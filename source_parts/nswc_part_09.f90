pure subroutine bval(t, bcoef, n, k, x, jderiv, w, wk)
implicit none
integer, intent(in) :: jderiv, k, n
real, intent(inout) :: w
real, intent(in) :: x
real, intent(in) :: t(*), bcoef(n)
real, intent(inout) :: wk(k,3)
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
implicit none
integer, intent(in) :: k, n
real, intent(out) :: w
real, intent(in) :: x
real, intent(in) :: t(*), bcoeff(n)
real, intent(inout) :: wk(*)
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
implicit none
integer, intent(in) :: k, n
real, intent(in) :: tnew
real, intent(out) :: w
real, intent(in) :: x
real, intent(in) :: t(*), bcoef(n)
real, intent(inout) :: wk(k,3)
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
implicit none
integer, intent(in) :: k
integer, intent(out) :: l
integer, intent(in) :: n
real, intent(in) :: t(*), a(n)
real, intent(inout) :: break(*), c(k,*), wk(k,*)
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
implicit none
integer, intent(in) :: l, n, ni
real :: a(l,n), x(n), xi(ni)
real, intent(inout) :: yi(ni)
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
implicit none
integer, intent(inout) :: j
integer, intent(in) :: jhigh, k, left
real, intent(in) :: x
real, intent(in) :: t(*)
real, intent(inout) :: blist(k)
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
implicit none
integer, intent(in) :: idim, k, left, nderiv
real, intent(in) :: x
real, intent(in) :: t(*)
real, intent(inout) :: dbiatx(idim,nderiv), a(k,k)
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
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: k, n
real, intent(inout) :: bcoef(n)
real, intent(in) :: gtau(n)
real, intent(inout) :: q(*)
real, intent(in) :: t(*), tau(n)
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
implicit none
integer, intent(out) :: iflag
integer, intent(in) :: nbandl, nbandu, nrow, nroww
real, intent(inout) :: w(nroww,nrow)
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
implicit none
integer, intent(in) :: nbandl, nbandu, nrow, nroww
real, intent(in) :: w(nroww,nrow)
real, intent(inout) :: b(nrow)
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
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: k, n, ntau
real, intent(in) :: tau(ntau), gtau(ntau), wgt(ntau)
real, intent(in) :: t(*)
real, intent(inout) :: a(n), wk(n), q(k,n)
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
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: n, nb
real, intent(inout) :: w(nb,n), diag(n)
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
implicit none
integer, intent(in) :: n, nb
real, intent(in) :: w(nb,n)
real, intent(inout) :: b(n)
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
implicit none
integer, intent(inout) :: mode
integer, intent(in) :: n, nconst, ndata, nord
real, intent(inout) :: rnorm
real, intent(in) :: bkpt(*), xdata(ndata), ydata(ndata)
real, intent(in) :: xconst(*), yconst(*)
real, intent(inout) :: coeff(n), w(*)
integer, intent(in) :: nderiv(*)
integer, intent(inout) :: iw(*)
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
implicit none
integer, intent(inout) :: ip, ir
integer, intent(in) :: jt, mdg, mt, nb
real, intent(inout) :: g(mdg,*)
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
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ip, ir, mdg, mode, n, nb
real :: g(mdg,*)
real, intent(out) :: rnorm
real, intent(inout) :: x(n)
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
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kz, mx, my, num, nx, ny
real, intent(in) :: x(mx), wx(mx), y(my), wy(my), z(kz, my)
real, intent(in) :: xbreak(nx), ybreak(ny)
real, intent(inout) :: f(*)
real, intent(inout) :: s(*), t(*), wk(num)
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
implicit none
integer, intent(in) :: ka, kdz, kz, m, n
real, intent(in) :: t(*), a(ka,n)
real, intent(inout) :: z(kz,*), dz(kdz,*)
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
implicit none
integer, intent(in) :: ider, jder, kf, kf1, kf12, kf2, kz, m, mx, &
   & my, n
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), f1(kf1,n), f2(kf2,n), &
   & f12(kf12,n)
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
implicit none
integer, intent(in) :: ider, jder, kf, kf1, kf12, kf2, kz, m, mx, &
   & my, n
real, intent(in) :: x(mx), y(my)
real, intent(inout) :: z(kz,my)
real, intent(in) :: s(m), t(n), f(kf,n), f1(kf1,n), f2(kf2,n), &
   & f12(kf12,n)
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
implicit none
integer, intent(in) :: m, n, iz
integer, intent(out) :: ierr
real, intent(in) :: x(m), y(n), z(iz,n), opt(*)
real, intent(inout) :: zp(m,n,*), temp(*)
real, intent(in) :: sigma
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
implicit none
integer, intent(in) :: m, n, iz
real, intent(in) :: xx, yy, x(m), y(n)
real :: z(iz,n), zp(m,n,*)
real, intent(in) :: sigma
integer :: i, im1, j, jm1
real :: coshp1, coshp2, del1, del2, delp1, delp2, dels, dummy, f1, &
   & f2, fp1, fp2, sigmap, sigmax, sigmay, sinhm1, sinhm2, sinhms, &
   & sinhp1, sinhp2, zi, zim1, zxxi, zxxim1
real :: surf2
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
implicit none
integer, intent(in) :: md, nd, idz, m, n, iz
real, intent(in) :: dxmin, dxmax, dymin, dymax
real, intent(inout) :: dz(idz,nd)
real, intent(in) :: x(m), y(n), z(iz,n), zp(m,n,*)
real, intent(inout) :: work(4,md)
real, intent(in) :: sigma
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
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: ka, kx, ky, kz, l, nx, ny
real, intent(in) :: x(nx), y(ny), z(kz,ny)
real, intent(in) :: tx(*), ty(*)
real, intent(inout) :: a(ka,ny), wk(l)
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
implicit none
integer, intent(out) :: iflag
integer, intent(in) :: k, ka, kz, m, n
real, intent(in) :: x(m), z(kz,n), t(*)
real, intent(inout) :: a(ka,m), work(*)
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
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: ka, kx, ky, kz, l, mx, my, nx, ny
real, intent(in) :: x(mx), wx(mx), y(my), wy(my), z(kz,my)
real, intent(in) :: tx(*), ty(*)
real, intent(inout) :: a(ka,ny), wk(l)
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
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: k, ka, kz, m, n, ntau
real, intent(in) :: tau(ntau), wgt(ntau), z(kz,m)
real, intent(in) :: t(*)
real, intent(inout) :: a(ka,n), wk(n), q(k,n)
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
implicit none
integer, intent(in) :: kb, m, n, nb
real, intent(in) :: w(nb,n)
real, intent(inout) :: b(kb,n)
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
implicit none
integer, intent(in) :: idx, idy, ka, kx, ky, nx, ny
real, intent(out) :: f
real, intent(in) :: x0, y0
real, intent(in) :: a(ka,ny), tx(*), ty(*)
real, intent(inout) :: wk(*)
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
implicit none
integer, intent(in) :: n
integer, intent(inout) :: iadj(*), iend(n)
integer, intent(out) :: ier
real :: x(n), y(n)
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
implicit none
integer, intent(in) :: kk
integer, intent(inout) :: iadj(*), iend(kk)
integer, intent(out) :: ier
real :: x(kk), y(kk)
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
implicit none
integer, intent(in) :: kk, i1, i2
integer, intent(inout) :: iadj(*), iend(kk)
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
implicit none
integer, intent(in) :: kk, i1, i2, i3
integer, intent(inout) :: iadj(*), iend(kk)
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
implicit none
integer, intent(in) :: nfrst, nlast, kk
integer, intent(inout) :: iarr(*)
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
implicit none
integer, intent(in) :: nin1, nin2, nout1, nout2
integer, intent(inout) :: iadj(*), iend(*)
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
implicit none
integer, intent(in) :: in1, in2, io1, io2
real, intent(in) :: x(*), y(*)
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
implicit none
integer, intent(in) :: nvertx, nabor, iadj(*), iend(*)
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
implicit none
integer, intent(in) :: nst, iadj(*), iend(*)
integer, intent(inout) :: i1, i2, i3
real, intent(in) :: px, py
real :: x(*), y(*)
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
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: zxzy(2,n)
integer, intent(in) :: iadj(*), iend(n)
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
implicit none
integer, intent(in) :: n, iadj(*), iend(n)
integer, intent(inout) :: nit, ier
real, intent(in) :: x(n), y(n), z(n), eps
real, intent(inout) :: zxzy(2,n)
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
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: zxzy(2,n)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
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
implicit none
integer, intent(in) :: n, k, iadj(*)
integer, intent(inout) :: iend(n), ier
real, intent(in) :: x(n), y(n), z(n)
real, intent(inout) :: dx, dy
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
implicit none
real, intent(in) :: xk, yk, zk, xi, yi, zi, s1, s2, r
real, intent(inout) :: row(6)
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

pure subroutine getnp(x,y,iadj,iend,l, npts, ds,ier)
implicit none
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(*)
integer, intent(in) :: l
integer, intent(inout) :: npts(l), ier
real, intent(in) :: x(*), y(*)
real, intent(inout) :: ds
integer :: lm1, n1, i, ni, np, indf, indl, indx, nb
real :: x1, y1, dnp, dnb
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given a thiessen triangulation of N nodes and an array
! npts containing the indices of l-1 nodes ordered by
! Euclidean distance from npts(1), this subroutine sets
! npts(l) to the index of the next node in the sequence --
! the node, other than npts(1),...,npts(l-1), which is
! closest to npts(1).  Thus, the ordered sequence of K
! closest nodes to n1 (including n1) may be determined by
! K-1 calls to getnp with npts(1) = n1 and l = 2,3,...,K
! FOR K .GE. 2.
!   The algorithm uses the fact that, in a thiessen trian-
! gulation, the K-TH closest node to a given node n1 is A
! neighbor of one of the K-1 closest nodes to n1.
! Input parameters - x,y - Vectors of length N containing
!                          the cartesian coordinates of the
!                          nodes.
!                   iadj - Set of adjacency lists of nodes
!                          in the triangulation.
!                   iend - Pointers to the ends of adjacency
!                          lists for each node in the TRI-
!                          angulation.
!                      l - Number of nodes in the sequence
!                          on output.  2 .LE. l .LE. N.
!                   npts - Array of length .GE. l contain-
!                          ing the indices of the l-1 clos-
!                          est nodes to npts(1) in the first
!                          l-1 LOCATIONS.
! iadj and iend may be created by subroutine trmesh.
! Input parameters other than npts are not altered by this
!   routine.
! Output parameters - npts - Updated with the index of the
!                            l-TH closest node to npts(1) in
!                            position l unless ier = 1.
!                       ds - Squared Euclidean distance be-
!                            tween npts(1) and npts(l)
!                            unless ier = 1.
!                      ier - Error indicator
!                            ier = 0 If no errors were EN-
!                                    countered.
!                            ier = 1 If l is out of range.
! Modules referenced by getnp - None
! intrinsic function called by getnp - IABS
!***********************************************************
! Local parameters -
! lm1 =     l - 1
! n1 =      npts(1)
! i =       npts index and do-loop index
! ni =      npts(i)
! np =      Candidate for npts(l)
! indf =    iadj index of the first neighbor of ni
! indl =    iadj index of the last neighbor of ni
! indx =    iadj index in the range indf,...,indl
! nb =      Neighbor of ni and candidate for np
! x1,y1 =   Coordinates of n1
! dnp,dnb = Squared distances from n1 to np and nb,
!             respectively
lm1 = l - 1
if (lm1 < 1) go to 4
ier = 0
n1 = npts(1)
x1 = x(n1)
y1 = y(n1)
! Mark the elements of npts
do i = 1,lm1
   ni = npts(i)
   iend(ni) = -iend(ni)
end do
! Candidates for np = npts(l) are the unmarked neighbors
!   of nodes in npts.  np=0 Is a flag to set np to the
!   first candidate encountered.
np = 0
dnp = 0.
! Loop on nodes ni in npts
do i = 1,lm1
   ni = npts(i)
   indf = 1
   if (ni > 1) indf = abs(iend(ni - 1)) + 1
   indl = -iend(ni)
! Loop on neighbors nb of ni
   do indx = indf,indl
      nb = iadj(indx)
      if (nb == 0  .or.  iend(nb) < 0) go to 2
! nb is an unmarked neighbor of ni.  Replace np if nb is
!   closer to n1 or is the first candidate encountered.
      dnb = (x(nb) - x1)**2 + (y(nb) - y1)**2
      if (np /= 0  .and.  dnb >= dnp) go to 2
      np = nb
      dnp = dnb
2     continue
   end do
end do
npts(l) = np
ds = dnp
! Unmark the elements of npts
do i = 1,lm1
   ni = npts(i)
   iend(ni) = -iend(ni)
end do
return
! l is out of range
4 ier = 1
end subroutine getnp

