subroutine dseig (a, ka, n, w, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka
integer :: n
integer :: l
!-----------------------------------------------------------------------
!                Double precision computation of the
!               eigenvalues of symmetric real matrices
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(*), w(n), t(*)
!
if (ka .eq. 0) go to 10
   call dtred1 (ka, n, a, w, t(n+1), t(1))
   call dtql (n, w, t, ierr)
   return
10 l = n*(n + 1)
l = l/2
call dtred3 (n, l, a, w, t(n+1), t(1))
call dtql (n, w, t, ierr)
return
end subroutine dseig

subroutine dseigv (a, ka, n, w, z, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
!-----------------------------------------------------------------------
!                 Double precision computation of
!                 eigenvalues and eigenvectors of
!                     symmetric real matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: w(n), z(ka,n), t(n)
!
call dtred2 (ka, n, a, w, t, z)
call dtql2 (ka, n, w, t, z, ierr)
return
end subroutine dseigv

subroutine dtred1 (nm,n,a,d,e,e2)
implicit none
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: ii
integer, intent(in) :: nm
integer :: jp1
double precision, intent(inout) :: a(nm,n), d(n), e(n), e2(n)
double precision :: f, g, h, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tred1,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!
!     This subroutine reduces a real symmetric matrix
!     to a symmetric tridiagonal matrix using
!     orthogonal similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        A contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!
!     On output-
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction in its strict lower
!          triangle.  The full upper triangle of A is unaltered,
!
!        d contains the diagonal elements of the tridiagonal matrix,
!
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!
!-----------------------------------------------------------------------
!
do 100 i = 1, n
100 d(i) = a(i,i)
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   h = 0.d0
   scale = 0.d0
   if (l .lt. 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do 120 k = 1, l
120 scale = scale + dabs(a(i,k))
!
   if (scale .ne. 0.d0) go to 140
130 e(i) = 0.d0
   e2(i) = 0.d0
   go to 290
!
140 do k = 1, l
      a(i,k) = a(i,k) / scale
      h = h + a(i,k) * a(i,k)
   end do
!
   e2(i) = scale * scale * h
   f = a(i,l)
   g = dsqrt(h)
   if (f .ge. 0.d0) g = -g
   e(i) = scale * g
   h = h - f * g
   a(i,l) = f - g
   if (l .eq. 1) go to 270
   f = 0.d0
!
   do j = 1, l
      g = 0.d0
!     ********** FORM ELEMENT OF a*U **********
      do 180 k = 1, j
180 g = g + a(j,k) * a(i,k)
!
      jp1 = j + 1
      if (l .lt. jp1) go to 220
!
      do 200 k = jp1, l
200 g = g + a(k,j) * a(i,k)
!     ********** FORM ELEMENT OF P **********
220 e(j) = g / h
      f = f + e(j) * a(i,j)
   end do
!
   h = f / (h + h)
!     ********** FORM REDUCED a **********
   do 260 j = 1, l
      f = a(i,j)
      g = e(j) - h * f
      e(j) = g
!
      do 260 k = 1, j
         a(j,k) = a(j,k) - f * e(k) - g * a(i,k)
260 continue
!
270 do 280 k = 1, l
280 a(i,k) = scale * a(i,k)
!
290 h = d(i)
   d(i) = a(i,i)
   a(i,i) = h
end do
!
return
!     ********** LAST CARD OF dtred1 **********
end subroutine dtred1

subroutine dtred3 (n,nv,a,d,e,e2)
implicit none
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: ii, iz, jk
integer, intent(in) :: nv
double precision, intent(inout) :: a(nv), d(n), e(n), e2(n)
double precision :: f, g, h, hh, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tred3,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!
!     This subroutine reduces a real symmetric matrix, stored as
!     a one-dimensional array, to a symmetric tridiagonal matrix
!     using orthogonal similarity transformations.
!
!     On input-
!
!        n is the order of the matrix,
!
!        nv must be set to the dimension of the array parameter A
!          as declared in the calling program dimension statement,
!
!        A contains the lower triangle of the real symmetric
!          input matrix, stored row-wise as a one-dimensional
!          array, in its first n*(n+1)/2 positions.
!
!     On output-
!
!        A contains information about the orthogonal
!          transformations used in the reduction,
!
!        d contains the diagonal elements of the tridiagonal matrix,
!
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!
!        e2 contains the squares of the corresponding elements of e.
!          e2 may coincide with e if the squares are not needed.
!
!-----------------------------------------------------------------------
!
!     ********** FOR i=n STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   iz = (i * l) / 2
   h = 0.d0
   scale = 0.d0
   if (l .lt. 1) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do k = 1, l
      iz = iz + 1
      d(k) = a(iz)
      scale = scale + dabs(d(k))
   end do
!
   if (scale .ne. 0.d0) go to 140
130 e(i) = 0.d0
   e2(i) = 0.d0
   go to 290
!
140 do k = 1, l
      d(k) = d(k) / scale
      h = h + d(k) * d(k)
   end do
!
   e2(i) = scale * scale * h
   f = d(l)
   g = dsqrt(h)
   if (f .ge. 0.d0) g = -g
   e(i) = scale * g
   h = h - f * g
   d(l) = f - g
   a(iz) = scale * d(l)
   if (l .eq. 1) go to 290
   f = 0.d0
!
   do j = 1, l
      g = 0.d0
      jk = (j * (j-1)) / 2
!     ********** FORM ELEMENT OF a*U **********
      do k = 1, l
         jk = jk + 1
         if (k .gt. j) jk = jk + k - 2
         g = g + a(jk) * d(k)
      end do
!     ********** FORM ELEMENT OF P **********
      e(j) = g / h
      f = f + e(j) * d(j)
   end do
!
   hh = f / (h + h)
   jk = 0
!     ********** FORM REDUCED a **********
   do 260 j = 1, l
      f = d(j)
      g = e(j) - hh * f
      e(j) = g
!
      do 260 k = 1, j
         jk = jk + 1
         a(jk) = a(jk) - f * e(k) - g * d(k)
260 continue
!
290 d(i) = a(iz+1)
   a(iz+1) = scale * dsqrt(h)
end do
!
return
!     ********** LAST CARD OF dtred3 **********
end subroutine dtred3

subroutine dtql (n,d,e2,ierr)
implicit none
!
integer :: i, j, l, m
integer, intent(in) :: n
integer :: ii, l1, mml
integer, intent(out) :: ierr
double precision, intent(inout) :: d(n), e2(n)
double precision :: b, c, f, g, h, p, r, s, machep
double precision :: dpmpar
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tqlrat,
!     algorithm 464, comm. ACM 16, 689(1973) by Reinsch.
!
!     This subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the rational QL method.
!
!     On input-
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e2 contains the squares of the subdiagonal elements of the
!          input matrix in its last n-1 positions.  e2(1) is arbitrary.
!
!      On output-
!
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!
!        e2 has been destroyed,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
if (n .eq. 1) go to 1001
!
do 100 i = 2, n
100 e2(i-1) = e2(i)
!
f = 0.d0
b = 0.d0
e2(n) = 0.d0
!
do l = 1, n
   j = 0
   h = machep * (dabs(d(l)) + dsqrt(e2(l)))
   if (b .gt. h) go to 105
   b = h
   c = b * b
!     ********** LOOK FOR SMALL SQUARED SUB-DIAGONAL ELEMENT **********
105 do m = l, n
      if (e2(m) .le. c) go to 120
!     ********** e2(n) IS ALWAYS ZERO, SO THERE IS NO EXIT
!                THROUGH THE BOTTOM OF THE LOOP **********
   end do
!
120 if (m .eq. l) go to 210
130 if (j .eq. 50) go to 1000
   j = j + 1
!     ********** FORM SHIFT **********
   l1 = l + 1
   s = dsqrt(e2(l))
   g = d(l)
   p = (d(l1) - g) / (2.d0 * s)
   r = dsqrt(p*p + 1.d0)
   if (p .lt. 0.d0) r = -r
   d(l) = s / (p + r)
   h = g - d(l)
!
   do 140 i = l1, n
140 d(i) = d(i) - h
!
   f = f + h
!     ********** RATIONAL QL TRANSFORMATION **********
   g = d(m)
   if (g .eq. 0.d0) g = b
   h = g
   s = 0.d0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
   do ii = 1, mml
      i = m - ii
      p = g * h
      r = p + e2(i)
      e2(i+1) = s * r
      s = e2(i) / r
      d(i+1) = h + s * (h + d(i))
      g = d(i) - e2(i) / g
      if (g .eq. 0.d0) g = b
      h = g * p / r
   end do
!
   e2(l) = s * g
   d(l) = h
!     ********** GUARD AGAINST UNDERFLOW IN CONVERGENCE TEST **********
   if (h .eq. 0.d0) go to 210
   if (dabs(e2(l)) .le. dabs(c/h)) go to 210
   e2(l) = h * e2(l)
   if (e2(l) .ne. 0.d0) go to 130
210 p = d(l) + f
!     ********** ORDER EIGENVALUES **********
   if (l .eq. 1) go to 250
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
   do ii = 2, l
      i = l + 2 - ii
      if (p .ge. d(i-1)) go to 270
      d(i) = d(i-1)
   end do
!
250 i = 1
270 d(i) = p
end do
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
1000 ierr = l
1001 return
!     ********** LAST CARD OF dtql **********
end subroutine dtql

subroutine dtred2 (nm,n,a,d,e,z)
implicit none
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: ii
integer, intent(in) :: nm
integer :: jp1
double precision, intent(in) :: a(nm,n)
double precision, intent(inout) :: d(n), e(n), z(nm,n)
double precision :: f, g, h, hh, scale
!     double precision dsqrt,dabs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tred2,
!     NUM. Math. 11, 181-195(1968) By Martin, Reinsch, and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 212-226(1971).
!
!     This subroutine reduces a real symmetric matrix to A
!     symmetric tridiagonal matrix using and accumulating
!     orthogonal similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        A contains the real symmetric input matrix.  Only the
!          lower triangle of the matrix need be supplied.
!
!     On output-
!
!        d contains the diagonal elements of the tridiagonal matrix,
!
!        e contains the subdiagonal elements of the tridiagonal
!          matrix in its last n-1 positions.  e(1) is set to zero,
!
!        z contains the orthogonal transformation matrix
!          produced in the reduction,
!
!        A and z may coincide.  If distinct, A is unaltered.
!
!-----------------------------------------------------------------------
!
do 100 i = 1, n
!
   do 100 j = 1, i
      z(i,j) = a(i,j)
100 continue
!
if (n .eq. 1) go to 320
!     ********** FOR i=n STEP -1 UNTIL 2 DO -- **********
do ii = 2, n
   i = n + 2 - ii
   l = i - 1
   h = 0.d0
   scale = 0.d0
   if (l .lt. 2) go to 130
!     ********** scale ROW (ALGOL TOL THEN NOT NEEDED) **********
   do 120 k = 1, l
120 scale = scale + dabs(z(i,k))
!
   if (scale .ne. 0.d0) go to 140
130 e(i) = z(i,l)
   go to 290
!
140 do k = 1, l
      z(i,k) = z(i,k) / scale
      h = h + z(i,k) * z(i,k)
   end do
!
   f = z(i,l)
   g = dsqrt(h)
   if (f .ge. 0.d0) g = -g
   e(i) = scale * g
   h = h - f * g
   z(i,l) = f - g
   f = 0.d0
!
   do j = 1, l
      z(j,i) = z(i,j) / h
      g = 0.d0
!     ********** FORM ELEMENT OF a*U **********
      do 180 k = 1, j
180 g = g + z(j,k) * z(i,k)
!
      jp1 = j + 1
      if (l .lt. jp1) go to 220
!
      do 200 k = jp1, l
200 g = g + z(k,j) * z(i,k)
!     ********** FORM ELEMENT OF P **********
220 e(j) = g / h
      f = f + e(j) * z(i,j)
   end do
!
   hh = f / (h + h)
!     ********** FORM REDUCED a **********
   do 260 j = 1, l
      f = z(i,j)
      g = e(j) - hh * f
      e(j) = g
!
      do 260 k = 1, j
         z(j,k) = z(j,k) - f * e(k) - g * z(i,k)
260 continue
!
290 d(i) = h
end do
!
320 d(1) = 0.d0
e(1) = 0.d0
!     ********** ACCUMULATION OF TRANSFORMATION MATRICES **********
do 500 i = 1, n
   l = i - 1
   if (d(i) .eq. 0.d0) go to 380
!
   do 360 j = 1, l
      g = 0.d0
!
      do 340 k = 1, l
340 g = g + z(i,k) * z(k,j)
!
      do 360 k = 1, l
         z(k,j) = z(k,j) - g * z(k,i)
360 continue
!
380 d(i) = z(i,i)
   z(i,i) = 1.d0
   if (l .lt. 1) go to 500
!
   do j = 1, l
      z(i,j) = 0.d0
      z(j,i) = 0.d0
   end do
!
500 continue
!
return
!     ********** LAST CARD OF dtred2 **********
end subroutine dtred2

subroutine dtql2 (nm,n,d,e,z,ierr)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: ii, l1
integer, intent(in) :: nm
integer :: mml
integer, intent(out) :: ierr
double precision, intent(inout) :: d(n), e(n), z(nm,n)
double precision :: b, c, f, g, h, p, r, s, machep
double precision :: dpmpar
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure tql2,
!     NUM. Math. 11, 293-306(1968) By Bowdler, Martin, Reinsch, and
!     Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 227-240(1971).
!
!     This subroutine finds the eigenvalues and eigenvectors
!     of a symmetric tridiagonal matrix BY the QL method.
!     The eigenvectors of a full symmetric matrix can also
!     be found if  tred2  has been used to reduce this
!     full matrix to tridiagonal form.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e contains the subdiagonal elements of the input matrix
!          in its last n-1 positions.  e(1) is arbitrary,
!
!        z contains the transformation matrix produced in the
!          reduction by  tred2, if performed.  If the eigenvectors
!          of the tridiagonal matrix are desired, z must contain
!          the identity matrix.
!
!      On output-
!
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct but
!          unordered for indices 1,2,...,ierr-1,
!
!        e has been destroyed,
!
!        z contains orthonormal eigenvectors of the symmetric
!          tridiagonal (or full) matrix.  If an error exit is made,
!          z contains the eigenvectors associated with the stored
!          eigenvalues,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                machep the value U where U is the smallest positive
!                FLOATING POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0 .
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
if (n .eq. 1) go to 1001
!
do 100 i = 2, n
100 e(i-1) = e(i)
!
f = 0.d0
b = 0.d0
e(n) = 0.d0
!
do l = 1, n
   j = 0
   h = machep * (dabs(d(l)) + dabs(e(l)))
   if (b .lt. h) b = h
!     ********** LOOK FOR SMALL SUB-DIAGONAL ELEMENT **********
   do m = l, n
      if (dabs(e(m)) .le. b) go to 120
!     ********** e(n) IS ALWAYS ZERO, SO THERE IS NO EXIT
!                THROUGH THE BOTTOM OF THE LOOP **********
   end do
!
120 if (m .eq. l) go to 220
130 if (j .eq. 50) go to 1000
   j = j + 1
!     ********** FORM SHIFT **********
   l1 = l + 1
   g = d(l)
   p = (d(l1) - g) / (2.d0 * e(l))
   r = dsqrt(p*p + 1.d0)
   if (p .lt. 0.d0) r = -r
   d(l) = e(l) / (p + r)
   h = g - d(l)
!
   do 140 i = l1, n
140 d(i) = d(i) - h
!
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
      if (dabs(p) .lt. dabs(e(i))) go to 150
      c = e(i) / p
      r = dsqrt(c*c + 1.d0)
      e(i+1) = s * p * r
      s = c / r
      c = 1.d0 / r
      go to 160
150 c = p / e(i)
      r = dsqrt(c*c + 1.d0)
      e(i+1) = s * e(i) * r
      s = 1.d0 / r
      c = c * s
160 p = c * d(i) - s * g
      d(i+1) = h + s * (c * g + s * d(i))
!     ********** FORM VECTOR **********
      do k = 1, n
         h = z(k,i+1)
         z(k,i+1) = s * z(k,i) + c * h
         z(k,i) = c * z(k,i) - s * h
      end do
!
   end do
!
   e(l) = s * p
   d(l) = c * p
   if (dabs(e(l)) .gt. b) go to 130
220 d(l) = d(l) + f
end do
!     ********** ORDER EIGENVALUES AND EIGENVECTORS **********
do 300 ii = 2, n
   i = ii - 1
   k = i
   p = d(i)
!
   do 260 j = ii, n
      if (d(j) .ge. p) go to 260
      k = j
      p = d(j)
260 continue
!
   if (k .eq. i) go to 300
   d(k) = d(i)
   d(i) = p
!
   do j = 1, n
      p = z(j,i)
      z(j,i) = z(j,k)
      z(j,k) = p
   end do
!
300 continue
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
1000 ierr = l
1001 return
!     ********** LAST CARD OF dtql2 **********
end subroutine dtql2

subroutine ceig(ibal,ar,ai,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, low
!-----------------------------------------------------------------------
!                Eigenvalues of complex matrices
!-----------------------------------------------------------------------
real, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), wi(n)
!
low = 1
igh = n
if (ibal .ne. 0) call cbal(ka,n,ar,ai,low,igh,wr)
call corth(ka,n,low,igh,ar,ai,wr,wi)
call comqr(ka,n,low,igh,ar,ai,wr,wi,ierr)
return
end subroutine ceig

subroutine ceigv(ibal,ar,ai,ka,n,wr,wi,zr,zi,ierr,temp)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: i1, i2, i3, igh, low
!-----------------------------------------------------------------------
!          Eigenvalues and eigenvectors of complex matrices
!-----------------------------------------------------------------------
real, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), wi(n), zr(ka,n), &
&zi(ka,n), temp(*)
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
if (ibal .ne. 0) call cbal(ka,n,ar,ai,low,igh,temp(i1))
call corth(ka,n,low,igh,ar,ai,temp(i2),temp(i3))
call comqr2(ka,n,low,igh,temp(i2),temp(i3),ar,ai,wr,wi,zr,zi,ierr)
if (ierr .ne. 0) return
if (ibal .ne. 0) call cbabk2(ka,n,low,igh,temp(i1),n,zr,zi)
return
end subroutine ceigv

subroutine cbal(nm,n,ar,ai,low,igh,scale)
implicit none
integer :: ipmpar
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: jj
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
integer :: iexc
real, intent(inout) :: ar(nm,n), ai(nm,n), scale(n)
real :: c, f, g, r, s, b2, radix
!     real abs
logical :: noconv
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure
!     CBALANCE, which is a complex version of balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!
!     This subroutine balances a complex matrix and isolates
!     eigenvalues whenever possible.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex matrix to be balanced.
!
!     On output-
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the balanced matrix,
!
!        Low and igh are two integers such that ar(i,j) and ai(i,j)
!          are equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!
!        Scale contains information determining the
!           permutations and scaling factors used.
!
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j)       j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!
!     Note that 1 is returned for igh if igh is zero formally.
!
!     The Algol procedure exc contained in CBALANCE appears in
!     cbal  in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!
!-----------------------------------------------------------------------
!
!     ********** radix IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the base of the machine floating point representation.
!
           radix = ipmpar(4)
!
!                **********
!
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** IN-LINE PROCEDURE FOR ROW AND
!                COLUMN EXCHANGE **********
20 scale(m) = j
if (j .eq. m) go to 50
!
do i = 1, l
   f = ar(i,j)
   ar(i,j) = ar(i,m)
   ar(i,m) = f
   f = ai(i,j)
   ai(i,j) = ai(i,m)
   ai(i,m) = f
end do
!
do i = k, n
   f = ar(j,i)
   ar(j,i) = ar(m,i)
   ar(m,i) = f
   f = ai(j,i)
   ai(j,i) = ai(m,i)
   ai(m,i) = f
end do
!
50 go to (80,130), iexc
!     ********** SEARCH FOR ROWS ISOLATING AN EIGENVALUE
!                AND PUSH THEM DOWN **********
80 if (l .eq. 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do 120 jj = 1, l
   j = l + 1 - jj
!
   do 110 i = 1, l
      if (i .eq. j) go to 110
      if (ar(j,i) .ne. 0.0 .or. ai(j,i) .ne. 0.0) go to 120
110 continue
!
   m = l
   iexc = 1
   go to 20
120 continue
!
go to 140
!     ********** SEARCH FOR COLUMNS ISOLATING AN EIGENVALUE
!                AND PUSH THEM LEFT **********
130 k = k + 1
!
140 do 170 j = k, l
!
   do 150 i = k, l
      if (i .eq. j) go to 150
      if (ar(i,j) .ne. 0.0 .or. ai(i,j) .ne. 0.0) go to 170
150 continue
!
   m = k
   iexc = 2
   go to 20
170 continue
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS k TO l **********
do 180 i = k, l
180 scale(i) = 1.0
!     ********** ITERATIVE LOOP FOR NORM REDUCTION **********
190 noconv = .false.
!
do 270 i = k, l
   c = 0.0
   r = 0.0
!
   do 200 j = k, l
      if (j .eq. i) go to 200
      c = c + abs(ar(j,i)) + abs(ai(j,i))
      r = r + abs(ar(i,j)) + abs(ai(i,j))
200 continue
!     ********** GUARD AGAINST ZERO c OR r DUE TO UNDERFLOW **********
   if (c .eq. 0.0 .or. r .eq. 0.0) go to 270
   g = r / radix
   f = 1.0
   s = c + r
210 if (c .ge. g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c .lt. g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** NOW BALANCE **********
240 if ((c + r) / f .ge. 0.95 * s) go to 270
   g = 1.0 / f
   scale(i) = scale(i) * f
   noconv = .true.
!
   do j = k, n
      ar(i,j) = ar(i,j) * g
      ai(i,j) = ai(i,j) * g
   end do
!
   do j = 1, l
      ar(j,i) = ar(j,i) * f
      ai(j,i) = ai(j,i) * f
   end do
!
270 continue
!
if (noconv) go to 190
!
280 low = k
igh = l
return
!     ********** LAST CARD OF cbal **********
end subroutine cbal

subroutine corth(nm,n,low,igh,ar,ai,ortr,orti)
implicit none
!
integer :: i, j, m
integer, intent(in) :: n
integer :: ii, jj, la, mp
integer, intent(in) :: nm, igh
integer :: kp1
integer, intent(in) :: low
real, intent(inout) :: ar(nm,n), ai(nm,n), ortr(igh), orti(igh)
real :: f, g, h, fi, fr, scale
!     real sqrt,cabs,abs
!     complex cmplx
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of a complex analogue of
!     the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!     by Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!
!     Given a complex general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     unitary similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          SET low=1, igh=n,
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex input matrix.
!
!     On output-
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the Hessenberg matrix.  Information
!          about the unitary transformations used in the reduction
!          is stored in the remaining triangles under the
!          Hessenberg matrix,
!
!        ortr and orti contain further information about the
!          transformations.  Only elements low through igh are used.
!
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la .lt. kp1) go to 200
!
do 180 m = kp1, la
   h = 0.0
   ortr(m) = 0.0
   orti(m) = 0.0
   scale = 0.0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + abs(ar(i,m-1)) + abs(ai(i,m-1))
!
   if (scale .eq. 0.0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ortr(i) = ar(i,m-1) / scale
      orti(i) = ai(i,m-1) / scale
      h = h + ortr(i) * ortr(i) + orti(i) * orti(i)
   end do
!
   g = sqrt(h)
   f = cabs(cmplx(ortr(m),orti(m)))
   if (f .eq. 0.0) go to 103
   h = h + f * g
   g = g / f
   ortr(m) = (1.0 + g) * ortr(m)
   orti(m) = (1.0 + g) * orti(m)
   go to 105
!
103 ortr(m) = g
   ar(m,m-1) = scale
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
!
      fr = fr / h
      fi = fi / h
!
      do i = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(i) + fi * orti(i)
         ai(i,j) = ai(i,j) - fr * orti(i) - fi * ortr(i)
      end do
!
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
!
      fr = fr / h
      fi = fi / h
!
      do j = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(j) - fi * orti(j)
         ai(i,j) = ai(i,j) + fr * orti(j) - fi * ortr(j)
      end do
!
   end do
!
   ortr(m) = scale * ortr(m)
   orti(m) = scale * orti(m)
   ar(m,m-1) = -g * ar(m,m-1)
   ai(m,m-1) = -g * ai(m,m-1)
180 continue
!
200 return
!     ********** LAST CARD OF corth **********
end subroutine corth

subroutine comqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
implicit none
!
integer :: i, j, l
integer, intent(in) :: n
integer :: en, ll
integer, intent(in) :: nm, igh
integer :: its
integer, intent(in) :: low
integer :: lp1, enm1
integer, intent(out) :: ierr
real, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), wi(n)
real :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep
complex :: z3
real :: spmpar
!     integer min0
!     real sqrt,cabs,abs,real,aimag
!     complex csqrt,cmplx
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!
!     This subroutine finds the eigenvalues of a complex
!     upper Hessenberg matrix BY the QR method.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          SET low=1, igh=n,
!
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain
!          information about the unitary transformations used in
!          the reduction by  corth, if performed.
!
!     On output-
!
!        The upper Hessenberg portions of hr and hi have been
!          destroyed.  Therefore, they must be saved before
!          calling  comqr  if subsequent calculation of
!          eigenvectors is to be performed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division and use of the subroutines
!     CSQRT and cmplx in computing complex square roots.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the relative precision of floating point arithmetic.
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
if (low .eq. igh) go to 180
!     ********** CREATE REAL SUBDIAGONAL ELEMENTS **********
l = low + 1
!
do 170 i = l, igh
   ll = min0(i+1,igh)
   if (hi(i,i-1) .eq. 0.0) go to 170
   norm = cabs(cmplx(hr(i,i-1),hi(i,i-1)))
   yr = hr(i,i-1) / norm
   yi = hi(i,i-1) / norm
   hr(i,i-1) = norm
   hi(i,i-1) = 0.0
!
   do j = i, igh
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
!
   do j = low, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
!
170 continue
!     ********** STORE ROOTS ISOLATED BY cbal **********
180 do 200 i = 1, n
   if (i .ge. low .and. i .le. igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
!
en = igh
tr = 0.0
ti = 0.0
!     ********** SEARCH FOR NEXT EIGENVALUE **********
220 if (en .lt. low) go to 1001
its = 0
enm1 = en - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL low  -- **********
240 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 300
   if (abs(hr(l,l-1)) .le. &
&machep * (abs(hr(l-1,l-1)) + abs(hi(l-1,l-1)) &
&+ abs(hr(l,l)) +abs(hi(l,l)))) go to 300
end do
!     ********** FORM SHIFT **********
300 if (l .eq. en) go to 660
if (its .eq. 30) go to 1000
if (its .eq. 10 .or. its .eq. 20) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr .eq. 0.0 .and. xi .eq. 0.0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.0
yi = (hi(enm1,enm1) - si) / 2.0
z3 = csqrt(cmplx(yr**2-yi**2+xr,2.0*yr*yi+xi))
zzr = real(z3)
zzi = aimag(z3)
if (yr * zzr + yi * zzi .ge. 0.0) go to 310
zzr = -zzr
zzi = -zzi
310 z3 = cmplx(xr,xi) / cmplx(yr+zzr,yi+zzi)
sr = sr - real(z3)
si = si - aimag(z3)
go to 340
!     ********** FORM EXCEPTIONAL SHIFT **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en-2))
si = 0.0
!
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
!
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** REDUCE TO TRIANGLE (ROWS) **********
lp1 = l + 1
!
do i = lp1, en
   sr = hr(i,i-1)
   hr(i,i-1) = 0.0
   norm = sqrt(hr(i-1,i-1)*hr(i-1,i-1)+hi(i-1,i-1)*hi(i-1,i-1) &
&+sr*sr)
   xr = hr(i-1,i-1) / norm
   wr(i-1) = xr
   xi = hi(i-1,i-1) / norm
   wi(i-1) = xi
   hr(i-1,i-1) = norm
   hi(i-1,i-1) = 0.0
   hi(i,i-1) = sr / norm
!
   do j = i, en
      yr = hr(i-1,j)
      yi = hi(i-1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i-1,j) = xr * yr + xi * yi + hi(i,i-1) * zzr
      hi(i-1,j) = xr * yi - xi * yr + hi(i,i-1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i-1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i-1) * yi
   end do
!
end do
!
si = hi(en,en)
if (si .eq. 0.0) go to 540
norm = cabs(cmplx(hr(en,en),si))
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.0
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j-1)
   xi = wi(j-1)
!
   do i = l, j
      yr = hr(i,j-1)
      yi = 0.0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i .eq. j) go to 560
      yi = hi(i,j-1)
      hi(i,j-1) = xr * yi + xi * yr + hi(j,j-1) * zzi
560 hr(i,j-1) = xr * yr - xi * yi + hi(j,j-1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j-1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j-1) * yi
   end do
!
end do
!
if (si .eq. 0.0) go to 240
!
do i = l, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
!
go to 240
!     ********** A ROOT FOUND **********
660 wr(en) = hr(en,en) + tr
wi(en) = hi(en,en) + ti
en = enm1
go to 220
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = en
1001 return
!     ********** LAST CARD OF comqr **********
end subroutine comqr

subroutine cbabk2(nm,n,low,igh,scale,m,zr,zi)
implicit none
!
integer :: i, j, k
integer, intent(in) :: m, n
integer :: ii
integer, intent(in) :: nm, igh, low
real, intent(in) :: scale(n)
real, intent(inout) :: zr(nm,m), zi(nm,m)
real :: s
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure
!     cbabk2, which is a complex version of balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!
!     This subroutine forms the eigenvectors of a complex general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by  cbal.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by  cbal,
!
!        Scale contains information determining the permutations
!          and scaling factors used by  cbal,
!
!        m is the number of eigenvectors to be back transformed,
!
!        zr and zi contain the real and imaginary parts,
!          respectively, of the eigenvectors to be
!          back transformed in their first m columns.
!
!     On output-
!
!        zr and zi contain the real and imaginary parts,
!          respectively, of the transformed eigenvectors
!          in their first m columns.
!
!-----------------------------------------------------------------------
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
!
end do
!     ********** FOR i=low-1 STEP -1 UNTIL 1,
!                igh+1 STEP 1 UNTIL n DO -- **********
120 do 140 ii = 1, n
   i = ii
   if (i .ge. low .and. i .le. igh) go to 140
   if (i .lt. low) i = low - ii
   k = scale(i)
   if (k .eq. i) go to 140
!
   do j = 1, m
      s = zr(i,j)
      zr(i,j) = zr(k,j)
      zr(k,j) = s
      s = zi(i,j)
      zi(i,j) = zi(k,j)
      zi(k,j) = s
   end do
!
140 continue
!
200 return
!     ********** LAST CARD OF cbabk2 **********
end subroutine cbabk2

subroutine comqr2(nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi,ierr)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ii, jj, ll
integer, intent(in) :: nm
integer :: nn
integer, intent(in) :: igh
integer :: ip1, its
integer, intent(in) :: low
integer :: lp1, enm1, iend
integer, intent(out) :: ierr
real, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), wi(n), zr(nm,n), &
&zi(nm,n), ortr(igh), orti(igh)
real :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, norm, machep
complex :: z3
real :: spmpar
!     integer min0
!     real sqrt,cabs,abs,real,aimag
!     complex csqrt,cmplx
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!
!     This subroutine finds the eigenvalues and eigenvectors
!     of a complex upper Hessenberg matrix BY the QR
!     method.  The eigenvectors of a complex general matrix
!     can also be found if  corth  has been used to reduce
!     this general matrix to Hessenberg form.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  cbal.  If  cbal  has not been used,
!          SET low=1, igh=n,
!
!        ORTR and ORTI contain information about the unitary trans-
!          formations used in the reduction by  corth, if performed.
!          Only elements low through igh are used.  If the eigenvectors
!          of the Hessenberg matrix are desired, set ORTR(j) and
!          ORTI(j) to 0.0 for these elements,
!
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain further
!          information about the transformations which were used in the
!          reduction by  corth, if performed.  If the eigenvectors of
!          the Hessenberg matrix are desired, these elements may be
!          arbitrary.
!
!     On output-
!
!        ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!          have been destroyed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        zr and ZI contain the real and imaginary parts,
!          respectively, of the eigenvectors.  The eigenvectors
!          are unnormalized.  If an error exit is made, none of
!          the eigenvectors has been found,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division and use of the subroutines
!     CSQRT and cmplx in computing complex square roots.
!
!-----------------------------------------------------------------------
!
!     ********** machep IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the relative precision of floating point arithmetic.
!
           machep = spmpar(1)
!
!                **********
!
ierr = 0
!     ********** INITIALIZE EIGENVECTOR MATRIX **********
do 100 i = 1, n
!
   do 100 j = 1, n
      zr(i,j) = 0.0
      zi(i,j) = 0.0
      if (i .eq. j) zr(i,j) = 1.0
100 continue
!     ********** FORM THE MATRIX OF ACCUMULATED TRANSFORMATIONS
!                FROM THE INFORMATION LEFT BY corth **********
iend = igh - low - 1
if (iend) 180, 150, 105
!     ********** FOR i=igh-1 STEP -1 UNTIL low+1 DO -- **********
105 do 140 ii = 1, iend
   i = igh - ii
   if (ortr(i) .eq. 0.0 .and. orti(i) .eq. 0.0) go to 140
   if (hr(i,i-1) .eq. 0.0 .and. hi(i,i-1) .eq. 0.0) go to 140
!     ********** norm BELOW IS NEGATIVE OF H FORMED IN corth **********
   norm = hr(i,i-1) * ortr(i) + hi(i,i-1) * orti(i)
   ip1 = i + 1
!
   do k = ip1, igh
      ortr(k) = hr(k,i-1)
      orti(k) = hi(k,i-1)
   end do
!
   do j = i, igh
      sr = 0.0
      si = 0.0
!
      do k = i, igh
         sr = sr + ortr(k) * zr(k,j) + orti(k) * zi(k,j)
         si = si + ortr(k) * zi(k,j) - orti(k) * zr(k,j)
      end do
!
      sr = sr / norm
      si = si / norm
!
      do k = i, igh
         zr(k,j) = zr(k,j) + sr * ortr(k) - si * orti(k)
         zi(k,j) = zi(k,j) + sr * orti(k) + si * ortr(k)
      end do
!
   end do
!
140 continue
!     ********** CREATE REAL SUBDIAGONAL ELEMENTS **********
150 l = low + 1
!
do 170 i = l, igh
   ll = min0(i+1,igh)
   if (hi(i,i-1) .eq. 0.0) go to 170
   norm = cabs(cmplx(hr(i,i-1),hi(i,i-1)))
   yr = hr(i,i-1) / norm
   yi = hi(i,i-1) / norm
   hr(i,i-1) = norm
   hi(i,i-1) = 0.0
!
   do j = i, n
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
!
   do j = 1, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
!
   do j = low, igh
      si = yr * zi(j,i) + yi * zr(j,i)
      zr(j,i) = yr * zr(j,i) - yi * zi(j,i)
      zi(j,i) = si
   end do
