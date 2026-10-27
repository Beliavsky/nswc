pure subroutine dtred2(nm,n,a,d,e,z)
!! <!-- nswc-ford:begin DTRED2 -->
!! Reference for `dtred2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision dsqrt,dabs
!!
!!      This subroutine is a translation of the Algol procedure tred2,
!!      NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!!      This subroutine reduces a real symmetric matrix to A
!!      symmetric tridiagonal matrix using and accumulating
!!      orthogonal similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         a contains the real symmetric input matrix.  Only the
!!           lower triangle of the matrix need be supplied.
!!      On output-
!!         d contains the diagonal elements of the tridiagonal matrix,
!!         e contains the subdiagonal elements of the tridiagonal
!!           matrix in its last n-1 positions.  e(1) is set to zero,
!!         z contains the orthogonal transformation matrix
!!           produced in the reduction,
!!         A and z may coincide.  If distinct, A is unaltered.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
double precision, intent(in) :: a(nm,n)
double precision, intent(inout) :: d(n), e(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, ii, jp1
double precision :: f, g, h, hh, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tred2,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!     This subroutine reduces a real symmetric matrix to A
!     symmetric tridiagonal matrix using and accumulating
!     orthogonal similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        a contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!     On output-
!        d contains the diagonal elements of the tridiagonal matrix,
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!        z contains the orthogonal transformation matrix
!          produced in the reduction,
!        A and z may coincide.  If distinct, A is unaltered.
!-----------------------------------------------------------------------
do i = 1, n
   do j = 1, i
      z(i,j) = a(i,j)
   end do
end do
if (n == 1) go to 320
!     ********** FOR i=n STEP -1 UNTIL 2 DO -- **********
do ii = 2, n
   i = n + 2 - ii
   l = i - 1
   h = 0.d0
   scale = 0.d0
   if (l < 2) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      scale = scale + abs(z(i,k))
   end do
   if (scale /= 0.d0) go to 140
130 e(i) = z(i,l)
   go to 290
140 do k = 1, l
      z(i,k) = z(i,k) / scale
      h = h + z(i,k) * z(i,k)
   end do
   f = z(i,l)
   g = sqrt(h)
   if (f >= 0.d0) g = -g
   e(i) = scale * g
   h = h - f * g
   z(i,l) = f - g
   f = 0.d0
   do j = 1, l
      z(j,i) = z(i,j) / h
      g = 0.d0
!     ********** Form element of a*U **********
      do k = 1, j
         g = g + z(j,k) * z(i,k)
      end do
      jp1 = j + 1
      if (l < jp1) go to 220
      do k = jp1, l
         g = g + z(k,j) * z(i,k)
      end do
!     ********** Form element of P **********
220   e(j) = g / h
      f = f + e(j) * z(i,j)
   end do
   hh = f / (h + h)
!     ********** Form reduced a **********
   do j = 1, l
      f = z(i,j)
      g = e(j) - hh * f
      e(j) = g
      do k = 1, j
         z(j,k) = z(j,k) - f * e(k) - g * z(i,k)
      end do
   end do
290 d(i) = h
end do
320 d(1) = 0.d0
e(1) = 0.d0
!     ********** Accumulation of transformation matrices **********
do i = 1, n
   l = i - 1
   if (d(i) == 0.d0) go to 380
   do j = 1, l
      g = 0.d0
      do k = 1, l
         g = g + z(i,k) * z(k,j)
      end do
      do k = 1, l
         z(k,j) = z(k,j) - g * z(k,i)
      end do
   end do
380 d(i) = z(i,i)
   z(i,i) = 1.d0
   if (l < 1) go to 500
   do j = 1, l
      z(i,j) = 0.d0
      z(j,i) = 0.d0
   end do
500 continue
end do
!     ********** Last card of dtred2 **********
end subroutine dtred2

pure subroutine dtql2(nm,n,d,e,z,ierr)
!! <!-- nswc-ford:begin DTQL2 -->
!! Reference for `dtql2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure tql2,
!!      NUM. Math. 11, 293-306(1968) By Bowdler, Martin, Reinsch, and
!!      Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 227-240(1971).
!!      This subroutine finds the eigenvalues and eigenvectors
!!      of a symmetric tridiagonal matrix BY the QL method.
!!      The eigenvectors of a full symmetric matrix can also
!!      be found if  tred2  has been used to reduce this
!!      full matrix to tridiagonal form.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         d contains the diagonal elements of the input matrix,
!!         e contains the subdiagonal elements of the input matrix
!!           in its last n-1 positions.  e(1) is arbitrary,
!!         z contains the transformation matrix produced in the
!!           reduction by  tred2, if performed.  If the eigenvectors
!!           of the tridiagonal matrix are desired, z must contain
!!           the identity matrix.
!!       On output-
!!         d contains the eigenvalues in ascending order.  If an
!!           error exit is made, the eigenvalues are correct but
!!           unordered for indices 1,2,...,ierr-1,
!!         e has been destroyed,
!!         z contains orthonormal eigenvectors of the symmetric
!!           tridiagonal (or full) matrix.  If an error exit is made,
!!           z contains the eigenvectors associated with the stored
!!           eigenvalues,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 50 iterations.
!!
!!      ********** machep is a machine dependent parameter. Assign
!!                 machep the value U where U is the smallest positive
!!                 floating point number such that 1.0 + U .GT. 1.0 .
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(out) :: ierr
double precision, intent(inout) :: d(n), e(n), z(nm,n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, ii, l1, mml
double precision :: b, c, f, g, h, p, r, s, machep
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure tql2,
!     NUM. Math. 11, 293-306(1968) By Bowdler, Martin, Reinsch, and
!     Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 227-240(1971).
!     This subroutine finds the eigenvalues and eigenvectors
!     of a symmetric tridiagonal matrix BY the QL method.
!     The eigenvectors of a full symmetric matrix can also
!     be found if  tred2  has been used to reduce this
!     full matrix to tridiagonal form.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        d contains the diagonal elements of the input matrix,
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary,
!        z contains the transformation matrix produced in the
!          reduction by  tred2, if performed.  If the eigenvectors
!          of the tridiagonal matrix are desired, z must contain
!          the identity matrix.
!      On output-
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct but
!          unordered for indices 1,2,...,ierr-1,
!        e has been destroyed,
!        z contains orthonormal eigenvectors of the symmetric
!          tridiagonal (or full) matrix.  If an error exit is made,
!          z contains the eigenvectors associated with the stored
!          eigenvalues,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
machep = dpmpar(1)
!                **********
ierr = 0
if (n == 1) go to 1001
do i = 2, n
   e(i - 1) = e(i)
end do
f = 0.d0
b = 0.d0
e(n) = 0.d0
do l = 1, n
   j = 0
   h = machep * (abs(d(l)) + abs(e(l)))
   if (b < h) b = h
!     ********** Look for small sub-diagonal element **********
   do m = l, n
      if (abs(e(m)) <= b) exit
!     ********** e(n) is always zero, so there is no exit
!                through the bottom of the loop **********
   end do
   if (m == l) go to 220
130 if (j == 50) go to 1000
   j = j + 1
!     ********** Form shift **********
   l1 = l + 1
   g = d(l)
   p = (d(l1) - g) / (2.d0 * e(l))
   r = sqrt(p*p + 1.d0)
   if (p < 0.d0) r = -r
   d(l) = e(l) / (p + r)
   h = g - d(l)
   do i = l1, n
      d(i) = d(i) - h
   end do
   f = f + h
!     ********** QL TRANSFORMATION **********
   p = d(m)
   c = 1.d0
   s = 0.d0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      g = c * e(i)
      h = c * p
      if (abs(p) < abs(e(i))) go to 150
      c = e(i) / p
      r = sqrt(c*c + 1.d0)
      e(i + 1) = s * p * r
      s = c / r
      c = 1.d0 / r
      go to 160
150   c = p / e(i)
      r = sqrt(c*c + 1.d0)
      e(i + 1) = s * e(i) * r
      s = 1.d0 / r
      c = c * s
160   p = c * d(i) - s * g
      d(i + 1) = h + s * (c * g + s * d(i))
!     ********** Form vector **********
      do k = 1, n
         h = z(k,i + 1)
         z(k,i + 1) = s * z(k,i) + c * h
         z(k,i) = c * z(k,i) - s * h
      end do
   end do
   e(l) = s * p
   d(l) = c * p
   if (abs(e(l)) > b) go to 130
220 d(l) = d(l) + f
end do
!     ********** Order eigenvalues and eigenvectors **********
do ii = 2, n
   i = ii - 1
   k = i
   p = d(i)
   do j = ii, n
      if (d(j) >= p) go to 260
      k = j
      p = d(j)
260   continue
   end do
   if (k == i) go to 300
   d(k) = d(i)
   d(i) = p
   do j = 1, n
      p = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = p
   end do
300 continue
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = l
1001 return
!     ********** Last card of dtql2 **********
end subroutine dtql2

pure subroutine ceig(ibal,ar,ai,ka,n,wr,wi,ierr)
!! <!-- nswc-ford:begin CEIG -->
!! Reference for `ceig`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Eigenvalues of complex matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: igh, low
interface
   pure subroutine cbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine cbal
   pure subroutine comqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: hr(nm,n)
      real, intent(inout) :: hi(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine comqr
   pure subroutine corth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      real, intent(inout) :: ortr(igh)
      real, intent(inout) :: orti(igh)
   end subroutine corth
end interface
!-----------------------------------------------------------------------
!                Eigenvalues of complex matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call cbal(ka,n,ar,ai,low,igh,wr)
call corth(ka,n,low,igh,ar,ai,wr,wi)
call comqr(ka,n,low,igh,ar,ai,wr,wi,ierr)
end subroutine ceig

pure subroutine ceigv(ibal,ar,ai,ka,n,wr,wi,zr,zi,ierr,temp)
!! <!-- nswc-ford:begin CEIGV -->
!! Reference for `ceigv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!           Eigenvalues and eigenvectors of complex matrices
!!
!!      Temp is a temporary storage area
!!         DIMENSION(TEMP) .GE. 2*n    IF ibal .EQ. 0
!!         DIMENSION(TEMP) .GE. 3*n    IF ibal .NE. 0
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), wi(n), zr(ka,n), &
   & zi(ka,n), temp(*)
!     beginning of local variable declarations
integer :: i1, i2, i3, igh, low
interface
   pure subroutine cbabk2(nm,n,low,igh,scale,m,zr,zi)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(in) :: scale(n)
      real, intent(inout) :: zr(nm,m)
      real, intent(inout) :: zi(nm,m)
   end subroutine cbabk2
   pure subroutine cbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine cbal
   pure subroutine comqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi, &
      & ierr)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: ortr(igh)
      real, intent(inout) :: orti(igh)
      real, intent(inout) :: hr(nm,n)
      real, intent(inout) :: hi(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      real, intent(inout) :: zr(nm,n)
      real, intent(inout) :: zi(nm,n)
      integer, intent(out) :: ierr
   end subroutine comqr2
   pure subroutine corth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: ar(nm,n)
      real, intent(inout) :: ai(nm,n)
      real, intent(inout) :: ortr(igh)
      real, intent(inout) :: orti(igh)
   end subroutine corth
end interface
!-----------------------------------------------------------------------
!          Eigenvalues and eigenvectors of complex matrices
!-----------------------------------------------------------------------
!----------------------
!     Temp is a temporary storage area
!        DIMENSION(TEMP) .GE. 2*n    IF ibal .EQ. 0
!        DIMENSION(TEMP) .GE. 3*n    IF ibal .NE. 0
!----------------------
i2 = 1
i3 = n + 1
i1 = n + i3
low = 1
igh = n
if (ibal /= 0) call cbal(ka,n,ar,ai,low,igh,temp(i1))
call corth(ka,n,low,igh,ar,ai,temp(i2),temp(i3))
call comqr2(ka,n,low,igh,temp(i2),temp(i3),ar,ai,wr,wi,zr,zi,ierr)
if (ierr /= 0) return
if (ibal /= 0) call cbabk2(ka,n,low,igh,temp(i1),n,zr,zi)
end subroutine ceigv

pure subroutine cbal(nm,n,ar,ai,low,igh,scale)
!! <!-- nswc-ford:begin CBAL -->
!! Reference for `cbal`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real abs
!!
!!      This subroutine is a translation of the Algol procedure
!!      CBALANCE, which is a complex version of balance,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!!      This subroutine balances a complex matrix and isolates
!!      eigenvalues whenever possible.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the complex matrix to be balanced.
!!      On output-
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the balanced matrix,
!!         low and igh are two integers such that ar(i,j) and ai(i,j)
!!           are equal to zero if
!!            (1) i is greater than j and
!!            (2) j=1,...,low-1 OR i=igh+1,...,n,
!!         scale contains information determining the
!!            permutations and scaling factors used.
!!      Suppose that the principal submatrix in rows low through igh
!!      has been balanced, that P(j) denotes the index interchanged
!!      with j during the permutation step, and that the elements
!!      of the diagonal matrix used are denoted by D(i,j).  Then
!!         scale(j) = P(j),    FOR j = 1,...,low-1
!!                  = D(j,j)       j = low,...,igh
!!                  = P(j)         j = igh+1,...,n.
!!      The order in which the interchanges are made is n to igh+1,
!!      then 1 to low-1.
!!      Note that 1 is returned for igh if igh is zero formally.
!!      The Algol procedure exc contained in CBALANCE appears in
!!      cbal  in line.  (Note that the Algol roles of identifiers
!!      k,l have been reversed.)
!!
!!      ********** radix is a machine dependent parameter specifying
!!                 the base of the machine floating point representation.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
real, intent(inout) :: ar(nm,n), ai(nm,n), scale(n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, jj, iexc
real :: c, f, g, r, s, b2, radix
logical :: noconv
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!     real abs
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure
!     CBALANCE, which is a complex version of balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!     This subroutine balances a complex matrix and isolates
!     eigenvalues whenever possible.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex matrix to be balanced.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the balanced matrix,
!        low and igh are two integers such that ar(i,j) and ai(i,j)
!          are equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!        scale contains information determining the
!           permutations and scaling factors used.
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j)       j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!     Note that 1 is returned for igh if igh is zero formally.
!     The Algol procedure exc contained in CBALANCE appears in
!     cbal  in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!-----------------------------------------------------------------------
!     ********** radix is a machine dependent parameter specifying
!                the base of the machine floating point representation.
radix = ipmpar(4)
!                **********
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** In-line procedure for row and
!                column exchange **********
20 scale(m) = j
if (j == m) go to 50
do i = 1, l
   f = ar(i,j)
   ar(i,j) = ar(i,m)
   ar(i,m) = f
   f = ai(i,j)
   ai(i,j) = ai(i,m)
   ai(i,m) = f
end do
do i = k, n
   f = ar(j,i)
   ar(j,i) = ar(m,i)
   ar(m,i) = f
   f = ai(j,i)
   ai(j,i) = ai(m,i)
   ai(m,i) = f
end do
50 select case (iexc)
case (1)
   go to 80
case (2)
   go to 130
end select
!     ********** Search for rows isolating an eigenvalue
!                and push them down **********
80 if (l == 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do jj = 1, l
   j = l + 1 - jj
   do i = 1, l
      if (i == j) go to 110
      if (ar(j,i) /= 0.0 .or. ai(j,i) /= 0.0) go to 120
110   continue
   end do
   m = l
   iexc = 1
   go to 20
120 continue
end do
go to 140
!     ********** Search for columns isolating an eigenvalue
!                and push them left **********
130 k = k + 1
140 do j = k, l
   do i = k, l
      if (i == j) go to 150
      if (ar(i,j) /= 0.0 .or. ai(i,j) /= 0.0) go to 170
150   continue
   end do
   m = k
   iexc = 2
   go to 20
170 continue
end do
!     ********** Now balance the submatrix in rows k to l **********
do i = k, l
   scale(i) = 1.0
end do
!     ********** Iterative loop for norm reduction **********
190 noconv = .false.
do i = k, l
   c = 0.0
   r = 0.0
   do j = k, l
      if (j == i) go to 200
      c = c + abs(ar(j,i)) + abs(ai(j,i))
      r = r + abs(ar(i,j)) + abs(ai(i,j))
200   continue
   end do
!     ********** Guard against zero c or r due to underflow **********
   if (c == 0.0 .or. r == 0.0) go to 270
   g = r / radix
   f = 1.0
   s = c + r
210 if (c >= g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c < g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** Now balance **********
240 if ((c + r) / f >= 0.95 * s) go to 270
   g = 1.0 / f
   scale(i) = scale(i) * f
   noconv = .true.
   do j = k, n
      ar(i,j) = ar(i,j) * g
      ai(i,j) = ai(i,j) * g
   end do
   do j = 1, l
      ar(j,i) = ar(j,i) * f
      ai(j,i) = ai(j,i) * f
   end do
270 continue
end do
if (noconv) go to 190
280 low = k
igh = l
!     ********** Last card of cbal **********
end subroutine cbal

pure subroutine corth(nm,n,low,igh,ar,ai,ortr,orti)
!! <!-- nswc-ford:begin CORTH -->
!! Reference for `corth`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      real sqrt,cabs,abs
!!      complex cmplx
!!
!!      This subroutine is a translation of a complex analogue of
!!      the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!!      by Martin and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!!      Given a complex general matrix, this subroutine
!!      reduces a submatrix situated in rows and columns
!!      low through igh to upper Hessenberg form by
!!      unitary similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  cbal.  If  cbal  has not been used,
!!           set low=1, igh=n,
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the complex input matrix.
!!      On output-
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the Hessenberg matrix.  Information
!!           about the unitary transformations used in the reduction
!!           is stored in the remaining triangles under the
!!           Hessenberg matrix,
!!         ortr and orti contain further information about the
!!           transformations.  Only elements low through igh are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: ar(nm,n), ai(nm,n), ortr(igh), orti(igh)
!     beginning of local variable declarations
integer :: i, j, m, ii, jj, la, mp, kp1
real :: f, g, h, fi, fr, scale
!     real sqrt,cabs,abs
!     complex cmplx
!-----------------------------------------------------------------------
!     This subroutine is a translation of a complex analogue of
!     the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!     by Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!     Given a complex general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     unitary similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          set low=1, igh=n,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex input matrix.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the Hessenberg matrix.  Information
!          about the unitary transformations used in the reduction
!          is stored in the remaining triangles under the
!          Hessenberg matrix,
!        ortr and orti contain further information about the
!          transformations.  Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   h = 0.0
   ortr(m) = 0.0
   orti(m) = 0.0
   scale = 0.0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do i = m, igh
      scale = scale + abs(ar(i,m - 1)) + abs(ai(i,m - 1))
   end do
   if (scale == 0.0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ortr(i) = ar(i,m - 1) / scale
      orti(i) = ai(i,m - 1) / scale
      h = h + ortr(i) * ortr(i) + orti(i) * orti(i)
   end do
   g = sqrt(h)
   f = abs(cmplx(ortr(m),orti(m)))
   if (f == 0.0) go to 103
   h = h + f * g
   g = g / f
   ortr(m) = (1.0 + g) * ortr(m)
   orti(m) = (1.0 + g) * orti(m)
   go to 105
103 ortr(m) = g
   ar(m,m - 1) = scale
!     ********** FORM (i-(U*UT)/h) * A **********
105 do j = m, n
      fr = 0.0
      fi = 0.0
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
      do ii = m, igh
         i = mp - ii
         fr = fr + ortr(i) * ar(i,j) + orti(i) * ai(i,j)
         fi = fi + ortr(i) * ai(i,j) - orti(i) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do i = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(i) + fi * orti(i)
         ai(i,j) = ai(i,j) - fr * orti(i) - fi * ortr(i)
      end do
   end do
!     ********** FORM (i-(U*UT)/h)*A*(i-(U*UT)/h) **********
   do i = 1, igh
      fr = 0.0
      fi = 0.0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         fr = fr + ortr(j) * ar(i,j) - orti(j) * ai(i,j)
         fi = fi + ortr(j) * ai(i,j) + orti(j) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do j = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(j) - fi * orti(j)
         ai(i,j) = ai(i,j) + fr * orti(j) - fi * ortr(j)
      end do
   end do
   ortr(m) = scale * ortr(m)
   orti(m) = scale * orti(m)
   ar(m,m - 1) = -g * ar(m,m - 1)
   ai(m,m - 1) = -g * ai(m,m - 1)
180 continue
end do
200 return
!     ********** Last card of corth **********
end subroutine corth

pure subroutine comqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
!! <!-- nswc-ford:begin COMQR -->
!! Reference for `comqr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      integer min0
!!      real sqrt,cabs,abs,real,aimag
!!      complex csqrt,cmplx
!!
!!      This subroutine is a translation of a unitary analogue of the
!!      Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!!      and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!!      The unitary analogue substitutes the QR algorithm of Francis
!!      (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!!      This subroutine finds the eigenvalues of a complex
!!      upper Hessenberg matrix BY the QR method.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  cbal.  If  cbal  has not been used,
!!           set low=1, igh=n,
!!         hr and hi contain the real and imaginary parts,
!!           respectively, of the complex upper Hessenberg matrix.
!!           Their lower triangles below the subdiagonal contain
!!           information about the unitary transformations used in
!!           the reduction by  corth, if performed.
!!      On output-
!!         the upper Hessenberg portions of hr and hi have been
!!           destroyed.  Therefore, they must be saved before
!!           calling  comqr  if subsequent calculation of
!!           eigenvectors is to be performed,
!!         wr and wi contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  If an error
!!           exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!      Arithmetic is real except for the replacement of the Algol
!!      procedure cdiv by complex division and use of the subroutines
!!      CSQRT and cmplx in computing complex square roots.
!!
!!      ********** machep is a machine dependent parameter specifying
!!                 the relative precision of floating point arithmetic.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), wi(n)
!     beginning of local variable declarations
integer :: i, j, l, en, ll, its, lp1, enm1
real :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep
complex :: z3
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     integer min0
!     real sqrt,cabs,abs,real,aimag
!     complex csqrt,cmplx
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues of a complex
!     upper Hessenberg matrix BY the QR method.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          set low=1, igh=n,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain
!          information about the unitary transformations used in
!          the reduction by  corth, if performed.
!     On output-
!        the upper Hessenberg portions of hr and hi have been
!          destroyed.  Therefore, they must be saved before
!          calling  comqr  if subsequent calculation of
!          eigenvectors is to be performed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division and use of the subroutines
!     CSQRT and cmplx in computing complex square roots.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = spmpar(1)
!                **********
ierr = 0
if (low == igh) go to 180
!     ********** Create real subdiagonal elements **********
l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.0) go to 170
   norm = abs(cmplx(hr(i,i - 1),hi(i,i - 1)))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.0
   do j = i, igh
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = low, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by cbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.0
ti = 0.0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 1001
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low  -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 30) go to 1000
if (its == 10 .or. its == 20) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.0 .and. xi == 0.0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.0
yi = (hi(enm1,enm1) - si) / 2.0
z3 = sqrt(cmplx(yr**2 - yi**2 + xr,2.0*yr*yi + xi))
zzr = real(z3)
zzi = aimag(z3)
if (yr * zzr + yi * zzi >= 0.0) go to 310
zzr = -zzr
zzi = -zzi
310 z3 = cmplx(xr,xi) / cmplx(yr + zzr,yi + zzi)
sr = sr - real(z3)
si = si - aimag(z3)
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.0
   hi(i,i - 1) = sr / norm
   do j = i, en
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.0) go to 540
norm = abs(cmplx(hr(en,en),si))
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.0
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = l, j
      yr = hr(i,j - 1)
      yi = 0.0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.0) go to 240
do i = l, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 wr(en) = hr(en,en) + tr
wi(en) = hi(en,en) + ti
en = enm1
go to 220
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
!     ********** Last card of comqr **********
end subroutine comqr

pure subroutine cbabk2(nm,n,low,igh,scale,m,zr,zi)
!! <!-- nswc-ford:begin CBABK2 -->
!! Reference for `cbabk2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure
!!      cbabk2, which is a complex version of balbak,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!!      This subroutine forms the eigenvectors of a complex general
!!      matrix BY back transforming those of the corresponding
!!      balanced matrix determined by  cbal.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by  cbal,
!!         scale contains information determining the permutations
!!           and scaling factors used by  cbal,
!!         m is the number of eigenvectors to be back transformed,
!!         zr and zi contain the real and imaginary parts,
!!           respectively, of the eigenvectors to be
!!           back transformed in their first m columns.
!!      On output-
!!         zr and zi contain the real and imaginary parts,
!!           respectively, of the transformed eigenvectors
!!           in their first m columns.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: nm, igh, low
real, intent(in) :: scale(n)
real, intent(inout) :: zr(nm,m), zi(nm,m)
!     beginning of local variable declarations
integer :: i, j, k, ii
real :: s
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure
!     cbabk2, which is a complex version of balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!     This subroutine forms the eigenvectors of a complex general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by  cbal.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by  cbal,
!        scale contains information determining the permutations
!          and scaling factors used by  cbal,
!        m is the number of eigenvectors to be back transformed,
!        zr and zi contain the real and imaginary parts,
!          respectively, of the eigenvectors to be
!          back transformed in their first m columns.
!     On output-
!        zr and zi contain the real and imaginary parts,
!          respectively, of the transformed eigenvectors
!          in their first m columns.
!-----------------------------------------------------------------------
if (m == 0) go to 200
if (igh == low) go to 120
do i = low, igh
   s = scale(i)
!     ********** Left hand eigenvectors are back transformed
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
end do
!     ********** FOR i=low-1 STEP -1 UNTIL 1,
!                igh+1 STEP 1 UNTIL n DO -- **********
120 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 140
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 140
   do j = 1, m
      s = zr(i,j)
      zr(i,j) = zr(k,j)
      zr(k,j) = s
      s = zi(i,j)
      zi(i,j) = zi(k,j)
      zi(k,j) = s
   end do
140 continue
end do
200 return
!     ********** Last card of cbabk2 **********
end subroutine cbabk2

pure subroutine comqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi,ierr)
!! <!-- nswc-ford:begin COMQR2 -->
!! Reference for `comqr2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      integer min0
!!      real sqrt,cabs,abs,real,aimag
!!      complex csqrt,cmplx
!!
!!      This subroutine is a translation of a unitary analogue of the
!!      Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!!      and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!!      The unitary analogue substitutes the QR algorithm of Francis
!!      (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!!      This subroutine finds the eigenvalues and eigenvectors
!!      of a complex upper Hessenberg matrix BY the QR
!!      method.  The eigenvectors of a complex general matrix
!!      can also be found if  corth  has been used to reduce
!!      this general matrix to Hessenberg form.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine  cbal.  If  cbal  has not been used,
!!           set low=1, igh=n,
!!         ORTR and ORTI contain information about the unitary trans-
!!           formations used in the reduction by  corth, if performed.
!!           Only elements low through igh are used.  If the eigenvectors
!!           of the Hessenberg matrix are desired, set ORTR(j) and
!!           ORTI(j) to 0.0 for these elements,
!!         hr and hi contain the real and imaginary parts,
!!           respectively, of the complex upper Hessenberg matrix.
!!           Their lower triangles below the subdiagonal contain further
!!           information about the transformations which were used in the
!!           reduction by  corth, if performed.  If the eigenvectors of
!!           the Hessenberg matrix are desired, these elements may be
!!           arbitrary.
!!      On output-
!!         ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!!           have been destroyed,
!!         wr and wi contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  If an error
!!           exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         zr and ZI contain the real and imaginary parts,
!!           respectively, of the eigenvectors.  The eigenvectors
!!           are unnormalized.  If an error exit is made, none of
!!           the eigenvectors has been found,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 30 iterations.
!!      Arithmetic is real except for the replacement of the Algol
!!      procedure cdiv by complex division and use of the subroutines
!!      CSQRT and cmplx in computing complex square roots.
!!
!!      ********** machep is a machine dependent parameter specifying
!!                 the relative precision of floating point arithmetic.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(in) :: igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), wi(n), zr(nm,n), &
   & zi(nm,n), ortr(igh), orti(igh)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ii, jj, ll, nn, ip1, its, lp1, enm1, iend, nswc_ai_i4
real :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep
complex :: z3
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     integer min0
!     real sqrt,cabs,abs,real,aimag
!     complex csqrt,cmplx
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues and eigenvectors
!     of a complex upper Hessenberg matrix BY the QR
!     method.  The eigenvectors of a complex general matrix
!     can also be found if  corth  has been used to reduce
!     this general matrix to Hessenberg form.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          set low=1, igh=n,
!        ORTR and ORTI contain information about the unitary trans-
!          formations used in the reduction by  corth, if performed.
!          Only elements low through igh are used.  If the eigenvectors
!          of the Hessenberg matrix are desired, set ORTR(j) and
!          ORTI(j) to 0.0 for these elements,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain further
!          information about the transformations which were used in the
!          reduction by  corth, if performed.  If the eigenvectors of
!          the Hessenberg matrix are desired, these elements may be
!          arbitrary.
!     On output-
!        ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!          have been destroyed,
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        zr and ZI contain the real and imaginary parts,
!          respectively, of the eigenvectors.  The eigenvectors
!          are unnormalized.  If an error exit is made, none of
!          the eigenvectors has been found,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division and use of the subroutines
!     CSQRT and cmplx in computing complex square roots.
!-----------------------------------------------------------------------
!     ********** machep is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = spmpar(1)
!                **********
ierr = 0
!     ********** Initialize eigenvector matrix **********
do i = 1, n
   do j = 1, n
      zr(i,j) = 0.0
      zi(i,j) = 0.0
      if (i == j) zr(i,j) = 1.0
   end do
end do
!     ********** Form the matrix of accumulated transformations
!                from the information left by corth **********
iend = igh - low - 1
nswc_ai_i4 = iend
if (nswc_ai_i4 < 0) go to 180
if (nswc_ai_i4 == 0) go to 150
go to 105
!     ********** For i=igh-1 step -1 Until low+1 do -- **********
105 do ii = 1, iend
   i = igh - ii
   if (ortr(i) == 0.0 .and. orti(i) == 0.0) go to 140
   if (hr(i,i - 1) == 0.0 .and. hi(i,i - 1) == 0.0) go to 140
!     ********** norm below is negative of H formed in corth **********
   norm = hr(i,i - 1) * ortr(i) + hi(i,i - 1) * orti(i)
   ip1 = i + 1
   do k = ip1, igh
      ortr(k) = hr(k,i - 1)
      orti(k) = hi(k,i - 1)
   end do
   do j = i, igh
      sr = 0.0
      si = 0.0
      do k = i, igh
         sr = sr + ortr(k) * zr(k,j) + orti(k) * zi(k,j)
         si = si + ortr(k) * zi(k,j) - orti(k) * zr(k,j)
      end do
      sr = sr / norm
      si = si / norm
      do k = i, igh
         zr(k,j) = zr(k,j) + sr * ortr(k) - si * orti(k)
         zi(k,j) = zi(k,j) + sr * orti(k) + si * ortr(k)
      end do
   end do
140 continue
end do
!     ********** Create real subdiagonal elements **********
150 l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.0) go to 170
   norm = abs(cmplx(hr(i,i - 1),hi(i,i - 1)))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.0
   do j = i, n
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = 1, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
   do j = low, igh
      si = yr * zi(j,i) + yi * zr(j,i)
      zr(j,i) = yr * zr(j,i) - yi * zi(j,i)
      zi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by cbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.0
ti = 0.0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 680
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 30) go to 1000
if (its == 10 .or. its == 20) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.0 .and. xi == 0.0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.0
yi = (hi(enm1,enm1) - si) / 2.0
z3 = sqrt(cmplx(yr**2 - yi**2 + xr,2.0*yr*yi + xi))
zzr = real(z3)
zzi = aimag(z3)
if (yr * zzr + yi * zzi >= 0.0) go to 310
zzr = -zzr
zzi = -zzi
310 z3 = cmplx(xr,xi) / cmplx(yr + zzr,yi + zzi)
sr = sr - real(z3)
si = si - aimag(z3)
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.0
   hi(i,i - 1) = sr / norm
   do j = i, n
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.0) go to 540
norm = abs(cmplx(hr(en,en),si))
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.0
if (en == n) go to 540
ip1 = en + 1
do j = ip1, n
   yr = hr(en,j)
   yi = hi(en,j)
   hr(en,j) = sr * yr + si * yi
   hi(en,j) = sr * yi - si * yr
end do
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = 1, j
      yr = hr(i,j - 1)
      yi = 0.0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
   do i = low, igh
      yr = zr(i,j - 1)
      yi = zi(i,j - 1)
      zzr = zr(i,j)
      zzi = zi(i,j)
      zr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      zi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
      zr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      zi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.0) go to 240
do i = 1, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
do i = low, igh
   yr = zr(i,en)
   yi = zi(i,en)
   zr(i,en) = sr * yr - si * yi
   zi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 hr(en,en) = hr(en,en) + tr
wr(en) = hr(en,en)
hi(en,en) = hi(en,en) + ti
wi(en) = hi(en,en)
en = enm1
go to 220
!     ********** All roots found.  Backsubstitute to find
!                vectors of upper triangular form **********
680 norm = 0.0
do i = 1, n
   do j = i, n
      norm = norm + abs(hr(i,j)) + abs(hi(i,j))
   end do
end do
if (n == 1 .or. norm == 0.0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 2 DO -- **********
do nn = 2, n
   en = n + 2 - nn
   xr = wr(en)
   xi = wi(en)
   enm1 = en - 1
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, enm1
      i = en - ii
      zzr = hr(i,en)
      zzi = hi(i,en)
      if (i == enm1) go to 760
      ip1 = i + 1
      do j = ip1, enm1
         zzr = zzr + hr(i,j) * hr(j,en) - hi(i,j) * hi(j,en)
         zzi = zzi + hr(i,j) * hi(j,en) + hi(i,j) * hr(j,en)
      end do
760   yr = xr - wr(i)
      yi = xi - wi(i)
      if (yr == 0.0 .and. yi == 0.0) yr = machep * norm
      z3 = cmplx(zzr,zzi) / cmplx(yr,yi)
      hr(i,en) = real(z3)
      hi(i,en) = aimag(z3)
   end do
end do
!     ********** End backsubstitution **********
enm1 = n - 1
!     ********** Vectors of isolated roots **********
do i = 1, enm1
   if (i >= low .and. i <= igh) go to 840
   ip1 = i + 1
   do j = ip1, n
      zr(i,j) = hr(i,j)
      zi(i,j) = hi(i,j)
   end do
840 continue
end do
!     ********** Multiply by transformation matrix to give
!                vectors of original full matrix.
!                For j=n step -1 Until low+1 do -- **********
do jj = low, enm1
   j = n + low - jj
   m = min(j - 1,igh)
   do i = low, igh
      zzr = zr(i,j)
      zzi = zi(i,j)
      do k = low, m
         zzr = zzr + zr(i,k) * hr(k,j) - zi(i,k) * hi(k,j)
         zzi = zzi + zr(i,k) * hi(k,j) + zi(i,k) * hr(k,j)
      end do
      zr(i,j) = zzr
      zi(i,j) = zzi
   end do
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
!     ********** Last card of comqr2 **********
end subroutine comqr2

pure subroutine dceig(ibal,ar,ai,ka,n,wr,wi,ierr)
!! <!-- nswc-ford:begin DCEIG -->
!! Reference for `dceig`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             Eigenvalues of double precision complex matrices
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
double precision, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), &
   & wi(n)
!     beginning of local variable declarations
integer :: igh, low
interface
   pure subroutine dcbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      double precision, intent(inout) :: scale(n)
   end subroutine dcbal
   pure subroutine dcomqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      double precision, intent(inout) :: hr(nm,n)
      double precision, intent(inout) :: hi(nm,n)
      double precision, intent(inout) :: wr(n)
      double precision, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine dcomqr
   pure subroutine dcorth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      double precision, intent(inout) :: ortr(igh)
      double precision, intent(inout) :: orti(igh)
   end subroutine dcorth
end interface
!-----------------------------------------------------------------------
!            Eigenvalues of double precision complex matrices
!-----------------------------------------------------------------------
low = 1
igh = n
if (ibal /= 0) call dcbal(ka,n,ar,ai,low,igh,wr)
call dcorth(ka,n,low,igh,ar,ai,wr,wi)
call dcomqr(ka,n,low,igh,ar,ai,wr,wi,ierr)
end subroutine dceig

pure subroutine dceigv(ibal,ar,ai,ka,n,wr,wi,zr,zi,ierr,temp)
!! <!-- nswc-ford:begin DCEIGV -->
!! Reference for `dceigv`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                      Eigenvalues and eigenvectors
!!                  of double precision complex matrices
!!
!!      Temp is a temporary storage area
!!         DIMENSION(TEMP) .GE. 2*n    IF ibal .EQ. 0
!!         DIMENSION(TEMP) .GE. 3*n    IF ibal .NE. 0
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
double precision, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), &
   & wi(n), zr(ka,n), zi(ka,n), temp(*)
!     beginning of local variable declarations
integer :: i1, i2, i3, igh, low
interface
   pure subroutine dcbabk(nm,n,low,igh,scale,m,zr,zi)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      double precision, intent(in) :: scale(n)
      double precision, intent(inout) :: zr(nm,m)
      double precision, intent(inout) :: zi(nm,m)
   end subroutine dcbabk
   pure subroutine dcbal(nm,n,ar,ai,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      double precision, intent(inout) :: scale(n)
   end subroutine dcbal
   pure subroutine dcmqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi, &
      & ierr)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: ortr(igh)
      double precision, intent(inout) :: orti(igh)
      double precision, intent(inout) :: hr(nm,n)
      double precision, intent(inout) :: hi(nm,n)
      double precision, intent(inout) :: wr(n)
      double precision, intent(inout) :: wi(n)
      double precision, intent(inout) :: zr(nm,n)
      double precision, intent(inout) :: zi(nm,n)
      integer, intent(out) :: ierr
   end subroutine dcmqr2
   pure subroutine dcorth(nm,n,low,igh,ar,ai,ortr,orti)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      double precision, intent(inout) :: ar(nm,n)
      double precision, intent(inout) :: ai(nm,n)
      double precision, intent(inout) :: ortr(igh)
      double precision, intent(inout) :: orti(igh)
   end subroutine dcorth
end interface
!-----------------------------------------------------------------------
!                     Eigenvalues and eigenvectors
!                 of double precision complex matrices
!-----------------------------------------------------------------------
!----------------------
!     Temp is a temporary storage area
!        DIMENSION(TEMP) .GE. 2*n    IF ibal .EQ. 0
!        DIMENSION(TEMP) .GE. 3*n    IF ibal .NE. 0
!----------------------
i2 = 1
i3 = n + 1
i1 = n + i3
low = 1
igh = n
if (ibal /= 0) call dcbal(ka,n,ar,ai,low,igh,temp(i1))
call dcorth(ka,n,low,igh,ar,ai,temp(i2),temp(i3))
call dcmqr2(ka,n,low,igh,temp(i2),temp(i3),ar,ai,wr,wi, &
   & zr,zi,ierr)
if (ierr /= 0) return
if (ibal /= 0) call dcbabk(ka,n,low,igh,temp(i1),n,zr,zi)
end subroutine dceigv