subroutine sfval(n, x, y, z, m, xi, yi, zi, iadj, iend, &
   & zxzy, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
real :: x(n), y(n)
real, intent(in) :: z(n), xi(m), yi(m)
real, intent(inout) :: zi(m)
real, intent(in) :: zxzy(2,n)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
integer :: ist, j
!-----------------------------------------------------------------------
!                    Evaluation of the surface
!-----------------------------------------------------------------------
if (n < 3 .or. m < 1) go to 20
ist = 1
do j = 1,m
   call intrc1(n, xi(j), yi(j), x, y, z, iadj, iend, &
      & 1, zxzy, ist, zi(j), ierr)
   if (ierr < 0) go to 30
end do
ierr = 0
return
!     Error return
20 ierr = 1
return
30 ierr = 2
end subroutine sfval

subroutine sfval2(n, x, y, z, l, m, nrows, xi, yi, zi, &
   & iadj, iend, zxzy, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, nrows
real :: x(n), y(n)
real, intent(in) :: z(n), zxzy(2,n)
real, intent(in) :: xi(l), yi(m)
real, intent(inout) :: zi(nrows,m)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
integer :: i, ist, j
!-----------------------------------------------------------------------
!                Evaluation of the surface over a grid
!-----------------------------------------------------------------------
if (n < 3 .or. l < 1 .or. m < 1 .or. nrows < l) &
   & go to 30
ist = 1
do j = 1,m
   do i = 1,l
      call intrc1(n, xi(i), yi(j), x, y, z, iadj, iend, &
         & 1, zxzy, ist, zi(i,j), ierr)
      if (ierr < 0) go to 40
   end do
end do
ierr = 0
return
!     Error return
30 ierr = 1
return
40 ierr = 2
end subroutine sfval2

subroutine intrc1(n,px,py,x,y,z,iadj,iend,iflag, &
   & zxzy, ist, pz,ier)
implicit none
integer, intent(in) :: n, iadj(*)
integer, intent(inout) :: iend(n)
integer, intent(in) :: iflag
integer, intent(inout) :: ist, ier
real, intent(in) :: px, py
real :: x(n), y(n)
real, intent(in) :: z(n), zxzy(2,n)
real, intent(out) :: pz
integer :: nn, i1, i2, i3, ierr, n1, n2, indx
real :: xp, yp, zx1, zy1, zx2, zy2, zx3, zy3, x1, y1, x2, y2, x3, &
   & y3, z1, z2, z3, dum, dp, u, v, xq, yq, r1, r2, a1, a2, b1, b2, c1, &
   & c2, f1, f2
interface
   pure elemental subroutine tval(x,y,x1,x2,x3,y1,y2,y3,z1,z2, &
      & z3,zx1,zx2,zx3,zy1,zy2,zy3,iflag,w,wx,wy,ier)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(in) :: x1
      real, intent(in) :: x2
      real, intent(in) :: x3
      real, intent(in) :: y1
      real, intent(in) :: y2
      real, intent(in) :: y3
      real, intent(in) :: z1
      real, intent(in) :: z2
      real, intent(in) :: z3
      real, intent(in) :: zx1
      real, intent(in) :: zx2
      real, intent(in) :: zx3
      real, intent(in) :: zy1
      real, intent(in) :: zy2
      real, intent(in) :: zy3
      integer, intent(in) :: iflag
      real, intent(inout) :: w
      real, intent(inout) :: wx
      real, intent(inout) :: wy
      integer, intent(inout) :: ier
   end subroutine tval
end interface
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given a triangulation of a set of points in the plane,
! this routine determines a piecewise cubic function F(x,y)
! which interpolates a set of data values and partial
! derivatives at the vertices.  F has continuous first
! derivatives over the mesh and extends beyond the mesh
! boundary allowing extrapolation.  Interpolation is exact
! for quadratic data.  The value of F at (px,py) is
! returned.  intrc1 is part of an interpolation package
! which provides routines to generate, update and plot the
! mesh.
! INPUT PARAMETERS -     n - NUMBER OF NODES IN THE MESH.
!                            n .GE. 3.
!                    px,py - Coordinates of a point at which
!                            F is to be evaluated.
!                      x,y - Vectors of coordinates of the
!                            nodes in the mesh.
!                        z - Vector of data values at the
!                            nodes.
!                     iadj - Set of adjacency lists of nodes
!                            in the mesh.
!                     iend - Pointers to the ends of
!                            adjacency lists in iadj for
!                            each node in the mesh.
!                    iflag - Option indicator
!                            iflag = 0 If intrc1 is to
!                                      provide derivative
!                                      estimates (from
!                                      gradl1).
!                            iflag = 1 If derivatives are
!                                      user provided.
!                     zxzy - 2 By n array whose columns
!                            contain estimated partial der-
!                            ivatives at the nodes (x par-
!                            tials in the first row) if
!                            iflag = 1, not used if iflag
!                            = 0.
!                      ist - Index of the starting node in
!                            the search for a triangle con-
!                            TAINING (px,py).  1 .LE. ist
!                            .LE. n.  the output value of
!                            ist from a previous call may
!                            be a good choice.
! iadj and iend may be created by trmesh and derivative
!   estimates may be computed by gradl1 or gradg.
! Input parameters other than ist are not altered by this
!   routine.
! Output parameters - ist - Index of one of the vertices of
!                           the triangle containing (px,py)
!                           unless ier .LT. 0.
!                      pz - Value of F at (px,py), or 0 if
!                           ier .LT. 0.
!                     ier - Error indicator
!                           ier = 0 If no errors were
!                                   encountered.
!                           ier = 1 If no errors were EN-
!                                   countered and extrapola-
!                                   tion was performed.
!                           ier = -1 IF n, iflag, OR ist IS
!                                    out of range.
!                           ier = -2 If the nodes are col-
!                                    linear.
! Modules referenced by intrc1 - trfind, tval,
!             (AND OPTIONALLY)   gradl1, getnp, setrm,
!                                srotg, srot
!***********************************************************
! Local parameters -
! nn =                      Local copy of n
! i1,i2,i3 =                Vertices determined by trfind
! ierr =                    Error flag for calls to gradl1
!                             AND tval
! n1,n2 =                   Endpoints of the closest bound-
!                             ary edge to P when P is out-
!                             side of the mesh boundary
! indx =                    iadj INDEX OF n1 AS A NEIGHBOR
!                             OF n2
! xp,yp =                   Local copies of the coordinates
!                             OF P=(px,py)
! zx1,zy1,zx2,zy2,zx3,zy3 = x and y derivatives at the
!                             vertices of a triangle T which
!                             contains P or at n1 and n2
! x1,y1,x2,y2,x3,Y3 =       x,y coordinates of the vertices
!                             of T or of n1 and n2
! Z1,Z2,Z3 =                Data values at the vertices of T
! DUM =                     Dummy variable for call to tval
! DP =                      Inner product of n1-n2 and P-n2
! U,V =                     x,y coordinates of the vector
!                             n2-n1
! XQ,YQ =                   x,y coordinates of the closest
!                             boundary point to P when P is
!                             outside of the mesh boundary
! R1,R2 =                   Barycentric coordinates of Q
!                             with respect to the line SEG-
!                             MENT n2-n1 CONTAINING Q
! A1,A2,B1,B2,C1,C2 =       Cardinal functions for EVALUAT-
!                             ing the interpolatory surface
!                             AT Q
! F1,F2 =                   Cubic factors used to compute
!                             the cardinal functions
nn = n
pz = 0.
if (nn < 3  .or.  iflag < 0  .or.  iflag > 1 &
   & .or.  ist < 1  .or.  ist > nn) go to 11
xp = px
yp = py
! Find a triangle containing P if P is within the mesh
!   boundary
call trfind(ist,xp,yp,x,y,iadj,iend, i1,i2,i3)
if (i1 == 0) go to 12
ist = i1
if (i3 == 0) go to 3
if (iflag /= 1) go to 1
! Derivatives are user provided
zx1 = zxzy(1,i1)
zx2 = zxzy(1,i2)
zx3 = zxzy(1,i3)
zy1 = zxzy(2,i1)
zy2 = zxzy(2,i2)
zy3 = zxzy(2,i3)
go to 2
! Compute derivative estimates at the vertices
1 call gradl1(nn,i1,x,y,z,iadj,iend, zx1,zy1,ierr)
call gradl1(nn,i2,x,y,z,iadj,iend, zx2,zy2,ierr)
call gradl1(nn,i3,x,y,z,iadj,iend, zx3,zy3,ierr)
! Set local parameters for call to tval
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
   & zx3,zy1,zy2,zy3,0, pz,dum,dum,ierr)
if (ierr /= 0) go to 12
ier = 0
return
! P is outside of the mesh boundary.  Extrapolate to P by
!   passing a linear function of one variable THROUGH the
!   value and directional derivative (in the direction
!   P-Q) of the interpolatory surface (tval) at Q where
!   Q is the closest boundary point to P.
! Determine Q by traversing the boundary starting from
!   the rightmost visible node i1.
3 n2 = i1
! Set n1 to the last nonzero neighbor of n2 and compute DP
4 indx = iend(n2) - 1
n1 = iadj(indx)
x1 = x(n1)
y1 = y(n1)
x2 = x(n2)
y2 = y(n2)
dp = (x1 - x2)*(xp - x2) + (y1 - y2)*(yp - y2)
if (dp <= 0.) go to 5
if ((xp - x1)*(x2 - x1) + (yp - y1)*(y2 - y1) > 0.) go to 8
n2 = n1
go to 4
! n2 is the closest boundary point to P.  compute partial
!   derivatives at n2.
5 if (iflag /= 1) go to 6
zx2 = zxzy(1,n2)
zy2 = zxzy(2,n2)
go to 7
6 call gradl1(nn,n2,x,y,z,iadj,iend, zx2,zy2,ierr)
! Compute extrapolated value at P
7 pz = z(n2) + zx2*(xp - x2) + zy2*(yp - y2)
ier = 1
return
! The closest boundary point Q lies on n2-n1.  Compute
!   partials at n1 and n2.
8 if (iflag /= 1) go to 9
zx1 = zxzy(1,n1)
zy1 = zxzy(2,n1)
zx2 = zxzy(1,n2)
zy2 = zxzy(2,n2)
go to 10
9 call gradl1(nn,n1,x,y,z,iadj,iend, zx1,zy1,ierr)
call gradl1(nn,n2,x,y,z,iadj,iend, zx2,zy2,ierr)
! Compute Q, its barycentric coordinates, and the cardinal
!   functions for extrapolation
10 u = x2 - x1
v = y2 - y1
r1 = dp/(u**2 + v**2)
r2 = 1. - r1
xq = r1*x1 + r2*x2
yq = r1*y1 + r2*y2
f1 = r1*r1*r2
f2 = r1*r2*r2
a1 = r1 + (f1 - f2)
a2 = r2 - (f1 - f2)
b1 = u*f1
b2 = -u*f2
c1 = v*f1
c2 = -v*f2
! Compute the value of the interpolatory surface (tval)
!   AT Q
pz = a1*z(n1) + a2*z(n2) + b1*zx1 + b2*zx2 + &
   & c1*zy1 + c2*zy2
! Compute the extrapolated value at P
pz = pz + (r1*zx1 + r2*zx2)*(xp - xq) + &
   & (r1*zy1 + r2*zy2)*(yp - yq)
ier = 1
return
! n, iflag, or ist out of range
11 ier = -1
return
! Nodes are collinear
12 ier = -2
end subroutine intrc1

pure elemental subroutine tval(x,y,x1,x2,x3,y1,y2,y3,z1,z2,z3,zx1, &
   & zx2,zx3,zy1,zy2,zy3,iflag, w,wx,wy, &
   & ier)
implicit none
integer, intent(in) :: iflag
integer, intent(inout) :: ier
real, intent(in) :: x, y, x1, x2, x3, y1, y2, y3, z1, z2, z3, zx1, &
   & zx2, zx3, zy1, zy2, zy3
real, intent(inout) :: w, wx, wy
integer :: i, ip1, ip2, ip3
real :: u(3), v(3), sl(3), area, xp, yp, r(3), rx(3), ry(3), &
   & phi(3), phix(3), phiy(3), rmin, c1, c2, ro(3), rox(3), roy(3), &
   & f(3), g(3), gx(3), gy(3), p(3), px(3), py(3), q(3), qx(3), qy(3), &
   & a(3), ax(3), ay(3), b(3), bx(3), by(3), c(3), cx(3), cy(3)
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given function values and first partial derivatives at
! the three vertices of a triangle, this routine determines
! a function w which agrees with the given data, returning
! the value and (optionally) first partial derivatives of w
! at a point (x,y) in the triangle.  The interpolation
! method is exact for quadratic polynomial data.  The
! triangle is partitioned into three subtriangles with
! equal areas.  w is cubic in each subtriangle and along
! the edges, but has only one continuous derivative across
! edges.  The normal derivative of w varies linearly along
! each outer edge.  The values and partial derivatives of w
! along a triangle edge depend only on the data values at
! the endpoints of the edge.  Thus the method yields C-1
! continuity when used to interpolate over a triangular
! grid.  This algorithm is due to C. L. Lawson.
! INPUT PARAMETERS -   x,y - COORDINATES OF A POINT AT WHICH
!                            w is to be evaluated.
!        x1,x2,x3,y1,y2,y3 - Coordinates of the vertices of
!                            a triangle containing (x,y).
!                 z1,z2,z3 - Function values at the vertices
!                            to be interpolated.
!              zx1,ZX2,ZX3 - x-derivative values at the
!                            vertices.
!              ZY1,ZY2,ZY3 - y-derivative values at the
!                            vertices.
!                    iflag - Option indicator
!                            iflag = 0 If only w is to be
!                                      computed.
!                            iflag = 1 IF w, wx, AND wy ARE
!                                      to be returned.
! Input parameters are not altered by this routine.
! OUTPUT PARAMETERS -   w - ESTIMATED VALUE OF THE INTERP-
!                           olatory function at (x,y) if
!                           ier = 0.  OTHERWISE w = 0.
!                   wx,wy - Partial derivatives of w at
!                           (x,y) if ier = 0 And iflag = 1,
!                           unchanged if iflag .NE. 1, zero
!                           if ier .NE. 0 and iflag = 1.
!                     ier - Error indicator
!                           ier = 0 If no errors were
!                                   encountered.
!                           ier = 1 If the vertices of the
!                                   triangle are collinear.
! Modules referenced by tval - None
! intrinsic function called by tval - AMIN1
!***********************************************************
! Local parameters -
! i =               Do-loop index
! ip1,ip2,ip3 =     Permuted indices for computing RO, ROX,
!                     and roy
! u(K) =            x-component of the vector representing
!                     the side opposite vertex K
! v(K) =            y-component of the vector representing
!                     the side opposite vertex K
! sl(K) =           Square of the length of the side
!                     opposite vertex K
! area =            Twice the area of the triangle
! xp,yp =           x-x1, y-y1
! r(K) =            K-TH BARYCENTRIC COORDINATE
! rx(K),ry(K) =     x,y partial derivatives of r(K)
! PHI(K)            r(K-1)*r(K+1) -- QUADRATIC
! PHIX(K),PHIY(K) = x,y PARTIALS OF PHI(K)
! rmin =            min(r1,r2,r3)
! C1,C2 =           Factors for computing RO
! RO(K) =           Factors for computing G -- cubic
!                     correction terms
! ROX(K),ROY(K) =   x,y PARTIALS OF RO(K)
! F(K) =            Factors for computing G, GX, and GY --
!                     constant
! G(K) =            Factors for computing the cardinal
!                     functions -- cubic
! GX(K),GY(K) =     x,y PARTIALS OF G(K)
! p(k) =            g(k) + phi(k)
! PX(K),PY(K) =     x,y PARTIALS OF P(K)
! q(k) =            g(k) - phi(k)
! QX(K),QY(K) =     x,y PARTIALS OF Q(K)
! A(K) =            Cardinal function whose coefficient is
!                     Z(K)
! AX(K),AY(K) =     x,y PARTIALS OF A(K) -- CARDINAL
!                     functions for wx and wy
! B(K) =            Twice the cardinal function whose
!                     coefficient is ZX(K)
! BX(K),BY(K) =     x,y PARTIALS OF B(K)
! C(K) =            Twice the cardinal function whose
!                     coefficient is ZY(K)
! CX(K),CY(K) =     x,y PARTIALS OF C(K)
u(1) = x3 - x2
u(2) = x1 - x3
u(3) = x2 - x1
v(1) = y3 - y2
v(2) = y1 - y3
v(3) = y2 - y1
do i = 1,3
   sl(i) = u(i)*u(i) + v(i)*v(i)
end do
! area = 3-1 x 3-2
area = u(1)*v(2) - u(2)*v(1)
if (area == 0.) go to 9
! r(1) = (2-3 x 2-(x,y))/area, r(2) = (1-(x,y) x 1-3)/area,
!   r(3) = (1-2 x 1-(x,y))/area
r(1) = (u(1)*(y - y2) - v(1)*(x - x2))/area
xp = x - x1
yp = y - y1
r(2) = (u(2)*yp - v(2)*xp)/area
r(3) = (u(3)*yp - v(3)*xp)/area
ier = 0
phi(1) = r(2)*r(3)
phi(2) = r(3)*r(1)
phi(3) = r(1)*r(2)
rmin = min(r(1),r(2),r(3))
if (rmin /= r(1)) go to 3
ip1 = 1
ip2 = 2
ip3 = 3
go to 5
3 if (rmin /= r(2)) go to 4
ip1 = 2
ip2 = 3
ip3 = 1
go to 5
4 ip1 = 3
ip2 = 1
ip3 = 2
5 c1 = rmin*rmin/2.
c2 = rmin/3.
ro(ip1) = (phi(ip1) + 5.*c1/3.)*r(ip1) - c1
ro(ip2) = c1*(r(ip3) - c2)
ro(ip3) = c1*(r(ip2) - c2)
f(1) = 3.*(sl(2) - sl(3))/sl(1)
f(2) = 3.*(sl(3) - sl(1))/sl(2)
f(3) = 3.*(sl(1) - sl(2))/sl(3)
g(1) = (r(2) - r(3))*phi(1) + f(1)*ro(1) - ro(2) + ro(3)
g(2) = (r(3) - r(1))*phi(2) + f(2)*ro(2) - ro(3) + ro(1)
g(3) = (r(1) - r(2))*phi(3) + f(3)*ro(3) - ro(1) + ro(2)
do i = 1,3
   p(i) = g(i) + phi(i)
   q(i) = g(i) - phi(i)
end do
a(1) = r(1) + g(3) - g(2)
a(2) = r(2) + g(1) - g(3)
a(3) = r(3) + g(2) - g(1)
b(1) = u(3)*p(3) + u(2)*q(2)
b(2) = u(1)*p(1) + u(3)*q(3)
b(3) = u(2)*p(2) + u(1)*q(1)
c(1) = v(3)*p(3) + v(2)*q(2)
c(2) = v(1)*p(1) + v(3)*q(3)
c(3) = v(2)*p(2) + v(1)*q(1)
! w is a linear combination of the cardinal functions
w = a(1)*z1 + a(2)*z2 + a(3)*z3 + (b(1)*zx1 + b(2)*zx2 &
   & + b(3)*zx3 + c(1)*zy1 + c(2)*zy2 + c(3)*zy3)/2.
if (iflag /= 1) return
! Compute wx and wy
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
rox(ip1) = rx(ip1)*(phi(ip1) + 5.*c1) + &
   & r(ip1)*(phix(ip1) - rx(ip1))
roy(ip1) = ry(ip1)*(phi(ip1) + 5.*c1) + &
   & r(ip1)*(phiy(ip1) - ry(ip1))
rox(ip2) = rx(ip1)*(phi(ip2) - c1) + c1*rx(ip3)
roy(ip2) = ry(ip1)*(phi(ip2) - c1) + c1*ry(ip3)
rox(ip3) = rx(ip1)*(phi(ip3) - c1) + c1*rx(ip2)
roy(ip3) = ry(ip1)*(phi(ip3) - c1) + c1*ry(ip2)
gx(1) = (rx(2) - rx(3))*phi(1) + (r(2) - r(3))*phix(1) &
   & + f(1)*rox(1) - rox(2) + rox(3)
gy(1) = (ry(2) - ry(3))*phi(1) + (r(2) - r(3))*phiy(1) &
   & + f(1)*roy(1) - roy(2) + roy(3)
gx(2) = (rx(3) - rx(1))*phi(2) + (r(3) - r(1))*phix(2) &
   & + f(2)*rox(2) - rox(3) + rox(1)
gy(2) = (ry(3) - ry(1))*phi(2) + (r(3) - r(1))*phiy(2) &
   & + f(2)*roy(2) - roy(3) + roy(1)
gx(3) = (rx(1) - rx(2))*phi(3) + (r(1) - r(2))*phix(3) &
   & + f(3)*rox(3) - rox(1) + rox(2)
gy(3) = (ry(1) - ry(2))*phi(3) + (r(1) - r(2))*phiy(3) &
   & + f(3)*roy(3) - roy(1) + roy(2)
do i = 1,3
   px(i) = gx(i) + phix(i)
   py(i) = gy(i) + phiy(i)
   qx(i) = gx(i) - phix(i)
   qy(i) = gy(i) - phiy(i)
end do
ax(1) = rx(1) + gx(3) - gx(2)
ay(1) = ry(1) + gy(3) - gy(2)
ax(2) = rx(2) + gx(1) - gx(3)
ay(2) = ry(2) + gy(1) - gy(3)
ax(3) = rx(3) + gx(2) - gx(1)
ay(3) = ry(3) + gy(2) - gy(1)
bx(1) = u(3)*px(3) + u(2)*qx(2)
by(1) = u(3)*py(3) + u(2)*qy(2)
bx(2) = u(1)*px(1) + u(3)*qx(3)
by(2) = u(1)*py(1) + u(3)*qy(3)
bx(3) = u(2)*px(2) + u(1)*qx(1)
by(3) = u(2)*py(2) + u(1)*qy(1)
cx(1) = v(3)*px(3) + v(2)*qx(2)
cy(1) = v(3)*py(3) + v(2)*qy(2)
cx(2) = v(1)*px(1) + v(3)*qx(3)
cy(2) = v(1)*py(1) + v(3)*qy(3)
cx(3) = v(2)*px(2) + v(1)*qx(1)
cy(3) = v(2)*py(2) + v(1)*qy(1)
! wx and wy are linear combinations of the cardinal
!   functions
wx = ax(1)*z1 + ax(2)*z2 + ax(3)*z3 + (bx(1)*zx1 + &
   & bx(2)*zx2 + bx(3)*zx3 + cx(1)*zy1 + cx(2)*zy2 + &
   & cx(3)*zy3)/2.
wy = ay(1)*z1 + ay(2)*z2 + ay(3)*z3 + (by(1)*zx1 + &
   & by(2)*zx2 + by(3)*zx3 + cy(1)*zy1 + cy(2)*zy2 + &
   & cy(3)*zy3)/2.
return
! Vertices are collinear
9 ier = 1
w = 0.
if (iflag /= 1) return
wx = 0.
wy = 0.
end subroutine tval

subroutine mfit(dimen,fitdeg,nfpols,nfpts, &
   & fitcds,ncrows,fitvls,wts, &
   & resids,error,fitiwk,fitdwk, &
   & fiwkln,fdwkln,ireqd,dreqd)
implicit none
integer, intent(inout) :: nfpols, fitdeg
integer, intent(in) :: nfpts, dimen, fiwkln, fdwkln
integer, intent(inout) :: error, ireqd, dreqd
integer, intent(in) :: ncrows
integer, intent(inout) :: fitiwk(fiwkln)
real, intent(inout) :: fitdwk(fdwkln), fitcds(ncrows,dimen)
real, intent(inout) :: fitvls(nfpts), resids(nfpts)
real, intent(in) :: wts(nfpts)
integer :: indstt, p, dimp1, newstt, maxstt, alfstt, psistt, cstt, ssqstt, psiwid, alfl
real :: scale
!     ***************
!     Purpose
!     -------
!     This subroutine constructs a least-squares  multinomial  fit  to
!     given data using a basis of orthogonal multinomials.
!     The data for the fit is given in the arrays fitcds, fitvls, and
!     wts. fitcds is a matrix, each row of which contains an observa-
!     tion point. fitvls is a singly-indexed array, each element of
!     which contains a function VALUE corresponding to an observation
!     point. wts is a singly-indexed array, each element of which is
!     a nonnegative weight for the corresponding observation.
!     The fit which is produced is a multinomial expressed in the form
!      C  psi  (X ,...,X     ) +...+ C       psi       (X ,...,X     )
!       1    1   1      dimen         nfpols    nfpols   1      dimen
!     where the value of  nfpols  will be as given (if  fitdeg .LT. 0)
!     or  as  computed  by  mfit  to give a full-degree fit (in case
!     fitdeg  is specified .GE. 0).  The elements
!         psi  (X ,...,X     )
!            K   1      dimen
!     form a basis for the multinomials which is orthogonal with
!     respect to the weights and observation points.
!     The extent of the fit can be specified in one of two ways.
!         If the parameter fitdeg is set .GE. 0, then a complete basis
!         for the multinomials of degree =  fitdeg  will be used.  (An
!         error will be  flagged  if  this  will  require  more  basis
!         multinomials  than  the  number  of  data  points which were
!         given.)
!         if the parameter  fitdeg  is .LT.  0, then  nfpols  will  be
!         taken as the count of the number of basis multinomials to be
!         used for a partial-degree fit.  (An error will be flagged if
!         nfpols  .LT. 0.)
!     variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      fitdeg  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if .LT. 0.
!         If fitdeg .GE. 0 then  fitdeg  is  checked  against  nfpts .
!         The value of  fitdeg  will be reduced if there is a basis of
!         multinomials, all of  degree  .LE. fitdeg ,  of  cardinality
!         nfpts .  See  error  below.
!      nfpols  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if  fitdeg  .GE. 0.
!         If  fitdeg .LT. 0 then the value of nfpols will be taken  as
!         the size of the basis of multinomials to be used in the fit.
!         nfpols  MUST SATISFY  nfpols  .LT. nfpts  AND nfpols .GE. 1
!         see  error  below.
!      nfpts  --- (INTEGER) -- (passed)
!         the number of data points to be used in the fit.
!         nfpts  must be .GE. 1.  See  error  below.
!      fitcds  -- (real 2-subscript array) -- (passed)
!         fitcds (p,K) is the value of the K-TH variable at the  p-TH
!         data point.
!      ncrows  -- (INTEGER) -- (passed)
!         THE ROW DIMENSION  DECLARED  FOR   fitcds   IN  THE  CALLING
!         program.
!      fitvls  -- (real 1-subscript array) -- (passed)
!         fitvls (p) is the observed function VALUE of the p-TH  data
!         point.
!      wts  ----- (real 1-subscript array) -- (passed)
!         wts (p) is the weight attached to the p-TH data point.
!      resids  -- (real 1-subscript array) -- (returned)
!         resids (p) is the difference between the fitted function at
!         point p and  fitvls (p).
!      error  -- (INTEGER) -- (returned)
!       0 the desired least square multinomial fit was obtained.
!      -1 Only the first nfpols basis polynomials were obtained.
!         fitdeg is the degree of the fit.
!       1 If  fitdeg  .GE. 0 but there is an interpolating multinomial
!         of smaller degree or if fitdeg .LT. 0 and nfpols .GT. nfpts.
!       2 IF  fitdeg  .LT. 0 AND  nfpols  .LE. 0.
!       3 IF  nfpts  .LT. 1 AND/OR  dimen  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         the value returned in  ireqd , and set  DWKLEN  to the value
!         returned in  dreqd  to resolve this problem.)
!      fitiwk  -- (integer, 1-subscript array) -- (returned)
!         an integer work array of length  fiwkln .  Upon return  from
!         mfit, fitiwk contains dimension and array LENGTH information.
!      fitdwk  -- (real 1-subscript array) -- (returned)
!         a real array of length  fdwkln  containing the coefficients
!         needed for computing the multinomial fit at a point.
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitdwk .
!      ireqd  -- (INTEGER) -- (returned)
!         the length which the array  fitiwk  really needs to be.
!      dreqd  -- (INTEGER) -- (returned)
!         the length which the array  fitdwk  really needs to be.
!     Note. The 20 loop depends on the scaling scheme being used. The
!     residual scaling must be consistent with that defined by scalpm
!     AND scaldn.
!     mfit  calls  allot  and  gnrtp.
!     ****************
dimp1 = dimen + 1
!     ***************
call allot(fitdeg,nfpols,nfpts,dimen,fitiwk,fiwkln,ireqd,dreqd, &
   & error)
