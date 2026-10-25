subroutine dseig (a, ka, n, w, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka
integer :: n
integer :: l
!-----------------------------------------------------------------------
!                DOUBLE PRECISION COMPUTATION OF THE
!               EIGENVALUES OF SYMMETRIC REAL MATRICES
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
!                 DOUBLE PRECISION COMPUTATION OF
!                 EIGENVALUES AND EIGENVECTORS OF
!                     SYMMETRIC REAL MATRICES
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
!     DOUBLE PRECISION DSQRT,DABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TRED1,
!     NUM. MATH. 11, 181-195(1968) BY MARTIN, REINSCH, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 212-226(1971).
!
!     THIS SUBROUTINE REDUCES A REAL SYMMETRIC MATRIX
!     TO A SYMMETRIC TRIDIAGONAL MATRIX USING
!     ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        A CONTAINS THE REAL SYMMETRIC INPUT MATRIX.  ONLY THE
!          LOWER TRIANGLE OF THE MATRIX NEED BE SUPPLIED.
!
!     ON OUTPUT-
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS-
!          FORMATIONS USED IN THE REDUCTION IN ITS STRICT LOWER
!          TRIANGLE.  THE FULL UPPER TRIANGLE OF A IS UNALTERED,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE TRIDIAGONAL MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE TRIDIAGONAL
!          MATRIX IN ITS LAST N-1 POSITIONS.  E(1) IS SET TO ZERO,
!
!        E2 CONTAINS THE SQUARES OF THE CORRESPONDING ELEMENTS OF E.
!          E2 MAY COINCIDE WITH E IF THE SQUARES ARE NOT NEEDED.
!
!-----------------------------------------------------------------------
!
do 100 i = 1, n
100 d(i) = a(i,i)
!     ********** FOR I=N STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   h = 0.d0
   scale = 0.d0
   if (l .lt. 1) go to 130
!     ********** SCALE ROW (ALGOL TOL THEN NOT NEEDED) **********
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
!     ********** FORM ELEMENT OF A*U **********
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
!     ********** FORM REDUCED A **********
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
!     ********** LAST CARD OF DTRED1 **********
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
!     DOUBLE PRECISION DSQRT,DABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TRED3,
!     NUM. MATH. 11, 181-195(1968) BY MARTIN, REINSCH, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 212-226(1971).
!
!     THIS SUBROUTINE REDUCES A REAL SYMMETRIC MATRIX, STORED AS
!     A ONE-DIMENSIONAL ARRAY, TO A SYMMETRIC TRIDIAGONAL MATRIX
!     USING ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        NV MUST BE SET TO THE DIMENSION OF THE ARRAY PARAMETER A
!          AS DECLARED IN THE CALLING PROGRAM DIMENSION STATEMENT,
!
!        A CONTAINS THE LOWER TRIANGLE OF THE REAL SYMMETRIC
!          INPUT MATRIX, STORED ROW-WISE AS A ONE-DIMENSIONAL
!          ARRAY, IN ITS FIRST N*(N+1)/2 POSITIONS.
!
!     ON OUTPUT-
!
!        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL
!          TRANSFORMATIONS USED IN THE REDUCTION,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE TRIDIAGONAL MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE TRIDIAGONAL
!          MATRIX IN ITS LAST N-1 POSITIONS.  E(1) IS SET TO ZERO,
!
!        E2 CONTAINS THE SQUARES OF THE CORRESPONDING ELEMENTS OF E.
!          E2 MAY COINCIDE WITH E IF THE SQUARES ARE NOT NEEDED.
!
!-----------------------------------------------------------------------
!
!     ********** FOR I=N STEP -1 UNTIL 1 DO -- **********
do ii = 1, n
   i = n + 1 - ii
   l = i - 1
   iz = (i * l) / 2
   h = 0.d0
   scale = 0.d0
   if (l .lt. 1) go to 130
!     ********** SCALE ROW (ALGOL TOL THEN NOT NEEDED) **********
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
!     ********** FORM ELEMENT OF A*U **********
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
!     ********** FORM REDUCED A **********
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
!     ********** LAST CARD OF DTRED3 **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TQLRAT,
!     ALGORITHM 464, COMM. ACM 16, 689(1973) BY REINSCH.
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES OF A SYMMETRIC
!     TRIDIAGONAL MATRIX BY THE RATIONAL QL METHOD.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX,
!
!        E2 CONTAINS THE SQUARES OF THE SUBDIAGONAL ELEMENTS OF THE
!          INPUT MATRIX IN ITS LAST N-1 POSITIONS.  E2(1) IS ARBITRARY.
!
!      ON OUTPUT-
!
!        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT AND
!          ORDERED FOR INDICES 1,2,...IERR-1, BUT MAY NOT BE
!          THE SMALLEST EIGENVALUES,
!
!        E2 HAS BEEN DESTROYED,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 50 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
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
!     ********** E2(N) IS ALWAYS ZERO, SO THERE IS NO EXIT
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
!     ********** FOR I=M-1 STEP -1 UNTIL L DO -- **********
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
!     ********** FOR I=L STEP -1 UNTIL 2 DO -- **********
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
!     ********** LAST CARD OF DTQL **********
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
!     DOUBLE PRECISION DSQRT,DABS
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TRED2,
!     NUM. MATH. 11, 181-195(1968) BY MARTIN, REINSCH, AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 212-226(1971).
!
!     THIS SUBROUTINE REDUCES A REAL SYMMETRIC MATRIX TO A
!     SYMMETRIC TRIDIAGONAL MATRIX USING AND ACCUMULATING
!     ORTHOGONAL SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        A CONTAINS THE REAL SYMMETRIC INPUT MATRIX.  ONLY THE
!          LOWER TRIANGLE OF THE MATRIX NEED BE SUPPLIED.
!
!     ON OUTPUT-
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE TRIDIAGONAL MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE TRIDIAGONAL
!          MATRIX IN ITS LAST N-1 POSITIONS.  E(1) IS SET TO ZERO,
!
!        Z CONTAINS THE ORTHOGONAL TRANSFORMATION MATRIX
!          PRODUCED IN THE REDUCTION,
!
!        A AND Z MAY COINCIDE.  IF DISTINCT, A IS UNALTERED.
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
!     ********** FOR I=N STEP -1 UNTIL 2 DO -- **********
do ii = 2, n
   i = n + 2 - ii
   l = i - 1
   h = 0.d0
   scale = 0.d0
   if (l .lt. 2) go to 130
!     ********** SCALE ROW (ALGOL TOL THEN NOT NEEDED) **********
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
!     ********** FORM ELEMENT OF A*U **********
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
!     ********** FORM REDUCED A **********
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
!     ********** LAST CARD OF DTRED2 **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE TQL2,
!     NUM. MATH. 11, 293-306(1968) BY BOWDLER, MARTIN, REINSCH, AND
!     WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 227-240(1971).
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS
!     OF A SYMMETRIC TRIDIAGONAL MATRIX BY THE QL METHOD.
!     THE EIGENVECTORS OF A FULL SYMMETRIC MATRIX CAN ALSO
!     BE FOUND IF  TRED2  HAS BEEN USED TO REDUCE THIS
!     FULL MATRIX TO TRIDIAGONAL FORM.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        D CONTAINS THE DIAGONAL ELEMENTS OF THE INPUT MATRIX,
!
!        E CONTAINS THE SUBDIAGONAL ELEMENTS OF THE INPUT MATRIX
!          IN ITS LAST N-1 POSITIONS.  E(1) IS ARBITRARY,
!
!        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
!          REDUCTION BY  TRED2, IF PERFORMED.  IF THE EIGENVECTORS
!          OF THE TRIDIAGONAL MATRIX ARE DESIRED, Z MUST CONTAIN
!          THE IDENTITY MATRIX.
!
!      ON OUTPUT-
!
!        D CONTAINS THE EIGENVALUES IN ASCENDING ORDER.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES ARE CORRECT BUT
!          UNORDERED FOR INDICES 1,2,...,IERR-1,
!
!        E HAS BEEN DESTROYED,
!
!        Z CONTAINS ORTHONORMAL EIGENVECTORS OF THE SYMMETRIC
!          TRIDIAGONAL (OR FULL) MATRIX.  IF AN ERROR EXIT IS MADE,
!          Z CONTAINS THE EIGENVECTORS ASSOCIATED WITH THE STORED
!          EIGENVALUES,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 50 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER. ASSIGN
!                MACHEP THE VALUE U WHERE U IS THE SMALLEST POSITIVE
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
!     ********** E(N) IS ALWAYS ZERO, SO THERE IS NO EXIT
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
!     ********** FOR I=M-1 STEP -1 UNTIL L DO -- **********
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
!     ********** LAST CARD OF DTQL2 **********
end subroutine dtql2

subroutine ceig(ibal,ar,ai,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, low
!-----------------------------------------------------------------------
!                EIGENVALUES OF COMPLEX MATRICES
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
!          EIGENVALUES AND EIGENVECTORS OF COMPLEX MATRICES
!-----------------------------------------------------------------------
real, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), wi(n), zr(ka,n), &
&zi(ka,n), temp(*)
!----------------------
!     TEMP IS A TEMPORARY STORAGE AREA
!        DIMENSION(TEMP) .GE. 2*N    IF IBAL .EQ. 0
!        DIMENSION(TEMP) .GE. 3*N    IF IBAL .NE. 0
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
!     REAL ABS
logical :: noconv
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE
!     CBALANCE, WHICH IS A COMPLEX VERSION OF BALANCE,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     THIS SUBROUTINE BALANCES A COMPLEX MATRIX AND ISOLATES
!     EIGENVALUES WHENEVER POSSIBLE.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX MATRIX TO BE BALANCED.
!
!     ON OUTPUT-
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE BALANCED MATRIX,
!
!        LOW AND IGH ARE TWO INTEGERS SUCH THAT AR(I,J) AND AI(I,J)
!          ARE EQUAL TO ZERO IF
!           (1) I IS GREATER THAN J AND
!           (2) J=1,...,LOW-1 OR I=IGH+1,...,N,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE
!           PERMUTATIONS AND SCALING FACTORS USED.
!
!     SUPPOSE THAT THE PRINCIPAL SUBMATRIX IN ROWS LOW THROUGH IGH
!     HAS BEEN BALANCED, THAT P(J) DENOTES THE INDEX INTERCHANGED
!     WITH J DURING THE PERMUTATION STEP, AND THAT THE ELEMENTS
!     OF THE DIAGONAL MATRIX USED ARE DENOTED BY D(I,J).  THEN
!        SCALE(J) = P(J),    FOR J = 1,...,LOW-1
!                 = D(J,J)       J = LOW,...,IGH
!                 = P(J)         J = IGH+1,...,N.
!     THE ORDER IN WHICH THE INTERCHANGES ARE MADE IS N TO IGH+1,
!     THEN 1 TO LOW-1.
!
!     NOTE THAT 1 IS RETURNED FOR IGH IF IGH IS ZERO FORMALLY.
!
!     THE ALGOL PROCEDURE EXC CONTAINED IN CBALANCE APPEARS IN
!     CBAL  IN LINE.  (NOTE THAT THE ALGOL ROLES OF IDENTIFIERS
!     K,L HAVE BEEN REVERSED.)
!
!-----------------------------------------------------------------------
!
!     ********** RADIX IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE BASE OF THE MACHINE FLOATING POINT REPRESENTATION.
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
!     ********** FOR J=L STEP -1 UNTIL 1 DO -- **********
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
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS K TO L **********
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
!     ********** GUARD AGAINST ZERO C OR R DUE TO UNDERFLOW **********
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
!     ********** LAST CARD OF CBAL **********
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
!     REAL SQRT,CABS,ABS
!     COMPLEX CMPLX
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF A COMPLEX ANALOGUE OF
!     THE ALGOL PROCEDURE ORTHES, NUM. MATH. 12, 349-368(1968)
!     BY MARTIN AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 339-358(1971).
!
!     GIVEN A COMPLEX GENERAL MATRIX, THIS SUBROUTINE
!     REDUCES A SUBMATRIX SITUATED IN ROWS AND COLUMNS
!     LOW THROUGH IGH TO UPPER HESSENBERG FORM BY
!     UNITARY SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  CBAL.  IF  CBAL  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX INPUT MATRIX.
!
!     ON OUTPUT-
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE HESSENBERG MATRIX.  INFORMATION
!          ABOUT THE UNITARY TRANSFORMATIONS USED IN THE REDUCTION
!          IS STORED IN THE REMAINING TRIANGLES UNDER THE
!          HESSENBERG MATRIX,
!
!        ORTR AND ORTI CONTAIN FURTHER INFORMATION ABOUT THE
!          TRANSFORMATIONS.  ONLY ELEMENTS LOW THROUGH IGH ARE USED.
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
!     ********** SCALE COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + abs(ar(i,m-1)) + abs(ai(i,m-1))
!
   if (scale .eq. 0.0) go to 180
   mp = m + igh
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H) * A **********
105 do j = m, n
      fr = 0.0
      fi = 0.0
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H)*A*(I-(U*UT)/H) **********
   do i = 1, igh
      fr = 0.0
      fi = 0.0
!     ********** FOR J=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** LAST CARD OF CORTH **********
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
!     INTEGER MIN0
!     REAL SQRT,CABS,ABS,REAL,AIMAG
!     COMPLEX CSQRT,CMPLX
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF A UNITARY ANALOGUE OF THE
!     ALGOL PROCEDURE  COMLR, NUM. MATH. 12, 369-376(1968) BY MARTIN
!     AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 396-403(1971).
!     THE UNITARY ANALOGUE SUBSTITUTES THE QR ALGORITHM OF FRANCIS
!     (COMP. JOUR. 4, 332-345(1962)) FOR THE LR ALGORITHM.
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES OF A COMPLEX
!     UPPER HESSENBERG MATRIX BY THE QR METHOD.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  CBAL.  IF  CBAL  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        HR AND HI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX UPPER HESSENBERG MATRIX.
!          THEIR LOWER TRIANGLES BELOW THE SUBDIAGONAL CONTAIN
!          INFORMATION ABOUT THE UNITARY TRANSFORMATIONS USED IN
!          THE REDUCTION BY  CORTH, IF PERFORMED.
!
!     ON OUTPUT-
!
!        THE UPPER HESSENBERG PORTIONS OF HR AND HI HAVE BEEN
!          DESTROYED.  THEREFORE, THEY MUST BE SAVED BEFORE
!          CALLING  COMQR  IF SUBSEQUENT CALCULATION OF
!          EIGENVECTORS IS TO BE PERFORMED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  IF AN ERROR
!          EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!     ARITHMETIC IS REAL EXCEPT FOR THE REPLACEMENT OF THE ALGOL
!     PROCEDURE CDIV BY COMPLEX DIVISION AND USE OF THE SUBROUTINES
!     CSQRT AND CMPLX IN COMPUTING COMPLEX SQUARE ROOTS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE RELATIVE PRECISION OF FLOATING POINT ARITHMETIC.
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
!     ********** STORE ROOTS ISOLATED BY CBAL **********
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
!                FOR L=EN STEP -1 UNTIL LOW  -- **********
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
!     ********** LAST CARD OF COMQR **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE
!     CBABK2, WHICH IS A COMPLEX VERSION OF BALBAK,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     THIS SUBROUTINE FORMS THE EIGENVECTORS OF A COMPLEX GENERAL
!     MATRIX BY BACK TRANSFORMING THOSE OF THE CORRESPONDING
!     BALANCED MATRIX DETERMINED BY  CBAL.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY  CBAL,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE PERMUTATIONS
!          AND SCALING FACTORS USED BY  CBAL,
!
!        M IS THE NUMBER OF EIGENVECTORS TO BE BACK TRANSFORMED,
!
!        ZR AND ZI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVECTORS TO BE
!          BACK TRANSFORMED IN THEIR FIRST M COLUMNS.
!
!     ON OUTPUT-
!
!        ZR AND ZI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE TRANSFORMED EIGENVECTORS
!          IN THEIR FIRST M COLUMNS.
!
!-----------------------------------------------------------------------
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                IF THE FOREGOING STATEMENT IS REPLACED BY
!                S=1.0/SCALE(I). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
!
end do
!     ********** FOR I=LOW-1 STEP -1 UNTIL 1,
!                IGH+1 STEP 1 UNTIL N DO -- **********
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
!     ********** LAST CARD OF CBABK2 **********
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
!     INTEGER MIN0
!     REAL SQRT,CABS,ABS,REAL,AIMAG
!     COMPLEX CSQRT,CMPLX
!-----------------------------------------------------------------------
!
!     THIS SUBROUTINE IS A TRANSLATION OF A UNITARY ANALOGUE OF THE
!     ALGOL PROCEDURE  COMLR2, NUM. MATH. 16, 181-204(1970) BY PETERS
!     AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!     THE UNITARY ANALOGUE SUBSTITUTES THE QR ALGORITHM OF FRANCIS
!     (COMP. JOUR. 4, 332-345(1962)) FOR THE LR ALGORITHM.
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS
!     OF A COMPLEX UPPER HESSENBERG MATRIX BY THE QR
!     METHOD.  THE EIGENVECTORS OF A COMPLEX GENERAL MATRIX
!     CAN ALSO BE FOUND IF  CORTH  HAS BEEN USED TO REDUCE
!     THIS GENERAL MATRIX TO HESSENBERG FORM.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  CBAL.  IF  CBAL  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        ORTR AND ORTI CONTAIN INFORMATION ABOUT THE UNITARY TRANS-
!          FORMATIONS USED IN THE REDUCTION BY  CORTH, IF PERFORMED.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.  IF THE EIGENVECTORS
!          OF THE HESSENBERG MATRIX ARE DESIRED, SET ORTR(J) AND
!          ORTI(J) TO 0.0 FOR THESE ELEMENTS,
!
!        HR AND HI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX UPPER HESSENBERG MATRIX.
!          THEIR LOWER TRIANGLES BELOW THE SUBDIAGONAL CONTAIN FURTHER
!          INFORMATION ABOUT THE TRANSFORMATIONS WHICH WERE USED IN THE
!          REDUCTION BY  CORTH, IF PERFORMED.  IF THE EIGENVECTORS OF
!          THE HESSENBERG MATRIX ARE DESIRED, THESE ELEMENTS MAY BE
!          ARBITRARY.
!
!     ON OUTPUT-
!
!        ORTR, ORTI, AND THE UPPER HESSENBERG PORTIONS OF HR AND HI
!          HAVE BEEN DESTROYED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  IF AN ERROR
!          EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        ZR AND ZI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVECTORS.  THE EIGENVECTORS
!          ARE UNNORMALIZED.  IF AN ERROR EXIT IS MADE, NONE OF
!          THE EIGENVECTORS HAS BEEN FOUND,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
!     ARITHMETIC IS REAL EXCEPT FOR THE REPLACEMENT OF THE ALGOL
!     PROCEDURE CDIV BY COMPLEX DIVISION AND USE OF THE SUBROUTINES
!     CSQRT AND CMPLX IN COMPUTING COMPLEX SQUARE ROOTS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE RELATIVE PRECISION OF FLOATING POINT ARITHMETIC.
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
!                FROM THE INFORMATION LEFT BY CORTH **********
iend = igh - low - 1
if (iend) 180, 150, 105
!     ********** FOR I=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
105 do 140 ii = 1, iend
   i = igh - ii
   if (ortr(i) .eq. 0.0 .and. orti(i) .eq. 0.0) go to 140
   if (hr(i,i-1) .eq. 0.0 .and. hi(i,i-1) .eq. 0.0) go to 140
!     ********** NORM BELOW IS NEGATIVE OF H FORMED IN CORTH **********
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
!     ********** STORE ROOTS ISOLATED BY CBAL **********
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
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
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
!     ********** FOR EN=N STEP -1 UNTIL 2 DO -- **********
do nn = 2, n
   en = n + 2 - nn
   xr = wr(en)
   xi = wi(en)
   enm1 = en - 1
!     ********** FOR I=EN-1 STEP -1 UNTIL 1 DO -- **********
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
!                VECTORS OF ORIGINAL FULL MATRIX.
!                FOR J=N STEP -1 UNTIL LOW+1 DO -- **********
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
!     ********** LAST CARD OF COMQR2 **********
end subroutine comqr2

subroutine dceig(ibal,ar,ai,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
integer :: igh, low
!-----------------------------------------------------------------------
!            EIGENVALUES OF DOUBLE PRECISION COMPLEX MATRICES
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
!                     EIGENVALUES AND EIGENVECTORS
!                 OF DOUBLE PRECISION COMPLEX MATRICES
!-----------------------------------------------------------------------
double precision, intent(inout) :: ar(ka,n), ai(ka,n), wr(n), &
&wi(n), zr(ka,n), zi(ka,n), temp(*)
!----------------------
!     TEMP IS A TEMPORARY STORAGE AREA
!        DIMENSION(TEMP) .GE. 2*N    IF IBAL .EQ. 0
!        DIMENSION(TEMP) .GE. 3*N    IF IBAL .NE. 0
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE
!     CBALANCE, WHICH IS A COMPLEX VERSION OF BALANCE,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     DCBAL BALANCES A DOUBLE PRECISION COMPLEX MATRIX AND
!     ISOLATES EIGENVALUES WHENEVER POSSIBLE.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX MATRIX TO BE BALANCED.
!
!     ON OUTPUT-
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE BALANCED MATRIX,
!
!        LOW AND IGH ARE TWO INTEGERS SUCH THAT AR(I,J) AND AI(I,J)
!          ARE EQUAL TO ZERO IF
!           (1) I IS GREATER THAN J AND
!           (2) J=1,...,LOW-1 OR I=IGH+1,...,N,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE
!           PERMUTATIONS AND SCALING FACTORS USED.
!
!     SUPPOSE THAT THE PRINCIPAL SUBMATRIX IN ROWS LOW THROUGH IGH
!     HAS BEEN BALANCED, THAT P(J) DENOTES THE INDEX INTERCHANGED
!     WITH J DURING THE PERMUTATION STEP, AND THAT THE ELEMENTS
!     OF THE DIAGONAL MATRIX USED ARE DENOTED BY D(I,J).  THEN
!        SCALE(J) = P(J),    FOR J = 1,...,LOW-1
!                 = D(J,J)       J = LOW,...,IGH
!                 = P(J)         J = IGH+1,...,N.
!     THE ORDER IN WHICH THE INTERCHANGES ARE MADE IS N TO IGH+1,
!     THEN 1 TO LOW-1.
!
!     NOTE THAT 1 IS RETURNED FOR IGH IF IGH IS ZERO FORMALLY.
!
!     THE ALGOL PROCEDURE EXC CONTAINED IN CBALANCE APPEARS IN
!     DCBAL IN LINE.  (NOTE THAT THE ALGOL ROLES OF IDENTIFIERS
!     K,L HAVE BEEN REVERSED.)
!
!-----------------------------------------------------------------------
!
!     ********** RADIX IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE BASE OF THE MACHINE FLOATING POINT REPRESENTATION.
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
!     ********** FOR J=L STEP -1 UNTIL 1 DO -- **********
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
!     ********** NOW BALANCE THE SUBMATRIX IN ROWS K TO L **********
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
!     ********** GUARD AGAINST ZERO C OR R DUE TO UNDERFLOW **********
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
!     ********** LAST CARD OF DCBAL **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF A COMPLEX ANALOGUE OF
!     THE ALGOL PROCEDURE ORTHES, NUM. MATH. 12, 349-368(1968)
!     BY MARTIN AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 339-358(1971).
!
!     GIVEN A DOUBLE PRECISION COMPLEX MATRIX, DCORTH
!     REDUCES A SUBMATRIX SITUATED IN ROWS AND COLUMNS
!     LOW THROUGH IGH TO UPPER HESSENBERG FORM BY
!     UNITARY SIMILARITY TRANSFORMATIONS.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DCBAL.  IF DCBAL HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX INPUT MATRIX.
!
!     ON OUTPUT-
!
!        AR AND AI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE HESSENBERG MATRIX.  INFORMATION
!          ABOUT THE UNITARY TRANSFORMATIONS USED IN THE REDUCTION
!          IS STORED IN THE REMAINING TRIANGLES UNDER THE
!          HESSENBERG MATRIX,
!
!        ORTR AND ORTI CONTAIN FURTHER INFORMATION ABOUT THE
!          TRANSFORMATIONS.  ONLY ELEMENTS LOW THROUGH IGH ARE USED.
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
!     ********** SCALE COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90 scale = scale + dabs(ar(i,m-1)) + dabs(ai(i,m-1))
!
   if (scale .eq. 0.d0) go to 180
   mp = m + igh
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H) * A **********
105 do j = m, n
      fr = 0.d0
      fi = 0.d0
!     ********** FOR I=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** FORM (I-(U*UT)/H)*A*(I-(U*UT)/H) **********
   do i = 1, igh
      fr = 0.d0
      fi = 0.d0
