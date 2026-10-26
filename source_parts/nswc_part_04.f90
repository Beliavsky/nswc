subroutine fxshfr(l2, nz, nn, p, qp, k, qk, svk)
implicit none
integer :: nn
double precision :: p(nn), qp(nn), k(nn), qk(nn), svk(nn)
integer :: l2, nz
integer :: n
double precision :: svu, svv, ui, vi, s
real :: betas, betav, oss, ovv, ss, vv, ts, tv, ots, otv, tvv, tss
integer :: type, i, j, iflag
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
      & tss .lt. tvv)) go to 40
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

subroutine quadit(uu, vv, nz, nn, p, qp, k, qk)
implicit none
integer :: nn
double precision :: uu, vv, p(nn), qp(nn), k(nn), qk(nn)
integer :: nz
integer :: n
double precision :: ui, vi
real :: mp, omp, ee, relstp, t, zm
integer :: type, i, j
logical :: tried
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
interface
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
end interface
!
!     Variable-shift k-polynomial iteration for A
!     quadratic factor converges only if the zeros are
!     equimodular or nearly so.
!
!     uu,vv - Coefficients of starting quadratic
!     nz - Number of zero found
!
!
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
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
   & return
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
   & (abs(sngl(a) + t) + abs(sngl(b))*zm) + &
   & 2.0*are*abs(t)
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
double precision :: sss, p(nn), qp(nn), k(nn), qk(nn)
integer :: i, j, n
double precision :: pv, kv, t, s
real :: ms, mp, omp, ee
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!
!     Variable-shift H polynomial iteration for a real zero.
!
!     sss   - Starting iterate
!     nz    - Number of zero found
!     iflag - Flag to indicate a pair of zeros near the real
!             axis.
!
!
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
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
ee = (mre/(are + mre))*abs(sngl(qp(1)))
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
if (dabs(t) .gt. 1.d-3*dabs(s - t) .or. mp .le. omp) &
   & go to 50
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
   k(i) = t*qk(i - 1) + qp(i)
end do
go to 100
!
!     Use unscaled form
!
80 k(1) = 0.0d0
do i = 2,n
   k(i) = qk(i - 1)
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
integer :: type
double precision :: k(n), qk(n)
double precision :: tol
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!
!     This routine calculates scalar quantities used to
!     compute the next k polynomial and new estimates of
!     the quadratic coefficients.
!
!     type - Integer variable SET here indicating how the
!            calculations are normalized to avoid overflow
!
!
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
!
!     Synthetic division of k by the quadratic 1,u,v
!
call quadsd(n, u, v, k, qk, c, d)
tol = 100.0*eta
if (dabs(c) .gt. tol*dabs(k(n))) go to 10
if (dabs(d) .gt. tol*dabs(k(n - 1))) go to 10
type = 3
!
!     type=3 Indicates the quadratic is almost a factor of k
!
return
10 if (dabs(d) .lt. dabs(c)) go to 20
type = 2
!
!     type=2 Indicates that all formulas are divided by d
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
!     type=1 Indicates that all formulas are divided by c
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
integer :: type
double precision :: qp(n), k(n), qk(n)
integer :: i
double precision :: temp
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!
!     Computes the next k polynomials using the scalars
!     computed in calcsc.
!
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
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
   k(i) = a3*qk(i - 2) - a7*qp(i - 1)
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
   k(i) = a3*qk(i - 2) - a7*qp(i - 1) + qp(i)
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
integer :: type
double precision :: uu, vv, p(nn), k(nn)
integer :: n
double precision :: a4, a5, b1, b2, c1, c2, c3, c4, temp
real :: eta, are, mre
double precision :: sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi
!
!     Compute new estimates of the quadratic coefficients
!     using the scalars computed in calcsc.
!
!
common /global/  sr, si, u, v, a, b, c, d, a1, a2, a3, a6, a7, &
   & e, f, g, h, szr, szi, lzr, lzi, eta, are, mre
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
!     If type=3 The quadratic is zeroed
!
30 uu = 0.d0
vv = 0.d0
return
end subroutine newest

pure subroutine quadsd (nn, u, v, p, q, a, b)
implicit none
integer, intent(in) :: nn
double precision, intent(in) :: p(nn)
double precision, intent(inout) :: q(nn)
double precision, intent(in) :: u, v
double precision, intent(out) :: a, b
integer :: i
double precision :: c
!
!     Divides p by the quadratic  1,u,v  placing the
!     quotient in q and the remainder in A,b.
!
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

pure elemental subroutine quadpl(a, b1, c, sr, si, lr, li)
implicit none
!
!     Calculate the zeros of the quadratic a*Z**2+b1*Z+c.
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
integer :: ideg
double precision, intent(in) :: opr(*), opi(*)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), wk(*)
integer :: idp1
integer :: pr, pi, qpr, qpi, hr, hi, qhr, qhi, shr, shi
!
!     This subroutine finds the zeros of a complex polynomial.
!
!     opr,opi     - DOUBLE PRECISION ARRAYS OF LENGTH ideg + 1.
!                   On input these arrays contain the real and imaginary
!                   parts of the coefficients in order of decreasing
!                   powers.
!
!     ideg        - Integer degree of the polynomial.
!
!     zeror,zeroi - Double precision arrays of length ideg.
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
!     wk          - Double precision array of length 10*(ideg + 1).
!                   The array is a work space for the routine.
!
!     The code has been written to reduce the chance of overflow
!     occurring. If it does occur, there is still a possibility that
!     the zerofinder will work provided the overflowed quantity is
!     replaced by a large number.
!
!
!
if (ideg .lt. 1) go to 10
!
!     Partition the workspace and obtain the zeros
!
idp1 = ideg + 1
!
pr = 1
pi = pr + idp1
qpr = pi + idp1
qpi = qpr + idp1
hr = qpi + idp1
hi = hr + idp1
qhr = hi + idp1
qhi = qhr + idp1
shr = qhi + idp1
shi = shr + idp1
!
call dcply1 (opr,opi,ideg,idp1,zeror,zeroi,wk(pr),wk(pi), &
   & wk(qpr),wk(qpi),wk(hr),wk(hi),wk(qhr),wk(qhi), &
   & wk(shr),wk(shi),num)
return
!
!     Error return
!
10 num = -1
return
end subroutine dcpoly

subroutine dcply1 (opr,opi,ideg,idp1,zeror,zeroi,pr,pi,qpr,qpi, &
   & hr,hi,qhr,qhi,shr,shi,num)
implicit none
integer :: ideg
integer, intent(in) :: idp1
integer, intent(out) :: num
double precision, intent(in) :: opr(idp1), opi(idp1)
double precision, intent(inout) :: zeror(ideg), zeroi(ideg), &
   & pr(idp1), pi(idp1), qpr(idp1), qpi(idp1), hr(idp1), hi(idp1), &
   & qhr(idp1), qhi(idp1), shr(idp1), shi(idp1)
integer :: i, nn
double precision :: sr, si, tr, ti, pvr, pvi, are, mre, eta, infin
double precision :: xx, yy, cosr, sinr, smalno, base, xxx, zr, zi, bnd, scalcp
logical :: conv
integer :: cnt1, cnt2
interface
   pure elemental subroutine cdivid(ar,ai,br,bi,cr,ci)
      implicit none
      double precision, intent(in) :: ar
      double precision, intent(in) :: ai
      double precision, intent(in) :: br
      double precision, intent(in) :: bi
      double precision, intent(inout) :: cr
      double precision, intent(inout) :: ci
   end subroutine cdivid
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
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
end interface
!-------------------------
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
   & zeroi(ideg))
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
         & qhr,qhi,shr,shi,sr,si,tr,ti,pvr,pvi, &
         & are,mre,eta,infin)
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

pure double precision function scalcp(nn,pt,eta,infin,smalno,base)
implicit none
integer, intent(in) :: nn
double precision, intent(in) :: pt(nn), eta, infin, smalno, base
integer :: i, l
double precision :: hi, lo, max, min, x, sc
!
!     Returns a scale factor to multiply the coefficients of the
!     polynomial. The scaling is done to avoid overflow and to avoid
!     undetected underflow interfering with the convergence criterion.
!     The factor is a power of the base.
!
!     pt - Modulus of the coefficients of P
!     eta,infin,smalno,base - Constants describing the
!            floating point arithmetic.
!
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

pure subroutine cauchy(nn,bnd,pt,q)
implicit none
integer, intent(in) :: nn
double precision, intent(inout) :: q(nn), pt(nn)
double precision, intent(inout) :: bnd
integer :: i, n
double precision :: x, xm, f, dx, df
!
!     Cauchy computes a lower bound bnd on the moduli of the zeros
!     of a polynomial. pt is the modulus of the coefficients.
!
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
!     Chop the interval (0,x) until f .LE. 0.
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

pure subroutine noshft(l1,nn,tr,ti,eta,pr,pi,hr,hi)
implicit none
integer, intent(in) :: l1, nn
double precision, intent(inout) :: tr, ti
double precision, intent(in) :: eta, pr(nn), pi(nn)
double precision, intent(inout) :: hr(nn), hi(nn)
integer :: i, j, jj, n, nm1
double precision :: dn, t1, t2, xni
interface
   pure elemental subroutine cdivid(ar,ai,br,bi,cr,ci)
      implicit none
      double precision, intent(in) :: ar
      double precision, intent(in) :: ai
      double precision, intent(in) :: br
      double precision, intent(in) :: bi
      double precision, intent(inout) :: cr
      double precision, intent(inout) :: ci
   end subroutine cdivid
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
end interface
!
!     Computes the derivative polynomial as the initial H
!     polynomial and computes l1 no-shift H polynomials.
!
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
      & go to 30
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

pure subroutine fxshft(l2,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi, &
   & qhr,qhi,shr,shi,sr,si,tr,ti,pvr,pvi, &
   & are,mre,eta,infin)
implicit none
integer, intent(in) :: l2, nn
double precision, intent(inout) :: sr, si, tr, ti, pvr, pvi
double precision, intent(in) :: are, mre, eta, infin, pr(nn), &
   & pi(nn)
double precision, intent(inout) :: qpr(nn), qpi(nn), hr(nn), &
   & hi(nn), qhr(nn), qhi(nn), shr(nn), shi(nn)
double precision, intent(inout) :: zr, zi
logical, intent(inout) :: conv
integer :: i, j, n
double precision :: otr, oti, svsr, svsi
logical :: test, pasd, bool
interface
   pure subroutine calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr, &
      & qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(inout) :: bool
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(inout) :: tr
      double precision, intent(inout) :: ti
      double precision, intent(in) :: pvr
      double precision, intent(in) :: pvi
      double precision, intent(in) :: are
      double precision, intent(in) :: hr(n)
      double precision, intent(in) :: hi(n)
      double precision, intent(inout) :: qhr(n)
      double precision, intent(inout) :: qhi(n)
   end subroutine calct
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(in) :: bool
      double precision, intent(in) :: tr
      double precision, intent(in) :: ti
      double precision, intent(inout) :: hr(n)
      double precision, intent(inout) :: hi(n)
      double precision, intent(in) :: qpr(n)
      double precision, intent(in) :: qpi(n)
      double precision, intent(in) :: qhr(n)
      double precision, intent(in) :: qhi(n)
   end subroutine nexth
   pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(in) :: pr(n)
      double precision, intent(in) :: pi(n)
      double precision, intent(inout) :: qr(n)
      double precision, intent(inout) :: qi(n)
      double precision, intent(out) :: pvr
      double precision, intent(out) :: pvi
   end subroutine polyev
   pure subroutine vrshft(l3,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr, &
      & qhi,sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
      implicit none
      integer, intent(in) :: nn
      integer, intent(in) :: l3
      double precision, intent(inout) :: zr
      double precision, intent(inout) :: zi
      logical, intent(out) :: conv
      double precision, intent(in) :: pr(nn)
      double precision, intent(in) :: pi(nn)
      double precision, intent(inout) :: hr(nn)
      double precision, intent(inout) :: hi(nn)
      double precision, intent(inout) :: qpr(nn)
      double precision, intent(inout) :: qpi(nn)
      double precision, intent(inout) :: qhr(nn)
      double precision, intent(inout) :: qhi(nn)
      double precision, intent(out) :: sr
      double precision, intent(out) :: si
      double precision, intent(inout) :: tr
      double precision, intent(inout) :: ti
      double precision, intent(inout) :: pvr
      double precision, intent(inout) :: pvi
      double precision, intent(in) :: are
      double precision, intent(in) :: mre
      double precision, intent(in) :: eta
      double precision, intent(in) :: infin
   end subroutine vrshft
end interface
!
!     Computes l2 fixed-shift H polynomials and tests for convergence.
!     Initiates a variable-shift iteration and returns with the
!     approximate zero if successful.
!
!     l2 - Limit of fixed-shift steps
!     zr,zi - Approximate zero if conv is .TRUE.
!     conv - Logical variable indicating convergence of stage 3
!            iteration
!
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
      & go to 40
   if (.not. pasd) go to 30
!
!     The weak convergence test has been passed twice. Start the
!     third shift iteration after saving the current H polynomial
!     and shift.
!
   do 10 i = 1,n
      shr(i) = hr(i)
      shi(i) = hi(i)
10    continue
   svsr = sr
   svsi = si
   call vrshft(10,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr, &
      & qhi,sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
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
   & sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
return
end subroutine fxshft

pure subroutine vrshft(l3,zr,zi,conv,nn,pr,pi,hr,hi,qpr,qpi,qhr,qhi, &
   & sr,si,tr,ti,pvr,pvi,are,mre,eta,infin)
implicit none
integer, intent(in) :: l3, nn
double precision, intent(out) :: sr, si
double precision, intent(inout) :: tr, ti, pvr, pvi
double precision, intent(in) :: are, mre, eta, infin, pr(nn), &
   & pi(nn)
double precision, intent(inout) :: qpr(nn), qpi(nn), hr(nn), &
   & hi(nn), qhr(nn), qhi(nn)
double precision, intent(inout) :: zr, zi
logical, intent(out) :: conv
integer :: i, j, n
double precision :: mp, ms, omp, relstp, r1, r2, tp
logical :: b, bool
interface
   pure subroutine calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr, &
      & qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(inout) :: bool
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(inout) :: tr
      double precision, intent(inout) :: ti
      double precision, intent(in) :: pvr
      double precision, intent(in) :: pvi
      double precision, intent(in) :: are
      double precision, intent(in) :: hr(n)
      double precision, intent(in) :: hi(n)
      double precision, intent(inout) :: qhr(n)
      double precision, intent(inout) :: qhi(n)
   end subroutine calct
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure function errev(nn,qr,qi,ms,mp,are,mre)
      implicit none
      integer, intent(in) :: nn
      double precision, intent(in) :: qr(nn)
      double precision, intent(in) :: qi(nn)
      double precision, intent(in) :: ms
      double precision, intent(in) :: mp
      double precision, intent(in) :: are
      double precision, intent(in) :: mre
      double precision :: errev
   end function errev
   pure subroutine nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
      implicit none
      integer, intent(in) :: n
      logical, intent(in) :: bool
      double precision, intent(in) :: tr
      double precision, intent(in) :: ti
      double precision, intent(inout) :: hr(n)
      double precision, intent(inout) :: hi(n)
      double precision, intent(in) :: qpr(n)
      double precision, intent(in) :: qpi(n)
      double precision, intent(in) :: qhr(n)
      double precision, intent(in) :: qhi(n)
   end subroutine nexth
   pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(in) :: pr(n)
      double precision, intent(in) :: pi(n)
      double precision, intent(inout) :: qr(n)
      double precision, intent(inout) :: qi(n)
      double precision, intent(out) :: pvr
      double precision, intent(out) :: pvi
   end subroutine polyev
end interface
!
!     Carries out the third stage iteration.
!
!     l3 - Limit of steps in stage 3.
!     zr,zi - On entry contain the initial iterate. If the
!             iteration converges zr,zi contain the final
!             iterate on exit.
!     conv  - The value is .TRUE. if the iteration converges.
!
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
      & go to 10
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
      & go to 30
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
20    continue
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

pure subroutine calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
implicit none
integer, intent(in) :: n
logical, intent(inout) :: bool
double precision, intent(in) :: sr, si
double precision, intent(inout) :: tr, ti
double precision, intent(in) :: pvr, pvi, are, hr(n), hi(n)
double precision, intent(inout) :: qhr(n), qhi(n)
double precision :: hvr, hvi
interface
   pure elemental subroutine cdivid(ar,ai,br,bi,cr,ci)
      implicit none
      double precision, intent(in) :: ar
      double precision, intent(in) :: ai
      double precision, intent(in) :: br
      double precision, intent(in) :: bi
      double precision, intent(inout) :: cr
      double precision, intent(inout) :: ci
   end subroutine cdivid
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: sr
      double precision, intent(in) :: si
      double precision, intent(in) :: pr(n)
      double precision, intent(in) :: pi(n)
      double precision, intent(inout) :: qr(n)
      double precision, intent(inout) :: qi(n)
      double precision, intent(out) :: pvr
      double precision, intent(out) :: pvi
   end subroutine polyev
end interface
!
!     This subroutine computes T = -P(S)/H(S)
!
!     bool - Logical variable, which is set to .TRUE. if H(S) is
!            essentially zero.
!
!
!     Evaluate H(S)
!
call polyev (n,sr,si,hr,hi,qhr,qhi,hvr,hvi)
bool = dcpabs(hvr,hvi) .le. 10.d0*are*dcpabs(hr(n),hi(n))
if (bool) go to 10
call cdivid(-pvr,-pvi,hvr,hvi,tr,ti)
return
10 tr = 0.d0
ti = 0.d0
return
end subroutine calct

pure subroutine nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
implicit none
integer, intent(in) :: n
logical, intent(in) :: bool
double precision, intent(in) :: tr, ti
double precision, intent(inout) :: hr(n), hi(n)
double precision, intent(in) :: qpr(n), qpi(n), qhr(n), qhi(n)
integer :: j
double precision :: t1, t2
!
!     Calculates the next shifted H polynomial.
!
!     bool - Logical variable. If .TRUE. H(S) is essentially zero.
!
!
if (bool) go to 20
do j = 2,n
   t1 = qhr(j - 1)
   t2 = qhi(j - 1)
   hr(j) = tr*t1 - ti*t2 + qpr(j)
   hi(j) = tr*t2 + ti*t1 + qpi(j)
end do
hr(1) = qpr(1)
hi(1) = qpi(1)
return
!
!     If H(S) is zero then replace H with QH.
!
20 do j = 2,n
   hr(j) = qhr(j - 1)
   hi(j) = qhi(j - 1)
end do
hr(1) = 0.d0
hi(1) = 0.d0
return
end subroutine nexth

pure subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: pr(n), pi(n)
double precision, intent(inout) :: qr(n), qi(n)
double precision, intent(in) :: sr, si
double precision, intent(out) :: pvr, pvi
integer :: i
double precision :: t
!
!     Evaluates a polynomial P at S by the Horner recurrence algo.,
!     placing the partial sums in Q and the computed value in PV.
!
!
qr(1) = pr(1)
qi(1) = pi(1)
pvr = qr(1)
pvi = qi(1)
do i = 2,n
   t = pvr*sr - pvi*si + pr(i)
   pvi = pvr*si + pvi*sr + pi(i)
   pvr = t
   qr(i) = pvr
   qi(i) = pvi
end do
return
end subroutine polyev

pure double precision function errev(nn,qr,qi,ms,mp,are,mre)
implicit none
integer, intent(in) :: nn
double precision, intent(in) :: qr(nn), qi(nn), ms, mp, are, mre
integer :: i
double precision :: e
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
end interface
!
!     Bounds the error in evaluating the polynomial by the Horner
!     recurrence algorithm.
!
!     QR,qi   - THE PARTIAL SUMS
!     ms      - Modulus of the point
!     mp      - Modulus of the polynomial value
!     are,mre - Error bounds on complex addition and multiplication
!
!
e = dcpabs(qr(1),qi(1))*mre/(are + mre)
do i = 1,nn
   e = e*ms + dcpabs(qr(i),qi(i))
end do
errev = e*(are + mre) - mp*mre
return
end function errev

pure subroutine rbnd (n, c, w, abserr, relerr, klust, ker)
implicit none
integer, intent(inout) :: ker
integer, intent(in) :: n
complex, intent(in) :: w(n)
integer, intent(inout) :: klust(n)
real, intent(in) :: c(*)
real, intent(inout) :: abserr(n), relerr(n)
integer :: j, jp1, k, l, m, nm1, np1
real :: b, cert, dist, eps, olderr, p, power, r, rat, wnrm, wrad
complex :: z
double precision :: xr, xi, vr, vi, vt
logical :: shrunk
interface
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!     Abstract
!
!         This routine computes error bounds and cluster counts
!         for approximate zeros of a polynomial with real coefficients.
!         The zeros may have been computed by any appropriate routine.
!         The method used is based on the fact that the value of A
!         polynomial at any point is equal to the leading coefficient
!         times the product of the distances from that point to each
!         of the zeros.  Given the value of the polynomial at an
!         approximate zero, rbnd computes for each approximate zero
!         the radius of a circle about that approximate zero which
!         contains a true zero of the polynomial.  Using the known
!         distribution of approximate zeros, an iterative procedure
!         is used to shrink the radii of the circles.
!
!     Description of arguments
!
!         Input---
!
!         n      - Degree of the polynomial (number of zeros).
!         c      - Real array of n+1 coefficients of the polynomial
!                  c(1) + c(2)*z + ... + c(n+1)*z**n
!         w      - Complex array of n approximate zeros.
!
!         Output--
!
!         abserr - Real array of n absolute error bounds.  abserr(I) is
!                  the absolute error bound in the zero (WR(I),WI(I)).
!         relerr - Real array of n relative error bounds.  relerr(I) is
!                  the relative error bound in the zero (WR(I),WI(I)).
!         klust  - Integer array of cluster counts for zeros.  The true
!                  zero corresponding to I-TH approximate zero lies in
!                  a circle of radius abserr(I). klust(I) is the number
!                  of circles including the I-TH circle which overlap
!                  the I-TH circle.  The cluster count often indicates
!                  the multiplicity of a zero.
!         ker    - An error flag
!                --normal code
!                  0  means the bounds and counts were computed.
!                --Abnormal codes
!                  1  n (DEGREE) must be .GE. 1
!                  2  leading coefficient is zero
!
!-------------------
!     Written by carl b. bailey and modified by william r. gavin
!        Sandia Laboratories
!        albuquerque, new mexico
!        January 1976
!     modified by A.H. Morris (NSWC)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-----------------------------------------------------------------------
if (n .lt. 1) go to 200
np1 = n + 1
power = 1.0/float(n)
p = abs(c(np1))
if (p .eq. 0.0) go to 210
rat = 4.0*eps*abs(c(1))/p
!
do l = 1,n
   xr = real(w(l))
   xi = aimag(w(l))
   vr = c(np1)
   vi = 0.0d0
   do j = 1,n
      m = np1 - j
      vt = xr*vr - xi*vi + dble(c(m))
      vi = xr*vi + xi*vr
      vr = vt
   end do
   b = amax1(rat,cpabs(sngl(vr),sngl(vi))/p)
!
!        Save product of distances temporarily
!
   relerr(l) = b
   abserr(l) = b ** power
end do
!
30 shrunk = .false.
do 50 j = 1,n
   if (abserr(j) .eq. 0.0) go to 50
   p = 1.0
   m = n
   do 40 k = 1,n
      if (k .eq. j) go to 40
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      cert = dist - abserr(k)
      if (cert .lt. abserr(j)) go to 40
      p = p*cert
      m = m - 1
40    continue
   olderr = abserr(j)
   abserr(j) = relerr(j)/p
   if (m .gt. 1) abserr(j) = abserr(j)**(1.0/float(m))
   if (abserr(j) .lt. olderr*0.99) shrunk = .true.
50 continue
if (shrunk) go to 30
!
do 80 j = 1,n
   klust(j) = 1
   wrad = abserr(j)
   wnrm = cpabs(real(w(j)),aimag(w(j)))
   if (wrad .ne. 0.0) go to 60
   r = 0.0
   go to 80
60 if (wnrm .ne. 0.0) go to 70
   r = -1.0
   go to 80
70 r = wrad/wnrm
80 relerr(j) = r
!
nm1 = n - 1
do j = 1,nm1
   jp1 = j + 1
   do 90 k = jp1,n
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      if (dist .gt. (abserr(j) + abserr(k))) go to 90
      klust(j) = klust(j) + 1
      klust(k) = klust(k) + 1
90    continue
end do
ker = 0
return
!
!             Error return
!
200 ker = 1
return
210 ker = 2
return
end subroutine rbnd

pure subroutine cbnd (n, c, w, abserr, relerr, klust, ker)
implicit none
integer, intent(inout) :: ker
integer, intent(in) :: n
complex, intent(in) :: c(*), w(n)
integer, intent(inout) :: klust(n)
real, intent(inout) :: abserr(n), relerr(n)
integer :: j, jp1, k, l, m, nm1, np1
real :: b, cert, dist, eps, olderr, p, power, r, rat, wnrm, wrad
complex :: z
double precision :: xr, xi, vr, vi, vt
logical :: shrunk
interface
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!
!     Abstract
!
!         This routine computes error bounds and cluster counts for
!         approximate zeros of a polynomial with complex coefficients.
!         The zeros may have been computed by any appropriate routine.
!         The method used is based on the fact that the value of A
!         polynomial at any point is equal to the leading coefficient
!         times the product of the distances from that point to each
!         of the zeros.  Given the value of the polynomial at an
!         approximate zero, cbnd computes for each approximate zero
!         the radius of a circle about that approximate zero which
!         contains a true zero of the polynomial.  Using the known
!         distribution of approximate zeros, an iterative procedure
!         is used to shrink the radii of the circles.
!
!     Description of arguments
!
!         Input---
!
!         n      - Degree of the polynomial (number of zeros).
!         c      - Complex array of n+1 coefficients of the polynomial
!                  c(1) + c(2)*z + ... + c(n+1)*z**n
!         w      - Complex array of n approximate zeros.
!
!         Output--
!
!         abserr - Real array of absolute error bounds.  abserr(I) is
!                  the absolute error bound in the zero (WR(I),WI(I)).
!         relerr - Real array of relative error bounds.  relerr(I) is
!                  the relative error bound in the zero (WR(I),WI(I)).
!         klust  - Integer array of cluster counts for zeros.  The true
!                  zero corresponding to I-TH approximate zero lies in
!                  a circle of radius abserr(I).  klust(I) is the number
!                  of circles including the I-TH circle which overlap
!                  the I-TH circle.  The cluster count often indicates
!                  the multiplicity of a zero.
!         ker    - An error code
!                --normal codes
!                  0  means the bounds and counts were computed.
!                --Abnormal codes
!                  1  n (DEGREE) must be .GE. 1
!                  2  leading coefficient is zero
!
!-------------------
!     Written by carl b. bailey and modified by william r. gavin
!        Sandia Laboratories
!        albuquerque, new mexico
!        January 1976
!     modified by A.H. Morris (NSWC)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!
!-----------------------------------------------------------------------
if (n .lt. 1) go to 200
np1 = n + 1
power = 1.0/float(n)
p = cpabs(real(c(np1)),aimag(c(np1)))
if (p .eq. 0.0) go to 210
rat = 4.0*eps*cpabs(real(c(1)),aimag(c(1)))/p
!
do l = 1,n
   xr = real(w(l))
   xi = aimag(w(l))
   vr = real(c(np1))
   vi = aimag(c(np1))
   do j = 1,n
      m = np1 - j
      vt = xr*vr - xi*vi + dble(real(c(m)))
      vi = xr*vi + xi*vr + dble(aimag(c(m)))
      vr = vt
   end do
   b = amax1(rat,cpabs(sngl(vr),sngl(vi))/p)
!
!        Save product of distances temporarily
!
   relerr(l) = b
   abserr(l) = b ** power
end do
!
30 shrunk = .false.
do 50 j = 1,n
   if (abserr(j) .eq. 0.0) go to 50
   p = 1.0
   m = n
   do 40 k = 1,n
      if (k .eq. j) go to 40
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      cert = dist - abserr(k)
      if (cert .lt. abserr(j)) go to 40
      p = p*cert
      m = m - 1
40    continue
   olderr = abserr(j)
   abserr(j) = relerr(j)/p
   if (m .gt. 1) abserr(j) = abserr(j)**(1.0/float(m))
   if (abserr(j) .lt. olderr*0.99) shrunk = .true.
50 continue
if (shrunk) go to 30
!
do 80 j = 1,n
   klust(j) = 1
   wrad = abserr(j)
   wnrm = cpabs(real(w(j)),aimag(w(j)))
   if (wrad .ne. 0.0) go to 60
   r = 0.0
   go to 80
60 if (wnrm .ne. 0.0) go to 70
   r = -1.0
   go to 80
70 r = wrad/wnrm
80 relerr(j) = r
!
nm1 = n - 1
do j = 1,nm1
   jp1 = j + 1
   do 90 k = jp1,n
      z = w(j) - w(k)
      dist = cpabs(real(z),aimag(z))
      if (dist .gt. (abserr(j) + abserr(k))) go to 90
      klust(j) = klust(j) + 1
      klust(k) = klust(k) + 1
90    continue
end do
ker = 0
return
!
!             Error return
!
200 ker = 1
return
210 ker = 2
return
end subroutine cbnd

pure subroutine  scopy(n,sx,incx,sy,incy)
implicit none
!
!     Copies a vector, X, to a vector, Y.
!     Uses unrolled loops for increments equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
real, intent(inout) :: sy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
integer :: i
integer :: ix, iy, m, mp1
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   sy(iy) = sx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!
!        Code for both increments equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,7)
if ( m .eq. 0 ) go to 40
do i = 1,m
   sy(i) = sx(i)
end do
if ( n .lt. 7 ) return
40 mp1 = m + 1
do i = mp1,n,7
   sy(i) = sx(i)
   sy(i + 1) = sx(i + 1)
   sy(i + 2) = sx(i + 2)
   sy(i + 3) = sx(i + 3)
   sy(i + 4) = sx(i + 4)
   sy(i + 5) = sx(i + 5)
   sy(i + 6) = sx(i + 6)
end do
return
end subroutine scopy

pure subroutine  dcopy(n,dx,incx,dy,incy)
implicit none
!
!     Copies a vector, X, to a vector, Y.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
double precision, intent(inout) :: dy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
integer :: i
integer :: ix, iy, m, mp1
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   dy(iy) = dx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!
!        Code for both increments equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,7)
if ( m .eq. 0 ) go to 40
do i = 1,m
   dy(i) = dx(i)