if (error >= 2) return
if (fdwkln >= dreqd) go to 10
error = 4
return
10 continue
psiwid = fitiwk(3)
alfl = fitiwk(4)
indstt = 1
newstt = 4 * nfpols + indstt
maxstt = 1
alfstt = maxstt + dimp1
cstt = alfstt + alfl
ssqstt = cstt + nfpols
psistt = ssqstt + nfpols
!     ***************
call gnrtp(fitdeg,fitdwk(alfstt), &
   & fitdwk(psistt),fitiwk(indstt), &
   & fitiwk(newstt),fitdwk(ssqstt),fitcds, &
   & ncrows,nfpols,dimen,nfpts,fitvls,resids, &
   & fitdwk(cstt),psiwid,wts,alfl,dimp1, &
   & fitdwk(maxstt),error)
!     ***************
!     Store the number of basis polynomials actually computed
!     by the modified routine incdg called by gnrtp.
!     ***************
fitiwk(1) = nfpols
!     ***************
!     Unscale the residuals for the benefit of the user.
!     ***************
scale = fitdwk(dimen + 1)
do p = 1,nfpts
   resids(p) = resids(p) * scale
end do
end subroutine mfit

pure subroutine allot(degree,npolys,npts,dimen,iwork,iwklen, &
   & ireqd,dreqd,error)
implicit none
integer, intent(inout) :: ireqd, dreqd
integer, intent(inout) :: error, npolys, degree
integer, intent(in) :: dimen, npts
integer, intent(in) :: iwklen
integer, intent(inout) :: iwork(iwklen)
integer :: alfl, newstt, psiwid, kmxbas, startj, kjp1d2, index, nplyt4
interface
   pure elemental subroutine basiz(degree,npts,dimen,npolys, &
      & error)
      implicit none
      integer, intent(inout) :: degree
      integer, intent(in) :: npts
      integer, intent(in) :: dimen
      integer, intent(inout) :: npolys
      integer, intent(out) :: error
   end subroutine basiz
   pure subroutine mtable(degree,dimen,npolys,indexs,newkj, &
      & alflp1)
      implicit none
      integer, intent(in) :: npolys
      integer, intent(in) :: dimen
      integer, intent(in) :: degree
      integer, intent(inout) :: indexs(4,npolys)
      integer, intent(inout) :: newkj(dimen,degree)
      integer, intent(out) :: alflp1
   end subroutine mtable
end interface
!     ***************
!     Purpose
!     -------
!      Allot  checks for sufficiency the declared  dimensions  of  the
!     work  arrays  used by the subroutine  mfit .  Various sizes of
!     sub-arrays are computed and reported.
!     This routine is called by  mfit .  It is not  called  directly
!     by the user.
!     THIS ROUTINE CALLS   basiz   AND   mtable   FOR  THE  SUBSTANTIVE
!     computations.
!     Variables
!     ---------
!      degree  - (PASSED/RETURNED)
!         ignored if .LT. 0.
!         If  degree  .GE. 0 then  degree is checked  against   npts .
!         The value of  degree  will be reduced if there is a basis of
!         multinomials, all of  degree .LE.  degree ,  of  cardinality
!          npts
!      npolys  - (PASSED/RETURNED)
!         ignored if  degree  .GE. 0.
!         If degree .LT. 0 then the value of npolys will be taken  as
!         the size of the basis of multinomials to be used in the fit.
!         npolys  MUST SATISFY npolys .LT.  npts  AND  npolys  .GE. 1
!      npts  --- (passed)
!         the number of data points to be used in the fit.
!          npts  MUST BE .GE. 1.
!      dimen  -- (passed)
!         the number of variables.
!      iwork  -- (returned)
!         an integer work array of length at least
!            if  degree  .GE. 0 then
!               4*binomial( dimen + degree , dimen )
!                  +( dimen )*( DEGREE )
!            ELSE
!               4*binomial( dimen +D,D)+( dimen )*D
!         where D is the minimum cardinality  of  a  basis  of  degree
!          degree  such that
!            BINOMIAL( dimen +abs( degree ), dimen ) .GE.  npolys
!      iwklen  - (passed)
!         the length of  iwork
!      ireqd  -- (returned)
!         THE SIZE OF THE INTEGER WORK ARRAY REQUIRED BY  mfit   FOR
!         the fit specified by the 4 input parameters.
!      dreqd  -- (returned)
!         the size of the double  precision  work  array  required  by
!          mfit  for the fit specified by the 4 input parameters.
!      error  -- (returned)
!       0 IF  npolys ,  dimen ,   DEGREE ,   npts   AND   iwklen   ARE
!         valid and consistent with each other.
!       1 If  degree  .GE. 0 but there is an interpolating multinomial
!         of smaller degree or if  degree .LT. 0 and  npolys .GT. npts
!       2 if  degree  .LT. 0 and  npolys  .LE. 0
!       3 IF  npts  .LT. 1 AND/OR  dimen  .LT. 1
!       4 if  iwklen  is too small (set  iwklen  to the value returned
!         in  ireqd  to resolve this problem)
!     NOTE THAT  DEGREE ,  npolys ,  psiwid  AND  alfl   ARE  RETURNED
!     in  iwork (1-4), respectively.
!     Date last modified
!     ---- ---- --------
!     December 10, 1984
!     ****************
!     ***************
!     basiz  computes the size of the basis (and auxiliary sizes)
!     based primarily upon the degree, number of  fitting points,
!     and the dimension.
!     ***************
call basiz(degree,npts,dimen,npolys,error)
if (error >= 2) return
ireqd = 4 * npolys + degree * dimen
if (iwklen >= ireqd) go to 5
error = 4
return
5 newstt = 4 * npolys + 1
!     ***************
!     Set up useful indexing arrays
!          iwork(1) ,..., iwork(newstt-1)
!     and
!          iwork(newstt ,..., iwork(newstt+dimen*degree)
!     ***************
call mtable(degree,dimen,npolys,iwork,iwork(newstt),alfl)
iwork(1) = degree
iwork(2) = npolys
!     ***************
!     Force  alfl  to be at least 1 so that dimension statements
!     using  alfl  do not bomb.
!     ***************
if (alfl > 1) alfl = alfl - 1
iwork(4) = alfl
!     ***************
!     The following is a section of code for setting up the
!     storage  management of the  psi  array.  There  is  A
!     complicated dovetailing formula used to pack information
!     into  psi  without leaving gaps.
!     ARRAY          LENGTH
!     -----          ------
!      MAXABS         dimen  + 1
!      ALPHA          alfl
!      C              npolys
!      SUMSQS         npolys
!     the number of columns in  psi ,  psiwid , is determined by
!     psiwid  =  npolys  + 1 - (the smallest M such that alpha(J,M)
!                                   is nonzero and J .GE. npolys)
!     this insures that if the user extends the basis, all the  psi
!     required will certainly be stored
!     IF degree( npolys ) .LE. 2 THEN                      (CASE 1)
!       psiwid  =  npolys
!     ELSE
!       IF K =  dimen  THEN                                (CASE 2)
!         psiwid  =  npolys
!                    -  NEWKJ( 1 , degree(npolys)-1 )  + 1
!       ELSE
!            psiwid  =  npolys
!                      + 1
!                      - (
!                         The smaller of
!                           NEWKJ(K+1,degree(npolys)-2)    (CASE 3)
!                         and
!                           INDEXS(3,npolys)               (CASE 4)
!                        )
if (degree > 2) go to 10
!     ***************
!     Case 1
!     ***************
psiwid = npolys
go to 40
10 nplyt4 = 4 * npolys
!     ***************
!     kmxbas  IS K
!                 npolys
!     ***************
kmxbas = iwork(nplyt4 - 2)
if (kmxbas /= dimen) go to 20
!     ***************
!     Case 2
!     ***************
psiwid = npolys - iwork(4 * npolys - 1)
go to 40
!     ***************
!     index =  newkj( k      + 1 , degree(npolys-2) )
!                      npolys
!     ***************
20 index = nplyt4 + (degree - 3) * dimen + kmxbas + 1
kjp1d2 = iwork(index)
!     ***************
!     startj  =  indexs(3,npolys)
!     ***************
startj = iwork(nplyt4 - 1)
if (startj > kjp1d2) go to 30
!     ***************
!     Case 4
!     ***************
psiwid = npolys - startj + 1
go to 40
!     ***************
!     Case 3
!     ***************
30 psiwid = npolys - kjp1d2 + 1
40 iwork(3) = psiwid
dreqd = 2 * npolys + dimen + 1 + npts * psiwid + alfl
end subroutine allot

pure elemental subroutine basiz(degree,npts,dimen,npolys,error)
implicit none
integer, intent(inout) :: degree
integer, intent(in) :: npts, dimen
integer, intent(inout) :: npolys
integer, intent(out) :: error
integer :: top, bot, i, rowlen
!     ***************
!     Purpose
!     -------
!     If  degree  .GE. 0 then
!       find the size of a basis required either to
!       1) approximate the data with a polynomial of degree
!          given by the parameter  degree
!       or to
!       2) span the space of polynomials of degree .LE. the
!          smallest degree of polynomial which interpolates the
!          data.
!       In case 1  error  = 0.
!       In case 2  error  = 1.
!     ELSE
!       IF  npolys  .GE. 1 THEN
!          IF npolys .GT. npts THEN
!             set  npolys  =  npts , find the smallest degree of A
!             polynomial  which  interpolates  the  data,  and set
!              error  = 1.
!          ELSE
!             find the largest degree  degree  of a polynomial  in
!             a  basis of  npolys  polynomials generated according
!             to our ordering and set  error  = 0.
!       ELSE
!           error  = 2
!     this subroutine is called by  allot .  It is not  called  by
!     the user directly.
!     Date last modified
!     ---- ---- --------
!     October 16, 1984
!     ****************
error = 0
if (npts >= 1 .and. dimen >= 1) go to 10
error = 3
return
10 continue
if (degree < 0) go to 30
rowlen = 1
npolys = 1
top = dimen - 1
bot = 0
if (degree < 1) go to 30
do i = 1,degree
   top = top + 1
   bot = bot + 1
   rowlen = (rowlen*top)/bot
   npolys = npolys + rowlen
end do
30 continue
if (npolys >= 1) go to 40
error = 2
return
40 continue
if (npolys < npts) go to 50
npolys = npts
error = 1
50 continue
rowlen = 1
i = 1
degree = 0
top = dimen - 1
bot = 0
60 continue
if (i >= npolys) go to 70
top = top + 1
bot = bot + 1
rowlen = (rowlen*top)/bot
i = i + rowlen
degree = degree + 1
if (i < npolys) go to 60
70 continue
end subroutine basiz