!     ********** FOR J=IGH STEP -1 UNTIL M DO -- **********
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
!     ********** LAST CARD OF DCORTH **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF A UNITARY ANALOGUE OF THE
!     ALGOL PROCEDURE  COMLR, NUM. MATH. 12, 369-376(1968) BY MARTIN
!     AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 396-403(1971).
!     THE UNITARY ANALOGUE SUBSTITUTES THE QR ALGORITHM OF FRANCIS
!     (COMP. JOUR. 4, 332-345(1962)) FOR THE LR ALGORITHM.
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES OF A DOUBLE PRECISION
!     COMPLEX UPPER HESSENBERG MATRIX BY THE QR METHOD.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DCBAL.  IF DCBAL HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        HR AND HI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX UPPER HESSENBERG MATRIX.
!          THEIR LOWER TRIANGLES BELOW THE SUBDIAGONAL CONTAIN
!          INFORMATION ABOUT THE UNITARY TRANSFORMATIONS USED IN
!          THE REDUCTION BY DCORTH, IF PERFORMED.
!
!     ON OUTPUT-
!
!        THE UPPER HESSENBERG PORTIONS OF HR AND HI HAVE BEEN
!          DESTROYED.  THEREFORE, THEY MUST BE SAVED BEFORE
!          CALLING DCOMQR IF SUBSEQUENT CALCULATION OF
!          EIGENVECTORS IS TO BE PERFORMED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  IF AN ERROR
!          EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 50 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE RELATIVE PRECISION OF FLOATING POINT ARITHMETIC.
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
!     ********** STORE ROOTS ISOLATED BY DCBAL **********
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
!                FOR L=EN STEP -1 UNTIL LOW  -- **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE
!     CBABK2, WHICH IS A COMPLEX VERSION OF BALBAK,
!     NUM. MATH. 13, 293-304(1969) BY PARLETT AND REINSCH.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 315-326(1971).
!
!     THIS SUBROUTINE FORMS THE EIGENVECTORS OF A DOUBLE PRECISION
!     COMPLEX MATRIX BY BACK TRANSFORMING THOSE OF THE CORRESPONDING
!     BALANCED MATRIX DETERMINED BY DCBAL.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY DCBAL,
!
!        SCALE CONTAINS INFORMATION DETERMINING THE PERMUTATIONS
!          AND SCALING FACTORS USED BY DCBAL,
!
!        M IS THE NUMBER OF EIGENVECTORS TO BE BACK TRANSFORMED,
!
!        ZR AND ZI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVECTORS TO BE
!          BACK TRANSFORMED IN THEIR FIRST M COLUMNS.
!
!     ON OUTPUT-
!
!        ZR AND ZI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE TRANSFORMED EIGENVECTORS
!          IN THEIR FIRST M COLUMNS.
!
!-----------------------------------------------------------------------
if (m .eq. 0) go to 200
if (igh .eq. low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** LEFT HAND EIGENVECTORS ARE BACK TRANSFORMED
!                IF THE FOREGOING STATEMENT IS REPLACED BY
!                S=1.0/SCALE(I). **********
   do j = 1, m
      zr(i,j) = zr(i,j) * s
      zi(i,j) = zi(i,j) * s
   end do
!
end do
!
!     ********** FOR I=LOW-1 STEP -1 UNTIL 1,
!                IGH+1 STEP 1 UNTIL N DO -- **********
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
!     ********** LAST CARD OF DCBABK **********
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
!     THIS SUBROUTINE IS A TRANSLATION OF A UNITARY ANALOGUE OF THE
!     ALGOL PROCEDURE  COMLR2, NUM. MATH. 16, 181-204(1970) BY PETERS
!     AND WILKINSON.
!     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
!     THE UNITARY ANALOGUE SUBSTITUTES THE QR ALGORITHM OF FRANCIS
!     (COMP. JOUR. 4, 332-345(1962)) FOR THE LR ALGORITHM.
!
!     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS OF
!     A DOUBLE PRECISION COMPLEX UPPER HESSENBERG MATRIX BY THE
!     QR METHOD.  THE EIGENVECTORS OF A COMPLEX GENERAL MATRIX
!     CAN ALSO BE FOUND IF DCORTH HAS BEEN USED TO REDUCE
!     THIS GENERAL MATRIX TO HESSENBERG FORM.
!
!     ON INPUT-
!
!        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
!          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
!          DIMENSION STATEMENT,
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DCBAL.  IF DCBAL HAS NOT BEEN USED,
!          SET LOW=1, IGH=N,
!
!        ORTR AND ORTI CONTAIN INFORMATION ABOUT THE UNITARY TRANS-
!          FORMATIONS USED IN THE REDUCTION BY DCORTH, IF PERFORMED.
!          ONLY ELEMENTS LOW THROUGH IGH ARE USED.  IF THE EIGENVECTORS
!          OF THE HESSENBERG MATRIX ARE DESIRED, SET ORTR(J) AND
!          ORTI(J) TO 0.0 FOR THESE ELEMENTS,
!
!        HR AND HI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE COMPLEX UPPER HESSENBERG MATRIX.
!          THEIR LOWER TRIANGLES BELOW THE SUBDIAGONAL CONTAIN FURTHER
!          INFORMATION ABOUT THE TRANSFORMATIONS WHICH WERE USED IN THE
!          REDUCTION BY DCORTH, IF PERFORMED.  IF THE EIGENVECTORS OF
!          THE HESSENBERG MATRIX ARE DESIRED, THESE ELEMENTS MAY BE
!          ARBITRARY.
!
!     ON OUTPUT-
!
!        ORTR, ORTI, AND THE UPPER HESSENBERG PORTIONS OF HR AND HI
!          HAVE BEEN DESTROYED,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  IF AN ERROR
!          EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N,
!
!        ZR AND ZI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVECTORS.  THE EIGENVECTORS
!          ARE UNNORMALIZED.  IF AN ERROR EXIT IS MADE, NONE OF
!          THE EIGENVECTORS HAS BEEN FOUND,
!
!        IERR IS SET TO
!          ZERO       FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 50 ITERATIONS.
!
!-----------------------------------------------------------------------
!
!     ********** MACHEP IS A MACHINE DEPENDENT PARAMETER SPECIFYING
!                THE RELATIVE PRECISION OF FLOATING POINT ARITHMETIC.
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
!                FROM THE INFORMATION LEFT BY DCORTH **********
iend = igh - low - 1
if (iend) 180, 150, 105
!     ********** FOR I=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
105 do 140 ii = 1, iend
   i = igh - ii
   if (ortr(i) .eq. 0.d0 .and. orti(i) .eq. 0.d0) go to 140
   if (hr(i,i-1) .eq. 0.d0 .and. hi(i,i-1) .eq. 0.d0) go to 140
!     ********** NORM BELOW IS NEGATIVE OF H FORMED IN DCORTH **********
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
!     ********** STORE ROOTS ISOLATED BY DCBAL **********
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
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
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
!     ********** FOR EN=N STEP -1 UNTIL 2 DO -- **********
do nn = 2, n
   en = n + 2 - nn
   xr = wr(en)
   xi = wi(en)
   enm1 = en - 1
!     ********** FOR I=EN-1 STEP -1 UNTIL 1 DO -- **********
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
!                VECTORS OF ORIGINAL FULL MATRIX.
!                FOR J=N STEP -1 UNTIL LOW+1 DO -- **********
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
!     ********** LAST CARD OF DCMQR2 **********
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
! THIS SUBROUTINE USES A MODIFICATION OF THE SIMPLEX
! METHOD OF LINEAR PROGRAMMING TO CALCULATE AN L1 SOLUTION
! TO A K BY N SYSTEM OF LINEAR EQUATIONS
!             AX=B
! SUBJECT TO L LINEAR EQUALITY CONSTRAINTS
!             CX=D
! AND M LINEAR INEQUALITY CONSTRAINTS
!             EX.LE.F.
! DESCRIPTION OF PARAMETERS
! K      NUMBER OF ROWS OF THE MATRIX A (K.GE.1).
! L      NUMBER OF ROWS OF THE MATRIX C (L.GE.0).
! M      NUMBER OF ROWS OF THE MATRIX E (M.GE.0).
! N      NUMBER OF COLUMNS OF THE MATRICES A,C,E (N.GE.1).
! KLMD   SET TO AT LEAST K+L+M FOR ADJUSTABLE DIMENSIONS.
! KLM2D  SET TO AT LEAST K+L+M+2 FOR ADJUSTABLE DIMENSIONS.
! NKLMD  SET TO AT LEAST N+K+L+M FOR ADJUSTABLE DIMENSIONS.
! N2D    SET TO AT LEAST N+2 FOR ADJUSTABLE DIMENSIONS
! Q      TWO DIMENSIONAL REAL ARRAY WITH KLM2D ROWS AND
!        AT LEAST N2D COLUMNS.
!        ON ENTRY THE MATRICES A,C AND E, AND THE VECTORS
!        B,D AND F MUST BE STORED IN THE FIRST K+L+M ROWS
!        AND N+1 COLUMNS OF Q AS FOLLOWS
!             A B
!         Q = C D
!             E F
!        THESE VALUES ARE DESTROYED BY THE SUBROUTINE.
! KODE   A CODE USED ON ENTRY TO, AND EXIT
!        FROM, THE SUBROUTINE.
!        ON ENTRY, THIS SHOULD NORMALLY BE SET TO 0.
!        HOWEVER, IF CERTAIN NONNEGATIVITY CONSTRAINTS
!        ARE TO BE INCLUDED IMPLICITLY, RATHER THAN
!        EXPLICITLY IN THE CONSTRAINTS EX.LE.F, THEN KODE
!        SHOULD BE SET TO 1, AND THE NONNEGATIVITY
!        CONSTRAINTS INCLUDED IN THE ARRAYS X AND
!        RES (SEE BELOW).
!        ON EXIT, KODE HAS ONE OF THE
!        FOLLOWING VALUES
!             0- OPTIMAL SOLUTION FOUND,
!             1- NO FEASIBLE SOLUTION TO THE
!                CONSTRAINTS,
!             2- CALCULATIONS TERMINATED
!                PREMATURELY DUE TO ROUNDING ERRORS,
!             3- MAXIMUM NUMBER OF ITERATIONS REACHED.
! TOLER  A SMALL POSITIVE TOLERANCE. EMPIRICAL
!        EVIDENCE SUGGESTS TOLER = 10**(-D*2/3),
!        WHERE D REPRESENTS THE NUMBER OF DECIMAL
!        DIGITS OF ACCURACY AVAILABLE. ESSENTIALLY,
!        THE SUBROUTINE CANNOT DISTINGUISH BETWEEN ZERO
!        AND ANY QUANTITY WHOSE MAGNITUDE DOES NOT EXCEED
!        TOLER. IN PARTICULAR, IT WILL NOT PIVOT ON ANY
!        NUMBER WHOSE MAGNITUDE DOES NOT EXCEED TOLER.
! ITER   ON ENTRY ITER MUST CONTAIN AN UPPER BOUND ON
!        THE MAXIMUM NUMBER OF ITERATIONS ALLOWED.
!        A SUGGESTED VALUE IS 10*(K+L+M). ON EXIT ITER
!        GIVES THE NUMBER OF SIMPLEX ITERATIONS.
! X      ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST N2D.
!        ON EXIT THIS ARRAY CONTAINS A
!        SOLUTION TO THE L1 PROBLEM. IF KODE=1
!        ON ENTRY, THIS ARRAY IS ALSO USED TO INCLUDE
!        SIMPLE NONNEGATIVITY CONSTRAINTS ON THE
!        VARIABLES. THE VALUES -1, 0, OR 1
!        FOR X(J) INDICATE THAT THE J-TH VARIABLE
!        IS RESTRICTED TO BE .LE.0, UNRESTRICTED,
!        OR .GE.0 RESPECTIVELY.
! RES    ONE DIMENSIONAL REAL ARRAY OF SIZE AT LEAST KLMD.
!        ON EXIT THIS CONTAINS THE RESIDUALS B-AX
!        IN THE FIRST K COMPONENTS, D-CX IN THE
!        NEXT L COMPONENTS (THESE WILL BE =0),AND
!        F-EX IN THE NEXT M COMPONENTS. IF KODE=1 ON
!        ENTRY, THIS ARRAY IS ALSO USED TO INCLUDE SIMPLE
!        NONNEGATIVITY CONSTRAINTS ON THE RESIDUALS
!        B-AX. THE VALUES -1, 0, OR 1 FOR RES(I)
!        INDICATE THAT THE I-TH RESIDUAL (1.LE.I.LE.K) IS
!        RESTRICTED TO BE .LE.0, UNRESTRICTED, OR .GE.0
!        RESPECTIVELY.
! ERROR  ON EXIT, THIS GIVES THE MINIMUM SUM OF
!        ABSOLUTE VALUES OF THE RESIDUALS.
! CU     A TWO DIMENSIONAL REAL ARRAY WITH TWO ROWS AND
!        AT LEAST NKLMD COLUMNS USED FOR WORKSPACE.
! IU     A TWO DIMENSIONAL INTEGER ARRAY WITH TWO ROWS AND
!        AT LEAST NKLMD COLUMNS USED FOR WORKSPACE.
! S      INTEGER ARRAY OF SIZE AT LEAST KLMD, USED FOR
!        WORKSPACE.
! IF YOUR FORTRAN COMPILER PERMITS A SINGLE COLUMN OF A TWO
! DIMENSIONAL ARRAY TO BE PASSED TO A ONE DIMENSIONAL ARRAY
! THROUGH A SUBROUTINE CALL, CONSIDERABLE SAVINGS IN
! EXECUTION TIME MAY BE ACHIEVED THROUGH THE USE OF THE
! FOLLOWING SUBROUTINE, WHICH OPERATES ON COLUMN VECTORS.
!     SUBROUTINE COL(V1, V2, XMLT, NOTROW, K)
! THIS SUBROUTINE ADDS TO THE VECTOR V1 A MULTIPLE OF THE
! VECTOR V2 (ELEMENTS 1 THROUGH K EXCLUDING NOTROW).
!     DIMENSION V1(K), V2(K)
!     KEND = NOTROW - 1
!     KSTART = NOTROW + 1
!     IF (KEND .LT. 1) GO TO 20
!     DO 10 I=1,KEND
!        V1(I) = V1(I) + XMLT*V2(I)
!  10 CONTINUE
!     IF(KSTART .GT. K) GO TO 40
!  20 DO 30 I=KSTART,K
!       V1(I) = V1(I) + XMLT*V2(I)
!  30 CONTINUE
!  40 RETURN
!     END
! SEE COMMENTS FOLLOWING STATEMENT LABELLED 440 FOR
! INSTRUCTIONS ON THE IMPLEMENTATION OF THIS MODIFICATION.
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
! INITIALIZATION.
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
! SET UP LABELS IN Q.
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
! SET UP PHASE 1 COSTS.
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
! COMPUTE THE MARGINAL COSTS.
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
! DETERMINE THE VECTOR TO ENTER THE BASIS.
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
! DETERMINE THE VECTOR TO LEAVE THE BASIS.
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
! BYPASS INTERMEDIATE VERTICES.
do j=js,n1
   z = q(iout,j)
   q(klm1,j) = q(klm1,j) - z*cuv
   q(iout,j) = -z
end do
q(iout,n2) = -q(iout,n2)
go to 350
! GAUSS-JORDAN ELIMINATION.
420 if (iter.lt.maxit) go to 430
kode = 3
go to 590
430 iter = iter + 1
do j=js,n1
   if (j.ne.in) q(iout,j) = q(iout,j)/pivot
end do
! IF PERMITTED, USE SUBROUTINE COL OF THE DESCRIPTION
! SECTION AND REPLACE THE FOLLOWING SEVEN STATEMENTS DOWN
! TO AND INCLUDING STATEMENT NUMBER 460 BY..
!     DO 460 J=JS,N1
!        IF(J .EQ. IN) GO TO 460
!        Z = -Q(IOUT,J)
!        CALL COL(Q(1,J), Q(1,IN), Z, IOUT, KLM1)
! 460 CONTINUE
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
! TEST FOR OPTIMALITY.
490 if (kforce.eq.0) go to 580
if (iphase.eq.1 .and. q(klm1,n1).le.toler) go to 500
kforce = 0
go to 240
! SET UP PHASE 2 COSTS.
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
! PREPARE OUTPUT.
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
!     DIMENSION WK(MN + 2M + N)
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
!      IDENTIFICATION
!        ORTHO - ORTHOGONAL TRANSFORMATION OF A GIVEN GENERAL M BY N
!                MATRIX A TO UPPER TRIANGULAR FORM
!        FORTRAN SUBROUTINE SUBPROGRAM
!        AEROSPACE RESEARCH LABORATORIES
!        WRIGHT-PATTERSON AFB, OHIO  45433
!      PURPOSE
!        ORTHO COMPUTES AN IMPLICIT ORTHOGONAL MATRIX Q AND AN EXPLICIT
!        UPPER TRIANGULAR MATRIX R AND A PERMUTATION MATRIX P SATISFYING
!        QR = PA GIVEN AN M BY N REAL MATRIX A.  ORTHO IS INTENDED FOR
!        USE WITH THE SUBROUTINE ORSOL TO PRODUCE THE LEAST SQUARES
!        SOLUTION OF THE EQUATION AX = B.
!      CONTROL
!
!        DIMENSION QR(MS,N), S(N), IP(N)
!        LOGICAL EXIT
!        .
!        .
!        .
!        CALL ORTHO(M, N, QR, MS, S, IP, EXIT)
!
!        WHERE
!        M    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        N    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. N .LE. M).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             QR(I,J), I .LE. J, AND THE RELEVANT PARTS OF Q IN QR(I,J),
!             I .GT. J.
!        MS   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR IN THE CALLING PROGRAM.
!        S    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        IP   IS AN INTEGER OUTPUT ARRAY CONTAINING IN IP(I), I=1,...,N,
!             THE IMAGES OF THE PERMUTATION CORRESPONDING TO THE PERMU-
!             TATION MATRIX P.
!        EXIT IS SET TO THE VALUE .TRUE. IF THE RANK OF A IS EQUAL TO N
!             AND .FALSE. OTHERWISE.
!      METHOD
!        THE MATRIX A IN THE ARRAY QR IS REDUCED TO UPPER TRIANGULAR
!        FORM USING ORTHOGONAL TRANSFORMATION WITH PARTIAL PIVOTING.
!      REFERENCES
!        (1) PETER BUSINGER AND G.H. GOLUB, LINEAR LEAST SQUARES SOLU-
!            TIONS BY HOUSEHOLDER TRANSFORMATIONS, NUMER. MATH. 7(1965),
!            269-276.
!        (2) N.K. TSAO AND P.J. NIKOLAI, PROCEDURES USING ORTHOGONAL
!            TRANSFORMATIONS FOR LINEAR LEAST SQUARES PROBLEMS, ARL
!            TECHNICAL REPORT ARL TR 74-0124(1974).
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
!                                       SEARCH FOR PIVOT IN THE J-TH
!                                       COLUMN AND INTERCHANGE ROWS.
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
!                                       NORMALIZE THE PIVOTING COLUMN
!                                       AND FIND ITS NORM.
30 ajj = qr(j,j)
  do 31 i = jp, m
31 qr(i,j) = qr(i,j)/ajj
  sav = 1.0
  do 40 i = jp, m
40 sav = sav + qr(i,j)*qr(i,j)
  s(j) = -sqrt(sav)
  qr(j,j) = s(j)*ajj
  if (jp .gt. n) go to 80
!                                       PREMULTIPLY QR WITH THE J-TH
!                                       ORTHOGONAL MATRIX.
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
!      IDENTIFICATION
!        ORSOL - LEAST SQUARES SOLUTION OF A LINEAR SYSTEM GIVEN AN
!                ORTHOGONAL-TRIANGULAR FACTORIZATION OF THE COEFFICIENT
!                MATRIX PRODUCED BY SUBROUTINE ORTHO
!        FORTRAN SUBROUTINE SUBPROGRAM
!        AEROSPACE RESEARCH LABORATORIES
!        WRIGHT-PATTERSON AFB, OHIO  45433
!      PURPOSE
!        ORSOL COMPUTES THE LEAST SQUARES SOLUTION OF THE LINEAR SYSTEM
!        QRX = PAX = B WHERE Q, R, AND P ARE DETERMINED FROM A BY ORTHO.
!      CONTROL
!
!        DIMENSION QR(MS,N), S(N), IP(N), X(M)
!        .
!        .
!        .
!        CALL ORSOL(M, N, QR, MS, S, IP, X)
!
!        WHERE
!        M  IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        N  IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A
!             (1 .LT. N .LE. M).
!        QR IS A REAL INPUT ARRAY, THE ORTHOGONAL AND TRIANGULAR FACTORS
!           OF A PRODUCED BY ORTHO.
!        MS IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!           QR IN THE CALLING PROGRAM.
!        S  IS A REAL INPUT ARRAY, THE RELEVANT PARTS OF Q PRODUCED BY
!           ORTHO.
!        IP IS AN INTEGER INPUT ARRAY, THE PERMUTATION INFORMATION
!           PRODUCED BY ORTHO.
!        X  AS A REAL INPUT ARRAY IS THE RIGHT-HAND SIDE B OF AX = B.
!        X  AS A REAL OUTPUT ARRAY IS X(I), I = 1, ..., N, THE LEAST
!           SQUARES SOLUTION, AND X(J), J = N+1, ..., M, THE VECTOR
!           WHOSE LENGTH IS THE MINIMUM OF ALL RESIDUAL B - AX.
!      METHOD
!        THE FACTORED SYSTEM QRX = PAX = PB ARE SOLVED IN THE SEQUENCE
!        OF QY = PB AND RX = Y. FULL RANK FOR THE MATRIX A IS ASSUMED
!        WHICH CAN BE CHECKED BY INTERROGATING THE LOGICAL OUTPUT
!        VARIABLE PRODUCED BY ORTHO.
!      REFERENCES
!        (1) PETER BUSINGER AND G.H. GOLUB, LINEAR LEAST SQUARES SOLU-
!            TIONS BY HOUSEHOLDER TRANSFORMATIONS, NUMER. MATH. 7(1965),
!            269-276.
!        (2) N.K. TSAO AND P.J. NIKOLAI, PROCEDURES USING ORTHOGONAL
!            TRANSFORMATIONS FOR LINEAR LEAST SQUARES PROBLEMS, ARL
!            TECHNICAL REPORT ARL TR 74-0124(1974).
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
!                                       PREMULTIPLY X WITH THE J-TH
!                                       ORTHOGONAL MATRIX.
  sav = x(j)
  do 10 k = jp, m
10 sav = sav + qr(k,j)*x(k)
  ss = x(j)
  x(j) = sav/s(j)
  ss = (ss - x(j))/y
  do 20 k = jp, m
20 x(k) = x(k) - qr(k,j)*ss
end do
!                                       BACK SUBSTITUTE TO FIND THE
!                                       LEAST SQUARES SOLUTION.
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
!      PURPOSE
!        GIVEN AN APPROXIMATE LEAST SQUARES SOLUTION X OF A LINEAR
!        SYSTEM AX = B OBTAINED USING ORSOL. ORIMP ATTEMPTS TO COMPUTE
!        AN IMPROVED SOLUTION CORRECT TO MACHINE PRECISION.
!
!      CONTROL
!
!        DIMENSION A(KA,N), QR(MS,N), B(M), X(M), R(M), S(N), IP(N)
!        LOGICAL EXIT
!        .
!        .
!        .
!        CALL ORIMP(M, N, A, KA, QR, MS, S, IP, B, X, R, EXIT)
!
!        WHERE
!        M    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        N    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A
!             (1 .LT. N .LE. M).
!        A    IS A REAL INPUT ARRAY, THE GIVEN M BY N MATRIX.
!        QR   IS A REAL INPUT ARRAY, THE ORTHOGONAL AND TRIANGULAR
!             FACTORS OF A PRODUCED BY ORTHO.
!        B    IS A REAL INPUT ARRAY, THE RIGHT HAND SIDE OF AX = B.
!        X    AS A REAL INPUT ARRAY IS THE APPROXIMATE LEAST SQUARES
!             SOLUTION TOGETHER WITH THE RESIDUAL INFORMATION PRODUCED
!             BY ORSOL.
!        X    AS A REAL OUTPUT ARRAY IS THE IMPROVED LEAST SQUARES
!             SOLUTION WITH A RESIDUAL OF MINIMUM LENGTH.
!        R    IS A REAL OUTPUT ARRAY, THE CORRECTION VECTOR ADDED TO X.
!        KA   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             OF A IN THE CALLING PROGRAM.
!        MS   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             OF QR IN THE CALLING PROGRAM.
!        S    IS A REAL INPUT ARRAY, A RELEVANT PART OF Q PRODUCED BY
!             ORTHO.
!        IP   IS AN INTEGER INPUT ARRAY, THE PERMUTATION INFORMATION
!             PRODUCED BY ORTHO.
!        EXIT IS SET TO THE VALUE .TRUE. IF IMPROVEMENT OF X IS SUCCESS-
!             FUL WITH A GAIN IN ACCURACY OF AT LEAST 50 PER CENT EACH
!             ITERATION AND .FALSE. OTHERWISE.
!
!      METHOD
!        ORIMP EXECUTES THE ITERATION CYCLE
!              (1)  AR = B - AX
!              (2)  X = X + R
!        WITH A GIVEN INITIAL X.  THE RESIDUAL VECTOR B - AX IS COMPUTED
!        TO HIGH ACCURACY BY DOUBLE PRECISION.  ORSOL IS THEN USED TO
!        SOLVE (1).
!
! ----------------------------------------------------------------------
!
dimension ip(n)
logical, intent(out) :: exit
double precision :: dsum
data zero/0.0/, one/1.0/, four/4.0/, fourth/0.25/
!
!     ********** EPS IS A MACHINE DEPENDENT PARAMETER. ASSIGN EPS
!                THE VALUE U WHERE U IS THE SMALLEST POSITIVE FLOATING
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
!                                       FIND THE RESIDUAL VECTOR.
!
20 do 22 k = 1,m
dsum = b(k)
do 21 j = 1,n
21 dsum = dsum - dble(a(k,j))*dble(x(j))
22 r(k) = dsum
!
!                                       FIND THE CORRECTION VECTOR.
!
call orsol(m, n, qr, ms, s, ip, r)
rnrm2 = zero
do 30 k = 1,n
30 rnrm2 = rnrm2 + r(k)*r(k)
if (rnrm2 .le. eps2*xnrm2) return
!
!                                       FORM NEW APPROXIMATE SOLUTION.
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
!      IDENTIFICATION
!        DORTHO - ORTHOGONAL TRANSFORMATION OF A GIVEN GENERAL M BY N
!                MATRIX A TO UPPER TRIANGULAR FORM
!        FORTRAN SUBROUTINE SUBPROGRAM
!        AEROSPACE RESEARCH LABORATORIES
!        WRIGHT-PATTERSON AFB, OHIO  45433
!      PURPOSE
!        DORTHO COMPUTES AN IMPLICIT ORTHOGONAL MATRIX Q AND AN EXPLICIT
!        UPPER TRIANGULAR MATRIX R AND A PERMUTATION MATRIX P SATISFYING
!        QR = PA GIVEN AN M BY N REAL MATRIX A.  DORTHO IS INTENDED FOR
!        USE WITH THE SUBROUTINE DORSOL TO PRODUCE THE LEAST SQUARES
!        SOLUTION OF THE EQUATION AX = B.
!      CONTROL
!
!        DIMENSION QR(MS,N), S(N), IP(N)
!        LOGICAL EXIT
!        .
!        .
!        .
!        CALL DORTHO(M, N, QR, MS, S, IP, EXIT)
!
!        WHERE
!        M    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        N    IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A,
!             (1 .LT. N .LE. M).
!        QR   AS A REAL INPUT ARRAY IS MATRIX A TO BE TRIANGULARIZED.
!        QR   AS A REAL OUTPUT ARRAY IS THE UPPER TRIANGULAR FACTOR R IN
!             QR(I,J), I .LE. J, AND THE RELEVANT PARTS OF Q IN QR(I,J),
!             I .GT. J.
!        MS   IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!             QR IN THE CALLING PROGRAM.
!        S    IS A REAL OUTPUT ARRAY, THE RELEVANT PARTS OF Q.
!        IP   IS AN INTEGER OUTPUT ARRAY CONTAINING IN IP(I), I=1,...,N,
!             THE IMAGES OF THE PERMUTATION CORRESPONDING TO THE PERMU-
!             TATION MATRIX P.
!        EXIT IS SET TO THE VALUE .TRUE. IF THE RANK OF A IS EQUAL TO N
!             AND .FALSE. OTHERWISE.
!      METHOD
!        THE MATRIX A IN THE ARRAY QR IS REDUCED TO UPPER TRIANGULAR
!        FORM USING ORTHOGONAL TRANSFORMATION WITH PARTIAL PIVOTING.
!      REFERENCES
!        (1) PETER BUSINGER AND G.H. GOLUB, LINEAR LEAST SQUARES SOLU-
!            TIONS BY HOUSEHOLDER TRANSFORMATIONS, NUMER. MATH. 7(1965),
!            269-276.
!        (2) N.K. TSAO AND P.J. NIKOLAI, PROCEDURES USING ORTHOGONAL
!            TRANSFORMATIONS FOR LINEAR LEAST SQUARES PROBLEMS, ARL
!            TECHNICAL REPORT ARL TR 74-0124(1974).
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
!                                       SEARCH FOR PIVOT IN THE J-TH
!                                       COLUMN AND INTERCHANGE ROWS.
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
!                                       NORMALIZE THE PIVOTING COLUMN
!                                       AND FIND ITS NORM.
30 ajj = qr(j,j)
  do 31 i = jp, m
