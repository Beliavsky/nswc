subroutine cbssli(z, cnu, w)
!! <!-- nswc-ford:begin CBSSLI -->
!! Reference for `cbssli`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculation of the modified Bessel function of the
!!      first kind for complex order cnu and complex argument
!!      z.  it is assumed that -Pi .LT. arg z .LE. pi.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: z, cnu
complex, intent(inout) :: w
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin BSSLI -->
!! Reference for `bssli`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for modified Bessel function of integral order
!!
!!      mo = Mode of operation
!!      a  = ARGUMENT (COMPLEX NUMBER)
!!      in = order (integer)
!!      w  = Function of first kind (complex number)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: in, mo
complex, intent(in) :: a
complex, intent(inout) :: w
!     beginning of local variable declarations
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
if ((az(1)) < 0) go to 002
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
007 if ((zs - 1.0) < 0) go to 009
go to 008
008 if ((- abs(az(1)) + 0.096 * az(2) * az(2)) < 0) &
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
if ((qz(2)) < 0) go to 020
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
if ((qz(2)) < 0) go to 032
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
!! <!-- nswc-ford:begin BESI -->
!! Reference for `besi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Written by D. E. Amos and S. L. Daniel, January,1975.
!!      Reference
!!          sand-75-0152
!!          CDC 6600 subroutines ibess and JBESS for Bessel functions
!!          i(NU,x) AND J(NU,x), x.GE.0, NU.GE.0  BY D.E. AMOS, S.L.
!!          Daniel, M.K. Weston. ACM trans math software,3,PP 76-92
!!          (1977)
!!          Tables of Bessel functions of moderate or large orders,
!!          npl mathematical tables, vol. 6, by F.W.J. Olver, her
!!          majesty-S stationery office, london, 1962.
!!      Abstract
!!          besi computes an n member sequence of i Bessel functions
!!          i/sub(alpha+k-1)/(x), k=1,...,n or scaled Bessel functions
!!          exp(-x)*i/sub(alpha+k-1)/(x), k=1,...,n for non-negative alpha
!!          and x. a combination of the power series, the asymptotic
!!          expansion for x to infinity, and the uniform asymptotic
!!          expansion for nu to infinity are applied over subdivisions of
!!          the (NU,x) plane. For values not covered by one of these
!!          formulae, the order is incremented by an integer so that one
!!          of these formulae apply. Backward recursion is used to reduce
!!          orders by integer values. The asymptotic expansion for x to
!!          infinity is used only when the entire sequence (specifically
!!          the last member) lies within the region covered by the
!!          expansion. Leading terms of these expansions are used to test
!!          for over or underflow where appropriate. If a sequence is
!!          requested and the last member would underflow, the result is
!!          set to zero and the next lower order tried, etc., until A
!!          member comes on scale or all are set to zero. An overflow
!!          cannot occur with scaling.
!!          besi calls asik, gamln, spmpar, and ipmpar
!!      description of arguments
!!          input
!!            x      - x.GE.0.0E0
!!            alpha  - Order of first member of the sequence,
!!                     alpha.GE.0.0E0
!!            kode   - A parameter to indicate the scaling option
!!                     kode=1 returns
!!                            y(k)=        i/sub(alpha+k-1)/(x),
!!                                 k=1,...,n
!!                     kode=2 returns
!!                            y(k)=exp(-x)*i/sub(alpha+k-1)/(x),
!!                                 k=1,...,n
!!            n      - Number of members in the sequence, n.GE.1
!!          output
!!            y      - A vector whose first n components contain
!!                     values for i/sub(alpha+k-1)/(x) or scaled
!!                     values for exp(-x)*i/sub(alpha+k-1)/(x),
!!                     k=1,...,n DEPENDING ON kode
!!            nz     - Error indicator
!!                     nz= 0     Normal return-computation completed
!!                     nz=-1     x is less than 0.0
!!                     nz=-2     alpha is less than 0.0
!!                     nz=-3     n is less than 1
!!                     nz=-4     kode IS NOT 1 OR 2
!!                     nz=-5     x is too large for kode=1
!!                     nz.GT.0   last nz components of y set to 0.0
!!                               because of underflow
!!      error conditions
!!          improper input arguments - A fatal error
!!          overflow with kode=1 - A fatal error
!!          UNDERFLOW - A NON-FATAL ERROR(nz.GT.0)
!!
!!      ipmpar(8) replaces ipmpar(5) in a double precision code
!!      ipmpar(9) replaces ipmpar(6) in a double precision code
!!      definition of the tolerances TOL and elim
!! ```
!! <!-- nswc-ford:end -->
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
!     beginning of local variable declarations
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
if (nswc_ai_i4 < 0) go to 590
if (nswc_ai_i4 == 0) go to 10
go to 20
10 kt = 2
20 nn = n
if (kode < 1 .or. kode > 2) go to 570
nswc_ai_r4 = x
if (nswc_ai_r4 < 0) go to 600
if (nswc_ai_r4 == 0) go to 30
go to 80
30 nswc_ai_r4 = alpha
if (nswc_ai_r4 < 0) go to 580
if (nswc_ai_r4 == 0) go to 40
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
   if (abs(t) < tol) exit
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
if (nswc_ai_i4 < 0) go to 340
if (nswc_ai_i4 == 0) go to 290
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
if (nswc_ai_i4 < 0) go to 340
if (nswc_ai_i4 == 0) go to 310
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
   if (abs(t) <= atol) exit
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
!! <!-- nswc-ford:begin ASIK -->
!! Reference for `asik`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                   asik computes Bessel functions I and k
!!                   for arguments x.GT.0.0 and orders fnu.GE.35
!!                   ON flgik = 1 AND flgik = -1 RESPECTIVELY.
!!                                     Input
!!       x    - ARGUMENT, x.GT.0.0E0
!!       fnu  - Order of first Bessel function
!!       kode - A parameter to indicate the scaling option
!!              kode=1 RETURNS y(I)=        I/SUB(fnu+I-1)/(x), I=1,IN
!!                     OR      y(I)=        k/SUB(fnu+I-1)/(x), I=1,IN
!!                     ON flgik = 1.0E0 OR flgik = -1.0E0
!!              kode=2 RETURNS y(I)=exp(-x)*I/SUB(fnu+I-1)/(x), I=1,IN
!!                     OR      y(I)=exp( x)*k/SUB(fnu+I-1)/(x), I=1,IN
!!                     ON flgik = 1.0E0 OR flgik = -1.0E0
!!      flgik - Selection parameter for I or k function
!!              flgik =  1.0E0 gives the I function
!!              flgik = -1.0E0 gives the k function
!!         ra - sqrt(1.+z*z), z=x/fnu
!!        arg - Argument of the leading exponential
!!         in - Number of functions desired, in=1 Or 2
!!        tol - Tolerance specified by besi or BESK
!!                                     output
!!          y - A vector whose first in components contain the sequence
!!                                  written by
!!                                  D. E. Amos
!!      abstract
!!          asik implements the uniform asymptotic expansion of
!!          the I and k Bessel functions for fnu.GE.35 and real
!!          x.GT.0.0E0. The forms are identical except for a change
!!          in sign of some of the terms. This change in sign is
!!          accomplished by means of the flag flgik = 1 Or -1.
!! ```
!! <!-- nswc-ford:end -->
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
!     beginning of local variable declarations
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
      if (max(abs(ak) , abs(ap)) < tol) exit
   end do
   t = abs(t)
   y(jn) = s2*coef*sqrt(t)*con(kk)
end do
end subroutine asik

subroutine cbesk(z, cnu, w)
!! <!-- nswc-ford:begin CBESK -->
!! Reference for `cbesk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Calculation of the modified Bessel function of the
!!         second kind for complex order cnu and complex argument
!!         z.  it is assumed that -Pi .LT. arg z .LE. pi.
!!
!!      Written by
!!         Alfred H. Morris, Jr. and Andrew H. van Tuyl
!!         Naval Surface Warfare Center
!!         oct 1992
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex :: z
complex, intent(in) :: cnu
complex, intent(inout) :: w
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CBKI -->
!! Reference for `cbki`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculation of the modified Bessel function of the
!!      second kind with complex order and argument in terms
!!      of the modified Bessel function of the first kind.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: z, cnu
complex, intent(inout) :: w
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CBKA -->
!! Reference for `cbka`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Computation of the Bessel function K for complex order
!!         cnu and complex argument z by the asymptotic expansion
!!
!!      c = pi**(1/2)
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1.0 + eps .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex :: z
complex, intent(in) :: cnu
complex, intent(inout) :: w
!     beginning of local variable declarations
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
   if (anorm(t) <= eps * anorm(p)) exit
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
!! <!-- nswc-ford:begin CBKM -->
!! Reference for `cbkm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculation of the modified Bessel function of the second
!!      kind with complex order and argument BY means of Maclaurin
!!      expansions and the Miller algorithm. It is assumed that
!!      rz = abs(z).
!!
!!      cpi = sqrt(pi/2)
!!
!!         Reduction of cnu to r = nu + b*i where
!!                 -0.5 .LT. nu .LE. 0.5
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: rz
complex, intent(in) :: z, cnu
complex, intent(inout) :: w
!     beginning of local variable declarations
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
zr = cmplx(zr1, zr2)
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
w1 = cmplx(aimag(z), -real(z))
call cbsslj(w1, r, w2)
w2 = cmplx(pi*aimag(w2), -pi*real(w2))
w = ex*(ex*w + w2)
return
100 ex = conjg(ex)/c
w1 = cmplx(-aimag(z), real(z))
call cbsslj(w1, r, w2)
w2 = cmplx(-pi*aimag(w2), pi*real(w2))
w = ex*(ex*w + w2)
end subroutine cbkm

subroutine ckps(z, r, zr, nu, w1, w2)
!! <!-- nswc-ford:begin CKPS -->
!! Reference for `ckps`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Calculation of the modified Bessel functions
!!                   w1 = k  (z)  AND  w2 = k    (z)
!!                         nu                nu+1
!!      for a complex argument z where abs(z) .LE. 2 and a complex
!!      order nu where abs(real(nu)) .LE. 0.5.  It is assumed that
!!      -pi .LT. arg z .LE. pi, r = abs(z/2), and zr = 2/z.  power
!!      series expansions are used.
!!
!!      ****** eps is a machine dependent constant.  Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex :: nu
complex, intent(inout) :: w1, w2
!     beginning of local variable declarations
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
50 t = cmplx(-y, x)
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
   if (anorm(t1) <= eps0 * anorm(w1)) exit
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
!! <!-- nswc-ford:begin CBKML -->
!! Reference for `cbkml`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Computation of the scaled Bessel function
!!                    w = (exp(z)*sqrt(z)) k  (z)
!!                                          nu
!!      and the value
!!                    w0 = k    (z) /k  (z)
!!                          nu+1      nu
!!      for complex orders nu and nu + 1 and for complex argument z
!!      by use of the Miller algorithm. For the greatest accuracy,
!!      z should lie in a sector slightly larger than the right half
!!      plane. It is assumed that abs(real(nu)) .LT. 0.5, and that
!!      r = abs(z/2) AND zr = 2/z.
!!
!!      c1 = sqrt(pi/2)
!!      c2 = sqrt(pi)
!!
!!      ****** eps is a machine dependent constant.  Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: r
complex, intent(in) :: z, zr, nu
complex, intent(inout) :: w, w0
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CBSSLK -->
!! Reference for `cbsslk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          Calculation of the modified Bessel function of the
!!          second kind for real order r and complex argument z.
!!          It is assumed that -pi .LT. arg z .LE. pi.
!!
!!      Written by
!!          Andrew H. van Tuyl
!!          Naval Surface Warfare Center
!!      modified by A.H. Morris (NSWC)
!!      revised ... oct 1992
!!
!!      cpi = sqrt(pi/2)
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: r
complex :: z
complex, intent(inout) :: w
!     beginning of local variable declarations
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
zr = cmplx(zr1, zr2)
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
cn = cmplx(a, 0.0)
if (y < 0.0) go to 100
w1 = cmplx(aimag(z), -real(z))
call cbsslj(w1, cn, w2)
w2 = cmplx(pi*aimag(w2), -pi*real(w2))
w = ex*(ex*w + w2)
return
100 ex = conjg(ex)
w1 = cmplx(-aimag(z), real(z))
call cbsslj(w1, cn, w2)
w2 = cmplx(-pi*aimag(w2), pi*real(w2))
w = ex*(ex*w + w2)
end subroutine cbsslk

subroutine cka(z, nu, w)
!! <!-- nswc-ford:begin CKA -->
!! Reference for `cka`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Computation of the Bessel function K for real order nu
!!         and complex argument z by the asymptotic expansion
!!
!!      c = pi**(1/2)
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1.0 + eps .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex :: z
complex, intent(inout) :: w
real, intent(in) :: nu
!     beginning of local variable declarations
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
   if (anorm(t) <= eps * anorm(p)) exit
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
!! <!-- nswc-ford:begin CKM -->
!! Reference for `ckm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Calculation of the modified Bessel functions
!!                   w1 = k  (z)  AND  w2 = k    (z)
!!                         nu                nu+1
!!      for a complex argument z where abs(z) .LE. 2  and a real
!!      order nu where abs(nu) .LE. 0.5.  It is assumed that
!!      -pi .LT. arg z .LE. pi, r = abs(z/2), and zr = 2/z. power
!!      series expansions are used.
!!
!!      ****** eps is a machine dependent constant.  Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex, intent(inout) :: w1, w2
real, intent(in) :: nu
!     beginning of local variable declarations
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
50 w = cmplx(-y, x)
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
   if (anorm(t1) <= eps0 * anorm(w1)) exit
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
!! <!-- nswc-ford:begin CKML -->
!! Reference for `ckml`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Computation of the scaled Bessel functions
!!                    k1 = (exp(z)*sqrt(z)) k  (z)
!!                                           nu
!!                    k2 = (exp(z)*sqrt(z)) k    (z)
!!                                           nu+1
!!      for real orders nu and nu + 1 and for complex argument z
!!      by use of the Miller algorithm. For the greatest accuracy,
!!      z should lie in a sector slightly larger than the right
!!      half plane. It is assumed that abs(nu) .LT. 0.5, and that
!!      r = abs(z/2) AND zr = 2/z.
!!
!!      c1 = sqrt(pi/2)
!!
!!      ****** eps is a machine dependent constant.  Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: r
complex, intent(in) :: z, zr
complex, intent(inout) :: k1, k2
real, intent(in) :: nu
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CXP -->
!! Reference for `cxp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Computation of exp(-R*(pi/2)*I)
!!               where R = n + nu for abs(nu) .LE. 0.5
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: nu
!     beginning of local variable declarations
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
10 cxp = cmplx(c, -s)
return
20 cxp = cmplx(-s, -c)
return
30 cxp = cmplx(-c, s)
return
40 cxp = cmplx(s, c)
end function cxp