pure subroutine mtable(degree,dimen,npolys,indexs,newkj,alflp1)
implicit none
integer, intent(in) :: npolys, dimen, degree
integer, intent(out) :: alflp1
integer, intent(inout) :: indexs(4,npolys), newkj(dimen,degree)
integer :: j, kj, curdeg, jprime, nwithk, i, curm1, ralen, dimm1, dimm2, dimp1
!     ***************
!     Purpose
!     -------
!     Tabulate  JP  and  kj  for each  j
!     variables
!     ---------
!      alflp1  -- (INTEGER) -- (passed)
!         the length required for array  ALPHA , plus one
!      degree  -- (INTEGER) -- (passed)
!         the degree of the polynomial to be fitted
!      dimen  -- (INTEGER) -- (passed)
!         number of independent variables
!      indexs  -- (integer, 2-subscript array) -- (returned)
!          indexs (1, j )   IS    JP ,    indexs (2, j )   IS     kj ,
!          indexs (3, j )  is the first nonzero recurrence coefficient
!         in  alpha  and  indexs (4, j ) is its location in  alpha .
!      newkj  -- (integer, 2-subscript array) -- (returned)
!          newkj ( K , D ) IS THE FIRST MONOMIAL OF DEGREE  D   HAVING
!          kj = k .
!      npolys  -- (INTEGER) -- (passed)
!         number  of  monomials  of  degree  .LE.  order  in   dimen
!         independent variables.
!     This subprogram can be coded (excluding the part for calculating
!      indexs (3, j )  AND   indexs (4, j )) MENTALLY MORE EFFICIENTLY
!     but computationally less efficiently as
!         j = 2
!         do 5 kj = 1,dimen
!           newkj(kj,1) = kj + 1
!           indexs(1,j) = 1
!           indexs(2,j) = kj
!           j = j + 1
!      5  continue
!         do 10 curdeg = 2,degree
!           do 10 kj = 1,dimen
!             jprime = newkj(kj,curdeg - 1)
!             newkj(kj,curdeg) = j
!             nwithk = comb(dimen + curdeg - kj - 1,curdeg - 1)
!             do 10 i = 1,nwithk
!               indexs(1,j) = jprime
!               indexs(2,j) = kj
!               jprime = jprime + 1
!               j = j + 1
!     10  continue
!     where comb(N,kj) is N-factorial / ((N-kj)-factorial * kj-factorial
!     here we make use of the recurrence relations
!       COMB(dimen+curdeg-2,curdeg-1)
!            (dimen+curdeg-2)*COMB(dimen+curdeg-3,curdeg-2)
!          = ----------------------------------------------
!                              (curdeg-1)
!     and
!       COMB(dimen+curdeg-kj-1,curdeg-1)
!            (dimen-kj+1)*COMB(dimen+curdeg-kj,curdeg-1)
!          = -------------------------------------------
!                         (dimen+curdeg-kj)
!     date last modified
!     ---- ---- --------
!     October 16, 1984
!     ****************
alflp1 = 1
!     ***************
!     Set  indexs (4,1) to 1 so that  ALFL - indexs (4,1)+1 is the
!     number of columns required for  psi  for  npolys =1  ( ALFL
!     is defined in the mainline to be  alflp1 -1 If alflp1 .GT. 1
!     and  alflp1  otherwise.
!     ***************
indexs(4,1) = 1
if (npolys == 1) return
j = 2
do kj = 1,dimen
   newkj(kj,1) = kj + 1
   indexs(1,j) = 1
   indexs(2,j) = kj
   indexs(3,j) = 1
   indexs(4,j) = alflp1
   alflp1 = alflp1 + j - 1
   if (j == npolys) return
   j = j + 1
end do
if (degree == 1) return
ralen = 1
dimm1 = dimen - 1
dimm2 = dimen - 2
dimp1 = dimen + 1
do curdeg = 2,degree
   curm1 = curdeg - 1
   ralen = (ralen * (dimm2 + curdeg)) / curm1
   nwithk = ralen
   kj = 1
20 jprime = newkj(kj,curm1)
   newkj(kj,curdeg) = j
   if (kj == dimen) go to 60
   do i = 1,nwithk
      indexs(1,j) = jprime
      indexs(2,j) = kj
!     ***************
!     CALCULATE  indexs (3, j ),  indexs (4, j )
!     ***************
      if (kj < indexs(2,jprime)) go to 30
      indexs(3,j) = indexs(1,jprime)
      go to 40
30    indexs(3,j) = newkj(1,curdeg - 1)
40    indexs(4,j) = alflp1
      alflp1 = alflp1 + j - indexs(3,j)
      if (j == npolys) return
      jprime = jprime + 1
      j = j + 1
   end do
   kj = kj + 1
   nwithk = (nwithk * (dimp1 - kj)) / (dimen + curdeg - kj)
   go to 20
60 indexs(1,j) = jprime
   indexs(2,j) = dimen
   indexs(3,j) = indexs(1,jprime)
   indexs(4,j) = alflp1
   alflp1 = alflp1 + j - indexs(3,j)
   if (j == npolys) return
   j = j + 1
end do
end subroutine mtable

subroutine gnrtp(degree,alpha,psi,indexs, &
   & newkj,sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,dimp1,maxabs,error)
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: degree
integer, intent(in) :: dimen
integer, intent(inout) :: npolys
integer, intent(in) :: npts
integer, intent(in) :: psiwid, alfl
integer, intent(inout) :: error
integer :: dimp1
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
real, intent(inout) :: psi(npts,psiwid), alpha(alfl), f(npts)
real, intent(inout) :: coord(ncrows,dimen), maxabs(dimp1)
real, intent(in) :: weight(npts)
real, intent(inout) :: z(npts), sumsqs(npolys), c(npolys)
integer :: k, p, sttdeg, onplys
real :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine starts the process off by setting up
!     the first basis element, scaling the  data,  finding  the  first
!     coefficient,  and  initializing  the  work array z.  gnrtp  then
!     calls  incdg  if more than one basis element is required.
!     This subroutine is called by  mfit .  It is not called by  the
!     user.
!     This subroutine calls  scalpm ,  scaldn , and  incdg .
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up the scaling.
!     ***************
do k = 1,dimen
   call scalpm(coord(1,k),npts,maxabs(k))
   call scaldn(coord(1,k),npts,maxabs(k))
end do
call scalpm(f,npts,maxabs(dimp1))
call scaldn(f,npts,maxabs(dimp1))
!     ***************
!      sumsqs (1) = (1,1)
!     c  = (f,1) / (1,1)
!      1
!     ***************
runtot = 0.0
rntot1 = 0.0
do p = 1,npts
   psi(p,1) = 1.0
   rntot1 = rntot1 + weight(p)
   runtot = runtot + f(p) * weight(p)
end do
sumsqs(1) = rntot1
c(1) = runtot / rntot1
!     ***************
!     z = f - c
!              1
!     ***************
do p = 1,npts
   z(p) = f(p) - c(1)
end do
if (npolys == 1) return
sttdeg = 1
onplys = 1
call incdg(degree,alpha,psi,indexs,newkj,sumsqs, &
   & coord,ncrows,npolys,dimen,npts,f,z,c,psiwid, &
   & weight,alfl,onplys,sttdeg,error)
end subroutine gnrtp

pure subroutine incdg(degree,alpha,psi,indexs,newkj, &
   & sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,onplys,sttdeg,error)
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: error
integer, intent(in) :: onplys
integer, intent(inout) :: sttdeg
integer, intent(inout) :: degree, npolys
integer, intent(in) :: npts, dimen, psiwid, alfl
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
real, intent(inout) :: alpha(alfl)
real, intent(in) :: coord(ncrows,dimen)
real, intent(inout) :: psi(npts,psiwid)
real, intent(inout) :: sumsqs(npolys), c(npolys)
real, intent(in) :: f(npts), weight(npts)
real, intent(inout) :: z(npts)
integer :: jprime, p, j, curdeg, kj, kjp, l, jpm1, jm1, m, start, jindex, jpindx, q, j3, j1, j1mj2, j0mj1, j1m1, starta, onpp1, &
   & index1, index2
real :: arc, runtot, rntot1, rntot2
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine continues the process started off by
!      gnrtp .
!     This subroutine is called by  gnrtp  and not by the user.
!     Modified by A.H. Morris (NSWC)
!     ****************
if (onplys >= 1 .and. sttdeg >= 1) go to 10
error = 6
return
10 if (indexs(2,onplys) == dimen) go to 20
curdeg = sttdeg
go to 30
20 curdeg = sttdeg + 1
30 onpp1 = onplys + 1
do j = onpp1,npolys
   jprime = indexs(1,j)
   jindex = j - ((j - 1) / psiwid) * psiwid
   jpindx = jprime - ((jprime - 1) / psiwid) * psiwid
   kj = indexs(2,j)
   start = indexs(3,j)
   m = start
   starta = indexs(4,j) - start
   if (curdeg == 1) go to 100
   kjp = indexs(2,jprime)
   j1 = newkj(kj,curdeg - 1)
!     ***************
!     Calculate those  alpha ( j , m ) that can be calculated from
!     previously calculated alphas.
!     ***************
   if (kj < kjp) go to 50
!     ***************
!     First calculate those between  JPP  and the end of 2 rows back.
!     Calculate  alpha ( j , JPP )
!     ***************
   index1 = indexs(4,j)
   alpha(index1) = sumsqs(jprime) / sumsqs(start)
   m = start + 1
   j3 = newkj(1,curdeg - 1) - 1
   if (m > j3) go to 50
!     ***************
!     curdeg .GT. 2 if control has passed the branches in the 3-RD
!     previous and 8-TH previous statements.
!     ***************
   j1mj2 = j1 - newkj(kj,curdeg - 2)
   do l = m,j3
      q = j1mj2 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between the 2
!     ranges calculated before using
!        alpha ( j , l ) = (X  *  psi  ,psi )  / (psi ,psi )
!                             K      JP    l         l    l
!                              j
!     ***************
   m = j3 + 1
50 if (jprime == j1) go to 100
   if (kj == 1) go to 80
   j1m1 = j1 - 1
   do l = m,j1m1
      runtot = 0.0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between
!      newkj ( kj , curdeg  - 1)  AND
!      JP  - 1.
!     ***************
80 j0mj1 = newkj(kj,curdeg) - j1
   jpm1 = jprime - 1
   do l = j1,jpm1
      q = j0mj1 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
   m = jprime
!     ***************
!     Calculate the remaining  alpha ( j , m ) from
!      alpha ( j , l ) = (X   * psi  ,psi ) / (psi ,psi )
!                          K       JP    l        l    l
!                           j
!     ***************
100 jm1 = j - 1
   do l = m,jm1
      runtot = 0.0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Now calculate the  psi (p,j),  sumsqs (j) and  c (j) using
!                          j-1
!     psi  = X  * psi   -  SUM   alpha(j,l) * psi
!        j    K      JP    l=JPP                 l
!     sumsqs  = (psi ,psi )
!           j       j    j
!     c  = (z,psi )
!      j         j
!     ***************
   jm1 = j - 1
   arc = 0.0
   rntot1 = 0.0
   rntot2 = 0.0
   do p = 1,npts
      runtot = coord(p,kj) * psi(p,jpindx)
      do l = start,jm1
         index1 = starta + l
         index2 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot - alpha(index1) * psi(p,index2)
      end do
      psi(p,jindex) = runtot
      arc = arc + psi(p,index2) * psi(p,jindex) * &
         & weight(p)
      rntot1 = rntot1 + psi(p,jindex) * psi(p,jindex) * &
         & weight(p)
      rntot2 = rntot2 + z(p) * psi(p,jindex) * weight(p)
   end do
   if (arc * arc >= sumsqs(jm1) * rntot1 * 1.e-03) &
      & go to 200
   sumsqs(j) = rntot1
   c(j) = rntot2 / rntot1
!     ***************
!     Calculate the new  z ( p ) and the new  SSRES  using
!     z = z - c  * psi
!              j      j
!     ***************
   do p = 1,npts
      z(p) = z(p) - c(j) * psi(p,jindex)
   end do
   sttdeg = curdeg
   if (kj == dimen) curdeg = curdeg + 1
end do
return
!     ***************
!     The j-TH basis multinomial cannot be computed accurately.
!     Only j - 1 Basis multinomials are generated.
!     ***************
200 error = -1
degree = sttdeg
npolys = jm1
end subroutine incdg

pure subroutine scalpm(coord,npts,maxabs)
implicit none
integer, intent(in) :: npts
real, intent(out) :: maxabs
real, intent(in) :: coord(npts)
integer :: p
real :: a
!     ***************
!     Purpose
!     -------
!     Find scaling parameter(S) for the problem. If the scaling scheme
!     is changed, all four of the following would have to be changed
!     1)  scalpm  - Find the scaling parameters
!     2)  scaldn  - Scale the problem data
!     3)  the scaling of the residuals in  mfit
!     4)  the scaling performed in  meval1
!     this subroutine is called by  gnrtp .  It is not called  by  the
!     user.
!     The scaling which  it  defines  must  be  coordinated  with  the
!     scaling  of residuals which is carried out toward the end of the
!     subroutine  mfit.  The scaling must also be coordinated with the
!     scaling performed in the 10 loop  and  at statements 40 and 50
!     (with the scale factor maxabs(DIMP1)) in  meval1.
!     ****************
maxabs = 0.0
do p = 1,npts
   a = abs(coord(p))
   if (a > maxabs) maxabs = a
end do
end subroutine scalpm

pure subroutine scaldn(coord,npts,maxabs)
implicit none
integer, intent(in) :: npts
real, intent(in) :: maxabs
real, intent(inout) :: coord(npts)
integer :: p
!     ***************
!     Purpose
!     -------
!     Carry out the data-scaling which is defined  by  the  subroutine
!     scalpm .
!     This subroutine is called by  gnrtp .  It is not called  by  the
!     user.
!     The scaling which this routine carries out  must  be  consistent
!     with the scaling in the subroutines mfit and meval1.
!     ****************
if (maxabs == 0.0e+00) return
do p = 1,npts
   coord(p) = coord(p) / maxabs
end do
end subroutine scaldn

pure subroutine meval(dimen,evldeg,nepols,nepts,evlcds,nerows,evlvls, &
   & error,fitiwk,fitdwk,fiwkln,fdwkln,temp)
implicit none
integer, intent(in) :: nerows
integer, intent(in) :: fiwkln, fdwkln
integer, intent(inout) :: nepols
integer, intent(in) :: nepts, dimen
integer, intent(inout) :: error
integer, intent(in) :: evldeg
integer, intent(in) :: fitiwk(fiwkln)
real, intent(inout) :: fitdwk(fdwkln)
real, intent(in) :: evlcds(nerows,dimen)
real, intent(inout) :: evlvls(nepts), temp(dimen)
integer :: maxstt, alfstt, cstt, gbasiz, alfl, dimp1, top, bot, curdeg, psistt
interface
   pure subroutine meval1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
      & indexs,psi,f,alfl,maxabs,x,dimp1)
      implicit none
      integer, intent(in) :: dimp1
      integer, intent(in) :: alfl
      integer, intent(in) :: npolys
      integer, intent(in) :: dimen
      integer, intent(in) :: nepts
      integer, intent(in) :: ncrows
      real, intent(in) :: coord(ncrows,dimen)
      real, intent(in) :: c(npolys)
      real, intent(in) :: alpha(alfl)
      integer, intent(in) :: indexs(4,npolys)
      real, intent(inout) :: psi(npolys)
      real, intent(inout) :: f(nepts)
      real, intent(in) :: maxabs(dimp1)
      real, intent(inout) :: x(dimen)
   end subroutine meval1
end interface
!     ***************
!     Purpose
!     -------
!     This subroutine  evaluates  the  least-squares  multinomial  fit
!     which has been previously produced by  mfit .  Either the full
!     multinomial as produced may be evaluated,  or  only  an  initial
!     segment thereof.  As in the case with  mfit , it is possible
!     (1) to specify multinomials of a full given degree, or
!     (2) to specify  the  number  of  orthogonal  basis  elements  to
!         achieve a partial-degree fit.
!     In case (1), the  desired  degree  is  given  as  the  value  of
!     evldeg   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     value used for  FITDEG  in  mfit ), and the parameter  nepols
!     will  be  set  by  meval  to specify the number of basis elements
!     required. If  evldeg  .LT.  FITDEG   is  given,  then  only  the
!     initial  portion of the fitting multinomial (of degree  evldeg )
!     will be evaluated.
!     In case (2),  evldeg  is to be set negative, in which  case  the
!     VALUE  OF   nepols  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   mfit )  WILL  BE  TAKEN  AS
!     defining  the  initial  portion of the fitting multinomial to be
!     evaluated.
!     IF  nepols  =  NFPOLS  (WITH  evldeg  .LT.  0),  OR   evldeg   =
!     FITDEG  (with   evldeg   .GT.  0),  then  the  full  multinomial
!     generated by  mfit  will be evaluated.
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (collection  of  variable  values)  given as a row of the matrix
!      evlcds .  The  values  produced  from  the  full,  or  partial,
!     multinomial will be placed in the array  evlvls .
!     Variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      evldeg  -- (INTEGER) -- (passed)
!         if  evldeg  .LT. 0, then this parameter will be ignored.
!         If  evldeg  .GE. 0, then the value of  evldeg  must  satisfy
!         evldeg  .LE. (the  degree  of the approximating multinomial
!         generated in  mfit ).  In this case  evldeg  will  specify
!         the degree of the initial portion of the fitting multinomial
!         to be evaluated.
!      nepols  -- (INTEGER) -- (PASSED/RETURNED)
!         if  evldeg  .GE. 0, then this parameter will be ignored.
!         If evldeg .LT. 0, then the partial multinomial involving the
!         FIRST   nepols  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         at the points given by  evlcds .  The resulting values  will
!         be stored in  evlvls .
!         The value of nepols must be .GE. 1 and .LE. (the size of the
!         BASIS  GENERATED  IN   mfit ),  WHICH  WAS RETURNED AS THE
!         value of  NFPOLS .
!         nepols  will be changed if evldeg .GT. 0 to give the size of
!         basis required for the multinomial of degree  evldeg .
!      nepts  -- (INTEGER) -- (passed)
!         the number of evaluation points.
!      evlcds  -- (real 2-subscript array) -- (passed)
!         evlcds (P,K) is the value of the K-TH variable at the  P-TH
!         evaluation point.
!      nerows  -- (INTEGER) -- (passed)
!         the row dimension declared for evlcds in the calling program.
!      evlvls  -- (INTEGER) -- (returned)
!         evlvls (P) is the value of the evaluated multinomial at the
!         P-TH evaluation point.
!      error  -- (INTEGER) -- (returned)
!          0 .........  if no errors
!         -1 .........  IF  nepols  .GT.  NFPOLS  OR  nepols  .LT. 1
!         -2 .........  IF  nepts  .LT. 1 OR  dimen  .LT. 1
!      fitiwk  -- (integer, 1-subscript array) -- (passed)
!         the integer work array of length  fiwkln  that was  used  in
!          mfit .
!      fitdwk  -- (real 2-subscript array) -- (passed)
!         the real work array of length  fdwkln  that was
!         used in  mfit .
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of  fitdwk .
!      temp    -- (REAL 1-SUBSCRIPT ARRAY)
!         a work array of length  dimen  (or longer).
!     The subroutine  meval1  is called to do the actual evaluation.
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up index pointers to the beginning of each row of
!     the mtable -- this sets the beginning point for each
!     full multinomial degree.
!     ***************
if (nepts < 1 .or. dimen < 1) go to 110
if (evldeg < 0) go to 40
if (evldeg == 0) go to 10
go to 20
10 nepols = 1
go to 50
20 top = 1
bot = 1
do curdeg = 1,evldeg
   top = top * (dimen + curdeg)
   bot = bot * curdeg
end do
nepols = top / bot
40 gbasiz = fitiwk(1)
if (nepols > gbasiz .or. nepols < 1) go to 100
50 error = 0
dimp1 = dimen + 1
alfl = fitiwk(4)
maxstt = 1
alfstt = dimp1 + maxstt
cstt = alfstt + alfl
psistt = cstt + fitiwk(2)
!     ***************
!     The actual evaluation is done inside  meval1.
!     ***************
call meval1(evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
   & fitdwk(alfstt),fitiwk,fitdwk(psistt), &
   & evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!     ***************
!     Error return
!     ***************
100 error = -1
return
110 error = -2
end subroutine meval

pure subroutine meval1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
   & indexs,psi,f,alfl,maxabs,x,dimp1)