!
170 continue
!     ********** STORE ROOTS ISOLATED BY cbal **********
180 do 200 i = 1, n
   if (i .ge. low .and. i .le. igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
!
en = igh
tr = 0.0
ti = 0.0
!     ********** SEARCH FOR NEXT EIGENVALUE **********
220 if (en .lt. low) go to 680
its = 0
enm1 = en - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
240 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 300
   if (abs(hr(l,l-1)) .le. &
&machep * (abs(hr(l-1,l-1)) + abs(hi(l-1,l-1)) &
&+ abs(hr(l,l)) +abs(hi(l,l)))) go to 300
end do
!     ********** FORM SHIFT **********
300 if (l .eq. en) go to 660
if (its .eq. 30) go to 1000
if (its .eq. 10 .or. its .eq. 20) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr .eq. 0.0 .and. xi .eq. 0.0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.0
yi = (hi(enm1,enm1) - si) / 2.0
z3 = csqrt(cmplx(yr**2-yi**2+xr,2.0*yr*yi+xi))
zzr = real(z3)
zzi = aimag(z3)
if (yr * zzr + yi * zzi .ge. 0.0) go to 310
zzr = -zzr
zzi = -zzi
310 z3 = cmplx(xr,xi) / cmplx(yr+zzr,yi+zzi)
sr = sr - real(z3)
si = si - aimag(z3)
go to 340
!     ********** FORM EXCEPTIONAL SHIFT **********
320 sr = abs(hr(en,enm1)) + abs(hr(enm1,en-2))
si = 0.0
!
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
!
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** REDUCE TO TRIANGLE (ROWS) **********
lp1 = l + 1
!
do i = lp1, en
   sr = hr(i,i-1)
   hr(i,i-1) = 0.0
   norm = sqrt(hr(i-1,i-1)*hr(i-1,i-1)+hi(i-1,i-1)*hi(i-1,i-1) &
&+sr*sr)
   xr = hr(i-1,i-1) / norm
   wr(i-1) = xr
   xi = hi(i-1,i-1) / norm
   wi(i-1) = xi
   hr(i-1,i-1) = norm
   hi(i-1,i-1) = 0.0
   hi(i,i-1) = sr / norm
!
   do j = i, n
      yr = hr(i-1,j)
      yi = hi(i-1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i-1,j) = xr * yr + xi * yi + hi(i,i-1) * zzr
      hi(i-1,j) = xr * yi - xi * yr + hi(i,i-1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i-1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i-1) * yi
   end do
!
end do
!
si = hi(en,en)
if (si .eq. 0.0) go to 540
norm = cabs(cmplx(hr(en,en),si))
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.0
if (en .eq. n) go to 540
ip1 = en + 1
!
do j = ip1, n
   yr = hr(en,j)
   yi = hi(en,j)
   hr(en,j) = sr * yr + si * yi
   hi(en,j) = sr * yi - si * yr
end do
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j-1)
   xi = wi(j-1)
!
   do i = 1, j
      yr = hr(i,j-1)
      yi = 0.0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i .eq. j) go to 560
      yi = hi(i,j-1)
      hi(i,j-1) = xr * yi + xi * yr + hi(j,j-1) * zzi
560 hr(i,j-1) = xr * yr - xi * yi + hi(j,j-1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j-1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j-1) * yi
   end do
!
   do i = low, igh
      yr = zr(i,j-1)
      yi = zi(i,j-1)
      zzr = zr(i,j)
      zzi = zi(i,j)
      zr(i,j-1) = xr * yr - xi * yi + hi(j,j-1) * zzr
      zi(i,j-1) = xr * yi + xi * yr + hi(j,j-1) * zzi
      zr(i,j) = xr * zzr + xi * zzi - hi(j,j-1) * yr
      zi(i,j) = xr * zzi - xi * zzr - hi(j,j-1) * yi
   end do
!
end do
!
if (si .eq. 0.0) go to 240
!
do i = 1, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
!
do i = low, igh
   yr = zr(i,en)
   yi = zi(i,en)
   zr(i,en) = sr * yr - si * yi
   zi(i,en) = sr * yi + si * yr
end do
!
go to 240
!     ********** A ROOT FOUND **********
660 hr(en,en) = hr(en,en) + tr
wr(en) = hr(en,en)
hi(en,en) = hi(en,en) + ti
wi(en) = hi(en,en)
en = enm1
go to 220
!     ********** ALL ROOTS FOUND.  BACKSUBSTITUTE TO FIND
!                VECTORS OF UPPER TRIANGULAR FORM **********
680 norm = 0.0
!
do 720 i = 1, n
!
   do 720 j = i, n
      norm = norm + abs(hr(i,j)) + abs(hi(i,j))
720 continue
!
if (n .eq. 1 .or. norm .eq. 0.0) go to 1001
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
      if (i .eq. enm1) go to 760
      ip1 = i + 1
!
      do j = ip1, enm1
         zzr = zzr + hr(i,j) * hr(j,en) - hi(i,j) * hi(j,en)
         zzi = zzi + hr(i,j) * hi(j,en) + hi(i,j) * hr(j,en)
      end do
!
760 yr = xr - wr(i)
      yi = xi - wi(i)
      if (yr .eq. 0.0 .and. yi .eq. 0.0) yr = machep * norm
      z3 = cmplx(zzr,zzi) / cmplx(yr,yi)
      hr(i,en) = real(z3)
      hi(i,en) = aimag(z3)
   end do
!
end do
!     ********** END BACKSUBSTITUTION **********
enm1 = n - 1
!     ********** VECTORS OF ISOLATED ROOTS **********
do 840 i = 1, enm1
   if (i .ge. low .and. i .le. igh) go to 840
   ip1 = i + 1
!
   do j = ip1, n
      zr(i,j) = hr(i,j)
      zi(i,j) = hi(i,j)
   end do
!
840 continue
!     ********** MULTIPLY BY TRANSFORMATION MATRIX TO GIVE
!                vectors of original full matrix.
!                FOR j=n STEP -1 UNTIL low+1 DO -- **********
do 880 jj = low, enm1
   j = n + low - jj
   m = min0(j-1,igh)
!
   do 880 i = low, igh
      zzr = zr(i,j)
      zzi = zi(i,j)
!
      do k = low, m
         zzr = zzr + zr(i,k) * hr(k,j) - zi(i,k) * hi(k,j)
         zzi = zzi + zr(i,k) * hi(k,j) + zi(i,k) * hr(k,j)
      end do
!
      zr(i,j) = zzr
      zi(i,j) = zzi
880 continue
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
1000 ierr = en
1001 return
!     ********** LAST CARD OF comqr2 **********
end subroutine comqr2

subroutine dceig(ibal,ar,ai,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, low
!-----------------------------------------------------------------------
!            Eigenvalues of double precision complex matrices
!-----------------------------------------------------------------------
double precision, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), &
&wi(n)
!
low = 1
igh = n
if (ibal .ne. 0) call dcbal(ka,n,ar,ai,low,igh,wr)
call dcorth(ka,n,low,igh,ar,ai,wr,wi)
call dcomqr(ka,n,low,igh,ar,ai,wr,wi,ierr)
return
end subroutine dceig

subroutine dceigv (ibal,ar,ai,ka,n,wr,wi,zr,zi,ierr,temp)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: i1, i2, i3, igh, low
!-----------------------------------------------------------------------
!                     Eigenvalues and eigenvectors
!                 of double precision complex matrices
!-----------------------------------------------------------------------
double precision, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), &
&wi(n), zr(ka,n), zi(ka,n), temp(*)
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
if (ibal .ne. 0) call dcbal(ka,n,ar,ai,low,igh,temp(i1))
call dcorth(ka,n,low,igh,ar,ai,temp(i2),temp(i3))
call dcmqr2(ka,n,low,igh,temp(i2),temp(i3),ar,ai,wr,wi, &
&zr,zi,ierr)
if (ierr .ne. 0) return
if (ibal .ne. 0) call dcbabk(ka,n,low,igh,temp(i1),n,zr,zi)
return
end subroutine dceigv

subroutine dcbal(nm,n,ar,ai,low,igh,scale)
implicit none
integer :: ipmpar
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: jj
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
integer :: iexc
double precision, intent(inout) :: ar(nm,n), ai(nm,n), scale(n)
double precision :: c, f, g, r, s, b2, radix
logical :: noconv
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure
!     CBALANCE, which is a complex version of balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!
!     dcbal balances a double precision complex matrix and
!     isolates eigenvalues whenever possible.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex matrix to be balanced.
!
!     On output-
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the balanced matrix,
!
!        Low and igh are two integers such that ar(i,j) and ai(i,j)
!          are equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!
!        Scale contains information determining the
!           permutations and scaling factors used.
!
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j)       j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!
!     Note that 1 is returned for igh if igh is zero formally.
!
!     The Algol procedure exc contained in CBALANCE appears in
!     dcbal in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!
!-----------------------------------------------------------------------
!
!     ********** radix IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the base of the machine floating point representation.
!
           radix = ipmpar(4)
!
!                **********
!
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** IN-LINE PROCEDURE FOR ROW AND
!                COLUMN EXCHANGE **********
20 scale(m) = j
if (j .eq. m) go to 50
!
do i = 1, l
   f = ar(i,j)
   ar(i,j) = ar(i,m)
   ar(i,m) = f
   f = ai(i,j)
   ai(i,j) = ai(i,m)
   ai(i,m) = f
end do
!
do i = k, n
   f = ar(j,i)
   ar(j,i) = ar(m,i)
   ar(m,i) = f
   f = ai(j,i)
   ai(j,i) = ai(m,i)
   ai(m,i) = f