end do
if ( n .lt. 7 ) return
40 mp1 = m + 1
do i = mp1,n,7
   dy(i) = dx(i)
   dy(i + 1) = dx(i + 1)
   dy(i + 2) = dx(i + 2)
   dy(i + 3) = dx(i + 3)
   dy(i + 4) = dx(i + 4)
   dy(i + 5) = dx(i + 5)
   dy(i + 6) = dx(i + 6)
end do
return
end subroutine dcopy

pure subroutine  ccopy(n,cx,incx,cy,incy)
implicit none
!
!     Copies a vector, X, to a vector, Y.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*)
complex, intent(inout) :: cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
integer :: i
integer :: ix, iy
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   cy(iy) = cx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!
!        Code for both increments equal to 1
!
20 do i = 1,n
   cy(i) = cx(i)
end do
return
end subroutine ccopy

pure subroutine iswap (n,ix,incx,iy,incy)
implicit none
integer, intent(in) :: incx, incy, n
integer, intent(inout) :: ix(*), iy(*)
integer :: i, iix, iiy, m, mp1, ns
integer :: itemp1, itemp2, itemp3
!
!                Extended B L A S  subprogram
!
!    Description of parameters
!
!     --Input--
!        n  number of elements in input vector(S)
!       ix  integer vector with n elements
!     incx  storage spacing between elements of ix
!       iy  integer vector with n elements
!     incy  storage spacing between elements of iy
!
!     --Output--
!       ix  INPUT VECTOR iy (UNCHANGED IF n .LE. 0)
!       iy  INPUT VECTOR ix (UNCHANGED IF n .LE. 0)
!
!     Interchange integer ix and integer iy.
!     For i = 0 To n-1, interchange  ix(LX+i*incx) and iy(LY+i*incy),
!     WHERE LX = 1 IF incx .GE. 0, ELSE LX = (-incx)*n, AND LY IS
!     defined in a similar way using incy.
!
!***AUTHOR  VANDEVENDER, W. (SNLA), 1985
!
!
if (n .le. 0) return
if (incx .ne. incy) go to 5
if (incx - 1) 5,20,60
5 continue
!
!       Code for unequal or nonpositive increments.
!
iix = 1
iiy = 1
if (incx .lt. 0) iix = (1 - n)*incx + 1
if (incy .lt. 0) iiy = (1 - n)*incy + 1
do i = 1,n
   itemp1 = ix(iix)
   ix(iix) = iy(iiy)
   iy(iiy) = itemp1
   iix = iix + incx
   iiy = iiy + incy
end do
return
!
!       Code for both increments equal to 1
!
!
!       Clean-up loop so remaining vector LENGTH is a multiple of 3.
!
20 m = mod(n,3)
if (m .eq. 0) go to 40
do i = 1,m
   itemp1 = ix(i)
   ix(i) = iy(i)
   iy(i) = itemp1
end do
if (n .lt. 3) return
!
40 mp1 = m + 1
do i = mp1,n,3
   itemp1 = ix(i)
   itemp2 = ix(i + 1)
   itemp3 = ix(i + 2)
   ix(i) = iy(i)
   ix(i + 1) = iy(i + 1)
   ix(i + 2) = iy(i + 2)
   iy(i) = itemp1
   iy(i + 1) = itemp2
   iy(i + 2) = itemp3
end do
return
!
!     Code for equal, positive, nonunit increments.
!
60 ns = n*incx
do i = 1,ns,incx
   itemp1 = ix(i)
   ix(i) = iy(i)
   iy(i) = itemp1
end do
return
end subroutine iswap

pure subroutine  sswap (n,sx,incx,sy,incy)
implicit none
!
!     Interchanges two vectors.
!     Uses unrolled loops for increments equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(inout) :: sx(*), sy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
real :: stemp
integer :: i
integer :: ix, iy, m, mp1
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   stemp = sx(ix)
   sx(ix) = sy(iy)
   sy(iy) = stemp
   ix = ix + incx
   iy = iy + incy
end do
return
!
!       Code for both increments equal to 1
!
!
!       Clean-up loop
!
20 m = mod(n,3)
if ( m .eq. 0 ) go to 40
do i = 1,m
   stemp = sx(i)
   sx(i) = sy(i)
   sy(i) = stemp
end do
if ( n .lt. 3 ) return
40 mp1 = m + 1
do i = mp1,n,3
   stemp = sx(i)
   sx(i) = sy(i)
   sy(i) = stemp
   stemp = sx(i + 1)
   sx(i + 1) = sy(i + 1)
   sy(i + 1) = stemp
   stemp = sx(i + 2)
   sx(i + 2) = sy(i + 2)
   sy(i + 2) = stemp
end do
return
end subroutine sswap

pure subroutine  dswap (n,dx,incx,dy,incy)
implicit none
!
!     Interchanges two vectors.
!     Uses unrolled loops for increments equal one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(inout) :: dx(*), dy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
double precision :: dtemp
integer :: i
integer :: ix, iy, m, mp1
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   dtemp = dx(ix)
   dx(ix) = dy(iy)
   dy(iy) = dtemp
   ix = ix + incx
   iy = iy + incy
end do
return
!
!       Code for both increments equal to 1
!
!
!       Clean-up loop
!
20 m = mod(n,3)
if ( m .eq. 0 ) go to 40
do i = 1,m
   dtemp = dx(i)
   dx(i) = dy(i)
   dy(i) = dtemp
end do
if ( n .lt. 3 ) return
40 mp1 = m + 1
do i = mp1,n,3
   dtemp = dx(i)
   dx(i) = dy(i)
   dy(i) = dtemp
   dtemp = dx(i + 1)
   dx(i + 1) = dy(i + 1)
   dy(i + 1) = dtemp
   dtemp = dx(i + 2)
   dx(i + 2) = dy(i + 2)
   dy(i + 2) = dtemp
end do
return
end subroutine dswap

pure subroutine  cswap (n,cx,incx,cy,incy)
implicit none
!
!     Interchanges two vectors.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(inout) :: cx(*), cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
complex :: ctemp
integer :: i
integer :: ix, iy
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = cx(ix)
   cx(ix) = cy(iy)
   cy(iy) = ctemp
   ix = ix + incx
   iy = iy + incy
end do
return
!
!       Code for both increments equal to 1
20 do i = 1,n
   ctemp = cx(i)
   cx(i) = cy(i)
   cy(i) = ctemp
end do
return
end subroutine cswap

pure subroutine  srot (n,sx,incx,sy,incy,c,s)
implicit none
!
!     Applies a plane rotation.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(inout) :: sx(*), sy(*)
real, intent(in) :: c, s
integer, intent(in) :: incx, incy
integer, intent(in) :: n
real :: stemp
integer :: i
integer :: ix, iy
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   stemp = c*sx(ix) + s*sy(iy)
   sy(iy) = c*sy(iy) - s*sx(ix)
   sx(ix) = stemp
   ix = ix + incx
   iy = iy + incy
end do
return
!
!       Code for both increments equal to 1
!
20 do i = 1,n
   stemp = c*sx(i) + s*sy(i)
   sy(i) = c*sy(i) - s*sx(i)
   sx(i) = stemp
end do
return
end subroutine srot

pure subroutine  drot (n,dx,incx,dy,incy,c,s)
implicit none
!
!     Applies a plane rotation.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(inout) :: dx(*), dy(*)
double precision, intent(in) :: c, s
integer, intent(in) :: incx, incy
integer, intent(in) :: n
double precision :: dtemp
integer :: i
integer :: ix, iy
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   dtemp = c*dx(ix) + s*dy(iy)
   dy(iy) = c*dy(iy) - s*dx(ix)
   dx(ix) = dtemp
   ix = ix + incx
   iy = iy + incy
end do
return
!
!       Code for both increments equal to 1
!
20 do i = 1,n
   dtemp = c*dx(i) + s*dy(i)
   dy(i) = c*dy(i) - s*dx(i)
   dx(i) = dtemp
end do
return
end subroutine drot

pure subroutine  csrot (n,cx,incx,cy,incy,c,s)
implicit none
!
!     Applies a plane rotation, where the cos and sin (c and s) are real
!     and the vectors cx and cy are complex.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(inout) :: cx(*), cy(*)
real, intent(in) :: c, s
integer, intent(in) :: incx, incy
integer, intent(in) :: n
complex :: ctemp
integer :: i
integer :: ix, iy
!
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = c*cx(ix) + s*cy(iy)
   cy(iy) = c*cy(iy) - s*cx(ix)
   cx(ix) = ctemp
   ix = ix + incx
   iy = iy + incy
end do
return
!
!       Code for both increments equal to 1
!
20 do i = 1,n
   ctemp = c*cx(i) + s*cy(i)
   cy(i) = c*cy(i) - s*cx(i)
   cx(i) = ctemp
end do
return
end subroutine csrot

pure subroutine srotmg (sd1,sd2,sx1,sy1,sparam)
implicit none
real, intent(inout) :: sd1, sd2, sparam(5), sx1
real, intent(in) :: sy1
real :: sflag, sh11, sh12, sh21, sh22, sp1, sp2, sq1, sq2, stemp, su
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
real, parameter :: two = 2.e0
real, parameter :: gam = 4096.e0
real, parameter :: gamsq = 1.67772e7
real, parameter :: rgamsq = 5.96046e-8
!
!     Construct the modified Givens transformation matrix H which zeros
!     the second component of the 2-vector  (sqrt(sd1)*sx1,sqrt(sd2)*
!     sy1)**T.
!     With sparam(1)=sflag, H has one of the following forms..
!
!     sflag=-1.e0     sflag=0.e0        sflag=1.e0     sflag=-2.e0
!
!       (sh11  sh12)    (1.E0  sh12)    (sh11  1.E0)    (1.E0  0.E0)
!     h=(          )    (          )    (          )    (          )
!       (sh21  sh22),   (sh21  1.E0),   (-1.E0 sh22),   (0.E0  1.E0).
!
!     Locations 2-4 of sparam contain sh11,sh21,sh12, and sh22
!     respectively. (Values of 1.E0, -1.E0, or 0.E0 implied by the
!     value of sparam(1) are not stored in sparam.)
!
!     It is assumed that gamsq = gam*gam and rgamsq = one/(gam*gam).
!     The values of gamsq and rgamsq set in the data statement may be
!     inexact.  This is OK as they are only used for testing the size
!     of sd1 and sd2.  All actual scaling of data is done using gam.
!
!
!
if (sd1 .lt. zero) go to 60
sp2 = sd2*sy1
if (sp2 .ne. zero) go to 20
sflag = -two
go to 260
!
!     Regular-case..
!
20 sp1 = sd1*sx1
sq1 = sp1*sx1
sq2 = sp2*sy1
!
if (abs(sq1) .le. abs(sq2)) go to 40
sh21 = -sy1/sx1
sh12 = sp2/sp1
!
su = one - sh12*sh21
if (su .le. zero) go to 60
!
sflag = zero
sh11 = one
sh22 = one
sd1 = sd1/su
sd2 = sd2/su
sx1 = sx1*su
!         Go scale-check..
go to 100
!
40 continue
if (sd2 .lt. zero) go to 60
sflag = one
sh11 = sp1/sp2
sh21 = -one
sh12 = one
sh22 = sx1/sy1
!
su = one + sh11*sh22
stemp = sd2/su
sd2 = sd1/su
sd1 = stemp
sx1 = sy1*su
!         Go scale-check
go to 100
!
!     Procedure..zero-H-D-and-sx1..
!
60 continue
sflag = -one
sh11 = zero
sh12 = zero
sh21 = zero
sh22 = zero
!
sd1 = zero
sd2 = zero
sx1 = zero
go to 250
!
!     Procedure..scale-check
!
100 continue
110 continue
if (sd1 .gt. rgamsq) go to 130
if (sd1 .eq. zero) go to 160
sflag = -one
sd1 = sd1*(gam*gam)
sx1 = sx1/gam
sh11 = sh11/gam
sh12 = sh12/gam
go to 110
!
130 continue
140 continue
if (sd1 .lt. gamsq) go to 160
sflag = -one
sd1 = sd1/(gam*gam)
sx1 = sx1*gam
sh11 = sh11*gam
sh12 = sh12*gam
go to 140
!
160 continue
170 continue
if (abs(sd2) .gt. rgamsq) go to 190
if (sd2 .eq. zero) go to 220
sflag = -one
sd2 = sd2*(gam*gam)
sh21 = sh21/gam
sh22 = sh22/gam
go to 170
!
190 continue
200 continue
if (abs(sd2) .lt. gamsq) go to 220
sflag = -one
sd2 = sd2/(gam*gam)
sh21 = sh21*gam
sh22 = sh22*gam
go to 200
!
220 continue
if (sflag) 250,230,240
230 continue
sparam(3) = sh21
sparam(4) = sh12
go to 260
240 continue
sparam(2) = sh11
sparam(5) = sh22
go to 260
250 continue
sparam(2) = sh11
sparam(3) = sh21
sparam(4) = sh12
sparam(5) = sh22
260 continue
sparam(1) = sflag
return
end subroutine srotmg

subroutine srotm (n,sx,incx,sy,incy,sparam)
implicit none
integer, intent(in) :: incx, incy, n
real :: sparam(5)
real, intent(inout) :: sx(*), sy(*)
integer :: i, kx, ky, nsteps
real :: sflag, sh11, sh12, sh21, sh22, w, z
real, parameter :: zero = 0.e0
real, parameter :: two = 2.e0
!
!     Apply the modified Givens transformation, H, to the 2 by n matrix
!
!     (sx**T), where **T indicates transpose. The elements of sx are in
!     (sy**T)
!
!     sx(LX+i*incx), i = 0 TO n-1, WHERE LX = 1 IF incx .GE. 0, ELSE
!     LX = (-incx)*n, and similarly for sy using using LY and incy.
!
!     With sparam(1)=sflag, H has one of the following forms..
!
!     sflag=-1.e0     sflag=0.e0        sflag=1.e0     sflag=-2.e0
!
!       (sh11  sh12)    (1.E0  sh12)    (sh11  1.E0)    (1.E0  0.E0)
!     h=(          )    (          )    (          )    (          )
!       (sh21  sh22),   (sh21  1.E0),   (-1.E0 sh22),   (0.E0  1.E0).
!
!
!
sflag = sparam(1)
if (n .le. 0 .or.(sflag + two.eq.zero)) go to 140
if (.not.(incx.eq.incy.and. incx .gt.0)) go to 70
!
nsteps = n*incx
if (sflag) 50,10,30
10 continue
sh21 = sparam(3)
sh12 = sparam(4)
do i = 1,nsteps,incx
   w = sx(i)
   z = sy(i)
   sx(i) = w + z*sh12
   sy(i) = w*sh21 + z
end do
go to 140
30 continue
sh11 = sparam(2)
sh22 = sparam(5)
do i = 1,nsteps,incx
   w = sx(i)
   z = sy(i)
   sx(i) = w*sh11 + z
   sy(i) = -w + sh22*z
end do
go to 140
50 continue
sh11 = sparam(2)
sh21 = sparam(3)
sh12 = sparam(4)
sh22 = sparam(5)
do i = 1,nsteps,incx
   w = sx(i)
   z = sy(i)
   sx(i) = w*sh11 + z*sh12
   sy(i) = w*sh21 + z*sh22
end do
go to 140
70 continue
kx = 1
ky = 1
if (incx .lt. 0) kx = 1 + (1 - n)*incx
if (incy .lt. 0) ky = 1 + (1 - n)*incy
!
if (sflag) 120,80,100
80 continue
sh21 = sparam(3)
sh12 = sparam(4)
do i = 1,n
   w = sx(kx)
   z = sy(ky)
   sx(kx) = w + z*sh12
   sy(ky) = w*sh21 + z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
100 continue
sh11 = sparam(2)
sh22 = sparam(5)
do i = 1,n
   w = sx(kx)
   z = sy(ky)
   sx(kx) = w*sh11 + z
   sy(ky) = -w + sh22*z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
120 continue
sh11 = sparam(2)
sh21 = sparam(3)
sh12 = sparam(4)
sh22 = sparam(5)
do i = 1,n
   w = sx(kx)
   z = sy(ky)
   sx(kx) = w*sh11 + z*sh12
   sy(ky) = w*sh21 + z*sh22
   kx = kx + incx
   ky = ky + incy
end do
140 continue
return
end subroutine srotm

pure subroutine drotmg (dd1,dd2,dx1,dy1,dparam)
implicit none
!
!     Construct the modified Givens transformation matrix H which zeros
!     the second component of the 2-vector  (dsqrt(dd1)*dx1,dsqrt(dd2)*
!     dy1)**T.
!     With dparam(1)=dflag, H has one of the following forms..
!
!     dflag=-1.d0     dflag=0.d0        dflag=1.d0     dflag=-2.d0
!
!       (dh11  dh12)    (1.D0  dh12)    (dh11  1.D0)    (1.D0  0.D0)
!     h=(          )    (          )    (          )    (          )
!       (dh21  dh22),   (dh21  1.D0),   (-1.D0 dh22),   (0.D0  1.D0).
!
!     Locations 2-4 of dparam contain dh11,dh21,dh12, and dh22
!     respectively. (Values of 1.D0, -1.D0, or 0.D0 implied by the
!     value of dparam(1) are not stored in dparam.)
!
!     It is assumed that gamsq = gam*gam and rgamsq = one/(gam*gam).
!     The values of gamsq and rgamsq set in the data statement may be
!     inexact.  This is OK as they are only used for testing the size
!     of dd1 and dd2.  All actual scaling of data is done using gam.
!
double precision, intent(inout) :: dd2
double precision, intent(inout) :: dparam(5)
double precision, intent(in) :: dy1
double precision, intent(inout) :: dd1
double precision, intent(inout) :: dx1
double precision :: dh11, dh21
double precision :: dp2, dq2, du
double precision :: dflag, dh12, dh22, dp1, dq1, dtemp
double precision, parameter :: zero = 0.d0
double precision, parameter :: one = 1.d0
double precision, parameter :: two = 2.d0
double precision, parameter :: gam = 4096.d0
double precision, parameter :: gamsq = 16777216.d0
double precision, parameter :: rgamsq = 5.9604645d-8
!
!
if (dd1 .lt. zero) go to 60
dp2 = dd2*dy1
if (dp2 .ne. zero) go to 20
dflag = -two
go to 260
!
!     Regular-case..
!
20 dp1 = dd1*dx1
dq1 = dp1*dx1
dq2 = dp2*dy1
!
if (dabs(dq1) .le. dabs(dq2)) go to 40
dh21 = -dy1/dx1
dh12 = dp2/dp1
!
du = one - dh12*dh21
if (du .le. zero) go to 60
!
dflag = zero
dh11 = one
dh22 = one
dd1 = dd1/du
dd2 = dd2/du
dx1 = dx1*du
!         Go scale-check..
go to 100
!
40 continue
if (dd2 .lt. zero) go to 60
dflag = one
dh11 = dp1/dp2
dh21 = -one
dh12 = one
dh22 = dx1/dy1
!
du = one + dh11*dh22
dtemp = dd2/du
dd2 = dd1/du
dd1 = dtemp
dx1 = dy1*du
!         Go scale-check
go to 100
!
!     Procedure..zero-H-D-and-dx1..
!
60 continue
dflag = -one
dh11 = zero
dh12 = zero
dh21 = zero
dh22 = zero
!
dd1 = zero
dd2 = zero
dx1 = zero
go to 250
!
!     Procedure..scale-check
!
100 continue
110 continue
if (dd1 .gt. rgamsq) go to 130
if (dd1 .eq. zero) go to 160
dflag = -one
dd1 = dd1*(gam*gam)
dx1 = dx1/gam
dh11 = dh11/gam
dh12 = dh12/gam
go to 110
!
130 continue
140 continue
if (dd1 .lt. gamsq) go to 160
dflag = -one
dd1 = dd1/(gam*gam)
dx1 = dx1*gam
dh11 = dh11*gam
dh12 = dh12*gam
go to 140
!
160 continue
170 continue
if (dabs(dd2) .gt. rgamsq) go to 190
if (dd2 .eq. zero) go to 220
dflag = -one
dd2 = dd2*(gam*gam)
dh21 = dh21/gam
dh22 = dh22/gam
go to 170
!
190 continue
200 continue
if (dabs(dd2) .lt. gamsq) go to 220
dflag = -one
dd2 = dd2/(gam*gam)
dh21 = dh21*gam
dh22 = dh22*gam
go to 200
!
220 continue
if (dflag) 250,230,240
230 continue
dparam(3) = dh21
dparam(4) = dh12
go to 260
240 continue
dparam(2) = dh11
dparam(5) = dh22
go to 260
250 continue
dparam(2) = dh11
dparam(3) = dh21
dparam(4) = dh12
dparam(5) = dh22
260 continue
dparam(1) = dflag
return
end subroutine drotmg

subroutine drotm (n,dx,incx,dy,incy,dparam)
implicit none
integer, intent(in) :: incx, incy, n
double precision, intent(inout) :: dx(*)
double precision :: dparam(5)
double precision, intent(inout) :: dy(*)
integer :: i, kx, ky, nsteps
double precision :: dflag, dh12, dh22
double precision :: z, dh11, dh21
double precision :: w
double precision, parameter :: zero = 0.d0
double precision, parameter :: two = 2.d0
!
!     Apply the modified Givens transformation, H, to the 2 by n matrix
!
!     (dx**T), where **T indicates transpose. The elements of dx are in
!     (dy**T)
!
!     dx(LX+i*incx), i = 0 TO n-1, WHERE LX = 1 IF incx .GE. 0, ELSE
!     LX = (-incx)*n, and similarly for SY using LY and incy.
!
!     With dparam(1)=dflag, H has one of the following forms..
!
!     dflag=-1.d0     dflag=0.d0        dflag=1.d0     dflag=-2.d0
!
!       (dh11  dh12)    (1.D0  dh12)    (dh11  1.D0)    (1.D0  0.D0)
!     h=(          )    (          )    (          )    (          )
!       (dh21  dh22),   (dh21  1.D0),   (-1.D0 dh22),   (0.D0  1.D0).
!
!
!
dflag = dparam(1)
if (n .le. 0 .or.(dflag + two.eq.zero)) go to 140
if (.not.(incx.eq.incy.and. incx .gt.0)) go to 70
!
nsteps = n*incx
if (dflag) 50,10,30
10 continue
dh21 = dparam(3)
dh12 = dparam(4)
do i = 1,nsteps,incx
   w = dx(i)
   z = dy(i)
   dx(i) = w + z*dh12
   dy(i) = w*dh21 + z
end do
go to 140
30 continue
dh11 = dparam(2)
dh22 = dparam(5)
do i = 1,nsteps,incx
   w = dx(i)
   z = dy(i)
   dx(i) = w*dh11 + z
   dy(i) = -w + dh22*z
end do
go to 140
50 continue
dh11 = dparam(2)
dh21 = dparam(3)
dh12 = dparam(4)
dh22 = dparam(5)
do i = 1,nsteps,incx
   w = dx(i)
   z = dy(i)
   dx(i) = w*dh11 + z*dh12
   dy(i) = w*dh21 + z*dh22
end do
go to 140
70 continue
kx = 1
ky = 1
if (incx .lt. 0) kx = 1 + (1 - n)*incx
if (incy .lt. 0) ky = 1 + (1 - n)*incy
!
if (dflag) 120,80,100
80 continue
dh21 = dparam(3)
dh12 = dparam(4)
do i = 1,n
   w = dx(kx)
   z = dy(ky)
   dx(kx) = w + z*dh12
   dy(ky) = w*dh21 + z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
100 continue
dh11 = dparam(2)
dh22 = dparam(5)
do i = 1,n
   w = dx(kx)
   z = dy(ky)
   dx(kx) = w*dh11 + z
   dy(ky) = -w + dh22*z
   kx = kx + incx
   ky = ky + incy
end do
go to 140
120 continue
dh11 = dparam(2)
dh21 = dparam(3)
dh12 = dparam(4)
dh22 = dparam(5)
do i = 1,n
   w = dx(kx)
   z = dy(ky)
   dx(kx) = w*dh11 + z*dh12
   dy(ky) = w*dh21 + z*dh22
   kx = kx + incx
   ky = ky + incy
end do
140 continue
return
end subroutine drotm

pure real function sdot(n,sx,incx,sy,incy)
implicit none
!
!     Forms the dot product of two vectors.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*), sy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
real :: stemp
integer :: i
integer :: ix, iy, m, mp1
!
stemp = 0.0e0
sdot = 0.0e0
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   stemp = stemp + sx(ix)*sy(iy)
   ix = ix + incx
   iy = iy + incy
end do
sdot = stemp
return
!
!        Code for both increments equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,5)
if ( m .eq. 0 ) go to 40
do i = 1,m
   stemp = stemp + sx(i)*sy(i)
end do
if ( n .lt. 5 ) go to 60
40 mp1 = m + 1
do i = mp1,n,5
   stemp = stemp + sx(i)*sy(i) + sx(i + 1)*sy(i + 1) + &
      & sx(i + 2)*sy(i + 2) + sx(i + 3)*sy(i + 3) + sx(i + 4)*sy(i + 4)
end do
60 sdot = stemp
return
end function sdot

pure double precision function ddot(n,dx,incx,dy,incy)
implicit none
!
!     Forms the dot product of two vectors.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*), dy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
double precision :: dtemp
integer :: i
integer :: ix, iy, m, mp1
!
ddot = 0.0d0
dtemp = 0.0d0
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   dtemp = dtemp + dx(ix)*dy(iy)
   ix = ix + incx
   iy = iy + incy
end do
ddot = dtemp
return
!
!        Code for both increments equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,5)
if ( m .eq. 0 ) go to 40
do i = 1,m
   dtemp = dtemp + dx(i)*dy(i)
end do
if ( n .lt. 5 ) go to 60
40 mp1 = m + 1
do i = mp1,n,5
   dtemp = dtemp + dx(i)*dy(i) + dx(i + 1)*dy(i + 1) + &
      & dx(i + 2)*dy(i + 2) + dx(i + 3)*dy(i + 3) + dx(i + 4)*dy(i + 4)
end do
60 ddot = dtemp
return
end function ddot

pure complex function cdotc(n,cx,incx,cy,incy)
implicit none
!
!     Forms the dot product of two vectors, conjugating the first
!     vector.
!     Jack dongarra, LINPACK,  3/11/78.
!
complex, intent(in) :: cx(*), cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
complex :: ctemp
integer :: i
integer :: ix, iy
!
ctemp = (0.0,0.0)
cdotc = (0.0,0.0)
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = ctemp + conjg(cx(ix))*cy(iy)
   ix = ix + incx
   iy = iy + incy
end do
cdotc = ctemp
return
!
!        Code for both increments equal to 1
!
20 do i = 1,n
   ctemp = ctemp + conjg(cx(i))*cy(i)
end do
cdotc = ctemp
return
end function cdotc

pure complex function cdotu(n,cx,incx,cy,incy)
implicit none
!
!     Forms the dot product of two vectors.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*), cy(*)
integer, intent(in) :: incx, incy
integer, intent(in) :: n
complex :: ctemp
integer :: i
integer :: ix, iy
!
ctemp = (0.0,0.0)
cdotu = (0.0,0.0)
if (n.le.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   ctemp = ctemp + cx(ix)*cy(iy)
   ix = ix + incx
   iy = iy + incy
end do
cdotu = ctemp
return
!
!        Code for both increments equal to 1
!
20 do i = 1,n
   ctemp = ctemp + cx(i)*cy(i)
end do
cdotu = ctemp
return
end function cdotu

pure subroutine  sscal(n,sa,sx,incx)
implicit none
!
!     Scales a vector BY a constant.
!     Uses unrolled loops for increment equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sa
real, intent(inout) :: sx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
integer :: i
integer :: m, mp1
integer :: nincx
!
if (n.le.0) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
nincx = n*incx
do i = 1,nincx,incx
   sx(i) = sa*sx(i)
end do
return
!
!        Code for increment equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,5)
if ( m .eq. 0 ) go to 40
do i = 1,m
   sx(i) = sa*sx(i)
end do
if ( n .lt. 5 ) return
40 mp1 = m + 1
do i = mp1,n,5
   sx(i) = sa*sx(i)
   sx(i + 1) = sa*sx(i + 1)
   sx(i + 2) = sa*sx(i + 2)
   sx(i + 3) = sa*sx(i + 3)
   sx(i + 4) = sa*sx(i + 4)
end do
return
end subroutine sscal

pure subroutine  dscal(n,da,dx,incx)
implicit none
!
!     Scales a vector BY a constant.
!     Uses unrolled loops for increment equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: da
double precision, intent(inout) :: dx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
integer :: i
integer :: m, mp1
integer :: nincx
!
if (n.le.0) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
nincx = n*incx
do i = 1,nincx,incx
   dx(i) = da*dx(i)
end do
return
!
!        Code for increment equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,5)
if ( m .eq. 0 ) go to 40
do i = 1,m
   dx(i) = da*dx(i)
end do
if ( n .lt. 5 ) return
40 mp1 = m + 1
do i = mp1,n,5
   dx(i) = da*dx(i)
   dx(i + 1) = da*dx(i + 1)
   dx(i + 2) = da*dx(i + 2)
   dx(i + 3) = da*dx(i + 3)
   dx(i + 4) = da*dx(i + 4)
