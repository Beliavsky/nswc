subroutine cka (z, nu, w)
implicit none
integer :: i
real :: a, c, eps, u, v
real :: anorm
real :: spmpar
!-----------------------------------------------------------------------
!        Computation of the Bessel function K for real order nu
!        and complex argument z by the asymptotic expansion
!-----------------------------------------------------------------------
complex :: z
complex, intent(inout) :: w
real :: m
real, intent(in) :: nu
complex :: p, t, zr
!--------------------------
anorm(z) = amax1(abs(real(z)), abs(aimag(z)))
!--------------------------
!     c = pi**(1/2)
!--------------------------
data c /1.77245385090552/
!--------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0 .
!
                eps = spmpar(1)
!
!--------------------------
call crec (real(z), aimag(z), u, v)
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
   if (anorm(t) .le. eps*anorm(p)) go to 20
end do
!
20 p = p + 1.0
t = csqrt(zr)
if (aimag(z) .eq. 0.0) t = conjg(t)
w = c*t*p*cexp(-z)
return
end subroutine cka

subroutine ckm (z, r, zr, nu, w1, w2)
implicit none
real, intent(in) :: r
integer :: k
real :: a, ak, eps, eps0, g1, g2, gm1, gm2, phi, pi, t, tol, x, y
real :: anorm
real :: spmpar
real :: gam1
!-----------------------------------------------------------------------
!
!        Calculation of the modified Bessel functions
!
!                  w1 = k  (z)  AND  w2 = k    (z)
!                        nu                nu+1
!
!     FOR A COMPLEX ARGUMENT z WHERE abs(z) .LE. 2  AND A REAL
!     ORDER nu WHERE abs(nu) .LE. 0.5.  IT IS ASSUMED THAT
!     -pi .LT. ARG z .LE. pi, r = abs(z/2), AND zr = 2/z. POWER
!     series expansions are used.
!
!-----------------------------------------------------------------------
complex, intent(in) :: z, zr
complex, intent(inout) :: w1, w2
real, intent(in) :: nu
real :: d(7)
complex :: c, ch, cl, f, mu, p, q, sh, t1, t2, w
!-----------------------
data tol /1.e-10/
data pi /3.14159265358979/
!-----------------------
data d(1) / .577215664901533e+00/,  d(2) /-.420026350340952e-01/, &
&d(3) /-.421977345555443e-01/,  d(4) / .721894324666310e-02/, &
&d(5) /-.215241674114951e-03/,  d(6) /-.201348547807882e-04/, &
&d(7) / .113302723198170e-05/
!-----------------------
anorm(w) = amax1(abs(real(w)), abs(aimag(w)))
!-----------------------------------------------------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1 + eps .GT. 1.
!
                eps = spmpar(1)
!
!-----------------------------------------------------------------------
eps0 = amax1(eps, 5.e-15)
!
!                     cl = - ln(z/2)
!
phi = atan2(aimag(z),real(z))
cl = cmplx(-alog(r), -phi)
mu = nu*cl
c = cexp(mu)
!
!                   g1 = gamma(1 + nu)
!                   g2 = gamma(1 - nu)
!
t = pi*nu
if (abs(nu) .gt. tol) go to 10
   a = 1.0 + (t*t)/6.0
   go to 20
10 a = t/sin(t)
!
20 t = 0.5 + (0.5 + gam1(nu))
g1 = 1.0/t
g2 = a*t
gm2 = 0.5*(g1 + g2)
if (abs(nu) .gt. 0.2) go to 30
!
!         The following is the Taylor series for
!     t = (1/g2 - 1/g1)/(2*nu). NOTE THAT g1*g2 = a.
!
   t = nu*nu
   t = -((((((d(7)*t + d(6))*t + d(5))*t + d(4))*t + &
&d(3))*t + d(2))*t + d(1))
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
if (anorm(mu) .gt. tol) go to 50
   t = x*y
   sh = cmplx(1.0, t/3.0)
   ch = cmplx(1.0, t)
   go to 60
50 w = cmplx (-y, x)
sh = csin(w)/w
ch = ccos(w)
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
   if (anorm(t1) .le. eps0*anorm(w1)) go to 80
end do
!
80 w2 = w2 * zr
return
end subroutine ckm

subroutine ckml (z, r, zr, nu, k1, k2)
implicit none
real, intent(in) :: r
integer :: i, m
real :: a, al, b, c, c1, e, eps, eps0, th, x, y
real :: cos1
real :: spmpar
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
!     HALF PLANE. IT IS ASSUMED THAT abs(nu) .LT. 0.5, AND THAT
!     r = abs(z/2) AND zr = 2/z.
!
!-----------------------------------------------------------------------
complex, intent(in) :: z, zr
complex, intent(inout) :: k1, k2
complex :: bl, s, u1, u2, u3
real :: l
real, intent(in) :: nu
real :: nu2
!---------------------
!     c1 = sqrt(pi/2)
!---------------------
data c1/1.25331413731559/
!-----------------------------------------------------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1 + eps .GT. 1.
!
                eps = spmpar(1)
!
!-----------------------------------------------------------------------
eps0 = amax1(eps, 5.e-15)
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
m = (0.485/r)*(alog(c) + r*cos(a*th)/(1.0 + 0.008*r))**2/ &
&(2.0*cos(b*th))**2 + 1.5
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
   if (i .eq. m .or. c .lt. 1.e+6) go to 10
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
if (c .lt. 2.0) go to 20
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

complex function cxp (n, nu)
implicit none
integer, intent(in) :: n
integer :: k
real :: c, s
real :: sin0
real :: cos0
!-----------------------------------------------------------------------
!                 Computation of exp(-R*(PI/2)*I)
!              WHERE R = n + nu FOR abs(nu) .LE. 0.5
!-----------------------------------------------------------------------
real, intent(in) :: nu
!
c = cos0(nu)
s = sin0(nu)
k = mod(n,4)
if (k .eq. 0) go to 10
if (k .eq. 1) go to 20
if (k .eq. 2) go to 30
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

subroutine bsslk (mo, a, in, w)
implicit none
integer, intent(in) :: in, mo
integer :: i, la, lk, lr, m, n
real :: an, aq(2), az(2), cd(30), ce(30), pm, pn, qf(2), qm, qn, &
&rm, rn, rz(2), sl(2), sm(2), sn, sq(2), sr(2), ss, sz(2), tm(2), &
&ts(2), zl(2), zs
!     ******************************************************************
!     Fortran subroutine for modified Bessel function of integral order
!     ******************************************************************
!     mo = MODE OF OPERATION
!     a  = ARGUMENT (COMPLEX NUMBER)
!     in = order (integer)
!     w  = FUNCTION OF SECOND KIND (COMPLEX NUMBER)
!     -------------------
complex, intent(in) :: a
complex, intent(inout) :: w
data cd(1) / 0.00000000000000e00/,  cd(2) /-1.64899505142212e-2/, &
&cd(3) /-7.18621880068536e-2/,  cd(4) /-1.67086878124866e-1/, &
&cd(5) /-3.02582250219469e-1/,  cd(6) /-4.80613945245927e-1/, &
&cd(7) /-7.07075239357898e-1/,  cd(8) /-9.92995790539516e-1/, &
&cd(9) /-1.35583925612592e00/,  cd(10)/-1.82105907899132e00/, &
&cd(11)/-2.42482175310879e00/,  cd(12)/-3.21956655708750e00/, &
&cd(13)/-4.28658077248384e00/,  cd(14)/-5.77022816798128e00/, &
&cd(15)/-8.01371260952526e00/
data cd(16)/ 0.00000000000000e00/,  cd(17)/-5.57742429879505e-3/, &
&cd(18)/-4.99112944172476e-2/,  cd(19)/-1.37440911652397e-1/, &
&cd(20)/-2.67233784710566e-1/,  cd(21)/-4.40380166808682e-1/, &
&cd(22)/-6.61813614872541e-1/,  cd(23)/-9.41861077665017e-1/, &
&cd(24)/-1.29754130468326e00/,  cd(25)/-1.75407696719816e00/, &
&cd(26)/-2.34755299882276e00/,  cd(27)/-3.13041332689196e00/, &
&cd(28)/-4.18397120563729e00/,  cd(29)/-5.65251799214994e00/, &
&cd(30)/-7.87863959810677e00/
data ce(1) / 0.00000000000000e00/,  ce(2) /-4.80942336387447e-3/, &
&ce(3) /-1.31366200347759e-2/,  ce(4) /-1.94843834008458e-2/, &
&ce(5) /-2.19948900032003e-2/,  ce(6) /-2.09396625676519e-2/, &
&ce(7) /-1.74600268458650e-2/,  ce(8) /-1.27937813362085e-2/, &
&ce(9) /-8.05234421796592e-3/,  ce(10)/-4.15817375002760e-3/, &
&ce(11)/-1.64317738747922e-3/,  ce(12)/-4.49175585314709e-4/, &
&ce(13)/-7.28594765574007e-5/,  ce(14)/-5.38265230658285e-6/, &
&ce(15)/-9.93779048036289e-8/
data ce(16)/ 0.00000000000000e00/,  ce(17)/ 7.53805779200591e-2/, &
&ce(18)/ 7.12293537403464e-2/,  ce(19)/ 6.33116224228200e-2/, &
&ce(20)/ 5.28240264523301e-2/,  ce(21)/ 4.13305359441492e-2/, &
&ce(22)/ 3.01350573947510e-2/,  ce(23)/ 2.01043439592720e-2/, &
&ce(24)/ 1.18552223068074e-2/,  ce(25)/ 5.86055510956010e-3/, &
&ce(26)/ 2.25465148267325e-3/,  ce(27)/ 6.08173041536336e-4/, &
&ce(28)/ 9.84215550625747e-5/,  ce(29)/ 7.32139093038089e-6/, &
&ce(30)/ 1.37279667384666e-7/
!     -------------------
az(1)=real(a)
az(2)=aimag(a)
zs=az(1)*az(1)+az(2)*az(2)
zl(1)=0.5*alog(zs)
zl(2)=atan2(az(2),az(1))
an=iabs(in)
tm(1)=0.0
tm(2)=0.0
if(mo.ne.0)go to 002
tm(1)=az(1)
tm(2)=az(2)
002 if(zs-1.0)020,020,003
003 if(zs-289.0)004,010,010
004 if(az(1)+0.096*az(2)*az(2))020,020,015
010 qm=1.25331413731550*exp(-0.5*zl(1)-tm(1))
qf(1)=qm*cos(-0.5*zl(2)-tm(2))
qf(2)=qm*sin(-0.5*zl(2)-tm(2))
if(an.gt.1.0)go to 012
pn=an
assign 011 to la
go to 100
011 ts(1)=qf(1)*sm(1)-qf(2)*sm(2)
ts(2)=qf(1)*sm(2)+qf(2)*sm(1)
sm(1)=ts(1)
sm(2)=ts(2)
go to 029
012 pn=1.0
assign 013 to la
go to 100
013 sq(1)=qf(1)*sm(1)-qf(2)*sm(2)
sq(2)=qf(1)*sm(2)+qf(2)*sm(1)
pn=0.0
assign 014 to la
go to 100
014 sr(1)=qf(1)*sm(1)-qf(2)*sm(2)
sr(2)=qf(1)*sm(2)+qf(2)*sm(1)
go to 026
015 qm=1.25331413731550*exp(-0.5*zl(1)-tm(1))
qf(1)=qm*cos(-0.5*zl(2)-tm(2))
qf(2)=qm*sin(-0.5*zl(2)-tm(2))
if(an.gt.1.0)go to 017
pn=an
assign 016 to lr
go to 104
016 ts(1)=qf(1)*sm(1)-qf(2)*sm(2)
ts(2)=qf(1)*sm(2)+qf(2)*sm(1)
sm(1)=ts(1)
sm(2)=ts(2)
go to 029
017 pn=1.0
assign 018 to lr
go to 104
018 sq(1)=qf(1)*sm(1)-qf(2)*sm(2)
sq(2)=qf(1)*sm(2)+qf(2)*sm(1)
pn=0.0
assign 019 to lr
go to 104
019 sr(1)=qf(1)*sm(1)-qf(2)*sm(2)
sr(2)=qf(1)*sm(2)+qf(2)*sm(1)
go to 026
020 qf(1)=1.0
qf(2)=0.0
if(mo.eq.0)go to 021
qm=exp(az(1))
qf(1)=qm*cos(az(2))
qf(2)=qm*sin(az(2))
021 if(an.gt.1.0)go to 023
pn=an
assign 022 to lk
go to 106
022 ts(1)=qf(1)*sm(1)-qf(2)*sm(2)
ts(2)=qf(1)*sm(2)+qf(2)*sm(1)
sm(1)=ts(1)
sm(2)=ts(2)
go to 029
023 pn=1.0
assign 024 to lk
go to 106
024 sq(1)=qf(1)*sm(1)-qf(2)*sm(2)
sq(2)=qf(1)*sm(2)+qf(2)*sm(1)
pn=0.0
assign 025 to lk
go to 106
025 sr(1)=qf(1)*sm(1)-qf(2)*sm(2)
sr(2)=qf(1)*sm(2)+qf(2)*sm(1)
026 rz(1)=+az(1)/zs
rz(2)=-az(2)/zs
pn=0.0
go to 028
027 sq(1)=sr(1)
sq(2)=sr(2)
sr(1)=sm(1)
sr(2)=sm(2)
028 sm(1)=2.0*pn*(rz(1)*sr(1)-rz(2)*sr(2))+sq(1)
sm(2)=2.0*pn*(rz(1)*sr(2)+rz(2)*sr(1))+sq(2)
pn=pn+1.0
if(pn.lt.an)go to 027
029 w=cmplx(sm(1),sm(2))
return
100 sm(1)=0.0
sm(2)=0.0
rz(1)=+0.5*az(1)/zs
rz(2)=-0.5*az(2)/zs
qn=(pn-0.5)*(pn+0.5)
tm(1)=1.0
tm(2)=0.0
pm=0.0
go to 102
101 qn=qn-2.0*pm
pm=pm+1.0
ts(1)=rz(1)*tm(1)-rz(2)*tm(2)
ts(2)=rz(1)*tm(2)+rz(2)*tm(1)
tm(1)=qn*ts(1)/pm
tm(2)=qn*ts(2)/pm
if(abs(sm(1))+abs(tm(1)).ne.abs(sm(1)))go to 102
if(abs(sm(2))+abs(tm(2)).eq.abs(sm(2)))go to 103
102 sm(1)=sm(1)+tm(1)
sm(2)=sm(2)+tm(2)
if(pm.lt.36.0)go to 101
103 go to la,(011,013,014)
104 sm(1)=1.0
sm(2)=0.0
m=15.0*pn+2.0
n=15.0*pn+15.0
do 105 i = m,n
ts(1)=az(1)-cd(i)
ts(2)=az(2)
ss=ts(1)*ts(1)+ts(2)*ts(2)
tm(1)=+ce(i)*ts(1)/ss
tm(2)=-ce(i)*ts(2)/ss
sm(1)=sm(1)+tm(1)
sm(2)=sm(2)+tm(2)
105 continue
go to lr,(016,018,019)
106 aq(1)=1.0
aq(2)=0.0
rn=0.0
sn=-1.0
pm=0.0
go to 108
107 pm=pm+1.0
rn=rn+0.5/pm
sn=-sn
ts(1)=0.5*(az(1)*aq(1)-az(2)*aq(2))
ts(2)=0.5*(az(1)*aq(2)+az(2)*aq(1))
aq(1)=ts(1)/pm
aq(2)=ts(2)/pm
108 if(pm.lt.pn)go to 107
sz(1)=0.25*(az(1)-az(2))*(az(1)+az(2))
sz(2)=0.5*az(1)*az(2)
sr(1)=0.0
sr(2)=0.0
ss=aq(1)*aq(1)+aq(2)*aq(2)
tm(1)=+aq(1)/ss
tm(2)=-aq(2)/ss
pm=0.0
go to 110
109 tm(1)=tm(1)/(pn-pm)
tm(2)=tm(2)/(pn-pm)
sr(1)=sr(1)+0.5*tm(1)
sr(2)=sr(2)+0.5*tm(2)
pm=pm+1.0
ts(1)=sz(1)*tm(1)-sz(2)*tm(2)
ts(2)=sz(1)*tm(2)+sz(2)*tm(1)
tm(1)=-ts(1)/pm
tm(2)=-ts(2)/pm
110 if(pm.lt.pn)go to 109
sm(1)=0.0
sm(2)=0.0
rm=1.0
qm=0.0
aq(1)=sn*aq(1)
aq(2)=sn*aq(2)
sl(1)=-0.115931515658412+zl(1)-rn
sl(2)=+zl(2)
pm=0.0
go to 112
111 qm=qm+rm
pm=pm+1.0
rm=0.25*zs*rm/(pm*(pn+pm))
ts(1)=sz(1)*aq(1)-sz(2)*aq(2)
ts(2)=sz(1)*aq(2)+sz(2)*aq(1)
aq(1)=ts(1)/(pm*(pn+pm))
aq(2)=ts(2)/(pm*(pn+pm))
sl(1)=sl(1)-0.5/pm-0.5/(pn+pm)
112 tm(1)=aq(1)*sl(1)-aq(2)*sl(2)
tm(2)=aq(1)*sl(2)+aq(2)*sl(1)
sm(1)=sm(1)+tm(1)
sm(2)=sm(2)+tm(2)
if(qm+rm.gt.qm)go to 111
sm(1)=sr(1)+sm(1)
sm(2)=sr(2)+sm(2)
go to lk,(022,024,025)
end subroutine bsslk