pure elemental subroutine bsslk(mo, a, in, w)
!! <!-- nswc-ford:begin BSSLK -->
!! Reference for `bsslk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for modified Bessel function of integral order
!!
!!      mo = Mode of operation
!!      a  = ARGUMENT (COMPLEX NUMBER)
!!      in = order (integer)
!!      w  = Function of second kind (complex number)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: in, mo
complex, intent(in) :: a
complex, intent(inout) :: w
!     beginning of local variable declarations
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
002 if ((zs - 1.0) <= 0) go to 020
go to 003
003 if ((zs - 289.0) < 0) go to 004
go to 010
004 if ((az(1) + 0.096 * az(2) * az(2)) <= 0) go to 020
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
103 select case (la)
case (11)
   go to 11
case (13)
   go to 13
case (14)
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
select case (lr)
case (16)
   go to 16
case (18)
   go to 18
case (19)
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
select case (lk)
case (22)
   go to 22
case (24)
   go to 24
case (25)
   go to 25
end select
end subroutine bsslk

subroutine cai(ind,z,ai,aip,ierr)
!! <!-- nswc-ford:begin CAI -->
!! Reference for `cai`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Airy function ai and its derivative aip
!!      for complex argument z.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: ai
complex, intent(inout) :: aip
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin AIRM -->
!! Reference for `airm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Airy functions ai and bi and their
!!      derivatives aip and bip by use of their Maclaurin
!!      expansions.
!!
!!      c1 = 3**(-2/3)/gamma(2/3)
!!      c2 = 3**(-1/3)/gamma(1/3)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ind
complex, intent(inout) :: ai, aip, bi, bip
complex, intent(in) :: z
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin AII -->
!! Reference for `aii`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Airy function ai and its derivative aip
!!      for complex argument z in the intermediate range 1 .LE.
!!      CABS(z) .LE. 10.0.
!!
!!      c1 = 1/(pi*sqrt(3))
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: ai, aip
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin AIA -->
!! Reference for `aia`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Airy function ai and its derivative aip for
!!      complex argument z by means of asymptotic expansions.
!!
!!      c1 = pi**(-1/2)
!!      c2 = (2*pi)**(-1/2)
!!
!!      Eps, xpos, and xneg are machine dependent constants. Eps is
!!      the smallest number such that 1.0 + eps .GT. 1.0, xpos is the
!!      the largest postive number for which exp(X) can be computed,
!!      and xneg is the largest negative number for which exp(X) does
!!      not underflow.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(inout) :: ai, aip
complex, intent(in) :: z
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin CBI -->
!! Reference for `cbi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Airy function bi and its derivative bip
!!      for complex argument z.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: bi
complex, intent(inout) :: bip
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin BII -->
!! Reference for `bii`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Airy function bi and its derivative bip
!!      for complex argument z in the intermediate range 1 .LE.
!!      CABS(z) .LE. 10.0.
!!
!!      c1 = 1/sqrt(3)
!!      sqt3 = sqrt(3)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: bi, bip
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin BIA -->
!! Reference for `bia`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Airy function bi and its derivative bip for
!!      complex argument z by means of asymptotic expansions.
!!
!!      sqt3 = sqrt(3)
!!      ex3c = exp(-i*pi/3)
!!      ex6 = exp(i*pi/6)
!!      ex6c = exp(-i*pi/6)
!!      cln2 = 0.5*i*ln(2)
!!      c1 = pi**(-1/2)
!!      c2 = (2*pi)**(-1/2)
!!      c3 = 2**(-1/2)
!!
!!      Eps and XM are machine dependent constants. Eps is the
!!      smallest number such that 1.0 + eps .GT. 1.0, xpos is the
!!      largest positive number for which exp(XM) can be computed,
!!      and XNEG is the negative number of largest magnitude for
!!      which exp(X) does not underflow.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: bi, bip
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin IA -->
!! Reference for `ia`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the modified Bessel function of the first
!!      kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!!      argument z, where -Pi .LT. arg(z) .LE. pi.  i1 and i2
!!      are replaced by the functions of orders 1/3 and 2/3,
!!      respectively, and i1m and i2m by the functions of orders
!!      -1/3 and -2/3, respectively.
!!
!!      ex13 = exp(i*pi/3)
!!      ex13c = exp(-i*pi/3)
!!      ex23 = exp(2*i*pi/3)
!!      ex23c = exp(-2*i*pi/3)
!! ```
!! <!-- nswc-ford:end -->
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
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin IMC -->
!! Reference for `imc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the modified Bessel function of the first
!!      kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!!      argument z. the Maclaurin expansion and backward recurrence
!!      are used. i1 and i2 are replaced by the functions of orders
!!      1/3 and 2/3, respectively, and i1m and i2m by the functions
!!      of orders -1/3 and -2/3, respectively.  For greatest
!!      accuracy, z should lie in the region real(z) .GE. 0.
!!
!!      gm1 = gamma(4.0/3.0)
!!      gm2 = gamma(5.0/3.0)
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin BIM -->
!! Reference for `bim`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the modified Bessel function of the first kind
!!      for real order cn .GT. -1 And complex argument z by means
!!      of the Maclaurin expansion.  w is replaced by the
!!      calculated value.
!!
!!      Eps is a machine dependent constant.  Eps is the smallest
!!      number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: cn
complex :: z
complex, intent(inout) :: w
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin JA -->
!! Reference for `ja`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Bessel function of the first kind for
!!      orders 1/3, 2/3, -1/3, and -2/3 and for complex argument
!!      z, where -Pi .LT. arg(z) .LE. pi.  i1 and i2 are replaced
!!      by the functions of orders 1/3 and 2/3, respectively, and
!!      i1m and i2m by functions of orders -1/3 and -2/3,
!!      respectively.
!!
!!      ex13 = exp(i*pi/3)
!!      ex13c = exp(-i*pi/3)
!!      ex23 = exp(2*i*pi/3)
!!      ex23c = exp(-2*i*pi/3)
!! ```
!! <!-- nswc-ford:end -->
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
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin JMC -->
!! Reference for `jmc`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Bessel function of the first
!!      kind for orders 1/3, 2/3, -1/3, and -2/3 and for complex
!!      argument z. the Maclaurin expansion and backward recurrence
!!      are used. i1 and i2 are replaced by the functions of orders
!!      1/3 and 2/3, respectively, and i1m and i2m by the functions
!!      of orders -1/3 and -2/3, respectively.  For greatest
!!      accuracy, z should lie in the region real(z) .GE. 0.
!!
!!      gm1 = gamma(4.0/3.0)
!!      gm2 = gamma(5.0/3.0)
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex :: z
complex, intent(inout) :: i1, i2, i1m, i2m
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin BJM -->
!! Reference for `bjm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the Bessel function of the first kind
!!      for real order cn .GT. -1 And complex argument z by means
!!      of the Maclaurin expansion.  w is replaced by the
!!      calculated value.
!!
!!      Eps is a machine dependent constant.  Eps is the smallest
!!      number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: cn
complex :: z
complex, intent(inout) :: w
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin KA -->
!! Reference for `ka`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the modified Bessel function of the second
!!      kind for orders 1/3 and 2/3 and for complex argument z,
!!      where -pi .LT. arg(z) .le pi.  k1 is replaced by the
!!      function of order 1/3, and k2 by the function of order
!!      2/3.
!!
!!      ex13c = exp(-pi*i/3)
!!      ex23c = exp(-2*pi*i/3)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: k1, k2
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin KML -->
!! Reference for `kml`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates the modified Bessel function of the second
!!      kind for orders 1/3 and 2/3 and for complex argument z
!!      by use of the Miller algorithm.  k1 is replaced by the
!!      function of order 1/3, and k2 by the function of order
!!      2/3.  For greatest accuracy, z should lie in the region
!!      real(z) .GE. 0.
!!
!!      c1 = sqrt(pi/2)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ind
complex, intent(in) :: z
complex, intent(inout) :: k1, k2
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin AI -->
!! Reference for `ai`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Evaluation of the Airy function ai(x)
!!
!!      x0 = 2**(2/3)
!!      c = exp(2/3)
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: x
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin AIE -->
!! Reference for `aie`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                    Scaled Airy function ai(x)
!!              aie(x) = exp(ZETA)*ai(x)  WHEN x .GE. 0
!!              aie(x) = ai(x)            WHEN x .LT. 0
!!              zeta = (2/3) * x**(3/2)
!!
!!      x0 = 2**(2/3)
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: x
!     beginning of local variable declarations
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
!! <!-- nswc-ford:begin BI -->
!! Reference for `bi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Evaluation of the Airy function bi(x)
!!      note... if x is a positive number where bi(x) is too large
!!      to be computed, then bi(x) is set to 0.
!!
!!      x0 = 16**(2/3)
!!      c = exp(2/3)
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: x
!     beginning of local variable declarations
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

pure elemental real function bie(x)
!! <!-- nswc-ford:begin BIE -->
!! Reference for `bie`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                     Scaled Airy function bi(x)
!!              bie(x) = exp(-ZETA)*bi(x)  WHEN x .GE. 0
!!              bie(x) = bi(x)             WHEN x .LT. 0
!!              zeta = (2/3) * x**(3/2)
!!
!!      x0 = 16**(2/3)
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: x
!     beginning of local variable declarations
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
!                    Scaled Airy function bi(x)
!             bie(x) = exp(-ZETA)*bi(x)  WHEN x .GE. 0
!             bie(x) = bi(x)             WHEN x .LT. 0
!             zeta = (2/3) * x**(3/2)
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
10 if (x >= 0.0) go to 20
bie = ((((((((((an10*x + an9)*x + an8)*x + an7)*x &
   & + an6)*x + an5)*x + an4)*x + an3)*x &
   & + an2)*x + an1)*x + an0) / &
   & (((ad3*x + ad2)*x + ad1)*x + ad0)
return
20 if (x > 1.0) go to 30
bie = ((((((((((bn10*x + bn9)*x + bn8)*x + bn7)*x &
   & + bn6)*x + bn5)*x + bn4)*x + bn3)*x &
   & + bn2)*x + bn1)*x + bn0) / &
   & (((bd3*x + bd2)*x + bd1)*x + bd0)
if (x > 1.e-20) bie = bie * exp(-2.0*x*sqrt(x)/3.0)
return
30 rtx = sqrt(x)
if (x > 2.0) go to 40
t = x - 1.0
w = ((((((pn6*t + pn5)*t + pn4)*t + pn3)*t + pn2)*t &
   & + pn1)*t + pn0) / &
   & (((((((pd7*t + pd6)*t + pd5)*t + pd4)*t + pd3)*t &
   & + pd2)*t + pd1)*t + pd0)
bie = w/sqrt(rtx)
return
40 if (x > 4.0) go to 50
t = x - 2.0
w = (((((((qn7*t + qn6)*t + qn5)*t + qn4)*t + qn3)*t &
   & + qn2)*t + qn1)*t + qn0) / &
   & ((((((((qd8*t + qd7)*t + qd6)*t + qd5)*t + qd4)*t &
   & + qd3)*t + qd2)*t + qd1)*t + qd0)
bie = w/sqrt(rtx)
return
50 if (x > x0) go to 60
t = 16.0/(x*rtx) - 1.0
w = (((((((((((rn11*t + rn10)*t + rn9)*t + rn8)*t &
   & + rn7)*t + rn6)*t + rn5)*t + rn4)*t + rn3)*t &
   & + rn2)*t + rn1)*t + rn0) / &
   & ((rd2*t + rd1)*t + rd0)
bie = w/sqrt(rtx)
return
60 if (x > 1.e20) go to 70
t = 16.0/(x*rtx)
w = (((((((((((((sn13*t + sn12)*t + sn11)*t + sn10)*t &
   & + sn9)*t + sn8)*t + sn7)*t + sn6)*t + sn5)*t &
   & + sn4)*t + sn3)*t + sn2)*t + sn1)*t + sn0) / &
   & (sd1*t + sd0)
bie = w/sqrt(rtx)
return
70 bie = sn0/sqrt(rtx)
end function bie

pure elemental subroutine aimp(x, r, phi)
!! <!-- nswc-ford:begin AIMP -->
!! Reference for `aimp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Computation of the Airy modulus and phase for x .GE. 1
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(inout) :: phi, r
real, intent(in) :: x
!     beginning of local variable declarations
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
10 if (x >= 4.0) go to 20
z = x - 2.0
r = (((((cn5*z + cn4)*z + cn3)*z + cn2)*z + cn1)*z + cn0) / &
   & ((((((cd6*z + cd5)*z + cd4)*z + cd3)*z + cd2)*z &
   & + cd1)*z + cd0)
phi = (((((dn5*z + dn4)*z + dn3)*z + dn2)*z + dn1)*z + dn0) / &
   & ((((((dd6*z + dd5)*z + dd4)*z + dd3)*z + dd2)*z &
   & + dd1)*z + dd0)
go to 40
20 if (x > 1.e10) go to 30
z = 64.0/x**3
r = (((((pn5*z + pn4)*z + pn3)*z + pn2)*z + pn1)*z + pn0) / &
   & (((((pd5*z + pd4)*z + pd3)*z + pd2)*z + pd1)*z + pd0)
phi = ((((qn4*z + qn3)*z + qn2)*z + qn1)*z + qn0) / &
   & (((((qd5*z + qd4)*z + qd3)*z + qd2)*z + qd1)*z + qd0)
go to 40
30 r = pn0
phi = qn0
40 rtx = sqrt(x)
r = sqrt(r/rtx)
phi = pi4 + x*rtx*phi
end subroutine aimp

pure complex function ck(k,l)
!! <!-- nswc-ford:begin CK -->
!! Reference for `ck`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This function calculates the complete elliptic integral F(k)
!!      for complex values of the modulus k. it is assumed that l.NE.0
!!      and that k**2 + l**2 = 1.
!!
!!      Eps is a machine dependent constant.  Eps is the
!!      smallest number such that 1. + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: k, l
!     beginning of local variable declarations
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
!     Eps is a machine dependent constant.  Eps is the
!     smallest number such that 1. + eps .GT. 1.
eps = spmpar(1)
!     ---------------------------------------------------
if (l == (0.0, 0.0)) go to 200
ind = 0
branch = .true.
tol = 8.0*max(eps, 1.e-14)
ak1 = cflect(k)
al1 = cflect(l)
ak = ak1
al = al1
x = real(ak)
y = aimag(ak)
u = real(al)
v = aimag(al)
if (max(x,abs(y)) >= 1.0/eps) go to 90
if (max(u,abs(v)) >= 1.1/eps) go to 200
!     Check that k**2 + l**2 = 1
if (x < u) go to 1
t = u/x
if (abs(x*x/(v*v + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 200
if (abs(y + t*v) > tol*max(1.0, abs(v))) go to 200
go to 10
1 t = x/u
if (abs(u*u/(y*y + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 200
if (abs(v + t*y) > tol*max(1.0, abs(y))) go to 200
!     Uses  logarithmic series when cabs(al)
!     is less than or equal to 0.55
10 if (u > 1.42 .or. abs(v) > 1.42) go to 50
11 if (abs(al) > 0.55) go to 20
call kl(al,ckk,ckp)
if (branch) go to 22
ck1 = ckk
ck = ckp
al = ak
go to 80
!     Uses Maclaurin expansion when the absolute value of
!     the modulus ak is less than or equal to 0.55
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
!     Numerical quadrature approximation
30 if (ind == 0 .and. r > 1.0) go to 50
31 al2 = al*al
f1 = (0.0, 0.0)
do i = 1,12
   xx = x1(i)/2.
   fxk = ak*xx
   f1 = f1 + w1(i)*fl(i)/(al2 + fxk*fxk)
end do
f2 = (0.0, 0.0)
do i = 1,12
   xx = .25*(1. + x2(i))
   fxk = ak*xx
   f2 = f2 + w2(i)*fa(i)/(al2 + fxk*fxk)
end do
f3 = (0.0, 0.0)
do i = 1,12
   xx = .25*(3. - x2(i))
   fxk = ak*xx
   f3 = f3 + w2(i)*fb(i)/(al2 + fxk*fxk)
end do
ck = al*(c1*f1 + c2*(f2 + f3))
!     END OF NUMERICAL QUADRATURE APPROXIMATION
if (branch) go to 70
ck1 = ck
branch = .true.
!     Interchange ak and al
aktemp = ak
ak = al
al = aktemp
go to 31
!     Uses inverse modulus transformation when cabs(ak) is greater
!     than 1 and real(ak**2) is greater than 0.5.
50 if (x*x <= y*y + 0.5) go to 60
ind = 1
branch = .false.
ak = 1.0/ak1
al = cflect(j*al1/ak1)
go to 11
!     Uses complementary inverse modulus transformation when cabs(ak)
!     is greater than 1 and real(ak**2) is less than or equal to 0.5
60 ind = 2
ak = cflect(j*ak1/al1)
al = 1.0/al1
go to 11
!     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
70 if (ind == 0) return
if (ind == 1) go to 80
!     Complementary inverse modulus transformation
ck = al*ck
return
!     Inverse modulus transformation
80 if (aimag(ak1) >= 0.0) go to 81
ck = al*(ck1 - j*ck)
return
81 ck = al*(ck1 + j*ck)
return
!     Calculation of F(k) for large k and l
90 if (x <= abs(y)) go to 100
if (abs(abs(v/x) - 1.0) > tol) go to 200
if (abs(u/x + y/v) > tol) go to 200
t = y/x
phi = atan2(x,abs(y))
r = (ln4 + 0.5*alnrel(t*t)) + log(x)
if (y < 0.0) r = -r
ck = (cmplx(phi,r)/cmplx(1.0,t))/x
return
100 if (abs(abs(u/y) - 1.0) > tol) go to 200
if (abs(x/u + v/y) > tol) go to 200
t = v/u
z = cmplx((ln4 + 0.5*alnrel(t*t)) + log(u), atan2(v,u))
ck = (z/cmplx(1.0,t))/u
return
!     Error return
200 ck = (0.0, 0.0)
end function ck

pure elemental complex function cflect(z)
!! <!-- nswc-ford:begin CFLECT -->
!! Reference for `cflect`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Reflects z with respect to the origin if real(z)
!!      .LT. 0.0 or if z is on the negative imaginary axis.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!---------------------------------------------------------
!     Reflects z with respect to the origin if real(z)
!     .LT. 0.0 or if z is on the negative imaginary axis.
!---------------------------------------------------------
complex, intent(in) :: z
!     beginning of local variable declarations
real :: nswc_ai_r4
!     ----------
nswc_ai_r4 = real(z)
if (nswc_ai_r4 < 0) then
   cflect = -z
else if (nswc_ai_r4 == 0) then
   cflect = cmplx(0.0, abs(aimag(z)))
else
   cflect = z
end if
end function cflect

pure complex function km(k2)
!! <!-- nswc-ford:begin KM -->
!! Reference for `km`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      km computes the complete elliptic integral F(K) for a given
!!      value of k2 = K**2 by use of the Maclaurin expansion.
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: k2
!     beginning of local variable declarations
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
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
! ---------------
tol = max(eps,1.e-14)
s1 = (1.0, 0.0)
an = (1.0, 0.0)
do i = 1,50
   ri = i
   c = ((ri - 0.5)/ri)**2
   an = c*(an*k2)
   s1 = s1 + an
   if (abs(real(an)) + abs(aimag(an)) < tol) exit
end do
km = hpi*s1
end function km

pure subroutine kl(l, fk, fl)
!! <!-- nswc-ford:begin KL -->
!! Reference for `kl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      kl computes the complete elliptic integrals F(K) and F(l) for
!!      a given value of l, where cabs(l) .LT. 1 and K**2 + l**2 = 1.
!!      It is assumed that -Pi .LE. arg(l**2) .LT. pi for the resulting
!!      value for F(K) to be meaningful.
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: l
complex, intent(inout) :: fk, fl
!     beginning of local variable declarations
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
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
! ---------------
!            The logarithmic expansion is used for F(K)
!              and the Maclaurin expansion for F(l)
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
   if (abs(real(an)) + abs(aimag(an)) < tol) exit