31 qr(i,j) = qr(i,j)/ajj
  sav = 1.d0
  do 40 i = jp, m
40 sav = sav + qr(i,j)*qr(i,j)
  s(j) = -dsqrt(sav)
  qr(j,j) = s(j)*ajj
  if (jp .gt. n) go to 80
!                                       PREMULTIPLY QR WITH THE J-TH
!                                       ORTHOGONAL MATRIX.
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
!      IDENTIFICATION
!        DORSOL - LEAST SQUARES SOLUTION OF A LINEAR SYSTEM GIVEN AN
!                ORTHOGONAL-TRIANGULAR FACTORIZATION OF THE COEFFICIENT
!                MATRIX PRODUCED BY SUBROUTINE DORTHO
!        FORTRAN SUBROUTINE SUBPROGRAM
!        AEROSPACE RESEARCH LABORATORIES
!        WRIGHT-PATTERSON AFB, OHIO  45433
!      PURPOSE
!        DORSOL COMPUTES THE LEAST SQUARES SOLUTION OF THE LINEAR SYSTEM
!        QRX = PAX = B WHERE Q, R, AND P ARE DETERMINED FROM A BY DORTHO
!      CONTROL
!
!        DIMENSION QR(MS,N), S(N), IP(N), X(M)
!        .
!        .
!        .
!        CALL DORSOL(M, N, QR, MS, S, IP, X)
!
!        WHERE
!        M  IS AN INTEGER INPUT VARIABLE, THE NUMBER OF ROWS OF A.
!        N  IS AN INTEGER INPUT VARIABLE, THE NUMBER OF COLUMNS OF A
!             (1 .LT. N .LE. M).
!        QR IS A REAL INPUT ARRAY, THE ORTHOGONAL AND TRIANGULAR FACTORS
!           OF A PRODUCED BY DORTHO.
!        MS IS AN INTEGER INPUT VARIABLE, THE LEADING DIMENSION OF
!           QR IN THE CALLING PROGRAM.
!        S  IS A REAL INPUT ARRAY, THE RELEVANT PARTS OF Q PRODUCED BY
!           DORTHO.
!        IP IS AN INTEGER INPUT ARRAY, THE PERMUTATION INFORMATION
!           PRODUCED BY DORTHO.
!        X  AS A REAL INPUT ARRAY IS THE RIGHT-HAND SIDE B OF AX = B.
!        X  AS A REAL OUTPUT ARRAY IS X(I), I = 1, ..., N, THE LEAST
!           SQUARES SOLUTION, AND X(J), J = N+1, ..., M, THE VECTOR
!           WHOSE LENGTH IS THE MINIMUM OF ALL RESIDUAL B - AX.
!      METHOD
!        THE FACTORED SYSTEM QRX = PAX = PB ARE SOLVED IN THE SEQUENCE
!        OF QY = PB AND RX = Y. FULL RANK FOR THE MATRIX A IS ASSUMED
!        WHICH CAN BE CHECKED BY INTERROGATING THE LOGICAL OUTPUT
!        VARIABLE PRODUCED BY DORTHO.
!      REFERENCES
!        (1) PETER BUSINGER AND G.H. GOLUB, LINEAR LEAST SQUARES SOLU-
!            TIONS BY HOUSEHOLDER TRANSFORMATIONS, NUMER. MATH. 7(1965),
!            269-276.
!        (2) N.K. TSAO AND P.J. NIKOLAI, PROCEDURES USING ORTHOGONAL
!            TRANSFORMATIONS FOR LINEAR LEAST SQUARES PROBLEMS, ARL
!            TECHNICAL REPORT ARL TR 74-0124(1974).
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
!                                       PREMULTIPLY X WITH THE J-TH
!                                       ORTHOGONAL MATRIX.
  sav = x(j)
  do 10 k = jp, m
10 sav = sav + qr(k,j)*x(k)
  ss = x(j)
  x(j) = sav/s(j)
  ss = (ss - x(j))/y
  do 20 k = jp, m
