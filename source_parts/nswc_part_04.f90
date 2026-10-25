subroutine calct(bool,n,sr,si,tr,ti,pvr,pvi,are,hr,hi,qhr,qhi)
implicit none
integer, intent(in) :: n
!
!     This subroutine computes T = -P(S)/H(S)
!
!     bool - Logical variable, which is set to .TRUE. if H(S) is
!            essentially zero.
!
logical, intent(inout) :: bool
double precision, intent(in) :: sr, si
double precision, intent(inout) :: tr, ti
double precision, intent(in) :: pvr, pvi, are, hr(n), hi(n)
double precision, intent(inout) :: qhr(n), qhi(n)
double precision :: hvr, hvi, dcpabs
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

subroutine nexth(bool,n,tr,ti,hr,hi,qpr,qpi,qhr,qhi)
implicit none
integer, intent(in) :: n
integer :: j
!
!     Calculates the next shifted H polynomial.
!
!     bool - Logical variable. If .TRUE. H(S) is essentially zero.
!
logical, intent(in) :: bool
double precision, intent(in) :: tr, ti
double precision, intent(inout) :: hr(n), hi(n)
double precision, intent(in) :: qpr(n), qpi(n), qhr(n), qhi(n)
double precision :: t1, t2
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

subroutine polyev(n,sr,si,pr,pi,qr,qi,pvr,pvi)
implicit none
integer, intent(in) :: n
integer :: i
!
!     Evaluates a polynomial P at S by the Horner recurrence algo.,
!     placing the partial sums in Q and the computed value in PV.
!
double precision, intent(in) :: pr(n), pi(n)
double precision, intent(inout) :: qr(n), qi(n)
double precision, intent(in) :: sr, si
double precision, intent(out) :: pvr, pvi
double precision :: t
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

double precision function errev(nn,qr,qi,ms,mp,are,mre)
implicit none
integer, intent(in) :: nn
integer :: i
!
!     Bounds the error in evaluating the polynomial by the Horner
!     recurrence algorithm.
!
!     QR,qi   - THE PARTIAL SUMS
!     ms      - Modulus of the point
!     mp      - Modulus of the polynomial value
!     are,mre - Error bounds on complex addition and multiplication
!
double precision, intent(in) :: qr(nn), qi(nn), ms, mp, are, mre
double precision :: e, dcpabs
!
e = dcpabs(qr(1),qi(1))*mre/(are + mre)
do i = 1,nn
   e = e*ms + dcpabs(qr(i),qi(i))
end do
errev = e*(are + mre) - mp*mre
return
end function errev

subroutine rbnd (n, c, w, abserr, relerr, klust, ker)
implicit none
integer, intent(inout) :: ker
integer, intent(in) :: n
integer :: j, jp1, k, l, m, nm1, np1
real :: b, cert, dist, eps, olderr, p, power, r, rat, wnrm, wrad
real :: spmpar
real :: cpabs
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
complex, intent(in) :: w(n)
complex :: z
integer, intent(inout) :: klust(n)
real, intent(in) :: c(*)
real, intent(inout) :: abserr(n), relerr(n)
double precision :: xr, xi, vr, vi, vt
logical :: shrunk
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
40 continue
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
90 continue
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

subroutine cbnd (n, c, w, abserr, relerr, klust, ker)
implicit none
integer, intent(inout) :: ker
integer, intent(in) :: n
integer :: j, jp1, k, l, m, nm1, np1
real :: b, cert, dist, eps, olderr, p, power, r, rat, wnrm, wrad
real :: spmpar
real :: cpabs
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
complex, intent(in) :: c(*), w(n)
complex :: z
integer, intent(inout) :: klust(n)
real, intent(inout) :: abserr(n), relerr(n)
double precision :: xr, xi, vr, vi, vt
logical :: shrunk
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
40 continue
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
90 continue
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

subroutine  scopy(n,sx,incx,sy,incy)
implicit none
!
!     Copies a vector, X, to a vector, Y.
!     Uses unrolled loops for increments equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
real, intent(inout) :: sy(*)
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  sy(i) = sx(i)
end do
if( n .lt. 7 ) return
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

subroutine  dcopy(n,dx,incx,dy,incy)
implicit none
!
!     Copies a vector, X, to a vector, Y.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
double precision, intent(inout) :: dy(*)
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  dy(i) = dx(i)
end do
if( n .lt. 7 ) return
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

subroutine  ccopy(n,cx,incx,cy,incy)
implicit none
!
!     Copies a vector, X, to a vector, Y.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*)
complex, intent(inout) :: cy(*)
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

subroutine iswap (n,ix,incx,iy,incy)
implicit none
integer, intent(in) :: incx, incy, n
integer :: i, iix, iiy, m, mp1, ns
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
integer, intent(inout) :: ix(*), iy(*)
integer :: itemp1, itemp2, itemp3
!
if (n .le. 0) return
if (incx .ne. incy) go to 5
if (incx-1) 5,20,60
5 continue
!
!       Code for unequal or nonpositive increments.
!
iix = 1
iiy = 1
if (incx .lt. 0) iix = (1-n)*incx + 1
if (incy .lt. 0) iiy = (1-n)*incy + 1
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
   itemp2 = ix(i+1)
   itemp3 = ix(i+2)
   ix(i) = iy(i)
   ix(i+1) = iy(i+1)
   ix(i+2) = iy(i+2)
   iy(i) = itemp1
   iy(i+1) = itemp2
   iy(i+2) = itemp3
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

subroutine  sswap (n,sx,incx,sy,incy)
implicit none
!
!     Interchanges two vectors.
!     Uses unrolled loops for increments equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(inout) :: sx(*), sy(*)
real :: stemp
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  stemp = sx(i)
  sx(i) = sy(i)
  sy(i) = stemp
end do
if( n .lt. 3 ) return
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

subroutine  dswap (n,dx,incx,dy,incy)
implicit none
!
!     Interchanges two vectors.
!     Uses unrolled loops for increments equal one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(inout) :: dx(*), dy(*)
double precision :: dtemp
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  dtemp = dx(i)
  dx(i) = dy(i)
  dy(i) = dtemp
end do
if( n .lt. 3 ) return
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

subroutine  cswap (n,cx,incx,cy,incy)
implicit none
!
!     Interchanges two vectors.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(inout) :: cx(*), cy(*)
complex :: ctemp
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

subroutine  srot (n,sx,incx,sy,incy,c,s)
implicit none
!
!     Applies a plane rotation.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(inout) :: sx(*), sy(*)
real :: stemp
real, intent(in) :: c, s
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

subroutine  drot (n,dx,incx,dy,incy,c,s)
implicit none
!
!     Applies a plane rotation.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(inout) :: dx(*), dy(*)
double precision :: dtemp
double precision, intent(in) :: c, s
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

subroutine  csrot (n,cx,incx,cy,incy,c,s)
implicit none
!
!     Applies a plane rotation, where the cos and sin (c and s) are real
!     and the vectors cx and cy are complex.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(inout) :: cx(*), cy(*)
complex :: ctemp
real, intent(in) :: c, s
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!       Code for unequal increments or equal increments not equal
!         to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

subroutine srotmg (sd1,sd2,sx1,sy1,sparam)
implicit none
real, intent(inout) :: sd1, sd2, sparam(5), sx1
real, intent(in) :: sy1
real :: gam, gamsq, one, rgamsq, sflag, sh11, sh12, sh21, sh22, &
&sp1, sp2, sq1, sq2, stemp, su, two, zero
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
data zero,one,two /0.e0,1.e0,2.e0/
data gam,gamsq,rgamsq/4096.e0,1.67772e7,5.96046e-8/
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
    if(sflag)250,230,240
230 continue
         sparam(3)=sh21
         sparam(4)=sh12
         go to 260
240 continue
         sparam(2)=sh11
         sparam(5)=sh22
         go to 260
250 continue
         sparam(2)=sh11
         sparam(3)=sh21
         sparam(4)=sh12
         sparam(5)=sh22
260 continue
    sparam(1)=sflag
    return
end subroutine srotmg

subroutine srotm (n,sx,incx,sy,incy,sparam)
implicit none
integer, intent(in) :: incx, incy, n
real :: sparam(5)
real, intent(inout) :: sx(*), sy(*)
integer :: i, kx, ky, nsteps
real :: sflag, sh11, sh12, sh21, sh22, two, w, z, zero
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
data zero,two/0.e0,2.e0/
!
sflag=sparam(1)
if(n .le. 0 .or.(sflag+two.eq.zero)) go to 140
    if(.not.(incx.eq.incy.and. incx .gt.0)) go to 70
!
         nsteps=n*incx
         if(sflag) 50,10,30
10 continue
         sh21=sparam(3)
         sh12=sparam(4)
              do i=1,nsteps,incx
              w=sx(i)
              z=sy(i)
              sx(i)=w+z*sh12
              sy(i)=w*sh21+z
              end do
         go to 140
30 continue
         sh11=sparam(2)
         sh22=sparam(5)
              do i=1,nsteps,incx
              w=sx(i)
              z=sy(i)
              sx(i)=w*sh11+z
              sy(i)=-w+sh22*z
              end do
         go to 140
50 continue
         sh11=sparam(2)
         sh21=sparam(3)
         sh12=sparam(4)
         sh22=sparam(5)
              do i=1,nsteps,incx
              w=sx(i)
              z=sy(i)
              sx(i)=w*sh11+z*sh12
              sy(i)=w*sh21+z*sh22
              end do
         go to 140
70 continue
    kx=1
    ky=1
    if(incx .lt. 0) kx=1+(1-n)*incx
    if(incy .lt. 0) ky=1+(1-n)*incy
!
    if(sflag)120,80,100
80 continue
    sh21=sparam(3)
    sh12=sparam(4)
         do i=1,n
         w=sx(kx)
         z=sy(ky)
         sx(kx)=w+z*sh12
         sy(ky)=w*sh21+z
         kx=kx+incx
         ky=ky+incy
         end do
    go to 140
100 continue
    sh11=sparam(2)
    sh22=sparam(5)
         do i=1,n
         w=sx(kx)
         z=sy(ky)
         sx(kx)=w*sh11+z
         sy(ky)=-w+sh22*z
         kx=kx+incx
         ky=ky+incy
         end do
    go to 140
120 continue
    sh11=sparam(2)
    sh21=sparam(3)
    sh12=sparam(4)
    sh22=sparam(5)
         do i=1,n
         w=sx(kx)
         z=sy(ky)
         sx(kx)=w*sh11+z*sh12
         sy(ky)=w*sh21+z*sh22
         kx=kx+incx
         ky=ky+incy
         end do
140 continue
    return
    end subroutine srotm

subroutine drotmg (dd1,dd2,dx1,dy1,dparam)
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
double precision :: gam, one, rgamsq
double precision, intent(inout) :: dd2
double precision :: dh11, dh21
double precision, intent(inout) :: dparam(5)
double precision :: dp2, dq2, du
double precision, intent(in) :: dy1
double precision :: zero, gamsq
double precision, intent(inout) :: dd1
double precision :: dflag, dh12, dh22, dp1, dq1, dtemp
double precision, intent(inout) :: dx1
double precision :: two
!
data zero,one,two /0.d0,1.d0,2.d0/
data gam,gamsq,rgamsq/4096.d0,16777216.d0,5.9604645d-8/
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
    if(dflag)250,230,240
230 continue
         dparam(3)=dh21
         dparam(4)=dh12
         go to 260
240 continue
         dparam(2)=dh11
         dparam(5)=dh22
         go to 260
250 continue
         dparam(2)=dh11
         dparam(3)=dh21
         dparam(4)=dh12
         dparam(5)=dh22
260 continue
    dparam(1)=dflag
    return
end subroutine drotmg

subroutine drotm (n,dx,incx,dy,incy,dparam)
implicit none
integer, intent(in) :: incx, incy, n
integer :: i, kx, ky, nsteps
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
double precision :: dflag, dh12, dh22
double precision, intent(inout) :: dx(*)
double precision :: two, z, dh11, dh21, dparam(5)
double precision, intent(inout) :: dy(*)
double precision :: w, zero
!
data zero,two/0.d0,2.d0/
!
dflag=dparam(1)
if(n .le. 0 .or.(dflag+two.eq.zero)) go to 140
    if(.not.(incx.eq.incy.and. incx .gt.0)) go to 70
!
         nsteps=n*incx
         if(dflag) 50,10,30
10 continue
         dh21=dparam(3)
         dh12=dparam(4)
              do i=1,nsteps,incx
              w=dx(i)
              z=dy(i)
              dx(i)=w+z*dh12
              dy(i)=w*dh21+z
              end do
         go to 140
30 continue
         dh11=dparam(2)
         dh22=dparam(5)
              do i=1,nsteps,incx
              w=dx(i)
              z=dy(i)
              dx(i)=w*dh11+z
              dy(i)=-w+dh22*z
              end do
         go to 140
50 continue
         dh11=dparam(2)
         dh21=dparam(3)
         dh12=dparam(4)
         dh22=dparam(5)
              do i=1,nsteps,incx
              w=dx(i)
              z=dy(i)
              dx(i)=w*dh11+z*dh12
              dy(i)=w*dh21+z*dh22
              end do
         go to 140
70 continue
    kx=1
    ky=1
    if(incx .lt. 0) kx=1+(1-n)*incx
    if(incy .lt. 0) ky=1+(1-n)*incy
!
    if(dflag)120,80,100
80 continue
    dh21=dparam(3)
    dh12=dparam(4)
         do i=1,n
         w=dx(kx)
         z=dy(ky)
         dx(kx)=w+z*dh12
         dy(ky)=w*dh21+z
         kx=kx+incx
         ky=ky+incy
         end do
    go to 140