implicit none
integer, intent(in) :: ncrows
integer, intent(in) :: dimen, nepts, npolys, alfl, dimp1
integer, intent(in) :: indexs(4,npolys)
real, intent(in) :: alpha(alfl), coord(ncrows,dimen)
real, intent(inout) :: psi(npolys)
real, intent(in) :: c(npolys)
real, intent(inout) :: f(nepts)
real, intent(in) :: maxabs(dimp1)
real, intent(inout) :: x(dimen)
integer :: jm1, jprime, m, p, k, i, j, index
real :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     This subroutine performs the main work of evaluating the
!     fitting multinomial (or the initial portion of it  which
!     is requested by the setting of  NEPOLS ,  EVLDEG  in the
!     CALL TO SUBROUTINE  meval .
!     This subroutine is called by  meval .  It is  not  called
!     directly by the user.
!     The body of this subroutine FOLLOWS the explanation
!     given in
!          least squares fitting using
!          orthogonal multinomials
!     by
!          Bartels and Jezioranski
!     in
!          ACM transactions on mathematical software
!     modified by A.H. Morris (NSWC)
!     ****************
if (npolys == 1) go to 50
psi(1) = 1.0
do p = 1,nepts
!     ***************
!     Scale the coordinates of the p-TH point
!     ***************
   do k = 1,dimen
      x(k) = coord(p,k)
      if (maxabs(k) /= 0.0) x(k) = x(k) / maxabs(k)
   end do
!     ***************
!     Use the  basis function coefficients  c  and recurrence
!     coefficients  alpha  to evaluate the fitted multinomial
!     at the p-TH point.
!     ***************
   rntot1 = c(1)
   do j = 2,npolys
      k = indexs(2,j)
      jprime = indexs(1,j)
      runtot = x(k) * psi(jprime)
      i = indexs(3,j)
      jm1 = j - 1
      do m = i,jm1
         index = indexs(4,j) + m - i
         runtot = runtot - psi(m) * alpha(index)
      end do
      psi(j) = runtot
      rntot1 = rntot1 + c(j) * psi(j)
   end do
   f(p) = rntot1 * maxabs(dimp1)
end do
return
!     ***************
!     Compute the degree 0 polynomial
!     ***************
50 runtot = c(1) * maxabs(dimp1)
do p = 1,nepts
   f(p) = runtot
end do
end subroutine meval1

subroutine dmfit(dimen,fitdeg,nfpols,nfpts, &
   & fitcds,ncrows,fitvls,wts, &
   & resids,error,fitiwk,fitdwk, &
   & fiwkln,fdwkln,ireqd,dreqd)
implicit none
integer, intent(inout) :: nfpols, fitdeg
integer, intent(in) :: nfpts, dimen, fiwkln, fdwkln
integer, intent(inout) :: error, ireqd, dreqd
integer, intent(in) :: ncrows
integer, intent(inout) :: fitiwk(fiwkln)
double precision, intent(inout) :: fitdwk(fdwkln), &
   & fitcds(ncrows,dimen)
double precision, intent(inout) :: fitvls(nfpts), resids(nfpts)
double precision, intent(in) :: wts(nfpts)
integer :: indstt, p, dimp1, newstt, maxstt, alfstt, psistt, cstt, ssqstt, psiwid, alfl
double precision :: scale
!     ***************
!     Purpose
!     -------
!     This subroutine constructs a least-squares  multinomial  fit  to
!     given data using a basis of orthogonal multinomials. The computa-
!     tion is performed in double precision.
!     The data for the fit is given in the arrays FITCDS, fitvls, and
!     wts. FITCDS is a matrix, each row of which contains an observa-
!     tion point. fitvls is a singly-indexed array, each element of
!     which contains a function VALUE corresponding to an observation
!     point. wts is a singly-indexed array, each element of which is
!     a nonnegative weight for the corresponding observation.
!     The fit which is produced is a multinomial expressed in the form
!      C  psi  (X ,...,X     ) +...+ C       psi       (X ,...,X     )
!       1    1   1      dimen         nfpols    nfpols   1      dimen
!     where the value of  nfpols  will be as given (if  fitdeg .LT. 0)
!     or  as  computed  by  dmfit  to give a full-degree fit (in case
!     fitdeg  is specified .GE. 0).  The elements
!         psi  (X ,...,X     )
!            K   1      dimen
!     form a basis for the multinomials which is orthogonal with
!     respect to the weights and observation points.
!     The extent of the fit can be specified in one of two ways.
!         If the parameter fitdeg is set .GE. 0, then a complete basis
!         for the multinomials of degree =  fitdeg  will be used.  (An
!         error will be  flagged  if  this  will  require  more  basis
!         multinomials  than  the  number  of  data  points which were
!         given.)
!         if the parameter  fitdeg  is .LT.  0, then  nfpols  will  be
!         taken as the count of the number of basis multinomials to be
!         used for a partial-degree fit.  (An error will be flagged if
!         nfpols  .LT. 0.)
!     variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      fitdeg  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if .LT. 0.
!         If fitdeg .GE. 0 then  fitdeg  is  checked  against  nfpts .
!         The value of  fitdeg  will be reduced if there is a basis of
!         multinomials, all of  degree  .LE. fitdeg ,  of  cardinality
!         nfpts .  See  error  below.
!      nfpols  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if  fitdeg  .GE. 0.
!         If  fitdeg .LT. 0 then the value of nfpols will be taken  as
!         the size of the basis of multinomials to be used in the fit.
!         nfpols  MUST SATISFY  nfpols  .LT. nfpts  AND nfpols .GE. 1
!         see  error  below.
!      nfpts  --- (INTEGER) -- (passed)
!         the number of data points to be used in the fit.
!         nfpts  must be .GE. 1.  See  error  below.
!      FITCDS  -- (double precision 2-subscript array) -- (passed)
!         FITCDS (p,K) is the value of the K-TH variable at the  p-TH
!         data point.
!      ncrows  -- (INTEGER) -- (passed)
!         THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
!         program.
!      fitvls  -- (double precision 1-subscript array) -- (passed)
!         fitvls (p) is the observed function VALUE of the p-TH  data
!         point.
!      wts  ----- (double precision 1-subscript array) -- (passed)
!         wts (p) is the weight attached to the p-TH data point.
!      resids  -- (double precision 1-subscript array) -- (returned)
!         resids (p) is the difference between the fitted function at
!         point p and  fitvls (p).
!      error  -- (INTEGER) -- (returned)
!       0 the desired least square multinomial fit was obtained.
!      -1 Only the first nfpols basis polynomials were obtained.
!         fitdeg is the degree of the fit.
!       1 If  fitdeg  .GE. 0 but there is an interpolating multinomial
!         of smaller degree or if fitdeg .LT. 0 and nfpols .GT. nfpts.
!       2 IF  fitdeg  .LT. 0 AND  nfpols  .LE. 0.
!       3 IF  nfpts  .LT. 1 AND/OR  dimen  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         the value returned in  ireqd , and set  DWKLEN  to the value
!         returned in  dreqd  to resolve this problem.)
!      fitiwk  -- (integer, 1-subscript array) -- (returned)
!         an integer work array of length  fiwkln .  Upon return  from
!         dmfit, fitiwk contains dimension and array LENGTH information.
!      fitdwk  -- (double precision 1-subscript array) -- (returned)
!         an array of length  fdwkln  containing the coefficients
!         needed for computing the multinomial fit at a point.
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitdwk .
!      ireqd  -- (INTEGER) -- (returned)
!         the length which the array  fitiwk  really needs to be.
!      dreqd  -- (INTEGER) -- (returned)
!         the length which the array  fitdwk  really needs to be.
!     Note. The 20 loop depends on the scaling scheme being used. The
!     residual scaling must be consistent with that defined by dscalp
!     AND dscald.
!     dmfit  calls  allot  and  dgnrtp.
!     ****************
dimp1 = dimen + 1
!     ***************
call allot(fitdeg,nfpols,nfpts,dimen,fitiwk,fiwkln,ireqd,dreqd, &
   & error)
if (error >= 2) return
if (fdwkln >= dreqd) go to 10
error = 4
return
10 continue
psiwid = fitiwk(3)
alfl = fitiwk(4)
indstt = 1
newstt = 4 * nfpols + indstt
maxstt = 1
alfstt = maxstt + dimp1
cstt = alfstt + alfl
ssqstt = cstt + nfpols
psistt = ssqstt + nfpols
!     ***************
call dgnrtp(fitdeg,fitdwk(alfstt), &
   & fitdwk(psistt),fitiwk(indstt), &
   & fitiwk(newstt),fitdwk(ssqstt),fitcds, &
   & ncrows,nfpols,dimen,nfpts,fitvls,resids, &
   & fitdwk(cstt),psiwid,wts,alfl,dimp1, &
   & fitdwk(maxstt),error)
!     ***************
!     Store the number of basis polynomials actually computed
!     by the modified routine dincdg called by dgnrtp.
!     ***************
fitiwk(1) = nfpols
!     ***************
!     Unscale the residuals for the benefit of the user.
!     ***************
scale = fitdwk(dimen + 1)
do p = 1,nfpts
   resids(p) = resids(p) * scale
end do
end subroutine dmfit

subroutine dgnrtp(degree,alpha,psi,indexs, &
   & newkj,sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,dimp1,maxabs,error)
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: degree
integer, intent(in) :: dimen
integer, intent(inout) :: npolys
integer, intent(in) :: npts
integer, intent(in) :: psiwid, alfl
integer, intent(inout) :: error
integer :: dimp1
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
double precision, intent(inout) :: psi(npts,psiwid), alpha(alfl), &
   & f(npts)
double precision, intent(inout) :: coord(ncrows,dimen), &
   & maxabs(dimp1)
double precision, intent(in) :: weight(npts)
double precision, intent(inout) :: z(npts), sumsqs(npolys), &
   & c(npolys)
integer :: k, p, sttdeg, onplys
double precision :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine starts the process off by setting up
!     the first basis element, scaling the  data,  finding  the  first
!     coefficient,  and  initializing  the  work array z.  dgnrtp then
!     calls  dincdg  if more than one basis element is required.
!     This subroutine is called by  dmfit .  It is not called by  the
!     user.
!     This subroutine calls  dscalp ,  dscald , and  dincdg .
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up the scaling.
!     ***************
do k = 1,dimen
   call dscalp(coord(1,k),npts,maxabs(k))
   call dscald(coord(1,k),npts,maxabs(k))
end do
call dscalp(f,npts,maxabs(dimp1))
call dscald(f,npts,maxabs(dimp1))
!     ***************
!      sumsqs (1) = (1,1)
!     c  = (f,1) / (1,1)
!      1
!     ***************
runtot = 0.d0
rntot1 = 0.d0
do p = 1,npts
   psi(p,1) = 1.d0
   rntot1 = rntot1 + weight(p)
   runtot = runtot + f(p) * weight(p)
end do
sumsqs(1) = rntot1
c(1) = runtot / rntot1
!     ***************
!     z = f - c
!              1
!     ***************
do p = 1,npts
   z(p) = f(p) - c(1)
end do
if (npolys == 1) return
sttdeg = 1
onplys = 1
call dincdg(degree,alpha,psi,indexs,newkj,sumsqs, &
   & coord,ncrows,npolys,dimen,npts,f,z,c,psiwid, &
   & weight,alfl,onplys,sttdeg,error)
end subroutine dgnrtp

pure subroutine dincdg(degree,alpha,psi,indexs,newkj, &
   & sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,onplys,sttdeg,error)
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: error
integer, intent(in) :: onplys
integer, intent(inout) :: sttdeg
integer, intent(inout) :: degree, npolys
integer, intent(in) :: npts, dimen, psiwid, alfl
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
double precision, intent(inout) :: alpha(alfl)
double precision, intent(in) :: coord(ncrows,dimen)
double precision, intent(inout) :: psi(npts,psiwid)
double precision, intent(inout) :: sumsqs(npolys), c(npolys)
double precision, intent(in) :: f(npts), weight(npts)
double precision, intent(inout) :: z(npts)
integer :: jprime, p, j, curdeg, kj, kjp, l, jpm1, jm1, m, start, jindex, jpindx, q, j3, j1, j1mj2, j0mj1, j1m1, starta, onpp1, &
   & index1, index2
double precision :: arc, runtot, rntot1, rntot2
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine continues the process started off by
!      dgnrtp .
!     This subroutine is called by  dgnrtp  and not by the user.
!     Modified by A.H. Morris (NSWC)
!     ****************
if (onplys >= 1 .and. sttdeg >= 1) go to 10
error = 6
return
10 if (indexs(2,onplys) == dimen) go to 20
curdeg = sttdeg
go to 30
20 curdeg = sttdeg + 1
30 onpp1 = onplys + 1
do j = onpp1,npolys
   jprime = indexs(1,j)
   jindex = j - ((j - 1) / psiwid) * psiwid
   jpindx = jprime - ((jprime - 1) / psiwid) * psiwid
   kj = indexs(2,j)
   start = indexs(3,j)
   m = start
   starta = indexs(4,j) - start
   if (curdeg == 1) go to 100
   kjp = indexs(2,jprime)
   j1 = newkj(kj,curdeg - 1)
!     ***************
!     Calculate those  alpha ( j , m ) that can be calculated from
!     previously calculated alphas.
!     ***************
   if (kj < kjp) go to 50
!     ***************
!     First calculate those between  JPP  and the end of 2 rows back.
!     Calculate  alpha ( j , JPP )
!     ***************
   index1 = indexs(4,j)
   alpha(index1) = sumsqs(jprime) / sumsqs(start)
   m = start + 1
   j3 = newkj(1,curdeg - 1) - 1
   if (m > j3) go to 50
!     ***************
!     curdeg .GT. 2 if control has passed the branches in the 3-RD
!     previous and 8-TH previous statements.
!     ***************
   j1mj2 = j1 - newkj(kj,curdeg - 2)
   do l = m,j3
      q = j1mj2 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between the 2
!     ranges calculated before using
!        alpha ( j , l ) = (X  *  psi  ,psi )  / (psi ,psi )
!                             K      JP    l         l    l
!                              j
!     ***************
   m = j3 + 1
50 if (jprime == j1) go to 100
   if (kj == 1) go to 80
   j1m1 = j1 - 1
   do l = m,j1m1
      runtot = 0.d0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between
!      newkj ( kj , curdeg  - 1)  AND
!      JP  - 1.
!     ***************
80 j0mj1 = newkj(kj,curdeg) - j1
   jpm1 = jprime - 1
   do l = j1,jpm1
      q = j0mj1 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
   m = jprime
!     ***************
!     Calculate the remaining  alpha ( j , m ) from
!      alpha ( j , l ) = (X   * psi  ,psi ) / (psi ,psi )
!                          K       JP    l        l    l
!                           j
!     ***************
100 jm1 = j - 1
   do l = m,jm1
      runtot = 0.d0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Now calculate the  psi (p,j),  sumsqs (j) and  c (j) using
!                          j-1
!     psi  = X  * psi   -  SUM   alpha(j,l) * psi
!        j    K      JP    l=JPP                 l
!     sumsqs  = (psi ,psi )
!           j       j    j
!     c  = (z,psi )
!      j         j
!     ***************
   jm1 = j - 1
   arc = 0.d0
   rntot1 = 0.d0
   rntot2 = 0.d0
   do p = 1,npts
      runtot = coord(p,kj) * psi(p,jpindx)
      do l = start,jm1
         index1 = starta + l
         index2 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot - alpha(index1) * psi(p,index2)
      end do
      psi(p,jindex) = runtot
      arc = arc + psi(p,index2) * psi(p,jindex) * &
         & weight(p)
      rntot1 = rntot1 + psi(p,jindex) * psi(p,jindex) * &
         & weight(p)
      rntot2 = rntot2 + z(p) * psi(p,jindex) * weight(p)
   end do
   if (arc * arc >= sumsqs(jm1) * rntot1 * 1.d-06) &
      & go to 200
   sumsqs(j) = rntot1
   c(j) = rntot2 / rntot1
!     ***************
!     Calculate the new  z ( p ) and the new  SSRES  using
!     z = z - c  * psi
!              j      j
!     ***************
   do p = 1,npts
      z(p) = z(p) - c(j) * psi(p,jindex)
   end do
   sttdeg = curdeg
   if (kj == dimen) curdeg = curdeg + 1
end do
return
!     ***************
!     The j-TH basis multinomial cannot be computed accurately.
!     Only j - 1 Basis multinomials are generated.
!     ***************
200 error = -1
degree = sttdeg
npolys = jm1
end subroutine dincdg

pure subroutine dscalp(coord,npts,maxabs)
implicit none
integer, intent(in) :: npts
double precision, intent(out) :: maxabs
double precision, intent(in) :: coord(npts)
integer :: p
double precision :: a
!     ***************
!     Purpose
!     -------
!     Find scaling parameter(S) for the problem. If the scaling scheme
!     is changed, all four of the following would have to be changed
!     1)  dscalp  - Find the scaling parameters
!     2)  dscald  - Scale the problem data
!     3)  the scaling of the residuals in  dmfit
!     4)  the scaling performed in  dmevl1
!     this subroutine is called by  dgnrtp .  It is not called  by  the
!     user.
!     The scaling which  it  defines  must  be  coordinated  with  the
!     scaling  of residuals which is carried out toward the end of the
!     subroutine  dmfit.  The scaling must also be coordinated with the
!     scaling performed in the 10 loop  and  at statements 40 and 50
!     (with the scale factor maxabs(DIMP1)) in  dmevl1.
!     ****************
maxabs = 0.d0
do p = 1,npts
   a = abs(coord(p))
   if (a > maxabs) maxabs = a
end do
end subroutine dscalp

pure subroutine dscald(coord,npts,maxabs)
implicit none
integer, intent(in) :: npts
double precision, intent(in) :: maxabs
double precision, intent(inout) :: coord(npts)
integer :: p
!     ***************
!     Purpose
!     -------
!     Carry out the data-scaling which is defined  by  the subroutine
!     dscalp .
!     This subroutine is called by  dgnrtp .  It is not called by the
!     user.
!     The scaling which this routine carries out must  be  consistent
!     with the scaling in the subroutines dmfit and dmevl1.
!     ****************
if (maxabs == 0.0d+00) return
do p = 1,npts
   coord(p) = coord(p) / maxabs
end do
end subroutine dscald

pure subroutine dmeval(dimen,evldeg,nepols,nepts,evlcds,nerows,evlvls, &
   & error,fitiwk,fitdwk,fiwkln,fdwkln,temp)
implicit none
integer, intent(in) :: nerows
integer, intent(in) :: fiwkln, fdwkln
integer, intent(inout) :: nepols
integer, intent(in) :: nepts, dimen
integer, intent(inout) :: error
integer, intent(in) :: evldeg
integer, intent(in) :: fitiwk(fiwkln)
double precision, intent(inout) :: fitdwk(fdwkln)
double precision, intent(in) :: evlcds(nerows,dimen)
double precision, intent(inout) :: evlvls(nepts), temp(dimen)
integer :: maxstt, alfstt, cstt, gbasiz, alfl, dimp1, top, bot, curdeg, psistt
interface
   pure subroutine dmevl1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
      & indexs,psi,f,alfl,maxabs,x,dimp1)
      implicit none
      integer, intent(in) :: dimp1
      integer, intent(in) :: alfl
      integer, intent(in) :: npolys
      integer, intent(in) :: dimen
      integer, intent(in) :: nepts
      integer, intent(in) :: ncrows
      double precision, intent(in) :: coord(ncrows,dimen)
      double precision, intent(in) :: c(npolys)
      double precision, intent(in) :: alpha(alfl)
      integer, intent(in) :: indexs(4,npolys)
      double precision, intent(inout) :: psi(npolys)
      double precision, intent(inout) :: f(nepts)
      double precision, intent(in) :: maxabs(dimp1)
      double precision, intent(inout) :: x(dimen)
   end subroutine dmevl1