end do
return
end subroutine dscal

pure subroutine  cscal(n,ca,cx,incx)
implicit none
!
!     Scales a vector BY a constant.
!     Jack dongarra, LINPACK,  3/11/78.
!
complex, intent(in) :: ca
complex, intent(inout) :: cx(*)
integer, intent(in) :: incx, n
integer :: i
integer :: nincx
!
if (n.le.0) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
nincx = n*incx
do i = 1,nincx,incx
   cx(i) = ca*cx(i)
end do
return
!
!        Code for increment equal to 1
!
20 do i = 1,n
   cx(i) = ca*cx(i)
end do
return
end subroutine cscal

pure subroutine  csscal(n,sa,cx,incx)
implicit none
!
!     Scales a complex vector BY a real constant.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(inout) :: cx(*)
real, intent(in) :: sa
integer, intent(in) :: incx, n
integer :: i
integer :: nincx
!
if (n.le.0) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
nincx = n*incx
do i = 1,nincx,incx
   cx(i) = cmplx(sa*real(cx(i)),sa*aimag(cx(i)))
end do
return
!
!        Code for increment equal to 1
!
20 do i = 1,n
   cx(i) = cmplx(sa*real(cx(i)),sa*aimag(cx(i)))
end do
return
end subroutine csscal

pure subroutine saxpy(n,sa,sx,incx,sy,incy)
implicit none
!
!     Constant times a vector plus a vector.
!     Uses unrolled loop for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
real, intent(inout) :: sy(*)
real, intent(in) :: sa
integer, intent(in) :: incx, incy
integer, intent(in) :: n
integer :: i
integer :: ix, iy, m, mp1
!
if (n.le.0) return
if (sa .eq. 0.0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   sy(iy) = sy(iy) + sa*sx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!
!        Code for both increments equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,4)
if ( m .eq. 0 ) go to 40
do i = 1,m
   sy(i) = sy(i) + sa*sx(i)
end do
if ( n .lt. 4 ) return
40 mp1 = m + 1
do i = mp1,n,4
   sy(i) = sy(i) + sa*sx(i)
   sy(i + 1) = sy(i + 1) + sa*sx(i + 1)
   sy(i + 2) = sy(i + 2) + sa*sx(i + 2)
   sy(i + 3) = sy(i + 3) + sa*sx(i + 3)
end do
return
end subroutine saxpy

pure subroutine daxpy(n,da,dx,incx,dy,incy)
implicit none
!
!     Constant times a vector plus a vector.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
double precision, intent(inout) :: dy(*)
double precision, intent(in) :: da
integer, intent(in) :: incx, incy
integer, intent(in) :: n
integer :: i
integer :: ix, iy, m, mp1
!
if (n.le.0) return
if (da .eq. 0.0d0) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   dy(iy) = dy(iy) + da*dx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!
!        Code for both increments equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,4)
if ( m .eq. 0 ) go to 40
do i = 1,m
   dy(i) = dy(i) + da*dx(i)
end do
if ( n .lt. 4 ) return
40 mp1 = m + 1
do i = mp1,n,4
   dy(i) = dy(i) + da*dx(i)
   dy(i + 1) = dy(i + 1) + da*dx(i + 1)
   dy(i + 2) = dy(i + 2) + da*dx(i + 2)
   dy(i + 3) = dy(i + 3) + da*dx(i + 3)
end do
return
end subroutine daxpy

pure subroutine caxpy(n,ca,cx,incx,cy,incy)
implicit none
!
!     Constant times a vector plus a vector.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*)
complex, intent(inout) :: cy(*)
complex, intent(in) :: ca
integer, intent(in) :: incx, incy
integer, intent(in) :: n
integer :: i
integer :: ix, iy
!
if (n.le.0) return
if (abs(real(ca)) + abs(aimag(ca)) .eq. 0.0 ) return
if (incx.eq.1.and.incy.eq.1) go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if (incx.lt.0) ix = (-n + 1)*incx + 1
if (incy.lt.0) iy = (-n + 1)*incy + 1
do i = 1,n
   cy(iy) = cy(iy) + ca*cx(ix)
   ix = ix + incx
   iy = iy + incy
end do
return
!
!        Code for both increments equal to 1
!
20 do i = 1,n
   cy(i) = cy(i) + ca*cx(i)
end do
return
end subroutine caxpy

pure real function sasum(n,sx,incx)
implicit none
!
!     Takes the sum of the absolute values.
!     Uses unrolled loops for increment equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
real :: stemp
integer :: i
integer :: m, mp1
integer :: nincx
!
sasum = 0.0e0
stemp = 0.0e0
if (n.le.0) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
nincx = n*incx
do i = 1,nincx,incx
   stemp = stemp + abs(sx(i))
end do
sasum = stemp
return
!
!        Code for increment equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,6)
if ( m .eq. 0 ) go to 40
do i = 1,m
   stemp = stemp + abs(sx(i))
end do
if ( n .lt. 6 ) go to 60
40 mp1 = m + 1
do i = mp1,n,6
   stemp = stemp + abs(sx(i)) + abs(sx(i + 1)) + abs(sx(i + 2)) &
      & + abs(sx(i + 3)) + abs(sx(i + 4)) + abs(sx(i + 5))
end do
60 sasum = stemp
return
end function sasum

pure double precision function dasum(n,dx,incx)
implicit none
!
!     Takes the sum of the absolute values.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
double precision :: dtemp
integer :: i
integer :: m, mp1
integer :: nincx
!
dasum = 0.0d0
dtemp = 0.0d0
if (n.le.0) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
nincx = n*incx
do i = 1,nincx,incx
   dtemp = dtemp + dabs(dx(i))
end do
dasum = dtemp
return
!
!        Code for increment equal to 1
!
!
!        Clean-up loop
!
20 m = mod(n,6)
if ( m .eq. 0 ) go to 40
do i = 1,m
   dtemp = dtemp + dabs(dx(i))
end do
if ( n .lt. 6 ) go to 60
40 mp1 = m + 1
do i = mp1,n,6
   dtemp = dtemp + dabs(dx(i)) + dabs(dx(i + 1)) + dabs(dx(i + 2)) &
      & + dabs(dx(i + 3)) + dabs(dx(i + 4)) + dabs(dx(i + 5))
end do
60 dasum = dtemp
return
end function dasum

pure real function scasum(n,cx,incx)
implicit none
!
!     Takes the sum of the absolute values of a complex vector and
!     returns a single precision result.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*)
integer, intent(in) :: incx, n
real :: stemp
integer :: i
integer :: nincx
!
scasum = 0.0e0
stemp = 0.0e0
if (n.le.0) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
nincx = n*incx
do i = 1,nincx,incx
   stemp = stemp + abs(real(cx(i))) + abs(aimag(cx(i)))
end do
scasum = stemp
return
!
!        Code for increment equal to 1
!
20 do i = 1,n
   stemp = stemp + abs(real(cx(i))) + abs(aimag(cx(i)))
end do
scasum = stemp
return
end function scasum

pure real function snrm2 ( n, sx, incx)
implicit none
integer, intent(in) :: incx, n
real, intent(in) :: sx(*)
integer :: i, j, nn
integer :: next
real :: hitest, sum, xmax
real, parameter :: zero = 0.0e0
real, parameter :: one = 1.0e0
real, parameter :: cutlo = 4.441e-16
real, parameter :: cuthi = 1.304e19
!
!     Euclidean norm of the n-vector stored in sx() with storage
!     increment incx .
!     If    n .LE. 0 return with result = 0.
!     If n .GE. 1 then incx must be .GE. 1
!
!           C.L.Lawson, 1978 jan 08
!
!     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!     hopefully applicable to all machines.
!         cutlo = Maximum of  sqrt(U/EPS)  over all known machines.
!         cuthi = Minimum of  sqrt(V)      over all known machines.
!     Where
!         eps = Smallest no. such that eps + 1. .GT. 1.
!         U   = Smallest positive no.   (underflow limit)
!         V   = Largest  no.            (overflow  limit)
!
!     Brief outline of algorithm..
!
!     PHASE 1    SCANS ZERO COMPONENTS.
!     Move to phase 2 when a component is nonzero and .LE. cutlo
!     move to phase 3 when a component is .GT. cutlo
!     move to phase 4 when a component is .GE. cuthi/M
!     where M = n for X() real and M = 2*n for complex.
!
!     Values for cutlo and cuthi..
!     From the environmental parameters listed in the IMSL converter
!     document the limiting values are as follows..
!     cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!                   Univac and DEC at 2**(-103)
!                   THUS cutlo = 2**(-51) = 4.44089E-16
!     cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!                   THUS cuthi = 2**(63.5) = 1.30438E19
!     cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!                   THUS cutlo = 2**(-33.5) = 8.23181D-11
!     cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!     DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!     DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
!
if (n .gt. 0) go to 10
snrm2 = zero
go to 300
!
10 assign 30 to next
sum = zero
nn = n * incx
!                                                 Begin main loop
i = 1
20 go to next,(30, 50, 70, 110)
30 if ( abs(sx(i)) .gt. cutlo) go to 85
assign 50 to next
xmax = zero
!
!                        Phase 1.  Sum is zero
!
50 if ( sx(i) .eq. zero) go to 200
if ( abs(sx(i)) .gt. cutlo) go to 85
!
!                                Prepare for phase 2.
assign 70 to next
go to 105
!
!                                Prepare for phase 4.
!
100 i = j
assign 110 to next
sum = (sum / sx(i)) / sx(i)
105 xmax = abs(sx(i))
go to 115
!
!                   Phase 2.  Sum is small.
!                             Scale to avoid destructive underflow.
!
70 if ( abs(sx(i)) .gt. cutlo ) go to 75
!
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
!
110 if ( abs(sx(i)) .le. xmax ) go to 115
sum = one + sum * (xmax / sx(i))**2
xmax = abs(sx(i))
go to 200
!
115 sum = sum + (sx(i)/xmax)**2
go to 200
!
!
!                  Prepare for phase 3.
!
75 sum = (sum * xmax) * xmax
!
!
!     For real or D.P. set hitest = cuthi/n
!     for complex      set hitest = cuthi/(2*n)
!
85 hitest = cuthi/float( n )
!
!                   Phase 3.  Sum is mid-range.  No scaling.
!
do 95 j = i,nn,incx
   if (abs(sx(j)) .ge. hitest) go to 100
95 sum = sum + sx(j)**2
snrm2 = sqrt( sum )
go to 300
!
200 continue
i = i + incx
if ( i .le. nn ) go to 20
!
!              END OF MAIN LOOP.
!
!              Compute square root and adjust for scaling.
!
snrm2 = xmax * sqrt(sum)
300 continue
return
end function snrm2

pure double precision function dnrm2 ( n, dx, incx)
implicit none
integer, intent(in) :: incx, n
double precision, intent(in) :: dx(*)
integer :: i, j, nn
integer :: next
double precision :: hitest, sum, xmax
double precision, parameter :: zero = 0.0d0
double precision, parameter :: one = 1.0d0
double precision, parameter :: cutlo = 8.232d-11
double precision, parameter :: cuthi = 1.304d19
!
!     Euclidean norm of the n-vector stored in dx() with storage
!     increment incx .
!     If    n .LE. 0 return with result = 0.
!     If n .GE. 1 then incx must be .GE. 1
!
!           C.L.Lawson, 1978 jan 08
!
!     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!     hopefully applicable to all machines.
!         cutlo = Maximum of  dsqrt(U/EPS)  over all known machines.
!         cuthi = Minimum of  dsqrt(V)      over all known machines.
!     Where
!         eps = Smallest no. such that eps + 1. .GT. 1.
!         U   = Smallest positive no.   (underflow limit)
!         V   = Largest  no.            (overflow  limit)
!
!     Brief outline of algorithm..
!
!     PHASE 1    SCANS ZERO COMPONENTS.
!     Move to phase 2 when a component is nonzero and .LE. cutlo
!     move to phase 3 when a component is .GT. cutlo
!     move to phase 4 when a component is .GE. cuthi/M
!     where M = n for X() real and M = 2*n for complex.
!
!     Values for cutlo and cuthi..
!     From the environmental parameters listed in the IMSL converter
!     document the limiting values are as follows..
!     cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!                   Univac and DEC at 2**(-103)
!                   THUS cutlo = 2**(-51) = 4.44089E-16
!     cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!                   THUS cuthi = 2**(63.5) = 1.30438E19
!     cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!                   THUS cutlo = 2**(-33.5) = 8.23181D-11
!     cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!     DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!     DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
!
if (n .gt. 0) go to 10
dnrm2 = zero
go to 300
!
10 assign 30 to next
sum = zero
nn = n * incx
!                                                 Begin main loop
i = 1
20 go to next,(30, 50, 70, 110)
30 if ( dabs(dx(i)) .gt. cutlo) go to 85
assign 50 to next
xmax = zero
!
!                        Phase 1.  Sum is zero
!
50 if ( dx(i) .eq. zero) go to 200
if ( dabs(dx(i)) .gt. cutlo) go to 85
!
!                                Prepare for phase 2.
assign 70 to next
go to 105
!
!                                Prepare for phase 4.
!
100 i = j
assign 110 to next
sum = (sum / dx(i)) / dx(i)
105 xmax = dabs(dx(i))
go to 115
!
!                   Phase 2.  Sum is small.
!                             Scale to avoid destructive underflow.
!
70 if ( dabs(dx(i)) .gt. cutlo ) go to 75
!
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
!
110 if ( dabs(dx(i)) .le. xmax ) go to 115
sum = one + sum * (xmax / dx(i))**2
xmax = dabs(dx(i))
go to 200
!
115 sum = sum + (dx(i)/xmax)**2
go to 200
!
!
!                  Prepare for phase 3.
!
75 sum = (sum * xmax) * xmax
!
!
!     For real or D.P. set hitest = cuthi/n
!     for complex      set hitest = cuthi/(2*n)
!
85 hitest = cuthi/float( n )
!
!                   Phase 3.  Sum is mid-range.  No scaling.
!
do 95 j = i,nn,incx
   if (dabs(dx(j)) .ge. hitest) go to 100
95 sum = sum + dx(j)**2
dnrm2 = dsqrt( sum )
go to 300
!
200 continue
i = i + incx
if ( i .le. nn ) go to 20
!
!              END OF MAIN LOOP.
!
!              Compute square root and adjust for scaling.
!
dnrm2 = xmax * dsqrt(sum)
300 continue
return
end function dnrm2

pure real function scnrm2( n, cx, incx)
implicit none
integer, intent(in) :: incx, n
complex, intent(in) :: cx(*)
integer :: i, nn
logical :: imag, scale
integer :: next
real :: hitest, sum, xmax, absx
real, parameter :: zero = 0.0e0
real, parameter :: one = 1.0e0
real, parameter :: cutlo = 4.441e-16
real, parameter :: cuthi = 1.304e19
!
!     Unitary norm of the complex n-vector stored in cx() with storage
!     increment incx .
!     If    n .LE. 0 return with result = 0.
!     If n .GE. 1 then incx must be .GE. 1
!
!           C.L.Lawson , 1978 jan 08
!
!     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
!     hopefully applicable to all machines.
!         cutlo = Maximum of  sqrt(U/EPS)  over all known machines.
!         cuthi = Minimum of  sqrt(V)      over all known machines.
!     Where
!         eps = Smallest no. such that eps + 1. .GT. 1.
!         U   = Smallest positive no.   (underflow limit)
!         V   = Largest  no.            (overflow  limit)
!
!     Brief outline of algorithm..
!
!     PHASE 1    SCANS ZERO COMPONENTS.
!     Move to phase 2 when a component is nonzero and .LE. cutlo
!     move to phase 3 when a component is .GT. cutlo
!     move to phase 4 when a component is .GE. cuthi/M
!     where M = n for X() real and M = 2*n for complex.
!
!     Values for cutlo and cuthi..
!     From the environmental parameters listed in the IMSL converter
!     document the limiting values are as follows..
!     cutlo, S.P.   U/eps = 2**(-102) for  Honeywell.  Close seconds are
!                   Univac and DEC at 2**(-103)
!                   THUS cutlo = 2**(-51) = 4.44089E-16
!     cuthi, S.P.   V = 2**127 for Univac, Honeywell, and DEC.
!                   THUS cuthi = 2**(63.5) = 1.30438E19
!     cutlo, D.P.   U/eps = 2**(-67) for Honeywell and DEC.
!                   THUS cutlo = 2**(-33.5) = 8.23181D-11
!     cuthi, D.P.   SAME AS S.P.  cuthi = 1.30438D19
!     DATA cutlo, cuthi / 8.232D-11,  1.304D19 /
!     DATA cutlo, cuthi / 4.441E-16,  1.304E19 /
!
if (n .gt. 0) go to 10
scnrm2 = zero
go to 300
!
10 assign 30 to next
sum = zero
nn = n * incx
!                                                 Begin main loop
do 210 i = 1,nn,incx
   absx = abs(real(cx(i)))
   imag = .false.
   go to next,(30, 50, 70, 90, 110)
30 if ( absx .gt. cutlo) go to 85
   assign 50 to next
   scale = .false.
!
!                        Phase 1.  Sum is zero
!
50 if ( absx .eq. zero) go to 200
   if ( absx .gt. cutlo) go to 85
!
!                                Prepare for phase 2.
   assign 70 to next
   go to 105
!
!                                Prepare for phase 4.
!
100 assign 110 to next
   sum = (sum / absx) / absx
105 scale = .true.
   xmax = absx
   go to 115
!
!                   Phase 2.  Sum is small.
!                             Scale to avoid destructive underflow.
!
70 if ( absx .gt. cutlo ) go to 75
!
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
!
110 if ( absx .le. xmax ) go to 115
   sum = one + sum * (xmax / absx)**2
   xmax = absx
   go to 200
!
115 sum = sum + (absx/xmax)**2
   go to 200
!
!
!                  Prepare for phase 3.
!
75 sum = (sum * xmax) * xmax
!
85 assign 90 to next
   scale = .false.
!
!     For real or D.P. set hitest = cuthi/n
!     for complex      set hitest = cuthi/(2*n)
!
   hitest = cuthi/float( n )
   hitest = hitest * 0.5
!
!                   Phase 3.  Sum is mid-range.  No scaling.
!
90 if (absx .ge. hitest) go to 100
   sum = sum + absx**2
200 continue
!                  Control selection of real and imaginary parts.
!
   if (imag) go to 210
   absx = abs(aimag(cx(i)))
   imag = .true.
   go to next,(  50, 70, 90, 110 )
!
210 continue
!
!              END OF MAIN LOOP.
!              Compute square root and adjust for scaling.
!
scnrm2 = sqrt(sum)
if (scale) scnrm2 = scnrm2 * xmax
300 continue
return
end function scnrm2

pure integer function isamax(n,sx,incx)
implicit none
!
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
real :: smax
integer :: i
integer :: ix
!
isamax = 0
if ( n .lt. 1 ) return
isamax = 1
if (n.eq.1) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
ix = 1
smax = abs(sx(1))
ix = ix + incx
do i = 2,n
   if (abs(sx(ix)).le.smax) go to 5
   isamax = i
   smax = abs(sx(ix))
5  ix = ix + incx
end do
return
!
!        Code for increment equal to 1
!
20 smax = abs(sx(1))
do 30 i = 2,n
   if (abs(sx(i)).le.smax) go to 30
   isamax = i
   smax = abs(sx(i))
30 continue
return
end function isamax

pure integer function idamax(n,dx,incx)
implicit none
!
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
double precision :: dmax
integer :: i
integer :: ix
!
idamax = 0
if ( n .lt. 1 ) return
idamax = 1
if (n.eq.1) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
ix = 1
dmax = dabs(dx(1))
ix = ix + incx
do i = 2,n
   if (dabs(dx(ix)).le.dmax) go to 5
   idamax = i
   dmax = dabs(dx(ix))
5  ix = ix + incx
end do
return
!
!        Code for increment equal to 1
!
20 dmax = dabs(dx(1))
do 30 i = 2,n
   if (dabs(dx(i)).le.dmax) go to 30
   idamax = i
   dmax = dabs(dx(i))
30 continue
return
end function idamax

integer function icamax(n,cx,incx)
implicit none
!
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex :: cx(*)
integer, intent(in) :: incx
integer, intent(in) :: n
real :: smax
integer :: i
integer :: ix
complex :: zdum
real :: cabs1
cabs1(zdum) = abs(real(zdum)) + abs(aimag(zdum))
!
icamax = 0
if ( n .lt. 1 ) return
icamax = 1
if (n.eq.1) return
if (incx.eq.1) go to 20
!
!        Code for increment not equal to 1
!
ix = 1
smax = cabs1(cx(1))
ix = ix + incx
do i = 2,n
   if (cabs1(cx(ix)).le.smax) go to 5
   icamax = i
   smax = cabs1(cx(ix))
5  ix = ix + incx
end do
return
!
!        Code for increment equal to 1
!
20 smax = cabs1(cx(1))
do 30 i = 2,n
   if (cabs1(cx(i)).le.smax) go to 30
   icamax = i
   smax = cabs1(cx(i))
30 continue
return
end function icamax