end do
s1 = s1 + (1.0, 0.0)
!                   SET w = 0.5*CLOG(16.0/l2)
x = real(l)
y = aimag(l)
if (x /= 0.0) go to 30
w = cmplx(ln4 - log(abs(y)), hpi)
go to 50
30 if (abs(x) > abs(y)) go to 31
u = (ln4 - 0.5*alnrel((x/y)**2)) - log(abs(y))
go to 40
31 u = (ln4 - 0.5*alnrel((y/x)**2)) - log(abs(x))
40 if (x > 0.0) go to 41
w = cmplx(u, -atan2(-y,-x))
go to 50
41 w = cmplx(u, -atan2(y,x))
!                        Final assembly
50 fk = w*s1 - s2
fl = hpi*s1
end subroutine kl

pure elemental subroutine cke(k,l,ck,ce,ierr)
!! <!-- nswc-ford:begin CKE -->
!! Reference for `cke`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This function calculates the complete elliptic integrals F(k)
!!      and E(k) for complex values of the modulus k. it is assumed
!!      that l.NE.0 and that k**2 + l**2 = 1.
!!
!!      Eps is a machine dependent constant.  Eps is the
!!      smallest number such that 1. + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
complex, intent(in) :: k, l
complex, intent(inout) :: ce, ck
!     beginning of local variable declarations
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
!     Eps is a machine dependent constant.  Eps is the
!     smallest number such that 1. + eps .GT. 1.
eps = spmpar(1)
!     ---------------------------------------------------
if (l == (0.0, 0.0)) go to 200
ind = 0
branch = .true.
tol = 8.0*max(eps, 1.e-14)
ak1 = cflect(k)
al1 = cflect(l)
ak = ak1
al = al1
ierr = 0
x = real(ak)
y = aimag(ak)
u = real(al)
v = aimag(al)
if (max(x,abs(y)) >= 1.0/eps) go to 90
if (max(u,abs(v)) >= 1.1/eps) go to 210
!     Check that k**2 + l**2 = 1
if (x < u) go to 1
t = u/x
if (abs(x*x/(v*v + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 210
if (abs(y + t*v) > tol*max(1.0, abs(v))) go to 210
go to 10
1 t = x/u
if (abs(u*u/(y*y + 1.0/(1.0 + t*t)) - 1.0) > tol) go to 210
if (abs(v + t*y) > tol*max(1.0, abs(y))) go to 210
!     Uses  logarithmic series when cabs(al)
!     is less than or equal to 0.55
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
!     Uses Maclaurin expansion when the absolute value of
!     the modulus ak is less than or equal to 0.55
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
!     Numerical quadrature approximation
30 if (ind == 0 .and. r > 1.0) go to 50
31 al2 = al*al
ak2 = ak*ak
f1 = (0.0, 0.0)
e1 = (0.0, 0.0)
do i = 1,12
   xx = x1(i)/2.
   fx = ak*xx/al
   fxk = ak*xx
   at = atn(fx)
   e1 = e1 + w1(i)*fl(i)*(1.0 + at)
   f1 = f1 + w1(i)*fl(i)/(al2 + fxk*fxk)
end do
f2 = (0.0, 0.0)
e2 = (0.0, 0.0)
do i = 1,12
   xx = .25*(1. + x2(i))
   fx = ak*xx/al
   fxk = ak*xx
   at = atn(fx)
   e2 = e2 + w2(i)*fa(i)*(1.0 + at)
   f2 = f2 + w2(i)*fa(i)/(al2 + fxk*fxk)
end do
f3 = (0.0, 0.0)
e3 = (0.0, 0.0)
do i = 1,12
   xx = .25*(3. - x2(i))
   fx = ak*xx/al
   fxk = ak*xx
   at = atn(fx)
   e3 = e3 + w2(i)*fb(i)*(1.0 + at)
   f3 = f3 + w2(i)*fb(i)/(al2 + fxk*fxk)
end do
ck = al*(c1*f1 + c2*(f2 + f3))
ce = al*(c1*e1 + c2*(e2 + e3))
!     END OF NUMERICAL QUADRATURE APPROXIMATION
if (branch) go to 70
ck1 = ck
ce1 = ce
branch = .true.
!     Interchange ak and al
aktemp = ak
ak = al
al = aktemp
go to 31
!     Uses inverse modulus transformation when cabs(ak) is greater
!     than 1 and real(ak**2) is greater than 0.5.
50 if (x*x <= y*y + 0.5) go to 60
ind = 1
branch = .false.
ak = 1.0/ak1
al = cflect(j*al1/ak1)
go to 11
!     Uses complementary inverse modulus transformation when cabs(ak)
!     is greater than 1 and real(ak**2) is less than or equal to 0.5
60 ind = 2
ak = cflect(j*ak1/al1)
al = 1.0/al1
go to 11
!     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
70 if (ind == 0) return
if (ind == 1) go to 80
!     Complementary inverse modulus transformation
ck = al*ck
ce = ce/al
return
!     Inverse modulus transformation
80 g = ce - al2*ck
g1 = ce1 - ak2*ck1
81 if (aimag(ak2) >= 0.0) go to 82
ce = (g1 + j*g)/al
ck = al*(ck1 - j*ck)
return
82 ce = (g1 - j*g)/al
ck = al*(ck1 + j*ck)
return
!     Calculation of F(k) and E(k) for large k and l
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
100 if (abs(abs(u/y) - 1.0) > tol) go to 210
if (abs(x/u + v/y) > tol) go to 210
t = v/u
l1 = cmplx(1.0,t)
r = (ln4 + 0.5*alnrel(t*t)) + log(u)
phi = atan2(v,u)
ck = (cmplx(r, phi)/l1)/u
ce = al + (cmplx(0.5*r - 0.25, 0.5*phi)/l1)/u
return
!     Error return
200 ierr = 1
return
210 ierr = 2
end subroutine cke

pure elemental complex function atn(z)
!! <!-- nswc-ford:begin ATN -->
!! Reference for `atn`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates complex function atn(z) = z*atan(z)
!!      using double precision.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: z
!     beginning of local variable declarations
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
end function atn

pure elemental subroutine ekm(k2, fk, ek)
!! <!-- nswc-ford:begin EKM -->
!! Reference for `ekm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      ekm computes the complete elliptic integrals F(K) and E(K) for
!!      a given value of k2 = K**2 by use of the Maclaurin expansions.
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: k2
complex, intent(inout) :: fk, ek
!     beginning of local variable declarations
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
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
! ---------------
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
   if (abs(real(an)) + abs(aimag(an)) < tol) exit
end do
fk = hpi*s1
ek = hpi*s2
end subroutine ekm

pure elemental subroutine ekl(l,fk,fl,ek,el,gk,gl)
!! <!-- nswc-ford:begin EKL -->
!! Reference for `ekl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      ekl computes the complete elliptic integrals F(K), F(l), E(K),
!!      E(l) for a given value of l2, where l2 = l**2 and K**2 + l**2 = 1.
!!      It is assumed that -Pi .LT. arg(l2) .LE. pi for the resulting
!!      value for F(K) to be meaningful.  The combinations of functions
!!      G(K) = E(K) - l**2*F(K) and G(l) = E(l) - K**2*F(l) are also
!!      calculated.
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
complex, intent(in) :: l
complex, intent(inout) :: fk, fl, ek, el, gk, gl
!     beginning of local variable declarations
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
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
eps = spmpar(1)
! ---------------
!            The logarithmic expansions are used for F(K) and E(K)
!            and the Maclaurin expansions for F(l) and E(l)
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
   if (abs(real(an)) + abs(aimag(an)) < tol) exit
end do
s1 = s1 + (1.0, 0.0)
s3 = s3 + (1.0, 0.0)
s5 = s5 + (1.0, 0.0)
s7 = s7 + (0.5, 0.0)
!              SET w = 0.5*CLOG(16.0/l2)
x = real(l)
y = aimag(l)
if (x /= 0.0) go to 30
w = cmplx(ln4 - log(abs(y)), hpi)
go to 50
30 if (abs(x) > abs(y)) go to 31
u = (ln4 - 0.5*alnrel((x/y)**2)) - log(abs(y))
go to 40
31 u = (ln4 - 0.5*alnrel((y/x)**2)) - log(abs(x))
40 if (x > 0.0) go to 41
w = cmplx(u, -atan2(-y,-x))
go to 50
41 w = cmplx(u, -atan2(y,x))
!              Final assembly
50 fk = w*s1 - s2
fl = hpi*s1
ek = w*s6 - s4 + s5
el = hpi*s3
gk = -w*s7*l2 - s4 + s5 + s2*l2
gl = hpi*s7*l2
end subroutine ekl

pure elemental subroutine ellpi(phi, cphi, k, l, f, e, ierr)
!! <!-- nswc-ford:begin ELLPI -->
!! Reference for `ellpi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Real elliptic integrals of the first and second kinds
!!
!!      phi = argument                    (0.0 .le. phi  .le. pi/2)
!!      cphi = pi/2 - phi                 (0.0 .le. cphi .le. pi/2)
!!      k = modulus                       (abs(k) .le. 1.0)
!!      l = comodulus = sqrt (1 - k*k)    (abs(l) .le. 1.0)
!!      f = Elliptic integral of first kind = f(phi, k)
!!      e = Elliptic integral of second kind = e(phi, k)
!!      ierr = ERROR INDICATOR (ierr = 0  IF NO ERRORS)
!!
!!      ln4 = ln(4)
!!      th1 = tanh(1)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: cphi
real, intent(inout) :: e, f
real, intent(in) :: phi
real, intent(in) :: k, l
!     beginning of local variable declarations
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
!          Real elliptic integrals of the first and second kinds
!                        -----------------
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
10 if (phi < 0.79) go to 11
sn = cos(cphi)
cn = sin(cphi)
go to 20
11 sn = sin(phi)
cn = cos(phi)
20 k2 = k*k
l2 = l*l
ss = sn*sn
px = abs(k*sn)
qx = abs(k*cn)
if (px >= th1) go to 50
!     Series expansion for abs(k*sin(phi)) .LE. tanh(1)
pn = 1.0
qn = 2.0
an = phi
hn = 1.0
s1 = 0.0
s2 = 0.0
tr = phi*ss
ts = sn*cn
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
40 f = phi + s1
e = phi - s2
return
!     Series expansion for abs(k*sin(phi)) .GT. tanh(1)
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
w = 1.0 + px
p = ln4 - log(r + qx)
t1 = (1.0 + s1)*p + qx/r*alnrel(-0.5*r2/w)
t2 = (0.5 + s2)*l2*p + (1.0 - qx*r/w)
f = t1 + s3
e = t2 + s4
return
!     Error return
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine ellpi

pure elemental subroutine dellpi(phi, cphi, k, l, f, e, ierr)
!! <!-- nswc-ford:begin DELLPI -->
!! Reference for `dellpi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                   Double precision computation of the
!!           real elliptic integrals of the first and second kinds
!!
!!      phi = argument                    (0.0 .le. phi  .le. pi/2)
!!      cphi = pi/2 - phi                 (0.0 .le. cphi .le. pi/2)
!!      k = modulus                       (dabs(k) .le. 1.0)
!!      l = comodulus = sqrt (1 - k*k)    (dabs(l) .le. 1.0)
!!      f = Elliptic integral of first kind = f(phi, k)
!!      e = Elliptic integral of second kind = e(phi, k)
!!      ierr = ERROR INDICATOR (ierr = 0  IF NO ERRORS)
!!
!!      ln4 = ln(4)
!!      th1 = tanh(1)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
double precision, intent(in) :: phi, cphi, k, l
double precision, intent(inout) :: f, e
!     beginning of local variable declarations
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
!                  Double precision computation of the
!          real elliptic integrals of the first and second kinds
!                        -----------------
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
10 if (phi < 0.79d0) go to 11
sn = cos(cphi)
cn = sin(cphi)
go to 20
11 sn = sin(phi)
cn = cos(phi)
20 k2 = k*k
l2 = l*l
ss = sn*sn
px = abs(k*sn)
qx = abs(k*cn)
if (px >= th1) go to 50
!     Series expansion for abs(k*sin(phi)) .LE. tanh(1)
pn = 1.d0
qn = 2.d0
an = phi
hn = 1.d0
s1 = 0.d0
s2 = 0.d0
tr = phi*ss
ts = sn*cn
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
40 f = phi + s1
e = phi - s2
return
!     Series expansion for abs(k*sin(phi)) .GT. tanh(1)
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
w = 1.d0 + px
p = ln4 - log(r + qx)
t1 = (1.d0 + s1)*p + qx/r*dlnrel(-0.5d0*r2/w)
t2 = (0.5d0 + s2)*l2*p + (1.d0 - qx*r/w)
f = t1 + s3
e = t2 + s4
return
!     Error return
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine dellpi

pure elemental subroutine epi(phi, cphi, k2, l2, n, m, p, ierr)
!! <!-- nswc-ford:begin EPI -->
!! Reference for `epi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!              Real elliptic integral of the third kind
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1.0 + eps .GT. 1.0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: phi, cphi, k2, l2, n, m
real, intent(inout) :: p
!     beginning of local variable declarations
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
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0.
eps = spmpar(1)
!-----------------------------------------------------------------------
tol = 4.0 * eps
if (min(phi,cphi) < 0.0) go to 100
if (abs((phi + cphi) - pihalf) > tol * pihalf) go to 100
if (abs(n) > 1.0) go to 110
if (k2 < 0.0 .or. l2 < 0.0) go to 120
if (abs((k2 + l2) - 1.0) > tol) go to 120
if (phi < 0.79) go to 10
s = cos(cphi)
c = sin(cphi)
go to 11
10 s = sin(phi)
c = cos(phi)
11 a = c*c
b = l2 + k2*a
s2 = s*s
if (n > 0.0) go to 20
r = 1.0 - n*s2
go to 30
20 if (m < 0.0 .or. m > 1.0) go to 110
if (abs((m + n) - 1.0) > tol) go to 110
r = m + n*a
30 call rjval(a, b, 1.0, r, p, ierr)
if (ierr /= 0) go to 130
p = p * (s * s2) * n/3.0
call rfval(a, b, 1.0, rf, ierr)
p = p + s * rf
return
!     Error return
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine epi

pure elemental subroutine depi(phi, cphi, k2, l2, n, m, p, ierr)
!! <!-- nswc-ford:begin DEPI -->
!! Reference for `depi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                Double precision computation of the
!!              real elliptic integral of the third kind
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1.D0 + eps .GT. 1.D0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
double precision, intent(in) :: phi, cphi, k2, l2, n, m
double precision, intent(inout) :: p
!     beginning of local variable declarations
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
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.D0 + eps .GT. 1.D0.
eps = dpmpar(1)
!-----------------------------------------------------------------------
tol = 4.d0 * eps
if (min(phi,cphi) < 0.d0) go to 100
if (abs((phi + cphi) - pihalf) > tol * pihalf) go to 100
if (abs(n) > 1.d0) go to 110
if (k2 < 0.d0 .or. l2 < 0.d0) go to 120
if (abs((k2 + l2) - 1.d0) > tol) go to 120
if (phi < 0.79d0) go to 10
s = cos(cphi)
c = sin(cphi)
go to 11
10 s = sin(phi)
c = cos(phi)
11 a = c*c
b = l2 + k2*a
s2 = s*s
if (n > 0.d0) go to 20
r = 1.d0 - n*s2
go to 30
20 if (m < 0.d0 .or. m > 1.d0) go to 110
if (abs((m + n) - 1.d0) > tol) go to 110
r = m + n*a
30 call drjval(a, b, 1.d0, r, p, ierr)
if (ierr /= 0) go to 130
p = p * (s * s2) * n/3.d0
call drfval(a, b, 1.d0, rf, ierr)
p = p + s * rf
return
!     Error return
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine depi

pure elemental subroutine rfval(x, y, z, rf, ierr)
!! <!-- nswc-ford:begin RFVAL -->
!! Reference for `rfval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the incomplete elliptic integral
!!           of the first kind
!!           rf(x,y,z) = Integral from zero to infinity of
!!                                 -1/2     -1/2     -1/2
!!                       (1/2)(T+x)    (T+y)    (T+z)    DT,
!!           where x, y, and z are nonnegative and at most one of them
!!           is zero.  If one of them is zero, the integral is complete.
!!           The duplication theorem is iterated until the variables are
!!           nearly equal, and the function is then expanded in Taylor
!!           series to fifth order.  Reference. B. C. Carlson, computing
!!           elliptic integrals by duplication, numer. Math. 33 (1979),
!!           1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!!           laboratory-doe, Iowa State University, ames, iowa 50011.
!!           March 1, 1980. Modified by A.H. Morris (NSWC).
!!
!!           Input ...
!!           x, y, and z are the variables in the integral rf(x,y,z).
!!           Output ...
!!           rf is the value of the incomplete elliptic integral.
!!           ierr is the return error code.
!!                ierr = 0  For normal completion of the subroutine.
!!                ierr = 1  x, y, or z is negative.
!!                ierr = 2  x+y, x+z, or y+z is too small.
!!                ierr = 3  x, y, or z is too large.
!!
!!           Machine dependent parameters ...
!!           lolim and uplim determine the range of valid arguments.
!!           lolim is not less than the machine minimum multiplied by 5.
!!           uplim is not greater than the machine maximum divided by 5.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the incomplete elliptic integral
!          of the first kind
!          rf(x,y,z) = Integral from zero to infinity of
!                                -1/2     -1/2     -1/2
!                      (1/2)(T+x)    (T+y)    (T+z)    DT,
!          where x, y, and z are nonnegative and at most one of them
!          is zero.  If one of them is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rf
real, intent(in) :: x
real, intent(in) :: y
real, intent(in) :: z
!     beginning of local variable declarations
real :: c1, c2, c3, e2, e3, epslon, errtol, lamda, lolim, mu, s, uplim, xn, xndev, xnroot, yn, yndev, ynroot, zn, zndev, znroot
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!          Input ...
!          x, y, and z are the variables in the integral rf(x,y,z).
!          Output ...
!          rf is the value of the incomplete elliptic integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y, x+z, or y+z is too small.
!               ierr = 3  x, y, or z is too large.
!-----------------------------------------------------------------------
!          Machine dependent parameters ...
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
lolim = 5.0 * spmpar(2)
uplim = 0.2 * spmpar(3)
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          errtol ** 6 / (4 * (1 - errtol)).
errtol = (3.6 * spmpar(1))**(1.0/6.0)
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (min(x,y,z) < 0.0) go to 100
if (min(x + y,x + z,y + z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
ierr = 0
xn = x
yn = y
zn = z
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
20 c1 = 1.0 / 24.0
c2 = 3.0 / 44.0
c3 = 1.0 / 14.0
e2 = xndev * yndev - zndev * zndev
e3 = xndev * yndev * zndev
s = 1.0 + (c1 * e2 - 0.1 - c2 * e3) * e2 + c3 * e3
rf = s / sqrt(mu)
return
!                      Error return
100 rf = 0.0
ierr = 1
return
110 rf = 0.0
ierr = 2
return
120 rf = 0.0
ierr = 3
end subroutine rfval

pure elemental subroutine drfval(x, y, z, rf, ierr)
!! <!-- nswc-ford:begin DRFVAL -->
!! Reference for `drfval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the incomplete elliptic integral
!!           of the first kind
!!           rf(x,y,z) = Integral from zero to infinity of
!!                                 -1/2     -1/2     -1/2
!!                       (1/2)(T+x)    (T+y)    (T+z)    DT,
!!           where x, y, and z are nonnegative and at most one of them
!!           is zero.  If one of them is zero, the integral is complete.
!!           The duplication theorem is iterated until the variables are
!!           nearly equal, and the function is then expanded in Taylor
!!           series to fifth order.  Reference. B. C. Carlson, computing
!!           elliptic integrals by duplication, numer. Math. 33 (1979),
!!           1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!!           laboratory-doe, Iowa State University, ames, iowa 50011.
!!           March 1, 1980. Modified by A.H. Morris (NSWC).
!!
!!           Input ...
!!           x, y, and z are the variables in the integral rf(x,y,z).
!!           Output ...
!!           rf is the value of the incomplete elliptic integral.
!!           ierr is the return error code.
!!                ierr = 0  For normal completion of the subroutine.
!!                ierr = 1  x, y, or z is negative.
!!                ierr = 2  x+y, x+z, or y+z is too small.
!!                ierr = 3  x, y, or z is too large.
!!
!!           Machine dependent parameters ...
!!           lolim and uplim determine the range of valid arguments.
!!           lolim is not less than the machine minimum multiplied by 5.
!!           uplim is not greater than the machine maximum divided by 5.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the incomplete elliptic integral
!          of the first kind
!          rf(x,y,z) = Integral from zero to infinity of
!                                -1/2     -1/2     -1/2
!                      (1/2)(T+x)    (T+y)    (T+z)    DT,
!          where x, y, and z are nonnegative and at most one of them
!          is zero.  If one of them is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rf
double precision, intent(in) :: x
double precision, intent(in) :: y
double precision, intent(in) :: z
!     beginning of local variable declarations
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
!          Input ...
!          x, y, and z are the variables in the integral rf(x,y,z).
!          Output ...
!          rf is the value of the incomplete elliptic integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y, x+z, or y+z is too small.
!               ierr = 3  x, y, or z is too large.
!-----------------------------------------------------------------------
!          Machine dependent parameters ...
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
lolim = 5.0d0 * dpmpar(2)
uplim = 0.2d0 * dpmpar(3)
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          errtol ** 6 / (4 * (1 - errtol)).
errtol = (3.6 * sngl(dpmpar(1)))**(1.0/6.0)
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (min(x,y,z) < 0.d0) go to 100
if (min(x + y,x + z,y + z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
ierr = 0
xn = x
yn = y
zn = z
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
20 c1 = 1.d0 / 24.d0
c2 = 3.d0 / 44.d0
c3 = 1.d0 / 14.d0
e2 = xndev * yndev - zndev * zndev
e3 = xndev * yndev * zndev
s = 1.d0 + (c1 * e2 - 0.1d0 - c2 * e3) * e2 + c3 * e3
rf = s / sqrt(mu)
return
!                      Error return
100 rf = 0.d0
ierr = 1
return
110 rf = 0.d0
ierr = 2
return
120 rf = 0.d0
ierr = 3
end subroutine drfval

pure elemental subroutine rdval(x, y, z, rd, ierr)
!! <!-- nswc-ford:begin RDVAL -->
!! Reference for `rdval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the incomplete elliptic integral
!!           of the second kind
!!           rd(x,y,z) = Integral from zero to infinity of
!!                                 -1/2     -1/2     -3/2
!!                       (3/2)(T+x)    (T+y)    (T+z)    DT,
!!           where x and y are nonnegative, x + y is positive, and z is
!!           positive.  If x or y is zero, the integral is complete.
!!           The duplication theorem is iterated until the variables are
!!           nearly equal, and the function is then expanded in Taylor
!!           series to fifth order.  Reference. B. C. Carlson, computing
!!           elliptic integrals by duplication, numer. Math. 33 (1979),
!!           1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!!           laboratory-doe, Iowa State University, ames, iowa 50011.
!!           March 1, 1980. Modified by A.H. Morris (NSWC).
!!
!!           Input ...
!!           x, y, and z are the variables in the integral rd(x,y,z).
!!           Output ...
!!           rd is the value of the incomplete elliptic integral.
!!           ierr is the return error code.
!!                ierr = 0  For normal completion of the subroutine.
!!                ierr = 1  x, y, or z is negative.
!!                ierr = 2  x+y or z is too small.
!!                ierr = 3  x, y, or z is too large.
!!
!!           Machine dependent parameters ...
!!           errtol is set to the desired error tolerance.
!!           Relative error due to truncation is less than
!!           3 * errtol ** 6 / (1 - errtol) ** 3/2.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the incomplete elliptic integral
!          of the second kind
!          rd(x,y,z) = Integral from zero to infinity of
!                                -1/2     -1/2     -3/2
!                      (3/2)(T+x)    (T+y)    (T+z)    DT,
!          where x and y are nonnegative, x + y is positive, and z is
!          positive.  If x or y is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rd
real, intent(in) :: x
real, intent(in) :: y
real, intent(in) :: z
!     beginning of local variable declarations
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
!          Input ...
!          x, y, and z are the variables in the integral rd(x,y,z).
!          Output ...
!          rd is the value of the incomplete elliptic integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y or z is too small.
!               ierr = 3  x, y, or z is too large.
!-----------------------------------------------------------------------
!          Machine dependent parameters ...
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          3 * errtol ** 6 / (1 - errtol) ** 3/2.
errtol = (.28 * spmpar(1)) ** (1.0/6.0)
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than 2 / (machine maximum) ** (2/3).
!          uplim is not greater than (0.1 * errtol / machine
!          MINIMUM) ** (2/3).
mu = -2.0/3.0
lolim = 2.0001 * spmpar(3) ** mu
uplim = (10.0 * spmpar(2) / errtol) ** mu
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (min(x,y,z) < 0.0) go to 100
if (min(x + y,z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
ierr = 0
xn = x
yn = y
zn = z
sigma = 0.0
power4 = 1.0
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
!                        Error return
100 rd = 0.0
ierr = 1
return
110 rd = 0.0
ierr = 2
return
120 rd = 0.0
ierr = 3
end subroutine rdval

pure elemental subroutine drdval(x, y, z, rd, ierr)
!! <!-- nswc-ford:begin DRDVAL -->
!! Reference for `drdval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the incomplete elliptic integral
!!           of the second kind
!!           rd(x,y,z) = Integral from zero to infinity of
!!                                 -1/2     -1/2     -3/2
!!                       (3/2)(T+x)    (T+y)    (T+z)    DT,
!!           where x and y are nonnegative, x + y is positive, and z is
!!           positive.  If x or y is zero, the integral is complete.
!!           The duplication theorem is iterated until the variables are
!!           nearly equal, and the function is then expanded in Taylor
!!           series to fifth order.  Reference. B. C. Carlson, computing
!!           elliptic integrals by duplication, numer. Math. 33 (1979),
!!           1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!!           laboratory-doe, Iowa State University, ames, iowa 50011.
!!           March 1, 1980. Modified by A.H. Morris (NSWC).
!!
!!           Input ...
!!           x, y, and z are the variables in the integral rd(x,y,z).
!!           Output ...
!!           rd is the value of the incomplete elliptic integral.
!!           ierr is the return error code.
!!                ierr = 0  For normal completion of the subroutine.
!!                ierr = 1  x, y, or z is negative.
!!                ierr = 2  x+y or z is too small.
!!                ierr = 3  x, y, or z is too large.
!!
!!           Machine dependent parameters ...
!!           ERRTOL is set to the desired error tolerance.
!!           Relative error due to truncation is less than
!!           3 * ERRTOL ** 6 / (1 - ERRTOL) ** 3/2.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the incomplete elliptic integral
!          of the second kind
!          rd(x,y,z) = Integral from zero to infinity of
!                                -1/2     -1/2     -3/2
!                      (3/2)(T+x)    (T+y)    (T+z)    DT,
!          where x and y are nonnegative, x + y is positive, and z is
!          positive.  If x or y is zero, the integral is complete.
!          The duplication theorem is iterated until the variables are
!          nearly equal, and the function is then expanded in Taylor
!          series to fifth order.  Reference. B. C. Carlson, computing
!          elliptic integrals by duplication, numer. Math. 33 (1979),
!          1-16.  Coded by B. C. Carlson and Elaine M. Notis, ames
!          laboratory-doe, Iowa State University, ames, iowa 50011.
!          March 1, 1980. Modified by A.H. Morris (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rd
double precision, intent(in) :: x
double precision, intent(in) :: y
double precision, intent(in) :: z
!     beginning of local variable declarations
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
!          Input ...
!          x, y, and z are the variables in the integral rd(x,y,z).
!          Output ...
!          rd is the value of the incomplete elliptic integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, or z is negative.
!               ierr = 2  x+y or z is too small.
!               ierr = 3  x, y, or z is too large.
!-----------------------------------------------------------------------
!          Machine dependent parameters ...
!          ERRTOL is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          3 * ERRTOL ** 6 / (1 - ERRTOL) ** 3/2.
errtol = (.28 * sngl(dpmpar(1)))**(1.0/6.0)
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than 2 / (machine maximum) ** (2/3).
!          uplim is not greater than (0.1 * ERRTOL / machine
!          MINIMUM) ** (2/3).
mu = -2.d0/3.d0
lolim = 2.00000000001d0 * dpmpar(3) ** mu
uplim = (10.d0 * dpmpar(2) / errtol) ** mu
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (min(x,y,z) < 0.d0) go to 100
if (min(x + y,z) < lolim) go to 110
if (max(x,y,z) > uplim) go to 120
ierr = 0
xn = x
yn = y
zn = z
sigma = 0.d0
power4 = 1.d0
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
!                        Error return
100 rd = 0.d0
ierr = 1
return
110 rd = 0.d0
ierr = 2
return
120 rd = 0.d0
ierr = 3
end subroutine drdval

pure elemental subroutine rjval(x, y, z, p, rj, ierr)
!! <!-- nswc-ford:begin RJVAL -->
!! Reference for `rjval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the incomplete elliptic integral
!!           of the third kind
!!           rj(x,y,z,p) = Integral from zero to infinity of
!!                                   -1/2     -1/2     -1/2     -1
!!                         (3/2)(T+x)    (T+y)    (T+z)    (T+p)  DT,
!!           where x, y, and z are nonnegative, at most one of them is
!!           zero, and p is positive.  If x or y or z is zero, the
!!           integral is complete.  The duplication theorem is iterated
!!           until the variables are nearly equal, and the function is
!!           then expanded in Taylor series to fifth order.  Reference.
!!           B. C. Carlson, computing elliptic integrals by duplication,
!!           numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!!           Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!!           ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!!           (NSWC).
!!
!!           Input ...
!!           x, y, z, and p are the variables in the integral rj(x,y,z,p).
!!           Output ...
!!           rj is the value of the incomplete elliptic integral.
!!           ierr is the return error code.
!!                ierr = 0  For normal completion of the subroutine.
!!                ierr = 1  x, y, z, or p is negative.
!!                ierr = 2  x+y, x+z, y+z, or p is too small.
!!                ierr = 3  x, y, z, or p is too large.
!!
!!           Machine dependent parameters ...
!!           rc is a function computed by the subroutine rcval1.
!!           lolim and uplim determine the range of valid arguments.
!!           lolim is not less than the cube root of the value
!!           of lolim used in the code for rc, and
!!           uplim is not greater than 0.3 times the cube root of
!!           the value of uplim used in the code for rc.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the incomplete elliptic integral
!          of the third kind
!          rj(x,y,z,p) = Integral from zero to infinity of
!                                  -1/2     -1/2     -1/2     -1
!                        (3/2)(T+x)    (T+y)    (T+z)    (T+p)  DT,
!          where x, y, and z are nonnegative, at most one of them is
!          zero, and p is positive.  If x or y or z is zero, the
!          integral is complete.  The duplication theorem is iterated
!          until the variables are nearly equal, and the function is
!          then expanded in Taylor series to fifth order.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rj
real, intent(in) :: p
real, intent(in) :: x
real, intent(in) :: y
real, intent(in) :: z
!     beginning of local variable declarations
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
!          Input ...
!          x, y, z, and p are the variables in the integral rj(x,y,z,p).
!          Output ...
!          rj is the value of the incomplete elliptic integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, z, or p is negative.
!               ierr = 2  x+y, x+z, y+z, or p is too small.
!               ierr = 3  x, y, z, or p is too large.
!-----------------------------------------------------------------------
!          Machine dependent parameters ...
!          rc is a function computed by the subroutine rcval1.
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the cube root of the value
!          of lolim used in the code for rc, and
!          uplim is not greater than 0.3 times the cube root of
!          the value of uplim used in the code for rc.
mu = 1.0/3.0
lolim = 1.0001 * (5.0 * spmpar(2))**mu
uplim = .29999 * (0.2 * spmpar(3))**mu
!          errtol is set to the desired error tolerance. The
!          relative error due to truncation of the series for rj
!          is less than 3 * errtol ** 6 / (1 - errtol) ** 3/2.
!          An error tolerance (etolrc) will be passed to the code for
!          rc to make the truncation error for rc less than for rj.
errtol = (.28 * spmpar(1))**(1.0/6.0)
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (min(x,y,z,p) < 0.0) go to 100
if (min(x + y,x + z,y + z,p) < lolim) go to 110
if (max(x,y,z,p) > uplim) go to 120
ierr = 0
xn = x
yn = y
zn = z
pn = p
sigma = 0.0
power4 = 1.0
etolrc = 0.5 * errtol
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
!                        Error return
100 rj = 0.0
ierr = 1
return
110 rj = 0.0
ierr = 2
return
120 rj = 0.0
ierr = 3
end subroutine rjval

pure elemental subroutine drjval(x, y, z, p, rj, ierr)
!! <!-- nswc-ford:begin DRJVAL -->
!! Reference for `drjval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the incomplete elliptic integral
!!           of the third kind
!!           rj(x,y,z,p) = Integral from zero to infinity of
!!                                   -1/2     -1/2     -1/2     -1
!!                         (3/2)(T+x)    (T+y)    (T+z)    (T+p)  DT,
!!           where x, y, and z are nonnegative, at most one of them is
!!           zero, and p is positive.  If x or y or z is zero, the
!!           integral is complete.  The duplication theorem is iterated
!!           until the variables are nearly equal, and the function is
!!           then expanded in Taylor series to fifth order.  Reference.
!!           B. C. Carlson, computing elliptic integrals by duplication,
!!           numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!!           Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!!           ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!!           (NSWC).
!!
!!           Input ...
!!           x, y, z, and p are the variables in the integral rj(x,y,z,p).
!!           Output ...
!!           rj is the value of the incomplete elliptic integral.
!!           ierr is the return error code.
!!                ierr = 0  For normal completion of the subroutine.
!!                ierr = 1  x, y, z, or p is negative.
!!                ierr = 2  x+y, x+z, y+z, or p is too small.
!!                ierr = 3  x, y, z, or p is too large.
!!
!!           Machine dependent parameters ...
!!           rc is a function computed by the subroutine drcvl1.
!!           lolim and uplim determine the range of valid arguments.
!!           lolim is not less than the cube root of the value
!!           of lolim used in the code for rc, and
!!           uplim is not greater than 0.3 times the cube root of
!!           the value of uplim used in the code for rc.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the incomplete elliptic integral
!          of the third kind
!          rj(x,y,z,p) = Integral from zero to infinity of
!                                  -1/2     -1/2     -1/2     -1
!                        (3/2)(T+x)    (T+y)    (T+z)    (T+p)  DT,
!          where x, y, and z are nonnegative, at most one of them is
!          zero, and p is positive.  If x or y or z is zero, the
!          integral is complete.  The duplication theorem is iterated
!          until the variables are nearly equal, and the function is
!          then expanded in Taylor series to fifth order.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rj
double precision, intent(in) :: p
double precision, intent(in) :: x
double precision, intent(in) :: y
double precision, intent(in) :: z
!     beginning of local variable declarations
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
!          Input ...
!          x, y, z, and p are the variables in the integral rj(x,y,z,p).
!          Output ...
!          rj is the value of the incomplete elliptic integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x, y, z, or p is negative.
!               ierr = 2  x+y, x+z, y+z, or p is too small.
!               ierr = 3  x, y, z, or p is too large.
!-----------------------------------------------------------------------
!          Machine dependent parameters ...
!          rc is a function computed by the subroutine drcvl1.
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the cube root of the value
!          of lolim used in the code for rc, and
!          uplim is not greater than 0.3 times the cube root of
!          the value of uplim used in the code for rc.
mu = 1.d0/3.d0
lolim = 1.00000000001d0 * (5.0d0 * dpmpar(2))**mu
uplim = .299999999999d0 * (0.2d0 * dpmpar(3))**mu
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation of the series for rj
!          is less than 3 * errtol ** 6 / (1 - errtol) ** 3/2.
!          An error tolerance (etolrc) will be passed to the code for
!          rc to make the truncation error for rc less than for rj.
errtol = (.28 * sngl(dpmpar(1)))**(1.0/6.0)
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (min(x,y,z,p) < 0.d0) go to 100
if (min(x + y,x + z,y + z,p) < lolim) go to 110
if (max(x,y,z,p) > uplim) go to 120
ierr = 0
xn = x
yn = y
zn = z
pn = p
sigma = 0.d0
power4 = 1.d0
etolrc = 0.5d0 * errtol
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
!                        Error return
100 rj = 0.d0
ierr = 1
return
110 rj = 0.d0
ierr = 2
return
120 rj = 0.d0
ierr = 3
end subroutine drjval

pure elemental subroutine rcval1(x, y, errtol, rc, ierr)
!! <!-- nswc-ford:begin RCVAL1 -->
!! Reference for `rcval1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the integral
!!           rc(x,y) = Integral from zero to infinity of
!!                               -1/2     -1
!!                     (1/2)(T+x)    (T+y)  DT,
!!           where x is nonnegative and y is positive.  The duplication
!!           theorem is iterated until the variables are nearly equal,
!!           and the function is then expanded in Taylor series to fifth
!!           order.  Logarithmic, inverse circular, and inverse hyper-
!!           BOLIC functions can be expressed in terms of rc.  Reference.
!!           B. C. Carlson, computing elliptic integrals by duplication,
!!           numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!!           Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!!           ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!!           (NSWC).
!!
!!           lolim and uplim determine the range of valid arguments.
!!           lolim is not less than the machine minimum multiplied by 5.
!!           uplim is not greater than the machine maximum divided by 5.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the integral
!          rc(x,y) = Integral from zero to infinity of
!                              -1/2     -1
!                    (1/2)(T+x)    (T+y)  DT,
!          where x is nonnegative and y is positive.  The duplication
!          theorem is iterated until the variables are nearly equal,
!          and the function is then expanded in Taylor series to fifth
!          order.  Logarithmic, inverse circular, and inverse hyper-
!          BOLIC functions can be expressed in terms of rc.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
real, intent(inout) :: rc
real, intent(in) :: errtol
real, intent(in) :: x
real, intent(in) :: y
!     beginning of local variable declarations
real :: c1, c2, lamda, lolim, mu, s, sn, uplim, xn, yn
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
lolim = 5.0 * spmpar(2)
uplim = 0.2 * spmpar(3)
!          Input ...
!          x and y are the variables in the integral rc(x,y).
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          16 * errtol ** 6 / (1 - 2 * errtol).
!          SAMPLE CHOICES   errtol   RELATIVE TRUNCATION
!                                    error less than
!                           1.E-3    2.E-17
!                           3.E-3    2.E-14
!                           1.E-2    2.E-11
!                           3.E-2    2.E-8
!                           1.E-1    2.E-5
!          output ...
!          rc is the value of the integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x OR y IS NEGATIVE, OR y = 0.
!               ierr = 2  x+y is too small.
!               ierr = 3  x or y is too large.
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (x < 0.0 .or. y <= 0.0) go to 100
if ((x + y) < lolim) go to 110
if (max(x,y) > uplim) go to 120
ierr = 0
xn = x
yn = y
10 mu = (xn + yn + yn) / 3.0
sn = (yn + mu) / mu - 2.0
if (abs(sn) < errtol) go to 20
lamda = 2.0 * sqrt(xn) * sqrt(yn) + yn
xn = (xn + lamda) * 0.25
yn = (yn + lamda) * 0.25
go to 10
20 c1 = 1.0 / 7.0
c2 = 9.0 / 22.0
s = sn * sn * (0.3 + sn * (c1 + sn * (0.375 + sn * c2)))
rc = (1.0 + s) / sqrt(mu)
return
!                      Error return
100 rc = 0.0
ierr = 1
return
110 rc = 0.0
ierr = 2
return
120 rc = 0.0
ierr = 3
end subroutine rcval1

pure elemental subroutine drcvl1(x, y, errtol, rc, ierr)
!! <!-- nswc-ford:begin DRCVL1 -->
!! Reference for `drcvl1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           This subroutine computes the integral
!!           rc(x,y) = Integral from zero to infinity of
!!                               -1/2     -1
!!                     (1/2)(T+x)    (T+y)  DT,
!!           where x is nonnegative and y is positive.  The duplication
!!           theorem is iterated until the variables are nearly equal,
!!           and the function is then expanded in Taylor series to fifth
!!           order.  Logarithmic, inverse circular, and inverse hyper-
!!           BOLIC functions can be expressed in terms of rc.  Reference.
!!           B. C. Carlson, computing elliptic integrals by duplication,
!!           numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!!           Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!!           ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!!           (NSWC).
!!
!!           lolim and uplim determine the range of valid arguments.
!!           lolim is not less than the machine minimum multiplied by 5.
!!           uplim is not greater than the machine maximum divided by 5.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!          This subroutine computes the integral
!          rc(x,y) = Integral from zero to infinity of
!                              -1/2     -1
!                    (1/2)(T+x)    (T+y)  DT,
!          where x is nonnegative and y is positive.  The duplication
!          theorem is iterated until the variables are nearly equal,
!          and the function is then expanded in Taylor series to fifth
!          order.  Logarithmic, inverse circular, and inverse hyper-
!          BOLIC functions can be expressed in terms of rc.  Reference.
!          B. C. Carlson, computing elliptic integrals by duplication,
!          numer. Math. 33 (1979), 1-16.  Coded by B. C. Carlson and
!          Elaine M. Notis, Ames Laboratory-doe, Iowa State University,
!          ames, iowa 50011.  March 1, 1980. Modified by A.H. Morris
!          (NSWC).
!-----------------------------------------------------------------------
integer, intent(inout) :: ierr
double precision, intent(inout) :: rc
double precision, intent(in) :: errtol
double precision, intent(in) :: x
double precision, intent(in) :: y
!     beginning of local variable declarations
double precision :: c1, c2, lamda, lolim, mu, s, sn, uplim, xn, yn
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!          lolim and uplim determine the range of valid arguments.
!          lolim is not less than the machine minimum multiplied by 5.
!          uplim is not greater than the machine maximum divided by 5.
lolim = 5.0d0 * dpmpar(2)
uplim = 0.2d0 * dpmpar(3)
!          Input ...
!          x and y are the variables in the integral rc(x,y).
!          errtol is set to the desired error tolerance.
!          Relative error due to truncation is less than
!          16 * errtol ** 6 / (1 - 2 * errtol).
!          Output ...
!          rc is the value of the integral.
!          ierr is the return error code.
!               ierr = 0  For normal completion of the subroutine.
!               ierr = 1  x OR y IS NEGATIVE, OR y = 0.
!               ierr = 2  x+y is too small.
!               ierr = 3  x or y is too large.
!-----------------------------------------------------------------------
!          Warning. Changes in the program may improve speed at the
!          expense of robustness.
!-----------------------------------------------------------------------
if (x < 0.d0  .or.  y <= 0.d0) go to 100
if ((x + y) < lolim) go to 110
if (max(x,y) > uplim) go to 120
ierr = 0
xn = x
yn = y
10 mu = (xn + yn + yn) / 3.d0
sn = (yn + mu) / mu - 2.d0
if (abs(sn) < errtol) go to 20
lamda = 2.d0 * sqrt(xn) * sqrt(yn) + yn
xn = (xn + lamda) * 0.25d0
yn = (yn + lamda) * 0.25d0
go to 10
20 c1 = 1.d0 / 7.d0
c2 = 9.d0 / 22.d0
s = sn * sn * (0.3d0 + sn * (c1 + sn * (0.375d0 + sn * c2)))
rc = (1.d0 + s) / sqrt(mu)
return
!                      Error return
100 rc = 0.d0
ierr = 1
return
110 rc = 0.d0
ierr = 2
return
120 rc = 0.d0
ierr = 3
end subroutine drcvl1

pure elemental subroutine ellpf(u,k,l,s,c,d,ierr)
!! <!-- nswc-ford:begin ELLPF -->
!! Reference for `ellpf`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      ellpf calculates the elliptic functions sn(u,k), CN(u,k), and
!!      DN(u,k) for real u and real modulus k.  it is assumed that
!!      abs(k) .LE. 1. AND k**2 + l**2 = 1.
!!
!!      ****** max and eps are machine dependent constants.
!!             Max is the largest positive integer that may
!!             be used, and eps is the smallest real number
!!             for which 1 + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
real, intent(inout) :: c, d, s
real, intent(in) :: u
real, intent(in) :: k, l
!     beginning of local variable declarations
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
max = ipmpar(3)
eps = spmpar(1)
!     ----------------
!     Calculation for l = 0.0
if (l /= 0.0) go to 10
s = tanh(u)
e = exp(-abs(u))
c = 2.0*e/(1.0 + e*e)
d = c
ierr = 0
return
!     Check that k**2 + l**2 = 1
10 tol = 2.0*eps
z = dble(k*k) + (dble(l*l) - 1.d0)
if (abs(z) > tol) go to 100
f = pihalf
if (k /= 0.0) call ellpi(pihalf,0.0,k,l,f,e,ierr)
f2 = 2.0*f
!                   Argument reduction
u1 = abs(u)
r = u1/f2
if (r >= min(float(max),1.0/eps)) go to 110
n = int(r)
u1 = u1 - float(n)*f2
sg = 1.0
if (mod(n,2) /= 0) sg = -1.0
if (u1 <= 0.0) go to 30
if (u1 <= f) go to 20
u1 = u1 - f2
sg = -sg
if (u1 >= 0.0) go to 30
!     Calculation of elliptic functions for 0.0 .LE. u2 .LE. f(k)
20 u2 = abs(u1)
call scd(u2,abs(k),abs(l),f,s,c,d)
ierr = 0
if (u1 < 0.0) s = -s
!     Final assembly
s = sg*s
c = sg*c
if (u < 0.0) s = -s
return
!             u is an integer multiple of f2
30 s = 0.0
c = sg
d = 1.0
ierr = 0
return
!                      Error return
100 ierr = 1
return
110 ierr = 2
end subroutine ellpf

pure elemental subroutine scd(u,k,l,f,s,c,d)
!! <!-- nswc-ford:begin SCD -->
!! Reference for `scd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      scd computes the elliptic functions sn(u,k), CN(u,k),
!!      and DN(u,k) for real u and real modulus k such that
!!      0.0 .LE. u .LE. f AND 0.0 .LE. k .LT. 1.0, WHERE
!!      f = f(k) is the complete elliptic integral of the
!!      first kind, and f1 = f(l) is the complementary integral.
!!      It is assumed that k**2 + l**2 = 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f
real, intent(inout) :: s
real, intent(in) :: u
real, intent(in) :: k, l
!     beginning of local variable declarations
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
!     Uses Maclaurin expansion when u or v .LE. 0.01
if (u > 0.01) go to 10
call scdm(u,k,s,c,d)
return
10 if (v > 0.01) go to 20
call scdm(v,k,s1,c1,d1)
s = c1/d1
c = l*s1/d1
d = l/d1
return
!     Uses Fourier expansion when k .LE. l
20 call ellpi(pihalf,0.0,l,k,f1,e1,ierr)
if (k > l) go to 30
call scdf(u,k,l,f,f1,s,c,d)
return
!     Uses imaginary transformation of Jacobi and Fourier
!     expansion when k .GT. l
30 call scdj(u,k,l,f,f1,s,c,d)
return
!     Computation for k = 0.0
40 s = sin(u)
c = cos(u)
d = 1.0
end subroutine scd

pure elemental subroutine scdm(u,k,s,c,d)
!! <!-- nswc-ford:begin SCDM -->
!! Reference for `scdm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Calculates SN(u,k), CN(u,k), and DN(u,k) for
!!      0.0 .LE. u .LE. 0.01 and for 0.0 .LE. k .LE. 1.0
!!      by use of the Maclaurin expansion for SN(u,k)
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(out) :: c, d, s
real, intent(in) :: u
real, intent(in) :: k
!     beginning of local variable declarations
real :: c1, c2, c3, c4, u2, k2
!     -------------------------------------------------
!     Calculates SN(u,k), CN(u,k), and DN(u,k) for
!     0.0 .LE. u .LE. 0.01 and for 0.0 .LE. k .LE. 1.0
!     by use of the Maclaurin expansion for SN(u,k)
!     -------------------------------------------------
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
end subroutine scdm

pure elemental subroutine scdf(u,k,l,f,f1,s,c,d)
!! <!-- nswc-ford:begin SCDF -->
!! Reference for `scdf`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      scdf computes SN(u,k), CN(u,k), and DN(u,k) for real u and
!!      k by use of the Fourier expansion for SN(u,k).  It is
!!      assumed that 0.0 .LE. k .LT. 1.0 and 0.0 .LE. u .LE. f,
!!      where f = f(k) is the complete elliptic integral of the
!!      first kind and f1 = f(l) is the complementary integral, with
!!      l .NE. 0. AND k**2 + l**2 = 1.
!!
!!      Eps is a machine dependent constant.  Eps is the
!!      smallest number such that 1. + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f, f1
real, intent(inout) :: s
real, intent(in) :: u
real, intent(in) :: k, l
!     beginning of local variable declarations
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
eps = spmpar(1)
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
!     Calculation of series for W = AMIN1(u,V)
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
!     Assembly for u .LE. V
20 s = coef*sum
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
if (u == w) return
!     Assembly for u .GT. V
temp = s
s = c/d
c = l*temp/d
d = l/d
end subroutine scdf

pure elemental subroutine scdj(u,k,l,f,f1,s,c,d)
!! <!-- nswc-ford:begin SCDJ -->
!! Reference for `scdj`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      scdj computes SN(u,k), CN(u,k), and DN(u,k) for real u and
!!      k using the imaginary transformation of Jacobi and A
!!      Fourier expansion.  It is assumed that 0.0 .LE. k .LT. 1.0
!!      and 0.0 .LE. u .LE. f, where f = f(k) is the complete elliptic
!!      integral of the first kind and f1 = f(l) is the complementary
!!      integral, and that l .NE. 0. And k**2 + l**2 = 1.
!!
!!      Eps is a machine dependent constant.  Eps is the
!!      smallest number such that 1. + eps .GT. 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(inout) :: c, d
real, intent(in) :: f, f1
real, intent(inout) :: s
real, intent(in) :: u
real, intent(in) :: k, l
!     beginning of local variable declarations
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
eps = spmpar(1)
!     ------------------------------------------------
tol = eps/10.0
v = f - u
q1 = -exp(-pi*f/f1)
q2 = q1*q1
w = min(u,v)
e1 = pi*max(u,v)/f1
e2 = pi*(f + w)/f1
e1 = exp(-e1)
e2 = exp(-e2)
coef = pihalf/(k*f1)
x = pihalf*w/f1
x2 = 2.0*x
!     Calculation of series for W = AMIN1(u,V)
n = 1.0
q1n = q1
q2n = q2
e1n = e1
e2n = e2
sum = 0.0
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
!     Assembly for u .LE. V
50 s = coef*(tanh(x) + 2.0*sum)
c = sqrt(1.0 - s*s)
d = sqrt(1.0 - (k*s)**2)
if (u == w) return
!     Assembly for u .GT. V
temp = s
s = c/d
c = l*temp/d
d = l/d
end subroutine scdj

pure elemental subroutine elpfc1(u,k,l,s,c,d,ierr)
!! <!-- nswc-ford:begin ELPFC1 -->
!! Reference for `elpfc1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      elpfc1 calculates the elliptic functions sn(u,k), CN(u,k),
!!      DN(u,k) for complex u and real modulus k.  it is assumed that
!!      abs(k) .LE. 1. AND k**2 + l**2 = 1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
complex, intent(in) :: u
complex, intent(inout) :: s, c, d
real, intent(in) :: k, l
!     beginning of local variable declarations
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
u1 = real(u)
u2 = aimag(u)
k2 = k*k
if (u1 == 0.0) go to 10
if (u2 /= 0.0) go to 20
!     Calculation for U2 = 0.
call ellpf(u1,k,l,s1,c1,d1,ierr)
if (ierr /= 0) return
s2 = 0.0
c2 = 0.0
d2 = 0.0
go to 40
!     Calculation for U1 = 0.
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
!     Calculation for U1 and U2 .NE. 0.
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
!     Final assembly
40 s = cmplx(s1, s2)
c = cmplx(c1, c2)
d = cmplx(d1, d2)
return
!     Error return
50 ierr = 3
end subroutine elpfc1

pure elemental subroutine peq(z, w, ierr)
!! <!-- nswc-ford:begin PEQ -->
!! Reference for `peq`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Weierstrass P-function in the equianharmonic case
!!      for complex argument with unit period parallelogram
!!      Reduction to fundamental parallelogram
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Weierstrass P-function in the equianharmonic case
!     for complex argument with unit period parallelogram
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
!     beginning of local variable declarations
complex :: z1, z4, z6
real :: zr, zi
integer :: m, n
!     Reduction to fundamental parallelogram
zi = 1.1547005383792515e0*aimag(z) + 0.5e0
m = int(zi)
if (zi < 0e0) m = m - 1
zr = real(z) - 0.5e0*float(m) + 0.5e0
n = int(zr)
if (zr < 0e0) n = n - 1
z1 = z - float(n) - (0.5e0,0.86602540378443865e0)*float(m)
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for P.
w = z1*z1
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!     Evaluation of P(z1)
10 ierr = 0
z4 = w*w
z6 = z4*w
w = 1e0/w + 6e0*z4*(5e0 + z6)/(1e0 - z6)**2 + z4* &
   & (((((-2.6427662e-10*z6 + 1.610954818e-8)*z6 + 7.38610752879e-6)* &
   & z6 + 4.3991444671178e-4)*z6 + 7.477288220490697e-2)* &
   & z6 - 6.8484153287299201e-1)/(((((6.2252191e-10*z6 + 2.553314573e-7)* &
   & z6 - 2.619832920421e-5)*z6 - 5.6444801847646e-4)* &
   & z6 + 4.565553484820106e-2)*z6 + 1e0)
end subroutine peq

pure elemental subroutine peq1(z, w, ierr)
!! <!-- nswc-ford:begin PEQ1 -->
!! Reference for `peq1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      First derivative of Weierstrass P-function in the
!!      equianharmonic case for complex argument
!!      with unit period parallelogram
!!      Reduction to fundamental parallelogram
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     First derivative of Weierstrass P-function in the
!     equianharmonic case for complex argument
!     with unit period parallelogram
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
!     beginning of local variable declarations
complex :: z1, z3, z6
real :: zr, zi
integer :: m, n
!     Reduction to fundamental parallelogram
zi = 1.1547005383792515e0*aimag(z) + 0.5e0
m = int(zi)
if (zi < 0e0) m = m - 1
zr = real(z) - 0.5e0*float(m) + 0.5e0
n = int(zr)
if (zr < 0e0) n = n - 1
z1 = z - float(n) - (0.5e0,0.86602540378443865e0)*float(m)
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for DP.
z3 = z1*z1*z1
z6 = z3*z3
w = z3*(1e0 - z6)**3
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!     Evaluation of DP(z1)
10 ierr = 0
w = (((14e0*z6 + 294e0)*z6 + 126e0)*z6 - 2e0)/w + &
   & z3*((((((-2.95539175e-9*z6 - 2.6764693031e-7)*z6 + 2.402192743346e-5) &
   & *z6 + 1.9656661451391e-4)*z6 + 1.760135529461036e-2)* &
   & z6 + 8.1026243498822636e-1)*z6 - 2.73936613149196804e0)/ &
   & ((((((4.6397763e-10*z6 + 5.413482233e-8)*z6 - 1.56293298374e-6)* &
   & z6 - 1.0393701076352e-4)*z6 + 9.5553182532237e-4)* &
   & z6 + 9.131106969640212e-2)*z6 + 1e0)
end subroutine peq1

pure elemental subroutine plem(z, w, ierr)
!! <!-- nswc-ford:begin PLEM -->
!! Reference for `plem`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Weierstrass P-function in the lemniscatic case
!!      for complex argument with unit period parallelogram
!!      Reduction to fundamental parallelogram
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     Weierstrass P-function in the lemniscatic case
!     for complex argument with unit period parallelogram
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
!     beginning of local variable declarations
complex :: z1, z4, z6
real :: zr, zi
integer :: m, n
!     Reduction to fundamental parallelogram
zr = real(z) + 0.5e0
zi = aimag(z) + 0.5e0
m = int(zr)
n = int(zi)
if (zr < 0e0) m = m - 1
if (zi < 0e0) n = n - 1
z1 = z - float(m) - (0e0,1e0)*float(n)
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for P.
w = z1*z1
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!     Evaluation of P(z1)
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
end subroutine plem

pure elemental subroutine plem1(z, w, ierr)
!! <!-- nswc-ford:begin PLEM1 -->
!! Reference for `plem1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      First derivative of Weierstrass P-function in the
!!      lemniscatic case for complex argument
!!      with unit period parallelogram
!!      Reduction to fundamental parallelogram
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     First derivative of Weierstrass P-function in the
!     lemniscatic case for complex argument
!     with unit period parallelogram
complex, intent(in) :: z
complex, intent(inout) :: w
integer, intent(inout) :: ierr
!     beginning of local variable declarations
complex :: z1, z3, z4
real :: zr, zi
integer :: m, n
!     Reduction to fundamental parallelogram
zr = real(z) + 0.5e0
zi = aimag(z) + 0.5e0
m = int(zr)
n = int(zi)
if (zr < 0e0) m = m - 1
if (zi < 0e0) n = n - 1
z1 = z - float(m) - (0e0,1e0)*float(n)
!     If z1=0 Then z coincides with a lattice point.
!     The lattice points are poles for DP.
z3 = z1*z1*z1
z4 = z3*z1
w = (z1*(1e0 - z4))**3
zr = abs(real(w)) + abs(aimag(w))
if (zr /= 0e0) go to 10
ierr = 1
return
!     Evaluation of DP(z1)
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
end subroutine plem1

pure subroutine valr2(x,y,n0,p,iop,a,ind,ko)
!! <!-- nswc-ford:begin VALR2 -->
!! Reference for `valr2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Tau is a machine dependent tolerance. It is assumed that A
!!      7 or more digit floating point arithmetic is being used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: iop
integer, intent(inout) :: ko
integer, intent(in) :: n0
real, intent(inout) :: a, p, x(*), y(*)
!     beginning of local variable declarations
integer :: k, m, n, nswc_ai_i4
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
p = 0.0
ind = 0
a = 0.0
kom = 0.0
k = 1
if (n /= 1) go to 10
w = x(2) - x(1)
z = y(2) - y(1)
u = x(3) - x(1)
v = y(3) - y(1)
xk = 0.0
psi1 = v*w - u*z
if (psi1 >= 0.0) go to 21
p = -1.0
t1 = w
w = u
u = t1
t1 = v
v = z
z = t1
go to 21
10 ko = 0
x(n + 1) = x(1)
y(n + 1) = y(1)
u = x(2) - x(1)
v = y(2) - y(1)
xk = x(1)
yk = y(1)
20 w = x(1) - x(n)
z = y(1) - y(n)
21 d1sq = w*w + z*z
if (d1sq > tausq) go to 30
if (n == 1) go to 4011
n = n - 1
if (n == 2) return
go to 20
30 d2sq = u*u + v*v
if (d2sq > tausq) go to 40
if (n == 1) go to 4011
31 k = k + 1
u = x(k + 1) - xk
v = y(k + 1) - yk
d2sq = u*u + v*v
if (d2sq <= tausq) go to 31
if (k == n - 1) return
40 a = xk*(y(k + 1) - y(n))
bgd1 = sqrt(d1sq + d1sq)
bgd2 = sqrt(d2sq + d2sq)
!             Processing vertex (XK,YK)
50 psi1 = v*w - u*z
cee = u*w + v*z
aj0 = atan2(psi1,cee)
kom = kom + aj0
l = 0.0
b = .5*(x(k)*x(k) + y(k)*y(k))
if (b > aph1(iop)) go to 60
p1 = aj0/twopi
go to 3621
60 g(1) = (w*x(k) + z*y(k))/bgd1
g(2) = (u*x(k) + v*y(k))/bgd2
h(1) = (-y(k)*w + x(k)*z)/bgd1
h(2) = (-y(k)*u + x(k)*v)/bgd2
if (abs(psi1) > bgd1*bgd2*a3d8(iop)) go to 80
if (cee < 0.0) go to 70
if (abs(aj0) > tau.and.g(1) < 0.0) go to 80
p1 = 0.0
go to 3621
70 if (abs(psi1) <= (.5*tau*bgd1*bgd2)) ind = 2
if (psi1 < 0.0) go to 71
p1 = .5*erfc1(0,h(2))
go to 3621
71 p1 = -.5*erfc1(0,h(1))
go to 3621
80 if (b > aph2(iop)) go to 90
c = rtpi*(h(2) - h(1)) - (g(2)*h(2) - g(1)*h(1))
p1 = (aj0 - c)/twopi
go to 3621
!                 Computation of l
90 if (g(1) < 0.0) go to 100
if (g(2) >= 0.0) go to 130
g(2) = -g(2)
h(2) = -h(2)
if (abs(h(2)) <= aph4(iop)) go to 91
l = .5*erfc1(0,-h(2))
go to 120
91 l = .5 + rtpii*h(2)
go to 120
100 g(1) = -g(1)
h(1) = -h(1)
if (g(2) < 0.0) go to 110
if (abs(h(1)) <= aph4(iop)) go to 101
l = .5*erfc1(0,h(1))
go to 120
101 l = .5 - rtpii*h(1)
go to 120
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
120 psi1 = -psi1
if (psi1 <= 0.0) go to 121
l = l - 1.0
aj0 = aj0 + pi
go to 130
121 aj0 = aj0 - pi
!                 Series evaluation
130 if (b >= rsq(iop)) go to 171
cape = aj0
caph = .5*aj0
m = 1
f = 0.0
aj1 = h(2) - h(1)
circm = aj1
nswc_ai_i4 = iop - 2
if (nswc_ai_i4 < 0) go to 140
if (nswc_ai_i4 == 0) go to 150
go to 160
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
170 p1 = l + exp(-(b + alnpi))*(caph - sum)
go to 3621
171 p1 = l
!               Standard termination
3621 if (k /= n) go to 3651
if (n /= 1) go to 3631
p = abs(p + abs(p1))
return
3631 p = p - p1
kom = kom/twopi
a = .5*a
if (kom < 0.0) go to 3641
ko = int(kom + .125)
go to 3645
3641 ko = int(kom - .125)
3645 p = p + float(ko)
return
!              Set up the next vertex
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
!                  Error return
4011 ind = 1
p = 5.0
return
4021 ind = 3
end subroutine valr2

pure elemental subroutine circv(r, d, j, p, ierr)
!! <!-- nswc-ford:begin CIRCV -->
!! Reference for `circv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!        If j .NE. 0, output is p = Circular coverage function. p gives
!!        the probability of a shot falling, under a normal distribution
!!        with mean (0,0) and equal standard deviations, S, in a circle
!!        of radius R0, offset a distance D0 from (0,0).
!!        Input is r = R0/S, d = D0/S.
!!        If j = 0, output is p = Generalized circular error function.
!!        p gives the probability of a shot falling ,under a normal
!!        bivariate distribution with mean (0,0) and standard deviations
!!        SMIN and S, in a circle of radius R0 centered at (0,0).
!!        Input for j = 0, r = R0/S, d = SMIN/S .LE. 1.
!!        IF SMIN = 0, S .NE. 0, p = erf(r/(SQR(2)).
!!        If ierr .NE. 0, some portion of the input is unacceptable.
!!        IF r .LT. 0., THEN circv SETS ierr = 1.
!!        IF d .LT. 0, OR j = 0 AND d .GT. 1., THEN circv SETS ierr = 2.
!!        References
!!        math of comp April 1961,PP169,173 and oct.1961, PP 375, 382.
!!        NWL report N0.1768, jan. 1962. NSWC report N0.83-13, nov. 1982.
!!        IEEE trans. Info. TH. April 1965, p. 312.
!!
!!        Negative r and d are not permitted.
!!
!!      c1 = 1/sqrt(2)
!!      c2 = 1/sqrt(pi)
!!      c3 = 2*pi
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: j
real, intent(in) :: d
real, intent(out) :: p
real, intent(in) :: r
!     beginning of local variable declarations
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
!       If j = 0, output is p = Generalized circular error function.
!       p gives the probability of a shot falling ,under a normal
!       bivariate distribution with mean (0,0) and standard deviations
!       SMIN and S, in a circle of radius R0 centered at (0,0).
!       Input for j = 0, r = R0/S, d = SMIN/S .LE. 1.
!       IF SMIN = 0, S .NE. 0, p = erf(r/(SQR(2)).
!       If ierr .NE. 0, some portion of the input is unacceptable.
!       IF r .LT. 0., THEN circv SETS ierr = 1.
!       IF d .LT. 0, OR j = 0 AND d .GT. 1., THEN circv SETS ierr = 2.
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
p = 1.0
sum = m
an = 0.0
if (expt*m < 5.e-3) go to 30
!          SET  p = 1 - exp(-r*r/2)*m
p = (erf(c1*r) - d2/(1.0 + delta))/delta
sum = 0.0
!          Compute the asymptotic expansion
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
!       Find the number n of terms to be used in the series
z = 0.5*t
n = z*e + 1.0
tn = ((e*z/n)**(n + n))/(c3*n)
65 n = n + 1
w = z/n
tn = tn*(w*w)
if (tn > eps) go to 65
!       Compute the series
m = n
call gratio(m + 1.0, tr, s, w, 0)
w = rcomp(m,tr)/m
p = s
do i = 1,n
   s = s + w
   w = (m/tr)*w
   p = s + (td/m)*p
   m = m - 1.0
end do
p = exp(-td)*p
go to 110
!------------------------------------------------------------------
!      j .NE. 0,    r .GE. 1.7  AND  r*d .GT. 16
!------------------------------------------------------------------
75 z = c1*abs(a1)
w = exp(-a)
call erfc0(1, z, w, s1)
a = 0.5*z/t
t = 0.25/t
m = c2 - z*s1
if (z >= 4.0) m = erfcr(z)
m = 0.5*a*m
x = 0.5*c2*t
s1 = s1 + m
s2 = c2 + x
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
90 an = an + 2.0
anm1 = an - 1.0
x0 = x
x = (anm1/an)*(anm1*t)*x
if (x >= x0) go to 100
s2 = s2 + x
if (x > eps*s2) go to 90
100 s1 = 0.5*(r + d)*s1
s2 = c1*s2
w = w/sqrt(r*d)
p = 0.5*w*abs(s1 - s2)
if (a1 > 0.0) p = abs(1.0 - 0.5*w*(s1 + s2))
!       Termination
110 if (p > 1.0) p = 1.0
return
115 ierr = 1
p = -1.0
return
120 ierr = 2
p = -1.0
end subroutine circv

pure elemental subroutine erfc0(ind, x, e, y)
!! <!-- nswc-ford:begin ERFC0 -->
!! Reference for `erfc0`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          Evaluation of the complementary error function
!!                y = erfc(x)            if ind = 0
!!                y = exp(x*x)*erfc(x)   otherwise
!!      e is an input/output variable. If e .GE. 0 then it is assumed
!!      that e = exp(-x*x). In this case e is not modified. If e is
!!      negative then e is set to exp(-x*x) when this value is needed.
!!
!!                      abs(x) .LT. 0.47
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ind
real, intent(inout) :: e
real, intent(in) :: x
real, intent(inout) :: y
!     beginning of local variable declarations
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
!               y = erfc(x)            if ind = 0
!               y = exp(x*x)*erfc(x)   otherwise
!     e is an input/output variable. If e .GE. 0 then it is assumed
!     that e = exp(-x*x). In this case e is not modified. If e is
!     negative then e is set to exp(-x*x) when this value is needed.
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!                     abs(x) .LT. 0.47
ax = abs(x)
if (ax >= 0.47) go to 10
t = x*x
top = ((a(1)*t + a(2))*t + a(3))*t + a(4)
bot = ((b(1)*t + b(2))*t + b(3))*t + b(4)
y = 0.5 + (0.5 - x*top/bot)
if (ind == 0) return
if (e < 0.0) e = exp(-t)
y = y/e
return
!                  0.47 .LE. abs(x) .LE. 4
10 if (ax > 4.0) go to 30
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
   & + p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
   & + q(6))*ax + q(7))*ax + q(8)
y = top/bot
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
!                      abs(x) .GT. 4
30 if (x <= -5.5) go to 40
if (ind == 0 .and. x > 50.0) go to 50
t = (1.0/x)**2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + s(5)
y = (c - t*top/bot) / ax
go to 20
!             Limit value for large negative x
40 y = 2.0
if (ind == 0) return
if (e < 0.0) e = exp(-x*x)
y = 2.0/e
return
!             Limit value for large positive x
!                       when ind = 0
50 y = 0.0
end subroutine erfc0

pure elemental real function erfcr(x)
!! <!-- nswc-ford:begin ERFCR -->
!! Reference for `erfcr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Computation of  1/sqrt(PI) - x*exp(x*x)*erfc(x)  for x .GE. 4
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: x
!     beginning of local variable declarations
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
end function erfcr

pure elemental subroutine pkill(r0, sx, sy, h, k, p)
!! <!-- nswc-ford:begin PKILL -->
!! Reference for `pkill`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!            Computation of the elliptical coverage function
!!
!!      The result p is accurate to at least 6 significant digits if
!!      p .GE. 1.E-20 AND max(h/S,k/S,sx/S,sy/S) .LE. 10/sqrt(spmpar(1))
!!      FOR S = min(sx,sy).
!!
!!    v(*), w(*)-- Gaussian abscissas and weights of order 32, on (-1,1).
!!
!!      c = (2**.25)*gamma(3/4)/pi
!!      rpi = 1/sqrt(pi)
!!      rt2 = sqrt(2)
!! ```
!! <!-- nswc-ford:end -->
implicit none
real, intent(in) :: h
real, intent(out) :: p
real, intent(in) :: r0, sx, sy
real, intent(in) :: k
!     beginning of local variable declarations
integer :: i, ii, iy, iz, iz3, j, j8, n1, nt
real :: a, a1, a2, a4, c8, d, d1, d2, dm, e3, e4, eps, f, g2, g3, h1, h2, h3, h5, h6, h8, q, q1, r, r8, s0, s1, s2, s9, sa, seps1, &
   & sqeps, t, t1, t2, t3, t4, t5, t9, u, x1, x5, yy, z, z1, z2, z3, z8, z9, k8, nswc_ai_r4
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
!           Computation of the elliptical coverage function
!                         ---------------
!     The result p is accurate to at least 6 significant digits if
!     p .GE. 1.E-20 AND max(h/S,k/S,sx/S,sy/S) .LE. 10/sqrt(spmpar(1))
!     FOR S = min(sx,sy).
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!   v(*), w(*)-- Gaussian abscissas and weights of order 32, on (-1,1).
!-----------------------------------------------------------------------
!----------------------------------------
!     c = (2**.25)*gamma(3/4)/pi
!     rpi = 1/sqrt(pi)
!     rt2 = sqrt(2)
!----------------------------------------
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
nswc_ai_r4 = d1 - t
if (nswc_ai_r4 < 0) go to 200
if (nswc_ai_r4 == 0) go to 180
go to 195
172 if (e3 < 2.e4*eps) go to 195
if (f < 2.e4*eps) go to 200
if (max(h8/s1,k8/s2) < 2.0) go to 175
if (s2 < 1.e-5) go to 175
if (s2 >= 5.e-4) go to 180
if (s1 /= s2) go to 195
175 if (min(e3,f) < 2.5e-2*sqeps) goto 185
180 nswc_ai_r4 = e3 - f
if (nswc_ai_r4 < 0) go to 200
if (nswc_ai_r4 == 0) go to 190
go to 195
185 nswc_ai_r4 = e3 - f
if (nswc_ai_r4 < 0) go to 195
if (nswc_ai_r4 == 0) go to 190
go to 200
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
q1 = rpi*e3*r8
g3 = 0.0
nt = 2*n1 + 1
z = (.5 + d1) + .5
do ii = 1, nt
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
end do
p = q1*g3
if (p > yy) p = yy
if (p > (1.0 - min(1.e6*eps,1.e-5))) p = 1.0
if (p < 0.0) p = 0.0
end subroutine pkill

pure subroutine plcopy(a,ka,m,b,kb,n)
!! <!-- nswc-ford:begin PLCOPY -->
!! Reference for `plcopy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Copying real polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
!     beginning of local variable declarations
integer :: j, jmax, la, lb, mp1
!     ------------------------------------------------------------------
!     Copying real polynomials
!     ------------------------------------------------------------------
la = 1
lb = 1
jmax = min(m, n)
do j = 1,jmax
   b(lb) = a(la)
   la = la + ka
   lb = lb + kb
end do
if (jmax == n) return
mp1 = m + 1
do j = mp1,n
   b(lb) = 0.0
   lb = lb + kb
end do
end subroutine plcopy

pure subroutine dpcopy(a,ka,m,b,kb,n)
!! <!-- nswc-ford:begin DPCOPY -->
!! Reference for `dpcopy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Copying double precision polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
!     beginning of local variable declarations
integer :: j, jmax, la, lb, mp1
!     ------------------------------------------------------------------
!     Copying double precision polynomials
!     ------------------------------------------------------------------
la = 1
lb = 1
jmax = min(m, n)
do j = 1,jmax
   b(lb) = a(la)
   la = la + ka
   lb = lb + kb
end do
if (jmax == n) return
mp1 = m + 1
do j = mp1,n
   b(lb) = 0.d0
   lb = lb + kb
end do
end subroutine dpcopy

pure subroutine padd(a,ka,l,b,kb,m,c,kc,n)
!! <!-- nswc-ford:begin PADD -->
!! Reference for `padd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Addition of real polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Addition of real polynomials
!     ------------------------------------------------------------------
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
end subroutine padd

pure subroutine dpadd(a,ka,l,b,kb,m,c,kc,n)
!! <!-- nswc-ford:begin DPADD -->
!! Reference for `dpadd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Addition of double precision polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Addition of double precision polynomials
!     ------------------------------------------------------------------
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
end subroutine dpadd

pure subroutine psubt(a,ka,l,b,kb,m,c,kc,n)
!! <!-- nswc-ford:begin PSUBT -->
!! Reference for `psubt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Subtraction of real polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Subtraction of real polynomials
!     ------------------------------------------------------------------
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
end subroutine psubt

pure subroutine dpsubt(a,ka,l,b,kb,m,c,kc,n)
!! <!-- nswc-ford:begin DPSUBT -->
!! Reference for `dpsubt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Subtraction of double precision polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, la, lb, lc
!     ------------------------------------------------------------------
!     Subtraction of double precision polynomials
!     ------------------------------------------------------------------
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
end subroutine dpsubt

pure subroutine pmult(a,ka,l,b,kb,m,c,kc,n)
!! <!-- nswc-ford:begin PMULT -->
!! Reference for `pmult`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Multiplication of real polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, imax, imin, j, jmax, jmin, la, lb, lc
double precision :: dsum
!     ------------------------------------------------------------------
!     Multiplication of real polynomials
!     ------------------------------------------------------------------
lc = 1
jmax = min(l + m - 1, n)
do j = 1,jmax
   if (j <= l) go to 10
   imin = 1 + (j - l)
   la = 1 + (l - 1)*ka
   lb = 1 + (imin - 1)*kb
   go to 20
10 imin = 1
   la = 1 + (j - 1)*ka
   lb = 1
20 imax = min(j, m)
   dsum = 0.d0
   do i = imin,imax
      dsum = dsum + dble(a(la))*dble(b(lb))
      la = la - ka
      lb = lb + kb
   end do
   c(lc) = dsum
   lc = lc + kc
end do
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   c(lc) = 0.0
   lc = lc + kc
end do
end subroutine pmult

pure subroutine dpmult(a,ka,l,b,kb,m,c,kc,n)
!! <!-- nswc-ford:begin DPMULT -->
!! Reference for `dpmult`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Multiplication of double precision polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, imax, imin, j, jmax, jmin, la, lb, lc
double precision :: sum
!     ------------------------------------------------------------------
!     Multiplication of double precision polynomials
!     ------------------------------------------------------------------
lc = 1
jmax = min(l + m - 1, n)
do j = 1,jmax
   if (j <= l) go to 10
   imin = 1 + (j - l)
   la = 1 + (l - 1)*ka
   lb = 1 + (imin - 1)*kb
   go to 20
10 imin = 1
   la = 1 + (j - 1)*ka
   lb = 1
20 imax = min(j, m)
   sum = 0.d0
   do i = imin,imax
      sum = sum + a(la)*b(lb)
      la = la - ka
      lb = lb + kb
   end do
   c(lc) = sum
   lc = lc + kc
end do
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   c(lc) = 0.d0
   lc = lc + kc
end do
end subroutine dpmult

pure subroutine pdiv(a,ka,l,b,kb,m,c,kc,n,ierr)
!! <!-- nswc-ford:begin PDIV -->
!! Reference for `pdiv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Division of real polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, ib, ic, imax, j, la, lc
real :: b0
double precision :: dsum
!     ------------------------------------------------------------------
!     Division of real polynomials
!     ------------------------------------------------------------------
b0 = b(1)
if (b0 == 0.0) go to 100
ierr = 0
c(1) = a(1)/b0
if (n == 1) return
!               Case when m = 1
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
!              Case when m .GT. 1
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
!                Error return
100 ierr = 1
end subroutine pdiv

pure subroutine dpdiv(a,ka,l,b,kb,m,c,kc,n,ierr)
!! <!-- nswc-ford:begin DPDIV -->
!! Reference for `dpdiv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Division of double precision polynomials
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*)
!     beginning of local variable declarations
integer :: i, ib, ic, imax, j, la, lc
double precision :: b0, sum
!     ------------------------------------------------------------------
!     Division of double precision polynomials
!     ------------------------------------------------------------------
b0 = b(1)
if (b0 == 0.d0) go to 100
ierr = 0
c(1) = a(1)/b0
if (n == 1) return
!               Case when m = 1
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
!              Case when m .GT. 1
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
!                Error return
100 ierr = 1
end subroutine dpdiv

pure subroutine plpwr(r,a,ka,m,b,kb,n,ierr)
!! <!-- nswc-ford:begin PLPWR -->
!! Reference for `plpwr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      SET b = a**r WHERE A IS A REAL POLYNOMIAL
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: r
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
!     beginning of local variable declarations
integer :: i, ia, ib, imax, j, lb
real :: a0, jm1
double precision :: coeff, dsum, rp1
!     ------------------------------------------------------------------
!     SET b = a**r WHERE A IS A REAL POLYNOMIAL
!     ------------------------------------------------------------------
a0 = a(1)
if (a0 <= 0.0) go to 100
ierr = 0
b(1) = a0**r
if (n == 1) return
!            Case when m = 1 Or r = 0
if (m > 1 .and. r /= 0.0) go to 20
lb = 1
do j = 2,n
   lb = lb + kb
   b(lb) = 0.0
end do
return
!                  General case
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
!                Error return
100 ierr = 1
end subroutine plpwr

pure subroutine dplpwr(r,a,ka,m,b,kb,n,ierr)
!! <!-- nswc-ford:begin DPLPWR -->
!! Reference for `dplpwr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Set b = a**r where A is a double precision polynomial
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
double precision, intent(in) :: r
!     beginning of local variable declarations
integer :: i, ia, ib, imax, j, lb
double precision :: a0, coeff, jm1, rp1, sum
!     ------------------------------------------------------------------
!     Set b = a**r where A is a double precision polynomial
!     ------------------------------------------------------------------
a0 = a(1)
if (a0 <= 0.d0) go to 100
ierr = 0
b(1) = a0**r
if (n == 1) return
!            Case when m = 1 Or r = 0
if (m > 1 .and. r /= 0.d0) go to 20
lb = 1
do j = 2,n
   lb = lb + kb
   b(lb) = 0.d0
end do
return
!                  General case
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
!                Error return
100 ierr = 1
end subroutine dplpwr

pure subroutine pinv(a, d, n, q)
!! <!-- nswc-ford:begin PINV -->
!! Reference for `pinv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Computation of the inverse of the power series
!!                   sum (a(i)*X**i, i = 1,2,...)
!!
!!      num = (n*(n + 1))/2
!!      real q(num)
!!
!!                  Compute the coefficient matrix q
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: a(n)
real, intent(inout) :: d(n), q(*)
!     beginning of local variable declarations
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
!                 Compute the coefficient matrix q
q(1) = 1.0
k = 2
do i = 2,n
   q(k) = 0.0
   k = k + i
end do
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
!              Compute the coefficients of the inverse
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
end subroutine pinv

pure subroutine dpinv(a, d, n, q)
!! <!-- nswc-ford:begin DPINV -->
!! Reference for `dpinv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Computation of the inverse of the power series
!!                   sum (a(i)*X**i, i = 1,2,...)
!!
!!      num = (n*(n + 1))/2
!!      real q(num)
!!
!!                  Compute the coefficient matrix q
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
double precision, intent(in) :: a(n)
double precision, intent(inout) :: d(n), q(*)
!     beginning of local variable declarations
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
!                 Compute the coefficient matrix q
q(1) = 1.d0
k = 2
do i = 2,n
   q(k) = 0.d0
   k = k + i
end do
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
!              Compute the coefficients of the inverse
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
end subroutine dpinv

subroutine mplnmv(mo, au, nc, ac, fv)
!! <!-- nswc-ford:begin MPLNMV -->
!! Reference for `mplnmv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for multiplex polynomial evaluation
!!
!!      mo = Mode of operation
!!      au = ARGUMENT U
!!      nc = Number of coefficients
!!      ac = Array of coefficients
!!      fv = FUNCTION V
!!      mo = -1 For integral
!!      mo =  0 For function
!!      mo = +1 For first derivative
!!      mo = +2 For second derivative
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: mo, nc
real, intent(in) :: ac(*)
real, intent(in) :: au
real, intent(out) :: fv
!     beginning of local variable declarations
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
!     mo = -1 For integral
!     mo =  0 For function
!     mo = +1 For first derivative
!     mo = +2 For second derivative
fv = 0.0
l = nc
if (mo < 0) go to 002
if (mo == 0) go to 004
if (mo == 1) go to 006
if (mo >= 2) go to 008
002 ql = nc
do k = 1,nc
   fv = ac(l)/ql + au*fv
   l = l - 1
   ql = ql - 1.0
end do
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
end subroutine mplnmv

pure real function csevl(x, a, n)
!! <!-- nswc-ford:begin CSEVL -->
!! Reference for `csevl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Evaluate the n term Chebyshev series A at x.
!!           Only half of the first coefficient is used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
real, intent(in) :: x
real, intent(in) :: a(n)
!     beginning of local variable declarations
integer :: i, k
real :: s0, s1, s2, x2
!-----------------------------------------------------------------------
!          Evaluate the n term Chebyshev series A at x.
!          Only half of the first coefficient is used.
!-----------------------------------------------------------------------
if (n > 1) go to 10
csevl = 0.5 * a(1)
return
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
end function csevl

pure double precision function dcsevl(x, a, n)
!! <!-- nswc-ford:begin DCSEVL -->
!! Reference for `dcsevl`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Evaluate the n term Chebyshev series A at x.
!!           Only half of the first coefficient is used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
double precision, intent(in) :: a(n), x
!     beginning of local variable declarations
integer :: i, k
double precision :: x2, s0, s1, s2
!-----------------------------------------------------------------------
!          Evaluate the n term Chebyshev series A at x.
!          Only half of the first coefficient is used.
!-----------------------------------------------------------------------
if (n > 1) go to 10
dcsevl = 0.5d0 * a(1)
return
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
end function dcsevl

subroutine lgrngn(au, na, an)
!! <!-- nswc-ford:begin LGRNGN -->
!! Reference for `lgrngn`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for Lagrangian normalization factors
!!
!!      au = COORDINATE ARGUMENTS  (N-ARRAY)
!!      na = Number of arguments   (N)
!!      an = NORMALIZATION FACTORS (N-ARRAY)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: na
real, intent(inout) :: an(*)
real, intent(in) :: au(*)
!     beginning of local variable declarations
integer :: k, m
real :: dm, tm
!     ******************************************************************
!     Fortran subroutine for Lagrangian normalization factors
!     ******************************************************************
!     au = COORDINATE ARGUMENTS  (N-ARRAY)
!     na = Number of arguments   (N)
!     an = NORMALIZATION FACTORS (N-ARRAY)
do k = 1,na
   tm = 1.0
   do m = 1,na
      if (m == k) go to 002
      dm = au(k) - au(m)
      tm = dm*tm
002   continue
   end do
   an(k) = tm
end do
end subroutine lgrngn

subroutine lgrngv(mo, na, qu, au, an, ff, df, sf)
!! <!-- nswc-ford:begin LGRNGV -->
!! Reference for `lgrngv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for Lagrangian function evaluation
!!
!!      mo = Mode of operation
!!      na = Number of stations
!!      qu = Argument of functions
!!      au = STATION COORDINATES                    (N-ARRAY)
!!      an = NORMALIZATION FACTORS                  (N-ARRAY)
!!      ff = LAGRANGIAN FUNCTIONS                   (N-ARRAY)
!!      df = FIRST DERIVATIVES                      (N-ARRAY)
!!      sf = SECOND DERIVATIVES                     (N-ARRAY)
!!      call lgrngv (0, na, qu, au, an, ff)         for functions
!!      call lgrngv (1, na, qu, au, an, ff, df)     for first derivatives
!!      call lgrngv (2, na, qu, au, an, ff, df, sf) for second derivatives
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: mo, na
real, intent(in) :: an(*), au(*)
real, intent(inout) :: df(*), ff(*)
real, intent(in) :: qu
real, intent(inout) :: sf(*)
!     beginning of local variable declarations
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
!     call lgrngv (0, na, qu, au, an, ff)         for functions
!     call lgrngv (1, na, qu, au, an, ff, df)     for first derivatives
!     call lgrngv (2, na, qu, au, an, ff, df, sf) for second derivatives
ln = .true.
tm = 1.0
do k = 1,na
   if (qu /= au(k)) go to 002
   ln = .false.
   go to 003
002 dm = qu - au(k)
   tm = dm*tm
003 continue
end do
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
do k = 1,na
   df(k) = sm
   if (ln) go to 012
   if (qu == au(k)) go to 013
012 dm = qu - au(k)
   sm = sm + 1.0/dm
013 continue
end do
rm = sm
if (mo == 1) go to 040
sm = 0.0
do k = 1,na
   sf(k) = sm
   if (ln) go to 022
   if (qu == au(k)) go to 023
022 dm = qu - au(k)
   sm = sm + 2.0*df(k)/dm
023 continue
end do
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
do k = 1,na
   if (qu /= au(k)) go to 041
   df(k) = rm
   ff(k) = 1.0
   go to 042
041 df(k) = ff(k)
   ff(k) = 0.0
042 continue
end do
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
do k = 1,na
   ff(k) = 0.0
   if (qu /= au(k)) go to 052
   ff(k) = 1.0
052 continue
end do
053 return
end subroutine lgrngv

subroutine lgrngx(au, na, ac)
!! <!-- nswc-ford:begin LGRNGX -->
!! Reference for `lgrngx`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Fortran subroutine for Lagrangian polynomial expansion
!!
!!      au = COORDINATE ARGUMENTS    (N-ARRAY)
!!      na = Number of arguments     (N)
!!      ac = Polynomial coefficients (NX(N+1) array)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: na
real, intent(inout) :: ac(*)
real, intent(in) :: au(*)
!     beginning of local variable declarations
integer :: i, j, k, l
real :: sm, td, tm
!     ******************************************************************
!     Fortran subroutine for Lagrangian polynomial expansion
!     ******************************************************************
!     au = COORDINATE ARGUMENTS    (N-ARRAY)
!     na = Number of arguments     (N)
!     ac = Polynomial coefficients (NX(N+1) array)
do i = 1,na
   k = (i - 1)*na
   l = k + i
   ac(l) = 1.0
   sm = 0.0
   do j = 1,i
      k = k + 1
      l = k + na
      ac(l) = sm - au(i)*ac(k)
      sm = ac(k)
   end do
end do
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
   do j = 1,na
      if (j == i) go to 006
      td = au(i) - au(j)
      tm = tm*td
006   continue
   end do
   k = (i - 1)*na
   do j = 1,na
      k = k + 1
      ac(k) = ac(k)/tm
   end do
end do
end subroutine lgrngx