end interface
!     ***************
!     Purpose
!     -------
!     This subroutine  evaluates  the  least-squares  multinomial  fit
!     which has been previously produced by  dmfit .  The computation
!     is performed in double precision. Either the full
!     multinomial as produced may be evaluated,  or  only  an  initial
!     segment thereof.  As in the case with  dmfit , it is possible
!     (1) to specify multinomials of a full given degree, or
!     (2) to specify  the  number  of  orthogonal  basis  elements  to
!         achieve a partial-degree fit.
!     In case (1), the  desired  degree  is  given  as  the  value  of
!     evldeg   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     value used for  FITDEG  in  dmfit ), and the parameter  nepols
!     will be set  by  dmeval  to specify the number of basis elements
!     required. If  evldeg  .LT.  FITDEG   is  given,  then  only  the
!     initial  portion of the fitting multinomial (of degree  evldeg )
!     will be evaluated.
!     In case (2),  evldeg  is to be set negative, in which  case  the
!     VALUE  OF   nepols  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   dmfit )  WILL  BE  TAKEN  AS
!     defining  the  initial  portion of the fitting multinomial to be
!     evaluated.
!     IF  nepols  =  NFPOLS  (WITH  evldeg  .LT.  0),  OR   evldeg   =
!     FITDEG  (with   evldeg   .GT.  0),  then  the  full  multinomial
!     generated by  dmfit  will be evaluated.
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (collection  of  variable  values)  given as a row of the matrix
!      evlcds .  The  values  produced  from  the  full,  or  partial,
!     multinomial will be placed in the array  evlvls .
!     Variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      evldeg  -- (INTEGER) -- (passed)
!         if  evldeg  .LT. 0, then this parameter will be ignored.
!         If  evldeg  .GE. 0, then the value of  evldeg  must  satisfy
!         evldeg  .LE. (the  degree  of the approximating multinomial
!         generated in  dmfit ).  In this case  evldeg  will  specify
!         the degree of the initial portion of the fitting multinomial
!         to be evaluated.
!      nepols  -- (INTEGER) -- (PASSED/RETURNED)
!         if  evldeg  .GE. 0, then this parameter will be ignored.
!         If evldeg .LT. 0, then the partial multinomial involving the
!         FIRST   nepols  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         at the points given by  evlcds .  The resulting values  will
!         be stored in  evlvls .
!         The value of nepols must be .GE. 1 and .LE. (the size of the
!         BASIS  GENERATED  IN   dmfit ),  WHICH  WAS RETURNED AS THE
!         value of  NFPOLS .
!         nepols  will be changed if evldeg .GT. 0 to give the size of
!         basis required for the multinomial of degree  evldeg .
!      nepts  -- (INTEGER) -- (passed)
!         the number of evaluation points.
!      evlcds  -- (double precision 2-subscript array) -- (passed)
!         evlcds (P,K) is the value of the K-TH variable at the  P-TH
!         evaluation point.
!      nerows  -- (INTEGER) -- (passed)
!         the row dimension declared for evlcds in the calling program.
!      evlvls  -- (INTEGER) -- (returned)
!         evlvls (P) is the value of the evaluated multinomial at the
!         P-TH evaluation point.
!      error  -- (INTEGER) -- (returned)
!          0 .........  if no errors
!         -1 .........  IF  nepols  .GT.  NFPOLS  OR  nepols  .LT. 1
!         -2 .........  IF  nepts  .LT. 1 OR  dimen  .LT. 1
!      fitiwk  -- (integer, 1-subscript array) -- (passed)
!         the integer work array of length  fiwkln  that was  used  in
!          dmfit .
!      fitdwk  -- (double precision 2-subscript array) -- (passed)
!         the real work array of length  fdwkln  that was
!         used in  dmfit .
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of  fitdwk .
!      temp    -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY)
!         a work array of length  dimen  (or longer).
!     The subroutine  dmevl1  is called to do the actual evaluation.
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up index pointers to the beginning of each row of
!     the mtable -- this sets the beginning point for each
!     full multinomial degree.
!     ***************
if (nepts < 1 .or. dimen < 1) go to 110
if (evldeg < 0) go to 40
if (evldeg == 0) go to 10
go to 20
10 nepols = 1
go to 50
20 top = 1
bot = 1
do curdeg = 1,evldeg
   top = top * (dimen + curdeg)
   bot = bot * curdeg
end do
nepols = top / bot
40 gbasiz = fitiwk(1)
if (nepols > gbasiz .or. nepols < 1) go to 100
50 error = 0
dimp1 = dimen + 1
alfl = fitiwk(4)
maxstt = 1
alfstt = dimp1 + maxstt
cstt = alfstt + alfl
psistt = cstt + fitiwk(2)
!     ***************
!     The actual evaluation is done inside  dmevl1.
!     ***************
call dmevl1(evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
   & fitdwk(alfstt),fitiwk,fitdwk(psistt), &
   & evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!     ***************
!     Error return
!     ***************
100 error = -1
return
110 error = -2
end subroutine dmeval

pure subroutine dmevl1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
   & indexs,psi,f,alfl,maxabs,x,dimp1)
implicit none
integer, intent(in) :: ncrows
integer, intent(in) :: dimen, nepts, npolys, alfl, dimp1
integer, intent(in) :: indexs(4,npolys)
double precision, intent(in) :: alpha(alfl), coord(ncrows,dimen)
double precision, intent(inout) :: psi(npolys)
double precision, intent(in) :: c(npolys)
double precision, intent(inout) :: f(nepts)
double precision, intent(in) :: maxabs(dimp1)
double precision, intent(inout) :: x(dimen)
integer :: jm1, jprime, m, p, k, i, j, index
double precision :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     This subroutine performs the main work of evaluating the
!     fitting multinomial (or the initial portion of it  which
!     is requested by the setting of  NEPOLS ,  EVLDEG  in the
!     CALL TO SUBROUTINE  dmeval .
!     This subroutine is called by  dmeval .  It is  not  called
!     directly by the user.
!     The body of this subroutine FOLLOWS the explanation
!     given in
!          least squares fitting using
!          orthogonal multinomials
!     by
!          Bartels and Jezioranski
!     in
!          ACM transactions on mathematical software
!     modified by A.H. Morris (NSWC)
!     ****************
if (npolys == 1) go to 50
psi(1) = 1.d0
do p = 1,nepts
!     ***************
!     Scale the coordinates of the p-TH point
!     ***************
   do k = 1,dimen
      x(k) = coord(p,k)
      if (maxabs(k) /= 0.d0) x(k) = x(k) / maxabs(k)
   end do
!     ***************
!     Use the  basis function coefficients  c  and recurrence
!     coefficients  alpha  to evaluate the fitted multinomial
!     at the p-TH point.
!     ***************
   rntot1 = c(1)
   do j = 2,npolys
      k = indexs(2,j)
      jprime = indexs(1,j)
      runtot = x(k) * psi(jprime)
      i = indexs(3,j)
      jm1 = j - 1
      do m = i,jm1
         index = indexs(4,j) + m - i
         runtot = runtot - psi(m) * alpha(index)
      end do
      psi(j) = runtot
      rntot1 = rntot1 + c(j) * psi(j)
   end do
   f(p) = rntot1 * maxabs(dimp1)
end do
return
!     ***************
!     Compute the degree 0 polynomial
!     ***************
50 runtot = c(1) * maxabs(dimp1)
do p = 1,nepts
   f(p) = runtot
end do
end subroutine dmevl1

real function qsuba(f, a, b, epsil, mcount, relerr, ind)
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: mcount
real, intent(in) :: a, b, epsil
real, intent(inout) :: relerr
real :: f
external f
integer :: icheck, is, k, nf, npts
real :: eps, err, result(8), stack(100), sub1, sub2, sub3, sum, &
   & tol, x
integer, parameter :: ismax = 100
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!                Integration over a finite interval
!                          ----------
!     qsuba computes the integral of f(X) from A to b where the
!     relative error does not exceed epsil.
!     mcount is the maximum number of points at which f(X) may be
!     evaluated.
!     relerr is a variable. When qsuba terminates, if the value
!     of the integral is nonzero then relerr is a crude estimate
!     of the relative error of the value. Otherwise, if qsuba = 0
!     then relerr is an estimate of the absolute error.
!     Ind is a variable. When qsuba terminates, ind has one of the
!     following values ...
!     ind=0   qsuba is satisfied that the integral has been
!             computed to the desired accuracy.
!     ind=1   The integral has been computed, but qsuba is
!             not certain of the accuracy of the result.
!     ind=2   The integrand has been evaluated at mcount
!             points. If more evaluations are needed then
!             qsuba TERMINATES.
!     ind=3   qsuba cannot compute the integral to the desired
!             accuracy. Ind is set to 3 whenever the stack of
!             intervals becomes full (it currently can hold 50
!             intervals). A result is obtained by continuing
!             the integration ignoring convergence failures
!             which cannot be accommodated on the stack.
!     The reliability of the algorithm decreases for large values
!     of epsil. It is recommended that epsil be less than 0.001.
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0.
eps = spmpar(1)
!-----------------------------------------------------------------------
qsuba = 0.0
relerr = 0.0
ind = 0
if (a == b) return
!     Apply quad to the entire interval
sub1 = min(a,b)
sub3 = max(a,b)
tol = max(epsil, 10.0*eps)
call quad(sub1, sub3, result, k, tol, npts, icheck, f)
if (icheck == 0) go to 100
is = 1
!     Subdivide the interval (sub1,sub3) into the subintervals
!     (sub1,sub2) and (sub2,sub3). Call quad for (sub1,sub2).
10 if (npts >= mcount) go to 110
sub2 = 0.5*(sub1 + sub3)
call quad(sub1, sub2, result, k, tol, nf, icheck, f)
npts = npts + nf
err = abs(result(k) - result(k - 1))
sum = qsuba + result(k)
if (icheck == 0 .or. err <= abs(tol*sum)) go to 30
!        Stack the subinterval (sub1,sub2) for further
!        examination if there is sufficient storage.
if (is >= ismax) go to 20
stack(is) = sub1
is = is + 1
stack(is) = sub2
is = is + 1
go to 40
20 ind = 3
!     Update qsuba and check if any significant digits are lost
30 x = qsuba
qsuba = sum
relerr = relerr + err
if (ind /= 0 .or. x*result(k) >= 0.0) go to 40
x = 0.1*min(abs(x),abs(result(k)))
if (abs(qsuba) <= x) ind = 1
!     CALL QUAD FOR THE INTERVAL (sub2,sub3)
40 if (npts >= mcount) go to 110
call quad(sub2, sub3, result, k, tol, nf, icheck, f)
npts = npts + nf
err = abs(result(k) - result(k - 1))
sum = qsuba + result(k)
if (icheck == 0 .or. err <= abs(tol*sum)) go to 50
!        Subdivide the interval (sub2,sub3)
sub1 = sub2
go to 10
!     Update qsuba and check if any significant digits are lost
50 x = qsuba
qsuba = sum
relerr = relerr + err
if (ind /= 0 .or. x*result(k) >= 0.0) go to 60
x = 0.1*min(abs(x),abs(result(k)))
if (abs(qsuba) <= x) ind = 1
!     Subdivide the interval last stacked
60 if (is == 1) go to 120
is = is - 1
sub3 = stack(is)
is = is - 1
sub1 = stack(is)
go to 10
!     Termination when subdivision is not needed
100 qsuba = result(k)
if (a > b) qsuba = -qsuba
relerr = abs(result(k) - result(k - 1))
if (qsuba /= 0.0) relerr = relerr/abs(qsuba)
return
!     Subdivision result
110 ind = 2
120 if (a > b) qsuba = -qsuba
if (qsuba /= 0.0) relerr = relerr/abs(qsuba)
end function qsuba

subroutine quad(a, b, result, k, epsil, npts, icheck, f)
implicit none
integer, intent(out) :: icheck
integer, intent(inout) :: k, npts
real, intent(in) :: a, b, epsil
real, intent(inout) :: result(*)
real :: f
external f
integer :: i, inew, iold, j
real :: acum, diff, funct(127), fzero, sum, x
real, parameter :: p(381) = [0.77459666924148337704e00, 0.55555555555555555556e00, 0.88888888888888888889e00, &
   & 0.26848808986833344073e00, 0.96049126870802028342e00, 0.10465622602646726519e00, 0.43424374934680255800e00, &
   & 0.40139741477596222291e00, 0.45091653865847414235e00, 0.13441525524378422036e00, 0.51603282997079739697e-01, &
   & 0.20062852937698902103e00, 0.99383196321275502221e00, 0.17001719629940260339e-01, 0.88845923287225699889e00, &
   & 0.92927195315124537686e-01, 0.62110294673722640294e00, 0.17151190913639138079e00, 0.22338668642896688163e00, &
   & 0.21915685840158749640e00, 0.22551049979820668739e00, 0.67207754295990703540e-01, 0.25807598096176653565e-01, &
   & 0.10031427861179557877e00, 0.84345657393211062463e-02, 0.46462893261757986541e-01, 0.85755920049990351154e-01, &
   & 0.10957842105592463824e00, 0.99909812496766759766e00, 0.25447807915618744154e-02, 0.98153114955374010687e00, &
   & 0.16446049854387810934e-01, 0.92965485742974005667e00, 0.35957103307129322097e-01, 0.83672593816886873550e00, &
   & 0.56979509494123357412e-01, 0.70249620649152707861e00, 0.76879620499003531043e-01, 0.53131974364437562397e00, &
   & 0.93627109981264473617e-01, 0.33113539325797683309e00, 0.10566989358023480974e00, 0.11248894313318662575e00, &
   & 0.11195687302095345688e00, 0.11275525672076869161e00, 0.33603877148207730542e-01, 0.12903800100351265626e-01, &
   & 0.50157139305899537414e-01, 0.42176304415588548391e-02, 0.23231446639910269443e-01, 0.42877960025007734493e-01, &
   & 0.54789210527962865032e-01, 0.12651565562300680114e-02, 0.82230079572359296693e-02, 0.17978551568128270333e-01, &
   & 0.28489754745833548613e-01, 0.38439810249455532039e-01, 0.46813554990628012403e-01, 0.52834946790116519862e-01, &
   & 0.55978436510476319408e-01, 0.99987288812035761194e00, 0.36322148184553065969e-03, 0.99720625937222195908e00, &
   & 0.25790497946856882724e-02, 0.98868475754742947994e00, 0.61155068221172463397e-02, 0.97218287474858179658e00, &
   & 0.10498246909621321898e-01, 0.94634285837340290515e00, 0.15406750466559497802e-01, 0.91037115695700429250e00, &
   & 0.20594233915912711149e-01, 0.86390793819369047715e00, 0.25869679327214746911e-01, 0.80694053195021761186e00, &
   & 0.31073551111687964880e-01, 0.73975604435269475868e00, 0.36064432780782572640e-01, 0.66290966002478059546e00, &
   & 0.40715510116944318934e-01, 0.57719571005204581484e00, 0.44914531653632197414e-01, 0.48361802694584102756e00, &
   & 0.48564330406673198716e-01, 0.38335932419873034692e00, 0.51583253952048458777e-01, 0.27774982202182431507e00, &
   & 0.53905499335266063927e-01, 0.16823525155220746498e00, 0.55481404356559363988e-01, 0.56344313046592789972e-01, &
   & 0.56277699831254301273e-01, 0.56377628360384717388e-01, 0.16801938574103865271e-01, 0.64519000501757369228e-02, &
   & 0.25078569652949768707e-01, 0.21088152457266328793e-02, 0.11615723319955134727e-01, 0.21438980012503867246e-01, &
   & 0.27394605263981432516e-01, 0.63260731936263354422e-03, 0.41115039786546930472e-02, 0.89892757840641357233e-02, &
   & 0.14244877372916774306e-01, 0.19219905124727766019e-01, 0.23406777495314006201e-01, 0.26417473395058259931e-01, &
   & 0.27989218255238159704e-01, 0.18073956444538835782e-03, 0.12895240826104173921e-02, 0.30577534101755311361e-02, &
   & 0.52491234548088591251e-02, 0.77033752332797418482e-02, 0.10297116957956355524e-01, 0.12934839663607373455e-01, &
   & 0.15536775555843982440e-01, 0.18032216390391286320e-01, 0.20357755058472159467e-01, 0.22457265826816098707e-01, &
   & 0.24282165203336599358e-01, 0.25791626976024229388e-01, 0.26952749667633031963e-01, 0.27740702178279681994e-01, &
   & 0.28138849915627150636e-01, 0.99998243035489159858e00, 0.50536095207862517625e-04, 0.99959879967191068325e00, &
   & 0.37774664632698466027e-03, 0.99831663531840739253e00, 0.93836984854238150079e-03, 0.99572410469840718851e00, &
   & 0.16811428654214699063e-02, 0.99149572117810613240e00, 0.25687649437940203731e-02, 0.98537149959852037111e00, &
   & 0.35728927835172996494e-02, 0.97714151463970571416e00, 0.46710503721143217474e-02, 0.96663785155841656709e00, &
   & 0.58434498758356395076e-02, 0.95373000642576113641e00, 0.70724899954335554680e-02, 0.93832039777959288365e00, &
   & 0.83428387539681577056e-02, 0.92034002547001242073e00, 0.96411777297025366953e-02, 0.89974489977694003664e00, &
   & 0.10955733387837901648e-01, 0.87651341448470526974e00, 0.12275830560082770087e-01, 0.85064449476835027976e00, &
   & 0.13591571009765546790e-01, 0.82215625436498040737e00, 0.14893641664815182035e-01, 0.79108493379984836143e00, &
   & 0.16173218729577719942e-01, 0.75748396638051363793e00, 0.17421930159464173747e-01, 0.72142308537009891548e00, &
   & 0.18631848256138790186e-01, 0.68298743109107922809e00, 0.19795495048097499488e-01, 0.64227664250975951377e00, &
   & 0.20905851445812023852e-01, 0.59940393024224289297e00, 0.21956366305317824939e-01, 0.55449513263193254887e00, &
   & 0.22940964229387748761e-01, 0.50768775753371660215e00, 0.23854052106038540080e-01, 0.45913001198983233287e00, &
   & 0.24690524744487676909e-01, 0.40897982122988867241e00, 0.25445769965464765813e-01, 0.35740383783153215238e00, &
   & 0.26115673376706097680e-01, 0.30457644155671404334e00, 0.26696622927450359906e-01, 0.25067873030348317661e00, &
   & 0.27185513229624791819e-01, 0.19589750271110015392e00, 0.27579749566481873035e-01, 0.14042423315256017459e00, &
   & 0.27877251476613701609e-01, 0.84454040083710883710e-01, 0.28076455793817246607e-01, 0.28184648949745694339e-01, &
   & 0.28176319033016602131e-01, 0.28188814180192358694e-01, 0.84009692870519326354e-02, 0.32259500250878684614e-02, &
   & 0.12539284826474884353e-01, 0.10544076228633167722e-02, 0.58078616599775673635e-02, 0.10719490006251933623e-01, &
   & 0.13697302631990716258e-01, 0.31630366082226447689e-03, 0.20557519893273465236e-02, 0.44946378920320678616e-02, &
   & 0.71224386864583871532e-02, 0.96099525623638830097e-02, 0.11703388747657003101e-01, 0.13208736697529129966e-01, &
   & 0.13994609127619079852e-01, 0.90372734658751149261e-04, 0.64476204130572477933e-03, 0.15288767050877655684e-02, &
   & 0.26245617274044295626e-02, 0.38516876166398709241e-02, 0.51485584789781777618e-02, 0.64674198318036867274e-02, &
   & 0.77683877779219912200e-02, 0.90161081951956431600e-02, 0.10178877529236079733e-01, 0.11228632913408049354e-01, &
   & 0.12141082601668299679e-01, 0.12895813488012114694e-01, 0.13476374833816515982e-01, 0.13870351089139840997e-01, &
   & 0.14069424957813575318e-01, 0.25157870384280661489e-04, 0.18887326450650491366e-03, 0.46918492424785040975e-03, &
   & 0.84057143271072246365e-03, 0.12843824718970101768e-02, 0.17864463917586498247e-02, 0.23355251860571608737e-02, &
   & 0.29217249379178197538e-02, 0.35362449977167777340e-02, 0.41714193769840788528e-02, 0.48205888648512683476e-02, &
   & 0.54778666939189508240e-02, 0.61379152800413850435e-02, 0.67957855048827733948e-02, 0.74468208324075910174e-02, &
   & 0.80866093647888599710e-02, 0.87109650797320868736e-02, 0.93159241280693950932e-02, 0.98977475240487497440e-02, &
   & 0.10452925722906011926e-01, 0.10978183152658912470e-01, 0.11470482114693874380e-01, 0.11927026053019270040e-01, &
   & 0.12345262372243838455e-01, 0.12722884982732382906e-01, 0.13057836688353048840e-01, 0.13348311463725179953e-01, &
   & 0.13592756614812395910e-01, 0.13789874783240936517e-01, 0.13938625738306850804e-01, 0.14038227896908623303e-01, &
   & 0.14088159516508301065e-01, 0.99999759637974846462e00, 0.69379364324108267170e-05, 0.99994399620705437576e00, &
   & 0.53275293669780613125e-04, 0.99976049092443204733e00, 0.13575491094922871973e-03, 0.99938033802502358193e00, &
   & 0.24921240048299729402e-03, 0.99874561446809511470e00, 0.38974528447328229322e-03, 0.99780535449595727456e00, &
   & 0.55429531493037471492e-03, 0.99651414591489027385e00, 0.74028280424450333046e-03, 0.99483150280062100052e00, &
   & 0.94536151685852538246e-03, 0.99272134428278861533e00, 0.11674841174299594077e-02, 0.99015137040077015918e00, &
   & 0.14049079956551446427e-02, 0.98709252795403406719e00, 0.16561127281544526052e-02, 0.98351865757863272876e00, &
   & 0.19197129710138724125e-02, 0.97940628167086268381e00, 0.21944069253638388388e-02, 0.97473445975240266776e00, &
   & 0.24789582266575679307e-02, 0.96948465950245923177e00, 0.27721957645934509940e-02, 0.96364062156981213252e00, &
   & 0.30730184347025783234e-02, 0.95718821610986096274e00, 0.33803979910869203823e-02, 0.95011529752129487656e00, &
   & 0.36933779170256508183e-02, 0.94241156519108305981e00, 0.40110687240750233989e-02, 0.93406843615772578800e00, &
   & 0.43326409680929828545e-02, 0.92507893290707565236e00, 0.46573172997568547773e-02, 0.91543758715576504064e00, &
   & 0.49843645647655386012e-02, 0.90514035881326159519e00, 0.53130866051870565663e-02, 0.89418456833555902286e00, &
   & 0.56428181013844441585e-02, 0.88256884024734190684e00, 0.59729195655081658049e-02, 0.87029305554811390585e00, &
   & 0.63027734490857587172e-02, 0.85735831088623215653e00, 0.66317812429018878941e-02, 0.84376688267270860104e00, &
   & 0.69593614093904229394e-02, 0.82952219463740140018e00, 0.72849479805538070639e-02, 0.81462878765513741344e00, &
   & 0.76079896657190565832e-02, 0.79909229096084140180e00, 0.79279493342948491103e-02, 0.78291939411828301639e00, &
   & 0.82443037630328680306e-02, 0.76611781930376009072e00, 0.85565435613076896192e-02, 0.74869629361693660282e00, &
   & 0.88641732094824942641e-02, 0.73066452124218126133e00, 0.91667111635607884067e-02, 0.71203315536225203459e00, &
   & 0.94636899938300652943e-02, 0.69281376977911470289e00, 0.97546565363174114611e-02, 0.67301883023041847920e00, &
   & 0.10039172044056840798e-01, 0.65266166541001749610e00, 0.10316812330947621682e-01, 0.63175643771119423041e00, &
   & 0.10587167904885197931e-01, 0.61031811371518640016e00, 0.10849844089337314099e-01, 0.58836243444766254143e00, &
   & 0.11104461134006926537e-01, 0.56590588542365442262e00, 0.11350654315980596602e-01, 0.54296566649831149049e00, &
   & 0.11588074033043952568e-01, 0.51955966153745702199e00, 0.11816385890830235763e-01, 0.49570640791876146017e00, &
   & 0.12035270785279562630e-01, 0.47142506587165887693e00, 0.12244424981611985899e-01, 0.44673538766202847374e00, &
   & 0.12443560190714035263e-01, 0.42165768662616330006e00, 0.12632403643542078765e-01, 0.39621280605761593918e00, &
   & 0.12810698163877361967e-01, 0.37042208795007823014e00, 0.12978202239537399286e-01, 0.34430734159943802278e00, &
   & 0.13134690091960152836e-01, 0.31789081206847668318e00, 0.13279951743930530650e-01, 0.29119514851824668196e00, &
   & 0.13413793085110098513e-01, 0.26424337241092676194e00, 0.13536035934956213614e-01, 0.23705884558982972721e00, &
   & 0.13646518102571291428e-01, 0.20966523824318119477e00, 0.13745093443001896632e-01, 0.18208649675925219825e00, &
   & 0.13831631909506428676e-01, 0.15434681148137810869e00, 0.13906019601325461264e-01, 0.12647058437230196685e00, &
   & 0.13968158806516938516e-01, 0.98482396598119202090e-01, 0.14017968039456608810e-01, 0.70406976042855179063e-01, &
   & 0.14055382072649964277e-01, 0.42269164765363603212e-01, 0.14080351962553661325e-01, 0.14093886410782462614e-01, &
   & 0.14092845069160408355e-01, 0.14094407090096179347e-01]
!     --------------------
! This subroutine attempts to calculate the integral of f(x)
! over the interval *a* to *b* with relative error not
! EXCEEDING *epsil*.
! The result is obtained using a sequence of 1,3,7,15,31,63,
! 127, and 255 point interlacing formulae(no integrand
! evaluations are wasted) of respective degree 1,5,11,23,
! 47,95,191 and 383. The formulae are based on the optimal
! extension of the 3-point Gauss formula.  Details of
! the formulae are given in *the optimum addition of points
! to quadrature formulae* by T.N.L. patterson,maths.COMP.
! Vol 22,847-856,1968.
!                     *** INPUT ***
! A       LOWER LIMIT OF INTEGRATION.
! b       UPPER LIMIT OF INTEGRATION.
! epsil   RELATIVE ACCURACY REQUIRED. WHEN THE RELATIVE
!         difference of two successive formulae does not
!         exceed *epsil* the last formula computed is taken
!         as the result.
! f       f(x) IS THE INTEGRAND.
!                     *** OUTPUT ***
! result  this array,which should be declared to have at
!         least 8 elements, holds the results obtained by
!         the 1,3,7, etc., point formulae. The number of
!         formulae computed depents on *epsil*.
! k       result(k) HOLDS THE VALUE OF THE INTEGRAL TO THE
!         specified relative accuracy.
! npts    NUMBER INTEGRAND EVALUATIONS.
! icheck  on exit normally icheck=0. However if convergence
!         to the accuracy requested is not achieved icheck=1
!         on exit.
! Abscissae and weights of quadrature rules are stacked in
! array *p* in the order in which they are needed.
!     --------------------
icheck = 0
! Check for trivial case.
if (a == b) go to 70
! Scale factors.
sum = (b + a)/2.0
diff = (b - a)/2.0
! 1-Point Gauss
fzero = f(sum)
result(1) = 2.0*fzero*diff
i = 0
iold = 0
inew = 1
k = 2
acum = 0.0
go to 30
10 if (k == 8) go to 50
k = k + 1
acum = 0.0
! Contribution from function values already computed.
do j = 1,iold
   i = i + 1
   acum = acum + p(i)*funct(j)
end do
! Contribution from new function values.
30 iold = iold + inew
do j = inew,iold
   i = i + 1
   x = p(i)*diff
   funct(j) = f(sum + x) + f(sum - x)
   i = i + 1
   acum = acum + p(i)*funct(j)
end do
inew = iold + 1
i = i + 1
result(k) = (acum + p(i)*fzero)*diff
! Check for convergence.
if ((abs(result(k) - result(k - 1)) - epsil * abs( &
   & result(k))) <= 0) go to 60
go to 10
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
end subroutine quad

subroutine qags(f, a, b, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
implicit none
real :: f
integer, intent(out) :: ier, last
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
real, intent(in) :: a
real, intent(out) :: abserr
real, intent(in) :: b, epsabs, epsrel
real, intent(out) :: result
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!                 Computation of a definite integral
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
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
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (a,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of
!                    significant elements actually in the work
!                    arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!         Subroutines or functions needed
!              - qagse
!              - qk21f
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - spmpar
!-----------------------------------------------------------------------
!         Check validity of limit and lenw.
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit < 1 .or. lenw < limit*4) return
!         Prepare call for qagse.
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
call qagse(f,a,b,epsabs,epsrel,limit,result,abserr,neval, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last)
end subroutine qags

subroutine qagse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!                 Computation of a definite integral
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upperbound on the number of
!                     subintervals in the partition of (a,b)
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!                         = 1 Maximum number of subdivisions allowed
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
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             iord(1) and elist(1) are set to zero.
!                             alist(1) and blist(1) are set to A and b
!                             respectively.
!            alist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!            blist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!            rlist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     SUBINERVALS
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the error
!                     estimates over the subintervals, such
!                     THAT elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!         subroutines or functions needed
!              - qk21f
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - spmpar
!-----------------------------------------------------------------------
real, intent(in) :: a
real, intent(out) :: abserr
real, intent(inout) :: alist
real, intent(in) :: b
real, intent(inout) :: blist
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
real :: abseps, area, area1, area12, area2, a1, a2, b1, b2, correc, defabs, defab1, defab2, dres, epmach, erlarg, erlast, errbnd, &
   & errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), small, t, uflow
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2
logical :: extrap, noext
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine qelg (rlist2 should be of dimension
!            (LIMEXP+2) at least).
!            List of major variables
!            -----------------------
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least LIMEXP+2
!                       containing the part of the epsilon table
!                       which is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left interval
!           *****2    - Variable for the right interval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered
!                       up to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation
!                       I.E. before subdividing the smallest interval
!                       we try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (true value)
!            machine dependent constants
!            ---------------------------
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!            Check epsabs and epsrel
!            -----------------------
neval = 0
last = 0
result = 0.0
abserr = 0.0
alist(1) = a
blist(1) = b
rlist(1) = 0.0
elist(1) = 0.0
ier = 6
if (epsabs < 0.0 .or. epsrel < 0.0) go to 999
ier = 0
rerr = max(epsrel, 50.0*epmach, 0.5e-14)
!           First approximation to the integral
!           -----------------------------------
ierro = 0
call qk21f(f, a, b, result, abserr, defabs, resabs, &
   & epmach, uflow, id)
if (id /= 0) go to 999
neval = 21
!           Test on accuracy.
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr <= 100.0*epmach*defabs .and. abserr > &
   & errbnd) ier = 2