pure subroutine mcvfs(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
integer :: i, j, l
!
l = 0
do j = 1,n
   do 10 i = 1,j
      l = l + 1
10    b(l) = a(i,j)
end do
return
end subroutine mcvfs

pure subroutine dmcvfs(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(*)
integer :: i, j, l
!
l = 0
do j = 1,n
   do 10 i = 1,j
      l = l + 1
10    b(l) = a(i,j)
end do
return
end subroutine dmcvfs

pure subroutine mcvsf(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n)
real, intent(in) :: b(*)
integer :: i, ii, im1, j, jj, l
!
a(1,1) = b(1)
if (n .lt. 2) return
l = (n*(n + 1))/2
!
j = n
do 11 jj = 2,n
   i = j
   do 10 ii = 1,j
      a(i,j) = b(l)
      i = i - 1
10    l = l - 1
11 j = j - 1
!
do i = 2,n
   im1 = i - 1
   do 20 j = 1,im1
20    a(i,j) = a(j,i)
end do
return
end subroutine mcvsf

pure subroutine dmcvsf(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
double precision, intent(inout) :: a(ka,n)
double precision, intent(in) :: b(*)
integer :: i, ii, im1, j, jj, l
!
a(1,1) = b(1)
if (n .lt. 2) return
l = (n*(n + 1))/2
!
j = n
do 11 jj = 2,n
   i = j
   do 10 ii = 1,j
      a(i,j) = b(l)
      i = i - 1
10    l = l - 1
11 j = j - 1
!
do i = 2,n
   im1 = i - 1
   do 20 j = 1,im1
20    a(i,j) = a(j,i)
end do
return
end subroutine dmcvsf

pure subroutine mcvrd(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = a(i,j)
end do
return
end subroutine mcvrd

pure subroutine mcvdr(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = a(i,j)
end do
return
end subroutine mcvdr

pure subroutine mcvrc(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = cmplx(a(i,j),0.0)
end do
return
end subroutine mcvrc

pure subroutine cmreal(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = real(a(i,j))
end do
return
end subroutine cmreal

pure subroutine cmimag(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = aimag(a(i,j))
end do
return
end subroutine cmimag

pure subroutine mcopy(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = a(i,j)
end do
return
end subroutine mcopy

pure subroutine smcopy(n,a,b)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer :: k, l
!
l = (n*(n + 1))/2
do 10 k = 1,l
10 b(k) = a(k)
return
end subroutine smcopy

pure subroutine dmcopy(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = a(i,j)
end do
return
end subroutine dmcopy

pure subroutine cmcopy(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = a(i,j)
end do
return
end subroutine cmcopy

pure subroutine cmconj(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(i,j) = conjg(a(i,j))
end do
return
end subroutine cmconj

pure subroutine tpose(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,m)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(j,i) = a(i,j)
end do
return
end subroutine tpose

pure subroutine dtpose(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,m)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(j,i) = a(i,j)
end do
return
end subroutine dtpose

pure subroutine ctpose(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,m)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(j,i) = a(i,j)
end do
return
end subroutine ctpose

pure subroutine tip (a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
real, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, &
   & istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
   & npower
real :: atemp, btemp
integer :: ifact(8), ipower(8), nexp(8), iexp(8)
interface
   pure subroutine infctr(n,ifact,ipower,nexp,npower)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ifact(*)
      integer, intent(inout) :: ipower(*)
      integer, intent(inout) :: nexp(*)
      integer, intent(inout) :: npower
   end subroutine infctr
end interface
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
if (n1.lt.2 .or. n2.lt.2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1.ne.n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max = n,m,n
   i2 = i1min + n - 1
   do i1 = i1min,i1max
      atemp = a(i1)
      a(i1) = a(i2)
      a(i2) = atemp
      i2 = i2 + n
   end do
   i1min = i1min + n + 1
end do
return
! Modulus M is factored into prime powers.  Eight factors
! suffice up to M = 2*3*5*7*11*13*17*19 = 9,767,520.
30 ndim = 0
call infctr(m, ifact, ipower, nexp, npower)
do ip = 1,npower
   iexp(ip) = 0
end do
! Generate every divisor of M less than M/2
idiv = 1
mhalf = m/2
50 if (idiv.ge.mhalf) return
! The number of elements whose index is divisible by idiv
! and by no other divisor of M is the Euler totient
! function, phi(M/idiv).
ncount = m/idiv
do 60 ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 60
   ncount = (ncount/ifact(ip))*(ifact(ip) - 1)
60 continue
if (nwork.le.0) go to 75
do i = 1,nwork
   moved(i) = 0
end do
75 istart = idiv
! The starting point of a subcycle is divisible only by idiv
! and must not appear in any other subcycle.
80 mmist = m - istart
if (istart.eq.idiv) go to 120
ndim = max0(ndim,istart)
if (istart.gt.nwork) go to 90
if (moved(istart).ne.0) go to 160
90 isoid = istart/idiv
do 100 ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 100
   if (mod(isoid,ifact(ip)).eq.0) go to 160
100 continue
if (istart.le.nwork) go to 120
itest = istart
110 itest = mod(n*itest,m)
if (itest.lt.istart .or. itest.gt.mmist) go to 160
if (itest.gt.istart .and. itest.lt.mmist) go to 110
120 atemp = a(istart + 1)
btemp = a(mmist + 1)
ia1 = istart
130 ia2 = mod(n*ia1,m)
mmia1 = m - ia1
mmia2 = m - ia2
if (ia1.le.nwork) moved(ia1) = 1
if (mmia1.le.nwork) moved(mmia1) = 1
ncount = ncount - 2
! Move two elements, the second from the negative
! subcycle.  Check first for subcycle closure.
if (ia2.eq.istart) go to 140
if (mmia2.eq.istart) go to 150
a(ia1 + 1) = a(ia2 + 1)
a(mmia1 + 1) = a(mmia2 + 1)
ia1 = ia2
go to 130
140 a(ia1 + 1) = atemp
a(mmia1 + 1) = btemp
go to 160
150 a(ia1 + 1) = btemp
a(mmia1 + 1) = atemp
160 istart = istart + idiv
if (ncount.gt.0) go to 80
do ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 170
   iexp(ip) = iexp(ip) + 1
   idiv = idiv*ifact(ip)
   go to 50
170 iexp(ip) = 0
   idiv = idiv/ipower(ip)
end do
return
200 if (n1.ne.n2) ndim = 0
return
end subroutine tip

pure subroutine dtip (a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
double precision, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, &
   & istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
   & npower
double precision :: atemp, btemp
integer :: ifact(8), ipower(8), nexp(8), iexp(8)
interface
   pure subroutine infctr(n,ifact,ipower,nexp,npower)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ifact(*)
      integer, intent(inout) :: ipower(*)
      integer, intent(inout) :: nexp(*)
      integer, intent(inout) :: npower
   end subroutine infctr
end interface
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
if (n1.lt.2 .or. n2.lt.2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1.ne.n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max = n,m,n
   i2 = i1min + n - 1
   do i1 = i1min,i1max
      atemp = a(i1)
      a(i1) = a(i2)
      a(i2) = atemp
      i2 = i2 + n
   end do
   i1min = i1min + n + 1
end do
return
! Modulus M is factored into prime powers.  Eight factors
! suffice up to M = 2*3*5*7*11*13*17*19 = 9,767,520.
30 ndim = 0
call infctr(m, ifact, ipower, nexp, npower)
do ip = 1,npower
   iexp(ip) = 0
end do
! Generate every divisor of M less than M/2
idiv = 1
mhalf = m/2
50 if (idiv.ge.mhalf) return
! The number of elements whose index is divisible by idiv
! and by no other divisor of M is the Euler totient
! function, phi(M/idiv).
ncount = m/idiv
do 60 ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 60
   ncount = (ncount/ifact(ip))*(ifact(ip) - 1)
60 continue
if (nwork.le.0) go to 75
do i = 1,nwork
   moved(i) = 0
end do
75 istart = idiv
! The starting point of a subcycle is divisible only by idiv
! and must not appear in any other subcycle.
80 mmist = m - istart
if (istart.eq.idiv) go to 120
ndim = max0(ndim,istart)
if (istart.gt.nwork) go to 90
if (moved(istart).ne.0) go to 160
90 isoid = istart/idiv
do 100 ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 100
   if (mod(isoid,ifact(ip)).eq.0) go to 160
100 continue
if (istart.le.nwork) go to 120
itest = istart
110 itest = mod(n*itest,m)
if (itest.lt.istart .or. itest.gt.mmist) go to 160
if (itest.gt.istart .and. itest.lt.mmist) go to 110
120 atemp = a(istart + 1)
btemp = a(mmist + 1)
ia1 = istart
130 ia2 = mod(n*ia1,m)
mmia1 = m - ia1
mmia2 = m - ia2
if (ia1.le.nwork) moved(ia1) = 1
if (mmia1.le.nwork) moved(mmia1) = 1
ncount = ncount - 2
! Move two elements, the second from the negative
! subcycle.  Check first for subcycle closure.
if (ia2.eq.istart) go to 140
if (mmia2.eq.istart) go to 150
a(ia1 + 1) = a(ia2 + 1)
a(mmia1 + 1) = a(mmia2 + 1)
ia1 = ia2
go to 130
140 a(ia1 + 1) = atemp
a(mmia1 + 1) = btemp
go to 160
150 a(ia1 + 1) = btemp
a(mmia1 + 1) = atemp
160 istart = istart + idiv
if (ncount.gt.0) go to 80
do ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 170
   iexp(ip) = iexp(ip) + 1
   idiv = idiv*ifact(ip)
   go to 50
170 iexp(ip) = 0
   idiv = idiv/ipower(ip)
end do
return
200 if (n1.ne.n2) ndim = 0
return
end subroutine dtip

pure subroutine ctip (a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
complex, intent(inout) :: a(*)
integer, intent(inout) :: moved(nwork)
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, &
   & istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
   & npower
complex :: atemp, btemp
integer :: ifact(8), ipower(8), nexp(8), iexp(8)
interface
   pure subroutine infctr(n,ifact,ipower,nexp,npower)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ifact(*)
      integer, intent(inout) :: ipower(*)
      integer, intent(inout) :: nexp(*)
      integer, intent(inout) :: npower
   end subroutine infctr
end interface
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
if (n1.lt.2 .or. n2.lt.2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1.ne.n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max = n,m,n
   i2 = i1min + n - 1
   do i1 = i1min,i1max
      atemp = a(i1)
      a(i1) = a(i2)
      a(i2) = atemp
      i2 = i2 + n
   end do
   i1min = i1min + n + 1
end do
return
! Modulus M is factored into prime powers.  Eight factors
! suffice up to M = 2*3*5*7*11*13*17*19 = 9,767,520.
30 ndim = 0
call infctr(m, ifact, ipower, nexp, npower)
do ip = 1,npower
   iexp(ip) = 0
end do
! Generate every divisor of M less than M/2
idiv = 1
mhalf = m/2
50 if (idiv.ge.mhalf) return
! The number of elements whose index is divisible by idiv
! and by no other divisor of M is the Euler totient
! function, phi(M/idiv).
ncount = m/idiv
do 60 ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 60
   ncount = (ncount/ifact(ip))*(ifact(ip) - 1)
60 continue
if (nwork.le.0) go to 75
do i = 1,nwork
   moved(i) = 0
end do
75 istart = idiv
! The starting point of a subcycle is divisible only by idiv
! and must not appear in any other subcycle.
80 mmist = m - istart
if (istart.eq.idiv) go to 120
ndim = max0(ndim,istart)
if (istart.gt.nwork) go to 90
if (moved(istart).ne.0) go to 160
90 isoid = istart/idiv
do 100 ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 100
   if (mod(isoid,ifact(ip)).eq.0) go to 160
100 continue
if (istart.le.nwork) go to 120
itest = istart
110 itest = mod(n*itest,m)
if (itest.lt.istart .or. itest.gt.mmist) go to 160
if (itest.gt.istart .and. itest.lt.mmist) go to 110
120 atemp = a(istart + 1)
btemp = a(mmist + 1)
ia1 = istart
130 ia2 = mod(n*ia1,m)
mmia1 = m - ia1
mmia2 = m - ia2
if (ia1.le.nwork) moved(ia1) = 1
if (mmia1.le.nwork) moved(mmia1) = 1
ncount = ncount - 2
! Move two elements, the second from the negative
! subcycle.  Check first for subcycle closure.
if (ia2.eq.istart) go to 140
if (mmia2.eq.istart) go to 150
a(ia1 + 1) = a(ia2 + 1)
a(mmia1 + 1) = a(mmia2 + 1)
ia1 = ia2
go to 130
140 a(ia1 + 1) = atemp
a(mmia1 + 1) = btemp
go to 160
150 a(ia1 + 1) = btemp
a(mmia1 + 1) = atemp
160 istart = istart + idiv
if (ncount.gt.0) go to 80
do ip = 1,npower
   if (iexp(ip).eq.nexp(ip)) go to 170
   iexp(ip) = iexp(ip) + 1
   idiv = idiv*ifact(ip)
   go to 50
170 iexp(ip) = 0
   idiv = idiv/ipower(ip)
end do
return
200 if (n1.ne.n2) ndim = 0
return
end subroutine ctip

pure subroutine infctr(n, ifact, ipower, nexp, npower)
implicit none
integer, intent(inout) :: ifact(*), ipower(*)
integer, intent(in) :: n
integer, intent(inout) :: nexp(*), npower
integer :: idiv, ifcur, ip, iquot, npart
! Factor n into its prime powers, npower in number.
! E.G., FOR n=1960=2**3 *5 *7**2, npower=3, ifact=2,5,7,
! ipower=8,5,49, AND nexp=3,1,2.
ip = 0
ifcur = 0
npart = n
idiv = 2
10 iquot = npart/idiv
if (npart - idiv*iquot) 60, 20, 60
20 if (idiv - ifcur) 40, 40, 30
30 ip = ip + 1
ifact(ip) = idiv
ipower(ip) = idiv
ifcur = idiv
nexp(ip) = 1
go to 50
40 ipower(ip) = idiv*ipower(ip)
nexp(ip) = nexp(ip) + 1
50 npart = iquot
go to 10
60 if (iquot - idiv) 100, 100, 70
70 if (idiv - 2) 80, 80, 90
80 idiv = 3
go to 10
90 idiv = idiv + 2
go to 10
100 if (npart - 1) 140, 140, 110
110 if (npart - ifcur) 130, 130, 120
120 ip = ip + 1
ifact(ip) = npart
ipower(ip) = npart
nexp(ip) = 1
go to 140
130 ipower(ip) = npart*ipower(ip)
nexp(ip) = nexp(ip) + 1
140 npower = ip
return
end subroutine infctr

pure subroutine cmadj(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,m)
integer :: i, j
!
do j = 1,n
   do 10 i = 1,m
10    b(j,i) = conjg(a(i,j))
end do
return
end subroutine cmadj

pure subroutine ctrans (nm, n, a)
implicit none
!
!
!     Subroutine ctrans finds the complex conjugate of an input
!     matrix.
!
!
!     On entry,
!
!     nm is the leading dimension of matrix a in the main program.
!
!     n  is the order of matrix a.
!
!     A  is the input matrix.
!
!
!     On return,
!
!     A  contains its conjugate transpose.
!
!
integer, intent(in) :: n, nm
complex, intent(inout) :: a(nm,n)
integer :: i, j
complex :: temp
!
do i = 1,n
   do j = i,n
      temp = a(i,j)
      a(i,j) = conjg(a(j,i))
      a(j,i) = conjg(temp)
   end do
end do
return
end subroutine ctrans

pure subroutine madd (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                      Addition of real matrices
!-----------------------------------------------------------------------
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
return
end subroutine madd

pure subroutine dmadd (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                Addition of double precision matrices
!-----------------------------------------------------------------------
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
return
end subroutine dmadd

pure subroutine cmadd (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                   Addition of complex matrices
!-----------------------------------------------------------------------
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
return
end subroutine cmadd

pure subroutine smadd(n,a,b,c)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: k, m
m = (n*(n + 1))/2
do 10 k = 1,m
10 c(k) = a(k) + b(k)
return
end subroutine smadd

pure subroutine msubt (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                     Subtraction of real matrices
!-----------------------------------------------------------------------
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
return
end subroutine msubt

pure subroutine dmsubt (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!              Subtraction of double precision matrices
!-----------------------------------------------------------------------
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
return
end subroutine dmsubt

pure subroutine cmsubt (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
integer :: i, j
!-----------------------------------------------------------------------
!                  Subtraction of complex matrices
!-----------------------------------------------------------------------
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
return
end subroutine cmsubt

pure subroutine smsubt(n,a,b,c)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
integer :: k, m
m = (n*(n + 1))/2
do 10 k = 1,m
10 c(k) = a(k) - b(k)
return
end subroutine smsubt

pure subroutine mtms (m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
integer :: i, j, k
double precision :: w
!-----------------------------------------------------------------------
!                     Product of real matrices
!-----------------------------------------------------------------------
!
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + dble(a(i,k))*dble(b(k,j))
      end do
      c(i,j) = w
   end do
end do
return
end subroutine mtms

pure subroutine dmtms (m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,l)
integer :: i, j, k
double precision :: w
!-----------------------------------------------------------------------
!                Product of double precision matrices
!-----------------------------------------------------------------------
!
do j = 1,l
   do i = 1,m
      w = 0.d0
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      c(i,j) = w
   end do
end do
return
end subroutine dmtms

pure subroutine cmtms (m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,l)
integer :: i, j, k
complex :: w
!-----------------------------------------------------------------------
!                   Product of complex matrices
!-----------------------------------------------------------------------
!
do j = 1,l
   do i = 1,m
      w = (0.0,0.0)
      do k = 1,n
         w = w + a(i,k)*b(k,j)
      end do
      c(i,j) = w
   end do
end do
return
end subroutine cmtms

subroutine mprod (m, n, l, a, ka, b, kb, c, kc, row)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
integer :: i, j, k
real :: save
double precision :: w
logical :: rloc
!-----------------------------------------------------------------------
!                     Product of real matrices
!-----------------------------------------------------------------------
!
save = c(1,1)
c(1,1) = 1.0
if (rloc(c,a)) go to 20
if (rloc(c,b)) go to 30
!
do j = 1,l
   do 11 i = 1,m
      w = 0.d0
      do 10 k = 1,n
10       w = w + dble(a(i,k))*dble(b(k,j))
11    c(i,j) = w
end do
return
!
!     Here c begins in the same location as A. the dimension of row
!     must be greater than or equal to l. it is assumed that kc=ka.
!
20 a(1,1) = save
do i = 1,m
   do 22 j = 1,l
      w = 0.d0
      do 21 k = 1,n
21       w = w + dble(a(i,k))*dble(b(k,j))
22    row(j) = w
   do 23 j = 1,l
23    a(i,j) = row(j)
end do
return
!
!     Here c begins in the same location as b. the dimension of row
!     must be greater than or equal to m. it is assumed that kc=kb.
!
30 b(1,1) = save
do j = 1,l
   do 32 i = 1,m
      w = 0.d0
      do 31 k = 1,n
31       w = w + dble(a(i,k))*dble(b(k,j))
32    row(i) = w
   do 33 i = 1,m
33    b(i,j) = row(i)
end do
return
end subroutine mprod

logical function rloc (x, y)
implicit none
real, intent(in) :: x(*)
real, intent(inout) :: y(*)
real :: xold, yold
!-----------------------------------------------------------------------
!     x and y are arrays. It is assumed that x(1) and y(1) contain data.
!
!     rloc(x,y) = .TRUE.   if x and y begin in the same location
!     rloc(x,y) = .FALSE.  if x and y begin in different locations
!
!     It is recommended that this coding not be optimized by eliminating
!     the subroutine ychg. If it is optimized then rloc may not compile
!     properly.
!-----------------------------------------------------------------------
!
xold = x(1)
yold = y(1)
call ychg(x,y,yold)
if (x(1) .eq. xold) go to 10
!
!     x and y begin in the same location
!
y(1) = yold
rloc = .true.
return
!
!     x and y begin in different locations
!
10 y(1) = yold
rloc = .false.
return
end function rloc

pure subroutine ychg (x, y, yold)
implicit none
real, intent(in) :: yold
real, intent(in) :: x(*)
real, intent(inout) :: y(*)
!
y(1) = 0.0
if (yold .eq. 0.0) y(1) = 1.0
return
end subroutine ychg

subroutine dmprod (m, n, l, a, ka, b, kb, c, kc, row)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
double precision, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), &
   & row(*)
integer :: i, j, k
double precision :: w
logical :: dloc
!-----------------------------------------------------------------------
!                Product of double precision matrices
!-----------------------------------------------------------------------
!
w = c(1,1)
c(1,1) = 1.d0
if (dloc(c,a)) go to 20
if (dloc(c,b)) go to 30
!
do j = 1,l
   do 11 i = 1,m
      w = 0.d0
      do 10 k = 1,n
10       w = w + a(i,k)*b(k,j)
11    c(i,j) = w
end do
return
!
!     Here c begins in the same location as A. the dimension of row
!     must be greater than or equal to l. it is assumed that kc=ka.
!
20 a(1,1) = w
do i = 1,m
   do 22 j = 1,l
      w = 0.d0
      do 21 k = 1,n
21       w = w + a(i,k)*b(k,j)
22    row(j) = w
   do 23 j = 1,l
23    a(i,j) = row(j)
end do
return
!
!     Here c begins in the same location as b. the dimension of row
!     must be greater than or equal to m. it is assumed that kc=kb.
!
30 b(1,1) = w
do j = 1,l
   do 32 i = 1,m
      w = 0.d0
      do 31 k = 1,n
31       w = w + a(i,k)*b(k,j)
32    row(i) = w
   do 33 i = 1,m
33    b(i,j) = row(i)
end do
return
end subroutine dmprod

logical function dloc (x, y)
implicit none
!-----------------------------------------------------------------------
!     x and y are arrays. It is assumed that x(1) and y(1) contain data.
!
!     dloc(x,y) = .TRUE.   if x and y begin in the same location
!     dloc(x,y) = .FALSE.  if x and y begin in different locations
!
!     It is recommended that this coding not be optimized by eliminating
!     the subroutine dychg. If it is optimized then dloc may not compile
!     properly.
!-----------------------------------------------------------------------
double precision, intent(in) :: x(*)
double precision, intent(inout) :: y(*)
double precision :: xold, yold
!
xold = x(1)
yold = y(1)
call dychg(x,y,yold)
if (x(1) .eq. xold) go to 10
!
!     x and y begin in the same location
!
y(1) = yold
dloc = .true.
return
!
!     x and y begin in different locations
!
10 y(1) = yold
dloc = .false.
return
end function dloc

pure subroutine dychg (x, y, yold)
implicit none
double precision, intent(in) :: x(*)
double precision, intent(inout) :: y(*)
double precision, intent(in) :: yold
!
y(1) = 0.d0
if (yold .eq. 0.d0) y(1) = 1.d0
return
end subroutine dychg

subroutine cmprod (m, n, l, a, ka, b, kb, c, kc, row)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
complex, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
integer :: i, j, k
complex :: w
logical :: cloc
!-----------------------------------------------------------------------
!                   Product of complex matrices
!-----------------------------------------------------------------------
!
w = c(1,1)
c(1,1) = (1.0,0.0)
if (cloc(c,a)) go to 20
if (cloc(c,b)) go to 30
!
do j = 1,l
   do 11 i = 1,m
      w = (0.0,0.0)
      do 10 k = 1,n
10       w = w + a(i,k)*b(k,j)
11    c(i,j) = w
end do
return
!
!     Here c begins in the same location as A. the dimension of row
!     must be greater than or equal to l. it is assumed that kc=ka.
!
20 a(1,1) = w
do i = 1,m
   do 22 j = 1,l
      w = (0.0,0.0)
      do 21 k = 1,n
21       w = w + a(i,k)*b(k,j)
22    row(j) = w
   do 23 j = 1,l
23    a(i,j) = row(j)
end do
return
!
!     Here c begins in the same location as b. the dimension of row
!     must be greater than or equal to m. it is assumed that kc=kb.
!
30 b(1,1) = w
do j = 1,l
   do 32 i = 1,m
      w = (0.0,0.0)
      do 31 k = 1,n
31       w = w + a(i,k)*b(k,j)
32    row(i) = w
   do 33 i = 1,m
33    b(i,j) = row(i)
end do
return
end subroutine cmprod

logical function cloc (x, y)
implicit none
!-----------------------------------------------------------------------
!     x and y are arrays. It is assumed that x(1) and y(1) contain data.
!
!     cloc(x,y) = .TRUE.   if x and y begin in the same location
!     cloc(x,y) = .FALSE.  if x and y begin in different locations
!
!     It is recommended that this coding not be optimized by eliminating
!     the subroutine cychg. If it is optimized then cloc may not compile
!     properly.
!-----------------------------------------------------------------------
complex, intent(in) :: x(*)
complex, intent(inout) :: y(*)
complex :: xold, yold
!
xold = x(1)
yold = y(1)
call cychg(x,y,yold)
if (x(1) .eq. xold) go to 10
!
!     x and y begin in the same location
!
y(1) = yold
cloc = .true.
return
!
!     x and y begin in different locations
!
10 y(1) = yold
cloc = .false.
return
end function cloc

pure subroutine cychg (x, y, yold)
implicit none
complex, intent(in) :: x(*)
complex, intent(inout) :: y(*)
complex, intent(in) :: yold
complex, parameter :: zero = (0.0,0.0)
complex, parameter :: one = (1.0,0.0)
!
y(1) = zero
if (yold .eq. zero) y(1) = one
return
end subroutine cychg

pure subroutine svprd(a,n,x,y)
implicit none
integer, intent(in) :: n
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(n)
integer :: i, k, km1, l
real :: xk, yk
y(1) = a(1)*x(1)
if (n .eq. 1) return
!
l = 1
do 20 k = 2,n
   km1 = k - 1
   xk = x(k)
   yk = 0.0
!
   do 10 i = 1,km1
      l = l + 1
      y(i) = y(i) + a(l)*xk
10    yk = yk + a(l)*x(i)
!
   l = l + 1
20 y(k) = yk + a(l)*xk
return
end subroutine svprd

pure subroutine dsvprd(a,n,x,y)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(n)
integer :: i, k, km1, l
double precision :: xk, yk
y(1) = a(1)*x(1)
if (n .eq. 1) return
!
l = 1
do 20 k = 2,n
   km1 = k - 1
   xk = x(k)
   yk = 0.d0
!
   do 10 i = 1,km1
      l = l + 1
      y(i) = y(i) + a(l)*xk
10    yk = yk + a(l)*x(i)
!
   l = l + 1
20 y(k) = yk + a(l)*xk
return
end subroutine dsvprd

pure subroutine tmprod(m,n,l,a,ka,b,kb,c,kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
integer :: i, j, k
double precision :: s
do j = 1,l
   do 11 i = 1,n
      s = 0.d0
      do 10 k = 1,m
10       s = s + dble(a(k,i))*dble(b(k,j))
11    c(i,j) = s
end do
return
end subroutine tmprod

pure subroutine smprod(m,n,a,ka,b)
implicit none
integer, intent(in) :: ka, m, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
integer :: i, ii, j, k
double precision :: s
ii = 1
do i = 1,n
   do 11 j = 1,i
      s = 0.d0
      do 10 k = 1,m
10       s = s + dble(a(k,i))*dble(a(k,j))
      b(ii) = s
11    ii = ii + 1
end do
return
end subroutine smprod

pure subroutine kprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,*)
integer :: i, ii, j, jj
integer :: r, s
!     ******************************************************************
!     Kronecker product of real matrices A and b
!     ******************************************************************
!
j = 0
do s = 1,n
   do jj = 1,l
      j = j + 1
!
!        Compute the j-TH column of c
!
      i = 0
      do r = 1,m
         do 10 ii = 1,k
            i = i + 1
10          c(i,j) = a(r,s)*b(ii,jj)
      end do
!
   end do
end do
return
end subroutine kprod

pure subroutine dkprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,*)
integer :: i, ii, j, jj
integer :: r, s
!     ******************************************************************
!     Kronecker product of double precision matrices A and b
!     ******************************************************************
!
j = 0
do s = 1,n
   do jj = 1,l
      j = j + 1
!
!        Compute the j-TH column of c
!
      i = 0
      do r = 1,m
         do 10 ii = 1,k
            i = i + 1
10          c(i,j) = a(r,s)*b(ii,jj)
      end do
!
   end do
end do
return
end subroutine dkprod

pure subroutine ckprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,*)
integer :: i, ii, j, jj
integer :: r, s
!     ******************************************************************
!     Kronecker product of complex matrices A and b
!     ******************************************************************
!
j = 0
do s = 1,n
   do jj = 1,l
      j = j + 1
!
!        Compute the j-TH column of c
!
      i = 0
      do r = 1,m
         do 10 ii = 1,k
            i = i + 1
10          c(i,j) = a(r,s)*b(ii,jj)
      end do
!
   end do
end do
return
end subroutine ckprod

pure subroutine rnk (a, mda, m, n, re, ae, krank, ksure, work, iwork)
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
real, intent(in) :: ae, re
real, intent(inout) :: a(mda,n), work(*)
integer, intent(inout) :: iwork(*)
integer :: i, imax, m0, m1, m2, m3, m4, m5
real :: eps, rerr
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
   pure subroutine u11ls(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
      & ic,ir)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      real, intent(inout) :: a(mda,n)
      real, intent(inout) :: ub(n)
      real, intent(inout) :: db(n)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      real, intent(inout) :: h(n)
      real, intent(inout) :: w(n)
      real, intent(inout) :: eb(n)
      integer, intent(inout) :: ic(n)
      integer, intent(inout) :: ir(m)
   end subroutine u11ls
   pure subroutine u11us(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
      & ir,ic)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      real, intent(inout) :: a(mda,n)
      real, intent(inout) :: ub(m)
      real, intent(inout) :: db(m)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      real, intent(inout) :: h(m)
      real, intent(inout) :: w(m)
      real, intent(inout) :: eb(m)
      integer, intent(inout) :: ir(m)
      integer, intent(inout) :: ic(n)
   end subroutine u11us
end interface
!-----------------------------------------------------------------------
!
!          Upper and lower bounds of the rank of a real matrix
!
!-----------------------------------------------------------------------
!     real work(5*m0)  where m0 = 5*min0(m,n)
!     integer iwork(m + n)
!--------------------
!
m0 = min0(m,n)
!
!     Define the relative and absolute tolerance lists
!
m1 = 1
m2 = m1 + m0
m3 = m2 + m0
m4 = m3 + m0
m5 = m4 + m0
!
eps = 10.0*spmpar(1)
rerr = amax1(eps,re)
!
imax = m5 - 1
do i = m4,imax
   work(i) = rerr
end do
imax = imax + m0
do i = m5,imax
   work(i) = ae
end do
!
!     Factor the matrix a
!
if (m .lt. n) go to 40
!
call u11ls (a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
!
40 call u11us (a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
end subroutine rnk

pure subroutine drnk (a, mda, m, n, re, ae, krank, ksure, work, iwork)
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
double precision, intent(inout) :: a(mda,n)
double precision, intent(in) :: re, ae
double precision, intent(inout) :: work(*)
integer, intent(inout) :: iwork(*)
integer :: i, imax, m0, m1, m2, m3, m4, m5
double precision :: eps, rerr
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure subroutine du11ls(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb &
      & ,ic,ir)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      double precision, intent(inout) :: a(mda,n)
      double precision, intent(inout) :: ub(n)
      double precision, intent(inout) :: db(n)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      double precision, intent(inout) :: h(n)
      double precision, intent(inout) :: w(n)
      double precision, intent(inout) :: eb(n)
      integer, intent(inout) :: ic(n)
      integer, intent(inout) :: ir(m)
   end subroutine du11ls
   pure subroutine du11us(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb &
      & ,ir,ic)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      double precision, intent(inout) :: a(mda,n)
      double precision, intent(inout) :: ub(m)
      double precision, intent(inout) :: db(m)
      integer, intent(in) :: mode
      integer, intent(in) :: np
      integer, intent(out) :: krank
      integer, intent(inout) :: ksure
      double precision, intent(inout) :: h(m)
      double precision, intent(inout) :: w(m)
      double precision, intent(inout) :: eb(m)
      integer, intent(inout) :: ir(m)
      integer, intent(inout) :: ic(n)
   end subroutine du11us
end interface
!-----------------------------------------------------------------------
!
!              Upper and lower bounds of the rank of A
!                      double precision matrix
!
!-----------------------------------------------------------------------
!     double precision work(5*m0)  where m0 = 5*min0(m,n)
!     integer iwork(m + n)
!--------------------
!
m0 = min0(m,n)
!
!     Define the relative and absolute tolerance lists
!
m1 = 1
m2 = m1 + m0
m3 = m2 + m0
m4 = m3 + m0
m5 = m4 + m0
!
eps = 10.d0*dpmpar(1)
rerr = dmax1(eps,re)
!
imax = m5 - 1
do i = m4,imax
   work(i) = rerr
end do
imax = imax + m0
do i = m5,imax
   work(i) = ae
end do
!
!     Factor the matrix a
!
if (m .lt. n) go to 40
!
call du11ls (a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
!
40 call du11us (a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
end subroutine drnk

pure subroutine crout(mo,n,m,a,ka,b,kb,d,index,temp)
implicit none
integer, intent(inout) :: index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), d, temp(*)
integer :: i, im1, j, jp1, k, kj, km1, kp1, l, lj, maxb, nj, nm1, &
   & nmj, nmk
real :: p, t
integer :: onej
double precision :: dsum
!-----------------------------------------------------------------------
!     crout procedure for inverting matrices and solving equations
!-----------------------------------------------------------------------
!     A is a matrix of order n where n is greater than or equal to 1.
!     If mo=0 Then the inverse of A is computed and stored in A. if mo
!     is not 0 then the inverse is not computed.
!
!     If m is greater than 0 then b is a matrix having n rows and m
!     columns. In this case AX=b is solved and the solution X is stored
!     in b. if m=0 Then there are no equations to be solved.
!
!     ka = The length of the columns of the array a
!     kb = The length of the columns of the array b (if m.GT.0)
!
!     The determinant d of A is always computed. If d=0 Then the
!     routine immediately terminates.
!
!     Index is an array of dimension n-1 or larger that is used by the
!     routine for keeping track of the row interchanges that are made.
!     If mo is not 0 then this array is not needed.
!
!     Temp is an array of dimension n or larger that is used when A
!     is inverted. If mo is not 0 then this array is not needed.
!-----------------------------------------------------------------------
!
if (n .lt. 2) go to 200
d = 1.0
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!
!               Search for the k-TH pivot element
!
   p = abs(a(k,k))
   l = k
   do 10 i = kp1,n
      t = abs(a(i,k))
      if (p .ge. t) go to 10
      p = t
      l = i
10    continue
!
   p = a(l,k)
   d = p*d
   if (d .eq. 0.0) return
   if (mo .eq. 0) index(k) = l
   if (k .eq. l) go to 40
   d = -d
!
!                  Interchanging rows k and l
!
   do 20 j = 1,n
      t = a(k,j)
      a(k,j) = a(l,j)
20    a(l,j) = t
!
   if (m .le. 0) go to 40
   kj = k
   lj = l
   do 30 j = 1,m
      t = b(kj)
      b(kj) = b(lj)
      b(lj) = t
      kj = kj + kb
30    lj = lj + kb
!
!                  Compute the k-TH row of U
!
40 if (k .gt. 1) go to 50
   do 41 j = kp1,n
41    a(k,j) = a(k,j)/p
   go to 60
!
50 do j = kp1,n
      dsum = a(k,j)
      do 51 l = 1,km1
51       dsum = dsum - dble(a(k,l))*dble(a(l,j))
      a(k,j) = sngl(dsum)/p
   end do
!
!               Compute the (k+1)-ST column of l
!
60 do i = kp1,n
      dsum = a(i,kp1)
      do 61 l = 1,k
61       dsum = dsum - dble(a(i,l))*dble(a(l,kp1))
      a(i,kp1) = dsum
   end do
!
   km1 = k
end do
!
!                 Check the n-TH pivot element
!
d = a(n,n)*d
if (d .eq. 0.0) return
!
!                 Solving the equation LY = b
!
if (m .le. 0) go to 120
maxb = kb*m
do onej = 1,maxb,kb
   kj = onej
   b(kj) = b(kj)/a(1,1)
   do 101 k = 2,n
      kj = kj + 1
      dsum = b(kj)
      km1 = k - 1
      lj = onej
      do 100 l = 1,km1
         dsum = dsum - dble(a(k,l))*dble(b(lj))
100      lj = lj + 1
101   b(kj) = sngl(dsum)/a(k,k)
end do
!
!                 Solving the equation UX = Y
!
do nj = n,maxb,kb
   kj = nj
   do nmk = 1,nm1
      k = n - nmk
      lj = kj
      kj = kj - 1
      dsum = b(kj)
      kp1 = k + 1
      do 110 l = kp1,n
         dsum = dsum - dble(a(k,l))*dble(b(lj))
110      lj = lj + 1
      b(kj) = dsum
   end do
end do
!
!               Replace l with the inverse of l
!
120 if (mo .ne. 0) return
do j = 1,nm1
   a(j,j) = 1.0/a(j,j)
   jp1 = j + 1
   do 131 i = jp1,n
      dsum = 0.d0
      im1 = i - 1
      do 130 l = j,im1
130      dsum = dsum + dble(a(i,l))*dble(a(l,j))
131   a(i,j) = -sngl(dsum)/a(i,i)
end do
a(n,n) = 1.0/a(n,n)
!
!           Solve UX = Y where Y is the inverse of l
!
do nmk = 1,nm1
   k = n - nmk
   kp1 = k + 1
   do 140 j = kp1,n
      temp(j) = a(k,j)
140   a(k,j) = 0.0
!
   do j = 1,n
      dsum = a(k,j)
      do 150 l = kp1,n
150      dsum = dsum - dble(temp(l))*dble(a(l,j))
      a(k,j) = dsum
   end do
end do
!
!                    Column interchanges
!
do 161 nmj = 1,nm1
   j = n - nmj
   k = index(j)
   if (j .eq. k) go to 161
   do 160 i = 1,n
      t = a(i,j)
      a(i,j) = a(i,k)
160   a(i,k) = t
161 continue
return
!
!                      Case when n = 1
!
200 d = a(1,1)
if (d .eq. 0.0) return
if (mo .eq. 0) a(1,1) = 1.0/d
!
if (m .le. 0) return
maxb = kb*m
do 210 kj = 1,maxb,kb
210 b(kj) = b(kj)/d
return
end subroutine crout

pure subroutine krout(mo,n,m,a,ka,b,kb,ierr,index,temp)
implicit none
integer, intent(inout) :: ierr, index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), temp(*)
integer :: i, im1, j, jp1, k, kj, km1, kp1, l, lj, maxb, nj, nm1, &
   & nmj, nmk
real :: d, p, t
integer :: onej
double precision :: dsum
!-----------------------------------------------------------------------
!     crout procedure for inverting matrices and solving equations
!-----------------------------------------------------------------------
!     A is a matrix of order n where n is greater than or equal to 1.
!     If mo=0 Then the inverse of A is computed and stored in A. if mo
!     is not 0 then the inverse is not computed.
!
!     If m is greater than 0 then b is a matrix having n rows and m
!     columns. In this case AX=b is solved and the solution X is stored
!     in b. if m=0 Then there are no equations to be solved.
!
!     ka = The length of the columns of the array a
!     kb = The length of the columns of the array b (if m.GT.0)
!
!     ierr is a variable that reports the status of the results. When
!     the routine terminates ierr has one of the following values ...
!        ierr =  0   The requested task was performed.
!        ierr = -1   Either n, ka, or kb is incorrect.
!        ierr =  k   the k-TH pivot element is 0.
!
!     Index is an array of dimension n-1 or larger that is used by the
!     routine for keeping track of the row interchanges that are made.
!     If mo is not 0 then this array is not needed.
!
!     Temp is an array of dimension n or larger that is used when A
!     is inverted. If mo is not 0 then this array is not needed.
!-----------------------------------------------------------------------
!
if (n .lt. 1 .or. ka .lt. n) go to 320
if (m .le. 0) go to 5
if (kb .lt. n) go to 320
!
5 ierr = 0
if (n .lt. 2) go to 200
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!
!               Search for the k-TH pivot element
!
   p = abs(a(k,k))
   l = k
   do 10 i = kp1,n
      t = abs(a(i,k))
      if (p .ge. t) go to 10
      p = t
      l = i
10    continue
   if (p .eq. 0.0) go to 300
!
   p = a(l,k)
   if (mo .eq. 0) index(k) = l
   if (k .eq. l) go to 40
!
!                  Interchanging rows k and l
!
   do 20 j = 1,n
      t = a(k,j)
      a(k,j) = a(l,j)
20    a(l,j) = t
!
   if (m .le. 0) go to 40
   kj = k
   lj = l
   do 30 j = 1,m
      t = b(kj)
      b(kj) = b(lj)
      b(lj) = t
      kj = kj + kb
30    lj = lj + kb
!
!                  Compute the k-TH row of U
!
40 if (k .gt. 1) go to 50
   do 41 j = kp1,n
41    a(k,j) = a(k,j)/p
   go to 60
!
50 do j = kp1,n
      dsum = a(k,j)
      do 51 l = 1,km1
51       dsum = dsum - dble(a(k,l))*dble(a(l,j))
      a(k,j) = sngl(dsum)/p
   end do
!
!               Compute the (k+1)-ST column of l
!
60 do i = kp1,n
      dsum = a(i,kp1)
      do 61 l = 1,k
61       dsum = dsum - dble(a(i,l))*dble(a(l,kp1))
      a(i,kp1) = dsum
   end do
!
   km1 = k
end do
!
!                 Check the n-TH pivot element
!
if (a(n,n) .eq. 0.0) go to 310
!
!                 Solving the equation LY = b
!
if (m .le. 0) go to 120
maxb = kb*m
do onej = 1,maxb,kb
   kj = onej
   b(kj) = b(kj)/a(1,1)
   do 101 k = 2,n
      kj = kj + 1
      dsum = b(kj)
      km1 = k - 1
      lj = onej
      do 100 l = 1,km1
         dsum = dsum - dble(a(k,l))*dble(b(lj))
100      lj = lj + 1
101   b(kj) = sngl(dsum)/a(k,k)
end do
!
!                 Solving the equation UX = Y
!
do nj = n,maxb,kb
   kj = nj
   do nmk = 1,nm1
      k = n - nmk
      lj = kj
      kj = kj - 1
      dsum = b(kj)
      kp1 = k + 1
      do 110 l = kp1,n
         dsum = dsum - dble(a(k,l))*dble(b(lj))
110      lj = lj + 1
      b(kj) = dsum
   end do
end do
!
!               Replace l with the inverse of l
!
120 if (mo .ne. 0) return
do j = 1,nm1
   a(j,j) = 1.0/a(j,j)
   jp1 = j + 1
   do 131 i = jp1,n
      dsum = 0.d0
      im1 = i - 1
      do 130 l = j,im1
130      dsum = dsum + dble(a(i,l))*dble(a(l,j))
131   a(i,j) = -sngl(dsum)/a(i,i)
end do
a(n,n) = 1.0/a(n,n)
!
!           Solve UX = Y where Y is the inverse of l
!
do nmk = 1,nm1
   k = n - nmk
   kp1 = k + 1
   do 140 j = kp1,n
      temp(j) = a(k,j)
140   a(k,j) = 0.0
!
   do j = 1,n
      dsum = a(k,j)
      do 150 l = kp1,n
150      dsum = dsum - dble(temp(l))*dble(a(l,j))
      a(k,j) = dsum
   end do
end do
!
!                    Column interchanges
!
do 161 nmj = 1,nm1
   j = n - nmj
   k = index(j)
   if (j .eq. k) go to 161
   do 160 i = 1,n
      t = a(i,j)
      a(i,j) = a(i,k)
160   a(i,k) = t
161 continue
return
!
!                      Case when n = 1
!
200 d = a(1,1)
if (d .eq. 0.0) go to 310
if (mo .eq. 0) a(1,1) = 1.0/d
!
if (m .le. 0) return
maxb = kb*m
do 210 kj = 1,maxb,kb
210 b(kj) = b(kj)/d
return
!
!                  k-TH pivot element is 0
!
300 ierr = k
return
310 ierr = n
return
!
!                        Input error
!
320 ierr = -1
return
end subroutine krout

pure subroutine dec (n, ndim, a, ip, ier)
implicit none
!-----------------------------------------------------------------------
! Matrix triangularization by Gaussian elimination.
! Input..
!    n = Order of matrix.
!    ndim = Declared dimension of array  a .
!    a = Matrix to be triangularized.
! Output..
!    a(i,j), i.LE.j = Upper triangular factor, U .
!    a(i,j), i.GT.j = Multipliers = Lower triangular factor, i - L.
!    ip(k), k.LT.n = Index of k-TH pivot row.
!    ip(n) = (-1)**(number of interchanges) or O .
!    ier = 0 If a nonsingular, or k if a found to be
!          singular at stage k.
! Use  sol  to obtain solution of linear system.
! determ(a) = ip(n)*a(1,1)*a(2,2)*...*a(n,n).
! If ip(n)=0, A is singular, sol will divide by zero.
! Interchanges finished in U , only partly in L .
!
! Reference..
! C. B. Moler, algorithm 423, linear equation solver,
! comm. Assoc. COMPUT. Mach., 15 (1972), P. 274.
!-----------------------------------------------------------------------
integer, intent(out) :: ier
integer, intent(inout) :: ip
integer, intent(in) :: n, ndim
real, intent(inout) :: a(ndim,n)
integer :: i, j, k, kp1, m, nm1
real :: t
dimension ip(n)
!
ier = 0
ip(n) = 1
if (n .eq. 1) go to 70
nm1 = n - 1
do k = 1,nm1
   kp1 = k + 1
!  Find the pivot in column k.  search rows k to n. --------------------
   m = k
   do 10 i = kp1,n
10    if (abs(a(i,k)) .gt. abs(a(m,k))) m = i
   ip(k) = m
!  Interchange elements in rows k and m. -------------------------------
   t = a(m,k)
   if (m .eq. k) go to 20
   ip(n) = -ip(n)
   a(m,k) = a(k,k)
   a(k,k) = t
20 if (t .eq. 0.0) go to 80
!  Store multipliers in a(i,k), i = k+1,...,n. -------------------------
   t = 1.0/t
   do 30 i = kp1,n
30    a(i,k) = -a(i,k)*t
!  Apply multipliers to other columns of A. ----------------------------
   do 50 j = kp1,n
      t = a(m,j)
      a(m,j) = a(k,j)
      a(k,j) = t
      if (t .eq. 0.0) go to 50
      do 40 i = kp1,n
40       a(i,j) = a(i,j) + a(i,k)*t
50    continue
end do
70 k = n
if (a(n,n) .eq. 0.0) go to 80
return
80 ier = k
ip(n) = 0
return
end subroutine dec

subroutine sol (n, ndim, a, b, ip)
implicit none
!-----------------------------------------------------------------------
! Solution of linear system, a*X = b .
! Input..
!   n = Order of matrix.
!   ndim = Declared dimension of array  a .
!   a = Triangularized matrix obtained from DEC.
!   b = Right hand side vector.
!   ip = Pivot vector obtained from DEC.
! Do not use if DEC has set ier .NE. 0.
! Output..
!   b = Solution vector, X .
!-----------------------------------------------------------------------
integer :: ip
integer, intent(in) :: n, ndim
real :: a(ndim, n)
real, intent(inout) :: b(n)
integer :: i, k, kb, km1, kp1, m, nm1
real :: t
dimension ip(n)
!
if (n .eq. 1) go to 50
nm1 = n - 1
!  Apply row permutations and multipliers to b. ------------------------
do k = 1,nm1
   kp1 = k + 1
   m = ip(k)
   t = b(m)
   b(m) = b(k)
   b(k) = t
   do 10 i = kp1,n
10    b(i) = b(i) + a(i,k)*t
end do
!  Back solve. ---------------------------------------------------------
do kb = 1,nm1
   km1 = n - kb
   k = km1 + 1
   b(k) = b(k)/a(k,k)
   t = -b(k)
   do 30 i = 1,km1
30    b(i) = b(i) + a(i,k)*t
end do
50 b(1) = b(1)/a(1,1)
return
end subroutine sol

pure subroutine npivot (n, m, a, ka, b, kb, d, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(inout) :: d
real, intent(inout) :: a(ka,n), b(*)
integer :: j, jl, k, kl, l, maxb
real :: pivot, t
!-----------------------------------------------------------------------
!     Matrix inversion/equation solving without pivot search
!-----------------------------------------------------------------------
!
ierr = 0
maxb = kb*m
do k = 1,n
!
!     Examine the pivot element
!
   pivot = a(k,k)
   d = d*pivot
   if (pivot .ne. 0.0) go to 10
   ierr = 1
   return
!
!     Divide the pivot row by the pivot element
!
10 a(k,k) = 1.0
   do l = 1,n
      a(k,l) = a(k,l)/pivot
   end do
   if (m .le. 0) go to 40
!
   do kl = k,maxb,kb
      b(kl) = b(kl)/pivot
   end do
!
!     Reduce the non-pivot rows
!
40 do 70 j = 1,n
      if (j .eq. k) go to 70
      t = a(j,k)
      a(j,k) = 0.0
      do l = 1,n
         a(j,l) = a(j,l) - a(k,l)*t
      end do
      if (m .le. 0) go to 70
!
      kl = k
      do jl = j,maxb,kb
         b(jl) = b(jl) - b(kl)*t
         kl = kl + kb
      end do
70    continue
!
end do
return
end subroutine npivot

pure subroutine slv (n, m, a, ka, b, kb, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(inout) :: a(ka,n), b(kb,m)
integer :: i, ip1, j, jp1, k, l, nm1
real :: p, sum, t
!     ------------------------------------------------------------------
!     Partial pivot solution of a*X = b where A is a matrix of
!     order n and b is a matrix having n rows and m columns.
!     The solution matrix X is stored in b.
!
!     ierr is a variable that reports the status of the results.
!        ierr = 0   The equations have been solved.
!        ierr = j   the j-TH pivot element was found to be 0.
!     ------------------------------------------------------------------
ierr = 0
nm1 = n - 1
if (nm1 .eq. 0) go to 140
do j = 1,nm1
!
!     Search for the j-TH pivot element
!
   p = 0.0
   do 10 i = j,n
      t = abs(a(i,j))
      if (t .le. p) go to 10
      p = t
      l = i
10    continue
   if (p .eq. 0.0) go to 210
   if (j .eq. l) go to 40
!
!     Interchange rows j and l
!
   do k = j,n
      t = a(j,k)
      a(j,k) = a(l,k)
      a(l,k) = t
   end do
   do k = 1,m
      t = b(j,k)
      b(j,k) = b(l,k)
      b(l,k) = t
   end do
!
!     Eliminate the coefficients of X(j) in rows i = j+1,...,n
!
40 p = a(j,j)
   jp1 = j + 1
   do i = jp1,n
      t = a(i,j)/p
      do 50 k = jp1,n
50       a(i,k) = a(i,k) - t*a(j,k)
      do 60 k = 1,m
60       b(i,k) = b(i,k) - t*b(j,k)
   end do
end do
if (a(n,n) .eq. 0.0) go to 220
!
!     Backsolve the triangular set of equations
!
do 100 j = 1,m
100 b(n,j) = b(n,j)/a(n,n)
!
do l = 1,nm1
   i = n - l
   ip1 = i + 1
   do 120 j = 1,m
      sum = b(i,j)
      do 110 k = ip1,n
110      sum = sum - a(i,k)*b(k,j)
120   b(i,j) = sum/a(i,i)
end do
return
!
!     Case when n = 1
!
140 if (a(1,1) .eq. 0.0) go to 200
do 150 j = 1,m
150 b(1,j) = b(1,j)/a(1,1)
return
!
!     Error return
!
200 ierr = 1
return
210 ierr = j
return
220 ierr = n
return
end subroutine slv

pure subroutine dpslv (n, m, a, ka, b, kb, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
double precision, intent(inout) :: a(ka,n), b(kb,m)
integer :: i, j, k, km1, kp1, l, nm1
double precision :: p, t
!     ------------------------------------------------------------------
!     Partial pivot solution of a*X = b where A is a matrix of
!     order n and b is a matrix having n rows and m columns.
!     The solution matrix X is stored in b.
!
!     ierr is a variable that reports the status of the results.
!        ierr = 0   The equations have been solved.
!        ierr = j   the j-TH pivot element was found to be 0.
!     ------------------------------------------------------------------
ierr = 0
nm1 = n - 1
if (nm1 .eq. 0) go to 140
do k = 1,nm1
!
!     Search for the k-TH pivot element
!
   p = 0.d0
   do 10 i = k,n
      t = dabs(a(i,k))
      if (p .ge. t) go to 10
      p = t
      l = i
10    continue
   if (p .eq. 0.d0) go to 210
   if (k .eq. l) go to 40
!
!     Interchange rows k and l
!
   do j = k,n
      t = a(k,j)
      a(k,j) = a(l,j)
      a(l,j) = t
   end do
   do j = 1,m
      t = b(k,j)
      b(k,j) = b(l,j)
      b(l,j) = t
   end do
!
!     Eliminate the coefficients of X(k) in rows i = k+1,...,n
!
40 p = a(k,k)
   kp1 = k + 1
   do i = kp1,n
      t = a(i,k)/p
      do 50 j = kp1,n
50       a(i,j) = a(i,j) - t*a(k,j)
      do 60 j = 1,m
60       b(i,j) = b(i,j) - t*b(k,j)
   end do
end do
if (a(n,n) .eq. 0.d0) go to 220
!
!     Backsolve the triangular set of equations
!
do 120 j = 1,m
   k = n
   km1 = nm1
   do 110 l = 2,n
      b(k,j) = b(k,j)/a(k,k)
      t = b(k,j)
      do 100 i = 1,km1
100      b(i,j) = b(i,j) - t*a(i,k)
      k = km1
110   km1 = k - 1
120 b(1,j) = b(1,j)/a(1,1)
return
!
!     Case when n = 1
!
140 if (a(1,1) .eq. 0.d0) go to 200
do 150 j = 1,m
150 b(1,j) = b(1,j)/a(1,1)
return
!
!     Error return
!
200 ierr = 1
return
210 ierr = k
return
220 ierr = n
return
end subroutine dpslv

subroutine mslv (mo,n,m,a,ka,b,kb,det,rcond,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*)
real, intent(inout) :: det(2), rcond
real, intent(inout) :: wk(n)
integer, intent(inout) :: ipvt(n)
integer :: j, job
real :: t
integer :: onej
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting real matrices
!     and solving real equations
!-----------------------------------------------------------------------
!
!          Matrix factorization and computation of rcond
!
ierr = 0
call sgeco (a, ka, n, ipvt, rcond, wk)
t = 1.0 + rcond
if (t .eq. 1.0) go to 30
!
!                  Solution of the equation AX=b
!
if (m .lt. 1) go to 20
onej = 1
do 10 j = 1,m
   call sgesl (a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
10 continue
!
!             Calculation of det and the inverse of A
!
20 job = 10
if (mo .eq. 0) job = 11
call sgedi (a, ka, n, ipvt, det, wk, job)
return
!
!                  The problem cannot be solved
!
30 ierr = 1
return
end subroutine mslv

subroutine mslv1 (mo,n,m,a,ka,b,kb,ierr,ipvt,wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
integer :: j
real :: det(2)
integer :: onej
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting real matrices
!     and solving real equations
!-----------------------------------------------------------------------
!
if (n .lt. 1 .or. ka .lt. n) go to 40
if (m .le. 0) go to 10
if (kb .lt. n) go to 40
!
!                      Matrix factorization
!
10 call sgefa (a, ka, n, ipvt, ierr)
if (ierr .ne. 0) return
!
!                  Solution of the equation AX=b
!
if (m .le. 0) go to 30
onej = 1
do j = 1,m
   call sgesl (a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!
!                 Calculation of the inverse of A
!
30 if (mo .eq. 0) call sgedi (a, ka, n, ipvt, det, wk, 1)
return
!
!                          Error return
!
40 ierr = -1
return
end subroutine mslv1

subroutine slvmp(mo, n, a, ka, b, x, wk, iwk, ierr)
implicit none
integer, intent(inout) :: ierr, iwk
integer, intent(in) :: ka, mo, n
real :: a(ka,n), b(n)
real, intent(inout) :: wk(*), x(n)
integer :: i, ir
!     ******************************************************************
!     Solution of real linear equations with iterative improvement
!     ******************************************************************
dimension iwk(n)
!     -------------------
!     dimension wk(n*n + n)
!     -------------------
if (mo .ne. 0) go to 10
!
!             Compute the LU decomposition of A
!
call mcopy(n, n, a, ka, wk, n)
call sgefa(wk, n, n, iwk, ierr)
if (ierr .eq. 0) go to 10
ierr = -ierr
return
!
!            Solve the system of equations AX = b
!
10 do 11 i = 1,n
11 x(i) = b(i)
!
ir = n*n + 1
call sgesl(wk, n, n, iwk, x, 0)
call luimp(a, ka, n, wk(1), n, iwk, b, x, wk(ir), ierr)
return
end subroutine slvmp

subroutine luimp(a, ka, n, q, kq, ipvt, b, x, r, ind)
implicit none
integer, intent(out) :: ind
integer :: ipvt
integer, intent(in) :: ka, kq, n
real :: a(ka,n), b(n), q(kq,n)
real, intent(inout) :: r(n), x(n)
integer :: i, j
real :: eps, eps2, rat, ratio, rnrm, xnrm
double precision :: dsum
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!     Purpose
!       given an approximate solution x of a linear system AX = b
!       obtained using sgeco or sgefa. luimp attempts to compute
!       an improved solution correct to machine precision.
!
!     Parameters
!
!       A    AN ARRAY OF DIMENSION (ka,n) CONTAINING THE MATRIX
!            A of order n.
!       q    AN ARRAY OF DIMENSION (kq,n) CONTAINING THE LU
!            decomposition of a produced by sgeco or sgefa.
!       ipvt an array of dimension n containing the permutation
!            information given by sgeco or sgefa.
!       b    the right hand side of the equation AX = b.
!       x    on input x is the approximate solution of AX = b to
!            be improved. On output x is the solution obtained.
!       r    AN ARRAY FOR INTERNAL USE BY THE ROUTINE.
!       Ind  variable that reports the status of the results.
!            ind = 0 If improvement of x is successful with A
!            gain in accuracy of at least 50 per cent each
!            iteration. Otherwise ind = 1.
!
!     Method
!       luimp executes the iteration cycle
!            (1)  AR = b - AX
!            (2)  x = x + r
!       with an initial given x. the residual vector b - AX is
!       computed to high accuracy using double precision. sgesl
!       is then used to solve (1).
!
! ----------------------------------------------------------------------
dimension ipvt(n)
!
!     ********** eps is a machine dependent parameter. Assign eps
!                the value U where U is the smallest floating point
!                number such that 1.0 + U .GT. 1.0.
!
eps = spmpar(1)
!
ind = 0
xnrm = 0.0
do 10 i = 1,n
10 xnrm = xnrm + x(i)*x(i)
if (xnrm .eq. 0.0) return
eps2 = eps*eps
ratio = 1.0
!
!                  Compute the residual vector
!
20 do 22 i = 1,n
   dsum = b(i)
   do 21 j = 1,n
21    dsum = dsum - dble(a(i,j))*dble(x(j))
22 r(i) = dsum
!
!                  Find the correction vector
!
call sgesl(q, kq, n, ipvt, r, 0)
rnrm = 0.0
do 30 i = 1,n
30 rnrm = rnrm + r(i)*r(i)
if (rnrm .le. eps2*xnrm) return
!
!                Form a new approximate solution
!
do 40 i = 1,n
40 x(i) = x(i) + r(i)
xnrm = 0.0
do 41 i = 1,n
41 xnrm = xnrm + x(i)*x(i)
!
if (xnrm .eq. 0.0) return
rat = ratio
ratio = rnrm/xnrm
if (ratio .le. 0.25*rat) go to 20
!
if (ratio .gt. amin1(rat,4.0*eps2)) ind = 1
return
end subroutine luimp

pure subroutine sgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
real, intent(inout) :: a(lda,*), z(*)
real, intent(inout) :: rcond
real :: ek, t, wk, wkm
real :: anorm, s, sm, ynorm
integer :: info, j, k, kb, kp1, l
interface
   pure function sasum(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: sasum
   end function sasum
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
   pure subroutine sgefa(a,lda,n,ipvt,info)
      implicit none
      integer, intent(in) :: lda
      real, intent(inout) :: a(lda,*)
      integer, intent(in) :: n
      integer, intent(inout) :: ipvt(*)
      integer, intent(out) :: info
   end subroutine sgefa
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
end interface
!
!     sgeco factors a real matrix BY Gaussian elimination
!     and estimates the condition of the matrix.
!
!     If  rcond  is not needed, sgefa is slightly faster.
!     To solve  a*X = B , follow sgeco by sgesl.
!     To compute  inverse(a)*C , follow sgeco by sgesl.
!     To compute  determinant(a) , follow sgeco by sgedi.
!     To compute  inverse(a) , follow sgeco by sgedi.
!
!     On entry
!
!        A       real(lda, n)
!                the matrix to be factored.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        rcond   REAL
!                an estimate of the reciprocal condition of  A .
!                For the system  a*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!
!        z       real(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     LINPACK sgefa
!     BLAS saxpy,sdot,sscal,sasum
!     Fortran abs,AMAX1,sign
!
!     Internal variables
!
!
!
!     Compute 1-norm of A
!
anorm = 0.0e0
do j = 1, n
   anorm = amax1(anorm,sasum(n,a(1,j),1))
end do
!
!     Factor
!
call sgefa(a,lda,n,ipvt,info)
!
!     rcond = 1/(norm(a)*(estimate of norm(inverse(a)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  a*z = Y  AND  TRANS(a)*Y = E .
!     Trans(a)  is the transpose of A .  The components of  E  are
!     chosen to cause maximum local growth in the elements of W  where
!     trans(U)*W = E .  The vectors are frequently rescaled to avoid
!     overflow.
!
!     SOLVE TRANS(U)*W = E
!
ek = 1.0e0
do j = 1, n
   z(j) = 0.0e0
end do
do k = 1, n
   if (z(k) .ne. 0.0e0) ek = sign(ek,-z(k))
   if (abs(ek - z(k)) .le. abs(a(k,k))) go to 30
   s = abs(a(k,k))/abs(ek - z(k))
   call sscal(n,s,z,1)
   ek = s*ek
30 continue
   wk = ek - z(k)
   wkm = -ek - z(k)
   s = abs(wk)
   sm = abs(wkm)
   if (a(k,k) .eq. 0.0e0) go to 40
   wk = wk/a(k,k)
   wkm = wkm/a(k,k)
   go to 50
40 continue
   wk = 1.0e0
   wkm = 1.0e0
50 continue
   kp1 = k + 1
   if (kp1 .gt. n) go to 90
   do j = kp1, n
      sm = sm + abs(z(j) + wkm*a(k,j))
      z(j) = z(j) + wk*a(k,j)
      s = s + abs(z(j))
   end do
   if (s .ge. sm) go to 80
   t = wkm - wk
   wk = wkm
   do j = kp1, n
      z(j) = z(j) + t*a(k,j)
   end do
80 continue
90 continue
   z(k) = wk
end do
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
!
!     SOLVE TRANS(l)*Y = W
!
do kb = 1, n
   k = n + 1 - kb
   if (k .lt. n) z(k) = z(k) + sdot(n - k,a(k + 1,k),1,z(k + 1),1)
   if (abs(z(k)) .le. 1.0e0) go to 110
   s = 1.0e0/abs(z(k))
   call sscal(n,s,z,1)
110 continue
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
end do
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
!
ynorm = 1.0e0
!
!     SOLVE l*V = Y
!
do k = 1, n
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
   if (k .lt. n) call saxpy(n - k,t,a(k + 1,k),1,z(k + 1),1)
   if (abs(z(k)) .le. 1.0e0) go to 130
   s = 1.0e0/abs(z(k))
   call sscal(n,s,z,1)
   ynorm = s*ynorm
130 continue
end do
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
!
!     SOLVE  U*z = V
!
do kb = 1, n
   k = n + 1 - kb
   if (abs(z(k)) .le. abs(a(k,k))) go to 150
   s = abs(a(k,k))/abs(z(k))
   call sscal(n,s,z,1)
   ynorm = s*ynorm
150 continue
   if (a(k,k) .ne. 0.0e0) z(k) = z(k)/a(k,k)
   if (a(k,k) .eq. 0.0e0) z(k) = 1.0e0
   t = -z(k)
   call saxpy(k - 1,t,a(1,k),1,z(1),1)
end do
!     MAKE ZNORM = 1.0
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
!
if (anorm .ne. 0.0e0) rcond = ynorm/anorm
if (anorm .eq. 0.0e0) rcond = 0.0e0
return
end subroutine sgeco

pure subroutine sgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
real, intent(inout) :: a(lda,*)
real :: t
integer :: j, k, kp1, l, nm1
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
end interface
!
!     sgefa factors a real matrix BY Gaussian elimination.
!
!     sgefa is usually called by sgeco, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for sgeco) = (1 + 9/n)*(time for sgefa) .
!
!     On entry
!
!        A       real(lda, n)
!                the matrix to be factored.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if  U(k,k) .EQ. 0.0 .  this is not an error
!                     condition for this subroutine, but it does
!                     indicate that sgesl or sgedi will divide by zero
!                     if called.  Use  RCOND  in sgeco for a reliable
!                     indication of singularity.
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sscal,isamax
!
!     Internal variables
!
!
!
!     Gaussian elimination with partial pivoting
!
info = 0
nm1 = n - 1
if (nm1 .lt. 1) go to 70
do k = 1, nm1
   kp1 = k + 1
!
!        Find l = Pivot index
!
   l = isamax(n - k + 1,a(k,k),1) + k - 1
   ipvt(k) = l
!
!        Zero pivot implies this column already triangularized
!
   if (a(l,k) .eq. 0.0e0) go to 40
!
!           Interchange if necessary
!
   if (l .eq. k) go to 10
   t = a(l,k)
   a(l,k) = a(k,k)
   a(k,k) = t
10 continue
!
!           Compute multipliers
!
   t = -1.0e0/a(k,k)
   call sscal(n - k,t,a(k + 1,k),1)
!
!           Row elimination with column indexing
!
   do j = kp1, n
      t = a(l,j)
      if (l .eq. k) go to 20
      a(l,j) = a(k,j)
      a(k,j) = t
20    continue
      call saxpy(n - k,t,a(k + 1,k),1,a(k + 1,j),1)
   end do
   go to 50
40 continue
   info = k
50 continue
end do
70 continue
ipvt(n) = n
if (a(n,n) .eq. 0.0e0) info = n
return
end subroutine sgefa

pure subroutine sgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
real, intent(in) :: a(lda,*)
real, intent(inout) :: b(*)
real :: t
integer :: k, kb, l, nm1
interface
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
end interface
!
!     sgesl solves the real system
!     a * X = b  OR  TRANS(a) * X = b
!     using the factors computed by sgeco or sgefa.
!
!     On entry
!
!        A       real(lda, n)
!                the output from sgeco or sgefa.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!        ipvt    INTEGER(n)
!                the pivot vector from sgeco or sgefa.
!
!        b       real(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         To solve  a*X = b ,
!                = Nonzero   to solve  trans(a)*X = b  where
!                            trans(a)  is the transpose.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda .  It will not occur if the subroutines are
!        called correctly and if sgeco has set RCOND .GT. 0.0
!        or sgefa has set info .EQ. 0 .
!
!     To compute  inverse(a) * C  where  C  is a matrix
!     with  P  columns
!           call sgeco(a,lda,n,ipvt,rcond,z)
!           if (rcond is too small) go to ...
!           do 10 j = 1, p
!              call sgesl(a,lda,n,ipvt,c(1,j),0)
!        10 continue
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sdot
!
!     Internal variables
!
!
nm1 = n - 1
if (job .ne. 0) go to 50
!
!        job = 0 , SOLVE  a * X = b
!        first solve  l*Y = b
!
if (nm1 .lt. 1) go to 30
do k = 1, nm1
   l = ipvt(k)
   t = b(l)
   if (l .eq. k) go to 10
   b(l) = b(k)
   b(k) = t
10 continue
   call saxpy(n - k,t,a(k + 1,k),1,b(k + 1),1)
end do
30 continue
!
!        Now solve  U*X = Y
!
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/a(k,k)
   t = -b(k)
   call saxpy(k - 1,t,a(1,k),1,b(1),1)
end do
go to 100
50 continue
!
!        job = NONZERO, SOLVE  TRANS(a) * X = b
!        first solve  trans(U)*Y = b
!
do k = 1, n
   t = sdot(k - 1,a(1,k),1,b(1),1)
   b(k) = (b(k) - t)/a(k,k)
end do
!
!        Now solve trans(l)*X = Y
!
if (nm1 .lt. 1) go to 90
do kb = 1, nm1
   k = n - kb
   b(k) = b(k) + sdot(n - k,a(k + 1,k),1,b(k + 1),1)
   l = ipvt(k)
   if (l .eq. k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
90 continue
100 continue
return
end subroutine sgesl

subroutine sgedi(a,lda,n,ipvt,det,work,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
real, intent(inout) :: a(lda,*), det(2), work(*)
real :: t
real :: ten
integer :: i, j, k, kb, kp1, l, nm1
!
!     sgedi computes the determinant and inverse of a matrix
!     using the factors computed by sgeco or sgefa.
!
!     On entry
!
!        A       real(lda, n)
!                the output from sgeco or sgefa.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!        ipvt    INTEGER(n)
!                the pivot vector from sgeco or sgefa.
!
!        WORK    real(n)
!                work vector.  Contents destroyed.
!
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!
!     On return
!
!        A       INVERSE OF ORIGINAL MATRIX IF REQUESTED.
!                Otherwise unchanged.
!
!        det     real(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. abs(det(1)) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if sgeco has set RCOND .GT. 0.0 or sgefa has set
!        INFO .EQ. 0 .
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sscal,sswap
!     Fortran abs,mod
!
!     Internal variables
!
!
!
!     Compute determinant
!
if (job/10 .eq. 0) go to 70
det(1) = 1.0e0
det(2) = 0.0e0
ten = 10.0e0
do 50 i = 1, n
   if (ipvt(i) .ne. i) det(1) = -det(1)
   det(1) = a(i,i)*det(1)
!        ...Exit
   if (det(1) .eq. 0.0e0) go to 60
10 if (abs(det(1)) .ge. 1.0e0) go to 20
   det(1) = ten*det(1)
   det(2) = det(2) - 1.0e0
   go to 10
20 continue
30 if (abs(det(1)) .lt. ten) go to 40
   det(1) = det(1)/ten
   det(2) = det(2) + 1.0e0
   go to 30
40 continue
50 continue
60 continue
70 continue
!
!     Compute inverse(U)
!
if (mod(job,10) .eq. 0) go to 150
do k = 1, n
   a(k,k) = 1.0e0/a(k,k)
   t = -a(k,k)
   call sscal(k - 1,t,a(1,k),1)
   kp1 = k + 1
   if (n .lt. kp1) go to 90
   do j = kp1, n
      t = a(k,j)
      a(k,j) = 0.0e0
      call saxpy(k,t,a(1,k),1,a(1,j),1)
   end do
90 continue
end do
!
!        Form inverse(U)*inverse(l)
!
nm1 = n - 1
if (nm1 .lt. 1) go to 140
do kb = 1, nm1
   k = n - kb
   kp1 = k + 1
   do i = kp1, n
      work(i) = a(i,k)
      a(i,k) = 0.0e0
   end do
   do j = kp1, n
      t = work(j)
      call saxpy(n,t,a(1,j),1,a(1,k),1)
   end do
   l = ipvt(k)
   if (l .ne. k) call sswap(n,a(1,k),1,a(1,l),1)
end do
140 continue
150 continue
return
end subroutine sgedi

subroutine dmslv (mo,n,m,a,ka,b,kb,det,rcond,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
double precision, intent(inout) :: a(ka,n), b(*)
double precision, intent(inout) :: det(2), rcond
double precision, intent(inout) :: wk(n)
integer, intent(inout) :: ipvt(n)
integer :: j, job
double precision :: t
integer :: onej
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     real matrices and solving double precision real equations
!-----------------------------------------------------------------------
!
!          Matrix factorization and computation of rcond
!
ierr = 0
call dgeco (a, ka, n, ipvt, rcond, wk)
t = 1.d0 + rcond
if (t .eq. 1.d0) go to 30
!
!                  Solution of the equation AX=b
!
if (m .lt. 1) go to 20
onej = 1
do 10 j = 1,m
   call dgesl (a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
10 continue
!
!             Calculation of det and the inverse of A
!
20 job = 10
if (mo .eq. 0) job = 11
call dgedi (a, ka, n, ipvt, det, wk, job)
return
!
!                  The problem cannot be solved
!
30 ierr = 1
return
end subroutine dmslv

subroutine dmslv1 (mo,n,m,a,ka,b,kb,ierr,ipvt,wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo, n
double precision, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
integer :: j
double precision :: det(2)
integer :: onej
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     real matrices and solving double precision real equations
!-----------------------------------------------------------------------
!
if (n .lt. 1 .or. ka .lt. n) go to 40
if (m .le. 0) go to 10
if (kb .lt. n) go to 40
!
!                      Matrix factorization
!
10 call dgefa (a, ka, n, ipvt, ierr)
if (ierr .ne. 0) return
!
!                  Solution of the equation AX=b
!
if (m .le. 0) go to 30
onej = 1
do j = 1,m
   call dgesl (a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!
!                 Calculation of the inverse of A
!
30 if (mo .eq. 0) call dgedi (a, ka, n, ipvt, det, wk, 1)
return
!
!                          Error return
!
40 ierr = -1
return
end subroutine dmslv1

pure subroutine dgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
double precision, intent(inout) :: a(lda,*), z(*)
double precision, intent(inout) :: rcond
double precision :: ek, t, wk, wkm
double precision :: anorm, s, sm, ynorm
integer :: info, j, k, kb, kp1, l
interface
   pure function dasum(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dasum
   end function dasum
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
   pure subroutine dgefa(a,lda,n,ipvt,info)
      implicit none
      integer, intent(in) :: lda
      double precision, intent(inout) :: a(lda,*)
      integer, intent(in) :: n
      integer, intent(inout) :: ipvt(*)
      integer, intent(out) :: info
   end subroutine dgefa
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
end interface
!
!     dgeco factors a double precision matrix BY Gaussian elimination
!     and estimates the condition of the matrix.
!
!     If  rcond  is not needed, dgefa is slightly faster.
!     To solve  a*X = B , follow dgeco by dgesl.
!     To compute  inverse(a)*C , follow dgeco by dgesl.
!     To compute  determinant(a) , follow dgeco by dgedi.
!     To compute  inverse(a) , follow dgeco by dgedi.
!
!     On entry
!
!        A       DOUBLE PRECISION(lda, n)
!                the matrix to be factored.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        rcond   DOUBLE PRECISION
!                an estimate of the reciprocal condition of  A .
!                For the system  a*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!
!        z       DOUBLE PRECISION(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     LINPACK dgefa
!     BLAS daxpy,ddot,dscal,dasum
!     Fortran dabs,DMAX1,DSIGN
!
!     Internal variables
!
!
!
!     Compute 1-norm of A
!
anorm = 0.0d0
do j = 1, n
   anorm = dmax1(anorm,dasum(n,a(1,j),1))
end do
!
!     Factor
!
call dgefa(a,lda,n,ipvt,info)
!
!     rcond = 1/(norm(a)*(estimate of norm(inverse(a)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  a*z = Y  AND  TRANS(a)*Y = E .
!     Trans(a)  is the transpose of A .  The components of  E  are
!     chosen to cause maximum local growth in the elements of W  where
!     trans(U)*W = E .  The vectors are frequently rescaled to avoid
!     overflow.
!
!     SOLVE TRANS(U)*W = E
!
ek = 1.0d0
do j = 1, n
   z(j) = 0.0d0
end do
do k = 1, n
   if (z(k) .ne. 0.0d0) ek = dsign(ek,-z(k))
   if (dabs(ek - z(k)) .le. dabs(a(k,k))) go to 30
   s = dabs(a(k,k))/dabs(ek - z(k))
   call dscal(n,s,z,1)
   ek = s*ek
30 continue
   wk = ek - z(k)
   wkm = -ek - z(k)
   s = dabs(wk)
   sm = dabs(wkm)
   if (a(k,k) .eq. 0.0d0) go to 40
   wk = wk/a(k,k)
   wkm = wkm/a(k,k)
   go to 50
40 continue
   wk = 1.0d0
   wkm = 1.0d0
50 continue
   kp1 = k + 1
   if (kp1 .gt. n) go to 90
   do j = kp1, n
      sm = sm + dabs(z(j) + wkm*a(k,j))
      z(j) = z(j) + wk*a(k,j)
      s = s + dabs(z(j))
   end do
   if (s .ge. sm) go to 80
   t = wkm - wk
   wk = wkm
   do j = kp1, n
      z(j) = z(j) + t*a(k,j)
   end do
80 continue
90 continue
   z(k) = wk
end do
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
!
!     SOLVE TRANS(l)*Y = W
!
do kb = 1, n
   k = n + 1 - kb
   if (k .lt. n) z(k) = z(k) + ddot(n - k,a(k + 1,k),1,z(k + 1),1)
   if (dabs(z(k)) .le. 1.0d0) go to 110
   s = 1.0d0/dabs(z(k))
   call dscal(n,s,z,1)
110 continue
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
end do
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
!
ynorm = 1.0d0
!
!     SOLVE l*V = Y
!
do k = 1, n
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
   if (k .lt. n) call daxpy(n - k,t,a(k + 1,k),1,z(k + 1),1)
   if (dabs(z(k)) .le. 1.0d0) go to 130
   s = 1.0d0/dabs(z(k))
   call dscal(n,s,z,1)
   ynorm = s*ynorm
130 continue
end do
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
!
!     SOLVE  U*z = V
!
do kb = 1, n
   k = n + 1 - kb
   if (dabs(z(k)) .le. dabs(a(k,k))) go to 150
   s = dabs(a(k,k))/dabs(z(k))
   call dscal(n,s,z,1)
   ynorm = s*ynorm
150 continue
   if (a(k,k) .ne. 0.0d0) z(k) = z(k)/a(k,k)
   if (a(k,k) .eq. 0.0d0) z(k) = 1.0d0
   t = -z(k)
   call daxpy(k - 1,t,a(1,k),1,z(1),1)
end do
!     MAKE ZNORM = 1.0
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
!
if (anorm .ne. 0.0d0) rcond = ynorm/anorm
if (anorm .eq. 0.0d0) rcond = 0.0d0
return
end subroutine dgeco

pure subroutine dgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
double precision, intent(inout) :: a(lda,*)
double precision :: t
integer :: j, k, kp1, l, nm1
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
end interface
!
!     dgefa factors a double precision matrix BY Gaussian elimination.
!
!     dgefa is usually called by dgeco, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for dgeco) = (1 + 9/n)*(time for dgefa) .
!
!     On entry
!
!        A       DOUBLE PRECISION(lda, n)
!                the matrix to be factored.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if  U(k,k) .EQ. 0.0 .  this is not an error
!                     condition for this subroutine, but it does
!                     indicate that dgesl or dgedi will divide by zero
!                     if called.  Use  RCOND  in dgeco for a reliable
!                     indication of singularity.
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS daxpy,dscal,idamax
!
!     Internal variables
!
!
!
!     Gaussian elimination with partial pivoting
!
info = 0
nm1 = n - 1
if (nm1 .lt. 1) go to 70
do k = 1, nm1
   kp1 = k + 1
!
!        Find l = Pivot index
!
   l = idamax(n - k + 1,a(k,k),1) + k - 1
   ipvt(k) = l
!
!        Zero pivot implies this column already triangularized
!
   if (a(l,k) .eq. 0.0d0) go to 40
!
!           Interchange if necessary
!
   if (l .eq. k) go to 10
   t = a(l,k)
   a(l,k) = a(k,k)
   a(k,k) = t
10 continue
!
!           Compute multipliers
!
   t = -1.0d0/a(k,k)
   call dscal(n - k,t,a(k + 1,k),1)
!
!           Row elimination with column indexing
!
   do j = kp1, n
      t = a(l,j)
      if (l .eq. k) go to 20
      a(l,j) = a(k,j)
      a(k,j) = t
20    continue
      call daxpy(n - k,t,a(k + 1,k),1,a(k + 1,j),1)
   end do
   go to 50
40 continue
   info = k
50 continue
end do
70 continue
ipvt(n) = n
if (a(n,n) .eq. 0.0d0) info = n
return
end subroutine dgefa

pure subroutine dgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
double precision, intent(in) :: a(lda,*)
double precision, intent(inout) :: b(*)
double precision :: t
integer :: k, kb, l, nm1
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
end interface
!
!     dgesl solves the double precision system
!     a * X = b  OR  TRANS(a) * X = b
!     using the factors computed by dgeco or dgefa.
!
!     On entry
!
!        A       DOUBLE PRECISION(lda, n)
!                the output from dgeco or dgefa.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!        ipvt    INTEGER(n)
!                the pivot vector from dgeco or dgefa.
!
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         To solve  a*X = b ,
!                = Nonzero   to solve  trans(a)*X = b  where
!                            trans(a)  is the transpose.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda .  It will not occur if the subroutines are
!        called correctly and if dgeco has set RCOND .GT. 0.0
!        or dgefa has set info .EQ. 0 .
!
!     To compute  inverse(a) * C  where  C  is a matrix
!     with  P  columns
!           call dgeco(a,lda,n,ipvt,rcond,z)
!           if (rcond is too small) go to ...
!           do 10 j = 1, p
!              call dgesl(a,lda,n,ipvt,c(1,j),0)
!        10 continue
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS daxpy,ddot
!
!     Internal variables
!
!
nm1 = n - 1
if (job .ne. 0) go to 50
!
!        job = 0 , SOLVE  a * X = b
!        first solve  l*Y = b
!
if (nm1 .lt. 1) go to 30
do k = 1, nm1
   l = ipvt(k)
   t = b(l)
   if (l .eq. k) go to 10
   b(l) = b(k)
   b(k) = t
10 continue
   call daxpy(n - k,t,a(k + 1,k),1,b(k + 1),1)
end do
30 continue
!
!        Now solve  U*X = Y
!
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/a(k,k)
   t = -b(k)
   call daxpy(k - 1,t,a(1,k),1,b(1),1)
end do
go to 100
50 continue
!
!        job = NONZERO, SOLVE  TRANS(a) * X = b
!        first solve  trans(U)*Y = b
!
do k = 1, n
   t = ddot(k - 1,a(1,k),1,b(1),1)
   b(k) = (b(k) - t)/a(k,k)
end do
!
!        Now solve trans(l)*X = Y
!
if (nm1 .lt. 1) go to 90
do kb = 1, nm1
   k = n - kb
   b(k) = b(k) + ddot(n - k,a(k + 1,k),1,b(k + 1),1)
   l = ipvt(k)
   if (l .eq. k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
90 continue
100 continue
return
end subroutine dgesl

subroutine dgedi(a,lda,n,ipvt,det,work,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
double precision, intent(inout) :: a(lda,*), det(2), work(*)
double precision :: t
double precision :: ten
integer :: i, j, k, kb, kp1, l, nm1
!
!     dgedi computes the determinant and inverse of a matrix
!     using the factors computed by dgeco or dgefa.
!
!     On entry
!
!        A       DOUBLE PRECISION(lda, n)
!                the output from dgeco or dgefa.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!        ipvt    INTEGER(n)
!                the pivot vector from dgeco or dgefa.
!
!        WORK    DOUBLE PRECISION(n)
!                work vector.  Contents destroyed.
!
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!
!     On return
!
!        A       INVERSE OF ORIGINAL MATRIX IF REQUESTED.
!                Otherwise unchanged.
!
!        det     DOUBLE PRECISION(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. dabs(det(1)) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if dgeco has set RCOND .GT. 0.0 or dgefa has set
!        INFO .EQ. 0 .
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS daxpy,dscal,dswap
!     Fortran dabs,mod
!
!     Internal variables
!
!
!
!     Compute determinant
!
if (job/10 .eq. 0) go to 70
det(1) = 1.0d0
det(2) = 0.0d0
ten = 10.0d0
do 50 i = 1, n
   if (ipvt(i) .ne. i) det(1) = -det(1)
   det(1) = a(i,i)*det(1)
!        ...Exit
   if (det(1) .eq. 0.0d0) go to 60
10 if (dabs(det(1)) .ge. 1.0d0) go to 20
   det(1) = ten*det(1)
   det(2) = det(2) - 1.0d0
   go to 10
20 continue
30 if (dabs(det(1)) .lt. ten) go to 40
   det(1) = det(1)/ten
   det(2) = det(2) + 1.0d0
   go to 30
40 continue
50 continue
60 continue
70 continue
!
!     Compute inverse(U)
!
if (mod(job,10) .eq. 0) go to 150
do k = 1, n
   a(k,k) = 1.0d0/a(k,k)
   t = -a(k,k)
   call dscal(k - 1,t,a(1,k),1)
   kp1 = k + 1
   if (n .lt. kp1) go to 90
   do j = kp1, n
      t = a(k,j)
      a(k,j) = 0.0d0
      call daxpy(k,t,a(1,k),1,a(1,j),1)
   end do
90 continue
end do
!
!        Form inverse(U)*inverse(l)
!
nm1 = n - 1
if (nm1 .lt. 1) go to 140
do kb = 1, nm1
   k = n - kb
   kp1 = k + 1
   do i = kp1, n
      work(i) = a(i,k)
      a(i,k) = 0.0d0
   end do
   do j = kp1, n
      t = work(j)
      call daxpy(n,t,a(1,j),1,a(1,k),1)
   end do
   l = ipvt(k)
   if (l .ne. k) call dswap(n,a(1,k),1,a(1,l),1)
end do
140 continue
150 continue
return
end subroutine dgedi

subroutine arceco(n, array, mtrstr, nmblks, pivot, b, x, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: n, nmblks
real, intent(inout) :: array(*), b(*), x(*)
integer, intent(inout) :: mtrstr(3,*), pivot(*)
!
!***************************************************************
!
!  This program solves the linear system  A*x = b  where  A is
!  an almost block diagonal matrix.  The method implemented is
!  based on Gauss elimination with alternate row and column
!  elimination with partial pivoting, which produces a stable
!  decomposition of the matrix  A  without introducing fill-in.
!
!***************************************************************
!
!               *****  PARAMETERS  *****
!
!       *** On entry ...
!
!                n     - INTEGER
!                         the order of the linear system, where
!                           n = sum(mtrstr(1,k),k=1,nmblks)
!
!                array - real(NUMELS)
!                         where
!                          numels = sum(mtrstr(1,k)*mtrstr(2,k),
!                               k=1,nmblks).
!                         Contains the entries of the almost
!                         block diagonal matrix  A  whose block
!                         structure is given by the integer array
!                         mtrstr. The elements of A are stored by
!                         columns, in blocks corresponding to the
!                         given structure.
!
!               mtrstr - INTEGER(3,nmblks)
!                         describes the block structure of  A ...
!                           mtrstr(1,K)  = Number of rows in
!                                            block K.
!                           mtrstr(2,K)  = Number of columns in
!                                            block K.
!                           mtrstr(3,K)  = Number of columns
!                                          overlapped by block K
!                                          and block (K+1).
!                        mtrstr must satisfy some restrictions.
!                         In order that A be square, we need
!                         sum(mtrstr(1,K),K=1,nmblks) = n =
!                         sum((mtrstr(2,K)-mtrstr(3,K)),K=1,nmblks).
!                        In addition, to ensure that three success-
!                         ive blocks do not have columns in common,
!                         mtrstr must satisfy
!                         mtrstr(3,K-1)+mtrstr(3,K).LE.mtrstr(2,K),
!                         FOR K = 2,nmblks.
!                        Finally,  A R C E C O,  sets
!                         mtrstr(3,nmblks) = 0, IN ARCECD.
!
!               nmblks - INTEGER
!                         total number of blocks in  A
!
!                pivot - Integer(n)
!                         work space
!
!                    b - real(n)
!                         the right hand side vector
!
!                    x - real(n)
!                         work space
!
!       *** On return  ...
!
!                array - real(NUMELS)
!                         contains the modified alternate row
!                         and column decomposition of  A (if
!                         iflag = 0)
!
!                pivot - Integer(n)
!                         records the pivoting indices deter-
!                         mined in the decomposition
!
!                    x - real(n)
!                         the solution vector (if iflag = 0)
!
!                iflag - INTEGER
!                         =  1,if input parameters are invalid
!                         = -1, if matrix is singular
!                         =  0, OTHERWISE
!
!***************************************************************
!
!               *****  Auxiliary programs  *****
!
!            arcedc(array,mtrstr,nmblks,pivot,iflag)
!               - Decomposes the matrix  A  using modified
!                 alternate row and column elimination
!                 with partial pivoting, and is used for
!                 this purpose in  A R C E C O.
!                 The arguments are all as in A R C E C O.
!
!            arcesl(array,mtrstr,nmblks,pivot,b,x)
!               - Solves the system  A*x = b  once  A  is
!                 decomposed.
!                 The arguments are all as in A R C E C O .
!
!***************************************************************
!
!               *****  Block structure of  A  *****
!
!  The nmblks blocks of A are stored consecutively in the one
!  dimensional matrix  array, the entries of  A  being stored
!  as follows ...
!
!       IN array(1)     THE (1,1) ENTRY OF THE TOP BLOCK,
!
!       In array(INDEX) the (1,1) entry of the ith block where
!                       index = 1 + sum(mtrstr(1,j)*mtrstr(2,j),
!                               j=1,i-1), i=2,nmblks.
!
!***************************************************************
!
!       The subroutine  A R C E C O  automatically solves the
!  input system when iflag=0.  A R C E C O  is called only once
!  for a given system. The solution for a sequence of P right
!  hand sides can be obtained by one call to  A R C E C O  and
!  P-1 calls to arcesl only. Since the arrays array and
!  pivot contain, respectively, the decomposition of the given
!  coefficient matrix and pivoting information on return from
!  A R C E C O , they must not be altered between successive
!  calls to arcesl with the same right hand sides. For the
!  same reason, if the user wishes to save the coefficient
!  matrix, the array array must be copied before a call
!  TO  A R C E C O .
!
!**********************************************************************
call arcedc(n, array, mtrstr, nmblks, pivot, iflag)
if (iflag.ne.0) return
call arcesl(array, mtrstr, nmblks, pivot, b, x)
return
end subroutine arceco

pure subroutine arcedc(n, array, mtrstr, nmblks, pivot, iflag)
implicit none
integer, intent(inout) :: iflag, mtrstr(3,*)
integer, intent(in) :: n, nmblks
real, intent(inout) :: array(*)
integer, intent(inout) :: pivot(*)
integer :: index1, index2, index3, indpiv, isum1, isum2, k, &
   & nclblk, nclpiv, novrlp, nrwbk2, nrwblk, nrwpiv
real :: pivmax
real, parameter :: zero = 0.0
interface
   pure subroutine arcepc(topblk,nrwtop,novrlp,botblk,nrwbot, &
      & nclpiv,pivot,pivmax,iflag)
      implicit none
      integer, intent(in) :: nrwbot
      integer, intent(in) :: novrlp
      integer, intent(in) :: nrwtop
      real, intent(inout) :: topblk(nrwtop,novrlp)
      real, intent(inout) :: botblk(nrwbot,novrlp)
      integer, intent(in) :: nclpiv
      integer, intent(inout) :: pivot(nrwtop)
      real, intent(inout) :: pivmax
      integer, intent(inout) :: iflag
   end subroutine arcepc
   pure subroutine arcepr(block,nrwblk,nclblk,nrwpiv,pivot, &
      & pivmax,iflag)
      implicit none
      integer, intent(in) :: nclblk
      integer, intent(in) :: nrwblk
      real, intent(inout) :: block(nrwblk,nclblk)
      integer, intent(in) :: nrwpiv
      integer, intent(inout) :: pivot(nrwblk)
      real, intent(inout) :: pivmax
      integer, intent(inout) :: iflag
   end subroutine arcepr
end interface
!
!***************************************************************
!
!  A R C E D C supervises the modified alternate row and column
!  decomposition with partial pivoting of the almost block
!  DIAGONAL MATRIX  A   STORED IN THE ARRAYS A R R A Y  AND
!  M T R S T R .
!
!***************************************************************
!
!               *****  PARAMETERS  *****
!
!       *** On entry ...
!
!                n     - INTEGER
!                         the order of the linear system, where
!                           n = sum(mtrstr(1,k),k=1,nmblks)
!
!                array - real(NUMELS)
!                         where
!                          numels = sum(mtrstr(1,k)*mtrstr(2,k),
!                               k=1,nmblks).
!                         Contains the entries of the almost
!                         block diagonal matrix  A  whose block
!                         structure is given by the integer array
!                         mtrstr. The elements of A are stored by
!                         columns, in blocks corresponding to the
!                         given structure.
!               mtrstr - INTEGER(3,nmblks)
!                         describes the block structure of  A ...
!                           mtrstr(1,k)  = Number of rows in
!                                            block k.
!                           mtrstr(2,k)  = Number of columns in
!                                            block k.
!                           mtrstr(3,k)  = Number of columns
!                                          overlapped by block k
!                                          and block (k+1).
!                        mtrstr must satisfy some restrictions.
!                         In order that A be square, we need
!                         sum(mtrstr(1,k),k=1,nmblks) = n =
!                         sum((mtrstr(2,k)-mtrstr(3,k)),k=1,nmblks).
!                        In addition, to ensure that three success-
!                         ive blocks do not have columns in common,
!                         mtrstr must satisfy
!                         mtrstr(3,k-1)+mtrstr(3,k).LE.mtrstr(2,k),
!                         FOR k = 2,nmblks.
!                        Finally,  A R C E C O,  sets
!                         mtrstr(3,nmblks) = 0, IN ARCECD.
!
!               nmblks - INTEGER
!                         total number of blocks
!
!                pivot - Integer(n)
!                         work space
!
!       *** On return  ...
!
!                array - real(NUMELS)
!                         contains the modified alternate row
!                         and column decomposition of  A (if
!                         iflag = 0)
!
!                pivot - Integer(n)
!                         records the pivoting indices deter-
!                         mined in the decomposition
!
!                iflag - INTEGER
!                         =  1, if input parameters are invalid
!                         = -1, if matrix is singular
!                         =  0, OTHERWISE
!
!***************************************************************
!
!               *****  Auxiliary programs  *****
!
!       arcepr(BLOCK,NRWBLK,NCLBLK,NRWPIV,pivot,pivmax,iflag)
!        carries out the row eliminations
!
!       arcepc(TOPBLK,NRWTOP,NOVRLP,BOTBLK,NRWBOT,NCLPIV,
!            PIVOT,pivmax,iflag)
!        carries out the column eliminations
!
!***************************************************************
!
!
!***************************************************************
!
!       ****  Check validity of the input parameters....
!
!            If parameters are invalid then terminate at 7,
!                                      ELSE CONTINUE AT 8.
!
!***************************************************************
!
!
mtrstr(3,nmblks) = 0
do k = 2,nmblks
   if (mtrstr(3,k - 1) + mtrstr(3,k).gt.mtrstr(2,k)) go to 30
end do
isum1 = 0
isum2 = 0
do k = 1,nmblks
   isum1 = isum1 + mtrstr(1,k)
   isum2 = isum2 + mtrstr(2,k) - mtrstr(3,k)
end do
if (isum1.ne.isum2) go to 30
if (isum1.ne.n) go to 30
!
!Ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
!          Parameters are acceptable - Continue at 8
!
!Ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
go to 40
30 continue
!
!Cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
!        Parameters are invalid.  Set iflag = 1, and terminate
!
!Cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
iflag = 1
return
40 continue
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C  internal parameters ...
!       C
!       C       index1  POINTER TO THE ELEMENT IN THE COLUMN
!       C               WHERE ROW PIVOTING STARTS.
!       C
!       C       index2  POINTER TO THE ELEMENT IN THE COLUMN
!       C               WHERE COLUMN PIVOTING STARTS.
!       C
!       C       index3  POINTER TO 1ST ELEMENT IN 1ST COLUMN
!       C               OF NEXT BLOCK.
!       C
!       C       indpiv  POINTER TO 1ST ELEMENT OF BLOCK OF PIVOT
!       C
!       C       NRWBLK  NUMBER OF ROWS IN BLOCK.
!       C
!       C       NRWBK2  NUMBER OF ROWS IN NEXT BLOCK.
!       C
!       C       NRWPIV  NUMBER OF ROW ELIMINATIONS.
!       C
!       C       NCLBLK  NUMBER OF COLUMNS IN BLOCK TO BE
!       C               ROW PIVOTED.
!       C
!       C       NCLPIV  NUMBER OF COLUMN ELIMINATIONS.
!       C
!       C       NOVRLP  NUMBER OF COLUMNS OVERLAPPED BY THE
!       C               CURRENT BLOCK AND THE NEXT BLOCK.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
pivmax = zero
iflag = 0
index1 = 1
indpiv = 1
nrwblk = mtrstr(1,1)
nclblk = mtrstr(2,1)
novrlp = mtrstr(3,1)
nrwpiv = nclblk - novrlp
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       CALL arcepr TO PERFORM NRWPIV ROW ELIMINATIONS
!       C               ON TOP BLOCK.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
if (nrwpiv.gt.0) call arcepr(array(index1), nrwblk, nclblk, &
   & nrwpiv, pivot(indpiv), pivmax, iflag)
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       IF MATRIX SINGULAR RETURN.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
if (iflag.lt.0) return
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       NOW DO DECOMPOSITION PROCEEDING ONE BLOCK AT A
!       C               TIME.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do k = 2,nmblks
   indpiv = indpiv + nrwpiv
   index2 = index1 + nrwblk*nrwpiv
   index3 = index2 + nrwblk*novrlp
   nclpiv = nrwblk - nrwpiv
   nrwbk2 = mtrstr(1,k)
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C  call arcepc to perform NCLPIV column eliminations.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (nclpiv.eq.0) go to 50
   call arcepc(array(index2), nrwblk, novrlp, array(index3), &
      & nrwbk2, nclpiv, pivot(indpiv), pivmax, iflag)
!
!             Cccccccccccccccccccccccccccccccccccccccccccccccccc
!             C
!             C    IF MATRIX IS SINGULAR RETURN.
!             C
!             cccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (iflag.lt.0) return
50 continue
   nrwblk = nrwbk2
   index1 = index3 + nrwblk*nclpiv
   nclblk = mtrstr(2,k) - nclpiv
   novrlp = mtrstr(3,k)
   nrwpiv = nclblk - novrlp
   indpiv = indpiv + nclpiv
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcepr TO PERFORM NRWPIV ROW ELIMINATIONS.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (nrwpiv.eq.0) go to 60
   call arcepr(array(index1), nrwblk, nclblk, nrwpiv, &
      & pivot(indpiv), pivmax, iflag)
!             Cccccccccccccccccccccccccccccccccccccccccccccccccc
!             C
!             C    IF MATRIX IS SINGULAR RETURN.
!             C
!             cccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (iflag.lt.0) return
60 continue
end do
return
end subroutine arcedc

pure subroutine arcepr(block, nrwblk, nclblk, nrwpiv, pivot, pivmax, &
   & iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: nclblk, nrwblk, nrwpiv
integer, intent(inout) :: pivot(nrwblk)
real, intent(inout) :: block(nrwblk,nclblk)
real, intent(inout) :: pivmax
integer :: i1, j, j1, jplus1, l1, max
real :: rowmax
real :: tempiv, rowpiv, swap
!
!***************************************************************
!
!  A R C E P R  performs  nrwpiv  row eliminations on the matrix
!               block
!
!***************************************************************
!
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C        PERFORM nrwpiv ROW ELIMINATIONS...
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do j = 1,nrwpiv
   jplus1 = j + 1
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    DETERMINE ROW PIVOT AND PIVOT INDEX
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   max = j
   rowmax = abs(block(j,j))
   if (j.eq.nrwblk) go to 30
   do i1 = jplus1,nrwblk
      tempiv = abs(block(i1,j))
      if (tempiv.le.rowmax) go to 10
      rowmax = tempiv
      max = i1
10    continue
   end do
30 continue
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    TEST FOR SINGULARITY ...
!          C
!          C             IF SINGULAR THEN TERMINATE AT 90,
!          C                         ELSE CONTINUE.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (pivmax + rowmax.eq.pivmax) go to 100
   pivmax = amax1(pivmax,rowmax)
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    IF NECESSARY INTERCHANGE ROWS
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   pivot(j) = max
   if (j.eq.max) go to 50
   do j1 = j,nclblk
      swap = block(max,j1)
      block(max,j1) = block(j,j1)
      block(j,j1) = swap
   end do
50 continue
   if (j.eq.nrwblk) return
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    COMPUTE THE MULTIPLIERS
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   rowpiv = block(j,j)
   do i1 = jplus1,nrwblk
      block(i1,j) = block(i1,j)/rowpiv
   end do
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    PERFORM ROW ELIMINATIONS WITH COLUMN INDEXING
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   do j1 = jplus1,nclblk
      do l1 = jplus1,nrwblk
         block(l1,j1) = block(l1,j1) - block(l1,j)*block(j,j1)
      end do
   end do
end do
return
100 continue
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       matrix is singular - Set iflag = -1.
!       C                            TERMINATE AT 90.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
iflag = -1
return
end subroutine arcepr

pure subroutine arcepc(topblk, nrwtop, novrlp, botblk, nrwbot, nclpiv, &
   & pivot, pivmax, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: nclpiv, novrlp, nrwbot, nrwtop
real, intent(inout) :: topblk(nrwtop,novrlp), &
   & botblk(nrwbot,novrlp)
real, intent(inout) :: pivmax
integer, intent(inout) :: pivot(nrwtop)
integer :: i, i1, i2, iplus1, j, j1, jplus1, l1, max
real :: colmax
real :: colmlt
real :: tempiv, swap
!
!***************************************************************
!
!     A R C E P C performs nclpiv column eliminations on the
!                 matrices topblk and BOTBLK
!***************************************************************
!
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       PERFORM THE COLUMN ELIMINATIONS ON A LOOP.
!       C
!       ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do j = 1,nclpiv
   i = nrwtop - nclpiv + j
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    DETERMINE COLUMN PIVOT AND PIVOT INDEX
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   max = j
   colmax = abs(topblk(i,j))
   if (j.eq.novrlp) go to 30
   jplus1 = j + 1
   do j1 = jplus1,novrlp
      tempiv = abs(topblk(i,j1))
      if (tempiv.le.colmax) go to 10
      colmax = tempiv
      max = j1
10    continue
   end do
30 continue
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    TEST FOR SINGULARITY ...
!          C
!          C             IF SINGULAR THEN TERMINATE AT 110,
!          C                         ELSE CONTINUE.
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (pivmax + colmax.eq.pivmax) go to 120
   pivmax = amax1(pivmax,colmax)
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    IF NECESSARY INTERCHANGE COLUMNS
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   pivot(j) = max
   if (j.eq.max) go to 60
   do i1 = i,nrwtop
      swap = topblk(i1,j)
      topblk(i1,j) = topblk(i1,max)
      topblk(i1,max) = swap
   end do
   do i2 = 1,nrwbot
      swap = botblk(i2,j)
      botblk(i2,j) = botblk(i2,max)
      botblk(i2,max) = swap
   end do
60 continue
   if (j.eq.novrlp) return
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    COMPUTE MULTIPLIERS AND PERFORM COLUMN
!          C            ELIMINATION
!          C
!          cccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   do j1 = jplus1,novrlp
      colmlt = topblk(i,j1)/topblk(i,j)
      topblk(i,j1) = colmlt
      if (i.eq.nrwtop) go to 80
      iplus1 = i + 1
      do l1 = iplus1,nrwtop
         topblk(l1,j1) = topblk(l1,j1) - colmlt*topblk(l1,j)
      end do
80    continue
      do l1 = 1,nrwbot
         botblk(l1,j1) = botblk(l1,j1) - colmlt*botblk(l1,j)
      end do
   end do
end do
return
120 continue
!
!       Ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       matrix is singular - Set iflag = -1.
!       C                            TERMINATE AT 110.
!       C
!       ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
iflag = -1
return
end subroutine arcepc

subroutine arcesl(array, mtrstr, nmblks, pivot, b, x)
implicit none
integer :: mtrstr(3,*)
integer, intent(in) :: nmblks
real :: array(*)
real, intent(inout) :: b(*), x(*)
integer, intent(in) :: pivot(*)
integer :: indexa, indpiv, k, ll, nclblk, nclpiv, novrlp, nrwblk, &
   & nrwpiv
!
!***************************************************************
!
!  A R C E S L  supervises the solution of the linear system
!                          A*x = b
!  using the decomposition of the matrix  A  already generated
!  in  A R C E D C.  it involves two loops, the forward loop,
!  consisting of forward solution, forward modification, and
!  forward elimination, and the backward loop, consisting of
!  backward solution, backward modification, and backward
!  elimination.
!
!***************************************************************
!
!               *****  PARAMETERS  *****
!
!       *** On entry ...
!
!                array - real(NUMELS)
!                         where
!                          numels = sum(mtrstr(1,k)*mtrstr(2,k),
!                               k=1,nmblks).
!                         Output from A R C E D C
!
!               mtrstr - INTEGER(3,nmblks)
!                         describes the block structure of  A ...
!                           mtrstr(1,k)  = Number of rows in
!                                            block k.
!                           mtrstr(2,k)  = Number of columns in
!                                            block k.
!                           mtrstr(3,k)  = Number of columns
!                                          overlapped by block k
!                                          and block (k+1).
!
!                        The linear system is of order
!                           n  = sum(mtrstr(1,k),k=1,nmblks)
!
!               nmblks - INTEGER
!                         total number of blocks in  A
!
!                pivot - Integer(N)
!                         output from A R C E D C
!
!                    b - real(N)
!                         the right hand side vector
!
!                    x - real(N)
!                         work space
!
!       *** On return  ...
!
!
!                    x - real(N)
!                         the solution vector
!
!***************************************************************
!
!               *****  Auxiliary programs  *****
!
!
!       arcefs - Performs forward solution step
!
!       arcefm - Performs forward modification step
!
!       arcefe - Performs forward elimination step
!
!       arcebs - Performs backward solution step
!
!       arcebm - Performs backward modification step
!
!       arcebe - Performs backward elimination step
!
!***************************************************************
!
indpiv = 1
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C  internal parameters ...
!       C
!       C       indexa  POINTER TO 1ST ELEMENT OF BLOCK OF A.
!       C
!       C       INDEXB  POINTER TO 1ST ELEMENT OF BLOCK OF b.
!       C
!       C       indpiv,nrwblk,NRWPIV,nclblk,nclpiv,novrlp
!       C       ARE AS IN arcedc.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
indexa = 1
nrwblk = mtrstr(1,1)
nclblk = mtrstr(2,1)
novrlp = mtrstr(3,1)
nrwpiv = nclblk - novrlp
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       CALL arcefe TO PERFORM FORWARD ELIMINATION.
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
if (nrwpiv.gt.0) call arcefe(array(indexa), nrwblk, nrwpiv, &
   & pivot(indpiv), b(indpiv))
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       FORWARD LOOP
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do k = 2,nmblks
   indexa = indexa + nrwblk*nrwpiv
   nclpiv = nrwblk - nrwpiv
   indpiv = indpiv + nrwpiv
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcefs TO PERFORM FORWARD SOLUTION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (nclpiv.gt.0) call arcefs(array(indexa), nrwblk, nclpiv, &
      & novrlp, b(indpiv), x(indpiv))
   indexa = indexa + novrlp*nrwblk
   nrwblk = mtrstr(1,k)
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcefm TO PERFORM FORWARD MODIFICATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (nclpiv.gt.0) call arcefm(array(indexa), nrwblk, nclpiv, &
      & b(indpiv), x(indpiv))
   indexa = indexa + nrwblk*nclpiv
   nclblk = mtrstr(2,k) - nclpiv
   novrlp = mtrstr(3,k)
   nrwpiv = nclblk - novrlp
   indpiv = indpiv + nclpiv
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcefe TO PERFORM FORWARD ELIMINATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (nrwpiv.gt.0) call arcefe(array(indexa), nrwblk, nrwpiv, &
      & pivot(indpiv), b(indpiv))
end do
!     indexb = indpiv + nrwpiv - 1
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       BACKWARD LOOP
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do ll = 2,nmblks
   k = nmblks - ll + 1
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcebm TO PERFORM BACKWARD MODIFICATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (nrwpiv.eq.0) go to 20
   if (nrwpiv.ne.nclblk) call arcebm(array(indexa), nrwblk, &
      & nclblk, nrwpiv, b(indpiv), x(indpiv))
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcebs TO PERFORM BACKWARD SOLUTION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   call arcebs(array(indexa), nrwblk, nclblk, nrwpiv, b(indpiv), &
      & x(indpiv))
20 continue
   indexa = indexa - nrwblk*nclpiv
   nrwblk = mtrstr(1,k)
   novrlp = mtrstr(3,k)
   indexa = indexa - nrwblk*novrlp
   indpiv = indpiv - nclpiv
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcebe TO PERFORM BACKWARD ELIMINATION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
   if (nclpiv.gt.0) call arcebe(array(indexa), nrwblk, nclpiv, &
      & novrlp, pivot(indpiv), x(indpiv))
   nrwpiv = nrwblk - nclpiv
   nclblk = novrlp + nrwpiv
   indexa = indexa - nrwblk*nrwpiv
   indpiv = indpiv - nrwpiv
   nclpiv = mtrstr(2,k) - nclblk
end do
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       IF ROW ELIMINATIONS WERE DONE IN TOPBLOCK, CALL
!       C       arcebs TO PERFORM BACKWARD SOLUTION
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
if (nrwpiv.eq.0) return
if (nrwpiv.ne.nclblk) call arcebm(array(indexa), nrwblk, nclblk, &
   & nrwpiv, b(indpiv), x(indpiv))
call arcebs(array(indexa), nrwblk, nclblk, nrwpiv, b(indpiv), &
   & x(indpiv))
return
end subroutine arcesl

subroutine arcefs(block, nrwblk, nclpiv, novrlp, b, x)
implicit none
integer, intent(in) :: nclpiv, novrlp, nrwblk
real :: block(nrwblk,novrlp)
real, intent(inout) :: b(*), x(*)
integer :: i, iplusl, j, jplusl, l, long
real :: xj
!
!***************************************************************
!
!  A R C E F S performs the forward solution step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
do j = 1,nclpiv
   i = nrwblk - nclpiv + j
   x(j) = b(j)/block(i,j)
   if (i.eq.nrwblk) return
   long = nrwblk - i
   xj = x(j)
   do l = 1,long
      iplusl = i + l
      jplusl = j + l
      b(jplusl) = b(jplusl) - block(iplusl,j)*xj
   end do
end do
return
end subroutine arcefs

subroutine arcefm(block, nrwblk, nclpiv, b, x)
implicit none
integer, intent(in) :: nclpiv, nrwblk
real :: block(nrwblk,nclpiv)
real, intent(inout) :: b(*)
real :: x(*)
integer :: j, l, nclpvl
real :: xj
!
!***************************************************************
!
!  A R C E F M  performs the forward modification step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
do j = 1,nclpiv
   xj = x(j)
   do l = 1,nrwblk
      nclpvl = nclpiv + l
      b(nclpvl) = b(nclpvl) - block(l,j)*xj
   end do
end do
return
end subroutine arcefm

subroutine arcefe(block, nrwblk, nrwpiv, pivot, b)
implicit none
integer, intent(in) :: nrwblk, nrwpiv
real :: block(nrwblk,nrwpiv)
real, intent(inout) :: b(*)
integer, intent(in) :: pivot(nrwpiv)
integer :: i, iplus1, l
real :: bi, swap
integer :: pivoti
!
!***************************************************************
!
!  A R C E F E  performs the forward elimination step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
do i = 1,nrwpiv
   pivoti = pivot(i)
   if (pivoti.eq.i) go to 10
   swap = b(i)
   b(i) = b(pivoti)
   b(pivoti) = swap
10 continue
   if (i.eq.nrwblk) return
   bi = b(i)
   iplus1 = i + 1
   do l = iplus1,nrwblk
      b(l) = b(l) - block(l,i)*bi
   end do
end do
return
end subroutine arcefe

subroutine arcebs(block, nrwblk, nclblk, nrwpiv, b, x)
implicit none
integer, intent(in) :: nclblk, nrwblk, nrwpiv
real :: block(nrwblk,nclblk)
real, intent(inout) :: b(*), x(*)
integer :: j, jmin1, l, nj
real :: xj
!
!***************************************************************
!
!  A R C E b S performs the backward solution step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
do nj = 1,nrwpiv
   j = nrwpiv - nj + 1
   x(j) = b(j)/block(j,j)
   if (j.eq.1) return
   jmin1 = j - 1
   xj = x(j)
   do l = 1,jmin1
      b(l) = b(l) - block(l,j)*xj
   end do
end do
return
end subroutine arcebs

subroutine arcebm(block, nrwblk, nclblk, nrwpiv, b, x)
implicit none
integer, intent(in) :: nclblk, nrwblk, nrwpiv
real :: block(nrwblk,nclblk)
real, intent(inout) :: b(*)
real :: x(*)
integer :: j, l, nrwpv1
real :: xj
!
!***************************************************************
!
!  A R C E b M  performs the backward modification step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
nrwpv1 = nrwpiv + 1
do j = nrwpv1,nclblk
   xj = x(j)
   do l = 1,nrwpiv
      b(l) = b(l) - block(l,j)*xj
   end do
end do
return
end subroutine arcebm

subroutine arcebe(block, nrwblk, nclpiv, novrlp, pivot, x)
implicit none
integer, intent(in) :: nclpiv, novrlp, nrwblk
real :: block(nrwblk,novrlp)
real, intent(inout) :: x(*)
integer, intent(in) :: pivot(nrwblk)
integer :: i, j, j1, jplus1, nj
real :: dotprd, swap
integer :: pivotj
!
!***************************************************************
!
!  A R C E B E performs the backward elimination step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
do 40 nj = 1,nclpiv
   j = nclpiv + 1 - nj
   i = nrwblk + 1 - nj
   dotprd = x(j)
   if (j.eq.novrlp) go to 20
   jplus1 = j + 1
   do 10 j1 = jplus1,novrlp
      dotprd = dotprd - x(j1)*block(i,j1)
10    continue
20 continue
   x(j) = dotprd
   pivotj = pivot(j)
   if (pivotj.eq.j) go to 30
   swap = x(pivotj)
   x(pivotj) = x(j)
   x(j) = swap
30 continue
40 continue
return
end subroutine arcebe

subroutine btslv(mo, m, n, a, b, c, x, ip, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo, m
integer :: n
integer, intent(inout) :: ip(m,n)
real, intent(inout) :: a(m,m,n), b(m,m,n), c(m,m,n), x(*)
!
!     Decompose the coefficient matrix
!
if (mo .ne. 0) go to 10
call decbt(m, n, a, b, c, ip, ierr)
if (ierr .ne. 0) return
!
!     Solve the system of equations
!
10 call solbt(m, n, a, b, c, x, ip)
return
end subroutine btslv

subroutine decbt (m, n, a, b, c, ip, ier)
implicit none
integer, intent(in) :: m
integer :: n
integer, intent(inout) :: ip(m,n), ier
real, intent(inout) :: a(m,m,n), b(m,m,n), c(m,m,n)
integer :: nm1, nm2, km1, i, j, k, l
real :: dp
!-----------------------------------------------------------------------
! Block-tridiagonal matrix decomposition routine.
! Written by A. C. Hindmarsh.
! Latest revision January 26, 1977  (AG)
! reference.. UCID-30150
!             solution of block-tridiagonal systems of linear
!             algebraic equations
!             A.C. Hindmarsh
!             February 1977
! the input matrix contains three blocks of elements in each block-row,
! including blocks in the (1,3) and (n,n-2) block positions.
! decbt uses block Gauss elimination and subroutines dec and sol
! for solution of blocks.  Partial pivoting is done within
! block-rows only.
! Input..
!     m = Order of each block.
!     n = Number of blocks in each direction of the matrix.
!         n must be 4 or more.  The complete matrix HAS order m*n.
!     a = m by m by n array containing diagonal blocks.
!         a(i,j,k) contains the (i,j) element of the k-TH block.
!     b = m by m by n array containing the super-diagonal blocks
!         (in b(*,*,k) for k = 1,...,n-1) and the block in the (n,n-2)
!         block position (in b(*,*,n)).
!     c = m by m by n array containing the subdiagonal blocks
!         (in c(*,*,k) for k = 2,3,...,n) and the block in the
!         (1,3) block position (in c(*,*,1)).
!    ip = Integer array of length m*n for working storage.
! Output..
! A,b,c = m by m by n arrays containing the block LU decomposition
!         of the input matrix.
!    ip = m by n array of pivot information.  ip(*,k) contains
!         information for the k-TH DIGONAL block.
!   ier = 0  If no trouble occurred, or
!       = -1 If the input value of m or n was illegal, or
!       = k  if a singular matrix was found in the k-TH diagonal block.
! Use solbt to solve the associated linear system.
! decbt calls subroutines  dec(m,M0,a,ip,ier)  and  sol(m,M0,a,Y,ip)
! for solution of m by m linear systems.
!-----------------------------------------------------------------------
!
if (m .lt. 1 .or. n .lt. 4) go to 210
nm1 = n - 1
nm2 = n - 2
! Process the first block-row. -----------------------------------------
call dec (m, m, a, ip, ier)
k = 1
if (ier .ne. 0) go to 200
do j = 1,m
   call sol (m, m, a, b(1,j,1), ip)
   call sol (m, m, a, c(1,j,1), ip)
end do
! Adjust b(*,*,2). -----------------------------------------------------
do j = 1,m
   do i = 1,m
      dp = 0.
      do 20 l = 1,m
20       dp = dp + c(i,l,2)*c(l,j,1)
      b(i,j,2) = b(i,j,2) - dp
   end do
end do
! Main loop.  Process block-rows 2 to n-1. -----------------------------
do k = 2,nm1
   km1 = k - 1
   do j = 1,m
      do i = 1,m
         dp = 0.
         do 50 l = 1,m
50          dp = dp + c(i,l,k)*b(l,j,km1)
         a(i,j,k) = a(i,j,k) - dp
      end do
   end do
   call dec (m, m, a(1,1,k), ip(1,k), ier)
   if (ier .ne. 0) go to 200
   do 80 j = 1,m
80    call sol (m, m, a(1,1,k), b(1,j,k), ip(1,k))
end do
! Process last block-row and return. -----------------------------------
do j = 1,m
   do i = 1,m
      dp = 0.
      do 110 l = 1,m
110      dp = dp + b(i,l,n)*b(l,j,nm2)
      c(i,j,n) = c(i,j,n) - dp
   end do
end do
do j = 1,m
   do i = 1,m
      dp = 0.
      do 140 l = 1,m
140      dp = dp + c(i,l,n)*b(l,j,nm1)
      a(i,j,n) = a(i,j,n) - dp
   end do
end do
call dec (m, m, a(1,1,n), ip(1,n), ier)
k = n
if (ier .ne. 0) go to 200
return
! Error returns. -------------------------------------------------------
200 ier = k
return
210 ier = -1
return
!-----------------------  End of subroutine decbt  ---------------------
end subroutine decbt

subroutine solbt (m, n, a, b, c, y, ip)
implicit none
integer, intent(in) :: m
integer :: n, ip(m,n)
real :: a(m,m,n)
real, intent(in) :: b(m,m,n), c(m,m,n)
real, intent(inout) :: y(m,n)
integer :: kb, kp1
integer :: nm1, nm2, km1, i, j, k
real :: dp
!-----------------------------------------------------------------------
! Solution of block-tridiagonal linear system.
! Coefficient matrix must have been previously processed by decbt.
! m, n, A, b, c, and ip  must not have been changed since call to decbt.
! Written by A. C. Hindmarsh.
! Input..
!     m = Order of each block.
!     n = Number of blocks in each direction of matrix.
! A,b,c = m by m by n arrays containing block LU decomposition
!         of coefficient matrix from decbt.
!    ip = m by n integer array of pivot information from decbt.
!     y = Array of length m*n containing the right-hand side vector
!         (treated as an m by n array here).
! Output..
!     y = Solution vector, of length m*n.
! solbt makes calls to subroutine sol(m,M0,a,y,ip)
! for solution of m by m linear systems.
!-----------------------------------------------------------------------
!
nm1 = n - 1
nm2 = n - 2
! Forward solution sweep. ----------------------------------------------
call sol (m, m, a, y, ip)
do k = 2,nm1
   km1 = k - 1
   do i = 1,m
      dp = 0.
      do 10 j = 1,m
10       dp = dp + c(i,j,k)*y(j,km1)
      y(i,k) = y(i,k) - dp
   end do
   call sol (m, m, a(1,1,k), y(1,k), ip(1,k))
end do
do i = 1,m
   dp = 0.
   do 40 j = 1,m
40    dp = dp + c(i,j,n)*y(j,nm1) + b(i,j,n)*y(j,nm2)
   y(i,n) = y(i,n) - dp
end do
call sol (m, m, a(1,1,n), y(1,n), ip(1,n))
! Backward solution sweep. ---------------------------------------------
do kb = 1,nm1
   k = n - kb
   kp1 = k + 1
   do i = 1,m
      dp = 0.
      do 60 j = 1,m
60       dp = dp + b(i,j,k)*y(j,kp1)
      y(i,k) = y(i,k) - dp
   end do
end do
do i = 1,m
   dp = 0.
   do 90 j = 1,m
90    dp = dp + c(i,j,1)*y(j,3)
   y(i,1) = y(i,1) - dp
end do
return
!-----------------------  End of subroutine solbt  ---------------------
end subroutine solbt

subroutine smslv(mo,n,m,a,b,kb,det,rcond,inert,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: kb, m, mo, n
real, intent(inout) :: a(*), b(*)
real, intent(inout) :: det(2), rcond
real, intent(inout) :: wk(n)
integer, intent(inout) :: inert(3), ipvt(n)
integer :: j, job
real :: t
integer :: onej
!     ------------------
!     ------------------
!
!          Matrix factorization and computation of rcond
!
ierr = 0
call sspco(a,n,ipvt,rcond,wk)
t = 1.0 + rcond
if (t .eq. 1.0) go to 30
!
!                  Solution of the equation AX=b
!
if (m .lt. 1) go to 20
onej = 1
do 10 j = 1,m
   call sspsl(a,n,ipvt,b(onej))
10 onej = onej + kb
!
!             Calculation of det and the inverse of A
!
20 job = 110
if (mo .eq. 0) job = 111
call sspdi(a,n,ipvt,det,inert,wk,job)
return
!
!                  The problem cannot be solved
!
30 ierr = 1
return
end subroutine smslv

pure subroutine sspco(ap,n,kpvt,rcond,z)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
real, intent(inout) :: ap(*), z(*)
real, intent(inout) :: rcond
real :: ak, akm1, bk, bkm1, denom, ek, t
real :: anorm, s, ynorm
integer :: i, ij, ik, ikm1, ikp1, info, j, jm1, j1
integer :: k, kk, km1k, km1km1, kp, kps, ks
interface
   pure function sasum(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: sasum
   end function sasum
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
   pure subroutine sspfa(ap,n,kpvt,info)
      implicit none
      real, intent(inout) :: ap(*)
      integer, intent(in) :: n
      integer, intent(inout) :: kpvt(*)
      integer, intent(out) :: info
   end subroutine sspfa
end interface
!
!     sspco factors a real symmetric matrix stored in packed
!     form by elimination with symmetric pivoting and estimates
!     the condition of the matrix.
!
!     If  rcond  is not needed, sspfa is slightly faster.
!     To solve  A*X = B , follow sspco by sspsl.
!     To compute  inverse(A)*C , follow sspco by sspsl.
!     To compute  inverse(A) , follow sspco by sspdi.
!     To compute  determinant(A) , follow sspco by sspdi.
!     To compute  inertia(A), follow sspco by sspdi.
!
!     On entry
!
!        ap      real (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!     Output
!
!        ap      A BLOCK DIAGONAL MATRIX AND THE MULTIPLIERS WHICH
!                were used to obtain it stored in packed form.
!                The factorization can be written  A = U*D*trans(U)
!                where  U  is a product of permutation and unit
!                upper triangular matrices , trans(U) is the
!                transpose of  U , and  D  is block diagonal
!                with 1 by 1 and 2 by 2 blocks.
!
!        kpvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        rcond   REAL
!                an estimate of the reciprocal condition of  A .
!                For the system  A*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!
!        z       real(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!
!     Packed storage
!
!          The following program segment will pack the upper
!          triangle of a symmetric matrix.
!
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k) = a(i,j)
!             10    continue
!             20 continue
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     LINPACK sspfa
!     BLAS saxpy,sdot,sscal,sasum
!     Fortran abs,AMAX1,IABS,sign
!
!     Internal variables
!
!
!
!     Find norm of a using only upper half
!
j1 = 1
do j = 1, n
   z(j) = sasum(j,ap(j1),1)
   ij = j1
   j1 = j1 + j
   jm1 = j - 1
   if (jm1 .lt. 1) go to 20
   do i = 1, jm1
      z(i) = z(i) + abs(ap(ij))
      ij = ij + 1
   end do
20 continue
end do
anorm = 0.0e0
do j = 1, n
   anorm = amax1(anorm,z(j))
end do
!
!     Factor
!
call sspfa(ap,n,kpvt,info)
!
!     rcond = 1/(norm(A)*(estimate of norm(inverse(A)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  A*z = Y  AND  A*Y = E .
!     The components of  E  are chosen to cause maximum local
!     growth in the elements of W  where  U*D*W = E .
!     The vectors are frequently rescaled to avoid overflow.
!
!     SOLVE U*D*W = E
!
ek = 1.0e0
do j = 1, n
   z(j) = 0.0e0
end do
k = n
ik = (n*(n - 1))/2
60 if (k .eq. 0) go to 120
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) .lt. 0) ks = 2
kp = iabs(kpvt(k))
kps = k + 1 - ks
if (kp .eq. kps) go to 70
t = z(kps)
z(kps) = z(kp)
z(kp) = t
70 continue
if (z(k) .ne. 0.0e0) ek = sign(ek,z(k))
z(k) = z(k) + ek
call saxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks .eq. 1) go to 80
if (z(k - 1) .ne. 0.0e0) ek = sign(ek,z(k - 1))
z(k - 1) = z(k - 1) + ek
call saxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
80 continue
if (ks .eq. 2) go to 100
if (abs(z(k)) .le. abs(ap(kk))) go to 90
s = abs(ap(kk))/abs(z(k))
call sscal(n,s,z,1)
ek = s*ek
90 continue
if (ap(kk) .ne. 0.0e0) z(k) = z(k)/ap(kk)
if (ap(kk) .eq. 0.0e0) z(k) = 1.0e0
go to 110
100 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0e0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
110 continue
k = k - ks
ik = ik - k
if (ks .eq. 2) ik = ik - (k + 1)
go to 60
120 continue
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
!
!     SOLVE TRANS(U)*Y = W
!
k = 1
ik = 0
130 if (k .gt. n) go to 160
ks = 1
if (kpvt(k) .lt. 0) ks = 2
if (k .eq. 1) go to 150
z(k) = z(k) + sdot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks .eq. 2) &
   & z(k + 1) = z(k + 1) + sdot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = iabs(kpvt(k))
if (kp .eq. k) go to 140
t = z(k)
z(k) = z(kp)
z(kp) = t
140 continue
150 continue
ik = ik + k
if (ks .eq. 2) ik = ik + (k + 1)
k = k + ks
go to 130
160 continue
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
!
ynorm = 1.0e0
!
!     SOLVE U*D*V = Y
!
k = n
ik = n*(n - 1)/2
170 if (k .eq. 0) go to 230
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) .lt. 0) ks = 2
if (k .eq. ks) go to 190
kp = iabs(kpvt(k))
kps = k + 1 - ks
if (kp .eq. kps) go to 180
t = z(kps)
z(kps) = z(kp)
z(kp) = t
180 continue
call saxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks .eq. 2) call saxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
190 continue
if (ks .eq. 2) go to 210
if (abs(z(k)) .le. abs(ap(kk))) go to 200
s = abs(ap(kk))/abs(z(k))
call sscal(n,s,z,1)
ynorm = s*ynorm
200 continue
if (ap(kk) .ne. 0.0e0) z(k) = z(k)/ap(kk)
if (ap(kk) .eq. 0.0e0) z(k) = 1.0e0
go to 220
210 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0e0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
220 continue
k = k - ks
ik = ik - k
if (ks .eq. 2) ik = ik - (k + 1)
go to 170
230 continue
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
!
!     SOLVE TRANS(U)*z = V
!
k = 1
ik = 0
240 if (k .gt. n) go to 270
ks = 1
if (kpvt(k) .lt. 0) ks = 2
if (k .eq. 1) go to 260
z(k) = z(k) + sdot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks .eq. 2) &
   & z(k + 1) = z(k + 1) + sdot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = iabs(kpvt(k))
if (kp .eq. k) go to 250
t = z(k)
z(k) = z(kp)
z(kp) = t
250 continue
260 continue
ik = ik + k
if (ks .eq. 2) ik = ik + (k + 1)
k = k + ks
go to 240
270 continue
!     MAKE ZNORM = 1.0
s = 1.0e0/sasum(n,z,1)
call sscal(n,s,z,1)
ynorm = s*ynorm
!
if (anorm .ne. 0.0e0) rcond = ynorm/anorm
if (anorm .eq. 0.0e0) rcond = 0.0e0
return
end subroutine sspco

pure subroutine sspfa(ap,n,kpvt,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
integer, intent(out) :: info
real, intent(inout) :: ap(*)
real :: ak, akm1, bk, bkm1, denom, mulk, mulkm1, t
real :: absakk, alpha, colmax, rowmax
integer :: ij, ijj, ik, ikm1, im, imax, imaxp1, imim, imj, imk
integer :: j, jj, jk, jkm1, jmax, jmim, k, kk, km1, km1k, km1km1, &
   & km2, kstep
logical :: swap
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure subroutine sswap(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine sswap
end interface
!
!     sspfa factors a real symmetric matrix stored in
!     packed form by elimination with symmetric pivoting.
!
!     To solve  A*X = B , follow sspfa by sspsl.
!     To compute  inverse(A)*C , follow sspfa by sspsl.
!     To compute  determinant(A) , follow sspfa by sspdi.
!     To compute  inertia(A) , follow sspfa by sspdi.
!     To compute  inverse(A) , follow sspfa by sspdi.
!
!     On entry
!
!        ap      real (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!     Output
!
!        ap      A BLOCK DIAGONAL MATRIX AND THE MULTIPLIERS WHICH
!                were used to obtain it stored in packed form.
!                The factorization can be written  A = U*D*trans(U)
!                where  U  is a product of permutation and unit
!                upper triangular matrices , trans(U) is the
!                transpose of  U , and  D  is block diagonal
!                with 1 by 1 and 2 by 2 blocks.
!
!        kpvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if the k-TH pivot block is singular. This is
!                     not an error condition for this subroutine,
!                     but it does indicate that sspsl or sspdi may
!                     divide by zero if called.
!
!     Packed storage
!
!          The following program segment will pack the upper
!          triangle of a symmetric matrix.
!
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k)  = a(i,j)
!             10    continue
!             20 continue
!
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sswap,isamax
!     Fortran abs,AMAX1,sqrt
!
!     Internal variables
!
!
!
!     Initialize
!
!     alpha is used in choosing pivot block SIZE.
alpha = (1.0e0 + sqrt(17.0e0))/8.0e0
!
info = 0
!
!     Main loop on k, which goes from n to 1.
!
k = n
ik = (n*(n - 1))/2
10 continue
!
!        Leave the loop if k=0 Or k=1.
!
!     ...Exit
if (k .eq. 0) go to 200
if (k .gt. 1) go to 20
kpvt(1) = 1
if (ap(1) .eq. 0.0e0) info = 1
!     ......Exit
go to 200
20 continue
!
!        This section of code determines the kind of
!        elimination to be performed.  When it is completed,
!        KSTEP will be set to the size of the pivot block, and
!        swap will be set to .TRUE. if an interchange is
!        required.
!
km1 = k - 1
kk = ik + k
absakk = abs(ap(kk))
!
!        Determine the largest off-diagonal element in
!        column k.
!
imax = isamax(k - 1,ap(ik + 1),1)
imk = ik + imax
colmax = abs(ap(imk))
if (absakk .lt. alpha*colmax) go to 30
kstep = 1
swap = .false.
go to 90
30 continue
!
!           Determine the largest off-diagonal element in
!           row imax.
!
rowmax = 0.0e0
imaxp1 = imax + 1
im = imax*(imax - 1)/2
imj = im + 2*imax
do j = imaxp1, k
   rowmax = amax1(rowmax,abs(ap(imj)))
   imj = imj + j
end do
if (imax .eq. 1) go to 50
jmax = isamax(imax - 1,ap(im + 1),1)
jmim = jmax + im
rowmax = amax1(rowmax,abs(ap(jmim)))
50 continue
imim = imax + im
if (abs(ap(imim)) .lt. alpha*rowmax) go to 60
kstep = 1
swap = .true.
go to 80
60 continue
if (absakk .lt. alpha*colmax*(colmax/rowmax)) go to 70
kstep = 1
swap = .false.
go to 80
70 continue
kstep = 2
swap = imax .ne. km1
80 continue
90 continue
if (amax1(absakk,colmax) .ne. 0.0e0) go to 100
!
!           Column k is zero.  Set info and iterate the loop.
!
kpvt(k) = k
info = k
go to 190
100 continue
if (kstep .eq. 2) go to 140
!
!           1 X 1 pivot block.
!
if (.not.swap) go to 120
!
!              Perform an interchange.
!
call sswap(imax,ap(im + 1),1,ap(ik + 1),1)
imj = ik + imax
do jj = imax, k
   j = k + imax - jj
   jk = ik + j
   t = ap(jk)
   ap(jk) = ap(imj)
   ap(imj) = t
   imj = imj - (j - 1)
end do
120 continue
!
!           Perform the elimination.
!
ij = ik - (k - 1)
do jj = 1, km1
   j = k - jj
   jk = ik + j
   mulk = -ap(jk)/ap(kk)
   t = mulk
   call saxpy(j,t,ap(ik + 1),1,ap(ij + 1),1)
   ijj = ij + j
   ap(jk) = mulk
   ij = ij - (j - 1)
end do
!
!           Set the pivot array.
!
kpvt(k) = k
if (swap) kpvt(k) = imax
go to 190
140 continue
!
!           2 X 2 pivot block.
!
km1k = ik + k - 1
ikm1 = ik - (k - 1)
if (.not.swap) go to 160
!
!              Perform an interchange.
!
call sswap(imax,ap(im + 1),1,ap(ikm1 + 1),1)
imj = ikm1 + imax
do jj = imax, km1
   j = km1 + imax - jj
   jkm1 = ikm1 + j
   t = ap(jkm1)
   ap(jkm1) = ap(imj)
   ap(imj) = t
   imj = imj - (j - 1)
end do
t = ap(km1k)
ap(km1k) = ap(imk)
ap(imk) = t
160 continue
!
!           Perform the elimination.
!
km2 = k - 2
if (km2 .eq. 0) go to 180
ak = ap(kk)/ap(km1k)
km1km1 = ikm1 + k - 1
akm1 = ap(km1km1)/ap(km1k)
denom = 1.0e0 - ak*akm1
ij = ik - (k - 1) - (k - 2)
do jj = 1, km2
   j = km1 - jj
   jk = ik + j
   bk = ap(jk)/ap(km1k)
   jkm1 = ikm1 + j
   bkm1 = ap(jkm1)/ap(km1k)
   mulk = (akm1*bk - bkm1)/denom
   mulkm1 = (ak*bkm1 - bk)/denom
   t = mulk
   call saxpy(j,t,ap(ik + 1),1,ap(ij + 1),1)
   t = mulkm1
   call saxpy(j,t,ap(ikm1 + 1),1,ap(ij + 1),1)
   ap(jk) = mulk
   ap(jkm1) = mulkm1
   ijj = ij + j
   ij = ij - (j - 1)
end do
180 continue
!
!           Set the pivot array.
!
kpvt(k) = 1 - k
if (swap) kpvt(k) = -imax
kpvt(k - 1) = kpvt(k)
190 continue
ik = ik - (k - 1)
if (kstep .eq. 2) ik = ik - (k - 2)
k = k - kstep
go to 10
200 continue
return
end subroutine sspfa

pure subroutine sspsl(ap,n,kpvt,b)
implicit none
integer, intent(in) :: n, kpvt(*)
real, intent(in) :: ap(*)
real, intent(inout) :: b(*)
real :: ak, akm1, bk, bkm1, denom, temp
integer :: ik, ikm1, ikp1, k, kk, km1k, km1km1, kp
interface
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
end interface
!
!     SSISL solves the real symmetric system
!     A * X = b
!     using the factors computed by sspfa.
!
!     On entry
!
!        ap      real(n*(n+1)/2)
!                the output from sspfa.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!        kpvt    INTEGER(n)
!                the pivot vector from sspfa.
!
!        b       real(n)
!                the right hand side vector.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero may occur if  sspco  has set RCOND .EQ. 0.0
!        or  sspfa  has set info .NE. 0  .
!
!     To compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call sspfa(ap,n,kpvt,info)
!           if (info .ne. 0) go to ...
!           do 10 j = 1, p
!              call sspsl(ap,n,kpvt,c(1,j))
!        10 continue
!
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sdot
!     FORTRAN IABS
!
!     Internal variables.
!
!
!     Loop backward applying the transformations and
!     D inverse to b.
!
k = n
ik = (n*(n - 1))/2
10 if (k .eq. 0) go to 80
kk = ik + k
if (kpvt(k) .lt. 0) go to 40
!
!           1 X 1 pivot block.
!
if (k .eq. 1) go to 30
kp = kpvt(k)
if (kp .eq. k) go to 20
!
!                 Interchange.
!
temp = b(k)
b(k) = b(kp)
b(kp) = temp
20 continue
!
!              Apply the transformation.
!
call saxpy(k - 1,b(k),ap(ik + 1),1,b(1),1)
30 continue
!
!           Apply D inverse.
!
b(k) = b(k)/ap(kk)
k = k - 1
ik = ik - k
go to 70
40 continue
!
!           2 X 2 pivot block.
!
ikm1 = ik - (k - 1)
if (k .eq. 2) go to 60
kp = iabs(kpvt(k))
if (kp .eq. k - 1) go to 50
!
!                 Interchange.
!
temp = b(k - 1)
b(k - 1) = b(kp)
b(kp) = temp
50 continue
!
!              Apply the transformation.
!
call saxpy(k - 2,b(k),ap(ik + 1),1,b(1),1)
call saxpy(k - 2,b(k - 1),ap(ikm1 + 1),1,b(1),1)
60 continue
!
!           Apply D inverse.
!
km1k = ik + k - 1
kk = ik + k
ak = ap(kk)/ap(km1k)
km1km1 = ikm1 + k - 1
akm1 = ap(km1km1)/ap(km1k)
bk = b(k)/ap(km1k)
bkm1 = b(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0e0
b(k) = (akm1*bk - bkm1)/denom
b(k - 1) = (ak*bkm1 - bk)/denom
k = k - 2
ik = ik - (k + 1) - k
70 continue
go to 10
80 continue
!
!     Loop forward applying the transformations.
!
k = 1
ik = 0
90 if (k .gt. n) go to 160
if (kpvt(k) .lt. 0) go to 120
!
!           1 X 1 pivot block.
!
if (k .eq. 1) go to 110
!
!              Apply the transformation.
!
b(k) = b(k) + sdot(k - 1,ap(ik + 1),1,b(1),1)
kp = kpvt(k)
if (kp .eq. k) go to 100
!
!                 Interchange.
!
temp = b(k)
b(k) = b(kp)
b(kp) = temp
100 continue
110 continue
ik = ik + k
k = k + 1
go to 150
120 continue
!
!           2 X 2 pivot block.
!
if (k .eq. 1) go to 140
!
!              Apply the transformation.
!
b(k) = b(k) + sdot(k - 1,ap(ik + 1),1,b(1),1)
ikp1 = ik + k
b(k + 1) = b(k + 1) + sdot(k - 1,ap(ikp1 + 1),1,b(1),1)
kp = iabs(kpvt(k))
if (kp .eq. k) go to 130
!
!                 Interchange.
!
temp = b(k)
b(k) = b(kp)
b(kp) = temp
130 continue
140 continue
ik = ik + k + k + 1
k = k + 2
150 continue
go to 90
160 continue
return
end subroutine sspsl

subroutine sspdi(ap,n,kpvt,det,inert,work,job)
implicit none
integer, intent(in) :: n, job
real, intent(inout) :: ap(*), work(*)
real, intent(inout) :: det(2)
integer, intent(in) :: kpvt(*)
integer, intent(inout) :: inert(3)
real :: akkp1, sdot, temp
real :: ten, d, t, ak, akp1
integer :: ij, ik, ikp1, iks, j, jb, jk, jkp1
integer :: k, kk, kkp1, km1, ks, ksj, kskp1, kstep
logical :: noinv, nodet, noert
!
!     sspdi computes the determinant, inertia and inverse
!     of a real symmetric matrix using the factors from sspfa,
!     where the matrix is stored in packed form.
!
!     On entry
!
!        ap      real (n*(n+1)/2)
!                the output from sspfa.
!
!        n       INTEGER
!                the order of the matrix A.
!
!        kpvt    INTEGER(n)
!                the pivot vector from sspfa.
!
!        WORK    real(n)
!                work vector.  Contents ignored.
!
!        JOB     INTEGER
!                job has the decimal expansion  abc  where
!                   if  C .NE. 0, the inverse is computed,
!                   if  B .NE. 0, the determinant is computed,
!                   if  A .NE. 0, the inertia is computed.
!
!                For example, job = 111  Gives all three.
!
!     On return
!
!        Variables not requested by job are not used.
!
!        ap     CONTAINS THE UPPER TRIANGLE OF THE INVERSE OF
!               the original matrix, stored in packed form.
!               The columns of the upper triangle are stored
!               sequentially in a one-dimensional array.
!
!        det    real(2)
!               determinant of original matrix.
!               determinant = det(1) * 10.0**det(2)
!               WITH 1.0 .LE. abs(det(1)) .LT. 10.0
!               OR det(1) = 0.0.
!
!        Inert  integer(3)
!               the inertia of the original matrix.
!               inert(1)  =  Number of positive eigenvalues.
!               inert(2)  =  Number of negative eigenvalues.
!               inert(3)  =  Number of zero eigenvalues.
!
!     Error condition
!
!        A division by zero will occur if the inverse is requested
!        and  sspco  has set RCOND .EQ. 0.0
!        or  sspfa  has set  info .NE. 0 .
!
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,scopy,sdot,sswap
!     Fortran abs,IABS,mod
!
!     Internal variables.
!
!
noinv = mod(job,10) .eq. 0
nodet = mod(job,100)/10 .eq. 0
noert = mod(job,1000)/100 .eq. 0
!
if (nodet .and. noert) go to 140
if (noert) go to 10
inert(1) = 0
inert(2) = 0
inert(3) = 0
10 continue
if (nodet) go to 20
det(1) = 1.0e0
det(2) = 0.0e0
ten = 10.0e0
20 continue
t = 0.0e0
ik = 0
do 130 k = 1, n
   kk = ik + k
   d = ap(kk)
!
!           Check if 1 by 1
!
   if (kpvt(k) .gt. 0) go to 50
!
!              2 By 2 block
!              USE det (d  S)  =  (d/t * C - t) * t  ,  t = abs(S)
!                      (S  C)
!              to avoid underflow/overflow troubles.
!              Take two passes through scaling.  Use  t  for flag.
!
   if (t .ne. 0.0e0) go to 30
   ikp1 = ik + k
   kkp1 = ikp1 + k
   t = abs(ap(kkp1))
   d = (d/t)*ap(kkp1 + 1) - t
   go to 40
30 continue
   d = t
   t = 0.0e0
40 continue
50 continue
!
   if (noert) go to 60
   if (d .gt. 0.0e0) inert(1) = inert(1) + 1
   if (d .lt. 0.0e0) inert(2) = inert(2) + 1
   if (d .eq. 0.0e0) inert(3) = inert(3) + 1
60 continue
!
   if (nodet) go to 120
   det(1) = d*det(1)
   if (det(1) .eq. 0.0e0) go to 110
70 if (abs(det(1)) .ge. 1.0e0) go to 80
   det(1) = ten*det(1)
   det(2) = det(2) - 1.0e0
   go to 70
80 continue
90 if (abs(det(1)) .lt. ten) go to 100
   det(1) = det(1)/ten
   det(2) = det(2) + 1.0e0
   go to 90
100 continue
110 continue
120 continue
   ik = ik + k
130 continue
140 continue
!
!     Compute inverse(A)
!
if (noinv) go to 270
k = 1
ik = 0
150 if (k .gt. n) go to 260
km1 = k - 1
kk = ik + k
ikp1 = ik + k
kkp1 = ikp1 + k
if (kpvt(k) .lt. 0) go to 180
!
!              1 By 1
!
ap(kk) = 1.0e0/ap(kk)
if (km1 .lt. 1) go to 170
call scopy(km1,ap(ik + 1),1,work,1)
ij = 0
do j = 1, km1
   jk = ik + j
   ap(jk) = sdot(j,ap(ij + 1),1,work,1)
   call saxpy(j - 1,work(j),ap(ij + 1),1,ap(ik + 1),1)
   ij = ij + j
end do
ap(kk) = ap(kk) + sdot(km1,work,1,ap(ik + 1),1)
170 continue
kstep = 1
go to 220
180 continue
!
!              2 By 2
!
t = abs(ap(kkp1))
ak = ap(kk)/t
akp1 = ap(kkp1 + 1)/t
akkp1 = ap(kkp1)/t
d = t*(ak*akp1 - 1.0e0)
ap(kk) = akp1/d
ap(kkp1 + 1) = ak/d
ap(kkp1) = -akkp1/d
if (km1 .lt. 1) go to 210
call scopy(km1,ap(ikp1 + 1),1,work,1)
ij = 0
do j = 1, km1
   jkp1 = ikp1 + j
   ap(jkp1) = sdot(j,ap(ij + 1),1,work,1)
   call saxpy(j - 1,work(j),ap(ij + 1),1,ap(ikp1 + 1),1)
   ij = ij + j
end do
ap(kkp1 + 1) = ap(kkp1 + 1) &
   & + sdot(km1,work,1,ap(ikp1 + 1),1)
ap(kkp1) = ap(kkp1) &
   & + sdot(km1,ap(ik + 1),1,ap(ikp1 + 1),1)
call scopy(km1,ap(ik + 1),1,work,1)
ij = 0
do j = 1, km1
   jk = ik + j
   ap(jk) = sdot(j,ap(ij + 1),1,work,1)
   call saxpy(j - 1,work(j),ap(ij + 1),1,ap(ik + 1),1)
   ij = ij + j
end do
ap(kk) = ap(kk) + sdot(km1,work,1,ap(ik + 1),1)
210 continue
kstep = 2
220 continue
!
!           Swap
!
ks = iabs(kpvt(k))
if (ks .eq. k) go to 250
iks = (ks*(ks - 1))/2
call sswap(ks,ap(iks + 1),1,ap(ik + 1),1)
ksj = ik + ks
do jb = ks, k
   j = k + ks - jb
   jk = ik + j
   temp = ap(jk)
   ap(jk) = ap(ksj)
   ap(ksj) = temp
   ksj = ksj - (j - 1)
end do
if (kstep .eq. 1) go to 240
kskp1 = ikp1 + ks
temp = ap(kskp1)
ap(kskp1) = ap(kkp1)
ap(kkp1) = temp
240 continue
250 continue
ik = ik + k
if (kstep .eq. 2) ik = ik + k + 1
k = k + kstep
go to 150
260 continue
270 continue
return
end subroutine sspdi

subroutine dsmslv(mo,n,m,a,b,kb,det,rcond,inert,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: kb, m, mo, n
double precision, intent(inout) :: a(*), b(*)
double precision, intent(inout) :: det(2), rcond
double precision, intent(inout) :: wk(n)
integer, intent(inout) :: inert(3), ipvt(n)
integer :: j, job
double precision :: t
integer :: onej
!     ------------------
!     ------------------
!
!          Matrix factorization and computation of rcond
!
ierr = 0
call dspco(a,n,ipvt,rcond,wk)
t = 1.d0 + rcond
if (t .eq. 1.d0) go to 30
!
!                  Solution of the equation AX=b
!
if (m .lt. 1) go to 20
onej = 1
do 10 j = 1,m
   call dspsl(a,n,ipvt,b(onej))
10 onej = onej + kb
!
!             Calculation of det and the inverse of A
!
20 job = 110
if (mo .eq. 0) job = 111
call dspdi(a,n,ipvt,det,inert,wk,job)
return
!
!                  The problem cannot be solved
!
30 ierr = 1
return
end subroutine dsmslv

pure subroutine dspco(ap,n,kpvt,rcond,z)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
double precision, intent(inout) :: ap(*), z(*)
double precision, intent(inout) :: rcond
double precision :: ak, akm1, bk, bkm1, denom, ek, t
double precision :: anorm, s, ynorm
integer :: i, ij, ik, ikm1, ikp1, info, j, jm1, j1
integer :: k, kk, km1k, km1km1, kp, kps, ks
interface
   pure function dasum(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dasum
   end function dasum
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure subroutine dspfa(ap,n,kpvt,info)
      implicit none
      double precision, intent(inout) :: ap(*)
      integer, intent(in) :: n
      integer, intent(inout) :: kpvt(*)
      integer, intent(out) :: info
   end subroutine dspfa
end interface
!
!     dspco factors a double precision symmetric matrix stored in
!     packed form by elimination with symmetric pivoting and estimates
!     the condition of the matrix.
!
!     If  rcond  is not needed, dspfa is slightly faster.
!     To solve  A*X = B , follow dspco by dspsl.
!     To compute  inverse(A)*C , follow dspco by dspsl.
!     To compute  inverse(A) , follow dspco by dspdi.
!     To compute  determinant(A) , follow dspco by dspdi.
!     To compute  inertia(A), follow dspco by dspdi.
!
!     On entry
!
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the packed form of A symmetric matrix  A .  The
!                columns of the upper triangle are stored sequentially
!                in a one-dimensional array of length  n*(n+1)/2 .
!                See comments below for details.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!     Output
!
!        ap      A BLOCK DIAGONAL MATRIX AND THE MULTIPLIERS WHICH
!                were used to obtain it stored in packed form.
!                The factorization can be written  A = U*D*trans(U)
!                where  U  is a product of permutation and unit
!                upper triangular matrices , trans(U) is the
!                transpose of  U , and  D  is block diagonal
!                with 1 by 1 and 2 by 2 blocks.
!
!        kpvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        rcond   DOUBLE PRECISION
!                an estimate of the reciprocal condition of  A .
!                For the system  A*X = B , relative perturbations
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!
!        z       DOUBLE PRECISION(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!
!     Packed storage
!
!          The following program segment will pack the upper
!          triangle of a symmetric matrix.
!
!                k = 0
!                do 20 j = 1, n
!                   do 10 i = 1, j
!                      k = k + 1
!                      ap(k) = a(i,j)
!             10    continue
!             20 continue
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     LINPACK dspfa
!     BLAS daxpy,ddot,dscal,dasum
!     Fortran dabs,DMAX1,IABS,DSIGN
!
!     Internal variables
!
!
!
!     Find norm of a using only upper half
!
j1 = 1
do j = 1, n
   z(j) = dasum(j,ap(j1),1)
   ij = j1
   j1 = j1 + j
   jm1 = j - 1
   if (jm1 .lt. 1) go to 20
   do i = 1, jm1
      z(i) = z(i) + dabs(ap(ij))
      ij = ij + 1
   end do
20 continue
end do
anorm = 0.0d0
do j = 1, n
   anorm = dmax1(anorm,z(j))
end do
!
!     Factor
!
call dspfa(ap,n,kpvt,info)
!
!     rcond = 1/(norm(A)*(estimate of norm(inverse(A)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  A*z = Y  AND  A*Y = E .
!     The components of  E  are chosen to cause maximum local
!     growth in the elements of W  where  U*D*W = E .
!     The vectors are frequently rescaled to avoid overflow.
!
!     SOLVE U*D*W = E
!
ek = 1.0d0
do j = 1, n
   z(j) = 0.0d0
end do
k = n
ik = (n*(n - 1))/2
60 if (k .eq. 0) go to 120
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) .lt. 0) ks = 2
kp = iabs(kpvt(k))
kps = k + 1 - ks
if (kp .eq. kps) go to 70
t = z(kps)
z(kps) = z(kp)
z(kp) = t
70 continue
if (z(k) .ne. 0.0d0) ek = dsign(ek,z(k))
z(k) = z(k) + ek
call daxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks .eq. 1) go to 80
if (z(k - 1) .ne. 0.0d0) ek = dsign(ek,z(k - 1))
z(k - 1) = z(k - 1) + ek
call daxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
80 continue
if (ks .eq. 2) go to 100
if (dabs(z(k)) .le. dabs(ap(kk))) go to 90
s = dabs(ap(kk))/dabs(z(k))
call dscal(n,s,z,1)
ek = s*ek
90 continue
if (ap(kk) .ne. 0.0d0) z(k) = z(k)/ap(kk)
if (ap(kk) .eq. 0.0d0) z(k) = 1.0d0
go to 110
100 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0d0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
110 continue
k = k - ks
ik = ik - k
if (ks .eq. 2) ik = ik - (k + 1)
go to 60
120 continue
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
!
!     SOLVE TRANS(U)*Y = W
!
k = 1
ik = 0
130 if (k .gt. n) go to 160
ks = 1
if (kpvt(k) .lt. 0) ks = 2
if (k .eq. 1) go to 150
z(k) = z(k) + ddot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks .eq. 2) &
   & z(k + 1) = z(k + 1) + ddot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = iabs(kpvt(k))
if (kp .eq. k) go to 140
t = z(k)
z(k) = z(kp)
z(kp) = t
140 continue
150 continue
ik = ik + k
if (ks .eq. 2) ik = ik + (k + 1)
k = k + ks
go to 130
160 continue
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
!
ynorm = 1.0d0
!
!     SOLVE U*D*V = Y
!
k = n
ik = n*(n - 1)/2
170 if (k .eq. 0) go to 230
kk = ik + k
ikm1 = ik - (k - 1)
ks = 1
if (kpvt(k) .lt. 0) ks = 2
if (k .eq. ks) go to 190
kp = iabs(kpvt(k))
kps = k + 1 - ks
if (kp .eq. kps) go to 180
t = z(kps)
z(kps) = z(kp)
z(kp) = t
180 continue
call daxpy(k - ks,z(k),ap(ik + 1),1,z(1),1)
if (ks .eq. 2) call daxpy(k - ks,z(k - 1),ap(ikm1 + 1),1,z(1),1)
190 continue
if (ks .eq. 2) go to 210
if (dabs(z(k)) .le. dabs(ap(kk))) go to 200
s = dabs(ap(kk))/dabs(z(k))
call dscal(n,s,z,1)
ynorm = s*ynorm
200 continue
if (ap(kk) .ne. 0.0d0) z(k) = z(k)/ap(kk)
if (ap(kk) .eq. 0.0d0) z(k) = 1.0d0
go to 220
210 continue
km1k = ik + k - 1
km1km1 = ikm1 + k - 1
ak = ap(kk)/ap(km1k)
akm1 = ap(km1km1)/ap(km1k)
bk = z(k)/ap(km1k)
bkm1 = z(k - 1)/ap(km1k)
denom = ak*akm1 - 1.0d0
z(k) = (akm1*bk - bkm1)/denom
z(k - 1) = (ak*bkm1 - bk)/denom
220 continue
k = k - ks
ik = ik - k
if (ks .eq. 2) ik = ik - (k + 1)
go to 170
230 continue
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
!
!     SOLVE TRANS(U)*z = V
!
k = 1
ik = 0
240 if (k .gt. n) go to 270
ks = 1
if (kpvt(k) .lt. 0) ks = 2
if (k .eq. 1) go to 260
z(k) = z(k) + ddot(k - 1,ap(ik + 1),1,z(1),1)
ikp1 = ik + k
if (ks .eq. 2) &
   & z(k + 1) = z(k + 1) + ddot(k - 1,ap(ikp1 + 1),1,z(1),1)
kp = iabs(kpvt(k))
if (kp .eq. k) go to 250
t = z(k)
z(k) = z(kp)
z(kp) = t
250 continue
260 continue
ik = ik + k
if (ks .eq. 2) ik = ik + (k + 1)
k = k + ks
go to 240
270 continue
!     MAKE ZNORM = 1.0
s = 1.0d0/dasum(n,z,1)
call dscal(n,s,z,1)
ynorm = s*ynorm
!
if (anorm .ne. 0.0d0) rcond = ynorm/anorm
if (anorm .eq. 0.0d0) rcond = 0.0d0
return
end subroutine dspco