pure subroutine dcbal(nm,n,ar,ai,low,igh,scale)
!! <!-- nswc-ford:begin DCBAL -->
!! Reference for `dcbal`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure
!!      CBALANCE, which is a complex version of balance,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!!      dcbal balances a double precision complex matrix and
!!      isolates eigenvalues whenever possible.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the complex matrix to be balanced.
!!      On output-
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the balanced matrix,
!!         low and igh are two integers such that ar(i,j) and ai(i,j)
!!           are equal to zero if
!!            (1) i is greater than j and
!!            (2) j=1,...,low-1 OR i=igh+1,...,n,
!!         scale contains information determining the
!!            permutations and scaling factors used.
!!      Suppose that the principal submatrix in rows low through igh
!!      has been balanced, that P(j) denotes the index interchanged
!!      with j during the permutation step, and that the elements
!!      of the diagonal matrix used are denoted by D(i,j).  Then
!!         scale(j) = P(j),    FOR j = 1,...,low-1
!!                  = D(j,j)       j = low,...,igh
!!                  = P(j)         j = igh+1,...,n.
!!      The order in which the interchanges are made is n to igh+1,
!!      then 1 to low-1.
!!      Note that 1 is returned for igh if igh is zero formally.
!!      The Algol procedure exc contained in CBALANCE appears in
!!      dcbal in line.  (Note that the Algol roles of identifiers
!!      k,l have been reversed.)
!!
!!      ********** radix is a machine dependent parameter specifying
!!                 the base of the machine floating point representation.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
double precision, intent(inout) :: ar(nm,n), ai(nm,n), scale(n)
!     beginning of local variable declarations
integer :: i, j, k, l, m, jj, iexc
double precision :: c, f, g, r, s, b2, radix
logical :: noconv
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure
!     CBALANCE, which is a complex version of balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!     dcbal balances a double precision complex matrix and
!     isolates eigenvalues whenever possible.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex matrix to be balanced.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the balanced matrix,
!        low and igh are two integers such that ar(i,j) and ai(i,j)
!          are equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!        scale contains information determining the
!           permutations and scaling factors used.
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j)       j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!     Note that 1 is returned for igh if igh is zero formally.
!     The Algol procedure exc contained in CBALANCE appears in
!     dcbal in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!-----------------------------------------------------------------------
!     ********** radix is a machine dependent parameter specifying
!                the base of the machine floating point representation.
radix = ipmpar(4)
!                **********
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** In-line procedure for row and
!                column exchange **********
20 scale(m) = j
if (j == m) go to 50
do i = 1, l
   f = ar(i,j)
   ar(i,j) = ar(i,m)
   ar(i,m) = f
   f = ai(i,j)
   ai(i,j) = ai(i,m)
   ai(i,m) = f
end do
do i = k, n
   f = ar(j,i)
   ar(j,i) = ar(m,i)
   ar(m,i) = f
   f = ai(j,i)
   ai(j,i) = ai(m,i)
   ai(m,i) = f
end do
50 select case (iexc)
case (1)
   go to 80
case (2)
   go to 130
end select
!     ********** Search for rows isolating an eigenvalue
!                and push them down **********
80 if (l == 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do jj = 1, l
   j = l + 1 - jj
   do i = 1, l
      if (i == j) go to 110
      if (ar(j,i) /= 0.d0 .or. ai(j,i) /= 0.d0) go to 120
110   continue
   end do
   m = l
   iexc = 1
   go to 20
120 continue
end do
go to 140
!     ********** Search for columns isolating an eigenvalue
!                and push them left **********
130 k = k + 1
140 do j = k, l
   do i = k, l
      if (i == j) go to 150
      if (ar(i,j) /= 0.d0 .or. ai(i,j) /= 0.d0) go to 170
150   continue
   end do
   m = k
   iexc = 2
   go to 20
170 continue
end do
!     ********** Now balance the submatrix in rows k to l **********
do i = k, l
   scale(i) = 1.d0
end do
!     ********** Iterative loop for norm reduction **********
190 noconv = .false.
do i = k, l
   c = 0.d0
   r = 0.d0
   do j = k, l
      if (j == i) go to 200
      c = c + abs(ar(j,i)) + abs(ai(j,i))
      r = r + abs(ar(i,j)) + abs(ai(i,j))
200   continue
   end do
!     ********** Guard against zero c or r due to underflow **********
   if (c == 0.d0 .or. r == 0.d0) go to 270
   g = r / radix
   f = 1.d0
   s = c + r
210 if (c >= g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c < g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** Now balance **********
240 if ((c + r) / f >= 0.95d0 * s) go to 270
   g = 1.d0 / f
   scale(i) = scale(i) * f
   noconv = .true.
   do j = k, n
      ar(i,j) = ar(i,j) * g
      ai(i,j) = ai(i,j) * g
   end do
   do j = 1, l
      ar(j,i) = ar(j,i) * f
      ai(j,i) = ai(j,i) * f
   end do
270 continue
end do
if (noconv) go to 190
280 low = k
igh = l
!     ********** Last card of dcbal **********
end subroutine dcbal

pure subroutine dcorth(nm,n,low,igh,ar,ai,ortr,orti)
!! <!-- nswc-ford:begin DCORTH -->
!! Reference for `dcorth`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of a complex analogue of
!!      the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!!      by Martin and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!!      Given a double precision complex matrix, dcorth
!!      reduces a submatrix situated in rows and columns
!!      low through igh to upper Hessenberg form by
!!      unitary similarity transformations.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dcbal.  If dcbal has not been used,
!!           set low=1, igh=n,
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the complex input matrix.
!!      On output-
!!         ar and ai contain the real and imaginary parts,
!!           respectively, of the Hessenberg matrix.  Information
!!           about the unitary transformations used in the reduction
!!           is stored in the remaining triangles under the
!!           Hessenberg matrix,
!!         ortr and ORTI contain further information about the
!!           transformations.  Only elements low through igh are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
double precision, intent(inout) :: ar(nm,n), ai(nm,n), ortr(igh), &
   & orti(igh)
!     beginning of local variable declarations
integer :: i, j, m, ii, jj, la, mp, kp1
double precision :: f, g, h, fi, fr, scale
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of a complex analogue of
!     the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!     by Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!     Given a double precision complex matrix, dcorth
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     unitary similarity transformations.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          set low=1, igh=n,
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex input matrix.
!     On output-
!        ar and ai contain the real and imaginary parts,
!          respectively, of the Hessenberg matrix.  Information
!          about the unitary transformations used in the reduction
!          is stored in the remaining triangles under the
!          Hessenberg matrix,
!        ortr and ORTI contain further information about the
!          transformations.  Only elements low through igh are used.
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
do m = kp1, la
   h = 0.d0
   ortr(m) = 0.d0
   orti(m) = 0.d0
   scale = 0.d0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do i = m, igh
      scale = scale + abs(ar(i,m - 1)) + abs(ai(i,m - 1))
   end do
   if (scale == 0.d0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ortr(i) = ar(i,m - 1) / scale
      orti(i) = ai(i,m - 1) / scale
      h = h + ortr(i) * ortr(i) + orti(i) * orti(i)
   end do
   g = sqrt(h)
   f = dcpabs(ortr(m),orti(m))
   if (f == 0.d0) go to 103
   h = h + f * g
   g = g / f
   ortr(m) = (1.d0 + g) * ortr(m)
   orti(m) = (1.d0 + g) * orti(m)
   go to 105
103 ortr(m) = g
   ar(m,m - 1) = scale
!     ********** FORM (i-(U*UT)/h) * A **********
105 do j = m, n
      fr = 0.d0
      fi = 0.d0
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
      do ii = m, igh
         i = mp - ii
         fr = fr + ortr(i) * ar(i,j) + orti(i) * ai(i,j)
         fi = fi + ortr(i) * ai(i,j) - orti(i) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do i = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(i) + fi * orti(i)
         ai(i,j) = ai(i,j) - fr * orti(i) - fi * ortr(i)
      end do
   end do
!     ********** FORM (i-(U*UT)/h)*A*(i-(U*UT)/h) **********
   do i = 1, igh
      fr = 0.d0
      fi = 0.d0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         fr = fr + ortr(j) * ar(i,j) - orti(j) * ai(i,j)
         fi = fi + ortr(j) * ai(i,j) + orti(j) * ar(i,j)
      end do
      fr = fr / h
      fi = fi / h
      do j = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(j) - fi * orti(j)
         ai(i,j) = ai(i,j) + fr * orti(j) - fi * ortr(j)
      end do
   end do
   ortr(m) = scale * ortr(m)
   orti(m) = scale * orti(m)
   ar(m,m - 1) = -g * ar(m,m - 1)
   ai(m,m - 1) = -g * ai(m,m - 1)
180 continue
end do
200 return
!     ********** Last card of dcorth **********
end subroutine dcorth

pure subroutine dcomqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
!! <!-- nswc-ford:begin DCOMQR -->
!! Reference for `dcomqr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of a unitary analogue of the
!!      Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!!      and Wilkinson.
!!      Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!!      The unitary analogue substitutes the QR algorithm of Francis
!!      (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!!      This subroutine finds the eigenvalues of a double precision
!!      complex upper Hessenberg matrix BY the QR method.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dcbal.  If dcbal has not been used,
!!           set low=1, igh=n,
!!         hr and hi contain the real and imaginary parts,
!!           respectively, of the complex upper Hessenberg matrix.
!!           Their lower triangles below the subdiagonal contain
!!           information about the unitary transformations used in
!!           the reduction by dcorth, if performed.
!!      On output-
!!         the upper Hessenberg portions of hr and hi have been
!!           destroyed.  Therefore, they must be saved before
!!           calling dcomqr if subsequent calculation of
!!           eigenvectors is to be performed,
!!         wr and WI contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  If an error
!!           exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 50 iterations.
!!
!!      ********** MACHEP is a machine dependent parameter specifying
!!                 the relative precision of floating point arithmetic.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
double precision, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), &
   & wi(n)
!     beginning of local variable declarations
integer :: i, j, l, en, ll, its, lp1, enm1
double precision :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep, r2, w(2), z(2)
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine dcsqrt(z,w)
      implicit none
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine dcsqrt
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues of a double precision
!     complex upper Hessenberg matrix BY the QR method.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          set low=1, igh=n,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain
!          information about the unitary transformations used in
!          the reduction by dcorth, if performed.
!     On output-
!        the upper Hessenberg portions of hr and hi have been
!          destroyed.  Therefore, they must be saved before
!          calling dcomqr if subsequent calculation of
!          eigenvectors is to be performed,
!        wr and WI contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** MACHEP is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = dpmpar(1)
!                **********
ierr = 0
if (low == igh) go to 180
!     ********** Create real subdiagonal elements **********
l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.d0) go to 170
   norm = dcpabs(hr(i,i - 1),hi(i,i - 1))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.d0
   do j = i, igh
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = low, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by dcbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.d0
ti = 0.d0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 1001
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low  -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 50) go to 1000
if (its == 10 .or. its == 20 .or. its == 30) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.d0 .and. xi == 0.d0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.d0
yi = (hi(enm1,enm1) - si) / 2.d0
z(1) = yr*yr - yi*yi + xr
z(2) = 2.d0*yr*yi + xi
call dcsqrt(z,w)
zzr = w(1)
zzi = w(2)
if (yr * zzr + yi * zzi >= 0.d0) go to 310
zzr = -zzr
zzi = -zzi
310 z(1) = yr + zzr
z(2) = yi + zzi
r2 = z(1)**2 + z(2)**2
sr = sr - (xr*z(1) + xi*z(2))/r2
si = si - (xi*z(1) - xr*z(2))/r2
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.d0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.d0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.d0
   hi(i,i - 1) = sr / norm
   do j = i, en
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.d0) go to 540
norm = dcpabs(hr(en,en),si)
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.d0
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = l, j
      yr = hr(i,j - 1)
      yi = 0.d0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.d0) go to 240
do i = l, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 wr(en) = hr(en,en) + tr
wi(en) = hi(en,en) + ti
en = enm1
go to 220
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = en
1001 return
end subroutine dcomqr

pure subroutine dcbabk(nm,n,low,igh,scale,m,zr,zi)
!! <!-- nswc-ford:begin DCBABK -->
!! Reference for `dcbabk`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of the Algol procedure
!!      cbabk2, which is a complex version of balbak,
!!      NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!!      This subroutine forms the eigenvectors of a double precision
!!      complex matrix BY back transforming those of the corresponding
!!      balanced matrix determined by dcbal.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by dcbal,
!!         scale contains information determining the permutations
!!           and scaling factors used by dcbal,
!!         m is the number of eigenvectors to be back transformed,
!!         zr and zi contain the real and imaginary parts,
!!           respectively, of the eigenvectors to be
!!           back transformed in their first m columns.
!!      On output-
!!         zr and zi contain the real and imaginary parts,
!!           respectively, of the transformed eigenvectors
!!           in their first m columns.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: nm, igh, low
double precision, intent(in) :: scale(n)
double precision, intent(inout) :: zr(nm,m), zi(nm,m)
!     beginning of local variable declarations
integer :: i, j, k, ii
double precision :: s
!-----------------------------------------------------------------------
!     This subroutine is a translation of the Algol procedure
!     cbabk2, which is a complex version of balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!     This subroutine forms the eigenvectors of a double precision
!     complex matrix BY back transforming those of the corresponding
!     balanced matrix determined by dcbal.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by dcbal,
!        scale contains information determining the permutations
!          and scaling factors used by dcbal,
!        m is the number of eigenvectors to be back transformed,
!        zr and zi contain the real and imaginary parts,
!          respectively, of the eigenvectors to be
!          back transformed in their first m columns.
!     On output-
!        zr and zi contain the real and imaginary parts,
!          respectively, of the transformed eigenvectors
!          in their first m columns.
!-----------------------------------------------------------------------
if (m == 0) go to 200
if (igh == low) go to 120
do i = low, igh
   s = scale(i)
!     ********** Left hand eigenvectors are back transformed
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
end do
!     ********** FOR i=low-1 STEP -1 UNTIL 1,
!                igh+1 STEP 1 UNTIL n DO -- **********
120 do ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 140
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 140
   do j = 1, m
      s = zr(i,j)
      zr(i,j) = zr(k,j)
      zr(k,j) = s
      s = zi(i,j)
      zi(i,j) = zi(k,j)
      zi(k,j) = s
   end do
140 continue
end do
200 return
!     ********** Last card of dcbabk **********
end subroutine dcbabk

pure subroutine dcmqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi,ierr)
!! <!-- nswc-ford:begin DCMQR2 -->
!! Reference for `dcmqr2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This subroutine is a translation of a unitary analogue of the
!!      Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!!      and Wilkinson.
!!      Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!!      The unitary analogue substitutes the QR algorithm of Francis
!!      (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!!      This subroutine finds the eigenvalues and eigenvectors of
!!      a double precision complex upper Hessenberg matrix BY the
!!      QR method.  The eigenvectors of a complex general matrix
!!      can also be found if dcorth has been used to reduce
!!      this general matrix to Hessenberg form.
!!      On input-
!!         nm must be set to the row dimension of two-dimensional
!!           array parameters as declared in the calling program
!!           dimension statement,
!!         n is the order of the matrix,
!!         low and igh are integers determined by the balancing
!!           subroutine dcbal.  If dcbal has not been used,
!!           set low=1, igh=n,
!!         ORTR and ORTI contain information about the unitary trans-
!!           formations used in the reduction by dcorth, if performed.
!!           Only elements low through igh are used.  If the eigenvectors
!!           of the Hessenberg matrix are desired, set ORTR(j) and
!!           ORTI(j) to 0.0 for these elements,
!!         hr and hi contain the real and imaginary parts,
!!           respectively, of the complex upper Hessenberg matrix.
!!           Their lower triangles below the subdiagonal contain further
!!           information about the transformations which were used in the
!!           reduction by dcorth, if performed.  If the eigenvectors of
!!           the Hessenberg matrix are desired, these elements may be
!!           arbitrary.
!!      On output-
!!         ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!!           have been destroyed,
!!         wr and WI contain the real and imaginary parts,
!!           respectively, of the eigenvalues.  If an error
!!           exit is made, the eigenvalues should be correct
!!           for indices ierr+1,...,n,
!!         ZR and ZI contain the real and imaginary parts,
!!           respectively, of the eigenvectors.  The eigenvectors
!!           are unnormalized.  If an error exit is made, none of
!!           the eigenvectors has been found,
!!         ierr is set to
!!           ZERO       FOR NORMAL RETURN,
!!           j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!!                      determined after 50 iterations.
!!
!!      ********** MACHEP is a machine dependent parameter specifying
!!                 the relative precision of floating point arithmetic.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(in) :: igh
integer, intent(in) :: low
integer, intent(out) :: ierr
double precision, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), &
   & wi(n), zr(nm,n), zi(nm,n), ortr(igh), orti(igh)
!     beginning of local variable declarations
integer :: i, j, k, l, m, en, ii, jj, ll, nn, ip1, its, lp1, enm1, iend, nswc_ai_i4
double precision :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep, r2, w(2), z(2)
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
   pure subroutine dcsqrt(z,w)
      implicit none
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine dcsqrt
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!     This subroutine finds the eigenvalues and eigenvectors of
!     a double precision complex upper Hessenberg matrix BY the
!     QR method.  The eigenvectors of a complex general matrix
!     can also be found if dcorth has been used to reduce
!     this general matrix to Hessenberg form.
!     On input-
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!        n is the order of the matrix,
!        low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          set low=1, igh=n,
!        ORTR and ORTI contain information about the unitary trans-
!          formations used in the reduction by dcorth, if performed.
!          Only elements low through igh are used.  If the eigenvectors
!          of the Hessenberg matrix are desired, set ORTR(j) and
!          ORTI(j) to 0.0 for these elements,
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain further
!          information about the transformations which were used in the
!          reduction by dcorth, if performed.  If the eigenvectors of
!          the Hessenberg matrix are desired, these elements may be
!          arbitrary.
!     On output-
!        ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!          have been destroyed,
!        wr and WI contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!        ZR and ZI contain the real and imaginary parts,
!          respectively, of the eigenvectors.  The eigenvectors
!          are unnormalized.  If an error exit is made, none of
!          the eigenvectors has been found,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!-----------------------------------------------------------------------
!     ********** MACHEP is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
machep = dpmpar(1)
!                **********
ierr = 0
!     ********** Initialize eigenvector matrix **********
do i = 1, n
   do j = 1, n
      zr(i,j) = 0.d0
      zi(i,j) = 0.d0
      if (i == j) zr(i,j) = 1.d0
   end do
end do
!     ********** Form the matrix of accumulated transformations
!                from the information left by dcorth **********
iend = igh - low - 1
nswc_ai_i4 = iend
if (nswc_ai_i4 < 0) go to 180
if (nswc_ai_i4 == 0) go to 150
go to 105
!     ********** For i=igh-1 step -1 Until low+1 do -- **********
105 do ii = 1, iend
   i = igh - ii
   if (ortr(i) == 0.d0 .and. orti(i) == 0.d0) go to 140
   if (hr(i,i - 1) == 0.d0 .and. hi(i,i - 1) == 0.d0) go to 140
!     ********** Norm below is negative of H formed in dcorth **********
   norm = hr(i,i - 1) * ortr(i) + hi(i,i - 1) * orti(i)
   ip1 = i + 1
   do k = ip1, igh
      ortr(k) = hr(k,i - 1)
      orti(k) = hi(k,i - 1)
   end do
   do j = i, igh
      sr = 0.d0
      si = 0.d0
      do k = i, igh
         sr = sr + ortr(k) * zr(k,j) + orti(k) * zi(k,j)
         si = si + ortr(k) * zi(k,j) - orti(k) * zr(k,j)
      end do
      sr = sr / norm
      si = si / norm
      do k = i, igh
         zr(k,j) = zr(k,j) + sr * ortr(k) - si * orti(k)
         zi(k,j) = zi(k,j) + sr * orti(k) + si * ortr(k)
      end do
   end do
140 continue
end do
!     ********** Create real subdiagonal elements **********
150 l = low + 1
do i = l, igh
   ll = min(i + 1,igh)
   if (hi(i,i - 1) == 0.d0) go to 170
   norm = dcpabs(hr(i,i - 1),hi(i,i - 1))
   yr = hr(i,i - 1) / norm
   yi = hi(i,i - 1) / norm
   hr(i,i - 1) = norm
   hi(i,i - 1) = 0.d0
   do j = i, n
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
   do j = 1, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
   do j = low, igh
      si = yr * zi(j,i) + yi * zr(j,i)
      zr(j,i) = yr * zr(j,i) - yi * zi(j,i)
      zi(j,i) = si
   end do
170 continue
end do
!     ********** Store roots isolated by dcbal **********
180 do i = 1, n
   if (i >= low .and. i <= igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
end do
en = igh
tr = 0.d0
ti = 0.d0
!     ********** Search for next eigenvalue **********
220 if (en < low) go to 680
its = 0
enm1 = en - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
240 do ll = low, en
   l = en + low - ll
   if (l == low) exit
   if (abs(hr(l,l - 1)) <= &
      & machep * (abs(hr(l - 1,l - 1)) + abs(hi(l - 1,l - 1)) &
      & + abs(hr(l,l)) + abs(hi(l,l)))) go to 300
end do
!     ********** Form shift **********
300 if (l == en) go to 660
if (its == 50) go to 1000
if (its == 10 .or. its == 20 .or. its == 30) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr == 0.d0 .and. xi == 0.d0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.d0
yi = (hi(enm1,enm1) - si) / 2.d0
z(1) = yr*yr - yi*yi + xr
z(2) = 2.d0*yr*yi + xi
call dcsqrt(z,w)
zzr = w(1)
zzi = w(2)
if (yr * zzr + yi * zzi >= 0.d0) go to 310
zzr = -zzr
zzi = -zzi
310 z(1) = yr + zzr
z(2) = yi + zzi
r2 = z(1)**2 + z(2)**2
sr = sr - (xr*z(1) + xi*z(2))/r2
si = si - (xi*z(1) - xr*z(2))/r2
go to 340
!     ********** Form exceptional shift **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en - 2))
si = 0.d0
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** Reduce to triangle (rows) **********
lp1 = l + 1
do i = lp1, en
   sr = hr(i,i - 1)
   hr(i,i - 1) = 0.d0
   norm = sqrt(hr(i - 1,i - 1)*hr(i - 1,i - 1) + hi(i - 1,i - 1)*hi(i - 1,i - 1) &
      & + sr*sr)
   xr = hr(i - 1,i - 1) / norm
   wr(i - 1) = xr
   xi = hi(i - 1,i - 1) / norm
   wi(i - 1) = xi
   hr(i - 1,i - 1) = norm
   hi(i - 1,i - 1) = 0.d0
   hi(i,i - 1) = sr / norm
   do j = i, n
      yr = hr(i - 1,j)
      yi = hi(i - 1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i - 1,j) = xr * yr + xi * yi + hi(i,i - 1) * zzr
      hi(i - 1,j) = xr * yi - xi * yr + hi(i,i - 1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i - 1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i - 1) * yi
   end do
end do
si = hi(en,en)
if (si == 0.d0) go to 540
norm = dcpabs(hr(en,en),si)
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.d0
if (en == n) go to 540
ip1 = en + 1
do j = ip1, n
   yr = hr(en,j)
   yi = hi(en,j)
   hr(en,j) = sr * yr + si * yi
   hi(en,j) = sr * yi - si * yr
end do
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j - 1)
   xi = wi(j - 1)
   do i = 1, j
      yr = hr(i,j - 1)
      yi = 0.d0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i == j) go to 560
      yi = hi(i,j - 1)
      hi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
560   hr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
   do i = low, igh
      yr = zr(i,j - 1)
      yi = zi(i,j - 1)
      zzr = zr(i,j)
      zzi = zi(i,j)
      zr(i,j - 1) = xr * yr - xi * yi + hi(j,j - 1) * zzr
      zi(i,j - 1) = xr * yi + xi * yr + hi(j,j - 1) * zzi
      zr(i,j) = xr * zzr + xi * zzi - hi(j,j - 1) * yr
      zi(i,j) = xr * zzi - xi * zzr - hi(j,j - 1) * yi
   end do
end do
if (si == 0.d0) go to 240
do i = 1, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
do i = low, igh
   yr = zr(i,en)
   yi = zi(i,en)
   zr(i,en) = sr * yr - si * yi
   zi(i,en) = sr * yi + si * yr
end do
go to 240
!     ********** A ROOT FOUND **********
660 hr(en,en) = hr(en,en) + tr
wr(en) = hr(en,en)
hi(en,en) = hi(en,en) + ti
wi(en) = hi(en,en)
en = enm1
go to 220
!     ********** All roots found.  Backsubstitute to find
!                vectors of upper triangular form **********
680 norm = 0.d0
do i = 1, n
   do j = i, n
      norm = norm + abs(hr(i,j)) + abs(hi(i,j))
   end do