if (limit == 1) ier = 1
if (ier /= 0) go to 999
!           Initialization
!           --------------
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
if (dres >= (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with the nrmax-TH largest
!           error estimate.
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qk21f(f, a1, b1, area1, error1, resabs, defab1, &
      & epmach, uflow, ier)
   if (ier /= 0) exit
   call qk21f(f, a2, b2, area2, error2, resabs, defab2, &
      & epmach, uflow, ier)
   neval = neval + 42
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1e-04*abs(area12) &
      & .or. erro12 < 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually
!           set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of
!           subintervals equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
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
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum <= errbnd) go to 115
! ***Jump out of do-loop
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro == 3 .or. erlarg <= ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (erlarg) and perform
!           extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg(numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1e-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
! ***Jump out of do-loop
   if (abserr <= ertest) exit
!           Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
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
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.0 .and. area /= 0.0) go to 105
if (abserr > errsum) go to 115
if (area == 0.0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence.
110 if (ksgn == -1 .and. max(abs(result),abs(area)) <= &
   & defabs*0.1e-01) go to 130
if (0.1e-01 > (result/area) .or. (result/area) > 0.1e+03 &
   & .or. errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier > 2) ier = ier - 1
999 return
end subroutine qagse

subroutine qk21f(f, a, b, result, abserr, resabs, resasc, &
   & epmach, uflow, isig)
implicit none
integer, intent(out) :: isig
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
real :: f
external f
integer :: j, jtw, jtwm1
real :: absc, centr, dhlgth, fc, fsum, fval1, fval2, hlgth, resg, resk, reskh, tol, fv1(10), fv2(10)
real, parameter :: xgk(11) = [0.9956571630258081e+00, 0.9739065285171717e+00, 0.9301574913557082e+00, &
   & 0.8650633666889845e+00, 0.7808177265864169e+00, 0.6794095682990244e+00, 0.5627571346686047e+00, 0.4333953941292472e+00, &
   & 0.2943928627014602e+00, 0.1488743389816312e+00, 0.0000000000000000e+00]
real, parameter :: wgk(11) = [0.1169463886737187e-01, 0.3255816230796473e-01, 0.5475589657435200e-01, &
   & 0.7503967481091995e-01, 0.9312545458369761e-01, 0.1093871588022976e+00, 0.1234919762620659e+00, 0.1347092173114733e+00, &
   & 0.1427759385770601e+00, 0.1477391049013385e+00, 0.1494455540029169e+00]
real, parameter :: wg(5) = [0.6667134430868814e-01, 0.1494513491505806e+00, 0.2190863625159820e+00, 0.2692667193099964e+00 &
   & , 0.2955242247147529e+00]
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              to compute I = Integral of f over (a,b), with error
!                             estimate
!                         j = Integral of abs(f) over (a,b)
! 2.        PARAMETERS
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!              a      - REAL
!                       lower limit of integration
!              b      - REAL
!                       upper limit of integration
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!              uflow  - REAL
!                       the smallest positive magnitude.
!            On return
!              result - Real
!                       approximation to the integral I
!                       result is computed by applying the 21-point
!                       Kronrod rule (RESK) obtained by optimal
!                       addition of abscissae to the 10-point Gauss
!                       RULE (resg).
!              abserr - REAL
!                       estimate of the modulus of the absolute error,
!                       which should not exceed abs(I-result)
!              resabs - REAL
!                       approximation to the integral j
!              resasc - REAL
!                       approximation to the integral of abs(f-I/(b-a))
!                       OVER (a,b)
!              isig   - INTEGER
!                       isig=0  The integral was approximated.
!                       isig=5  The interval (a,b) is too short.
!                               The integral cannot be computed.
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!-----------------------------------------------------------------------
!           The abscissae and weights are given for the interval (-1,1).
!           Because of symmetry only the positive abscissae and their
!           corresponding weights are given.
!           xgk    - Abscissae of the 21-point Kronrod rule
!                    xgk(2), xgk(4), ...  abscissae of the 10-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 10-point Gauss rule
!           wgk    - Weights of the 21-point Kronrod rule
!           wg     - Weights of the 10-point Gauss rule
!           List of major variables
!           -----------------------
!           centr  - Mid point of the interval
!           hlgth  - Half-length of the interval
!           absc   - ABSCISSA
!           FVAL*  - Function VALUE
!           resg   - result of the 10-point Gauss formula
!           RESK   - result of the 21-point Kronrod formula
!           RESKH  - Approximation to the mean value of f over (a,b),
!                    I.E. TO I/(b-a)
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
dhlgth = abs(hlgth)
!             Check if the interval (a,b) is too short
isig = 5
absc = abs(centr) + dhlgth*0.14
if (absc == abs(centr)) return
!           Compute the 21-point Kronrod approximation to
!           the integral, and estimate the absolute error.
isig = 0
resg = 0.0
fc = f(centr)
resk = wgk(11)*fc
resabs = abs(resk)
do j = 1,5
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
end do
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
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) + abs(fv2(j) - reskh))
end do
result = resk*hlgth
resabs = resabs*dhlgth
resasc = resasc*dhlgth
abserr = abs((resk - resg)*hlgth)
if (resasc /= 0.0 .and. abserr /= 0.0) &
   & abserr = resasc*min(1.0, &
   & (0.2e+03*abserr/resasc)**1.5)
tol = epmach*0.5e+02
if (resabs > uflow/tol) abserr = max(abserr,tol*resabs)
end subroutine qk21f