100 continue
    dh11=dparam(2)
    dh22=dparam(5)
         do i=1,n
         w=dx(kx)
         z=dy(ky)
         dx(kx)=w*dh11+z
         dy(ky)=-w+dh22*z
         kx=kx+incx
         ky=ky+incy
         end do
    go to 140
120 continue
    dh11=dparam(2)
    dh21=dparam(3)
    dh12=dparam(4)
    dh22=dparam(5)
         do i=1,n
         w=dx(kx)
         z=dy(ky)
         dx(kx)=w*dh11+z*dh12
         dy(ky)=w*dh21+z*dh22
         kx=kx+incx
         ky=ky+incy
         end do
140 continue
    return
    end subroutine drotm

real function sdot(n,sx,incx,sy,incy)
implicit none
!
!     Forms the dot product of two vectors.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*), sy(*)
real :: stemp
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
stemp = 0.0e0
sdot = 0.0e0
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  stemp = stemp + sx(i)*sy(i)
end do
if( n .lt. 5 ) go to 60
40 mp1 = m + 1
do i = mp1,n,5
  stemp = stemp + sx(i)*sy(i) + sx(i + 1)*sy(i + 1) + &
&sx(i + 2)*sy(i + 2) + sx(i + 3)*sy(i + 3) + sx(i + 4)*sy(i + 4)
end do
60 sdot = stemp
return
end function sdot

double precision function ddot(n,dx,incx,dy,incy)
implicit none
!
!     Forms the dot product of two vectors.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*), dy(*)
double precision :: dtemp
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
ddot = 0.0d0
dtemp = 0.0d0
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  dtemp = dtemp + dx(i)*dy(i)
end do
if( n .lt. 5 ) go to 60
40 mp1 = m + 1
do i = mp1,n,5
  dtemp = dtemp + dx(i)*dy(i) + dx(i + 1)*dy(i + 1) + &
&dx(i + 2)*dy(i + 2) + dx(i + 3)*dy(i + 3) + dx(i + 4)*dy(i + 4)
end do
60 ddot = dtemp
return
end function ddot

complex function cdotc(n,cx,incx,cy,incy)
implicit none
!
!     Forms the dot product of two vectors, conjugating the first
!     vector.
!     Jack dongarra, LINPACK,  3/11/78.
!
complex, intent(in) :: cx(*), cy(*)
complex :: ctemp
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
ctemp = (0.0,0.0)
cdotc = (0.0,0.0)
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

complex function cdotu(n,cx,incx,cy,incy)
implicit none
!
!     Forms the dot product of two vectors.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*), cy(*)
complex :: ctemp
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
ctemp = (0.0,0.0)
cdotu = (0.0,0.0)
if(n.le.0)return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

subroutine  sscal(n,sa,sx,incx)
implicit none
!
!     Scales a vector BY a constant.
!     Uses unrolled loops for increment equal to 1.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sa
real, intent(inout) :: sx(*)
integer :: i
integer, intent(in) :: incx
integer :: m, mp1
integer, intent(in) :: n
integer :: nincx
!
if(n.le.0)return
if(incx.eq.1)go to 20
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
if( m .eq. 0 ) go to 40
do i = 1,m
  sx(i) = sa*sx(i)
end do
if( n .lt. 5 ) return
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

subroutine  dscal(n,da,dx,incx)
implicit none
!
!     Scales a vector BY a constant.
!     Uses unrolled loops for increment equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: da
double precision, intent(inout) :: dx(*)
integer :: i
integer, intent(in) :: incx
integer :: m, mp1
integer, intent(in) :: n
integer :: nincx
!
if(n.le.0)return
if(incx.eq.1)go to 20
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
if( m .eq. 0 ) go to 40
do i = 1,m
  dx(i) = da*dx(i)
end do
if( n .lt. 5 ) return
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

subroutine  cscal(n,ca,cx,incx)
implicit none
!
!     Scales a vector BY a constant.
!     Jack dongarra, LINPACK,  3/11/78.
!
complex, intent(in) :: ca
complex, intent(inout) :: cx(*)
integer :: i
integer, intent(in) :: incx, n
integer :: nincx
!
if(n.le.0)return
if(incx.eq.1)go to 20
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

subroutine  csscal(n,sa,cx,incx)
implicit none
!
!     Scales a complex vector BY a real constant.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(inout) :: cx(*)
real, intent(in) :: sa
integer :: i
integer, intent(in) :: incx, n
integer :: nincx
!
if(n.le.0)return
if(incx.eq.1)go to 20
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

subroutine saxpy(n,sa,sx,incx,sy,incy)
implicit none
!
!     Constant times a vector plus a vector.
!     Uses unrolled loop for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
real, intent(inout) :: sy(*)
real, intent(in) :: sa
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
if(n.le.0)return
if (sa .eq. 0.0) return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  sy(i) = sy(i) + sa*sx(i)
end do
if( n .lt. 4 ) return
40 mp1 = m + 1
do i = mp1,n,4
  sy(i) = sy(i) + sa*sx(i)
  sy(i + 1) = sy(i + 1) + sa*sx(i + 1)
  sy(i + 2) = sy(i + 2) + sa*sx(i + 2)
  sy(i + 3) = sy(i + 3) + sa*sx(i + 3)
end do
return
end subroutine saxpy

subroutine daxpy(n,da,dx,incx,dy,incy)
implicit none
!
!     Constant times a vector plus a vector.
!     Uses unrolled loops for increments equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
double precision, intent(inout) :: dy(*)
double precision, intent(in) :: da
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy, m, mp1
integer, intent(in) :: n
!
if(n.le.0)return
if (da .eq. 0.0d0) return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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
if( m .eq. 0 ) go to 40
do i = 1,m
  dy(i) = dy(i) + da*dx(i)
end do
if( n .lt. 4 ) return
40 mp1 = m + 1
do i = mp1,n,4
  dy(i) = dy(i) + da*dx(i)
  dy(i + 1) = dy(i + 1) + da*dx(i + 1)
  dy(i + 2) = dy(i + 2) + da*dx(i + 2)
  dy(i + 3) = dy(i + 3) + da*dx(i + 3)
end do
return
end subroutine daxpy

subroutine caxpy(n,ca,cx,incx,cy,incy)
implicit none
!
!     Constant times a vector plus a vector.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*)
complex, intent(inout) :: cy(*)
complex, intent(in) :: ca
integer :: i
integer, intent(in) :: incx, incy
integer :: ix, iy
integer, intent(in) :: n
!
if(n.le.0)return
if (abs(real(ca)) + abs(aimag(ca)) .eq. 0.0 ) return
if(incx.eq.1.and.incy.eq.1)go to 20
!
!        Code for unequal increments or equal increments
!          not equal to 1
!
ix = 1
iy = 1
if(incx.lt.0)ix = (-n+1)*incx + 1
if(incy.lt.0)iy = (-n+1)*incy + 1
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

real function sasum(n,sx,incx)
implicit none
!
!     Takes the sum of the absolute values.
!     Uses unrolled loops for increment equal to one.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
real :: stemp
integer :: i
integer, intent(in) :: incx
integer :: m, mp1
integer, intent(in) :: n
integer :: nincx
!
sasum = 0.0e0
stemp = 0.0e0
if(n.le.0)return
if(incx.eq.1)go to 20
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
if( m .eq. 0 ) go to 40
do i = 1,m
  stemp = stemp + abs(sx(i))
end do
if( n .lt. 6 ) go to 60
40 mp1 = m + 1
do i = mp1,n,6
  stemp = stemp + abs(sx(i)) + abs(sx(i + 1)) + abs(sx(i + 2)) &
&+ abs(sx(i + 3)) + abs(sx(i + 4)) + abs(sx(i + 5))
end do
60 sasum = stemp
return
end function sasum

double precision function dasum(n,dx,incx)
implicit none
!
!     Takes the sum of the absolute values.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
double precision :: dtemp
integer :: i
integer, intent(in) :: incx
integer :: m, mp1
integer, intent(in) :: n
integer :: nincx
!
dasum = 0.0d0
dtemp = 0.0d0
if(n.le.0)return
if(incx.eq.1)go to 20
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
if( m .eq. 0 ) go to 40
do i = 1,m
  dtemp = dtemp + dabs(dx(i))
end do
if( n .lt. 6 ) go to 60
40 mp1 = m + 1
do i = mp1,n,6
  dtemp = dtemp + dabs(dx(i)) + dabs(dx(i + 1)) + dabs(dx(i + 2)) &
&+ dabs(dx(i + 3)) + dabs(dx(i + 4)) + dabs(dx(i + 5))
end do
60 dasum = dtemp
return
end function dasum

real function scasum(n,cx,incx)
implicit none
!
!     Takes the sum of the absolute values of a complex vector and
!     returns a single precision result.
!     Jack dongarra, LINPACK, 3/11/78.
!
complex, intent(in) :: cx(*)
real :: stemp
integer :: i
integer, intent(in) :: incx, n
integer :: nincx
!
scasum = 0.0e0
stemp = 0.0e0
if(n.le.0)return
if(incx.eq.1)go to 20
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

real function snrm2 ( n, sx, incx)
implicit none
integer, intent(in) :: incx, n
integer :: i, j, nn
integer :: next
real, intent(in) :: sx(*)
real :: cutlo, cuthi, hitest, sum, xmax, zero, one
data   zero, one /0.0e0, 1.0e0/
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
data cutlo, cuthi / 4.441e-16,  1.304e19 /
!
if(n .gt. 0) go to 10
   snrm2  = zero
   go to 300
!
10 assign 30 to next
sum = zero
nn = n * incx
!                                                 Begin main loop
i = 1
20 go to next,(30, 50, 70, 110)
30 if( abs(sx(i)) .gt. cutlo) go to 85
assign 50 to next
xmax = zero
!
!                        Phase 1.  Sum is zero
!
50 if( sx(i) .eq. zero) go to 200
if( abs(sx(i)) .gt. cutlo) go to 85
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
70 if( abs(sx(i)) .gt. cutlo ) go to 75
!
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
!
110 if( abs(sx(i)) .le. xmax ) go to 115
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
if(abs(sx(j)) .ge. hitest) go to 100
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

double precision function dnrm2 ( n, dx, incx)
implicit none
integer, intent(in) :: incx, n
integer :: i, j, nn
integer :: next
double precision, intent(in) :: dx(*)
double precision :: cutlo, cuthi, hitest, sum, xmax, zero, one
data   zero, one /0.0d0, 1.0d0/
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
data cutlo, cuthi / 8.232d-11,  1.304d19 /
!
if(n .gt. 0) go to 10
   dnrm2  = zero
   go to 300
!
10 assign 30 to next
sum = zero
nn = n * incx
!                                                 Begin main loop
i = 1
20 go to next,(30, 50, 70, 110)
30 if( dabs(dx(i)) .gt. cutlo) go to 85
assign 50 to next
xmax = zero
!
!                        Phase 1.  Sum is zero
!
50 if( dx(i) .eq. zero) go to 200
if( dabs(dx(i)) .gt. cutlo) go to 85
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
70 if( dabs(dx(i)) .gt. cutlo ) go to 75
!
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
!
110 if( dabs(dx(i)) .le. xmax ) go to 115
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
if(dabs(dx(j)) .ge. hitest) go to 100
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

real function scnrm2( n, cx, incx)
implicit none
integer, intent(in) :: incx, n
integer :: i, nn
logical :: imag, scale
integer :: next
real :: cutlo, cuthi, hitest, sum, xmax, absx, zero, one
complex, intent(in) :: cx(*)
data         zero, one /0.0e0, 1.0e0/
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
data cutlo, cuthi / 4.441e-16,  1.304e19 /
!
if(n .gt. 0) go to 10
   scnrm2  = zero
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
30 if( absx .gt. cutlo) go to 85
assign 50 to next
scale = .false.
!
!                        Phase 1.  Sum is zero
!
50 if( absx .eq. zero) go to 200
if( absx .gt. cutlo) go to 85
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
70 if( absx .gt. cutlo ) go to 75
!
!                     Common code for phases 2 and 4.
!                     In phase 4 sum is large.  Scale to avoid overflow.
!
110 if( absx .le. xmax ) go to 115
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
90 if(absx .ge. hitest) go to 100
   sum = sum + absx**2
200 continue
!                  Control selection of real and imaginary parts.
!
if(imag) go to 210
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
if(scale) scnrm2 = scnrm2 * xmax
300 continue
return
end function scnrm2

integer function isamax(n,sx,incx)
implicit none
!
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
!
real, intent(in) :: sx(*)
real :: smax
integer :: i
integer, intent(in) :: incx
integer :: ix
integer, intent(in) :: n
!
isamax = 0
if( n .lt. 1 ) return
isamax = 1
if(n.eq.1)return
if(incx.eq.1)go to 20
!
!        Code for increment not equal to 1
!
ix = 1
smax = abs(sx(1))
ix = ix + incx
do i = 2,n
   if(abs(sx(ix)).le.smax) go to 5
   isamax = i
   smax = abs(sx(ix))
5 ix = ix + incx
end do
return
!
!        Code for increment equal to 1
!
20 smax = abs(sx(1))
do 30 i = 2,n
   if(abs(sx(i)).le.smax) go to 30
   isamax = i
   smax = abs(sx(i))
30 continue
return
end function isamax