end do
if (n == 1 .or. norm == 0.d0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 2 DO -- **********
do nn = 2, n
   en = n + 2 - nn
   xr = wr(en)
   xi = wi(en)
   enm1 = en - 1
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do ii = 1, enm1
      i = en - ii
      zzr = hr(i,en)
      zzi = hi(i,en)
      if (i == enm1) go to 760
      ip1 = i + 1
      do j = ip1, enm1
         zzr = zzr + hr(i,j) * hr(j,en) - hi(i,j) * hi(j,en)
         zzi = zzi + hr(i,j) * hi(j,en) + hi(i,j) * hr(j,en)
      end do
760   yr = xr - wr(i)
      yi = xi - wi(i)
      if (yr == 0.d0 .and. yi == 0.d0) yr = machep * norm
      r2 = yr*yr + yi*yi
      hr(i,en) = (zzr*yr + zzi*yi)/r2
      hi(i,en) = (zzi*yr - zzr*yi)/r2
   end do
end do
!     ********** End backsubstitution **********
enm1 = n - 1
!     ********** Vectors of isolated roots **********
do i = 1, enm1
   if (i >= low .and. i <= igh) go to 840
   ip1 = i + 1
   do j = ip1, n
      zr(i,j) = hr(i,j)
      zi(i,j) = hi(i,j)
   end do
840 continue
end do
!     ********** Multiply by transformation matrix to give
!                vectors of original full matrix.
!                For j=n step -1 Until low+1 do -- **********
do jj = low, enm1
   j = n + low - jj
   m = min(j - 1,igh)
   do i = low, igh
      zzr = zr(i,j)
      zzi = zi(i,j)
      do k = low, m
         zzr = zzr + zr(i,k) * hr(k,j) - zi(i,k) * hi(k,j)
         zzi = zzi + zr(i,k) * hi(k,j) + zi(i,k) * hr(k,j)
      end do
      zr(i,j) = zzr
      zi(i,j) = zzi
   end do
end do
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 50 iterations **********
1000 ierr = en
1001 return
!     ********** Last card of dcmqr2 **********
end subroutine dcmqr2

pure subroutine cl1(k, l, m, n, q, kq, kode, toler, iter, x, res, &
   & error, wk, iwk)
!! <!-- nswc-ford:begin CL1 -->
!! Reference for `cl1`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: iter, iwk(*)
integer, intent(in) :: k
integer, intent(inout) :: kode
integer, intent(in) :: kq, l, m, n
real, intent(inout) :: error, q(kq,*), res(*)
real, intent(in) :: toler
real, intent(inout) :: wk(*), x(*)
!     beginning of local variable declarations
integer :: klm
interface
   pure subroutine xl1(k,l,m,n,klmd,klm2d,nklmd,n2d,q,kode, &
      & toler,iter,x,res,error,cu,iu,s)
      implicit none
      integer, intent(in) :: n2d
      integer, intent(in) :: nklmd
      integer, intent(in) :: klm2d
      integer, intent(in) :: klmd
      integer, intent(in) :: k
      integer, intent(in) :: l
      integer, intent(in) :: m
      integer, intent(in) :: n
      real, intent(inout) :: q(klm2d,n2d)
      integer, intent(inout) :: kode
      real, intent(in) :: toler
      integer, intent(inout) :: iter
      real, intent(inout) :: x(n2d)
      real, intent(inout) :: res(klmd)
      real, intent(inout) :: error
      real, intent(inout) :: cu(2,nklmd)
      integer, intent(inout) :: iu(2,nklmd)
      integer, intent(inout) :: s(klmd)
   end subroutine xl1
end interface
!     -------------------
klm = k + l + m
call xl1(k, l, m, n, klm, kq, klm + n, n + 2, q, kode, toler, &
   & iter, x, res, error, wk, iwk(klm + 1), iwk(1))
end subroutine cl1

pure subroutine xl1(k, l, m, n, klmd, klm2d, nklmd, n2d, &
   & q, kode, toler, iter, x, res, error, cu, iu, s)
!! <!-- nswc-ford:begin XL1 -->
!! Reference for `xl1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  This subroutine uses a modification of the simplex
!!  method of linear programming to calculate an L1 solution
!!  to A k by n system of linear equations
!!              ax=b
!!  subject to l linear equality constraints
!!              cx=d
!!  and m linear inequality constraints
!!              EX.LE.F.
!!  Description of parameters
!!  k      number of rows of the matrix A (k.GE.1).
!!  l      number of rows of the matrix C (l.GE.0).
!!  m      number of rows of the matrix E (m.GE.0).
!!  n      number of columns of the matrices A,C,E (n.GE.1).
!!  klmd   SET TO AT LEAST k+l+m FOR ADJUSTABLE DIMENSIONS.
!!  klm2d  set to at least k+l+m+2 for adjustable dimensions.
!!  nklmd  set to at least n+k+l+m for adjustable dimensions.
!!  n2d    SET TO AT LEAST n+2 FOR ADJUSTABLE DIMENSIONS
!!  q      TWO DIMENSIONAL REAL ARRAY WITH klm2d ROWS AND
!!         at least n2d columns.
!!         On entry the matrices A,C and E, and the vectors
!!         B,D and F must be stored in the first k+l+m rows
!!         and n+1 columns of q as follows
!!              A B
!!          q = C D
!!              E F
!!         these values are destroyed by the subroutine.
!!  kode   A CODE USED ON ENTRY TO, AND EXIT
!!         from, the subroutine.
!!         On entry, this should normally be set to 0.
!!         However, if certain nonnegativity constraints
!!         are to be included implicitly, rather than
!!         explicitly in the constraints EX.LE.F, then kode
!!         should be set to 1, and the nonnegativity
!!         constraints included in the arrays x and
!!         res (see below).
!!         On exit, kode has one of the
!!         following values
!!              0- optimal solution found,
!!              1- no feasible solution to the
!!                 constraints,
!!              2- calculations terminated
!!                 prematurely due to rounding errors,
!!              3- maximum number of iterations reached.
!!  toler  a small positive tolerance. Empirical
!!         evidence suggests toler = 10**(-D*2/3),
!!         where D represents the number of decimal
!!         digits of accuracy available. Essentially,
!!         the subroutine CANNOT distinguish between zero
!!         and any quantity whose magnitude does not exceed
!!         toler. In particular, it will not pivot on any
!!         number whose magnitude does not exceed toler.
!!  ITER   ON ENTRY ITER MUST CONTAIN AN UPPER BOUND ON
!!         the maximum number of iterations allowed.
!!         A suggested value is 10*(k+l+m). On exit iter
!!         gives the number of simplex iterations.
!!  x      ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST n2d.
!!         On exit this array contains A
!!         solution to the L1 problem. If kode=1
!!         on entry, this array is also used to include
!!         simple nonnegativity constraints on the
!!         variables. The values -1, 0, or 1
!!         for x(j) indicate that the j-TH variable
!!         is restricted to be .LE.0, unrestricted,
!!         OR .GE.0 RESPECTIVELY.
!!  RES    ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST klmd.
!!         On exit this contains the residuals B-AX
!!         in the first k components, D-CX in the
!!         NEXT l COMPONENTS (THESE WILL BE =0),AND
!!         F-EX in the next m components. If kode=1 On
!!         entry, this array is also used to include simple
!!         nonnegativity constraints on the residuals
!!         B-AX. The values -1, 0, or 1 for res(i)
!!         indicate that the i-TH residual (1.le.i.le.k) is
!!         restricted to be .LE.0, unrestricted, or .GE.0
!!         respectively.
!!  Error  on exit, this gives the minimum sum of
!!         absolute values of the residuals.
!!  cu     A TWO DIMENSIONAL REAL ARRAY WITH TWO ROWS AND
!!         at least nklmd columns used for workspace.
!!  iu     A TWO DIMENSIONAL INTEGER ARRAY WITH TWO ROWS AND
!!         at least nklmd columns used for workspace.
!!  s      INTEGER ARRAY OF SIZE AT LEAST klmd, USED FOR
!!         workspace.
!!  If your Fortran compiler permits a single column of a two
!!  dimensional array to be passed to a one dimensional array
!!  through a subroutine CALL, considerable savings in
!!  execution time may be achieved through the use of the
!!  following subroutine, which operates on column vectors.
!!      subroutine col(v1, v2, xmlt, notrow, k)
!!  this subroutine adds to the vector v1 a multiple of the
!!  vector v2 (elements 1 through k excluding NOTROW).
!!      dimension v1(k), v2(k)
!!      kend = notrow - 1
!!      kstart = notrow + 1
!!      if (kend .lt. 1) go to 20
!!      do 10 i=1,kend
!!         v1(i) = v1(i) + xmlt*v2(i)
!!   10 continue
!!      if(kstart .gt. k) go to 40
!!   20 do 30 i=kstart,k
!!        v1(i) = v1(i) + xmlt*v2(i)
!!   30 continue
!!   40 return
!!      end
!!  see comments following statement labelled 440 for
!!  instructions on the implementation of this modification.
!!  Initialization.
!! ```
!! <!-- nswc-ford:end -->
implicit none
! This subroutine uses a modification of the simplex
! method of linear programming to calculate an L1 solution
! to A k by n system of linear equations
!             ax=b
! subject to l linear equality constraints
!             cx=d
! and m linear inequality constraints
!             EX.LE.F.
! Description of parameters
! k      number of rows of the matrix A (k.GE.1).
! l      number of rows of the matrix C (l.GE.0).
! m      number of rows of the matrix E (m.GE.0).
! n      number of columns of the matrices A,C,E (n.GE.1).
! klmd   SET TO AT LEAST k+l+m FOR ADJUSTABLE DIMENSIONS.
! klm2d  set to at least k+l+m+2 for adjustable dimensions.
! nklmd  set to at least n+k+l+m for adjustable dimensions.
! n2d    SET TO AT LEAST n+2 FOR ADJUSTABLE DIMENSIONS
! q      TWO DIMENSIONAL REAL ARRAY WITH klm2d ROWS AND
!        at least n2d columns.
!        On entry the matrices A,C and E, and the vectors
!        B,D and F must be stored in the first k+l+m rows
!        and n+1 columns of q as follows
!             A B
!         q = C D
!             E F
!        these values are destroyed by the subroutine.
! kode   A CODE USED ON ENTRY TO, AND EXIT
!        from, the subroutine.
!        On entry, this should normally be set to 0.
!        However, if certain nonnegativity constraints
!        are to be included implicitly, rather than
!        explicitly in the constraints EX.LE.F, then kode
!        should be set to 1, and the nonnegativity
!        constraints included in the arrays x and
!        res (see below).
!        On exit, kode has one of the
!        following values
!             0- optimal solution found,
!             1- no feasible solution to the
!                constraints,
!             2- calculations terminated
!                prematurely due to rounding errors,
!             3- maximum number of iterations reached.
! toler  a small positive tolerance. Empirical
!        evidence suggests toler = 10**(-D*2/3),
!        where D represents the number of decimal
!        digits of accuracy available. Essentially,
!        the subroutine CANNOT distinguish between zero
!        and any quantity whose magnitude does not exceed
!        toler. In particular, it will not pivot on any
!        number whose magnitude does not exceed toler.
! ITER   ON ENTRY ITER MUST CONTAIN AN UPPER BOUND ON
!        the maximum number of iterations allowed.
!        A suggested value is 10*(k+l+m). On exit iter
!        gives the number of simplex iterations.
! x      ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST n2d.
!        On exit this array contains A
!        solution to the L1 problem. If kode=1
!        on entry, this array is also used to include
!        simple nonnegativity constraints on the
!        variables. The values -1, 0, or 1
!        for x(j) indicate that the j-TH variable
!        is restricted to be .LE.0, unrestricted,
!        OR .GE.0 RESPECTIVELY.
! RES    ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST klmd.
!        On exit this contains the residuals B-AX
!        in the first k components, D-CX in the
!        NEXT l COMPONENTS (THESE WILL BE =0),AND
!        F-EX in the next m components. If kode=1 On
!        entry, this array is also used to include simple
!        nonnegativity constraints on the residuals
!        B-AX. The values -1, 0, or 1 for res(i)
!        indicate that the i-TH residual (1.le.i.le.k) is
!        restricted to be .LE.0, unrestricted, or .GE.0
!        respectively.
! Error  on exit, this gives the minimum sum of
!        absolute values of the residuals.
! cu     A TWO DIMENSIONAL REAL ARRAY WITH TWO ROWS AND
!        at least nklmd columns used for workspace.
! iu     A TWO DIMENSIONAL INTEGER ARRAY WITH TWO ROWS AND
!        at least nklmd columns used for workspace.
! s      INTEGER ARRAY OF SIZE AT LEAST klmd, USED FOR
!        workspace.
! If your Fortran compiler permits a single column of a two
! dimensional array to be passed to a one dimensional array
! through a subroutine CALL, considerable savings in
! execution time may be achieved through the use of the
! following subroutine, which operates on column vectors.
!     subroutine col(v1, v2, xmlt, notrow, k)
! this subroutine adds to the vector v1 a multiple of the
! vector v2 (elements 1 through k excluding NOTROW).
!     dimension v1(k), v2(k)
!     kend = notrow - 1
!     kstart = notrow + 1
!     if (kend .lt. 1) go to 20
!     do 10 i=1,kend
!        v1(i) = v1(i) + xmlt*v2(i)
!  10 continue
!     if(kstart .gt. k) go to 40
!  20 do 30 i=kstart,k
!       v1(i) = v1(i) + xmlt*v2(i)
!  30 continue
!  40 return
!     end
! see comments following statement labelled 440 for
! instructions on the implementation of this modification.
real, intent(inout) :: q, x
real, intent(inout) :: cu
real, intent(inout) :: res
real, intent(inout) :: error
real, intent(in) :: toler
integer, intent(in) :: k, l, m, n
integer, intent(inout) :: s
integer, intent(inout) :: iu
integer, intent(in) :: n2d
integer, intent(inout) :: iter
integer, intent(in) :: klmd
integer, intent(inout) :: kode
integer, intent(in) :: klm2d
integer, intent(in) :: nklmd
dimension q(klm2d,n2d), x(n2d), res(klmd), cu(2,nklmd), &
   & iu(2,nklmd), s(klmd)
!     beginning of local variable declarations
double precision :: sum
real :: z, sn, zu, zv, cuv, xmax, xmin, pivot, tpivot, nswc_ai_r4
integer :: i, j, ia, ii, in, js, kk, nk, n1, n2, jmn, jpn, klm, nkl, nk1, iimn, iout, klm1, klm2, nklm, nkl1, maxit, iphase, &
   & kforce, iineg
! Initialization.
maxit = iter
n1 = n + 1
n2 = n + 2
nk = n + k
nk1 = nk + 1
nkl = nk + l
nkl1 = nkl + 1
klm = k + l + m
klm1 = klm + 1
klm2 = klm + 2
nklm = n + klm
kforce = 1
iter = 0
js = 1
ia = 0
! Set up labels in q.
do j = 1,n
   q(klm2,j) = j
end do
do i = 1,klm
   q(i,n2) = n + i
   if (q(i,n1) >= 0.) go to 30
   do j = 1,n2
      q(i,j) = -q(i,j)
   end do
30 continue
end do
! Set up phase 1 costs.
iphase = 2
do j = 1,nklm
   cu(1,j) = 0.
   cu(2,j) = 0.
   iu(1,j) = 0
   iu(2,j) = 0
end do
if (l == 0) go to 60
do j = nk1,nkl
   cu(1,j) = 1.
   cu(2,j) = 1.
   iu(1,j) = 1
   iu(2,j) = 1
end do
iphase = 1
60 if (m == 0) go to 80
do j = nkl1,nklm
   cu(2,j) = 1.
   iu(2,j) = 1
   jmn = j - n
   if (q(jmn,n2) < 0.) iphase = 1
end do
80 if (kode == 0) go to 150
do j = 1,n
   nswc_ai_r4 = x(j)
   if (nswc_ai_r4 < 0) go to 90
   if (nswc_ai_r4 == 0) go to 110
   go to 100
90 cu(1,j) = 1.
   iu(1,j) = 1
   go to 110
100 cu(2,j) = 1.
   iu(2,j) = 1
110 continue
end do
do j = 1,k
   jpn = j + n
   nswc_ai_r4 = res(j)
   if (nswc_ai_r4 < 0) go to 120
   if (nswc_ai_r4 == 0) go to 140
   go to 130
120 cu(1,jpn) = 1.
   iu(1,jpn) = 1
   if (q(j,n2) > 0.0) iphase = 1
   go to 140
130 cu(2,jpn) = 1.
   iu(2,jpn) = 1
   if (q(j,n2) < 0.0) iphase = 1
140 continue
end do
150 if (iphase == 2) go to 500
! Compute the marginal costs.
160 do j = js,n1
   sum = 0.d0
   do i = 1,klm
      ii = q(i,n2)
      if (ii < 0) go to 170
      z = cu(1,ii)
      go to 180
170   iineg = -ii
      z = cu(2,iineg)
180   sum = sum + dble(q(i,j))*dble(z)
   end do
   q(klm1,j) = sum
end do
do j = js,n
   ii = q(klm2,j)
   if (ii < 0) go to 210
   z = cu(1,ii)
   go to 220
210 iineg = -ii
   z = cu(2,iineg)
220 q(klm1,j) = q(klm1,j) - z
end do
! Determine the vector to enter the basis.
240 xmax = 0.
if (js > n) go to 490
do j = js,n
   zu = q(klm1,j)
   ii = q(klm2,j)
   if (ii > 0) go to 250
   ii = -ii
   zv = zu
   zu = -zu - cu(1,ii) - cu(2,ii)
   go to 260
250 zv = -zu - cu(1,ii) - cu(2,ii)
260 if (kforce == 1 .and. ii > n) go to 280
   if (iu(1,ii) == 1) go to 270
   if (zu <= xmax) go to 270
   xmax = zu
   in = j
270 if (iu(2,ii) == 1) go to 280
   if (zv <= xmax) go to 280
   xmax = zv
   in = j
280 continue
end do
if (xmax <= toler) go to 490
if (q(klm1,in) == xmax) go to 300
do i = 1,klm2
   q(i,in) = -q(i,in)
end do
q(klm1,in) = xmax
! Determine the vector to leave the basis.
300 if (iphase == 1 .or. ia == 0) go to 330
xmax = 0.
do i = 1,ia
   z = abs(q(i,in))
   if (z <= xmax) go to 310
   xmax = z
   iout = i
310 continue
end do
if (xmax <= toler) go to 330
do j = 1,n2
   z = q(ia,j)
   q(ia,j) = q(iout,j)
   q(iout,j) = z
end do
iout = ia
ia = ia - 1
pivot = q(iout,in)
go to 420
330 kk = 0
do i = 1,klm
   z = q(i,in)
   if (z <= toler) go to 340
   kk = kk + 1
   res(kk) = q(i,n1)/z
   s(kk) = i
340 continue
end do
350 if (kk > 0) go to 360
kode = 2
go to 590
360 xmin = res(1)
iout = s(1)
j = 1
if (kk == 1) go to 380
do i = 2,kk
   if (res(i) >= xmin) go to 370
   j = i
   xmin = res(i)
   iout = s(i)
370 continue
end do
res(j) = res(kk)
s(j) = s(kk)
380 kk = kk - 1
pivot = q(iout,in)
ii = q(iout,n2)
if (iphase == 1) go to 400
if (ii < 0) go to 390
if (iu(2,ii) == 1) go to 420
go to 400
390 iineg = -ii
if (iu(1,iineg) == 1) go to 420
400 ii = abs(ii)
cuv = cu(1,ii) + cu(2,ii)
if (q(klm1,in) - pivot*cuv <= toler) go to 420
! Bypass intermediate vertices.
do j = js,n1
   z = q(iout,j)
   q(klm1,j) = q(klm1,j) - z*cuv
   q(iout,j) = -z
end do
q(iout,n2) = -q(iout,n2)
go to 350
! Gauss-Jordan elimination.
420 if (iter < maxit) go to 430
kode = 3
go to 590
430 iter = iter + 1
do j = js,n1
   if (j /= in) q(iout,j) = q(iout,j)/pivot
end do
! If permitted, use subroutine col of the description
! section and replace the following seven statements down
! to and including statement number 460 by..
!     do 460 j=js,n1
!        if(j .eq. in) go to 460
!        z = -q(iout,j)
!        call col(q(1,j), q(1,in), z, iout, klm1)
! 460 continue
do j = js,n1
   if (j == in) go to 460
   z = -q(iout,j)
   do i = 1,klm1
      if (i /= iout) q(i,j) = q(i,j) + z*q(i,in)
   end do
460 continue
end do
tpivot = -pivot
do i = 1,klm1
   if (i /= iout) q(i,in) = q(i,in)/tpivot
end do
q(iout,in) = 1./pivot
z = q(iout,n2)
q(iout,n2) = q(klm2,in)
q(klm2,in) = z
ii = abs(z)
if (iu(1,ii) == 0 .or. iu(2,ii) == 0) go to 240
do i = 1,klm2
   z = q(i,in)
   q(i,in) = q(i,js)
   q(i,js) = z
end do
js = js + 1
go to 240
! Test for optimality.
490 if (kforce == 0) go to 580
if (iphase == 1 .and. q(klm1,n1) <= toler) go to 500
kforce = 0
go to 240
! Set up phase 2 costs.
500 iphase = 2
do j = 1,nklm
   cu(1,j) = 0.
   cu(2,j) = 0.
end do
do j = n1,nk
   cu(1,j) = 1.
   cu(2,j) = 1.
end do
do i = 1,klm
   ii = q(i,n2)
   if (ii > 0) go to 530
   ii = -ii
   if (iu(2,ii) == 0) go to 560
   cu(2,ii) = 0.
   go to 540
530 if (iu(1,ii) == 0) go to 560
   cu(1,ii) = 0.
540 ia = ia + 1
   do j = 1,n2
      z = q(ia,j)
      q(ia,j) = q(i,j)
      q(i,j) = z
   end do
560 continue
end do
go to 160
570 if (q(klm1,n1) <= toler) go to 500
kode = 1
go to 590
580 if (iphase == 1) go to 570
! Prepare output.
kode = 0
590 sum = 0.d0
do j = 1,n
   x(j) = 0.
end do
do i = 1,klm
   res(i) = 0.
end do
do i = 1,klm
   ii = q(i,n2)
   sn = 1.
   if (ii > 0) go to 620
   ii = -ii
   sn = -1.
620 if (ii > n) go to 630
   x(ii) = sn*q(i,n1)
   go to 640
630 iimn = ii - n
   res(iimn) = sn*q(i,n1)
   if (ii >= n1 .and. ii <= nk) sum = sum + &
      & dble(q(i,n1))
640 continue
end do
error = sum
end subroutine xl1

subroutine llsq(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
!! <!-- nswc-ford:begin LLSQ -->
!! Reference for `llsq`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: iwk
integer, intent(in) :: ka, kb, m, n, nb
real, intent(inout) :: a(ka,n), b(kb,nb), wk(n)
dimension iwk(n)
!     beginning of local variable declarations
integer :: i, j, np1
real :: rnorm
logical :: exit
!     --------------
ierr = 0
if (1 < n .and. n <= m) go to 10
ierr = 1
return
10 np1 = n + 1
call ortho(m,n,a,ka,wk,iwk,exit)
if (exit) go to 20
ierr = 2
return
20 do j = 1,nb
   call orsol(m,n,a,ka,wk,iwk,b(1,j))
   if (m == n) go to 22
   rnorm = 0.0
   do i = np1,m
      rnorm = rnorm + b(i,j)*b(i,j)
   end do
   b(np1,j) = sqrt(rnorm)
22 continue
end do
end subroutine llsq

subroutine llsqmp(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
!! <!-- nswc-ford:begin LLSQMP -->
!! Reference for `llsqmp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      dimension wk(mn + 2m + n)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: iwk
integer, intent(in) :: ka, kb, m, n, nb
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,nb), wk(*)
dimension iwk(n)
!     beginning of local variable declarations
integer :: i, j, lq, lr, ls, np1
real :: rnorm
logical :: exit
!     -------------------
!     dimension wk(mn + 2m + n)
!     -------------------
ierr = 0
if (1 < n .and. n <= m) go to 10
ierr = 2
return
10 np1 = n + 1
lr = m + 1
ls = lr + m
lq = ls + n
call mcopy(m, n, a, ka, wk(lq), m)
call ortho(m, n, wk(lq), m, wk(ls), iwk, exit)
if (exit) go to 20
ierr = 3
return
20 do j = 1,nb
   do i = 1,m
      wk(i) = b(i,j)
   end do
   call orsol(m, n, wk(lq), m, wk(ls), iwk, wk(1))
   call orimp(m, n, a, ka, wk(lq), m, wk(ls), iwk, b(1,j), &
      & wk(1), wk(lr), exit)
   do i = 1,n
      b(i,j) = wk(i)
   end do
   if (.not.exit) ierr = 1
   if (m == n) go to 31
   rnorm = 0.0
   do i = np1,m
      rnorm = rnorm + wk(i)*wk(i)
   end do
   b(np1,j) = sqrt(rnorm)
31 continue
end do
end subroutine llsqmp

pure subroutine ortho(m, n, qr, ms, s, ip, exit)
!! <!-- nswc-ford:begin ORTHO -->
!! Reference for `ortho`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!       Identification
!!         ortho - Orthogonal transformation of a given general m by n
!!                 matrix A to upper triangular form
!!         Fortran subroutine subprogram
!!         aerospace research laboratories
!!         wright-patterson afb, ohio  45433
!!       purpose
!!         ortho computes an implicit orthogonal matrix Q and an explicit
!!         upper triangular matrix R and a permutation matrix P satisfying
!!         qr = PA given an m by n real matrix A.  ortho is intended for
!!         use with the subroutine orsol to produce the least squares
!!         solution of the equation AX = B.
!!       Control
!!         dimension qr(ms,n), s(n), ip(n)
!!         logical exit
!!
!!         call ortho(m, n, qr, ms, s, ip, exit)
!!         where
!!         m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!!         n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!!              (1 .LT. n .LE. m).
!!         QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!!         QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!!              qr(i,j), i .LE. j, and the relevant parts of Q in qr(i,j),
!!              i .GT. j.
!!         ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!!              QR in the calling program.
!!         s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!!         ip   is an integer output array containing in ip(i), i=1,...,n,
!!              the images of the permutation corresponding to the PERMU-
!!              TATION matrix P.
!!         Exit is set to the value .TRUE. if the rank of A is equal to n
!!              and .FALSE. otherwise.
!!       Method
!!         the matrix A in the array qr is reduced to upper triangular
!!         form using orthogonal transformation with partial pivoting.
!!       References
!!         (1) peter Businger and G.H. Golub, linear least squares SOLU-
!!             TIONS by Householder transformations, numer. Math. 7(1965),
!!             269-276.
!!         (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!!             transformations for linear least squares problems, ARL
!!             technical report ARL TR 74-0124(1974).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ip
integer, intent(in) :: m, ms, n
real, intent(inout) :: qr(ms,n), s(n)
logical, intent(out) :: exit
dimension ip(n)
!     beginning of local variable declarations
integer :: i, j, jp, k, kj, nn
real :: ajj, sav, ss, y
!***********************************************************************
!      Identification
!        ortho - Orthogonal transformation of a given general m by n
!                matrix A to upper triangular form
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        ortho computes an implicit orthogonal matrix Q and an explicit
!        upper triangular matrix R and a permutation matrix P satisfying
!        qr = PA given an m by n real matrix A.  ortho is intended for
!        use with the subroutine orsol to produce the least squares
!        solution of the equation AX = B.
!      Control
!        dimension qr(ms,n), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call ortho(m, n, qr, ms, s, ip, exit)
!        where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. n .LE. m).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             qr(i,j), i .LE. j, and the relevant parts of Q in qr(i,j),
!             i .GT. j.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR in the calling program.
!        s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        ip   is an integer output array containing in ip(i), i=1,...,n,
!             the images of the permutation corresponding to the PERMU-
!             TATION matrix P.
!        Exit is set to the value .TRUE. if the rank of A is equal to n
!             and .FALSE. otherwise.
!      Method
!        the matrix A in the array qr is reduced to upper triangular
!        form using orthogonal transformation with partial pivoting.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
exit = .true.
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   ip(j) = j
   jp = j + 1
   kj = j
!                                       Search for pivot in the j-TH
!                                       column and interchange rows.
   do k = jp, m
      if (abs(qr(k,j)) > abs(qr(kj,j))) kj = k
   end do
   if (qr(kj,j) == 0.0) go to 90
   if (kj == j) go to 30
   ip(j) = kj
   do i = j, n
      sav = qr(j,i)
      qr(j,i) = qr(kj,i)
      qr(kj,i) = sav
   end do
!                                       Normalize the pivoting column
!                                       and find its norm.
30 ajj = qr(j,j)
   do i = jp, m
      qr(i,j) = qr(i,j)/ajj
   end do
   sav = 1.0
   do i = jp, m
      sav = sav + qr(i,j)*qr(i,j)
   end do
   s(j) = -sqrt(sav)
   qr(j,j) = s(j)*ajj
   if (jp > n) go to 80
!                                       Premultiply QR with the j-TH
!                                       orthogonal matrix.
   y = 1.0 - s(j)
   do k = jp, n
      sav = qr(j,k)
      do i = jp, m
         sav = sav + qr(i,j)*qr(i,k)
      end do
      ss = qr(j,k)
      qr(j,k) = sav/s(j)
      ss = (ss - qr(j,k))/y
      do i = jp, m
         qr(i,k) = qr(i,k) - qr(i,j)*ss
      end do
   end do
80 continue
end do
return
90 exit = .false.
end subroutine ortho

subroutine orsol(m, n, qr, ms, s, ip, x)
!! <!-- nswc-ford:begin ORSOL -->
!! Reference for `orsol`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!       Identification
!!         orsol - Least squares solution of a linear system given an
!!                 orthogonal-triangular factorization of the coefficient
!!                 matrix produced by subroutine ortho
!!         Fortran subroutine subprogram
!!         aerospace research laboratories
!!         wright-patterson afb, ohio  45433
!!       purpose
!!         orsol computes the least squares solution of the linear system
!!         QRX = Pax = B where Q, R, and P are determined from a by ortho.
!!       Control
!!         dimension qr(ms,n), s(n), ip(n), x(m)
!!
!!         call orsol(m, n, qr, ms, s, ip, x)
!!         where
!!         m  is an integer input variable, the number of rows of A.
!!         n  is an integer input variable, the number of columns of A
!!              (1 .LT. n .LE. m).
!!         QR is a real input array, the orthogonal and triangular factors
!!            of a produced by ortho.
!!         ms is an integer input variable, the leading dimension of
!!            QR in the calling program.
!!         s  is a real input array, the relevant parts of Q produced by
!!            ortho.
!!         ip is an integer input array, the permutation information
!!            produced by ortho.
!!         x  as a real input array is the right-hand side B of AX = B.
!!         x  as a real output array is x(i), i = 1, ..., n, the least
!!            squares solution, and x(j), j = n+1, ..., m, the vector
!!            whose length is the minimum of all residual B - AX.
!!       Method
!!         the factored system QRX = Pax = PB are solved in the sequence
!!         of QY = PB and RX = y. full rank for the matrix A is assumed
!!         which can be checked by interrogating the logical output
!!         variable produced by ortho.
!!       References
!!         (1) peter Businger and G.H. Golub, linear least squares SOLU-
!!             TIONS by Householder transformations, numer. Math. 7(1965),
!!             269-276.
!!         (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!!             transformations for linear least squares problems, ARL
!!             technical report ARL TR 74-0124(1974).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ip
integer, intent(in) :: m, ms, n
real :: qr(ms,n), s(n)
real, intent(inout) :: x(m)
dimension ip(n)
!     beginning of local variable declarations
integer :: i, ij, j, jp, k, ni, nm, nn
real :: sav, ss, y
!***********************************************************************
!      Identification
!        orsol - Least squares solution of a linear system given an
!                orthogonal-triangular factorization of the coefficient
!                matrix produced by subroutine ortho
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        orsol computes the least squares solution of the linear system
!        QRX = Pax = B where Q, R, and P are determined from a by ortho.
!      Control
!        dimension qr(ms,n), s(n), ip(n), x(m)
!        .
!        .
!        .
!        call orsol(m, n, qr, ms, s, ip, x)
!        where
!        m  is an integer input variable, the number of rows of A.
!        n  is an integer input variable, the number of columns of A
!             (1 .LT. n .LE. m).
!        QR is a real input array, the orthogonal and triangular factors
!           of a produced by ortho.
!        ms is an integer input variable, the leading dimension of
!           QR in the calling program.
!        s  is a real input array, the relevant parts of Q produced by
!           ortho.
!        ip is an integer input array, the permutation information
!           produced by ortho.
!        x  as a real input array is the right-hand side B of AX = B.
!        x  as a real output array is x(i), i = 1, ..., n, the least
!           squares solution, and x(j), j = n+1, ..., m, the vector
!           whose length is the minimum of all residual B - AX.
!      Method
!        the factored system QRX = Pax = PB are solved in the sequence
!        of QY = PB and RX = y. full rank for the matrix A is assumed
!        which can be checked by interrogating the logical output
!        variable produced by ortho.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   jp = j + 1
   ij = ip(j)
   y = 1.0 - s(j)
   sav = x(j)
   x(j) = x(ij)
   x(ij) = sav
!                                       Premultiply x with the j-TH
!                                       orthogonal matrix.
   sav = x(j)
   do k = jp, m
      sav = sav + qr(k,j)*x(k)
   end do
   ss = x(j)
   x(j) = sav/s(j)
   ss = (ss - x(j))/y
   do k = jp, m
      x(k) = x(k) - qr(k,j)*ss
   end do
end do
!                                       Back substitute to find the
!                                       least squares solution.
x(n) = x(n)/qr(n,n)
nm = n - 1
do i = 1, nm
   ni = n - i
   nn = n
   do j = 1, i
      x(ni) = x(ni) - qr(ni,nn)*x(nn)
      nn = nn - 1
   end do
   x(ni) = x(ni)/qr(ni,ni)
end do
end subroutine orsol

subroutine orimp(m, n, a, ka, qr, ms, s, ip, b, x, r, exit)
!! <!-- nswc-ford:begin ORIMP -->
!! Reference for `orimp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!       Purpose
!!         given an approximate least squares solution x of a linear
!!         system AX = b obtained using orsol. orimp attempts to compute
!!         an improved solution correct to machine precision.
!!       Control
!!         dimension a(ka,n), qr(ms,n), b(m), x(m), r(m), s(n), ip(n)
!!         logical exit
!!
!!         call orimp(m, n, a, ka, qr, ms, s, ip, b, x, r, exit)
!!         where
!!         m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!!         n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A
!!              (1 .LT. n .LE. m).
!!         A    IS A REAL INPUT ARRAY, THE GIVEN m BY n MATRIX.
!!         QR   IS A REAL INPUT ARRAY, THE ORTHOGONAL AND TRIANGULAR
!!              factors of a produced by ortho.
!!         b    is a real input array, the right hand side of AX = b.
!!         x    AS A REAL INPUT ARRAY IS THE APPROXIMATE LEAST SQUARES
!!              solution together with the residual information produced
!!              BY orsol.
!!         x    AS A REAL OUTPUT ARRAY IS THE IMPROVED LEAST SQUARES
!!              solution with a residual of minimum length.
!!         r    IS A REAL OUTPUT ARRAY, THE CORRECTION VECTOR ADDED TO x.
!!         ka   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!!              of A in the calling program.
!!         ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!!              of QR in the calling program.
!!         s    IS A REAL INPUT ARRAY, A RELEVANT PART OF Q PRODUCED BY
!!              ortho.
!!         ip   IS AN INTEGER INPUT ARRAY, THE PERMUTATION INFORMATION
!!              produced by ortho.
!!         Exit is set to the value .TRUE. if improvement of x is success-
!!              ful with a gain in accuracy of at least 50 per cent each
!!              iteration and .FALSE. otherwise.
!!       Method
!!         orimp executes the iteration cycle
!!               (1)  AR = b - AX
!!               (2)  x = x + r
!!         with a given initial x.  the residual vector b - AX is computed
!!         to high accuracy by double precision.  orsol is then used to
!!         solve (1).
!!
!!      ********** eps is a machine dependent parameter. Assign eps
!!                 the value U where U is the smallest positive floating
!!                 point number such that 1.0 + U .GT. 1.0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ip
integer, intent(in) :: ka, m, ms, n
real, intent(in) :: a(ka,n), b(m)
real :: qr(ms,n)
real, intent(inout) :: r(m)
real :: s(n)
real, intent(inout) :: x(m)
logical, intent(out) :: exit
dimension ip(n)
!     beginning of local variable declarations
integer :: i, j, k, np1
real :: eps, eps2, rat, ratio, rnrm2, xnrm2
double precision :: dsum
real, parameter :: zero = 0.0
real, parameter :: one = 1.0
real, parameter :: four = 4.0
real, parameter :: fourth = 0.25
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
! ----------------------------------------------------------------------
!      Purpose
!        given an approximate least squares solution x of a linear
!        system AX = b obtained using orsol. orimp attempts to compute
!        an improved solution correct to machine precision.
!      Control
!        dimension a(ka,n), qr(ms,n), b(m), x(m), r(m), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call orimp(m, n, a, ka, qr, ms, s, ip, b, x, r, exit)
!        where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A
!             (1 .LT. n .LE. m).
!        A    IS A REAL INPUT ARRAY, THE GIVEN m BY n MATRIX.
!        QR   IS A REAL INPUT ARRAY, THE ORTHOGONAL AND TRIANGULAR
!             factors of a produced by ortho.
!        b    is a real input array, the right hand side of AX = b.
!        x    AS A REAL INPUT ARRAY IS THE APPROXIMATE LEAST SQUARES
!             solution together with the residual information produced
!             BY orsol.
!        x    AS A REAL OUTPUT ARRAY IS THE IMPROVED LEAST SQUARES
!             solution with a residual of minimum length.
!        r    IS A REAL OUTPUT ARRAY, THE CORRECTION VECTOR ADDED TO x.
!        ka   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             of A in the calling program.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             of QR in the calling program.
!        s    IS A REAL INPUT ARRAY, A RELEVANT PART OF Q PRODUCED BY
!             ortho.
!        ip   IS AN INTEGER INPUT ARRAY, THE PERMUTATION INFORMATION
!             produced by ortho.
!        Exit is set to the value .TRUE. if improvement of x is success-
!             ful with a gain in accuracy of at least 50 per cent each
!             iteration and .FALSE. otherwise.
!      Method
!        orimp executes the iteration cycle
!              (1)  AR = b - AX
!              (2)  x = x + r
!        with a given initial x.  the residual vector b - AX is computed
!        to high accuracy by double precision.  orsol is then used to
!        solve (1).
! ----------------------------------------------------------------------
!     ********** eps is a machine dependent parameter. Assign eps
!                the value U where U is the smallest positive floating
!                point number such that 1.0 + U .GT. 1.0.
eps = spmpar(1)
exit = .true.
np1 = n + 1
eps2 = eps*eps
xnrm2 = zero
do i = 1,n
   xnrm2 = xnrm2 + x(i)*x(i)
end do
if (xnrm2 == zero) return
ratio = one
!                                       Find the residual vector.
20 do k = 1,m
   dsum = b(k)
   do j = 1,n
      dsum = dsum - dble(a(k,j))*dble(x(j))
   end do
   r(k) = dsum
end do
!                                       Find the correction vector.
call orsol(m, n, qr, ms, s, ip, r)
rnrm2 = zero
do k = 1,n
   rnrm2 = rnrm2 + r(k)*r(k)
end do
if (rnrm2 <= eps2*xnrm2) return
!                                       Form new approximate solution.
do k = 1,n
   x(k) = x(k) + r(k)
end do
xnrm2 = zero
do k = 1,n
   xnrm2 = xnrm2 + x(k)*x(k)
end do
if (m == n) go to 50
do k = np1,m
   x(k) = r(k)
end do
50 if (xnrm2 == zero) return
rat = ratio
ratio = rnrm2/xnrm2
if (ratio <= fourth*rat) go to 20
if (ratio <= min(rat,four*eps2)) return
exit = .false.
end subroutine orimp

pure subroutine dllsq(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
!! <!-- nswc-ford:begin DLLSQ -->
!! Reference for `dllsq`.
!!
!! No introductory description is present in the original source.
!! The signature below records the declared arguments and their available intents;
!! consult the source and chapter manual for algorithm details.
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n, nb
double precision, intent(inout) :: a(ka,n), b(kb,nb), wk(n)
integer, intent(inout) :: iwk(n)
!     beginning of local variable declarations
integer :: i, j, np1
double precision :: rnorm
logical :: exit
interface
   pure subroutine dorsol(m,n,qr,ms,s,ip,x)
      implicit none
      integer, intent(in) :: ms
      integer, intent(in) :: n
      integer, intent(in) :: m
      double precision, intent(in) :: qr(ms,n)
      double precision, intent(in) :: s(n)
      integer, intent(in) :: ip(n)
      double precision, intent(inout) :: x(m)
   end subroutine dorsol
   pure subroutine dortho(m,n,qr,ms,s,ip,exit)
      implicit none
      integer, intent(in) :: ms
      integer, intent(in) :: n
      integer, intent(in) :: m
      double precision, intent(inout) :: qr(ms,n)
      double precision, intent(inout) :: s(n)
      integer, intent(inout) :: ip(n)
      logical, intent(out) :: exit
   end subroutine dortho
end interface
!     --------------
ierr = 0
if (1 < n .and. n <= m) go to 10
ierr = 1
return
10 np1 = n + 1
call dortho(m,n,a,ka,wk,iwk,exit)
if (exit) go to 20
ierr = 2
return
20 do j = 1,nb
   call dorsol(m,n,a,ka,wk,iwk,b(1,j))
   if (m == n) go to 22
   rnorm = 0.d0
   do i = np1,m
      rnorm = rnorm + b(i,j)*b(i,j)
   end do
   b(np1,j) = sqrt(rnorm)
22 continue
end do
end subroutine dllsq

pure subroutine dortho(m, n, qr, ms, s, ip, exit)
!! <!-- nswc-ford:begin DORTHO -->
!! Reference for `dortho`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!       Identification
!!         dortho - Orthogonal transformation of a given general m by n
!!                 matrix A to upper triangular form
!!         Fortran subroutine subprogram
!!         aerospace research laboratories
!!         wright-patterson afb, ohio  45433
!!       purpose
!!         dortho computes an implicit orthogonal matrix Q and an explicit
!!         upper triangular matrix R and a permutation matrix P satisfying
!!         qr = PA given an m by n real matrix A.  dortho is intended for
!!         use with the subroutine dorsol to produce the least squares
!!         solution of the equation AX = B.
!!       Control
!!         dimension qr(ms,n), s(n), ip(n)
!!         logical exit
!!
!!         call dortho(m, n, qr, ms, s, ip, exit)
!!         where
!!         m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!!         n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!!              (1 .LT. n .LE. m).
!!         QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!!         QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!!              qr(i,j), i .LE. j, and the relevant parts of Q in qr(i,j),
!!              i .GT. j.
!!         ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!!              QR in the calling program.
!!         s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!!         ip   is an integer output array containing in ip(i), i=1,...,n,
!!              the images of the permutation corresponding to the PERMU-
!!              TATION matrix P.
!!         Exit is set to the value .TRUE. if the rank of A is equal to n
!!              and .FALSE. otherwise.
!!       Method
!!         the matrix A in the array qr is reduced to upper triangular
!!         form using orthogonal transformation with partial pivoting.
!!       References
!!         (1) peter Businger and G.H. Golub, linear least squares SOLU-
!!             TIONS by Householder transformations, numer. Math. 7(1965),
!!             269-276.
!!         (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!!             transformations for linear least squares problems, ARL
!!             technical report ARL TR 74-0124(1974).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, ms, n
double precision, intent(inout) :: qr(ms,n), s(n)
integer, intent(inout) :: ip(n)
logical, intent(out) :: exit
!     beginning of local variable declarations
integer :: i, j, jp, k, kj, nn
double precision :: ajj, sav, ss, y
!***********************************************************************
!      Identification
!        dortho - Orthogonal transformation of a given general m by n
!                matrix A to upper triangular form
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        dortho computes an implicit orthogonal matrix Q and an explicit
!        upper triangular matrix R and a permutation matrix P satisfying
!        qr = PA given an m by n real matrix A.  dortho is intended for
!        use with the subroutine dorsol to produce the least squares
!        solution of the equation AX = B.
!      Control
!        dimension qr(ms,n), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call dortho(m, n, qr, ms, s, ip, exit)
!        where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. n .LE. m).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             qr(i,j), i .LE. j, and the relevant parts of Q in qr(i,j),
!             i .GT. j.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR in the calling program.
!        s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        ip   is an integer output array containing in ip(i), i=1,...,n,
!             the images of the permutation corresponding to the PERMU-
!             TATION matrix P.
!        Exit is set to the value .TRUE. if the rank of A is equal to n
!             and .FALSE. otherwise.
!      Method
!        the matrix A in the array qr is reduced to upper triangular
!        form using orthogonal transformation with partial pivoting.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
exit = .true.
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   ip(j) = j
   jp = j + 1
   kj = j
!                                       Search for pivot in the j-TH
!                                       column and interchange rows.
   do k = jp, m
      if (abs(qr(k,j)) > abs(qr(kj,j))) kj = k
   end do
   if (qr(kj,j) == 0.d0) go to 90
   if (kj == j) go to 30
   ip(j) = kj
   do i = j, n
      sav = qr(j,i)
      qr(j,i) = qr(kj,i)
      qr(kj,i) = sav
   end do
!                                       Normalize the pivoting column
!                                       and find its norm.
30 ajj = qr(j,j)
   do i = jp, m
      qr(i,j) = qr(i,j)/ajj
   end do
   sav = 1.d0
   do i = jp, m
      sav = sav + qr(i,j)*qr(i,j)
   end do
   s(j) = -sqrt(sav)
   qr(j,j) = s(j)*ajj
   if (jp > n) go to 80
!                                       Premultiply QR with the j-TH
!                                       orthogonal matrix.
   y = 1.d0 - s(j)
   do k = jp, n
      sav = qr(j,k)
      do i = jp, m
         sav = sav + qr(i,j)*qr(i,k)
      end do
      ss = qr(j,k)
      qr(j,k) = sav/s(j)
      ss = (ss - qr(j,k))/y
      do i = jp, m
         qr(i,k) = qr(i,k) - qr(i,j)*ss
      end do
   end do
80 continue
end do
return
90 exit = .false.
end subroutine dortho

pure subroutine dorsol(m, n, qr, ms, s, ip, x)
!! <!-- nswc-ford:begin DORSOL -->
!! Reference for `dorsol`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!       Identification
!!         dorsol - Least squares solution of a linear system given an
!!                 orthogonal-triangular factorization of the coefficient
!!                 matrix produced by subroutine dortho
!!         Fortran subroutine subprogram
!!         aerospace research laboratories
!!         wright-patterson afb, ohio  45433
!!       purpose
!!         dorsol computes the least squares solution of the linear system
!!         QRX = Pax = B where Q, R, and P are determined from a by dortho
!!       control
!!         dimension qr(ms,n), s(n), ip(n), x(m)
!!
!!         call dorsol(m, n, qr, ms, s, ip, x)
!!         where
!!         m  is an integer input variable, the number of rows of A.
!!         n  is an integer input variable, the number of columns of A
!!              (1 .LT. n .LE. m).
!!         QR is a real input array, the orthogonal and triangular factors
!!            of a produced by dortho.
!!         ms is an integer input variable, the leading dimension of
!!            QR in the calling program.
!!         s  is a real input array, the relevant parts of Q produced by
!!            dortho.
!!         ip is an integer input array, the permutation information
!!            produced by dortho.
!!         x  as a real input array is the right-hand side B of AX = B.
!!         x  as a real output array is x(i), i = 1, ..., n, the least
!!            squares solution, and x(j), j = n+1, ..., m, the vector
!!            whose length is the minimum of all residual B - AX.
!!       Method
!!         the factored system QRX = Pax = PB are solved in the sequence
!!         of QY = PB and RX = y. full rank for the matrix A is assumed
!!         which can be checked by interrogating the logical output
!!         variable produced by dortho.
!!       References
!!         (1) peter Businger and G.H. Golub, linear least squares SOLU-
!!             TIONS by Householder transformations, numer. Math. 7(1965),
!!             269-276.
!!         (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!!             transformations for linear least squares problems, ARL
!!             technical report ARL TR 74-0124(1974).
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: m, ms, n
double precision, intent(in) :: qr(ms,n), s(n)
double precision, intent(inout) :: x(m)
integer, intent(in) :: ip(n)
!     beginning of local variable declarations
integer :: i, ij, j, jp, k, ni, nm, nn
double precision :: sav, ss, y
!***********************************************************************
!      Identification
!        dorsol - Least squares solution of a linear system given an
!                orthogonal-triangular factorization of the coefficient
!                matrix produced by subroutine dortho
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        dorsol computes the least squares solution of the linear system
!        QRX = Pax = B where Q, R, and P are determined from a by dortho
!      control
!        dimension qr(ms,n), s(n), ip(n), x(m)
!        .
!        .
!        .
!        call dorsol(m, n, qr, ms, s, ip, x)
!        where
!        m  is an integer input variable, the number of rows of A.
!        n  is an integer input variable, the number of columns of A
!             (1 .LT. n .LE. m).
!        QR is a real input array, the orthogonal and triangular factors
!           of a produced by dortho.
!        ms is an integer input variable, the leading dimension of
!           QR in the calling program.
!        s  is a real input array, the relevant parts of Q produced by
!           dortho.
!        ip is an integer input array, the permutation information
!           produced by dortho.
!        x  as a real input array is the right-hand side B of AX = B.
!        x  as a real output array is x(i), i = 1, ..., n, the least
!           squares solution, and x(j), j = n+1, ..., m, the vector
!           whose length is the minimum of all residual B - AX.
!      Method
!        the factored system QRX = Pax = PB are solved in the sequence
!        of QY = PB and RX = y. full rank for the matrix A is assumed
!        which can be checked by interrogating the logical output
!        variable produced by dortho.
!      References
!        (1) peter Businger and G.H. Golub, linear least squares SOLU-
!            TIONS by Householder transformations, numer. Math. 7(1965),
!            269-276.
!        (2) N.K. Tsao and P.J. nikolai, procedures using orthogonal
!            transformations for linear least squares problems, ARL
!            technical report ARL TR 74-0124(1974).
!***********************************************************************
nn = n
if (n == m) nn = n - 1
do j = 1, nn
   jp = j + 1
   ij = ip(j)
   y = 1.d0 - s(j)
   sav = x(j)
   x(j) = x(ij)
   x(ij) = sav
!                                       Premultiply x with the j-TH
!                                       orthogonal matrix.
   sav = x(j)
   do k = jp, m
      sav = sav + qr(k,j)*x(k)
   end do
   ss = x(j)
   x(j) = sav/s(j)
   ss = (ss - x(j))/y
   do k = jp, m
      x(k) = x(k) - qr(k,j)*ss
   end do
end do
!                                       Back substitute to find the
!                                       least squares solution.
x(n) = x(n)/qr(n,n)
nm = n - 1
do i = 1, nm
   ni = n - i
   nn = n
   do j = 1, i
      x(ni) = x(ni) - qr(ni,nn)*x(nn)
      nn = nn - 1
   end do
   x(ni) = x(ni)/qr(ni,ni)
end do
end subroutine dorsol

subroutine lsqr(ind, a, mda, m, n, b, mdb, nb, re, ae, krank, &
   & ksure, rnorm, work, lw, iwork, liw, ierr)
!! <!-- nswc-ford:begin LSQR -->
!! Reference for `lsqr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Least squares solution of linear equations
!!
!!      lsqr solves both underdetermined and overdetermined linear
!!      systems AX = b, where A is an m by n matrix and b is an m by
!!      nb matrix of right hand sides. If m .GE. n, the least squares
!!      solution is computed by decomposing the matrix a into the
!!      product of an orthogonal matrix Q and upper triangular matrix
!!      R (QR factorization). If m .LT. n, the minimal length solution
!!      is computed by factoring the matrix a into the product of a
!!      lower triangular matrix L and orthogonal matrix Q (LQ factor-
!!      ization). If the matrix a is determined to be rank deficient,
!!      then the minimal length least squares solution is computed.
!!      User input bounds on the uncertainty of the elements of A are
!!      used to detect numerical rank deficiency. The algorithm uses
!!      a row and column pivot strategy to minimize the growth of
!!      uncertainty and round-off errors.
!!
!!    *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!!
!!      Input..
!!      IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!!                    called for the first time.
!!                       ind = 0      Original call
!!                       ind .NE. 0   subsequent calls
!!                    on subsequent calls a new set b of equations can
!!                    be solved (using the same coefficient matrix a).
!!                    It is assumed that A, mda, m, n, krank, iwork,
!!                    liw, and the first 2*min(m,n) locations of work
!!                    have not been modified by the user. re, ae, and
!!                    ksure are not used.
!!      a(,)          linear coefficient matrix of AX=b, with mda the
!!       mda,m,n      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!!                    m is the row dimension (no. of equations of the
!!                    problem) and n the col dimension (no. of unknowns).
!!                    Must have mda .GE. m.
!!      b(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!!       MDB,nb       DIMENSION OF b IN THE CALLING PROGRAM. nb IS THE
!!                    number of m by 1 right hand sides. Must have
!!                    mdb .GE. max(m,n). If nb .LE. 0 then b and mdb
!!                    are ignored.
!!      re            re IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!!                    elements of the matrix a (0 .le. re .LT. 1).
!!      ae            ae IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!!                    elements of the matrix a (ae .GE. 0).
!!      work()        A REAL WORK ARRAY DIMENSIONED 5*min(m,n).
!!      lw            ACTUAL DIMENSION OF WORK
!!      iwork()       INTEGER WORK ARRAY DIMENSIONED AT LEAST n+m.
!!      liw           ACTUAL DIMENSION OF iwork.
!!      Output..
!!      a(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!!                    and the transformation information. A and the first
!!                    2*min(m,n) elements of work (see below) completely
!!                    specify the factorization of the matrix a.
!!      b(,)          CONTAINS THE n BY nb SOLUTION MATRIX FOR X.
!!      krank,ksure   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!!                    and absolute bounds on uncertainty, is bounded
!!                    above by krank and below by ksure. The algorithm
!!                    returns a solution based on krank. ksure provides
!!                    an indication of the precision of the rank.
!!      rnorm()       CONTAINS THE EUCLIDEAN LENGTH OF THE nb RESIDUAL
!!                    VECTORS  b(i) - AX(i), i=1,...,nb.
!!      work()        THE FIRST 2*min(m,n) LOCATIONS OF WORK CONTAIN
!!                    the values necessary to reproduce the Householder
!!                    factorization of A.
!!      iwork()       AN ARRAY OF LENGTH m + n CONTAINING THE ORDERS IN
!!                    which the rows and columns were used. If m .GE. n
!!                    then the first n locations contain the order of
!!                    the columns and the next m locations the order of
!!                    the rows. If m .LT. n then the order of the rows
!!                    precedes the order of the columns.
!!      ierr          FLAG TO INDICATE THE STATUS OF THE RESULTS
!!                      0     - Satisfactory completion
!!                    .GT. 0  - Input error
!!
!!      The subroutines u11ls, u12ls, u11us, and u12us were written by
!!      T. Manteuffel (LANL) in 1981. The driver routine lsqr was written
!!      by A.H. Morris (NSWC) in 1991.
!!
!!      Reference.  Manteuffel, T., An interval analysis approach to rank
!!                  determination in linear least squares problems,
!!                  Sandia Laboratories report SAND80-0655, June, 1980.
!!
!!      np            if m .GE. n then the first np columns of A
!!                    are never interchanged.
!!                    If m .LT. n then the first np rows of A are
!!                    never interchanged. np is not referenced on
!!                    a continuation call to the routine.
!!      MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!!                    is to react if rank deficiency is detected.
!!                    If mode = 0 Return immediately, no solution
!!                              1 compute truncated solution
!!                              2 compute minimal length solution
!!                    mode must not be modified on a continuation
!!                    CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!!                    first n locations of work are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ind
integer, intent(inout) :: krank, ksure
integer, intent(in) :: liw, lw, m, mda, mdb, n, nb
real, intent(in) :: ae, re
real, intent(inout) :: a(mda,n), b(mdb,*), rnorm(*), work(lw)
integer, intent(inout) :: iwork(liw)
!     beginning of local variable declarations
integer :: i, imax, info, m0, m1, m2, m3, m4, m5, mode, n0, np
real :: eps, rerr
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!              Least squares solution of linear equations
!                            --------------
!     lsqr solves both underdetermined and overdetermined linear
!     systems AX = b, where A is an m by n matrix and b is an m by
!     nb matrix of right hand sides. If m .GE. n, the least squares
!     solution is computed by decomposing the matrix a into the
!     product of an orthogonal matrix Q and upper triangular matrix
!     R (QR factorization). If m .LT. n, the minimal length solution
!     is computed by factoring the matrix a into the product of a
!     lower triangular matrix L and orthogonal matrix Q (LQ factor-
!     ization). If the matrix a is determined to be rank deficient,
!     then the minimal length least squares solution is computed.
!     User input bounds on the uncertainty of the elements of A are
!     used to detect numerical rank deficiency. The algorithm uses
!     a row and column pivot strategy to minimize the growth of
!     uncertainty and round-off errors.
!   ******************************************************************
!   *                                                                *
!   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!   *                                                                *
!   ******************************************************************
!     Input..
!     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!                   called for the first time.
!                      ind = 0      Original call
!                      ind .NE. 0   subsequent calls
!                   on subsequent calls a new set b of equations can
!                   be solved (using the same coefficient matrix a).
!                   It is assumed that A, mda, m, n, krank, iwork,
!                   liw, and the first 2*min(m,n) locations of work
!                   have not been modified by the user. re, ae, and
!                   ksure are not used.
!     a(,)          linear coefficient matrix of AX=b, with mda the
!      mda,m,n      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!                   m is the row dimension (no. of equations of the
!                   problem) and n the col dimension (no. of unknowns).
!                   Must have mda .GE. m.
!     b(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!      MDB,nb       DIMENSION OF b IN THE CALLING PROGRAM. nb IS THE
!                   number of m by 1 right hand sides. Must have
!                   mdb .GE. max(m,n). If nb .LE. 0 then b and mdb
!                   are ignored.
!     re            re IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!                   elements of the matrix a (0 .le. re .LT. 1).
!     ae            ae IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!                   elements of the matrix a (ae .GE. 0).
!     work()        A REAL WORK ARRAY DIMENSIONED 5*min(m,n).
!     lw            ACTUAL DIMENSION OF WORK
!     iwork()       INTEGER WORK ARRAY DIMENSIONED AT LEAST n+m.
!     liw           ACTUAL DIMENSION OF iwork.
!     Output..
!     a(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!                   and the transformation information. A and the first
!                   2*min(m,n) elements of work (see below) completely
!                   specify the factorization of the matrix a.
!     b(,)          CONTAINS THE n BY nb SOLUTION MATRIX FOR X.
!     krank,ksure   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!                   and absolute bounds on uncertainty, is bounded
!                   above by krank and below by ksure. The algorithm
!                   returns a solution based on krank. ksure provides
!                   an indication of the precision of the rank.
!     rnorm()       CONTAINS THE EUCLIDEAN LENGTH OF THE nb RESIDUAL
!                   VECTORS  b(i) - AX(i), i=1,...,nb.
!     work()        THE FIRST 2*min(m,n) LOCATIONS OF WORK CONTAIN
!                   the values necessary to reproduce the Householder
!                   factorization of A.
!     iwork()       AN ARRAY OF LENGTH m + n CONTAINING THE ORDERS IN
!                   which the rows and columns were used. If m .GE. n
!                   then the first n locations contain the order of
!                   the columns and the next m locations the order of
!                   the rows. If m .LT. n then the order of the rows
!                   precedes the order of the columns.
!     ierr          FLAG TO INDICATE THE STATUS OF THE RESULTS
!                     0     - Satisfactory completion
!                   .GT. 0  - Input error
!----------------
!     The subroutines u11ls, u12ls, u11us, and u12us were written by
!     T. Manteuffel (LANL) in 1981. The driver routine lsqr was written
!     by A.H. Morris (NSWC) in 1991.
!----------------
!     Reference.  Manteuffel, T., An interval analysis approach to rank
!                 determination in linear least squares problems,
!                 Sandia Laboratories report SAND80-0655, June, 1980.
!-----------------------------------------------------------------------
!----------------
!     np            if m .GE. n then the first np columns of A
!                   are never interchanged.
!                   If m .LT. n then the first np rows of A are
!                   never interchanged. np is not referenced on
!                   a continuation call to the routine.
!     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!                   is to react if rank deficiency is detected.
!                   If mode = 0 Return immediately, no solution
!                             1 compute truncated solution
!                             2 compute minimal length solution
!                   mode must not be modified on a continuation
!                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!                   first n locations of work are used.
!----------------
np = 0
mode = 2
!     Check the input
if (nb <= 0 .and. ind /= 0) go to 200
if (m < 1 .or. n < 1) go to 210
if (mda < m) go to 220
if (liw < m + n) go to 240
m0 = min(m,n)
n0 = max(m,n)
!     num = 0
if (nb <= 0) go to 10
if (mdb < n0) go to 230
if (ind /= 0) go to 100
10 if (lw < 5*m0) go to 250
if (re < 0.0 .or. ae < 0.0) go to 260
!     Define the relative and absolute tolerance lists
m1 = 1
m2 = m1 + m0
m3 = m2 + m0
m4 = m3 + m0
m5 = m4 + m0
eps = 10.0*spmpar(1)
rerr = max(eps,re)
imax = m5 - 1
do i = m4,imax
   work(i) = rerr
end do
imax = imax + m0
do i = m5,imax
   work(i) = ae
end do
!     Factor the matrix a
!     num = np
if (m < n) go to 40
call u11ls(a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
go to 100
40 call u11us(a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
!     Solution phase
100 ierr = 0
info = 0
if (krank == m0) go to 110
if (krank == 0) go to 110
!     if (krank .lt. num) go to 280
!     if (mode .eq. 0) return
info = mode
110 if (nb <= 0) return
m1 = 1
m2 = 1 + m0
if (info == 2) go to 130
!     Only min(m,n) elements of work are needed
if (lw < m0) go to 250
if (m < n) go to 120
call u12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m1),iwork(m1),iwork(m2))
return
120 call u12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m1),iwork(m1),iwork(m2))
return
!     Here 2*min(m,n) elements of work are needed
130 if (lw < 2*m0) go to 250
if (m < n) go to 140
call u12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m2),iwork(m1),iwork(m2))
return
140 call u12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m2),iwork(m1),iwork(m2))
return
!     Error return
!                             nb .LE. 0  on a continuation call
200 ierr = 7
return
!                             m .LT. 1 OR n .LT. 1
210 ierr = 1
return
!                             mda .LT. m
220 ierr = 2
return
!                             mdb .LT. max(m,n)
230 ierr = 3
return
!                             liw .LT. m + n
240 ierr = 4
return
!                             lw too small
250 ierr = 5
return
!                             re or ae is negative
260 ierr = 6
!                             0 .LT. krank .LT. np
! 280 ierr = 8
!     return
end subroutine lsqr

pure subroutine u11ls(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
   & ic,ir)
!! <!-- nswc-ford:begin U11LS -->
!! Reference for `u11ls`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!        This routine performs A QR factorization of A
!!        using Householder transformations. Row and
!!        column pivots are chosen to reduce the growth
!!        of round-off and to help detect possible rank
!!        deficiency.
!!         Initialization
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
real, intent(inout) :: a(mda,n), db(n), eb(n), h(n), ub(n), w(n)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
   & kp1, kz, l, lm1, mm, nmk
real :: bb, r2, rmin, sum, t, temp, tn, tt
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine iswap(n,ix,incx,iy,incy)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix(*)
      integer, intent(in) :: incx
      integer, intent(inout) :: iy(*)
      integer, intent(in) :: incy
   end subroutine iswap
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
   pure function snrm2(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: snrm2
   end function snrm2
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
   pure subroutine sswap(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine sswap
end interface
!       This routine performs A QR factorization of A
!       using Householder transformations. Row and
!       column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!        Initialization
j = 0
krank = n
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!        Determine rel and abs error vectors
!        calculate col length
do i = 1,n
   h(i) = snrm2(m,a(1,i),1)
   w(i) = h(i)
end do
!         Initialize error bounds
do i = 1,n
   eb(i) = max(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!          Discard self dependent columns
i = 1
50 if (eb(i) >= h(i)) go to 60
if (i == krank) go to 70
i = i + 1
go to 50
!          Matrix reduction
60 kk = krank
krank = krank - 1
if (mode == 0) return
if (i <= np) go to 400
if (i > krank) go to 70
call sswap(1,eb(i),1,eb(kk),1)
call sswap(1,ub(i),1,ub(kk),1)
call sswap(1,w(i),1,w(kk),1)
call sswap(1,h(i),1,h(kk),1)
call iswap(1,ic(i),1,ic(kk),1)
call sswap(m,a(1,i),1,a(1,kk),1)
go to 50
!           Test for zero rank
70 if (krank > 0) go to 100
krank = 0
ksure = 0
return
!        m A i n    L O O P
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j <= np) kz = j
!        Each col has MM=m-j+1 components
mm = m - j + 1
!         ub determines column pivot
110 imin = j
if (h(j) == 0.0) go to 170
rmin = ub(j)/h(j)
do i = j,kz
   if (ub(i) >= h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
end do
!     Test for rank deficiency
if (rmin < 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt >= 1.0) go to 170
!     Compute exact ub
do i = 1,jm1
   w(i) = a(i,imin)
end do
l = jm1
130 w(l) = w(l)/a(l,l)
if (l == 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(lm1,i)*w(i)
end do
l = lm1
go to 130
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) >= 1.0) go to 170
go to 200
!        Matrix reduction
170 kk = krank
krank = krank - 1
kz = krank
if (mode == 0) return
if (j <= np) go to 410
if (imin > krank) go to 180
call iswap(1,ic(imin),1,ic(kk),1)
call sswap(m,a(1,imin),1,a(1,kk),1)
call sswap(1,eb(imin),1,eb(kk),1)
call sswap(1,ub(imin),1,ub(kk),1)
call sswap(1,db(imin),1,db(kk),1)
call sswap(1,w(imin),1,w(kk),1)
call sswap(1,h(imin),1,h(kk),1)
180 if (j > krank) go to 300
go to 110
!        Column pivot
200 if (imin == j) go to 210
call sswap(1,h(j),1,h(imin),1)
call sswap(m,a(1,j),1,a(1,imin),1)
call sswap(1,eb(j),1,eb(imin),1)
call sswap(1,ub(j),1,ub(imin),1)
call sswap(1,db(j),1,db(imin),1)
call sswap(1,w(j),1,w(imin),1)
call iswap(1,ic(j),1,ic(imin),1)
!        Row pivot
210 jmax = isamax(mm,a(j,j),1)
jmax = jmax + j - 1
if (jmax == j) go to 220
call sswap(n,a(j,1),mda,a(jmax,1),mda)
call iswap(1,ir(j),1,ir(jmax),1)
!     Apply Householder transformation
220 tn = snrm2(mm,a(j,j),1)
if (tn == 0.0) go to 170
if (a(j,j) /= 0.0) tn = sign(tn,a(j,j))
call sscal(mm,1.0/tn,a(j,j),1)
a(j,j) = a(j,j) + 1.0
if (j == n) go to 250
do i = jp1,n
   bb = -sdot(mm,a(j,j),1,a(j,i),1)/a(j,j)
   call saxpy(mm,bb,a(j,j),1,a(j,i),1)
   if (i <= np) go to 240
   if (h(i) == 0.0) go to 240
   tt = 1.0 - (a(j,i)/h(i))**2
   tt = max(tt,0.0)
   t = tt
   tt = 1.0 + 0.05*tt*(h(i)/w(i))**2
   if (tt == 1.0) go to 230
   h(i) = h(i)*sqrt(t)
   go to 240
230 h(i) = snrm2(m - j,a(j + 1,i),1)
   w(i) = h(i)
240 continue
end do
250 h(j) = a(j,j)
a(j,j) = -tn
!          Update ub, db
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j)) + db(j))/a(j,j)
if (j == krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(j,i))*ub(j)
   db(i) = db(i) - a(j,i)*db(j)
end do
go to 100
!        E n D    m A i n    L O O P
300 continue
!        Compute ksure
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do ii = 1,kmi
      if (ub(ii) <= ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310   continue
   end do
   if (is == 0) exit
end do
ksure = 0
sum = 0.0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum >= 1.0) exit
   sum = sum + r2
   ksure = ksure + 1
end do
!     If system is of reduced rank and mode = 2
!     complete the decomposition for shortest least squares solution
if (krank == n .or. mode < 2) return
nmk = n - krank
kp1 = krank + 1
i = krank
340 tn = snrm2(nmk,a(i,kp1),mda)/a(i,i)
tn = a(i,i)*sqrt(1.0 + tn*tn)
call sscal(nmk,1.0/tn,a(i,kp1),mda)
w(i) = a(i,i)/tn + 1.0
a(i,i) = -tn
if (i == 1) go to 350
im1 = i - 1
do ii = 1,im1
   tt = -sdot(nmk,a(ii,kp1),mda,a(i,kp1),mda)/w(i)
   tt = tt - a(ii,i)
   call saxpy(nmk,tt,a(i,kp1),mda,a(ii,kp1),mda)
   a(ii,i) = a(ii,i) + tt*w(i)
end do
i = i - 1
go to 340
350 continue
return
!     First np columns are linearly dependent
400 krank = i - 1
return
410 krank = j - 1
end subroutine u11ls

subroutine u12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ic,ir)
!! <!-- nswc-ford:begin U12LS -->
!! Reference for `u12ls`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Given the Householder QR factorization of A, this
!!         subroutine solves the system AX=b. if the system
!!         is of reduced rank, this routine returns a solution
!!         according to the selected mode.
!!        Note - If mode.NE.2, w is never accessed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
real, intent(inout) :: a(mda,n), b(mdb,nb)
real :: h(n)
real, intent(inout) :: rnorm(nb)
real :: w(n)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ij, im1, j, jb, k, kp1, nmk
real :: bb, tt
real :: snrm2
real :: sdot
!        Given the Householder QR factorization of A, this
!        subroutine solves the system AX=b. if the system
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!       Note - If mode.NE.2, w is never accessed.
k = krank
kp1 = k + 1
if (k > 0) go to 30
!        rank=0
do jb = 1,nb
   rnorm(jb) = snrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
return
30 i = 0
!     Reorder b to reflect row interchanges
40 i = i + 1
if (i == m) go to 100
j = ir(i)
if (j == i) go to 40
if (j < 0) go to 40
ir(i) = -ir(i)
do jb = 1,nb
   rnorm(jb) = b(i,jb)
end do
ij = i
60 do jb = 1,nb
   b(ij,jb) = b(j,jb)
end do
ij = j
j = ir(ij)
ir(ij) = -ir(ij)
if (j /= i) go to 60
do jb = 1,nb
   b(ij,jb) = rnorm(jb)
end do
go to 40
100 do i = 1,m
   ir(i) = abs(ir(i))
end do
!     Apply Householder transformations to b
do j = 1,k
   tt = a(j,j)
   a(j,j) = h(j)
   do i = 1,nb
      bb = -sdot(m - j + 1,a(j,j),1,b(j,i),1)/h(j)
      call saxpy(m - j + 1,bb,a(j,j),1,b(j,i),1)
   end do
   a(j,j) = tt
end do
!        Find norms of residual vector(S)..(before overwrite b)
do jb = 1,nb
   rnorm(jb) = snrm2(m - k,b(kp1,jb),1)
end do
!     Back solve upper triangular R
i = k
150 do jb = 1,nb
   b(i,jb) = b(i,jb)/a(i,i)
end do
if (i == 1) go to 200
im1 = i - 1
do jb = 1,nb
   call saxpy(im1,-b(i,jb),a(1,i),1,b(1,jb),1)
end do
i = im1
go to 150
!     RANK LT n
!      truncated solution
200 if (k == n) go to 230
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
if (mode == 1) go to 230
!      Minimal length solution
nmk = n - k
do jb = 1,nb
   do i = 1,k
      tt = -sdot(nmk,a(i,kp1),mda,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call saxpy(nmk,tt,a(i,kp1),mda,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!     Reorder b to reflect column interchanges
230 i = 0
240 i = i + 1
if (i == n) go to 260
j = ic(i)
if (j == i) go to 240
if (j < 0) go to 240
ic(i) = -ic(i)
250 call sswap(nb,b(j,1),mdb,b(i,1),mdb)
ij = ic(j)
ic(j) = -ic(j)
j = ij
if (j /= i) go to 250
go to 240
260 do i = 1,n
   ic(i) = abs(ic(i))
end do
end subroutine u12ls

pure subroutine u11us(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
   & ir,ic)
!! <!-- nswc-ford:begin U11US -->
!! Reference for `u11us`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!        This routine performs an LQ factorization of the
!!        matrix a using Householder transformations. Row
!!        and column pivots are chosen to reduce the growth
!!        of round-off and to help detect possible rank
!!        deficiency.
!!         Initialization
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
real, intent(inout) :: a(mda,n), db(m), eb(m), h(m), ub(m), w(m)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
   & kp1, kz, l, lm1, mmk, nn
real :: bb, r2, rmin, sum, t, temp, tn, tt
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine iswap(n,ix,incx,iy,incy)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix(*)
      integer, intent(in) :: incx
      integer, intent(inout) :: iy(*)
      integer, intent(in) :: incy
   end subroutine iswap
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
   pure function snrm2(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: snrm2
   end function snrm2
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
   pure subroutine sswap(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine sswap
end interface
!       This routine performs an LQ factorization of the
!       matrix a using Householder transformations. Row
!       and column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!        Initialization
j = 0
krank = m
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!        Determine rel and abs error vectors
!        calculate row length
do i = 1,m
   h(i) = snrm2(n,a(i,1),mda)
   w(i) = h(i)
end do
!         Initialize error bounds
do i = 1,m
   eb(i) = max(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!          Discard self dependent rows
i = 1
50 if (eb(i) >= h(i)) go to 60
if (i == krank) go to 70
i = i + 1
go to 50
!          Matrix reduction
60 kk = krank
krank = krank - 1
if (mode == 0) return
if (i <= np) go to 400
if (i > krank) go to 70
call sswap(1,eb(i),1,eb(kk),1)
call sswap(1,ub(i),1,ub(kk),1)
call sswap(1,w(i),1,w(kk),1)
call sswap(1,h(i),1,h(kk),1)
call iswap(1,ir(i),1,ir(kk),1)
call sswap(n,a(i,1),mda,a(kk,1),mda)
go to 50
!           Test for zero rank
70 if (krank > 0) go to 100
krank = 0
ksure = 0
return
!        m A i n    L O O P
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j <= np) kz = j
!        Each row has NN=n-j+1 components
nn = n - j + 1
!         ub determines row pivot
110 imin = j
if (h(j) == 0.0) go to 170
rmin = ub(j)/h(j)
do i = j,kz
   if (ub(i) >= h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
end do
!     Test for rank deficiency
if (rmin < 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt >= 1.0) go to 170
!     Compute exact ub
do i = 1,jm1
   w(i) = a(imin,i)
end do
l = jm1
130 w(l) = w(l)/a(l,l)
if (l == 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(i,lm1)*w(i)
end do
l = lm1
go to 130
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) >= 1.0) go to 170
go to 200
!        Matrix reduction
170 kk = krank
krank = krank - 1
kz = krank
if (mode == 0) return
if (j <= np) go to 410
if (imin > krank) go to 180
call iswap(1,ir(imin),1,ir(kk),1)
call sswap(n,a(imin,1),mda,a(kk,1),mda)
call sswap(1,eb(imin),1,eb(kk),1)
call sswap(1,ub(imin),1,ub(kk),1)
call sswap(1,db(imin),1,db(kk),1)
call sswap(1,w(imin),1,w(kk),1)
call sswap(1,h(imin),1,h(kk),1)
180 if (j > krank) go to 300
go to 110
!        Row pivot
200 if (imin == j) go to 210
call sswap(1,h(j),1,h(imin),1)
call sswap(n,a(j,1),mda,a(imin,1),mda)
call sswap(1,eb(j),1,eb(imin),1)
call sswap(1,ub(j),1,ub(imin),1)
call sswap(1,db(j),1,db(imin),1)
call sswap(1,w(j),1,w(imin),1)
call iswap(1,ir(j),1,ir(imin),1)
!        Column pivot
210 jmax = isamax(nn,a(j,j),mda)
jmax = jmax + j - 1
if (jmax == j) go to 220
call sswap(m,a(1,j),1,a(1,jmax),1)
call iswap(1,ic(j),1,ic(jmax),1)
!     Apply Householder transformation
220 tn = snrm2(nn,a(j,j),mda)
if (tn == 0.0) go to 170
if (a(j,j) /= 0.0) tn = sign(tn,a(j,j))
call sscal(nn,1.0/tn,a(j,j),mda)
a(j,j) = a(j,j) + 1.0
if (j == m) go to 250
do i = jp1,m
   bb = -sdot(nn,a(j,j),mda,a(i,j),mda)/a(j,j)
   call saxpy(nn,bb,a(j,j),mda,a(i,j),mda)
   if (i <= np) go to 240
   if (h(i) == 0.0) go to 240
   tt = 1.0 - (a(i,j)/h(i))**2
   tt = max(tt,0.0)
   t = tt
   tt = 1.0 + 0.05*tt*(h(i)/w(i))**2
   if (tt == 1.0) go to 230
   h(i) = h(i)*sqrt(t)
   go to 240
230 h(i) = snrm2(n - j,a(i,j + 1),mda)
   w(i) = h(i)
240 continue
end do
250 h(j) = a(j,j)
a(j,j) = -tn
!          Update ub, db
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j)) + db(j))/a(j,j)
if (j == krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(i,j))*ub(j)
   db(i) = db(i) - a(i,j)*db(j)
end do
go to 100
!        E n D    m A i n    L O O P
300 continue
!        Compute ksure
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do ii = 1,kmi
      if (ub(ii) <= ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310   continue
   end do
   if (is == 0) exit
end do
ksure = 0
sum = 0.0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum >= 1.0) exit
   sum = sum + r2
   ksure = ksure + 1
end do
!     If system is of reduced rank and mode = 2
!     complete the decomposition for shortest least squares solution
if (krank == m .or. mode < 2) return
mmk = m - krank
kp1 = krank + 1
i = krank
340 tn = snrm2(mmk,a(kp1,i),1)/a(i,i)
tn = a(i,i)*sqrt(1.0 + tn*tn)
call sscal(mmk,1.0/tn,a(kp1,i),1)
w(i) = a(i,i)/tn + 1.0
a(i,i) = -tn
if (i == 1) go to 350
im1 = i - 1
do ii = 1,im1
   tt = -sdot(mmk,a(kp1,ii),1,a(kp1,i),1)/w(i)
   tt = tt - a(i,ii)
   call saxpy(mmk,tt,a(kp1,i),1,a(kp1,ii),1)
   a(i,ii) = a(i,ii) + tt*w(i)
end do
i = i - 1
go to 340
350 continue
return
!     First np rows are linearly dependent
400 krank = i - 1
return
410 krank = j - 1
end subroutine u11us

subroutine u12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ir,ic)
!! <!-- nswc-ford:begin U12US -->
!! Reference for `u12us`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Given the Householder LQ factorization of A, this
!!         subroutine solves the system AX=b. if the system
!!         is of reduced rank, this routine returns a solution
!!         according to the selected mode.
!!        Note - If mode.NE.2, w is never accessed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
real, intent(inout) :: a(mda,n), b(mdb,nb)
real :: h(m)
real, intent(inout) :: rnorm(nb)
real :: w(m)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ij, ip1, j, jb, k, kp1, mmk
real :: bb, tt
real :: snrm2
real :: sdot
!        Given the Householder LQ factorization of A, this
!        subroutine solves the system AX=b. if the system
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!       Note - If mode.NE.2, w is never accessed.
k = krank
kp1 = k + 1
if (k > 0) go to 30
!        rank=0
do jb = 1,nb
   rnorm(jb) = snrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
return
30 i = 0
!     Reorder b to reflect row interchanges
40 i = i + 1
if (i == m) go to 100
j = ir(i)
if (j == i) go to 40
if (j < 0) go to 40
ir(i) = -ir(i)
do jb = 1,nb
   rnorm(jb) = b(i,jb)
end do
ij = i
60 do jb = 1,nb
   b(ij,jb) = b(j,jb)
end do
ij = j
j = ir(ij)
ir(ij) = -ir(ij)
if (j /= i) go to 60
do jb = 1,nb
   b(ij,jb) = rnorm(jb)
end do
go to 40
100 do i = 1,m
   ir(i) = abs(ir(i))
end do
!     If A is of reduced rank and mode=2,
!     apply Householder transformations to b
if (mode < 2 .or. k == m) go to 140
mmk = m - k
do jb = 1,nb
   do j = 1,k
      i = kp1 - j
      tt = -sdot(mmk,a(kp1,i),1,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call saxpy(mmk,tt,a(kp1,i),1,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!     Find norms of residual vector(S)..(before overwrite b)
140 do jb = 1,nb
   rnorm(jb) = snrm2(m - k,b(kp1,jb),1)
end do
!     Back solve lower triangular L
do jb = 1,nb
   do i = 1,k
      b(i,jb) = b(i,jb)/a(i,i)
      if (i == k) exit
      ip1 = i + 1
      call saxpy(k - i,-b(i,jb),a(ip1,i),1,b(ip1,jb),1)
   end do
end do
!      Truncated solution
if (k == n) go to 210
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
!     Apply Householder transformations to b
210 do i = 1,k
   j = kp1 - i
   tt = a(j,j)
   a(j,j) = h(j)
   do jb = 1,nb
      bb = -sdot(n - j + 1,a(j,j),mda,b(j,jb),1)/h(j)
      call saxpy(n - j + 1,bb,a(j,j),mda,b(j,jb),1)
   end do
   a(j,j) = tt
end do
!     Reorder b to reflect column interchanges
i = 0
240 i = i + 1
if (i == n) go to 260
j = ic(i)
if (j == i) go to 240
if (j < 0) go to 240
ic(i) = -ic(i)
250 call sswap(nb,b(j,1),mdb,b(i,1),mdb)
ij = ic(j)
ic(j) = -ic(j)
j = ij
if (j /= i) go to 250
go to 240
260 do i = 1,n
   ic(i) = abs(ic(i))
end do
end subroutine u12us

pure subroutine dlsqr(ind, a, mda, m, n, b, mdb, nb, re, ae, krank, &
   & ksure, rnorm, work, lw, iwork, liw, ierr)
!! <!-- nswc-ford:begin DLSQR -->
!! Reference for `dlsqr`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!               Least squares solution of linear equations
!!
!!      dlsqr solves both underdetermined and overdetermined linear
!!      systems AX = b, where A is an m by n matrix and b is an m by
!!      nb matrix of right hand sides. If m .GE. n, the least squares
!!      solution is computed by decomposing the matrix a into the
!!      product of an orthogonal matrix Q and upper triangular matrix
!!      R (QR factorization). If m .LT. n, the minimal length solution
!!      is computed by factoring the matrix a into the product of a
!!      lower triangular matrix L and orthogonal matrix Q (LQ factor-
!!      ization). If the matrix a is determined to be rank deficient,
!!      then the minimal length least squares solution is computed.
!!      User input bounds on the uncertainty of the elements of A are
!!      used to detect numerical rank deficiency. The algorithm uses
!!      a row and column pivot strategy to minimize the growth of
!!      uncertainty and round-off errors.
!!
!!    *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!!
!!      Input..
!!      IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!!                    called for the first time.
!!                       ind = 0      Original call
!!                       ind .NE. 0   subsequent calls
!!                    on subsequent calls a new set b of equations can
!!                    be solved (using the same coefficient matrix a).
!!                    It is assumed that A, mda, m, n, krank, iwork,
!!                    liw, and the first 2*min(m,n) locations of work
!!                    have not been modified by the user. re, ae, and
!!                    ksure are not used.
!!      a(,)          linear coefficient matrix of AX=b, with mda the
!!       mda,m,n      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!!                    m is the row dimension (no. of equations of the
!!                    problem) and n the col dimension (no. of unknowns).
!!                    Must have mda .GE. m.
!!      b(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!!       MDB,nb       DIMENSION OF b IN THE CALLING PROGRAM. nb IS THE
!!                    number of m by 1 right hand sides. Must have
!!                    mdb .GE. max(m,n). If nb .LE. 0 then b and mdb
!!                    are ignored.
!!      re            re IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!!                    elements of the matrix a (0 .le. re .LT. 1).
!!      ae            ae IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!!                    elements of the matrix a (ae .GE. 0).
!!      work()        A REAL WORK ARRAY DIMENSIONED 5*min(m,n).
!!      lw            ACTUAL DIMENSION OF WORK
!!      iwork()       INTEGER WORK ARRAY DIMENSIONED AT LEAST n+m.
!!      liw           ACTUAL DIMENSION OF iwork.
!!      Output..
!!      a(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!!                    and the transformation information.Ind together with
!!                    the first 2*min(m,n) elements of work (see below)
!!                    completely specify the factorization of A.
!!      b(,)          CONTAINS THE n BY nb SOLUTION MATRIX FOR X.
!!      krank,ksure   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!!                    and absolute bounds on uncertainty, is bounded
!!                    above by krank and below by ksure. The algorithm
!!                    returns a solution based on krank. ksure provides
!!                    an indication of the precision of the rank.
!!      rnorm()       CONTAINS THE EUCLIDEAN LENGTH OF THE nb RESIDUAL
!!                    VECTORS  b(i) - AX(i), i=1,...,nb.
!!      work()        THE FIRST 2*min(m,n) LOCATIONS OF WORK CONTAIN
!!                    the values necessary to reproduce the Householder
!!                    factorization of A.
!!      iwork()       AN ARRAY OF LENGTH m + n CONTAINING THE ORDERS IN
!!                    which the rows and columns were used. If m .GE. n
!!                    then the first n locations contain the order of
!!                    the columns and the next m locations the order of
!!                    the rows. If m .LT. n then the order of the rows
!!                    precedes the order of the columns.
!!      ierr          FLAG TO INDICATE THE STATUS OF THE RESULTS
!!                      0     - Satisfactory completion
!!                    .GT. 0  - Input error
!!
!!      The subroutines du11ls, du12ls, du11us, and du12us were written by
!!      T. Manteuffel (LANL) in 1981. The driver routine dlsqr was written
!!      by A.H. Morris (NSWC) in 1991.
!!
!!      Reference.  Manteuffel, T., *An interval analysis approach to rank
!!                  determination in linear least squares problems*,
!!                  Sandia Laboratories report SAND80-0655, June, 1980.
!!
!!      np            if m .GE. n then the first np columns of A
!!                    are never interchanged.
!!                    If m .LT. n then the first np rows of A are
!!                    never interchanged. np is not referenced on
!!                    a continuation call to the routine.
!!      MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!!                    is to react if rank deficiency is detected.
!!                    If mode = 0 Return immediately, no solution
!!                              1 compute truncated solution
!!                              2 compute minimal length solution
!!                    mode must not be modified on a continuation
!!                    CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!!                    first n locations of work are used.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ind
integer, intent(inout) :: krank, ksure
integer, intent(in) :: liw, lw, m, mda, mdb, n, nb
double precision, intent(inout) :: a(mda,n), b(mdb,*)
double precision, intent(in) :: re, ae
double precision, intent(inout) :: rnorm(*), work(lw)
integer, intent(inout) :: iwork(liw)
!     beginning of local variable declarations
integer :: i, imax, info, m0, m1, m2, m3, m4, m5, mode, n0, np
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
   pure subroutine du12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ic &
      & ,ir)
      implicit none
      integer, intent(in) :: nb
      integer, intent(in) :: mdb
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      double precision, intent(inout) :: a(mda,n)
      double precision, intent(inout) :: b(mdb,nb)
      integer, intent(in) :: mode
      integer, intent(in) :: krank
      double precision, intent(inout) :: rnorm(nb)
      double precision, intent(in) :: h(n)
      double precision, intent(in) :: w(n)
      integer, intent(inout) :: ic(n)
      integer, intent(inout) :: ir(m)
   end subroutine du12ls
   pure subroutine du12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ir &
      & ,ic)
      implicit none
      integer, intent(in) :: nb
      integer, intent(in) :: mdb
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: mda
      double precision, intent(inout) :: a(mda,n)
      double precision, intent(inout) :: b(mdb,nb)
      integer, intent(in) :: mode
      integer, intent(in) :: krank
      double precision, intent(inout) :: rnorm(nb)
      double precision, intent(in) :: h(m)
      double precision, intent(in) :: w(m)
      integer, intent(inout) :: ir(m)
      integer, intent(inout) :: ic(n)
   end subroutine du12us
end interface
!-----------------------------------------------------------------------
!              Least squares solution of linear equations
!                            --------------
!     dlsqr solves both underdetermined and overdetermined linear
!     systems AX = b, where A is an m by n matrix and b is an m by
!     nb matrix of right hand sides. If m .GE. n, the least squares
!     solution is computed by decomposing the matrix a into the
!     product of an orthogonal matrix Q and upper triangular matrix
!     R (QR factorization). If m .LT. n, the minimal length solution
!     is computed by factoring the matrix a into the product of a
!     lower triangular matrix L and orthogonal matrix Q (LQ factor-
!     ization). If the matrix a is determined to be rank deficient,
!     then the minimal length least squares solution is computed.
!     User input bounds on the uncertainty of the elements of A are
!     used to detect numerical rank deficiency. The algorithm uses
!     a row and column pivot strategy to minimize the growth of
!     uncertainty and round-off errors.
!   ******************************************************************
!   *                                                                *
!   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!   *                                                                *
!   ******************************************************************
!     Input..
!     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!                   called for the first time.
!                      ind = 0      Original call
!                      ind .NE. 0   subsequent calls
!                   on subsequent calls a new set b of equations can
!                   be solved (using the same coefficient matrix a).
!                   It is assumed that A, mda, m, n, krank, iwork,
!                   liw, and the first 2*min(m,n) locations of work
!                   have not been modified by the user. re, ae, and
!                   ksure are not used.
!     a(,)          linear coefficient matrix of AX=b, with mda the
!      mda,m,n      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!                   m is the row dimension (no. of equations of the
!                   problem) and n the col dimension (no. of unknowns).
!                   Must have mda .GE. m.
!     b(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!      MDB,nb       DIMENSION OF b IN THE CALLING PROGRAM. nb IS THE
!                   number of m by 1 right hand sides. Must have
!                   mdb .GE. max(m,n). If nb .LE. 0 then b and mdb
!                   are ignored.
!     re            re IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!                   elements of the matrix a (0 .le. re .LT. 1).
!     ae            ae IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!                   elements of the matrix a (ae .GE. 0).
!     work()        A REAL WORK ARRAY DIMENSIONED 5*min(m,n).
!     lw            ACTUAL DIMENSION OF WORK
!     iwork()       INTEGER WORK ARRAY DIMENSIONED AT LEAST n+m.
!     liw           ACTUAL DIMENSION OF iwork.
!     Output..
!     a(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!                   and the transformation information.Ind together with
!                   the first 2*min(m,n) elements of work (see below)
!                   completely specify the factorization of A.
!     b(,)          CONTAINS THE n BY nb SOLUTION MATRIX FOR X.
!     krank,ksure   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!                   and absolute bounds on uncertainty, is bounded
!                   above by krank and below by ksure. The algorithm
!                   returns a solution based on krank. ksure provides
!                   an indication of the precision of the rank.
!     rnorm()       CONTAINS THE EUCLIDEAN LENGTH OF THE nb RESIDUAL
!                   VECTORS  b(i) - AX(i), i=1,...,nb.
!     work()        THE FIRST 2*min(m,n) LOCATIONS OF WORK CONTAIN
!                   the values necessary to reproduce the Householder
!                   factorization of A.
!     iwork()       AN ARRAY OF LENGTH m + n CONTAINING THE ORDERS IN
!                   which the rows and columns were used. If m .GE. n
!                   then the first n locations contain the order of
!                   the columns and the next m locations the order of
!                   the rows. If m .LT. n then the order of the rows
!                   precedes the order of the columns.
!     ierr          FLAG TO INDICATE THE STATUS OF THE RESULTS
!                     0     - Satisfactory completion
!                   .GT. 0  - Input error
!----------------
!     The subroutines du11ls, du12ls, du11us, and du12us were written by
!     T. Manteuffel (LANL) in 1981. The driver routine dlsqr was written
!     by A.H. Morris (NSWC) in 1991.
!----------------
!     Reference.  Manteuffel, T., *An interval analysis approach to rank
!                 determination in linear least squares problems*,
!                 Sandia Laboratories report SAND80-0655, June, 1980.
!-----------------------------------------------------------------------
!----------------
!     np            if m .GE. n then the first np columns of A
!                   are never interchanged.
!                   If m .LT. n then the first np rows of A are
!                   never interchanged. np is not referenced on
!                   a continuation call to the routine.
!     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!                   is to react if rank deficiency is detected.
!                   If mode = 0 Return immediately, no solution
!                             1 compute truncated solution
!                             2 compute minimal length solution
!                   mode must not be modified on a continuation
!                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!                   first n locations of work are used.
!----------------
np = 0
mode = 2
!     Check the input
if (nb <= 0 .and. ind /= 0) go to 200
if (m < 1 .or. n < 1) go to 210
if (mda < m) go to 220
if (liw < m + n) go to 240
m0 = min(m,n)
n0 = max(m,n)
!     num = 0
if (nb <= 0) go to 10
if (mdb < n0) go to 230
if (ind /= 0) go to 100
10 if (lw < 5*m0) go to 250
if (re < 0.d0 .or. ae < 0.d0) go to 260
!     Define the relative and absolute tolerance lists
m1 = 1
m2 = m1 + m0
m3 = m2 + m0
m4 = m3 + m0
m5 = m4 + m0
eps = 10.d0*dpmpar(1)
rerr = max(eps,re)
imax = m5 - 1
do i = m4,imax
   work(i) = rerr
end do
imax = imax + m0
do i = m5,imax
   work(i) = ae
end do
!     Factor the matrix a
!     num = np
if (m < n) go to 40
call du11ls(a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
go to 100
40 call du11us(a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
   & work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
!     Solution phase
100 ierr = 0
info = 0
if (krank == m0) go to 110
if (krank == 0) go to 110
!     if (krank .lt. num) go to 280
!     if (mode .eq. 0) return
info = mode
110 if (nb <= 0) return
m1 = 1
m2 = 1 + m0
if (info == 2) go to 130
!     Only min(m,n) elements of work are needed
if (lw < m0) go to 250
if (m < n) go to 120
call du12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m1),iwork(m1),iwork(m2))
return
120 call du12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m1),iwork(m1),iwork(m2))
return
!     Here 2*min(m,n) elements of work are needed
130 if (lw < 2*m0) go to 250
if (m < n) go to 140
call du12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m2),iwork(m1),iwork(m2))
return
140 call du12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
   & work(m1),work(m2),iwork(m1),iwork(m2))
return
!     Error return
!                             nb .LE. 0  on a continuation call
200 ierr = 7
return
!                             m .LT. 1 OR n .LT. 1
210 ierr = 1
return
!                             mda .LT. m
220 ierr = 2
return
!                             mdb .LT. max(m,n)
230 ierr = 3
return
!                             liw .LT. m + n
240 ierr = 4
return
!                             lw too small
250 ierr = 5
return
!                             re or ae is negative
260 ierr = 6
!                             0 .LT. krank .LT. np
! 280 ierr = 8
!     return
end subroutine dlsqr

pure subroutine du11ls(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
   & ic,ir)
!! <!-- nswc-ford:begin DU11LS -->
!! Reference for `du11ls`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!        This routine performs A QR factorization of A
!!        using Householder transformations. Row and
!!        column pivots are chosen to reduce the growth
!!        of round-off and to help detect possible rank
!!        deficiency.
!!         Initialization
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
double precision, intent(inout) :: a(mda,n), ub(n), db(n), h(n), &
   & w(n), eb(n)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
   & kp1, kz, l, lm1, mm, nmk
double precision :: bb, rmin, r2, sum, t, temp, tn, tt
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
   pure function dnrm2(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dnrm2
   end function dnrm2
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure subroutine dswap(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dswap
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
   pure subroutine iswap(n,ix,incx,iy,incy)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix(*)
      integer, intent(in) :: incx
      integer, intent(inout) :: iy(*)
      integer, intent(in) :: incy
   end subroutine iswap
end interface
!       This routine performs A QR factorization of A
!       using Householder transformations. Row and
!       column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!        Initialization
j = 0
krank = n
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!        Determine rel and abs error vectors
!        calculate col length
do i = 1,n
   h(i) = dnrm2(m,a(1,i),1)
   w(i) = h(i)
end do
!         Initialize error bounds
do i = 1,n
   eb(i) = max(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.d0
end do
!          Discard self dependent columns
i = 1
50 if (eb(i) >= h(i)) go to 60
if (i == krank) go to 70
i = i + 1
go to 50
!          Matrix reduction
60 kk = krank
krank = krank - 1
if (mode == 0) return
if (i <= np) go to 400
if (i > krank) go to 70
call dswap(1,eb(i),1,eb(kk),1)
call dswap(1,ub(i),1,ub(kk),1)
call dswap(1,w(i),1,w(kk),1)
call dswap(1,h(i),1,h(kk),1)
call iswap(1,ic(i),1,ic(kk),1)
call dswap(m,a(1,i),1,a(1,kk),1)
go to 50
!           Test for zero rank
70 if (krank > 0) go to 100
krank = 0
ksure = 0
return
!        m A i n    L O O P
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j <= np) kz = j
!        Each col has MM=m-j+1 components
mm = m - j + 1
!         ub determines column pivot
110 imin = j
if (h(j) == 0.d0) go to 170
rmin = ub(j)/h(j)
do i = j,kz
   if (ub(i) >= h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
end do
!     Test for rank deficiency
if (rmin < 1.d0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt >= 1.d0) go to 170
!     Compute exact ub
do i = 1,jm1
   w(i) = a(i,imin)
end do
l = jm1
130 w(l) = w(l)/a(l,l)
if (l == 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(lm1,i)*w(i)
end do
l = lm1
go to 130
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) >= 1.d0) go to 170
go to 200
!        Matrix reduction
170 kk = krank
krank = krank - 1
kz = krank
if (mode == 0) return
if (j <= np) go to 410
if (imin > krank) go to 180
call iswap(1,ic(imin),1,ic(kk),1)
call dswap(m,a(1,imin),1,a(1,kk),1)
call dswap(1,eb(imin),1,eb(kk),1)
call dswap(1,ub(imin),1,ub(kk),1)
call dswap(1,db(imin),1,db(kk),1)
call dswap(1,w(imin),1,w(kk),1)
call dswap(1,h(imin),1,h(kk),1)
180 if (j > krank) go to 300
go to 110
!        Column pivot
200 if (imin == j) go to 210
call dswap(1,h(j),1,h(imin),1)
call dswap(m,a(1,j),1,a(1,imin),1)
call dswap(1,eb(j),1,eb(imin),1)
call dswap(1,ub(j),1,ub(imin),1)
call dswap(1,db(j),1,db(imin),1)
call dswap(1,w(j),1,w(imin),1)
call iswap(1,ic(j),1,ic(imin),1)
!        Row pivot
210 jmax = idamax(mm,a(j,j),1)
jmax = jmax + j - 1
if (jmax == j) go to 220
call dswap(n,a(j,1),mda,a(jmax,1),mda)
call iswap(1,ir(j),1,ir(jmax),1)
!     Apply Householder transformation
220 tn = dnrm2(mm,a(j,j),1)
if (tn == 0.d0) go to 170
if (a(j,j) /= 0.d0) tn = sign(tn,a(j,j))
call dscal(mm,1.d0/tn,a(j,j),1)
a(j,j) = a(j,j) + 1.d0
if (j == n) go to 250
do i = jp1,n
   bb = -ddot(mm,a(j,j),1,a(j,i),1)/a(j,j)
   call daxpy(mm,bb,a(j,j),1,a(j,i),1)
   if (i <= np) go to 240
   if (h(i) == 0.d0) go to 240
   tt = 1.d0 - (a(j,i)/h(i))**2
   tt = max(tt,0.d0)
   t = tt
   tt = 1.d0 + 0.05d0*tt*(h(i)/w(i))**2
   if (tt == 1.d0) go to 230
   h(i) = h(i)*sqrt(t)
   go to 240
230 h(i) = dnrm2(m - j,a(j + 1,i),1)
   w(i) = h(i)
240 continue
end do
250 h(j) = a(j,j)
a(j,j) = -tn
!          Update ub, db
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j)) + db(j))/a(j,j)
if (j == krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(j,i))*ub(j)
   db(i) = db(i) - a(j,i)*db(j)
end do
go to 100
!        E n D    m A i n    L O O P
300 continue
!        Compute ksure
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do ii = 1,kmi
      if (ub(ii) <= ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310   continue
   end do
   if (is == 0) exit
end do
ksure = 0
sum = 0.d0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum >= 1.d0) exit
   sum = sum + r2
   ksure = ksure + 1
end do
!     If system is of reduced rank and mode = 2
!     complete the decomposition for shortest least squares solution
if (krank == n .or. mode < 2) return
nmk = n - krank
kp1 = krank + 1
i = krank
340 tn = dnrm2(nmk,a(i,kp1),mda)/a(i,i)
tn = a(i,i)*sqrt(1.d0 + tn*tn)
call dscal(nmk,1.d0/tn,a(i,kp1),mda)
w(i) = a(i,i)/tn + 1.d0
a(i,i) = -tn
if (i == 1) go to 350
im1 = i - 1
do ii = 1,im1
   tt = -ddot(nmk,a(ii,kp1),mda,a(i,kp1),mda)/w(i)
   tt = tt - a(ii,i)
   call daxpy(nmk,tt,a(i,kp1),mda,a(ii,kp1),mda)
   a(ii,i) = a(ii,i) + tt*w(i)
end do
i = i - 1
go to 340
350 continue
return
!     First np columns are linearly dependent
400 krank = i - 1
return
410 krank = j - 1
end subroutine du11ls

pure subroutine du12ls(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ic,ir)
!! <!-- nswc-ford:begin DU12LS -->
!! Reference for `du12ls`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Given the Householder QR factorization of A, this
!!         subroutine solves the system AX=b. if the system
!!         is of reduced rank, this routine returns a solution
!!         according to the selected mode.
!!        Note - If mode.NE.2, w is never accessed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
double precision, intent(inout) :: a(mda,n), b(mdb,nb), rnorm(nb)
double precision, intent(in) :: h(n), w(n)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ij, im1, j, jb, k, kp1, nmk
double precision :: bb, tt
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
   pure function dnrm2(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dnrm2
   end function dnrm2
   pure subroutine dswap(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dswap
end interface
!        Given the Householder QR factorization of A, this
!        subroutine solves the system AX=b. if the system
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!       Note - If mode.NE.2, w is never accessed.
k = krank
kp1 = k + 1
if (k > 0) go to 30
!        rank=0
do jb = 1,nb
   rnorm(jb) = dnrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.d0
   end do
end do
return
30 i = 0
!     Reorder b to reflect row interchanges
40 i = i + 1
if (i == m) go to 100
j = ir(i)
if (j == i) go to 40
if (j < 0) go to 40
ir(i) = -ir(i)
do jb = 1,nb
   rnorm(jb) = b(i,jb)
end do
ij = i
60 do jb = 1,nb
   b(ij,jb) = b(j,jb)
end do
ij = j
j = ir(ij)
ir(ij) = -ir(ij)
if (j /= i) go to 60
do jb = 1,nb
   b(ij,jb) = rnorm(jb)
end do
go to 40
100 do i = 1,m
   ir(i) = abs(ir(i))
end do
!     Apply Householder transformations to b
do j = 1,k
   tt = a(j,j)
   a(j,j) = h(j)
   do i = 1,nb
      bb = -ddot(m - j + 1,a(j,j),1,b(j,i),1)/h(j)
      call daxpy(m - j + 1,bb,a(j,j),1,b(j,i),1)
   end do
   a(j,j) = tt
end do
!        Find norms of residual vector(S)..(before overwrite b)
do jb = 1,nb
   rnorm(jb) = dnrm2(m - k,b(kp1,jb),1)
end do
!     Back solve upper triangular R
i = k
150 do jb = 1,nb
   b(i,jb) = b(i,jb)/a(i,i)
end do
if (i == 1) go to 200
im1 = i - 1
do jb = 1,nb
   call daxpy(im1,-b(i,jb),a(1,i),1,b(1,jb),1)
end do
i = im1
go to 150
!     RANK LT n
!      truncated solution
200 if (k == n) go to 230
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.d0
   end do
end do
if (mode == 1) go to 230
!      Minimal length solution
nmk = n - k
do jb = 1,nb
   do i = 1,k
      tt = -ddot(nmk,a(i,kp1),mda,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call daxpy(nmk,tt,a(i,kp1),mda,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!     Reorder b to reflect column interchanges
230 i = 0
240 i = i + 1
if (i == n) go to 260
j = ic(i)
if (j == i) go to 240
if (j < 0) go to 240
ic(i) = -ic(i)
250 call dswap(nb,b(j,1),mdb,b(i,1),mdb)
ij = ic(j)
ic(j) = -ic(j)
j = ij
if (j /= i) go to 250
go to 240
260 do i = 1,n
   ic(i) = abs(ic(i))
end do
end subroutine du12ls

pure subroutine du11us(a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
   & ir,ic)
!! <!-- nswc-ford:begin DU11US -->
!! Reference for `du11us`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!        This routine performs an LQ factorization of the
!!        matrix a using Householder transformations. Row
!!        and column pivots are chosen to reduce the growth
!!        of round-off and to help detect possible rank
!!        deficiency.
!!         Initialization
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
double precision, intent(inout) :: a(mda,n), ub(m), db(m), h(m), &
   & w(m), eb(m)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
   & kp1, kz, l, lm1, mmk, nn
double precision :: bb, rmin, r2, sum, t, temp, tn, tt
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
   pure function dnrm2(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dnrm2
   end function dnrm2
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure subroutine dswap(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dswap
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
   pure subroutine iswap(n,ix,incx,iy,incy)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix(*)
      integer, intent(in) :: incx
      integer, intent(inout) :: iy(*)
      integer, intent(in) :: incy
   end subroutine iswap
end interface
!       This routine performs an LQ factorization of the
!       matrix a using Householder transformations. Row
!       and column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!        Initialization
j = 0
krank = m
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!        Determine rel and abs error vectors
!        calculate row length
do i = 1,m
   h(i) = dnrm2(n,a(i,1),mda)
   w(i) = h(i)
end do
!         Initialize error bounds
do i = 1,m
   eb(i) = max(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.d0
end do
!          Discard self dependent rows
i = 1
50 if (eb(i) >= h(i)) go to 60
if (i == krank) go to 70
i = i + 1
go to 50
!          Matrix reduction
60 kk = krank
krank = krank - 1
if (mode == 0) return
if (i <= np) go to 400
if (i > krank) go to 70
call dswap(1,eb(i),1,eb(kk),1)
call dswap(1,ub(i),1,ub(kk),1)
call dswap(1,w(i),1,w(kk),1)
call dswap(1,h(i),1,h(kk),1)
call iswap(1,ir(i),1,ir(kk),1)
call dswap(n,a(i,1),mda,a(kk,1),mda)
go to 50
!           Test for zero rank
70 if (krank > 0) go to 100
krank = 0
ksure = 0
return
!        m A i n    L O O P
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j <= np) kz = j
!        Each row has NN=n-j+1 components
nn = n - j + 1
!         ub determines row pivot
110 imin = j
if (h(j) == 0.d0) go to 170
rmin = ub(j)/h(j)
do i = j,kz
   if (ub(i) >= h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
end do
!     Test for rank deficiency
if (rmin < 1.d0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt >= 1.d0) go to 170
!     Compute exact ub
do i = 1,jm1
   w(i) = a(imin,i)
end do
l = jm1
130 w(l) = w(l)/a(l,l)
if (l == 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(i,lm1)*w(i)
end do
l = lm1
go to 130
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) >= 1.d0) go to 170
go to 200
!        Matrix reduction
170 kk = krank
krank = krank - 1
kz = krank
if (mode == 0) return
if (j <= np) go to 410
if (imin > krank) go to 180
call iswap(1,ir(imin),1,ir(kk),1)
call dswap(n,a(imin,1),mda,a(kk,1),mda)
call dswap(1,eb(imin),1,eb(kk),1)
call dswap(1,ub(imin),1,ub(kk),1)
call dswap(1,db(imin),1,db(kk),1)
call dswap(1,w(imin),1,w(kk),1)
call dswap(1,h(imin),1,h(kk),1)
180 if (j > krank) go to 300
go to 110
!        Row pivot
200 if (imin == j) go to 210
call dswap(1,h(j),1,h(imin),1)
call dswap(n,a(j,1),mda,a(imin,1),mda)
call dswap(1,eb(j),1,eb(imin),1)
call dswap(1,ub(j),1,ub(imin),1)
call dswap(1,db(j),1,db(imin),1)
call dswap(1,w(j),1,w(imin),1)
call iswap(1,ir(j),1,ir(imin),1)
!        Column pivot
210 jmax = idamax(nn,a(j,j),mda)
jmax = jmax + j - 1
if (jmax == j) go to 220
call dswap(m,a(1,j),1,a(1,jmax),1)
call iswap(1,ic(j),1,ic(jmax),1)
!     Apply Householder transformation
220 tn = dnrm2(nn,a(j,j),mda)
if (tn == 0.d0) go to 170
if (a(j,j) /= 0.d0) tn = sign(tn,a(j,j))
call dscal(nn,1.d0/tn,a(j,j),mda)
a(j,j) = a(j,j) + 1.d0
if (j == m) go to 250
do i = jp1,m
   bb = -ddot(nn,a(j,j),mda,a(i,j),mda)/a(j,j)
   call daxpy(nn,bb,a(j,j),mda,a(i,j),mda)
   if (i <= np) go to 240
   if (h(i) == 0.d0) go to 240
   tt = 1.0 - (a(i,j)/h(i))**2
   tt = max(tt,0.d0)
   t = tt
   tt = 1.d0 + 0.05d0*tt*(h(i)/w(i))**2
   if (tt == 1.d0) go to 230
   h(i) = h(i)*sqrt(t)
   go to 240
230 h(i) = dnrm2(n - j,a(i,j + 1),mda)
   w(i) = h(i)
240 continue
end do
250 h(j) = a(j,j)
a(j,j) = -tn
!          Update ub, db
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j)) + db(j))/a(j,j)
if (j == krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(i,j))*ub(j)
   db(i) = db(i) - a(i,j)*db(j)
end do
go to 100
!        E n D    m A i n    L O O P
300 continue
!        Compute ksure
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do ii = 1,kmi
      if (ub(ii) <= ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310   continue
   end do
   if (is == 0) exit
end do
ksure = 0
sum = 0.d0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum >= 1.d0) exit
   sum = sum + r2
   ksure = ksure + 1
end do
!     If system is of reduced rank and mode = 2
!     complete the decomposition for shortest least squares solution
if (krank == m .or. mode < 2) return
mmk = m - krank
kp1 = krank + 1
i = krank
340 tn = dnrm2(mmk,a(kp1,i),1)/a(i,i)
tn = a(i,i)*sqrt(1.d0 + tn*tn)
call dscal(mmk,1.d0/tn,a(kp1,i),1)
w(i) = a(i,i)/tn + 1.d0
a(i,i) = -tn
if (i == 1) go to 350
im1 = i - 1
do ii = 1,im1
   tt = -ddot(mmk,a(kp1,ii),1,a(kp1,i),1)/w(i)
   tt = tt - a(i,ii)
   call daxpy(mmk,tt,a(kp1,i),1,a(kp1,ii),1)
   a(i,ii) = a(i,ii) + tt*w(i)
end do
i = i - 1
go to 340
350 continue
return
!     First np rows are linearly dependent
400 krank = i - 1
return
410 krank = j - 1
end subroutine du11us

pure subroutine du12us(a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ir,ic)
!! <!-- nswc-ford:begin DU12US -->
!! Reference for `du12us`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!         Given the Householder LQ factorization of A, this
!!         subroutine solves the system AX=b. if the system
!!         is of reduced rank, this routine returns a solution
!!         according to the selected mode.
!!        Note - If mode.NE.2, w is never accessed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
double precision, intent(inout) :: a(mda,n), b(mdb,nb), rnorm(nb)
double precision, intent(in) :: h(m), w(m)
integer, intent(inout) :: ic(n), ir(m)
!     beginning of local variable declarations
integer :: i, ij, ip1, j, jb, k, kp1, mmk
double precision :: bb, tt
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
   pure function dnrm2(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dnrm2
   end function dnrm2
   pure subroutine dswap(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dswap
end interface
!        Given the Householder LQ factorization of A, this
!        subroutine solves the system AX=b. if the system
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!       Note - If mode.NE.2, w is never accessed.
k = krank
kp1 = k + 1
if (k > 0) go to 30
!        rank=0
do jb = 1,nb
   rnorm(jb) = dnrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.d0
   end do
end do
return
30 i = 0
!     Reorder b to reflect row interchanges
40 i = i + 1
if (i == m) go to 100
j = ir(i)
if (j == i) go to 40
if (j < 0) go to 40
ir(i) = -ir(i)
do jb = 1,nb
   rnorm(jb) = b(i,jb)
end do
ij = i
60 do jb = 1,nb
   b(ij,jb) = b(j,jb)
end do
ij = j
j = ir(ij)
ir(ij) = -ir(ij)
if (j /= i) go to 60
do jb = 1,nb
   b(ij,jb) = rnorm(jb)
end do
go to 40
100 do i = 1,m
   ir(i) = abs(ir(i))
end do
!     If A is of reduced rank and mode=2,
!     apply Householder transformations to b
if (mode < 2 .or. k == m) go to 140
mmk = m - k
do jb = 1,nb
   do j = 1,k
      i = kp1 - j
      tt = -ddot(mmk,a(kp1,i),1,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call daxpy(mmk,tt,a(kp1,i),1,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!     Find norms of residual vector(S)..(before overwrite b)
140 do jb = 1,nb
   rnorm(jb) = dnrm2(m - k,b(kp1,jb),1)
end do
!     Back solve lower triangular L
do jb = 1,nb
   do i = 1,k
      b(i,jb) = b(i,jb)/a(i,i)
      if (i == k) exit
      ip1 = i + 1
      call daxpy(k - i,-b(i,jb),a(ip1,i),1,b(ip1,jb),1)
   end do
end do
!      Truncated solution
if (k == n) go to 210
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.d0
   end do
end do
!     Apply Householder transformations to b
210 do i = 1,k
   j = kp1 - i
   tt = a(j,j)
   a(j,j) = h(j)
   do jb = 1,nb
      bb = -ddot(n - j + 1,a(j,j),mda,b(j,jb),1)/h(j)
      call daxpy(n - j + 1,bb,a(j,j),mda,b(j,jb),1)
   end do
   a(j,j) = tt
end do
!     Reorder b to reflect column interchanges
i = 0
240 i = i + 1
if (i == n) go to 260
j = ic(i)
if (j == i) go to 240
if (j < 0) go to 240
ic(i) = -ic(i)
250 call dswap(nb,b(j,1),mdb,b(i,1),mdb)
ij = ic(j)
ic(j) = -ic(j)
j = ij
if (j /= i) go to 250
go to 240
260 do i = 1,n
   ic(i) = abs(ic(i))
end do
end subroutine du12us

pure subroutine hfti(a,mda,m,n,b,mdb,nb,tau,k,rnorm,h,g,ip)
!! <!-- nswc-ford:begin HFTI -->
!! Reference for `hfti`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      dimension a(mda,n),(b(mdb,nb) or b(m)),rnorm(nb),h(n),g(n),ip(n)
!!      written by C.L. Lawson and R.J. Hanson.
!!      From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!!      For algorithmic details see algorithm hfti in chapter 14.
!!      Abstract
!!      this subroutine solves a linear least squares problem or a set of
!!      linear least squares problems having the same matrix but different
!!      right-side vectors.  The problem data consists of an m by n matrix
!!      A, an m by nb matrix b, and an absolute tolerance parameter tau
!!      whose usage is described below.  The nb column vectors of b
!!      represent right-side vectors for nb distinct linear least squares
!!      problems.
!!      This set of problems can also be written as the matrix least
!!      squares problem
!!                        ax = b,
!!      where X is the n by nb solution matrix.
!!      Note that if b is the m by m identity matrix, then X will be the
!!      pseudo-inverse of A.
!!      This subroutine first transforms the augmented matrix (A b) to A
!!      matrix (R C) using premultiplying Householder transformations with
!!      column interchanges.  All subdiagonal elements in the matrix R are
!!      zero and its diagonal elements satisfy
!!                        abs(R(i,i)).GE.abs(R(i+1,i+1)),
!!                        i = 1,...,l-1, where
!!                        l = min(m,n).
!!      The subroutine sets k to be the number of diagonal elements
!!      of R that exceed tau in magnitude. Then the solution of minimum
!!      Euclidean length is computed using the first k rows of (R C).
!!      To be specific we suggest that the user consider an easily
!!      computable matrix NORM, such as, the maximum of all column sums of
!!      magnitudes.
!!      Now if the relative uncertainty of b is eps, (norm of uncertainty/
!!      norm of b), it is suggested that tau be set approximately equal to
!!      eps*(norm of A).
!!      The entire set of parameters for hfti are
!!      input..
!!      a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!!                        matrix a of the least squares problem AX = b.
!!                        The first dimensioning parameter of the array
!!                        a(*,*) is mda, which must satisfy mda.GE.m
!!                        either m.GE.n or m.LT.n is permitted.  There
!!                        is no restriction on the rank of A.  the
!!                        condition mda.LT.m is considered an error.
!!      b(*),mdb,nb       if nb = 0 The subroutine will perform the
!!                        orthogonal decomposition but will make no
!!                        references to the array b(*).  If nb.GT.0
!!                        the array b(*) must initially contain the m by
!!                        nb matrix b of the least squares problem AX =
!!                        b.  if nb.GE.2 the array b(*) must be doubly
!!                        subscripted with first dimensioning parameter
!!                        mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!!                        be either doubly or singly subscripted.  In
!!                        the latter case the value of mdb is arbitrary
!!                        but it should be set to some valid integer
!!                        value such as mdb = m.
!!                        The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!!                        is considered an error.
!!      tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!!                        for pseudorank determination.
!!      h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY hfti.
!!      Output..
!!      a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!!                        modified by the subroutine.  These contents
!!                        are not generally required by the user.
!!      b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!!                        nb solution matrix X.
!!      k                 SET BY THE SUBROUTINE TO INDICATE THE
!!                        pseudorank of A.
!!      rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!!                        norm of the residual vector for the problem
!!                        defined by the j-TH column vector of the array
!!                        b(*,*) FOR j = 1,...,nb.
!!      h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!!                        elements of the pre- and post-multiplying
!!                        Householder transformations used to compute
!!                        the minimum Euclidean length solution.
!!      ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!!                        describing the permutation of column vectors.
!!                        The contents of arrays h(*),g(*) and ip(*)
!!                        are not generally required by the user.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
real, intent(inout) :: a(mda,n), b(mdb,*), g(n), h(n), rnorm(*)
real, intent(in) :: tau
integer, intent(inout) :: ip(n)
!     beginning of local variable declarations
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
real :: hmax, sm1, tmp, z
double precision :: sm
real, parameter :: factor = 1.e-3
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
!-----------------------------------------------------------------------
!     dimension a(mda,n),(b(mdb,nb) or b(m)),rnorm(nb),h(n),g(n),ip(n)
!     written by C.L. Lawson and R.J. Hanson.
!     From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!     Abstract
!     this subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!     This set of problems can also be written as the matrix least
!     squares problem
!                       ax = b,
!     where X is the n by nb solution matrix.
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!                       abs(R(i,i)).GE.abs(R(i+1,i+1)),
!                       i = 1,...,l-1, where
!                       l = min(m,n).
!     The subroutine sets k to be the number of diagonal elements
!     of R that exceed tau in magnitude. Then the solution of minimum
!     Euclidean length is computed using the first k rows of (R C).
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!     The entire set of parameters for hfti are
!     input..
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       matrix a of the least squares problem AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) is mda, which must satisfy mda.GE.m
!                       either m.GE.n or m.LT.n is permitted.  There
!                       is no restriction on the rank of A.  the
!                       condition mda.LT.m is considered an error.
!     b(*),mdb,nb       if nb = 0 The subroutine will perform the
!                       orthogonal decomposition but will make no
!                       references to the array b(*).  If nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb matrix b of the least squares problem AX =
!                       b.  if nb.GE.2 the array b(*) must be doubly
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       value such as mdb = m.
!                       The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY hfti.
!     Output..
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!     rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!-----------------------------------------------------------------------
!---------------------
k = 0
ldiag = min(m,n)
if (ldiag <= 0) go to 270
do j = 1,ldiag
   if (j == 1) go to 20
!     Update squared column lengths and find lmax
!    ..
   lmax = j
   do l = j,n
      h(l) = h(l) - a(j - 1,l)**2
      if (h(l) > h(lmax)) lmax = l
   end do
   z = hmax + factor*h(lmax)
   if (z > hmax) go to 50
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
   do l = j,n
      h(l) = 0.0
      do i = j,m
         h(l) = h(l) + a(i,l)**2
      end do
      if (h(l) > h(lmax)) lmax = l
   end do
   hmax = h(lmax)
!    ..
!     lmax has been determined
!     do column interchanges if needed.
!    ..
50 ip(j) = lmax
   if (ip(j) == j) go to 70
   do i = 1,m
      tmp = a(i,j)
      a(i,j) = a(i,lmax)
      a(i,lmax) = tmp
   end do
   h(lmax) = h(j)
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call h12(1,j,j + 1,m,a(1,j),1,h(j),a(1,j + 1),1,mda,n - j)
   call h12(2,j,j + 1,m,a(1,j),1,h(j),b,1,mdb,nb)
end do
!     Determine the pseudorank, k, using the tolerance, tau.
!    ..
do j = 1,ldiag
   if (abs(a(j,j)) <= tau) go to 100
end do
k = ldiag
go to 110
100 k = j - 1
110 kp1 = k + 1
!     Compute the norms of the residual vectors.
if (nb <= 0) go to 140
do jb = 1,nb
   tmp = 0.0
   if (kp1 > m) go to 130
   do i = kp1,m
      tmp = tmp + b(i,jb)**2
   end do
130 rnorm(jb) = sqrt(tmp)
end do
140 continue
!                                           Special for pseudorank = 0
if (k > 0) go to 160
if (nb <= 0) go to 270
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
go to 270
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k == n) go to 180
do ii = 1,k
   i = kp1 - ii
   call h12(1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i - 1)
end do
180 continue
if (nb <= 0) go to 270
do jb = 1,nb
!     Solve the k by k triangular system.
!    ..
   do l = 1,k
      sm = 0.d0
      i = kp1 - l
      if (i == k) go to 200
      ip1 = i + 1
      do j = ip1,k
         sm = sm + dble(a(i,j))*dble(b(j,jb))
      end do
200   sm1 = dble(b(i,jb)) - sm
      b(i,jb) = sm1/a(i,i)
   end do
!     Complete computation of solution vector.
!    ..
   if (k == n) go to 240
   do j = kp1,n
      b(j,jb) = 0.0
   end do
   do i = 1,k
      call h12(2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
   end do
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do jj = 1,ldiag
      j = ldiag + 1 - jj
      if (ip(j) == j) go to 250
      l = ip(j)
      tmp = b(l,jb)
      b(l,jb) = b(j,jb)
      b(j,jb) = tmp
250   continue
   end do
end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
270 return
end subroutine hfti

pure subroutine hfti2(a,mda,m,n,b,mdb,nb,d,tau,k,rnorm,h,g,ip,ierr)
!! <!-- nswc-ford:begin HFTI2 -->
!! Reference for `hfti2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      dimension a(mda,n),(b(mdb,nb) or b(m))
!!      dimension d(l) where l = min(m,n)
!!      dimension rnorm(nb),h(n),g(n),ip(n)
!!      written by C.L. Lawson and R.J. Hanson. Modified by A.H. Morris.
!!      From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!!      For algorithmic details see algorithm hfti in chapter 14.
!!      Abstract
!!      this subroutine solves a linear least squares problem or a set of
!!      linear least squares problems having the same matrix but different
!!      right-side vectors.  The problem data consists of an m by n matrix
!!      A, an m by nb matrix b, and an absolute tolerance parameter tau
!!      whose usage is described below.  The nb column vectors of b
!!      represent right-side vectors for nb distinct linear least squares
!!      problems.
!!      This set of problems can also be written as the matrix least
!!      squares problem
!!                        ax = b,
!!      where X is the n by nb solution matrix.
!!      Note that if b is the m by m identity matrix, then X will be the
!!      pseudo-inverse of A.
!!      This subroutine first transforms the augmented matrix (A b) to A
!!      matrix (R C) using premultiplying Householder transformations with
!!      column interchanges.  All subdiagonal elements in the matrix R are
!!      zero and its diagonal elements satisfy
!!                        abs(R(i,i)).GE.abs(R(i+1,i+1)),
!!                        i = 1,...,l-1, where
!!                        l = min(m,n).
!!      The array d will contain the diagonal elements R(1,1),...,R(l,l).
!!      The subroutine sets k to be the number of diagonal elements that
!!      exceed tau in magnitude.  Then the solution of minimum Euclidean
!!      length is computed using the first k rows of (R C).
!!      To be specific we suggest that the user consider an easily
!!      computable matrix NORM, such as, the maximum of all column sums of
!!      magnitudes.
!!      Now if the relative uncertainty of b is eps, (norm of uncertainty/
!!      norm of b), it is suggested that tau be set approximately equal to
!!      eps*(norm of A).
!!      The entire set of parameters for hfti2 are
!!      input..
!!      a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!!                        matrix a of the least squares problem AX = b.
!!                        The first dimensioning parameter of the array
!!                        a(*,*) is mda, which must satisfy mda.GE.m
!!                        either m.GE.n or m.LT.n is permitted.  There
!!                        is no restriction on the rank of A.  the
!!                        condition mda.LT.m is considered an error.
!!      b(*),mdb,nb       if nb = 0 The subroutine will perform the
!!                        orthogonal decomposition but will make no
!!                        references to the array b(*).  If nb.GT.0
!!                        the array b(*) must initially contain the m by
!!                        nb matrix b of the least squares problem AX =
!!                        b.  if nb.GE.2 the array b(*) must be doubly
!!                        subscripted with first dimensioning parameter
!!                        mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!!                        be either doubly or singly subscripted.  In
!!                        the latter case the value of mdb is arbitrary
!!                        but it should be set to some valid integer
!!                        value such as mdb = m.
!!                        The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!!                        is considered an error.
!!      tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!!                        for pseudorank determination.
!!      h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY hfti2.
!!      Output..
!!      a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!!                        modified by the subroutine.  These contents
!!                        are not generally required by the user.
!!      b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!!                        nb solution matrix X.
!!      d(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!!                        triangular matrix R
!!      k                 SET BY THE SUBROUTINE TO INDICATE THE
!!                        pseudorank of A.
!!      RNORM(*)          ON RETURN, RNORM(j) WILL CONTAIN THE EUCLIDEAN
!!                        norm of the residual vector for the problem
!!                        defined by the j-TH column vector of the array
!!                        b(*,*) FOR j = 1,...,nb.
!!      h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!!                        elements of the pre- and post-multiplying
!!                        Householder transformations used to compute
!!                        the minimum Euclidean length solution.
!!      ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!!                        describing the permutation of column vectors.
!!                        The contents of arrays h(*),g(*) and ip(*)
!!                        are not generally required by the user.
!!      ierr              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!!                        detected then ierr is set to 0. Otherwise
!!                           ierr = 1  IF mda.LT.m
!!                           ierr = 2  If nb.GT.1 and mdb.LT.max(m,n)
!!                        these errors are fatal.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
real, intent(inout) :: a(mda,n), b(mdb,*), d(*), g(n), h(n), &
   & rnorm(*)
real, intent(in) :: tau
integer, intent(inout) :: ip(n)
!     beginning of local variable declarations
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
real :: hmax, sm1, tmp, z
double precision :: sm
real, parameter :: factor = 1.e-3
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
!-----------------------------------------------------------------------
!     dimension a(mda,n),(b(mdb,nb) or b(m))
!     dimension d(l) where l = min(m,n)
!     dimension rnorm(nb),h(n),g(n),ip(n)
!     written by C.L. Lawson and R.J. Hanson. Modified by A.H. Morris.
!     From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!     Abstract
!     this subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!     This set of problems can also be written as the matrix least
!     squares problem
!                       ax = b,
!     where X is the n by nb solution matrix.
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!                       abs(R(i,i)).GE.abs(R(i+1,i+1)),
!                       i = 1,...,l-1, where
!                       l = min(m,n).
!     The array d will contain the diagonal elements R(1,1),...,R(l,l).
!     The subroutine sets k to be the number of diagonal elements that
!     exceed tau in magnitude.  Then the solution of minimum Euclidean
!     length is computed using the first k rows of (R C).
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!     The entire set of parameters for hfti2 are
!     input..
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       matrix a of the least squares problem AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) is mda, which must satisfy mda.GE.m
!                       either m.GE.n or m.LT.n is permitted.  There
!                       is no restriction on the rank of A.  the
!                       condition mda.LT.m is considered an error.
!     b(*),mdb,nb       if nb = 0 The subroutine will perform the
!                       orthogonal decomposition but will make no
!                       references to the array b(*).  If nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb matrix b of the least squares problem AX =
!                       b.  if nb.GE.2 the array b(*) must be doubly
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       value such as mdb = m.
!                       The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY hfti2.
!     Output..
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!     d(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!                       triangular matrix R
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!     RNORM(*)          ON RETURN, RNORM(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!     ierr              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!                       detected then ierr is set to 0. Otherwise
!                          ierr = 1  IF mda.LT.m
!                          ierr = 2  If nb.GT.1 and mdb.LT.max(m,n)
!                       these errors are fatal.
!-----------------------------------------------------------------------
!---------------------
k = 0
ldiag = min(m,n)
if (ldiag <= 0) go to 270
if (m > mda) go to 300
if (nb > 1 .and. max(m,n) > mdb) go to 310
do j = 1,ldiag
   if (j == 1) go to 20
!     Update squared column lengths and find lmax
!    ..
   lmax = j
   do l = j,n
      h(l) = h(l) - a(j - 1,l)**2
      if (h(l) > h(lmax)) lmax = l
   end do
   z = hmax + factor*h(lmax)
   if (z > hmax) go to 50
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
   do l = j,n
      h(l) = 0.0
      do i = j,m
         h(l) = h(l) + a(i,l)**2
      end do
      if (h(l) > h(lmax)) lmax = l
   end do
   hmax = h(lmax)
!    ..
!     lmax has been determined
!     do column interchanges if needed.
!    ..
50 ip(j) = lmax
   if (ip(j) == j) go to 70
   do i = 1,m
      tmp = a(i,j)
      a(i,j) = a(i,lmax)
      a(i,lmax) = tmp
   end do
   h(lmax) = h(j)
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call h12(1,j,j + 1,m,a(1,j),1,h(j),a(1,j + 1),1,mda,n - j)
   call h12(2,j,j + 1,m,a(1,j),1,h(j),b,1,mdb,nb)
end do
!     Determine the pseudorank, k, using the tolerance, tau.
!     Also store the diagonal elements in the array d.
!    ..
do j = 1,ldiag
   if (abs(a(j,j)) <= tau) go to 100
   d(j) = a(j,j)
end do
k = ldiag
kp1 = k + 1
go to 110
100 k = j - 1
kp1 = j
do j = kp1,ldiag
   d(j) = a(j,j)
end do
!     Compute the norms of the residual vectors.
110 if (nb <= 0) go to 140
do jb = 1,nb
   tmp = 0.0
   if (kp1 > m) go to 130
   do i = kp1,m
      tmp = tmp + b(i,jb)**2
   end do
130 rnorm(jb) = sqrt(tmp)
end do
140 continue
!                                           Special for pseudorank = 0
if (k > 0) go to 160
if (nb <= 0) go to 270
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
go to 270
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k == n) go to 180
do ii = 1,k
   i = kp1 - ii
   call h12(1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i - 1)
end do
180 continue
if (nb <= 0) go to 270
do jb = 1,nb
!     Solve the k by k triangular system.
!    ..
   do l = 1,k
      sm = 0.d0
      i = kp1 - l
      if (i == k) go to 200
      ip1 = i + 1
      do j = ip1,k
         sm = sm + dble(a(i,j))*dble(b(j,jb))
      end do
200   sm1 = dble(b(i,jb)) - sm
      b(i,jb) = sm1/a(i,i)
   end do
!     Complete computation of solution vector.
!    ..
   if (k == n) go to 240
   do j = kp1,n
      b(j,jb) = 0.0
   end do
   do i = 1,k
      call h12(2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
   end do
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do jj = 1,ldiag
      j = ldiag + 1 - jj
      if (ip(j) == j) go to 250
      l = ip(j)
      tmp = b(l,jb)
      b(l,jb) = b(j,jb)
      b(j,jb) = tmp
250   continue
   end do
end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
270 ierr = 0
return
!     Error return
300 ierr = 1
return
310 ierr = 2
end subroutine hfti2

pure subroutine h12(mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv)
!! <!-- nswc-ford:begin H12 -->
!! Reference for `h12`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!!      From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!!      Construction and/or application of a single
!!      Householder transformation..     Q = i + u*(u**T)/b
!!      mode    = 1 Or 2   to select algorithm  H1  or  H2 .
!!      lpivot is the index of the pivot element.
!!      l1,m   if l1 .LE. m   the transformation will be constructed to
!!             ZERO ELEMENTS INDEXED FROM l1 THROUGH m.   IF l1 GT. m
!!             the subroutine does an identity transformation.
!!      u(),iue,UP    ON ENTRY TO H1 u() CONTAINS THE PIVOT VECTOR.
!!                    iue is the storage increment between elements.
!!                                        On exit from H1 u() and up
!!                    contain quantities defining the vector u of the
!!                    HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 u()
!!                    and up should contain quantities previously computed
!!                    by H1.  These will not be modified by H2.
!!      c()    ON ENTRY TO H1 OR H2 c() CONTAINS A MATRIX WHICH WILL BE
!!             regarded as a set of vectors to which the Householder
!!             transformation is to be applied.  On exit c() contains the
!!             set of transformed vectors.
!!      ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN c().
!!      icv    STORAGE INCREMENT BETWEEN VECTORS IN c().
!!      ncv    number of vectors in c() to be transformed. If ncv .LE. 0
!!             no operations will be done on c().
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ice, icv, iue, l1, lpivot, m, mode, ncv
real, intent(inout) :: c(*), u(iue,m), up
!     beginning of local variable declarations
integer :: i, i2, i3, i4, incr, j
real :: cl, d, sm1
double precision :: sm, b
!-----------------------------------------------------------------------
!     Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!     From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!     Construction and/or application of a single
!     Householder transformation..     Q = i + u*(u**T)/b
!     mode    = 1 Or 2   to select algorithm  H1  or  H2 .
!     lpivot is the index of the pivot element.
!     l1,m   if l1 .LE. m   the transformation will be constructed to
!            ZERO ELEMENTS INDEXED FROM l1 THROUGH m.   IF l1 GT. m
!            the subroutine does an identity transformation.
!     u(),iue,UP    ON ENTRY TO H1 u() CONTAINS THE PIVOT VECTOR.
!                   iue is the storage increment between elements.
!                                       On exit from H1 u() and up
!                   contain quantities defining the vector u of the
!                   HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 u()
!                   and up should contain quantities previously computed
!                   by H1.  These will not be modified by H2.
!     c()    ON ENTRY TO H1 OR H2 c() CONTAINS A MATRIX WHICH WILL BE
!            regarded as a set of vectors to which the Householder
!            transformation is to be applied.  On exit c() contains the
!            set of transformed vectors.
!     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN c().
!     icv    STORAGE INCREMENT BETWEEN VECTORS IN c().
!     ncv    number of vectors in c() to be transformed. If ncv .LE. 0
!            no operations will be done on c().
!-----------------------------------------------------------------------
if (0 >= lpivot .or. lpivot >= l1 .or. l1 > m) return
cl = abs(u(1,lpivot))
if (mode == 2) go to 60
!                            ****** Construct the transformation. ******
do j = l1,m
   cl = max(abs(u(1,j)),cl)
end do
if (cl <= 0.0) go to 130
d = u(1,lpivot)/cl
sm = d*d
do j = l1,m
   d = u(1,j)/cl
   sm = sm + dble(d*d)
end do
sm1 = sm
cl = cl*sqrt(sm1)
if (u(1,lpivot) > 0.0) cl = -cl
up = u(1,lpivot) - cl
u(1,lpivot) = cl
go to 70
!            ****** Apply the transformation  i+u*(u**T)/b  to c. ******
60 if ((cl) <= 0) go to 130
go to 70
70 if (ncv <= 0) return
b = dble(up)*dble(u(1,lpivot))
!                       b  must be nonpositive here.  If b = 0., Return.
if (b >= 0.d0) go to 130
b = 1.d0/b
i2 = 1 - icv + ice*(lpivot - 1)
incr = ice*(l1 - lpivot)
do j = 1,ncv
   i2 = i2 + icv
   i3 = i2 + incr
   i4 = i3
   sm = dble(c(i2))*dble(up)
   do i = l1,m
      sm = sm + dble(c(i3))*dble(u(1,i))
      i3 = i3 + ice
   end do
   if (sm == 0.d0) go to 120
   sm = sm*b
   c(i2) = c(i2) + sm*dble(up)
   do i = l1,m
      c(i4) = c(i4) + sm*dble(u(1,i))
      i4 = i4 + ice
   end do
120 continue
end do
130 return
end subroutine h12

pure subroutine dhfti(a,mda,m,n,b,mdb,nb,tau,k,rnorm,h,g,ip)
!! <!-- nswc-ford:begin DHFTI -->
!! Reference for `dhfti`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision a(mda,n),(b(mdb,nb) or b(m))
!!      double precision tau,rnorm(nb),h(n),g(n)
!!      integer ip(n)
!!      written by C.L. Lawson and R.J. Hanson.
!!      From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!!      For algorithmic details see algorithm hfti in chapter 14.
!!      Abstract
!!      this subroutine solves a linear least squares problem or a set of
!!      linear least squares problems having the same matrix but different
!!      right-side vectors.  The problem data consists of an m by n matrix
!!      A, an m by nb matrix b, and an absolute tolerance parameter tau
!!      whose usage is described below.  The nb column vectors of b
!!      represent right-side vectors for nb distinct linear least squares
!!      problems.
!!      This set of problems can also be written as the matrix least
!!      squares problem
!!                        ax = b,
!!      where X is the n by nb solution matrix.
!!      Note that if b is the m by m identity matrix, then X will be the
!!      pseudo-inverse of A.
!!      This subroutine first transforms the augmented matrix (A b) to A
!!      matrix (R C) using premultiplying Householder transformations with
!!      column interchanges.  All subdiagonal elements in the matrix R are
!!      zero and its diagonal elements satisfy
!!                        dabs(R(i,i)).GE.dabs(R(i+1,i+1)),
!!                        i = 1,...,l-1, where
!!                        l = min(m,n).
!!      The subroutine sets k to be the number of diagonal elements
!!      of R that exceed tau in magnitude. Then the solution of minimum
!!      Euclidean length is computed using the first k rows of (R C).
!!      To be specific we suggest that the user consider an easily
!!      computable matrix NORM, such as, the maximum of all column sums of
!!      magnitudes.
!!      Now if the relative uncertainty of b is eps, (norm of uncertainty/
!!      norm of b), it is suggested that tau be set approximately equal to
!!      eps*(norm of A).
!!      The entire set of parameters for dhfti are
!!      input..
!!      a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!!                        matrix a of the least squares problem AX = b.
!!                        The first dimensioning parameter of the array
!!                        a(*,*) is mda, which must satisfy mda.GE.m
!!                        either m.GE.n or m.LT.n is permitted.  There
!!                        is no restriction on the rank of A.  the
!!                        condition mda.LT.m is considered an error.
!!      b(*),mdb,nb       if nb = 0 The subroutine will perform the
!!                        orthogonal decomposition but will make no
!!                        references to the array b(*).  If nb.GT.0
!!                        the array b(*) must initially contain the m by
!!                        nb matrix b of the least squares problem AX =
!!                        b.  if nb.GE.2 the array b(*) must be doubly
!!                        subscripted with first dimensioning parameter
!!                        mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!!                        be either doubly or singly subscripted.  In
!!                        the latter case the value of mdb is arbitrary
!!                        but it should be set to some valid integer
!!                        value such as mdb = m.
!!                        The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!!                        is considered an error.
!!      tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!!                        for pseudorank determination.
!!      h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY dhfti.
!!      Output..
!!      a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!!                        modified by the subroutine.  These contents
!!                        are not generally required by the user.
!!      b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!!                        nb solution matrix X.
!!      k                 SET BY THE SUBROUTINE TO INDICATE THE
!!                        pseudorank of A.
!!      rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!!                        norm of the residual vector for the problem
!!                        defined by the j-TH column vector of the array
!!                        b(*,*) FOR j = 1,...,nb.
!!      h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!!                        elements of the pre- and post-multiplying
!!                        Householder transformations used to compute
!!                        the minimum Euclidean length solution.
!!      ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!!                        describing the permutation of column vectors.
!!                        The contents of arrays h(*),g(*) and ip(*)
!!                        are not generally required by the user.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
double precision, intent(inout) :: a(mda,n), b(mdb,*)
double precision, intent(in) :: tau
double precision, intent(inout) :: rnorm(*), h(n), g(n)
integer, intent(inout) :: ip(n)
!     beginning of local variable declarations
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
double precision :: hmax, sm, sm1, tmp, z
double precision, parameter :: factor = 1.d-3
interface
   pure subroutine dh12(mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv &
      & )
      implicit none
      integer, intent(in) :: iue
      integer, intent(in) :: m
      integer, intent(in) :: mode
      integer, intent(in) :: lpivot
      integer, intent(in) :: l1
      double precision, intent(inout) :: u(iue,m)
      double precision, intent(inout) :: up
      double precision, intent(inout) :: c(*)
      integer, intent(in) :: ice
      integer, intent(in) :: icv
      integer, intent(in) :: ncv
   end subroutine dh12
end interface
!-----------------------------------------------------------------------
!     double precision a(mda,n),(b(mdb,nb) or b(m))
!     double precision tau,rnorm(nb),h(n),g(n)
!     integer ip(n)
!     written by C.L. Lawson and R.J. Hanson.
!     From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!     Abstract
!     this subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!     This set of problems can also be written as the matrix least
!     squares problem
!                       ax = b,
!     where X is the n by nb solution matrix.
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!                       dabs(R(i,i)).GE.dabs(R(i+1,i+1)),
!                       i = 1,...,l-1, where
!                       l = min(m,n).
!     The subroutine sets k to be the number of diagonal elements
!     of R that exceed tau in magnitude. Then the solution of minimum
!     Euclidean length is computed using the first k rows of (R C).
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!     The entire set of parameters for dhfti are
!     input..
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       matrix a of the least squares problem AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) is mda, which must satisfy mda.GE.m
!                       either m.GE.n or m.LT.n is permitted.  There
!                       is no restriction on the rank of A.  the
!                       condition mda.LT.m is considered an error.
!     b(*),mdb,nb       if nb = 0 The subroutine will perform the
!                       orthogonal decomposition but will make no
!                       references to the array b(*).  If nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb matrix b of the least squares problem AX =
!                       b.  if nb.GE.2 the array b(*) must be doubly
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       value such as mdb = m.
!                       The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY dhfti.
!     Output..
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!     rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!-----------------------------------------------------------------------
!---------------------
k = 0
ldiag = min(m,n)
if (ldiag <= 0) go to 270
do j = 1,ldiag
   if (j == 1) go to 20
!     Update squared column lengths and find lmax
!    ..
   lmax = j
   do l = j,n
      h(l) = h(l) - a(j - 1,l)**2
      if (h(l) > h(lmax)) lmax = l
   end do
   z = hmax + factor*h(lmax)
   if (z > hmax) go to 50
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
   do l = j,n
      h(l) = 0.d0
      do i = j,m
         h(l) = h(l) + a(i,l)**2
      end do
      if (h(l) > h(lmax)) lmax = l
   end do
   hmax = h(lmax)
!    ..
!     lmax has been determined
!     do column interchanges if needed.
!    ..
50 ip(j) = lmax
   if (ip(j) == j) go to 70
   do i = 1,m
      tmp = a(i,j)
      a(i,j) = a(i,lmax)
      a(i,lmax) = tmp
   end do
   h(lmax) = h(j)
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call dh12(1,j,j + 1,m,a(1,j),1,h(j),a(1,j + 1),1,mda,n - j)
   call dh12(2,j,j + 1,m,a(1,j),1,h(j),b,1,mdb,nb)
end do
!     Determine the pseudorank, k, using the tolerance, tau.
!    ..
do j = 1,ldiag
   if (abs(a(j,j)) <= tau) go to 100
end do
k = ldiag
go to 110
100 k = j - 1
110 kp1 = k + 1
!     Compute the norms of the residual vectors.
if (nb <= 0) go to 140
do jb = 1,nb
   tmp = 0.d0
   if (kp1 > m) go to 130
   do i = kp1,m
      tmp = tmp + b(i,jb)**2
   end do
130 rnorm(jb) = sqrt(tmp)
end do
140 continue
!                                           Special for pseudorank = 0
if (k > 0) go to 160
if (nb <= 0) go to 270
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.d0
   end do
end do
go to 270
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k == n) go to 180
do ii = 1,k
   i = kp1 - ii
   call dh12(1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i - 1)
end do
180 continue
if (nb <= 0) go to 270
do jb = 1,nb
!     Solve the k by k triangular system.
!    ..
   do l = 1,k
      sm = 0.d0
      i = kp1 - l
      if (i == k) go to 200
      ip1 = i + 1
      do j = ip1,k
         sm = sm + a(i,j)*b(j,jb)
      end do
200   sm1 = b(i,jb) - sm
      b(i,jb) = sm1/a(i,i)
   end do
!     Complete computation of solution vector.
!    ..
   if (k == n) go to 240
   do j = kp1,n
      b(j,jb) = 0.d0
   end do
   do i = 1,k
      call dh12(2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
   end do
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do jj = 1,ldiag
      j = ldiag + 1 - jj
      if (ip(j) == j) go to 250
      l = ip(j)
      tmp = b(l,jb)
      b(l,jb) = b(j,jb)
      b(j,jb) = tmp
250   continue
   end do
end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
270 return
end subroutine dhfti

pure subroutine dhfti2(a,mda,m,n,b,mdb,nb,d,tau,k,rnorm,h,g,ip,ierr)
!! <!-- nswc-ford:begin DHFTI2 -->
!! Reference for `dhfti2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      double precision a(mda,n),(b(mdb,nb) or b(m))
!!      double precision d(l) where l = min(m,n)
!!      double precision tau,rnorm(nb),h(n),g(n)
!!      integer ip(n)
!!      written by C.L. Lawson and R.J. Hanson. Modified by A.H. Morris.
!!      From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!!      For algorithmic details see algorithm hfti in chapter 14.
!!      Abstract
!!      this subroutine solves a linear least squares problem or a set of
!!      linear least squares problems having the same matrix but different
!!      right-side vectors.  The problem data consists of an m by n matrix
!!      A, an m by nb matrix b, and an absolute tolerance parameter tau
!!      whose usage is described below.  The nb column vectors of b
!!      represent right-side vectors for nb distinct linear least squares
!!      problems.
!!      This set of problems can also be written as the matrix least
!!      squares problem
!!                        ax = b,
!!      where X is the n by nb solution matrix.
!!      Note that if b is the m by m identity matrix, then X will be the
!!      pseudo-inverse of A.
!!      This subroutine first transforms the augmented matrix (A b) to A
!!      matrix (R C) using premultiplying Householder transformations with
!!      column interchanges.  All subdiagonal elements in the matrix R are
!!      zero and its diagonal elements satisfy
!!                        dabs(R(i,i)).GE.dabs(R(i+1,i+1)),
!!                        i = 1,...,l-1, where
!!                        l = min(m,n).
!!      The array d will contain the diagonal elements R(1,1),...,R(l,l).
!!      The subroutine sets k to be the number of diagonal elements that
!!      exceed tau in magnitude.  Then the solution of minimum Euclidean
!!      length is computed using the first k rows of (R C).
!!      To be specific we suggest that the user consider an easily
!!      computable matrix NORM, such as, the maximum of all column sums of
!!      magnitudes.
!!      Now if the relative uncertainty of b is eps, (norm of uncertainty/
!!      norm of b), it is suggested that tau be set approximately equal to
!!      eps*(norm of A).
!!      The entire set of parameters for dhfti2 are
!!      input..
!!      a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!!                        matrix a of the least squares problem AX = b.
!!                        The first dimensioning parameter of the array
!!                        a(*,*) is mda, which must satisfy mda.GE.m
!!                        either m.GE.n or m.LT.n is permitted.  There
!!                        is no restriction on the rank of A.  the
!!                        condition mda.LT.m is considered an error.
!!      b(*),mdb,nb       if nb = 0 The subroutine will perform the
!!                        orthogonal decomposition but will make no
!!                        references to the array b(*).  If nb.GT.0
!!                        the array b(*) must initially contain the m by
!!                        nb matrix b of the least squares problem AX =
!!                        b.  if nb.GE.2 the array b(*) must be doubly
!!                        subscripted with first dimensioning parameter
!!                        mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!!                        be either doubly or singly subscripted.  In
!!                        the latter case the value of mdb is arbitrary
!!                        but it should be set to some valid integer
!!                        value such as mdb = m.
!!                        The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!!                        is considered an error.
!!      tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!!                        for pseudorank determination.
!!      h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY dhfti2.
!!      Output..
!!      a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!!                        modified by the subroutine.  These contents
!!                        are not generally required by the user.
!!      b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!!                        nb solution matrix X.
!!      d(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!!                        triangular matrix R
!!      k                 SET BY THE SUBROUTINE TO INDICATE THE
!!                        pseudorank of A.
!!      rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!!                        norm of the residual vector for the problem
!!                        defined by the j-TH column vector of the array
!!                        b(*,*) FOR j = 1,...,nb.
!!      h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!!                        elements of the pre- and post-multiplying
!!                        Householder transformations used to compute
!!                        the minimum Euclidean length solution.
!!      ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!!                        describing the permutation of column vectors.
!!                        The contents of arrays h(*),g(*) and ip(*)
!!                        are not generally required by the user.
!!      ierr              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!!                        detected then ierr is set to 0. Otherwise
!!                           ierr = 1  IF mda.LT.m
!!                           ierr = 2  If nb.GT.1 and mdb.LT.max(m,n)
!!                        these errors are fatal.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
double precision, intent(inout) :: a(mda,n), b(mdb,*), d(*)
double precision, intent(in) :: tau
double precision, intent(inout) :: rnorm(*), h(n), g(n)
integer, intent(inout) :: ip(n)
!     beginning of local variable declarations
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
double precision :: hmax, sm, sm1, tmp, z
double precision, parameter :: factor = 1.d-3
interface
   pure subroutine dh12(mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv &
      & )
      implicit none
      integer, intent(in) :: iue
      integer, intent(in) :: m
      integer, intent(in) :: mode
      integer, intent(in) :: lpivot
      integer, intent(in) :: l1
      double precision, intent(inout) :: u(iue,m)
      double precision, intent(inout) :: up
      double precision, intent(inout) :: c(*)
      integer, intent(in) :: ice
      integer, intent(in) :: icv
      integer, intent(in) :: ncv
   end subroutine dh12
end interface
!-----------------------------------------------------------------------
!     double precision a(mda,n),(b(mdb,nb) or b(m))
!     double precision d(l) where l = min(m,n)
!     double precision tau,rnorm(nb),h(n),g(n)
!     integer ip(n)
!     written by C.L. Lawson and R.J. Hanson. Modified by A.H. Morris.
!     From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!     Abstract
!     this subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!     This set of problems can also be written as the matrix least
!     squares problem
!                       ax = b,
!     where X is the n by nb solution matrix.
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!                       dabs(R(i,i)).GE.dabs(R(i+1,i+1)),
!                       i = 1,...,l-1, where
!                       l = min(m,n).
!     The array d will contain the diagonal elements R(1,1),...,R(l,l).
!     The subroutine sets k to be the number of diagonal elements that
!     exceed tau in magnitude.  Then the solution of minimum Euclidean
!     length is computed using the first k rows of (R C).
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!     The entire set of parameters for dhfti2 are
!     input..
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       matrix a of the least squares problem AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) is mda, which must satisfy mda.GE.m
!                       either m.GE.n or m.LT.n is permitted.  There
!                       is no restriction on the rank of A.  the
!                       condition mda.LT.m is considered an error.
!     b(*),mdb,nb       if nb = 0 The subroutine will perform the
!                       orthogonal decomposition but will make no
!                       references to the array b(*).  If nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb matrix b of the least squares problem AX =
!                       b.  if nb.GE.2 the array b(*) must be doubly
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  If nb = 1 The array b(*) may
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       value such as mdb = m.
!                       The condition of nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY dhfti2.
!     Output..
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!     d(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!                       triangular matrix R
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!     rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!     ierr              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!                       detected then ierr is set to 0. Otherwise
!                          ierr = 1  IF mda.LT.m
!                          ierr = 2  If nb.GT.1 and mdb.LT.max(m,n)
!                       these errors are fatal.
!-----------------------------------------------------------------------
!---------------------
k = 0
ldiag = min(m,n)
if (ldiag <= 0) go to 270
if (m > mda) go to 300
if (nb > 1 .and. max(m,n) > mdb) go to 310
do j = 1,ldiag
   if (j == 1) go to 20
!     Update squared column lengths and find lmax
!    ..
   lmax = j
   do l = j,n
      h(l) = h(l) - a(j - 1,l)**2
      if (h(l) > h(lmax)) lmax = l
   end do
   z = hmax + factor*h(lmax)
   if (z > hmax) go to 50
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
   do l = j,n
      h(l) = 0.d0
      do i = j,m
         h(l) = h(l) + a(i,l)**2
      end do
      if (h(l) > h(lmax)) lmax = l
   end do
   hmax = h(lmax)
!    ..
!     lmax has been determined
!     do column interchanges if needed.
!    ..
50 ip(j) = lmax
   if (ip(j) == j) go to 70
   do i = 1,m
      tmp = a(i,j)
      a(i,j) = a(i,lmax)
      a(i,lmax) = tmp
   end do
   h(lmax) = h(j)
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call dh12(1,j,j + 1,m,a(1,j),1,h(j),a(1,j + 1),1,mda,n - j)
   call dh12(2,j,j + 1,m,a(1,j),1,h(j),b,1,mdb,nb)
end do
!     Determine the pseudorank, k, using the tolerance, tau.
!     Also store the diagonal elements in the array d.
!    ..
do j = 1,ldiag
   if (abs(a(j,j)) <= tau) go to 100
   d(j) = a(j,j)
end do
k = ldiag
kp1 = k + 1
go to 110
100 k = j - 1
kp1 = j
do j = kp1,ldiag
   d(j) = a(j,j)
end do
!     Compute the norms of the residual vectors.
110 if (nb <= 0) go to 140
do jb = 1,nb
   tmp = 0.d0
   if (kp1 > m) go to 130
   do i = kp1,m
      tmp = tmp + b(i,jb)**2
   end do
130 rnorm(jb) = sqrt(tmp)
end do
140 continue
!                                           Special for pseudorank = 0
if (k > 0) go to 160
if (nb <= 0) go to 270
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.d0
   end do
end do
go to 270
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k == n) go to 180
do ii = 1,k
   i = kp1 - ii
   call dh12(1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i - 1)
end do
180 continue
if (nb <= 0) go to 270
do jb = 1,nb
!     Solve the k by k triangular system.
!    ..
   do l = 1,k
      sm = 0.d0
      i = kp1 - l
      if (i == k) go to 200
      ip1 = i + 1
      do j = ip1,k
         sm = sm + a(i,j)*b(j,jb)
      end do
200   sm1 = b(i,jb) - sm
      b(i,jb) = sm1/a(i,i)
   end do
!     Complete computation of solution vector.
!    ..
   if (k == n) go to 240
   do j = kp1,n
      b(j,jb) = 0.d0
   end do
   do i = 1,k
      call dh12(2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
   end do
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do jj = 1,ldiag
      j = ldiag + 1 - jj
      if (ip(j) == j) go to 250
      l = ip(j)
      tmp = b(l,jb)
      b(l,jb) = b(j,jb)
      b(j,jb) = tmp
250   continue
   end do
end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
270 ierr = 0
return
!     Error return
300 ierr = 1
return
310 ierr = 2
end subroutine dhfti2

pure subroutine dh12(mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv)
!! <!-- nswc-ford:begin DH12 -->
!! Reference for `dh12`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!!      From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!!      Construction and/or application of a single
!!      Householder transformation..     Q = i + u*(u**T)/b
!!      mode    = 1 Or 2   to select algorithm  H1  or  H2 .
!!      lpivot is the index of the pivot element.
!!      l1,m   if l1 .LE. m   the transformation will be constructed to
!!             ZERO ELEMENTS INDEXED FROM l1 THROUGH m.   IF l1 GT. m
!!             the subroutine does an identity transformation.
!!      u(),iue,UP    ON ENTRY TO H1 u() CONTAINS THE PIVOT VECTOR.
!!                    iue is the storage increment between elements.
!!                                        On exit from H1 u() and up
!!                    contain quantities defining the vector u of the
!!                    HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 u()
!!                    and up should contain quantities previously computed
!!                    by H1.  These will not be modified by H2.
!!      c()    ON ENTRY TO H1 OR H2 c() CONTAINS A MATRIX WHICH WILL BE
!!             regarded as a set of vectors to which the Householder
!!             transformation is to be applied.  On exit c() contains the
!!             set of transformed vectors.
!!      ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN c().
!!      icv    STORAGE INCREMENT BETWEEN VECTORS IN c().
!!      ncv    number of vectors in c() to be transformed. If ncv .LE. 0
!!             no operations will be done on c().
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ice, icv, iue, l1, lpivot, m, mode, ncv
double precision, intent(inout) :: u(iue,m), up, c(*)
!     beginning of local variable declarations
integer :: i, i2, i3, i4, incr, j
double precision :: b, cl, d, sm
!-----------------------------------------------------------------------
!     Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!     From the book Solving Least Squares Problems, Prentice-Hall, 1974.
!     Construction and/or application of a single
!     Householder transformation..     Q = i + u*(u**T)/b
!     mode    = 1 Or 2   to select algorithm  H1  or  H2 .
!     lpivot is the index of the pivot element.
!     l1,m   if l1 .LE. m   the transformation will be constructed to
!            ZERO ELEMENTS INDEXED FROM l1 THROUGH m.   IF l1 GT. m
!            the subroutine does an identity transformation.
!     u(),iue,UP    ON ENTRY TO H1 u() CONTAINS THE PIVOT VECTOR.
!                   iue is the storage increment between elements.
!                                       On exit from H1 u() and up
!                   contain quantities defining the vector u of the
!                   HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 u()
!                   and up should contain quantities previously computed
!                   by H1.  These will not be modified by H2.
!     c()    ON ENTRY TO H1 OR H2 c() CONTAINS A MATRIX WHICH WILL BE
!            regarded as a set of vectors to which the Householder
!            transformation is to be applied.  On exit c() contains the
!            set of transformed vectors.
!     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN c().
!     icv    STORAGE INCREMENT BETWEEN VECTORS IN c().
!     ncv    number of vectors in c() to be transformed. If ncv .LE. 0
!            no operations will be done on c().
!-----------------------------------------------------------------------
if (0 >= lpivot .or. lpivot >= l1 .or. l1 > m) return
cl = abs(u(1,lpivot))
if (mode == 2) go to 60
!                            ****** Construct the transformation. ******
do j = l1,m
   cl = max(abs(u(1,j)),cl)
end do
if (cl <= 0.d0) go to 130
d = u(1,lpivot)/cl
sm = d*d
do j = l1,m
   d = u(1,j)/cl
   sm = sm + d*d
end do
cl = cl*sqrt(sm)
if (u(1,lpivot) > 0.d0) cl = -cl
up = u(1,lpivot) - cl
u(1,lpivot) = cl
go to 70
!            ****** Apply the transformation  i+u*(u**T)/b  to c. ******
60 if ((cl) <= 0) go to 130
go to 70
70 if (ncv <= 0) return
b = up*u(1,lpivot)
!                       b  must be nonpositive here.  If b = 0., Return.
if (b >= 0.d0) go to 130
b = 1.d0/b
i2 = 1 - icv + ice*(lpivot - 1)
incr = ice*(l1 - lpivot)
do j = 1,ncv
   i2 = i2 + icv
   i3 = i2 + incr
   i4 = i3
   sm = c(i2)*up
   do i = l1,m
      sm = sm + c(i3)*u(1,i)
      i3 = i3 + ice
   end do
   if (sm == 0.d0) go to 120
   sm = sm*b
   c(i2) = c(i2) + sm*up
   do i = l1,m
      c(i4) = c(i4) + sm*u(1,i)
      i4 = i4 + ice
   end do
120 continue
end do
130 return
end subroutine dh12

subroutine lsei(w, mdw, me, ma, mg, n, prgopt, x, rnorme, rnorml, &
   & mode, ws, ip)
!! <!-- nswc-ford:begin LSEI -->
!! Reference for `lsei`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      dimension w(mdw,n+1),prgopt(*),x(n),
!!      ws(2*(me+n)+k+(mg+2)*(n+7)),ip(mg+2*n+2)
!!      ABOVE, k=max(ma+mg,n).
!!      Written by R. J. Hanson and K. H. Haskell.  For further math.
!!      And algorithmic details see Sandia Laboratories tech. REPTS.
!!      SAND77-0552, (1978), and SAND78-1290, (1979), and math.
!!      Programming (21), 1981, PP. 98-118. modified by A.H. Morris.
!!      Abstract
!!      this subprogram solves a linearly constrained least squares
!!      problem with both equality and inequality constraints, and, if the
!!      user requests, obtains a covariance matrix of the solution
!!      parameters.
!!      Suppose there are given matrices E, A and G of respective
!!      dimensions me by n, ma by n and mg by n, and vectors F, B and H of
!!      respective lengths me, ma and mg.  This subroutine solves the
!!      linearly constrained least squares problem
!!                    EX = F, (E me by n) (equations to be exactly
!!                                        satisfied)
!!                    AX = B, (A ma by n) (equations to be
!!                                        approximately satisfied,
!!                                        least squares sense)
!!                    GX.GE.H,(G mg by n) (inequality constraints)
!!      the inequalities GX.GE.H mean that every component of the product
!!      GX must be .GE. the corresponding component of H.
!!      In case the equality constraints cannot be satisfied, A
!!      generalized inverse solution residual vector LENGTH is obtained
!!      for F-EX. This is the minimal length possible for F-EX.
!!      Any values me.GE.0, ma.GE.0, or mg.GE.0 are permitted.  The
!!      rank of the matrix E is estimated during the computation. We call
!!      this value kranke. It is an output parameter in ip(1) defined
!!      below. Using a generalized inverse solution of EX=F, a reduced
!!      least squares problem with inequality constraints is obtained.
!!      The tolerances used in these tests for determining the rank
!!      of E and the rank of the reduced least squares problem are
!!      given in sandia tech. Rept. SAND78-1290. They can be
!!      modified by the user if new values are provided in
!!      the option list of the array prgopt(*).
!!      The user must dimension all arrays appearing in the call list..
!!      w(mdw,n+1),prgopt(*),x(n),ws(2*(me+n)+k+(mg+2)*(n+7)),ip(mg+2*n+2)
!!      where k=max(ma+mg,n).  This allows for a solution of a range of
!!      problems in the given working space.  The dimension of ws(*)
!!      given is a necessary overestimate.  Once a particular problem
!!      has been run, the output parameter ip(3) gives the actual
!!      dimension required for that problem.
!!      The parameters for lsei( ) are
!!      input..
!!      w(*,*),mdw,   THE ARRAY w(*,*) IS DOUBLY SUBSCRIPTED WITH
!!      ME,ma,mg,n    FIRST DIMENSIONING PARAMETER EQUAL TO mdw.
!!                    For this discussion let us call M = me+ma+mg.  Then
!!                    mdw must satisfy mdw.GE.M.  the condition
!!                    mdw.LT.M is an error.
!!                    The array w(*,*) contains the matrices and vectors
!!                                   (E  F)
!!                                   (A  B)
!!                                   (G  H)
!!                    in rows and columns 1,...,M and 1,...,n+1
!!                    respectively.
!!                    The integers me, ma, and mg are the
!!                    respective matrix ROW dimensions
!!                    of E, A and G. each matrix HAS n columns.
!!      prgopt(*)    THIS REAL-VALUED ARRAY IS THE OPTION VECTOR.
!!                   If the user is satisfied with the nominal
!!                   subprogram features set
!!                   prgopt(1)=1 (OR prgopt(1)=1.0)
!!                   otherwise prgopt(*) is a linked list consisting of
!!                   groups of data of the following form
!!                   link
!!                   key
!!                   data set
!!                   the parameters link and key are each one word.
!!                   The data set can be comprised of several words.
!!                   The number of items depends on the value of key.
!!                   The value of link points to the first
!!                   entry of the next group of data within
!!                   prgopt(*).  The exception is when there are
!!                   no more options to change.  In that
!!                   case link=1 And the values key and data set
!!                   are not referenced. The general layout of
!!                   prgopt(*) is as follows.
!!                ...prgopt(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!!                .  prgopt(2)=KEY1 (KEY TO THE OPTION CHANGE)
!!                .  prgopt(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!!
!!                ...prgopt(LINK1)=LINK2 (link to the first entry of
!!                .                       NEXT GROUP)
!!                .  prgopt(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!!                .  prgopt(LINK1+2)=Data value
!!
!!                ...prgopt(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!!                   values of link that are nonpositive are errors.
!!                   A value of link.GT.NLINK=100000 Is also an error.
!!                   This helps prevent using invalid but positive
!!                   values of link that will probably extend
!!                   beyond the program limits of prgopt(*).
!!                   Unrecognized values of key are ignored.  The
!!                   order of the options is arbitrary and any number
!!                   of options can be changed with the following
!!                   restriction.  To prevent cycling in the
!!                   processing of the option array A count of the
!!                   number of options changed is maintained.
!!                   Whenever this count exceeds NOPT=1000 The
!!                   routine terminates.
!!                   Options..
!!                   key=1
!!                          compute in w(*,*) the n by n
!!                   covariance matrix of the solution variables
!!                   as an output paramter.  Nominally the
!!                   covariance matrix will not be computed.
!!                   (This requires no user input.)
!!                   the data set for this option is a single value.
!!                   It must be nonzero when the covariance matrix
!!                   is desired.  If it is zero, the covariance
!!                   matrix is not computed.  When the covariance matrix
!!                   is computed, the first dimensioning parameter
!!                   of the array w(*,*) must satisfy mdw.GE.MAX0(M,n).
!!                   key=2
!!                          scale the nonzero columns of the
!!                          entire data matrix.
!!                   (E)
!!                   (A)
!!                   (G)
!!                   to have length one.  The data set for this
!!                   option is a single value.  It must be
!!                   nonzero if unit length column scaling
!!                   is desired.
!!                   key=3
!!                          scale columns of the entire data matrix
!!                   (E)
!!                   (A)
!!                   (G)
!!                   with a user-provided diagonal matrix.
!!                   The data set for this option consists
!!                   of the n diagonal scaling factors, one for
!!                   each matrix column.
!!                   key=4
!!                          change the rank determination tolerance for
!!                   the equality constraint equations from
!!                   the nominal value of sqrt(SRELPR).  This quantity
!!                   can be no smaller than SRELPR, the arithmetic-
!!                   storage precision.  The quantity SRELPR is the
!!                   largest positive number such that T=1.+SRELPR
!!                   satisfies T.EQ.1.  the quantity used
!!                   here is internally restricted to be at
!!                   least SRELPR.  The data set for this option
!!                   is the new tolerance.
!!                   key=5
!!                          change the rank determination tolerance for
!!                   the reduced least squares equations from
!!                   the nominal value of sqrt(SRELPR).  This quantity
!!                   can be no smaller than SRELPR, the arithmetic-
!!                   storage precision.  The quantity used
!!                   here is internally restricted to be at
!!                   least SRELPR.  The data set for this option
!!                   is the new tolerance.
!!                   For example, suppose we want to change
!!                   the tolerance for the reduced least squares
!!                   problem, compute the covariance matrix of
!!                   the solution parameters, and provide
!!                   column scaling for the data matrix.  For
!!                   these options the dimension of prgopt(*)
!!                   must be at least n+9.  The Fortran statements
!!                   defining these options would be as follows.
!!                   prgopt(1)=4 (LINK TO ENTRY 4 IN prgopt(*))
!!                   prgopt(2)=1 (COVARIANCE MATRIX key)
!!                   prgopt(3)=1 (COVARIANCE MATRIX WANTED)
!!                   prgopt(4)=7 (LINK TO ENTRY 7 IN prgopt(*))
!!                   prgopt(5)=5 (LEAST SQUARES EQUAS. TOLERANCE KEY)
!!                   prgopt(6)=... (new value of the tolerance)
!!                   prgopt(7)=n+9 (LINK TO ENTRY n+9 IN prgopt(*))
!!                   prgopt(8)=3 (USER-PROVIDED COLUMN SCALING KEY)
!!                   call scopy(n,d,1,prgopt(9),1)  (copy the n
!!                     scaling factors from the user array D(*)
!!                     to prgopt(9)-prgopt(n+8))
!!                   prgopt(n+9)=1 (NO MORE OPTIONS TO CHANGE)
!!                   the contents of prgopt(*) are not modified
!!                   by the subprogram.
!!                   The key 8 and 9 options for wnnls( ) can also
!!                   be included in this array.  Their functions
!!                   are documented in the usage instructions for
!!                   subprogram wnnls( ).
!!      Output..
!!      x(*),rnorme,  the array x(*) contains the solution parameters
!!      rnorml        if the integer output flag mode = 0 Or 1.
!!                    The definition of mode is given directly below.
!!                    When mode = 0 Or 1, rnorme and rnorml
!!                    respectively contain the residual vector
!!                    Euclidean lengths of F - EX and B - AX.  When
!!                    mode=1 The equality constraint equations EX=F
!!                    are contradictory, so rnorme.NE.0. The residual
!!                    vector F-EX has minimal Euclidean length. For
!!                    mode.GE.2, none of these parameters are
!!                    defined.
!!      MODE          INTEGER FLAG THAT INDICATES THE SUBPROGRAM
!!                    status after completion.  If mode.GE.2, no
!!                    solution has been computed.
!!                    mode =
!!                    0  both equality and inequality constraints
!!                       are compatible and have been satisfied.
!!                    1  Equality constraints are contradictory.
!!                       A generalized inverse solution of EX=F was used
!!                       to minimize the residual vector LENGTH F-EX.
!!                       In this sense, the solution is still meaningful.
!!                    2  No solution could be obtained. The constraints
!!                       are contradictory.
!!                    4  Usage error occurred.  The value
!!                       of mdw is .LT. me+ma+mg, mdw is
!!                       .LT. n and a covariance matrix is
!!                       requested, or the option vector
!!                       prgopt(*) is not properly defined.
!!      w(*,*)        THE ARRAY w(*,*) CONTAINS THE n BY n SYMMETRIC
!!                    covariance matrix of the solution parameters,
!!                    provided this was requested on input with
!!                    the option vector prgopt(*) and the output
!!                    flag is returned with mode = 0 Or 1.
!!      ip(*)         THE INTEGER WORKING ARRAY HAS THREE ENTRIES
!!                    that provide rank and working array LENGTH
!!                    information after completion.
!!                       ip(1) = Rank of equality constraint
!!                               matrix.  Define this quantity
!!                               as kranke.
!!                       ip(2) = Rank of reduced least squares
!!                               problem.
!!                       ip(3) = The amount of storage in the
!!                               working array ws(*) that was
!!                               actually used by the subprogram.
!!                               The formula given above for the length
!!                               of ws(*) is a necessary overestimate.
!!      User designated
!!      working arrays..
!!      ws(*),ip(*)              THESE ARE RESPECTIVELY TYPE REAL
!!                               and type integer working arrays.
!!                               Their required minimal lengths are
!!                               given above.
!!      Subroutines called
!!      lsi           PART OF THIS PACKAGE.  SOLVES A
!!                    constrained least squares problem with
!!                    inequality constraints.
!!      sdot,sscal,   SUBROUTINES FROM THE BLAS PACKAGE.
!!      saxpy,sasum,  see trans. Math software (5), P. 308.
!!      scopy,snrm2,
!!      sswap,isamax
!!      h12           SUBROUTINE TO CONSTRUCT AND APPLY A
!!                    Householder transformation.
!!      spmpar        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!!                    precision.
!!      Revised oct. 1, 1989.
!!      Compute machine precision
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ma, mdw, me, mg
integer, intent(out) :: mode
integer :: n
real, intent(inout) :: rnorme, rnorml
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(*), ws(*)
integer, intent(inout) :: ip(*)
!     beginning of local variable declarations
integer :: i, ii, imax, j, jj, jp1, k, key, kk, kranke, l, last, &
   & link, m, mapke1, mdeqc, mend, mep1, n1, n2, next, nlink, nopt, &
   & np1, ntimes
real :: enorm, fnorm, gam, rb, rn, rnmax, size, sn, snmax, srelpr, t, tau, uj, up, vj, xnorm, xnrme
real :: snrm2
real :: sasum
real :: sdot
logical :: cov
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
real, parameter :: half = 0.5e0
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     dimension w(mdw,n+1),prgopt(*),x(n),
!     ws(2*(me+n)+k+(mg+2)*(n+7)),ip(mg+2*n+2)
!     ABOVE, k=max(ma+mg,n).
!     Written by R. J. Hanson and K. H. Haskell.  For further math.
!     And algorithmic details see Sandia Laboratories tech. REPTS.
!     SAND77-0552, (1978), and SAND78-1290, (1979), and math.
!     Programming (21), 1981, PP. 98-118. modified by A.H. Morris.
!     Abstract
!     this subprogram solves a linearly constrained least squares
!     problem with both equality and inequality constraints, and, if the
!     user requests, obtains a covariance matrix of the solution
!     parameters.
!     Suppose there are given matrices E, A and G of respective
!     dimensions me by n, ma by n and mg by n, and vectors F, B and H of
!     respective lengths me, ma and mg.  This subroutine solves the
!     linearly constrained least squares problem
!                   EX = F, (E me by n) (equations to be exactly
!                                       satisfied)
!                   AX = B, (A ma by n) (equations to be
!                                       approximately satisfied,
!                                       least squares sense)
!                   GX.GE.H,(G mg by n) (inequality constraints)
!     the inequalities GX.GE.H mean that every component of the product
!     GX must be .GE. the corresponding component of H.
!     In case the equality constraints cannot be satisfied, A
!     generalized inverse solution residual vector LENGTH is obtained
!     for F-EX. This is the minimal length possible for F-EX.
!     Any values me.GE.0, ma.GE.0, or mg.GE.0 are permitted.  The
!     rank of the matrix E is estimated during the computation. We call
!     this value kranke. It is an output parameter in ip(1) defined
!     below. Using a generalized inverse solution of EX=F, a reduced
!     least squares problem with inequality constraints is obtained.
!     The tolerances used in these tests for determining the rank
!     of E and the rank of the reduced least squares problem are
!     given in sandia tech. Rept. SAND78-1290. They can be
!     modified by the user if new values are provided in
!     the option list of the array prgopt(*).
!     The user must dimension all arrays appearing in the call list..
!     w(mdw,n+1),prgopt(*),x(n),ws(2*(me+n)+k+(mg+2)*(n+7)),ip(mg+2*n+2)
!     where k=max(ma+mg,n).  This allows for a solution of a range of
!     problems in the given working space.  The dimension of ws(*)
!     given is a necessary overestimate.  Once a particular problem
!     has been run, the output parameter ip(3) gives the actual
!     dimension required for that problem.
!     The parameters for lsei( ) are
!     input..
!     w(*,*),mdw,   THE ARRAY w(*,*) IS DOUBLY SUBSCRIPTED WITH
!     ME,ma,mg,n    FIRST DIMENSIONING PARAMETER EQUAL TO mdw.
!                   For this discussion let us call M = me+ma+mg.  Then
!                   mdw must satisfy mdw.GE.M.  the condition
!                   mdw.LT.M is an error.
!                   The array w(*,*) contains the matrices and vectors
!                                  (E  F)
!                                  (A  B)
!                                  (G  H)
!                   in rows and columns 1,...,M and 1,...,n+1
!                   respectively.
!                   The integers me, ma, and mg are the
!                   respective matrix ROW dimensions
!                   of E, A and G. each matrix HAS n columns.
!     prgopt(*)    THIS REAL-VALUED ARRAY IS THE OPTION VECTOR.
!                  If the user is satisfied with the nominal
!                  subprogram features set
!                  prgopt(1)=1 (OR prgopt(1)=1.0)
!                  otherwise prgopt(*) is a linked list consisting of
!                  groups of data of the following form
!                  link
!                  key
!                  data set
!                  the parameters link and key are each one word.
!                  The data set can be comprised of several words.
!                  The number of items depends on the value of key.
!                  The value of link points to the first
!                  entry of the next group of data within
!                  prgopt(*).  The exception is when there are
!                  no more options to change.  In that
!                  case link=1 And the values key and data set
!                  are not referenced. The general layout of
!                  prgopt(*) is as follows.
!               ...prgopt(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!               .  prgopt(2)=KEY1 (KEY TO THE OPTION CHANGE)
!               .  prgopt(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!               .       .
!               .       .
!               .       .
!               ...prgopt(LINK1)=LINK2 (link to the first entry of
!               .                       NEXT GROUP)
!               .  prgopt(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!               .  prgopt(LINK1+2)=Data value
!               ...     .
!               .       .
!               .       .
!               ...prgopt(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!                  values of link that are nonpositive are errors.
!                  A value of link.GT.NLINK=100000 Is also an error.
!                  This helps prevent using invalid but positive
!                  values of link that will probably extend
!                  beyond the program limits of prgopt(*).
!                  Unrecognized values of key are ignored.  The
!                  order of the options is arbitrary and any number
!                  of options can be changed with the following
!                  restriction.  To prevent cycling in the
!                  processing of the option array A count of the
!                  number of options changed is maintained.
!                  Whenever this count exceeds NOPT=1000 The
!                  routine terminates.
!                  Options..
!                  key=1
!                         compute in w(*,*) the n by n
!                  covariance matrix of the solution variables
!                  as an output paramter.  Nominally the
!                  covariance matrix will not be computed.
!                  (This requires no user input.)
!                  the data set for this option is a single value.
!                  It must be nonzero when the covariance matrix
!                  is desired.  If it is zero, the covariance
!                  matrix is not computed.  When the covariance matrix
!                  is computed, the first dimensioning parameter
!                  of the array w(*,*) must satisfy mdw.GE.MAX0(M,n).
!                  key=2
!                         scale the nonzero columns of the
!                         entire data matrix.
!                  (E)
!                  (A)
!                  (G)
!                  to have length one.  The data set for this
!                  option is a single value.  It must be
!                  nonzero if unit length column scaling
!                  is desired.
!                  key=3
!                         scale columns of the entire data matrix
!                  (E)
!                  (A)
!                  (G)
!                  with a user-provided diagonal matrix.
!                  The data set for this option consists
!                  of the n diagonal scaling factors, one for
!                  each matrix column.
!                  key=4
!                         change the rank determination tolerance for
!                  the equality constraint equations from
!                  the nominal value of sqrt(SRELPR).  This quantity
!                  can be no smaller than SRELPR, the arithmetic-
!                  storage precision.  The quantity SRELPR is the
!                  largest positive number such that T=1.+SRELPR
!                  satisfies T.EQ.1.  the quantity used
!                  here is internally restricted to be at
!                  least SRELPR.  The data set for this option
!                  is the new tolerance.
!                  key=5
!                         change the rank determination tolerance for
!                  the reduced least squares equations from
!                  the nominal value of sqrt(SRELPR).  This quantity
!                  can be no smaller than SRELPR, the arithmetic-
!                  storage precision.  The quantity used
!                  here is internally restricted to be at
!                  least SRELPR.  The data set for this option
!                  is the new tolerance.
!                  For example, suppose we want to change
!                  the tolerance for the reduced least squares
!                  problem, compute the covariance matrix of
!                  the solution parameters, and provide
!                  column scaling for the data matrix.  For
!                  these options the dimension of prgopt(*)
!                  must be at least n+9.  The Fortran statements
!                  defining these options would be as follows.
!                  prgopt(1)=4 (LINK TO ENTRY 4 IN prgopt(*))
!                  prgopt(2)=1 (COVARIANCE MATRIX key)
!                  prgopt(3)=1 (COVARIANCE MATRIX WANTED)
!                  prgopt(4)=7 (LINK TO ENTRY 7 IN prgopt(*))
!                  prgopt(5)=5 (LEAST SQUARES EQUAS. TOLERANCE KEY)
!                  prgopt(6)=... (new value of the tolerance)
!                  prgopt(7)=n+9 (LINK TO ENTRY n+9 IN prgopt(*))
!                  prgopt(8)=3 (USER-PROVIDED COLUMN SCALING KEY)
!                  call scopy(n,d,1,prgopt(9),1)  (copy the n
!                    scaling factors from the user array D(*)
!                    to prgopt(9)-prgopt(n+8))
!                  prgopt(n+9)=1 (NO MORE OPTIONS TO CHANGE)
!                  the contents of prgopt(*) are not modified
!                  by the subprogram.
!                  The key 8 and 9 options for wnnls( ) can also
!                  be included in this array.  Their functions
!                  are documented in the usage instructions for
!                  subprogram wnnls( ).
!     Output..
!     x(*),rnorme,  the array x(*) contains the solution parameters
!     rnorml        if the integer output flag mode = 0 Or 1.
!                   The definition of mode is given directly below.
!                   When mode = 0 Or 1, rnorme and rnorml
!                   respectively contain the residual vector
!                   Euclidean lengths of F - EX and B - AX.  When
!                   mode=1 The equality constraint equations EX=F
!                   are contradictory, so rnorme.NE.0. The residual
!                   vector F-EX has minimal Euclidean length. For
!                   mode.GE.2, none of these parameters are
!                   defined.
!     MODE          INTEGER FLAG THAT INDICATES THE SUBPROGRAM
!                   status after completion.  If mode.GE.2, no
!                   solution has been computed.
!                   mode =
!                   0  both equality and inequality constraints
!                      are compatible and have been satisfied.
!                   1  Equality constraints are contradictory.
!                      A generalized inverse solution of EX=F was used
!                      to minimize the residual vector LENGTH F-EX.
!                      In this sense, the solution is still meaningful.
!                   2  No solution could be obtained. The constraints
!                      are contradictory.
!                   4  Usage error occurred.  The value
!                      of mdw is .LT. me+ma+mg, mdw is
!                      .LT. n and a covariance matrix is
!                      requested, or the option vector
!                      prgopt(*) is not properly defined.
!     w(*,*)        THE ARRAY w(*,*) CONTAINS THE n BY n SYMMETRIC
!                   covariance matrix of the solution parameters,
!                   provided this was requested on input with
!                   the option vector prgopt(*) and the output
!                   flag is returned with mode = 0 Or 1.
!     ip(*)         THE INTEGER WORKING ARRAY HAS THREE ENTRIES
!                   that provide rank and working array LENGTH
!                   information after completion.
!                      ip(1) = Rank of equality constraint
!                              matrix.  Define this quantity
!                              as kranke.
!                      ip(2) = Rank of reduced least squares
!                              problem.
!                      ip(3) = The amount of storage in the
!                              working array ws(*) that was
!                              actually used by the subprogram.
!                              The formula given above for the length
!                              of ws(*) is a necessary overestimate.
!     User designated
!     working arrays..
!     ws(*),ip(*)              THESE ARE RESPECTIVELY TYPE REAL
!                              and type integer working arrays.
!                              Their required minimal lengths are
!                              given above.
!     Subroutines called
!     lsi           PART OF THIS PACKAGE.  SOLVES A
!                   constrained least squares problem with
!                   inequality constraints.
!     sdot,sscal,   SUBROUTINES FROM THE BLAS PACKAGE.
!     saxpy,sasum,  see trans. Math software (5), P. 308.
!     scopy,snrm2,
!     sswap,isamax
!     h12           SUBROUTINE TO CONSTRUCT AND APPLY A
!                   Householder transformation.
!     spmpar        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!                   precision.
!     Revised oct. 1, 1989.
!     Compute machine precision
srelpr = spmpar(1)
!     Compute number of possible right multiplying Householder
!     transformations.
m = me + ma + mg
mode = 0
if (n <= 0 .or. me + ma <= 0) return
if (.not.(mdw < m)) go to 80
mode = 4
return
80 np1 = n + 1
kranke = min(me,n)
n1 = 2*kranke + 1
n2 = n1 + n
!     Process-option-vector
go to 480
90 if (.not.(cov .and. mdw < n)) go to 100
mode = 4
return
100 l = kranke
!     Compute norm of equality constraint matrix and RT side.
enorm = zero
do j = 1,n
   enorm = max(enorm,sasum(me,w(1,j),1))
end do
fnorm = sasum(me,w(1,np1),1)
if (.not.(l > 0)) go to 200
snmax = zero
rnmax = zero
do i = 1,l
!     Compute maximum ratio of vector lengths. Partition
!     is at col. i.
   do k = i,me
      sn = sdot(n - i + 1,w(k,i),mdw,w(k,i),mdw)
      rn = sdot(i - 1,w(k,1),mdw,w(k,1),mdw)
      if (.not.(rn == zero .and. sn > snmax)) go to 120
      snmax = sn
      imax = k
      go to 150
120   if (.not.(k == i .or. (sn*rnmax > rn*snmax))) go to 150
      snmax = sn
      rnmax = rn
      imax = k
150   continue
   end do
!     Interchange rows if necessary.
   if (i /= imax) call sswap(np1, w(i,1), mdw, w(imax,1), mdw)
   if (.not.(snmax > tau**2*rnmax)) go to 160
!     Eliminate elems i+1,...,n in row i.
   call h12(1, i, i + 1, n, w(i,1), mdw, ws(i), w(i + 1,1), mdw, 1, &
      & m - i)
   go to 180
160 kranke = i - 1
   exit
180 continue
end do
!     Save diag. Terms of lower trap. Matrix.
200 call scopy(kranke, w, mdw + 1, ws(kranke + 1), 1)
!     Use Householder trans from left to achieve kranke by kranke upper
!     triangular form.
if (.not.(kranke > 0 .and. kranke < me)) go to 220
do kk = 1,kranke
   k = kranke + 1 - kk
!     Apply tranformation to matrix cols. 1,...,k-1.
   call h12(1, k, kranke + 1, me, w(1,k), 1, up, w, 1, mdw, k - 1)
!     Apply to RT side vector.
   call h12(2, k, kranke + 1, me, w(1,k), 1, up, w(1,np1), 1, 1, 1)
end do
220 if (.not.(kranke > 0)) go to 240
!     Solve for variables 1,...,kranke in new coordinates.
call scopy(kranke, w(1,np1), 1, x, 1)
do i = 1,kranke
   x(i) = (x(i) - sdot(i - 1,w(i,1),mdw,x,1))/w(i,i)
end do
!     Compute residuals for reduced problem.
240 mep1 = me + 1
rnorml = zero
if (.not.(me < m)) go to 270
do i = mep1,m
   w(i,np1) = w(i,np1) - sdot(kranke,w(i,1),mdw,x,1)
   sn = sdot(kranke,w(i,1),mdw,w(i,1),mdw)
   rn = sdot(n - kranke,w(i,kranke + 1),mdw,w(i,kranke + 1),mdw)
   if (.not.(rn <= tau**2*sn .and. kranke < n)) go to 260
   w(i,kranke + 1) = zero
   call scopy(n - kranke, w(i,kranke + 1), 0, w(i,kranke + 1), mdw)
260 continue
end do
!     Compute equal. Constraint equas. Residual length.
270 rnorme = snrm2(me - kranke,w(kranke + 1,np1),1)
!     Move reduced problem data upward if kranke.LT.me.
if (.not.(kranke < me)) go to 290
do j = 1,np1
   call scopy(m - me, w(me + 1,j), 1, w(kranke + 1,j), 1)
end do
!     Compute soln of reduced problem.
290 call lsi(w(kranke + 1,kranke + 1), mdw, ma, mg, n - kranke, prgopt, &
   & x(kranke + 1), rnorml, mode, ws(n2), ip(2))
if (mode > 1) go to 470
if (.not.(me > 0)) go to 330
!     Test for consistency of equality constraints.
mdeqc = 0
xnrme = sasum(kranke,w(1,np1),1)
if (rnorme > tau*(enorm*xnrme + fnorm)) mdeqc = 1
mode = mode + mdeqc
!     Check if soln to equal. Constraints satisfies inequal.
!     Constraints when there are no degrees of freedom left.
if (.not.(kranke == n .and. mg > 0)) go to 330
xnorm = sasum(n,x,1)
mapke1 = ma + kranke + 1
mend = ma + kranke + mg
do i = mapke1,mend
   size = sasum(n,w(i,1),mdw)*xnorm + abs(w(i,np1))
   if (.not.(w(i,np1) > tau*size)) go to 310
   mode = 2
   go to 470
310 continue
end do
330 if (.not.(kranke > 0)) go to 420
!     Replace diag. Terms of lower trap. Matrix.
call scopy(kranke, ws(kranke + 1), 1, w, mdw + 1)
!     Reapply trans to put soln in original coordinates.
do ii = 1,kranke
   i = kranke + 1 - ii
   call h12(2, i, i + 1, n, w(i,1), mdw, ws(i), x, 1, 1, 1)
end do
!     Compute cov matrix of equal. Constrained problem.
if (.not.(cov)) go to 450
do jj = 1,kranke
   j = kranke + 1 - jj
   if (.not.(j < n)) go to 400
   rb = ws(j)*w(j,j)
   if (rb /= zero) rb = one/rb
   jp1 = j + 1
   do i = jp1,n
      w(i,j) = sdot(n - j,w(i,jp1),mdw,w(j,jp1),mdw)*rb
   end do
   gam = sdot(n - j,w(jp1,j),1,w(j,jp1),mdw)*rb
   gam = half*gam
   call saxpy(n - j, gam, w(j,jp1), mdw, w(jp1,j), 1)
   do i = jp1,n
      do k = i,n
         w(i,k) = w(i,k) + w(j,i)*w(k,j) + w(i,j)*w(j,k)
         w(k,i) = w(i,k)
      end do
   end do
   uj = ws(j)
   vj = gam*uj
   w(j,j) = uj*vj + uj*vj
   do i = jp1,n
      w(j,i) = uj*w(i,j) + vj*w(j,i)
   end do
   call scopy(n - j, w(j,jp1), mdw, w(jp1,j), 1)
400 continue
end do
!     Apply the scaling to the covariance matrix.
420 if (.not.(cov)) go to 450
do i = 1,n
   l = n1 + i
   call sscal(n, ws(l - 1), w(i,1), mdw)
   call sscal(n, ws(l - 1), w(1,i), 1)
end do
!     Rescale soln. Vector.
450 if (mode > 1) go to 470
do j = 1,n
   l = n1 + j
   x(j) = x(j)*ws(l - 1)
end do
470 ip(1) = kranke
ip(3) = ip(3) + 2*kranke + n
return
480 continue
!     To process-option-vector
!     the nominal tolerance used in the code
!     for the equality constraint equations.
tau = sqrt(srelpr)
!     The nominal column scaling used in the code is
!     the identity scaling.
ws(n1) = one
call scopy(n, ws(n1), 0, ws(n1), 1)
!     No covariance matrix is nominally computed.
cov = .false.
!     Define bound for number of options to change.
nopt = 1000
ntimes = 0
!     Define bound for positive values of link.
nlink = 100000
last = 1
link = prgopt(1)
if (.not.(link <= 0 .or. link > nlink)) go to 490
mode = 4
return
490 if (.not.(link > 1)) go to 540
ntimes = ntimes + 1
if (.not.(ntimes > nopt)) go to 500
mode = 4
return
500 key = prgopt(last + 1)
if (key == 1) cov = prgopt(last + 2) /= zero
if (.not.(key == 2 .and. prgopt(last + 2) /= zero)) go to 520
do j = 1,n
   t = snrm2(m,w(1,j),1)
   if (t /= zero) t = one/t
   l = n1 + j
   ws(l - 1) = t
end do
520 if (key == 3) call scopy(n, prgopt(last + 2), 1, ws(n1), 1)
if (key == 4) tau = max(srelpr,prgopt(last + 2))
next = prgopt(link)
if (.not.(next <= 0 .or. next > nlink)) go to 530
mode = 4
return
530 last = link
link = next
go to 490
540 do j = 1,n
   l = n1 + j
   call sscal(m, ws(l - 1), w(1,j), 1)
end do
go to 90
end subroutine lsei

subroutine lsi(w, mdw, ma, mg, n, prgopt, x, rnorm, mode, ws, ip)
!! <!-- nswc-ford:begin LSI -->
!! Reference for `lsi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This is a companion subprogram to lsei( ).
!!      The documentation for lsei( ) has more complete
!!      usage instructions.
!!      Written by R. J. Hanson, sla.
!!      Solve..
!!               AX = B,  A  ma BY n  (LEAST SQUARES EQUATIONS)
!!      subject to..
!!               GX.GE.H, G  mg BY n  (INEQUALITY CONSTRAINTS)
!!      input..
!!       w(*,*) contains  (A B) in rows 1,...,ma+mg, cols 1,...,n+1.
!!                        (G H)
!!      mdw,ma,mg,n
!!               contain (resp) var. Dimension of w(*,*),
!!               and matrix dimensions.
!!      prgopt(*),
!!               program option vector.
!!      Output..
!!       x(*),rnorm
!!               solution vector(unless mode=2), length of AX-B.
!!       Mode
!!               =0   Inequality constraints are compatible.
!!               =2   Inequality constraints contradictory.
!!       ws(*),
!!               working storage of dimension k+n+(mg+2)*(n+7),
!!               WHERE k=max(ma+mg,n).
!!       ip(mg+2*n+1)
!!               integer working storage
!!      subroutines called
!!      lpdp          THIS SUBPROGRAM MINIMIZES A SUM OF SQUARES
!!                    of unknowns subject to linear inequality
!!                    constraints.  Part of this package.
!!      sdot,sscal    SUBROUTINES FROM THE BLAS PACKAGE.
!!      saxpy,sasum,  see trans. Math software (5), P. 308.
!!      scopy,sswap
!!      hfti          SOLVES AN UNCONSTRAINED LINEAR LEAST SQUARES
!!                    problem.
!!      h12           SUBROUTINE TO CONSTRUCT AND APPLY A HOUSEHOLDER
!!                    transformation.
!!      spmpar        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!!                    precision.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ma, mdw, mg
integer, intent(out) :: mode
integer :: n
real, intent(out) :: rnorm
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(*), ws(*)
integer, intent(inout) :: ip(*)
!     beginning of local variable declarations
integer :: i, ii, il, im1, ip1, j, k, key, key8, key9, krank, &
   & krm1, krp1, l, last, link, m, map1, mdlpdp, minman, n1, n2, n3, &
   & next, np1
real :: anorm, blowup, eps, fac, gam, rb, srelpr, tau, tol, xnorm
real :: sasum
real :: sdot
real :: rnrm(1), opt(7)
logical :: cov
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
real, parameter :: half = 0.5e0
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     This is a companion subprogram to lsei( ).
!     The documentation for lsei( ) has more complete
!     usage instructions.
!     Written by R. J. Hanson, sla.
!     Solve..
!              AX = B,  A  ma BY n  (LEAST SQUARES EQUATIONS)
!     subject to..
!              GX.GE.H, G  mg BY n  (INEQUALITY CONSTRAINTS)
!     input..
!      w(*,*) contains  (A B) in rows 1,...,ma+mg, cols 1,...,n+1.
!                       (G H)
!     mdw,ma,mg,n
!              contain (resp) var. Dimension of w(*,*),
!              and matrix dimensions.
!     prgopt(*),
!              program option vector.
!     Output..
!      x(*),rnorm
!              solution vector(unless mode=2), length of AX-B.
!      Mode
!              =0   Inequality constraints are compatible.
!              =2   Inequality constraints contradictory.
!      ws(*),
!              working storage of dimension k+n+(mg+2)*(n+7),
!              WHERE k=max(ma+mg,n).
!      ip(mg+2*n+1)
!              integer working storage
!     subroutines called
!     lpdp          THIS SUBPROGRAM MINIMIZES A SUM OF SQUARES
!                   of unknowns subject to linear inequality
!                   constraints.  Part of this package.
!     sdot,sscal    SUBROUTINES FROM THE BLAS PACKAGE.
!     saxpy,sasum,  see trans. Math software (5), P. 308.
!     scopy,sswap
!     hfti          SOLVES AN UNCONSTRAINED LINEAR LEAST SQUARES
!                   problem.
!     h12           SUBROUTINE TO CONSTRUCT AND APPLY A HOUSEHOLDER
!                   transformation.
!     spmpar        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!                   precision.
srelpr = spmpar(1)
mode = 0
rnorm = zero
m = ma + mg
np1 = n + 1
krank = 0
if (n <= 0 .or. m <= 0) go to 70
!     Process-option-vector
go to 500
!     Compute matrix NORM of least squares equas.
40 anorm = zero
do j = 1,n
   anorm = max(anorm,sasum(ma,w(1,j),1))
end do
!     Set TOL for hfti( ) rank test.
tau = tol*anorm
!     Compute Householder orthogonal decomp of matrix.
if (n > 0) ws(1) = zero
call scopy(n, ws, 0, ws, 1)
call scopy(ma, w(1,np1), 1, ws, 1)
k = max(m,n)
minman = min(ma,n)
n1 = k + 1
n2 = n1 + n
call hfti(w, mdw, ma, n, ws, 1, 1, tau, krank, rnrm, ws(n2), &
   & ws(n1), ip)
rnorm = rnrm(1)
fac = one
gam = ma - krank
if (krank < ma) fac = rnorm**2/gam
go to 80
!     Reduce-to-lpdp-and-solve
70 ip(1) = krank
ip(2) = n + max(m,n) + (mg + 2)*(n + 7)
return
!     To reduce-to-lpdp-and-solve
80 map1 = ma + 1
!     Compute ineq. RT-hand side for lpdp.
if (.not.(ma < m)) go to 260
if (.not.(minman > 0)) go to 160
do i = map1,m
   w(i,np1) = w(i,np1) - sdot(n,w(i,1),mdw,ws,1)
end do
do i = 1,minman
   j = ip(i)
!     Apply permutations to cols of ineq. Constraint matrix.
   call sswap(mg, w(map1,i), 1, w(map1,j), 1)
end do
!     Apply Householder transformations to constraint matrix.
if (.not.(0 < krank .and. krank < n)) go to 120
do ii = 1,krank
   i = krank + 1 - ii
   l = n1 + i
   call h12(2, i, krank + 1, n, w(i,1), mdw, ws(l - 1), w(map1,1), &
      & mdw, 1, mg)
end do
!     Compute permuted ineq. Constr. Matrix times R-inverse.
120 do i = map1,m
   if (.not.(0 < krank)) go to 150
   do j = 1,krank
      w(i,j) = (w(i,j) - sdot(j - 1,w(1,j),1,w(i,1),mdw))/w(j,j)
   end do
150 continue
end do
!     Solve the reduced problem with lpdp algorithm,
!     the least projected distance problem.
160 call lpdp(w(map1,1), mdw, mg, krank, n - krank, opt, x, xnorm, &
   & mdlpdp, ws(n2), ip(n + 1))
if (mdlpdp /= 1) go to 240
if (.not.(krank > 0)) go to 180
!     Compute soln in original coordinates.
do ii = 1,krank
   i = krank + 1 - ii
   x(i) = (x(i) - sdot(ii - 1,w(i,i + 1),mdw,x(i + 1),1))/w(i,i)
end do
!     Apply Householder trans. To soln vector.
180 if (.not.(0 < krank .and. krank < n)) go to 200
do i = 1,krank
   l = n1 + i
   call h12(2, i, krank + 1, n, w(i,1), mdw, ws(l - 1), x, 1, 1, 1)
end do
200 if (.not.(minman > 0)) go to 270
!     Repermute variables to their input order.
do ii = 1,minman
   i = minman + 1 - ii
   j = ip(i)
   call sswap(1, x(i), 1, x(j), 1)
end do
!     Variables are now in orig. Coordinates.
!     Add soln of unsconstrained prob.
do i = 1,n
   x(i) = x(i) + ws(i)
end do
!     Compute the residual vector NORM.
rnorm = sqrt(rnorm**2 + xnorm**2)
go to 270
240 mode = 2
go to 270
260 call scopy(n, ws, 1, x, 1)
270 if (.not.(cov .and. krank > 0)) go to 70
!     Compute covariance matrix based on the orthogonal decomp.
!     FROM hfti( ).
krm1 = krank - 1
krp1 = krank + 1
!     Copy diag. Terms to working array.
call scopy(krank, w, mdw + 1, ws(n2), 1)
!     Reciprocate diag. Terms.
do j = 1,krank
   w(j,j) = one/w(j,j)
end do
if (.not.(krank > 1)) go to 310
!     Invert the upper triangular QR factor on itself.
do i = 1,krm1
   ip1 = i + 1
   do j = ip1,krank
      w(i,j) = -sdot(j - i,w(i,i),mdw,w(i,j),1)*w(j,j)
   end do
end do
!     Compute the inverted factor times its transpose.
310 do i = 1,krank
   do j = i,krank
      w(i,j) = sdot(krank + 1 - j,w(i,j),mdw,w(j,j),mdw)
   end do
end do
if (.not.(krank < n)) go to 450
!     Zero out lower trapezoidal part.
!     Copy upper TRI. To lower TRI. Part.
do j = 1,krank
   call scopy(j, w(1,j), 1, w(j,1), mdw)
end do
do i = krp1,n
   w(i,1) = zero
   call scopy(i, w(i,1), 0, w(i,1), mdw)
end do
!     Apply right side transformations to lower TRI.
n3 = n2 + krp1
do i = 1,krank
   l = n1 + i
   k = n2 + i
   rb = ws(l - 1)*ws(k - 1)
   if (.not.(rb < zero)) go to 420
!     If rb.GE.zero, transformation can be regarded as zero.
   rb = one/rb
!     Store unscaled rank-one Householder update in work array.
   ws(n3) = zero
   call scopy(n, ws(n3), 0, ws(n3), 1)
   l = n1 + i
   k = n3 + i
   ws(k - 1) = ws(l - 1)
   do j = krp1,n
      k = n3 + j
      ws(k - 1) = w(i,j)
   end do
   do j = 1,n
      l = n3 + i
      k = n3 + j
      ws(j) = sdot(j - i,w(j,i),mdw,ws(l - 1),1) + sdot(n - j + 1,w(j,j),1, &
         & ws(k - 1),1)
      ws(j) = ws(j)*rb
   end do
   l = n3 + i
   gam = sdot(n - i + 1,ws(l - 1),1,ws(i),1)*rb
   gam = gam*half
   call saxpy(n - i + 1, gam, ws(l - 1), 1, ws(i), 1)
   do j = i,n
      if (.not.(i > 1)) go to 390
      im1 = i - 1
      k = n3 + j
      do l = 1,im1
         w(j,l) = w(j,l) + ws(k - 1)*ws(l)
      end do
390   k = n3 + j
      do l = i,j
         il = n3 + l
         w(j,l) = w(j,l) + ws(j)*ws(il - 1) + ws(l)*ws(k - 1)
      end do
   end do
420 continue
end do
!     Copy lower TRI. To upper TRI. To symmetrize the covariance matrix.
do i = 1,n
   call scopy(i, w(i,1), mdw, w(1,i), 1)
end do
!     Repermute rows and cols.
450 do ii = 1,minman
   i = minman + 1 - ii
   k = ip(i)
   if (.not.(i /= k)) go to 470
   call sswap(1, w(i,i), 1, w(k,k), 1)
   call sswap(i - 1, w(1,i), 1, w(1,k), 1)
   call sswap(k - i - 1, w(i,i + 1), mdw, w(i + 1,k), 1)
   call sswap(n - k, w(i,k + 1), mdw, w(k,k + 1), mdw)
470 continue
end do
!     Put in normalized residual sum of squares scale factor
!     and symmetrize the resulting covariance marix.
do j = 1,n
   call sscal(j, fac, w(1,j), 1)
   call scopy(j, w(1,j), 1, w(j,1), mdw)
end do
go to 70
!     To process-option-vector
!     the nominal tolerance used in the code,
500 tol = sqrt(srelpr)
cov = .false.
last = 1
link = prgopt(1)
key8 = 0
key9 = 0
510 if (.not.(link > 1)) go to 540
key = prgopt(last + 1)
if (key == 1) cov = prgopt(last + 2) /= zero
if (key == 5) tol = max(srelpr,prgopt(last + 2))
if (key /= 8) go to 520
key8 = 1
eps = prgopt(last + 2)
go to 530
520 if (key /= 9) go to 530
key9 = 1
blowup = prgopt(last + 2)
530 next = prgopt(link)
last = link
link = next
go to 510
!     Prepare the option vector for wnnls
540 j = 1
if (key8 == 0) go to 550
opt(1) = 4.0
opt(2) = 8.0
opt(3) = eps
j = 4
550 if (key9 == 0) go to 560
opt(j) = j + 3
opt(j + 1) = 9.0
opt(j + 2) = blowup
j = j + 3
560 opt(j) = 1.0
go to 40
end subroutine lsi

subroutine lpdp(a, mda, m, n1, n2, prgopt, x, wnorm, mode, ws, is)
!! <!-- nswc-ford:begin LPDP -->
!! Reference for `lpdp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      dimension a(mda,n+1),prgopt(*),x(n),ws((m+2)*(n+7)),is(m+n+1),
!!      where n=n1+n2.  This is a slight overestimate for ws(*).
!!      Written by R. J. Hanson and K. H. Haskell, sandia labs
!!      determine an n1-vector W, and
!!                an n2-vector Z
!!      which minimizes the Euclidean length of W
!!      subject to G*W+H*Z .GE. Y.
!!      This is the least projected distance problem, lpdp.
!!      The matrices G and H are of respective
!!      dimensions m by n1 and m by n2.
!!      Called by subprogram lsi( ).
!!      The matrix
!!                 (G H Y)
!!      occupies rows 1,...,m and cols 1,...,n1+n2+1 of a(*,*).
!!      The solution (W) is returned in x(*).
!!                   (Z)
!!      the value of mode indicates the status of
!!      the computation after returning to the user.
!!           mode=1  The solution was successfully obtained.
!!           mode=2  The inequalities are inconsistent.
!!      Subroutines called
!!      wnnls         SOLVES A NONNEGATIVELY CONSTRAINED LINEAR LEAST
!!                    squares problem with linear equality constraints.
!!                    Part of this package.
!!      sdot,scopy    SUBROUTINES FROM THE BLAS PACKAGE.
!!      sscal,snrm2   SEE TRANS. MATH SOFTWARE (5), P. 308.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: is(*)
integer, intent(in) :: m, mda
integer, intent(out) :: mode
integer, intent(in) :: n1, n2
real, intent(inout) :: a(mda,*)
real :: prgopt(*)
real, intent(inout) :: wnorm, ws(*), x(*)
!     beginning of local variable declarations
integer :: i, iw, ix, j, l, modew, n, np1
real :: rnorm, sc, ynorm
real :: snrm2
real :: sdot
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
real, parameter :: fac = 0.1e0
!     dimension a(mda,n+1),prgopt(*),x(n),ws((m+2)*(n+7)),is(m+n+1),
!     where n=n1+n2.  This is a slight overestimate for ws(*).
!     Written by R. J. Hanson and K. H. Haskell, sandia labs
!     determine an n1-vector W, and
!               an n2-vector Z
!     which minimizes the Euclidean length of W
!     subject to G*W+H*Z .GE. Y.
!     This is the least projected distance problem, lpdp.
!     The matrices G and H are of respective
!     dimensions m by n1 and m by n2.
!     Called by subprogram lsi( ).
!     The matrix
!                (G H Y)
!     occupies rows 1,...,m and cols 1,...,n1+n2+1 of a(*,*).
!     The solution (W) is returned in x(*).
!                  (Z)
!     the value of mode indicates the status of
!     the computation after returning to the user.
!          mode=1  The solution was successfully obtained.
!          mode=2  The inequalities are inconsistent.
!     Subroutines called
!     wnnls         SOLVES A NONNEGATIVELY CONSTRAINED LINEAR LEAST
!                   squares problem with linear equality constraints.
!                   Part of this package.
!     sdot,scopy    SUBROUTINES FROM THE BLAS PACKAGE.
!     sscal,snrm2   SEE TRANS. MATH SOFTWARE (5), P. 308.
n = n1 + n2
mode = 1
if (.not.(m <= 0)) go to 20
if (.not.(n > 0)) go to 10
x(1) = zero
call scopy(n, x, 0, x, 1)
10 wnorm = zero
return
20 np1 = n + 1
!     Scale nonzero rows of inequality matrix to have length one.
do i = 1,m
   sc = snrm2(n,a(i,1),mda)
   if (sc == zero) go to 40
   sc = one/sc
   call sscal(np1, sc, a(i,1), mda)
40 continue
end do
!     Scale RT.-Side vector to have length one (or zero).
ynorm = snrm2(m,a(1,np1),1)
if (ynorm == zero) go to 50
sc = one/ynorm
call sscal(m, sc, a(1,np1), 1)
!     Scale cols of matrix H.
50 j = n1 + 1
60 if (j > n) go to 70
sc = snrm2(m,a(1,j),1)
if (sc /= zero) sc = one/sc
call sscal(m, sc, a(1,j), 1)
x(j) = sc
j = j + 1
go to 60
70 if (.not.(n1 > 0)) go to 130
!     Copy transpose of (H G Y) to work array ws(*).
iw = 0
do i = 1,m
!     Move col of transpose of H into work array.
   call scopy(n2, a(i,n1 + 1), mda, ws(iw + 1), 1)
   iw = iw + n2
!     Move col of transpose of G into work array.
   call scopy(n1, a(i,1), mda, ws(iw + 1), 1)
   iw = iw + n1
!     Move component of vector Y into work array.
   ws(iw + 1) = a(i,np1)
   iw = iw + 1
end do
ws(iw + 1) = zero
call scopy(n, ws(iw + 1), 0, ws(iw + 1), 1)
iw = iw + n
ws(iw + 1) = one
iw = iw + 1
!     SOLVE EU=F SUBJECT TO (TRANSPOSE OF H)U=0, U.GE.0.  THE
!     MATRIX E = TRANSPOSE OF (G Y), AND THE (n+1)-VECTOR
!     F = TRANSPOSE OF (0,...,0,1).
ix = iw + 1
iw = iw + m
call wnnls(ws, np1, n2, np1 - n2, m, 0, prgopt, ws(ix), rnorm, &
   & modew, is, ws(iw + 1))
!     Compute the components of the soln denoted above by W.
sc = one - sdot(m,a(1,np1),1,ws(ix),1)
if (.not.(one + fac*abs(sc) /= one .and. rnorm > zero)) go to 110
sc = one/sc
do j = 1,n1
   x(j) = sc*sdot(m,a(1,j),1,ws(ix),1)
end do
!     Compute the vector Q=Y-GW.  Overwrite Y with this vector.
do i = 1,m
   a(i,np1) = a(i,np1) - sdot(n1,a(i,1),mda,x,1)
end do
go to 130
110 mode = 2
return
130 if (.not.(n2 > 0)) go to 180
!     Copy transpose of (H Q) to work array ws(*).
iw = 0
do i = 1,m
   call scopy(n2, a(i,n1 + 1), mda, ws(iw + 1), 1)
   iw = iw + n2
   ws(iw + 1) = a(i,np1)
   iw = iw + 1
end do
ws(iw + 1) = zero
call scopy(n2, ws(iw + 1), 0, ws(iw + 1), 1)
iw = iw + n2
ws(iw + 1) = one
iw = iw + 1
ix = iw + 1
iw = iw + m
!     Solve RV=S subject to V.GE.0.  The matrix R =(transpose
!     OF (H Q)), WHERE Q=Y-GW.  THE (n2+1)-VECTOR S =(TRANSPOSE
!     of (0,...,0,1)).
call wnnls(ws, n2 + 1, 0, n2 + 1, m, 0, prgopt, ws(ix), rnorm, modew, &
   & is, ws(iw + 1))
!     Compute the components of the soln denoted above by Z.
sc = one - sdot(m,a(1,np1),1,ws(ix),1)
if (.not.(one + fac*abs(sc) /= one .and. rnorm > zero)) go to 160
sc = one/sc
do j = 1,n2
   l = n1 + j
   x(l) = sc*sdot(m,a(1,l),1,ws(ix),1)*x(l)
end do
go to 180
160 mode = 2
return
!     Account for scaling of RT.-Side vector in solution.
180 call sscal(n, ynorm, x, 1)
wnorm = snrm2(n1,x,1)
end subroutine lpdp

subroutine wnnls(w, mdw, me, ma, n, l, prgopt, x, rnorm, mode, &
   & iwork, work)
!! <!-- nswc-ford:begin WNNLS -->
!! Reference for `wnnls`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      dimension w(mdw,n+1),prgopt(*),x(n),iwork(m+n),work(m+5*n)
!!      abstract
!!      this subprogram solves a linearly constrained least squares
!!      problem.  Suppose there are given matrices E and A of
!!      respective dimensions me by n and ma by n, and vectors F
!!      and B of respective lengths me and ma.  This subroutine
!!      solves the problem
!!                EX = F, (equations to be exactly satisfied)
!!                AX = B, (equations to be approximately satisfied,
!!                         in the least squares sense)
!!                subject to components l+1,...,n nonnegative
!!      any values me.GE.0, ma.GE.0 and 0.LE. l .LE.n are permitted.
!!      The problem is reposed as problem wnnls
!!                (WT*E)x = (WT*F)
!!                (   A)    (   B), (LEAST SQUARES)
!!                subject to components l+1,...,n nonnegative.
!!      The subprogram chooses the heavy weight (or penalty parameter) WT.
!!      The parameters for wnnls are
!!      input..
!!      w(*,*),mdw,  the array w(*,*) is double subscripted with first
!!      ME,ma,n,l    DIMENSIONING PARAMETER EQUAL TO mdw.  FOR THIS
!!                   discussion let us call M = me + ma.  Then mdw
!!                   must satisfy mdw.GE.M.  the condition mdw.LT.M
!!                   is an error.
!!                   The array w(*,*) contains the matrices and vectors
!!                        (E  F)
!!                        (A  B)
!!                   in rows and columns 1,...,M and 1,...,n+1
!!                   respectively.  Columns 1,...,l correspond to
!!                   unconstrained variables x(1),...,x(l).  The
!!                   remaining variables are constrained to be
!!                   nonnegative.  The condition l.LT.0 .OR. l.GT.n is
!!                   an error.
!!      prgopt(*)    THIS ARRAY IS THE OPTION VECTOR.
!!                   If the user is satisfied with the nominal
!!                   subprogram features set
!!                   prgopt(1)=1 (OR prgopt(1)=1.0)
!!                   otherwise prgopt(*) is a linked list consisting of
!!                   groups of data of the following form
!!                   link
!!                   key
!!                   data set
!!                   the parameters link and key are each one word.
!!                   The data set can be comprised of several words.
!!                   The number of items depends on the value of key.
!!                   The value of link points to the first
!!                   entry of the next group of data within
!!                   prgopt(*).  The exception is when there are
!!                   no more options to change.  In that
!!                   case link=1 And the values key and data set
!!                   are not referenced. The general layout of
!!                   prgopt(*) is as follows.
!!                ...prgopt(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!!                .  prgopt(2)=KEY1 (KEY TO THE OPTION CHANGE)
!!                .  prgopt(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!!
!!                ...prgopt(LINK1)=LINK2 (link to the first entry of
!!                .                       NEXT GROUP)
!!                .  prgopt(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!!                .  prgopt(LINK1+2)=Data value
!!
!!                ...prgopt(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!!                   values of link that are nonpositive are errors.
!!                   A value of link.GT.NLINK=100000 Is also an error.
!!                   This helps prevent using invalid but positive
!!                   values of link that will probably extend
!!                   beyond the program limits of prgopt(*).
!!                   Unrecognized values of key are ignored.  The
!!                   order of the options is arbitrary and any number
!!                   of options can be changed with the following
!!                   restriction.  To prevent cycling in the
!!                   processing of the option array A count of the
!!                   number of options changed is maintained.
!!                   Whenever this count exceeds NOPT=1000 The
!!                   routine terminates.
!!                   Options..
!!                   key=6
!!                          scale the nonzero columns of the
!!                   entire data matrix
!!                   (E)
!!                   (A)
!!                   to have length one.  The data set for
!!                   this option is a single value.  It must
!!                   be nonzero if unit length column scaling is
!!                   desired.
!!                   key=7
!!                          scale columns of the entire data matrix
!!                   (E)
!!                   (A)
!!                   with a user-provided diagonal matrix.
!!                   The data set for this option consists
!!                   of the n diagonal scaling factors, one for
!!                   each matrix column.
!!                   key=8
!!                          change the rank determination tolerance from
!!                   the nominal value of sqrt(EPS).  This quantity can
!!                   be no smaller than eps, the arithmetic-
!!                   storage precision.  The quantity used
!!                   here is internally restricted to be at
!!                   least eps.  The data set for this option
!!                   is the new tolerance.
!!                   key=9
!!                          change the blow-up parameter from the
!!                   nominal value of sqrt(EPS).  The reciprocal of
!!                   this parameter is used in rejecting solution
!!                   components as too large when a variable is
!!                   first brought into the active set.  Too large
!!                   means that the proposed component times the
!!                   reciprocal of the parameteris not less than
!!                   the ratio of the norms of the right-side
!!                   vector and the data matrix.
!!                   This parameter can be no smaller than eps,
!!                   the arithmetic-storage precision.
!!                   For example, suppose we want to provide
!!                   a diagonal matrix to scale the problem
!!                   matrix and change the tolerance used for
!!                   determining linear dependence of dropped col
!!                   vectors.  For these options the dimensions of
!!                   prgopt(*) must be at least n+6.  The Fortran
!!                   statements defining these options would
!!                   be as follows.
!!                   prgopt(1)=n+3 (LINK TO ENTRY n+3 IN prgopt(*))
!!                   prgopt(2)=7 (USER-PROVIDED SCALING KEY)
!!                   call scopy(n,d,1,prgopt(3),1) (copy the n
!!                   scaling factors from a user array called D(*)
!!                   into prgopt(3)-prgopt(n+2))
!!                   prgopt(n+3)=n+6 (LINK TO ENTRY n+6 OF prgopt(*))
!!                   prgopt(n+4)=8 (LINEAR DEPENDENCE TOLERANCE KEY)
!!                   prgopt(n+5)=... (new value of the tolerance)
!!                   prgopt(n+6)=1 (NO MORE OPTIONS TO CHANGE)
!!      output..
!!      x(*)         AN ARRAY DIMENSIONED AT LEAST n, WHICH WILL
!!                   contain the n components of the solution vector
!!                   on output.
!!      rnorm        THE RESIDUAL NORM OF THE SOLUTION.  THE VALUE OF
!!                   rnorm contains the residual vector LENGTH of the
!!                   equality constraints and least squares equations.
!!      MODE         THE VALUE OF MODE INDICATES THE SUCCESS OR FAILURE
!!                   of the subprogram.
!!                   mode = 0  Subprogram completed successfully.
!!                        = 1  Max. Number of iterations (equal to
!!                             3*(n-l)) exceeded. Nearly all problems
!!                             should complete in fewer than this
!!                             number of iterations. An approximate
!!                             solution and its corresponding residual
!!                             vector LENGTH are in x(*) and rnorm.
!!                        = 2  Usage error occurred.  Either
!!                             mdw .LT. me + ma, l .LT. 0, l .GT. n,
!!                             or the option vector prgopt(*) is
!!                             not properly defined.
!!      User-designated
!!      working arrays..
!!      work(*)      A WORKING ARRAY OF LENGTH AT LEAST
!!                   M + 5*n.
!!      iwork(*)     AN INTEGER-VALUED WORKING ARRAY OF LENGTH AT LEAST
!!                   M+n.
!!      Written by karen H. Haskell, Sandia Laboratories,
!!      and R.J. Hanson, Sandia Laboratories.
!!      Revised oct. 1, 1989.
!!      Subroutines called by wnnls( )
!!      wnlsm         COMPANION SUBROUTINE TO wnnls( ), WHERE
!!                    most of the computation takes place.
!!      References
!!      1. Solving Least Squares Problems, by C.L. Lawson
!!         and R.J. Hanson.  Prentice-Hall, inc. (1974).
!!      2. BASIC linear algebra subprograms for Fortran usage, by
!!         C.L. Lawson, R.J. Hanson, D.R. kincaid, and F.T. krogh.
!!         Toms, V. 5, No. 3, P. 308.  Also available as
!!         sandia technical report no. SAND77-0898.
!!      3. An algorithm for linear least squares with equality
!!         and nonnegativity constraints, by K.H. Haskell and
!!         R.J. Hanson.  Available as sandia technical report no.
!!         SAND77-0552, and math. Programming, vol. 21, (1981), P. 98-118.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: l, ma, mdw, me
integer, intent(out) :: mode
integer, intent(in) :: n
real, intent(inout) :: rnorm
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(n), work(*)
integer, intent(inout) :: iwork(*)
!     beginning of local variable declarations
integer :: l1, l2, l3, l4, l5
!     dimension w(mdw,n+1),prgopt(*),x(n),iwork(m+n),work(m+5*n)
!     abstract
!     this subprogram solves a linearly constrained least squares
!     problem.  Suppose there are given matrices E and A of
!     respective dimensions me by n and ma by n, and vectors F
!     and B of respective lengths me and ma.  This subroutine
!     solves the problem
!               EX = F, (equations to be exactly satisfied)
!               AX = B, (equations to be approximately satisfied,
!                        in the least squares sense)
!               subject to components l+1,...,n nonnegative
!     any values me.GE.0, ma.GE.0 and 0.LE. l .LE.n are permitted.
!     The problem is reposed as problem wnnls
!               (WT*E)x = (WT*F)
!               (   A)    (   B), (LEAST SQUARES)
!               subject to components l+1,...,n nonnegative.
!     The subprogram chooses the heavy weight (or penalty parameter) WT.
!     The parameters for wnnls are
!     input..
!     w(*,*),mdw,  the array w(*,*) is double subscripted with first
!     ME,ma,n,l    DIMENSIONING PARAMETER EQUAL TO mdw.  FOR THIS
!                  discussion let us call M = me + ma.  Then mdw
!                  must satisfy mdw.GE.M.  the condition mdw.LT.M
!                  is an error.
!                  The array w(*,*) contains the matrices and vectors
!                       (E  F)
!                       (A  B)
!                  in rows and columns 1,...,M and 1,...,n+1
!                  respectively.  Columns 1,...,l correspond to
!                  unconstrained variables x(1),...,x(l).  The
!                  remaining variables are constrained to be
!                  nonnegative.  The condition l.LT.0 .OR. l.GT.n is
!                  an error.
!     prgopt(*)    THIS ARRAY IS THE OPTION VECTOR.
!                  If the user is satisfied with the nominal
!                  subprogram features set
!                  prgopt(1)=1 (OR prgopt(1)=1.0)
!                  otherwise prgopt(*) is a linked list consisting of
!                  groups of data of the following form
!                  link
!                  key
!                  data set
!                  the parameters link and key are each one word.
!                  The data set can be comprised of several words.
!                  The number of items depends on the value of key.
!                  The value of link points to the first
!                  entry of the next group of data within
!                  prgopt(*).  The exception is when there are
!                  no more options to change.  In that
!                  case link=1 And the values key and data set
!                  are not referenced. The general layout of
!                  prgopt(*) is as follows.
!               ...prgopt(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!               .  prgopt(2)=KEY1 (KEY TO THE OPTION CHANGE)
!               .  prgopt(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!               .       .
!               .       .
!               .       .
!               ...prgopt(LINK1)=LINK2 (link to the first entry of
!               .                       NEXT GROUP)
!               .  prgopt(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!               .  prgopt(LINK1+2)=Data value
!               ...     .
!               .       .
!               .       .
!               ...prgopt(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!                  values of link that are nonpositive are errors.
!                  A value of link.GT.NLINK=100000 Is also an error.
!                  This helps prevent using invalid but positive
!                  values of link that will probably extend
!                  beyond the program limits of prgopt(*).
!                  Unrecognized values of key are ignored.  The
!                  order of the options is arbitrary and any number
!                  of options can be changed with the following
!                  restriction.  To prevent cycling in the
!                  processing of the option array A count of the
!                  number of options changed is maintained.
!                  Whenever this count exceeds NOPT=1000 The
!                  routine terminates.
!                  Options..
!                  key=6
!                         scale the nonzero columns of the
!                  entire data matrix
!                  (E)
!                  (A)
!                  to have length one.  The data set for
!                  this option is a single value.  It must
!                  be nonzero if unit length column scaling is
!                  desired.
!                  key=7
!                         scale columns of the entire data matrix
!                  (E)
!                  (A)
!                  with a user-provided diagonal matrix.
!                  The data set for this option consists
!                  of the n diagonal scaling factors, one for
!                  each matrix column.
!                  key=8
!                         change the rank determination tolerance from
!                  the nominal value of sqrt(EPS).  This quantity can
!                  be no smaller than eps, the arithmetic-
!                  storage precision.  The quantity used
!                  here is internally restricted to be at
!                  least eps.  The data set for this option
!                  is the new tolerance.
!                  key=9
!                         change the blow-up parameter from the
!                  nominal value of sqrt(EPS).  The reciprocal of
!                  this parameter is used in rejecting solution
!                  components as too large when a variable is
!                  first brought into the active set.  Too large
!                  means that the proposed component times the
!                  reciprocal of the parameteris not less than
!                  the ratio of the norms of the right-side
!                  vector and the data matrix.
!                  This parameter can be no smaller than eps,
!                  the arithmetic-storage precision.
!                  For example, suppose we want to provide
!                  a diagonal matrix to scale the problem
!                  matrix and change the tolerance used for
!                  determining linear dependence of dropped col
!                  vectors.  For these options the dimensions of
!                  prgopt(*) must be at least n+6.  The Fortran
!                  statements defining these options would
!                  be as follows.
!                  prgopt(1)=n+3 (LINK TO ENTRY n+3 IN prgopt(*))
!                  prgopt(2)=7 (USER-PROVIDED SCALING KEY)
!                  call scopy(n,d,1,prgopt(3),1) (copy the n
!                  scaling factors from a user array called D(*)
!                  into prgopt(3)-prgopt(n+2))
!                  prgopt(n+3)=n+6 (LINK TO ENTRY n+6 OF prgopt(*))
!                  prgopt(n+4)=8 (LINEAR DEPENDENCE TOLERANCE KEY)
!                  prgopt(n+5)=... (new value of the tolerance)
!                  prgopt(n+6)=1 (NO MORE OPTIONS TO CHANGE)
!     output..
!     x(*)         AN ARRAY DIMENSIONED AT LEAST n, WHICH WILL
!                  contain the n components of the solution vector
!                  on output.
!     rnorm        THE RESIDUAL NORM OF THE SOLUTION.  THE VALUE OF
!                  rnorm contains the residual vector LENGTH of the
!                  equality constraints and least squares equations.
!     MODE         THE VALUE OF MODE INDICATES THE SUCCESS OR FAILURE
!                  of the subprogram.
!                  mode = 0  Subprogram completed successfully.
!                       = 1  Max. Number of iterations (equal to
!                            3*(n-l)) exceeded. Nearly all problems
!                            should complete in fewer than this
!                            number of iterations. An approximate
!                            solution and its corresponding residual
!                            vector LENGTH are in x(*) and rnorm.
!                       = 2  Usage error occurred.  Either
!                            mdw .LT. me + ma, l .LT. 0, l .GT. n,
!                            or the option vector prgopt(*) is
!                            not properly defined.
!     User-designated
!     working arrays..
!     work(*)      A WORKING ARRAY OF LENGTH AT LEAST
!                  M + 5*n.
!     iwork(*)     AN INTEGER-VALUED WORKING ARRAY OF LENGTH AT LEAST
!                  M+n.
!     Written by karen H. Haskell, Sandia Laboratories,
!     and R.J. Hanson, Sandia Laboratories.
!     Revised oct. 1, 1989.
!     Subroutines called by wnnls( )
!     wnlsm         COMPANION SUBROUTINE TO wnnls( ), WHERE
!                   most of the computation takes place.
!     References
!     1. Solving Least Squares Problems, by C.L. Lawson
!        and R.J. Hanson.  Prentice-Hall, inc. (1974).
!     2. BASIC linear algebra subprograms for Fortran usage, by
!        C.L. Lawson, R.J. Hanson, D.R. kincaid, and F.T. krogh.
!        Toms, V. 5, No. 3, P. 308.  Also available as
!        sandia technical report no. SAND77-0898.
!     3. An algorithm for linear least squares with equality
!        and nonnegativity constraints, by K.H. Haskell and
!        R.J. Hanson.  Available as sandia technical report no.
!        SAND77-0552, and math. Programming, vol. 21, (1981), P. 98-118.
mode = 0
if (ma + me <= 0 .or. n <= 0) return
if (.not.(mdw < me + ma)) go to 10
mode = 2
return
10 if (0 <= l .and. l <= n) go to 20
mode = 2
return
!     The purpose of this subroutine is to break up the arrays
!     work(*) and iwork(*) into separate work arrays
!     required by the main subroutine wnlsm( ).
20 l1 = n + 1
l2 = l1 + n
l3 = l2 + me + ma
l4 = l3 + n
l5 = l4 + n
call wnlsm(w, mdw, me, ma, n, l, prgopt, x, rnorm, mode, iwork, &
   & iwork(l1), work(1), work(l1), work(l2), work(l3), work(l4), &
   & work(l5))
end subroutine wnnls

subroutine wnlsm(w, mdw, mme, ma, n, l, prgopt, x, rnorm, mode, &
   & ipivot, itype, wd, h, scale, z, temp, d)
!! <!-- nswc-ford:begin WNLSM -->
!! Reference for `wnlsm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      This is a companion subprogram to wnnls( ).
!!      The documentation for wnnls( ) has more complete
!!      usage instructions.
!!      Written by karen h. Haskell, Sandia Laboratories,
!!      with the help of R.J. Hanson, Sandia Laboratories.
!!      In addition to the parameters discussed in the prologue to
!!      subroutine wnnls, the following work arrays are used in
!!      subroutine wnlsm  (they are passed through the calling
!!      sequence from wnnls for purposes of variable dimensioning).
!!      Their contents will in general be of no interest to the user.
!!          ipivot(*)
!!             an array of length n.  upon completion it contains the
!!          pivoting information for the cols of w(*,*).
!!          itype(*)
!!             an array of length M which is used to keep track
!!          of the classification of the equations.  itype(i)=0
!!          denotes equation i as an equality constraint.
!!          itype(i)=1 Denotes equation i as a least squares
!!          equation.
!!          wd(*)
!!             an array of length n.  upon completion it contains the
!!          dual solution vector.
!!          h(*)
!!             an array of length n.  upon completion it contains the
!!          pivot scalars of the Householder transformations performed
!!          in the case KRANK.LT.L.
!!          scale(*)
!!             an array of length M which is used by the subroutine
!!          to store the diagonal matrix of weights.
!!          These are used to apply the modified Givens
!!          transformations.
!!          z(*),temp(*)
!!             working arrays of length n.
!!          d(*)
!!             an array of length n that contains the
!!          column scaling for the matrix (E).
!!                                        (A)
!!      Initialize-variables
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: l, ma, mdw, mme
integer, intent(inout) :: mode
integer, intent(in) :: n
real, intent(inout) :: rnorm
real, intent(inout) :: w(mdw,*), x(*), wd(*), h(*), scale(*)
real, intent(inout) :: z(*), temp(*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: d(*)
integer, intent(inout) :: ipivot(*), itype(*)
!     beginning of local variable declarations
integer :: i, igo897, igo938, igo958, imax, isol, itemp, iter, &
   & itmax, iwmax, j, jcon, jj, jm1, jp, key, krank, krp1, l1, last, &
   & link, lp1, m, me, mep1, next, niv, niv1, nlink, nm1, nopt, np1, &
   & nsoln, nsp1, ntimes
real :: alamda, alpha, alsq, amax, blowup, bnorm, eanorm, fac, sm, srelpr, t, tau, wmax, z2, zz
real :: snrm2
real :: sasum
integer :: isamax
real :: dope(4), sparam(5)
integer :: idope(8)
logical :: hitcon, feasbl, done, pos
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
real, parameter :: two = 2.e0
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     This is a companion subprogram to wnnls( ).
!     The documentation for wnnls( ) has more complete
!     usage instructions.
!     Written by karen h. Haskell, Sandia Laboratories,
!     with the help of R.J. Hanson, Sandia Laboratories.
!     In addition to the parameters discussed in the prologue to
!     subroutine wnnls, the following work arrays are used in
!     subroutine wnlsm  (they are passed through the calling
!     sequence from wnnls for purposes of variable dimensioning).
!     Their contents will in general be of no interest to the user.
!         ipivot(*)
!            an array of length n.  upon completion it contains the
!         pivoting information for the cols of w(*,*).
!         itype(*)
!            an array of length M which is used to keep track
!         of the classification of the equations.  itype(i)=0
!         denotes equation i as an equality constraint.
!         itype(i)=1 Denotes equation i as a least squares
!         equation.
!         wd(*)
!            an array of length n.  upon completion it contains the
!         dual solution vector.
!         h(*)
!            an array of length n.  upon completion it contains the
!         pivot scalars of the Householder transformations performed
!         in the case KRANK.LT.L.
!         scale(*)
!            an array of length M which is used by the subroutine
!         to store the diagonal matrix of weights.
!         These are used to apply the modified Givens
!         transformations.
!         z(*),temp(*)
!            working arrays of length n.
!         d(*)
!            an array of length n that contains the
!         column scaling for the matrix (E).
!                                       (A)
!     Initialize-variables
go to 180
!     Perform initial triangularization in the submatrix
!     corresponding to the unconstrained variables using
!     the procedure initially-triangularize.
10 go to 280
!     Perform wnnls algorithm using the following steps.
!     Until(done)
!        compute-search-direction-and-feasible-point
!        when (hitcon) add-constraints
!        ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
!        fin
!     compute-final-solution
20 if (done) go to 80
go to 300
!     Compute-search-direction-and-feasible-point
30 if (.not.(hitcon)) go to 50
go to 370
!     When (hitcon) add-constraints
50 go to 640
!     ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
80 go to 1000
!     Compute-final-solution
100 continue
!     To process-option-vector
fac = 1.e-4
!     The nominal tolerance used in the code,
tau = sqrt(srelpr)
!     The nominal blow-up factor used in the code.
blowup = tau
!     The nominal column scaling used in the code is
!     the identity scaling.
d(1) = one
call scopy(n, d, 0, d, 1)
!     Define bound for number of options to change.
nopt = 1000
!     Define bound for positive value of link.
nlink = 100000
ntimes = 0
last = 1
link = prgopt(1)
if (.not.(link <= 0 .or. link > nlink)) go to 110
mode = 2
return
110 if (.not.(link > 1)) go to 160
ntimes = ntimes + 1
if (.not.(ntimes > nopt)) go to 120
mode = 2
return
120 key = prgopt(last + 1)
if (.not.(key == 6 .and. prgopt(last + 2) /= zero)) go to 140
do j = 1,n
   t = snrm2(m,w(1,j),1)
   if (t /= zero) t = one/t
   d(j) = t
end do
140 if (key == 7) call scopy(n, prgopt(last + 2), 1, d, 1)
if (key == 8) tau = max(srelpr,prgopt(last + 2))
if (key == 9) blowup = max(srelpr,prgopt(last + 2))
next = prgopt(link)
if (.not.(next <= 0 .or. next > nlink)) go to 150
mode = 2
return
150 last = link
link = next
go to 110
160 do j = 1,n
   call sscal(m, d(j), w(1,j), 1)
end do
go to 220
!     To initialize-variables
!     SRELPR is the precision for the machine being used.
180 srelpr = spmpar(1)
m = ma + mme
me = mme
mep1 = me + 1
go to 100
!     Process-option-vector
220 done = .false.
iter = 0
itmax = 3*(n - l)
mode = 0
lp1 = l + 1
nsoln = l
nsp1 = nsoln + 1
np1 = n + 1
nm1 = n - 1
l1 = min(m,l)
!     Compute scale factor to apply to equal. Constraint equas.
do j = 1,n
   wd(j) = sasum(m,w(1,j),1)
end do
imax = isamax(n,wd,1)
eanorm = wd(imax)
bnorm = sasum(m,w(1,np1),1)
alamda = eanorm/(srelpr*fac)
!     Define scaling diag matrix for mod Givens usage and
!     classify equation types.
alsq = alamda**2
do i = 1,m
!     When EQU i is heavily weighted itype(i)=0, else itype(i)=1.
   if (.not.(i <= me)) go to 240
   t = alsq
   itemp = 0
   go to 250
240 t = one
   itemp = 1
250 scale(i) = t
   itype(i) = itemp
end do
!     Set the soln vector x(*) to zero and the col interchange
!     matrix to the identity.
x(1) = zero
call scopy(n, x, 0, x, 1)
do i = 1,n
   ipivot(i) = i
end do
go to 10
280 continue
!     To initially-triangularize
!     set first l comps. Of dual vector to zero because
!     these correspond to the unconstrained variables.
if (.not.(l > 0)) go to 290
wd(1) = zero
call scopy(l, wd, 0, wd, 1)
!     The arrays idope(*) and dope(*) are used to pass
!     information to wnlit().  This was done to avoid
!     a long calling sequence or the use of common.
290 idope(1) = me
idope(2) = mep1
idope(3) = 0
idope(4) = 1
idope(5) = nsoln
idope(6) = 0
idope(7) = 1
idope(8) = l1
dope(1) = alsq
dope(2) = eanorm
dope(3) = fac
dope(4) = tau
call wnlit(w, mdw, m, n, l, ipivot, itype, h, scale, rnorm, &
   & idope, dope, done)
me = idope(1)
mep1 = idope(2)
krank = idope(3)
krp1 = idope(4)
nsoln = idope(5)
niv = idope(6)
niv1 = idope(7)
l1 = idope(8)
go to 20
300 continue
!     To compute-search-direction-and-feasible-point
!     solve the triangular system of currently non-active
!     variables and store the solution in z(*).
!     Solve-system
igo958 = 310
go to 1110
!     Increment iteration counter and check against max. Number
!     of iterations.
310 iter = iter + 1
if (.not.(iter > itmax)) go to 320
mode = 1
done = .true.
!     Check to see if any constraints have become active.
!     If so, calculate an interpolation factor so that all
!     active constraints are removed from the basis.
320 alpha = two
hitcon = .false.
if (.not.(l < nsoln)) go to 360
do j = lp1,nsoln
   zz = z(j)
   if (.not.(zz <= zero)) go to 350
   t = x(j)/(x(j) - zz)
   if (.not.(t < alpha)) go to 330
   alpha = t
   jcon = j
330 hitcon = .true.
350 continue
end do
360 go to 30
370 continue
!     To add-constraints
!     use computed alpha to interpolate between last
!     feasible solution x(*) and current unconstrained
!     (and infeasible) solution z(*).
if (.not.(lp1 <= nsoln)) go to 390
do j = lp1,nsoln
   x(j) = x(j) + alpha*(z(j) - x(j))
end do
390 feasbl = .false.
go to 410
400 if (feasbl) go to 20
!     Remove col JCON and shift cols JCON+1 through n to the
!     left. Swap col JCON into the n-TH position.  This achieves
!     upper Hessenberg form for the nonactive constraints and
!     leaves an upper Hessenberg matrix to retriangularize.
410 do i = 1,m
   t = w(i,jcon)
   call scopy(n - jcon, w(i,jcon + 1), mdw, w(i,jcon), mdw)
   w(i,n) = t
end do
!     Update permuted index vector to reflect this shift and swap.
itemp = ipivot(jcon)
if (.not.(jcon < n)) go to 440
do i = jcon,nm1
   ipivot(i) = ipivot(i + 1)
end do
440 ipivot(n) = itemp
!     Similarly repermute x(*) vector.
call scopy(n - jcon, x(jcon + 1), 1, x(jcon), 1)
x(n) = zero
nsp1 = nsoln
nsoln = nsoln - 1
niv1 = niv
niv = niv - 1
!     Retriangularize upper Hessenberg matrix after adding constraints.
j = jcon
i = krank + jcon - l
450 if (.not.(j <= nsoln)) go to 570
if (.not.(itype(i) == 0 .and. itype(i + 1) == 0)) go to 470
igo938 = 460
go to 620
!     (itype(i).EQ.0 .AND. itype(i+1).EQ.0) ZERO-IP1-TO-i-IN-COL-J
460 go to 560
470 if (.not.(itype(i) == 1 .and. itype(i + 1) == 1)) go to 490
igo938 = 480
go to 620
!     (itype(i).EQ.1 .AND. itype(i+1).EQ.1) ZERO-IP1-TO-i-IN-COL-J
480 go to 560
490 if (.not.(itype(i) == 1 .and. itype(i + 1) == 0)) go to 510
call sswap(np1, w(i,1), mdw, w(i + 1,1), mdw)
call sswap(1, scale(i), 1, scale(i + 1), 1)
itemp = itype(i + 1)
itype(i + 1) = itype(i)
itype(i) = itemp
!     Swapped row was formerly a pivot elt., So it will
!     be large enough to perform ELIM.
igo938 = 500
go to 620
!     Zero-IP1-to-i-in-col-J
500 go to 560
510 if (.not.(itype(i) == 0 .and. itype(i + 1) == 1)) go to 550
t = scale(i)*w(i,j)**2/alsq
if (.not.(t > tau**2*eanorm**2)) go to 530
igo938 = 520
go to 620
520 go to 540
530 call sswap(np1, w(i,1), mdw, w(i + 1,1), mdw)
call sswap(1, scale(i), 1, scale(i + 1), 1)
itemp = itype(i + 1)
itype(i + 1) = itype(i)
itype(i) = itemp
w(i + 1,j) = zero
540 continue
550 continue
560 i = i + 1
j = j + 1
go to 450
!     See if the remaining coeffs in the soln set are feasible.  They
!     should be because of the way alpha was determined.  If any are
!     infeasible it is due to roundoff error.  Any that are non-
!     positive will be set to zero and removed from the soln set.
570 if (.not.(lp1 <= nsoln)) go to 590
do jcon = lp1,nsoln
   if (x(jcon) <= zero) go to 600
end do
590 feasbl = .true.
600 continue
go to 400
620 continue
!     To zero-IP1-to-i-in-col-J
if (.not.(w(i + 1,j) /= zero)) go to 630
call srotmg(scale(i), scale(i + 1), w(i,j), w(i + 1,j), sparam)
w(i + 1,j) = zero
call srotm(np1 - j, w(i,j + 1), mdw, w(i + 1,j + 1), mdw, sparam)
630 go to 1290
!     To perform-multiplier-test-and-drop-A-constraint
640 call scopy(nsoln, z, 1, x, 1)
if (.not.(nsoln < n)) go to 650
x(nsp1) = zero
call scopy(n - nsoln, x(nsp1), 0, x(nsp1), 1)
650 i = niv1
660 if (.not.(i <= me)) go to 690
!     Reclassify least squares eqations as equalities as
!     necessary.
if (.not.(itype(i) == 0)) go to 670
i = i + 1
go to 680
670 call sswap(np1, w(i,1), mdw, w(me,1), mdw)
call sswap(1, scale(i), 1, scale(me), 1)
itemp = itype(i)
itype(i) = itype(me)
itype(me) = itemp
mep1 = me
me = me - 1
680 go to 660
!     Form inner product vector wd(*) of dual coeffs.
690 if (.not.(nsp1 <= n)) go to 730
do j = nsp1,n
   sm = zero
   if (.not.(nsoln < m)) go to 710
   do i = nsp1,m
      sm = sm + scale(i)*w(i,j)*w(i,np1)
   end do
710 wd(j) = sm
end do
730 go to 750
740 if (pos .or. done) go to 970
!     Find J such that wd(J)=WMAX is maximum.  This determines
!     that the incoming col J will reduce the residual vector
!     and be positive.
750 wmax = zero
iwmax = nsp1
if (.not.(nsp1 <= n)) go to 780
do j = nsp1,n
   if (.not.(wd(j) > wmax)) go to 760
   wmax = wd(j)
   iwmax = j
760 continue
end do
780 if (.not.(wmax <= zero)) go to 790
done = .true.
go to 960
!     Set dual COEFF to zero for incoming col.
790 wd(iwmax) = zero
!     WMAX .GT. zero, so okay to move col IWMAX to soln set.
!     Perform transformation to retriangularize, and test
!     for near linear dependence.
!     Swap col IWMAX into NSOLN-TH position to maintain upper
!     Hessenberg form of adjacent cols, and add new col to
!     triangular decomposition.
nsoln = nsp1
nsp1 = nsoln + 1
niv = niv1
niv1 = niv + 1
if (.not.(nsoln /= iwmax)) go to 800
call sswap(m, w(1,nsoln), 1, w(1,iwmax), 1)
wd(iwmax) = wd(nsoln)
wd(nsoln) = zero
itemp = ipivot(nsoln)
ipivot(nsoln) = ipivot(iwmax)
ipivot(iwmax) = itemp
!     Reduce col NSOLN so that the matrix of nonactive
!     constraints variables is triangular.
800 j = m
810 if (.not.(j > niv)) go to 870
jm1 = j - 1
jp = jm1
!     When operating near the me line, test to see if the pivot elt.
!     Is near zero.  If so, use the largest elt. Above it as the pivot.
!     This is to maintain the sharp interface between weighted and
!     non-weighted rows in all cases.
if (.not.(j == mep1)) go to 850
imax = me
amax = scale(me)*w(me,nsoln)**2
820 if (.not.(jp >= niv)) go to 840
t = scale(jp)*w(jp,nsoln)**2
if (.not.(t > amax)) go to 830
imax = jp
amax = t
830 jp = jp - 1
go to 820
840 jp = imax
850 if (.not.(w(j,nsoln) /= zero)) go to 860
call srotmg(scale(jp), scale(j), w(jp,nsoln), w(j,nsoln), sparam)
w(j,nsoln) = zero
call srotm(np1 - nsoln, w(jp,nsp1), mdw, w(j,nsp1), mdw, sparam)
860 j = jm1
go to 810
!     Solve for z(NSOLN)=Proposed new value for x(NSOLN).
!     Test if this is nonpositive or too large.
!     If this was true or if the pivot term was zero reject
!     the col as dependent.
870 if (.not.(w(niv,nsoln) /= zero)) go to 890
isol = niv
igo897 = 880
go to 980
!     Test-proposed-new-component
880 go to 940
890 if (.not.(niv <= me .and. w(mep1,nsoln) /= zero)) go to 920
!     Try to add row MEP1 as an additional equality constraint.
!     Check size of proposed new soln component.
!     Reject it if it is too large.
isol = mep1
igo897 = 900
go to 980
!     Test-proposed-new-component
900 if (.not.(pos)) go to 910
!     Swap rows MEP1 and NIV, and scale factors for these rows.
call sswap(np1, w(mep1,1), mdw, w(niv,1), mdw)
call sswap(1, scale(mep1), 1, scale(niv), 1)
itemp = itype(mep1)
itype(mep1) = itype(niv)
itype(niv) = itemp
me = mep1
mep1 = me + 1
910 go to 930
920 pos = .false.
930 continue
940 if (pos) go to 950
nsp1 = nsoln
nsoln = nsoln - 1
niv1 = niv
niv = niv - 1
950 continue
960 go to 740
970 go to 20
980 continue
!     To test-proposed-new-component
z2 = w(isol,np1)/w(isol,nsoln)
z(nsoln) = z2
pos = z2 > zero
if (.not.(z2*eanorm >= bnorm .and. pos)) go to 990
pos = .not.(blowup*z2*eanorm >= bnorm)
990 go to 1280
1000 continue
!     To compute-final-solution
!     solve system, store results in x(*).
igo958 = 1010
go to 1110
!     Solve-system
1010 call scopy(nsoln, z, 1, x, 1)
!     Apply Householder transformations to x(*) if KRANK.LT.l
if (.not.(0 < krank .and. krank < l)) go to 1030
do i = 1,krank
   call h12(2, i, krp1, l, w(i,1), mdw, h(i), x, 1, 1, 1)
end do
!     Fill in trailing zeroes for constrained variables not in soln.
1030 if (.not.(nsoln < n)) go to 1040
x(nsp1) = zero
call scopy(n - nsoln, x(nsp1), 0, x(nsp1), 1)
!     Repermute soln vector to natural order.
1040 do i = 1,n
   j = i
1050 if (ipivot(j) == i) go to 1060
   j = j + 1
   go to 1050
1060 ipivot(j) = ipivot(i)
   ipivot(i) = j
   call sswap(1, x(j), 1, x(i), 1)
end do
!     Rescale the soln using the col scaling.
do j = 1,n
   x(j) = x(j)*d(j)
end do
if (.not.(niv < m)) go to 1100
do i = niv1,m
   t = w(i,np1)
   if (i <= me) t = t/alamda
   t = (scale(i)*t)*t
   rnorm = rnorm + t
end do
1100 rnorm = sqrt(rnorm)
return
!     To solve-system
1110 continue
if (.not.(done)) go to 1120
isol = 1
go to 1130
1120 isol = lp1
1130 if (.not.(nsoln >= isol)) go to 1270
!     Copy RT. Hand side into temp vector to use overwriting method.
call scopy(niv, w(1,np1), 1, temp, 1)
do jj = isol,nsoln
   j = nsoln - jj + isol
   if (.not.(j > krank)) go to 1140
   i = niv - jj + isol
   go to 1150
1140 i = j
1150 if (.not.(j > krank .and. j <= l)) go to 1160
   z(j) = zero
   go to 1170
1160 z(j) = temp(i)/w(i,j)
   call saxpy(i - 1, -z(j), w(1,j), 1, temp, 1)
1170 continue
end do
1270 select case (igo958)
case (310)
   go to 310
case (1010)
   go to 1010
end select
1280 select case (igo897)
case (880)
   go to 880
case (900)
   go to 900
end select
1290 select case (igo938)
case (460)
   go to 460
case (480)
   go to 480
case (500)
   go to 500
case (520)
   go to 520
end select
end subroutine wnlsm