subroutine cai(ind,z,ai,aip,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
real :: a, b, r
real :: cpabs
!------------------------------------------------------------
!     Calculates the Airy function ai and its derivative aip
!     for complex argument z.
!------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: ai
complex :: bi
complex, intent(inout) :: aip
complex :: bip
ierr = 0
a = real(z)
b = aimag(z)
r = cpabs(a,b)
if(r .gt. 1.0) go to 10
!
!     Maclaurin expansion
!
   call airm(ind,z,ai,aip,bi,bip)
   return
10 if(r .gt. 10.0) go to 20
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

subroutine airm (ind,z,ai,aip,bi,bip)
implicit none
integer, intent(in) :: ind
integer :: i, n
real :: c1, c2, sqt3, x, y
!--------------------------------------------------------------
!     Calculates the Airy functions ai and bi and their
!     derivatives aip and bip by use of their Maclaurin
!     expansions.
!--------------------------------------------------------------
complex, intent(inout) :: ai, aip, bi, bip
complex, intent(in) :: z
complex :: z1, z2, z3, zz, f, f1, g, g1, e, e1
real :: a(8), b(8), c(8), d(8)
!-----------------------
!     c1 = 3**(-2/3)/gamma(2/3)
!     c2 = 3**(-1/3)/gamma(1/3)
!-----------------------
data c1/3.55028053887817e-01/, c2/2.58819403792807e-01/, &
&sqt3/1.73205080756888e+00/
!-----------------------
data a(1) /.166666666666667e+00/, a(2) /.555555555555556e-02/, &
&a(3) /.771604938271605e-04/, a(4) /.584549195660307e-06/, &
&a(5) /.278356759838241e-08/, a(6) /.909662613850462e-11/, &
&a(7) /.216586336631062e-13/, a(8) /.392366551867867e-16/
data b(1) /.833333333333333e-01/, b(2) /.198412698412698e-02/, &
&b(3) /.220458553791887e-04/, b(4) /.141319585764030e-06/, &
&b(5) /.588831607350126e-09/, b(6) /.172172984605300e-11/, &
&b(7) /.372668797846970e-14/, b(8) /.621114663078283e-17/
data c(1) /.333333333333333e-01/, c(2) /.694444444444444e-03/, &
&c(3) /.701459034792368e-05/, c(4) /.417535139757362e-07/, &
&c(5) /.163739270493083e-09/, c(6) /.454831306925231e-12/, &
&c(7) /.941679724482880e-15/, c(8) /.150910212256872e-17/
data d(1) /.333333333333333e+00/, d(2) /.138888888888889e-01/, &
&d(3) /.220458553791887e-03/, d(4) /.183715461493239e-05/, &
&d(5) /.942130571760201e-08/, d(6) /.327128670750070e-10/, &
&d(7) /.819871355263333e-13/, d(8) /.155278665769571e-15/
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
if (ind .eq. 0) return
   x = real(z)
   y = aimag(z)
   z1 = csqrt(z)
   zz = z*z1/1.5
   e = cexp(zz)
   e1 = 1.0/e
   ai = ai*e
   aip = aip*e
   if (abs(y) .gt. x*sqt3) go to 30
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
real :: a, b, c1, r
real :: cpabs
!------------------------------------------------------------
!     Calculates the Airy function ai and its derivative aip
!     FOR COMPLEX ARGUMENT z IN THE INTERMEDIATE RANGE 1 .LE.
!     CABS(z) .LE. 10.0.
!------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: ai, aip
complex :: z1, z2, z3, zm, w1, w2, w1m, w2m, e
!
!     c1 = 1/(pi*sqrt(3))
!
data c1/1.83776298473931e-01/
ierr = 0
a = real(z)
b = aimag(z)
r = cpabs(a, b)
z1 = csqrt(z)
z2 = z1*z/1.5
if (abs(b) .lt. -5.0*a) go to 10
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
10 if (abs(b) .lt. -1.74*a) go to 30
   if (r .ge. 8.2) go to 40
20 zm = -z
   z1 = csqrt(zm)
   z3 = z1*zm/1.5
   call ja(z3, w1, w2, w1m, w2m)
   ai = (z1/3.0)*(w1m +w1)
   aip = (z/3.0)*(w2m - w2)
   if (ind .eq. 0) return
      e = cexp(z2)
      ai = ai*e
      aip = aip*e
      return
30 if (r .lt. 7.4) go to 20
40 call aia (ind,z,ai,aip,ierr)
return
end subroutine aii

subroutine aia (ind, z, ai, aip, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
integer :: i, k, m, m2
real :: c1, c2, eps, r, t, u, u1, v, v1, xm, xneg, xpos
real :: exparg
real :: spmpar
!-----------------------------------------------------------------------
!     Calculates the Airy function ai and its derivative aip for
!     complex argument z by means of asymptotic expansions.
!-----------------------------------------------------------------------
complex, intent(inout) :: ai, aip
complex, intent(in) :: z
complex :: z1, z2, z2r, zz, w, w2, s1, s2, s3, s4, e, zeta, si, cn
complex :: alpha, beta, j
real :: c(30), d(30)
!------------------------
data c(1)  /.100000000000000e+01/, c(2)  /.694444444444444e-01/, &
&c(3)  /.371334876543210e-01/, c(4)  /.379930591278006e-01/, &
&c(5)  /.576491904126697e-01/, c(6)  /.116099064025515e+00/, &
&c(7)  /.291591399230751e+00/, c(8)  /.877666969510017e+00/, &
&c(9)  /.307945303017317e+01/, c(10) /.123415733323452e+02/, &
&c(11) /.556227853659171e+02/, c(12) /.278465080777603e+03/, &
&c(13) /.153316943201280e+04/, c(14) /.920720659972641e+04/, &
&c(15) /.598925135658791e+05/, c(16) /.419524875116551e+06/, &
&c(17) /.314825741786683e+07/, c(18) /.251989198716024e+08/, &
&c(19) /.214288036963680e+09/, c(20) /.192937554918249e+10/
data c(21) /.183357669378906e+11/, c(22) /.183418303528833e+12/, &
&c(23) /.192647115897045e+13/, c(24) /.211969993886476e+14/, &
&c(25) /.243826826879716e+15/, c(26) /.292659921929793e+16/, &
&c(27) /.365903070126431e+17/, c(28) /.475768102036307e+18/, &
&c(29) /.642404935790194e+19/, c(30) /.899520742705838e+20/
!------------------------
data d(1)  / .100000000000000e+01/, d(2)  /-.972222222222222e-01/, &
&d(3)  /-.438850308641975e-01/, d(4)  /-.424628307898948e-01/, &
&d(5)  /-.626621634920323e-01/, d(6)  /-.124105896027275e+00/, &
&d(7)  /-.308253764901079e+00/, d(8)  /-.920479992412945e+00/, &
&d(9)  /-.321049358464862e+01/, d(10) /-.128072930807356e+02/, &
&d(11) /-.575083035139143e+02/, d(12) /-.287033237109221e+03/, &
&d(13) /-.157635730333710e+04/, d(14) /-.944635482309593e+04/, &
&d(15) /-.613357066638521e+05/, d(16) /-.428952400400069e+06/, &
&d(17) /-.321453652140086e+07/, d(18) /-.256979083839113e+08/, &
&d(19) /-.218293420832160e+09/, d(20) /-.196352378899103e+10/
data d(21) /-.186439310881072e+11/, d(22) /-.186352996385294e+12/, &
&d(23) /-.195588293238984e+13/, d(24) /-.215064446351972e+14/, &
&d(25) /-.247236992290621e+15/, d(26) /-.296588243029521e+16/, &
&d(27) /-.370624400063547e+17/, d(28) /-.481678264794522e+18/, &
&d(29) /-.650098408075106e+19/, d(30) /-.909919826436541e+20/
!------------------------
!     c1 = pi**(-1/2)
!     c2 = (2*pi)**(-1/2)
!------------------------
data c1 /.564189583547756/
data c2 /.398942280401433/
!------------------------
!
!     Eps, xpos, and xneg are machine dependent constants. Eps is
!     THE SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0, XPOS IS THE
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
if (real(z) .lt. 0.0) go to 30
!
!             -----   real(z) .GE. 0    -----
!
z1 = csqrt(z)
z2 = csqrt(z1)
z2r = 1.0/z2
call crec (real(z), aimag(z), u, v)
w = -1.5*cmplx(u,v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = amax1(u,v)
if (ind .ne. 0) go to 10
!
   if (t .eq. 0.0) go to 90
   u1 = u/t
   v1 = v/t
   r = u*u1 + v*v1
   xm = xpos
   if (real(w) .lt. 0.0) xm = -xneg
   if (u1 .ge. r*xm .or. v1 .ge. 0.1*r/eps) go to 90
   zeta = z1*z/1.5
   e = cexp(-zeta)
!
10 m = 20
if (t .gt. 30.0) m = 8
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
if (ind .ne. 0) return
ai = e*ai
aip = e*aip
return
!
!             -----   real(z) .LT. 0    -----
!
30 zz = -z
z1 = csqrt(zz)
z2 = csqrt(z1)
z2r = 1.0/z2
call crec (real(zz), aimag(zz), u, v)
w = 1.5*cmplx(u,v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = amax1(u,v)
!
   if (t .eq. 0.0) go to 90
   u1 = u/t
   v1 = v/t
   r = u*u1 + v*v1
   if (ind .ne. 0) go to 40
      if (v1 .ge. r*xpos .or. u1 .ge. 0.1*r/eps) go to 90
      zeta = z1*zz/1.5
      go to 50
40 e = (0.0, 0.0)
   j = (0.0, -1.0)
   if (aimag(z) .lt. 0.0) j = (0.0, 1.0)
   if (v1 .gt. 0.5*r*abs(xneg)) go to 50
   if (u1 .ge. 0.05*r/eps) go to 90
   zeta = z1*zz/1.5
   e = cexp(2.0*j*zeta)
!
50 w2 =  w*w
m = 15
if (t .gt. 30.0) m = 5
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
if (ind .ne. 0) go to 70
   cn = ccos(zeta)
   si = csin(zeta)
   go to 80
70 cn = 0.5*(1.0 + e)
si = 0.5*(1.0 - e)*j
!
80 alpha = s1 - s2
beta  = s1 + s2
ai = c2*z2r*(alpha*cn + beta*si)
alpha = s3 - s4
beta  = s3 + s4
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
real :: a, b, r
real :: cpabs
!------------------------------------------------------------
!     Calculates the Airy function bi and its derivative bip
!     for complex argument z.
!------------------------------------------------------------
complex, intent(in) :: z
complex :: ai
complex, intent(inout) :: bi
complex :: aip
complex, intent(inout) :: bip
ierr = 0
a = real(z)
b = aimag(z)
r = cpabs(a,b)
if(r .gt. 1.0) go to 10
!
!     Maclaurin expansion
!
   call airm(ind,z,ai,aip,bi,bip)
   return
10 if(r .gt. 9.6) go to 20
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
real :: a, c1, r, sqt3, x, y
real :: cpabs
!------------------------------------------------------------
!     Calculates the Airy function bi and its derivative bip
!     FOR COMPLEX ARGUMENT z IN THE INTERMEDIATE RANGE 1 .LE.
!     CABS(z) .LE. 10.0.
!------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: bi, bip
complex :: z1, z2, zm, w1, w2, w1m, w2m, e, e1
!
!     c1 = 1/sqrt(3)
!     sqt3 = sqrt(3)
!
data c1/5.77350269189626e-01/
data sqt3/1.73205080756888e+00/
!
ierr = 0
x = real(z)
y = aimag(z)
r = cpabs(x, y)
z1 = csqrt(z)
z2 = z1*z/1.5
e = cexp(-z2)
e1 = 1.0/e
if(real(z) .lt. 0.0) go to 10
!
!               ----  real(z) .GE. 0  ----
!
if (r .lt. 8.9) go to 5
a = 0.156*r - 0.913
if (abs(y) .lt. a*x .or. abs(y) .gt. 0.58*x) go to 40
5 call ia(z2, w1, w2, w1m, w2m)
   bi = c1*z1*(w1 + w1m)
   bip = c1*z*(w2 + w2m)
   if (ind .eq. 0) return
   go to 20
!
!               ----  real(z) .LT. 0  ----
!
10 if (r .lt. 8.1) go to 15
if (abs(y) .lt. 3.89*abs(x)) go to 40
15 zm = -z
   z1 = csqrt(zm)
   z2 = z1*zm/1.5
   call ja(z2, w1, w2, w1m, w2m)
   bi = c1*z1*(w1m -w1)
   bip = c1*zm*(w2m + w2)
   if (ind .eq. 0) return
20 if (x .ge. c1*abs(y)) go to 30
      bi = bi*e1
      bip = bip*e1
      return
30 bi = bi*e
   bip = bip*e
   return
40 call bia(ind, z, bi, bip, ierr)
return
end subroutine bii

subroutine bia(ind,z,bi,bip,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
integer :: i, k, m, m2
real :: c(30), c1, c2, c3, ce, cf, d(30), eps, r, s, sqt3, t, u, &
&u1, v, v1, x, xneg, xpos, y
real :: exparg
real :: spmpar
!---------------------------------------------------------------
!     Calculates the Airy function bi and its derivative bip for
!     complex argument z by means of asymptotic expansions.
!---------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: bi, bip
complex :: z1, z2, z2r, zz, w, w2, s1, s2, s3, s4, e, zeta, si, &
&cn, cf1, cf2, ex3c, ex6, ex6c, cln2, alpha, beta, j, cz
!------------------------
data c(1)  /.100000000000000e+01/, c(2)  /.694444444444444e-01/, &
&c(3)  /.371334876543210e-01/, c(4)  /.379930591278006e-01/, &
&c(5)  /.576491904126697e-01/, c(6)  /.116099064025515e+00/, &
&c(7)  /.291591399230751e+00/, c(8)  /.877666969510017e+00/, &
&c(9)  /.307945303017317e+01/, c(10) /.123415733323452e+02/, &
&c(11) /.556227853659171e+02/, c(12) /.278465080777603e+03/, &
&c(13) /.153316943201280e+04/, c(14) /.920720659972641e+04/, &
&c(15) /.598925135658791e+05/, c(16) /.419524875116551e+06/, &
&c(17) /.314825741786683e+07/, c(18) /.251989198716024e+08/, &
&c(19) /.214288036963680e+09/, c(20) /.192937554918249e+10/
data c(21) /.183357669378906e+11/, c(22) /.183418303528833e+12/, &
&c(23) /.192647115897045e+13/, c(24) /.211969993886476e+14/, &
&c(25) /.243826826879716e+15/, c(26) /.292659921929793e+16/, &
&c(27) /.365903070126431e+17/, c(28) /.475768102036307e+18/, &
&c(29) /.642404935790194e+19/, c(30) /.899520742705838e+20/
!------------------------
data d(1)  / .100000000000000e+01/, d(2)  /-.972222222222222e-01/, &
&d(3)  /-.438850308641975e-01/, d(4)  /-.424628307898948e-01/, &
&d(5)  /-.626621634920323e-01/, d(6)  /-.124105896027275e+00/, &
&d(7)  /-.308253764901079e+00/, d(8)  /-.920479992412945e+00/, &
&d(9)  /-.321049358464862e+01/, d(10) /-.128072930807356e+02/, &
&d(11) /-.575083035139143e+02/, d(12) /-.287033237109221e+03/, &
&d(13) /-.157635730333710e+04/, d(14) /-.944635482309593e+04/, &
&d(15) /-.613357066638521e+05/, d(16) /-.428952400400069e+06/, &
&d(17) /-.321453652140086e+07/, d(18) /-.256979083839113e+08/, &
&d(19) /-.218293420832160e+09/, d(20) /-.196352378899103e+10/
data d(21) /-.186439310881072e+11/, d(22) /-.186352996385294e+12/, &
&d(23) /-.195588293238984e+13/, d(24) /-.215064446351972e+14/, &
&d(25) /-.247236992290621e+15/, d(26) /-.296588243029521e+16/, &
&d(27) /-.370624400063547e+17/, d(28) /-.481678264794522e+18/, &
&d(29) /-.650098408075106e+19/, d(30) /-.909919826436541e+20/
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
data sqt3/1.73205080756888/
data ex3c/(5.e-01, -8.66025403784439e-01)/
data ex6/(8.66025403784439e-01, 5.e-01)/
data ex6c/(8.66025403784439e-01, -5.e-01)/
data cln2/(0.0, 3.46573590279973e-01)/
data c1/5.64189583547756e-01/
data c2/3.98942280401433e-01/
data c3/7.07106781186548e-01/
!--------------------------
!
!     Eps and XM are machine dependent constants. Eps is the
!     SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0, XPOS IS THE
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
if (x .lt. abs(y)*sqt3) go to 30
!
!          -----  abs(ARG(z)) .LE. PI/6  ----
!
z1 = csqrt(z)
z2 = csqrt(z1)
z2r = 1.0/z2
call crec(x, y, u, v)
w = 1.5*cmplx(u, v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = amax1(u, v)
if (ind .ne. 0) go to 10
   if (t .eq. 0.0) go to 90
      u1 = u/t
      v1 = v/t
      r = u*u1 + v*v1
      if (u1 .ge. r*xpos .or. v1 .ge. 0.1*r/eps) go to 90
         zeta = z1*z/1.5
         e = cexp(zeta)
!
10 m = 20
t = amax1(x, abs(y))
if (t .gt. 30.0) m = 8
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
if (ind .ne. 0) return
   bi = e*bi
   bip = e*bip
   return
30 if (x .lt. 0.0) go to 50
!
!          ----  PI/6 .LT. abs(ARG(z)) .LE. PI/2  ----
!
cz = z
if (y .lt. 0.0) cz = conjg(cz)
zz = cz*ex3c
z1 = csqrt(zz)
z2 = csqrt(z1)
z2r = 1.0/z2
cf1 = c1*z2r*ex6
cf2 = c1*z2*ex6c
call crec(real(zz), aimag(zz), u, v)
w = 1.5*cmplx(u, v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = amax1(u, v)
!
if (t .eq. 0.0) go to 90
   u1 = u/t
   v1 = v/t
   r = u*u1 + v*v1
   if (ind .ne. 0) go to 40
      if (v1 .ge. r*xpos .or. u1 .ge. 0.1*r/eps) go to 90
         zeta = z1*zz/1.5
         cn = ccos(zeta - cln2)
         si = csin(zeta - cln2)
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
   if (aimag(zz) .le. 0.0) go to 44
      s = -1.0
      ce = 0.5
      cf = 2.0
44 if (v1 .ge. 0.5*r*abs(xneg)) go to 45
   if (u1 .ge. 0.05*r/eps) go to 90
   zeta = z1*zz/1.5
   e = cf*cexp(2.0*s*j*zeta)
45 cn = ce*c3*(1 + e)
   si = ce*s*c3*(1 - e)*j
   go to 70
!
!                  ----  real(z) .LT. 0  ----
!
50 zz = -z
if (y .lt. 0.0) zz = conjg(zz)
z1 = csqrt(zz)
z2 = csqrt(z1)
z2r = 1.0/z2
cf1 = c2*z2r
cf2 = c2*z2
call crec(real(zz), aimag(zz), u, v)
w = 1.5*cmplx(u, v)/z1
u = abs(real(w))
v = abs(aimag(w))
t = amax1(u, v)
!
if (t .eq. 0.0) go to 90
   u1 = u/t
   v1 = v/t
   r = u*u1 + v*v1
   if (ind .ne. 0) go to 60
      if (v1 .ge. r*xpos .or. u1 .ge. 0.1*r/eps) go to 90
         zeta = z1*zz/1.5
         cn = ccos(zeta)
         si = csin(zeta)
         go to 70
60 e = (0.0, 0.0)
   j = (0.0, -1.0)
   if (v1 .ge. 0.5*r*abs(xneg)) go to 65
   if (u1 .ge. 0.05*r/eps) go to 90
   zeta = z1*zz/1.5
   e = cexp(2.0*j*zeta)
65 cn = 0.5*(1.0 + e)
   si = 0.5*(1.0 - e)*j
!
70 w2 = w*w
m = 15
t = amax1(abs(x), abs(y))
if (t .gt. 30.0) m = 5
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
   if (x .ge. 0.0) go to 81
      alpha = s1 + s2
      beta = s2 - s1
      go to 82
81 alpha = s1 - s2
   beta = s1 + s2
82 bi = cf1*(alpha*cn + beta*si)
   if (x .ge. 0.0) go to 83
      alpha = s3 - s4
      beta = s3 + s4
      go to 84
83 alpha = s3 + s4
   beta = s4 - s3
84 bip = cf2*(alpha*cn + beta*si)
   if (y .ge. 0.0) return
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
!     ARGUMENT z, WHERE -PI .LT. ARG(z) .LE. PI.  i1 AND i2
!     are replaced by the functions of orders 1/3 and 2/3,
!     respectively, and i1m and i2m by the functions of orders
!     -1/3 and -2/3, respectively.
!-------------------------------------------------------------
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
complex :: cz, ex13, ex13c, ex23, ex23c
!
!     ex13 = exp(i*pi/3)
!     ex13c = exp(-i*pi/3)
!     ex23 = exp(2*i*pi/3)
!     ex23c = exp(-2*i*pi/3)
!
data ex13/(5.0e-01, 8.66025403784439e-01)/
data ex13c/(5.0e-01, -8.66025403784439e-01)/
data ex23/(-5.0e-01, 8.66025403784439e-01)/
data ex23c/(-5.0e-01, -8.66025403784439e-01)/
if(real(z) .ge. 0.0) go to 20
   cz = -z
!
!     CALCULATION OF i1, i2, i1m, AND i2m WHEN real(cz) .GT. 0.
!
   call imc(cz, i1, i2, i1m, i2m)
!
!     Final assembly
!
   if(aimag(z) .lt. 0.0) go to 10
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
integer :: i, n, n1
real :: a, an, b, c1, c2, cfa, cfb, cn1, cn2, gm1, gm2
!----------------------------------------------------------------
!     Calculates the modified Bessel function of the first
!     kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!     argument z. the Maclaurin expansion and backward recurrence
!     are used. i1 and i2 are replaced by the functions of orders
!     1/3 and 2/3, respectively, and i1m and i2m by the functions
!     of orders -1/3 and -2/3, respectively.  For greatest
!     ACCURACY, z SHOULD LIE IN THE REGION real(z) .GE. 0.
!----------------------------------------------------------------
complex :: z, ia1, ia2, ia3, ib1, ib2, ib3
complex, intent(inout) :: i1, i2, i1m, i2m
complex :: sz, zh, e, cf1, cf2, cf3, cf4
real :: m
!
!     gm1 = gamma(4.0/3.0)
!     gm2 = gamma(5.0/3.0)
!
data c1/.333333333333333e+00/
data c2/.666666666666667e+00/
data gm1/.892979511569248e+00/
data gm2/.902745292950932e+00/
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
e = cexp(c1*clog(zh))
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
real :: d, eps
real :: anorm
real :: spmpar
!-------------------------------------------------------------
!     Calculates the modified Bessel function of the first kind
!     FOR REAL ORDER cn .GT. -1 AND COMPLEX ARGUMENT z BY MEANS
!     of the Maclaurin expansion.  w is replaced by the
!     calculated value.
!-------------------------------------------------------------
real :: m
complex :: z
complex, intent(inout) :: w
complex :: sz, t
!------------------
anorm(z) = amax1(abs(real(z)),abs(aimag(z)))
!-------------------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the smallest
!     NUMBER SUCH THAT 1 + eps .GT. 1.
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
   if(anorm(t) .gt. eps*anorm(w)) go to 10
!
w = w + 1.0
return
end subroutine bim

subroutine ja(z, i1, i2, i1m, i2m)
implicit none
!------------------------------------------------------------
!     Calculates the Bessel function of the first kind for
!     orders 1/3, 2/3, -1/3, and -2/3 and for complex argument
!     z, WHERE -PI .LT. ARG(z) .LE. PI.  i1 AND i2 ARE REPLACED
!     by the functions of orders 1/3 and 2/3, respectively, and
!     i1m and i2m by functions of orders -1/3 and -2/3,
!     respectively.
!--------------------------------------------------------------
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
complex :: cz, ex13, ex13c, ex23, ex23c
!
!     ex13 = exp(i*pi/3)
!     ex13c = exp(-i*pi/3)
!     ex23 = exp(2*i*pi/3)
!     ex23c = exp(-2*i*pi/3)
!
data ex13/(5.0e-01, 8.66025403784439e-01)/
data ex13c/(5.0e-01, -8.66025403784439e-01)/
data ex23/(-5.0e-01, 8.66025403784439e-01)/
data ex23c/(-5.0e-01, -8.66025403784439e-01)/
if(real(z) .ge. 0.0) go to 20
   cz = -z
!
!     CALCULATION OF i1, i2, i1m, AND i2m WHEN real(cz) .GT. 0.0
!
   call jmc(cz, i1, i2, i1m, i2m)
!
!     Final assembly
!
   if(aimag(z) .lt. 0.0) go to 10
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
integer :: i, n, n1
real :: a, an, b, c1, c2, cfa, cfb, cn1, cn2, gm1, gm2
!----------------------------------------------------------------
!     Calculates the Bessel function of the first
!     kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!     argument z. the Maclaurin expansion and backward recurrence
!     are used. i1 and i2 are replaced by the functions of orders
!     1/3 and 2/3, respectively, and i1m and i2m by the functions
!     of orders -1/3 and -2/3, respectively.  For greatest
!     ACCURACY, z SHOULD LIE IN THE REGION real(z) .GE. 0.
!----------------------------------------------------------------
complex :: z, ia1, ia2, ia3, ib1, ib2, ib3
complex, intent(inout) :: i1, i2, i1m, i2m
complex :: sz, zh, e, cf1, cf2, cf3, cf4
real :: m
!
!     gm1 = gamma(4.0/3.0)
!     gm2 = gamma(5.0/3.0)
!
data c1/.333333333333333e+00/
data c2/.666666666666667e+00/
data gm1/.892979511569248e+00/
data gm2/.902745292950932e+00/
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
e = cexp(c1*clog(zh))
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
real :: d, eps
real :: anorm
real :: spmpar
!-------------------------------------------------------------
!     Calculates the Bessel function of the first kind
!     FOR REAL ORDER cn .GT. -1 AND COMPLEX ARGUMENT z BY MEANS
!     of the Maclaurin expansion.  w is replaced by the
!     calculated value.
!-------------------------------------------------------------
real :: m
complex :: z
complex, intent(inout) :: w
complex :: sz, t
!------------------
anorm(z) = amax1(abs(real(z)),abs(aimag(z)))
!-------------------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the smallest
!     NUMBER SUCH THAT 1 + eps .GT. 1.
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
   if(anorm(t) .gt. eps*anorm(w)) go to 10
!
w = w + 1.0
return
end subroutine bjm

subroutine ka(ind, z, k1, k2)
implicit none
integer, intent(in) :: ind
integer :: ind1
real :: a, b, pi
!------------------------------------------------------------
!     Calculates the modified Bessel function of the second
!     kind for orders 1/3 and 2/3 and for complex argument z,
!     WHERE -pi .LT. ARG(z) .LE pi.  k1 IS REPLACED BY THE
!     function of order 1/3, and k2 by the function of order
!     2/3.
!------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: k1, k2
complex :: i1, i2, i1m, i2m, cz, ex13c, ex23c, j, e
!
!     ex13c = exp(-pi*i/3)
!     ex23c = exp(-2*pi*i/3)
!
data pi/3.14159265358979e+00/
data ex13c/(5.0e-01, -8.66025403784439e-01)/
data ex23c/(-5.0e-01, -8.66025403784439e-01)/
data j/(0.0, 1.0)/
a = real(z)
b = aimag(z)
if (abs(b) .lt. -0.5*a) go to 10
!
!            ----  abs(b) .GE. -0.5*a  ----
!
   call kml(ind, z, k1, k2)
   return
!
!            ----  abs(b) .LT. -0.5*a  ----
!
10 cz = -z
   if(aimag(z) .lt. 0.0) cz = conjg(cz)
   ind1 = 0
   call kml(ind1, cz, k1, k2)
   call imc(cz, i1, i2, i1m, i2m)
   k1 = ex13c*k1 - j*pi*i1
   k2 = ex23c*k2 - j*pi*i2
   if (ind .eq. 0) go to 20
   e = cexp(z)
   k1 = k1*e
   k2 = k2*e
20 if(aimag(z) .ge. 0.0) return
      k1 = conjg(k1)
      k2 = conjg(k2)
      return
end subroutine ka

subroutine kml(ind, z, k1, k2)
implicit none
integer, intent(in) :: ind
integer :: i, l, m
real :: a, ai, al, b, c, c1, eps, r, th, x1, x2
real :: spmpar
!------------------------------------------------------------
!     Calculates the modified Bessel function of the second
!     kind for orders 1/3 and 2/3 and for complex argument z
!     by use of the Miller algorithm.  k1 is replaced by the
!     function of order 1/3, and k2 by the function of order
!     2/3.  For greatest accuracy, z should lie in the region
!     real(z) .GE. 0.
!------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: k1, k2
complex :: bi, u1, u2, u3, s, e
!
!     c1 = sqrt(pi/2)
!
data c1/1.25331413731550e+00/
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
m = (0.485/r)*(alog(c) + r*cos(a*th)/(1.0 + 0.008*r))**2/ &
&(2.0*cos(b*th))**2 + 1.5
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
k1 = c1*u1/(s*csqrt(z))
k2 = k1*(z  + 1.0/6.0 - u2/u1)/z
if (ind .ne. 0) return
   e = cexp(-z)
   k1 = k1*e
   k2 = k2*e
   return
end subroutine kml

real function ai(x)
implicit none
real, intent(in) :: x
integer :: n, n2
real :: ad0, ad1, ad2, ad3, an0, an1, an2, an3, an4, an5, an6, &
&an7, an8, an9, bd0, bd1, bd2, bd3, bd4, bd5, bn0, bn1, bn2, bn3, &
&bn4, bn5, bn6, bn7, c, pd0, pd1, pd2, pd3, pd4, pd5, phi, pn0, &
&pn1, pn2, pn3, pn4, qd0, qd1, qd2, qd3, qd4, qd5, qn0, qn1, qn2, &
&qn3, qn4, qn5, r, rd0, rd1, rd2, rd3, rd4, rd5, rn0, rn1, rn2, &
&rn3, rn4, rtx, t, w, x0
real :: exparg
!-----------------------------------------------------------------------
!     Evaluation of the Airy function ai(x)
!-----------------------------------------------------------------------
!     x0 = 2**(2/3)
!     c = exp(2/3)
!-----------------------
data x0/1.58740105196820/
data c /1.94773404105468/
!-----------------------
data an0/ .355028053887818e+00/, an1/-.187394912983414e+00/, &
&an2/-.383735973881972e-01/, an3/ .491952571236878e-01/, &
&an4/-.967017625191329e-02/, an5/-.205648610308316e-02/, &
&an6/ .114176040526844e-02/, an7/-.117114823456866e-03/, &
&an8/-.270165470074755e-04/, an9/ .789002965889206e-05/
data ad0/ .100000000000000e+01/, ad1/ .201179850513612e+00/, &
&ad2/ .385762517106249e-01/, ad3/ .230887443780120e-04/
!-----------------------
data bn0/ .355028053887817e+00/, bn1/-.997169317338190e-01/, &
&bn2/-.602216060213075e-01/, bn3/ .297705337630730e-01/, &
&bn4/-.152969932286570e-02/, bn5/-.147868368189372e-02/, &
&bn6/ .350518617006107e-03/, bn7/-.257766924610873e-04/
data bd0/.100000000000000e+01/, bd1/.448140563306831e+00/, &
&bd2/.157074537566686e+00/, bd3/.316964519364865e-01/, &
&bd4/.485922740843953e-02/, bd5/.423326964456309e-03/
!-----------------------
data pn0/.282094378896566e+00/, pn1/.807868561687271e-01/, &
&pn2/.630644564152247e-02/, pn3/.147116711467936e-03/, &
&pn4/.750490748341483e-06/
data pd0/.100000000000000e+01/, pd1/.292890323271551e+00/, &
&pd2/.239376862143358e-01/, pd3/.612353984250624e-03/, &
&pd4/.384461189764830e-05/, pd5/.123247804102182e-08/
!-----------------------
data qn0/.282094791017188e+00/, qn1/.149585822742689e+00/, &
&qn2/.241876418864958e-01/, qn3/.138190913282142e-02/, &
&qn4/.241862862465003e-04/, qn5/.709733720554615e-07/
data qd0/.100000000000000e+01/, qd1/.536778341756648e+00/, &
&qd2/.889112579703465e-01/, qd3/.533368703697049e-02/, &
&qd4/.103812739863315e-03/, qd5/.408838544650398e-06/
!-----------------------
data rn0/.282094791773878e+00/, rn1/.203731967781874e+00/, &
&rn2/.436660479870037e-01/, rn3/.306595563073142e-02/, &
&rn4/.517398800281618e-04/
data rd0/.100000000000000e+01/, rd1/.728721438361672e+00/, &
&rd2/.159210021472267e+00/, rd3/.116985268534248e-01/, &
&rd4/.225973894323078e-03/, rd5/.232707159780478e-06/
!-----------------------------------------------------------------------
if (x .ge. -1.0) go to 10
call aimp (-x, r, phi)
ai = r*sin(phi)
return
!
10 if (x .ge. 0.0) go to 20
ai = (((((((((an9*x + an8)*x + an7)*x + an6)*x + an5)*x &
&+ an4)*x + an3)*x + an2)*x + an1)*x + an0) / &
&(((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x .ge. 1.0) go to 30
ai = (((((((bn7*x + bn6)*x + bn5)*x + bn4)*x + bn3)*x + bn2)*x &
&+ bn1)*x + bn0) / &
&(((((bd5*x + bd4)*x + bd3)*x + bd2)*x + bd1)*x + bd0)
return
!
30 rtx = sqrt(x)
if (x .gt. x0) go to 40
t = 16.0/(x*rtx)
w = ((((pn4*t + pn3)*t + pn2)*t + pn1)*t + pn0) / &
&(((((pd5*t + pd4)*t + pd3)*t + pd2)*t + pd1)*t + pd0)
ai = (w/sqrt(rtx)) * exp(-2.0*x*rtx/3.0)
return
!
40 if (x .gt. 4.0d0) go to 50
t = 16.0/(x*rtx)
w = (((((qn5*t + qn4)*t + qn3)*t + qn2)*t + qn1)*t + qn0) / &
&(((((qd5*t + qd4)*t + qd3)*t + qd2)*t + qd1)*t + qd0)
ai = (w/sqrt(rtx)) * exp(-2.0*x*rtx/3.0)
return
!
50 if (x*rtx .gt. 1.5*exparg(0)) go to 60
t = 16.0/(x*rtx)
w = ((((rn4*t + rn3)*t + rn2)*t + rn1)*t + rn0) / &
&(((((rd5*t + rd4)*t + rd3)*t + rd2)*t + rd1)*t + rd0)
n = rtx
n2 = n*n
t = (x - n2)/(rtx + n)
ai = ((w/sqrt(rtx)) / c**(n2*n)) * exp(-2.0*t*(n*rtx + t*t/3.0))
return
!
60 ai = 0.0
return
end function ai

real function aie(x)
implicit none
real, intent(in) :: x
real :: ad0, ad1, ad2, ad3, an0, an1, an2, an3, an4, an5, an6, &
&an7, an8, an9, bd0, bd1, bd2, bd3, bd4, bd5, bn0, bn1, bn2, bn3, &
&bn4, bn5, bn6, bn7, pd0, pd1, pd2, pd3, pd4, pd5, phi, pn0, pn1, &
&pn2, pn3, pn4, qd0, qd1, qd2, qd3, qd4, qd5, qn0, qn1, qn2, qn3, &
&qn4, qn5, r, rd0, rd1, rd2, rd3, rd4, rd5, rn0, rn1, rn2, rn3, &
&rn4, rtx, t, w, x0
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
data x0/.158740105196820e+01/
!-----------------------
data an0/ .355028053887818e+00/, an1/-.187394912983414e+00/, &
&an2/-.383735973881972e-01/, an3/ .491952571236878e-01/, &
&an4/-.967017625191329e-02/, an5/-.205648610308316e-02/, &
&an6/ .114176040526844e-02/, an7/-.117114823456866e-03/, &
&an8/-.270165470074755e-04/, an9/ .789002965889206e-05/
data ad0/ .100000000000000e+01/, ad1/ .201179850513612e+00/, &
&ad2/ .385762517106249e-01/, ad3/ .230887443780120e-04/
!-----------------------
data bn0/ .355028053887817e+00/, bn1/-.997169317338190e-01/, &
&bn2/-.602216060213075e-01/, bn3/ .297705337630730e-01/, &
&bn4/-.152969932286570e-02/, bn5/-.147868368189372e-02/, &
&bn6/ .350518617006107e-03/, bn7/-.257766924610873e-04/
data bd0/.100000000000000e+01/, bd1/.448140563306831e+00/, &
&bd2/.157074537566686e+00/, bd3/.316964519364865e-01/, &
&bd4/.485922740843953e-02/, bd5/.423326964456309e-03/
!-----------------------
data pn0/.282094378896566e+00/, pn1/.807868561687271e-01/, &
&pn2/.630644564152247e-02/, pn3/.147116711467936e-03/, &
&pn4/.750490748341483e-06/
data pd0/.100000000000000e+01/, pd1/.292890323271551e+00/, &
&pd2/.239376862143358e-01/, pd3/.612353984250624e-03/, &
&pd4/.384461189764830e-05/, pd5/.123247804102182e-08/
!-----------------------
data qn0/.282094791017188e+00/, qn1/.149585822742689e+00/, &
&qn2/.241876418864958e-01/, qn3/.138190913282142e-02/, &
&qn4/.241862862465003e-04/, qn5/.709733720554615e-07/
data qd0/.100000000000000e+01/, qd1/.536778341756648e+00/, &
&qd2/.889112579703465e-01/, qd3/.533368703697049e-02/, &
&qd4/.103812739863315e-03/, qd5/.408838544650398e-06/
!-----------------------
data rn0/.282094791773878e+00/, rn1/.203731967781874e+00/, &
&rn2/.436660479870037e-01/, rn3/.306595563073142e-02/, &
&rn4/.517398800281618e-04/
data rd0/.100000000000000e+01/, rd1/.728721438361672e+00/, &
&rd2/.159210021472267e+00/, rd3/.116985268534248e-01/, &
&rd4/.225973894323078e-03/, rd5/.232707159780478e-06/
!-----------------------------------------------------------------------
if (x .ge. -1.0) go to 10
call aimp (-x, r, phi)
aie = r*sin(phi)
return
!
10 if (x .ge. 0.0) go to 20
aie = (((((((((an9*x + an8)*x + an7)*x + an6)*x + an5)*x &
&+ an4)*x + an3)*x + an2)*x + an1)*x + an0) / &
&(((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x .ge. 1.0) go to 30
aie = (((((((bn7*x + bn6)*x + bn5)*x + bn4)*x + bn3)*x + bn2)*x &
&+ bn1)*x + bn0) / &
&(((((bd5*x + bd4)*x + bd3)*x + bd2)*x + bd1)*x + bd0)
if (x .gt. 1.e-20) aie = aie * exp(2.0*x*sqrt(x)/3.0)
return
!
30 rtx = sqrt(x)
if (x .gt. x0) go to 40
t = 16.0/(x*rtx)
w = ((((pn4*t + pn3)*t + pn2)*t + pn1)*t + pn0) / &
&(((((pd5*t + pd4)*t + pd3)*t + pd2)*t + pd1)*t + pd0)
aie = w/sqrt(rtx)
return
!
40 if (x .gt. 4.0d0) go to 50
t = 16.0/(x*rtx)
w = (((((qn5*t + qn4)*t + qn3)*t + qn2)*t + qn1)*t + qn0) / &
&(((((qd5*t + qd4)*t + qd3)*t + qd2)*t + qd1)*t + qd0)
aie = w/sqrt(rtx)
return
!
50 if (x .gt. 1.e20) go to 60
t = 16.0/(x*rtx)
w = ((((rn4*t + rn3)*t + rn2)*t + rn1)*t + rn0) / &
&(((((rd5*t + rd4)*t + rd3)*t + rd2)*t + rd1)*t + rd0)
aie = w/sqrt(rtx)
return
!
60 aie = rn0/sqrt(rtx)
return
end function aie

real function bi(x)
implicit none
real, intent(in) :: x
integer :: n, n2
real :: ad0, ad1, ad2, ad3, an0, an1, an10, an2, an3, an4, an5, &
&an6, an7, an8, an9, bd0, bd1, bd2, bd3, bn0, bn1, bn10, bn2, bn3, &
&bn4, bn5, bn6, bn7, bn8, bn9, c, pd0, pd1, pd2, pd3, pd4, pd5, &
&pd6, pd7, phi, pn0, pn1, pn2, pn3, pn4, pn5, pn6, qd0, qd1, qd2, &
&qd3, qd4, qd5, qd6, qd7, qd8, qn0, qn1, qn2, qn3, qn4, qn5, qn6, &
&qn7, r, rd0, rd1, rd2, rn0, rn1, rn10, rn11, rn2, rn3, rn4, rn5, &
&rn6, rn7, rn8, rn9, rtx, sd0, sd1, sn0, sn1, sn10, sn11, sn12, &
&sn13, sn2, sn3, sn4, sn5, sn6, sn7, sn8, sn9, t, w, x0
real :: exparg
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
data x0/6.3496042078728/
data c /1.94773404105468/
!-----------------------
data an0/ .614926627446001e+00/, an1/ .462726943978834e+00/, &
&an2/ .867811386408974e-02/, an3/ .974670609357959e-01/, &
&an4/ .370856545413908e-01/, an5/ .569193415071716e-03/, &
&an6/ .269172131237236e-02/, an7/ .746473849872868e-03/, &
&an8/ .105638036899269e-04/, an9/ .242726195973978e-04/, &
&an10/.557260250681542e-05/
data ad0/ .100000000000000e+01/, ad1/ .234801779278695e-01/, &
&ad2/-.300487317759152e-02/, ad3/-.597414466459612e-02/
!-----------------------
data bn0/ .614926627446001e+00/, bn1/ .548653374523520e+00/, &
&bn2/ .582684047163842e-01/, bn3/ .871954925712688e-01/, &
&bn4/ .508547058449004e-01/, bn5/ .361412623711710e-02/, &
&bn6/ .177269722794511e-02/, bn7/ .117774184027185e-02/, &
&bn8/ .627004834186143e-04/, bn9/ .774782269814080e-06/, &
&bn10/.118116474369315e-04/
data bd0/ .100000000000000e+01/, bd1/ .163214622184402e+00/, &
&bd2/-.242285981710408e-01/, bd3/-.720554280297616e-02/
!-----------------------
data pn0/.619911943572678e+00/, pn1/.100411558489626e+01/, &
&pn2/.563659963795768e+00/, pn3/.274925508033015e+00/, &
&pn4/.115641822943246e+00/, pn5/.120048517441127e-01/, &
&pn6/.501838091254330e-02/
data pd0/.100000000000000e+01/, pd1/.159751878026937e+01/, &
&pd2/.104664867034140e+01/, pd3/.512560333664022e+00/, &
&pd4/.159144727666995e+00/, pd5/.394456748956258e-01/, &
&pd6/.529926873250079e-02/, pd7/.288921845412576e-03/
!-----------------------
data qn0/.595123543430856e+00/, qn1/.652692120245803e+00/, &
&qn2/.436851872835894e+00/, qn3/.201626141057807e+00/, &
&qn4/.649535170626944e-01/, qn5/.171798867787816e-01/, &
&qn6/.287998748038892e-02/, qn7/.359634362348937e-03/
data qd0/.100000000000000e+01/, qd1/.114259871204893e+01/, &
&qd2/.766390439057101e+00/, qd3/.348287281255683e+00/, &
&qd4/.117049276946157e+00/, qd5/.294545450289541e-01/, &
&qd6/.523951773968125e-02/, qd7/.622692248774973e-03/, &
&qd8/.674811395957744e-06/
!-----------------------
data rn0 / .568067636505865e+00/, rn1 / .462183136291541e-01/, &
&rn2 / .268519638203645e+00/, rn3 / .199427104235673e-02/, &
&rn4 / .135599161332010e-03/, rn5 / .229937707171804e-04/, &
&rn6 / .697888081361175e-05/, rn7 / .153277172934286e-05/, &
&rn8 /-.149322381877245e-05/, rn9 /-.113533571972859e-05/, &
&rn10/ .740721412702102e-06/, rn11/-.120160431596119e-06/
data rd0 / .100000000000000e+01/, rd1 / .741293424676788e-01/, &
&rd2 / .471695968238457e+00/
!-----------------------
data sn0 /.564189583547757e+00/, sn1 / .112605519585866e+00/, &
&sn2 /.893329124921909e-03/, sn3 / .532139134120350e-04/, &
&sn4 /.592725458717738e-05/, sn5 / .921448923850546e-06/, &
&sn6 /.404558310611815e-06/, sn7 /-.660517686759109e-06/, &
&sn8 /.174667472383815e-05/, sn9 /-.287037710548882e-05/, &
&sn10/.322304072982791e-05/, sn11/-.231569499551950e-05/, &
&sn12/.963478964685941e-06/, sn13/-.173784488565533e-06/
data sd0 /.100000000000000e+01/, sd1 / .193077670156841e+00/
!-----------------------------------------------------------------------
if (x .ge. -1.0) go to 10
call aimp (-x, r, phi)
bi = r*cos(phi)
return
!
10 if (x .ge. 0.0) go to 20
bi = ((((((((((an10*x + an9)*x + an8)*x + an7)*x &
&+ an6)*x + an5)*x + an4)*x + an3)*x &
&+ an2)*x + an1)*x + an0) / &
&(((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x .gt. 1.0) go to 30
bi = ((((((((((bn10*x + bn9)*x + bn8)*x + bn7)*x &
&+ bn6)*x + bn5)*x + bn4)*x + bn3)*x &
&+ bn2)*x + bn1)*x + bn0) / &
&(((bd3*x + bd2)*x + bd1)*x + bd0)
return
!
30 rtx = sqrt(x)
if (x .gt. 2.0) go to 40
t = x - 1.0
w = ((((((pn6*t + pn5)*t + pn4)*t + pn3)*t + pn2)*t &
&+ pn1)*t + pn0) / &
&(((((((pd7*t + pd6)*t + pd5)*t + pd4)*t + pd3)*t &
&+ pd2)*t + pd1)*t + pd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
!
40 if (x .gt. 4.0) go to 50
t = x - 2.0
w = (((((((qn7*t + qn6)*t + qn5)*t + qn4)*t + qn3)*t &
&+ qn2)*t + qn1)*t + qn0) / &
&((((((((qd8*t + qd7)*t + qd6)*t + qd5)*t + qd4)*t &
&+ qd3)*t + qd2)*t + qd1)*t + qd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
!
50 if (x .gt. x0) go to 60
t = 16.0/(x*rtx) - 1.0
w = (((((((((((rn11*t + rn10)*t + rn9)*t + rn8)*t &
&+ rn7)*t + rn6)*t + rn5)*t + rn4)*t + rn3)*t &
&+ rn2)*t + rn1)*t + rn0) / &
&((rd2*t + rd1)*t + rd0)
bi = (w/sqrt(rtx)) * exp(2.0*x*rtx/3.0)
return
!
60 if (x*rtx .gt. 1.5*exparg(0)) go to 70
t = 16.0/(x*rtx)
w = (((((((((((((sn13*t + sn12)*t + sn11)*t + sn10)*t &
&+ sn9)*t + sn8)*t + sn7)*t + sn6)*t + sn5)*t &
&+ sn4)*t + sn3)*t + sn2)*t + sn1)*t + sn0) / &
&(sd1*t + sd0)
n = rtx
n2 = n*n
t = (x - n2)/(rtx + n)
bi = (w/sqrt(rtx)) * c**(n2*n) * exp(2.0*t*(n*rtx + t*t/3.0))
return
!
70 bi = 0.0
return
end function bi

real function bie(x)
implicit none
real, intent(in) :: x
real :: ad0, ad1, ad2, ad3, an0, an1, an10, an2, an3, an4, an5, &
&an6, an7, an8, an9, bd0, bd1, bd2, bd3, bn0, bn1, bn10, bn2, bn3, &
&bn4, bn5, bn6, bn7, bn8, bn9, pd0, pd1, pd2, pd3, pd4, pd5, pd6, &
&pd7, phi, pn0, pn1, pn2, pn3, pn4, pn5, pn6, qd0, qd1, qd2, qd3, &
&qd4, qd5, qd6, qd7, qd8, qn0, qn1, qn2, qn3, qn4, qn5, qn6, qn7, &
&r, rd0, rd1, rd2, rn0, rn1, rn10, rn11, rn2, rn3, rn4, rn5, rn6, &
&rn7, rn8, rn9, rtx, sd0, sd1, sn0, sn1, sn10, sn11, sn12, sn13, &
&sn2, sn3, sn4, sn5, sn6, sn7, sn8, sn9, t, w, x0
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
data x0/6.3496042078728/
!-----------------------
data an0/ .614926627446001e+00/, an1/ .462726943978834e+00/, &
&an2/ .867811386408974e-02/, an3/ .974670609357959e-01/, &
&an4/ .370856545413908e-01/, an5/ .569193415071716e-03/, &
&an6/ .269172131237236e-02/, an7/ .746473849872868e-03/, &
&an8/ .105638036899269e-04/, an9/ .242726195973978e-04/, &
&an10/.557260250681542e-05/
data ad0/ .100000000000000e+01/, ad1/ .234801779278695e-01/, &
&ad2/-.300487317759152e-02/, ad3/-.597414466459612e-02/
!-----------------------
data bn0/ .614926627446001e+00/, bn1/ .548653374523520e+00/, &
&bn2/ .582684047163842e-01/, bn3/ .871954925712688e-01/, &
&bn4/ .508547058449004e-01/, bn5/ .361412623711710e-02/, &
&bn6/ .177269722794511e-02/, bn7/ .117774184027185e-02/, &
&bn8/ .627004834186143e-04/, bn9/ .774782269814080e-06/, &
&bn10/.118116474369315e-04/
data bd0/ .100000000000000e+01/, bd1/ .163214622184402e+00/, &
&bd2/-.242285981710408e-01/, bd3/-.720554280297616e-02/
!-----------------------
data pn0/.619911943572678e+00/, pn1/.100411558489626e+01/, &
&pn2/.563659963795768e+00/, pn3/.274925508033015e+00/, &
&pn4/.115641822943246e+00/, pn5/.120048517441127e-01/, &
&pn6/.501838091254330e-02/
data pd0/.100000000000000e+01/, pd1/.159751878026937e+01/, &
&pd2/.104664867034140e+01/, pd3/.512560333664022e+00/, &
&pd4/.159144727666995e+00/, pd5/.394456748956258e-01/, &
&pd6/.529926873250079e-02/, pd7/.288921845412576e-03/
!-----------------------
data qn0/.595123543430856e+00/, qn1/.652692120245803e+00/, &
&qn2/.436851872835894e+00/, qn3/.201626141057807e+00/, &
&qn4/.649535170626944e-01/, qn5/.171798867787816e-01/, &
&qn6/.287998748038892e-02/, qn7/.359634362348937e-03/
data qd0/.100000000000000e+01/, qd1/.114259871204893e+01/, &
&qd2/.766390439057101e+00/, qd3/.348287281255683e+00/, &
&qd4/.117049276946157e+00/, qd5/.294545450289541e-01/, &
&qd6/.523951773968125e-02/, qd7/.622692248774973e-03/, &
&qd8/.674811395957744e-06/
!-----------------------
data rn0 / .568067636505865e+00/, rn1 / .462183136291541e-01/, &
&rn2 / .268519638203645e+00/, rn3 / .199427104235673e-02/, &
&rn4 / .135599161332010e-03/, rn5 / .229937707171804e-04/, &
&rn6 / .697888081361175e-05/, rn7 / .153277172934286e-05/, &
&rn8 /-.149322381877245e-05/, rn9 /-.113533571972859e-05/, &
&rn10/ .740721412702102e-06/, rn11/-.120160431596119e-06/
data rd0 / .100000000000000e+01/, rd1 / .741293424676788e-01/, &
&rd2 / .471695968238457e+00/
!-----------------------
data sn0 /.564189583547757e+00/, sn1 / .112605519585866e+00/, &
&sn2 /.893329124921909e-03/, sn3 / .532139134120350e-04/, &
&sn4 /.592725458717738e-05/, sn5 / .921448923850546e-06/, &
&sn6 /.404558310611815e-06/, sn7 /-.660517686759109e-06/, &
&sn8 /.174667472383815e-05/, sn9 /-.287037710548882e-05/, &
&sn10/.322304072982791e-05/, sn11/-.231569499551950e-05/, &
&sn12/.963478964685941e-06/, sn13/-.173784488565533e-06/
data sd0 /.100000000000000e+01/, sd1 / .193077670156841e+00/
!-----------------------------------------------------------------------
if (x .ge. -1.0) go to 10
call aimp (-x, r, phi)
bie = r*cos(phi)
return
!
10 if (x .ge. 0.0) go to 20
bie = ((((((((((an10*x + an9)*x + an8)*x + an7)*x &
&+ an6)*x + an5)*x + an4)*x + an3)*x &
&+ an2)*x + an1)*x + an0) / &
&(((ad3*x + ad2)*x + ad1)*x + ad0)
return
!
20 if (x .gt. 1.0) go to 30
bie = ((((((((((bn10*x + bn9)*x + bn8)*x + bn7)*x &
&+ bn6)*x + bn5)*x + bn4)*x + bn3)*x &
&+ bn2)*x + bn1)*x + bn0) / &
&(((bd3*x + bd2)*x + bd1)*x + bd0)
if (x .gt. 1.e-20) bie = bie * exp(-2.0*x*sqrt(x)/3.0)
return
!
30 rtx = sqrt(x)
if (x .gt. 2.0) go to 40
t = x - 1.0
w = ((((((pn6*t + pn5)*t + pn4)*t + pn3)*t + pn2)*t &
&+ pn1)*t + pn0) / &
&(((((((pd7*t + pd6)*t + pd5)*t + pd4)*t + pd3)*t &
&+ pd2)*t + pd1)*t + pd0)
bie = w/sqrt(rtx)
return
!
40 if (x .gt. 4.0) go to 50
t = x - 2.0
w = (((((((qn7*t + qn6)*t + qn5)*t + qn4)*t + qn3)*t &
&+ qn2)*t + qn1)*t + qn0) / &
&((((((((qd8*t + qd7)*t + qd6)*t + qd5)*t + qd4)*t &
&+ qd3)*t + qd2)*t + qd1)*t + qd0)
bie = w/sqrt(rtx)
return
!
50 if (x .gt. x0) go to 60
t = 16.0/(x*rtx) - 1.0
w = (((((((((((rn11*t + rn10)*t + rn9)*t + rn8)*t &
&+ rn7)*t + rn6)*t + rn5)*t + rn4)*t + rn3)*t &
&+ rn2)*t + rn1)*t + rn0) / &
&((rd2*t + rd1)*t + rd0)
bie = w/sqrt(rtx)
return
!
60 if (x .gt. 1.e20) go to 70
t = 16.0/(x*rtx)
w = (((((((((((((sn13*t + sn12)*t + sn11)*t + sn10)*t &
&+ sn9)*t + sn8)*t + sn7)*t + sn6)*t + sn5)*t &
&+ sn4)*t + sn3)*t + sn2)*t + sn1)*t + sn0) / &
&(sd1*t + sd0)
bie = w/sqrt(rtx)
return
!
70 bie = sn0/sqrt(rtx)
return
end function bie

subroutine aimp (x, r, phi)
implicit none
real, intent(inout) :: phi, r
real, intent(in) :: x
real :: ad0, ad1, ad2, ad3, ad4, ad5, an0, an1, an2, an3, an4, &
&an5, an6, bd0, bd1, bd2, bd3, bd4, bd5, bd6, bn0, bn1, bn2, bn3, &
&bn4, bn5, bn6, cd0, cd1, cd2, cd3, cd4, cd5, cd6, cn0, cn1, cn2, &
&cn3, cn4, cn5, dd0, dd1, dd2, dd3, dd4, dd5, dd6, dn0, dn1, dn2, &
&dn3, dn4, dn5, pd0, pd1, pd2, pd3, pd4, pd5, pi4, pn0, pn1, pn2, &
&pn3, pn4, pn5, qd0, qd1, qd2, qd3, qd4, qd5, qn0, qn1, qn2, qn3, &
&qn4, rtx, z
!-----------------------------------------------------------------------
!     COMPUTATION OF THE AIRY MODULUS AND PHASE FOR x .GE. 1
!-----------------------------------------------------------------------
data pi4 /.785398163397448/
!-----------------------
data an0/.297640916735064e+00/, an1/.772796814419809e+00/, &
&an2/.764990563560236e+00/, an3/.375694096095838e+00/, &
&an4/.978661044870204e-01/, an5/.110446639522696e-01/, &
&an6/.145271249611697e-05/
data ad0/.100000000000000e+01/, ad1/.247380029946443e+01/, &
&ad2/.240125897828762e+01/, ad3/.118267264172257e+01/, &
&ad4/.306942883081787e+00/, ad5/.347670057203535e-01/
!-----------------------
data bn0/.593601051670149e+00/, bn1/.223281495955754e+01/, &
&bn2/.317718143418600e+01/, bn3/.229890914530923e+01/, &
&bn4/.933580623665765e+00/, bn5/.209164380960390e+00/, &
&bn6/.207910965366403e-01/
data bd0/.100000000000000e+01/, bd1/.345985556561483e+01/, &
&bd2/.479629661187354e+01/, bd3/.345429311552596e+01/, &
&bd4/.140017214942186e+01/, bd5/.313770549939860e+00/, &
&bd6/.311852186700025e-01/
!-----------------------
data cn0/.313541841678871e+00/, cn1/.470104287134296e+00/, &
&cn2/.291795874641314e+00/, cn3/.962250689852768e-01/, &
&cn4/.171024484244850e-01/, cn5/.134933201907052e-02/
data cd0/.100000000000000e+01/, cd1/.148070947673639e+01/, &
&cd2/.917484386216329e+00/, cd3/.302281922152536e+00/, &
&cd4/.537309296828367e-01/, cd5/.423890576557513e-02/, &
&cd6/.525954318463502e-08/
!-----------------------
data dn0/.654836896032068e+00/, dn1/.117099614856528e+01/, &
&dn2/.831899010444840e+00/, dn3/.301060337976575e+00/, &
&dn4/.564712748150658e-01/, dn5/.444134415666317e-02/
data dd0/.100000000000000e+01/, dd1/.176306543768126e+01/, &
&dd2/.124897609613487e+01/, dd3/.451576491257036e+00/, &
&dd4/.847085955634988e-01/, dd5/.666188176245820e-02/, &
&dd6/.537600060708764e-08/
!-----------------------
data pn0/.318309886183791e+00/, pn1/.100996327221962e+01/, &
&pn2/.902315148591491e+00/, pn3/.259820640977615e+00/, &
&pn4/.203717769716282e-01/, pn5/.216893438784765e-03/
data pd0/.100000000000000e+01/, pd1/.317533460265059e+01/, &
&pd2/.284232123705698e+01/, pd3/.822777439238360e+00/, &
&pd4/.656865942543526e-01/, pd5/.775376048996392e-03/
!-----------------------
data qn0/.666666666666667e+00/, qn1/.141905542385598e+01/, &
&qn2/.772778148352443e+00/, qn3/.115170415082442e+00/, &
&qn4/.326457319318373e-02/
data qd0/.100000000000000e+01/, qd1/.213102454203392e+01/, &
&qd2/.116432601041188e+01/, qd3/.175509465791633e+00/, &
&qd4/.528319849831061e-02/, qd5/.867802002275824e-05/
!-----------------------------------------------------------------------
if (x .gt. 2.0) go to 10
z = x - 1.0
r =   ((((((an6*z + an5)*z + an4)*z + an3)*z + an2)*z &
&+ an1)*z + an0) / &
&(((((ad5*z + ad4)*z + ad3)*z + ad2)*z + ad1)*z + ad0)
phi = ((((((bn6*z + bn5)*z + bn4)*z + bn3)*z + bn2)*z &
&+ bn1)*z + bn0) / &
&((((((bd6*z + bd5)*z + bd4)*z + bd3)*z + bd2)*z &
&+ bd1)*z + bd0)
go to 40
!
10 if (x .ge. 4.0) go to 20
z = x - 2.0
r =   (((((cn5*z + cn4)*z + cn3)*z + cn2)*z + cn1)*z + cn0) / &
&((((((cd6*z + cd5)*z + cd4)*z + cd3)*z + cd2)*z &
&+ cd1)*z + cd0)
phi = (((((dn5*z + dn4)*z + dn3)*z + dn2)*z + dn1)*z + dn0) / &
&((((((dd6*z + dd5)*z + dd4)*z + dd3)*z + dd2)*z &
&+ dd1)*z + dd0)
go to 40
!
20 if (x .gt. 1.e10) go to 30
z = 64.0/x**3
r =   (((((pn5*z + pn4)*z + pn3)*z + pn2)*z + pn1)*z + pn0) / &
&(((((pd5*z + pd4)*z + pd3)*z + pd2)*z + pd1)*z + pd0)
phi = ((((qn4*z + qn3)*z + qn2)*z + qn1)*z + qn0) / &
&(((((qd5*z + qd4)*z + qd3)*z + qd2)*z + qd1)*z + qd0)
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

complex function ck(k,l)
implicit none
integer :: i, ind
real :: c1, c2, eps, phi, r, t, tol, u, v, x, xx, y
real :: spmpar
real :: alnrel
!     ------------------------------------------------------------------
!     This function calculates the complete elliptic integral F(k)
!     FOR COMPLEX VALUES OF THE MODULUS k. IT IS ASSUMED THAT l.NE.0
!     AND THAT k**2 + l**2 = 1.
!     ------------------------------------------------------------------
complex, intent(in) :: k, l
complex :: ak, al, ak1, al1, al2, ckk, ckp, f1, f2, f3, fxk, &
&aktemp, ck1, j
complex :: cflect, km, z
real :: ln4, x1(12), x2(12), w1(12), w2(12), fl(12), fa(12), &
&fb(12)
logical :: branch
!     --------------------------------------------------------------
data x1(1)/ 6.5487222790801e-03/, x1(2)/ 3.8946809560450e-02/, &
&x1(3)/ 9.8150263106007e-02/, x1(4)/ 1.8113858159063e-01/, &
&x1(5)/ 2.8322006766737e-01/, x1(6)/ 3.9843443516344e-01/, &
&x1(7)/ 5.1995262679235e-01/, x1(8)/ 6.4051091671611e-01/, &
&x1(9)/ 7.5286501205183e-01/, x1(10)/8.5024002416230e-01/, &
&x1(11)/9.2674968322391e-01/, x1(12)/9.7775612969000e-01/
!     --------------------------------------------------------------
data w1(1)/ 9.3192691443932e-02/, w1(2)/ 1.4975182757632e-01/, &
&w1(3)/ 1.6655745436459e-01/, w1(4)/ 1.5963355943699e-01/, &
&w1(5)/ 1.3842483186484e-01/, w1(6)/ 1.1001657063572e-01/, &
&w1(7)/ 7.9961821770829e-02/, w1(8)/ 5.2406954824642e-02/, &
&w1(9)/ 3.0071088873761e-02/, w1(10)/1.4249245587998e-02/, &
&w1(11)/4.8999245823217e-03/, w1(12)/8.3402903805690e-04/
!     --------------------------------------------------------------
data fl(1)/ 1.5708005371203e+00/, fl(2)/ 1.5709452753591e+00/, &
&fl(3)/ 1.5717433742881e+00/, fl(4)/ 1.5740325056162e+00/, &
&fl(5)/ 1.5787613653341e+00/, fl(6)/ 1.5867393901613e+00/, &
&fl(7)/ 1.5983969635617e+00/, fl(8)/ 1.6135762587884e+00/, &
&fl(9)/ 1.6313677113831e+00/, fl(10)/1.6500349733510e+00/, &
&fl(11)/1.6671202200919e+00/, fl(12)/1.6798403417359e+00/
!     --------------------------------------------------------------
data x2(1)/-9.8156063424672e-01/, x2(2)/-9.0411725637048e-01/, &
&x2(3)/-7.6990267419431e-01/, x2(4)/-5.8731795428662e-01/, &
&x2(5)/-3.6783149899818e-01/, x2(6)/-1.2523340851147e-01/, &
&x2(7)/ 1.2523340851147e-01/, x2(8)/ 3.6783149899818e-01/, &
&x2(9)/ 5.8731795428662e-01/, x2(10)/7.6990267419431e-01/, &
&x2(11)/9.0411725637048e-01/, x2(12)/9.8156063424672e-01/
!     --------------------------------------------------------------
data w2(1)/ 4.7175336386512e-02/, w2(2)/ 1.0693932599532e-01/, &
&w2(3)/ 1.6007832854335e-01/, w2(4)/ 2.0316742672307e-01/, &
&w2(5)/ 2.3349253653836e-01/, w2(6)/ 2.4914704581340e-01/, &
&w2(7)/ 2.4914704581340e-01/, w2(8)/ 2.3349253653836e-01/, &
&w2(9)/ 2.0316742672307e-01/, w2(10)/1.6007832854335e-01/, &
&w2(11)/1.0693932599532e-01/, w2(12)/4.7175336386512e-02/
!     --------------------------------------------------------------
data fa(1)/ 2.0794472764428e+00/, fa(2)/ 2.0795966441739e+00/, &
&fa(3)/ 2.0803359313463e+00/, fa(4)/ 2.0823286205438e+00/, &
&fa(5)/ 2.0862633195105e+00/, fa(6)/ 2.0926508621232e+00/, &
&fa(7)/ 2.1016440761258e+00/, fa(8)/ 2.1128974786197e+00/, &
&fa(9)/ 2.1254857173540e+00/, fa(10)/2.1379218133017e+00/, &
&fa(11)/2.1483404506064e+00/, fa(12)/2.1548934173960e+00/
!     --------------------------------------------------------------
data fb(1)/ 1.5744273529551e+00/, fb(2)/ 1.5899097325063e+00/, &
&fb(3)/ 1.6176685384410e+00/, fb(4)/ 1.6574605448620e+00/, &
&fb(5)/ 1.7087245795822e+00/, fb(6)/ 1.7703459462057e+00/, &
&fb(7)/ 1.8403280188791e+00/, fb(8)/ 1.9154060277115e+00/, &
&fb(9)/ 1.9907093877047e+00/, fb(10)/2.0596975322636e+00/, &
&fb(11)/2.1146977530430e+00/, fb(12)/2.1482986855683e+00/
!     --------------------------------------------------------------
data j/(0.0, 1.0)/
data ln4 /1.3862943611199/
data c1  /.20264236728467/, c2/.15915494309189/
!     ---------------------------------------------------
!
!     Eps is a machine dependent constant.  Eps is the
!     SMALLEST NUMBER SUCH THAT 1. + eps .GT. 1.
!
eps = spmpar(1)
!
!     ---------------------------------------------------
if (l .eq. (0.0, 0.0)) go to 200
ind = 0
branch = .true.
tol = 8.0*amax1(eps, 1.e-14)
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
if (amax1(x,abs(y)) .ge. 1.0/eps) go to 90
if (amax1(u,abs(v)) .ge. 1.1/eps) go to 200
!
!     CHECK THAT k**2 + l**2 = 1
!
if (x .lt. u) go to 1
   t = u/x
   if (abs(x*x/(v*v + 1.0/(1.0 + t*t)) - 1.0) .gt. tol) go to 200
   if (abs(y + t*v) .gt. tol*amax1(1.0, abs(v))) go to 200
   go to 10
1 t = x/u
if (abs(u*u/(y*y + 1.0/(1.0 + t*t)) - 1.0) .gt. tol) go to 200
if (abs(v + t*y) .gt. tol*amax1(1.0, abs(y))) go to 200
!
!     Uses  logarithmic series when CABS(al)
!     is less than or equal to 0.55
!
10 if (u .gt. 1.42 .or. abs(v) .gt. 1.42) go to 50
11 if (cabs(al) .gt. 0.55) go to 20
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
20 r = cabs(ak)
if (r .gt. 0.55) go to 30
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
30 if (ind .eq. 0 .and. r .gt. 1.0) go to 50
31 al2 = al*al
!
f1 = (0.0, 0.0)
do 40 i = 1,12
   xx = x1(i)/2.
   fxk = ak*xx
40 f1 = f1 + w1(i)*fl(i)/(al2 + fxk*fxk)
f2 = (0.0, 0.0)
do 41 i = 1,12
   xx = .25*(1.+ x2(i))
   fxk = ak*xx
41 f2 = f2 + w2(i)*fa(i)/(al2 + fxk*fxk)
f3 = (0.0, 0.0)
do 42 i = 1,12
   xx = .25*(3.- x2(i))
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
!     Uses inverse modulus transformation when CABS(ak) is greater
!     THAN 1 AND real(ak**2) IS GREATER THAN 0.5.
!
50 if (x*x .le. y*y + 0.5) go to 60
ind = 1
branch = .false.
ak = 1.0/ak1
al = cflect(j*al1/ak1)
go to 11
!
!     Uses complementary inverse modulus transformation when CABS(ak)
!     IS GREATER THAN 1 AND real(ak**2) IS LESS THAN OR EQUAL TO 0.5
!
60 ind = 2
ak = cflect(j*ak1/al1)
al = 1.0/al1
go to 11
!
!     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
!
70 if (ind .eq. 0) return
if (ind .eq. 1) go to 80
!
!     Complementary inverse modulus transformation
!
ck = al*ck
return
!
!     Inverse modulus transformation
!
80 if (aimag(ak1) .ge. 0.0) go to 81
   ck = al*(ck1 - j*ck)
   return
81 ck = al*(ck1 + j*ck)
return
!
!     Calculation of F(k) for large k and l
!
90 if (x .le. abs(y)) go to 100
if (abs(abs(v/x) - 1.0) .gt. tol) go to 200
if (abs(u/x + y/v) .gt. tol) go to 200
t = y/x
phi = atan2(x,abs(y))
r = (ln4 + 0.5*alnrel(t*t)) + alog(x)
if (y .lt. 0.0) r = -r
ck = (cmplx(phi,r)/cmplx(1.0,t))/x
return
!
100 if (abs(abs(u/y) - 1.0) .gt. tol) go to 200
if (abs(x/u + v/y) .gt. tol) go to 200
t = v/u
z = cmplx((ln4 + 0.5*alnrel(t*t)) + alog(u), atan2(v,u))
ck = (z/cmplx(1.0,t))/u
return
!
!     Error return
!
200 ck = (0.0, 0.0)
return
end function ck

complex function cflect(z)
implicit none
!---------------------------------------------------------
!     Reflects z with respect to the origin if real(z)
!     .LT. 0.0 OR IF z IS ON THE NEGATIVE IMAGINARY AXIS.
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

complex function km(k2)
implicit none
integer :: i
real :: c, eps, hpi, ri, tol
real :: spmpar
complex, intent(in) :: k2
!---------------------------------------------------------------------
!     KM computes the complete elliptic integral F(K) for a given
!     VALUE OF k2 = K**2 BY USE OF THE MACLAURIN EXPANSION.
!---------------------------------------------------------------------
complex :: an, s1
data hpi /1.5707963267949/
! ---------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1 + eps .GT. 1.
!
                eps = spmpar(1)
!
! ---------------
!
tol = amax1(eps,1.e-14)
s1 = (1.0, 0.0)
an = (1.0, 0.0)
do i = 1,50
   ri = i
   c = ((ri - 0.5)/ri)**2
   an = c*(an*k2)
   s1 = s1 + an
   if (abs(real(an)) + abs(aimag(an)) .lt. tol) go to 20
end do
!
20 km = hpi*s1
return
end function km

subroutine kl (l, fk, fl)
implicit none
integer :: i
real :: bn, c, eps, hpi, ri, tol, u, x, y
real :: spmpar
real :: alnrel
complex, intent(in) :: l
complex, intent(inout) :: fk, fl
! ----------------------------------------------------------------------
!     KL computes the complete elliptic integrals F(K) and F(l) for
!     A GIVEN VALUE OF l, WHERE CABS(l) .LT. 1 AND K**2 + l**2 = 1.
!     IT IS ASSUMED THAT -PI .LE. ARG(l**2) .LT. PI FOR THE RESULTING
!     value for F(K) to be meaningful.
! ----------------------------------------------------------------------
complex :: an, l2, s1, s2, w
real :: ln4
!     --------------
data hpi /1.5707963267949/
data ln4 /1.3862943611199/
! ---------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1 + eps .GT. 1.
!
                eps = spmpar(1)
!
! ---------------
!
!            The logarithmic expansion is used for F(K)
!              and the Maclaurin expansion for F(l)
!
tol = amax1(eps,1.e-14)
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
   if (abs(real(an)) + abs(aimag(an)) .lt. tol) go to 20
end do
20 s1 = s1 + (1.0, 0.0)
!
!                   SET w = 0.5*CLOG(16.0/l2)
!
x = real(l)
y = aimag(l)
if (x .ne. 0.0) go to 30
   w = cmplx(ln4 - alog(abs(y)), hpi)
   go to 50
!
30 if (abs(x) .gt. abs(y)) go to 31
   u = (ln4 - 0.5*alnrel((x/y)**2)) - alog(abs(y))
   go to 40
31 u = (ln4 - 0.5*alnrel((y/x)**2)) - alog(abs(x))
!
40 if (x .gt. 0.0) go to 41
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

subroutine cke(k,l,ck,ce,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: i, ind
real :: c, c1, c2, eps, phi, r, t, tol, u, v, x, xx, y
real :: alnrel
real :: spmpar
!     ------------------------------------------------------------------
!     This function calculates the complete elliptic integrals F(k)
!     and E(k) for complex values of the modulus k. it is assumed
!     THAT l.NE.0 AND THAT k**2 + l**2 = 1.
!     ------------------------------------------------------------------
complex, intent(in) :: k, l
complex :: ak, al, ak1, al1, ckk, ckp, f1, f2, f3, aktemp, ck1, j
complex, intent(inout) :: ce, ck
complex :: cee, cep, ce1, e1, e2, e3, at, fx, fxk, atn
complex :: cflect, k1, l1, ak2, al2, z, g, g1, gg, gp
real :: ln4, x1(12), x2(12), w1(12), w2(12), fl(12), fa(12), &
&fb(12)
logical :: branch
!     --------------------------------------------------------------
data x1(1)/ 6.5487222790801e-03/, x1(2)/ 3.8946809560450e-02/, &
&x1(3)/ 9.8150263106007e-02/, x1(4)/ 1.8113858159063e-01/, &
&x1(5)/ 2.8322006766737e-01/, x1(6)/ 3.9843443516344e-01/, &
&x1(7)/ 5.1995262679235e-01/, x1(8)/ 6.4051091671611e-01/, &
&x1(9)/ 7.5286501205183e-01/, x1(10)/8.5024002416230e-01/, &
&x1(11)/9.2674968322391e-01/, x1(12)/9.7775612969000e-01/
!     --------------------------------------------------------------
data w1(1)/ 9.3192691443932e-02/, w1(2)/ 1.4975182757632e-01/, &
&w1(3)/ 1.6655745436459e-01/, w1(4)/ 1.5963355943699e-01/, &
&w1(5)/ 1.3842483186484e-01/, w1(6)/ 1.1001657063572e-01/, &
&w1(7)/ 7.9961821770829e-02/, w1(8)/ 5.2406954824642e-02/, &
&w1(9)/ 3.0071088873761e-02/, w1(10)/1.4249245587998e-02/, &
&w1(11)/4.8999245823217e-03/, w1(12)/8.3402903805690e-04/
!     --------------------------------------------------------------
data fl(1)/ 1.5708005371203e+00/, fl(2)/ 1.5709452753591e+00/, &
&fl(3)/ 1.5717433742881e+00/, fl(4)/ 1.5740325056162e+00/, &
&fl(5)/ 1.5787613653341e+00/, fl(6)/ 1.5867393901613e+00/, &
&fl(7)/ 1.5983969635617e+00/, fl(8)/ 1.6135762587884e+00/, &
&fl(9)/ 1.6313677113831e+00/, fl(10)/1.6500349733510e+00/, &
&fl(11)/1.6671202200919e+00/, fl(12)/1.6798403417359e+00/
!     --------------------------------------------------------------
data x2(1)/-9.8156063424672e-01/, x2(2)/-9.0411725637048e-01/, &
&x2(3)/-7.6990267419431e-01/, x2(4)/-5.8731795428662e-01/, &
&x2(5)/-3.6783149899818e-01/, x2(6)/-1.2523340851147e-01/, &
&x2(7)/ 1.2523340851147e-01/, x2(8)/ 3.6783149899818e-01/, &
&x2(9)/ 5.8731795428662e-01/, x2(10)/7.6990267419431e-01/, &
&x2(11)/9.0411725637048e-01/, x2(12)/9.8156063424672e-01/
!     --------------------------------------------------------------
data w2(1)/ 4.7175336386512e-02/, w2(2)/ 1.0693932599532e-01/, &
&w2(3)/ 1.6007832854335e-01/, w2(4)/ 2.0316742672307e-01/, &
&w2(5)/ 2.3349253653836e-01/, w2(6)/ 2.4914704581340e-01/, &
&w2(7)/ 2.4914704581340e-01/, w2(8)/ 2.3349253653836e-01/, &
&w2(9)/ 2.0316742672307e-01/, w2(10)/1.6007832854335e-01/, &
&w2(11)/1.0693932599532e-01/, w2(12)/4.7175336386512e-02/
!     --------------------------------------------------------------
data fa(1)/ 2.0794472764428e+00/, fa(2)/ 2.0795966441739e+00/, &
&fa(3)/ 2.0803359313463e+00/, fa(4)/ 2.0823286205438e+00/, &
&fa(5)/ 2.0862633195105e+00/, fa(6)/ 2.0926508621232e+00/, &
&fa(7)/ 2.1016440761258e+00/, fa(8)/ 2.1128974786197e+00/, &
&fa(9)/ 2.1254857173540e+00/, fa(10)/2.1379218133017e+00/, &
&fa(11)/2.1483404506064e+00/, fa(12)/2.1548934173960e+00/
!     --------------------------------------------------------------
data fb(1)/ 1.5744273529551e+00/, fb(2)/ 1.5899097325063e+00/, &
&fb(3)/ 1.6176685384410e+00/, fb(4)/ 1.6574605448620e+00/, &
&fb(5)/ 1.7087245795822e+00/, fb(6)/ 1.7703459462057e+00/, &
&fb(7)/ 1.8403280188791e+00/, fb(8)/ 1.9154060277115e+00/, &
&fb(9)/ 1.9907093877047e+00/, fb(10)/2.0596975322636e+00/, &
&fb(11)/2.1146977530430e+00/, fb(12)/2.1482986855683e+00/
!     --------------------------------------------------------------
data j/(0.0, 1.0)/
data ln4 /1.3862943611199/
data c1  /.20264236728467/, c2/.15915494309189/
!     ---------------------------------------------------
!
!     Eps is a machine dependent constant.  Eps is the
!     SMALLEST NUMBER SUCH THAT 1. + eps .GT. 1.
!
eps = spmpar(1)
!
!     ---------------------------------------------------
if (l .eq. (0.0, 0.0)) go to 200
ind = 0
branch = .true.
tol = 8.0*amax1(eps, 1.e-14)
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
if (amax1(x,abs(y)) .ge. 1.0/eps) go to 90
if (amax1(u,abs(v)) .ge. 1.1/eps) go to 210
!
!     CHECK THAT k**2 + l**2 = 1
!
if (x .lt. u) go to 1
   t = u/x
   if (abs(x*x/(v*v + 1.0/(1.0 + t*t)) - 1.0) .gt. tol) go to 210
   if (abs(y + t*v) .gt. tol*amax1(1.0, abs(v))) go to 210
   go to 10
1 t = x/u
if (abs(u*u/(y*y + 1.0/(1.0 + t*t)) - 1.0) .gt. tol) go to 210
if (abs(v + t*y) .gt. tol*amax1(1.0, abs(y))) go to 210
!
!     Uses  logarithmic series when CABS(al)
!     is less than or equal to 0.55
!
10 if (u .gt. 1.42 .or. abs(v) .gt. 1.42) go to 50
11 if (cabs(al) .gt. 0.55) go to 20
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
20 r = cabs(ak)
if (r .gt. 0.55) go to 30
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
30 if (ind .eq. 0 .and. r .gt. 1.0) go to 50
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
   xx = .25*(1.+ x2(i))
   fx = ak*xx/al
   fxk = ak*xx
   at = atn(fx)
   e2 = e2 + w2(i)*fa(i)*(1.0 + at)
41 f2 = f2 + w2(i)*fa(i)/(al2 + fxk*fxk)
f3 = (0.0, 0.0)
e3 = (0.0, 0.0)
do 42 i = 1,12
   xx = .25*(3.- x2(i))
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
!     Uses inverse modulus transformation when CABS(ak) is greater
!     THAN 1 AND real(ak**2) IS GREATER THAN 0.5.
!
50 if (x*x .le. y*y + 0.5) go to 60
ind = 1
branch = .false.
ak = 1.0/ak1
al = cflect(j*al1/ak1)
go to 11
!
!     Uses complementary inverse modulus transformation when CABS(ak)
!     IS GREATER THAN 1 AND real(ak**2) IS LESS THAN OR EQUAL TO 0.5
!
60 ind = 2
ak = cflect(j*ak1/al1)
al = 1.0/al1
go to 11
!
!     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
!
70 if (ind .eq. 0) return
if (ind .eq. 1) go to 80
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
81 if (aimag(ak2) .ge. 0.0) go to 82
   ce = (g1 + j*g)/al
   ck = al*(ck1 - j*ck)
   return
82 ce = (g1 - j*g)/al
ck = al*(ck1 + j*ck)
return
!
!     Calculation of F(k) and E(k) for large k and l
!
90 if (x .le. abs(y)) go to 100
if (abs(abs(v/x) - 1.0) .gt. tol) go to 210
if (abs(u/x + y/v) .gt. tol) go to 210
t = y/x
k1 = cmplx(1.0,t)
phi = atan2(x,abs(y))
r = (ln4 + 0.5*alnrel(t*t)) + alog(x)
c = 0.5*r + 0.25
z = cmplx(y,-x)
if (y .ge. 0.0) go to 91
   r = -r
   c = -c
   z = -z
91 ck = (cmplx(phi,r)/k1)/x
ce = z + (cmplx(0.5*phi,c)/k1)/x
return
!
100 if (abs(abs(u/y) - 1.0) .gt. tol) go to 210
if (abs(x/u + v/y) .gt. tol) go to 210
t = v/u
l1 = cmplx(1.0,t)
r = (ln4 + 0.5*alnrel(t*t)) + alog(u)
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

complex function atn(z)
implicit none
real :: atn1, atn2, d, da, db, t, x, y
real :: alnrel
!---------------------------------------------------
!     CALCULATES COMPLEX FUNCTION atn(z) = z*ATAN(z)
!     using double precision.
!---------------------------------------------------
complex, intent(in) :: z
double precision :: dx, dy
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

subroutine ekm (k2, fk, ek)
implicit none
integer :: i
real :: c, eps, hpi, ri, tol
real :: spmpar
complex, intent(in) :: k2
complex, intent(inout) :: fk, ek
! ----------------------------------------------------------------------
!     ekm computes the complete elliptic integrals F(K) and E(K) for
!     A GIVEN VALUE OF k2 = K**2 BY USE OF THE MACLAURIN EXPANSIONS.
! ----------------------------------------------------------------------
complex :: an, cn, s1, s2
data hpi /1.5707963267949/
! ---------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1 + eps .GT. 1.
!
                eps = spmpar(1)
!
! ---------------
!
tol = amax1(eps,1.e-14)
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
   if (abs(real(an)) + abs(aimag(an)) .lt. tol) go to 20
end do
!
20 fk = hpi*s1
ek = hpi*s2
return
end subroutine ekm

subroutine ekl (l,fk,fl,ek,el,gk,gl)
implicit none
integer :: i
real :: bn, c, dn, eps, fn, gn, hpi, ri, tol, u, x, y
real :: spmpar
real :: alnrel
complex, intent(in) :: l
complex :: l2
complex, intent(inout) :: fk, fl, ek, el, gk, gl
! ----------------------------------------------------------------------
!     ekl computes the complete elliptic integrals F(K), F(l), E(K),
!     E(l) FOR A GIVEN VALUE OF l2, WHERE l2 = l**2 AND K**2 + l**2 = 1.
!     IT IS ASSUMED THAT -PI .LT. ARG(l2) .LE. PI FOR THE RESULTING
!     value for F(K) to be meaningful.  The combinations of functions
!     G(K) = E(K) - l**2*F(K) AND G(l) = E(l) - K**2*F(l) ARE ALSO
!     calculated.
! ----------------------------------------------------------------------
complex :: an, cn, en, s1, s2, s3, s4, s5, s6, s7, w
real :: ln4
!     ------------------
data hpi /1.5707963267949/
data ln4 /1.3862943611199/
! ---------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1 + eps .GT. 1.
!
                eps = spmpar(1)
!
! ---------------
!
!            The logarithmic expansions are used for F(K) and E(K)
!            and the Maclaurin expansions for F(l) and E(l)
!
tol = amax1(eps,1.e-14)
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
   if (abs(real(an)) + abs(aimag(an)) .lt. tol) go to 20
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
if (x .ne. 0.0) go to 30
   w = cmplx(ln4 - alog(abs(y)), hpi)
   go to 50
!
30 if (abs(x) .gt. abs(y)) go to 31
   u = (ln4 - 0.5*alnrel((x/y)**2)) - alog(abs(y))
   go to 40
31 u = (ln4 - 0.5*alnrel((y/x)**2)) - alog(abs(x))
!
40 if (x .gt. 0.0) go to 41
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
gk = -w*s7*l2 -s4 + s5 + s2*l2
gl = hpi*s7*l2
return
end subroutine ekl

subroutine ellpi (phi, cphi, k, l, f, e, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: cphi
real, intent(inout) :: e, f
real, intent(in) :: phi
real :: an, cn, d1, d2, d3, d4, dn, hn, p, pn, px, qn, qx, r, r0, &
&r2, ri, rj, rk, rm, rn, s0, s1, s2, s3, s4, si, sj, sk, sn, ss, &
&t1, t2, td, th1, tr, ts, w
real :: alnrel
real :: cpabs
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
!     f = ELLIPTIC INTEGRAL OF FIRST KIND = f(phi, k)
!     e = ELLIPTIC INTEGRAL OF SECOND KIND = e(phi, k)
!     ierr = ERROR INDICATOR (ierr = 0  IF NO ERRORS)
!-----------------------------------------------------------------------
real, intent(in) :: k, l
real :: k2, l2, ln4
!------------------------
!     ln4 = ln(4)
!     th1 = tanh(1)
!------------------------
data ln4/1.3862943611199/
data th1/.76159415595576/
!------------------------
if (phi .lt. 0.0 .or. cphi .lt. 0.0) go to 100
if (abs(k) .gt. 1.0 .or. abs(l) .gt. 1.0) go to 110
ierr = 0
if (phi .ne. 0.0) go to 10
   f = 0.0
   e = 0.0
   return
!
10 if (phi .lt. 0.79) go to 11
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
if (px .ge. th1) go to 50
!
!     SERIES EXPANSION FOR abs(k*sin(phi)) .LE. TANH(1)
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
r  = k2*hn/qn
s2 = s2 + r*an
hn = pn*r
s0 = s1
s1 = s1 + hn*an
if (abs(tr) .lt. abs(an)) go to 40
if (abs(s1) .le. abs(s0)) go to 40
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
!     SERIES EXPANSION FOR abs(k*sin(phi)) .GT. TANH(1)
!
50 r = cpabs(l,qx)
if (r .eq. 0.0) go to 120
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
if (s3 .lt. r0) go to 60
!
w = 1.0 + px
p = ln4 - alog(r + qx)
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

subroutine dellpi (phi, cphi, k, l, f, e, ierr)
implicit none
integer, intent(inout) :: ierr
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
!     f = ELLIPTIC INTEGRAL OF FIRST KIND = f(phi, k)
!     e = ELLIPTIC INTEGRAL OF SECOND KIND = e(phi, k)
!     ierr = ERROR INDICATOR (ierr = 0  IF NO ERRORS)
!-----------------------------------------------------------------------
double precision, intent(in) :: phi, cphi, k, l
double precision, intent(inout) :: f, e
double precision :: an, cn, dn, d1, d2, d3, d4, hn, k2, l2, ln4, &
&p, pn, px, qn, qx, r, ri, rj, rk, rm, rn, r0, r2, si, sj, sk, sn, &
&ss, s0, s1, s2, s3, s4, td, th1, tr, ts, t1, t2, w
double precision :: dlnrel, dcpabs
!------------------------
!     ln4 = ln(4)
!     th1 = tanh(1)
!------------------------
data ln4 /.1386294361119890618834464242916353136151d+01/
data th1 /.7615941559557648881194582826047935904128d+00/
!------------------------
if (phi .lt. 0.d0 .or. cphi .lt. 0.d0) go to 100
if (dabs(k) .gt. 1.d0 .or. dabs(l) .gt. 1.d0) go to 110
ierr = 0
if (phi .ne. 0.d0) go to 10
   f = 0.d0
   e = 0.d0
   return
!
10 if (phi .lt. 0.79d0) go to 11
   sn = dcos(cphi)
   cn = dsin(cphi)
   go to 20
11 sn = dsin(phi)
cn = dcos(phi)
!
20 k2 = k*k
l2 = l*l
ss = sn*sn
px = dabs(k*sn)
qx = dabs(k*cn)
if (px .ge. th1) go to 50
!
!     SERIES EXPANSION FOR abs(k*sin(phi)) .LE. TANH(1)
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
r  = k2*hn/qn
s2 = s2 + r*an
hn = pn*r
s0 = s1
s1 = s1 + hn*an
if (dabs(tr) .lt. dabs(an)) go to 40
if (dabs(s1) .le. dabs(s0)) go to 40
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
!     SERIES EXPANSION FOR abs(k*sin(phi)) .GT. TANH(1)
!
50 r = dcpabs(l,qx)
if (r .eq. 0.d0) go to 120
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
if (s3 .lt. r0) go to 60
!
w = 1.d0 + px
p = ln4 - dlog(r + qx)
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

subroutine epi (phi, cphi, k2, l2, n, m, p, ierr)
implicit none
integer, intent(inout) :: ierr
!-----------------------------------------------------------------------
!             Real elliptic integral of the third kind
!-----------------------------------------------------------------------
real, intent(in) :: phi, cphi, k2, l2, n, m
real, intent(inout) :: p
real :: a, b, c, eps, pihalf, r, rf, s, s2, tol
real :: spmpar
!---------------------
data pihalf /1.5707963267948966192/
!-----------------------------------------------------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0.
!
                eps = spmpar(1)
!
!-----------------------------------------------------------------------
tol = 4.0 * eps
if (amin1(phi,cphi) .lt. 0.0) go to 100
if (abs((phi + cphi) - pihalf) .gt. tol * pihalf) go to 100
if (abs(n) .gt. 1.0) go to 110
if (k2 .lt. 0.0 .or. l2 .lt. 0.0) go to 120
if (abs((k2 + l2) - 1.0) .gt. tol) go to 120
!
if (phi .lt. 0.79) go to 10
    s = cos(cphi)
    c = sin(cphi)
    go to 11
10 s = sin(phi)
c = cos(phi)
11 a = c*c
b = l2 + k2*a
s2 = s*s
!
if (n .gt. 0.0) go to 20
    r = 1.0 - n*s2
    go to 30
20 if (m .lt. 0.0 .or. m .gt. 1.0) go to 110
if (abs((m + n) - 1.0) .gt. tol) go to 110
r = m + n*a
!
30 call rjval (a, b, 1.0, r, p, ierr)
if (ierr .ne. 0) go to 130
p = p * (s * s2) * n/3.0
call rfval (a, b, 1.0, rf, ierr)
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

subroutine depi (phi, cphi, k2, l2, n, m, p, ierr)
implicit none
integer, intent(inout) :: ierr
!-----------------------------------------------------------------------
!               Double precision computation of the
!             real elliptic integral of the third kind
!-----------------------------------------------------------------------
double precision, intent(in) :: phi, cphi, k2, l2, n, m
double precision, intent(inout) :: p
double precision :: a, b, c, eps, pihalf, r, rf, s, s2, tol
double precision :: dpmpar
!---------------------
data pihalf /1.570796326794896619231321691639751442099d0/
!-----------------------------------------------------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0.
!
                eps = dpmpar(1)
!
!-----------------------------------------------------------------------
tol = 4.d0 * eps
if (dmin1(phi,cphi) .lt. 0.d0) go to 100
if (dabs((phi + cphi) - pihalf) .gt. tol * pihalf) go to 100
if (dabs(n) .gt. 1.d0) go to 110
if (k2 .lt. 0.d0 .or. l2 .lt. 0.d0) go to 120
if (dabs((k2 + l2) - 1.d0) .gt. tol) go to 120
!
if (phi .lt. 0.79d0) go to 10
    s = dcos(cphi)
    c = dsin(cphi)
    go to 11
10 s = dsin(phi)
c = dcos(phi)
11 a = c*c
b = l2 + k2*a
s2 = s*s
!
if (n .gt. 0.d0) go to 20
    r = 1.d0 - n*s2
    go to 30
20 if (m .lt. 0.d0 .or. m .gt. 1.d0) go to 110
if (dabs((m + n) - 1.d0) .gt. tol) go to 110
r = m + n*a
!
30 call drjval (a, b, 1.d0, r, p, ierr)
if (ierr .ne. 0) go to 130
p = p * (s * s2) * n/3.d0
call drfval (a, b, 1.d0, rf, ierr)
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

subroutine rfval (x, y, z, rf, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the first kind
!
!          rf(x,y,z) = INTEGRAL FROM ZERO TO INFINITY OF
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
real :: c1, c2, c3, e2, e3, epslon, errtol, lamda
real :: lolim, mu, s, uplim
real, intent(in) :: x
real :: xn, xndev, xnroot
real, intent(in) :: y
real :: yn, yndev, ynroot
real, intent(in) :: z
real :: zn, zndev, znroot
real :: spmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x, y, OR z IS NEGATIVE.
!               ierr = 2  x+y, x+z, OR y+z IS TOO SMALL.
!               ierr = 3  x, y, OR z IS TOO LARGE.
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
if (amin1(x,y,z) .lt. 0.0) go to 100
if (amin1(x+y,x+z,y+z) .lt. lolim) go to 110
if (amax1(x,y,z) .gt. uplim) go to 120
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
epslon = amax1(abs(xndev),abs(yndev),abs(zndev))
if (epslon .lt. errtol) go to 20
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

subroutine drfval (x, y, z, rf, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the first kind
!
!          rf(x,y,z) = INTEGRAL FROM ZERO TO INFINITY OF
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
double precision :: c1, c2, c3, e2, e3, epslon, errtol, lamda
double precision :: lolim, mu, s, uplim
double precision, intent(in) :: x
double precision :: xn, xndev, xnroot
double precision, intent(in) :: y
double precision :: yn, yndev, ynroot
double precision, intent(in) :: z
double precision :: zn, zndev, znroot
double precision :: dpmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x, y, OR z IS NEGATIVE.
!               ierr = 2  x+y, x+z, OR y+z IS TOO SMALL.
!               ierr = 3  x, y, OR z IS TOO LARGE.
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
if (dmin1(x,y,z) .lt. 0.d0) go to 100
if (dmin1(x+y,x+z,y+z) .lt. lolim) go to 110
if (dmax1(x,y,z) .gt. uplim) go to 120
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
epslon = dmax1(dabs(xndev),dabs(yndev),dabs(zndev))
if (epslon .lt. errtol) go to 20
xnroot = dsqrt(xn)
ynroot = dsqrt(yn)
znroot = dsqrt(zn)
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
rf = s / dsqrt(mu)
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

subroutine rdval (x, y, z, rd, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the second kind
!
!          rd(x,y,z) = INTEGRAL FROM ZERO TO INFINITY OF
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
real :: c1, c2, c3, c4, ea, eb, ec, ed, ef, epslon, errtol, lamda
real :: lolim, mu, power4, sigma, s1, s2, uplim
real, intent(in) :: x
real :: xn, xndev
real :: xnroot
real, intent(in) :: y
real :: yn, yndev, ynroot
real, intent(in) :: z
real :: zn, zndev, znroot
real :: spmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x, y, OR z IS NEGATIVE.
!               ierr = 2  x+y OR z IS TOO SMALL.
!               ierr = 3  x, y, OR z IS TOO LARGE.
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
!          lolim IS NOT LESS THAN 2 / (MACHINE MAXIMUM) ** (2/3).
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
if (amin1(x,y,z) .lt. 0.0) go to 100
if (amin1(x+y,z) .lt. lolim) go to 110
if (amax1(x,y,z) .gt. uplim) go to 120
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
epslon = amax1(abs(xndev),abs(yndev),abs(zndev))
if (epslon .lt. errtol) go to 20
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

subroutine drdval (x, y, z, rd, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the second kind
!
!          rd(x,y,z) = INTEGRAL FROM ZERO TO INFINITY OF
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
double precision :: c1, c2, c3, c4, ea, eb, ec, ed, ef, epslon, &
&errtol, lamda
double precision :: lolim, mu, power4, sigma, s1, s2, uplim
double precision, intent(in) :: x
double precision :: xn, xndev
double precision :: xnroot
double precision, intent(in) :: y
double precision :: yn, yndev, ynroot
double precision, intent(in) :: z
double precision :: zn, zndev, znroot
double precision :: dpmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x, y, OR z IS NEGATIVE.
!               ierr = 2  x+y OR z IS TOO SMALL.
!               ierr = 3  x, y, OR z IS TOO LARGE.
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
!          lolim IS NOT LESS THAN 2 / (MACHINE MAXIMUM) ** (2/3).
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
if (dmin1(x,y,z) .lt. 0.d0) go to 100
if (dmin1(x+y,z) .lt. lolim) go to 110
if (dmax1(x,y,z) .gt. uplim) go to 120
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
epslon = dmax1(dabs(xndev),dabs(yndev),dabs(zndev))
if (epslon .lt. errtol) go to 20
xnroot = dsqrt(xn)
ynroot = dsqrt(yn)
znroot = dsqrt(zn)
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
rd = 3.d0 * sigma + power4 * (1.d0 + s1 + s2) / (mu * dsqrt(mu))
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

subroutine rjval (x, y, z, p, rj, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the third kind
!
!          rj(x,y,z,p) = INTEGRAL FROM ZERO TO INFINITY OF
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
real :: rc, alfa, beta, c1, c2, c3, c4, ea, eb, ec, e2, e3
real :: epslon, errtol, etolrc, lamda, lolim, mu
real, intent(in) :: p
real :: pn, pndev
real :: power4, sigma, s1, s2, s3, uplim
real, intent(in) :: x
real :: xn, xndev
real :: xnroot
real, intent(in) :: y
real :: yn, yndev, ynroot
real, intent(in) :: z
real :: zn, zndev, znroot
real :: spmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x, y, z, OR p IS NEGATIVE.
!               ierr = 2  x+y, x+z, y+z, OR p IS TOO SMALL.
!               ierr = 3  x, y, z, OR p IS TOO LARGE.
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
!          IS LESS THAN 3 * errtol ** 6 / (1 - errtol) ** 3/2.
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
if (amin1(x,y,z,p) .lt. 0.0) go to 100
if (amin1(x+y,x+z,y+z,p) .lt. lolim) go to 110
if (amax1(x,y,z,p) .gt. uplim) go to 120
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
epslon = amax1(abs(xndev),abs(yndev),abs(zndev),abs(pndev))
if (epslon .lt. errtol) go to 20
xnroot = sqrt(xn)
ynroot = sqrt(yn)
znroot = sqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
alfa = pn * (xnroot + ynroot + znroot) + xnroot * ynroot * znroot
alfa = alfa * alfa
beta = pn * (pn + lamda) * (pn + lamda)
call rcval1 (alfa, beta, etolrc, rc, ierr)
if (ierr .ne. 0) return
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

subroutine drjval (x, y, z, p, rj, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the incomplete elliptic integral
!          of the third kind
!
!          rj(x,y,z,p) = INTEGRAL FROM ZERO TO INFINITY OF
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
double precision :: rc, alfa, beta, c1, c2, c3, c4, ea, eb, ec, &
&e2, e3
double precision :: epslon, errtol, etolrc, lamda, lolim, mu
double precision, intent(in) :: p
double precision :: pn, pndev
double precision :: power4, sigma, s1, s2, s3, uplim
double precision, intent(in) :: x
double precision :: xn, xndev
double precision :: xnroot
double precision, intent(in) :: y
double precision :: yn, yndev, ynroot
double precision, intent(in) :: z
double precision :: zn, zndev, znroot
double precision :: dpmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x, y, z, OR p IS NEGATIVE.
!               ierr = 2  x+y, x+z, y+z, OR p IS TOO SMALL.
!               ierr = 3  x, y, z, OR p IS TOO LARGE.
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
!          IS LESS THAN 3 * errtol ** 6 / (1 - errtol) ** 3/2.
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
if (dmin1(x,y,z,p) .lt. 0.d0) go to 100
if (dmin1(x+y,x+z,y+z,p) .lt. lolim) go to 110
if (dmax1(x,y,z,p) .gt. uplim) go to 120
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
epslon = dmax1(dabs(xndev),dabs(yndev),dabs(zndev),dabs(pndev))
if (epslon .lt. errtol) go to 20
xnroot = dsqrt(xn)
ynroot = dsqrt(yn)
znroot = dsqrt(zn)
lamda = xnroot * (ynroot + znroot) + ynroot * znroot
alfa = pn * (xnroot + ynroot + znroot) + xnroot * ynroot * znroot
alfa = alfa * alfa
beta = pn * (pn + lamda) * (pn + lamda)
call drcvl1 (alfa, beta, etolrc, rc, ierr)
if (ierr .ne. 0) return
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
rj = 3.d0 * sigma + power4 * (s1 + s2 + s3) / (mu * dsqrt(mu))
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

subroutine rcval1 (x, y, errtol, rc, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the integral
!
!          rc(x,y) = INTEGRAL FROM ZERO TO INFINITY OF
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
real :: c1, c2
real, intent(in) :: errtol
real :: lamda, lolim
real :: mu, s, sn, uplim
real, intent(in) :: x
real :: xn
real, intent(in) :: y
real :: yn
real :: spmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x OR y IS NEGATIVE, OR y = 0.
!               ierr = 2  x+y IS TOO SMALL.
!               ierr = 3  x OR y IS TOO LARGE.
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (x .lt. 0.0 .or. y .le. 0.0) go to 100
if ((x + y) .lt. lolim) go to 110
if (amax1(x,y) .gt. uplim) go to 120
!
ierr = 0
xn = x
yn = y
!
10 mu = (xn + yn + yn) / 3.0
sn = (yn + mu) / mu - 2.0
if (abs(sn) .lt. errtol) go to 20
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

subroutine drcvl1 (x, y, errtol, rc, ierr)
implicit none
!-----------------------------------------------------------------------
!
!          This subroutine computes the integral
!
!          rc(x,y) = INTEGRAL FROM ZERO TO INFINITY OF
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
double precision :: c1, c2
double precision, intent(in) :: errtol
double precision :: lamda, lolim
double precision :: mu, s, sn, uplim
double precision, intent(in) :: x
double precision :: xn
double precision, intent(in) :: y
double precision :: yn
double precision :: dpmpar
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
!               ierr = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
!               ierr = 1  x OR y IS NEGATIVE, OR y = 0.
!               ierr = 2  x+y IS TOO SMALL.
!               ierr = 3  x OR y IS TOO LARGE.
!
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
!
if (x .lt. 0.d0  .or.  y .le. 0.d0) go to 100
if ((x + y) .lt. lolim) go to 110
if (dmax1(x,y) .gt. uplim) go to 120
!
ierr = 0
xn = x
yn = y
!
10 mu = (xn + yn + yn) / 3.d0
sn = (yn + mu) / mu - 2.d0
if (dabs(sn) .lt. errtol) go to 20
lamda = 2.d0 * dsqrt(xn) * dsqrt(yn) + yn
xn = (xn + lamda) * 0.25d0
yn = (yn + lamda) * 0.25d0
go to 10
!
20 c1 = 1.d0 / 7.d0
c2 = 9.d0 / 22.d0
s = sn * sn * (0.3d0 + sn * (c1 + sn * (0.375d0 + sn * c2)))
rc = (1.d0 + s) / dsqrt(mu)
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

subroutine ellpf(u,k,l,s,c,d,ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(inout) :: c, d, s
real, intent(in) :: u
integer :: max, n
real :: e, eps, f, f2, pihalf, r, sg, tol, u1, u2, z
integer :: ipmpar
real :: spmpar
!     -------------------------------------------------------------
!     ellpf calculates the elliptic functions sn(u,k), CN(u,k), and
!     DN(u,k) for real u and real modulus k.  it is assumed that
!     abs(k) .LE. 1. AND k**2 + l**2 = 1.
!     -------------------------------------------------------------
real, intent(in) :: k, l
data pihalf /1.5707963267949/
!     ----------------
!     ****** max AND EPS ARE MACHINE DEPENDENT CONSTANTS.
!            Max is the largest positive integer that may
!            be used, and eps is the smallest real number
!            FOR WHICH 1 + eps .GT. 1.
!
              max = ipmpar(3)
              eps = spmpar(1)
!
!     ----------------
!     CALCULATION FOR l = 0.0
!
if (l .ne. 0.0) go to 10
s = tanh(u)
e = exp(-abs(u))
c = 2.0*e/(1.0 + e*e)
d = c
ierr = 0
return
!
!     CHECK THAT k**2 + l**2 = 1
!
10 tol = 2.0*eps
z = dble(k*k) + (dble(l*l) - 1.d0)
if (abs(z) .gt. tol) go to 100
!
f = pihalf
if (k .ne. 0.0) call ellpi(pihalf,0.0,k,l,f,e,ierr)
f2 = 2.0*f
!
!                   Argument reduction
!
u1 = abs(u)
r = u1/f2
if (r .ge. amin1(float(max),1.0/eps)) go to 110
n = int(r)
u1 = u1 - float(n)*f2
sg = 1.0
if (mod(n,2) .ne. 0) sg = -1.0
!
if (u1 .le. 0.0) go to 30
if (u1 .le. f) go to 20
u1 = u1 - f2
sg = -sg
if (u1 .ge. 0.0) go to 30
!
!     CALCULATION OF ELLIPTIC FUNCTIONS FOR 0.0 .LE. u2 .LE. f(k)
!
20 u2 = abs(u1)
call scd (u2,abs(k),abs(l),f,s,c,d)
ierr = 0
if (u1 .lt. 0.0) s = -s
!
!     Final assembly
!
s = sg*s
c = sg*c
if (u .lt. 0.0) s = -s
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

subroutine scd(u,k,l,f,s,c,d)
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f
real, intent(inout) :: s
real, intent(in) :: u
integer :: ierr
real :: c1, d1, e1, f1, pihalf, s1, v
!     --------------------------------------------------------
!     scd computes the elliptic functions sn(u,k), CN(u,k),
!     and DN(u,k) for real u and real modulus k such that
!     0.0 .LE. u .LE. f AND 0.0 .LE. k .LT. 1.0, WHERE
!     f = f(k) IS THE COMPLETE ELLIPTIC INTEGRAL OF THE
!     FIRST KIND, AND f1 = f(l) IS THE COMPLEMENTARY INTEGRAL.
!     IT IS ASSUMED THAT k**2 + l**2 = 1.
!     --------------------------------------------------------
real, intent(in) :: k, l
data pihalf /1.5707963267949/
!     ------------------------
if (k .eq. 0.0) go to 40
v = f - u
!
!     USES MACLAURIN EXPANSION WHEN u OR v .LE. 0.01
!
if (u .gt. 0.01) go to 10
   call scdm (u,k,s,c,d)
   return
10 if (v .gt. 0.01) go to 20
call scdm (v,k,s1,c1,d1)
s = c1/d1
c = l*s1/d1
d = l/d1
return
!
!     USES FOURIER EXPANSION WHEN k .LE. l
!
20 call ellpi(pihalf,0.0,l,k,f1,e1,ierr)
!
if (k .gt. l) go to 30
call scdf (u,k,l,f,f1,s,c,d)
return
!
!     Uses imaginary transformation of Jacobi and Fourier
!     EXPANSION WHEN k .GT. l
!
30 call scdj (u,k,l,f,f1,s,c,d)
return
!
!     COMPUTATION FOR k = 0.0
!
40 s = sin(u)
c = cos(u)
d = 1.0
return
end subroutine scd

subroutine scdm(u,k,s,c,d)
implicit none
real, intent(out) :: c, d, s
real, intent(in) :: u
real :: c1, c2, c3, c4, u2
!     -------------------------------------------------
!     Calculates SN(u,k), CN(u,k), and DN(u,k) for
!     0.0 .LE. u .LE. 0.01 AND FOR 0.0 .LE. k .LE. 1.0
!     by use of the Maclaurin expansion for SN(u,k)
!     -------------------------------------------------
real, intent(in) :: k
real :: k2
!
k2 = k*k
u2 = u*u
c1 = -(1.0 + k2)/6.0
c2 = (1.0 + k2*(14.0 + k2))/120.0
c3 = -(1.0 + k2*(135.0 + k2*(135.0 + k2)))/5040.0
c4 = (1.0 + k2*(1228.0 + k2*(5478.0 + k2*(1228.0 + k2))))/ &
&362880.0
s = u*(1.0 + u2*(c1 + u2*(c2 + u2*(c3 + c4*u2))))
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
return
end subroutine scdm

subroutine scdf(u,k,l,f,f1,s,c,d)
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f, f1
real, intent(inout) :: s
real, intent(in) :: u
real :: a, ai, coef, eps, pihalf, q1, q2, qd, qh, qn, sum, temp, &
&tol, v, w, x
real :: spmpar
!     -------------------------------------------------------------
!     scdf computes SN(u,k), CN(u,k), and DN(u,k) for real u and
!     k by use of the Fourier expansion for SN(u,k).  It is
!     ASSUMED THAT 0.0 .LE. k .LT. 1.0 AND 0.0 .LE. u .LE. f,
!     WHERE f = f(k) IS THE COMPLETE ELLIPTIC INTEGRAL OF THE
!     FIRST KIND AND f1 = f(l) IS THE COMPLEMENTARY INTEGRAL, WITH
!     l .NE. 0. AND k**2 + l**2 = 1.
!     -------------------------------------------------------------
real :: i
real, intent(in) :: k, l
data pihalf /1.5707963267949/
!     -------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the
!     SMALLEST NUMBER SUCH THAT 1. + eps .GT. 1.
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
w = amin1(u,v)
x = pihalf*w/f
!
!     CALCULATION OF SERIES FOR W = AMIN1(u,V)
!
i = 1.0
sum = 0.0
10 ai = qn/(1.0 - qd)
a = ai*sin(i*x)
sum = sum + a
if (abs(ai) .lt. tol*abs(sum)) go to 20
qn = qn*q1
qd = qd*q2
i = i + 2.0
go to 10
!
!     ASSEMBLY FOR u .LE. V
!
20 s = coef*sum
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
if (u .eq. w) return
!
!     ASSEMBLY FOR u .GT. V
!
temp = s
s = c/d
c = l*temp/d
d = l/d
return
end subroutine scdf

subroutine scdj(u,k,l,f,f1,s,c,d)
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f, f1
real, intent(inout) :: s
real, intent(in) :: u
real :: a, ch, coef, e1, e1n, e2, e2n, eps, pi, pihalf, q1, q1n, &
&q2, q2n, sh, sum, temp, tol, v, w, x, x2, xn
real :: spmpar
!     ----------------------------------------------------------------
!     scdj computes SN(u,k), CN(u,k), and DN(u,k) for real u and
!     k using the imaginary transformation of Jacobi and A
!     FOURIER EXPANSION.  IT IS ASSUMED THAT 0.0 .LE. k .LT. 1.0
!     AND 0.0 .LE. u .LE. f, WHERE f = f(k) IS THE COMPLETE ELLIPTIC
!     INTEGRAL OF THE FIRST KIND AND f1 = f(l) IS THE COMPLEMENTARY
!     INTEGRAL, AND THAT l .NE. 0. AND k**2 + l**2 = 1.
!     ----------------------------------------------------------------
real, intent(in) :: k, l
real :: n
data pihalf /1.5707963267949/
data pi /3.1415926535898/
!     ------------------------------------------------
!     Eps is a machine dependent constant.  Eps is the
!     SMALLEST NUMBER SUCH THAT 1. + eps .GT. 1.
!
eps = spmpar(1)
!
!     ------------------------------------------------
tol = eps/10.0
v = f - u
q1 = -exp(-pi*f/f1)
q2 = q1*q1
!
w = amin1(u,v)
e1 = pi*amax1(u,v)/f1
e2 = pi*(f + w)/f1
e1 = exp(-e1)
e2 = exp(-e2)
!
coef = pihalf/(k*f1)
x = pihalf*w/f1
x2 = 2.0*x
!
!     CALCULATION OF SERIES FOR W = AMIN1(u,V)
!
n = 1.0
q1n = q1
q2n = q2
e1n = e1
e2n = e2
sum = 0.0
!
20 xn = n*x2
if (xn .gt. 1.0) go to 30
   call snhcsh(sh,ch,xn,-1)
   sh = sh + xn
   a = 2.0*q1n*abs(q1n)*sh/(1.0 + q2n)
   go to 40
30 a = q1n*(e1n - e2n)/(1.0 + q2n)
40 sum = sum + a
if (abs(a) .lt. tol*abs(sum)) go to 50
q1n = q1n*q1
q2n = q2n*q2
e1n = e1n*e1
e2n = e2n*e2
n = n + 1.0
go to 20
!
!     ASSEMBLY FOR u .LE. V
!
50 s = coef*(tanh(x) + 2.0*sum)
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
if (u .eq. w) return
!
!     ASSEMBLY FOR u .GT. V
!
temp = s
s = c/d
c = l*temp/d
d = l/d
return
end subroutine scdj

subroutine elpfc1 (u,k,l,s,c,d,ierr)
implicit none
integer, intent(inout) :: ierr
real :: c1, c2, ck, cl, coef, d1, d2, dk, dl, r, s1, s2, sk, sl, &
&t, t1, t2, td1, td2, u1, u2
!     -------------------------------------------------------------
!     elpfc1 calculates the elliptic functions sn(u,k), CN(u,k),
!     DN(u,k) for complex u and real modulus k.  it is assumed that
!     abs(k) .LE. 1. AND k**2 + l**2 = 1.
!     -------------------------------------------------------------
complex, intent(in) :: u
complex, intent(inout) :: s, c, d
real, intent(in) :: k, l
real :: k2
!
u1 = real(u)
u2 = aimag(u)
k2 = k*k
if (u1 .eq. 0.0) go to 10
if (u2 .ne. 0.0) go to 20
!
!     CALCULATION FOR U2 = 0.
!
call ellpf (u1,k,l,s1,c1,d1,ierr)
if (ierr .ne. 0) return
s2 = 0.0
c2 = 0.0
d2 = 0.0
go to 40
!
!     CALCULATION FOR U1 = 0.
!
10 call ellpf (u2,l,k,s2,c2,d2,ierr)
if  (ierr .ne. 0) return
if (c2 .eq. 0.0) go to 50
s1 = 0.0
s2 = s2/c2
d1 = d2/c2
d2 = 0.0
c1 = 1.0/c2
c2 = 0.0
go to 40
!
!     CALCULATION FOR U1 AND U2 .NE. 0.
!
20 call ellpf (u1,k,l,sk,ck,dk,ierr)
if (ierr .ne. 0) return
call ellpf (u2,l,k,sl,cl,dl,ierr)
if (ierr .ne. 0) return
coef = abs(k)*sl
t1 = cl
t2 = coef*sk
td1 = coef*t1
td2 = coef*t2
if (abs(t2) .le. abs(t1)) go to 30
if (t2 .eq. 0.0) go to 50
if (td2 .eq. 0.0) go to 50
t = t1/t2
r = 1.0/(1.0 + t*t)
s1 = dl*r/td2
s2 = ck*dk*sl*t*r/t2
c1 = ck*t*r/t2
c2 = -dk*sl*dl*r/td2
d1 = dk*dl*t*r/t2
d2 = -k2*ck*sl*r/td2
go to 40
30 if (t1 .eq. 0.0) go to 50
if (td1 .eq. 0.0) go to 50
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

subroutine peq(z, w, ierr)
implicit none
!
!     Weierstrass P-function in the equianharmonic case
!     for complex argument with unit period parallelogram
!
complex, intent(in) :: z
complex :: z1, z4, z6
complex, intent(inout) :: w
real :: zr, zi
integer, intent(inout) :: ierr
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zi = 1.1547005383792515e0*aimag(z) + 0.5e0
m = int(zi)
if (zi.lt.0e0) m = m - 1
zr = real(z) - 0.5e0*float(m) + 0.5e0
n = int(zr)
if (zr.lt.0e0) n = n - 1
z1 = z - float(n) - (0.5e0,0.86602540378443865e0)*float(m)
!
!     IF z1=0 THEN z COINCIDES WITH A LATTICE POINT.
!     The lattice points are poles for P.
!
w = z1*z1
zr = abs(real(w)) + abs(aimag(w))
if (zr.ne.0e0) go to 10
ierr = 1
return
!
!     Evaluation of P(z1)
!
10 ierr = 0
z4 = w*w
z6 = z4*w
w = 1e0/w + 6e0*z4*(5e0+z6)/(1e0-z6)**2 + z4* &
&(((((-2.6427662e-10*z6+1.610954818e-8)*z6+7.38610752879e-6)* &
&z6+4.3991444671178e-4)*z6+7.477288220490697e-2)* &
&z6-6.8484153287299201e-1)/(((((6.2252191e-10*z6+2.553314573e-7)* &
&z6-2.619832920421e-5)*z6-5.6444801847646e-4)* &
&z6+4.565553484820106e-2)*z6+1e0)
return
end subroutine peq

subroutine peq1(z, w, ierr)
implicit none
!
!     First derivative of Weierstrass P-function in the
!     equianharmonic case for complex argument
!     with unit period parallelogram
!
complex, intent(in) :: z
complex :: z1, z3, z6
complex, intent(inout) :: w
real :: zr, zi
integer, intent(inout) :: ierr
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zi = 1.1547005383792515e0*aimag(z) + 0.5e0
m = int(zi)
if (zi.lt.0e0) m = m - 1
zr = real(z) - 0.5e0*float(m) + 0.5e0
n = int(zr)
if (zr.lt.0e0) n = n - 1
z1 = z - float(n) - (0.5e0,0.86602540378443865e0)*float(m)
!
!     IF z1=0 THEN z COINCIDES WITH A LATTICE POINT.
!     The lattice points are poles for DP.
!
z3 = z1*z1*z1
z6 = z3*z3
w = z3*(1e0-z6)**3
zr = abs(real(w)) + abs(aimag(w))
if (zr.ne.0e0) go to 10
ierr = 1
return
!
!     Evaluation of DP(z1)
!
10 ierr = 0
w = (((14e0*z6+294e0)*z6+126e0)*z6-2e0)/w + &
&z3*((((((-2.95539175e-9*z6-2.6764693031e-7)*z6+2.402192743346e-5) &
&*z6+1.9656661451391e-4)*z6+1.760135529461036e-2)* &
&z6+8.1026243498822636e-1)*z6-2.73936613149196804e0)/ &
&((((((4.6397763e-10*z6+5.413482233e-8)*z6-1.56293298374e-6)* &
&z6-1.0393701076352e-4)*z6+9.5553182532237e-4)* &
&z6+9.131106969640212e-2)*z6+1e0)
return
end subroutine peq1

subroutine plem(z, w, ierr)
implicit none
!
!     Weierstrass P-function in the lemniscatic case
!     for complex argument with unit period parallelogram
!
complex, intent(in) :: z
complex :: z1, z4, z6
complex, intent(inout) :: w
real :: zr, zi
integer, intent(inout) :: ierr
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zr = real(z) + 0.5e0
zi = aimag(z) + 0.5e0
m = int(zr)
n = int(zi)
if (zr.lt.0e0) m = m - 1
if (zi.lt.0e0) n = n - 1
z1 = z - float(m) - (0e0,1e0)*float(n)
!
!     IF z1=0 THEN z COINCIDES WITH A LATTICE POINT.
!     The lattice points are poles for P.
!
w = z1*z1
zr = abs(real(w)) + abs(aimag(w))
if (zr.ne.0e0) go to 10
ierr = 1
return
!
!     Evaluation of P(z1)
!
10 ierr = 0
z4 = w*w
z6 = z4*w
w = 1e0/w + 4e0*w*(3e0+z4)/(1e0-z4)**2 + &
&w*((((((((-7.233108e-11*z4+1.714197273e-8)*z4-2.5369036492e-7)* &
&z4-7.98710206868e-6)*z4+6.4850606909737e-4)*z4+7.39624629362938e-3)*z4+2.012382768497244e-2)*z4+7.1177297543136598e-1)* &
&z4-2.54636399353830738e0)/((((((((5.1161516e-10*z4+6.61289408e-9) &
&*z4+4.4618987048e-7)*z4-8.42694918892e-6)*z4+4.42886829095e-6)* &
&z4-4.22629935217101e-3)*z4+2.577496871700433e-2)* &
&z4+4.2359940482277074e-1)*z4+1e0)
return
end subroutine plem

subroutine plem1(z, w, ierr)
implicit none
!
!     First derivative of Weierstrass P-function in the
!     lemniscatic case for complex argument
!     with unit period parallelogram
!
complex, intent(in) :: z
complex :: z1, z3, z4
complex, intent(inout) :: w
real :: zr, zi
integer, intent(inout) :: ierr
integer :: m, n
!
!     Reduction to fundamental parallelogram
!
zr = real(z) + 0.5e0
zi = aimag(z) + 0.5e0
m = int(zr)
n = int(zi)
if (zr.lt.0e0) m = m - 1
if (zi.lt.0e0) n = n - 1
z1 = z - float(m) - (0e0,1e0)*float(n)
!
!     IF z1=0 THEN z COINCIDES WITH A LATTICE POINT.
!     The lattice points are poles for DP.
!
z3 = z1*z1*z1
z4 = z3*z1
w = (z1*(1e0-z4))**3
zr = abs(real(w)) + abs(aimag(w))
if (zr.ne.0e0) go to 10
ierr = 1
return
!
!     Evaluation of DP(z1)
!
10 ierr = 0
w = (((1e1*z4+9e1)*z4+3e1)*z4-2e0)/w + &
&z1*((((((((((-3.9046302e-9*z4-1.001487137e-8)*z4+5.9573043092e-7) &
&*z4-2.482518130524e-5)*z4+1.4557266595395e-4)* &
&z4+4.56633655643206e-3)*z4+6.224782572111135e-2)* &
&z4+1.038527937794269e-2)*z4+1.19804620802637942e0)* &
&z4+6.42791439683811718e0)*z4-5.09272798707661477e0)/ &
&((((((((((4.726888e-11*z4-3.0667983e-9)*z4+1.0087596089e-7)* &
&z4-8.060683451e-8)*z4+1.184299251664e-5)*z4-2.3096723361547e-4)* &
&z4-2.90730903142055e-3)*z4+1.338392411135511e-2)* &
&z4+2.3098639320021426e-1)*z4+8.4719880964554148e-1)*z4+1e0)
return
end subroutine plem1

subroutine valr2(x,y,n0,p,iop,a,ind,ko)
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: iop
integer, intent(inout) :: ko
integer, intent(in) :: n0
real, intent(inout) :: a, p, x(*), y(*)
integer :: k, m, n
real :: a3d8(3), aj0, aj1, alnpi, aph1(3), aph2(3), aph4(3), b, &
&bgd1, bgd2, c, cape, caph, capv, cee, circm, cst(3), d1sq, d2sq, &
&e(5), e2(10), e3(15), f, g(2), h(2), p1, pi, psi1, rsq(3), rtpi, &
&rtpii, sum, t, t1, tau, tausq, twopi, u, v, w, xk, yk, ykm1, z
real :: erfc1
real :: spmpar
!     -------------------
real :: kom, l
!     -------------------
data pi/3.1415926535898/
data twopi/6.28318530717958/
data alnpi/1.14472988584940/
data rtpi/1.77245385090552/
data rtpii/.56418958354776/
!     -------------------
data e(1)/.885777518572895e+00/,  e(2)/-.981151952778050e+00/, &
&e(3)/.759305502082485e+00/,  e(4)/-.353644980686977e+00/, &
&e(5)/.695232092435207e-01/
data e2(1) /.886226470016632e+00/,  e2(2) /-.999950714561036e+00/, &
&e2(3) /.885348820003892e+00/,  e2(4) /-.660611239043357e+00/, &
&e2(5) /.421821197160099e+00/,  e2(6) /-.222898055667208e+00/, &
&e2(7) /.905057384150449e-01/,  e2(8) /-.254906111884287e-01/, &
&e2(9) /.430895168984138e-02/,  e2(10)/-.323377239693247e-03/
data e3(1) /.886226924931465e+00/,  e3(2) /-.999999899776252e+00/, &
&e3(3) /.886223733186722e+00/,  e3(4) /-.666626670510907e+00/, &
&e3(5) /.442851899328569e+00/,  e3(6) /-.265638206366025e+00/, &
&e3(7) /.145060043403014e+00/,  e3(8) /-.714909837799889e-01/, &
&e3(9) /.309199295521210e-01/,  e3(10)/-.112323532148441e-01/, &
&e3(11)/.324944543171185e-02/,  e3(12)/-.704260243309096e-03/, &
&e3(13)/.105787574480633e-03/,  e3(14)/-.971864864160461e-05/, &
&e3(15)/.408335517232165e-06/
data aph1(1)/2.02e-7/, aph1(2)/2.08e-13/, aph1(3)/2.71e-19/
data aph2(1)/1.22e-2/, aph2(2)/1.23e-4/, aph2(3)/1.34e-6/
data aph4(1)/.6962e-1/, aph4(2)/.6990e-2/, aph4(3)/.7311e-3/
data rsq(1)/6.0516/, rsq(2)/12.60605/, rsq(3)/19.201924/
data a3d8(1)/0.28125e-4/, a3d8(2)/0.285e-7/, a3d8(3)/0.32625e-10/
data cst(1)/.5625e-4/, cst(2)/.57e-7/, cst(3)/.6512e-10/
!     -------------------
!     Tau is a machine dependent tolerance. It is assumed that A
!     7 or more digit floating point arithmetic is being used.
!     -------------------
tau=2.0*spmpar(1)
if (tau.lt.3.e-11) tau=amax1(5.0*tau,1.e-14)
!     -------------------
n=n0
if (n.eq.2.or.n.lt.1) go to 4021
tausq=tau*tau
!
p=0.0
ind=0
a=0.0
kom=0.0
k=1
if (n.ne.1) go to 10
!
w=x(2)-x(1)
z=y(2)-y(1)
u=x(3)-x(1)
v=y(3)-y(1)
xk=0.0
psi1=v*w-u*z
if (psi1.ge.0.0) go to 21
!
p=-1.0
t1=w
w=u
u=t1
t1=v
v=z
z=t1
go to 21
!
10 ko=0
x(n+1)=x(1)
y(n+1)=y(1)
u=x(2)-x(1)
v=y(2)-y(1)
xk=x(1)
yk=y(1)
!
20 w=x(1)-x(n)
z=y(1)-y(n)
21 d1sq=w*w+z*z
if (d1sq.gt.tausq) go to 30
if (n.eq.1) go to 4011
n=n-1
if (n.eq.2) return
go to 20
!
30 d2sq=u*u+v*v
if (d2sq.gt.tausq) go to 40
if (n.eq.1) go to 4011
31 k=k+1
u=x(k+1)-xk
v=y(k+1)-yk
d2sq=u*u+v*v
if (d2sq.le.tausq) go to 31
if (k.eq.n-1) return
!
40 a=xk*(y(k+1)-y(n))
bgd1=sqrt(d1sq+d1sq)
bgd2=sqrt(d2sq+d2sq)
!
!             Processing vertex (XK,YK)
!
50 psi1=v*w-u*z
cee=u*w+v*z
aj0=atan2(psi1,cee)
kom=kom+aj0
l=0.0
b=.5*(x(k)*x(k)+y(k)*y(k))
if (b.gt.aph1(iop)) go to 60
p1=aj0/twopi
go to 3621
!
60 g(1)=(w*x(k)+z*y(k))/bgd1
g(2)=(u*x(k)+v*y(k))/bgd2
h(1)=(-y(k)*w+x(k)*z)/bgd1
h(2)=(-y(k)*u+x(k)*v)/bgd2
if (abs(psi1).gt.bgd1*bgd2*a3d8(iop)) go to 80
if (cee.lt.0.0) go to 70
if (abs(aj0).gt.tau.and.g(1).lt.0.0) go to 80
p1=0.0
go to 3621
!
70 if (abs(psi1).le.(.5*tau*bgd1*bgd2)) ind=2
if (psi1.lt.0.0) go to 71
p1=.5*erfc1(0,h(2))
go to 3621
71 p1=-.5*erfc1(0,h(1))
go to 3621
!
80 if (b.gt.aph2(iop)) go to 90
c=rtpi*(h(2)-h(1))-(g(2)*h(2)-g(1)*h(1))
p1=(aj0-c)/twopi
go to 3621
!
!                 Computation of l
!
90 if (g(1).lt.0.0) go to 100
if (g(2).ge.0.0) go to 130
g(2)=-g(2)
h(2)=-h(2)
if (abs(h(2)).le.aph4(iop)) go to 91
l=.5*erfc1(0,-h(2))
go to 120
91 l=.5+rtpii*h(2)
go to 120
!
100 g(1)=-g(1)
h(1)=-h(1)
if (g(2).lt.0.0) go to 110
if (abs(h(1)).le.aph4(iop)) go to 101
l=.5*erfc1(0,h(1))
go to 120
101 l=.5-rtpii*h(1)
go to 120
!
110 g(2)=-g(2)
h(2)=-h(2)
if (abs(h(1)).le.aph4(iop)) go to 112
if (abs(h(2)).le.aph4(iop)) go to 111
l=.5*(erfc1(0,h(1))-erfc1(0,h(2)))
go to 130
111 l=rtpii*h(2)-.5*erf(h(1))
go to 130
112 if (abs(h(2)).le.aph4(iop)) go to 113
l=.5*erf(h(2))-rtpii*h(1)
go to 130
113 l=rtpii*(h(2)-h(1))
go to 130
!
120 psi1=-psi1
if (psi1.le.0.0) go to 121
l=l-1.0
aj0=aj0+pi
go to 130
121 aj0=aj0-pi
!
!                 Series evaluation
!
130 if (b.ge.rsq(iop)) go to 171
cape=aj0
caph=.5*aj0
m=1
f=0.0
aj1=h(2)-h(1)
circm=aj1
if (iop-2) 140,150,160
!
140 sum=e(m)*aj1
141 m=m+1
h(1)=h(1)*g(1)
h(2)=h(2)*g(2)
t=h(2)-h(1)
f=f+b
capv=(f*cape+t)/m
sum=sum+e(m)*capv
if (m.ge.5) go to 170
cape=circm
circm=capv
go to 141
!
150 sum=e2(m)*aj1
151 m=m+1
h(1)=h(1)*g(1)
h(2)=h(2)*g(2)
t=h(2)-h(1)
f=f+b
capv=(f*cape+t)/m
sum=sum+e2(m)*capv
if (m.ge.10) go to 170
cape=circm
circm=capv
go to 151
!
160 sum=e3(m)*aj1
161 m=m+1
h(1)=h(1)*g(1)
h(2)=h(2)*g(2)
t=h(2)-h(1)
f=f+b
capv=(f*cape+t)/m
sum=sum+e3(m)*capv
if (m.ge.15) go to 170
cape=circm
circm=capv
go to 161
!
170 p1=l+exp(-(b+alnpi))*(caph-sum)
go to 3621
171 p1=l
!
!               Standard termination
!
3621 if (k.ne.n) go to 3651
if (n.ne.1) go to 3631
p=abs(p+abs(p1))
return
!
3631 p=p-p1
kom=kom/twopi
a=.5*a
if (kom.lt.0.0) go to 3641
ko=int(kom+.125)
go to 3645
3641 ko=int(kom-.125)
3645 p=p+float(ko)
return
!
!              Set up the next vertex
!
3651 w=u
z=v
bgd1=bgd2
xk=x(k+1)
yk=y(k+1)
ykm1=y(k)
3661 k=k+1
u=x(k+1)-xk
v=y(k+1)-yk
d2sq=u*u+v*v
if (d2sq.le.tausq) go to 3661
bgd2=sqrt(d2sq+d2sq)
p=p-p1
a=a+xk*(y(k+1)-ykm1)
go to 50
!
!                  Error return
!
4011 ind=1
p=5.0
return
4021 ind=3
return
end subroutine valr2

subroutine circv (r, d, j, p, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: j
real, intent(in) :: d
real, intent(out) :: p
real, intent(in) :: r
integer :: i, n
real :: a, a1, an, anm1, bk2, c0, c1, c2, c3, const, d2, delta, e, &
&eps, eps0, expt, f, s, s0, s1, s2, sum, t, t0, t2, td, tn, tr, w, &
&x, x0, y1, z, zm, zp, zr, zrs
real :: exparg
real :: erfcr
real :: rcomp
real :: rexp
real :: spmpar
!-----------------------------------------------------------------------
!       IF j .NE. 0, OUTPUT IS p = CIRCULAR COVERAGE FUNCTION. p GIVES
!       the probability of a shot falling, under a normal distribution
!       with mean (0,0) and equal standard deviations, S, in a circle
!       of radius R0, offset a distance D0 from (0,0).
!       INPUT IS r = R0/S, d = D0/S.
!
!       IF j = 0, OUTPUT IS p = GENERALIZED CIRCULAR ERROR FUNCTION.
!       p gives the probability of a shot falling ,under a normal
!       bivariate distribution with mean (0,0) and standard deviations
!       SMIN and S, in a circle of radius R0 centered at (0,0).
!       INPUT FOR j = 0, r = R0/S, d = SMIN/S .LE. 1.
!       IF SMIN = 0, S .NE. 0, p = erf(r/(SQR(2)).
!
!       IF ierr .NE. 0, SOME PORTION OF THE INPUT IS UNACCEPTABLE.
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
real :: m, m0
!-----------------------
!     c1 = 1/sqrt(2)
!     c2 = 1/sqrt(pi)
!     c3 = 2*pi
!-----------------------
data e  /2.71828182845905/
data c1 /.707106781186548/
data c2 /.564189583547756/
data c3 /6.28318530717959/
!-----------------------
  p = 0.0
  if (r .lt. 0.0) goto 115
  if (d .lt. 0.0) goto 120
  ierr = 0
  if (r .eq. 0.0) return
!
  eps0 = spmpar(1)
  z = - alog(eps0)
  if (j .ne. 0) goto 40
!------------------------------------------------------------------
!   FOR j = 0, ERROR IN d IF d .LT. 0 OR d .GT. 1
!------------------------------------------------------------------
!                j = 0
!--------------------------------------------------
  if (d .gt. 1.0) goto 120
  if (d .eq. 1.0) goto 45
  if (d .ne. 0.0) goto 5
!---------------------------------------
!          j = 0,     d = 0
!---------------------------------------
  p = erf(r*c1)
  return
!-------------------------------------------------
!   j = 0,  (r*r .gt. -2*log(eps0))  p = 1
!-------------------------------------------------
5 if (r*r .lt. 2.0*z) goto 10
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
  if (t .gt. 14.0) go to 25
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
  if (bk2 .le. 0.15) t0 = -rexp(-bk2)
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
     if (t0 .gt. eps*p) go to 20
  return
!------------------------------------------------
!   j = 0,    t .gt. 14
!------------------------------------------------
25 t = 0.25/t
  const = d2/zm
  delta = sqrt(zm)
  x = 2.0*(c1*c2)/(r*delta)
  expt = exp(-0.5*r*r)
  call erfc0 (1, c1*r, expt, m)
  m = m/delta
!
  p = 1.0
  sum = m
  an = 0.0
  if (expt*m .lt. 5.e-3) go to 30
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
     if (m .ge. m0 .or. m .lt. 0.0) go to 35
     x = anm1*f*t*x
     sum = sum + m
     if (m .gt. eps*sum) go to 30
35 p = p - expt*sum
  go to 110
!------------------------------------
!              j .NE. 0
!------------------------------------
40 a1 = r - d
  t = r*d
  if (d .ne. 0.0) go to 50
!----------------------------------------------
!     j = 0 AND d = 1, OR j .NE. 0 AND d = 0
!----------------------------------------------
45 p = -rexp(-0.5*r*r)
  return
!----------------------------------------
50 a = 0.5*(a1*a1)
  if (a1 .le. 5.0) go to 55
  if (a .le. z) go to 60
      p = 1.0
      return
55 if (a1 .lt. -5.0 .and. a .gt. -exparg(1)) return
!----------------------------------------
60 eps = 1.5e2*eps0
  if (r .ge. 1.7 .and. t .gt. 16.0) go to 75
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
      if (tn .gt. eps) go to 65
!
!       Compute the series
!
  m = n
  call gratio (m + 1.0, tr, s, w, 0)
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
  call erfc0 (1, z, w, s1)
!
  a = 0.5*z/t
  t = 0.25/t
  m = c2 - z*s1
  if (z .ge. 4.0) m = erfcr(z)
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
      if (m .le. 0.0 .or. m .ge. m0) go to 90
      s1 = s1 + m
      if (m .gt. eps*s1) go to 80
!
90 an = an + 2.0
      anm1 = an - 1.0
      x0 = x
      x = (anm1/an)*(anm1*t)*x
      if (x .ge. x0) go to 100
      s2 = s2 + x
      if (x .gt. eps*s2) go to 90
!
100 s1 = 0.5*(r + d)*s1
  s2 = c1*s2
  w = w/sqrt(r*d)
  p = 0.5*w*abs(s1 - s2)
  if (a1 .gt. 0.0) p = abs(1.0 - 0.5*w*(s1 + s2))
!
!       Termination
!
110 if (p .gt. 1.0) p = 1.0
  return
115 ierr = 1
  p = -1.0
  return
120 ierr = 2
  p = -1.0
  return
  end subroutine circv

subroutine erfc0 (ind, x, e, y)
implicit none
integer, intent(in) :: ind
real, intent(inout) :: e
real, intent(in) :: x
real, intent(inout) :: y
real :: ax, bot, c, eps, t, top
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!
!               y = erfc(x)            IF ind = 0
!               y = exp(x*x)*erfc(x)   otherwise
!
!     e IS AN INPUT/OUTPUT VARIABLE. IF e .GE. 0 THEN IT IS ASSUMED
!     THAT e = exp(-x*x). IN THIS CASE e IS NOT MODIFIED. IF e IS
!     negative then e is set to exp(-x*x) when this value is needed.
!
!-----------------------------------------------------------------------
real :: a(4), b(4), p(8), q(8), r(5), s(5)
double precision :: w
!-------------------------
data c/.564189583547756/
!-------------------------
data a(1)/-1.65581836870402e-4/, a(2)/3.25324098357738e-2/, &
&a(3)/1.02201136918406e-1/,  a(4)/1.12837916709552e00/
data b(1)/4.64988945913179e-3/,  b(2)/7.01333417158511e-2/, &
&b(3)/4.23906732683201e-1/,  b(4)/1.00000000000000e00/
data p(1)/-1.36864857382717e-7/, p(2)/5.64195517478974e-1/, &
&p(3)/7.21175825088309e00/,  p(4)/4.31622272220567e01/, &
&p(5)/1.52989285046940e02/,  p(6)/3.39320816734344e02/, &
&p(7)/4.51918953711873e02/,  p(8)/3.00459261020162e02/
data q(1)/1.00000000000000e00/,  q(2)/1.27827273196294e01/, &
&q(3)/7.70001529352295e01/,  q(4)/2.77585444743988e02/, &
&q(5)/6.38980264465631e02/,  q(6)/9.31354094850610e02/, &
&q(7)/7.90950925327898e02/,  q(8)/3.00459260956983e02/
data r(1)/2.10144126479064e00/,  r(2)/2.62370141675169e01/, &
&r(3)/2.13688200555087e01/,  r(4)/4.65807828718470e00/, &
&r(5)/2.82094791773523e-1/
data s(1)/9.41537750555460e01/,  s(2)/1.87114811799590e02/, &
&s(3)/9.90191814623914e01/,  s(4)/1.80124575948747e01/, &
&s(5)/1.00000000000000e00/
!-------------------------
!
!                     abs(x) .LT. 0.47
!
ax = abs(x)
if (ax .ge. 0.47) go to 10
t = x*x
top = ((a(1)*t + a(2))*t + a(3))*t + a(4)
bot = ((b(1)*t + b(2))*t + b(3))*t + b(4)
y = 0.5 + (0.5 - x*top/bot)
if (ind .eq. 0) return
!
if (e .lt. 0.0) e = exp(-t)
y = y/e
return
!
!                  0.47 .LE. abs(x) .LE. 4
!
10 if (ax .gt. 4.0) go to 30
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
&+ p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
&+ q(6))*ax + q(7))*ax + q(8)
y = top/bot
!
20 if (ind .eq. 0) go to 21
   if (x .ge. 0.0) return
   if (e .lt. 0.0) e = exp(-x*x)
   y = 2.0/e - y
   return
21 w = dble(x)*dble(x)
t = w
eps = w - dble(t)
if (e .lt. 0.0) e = exp(-t)
y = ((0.5 + (0.5 - eps)) * e) * y
if (x .lt. 0.0) y = 2.0 - y
return
!
!                      abs(x) .GT. 4
!
30 if (x .le. -5.5) go to 40
if (ind .eq. 0 .and. x .gt. 50.0) go to 50
t = (1.0/x)**2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + s(5)
y = (c - t*top/bot) / ax
go to 20
!
!             Limit value for large negative x
!
40 y = 2.0
if (ind .eq. 0) return
if (e .lt. 0.0) e = exp(-x*x)
y = 2.0/e
return
!
!             Limit value for large positive x
!                       WHEN ind = 0
!
50 y = 0.0
return
end subroutine erfc0

real function erfcr (x)
implicit none
real, intent(in) :: x
real :: bot, t, top
!-----------------------------------------------------------------------
!     COMPUTATION OF  1/sqrt(PI) - x*exp(x*x)*erfc(x)  FOR x .GE. 4
!-----------------------------------------------------------------------
real :: r(5), s(4)
!------------------------
data r(1)/2.10144126479064e+00/,  r(2)/2.62370141675169e+01/, &
&r(3)/2.13688200555087e+01/,  r(4)/4.65807828718470e+00/, &
&r(5)/2.82094791773523e-01/
data s(1)/9.41537750555460e+01/,  s(2)/1.87114811799590e+02/, &
&s(3)/9.90191814623914e+01/,  s(4)/1.80124575948747e+01/
!------------------------
t = (1.0/x)**2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erfcr = t*top/bot
return
end function erfcr

subroutine pkill (r0, sx, sy, h, k, p)
implicit none
real, intent(in) :: h
real, intent(out) :: p
real, intent(in) :: r0, sx, sy
integer :: i, ii, iy, iz, iz3, j, j8, n1, nt
real :: a, a1, a2, a3, a4, c, c8, d, d1, d2, dm, e3, e4, eps, f, &
&g2, g3, h1, h2, h3, h5, h6, h8, q, q1, r, r8, rpi, rt2, s0, s1, &
&s2, s9, sa, seps1, sqeps, t, t1, t2, t3, t4, t5, t9, u, x1, x5, &
&yy, z, z1, z2, z3, z8, z9
real :: exparg
real :: aerf
real :: epsln
real :: spmpar
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
real, intent(in) :: k
real :: k8, v(16), w(16)
!-----------------------------------------------------------------------
!   v(*), w(*)-- Gaussian abscissas and weights of order 32, on (-1,1).
!-----------------------------------------------------------------------
data v(1)  /.4830766568773832e-01/, v(2)  /.1444719615827965e+00/, &
&v(3)  /.2392873622521371e+00/, v(4)  /.3318686022821276e+00/, &
&v(5)  /.4213512761306353e+00/, v(6)  /.5068999089322294e+00/, &
&v(7)  /.5877157572407623e+00/, v(8)  /.6630442669302152e+00/, &
&v(9)  /.7321821187402897e+00/, v(10) /.7944837959679424e+00/, &
&v(11) /.8493676137325700e+00/, v(12) /.8963211557660521e+00/, &
&v(13) /.9349060759377397e+00/, v(14) /.9647622555875064e+00/, &
&v(15) /.9856115115452683e+00/, v(16) /.9972638618494816e+00/
data w(1)  /.9654008851472780e-01/, w(2)  /.9563872007927486e-01/, &
&w(3)  /.9384439908080457e-01/, w(4)  /.9117387869576388e-01/, &
&w(5)  /.8765209300440381e-01/, w(6)  /.8331192422694676e-01/, &
&w(7)  /.7819389578707031e-01/, w(8)  /.7234579410884851e-01/, &
&w(9)  /.6582222277636185e-01/, w(10) /.5868409347853555e-01/, &
&w(11) /.5099805926237618e-01/, w(12) /.4283589802222668e-01/, &
&w(13) /.3427386291302143e-01/, w(14) /.2539206530926206e-01/, &
&w(15) /.1627439473090567e-01/, w(16) /.7018610009470097e-02/
!----------------------------------------
!     c = (2**.25)*gamma(3/4)/pi
!     rpi = 1/sqrt(pi)
!     rt2 = sqrt(2)
!----------------------------------------
data a3  /20.0/
data c   /.4638648042895004/
data rpi /.5641895835477563/
data rt2 /1.414213562373095/
!
p = 0.0
if (sx .gt. 0.0 .and. sy .gt. 0.0) go to 5
   p = -1.e10
   return
5 j = 0
eps = spmpar(1)
sqeps = sqrt(eps)
a = 6.5
!----------------------------------------
!     Test no.1 (REPORT 83-13).
!----------------------------------------
z3 = amin1(sqrt(sqrt(spmpar(2))),1.e-30)*sx*sy
if (r0*r0 .le. z3) return
!
h2 = h*h + k*k
h8 = abs(h)
k8 = abs(k)
dm = amax1(sx,sy)
!-----------------------------------------
!     Test no.2 (REPORT 83-13).
!-----------------------------------------
if ((r0 - h8 + a3*sx) .le. 0.0) return
if ((r0 - k8 + a3*sy) .le. 0.0) return
!-----------------------------------------
!     Test no.3 (REPORT 83-13).
!-----------------------------------------
c8 = - epsln(0)
!-----------exp(-10.3026) = 3.35E(-5)---------
a4 = amax1(c8 - 1.74249e1, 10.3026)
a4 = sqrt(a4 + a4)
h3 = (r0 - h)*(r0 + h)
h5 = (r0 - k)*(r0 + k)
s0 = a4*dm
t = r0 - s0
if (t .lt. 0.0) go to 25
if (t*t .lt. h2) go to 25
if (r0 .lt. 1/sqeps) go to 20
t = h3 -2.0*r0*s0 + s0*s0 - k*k
if (abs(h3) .le. abs(h5)) go to 10
t = h5 - 2.0*r0*s0 + s0*s0 - h*h
10 if (t .lt. 0.0) go to 25
20 p = 1.0
return
!-----------------------------------------
!     Test no.4 (REPORT 83-13).
!-----------------------------------------
25 s0 = sqrt(h2)
g2 = 0.0
if (s0 .le. r0) go to 30
d = ((s0 - r0)/dm)**2
if (r0*r0*exp(-0.5*d) .le. z3) return
!-----------------------------------------
!     sx - sy .LT. EPS
!-----------------------------------------
30 if (abs(sx - sy) .gt. 20.0*dm*eps) go to 33
h8 = s0
k8 = 0.0
if ((r0 - h8 + a3*dm) .le. 0.0) return
if (r0 .lt. dm/sqeps) go to 33
j = 1
g2 = (k*k - h3)/((r0 + h8)*dm)
if (abs(h3) .le. abs(h5)) go to 33
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
if (abs(t) .gt. 1.e-3) go to 35
t9 = (t*t - 4.0*(t1*t1*(z1 - 0.5) + t2*t2*(z2 - 0.5)))/192.0
if (abs(t9) .gt. amax1(10.0*eps,1.e-10)) go to 35
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
if (s1 .ge. s2) go to 40
h1 = s1
s1 = s2
s2 = h1
h1 = h8
h8 = k8
k8 = h1
!-----------------------------------------------
!     LIMITING RESULTS FOR AMIN1(S1,S2) = 0
!-----------------------------------------------
40 seps1 = amin1(6.71*sqeps,1.e-5)
!-----------------------------------------------
!            r = k,  s2 small
!-----------------------------------------------
if (k8 .ne. r) go to 45
yy = .166484*(r*(h8*h8 + 1.0) + 1.0/r)*s2
if (abs(yy) .gt. seps1) go to 85
h1 = h8/rt2
p = c*exp(-h1*h1)*sqrt(k8*s2)
return
!-----------------------------------------------
!            R .GT. k,  S2 SMALL
!-----------------------------------------------
45 if (r .lt. k8) go to 85
if (k8 .ne. 0.0) go to 75
h1 = s2*s2/(4.0*rt2*r)
g2 = g2/rt2
if (j .eq. 0) g2 = abs(h8 - r)/rt2
if (abs(g2) .lt. 4.0) go to 55
   if (h1*abs(g2) .gt. seps1) go to 85
   p = 0.5*aerf(h8/rt2,r/rt2)
   return
55 if (j .ne. 0) go to 60
   p = 0.5*aerf(h8/rt2,r/rt2)
   go to 70
60 if (h8 + r .lt. rt2) go to 65
   p = 0.5*(erfc(g2) - erfc((h8 + r)/rt2))
   go to 70
65 p = 0.5*(erf((h8 + r)/rt2) - erf(g2))
70 if (h1*exp(-g2*g2) .gt. p*seps1) go to 85
return
!
75 z = (r - k8)*(r + k8)
g2 = sqrt(z)
h1 = abs(h8 - g2)
j = 0
if (h1 .gt. 5.0) go to 80
   j = 1
   z8 = aerf(h8/rt2,g2/rt2)
   if (z8 .eq. 0.0) go to 85
   h1 = exp(-0.5*(h8 - g2)**2)/z8
80 h1 = 1.0/(8.0*rt2*z)*(k8*k8*abs(h8 - g2) + r*r/g2)*s2*s2*h1
if (abs(h1) .gt. seps1) go to 85
u = 0.5
if (j .eq. 0) z8 = aerf(h8/rt2,g2/rt2)
s2 = rt2*s2
if (k8 - r .gt. -13.0*s2) u = 0.25*aerf(k8/s2,r/s2)
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
call gratio (t1,yy,z,z8,0)
z2 = r/(rt2*s2)
r8 = r/(rt2*s1)
h2 = h8/(rt2*s1)
h3 = k8/(rt2*s2)
s0 = 0.0
s9 = 0.0
if (z .lt. 1.e-13 .and. s2 .gt. 5.e-10) go to 90
if (h2 .gt. 50.0 .or. h3 .gt. 50.0) s0 = 1.5
90 u = aerf(h3,z2)
yy = 0.25*u*aerf(h2,r8)
if (yy .gt. 0.1) s9 = 0.5
if (yy .ge. 5.e-15) go to 95
   z = yy
   go to 100
95 z = amin1(yy,z)
!
100 if (z .ge. 0.5) go to 105
a = a + .5
if (z .ge. 5.e-4) go to 105
a = a + .5 + s0
if (z .ge. 1.e-6) go to 105
a = a + .5 + s9
if (z .ge. 5.e-9) go to 105
a = a + .5
if (z .ge. 5.e-10) go to 105
a = a + .25
if (z .ge. 5.e-11) go to 105
a = a + .25
if (z .ge. 5.e-12) go to 105
a = a + .25
if (z .ge. 5.e-13) go to 105
a = a + .5 + .5*s9
if (z .gt. 5.e-15) go to 105
a = a + .5
if (z .gt. 1.e-18) go to 105
a = a + .25
if (z .gt. 1.e-20) go to 105
a = a + .25
if (z .gt. 1.e-25) go to 105
a = a + 1.
if (z .gt. 1.e-30) go to 105
a = a + 2.
!
105 if (s2 .ge. 5.e-2 .or. h3 .le. z2) go to 107
t9 = r8*u*exp(-h2*h2)
if (t9 .lt. 5.e-2 * z) a = a + 0.5
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
if (abs(a1 - 0.5) .ge. 0.5) go to 115
a2 = amax1(((1.0 - g3/r) + a*z9/r)*(1.0 + a1), 0.0)
sa = sqrt(a2)
if (sa .lt. h3/r) go to 115
t3 = a1/sqrt(1.0 + sa)
!----------------------------------------
!            t9 = 1.0 - d1
!----------------------------------------
115 if (h3 .gt. 0.0) go to 135
!----------------------------------------
!            H3 .LE. 0.0
!----------------------------------------
if (t3 .lt. 0.0) go to 120
   d2 = 0.5*(1.0 + t3)
   e4 = 0.25*sa/d2
   t5 = e4
120 if (z .lt. r) go to 125
   e3 = 0.5
   d1 = e3
   t9 = d1
   go to 130
125 d1 = 0.5*(1.0 + sqrt(1.0 - z/r))
e3 = 0.25*z/(r*d1)
t9 = e3
130 if (t3 .le.d1 - e3)  go to 165
go to 160
!----------------------------------------
!            H3 .GT. 0.0
!----------------------------------------
135 h5 = 1.0
q = h3/r
if (q .le. 1.0) go to 140
   e3 = 0.5
   d1 = e3
   t9 = d1
   go to 165
140 if (t3 .lt. 0.0) go to 145
   e4 = amax1((1.0 - g2/r) + a*z8/r, 0.0)
   e4 = sqrt(e4)
   d2 = 0.5*(e4 + t3)
   t5 = 0.5*(q/(1.0 + e4) + sa/(1.0 + t3))
   e4 = 0.25*(sa - q)/d2
145 e3 = amax1((1.0 - g2/r) + a*z8/r, 0.0)
if (z .lt. r) go to 150
   e3 = 0.5*sqrt(e3)
   d1 = e3
   t9 = 0.25*(3.0 + h3/r)/(1.0 + e3)
   go to 155
150 t9 = sqrt(e3)
t2 = sqrt(1.0 - z/r)
d1 = 0.5*(t9 + t2)
e3 = a*z8/(r*2.0*d1)
t9 = 0.5*((h3/r)/(1.0 + t9) + (z/r)/(1.0 + t2))
155 if (t3 .le.d1 - e3) go to 165
160 e3 = e4
d1 = d2
t9 = t5
165 if (j8 .ne. 0) go to 170
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
170 if (s2 .gt. 2.e-2 .and. h8 + k8 .lt. 2.e2) go to 172
if (abs(e3 - f) .gt. 0.4*f) go to 172
if (d1 - t) 200,180,195
172 if (e3 .lt. 2.e4*eps) go to 195
if (f .lt. 2.e4*eps) go to 200
if (amax1(h8/s1,k8/s2) .lt. 2.0) go to 175
if (s2 .lt. 1.e-5) go to 175
if (s2 .ge. 5.e-4) go to 180
if (s1 .ne. s2) go to 195
175 if (amin1(e3,f) .lt. 2.5e-2*sqeps) goto 185
180 if (e3 - f) 200,190,195
185 if (e3 - f) 195,190,200
190 if (s0 .ge. s9) go to 200
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
if (t .gt. 0.0 .and. t*t .gt. -exparg(1)) return
!
q1 = rpi*e3*r8
g3 = 0.0
nt = 2*n1 + 1
z = (.5 + d1) +.5
do 260 ii = 1, nt
   i = ii - (n1 + 1)
   if (i .eq. 0) go to 260
   j = iabs(i)
   q = e3*isign(1,i)*v(j)
   t = q + d1
   h6 = z + q
   q = t9 - q
   f = h6*q
   t1 = r8*f
   t2 = (h2 - t1)*(h2 - t1)
   if (h2 - r8 .ge. 0. .or. t .lt. eps) t2 = &
&((h2 - r8) + r8*t*t)**2
   t4 = exp(-t2)
   if (h2 .ne. 0.0) go to 210
      t4 = t4 + t4
      go to 215
210 if (h5 .ne. 0.0) go to 215
      t2 = 4.0*h2*t1
      if (t2 .gt. c8) go to 215
      t4 = t4*(1.0 + exp(-t2))
215 if (iz .ne. 0) go to 255
   g2 = sqrt(1.0 + f)
   z1 = z2*t*g2
   x1 = h3 - z1
   if (x1 .gt. -a) go to 225
      iz = 1
      x5 = 2.0
      go to 255
225 if (abs(x1) .gt. 1.e-2*z1) go to 230
      iy = 1
      x1 = ((k8 - r) + r*f*f/(1.0 + t*g2))/(rt2*s9)
230 if (iz3 .ne. 0) go to 250
   sa = h3 + z1
   if (sa .gt. a3) go to 245
   if (iy .eq. 0) go to 240
   if (x1 .gt. rt2) go to 235
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
if (p .gt. yy) p = yy
if (p .gt. (1.0 - amin1(1.e6*eps,1.e-5))) p = 1.0
if (p .lt. 0.0) p = 0.0
return
end subroutine pkill

subroutine plcopy (a,ka,m,b,kb,n)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: j, jmax, la, lb, mp1
!     ------------------------------------------------------------------
!     Copying real polynomials
!     ------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
!
la = 1
lb = 1
jmax = min0(m, n)
do j = 1,jmax
   b(lb) = a(la)
   la = la + ka
   lb = lb + kb
end do
if (jmax .eq. n) return
!
mp1 = m + 1
do j = mp1,n
   b(lb) = 0.0
   lb = lb + kb
end do
return
end subroutine plcopy

subroutine dpcopy (a,ka,m,b,kb,n)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: j, jmax, la, lb, mp1
!     ------------------------------------------------------------------
!     Copying double precision polynomials
!     ------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
!
la = 1
lb = 1
jmax = min0(m, n)
do j = 1,jmax
   b(lb) = a(la)
   la = la + ka
   lb = lb + kb
end do
if (jmax .eq. n) return
!
mp1 = m + 1
do j = mp1,n
   b(lb) = 0.d0
   lb = lb + kb
end do
return
end subroutine dpcopy

subroutine padd (a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Addition of real polynomials
!     ------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.0
   if (i .le. l) c(lc) = a(la)
   if (i .le. m) c(lc) = c(lc) + b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine padd

subroutine dpadd (a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Addition of double precision polynomials
!     ------------------------------------------------------------------
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.d0
   if (i .le. l) c(lc) = a(la)
   if (i .le. m) c(lc) = c(lc) + b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine dpadd

subroutine psubt (a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Subtraction of real polynomials
!     ------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.0
   if (i .le. l) c(lc) = a(la)
   if (i .le. m) c(lc) = c(lc) - b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine psubt

subroutine dpsubt (a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Subtraction of double precision polynomials
!     ------------------------------------------------------------------
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
!
la = 1
lb = 1
lc = 1
do i = 1,n
   c(lc) = 0.d0
   if (i .le. l) c(lc) = a(la)
   if (i .le. m) c(lc) = c(lc) - b(lb)
   la = la + ka
   lb = lb + kb
   lc = lc + kc
end do
return
end subroutine dpsubt

subroutine pmult (a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, imax, imin, j, jmax, jmin, la, lb, lc
!     ------------------------------------------------------------------
!     Multiplication of real polynomials
!     ------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
double precision :: dsum
!
lc = 1
jmax = min0(l + m - 1, n)
do 40 j = 1,jmax
   if (j .le. l) go to 10
      imin = 1 + (j - l)
      la = 1 + (l - 1)*ka
      lb = 1 + (imin - 1)*kb
      go to 20
10 imin = 1
   la = 1 + (j - 1)*ka
   lb = 1
!
20 imax = min0(j, m)
   dsum = 0.d0
   do i = imin,imax
      dsum = dsum + dble(a(la))*dble(b(lb))
      la = la - ka
      lb = lb + kb
   end do
   c(lc) = dsum
40 lc = lc + kc
if (jmax .eq. n) return
!
jmin = jmax + 1
do 60 j = jmin,n
   c(lc) = 0.0
60 lc = lc + kc
return
end subroutine pmult

subroutine dpmult (a,ka,l,b,kb,m,c,kc,n)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, imax, imin, j, jmax, jmin, la, lb, lc
!     ------------------------------------------------------------------
!     Multiplication of double precision polynomials
!     ------------------------------------------------------------------
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
double precision :: sum
!
lc = 1
jmax = min0(l + m - 1, n)
do 40 j = 1,jmax
   if (j .le. l) go to 10
      imin = 1 + (j - l)
      la = 1 + (l - 1)*ka
      lb = 1 + (imin - 1)*kb
      go to 20
10 imin = 1
   la = 1 + (j - 1)*ka
   lb = 1
!
20 imax = min0(j, m)
   sum = 0.d0
   do i = imin,imax
      sum = sum + a(la)*b(lb)
      la = la - ka
      lb = lb + kb
   end do
   c(lc) = sum
40 lc = lc + kc
if (jmax .eq. n) return
!
jmin = jmax + 1
do 60 j = jmin,n
   c(lc) = 0.d0
60 lc = lc + kc
return
end subroutine dpmult

subroutine pdiv (a,ka,l,b,kb,m,c,kc,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, ib, ic, imax, j, la, lc
real :: b0
!     ------------------------------------------------------------------
!     Division of real polynomials
!     ------------------------------------------------------------------
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
double precision :: dsum
!
b0 = b(1)
if (b0 .eq. 0.0) go to 100
ierr = 0
c(1) = a(1)/b0
if (n .eq. 1) return
!
!               CASE WHEN m = 1
!
if (m .gt. 1) go to 20
la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   c(lc) = 0.0
   if (j .le. l) c(lc) = a(la)/b0
end do
return
!
!              CASE WHEN m .GT. 1
!
20 la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   ib = 1
   ic = lc
   dsum = 0.d0
   if (j .le. l) dsum = a(la)
   imax = min0(j, m)
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

subroutine dpdiv (a,ka,l,b,kb,m,c,kc,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, ib, ic, imax, j, la, lc
!     ------------------------------------------------------------------
!     Division of double precision polynomials
!     ------------------------------------------------------------------
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
double precision :: b0, sum
!
b0 = b(1)
if (b0 .eq. 0.d0) go to 100
ierr = 0
c(1) = a(1)/b0
if (n .eq. 1) return
!
!               CASE WHEN m = 1
!
if (m .gt. 1) go to 20
la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   c(lc) = 0.d0
   if (j .le. l) c(lc) = a(la)/b0
end do
return
!
!              CASE WHEN m .GT. 1
!
20 la = 1
lc = 1
do j = 2,n
   la = la + ka
   lc = lc + kc
   ib = 1
   ic = lc
   sum = 0.d0
   if (j .le. l) sum = a(la)
   imax = min0(j, m)
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

subroutine plpwr(r,a,ka,m,b,kb,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: r
integer :: i, ia, ib, imax, j, lb
real :: a0
!     ------------------------------------------------------------------
!     SET b = a**r WHERE A IS A REAL POLYNOMIAL
!     ------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
real :: jm1
double precision :: coeff, dsum, rp1
!
a0 = a(1)
if (a0 .le. 0.0) go to 100
ierr = 0
b(1) = a0**r
if (n .eq. 1) return
!
!            CASE WHEN m = 1 OR r = 0
!
if (m .gt. 1 .and. r .ne. 0.0) go to 20
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
   imax = min0(j, m)
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

subroutine dplpwr(r,a,ka,m,b,kb,n,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, n
integer :: i, ia, ib, imax, j, lb
!     ------------------------------------------------------------------
!     SET b = a**r WHERE A IS A DOUBLE PRECISION POLYNOMIAL
!     ------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
double precision, intent(in) :: r
double precision :: a0, coeff, jm1, rp1, sum
!
a0 = a(1)
if (a0 .le. 0.d0) go to 100
ierr = 0
b(1) = a0**r
if (n .eq. 1) return
!
!            CASE WHEN m = 1 OR r = 0
!
if (m .gt. 1 .and. r .ne. 0.d0) go to 20
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
   imax = min0(j, m)
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

subroutine pinv (a, d, n, q)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, k, l, l0, ll, m
real :: s, sum, t, u
!-----------------------------------------------------------------------
!          Computation of the inverse of the power series
!                  sum (a(i)*X**i, i = 1,2,...)
!-----------------------------------------------------------------------
real, intent(in) :: a(n)
real, intent(inout) :: d(n), q(*)
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

subroutine dpinv (a, d, n, q)
implicit none
integer, intent(in) :: n
integer :: i, j, jj, k, l, l0, ll, m
!-----------------------------------------------------------------------
!          Computation of the inverse of the power series
!                  sum (a(i)*X**i, i = 1,2,...)
!-----------------------------------------------------------------------
double precision, intent(in) :: a(n)
double precision, intent(inout) :: d(n), q(*)
double precision :: s, sum, t, u
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

subroutine mplnmv (mo, au, nc, ac, fv)
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
!     mo = MODE OF OPERATION
!     au = ARGUMENT U
!     nc = NUMBER OF COEFFICIENTS
!     ac = ARRAY OF COEFFICIENTS
!     fv = FUNCTION V
!
!     mo = -1 FOR INTEGRAL
!     mo =  0 FOR FUNCTION
!     mo = +1 FOR FIRST DERIVATIVE
!     mo = +2 FOR SECOND DERIVATIVE
!
001 fv=0.0
l=nc
if(mo.lt.0)go to 002
if(mo.eq.0)go to 004
if(mo.eq.1)go to 006
if(mo.ge.2)go to 008
002 ql=nc
do 003 k = 1,nc
fv=ac(l)/ql+au*fv
l=l-1
ql=ql-1.0
003 continue
fv=au*fv
return
004 do k=1,nc
fv=ac(l)+au*fv
l=l-1
end do
return
006 if(nc.le.1)return
ql=nc
do k=2,nc
ql=ql-1.0
fv=ql*ac(l)+au*fv
l=l-1
end do
return
008 if(nc.le.2)return
ql=nc
do k=3,nc
ql=ql-1.0
fv=ql*(ql-1.0)*ac(l)+au*fv
l=l-1
end do
return
end subroutine mplnmv

real function csevl (x, a, n)
implicit none
integer, intent(in) :: n
real, intent(in) :: x
integer :: i, k
real :: s0, s1, s2, x2
!-----------------------------------------------------------------------
!          Evaluate the n term Chebyshev series A at x.
!          Only half of the first coefficient is used.
!-----------------------------------------------------------------------
real, intent(in) :: a(n)
!
if (n .gt. 1) go to 10
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

double precision function dcsevl (x, a, n)
implicit none
integer, intent(in) :: n
integer :: i, k
!-----------------------------------------------------------------------
!          Evaluate the n term Chebyshev series A at x.
!          Only half of the first coefficient is used.
!-----------------------------------------------------------------------
double precision, intent(in) :: a(n), x
double precision :: x2, s0, s1, s2
!
if (n .gt. 1) go to 10
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

subroutine lgrngn (au, na, an)
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
!     na = NUMBER OF ARGUMENTS   (N)
!     an = NORMALIZATION FACTORS (N-ARRAY)
!
001 do k=1,na
tm=1.0
do 002 m = 1,na
if(m.eq.k)go to 002
dm=au(k)-au(m)
tm=dm*tm
002 continue
an(k)=tm
end do
return
end subroutine lgrngn

subroutine lgrngv (mo, na, qu, au, an, ff, df, sf)
implicit none
integer, intent(in) :: mo, na
real :: an(*), au(*)
real, intent(inout) :: df(*), ff(*)
real, intent(in) :: qu
real, intent(inout) :: sf(*)
integer :: k, l
real :: dm, rm, sm, tm
!     ******************************************************************
!     Fortran subroutine for Lagrangian function evaluation
!     ******************************************************************
!     mo = MODE OF OPERATION
!     na = NUMBER OF STATIONS
!     qu = ARGUMENT OF FUNCTIONS
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
logical :: ln
001 ln=.true.
tm=1.0
do 003 k = 1,na
if(qu.ne.au(k))go to 002
ln=.false.
go to 003
002 dm=qu-au(k)
tm=dm*tm
003 continue
do k=1,na
if(ln)go to 005
if(qu.ne.au(k))go to 005
ff(k)=tm
go to 006
005 dm=qu-au(k)
ff(k)=tm/dm
006 ff(k)=ff(k)/an(k)
end do
if(mo.le.0)go to 050
sm=0.0
do 013 k = 1,na
df(k)=sm
if(ln)go to 012
if(qu.eq.au(k))go to 013
012 dm=qu-au(k)
sm=sm+1.0/dm
013 continue
rm=sm
if(mo.eq.1)go to 040
sm=0.0
do 023 k = 1,na
sf(k)=sm
if(ln)go to 022
if(qu.eq.au(k))go to 023
022 dm=qu-au(k)
sm=sm+2.0*df(k)/dm
023 continue
sm=0.0
tm=0.0
l=na
if(ln)go to 034
do k=1,na
sf(l)=tm+sf(l)+2.0*sm*df(l)
if(qu.eq.au(l))go to 032
sf(l)=2.0*(sm+df(l))
dm=qu-au(l)
tm=tm+2.0*sm/dm
sm=sm+1.0/dm
032 l=l-1
end do
go to 036
034 do k=1,na
sf(l)=tm+sf(l)+2.0*sm*df(l)
dm=qu-au(l)
tm=tm+2.0*sm/dm
sm=sm+1.0/dm
l=l-1
end do
036 do k=1,na
sf(k)=ff(k)*sf(k)
end do
040 if (ln) go to 043
do 042 k = 1,na
if (qu.ne.au(k)) go to 041
df(k)=rm
ff(k)=1.0
go to 042
041 df(k)=ff(k)
ff(k)=0.0
042 continue
return
043 sm=0.0
l=na
do k=1,na
df(l)=ff(l)*(sm+df(l))
sm=sm+1.0/(qu-au(l))
l=l-1
end do
return
050 if(ln)go to 053
do 052 k = 1,na
ff(k)=0.0
if(qu.ne.au(k))go to 052
ff(k)=1.0
052 continue
053 return
end subroutine lgrngv

subroutine lgrngx (au, na, ac)
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
!     na = NUMBER OF ARGUMENTS     (N)
!     ac = POLYNOMIAL COEFFICIENTS (NX(N+1) ARRAY)
!
001 do 003 i = 1,na
k=(i-1)*na
l=k+i
ac(l)=1.0
sm=0.0
do 002 j = 1,i
k=k+1
l=k+na
ac(l)=sm-au(i)*ac(k)
sm=ac(k)
002 continue
003 continue
do i=1,na
k=na+na*na
l=i*na
ac(l)=1.0
do j=2,na
sm=au(i)*ac(l)
l=l-1
ac(l)=sm+ac(k)
k=k-1
end do
end do
do i=1,na
tm=1.0
do 006 j = 1,na
if(j.eq.i)go to 006
td=au(i)-au(j)
tm=tm*td
006 continue
k=(i-1)*na
do j=1,na
k=k+1
ac(k)=ac(k)/tm
end do
end do
return
end subroutine lgrngx

subroutine orthos (au, ma, aa, na, ar)
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
!     ma = NUMBER OF COLUMNS       (m)
!     aa = MATRIX OF POLYNOMIALS   (NXM ARRAY)
!     na = NUMBER OF ROWS          (N)
!     ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
!
001 sn=na
rn=sqrt(sn)
do 002 i = 1,na
aa(i)=1.0/rn
002 continue
if(ma.eq.1)return
003 sm=0.0
do i=1,na
sm=sm+au(i)
end do
ar(2)=sm/sn
sm=0.0
l=na
do 005 i = 1,na
l=l+1
aa(l)=au(i)-ar(2)
sm=sm+aa(l)*aa(l)
005 continue
rm=sqrt(sm)
l=na
do i=1,na
l=l+1
aa(l)=aa(l)/rm
end do
sm=0.0
l=na
do i=1,na
l=l+1
sm=sm+au(i)*aa(l)
end do
ar(1)=sm/rn
if(ma.eq.2)return
008 do m=3,ma
sm=0.0
k=(m-2)*na
do i=1,na
k=k+1
sm=sm+au(i)*aa(k)*aa(k)
end do
ar(2*m-2)=sm
sm=0.0
j=(m-3)*na
do i=1,na
j=j+1
k=j+na
l=k+na
aa(l)=au(i)*aa(k)-ar(2*m-2)*aa(k)-ar(2*m-5)*aa(j)
sm=sm+aa(l)*aa(l)
end do
rm=sqrt(sm)
l=(m-1)*na
do i=1,na
l=l+1
aa(l)=aa(l)/rm
end do
sm=0.0
k=(m-2)*na
do i=1,na
k=k+1
l=k+na
sm=sm+au(i)*aa(k)*aa(l)
end do
ar(2*m-3)=sm
end do
return
end subroutine orthos

subroutine orthov (mo, na, au, ar, nf, ff, df, sf)
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
!     mo = MODE OF OPERATION
!     na = NUMBER OF COORDINATES
!     au = ARGUMENT OF FUNCTIONS
!     ar = RECURRENCE COEFFICIENTS                (2*M-2 ARRAY)
!     nf = NUMBER OF FUNCTIONS                    (M)
!     ff = ORTHONORMAL FUNCTIONS                  (M-ARRAY)
!     df = FIRST DERIVATIVES                      (M-ARRAY)
!     sf = SECOND DERIVATIVES                     (M-ARRAY)
!
!     call orthov (0, na, au, ar, nf, ff)         for functions
!     call orthov (1, na, au, ar, nf, ff, df)     for first derivatives
!     call orthov (2, na, au, ar, nf, ff, df, sf) for second derivatives
!
001 sn=na
rn=sqrt(sn)
ff(1)=1.0/rn
if(nf.le.1)go to 003
ff(2)=(au-ar(2))*ff(1)/ar(1)
if(nf.eq.2)go to 003
l=2
do 002 k = 3,nf
l=l+2
ff(k)=((au-ar(l))*ff(k-1)-ar(l-3)*ff(k-2))/ar(l-1)
002 continue
003 if(mo.le.0)return
df(1)=0.0
if(nf.le.1)go to 005
df(2)=ff(1)/ar(1)
if(nf.eq.2)go to 005
l=2
do k=3,nf
l=l+2
df(k)=(ff(k-1)+(au-ar(l))*df(k-1)-ar(l-3)*df(k-2))/ar(l-1)
end do
005 if(mo.eq.1)return
sf(1)=0.0
if(nf.le.1)go to 007
sf(2)=0.0
if(nf.eq.2)go to 007
l=2
do k=3,nf
l=l+2
sf(k)=(2.0*df(k-1)+(au-ar(l))*sf(k-1)-ar(l-3)*sf(k-2))/ar(l-1)
end do
007 return
end subroutine orthov

subroutine orthox (na, ar, nc, ac)
implicit none
integer, intent(in) :: na, nc
real, intent(inout) :: ac(*)
real :: ar(*)
integer :: j, k, l, m, n
real :: rn, sn, tm
!     ******************************************************************
!     Fortran subroutine for orthonormal polynomial expansion
!     ******************************************************************
!     na = NUMBER OF ARGUMENTS     (n)
!     ar = RECURRENCE COEFFICIENTS (2*m-2 ARRAY)
!     nc = NUMBER OF COEFFICIENTS  (m)
!     ac = POLYNOMIAL COEFFICIENTS (m*m ARRAY)
!
001 do 002 n = 1,nc
ac(n)=0.0
002 continue
sn=na
rn=sqrt(sn)
ac(1)=1.0/rn
if(nc.eq.1)return
003 tm=0.0
l=nc
do n=1,nc
l=l+1
ac(l)=(tm-ar(2)*ac(n))/ar(1)
tm=ac(n)
end do
if(nc.eq.2)return
005 do m=3,nc
tm=0.0
j=(m-3)*nc
do n=1,nc
j=j+1
k=j+nc
l=k+nc
ac(l)=(tm-ar(2*m-2)*ac(k)-ar(2*m-5)*ac(j))/ar(2*m-3)
tm=ac(k)
end do
end do
return
end subroutine orthox

real function zeroin (f, ax, bx, aerr, rerr)
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
&rtol
real :: spmpar
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
rtol = amax1(0.5*rerr,2.0*eps)
!
! Begin step
!
10 c = a
fc = fa
d = b - a
e = d
20 if (abs(fc) .ge. abs(fb)) go to 40
a = b
b = c
c = a
fa = fb
fb = fc
fc = fa
!
! Convergence test
!
40 tol = rtol*amax1(abs(b),abs(c)) + atol
xm = 0.5*(c - b)
if (abs(xm) .le. tol) go to 90
if (fb .eq. 0.0) go to 90
!
! Is bisection necessary
!
if (abs(e) .lt. tol) go to 70
if (abs(fa) .le. abs(fb)) go to 70
!
! Is quadratic interpolation possible
!
if (a .ne. c) go to 50
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
60 if (p .gt. 0.0) q = -q
p = abs(p)
!
! Is interpolation acceptable
!
if (2.0*p .ge. (3.0*xm*q - abs(tol*q))) go to 70
if (p .ge. abs(0.5*e*q)) go to 70
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
if (abs(d) .gt. tol) b = b + d
if (abs(d) .le. tol) b = b + sign(tol,xm)
fb = f(b)
if ((fb*(fc/abs(fc))) .gt. 0.0) go to 10
go to 20
!
! Done
!
90 zeroin = b
return
end function zeroin

double precision function dzero (f, ax, bx, aerr, rerr)
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
&r, s, atol, rtol
double precision :: dpmpar
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
rtol = dmax1(0.5d0*rerr,2.d0*eps)
!
! Begin step
!
10 c = a
fc = fa
d = b - a
e = d
20 if (dabs(fc) .ge. dabs(fb)) go to 40
a = b
b = c
c = a
fa = fb
fb = fc
fc = fa
!
! Convergence test
!
40 tol = rtol*dmax1(dabs(b),dabs(c)) + atol
xm = 0.5d0*(c - b)
if (dabs(xm) .le. tol) go to 90
if (fb .eq. 0.d0) go to 90
!
! Is bisection necessary
!
if (dabs(e) .lt. tol) go to 70
if (dabs(fa) .le. dabs(fb)) go to 70
!
! Is quadratic interpolation possible
!
if (a .ne. c) go to 50
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
60 if (p .gt. 0.d0) q = -q
p = dabs(p)
!
! Is interpolation acceptable
!
if (2.d0*p .ge. (3.d0*xm*q - dabs(tol*q))) go to 70
if (p .ge. dabs(0.5d0*e*q)) go to 70
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
if (dabs(d) .gt. tol) b = b + d
if (dabs(d) .le. tol) b = b + dsign(tol,xm)
fb = f(b)
if ((fb*(fc/dabs(fc))) .gt. 0.d0) go to 10
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
!         info = 0   IMPROPER INPUT PARAMETERS.
!
!         info = 1   ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
!                    between x and the solution is at most tol.
!
!         info = 2   NUMBER OF CALLS TO FCN HAS REACHED OR EXCEEDED
!                    200*(n+1).
!
!         info = 3   tol IS TOO SMALL. NO FURTHER IMPROVEMENT IN
!                    the approximate solution x is possible.
!
!         info = 4   ITERATION IS NOT MAKING GOOD PROGRESS.
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
integer :: index, j, lr, maxfev, ml, mode, mu, nfev, nprint
real :: factor, one, xtol, zero
data factor,one,zero /1.0e2,1.0e0,0.0e0/
info = 0
!
!     Check the input parameters for errors.
!
if (n .le. 0 .or. epsfcn .lt. zero .or. tol .lt. zero .or. &
&lwa .lt. (n*(3*n + 13))/2) go to 20
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
&factor,nprint,info,nfev,wa(index+1),n,wa(6*n+1),lr, &
&wa(n+1),wa(2*n+1),wa(3*n+1),wa(4*n+1),wa(5*n+1))
if (info .eq. 5) info = 4
20 continue
return
!
!     Last card of subroutine hbrd.
!
end subroutine hbrd

subroutine hybrd(fcn,n,x,fvec,xtol,maxfev,ml,mu,epsfcn,diag, &
&mode,factor,nprint,info,nfev,fjac,ldfjac,r,lr, &
&qtf,wa1,wa2,wa3,wa4)
implicit none
integer :: n
integer, intent(in) :: maxfev, ml, mu, mode, nprint
integer, intent(out) :: info, nfev
integer, intent(in) :: ldfjac, lr
real, intent(in) :: xtol, epsfcn, factor
real, intent(inout) :: x(n), fvec(n), diag(n), fjac(ldfjac,n), &
&r(lr), qtf(n), wa1(n), wa2(n), wa3(n)
real :: wa4(n)
external fcn
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
!       DIAG IS AN ARRAY OF LENGTH n. IF mode = 1 (SEE
!         BELOW), DIAG IS INTERNALLY SET. IF mode = 2, DIAG
!         must contain positive entries that serve as
!         multiplicative scale factors for the variables.
!
!       MODE IS AN INTEGER INPUT VARIABLE. IF mode = 1, THE
!         VARIABLES WILL BE SCALED INTERNALLY. IF mode = 2,
!         the scaling is specified by the input diag. Other
!         VALUES OF MODE ARE EQUIVALENT TO mode = 1.
!
!       Factor is a positive input variable used in determining the
!         initial step bound. This bound is set to the product of
!         factor and the Euclidean norm of diag*x if nonzero, or else
!         to factor itself. In most cases factor should lie in the
!         interval (.1,100.). 100. Is a generally recommended value.
!
!       nprint is an integer input variable that enables controlled
!         printing of iterates if it is positive. In this case,
!         FCN IS CALLED WITH iflag = 0 AT THE BEGINNING OF THE FIRST
!         iteration and every nprint iterations thereafter and
!         immediately prior to return, with x and fvec available
!         for printing. If nprint is not positive, no special calls
!         OF FCN WITH iflag = 0 ARE MADE.
!
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of iflag. See description of FCN. Otherwise,
!         info is set as follows.
!
!         info = 0   IMPROPER INPUT PARAMETERS.
!
!         info = 1   RELATIVE ERROR BETWEEN TWO CONSECUTIVE ITERATES
!                    is at most xtol.
!
!         info = 2   NUMBER OF CALLS TO FCN HAS REACHED OR EXCEEDED
!                    maxfev.
!
!         info = 3   xtol IS TOO SMALL. NO FURTHER IMPROVEMENT IN
!                    the approximate solution x is possible.
!
!         info = 4   ITERATION IS NOT MAKING GOOD PROGRESS, AS
!                    measured by the improvement from the last
!                    five Jacobian evaluations.
!
!         info = 5   ITERATION IS NOT MAKING GOOD PROGRESS, AS
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
integer :: i, iflag, iter, j, jm1, l, msum, ncfail, ncsuc, nslow1, &
&nslow2
integer :: iwa(1)
logical :: jeval, sing
real :: actred, delta, epsmch, fnorm, fnorm1, one, pnorm, prered, &
&p1, p5, p001, p0001, ratio, sum, temp, xnorm, zero
real :: spmpar, enorm
data one,p1,p5,p001,p0001,zero &
&/1.0e0,1.0e-1,5.0e-1,1.0e-3,1.0e-4,0.0e0/
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
if (n .le. 0 .or. xtol .lt. zero .or. maxfev .le. 0 &
&.or. ml .lt. 0 .or. mu .lt. 0 .or. factor .le. zero &
&.or. ldfjac .lt. n .or. lr .lt. (n*(n + 1))/2) go to 300
if (mode .ne. 2) go to 20
do 10 j = 1, n
   if (diag(j) .le. zero) go to 300
10 continue
20 continue
!
!     Evaluate the function at the starting point
!     and calculate its norm.
!
iflag = 1
call fcn(n,x,fvec,iflag)
nfev = 1
if (iflag .lt. 0) go to 300
fnorm = enorm(n,fvec)
!
!     Determine the number of calls to FCN needed to compute
!     the Jacobian matrix.
!
msum = min0(ml+mu+1,n)
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
&wa2)
   nfev = nfev + msum
   if (iflag .lt. 0) go to 300
!
!        Compute the QR factorization of the Jacobian.
!
   call qrfac(n,n,fjac,ldfjac,.false.,iwa,1,wa1,wa2,wa3)
!
!        On the first iteration and if mode is 1, scale according
!        to the norms of the columns of the initial Jacobian.
!
   if (iter .ne. 1) go to 70
   if (mode .eq. 2) go to 50
   do j = 1, n
      diag(j) = wa2(j)
      if (wa2(j) .eq. zero) diag(j) = one
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
   if (delta .eq. zero) delta = factor
70 continue
!
!        Form (Q transpose)*fvec and store in QTF.
!
   do i = 1, n
      qtf(i) = fvec(i)
      end do
   do j = 1, n
      if (fjac(j,j) .eq. zero) go to 110
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
      if (jm1 .lt. 1) go to 140
      do i = 1, jm1
         r(l) = fjac(i,j)
         l = l + n - i
         end do
140 continue
      r(l) = wa1(j)
      if (wa1(j) .eq. zero) sing = .true.
      end do
!
!        Accumulate the orthogonal factor in fjac.
!
   call qform(n,n,fjac,ldfjac,wa1)
!
!        Rescale if necessary.
!
   if (mode .eq. 2) go to 170
   do j = 1, n
      diag(j) = amax1(diag(j),wa2(j))
      end do
170 continue
!
!        Beginning of the inner loop.
!
180 continue
!
!           If requested, call FCN to enable printing of iterates.
!
      if (nprint .le. 0) go to 190
      iflag = 0
      if (mod(iter-1,nprint) .eq. 0) call fcn(n,x,fvec,iflag)
      if (iflag .lt. 0) go to 300
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
      if (iter .eq. 1) delta = amin1(delta,pnorm)
!
!           Evaluate the function at x + P and calculate its norm.
!
      iflag = 1
      call fcn(n,wa2,wa4,iflag)
      nfev = nfev + 1
      if (iflag .lt. 0) go to 300
      fnorm1 = enorm(n,wa4)
!
!           Compute the scaled actual reduction.
!
      actred = -one
      if (fnorm1 .lt. fnorm) actred = one - (fnorm1/fnorm)**2
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
      if (temp .lt. fnorm) prered = one - (temp/fnorm)**2
!
!           Compute the ratio of the actual to the predicted
!           reduction.
!
      ratio = zero
      if (prered .gt. zero) ratio = actred/prered
!
!           Update the step bound.
!
      if (ratio .ge. p1) go to 230
         ncsuc = 0
         ncfail = ncfail + 1
         delta = p5*delta
         go to 240
230 continue
         ncfail = 0
         ncsuc = ncsuc + 1
         if (ratio .ge. p5 .or. ncsuc .gt. 1) &
&delta = amax1(delta,pnorm/p5)
         if (abs(ratio-one) .le. p1) delta = pnorm/p5
240 continue
!
!           Test for successful iteration.
!
      if (ratio .lt. p0001) go to 260
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
      if (actred .ge. p001) nslow1 = 0
      if (jeval) nslow2 = nslow2 + 1
      if (actred .ge. p1) nslow2 = 0
!
!           Test for convergence.
!
      if (delta .le. xtol*xnorm .or. fnorm .eq. zero) info = 1
      if (info .ne. 0) go to 300
!
!           Tests for termination and stringent tolerances.
!
      if (nfev .ge. maxfev) info = 2
      if (p1*amax1(p1*delta,pnorm) .le. epsmch*xnorm) info = 3
      if (nslow2 .eq. 5) info = 4
      if (nslow1 .eq. 10) info = 5
      if (info .ne. 0) go to 300
!
!           Criterion for recalculating Jacobian approximation
!           by forward differences.
!
      if (ncfail .eq. 2) go to 290
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
         if (ratio .ge. p0001) qtf(j) = sum
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
if (iflag .lt. 0) info = iflag
iflag = 0
if (nprint .gt. 0) call fcn(n,x,fvec,iflag)
return
!
!     Last card of subroutine hybrd.
!
end subroutine hybrd

subroutine qdcrt (a, z)
implicit none
real :: d, eps, r, w, x, y
real :: spmpar
!-----------------------------------------------------------------------
!
!        qdcrt computes the roots of the real polynomial
!              a(1) + a(2)*z + a(3)*z**2
!     and stores the results in z. it is assumed that a(3)
!     is nonzero.
!
!-----------------------------------------------------------------------
real, intent(in) :: a(3)
complex, intent(inout) :: z(2)
!-----------------------------------------------------------------------
!
!     ***** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!           SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0.
!
         eps = spmpar(1)
!
!-------------------
if (a(1) .eq. 0.0) go to 40
d = a(2)*a(2) - 4.0*a(1)*a(3)
if (abs(d) .le. 2.0*eps*a(2)*a(2)) go to 20
r = sqrt(abs(d))
if (d .lt. 0.0) go to 30
!
!                 Distinct real roots
!
if (a(2) .ne. 0.0) go to 10
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
!                 CASE WHEN a(1) = 0
!
40 z(1) = (0.0, 0.0)
z(2) = cmplx(-a(2)/a(3), 0.0)
return
end subroutine qdcrt

subroutine dqdcrt (a, zr, zi)
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
double precision :: dpmpar
!-----------------------------------------------------------------------
!
!     ***** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!           SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0.
!
         eps = dpmpar(1)
!
!-------------------
if (a(1) .eq. 0.d0) go to 40
d = a(2)*a(2) - 4.d0*a(1)*a(3)
if (dabs(d) .le. 2.d0*eps*a(2)*a(2)) go to 20
r = dsqrt(dabs(d))
if (d .lt. 0.d0) go to 30
!
!                 Distinct real roots
!
zi(1) = 0.d0
zi(2) = 0.d0
if (a(2) .ne. 0.d0) go to 10
   zr(1) = dabs(0.5d0*r/a(3))
   zr(2) = -zr(1)
   return
10 w = -(a(2) + dsign(r,a(2)))
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
zi(1) = dabs(0.5d0*r/a(3))
zi(2) = -zi(1)
return
!
!                 CASE WHEN a(1) = 0
!
40 zr(1) = 0.d0
zr(2) = -a(2)/a(3)
zi(1) = 0.d0
zi(2) = 0.d0
return
end subroutine dqdcrt

subroutine cbcrt (a, z)
implicit none
real :: arg, c, cf, d, eps, p, p1, q, q1, r, r1, ra, rb, rq, rt, &
&rt3, s, sf, sq, sum, t, t1, tol, w, w1, w2, x, x1, x2, x3, y, y1, &
&y2, y3
real :: cbrt
real :: spmpar
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
real, intent(in) :: a(4)
real :: aq(3)
complex, intent(inout) :: z(3)
!-------------------
data rt3/1.7320508075689/
!-----------------------------------------------------------------------
!
!     ***** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!           SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0.
!
         eps = spmpar(1)
!
!-------------------
if (a(1) .eq. 0.0) go to 100
p = a(3)/(3.0*a(4))
q = a(2)/a(4)
r = a(1)/a(4)
tol = 4.0*eps
!
c = 0.0
t = a(2) - p*a(3)
if (abs(t) .gt. tol*abs(a(2))) c = t/a(4)
!
t = 2.0*p*p - q
if (abs(t) .le. tol*abs(q)) t = 0.0
d = r + p*t
if (abs(d) .le. tol*abs(r)) go to 110
!
!           SET  SQ = (a(4)/S)**2 * (c**3/27 + d**2/4)
!
s = amax1(abs(a(1)),abs(a(2)),abs(a(3)))
p1 = a(3)/(3.0*s)
q1 = a(2)/s
r1 = a(1)/s
!
t1 = q - 2.25*p*p
if (abs(t1) .le. tol*abs(q)) t1 = 0.0
w = 0.25*r1*r1
w1 = 0.5*p1*r1*t
w2 = q1*q1*t1/27.0
if (w1 .lt. 0.0) go to 10
   w = w + w1
   sq = w + w2
   go to 12
10 if (w2 .lt. 0.0) go to 11
   w = w + w2
   sq = w + w1
   go to 12
11 sq = w + (w1 + w2)
12 if (abs(sq) .le. tol*w) sq = 0.0
rq = abs(s/a(4))*sqrt(abs(sq))
if (sq .ge. 0.0) go to 40
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
if (abs(x1) .le. abs(x2)) go to 20
   t = x1
   x1 = x2
   x2 = t
20 if (abs(x2) .le. abs(x3)) go to 30
   t = x2
   x2 = x3
   x3 = t
if (abs(x1) .le. abs(x2)) go to 30
   t = x1
   x1 = x2
   x2 = t
!
30 w = x3
if (abs(x2) .lt. 0.1*abs(x3)) go to 70
if (abs(x1) .lt. 0.1*abs(x2)) x1 = - (r/x3)/x2
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
if (abs(t) .le. tol*abs(ra)) go to 41
   w = t - p
   x = -0.5*t - p
   if (abs(x) .le. tol*abs(p)) x = 0.0
41 t = abs(ra - rb)
y = 0.5*rt3*t
!
if (t .le. tol*abs(ra)) go to 60
if (abs(x) .lt. abs(y)) go to 50
   s = abs(x)
   t = y/x
   go to 51
50 s = abs(y)
t = x/y
51 if (s .lt. 0.1*abs(w)) go to 70
w1 = w/s
sum = 1.0 + t*t
if (w1*w1 .lt. 0.01*sum) w = - ((r/sum)/s)/s
z(1) = cmplx(w,0.0)
z(2) = cmplx(x, y)
z(3) = cmplx(x,-y)
return
!
!               At least two roots are equal
!
60 if (abs(x) .lt. abs(w)) go to 61
   if (abs(w) .lt. 0.1*abs(x)) w = - (r/x)/x
   z(1) = cmplx(w, 0.0)
   z(2) = cmplx(x, 0.0)
   z(3) = z(2)
   return
61 if (abs(x) .lt. 0.1*abs(w)) go to 70
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
if (aimag(z(1)) .eq. 0.0) return
z(3) = z(2)
z(2) = z(1)
z(1) = cmplx(w, 0.0)
return
!-----------------------------------------------------------------------
!
!                  CASE WHEN a(1) = 0
!
100 z(1) = (0.0, 0.0)
call qdcrt(a(2), z(2))
return
!
!                   CASE WHEN d = 0
!
110 z(1) = cmplx(-p, 0.0)
w = sqrt(abs(c))
if (c .lt. 0.0) go to 120
   z(2) = cmplx(-p, w)
   z(3) = cmplx(-p,-w)
   return
!
120 if (p .ne. 0.0) go to 130
   z(2) = cmplx(w, 0.0)
   z(3) = cmplx(-w, 0.0)
   return
!
130 x = -(p + sign(w,p))
z(3) = cmplx(x, 0.0)
t = 3.0*a(1)/(a(3)*x)
if (abs(p) .gt. abs(t)) go to 131
   z(2) = cmplx(t, 0.0)
   return
131 z(2) = z(1)
z(1) = cmplx(t, 0.0)
return
end subroutine cbcrt

subroutine dcbcrt (a, zr, zi)
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
double precision :: aq(3), arg, c, cf, d, eps, p, p1, q, q1, r, &
&ra, rb, rq, rt, rt3, r1, s, sf, sq, sum, t, tol, t1, w, w1, w2, x, &
&x1, x2, x3, y, y1, y2, y3
double precision :: dpmpar, dcbrt
!-------------------
data rt3 /1.732050807568877293527446341505872366943d0/
!-----------------------------------------------------------------------
!
!     ***** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!           SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0.
!
         eps = dpmpar(1)
!
!-------------------
if (a(1) .eq. 0.d0) go to 100
p = a(3)/(3.d0*a(4))
q = a(2)/a(4)
r = a(1)/a(4)
tol = 4.d0*eps
!
c = 0.d0
t = a(2) - p*a(3)
if (dabs(t) .gt. tol*dabs(a(2))) c = t/a(4)
!
t = 2.d0*p*p - q
if (dabs(t) .le. tol*dabs(q)) t = 0.d0
d = r + p*t
if (dabs(d) .le. tol*dabs(r)) go to 110
!
!           SET  SQ = (a(4)/S)**2 * (c**3/27 + d**2/4)
!
s = dmax1(dabs(a(1)),dabs(a(2)),dabs(a(3)))
p1 = a(3)/(3.d0*s)
q1 = a(2)/s
r1 = a(1)/s
!
t1 = q - 2.25d0*p*p
if (dabs(t1) .le. tol*dabs(q)) t1 = 0.d0
w = 0.25d0*r1*r1
w1 = 0.5d0*p1*r1*t
w2 = q1*q1*t1/27.d0
if (w1 .lt. 0.d0) go to 10
   w = w + w1
   sq = w + w2
   go to 12
10 if (w2 .lt. 0.d0) go to 11
   w = w + w2
   sq = w + w1
   go to 12
11 sq = w + (w1 + w2)
12 if (dabs(sq) .le. tol*w) sq = 0.d0
rq = dabs(s/a(4))*dsqrt(dabs(sq))
if (sq .ge. 0.d0) go to 40
!
!                   All roots are real
!
arg = datan2(rq, -0.5d0*d)
cf = dcos(arg/3.d0)
sf = dsin(arg/3.d0)
rt = dsqrt(-c/3.d0)
y1 = 2.d0*rt*cf
y2 = -rt*(cf + rt3*sf)
y3 = -(d/y1)/y2
!
x1 = y1 - p
x2 = y2 - p
x3 = y3 - p
if (dabs(x1) .le. dabs(x2)) go to 20
   t = x1
   x1 = x2
   x2 = t
20 if (dabs(x2) .le. dabs(x3)) go to 30
   t = x2
   x2 = x3
   x3 = t
if (dabs(x1) .le. dabs(x2)) go to 30
   t = x1
   x1 = x2
   x2 = t
!
30 w = x3
if (dabs(x2) .lt. 0.1d0*dabs(x3)) go to 70
if (dabs(x1) .lt. 0.1d0*dabs(x2)) x1 = - (r/x3)/x2
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
40 ra = dcbrt(-0.5d0*d - dsign(rq,d))
rb = -c/(3.d0*ra)
t = ra + rb
w = -p
x = -p
if (dabs(t) .le. tol*dabs(ra)) go to 41
   w = t - p
   x = -0.5d0*t - p
   if (dabs(x) .le. tol*dabs(p)) x = 0.d0
41 t = dabs(ra - rb)
y = 0.5d0*rt3*t
!
if (t .le. tol*dabs(ra)) go to 60
if (dabs(x) .lt. dabs(y)) go to 50
   s = dabs(x)
   t = y/x
   go to 51
50 s = dabs(y)
t = x/y
51 if (s .lt. 0.1d0*dabs(w)) go to 70
w1 = w/s
sum = 1.d0 + t*t
if (w1*w1 .lt. 1.d-2*sum) w = - ((r/sum)/s)/s
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
if (dabs(x) .lt. dabs(w)) go to 61
   if (dabs(w) .lt. 0.1d0*dabs(x)) w = - (r/x)/x
   zr(1) = w
   zr(2) = x
   zr(3) = x
   return
61 if (dabs(x) .lt. 0.1d0*dabs(w)) go to 70
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
   call dqdcrt (aq, zr, zi)
   zr(3) = w
   zi(3) = 0.d0
!
if (zi(1) .eq. 0.d0) return
zr(3) = zr(2)
zi(3) = zi(2)
zr(2) = zr(1)
zi(2) = zi(1)
zr(1) = w
zi(1) = 0.d0
return
!-----------------------------------------------------------------------
!
!                  CASE WHEN a(1) = 0
!
100 zr(1) = 0.d0
zi(1) = 0.d0
call dqdcrt(a(2), zr(2), zi(2))
return
!
!                   CASE WHEN d = 0
!
110 zr(1) = -p
zi(1) = 0.d0
w = dsqrt(dabs(c))
if (c .lt. 0.d0) go to 120
   zr(2) = -p
   zr(3) = zr(2)
   zi(2) =  w
   zi(3) = -w
   return
!
120 if (p .ne. 0.d0) go to 130
   zr(2) =  w
   zr(3) = -w
   zi(2) = 0.d0
   zi(3) = 0.d0
   return
!
130 x = -(p + dsign(w,p))
zr(3) =  x
zi(2) = 0.d0
zi(3) = 0.d0
t = 3.d0*a(1)/(a(3)*x)
if (dabs(p) .gt. dabs(t)) go to 131
   zr(2) = t
   return
131 zr(2) = zr(1)
zr(1) = t
return
end subroutine dcbcrt

subroutine qtcrt (a, z)
implicit none
real :: b, b2, c, d, e, h, p, q, r, t, u, v, v1, v2, x, x1, x2, &
&x3, y
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
real, intent(in) :: a(5)
real :: temp(4)
complex, intent(inout) :: z(4)
complex :: w
!
if (a(1) .eq. 0.0) go to 100
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
temp(3) =  p
temp(4) = 1.0
call cbcrt(temp,z)
if (aimag(z(2)) .ne. 0.0) go to 60
!
!               The resolvent cubic has only real roots
!                reorder the roots in increasing order
!
x1 = real(z(1))
x2 = real(z(2))
x3 = real(z(3))
if (x1 .le. x2) go to 10
   t = x1
   x1 = x2
   x2 = t
10 if (x2 .le. x3) go to 20
   t = x2
   x2 = x3
   x3 = t
if (x1 .le. x2) go to 20
   t = x1
   x1 = x2
   x2 = t
!
20 u = 0.0
if (x3 .gt. 0.0) u = sqrt(x3)
if (x2 .le. 0.0) go to 41
if (x1 .ge. 0.0) go to 30
if (abs(x1) .gt. x2) go to 40
x1 = 0.0
!
30 x1 = sqrt(x1)
x2 = sqrt(x2)
if (q .gt. 0.0) x1 = -x1
temp(1) = (( x1 + x2) + u) - b
temp(2) = ((-x1 - x2) + u) - b
temp(3) = (( x1 - x2) - u) - b
temp(4) = ((-x1 + x2) - u) - b
call aord (temp,4)
if (abs(temp(1)) .ge. 0.1*abs(temp(4))) go to 31
   t = temp(2)*temp(3)*temp(4)
   if (t .ne. 0.0) temp(1) = e/t
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
if (q .lt. 0.0) u = -u
!
50 x = -u - b
y = v1 - v2
z(1) = cmplx(x, y)
z(2) = cmplx(x,-y)
x =  u - b
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
if (abs(t) .le. h) go to 70
go to 80
62 x = sqrt(t)
if (q .gt. 0.0) x = -x
!
70 w = csqrt(z(2))
u = 2.0*real(w)
v = 2.0*abs(aimag(w))
t =  x - b
x1 = t + u
x2 = t - u
if (abs(x1) .le. abs(x2)) go to 71
   t = x1
   x1 = x2
   x2 = t
71 u = -x - b
h = u*u + v*v
if (x1*x1 .lt. 0.01*amin1(x2*x2,h)) x1 = e/(x2*h)
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
!                         CASE WHEN a(1) = 0
!
100 z(1) = (0.0, 0.0)
call cbcrt(a(2), z(2))
return
end subroutine qtcrt

subroutine dqtcrt (a, zr, zi)
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
&v1, v2, w(2), x, x1, x2, x3
!
if (a(1) .eq. 0.d0) go to 100
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
temp(3) =  p
temp(4) = 1.d0
call dcbcrt (temp, zr, zi)
if (zi(2) .ne. 0.d0) go to 60
!
!               The resolvent cubic has only real roots
!                reorder the roots in increasing order
!
x1 = zr(1)
x2 = zr(2)
x3 = zr(3)
if (x1 .le. x2) go to 10
   t = x1
   x1 = x2
   x2 = t
10 if (x2 .le. x3) go to 20
   t = x2
   x2 = x3
   x3 = t
if (x1 .le. x2) go to 20
   t = x1
   x1 = x2
   x2 = t
!
20 u = 0.d0
if (x3 .gt. 0.d0) u = dsqrt(x3)
if (x2 .le. 0.d0) go to 41
if (x1 .ge. 0.d0) go to 30
if (dabs(x1) .gt. x2) go to 40
x1 = 0.d0
!
30 x1 = dsqrt(x1)
x2 = dsqrt(x2)
if (q .gt. 0.d0) x1 = -x1
zr(1) = (( x1 + x2) + u) - b
zr(2) = ((-x1 - x2) + u) - b
zr(3) = (( x1 - x2) - u) - b
zr(4) = ((-x1 + x2) - u) - b
call daord (zr, 4)
if (dabs(zr(1)) .ge. 0.1d0*dabs(zr(4))) go to 31
   t = zr(2)*zr(3)*zr(4)
   if (t .ne. 0.d0) zr(1) = e/t
31 zi(1) = 0.d0
zi(2) = 0.d0
zi(3) = 0.d0
zi(4) = 0.d0
return
!
40 v1 = dsqrt(dabs(x1))
v2 = 0.d0
go to 50
41 v1 = dsqrt(dabs(x1))
v2 = dsqrt(dabs(x2))
if (q .lt. 0.d0) u = -u
!
50 zr(1) = -u - b
zi(1) = v1 - v2
zr(2) =  zr(1)
zi(2) = -zi(1)
zr(3) =  u - b
zi(3) = v1 + v2
zr(4) =  zr(3)
zi(4) = -zi(3)
return
!
!                The resolvent cubic has complex roots
!
60 t = zr(1)
x = 0.d0
if (t) 61,70,62
61 h = dabs(zr(2)) + dabs(zi(2))
if (dabs(t) .le. h) go to 70
go to 80
62 x = dsqrt(t)
if (q .gt. 0.d0) x = -x
!
70 w(1) = zr(2)
w(2) = zi(2)
call dcsqrt (w, w)
u = 2.d0*w(1)
v = 2.d0*dabs(w(2))
t =  x - b
x1 = t + u
x2 = t - u
if (dabs(x1) .le. dabs(x2)) go to 71
   t = x1
   x1 = x2
   x2 = t
71 u = -x - b
h = u*u + v*v
if (x1*x1 .lt. 1.d-2*dmin1(x2*x2,h)) x1 = e/(x2*h)
zr(1) = x1
zr(2) = x2
zi(1) = 0.d0
zi(2) = 0.d0
zr(3) =  u
zr(4) =  u
zi(3) =  v
zi(4) = -v
return
!
80 v = dsqrt(dabs(t))
zr(1) = -b
zr(2) = -b
zr(3) = -b
zr(4) = -b
zi(1) =  v
zi(2) = -v
zi(3) =  v
zi(4) = -v
return
!
!                         CASE WHEN a(1) = 0
!
100 zr(1) = 0.d0
zi(1) = 0.d0
call dcbcrt(a(2), zr(2), zi(2))
return
end subroutine dqtcrt

subroutine drpoly (op, ideg, zeror, zeroi, num, wk, dwk)
implicit none
integer :: idp1
!
!     This subroutine finds the zeros of a real polynomial.
!
!     op          - DOUBLE PRECISION ARRAY OF LENGTH ideg + 1.
!                   On input this array contains the coefficients
!                   in order of decreasing powers.
!
!     ideg        - INTEGER DEGREE OF THE POLYNOMIAL.
!
!     zeror,zeroi - double precision arrays if length ideg.
!                   On output these arrays contain the real and
!                   imaginary parts of the zeros.
!
!     num         - VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
!                   IF num = -1 THEN THE LEADING COEFFICIENT OF THE
!                   POLYNOMIAL IS 0 OR ideg .LT. 1. OTHERWISE, num
!                   is the number of zeros that were obtained. If
!                   num .GE. 1 THEN THE REAL AND IMAGINARY PARTS OF
!                   the zeros are stored in zeror(J) and zeroi(J)
!                   FOR J = 1,...,num.
!
!     wk          - REAL ARRAY OF LENGTH ideg + 1. THE ARRAY IS
!                   a work space for the routine.
!
!     DWK         - DOUBLE PRECISION ARRAY OF LENGTH 6*(ideg + 1).
!                   The array is a work space for the routine.
!
!     The subroutine uses single precision calculations for scaling,
!     bounds, and error calculations. All other calculations are done
!     in double precision.
!
integer :: ideg
integer, intent(inout) :: num
double precision :: op(*)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), &
&dwk(*)
real, intent(inout) :: wk(*)
!
integer :: p, qp, k, qk, svk, tmp
!
if (ideg .lt. 1) go to 10
!
!     Partition the workspace DWK and obtain the zeros
!
idp1 = ideg + 1
!
p  = 1
qp = p  + idp1
k  = qp + idp1
qk = k  + idp1
svk = qk  + idp1
tmp = svk + idp1
!
call drply1 (op,ideg,idp1,zeror,zeroi,dwk(p),dwk(qp),dwk(k), &
&dwk(qk),dwk(svk),dwk(tmp),wk,num)
return
!
!     Error return
!
10 num = -1
return
end subroutine drpoly

subroutine drply1 (op,ideg,idp1,zeror,zeroi,p,qp,k,qk,svk, &
&temp,pt,num)
implicit none
integer :: ideg, idp1, num
integer :: i, j, jj, l, n, nm1, nn, nz
!-------------------------
double precision :: op(idp1), zeror(ideg), zeroi(ideg), p(idp1), &
&qp(idp1), k(idp1), qk(idp1), svk(idp1), temp(idp1)
real :: pt(idp1)
!
double precision :: aa, bb, cc, factor, t
real :: lo, max, min, xx, yy, cosr, sinr, x, xxx, sc, bnd, xm, ff, &
&df, dx, base, smalno, infin
integer :: cnt
logical :: zerok
!
real :: spmpar
integer :: ipmpar
double precision :: dpmpar
!-------------------------
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
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
if (op(1) .ne. 0.d0) go to 10
   num = -1
   return
!
!     Remove the zeros at the origin if any
!
10 if (op(nn) .ne. 0.0d0) go to 20
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
40 if (n .gt. 2) go to 60
if (n .lt. 1) return
!
!     Calculate the final zero or pair of zeros
!
num = ideg
if (n .eq. 2) go to 50
   zeror(ideg) = -p(2)/p(1)
   zeroi(ideg) = 0.0d0
   return
50 call quadpl(p(1), p(2), p(3), zeror(ideg - 1), zeroi(ideg - 1), &
&zeror(ideg), zeroi(ideg))
return
!
!     Find largest and smallest moduli of coefficients.
!
60 max = 0.0
min = infin
do i = 1,nn
   x = abs(sngl(p(i)))
   if (x .gt. max) max = x
   if (x .ne. 0.0 .and. x .lt. min) min = x
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
if (sc .gt. 1.0) go to 80
if (max .lt. 10.0) go to 110
if (sc .eq. 0.0) sc = smalno
go to 90
80 if (infin/sc .lt. max) go to 110
90 l = alog(sc)/alog(base) + 0.5
factor = dble(base)**l
if (factor .eq. 1.d0) go to 110
do i = 1,nn
   p(i) = factor*p(i)
end do
!
!     Compute lower bound on moduli of zeros.
!
110 do i=1,nn
   pt(i) = abs(sngl(p(i)))
end do
pt(nn) = -pt(nn)
!
!     Compute upper estimate of bound
!
x = exp((alog(-pt(nn)) - alog(pt(1)))/float(n))
if (pt(n) .eq. 0.0) go to 130
!
!     If the Newton step at the origin is better then use it.
!
xm = -pt(nn)/pt(n)
if (xm .lt. x) x = xm
!
!     CHOP THE INTERVAL (0,x) UNTIL ff .LE. 0.
!
130 xm = x*.1
ff = pt(1)
do i = 2,nn
   ff = ff*xm + pt(i)
end do
if (ff .le. 0.0) go to 150
x = xm
go to 130
150 dx = x
!
!     Do Newton iteration until x converges to two decimal places.
!
160 if (abs(dx/x) .le. 0.005) go to 180
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
zerok = k(n) .eq. 0.d0
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
   zerok = dabs(k(n)) .le. dabs(bb)*eta*10.
   go to 230
!
!     Use unscaled form of recurrence
!
210 do i = 1,nm1
      j = nn - i
      k(j) = k(j - 1)
   end do
   k(1) = 0.d0
   zerok = k(n).eq.0.d0
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
   if (nz .ne. 0) go to 300
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
if (nz .eq. 1) go to 40
num = num + 1
zeror(num) = lzr
zeroi(num) = lzi
go to 40
end subroutine drply1

subroutine fxshfr(l2, nz, nn, p, qp, k, qk, svk)
implicit none
integer :: nn
integer :: n
!
!     Computes up to  l2  fixed shift k-polynomials,
!     testing for convergence in the linear or quadratic
!     case. Initiates one of the variable SHIFT
!     iterations and returns with the number of zeros
!     found.
!
!     l2 - limit of fixed shift steps
!     nz - number of zeros found
!
double precision :: p(nn), qp(nn), k(nn), qk(nn), svk(nn)
double precision :: svu, svv, ui, vi, s
real :: betas, betav, oss, ovv, ss, vv, ts, tv, ots, otv, tvv, tss
integer :: l2, nz, type, i, j, iflag
logical :: vpass, spass, vtry, stry
!
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
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
   if (k(n) .ne. 0.d0) ss = -p(nn)/k(n)
   tv = 1.0
   ts = 1.0
   if (j .eq. 1 .or. type .eq. 3) go to 70
!
!     Compute relative measures of convergence of s and v
!     sequences
!
   if (vv .ne. 0.0) tv = abs((vv - ovv)/vv)
   if (ss .ne. 0.0) ts = abs((ss - oss)/ss)
!
!     If decreasing, multiply two most recent
!     convergence measures
!
   tvv = 1.0
   if (tv .lt. otv) tvv = tv*otv
   tss = 1.0
   if (ts .lt. ots) tss = ts*ots
!
!     Compare with convergence criteria
!
   vpass = tvv.lt.betav
   spass = tss.lt.betas
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
&tss .lt. tvv)) go to 40
20 call quadit(ui, vi, nz, nn, p, qp, k, qk)
   if (nz .gt. 0) return
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
   if (nz .gt. 0) return
!
!     Linear iteration has failed. Flag that it has been
!     tried and decrease the convergence criterion
!
   stry = .true.
   betas = betas*0.25
   if (iflag .eq. 0) go to 50
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
   do i=1,n
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

subroutine quadit(uu, vv, nz, nn, p, qp, k, qk)
implicit none
integer :: nn
integer :: n
!
!     Variable-shift k-polynomial iteration for A
!     quadratic factor converges only if the zeros are
!     equimodular or nearly so.
!
!     uu,vv - coefficients of starting quadratic
!     nz - number of zero found
!
double precision :: uu, vv, p(nn), qp(nn), k(nn), qk(nn)
double precision :: ui, vi
real :: mp, omp, ee, relstp, t, zm
integer :: nz, type, i, j
logical :: tried
!
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!
n = nn - 1
nz = 0
tried = .false.
u = uu
v = vv
j = 0
! Main loop
10 call quadpl(1.d0, u, v, szr, szi, lzr, lzi)
!
!     RETURN IF ROOTS OF THE QUADRATIC ARE REAL AND NOT CLOSE
!     to multiple or nearly equal and of opposite sign
!
if (dabs(dabs(szr) - dabs(lzr)) .gt. 1.d-2*dabs(lzr)) &
&return
!
!     Evaluate polynomial by quadratic synthetic division
!
call quadsd(nn, u, v, p, qp, a, b)
mp = dabs(a - szr*b) + dabs(szi*b)
!
!     Compute a rigorous bound on the rounding error in
!     EVALUTING p
!
zm = sqrt(abs(sngl(v)))
ee = 2.0*abs(sngl(qp(1)))
t = -szr*b
do 20 i = 2,n
   ee = ee*zm + abs(sngl(qp(i)))
20 continue
ee = ee*zm + abs(sngl(a) + t)
ee = (5.0*mre + 4.0*are)*ee - (5.0*mre + 2.0*are)* &
&(abs(sngl(a) + t) + abs(sngl(b))*zm) + &
&2.0*are*abs(t)
!
!     Iteration has converged sufficiently if the
!     polynomial value is less than 20 times this bound
!
if (mp .gt. 20.0*ee) go to 30
nz = 2
return
30 j = j + 1
!
!     STOP ITERATION AFTER 20 STEPS
!
if (j .gt. 20) return
if (j .lt. 2) go to 50
if (relstp .gt. 0.01 .or. mp .lt. omp .or. tried) go to 50
!
!     A cluster appears to be stalling the convergence.
!     Five fixed shift steps are taken with A u,v close
!     to the cluster
!
if (relstp .lt. eta) relstp = eta
relstp = sqrt(relstp)
u = u - u*relstp
v = v + v*relstp
call quadsd(nn, u, v, p, qp, a, b)
do i = 1,5
   call calcsc(type, n, k, qk)
   call nextk(type, n, qp, k, qk)
end do
tried = .true.
j = 0
50 omp = mp
!
!     Calculate next k polynomial and new u and v
!
call calcsc(type, n, k, qk)
call nextk(type, n, qp, k, qk)
call calcsc(type, n, k, qk)
call newest(type, ui, vi, nn, p, k)
!
!     If vi is zero the iteration is not converging
!
if (vi .eq. 0.d0) return
relstp = dabs((vi - v)/vi)
u = ui
v = vi
go to 10
end subroutine quadit

subroutine realit(sss, nz, iflag, nn, p, qp, k, qk)
implicit none
integer :: iflag, nn, nz
integer :: i, j, n
!
!     Variable-shift H polynomial iteration for a real zero.
!
!     sss   - STARTING ITERATE
!     nz    - NUMBER OF ZERO FOUND
!     iflag - flag to indicate a pair of zeros near the real
!             axis.
!
double precision :: sss, p(nn), qp(nn), k(nn), qk(nn)
double precision :: pv, kv, t, s
real :: ms, mp, omp, ee
!
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!
n = nn - 1
nz = 0
s = sss
iflag = 0
j = 0
!
!     Evaluate p at s
!
10 pv = p(1)
qp(1) = pv
do 20 i = 2,nn
   pv = pv*s + p(i)
   qp(i) = pv
20 continue
mp = dabs(pv)
!
!     Compute a rigorous bound on the error in evaluating p
!
ms = dabs(s)
ee = (mre/(are+mre))*abs(sngl(qp(1)))
do i = 2,nn
   ee = ee*ms + abs(sngl(qp(i)))
end do
!
!     Iteration has converged sufficiently if the
!     polynomial value is less than 20 times this bound
!
if (mp .gt. 20.0*((are + mre)*ee - mre*mp)) go to 40
nz = 1
szr = s
szi = 0.d0
return
40 j = j + 1
!
!     STOP ITERATION AFTER 10 STEPS
!
if (j .gt. 10) return
if (j .lt. 2) go to 50
if (dabs(t) .gt. 1.d-3*dabs(s-t) .or. mp .le. omp) &
&go to 50
!
!     A cluster of zeros near the real axis has been
!     encountered return with iflag set to initiate A
!     quadratic iteration
!
iflag = 1
sss = s
return
!
!     RETURN IF THE POLYNOMIAL VALUE HAS INCREASED
!     significantly
!
50 omp = mp
!
!     Compute t, the next polynomial, and the new iterate
!
kv = k(1)
qk(1) = kv
do i = 2,n
   kv = kv*s + k(i)
   qk(i) = kv
end do
if (dabs(kv) .le. dabs(k(n))*10.*eta) go to 80
!
!     Use the scaled form of the recurrence if the value
!     of k at s is nonzero
!
t = -pv/kv
k(1) = qp(1)
do i = 2,n
   k(i) = t*qk(i-1) + qp(i)
end do
go to 100
!
!     Use unscaled form
!
80 k(1) = 0.0d0
do i = 2,n
   k(i) = qk(i-1)
end do
100 kv = k(1)
do i = 2,n
   kv = kv*s + k(i)
end do
t = 0.d0
if (dabs(kv) .gt. dabs(k(n))*10.*eta) t = -pv/kv
s = s + t
go to 10
end subroutine realit

subroutine calcsc(type, n, k, qk)
implicit none
integer :: n
!
!     This routine calculates scalar quantities used to
!     compute the next k polynomial and new estimates of
!     the quadratic coefficients.
!
!     type - integer variable SET here indicating how the
!            calculations are normalized to avoid overflow
!
integer :: type
double precision :: k(n), qk(n)
double precision :: tol
!
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!
!     Synthetic division of k by the quadratic 1,u,v
!
call quadsd(n, u, v, k, qk, c, d)
tol = 100.0*eta
if (dabs(c) .gt. tol*dabs(k(n))) go to 10
if (dabs(d) .gt. tol*dabs(k(n - 1))) go to 10
type = 3
!
!     type=3 INDICATES THE QUADRATIC IS ALMOST A FACTOR OF k
!
return
10 if (dabs(d) .lt. dabs(c)) go to 20
type = 2
!
!     type=2 INDICATES THAT ALL FORMULAS ARE DIVIDED BY d
!
e = a/d
f = c/d
g = u*b
h = v*b
a3 = (a + g)*e + h*(b/d)
a1 = b*f - a
a7 = (f + u)*a + h
return
20 type = 1
!
!     type=1 INDICATES THAT ALL FORMULAS ARE DIVIDED BY c
!
e = a/c
f = d/c
g = u*e
h = v*b
a3 = a*e + (h/c + g)*b
a1 = b - a*(d/c)
a7 = a + g*d + h*f
return
end subroutine calcsc

subroutine nextk(type, n, qp, k, qk)
implicit none
integer :: n
integer :: i
!
!     Computes the next k polynomials using the scalars
!     computed in calcsc.
!
integer :: type
double precision :: qp(n), k(n), qk(n)
double precision :: temp
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!
if (type .eq. 3) go to 40
temp = a
if (type .eq. 1) temp = b
if (dabs(a1) .gt. dabs(temp)*eta*10.) go to 20
!
!     If a1 is nearly zero then use a special form of the
!     recurrence
!
k(1) = 0.d0
k(2) = -a7*qp(1)
do 10 i = 3,n
   k(i) = a3*qk(i-2) - a7*qp(i-1)
10 continue
return
!
!     Use scaled form of the recurrence
!
20 a7 = a7/a1
a3 = a3/a1
k(1) = qp(1)
k(2) = qp(2) - a7*qp(1)
do i = 3,n
   k(i) = a3*qk(i-2) - a7*qp(i-1) + qp(i)
end do
return
!
!     Use unscaled form of the recurrence if type is 3
!
40 k(1) = 0.d0
k(2) = 0.d0
do i = 3,n
   k(i) = qk(i - 2)
end do
return
end subroutine nextk

subroutine newest (type, uu, vv, nn, p, k)
implicit none
integer :: nn
integer :: n
!
!     Compute new estimates of the quadratic coefficients
!     using the scalars computed in calcsc.
!
integer :: type
double precision :: uu, vv, p(nn), k(nn)
double precision :: a4, a5, b1, b2, c1, c2, c3, c4, temp
!
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
&e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!
!     Use formulas appropriate to setting of type.
!
n = nn - 1
if (type .eq. 3) go to 30
if (type .eq. 2) go to 10
   a4 = a + u*b + h*f
   a5 = c + (u + v*f)*d
   go to 20
10 a4 = (a + g)*f + h
a5 = (f + u)*c + v*d
!
!     Evaluate new quadratic coefficients.
!
20 b1 = -k(n)/p(nn)
b2 = -(k(n - 1) + b1*p(n))/p(nn)
c1 = v*b2*a1
c2 = b1*a7
c3 = b1*b1*a3
c4 = c1 - c2 - c3
temp = a5 + b1*a4 - c4
if (temp .eq. 0.d0) go to 30
uu = u - (u*(c3 + c2) + v*(b1*a1 + b2*a7))/temp
vv = v*(1.d0 + c4/temp)
return
!
!     IF type=3 THE QUADRATIC IS ZEROED
!
30 uu = 0.d0
vv = 0.d0
return
end subroutine newest

subroutine quadsd (nn, u, v, p, q, a, b)
implicit none
integer, intent(in) :: nn
integer :: i
!
!     Divides p by the quadratic  1,u,v  placing the
!     quotient in q and the remainder in A,b.
!
double precision, intent(in) :: p(nn)
double precision, intent(inout) :: q(nn)
double precision, intent(in) :: u, v
double precision, intent(out) :: a, b
double precision :: c
!
b = p(1)
q(1) = b
a = p(2) - u*b
q(2) = a
do i = 3,nn
   c = p(i) - u*a - v*b
   q(i) = c
   b = a
   a = c
end do
return
end subroutine quadsd

subroutine quadpl(a, b1, c, sr, si, lr, li)
implicit none
!
!     CALCULATE THE ZEROS OF THE QUADRATIC a*Z**2+b1*Z+c.
!     The quadratic formula, modified to avoid overflow,
!     is used to find the larger zero if the zeros are
!     real, and both zeros if the zeros are complex.
!     The smaller real zero is found directly from the
!     product of the zeros c/a.
!
double precision, intent(in) :: a, b1, c
double precision, intent(inout) :: sr, si, lr, li
double precision :: b, d, e
!
if (a .ne. 0.d0) go to 20
   sr = 0.d0
   if (b1 .ne. 0.d0) sr = -c/b1
   lr = 0.d0
10 si = 0.d0
   li = 0.d0
   return
!
20 if (c .ne. 0.d0) go to 30
   sr = 0.d0
   lr = -b1/a
   go to 10
!
!     Compute discriminant avoiding overflow
!
30 b = b1/2.d0
if (dabs(b) .lt. dabs(c)) go to 40
   e = 1.d0 - (a/b)*(c/b)
   d = dsqrt(dabs(e))*dabs(b)
   go to 50
40 e = a
if (c .lt. 0.d0) e = -a
e = b*(b/dabs(c)) - e
d = dsqrt(dabs(e))*dsqrt(dabs(c))
50 if (e .lt. 0.d0) go to 60
!
!     real zeros
!
if (b .ge. 0.d0) d = -d
lr = (-b + d)/a
sr = 0.d0
if (lr .ne. 0.d0) sr = (c/lr)/a
go to 10
!
!     Complex conjugate zeros
!
60 sr = -b/a
lr = sr
si = dabs(d/a)
li = -si
return
end subroutine quadpl

subroutine dcpoly (opr,opi,ideg,zeror,zeroi,num,wk)
implicit none
integer, intent(inout) :: num
integer :: idp1
!
!     This subroutine finds the zeros of a complex polynomial.
!
!     opr,opi     - DOUBLE PRECISION ARRAYS OF LENGTH ideg + 1.
!                   On input these arrays contain the real and imaginary
!                   parts of the coefficients in order of decreasing
!                   powers.
!
!     ideg        - INTEGER DEGREE OF THE POLYNOMIAL.
!
!     zeror,zeroi - double precision arrays of length ideg.
!                   On output these arrays contain the real and
!                   imaginary parts of the zeros.
!
!     num         - VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
!                   IF num = -1 THEN THE LEADING COEFFICIENT OF THE
!                   POLYNOMIAL IS 0 OR ideg .LT. 1. OTHERWISE, num
!                   is the number of zeros that were obtained. If
!                   num .GE. 1 THEN THE REAL AND IMAGINARY PARTS OF
!                   the zeros are stored in zeror(J) and zeroi(J)
!                   FOR J = 1,...,num.
!
!     wk          - DOUBLE PRECISION ARRAY OF LENGTH 10*(ideg + 1).
!                   The array is a work space for the routine.
!
!     The code has been written to reduce the chance of overflow
!     occurring. If it does occur, there is still a possibility that
!     the zerofinder will work provided the overflowed quantity is
!     replaced by a large number.
!
integer :: ideg
double precision, intent(in) :: opr(*), opi(*)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), wk(*)
!
integer :: pr, pi, qpr, qpi, hr, hi, qhr, qhi, shr, shi
!
if (ideg .lt. 1) go to 10
!
!     Partition the workspace and obtain the zeros
!
idp1 = ideg + 1
!
pr  = 1
pi  = pr +  idp1
qpr = pi +  idp1
qpi = qpr + idp1
hr  = qpi + idp1
hi  = hr  + idp1
qhr = hi  + idp1
qhi = qhr + idp1
shr = qhi + idp1
shi = shr + idp1
!
call dcply1 (opr,opi,ideg,idp1,zeror,zeroi,wk(pr),wk(pi), &
&wk(qpr),wk(qpi),wk(hr),wk(hi),wk(qhr),wk(qhi), &
&wk(shr),wk(shi),num)
return
!
!     Error return
!
10 num = -1
return
end subroutine dcpoly

subroutine dcply1 (opr,opi,ideg,idp1,zeror,zeroi,pr,pi,qpr,qpi, &
&hr,hi,qhr,qhi,shr,shi,num)
implicit none
integer :: ideg
integer, intent(in) :: idp1
integer, intent(out) :: num
integer :: i, nn
integer :: ipmpar
!-------------------------
double precision, intent(in) :: opr(idp1), opi(idp1)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), &
&pr(idp1), pi(idp1), qpr(idp1), qpi(idp1), hr(idp1), hi(idp1), &
&qhr(idp1), qhi(idp1), shr(idp1), shi(idp1)
double precision :: sr, si, tr, ti, pvr, pvi, are, mre, eta, infin
double precision :: xx, yy, cosr, sinr, smalno, base, xxx, zr, zi, &
&bnd, dcpabs, dpmpar, scalcp
logical :: conv
integer :: cnt1, cnt2
!-------------------------
!     The following statements set the machine constants used
!     in the code. The meaning of the constants are ...
!
!     eta     THE SMALLEST POSITIVE NUMBER SUCH THAT
!             1.D0 + eta is greater than 1.D0
!     smalno  the smallest positive floating point number.
!     INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
!     BASE    THE BASE OF THE FLOATING POINT ARITHMETIC
!             being used.
!
                 eta = dpmpar(1)
                 smalno = dpmpar(2)
                 infin = dpmpar(3)
                 base = ipmpar(4)
!-------------------------
!
!     Initialization
!
   are = eta
   mre = 2.d0*dsqrt(2.d0)*eta
   xx = .70710678
   yy = -xx
   cosr = -.069756474
   sinr = .99756405
   num = 0
   nn = idp1
!
!     The algorithm fails if the leading coefficient is zero
!
   if (opr(1) .ne. 0.d0 .or. opi(1) .ne. 0.d0) go to 10
      num = -1
      return
!
!     Remove the zeros at the origin if any.
!
10 if (opr(nn) .ne. 0.d0 .or. opi(nn) .ne. 0.d0) go to 20
      num = num + 1
      zeror(num) = 0.d0
      zeroi(num) = 0.d0
      nn = nn - 1
      go to 10
!
!     Make a copy of the coefficients.
!
20 if (nn .lt. 2) return
   do i = 1,nn
      pr(i) = opr(i)
      pi(i) = opi(i)
      shr(i) = dcpabs(pr(i),pi(i))
   end do
!
!     Scale the polynomial.
!
   bnd = scalcp (nn,shr,eta,infin,smalno,base)
   if (bnd .eq. 1.d0) go to 40
   do i = 1,nn
      pr(i) = bnd*pr(i)
      pi(i) = bnd*pi(i)
   end do
!
!     Start the algorithm for obtaining a zero.
!
40 if (nn .gt. 2) go to 50
!
      num = ideg
      call cdivid(-pr(2),-pi(2),pr(1),pi(1),zeror(ideg), &
&zeroi(ideg))
      return
!
!     Calculate BND, a lower bound on the modulus of the zeros.
!
50 do i = 1,nn
      shr(i) = dcpabs(pr(i),pi(i))
   end do
   call cauchy(nn,bnd,shr,shi)
!
!     Outer loop to control two major passes with different
!     sequences of shifts.
!
   do cnt1 = 1,2
!
!     First stage calculation. No shift.
!
      call noshft(5,nn,tr,ti,eta,pr,pi,hr,hi)
!
!     Inner loop to select a shift.
!
      do cnt2 = 1,9
!
!     The shift is chosen with modulus BND and amplitude rotated
!     by 94 degrees from the previous shift.
!
         xxx = cosr*xx - sinr*yy
         yy = sinr*xx + cosr*yy
         xx = xxx
         sr = bnd*xx
         si = bnd*yy
!
!     Second stage calculation, fixed shift. The second stage jumps
!     directly to the third stage iteration.
!
         call fxshft(10*cnt2,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi, &
&qhr,qhi,shr,shi,sr,si,tr,ti,pvr,pvi, &
&are,mre,eta,infin)
         if (conv) go to 100
!
!     If the iteration is unsuccessful another shift is chosen.
!
      end do
!
!     If 9 shifts fail, the outer loop is repeated with another
!     sequence of shifts.
!
   end do
   return
!
!     A zero has been obtained. Store the zero and deflate
!     the polynomial.
!
100 num = num + 1
   zeror(num) = zr
   zeroi(num) = zi
   nn = nn - 1
   do i = 1,nn
      pr(i) = qpr(i)
      pi(i) = qpi(i)
   end do
   go to 40
   end subroutine dcply1

double precision function scalcp(nn,pt,eta,infin,smalno,base)
implicit none
integer, intent(in) :: nn
integer :: i, l
!
!     Returns a scale factor to multiply the coefficients of the
!     polynomial. The scaling is done to avoid overflow and to avoid
!     undetected underflow interfering with the convergence criterion.
!     The factor is a power of the base.
!
!     pt - modulus of the coefficients of P
!     eta,infin,smalno,base - constants describing the
!            floating point arithmetic.
!
double precision, intent(in) :: pt(nn), eta, infin, smalno, base
double precision :: hi, lo, max, min, x, sc
!
!     Find the largest and smallest moduli of coefficients.
!
hi = dsqrt(infin)
lo = smalno/eta
max = 0.d0
min = infin
do i = 1,nn
   x = pt(i)
   if (x .gt. max) max = x
   if (x .ne. 0.d0 .and. x .lt. min) min = x
end do
!
!     Scale only if there are very large or very small coefficients.
!
scalcp = 1.d0
sc = lo/min
if (sc .gt. 1.d0) go to 20
if (max .le. hi) return
sc = 1.d0/(dsqrt(max)*dsqrt(min))
go to 30
20 if (infin/sc .lt. max) return
30 l = dlog(sc)/dlog(base) + 0.5d0
scalcp = base**l
return
end function scalcp

subroutine cauchy(nn,bnd,pt,q)
implicit none
integer, intent(in) :: nn
integer :: i, n
!
!     Cauchy computes a lower bound bnd on the moduli of the zeros
!     of a polynomial. pt is the modulus of the coefficients.
!
double precision, intent(inout) :: q(nn), pt(nn)
double precision :: x, xm, f, dx, df
double precision, intent(inout) :: bnd
!
pt(nn) = -pt(nn)
!
!     Compute upper estimate of bound.
!
n = nn - 1
x = dexp((dlog(-pt(nn)) - dlog(pt(1)))/dble(float(n)))
if (pt(n) .eq. 0.d0) go to 20
!
!     If the Newton step at the origin is better then use it.
!
   xm = -pt(nn)/pt(n)
   if (xm .lt. x) x = xm
!
!     CHOP THE INTERVAL (0,x) UNTIL f .LE. 0.
!
20 xm = 0.1d0*x
f = pt(1)
do i = 2,nn
   f = f*xm + pt(i)
end do
if (f .le. 0.d0) go to 40
   x = xm
   go to 20
40 dx = x
!
!     Do Newton iteration until x converges to two decimal places.
!
50 if (dabs(dx/x) .le. 0.005d0) go to 70
   q(1) = pt(1)
   do i = 2,nn
      q(i) = q(i - 1)*x + pt(i)
   end do
   f = q(nn)
   df = q(1)
   do i = 2,n
      df = df*x + q(i)
   end do
   dx = f/df
   x = x - dx
   go to 50
!
70 bnd = x
return
end subroutine cauchy

subroutine noshft(l1,nn,tr,ti,eta,pr,pi,hr,hi)
implicit none
integer, intent(in) :: l1, nn
integer :: i, j, jj, n, nm1
!
!     Computes the derivative polynomial as the initial H
!     polynomial and computes l1 no-shift H polynomials.
!
double precision, intent(inout) :: tr, ti
double precision, intent(in) :: eta, pr(nn), pi(nn)
double precision, intent(inout) :: hr(nn), hi(nn)
double precision :: dn, t1, t2, xni, dcpabs
!
n = nn - 1
nm1 = n - 1
dn = n
do 10 i = 1,n
   xni = nn - i
   hr(i) = xni*pr(i)/dn
   hi(i) = xni*pi(i)/dn
10 continue
!
do 50 jj = 1,l1
   if (dcpabs(hr(n),hi(n)) .le. 10.d0*eta*dcpabs(pr(n),pi(n))) &
&go to 30
   call cdivid(-pr(nn),-pi(nn),hr(n),hi(n),tr,ti)
   do i = 1,nm1
      j = nn - i
      t1 = hr(j - 1)
      t2 = hi(j - 1)
      hr(j) = tr*t1 - ti*t2 + pr(j)
      hi(j) = tr*t2 + ti*t1 + pi(j)
   end do
   hr(1) = pr(1)
   hi(1) = pi(1)
   go to 50
!
!     If the constant term is essentially zero, shift H coefficients.
!
30 do i = 1,nm1
      j = nn - i
      hr(j) = hr(j - 1)
      hi(j) = hi(j - 1)
   end do
   hr(1) = 0.d0
   hi(1) = 0.d0
50 continue
return
end subroutine noshft

subroutine fxshft(l2,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi, &
&qhr,qhi,shr,shi,sr,si,tr,ti,pvr,pvi, &
&are,mre,eta,infin)
implicit none
integer, intent(in) :: l2, nn
integer :: i, j, n
!
!     Computes l2 fixed-shift H polynomials and tests for convergence.
!     Initiates a variable-shift iteration and returns with the
!     approximate zero if successful.
!
!     l2 - limit of fixed-shift steps
!     zr,zi - approximate zero if conv is .True.
!     conv - logical variable indicating convergence of stage 3
!            iteration
!
double precision, intent(inout) :: sr, si, tr, ti, pvr, pvi
double precision, intent(in) :: are, mre, eta, infin, pr(nn), &
&pi(nn)
double precision, intent(inout) :: qpr(nn), qpi(nn), hr(nn), &
&hi(nn), qhr(nn), qhi(nn), shr(nn), shi(nn)
double precision, intent(inout) :: zr, zi
double precision :: otr, oti, svsr, svsi, dcpabs
logical, intent(inout) :: conv
logical :: test, pasd, bool
!
   n = nn - 1
!
!     Evaluate P at S
!
   call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
   test = .true.
   pasd = .false.
!
!     CALCULATE T = -P(S)/H(S)
!
   call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
!
!     Main loop for one second stage step.
!
   do 50 j = 1,l2
      otr = tr
      oti = ti
!
!     Compute next H polynomial and new T.
!
      call nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
      call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
      zr = sr + tr
      zi = si + ti
!
!     Test for convergence unless stage 3 has failed once or this
!     is the last H polynomial.
!
      if (bool .or. (.not. test) .or. j .eq. l2) go to 50
      if (dcpabs(tr - otr,ti - oti) .ge. 0.5d0*dcpabs(zr,zi)) &
&go to 40
      if (.not. pasd) go to 30
!
!     The weak convergence test has been passed twice. Start the
!     third shift iteration after saving the current H polynomial
!     and shift.
!
         do 10 i = 1,n
            shr(i) = hr(i)
            shi(i) = hi(i)
10 continue
         svsr = sr
         svsi = si
         call vrshft(10,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr, &
&qhi,sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
         if (conv) return
!
!     The iteration failed to converge. Turn off testing and restore
!     H,S,PV AND T.
!
         test = .false.
         do i = 1,n
            hr(i) = shr(i)
            hi(i) = shi(i)
         end do
         sr = svsr
         si = svsi
         call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
         call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
         go to 50
!
30 pasd = .true.
      go to 50
!
40 pasd = .false.
50 continue
!
!     Attempt an iteration with final H polynomial from second stage.
!
call vrshft(10,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr,qhi, &
&sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
return
end subroutine fxshft

subroutine vrshft(l3,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr,qhi, &
&sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
implicit none
integer, intent(in) :: l3, nn
integer :: i, j, n
!
!     Carries out the third stage iteration.
!
!     l3 - limit of steps in stage 3.
!     zr,zi - on entry contain the initial iterate. If the
!             iteration converges zr,zi contain the final
!             iterate on exit.
!     conv  - the value is .True. If the iteration converges.
!
double precision, intent(out) :: sr, si
double precision, intent(inout) :: tr, ti, pvr, pvi
double precision, intent(in) :: are, mre, eta, infin, pr(nn), &
&pi(nn)
double precision, intent(inout) :: qpr(nn), qpi(nn), hr(nn), &
&hi(nn), qhr(nn), qhi(nn)
double precision, intent(inout) :: zr, zi
double precision :: mp, ms, omp, relstp, r1, r2, tp, errev, dcpabs
logical, intent(out) :: conv
logical :: b, bool
!
conv = .false.
b = .false.
sr = zr
si = zi
n = nn - 1
!
!     Main loop for stage 3.
!
do 60 i = 1,l3
!
!     Evaluate P at S and test for convergence.
!
   call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
   mp = dcpabs(pvr,pvi)
   ms = dcpabs(sr,si)
   if (mp .gt. 20.d0*errev(nn,qpr,qpi,ms,mp,are,mre)) &
&go to 10
!
!     Polynomial value is smaller than a bound on the error
!     in evaluating P. terminate the iteration.
!
      conv = .true.
      zr = sr
      zi = si
      return
!
10 if (i .eq. 1) go to 40
   if (b .or. mp .lt. omp .or. relstp .ge. 0.05d0) &
&go to 30
!
!     Iteration has stalled. Probably a cluster of zeros. Do 5 fixed
!     shift steps into the cluster to force one zero to dominate.
!
   tp = relstp
   b = .true.
   if (relstp .lt. eta) tp = eta
   r1 = dsqrt(tp)
   r2 = sr*(1.d0 + r1) - si*r1
   si = sr*r1 + si*(1.d0 + r1)
   sr = r2
   call polyev(nn,sr,si,pr,pi,qpr,qpi,pvr,pvi)
   do 20 j = 1,5
      call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
      call nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
20 continue
   omp = infin
   go to 50
!
!     Exit if the polynomial value increases significantly.
!
30 if (0.1d0*mp .gt. omp) return
!
!     Calculate the next iterate.
!
40 omp = mp
!
50 call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
   call nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
   call calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
   if (bool) go to 60
   relstp = dcpabs(tr,ti)/dcpabs(sr,si)
   sr = sr + tr
   si = si + ti
60 continue
return
end subroutine vrshft