integer function idamax(n,dx,incx)
implicit none
!
!     Finds the index of element having max. Absolute value.
!     Jack dongarra, LINPACK, 3/11/78.
!
double precision, intent(in) :: dx(*)
double precision :: dmax
integer :: i
integer, intent(in) :: incx
integer :: ix
integer, intent(in) :: n
!
idamax = 0
if( n .lt. 1 ) return
idamax = 1
if(n.eq.1)return
if(incx.eq.1)go to 20
!
!        Code for increment not equal to 1
!
ix = 1
dmax = dabs(dx(1))
ix = ix + incx
do i = 2,n
   if(dabs(dx(ix)).le.dmax) go to 5
   idamax = i
   dmax = dabs(dx(ix))
5 ix = ix + incx
end do
return
!
!        Code for increment equal to 1
!
20 dmax = dabs(dx(1))
do 30 i = 2,n
   if(dabs(dx(i)).le.dmax) go to 30
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
real :: smax
integer :: i
integer, intent(in) :: incx
integer :: ix
integer, intent(in) :: n
complex :: zdum
real :: cabs1
cabs1(zdum) = abs(real(zdum)) + abs(aimag(zdum))
!
icamax = 0
if( n .lt. 1 ) return
icamax = 1
if(n.eq.1)return
if(incx.eq.1)go to 20
!
!        Code for increment not equal to 1
!
ix = 1
smax = cabs1(cx(1))
ix = ix + incx
do i = 2,n
   if(cabs1(cx(ix)).le.smax) go to 5
   icamax = i
   smax = cabs1(cx(ix))
5 ix = ix + incx
end do
return
!
!        Code for increment equal to 1
!
20 smax = cabs1(cx(1))
do 30 i = 2,n
   if(cabs1(cx(i)).le.smax) go to 30
   icamax = i
   smax = cabs1(cx(i))
30 continue
return
end function icamax