end do
!
50 go to (80,130), iexc
!     ********** SEARCH FOR ROWS ISOLATING AN EIGENVALUE
!                AND PUSH THEM DOWN **********
80 if (l .eq. 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do 120 jj = 1, l
   j = l + 1 - jj
!
   do 110 i = 1, l
      if (i .eq. j) go to 110
      if (ar(j,i) .ne. 0.d0 .or. ai(j,i) .ne. 0.d0) go to 120
110 continue
!
   m = l
   iexc = 1
   go to 20
120 continue
!
go to 140
!     ********** SEARCH FOR COLUMNS ISOLATING AN EIGENVALUE
!                AND PUSH THEM LEFT **********
130 k = k + 1
!
140 do 170 j = k, l
!
   do 150 i = k, l
      if (i .eq. j) go to 150
      if (ar(i,j) .ne. 0.d0 .or. ai(i,j) .ne. 0.d0) go to 170
150 continue
!
   m = k
   iexc = 2
   go to 20
170 continue
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS k TO l **********
do 180 i = k, l
180 scale(i) = 1.d0
!     ********** ITERATIVE LOOP FOR NORM REDUCTION **********
190 noconv = .false.
!
do 270 i = k, l
   c = 0.d0
   r = 0.d0
!
   do 200 j = k, l
      if (j .eq. i) go to 200
      c = c + dabs(ar(j,i)) + dabs(ai(j,i))
      r = r + dabs(ar(i,j)) + dabs(ai(i,j))
200 continue
!     ********** GUARD AGAINST ZERO c OR r DUE TO UNDERFLOW **********
   if (c .eq. 0.d0 .or. r .eq. 0.d0) go to 270
   g = r / radix
   f = 1.d0
   s = c + r
210 if (c .ge. g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c .lt. g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** NOW BALANCE **********
240 if ((c + r) / f .ge. 0.95d0 * s) go to 270
   g = 1.d0 / f
   scale(i) = scale(i) * f
   noconv = .true.
!
   do j = k, n
      ar(i,j) = ar(i,j) * g
      ai(i,j) = ai(i,j) * g
   end do
!
   do j = 1, l
      ar(j,i) = ar(j,i) * f
      ai(j,i) = ai(j,i) * f
   end do
!
270 continue
!
if (noconv) go to 190
!
280 low = k
igh = l
return
!     ********** LAST CARD OF dcbal **********
end subroutine dcbal

subroutine dcorth(nm,n,low,igh,ar,ai,ortr,orti)
implicit none
!
integer :: i, j, m
integer, intent(in) :: n
integer :: ii, jj, la, mp
integer, intent(in) :: nm, igh
integer :: kp1
integer, intent(in) :: low
double precision, intent(inout) :: ar(nm,n), ai(nm,n), ortr(igh), &
&orti(igh)
double precision :: f, g, h, fi, fr, scale
double precision :: dcpabs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of a complex analogue of
!     the Algol procedure orthes, NUM. Math. 12, 349-368(1968)
!     by Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!
!     Given a double precision complex matrix, dcorth
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     unitary similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          SET low=1, igh=n,
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the complex input matrix.
!
!     On output-
!
!        ar and ai contain the real and imaginary parts,
!          respectively, of the Hessenberg matrix.  Information
!          about the unitary transformations used in the reduction
!          is stored in the remaining triangles under the
!          Hessenberg matrix,
!
!        ortr and ORTI contain further information about the
!          transformations.  Only elements low through igh are used.
!
!-----------------------------------------------------------------------
la = igh - 1
kp1 = low + 1
if (la .lt. kp1) go to 200
!
do 180 m = kp1, la
   h = 0.d0
   ortr(m) = 0.d0
   orti(m) = 0.d0
   scale = 0.d0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + dabs(ar(i,m-1)) + dabs(ai(i,m-1))
!
   if (scale .eq. 0.d0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ortr(i) = ar(i,m-1) / scale
      orti(i) = ai(i,m-1) / scale
      h = h + ortr(i) * ortr(i) + orti(i) * orti(i)
   end do
!
   g = dsqrt(h)
   f = dcpabs(ortr(m),orti(m))
   if (f .eq. 0.d0) go to 103
   h = h + f * g
   g = g / f
   ortr(m) = (1.d0 + g) * ortr(m)
   orti(m) = (1.d0 + g) * orti(m)
   go to 105
!
103 ortr(m) = g
   ar(m,m-1) = scale
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
!
      fr = fr / h
      fi = fi / h
!
      do i = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(i) + fi * orti(i)
         ai(i,j) = ai(i,j) - fr * orti(i) - fi * ortr(i)
      end do
!
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
!
      fr = fr / h
      fi = fi / h
!
      do j = m, igh
         ar(i,j) = ar(i,j) - fr * ortr(j) - fi * orti(j)
         ai(i,j) = ai(i,j) + fr * orti(j) - fi * ortr(j)
      end do
!
   end do
!
   ortr(m) = scale * ortr(m)
   orti(m) = scale * orti(m)
   ar(m,m-1) = -g * ar(m,m-1)
   ai(m,m-1) = -g * ai(m,m-1)
180 continue
!
200 return
!     ********** LAST CARD OF dcorth **********
end subroutine dcorth

subroutine dcomqr(nm,n,low,igh,hr,hi,wr,wi,ierr)
implicit none
!
integer :: i, j, l
integer, intent(in) :: n
integer :: en, ll
integer, intent(in) :: nm, igh
integer :: its
integer, intent(in) :: low
integer :: lp1, enm1
integer, intent(out) :: ierr
double precision, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), &
&wi(n)
double precision :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, &
&norm, machep
double precision :: r2, w(2), z(2)
double precision :: dpmpar, dcpabs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR, NUM. Math. 12, 369-376(1968) By Martin
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 396-403(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!
!     This subroutine finds the eigenvalues of a double precision
!     complex upper Hessenberg matrix BY the QR method.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          SET low=1, igh=n,
!
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain
!          information about the unitary transformations used in
!          the reduction by dcorth, if performed.
!
!     On output-
!
!        The upper Hessenberg portions of hr and hi have been
!          destroyed.  Therefore, they must be saved before
!          calling dcomqr if subsequent calculation of
!          eigenvectors is to be performed,
!
!        wr and WI contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the relative precision of floating point arithmetic.
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
if (low .eq. igh) go to 180
!     ********** CREATE REAL SUBDIAGONAL ELEMENTS **********
l = low + 1
!
do 170 i = l, igh
   ll = min0(i+1,igh)
   if (hi(i,i-1) .eq. 0.d0) go to 170
   norm = dcpabs(hr(i,i-1),hi(i,i-1))
   yr = hr(i,i-1) / norm
   yi = hi(i,i-1) / norm
   hr(i,i-1) = norm
   hi(i,i-1) = 0.d0
!
   do j = i, igh
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
!
   do j = low, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
!
170 continue
!     ********** STORE ROOTS ISOLATED BY dcbal **********
180 do 200 i = 1, n
   if (i .ge. low .and. i .le. igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
!
en = igh
tr = 0.d0
ti = 0.d0
!     ********** SEARCH FOR NEXT EIGENVALUE **********
220 if (en .lt. low) go to 1001
its = 0
enm1 = en - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL low  -- **********
240 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 300
   if (dabs(hr(l,l-1)) .le. &
&machep * (dabs(hr(l-1,l-1)) + dabs(hi(l-1,l-1)) &
&+ dabs(hr(l,l)) + dabs(hi(l,l)))) go to 300
end do
!     ********** FORM SHIFT **********
300 if (l .eq. en) go to 660
if (its .eq. 50) go to 1000
if (its .eq. 10 .or. its .eq. 20 .or. its .eq. 30) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr .eq. 0.d0 .and. xi .eq. 0.d0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.d0
yi = (hi(enm1,enm1) - si) / 2.d0
z(1) = yr*yr - yi*yi + xr
z(2) = 2.d0*yr*yi + xi
call dcsqrt(z,w)
zzr = w(1)
zzi = w(2)
if (yr * zzr + yi * zzi .ge. 0.d0) go to 310
zzr = -zzr
zzi = -zzi
310 z(1) = yr + zzr
z(2) = yi + zzi
r2 = z(1)**2 + z(2)**2
sr = sr - (xr*z(1) + xi*z(2))/r2
si = si - (xi*z(1) - xr*z(2))/r2
go to 340
!     ********** FORM EXCEPTIONAL SHIFT **********
320 sr = dabs(hr(en,enm1)) + dabs(hr(enm1,en-2))
si = 0.d0
!
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
!
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** REDUCE TO TRIANGLE (ROWS) **********
lp1 = l + 1
!
do i = lp1, en
   sr = hr(i,i-1)
   hr(i,i-1) = 0.d0
   norm = dsqrt(hr(i-1,i-1)*hr(i-1,i-1)+hi(i-1,i-1)*hi(i-1,i-1) &
&+ sr*sr)
   xr = hr(i-1,i-1) / norm
   wr(i-1) = xr
   xi = hi(i-1,i-1) / norm
   wi(i-1) = xi
   hr(i-1,i-1) = norm
   hi(i-1,i-1) = 0.d0
   hi(i,i-1) = sr / norm
!
   do j = i, en
      yr = hr(i-1,j)
      yi = hi(i-1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i-1,j) = xr * yr + xi * yi + hi(i,i-1) * zzr
      hi(i-1,j) = xr * yi - xi * yr + hi(i,i-1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i-1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i-1) * yi
   end do
!
end do
!
si = hi(en,en)
if (si .eq. 0.d0) go to 540
norm = dcpabs(hr(en,en),si)
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.d0
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j-1)
   xi = wi(j-1)
!
   do i = l, j
      yr = hr(i,j-1)
      yi = 0.d0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i .eq. j) go to 560
      yi = hi(i,j-1)
      hi(i,j-1) = xr * yi + xi * yr + hi(j,j-1) * zzi
560 hr(i,j-1) = xr * yr - xi * yi + hi(j,j-1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j-1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j-1) * yi
   end do
!
end do
!
if (si .eq. 0.d0) go to 240
!
do i = l, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
!
go to 240
!     ********** A ROOT FOUND **********
660 wr(en) = hr(en,en) + tr
wi(en) = hi(en,en) + ti
en = enm1
go to 220
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
1000 ierr = en
1001 return
end subroutine dcomqr

subroutine dcbabk (nm,n,low,igh,scale,m,zr,zi)
implicit none
!
integer :: i, j, k
integer, intent(in) :: m, n
integer :: ii
integer, intent(in) :: nm, igh, low
double precision, intent(in) :: scale(n)
double precision, intent(inout) :: zr(nm,m), zi(nm,m)
double precision :: s
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure
!     cbabk2, which is a complex version of balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!
!     This subroutine forms the eigenvectors of a double precision
!     complex matrix BY back transforming those of the corresponding
!     balanced matrix determined by dcbal.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by dcbal,
!
!        Scale contains information determining the permutations
!          and scaling factors used by dcbal,
!
!        m is the number of eigenvectors to be back transformed,
!
!        zr and zi contain the real and imaginary parts,
!          respectively, of the eigenvectors to be
!          back transformed in their first m columns.
!
!     On output-
!
!        zr and zi contain the real and imaginary parts,
!          respectively, of the transformed eigenvectors
!          in their first m columns.
!
!-----------------------------------------------------------------------
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
!
end do
!
!     ********** FOR i=low-1 STEP -1 UNTIL 1,
!                igh+1 STEP 1 UNTIL n DO -- **********
120 do 140 ii = 1, n
   i = ii
   if (i .ge. low .and. i .le. igh) go to 140
   if (i .lt. low) i = low - ii
   k = scale(i)
   if (k .eq. i) go to 140
!
   do j = 1, m
      s = zr(i,j)
      zr(i,j) = zr(k,j)
      zr(k,j) = s
      s = zi(i,j)
      zi(i,j) = zi(k,j)
      zi(k,j) = s
   end do
!
140 continue
!
200 return
!     ********** LAST CARD OF dcbabk **********
end subroutine dcbabk

subroutine dcmqr2 (nm,n,low,igh,ortr,orti,hr,hi,wr,wi,zr,zi,ierr)
implicit none
!
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ii, jj, ll
integer, intent(in) :: nm
integer :: nn
integer, intent(in) :: igh
integer :: ip1, its
integer, intent(in) :: low
integer :: lp1, enm1, iend
integer, intent(out) :: ierr
double precision, intent(inout) :: hr(nm,n), hi(nm,n), wr(n), &
&wi(n), zr(nm,n), zi(nm,n), ortr(igh), orti(igh)
double precision :: si, sr, ti, tr, xi, xr, yi, yr, zzi, zzr, &
&norm, machep
double precision :: r2, w(2), z(2)
double precision :: dpmpar, dcpabs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of a unitary analogue of the
!     Algol procedure  COMLR2, NUM. Math. 16, 181-204(1970) By peters
!     and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!     The unitary analogue substitutes the QR algorithm of Francis
!     (comp. Jour. 4, 332-345(1962)) For the LR algorithm.
!
!     This subroutine finds the eigenvalues and eigenvectors of
!     a double precision complex upper Hessenberg matrix BY the
!     QR method.  The eigenvectors of a complex general matrix
!     can also be found if dcorth has been used to reduce
!     this general matrix to Hessenberg form.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dcbal.  If dcbal has not been used,
!          SET low=1, igh=n,
!
!        ORTR and ORTI contain information about the unitary trans-
!          formations used in the reduction by dcorth, if performed.
!          Only elements low through igh are used.  If the eigenvectors
!          of the Hessenberg matrix are desired, set ORTR(j) and
!          ORTI(j) to 0.0 for these elements,
!
!        hr and hi contain the real and imaginary parts,
!          respectively, of the complex upper Hessenberg matrix.
!          Their lower triangles below the subdiagonal contain further
!          information about the transformations which were used in the
!          reduction by dcorth, if performed.  If the eigenvectors of
!          the Hessenberg matrix are desired, these elements may be
!          arbitrary.
!
!     On output-
!
!        ORTR, ORTI, and the upper Hessenberg portions of hr and hi
!          have been destroyed,
!
!        wr and WI contain the real and imaginary parts,
!          respectively, of the eigenvalues.  If an error
!          exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        ZR and ZI contain the real and imaginary parts,
!          respectively, of the eigenvectors.  The eigenvectors
!          are unnormalized.  If an error exit is made, none of
!          the eigenvectors has been found,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                the relative precision of floating point arithmetic.
!
           machep = dpmpar(1)
!
!                **********
!
ierr = 0
!     ********** INITIALIZE EIGENVECTOR MATRIX **********
do 100 i = 1, n
!
   do 100 j = 1, n
      zr(i,j) = 0.d0
      zi(i,j) = 0.d0
      if (i .eq. j) zr(i,j) = 1.d0
100 continue
!     ********** FORM THE MATRIX OF ACCUMULATED TRANSFORMATIONS
!                FROM THE INFORMATION LEFT BY dcorth **********
iend = igh - low - 1
if (iend) 180, 150, 105
!     ********** FOR i=igh-1 STEP -1 UNTIL low+1 DO -- **********
105 do 140 ii = 1, iend
   i = igh - ii
   if (ortr(i) .eq. 0.d0 .and. orti(i) .eq. 0.d0) go to 140
   if (hr(i,i-1) .eq. 0.d0 .and. hi(i,i-1) .eq. 0.d0) go to 140
!     ********** NORM BELOW IS NEGATIVE OF H FORMED IN dcorth **********
   norm = hr(i,i-1) * ortr(i) + hi(i,i-1) * orti(i)
   ip1 = i + 1
!
   do k = ip1, igh
      ortr(k) = hr(k,i-1)
      orti(k) = hi(k,i-1)
   end do
!
   do j = i, igh
      sr = 0.d0
      si = 0.d0
!
      do k = i, igh
         sr = sr + ortr(k) * zr(k,j) + orti(k) * zi(k,j)
         si = si + ortr(k) * zi(k,j) - orti(k) * zr(k,j)
      end do
!
      sr = sr / norm
      si = si / norm
!
      do k = i, igh
         zr(k,j) = zr(k,j) + sr * ortr(k) - si * orti(k)
         zi(k,j) = zi(k,j) + sr * orti(k) + si * ortr(k)
      end do
!
   end do
!
140 continue
!     ********** CREATE REAL SUBDIAGONAL ELEMENTS **********
150 l = low + 1
!
do 170 i = l, igh
   ll = min0(i+1,igh)
   if (hi(i,i-1) .eq. 0.d0) go to 170
   norm = dcpabs(hr(i,i-1),hi(i,i-1))
   yr = hr(i,i-1) / norm
   yi = hi(i,i-1) / norm
   hr(i,i-1) = norm
   hi(i,i-1) = 0.d0
!
   do j = i, n
      si = yr * hi(i,j) - yi * hr(i,j)
      hr(i,j) = yr * hr(i,j) + yi * hi(i,j)
      hi(i,j) = si
   end do
!
   do j = 1, ll
      si = yr * hi(j,i) + yi * hr(j,i)
      hr(j,i) = yr * hr(j,i) - yi * hi(j,i)
      hi(j,i) = si
   end do
!
   do j = low, igh
      si = yr * zi(j,i) + yi * zr(j,i)
      zr(j,i) = yr * zr(j,i) - yi * zi(j,i)
      zi(j,i) = si
   end do
!
170 continue
!     ********** STORE ROOTS ISOLATED BY dcbal **********
180 do 200 i = 1, n
   if (i .ge. low .and. i .le. igh) go to 200
   wr(i) = hr(i,i)
   wi(i) = hi(i,i)
200 continue
!
en = igh
tr = 0.d0
ti = 0.d0
!     ********** SEARCH FOR NEXT EIGENVALUE **********
220 if (en .lt. low) go to 680
its = 0
enm1 = en - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
240 do ll = low, en
   l = en + low - ll
   if (l .eq. low) go to 300
   if (dabs(hr(l,l-1)) .le. &
&machep * (dabs(hr(l-1,l-1)) + dabs(hi(l-1,l-1)) &
&+ dabs(hr(l,l)) + dabs(hi(l,l)))) go to 300
end do
!     ********** FORM SHIFT **********
300 if (l .eq. en) go to 660
if (its .eq. 50) go to 1000
if (its .eq. 10 .or. its .eq. 20 .or. its .eq. 30) go to 320
sr = hr(en,en)
si = hi(en,en)
xr = hr(enm1,en) * hr(en,enm1)
xi = hi(enm1,en) * hr(en,enm1)
if (xr .eq. 0.d0 .and. xi .eq. 0.d0) go to 340
yr = (hr(enm1,enm1) - sr) / 2.d0
yi = (hi(enm1,enm1) - si) / 2.d0
z(1) = yr*yr - yi*yi + xr
z(2) = 2.d0*yr*yi + xi
call dcsqrt(z,w)
zzr = w(1)
zzi = w(2)
if (yr * zzr + yi * zzi .ge. 0.d0) go to 310
zzr = -zzr
zzi = -zzi
310 z(1) = yr + zzr
z(2) = yi + zzi
r2 = z(1)**2 + z(2)**2
sr = sr - (xr*z(1) + xi*z(2))/r2
si = si - (xi*z(1) - xr*z(2))/r2
go to 340
!     ********** FORM EXCEPTIONAL SHIFT **********
320 sr = dabs(hr(en,enm1)) + dabs(hr(enm1,en-2))
si = 0.d0
!
340 do i = low, en
   hr(i,i) = hr(i,i) - sr
   hi(i,i) = hi(i,i) - si
end do
!
tr = tr + sr
ti = ti + si
its = its + 1
!     ********** REDUCE TO TRIANGLE (ROWS) **********
lp1 = l + 1
!
do i = lp1, en
   sr = hr(i,i-1)
   hr(i,i-1) = 0.d0
   norm = dsqrt(hr(i-1,i-1)*hr(i-1,i-1)+hi(i-1,i-1)*hi(i-1,i-1) &
&+ sr*sr)
   xr = hr(i-1,i-1) / norm
   wr(i-1) = xr
   xi = hi(i-1,i-1) / norm
   wi(i-1) = xi
   hr(i-1,i-1) = norm
   hi(i-1,i-1) = 0.d0
   hi(i,i-1) = sr / norm
!
   do j = i, n
      yr = hr(i-1,j)
      yi = hi(i-1,j)
      zzr = hr(i,j)
      zzi = hi(i,j)
      hr(i-1,j) = xr * yr + xi * yi + hi(i,i-1) * zzr
      hi(i-1,j) = xr * yi - xi * yr + hi(i,i-1) * zzi
      hr(i,j) = xr * zzr - xi * zzi - hi(i,i-1) * yr
      hi(i,j) = xr * zzi + xi * zzr - hi(i,i-1) * yi
   end do
!
end do
!
si = hi(en,en)
if (si .eq. 0.d0) go to 540
norm = dcpabs(hr(en,en),si)
sr = hr(en,en) / norm
si = si / norm
hr(en,en) = norm
hi(en,en) = 0.d0
if (en .eq. n) go to 540
ip1 = en + 1
!
do j = ip1, n
   yr = hr(en,j)
   yi = hi(en,j)
   hr(en,j) = sr * yr + si * yi
   hi(en,j) = sr * yi - si * yr
end do
!     ********** INVERSE OPERATION (COLUMNS) **********
540 do j = lp1, en
   xr = wr(j-1)
   xi = wi(j-1)
!
   do i = 1, j
      yr = hr(i,j-1)
      yi = 0.d0
      zzr = hr(i,j)
      zzi = hi(i,j)
      if (i .eq. j) go to 560
      yi = hi(i,j-1)
      hi(i,j-1) = xr * yi + xi * yr + hi(j,j-1) * zzi
560 hr(i,j-1) = xr * yr - xi * yi + hi(j,j-1) * zzr
      hr(i,j) = xr * zzr + xi * zzi - hi(j,j-1) * yr
      hi(i,j) = xr * zzi - xi * zzr - hi(j,j-1) * yi
   end do
!
   do i = low, igh
      yr = zr(i,j-1)
      yi = zi(i,j-1)
      zzr = zr(i,j)
      zzi = zi(i,j)
      zr(i,j-1) = xr * yr - xi * yi + hi(j,j-1) * zzr
      zi(i,j-1) = xr * yi + xi * yr + hi(j,j-1) * zzi
      zr(i,j) = xr * zzr + xi * zzi - hi(j,j-1) * yr
      zi(i,j) = xr * zzi - xi * zzr - hi(j,j-1) * yi
   end do
!
end do
!
if (si .eq. 0.d0) go to 240
!
do i = 1, en
   yr = hr(i,en)
   yi = hi(i,en)
   hr(i,en) = sr * yr - si * yi
   hi(i,en) = sr * yi + si * yr
end do
!
do i = low, igh
   yr = zr(i,en)
   yi = zi(i,en)
   zr(i,en) = sr * yr - si * yi
   zi(i,en) = sr * yi + si * yr
end do
!
go to 240
!     ********** A ROOT FOUND **********
660 hr(en,en) = hr(en,en) + tr
wr(en) = hr(en,en)
hi(en,en) = hi(en,en) + ti
wi(en) = hi(en,en)
en = enm1
go to 220
!     ********** ALL ROOTS FOUND.  BACKSUBSTITUTE TO FIND
!                VECTORS OF UPPER TRIANGULAR FORM **********
680 norm = 0.d0
!
do 720 i = 1, n
!
   do 720 j = i, n
      norm = norm + dabs(hr(i,j)) + dabs(hi(i,j))
720 continue
!
if (n .eq. 1 .or. norm .eq. 0.d0) go to 1001
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
      if (i .eq. enm1) go to 760
      ip1 = i + 1
!
      do j = ip1, enm1
         zzr = zzr + hr(i,j) * hr(j,en) - hi(i,j) * hi(j,en)
         zzi = zzi + hr(i,j) * hi(j,en) + hi(i,j) * hr(j,en)
      end do
!
760 yr = xr - wr(i)
      yi = xi - wi(i)
      if (yr .eq. 0.d0 .and. yi .eq. 0.d0) yr = machep * norm
      r2 = yr*yr + yi*yi
      hr(i,en) = (zzr*yr + zzi*yi)/r2
      hi(i,en) = (zzi*yr - zzr*yi)/r2
   end do
!
end do
!     ********** END BACKSUBSTITUTION **********
enm1 = n - 1
!     ********** VECTORS OF ISOLATED ROOTS **********
do 840 i = 1, enm1
   if (i .ge. low .and. i .le. igh) go to 840
   ip1 = i + 1
!
   do j = ip1, n
      zr(i,j) = hr(i,j)
      zi(i,j) = hi(i,j)
   end do
!
840 continue
!     ********** MULTIPLY BY TRANSFORMATION MATRIX TO GIVE
!                vectors of original full matrix.
!                FOR j=n STEP -1 UNTIL low+1 DO -- **********
do 880 jj = low, enm1
   j = n + low - jj
   m = min0(j-1,igh)
!
   do 880 i = low, igh
      zzr = zr(i,j)
      zzi = zi(i,j)
!
      do k = low, m
         zzr = zzr + zr(i,k) * hr(k,j) - zi(i,k) * hi(k,j)
         zzi = zzi + zr(i,k) * hi(k,j) + zi(i,k) * hr(k,j)
      end do
!
      zr(i,j) = zzr
      zi(i,j) = zzi
880 continue
!
go to 1001
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
1000 ierr = en
1001 return
!     ********** LAST CARD OF dcmqr2 **********
end subroutine dcmqr2

subroutine cl1(k, l, m, n, q, kq, kode, toler, iter, x, res, &
&error, wk, iwk)
implicit none
integer, intent(inout) :: iter, iwk(*)
integer, intent(in) :: k
integer, intent(inout) :: kode
integer, intent(in) :: kq, l, m, n
real, intent(inout) :: error, q(kq,*), res(*)
real, intent(in) :: toler
real, intent(inout) :: wk(*), x(*)
integer :: klm
!     -------------------
klm = k + l + m
call xl1(k, l, m, n, klm, kq, klm + n, n + 2, q, kode, toler, &
&iter, x, res, error, wk, iwk(klm+1), iwk(1))
return
end subroutine cl1

subroutine xl1(k, l, m, n, klmd, klm2d, nklmd, n2d, &
&q, kode, toler, iter, x, res, error, cu, iu, s)
implicit none
!
! This subroutine uses a modification of the simplex
! method of linear programming to calculate an L1 solution
! to A k by n system of linear equations
!             ax=b
! subject to l linear equality constraints
!             cx=d
! and m linear inequality constraints
!             EX.LE.F.
! Description of parameters
! k      NUMBER OF ROWS OF THE MATRIX A (k.GE.1).
! l      NUMBER OF ROWS OF THE MATRIX C (l.GE.0).
! m      NUMBER OF ROWS OF THE MATRIX E (m.GE.0).
! n      NUMBER OF COLUMNS OF THE MATRICES A,C,E (n.GE.1).
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
!        EXPLICITLY IN THE CONSTRAINTS EX.LE.F, THEN kode
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
!        EVIDENCE SUGGESTS toler = 10**(-D*2/3),
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
!        SOLUTION TO THE L1 PROBLEM. IF kode=1
!        on entry, this array is also used to include
!        simple nonnegativity constraints on the
!        variables. The values -1, 0, or 1
!        for x(j) indicate that the j-TH variable
!        IS RESTRICTED TO BE .LE.0, UNRESTRICTED,
!        OR .GE.0 RESPECTIVELY.
! RES    ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST klmd.
!        On exit this contains the residuals B-AX
!        in the first k components, D-CX in the
!        NEXT l COMPONENTS (THESE WILL BE =0),AND
!        F-EX IN THE NEXT m COMPONENTS. IF kode=1 ON
!        entry, this array is also used to include simple
!        nonnegativity constraints on the residuals
!        B-AX. The values -1, 0, or 1 for res(i)
!        INDICATE THAT THE i-TH RESIDUAL (1.le.i.le.k) IS
!        RESTRICTED TO BE .LE.0, UNRESTRICTED, OR .GE.0
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
!
double precision :: sum
real, intent(inout) :: q, x
real :: z
real, intent(inout) :: cu
real :: sn, zu, zv, cuv
real, intent(inout) :: res
real :: xmax, xmin
real, intent(inout) :: error
real :: pivot
real, intent(in) :: toler
real :: tpivot
integer :: i, j
integer, intent(in) :: k, l, m, n
integer, intent(inout) :: s
integer :: ia, ii, in
integer, intent(inout) :: iu
integer :: js, kk, nk, n1, n2, jmn, jpn, klm, nkl, nk1
integer, intent(in) :: n2d
integer :: iimn, iout
integer, intent(inout) :: iter
integer, intent(in) :: klmd
integer :: klm1, klm2
integer, intent(inout) :: kode
integer :: nklm, nkl1
integer, intent(in) :: klm2d
integer :: maxit
integer, intent(in) :: nklmd
integer :: iphase, kforce, iineg
dimension q(klm2d,n2d), x(n2d), res(klmd), &
&cu(2,nklmd), iu(2,nklmd), s(klmd)
!
! Initialization.
!
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
do j=1,n
   q(klm2,j) = j
end do
do 30 i = 1,klm
   q(i,n2) = n + i
   if (q(i,n1).ge.0.) go to 30
   do j=1,n2
      q(i,j) = -q(i,j)
   end do
30 continue
! Set up phase 1 costs.
iphase = 2
do j=1,nklm
   cu(1,j) = 0.
   cu(2,j) = 0.
   iu(1,j) = 0
   iu(2,j) = 0
end do
if (l.eq.0) go to 60
do j=nk1,nkl
   cu(1,j) = 1.
   cu(2,j) = 1.
   iu(1,j) = 1
   iu(2,j) = 1
end do
iphase = 1
60 if (m.eq.0) go to 80
do j=nkl1,nklm
   cu(2,j) = 1.
   iu(2,j) = 1
   jmn = j - n
   if (q(jmn,n2).lt.0.) iphase = 1
end do
80 if (kode.eq.0) go to 150
do 110 j = 1,n
   if (x(j)) 90, 110, 100
90 cu(1,j) = 1.
   iu(1,j) = 1
   go to 110
100 cu(2,j) = 1.
   iu(2,j) = 1
110 continue
do 140 j = 1,k
   jpn = j + n
   if (res(j)) 120, 140, 130
120 cu(1,jpn) = 1.
   iu(1,jpn) = 1
   if (q(j,n2).gt.0.0) iphase = 1
   go to 140
130 cu(2,jpn) = 1.
   iu(2,jpn) = 1
   if (q(j,n2).lt.0.0) iphase = 1
140 continue
150 if (iphase.eq.2) go to 500
! Compute the marginal costs.
160 do j=js,n1
   sum = 0.d0
   do i=1,klm
      ii = q(i,n2)
      if (ii.lt.0) go to 170
      z = cu(1,ii)
      go to 180
170 iineg = -ii
      z = cu(2,iineg)
180 sum = sum + dble(q(i,j))*dble(z)
   end do
   q(klm1,j) = sum
end do
do j=js,n
   ii = q(klm2,j)
   if (ii.lt.0) go to 210
   z = cu(1,ii)
   go to 220
210 iineg = -ii
   z = cu(2,iineg)
220 q(klm1,j) = q(klm1,j) - z
end do
! Determine the vector to enter the basis.
240 xmax = 0.
if (js.gt.n) go to 490
do 280 j = js,n
   zu = q(klm1,j)
   ii = q(klm2,j)
   if (ii.gt.0) go to 250
   ii = -ii
   zv = zu
   zu = -zu - cu(1,ii) - cu(2,ii)
   go to 260
250 zv = -zu - cu(1,ii) - cu(2,ii)
260 if (kforce.eq.1 .and. ii.gt.n) go to 280
   if (iu(1,ii).eq.1) go to 270
   if (zu.le.xmax) go to 270
   xmax = zu
   in = j
270 if (iu(2,ii).eq.1) go to 280
   if (zv.le.xmax) go to 280
   xmax = zv
   in = j
280 continue
if (xmax.le.toler) go to 490
if (q(klm1,in).eq.xmax) go to 300
do i=1,klm2
   q(i,in) = -q(i,in)
end do
q(klm1,in) = xmax
! Determine the vector to leave the basis.
300 if (iphase.eq.1 .or. ia.eq.0) go to 330
xmax = 0.
do 310 i = 1,ia
   z = abs(q(i,in))
   if (z.le.xmax) go to 310
   xmax = z
   iout = i
310 continue
if (xmax.le.toler) go to 330
do j=1,n2
   z = q(ia,j)
   q(ia,j) = q(iout,j)
   q(iout,j) = z
end do
iout = ia
ia = ia - 1
pivot = q(iout,in)
go to 420
330 kk = 0
do 340 i = 1,klm
   z = q(i,in)
   if (z.le.toler) go to 340
   kk = kk + 1
   res(kk) = q(i,n1)/z
   s(kk) = i
340 continue
350 if (kk.gt.0) go to 360
kode = 2
go to 590
360 xmin = res(1)
iout = s(1)
j = 1
if (kk.eq.1) go to 380
do 370 i = 2,kk
   if (res(i).ge.xmin) go to 370
   j = i
   xmin = res(i)
   iout = s(i)
370 continue
res(j) = res(kk)
s(j) = s(kk)
380 kk = kk - 1
pivot = q(iout,in)
ii = q(iout,n2)
if (iphase.eq.1) go to 400
if (ii.lt.0) go to 390
if (iu(2,ii).eq.1) go to 420
go to 400
390 iineg = -ii
if (iu(1,iineg).eq.1) go to 420
400 ii = iabs(ii)
cuv = cu(1,ii) + cu(2,ii)
if (q(klm1,in)-pivot*cuv.le.toler) go to 420
! Bypass intermediate vertices.
do j=js,n1
   z = q(iout,j)
   q(klm1,j) = q(klm1,j) - z*cuv
   q(iout,j) = -z
end do
q(iout,n2) = -q(iout,n2)
go to 350
! Gauss-Jordan elimination.
420 if (iter.lt.maxit) go to 430
kode = 3
go to 590
430 iter = iter + 1
do j=js,n1
   if (j.ne.in) q(iout,j) = q(iout,j)/pivot
end do
! If permitted, use subroutine col of the description
! section and replace the following seven statements down
! to and including statement number 460 by..
!     do 460 j=js,n1
!        if(j .eq. in) go to 460
!        z = -q(iout,j)
!        call col(q(1,j), q(1,in), z, iout, klm1)
! 460 continue
do 460 j = js,n1
   if (j.eq.in) go to 460
   z = -q(iout,j)
   do i=1,klm1
      if (i.ne.iout) q(i,j) = q(i,j) + z*q(i,in)
   end do
460 continue
tpivot = -pivot
do i=1,klm1
   if (i.ne.iout) q(i,in) = q(i,in)/tpivot
end do
q(iout,in) = 1./pivot
z = q(iout,n2)
q(iout,n2) = q(klm2,in)
q(klm2,in) = z
ii = abs(z)
if (iu(1,ii).eq.0 .or. iu(2,ii).eq.0) go to 240
do i=1,klm2
   z = q(i,in)
   q(i,in) = q(i,js)
   q(i,js) = z
end do
js = js + 1
go to 240
! Test for optimality.
490 if (kforce.eq.0) go to 580
if (iphase.eq.1 .and. q(klm1,n1).le.toler) go to 500
kforce = 0
go to 240
! Set up phase 2 costs.
500 iphase = 2
do j=1,nklm
   cu(1,j) = 0.
   cu(2,j) = 0.
end do
do j=n1,nk
   cu(1,j) = 1.
   cu(2,j) = 1.
end do
do 560 i = 1,klm
   ii = q(i,n2)
   if (ii.gt.0) go to 530
   ii = -ii
   if (iu(2,ii).eq.0) go to 560
   cu(2,ii) = 0.
   go to 540
530 if (iu(1,ii).eq.0) go to 560
   cu(1,ii) = 0.
540 ia = ia + 1
   do j=1,n2
      z = q(ia,j)
      q(ia,j) = q(i,j)
      q(i,j) = z
   end do
560 continue
go to 160
570 if (q(klm1,n1).le.toler) go to 500
kode = 1
go to 590
580 if (iphase.eq.1) go to 570
! Prepare output.
kode = 0
590 sum = 0.d0
do j=1,n
   x(j) = 0.
end do
do i=1,klm
   res(i) = 0.
end do
do 640 i = 1,klm
   ii = q(i,n2)
   sn = 1.
   if (ii.gt.0) go to 620
   ii = -ii
   sn = -1.
620 if (ii.gt.n) go to 630
   x(ii) = sn*q(i,n1)
   go to 640
630 iimn = ii - n
   res(iimn) = sn*q(i,n1)
   if (ii.ge.n1 .and. ii.le.nk) sum = sum + &
&dble(q(i,n1))
640 continue
error = sum
return
end subroutine xl1

subroutine llsq(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: iwk
integer, intent(in) :: ka, kb, m, n, nb
real, intent(inout) :: a(ka,n), b(kb,nb), wk(n)
integer :: i, j, np1
real :: rnorm
dimension iwk(n)
logical :: exit
!     --------------
ierr = 0
if (1 .lt. n .and. n .le. m) go to 10
ierr = 1
return
!
10 np1 = n + 1
call ortho(m,n,a,ka,wk,iwk,exit)
if (exit) go to 20
ierr = 2
return
!
20 do 22 j = 1,nb
call orsol(m,n,a,ka,wk,iwk,b(1,j))
if (m .eq. n) go to 22
rnorm = 0.0
do 21 i = np1,m
21 rnorm = rnorm + b(i,j)*b(i,j)
b(np1,j) = sqrt(rnorm)
22 continue
return
end subroutine llsq

subroutine llsqmp(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(inout) :: iwk
integer, intent(in) :: ka, kb, m, n, nb
real :: a(ka,n)
real, intent(inout) :: b(kb,nb), wk(*)
integer :: i, j, lq, lr, ls, np1
real :: rnorm
dimension iwk(n)
logical :: exit
!     -------------------
!     dimension wk(mn + 2m + n)
!     -------------------
ierr = 0
if (1.lt.n .and. n.le.m) go to 10
ierr = 2
return
!
10 np1 = n + 1
lr = m + 1
ls = lr + m
lq = ls + n
!
call mcopy(m, n, a, ka, wk(lq), m)
call ortho(m, n, wk(lq), m, wk(ls), iwk, exit)
if (exit) go to 20
ierr = 3
return
!
20 do 31 j = 1,nb
do 21 i = 1,m
21 wk(i) = b(i,j)
call orsol(m, n, wk(lq), m, wk(ls), iwk, wk(1))
call orimp(m, n, a, ka, wk(lq), m, wk(ls), iwk, b(1,j), &
&wk(1), wk(lr), exit)
do 22 i = 1,n
22 b(i,j) = wk(i)
if (.not.exit) ierr = 1
if (m .eq. n) go to 31
!
rnorm = 0.0
do 30 i = np1,m
30 rnorm = rnorm + wk(i)*wk(i)
b(np1,j) = sqrt(rnorm)
31 continue
return
end subroutine llsqmp

subroutine ortho(m, n, qr, ms, s, ip, exit)
implicit none
integer, intent(inout) :: ip
integer, intent(in) :: m, ms, n
real, intent(inout) :: qr(ms,n), s(n)
integer :: i, j, jp, k, kj, nn
real :: ajj, sav, ss, y
!***********************************************************************
!      Identification
!        ortho - orthogonal transformation of a given general m by n
!                matrix A to upper triangular form
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        ortho computes an implicit orthogonal matrix Q and an explicit
!        upper triangular matrix R and a permutation matrix P satisfying
!        qr = PA GIVEN AN m BY n REAL MATRIX A.  ORTHO IS INTENDED FOR
!        use with the subroutine orsol to produce the least squares
!        SOLUTION OF THE EQUATION AX = B.
!      Control
!
!        dimension qr(ms,n), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call ortho(m, n, qr, ms, s, ip, exit)
!
!        Where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. n .LE. m).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             qr(i,j), i .LE. j, AND THE RELEVANT PARTS OF Q IN qr(i,j),
!             i .GT. j.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR in the calling program.
!        s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        ip   IS AN INTEGER OUTPUT ARRAY CONTAINING IN ip(i), i=1,...,n,
!             the images of the permutation corresponding to the PERMU-
!             TATION matrix P.
!        Exit is set to the value .True. If the rank of A is equal to n
!             and .False. Otherwise.
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
dimension ip(n)
logical, intent(out) :: exit
!
exit = .true.
nn = n
if (n .eq. m) nn = n - 1
do 80 j = 1, nn
  ip(j) = j
  jp = j + 1
  kj = j
!                                       Search for pivot in the j-TH
!                                       column and interchange rows.
  do k = jp, m
     if (abs(qr(k,j)) .gt. abs(qr(kj,j))) kj = k
  end do
  if (qr(kj,j) .eq. 0.0) go to 90
  if (kj .eq. j) go to 30
  ip(j) = kj
  do 20 i = j, n
     sav = qr(j,i)
     qr(j,i) = qr(kj,i)
20 qr(kj,i) = sav
!                                       Normalize the pivoting column
!                                       and find its norm.
30 ajj = qr(j,j)
  do 31 i = jp, m
31 qr(i,j) = qr(i,j)/ajj
  sav = 1.0
  do 40 i = jp, m
40 sav = sav + qr(i,j)*qr(i,j)
  s(j) = -sqrt(sav)
  qr(j,j) = s(j)*ajj
  if (jp .gt. n) go to 80
!                                       Premultiply QR with the j-TH
!                                       orthogonal matrix.
  y = 1.0 - s(j)
  do k = jp, n
     sav = qr(j,k)
     do 50 i = jp, m
50 sav = sav + qr(i,j)*qr(i,k)
     ss = qr(j,k)
     qr(j,k) = sav/s(j)
     ss = (ss - qr(j,k))/y
     do 60 i = jp, m
60 qr(i,k) = qr(i,k) - qr(i,j)*ss
  end do
80 continue
return
!
90 exit = .false.
return
end subroutine ortho

subroutine orsol(m, n, qr, ms, s, ip, x)
implicit none
integer :: ip
integer, intent(in) :: m, ms, n
real :: qr(ms,n), s(n)
real, intent(inout) :: x(m)
integer :: i, ij, j, jp, k, ni, nm, nn
real :: sav, ss, y
!***********************************************************************
!      Identification
!        orsol - least squares solution of a linear system given an
!                orthogonal-triangular factorization of the coefficient
!                matrix produced by subroutine ortho
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        orsol computes the least squares solution of the linear system
!        QRX = PAX = B WHERE Q, R, AND P ARE DETERMINED FROM A BY ORTHO.
!      Control
!
!        dimension qr(ms,n), s(n), ip(n), x(m)
!        .
!        .
!        .
!        call orsol(m, n, qr, ms, s, ip, x)
!
!        Where
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
!        x  AS A REAL INPUT ARRAY IS THE RIGHT-HAND SIDE B OF AX = B.
!        x  AS A REAL OUTPUT ARRAY IS x(i), i = 1, ..., n, THE LEAST
!           SQUARES SOLUTION, AND x(j), j = n+1, ..., m, THE VECTOR
!           whose length is the minimum of all residual B - AX.
!      Method
!        THE FACTORED SYSTEM QRX = PAX = PB ARE SOLVED IN THE SEQUENCE
!        OF QY = PB AND RX = y. FULL RANK FOR THE MATRIX A IS ASSUMED
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
dimension ip(n)
!
nn = n
if (n .eq. m) nn = n - 1
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
  do 10 k = jp, m
10 sav = sav + qr(k,j)*x(k)
  ss = x(j)
  x(j) = sav/s(j)
  ss = (ss - x(j))/y
  do 20 k = jp, m
20 x(k) = x(k) - qr(k,j)*ss
end do
!                                       Back substitute to find the
!                                       least squares solution.
x(n) = x(n)/qr(n,n)
nm = n - 1
do i = 1, nm
  ni = n - i
  nn = n
  do 40 j = 1, i
    x(ni) = x(ni) - qr(ni,nn)*x(nn)
40 nn = nn - 1
  x(ni) = x(ni)/qr(ni,ni)
end do
return
end subroutine orsol

subroutine orimp(m, n, a, ka, qr, ms, s, ip, b, x, r, exit)
implicit none
integer :: ip
integer, intent(in) :: ka, m, ms, n
real :: a(ka,n), b(m), qr(ms,n)
real, intent(inout) :: r(m)
real :: s(n)
real, intent(inout) :: x(m)
integer :: i, j, k, np1
real :: eps, eps2, four, fourth, one, rat, ratio, rnrm2, xnrm2, &
&zero
real :: spmpar
! ----------------------------------------------------------------------
!      Purpose
!        given an approximate least squares solution x of a linear
!        SYSTEM AX = b OBTAINED USING orsol. orimp ATTEMPTS TO COMPUTE
!        an improved solution correct to machine precision.
!
!      Control
!
!        dimension a(ka,n), qr(ms,n), b(m), x(m), r(m), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call orimp(m, n, a, ka, qr, ms, s, ip, b, x, r, exit)
!
!        Where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A
!             (1 .LT. n .LE. m).
!        A    IS A REAL INPUT ARRAY, THE GIVEN m BY n MATRIX.
!        QR   IS A REAL INPUT ARRAY, THE ORTHOGONAL AND TRIANGULAR
!             factors of a produced by ortho.
!        b    IS A REAL INPUT ARRAY, THE RIGHT HAND SIDE OF AX = b.
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
!        Exit is set to the value .True. If improvement of x is success-
!             ful with a gain in accuracy of at least 50 per cent each
!             iteration and .False. Otherwise.
!
!      Method
!        orimp executes the iteration cycle
!              (1)  AR = b - AX
!              (2)  x = x + r
!        with a given initial x.  the residual vector b - AX is computed
!        to high accuracy by double precision.  orsol is then used to
!        solve (1).
!
! ----------------------------------------------------------------------
!
dimension ip(n)
logical, intent(out) :: exit
double precision :: dsum
data zero/0.0/, one/1.0/, four/4.0/, fourth/0.25/
!
!     ********** eps IS A MACHINE DEPENDENT PARAMETER. ASSIGN EPS
!                the value U where U is the smallest positive floating
!                POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0.
!
eps = spmpar(1)
!
exit = .true.
np1 = n + 1
eps2 = eps*eps
!
xnrm2 = zero
do 10 i = 1,n
10 xnrm2 = xnrm2 + x(i)*x(i)
if (xnrm2 .eq. zero) return
ratio = one
!
!                                       Find the residual vector.
!
20 do 22 k = 1,m
dsum = b(k)
do 21 j = 1,n
21 dsum = dsum - dble(a(k,j))*dble(x(j))
22 r(k) = dsum
!
!                                       Find the correction vector.
!
call orsol(m, n, qr, ms, s, ip, r)
rnrm2 = zero
do 30 k = 1,n
30 rnrm2 = rnrm2 + r(k)*r(k)
if (rnrm2 .le. eps2*xnrm2) return
!
!                                       Form new approximate solution.
!
do 40 k = 1,n
40 x(k) = x(k) + r(k)
xnrm2 = zero
do 41 k = 1,n
41 xnrm2 = xnrm2 + x(k)*x(k)
if (m .eq. n) go to 50
do 42 k = np1,m
42 x(k) = r(k)
!
50 if (xnrm2 .eq. zero) return
rat = ratio
ratio = rnrm2/xnrm2
if (ratio .le. fourth*rat) go to 20
!
if (ratio .le. amin1(rat,four*eps2)) return
exit = .false.
return
end subroutine orimp

subroutine dllsq(m,n,a,ka,b,kb,nb,wk,iwk,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, m, n, nb
integer :: i, j, np1
double precision, intent(inout) :: a(ka,n), b(kb,nb), wk(n)
integer, intent(inout) :: iwk(n)
double precision :: rnorm
logical :: exit
!     --------------
ierr = 0
if (1 .lt. n .and. n .le. m) go to 10
ierr = 1
return
!
10 np1 = n + 1
call dortho(m,n,a,ka,wk,iwk,exit)
if (exit) go to 20
ierr = 2
return
!
20 do 22 j = 1,nb
call dorsol(m,n,a,ka,wk,iwk,b(1,j))
if (m .eq. n) go to 22
rnorm = 0.d0
   do 21 i = np1,m
21 rnorm = rnorm + b(i,j)*b(i,j)
b(np1,j) = dsqrt(rnorm)
22 continue
return
end subroutine dllsq

subroutine dortho(m, n, qr, ms, s, ip, exit)
implicit none
integer, intent(in) :: m, ms, n
integer :: i, j, jp, k, kj, nn
!***********************************************************************
!      Identification
!        dortho - orthogonal transformation of a given general m by n
!                matrix A to upper triangular form
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        dortho computes an implicit orthogonal matrix Q and an explicit
!        upper triangular matrix R and a permutation matrix P satisfying
!        qr = PA GIVEN AN m BY n REAL MATRIX A.  dortho IS INTENDED FOR
!        use with the subroutine dorsol to produce the least squares
!        SOLUTION OF THE EQUATION AX = B.
!      Control
!
!        dimension qr(ms,n), s(n), ip(n)
!        logical exit
!        .
!        .
!        .
!        call dortho(m, n, qr, ms, s, ip, exit)
!
!        Where
!        m    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        n    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. n .LE. m).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             qr(i,j), i .LE. j, AND THE RELEVANT PARTS OF Q IN qr(i,j),
!             i .GT. j.
!        ms   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR in the calling program.
!        s    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        ip   IS AN INTEGER OUTPUT ARRAY CONTAINING IN ip(i), i=1,...,n,
!             the images of the permutation corresponding to the PERMU-
!             TATION matrix P.
!        Exit is set to the value .True. If the rank of A is equal to n
!             and .False. Otherwise.
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
double precision, intent(inout) :: qr(ms,n), s(n)
integer, intent(inout) :: ip(n)
double precision :: ajj, sav, ss, y
logical, intent(out) :: exit
!
exit = .true.
nn = n
if (n .eq. m) nn = n - 1
do 80 j = 1, nn
  ip(j) = j
  jp = j + 1
  kj = j
!                                       Search for pivot in the j-TH
!                                       column and interchange rows.
  do k = jp, m
     if (dabs(qr(k,j)) .gt. dabs(qr(kj,j))) kj = k
  end do
  if (qr(kj,j) .eq. 0.d0) go to 90
  if (kj .eq. j) go to 30
  ip(j) = kj
  do 20 i = j, n
     sav = qr(j,i)
     qr(j,i) = qr(kj,i)
20 qr(kj,i) = sav
!                                       Normalize the pivoting column
!                                       and find its norm.
30 ajj = qr(j,j)
  do 31 i = jp, m
31 qr(i,j) = qr(i,j)/ajj
  sav = 1.d0
  do 40 i = jp, m
40 sav = sav + qr(i,j)*qr(i,j)
  s(j) = -dsqrt(sav)
  qr(j,j) = s(j)*ajj
  if (jp .gt. n) go to 80
!                                       Premultiply QR with the j-TH
!                                       orthogonal matrix.
  y = 1.d0 - s(j)
  do k = jp, n
     sav = qr(j,k)
     do 50 i = jp, m
50 sav = sav + qr(i,j)*qr(i,k)
     ss = qr(j,k)
     qr(j,k) = sav/s(j)
     ss = (ss - qr(j,k))/y
     do 60 i = jp, m
60 qr(i,k) = qr(i,k) - qr(i,j)*ss
  end do
80 continue
return
!
90 exit = .false.
return
end subroutine dortho

subroutine dorsol(m, n, qr, ms, s, ip, x)
implicit none
integer, intent(in) :: m, ms, n
integer :: i, ij, j, jp, k, ni, nm, nn
!***********************************************************************
!      Identification
!        dorsol - least squares solution of a linear system given an
!                orthogonal-triangular factorization of the coefficient
!                matrix produced by subroutine dortho
!        Fortran subroutine subprogram
!        aerospace research laboratories
!        wright-patterson afb, ohio  45433
!      purpose
!        dorsol computes the least squares solution of the linear system
!        QRX = PAX = B WHERE Q, R, AND P ARE DETERMINED FROM A BY dortho
!      control
!
!        dimension qr(ms,n), s(n), ip(n), x(m)
!        .
!        .
!        .
!        call dorsol(m, n, qr, ms, s, ip, x)
!
!        Where
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
!        x  AS A REAL INPUT ARRAY IS THE RIGHT-HAND SIDE B OF AX = B.
!        x  AS A REAL OUTPUT ARRAY IS x(i), i = 1, ..., n, THE LEAST
!           SQUARES SOLUTION, AND x(j), j = n+1, ..., m, THE VECTOR
!           whose length is the minimum of all residual B - AX.
!      Method
!        THE FACTORED SYSTEM QRX = PAX = PB ARE SOLVED IN THE SEQUENCE
!        OF QY = PB AND RX = y. FULL RANK FOR THE MATRIX A IS ASSUMED
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
double precision, intent(in) :: qr(ms,n), s(n)
double precision, intent(inout) :: x(m)
integer, intent(in) :: ip(n)
double precision :: sav, ss, y
!
nn = n
if(n .eq. m) nn = n - 1
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
  do 10 k = jp, m
10 sav = sav + qr(k,j)*x(k)
  ss = x(j)
  x(j) = sav/s(j)
  ss = (ss - x(j))/y
  do 20 k = jp, m
20 x(k) = x(k) - qr(k,j)*ss
end do
!                                       Back substitute to find the
!                                       least squares solution.
x(n) = x(n)/qr(n,n)
nm = n - 1
do i = 1, nm
  ni = n - i
  nn = n
  do 40 j = 1, i
    x(ni) = x(ni) - qr(ni,nn)*x(nn)
40 nn = nn - 1
  x(ni) = x(ni)/qr(ni,ni)
end do
return
end subroutine dorsol

subroutine lsqr (ind, a, mda, m, n, b, mdb, nb, re, ae, krank, &
&ksure, rnorm, work, lw, iwork, liw, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ind
integer, intent(inout) :: krank, ksure
integer, intent(in) :: liw, lw, m, mda, mdb, n, nb
real, intent(in) :: ae, re
integer :: i, imax, info, m0, m1, m2, m3, m4, m5, mode, n0, np
real :: eps, rerr
real :: spmpar
!-----------------------------------------------------------------------
!
!              Least squares solution of linear equations
!
!                            --------------
!
!     lsqr solves both underdetermined and overdetermined linear
!     SYSTEMS AX = b, WHERE A IS AN m BY n MATRIX AND b IS AN m BY
!     nb MATRIX OF RIGHT HAND SIDES. IF m .GE. n, THE LEAST SQUARES
!     solution is computed by decomposing the matrix a into the
!     product of an orthogonal matrix Q and upper triangular matrix
!     R (QR FACTORIZATION). IF m .LT. n, THE MINIMAL LENGTH SOLUTION
!     is computed by factoring the matrix a into the product of a
!     lower triangular matrix L and orthogonal matrix Q (LQ factor-
!     ization). If the matrix a is determined to be rank deficient,
!     then the minimal length least squares solution is computed.
!
!     User input bounds on the uncertainty of the elements of A are
!     used to detect numerical rank deficiency. The algorithm uses
!     a row and column pivot strategy to minimize the growth of
!     uncertainty and round-off errors.
!
!   ******************************************************************
!   *                                                                *
!   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!   *                                                                *
!   ******************************************************************
!
!     Input..
!
!     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!                   called for the first time.
!                      ind = 0      ORIGINAL CALL
!                      ind .NE. 0   SUBSEQUENT CALLS
!                   on subsequent calls a new set b of equations can
!                   be solved (using the same coefficient matrix a).
!                   It is assumed that A, mda, m, n, krank, iwork,
!                   liw, and the first 2*min(m,n) locations of work
!                   have not been modified by the user. re, ae, and
!                   ksure are not used.
!
!     a(,)          LINEAR COEFFICIENT MATRIX OF AX=b, WITH mda THE
!      mda,m,n      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!                   m is the row dimension (no. of equations of the
!                   problem) and n the col dimension (no. of unknowns).
!                   MUST HAVE mda .GE. m.
!
!     b(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!      MDB,nb       DIMENSION OF b IN THE CALLING PROGRAM. nb IS THE
!                   number of m by 1 right hand sides. Must have
!                   mdb .GE. max(m,n). IF nb .LE. 0 THEN b AND MDB
!                   are ignored.
!
!     re            re IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX a (0 .le. re .LT. 1).
!
!     ae            ae IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX a (ae .GE. 0).
!
!     work()        A REAL WORK ARRAY DIMENSIONED 5*min(m,n).
!
!     lw            ACTUAL DIMENSION OF WORK
!
!     iwork()       INTEGER WORK ARRAY DIMENSIONED AT LEAST n+m.
!
!     liw           ACTUAL DIMENSION OF iwork.
!
!     Output..
!
!     a(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!                   and the transformation information. A and the first
!                   2*min(m,n) elements of work (see below) completely
!                   specify the factorization of the matrix a.
!
!     b(,)          CONTAINS THE n BY nb SOLUTION MATRIX FOR X.
!
!     krank,ksure   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!                   and absolute bounds on uncertainty, is bounded
!                   above by krank and below by ksure. The algorithm
!                   returns a solution based on krank. ksure provides
!                   an indication of the precision of the rank.
!
!     rnorm()       CONTAINS THE EUCLIDEAN LENGTH OF THE nb RESIDUAL
!                   VECTORS  b(i) - AX(i), i=1,...,nb.
!
!     work()        THE FIRST 2*min(m,n) LOCATIONS OF WORK CONTAIN
!                   the values necessary to reproduce the Householder
!                   factorization of A.
!
!     iwork()       AN ARRAY OF LENGTH m + n CONTAINING THE ORDERS IN
!                   WHICH THE ROWS AND COLUMNS WERE USED. IF m .GE. n
!                   then the first n locations contain the order of
!                   the columns and the next m locations the order of
!                   THE ROWS. IF m .LT. n THEN THE ORDER OF THE ROWS
!                   precedes the order of the columns.
!
!     ierr          FLAG TO INDICATE THE STATUS OF THE RESULTS
!                     0     - SATISFACTORY COMPLETION
!                   .GT. 0  - INPUT ERROR
!
!----------------
!     The subroutines u11ls, u12ls, u11us, and u12us were written by
!     T. Manteuffel (LANL) in 1981. The driver routine lsqr was written
!     by A.H. Morris (NSWC) in 1991.
!----------------
!     Reference.  Manteuffel, T., An interval analysis approach to rank
!                 determination in linear least squares problems,
!                 Sandia Laboratories report SAND80-0655, June, 1980.
!-----------------------------------------------------------------------
real, intent(inout) :: a(mda,n), b(mdb,*), rnorm(*), work(lw)
integer, intent(inout) :: iwork(liw)
!----------------
!     np            IF m .GE. n THEN THE FIRST np COLUMNS OF A
!                   are never interchanged.
!                   IF m .LT. n THEN THE FIRST np ROWS OF A ARE
!                   never interchanged. np is not referenced on
!                   a continuation call to the routine.
!
!     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!                   is to react if rank deficiency is detected.
!                   IF mode = 0 RETURN IMMEDIATELY, NO SOLUTION
!                             1 compute truncated solution
!                             2 compute minimal length solution
!                   mode must not be modified on a continuation
!                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!                   first n locations of work are used.
!----------------
np = 0
mode = 2
!
!     Check the input
!
if (nb .le. 0 .and. ind .ne. 0) go to 200
if (m .lt. 1 .or. n .lt. 1) go to 210
if (mda .lt. m) go to 220
if (liw .lt. m + n) go to 240
!
m0 = min0(m,n)
n0 = max0(m,n)
!     num = 0
!
if (nb .le. 0) go to 10
if (mdb .lt. n0) go to 230
if (ind .ne. 0) go to 100
!
10 if (lw .lt. 5*m0) go to 250
if (re .lt. 0.0 .or. ae .lt. 0.0) go to 260
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
!     num = np
if (m .lt. n) go to 40
!
   call u11ls (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
   go to 100
!
40 call u11us (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
!
!     Solution phase
!
100 ierr = 0
info = 0
if (krank .eq. m0) go to 110
if (krank .eq. 0) go to 110
!     if (krank .lt. num) go to 280
!     if (mode .eq. 0) return
info = mode
!
110 if (nb .le. 0) return
!
m1 = 1
m2 = 1 + m0
if (info .eq. 2) go to 130
!
!     Only min(m,n) elements of work are needed
!
if (lw .lt. m0) go to 250
if (m .lt. n) go to 120
!
   call u12ls (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m1),iwork(m1),iwork(m2))
   return
!
120 call u12us (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m1),iwork(m1),iwork(m2))
return
!
!     Here 2*min(m,n) elements of work are needed
!
130 if (lw .lt. 2*m0) go to 250
if (m .lt. n) go to 140
!
   call u12ls (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m2),iwork(m1),iwork(m2))
   return
!
140 call u12us (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m2),iwork(m1),iwork(m2))
return
!
!     Error return
!
!                             nb .LE. 0  ON A CONTINUATION CALL
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
return
!                             0 .LT. krank .LT. np
! 280 ierr = 8
!     return
end subroutine lsqr

subroutine u11ls (a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
&ic,ir)
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
real, intent(inout) :: a(mda,n), db(n), eb(n), h(n), ub(n), w(n)
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
&kp1, kz, l, lm1, mm, nmk
real :: bb, r2, rmin, sum, t, temp, tn, tt
real :: snrm2
real :: sdot
integer :: isamax
!
!       This routine performs A QR factorization of A
!       using Householder transformations. Row and
!       column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!
integer, intent(inout) :: ic(n), ir(m)
!
!        Initialization
!
j = 0
krank = n
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!
!        Determine rel and abs error vectors
!
!
!        Calculate col length
!
do i = 1,n
   h(i) = snrm2(m,a(1,i),1)
   w(i) = h(i)
end do
!
!         Initialize error bounds
!
do i = 1,n
   eb(i) = amax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!
!          Discard self dependent columns
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          Matrix reduction
!
60 kk = krank
krank = krank - 1
if (mode .eq. 0) return
if (i .le. np) go to 400
if (i .gt. krank) go to 70
call sswap (1,eb(i),1,eb(kk),1)
call sswap (1,ub(i),1,ub(kk),1)
call sswap (1,w(i),1,w(kk),1)
call sswap (1,h(i),1,h(kk),1)
call iswap (1,ic(i),1,ic(kk),1)
call sswap (m,a(1,i),1,a(1,kk),1)
go to 50
!
!           Test for zero rank
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        m A i n    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH COL HAS MM=m-j+1 COMPONENTS
!
mm = m - j + 1
!
!         ub determines column pivot
!
110 imin = j
if (h(j) .eq. 0.0) go to 170
rmin = ub(j)/h(j)
do 120 i = j,kz
   if (ub(i) .ge. h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
!
!     Test for rank deficiency
!
if (rmin .lt. 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt .ge. 1.0) go to 170
!
!     Compute exact ub
!
do i = 1,jm1
   w(i) = a(i,imin)
end do
!
l = jm1
130 w(l) = w(l)/a(l,l)
if (l .eq. 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(lm1,i)*w(i)
end do
l = lm1
go to 130
!
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) .ge. 1.0) go to 170
go to 200
!
!        Matrix reduction
!
170 kk = krank
krank = krank - 1
kz = krank
if (mode .eq. 0) return
if (j .le. np) go to 410
if (imin .gt. krank) go to 180
   call iswap (1,ic(imin),1,ic(kk),1)
   call sswap (m,a(1,imin),1,a(1,kk),1)
   call sswap (1,eb(imin),1,eb(kk),1)
   call sswap (1,ub(imin),1,ub(kk),1)
   call sswap (1,db(imin),1,db(kk),1)
   call sswap (1,w(imin),1,w(kk),1)
   call sswap (1,h(imin),1,h(kk),1)
180 if (j .gt. krank) go to 300
go to 110
!
!        Column pivot
!
200 if (imin .eq. j) go to 210
call sswap (1,h(j),1,h(imin),1)
call sswap (m,a(1,j),1,a(1,imin),1)
call sswap (1,eb(j),1,eb(imin),1)
call sswap (1,ub(j),1,ub(imin),1)
call sswap (1,db(j),1,db(imin),1)
call sswap (1,w(j),1,w(imin),1)
call iswap (1,ic(j),1,ic(imin),1)
!
!        Row pivot
!
210 jmax = isamax(mm,a(j,j),1)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call sswap (n,a(j,1),mda,a(jmax,1),mda)
call iswap (1,ir(j),1,ir(jmax),1)
!
!     Apply Householder transformation
!
220 tn = snrm2(mm,a(j,j),1)
if (tn .eq. 0.0) go to 170
if (a(j,j) .ne. 0.0) tn = sign(tn,a(j,j))
call sscal (mm,1.0/tn,a(j,j),1)
a(j,j) = a(j,j) + 1.0
if (j .eq. n) go to 250
do 240 i = jp1,n
   bb = -sdot(mm,a(j,j),1,a(j,i),1)/a(j,j)
   call saxpy (mm,bb,a(j,j),1,a(j,i),1)
   if (i .le. np) go to 240
   if (h(i) .eq. 0.0) go to 240
   tt = 1.0 - (a(j,i)/h(i))**2
   tt = amax1(tt,0.0)
   t = tt
   tt = 1.0 + 0.05*tt*(h(i)/w(i))**2
   if (tt .eq. 1.0) go to 230
      h(i) = h(i)*sqrt(t)
      go to 240
230 h(i) = snrm2(m-j,a(j+1,i),1)
   w(i) = h(i)
240 continue
!
250 h(j) = a(j,j)
a(j,j) = -tn
!
!          Update ub, db
!
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j)) + db(j))/a(j,j)
if (j .eq. krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(j,i))*ub(j)
   db(i) = db(i) - a(j,i)*db(j)
end do
go to 100
!
!        E n D    m A i n    L O O P
!
300 continue
!
!        Compute ksure
!
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do 310 ii = 1,kmi
      if (ub(ii) .le. ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310 continue
   if (is .eq. 0) go to 320
end do
!
320 ksure = 0
sum = 0.0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum .ge. 1.0) go to 330
   sum = sum + r2
   ksure = ksure + 1
end do
!
!     IF SYSTEM IS OF REDUCED RANK AND mode = 2
!     complete the decomposition for shortest least squares solution
!
330 if (krank .eq. n .or. mode .lt. 2) return
nmk = n - krank
kp1 = krank + 1
i = krank
340 tn = snrm2(nmk,a(i,kp1),mda)/a(i,i)
   tn = a(i,i)*sqrt(1.0 + tn*tn)
   call sscal (nmk,1.0/tn,a(i,kp1),mda)
   w(i) = a(i,i)/tn + 1.0
   a(i,i) = -tn
   if (i .eq. 1) go to 350
   im1 = i - 1
   do ii = 1,im1
      tt = -sdot(nmk,a(ii,kp1),mda,a(i,kp1),mda)/w(i)
      tt = tt - a(ii,i)
      call saxpy (nmk,tt,a(i,kp1),mda,a(ii,kp1),mda)
      a(ii,i) = a(ii,i) + tt*w(i)
   end do
   i = i - 1
   go to 340
!
350 continue
return
!
!     First np columns are linearly dependent
!
400 krank = i - 1
return
410 krank = j - 1
return
end subroutine u11ls

subroutine u12ls (a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ic,ir)
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
real, intent(inout) :: a(mda,n), b(mdb,nb)
real :: h(n)
real, intent(inout) :: rnorm(nb)
real :: w(n)
integer :: i, ij, im1, j, jb, k, kp1, nmk
real :: bb, tt
real :: snrm2
real :: sdot
!
!        Given the Householder QR factorization of A, this
!        SUBROUTINE SOLVES THE SYSTEM AX=b. IF THE SYSTEM
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!
!       NOTE - IF mode.NE.2, w IS NEVER ACCESSED.
!
integer, intent(inout) :: ic(n), ir(m)
!
k = krank
kp1 = k + 1
if (k .gt. 0) go to 30
!
!        rank=0
!
do jb = 1,nb
   rnorm(jb) = snrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
return
!
30 i = 0
!
!     Reorder b to reflect row interchanges
!
40 i = i + 1
   if (i .eq. m) go to 100
   j = ir(i)
   if (j .eq. i) go to 40
   if (j .lt. 0) go to 40
!
   ir(i) = -ir(i)
   do jb = 1,nb
      rnorm(jb) = b(i,jb)
   end do
!
   ij = i
60 do jb = 1,nb
         b(ij,jb) = b(j,jb)
      end do
      ij = j
      j = ir(ij)
      ir(ij) = -ir(ij)
   if (j .ne. i) go to 60
!
   do jb = 1,nb
      b(ij,jb) = rnorm(jb)
   end do
   go to 40
!
100 do i = 1,m
   ir(i) = iabs(ir(i))
end do
!
!     Apply Householder transformations to b
!
do j = 1,k
   tt = a(j,j)
   a(j,j) = h(j)
   do i = 1,nb
      bb = -sdot (m-j+1,a(j,j),1,b(j,i),1)/h(j)
      call saxpy (m-j+1,bb,a(j,j),1,b(j,i),1)
   end do
   a(j,j) = tt
end do
!
!        Find norms of residual VECTOR(S)..(before overwrite b)
!
do jb = 1,nb
   rnorm(jb) = snrm2(m-k,b(kp1,jb),1)
end do
!
!     Back solve upper triangular R
!
i = k
150 do jb = 1,nb
   b(i,jb) = b(i,jb)/a(i,i)
end do
if (i .eq. 1) go to 200
im1 = i - 1
do jb = 1,nb
   call saxpy (im1,-b(i,jb),a(1,i),1,b(1,jb),1)
end do
i = im1
go to 150
!
!     RANK LT n
!
!      Truncated solution
!
200 if (k .eq. n) go to 230
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
if (mode .eq. 1) go to 230
!
!      Minimal length solution
!
nmk = n - k
do jb = 1,nb
   do i = 1,k
      tt = -sdot(nmk,a(i,kp1),mda,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call saxpy (nmk,tt,a(i,kp1),mda,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!
!     Reorder b to reflect column interchanges
!
230 i = 0
!
240 i = i + 1
   if (i .eq. n) go to 260
   j = ic(i)
   if (j .eq. i) go to 240
   if (j .lt. 0) go to 240
!
   ic(i) = -ic(i)
250 call sswap (nb,b(j,1),mdb,b(i,1),mdb)
      ij = ic(j)
      ic(j) = -ic(j)
      j = ij
   if (j .ne. i) go to 250
   go to 240
!
260 do i = 1,n
   ic(i) = iabs(ic(i))
end do
return
end subroutine u12ls

subroutine u11us (a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
&ir,ic)
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
real, intent(inout) :: a(mda,n), db(m), eb(m), h(m), ub(m), w(m)
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
&kp1, kz, l, lm1, mmk, nn
real :: bb, r2, rmin, sum, t, temp, tn, tt
real :: snrm2
real :: sdot
integer :: isamax
!
!       This routine performs an LQ factorization of the
!       matrix a using Householder transformations. Row
!       and column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!
integer, intent(inout) :: ic(n), ir(m)
!
!        Initialization
!
j = 0
krank = m
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!
!        Determine rel and abs error vectors
!
!
!        Calculate row length
!
do i = 1,m
   h(i) = snrm2(n,a(i,1),mda)
   w(i) = h(i)
end do
!
!         Initialize error bounds
!
do i = 1,m
   eb(i) = amax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!
!          Discard self dependent rows
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          Matrix reduction
!
60 kk = krank
krank = krank - 1
if (mode .eq. 0) return
if (i .le. np) go to 400
if (i .gt. krank) go to 70
call sswap (1,eb(i),1,eb(kk),1)
call sswap (1,ub(i),1,ub(kk),1)
call sswap (1,w(i),1,w(kk),1)
call sswap (1,h(i),1,h(kk),1)
call iswap (1,ir(i),1,ir(kk),1)
call sswap (n,a(i,1),mda,a(kk,1),mda)
go to 50
!
!           Test for zero rank
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        m A i n    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH ROW HAS NN=n-j+1 COMPONENTS
!
nn = n - j + 1
!
!         ub determines row pivot
!
110 imin = j
if (h(j) .eq. 0.0) go to 170
rmin = ub(j)/h(j)
do 120 i = j,kz
   if (ub(i) .ge. h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
!
!     Test for rank deficiency
!
if (rmin .lt. 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt .ge. 1.0) go to 170
!
!     Compute exact ub
!
do i = 1,jm1
   w(i) = a(imin,i)
end do
!
l = jm1
130 w(l) = w(l)/a(l,l)
if (l .eq. 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(i,lm1)*w(i)
end do
l = lm1
go to 130
!
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + abs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) .ge. 1.0) go to 170
go to 200
!
!        Matrix reduction
!
170 kk = krank
krank = krank - 1
kz = krank
if (mode .eq. 0) return
if (j .le. np) go to 410
if (imin .gt. krank) go to 180
   call iswap (1,ir(imin),1,ir(kk),1)
   call sswap (n,a(imin,1),mda,a(kk,1),mda)
   call sswap (1,eb(imin),1,eb(kk),1)
   call sswap (1,ub(imin),1,ub(kk),1)
   call sswap (1,db(imin),1,db(kk),1)
   call sswap (1,w(imin),1,w(kk),1)
   call sswap (1,h(imin),1,h(kk),1)
180 if (j .gt. krank) go to 300
go to 110
!
!        Row pivot
!
200 if (imin .eq. j) go to 210
call sswap (1,h(j),1,h(imin),1)
call sswap (n,a(j,1),mda,a(imin,1),mda)
call sswap (1,eb(j),1,eb(imin),1)
call sswap (1,ub(j),1,ub(imin),1)
call sswap (1,db(j),1,db(imin),1)
call sswap (1,w(j),1,w(imin),1)
call iswap (1,ir(j),1,ir(imin),1)
!
!        Column pivot
!
210 jmax = isamax(nn,a(j,j),mda)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call sswap (m,a(1,j),1,a(1,jmax),1)
call iswap (1,ic(j),1,ic(jmax),1)
!
!     Apply Householder transformation
!
220 tn = snrm2(nn,a(j,j),mda)
if (tn .eq. 0.0) go to 170
if (a(j,j) .ne. 0.0) tn = sign(tn,a(j,j))
call sscal (nn,1.0/tn,a(j,j),mda)
a(j,j) = a(j,j) + 1.0
if (j .eq. m) go to 250
do 240 i = jp1,m
   bb = -sdot(nn,a(j,j),mda,a(i,j),mda)/a(j,j)
   call saxpy (nn,bb,a(j,j),mda,a(i,j),mda)
   if (i .le. np) go to 240
   if (h(i) .eq. 0.0) go to 240
   tt = 1.0 - (a(i,j)/h(i))**2
   tt = amax1(tt,0.0)
   t = tt
   tt = 1.0 + 0.05*tt*(h(i)/w(i))**2
   if (tt .eq. 1.0) go to 230
      h(i) = h(i)*sqrt(t)
      go to 240
230 h(i) = snrm2(n-j,a(i,j+1),mda)
   w(i) = h(i)
240 continue
!
250 h(j) = a(j,j)
a(j,j) = -tn
!
!          Update ub, db
!
ub(j) = ub(j)/abs(a(j,j))
db(j) = (sign(eb(j),db(j))+db(j))/a(j,j)
if (j .eq. krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + abs(a(i,j))*ub(j)
   db(i) = db(i) - a(i,j)*db(j)
end do
go to 100
!
!        E n D    m A i n    L O O P
!
300 continue
!
!        Compute ksure
!
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do 310 ii = 1,kmi
      if (ub(ii) .le. ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310 continue
   if (is .eq. 0) go to 320
end do
!
320 ksure = 0
sum = 0.0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum .ge. 1.0) go to 330
   sum = sum + r2
   ksure = ksure + 1
end do
!
!     IF SYSTEM IS OF REDUCED RANK AND mode = 2
!     complete the decomposition for shortest least squares solution
!
330 if (krank .eq. m .or. mode .lt. 2) return
mmk = m - krank
kp1 = krank + 1
i = krank
340 tn = snrm2(mmk,a(kp1,i),1)/a(i,i)
   tn = a(i,i)*sqrt(1.0 + tn*tn)
   call sscal (mmk,1.0/tn,a(kp1,i),1)
   w(i) = a(i,i)/tn + 1.0
   a(i,i) = -tn
   if (i .eq. 1) go to 350
   im1 = i - 1
   do ii = 1,im1
      tt = -sdot(mmk,a(kp1,ii),1,a(kp1,i),1)/w(i)
      tt = tt - a(i,ii)
      call saxpy (mmk,tt,a(kp1,i),1,a(kp1,ii),1)
      a(i,ii) = a(i,ii) + tt*w(i)
   end do
   i = i - 1
   go to 340
!
350 continue
return
!
!     First np rows are linearly dependent
!
400 krank = i - 1
return
410 krank = j - 1
return
end subroutine u11us

subroutine u12us (a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ir,ic)
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
real, intent(inout) :: a(mda,n), b(mdb,nb)
real :: h(m)
real, intent(inout) :: rnorm(nb)
real :: w(m)
integer :: i, ij, ip1, j, jb, k, kp1, mmk
real :: bb, tt
real :: snrm2
real :: sdot
!
!        Given the Householder LQ factorization of A, this
!        SUBROUTINE SOLVES THE SYSTEM AX=b. IF THE SYSTEM
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!
!       NOTE - IF mode.NE.2, w IS NEVER ACCESSED.
!
integer, intent(inout) :: ic(n), ir(m)
!
k = krank
kp1 = k + 1
if (k .gt. 0) go to 30
!
!        rank=0
!
do jb = 1,nb
   rnorm(jb) = snrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.0
   end do
end do
return
!
30 i = 0
!
!     Reorder b to reflect row interchanges
!
40 i = i + 1
   if (i .eq. m) go to 100
   j = ir(i)
   if (j .eq. i) go to 40
   if (j .lt. 0) go to 40
!
   ir(i) = -ir(i)
   do jb = 1,nb
      rnorm(jb) = b(i,jb)
   end do
!
   ij = i
60 do jb = 1,nb
         b(ij,jb) = b(j,jb)
      end do
      ij = j
      j = ir(ij)
      ir(ij) = -ir(ij)
   if (j .ne. i) go to 60
!
   do jb = 1,nb
      b(ij,jb) = rnorm(jb)
   end do
   go to 40
!
100 do i = 1,m
   ir(i) = iabs(ir(i))
end do
!
!     IF A IS OF REDUCED RANK AND mode=2,
!     apply Householder transformations to b
!
if (mode .lt. 2 .or. k .eq. m) go to 140
mmk = m - k
do jb = 1,nb
   do j = 1,k
      i = kp1 - j
      tt = -sdot(mmk,a(kp1,i),1,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call saxpy (mmk,tt,a(kp1,i),1,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!
!     Find norms of residual VECTOR(S)..(before overwrite b)
!
140 do jb = 1,nb
   rnorm(jb) = snrm2(m-k,b(kp1,jb),1)
end do
!
!     Back solve lower triangular L
!
do 170 jb = 1,nb
   do i = 1,k
      b(i,jb) = b(i,jb)/a(i,i)
      if (i .eq. k) go to 170
      ip1 = i + 1
      call saxpy(k-i,-b(i,jb),a(ip1,i),1,b(ip1,jb),1)
   end do
170 continue
!
!      Truncated solution
!
if (k .eq. n) go to 210
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
!
!     Apply Householder transformations to b
!
210 do i = 1,k
   j = kp1 - i
   tt = a(j,j)
   a(j,j) = h(j)
   do jb = 1,nb
      bb = -sdot(n-j+1,a(j,j),mda,b(j,jb),1)/h(j)
      call saxpy(n-j+1,bb,a(j,j),mda,b(j,jb),1)
   end do
   a(j,j) = tt
end do
!
!     Reorder b to reflect column interchanges
!
i = 0
!
240 i = i + 1
   if (i .eq. n) go to 260
   j = ic(i)
   if (j .eq. i) go to 240
   if (j .lt. 0) go to 240
!
   ic(i) = -ic(i)
250 call sswap (nb,b(j,1),mdb,b(i,1),mdb)
      ij = ic(j)
      ic(j) = -ic(j)
      j = ij
   if (j .ne. i) go to 250
   go to 240
!
260 do i = 1,n
   ic(i) = iabs(ic(i))
end do
return
end subroutine u12us

subroutine dlsqr (ind, a, mda, m, n, b, mdb, nb, re, ae, krank, &
&ksure, rnorm, work, lw, iwork, liw, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ind
integer, intent(inout) :: krank, ksure
integer, intent(in) :: liw, lw, m, mda, mdb, n, nb
integer :: i, imax, info, m0, m1, m2, m3, m4, m5, mode, n0, np
!-----------------------------------------------------------------------
!
!              Least squares solution of linear equations
!
!                            --------------
!
!     dlsqr solves both underdetermined and overdetermined linear
!     SYSTEMS AX = b, WHERE A IS AN m BY n MATRIX AND b IS AN m BY
!     nb MATRIX OF RIGHT HAND SIDES. IF m .GE. n, THE LEAST SQUARES
!     solution is computed by decomposing the matrix a into the
!     product of an orthogonal matrix Q and upper triangular matrix
!     R (QR FACTORIZATION). IF m .LT. n, THE MINIMAL LENGTH SOLUTION
!     is computed by factoring the matrix a into the product of a
!     lower triangular matrix L and orthogonal matrix Q (LQ factor-
!     ization). If the matrix a is determined to be rank deficient,
!     then the minimal length least squares solution is computed.
!
!     User input bounds on the uncertainty of the elements of A are
!     used to detect numerical rank deficiency. The algorithm uses
!     a row and column pivot strategy to minimize the growth of
!     uncertainty and round-off errors.
!
!   ******************************************************************
!   *                                                                *
!   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!   *                                                                *
!   ******************************************************************
!
!     Input..
!
!     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!                   called for the first time.
!                      ind = 0      ORIGINAL CALL
!                      ind .NE. 0   SUBSEQUENT CALLS
!                   on subsequent calls a new set b of equations can
!                   be solved (using the same coefficient matrix a).
!                   It is assumed that A, mda, m, n, krank, iwork,
!                   liw, and the first 2*min(m,n) locations of work
!                   have not been modified by the user. re, ae, and
!                   ksure are not used.
!
!     a(,)          LINEAR COEFFICIENT MATRIX OF AX=b, WITH mda THE
!      mda,m,n      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!                   m is the row dimension (no. of equations of the
!                   problem) and n the col dimension (no. of unknowns).
!                   MUST HAVE mda .GE. m.
!
!     b(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!      MDB,nb       DIMENSION OF b IN THE CALLING PROGRAM. nb IS THE
!                   number of m by 1 right hand sides. Must have
!                   mdb .GE. max(m,n). IF nb .LE. 0 THEN b AND MDB
!                   are ignored.
!
!     re            re IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX a (0 .le. re .LT. 1).
!
!     ae            ae IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX a (ae .GE. 0).
!
!     work()        A REAL WORK ARRAY DIMENSIONED 5*min(m,n).
!
!     lw            ACTUAL DIMENSION OF WORK
!
!     iwork()       INTEGER WORK ARRAY DIMENSIONED AT LEAST n+m.
!
!     liw           ACTUAL DIMENSION OF iwork.
!
!     Output..
!
!     a(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!                   and the transformation information.Ind together with
!                   the first 2*min(m,n) elements of work (see below)
!                   completely specify the factorization of A.
!
!     b(,)          CONTAINS THE n BY nb SOLUTION MATRIX FOR X.
!
!     krank,ksure   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!                   and absolute bounds on uncertainty, is bounded
!                   above by krank and below by ksure. The algorithm
!                   returns a solution based on krank. ksure provides
!                   an indication of the precision of the rank.
!
!     rnorm()       CONTAINS THE EUCLIDEAN LENGTH OF THE nb RESIDUAL
!                   VECTORS  b(i) - AX(i), i=1,...,nb.
!
!     work()        THE FIRST 2*min(m,n) LOCATIONS OF WORK CONTAIN
!                   the values necessary to reproduce the Householder
!                   factorization of A.
!
!     iwork()       AN ARRAY OF LENGTH m + n CONTAINING THE ORDERS IN
!                   WHICH THE ROWS AND COLUMNS WERE USED. IF m .GE. n
!                   then the first n locations contain the order of
!                   the columns and the next m locations the order of
!                   THE ROWS. IF m .LT. n THEN THE ORDER OF THE ROWS
!                   precedes the order of the columns.
!
!     ierr          FLAG TO INDICATE THE STATUS OF THE RESULTS
!                     0     - SATISFACTORY COMPLETION
!                   .GT. 0  - INPUT ERROR
!
!----------------
!     The subroutines du11ls, du12ls, du11us, and du12us were written by
!     T. Manteuffel (LANL) in 1981. The driver routine dlsqr was written
!     by A.H. Morris (NSWC) in 1991.
!----------------
!     Reference.  Manteuffel, T., *An interval analysis approach to rank
!                 determination in linear least squares problems*,
!                 Sandia Laboratories report SAND80-0655, June, 1980.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(mda,n), b(mdb,*)
double precision, intent(in) :: re, ae
double precision, intent(inout) :: rnorm(*), work(lw)
integer, intent(inout) :: iwork(liw)
double precision :: eps, rerr
double precision :: dpmpar
!----------------
!     np            IF m .GE. n THEN THE FIRST np COLUMNS OF A
!                   are never interchanged.
!                   IF m .LT. n THEN THE FIRST np ROWS OF A ARE
!                   never interchanged. np is not referenced on
!                   a continuation call to the routine.
!
!     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!                   is to react if rank deficiency is detected.
!                   IF mode = 0 RETURN IMMEDIATELY, NO SOLUTION
!                             1 compute truncated solution
!                             2 compute minimal length solution
!                   mode must not be modified on a continuation
!                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!                   first n locations of work are used.
!----------------
np = 0
mode = 2
!
!     Check the input
!
if (nb .le. 0 .and. ind .ne. 0) go to 200
if (m .lt. 1 .or. n .lt. 1) go to 210
if (mda .lt. m) go to 220
if (liw .lt. m + n) go to 240
!
m0 = min0(m,n)
n0 = max0(m,n)
!     num = 0
!
if (nb .le. 0) go to 10
if (mdb .lt. n0) go to 230
if (ind .ne. 0) go to 100
!
10 if (lw .lt. 5*m0) go to 250
if (re .lt. 0.d0 .or. ae .lt. 0.d0) go to 260
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
!     num = np
if (m .lt. n) go to 40
!
   call du11ls (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
   go to 100
!
40 call du11us (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
!
!     Solution phase
!
100 ierr = 0
info = 0
if (krank .eq. m0) go to 110
if (krank .eq. 0) go to 110
!     if (krank .lt. num) go to 280
!     if (mode .eq. 0) return
info = mode
!
110 if (nb .le. 0) return
!
m1 = 1
m2 = 1 + m0
if (info .eq. 2) go to 130
!
!     Only min(m,n) elements of work are needed
!
if (lw .lt. m0) go to 250
if (m .lt. n) go to 120
!
   call du12ls (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m1),iwork(m1),iwork(m2))
   return
!
120 call du12us (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m1),iwork(m1),iwork(m2))
return
!
!     Here 2*min(m,n) elements of work are needed
!
130 if (lw .lt. 2*m0) go to 250
if (m .lt. n) go to 140
!
   call du12ls (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m2),iwork(m1),iwork(m2))
   return
!
140 call du12us (a,mda,m,n,b,mdb,nb,mode,krank,rnorm, &
&work(m1),work(m2),iwork(m1),iwork(m2))
return
!
!     Error return
!
!                             nb .LE. 0  ON A CONTINUATION CALL
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
return
!                             0 .LT. krank .LT. np
! 280 ierr = 8
!     return
end subroutine dlsqr

subroutine du11ls (a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
&ic,ir)
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
&kp1, kz, l, lm1, mm, nmk
integer :: idamax
!
!       This routine performs A QR factorization of A
!       using Householder transformations. Row and
!       column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!
double precision, intent(inout) :: a(mda,n), ub(n), db(n), h(n), &
&w(n), eb(n)
integer, intent(inout) :: ic(n), ir(m)
double precision :: bb, rmin, r2, sum, t, temp, tn, tt
double precision :: ddot, dnrm2
!
!        Initialization
!
j = 0
krank = n
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!
!        Determine rel and abs error vectors
!
!
!        Calculate col length
!
do i = 1,n
   h(i) = dnrm2(m,a(1,i),1)
   w(i) = h(i)
end do
!
!         Initialize error bounds
!
do i = 1,n
   eb(i) = dmax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.d0
end do
!
!          Discard self dependent columns
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          Matrix reduction
!
60 kk = krank
krank = krank - 1
if (mode .eq. 0) return
if (i .le. np) go to 400
if (i .gt. krank) go to 70
call dswap (1,eb(i),1,eb(kk),1)
call dswap (1,ub(i),1,ub(kk),1)
call dswap (1,w(i),1,w(kk),1)
call dswap (1,h(i),1,h(kk),1)
call iswap (1,ic(i),1,ic(kk),1)
call dswap (m,a(1,i),1,a(1,kk),1)
go to 50
!
!           Test for zero rank
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        m A i n    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH COL HAS MM=m-j+1 COMPONENTS
!
mm = m - j + 1
!
!         ub determines column pivot
!
110 imin = j
if (h(j) .eq. 0.d0) go to 170
rmin = ub(j)/h(j)
do 120 i = j,kz
   if (ub(i) .ge. h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
!
!     Test for rank deficiency
!
if (rmin .lt. 1.d0) go to 200
tt = (eb(imin) + dabs(db(imin)))/h(imin)
if (tt .ge. 1.d0) go to 170
!
!     Compute exact ub
!
do i = 1,jm1
   w(i) = a(i,imin)
end do
!
l = jm1
130 w(l) = w(l)/a(l,l)
if (l .eq. 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(lm1,i)*w(i)
end do
l = lm1
go to 130
!
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + dabs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) .ge. 1.d0) go to 170
go to 200
!
!        Matrix reduction
!
170 kk = krank
krank = krank - 1
kz = krank
if (mode .eq. 0) return
if (j .le. np) go to 410
if (imin .gt. krank) go to 180
   call iswap (1,ic(imin),1,ic(kk),1)
   call dswap (m,a(1,imin),1,a(1,kk),1)
   call dswap (1,eb(imin),1,eb(kk),1)
   call dswap (1,ub(imin),1,ub(kk),1)
   call dswap (1,db(imin),1,db(kk),1)
   call dswap (1,w(imin),1,w(kk),1)
   call dswap (1,h(imin),1,h(kk),1)
180 if (j .gt. krank) go to 300
go to 110
!
!        Column pivot
!
200 if (imin .eq. j) go to 210
call dswap (1,h(j),1,h(imin),1)
call dswap (m,a(1,j),1,a(1,imin),1)
call dswap (1,eb(j),1,eb(imin),1)
call dswap (1,ub(j),1,ub(imin),1)
call dswap (1,db(j),1,db(imin),1)
call dswap (1,w(j),1,w(imin),1)
call iswap (1,ic(j),1,ic(imin),1)
!
!        Row pivot
!
210 jmax = idamax(mm,a(j,j),1)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call dswap (n,a(j,1),mda,a(jmax,1),mda)
call iswap (1,ir(j),1,ir(jmax),1)
!
!     Apply Householder transformation
!
220 tn = dnrm2(mm,a(j,j),1)
if (tn .eq. 0.d0) go to 170
if (a(j,j) .ne. 0.d0) tn = dsign(tn,a(j,j))
call dscal (mm,1.d0/tn,a(j,j),1)
a(j,j) = a(j,j) + 1.d0
if (j .eq. n) go to 250
do 240 i = jp1,n
   bb = -ddot(mm,a(j,j),1,a(j,i),1)/a(j,j)
   call daxpy (mm,bb,a(j,j),1,a(j,i),1)
   if (i .le. np) go to 240
   if (h(i) .eq. 0.d0) go to 240
   tt = 1.d0 - (a(j,i)/h(i))**2
   tt = dmax1(tt,0.d0)
   t = tt
   tt = 1.d0 + 0.05d0*tt*(h(i)/w(i))**2
   if (tt .eq. 1.d0) go to 230
      h(i) = h(i)*dsqrt(t)
      go to 240
230 h(i) = dnrm2(m-j,a(j+1,i),1)
   w(i) = h(i)
240 continue
!
250 h(j) = a(j,j)
a(j,j) = -tn
!
!          Update ub, db
!
ub(j) = ub(j)/dabs(a(j,j))
db(j) = (dsign(eb(j),db(j)) + db(j))/a(j,j)
if (j .eq. krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + dabs(a(j,i))*ub(j)
   db(i) = db(i) - a(j,i)*db(j)
end do
go to 100
!
!        E n D    m A i n    L O O P
!
300 continue
!
!        Compute ksure
!
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do 310 ii = 1,kmi
      if (ub(ii) .le. ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310 continue
   if (is .eq. 0) go to 320
end do
!
320 ksure = 0
sum = 0.d0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum .ge. 1.d0) go to 330
   sum = sum + r2
   ksure = ksure + 1
end do
!
!     IF SYSTEM IS OF REDUCED RANK AND mode = 2
!     complete the decomposition for shortest least squares solution
!
330 if (krank .eq. n .or. mode .lt. 2) return
nmk = n - krank
kp1 = krank + 1
i = krank
340 tn = dnrm2(nmk,a(i,kp1),mda)/a(i,i)
   tn = a(i,i)*dsqrt(1.d0 + tn*tn)
   call dscal (nmk,1.d0/tn,a(i,kp1),mda)
   w(i) = a(i,i)/tn + 1.d0
   a(i,i) = -tn
   if (i .eq. 1) go to 350
   im1 = i - 1
   do ii = 1,im1
      tt = -ddot(nmk,a(ii,kp1),mda,a(i,kp1),mda)/w(i)
      tt = tt - a(ii,i)
      call daxpy (nmk,tt,a(i,kp1),mda,a(ii,kp1),mda)
      a(ii,i) = a(ii,i) + tt*w(i)
   end do
   i = i - 1
   go to 340
!
350 continue
return
!
!     First np columns are linearly dependent
!
400 krank = i - 1
return
410 krank = j - 1
return
end subroutine du11ls

subroutine du12ls (a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ic,ir)
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
integer :: i, ij, im1, j, jb, k, kp1, nmk
!
!        Given the Householder QR factorization of A, this
!        SUBROUTINE SOLVES THE SYSTEM AX=b. IF THE SYSTEM
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!
!       NOTE - IF mode.NE.2, w IS NEVER ACCESSED.
!
double precision, intent(inout) :: a(mda,n), b(mdb,nb), rnorm(nb)
double precision, intent(in) :: h(n), w(n)
integer, intent(inout) :: ic(n), ir(m)
double precision :: bb, tt
double precision :: ddot, dnrm2
!
k = krank
kp1 = k + 1
if (k .gt. 0) go to 30
!
!        rank=0
!
do jb = 1,nb
   rnorm(jb) = dnrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.d0
   end do
end do
return
!
30 i = 0
!
!     Reorder b to reflect row interchanges
!
40 i = i + 1
   if (i .eq. m) go to 100
   j = ir(i)
   if (j .eq. i) go to 40
   if (j .lt. 0) go to 40
!
   ir(i) = -ir(i)
   do jb = 1,nb
      rnorm(jb) = b(i,jb)
   end do
!
   ij = i
60 do jb = 1,nb
         b(ij,jb) = b(j,jb)
      end do
      ij = j
      j = ir(ij)
      ir(ij) = -ir(ij)
   if (j .ne. i) go to 60
!
   do jb = 1,nb
      b(ij,jb) = rnorm(jb)
   end do
   go to 40
!
100 do i = 1,m
   ir(i) = iabs(ir(i))
end do
!
!     Apply Householder transformations to b
!
do j = 1,k
   tt = a(j,j)
   a(j,j) = h(j)
   do i = 1,nb
      bb = -ddot (m-j+1,a(j,j),1,b(j,i),1)/h(j)
      call daxpy (m-j+1,bb,a(j,j),1,b(j,i),1)
   end do
   a(j,j) = tt
end do
!
!        Find norms of residual VECTOR(S)..(before overwrite b)
!
do jb = 1,nb
   rnorm(jb) = dnrm2(m-k,b(kp1,jb),1)
end do
!
!     Back solve upper triangular R
!
i = k
150 do jb = 1,nb
   b(i,jb) = b(i,jb)/a(i,i)
end do
if (i .eq. 1) go to 200
im1 = i - 1
do jb = 1,nb
   call daxpy (im1,-b(i,jb),a(1,i),1,b(1,jb),1)
end do
i = im1
go to 150
!
!     RANK LT n
!
!      Truncated solution
!
200 if (k .eq. n) go to 230
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.d0
   end do
end do
if (mode .eq. 1) go to 230
!
!      Minimal length solution
!
nmk = n - k
do jb = 1,nb
   do i = 1,k
      tt = -ddot(nmk,a(i,kp1),mda,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call daxpy (nmk,tt,a(i,kp1),mda,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!
!     Reorder b to reflect column interchanges
!
230 i = 0
!
240 i = i + 1
   if (i .eq. n) go to 260
   j = ic(i)
   if (j .eq. i) go to 240
   if (j .lt. 0) go to 240
!
   ic(i) = -ic(i)
250 call dswap (nb,b(j,1),mdb,b(i,1),mdb)
      ij = ic(j)
      ic(j) = -ic(j)
      j = ij
   if (j .ne. i) go to 250
   go to 240
!
260 do i = 1,n
   ic(i) = iabs(ic(i))
end do
return
end subroutine du12ls

subroutine du11us (a,mda,m,n,ub,db,mode,np,krank,ksure,h,w,eb, &
&ir,ic)
implicit none
integer, intent(out) :: krank
integer, intent(inout) :: ksure
integer, intent(in) :: m, mda, mode, n, np
integer :: i, ii, im1, imin, is, j, jm1, jmax, jp1, kk, km1, kmi, &
&kp1, kz, l, lm1, mmk, nn
integer :: idamax
!
!       This routine performs an LQ factorization of the
!       matrix a using Householder transformations. Row
!       and column pivots are chosen to reduce the growth
!       of round-off and to help detect possible rank
!       deficiency.
!
double precision, intent(inout) :: a(mda,n), ub(m), db(m), h(m), &
&w(m), eb(m)
integer, intent(inout) :: ic(n), ir(m)
double precision :: bb, rmin, r2, sum, t, temp, tn, tt
double precision :: ddot, dnrm2
!
!        Initialization
!
j = 0
krank = m
do i = 1,n
   ic(i) = i
end do
do i = 1,m
   ir(i) = i
end do
!
!        Determine rel and abs error vectors
!
!
!        Calculate row length
!
do i = 1,m
   h(i) = dnrm2(n,a(i,1),mda)
   w(i) = h(i)
end do
!
!         Initialize error bounds
!
do i = 1,m
   eb(i) = dmax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.d0
end do
!
!          Discard self dependent rows
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          Matrix reduction
!
60 kk = krank
krank = krank - 1
if (mode .eq. 0) return
if (i .le. np) go to 400
if (i .gt. krank) go to 70
call dswap (1,eb(i),1,eb(kk),1)
call dswap (1,ub(i),1,ub(kk),1)
call dswap (1,w(i),1,w(kk),1)
call dswap (1,h(i),1,h(kk),1)
call iswap (1,ir(i),1,ir(kk),1)
call dswap (n,a(i,1),mda,a(kk,1),mda)
go to 50
!
!           Test for zero rank
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        m A i n    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH ROW HAS NN=n-j+1 COMPONENTS
!
nn = n - j + 1
!
!         ub determines row pivot
!
110 imin = j
if (h(j) .eq. 0.d0) go to 170
rmin = ub(j)/h(j)
do 120 i = j,kz
   if (ub(i) .ge. h(i)*rmin) go to 120
   rmin = ub(i)/h(i)
   imin = i
120 continue
!
!     Test for rank deficiency
!
if (rmin .lt. 1.d0) go to 200
tt = (eb(imin) + dabs(db(imin)))/h(imin)
if (tt .ge. 1.d0) go to 170
!
!     Compute exact ub
!
do i = 1,jm1
   w(i) = a(imin,i)
end do
!
l = jm1
130 w(l) = w(l)/a(l,l)
if (l .eq. 1) go to 150
lm1 = l - 1
do i = l,jm1
   w(lm1) = w(lm1) - a(i,lm1)*w(i)
end do
l = lm1
go to 130
!
150 tt = eb(imin)
do i = 1,jm1
   tt = tt + dabs(w(i))*eb(i)
end do
ub(imin) = tt
if (ub(imin)/h(imin) .ge. 1.d0) go to 170
go to 200
!
!        Matrix reduction
!
170 kk = krank
krank = krank - 1
kz = krank
if (mode .eq. 0) return
if (j .le. np) go to 410
if (imin .gt. krank) go to 180
   call iswap (1,ir(imin),1,ir(kk),1)
   call dswap (n,a(imin,1),mda,a(kk,1),mda)
   call dswap (1,eb(imin),1,eb(kk),1)
   call dswap (1,ub(imin),1,ub(kk),1)
   call dswap (1,db(imin),1,db(kk),1)
   call dswap (1,w(imin),1,w(kk),1)
   call dswap (1,h(imin),1,h(kk),1)
180 if (j .gt. krank) go to 300
go to 110
!
!        Row pivot
!
200 if (imin .eq. j) go to 210
call dswap (1,h(j),1,h(imin),1)
call dswap (n,a(j,1),mda,a(imin,1),mda)
call dswap (1,eb(j),1,eb(imin),1)
call dswap (1,ub(j),1,ub(imin),1)
call dswap (1,db(j),1,db(imin),1)
call dswap (1,w(j),1,w(imin),1)
call iswap (1,ir(j),1,ir(imin),1)
!
!        Column pivot
!
210 jmax = idamax(nn,a(j,j),mda)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call dswap (m,a(1,j),1,a(1,jmax),1)
call iswap (1,ic(j),1,ic(jmax),1)
!
!     Apply Householder transformation
!
220 tn = dnrm2(nn,a(j,j),mda)
if (tn .eq. 0.d0) go to 170
if (a(j,j) .ne. 0.d0) tn = dsign(tn,a(j,j))
call dscal (nn,1.d0/tn,a(j,j),mda)
a(j,j) = a(j,j) + 1.d0
if (j .eq. m) go to 250
do 240 i = jp1,m
   bb = -ddot(nn,a(j,j),mda,a(i,j),mda)/a(j,j)
   call daxpy (nn,bb,a(j,j),mda,a(i,j),mda)
   if (i .le. np) go to 240
   if (h(i) .eq. 0.d0) go to 240
   tt = 1.0 - (a(i,j)/h(i))**2
   tt = dmax1(tt,0.d0)
   t = tt
   tt = 1.d0 + 0.05d0*tt*(h(i)/w(i))**2
   if (tt .eq. 1.d0) go to 230
      h(i) = h(i)*dsqrt(t)
      go to 240
230 h(i) = dnrm2(n-j,a(i,j+1),mda)
   w(i) = h(i)
240 continue
!
250 h(j) = a(j,j)
a(j,j) = -tn
!
!          Update ub, db
!
ub(j) = ub(j)/dabs(a(j,j))
db(j) = (dsign(eb(j),db(j)) + db(j))/a(j,j)
if (j .eq. krank) go to 300
do i = jp1,krank
   ub(i) = ub(i) + dabs(a(i,j))*ub(j)
   db(i) = db(i) - a(i,j)*db(j)
end do
go to 100
!
!        E n D    m A i n    L O O P
!
300 continue
!
!        Compute ksure
!
km1 = krank - 1
do i = 1,km1
   is = 0
   kmi = krank - i
   do 310 ii = 1,kmi
      if (ub(ii) .le. ub(ii + 1)) go to 310
      is = 1
      temp = ub(ii)
      ub(ii) = ub(ii + 1)
      ub(ii + 1) = temp
310 continue
   if (is .eq. 0) go to 320
end do
!
320 ksure = 0
sum = 0.d0
do i = 1,krank
   r2 = ub(i)*ub(i)
   if (r2 + sum .ge. 1.d0) go to 330
   sum = sum + r2
   ksure = ksure + 1
end do
!
!     IF SYSTEM IS OF REDUCED RANK AND mode = 2
!     complete the decomposition for shortest least squares solution
!
330 if (krank .eq. m .or. mode .lt. 2) return
mmk = m - krank
kp1 = krank + 1
i = krank
340 tn = dnrm2(mmk,a(kp1,i),1)/a(i,i)
   tn = a(i,i)*dsqrt(1.d0 + tn*tn)
   call dscal (mmk,1.d0/tn,a(kp1,i),1)
   w(i) = a(i,i)/tn + 1.d0
   a(i,i) = -tn
   if (i .eq. 1) go to 350
   im1 = i - 1
   do ii = 1,im1
      tt = -ddot(mmk,a(kp1,ii),1,a(kp1,i),1)/w(i)
      tt = tt - a(i,ii)
      call daxpy (mmk,tt,a(kp1,i),1,a(kp1,ii),1)
      a(i,ii) = a(i,ii) + tt*w(i)
   end do
   i = i - 1
   go to 340
!
350 continue
return
!
!     First np rows are linearly dependent
!
400 krank = i - 1
return
410 krank = j - 1
return
end subroutine du11us

subroutine du12us (a,mda,m,n,b,mdb,nb,mode,krank,rnorm,h,w,ir,ic)
implicit none
integer, intent(in) :: krank, m, mda, mdb, mode, n, nb
integer :: i, ij, ip1, j, jb, k, kp1, mmk
!
!        Given the Householder LQ factorization of A, this
!        SUBROUTINE SOLVES THE SYSTEM AX=b. IF THE SYSTEM
!        is of reduced rank, this routine returns a solution
!        according to the selected mode.
!
!       NOTE - IF mode.NE.2, w IS NEVER ACCESSED.
!
double precision, intent(inout) :: a(mda,n), b(mdb,nb), rnorm(nb)
double precision, intent(in) :: h(m), w(m)
integer, intent(inout) :: ic(n), ir(m)
double precision :: bb, tt
double precision :: ddot, dnrm2
!
k = krank
kp1 = k + 1
if (k .gt. 0) go to 30
!
!        rank=0
!
do jb = 1,nb
   rnorm(jb) = dnrm2(m,b(1,jb),1)
end do
do jb = 1,nb
   do i = 1,n
      b(i,jb) = 0.d0
   end do
end do
return
!
30 i = 0
!
!     Reorder b to reflect row interchanges
!
40 i = i + 1
   if (i .eq. m) go to 100
   j = ir(i)
   if (j .eq. i) go to 40
   if (j .lt. 0) go to 40
!
   ir(i) = -ir(i)
   do jb = 1,nb
      rnorm(jb) = b(i,jb)
   end do
!
   ij = i
60 do jb = 1,nb
         b(ij,jb) = b(j,jb)
      end do
      ij = j
      j = ir(ij)
      ir(ij) = -ir(ij)
   if (j .ne. i) go to 60
!
   do jb = 1,nb
      b(ij,jb) = rnorm(jb)
   end do
   go to 40
!
100 do i = 1,m
   ir(i) = iabs(ir(i))
end do
!
!     IF A IS OF REDUCED RANK AND mode=2,
!     apply Householder transformations to b
!
if (mode .lt. 2 .or. k .eq. m) go to 140
mmk = m - k
do jb = 1,nb
   do j = 1,k
      i = kp1 - j
      tt = -ddot(mmk,a(kp1,i),1,b(kp1,jb),1)/w(i)
      tt = tt - b(i,jb)
      call daxpy (mmk,tt,a(kp1,i),1,b(kp1,jb),1)
      b(i,jb) = b(i,jb) + tt*w(i)
   end do
end do
!
!     Find norms of residual VECTOR(S)..(before overwrite b)
!
140 do jb = 1,nb
   rnorm(jb) = dnrm2(m-k,b(kp1,jb),1)
end do
!
!     Back solve lower triangular L
!
do 170 jb = 1,nb
   do i = 1,k
      b(i,jb) = b(i,jb)/a(i,i)
      if (i .eq. k) go to 170
      ip1 = i + 1
      call daxpy(k-i,-b(i,jb),a(ip1,i),1,b(ip1,jb),1)
   end do
170 continue
!
!      Truncated solution
!
if (k .eq. n) go to 210
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.d0
   end do
end do
!
!     Apply Householder transformations to b
!
210 do i = 1,k
   j = kp1 - i
   tt = a(j,j)
   a(j,j) = h(j)
   do jb = 1,nb
      bb = -ddot(n-j+1,a(j,j),mda,b(j,jb),1)/h(j)
      call daxpy(n-j+1,bb,a(j,j),mda,b(j,jb),1)
   end do
   a(j,j) = tt
end do
!
!     Reorder b to reflect column interchanges
!
i = 0
!
240 i = i + 1
   if (i .eq. n) go to 260
   j = ic(i)
   if (j .eq. i) go to 240
   if (j .lt. 0) go to 240
!
   ic(i) = -ic(i)
250 call dswap (nb,b(j,1),mdb,b(i,1),mdb)
      ij = ic(j)
      ic(j) = -ic(j)
      j = ij
   if (j .ne. i) go to 250
   go to 240
!
260 do i = 1,n
   ic(i) = iabs(ic(i))
end do
return
end subroutine du12us

subroutine hfti (a,mda,m,n,b,mdb,nb,tau,k,rnorm,h,g,ip)
implicit none
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
real, intent(inout) :: a(mda,n), b(mdb,*), g(n), h(n), rnorm(*)
real, intent(in) :: tau
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
real :: factor, hmax, sm1, tmp, z
!-----------------------------------------------------------------------
!     dimension a(mda,n),(b(mdb,nb) or b(m)),rnorm(nb),h(n),g(n),ip(n)
!
!     Written by C.L. Lawson and R.J. Hanson.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!
!     Abstract
!
!     This subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!
!     This set of problems can also be written as the matrix least
!     squares problem
!
!                       ax = b,
!
!     Where X is the n by nb solution matrix.
!
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!
!                       abs(R(i,i)).GE.abs(R(i+1,i+1)),
!
!                       i = 1,...,l-1, where
!
!                       l = min(m,n).
!
!     The subroutine sets k to be the number of diagonal elements
!     of R that exceed tau in magnitude. Then the solution of minimum
!     Euclidean length is computed using the first k rows of (R C).
!
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!
!     The entire set of parameters for hfti are
!
!     Input..
!
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       MATRIX a OF THE LEAST SQUARES PROBLEM AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) IS mda, WHICH MUST SATISFY mda.GE.m
!                       EITHER m.GE.n OR m.LT.n IS PERMITTED.  THERE
!                       is no restriction on the rank of A.  the
!                       CONDITION mda.LT.m IS CONSIDERED AN ERROR.
!
!     b(*),MDB,nb       IF nb = 0 THE SUBROUTINE WILL PERFORM THE
!                       orthogonal decomposition but will make no
!                       REFERENCES TO THE ARRAY b(*).  IF nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb MATRIX b OF THE LEAST SQUARES PROBLEM AX =
!                       b.  IF nb.GE.2 THE ARRAY b(*) MUST BE DOUBLY
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  IF nb = 1 THE ARRAY b(*) MAY
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       VALUE SUCH AS mdb = m.
!
!                       THE CONDITION OF nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY hfti.
!
!     Output..
!
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!
!     rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!-----------------------------------------------------------------------
integer, intent(inout) :: ip(n)
double precision :: sm
!---------------------
data factor /1.e-3/
!
k = 0
ldiag = min0(m,n)
if (ldiag .le. 0) go to 270
    do 80 j = 1,ldiag
    if (j .eq. 1) go to 20
!
!     Update squared column lengths and find lmax
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     Compute squared column lengths and find lmax
!    ..
20 lmax=j
        do l = j,n
        h(l) = 0.0
            do 30 i = j,m
30 h(l) = h(l) + a(i,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    hmax = h(lmax)
!    ..
!     lmax has been determined
!
!     Do column interchanges if needed.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call h12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call h12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     Determine the pseudorank, k, using the tolerance, tau.
!    ..
    do j = 1,ldiag
    if (abs(a(j,j)) .le. tau) go to 100
    end do
k = ldiag
go to 110
100 k = j - 1
110 kp1 = k + 1
!
!     Compute the norms of the residual vectors.
!
if (nb .le. 0) go to 140
    do 130 jb = 1,nb
    tmp = 0.0
    if (kp1 .gt. m) go to 130
        do 120 i = kp1,m
120 tmp = tmp + b(i,jb)**2
130 rnorm(jb) = sqrt(tmp)
140 continue
!                                           SPECIAL FOR PSEUDORANK = 0
if (k .gt. 0) go to 160
if (nb .le. 0) go to 270
    do jb = 1,nb
        do 150 i = 1,n
150 b(i,jb) = 0.0
    end do
go to 270
!
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k .eq. n) go to 180
    do 170 ii = 1,k
    i = kp1 - ii
170 call h12 (1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i-1)
180 continue
!
!
if (nb .le. 0) go to 270
    do jb = 1,nb
!
!     Solve the k by k triangular system.
!    ..
        do 210 l = 1,k
        sm = 0.d0
        i = kp1 - l
        if (i .eq. k) go to 200
        ip1 = i + 1
            do 190 j = ip1,k
190 sm = sm + dble(a(i,j))*dble(b(j,jb))
200 sm1 = dble(b(i,jb)) - sm
210 b(i,jb) = sm1/a(i,i)
!
!     Complete computation of solution vector.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.0
        do 230 i = 1,k
230 call h12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do 250 jj = 1,ldiag
        j = ldiag + 1 - jj
        if (ip(j) .eq. j) go to 250
        l = ip(j)
        tmp = b(l,jb)
        b(l,jb) = b(j,jb)
        b(j,jb) = tmp
250 continue
    end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
!
270 return
end subroutine hfti

subroutine hfti2(a,mda,m,n,b,mdb,nb,d,tau,k,rnorm,h,g,ip,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
real, intent(inout) :: a(mda,n), b(mdb,*), d(*), g(n), h(n), &
&rnorm(*)
real, intent(in) :: tau
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
real :: factor, hmax, sm1, tmp, z
!-----------------------------------------------------------------------
!     dimension a(mda,n),(b(mdb,nb) or b(m))
!     dimension d(l) where l = min(m,n)
!     dimension rnorm(nb),h(n),g(n),ip(n)
!
!     Written by C.L. Lawson and R.J. Hanson. Modified by A.H. Morris.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!
!     Abstract
!
!     This subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!
!     This set of problems can also be written as the matrix least
!     squares problem
!
!                       ax = b,
!
!     Where X is the n by nb solution matrix.
!
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!
!                       abs(R(i,i)).GE.abs(R(i+1,i+1)),
!
!                       i = 1,...,l-1, where
!
!                       l = min(m,n).
!
!     The array d will contain the diagonal elements R(1,1),...,R(l,l).
!     The subroutine sets k to be the number of diagonal elements that
!     exceed tau in magnitude.  Then the solution of minimum Euclidean
!     length is computed using the first k rows of (R C).
!
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!
!     The entire set of parameters for hfti2 are
!
!     Input..
!
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       MATRIX a OF THE LEAST SQUARES PROBLEM AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) IS mda, WHICH MUST SATISFY mda.GE.m
!                       EITHER m.GE.n OR m.LT.n IS PERMITTED.  THERE
!                       is no restriction on the rank of A.  the
!                       CONDITION mda.LT.m IS CONSIDERED AN ERROR.
!
!     b(*),MDB,nb       IF nb = 0 THE SUBROUTINE WILL PERFORM THE
!                       orthogonal decomposition but will make no
!                       REFERENCES TO THE ARRAY b(*).  IF nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb MATRIX b OF THE LEAST SQUARES PROBLEM AX =
!                       b.  IF nb.GE.2 THE ARRAY b(*) MUST BE DOUBLY
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  IF nb = 1 THE ARRAY b(*) MAY
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       VALUE SUCH AS mdb = m.
!
!                       THE CONDITION OF nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY hfti2.
!
!     Output..
!
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!
!     d(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!                       triangular matrix R
!
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!
!     RNORM(*)          ON RETURN, RNORM(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!
!     ierr              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!                       detected then ierr is set to 0. Otherwise
!                          ierr = 1  IF mda.LT.m
!                          ierr = 2  IF nb.GT.1 AND mdb.LT.max(m,n)
!                       these errors are fatal.
!-----------------------------------------------------------------------
integer, intent(inout) :: ip(n)
double precision :: sm
!---------------------
data factor /1.e-3/
!
k = 0
ldiag = min0(m,n)
if (ldiag .le. 0) go to 270
if (m .gt. mda) go to 300
if (nb .gt. 1 .and. max0(m,n) .gt. mdb) go to 310
!
    do 80 j = 1,ldiag
    if (j .eq. 1) go to 20
!
!     Update squared column lengths and find lmax
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
        do l = j,n
        h(l) = 0.0
            do 30 i = j,m
30 h(l) = h(l) + a(i,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    hmax = h(lmax)
!    ..
!     lmax has been determined
!
!     Do column interchanges if needed.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call h12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call h12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     Determine the pseudorank, k, using the tolerance, tau.
!     Also store the diagonal elements in the array d.
!    ..
    do 90 j = 1,ldiag
    if (abs(a(j,j)) .le. tau) go to 100
90 d(j) = a(j,j)
    k = ldiag
    kp1 = k + 1
    go to 110
!
100 k = j - 1
    kp1 = j
    do 105 j = kp1,ldiag
105 d(j) = a(j,j)
!
!     Compute the norms of the residual vectors.
!
110 if (nb .le. 0) go to 140
    do 130 jb = 1,nb
    tmp = 0.0
    if (kp1 .gt. m) go to 130
        do 120 i = kp1,m
120 tmp = tmp + b(i,jb)**2
130 rnorm(jb) = sqrt(tmp)
140 continue
!                                           SPECIAL FOR PSEUDORANK = 0
if (k .gt. 0) go to 160
if (nb .le. 0) go to 270
    do jb = 1,nb
        do 150 i = 1,n
150 b(i,jb) = 0.0
    end do
go to 270
!
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k .eq. n) go to 180
    do 170 ii = 1,k
    i = kp1 - ii
170 call h12 (1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i-1)
180 continue
!
!
if (nb .le. 0) go to 270
    do jb = 1,nb
!
!     Solve the k by k triangular system.
!    ..
        do 210 l = 1,k
        sm = 0.d0
        i = kp1 - l
        if (i .eq. k) go to 200
        ip1 = i + 1
            do 190 j = ip1,k
190 sm = sm + dble(a(i,j))*dble(b(j,jb))
200 sm1 = dble(b(i,jb)) - sm
210 b(i,jb)=sm1/a(i,i)
!
!     Complete computation of solution vector.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.0
        do 230 i = 1,k
230 call h12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do 250 jj = 1,ldiag
        j = ldiag + 1 - jj
        if (ip(j) .eq. j) go to 250
        l = ip(j)
        tmp = b(l,jb)
        b(l,jb) = b(j,jb)
        b(j,jb) = tmp
250 continue
    end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
!
270 ierr = 0
return
!
!     Error return
!
300 ierr = 1
return
310 ierr = 2
return
end subroutine hfti2

subroutine h12 (mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv)
implicit none
integer, intent(in) :: ice, icv, iue, l1, lpivot, m, mode, ncv
real, intent(inout) :: c(*), u(iue,m), up
integer :: i, i2, i3, i4, incr, j
real :: cl, d, sm1
!-----------------------------------------------------------------------
!     Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!
!     Construction and/or application of a single
!     HOUSEHOLDER TRANSFORMATION..     Q = i + u*(u**T)/b
!
!     mode    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
!     lpivot is the index of the pivot element.
!     l1,m   IF l1 .LE. m   THE TRANSFORMATION WILL BE CONSTRUCTED TO
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
!     ncv    NUMBER OF VECTORS IN c() TO BE TRANSFORMED. IF ncv .LE. 0
!            no operations will be done on c().
!-----------------------------------------------------------------------
double precision :: sm, b
!
if (0 .ge. lpivot .or. lpivot .ge. l1 .or. l1 .gt. m) return
cl = abs(u(1,lpivot))
if (mode .eq. 2) go to 60
!
!                            ****** CONSTRUCT THE TRANSFORMATION. ******
!
    do 10 j = l1,m
10 cl = amax1(abs(u(1,j)),cl)
if (cl .le. 0.0) go to 130
d = u(1,lpivot)/cl
sm = d*d
    do 20 j = l1,m
    d = u(1,j)/cl
20 sm = sm + dble(d*d)
!
sm1 = sm
cl = cl*sqrt(sm1)
if (u(1,lpivot) .gt. 0.0) cl = -cl
up = u(1,lpivot) - cl
u(1,lpivot) = cl
go to 70
!
!            ****** APPLY THE TRANSFORMATION  i+u*(u**T)/b  TO c. ******
!
60 if (cl) 130,130,70
70 if (ncv .le. 0) return
b = dble(up)*dble(u(1,lpivot))
!
!                       b  MUST BE NONPOSITIVE HERE.  IF b = 0., RETURN.
!
if (b .ge. 0.d0) go to 130
b = 1.d0/b
i2 = 1 - icv + ice*(lpivot - 1)
incr = ice*(l1 - lpivot)
    do 120 j = 1,ncv
    i2 = i2 + icv
    i3 = i2 + incr
    i4 = i3
    sm = dble(c(i2))*dble(up)
        do 90 i = l1,m
        sm = sm + dble(c(i3))*dble(u(1,i))
90 i3 = i3 + ice
    if (sm .eq. 0.d0) go to 120
    sm = sm*b
    c(i2) = c(i2) + sm*dble(up)
        do 110 i = l1,m
        c(i4) = c(i4) + sm*dble(u(1,i))
110 i4 = i4 + ice
120 continue
130 return
end subroutine h12

subroutine dhfti (a,mda,m,n,b,mdb,nb,tau,k,rnorm,h,g,ip)
implicit none
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
!-----------------------------------------------------------------------
!     double precision a(mda,n),(b(mdb,nb) or b(m))
!     double precision tau,rnorm(nb),h(n),g(n)
!     integer ip(n)
!
!     Written by C.L. Lawson and R.J. Hanson.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!
!     Abstract
!
!     This subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!
!     This set of problems can also be written as the matrix least
!     squares problem
!
!                       ax = b,
!
!     Where X is the n by nb solution matrix.
!
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!
!                       dabs(R(i,i)).GE.dabs(R(i+1,i+1)),
!
!                       i = 1,...,l-1, where
!
!                       l = min(m,n).
!
!     The subroutine sets k to be the number of diagonal elements
!     of R that exceed tau in magnitude. Then the solution of minimum
!     Euclidean length is computed using the first k rows of (R C).
!
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!
!     The entire set of parameters for dhfti are
!
!     Input..
!
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       MATRIX a OF THE LEAST SQUARES PROBLEM AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) IS mda, WHICH MUST SATISFY mda.GE.m
!                       EITHER m.GE.n OR m.LT.n IS PERMITTED.  THERE
!                       is no restriction on the rank of A.  the
!                       CONDITION mda.LT.m IS CONSIDERED AN ERROR.
!
!     b(*),MDB,nb       IF nb = 0 THE SUBROUTINE WILL PERFORM THE
!                       orthogonal decomposition but will make no
!                       REFERENCES TO THE ARRAY b(*).  IF nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb MATRIX b OF THE LEAST SQUARES PROBLEM AX =
!                       b.  IF nb.GE.2 THE ARRAY b(*) MUST BE DOUBLY
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  IF nb = 1 THE ARRAY b(*) MAY
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       VALUE SUCH AS mdb = m.
!
!                       THE CONDITION OF nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY dhfti.
!
!     Output..
!
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!
!     rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(mda,n), b(mdb,*)
double precision, intent(in) :: tau
double precision, intent(inout) :: rnorm(*), h(n), g(n)
integer, intent(inout) :: ip(n)
double precision :: factor, hmax, sm, sm1, tmp, z
!---------------------
data factor /1.d-3/
!
k = 0
ldiag = min0(m,n)
if (ldiag .le. 0) go to 270
    do 80 j = 1,ldiag
    if (j .eq. 1) go to 20
!
!     Update squared column lengths and find lmax
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     Compute squared column lengths and find lmax
!    ..
20 lmax=j
        do l = j,n
        h(l) = 0.d0
            do 30 i = j,m
30 h(l) = h(l) + a(i,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    hmax = h(lmax)
!    ..
!     lmax has been determined
!
!     Do column interchanges if needed.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call dh12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call dh12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     Determine the pseudorank, k, using the tolerance, tau.
!    ..
    do j = 1,ldiag
    if (dabs(a(j,j)) .le. tau) go to 100
    end do
k = ldiag
go to 110
100 k = j - 1
110 kp1 = k + 1
!
!     Compute the norms of the residual vectors.
!
if (nb .le. 0) go to 140
    do 130 jb = 1,nb
    tmp = 0.d0
    if (kp1 .gt. m) go to 130
        do 120 i = kp1,m
120 tmp = tmp + b(i,jb)**2
130 rnorm(jb) = dsqrt(tmp)
140 continue
!                                           SPECIAL FOR PSEUDORANK = 0
if (k .gt. 0) go to 160
if (nb .le. 0) go to 270
    do jb = 1,nb
        do 150 i = 1,n
150 b(i,jb) = 0.d0
    end do
go to 270
!
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k .eq. n) go to 180
    do 170 ii = 1,k
    i = kp1 - ii
170 call dh12 (1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i-1)
180 continue
!
!
if (nb .le. 0) go to 270
    do jb = 1,nb
!
!     Solve the k by k triangular system.
!    ..
        do 210 l = 1,k
        sm = 0.d0
        i = kp1 - l
        if (i .eq. k) go to 200
        ip1 = i + 1
            do 190 j = ip1,k
190 sm = sm + a(i,j)*b(j,jb)
200 sm1 = b(i,jb) - sm
210 b(i,jb) = sm1/a(i,i)
!
!     Complete computation of solution vector.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.d0
        do 230 i = 1,k
230 call dh12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do 250 jj = 1,ldiag
        j = ldiag + 1 - jj
        if (ip(j) .eq. j) go to 250
        l = ip(j)
        tmp = b(l,jb)
        b(l,jb) = b(j,jb)
        b(j,jb) = tmp
250 continue
    end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
!
270 return
end subroutine dhfti

subroutine dhfti2(a,mda,m,n,b,mdb,nb,d,tau,k,rnorm,h,g,ip,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
integer :: i, ii, ip1, j, jb, jj, kp1, l, ldiag, lmax
!-----------------------------------------------------------------------
!     double precision a(mda,n),(b(mdb,nb) or b(m))
!     double precision d(l) where l = min(m,n)
!     double precision tau,rnorm(nb),h(n),g(n)
!     integer ip(n)
!
!     Written by C.L. Lawson and R.J. Hanson. Modified by A.H. Morris.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!     For algorithmic details see algorithm hfti in chapter 14.
!
!     Abstract
!
!     This subroutine solves a linear least squares problem or a set of
!     linear least squares problems having the same matrix but different
!     right-side vectors.  The problem data consists of an m by n matrix
!     A, an m by nb matrix b, and an absolute tolerance parameter tau
!     whose usage is described below.  The nb column vectors of b
!     represent right-side vectors for nb distinct linear least squares
!     problems.
!
!     This set of problems can also be written as the matrix least
!     squares problem
!
!                       ax = b,
!
!     Where X is the n by nb solution matrix.
!
!     Note that if b is the m by m identity matrix, then X will be the
!     pseudo-inverse of A.
!
!     This subroutine first transforms the augmented matrix (A b) to A
!     matrix (R C) using premultiplying Householder transformations with
!     column interchanges.  All subdiagonal elements in the matrix R are
!     zero and its diagonal elements satisfy
!
!                       dabs(R(i,i)).GE.dabs(R(i+1,i+1)),
!
!                       i = 1,...,l-1, where
!
!                       l = min(m,n).
!
!     The array d will contain the diagonal elements R(1,1),...,R(l,l).
!     The subroutine sets k to be the number of diagonal elements that
!     exceed tau in magnitude.  Then the solution of minimum Euclidean
!     length is computed using the first k rows of (R C).
!
!     To be specific we suggest that the user consider an easily
!     computable matrix NORM, such as, the maximum of all column sums of
!     magnitudes.
!
!     Now if the relative uncertainty of b is eps, (norm of uncertainty/
!     norm of b), it is suggested that tau be set approximately equal to
!     eps*(norm of A).
!
!     The entire set of parameters for dhfti2 are
!
!     Input..
!
!     a(*,*),mda,m,n    THE ARRAY a(*,*) INITIALLY CONTAINS THE m BY n
!                       MATRIX a OF THE LEAST SQUARES PROBLEM AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) IS mda, WHICH MUST SATISFY mda.GE.m
!                       EITHER m.GE.n OR m.LT.n IS PERMITTED.  THERE
!                       is no restriction on the rank of A.  the
!                       CONDITION mda.LT.m IS CONSIDERED AN ERROR.
!
!     b(*),MDB,nb       IF nb = 0 THE SUBROUTINE WILL PERFORM THE
!                       orthogonal decomposition but will make no
!                       REFERENCES TO THE ARRAY b(*).  IF nb.GT.0
!                       the array b(*) must initially contain the m by
!                       nb MATRIX b OF THE LEAST SQUARES PROBLEM AX =
!                       b.  IF nb.GE.2 THE ARRAY b(*) MUST BE DOUBLY
!                       subscripted with first dimensioning parameter
!                       mdb.GE.max(m,n).  IF nb = 1 THE ARRAY b(*) MAY
!                       be either doubly or singly subscripted.  In
!                       the latter case the value of mdb is arbitrary
!                       but it should be set to some valid integer
!                       VALUE SUCH AS mdb = m.
!
!                       THE CONDITION OF nb.GT.1.AND.mdb.LT. max(m,n)
!                       is considered an error.
!
!     tau               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       for pseudorank determination.
!
!     h(*),g(*),ip(*)   ARRAYS OF WORKING SPACE USED BY dhfti2.
!
!     Output..
!
!     a(*,*)            THE CONTENTS OF THE ARRAY a(*,*) WILL BE
!                       modified by the subroutine.  These contents
!                       are not generally required by the user.
!
!     b(*)              ON RETURN THE ARRAY b(*) WILL CONTAIN THE n BY
!                       nb solution matrix X.
!
!     d(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!                       triangular matrix R
!
!     k                 SET BY THE SUBROUTINE TO INDICATE THE
!                       pseudorank of A.
!
!     rnorm(*)          ON RETURN, rnorm(j) WILL CONTAIN THE EUCLIDEAN
!                       norm of the residual vector for the problem
!                       defined by the j-TH column vector of the array
!                       b(*,*) FOR j = 1,...,nb.
!
!     h(*),g(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       elements of the pre- and post-multiplying
!                       Householder transformations used to compute
!                       the minimum Euclidean length solution.
!
!     ip(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       describing the permutation of column vectors.
!                       The contents of arrays h(*),g(*) and ip(*)
!                       are not generally required by the user.
!
!     ierr              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!                       detected then ierr is set to 0. Otherwise
!                          ierr = 1  IF mda.LT.m
!                          ierr = 2  IF nb.GT.1 AND mdb.LT.max(m,n)
!                       these errors are fatal.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(mda,n), b(mdb,*), d(*)
double precision, intent(in) :: tau
double precision, intent(inout) :: rnorm(*), h(n), g(n)
integer, intent(inout) :: ip(n)
double precision :: factor, hmax, sm, sm1, tmp, z
!---------------------
data factor /1.d-3/
!
k = 0
ldiag = min0(m,n)
if (ldiag .le. 0) go to 270
if (m .gt. mda) go to 300
if (nb .gt. 1 .and. max0(m,n) .gt. mdb) go to 310
!
    do 80 j = 1,ldiag
    if (j .eq. 1) go to 20
!
!     Update squared column lengths and find lmax
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
        do l = j,n
        h(l) = 0.d0
            do 30 i = j,m
30 h(l) = h(l) + a(i,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    hmax = h(lmax)
!    ..
!     lmax has been determined
!
!     Do column interchanges if needed.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call dh12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call dh12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     Determine the pseudorank, k, using the tolerance, tau.
!     Also store the diagonal elements in the array d.
!    ..
    do 90 j = 1,ldiag
    if (dabs(a(j,j)) .le. tau) go to 100
90 d(j) = a(j,j)
    k = ldiag
    kp1 = k + 1
    go to 110
!
100 k = j - 1
    kp1 = j
    do 105 j = kp1,ldiag
105 d(j) = a(j,j)
!
!     Compute the norms of the residual vectors.
!
110 if (nb .le. 0) go to 140
    do 130 jb = 1,nb
    tmp = 0.d0
    if (kp1 .gt. m) go to 130
        do 120 i = kp1,m
120 tmp = tmp + b(i,jb)**2
130 rnorm(jb) = dsqrt(tmp)
140 continue
!                                           SPECIAL FOR PSEUDORANK = 0
if (k .gt. 0) go to 160
if (nb .le. 0) go to 270
    do jb = 1,nb
        do 150 i = 1,n
150 b(i,jb) = 0.d0
    end do
go to 270
!
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k .eq. n) go to 180
    do 170 ii = 1,k
    i = kp1 - ii
170 call dh12 (1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i-1)
180 continue
!
!
if (nb .le. 0) go to 270
    do jb = 1,nb
!
!     Solve the k by k triangular system.
!    ..
        do 210 l = 1,k
        sm = 0.d0
        i = kp1 - l
        if (i .eq. k) go to 200
        ip1 = i + 1
            do 190 j = ip1,k
190 sm = sm + a(i,j)*b(j,jb)
200 sm1 = b(i,jb) - sm
210 b(i,jb)=sm1/a(i,i)
!
!     Complete computation of solution vector.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.d0
        do 230 i = 1,k
230 call dh12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-order the solution vector to compensate for the
!      column interchanges.
!    ..
240 do 250 jj = 1,ldiag
        j = ldiag + 1 - jj
        if (ip(j) .eq. j) go to 250
        l = ip(j)
        tmp = b(l,jb)
        b(l,jb) = b(j,jb)
        b(j,jb) = tmp
250 continue
    end do
!    ..
!     The solution vectors, X, are now
!     in the first  n  rows of the array b(,).
!
270 ierr = 0
return
!
!     Error return
!
300 ierr = 1
return
310 ierr = 2
return
end subroutine dhfti2

subroutine dh12 (mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv)
implicit none
integer, intent(in) :: ice, icv, iue, l1, lpivot, m, mode, ncv
integer :: i, i2, i3, i4, incr, j
!-----------------------------------------------------------------------
!     Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!
!     Construction and/or application of a single
!     HOUSEHOLDER TRANSFORMATION..     Q = i + u*(u**T)/b
!
!     mode    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
!     lpivot is the index of the pivot element.
!     l1,m   IF l1 .LE. m   THE TRANSFORMATION WILL BE CONSTRUCTED TO
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
!     ncv    NUMBER OF VECTORS IN c() TO BE TRANSFORMED. IF ncv .LE. 0
!            no operations will be done on c().
!-----------------------------------------------------------------------
double precision, intent(inout) :: u(iue,m), up, c(*)
double precision :: b, cl, d, sm
!
if (0 .ge. lpivot .or. lpivot .ge. l1 .or. l1 .gt. m) return
cl = dabs(u(1,lpivot))
if (mode .eq. 2) go to 60
!
!                            ****** CONSTRUCT THE TRANSFORMATION. ******
!
    do 10 j = l1,m
10 cl = dmax1(dabs(u(1,j)),cl)
if (cl .le. 0.d0) go to 130
d = u(1,lpivot)/cl
sm = d*d
    do 20 j = l1,m
    d = u(1,j)/cl
20 sm = sm + d*d
!
cl = cl*dsqrt(sm)
if (u(1,lpivot) .gt. 0.d0) cl = -cl
up = u(1,lpivot) - cl
u(1,lpivot) = cl
go to 70
!
!            ****** APPLY THE TRANSFORMATION  i+u*(u**T)/b  TO c. ******
!
60 if (cl) 130,130,70
70 if (ncv .le. 0) return
b = up*u(1,lpivot)
!
!                       b  MUST BE NONPOSITIVE HERE.  IF b = 0., RETURN.
!
if (b .ge. 0.d0) go to 130
b = 1.d0/b
i2 = 1 - icv + ice*(lpivot - 1)
incr = ice*(l1 - lpivot)
    do 120 j = 1,ncv
    i2 = i2 + icv
    i3 = i2 + incr
    i4 = i3
    sm = c(i2)*up
        do 90 i = l1,m
        sm = sm + c(i3)*u(1,i)
90 i3 = i3 + ice
    if (sm .eq. 0.d0) go to 120
    sm = sm*b
    c(i2) = c(i2) + sm*up
        do 110 i = l1,m
        c(i4) = c(i4) + sm*u(1,i)
110 i4 = i4 + ice
120 continue
130 return
end subroutine dh12

subroutine lsei(w, mdw, me, ma, mg, n, prgopt, x, rnorme, rnorml, &
&mode, ws, ip)
implicit none
integer, intent(in) :: ma, mdw, me, mg
integer, intent(out) :: mode
integer :: n
real, intent(inout) :: rnorme, rnorml
integer :: i, ii, imax, j, jj, jp1, k, key, kk, kranke, l, last, &
&link, m, mapke1, mdeqc, mend, mep1, n1, n2, next, nlink, nopt, &
&np1, ntimes
real :: enorm, fnorm, gam, half, one, rb, rn, rnmax, size, sn, &
&snmax, srelpr, t, tau, uj, up, vj, xnorm, xnrme, zero
real :: snrm2
real :: sasum
real :: sdot
real :: spmpar
!
!     dimension w(mdw,n+1),prgopt(*),x(n),
!     ws(2*(me+n)+k+(mg+2)*(n+7)),ip(mg+2*n+2)
!     ABOVE, k=max(ma+mg,n).
!
!     Written by R. J. Hanson and K. H. Haskell.  For further math.
!     And algorithmic details see Sandia Laboratories tech. REPTS.
!     SAND77-0552, (1978), and SAND78-1290, (1979), and math.
!     Programming (21), 1981, PP. 98-118. modified by A.H. Morris.
!
!     Abstract
!
!     This subprogram solves a linearly constrained least squares
!     problem with both equality and inequality constraints, and, if the
!     user requests, obtains a covariance matrix of the solution
!     parameters.
!
!     Suppose there are given matrices E, A and G of respective
!     dimensions me by n, ma by n and mg by n, and vectors F, B and H of
!     respective lengths me, ma and mg.  This subroutine solves the
!     linearly constrained least squares problem
!
!                   EX = F, (E ME BY n) (EQUATIONS TO BE EXACTLY
!                                       satisfied)
!                   AX = B, (A ma BY n) (EQUATIONS TO BE
!                                       approximately satisfied,
!                                       least squares sense)
!                   GX.GE.H,(G mg BY n) (INEQUALITY CONSTRAINTS)
!
!     THE INEQUALITIES GX.GE.H MEAN THAT EVERY COMPONENT OF THE PRODUCT
!     GX MUST BE .GE. THE CORRESPONDING COMPONENT OF H.
!
!     In case the equality constraints cannot be satisfied, A
!     generalized inverse solution residual vector LENGTH is obtained
!     for F-EX. This is the minimal length possible for F-EX.
!
!
!     ANY VALUES me.GE.0, ma.GE.0, OR mg.GE.0 ARE PERMITTED.  THE
!     rank of the matrix E is estimated during the computation. We call
!     this value kranke. It is an output parameter in ip(1) defined
!     BELOW. USING A GENERALIZED INVERSE SOLUTION OF EX=F, A REDUCED
!     least squares problem with inequality constraints is obtained.
!     The tolerances used in these tests for determining the rank
!     of E and the rank of the reduced least squares problem are
!     given in sandia tech. Rept. SAND78-1290. They can be
!     modified by the user if new values are provided in
!     the option list of the array prgopt(*).
!
!     The user must dimension all arrays appearing in the call list..
!     w(mdw,n+1),prgopt(*),x(n),ws(2*(me+n)+k+(mg+2)*(n+7)),ip(mg+2*n+2)
!     WHERE k=max(ma+mg,n).  THIS ALLOWS FOR A SOLUTION OF A RANGE OF
!     problems in the given working space.  The dimension of ws(*)
!     given is a necessary overestimate.  Once a particular problem
!     has been run, the output parameter ip(3) gives the actual
!     dimension required for that problem.
!
!     The parameters for lsei( ) are
!
!     Input..
!
!     w(*,*),mdw,   THE ARRAY w(*,*) IS DOUBLY SUBSCRIPTED WITH
!     ME,ma,mg,n    FIRST DIMENSIONING PARAMETER EQUAL TO mdw.
!                   FOR THIS DISCUSSION LET US CALL M = me+ma+mg.  THEN
!                   mdw MUST SATISFY mdw.GE.M.  THE CONDITION
!                   mdw.LT.M IS AN ERROR.
!
!                   The array w(*,*) contains the matrices and vectors
!
!                                  (E  F)
!                                  (A  B)
!                                  (G  H)
!
!                   In rows and columns 1,...,M and 1,...,n+1
!                   respectively.
!
!                   The integers me, ma, and mg are the
!                   respective matrix ROW dimensions
!                   of E, A and G. each matrix HAS n columns.
!
!     prgopt(*)    THIS REAL-VALUED ARRAY IS THE OPTION VECTOR.
!                  If the user is satisfied with the nominal
!                  subprogram features set
!
!                  prgopt(1)=1 (OR prgopt(1)=1.0)
!
!                  Otherwise prgopt(*) is a linked list consisting of
!                  groups of data of the following form
!
!                  Link
!                  key
!                  data set
!
!                  The parameters link and key are each one word.
!                  The data set can be comprised of several words.
!                  The number of items depends on the value of key.
!                  The value of link points to the first
!                  entry of the next group of data within
!                  prgopt(*).  The exception is when there are
!                  no more options to change.  In that
!                  CASE LINK=1 AND THE VALUES KEY AND DATA SET
!                  are not referenced. The general layout of
!                  prgopt(*) is as follows.
!
!               ...prgopt(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!               .  prgopt(2)=KEY1 (KEY TO THE OPTION CHANGE)
!               .  prgopt(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!               .       .
!               .       .
!               .       .
!               ...prgopt(LINK1)=LINK2 (LINK TO THE FIRST ENTRY OF
!               .                       NEXT GROUP)
!               .  prgopt(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!               .  prgopt(LINK1+2)=DATA VALUE
!               ...     .
!               .       .
!               .       .
!               ...prgopt(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!
!                  Values of link that are nonpositive are errors.
!                  A VALUE OF LINK.GT.NLINK=100000 IS ALSO AN ERROR.
!                  This helps prevent using invalid but positive
!                  values of link that will probably extend
!                  beyond the program limits of prgopt(*).
!                  Unrecognized values of key are ignored.  The
!                  order of the options is arbitrary and any number
!                  of options can be changed with the following
!                  restriction.  To prevent cycling in the
!                  processing of the option array A count of the
!                  number of options changed is maintained.
!                  WHENEVER THIS COUNT EXCEEDS NOPT=1000 THE
!                  routine terminates.
!
!                  Options..
!
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
!                  OF THE ARRAY w(*,*) MUST SATISFY mdw.GE.MAX0(M,n).
!
!                  key=2
!                         scale the nonzero columns of the
!                         entire data matrix.
!                  (E)
!                  (A)
!                  (G)
!
!                  To have length one.  The data set for this
!                  option is a single value.  It must be
!                  nonzero if unit length column scaling
!                  is desired.
!
!                  key=3
!                         scale columns of the entire data matrix
!                  (E)
!                  (A)
!                  (G)
!
!                  With a user-provided diagonal matrix.
!                  The data set for this option consists
!                  of the n diagonal scaling factors, one for
!                  each matrix column.
!
!                  key=4
!                         change the rank determination tolerance for
!                  the equality constraint equations from
!                  the nominal value of sqrt(SRELPR).  This quantity
!                  can be no smaller than SRELPR, the arithmetic-
!                  storage precision.  The quantity SRELPR is the
!                  LARGEST POSITIVE NUMBER SUCH THAT T=1.+SRELPR
!                  SATISFIES T.EQ.1.  THE QUANTITY USED
!                  here is internally restricted to be at
!                  least SRELPR.  The data set for this option
!                  is the new tolerance.
!
!                  key=5
!                         change the rank determination tolerance for
!                  the reduced least squares equations from
!                  the nominal value of sqrt(SRELPR).  This quantity
!                  can be no smaller than SRELPR, the arithmetic-
!                  storage precision.  The quantity used
!                  here is internally restricted to be at
!                  least SRELPR.  The data set for this option
!                  is the new tolerance.
!
!                  For example, suppose we want to change
!                  the tolerance for the reduced least squares
!                  problem, compute the covariance matrix of
!                  the solution parameters, and provide
!                  column scaling for the data matrix.  For
!                  these options the dimension of prgopt(*)
!                  must be at least n+9.  The Fortran statements
!                  defining these options would be as follows.
!
!                  prgopt(1)=4 (LINK TO ENTRY 4 IN prgopt(*))
!                  prgopt(2)=1 (COVARIANCE MATRIX key)
!                  prgopt(3)=1 (COVARIANCE MATRIX WANTED)
!
!                  prgopt(4)=7 (LINK TO ENTRY 7 IN prgopt(*))
!                  prgopt(5)=5 (LEAST SQUARES EQUAS. TOLERANCE KEY)
!                  prgopt(6)=... (NEW VALUE OF THE TOLERANCE)
!
!                  prgopt(7)=n+9 (LINK TO ENTRY n+9 IN prgopt(*))
!                  prgopt(8)=3 (USER-PROVIDED COLUMN SCALING KEY)
!
!                  call scopy(n,d,1,prgopt(9),1)  (copy the n
!                    scaling factors from the user array D(*)
!                    TO prgopt(9)-prgopt(n+8))
!
!                  prgopt(n+9)=1 (NO MORE OPTIONS TO CHANGE)
!
!                  The contents of prgopt(*) are not modified
!                  by the subprogram.
!                  The key 8 and 9 options for wnnls( ) can also
!                  be included in this array.  Their functions
!                  are documented in the usage instructions for
!                  SUBPROGRAM wnnls( ).
!
!     Output..
!
!     x(*),rnorme,  the array x(*) contains the solution parameters
!     rnorml        IF THE INTEGER OUTPUT FLAG mode = 0 OR 1.
!                   The definition of mode is given directly below.
!                   WHEN mode = 0 OR 1, rnorme AND rnorml
!                   respectively contain the residual vector
!                   Euclidean lengths of F - EX and B - AX.  When
!                   mode=1 THE EQUALITY CONSTRAINT EQUATIONS EX=F
!                   ARE CONTRADICTORY, SO rnorme.NE.0. THE RESIDUAL
!                   vector F-EX has minimal Euclidean length. For
!                   mode.GE.2, NONE OF THESE PARAMETERS ARE
!                   defined.
!
!     MODE          INTEGER FLAG THAT INDICATES THE SUBPROGRAM
!                   STATUS AFTER COMPLETION.  IF mode.GE.2, NO
!                   solution has been computed.
!
!                   mode =
!
!                   0  Both equality and inequality constraints
!                      are compatible and have been satisfied.
!
!                   1  Equality constraints are contradictory.
!                      A GENERALIZED INVERSE SOLUTION OF EX=F WAS USED
!                      to minimize the residual vector LENGTH F-EX.
!                      In this sense, the solution is still meaningful.
!
!                   2  No solution could be obtained. The constraints
!                      are contradictory.
!
!                   4  Usage error occurred.  The value
!                      OF mdw IS .LT. me+ma+mg, mdw IS
!                      .LT. n AND A COVARIANCE MATRIX IS
!                      requested, or the option vector
!                      prgopt(*) is not properly defined.
!
!     w(*,*)        THE ARRAY w(*,*) CONTAINS THE n BY n SYMMETRIC
!                   covariance matrix of the solution parameters,
!                   provided this was requested on input with
!                   the option vector prgopt(*) and the output
!                   FLAG IS RETURNED WITH mode = 0 OR 1.
!
!     ip(*)         THE INTEGER WORKING ARRAY HAS THREE ENTRIES
!                   that provide rank and working array LENGTH
!                   information after completion.
!
!                      ip(1) = RANK OF EQUALITY CONSTRAINT
!                              matrix.  Define this quantity
!                              AS kranke.
!
!                      ip(2) = RANK OF REDUCED LEAST SQUARES
!                              problem.
!
!                      ip(3) = THE AMOUNT OF STORAGE IN THE
!                              working array ws(*) that was
!                              actually used by the subprogram.
!                              The formula given above for the length
!                              of ws(*) is a necessary overestimate.
!     User designated
!     working arrays..
!
!     ws(*),ip(*)              THESE ARE RESPECTIVELY TYPE REAL
!                              and type integer working arrays.
!                              Their required minimal lengths are
!                              given above.
!
!
!     Subroutines called
!
!     lsi           PART OF THIS PACKAGE.  SOLVES A
!                   constrained least squares problem with
!                   inequality constraints.
!
!     sdot,sscal,   SUBROUTINES FROM THE BLAS PACKAGE.
!     saxpy,sasum,  see trans. Math software (5), P. 308.
!     scopy,snrm2,
!     sswap,isamax
!
!     h12           SUBROUTINE TO CONSTRUCT AND APPLY A
!                   Householder transformation.
!
!     spmpar        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!                   precision.
!
!     Revised oct. 1, 1989.
!
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(*), ws(*)
integer, intent(inout) :: ip(*)
logical :: cov
data zero /0.e0/, one /1.e0/, half /0.5e0/
!
!     Compute machine precision
!
srelpr = spmpar(1)
!
!     Compute number of possible right multiplying Householder
!     transformations.
!
m = me + ma + mg
mode = 0
if (n .le. 0 .or. me + ma .le. 0) return
if (.not.(mdw.lt.m)) go to 80
mode = 4
return
80 np1 = n + 1
kranke = min0(me,n)
n1 = 2*kranke + 1
n2 = n1 + n
!
!     Process-option-vector
!
go to 480
90 if (.not.(cov .and. mdw.lt.n)) go to 100
mode = 4
return
100 l = kranke
!
!     Compute norm of equality constraint matrix and RT side.
!
enorm = zero
do j = 1,n
  enorm = amax1(enorm,sasum(me,w(1,j),1))
end do
fnorm = sasum(me,w(1,np1),1)
if (.not.(l.gt.0)) go to 200
snmax = zero
rnmax = zero
do 180 i = 1,l
!
!     Compute maximum ratio of vector lengths. Partition
!     is at col. i.
  do 150 k = i,me
     sn = sdot(n-i+1,w(k,i),mdw,w(k,i),mdw)
     rn = sdot(i-1,w(k,1),mdw,w(k,1),mdw)
     if (.not.(rn.eq.zero .and. sn.gt.snmax)) go to 120
     snmax = sn
     imax = k
     go to 150
120 if (.not.(k.eq.i .or. (sn*rnmax.gt.rn*snmax))) go to 150
     snmax = sn
     rnmax = rn
     imax = k
150 continue
!
!     Interchange rows if necessary.
  if (i.ne.imax) call sswap(np1, w(i,1), mdw, w(imax,1), mdw)
  if (.not.(snmax.gt.tau**2*rnmax)) go to 160
!
!     Eliminate elems i+1,...,n in row i.
  call h12(1, i, i+1, n, w(i,1), mdw, ws(i), w(i+1,1), mdw, 1, &
&m-i)
  go to 180
160 kranke = i - 1
  go to 200
180 continue
!
!     Save diag. Terms of lower trap. Matrix.
!
200 call scopy(kranke, w, mdw+1, ws(kranke+1), 1)
!
!     Use Householder trans from left to achieve kranke by kranke upper
!     triangular form.
!
if (.not.(kranke.gt.0 .and. kranke.lt.me)) go to 220
do kk = 1,kranke
  k = kranke + 1 - kk
!
!     Apply tranformation to matrix cols. 1,...,k-1.
  call h12(1, k, kranke+1, me, w(1,k), 1, up, w, 1, mdw, k-1)
!
!     Apply to RT side vector.
  call h12(2, k, kranke+1, me, w(1,k), 1, up, w(1,np1), 1, 1, 1)
end do
220 if (.not.(kranke.gt.0)) go to 240
!
!     Solve for variables 1,...,kranke in new coordinates.
call scopy(kranke, w(1,np1), 1, x, 1)
do i=1,kranke
  x(i) = (x(i)-sdot(i-1,w(i,1),mdw,x,1))/w(i,i)
end do
!
!     Compute residuals for reduced problem.
!
240 mep1 = me + 1
rnorml = zero
if (.not.(me.lt.m)) go to 270
do 260 i = mep1,m
  w(i,np1) = w(i,np1) - sdot(kranke,w(i,1),mdw,x,1)
  sn = sdot(kranke,w(i,1),mdw,w(i,1),mdw)
  rn = sdot(n-kranke,w(i,kranke+1),mdw,w(i,kranke+1),mdw)
  if (.not.(rn.le.tau**2*sn .and. kranke.lt.n)) go to 260
  w(i,kranke+1) = zero
  call scopy(n-kranke, w(i,kranke+1), 0, w(i,kranke+1), mdw)
260 continue
!
!     Compute equal. Constraint equas. Residual length.
270 rnorme = snrm2(me-kranke,w(kranke+1,np1),1)
!
!     MOVE REDUCED PROBLEM DATA UPWARD IF kranke.LT.ME.
!
if (.not.(kranke.lt.me)) go to 290
do j=1,np1
  call scopy(m-me, w(me+1,j), 1, w(kranke+1,j), 1)
end do
!
!     Compute soln of reduced problem.
!
290 call lsi(w(kranke+1,kranke+1), mdw, ma, mg, n-kranke, prgopt, &
&x(kranke+1), rnorml, mode, ws(n2), ip(2))
if (mode .gt. 1) go to 470
if (.not.(me.gt.0)) go to 330
!
!     Test for consistency of equality constraints.
!
mdeqc = 0
xnrme = sasum(kranke,w(1,np1),1)
if (rnorme.gt.tau*(enorm*xnrme+fnorm)) mdeqc = 1
mode = mode + mdeqc
!
!     Check if soln to equal. Constraints satisfies inequal.
!     Constraints when there are no degrees of freedom left.
!
if (.not.(kranke.eq.n .and. mg.gt.0)) go to 330
xnorm = sasum(n,x,1)
mapke1 = ma + kranke + 1
mend = ma + kranke + mg
do 310 i = mapke1,mend
  size = sasum(n,w(i,1),mdw)*xnorm + abs(w(i,np1))
  if (.not.(w(i,np1).gt.tau*size)) go to 310
  mode = 2
  go to 470
310 continue
330 if (.not.(kranke.gt.0)) go to 420
!
!     Replace diag. Terms of lower trap. Matrix.
call scopy(kranke, ws(kranke+1), 1, w, mdw+1)
!
!     Reapply trans to put soln in original coordinates.
!
do ii = 1,kranke
  i = kranke + 1 - ii
  call h12(2, i, i+1, n, w(i,1), mdw, ws(i), x, 1, 1, 1)
end do
!
!     Compute cov matrix of equal. Constrained problem.
!
if (.not.(cov)) go to 450
do 400 jj = 1,kranke
  j = kranke + 1 - jj
  if (.not.(j.lt.n)) go to 400
  rb = ws(j)*w(j,j)
  if (rb.ne.zero) rb = one/rb
  jp1 = j + 1
  do i=jp1,n
    w(i,j) = sdot(n-j,w(i,jp1),mdw,w(j,jp1),mdw)*rb
  end do
  gam = sdot(n-j,w(jp1,j),1,w(j,jp1),mdw)*rb
  gam = half*gam
  call saxpy(n-j, gam, w(j,jp1), mdw, w(jp1,j), 1)
  do i=jp1,n
    do k=i,n
      w(i,k) = w(i,k) + w(j,i)*w(k,j) + w(i,j)*w(j,k)
      w(k,i) = w(i,k)
    end do
  end do
  uj = ws(j)
  vj = gam*uj
  w(j,j) = uj*vj + uj*vj
  do i=jp1,n
    w(j,i) = uj*w(i,j) + vj*w(j,i)
  end do
  call scopy(n-j, w(j,jp1), mdw, w(jp1,j), 1)
400 continue
!
!     Apply the scaling to the covariance matrix.
!
420 if (.not.(cov)) go to 450
do i = 1,n
  l = n1 + i
  call sscal(n, ws(l-1), w(i,1), mdw)
  call sscal(n, ws(l-1), w(1,i), 1)
end do
!
!     Rescale soln. Vector.
!
450 if (mode .gt. 1) go to 470
do j = 1,n
  l = n1 + j
  x(j) = x(j)*ws(l-1)
end do
470 ip(1) = kranke
ip(3) = ip(3) + 2*kranke + n
return
480 continue
!     To process-option-vector
!
!     The nominal tolerance used in the code
!     for the equality constraint equations.
tau = sqrt(srelpr)
!
!     The nominal column scaling used in the code is
!     the identity scaling.
ws(n1) = one
call scopy(n, ws(n1), 0, ws(n1), 1)
!
!     No covariance matrix is nominally computed.
cov = .false.
!
!     Define bound for number of options to change.
nopt = 1000
ntimes = 0
!
!     Define bound for positive values of link.
nlink = 100000
last = 1
link = prgopt(1)
if (.not.(link.le.0 .or. link.gt.nlink)) go to 490
mode = 4
return
490 if (.not.(link.gt.1)) go to 540
ntimes = ntimes + 1
if (.not.(ntimes.gt.nopt)) go to 500
mode = 4
return
500 key = prgopt(last+1)
if (key.eq.1) cov = prgopt(last+2).ne.zero
if (.not.(key.eq.2 .and. prgopt(last+2).ne.zero)) go to 520
do j=1,n
  t = snrm2(m,w(1,j),1)
  if (t.ne.zero) t = one/t
  l = n1 + j
  ws(l-1) = t
end do
520 if (key.eq.3) call scopy(n, prgopt(last+2), 1, ws(n1), 1)
if (key.eq.4) tau = amax1(srelpr,prgopt(last+2))
next = prgopt(link)
if (.not.(next.le.0 .or. next.gt.nlink)) go to 530
mode = 4
return
530 last = link
link = next
go to 490
540 do j=1,n
  l = n1 + j
  call sscal(m, ws(l-1), w(1,j), 1)
end do
go to 90
end subroutine lsei

subroutine lsi(w, mdw, ma, mg, n, prgopt, x, rnorm, mode, ws, ip)
implicit none
integer, intent(in) :: ma, mdw, mg
integer, intent(out) :: mode
integer :: n
real, intent(out) :: rnorm
integer :: i, ii, il, im1, ip1, j, k, key, key8, key9, krank, &
&krm1, krp1, l, last, link, m, map1, mdlpdp, minman, n1, n2, n3, &
&next, np1
real :: anorm, blowup, eps, fac, gam, half, one, rb, srelpr, tau, &
&tol, xnorm, zero
real :: sasum
real :: sdot
real :: spmpar
!
!     This is a companion subprogram to lsei( ).
!     The documentation for lsei( ) has more complete
!     usage instructions.
!     Written by R. J. Hanson, sla.
!
!     Solve..
!              AX = B,  A  ma BY n  (LEAST SQUARES EQUATIONS)
!     subject to..
!
!              GX.GE.H, G  mg BY n  (INEQUALITY CONSTRAINTS)
!
!     Input..
!
!      w(*,*) contains  (A B) in rows 1,...,ma+mg, cols 1,...,n+1.
!                       (G H)
!
!     mdw,ma,mg,n
!              contain (resp) var. Dimension of w(*,*),
!              and matrix dimensions.
!
!     prgopt(*),
!              program option vector.
!
!     Output..
!
!      x(*),rnorm
!
!              SOLUTION VECTOR(UNLESS mode=2), LENGTH OF AX-B.
!
!      Mode
!              =0   INEQUALITY CONSTRAINTS ARE COMPATIBLE.
!              =2   INEQUALITY CONSTRAINTS CONTRADICTORY.
!
!      ws(*),
!              working storage of dimension k+n+(mg+2)*(n+7),
!              WHERE k=max(ma+mg,n).
!      ip(mg+2*n+1)
!              integer working storage
!
!     Subroutines called
!
!     lpdp          THIS SUBPROGRAM MINIMIZES A SUM OF SQUARES
!                   of unknowns subject to linear inequality
!                   constraints.  Part of this package.
!
!     sdot,sscal    SUBROUTINES FROM THE BLAS PACKAGE.
!     saxpy,sasum,  see trans. Math software (5), P. 308.
!     scopy,sswap
!
!     hfti          SOLVES AN UNCONSTRAINED LINEAR LEAST SQUARES
!                   problem.
!
!     h12           SUBROUTINE TO CONSTRUCT AND APPLY A HOUSEHOLDER
!                   transformation.
!
!     spmpar        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!                   precision.
!
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(*), ws(*)
real :: rnrm(1), opt(7)
integer, intent(inout) :: ip(*)
logical :: cov
!
data zero /0.e0/, one /1.e0/, half /0.5e0/
!
srelpr = spmpar(1)
mode = 0
rnorm = zero
m = ma + mg
np1 = n + 1
krank = 0
if (n.le.0 .or. m.le.0) go to 70
!
!     Process-option-vector
!
go to 500
!
!     Compute matrix NORM of least squares equas.
!
40 anorm = zero
do j = 1,n
  anorm = amax1(anorm,sasum(ma,w(1,j),1))
end do
!
!     Set TOL for hfti( ) rank test.
tau = tol*anorm
!
!     Compute Householder orthogonal decomp of matrix.
!
if (n.gt.0) ws(1) = zero
call scopy(n, ws, 0, ws, 1)
call scopy(ma, w(1,np1), 1, ws, 1)
k = max0(m,n)
minman = min0(ma,n)
n1 = k + 1
n2 = n1 + n
call hfti(w, mdw, ma, n, ws, 1, 1, tau, krank, rnrm, ws(n2), &
&ws(n1), ip)
rnorm = rnrm(1)
fac = one
gam = ma - krank
if (krank .lt. ma) fac = rnorm**2/gam
go to 80
!
!     Reduce-to-lpdp-and-solve
!
70 ip(1) = krank
ip(2) = n + max0(m,n) + (mg+2)*(n+7)
return
!
!     To reduce-to-lpdp-and-solve
!
80 map1 = ma + 1
!
!     Compute ineq. RT-hand side for lpdp.
!
if (.not.(ma.lt.m)) go to 260
if (.not.(minman.gt.0)) go to 160
do i = map1,m
  w(i,np1) = w(i,np1) - sdot(n,w(i,1),mdw,ws,1)
end do
do i = 1,minman
  j = ip(i)
!
!     Apply permutations to cols of ineq. Constraint matrix.
  call sswap(mg, w(map1,i), 1, w(map1,j), 1)
end do
!
!     Apply Householder transformations to constraint matrix.
!
if (.not.(0.lt.krank .and. krank.lt.n)) go to 120
do ii = 1,krank
  i = krank + 1 - ii
  l = n1 + i
  call h12(2, i, krank+1, n, w(i,1), mdw, ws(l-1), w(map1,1), &
&mdw, 1, mg)
end do
!
!     Compute permuted ineq. Constr. Matrix times R-inverse.
!
120 do 150 i = map1,m
  if (.not.(0.lt.krank)) go to 150
  do j=1,krank
    w(i,j) = (w(i,j)-sdot(j-1,w(1,j),1,w(i,1),mdw))/w(j,j)
  end do
150 continue
!
!     Solve the reduced problem with lpdp algorithm,
!     the least projected distance problem.
!
160 call lpdp(w(map1,1), mdw, mg, krank, n-krank, opt, x, xnorm, &
&mdlpdp, ws(n2), ip(n+1))
if (mdlpdp .ne. 1) go to 240
if (.not.(krank.gt.0)) go to 180
!
!     Compute soln in original coordinates.
!
do ii = 1,krank
  i = krank + 1 - ii
  x(i) = (x(i)-sdot(ii-1,w(i,i+1),mdw,x(i+1),1))/w(i,i)
end do
!
!     Apply Householder trans. To soln vector.
!
180 if (.not.(0.lt.krank .and. krank.lt.n)) go to 200
do i = 1,krank
  l = n1 + i
  call h12(2, i, krank+1, n, w(i,1), mdw, ws(l-1), x, 1, 1, 1)
end do
200 if (.not.(minman.gt.0)) go to 270
!
!     Repermute variables to their input order.
do ii=1,minman
  i = minman + 1 - ii
  j = ip(i)
  call sswap(1, x(i), 1, x(j), 1)
end do
!
!     Variables are now in orig. Coordinates.
!     Add soln of unsconstrained prob.
do i = 1,n
  x(i) = x(i) + ws(i)
end do
!
!     Compute the residual vector NORM.
rnorm = sqrt(rnorm**2+xnorm**2)
go to 270
240 mode = 2
go to 270
260 call scopy(n, ws, 1, x, 1)
270 if (.not.(cov .and. krank.gt.0)) go to 70
!
!     Compute covariance matrix based on the orthogonal decomp.
!     FROM hfti( ).
!
krm1 = krank - 1
krp1 = krank + 1
!
!     Copy diag. Terms to working array.
call scopy(krank, w, mdw+1, ws(n2), 1)
!
!     Reciprocate diag. Terms.
do j = 1,krank
  w(j,j) = one/w(j,j)
end do
if (.not.(krank.gt.1)) go to 310
!
!     Invert the upper triangular QR factor on itself.
do i=1,krm1
  ip1 = i + 1
  do j=ip1,krank
    w(i,j) = -sdot(j-i,w(i,i),mdw,w(i,j),1)*w(j,j)
  end do
end do
!
!     Compute the inverted factor times its transpose.
310 do i=1,krank
  do j=i,krank
    w(i,j) = sdot(krank+1-j,w(i,j),mdw,w(j,j),mdw)
  end do
end do
if (.not.(krank.lt.n)) go to 450
!
!     Zero out lower trapezoidal part.
!     Copy upper TRI. To lower TRI. Part.
do j=1,krank
  call scopy(j, w(1,j), 1, w(j,1), mdw)
end do
do i=krp1,n
  w(i,1) = zero
  call scopy(i, w(i,1), 0, w(i,1), mdw)
end do
!
!     Apply right side transformations to lower TRI.
n3 = n2 + krp1
do i=1,krank
  l = n1 + i
  k = n2 + i
  rb = ws(l-1)*ws(k-1)
  if (.not.(rb.lt.zero)) go to 420
!
!     IF rb.GE.ZERO, TRANSFORMATION CAN BE REGARDED AS ZERO.
  rb = one/rb
!
!     Store unscaled rank-one Householder update in work array.
  ws(n3) = zero
  call scopy(n, ws(n3), 0, ws(n3), 1)
  l = n1 + i
  k = n3 + i
  ws(k-1) = ws(l-1)
  do j=krp1,n
    k = n3 + j
    ws(k-1) = w(i,j)
  end do
  do j=1,n
    l = n3 + i
    k = n3 + j
    ws(j) = sdot(j-i,w(j,i),mdw,ws(l-1),1) + sdot(n-j+1,w(j,j),1, &
&ws(k-1),1)
    ws(j) = ws(j)*rb
  end do
  l = n3 + i
  gam = sdot(n-i+1,ws(l-1),1,ws(i),1)*rb
  gam = gam*half
  call saxpy(n-i+1, gam, ws(l-1), 1, ws(i), 1)
  do j=i,n
    if (.not.(i.gt.1)) go to 390
    im1 = i - 1
    k = n3 + j
    do l=1,im1
      w(j,l) = w(j,l) + ws(k-1)*ws(l)
    end do
390 k = n3 + j
    do l=i,j
      il = n3 + l
      w(j,l) = w(j,l) + ws(j)*ws(il-1) + ws(l)*ws(k-1)
    end do
  end do
420 continue
end do
!
!     Copy lower TRI. To upper TRI. To symmetrize the covariance matrix.
!
do i = 1,n
  call scopy(i, w(i,1), mdw, w(1,i), 1)
end do
!
!     Repermute rows and cols.
!
450 do 470 ii = 1,minman
  i = minman + 1 - ii
  k = ip(i)
  if (.not.(i.ne.k)) go to 470
  call sswap(1, w(i,i), 1, w(k,k), 1)
  call sswap(i-1, w(1,i), 1, w(1,k), 1)
  call sswap(k-i-1, w(i,i+1), mdw, w(i+1,k), 1)
  call sswap(n-k, w(i,k+1), mdw, w(k,k+1), mdw)
470 continue
!
!     Put in normalized residual sum of squares scale factor
!     and symmetrize the resulting covariance marix.
!
do j = 1,n
  call sscal(j, fac, w(1,j), 1)
  call scopy(j, w(1,j), 1, w(j,1), mdw)
end do
go to 70
!
!     To process-option-vector
!
!     The nominal tolerance used in the code,
500 tol = sqrt(srelpr)
cov = .false.
last = 1
link = prgopt(1)
key8 = 0
key9 = 0
510 if (.not.(link.gt.1)) go to 540
   key = prgopt(last+1)
   if (key .eq. 1) cov = prgopt(last+2).ne.zero
   if (key .eq. 5) tol = amax1(srelpr,prgopt(last+2))
   if (key .ne. 8) go to 520
      key8 = 1
      eps = prgopt(last+2)
      go to 530
520 if (key .ne. 9) go to 530
      key9 = 1
      blowup = prgopt(last+2)
530 next = prgopt(link)
   last = link
   link = next
   go to 510
!
!     Prepare the option vector for wnnls
!
540 j = 1
if (key8 .eq. 0) go to 550
   opt(1) = 4.0
   opt(2) = 8.0
   opt(3) = eps
   j = 4
550 if (key9 .eq. 0) go to 560
   opt(j) = j + 3
   opt(j+1) = 9.0
   opt(j+2) = blowup
   j = j + 3
560 opt(j) = 1.0
go to 40
end subroutine lsi

subroutine lpdp(a, mda, m, n1, n2, prgopt, x, wnorm, mode, ws, is)
implicit none
integer, intent(inout) :: is(*)
integer, intent(in) :: m, mda
integer, intent(out) :: mode
integer, intent(in) :: n1, n2
real, intent(inout) :: a(mda,*)
real :: prgopt(*)
real, intent(inout) :: wnorm, ws(*), x(*)
integer :: i, iw, ix, j, l, modew, n, np1
real :: fac, one, rnorm, sc, ynorm, zero
real :: snrm2
real :: sdot
!
!     dimension a(mda,n+1),prgopt(*),x(n),ws((m+2)*(n+7)),is(m+n+1),
!     WHERE n=n1+n2.  THIS IS A SLIGHT OVERESTIMATE FOR ws(*).
!
!     Written by R. J. Hanson and K. H. Haskell, sandia labs
!
!     Determine an n1-vector W, and
!               an n2-vector Z
!     which minimizes the Euclidean length of W
!     SUBJECT TO G*W+H*Z .GE. Y.
!     This is the least projected distance problem, lpdp.
!     The matrices G and H are of respective
!     dimensions m by n1 and m by n2.
!
!     Called by subprogram lsi( ).
!
!     The matrix
!                (G H Y)
!
!     Occupies rows 1,...,m and cols 1,...,n1+n2+1 of a(*,*).
!
!     The solution (W) is returned in x(*).
!                  (Z)
!
!     The value of mode indicates the status of
!     the computation after returning to the user.
!
!          mode=1  THE SOLUTION WAS SUCCESSFULLY OBTAINED.
!
!          mode=2  THE INEQUALITIES ARE INCONSISTENT.
!
!     Subroutines called
!
!     wnnls         SOLVES A NONNEGATIVELY CONSTRAINED LINEAR LEAST
!                   squares problem with linear equality constraints.
!                   Part of this package.
!
!     sdot,scopy    SUBROUTINES FROM THE BLAS PACKAGE.
!     sscal,snrm2   SEE TRANS. MATH SOFTWARE (5), P. 308.
!
data zero, one /0.e0,1.e0/, fac /0.1e0/
!
n = n1 + n2
mode = 1
if (.not.(m.le.0)) go to 20
if (.not.(n.gt.0)) go to 10
x(1) = zero
call scopy(n, x, 0, x, 1)
10 wnorm = zero
return
20 np1 = n + 1
!
!     Scale nonzero rows of inequality matrix to have length one.
!
do 40 i = 1,m
   sc = snrm2(n,a(i,1),mda)
   if (sc .eq. zero) go to 40
   sc = one/sc
   call sscal(np1, sc, a(i,1), mda)
40 continue
!
!     Scale RT.-Side vector to have length one (or zero).
ynorm = snrm2(m,a(1,np1),1)
if (ynorm .eq. zero) go to 50
sc = one/ynorm
call sscal(m, sc, a(1,np1), 1)
!
!     Scale cols of matrix H.
50 j = n1 + 1
60 if (j .gt. n) go to 70
sc = snrm2(m,a(1,j),1)
if (sc .ne. zero) sc = one/sc
call sscal(m, sc, a(1,j), 1)
x(j) = sc
j = j + 1
go to 60
70 if (.not.(n1.gt.0)) go to 130
!
!     Copy transpose of (H G Y) to work array ws(*).
iw = 0
do i=1,m
!
!     Move col of transpose of H into work array.
   call scopy(n2, a(i,n1+1), mda, ws(iw+1), 1)
   iw = iw + n2
!
!     Move col of transpose of G into work array.
   call scopy(n1, a(i,1), mda, ws(iw+1), 1)
   iw = iw + n1
!
!     Move component of vector Y into work array.
   ws(iw+1) = a(i,np1)
   iw = iw + 1
end do
ws(iw+1) = zero
call scopy(n, ws(iw+1), 0, ws(iw+1), 1)
iw = iw + n
ws(iw+1) = one
iw = iw + 1
!
!     SOLVE EU=F SUBJECT TO (TRANSPOSE OF H)U=0, U.GE.0.  THE
!     MATRIX E = TRANSPOSE OF (G Y), AND THE (n+1)-VECTOR
!     F = TRANSPOSE OF (0,...,0,1).
ix = iw + 1
iw = iw + m
call wnnls(ws, np1, n2, np1-n2, m, 0, prgopt, ws(ix), rnorm, &
&modew, is, ws(iw+1))
!
!     Compute the components of the soln denoted above by W.
sc = one - sdot(m,a(1,np1),1,ws(ix),1)
if (.not.(one+fac*abs(sc).ne.one .and. rnorm.gt.zero)) go to 110
sc = one/sc
do j=1,n1
   x(j) = sc*sdot(m,a(1,j),1,ws(ix),1)
end do
!
!     COMPUTE THE VECTOR Q=Y-GW.  OVERWRITE Y WITH THIS VECTOR.
do i=1,m
   a(i,np1) = a(i,np1) - sdot(n1,a(i,1),mda,x,1)
end do
go to 130
110 mode = 2
return
130 if (.not.(n2.gt.0)) go to 180
!
!     Copy transpose of (H Q) to work array ws(*).
iw = 0
do i=1,m
   call scopy(n2, a(i,n1+1), mda, ws(iw+1), 1)
   iw = iw + n2
   ws(iw+1) = a(i,np1)
   iw = iw + 1
end do
ws(iw+1) = zero
call scopy(n2, ws(iw+1), 0, ws(iw+1), 1)
iw = iw + n2
ws(iw+1) = one
iw = iw + 1
ix = iw + 1
iw = iw + m
!
!     SOLVE RV=S SUBJECT TO V.GE.0.  THE MATRIX R =(TRANSPOSE
!     OF (H Q)), WHERE Q=Y-GW.  THE (n2+1)-VECTOR S =(TRANSPOSE
!     of (0,...,0,1)).
!
call wnnls(ws, n2+1, 0, n2+1, m, 0, prgopt, ws(ix), rnorm, modew, &
&is, ws(iw+1))
!
!     Compute the components of the soln denoted above by Z.
!
sc = one - sdot(m,a(1,np1),1,ws(ix),1)
if (.not.(one+fac*abs(sc).ne.one .and. rnorm.gt.zero)) go to 160
sc = one/sc
do j=1,n2
   l = n1 + j
   x(l) = sc*sdot(m,a(1,l),1,ws(ix),1)*x(l)
end do
go to 180
160 mode = 2
return
!
!     Account for scaling of RT.-Side vector in solution.
180 call sscal(n, ynorm, x, 1)
wnorm = snrm2(n1,x,1)
return
end subroutine lpdp

subroutine wnnls(w, mdw, me, ma, n, l, prgopt, x, rnorm, mode, &
&iwork, work)
implicit none
integer, intent(in) :: l, ma, mdw, me
integer, intent(out) :: mode
integer, intent(in) :: n
real, intent(inout) :: rnorm
integer :: l1, l2, l3, l4, l5
!
!     dimension w(mdw,n+1),prgopt(*),x(n),iwork(m+n),work(m+5*n)
!
!     Abstract
!
!     This subprogram solves a linearly constrained least squares
!     problem.  Suppose there are given matrices E and A of
!     respective dimensions me by n and ma by n, and vectors F
!     and B of respective lengths me and ma.  This subroutine
!     solves the problem
!
!               EX = F, (EQUATIONS TO BE EXACTLY SATISFIED)
!
!               AX = B, (EQUATIONS TO BE APPROXIMATELY SATISFIED,
!                        in the least squares sense)
!
!               Subject to components l+1,...,n nonnegative
!
!     ANY VALUES me.GE.0, ma.GE.0 AND 0.LE. l .LE.n ARE PERMITTED.
!
!     The problem is reposed as problem wnnls
!
!               (WT*E)x = (WT*F)
!               (   A)    (   B), (LEAST SQUARES)
!               subject to components l+1,...,n nonnegative.
!
!     The subprogram chooses the heavy weight (or penalty parameter) WT.
!
!     The parameters for wnnls are
!
!     Input..
!
!     w(*,*),mdw,  the array w(*,*) is double subscripted with first
!     ME,ma,n,l    DIMENSIONING PARAMETER EQUAL TO mdw.  FOR THIS
!                  DISCUSSION LET US CALL M = me + ma.  THEN mdw
!                  MUST SATISFY mdw.GE.M.  THE CONDITION mdw.LT.M
!                  is an error.
!
!                  The array w(*,*) contains the matrices and vectors
!
!                       (E  F)
!                       (A  B)
!
!                  In rows and columns 1,...,M and 1,...,n+1
!                  respectively.  Columns 1,...,l correspond to
!                  unconstrained variables x(1),...,x(l).  The
!                  remaining variables are constrained to be
!                  NONNEGATIVE.  THE CONDITION l.LT.0 .OR. l.GT.n IS
!                  an error.
!
!     prgopt(*)    THIS ARRAY IS THE OPTION VECTOR.
!                  If the user is satisfied with the nominal
!                  subprogram features set
!
!                  prgopt(1)=1 (OR prgopt(1)=1.0)
!
!                  Otherwise prgopt(*) is a linked list consisting of
!                  groups of data of the following form
!
!                  Link
!                  key
!                  data set
!
!                  The parameters link and key are each one word.
!                  The data set can be comprised of several words.
!                  The number of items depends on the value of key.
!                  The value of link points to the first
!                  entry of the next group of data within
!                  prgopt(*).  The exception is when there are
!                  no more options to change.  In that
!                  CASE LINK=1 AND THE VALUES KEY AND DATA SET
!                  are not referenced. The general layout of
!                  prgopt(*) is as follows.
!
!               ...prgopt(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!               .  prgopt(2)=KEY1 (KEY TO THE OPTION CHANGE)
!               .  prgopt(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!               .       .
!               .       .
!               .       .
!               ...prgopt(LINK1)=LINK2 (LINK TO THE FIRST ENTRY OF
!               .                       NEXT GROUP)
!               .  prgopt(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!               .  prgopt(LINK1+2)=DATA VALUE
!               ...     .
!               .       .
!               .       .
!               ...prgopt(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!
!                  Values of link that are nonpositive are errors.
!                  A VALUE OF LINK.GT.NLINK=100000 IS ALSO AN ERROR.
!                  This helps prevent using invalid but positive
!                  values of link that will probably extend
!                  beyond the program limits of prgopt(*).
!                  Unrecognized values of key are ignored.  The
!                  order of the options is arbitrary and any number
!                  of options can be changed with the following
!                  restriction.  To prevent cycling in the
!                  processing of the option array A count of the
!                  number of options changed is maintained.
!                  WHENEVER THIS COUNT EXCEEDS NOPT=1000 THE
!                  routine terminates.
!
!                  Options..
!
!                  key=6
!                         scale the nonzero columns of the
!                  entire data matrix
!                  (E)
!                  (A)
!                  to have length one.  The data set for
!                  this option is a single value.  It must
!                  be nonzero if unit length column scaling is
!                  desired.
!
!                  key=7
!                         scale columns of the entire data matrix
!                  (E)
!                  (A)
!                  with a user-provided diagonal matrix.
!                  The data set for this option consists
!                  of the n diagonal scaling factors, one for
!                  each matrix column.
!
!                  key=8
!                         change the rank determination tolerance from
!                  the nominal value of sqrt(EPS).  This quantity can
!                  be no smaller than eps, the arithmetic-
!                  storage precision.  The quantity used
!                  here is internally restricted to be at
!                  least eps.  The data set for this option
!                  is the new tolerance.
!
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
!
!                  For example, suppose we want to provide
!                  a diagonal matrix to scale the problem
!                  matrix and change the tolerance used for
!                  determining linear dependence of dropped col
!                  vectors.  For these options the dimensions of
!                  prgopt(*) must be at least n+6.  The Fortran
!                  statements defining these options would
!                  be as follows.
!
!                  prgopt(1)=n+3 (LINK TO ENTRY n+3 IN prgopt(*))
!                  prgopt(2)=7 (USER-PROVIDED SCALING KEY)
!
!                  call scopy(n,d,1,prgopt(3),1) (copy the n
!                  scaling factors from a user array called D(*)
!                  INTO prgopt(3)-prgopt(n+2))
!
!                  prgopt(n+3)=n+6 (LINK TO ENTRY n+6 OF prgopt(*))
!                  prgopt(n+4)=8 (LINEAR DEPENDENCE TOLERANCE KEY)
!                  prgopt(n+5)=... (NEW VALUE OF THE TOLERANCE)
!
!                  prgopt(n+6)=1 (NO MORE OPTIONS TO CHANGE)
!
!     Output..
!
!     x(*)         AN ARRAY DIMENSIONED AT LEAST n, WHICH WILL
!                  contain the n components of the solution vector
!                  on output.
!
!     rnorm        THE RESIDUAL NORM OF THE SOLUTION.  THE VALUE OF
!                  rnorm contains the residual vector LENGTH of the
!                  equality constraints and least squares equations.
!
!     MODE         THE VALUE OF MODE INDICATES THE SUCCESS OR FAILURE
!                  of the subprogram.
!
!                  mode = 0  SUBPROGRAM COMPLETED SUCCESSFULLY.
!
!                       = 1  MAX. NUMBER OF ITERATIONS (EQUAL TO
!                            3*(n-l)) exceeded. Nearly all problems
!                            should complete in fewer than this
!                            number of iterations. An approximate
!                            solution and its corresponding residual
!                            vector LENGTH are in x(*) and rnorm.
!
!                       = 2  USAGE ERROR OCCURRED.  EITHER
!                            mdw .LT. me + ma, l .LT. 0, l .GT. n,
!                            or the option vector prgopt(*) is
!                            not properly defined.
!
!     User-designated
!     working arrays..
!
!     work(*)      A WORKING ARRAY OF LENGTH AT LEAST
!                  M + 5*n.
!
!     iwork(*)     AN INTEGER-VALUED WORKING ARRAY OF LENGTH AT LEAST
!                  M+n.
!
!     Written by karen H. Haskell, Sandia Laboratories,
!     and R.J. Hanson, Sandia Laboratories.
!     Revised oct. 1, 1989.
!
!
!     Subroutines called by wnnls( )
!
!     wnlsm         COMPANION SUBROUTINE TO wnnls( ), WHERE
!                   most of the computation takes place.
!
!
!     References
!
!     1. Solving least squares problems, by C.L. Lawson
!        and R.J. Hanson.  Prentice-Hall, inc. (1974).
!
!     2. BASIC linear algebra subprograms for Fortran usage, by
!        C.L. Lawson, R.J. Hanson, D.R. kincaid, and F.T. krogh.
!        Toms, V. 5, No. 3, P. 308.  Also available as
!        sandia technical report no. SAND77-0898.
!
!     3. An algorithm for linear least squares with equality
!        and nonnegativity constraints, by K.H. Haskell and
!        R.J. Hanson.  Available as sandia technical report no.
!        SAND77-0552, and math. Programming, vol. 21, (1981), P. 98-118.
!
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(n), work(*)
integer, intent(inout) :: iwork(*)
!
mode = 0
if (ma+me .le. 0 .or. n .le. 0) return
if (.not.(mdw.lt.me+ma)) go to 10
mode = 2
return
10 if (0.le.l .and. l.le.n) go to 20
mode = 2
return
!
!     The purpose of this subroutine is to break up the arrays
!     work(*) and iwork(*) into separate work arrays
!     required by the main subroutine wnlsm( ).
!
20 l1 = n + 1
l2 = l1 + n
l3 = l2 + me + ma
l4 = l3 + n
l5 = l4 + n
!
call wnlsm(w, mdw, me, ma, n, l, prgopt, x, rnorm, mode, iwork, &
&iwork(l1), work(1), work(l1), work(l2), work(l3), work(l4), &
&work(l5))
return
end subroutine wnnls

subroutine wnlsm(w, mdw, mme, ma, n, l, prgopt, x, rnorm, mode, &
&ipivot, itype, wd, h, scale, z, temp, d)
implicit none
integer, intent(in) :: l, ma, mdw, mme
integer, intent(inout) :: mode
integer, intent(in) :: n
real, intent(inout) :: rnorm
integer :: i, igo897, igo938, igo958, imax, isol, itemp, iter, &
&itmax, iwmax, j, jcon, jj, jm1, jp, key, krank, krp1, l1, last, &
&link, lp1, m, me, mep1, next, niv, niv1, nlink, nm1, nopt, np1, &
&nsoln, nsp1, ntimes
real :: alamda, alpha, alsq, amax, blowup, bnorm, eanorm, fac, &
&one, sm, srelpr, t, tau, two, wmax, z2, zero, zz
real :: snrm2
real :: sasum
real :: spmpar
integer :: isamax
!
!     This is a companion subprogram to wnnls( ).
!     The documentation for wnnls( ) has more complete
!     usage instructions.
!
!     Written by karen h. Haskell, Sandia Laboratories,
!     with the help of R.J. Hanson, Sandia Laboratories.
!
!     In addition to the parameters discussed in the prologue to
!     subroutine wnnls, the following work arrays are used in
!     subroutine wnlsm  (they are passed through the calling
!     sequence from wnnls for purposes of variable dimensioning).
!     Their contents will in general be of no interest to the user.
!
!         ipivot(*)
!            an array of length n.  upon completion it contains the
!         pivoting information for the cols of w(*,*).
!
!         itype(*)
!            an array of length M which is used to keep track
!         OF THE CLASSIFICATION OF THE EQUATIONS.  itype(i)=0
!         denotes equation i as an equality constraint.
!         itype(i)=1 DENOTES EQUATION i AS A LEAST SQUARES
!         equation.
!
!         wd(*)
!            an array of length n.  upon completion it contains the
!         dual solution vector.
!
!         h(*)
!            an array of length n.  upon completion it contains the
!         pivot scalars of the Householder transformations performed
!         IN THE CASE KRANK.LT.l.
!
!         scale(*)
!            an array of length M which is used by the subroutine
!         to store the diagonal matrix of weights.
!         These are used to apply the modified Givens
!         transformations.
!
!         z(*),temp(*)
!            working arrays of length n.
!
!         d(*)
!            an array of length n that contains the
!         column scaling for the matrix (E).
!                                       (A)
!
!
real, intent(inout) :: w(mdw,*), x(*), wd(*), h(*), scale(*)
real :: dope(4)
real, intent(inout) :: z(*), temp(*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: d(*)
real :: sparam(5)
integer, intent(inout) :: ipivot(*), itype(*)
integer :: idope(8)
logical :: hitcon, feasbl, done, pos
data zero /0.e0/, one /1.e0/, two /2.e0/
!
!     Initialize-variables
!
go to 180
!
!     Perform initial triangularization in the submatrix
!     corresponding to the unconstrained variables using
!     the procedure initially-triangularize.
!
10 go to 280
!
!     Perform wnnls algorithm using the following steps.
!
!     UNTIL(done)
!
!        Compute-search-direction-and-feasible-point
!
!        When (hitcon) add-constraints
!
!        ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
!
!        Fin
!
!     Compute-final-solution
!
20 if (done) go to 80
go to 300
!
!     Compute-search-direction-and-feasible-point
!
30 if (.not.(hitcon)) go to 50
go to 370
!
!     When (hitcon) add-constraints
!
50 go to 640
!
!     ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
!
80 go to 1000
!
!     Compute-final-solution
!
100 continue
!
!     To process-option-vector
fac = 1.e-4
!
!     The nominal tolerance used in the code,
tau = sqrt(srelpr)
!
!     The nominal blow-up factor used in the code.
blowup = tau
!
!     The nominal column scaling used in the code is
!     the identity scaling.
d(1) = one
call scopy(n, d, 0, d, 1)
!
!     Define bound for number of options to change.
nopt = 1000
!
!     Define bound for positive value of link.
nlink = 100000
ntimes = 0
last = 1
link = prgopt(1)
if (.not.(link.le.0 .or. link.gt.nlink)) go to 110
mode = 2
return
110 if (.not.(link.gt.1)) go to 160
ntimes = ntimes + 1
if (.not.(ntimes.gt.nopt)) go to 120
mode = 2
return
120 key = prgopt(last+1)
if (.not.(key.eq.6 .and. prgopt(last+2).ne.zero)) go to 140
do 130 j = 1,n
  t = snrm2(m,w(1,j),1)
  if (t.ne.zero) t = one/t
  d(j) = t
130 continue
140 if (key.eq.7) call scopy(n, prgopt(last+2), 1, d, 1)
if (key.eq.8) tau = amax1(srelpr,prgopt(last+2))
if (key.eq.9) blowup = amax1(srelpr,prgopt(last+2))
next = prgopt(link)
if (.not.(next.le.0 .or. next.gt.nlink)) go to 150
mode = 2
return
150 last = link
link = next
go to 110
160 do 170 j = 1,n
  call sscal(m, d(j), w(1,j), 1)
170 continue
go to 220
!
!     To initialize-variables
!
!     SRELPR is the precision for the machine being used.
!
180 srelpr = spmpar(1)
!
m = ma + mme
me = mme
mep1 = me + 1
go to 100
!
!     Process-option-vector
220 done = .false.
iter = 0
itmax = 3*(n-l)
mode = 0
lp1 = l + 1
nsoln = l
nsp1 = nsoln + 1
np1 = n + 1
nm1 = n - 1
l1 = min0(m,l)
!
!     Compute scale factor to apply to equal. Constraint equas.
do 230 j = 1,n
  wd(j) = sasum(m,w(1,j),1)
230 continue
imax = isamax(n,wd,1)
eanorm = wd(imax)
bnorm = sasum(m,w(1,np1),1)
alamda = eanorm/(srelpr*fac)
!
!     Define scaling diag matrix for mod Givens usage and
!     classify equation types.
alsq = alamda**2
do 260 i = 1,m
!
!     WHEN EQU i IS HEAVILY WEIGHTED itype(i)=0, ELSE itype(i)=1.
  if (.not.(i.le.me)) go to 240
  t = alsq
  itemp = 0
  go to 250
240 t = one
  itemp = 1
250 scale(i) = t
  itype(i) = itemp
260 continue
!
!     Set the soln vector x(*) to zero and the col interchange
!     matrix to the identity.
x(1) = zero
call scopy(n, x, 0, x, 1)
do 270 i = 1,n
  ipivot(i) = i
270 continue
go to 10
280 continue
!
!     To initially-triangularize
!
!     Set first l comps. Of dual vector to zero because
!     these correspond to the unconstrained variables.
if (.not.(l.gt.0)) go to 290
wd(1) = zero
call scopy(l, wd, 0, wd, 1)
!
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
!
dope(1) = alsq
dope(2) = eanorm
dope(3) = fac
dope(4) = tau
call wnlit(w, mdw, m, n, l, ipivot, itype, h, scale, rnorm, &
&idope, dope, done)
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
!
!     To compute-search-direction-and-feasible-point
!
!     Solve the triangular system of currently non-active
!     variables and store the solution in z(*).
!
!     Solve-system
assign 310 to igo958
go to 1110
!
!     Increment iteration counter and check against max. Number
!     of iterations.
310 iter = iter + 1
if (.not.(iter.gt.itmax)) go to 320
mode = 1
done = .true.
!
!     Check to see if any constraints have become active.
!     If so, calculate an interpolation factor so that all
!     active constraints are removed from the basis.
320 alpha = two
hitcon = .false.
if (.not.(l.lt.nsoln)) go to 360
do 350 j = lp1,nsoln
  zz = z(j)
  if (.not.(zz.le.zero)) go to 350
  t = x(j)/(x(j)-zz)
  if (.not.(t.lt.alpha)) go to 330
  alpha = t
  jcon = j
330 hitcon = .true.
350 continue
360 go to 30
370 continue
!
!     To add-constraints
!
!     Use computed alpha to interpolate between last
!     feasible solution x(*) and current unconstrained
!     (and infeasible) solution z(*).
if (.not.(lp1.le.nsoln)) go to 390
do 380 j = lp1,nsoln
  x(j) = x(j) + alpha*(z(j)-x(j))
380 continue
390 feasbl = .false.
go to 410
400 if (feasbl) go to 20
!
!     Remove col JCON and shift cols JCON+1 through n to the
!     left. Swap col JCON into the n-TH position.  This achieves
!     upper Hessenberg form for the nonactive constraints and
!     leaves an upper Hessenberg matrix to retriangularize.
410 do 420 i = 1,m
  t = w(i,jcon)
  call scopy(n-jcon, w(i,jcon+1), mdw, w(i,jcon), mdw)
  w(i,n) = t
420 continue
!
!     Update permuted index vector to reflect this shift and swap.
itemp = ipivot(jcon)
if (.not.(jcon.lt.n)) go to 440
do 430 i = jcon,nm1
  ipivot(i) = ipivot(i+1)
430 continue
440 ipivot(n) = itemp
!
!     Similarly repermute x(*) vector.
call scopy(n-jcon, x(jcon+1), 1, x(jcon), 1)
x(n) = zero
nsp1 = nsoln
nsoln = nsoln - 1
niv1 = niv
niv = niv - 1
!
!     Retriangularize upper Hessenberg matrix after adding constraints.
j = jcon
i = krank + jcon - l
450 if (.not.(j.le.nsoln)) go to 570
if (.not.(itype(i).eq.0 .and. itype(i+1).eq.0)) go to 470
assign 460 to igo938
go to 620
!
!     (itype(i).EQ.0 .AND. itype(i+1).EQ.0) ZERO-IP1-TO-i-IN-COL-J
460 go to 560
470 if (.not.(itype(i).eq.1 .and. itype(i+1).eq.1)) go to 490
assign 480 to igo938
go to 620
!
!     (itype(i).EQ.1 .AND. itype(i+1).EQ.1) ZERO-IP1-TO-i-IN-COL-J
480 go to 560
490 if (.not.(itype(i).eq.1 .and. itype(i+1).eq.0)) go to 510
call sswap(np1, w(i,1), mdw, w(i+1,1), mdw)
call sswap(1, scale(i), 1, scale(i+1), 1)
itemp = itype(i+1)
itype(i+1) = itype(i)
itype(i) = itemp
!
!     Swapped row was formerly a pivot elt., So it will
!     be large enough to perform ELIM.
assign 500 to igo938
go to 620
!
!     Zero-IP1-to-i-in-col-J
500 go to 560
510 if (.not.(itype(i).eq.0 .and. itype(i+1).eq.1)) go to 550
t = scale(i)*w(i,j)**2/alsq
if (.not.(t.gt.tau**2*eanorm**2)) go to 530
assign 520 to igo938
go to 620
520 go to 540
530 call sswap(np1, w(i,1), mdw, w(i+1,1), mdw)
call sswap(1, scale(i), 1, scale(i+1), 1)
itemp = itype(i+1)
itype(i+1) = itype(i)
itype(i) = itemp
w(i+1,j) = zero
540 continue
550 continue
560 i = i + 1
j = j + 1
go to 450
!
!     See if the remaining coeffs in the soln set are feasible.  They
!     should be because of the way alpha was determined.  If any are
!     infeasible it is due to roundoff error.  Any that are non-
!     positive will be set to zero and removed from the soln set.
570 if (.not.(lp1.le.nsoln)) go to 590
do 580 jcon = lp1,nsoln
  if (x(jcon).le.zero) go to 600
580 continue
590 feasbl = .true.
600 continue
go to 400
620 continue
!
!     To zero-IP1-to-i-in-col-J
if (.not.(w(i+1,j).ne.zero)) go to 630
call srotmg(scale(i), scale(i+1), w(i,j), w(i+1,j), sparam)
w(i+1,j) = zero
call srotm(np1-j, w(i,j+1), mdw, w(i+1,j+1), mdw, sparam)
630 go to 1290
!
!     To perform-multiplier-test-and-drop-A-constraint
!
640 call scopy(nsoln, z, 1, x, 1)
if (.not.(nsoln.lt.n)) go to 650
x(nsp1) = zero
call scopy(n-nsoln, x(nsp1), 0, x(nsp1), 1)
650 i = niv1
660 if (.not.(i.le.me)) go to 690
!
!     Reclassify least squares eqations as equalities as
!     necessary.
if (.not.(itype(i).eq.0)) go to 670
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
!
!     Form inner product vector wd(*) of dual coeffs.
690 if (.not.(nsp1.le.n)) go to 730
do 720 j = nsp1,n
  sm = zero
  if (.not.(nsoln.lt.m)) go to 710
  do 700 i = nsp1,m
    sm = sm + scale(i)*w(i,j)*w(i,np1)
700 continue
710 wd(j) = sm
720 continue
730 go to 750
740 if (pos .or. done) go to 970
!
!     FIND J SUCH THAT wd(J)=WMAX IS MAXIMUM.  THIS DETERMINES
!     that the incoming col J will reduce the residual vector
!     and be positive.
750 wmax = zero
iwmax = nsp1
if (.not.(nsp1.le.n)) go to 780
do 770 j = nsp1,n
  if (.not.(wd(j).gt.wmax)) go to 760
  wmax = wd(j)
  iwmax = j
760 continue
770 continue
780 if (.not.(wmax.le.zero)) go to 790
done = .true.
go to 960
!
!     Set dual COEFF to zero for incoming col.
790 wd(iwmax) = zero
!
!     WMAX .GT. ZERO, SO OKAY TO MOVE COL IWMAX TO SOLN SET.
!     Perform transformation to retriangularize, and test
!     for near linear dependence.
!     Swap col IWMAX into NSOLN-TH position to maintain upper
!     Hessenberg form of adjacent cols, and add new col to
!     triangular decomposition.
nsoln = nsp1
nsp1 = nsoln + 1
niv = niv1
niv1 = niv + 1
if (.not.(nsoln.ne.iwmax)) go to 800
call sswap(m, w(1,nsoln), 1, w(1,iwmax), 1)
wd(iwmax) = wd(nsoln)
wd(nsoln) = zero
itemp = ipivot(nsoln)
ipivot(nsoln) = ipivot(iwmax)
ipivot(iwmax) = itemp
!
!     Reduce col NSOLN so that the matrix of nonactive
!     constraints variables is triangular.
800 j = m
810 if (.not.(j.gt.niv)) go to 870
jm1 = j - 1
jp = jm1
!
!     When operating near the me line, test to see if the pivot elt.
!     Is near zero.  If so, use the largest elt. Above it as the pivot.
!     This is to maintain the sharp interface between weighted and
!     non-weighted rows in all cases.
if (.not.(j.eq.mep1)) go to 850
imax = me
amax = scale(me)*w(me,nsoln)**2
820 if (.not.(jp.ge.niv)) go to 840
t = scale(jp)*w(jp,nsoln)**2
if (.not.(t.gt.amax)) go to 830
imax = jp
amax = t
830 jp = jp - 1
go to 820
840 jp = imax
850 if (.not.(w(j,nsoln).ne.zero)) go to 860
call srotmg(scale(jp), scale(j), w(jp,nsoln), w(j,nsoln), sparam)
w(j,nsoln) = zero
call srotm(np1-nsoln, w(jp,nsp1), mdw, w(j,nsp1), mdw, sparam)
860 j = jm1
go to 810
!
!     SOLVE FOR z(NSOLN)=PROPOSED NEW VALUE FOR x(NSOLN).
!     Test if this is nonpositive or too large.
!     If this was true or if the pivot term was zero reject
!     the col as dependent.
870 if (.not.(w(niv,nsoln).ne.zero)) go to 890
isol = niv
assign 880 to igo897
go to 980
!
!     Test-proposed-new-component
880 go to 940
890 if (.not.(niv.le.me .and. w(mep1,nsoln).ne.zero)) go to 920
!
!     Try to add row MEP1 as an additional equality constraint.
!     Check size of proposed new soln component.
!     Reject it if it is too large.
isol = mep1
assign 900 to igo897
go to 980
!
!     Test-proposed-new-component
900 if (.not.(pos)) go to 910
!
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
!
!     To test-proposed-new-component
z2 = w(isol,np1)/w(isol,nsoln)
z(nsoln) = z2
pos = z2.gt.zero
if (.not.(z2*eanorm.ge.bnorm .and. pos)) go to 990
pos = .not.(blowup*z2*eanorm.ge.bnorm)
990 go to 1280
1000 continue
!     To compute-final-solution
!
!     Solve system, store results in x(*).
!
assign 1010 to igo958
go to 1110
!     Solve-system
1010 call scopy(nsoln, z, 1, x, 1)
!
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO x(*) IF KRANK.LT.l
if (.not.(0.lt.krank .and. krank.lt.l)) go to 1030
do 1020 i = 1,krank
  call h12(2, i, krp1, l, w(i,1), mdw, h(i), x, 1, 1, 1)
1020 continue
!
!     Fill in trailing zeroes for constrained variables not in soln.
1030 if (.not.(nsoln.lt.n)) go to 1040
x(nsp1) = zero
call scopy(n-nsoln, x(nsp1), 0, x(nsp1), 1)
!
!     Repermute soln vector to natural order.
1040 do 1070 i = 1,n
  j = i
1050 if (ipivot(j).eq.i) go to 1060
  j = j + 1
  go to 1050
1060 ipivot(j) = ipivot(i)
  ipivot(i) = j
  call sswap(1, x(j), 1, x(i), 1)
1070 continue
!
!     Rescale the soln using the col scaling.
do 1080 j = 1,n
  x(j) = x(j)*d(j)
1080 continue
if (.not.(niv.lt.m)) go to 1100
do 1090 i = niv1,m
  t = w(i,np1)
  if (i.le.me) t = t/alamda
  t = (scale(i)*t)*t
  rnorm = rnorm + t
1090 continue
1100 rnorm = sqrt(rnorm)
return
!
!     To solve-system
!
1110 continue
if (.not.(done)) go to 1120
isol = 1
go to 1130
1120 isol = lp1
1130 if (.not.(nsoln.ge.isol)) go to 1270
!
!     Copy RT. Hand side into temp vector to use overwriting method.
call scopy(niv, w(1,np1), 1, temp, 1)
do 1180 jj = isol,nsoln
  j = nsoln - jj + isol
  if (.not.(j.gt.krank)) go to 1140
  i = niv - jj + isol
  go to 1150
1140 i = j
1150 if (.not.(j.gt.krank .and. j.le.l)) go to 1160
  z(j) = zero
  go to 1170
1160 z(j) = temp(i)/w(i,j)
  call saxpy(i-1, -z(j), w(1,j), 1, temp, 1)
1170 continue
1180 continue
!
1270 go to igo958, (310, 1010)
1280 go to igo897, (880, 900)
1290 go to igo938, (460, 480, 500, 520)
end subroutine wnlsm

subroutine wnlit(w, mdw, m, n, l, ipivot, itype, h, scale, rnorm, &
&idope, dope, done)
implicit none
integer, intent(in) :: l, m, mdw, n
real, intent(out) :: rnorm
integer :: i, i1, ic, igo990, igo993, igo996, ip1, ir, irp1, &
&itemp, j, j1, jj, jm1, jp, k, kk, krank, krp1, l1, lb, lend, lp1, &
&max, me, mend, mep1, niv, niv1, np1, nsoln
real :: alsq, eanorm, fac, factor, hbar, one, rn, sn, t, tau, &
&tenm3, zero
!
!     This is a companion subprogram to wnnls( ).
!     The documentation for wnnls( ) has more complete
!     usage instructions.
!
!     Note  the m by (n+1) matrix w( , ) contains the RT. Hand side
!           B as the (n+1)ST col.
!
!
!     TRIANGULARIZE L1 BY L1 SUBSYSTEM, WHERE L1=min(m,l), WITH
!     col interchanges.
!     Revised oct. 1, 1989
!
real, intent(inout) :: w(mdw,*), h(*), scale(*)
real, intent(in) :: dope(*)
real :: sparam(5)
integer, intent(inout) :: itype(*), ipivot(*), idope(*)
integer :: isamax
logical :: indep
logical, intent(inout) :: done
logical :: recalc
data tenm3 /1.e-3/, zero /0.e0/, one /1.e0/
!
me = idope(1)
mep1 = idope(2)
krank = idope(3)
krp1 = idope(4)
nsoln = idope(5)
niv = idope(6)
niv1 = idope(7)
l1 = idope(8)
!
alsq = dope(1)
eanorm = dope(2)
fac = dope(3)
tau = dope(4)
np1 = n + 1
lb = min0(m-1,l)
recalc = .true.
rnorm = zero
krank = 0
!     WE SET factor=1.E0 SO THAT THE HEAVY WEIGHT ALAMDA WILL BE
!     included in the test for col independence.
factor = 1.e0
i = 1
ip1 = 2
lend = l
10 if (.not.(i.le.lb)) go to 150
if (.not.(i.le.me)) go to 130
!
!     Set ir to point to the i-TH row.
ir = i
mend = m
assign 20 to igo996
go to 460
!
!     Update-col-SS-and-find-pivot-col
20 assign 30 to igo993
go to 560
!
!     Perform-col-interchange
!
!     Set ic to point to i-TH col.
30 ic = i
assign 40 to igo990
go to 520
!
!     Test-indep-of-incoming-col
40 if (.not.(indep)) go to 110
!
!     Eliminate i-TH col below diag. Using mod. Givens transformations
!     applied to (A B).
j = m
do 100 jj = ip1,m
  jm1 = j - 1
  jp = jm1
  if (.not.(jj.eq.m)) go to 70
  if (.not.(i.lt.mep1)) go to 80
  j = mep1
  jp = i
  t = scale(jp)*w(jp,i)**2*tau**2
  if (.not.(t.gt.scale(j)*w(j,i)**2)) go to 130
  go to 80
70 if (.not.(j.eq.mep1)) go to 80
  j = jm1
  jm1 = j - 1
  jp = jm1
80 if (.not.(w(j,i).ne.zero)) go to 90
  call srotmg(scale(jp), scale(j), w(jp,i), w(j,i), sparam)
  w(j,i) = zero
  call srotm(np1-i, w(jp,ip1), mdw, w(j,ip1), mdw, sparam)
90 j = jm1
100 continue
go to 140
110 continue
if (.not.(lend.gt.i)) go to 130
!
!     Col i is dependent. Swap with col lend.
max = lend
!
!     Perform-col-interchange
assign 120 to igo993
go to 560
120 continue
lend = lend - 1
!
!     Find col in remaining set with largest SS.
max = isamax(lend-i+1,h(i),1) + i - 1
hbar = h(max)
go to 30
130 continue
krank = i - 1
go to 160
140 i = ip1
ip1 = ip1 + 1
go to 10
150 krank = l1
160 continue
krp1 = krank + 1
if (.not.(krank.lt.me)) go to 290
factor = alsq
do 170 i = krp1,me
  if (l.gt.0) w(i,1) = zero
  call scopy(l, w(i,1), 0, w(i,1), mdw)
170 continue
!
!     Determine the rank of the remaining equality constraint
!     equations by eliminating within the block of constrained
!     variables.  Remove any redundant constraints.
!
ir = krp1
if (.not.(l.lt.n)) go to 245
lp1 = l + 1
recalc = .true.
lb = min0(l+me-krank,n)
i = lp1
ip1 = i + 1
180 if (.not.(i.le.lb)) go to 280
ir = krank + i - l
lend = n
mend = me
assign 190 to igo996
go to 460
!
!     Update-col-SS-and-find-pivot-col
190 assign 200 to igo993
go to 560
!
!     Perform-col-interchange
!
!     Eliminate elements in the i-TH col.
200 j = me
210 if (.not.(j.gt.ir)) go to 230
jm1 = j - 1
if (.not.(w(j,i).ne.zero)) go to 220
call srotmg(scale(jm1), scale(j), w(jm1,i), w(j,i), sparam)
w(j,i) = zero
call srotm(np1-i, w(jm1,ip1), mdw, w(j,ip1), mdw, sparam)
220 j = jm1
go to 210
!
!     SET ic=i=COL BEING ELIMINATED
230 ic = i
assign 240 to igo990
go to 520
!
!     Test-indep-of-incoming-col
240 if (indep) go to 270
!
!     Remove any redundant or dependent equality constraints.
245 continue
jj = ir
250 if (.not.(ir.le.me)) go to 260
w(ir,1) = zero
call scopy(n, w(ir,1), 0, w(ir,1), mdw)
rnorm = rnorm + (scale(ir)*w(ir,np1)/alsq)*w(ir,np1)
w(ir,np1) = zero
scale(ir) = one
!     Reclassify the zeroed row as a least squares equation.
itype(ir) = 1
ir = ir + 1
go to 250
!
!     Reduce me to reflect any discovered dependent equality
!     constraints.
260 continue
me = jj - 1
mep1 = me + 1
go to 300
270 i = ip1
ip1 = ip1 + 1
go to 180
280 continue
290 continue
300 continue
if (.not.(krank.lt.l1)) go to 420
!
!     Try to determine the variables KRANK+1 through L1 from the
!     least squares equations.  Continue the triangularization with
!     pivot element w(MEP1,i).
!
recalc = .true.
!
!     SET factor=alsq TO REMOVE EFFECT OF HEAVY WEIGHT FROM
!     test for col independence.
factor = alsq
kk = krp1
i = kk
ip1 = i + 1
310 if (.not.(i.le.l1)) go to 410
!
!     Set ir to point to the MEP1-ST row.
ir = mep1
lend = l
mend = m
assign 320 to igo996
go to 460
!
!     Update-col-SS-and-find-pivot-col
320 assign 330 to igo993
go to 560
!
!     Perform-col-interchange
!
!     Eliminate i-TH col below the ir-TH element.
330 irp1 = ir + 1
if (.not.(irp1.le.m)) go to 355
j = m
do 350 jj = irp1,m
  jm1 = j - 1
  if (.not.(w(j,i).ne.zero)) go to 340
  call srotmg(scale(jm1), scale(j), w(jm1,i), w(j,i), sparam)
  w(j,i) = zero
  call srotm(np1-i, w(jm1,ip1), mdw, w(j,ip1), mdw, sparam)
340 j = jm1
350 continue
355 continue
!
!     Test if new pivot element is near zero. If so, the col is
!     dependent.
t = scale(ir)*w(ir,i)**2
indep = t.gt.tau**2*eanorm**2
if (.not.indep) go to 380
!
!     Col test passed. Now must pass row norm test to be classified
!     as independent.
rn = zero
do 370 i1 = ir,m
  do 360 j1 = ip1,n
    rn = amax1(rn,scale(i1)*w(i1,j1)**2)
360 continue
370 continue
indep = t.gt.tau**2*rn
!
!     If independent, swap the ir-TH and KRP1-ST rows to maintain the
!     triangular form.  Update the rank indicator KRANK and the
!     equality constraint pointer me.
380 if (.not.(indep)) go to 390
call sswap(np1, w(krp1,1), mdw, w(ir,1), mdw)
call sswap(1, scale(krp1), 1, scale(ir), 1)
!     Reclassify the least SQ. Equation as an equality constraint and
!     rescale it.
itype(ir) = 0
t = sqrt(scale(krp1))
call sscal(np1, t, w(krp1,1), mdw)
scale(krp1) = alsq
me = mep1
mep1 = me + 1
krank = krp1
krp1 = krank + 1
go to 400
390 go to 430
400 i = ip1
ip1 = ip1 + 1
go to 310
410 continue
420 continue
430 continue
!
!     If pseudorank is less than l, apply Householder trans.
!     From right.
if (.not.(krank.lt.l)) go to 450
do 440 i = 1,krank
  j = krp1 - i
  call h12(1, j, krp1, l, w(j,1), mdw, h(j), w, mdw, 1, j-1)
440 continue
450 niv = krank + nsoln - l
niv1 = niv + 1
if (l.eq.n) done = .true.
!
!  END OF INITIAL TRIANGULARIZATION.
idope(1) = me
idope(2) = mep1
idope(3) = krank
idope(4) = krp1
idope(5) = nsoln
idope(6) = niv
idope(7) = niv1
idope(8) = l1
return
460 continue
!
!     To update-col-SS-and-find-pivot-col
!
!     The col SS vector will be updated at each step. When
!     numerically necessary, these values will be recomputed.
!
if (.not.(ir.ne.1 .and. (.not.recalc))) go to 480
!     UPDATE COL SS =SUM OF SQUARES.
do 470 j = i,lend
  h(j) = h(j) - scale(ir-1)*w(ir-1,j)**2
470 continue
!
!     Test for numerical accuracy.
max = isamax(lend-i+1,h(i),1) + i - 1
recalc = hbar + tenm3*h(max).eq.hbar
!
!     If required, recalculate col SS, using rows ir through mend.
480 if (.not.(recalc)) go to 510
do 500 j = i,lend
  h(j) = zero
  do 490 k = ir,mend
    h(j) = h(j) + scale(k)*w(k,j)**2
490 continue
500 continue
!
!     Find col with largest SS.
max = isamax(lend-i+1,h(i),1) + i - 1
hbar = h(max)
510 go to 600
520 continue
!
!     To test-indep-of-incoming-col
!
!     Test the col ic to determine if it is linearly independent
!     of the cols already in the basis.  In the init TRI
!     step, we usually want the heavy weight ALAMDA to
!     be included in the test for independence.  In this case the
!     value of factor will have been set to 1.E0 before this
!     procedure is invoked.  In the potentially rank deficient
!     problem, the value of factor will have been
!     SET TO alsq=ALAMDA**2 TO REMOVE THE EFFECT OF THE HEAVY WEIGHT
!     from the test for independence.
!
!     Write new col as partitioned vector
!             (A1)  NUMBER OF COMPONENTS IN SOLN SO FAR = NIV
!             (A2)  m-NIV COMPONENTS
!     AND COMPUTE  sn = INVERSE WEIGHTED LENGTH OF A1
!                  rn = INVERSE WEIGHTED LENGTH OF A2
!     CALL THE COL INDEPENDENT WHEN rn .GT. tau*sn
sn = zero
rn = zero
do 550 j = 1,mend
  t = scale(j)
  if (j.le.me) t = t/factor
  t = t*w(j,ic)**2
  if (.not.(j.lt.ir)) go to 530
  sn = sn + t
  go to 540
530 rn = rn + t
540 continue
550 continue
indep = rn.gt.tau**2*sn
go to 590
560 continue
!
!     To perform-col-interchange
!
if (.not.(max.ne.i)) go to 570
!     Exchange elements of permuted index vector and perform col
!     interchanges.
itemp = ipivot(i)
ipivot(i) = ipivot(max)
ipivot(max) = itemp
call sswap(m, w(1,max), 1, w(1,i), 1)
t = h(max)
h(max) = h(i)
h(i) = t
570 go to igo993, (30, 200, 330, 120)
590 go to igo990, (40, 240)
600 go to igo996, (20, 190, 320)
end subroutine wnlit

subroutine l2slv(m, n, m1, l, a, mm, b, mb, w, tol, n1, ipivot, &
&x, nn, res, mr, qr, mmpnn, c, ifault)
implicit none
integer, intent(inout) :: ifault
integer, intent(in) :: l, m, m1, mb, mm, mmpnn, mr, n
integer, intent(inout) :: n1
integer, intent(in) :: nn
integer :: i, iter, j, jm1, k, k0, k1, k10, k11, k12, k2, k3, k4, &
&k5, k6, k7, k8, k9, ksum, m1p1, mp1, mpi, mpn, numit
real :: spmpar
! ** PURPOSE **
! subroutine l2slv computes least squares solutions to overdetermined
! and underdetermined systems of linear equations.  The method used is
! a modified Gram-Schmidt orthogonal decomposition with iterative
! refinement of the solution.  The solution may be subject to linear
! equality constraints.  Output includes the least squares
! coefficients, residuals, unscaled covariance matrix, and information
! on the behavior of the iterative refinement procedure.
! Matrix a is the given matrix of a system of m linear equations in n
! unknowns, and matrix w is a given diagonal matrix of weights with all
! DIAGONAL ELEMENTS NONNEGATIVE.  LET H = w*a.
! In the event that n1 (the computed rank of matrix H) is less than n
! (the number of unknown coefficients), a unique solution vector having
! n elements can be obtained by imposing the condition that the
! solution be of minimal Euclidean norm.  Such a solution is sought in
! the case of underdetermined or rank-deficient problems.
!
! ** INPUT VARIABLES **
! m      TOTAL NUMBER OF EQUATIONS.
! n      NUMBER OF UNKNOWN COEFFICIENTS.
! m1     NUMBER OF LINEAR CONSTRAINTS (0.LE.m1.LE.m AND m1.LE.n).
! l      NUMBER OF RIGHT-HAND SIDES (VECTORS OF OBSERVATIONS).
! a      TWO-DIMENSIONAL ARRAY OF size (mm,n).  ON ENTRY, THE ARRAY a
!        contains the given matrix of a system of m linear equations
!        in n unknowns, where the first m1 equations are to be
!        satisfied exactly.  A is left intact on exit.
! b      TWO-DIMENSIONAL ARRAY OF size (mb,l).  ON ENTRY, b CONTAINS
!        the l given right-hand sides (vectors of observations).  b is
!        left intact on exit.
! w      VECTOR OF SIZE m.  ON ENTRY, w CONTAINS THE DIAGONAL ELEMENTS
!        of a given diagonal matrix of weights, all nonnegative.
!        (The first m1 elements of w are set equal to 1.0 by the
!        program when m1 is greater than zero.)
! tol    PARAMETER USED IN DETERMINING THE RANK OF MATRIX H.
!        Note --
!        (1) if tol equals zero, the tolerance used in subroutine
!            decom2 will be based on machine precision.
!        (2) If tol is greater than zero, this value of tol will be
!            used in setting an absolute tolerance for comparison with
!            diagonal elements of the triangular matrix obtained in
!            subroutine decom2.  The value of tol can be based on
!            knowledge concerning the accuracy of the data.
! mm     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY a.  mm MUST SATISFY mm.GE.m.
! mb     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY b.  mb MUST SATISFY mb.GE.m.
! mr     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY res.  mr MUST SATISFY mr.GE.m.
! nn     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY x.  nn MUST SATISFY nn.GE.n.
! mmpnn  dimensioning parameter specifying maximum number of rows in
!        THE ARRAY qr.  mmpnn MUST SATISFY mmpnn.GE.m+n.
!
! ** OUTPUT VARIABLES AND INTERNAL VARIABLES **
! n1     COMPUTED RANK OF MATRIX H, WHERE H = w*a.
! ipivot vector of size n.  on exit, this array records the order
!        in which the columns of H were selected by the pivoting
!        scheme in the course of the orthogonal decomposition.
!        WHENEVER n1.LT.n, THE FIRST n1 ELEMENTS OF ipivot INDICATE
!        which columns of H were found to be linearly independent.
! x      TWO-DIMENSIONAL ARRAY OF size (nn,l).  ON EXIT, x CONTAINS
!        the solution vectors.
! RES    TWO-DIMENSIONAL ARRAY OF size (mr,l).  ON EXIT, RES CONTAINS
!        the residual vectors.
! QR     TWO-DIMENSIONAL ARRAY OF size (mmpnn,n).  ON EXIT, IF n1 = n
!        then QR contains the unscaled covariance matrix. (QR is used
!        internally to store the results from the subroutine decom2.
!        The results from decom2 are destroyed when the covariance
!        matrix is computed.)
! c      VECTOR HAVING AT LEAST 6*(m+n)+2*l ELEMENTS USED (1) FOR
!        internal work space and (2) for returning information on the
!        behavior of the iterative refinement procedure.
!        (A) NUMIT is the number of iterations carried out during the
!            iterative refinement in attempting to obtain a solution
!            for the k-TH right-hand side.
!            ON EXIT, c(k) = +NUMIT IF THE SOLUTION CONVERGED, AND
!                     c(k) = -NUMIT IF THE SOLUTION FAILED TO CONVERGE.
!        (b) digitx gives an estimate of the number of correct digits
!            in the initial solution of the coefficients for the k-TH
!            RIGHT-HAND SIDE.  ON EXIT, c(k+l) = digitx.
! ifault fault indicator which is zero if no errors were encountered
!        and positive if errors were detected or if evidence of severe
!        ill-conditioning was found.  If ifault is set to 1, 2, 3, 4,
!        5, 6 or 7, execution is terminated.  Execution continues when
!        ifault is set equal to 8, 9 or 10 provided that a solution
!        was obtained for at least one right-hand side.  The value of
!        ifault is used to indicate the following --
!        0 = NO ERRORS ENCOUNTERED.
!        1 = BAD INPUT PARAMETER (m, n OR l).
!        2 = BAD INPUT PARAMETER (m1).
!        3 = BAD DIMENSION.  EITHER m.GT.mm, m.GT.mb, m.GT.mr,
!            n.GT.nn, OR m+n.GT.mmpnn.
!        4 = AT LEAST ONE WEIGHT IS NEGATIVE.
!        5 = EITHER MATRIX H OR MATRIX OF CONSTRAINTS EQUALS ZERO.
!        6 = CONSTRAINTS ARE LINEARLY DEPENDENT.
!        7 = ALL SOLUTIONS FAILED TO CONVERGE.
!        8 = SOLUTION FAILED TO CONVERGE FOR AT LEAST ONE RIGHT-HAND
!            side.
!        9 = LARGE NUMBER OF ITERATIONS REQUIRED FOR CONVERGENCE.
!       10 = ESTIMATED NUMBER OF DIGITS IN INITIAL SOLUTION OF
!            coefficients is small.
!       11 = DIAGONAL ELEMENT OF COVARIANCE MATRIX WAS COMPUTED TO BE
!            negative owing to rounding error. No severe conditioning
!            problems were detected.
!       12 = DIAGONAL ELEMENT OF COVARIANCE MATRIX WAS COMPUTED TO BE
!            negative owing to rounding error. The problem appears to
!            be extremely ill-conditioned.
!
! ** SUBROUTINES REQUIRED **
! SUBROUTINE decom2
!        uses modified Gram-Schmidt algorithm with pivoting to
!        obtain an orthogonal decomposition of the input matrix.
! SUBROUTINE solve2
!        computes coefficients and residuals.  Iterative refinement is
!        used to improve the accuracy of the initial solution.
! SUBROUTINE solve3
!        called only by subroutine solve2.
! SUBROUTINE covar
!        computes unscaled covariance matrix of the coefficients.
!
! ** STORAGE REQUIREMENTS **
! the storage required for the dimensioned arrays in l2slv is
!   m*(2*n + 2*l + 7) + n*(n + l + 7) + 2*l
! locations.  All arrays required in subroutines called by l2slv are
! declared herein and are transmitted only through parameter lists of
! CALL-SEQUENCES.
!
! ** PRECISION OF ARITHMETIC CALCULATIONS **
! single precision arithmetic is used for all calculations except the
! double precision accumulation of inner products.  (The variable SUM
! is declared to be double precision in subroutines decom2, solve2,
! solve3 and covar.)  It is essential for the success of the iterative
! refinement procedure that inner products be accumulated in double
! precision.
!
! ** CONVERSION OF THE PROGRAM TO DOUBLE PRECISION **
! *********************************************************************
! * On computers having short word length (as the IBM 360/370) it may *
! * be desirable to perform all calculations in double precision.  In *
! * this case, the iterative refinement presently included in solve2  *
! * SHOULD BE OMITTED.                                                *
! * TO CONVERT THE PROGRAM TO DOUBLE PRECISION, THE FOLLOWING         *
! * APPROACH IS SUGGESTED.                                            *
! *                                                                   *
! * 1. VARIABLES PRESENTLY DECLARED TO BE REAL SHOULD BE DECLARED     *
! *    DOUBLE PRECISION.  THOSE TYPED INTEGER, DOUBLE PRECISION AND   *
! *    LOGICAL SHOULD NOT BE CHANGED.                                 *
! * 2. THE USE OF FAIL, NUMIT AND digitx SHOULD BE OMITTED.           *
! * 3. DESCRIPTION OF VARIABLE c (AT L2B 690-790) SHOULD READ --      *
! *    c  VECTOR HAVING AT LEAST 6*(m+n) ELEMENTS USED ONLY FOR       *
! *       INTERNAL WORK SPACE.                                        *
! * 4. The value of eta (at L2B 1960) should be set so that it is the *
! *    SMALLEST POSITIVE DOUBLE PRECISION NUMBER SUCH THAT 1.0 + eta  *
! *    IS GREATER THAN 1.0 IN DOUBLE PRECISION ARITHMETIC.            *
! *    FOR IBM COMPUTER TYPE, eta = 16.**(-13)                        *
! *    FOR UNIVAC COMPUTER TYPE, eta = 2.**(-59)                      *
! * 5. THE FOLLOWING FORTRAN FUNCTIONS SHOULD BE CHANGED --           *
! *      SINGLE PRECISION NAME     DOUBLE PRECISION NAME              *
! *             dble(x)                x                              *
! *             FLOAT(n)               dble(FLOAT(n))                 *
! *             sqrt(x)                dsqrt(x)                       *
! *    dble(x) IS USED IN SUBROUTINES decom2, solve2, solve3 AND      *
! *       covar.                                                      *
! *    FLOAT(n) IS USED IN SUBROUTINE decom2.                         *
! *    sqrt(x) IS USED IN SUBROUTINE l2slv.                           *
! * 6. REPLACE STATEMENT L2B 2500 BY A STATEMENT READING              *
! *          k3 = 1                                                   *
! * 7. FURTHER DETAILS ARE GIVEN IN SUBROUTINE solve2 IN CONNECTION   *
! *    WITH THE OMISSION OF ITERATIVE REFINEMENT.                     *
! * 8. In subroutine l2slv, statements L2B 950-1000, 1820-1830, 2020, *
! *    2350-2360, 2480-2490, 3070, 3280-3570 AND 3590-3620 SHOULD BE  *
! *    OMITTED.                                                       *
! *    STATEMENT NUMBERS GIVEN HERE REFER TO THOSE IN THE RIGHT-HAND  *
! *    MARGIN.  CERTAIN COMMENTS IN SUBROUTINE l2slv DO NOT APPLY TO  *
! *    THE DOUBLE PRECISION VERSION.                                  *
! *                                                                   *
! *********************************************************************
!
integer, intent(inout) :: ipivot(n)
real, intent(in) :: a(mm,n), b(mb,l)
real, intent(inout) :: c(*)
real :: eta
real, intent(inout) :: qr(mmpnn,n), res(mr,l), tol, w(m), x(nn,l)
real :: digitx
logical :: fail
logical :: sing
!
! Set value of eta, a machine-dependent parameter.
! eta, the relative machine precision, is the smallest positive real
! number such that 1.0 + eta is greater than 1.0 in floating-point
! arithmetic.
!
eta = spmpar(1)
!
! Default value for tol is zero.
!
if (tol.lt.0.0) tol = 0.0
ifault = 0
ksum = 0
!
! Perform initial checking of input parameters, dimensions and
! weights for possible errors.
!
if (m.gt.0 .and. n.gt.0 .and. l.gt.0) go to 10
ifault = 1
return
10 if (m1.le.m .and. m1.le.n .and. m1.ge.0) go to 20
ifault = 2
return
20 if (m.le.mm .and. m.le.mb .and. m.le.mr .and. n.le.nn &
&.and. m+n.le.mmpnn) go to 30
ifault = 3
return
30 do 40 i = 1,m
  if (m1.gt.0 .and. i.le.m1) w(i) = 1.0
  if (w(i).ge.0.0) go to 40
  ifault = 4
  return
40 continue
!
! Set parameters which allocate vector c to contain certain final
! results and also to be used as work space.
!
! k1 is starting point for NUMIT and fail, of length l.
! k2 is starting point for digitx, of length l.
! k3 is starting point for D, of length n.
! k4 is starting point for k-TH column of b, of length m.
! K5 is starting point for k-TH column of x, of length n.
! K6 is starting point for k-TH column of res, of length m.
! K7 is starting point for work space of length m.
! K8 is starting point for work space of length m.
! K9 is starting point for work space of length n.
! k10 is starting point for work space of length n.
! k11 is starting point for work space of length m + n.
! k12 is starting point for work space of length m + n.
!
k1 = 1
k2 = k1 + l
k3 = k2 + l
k4 = k3 + n
k5 = k4 + m
k6 = k5 + n
k7 = k6 + m
k8 = k7 + m
k9 = k8 + m
k10 = k9 + n
k11 = k10 + n
k12 = k11 + m + n
k = k12 + m + n - 1
!
! Multiply each row of matrix a (m by n) by its appropriate weight and
! store the result in the first m rows of array qr.  Set array c and
! the last n rows of array qr equal to zero.
!
do i=1,k
  c(i) = 0.0
end do
mp1 = m + 1
mpn = m + n
do j=1,n
  do i=1,m
    qr(i,j) = a(i,j)*w(i)
  end do
  do i=mp1,mpn
    qr(i,j) = 0.0
  end do
end do
!
! Obtain an orthogonal decomposition of the matrix stored in the first
! m rows of array qr and compute its rank.
!
call decom2(m, n, m1, eta, tol, qr, c(k3), n1, ipivot, sing, &
&mmpnn)
!
if (.not.sing) go to 110
if (n1.gt.0) go to 100
ifault = 5
return
100 ifault = 6
return
!
! Seek a solution (coefficients and residuals) for each of the l least
! squares problems whose right-hand sides are given in the array b.
!
110 iter = -alog10(eta)
do 200 k = 1,l
! k-TH right-hand side.
  k0 = k4 - 1
  do i=1,m
    k0 = k0 + 1
    c(k0) = b(i,k)
  end do
!
  call solve2(m, n, m1, a, c(k4), w, n1, ipivot, qr, c(k3), &
&eta, fail, numit, digitx, &
&c(k5), c(k6), c(k7), c(k8), c(k9), c(k10), c(k11), c(k12), &
&mm, mmpnn)
!
  k0 = k5 - 1
  do j=1,n
    k0 = k0 + 1
    x(j,k) = c(k0)
  end do
  if (m1.eq.0) go to 150
  do i=1,m1
    res(i,k) = 0.0
  end do
150 m1p1 = m1 + 1
  if (m1p1.gt.m) go to 170
  k0 = k6 + m1 - 1
  do i=m1p1,m
    k0 = k0 + 1
    res(i,k) = c(k0)
  end do
170 continue
!
! For right-hand sides where convergence of a solution is reported,
! a check is made for evidence of severe ill-conditioning.  Such
! evidence is furnished by large values of NUMIT (number of iterations
! before convergence was obtained) and small values of digitx
! (estimate of the number of correct digits in the initial solution
! of the coefficients).  If NUMIT exceeds -ALOG10(eta) then ifault
! is set to 9.  If digitx is less than 0.5 (half a decimal digit)
! then ifault is set to 10.
!
  c(k) = float(numit)
  if (fail) c(k) = -c(k)
  k0 = k2 + k - 1
  c(k0) = digitx
  if (.not.fail) go to 180
! KSUM is a tally of solutions which failed to converge.
  ksum = ksum + 1
  ifault = 8
  go to 200
180 if (numit.le.iter) go to 190
  ifault = 9
190 if (digitx.ge.0.5) go to 200
  ifault = 10
200 continue
if (ksum.lt.l) go to 210
ifault = 7
return
210 if (n1.lt.n) return
do i=1,n
  mpi = m + i
  do j=1,n
    qr(i,j) = qr(mpi,j)
  end do
  qr(i,i) = 0.0
end do
!
! Compute the unscaled covariance matrix of the coefficients.
!
call covar(n, m1, n1, ipivot, qr, c(k3), c(k9), mmpnn)
if (n.eq.1) go to 260
do j=2,n
jm1 = j - 1
  do 240 i = 1,jm1
240 qr(i,j) = qr(j,i)
end do
!
! In certain problems, some diagonal terms of the unscaled covariance
! matrix are equal to zero or to small positive numbers.  Because of
! rounding errors, computed values for these terms may be small
! negative numbers.  ifault is set to 11 if this occurs.
!
260 do j=1,n
  if (qr(j,j).lt.0.0) go to 280
end do
return
280 if (ifault.ne.0) go to 290
ifault = 11
return
290 ifault = 12
return
end subroutine l2slv

!     subroutine decom2(...)
! subroutine decom2 uses a modified Gram-Schmidt algorithm with
! pivoting to obtain an orthogonal decomposition of the input matrix
! given in QR.
! The input parameter tol (equal either to zero or to a positive
! number) is used in determining the rank of matrix qr.
! Note --
!     (1) if tol equals zero, the tolerance used at statement DC2 1180
!         will be based on machine precision.
!         Under this approach, the tolerance (TOL2) is set equal to
!         (FLOAT(n)*eta)**2*D(m1+1) AT STATEMENT DC2 1170.
!         If desired, the user can obtain a more conservative
!         tolerance by replacing n in this statement by a larger
!         quantity.
!     (2) If tol is greater than zero, TOL2 (which is set equal to
!         tol) will be used at statement DC2 1180 as an absolute
!         tolerance for comparison with diagonal elements of the
!         triangular matrix obtained in the decomposition.  Under this
!         approach, the value of tol can be based on knowledge
!         concerning the accuracy of the data.
! On exit, the arrays QR, D and ipivot contain the results of the
! decomposition which are needed for obtaining an initial solution
! and for iterative refinement.
! On exit, n1 is the computed rank of the input matrix qr.
! On exit, sing is set equal to .True. Whenever
!     (1) n1 = 0 (I.E., INPUT MATRIX qr EQUALS ZERO OR MATRIX OF
!         constraints equals zero), or
!     (2) n1 is less than m1 (I.E., The m1 by n matrix of linear
!         constraints is singular).
! OTHERWISE, ON EXIT FROM decom2, sing = .FALSE.
! On exit, the vector ipivot records the order in which the columns
! of QR were selected by the pivoting scheme in the course of the
! orthogonal decomposition.
subroutine decom2(m, n, m1, eta, tol, qr, d, n1, ipivot, sing, &
&mmpnn)
implicit none
integer, intent(in) :: m, m1, mmpnn, n
integer, intent(out) :: n1
integer :: ik, j, jj, k, km1, l, lmm, mh, mp1, mpn1, ms, mv, np, &
&ns, nsp1
integer, intent(inout) :: ipivot(n)
real :: c
real, intent(inout) :: d(*)
real :: dm, ds
real, intent(in) :: eta
real, intent(inout) :: qr(mmpnn,n)
real :: rsj
real, intent(in) :: tol
real :: tol2
double precision :: sum
logical :: finis, fsum
logical, intent(out) :: sing
n1 = 0
sing = .true.
fsum = .true.
mv = 1
mh = m1
ms = m
mp1 = m + 1
finis = .false.
if (tol.gt.0.0) tol2 = tol
do j=1,n
  d(j) = 0.0
  ipivot(j) = j
end do
! Step number NS of the decomposition.
do ns=1,n
  k = m + ns
  if (ns.eq.m1+1) go to 20
  go to 30
20 if (m1.eq.m) go to 200
  mv = m1 + 1
  mh = m
  fsum = .true.
30 if (.not.finis) go to 40
  go to 150
! Pivot search.
40 ds = 0.0
  np = ns
  do 90 j = ns,n
    if (fsum) go to 50
    go to 70
50 sum = 0.0
    do l=mv,mh
      sum = sum + dble(qr(l,j))*dble(qr(l,j))
    end do
    d(j) = sum
70 if (ds.lt.d(j)) go to 80
    go to 90
80 ds = d(j)
    np = j
90 continue
  if (fsum) dm = ds
  if (ds.lt.eta*dm) go to 100
  fsum = .false.
  go to 110
100 fsum = .true.
110 if (fsum) go to 40
  if (np.ne.ns) go to 120
  go to 140
! Column interchange.
120 ik = ipivot(np)
  ipivot(np) = ipivot(ns)
  ipivot(ns) = ik
  d(np) = d(ns)
  km1 = k - 1
  do l=1,km1
    c = qr(l,np)
    qr(l,np) = qr(l,ns)
    qr(l,ns) = c
  end do
! END COLUMN INTERCHANGE.
! END PIVOT SEARCH.
! RETURN HERE IF n1 = 0.  EITHER INPUT MATRIX qr EQUALS ZERO OR
! matrix of constraints equals zero.
140 if (ns.eq.1 .and. ds.eq.0.0) return
  go to 160
150 ms = k - 1
  mh = k - 1
160 if (finis) go to 170
  c = 0.0
  go to 180
170 c = 1.0
180 sum = dble(c)
  do l=mv,mh
    sum = sum + dble(qr(l,ns))*dble(qr(l,ns))
  end do
  d(ns) = sum
  ds = d(ns)
  if (tol.eq.0.0) tol2 = (float(n)*eta)**2*d(m1+1)
  if (.not.finis .and. ns.gt.m1 .and. ds.le.tol2) go to 200
  go to 290
200 finis = .true.
  mv = m + 1
  do np=ns,n
    if (1.gt.m1) go to 250
    do l=1,m1
      qr(l,np) = 0.0
    end do
    do j=1,m1
      sum = 0.0
      do l=1,m
        sum = sum + dble(qr(l,j))*dble(qr(l,np))
      end do
      c = sum
      c = c/d(j)
      do l=1,m1
        qr(l,np) = qr(l,np) - c*qr(l,j)
      end do
    end do
250 mpn1 = m + n1
    do jj=mp1,mpn1
      j = (m + 1) + (m + n1) - jj
      sum = 0.0
      do l=j,mpn1
        lmm = l - m
        sum = sum + dble(qr(j,lmm))*dble(qr(l,np))
      end do
      qr(j,np) = -sum
    end do
  end do
  go to 150
! RETURN HERE IF MATRIX OF CONSTRAINTS IS FOUND TO BE SINGULAR.
290 if (ds.eq.0.0) return
  qr(k,ns) = -1.0
  nsp1 = ns + 1
  if (nsp1.gt.n) go to 340
! Begin orthogonalization.
  do 330 j = nsp1,n
    sum = 0.0
    do l=mv,mh
      sum = sum + dble(qr(l,j))*dble(qr(l,ns))
    end do
    rsj = sum
    rsj = rsj/ds
    qr(k,j) = rsj
    do l=1,ms
      qr(l,j) = qr(l,j) - rsj*qr(l,ns)
    end do
    if (.not.finis) go to 320
    go to 330
320 d(j) = d(j) - ds*rsj*rsj
330 continue
! END ORTHOGONALIZATION.
340 if (.not.finis) n1 = n1 + 1
end do
! END STEP NUMBER NS.
sing = .false.
! Normal return.
return
end subroutine decom2

!     subroutine solve2(...)
! subroutine solve2 uses the orthogonal decomposition stored in QR, d
! and ipivot to compute the solution (coefficients and residuals)
! to the least squares problem whose right-hand side is given in B.
! In the event that n1 (the computed rank of matrix H) is less than n
! (the number of unknown coefficients), a unique solution vector having
! n elements can be obtained by imposing the condition that the
! solution be of minimal Euclidean norm.  Such a solution is sought in
! the case of underdetermined or rank-deficient problems.
! In normal exits, the solution is contained in the vector X
! (coefficients) and the vector RES (residuals).
! Iterative refinement is used to improve the accuracy of the initial
! solution.
! On exit, fail is set equal to .True. If the solution fails to
! IMPROVE SUFFICIENTLY.  OTHERWISE, FAIL = .FALSE.  INFORMATION ON THE
! behavior of the iterative refinement procedure is given by NUMIT and
! DIGITX.  NUMIT is the number of iterations carried out in attempting
! to obtain a solution.  DIGITX is an estimate of the number of
! correct digits in the initial solution of the coefficients.
! This subroutine calls subroutine solve3.
!
! ********* CONVERSION OF THIS SUBROUTINE TO DOUBLE PRECISION *********
! * if the program is converted so that all calculations are done in  *
! * DOUBLE PRECISION ARITHMETIC, THE ITERATIVE REFINEMENT PRESENTLY   *
! * INCLUDED IN solve2 SHOULD BE OMITTED, SINCE THE SUCCESS OF THIS   *
! * PROCEDURE DEPENDS ON COMPUTING INNER PRODUCTS IN GREATER          *
! * PRECISION THAN OTHER CALCULATIONS.                                *
! * SEE COMMENTS IN SUBROUTINE l2slv REGARDING CONVERSION TO DOUBLE   *
! * PRECISION.  IN ADDITION, THE FOLLOWING COMMENTS INDICATE HOW TO   *
! * OMIT THE ITERATIVE REFINEMENT FROM THIS SUBROUTINE.  STATEMENT    *
! * NUMBERS GIVEN HERE REFER TO THOSE IN THE RIGHT-HAND MARGIN.       *
! *                                                                   *
! * 1. IN STATEMENT SV2 470 CHANGE REAL TO DOUBLE PRECISION.          *
! * 2. REPLACE STATEMENT SV2 880 BY A STATEMENT READING               *
! *       30 DO 50 I=1,m                                              *
! * 3. REPLACE STATEMENTS SV2 1310-1400 BY A STATEMENT READING        *
! *          RETURN                                                   *
! * 4. OMIT STATEMENTS SV2 120-190, 440, 490-500, 520-550, 650,       *
! *    750-850, 1650-1830 AND 1850-1910.                              *
! *                                                                   *
! *********************************************************************
!