20 x(k) = x(k) - qr(k,j)*ss
end do
!                                       BACK SUBSTITUTE TO FIND THE
!                                       LEAST SQUARES SOLUTION.
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
!              LEAST SQUARES SOLUTION OF LINEAR EQUATIONS
!
!                            --------------
!
!     LSQR SOLVES BOTH UNDERDETERMINED AND OVERDETERMINED LINEAR
!     SYSTEMS AX = B, WHERE A IS AN M BY N MATRIX AND B IS AN M BY
!     NB MATRIX OF RIGHT HAND SIDES. IF M .GE. N, THE LEAST SQUARES
!     SOLUTION IS COMPUTED BY DECOMPOSING THE MATRIX A INTO THE
!     PRODUCT OF AN ORTHOGONAL MATRIX Q AND UPPER TRIANGULAR MATRIX
!     R (QR FACTORIZATION). IF M .LT. N, THE MINIMAL LENGTH SOLUTION
!     IS COMPUTED BY FACTORING THE MATRIX A INTO THE PRODUCT OF A
!     LOWER TRIANGULAR MATRIX L AND ORTHOGONAL MATRIX Q (LQ FACTOR-
!     IZATION). IF THE MATRIX A IS DETERMINED TO BE RANK DEFICIENT,
!     THEN THE MINIMAL LENGTH LEAST SQUARES SOLUTION IS COMPUTED.
!
!     USER INPUT BOUNDS ON THE UNCERTAINTY OF THE ELEMENTS OF A ARE
!     USED TO DETECT NUMERICAL RANK DEFICIENCY. THE ALGORITHM USES
!     A ROW AND COLUMN PIVOT STRATEGY TO MINIMIZE THE GROWTH OF
!     UNCERTAINTY AND ROUND-OFF ERRORS.
!
!   ******************************************************************
!   *                                                                *
!   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!   *                                                                *
!   ******************************************************************
!
!     INPUT..
!
!     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!                   CALLED FOR THE FIRST TIME.
!                      IND = 0      ORIGINAL CALL
!                      IND .NE. 0   SUBSEQUENT CALLS
!                   ON SUBSEQUENT CALLS A NEW SET B OF EQUATIONS CAN
!                   BE SOLVED (USING THE SAME COEFFICIENT MATRIX A).
!                   IT IS ASSUMED THAT A, MDA, M, N, KRANK, IWORK,
!                   LIW, AND THE FIRST 2*MIN(M,N) LOCATIONS OF WORK
!                   HAVE NOT BEEN MODIFIED BY THE USER. RE, AE, AND
!                   KSURE ARE NOT USED.
!
!     A(,)          LINEAR COEFFICIENT MATRIX OF AX=B, WITH MDA THE
!      MDA,M,N      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!                   M IS THE ROW DIMENSION (NO. OF EQUATIONS OF THE
!                   PROBLEM) AND N THE COL DIMENSION (NO. OF UNKNOWNS).
!                   MUST HAVE MDA .GE. M.
!
!     B(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!      MDB,NB       DIMENSION OF B IN THE CALLING PROGRAM. NB IS THE
!                   NUMBER OF M BY 1 RIGHT HAND SIDES. MUST HAVE
!                   MDB .GE. MAX(M,N). IF NB .LE. 0 THEN B AND MDB
!                   ARE IGNORED.
!
!     RE            RE IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX A (0 .LE. RE .LT. 1).
!
!     AE            AE IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX A (AE .GE. 0).
!
!     WORK()        A REAL WORK ARRAY DIMENSIONED 5*MIN(M,N).
!
!     LW            ACTUAL DIMENSION OF WORK
!
!     IWORK()       INTEGER WORK ARRAY DIMENSIONED AT LEAST N+M.
!
!     LIW           ACTUAL DIMENSION OF IWORK.
!
!     OUTPUT..
!
!     A(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!                   AND THE TRANSFORMATION INFORMATION. A AND THE FIRST
!                   2*MIN(M,N) ELEMENTS OF WORK (SEE BELOW) COMPLETELY
!                   SPECIFY THE FACTORIZATION OF THE MATRIX A.
!
!     B(,)          CONTAINS THE N BY NB SOLUTION MATRIX FOR X.
!
!     KRANK,KSURE   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!                   AND ABSOLUTE BOUNDS ON UNCERTAINTY, IS BOUNDED
!                   ABOVE BY KRANK AND BELOW BY KSURE. THE ALGORITHM
!                   RETURNS A SOLUTION BASED ON KRANK. KSURE PROVIDES
!                   AN INDICATION OF THE PRECISION OF THE RANK.
!
!     RNORM()       CONTAINS THE EUCLIDEAN LENGTH OF THE NB RESIDUAL
!                   VECTORS  B(I) - AX(I), I=1,...,NB.
!
!     WORK()        THE FIRST 2*MIN(M,N) LOCATIONS OF WORK CONTAIN
!                   THE VALUES NECESSARY TO REPRODUCE THE HOUSEHOLDER
!                   FACTORIZATION OF A.
!
!     IWORK()       AN ARRAY OF LENGTH M + N CONTAINING THE ORDERS IN
!                   WHICH THE ROWS AND COLUMNS WERE USED. IF M .GE. N
!                   THEN THE FIRST N LOCATIONS CONTAIN THE ORDER OF
!                   THE COLUMNS AND THE NEXT M LOCATIONS THE ORDER OF
!                   THE ROWS. IF M .LT. N THEN THE ORDER OF THE ROWS
!                   PRECEDES THE ORDER OF THE COLUMNS.
!
!     IERR          FLAG TO INDICATE THE STATUS OF THE RESULTS
!                     0     - SATISFACTORY COMPLETION
!                   .GT. 0  - INPUT ERROR
!
!----------------
!     THE SUBROUTINES U11LS, U12LS, U11US, AND U12US WERE WRITTEN BY
!     T. MANTEUFFEL (LANL) IN 1981. THE DRIVER ROUTINE LSQR WAS WRITTEN
!     BY A.H. MORRIS (NSWC) IN 1991.
!----------------
!     REFERENCE.  MANTEUFFEL, T., AN INTERVAL ANALYSIS APPROACH TO RANK
!                 DETERMINATION IN LINEAR LEAST SQUARES PROBLEMS,
!                 SANDIA LABORATORIES REPORT SAND80-0655, JUNE, 1980.
!-----------------------------------------------------------------------
real, intent(inout) :: a(mda,n), b(mdb,*), rnorm(*), work(lw)
integer, intent(inout) :: iwork(liw)
!----------------
!     NP            IF M .GE. N THEN THE FIRST NP COLUMNS OF A
!                   ARE NEVER INTERCHANGED.
!                   IF M .LT. N THEN THE FIRST NP ROWS OF A ARE
!                   NEVER INTERCHANGED. NP IS NOT REFERENCED ON
!                   A CONTINUATION CALL TO THE ROUTINE.
!
!     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!                   IS TO REACT IF RANK DEFICIENCY IS DETECTED.
!                   IF MODE = 0 RETURN IMMEDIATELY, NO SOLUTION
!                             1 COMPUTE TRUNCATED SOLUTION
!                             2 COMPUTE MINIMAL LENGTH SOLUTION
!                   MODE MUST NOT BE MODIFIED ON A CONTINUATION
!                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!                   FIRST N LOCATIONS OF WORK ARE USED.
!----------------
np = 0
mode = 2
!
!     CHECK THE INPUT
!
if (nb .le. 0 .and. ind .ne. 0) go to 200
if (m .lt. 1 .or. n .lt. 1) go to 210
if (mda .lt. m) go to 220
if (liw .lt. m + n) go to 240
!
m0 = min0(m,n)
n0 = max0(m,n)
!     NUM = 0
!
if (nb .le. 0) go to 10
if (mdb .lt. n0) go to 230
if (ind .ne. 0) go to 100
!
10 if (lw .lt. 5*m0) go to 250
if (re .lt. 0.0 .or. ae .lt. 0.0) go to 260
!
!     DEFINE THE RELATIVE AND ABSOLUTE TOLERANCE LISTS
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
!     FACTOR THE MATRIX A
!
!     NUM = NP
if (m .lt. n) go to 40
!
   call u11ls (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
   go to 100
!
40 call u11us (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
!
!     SOLUTION PHASE
!
100 ierr = 0
info = 0
if (krank .eq. m0) go to 110
if (krank .eq. 0) go to 110
!     IF (KRANK .LT. NUM) GO TO 280
!     IF (MODE .EQ. 0) RETURN
info = mode
!
110 if (nb .le. 0) return
!
m1 = 1
m2 = 1 + m0
if (info .eq. 2) go to 130
!
!     ONLY MIN(M,N) ELEMENTS OF WORK ARE NEEDED
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
!     HERE 2*MIN(M,N) ELEMENTS OF WORK ARE NEEDED
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
!     ERROR RETURN
!
!                             NB .LE. 0  ON A CONTINUATION CALL
200 ierr = 7
return
!                             M .LT. 1 OR N .LT. 1
210 ierr = 1
return
!                             MDA .LT. M
220 ierr = 2
return
!                             MDB .LT. MAX(M,N)
230 ierr = 3
return
!                             LIW .LT. M + N
240 ierr = 4
return
!                             LW TOO SMALL
250 ierr = 5
return
!                             RE OR AE IS NEGATIVE
260 ierr = 6
return
!                             0 .LT. KRANK .LT. NP
! 280 IERR = 8
!     RETURN
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
!       THIS ROUTINE PERFORMS A QR FACTORIZATION OF A
!       USING HOUSEHOLDER TRANSFORMATIONS. ROW AND
!       COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
!       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
!       DEFICIENCY.
!
integer, intent(inout) :: ic(n), ir(m)
!
!        INITIALIZATION
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
!        DETERMINE REL AND ABS ERROR VECTORS
!
!
!        CALCULATE COL LENGTH
!
do i = 1,n
   h(i) = snrm2(m,a(1,i),1)
   w(i) = h(i)
end do
!
!         INITIALIZE ERROR BOUNDS
!
do i = 1,n
   eb(i) = amax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!
!          DISCARD SELF DEPENDENT COLUMNS
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          MATRIX REDUCTION
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
!           TEST FOR ZERO RANK
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        M A I N    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH COL HAS MM=M-J+1 COMPONENTS
!
mm = m - j + 1
!
!         UB DETERMINES COLUMN PIVOT
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
!     TEST FOR RANK DEFICIENCY
!
if (rmin .lt. 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt .ge. 1.0) go to 170
!
!     COMPUTE EXACT UB
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
!        MATRIX REDUCTION
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
!        COLUMN PIVOT
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
!        ROW PIVOT
!
210 jmax = isamax(mm,a(j,j),1)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call sswap (n,a(j,1),mda,a(jmax,1),mda)
call iswap (1,ir(j),1,ir(jmax),1)
!
!     APPLY HOUSEHOLDER TRANSFORMATION
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
!          UPDATE UB, DB
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
!        E N D    M A I N    L O O P
!
300 continue
!
!        COMPUTE KSURE
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
!     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
!     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
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
!     FIRST NP COLUMNS ARE LINEARLY DEPENDENT
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
!        GIVEN THE HOUSEHOLDER QR FACTORIZATION OF A, THIS
!        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
!        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
!        ACCORDING TO THE SELECTED MODE.
!
!       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
!
integer, intent(inout) :: ic(n), ir(m)
!
k = krank
kp1 = k + 1
if (k .gt. 0) go to 30
!
!        RANK=0
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
!     REORDER B TO REFLECT ROW INTERCHANGES
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
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
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
!        FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
!
do jb = 1,nb
   rnorm(jb) = snrm2(m-k,b(kp1,jb),1)
end do
!
!     BACK SOLVE UPPER TRIANGULAR R
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
!     RANK LT N
!
!      TRUNCATED SOLUTION
!
200 if (k .eq. n) go to 230
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
if (mode .eq. 1) go to 230
!
!      MINIMAL LENGTH SOLUTION
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
!     REORDER B TO REFLECT COLUMN INTERCHANGES
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
!       THIS ROUTINE PERFORMS AN LQ FACTORIZATION OF THE
!       MATRIX A USING HOUSEHOLDER TRANSFORMATIONS. ROW
!       AND COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
!       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
!       DEFICIENCY.
!
integer, intent(inout) :: ic(n), ir(m)
!
!        INITIALIZATION
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
!        DETERMINE REL AND ABS ERROR VECTORS
!
!
!        CALCULATE ROW LENGTH
!
do i = 1,m
   h(i) = snrm2(n,a(i,1),mda)
   w(i) = h(i)
end do
!
!         INITIALIZE ERROR BOUNDS
!
do i = 1,m
   eb(i) = amax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.0
end do
!
!          DISCARD SELF DEPENDENT ROWS
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          MATRIX REDUCTION
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
!           TEST FOR ZERO RANK
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        M A I N    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH ROW HAS NN=N-J+1 COMPONENTS
!
nn = n - j + 1
!
!         UB DETERMINES ROW PIVOT
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
!     TEST FOR RANK DEFICIENCY
!
if (rmin .lt. 1.0) go to 200
tt = (eb(imin) + abs(db(imin)))/h(imin)
if (tt .ge. 1.0) go to 170
!
!     COMPUTE EXACT UB
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
!        MATRIX REDUCTION
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
!        ROW PIVOT
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
!        COLUMN PIVOT
!
210 jmax = isamax(nn,a(j,j),mda)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call sswap (m,a(1,j),1,a(1,jmax),1)
call iswap (1,ic(j),1,ic(jmax),1)
!
!     APPLY HOUSEHOLDER TRANSFORMATION
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
!          UPDATE UB, DB
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
!        E N D    M A I N    L O O P
!
300 continue
!
!        COMPUTE KSURE
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
!     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
!     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
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
!     FIRST NP ROWS ARE LINEARLY DEPENDENT
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
!        GIVEN THE HOUSEHOLDER LQ FACTORIZATION OF A, THIS
!        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
!        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
!        ACCORDING TO THE SELECTED MODE.
!
!       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
!
integer, intent(inout) :: ic(n), ir(m)
!
k = krank
kp1 = k + 1
if (k .gt. 0) go to 30
!
!        RANK=0
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
!     REORDER B TO REFLECT ROW INTERCHANGES
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
!     IF A IS OF REDUCED RANK AND MODE=2,
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
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
!     FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
!
140 do jb = 1,nb
   rnorm(jb) = snrm2(m-k,b(kp1,jb),1)
end do
!
!     BACK SOLVE LOWER TRIANGULAR L
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
!      TRUNCATED SOLUTION
!
if (k .eq. n) go to 210
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.0
   end do
end do
!
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
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
!     REORDER B TO REFLECT COLUMN INTERCHANGES
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
!              LEAST SQUARES SOLUTION OF LINEAR EQUATIONS
!
!                            --------------
!
!     DLSQR SOLVES BOTH UNDERDETERMINED AND OVERDETERMINED LINEAR
!     SYSTEMS AX = B, WHERE A IS AN M BY N MATRIX AND B IS AN M BY
!     NB MATRIX OF RIGHT HAND SIDES. IF M .GE. N, THE LEAST SQUARES
!     SOLUTION IS COMPUTED BY DECOMPOSING THE MATRIX A INTO THE
!     PRODUCT OF AN ORTHOGONAL MATRIX Q AND UPPER TRIANGULAR MATRIX
!     R (QR FACTORIZATION). IF M .LT. N, THE MINIMAL LENGTH SOLUTION
!     IS COMPUTED BY FACTORING THE MATRIX A INTO THE PRODUCT OF A
!     LOWER TRIANGULAR MATRIX L AND ORTHOGONAL MATRIX Q (LQ FACTOR-
!     IZATION). IF THE MATRIX A IS DETERMINED TO BE RANK DEFICIENT,
!     THEN THE MINIMAL LENGTH LEAST SQUARES SOLUTION IS COMPUTED.
!
!     USER INPUT BOUNDS ON THE UNCERTAINTY OF THE ELEMENTS OF A ARE
!     USED TO DETECT NUMERICAL RANK DEFICIENCY. THE ALGORITHM USES
!     A ROW AND COLUMN PIVOT STRATEGY TO MINIMIZE THE GROWTH OF
!     UNCERTAINTY AND ROUND-OFF ERRORS.
!
!   ******************************************************************
!   *                                                                *
!   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
!   *                                                                *
!   ******************************************************************
!
!     INPUT..
!
!     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
!                   CALLED FOR THE FIRST TIME.
!                      IND = 0      ORIGINAL CALL
!                      IND .NE. 0   SUBSEQUENT CALLS
!                   ON SUBSEQUENT CALLS A NEW SET B OF EQUATIONS CAN
!                   BE SOLVED (USING THE SAME COEFFICIENT MATRIX A).
!                   IT IS ASSUMED THAT A, MDA, M, N, KRANK, IWORK,
!                   LIW, AND THE FIRST 2*MIN(M,N) LOCATIONS OF WORK
!                   HAVE NOT BEEN MODIFIED BY THE USER. RE, AE, AND
!                   KSURE ARE NOT USED.
!
!     A(,)          LINEAR COEFFICIENT MATRIX OF AX=B, WITH MDA THE
!      MDA,M,N      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
!                   M IS THE ROW DIMENSION (NO. OF EQUATIONS OF THE
!                   PROBLEM) AND N THE COL DIMENSION (NO. OF UNKNOWNS).
!                   MUST HAVE MDA .GE. M.
!
!     B(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
!      MDB,NB       DIMENSION OF B IN THE CALLING PROGRAM. NB IS THE
!                   NUMBER OF M BY 1 RIGHT HAND SIDES. MUST HAVE
!                   MDB .GE. MAX(M,N). IF NB .LE. 0 THEN B AND MDB
!                   ARE IGNORED.
!
!     RE            RE IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX A (0 .LE. RE .LT. 1).
!
!     AE            AE IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
!                   ELEMENTS OF THE MATRIX A (AE .GE. 0).
!
!     WORK()        A REAL WORK ARRAY DIMENSIONED 5*MIN(M,N).
!
!     LW            ACTUAL DIMENSION OF WORK
!
!     IWORK()       INTEGER WORK ARRAY DIMENSIONED AT LEAST N+M.
!
!     LIW           ACTUAL DIMENSION OF IWORK.
!
!     OUTPUT..
!
!     A(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
!                   AND THE TRANSFORMATION INFORMATION.IND TOGETHER WITH
!                   THE FIRST 2*MIN(M,N) ELEMENTS OF WORK (SEE BELOW)
!                   COMPLETELY SPECIFY THE FACTORIZATION OF A.
!
!     B(,)          CONTAINS THE N BY NB SOLUTION MATRIX FOR X.
!
!     KRANK,KSURE   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
!                   AND ABSOLUTE BOUNDS ON UNCERTAINTY, IS BOUNDED
!                   ABOVE BY KRANK AND BELOW BY KSURE. THE ALGORITHM
!                   RETURNS A SOLUTION BASED ON KRANK. KSURE PROVIDES
!                   AN INDICATION OF THE PRECISION OF THE RANK.
!
!     RNORM()       CONTAINS THE EUCLIDEAN LENGTH OF THE NB RESIDUAL
!                   VECTORS  B(I) - AX(I), I=1,...,NB.
!
!     WORK()        THE FIRST 2*MIN(M,N) LOCATIONS OF WORK CONTAIN
!                   THE VALUES NECESSARY TO REPRODUCE THE HOUSEHOLDER
!                   FACTORIZATION OF A.
!
!     IWORK()       AN ARRAY OF LENGTH M + N CONTAINING THE ORDERS IN
!                   WHICH THE ROWS AND COLUMNS WERE USED. IF M .GE. N
!                   THEN THE FIRST N LOCATIONS CONTAIN THE ORDER OF
!                   THE COLUMNS AND THE NEXT M LOCATIONS THE ORDER OF
!                   THE ROWS. IF M .LT. N THEN THE ORDER OF THE ROWS
!                   PRECEDES THE ORDER OF THE COLUMNS.
!
!     IERR          FLAG TO INDICATE THE STATUS OF THE RESULTS
!                     0     - SATISFACTORY COMPLETION
!                   .GT. 0  - INPUT ERROR
!
!----------------
!     THE SUBROUTINES DU11LS, DU12LS, DU11US, AND DU12US WERE WRITTEN BY
!     T. MANTEUFFEL (LANL) IN 1981. THE DRIVER ROUTINE DLSQR WAS WRITTEN
!     BY A.H. MORRIS (NSWC) IN 1991.
!----------------
!     REFERENCE.  MANTEUFFEL, T., *AN INTERVAL ANALYSIS APPROACH TO RANK
!                 DETERMINATION IN LINEAR LEAST SQUARES PROBLEMS*,
!                 SANDIA LABORATORIES REPORT SAND80-0655, JUNE, 1980.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(mda,n), b(mdb,*)
double precision, intent(in) :: re, ae
double precision, intent(inout) :: rnorm(*), work(lw)
integer, intent(inout) :: iwork(liw)
double precision :: eps, rerr
double precision :: dpmpar
!----------------
!     NP            IF M .GE. N THEN THE FIRST NP COLUMNS OF A
!                   ARE NEVER INTERCHANGED.
!                   IF M .LT. N THEN THE FIRST NP ROWS OF A ARE
!                   NEVER INTERCHANGED. NP IS NOT REFERENCED ON
!                   A CONTINUATION CALL TO THE ROUTINE.
!
!     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
!                   IS TO REACT IF RANK DEFICIENCY IS DETECTED.
!                   IF MODE = 0 RETURN IMMEDIATELY, NO SOLUTION
!                             1 COMPUTE TRUNCATED SOLUTION
!                             2 COMPUTE MINIMAL LENGTH SOLUTION
!                   MODE MUST NOT BE MODIFIED ON A CONTINUATION
!                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
!                   FIRST N LOCATIONS OF WORK ARE USED.
!----------------
np = 0
mode = 2
!
!     CHECK THE INPUT
!
if (nb .le. 0 .and. ind .ne. 0) go to 200
if (m .lt. 1 .or. n .lt. 1) go to 210
if (mda .lt. m) go to 220
if (liw .lt. m + n) go to 240
!
m0 = min0(m,n)
n0 = max0(m,n)
!     NUM = 0
!
if (nb .le. 0) go to 10
if (mdb .lt. n0) go to 230
if (ind .ne. 0) go to 100
!
10 if (lw .lt. 5*m0) go to 250
if (re .lt. 0.d0 .or. ae .lt. 0.d0) go to 260
!
!     DEFINE THE RELATIVE AND ABSOLUTE TOLERANCE LISTS
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
!     FACTOR THE MATRIX A
!
!     NUM = NP
if (m .lt. n) go to 40
!
   call du11ls (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
   go to 100
!
40 call du11us (a,mda,m,n,work(m4),work(m5),mode,np,krank,ksure, &
&work(m1),work(m2),work(m3),iwork(m1),iwork(m2))
!
!     SOLUTION PHASE
!
100 ierr = 0
info = 0
if (krank .eq. m0) go to 110
if (krank .eq. 0) go to 110
!     IF (KRANK .LT. NUM) GO TO 280
!     IF (MODE .EQ. 0) RETURN
info = mode
!
110 if (nb .le. 0) return
!
m1 = 1
m2 = 1 + m0
if (info .eq. 2) go to 130
!
!     ONLY MIN(M,N) ELEMENTS OF WORK ARE NEEDED
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
!     HERE 2*MIN(M,N) ELEMENTS OF WORK ARE NEEDED
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
!     ERROR RETURN
!
!                             NB .LE. 0  ON A CONTINUATION CALL
200 ierr = 7
return
!                             M .LT. 1 OR N .LT. 1
210 ierr = 1
return
!                             MDA .LT. M
220 ierr = 2
return
!                             MDB .LT. MAX(M,N)
230 ierr = 3
return
!                             LIW .LT. M + N
240 ierr = 4
return
!                             LW TOO SMALL
250 ierr = 5
return
!                             RE OR AE IS NEGATIVE
260 ierr = 6
return
!                             0 .LT. KRANK .LT. NP
! 280 IERR = 8
!     RETURN
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
!       THIS ROUTINE PERFORMS A QR FACTORIZATION OF A
!       USING HOUSEHOLDER TRANSFORMATIONS. ROW AND
!       COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
!       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
!       DEFICIENCY.
!
double precision, intent(inout) :: a(mda,n), ub(n), db(n), h(n), &
&w(n), eb(n)
integer, intent(inout) :: ic(n), ir(m)
double precision :: bb, rmin, r2, sum, t, temp, tn, tt
double precision :: ddot, dnrm2
!
!        INITIALIZATION
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
!        DETERMINE REL AND ABS ERROR VECTORS
!
!
!        CALCULATE COL LENGTH
!
do i = 1,n
   h(i) = dnrm2(m,a(1,i),1)
   w(i) = h(i)
end do
!
!         INITIALIZE ERROR BOUNDS
!
do i = 1,n
   eb(i) = dmax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.d0
end do
!
!          DISCARD SELF DEPENDENT COLUMNS
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          MATRIX REDUCTION
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
!           TEST FOR ZERO RANK
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        M A I N    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH COL HAS MM=M-J+1 COMPONENTS
!
mm = m - j + 1
!
!         UB DETERMINES COLUMN PIVOT
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
!     TEST FOR RANK DEFICIENCY
!
if (rmin .lt. 1.d0) go to 200
tt = (eb(imin) + dabs(db(imin)))/h(imin)
if (tt .ge. 1.d0) go to 170
!
!     COMPUTE EXACT UB
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
!        MATRIX REDUCTION
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
!        COLUMN PIVOT
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
!        ROW PIVOT
!
210 jmax = idamax(mm,a(j,j),1)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call dswap (n,a(j,1),mda,a(jmax,1),mda)
call iswap (1,ir(j),1,ir(jmax),1)
!
!     APPLY HOUSEHOLDER TRANSFORMATION
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
!          UPDATE UB, DB
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
!        E N D    M A I N    L O O P
!
300 continue
!
!        COMPUTE KSURE
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
!     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
!     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
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
!     FIRST NP COLUMNS ARE LINEARLY DEPENDENT
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
!        GIVEN THE HOUSEHOLDER QR FACTORIZATION OF A, THIS
!        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
!        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
!        ACCORDING TO THE SELECTED MODE.
!
!       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
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
!        RANK=0
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
!     REORDER B TO REFLECT ROW INTERCHANGES
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
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
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
!        FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
!
do jb = 1,nb
   rnorm(jb) = dnrm2(m-k,b(kp1,jb),1)
end do
!
!     BACK SOLVE UPPER TRIANGULAR R
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
!     RANK LT N
!
!      TRUNCATED SOLUTION
!
200 if (k .eq. n) go to 230
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.d0
   end do
end do
if (mode .eq. 1) go to 230
!
!      MINIMAL LENGTH SOLUTION
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
!     REORDER B TO REFLECT COLUMN INTERCHANGES
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
!       THIS ROUTINE PERFORMS AN LQ FACTORIZATION OF THE
!       MATRIX A USING HOUSEHOLDER TRANSFORMATIONS. ROW
!       AND COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
!       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
!       DEFICIENCY.
!
double precision, intent(inout) :: a(mda,n), ub(m), db(m), h(m), &
&w(m), eb(m)
integer, intent(inout) :: ic(n), ir(m)
double precision :: bb, rmin, r2, sum, t, temp, tn, tt
double precision :: ddot, dnrm2
!
!        INITIALIZATION
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
!        DETERMINE REL AND ABS ERROR VECTORS
!
!
!        CALCULATE ROW LENGTH
!
do i = 1,m
   h(i) = dnrm2(n,a(i,1),mda)
   w(i) = h(i)
end do
!
!         INITIALIZE ERROR BOUNDS
!
do i = 1,m
   eb(i) = dmax1(db(i),ub(i)*h(i))
   ub(i) = eb(i)
   db(i) = 0.d0
end do
!
!          DISCARD SELF DEPENDENT ROWS
!
i = 1
50 if (eb(i) .ge. h(i)) go to 60
if (i .eq. krank) go to 70
i = i + 1
go to 50
!
!          MATRIX REDUCTION
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
!           TEST FOR ZERO RANK
!
70 if (krank .gt. 0) go to 100
krank = 0
ksure = 0
return
!
!        M A I N    L O O P
!
100 j = j + 1
jp1 = j + 1
jm1 = j - 1
kz = krank
if (j .le. np) kz = j
!
!        EACH ROW HAS NN=N-J+1 COMPONENTS
!
nn = n - j + 1
!
!         UB DETERMINES ROW PIVOT
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
!     TEST FOR RANK DEFICIENCY
!
if (rmin .lt. 1.d0) go to 200
tt = (eb(imin) + dabs(db(imin)))/h(imin)
if (tt .ge. 1.d0) go to 170
!
!     COMPUTE EXACT UB
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
!        MATRIX REDUCTION
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
!        ROW PIVOT
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
!        COLUMN PIVOT
!
210 jmax = idamax(nn,a(j,j),mda)
jmax = jmax + j - 1
if (jmax .eq. j) go to 220
call dswap (m,a(1,j),1,a(1,jmax),1)
call iswap (1,ic(j),1,ic(jmax),1)
!
!     APPLY HOUSEHOLDER TRANSFORMATION
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
!          UPDATE UB, DB
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
!        E N D    M A I N    L O O P
!
300 continue
!
!        COMPUTE KSURE
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
!     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
!     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
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
!     FIRST NP ROWS ARE LINEARLY DEPENDENT
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
!        GIVEN THE HOUSEHOLDER LQ FACTORIZATION OF A, THIS
!        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
!        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
!        ACCORDING TO THE SELECTED MODE.
!
!       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
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
!        RANK=0
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
!     REORDER B TO REFLECT ROW INTERCHANGES
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
!     IF A IS OF REDUCED RANK AND MODE=2,
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
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
!     FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
!
140 do jb = 1,nb
   rnorm(jb) = dnrm2(m-k,b(kp1,jb),1)
end do
!
!     BACK SOLVE LOWER TRIANGULAR L
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
!      TRUNCATED SOLUTION
!
if (k .eq. n) go to 210
do jb = 1,nb
   do i = kp1,n
      b(i,jb) = 0.d0
   end do
end do
!
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
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
!     REORDER B TO REFLECT COLUMN INTERCHANGES
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
!     DIMENSION A(MDA,N),(B(MDB,NB) OR B(M)),RNORM(NB),H(N),G(N),IP(N)
!
!     WRITTEN BY C.L. LAWSON AND R.J. HANSON.
!     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
!     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
!
!     ABSTRACT
!
!     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
!     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
!     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
!     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
!     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
!     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
!     PROBLEMS.
!
!     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
!     SQUARES PROBLEM
!
!                       AX = B,
!
!     WHERE X IS THE N BY NB SOLUTION MATRIX.
!
!     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
!     PSEUDO-INVERSE OF A.
!
!     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
!     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
!     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
!     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
!
!                       ABS(R(I,I)).GE.ABS(R(I+1,I+1)),
!
!                       I = 1,...,L-1, WHERE
!
!                       L = MIN(M,N).
!
!     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS
!     OF R THAT EXCEED TAU IN MAGNITUDE. THEN THE SOLUTION OF MINIMUM
!     EUCLIDEAN LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
!
!     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
!     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
!     MAGNITUDES.
!
!     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
!     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
!     EPS*(NORM OF A).
!
!     THE ENTIRE SET OF PARAMETERS FOR HFTI ARE
!
!     INPUT..
!
!     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
!                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
!                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
!                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
!                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
!                       IS NO RESTRICTION ON THE RANK OF A.  THE
!                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
!
!     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
!                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
!                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
!                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
!                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
!                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
!                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
!                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
!                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
!                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
!                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
!                       VALUE SUCH AS MDB = M.
!
!                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
!                       IS CONSIDERED AN ERROR.
!
!     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       FOR PSEUDORANK DETERMINATION.
!
!     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY HFTI.
!
!     OUTPUT..
!
!     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
!                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
!
!     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
!                       NB SOLUTION MATRIX X.
!
!     K                 SET BY THE SUBROUTINE TO INDICATE THE
!                       PSEUDORANK OF A.
!
!     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
!                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
!                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
!                       B(*,*) FOR J = 1,...,NB.
!
!     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
!                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
!                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
!
!     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
!                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
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
!     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
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
!     LMAX HAS BEEN DETERMINED
!
!     DO COLUMN INTERCHANGES IF NEEDED.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
!    ..
70 call h12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call h12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
!    ..
    do j = 1,ldiag
    if (abs(a(j,j)) .le. tau) go to 100
    end do
k = ldiag
go to 110
100 k = j - 1
110 kp1 = k + 1
!
!     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
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
!     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
!     DECOMPOSITION OF FIRST K ROWS.
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
!     SOLVE THE K BY K TRIANGULAR SYSTEM.
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
!     COMPLETE COMPUTATION OF SOLUTION VECTOR.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.0
        do 230 i = 1,k
230 call h12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
!      COLUMN INTERCHANGES.
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
!     THE SOLUTION VECTORS, X, ARE NOW
!     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
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
!     DIMENSION A(MDA,N),(B(MDB,NB) OR B(M))
!     DIMENSION D(L) WHERE L = MIN(M,N)
!     DIMENSION RNORM(NB),H(N),G(N),IP(N)
!
!     WRITTEN BY C.L. LAWSON AND R.J. HANSON. MODIFIED BY A.H. MORRIS.
!     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
!     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
!
!     ABSTRACT
!
!     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
!     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
!     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
!     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
!     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
!     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
!     PROBLEMS.
!
!     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
!     SQUARES PROBLEM
!
!                       AX = B,
!
!     WHERE X IS THE N BY NB SOLUTION MATRIX.
!
!     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
!     PSEUDO-INVERSE OF A.
!
!     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
!     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
!     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
!     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
!
!                       ABS(R(I,I)).GE.ABS(R(I+1,I+1)),
!
!                       I = 1,...,L-1, WHERE
!
!                       L = MIN(M,N).
!
!     THE ARRAY D WILL CONTAIN THE DIAGONAL ELEMENTS R(1,1),...,R(L,L).
!     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS THAT
!     EXCEED TAU IN MAGNITUDE.  THEN THE SOLUTION OF MINIMUM EUCLIDEAN
!     LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
!
!     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
!     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
!     MAGNITUDES.
!
!     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
!     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
!     EPS*(NORM OF A).
!
!     THE ENTIRE SET OF PARAMETERS FOR HFTI2 ARE
!
!     INPUT..
!
!     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
!                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
!                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
!                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
!                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
!                       IS NO RESTRICTION ON THE RANK OF A.  THE
!                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
!
!     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
!                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
!                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
!                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
!                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
!                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
!                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
!                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
!                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
!                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
!                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
!                       VALUE SUCH AS MDB = M.
!
!                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
!                       IS CONSIDERED AN ERROR.
!
!     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       FOR PSEUDORANK DETERMINATION.
!
!     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY HFTI2.
!
!     OUTPUT..
!
!     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
!                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
!
!     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
!                       NB SOLUTION MATRIX X.
!
!     D(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!                       TRIANGULAR MATRIX R
!
!     K                 SET BY THE SUBROUTINE TO INDICATE THE
!                       PSEUDORANK OF A.
!
!     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
!                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
!                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
!                       B(*,*) FOR J = 1,...,NB.
!
!     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
!                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
!                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
!
!     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
!                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
!
!     IERR              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!                       DETECTED THEN IERR IS SET TO 0. OTHERWISE
!                          IERR = 1  IF MDA.LT.M
!                          IERR = 2  IF NB.GT.1 AND MDB.LT.MAX(M,N)
!                       THESE ERRORS ARE FATAL.
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
!     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
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
!     LMAX HAS BEEN DETERMINED
!
!     DO COLUMN INTERCHANGES IF NEEDED.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
!    ..
70 call h12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call h12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
!     ALSO STORE THE DIAGONAL ELEMENTS IN THE ARRAY D.
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
!     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
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
!     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
!     DECOMPOSITION OF FIRST K ROWS.
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
!     SOLVE THE K BY K TRIANGULAR SYSTEM.
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
!     COMPLETE COMPUTATION OF SOLUTION VECTOR.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.0
        do 230 i = 1,k
230 call h12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
!      COLUMN INTERCHANGES.
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
!     THE SOLUTION VECTORS, X, ARE NOW
!     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
!
270 ierr = 0
return
!
!     ERROR RETURN
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
!     WRITTEN BY C.L. LAWSON AND R.J. HANSON.  MODIFIED BY A.H. MORRIS.
!     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
!
!     CONSTRUCTION AND/OR APPLICATION OF A SINGLE
!     HOUSEHOLDER TRANSFORMATION..     Q = I + U*(U**T)/B
!
!     MODE    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
!     LPIVOT IS THE INDEX OF THE PIVOT ELEMENT.
!     L1,M   IF L1 .LE. M   THE TRANSFORMATION WILL BE CONSTRUCTED TO
!            ZERO ELEMENTS INDEXED FROM L1 THROUGH M.   IF L1 GT. M
!            THE SUBROUTINE DOES AN IDENTITY TRANSFORMATION.
!     U(),IUE,UP    ON ENTRY TO H1 U() CONTAINS THE PIVOT VECTOR.
!                   IUE IS THE STORAGE INCREMENT BETWEEN ELEMENTS.
!                                       ON EXIT FROM H1 U() AND UP
!                   CONTAIN QUANTITIES DEFINING THE VECTOR U OF THE
!                   HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 U()
!                   AND UP SHOULD CONTAIN QUANTITIES PREVIOUSLY COMPUTED
!                   BY H1.  THESE WILL NOT BE MODIFIED BY H2.
!     C()    ON ENTRY TO H1 OR H2 C() CONTAINS A MATRIX WHICH WILL BE
!            REGARDED AS A SET OF VECTORS TO WHICH THE HOUSEHOLDER
!            TRANSFORMATION IS TO BE APPLIED.  ON EXIT C() CONTAINS THE
!            SET OF TRANSFORMED VECTORS.
!     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN C().
!     ICV    STORAGE INCREMENT BETWEEN VECTORS IN C().
!     NCV    NUMBER OF VECTORS IN C() TO BE TRANSFORMED. IF NCV .LE. 0
!            NO OPERATIONS WILL BE DONE ON C().
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
!            ****** APPLY THE TRANSFORMATION  I+U*(U**T)/B  TO C. ******
!
60 if (cl) 130,130,70
70 if (ncv .le. 0) return
b = dble(up)*dble(u(1,lpivot))
!
!                       B  MUST BE NONPOSITIVE HERE.  IF B = 0., RETURN.
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
!     DOUBLE PRECISION A(MDA,N),(B(MDB,NB) OR B(M))
!     DOUBLE PRECISION TAU,RNORM(NB),H(N),G(N)
!     INTEGER IP(N)
!
!     WRITTEN BY C.L. LAWSON AND R.J. HANSON.
!     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
!     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
!
!     ABSTRACT
!
!     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
!     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
!     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
!     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
!     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
!     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
!     PROBLEMS.
!
!     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
!     SQUARES PROBLEM
!
!                       AX = B,
!
!     WHERE X IS THE N BY NB SOLUTION MATRIX.
!
!     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
!     PSEUDO-INVERSE OF A.
!
!     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
!     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
!     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
!     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
!
!                       DABS(R(I,I)).GE.DABS(R(I+1,I+1)),
!
!                       I = 1,...,L-1, WHERE
!
!                       L = MIN(M,N).
!
!     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS
!     OF R THAT EXCEED TAU IN MAGNITUDE. THEN THE SOLUTION OF MINIMUM
!     EUCLIDEAN LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
!
!     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
!     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
!     MAGNITUDES.
!
!     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
!     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
!     EPS*(NORM OF A).
!
!     THE ENTIRE SET OF PARAMETERS FOR DHFTI ARE
!
!     INPUT..
!
!     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
!                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
!                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
!                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
!                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
!                       IS NO RESTRICTION ON THE RANK OF A.  THE
!                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
!
!     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
!                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
!                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
!                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
!                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
!                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
!                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
!                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
!                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
!                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
!                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
!                       VALUE SUCH AS MDB = M.
!
!                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
!                       IS CONSIDERED AN ERROR.
!
!     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       FOR PSEUDORANK DETERMINATION.
!
!     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY DHFTI.
!
!     OUTPUT..
!
!     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
!                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
!
!     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
!                       NB SOLUTION MATRIX X.
!
!     K                 SET BY THE SUBROUTINE TO INDICATE THE
!                       PSEUDORANK OF A.
!
!     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
!                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
!                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
!                       B(*,*) FOR J = 1,...,NB.
!
!     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
!                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
!                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
!
!     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
!                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
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
!     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
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
!     LMAX HAS BEEN DETERMINED
!
!     DO COLUMN INTERCHANGES IF NEEDED.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
!    ..
70 call dh12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call dh12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
!    ..
    do j = 1,ldiag
    if (dabs(a(j,j)) .le. tau) go to 100
    end do
k = ldiag
go to 110
100 k = j - 1
110 kp1 = k + 1
!
!     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
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
!     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
!     DECOMPOSITION OF FIRST K ROWS.
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
!     SOLVE THE K BY K TRIANGULAR SYSTEM.
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
!     COMPLETE COMPUTATION OF SOLUTION VECTOR.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.d0
        do 230 i = 1,k
230 call dh12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
!      COLUMN INTERCHANGES.
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
!     THE SOLUTION VECTORS, X, ARE NOW
!     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
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
!     DOUBLE PRECISION A(MDA,N),(B(MDB,NB) OR B(M))
!     DOUBLE PRECISION D(L) WHERE L = MIN(M,N)
!     DOUBLE PRECISION TAU,RNORM(NB),H(N),G(N)
!     INTEGER IP(N)
!
!     WRITTEN BY C.L. LAWSON AND R.J. HANSON. MODIFIED BY A.H. MORRIS.
!     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
!     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
!
!     ABSTRACT
!
!     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
!     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
!     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
!     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
!     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
!     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
!     PROBLEMS.
!
!     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
!     SQUARES PROBLEM
!
!                       AX = B,
!
!     WHERE X IS THE N BY NB SOLUTION MATRIX.
!
!     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
!     PSEUDO-INVERSE OF A.
!
!     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
!     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
!     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
!     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
!
!                       DABS(R(I,I)).GE.DABS(R(I+1,I+1)),
!
!                       I = 1,...,L-1, WHERE
!
!                       L = MIN(M,N).
!
!     THE ARRAY D WILL CONTAIN THE DIAGONAL ELEMENTS R(1,1),...,R(L,L).
!     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS THAT
!     EXCEED TAU IN MAGNITUDE.  THEN THE SOLUTION OF MINIMUM EUCLIDEAN
!     LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
!
!     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
!     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
!     MAGNITUDES.
!
!     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
!     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
!     EPS*(NORM OF A).
!
!     THE ENTIRE SET OF PARAMETERS FOR DHFTI2 ARE
!
!     INPUT..
!
!     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
!                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
!                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
!                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
!                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
!                       IS NO RESTRICTION ON THE RANK OF A.  THE
!                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
!
!     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
!                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
!                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
!                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
!                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
!                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
!                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
!                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
!                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
!                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
!                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
!                       VALUE SUCH AS MDB = M.
!
!                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
!                       IS CONSIDERED AN ERROR.
!
!     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
!                       FOR PSEUDORANK DETERMINATION.
!
!     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY DHFTI2.
!
!     OUTPUT..
!
!     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
!                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
!
!     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
!                       NB SOLUTION MATRIX X.
!
!     D(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
!                       TRIANGULAR MATRIX R
!
!     K                 SET BY THE SUBROUTINE TO INDICATE THE
!                       PSEUDORANK OF A.
!
!     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
!                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
!                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
!                       B(*,*) FOR J = 1,...,NB.
!
!     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
!                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
!                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
!                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
!
!     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
!                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
!                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
!                       ARE NOT GENERALLY REQUIRED BY THE USER.
!
!     IERR              ERROR INDICATOR. IF NO INPUT ERRORS ARE
!                       DETECTED THEN IERR IS SET TO 0. OTHERWISE
!                          IERR = 1  IF MDA.LT.M
!                          IERR = 2  IF NB.GT.1 AND MDB.LT.MAX(M,N)
!                       THESE ERRORS ARE FATAL.
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
!     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
!    ..
    lmax = j
        do l = j,n
        h(l) = h(l) - a(j-1,l)**2
        if (h(l) .gt. h(lmax)) lmax = l
        end do
    z = hmax + factor*h(lmax)
    if (z .gt. hmax) go to 50
!
!     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
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
!     LMAX HAS BEEN DETERMINED
!
!     DO COLUMN INTERCHANGES IF NEEDED.
!    ..
50 ip(j) = lmax
    if (ip(j) .eq. j) go to 70
        do 60 i = 1,m
        tmp = a(i,j)
        a(i,j) = a(i,lmax)
60 a(i,lmax) = tmp
    h(lmax) = h(j)
!
!     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
!    ..
70 call dh12 (1,j,j+1,m,a(1,j),1,h(j),a(1,j+1),1,mda,n-j)
80 call dh12 (2,j,j+1,m,a(1,j),1,h(j),b,1,mdb,nb)
!
!     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
!     ALSO STORE THE DIAGONAL ELEMENTS IN THE ARRAY D.
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
!     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
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
!     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
!     DECOMPOSITION OF FIRST K ROWS.
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
!     SOLVE THE K BY K TRIANGULAR SYSTEM.
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
!     COMPLETE COMPUTATION OF SOLUTION VECTOR.
!    ..
    if (k .eq. n) go to 240
        do 220 j = kp1,n
220 b(j,jb) = 0.d0
        do 230 i = 1,k
230 call dh12 (2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
!
!      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
!      COLUMN INTERCHANGES.
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
!     THE SOLUTION VECTORS, X, ARE NOW
!     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
!
270 ierr = 0
return
!
!     ERROR RETURN
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
!     WRITTEN BY C.L. LAWSON AND R.J. HANSON.  MODIFIED BY A.H. MORRIS.
!     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
!
!     CONSTRUCTION AND/OR APPLICATION OF A SINGLE
!     HOUSEHOLDER TRANSFORMATION..     Q = I + U*(U**T)/B
!
!     MODE    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
!     LPIVOT IS THE INDEX OF THE PIVOT ELEMENT.
!     L1,M   IF L1 .LE. M   THE TRANSFORMATION WILL BE CONSTRUCTED TO
!            ZERO ELEMENTS INDEXED FROM L1 THROUGH M.   IF L1 GT. M
!            THE SUBROUTINE DOES AN IDENTITY TRANSFORMATION.
!     U(),IUE,UP    ON ENTRY TO H1 U() CONTAINS THE PIVOT VECTOR.
!                   IUE IS THE STORAGE INCREMENT BETWEEN ELEMENTS.
!                                       ON EXIT FROM H1 U() AND UP
!                   CONTAIN QUANTITIES DEFINING THE VECTOR U OF THE
!                   HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 U()
!                   AND UP SHOULD CONTAIN QUANTITIES PREVIOUSLY COMPUTED
!                   BY H1.  THESE WILL NOT BE MODIFIED BY H2.
!     C()    ON ENTRY TO H1 OR H2 C() CONTAINS A MATRIX WHICH WILL BE
!            REGARDED AS A SET OF VECTORS TO WHICH THE HOUSEHOLDER
!            TRANSFORMATION IS TO BE APPLIED.  ON EXIT C() CONTAINS THE
!            SET OF TRANSFORMED VECTORS.
!     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN C().
!     ICV    STORAGE INCREMENT BETWEEN VECTORS IN C().
!     NCV    NUMBER OF VECTORS IN C() TO BE TRANSFORMED. IF NCV .LE. 0
!            NO OPERATIONS WILL BE DONE ON C().
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
!            ****** APPLY THE TRANSFORMATION  I+U*(U**T)/B  TO C. ******
!
60 if (cl) 130,130,70
70 if (ncv .le. 0) return
b = up*u(1,lpivot)
!
!                       B  MUST BE NONPOSITIVE HERE.  IF B = 0., RETURN.
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
!     DIMENSION W(MDW,N+1),PRGOPT(*),X(N),
!     WS(2*(ME+N)+K+(MG+2)*(N+7)),IP(MG+2*N+2)
!     ABOVE, K=MAX(MA+MG,N).
!
!     WRITTEN BY R. J. HANSON AND K. H. HASKELL.  FOR FURTHER MATH.
!     AND ALGORITHMIC DETAILS SEE SANDIA LABORATORIES TECH. REPTS.
!     SAND77-0552, (1978), AND SAND78-1290, (1979), AND MATH.
!     PROGRAMMING (21), 1981, PP. 98-118. MODIFIED BY A.H. MORRIS.
!
!     ABSTRACT
!
!     THIS SUBPROGRAM SOLVES A LINEARLY CONSTRAINED LEAST SQUARES
!     PROBLEM WITH BOTH EQUALITY AND INEQUALITY CONSTRAINTS, AND, IF THE
!     USER REQUESTS, OBTAINS A COVARIANCE MATRIX OF THE SOLUTION
!     PARAMETERS.
!
!     SUPPOSE THERE ARE GIVEN MATRICES E, A AND G OF RESPECTIVE
!     DIMENSIONS ME BY N, MA BY N AND MG BY N, AND VECTORS F, B AND H OF
!     RESPECTIVE LENGTHS ME, MA AND MG.  THIS SUBROUTINE SOLVES THE
!     LINEARLY CONSTRAINED LEAST SQUARES PROBLEM
!
!                   EX = F, (E ME BY N) (EQUATIONS TO BE EXACTLY
!                                       SATISFIED)
!                   AX = B, (A MA BY N) (EQUATIONS TO BE
!                                       APPROXIMATELY SATISFIED,
!                                       LEAST SQUARES SENSE)
!                   GX.GE.H,(G MG BY N) (INEQUALITY CONSTRAINTS)
!
!     THE INEQUALITIES GX.GE.H MEAN THAT EVERY COMPONENT OF THE PRODUCT
!     GX MUST BE .GE. THE CORRESPONDING COMPONENT OF H.
!
!     IN CASE THE EQUALITY CONSTRAINTS CANNOT BE SATISFIED, A
!     GENERALIZED INVERSE SOLUTION RESIDUAL VECTOR LENGTH IS OBTAINED
!     FOR F-EX. THIS IS THE MINIMAL LENGTH POSSIBLE FOR F-EX.
!
!
!     ANY VALUES ME.GE.0, MA.GE.0, OR MG.GE.0 ARE PERMITTED.  THE
!     RANK OF THE MATRIX E IS ESTIMATED DURING THE COMPUTATION. WE CALL
!     THIS VALUE KRANKE. IT IS AN OUTPUT PARAMETER IN IP(1) DEFINED
!     BELOW. USING A GENERALIZED INVERSE SOLUTION OF EX=F, A REDUCED
!     LEAST SQUARES PROBLEM WITH INEQUALITY CONSTRAINTS IS OBTAINED.
!     THE TOLERANCES USED IN THESE TESTS FOR DETERMINING THE RANK
!     OF E AND THE RANK OF THE REDUCED LEAST SQUARES PROBLEM ARE
!     GIVEN IN SANDIA TECH. REPT. SAND78-1290. THEY CAN BE
!     MODIFIED BY THE USER IF NEW VALUES ARE PROVIDED IN
!     THE OPTION LIST OF THE ARRAY PRGOPT(*).
!
!     THE USER MUST DIMENSION ALL ARRAYS APPEARING IN THE CALL LIST..
!     W(MDW,N+1),PRGOPT(*),X(N),WS(2*(ME+N)+K+(MG+2)*(N+7)),IP(MG+2*N+2)
!     WHERE K=MAX(MA+MG,N).  THIS ALLOWS FOR A SOLUTION OF A RANGE OF
!     PROBLEMS IN THE GIVEN WORKING SPACE.  THE DIMENSION OF WS(*)
!     GIVEN IS A NECESSARY OVERESTIMATE.  ONCE A PARTICULAR PROBLEM
!     HAS BEEN RUN, THE OUTPUT PARAMETER IP(3) GIVES THE ACTUAL
!     DIMENSION REQUIRED FOR THAT PROBLEM.
!
!     THE PARAMETERS FOR LSEI( ) ARE
!
!     INPUT..
!
!     W(*,*),MDW,   THE ARRAY W(*,*) IS DOUBLY SUBSCRIPTED WITH
!     ME,MA,MG,N    FIRST DIMENSIONING PARAMETER EQUAL TO MDW.
!                   FOR THIS DISCUSSION LET US CALL M = ME+MA+MG.  THEN
!                   MDW MUST SATISFY MDW.GE.M.  THE CONDITION
!                   MDW.LT.M IS AN ERROR.
!
!                   THE ARRAY W(*,*) CONTAINS THE MATRICES AND VECTORS
!
!                                  (E  F)
!                                  (A  B)
!                                  (G  H)
!
!                   IN ROWS AND COLUMNS 1,...,M AND 1,...,N+1
!                   RESPECTIVELY.
!
!                   THE INTEGERS ME, MA, AND MG ARE THE
!                   RESPECTIVE MATRIX ROW DIMENSIONS
!                   OF E, A AND G. EACH MATRIX HAS N COLUMNS.
!
!     PRGOPT(*)    THIS REAL-VALUED ARRAY IS THE OPTION VECTOR.
!                  IF THE USER IS SATISFIED WITH THE NOMINAL
!                  SUBPROGRAM FEATURES SET
!
!                  PRGOPT(1)=1 (OR PRGOPT(1)=1.0)
!
!                  OTHERWISE PRGOPT(*) IS A LINKED LIST CONSISTING OF
!                  GROUPS OF DATA OF THE FOLLOWING FORM
!
!                  LINK
!                  KEY
!                  DATA SET
!
!                  THE PARAMETERS LINK AND KEY ARE EACH ONE WORD.
!                  THE DATA SET CAN BE COMPRISED OF SEVERAL WORDS.
!                  THE NUMBER OF ITEMS DEPENDS ON THE VALUE OF KEY.
!                  THE VALUE OF LINK POINTS TO THE FIRST
!                  ENTRY OF THE NEXT GROUP OF DATA WITHIN
!                  PRGOPT(*).  THE EXCEPTION IS WHEN THERE ARE
!                  NO MORE OPTIONS TO CHANGE.  IN THAT
!                  CASE LINK=1 AND THE VALUES KEY AND DATA SET
!                  ARE NOT REFERENCED. THE GENERAL LAYOUT OF
!                  PRGOPT(*) IS AS FOLLOWS.
!
!               ...PRGOPT(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!               .  PRGOPT(2)=KEY1 (KEY TO THE OPTION CHANGE)
!               .  PRGOPT(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!               .       .
!               .       .
!               .       .
!               ...PRGOPT(LINK1)=LINK2 (LINK TO THE FIRST ENTRY OF
!               .                       NEXT GROUP)
!               .  PRGOPT(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!               .  PRGOPT(LINK1+2)=DATA VALUE
!               ...     .
!               .       .
!               .       .
!               ...PRGOPT(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!
!                  VALUES OF LINK THAT ARE NONPOSITIVE ARE ERRORS.
!                  A VALUE OF LINK.GT.NLINK=100000 IS ALSO AN ERROR.
!                  THIS HELPS PREVENT USING INVALID BUT POSITIVE
!                  VALUES OF LINK THAT WILL PROBABLY EXTEND
!                  BEYOND THE PROGRAM LIMITS OF PRGOPT(*).
!                  UNRECOGNIZED VALUES OF KEY ARE IGNORED.  THE
!                  ORDER OF THE OPTIONS IS ARBITRARY AND ANY NUMBER
!                  OF OPTIONS CAN BE CHANGED WITH THE FOLLOWING
!                  RESTRICTION.  TO PREVENT CYCLING IN THE
!                  PROCESSING OF THE OPTION ARRAY A COUNT OF THE
!                  NUMBER OF OPTIONS CHANGED IS MAINTAINED.
!                  WHENEVER THIS COUNT EXCEEDS NOPT=1000 THE
!                  ROUTINE TERMINATES.
!
!                  OPTIONS..
!
!                  KEY=1
!                         COMPUTE IN W(*,*) THE N BY N
!                  COVARIANCE MATRIX OF THE SOLUTION VARIABLES
!                  AS AN OUTPUT PARAMTER.  NOMINALLY THE
!                  COVARIANCE MATRIX WILL NOT BE COMPUTED.
!                  (THIS REQUIRES NO USER INPUT.)
!                  THE DATA SET FOR THIS OPTION IS A SINGLE VALUE.
!                  IT MUST BE NONZERO WHEN THE COVARIANCE MATRIX
!                  IS DESIRED.  IF IT IS ZERO, THE COVARIANCE
!                  MATRIX IS NOT COMPUTED.  WHEN THE COVARIANCE MATRIX
!                  IS COMPUTED, THE FIRST DIMENSIONING PARAMETER
!                  OF THE ARRAY W(*,*) MUST SATISFY MDW.GE.MAX0(M,N).
!
!                  KEY=2
!                         SCALE THE NONZERO COLUMNS OF THE
!                         ENTIRE DATA MATRIX.
!                  (E)
!                  (A)
!                  (G)
!
!                  TO HAVE LENGTH ONE.  THE DATA SET FOR THIS
!                  OPTION IS A SINGLE VALUE.  IT MUST BE
!                  NONZERO IF UNIT LENGTH COLUMN SCALING
!                  IS DESIRED.
!
!                  KEY=3
!                         SCALE COLUMNS OF THE ENTIRE DATA MATRIX
!                  (E)
!                  (A)
!                  (G)
!
!                  WITH A USER-PROVIDED DIAGONAL MATRIX.
!                  THE DATA SET FOR THIS OPTION CONSISTS
!                  OF THE N DIAGONAL SCALING FACTORS, ONE FOR
!                  EACH MATRIX COLUMN.
!
!                  KEY=4
!                         CHANGE THE RANK DETERMINATION TOLERANCE FOR
!                  THE EQUALITY CONSTRAINT EQUATIONS FROM
!                  THE NOMINAL VALUE OF SQRT(SRELPR).  THIS QUANTITY
!                  CAN BE NO SMALLER THAN SRELPR, THE ARITHMETIC-
!                  STORAGE PRECISION.  THE QUANTITY SRELPR IS THE
!                  LARGEST POSITIVE NUMBER SUCH THAT T=1.+SRELPR
!                  SATISFIES T.EQ.1.  THE QUANTITY USED
!                  HERE IS INTERNALLY RESTRICTED TO BE AT
!                  LEAST SRELPR.  THE DATA SET FOR THIS OPTION
!                  IS THE NEW TOLERANCE.
!
!                  KEY=5
!                         CHANGE THE RANK DETERMINATION TOLERANCE FOR
!                  THE REDUCED LEAST SQUARES EQUATIONS FROM
!                  THE NOMINAL VALUE OF SQRT(SRELPR).  THIS QUANTITY
!                  CAN BE NO SMALLER THAN SRELPR, THE ARITHMETIC-
!                  STORAGE PRECISION.  THE QUANTITY USED
!                  HERE IS INTERNALLY RESTRICTED TO BE AT
!                  LEAST SRELPR.  THE DATA SET FOR THIS OPTION
!                  IS THE NEW TOLERANCE.
!
!                  FOR EXAMPLE, SUPPOSE WE WANT TO CHANGE
!                  THE TOLERANCE FOR THE REDUCED LEAST SQUARES
!                  PROBLEM, COMPUTE THE COVARIANCE MATRIX OF
!                  THE SOLUTION PARAMETERS, AND PROVIDE
!                  COLUMN SCALING FOR THE DATA MATRIX.  FOR
!                  THESE OPTIONS THE DIMENSION OF PRGOPT(*)
!                  MUST BE AT LEAST N+9.  THE FORTRAN STATEMENTS
!                  DEFINING THESE OPTIONS WOULD BE AS FOLLOWS.
!
!                  PRGOPT(1)=4 (LINK TO ENTRY 4 IN PRGOPT(*))
!                  PRGOPT(2)=1 (COVARIANCE MATRIX KEY)
!                  PRGOPT(3)=1 (COVARIANCE MATRIX WANTED)
!
!                  PRGOPT(4)=7 (LINK TO ENTRY 7 IN PRGOPT(*))
!                  PRGOPT(5)=5 (LEAST SQUARES EQUAS. TOLERANCE KEY)
!                  PRGOPT(6)=... (NEW VALUE OF THE TOLERANCE)
!
!                  PRGOPT(7)=N+9 (LINK TO ENTRY N+9 IN PRGOPT(*))
!                  PRGOPT(8)=3 (USER-PROVIDED COLUMN SCALING KEY)
!
!                  CALL SCOPY(N,D,1,PRGOPT(9),1)  (COPY THE N
!                    SCALING FACTORS FROM THE USER ARRAY D(*)
!                    TO PRGOPT(9)-PRGOPT(N+8))
!
!                  PRGOPT(N+9)=1 (NO MORE OPTIONS TO CHANGE)
!
!                  THE CONTENTS OF PRGOPT(*) ARE NOT MODIFIED
!                  BY THE SUBPROGRAM.
!                  THE KEY 8 AND 9 OPTIONS FOR WNNLS( ) CAN ALSO
!                  BE INCLUDED IN THIS ARRAY.  THEIR FUNCTIONS
!                  ARE DOCUMENTED IN THE USAGE INSTRUCTIONS FOR
!                  SUBPROGRAM WNNLS( ).
!
!     OUTPUT..
!
!     X(*),RNORME,  THE ARRAY X(*) CONTAINS THE SOLUTION PARAMETERS
!     RNORML        IF THE INTEGER OUTPUT FLAG MODE = 0 OR 1.
!                   THE DEFINITION OF MODE IS GIVEN DIRECTLY BELOW.
!                   WHEN MODE = 0 OR 1, RNORME AND RNORML
!                   RESPECTIVELY CONTAIN THE RESIDUAL VECTOR
!                   EUCLIDEAN LENGTHS OF F - EX AND B - AX.  WHEN
!                   MODE=1 THE EQUALITY CONSTRAINT EQUATIONS EX=F
!                   ARE CONTRADICTORY, SO RNORME.NE.0. THE RESIDUAL
!                   VECTOR F-EX HAS MINIMAL EUCLIDEAN LENGTH. FOR
!                   MODE.GE.2, NONE OF THESE PARAMETERS ARE
!                   DEFINED.
!
!     MODE          INTEGER FLAG THAT INDICATES THE SUBPROGRAM
!                   STATUS AFTER COMPLETION.  IF MODE.GE.2, NO
!                   SOLUTION HAS BEEN COMPUTED.
!
!                   MODE =
!
!                   0  BOTH EQUALITY AND INEQUALITY CONSTRAINTS
!                      ARE COMPATIBLE AND HAVE BEEN SATISFIED.
!
!                   1  EQUALITY CONSTRAINTS ARE CONTRADICTORY.
!                      A GENERALIZED INVERSE SOLUTION OF EX=F WAS USED
!                      TO MINIMIZE THE RESIDUAL VECTOR LENGTH F-EX.
!                      IN THIS SENSE, THE SOLUTION IS STILL MEANINGFUL.
!
!                   2  NO SOLUTION COULD BE OBTAINED. THE CONSTRAINTS
!                      ARE CONTRADICTORY.
!
!                   4  USAGE ERROR OCCURRED.  THE VALUE
!                      OF MDW IS .LT. ME+MA+MG, MDW IS
!                      .LT. N AND A COVARIANCE MATRIX IS
!                      REQUESTED, OR THE OPTION VECTOR
!                      PRGOPT(*) IS NOT PROPERLY DEFINED.
!
!     W(*,*)        THE ARRAY W(*,*) CONTAINS THE N BY N SYMMETRIC
!                   COVARIANCE MATRIX OF THE SOLUTION PARAMETERS,
!                   PROVIDED THIS WAS REQUESTED ON INPUT WITH
!                   THE OPTION VECTOR PRGOPT(*) AND THE OUTPUT
!                   FLAG IS RETURNED WITH MODE = 0 OR 1.
!
!     IP(*)         THE INTEGER WORKING ARRAY HAS THREE ENTRIES
!                   THAT PROVIDE RANK AND WORKING ARRAY LENGTH
!                   INFORMATION AFTER COMPLETION.
!
!                      IP(1) = RANK OF EQUALITY CONSTRAINT
!                              MATRIX.  DEFINE THIS QUANTITY
!                              AS KRANKE.
!
!                      IP(2) = RANK OF REDUCED LEAST SQUARES
!                              PROBLEM.
!
!                      IP(3) = THE AMOUNT OF STORAGE IN THE
!                              WORKING ARRAY WS(*) THAT WAS
!                              ACTUALLY USED BY THE SUBPROGRAM.
!                              THE FORMULA GIVEN ABOVE FOR THE LENGTH
!                              OF WS(*) IS A NECESSARY OVERESTIMATE.
!     USER DESIGNATED
!     WORKING ARRAYS..
!
!     WS(*),IP(*)              THESE ARE RESPECTIVELY TYPE REAL
!                              AND TYPE INTEGER WORKING ARRAYS.
!                              THEIR REQUIRED MINIMAL LENGTHS ARE
!                              GIVEN ABOVE.
!
!
!     SUBROUTINES CALLED
!
!     LSI           PART OF THIS PACKAGE.  SOLVES A
!                   CONSTRAINED LEAST SQUARES PROBLEM WITH
!                   INEQUALITY CONSTRAINTS.
!
!     SDOT,SSCAL,   SUBROUTINES FROM THE BLAS PACKAGE.
!     SAXPY,SASUM,  SEE TRANS. MATH SOFTWARE (5), P. 308.
!     SCOPY,SNRM2,
!     SSWAP,ISAMAX
!
!     H12           SUBROUTINE TO CONSTRUCT AND APPLY A
!                   HOUSEHOLDER TRANSFORMATION.
!
!     SPMPAR        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!                   PRECISION.
!
!     REVISED OCT. 1, 1989.
!
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(*), ws(*)
integer, intent(inout) :: ip(*)
logical :: cov
data zero /0.e0/, one /1.e0/, half /0.5e0/
!
!     COMPUTE MACHINE PRECISION
!
srelpr = spmpar(1)
!
!     COMPUTE NUMBER OF POSSIBLE RIGHT MULTIPLYING HOUSEHOLDER
!     TRANSFORMATIONS.
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
!     PROCESS-OPTION-VECTOR
!
go to 480
90 if (.not.(cov .and. mdw.lt.n)) go to 100
mode = 4
return
100 l = kranke
!
!     COMPUTE NORM OF EQUALITY CONSTRAINT MATRIX AND RT SIDE.
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
!     COMPUTE MAXIMUM RATIO OF VECTOR LENGTHS. PARTITION
!     IS AT COL. I.
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
!     INTERCHANGE ROWS IF NECESSARY.
  if (i.ne.imax) call sswap(np1, w(i,1), mdw, w(imax,1), mdw)
  if (.not.(snmax.gt.tau**2*rnmax)) go to 160
!
!     ELIMINATE ELEMS I+1,...,N IN ROW I.
  call h12(1, i, i+1, n, w(i,1), mdw, ws(i), w(i+1,1), mdw, 1, &
&m-i)
  go to 180
160 kranke = i - 1
  go to 200
180 continue
!
!     SAVE DIAG. TERMS OF LOWER TRAP. MATRIX.
!
200 call scopy(kranke, w, mdw+1, ws(kranke+1), 1)
!
!     USE HOUSEHOLDER TRANS FROM LEFT TO ACHIEVE KRANKE BY KRANKE UPPER
!     TRIANGULAR FORM.
!
if (.not.(kranke.gt.0 .and. kranke.lt.me)) go to 220
do kk = 1,kranke
  k = kranke + 1 - kk
!
!     APPLY TRANFORMATION TO MATRIX COLS. 1,...,K-1.
  call h12(1, k, kranke+1, me, w(1,k), 1, up, w, 1, mdw, k-1)
!
!     APPLY TO RT SIDE VECTOR.
  call h12(2, k, kranke+1, me, w(1,k), 1, up, w(1,np1), 1, 1, 1)
end do
220 if (.not.(kranke.gt.0)) go to 240
!
!     SOLVE FOR VARIABLES 1,...,KRANKE IN NEW COORDINATES.
call scopy(kranke, w(1,np1), 1, x, 1)
do i=1,kranke
  x(i) = (x(i)-sdot(i-1,w(i,1),mdw,x,1))/w(i,i)
end do
!
!     COMPUTE RESIDUALS FOR REDUCED PROBLEM.
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
!     COMPUTE EQUAL. CONSTRAINT EQUAS. RESIDUAL LENGTH.
270 rnorme = snrm2(me-kranke,w(kranke+1,np1),1)
!
!     MOVE REDUCED PROBLEM DATA UPWARD IF KRANKE.LT.ME.
!
if (.not.(kranke.lt.me)) go to 290
do j=1,np1
  call scopy(m-me, w(me+1,j), 1, w(kranke+1,j), 1)
end do
!
!     COMPUTE SOLN OF REDUCED PROBLEM.
!
290 call lsi(w(kranke+1,kranke+1), mdw, ma, mg, n-kranke, prgopt, &
&x(kranke+1), rnorml, mode, ws(n2), ip(2))
if (mode .gt. 1) go to 470
if (.not.(me.gt.0)) go to 330
!
!     TEST FOR CONSISTENCY OF EQUALITY CONSTRAINTS.
!
mdeqc = 0
xnrme = sasum(kranke,w(1,np1),1)
if (rnorme.gt.tau*(enorm*xnrme+fnorm)) mdeqc = 1
mode = mode + mdeqc
!
!     CHECK IF SOLN TO EQUAL. CONSTRAINTS SATISFIES INEQUAL.
!     CONSTRAINTS WHEN THERE ARE NO DEGREES OF FREEDOM LEFT.
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
!     REPLACE DIAG. TERMS OF LOWER TRAP. MATRIX.
call scopy(kranke, ws(kranke+1), 1, w, mdw+1)
!
!     REAPPLY TRANS TO PUT SOLN IN ORIGINAL COORDINATES.
!
do ii = 1,kranke
  i = kranke + 1 - ii
  call h12(2, i, i+1, n, w(i,1), mdw, ws(i), x, 1, 1, 1)
end do
!
!     COMPUTE COV MATRIX OF EQUAL. CONSTRAINED PROBLEM.
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
!     APPLY THE SCALING TO THE COVARIANCE MATRIX.
!
420 if (.not.(cov)) go to 450
do i = 1,n
  l = n1 + i
  call sscal(n, ws(l-1), w(i,1), mdw)
  call sscal(n, ws(l-1), w(1,i), 1)
end do
!
!     RESCALE SOLN. VECTOR.
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
!     TO PROCESS-OPTION-VECTOR
!
!     THE NOMINAL TOLERANCE USED IN THE CODE
!     FOR THE EQUALITY CONSTRAINT EQUATIONS.
tau = sqrt(srelpr)
!
!     THE NOMINAL COLUMN SCALING USED IN THE CODE IS
!     THE IDENTITY SCALING.
ws(n1) = one
call scopy(n, ws(n1), 0, ws(n1), 1)
!
!     NO COVARIANCE MATRIX IS NOMINALLY COMPUTED.
cov = .false.
!
!     DEFINE BOUND FOR NUMBER OF OPTIONS TO CHANGE.
nopt = 1000
ntimes = 0
!
!     DEFINE BOUND FOR POSITIVE VALUES OF LINK.
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
!     THIS IS A COMPANION SUBPROGRAM TO LSEI( ).
!     THE DOCUMENTATION FOR LSEI( ) HAS MORE COMPLETE
!     USAGE INSTRUCTIONS.
!     WRITTEN BY R. J. HANSON, SLA.
!
!     SOLVE..
!              AX = B,  A  MA BY N  (LEAST SQUARES EQUATIONS)
!     SUBJECT TO..
!
!              GX.GE.H, G  MG BY N  (INEQUALITY CONSTRAINTS)
!
!     INPUT..
!
!      W(*,*) CONTAINS  (A B) IN ROWS 1,...,MA+MG, COLS 1,...,N+1.
!                       (G H)
!
!     MDW,MA,MG,N
!              CONTAIN (RESP) VAR. DIMENSION OF W(*,*),
!              AND MATRIX DIMENSIONS.
!
!     PRGOPT(*),
!              PROGRAM OPTION VECTOR.
!
!     OUTPUT..
!
!      X(*),RNORM
!
!              SOLUTION VECTOR(UNLESS MODE=2), LENGTH OF AX-B.
!
!      MODE
!              =0   INEQUALITY CONSTRAINTS ARE COMPATIBLE.
!              =2   INEQUALITY CONSTRAINTS CONTRADICTORY.
!
!      WS(*),
!              WORKING STORAGE OF DIMENSION K+N+(MG+2)*(N+7),
!              WHERE K=MAX(MA+MG,N).
!      IP(MG+2*N+1)
!              INTEGER WORKING STORAGE
!
!     SUBROUTINES CALLED
!
!     LPDP          THIS SUBPROGRAM MINIMIZES A SUM OF SQUARES
!                   OF UNKNOWNS SUBJECT TO LINEAR INEQUALITY
!                   CONSTRAINTS.  PART OF THIS PACKAGE.
!
!     SDOT,SSCAL    SUBROUTINES FROM THE BLAS PACKAGE.
!     SAXPY,SASUM,  SEE TRANS. MATH SOFTWARE (5), P. 308.
!     SCOPY,SSWAP
!
!     HFTI          SOLVES AN UNCONSTRAINED LINEAR LEAST SQUARES
!                   PROBLEM.
!
!     H12           SUBROUTINE TO CONSTRUCT AND APPLY A HOUSEHOLDER
!                   TRANSFORMATION.
!
!     SPMPAR        FUNCTION TO COMPUTE THE RELATIVE MACHINE
!                   PRECISION.
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
!     PROCESS-OPTION-VECTOR
!
go to 500
!
!     COMPUTE MATRIX NORM OF LEAST SQUARES EQUAS.
!
40 anorm = zero
do j = 1,n
  anorm = amax1(anorm,sasum(ma,w(1,j),1))
end do
!
!     SET TOL FOR HFTI( ) RANK TEST.
tau = tol*anorm
!
!     COMPUTE HOUSEHOLDER ORTHOGONAL DECOMP OF MATRIX.
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
!     REDUCE-TO-LPDP-AND-SOLVE
!
70 ip(1) = krank
ip(2) = n + max0(m,n) + (mg+2)*(n+7)
return
!
!     TO REDUCE-TO-LPDP-AND-SOLVE
!
80 map1 = ma + 1
!
!     COMPUTE INEQ. RT-HAND SIDE FOR LPDP.
!
if (.not.(ma.lt.m)) go to 260
if (.not.(minman.gt.0)) go to 160
do i = map1,m
  w(i,np1) = w(i,np1) - sdot(n,w(i,1),mdw,ws,1)
end do
do i = 1,minman
  j = ip(i)
!
!     APPLY PERMUTATIONS TO COLS OF INEQ. CONSTRAINT MATRIX.
  call sswap(mg, w(map1,i), 1, w(map1,j), 1)
end do
!
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO CONSTRAINT MATRIX.
!
if (.not.(0.lt.krank .and. krank.lt.n)) go to 120
do ii = 1,krank
  i = krank + 1 - ii
  l = n1 + i
  call h12(2, i, krank+1, n, w(i,1), mdw, ws(l-1), w(map1,1), &
&mdw, 1, mg)
end do
!
!     COMPUTE PERMUTED INEQ. CONSTR. MATRIX TIMES R-INVERSE.
!
120 do 150 i = map1,m
  if (.not.(0.lt.krank)) go to 150
  do j=1,krank
    w(i,j) = (w(i,j)-sdot(j-1,w(1,j),1,w(i,1),mdw))/w(j,j)
  end do
150 continue
!
!     SOLVE THE REDUCED PROBLEM WITH LPDP ALGORITHM,
!     THE LEAST PROJECTED DISTANCE PROBLEM.
!
160 call lpdp(w(map1,1), mdw, mg, krank, n-krank, opt, x, xnorm, &
&mdlpdp, ws(n2), ip(n+1))
if (mdlpdp .ne. 1) go to 240
if (.not.(krank.gt.0)) go to 180
!
!     COMPUTE SOLN IN ORIGINAL COORDINATES.
!
do ii = 1,krank
  i = krank + 1 - ii
  x(i) = (x(i)-sdot(ii-1,w(i,i+1),mdw,x(i+1),1))/w(i,i)
end do
!
!     APPLY HOUSEHOLDER TRANS. TO SOLN VECTOR.
!
180 if (.not.(0.lt.krank .and. krank.lt.n)) go to 200
do i = 1,krank
  l = n1 + i
  call h12(2, i, krank+1, n, w(i,1), mdw, ws(l-1), x, 1, 1, 1)
end do
200 if (.not.(minman.gt.0)) go to 270
!
!     REPERMUTE VARIABLES TO THEIR INPUT ORDER.
do ii=1,minman
  i = minman + 1 - ii
  j = ip(i)
  call sswap(1, x(i), 1, x(j), 1)
end do
!
!     VARIABLES ARE NOW IN ORIG. COORDINATES.
!     ADD SOLN OF UNSCONSTRAINED PROB.
do i = 1,n
  x(i) = x(i) + ws(i)
end do
!
!     COMPUTE THE RESIDUAL VECTOR NORM.
rnorm = sqrt(rnorm**2+xnorm**2)
go to 270
240 mode = 2
go to 270
260 call scopy(n, ws, 1, x, 1)
270 if (.not.(cov .and. krank.gt.0)) go to 70
!
!     COMPUTE COVARIANCE MATRIX BASED ON THE ORTHOGONAL DECOMP.
!     FROM HFTI( ).
!
krm1 = krank - 1
krp1 = krank + 1
!
!     COPY DIAG. TERMS TO WORKING ARRAY.
call scopy(krank, w, mdw+1, ws(n2), 1)
!
!     RECIPROCATE DIAG. TERMS.
do j = 1,krank
  w(j,j) = one/w(j,j)
end do
if (.not.(krank.gt.1)) go to 310
!
!     INVERT THE UPPER TRIANGULAR QR FACTOR ON ITSELF.
do i=1,krm1
  ip1 = i + 1
  do j=ip1,krank
    w(i,j) = -sdot(j-i,w(i,i),mdw,w(i,j),1)*w(j,j)
  end do
end do
!
!     COMPUTE THE INVERTED FACTOR TIMES ITS TRANSPOSE.
310 do i=1,krank
  do j=i,krank
    w(i,j) = sdot(krank+1-j,w(i,j),mdw,w(j,j),mdw)
  end do
end do
if (.not.(krank.lt.n)) go to 450
!
!     ZERO OUT LOWER TRAPEZOIDAL PART.
!     COPY UPPER TRI. TO LOWER TRI. PART.
do j=1,krank
  call scopy(j, w(1,j), 1, w(j,1), mdw)
end do
do i=krp1,n
  w(i,1) = zero
  call scopy(i, w(i,1), 0, w(i,1), mdw)
end do
!
!     APPLY RIGHT SIDE TRANSFORMATIONS TO LOWER TRI.
n3 = n2 + krp1
do i=1,krank
  l = n1 + i
  k = n2 + i
  rb = ws(l-1)*ws(k-1)
  if (.not.(rb.lt.zero)) go to 420
!
!     IF RB.GE.ZERO, TRANSFORMATION CAN BE REGARDED AS ZERO.
  rb = one/rb
!
!     STORE UNSCALED RANK-ONE HOUSEHOLDER UPDATE IN WORK ARRAY.
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
!     COPY LOWER TRI. TO UPPER TRI. TO SYMMETRIZE THE COVARIANCE MATRIX.
!
do i = 1,n
  call scopy(i, w(i,1), mdw, w(1,i), 1)
end do
!
!     REPERMUTE ROWS AND COLS.
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
!     PUT IN NORMALIZED RESIDUAL SUM OF SQUARES SCALE FACTOR
!     AND SYMMETRIZE THE RESULTING COVARIANCE MARIX.
!
do j = 1,n
  call sscal(j, fac, w(1,j), 1)
  call scopy(j, w(1,j), 1, w(j,1), mdw)
end do
go to 70
!
!     TO PROCESS-OPTION-VECTOR
!
!     THE NOMINAL TOLERANCE USED IN THE CODE,
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
!     PREPARE THE OPTION VECTOR FOR WNNLS
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
!     DIMENSION A(MDA,N+1),PRGOPT(*),X(N),WS((M+2)*(N+7)),IS(M+N+1),
!     WHERE N=N1+N2.  THIS IS A SLIGHT OVERESTIMATE FOR WS(*).
!
!     WRITTEN BY R. J. HANSON AND K. H. HASKELL, SANDIA LABS
!
!     DETERMINE AN N1-VECTOR W, AND
!               AN N2-VECTOR Z
!     WHICH MINIMIZES THE EUCLIDEAN LENGTH OF W
!     SUBJECT TO G*W+H*Z .GE. Y.
!     THIS IS THE LEAST PROJECTED DISTANCE PROBLEM, LPDP.
!     THE MATRICES G AND H ARE OF RESPECTIVE
!     DIMENSIONS M BY N1 AND M BY N2.
!
!     CALLED BY SUBPROGRAM LSI( ).
!
!     THE MATRIX
!                (G H Y)
!
!     OCCUPIES ROWS 1,...,M AND COLS 1,...,N1+N2+1 OF A(*,*).
!
!     THE SOLUTION (W) IS RETURNED IN X(*).
!                  (Z)
!
!     THE VALUE OF MODE INDICATES THE STATUS OF
!     THE COMPUTATION AFTER RETURNING TO THE USER.
!
!          MODE=1  THE SOLUTION WAS SUCCESSFULLY OBTAINED.
!
!          MODE=2  THE INEQUALITIES ARE INCONSISTENT.
!
!     SUBROUTINES CALLED
!
!     WNNLS         SOLVES A NONNEGATIVELY CONSTRAINED LINEAR LEAST
!                   SQUARES PROBLEM WITH LINEAR EQUALITY CONSTRAINTS.
!                   PART OF THIS PACKAGE.
!
!     SDOT,SCOPY    SUBROUTINES FROM THE BLAS PACKAGE.
!     SSCAL,SNRM2   SEE TRANS. MATH SOFTWARE (5), P. 308.
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
!     SCALE NONZERO ROWS OF INEQUALITY MATRIX TO HAVE LENGTH ONE.
!
do 40 i = 1,m
   sc = snrm2(n,a(i,1),mda)
   if (sc .eq. zero) go to 40
   sc = one/sc
   call sscal(np1, sc, a(i,1), mda)
40 continue
!
!     SCALE RT.-SIDE VECTOR TO HAVE LENGTH ONE (OR ZERO).
ynorm = snrm2(m,a(1,np1),1)
if (ynorm .eq. zero) go to 50
sc = one/ynorm
call sscal(m, sc, a(1,np1), 1)
!
!     SCALE COLS OF MATRIX H.
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
!     COPY TRANSPOSE OF (H G Y) TO WORK ARRAY WS(*).
iw = 0
do i=1,m
!
!     MOVE COL OF TRANSPOSE OF H INTO WORK ARRAY.
   call scopy(n2, a(i,n1+1), mda, ws(iw+1), 1)
   iw = iw + n2
!
!     MOVE COL OF TRANSPOSE OF G INTO WORK ARRAY.
   call scopy(n1, a(i,1), mda, ws(iw+1), 1)
   iw = iw + n1
!
!     MOVE COMPONENT OF VECTOR Y INTO WORK ARRAY.
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
!     MATRIX E = TRANSPOSE OF (G Y), AND THE (N+1)-VECTOR
!     F = TRANSPOSE OF (0,...,0,1).
ix = iw + 1
iw = iw + m
call wnnls(ws, np1, n2, np1-n2, m, 0, prgopt, ws(ix), rnorm, &
&modew, is, ws(iw+1))
!
!     COMPUTE THE COMPONENTS OF THE SOLN DENOTED ABOVE BY W.
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
!     COPY TRANSPOSE OF (H Q) TO WORK ARRAY WS(*).
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
!     OF (H Q)), WHERE Q=Y-GW.  THE (N2+1)-VECTOR S =(TRANSPOSE
!     OF (0,...,0,1)).
!
call wnnls(ws, n2+1, 0, n2+1, m, 0, prgopt, ws(ix), rnorm, modew, &
&is, ws(iw+1))
!
!     COMPUTE THE COMPONENTS OF THE SOLN DENOTED ABOVE BY Z.
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
!     ACCOUNT FOR SCALING OF RT.-SIDE VECTOR IN SOLUTION.
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
!     DIMENSION W(MDW,N+1),PRGOPT(*),X(N),IWORK(M+N),WORK(M+5*N)
!
!     ABSTRACT
!
!     THIS SUBPROGRAM SOLVES A LINEARLY CONSTRAINED LEAST SQUARES
!     PROBLEM.  SUPPOSE THERE ARE GIVEN MATRICES E AND A OF
!     RESPECTIVE DIMENSIONS ME BY N AND MA BY N, AND VECTORS F
!     AND B OF RESPECTIVE LENGTHS ME AND MA.  THIS SUBROUTINE
!     SOLVES THE PROBLEM
!
!               EX = F, (EQUATIONS TO BE EXACTLY SATISFIED)
!
!               AX = B, (EQUATIONS TO BE APPROXIMATELY SATISFIED,
!                        IN THE LEAST SQUARES SENSE)
!
!               SUBJECT TO COMPONENTS L+1,...,N NONNEGATIVE
!
!     ANY VALUES ME.GE.0, MA.GE.0 AND 0.LE. L .LE.N ARE PERMITTED.
!
!     THE PROBLEM IS REPOSED AS PROBLEM WNNLS
!
!               (WT*E)X = (WT*F)
!               (   A)    (   B), (LEAST SQUARES)
!               SUBJECT TO COMPONENTS L+1,...,N NONNEGATIVE.
!
!     THE SUBPROGRAM CHOOSES THE HEAVY WEIGHT (OR PENALTY PARAMETER) WT.
!
!     THE PARAMETERS FOR WNNLS ARE
!
!     INPUT..
!
!     W(*,*),MDW,  THE ARRAY W(*,*) IS DOUBLE SUBSCRIPTED WITH FIRST
!     ME,MA,N,L    DIMENSIONING PARAMETER EQUAL TO MDW.  FOR THIS
!                  DISCUSSION LET US CALL M = ME + MA.  THEN MDW
!                  MUST SATISFY MDW.GE.M.  THE CONDITION MDW.LT.M
!                  IS AN ERROR.
!
!                  THE ARRAY W(*,*) CONTAINS THE MATRICES AND VECTORS
!
!                       (E  F)
!                       (A  B)
!
!                  IN ROWS AND COLUMNS 1,...,M AND 1,...,N+1
!                  RESPECTIVELY.  COLUMNS 1,...,L CORRESPOND TO
!                  UNCONSTRAINED VARIABLES X(1),...,X(L).  THE
!                  REMAINING VARIABLES ARE CONSTRAINED TO BE
!                  NONNEGATIVE.  THE CONDITION L.LT.0 .OR. L.GT.N IS
!                  AN ERROR.
!
!     PRGOPT(*)    THIS ARRAY IS THE OPTION VECTOR.
!                  IF THE USER IS SATISFIED WITH THE NOMINAL
!                  SUBPROGRAM FEATURES SET
!
!                  PRGOPT(1)=1 (OR PRGOPT(1)=1.0)
!
!                  OTHERWISE PRGOPT(*) IS A LINKED LIST CONSISTING OF
!                  GROUPS OF DATA OF THE FOLLOWING FORM
!
!                  LINK
!                  KEY
!                  DATA SET
!
!                  THE PARAMETERS LINK AND KEY ARE EACH ONE WORD.
!                  THE DATA SET CAN BE COMPRISED OF SEVERAL WORDS.
!                  THE NUMBER OF ITEMS DEPENDS ON THE VALUE OF KEY.
!                  THE VALUE OF LINK POINTS TO THE FIRST
!                  ENTRY OF THE NEXT GROUP OF DATA WITHIN
!                  PRGOPT(*).  THE EXCEPTION IS WHEN THERE ARE
!                  NO MORE OPTIONS TO CHANGE.  IN THAT
!                  CASE LINK=1 AND THE VALUES KEY AND DATA SET
!                  ARE NOT REFERENCED. THE GENERAL LAYOUT OF
!                  PRGOPT(*) IS AS FOLLOWS.
!
!               ...PRGOPT(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
!               .  PRGOPT(2)=KEY1 (KEY TO THE OPTION CHANGE)
!               .  PRGOPT(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
!               .       .
!               .       .
!               .       .
!               ...PRGOPT(LINK1)=LINK2 (LINK TO THE FIRST ENTRY OF
!               .                       NEXT GROUP)
!               .  PRGOPT(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
!               .  PRGOPT(LINK1+2)=DATA VALUE
!               ...     .
!               .       .
!               .       .
!               ...PRGOPT(LINK)=1 (NO MORE OPTIONS TO CHANGE)
!
!                  VALUES OF LINK THAT ARE NONPOSITIVE ARE ERRORS.
!                  A VALUE OF LINK.GT.NLINK=100000 IS ALSO AN ERROR.
!                  THIS HELPS PREVENT USING INVALID BUT POSITIVE
!                  VALUES OF LINK THAT WILL PROBABLY EXTEND
!                  BEYOND THE PROGRAM LIMITS OF PRGOPT(*).
!                  UNRECOGNIZED VALUES OF KEY ARE IGNORED.  THE
!                  ORDER OF THE OPTIONS IS ARBITRARY AND ANY NUMBER
!                  OF OPTIONS CAN BE CHANGED WITH THE FOLLOWING
!                  RESTRICTION.  TO PREVENT CYCLING IN THE
!                  PROCESSING OF THE OPTION ARRAY A COUNT OF THE
!                  NUMBER OF OPTIONS CHANGED IS MAINTAINED.
!                  WHENEVER THIS COUNT EXCEEDS NOPT=1000 THE
!                  ROUTINE TERMINATES.
!
!                  OPTIONS..
!
!                  KEY=6
!                         SCALE THE NONZERO COLUMNS OF THE
!                  ENTIRE DATA MATRIX
!                  (E)
!                  (A)
!                  TO HAVE LENGTH ONE.  THE DATA SET FOR
!                  THIS OPTION IS A SINGLE VALUE.  IT MUST
!                  BE NONZERO IF UNIT LENGTH COLUMN SCALING IS
!                  DESIRED.
!
!                  KEY=7
!                         SCALE COLUMNS OF THE ENTIRE DATA MATRIX
!                  (E)
!                  (A)
!                  WITH A USER-PROVIDED DIAGONAL MATRIX.
!                  THE DATA SET FOR THIS OPTION CONSISTS
!                  OF THE N DIAGONAL SCALING FACTORS, ONE FOR
!                  EACH MATRIX COLUMN.
!
!                  KEY=8
!                         CHANGE THE RANK DETERMINATION TOLERANCE FROM
!                  THE NOMINAL VALUE OF SQRT(EPS).  THIS QUANTITY CAN
!                  BE NO SMALLER THAN EPS, THE ARITHMETIC-
!                  STORAGE PRECISION.  THE QUANTITY USED
!                  HERE IS INTERNALLY RESTRICTED TO BE AT
!                  LEAST EPS.  THE DATA SET FOR THIS OPTION
!                  IS THE NEW TOLERANCE.
!
!                  KEY=9
!                         CHANGE THE BLOW-UP PARAMETER FROM THE
!                  NOMINAL VALUE OF SQRT(EPS).  THE RECIPROCAL OF
!                  THIS PARAMETER IS USED IN REJECTING SOLUTION
!                  COMPONENTS AS TOO LARGE WHEN A VARIABLE IS
!                  FIRST BROUGHT INTO THE ACTIVE SET.  TOO LARGE
!                  MEANS THAT THE PROPOSED COMPONENT TIMES THE
!                  RECIPROCAL OF THE PARAMETERIS NOT LESS THAN
!                  THE RATIO OF THE NORMS OF THE RIGHT-SIDE
!                  VECTOR AND THE DATA MATRIX.
!                  THIS PARAMETER CAN BE NO SMALLER THAN EPS,
!                  THE ARITHMETIC-STORAGE PRECISION.
!
!                  FOR EXAMPLE, SUPPOSE WE WANT TO PROVIDE
!                  A DIAGONAL MATRIX TO SCALE THE PROBLEM
!                  MATRIX AND CHANGE THE TOLERANCE USED FOR
!                  DETERMINING LINEAR DEPENDENCE OF DROPPED COL
!                  VECTORS.  FOR THESE OPTIONS THE DIMENSIONS OF
!                  PRGOPT(*) MUST BE AT LEAST N+6.  THE FORTRAN
!                  STATEMENTS DEFINING THESE OPTIONS WOULD
!                  BE AS FOLLOWS.
!
!                  PRGOPT(1)=N+3 (LINK TO ENTRY N+3 IN PRGOPT(*))
!                  PRGOPT(2)=7 (USER-PROVIDED SCALING KEY)
!
!                  CALL SCOPY(N,D,1,PRGOPT(3),1) (COPY THE N
!                  SCALING FACTORS FROM A USER ARRAY CALLED D(*)
!                  INTO PRGOPT(3)-PRGOPT(N+2))
!
!                  PRGOPT(N+3)=N+6 (LINK TO ENTRY N+6 OF PRGOPT(*))
!                  PRGOPT(N+4)=8 (LINEAR DEPENDENCE TOLERANCE KEY)
!                  PRGOPT(N+5)=... (NEW VALUE OF THE TOLERANCE)
!
!                  PRGOPT(N+6)=1 (NO MORE OPTIONS TO CHANGE)
!
!     OUTPUT..
!
!     X(*)         AN ARRAY DIMENSIONED AT LEAST N, WHICH WILL
!                  CONTAIN THE N COMPONENTS OF THE SOLUTION VECTOR
!                  ON OUTPUT.
!
!     RNORM        THE RESIDUAL NORM OF THE SOLUTION.  THE VALUE OF
!                  RNORM CONTAINS THE RESIDUAL VECTOR LENGTH OF THE
!                  EQUALITY CONSTRAINTS AND LEAST SQUARES EQUATIONS.
!
!     MODE         THE VALUE OF MODE INDICATES THE SUCCESS OR FAILURE
!                  OF THE SUBPROGRAM.
!
!                  MODE = 0  SUBPROGRAM COMPLETED SUCCESSFULLY.
!
!                       = 1  MAX. NUMBER OF ITERATIONS (EQUAL TO
!                            3*(N-L)) EXCEEDED. NEARLY ALL PROBLEMS
!                            SHOULD COMPLETE IN FEWER THAN THIS
!                            NUMBER OF ITERATIONS. AN APPROXIMATE
!                            SOLUTION AND ITS CORRESPONDING RESIDUAL
!                            VECTOR LENGTH ARE IN X(*) AND RNORM.
!
!                       = 2  USAGE ERROR OCCURRED.  EITHER
!                            MDW .LT. ME + MA, L .LT. 0, L .GT. N,
!                            OR THE OPTION VECTOR PRGOPT(*) IS
!                            NOT PROPERLY DEFINED.
!
!     USER-DESIGNATED
!     WORKING ARRAYS..
!
!     WORK(*)      A WORKING ARRAY OF LENGTH AT LEAST
!                  M + 5*N.
!
!     IWORK(*)     AN INTEGER-VALUED WORKING ARRAY OF LENGTH AT LEAST
!                  M+N.
!
!     WRITTEN BY KAREN H. HASKELL, SANDIA LABORATORIES,
!     AND R.J. HANSON, SANDIA LABORATORIES.
!     REVISED OCT. 1, 1989.
!
!
!     SUBROUTINES CALLED BY WNNLS( )
!
!     WNLSM         COMPANION SUBROUTINE TO WNNLS( ), WHERE
!                   MOST OF THE COMPUTATION TAKES PLACE.
!
!
!     REFERENCES
!
!     1. SOLVING LEAST SQUARES PROBLEMS, BY C.L. LAWSON
!        AND R.J. HANSON.  PRENTICE-HALL, INC. (1974).
!
!     2. BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE, BY
!        C.L. LAWSON, R.J. HANSON, D.R. KINCAID, AND F.T. KROGH.
!        TOMS, V. 5, NO. 3, P. 308.  ALSO AVAILABLE AS
!        SANDIA TECHNICAL REPORT NO. SAND77-0898.
!
!     3. AN ALGORITHM FOR LINEAR LEAST SQUARES WITH EQUALITY
!        AND NONNEGATIVITY CONSTRAINTS, BY K.H. HASKELL AND
!        R.J. HANSON.  AVAILABLE AS SANDIA TECHNICAL REPORT NO.
!        SAND77-0552, AND MATH. PROGRAMMING, VOL. 21, (1981), P. 98-118.
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
!     THE PURPOSE OF THIS SUBROUTINE IS TO BREAK UP THE ARRAYS
!     WORK(*) AND IWORK(*) INTO SEPARATE WORK ARRAYS
!     REQUIRED BY THE MAIN SUBROUTINE WNLSM( ).
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
!     THIS IS A COMPANION SUBPROGRAM TO WNNLS( ).
!     THE DOCUMENTATION FOR WNNLS( ) HAS MORE COMPLETE
!     USAGE INSTRUCTIONS.
!
!     WRITTEN BY KAREN H. HASKELL, SANDIA LABORATORIES,
!     WITH THE HELP OF R.J. HANSON, SANDIA LABORATORIES.
!
!     IN ADDITION TO THE PARAMETERS DISCUSSED IN THE PROLOGUE TO
!     SUBROUTINE WNNLS, THE FOLLOWING WORK ARRAYS ARE USED IN
!     SUBROUTINE WNLSM  (THEY ARE PASSED THROUGH THE CALLING
!     SEQUENCE FROM WNNLS FOR PURPOSES OF VARIABLE DIMENSIONING).
!     THEIR CONTENTS WILL IN GENERAL BE OF NO INTEREST TO THE USER.
!
!         IPIVOT(*)
!            AN ARRAY OF LENGTH N.  UPON COMPLETION IT CONTAINS THE
!         PIVOTING INFORMATION FOR THE COLS OF W(*,*).
!
!         ITYPE(*)
!            AN ARRAY OF LENGTH M WHICH IS USED TO KEEP TRACK
!         OF THE CLASSIFICATION OF THE EQUATIONS.  ITYPE(I)=0
!         DENOTES EQUATION I AS AN EQUALITY CONSTRAINT.
!         ITYPE(I)=1 DENOTES EQUATION I AS A LEAST SQUARES
!         EQUATION.
!
!         WD(*)
!            AN ARRAY OF LENGTH N.  UPON COMPLETION IT CONTAINS THE
!         DUAL SOLUTION VECTOR.
!
!         H(*)
!            AN ARRAY OF LENGTH N.  UPON COMPLETION IT CONTAINS THE
!         PIVOT SCALARS OF THE HOUSEHOLDER TRANSFORMATIONS PERFORMED
!         IN THE CASE KRANK.LT.L.
!
!         SCALE(*)
!            AN ARRAY OF LENGTH M WHICH IS USED BY THE SUBROUTINE
!         TO STORE THE DIAGONAL MATRIX OF WEIGHTS.
!         THESE ARE USED TO APPLY THE MODIFIED GIVENS
!         TRANSFORMATIONS.
!
!         Z(*),TEMP(*)
!            WORKING ARRAYS OF LENGTH N.
!
!         D(*)
!            AN ARRAY OF LENGTH N THAT CONTAINS THE
!         COLUMN SCALING FOR THE MATRIX (E).
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
!     INITIALIZE-VARIABLES
!
go to 180
!
!     PERFORM INITIAL TRIANGULARIZATION IN THE SUBMATRIX
!     CORRESPONDING TO THE UNCONSTRAINED VARIABLES USING
!     THE PROCEDURE INITIALLY-TRIANGULARIZE.
!
10 go to 280
!
!     PERFORM WNNLS ALGORITHM USING THE FOLLOWING STEPS.
!
!     UNTIL(DONE)
!
!        COMPUTE-SEARCH-DIRECTION-AND-FEASIBLE-POINT
!
!        WHEN (HITCON) ADD-CONSTRAINTS
!
!        ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
!
!        FIN
!
!     COMPUTE-FINAL-SOLUTION
!
20 if (done) go to 80
go to 300
!
!     COMPUTE-SEARCH-DIRECTION-AND-FEASIBLE-POINT
!
30 if (.not.(hitcon)) go to 50
go to 370
!
!     WHEN (HITCON) ADD-CONSTRAINTS
!
50 go to 640
!
!     ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
!
80 go to 1000
!
!     COMPUTE-FINAL-SOLUTION
!
100 continue
!
!     TO PROCESS-OPTION-VECTOR
fac = 1.e-4
!
!     THE NOMINAL TOLERANCE USED IN THE CODE,
tau = sqrt(srelpr)
!
!     THE NOMINAL BLOW-UP FACTOR USED IN THE CODE.
blowup = tau
!
!     THE NOMINAL COLUMN SCALING USED IN THE CODE IS
!     THE IDENTITY SCALING.
d(1) = one
call scopy(n, d, 0, d, 1)
!
!     DEFINE BOUND FOR NUMBER OF OPTIONS TO CHANGE.
nopt = 1000
!
!     DEFINE BOUND FOR POSITIVE VALUE OF LINK.
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
!     TO INITIALIZE-VARIABLES
!
!     SRELPR IS THE PRECISION FOR THE MACHINE BEING USED.
!
180 srelpr = spmpar(1)
!
m = ma + mme
me = mme
mep1 = me + 1
go to 100
!
!     PROCESS-OPTION-VECTOR
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
!     COMPUTE SCALE FACTOR TO APPLY TO EQUAL. CONSTRAINT EQUAS.
do 230 j = 1,n
  wd(j) = sasum(m,w(1,j),1)
230 continue
imax = isamax(n,wd,1)
eanorm = wd(imax)
bnorm = sasum(m,w(1,np1),1)
alamda = eanorm/(srelpr*fac)
!
!     DEFINE SCALING DIAG MATRIX FOR MOD GIVENS USAGE AND
!     CLASSIFY EQUATION TYPES.
alsq = alamda**2
do 260 i = 1,m
!
!     WHEN EQU I IS HEAVILY WEIGHTED ITYPE(I)=0, ELSE ITYPE(I)=1.
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
!     SET THE SOLN VECTOR X(*) TO ZERO AND THE COL INTERCHANGE
!     MATRIX TO THE IDENTITY.
x(1) = zero
call scopy(n, x, 0, x, 1)
do 270 i = 1,n
  ipivot(i) = i
270 continue
go to 10
280 continue
!
!     TO INITIALLY-TRIANGULARIZE
!
!     SET FIRST L COMPS. OF DUAL VECTOR TO ZERO BECAUSE
!     THESE CORRESPOND TO THE UNCONSTRAINED VARIABLES.
if (.not.(l.gt.0)) go to 290
wd(1) = zero
call scopy(l, wd, 0, wd, 1)
!
!     THE ARRAYS IDOPE(*) AND DOPE(*) ARE USED TO PASS
!     INFORMATION TO WNLIT().  THIS WAS DONE TO AVOID
!     A LONG CALLING SEQUENCE OR THE USE OF COMMON.
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
!     TO COMPUTE-SEARCH-DIRECTION-AND-FEASIBLE-POINT
!
!     SOLVE THE TRIANGULAR SYSTEM OF CURRENTLY NON-ACTIVE
!     VARIABLES AND STORE THE SOLUTION IN Z(*).
!
!     SOLVE-SYSTEM
assign 310 to igo958
go to 1110
!
!     INCREMENT ITERATION COUNTER AND CHECK AGAINST MAX. NUMBER
!     OF ITERATIONS.
310 iter = iter + 1
if (.not.(iter.gt.itmax)) go to 320
mode = 1
done = .true.
!
!     CHECK TO SEE IF ANY CONSTRAINTS HAVE BECOME ACTIVE.
!     IF SO, CALCULATE AN INTERPOLATION FACTOR SO THAT ALL
!     ACTIVE CONSTRAINTS ARE REMOVED FROM THE BASIS.
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
!     TO ADD-CONSTRAINTS
!
!     USE COMPUTED ALPHA TO INTERPOLATE BETWEEN LAST
!     FEASIBLE SOLUTION X(*) AND CURRENT UNCONSTRAINED
!     (AND INFEASIBLE) SOLUTION Z(*).
if (.not.(lp1.le.nsoln)) go to 390
do 380 j = lp1,nsoln
  x(j) = x(j) + alpha*(z(j)-x(j))
380 continue
390 feasbl = .false.
go to 410
400 if (feasbl) go to 20
!
!     REMOVE COL JCON AND SHIFT COLS JCON+1 THROUGH N TO THE
!     LEFT. SWAP COL JCON INTO THE N-TH POSITION.  THIS ACHIEVES
!     UPPER HESSENBERG FORM FOR THE NONACTIVE CONSTRAINTS AND
!     LEAVES AN UPPER HESSENBERG MATRIX TO RETRIANGULARIZE.
410 do 420 i = 1,m
  t = w(i,jcon)
  call scopy(n-jcon, w(i,jcon+1), mdw, w(i,jcon), mdw)
  w(i,n) = t
420 continue
!
!     UPDATE PERMUTED INDEX VECTOR TO REFLECT THIS SHIFT AND SWAP.
itemp = ipivot(jcon)
if (.not.(jcon.lt.n)) go to 440
do 430 i = jcon,nm1
  ipivot(i) = ipivot(i+1)
430 continue
440 ipivot(n) = itemp
!
!     SIMILARLY REPERMUTE X(*) VECTOR.
call scopy(n-jcon, x(jcon+1), 1, x(jcon), 1)
x(n) = zero
nsp1 = nsoln
nsoln = nsoln - 1
niv1 = niv
niv = niv - 1
!
!     RETRIANGULARIZE UPPER HESSENBERG MATRIX AFTER ADDING CONSTRAINTS.
j = jcon
i = krank + jcon - l
450 if (.not.(j.le.nsoln)) go to 570
if (.not.(itype(i).eq.0 .and. itype(i+1).eq.0)) go to 470
assign 460 to igo938
go to 620
!
!     (ITYPE(I).EQ.0 .AND. ITYPE(I+1).EQ.0) ZERO-IP1-TO-I-IN-COL-J
460 go to 560
470 if (.not.(itype(i).eq.1 .and. itype(i+1).eq.1)) go to 490
assign 480 to igo938
go to 620
!
!     (ITYPE(I).EQ.1 .AND. ITYPE(I+1).EQ.1) ZERO-IP1-TO-I-IN-COL-J
480 go to 560
490 if (.not.(itype(i).eq.1 .and. itype(i+1).eq.0)) go to 510
call sswap(np1, w(i,1), mdw, w(i+1,1), mdw)
call sswap(1, scale(i), 1, scale(i+1), 1)
itemp = itype(i+1)
itype(i+1) = itype(i)
itype(i) = itemp
!
!     SWAPPED ROW WAS FORMERLY A PIVOT ELT., SO IT WILL
!     BE LARGE ENOUGH TO PERFORM ELIM.
assign 500 to igo938
go to 620
!
!     ZERO-IP1-TO-I-IN-COL-J
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
!     SEE IF THE REMAINING COEFFS IN THE SOLN SET ARE FEASIBLE.  THEY
!     SHOULD BE BECAUSE OF THE WAY ALPHA WAS DETERMINED.  IF ANY ARE
!     INFEASIBLE IT IS DUE TO ROUNDOFF ERROR.  ANY THAT ARE NON-
!     POSITIVE WILL BE SET TO ZERO AND REMOVED FROM THE SOLN SET.
570 if (.not.(lp1.le.nsoln)) go to 590
do 580 jcon = lp1,nsoln
  if (x(jcon).le.zero) go to 600
580 continue
590 feasbl = .true.
600 continue
go to 400
620 continue
!
!     TO ZERO-IP1-TO-I-IN-COL-J
if (.not.(w(i+1,j).ne.zero)) go to 630
call srotmg(scale(i), scale(i+1), w(i,j), w(i+1,j), sparam)
w(i+1,j) = zero
call srotm(np1-j, w(i,j+1), mdw, w(i+1,j+1), mdw, sparam)
630 go to 1290
!
!     TO PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
!
640 call scopy(nsoln, z, 1, x, 1)
if (.not.(nsoln.lt.n)) go to 650
x(nsp1) = zero
call scopy(n-nsoln, x(nsp1), 0, x(nsp1), 1)
650 i = niv1
660 if (.not.(i.le.me)) go to 690
!
!     RECLASSIFY LEAST SQUARES EQATIONS AS EQUALITIES AS
!     NECESSARY.
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
!     FORM INNER PRODUCT VECTOR WD(*) OF DUAL COEFFS.
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
!     FIND J SUCH THAT WD(J)=WMAX IS MAXIMUM.  THIS DETERMINES
!     THAT THE INCOMING COL J WILL REDUCE THE RESIDUAL VECTOR
!     AND BE POSITIVE.
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
!     SET DUAL COEFF TO ZERO FOR INCOMING COL.
790 wd(iwmax) = zero
!
!     WMAX .GT. ZERO, SO OKAY TO MOVE COL IWMAX TO SOLN SET.
!     PERFORM TRANSFORMATION TO RETRIANGULARIZE, AND TEST
!     FOR NEAR LINEAR DEPENDENCE.
!     SWAP COL IWMAX INTO NSOLN-TH POSITION TO MAINTAIN UPPER
!     HESSENBERG FORM OF ADJACENT COLS, AND ADD NEW COL TO
!     TRIANGULAR DECOMPOSITION.
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
!     REDUCE COL NSOLN SO THAT THE MATRIX OF NONACTIVE
!     CONSTRAINTS VARIABLES IS TRIANGULAR.
800 j = m
810 if (.not.(j.gt.niv)) go to 870
jm1 = j - 1
jp = jm1
!
!     WHEN OPERATING NEAR THE ME LINE, TEST TO SEE IF THE PIVOT ELT.
!     IS NEAR ZERO.  IF SO, USE THE LARGEST ELT. ABOVE IT AS THE PIVOT.
!     THIS IS TO MAINTAIN THE SHARP INTERFACE BETWEEN WEIGHTED AND
!     NON-WEIGHTED ROWS IN ALL CASES.
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
!     SOLVE FOR Z(NSOLN)=PROPOSED NEW VALUE FOR X(NSOLN).
!     TEST IF THIS IS NONPOSITIVE OR TOO LARGE.
!     IF THIS WAS TRUE OR IF THE PIVOT TERM WAS ZERO REJECT
!     THE COL AS DEPENDENT.
870 if (.not.(w(niv,nsoln).ne.zero)) go to 890
isol = niv
assign 880 to igo897
go to 980
!
!     TEST-PROPOSED-NEW-COMPONENT
880 go to 940
890 if (.not.(niv.le.me .and. w(mep1,nsoln).ne.zero)) go to 920
!
!     TRY TO ADD ROW MEP1 AS AN ADDITIONAL EQUALITY CONSTRAINT.
!     CHECK SIZE OF PROPOSED NEW SOLN COMPONENT.
!     REJECT IT IF IT IS TOO LARGE.
isol = mep1
assign 900 to igo897
go to 980
!
!     TEST-PROPOSED-NEW-COMPONENT
900 if (.not.(pos)) go to 910
!
!     SWAP ROWS MEP1 AND NIV, AND SCALE FACTORS FOR THESE ROWS.
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
!     TO TEST-PROPOSED-NEW-COMPONENT
z2 = w(isol,np1)/w(isol,nsoln)
z(nsoln) = z2
pos = z2.gt.zero
if (.not.(z2*eanorm.ge.bnorm .and. pos)) go to 990
pos = .not.(blowup*z2*eanorm.ge.bnorm)
990 go to 1280
1000 continue
!     TO COMPUTE-FINAL-SOLUTION
!
!     SOLVE SYSTEM, STORE RESULTS IN X(*).
!
assign 1010 to igo958
go to 1110
!     SOLVE-SYSTEM
1010 call scopy(nsoln, z, 1, x, 1)
!
!     APPLY HOUSEHOLDER TRANSFORMATIONS TO X(*) IF KRANK.LT.L
if (.not.(0.lt.krank .and. krank.lt.l)) go to 1030
do 1020 i = 1,krank
  call h12(2, i, krp1, l, w(i,1), mdw, h(i), x, 1, 1, 1)
1020 continue
!
!     FILL IN TRAILING ZEROES FOR CONSTRAINED VARIABLES NOT IN SOLN.
1030 if (.not.(nsoln.lt.n)) go to 1040
x(nsp1) = zero
call scopy(n-nsoln, x(nsp1), 0, x(nsp1), 1)
!
!     REPERMUTE SOLN VECTOR TO NATURAL ORDER.
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
!     RESCALE THE SOLN USING THE COL SCALING.
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
!     TO SOLVE-SYSTEM
!
1110 continue
if (.not.(done)) go to 1120
isol = 1
go to 1130
1120 isol = lp1
1130 if (.not.(nsoln.ge.isol)) go to 1270
!
!     COPY RT. HAND SIDE INTO TEMP VECTOR TO USE OVERWRITING METHOD.
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
!     THIS IS A COMPANION SUBPROGRAM TO WNNLS( ).
!     THE DOCUMENTATION FOR WNNLS( ) HAS MORE COMPLETE
!     USAGE INSTRUCTIONS.
!
!     NOTE  THE M BY (N+1) MATRIX W( , ) CONTAINS THE RT. HAND SIDE
!           B AS THE (N+1)ST COL.
!
!
!     TRIANGULARIZE L1 BY L1 SUBSYSTEM, WHERE L1=MIN(M,L), WITH
!     COL INTERCHANGES.
!     REVISED OCT. 1, 1989
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
!     WE SET FACTOR=1.E0 SO THAT THE HEAVY WEIGHT ALAMDA WILL BE
!     INCLUDED IN THE TEST FOR COL INDEPENDENCE.
factor = 1.e0
i = 1
ip1 = 2
lend = l
10 if (.not.(i.le.lb)) go to 150
if (.not.(i.le.me)) go to 130
!
!     SET IR TO POINT TO THE I-TH ROW.
ir = i
mend = m
assign 20 to igo996
go to 460
!
!     UPDATE-COL-SS-AND-FIND-PIVOT-COL
20 assign 30 to igo993
go to 560
!
!     PERFORM-COL-INTERCHANGE
!
!     SET IC TO POINT TO I-TH COL.
30 ic = i
assign 40 to igo990
go to 520
!
!     TEST-INDEP-OF-INCOMING-COL
40 if (.not.(indep)) go to 110
!
!     ELIMINATE I-TH COL BELOW DIAG. USING MOD. GIVENS TRANSFORMATIONS
!     APPLIED TO (A B).
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
!     COL I IS DEPENDENT. SWAP WITH COL LEND.
max = lend
!
!     PERFORM-COL-INTERCHANGE
assign 120 to igo993
go to 560
120 continue
lend = lend - 1
!
!     FIND COL IN REMAINING SET WITH LARGEST SS.
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
!     DETERMINE THE RANK OF THE REMAINING EQUALITY CONSTRAINT
!     EQUATIONS BY ELIMINATING WITHIN THE BLOCK OF CONSTRAINED
!     VARIABLES.  REMOVE ANY REDUNDANT CONSTRAINTS.
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
!     UPDATE-COL-SS-AND-FIND-PIVOT-COL
190 assign 200 to igo993
go to 560
!
!     PERFORM-COL-INTERCHANGE
!
!     ELIMINATE ELEMENTS IN THE I-TH COL.
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
!     SET IC=I=COL BEING ELIMINATED
230 ic = i
assign 240 to igo990
go to 520
!
!     TEST-INDEP-OF-INCOMING-COL
240 if (indep) go to 270
!
!     REMOVE ANY REDUNDANT OR DEPENDENT EQUALITY CONSTRAINTS.
245 continue
jj = ir
250 if (.not.(ir.le.me)) go to 260
w(ir,1) = zero
call scopy(n, w(ir,1), 0, w(ir,1), mdw)
rnorm = rnorm + (scale(ir)*w(ir,np1)/alsq)*w(ir,np1)
w(ir,np1) = zero
scale(ir) = one
!     RECLASSIFY THE ZEROED ROW AS A LEAST SQUARES EQUATION.
itype(ir) = 1
ir = ir + 1
go to 250
!
!     REDUCE ME TO REFLECT ANY DISCOVERED DEPENDENT EQUALITY
!     CONSTRAINTS.
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
!     TRY TO DETERMINE THE VARIABLES KRANK+1 THROUGH L1 FROM THE
!     LEAST SQUARES EQUATIONS.  CONTINUE THE TRIANGULARIZATION WITH
!     PIVOT ELEMENT W(MEP1,I).
!
recalc = .true.
!
!     SET FACTOR=ALSQ TO REMOVE EFFECT OF HEAVY WEIGHT FROM
!     TEST FOR COL INDEPENDENCE.
factor = alsq
kk = krp1
i = kk
ip1 = i + 1
310 if (.not.(i.le.l1)) go to 410
!
!     SET IR TO POINT TO THE MEP1-ST ROW.
ir = mep1
lend = l
mend = m
assign 320 to igo996
go to 460
!
!     UPDATE-COL-SS-AND-FIND-PIVOT-COL
320 assign 330 to igo993
go to 560
!
!     PERFORM-COL-INTERCHANGE
!
!     ELIMINATE I-TH COL BELOW THE IR-TH ELEMENT.
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
!     TEST IF NEW PIVOT ELEMENT IS NEAR ZERO. IF SO, THE COL IS
!     DEPENDENT.
t = scale(ir)*w(ir,i)**2
indep = t.gt.tau**2*eanorm**2
if (.not.indep) go to 380
!
!     COL TEST PASSED. NOW MUST PASS ROW NORM TEST TO BE CLASSIFIED
!     AS INDEPENDENT.
rn = zero
do 370 i1 = ir,m
  do 360 j1 = ip1,n
    rn = amax1(rn,scale(i1)*w(i1,j1)**2)
360 continue
370 continue
indep = t.gt.tau**2*rn
!
!     IF INDEPENDENT, SWAP THE IR-TH AND KRP1-ST ROWS TO MAINTAIN THE
!     TRIANGULAR FORM.  UPDATE THE RANK INDICATOR KRANK AND THE
!     EQUALITY CONSTRAINT POINTER ME.
380 if (.not.(indep)) go to 390
call sswap(np1, w(krp1,1), mdw, w(ir,1), mdw)
call sswap(1, scale(krp1), 1, scale(ir), 1)
!     RECLASSIFY THE LEAST SQ. EQUATION AS AN EQUALITY CONSTRAINT AND
!     RESCALE IT.
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
!     IF PSEUDORANK IS LESS THAN L, APPLY HOUSEHOLDER TRANS.
!     FROM RIGHT.
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
!     TO UPDATE-COL-SS-AND-FIND-PIVOT-COL
!
!     THE COL SS VECTOR WILL BE UPDATED AT EACH STEP. WHEN
!     NUMERICALLY NECESSARY, THESE VALUES WILL BE RECOMPUTED.
!
if (.not.(ir.ne.1 .and. (.not.recalc))) go to 480
!     UPDATE COL SS =SUM OF SQUARES.
do 470 j = i,lend
  h(j) = h(j) - scale(ir-1)*w(ir-1,j)**2
470 continue
!
!     TEST FOR NUMERICAL ACCURACY.
max = isamax(lend-i+1,h(i),1) + i - 1
recalc = hbar + tenm3*h(max).eq.hbar
!
!     IF REQUIRED, RECALCULATE COL SS, USING ROWS IR THROUGH MEND.
480 if (.not.(recalc)) go to 510
do 500 j = i,lend
  h(j) = zero
  do 490 k = ir,mend
    h(j) = h(j) + scale(k)*w(k,j)**2
490 continue
500 continue
!
!     FIND COL WITH LARGEST SS.
max = isamax(lend-i+1,h(i),1) + i - 1
hbar = h(max)
510 go to 600
520 continue
!
!     TO TEST-INDEP-OF-INCOMING-COL
!
!     TEST THE COL IC TO DETERMINE IF IT IS LINEARLY INDEPENDENT
!     OF THE COLS ALREADY IN THE BASIS.  IN THE INIT TRI
!     STEP, WE USUALLY WANT THE HEAVY WEIGHT ALAMDA TO
!     BE INCLUDED IN THE TEST FOR INDEPENDENCE.  IN THIS CASE THE
!     VALUE OF FACTOR WILL HAVE BEEN SET TO 1.E0 BEFORE THIS
!     PROCEDURE IS INVOKED.  IN THE POTENTIALLY RANK DEFICIENT
!     PROBLEM, THE VALUE OF FACTOR WILL HAVE BEEN
!     SET TO ALSQ=ALAMDA**2 TO REMOVE THE EFFECT OF THE HEAVY WEIGHT
!     FROM THE TEST FOR INDEPENDENCE.
!
!     WRITE NEW COL AS PARTITIONED VECTOR
!             (A1)  NUMBER OF COMPONENTS IN SOLN SO FAR = NIV
!             (A2)  M-NIV COMPONENTS
!     AND COMPUTE  SN = INVERSE WEIGHTED LENGTH OF A1
!                  RN = INVERSE WEIGHTED LENGTH OF A2
!     CALL THE COL INDEPENDENT WHEN RN .GT. TAU*SN
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
!     TO PERFORM-COL-INTERCHANGE
!
if (.not.(max.ne.i)) go to 570
!     EXCHANGE ELEMENTS OF PERMUTED INDEX VECTOR AND PERFORM COL
!     INTERCHANGES.
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
! SUBROUTINE L2SLV COMPUTES LEAST SQUARES SOLUTIONS TO OVERDETERMINED
! AND UNDERDETERMINED SYSTEMS OF LINEAR EQUATIONS.  THE METHOD USED IS
! A MODIFIED GRAM-SCHMIDT ORTHOGONAL DECOMPOSITION WITH ITERATIVE
! REFINEMENT OF THE SOLUTION.  THE SOLUTION MAY BE SUBJECT TO LINEAR
! EQUALITY CONSTRAINTS.  OUTPUT INCLUDES THE LEAST SQUARES
! COEFFICIENTS, RESIDUALS, UNSCALED COVARIANCE MATRIX, AND INFORMATION
! ON THE BEHAVIOR OF THE ITERATIVE REFINEMENT PROCEDURE.
! MATRIX A IS THE GIVEN MATRIX OF A SYSTEM OF M LINEAR EQUATIONS IN N
! UNKNOWNS, AND MATRIX W IS A GIVEN DIAGONAL MATRIX OF WEIGHTS WITH ALL
! DIAGONAL ELEMENTS NONNEGATIVE.  LET H = W*A.
! IN THE EVENT THAT N1 (THE COMPUTED RANK OF MATRIX H) IS LESS THAN N
! (THE NUMBER OF UNKNOWN COEFFICIENTS), A UNIQUE SOLUTION VECTOR HAVING
! N ELEMENTS CAN BE OBTAINED BY IMPOSING THE CONDITION THAT THE
! SOLUTION BE OF MINIMAL EUCLIDEAN NORM.  SUCH A SOLUTION IS SOUGHT IN
! THE CASE OF UNDERDETERMINED OR RANK-DEFICIENT PROBLEMS.
!
! ** INPUT VARIABLES **
! M      TOTAL NUMBER OF EQUATIONS.
! N      NUMBER OF UNKNOWN COEFFICIENTS.
! M1     NUMBER OF LINEAR CONSTRAINTS (0.LE.M1.LE.M AND M1.LE.N).
! L      NUMBER OF RIGHT-HAND SIDES (VECTORS OF OBSERVATIONS).
! A      TWO-DIMENSIONAL ARRAY OF SIZE (MM,N).  ON ENTRY, THE ARRAY A
!        CONTAINS THE GIVEN MATRIX OF A SYSTEM OF M LINEAR EQUATIONS
!        IN N UNKNOWNS, WHERE THE FIRST M1 EQUATIONS ARE TO BE
!        SATISFIED EXACTLY.  A IS LEFT INTACT ON EXIT.
! B      TWO-DIMENSIONAL ARRAY OF SIZE (MB,L).  ON ENTRY, B CONTAINS
!        THE L GIVEN RIGHT-HAND SIDES (VECTORS OF OBSERVATIONS).  B IS
!        LEFT INTACT ON EXIT.
! W      VECTOR OF SIZE M.  ON ENTRY, W CONTAINS THE DIAGONAL ELEMENTS
!        OF A GIVEN DIAGONAL MATRIX OF WEIGHTS, ALL NONNEGATIVE.
!        (THE FIRST M1 ELEMENTS OF W ARE SET EQUAL TO 1.0 BY THE
!        PROGRAM WHEN M1 IS GREATER THAN ZERO.)
! TOL    PARAMETER USED IN DETERMINING THE RANK OF MATRIX H.
!        NOTE --
!        (1) IF TOL EQUALS ZERO, THE TOLERANCE USED IN SUBROUTINE
!            DECOM2 WILL BE BASED ON MACHINE PRECISION.
!        (2) IF TOL IS GREATER THAN ZERO, THIS VALUE OF TOL WILL BE
!            USED IN SETTING AN ABSOLUTE TOLERANCE FOR COMPARISON WITH
!            DIAGONAL ELEMENTS OF THE TRIANGULAR MATRIX OBTAINED IN
!            SUBROUTINE DECOM2.  THE VALUE OF TOL CAN BE BASED ON
!            KNOWLEDGE CONCERNING THE ACCURACY OF THE DATA.
! MM     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY A.  MM MUST SATISFY MM.GE.M.
! MB     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY B.  MB MUST SATISFY MB.GE.M.
! MR     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY RES.  MR MUST SATISFY MR.GE.M.
! NN     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY X.  NN MUST SATISFY NN.GE.N.
! MMPNN  DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        THE ARRAY QR.  MMPNN MUST SATISFY MMPNN.GE.M+N.
!
! ** OUTPUT VARIABLES AND INTERNAL VARIABLES **
! N1     COMPUTED RANK OF MATRIX H, WHERE H = W*A.
! IPIVOT VECTOR OF SIZE N.  ON EXIT, THIS ARRAY RECORDS THE ORDER
!        IN WHICH THE COLUMNS OF H WERE SELECTED BY THE PIVOTING
!        SCHEME IN THE COURSE OF THE ORTHOGONAL DECOMPOSITION.
!        WHENEVER N1.LT.N, THE FIRST N1 ELEMENTS OF IPIVOT INDICATE
!        WHICH COLUMNS OF H WERE FOUND TO BE LINEARLY INDEPENDENT.
! X      TWO-DIMENSIONAL ARRAY OF SIZE (NN,L).  ON EXIT, X CONTAINS
!        THE SOLUTION VECTORS.
! RES    TWO-DIMENSIONAL ARRAY OF SIZE (MR,L).  ON EXIT, RES CONTAINS
!        THE RESIDUAL VECTORS.
! QR     TWO-DIMENSIONAL ARRAY OF SIZE (MMPNN,N).  ON EXIT, IF N1 = N
!        THEN QR CONTAINS THE UNSCALED COVARIANCE MATRIX. (QR IS USED
!        INTERNALLY TO STORE THE RESULTS FROM THE SUBROUTINE DECOM2.
!        THE RESULTS FROM DECOM2 ARE DESTROYED WHEN THE COVARIANCE
!        MATRIX IS COMPUTED.)
! C      VECTOR HAVING AT LEAST 6*(M+N)+2*L ELEMENTS USED (1) FOR
!        INTERNAL WORK SPACE AND (2) FOR RETURNING INFORMATION ON THE
!        BEHAVIOR OF THE ITERATIVE REFINEMENT PROCEDURE.
!        (A) NUMIT IS THE NUMBER OF ITERATIONS CARRIED OUT DURING THE
!            ITERATIVE REFINEMENT IN ATTEMPTING TO OBTAIN A SOLUTION
!            FOR THE K-TH RIGHT-HAND SIDE.
!            ON EXIT, C(K) = +NUMIT IF THE SOLUTION CONVERGED, AND
!                     C(K) = -NUMIT IF THE SOLUTION FAILED TO CONVERGE.
!        (B) DIGITX GIVES AN ESTIMATE OF THE NUMBER OF CORRECT DIGITS
!            IN THE INITIAL SOLUTION OF THE COEFFICIENTS FOR THE K-TH
!            RIGHT-HAND SIDE.  ON EXIT, C(K+L) = DIGITX.
! IFAULT FAULT INDICATOR WHICH IS ZERO IF NO ERRORS WERE ENCOUNTERED
!        AND POSITIVE IF ERRORS WERE DETECTED OR IF EVIDENCE OF SEVERE
!        ILL-CONDITIONING WAS FOUND.  IF IFAULT IS SET TO 1, 2, 3, 4,
!        5, 6 OR 7, EXECUTION IS TERMINATED.  EXECUTION CONTINUES WHEN
!        IFAULT IS SET EQUAL TO 8, 9 OR 10 PROVIDED THAT A SOLUTION
!        WAS OBTAINED FOR AT LEAST ONE RIGHT-HAND SIDE.  THE VALUE OF
!        IFAULT IS USED TO INDICATE THE FOLLOWING --
!        0 = NO ERRORS ENCOUNTERED.
!        1 = BAD INPUT PARAMETER (M, N OR L).
!        2 = BAD INPUT PARAMETER (M1).
!        3 = BAD DIMENSION.  EITHER M.GT.MM, M.GT.MB, M.GT.MR,
!            N.GT.NN, OR M+N.GT.MMPNN.
!        4 = AT LEAST ONE WEIGHT IS NEGATIVE.
!        5 = EITHER MATRIX H OR MATRIX OF CONSTRAINTS EQUALS ZERO.
!        6 = CONSTRAINTS ARE LINEARLY DEPENDENT.
!        7 = ALL SOLUTIONS FAILED TO CONVERGE.
!        8 = SOLUTION FAILED TO CONVERGE FOR AT LEAST ONE RIGHT-HAND
!            SIDE.
!        9 = LARGE NUMBER OF ITERATIONS REQUIRED FOR CONVERGENCE.
!       10 = ESTIMATED NUMBER OF DIGITS IN INITIAL SOLUTION OF
!            COEFFICIENTS IS SMALL.
!       11 = DIAGONAL ELEMENT OF COVARIANCE MATRIX WAS COMPUTED TO BE
!            NEGATIVE OWING TO ROUNDING ERROR. NO SEVERE CONDITIONING
!            PROBLEMS WERE DETECTED.
!       12 = DIAGONAL ELEMENT OF COVARIANCE MATRIX WAS COMPUTED TO BE
!            NEGATIVE OWING TO ROUNDING ERROR. THE PROBLEM APPEARS TO
!            BE EXTREMELY ILL-CONDITIONED.
!
! ** SUBROUTINES REQUIRED **
! SUBROUTINE DECOM2
!        USES MODIFIED GRAM-SCHMIDT ALGORITHM WITH PIVOTING TO
!        OBTAIN AN ORTHOGONAL DECOMPOSITION OF THE INPUT MATRIX.
! SUBROUTINE SOLVE2
!        COMPUTES COEFFICIENTS AND RESIDUALS.  ITERATIVE REFINEMENT IS
!        USED TO IMPROVE THE ACCURACY OF THE INITIAL SOLUTION.
! SUBROUTINE SOLVE3
!        CALLED ONLY BY SUBROUTINE SOLVE2.
! SUBROUTINE COVAR
!        COMPUTES UNSCALED COVARIANCE MATRIX OF THE COEFFICIENTS.
!
! ** STORAGE REQUIREMENTS **
! THE STORAGE REQUIRED FOR THE DIMENSIONED ARRAYS IN L2SLV IS
!   M*(2*N + 2*L + 7) + N*(N + L + 7) + 2*L
! LOCATIONS.  ALL ARRAYS REQUIRED IN SUBROUTINES CALLED BY L2SLV ARE
! DECLARED HEREIN AND ARE TRANSMITTED ONLY THROUGH PARAMETER LISTS OF
! CALL-SEQUENCES.
!
! ** PRECISION OF ARITHMETIC CALCULATIONS **
! SINGLE PRECISION ARITHMETIC IS USED FOR ALL CALCULATIONS EXCEPT THE
! DOUBLE PRECISION ACCUMULATION OF INNER PRODUCTS.  (THE VARIABLE SUM
! IS DECLARED TO BE DOUBLE PRECISION IN SUBROUTINES DECOM2, SOLVE2,
! SOLVE3 AND COVAR.)  IT IS ESSENTIAL FOR THE SUCCESS OF THE ITERATIVE
! REFINEMENT PROCEDURE THAT INNER PRODUCTS BE ACCUMULATED IN DOUBLE
! PRECISION.
!
! ** CONVERSION OF THE PROGRAM TO DOUBLE PRECISION **
! *********************************************************************
! * ON COMPUTERS HAVING SHORT WORD LENGTH (AS THE IBM 360/370) IT MAY *
! * BE DESIRABLE TO PERFORM ALL CALCULATIONS IN DOUBLE PRECISION.  IN *
! * THIS CASE, THE ITERATIVE REFINEMENT PRESENTLY INCLUDED IN SOLVE2  *
! * SHOULD BE OMITTED.                                                *
! * TO CONVERT THE PROGRAM TO DOUBLE PRECISION, THE FOLLOWING         *
! * APPROACH IS SUGGESTED.                                            *
! *                                                                   *
! * 1. VARIABLES PRESENTLY DECLARED TO BE REAL SHOULD BE DECLARED     *
! *    DOUBLE PRECISION.  THOSE TYPED INTEGER, DOUBLE PRECISION AND   *
! *    LOGICAL SHOULD NOT BE CHANGED.                                 *
! * 2. THE USE OF FAIL, NUMIT AND DIGITX SHOULD BE OMITTED.           *
! * 3. DESCRIPTION OF VARIABLE C (AT L2B 690-790) SHOULD READ --      *
! *    C  VECTOR HAVING AT LEAST 6*(M+N) ELEMENTS USED ONLY FOR       *
! *       INTERNAL WORK SPACE.                                        *
! * 4. THE VALUE OF ETA (AT L2B 1960) SHOULD BE SET SO THAT IT IS THE *
! *    SMALLEST POSITIVE DOUBLE PRECISION NUMBER SUCH THAT 1.0 + ETA  *
! *    IS GREATER THAN 1.0 IN DOUBLE PRECISION ARITHMETIC.            *
! *    FOR IBM COMPUTER TYPE, ETA = 16.**(-13)                        *
! *    FOR UNIVAC COMPUTER TYPE, ETA = 2.**(-59)                      *
! * 5. THE FOLLOWING FORTRAN FUNCTIONS SHOULD BE CHANGED --           *
! *      SINGLE PRECISION NAME     DOUBLE PRECISION NAME              *
! *             DBLE(X)                X                              *
! *             FLOAT(N)               DBLE(FLOAT(N))                 *
! *             SQRT(X)                DSQRT(X)                       *
! *    DBLE(X) IS USED IN SUBROUTINES DECOM2, SOLVE2, SOLVE3 AND      *
! *       COVAR.                                                      *
! *    FLOAT(N) IS USED IN SUBROUTINE DECOM2.                         *
! *    SQRT(X) IS USED IN SUBROUTINE L2SLV.                           *
! * 6. REPLACE STATEMENT L2B 2500 BY A STATEMENT READING              *
! *          K3 = 1                                                   *
! * 7. FURTHER DETAILS ARE GIVEN IN SUBROUTINE SOLVE2 IN CONNECTION   *
! *    WITH THE OMISSION OF ITERATIVE REFINEMENT.                     *
! * 8. IN SUBROUTINE L2SLV, STATEMENTS L2B 950-1000, 1820-1830, 2020, *
! *    2350-2360, 2480-2490, 3070, 3280-3570 AND 3590-3620 SHOULD BE  *
! *    OMITTED.                                                       *
! *    STATEMENT NUMBERS GIVEN HERE REFER TO THOSE IN THE RIGHT-HAND  *
! *    MARGIN.  CERTAIN COMMENTS IN SUBROUTINE L2SLV DO NOT APPLY TO  *
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
! SET VALUE OF ETA, A MACHINE-DEPENDENT PARAMETER.
! ETA, THE RELATIVE MACHINE PRECISION, IS THE SMALLEST POSITIVE REAL
! NUMBER SUCH THAT 1.0 + ETA IS GREATER THAN 1.0 IN FLOATING-POINT
! ARITHMETIC.
!
eta = spmpar(1)
!
! DEFAULT VALUE FOR TOL IS ZERO.
!
if (tol.lt.0.0) tol = 0.0
ifault = 0
ksum = 0
!
! PERFORM INITIAL CHECKING OF INPUT PARAMETERS, DIMENSIONS AND
! WEIGHTS FOR POSSIBLE ERRORS.
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
! SET PARAMETERS WHICH ALLOCATE VECTOR C TO CONTAIN CERTAIN FINAL
! RESULTS AND ALSO TO BE USED AS WORK SPACE.
!
! K1 IS STARTING POINT FOR NUMIT AND FAIL, OF LENGTH L.
! K2 IS STARTING POINT FOR DIGITX, OF LENGTH L.
! K3 IS STARTING POINT FOR D, OF LENGTH N.
! K4 IS STARTING POINT FOR K-TH COLUMN OF B, OF LENGTH M.
! K5 IS STARTING POINT FOR K-TH COLUMN OF X, OF LENGTH N.
! K6 IS STARTING POINT FOR K-TH COLUMN OF RES, OF LENGTH M.
! K7 IS STARTING POINT FOR WORK SPACE OF LENGTH M.
! K8 IS STARTING POINT FOR WORK SPACE OF LENGTH M.
! K9 IS STARTING POINT FOR WORK SPACE OF LENGTH N.
! K10 IS STARTING POINT FOR WORK SPACE OF LENGTH N.
! K11 IS STARTING POINT FOR WORK SPACE OF LENGTH M + N.
! K12 IS STARTING POINT FOR WORK SPACE OF LENGTH M + N.
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
! MULTIPLY EACH ROW OF MATRIX A (M BY N) BY ITS APPROPRIATE WEIGHT AND
! STORE THE RESULT IN THE FIRST M ROWS OF ARRAY QR.  SET ARRAY C AND
! THE LAST N ROWS OF ARRAY QR EQUAL TO ZERO.
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
! OBTAIN AN ORTHOGONAL DECOMPOSITION OF THE MATRIX STORED IN THE FIRST
! M ROWS OF ARRAY QR AND COMPUTE ITS RANK.
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
! SEEK A SOLUTION (COEFFICIENTS AND RESIDUALS) FOR EACH OF THE L LEAST
! SQUARES PROBLEMS WHOSE RIGHT-HAND SIDES ARE GIVEN IN THE ARRAY B.
!
110 iter = -alog10(eta)
do 200 k = 1,l
! K-TH RIGHT-HAND SIDE.
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
! FOR RIGHT-HAND SIDES WHERE CONVERGENCE OF A SOLUTION IS REPORTED,
! A CHECK IS MADE FOR EVIDENCE OF SEVERE ILL-CONDITIONING.  SUCH
! EVIDENCE IS FURNISHED BY LARGE VALUES OF NUMIT (NUMBER OF ITERATIONS
! BEFORE CONVERGENCE WAS OBTAINED) AND SMALL VALUES OF DIGITX
! (ESTIMATE OF THE NUMBER OF CORRECT DIGITS IN THE INITIAL SOLUTION
! OF THE COEFFICIENTS).  IF NUMIT EXCEEDS -ALOG10(ETA) THEN IFAULT
! IS SET TO 9.  IF DIGITX IS LESS THAN 0.5 (HALF A DECIMAL DIGIT)
! THEN IFAULT IS SET TO 10.
!
  c(k) = float(numit)
  if (fail) c(k) = -c(k)
  k0 = k2 + k - 1
  c(k0) = digitx
  if (.not.fail) go to 180
! KSUM IS A TALLY OF SOLUTIONS WHICH FAILED TO CONVERGE.
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
! COMPUTE THE UNSCALED COVARIANCE MATRIX OF THE COEFFICIENTS.
!
call covar(n, m1, n1, ipivot, qr, c(k3), c(k9), mmpnn)
if (n.eq.1) go to 260
do j=2,n
jm1 = j - 1
  do 240 i = 1,jm1
240 qr(i,j) = qr(j,i)
end do
!
! IN CERTAIN PROBLEMS, SOME DIAGONAL TERMS OF THE UNSCALED COVARIANCE
! MATRIX ARE EQUAL TO ZERO OR TO SMALL POSITIVE NUMBERS.  BECAUSE OF
! ROUNDING ERRORS, COMPUTED VALUES FOR THESE TERMS MAY BE SMALL
! NEGATIVE NUMBERS.  IFAULT IS SET TO 11 IF THIS OCCURS.
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

!     SUBROUTINE DECOM2(...)
! SUBROUTINE DECOM2 USES A MODIFIED GRAM-SCHMIDT ALGORITHM WITH
! PIVOTING TO OBTAIN AN ORTHOGONAL DECOMPOSITION OF THE INPUT MATRIX
! GIVEN IN QR.
! THE INPUT PARAMETER TOL (EQUAL EITHER TO ZERO OR TO A POSITIVE
! NUMBER) IS USED IN DETERMINING THE RANK OF MATRIX QR.
! NOTE --
!     (1) IF TOL EQUALS ZERO, THE TOLERANCE USED AT STATEMENT DC2 1180
!         WILL BE BASED ON MACHINE PRECISION.
!         UNDER THIS APPROACH, THE TOLERANCE (TOL2) IS SET EQUAL TO
!         (FLOAT(N)*ETA)**2*D(M1+1) AT STATEMENT DC2 1170.
!         IF DESIRED, THE USER CAN OBTAIN A MORE CONSERVATIVE
!         TOLERANCE BY REPLACING N IN THIS STATEMENT BY A LARGER
!         QUANTITY.
!     (2) IF TOL IS GREATER THAN ZERO, TOL2 (WHICH IS SET EQUAL TO
!         TOL) WILL BE USED AT STATEMENT DC2 1180 AS AN ABSOLUTE
!         TOLERANCE FOR COMPARISON WITH DIAGONAL ELEMENTS OF THE
!         TRIANGULAR MATRIX OBTAINED IN THE DECOMPOSITION.  UNDER THIS
!         APPROACH, THE VALUE OF TOL CAN BE BASED ON KNOWLEDGE
!         CONCERNING THE ACCURACY OF THE DATA.
! ON EXIT, THE ARRAYS QR, D AND IPIVOT CONTAIN THE RESULTS OF THE
! DECOMPOSITION WHICH ARE NEEDED FOR OBTAINING AN INITIAL SOLUTION
! AND FOR ITERATIVE REFINEMENT.
! ON EXIT, N1 IS THE COMPUTED RANK OF THE INPUT MATRIX QR.
! ON EXIT, SING IS SET EQUAL TO .TRUE. WHENEVER
!     (1) N1 = 0 (I.E., INPUT MATRIX QR EQUALS ZERO OR MATRIX OF
!         CONSTRAINTS EQUALS ZERO), OR
!     (2) N1 IS LESS THAN M1 (I.E., THE M1 BY N MATRIX OF LINEAR
!         CONSTRAINTS IS SINGULAR).
! OTHERWISE, ON EXIT FROM DECOM2, SING = .FALSE.
! ON EXIT, THE VECTOR IPIVOT RECORDS THE ORDER IN WHICH THE COLUMNS
! OF QR WERE SELECTED BY THE PIVOTING SCHEME IN THE COURSE OF THE
! ORTHOGONAL DECOMPOSITION.
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
! STEP NUMBER NS OF THE DECOMPOSITION.
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
! PIVOT SEARCH.
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
! COLUMN INTERCHANGE.
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
! RETURN HERE IF N1 = 0.  EITHER INPUT MATRIX QR EQUALS ZERO OR
! MATRIX OF CONSTRAINTS EQUALS ZERO.
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
! BEGIN ORTHOGONALIZATION.
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
! NORMAL RETURN.
return
end subroutine decom2

!     SUBROUTINE SOLVE2(...)
! SUBROUTINE SOLVE2 USES THE ORTHOGONAL DECOMPOSITION STORED IN QR, D
! AND IPIVOT TO COMPUTE THE SOLUTION (COEFFICIENTS AND RESIDUALS)
! TO THE LEAST SQUARES PROBLEM WHOSE RIGHT-HAND SIDE IS GIVEN IN B.
! IN THE EVENT THAT N1 (THE COMPUTED RANK OF MATRIX H) IS LESS THAN N
! (THE NUMBER OF UNKNOWN COEFFICIENTS), A UNIQUE SOLUTION VECTOR HAVING
! N ELEMENTS CAN BE OBTAINED BY IMPOSING THE CONDITION THAT THE
! SOLUTION BE OF MINIMAL EUCLIDEAN NORM.  SUCH A SOLUTION IS SOUGHT IN
! THE CASE OF UNDERDETERMINED OR RANK-DEFICIENT PROBLEMS.
! IN NORMAL EXITS, THE SOLUTION IS CONTAINED IN THE VECTOR X
! (COEFFICIENTS) AND THE VECTOR RES (RESIDUALS).
! ITERATIVE REFINEMENT IS USED TO IMPROVE THE ACCURACY OF THE INITIAL
! SOLUTION.
! ON EXIT, FAIL IS SET EQUAL TO .TRUE. IF THE SOLUTION FAILS TO
! IMPROVE SUFFICIENTLY.  OTHERWISE, FAIL = .FALSE.  INFORMATION ON THE
! BEHAVIOR OF THE ITERATIVE REFINEMENT PROCEDURE IS GIVEN BY NUMIT AND
! DIGITX.  NUMIT IS THE NUMBER OF ITERATIONS CARRIED OUT IN ATTEMPTING
! TO OBTAIN A SOLUTION.  DIGITX IS AN ESTIMATE OF THE NUMBER OF
! CORRECT DIGITS IN THE INITIAL SOLUTION OF THE COEFFICIENTS.
! THIS SUBROUTINE CALLS SUBROUTINE SOLVE3.
!
! ********* CONVERSION OF THIS SUBROUTINE TO DOUBLE PRECISION *********
! * IF THE PROGRAM IS CONVERTED SO THAT ALL CALCULATIONS ARE DONE IN  *
! * DOUBLE PRECISION ARITHMETIC, THE ITERATIVE REFINEMENT PRESENTLY   *
! * INCLUDED IN SOLVE2 SHOULD BE OMITTED, SINCE THE SUCCESS OF THIS   *
! * PROCEDURE DEPENDS ON COMPUTING INNER PRODUCTS IN GREATER          *
! * PRECISION THAN OTHER CALCULATIONS.                                *
! * SEE COMMENTS IN SUBROUTINE L2SLV REGARDING CONVERSION TO DOUBLE   *
! * PRECISION.  IN ADDITION, THE FOLLOWING COMMENTS INDICATE HOW TO   *
! * OMIT THE ITERATIVE REFINEMENT FROM THIS SUBROUTINE.  STATEMENT    *
! * NUMBERS GIVEN HERE REFER TO THOSE IN THE RIGHT-HAND MARGIN.       *
! *                                                                   *
! * 1. IN STATEMENT SV2 470 CHANGE REAL TO DOUBLE PRECISION.          *
! * 2. REPLACE STATEMENT SV2 880 BY A STATEMENT READING               *
! *       30 DO 50 I=1,M                                              *
! * 3. REPLACE STATEMENTS SV2 1310-1400 BY A STATEMENT READING        *
! *          RETURN                                                   *
! * 4. OMIT STATEMENTS SV2 120-190, 440, 490-500, 520-550, 650,       *
! *    750-850, 1650-1830 AND 1850-1910.                              *
! *                                                                   *
! *********************************************************************
!