subroutine mcvfs(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
integer :: i, j, l
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
!
l = 0
do j = 1,n
   do 10 i = 1,j
   l = l + 1
10 b(l) = a(i,j)
end do
return
end subroutine mcvfs

subroutine dmcvfs(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
integer :: i, j, l
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(*)
!
l = 0
do j = 1,n
   do 10 i = 1,j
   l = l + 1
10 b(l) = a(i,j)
end do
return
end subroutine dmcvfs

subroutine mcvsf(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
integer :: i, ii, im1, j, jj, l
real, intent(inout) :: a(ka,n)
real, intent(in) :: b(*)
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
10 l = l - 1
11 j = j - 1
!
do i = 2,n
im1 = i - 1
   do 20 j = 1,im1
20 a(i,j) = a(j,i)
end do
return
end subroutine mcvsf

subroutine dmcvsf(a,ka,n,b)
implicit none
integer, intent(in) :: ka, n
integer :: i, ii, im1, j, jj, l
double precision, intent(inout) :: a(ka,n)
double precision, intent(in) :: b(*)
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
10 l = l - 1
11 j = j - 1
!
do i = 2,n
im1 = i - 1
   do 20 j = 1,im1
20 a(i,j) = a(j,i)
end do
return
end subroutine dmcvsf

subroutine mcvrd(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
real, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = a(i,j)
end do
return
end subroutine mcvrd

subroutine mcvdr(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
double precision, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = a(i,j)
end do
return
end subroutine mcvdr

subroutine mcvrc(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
real, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = cmplx(a(i,j),0.0)
end do
return
end subroutine mcvrc

subroutine cmreal(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
complex, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = real(a(i,j))
end do
return
end subroutine cmreal

subroutine cmimag(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
complex, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = aimag(a(i,j))
end do
return
end subroutine cmimag

subroutine mcopy(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = a(i,j)
end do
return
end subroutine mcopy

subroutine smcopy(n,a,b)
implicit none
integer, intent(in) :: n
integer :: k, l
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
!
l = (n*(n + 1))/2
do 10 k = 1,l
10 b(k) = a(k)
return
end subroutine smcopy

subroutine dmcopy(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = a(i,j)
end do
return
end subroutine dmcopy

subroutine cmcopy(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = a(i,j)
end do
return
end subroutine cmcopy

subroutine cmconj(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,n)
!
do j = 1,n
   do 10 i = 1,m
10 b(i,j) = conjg(a(i,j))
end do
return
end subroutine cmconj

subroutine tpose(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,m)
!
do j = 1,n
   do 10 i = 1,m
10 b(j,i) = a(i,j)
end do
return
end subroutine tpose

subroutine dtpose(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,m)
!
do j = 1,n
   do 10 i = 1,m
10 b(j,i) = a(i,j)
end do
return
end subroutine dtpose

subroutine ctpose(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,m)
!
do j = 1,n
   do 10 i = 1,m
10 b(j,i) = a(i,j)
end do
return
end subroutine ctpose

subroutine tip (a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, &
&istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
&npower
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
real, intent(inout) :: a(*)
real :: atemp, btemp
integer, intent(inout) :: moved(nwork)
integer :: ifact(8), ipower(8), nexp(8), iexp(8)
if (n1.lt.2 .or. n2.lt.2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1.ne.n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max=n,m,n
  i2 = i1min + n - 1
  do i1=i1min,i1max
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
do ip=1,npower
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
  ncount = (ncount/ifact(ip))*(ifact(ip)-1)
60 continue
if (nwork.le.0) go to 75
do i=1,nwork
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
120 atemp = a(istart+1)
btemp = a(mmist+1)
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
a(ia1+1) = a(ia2+1)
a(mmia1+1) = a(mmia2+1)
ia1 = ia2
go to 130
140 a(ia1+1) = atemp
a(mmia1+1) = btemp
go to 160
150 a(ia1+1) = btemp
a(mmia1+1) = atemp
160 istart = istart + idiv
if (ncount.gt.0) go to 80
do ip=1,npower
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

subroutine dtip (a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, &
&istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
&npower
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
double precision, intent(inout) :: a(*)
double precision :: atemp, btemp
integer, intent(inout) :: moved(nwork)
integer :: ifact(8), ipower(8), nexp(8), iexp(8)
if (n1.lt.2 .or. n2.lt.2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1.ne.n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max=n,m,n
  i2 = i1min + n - 1
  do i1=i1min,i1max
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
do ip=1,npower
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
  ncount = (ncount/ifact(ip))*(ifact(ip)-1)
60 continue
if (nwork.le.0) go to 75
do i=1,nwork
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
120 atemp = a(istart+1)
btemp = a(mmist+1)
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
a(ia1+1) = a(ia2+1)
a(mmia1+1) = a(mmia2+1)
ia1 = ia2
go to 130
140 a(ia1+1) = atemp
a(mmia1+1) = btemp
go to 160
150 a(ia1+1) = btemp
a(mmia1+1) = atemp
160 istart = istart + idiv
if (ncount.gt.0) go to 80
do ip=1,npower
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

subroutine ctip (a, n1, n2, moved, nwork, ndim)
implicit none
integer, intent(in) :: n1, n2
integer, intent(inout) :: ndim
integer, intent(in) :: nwork
integer :: i, i1, i1max, i1min, i2, ia1, ia2, idiv, ip, isoid, &
&istart, itest, m, mhalf, mmia1, mmia2, mmist, n, n12, ncount, &
&npower
! ----------------------------------------------------------
! Transposition of a rectangular matrix in situ.
! By norman brenner, mit, 1/72.  CF. Alg. 380, CACM, 5/70.
! Transposition of the n1 by n2 matrix a amounts to
! replacing the element at vector position i (0-ORIGIN)
! with the element at position n1*i (mod n1*n2-1).
! Each subcycle of this permutation is completed in order.
! ----------------------------------------------------------
complex, intent(inout) :: a(*)
complex :: atemp, btemp
integer, intent(inout) :: moved(nwork)
integer :: ifact(8), ipower(8), nexp(8), iexp(8)
if (n1.lt.2 .or. n2.lt.2) go to 200
n12 = n1*n2
n = n1
m = n12 - 1
if (n1.ne.n2) go to 30
! Square matrices are done separately for speed
i1min = 2
do i1max=n,m,n
  i2 = i1min + n - 1
  do i1=i1min,i1max
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
do ip=1,npower
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
  ncount = (ncount/ifact(ip))*(ifact(ip)-1)
60 continue
if (nwork.le.0) go to 75
do i=1,nwork
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
120 atemp = a(istart+1)
btemp = a(mmist+1)
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
a(ia1+1) = a(ia2+1)
a(mmia1+1) = a(mmia2+1)
ia1 = ia2
go to 130
140 a(ia1+1) = atemp
a(mmia1+1) = btemp
go to 160
150 a(ia1+1) = btemp
a(mmia1+1) = atemp
160 istart = istart + idiv
if (ncount.gt.0) go to 80
do ip=1,npower
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

subroutine infctr(n, ifact, ipower, nexp, npower)
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
if (npart-idiv*iquot) 60, 20, 60
20 if (idiv-ifcur) 40, 40, 30
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
60 if (iquot-idiv) 100, 100, 70
70 if (idiv-2) 80, 80, 90
80 idiv = 3
go to 10
90 idiv = idiv + 2
go to 10
100 if (npart-1) 140, 140, 110
110 if (npart-ifcur) 130, 130, 120
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

subroutine cmadj(m,n,a,ka,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,m)
!
do j = 1,n
   do 10 i = 1,m
10 b(j,i) = conjg(a(i,j))
end do
return
end subroutine cmadj

subroutine ctrans (nm, n, a)
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
integer :: i, j
integer, intent(in) :: n, nm
complex, intent(inout) :: a(nm,n)
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

subroutine madd (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
integer :: i, j
!-----------------------------------------------------------------------
!                      Addition of real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
return
end subroutine madd

subroutine dmadd (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
integer :: i, j
!-----------------------------------------------------------------------
!                Addition of double precision matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
return
end subroutine dmadd

subroutine cmadd (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
integer :: i, j
!-----------------------------------------------------------------------
!                   Addition of complex matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) + b(i,j)
   end do
end do
return
end subroutine cmadd

subroutine smadd(n,a,b,c)
implicit none
integer, intent(in) :: n
integer :: k, m
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
m=(n*(n+1))/2
do 10 k = 1,m
10 c(k)=a(k)+b(k)
return
end subroutine smadd

subroutine msubt (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
integer :: i, j
!-----------------------------------------------------------------------
!                     Subtraction of real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,n), b(kb,n)
real, intent(inout) :: c(kc,n)
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
return
end subroutine msubt

subroutine dmsubt (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
integer :: i, j
!-----------------------------------------------------------------------
!              Subtraction of double precision matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,n), b(kb,n)
double precision, intent(inout) :: c(kc,n)
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
return
end subroutine dmsubt

subroutine cmsubt (m, n, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, m, n
integer :: i, j
!-----------------------------------------------------------------------
!                  Subtraction of complex matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,n), b(kb,n)
complex, intent(inout) :: c(kc,n)
!
do j = 1,n
   do i = 1,m
      c(i,j) = a(i,j) - b(i,j)
   end do
end do
return
end subroutine cmsubt

subroutine smsubt(n,a,b,c)
implicit none
integer, intent(in) :: n
integer :: k, m
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*)
m=(n*(n+1))/2
do 10 k = 1,m
10 c(k)=a(k)-b(k)
return
end subroutine smsubt

subroutine mtms (m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, j, k
!-----------------------------------------------------------------------
!                     Product of real matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
double precision :: w
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

subroutine dmtms (m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, j, k
!-----------------------------------------------------------------------
!                Product of double precision matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,l)
double precision :: w
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

subroutine cmtms (m, n, l, a, ka, b, kb, c, kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, j, k
!-----------------------------------------------------------------------
!                   Product of complex matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,l)
complex :: w
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
integer :: i, j, k
real :: save
!-----------------------------------------------------------------------
!                     Product of real matrices
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
double precision :: w
logical :: rloc
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
10 w = w + dble(a(i,k))*dble(b(k,j))
11 c(i,j) = w
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
21 w = w + dble(a(i,k))*dble(b(k,j))
22 row(j) = w
   do 23 j = 1,l
23 a(i,j) = row(j)
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
31 w = w + dble(a(i,k))*dble(b(k,j))
32 row(i) = w
   do 33 i = 1,m
33 b(i,j) = row(i)
end do
return
end subroutine mprod

logical function rloc (x, y)
implicit none
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
real, intent(in) :: x(*)
real, intent(inout) :: y(*)
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

subroutine ychg (x, y, yold)
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
integer :: i, j, k
!-----------------------------------------------------------------------
!                Product of double precision matrices
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), &
&row(*)
double precision :: w
logical :: dloc
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
10 w = w + a(i,k)*b(k,j)
11 c(i,j) = w
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
21 w = w + a(i,k)*b(k,j)
22 row(j) = w
   do 23 j = 1,l
23 a(i,j) = row(j)
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
31 w = w + a(i,k)*b(k,j)
32 row(i) = w
   do 33 i = 1,m
33 b(i,j) = row(i)
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

subroutine dychg (x, y, yold)
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
integer :: i, j, k
!-----------------------------------------------------------------------
!                   Product of complex matrices
!-----------------------------------------------------------------------
complex, intent(inout) :: a(ka,n), b(kb,l), c(kc,l), row(*)
complex :: w
logical :: cloc
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
10 w = w + a(i,k)*b(k,j)
11 c(i,j) = w
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
21 w = w + a(i,k)*b(k,j)
22 row(j) = w
   do 23 j = 1,l
23 a(i,j) = row(j)
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
31 w = w + a(i,k)*b(k,j)
32 row(i) = w
   do 33 i = 1,m
33 b(i,j) = row(i)
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

subroutine cychg (x, y, yold)
implicit none
complex, intent(in) :: x(*)
complex, intent(inout) :: y(*)
complex, intent(in) :: yold
complex :: zero, one
data zero/(0.0,0.0)/, one/(1.0,0.0)/
!
y(1) = zero
if (yold .eq. zero) y(1) = one
return
end subroutine cychg

subroutine svprd(a,n,x,y)
implicit none
integer, intent(in) :: n
integer :: i, k, km1, l
real :: xk, yk
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(n)
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
10 yk = yk + a(l)*x(i)
!
l = l + 1
20 y(k) = yk + a(l)*xk
return
end subroutine svprd

subroutine dsvprd(a,n,x,y)
implicit none
integer, intent(in) :: n
integer :: i, k, km1, l
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(n)
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
10 yk = yk + a(l)*x(i)
!
l = l + 1
20 y(k) = yk + a(l)*xk
return
end subroutine dsvprd

subroutine tmprod(m,n,l,a,ka,b,kb,c,kc)
implicit none
integer, intent(in) :: ka, kb, kc, l, m, n
integer :: i, j, k
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,l)
double precision :: s
do j=1,l
do 11 i = 1,n
s = 0.d0
do 10 k = 1,m
10 s = s + dble(a(k,i))*dble(b(k,j))
11 c(i,j) = s
end do
return
end subroutine tmprod

subroutine smprod(m,n,a,ka,b)
implicit none
integer, intent(in) :: ka, m, n
integer :: i, ii, j, k
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
double precision :: s
ii=1
do i=1,n
do 11 j = 1,i
s = 0.d0
do 10 k = 1,m
10 s = s + dble(a(k,i))*dble(a(k,j))
b(ii) = s
11 ii = ii + 1
end do
return
end subroutine smprod

subroutine kprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
integer :: i, ii, j, jj
!     ******************************************************************
!     Kronecker product of real matrices A and b
!     ******************************************************************
real, intent(in) :: a(ka,n), b(kb,l)
real, intent(inout) :: c(kc,*)
integer :: r, s
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
10 c(i,j) = a(r,s)*b(ii,jj)
      end do
!
   end do
end do
return
end subroutine kprod

subroutine dkprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
integer :: i, ii, j, jj
!     ******************************************************************
!     Kronecker product of double precision matrices A and b
!     ******************************************************************
double precision, intent(in) :: a(ka,n), b(kb,l)
double precision, intent(inout) :: c(kc,*)
integer :: r, s
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
10 c(i,j) = a(r,s)*b(ii,jj)
      end do
!
   end do
end do
return
end subroutine dkprod

subroutine ckprod(a,ka,m,n,b,kb,k,l,c,kc)
implicit none
integer, intent(in) :: k, ka, kb, kc, l, m, n
integer :: i, ii, j, jj
!     ******************************************************************
!     Kronecker product of complex matrices A and b
!     ******************************************************************
complex, intent(in) :: a(ka,n), b(kb,l)
complex, intent(inout) :: c(kc,*)
integer :: r, s
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
10 c(i,j) = a(r,s)*b(ii,jj)
      end do
!
   end do
end do
return
end subroutine ckprod

subroutine rnk (a, mda, m, n, re, ae, krank, ksure, work, iwork)
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
real, intent(in) :: ae, re
integer :: i, imax, m0, m1, m2, m3, m4, m5
real :: eps, rerr
real :: spmpar
!-----------------------------------------------------------------------
!
!          Upper and lower bounds of the rank of a real matrix
!
!-----------------------------------------------------------------------
!     real work(5*m0)  where m0 = 5*min0(m,n)
!     integer iwork(m + n)
!--------------------
real, intent(inout) :: a(mda,n), work(*)
integer, intent(inout) :: iwork(*)
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
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
   return
!
40 call u11us (a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
end subroutine rnk

subroutine drnk (a, mda, m, n, re, ae, krank, ksure, work, iwork)
implicit none
integer, intent(inout) :: krank, ksure
integer, intent(in) :: m, mda, n
integer :: i, imax, m0, m1, m2, m3, m4, m5
!-----------------------------------------------------------------------
!
!              Upper and lower bounds of the rank of A
!                      double precision matrix
!
!-----------------------------------------------------------------------
!     double precision work(5*m0)  where m0 = 5*min0(m,n)
!     integer iwork(m + n)
!--------------------
double precision, intent(inout) :: a(mda,n)
double precision, intent(in) :: re, ae
double precision, intent(inout) :: work(*)
integer, intent(inout) :: iwork(*)
double precision :: eps, rerr
double precision :: dpmpar
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
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
   return
!
40 call du11us (a,mda,m,n,work(m4),work(m5),1,0,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
return
end subroutine drnk

subroutine crout(mo,n,m,a,ka,b,kb,d,index,temp)
implicit none
integer, intent(inout) :: index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), d, temp(*)
integer :: i, im1, j, jp1, k, kj, km1, kp1, l, lj, maxb, nj, nm1, &
&nmj, nmk
real :: p, t
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
integer :: onej
double precision :: dsum
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
10 continue
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
20 a(l,j) = t
!
   if (m .le. 0) go to 40
   kj = k
   lj = l
   do 30 j = 1,m
      t = b(kj)
      b(kj) = b(lj)
      b(lj) = t
      kj = kj + kb
30 lj = lj + kb
!
!                  Compute the k-TH row of U
!
40 if (k .gt. 1) go to 50
      do 41 j = kp1,n
41 a(k,j) = a(k,j)/p
      go to 60
!
50 do j = kp1,n
      dsum = a(k,j)
      do 51 l = 1,km1
51 dsum = dsum - dble(a(k,l))*dble(a(l,j))
      a(k,j) = sngl(dsum)/p
   end do
!
!               Compute the (k+1)-ST column of l
!
60 do i = kp1,n
      dsum = a(i,kp1)
      do 61 l = 1,k
61 dsum = dsum - dble(a(i,l))*dble(a(l,kp1))
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
100 lj = lj + 1
101 b(kj) = sngl(dsum)/a(k,k)
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
110 lj = lj + 1
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
130 dsum = dsum + dble(a(i,l))*dble(a(l,j))
131 a(i,j) = -sngl(dsum)/a(i,i)
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
140 a(k,j) = 0.0
!
   do j = 1,n
      dsum = a(k,j)
      do 150 l = kp1,n
150 dsum = dsum - dble(temp(l))*dble(a(l,j))
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
160 a(i,k) = t
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

subroutine krout(mo,n,m,a,ka,b,kb,ierr,index,temp)
implicit none
integer, intent(inout) :: ierr, index(*)
integer, intent(in) :: ka, kb, m, mo, n
real, intent(inout) :: a(ka,n), b(*), temp(*)
integer :: i, im1, j, jp1, k, kj, km1, kp1, l, lj, maxb, nj, nm1, &
&nmj, nmk
real :: d, p, t
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
integer :: onej
double precision :: dsum
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
10 continue
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
20 a(l,j) = t
!
   if (m .le. 0) go to 40
   kj = k
   lj = l
   do 30 j = 1,m
      t = b(kj)
      b(kj) = b(lj)
      b(lj) = t
      kj = kj + kb
30 lj = lj + kb
!
!                  Compute the k-TH row of U
!
40 if (k .gt. 1) go to 50
      do 41 j = kp1,n
41 a(k,j) = a(k,j)/p
      go to 60
!
50 do j = kp1,n
      dsum = a(k,j)
      do 51 l = 1,km1
51 dsum = dsum - dble(a(k,l))*dble(a(l,j))
      a(k,j) = sngl(dsum)/p
   end do
!
!               Compute the (k+1)-ST column of l
!
60 do i = kp1,n
      dsum = a(i,kp1)
      do 61 l = 1,k
61 dsum = dsum - dble(a(i,l))*dble(a(l,kp1))
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
100 lj = lj + 1
101 b(kj) = sngl(dsum)/a(k,k)
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
110 lj = lj + 1
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
130 dsum = dsum + dble(a(i,l))*dble(a(l,j))
131 a(i,j) = -sngl(dsum)/a(i,i)
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
140 a(k,j) = 0.0
!
   do j = 1,n
      dsum = a(k,j)
      do 150 l = kp1,n
150 dsum = dsum - dble(temp(l))*dble(a(l,j))
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
160 a(i,k) = t
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

subroutine dec (n, ndim, a, ip, ier)
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
integer :: i, j, k, kp1, m, nm1
real, intent(inout) :: a(ndim,n)
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
10 if (abs(a(i,k)) .gt. abs(a(m,k))) m = i
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
30 a(i,k) = -a(i,k)*t
!  Apply multipliers to other columns of A. ----------------------------
  do 50 j = kp1,n
    t = a(m,j)
    a(m,j) = a(k,j)
    a(k,j) = t
    if (t .eq. 0.0) go to 50
    do 40 i = kp1,n
40 a(i,j) = a(i,j) + a(i,k)*t
50 continue
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
integer :: i, k, kb, km1, kp1, m, nm1
real :: a(ndim, n)
real, intent(inout) :: b(n)
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
10 b(i) = b(i) + a(i,k)*t
  end do
!  Back solve. ---------------------------------------------------------
do kb = 1,nm1
  km1 = n - kb
  k = km1 + 1
  b(k) = b(k)/a(k,k)
  t = -b(k)
  do 30 i = 1,km1
30 b(i) = b(i) + a(i,k)*t
  end do
50 b(1) = b(1)/a(1,1)
return
end subroutine sol

subroutine npivot (n, m, a, ka, b, kb, d, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
real, intent(inout) :: d
integer :: j, jl, k, kl, l, maxb
real :: pivot, t
!-----------------------------------------------------------------------
!     Matrix inversion/equation solving without pivot search
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), b(*)
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
70 continue
!
end do
return
end subroutine npivot

subroutine slv (n, m, a, ka, b, kb, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
integer :: i, ip1, j, jp1, k, l, nm1
real :: p, sum, t
real, intent(inout) :: a(ka,n), b(kb,m)
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
10 continue
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
50 a(i,k) = a(i,k) - t*a(j,k)
      do 60 k = 1,m
60 b(i,k) = b(i,k) - t*b(j,k)
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
110 sum = sum - a(i,k)*b(k,j)
120 b(i,j) = sum/a(i,i)
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

subroutine dpslv (n, m, a, ka, b, kb, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n
integer :: i, j, k, km1, kp1, l, nm1
double precision, intent(inout) :: a(ka,n), b(kb,m)
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
10 continue
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
50 a(i,j) = a(i,j) - t*a(k,j)
      do 60 j = 1,m
60 b(i,j) = b(i,j) - t*b(k,j)
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
100 b(i,j) = b(i,j) - t*a(i,k)
   k = km1
110 km1 = k - 1
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
integer :: j, job
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting real matrices
!     and solving real equations
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), b(*)
real, intent(inout) :: det(2), rcond
real :: t
real, intent(inout) :: wk(n)
integer, intent(inout) :: ipvt(n)
integer :: onej
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
integer :: j
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting real matrices
!     and solving real equations
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
real :: det(2)
integer :: onej
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
real :: spmpar
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
double precision :: dsum
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
21 dsum = dsum - dble(a(i,j))*dble(x(j))
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

subroutine sgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
real, intent(inout) :: a(lda,*), z(*)
real, intent(inout) :: rcond
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
real :: sdot, ek, t, wk, wkm
real :: anorm, s, sasum, sm, ynorm
integer :: info, j, k, kb, kp1, l
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
   if (abs(ek-z(k)) .le. abs(a(k,k))) go to 30
      s = abs(a(k,k))/abs(ek-z(k))
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
         sm = sm + abs(z(j)+wkm*a(k,j))
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
   if (k .lt. n) z(k) = z(k) + sdot(n-k,a(k+1,k),1,z(k+1),1)
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
   if (k .lt. n) call saxpy(n-k,t,a(k+1,k),1,z(k+1),1)
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
   call saxpy(k-1,t,a(1,k),1,z(1),1)
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

subroutine sgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
real, intent(inout) :: a(lda,*)
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
real :: t
integer :: isamax, j, k, kp1, l, nm1
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
   l = isamax(n-k+1,a(k,k),1) + k - 1
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
      call sscal(n-k,t,a(k+1,k),1)
!
!           Row elimination with column indexing
!
      do j = kp1, n
         t = a(l,j)
         if (l .eq. k) go to 20
            a(l,j) = a(k,j)
            a(k,j) = t
20 continue
         call saxpy(n-k,t,a(k+1,k),1,a(k+1,j),1)
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

subroutine sgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
real, intent(in) :: a(lda,*)
real, intent(inout) :: b(*)
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
real :: sdot, t
integer :: k, kb, l, nm1
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
      call saxpy(n-k,t,a(k+1,k),1,b(k+1),1)
   end do
30 continue
!
!        Now solve  U*X = Y
!
   do kb = 1, n
      k = n + 1 - kb
      b(k) = b(k)/a(k,k)
      t = -b(k)
      call saxpy(k-1,t,a(1,k),1,b(1),1)
   end do
go to 100
50 continue
!
!        job = NONZERO, SOLVE  TRANS(a) * X = b
!        first solve  trans(U)*Y = b
!
   do k = 1, n
      t = sdot(k-1,a(1,k),1,b(1),1)
      b(k) = (b(k) - t)/a(k,k)
   end do
!
!        Now solve trans(l)*X = Y
!
   if (nm1 .lt. 1) go to 90
   do kb = 1, nm1
      k = n - kb
      b(k) = b(k) + sdot(n-k,a(k+1,k),1,b(k+1),1)
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
real :: t
real :: ten
integer :: i, j, k, kb, kp1, l, nm1
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
      call sscal(k-1,t,a(1,k),1)
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
integer :: j, job
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     real matrices and solving double precision real equations
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,n), b(*)
double precision, intent(inout) :: det(2), rcond
double precision :: t
double precision, intent(inout) :: wk(n)
integer, intent(inout) :: ipvt(n)
integer :: onej
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
integer :: j
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     real matrices and solving double precision real equations
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
double precision :: det(2)
integer :: onej
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

subroutine dgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
double precision, intent(inout) :: a(lda,*), z(*)
double precision, intent(inout) :: rcond
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
double precision :: ddot, ek, t, wk, wkm
double precision :: anorm, s, dasum, sm, ynorm
integer :: info, j, k, kb, kp1, l
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
   if (dabs(ek-z(k)) .le. dabs(a(k,k))) go to 30
      s = dabs(a(k,k))/dabs(ek-z(k))
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
         sm = sm + dabs(z(j)+wkm*a(k,j))
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
   if (k .lt. n) z(k) = z(k) + ddot(n-k,a(k+1,k),1,z(k+1),1)
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
   if (k .lt. n) call daxpy(n-k,t,a(k+1,k),1,z(k+1),1)
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
   call daxpy(k-1,t,a(1,k),1,z(1),1)
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

subroutine dgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda, n
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
double precision, intent(inout) :: a(lda,*)
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
double precision :: t
integer :: idamax, j, k, kp1, l, nm1
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
   l = idamax(n-k+1,a(k,k),1) + k - 1
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
      call dscal(n-k,t,a(k+1,k),1)
!
!           Row elimination with column indexing
!
      do j = kp1, n
         t = a(l,j)
         if (l .eq. k) go to 20
            a(l,j) = a(k,j)
            a(k,j) = t
20 continue
         call daxpy(n-k,t,a(k+1,k),1,a(k+1,j),1)
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

subroutine dgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
double precision, intent(in) :: a(lda,*)
double precision, intent(inout) :: b(*)
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
double precision :: ddot, t
integer :: k, kb, l, nm1
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
      call daxpy(n-k,t,a(k+1,k),1,b(k+1),1)
   end do
30 continue
!
!        Now solve  U*X = Y
!
   do kb = 1, n
      k = n + 1 - kb
      b(k) = b(k)/a(k,k)
      t = -b(k)
      call daxpy(k-1,t,a(1,k),1,b(1),1)
   end do
go to 100
50 continue
!
!        job = NONZERO, SOLVE  TRANS(a) * X = b
!        first solve  trans(U)*Y = b
!
   do k = 1, n
      t = ddot(k-1,a(1,k),1,b(1),1)
      b(k) = (b(k) - t)/a(k,k)
   end do
!
!        Now solve trans(l)*X = Y
!
   if (nm1 .lt. 1) go to 90
   do kb = 1, nm1
      k = n - kb
      b(k) = b(k) + ddot(n-k,a(k+1,k),1,b(k+1),1)
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
double precision :: t
double precision :: ten
integer :: i, j, k, kb, kp1, l, nm1
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
      call dscal(k-1,t,a(1,k),1)
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
real, intent(inout) :: array(*), b(*), x(*)
integer, intent(inout) :: mtrstr(3,*), pivot(*)
call arcedc(n, array, mtrstr, nmblks, pivot, iflag)
if (iflag.ne.0) return
call arcesl(array, mtrstr, nmblks, pivot, b, x)
return
end subroutine arceco

subroutine arcedc(n, array, mtrstr, nmblks, pivot, iflag)
implicit none
integer, intent(inout) :: iflag, mtrstr(3,*)
integer, intent(in) :: n, nmblks
integer :: index1, index2, index3, indpiv, isum1, isum2, k, &
&nclblk, nclpiv, novrlp, nrwbk2, nrwblk, nrwpiv
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
real, intent(inout) :: array(*)
real :: pivmax, zero
integer, intent(inout) :: pivot(*)
data zero /0.0/
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
do k=2,nmblks
  if (mtrstr(3,k-1)+mtrstr(3,k).gt.mtrstr(2,k)) go to 30
end do
isum1 = 0
isum2 = 0
do k=1,nmblks
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
&nrwpiv, pivot(indpiv), pivmax, iflag)
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
do k=2,nmblks
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
&nrwbk2, nclpiv, pivot(indpiv), pivmax, iflag)
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
&pivot(indpiv), pivmax, iflag)
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

subroutine arcepr(block, nrwblk, nclblk, nrwpiv, pivot, pivmax, &
&iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: nclblk, nrwblk, nrwpiv
integer :: i1, j, j1, jplus1, l1, max
!
!***************************************************************
!
!  A R C E P R  performs  nrwpiv  row eliminations on the matrix
!               block
!
!***************************************************************
!
integer, intent(inout) :: pivot(nrwblk)
real, intent(inout) :: block(nrwblk,nclblk)
real :: rowmax
real, intent(inout) :: pivmax
real :: tempiv, rowpiv, swap
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C        PERFORM nrwpiv ROW ELIMINATIONS...
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do j=1,nrwpiv
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
  do i1=jplus1,nrwblk
    tempiv = abs(block(i1,j))
    if (tempiv.le.rowmax) go to 10
    rowmax = tempiv
    max = i1
10 continue
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
  if (pivmax+rowmax.eq.pivmax) go to 100
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
  do j1=j,nclblk
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
  do i1=jplus1,nrwblk
    block(i1,j) = block(i1,j)/rowpiv
  end do
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    PERFORM ROW ELIMINATIONS WITH COLUMN INDEXING
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
  do j1=jplus1,nclblk
    do l1=jplus1,nrwblk
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

subroutine arcepc(topblk, nrwtop, novrlp, botblk, nrwbot, nclpiv, &
&pivot, pivmax, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: nclpiv, novrlp, nrwbot, nrwtop
integer :: i, i1, i2, iplus1, j, j1, jplus1, l1, max
!
!***************************************************************
!
!     A R C E P C performs nclpiv column eliminations on the
!                 matrices topblk and BOTBLK
!***************************************************************
!
real, intent(inout) :: topblk(nrwtop,novrlp), &
&botblk(nrwbot,novrlp)
real :: colmax
real, intent(inout) :: pivmax
real :: colmlt
real :: tempiv, swap
integer, intent(inout) :: pivot(nrwtop)
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       PERFORM THE COLUMN ELIMINATIONS ON A LOOP.
!       C
!       ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do j=1,nclpiv
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
  do j1=jplus1,novrlp
    tempiv = abs(topblk(i,j1))
    if (tempiv.le.colmax) go to 10
    colmax = tempiv
    max = j1
10 continue
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
  if (pivmax+colmax.eq.pivmax) go to 120
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
  do i1=i,nrwtop
    swap = topblk(i1,j)
    topblk(i1,j) = topblk(i1,max)
    topblk(i1,max) = swap
  end do
  do i2=1,nrwbot
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
  do j1=jplus1,novrlp
    colmlt = topblk(i,j1)/topblk(i,j)
    topblk(i,j1) = colmlt
    if (i.eq.nrwtop) go to 80
    iplus1 = i + 1
    do l1=iplus1,nrwtop
      topblk(l1,j1) = topblk(l1,j1) - colmlt*topblk(l1,j)
    end do
80 continue
    do l1=1,nrwbot
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
integer :: indexa, indpiv, k, ll, nclblk, nclpiv, novrlp, nrwblk, &
&nrwpiv
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
real :: array(*)
real, intent(inout) :: b(*), x(*)
integer, intent(in) :: pivot(*)
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
&pivot(indpiv), b(indpiv))
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       FORWARD LOOP
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do k=2,nmblks
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
&novrlp, b(indpiv), x(indpiv))
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
&b(indpiv), x(indpiv))
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
&pivot(indpiv), b(indpiv))
end do
!     indexb = indpiv + nrwpiv - 1
!
!       Cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!       C
!       C       BACKWARD LOOP
!       C
!       cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
do ll=2,nmblks
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
&nclblk, nrwpiv, b(indpiv), x(indpiv))
!
!          Ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          C
!          C    CALL arcebs TO PERFORM BACKWARD SOLUTION
!          C
!          ccccccccccccccccccccccccccccccccccccccccccccccccccccc
!
  call arcebs(array(indexa), nrwblk, nclblk, nrwpiv, b(indpiv), &
&x(indpiv))
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
&novrlp, pivot(indpiv), x(indpiv))
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
&nrwpiv, b(indpiv), x(indpiv))
call arcebs(array(indexa), nrwblk, nclblk, nrwpiv, b(indpiv), &
&x(indpiv))
return
end subroutine arcesl

subroutine arcefs(block, nrwblk, nclpiv, novrlp, b, x)
implicit none
integer, intent(in) :: nclpiv, novrlp, nrwblk
integer :: i, iplusl, j, jplusl, l, long
!
!***************************************************************
!
!  A R C E F S performs the forward solution step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
real :: block(nrwblk,novrlp)
real, intent(inout) :: b(*), x(*)
real :: xj
do j=1,nclpiv
  i = nrwblk - nclpiv + j
  x(j) = b(j)/block(i,j)
  if (i.eq.nrwblk) return
  long = nrwblk - i
  xj = x(j)
  do l=1,long
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
integer :: j, l, nclpvl
!
!***************************************************************
!
!  A R C E F M  performs the forward modification step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
real :: block(nrwblk,nclpiv)
real, intent(inout) :: b(*)
real :: x(*), xj
do j=1,nclpiv
  xj = x(j)
  do l=1,nrwblk
    nclpvl = nclpiv + l
    b(nclpvl) = b(nclpvl) - block(l,j)*xj
  end do
end do
return
end subroutine arcefm

subroutine arcefe(block, nrwblk, nrwpiv, pivot, b)
implicit none
integer, intent(in) :: nrwblk, nrwpiv
integer :: i, iplus1, l
!
!***************************************************************
!
!  A R C E F E  performs the forward elimination step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
real :: block(nrwblk,nrwpiv)
real, intent(inout) :: b(*)
real :: bi, swap
integer, intent(in) :: pivot(nrwpiv)
integer :: pivoti
do i=1,nrwpiv
  pivoti = pivot(i)
  if (pivoti.eq.i) go to 10
  swap = b(i)
  b(i) = b(pivoti)
  b(pivoti) = swap
10 continue
  if (i.eq.nrwblk) return
  bi = b(i)
  iplus1 = i + 1
  do l=iplus1,nrwblk
    b(l) = b(l) - block(l,i)*bi
  end do
end do
return
end subroutine arcefe

subroutine arcebs(block, nrwblk, nclblk, nrwpiv, b, x)
implicit none
integer, intent(in) :: nclblk, nrwblk, nrwpiv
integer :: j, jmin1, l, nj
!
!***************************************************************
!
!  A R C E b S performs the backward solution step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
real :: block(nrwblk,nclblk)
real, intent(inout) :: b(*), x(*)
real :: xj
do nj=1,nrwpiv
  j = nrwpiv - nj + 1
  x(j) = b(j)/block(j,j)
  if (j.eq.1) return
  jmin1 = j - 1
  xj = x(j)
  do l=1,jmin1
    b(l) = b(l) - block(l,j)*xj
  end do
end do
return
end subroutine arcebs

subroutine arcebm(block, nrwblk, nclblk, nrwpiv, b, x)
implicit none
integer, intent(in) :: nclblk, nrwblk, nrwpiv
integer :: j, l, nrwpv1
!
!***************************************************************
!
!  A R C E b M  performs the backward modification step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
real :: block(nrwblk,nclblk)
real, intent(inout) :: b(*)
real :: x(*), xj
nrwpv1 = nrwpiv + 1
do j=nrwpv1,nclblk
  xj = x(j)
  do l=1,nrwpiv
    b(l) = b(l) - block(l,j)*xj
  end do
end do
return
end subroutine arcebm

subroutine arcebe(block, nrwblk, nclpiv, novrlp, pivot, x)
implicit none
integer, intent(in) :: nclpiv, novrlp, nrwblk
integer :: i, j, j1, jplus1, nj
!
!***************************************************************
!
!  A R C E B E performs the backward elimination step in the
!  solution phase of  A R C E C O.
!
!***************************************************************
!
real :: block(nrwblk,novrlp)
real, intent(inout) :: x(*)
real :: dotprd, swap
integer, intent(in) :: pivot(nrwblk)
integer :: pivotj
do 40 nj = 1,nclpiv
  j = nclpiv + 1 - nj
  i = nrwblk + 1 - nj
  dotprd = x(j)
  if (j.eq.novrlp) go to 20
  jplus1 = j + 1
  do 10 j1 = jplus1,novrlp
    dotprd = dotprd - x(j1)*block(i,j1)
10 continue
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
integer :: nm1, nm2, km1, i, j, k, l
real :: dp
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
20 dp = dp + c(i,l,2)*c(l,j,1)
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
50 dp = dp + c(i,l,k)*b(l,j,km1)
      a(i,j,k) = a(i,j,k) - dp
      end do
    end do
  call dec (m, m, a(1,1,k), ip(1,k), ier)
  if (ier .ne. 0) go to 200
  do 80 j = 1,m
80 call sol (m, m, a(1,1,k), b(1,j,k), ip(1,k))
  end do
! Process last block-row and return. -----------------------------------
do j = 1,m
  do i = 1,m
    dp = 0.
    do 110 l = 1,m
110 dp = dp + b(i,l,n)*b(l,j,nm2)
    c(i,j,n) = c(i,j,n) - dp
    end do
  end do
do j = 1,m
  do i = 1,m
    dp = 0.
    do 140 l = 1,m
140 dp = dp + c(i,l,n)*b(l,j,nm1)
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
integer :: kb, kp1
integer, intent(in) :: m
integer :: n, ip(m,n)
real :: a(m,m,n)
real, intent(in) :: b(m,m,n), c(m,m,n)
real, intent(inout) :: y(m,n)
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
integer :: nm1, nm2, km1, i, j, k
real :: dp
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
10 dp = dp + c(i,j,k)*y(j,km1)
    y(i,k) = y(i,k) - dp
    end do
  call sol (m, m, a(1,1,k), y(1,k), ip(1,k))
  end do
do i = 1,m
  dp = 0.
  do 40 j = 1,m
40 dp = dp + c(i,j,n)*y(j,nm1) + b(i,j,n)*y(j,nm2)
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
60 dp = dp + b(i,j,k)*y(j,kp1)
    y(i,k) = y(i,k) - dp
    end do
  end do
do i = 1,m
  dp = 0.
  do 90 j = 1,m
90 dp = dp + c(i,j,1)*y(j,3)
  y(i,1) = y(i,1) - dp
  end do
return
!-----------------------  End of subroutine solbt  ---------------------
end subroutine solbt

subroutine smslv(mo,n,m,a,b,kb,det,rcond,inert,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: kb, m, mo, n
integer :: j, job
!     ------------------
real, intent(inout) :: a(*), b(*)
real, intent(inout) :: det(2), rcond
real :: t
real, intent(inout) :: wk(n)
integer, intent(inout) :: inert(3), ipvt(n)
integer :: onej
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

subroutine sspco(ap,n,kpvt,rcond,z)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
real, intent(inout) :: ap(*), z(*)
real, intent(inout) :: rcond
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
real :: ak, akm1, bk, bkm1, sdot, denom, ek, t
real :: anorm, s, sasum, ynorm
integer :: i, ij, ik, ikm1, ikp1, info, j, jm1, j1
integer :: k, kk, km1k, km1km1, kp, kps, ks
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
   call saxpy(k-ks,z(k),ap(ik+1),1,z(1),1)
   if (ks .eq. 1) go to 80
      if (z(k-1) .ne. 0.0e0) ek = sign(ek,z(k-1))
      z(k-1) = z(k-1) + ek
      call saxpy(k-ks,z(k-1),ap(ikm1+1),1,z(1),1)
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
      bkm1 = z(k-1)/ap(km1k)
      denom = ak*akm1 - 1.0e0
      z(k) = (akm1*bk - bkm1)/denom
      z(k-1) = (ak*bkm1 - bk)/denom
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
      z(k) = z(k) + sdot(k-1,ap(ik+1),1,z(1),1)
      ikp1 = ik + k
      if (ks .eq. 2) &
&z(k+1) = z(k+1) + sdot(k-1,ap(ikp1+1),1,z(1),1)
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
      call saxpy(k-ks,z(k),ap(ik+1),1,z(1),1)
      if (ks .eq. 2) call saxpy(k-ks,z(k-1),ap(ikm1+1),1,z(1),1)
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
      bkm1 = z(k-1)/ap(km1k)
      denom = ak*akm1 - 1.0e0
      z(k) = (akm1*bk - bkm1)/denom
      z(k-1) = (ak*bkm1 - bk)/denom
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
      z(k) = z(k) + sdot(k-1,ap(ik+1),1,z(1),1)
      ikp1 = ik + k
      if (ks .eq. 2) &
&z(k+1) = z(k+1) + sdot(k-1,ap(ikp1+1),1,z(1),1)
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

subroutine sspfa(ap,n,kpvt,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
integer, intent(out) :: info
real, intent(inout) :: ap(*)
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
real :: ak, akm1, bk, bkm1, denom, mulk, mulkm1, t
real :: absakk, alpha, colmax, rowmax
integer :: isamax, ij, ijj, ik, ikm1, im, imax, imaxp1, imim, imj, &
&imk
integer :: j, jj, jk, jkm1, jmax, jmim, k, kk, km1, km1k, km1km1, &
&km2, kstep
logical :: swap
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
   imax = isamax(k-1,ap(ik+1),1)
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
         jmax = isamax(imax-1,ap(im+1),1)
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
         call sswap(imax,ap(im+1),1,ap(ik+1),1)
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
         call saxpy(j,t,ap(ik+1),1,ap(ij+1),1)
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
         call sswap(imax,ap(im+1),1,ap(ikm1+1),1)
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
            call saxpy(j,t,ap(ik+1),1,ap(ij+1),1)
            t = mulkm1
            call saxpy(j,t,ap(ikm1+1),1,ap(ij+1),1)
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
      kpvt(k-1) = kpvt(k)
190 continue
   ik = ik - (k - 1)
   if (kstep .eq. 2) ik = ik - (k - 2)
   k = k - kstep
go to 10
200 continue
return
end subroutine sspfa

subroutine sspsl(ap,n,kpvt,b)
implicit none
integer, intent(in) :: n, kpvt(*)
real, intent(in) :: ap(*)
real, intent(inout) :: b(*)
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
real :: ak, akm1, bk, bkm1, sdot, denom, temp
integer :: ik, ikm1, ikp1, k, kk, km1k, km1km1, kp
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
         call saxpy(k-1,b(k),ap(ik+1),1,b(1),1)
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
            temp = b(k-1)
            b(k-1) = b(kp)
            b(kp) = temp
50 continue
!
!              Apply the transformation.
!
         call saxpy(k-2,b(k),ap(ik+1),1,b(1),1)
         call saxpy(k-2,b(k-1),ap(ikm1+1),1,b(1),1)
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
      bkm1 = b(k-1)/ap(km1k)
      denom = ak*akm1 - 1.0e0
      b(k) = (akm1*bk - bkm1)/denom
      b(k-1) = (ak*bkm1 - bk)/denom
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
         b(k) = b(k) + sdot(k-1,ap(ik+1),1,b(1),1)
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
         b(k) = b(k) + sdot(k-1,ap(ik+1),1,b(1),1)
         ikp1 = ik + k
         b(k+1) = b(k+1) + sdot(k-1,ap(ikp1+1),1,b(1),1)
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
real :: akkp1, sdot, temp
real :: ten, d, t, ak, akp1
integer :: ij, ik, ikp1, iks, j, jb, jk, jkp1
integer :: k, kk, kkp1, km1, ks, ksj, kskp1, kstep
logical :: noinv, nodet, noert
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
            d = (d/t)*ap(kkp1+1) - t
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
            call scopy(km1,ap(ik+1),1,work,1)
            ij = 0
            do j = 1, km1
               jk = ik + j
               ap(jk) = sdot(j,ap(ij+1),1,work,1)
               call saxpy(j-1,work(j),ap(ij+1),1,ap(ik+1),1)
               ij = ij + j
            end do
            ap(kk) = ap(kk) + sdot(km1,work,1,ap(ik+1),1)
170 continue
         kstep = 1
      go to 220
180 continue
!
!              2 By 2
!
         t = abs(ap(kkp1))
         ak = ap(kk)/t
         akp1 = ap(kkp1+1)/t
         akkp1 = ap(kkp1)/t
         d = t*(ak*akp1 - 1.0e0)
         ap(kk) = akp1/d
         ap(kkp1+1) = ak/d
         ap(kkp1) = -akkp1/d
         if (km1 .lt. 1) go to 210
            call scopy(km1,ap(ikp1+1),1,work,1)
            ij = 0
            do j = 1, km1
               jkp1 = ikp1 + j
               ap(jkp1) = sdot(j,ap(ij+1),1,work,1)
               call saxpy(j-1,work(j),ap(ij+1),1,ap(ikp1+1),1)
               ij = ij + j
            end do
            ap(kkp1+1) = ap(kkp1+1) &
&+ sdot(km1,work,1,ap(ikp1+1),1)
            ap(kkp1) = ap(kkp1) &
&+ sdot(km1,ap(ik+1),1,ap(ikp1+1),1)
            call scopy(km1,ap(ik+1),1,work,1)
            ij = 0
            do j = 1, km1
               jk = ik + j
               ap(jk) = sdot(j,ap(ij+1),1,work,1)
               call saxpy(j-1,work(j),ap(ij+1),1,ap(ik+1),1)
               ij = ij + j
            end do
            ap(kk) = ap(kk) + sdot(km1,work,1,ap(ik+1),1)
210 continue
         kstep = 2
220 continue
!
!           Swap
!
      ks = iabs(kpvt(k))
      if (ks .eq. k) go to 250
         iks = (ks*(ks - 1))/2
         call sswap(ks,ap(iks+1),1,ap(ik+1),1)
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
integer :: j, job
!     ------------------
double precision, intent(inout) :: a(*), b(*)
double precision, intent(inout) :: det(2), rcond
double precision :: t
double precision, intent(inout) :: wk(n)
integer, intent(inout) :: inert(3), ipvt(n)
integer :: onej
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

subroutine dspco(ap,n,kpvt,rcond,z)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
double precision, intent(inout) :: ap(*), z(*)
double precision, intent(inout) :: rcond
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
double precision :: ak, akm1, bk, bkm1, ddot, denom, ek, t
double precision :: anorm, s, dasum, ynorm
integer :: i, ij, ik, ikm1, ikp1, info, j, jm1, j1
integer :: k, kk, km1k, km1km1, kp, kps, ks
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
   call daxpy(k-ks,z(k),ap(ik+1),1,z(1),1)
   if (ks .eq. 1) go to 80
      if (z(k-1) .ne. 0.0d0) ek = dsign(ek,z(k-1))
      z(k-1) = z(k-1) + ek
      call daxpy(k-ks,z(k-1),ap(ikm1+1),1,z(1),1)
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
      bkm1 = z(k-1)/ap(km1k)
      denom = ak*akm1 - 1.0d0
      z(k) = (akm1*bk - bkm1)/denom
      z(k-1) = (ak*bkm1 - bk)/denom
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
      z(k) = z(k) + ddot(k-1,ap(ik+1),1,z(1),1)
      ikp1 = ik + k
      if (ks .eq. 2) &
&z(k+1) = z(k+1) + ddot(k-1,ap(ikp1+1),1,z(1),1)
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
      call daxpy(k-ks,z(k),ap(ik+1),1,z(1),1)
      if (ks .eq. 2) call daxpy(k-ks,z(k-1),ap(ikm1+1),1,z(1),1)
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
      bkm1 = z(k-1)/ap(km1k)
      denom = ak*akm1 - 1.0d0
      z(k) = (akm1*bk - bkm1)/denom
      z(k-1) = (ak*bkm1 - bk)/denom
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
      z(k) = z(k) + ddot(k-1,ap(ik+1),1,z(1),1)
      ikp1 = ik + k
      if (ks .eq. 2) &
&z(k+1) = z(k+1) + ddot(k-1,ap(ikp1+1),1,z(1),1)
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

subroutine dspfa(ap,n,kpvt,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: kpvt(*)
integer, intent(out) :: info
double precision, intent(inout) :: ap(*)
!
!     dspfa factors a double precision symmetric matrix stored in
!     packed form by elimination with symmetric pivoting.
!
!     To solve  A*X = B , follow dspfa by dspsl.
!     To compute  inverse(A)*C , follow dspfa by dspsl.
!     To compute  determinant(A) , follow dspfa by dspdi.
!     To compute  inertia(A) , follow dspfa by dspdi.
!     To compute  inverse(A) , follow dspfa by dspdi.
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
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if the k-TH pivot block is singular. This is
!                     not an error condition for this subroutine,
!                     but it does indicate that dspsl or dspdi may
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
!     BLAS daxpy,dswap,idamax
!     Fortran dabs,DMAX1,DSQRT
!
!     Internal variables
!
double precision :: ak, akm1, bk, bkm1, denom, mulk, mulkm1, t
double precision :: absakk, alpha, colmax, rowmax
integer :: idamax, ij, ijj, ik, ikm1, im, imax, imaxp1, imim, imj, &
&imk
integer :: j, jj, jk, jkm1, jmax, jmim, k, kk, km1, km1k, km1km1, &
&km2, kstep
logical :: swap
!
!
!     Initialize
!
!     alpha is used in choosing pivot block SIZE.
alpha = (1.0d0 + dsqrt(17.0d0))/8.0d0
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
      if (ap(1) .eq. 0.0d0) info = 1
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
   absakk = dabs(ap(kk))
!
!        Determine the largest off-diagonal element in
!        column k.
!
   imax = idamax(k-1,ap(ik+1),1)
   imk = ik + imax
   colmax = dabs(ap(imk))
   if (absakk .lt. alpha*colmax) go to 30
      kstep = 1
      swap = .false.
   go to 90
30 continue
!
!           Determine the largest off-diagonal element in
!           row imax.
!
      rowmax = 0.0d0
      imaxp1 = imax + 1
      im = imax*(imax - 1)/2
      imj = im + 2*imax
      do j = imaxp1, k
         rowmax = dmax1(rowmax,dabs(ap(imj)))
         imj = imj + j
      end do
      if (imax .eq. 1) go to 50
         jmax = idamax(imax-1,ap(im+1),1)
         jmim = jmax + im
         rowmax = dmax1(rowmax,dabs(ap(jmim)))
50 continue
      imim = imax + im
      if (dabs(ap(imim)) .lt. alpha*rowmax) go to 60
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
   if (dmax1(absakk,colmax) .ne. 0.0d0) go to 100
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
         call dswap(imax,ap(im+1),1,ap(ik+1),1)
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
         call daxpy(j,t,ap(ik+1),1,ap(ij+1),1)
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
         call dswap(imax,ap(im+1),1,ap(ikm1+1),1)
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
         denom = 1.0d0 - ak*akm1
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
            call daxpy(j,t,ap(ik+1),1,ap(ij+1),1)
            t = mulkm1
            call daxpy(j,t,ap(ikm1+1),1,ap(ij+1),1)
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
      kpvt(k-1) = kpvt(k)
190 continue
   ik = ik - (k - 1)
   if (kstep .eq. 2) ik = ik - (k - 2)
   k = k - kstep
go to 10
200 continue
return
end subroutine dspfa

subroutine dspsl(ap,n,kpvt,b)
implicit none
integer, intent(in) :: n, kpvt(*)
double precision, intent(in) :: ap(*)
double precision, intent(inout) :: b(*)
!
!     DSISL solves the double precision symmetric system
!     A * X = b
!     using the factors computed by dspfa.
!
!     On entry
!
!        ap      DOUBLE PRECISION(n*(n+1)/2)
!                the output from dspfa.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!        kpvt    INTEGER(n)
!                the pivot vector from dspfa.
!
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero may occur if  dspco  has set RCOND .EQ. 0.0
!        or  dspfa  has set info .NE. 0  .
!
!     To compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call dspfa(ap,n,kpvt,info)
!           if (info .ne. 0) go to ...
!           do 10 j = 1, p
!              call dspsl(ap,n,kpvt,c(1,j))
!        10 continue
!
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!
!     Subroutines and functions
!
!     BLAS daxpy,ddot
!     FORTRAN IABS
!
!     Internal variables.
!
double precision :: ak, akm1, bk, bkm1, ddot, denom, temp
integer :: ik, ikm1, ikp1, k, kk, km1k, km1km1, kp
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
         call daxpy(k-1,b(k),ap(ik+1),1,b(1),1)
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
            temp = b(k-1)
            b(k-1) = b(kp)
            b(kp) = temp
50 continue
!
!              Apply the transformation.
!
         call daxpy(k-2,b(k),ap(ik+1),1,b(1),1)
         call daxpy(k-2,b(k-1),ap(ikm1+1),1,b(1),1)
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
      bkm1 = b(k-1)/ap(km1k)
      denom = ak*akm1 - 1.0d0
      b(k) = (akm1*bk - bkm1)/denom
      b(k-1) = (ak*bkm1 - bk)/denom
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
         b(k) = b(k) + ddot(k-1,ap(ik+1),1,b(1),1)
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
         b(k) = b(k) + ddot(k-1,ap(ik+1),1,b(1),1)
         ikp1 = ik + k
         b(k+1) = b(k+1) + ddot(k-1,ap(ikp1+1),1,b(1),1)
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
end subroutine dspsl

subroutine dspdi(ap,n,kpvt,det,inert,work,job)
implicit none
integer, intent(in) :: n, job
double precision, intent(inout) :: ap(*), work(*)
double precision, intent(inout) :: det(2)
integer, intent(in) :: kpvt(*)
integer, intent(inout) :: inert(3)
!
!     dspdi computes the determinant, inertia and inverse
!     of a double precision symmetric matrix using the factors from
!     dspfa, where the matrix is stored in packed form.
!
!     On entry
!
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the output from dspfa.
!
!        n       INTEGER
!                the order of the matrix A.
!
!        kpvt    INTEGER(n)
!                the pivot vector from dspfa.
!
!        WORK    DOUBLE PRECISION(n)
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
!        det    DOUBLE PRECISION(2)
!               determinant of original matrix.
!               determinant = det(1) * 10.0**det(2)
!               WITH 1.0 .LE. dabs(det(1)) .LT. 10.0
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
!        and  dspco  has set RCOND .EQ. 0.0
!        or  dspfa  has set  info .NE. 0 .
!
!     LINPACK. This version dated 08/14/78 .
!     James bunch, univ. Calif. San diego, argonne nat. Lab.
!
!     Subroutines and functions
!
!     BLAS daxpy,dcopy,ddot,dswap
!     Fortran dabs,IABS,mod
!
!     Internal variables.
!
double precision :: akkp1, ddot, temp
double precision :: ten, d, t, ak, akp1
integer :: ij, ik, ikp1, iks, j, jb, jk, jkp1
integer :: k, kk, kkp1, km1, ks, ksj, kskp1, kstep
logical :: noinv, nodet, noert
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
      det(1) = 1.0d0
      det(2) = 0.0d0
      ten = 10.0d0
20 continue
   t = 0.0d0
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
!              USE det (d  S)  =  (d/t * C - t) * t  ,  t = dabs(S)
!                      (S  C)
!              to avoid underflow/overflow troubles.
!              Take two passes through scaling.  Use  t  for flag.
!
         if (t .ne. 0.0d0) go to 30
            ikp1 = ik + k
            kkp1 = ikp1 + k
            t = dabs(ap(kkp1))
            d = (d/t)*ap(kkp1+1) - t
         go to 40
30 continue
            d = t
            t = 0.0d0
40 continue
50 continue
!
      if (noert) go to 60
         if (d .gt. 0.0d0) inert(1) = inert(1) + 1
         if (d .lt. 0.0d0) inert(2) = inert(2) + 1
         if (d .eq. 0.0d0) inert(3) = inert(3) + 1
60 continue
!
      if (nodet) go to 120
         det(1) = d*det(1)
         if (det(1) .eq. 0.0d0) go to 110
70 if (dabs(det(1)) .ge. 1.0d0) go to 80
               det(1) = ten*det(1)
               det(2) = det(2) - 1.0d0
            go to 70
80 continue
90 if (dabs(det(1)) .lt. ten) go to 100
               det(1) = det(1)/ten
               det(2) = det(2) + 1.0d0
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
         ap(kk) = 1.0d0/ap(kk)
         if (km1 .lt. 1) go to 170
            call dcopy(km1,ap(ik+1),1,work,1)
            ij = 0
            do j = 1, km1
               jk = ik + j
               ap(jk) = ddot(j,ap(ij+1),1,work,1)
               call daxpy(j-1,work(j),ap(ij+1),1,ap(ik+1),1)
               ij = ij + j
            end do
            ap(kk) = ap(kk) + ddot(km1,work,1,ap(ik+1),1)
170 continue
         kstep = 1
      go to 220
180 continue
!
!              2 By 2
!
         t = dabs(ap(kkp1))
         ak = ap(kk)/t
         akp1 = ap(kkp1+1)/t
         akkp1 = ap(kkp1)/t
         d = t*(ak*akp1 - 1.0d0)
         ap(kk) = akp1/d
         ap(kkp1+1) = ak/d
         ap(kkp1) = -akkp1/d
         if (km1 .lt. 1) go to 210
            call dcopy(km1,ap(ikp1+1),1,work,1)
            ij = 0
            do j = 1, km1
               jkp1 = ikp1 + j
               ap(jkp1) = ddot(j,ap(ij+1),1,work,1)
               call daxpy(j-1,work(j),ap(ij+1),1,ap(ikp1+1),1)
               ij = ij + j
            end do
            ap(kkp1+1) = ap(kkp1+1) &
&+ ddot(km1,work,1,ap(ikp1+1),1)
            ap(kkp1) = ap(kkp1) &
&+ ddot(km1,ap(ik+1),1,ap(ikp1+1),1)
            call dcopy(km1,ap(ik+1),1,work,1)
            ij = 0
            do j = 1, km1
               jk = ik + j
               ap(jk) = ddot(j,ap(ij+1),1,work,1)
               call daxpy(j-1,work(j),ap(ij+1),1,ap(ik+1),1)
               ij = ij + j
            end do
            ap(kk) = ap(kk) + ddot(km1,work,1,ap(ik+1),1)
210 continue
         kstep = 2
220 continue
!
!           Swap
!
      ks = iabs(kpvt(k))
      if (ks .eq. k) go to 250
         iks = (ks*(ks - 1))/2
         call dswap(ks,ap(iks+1),1,ap(ik+1),1)
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
end subroutine dspdi

subroutine pchol (mo,n,m,a,b,kb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m, mo, n
integer :: j
!     -----------------
real, intent(inout) :: a(*), b(*)
real :: d(2)
integer :: onej
!     -----------------
!
!              Matrix factorization
!
call sppfa (a,n,ierr)
if (ierr .ne. 0) return
!
!          Solution of the equation AX=b
!
if (m .lt. 1) go to 20
onej = 1
do 10 j = 1,m
   call sppsl (a,n,b(onej))
10 onej = onej + kb
!
!         Computation of the inverse of A
!
20 if (mo .eq. 0) call sppdi (a,n,d,1)
return
end subroutine pchol

subroutine sppfa(ap,n,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: info
real, intent(inout) :: ap(*)
!
!     sppfa factors a real symmetric positive definite matrix
!     stored in packed form.
!
!     sppfa is usually called by SPPCO, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for SPPCO) = (1 + 18/n)*(time for sppfa) .
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
!     On return
!
!        ap      AN UPPER TRIANGULAR MATRIX  R , STORED IN PACKED
!                form, so that  A = Trans(R)*R .
!
!        INFO    INTEGER
!                = 0  For normal return.
!                = k  if the leading minor of order  k  is not
!                     positive definite.
!
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
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS sdot
!     Fortran sqrt
!
!     Internal variables
!
real :: sdot, t
real :: s
integer :: j, jj, jm1, k, kj, kk
!     Begin block with ...exits to 40
!
!
   jj = 0
   do j = 1, n
      info = j
      s = 0.0e0
      jm1 = j - 1
      kj = jj
      kk = 0
      if (jm1 .lt. 1) go to 20
      do k = 1, jm1
         kj = kj + 1
         t = ap(kj) - sdot(k-1,ap(kk+1),1,ap(jj+1),1)
         kk = kk + k
         t = t/ap(kk)
         ap(kj) = t
         s = s + t*t
      end do
20 continue
      jj = jj + j
      s = ap(jj) - s
!     ......Exit
      if (s .le. 0.0e0) go to 40
      ap(jj) = sqrt(s)
   end do
   info = 0
40 continue
return
end subroutine sppfa

subroutine sppsl(ap,n,b)
implicit none
integer, intent(in) :: n
real, intent(in) :: ap(*)
real, intent(inout) :: b(*)
!
!     sppsl solves the real symmetric positive definite system
!     A * X = b
!     using the factors computed by SPPCO or sppfa.
!
!     On entry
!
!        ap      real (n*(n+1)/2)
!                the output from SPPCO or sppfa.
!
!        n       INTEGER
!                the order of the matrix  A .
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
!        A division by zero will occur if the input factor contains
!        a zero on the diagonal.  Technically this indicates
!        singularity but it is usually caused by improper subroutine
!        arguments.  It will not occur if the subroutines are called
!        correctly and  info .EQ. 0 .
!
!     To compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call sppco(ap,n,rcond,z,info)
!           if (rcond is too small .or. info .ne. 0) go to ...
!           do 10 j = 1, p
!              call sppsl(ap,n,c(1,j))
!        10 continue
!
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sdot
!
!     Internal variables
!
real :: sdot, t
integer :: k, kb, kk
!
kk = 0
do k = 1, n
   t = sdot(k-1,ap(kk+1),1,b(1),1)
   kk = kk + k
   b(k) = (b(k) - t)/ap(kk)
end do
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/ap(kk)
   kk = kk - k
   t = -b(k)
   call saxpy(k-1,t,ap(kk+1),1,b(1),1)
end do
return
end subroutine sppsl

subroutine sppdi(ap,n,det,job)
implicit none
integer, intent(in) :: n, job
real, intent(inout) :: ap(*)
real, intent(inout) :: det(2)
!
!     sppdi computes the determinant and inverse
!     of a real symmetric positive definite matrix
!     using the factors computed by SPPCO or sppfa .
!
!     On entry
!
!        ap      real (n*(n+1)/2)
!                the output from SPPCO or sppfa.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!
!     On return
!
!        ap      THE UPPER TRIANGULAR HALF OF THE INVERSE .
!
!        det     real(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. det(1) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if SPOCO or SPOFA has set info .EQ. 0 .
!
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sscal
!     Fortran mod
!
!     Internal variables
!
real :: t
real :: s
integer :: i, ii, j, jj, jm1, j1, k, kj, kk, kp1, k1
!
!     Compute determinant
!
if (job/10 .eq. 0) go to 70
   det(1) = 1.0e0
   det(2) = 0.0e0
   s = 10.0e0
   ii = 0
   do 50 i = 1, n
      ii = ii + i
      det(1) = ap(ii)**2*det(1)
!        ...Exit
      if (det(1) .eq. 0.0e0) go to 60
10 if (det(1) .ge. 1.0e0) go to 20
         det(1) = s*det(1)
         det(2) = det(2) - 1.0e0
      go to 10
20 continue
30 if (det(1) .lt. s) go to 40
         det(1) = det(1)/s
         det(2) = det(2) + 1.0e0
      go to 30
40 continue
50 continue
60 continue
70 continue
!
!     Compute inverse(R)
!
if (mod(job,10) .eq. 0) go to 140
   kk = 0
   do k = 1, n
      k1 = kk + 1
      kk = kk + k
      ap(kk) = 1.0e0/ap(kk)
      t = -ap(kk)
      call sscal(k-1,t,ap(k1),1)
      kp1 = k + 1
      j1 = kk + 1
      kj = kk + k
      if (n .lt. kp1) go to 90
      do j = kp1, n
         t = ap(kj)
         ap(kj) = 0.0e0
         call saxpy(k,t,ap(k1),1,ap(j1),1)
         j1 = j1 + j
         kj = kj + j
      end do
90 continue
   end do
!
!        Form  inverse(R) * trans(inverse(R))
!
   jj = 0
   do j = 1, n
      j1 = jj + 1
      jj = jj + j
      jm1 = j - 1
      k1 = 1
      kj = j1
      if (jm1 .lt. 1) go to 120
      do k = 1, jm1
         t = ap(kj)
         call saxpy(k,t,ap(j1),1,ap(k1),1)
         k1 = k1 + k
         kj = kj + 1
      end do
120 continue
      t = ap(jj)
      call sscal(j,t,ap(j1),1)
   end do
140 continue
return
end subroutine sppdi

subroutine dpchol (mo,n,m,a,b,kb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m, mo, n
integer :: j
!     -----------------
double precision, intent(inout) :: a(*), b(*)
double precision :: d(2)
integer :: onej
!     -----------------
!
!              Matrix factorization
!
call dppfa (a,n,ierr)
if (ierr .ne. 0) return
!
!          Solution of the equation AX=b
!
if (m .lt. 1) go to 20
onej = 1
do 10 j = 1,m
   call dppsl (a,n,b(onej))
10 onej = onej + kb
!
!         Computation of the inverse of A
!
20 if (mo .eq. 0) call dppdi (a,n,d,1)
return
end subroutine dpchol

subroutine dppfa(ap,n,info)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: info
double precision, intent(inout) :: ap(*)
!
!     dppfa factors a double precision symmetric positive definite
!     matrix stored in packed form.
!
!     dppfa is usually called by DPPCO, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (Time for DPPCO) = (1 + 18/n)*(time for dppfa) .
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
!     On return
!
!        ap      AN UPPER TRIANGULAR MATRIX  R , STORED IN PACKED
!                form, so that  A = Trans(R)*R .
!
!        INFO    INTEGER
!                = 0  For normal return.
!                = k  if the leading minor of order  k  is not
!                     positive definite.
!
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
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS ddot
!     FORTRAN DSQRT
!
!     Internal variables
!
double precision :: ddot, t
double precision :: s
integer :: j, jj, jm1, k, kj, kk
!     Begin block with ...exits to 40
!
!
   jj = 0
   do j = 1, n
      info = j
      s = 0.0d0
      jm1 = j - 1
      kj = jj
      kk = 0
      if (jm1 .lt. 1) go to 20
      do k = 1, jm1
         kj = kj + 1
         t = ap(kj) - ddot(k-1,ap(kk+1),1,ap(jj+1),1)
         kk = kk + k
         t = t/ap(kk)
         ap(kj) = t
         s = s + t*t
      end do
20 continue
      jj = jj + j
      s = ap(jj) - s
!     ......Exit
      if (s .le. 0.0d0) go to 40
      ap(jj) = dsqrt(s)
   end do
   info = 0
40 continue
return
end subroutine dppfa

subroutine dppsl(ap,n,b)
implicit none
integer, intent(in) :: n
double precision, intent(in) :: ap(*)
double precision, intent(inout) :: b(*)
!
!     dppsl solves the double precision symmetric positive definite
!     SYSTEM A * X = b
!     using the factors computed by DPPCO or dppfa.
!
!     On entry
!
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the output from DPPCO or dppfa.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains
!        a zero on the diagonal.  Technically this indicates
!        singularity but it is usually caused by improper subroutine
!        arguments.  It will not occur if the subroutines are called
!        correctly and  info .EQ. 0 .
!
!     To compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call dppco(ap,n,rcond,z,info)
!           if (rcond is too small .or. info .ne. 0) go to ...
!           do 10 j = 1, p
!              call dppsl(ap,n,c(1,j))
!        10 continue
!
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS daxpy,ddot
!
!     Internal variables
!
double precision :: ddot, t
integer :: k, kb, kk
!
kk = 0
do k = 1, n
   t = ddot(k-1,ap(kk+1),1,b(1),1)
   kk = kk + k
   b(k) = (b(k) - t)/ap(kk)
end do
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/ap(kk)
   kk = kk - k
   t = -b(k)
   call daxpy(k-1,t,ap(kk+1),1,b(1),1)
end do
return
end subroutine dppsl

subroutine dppdi(ap,n,det,job)
implicit none
integer, intent(in) :: n, job
double precision, intent(inout) :: ap(*)
double precision, intent(inout) :: det(2)
!
!     dppdi computes the determinant and inverse
!     of a double precision symmetric positive definite matrix
!     using the factors computed by DPPCO or dppfa .
!
!     On entry
!
!        ap      DOUBLE PRECISION (n*(n+1)/2)
!                the output from DPPCO or dppfa.
!
!        n       INTEGER
!                the order of the matrix  A .
!
!        JOB     INTEGER
!                = 11   Both determinant and inverse.
!                = 01   Inverse only.
!                = 10   Determinant only.
!
!     On return
!
!        ap      THE UPPER TRIANGULAR HALF OF THE INVERSE .
!
!        det     DOUBLE PRECISION(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. det(1) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        and if DPOCO or DPOFA has set info .EQ. 0 .
!
!     LINPACK.  This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS daxpy,dscal
!     Fortran mod
!
!     Internal variables
!
double precision :: t
double precision :: s
integer :: i, ii, j, jj, jm1, j1, k, kj, kk, kp1, k1
!
!     Compute determinant
!
if (job/10 .eq. 0) go to 70
   det(1) = 1.0d0
   det(2) = 0.0d0
   s = 10.0d0
   ii = 0
   do 50 i = 1, n
      ii = ii + i
      det(1) = ap(ii)**2*det(1)
!        ...Exit
      if (det(1) .eq. 0.0d0) go to 60
10 if (det(1) .ge. 1.0d0) go to 20
         det(1) = s*det(1)
         det(2) = det(2) - 1.0d0
      go to 10
20 continue
30 if (det(1) .lt. s) go to 40
         det(1) = det(1)/s
         det(2) = det(2) + 1.0d0
      go to 30
40 continue
50 continue
60 continue
70 continue
!
!     Compute inverse(R)
!
if (mod(job,10) .eq. 0) go to 140
   kk = 0
   do k = 1, n
      k1 = kk + 1
      kk = kk + k
      ap(kk) = 1.0d0/ap(kk)
      t = -ap(kk)
      call dscal(k-1,t,ap(k1),1)
      kp1 = k + 1
      j1 = kk + 1
      kj = kk + k
      if (n .lt. kp1) go to 90
      do j = kp1, n
         t = ap(kj)
         ap(kj) = 0.0d0
         call daxpy(k,t,ap(k1),1,ap(j1),1)
         j1 = j1 + j
         kj = kj + j
      end do
90 continue
   end do
!
!        Form  inverse(R) * trans(inverse(R))
!
   jj = 0
   do j = 1, n
      j1 = jj + 1
      jj = jj + j
      jm1 = j - 1
      k1 = 1
      kj = j1
      if (jm1 .lt. 1) go to 120
      do k = 1, jm1
         t = ap(kj)
         call daxpy(k,t,ap(j1),1,ap(k1),1)
         k1 = k1 + k
         kj = kj + 1
      end do
120 continue
      t = ap(jj)
      call dscal(j,t,ap(j1),1)
   end do
140 continue
return
end subroutine dppdi

subroutine toplx (a, b, x, n, g, h, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
integer :: j, k, l, m, max, mp1, nml, npl
real :: c, c1, c2, gd, gj, gk, gn, hj, hk, hn, xd, xn
!-----------------------------------------------------------------------
!            Solution of the Toeplitz system of equations
!
!               sum(j = 1,...,n) a(n+I-j)*x(j) = b(I)
!
!     FOR I = 1,...,n.
!-----------------------------------------------------------------------
!     real a(2*n - 1)
!----------------------
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), g(n), h(n)
!
if (a(n) .eq. 0.0) go to 100
ierr = 0
x(1) = b(1)/a(n)
if (n .eq. 1) return
g(1) = a(n - 1)/a(n)
h(1) = a(n + 1)/a(n)
mp1 = 1
!
!     Compute numerator and denominator of x(m+1)
!
10 m = mp1
mp1 = m + 1
xn = -b(mp1)
xd = -a(n)
do 20 j = 1,m
   l = mp1 - j
   npl = n + l
   xn = xn + a(npl)*x(j)
20 xd = xd + a(npl)*g(l)
if (xd .eq. 0.0) go to 100
x(mp1) = xn/xd
!
!        Compute x
!
c = x(mp1)
do 30 j = 1,m
   l = mp1 - j
30 x(j) = x(j) - c*g(l)
if (mp1 .eq. n) return
!
!     Compute numerator and denominator of g(m+1) and h(m+1)
!
l = n - mp1
gn = -a(l)
gd = -a(n)
l = n + mp1
hn = -a(l)
do 40 j = 1,m
   l = mp1 - j
   nml = n - l
   npl = n + l
   gn = gn + a(nml)*g(j)
   gd = gd + a(nml)*h(l)
40 hn = hn + a(npl)*h(j)
if (gd .eq. 0.0) go to 100
g(mp1) = gn/gd
h(mp1) = hn/xd
!
!     Compute g and h
!
c1 = g(mp1)
c2 = h(mp1)
max = mp1/2
k = m
do 50 j = 1,max
   gj = g(j)
   gk = g(k)
   hj = h(j)
   hk = h(k)
   g(j) = gj - c1*hk
   g(k) = gk - c1*hj
   h(j) = hj - c2*gk
   h(k) = hk - c2*gj
50 k = k - 1
go to 10
!
!     Error return
!
100 ierr = 1
return
end subroutine toplx

subroutine dtoplx (a, b, x, n, g, h, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
integer :: j, k, l, m, max, mp1, nml, npl
!-----------------------------------------------------------------------
!            Solution of the Toeplitz system of equations
!
!               sum(j = 1,...,n) a(n+I-j)*x(j) = b(I)
!
!     FOR I = 1,...,n.
!-----------------------------------------------------------------------
!     double precision a(2*n - 1)
!----------------------
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), g(n), h(n)
double precision :: c, c1, c2, gd, gj, gk, gn, hj, hk, hn, xd, xn
!
if (a(n) .eq. 0.d0) go to 100
ierr = 0
x(1) = b(1)/a(n)
if (n .eq. 1) return
g(1) = a(n - 1)/a(n)
h(1) = a(n + 1)/a(n)
mp1 = 1
!
!     Compute numerator and denominator of x(m+1)
!
10 m = mp1
mp1 = m + 1
xn = -b(mp1)
xd = -a(n)
do 20 j = 1,m
   l = mp1 - j
   npl = n + l
   xn = xn + a(npl)*x(j)
20 xd = xd + a(npl)*g(l)
if (xd .eq. 0.d0) go to 100
x(mp1) = xn/xd
!
!        Compute x
!
c = x(mp1)
do 30 j = 1,m
   l = mp1 - j
30 x(j) = x(j) - c*g(l)
if (mp1 .eq. n) return
!
!     Compute numerator and denominator of g(m+1) and h(m+1)
!
l = n - mp1
gn = -a(l)
gd = -a(n)
l = n + mp1
hn = -a(l)
do 40 j = 1,m
   l = mp1 - j
   nml = n - l
   npl = n + l
   gn = gn + a(nml)*g(j)
   gd = gd + a(nml)*h(l)
40 hn = hn + a(npl)*h(j)
if (gd .eq. 0.d0) go to 100
g(mp1) = gn/gd
h(mp1) = hn/xd
!
!     Compute g and h
!
c1 = g(mp1)
c2 = h(mp1)
max = mp1/2
k = m
do 50 j = 1,max
   gj = g(j)
   gk = g(k)
   hj = h(j)
   hk = h(k)
   g(j) = gj - c1*hk
   g(k) = gk - c1*hj
   h(j) = hj - c2*gk
   h(k) = hk - c2*gj
50 k = k - 1
go to 10
!
!     Error return
!
100 ierr = 1
return
end subroutine dtoplx

subroutine cmslv(mo,n,m,a,ka,b,kb,det,rcond,ierr,ipvt,wk)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, mo
integer :: n
integer :: j, job
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting complex matrices
!     and solving complex equations
!-----------------------------------------------------------------------
complex, intent(inout) :: a(ka,n), b(*), det(2), wk(n)
real, intent(inout) :: rcond
real :: t
integer, intent(inout) :: ipvt(n)
integer :: onej
!
!          Matrix factorization and computation of rcond
!
ierr = 0
call cgeco (a, ka, n, ipvt, rcond, wk)
t = 1.0 + rcond
if (t .eq. 1.0) go to 30
!
!                  Solution of the equation AX=b
!
if (m .lt. 1) go to 20
onej = 1
do 10 j = 1,m
   call cgesl (a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
10 continue
!
!             Calculation of det and the inverse of A
!
20 job = 10
if (mo .eq. 0) job = 11
call cgedi (a, ka, n, ipvt, det, wk, job)
return
!
!                  The problem cannot be solved
!
30 ierr = 1
return
end subroutine cmslv

subroutine cmslv1 (mo, n, m, a, ka, b, kb, ierr, ipvt, wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo
integer :: n
integer :: j
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting complex matrices
!     and solving complex equations
!-----------------------------------------------------------------------
complex, intent(inout) :: a(ka,n), b(*), wk(*)
integer, intent(inout) :: ipvt(n)
complex :: d(2)
integer :: onej
!
if (n .lt. 1 .or. ka .lt. n) go to 40
if (m .le. 0) go to 10
if (kb .lt. n) go to 40
!
!                      Matrix factorization
!
10 call cgefa (a, ka, n, ipvt, ierr)
if (ierr .ne. 0) return
!
!                 Solution of the equation AX = b
!
if (m .le. 0) go to 30
onej = 1
do j = 1,m
   call cgesl (a, ka, n, ipvt, b(onej), 0)
   onej = onej + kb
end do
!
!                 Calculation of the inverse of A
!
30 if (mo .eq. 0) call cgedi (a, ka, n, ipvt, d, wk, 1)
return
!
!                          Error return
!
40 ierr = -1
return
end subroutine cmslv1