subroutine qagi(f, bound, inf, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
implicit none
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(out) :: last
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
real, intent(out) :: abserr
real, intent(in) :: bound, epsabs, epsrel
real, intent(out) :: result
real :: f
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!                   Integration over infinite intervals
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            bound  - Real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
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
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of significant
!                    elements actually in the work arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first
!                    K elements of which contain pointers
!                    to the error estimates over the subintervals,
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!        Subroutines or functions needed
!              - qagie
!              - qk15i
!              - qpsrt
!              - qelg
!              - f (user provided function)
!              - spmpar
!-----------------------------------------------------------------------
!         Check validity of limit and lenw.
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit < 1 .or. lenw < limit*4) return
!         Prepare call for qagie.
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
call qagie(f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
end subroutine qagi

subroutine qagie(f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!                   Integration over infinite intervals
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            bound  - Real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     limit.GE.1
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
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
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             elist(1) and iord(1) are set to zero.
!                             alist(1) and blist(1) are set to 0
!                             and 1 respectively.
!            alist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!            blist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!            rlist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - REAL
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!            iord   - INTEGER
!                     vector of dimension limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!        subroutines or functions needed
!              - qk15i
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - spmpar
!-----------------------------------------------------------------------
real, intent(out) :: abserr
real, intent(inout) :: alist
real, intent(inout) :: blist
real, intent(in) :: bound
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
real :: abseps, area, area1, area12, area2, a1, a2, boun, b1, b2, correc, defabs, defab1, defab2, dres, epmach, erlarg, erlast, &
   & errbnd, errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), small, t, uflow
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2
logical :: extrap, noext
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine qelg.
!            List of major variables
!            -----------------------
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left subinterval
!           *****2    - Variable for the right subinterval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered up
!                       to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (TRUE-VALUE)
!            machine dependent constants
!            ---------------------------
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!           Check epsabs and epsrel
!           -----------------------
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
if (epsabs < 0.0 .or. epsrel < 0.0) go to 999
ier = 0
rerr = max(epsrel, 50.0*epmach, 0.5e-14)
!           First approximation to the integral
!           -----------------------------------
!           Determine the interval to be mapped onto (0,1).
!           If inf = 2 The integral is computed as I = I1+I2, where
!           I1 = Integral of f over (-INFINITY,0),
!           I2 = Integral of f over (0,+INFINITY).
boun = bound
if (inf == 2) boun = 0.0
call qk15i(f, boun, inf, 0.0, 1.0, result, abserr, &
   & defabs, resabs, epmach, uflow)
!           Test on accuracy
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
if (abserr <= 100.0*epmach*defabs .and. abserr > errbnd) &
   & ier = 2
if (limit == 1) ier = 1
if (ier /= 0 .or. (abserr <= errbnd .and. abserr /= resabs) &
   & .or. abserr == 0.0) go to 130
!           Initialization
!           --------------
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
if (dres >= (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with nrmax-TH largest
!           error estimate.
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qk15i(f, boun, inf, a1, b1, area1, error1, &
      & resabs, defab1, epmach, uflow)
   call qk15i(f, boun, inf, a2, b2, area2, error2, &
      & resabs, defab2, epmach, uflow)
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1e-04*abs(area12) &
      & .or. erro12 < 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually
!           set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of
!           subintervals equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at some points of the integration range.

   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
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
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
   if (errsum <= errbnd) go to 115
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro == 3 .or. erlarg <= ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (erlarg) and perform
!           extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg(numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1e-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
   if (abserr <= ertest) exit
!            Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
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
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.0 .and. area /= 0.0) go to 105
if (abserr > errsum) go to 115
if (area == 0.0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence
110 if (ksgn == -1 .and. max(abs(result),abs(area)) <= &
   & defabs*0.1e-01) go to 130
if (0.1e-01 > (result/area) .or. (result/area) > 0.1e+03 &
   & .or. errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf == 2) neval = 2*neval
if (ier > 2) ier = ier - 1
999 return
end subroutine qagie

subroutine qk15i(f, boun, inf, a, b, result, abserr, resabs, &
   & resasc, epmach, uflow)
implicit none
integer, intent(in) :: inf
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, boun, epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
real :: f
external f
integer :: j
real :: absc, absc1, absc2, centr, dinf, fc, fsum, fval1, fval2, hlgth, resg, resk, reskh, tabsc1, tabsc2, tol, fv1(7), fv2(7)
real, parameter :: xgk(8) = [0.9914553711208126e+00, 0.9491079123427585e+00, 0.8648644233597691e+00, &
   & 0.7415311855993944e+00, 0.5860872354676911e+00, 0.4058451513773972e+00, 0.2077849550078985e+00, 0.0000000000000000e+00]
real, parameter :: wgk(8) = [0.2293532201052922e-01, 0.6309209262997855e-01, 0.1047900103222502e+00, &
   & 0.1406532597155259e+00, 0.1690047266392679e+00, 0.1903505780647854e+00, 0.2044329400752989e+00, 0.2094821410847278e+00]
real, parameter :: wg(8) = [0.0000000000000000e+00, 0.1294849661688697e+00, 0.0000000000000000e+00, 0.2797053914892767e+00 &
   & , 0.0000000000000000e+00, 0.3818300505051189e+00, 0.0000000000000000e+00, 0.4179591836734694e+00]
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (a,b) is a part of (0,1).
!              It is the purpose to compute
!              I = Integral of transformed integrand over (a,b),
!              j = Integral of abs(transformed integrand) over (a,b).
! 2.        PARAMETERS
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!              boun   - REAL
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF inf = +2)
!              inf    - INTEGER
!                       if inf = -1, the original interval is
!                                   (-INFINITY,BOUND),
!                       if inf = +1, the original interval is
!                                   (BOUND,+INFINITY),
!                       if inf = +2, the original interval is
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!              a      - REAL
!                       lower limit for integration over subrange
!                       of (0,1)
!              b      - REAL
!                       upper limit for integration over subrange
!                       of (0,1)
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!              uflow  - REAL
!                       the smallest positive magnitude.
!            On return
!              result - Real
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod rule(RESK) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(RESG).
!              abserr - REAL
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed abs(I-result)
!              resabs - REAL
!                       approximation to the integral j
!              resasc - REAL
!                       approximation to the integral of
!                       abs((transformed integrand)-I/(b-a))
!                       OVER (a,b)
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!-----------------------------------------------------------------------
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!           xgk    - Abscissae of the 15-point Kronrod rule
!                    xgk(2), xgk(4), ... abscissae of the 7-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!           wgk    - Weights of the 15-point Kronrod rule
!           wg     - Weights of the 7-point Gauss rule, corresponding
!                    to the abscissae xgk(2), xgk(4), ...
!                    wg(1), wg(3), ... are set to zero.
!           List of major variables
!           -----------------------
!           centr  - Mid point of the interval
!           HLGTH  - Half-length of the interval
!           absc*  - ABSCISSA
!           TABSC* - Transformed abscissa
!           FVAL*  - Function VALUE
!           RESG   - result of the 7-point Gauss formula
!           RESK   - result of the 15-point Kronrod formula
!           RESKH  - Approximation to the mean value of the transformed
!                    integrand over (a,b), I.E. to I/(b-a)
dinf = min(1,inf)
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
tabsc1 = boun + dinf*(1.0 - centr)/centr
fval1 = f(tabsc1)
if (inf == 2) fval1 = fval1 + f(-tabsc1)
fc = (fval1/centr)/centr
!           Compute the 15-point Kronrod approximation to
!           the integral, and estimate the error.
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
   if (inf == 2) fval1 = fval1 + f(-tabsc1)
   if (inf == 2) fval2 = fval2 + f(-tabsc2)
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
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) + &
      & abs(fv2(j) - reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = abs((resk - resg)*hlgth)
if (resasc /= 0.0 .and. abserr /= 0.0) abserr = resasc* &
   & min(1.0, (0.2e+03*abserr/resasc)**1.5)
tol = 50.0*epmach
if (resabs > uflow/tol) abserr = max(abserr, tol*resabs)
end subroutine qk15i

subroutine qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
implicit none
!     ..................................................................
! 1.        qpsrt
!           ordering routine
!              standard Fortran subroutine
!              real version
! 2.        PURPOSE
!              this routine maintains the descending ordering
!              in the list of the local error estimates resulting from
!              the interval subdivision process. At each call two error
!              estimates are inserted using the sequential search
!              method, top-down for the largest error estimate
!              and bottom-up for the smallest error estimate.
! 3.        CALLING SEQUENCE
!              call qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!           parameters (meaning at output)
!              limit  - Integer
!                       maximum number of error estimates the list
!                       can contain
!              last   - INTEGER
!                       number of error estimates currently
!                       in the list
!              maxerr - Integer
!                       maxerr points to the nrmax-TH largest error
!                       estimate currently in the list
!              ermax  - Real
!                       nrmax-TH largest error estimate
!                       ermax = elist(maxerr)
!              elist  - Real
!                       vector of dimension last containing
!                       the error estimates
!              iord   - INTEGER
!                       vector of dimension last, the first k
!                       elements of which contain pointers
!                       to the error estimates, such that
!                       elist(iord(1)),... , elist(iord(k))
!                       form a decreasing sequence, with
!                       k = last if last.LE.(limit/2+2), and
!                       k = limit+1-last otherwise
!              nrmax  - Integer
!                       maxerr = iord(nrmax)
! 4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!     ..................................................................
real :: elist
real, intent(inout) :: ermax
integer, intent(inout) :: iord
integer, intent(in) :: last, limit
integer, intent(inout) :: maxerr, nrmax
real :: errmax, errmin
integer :: i, ibeg, ido, isucc, j, jbnd, jupbn, k
dimension elist(last),iord(last)
!           Check whether the list contains more than
!           two error estimates.
!***First executable statement  qpsrt
if (last > 2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!           This part of the routine is only executed
!           if, due to a difficult integrand, subdivision
!           increased the error estimate. In the normal case
!           the insert procedure should start after the
!           nrmax-TH largest error estimate.
10 errmax = elist(maxerr)
if (nrmax == 1) go to 30
ido = nrmax - 1
do i = 1,ido
   isucc = iord(nrmax - 1)
! ***Jump out of do-loop
   if (errmax <= elist(isucc)) exit
   iord(nrmax) = isucc
   nrmax = nrmax - 1
end do
!           Compute the number of elements in the list to
!           be maintained in descending order. This number
!           depends on the number of subdivisions still
!           allowed.
30 jupbn = last
if (last > (limit/2 + 2)) jupbn = limit + 3 - last
errmin = elist(last)
!           Insert errmax by traversing the list top-down,
!           starting comparison from the element elist(iord(nrmax+1)).
jbnd = jupbn - 1
ibeg = nrmax + 1
if (ibeg > jbnd) go to 50
do i = ibeg,jbnd
   isucc = iord(i)
! ***Jump out of do-loop
   if (errmax >= elist(isucc)) go to 60
   iord(i - 1) = isucc
end do
50 iord(jbnd) = maxerr
iord(jupbn) = last
go to 90
!           Insert errmin by traversing the list bottom-up.
60 iord(i - 1) = maxerr
k = jbnd
do j = i,jbnd
   isucc = iord(k)
! ***Jump out of do-loop
   if (errmin < elist(isucc)) go to 80
   iord(k + 1) = isucc
   k = k - 1
end do
iord(i) = last
go to 90
80 iord(k + 1) = last
!           Set maxerr and ermax.
90 maxerr = iord(nrmax)
ermax = elist(maxerr)
end subroutine qpsrt

pure subroutine qelg(n, epstab, result, abserr, res3la, nres, &
   & epmach, oflow)
implicit none
integer, intent(inout) :: n, nres
real, intent(out) :: abserr
real, intent(in) :: epmach, oflow
real, intent(out) :: result
real, intent(inout) :: epstab(52), res3la(3)
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp, newelm, num
real :: delta1, delta2, delta3, e0, e1, e1abs, e2, e3, epsinf, &
   & err1, err2, err3, error, res, ss, tol1, tol2, tol3
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
! 2.        PARAMETERS
!              n      - INTEGER
!                       epstab(n) contains the new element in the
!                       first column of the epsilon table.
!              epstab - REAL
!                       vector of dimension 52 containing the
!                       elements of the two lower diagonals of
!                       the triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!              result - Real
!                       resulting approximation to the integral
!              abserr - REAL
!                       estimate of the absolute error computed from
!                       result and the 3 previous results
!              res3la - REAL
!                       vector of dimension 3 containing the last 3
!                       results
!              nres   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!              oflow  - REAL
!                       the largest positive magnitude.
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!-----------------------------------------------------------------------
!---------------------
!           List of major variables
!           -----------------------
!           e0     - The 4 elements on which the
!           e1       COMPUTATION OF A NEW ELEMENT IN
!           e2       THE EPSILON TABLE IS BASED
!           e3                 e0
!                        e3    e1    NEW
!                              e2
!           newelm - Number of elements to be computed in the new
!                    diagonal
!           ERROR  - ERROR = abs(e1-e0)+abs(e2-e1)+abs(NEW-e2)
!           result - The element in the new diagonal with least value
!                    of error
!           limexp is the maximum number of elements the epsilon
!           table can contain. If this number is reached, the upper
!           diagonal of the epsilon table is deleted.
nres = nres + 1
abserr = oflow
result = epstab(n)
if (n < 3) go to 100
limexp = 50
epstab(n + 2) = epstab(n)
newelm = (n - 1)/2
epstab(n) = oflow
num = n
k1 = n
do i = 1,newelm
   k2 = k1 - 1
   k3 = k1 - 2
   res = epstab(k1 + 2)
   e0 = epstab(k3)
   e1 = epstab(k2)
   e2 = res
   e1abs = abs(e1)
   delta2 = e2 - e1
   err2 = abs(delta2)
   tol2 = max(abs(e2),e1abs)*epmach
   delta3 = e1 - e0
   err3 = abs(delta3)
   tol3 = max(e1abs,abs(e0))*epmach
   if (err2 > tol2 .or. err3 > tol3) go to 10
!           If e0, e1 and e2 are equal to within machine
!           accuracy, convergence is assumed.
!           result = e2
!           abserr = abs(e1-e0) + abs(e2-e1)
   result = res
   abserr = err2 + err3
! ***Jump out of do-loop
   go to 100
10 e3 = epstab(k1)
   epstab(k1) = e1
   delta1 = e1 - e3
   err1 = abs(delta1)
   tol1 = max(e1abs,abs(e3))*epmach
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of n
   if (err1 <= tol1 .or. err2 <= tol2 .or. err3 <= tol3) go to 20
   ss = 1.0/delta1 + 1.0/delta2 - 1.0/delta3
   epsinf = abs(ss*e1)
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF n.
   if (epsinf > 0.1e-03) go to 30
20 n = i + i - 1
! ***Jump out of do-loop
   exit
!           Compute a new element and eventually adjust
!           the value of result.
30 res = e1 + 1.0/ss
   epstab(k1) = res
   k1 = k1 - 2
   error = err2 + abs(res - e2) + err3
   if (error > abserr) go to 40
   abserr = error
   result = res
40 continue
end do
!           Shift the table.
if (n == limexp) n = 2*(limexp/2) - 1
ib = 1
if ((num/2)*2 == num) ib = 2
ie = newelm + 1
do i = 1,ie
   ib2 = ib + 2
   epstab(ib) = epstab(ib2)
   ib = ib2
end do
if (num == n) go to 80
indx = num - n + 1
do i = 1,n
   epstab(i) = epstab(indx)
   indx = indx + 1
end do
80 if (nres >= 4) go to 90
res3la(nres) = result
abserr = oflow
go to 100
!           Compute error estimate
90 abserr = abs(result - res3la(3)) + abs(result - res3la(2)) + &
   & abs(result - res3la(1))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = max(abserr,5.0*epmach*abs(result))
end subroutine qelg

subroutine qxgs(f,a,b,epsabs,epsrel,result,abserr,ier, &
   & limit,leniw,lenw,last,iwork,work)
implicit none
!            The routine calculates an approximation result to a given
!            definite integral  I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account. However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table. It is presumed that
!                             the requested tolerance cannot be
!                             achieved, and that the returned result is
!                             the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel IS NEGATIVE, limit .LT. 1,
!                             lenw .LT. 46*limit, OR
!                             leniw .LT. 3*limit.
!                             Result, abserr, last are set to
!                             zero. Except when limit or lenw or leniw
!                             is invalid, iwork(1), work(limit*2+1) and
!                             work(limit*3+1) are set to zero, work(1)
!                             is set to A, and work(limit+1) to b.
!         Dimensioning parameters
!            limit - Integer
!                    limit determines the maximum number of subintervals
!                    in the partition of the given integration interval
!                    (A,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*46.
!                    If lenw.LT.limit*46, the routine will end
!                    with ier = 6.
!            leniw - INTEGER
!                    dimensioning parameter for iwork
!                    leniw must be at least limit*3.
!                    If lenw.LT.limit*3, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of subintervals
!                    produced in the subdivision process, which deter-
!                    mines the number of significant elements actually
!                    in the work arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least 3*limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2),
!                    and K = limit+1-last otherwise.
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END-POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end-points,
!                    work(limit*2+1), ..., work(limit*2+last) contain
!                     the integral approximations over the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!                    work(limit*4+1), ... is the area reserved to store
!                     functional values.
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
external f
integer :: l1, l2, l3, l4, l5
dimension iwork(leniw),work(lenw)
!         Check validity of limit,leniw and lenw.
ier = 6
last = 0
result = 0.0
abserr = 0.0
if (limit < 1 .or. leniw < limit*3 .or. lenw < limit*46) &
   & return
!         Prepare call for qxgse.
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
l4 = limit + l3
l5 = 21*limit + l4
call qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last, &
   & work(l4),work(l5),iwork(l1),iwork(l2))
end subroutine qxgs

subroutine qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,alist,blist,rlist,elist,iord,last,valp,valn,lp,ln)
implicit none
!            The routine calculates an approximation result to A
!            definite integral I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - Real
!                     absolute accuracy requested
!            epsrel - Real
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upperbound on the number of subintervals
!                     in the partition of (a,b)
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - Real
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                         = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account). However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel is negative. Result, abserr,
!                             last, rlist(1), iord(1), and elist(1)
!                             are set to zero. alist(1) and blist(1)
!                             are set to A and b respectively.
!            alist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left end points
!                     of the subintervals in the partition of the
!                     given integration range (a,b)
!            blist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right end points
!                     of the subintervals in the partition of the given
!                     integration range (a,b)
!            rlist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli of the
!                     absolute error estimates on the subintervals
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!            valp   - REAL
!            valn     ARRAYS OF DIMENSION AT LEAST (21,limit) USED TO
!                     save the functional values
!            lp     - INTEGER
!            ln       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!                     store the actual number of functional values
!                     saved in the corresponding column
!                     of valp,valn
!***routines called  f,spmpar,qelg,qxlqm,qpsrt,qxrrd,qxcpy
real :: a
real, intent(out) :: abserr
real, intent(inout) :: alist
real :: b
real, intent(inout) :: blist
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
real, intent(inout) :: valp, valn
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(inout) :: lp(limit), ln(limit)
external f
real :: abseps, area, area1, area12, area2, a1, a2, b1, b2, correc, defabs, defab1, defab2, dres, epmach, erlarg, erlast, errbnd, &
   & errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), small, t, uflow, vp1(21), &
   & vp2(21), vn1(21), vn2(21)
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2, lp1, lp2, ln1, ln2
logical :: extrap, noext
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit), valp(21,limit), valn(21,limit)
!            Machine dependent constants
!            ---------------------------
!          epmach is the largest relative spacing.
!          uflow is the smallest positive magnitude.
!          OFLOW is the largest positive magnitude.
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
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
if (epsabs < 0.0 .or. epsrel < 0.0) go to 999
ier = 0
rerr = max(epsrel, 50.0*epmach)
!           First approximation to the integral
!           -----------------------------------
ierro = 0
lp(1) = 1
ln(1) = 1
valp(1,1) = f((a + b)*0.5)
valn(1,1) = valp(1,1)
call qxlqm(f,a,b,result,abserr,defabs,resabs, &
   & valp(1,1),valn(1,1),lp(1),ln(1),2, &
   & epmach,uflow,oflow)
!           Test on accuracy.
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr <= 100.0*epmach*defabs .and. abserr > &
   & errbnd) ier = 2
if (limit == 1) ier = 1
if (ier /= 0 .or. (abserr <= errbnd.and.abserr /= resabs) .or. &
   & abserr == 0.0) go to 999
!           Initialization
!           --------------
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
if (dres >= (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with the nrmax-TH largest error
!           estimate.
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qxrrd(f,valn(1,maxerr),ln(maxerr),b1,a1,vn1,vp1,ln1,lp1)
   call qxlqm(f,a1,b1,area1,error1,resabs,defab1,vp1,vn1,lp1,ln1, &
      & 2,epmach,uflow,oflow)
   call qxrrd(f,valp(1,maxerr),lp(maxerr),a2,b2,vp2,vn2,lp2,ln2)
   call qxlqm(f,a2,b2,area2,error2,resabs,defab2,vp2,vn2,lp2,ln2, &
      & 2,epmach,uflow,oflow)
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1e-04*abs(area12) &
      & .or. erro12 < 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of subintervals
!           equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 1.e+03*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
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
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the subinterval
!           with nrmax-TH largest error estimate (to be bisected next).
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum <= errbnd) go to 115
! ***Jump out of do-loop
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
!           The bound 0.3*ERTEST has been introduced to perform A
!           more cautious extrapolation than in the original dqagse
!           routine
40 if (ierro == 3 .or. erlarg <= 0.3*ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors over the
!           larger intervals (erlarg) and perform extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg(numrl2,rlist2,reseps,abseps,res3la,nres, &
      & epmach,oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1e-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
! ***Jump out of do-loop
   if (abserr <= ertest) exit
!           Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
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
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.0 .and. area /= 0.0) go to 105
if (abserr > errsum) go to 115
if (area == 0.0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence.
110 if (ksgn == (-1).and.max(abs(result),abs(area)) <= &
   & defabs*0.1e-01) go to 130
if (0.1e-01 > (result/area).or.(result/area) > 0.1e+03 &
   & .or.errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier > 2) ier = ier - 1
999 return
end subroutine qxgse

