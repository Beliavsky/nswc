pure subroutine h12(mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv)
implicit none
integer, intent(in) :: ice, icv, iue, l1, lpivot, m, mode, ncv
real, intent(inout) :: c(*), u(iue,m), up
integer :: i, i2, i3, i4, incr, j
real :: cl, d, sm1
double precision :: sm, b
!-----------------------------------------------------------------------
!     Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!
!     Construction and/or application of a single
!     Householder transformation..     Q = i + u*(u**T)/b
!
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
!
if (0 >= lpivot .or. lpivot >= l1 .or. l1 > m) return
cl = abs(u(1,lpivot))
if (mode == 2) go to 60
!
!                            ****** Construct the transformation. ******
!
do j = l1,m
10 cl = max(abs(u(1,j)),cl)
end do
if (cl <= 0.0) go to 130
d = u(1,lpivot)/cl
sm = d*d
do j = l1,m
   d = u(1,j)/cl
20 sm = sm + dble(d*d)
end do
!
sm1 = sm
cl = cl*sqrt(sm1)
if (u(1,lpivot) > 0.0) cl = -cl
up = u(1,lpivot) - cl
u(1,lpivot) = cl
go to 70
!
!            ****** Apply the transformation  i+u*(u**T)/b  to c. ******
!
60 if ( ( cl ) <= 0 ) go to 130
go to 70
70 if (ncv <= 0) return
b = dble(up)*dble(u(1,lpivot))
!
!                       b  must be nonpositive here.  If b = 0., Return.
!
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
90    i3 = i3 + ice
   end do
   if (sm == 0.d0) go to 120
   sm = sm*b
   c(i2) = c(i2) + sm*dble(up)
   do i = l1,m
      c(i4) = c(i4) + sm*dble(u(1,i))
110   i4 = i4 + ice
   end do
120 continue
end do
130 return
end subroutine h12

pure subroutine dhfti(a,mda,m,n,b,mdb,nb,tau,k,rnorm,h,g,ip)
implicit none
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
double precision, intent(inout) :: a(mda,n), b(mdb,*)
double precision, intent(in) :: tau
double precision, intent(inout) :: rnorm(*), h(n), g(n)
integer, intent(inout) :: ip(n)
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
!                       matrix a of the least squares problem AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) is mda, which must satisfy mda.GE.m
!                       either m.GE.n or m.LT.n is permitted.  There
!                       is no restriction on the rank of A.  the
!                       condition mda.LT.m is considered an error.
!
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
!
!                       The condition of nb.GT.1.AND.mdb.LT. max(m,n)
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
!---------------------
!
k = 0
ldiag = min(m,n)
if (ldiag <= 0) go to 270
do j = 1,ldiag
   if (j == 1) go to 20
!
!     Update squared column lengths and find lmax
!    ..
   lmax = j
   do l = j,n
      h(l) = h(l) - a(j - 1,l)**2
      if (h(l) > h(lmax)) lmax = l
   end do
   z = hmax + factor*h(lmax)
   if (z > hmax) go to 50
!
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
   do l = j,n
      h(l) = 0.d0
      do i = j,m
30       h(l) = h(l) + a(i,l)**2
      end do
      if (h(l) > h(lmax)) lmax = l
   end do
   hmax = h(lmax)
!    ..
!     lmax has been determined
!
!     Do column interchanges if needed.
!    ..
50 ip(j) = lmax
   if (ip(j) == j) go to 70
   do i = 1,m
      tmp = a(i,j)
      a(i,j) = a(i,lmax)
60    a(i,lmax) = tmp
   end do
   h(lmax) = h(j)
!
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call dh12(1,j,j + 1,m,a(1,j),1,h(j),a(1,j + 1),1,mda,n - j)
80 call dh12(2,j,j + 1,m,a(1,j),1,h(j),b,1,mdb,nb)
end do
!
!     Determine the pseudorank, k, using the tolerance, tau.
!    ..
do j = 1,ldiag
   if (abs(a(j,j)) <= tau) go to 100
end do
k = ldiag
go to 110
100 k = j - 1
110 kp1 = k + 1
!
!     Compute the norms of the residual vectors.
!
if (nb <= 0) go to 140
do jb = 1,nb
   tmp = 0.d0
   if (kp1 > m) go to 130
   do i = kp1,m
120   tmp = tmp + b(i,jb)**2
   end do
130 rnorm(jb) = sqrt(tmp)
end do
140 continue
!                                           Special for pseudorank = 0
if (k > 0) go to 160
if (nb <= 0) go to 270
do jb = 1,nb
   do i = 1,n
150   b(i,jb) = 0.d0
   end do
end do
go to 270
!
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k == n) go to 180
do ii = 1,k
   i = kp1 - ii
170 call dh12(1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i - 1)
end do
180 continue
!
!
if (nb <= 0) go to 270
do jb = 1,nb
!
!     Solve the k by k triangular system.
!    ..
   do l = 1,k
      sm = 0.d0
      i = kp1 - l
      if (i == k) go to 200
      ip1 = i + 1
      do j = ip1,k
190      sm = sm + a(i,j)*b(j,jb)
      end do
200   sm1 = b(i,jb) - sm
210   b(i,jb) = sm1/a(i,i)
   end do
!
!     Complete computation of solution vector.
!    ..
   if (k == n) go to 240
   do j = kp1,n
220   b(j,jb) = 0.d0
   end do
   do i = 1,k
230   call dh12(2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
   end do
!
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
!
270 return
end subroutine dhfti

pure subroutine dhfti2(a,mda,m,n,b,mdb,nb,d,tau,k,rnorm,h,g,ip,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(out) :: k
integer, intent(in) :: m, mda, mdb, n, nb
double precision, intent(inout) :: a(mda,n), b(mdb,*), d(*)
double precision, intent(in) :: tau
double precision, intent(inout) :: rnorm(*), h(n), g(n)
integer, intent(inout) :: ip(n)
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
!                       matrix a of the least squares problem AX = b.
!                       The first dimensioning parameter of the array
!                       a(*,*) is mda, which must satisfy mda.GE.m
!                       either m.GE.n or m.LT.n is permitted.  There
!                       is no restriction on the rank of A.  the
!                       condition mda.LT.m is considered an error.
!
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
!
!                       The condition of nb.GT.1.AND.mdb.LT. max(m,n)
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
!                          ierr = 2  If nb.GT.1 and mdb.LT.max(m,n)
!                       these errors are fatal.
!-----------------------------------------------------------------------
!---------------------
!
k = 0
ldiag = min(m,n)
if (ldiag <= 0) go to 270
if (m > mda) go to 300
if (nb > 1 .and. max(m,n) > mdb) go to 310
!
do j = 1,ldiag
   if (j == 1) go to 20
!
!     Update squared column lengths and find lmax
!    ..
   lmax = j
   do l = j,n
      h(l) = h(l) - a(j - 1,l)**2
      if (h(l) > h(lmax)) lmax = l
   end do
   z = hmax + factor*h(lmax)
   if (z > hmax) go to 50
!
!     Compute squared column lengths and find lmax
!    ..
20 lmax = j
   do l = j,n
      h(l) = 0.d0
      do i = j,m
30       h(l) = h(l) + a(i,l)**2
      end do
      if (h(l) > h(lmax)) lmax = l
   end do
   hmax = h(lmax)
!    ..
!     lmax has been determined
!
!     Do column interchanges if needed.
!    ..
50 ip(j) = lmax
   if (ip(j) == j) go to 70
   do i = 1,m
      tmp = a(i,j)
      a(i,j) = a(i,lmax)
60    a(i,lmax) = tmp
   end do
   h(lmax) = h(j)
!
!     Compute the j-TH transformation and apply it to A and b.
!    ..
70 call dh12(1,j,j + 1,m,a(1,j),1,h(j),a(1,j + 1),1,mda,n - j)
80 call dh12(2,j,j + 1,m,a(1,j),1,h(j),b,1,mdb,nb)
end do
!
!     Determine the pseudorank, k, using the tolerance, tau.
!     Also store the diagonal elements in the array d.
!    ..
do j = 1,ldiag
   if (abs(a(j,j)) <= tau) go to 100
90 d(j) = a(j,j)
end do
k = ldiag
kp1 = k + 1
go to 110
!
100 k = j - 1
kp1 = j
do j = kp1,ldiag
105 d(j) = a(j,j)
end do
!
!     Compute the norms of the residual vectors.
!
110 if (nb <= 0) go to 140
do jb = 1,nb
   tmp = 0.d0
   if (kp1 > m) go to 130
   do i = kp1,m
120   tmp = tmp + b(i,jb)**2
   end do
130 rnorm(jb) = sqrt(tmp)
end do
140 continue
!                                           Special for pseudorank = 0
if (k > 0) go to 160
if (nb <= 0) go to 270
do jb = 1,nb
   do i = 1,n
150   b(i,jb) = 0.d0
   end do
end do
go to 270
!
!     If the pseudorank is less than n compute Householder
!     decomposition of first k rows.
!    ..
160 if (k == n) go to 180
do ii = 1,k
   i = kp1 - ii
170 call dh12(1,i,kp1,n,a(i,1),mda,g(i),a,mda,1,i - 1)
end do
180 continue
!
!
if (nb <= 0) go to 270
do jb = 1,nb
!
!     Solve the k by k triangular system.
!    ..
   do l = 1,k
      sm = 0.d0
      i = kp1 - l
      if (i == k) go to 200
      ip1 = i + 1
      do j = ip1,k
190      sm = sm + a(i,j)*b(j,jb)
      end do
200   sm1 = b(i,jb) - sm
210   b(i,jb) = sm1/a(i,i)
   end do
!
!     Complete computation of solution vector.
!    ..
   if (k == n) go to 240
   do j = kp1,n
220   b(j,jb) = 0.d0
   end do
   do i = 1,k
230   call dh12(2,i,kp1,n,a(i,1),mda,g(i),b(1,jb),1,mdb,1)
   end do
!
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
!
270 ierr = 0
return
!
!     Error return
!
300 ierr = 1
return
310 ierr = 2
end subroutine dhfti2

pure subroutine dh12(mode,lpivot,l1,m,u,iue,up,c,ice,icv,ncv)
implicit none
integer, intent(in) :: ice, icv, iue, l1, lpivot, m, mode, ncv
double precision, intent(inout) :: u(iue,m), up, c(*)
integer :: i, i2, i3, i4, incr, j
double precision :: b, cl, d, sm
!-----------------------------------------------------------------------
!     Written by C.L. Lawson and R.J. Hanson.  Modified by A.H. Morris.
!     From the book solving least squares problems, Prentice-Hall, 1974.
!
!     Construction and/or application of a single
!     Householder transformation..     Q = i + u*(u**T)/b
!
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
!
if (0 >= lpivot .or. lpivot >= l1 .or. l1 > m) return
cl = abs(u(1,lpivot))
if (mode == 2) go to 60
!
!                            ****** Construct the transformation. ******
!
do j = l1,m
10 cl = max(abs(u(1,j)),cl)
end do
if (cl <= 0.d0) go to 130
d = u(1,lpivot)/cl
sm = d*d
do j = l1,m
   d = u(1,j)/cl
20 sm = sm + d*d
end do
!
cl = cl*sqrt(sm)
if (u(1,lpivot) > 0.d0) cl = -cl
up = u(1,lpivot) - cl
u(1,lpivot) = cl
go to 70
!
!            ****** Apply the transformation  i+u*(u**T)/b  to c. ******
!
60 if ( ( cl ) <= 0 ) go to 130
go to 70
70 if (ncv <= 0) return
b = up*u(1,lpivot)
!
!                       b  must be nonpositive here.  If b = 0., Return.
!
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
90    i3 = i3 + ice
   end do
   if (sm == 0.d0) go to 120
   sm = sm*b
   c(i2) = c(i2) + sm*up
   do i = l1,m
      c(i4) = c(i4) + sm*u(1,i)
110   i4 = i4 + ice
   end do
120 continue
end do
130 return
end subroutine dh12

subroutine lsei(w, mdw, me, ma, mg, n, prgopt, x, rnorme, rnorml, &
   & mode, ws, ip)
implicit none
integer, intent(in) :: ma, mdw, me, mg
integer, intent(out) :: mode
integer :: n
real, intent(inout) :: rnorme, rnorml
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(*), ws(*)
integer, intent(inout) :: ip(*)
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
!                   EX = F, (E me by n) (equations to be exactly
!                                       satisfied)
!                   AX = B, (A ma by n) (equations to be
!                                       approximately satisfied,
!                                       least squares sense)
!                   GX.GE.H,(G mg by n) (inequality constraints)
!
!     The inequalities GX.GE.H mean that every component of the product
!     GX must be .GE. the corresponding component of H.
!
!     In case the equality constraints cannot be satisfied, A
!     generalized inverse solution residual vector LENGTH is obtained
!     for F-EX. This is the minimal length possible for F-EX.
!
!
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
!
!     The user must dimension all arrays appearing in the call list..
!     w(mdw,n+1),prgopt(*),x(n),ws(2*(me+n)+k+(mg+2)*(n+7)),ip(mg+2*n+2)
!     where k=max(ma+mg,n).  This allows for a solution of a range of
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
!                   For this discussion let us call M = me+ma+mg.  Then
!                   mdw must satisfy mdw.GE.M.  the condition
!                   mdw.LT.M is an error.
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
!                  case link=1 And the values key and data set
!                  are not referenced. The general layout of
!                  prgopt(*) is as follows.
!
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
!
!                  Values of link that are nonpositive are errors.
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
!                  of the array w(*,*) must satisfy mdw.GE.MAX0(M,n).
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
!                  largest positive number such that T=1.+SRELPR
!                  satisfies T.EQ.1.  the quantity used
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
!                  prgopt(6)=... (new value of the tolerance)
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
!
!     MODE          INTEGER FLAG THAT INDICATES THE SUBPROGRAM
!                   status after completion.  If mode.GE.2, no
!                   solution has been computed.
!
!                   mode =
!
!                   0  Both equality and inequality constraints
!                      are compatible and have been satisfied.
!
!                   1  Equality constraints are contradictory.
!                      A generalized inverse solution of EX=F was used
!                      to minimize the residual vector LENGTH F-EX.
!                      In this sense, the solution is still meaningful.
!
!                   2  No solution could be obtained. The constraints
!                      are contradictory.
!
!                   4  Usage error occurred.  The value
!                      of mdw is .LT. me+ma+mg, mdw is
!                      .LT. n and a covariance matrix is
!                      requested, or the option vector
!                      prgopt(*) is not properly defined.
!
!     w(*,*)        THE ARRAY w(*,*) CONTAINS THE n BY n SYMMETRIC
!                   covariance matrix of the solution parameters,
!                   provided this was requested on input with
!                   the option vector prgopt(*) and the output
!                   flag is returned with mode = 0 Or 1.
!
!     ip(*)         THE INTEGER WORKING ARRAY HAS THREE ENTRIES
!                   that provide rank and working array LENGTH
!                   information after completion.
!
!                      ip(1) = Rank of equality constraint
!                              matrix.  Define this quantity
!                              AS kranke.
!
!                      ip(2) = Rank of reduced least squares
!                              problem.
!
!                      ip(3) = The amount of storage in the
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
if (n <= 0 .or. me + ma <= 0) return
if (.not.(mdw < m)) go to 80
mode = 4
return
80 np1 = n + 1
kranke = min(me,n)
n1 = 2*kranke + 1
n2 = n1 + n
!
!     Process-option-vector
!
go to 480
90 if (.not.(cov .and. mdw < n)) go to 100
mode = 4
return
100 l = kranke
!
!     Compute norm of equality constraint matrix and RT side.
!
enorm = zero
do j = 1,n
   enorm = max(enorm,sasum(me,w(1,j),1))
end do
fnorm = sasum(me,w(1,np1),1)
if (.not.(l > 0)) go to 200
snmax = zero
rnmax = zero
do i = 1,l
!
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
!
!     Interchange rows if necessary.
   if (i /= imax) call sswap(np1, w(i,1), mdw, w(imax,1), mdw)
   if (.not.(snmax > tau**2*rnmax)) go to 160
!
!     Eliminate elems i+1,...,n in row i.
   call h12(1, i, i + 1, n, w(i,1), mdw, ws(i), w(i + 1,1), mdw, 1, &
      & m - i)
   go to 180
160 kranke = i - 1
   go to 200
180 continue
end do
!
!     Save diag. Terms of lower trap. Matrix.
!
200 call scopy(kranke, w, mdw + 1, ws(kranke + 1), 1)
!
!     Use Householder trans from left to achieve kranke by kranke upper
!     triangular form.
!
if (.not.(kranke > 0 .and. kranke < me)) go to 220
do kk = 1,kranke
   k = kranke + 1 - kk
!
!     Apply tranformation to matrix cols. 1,...,k-1.
   call h12(1, k, kranke + 1, me, w(1,k), 1, up, w, 1, mdw, k - 1)
!
!     Apply to RT side vector.
   call h12(2, k, kranke + 1, me, w(1,k), 1, up, w(1,np1), 1, 1, 1)
end do
220 if (.not.(kranke > 0)) go to 240
!
!     Solve for variables 1,...,kranke in new coordinates.
call scopy(kranke, w(1,np1), 1, x, 1)
do i = 1,kranke
   x(i) = (x(i) - sdot(i - 1,w(i,1),mdw,x,1))/w(i,i)
end do
!
!     Compute residuals for reduced problem.
!
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
!
!     Compute equal. Constraint equas. Residual length.
270 rnorme = snrm2(me - kranke,w(kranke + 1,np1),1)
!
!     Move reduced problem data upward if kranke.LT.me.
!
if (.not.(kranke < me)) go to 290
do j = 1,np1
   call scopy(m - me, w(me + 1,j), 1, w(kranke + 1,j), 1)
end do
!
!     Compute soln of reduced problem.
!
290 call lsi(w(kranke + 1,kranke + 1), mdw, ma, mg, n - kranke, prgopt, &
   & x(kranke + 1), rnorml, mode, ws(n2), ip(2))
if (mode > 1) go to 470
if (.not.(me > 0)) go to 330
!
!     Test for consistency of equality constraints.
!
mdeqc = 0
xnrme = sasum(kranke,w(1,np1),1)
if (rnorme > tau*(enorm*xnrme + fnorm)) mdeqc = 1
mode = mode + mdeqc
!
!     Check if soln to equal. Constraints satisfies inequal.
!     Constraints when there are no degrees of freedom left.
!
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
!
!     Replace diag. Terms of lower trap. Matrix.
call scopy(kranke, ws(kranke + 1), 1, w, mdw + 1)
!
!     Reapply trans to put soln in original coordinates.
!
do ii = 1,kranke
   i = kranke + 1 - ii
   call h12(2, i, i + 1, n, w(i,1), mdw, ws(i), x, 1, 1, 1)
end do
!
!     Compute cov matrix of equal. Constrained problem.
!
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
!
!     Apply the scaling to the covariance matrix.
!
420 if (.not.(cov)) go to 450
do i = 1,n
   l = n1 + i
   call sscal(n, ws(l - 1), w(i,1), mdw)
   call sscal(n, ws(l - 1), w(1,i), 1)
end do
!
!     Rescale soln. Vector.
!
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
implicit none
integer, intent(in) :: ma, mdw, mg
integer, intent(out) :: mode
integer :: n
real, intent(out) :: rnorm
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(*), ws(*)
integer, intent(inout) :: ip(*)
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
!              Solution vector(unless mode=2), length of AX-B.
!
!      Mode
!              =0   Inequality constraints are compatible.
!              =2   Inequality constraints contradictory.
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
!
!
srelpr = spmpar(1)
mode = 0
rnorm = zero
m = ma + mg
np1 = n + 1
krank = 0
if (n <= 0 .or. m <= 0) go to 70
!
!     Process-option-vector
!
go to 500
!
!     Compute matrix NORM of least squares equas.
!
40 anorm = zero
do j = 1,n
   anorm = max(anorm,sasum(ma,w(1,j),1))
end do
!
!     Set TOL for hfti( ) rank test.
tau = tol*anorm
!
!     Compute Householder orthogonal decomp of matrix.
!
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
!
!     Reduce-to-lpdp-and-solve
!
70 ip(1) = krank
ip(2) = n + max(m,n) + (mg + 2)*(n + 7)
return
!
!     To reduce-to-lpdp-and-solve
!
80 map1 = ma + 1
!
!     Compute ineq. RT-hand side for lpdp.
!
if (.not.(ma < m)) go to 260
if (.not.(minman > 0)) go to 160
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
if (.not.(0 < krank .and. krank < n)) go to 120
do ii = 1,krank
   i = krank + 1 - ii
   l = n1 + i
   call h12(2, i, krank + 1, n, w(i,1), mdw, ws(l - 1), w(map1,1), &
      & mdw, 1, mg)
end do
!
!     Compute permuted ineq. Constr. Matrix times R-inverse.
!
120 do i = map1,m
   if (.not.(0 < krank)) go to 150
   do j = 1,krank
      w(i,j) = (w(i,j) - sdot(j - 1,w(1,j),1,w(i,1),mdw))/w(j,j)
   end do
150 continue
end do
!
!     Solve the reduced problem with lpdp algorithm,
!     the least projected distance problem.
!
160 call lpdp(w(map1,1), mdw, mg, krank, n - krank, opt, x, xnorm, &
   & mdlpdp, ws(n2), ip(n + 1))
if (mdlpdp /= 1) go to 240
if (.not.(krank > 0)) go to 180
!
!     Compute soln in original coordinates.
!
do ii = 1,krank
   i = krank + 1 - ii
   x(i) = (x(i) - sdot(ii - 1,w(i,i + 1),mdw,x(i + 1),1))/w(i,i)
end do
!
!     Apply Householder trans. To soln vector.
!
180 if (.not.(0 < krank .and. krank < n)) go to 200
do i = 1,krank
   l = n1 + i
   call h12(2, i, krank + 1, n, w(i,1), mdw, ws(l - 1), x, 1, 1, 1)
end do
200 if (.not.(minman > 0)) go to 270
!
!     Repermute variables to their input order.
do ii = 1,minman
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
rnorm = sqrt(rnorm**2 + xnorm**2)
go to 270
240 mode = 2
go to 270
260 call scopy(n, ws, 1, x, 1)
270 if (.not.(cov .and. krank > 0)) go to 70
!
!     Compute covariance matrix based on the orthogonal decomp.
!     FROM hfti( ).
!
krm1 = krank - 1
krp1 = krank + 1
!
!     Copy diag. Terms to working array.
call scopy(krank, w, mdw + 1, ws(n2), 1)
!
!     Reciprocate diag. Terms.
do j = 1,krank
   w(j,j) = one/w(j,j)
end do
if (.not.(krank > 1)) go to 310
!
!     Invert the upper triangular QR factor on itself.
do i = 1,krm1
   ip1 = i + 1
   do j = ip1,krank
      w(i,j) = -sdot(j - i,w(i,i),mdw,w(i,j),1)*w(j,j)
   end do
end do
!
!     Compute the inverted factor times its transpose.
310 do i = 1,krank
   do j = i,krank
      w(i,j) = sdot(krank + 1 - j,w(i,j),mdw,w(j,j),mdw)
   end do
end do
if (.not.(krank < n)) go to 450
!
!     Zero out lower trapezoidal part.
!     Copy upper TRI. To lower TRI. Part.
do j = 1,krank
   call scopy(j, w(1,j), 1, w(j,1), mdw)
end do
do i = krp1,n
   w(i,1) = zero
   call scopy(i, w(i,1), 0, w(i,1), mdw)
end do
!
!     Apply right side transformations to lower TRI.
n3 = n2 + krp1
do i = 1,krank
   l = n1 + i
   k = n2 + i
   rb = ws(l - 1)*ws(k - 1)
   if (.not.(rb < zero)) go to 420
!
!     If rb.GE.zero, transformation can be regarded as zero.
   rb = one/rb
!
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
!
!     Copy lower TRI. To upper TRI. To symmetrize the covariance matrix.
!
do i = 1,n
   call scopy(i, w(i,1), mdw, w(1,i), 1)
end do
!
!     Repermute rows and cols.
!
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
!
!     Prepare the option vector for wnnls
!
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
implicit none
integer, intent(inout) :: is(*)
integer, intent(in) :: m, mda
integer, intent(out) :: mode
integer, intent(in) :: n1, n2
real, intent(inout) :: a(mda,*)
real :: prgopt(*)
real, intent(inout) :: wnorm, ws(*), x(*)
integer :: i, iw, ix, j, l, modew, n, np1
real :: rnorm, sc, ynorm
real :: snrm2
real :: sdot
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
real, parameter :: fac = 0.1e0
!
!     dimension a(mda,n+1),prgopt(*),x(n),ws((m+2)*(n+7)),is(m+n+1),
!     where n=n1+n2.  This is a slight overestimate for ws(*).
!
!     Written by R. J. Hanson and K. H. Haskell, sandia labs
!
!     Determine an n1-vector W, and
!               an n2-vector Z
!     which minimizes the Euclidean length of W
!     subject to G*W+H*Z .GE. Y.
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
!          mode=1  The solution was successfully obtained.
!
!          mode=2  The inequalities are inconsistent.
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
!
n = n1 + n2
mode = 1
if (.not.(m <= 0)) go to 20
if (.not.(n > 0)) go to 10
x(1) = zero
call scopy(n, x, 0, x, 1)
10 wnorm = zero
return
20 np1 = n + 1
!
!     Scale nonzero rows of inequality matrix to have length one.
!
do i = 1,m
   sc = snrm2(n,a(i,1),mda)
   if (sc == zero) go to 40
   sc = one/sc
   call sscal(np1, sc, a(i,1), mda)
40 continue
end do
!
!     Scale RT.-Side vector to have length one (or zero).
ynorm = snrm2(m,a(1,np1),1)
if (ynorm == zero) go to 50
sc = one/ynorm
call sscal(m, sc, a(1,np1), 1)
!
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
!
!     Copy transpose of (H G Y) to work array ws(*).
iw = 0
do i = 1,m
!
!     Move col of transpose of H into work array.
   call scopy(n2, a(i,n1 + 1), mda, ws(iw + 1), 1)
   iw = iw + n2
!
!     Move col of transpose of G into work array.
   call scopy(n1, a(i,1), mda, ws(iw + 1), 1)
   iw = iw + n1
!
!     Move component of vector Y into work array.
   ws(iw + 1) = a(i,np1)
   iw = iw + 1
end do
ws(iw + 1) = zero
call scopy(n, ws(iw + 1), 0, ws(iw + 1), 1)
iw = iw + n
ws(iw + 1) = one
iw = iw + 1
!
!     SOLVE EU=F SUBJECT TO (TRANSPOSE OF H)U=0, U.GE.0.  THE
!     MATRIX E = TRANSPOSE OF (G Y), AND THE (n+1)-VECTOR
!     F = TRANSPOSE OF (0,...,0,1).
ix = iw + 1
iw = iw + m
call wnnls(ws, np1, n2, np1 - n2, m, 0, prgopt, ws(ix), rnorm, &
   & modew, is, ws(iw + 1))
!
!     Compute the components of the soln denoted above by W.
sc = one - sdot(m,a(1,np1),1,ws(ix),1)
if (.not.(one + fac*abs(sc) /= one .and. rnorm > zero)) go to 110
sc = one/sc
do j = 1,n1
   x(j) = sc*sdot(m,a(1,j),1,ws(ix),1)
end do
!
!     Compute the vector Q=Y-GW.  Overwrite Y with this vector.
do i = 1,m
   a(i,np1) = a(i,np1) - sdot(n1,a(i,1),mda,x,1)
end do
go to 130
110 mode = 2
return
130 if (.not.(n2 > 0)) go to 180
!
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
!
!     Solve RV=S subject to V.GE.0.  The matrix R =(transpose
!     OF (H Q)), WHERE Q=Y-GW.  THE (n2+1)-VECTOR S =(TRANSPOSE
!     of (0,...,0,1)).
!
call wnnls(ws, n2 + 1, 0, n2 + 1, m, 0, prgopt, ws(ix), rnorm, modew, &
   & is, ws(iw + 1))
!
!     Compute the components of the soln denoted above by Z.
!
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
!
!     Account for scaling of RT.-Side vector in solution.
180 call sscal(n, ynorm, x, 1)
wnorm = snrm2(n1,x,1)
end subroutine lpdp

subroutine wnnls(w, mdw, me, ma, n, l, prgopt, x, rnorm, mode, &
   & iwork, work)
implicit none
integer, intent(in) :: l, ma, mdw, me
integer, intent(out) :: mode
integer, intent(in) :: n
real, intent(inout) :: rnorm
real, intent(inout) :: w(mdw,*)
real, intent(in) :: prgopt(*)
real, intent(inout) :: x(n), work(*)
integer, intent(inout) :: iwork(*)
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
!               EX = F, (equations to be exactly satisfied)
!
!               AX = B, (equations to be approximately satisfied,
!                        in the least squares sense)
!
!               Subject to components l+1,...,n nonnegative
!
!     Any values me.GE.0, ma.GE.0 and 0.LE. l .LE.n are permitted.
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
!                  discussion let us call M = me + ma.  Then mdw
!                  must satisfy mdw.GE.M.  the condition mdw.LT.M
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
!                  nonnegative.  The condition l.LT.0 .OR. l.GT.n is
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
!                  case link=1 And the values key and data set
!                  are not referenced. The general layout of
!                  prgopt(*) is as follows.
!
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
!
!                  Values of link that are nonpositive are errors.
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
!                  prgopt(n+5)=... (new value of the tolerance)
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
!                  mode = 0  Subprogram completed successfully.
!
!                       = 1  Max. Number of iterations (equal to
!                            3*(n-l)) exceeded. Nearly all problems
!                            should complete in fewer than this
!                            number of iterations. An approximate
!                            solution and its corresponding residual
!                            vector LENGTH are in x(*) and rnorm.
!
!                       = 2  Usage error occurred.  Either
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
!
mode = 0
if (ma + me <= 0 .or. n <= 0) return
if (.not.(mdw < me + ma)) go to 10
mode = 2
return
10 if (0 <= l .and. l <= n) go to 20
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
   & iwork(l1), work(1), work(l1), work(l2), work(l3), work(l4), &
   & work(l5))
end subroutine wnnls

subroutine wnlsm(w, mdw, mme, ma, n, l, prgopt, x, rnorm, mode, &
   & ipivot, itype, wd, h, scale, z, temp, d)
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
!         of the classification of the equations.  itype(i)=0
!         denotes equation i as an equality constraint.
!         itype(i)=1 Denotes equation i as a least squares
!         equation.
!
!         wd(*)
!            an array of length n.  upon completion it contains the
!         dual solution vector.
!
!         h(*)
!            an array of length n.  upon completion it contains the
!         pivot scalars of the Householder transformations performed
!         in the case KRANK.LT.L.
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
!     Until(done)
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
130 continue
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
170 continue
end do
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
itmax = 3*(n - l)
mode = 0
lp1 = l + 1
nsoln = l
nsp1 = nsoln + 1
np1 = n + 1
nm1 = n - 1
l1 = min(m,l)
!
!     Compute scale factor to apply to equal. Constraint equas.
do j = 1,n
   wd(j) = sasum(m,w(1,j),1)
230 continue
end do
imax = isamax(n,wd,1)
eanorm = wd(imax)
bnorm = sasum(m,w(1,np1),1)
alamda = eanorm/(srelpr*fac)
!
!     Define scaling diag matrix for mod Givens usage and
!     classify equation types.
alsq = alamda**2
do i = 1,m
!
!     When EQU i is heavily weighted itype(i)=0, else itype(i)=1.
   if (.not.(i <= me)) go to 240
   t = alsq
   itemp = 0
   go to 250
240 t = one
   itemp = 1
250 scale(i) = t
   itype(i) = itemp
260 continue
end do
!
!     Set the soln vector x(*) to zero and the col interchange
!     matrix to the identity.
x(1) = zero
call scopy(n, x, 0, x, 1)
do i = 1,n
   ipivot(i) = i
270 continue
end do
go to 10
280 continue
!
!     To initially-triangularize
!
!     Set first l comps. Of dual vector to zero because
!     these correspond to the unconstrained variables.
if (.not.(l > 0)) go to 290
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
!
!     To compute-search-direction-and-feasible-point
!
!     Solve the triangular system of currently non-active
!     variables and store the solution in z(*).
!
!     Solve-system
igo958 = 310
go to 1110
!
!     Increment iteration counter and check against max. Number
!     of iterations.
310 iter = iter + 1
if (.not.(iter > itmax)) go to 320
mode = 1
done = .true.
!
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
!
!     To add-constraints
!
!     Use computed alpha to interpolate between last
!     feasible solution x(*) and current unconstrained
!     (and infeasible) solution z(*).
if (.not.(lp1 <= nsoln)) go to 390
do j = lp1,nsoln
   x(j) = x(j) + alpha*(z(j) - x(j))
380 continue
end do
390 feasbl = .false.
go to 410
400 if (feasbl) go to 20
!
!     Remove col JCON and shift cols JCON+1 through n to the
!     left. Swap col JCON into the n-TH position.  This achieves
!     upper Hessenberg form for the nonactive constraints and
!     leaves an upper Hessenberg matrix to retriangularize.
410 do i = 1,m
   t = w(i,jcon)
   call scopy(n - jcon, w(i,jcon + 1), mdw, w(i,jcon), mdw)
   w(i,n) = t
420 continue
end do
!
!     Update permuted index vector to reflect this shift and swap.
itemp = ipivot(jcon)
if (.not.(jcon < n)) go to 440
do i = jcon,nm1
   ipivot(i) = ipivot(i + 1)
430 continue
end do
440 ipivot(n) = itemp
!
!     Similarly repermute x(*) vector.
call scopy(n - jcon, x(jcon + 1), 1, x(jcon), 1)
x(n) = zero
nsp1 = nsoln
nsoln = nsoln - 1
niv1 = niv
niv = niv - 1
!
!     Retriangularize upper Hessenberg matrix after adding constraints.
j = jcon
i = krank + jcon - l
450 if (.not.(j <= nsoln)) go to 570
if (.not.(itype(i) == 0 .and. itype(i + 1) == 0)) go to 470
igo938 = 460
go to 620
!
!     (itype(i).EQ.0 .AND. itype(i+1).EQ.0) ZERO-IP1-TO-i-IN-COL-J
460 go to 560
470 if (.not.(itype(i) == 1 .and. itype(i + 1) == 1)) go to 490
igo938 = 480
go to 620
!
!     (itype(i).EQ.1 .AND. itype(i+1).EQ.1) ZERO-IP1-TO-i-IN-COL-J
480 go to 560
490 if (.not.(itype(i) == 1 .and. itype(i + 1) == 0)) go to 510
call sswap(np1, w(i,1), mdw, w(i + 1,1), mdw)
call sswap(1, scale(i), 1, scale(i + 1), 1)
itemp = itype(i + 1)
itype(i + 1) = itype(i)
itype(i) = itemp
!
!     Swapped row was formerly a pivot elt., So it will
!     be large enough to perform ELIM.
igo938 = 500
go to 620
!
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
!
!     See if the remaining coeffs in the soln set are feasible.  They
!     should be because of the way alpha was determined.  If any are
!     infeasible it is due to roundoff error.  Any that are non-
!     positive will be set to zero and removed from the soln set.
570 if (.not.(lp1 <= nsoln)) go to 590
do jcon = lp1,nsoln
   if (x(jcon) <= zero) go to 600
580 continue
end do
590 feasbl = .true.
600 continue
go to 400
620 continue
!
!     To zero-IP1-to-i-in-col-J
if (.not.(w(i + 1,j) /= zero)) go to 630
call srotmg(scale(i), scale(i + 1), w(i,j), w(i + 1,j), sparam)
w(i + 1,j) = zero
call srotm(np1 - j, w(i,j + 1), mdw, w(i + 1,j + 1), mdw, sparam)
630 go to 1290
!
!     To perform-multiplier-test-and-drop-A-constraint
!
640 call scopy(nsoln, z, 1, x, 1)
if (.not.(nsoln < n)) go to 650
x(nsp1) = zero
call scopy(n - nsoln, x(nsp1), 0, x(nsp1), 1)
650 i = niv1
660 if (.not.(i <= me)) go to 690
!
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
!
!     Form inner product vector wd(*) of dual coeffs.
690 if (.not.(nsp1 <= n)) go to 730
do j = nsp1,n
   sm = zero
   if (.not.(nsoln < m)) go to 710
   do i = nsp1,m
      sm = sm + scale(i)*w(i,j)*w(i,np1)
700   continue
   end do
710 wd(j) = sm
720 continue
end do
730 go to 750
740 if (pos .or. done) go to 970
!
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
770 continue
end do
780 if (.not.(wmax <= zero)) go to 790
done = .true.
go to 960
!
!     Set dual COEFF to zero for incoming col.
790 wd(iwmax) = zero
!
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
!
!     Reduce col NSOLN so that the matrix of nonactive
!     constraints variables is triangular.
800 j = m
810 if (.not.(j > niv)) go to 870
jm1 = j - 1
jp = jm1
!
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
!
!     Solve for z(NSOLN)=Proposed new value for x(NSOLN).
!     Test if this is nonpositive or too large.
!     If this was true or if the pivot term was zero reject
!     the col as dependent.
870 if (.not.(w(niv,nsoln) /= zero)) go to 890
isol = niv
igo897 = 880
go to 980
!
!     Test-proposed-new-component
880 go to 940
890 if (.not.(niv <= me .and. w(mep1,nsoln) /= zero)) go to 920
!
!     Try to add row MEP1 as an additional equality constraint.
!     Check size of proposed new soln component.
!     Reject it if it is too large.
isol = mep1
igo897 = 900
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
pos = z2 > zero
if (.not.(z2*eanorm >= bnorm .and. pos)) go to 990
pos = .not.(blowup*z2*eanorm >= bnorm)
990 go to 1280
1000 continue
!     To compute-final-solution
!
!     Solve system, store results in x(*).
!
igo958 = 1010
go to 1110
!     Solve-system
1010 call scopy(nsoln, z, 1, x, 1)
!
!     Apply Householder transformations to x(*) if KRANK.LT.l
if (.not.(0 < krank .and. krank < l)) go to 1030
do i = 1,krank
   call h12(2, i, krp1, l, w(i,1), mdw, h(i), x, 1, 1, 1)
1020 continue
end do
!
!     Fill in trailing zeroes for constrained variables not in soln.
1030 if (.not.(nsoln < n)) go to 1040
x(nsp1) = zero
call scopy(n - nsoln, x(nsp1), 0, x(nsp1), 1)
!
!     Repermute soln vector to natural order.
1040 do i = 1,n
   j = i
1050 if (ipivot(j) == i) go to 1060
   j = j + 1
   go to 1050
1060 ipivot(j) = ipivot(i)
   ipivot(i) = j
   call sswap(1, x(j), 1, x(i), 1)
1070 continue
end do
!
!     Rescale the soln using the col scaling.
do j = 1,n
   x(j) = x(j)*d(j)
1080 continue
end do
if (.not.(niv < m)) go to 1100
do i = niv1,m
   t = w(i,np1)
   if (i <= me) t = t/alamda
   t = (scale(i)*t)*t
   rnorm = rnorm + t
1090 continue
end do
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
1130 if (.not.(nsoln >= isol)) go to 1270
!
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
1180 continue
end do
!
1270 select case ( igo958 )
case ( 310 )
   go to 310
case ( 1010 )
   go to 1010
end select
1280 select case ( igo897 )
case ( 880 )
   go to 880
case ( 900 )
   go to 900
end select
1290 select case ( igo938 )
case ( 460 )
   go to 460
case ( 480 )
   go to 480
case ( 500 )
   go to 500
case ( 520 )
   go to 520
end select
end subroutine wnlsm

subroutine wnlit(w, mdw, m, n, l, ipivot, itype, h, scale, rnorm, &
   & idope, dope, done)
implicit none
integer, intent(in) :: l, m, mdw, n
real, intent(out) :: rnorm
real, intent(inout) :: w(mdw,*), h(*), scale(*)
real, intent(in) :: dope(*)
integer, intent(inout) :: itype(*), ipivot(*), idope(*)
logical, intent(inout) :: done
integer :: i, i1, ic, igo990, igo993, igo996, ip1, ir, irp1, &
   & itemp, j, j1, jj, jm1, jp, k, kk, krank, krp1, l1, lb, lend, lp1, &
   & max, me, mend, mep1, niv, niv1, np1, nsoln
real :: alsq, eanorm, fac, factor, hbar, rn, sn, t, tau, sparam(5)
integer :: isamax
logical :: indep, recalc
real, parameter :: tenm3 = 1.e-3
real, parameter :: zero = 0.e0
real, parameter :: one = 1.e0
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
lb = min(m - 1,l)
recalc = .true.
rnorm = zero
krank = 0
!     We set factor=1.E0 so that the heavy weight ALAMDA will be
!     included in the test for col independence.
factor = 1.e0
i = 1
ip1 = 2
lend = l
10 if (.not.(i <= lb)) go to 150
if (.not.(i <= me)) go to 130
!
!     Set ir to point to the i-TH row.
ir = i
mend = m
igo996 = 20
go to 460
!
!     Update-col-SS-and-find-pivot-col
20 igo993 = 30
go to 560
!
!     Perform-col-interchange
!
!     Set ic to point to i-TH col.
30 ic = i
igo990 = 40
go to 520
!
!     Test-indep-of-incoming-col
40 if (.not.(indep)) go to 110
!
!     Eliminate i-TH col below diag. Using mod. Givens transformations
!     applied to (A B).
j = m
do jj = ip1,m
   jm1 = j - 1
   jp = jm1
   if (.not.(jj == m)) go to 70
   if (.not.(i < mep1)) go to 80
   j = mep1
   jp = i
   t = scale(jp)*w(jp,i)**2*tau**2
   if (.not.(t > scale(j)*w(j,i)**2)) go to 130
   go to 80
70 if (.not.(j == mep1)) go to 80
   j = jm1
   jm1 = j - 1
   jp = jm1
80 if (.not.(w(j,i) /= zero)) go to 90
   call srotmg(scale(jp), scale(j), w(jp,i), w(j,i), sparam)
   w(j,i) = zero
   call srotm(np1 - i, w(jp,ip1), mdw, w(j,ip1), mdw, sparam)
90 j = jm1
100 continue
end do
go to 140
110 continue
if (.not.(lend > i)) go to 130
!
!     Col i is dependent. Swap with col lend.
max = lend
!
!     Perform-col-interchange
igo993 = 120
go to 560
120 continue
lend = lend - 1
!
!     Find col in remaining set with largest SS.
max = isamax(lend - i + 1,h(i),1) + i - 1
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
if (.not.(krank < me)) go to 290
factor = alsq
do i = krp1,me
   if (l > 0) w(i,1) = zero
   call scopy(l, w(i,1), 0, w(i,1), mdw)
170 continue
end do
!
!     Determine the rank of the remaining equality constraint
!     equations by eliminating within the block of constrained
!     variables.  Remove any redundant constraints.
!
ir = krp1
if (.not.(l < n)) go to 245
lp1 = l + 1
recalc = .true.
lb = min(l + me - krank,n)
i = lp1
ip1 = i + 1
180 if (.not.(i <= lb)) go to 280
ir = krank + i - l
lend = n
mend = me
igo996 = 190
go to 460
!
!     Update-col-SS-and-find-pivot-col
190 igo993 = 200
go to 560
!
!     Perform-col-interchange
!
!     Eliminate elements in the i-TH col.
200 j = me
210 if (.not.(j > ir)) go to 230
jm1 = j - 1
if (.not.(w(j,i) /= zero)) go to 220
call srotmg(scale(jm1), scale(j), w(jm1,i), w(j,i), sparam)
w(j,i) = zero
call srotm(np1 - i, w(jm1,ip1), mdw, w(j,ip1), mdw, sparam)
220 j = jm1
go to 210
!
!     Set ic=i=Col being eliminated
230 ic = i
igo990 = 240
go to 520
!
!     Test-indep-of-incoming-col
240 if (indep) go to 270
!
!     Remove any redundant or dependent equality constraints.
245 continue
jj = ir
250 if (.not.(ir <= me)) go to 260
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
if (.not.(krank < l1)) go to 420
!
!     Try to determine the variables KRANK+1 through L1 from the
!     least squares equations.  Continue the triangularization with
!     pivot element w(MEP1,i).
!
recalc = .true.
!
!     Set factor=alsq to remove effect of heavy weight from
!     test for col independence.
factor = alsq
kk = krp1
i = kk
ip1 = i + 1
310 if (.not.(i <= l1)) go to 410
!
!     Set ir to point to the MEP1-ST row.
ir = mep1
lend = l
mend = m
igo996 = 320
go to 460
!
!     Update-col-SS-and-find-pivot-col
320 igo993 = 330
go to 560
!
!     Perform-col-interchange
!
!     Eliminate i-TH col below the ir-TH element.
330 irp1 = ir + 1
if (.not.(irp1 <= m)) go to 355
j = m
do jj = irp1,m
   jm1 = j - 1
   if (.not.(w(j,i) /= zero)) go to 340
   call srotmg(scale(jm1), scale(j), w(jm1,i), w(j,i), sparam)
   w(j,i) = zero
   call srotm(np1 - i, w(jm1,ip1), mdw, w(j,ip1), mdw, sparam)
340 j = jm1
350 continue
end do
355 continue
!
!     Test if new pivot element is near zero. If so, the col is
!     dependent.
t = scale(ir)*w(ir,i)**2
indep = t > tau**2*eanorm**2
if (.not.indep) go to 380
!
!     Col test passed. Now must pass row norm test to be classified
!     as independent.
rn = zero
do i1 = ir,m
   do j1 = ip1,n
      rn = amax1(rn,scale(i1)*w(i1,j1)**2)
360   continue
   end do
370 continue
end do
indep = t > tau**2*rn
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
if (.not.(krank < l)) go to 450
do i = 1,krank
   j = krp1 - i
   call h12(1, j, krp1, l, w(j,1), mdw, h(j), w, mdw, 1, j - 1)
440 continue
end do
450 niv = krank + nsoln - l
niv1 = niv + 1
if (l == n) done = .true.
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
if (.not.(ir /= 1 .and. (.not.recalc))) go to 480
!     Update col SS =Sum of squares.
do j = i,lend
   h(j) = h(j) - scale(ir - 1)*w(ir - 1,j)**2
470 continue
end do
!
!     Test for numerical accuracy.
max = isamax(lend - i + 1,h(i),1) + i - 1
recalc = hbar + tenm3*h(max) == hbar
!
!     If required, recalculate col SS, using rows ir through mend.
480 if (.not.(recalc)) go to 510
do j = i,lend
   h(j) = zero
   do k = ir,mend
      h(j) = h(j) + scale(k)*w(k,j)**2
490   continue
   end do
500 continue
end do
!
!     Find col with largest SS.
max = isamax(lend - i + 1,h(i),1) + i - 1
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
!     set to alsq=ALAMDA**2 to remove the effect of the heavy weight
!     from the test for independence.
!
!     Write new col as partitioned vector
!             (A1)  number of components in soln so far = NIV
!             (A2)  m-NIV COMPONENTS
!     and compute  sn = Inverse weighted length of A1
!                  rn = Inverse weighted length of A2
!     CALL THE COL INDEPENDENT WHEN rn .GT. tau*sn
sn = zero
rn = zero
do j = 1,mend
   t = scale(j)
   if (j <= me) t = t/factor
   t = t*w(j,ic)**2
   if (.not.(j < ir)) go to 530
   sn = sn + t
   go to 540
530 rn = rn + t
540 continue
550 continue
end do
indep = rn > tau**2*sn
go to 590
560 continue
!
!     To perform-col-interchange
!
if (.not.(max /= i)) go to 570
!     Exchange elements of permuted index vector and perform col
!     interchanges.
itemp = ipivot(i)
ipivot(i) = ipivot(max)
ipivot(max) = itemp
call sswap(m, w(1,max), 1, w(1,i), 1)
t = h(max)
h(max) = h(i)
h(i) = t
570 select case ( igo993 )
case ( 30 )
   go to 30
case ( 200 )
   go to 200
case ( 330 )
   go to 330
case ( 120 )
   go to 120
end select
590 select case ( igo990 )
case ( 40 )
   go to 40
case ( 240 )
   go to 240
end select
600 select case ( igo996 )
case ( 20 )
   go to 20
case ( 190 )
   go to 190
case ( 320 )
   go to 320
end select
end subroutine wnlit

pure subroutine l2slv(m, n, m1, l, a, mm, b, mb, w, tol, n1, ipivot, &
   & x, nn, res, mr, qr, mmpnn, c, ifault)
implicit none
integer, intent(inout) :: ifault
integer, intent(in) :: l, m, m1, mb, mm, mmpnn, mr, n
integer, intent(inout) :: n1
integer, intent(in) :: nn
integer, intent(inout) :: ipivot(n)
real, intent(in) :: a(mm,n), b(mb,l)
real, intent(inout) :: c(*)
real, intent(inout) :: qr(mmpnn,n), res(mr,l), tol, w(m), x(nn,l)
integer :: i, iter, j, jm1, k, k0, k1, k10, k11, k12, k2, k3, k4, &
   & k5, k6, k7, k8, k9, ksum, m1p1, mp1, mpi, mpn, numit
real :: eta, digitx
logical :: fail, sing
interface
   pure subroutine covar(n,m1,n1,ipivot,c,d,z,nn)
      implicit none
      integer, intent(in) :: nn
      integer, intent(in) :: n
      integer, intent(in) :: m1
      integer, intent(in) :: n1
      integer, intent(in) :: ipivot(n)
      real, intent(inout) :: c(nn,n)
      real, intent(in) :: d(*)
      real, intent(inout) :: z(*)
   end subroutine covar
   pure subroutine decom2(m,n,m1,eta,tol,qr,d,n1,ipivot,sing, &
      & mmpnn)
      implicit none
      integer, intent(in) :: mmpnn
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: m1
      real, intent(in) :: eta
      real, intent(in) :: tol
      real, intent(inout) :: qr(mmpnn,n)
      real, intent(inout) :: d(*)
      integer, intent(out) :: n1
      integer, intent(inout) :: ipivot(n)
      logical, intent(out) :: sing
   end subroutine decom2
   pure subroutine solve2(m,n,m1,a,b,w,n1,ipivot,qr,d,eta,fail, &
      & numit,digitx,x,res,wres,y1,y2,y,f,g,mm,mmpnn)
      implicit none
      integer, intent(in) :: mmpnn
      integer, intent(in) :: mm
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(in) :: m1
      real, intent(in) :: a(mm,n)
      real, intent(in) :: b(*)
      real, intent(in) :: w(m)
      integer, intent(in) :: n1
      integer, intent(in) :: ipivot(n)
      real, intent(in) :: qr(mmpnn,n)
      real, intent(in) :: d(*)
      real, intent(in) :: eta
      logical, intent(inout) :: fail
      integer, intent(out) :: numit
      real, intent(inout) :: digitx
      real, intent(inout) :: x(*)
      real, intent(inout) :: res(*)
      real, intent(inout) :: wres(*)
      real, intent(inout) :: y1(*)
      real, intent(inout) :: y2(*)
      real, intent(inout) :: y(*)
      real, intent(inout) :: f(*)
      real, intent(inout) :: g(*)
   end subroutine solve2
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
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
! diagonal elements nonnegative.  Let H = w*a.
! In the event that n1 (the computed rank of matrix H) is less than n
! (the number of unknown coefficients), a unique solution vector having
! n elements can be obtained by imposing the condition that the
! solution be of minimal Euclidean norm.  Such a solution is sought in
! the case of underdetermined or rank-deficient problems.
!
! ** Input variables **
! m      TOTAL NUMBER OF EQUATIONS.
! n      NUMBER OF UNKNOWN COEFFICIENTS.
! m1     number of linear constraints (0.LE.m1.LE.m and m1.LE.n).
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
!        the array a.  mm must satisfy mm.GE.M.
! mb     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        the array b.  mb must satisfy mb.GE.M.
! mr     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        the array res.  mr must satisfy mr.GE.M.
! nn     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
!        the array x.  nn must satisfy nn.GE.N.
! mmpnn  dimensioning parameter specifying maximum number of rows in
!        the array qr.  mmpnn must satisfy mmpnn.GE.m+n.
!
! ** Output variables and internal variables **
! n1     computed rank of matrix H, where H = w*a.
! ipivot vector of size n.  on exit, this array records the order
!        in which the columns of H were selected by the pivoting
!        scheme in the course of the orthogonal decomposition.
!        Whenever n1.LT.n, the first n1 elements of ipivot indicate
!        which columns of H were found to be linearly independent.
! x      TWO-DIMENSIONAL ARRAY OF size (nn,l).  ON EXIT, x CONTAINS
!        the solution vectors.
! RES    TWO-DIMENSIONAL ARRAY OF size (mr,l).  ON EXIT, RES CONTAINS
!        the residual vectors.
! QR     two-dimensional array of size (mmpnn,n).  On exit, if n1 = n
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
!            On exit, c(k) = +NUMIT if the solution converged, and
!                     c(k) = -NUMIT if the solution failed to converge.
!        (b) digitx gives an estimate of the number of correct digits
!            in the initial solution of the coefficients for the k-TH
!            right-hand side.  On exit, c(k+l) = digitx.
! ifault fault indicator which is zero if no errors were encountered
!        and positive if errors were detected or if evidence of severe
!        ill-conditioning was found.  If ifault is set to 1, 2, 3, 4,
!        5, 6 or 7, execution is terminated.  Execution continues when
!        ifault is set equal to 8, 9 or 10 provided that a solution
!        was obtained for at least one right-hand side.  The value of
!        ifault is used to indicate the following --
!        0 = No errors encountered.
!        1 = Bad input parameter (m, n or l).
!        2 = Bad input parameter (m1).
!        3 = Bad dimension.  Either m.GT.mm, m.GT.mb, m.GT.mr,
!            n.GT.nn, OR m+n.GT.MMPNN.
!        4 = At least one weight is negative.
!        5 = Either matrix H or matrix of constraints equals zero.
!        6 = Constraints are linearly dependent.
!        7 = All solutions failed to converge.
!        8 = Solution failed to converge for at least one right-hand
!            side.
!        9 = Large number of iterations required for convergence.
!       10 = Estimated number of digits in initial solution of
!            coefficients is small.
!       11 = Diagonal element of covariance matrix was computed to be
!            negative owing to rounding error. No severe conditioning
!            problems were detected.
!       12 = Diagonal element of covariance matrix was computed to be
!            negative owing to rounding error. The problem appears to
!            be extremely ill-conditioned.
!
! ** Subroutines required **
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
! ** Storage requirements **
! the storage required for the dimensioned arrays in l2slv is
!   m*(2*n + 2*l + 7) + n*(n + l + 7) + 2*l
! locations.  All arrays required in subroutines called by l2slv are
! declared herein and are transmitted only through parameter lists of
! CALL-SEQUENCES.
!
! ** Precision of arithmetic calculations **
! single precision arithmetic is used for all calculations except the
! double precision accumulation of inner products.  (The variable SUM
! is declared to be double precision in subroutines decom2, solve2,
! solve3 and covar.)  It is essential for the success of the iterative
! refinement procedure that inner products be accumulated in double
! precision.
!
! ** Conversion of the program to double precision **
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
! *    for IBM computer type, eta = 16.**(-13)                        *
! *    for Univac computer type, eta = 2.**(-59)                      *
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
if (tol < 0.0) tol = 0.0
ifault = 0
ksum = 0
!
! Perform initial checking of input parameters, dimensions and
! weights for possible errors.
!
if (m > 0 .and. n > 0 .and. l > 0) go to 10
ifault = 1
return
10 if (m1 <= m .and. m1 <= n .and. m1 >= 0) go to 20
ifault = 2
return
20 if (m <= mm .and. m <= mb .and. m <= mr .and. n <= nn &
   & .and. m + n <= mmpnn) go to 30
ifault = 3
return
30 do i = 1,m
   if (m1 > 0 .and. i <= m1) w(i) = 1.0
   if (w(i) >= 0.0) go to 40
   ifault = 4
   return
40 continue
end do
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
do i = 1,k
   c(i) = 0.0
end do
mp1 = m + 1
mpn = m + n
do j = 1,n
   do i = 1,m
      qr(i,j) = a(i,j)*w(i)
   end do
   do i = mp1,mpn
      qr(i,j) = 0.0
   end do
end do
!
! Obtain an orthogonal decomposition of the matrix stored in the first
! m rows of array qr and compute its rank.
!
call decom2(m, n, m1, eta, tol, qr, c(k3), n1, ipivot, sing, &
   & mmpnn)
!
if (.not.sing) go to 110
if (n1 > 0) go to 100
ifault = 5
return
100 ifault = 6
return
!
! Seek a solution (coefficients and residuals) for each of the l least
! squares problems whose right-hand sides are given in the array b.
!
110 iter = -log10(eta)
do k = 1,l
! k-TH right-hand side.
   k0 = k4 - 1
   do i = 1,m
      k0 = k0 + 1
      c(k0) = b(i,k)
   end do
!
   call solve2(m, n, m1, a, c(k4), w, n1, ipivot, qr, c(k3), &
      & eta, fail, numit, digitx, &
      & c(k5), c(k6), c(k7), c(k8), c(k9), c(k10), c(k11), c(k12), &
      & mm, mmpnn)
!
   k0 = k5 - 1
   do j = 1,n
      k0 = k0 + 1
      x(j,k) = c(k0)
   end do
   if (m1 == 0) go to 150
   do i = 1,m1
      res(i,k) = 0.0
   end do
150 m1p1 = m1 + 1
   if (m1p1 > m) go to 170
   k0 = k6 + m1 - 1
   do i = m1p1,m
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
180 if (numit <= iter) go to 190
   ifault = 9
190 if (digitx >= 0.5) go to 200
   ifault = 10
200 continue
end do
if (ksum < l) go to 210
ifault = 7
return
210 if (n1 < n) return
do i = 1,n
   mpi = m + i
   do j = 1,n
      qr(i,j) = qr(mpi,j)
   end do
   qr(i,i) = 0.0
end do
!
! Compute the unscaled covariance matrix of the coefficients.
!
call covar(n, m1, n1, ipivot, qr, c(k3), c(k9), mmpnn)
if (n == 1) go to 260
do j = 2,n
   jm1 = j - 1
   do i = 1,jm1
240   qr(i,j) = qr(j,i)
   end do
end do
!
! In certain problems, some diagonal terms of the unscaled covariance
! matrix are equal to zero or to small positive numbers.  Because of
! rounding errors, computed values for these terms may be small
! negative numbers.  ifault is set to 11 if this occurs.
!
260 do j = 1,n
   if (qr(j,j) < 0.0) go to 280
end do
return
280 if (ifault /= 0) go to 290
ifault = 11
return
290 ifault = 12
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
!         (float(n)*eta)**2*D(m1+1) at statement DC2 1170.
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
! On exit, sing is set equal to .TRUE. whenever
!     (1) n1 = 0 (I.E., input matrix qr equals zero or matrix of
!         constraints equals zero), or
!     (2) n1 is less than m1 (I.E., the m1 by n matrix of linear
!         constraints is singular).
! Otherwise, on exit from decom2, sing = .FALSE.
! On exit, the vector ipivot records the order in which the columns
! of QR were selected by the pivoting scheme in the course of the
! orthogonal decomposition.
pure subroutine decom2(m, n, m1, eta, tol, qr, d, n1, ipivot, sing, &
   & mmpnn)
implicit none
integer, intent(in) :: m, m1, mmpnn, n
integer, intent(out) :: n1
integer, intent(inout) :: ipivot(n)
real, intent(inout) :: d(*)
real, intent(in) :: eta
real, intent(inout) :: qr(mmpnn,n)
real, intent(in) :: tol
logical, intent(out) :: sing
integer :: ik, j, jj, k, km1, l, lmm, mh, mp1, mpn1, ms, mv, np, &
   & ns, nsp1
real :: c, dm, ds, rsj, tol2
double precision :: sum
logical :: finis, fsum
n1 = 0
sing = .true.
fsum = .true.
mv = 1
mh = m1
ms = m
mp1 = m + 1
finis = .false.
if (tol > 0.0) tol2 = tol
do j = 1,n
   d(j) = 0.0
   ipivot(j) = j
end do
! Step number NS of the decomposition.
do ns = 1,n
   k = m + ns
   if (ns == m1 + 1) go to 20
   go to 30
20 if (m1 == m) go to 200
   mv = m1 + 1
   mh = m
   fsum = .true.
30 if (.not.finis) go to 40
   go to 150
! Pivot search.
40 ds = 0.0
   np = ns
   do j = ns,n
      if (fsum) go to 50
      go to 70
50    sum = 0.0
      do l = mv,mh
         sum = sum + dble(qr(l,j))*dble(qr(l,j))
      end do
      d(j) = sum
70    if (ds < d(j)) go to 80
      go to 90
80    ds = d(j)
      np = j
90    continue
   end do
   if (fsum) dm = ds
   if (ds < eta*dm) go to 100
   fsum = .false.
   go to 110
100 fsum = .true.
110 if (fsum) go to 40
   if (np /= ns) go to 120
   go to 140
! Column interchange.
120 ik = ipivot(np)
   ipivot(np) = ipivot(ns)
   ipivot(ns) = ik
   d(np) = d(ns)
   km1 = k - 1
   do l = 1,km1
      c = qr(l,np)
      qr(l,np) = qr(l,ns)
      qr(l,ns) = c
   end do
! END COLUMN INTERCHANGE.
! END PIVOT SEARCH.
! RETURN HERE IF n1 = 0.  EITHER INPUT MATRIX qr EQUALS ZERO OR
! matrix of constraints equals zero.
140 if (ns == 1 .and. ds == 0.0) return
   go to 160
150 ms = k - 1
   mh = k - 1
160 if (finis) go to 170
   c = 0.0
   go to 180
170 c = 1.0
180 sum = dble(c)
   do l = mv,mh
      sum = sum + dble(qr(l,ns))*dble(qr(l,ns))
   end do
   d(ns) = sum
   ds = d(ns)
   if (tol == 0.0) tol2 = (float(n)*eta)**2*d(m1 + 1)
   if (.not.finis .and. ns > m1 .and. ds <= tol2) go to 200
   go to 290
200 finis = .true.
   mv = m + 1
   do np = ns,n
      if (1 > m1) go to 250
      do l = 1,m1
         qr(l,np) = 0.0
      end do
      do j = 1,m1
         sum = 0.0
         do l = 1,m
            sum = sum + dble(qr(l,j))*dble(qr(l,np))
         end do
         c = sum
         c = c/d(j)
         do l = 1,m1
            qr(l,np) = qr(l,np) - c*qr(l,j)
         end do
      end do
250   mpn1 = m + n1
      do jj = mp1,mpn1
         j = (m + 1) + (m + n1) - jj
         sum = 0.0
         do l = j,mpn1
            lmm = l - m
            sum = sum + dble(qr(j,lmm))*dble(qr(l,np))
         end do
         qr(j,np) = -sum
      end do
   end do
   go to 150
! RETURN HERE IF MATRIX OF CONSTRAINTS IS FOUND TO BE SINGULAR.
290 if (ds == 0.0) return
   qr(k,ns) = -1.0
   nsp1 = ns + 1
   if (nsp1 > n) go to 340
! Begin orthogonalization.
   do j = nsp1,n
      sum = 0.0
      do l = mv,mh
         sum = sum + dble(qr(l,j))*dble(qr(l,ns))
      end do
      rsj = sum
      rsj = rsj/ds
      qr(k,j) = rsj
      do l = 1,ms
         qr(l,j) = qr(l,j) - rsj*qr(l,ns)
      end do
      if (.not.finis) go to 320
      go to 330
320   d(j) = d(j) - ds*rsj*rsj
330   continue
   end do
! END ORTHOGONALIZATION.
340 if (.not.finis) n1 = n1 + 1
end do
! END STEP NUMBER NS.
sing = .false.
! Normal return.
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
! On exit, fail is set equal to .TRUE. if the solution fails to
! improve sufficiently.  Otherwise, fail = .FALSE.  information on the
! behavior of the iterative refinement procedure is given by NUMIT and
! DIGITX.  NUMIT is the number of iterations carried out in attempting
! to obtain a solution.  DIGITX is an estimate of the number of
! correct digits in the initial solution of the coefficients.
! This subroutine calls subroutine solve3.
!
! ********* Conversion of this subroutine to double precision *********
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
pure subroutine solve2(m, n, m1, a, b, w, n1, ipivot, qr, d, &
   & eta, fail, numit, digitx, &
   & x, res, wres, y1, y2, y, f, g, mm, mmpnn)
implicit none
integer, intent(in) :: m, m1, mm, mmpnn, n, n1
integer, intent(out) :: numit
integer, intent(in) :: ipivot(n)
real, intent(in) :: a(mm,n), b(*)
real, intent(in) :: d(*)
real, intent(inout) :: f(*), g(*)
real, intent(in) :: qr(mmpnn,n)
real, intent(inout) :: res(*)
real, intent(in) :: w(m)
real, intent(inout) :: wres(*), x(*), y(*), y1(*), y2(*)
real, intent(inout) :: digitx
real, intent(in) :: eta
logical, intent(inout) :: fail
integer :: i, j, k, kz, l, mp1, mpn, n1p1, np, ns
real :: c, dxnorm, eta2, rdr1, rdr2, rdx1, rdx2, rnr, rnx, xnorm
double precision :: sum
interface
   pure subroutine solve3(f,m1,m,n1,qr,d,y,mmpnn)
      implicit none
      integer, intent(in) :: mmpnn
      integer, intent(in) :: n1
      real, intent(inout) :: f(*)
      integer, intent(in) :: m1
      integer, intent(in) :: m
      real, intent(in) :: qr(mmpnn,n1)
      real, intent(in) :: d(*)
      real, intent(inout) :: y(*)
   end subroutine solve3
end interface
numit = 0
kz = 0
eta2 = eta*eta
mp1 = m + 1
mpn = m + n
n1p1 = n1 + 1
do i = 1,m
   f(i) = b(i)*w(i)
   g(i) = 0.0
   wres(i) = 0.0
   res(i) = 0.0
   y1(i) = 0.0
   if (w(i) == 0.0) kz = kz + 1
10 continue
end do
do ns = 1,n
   j = m + ns
   f(j) = 0.0
   g(j) = 0.0
   x(ns) = 0.0
   y2(ns) = 0.0
end do
k = 0
rdx2 = 0.0
rdr2 = 0.0
! Begin k-TH iteration step.
30 if (k < 2) go to 40
if (((64.*rdx2 < rdx1) .and. (rdx2 > eta2*rnx)) .or. &
   & ((64.*rdr2 < rdr1) .and. (rdr2 > eta2*rnr))) go to 40
go to 270
40 rdx1 = rdx2
rdr1 = rdr2
rdx2 = 0.0
rdr2 = 0.0
if (k == 0) go to 160
! New residuals.
do i = 1,m
   wres(i) = wres(i) + f(i)*w(i)
   if (w(i) == 0.0) go to 50
   res(i) = res(i) + f(i)/w(i)
   y1(i) = y1(i) + g(i)
50 continue
end do
do ns = 1,n
   j = m + ns
   np = ipivot(ns)
   x(np) = x(np) + f(j)
   y2(np) = y2(np) + g(j)
   sum = -dble(x(np))
   do l = 1,m
      sum = sum + dble(a(l,np))*dble(y1(l))
   end do
   g(j) = -sum
   if (ns > n1) go to 70
   go to 80
70 f(j) = 0.0
   go to 100
80 sum = 0.0
   do l = 1,m
      sum = sum + dble(a(l,np))*dble(wres(l))
   end do
   f(j) = -sum
100 continue
end do
do i = 1,m
   sum = 0.0
   if (i > m1) sum = dble(res(i))
   do l = 1,n
      sum = sum + dble(a(i,l))*dble(x(l))
   end do
   sum = sum - dble(b(i))
   f(i) = -sum
   f(i) = f(i)*w(i)
   if (w(i) == 0.0) res(i) = dble(res(i)) - sum
   sum = 0.0
   if (i > m1) sum = dble(y1(i))
   do l = 1,n
      sum = sum + dble(a(i,l))*dble(y2(l))
   end do
   g(i) = -sum
end do
if (n1p1 > n) go to 160
do i = n1p1,n
   ns = n + n1p1 - i
   j = m + ns
   sum = 0.0
   do l = 1,j
      sum = sum + dble(qr(l,ns))*dble(g(l))
   end do
   g(j) = sum
end do
! END NEW RESIDUALS.
!
160 call solve3(f, m1, m, n1, qr, d, y, mmpnn)
!
if (n1p1 > n) go to 200
do ns = n1p1,n
   j = m + ns
   sum = dble(g(j))
   do l = mp1,j
      sum = sum + dble(qr(l,ns))*dble(f(l))
   end do
   c = sum
   c = c/d(ns)
   do i = 1,j
      f(i) = f(i) - c*qr(i,ns)
   end do
end do
200 do j = mp1,mpn
   g(j) = 0.0
   if (j <= m + n1) g(j) = g(j) + f(j)
end do
!
call solve3(g, m1, m, n1, qr, d, y, mmpnn)
!
do i = 1,m
   rdr2 = rdr2 + f(i)*f(i)
end do
do i = mp1,mpn
   rdx2 = rdx2 + f(i)*f(i)
end do
if (k /= 0) go to 240
rnr = rdr2
rnx = rdx2
240 if (k /= 1) go to 260
xnorm = sqrt(rnx)
dxnorm = sqrt(rdx2)
if (xnorm /= 0.0) go to 250
digitx = -log10(eta)
go to 260
250 digitx = -log10(max(dxnorm/xnorm,eta))
! END k-TH ITERATION STEP.
260 numit = k
k = k + 1
go to 30
270 if ((m1 + kz == m) .and. (rdx2 > 4.*eta2*rnx)) go to 280
if ((rdr2 > 4.*eta2*rnr) .and. &
   & (rdx2 > 4.*eta2*rnx)) go to 280
fail = .false.
return
280 fail = .true.
end subroutine solve2

pure subroutine solve3(f, m1, m, n1, qr, d, y, mmpnn)
implicit none
integer, intent(in) :: m, m1, mmpnn, n1
real, intent(in) :: d(*)
real, intent(inout) :: f(*)
real, intent(in) :: qr(mmpnn,n1)
real, intent(inout) :: y(*)
integer :: j, l, lmm, mh, mpl, mpn1, mv, ns, nsm1
real :: c
double precision :: sum
! Subroutine solve3 is called only by subroutine solve2.
! This subroutine calculates new values of f.
mv = 1
mh = m1
do ns = 1,n1
   j = m + ns
   if (ns == m1 + 1) go to 10
   go to 20
10 mv = m1 + 1
   mh = m
20 nsm1 = ns - 1
   sum = -dble(f(j))
   if (ns == 1) go to 40
   do l = 1,nsm1
      mpl = m + l
      sum = sum + dble(qr(mpl,ns))*dble(y(l))
   end do
40 y(ns) = -sum
   if (ns > m1) go to 50
   go to 60
50 c = -y(ns)
   go to 70
60 c = 0.0
70 sum = dble(c)
   do l = mv,mh
      sum = sum + dble(qr(l,ns))*dble(f(l))
   end do
   c = sum
   c = c/d(ns)
   f(j) = c
   do l = mv,m
      f(l) = f(l) - c*qr(l,ns)
   end do
end do
if (1 > m1) go to 150
do l = 1,m1
   f(l) = 0.0
end do
do ns = 1,m1
   sum = -dble(y(ns))
   do l = 1,m
      sum = sum + dble(qr(l,ns))*dble(f(l))
   end do
   c = sum
   c = c/d(ns)
   do l = 1,m1
      f(l) = f(l) - c*qr(l,ns)
   end do
end do
150 do ns = 1,n1
   j = m + n1 + 1 - ns
   mpn1 = m + n1
   sum = 0.0
   do l = j,mpn1
      lmm = l - m
      sum = sum + dble(qr(j,lmm))*dble(f(l))
   end do
   f(j) = -sum
end do
end subroutine solve3

pure subroutine covar(n, m1, n1, ipivot, c, d, z, nn)
implicit none
integer, intent(in) :: m1, n, n1, nn
integer, intent(in) :: ipivot(n)
real, intent(inout) :: c(nn,n)
real, intent(in) :: d(*)
real, intent(inout) :: z(*)
integer :: i, j, k, ka, l, n1p1
double precision :: sum
! Subroutine covar uses results from the orthogonal decomposition
! stored in c, d and ipivot to compute the unscaled covariance matrix
! of the least squares coefficients.
! On entry, the first n rows and the first n columns of c contain the
! upper triangular matrix obtained from the decomposition.  This input
! matrix is destroyed in subsequent calculations.
! On exit, the lower triangular portion of the symmetric unscaled
! covariance matrix is contained in
!     c(1,1)
!     c(2,1) c(2,2)
!     . . .
!     c(n,1) c(n,2) ... c(n,n)
! if n1 is less than n, one or more columns of the matrix
! H = (sqrt(W))*a were rejected as being linearly dependent.  Whenever
! the k-TH column of H was so rejected, c(i,j) is set equal to zero,
! FOR i = k OR j = k, i.GE.J.
l = n1
if (l > m1) c(l,l) = 1.0/d(l)
if (l == 1) go to 60
10 j = l - 1
if (j > m1) c(j,j) = 1.0/d(j)
do k = l,n1
   z(k) = c(j,k)
end do
i = n1
do ka = j,n1
   sum = 0.0
   if (i == j) sum = dble(c(i,j))
   do k = l,n1
      sum = sum - dble(z(k))*dble(c(k,i))
   end do
   c(i,j) = sum
   i = i - 1
end do
do k = l,n1
   c(j,k) = c(k,j)
end do
l = l - 1
if (l > 1) go to 10
60 if (n1 == n) go to 90
n1p1 = n1 + 1
do i = 1,n
   do j = n1p1,n
      c(i,j) = 0.0
   end do
end do
! Permute the columns and rows of matrix c to account for pivoting.
90 do i = 1,n
   do j = 1,n
      k = ipivot(j)
      z(k) = c(i,j)
   end do
   do j = 1,n
      c(i,j) = z(j)
   end do
end do
do i = 1,n
   do j = 1,n
      k = ipivot(j)
      z(k) = c(j,i)
   end do
   do j = i,n
      c(j,i) = z(j)
   end do
end do
end subroutine covar

subroutine splsq(m,n,a,ia,ja,damp,u,x,atol,btol,conlim,itnlim, &
   & istop,itn,acond,rnorm,xnorm,w)
implicit none
integer, intent(in) :: m
integer :: n
integer, intent(in) :: itnlim
integer, intent(inout) :: istop
integer, intent(in) :: ia(*), ja(*)
real, intent(in) :: a(*), damp
real, intent(inout) :: u(m), x(n)
real, intent(in) :: atol, btol, conlim
real, intent(inout) :: acond, rnorm, xnorm, w(*)
integer, intent(inout) :: itn
integer :: npi, i, nconv, nstop
real :: alfa, anorm, arnorm, bbnorm, beta, bnorm, cs, cs1, cs2, &
   & ctol, dampsq, ddnorm, delta, gamma, gambar, one, phi, phibar, psi, &
   & res1, res2, rho, rhobar, rhbar1, rhbar2, rhs, rtol, sn, sn1, sn2, &
   & t, tau, test1, test2, test3, theta, t1, t2, t3, xxnorm, z, zbar, &
   & zero
!
!     ------------------------------------------------------------------
!
!     splsq finds a solution x to the following problems ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  a*x = B
!
!     2. Linear least squares  --    solve  a*x = B
!                                    in the least-squares sense
!
!     3. Damped least squares  --    solve  (   a    )*x = ( B )
!                                           ( damp*i )     ( 0 )
!                                    in the least-squares sense
!
!     Where A is a matrix with m rows and n columns, B an m-vector,
!     and damp a scalar. (All quantities are real.) The matrix a is
!     a sparse matrix stored rowwise in the arrays A,ia,ja.
!
!     The RHS vector B is input via u, and is subsequently overwritten.
!
!
!     Note. splsq uses an iterative method to approximate the solution.
!     The number of iterations required to reach a certain accuracy
!     depends strongly on the scaling of the problem. Poor scaling of
!     the rows or columns of A should therefore be avoided whenever
!     possible.
!
!     For example, in problem 1 the solution is unaltered by
!     row-scaling.  If a row of A is very small or large compared to
!     the other rows of A, the corresponding row of (A  B) should be
!     scaled up or down.
!
!     In problems 1 and 2, the solution x is easily recovered
!     following column scaling. In the absence of better information,
!     the nonzero columns of A should be scaled so that they all have
!     the same Euclidean norm (E.G.  1.0).
!
!     In problem 3, there is no freedom to RE-scale if damp is
!     nonzero. However, the value of damp should be assigned only
!     after attention has been paid to the scaling of A.
!
!     The parameter damp is intended to help regularize
!     ill-conditioned systems, by preventing the true solution from
!     being very large. Another aid to regularization is provided by
!     the parameter acond, which may be used to terminate iterations
!     before the computed solution becomes very large.
!
!
!     Notation
!     --------
!
!     The following quantities are used in discussing the subroutine
!     parameters...
!
!     abar   =  (   a    ),          bbar  =  ( b )
!               ( damp*i )                    ( 0 )
!
!     r      =  b  -  a*x,           rbar  =  bbar  -  abar*x
!
!     rnorm  =  sqrt( norm(r)**2  +  damp**2 * norm(x)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  The smallest floating point number for which
!               1 + RELPR .GT. 1.
!
!     splsq  minimizes the function rnorm with respect to x.
!
!
!     Parameters
!     ----------
!
!     m       INPUT      THE NUMBER OF ROWS IN A.
!
!     n       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     a,ia,ja INPUT      THE MATRIX a STORED ROWWISE IN SPARSE FORM.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (Damp  should be 0.0 for problems 1 and 2.)
!                        if the system  a*x = B  is incompatible, values
!                        of damp in the range 0 to sqrt(RELPR)*norm(a)
!                        will probably have a negligible effect.
!                        Larger values of damp will tend to decrease
!                        the norm of x and to reduce the number of
!                        iterations required by splsq.
!
!                        The work per iteration and the storage needed
!                        by splsq are the same for all values of damp.
!
!     u(m)    INPUT      THE RHS VECTOR B. BE AWARE THAT u IS
!                        over-written by splsq.
!
!     x(n)    OUTPUT     RETURNS THE COMPUTED SOLUTION x.
!
!     atol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the matrix a. for example,
!                        if A is accurate to about 6 digits, set
!                        atol = 1.0e-6 .
!
!     btol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the RHS vector B. for example,
!                        if B is accurate to about 6 digits, set
!                        btol = 1.0e-6 .
!
!     conlim  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        condition number of the matrix abar.
!                        Iterations will be terminated if a computed
!                        estimate of cond(ABAR) exceeds conlim.
!                        This is intended to prevent certain small or
!                        zero singular values of A or ABAR from
!                        coming into effect and causing unwanted growth
!                        in the computed solution.
!
!                        conlim and damp may be used separately or
!                        together to regularize ill-conditioned systems.
!
!                        Normally, conlim should be in the range
!                        1000  TO  1/RELPR.
!                        Suggested value --
!                        conlim = 1/(100*RELPR)  for compatible systems,
!                        conlim = 1/(10*sqrt(RELPR))  for least squares.
!
!             Note. If the user is not concerned about the parameters
!             atol, btol, and conlim, any or all of them may be set
!             to zero. The effect will be the same as the values
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     itnlim  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        Suggested value --
!                        itnlim = n/2     for well conditioned systems,
!                        itnlim = 4*n     OTHERWISE.
!
!     istop   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       x = 0  Is the exact solution.
!                        No iterations were performed.
!
!                1       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is sufficiently
!                        small, given the values of atol and btol.
!
!                2       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is sufficiently accurate,
!                        given the value of atol.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        conlim. The system  a*x = B  appears to be
!                        ill-conditioned.
!
!                4       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is as small as
!                        seems reasonable on this machine.
!
!                5       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is as accurate as seems
!                        reasonable on this machine.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        not much point in doing further iterations,
!                        given the precision of this machine.
!
!                7       THE ITERATION LIMIT itnlim WAS REACHED.
!
!
!     itn     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     acond   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        number of ABAR.
!
!     rnorm   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        the function being minimized (see notation
!                        above). This will be small if  a*x = B  has
!                        A SOLUTION.
!
!     xnorm   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        solution vector x.
!
!     w(2*n)             WORKSPACE
!
!     anorm   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        This is the square root of the sum of squares
!                        of the elements of ABAR.
!                        If damp is small and if the columns of A
!                        have all been scaled to have length  1.0,
!                        anorm should increase to roughly sqrt(n).
!
!     arnorm  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        norm( ABAR(transpose)*RBAR ), the norm of
!                        the residual for the usual normal equations.
!                        This should be small in all cases. (arnorm
!                        will often be smaller than the true value
!                        computed from the output vector x.)
!
!
!     Subroutines and functions used
!     ------------------------------
!
!                normlz,mvprd1,mtprd1
!     BLAS       scopy,snrm2,sscal  (SEE LAWSON ET AL. BELOW)
!                (snrm2 is used only in normlz)
!     FORTRAN    ABS,SQRT
!
!
!     References
!     ----------
!
!     Paige, C.C. and saunders, M.A.  lsqr, an algorithm for sparse
!        linear equations and sparse least squares.
!        ACM transactions on mathematical software 8, 1 (March 1982).
!
!     Lawson, C.L., Hanson, R.J., kincaid, D.R. and krogh, F.T.
!        BASIC linear algebra subprograms for Fortran usage.
!        ACM transactions on mathematical software 5, 3 (sept 1979),
!        308-323 and 324-325.
!
!     ------------------------------------------------------------------
!
!     Local variables
!
!
!
!     Initialize.
!
zero = 0.0
one = 1.0
ctol = zero
if (conlim > zero) ctol = one/conlim
dampsq = damp**2
anorm = zero
acond = zero
bbnorm = zero
ddnorm = zero
res2 = zero
xnorm = zero
xxnorm = zero
cs2 = -one
sn2 = zero
z = zero
itn = 0
istop = 0
nstop = 0
!
do i = 1, n
   w(i) = zero
   x(i) = zero
end do
!
!     Set up the first vectors for the bidiagonalization.
!     These satisfy   beta*u = B,   alfa*w = a(transpose)*u.
!
call normlz(m,u,beta)
call mtprd1(m,n,a,ia,ja,u,w)
call normlz(n,w,alfa)
call scopy(n,w,1,w(n + 1),1)
!
rhobar = alfa
phibar = beta
bnorm = beta
rnorm = beta
arnorm = alfa*beta
if (arnorm <= zero) go to 800
!
!     ------------------------------------------------------------------
!     Main iteration loop.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     Perform the next step of the bidiagonalization to obtain the
!     next  beta, u, alfa, w.  these satisfy the relations
!                beta*u  =  a*w  -  alfa*u,
!                alfa*w  =  a(TRANSPOSE)*u  -  beta*w.
!
call sscal(m,(-alfa),u,1)
call mvprd1(m,n,a,ia,ja,w,u)
call normlz(m,u,beta)
bbnorm = bbnorm + alfa**2 + beta**2 + dampsq
call sscal(n,(-beta),w,1)
call mtprd1(m,n,a,ia,ja,u,w)
call normlz(n,w,alfa)
!
!
!     Use a plane rotation to eliminate the damping parameter.
!     This alters the diagonal (RHOBAR) of the lower-bidiagonal matrix.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1 = rhobar/rhbar1
sn1 = damp/rhbar1
psi = sn1*phibar
phibar = cs1*phibar
!
!
!     Use a plane rotation to eliminate the subdiagonal element (beta)
!     of the lower-bidiagonal matrix, giving an upper-bidiagonal matrix.
!
rho = sqrt(rhbar2 + beta**2)
cs = rhbar1/rho
sn = beta/rho
theta = sn*alfa
rhobar = -cs*alfa
phi = cs*phibar
phibar = sn*phibar
tau = sn*phi
!
!
!     Update x and w(n+1),...,w(2*n)
!
t1 = phi/rho
t2 = -theta/rho
t3 = one/rho
!
do i = 1, n
   npi = n + i
   t = w(npi)
   x(i) = t1*t + x(i)
   w(npi) = t2*t + w(i)
   t = (t3*t)**2
   ddnorm = t + ddnorm
end do
!
!
!     Use a plane rotation on the right to eliminate the
!     super-diagonal element (THETA) of the upper-bidiagonal matrix.
!     Then use the result to estimate norm(x).
!
delta = sn2*rho
gambar = -cs2*rho
rhs = phi - delta*z
zbar = rhs/gambar
xnorm = sqrt(xxnorm + zbar**2)
gamma = sqrt(gambar**2 + theta**2)
cs2 = gambar/gamma
sn2 = theta/gamma
z = rhs/gamma
xxnorm = xxnorm + z**2
!
!
!     Test for convergence.
!     First, estimate the norm and condition of the matrix abar,
!     and the norms of RBAR and ABAR(transpose)*RBAR.
!
anorm = sqrt(bbnorm)
acond = anorm*sqrt(ddnorm)
res1 = phibar**2
res2 = res2 + psi**2
rnorm = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     Now use these norms to estimate certain other quantities,
!     some of which will be small near a solution.
!
test1 = rnorm/bnorm
test2 = arnorm/(anorm*rnorm)
test3 = one/acond
t1 = test1/(one + anorm*xnorm/bnorm)
rtol = btol + atol*anorm*xnorm/bnorm
!
!     The following tests guard against extremely small values of
!     atol, btol, or CTOL.  (The user may have set any or all of
!     the parameters atol, btol, conlim to zero.)
!     the effect is equivalent to the normal tests using
!     atol = relpr,  btol = relpr,  conlim = 1/relpr.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn >= itnlim) istop = 7
if (t3 <= one   ) istop = 6
if (t2 <= one   ) istop = 5
if (t1 <= one   ) istop = 4
!
!     Allow for tolerances set by the user.
!
if (test3 <= ctol) istop = 3
if (test2 <= atol) istop = 2
if (test1 <= rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     The convergence criteria are required to be met on  nconv
!     consecutive iterations, where  nconv  is set below.
!     Suggested value --   nconv = 1, 2  or  3.
!
if (istop == 0) nstop = 0
if (istop == 0) go to 100
nconv = 1
nstop = nstop + 1
if (nstop < nconv  .and.  itn < itnlim) istop = 0
if (istop == 0) go to 100
!     ------------------------------------------------------------------
!     END OF ITERATION LOOP.
!     ------------------------------------------------------------------
!
800 return
end subroutine splsq

pure subroutine normlz(n,x,beta)
implicit none
integer, intent(in) :: n
real, intent(inout) :: x(n)
real, intent(out) :: beta
real, parameter :: zero = 0.0
real, parameter :: one = 1.0
interface
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
end interface
!
!     normlz computes the Euclidean norm of x and returns the
!     value in beta. If x is nonzero, then x is rescaled so
!     THAT NORM(x) = 1.
!
!     Functions and subroutines
!
!     BLAS       snrm2,sscal
!
!
!
!
beta = snrm2(n,x,1)
if (beta > zero) call sscal(n,(one/beta),x,1)
end subroutine normlz

subroutine stlsq(m,n,ta,ita,jta,damp,u,x,atol,btol,conlim, &
   & itnlim,istop,itn,acond,rnorm,xnorm,w)
implicit none
integer, intent(in) :: m
integer :: n
integer, intent(in) :: itnlim
integer, intent(inout) :: istop
integer, intent(in) :: ita(*), jta(*)
real, intent(in) :: ta(*), damp
real, intent(inout) :: u(m), x(n)
real, intent(in) :: atol, btol, conlim
real, intent(inout) :: acond, rnorm, xnorm, w(*)
integer, intent(inout) :: itn
integer :: npi, i, nconv, nstop
real :: alfa, anorm, arnorm, bbnorm, beta, bnorm, cs, cs1, cs2, &
   & ctol, dampsq, ddnorm, delta, gamma, gambar, one, phi, phibar, psi, &
   & res1, res2, rho, rhobar, rhbar1, rhbar2, rhs, rtol, sn, sn1, sn2, &
   & t, tau, test1, test2, test3, theta, t1, t2, t3, xxnorm, z, zbar, &
   & zero
!
!     ------------------------------------------------------------------
!
!     stlsq finds a solution x to the following problems ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*x = B
!
!     2. Linear least squares  --    solve  A*x = B
!                                    in the least-squares sense
!
!     3. Damped least squares  --    solve  (   A    )*x = ( B )
!                                           ( damp*i )     ( 0 )
!                                    in the least-squares sense
!
!     Where A is a matrix with m rows and n columns, B an m-vector,
!     and damp A scalar. (All quantities are real.) The matrix A is
!     a sparse matrix whose transpose is stored rowwise in the arrays
!     ta,ita,jta.
!
!     The RHS vector B is input via u, and is subsequently overwritten.
!
!
!     Note. stlsq uses an iterative method to approximate the solution.
!     The number of iterations required to reach a certain accuracy
!     depends strongly on the scaling of the problem. Poor scaling of
!     the rows or columns of A should therefore be avoided whenever
!     possible.
!
!     For example, in problem 1 the solution is unaltered by
!     row-scaling.  If a row of A is very small or large compared to
!     the other rows of A, the corresponding row of (A  B) should be
!     scaled up or down.
!
!     In problems 1 and 2, the solution x is easily recovered
!     following column scaling. In the absence of better information,
!     the nonzero columns of A should be scaled so that they all have
!     the same Euclidean norm (E.G.  1.0).
!
!     In problem 3, there is no freedom to RE-scale if damp is
!     nonzero. However, the value of damp should be assigned only
!     after attention has been paid to the scaling of A.
!
!     The parameter damp is intended to help regularize
!     ill-conditioned systems, by preventing the true solution from
!     being very large. Another aid to regularization is provided by
!     the parameter acond, which may be used to terminate iterations
!     before the computed solution becomes very large.
!
!
!     Notation
!     --------
!
!     The following quantities are used in discussing the subroutine
!     parameters...
!
!     abar   =  (   a    ),          bbar  =  ( b )
!               ( damp*i )                    ( 0 )
!
!     r      =  b  -  a*x,           rbar  =  bbar  -  abar*x
!
!     rnorm  =  sqrt( norm(r)**2  +  damp**2 * norm(x)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  The smallest floating point number for which
!               1 + RELPR .GT. 1.
!
!     stlsq  minimizes the function rnorm with respect to x.
!
!
!     Parameters
!     ----------
!
!     m       INPUT      THE NUMBER OF ROWS IN A.
!
!     n       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     ta,ita  INPUT      THE TRANSPOSE OF THE MATRIX A IS STORED
!      jta               ROWWISE IN SPARSE FORM.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (Damp  should be 0.0 for problems 1 and 2.)
!                        if the system  A*x = B  is incompatible, values
!                        of damp in the range 0 to sqrt(RELPR)*norm(A)
!                        will probably have a negligible effect.
!                        Larger values of damp will tend to decrease
!                        the norm of x and to reduce the number of
!                        iterations required by stlsq.
!
!                        The work per iteration and the storage needed
!                        by stlsq are the same for all values of damp.
!
!     u(m)    INPUT      THE RHS VECTOR B. BE AWARE THAT u IS
!                        over-written by stlsq.
!
!     x(n)    OUTPUT     RETURNS THE COMPUTED SOLUTION x.
!
!     atol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the matrix A. for example,
!                        if A is accurate to about 6 digits, set
!                        atol = 1.0e-6 .
!
!     btol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the RHS vector B. for example,
!                        if B is accurate to about 6 digits, set
!                        btol = 1.0e-6 .
!
!     conlim  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        condition number of the matrix abar.
!                        Iterations will be terminated if a computed
!                        estimate of cond(ABAR) exceeds conlim.
!                        This is intended to prevent certain small or
!                        zero singular values of A or ABAR from
!                        coming into effect and causing unwanted growth
!                        in the computed solution.
!
!                        conlim and damp may be used separately or
!                        together to regularize ill-conditioned systems.
!
!                        Normally, conlim should be in the range
!                        1000  TO  1/RELPR.
!                        Suggested value --
!                        conlim = 1/(100*RELPR)  for compatible systems,
!                        conlim = 1/(10*sqrt(RELPR))  for least squares.
!
!             Note. If the user is not concerned about the parameters
!             atol, btol, and conlim, any or all of them may be set
!             to zero. The effect will be the same as the values
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     itnlim  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        Suggested value --
!                        itnlim = n/2     for well conditioned systems,
!                        itnlim = 4*n     OTHERWISE.
!
!     istop   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       x = 0  Is the exact solution.
!                        No iterations were performed.
!
!                1       The equations  A*x = B  are probably
!                        compatible. Norm(A*x - B) is sufficiently
!                        small, given the values of atol and btol.
!
!                2       The system  A*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is sufficiently accurate,
!                        given the value of atol.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        conlim. The system  A*x = B  appears to be
!                        ill-conditioned.
!
!                4       The equations  A*x = B  are probably
!                        compatible. Norm(A*x - B) is as small as
!                        seems reasonable on this machine.
!
!                5       The system  A*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is as accurate as seems
!                        reasonable on this machine.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        not much point in doing further iterations,
!                        given the precision of this machine.
!
!                7       THE ITERATION LIMIT itnlim WAS REACHED.
!
!
!     itn     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     acond   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        number of ABAR.
!
!     rnorm   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        the function being minimized (see notation
!                        above). This will be small if  A*x = B  has
!                        A SOLUTION.
!
!     xnorm   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        solution vector x.
!
!     w(2*n)             WORKSPACE
!
!     anorm   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        This is the square root of the sum of squares
!                        of the elements of ABAR.
!                        If damp is small and if the columns of A
!                        have all been scaled to have length  1.0,
!                        anorm should increase to roughly sqrt(n).
!
!     arnorm  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        norm( ABAR(transpose)*RBAR ), the norm of
!                        the residual for the usual normal equations.
!                        This should be small in all cases. (arnorm
!                        will often be smaller than the true value
!                        computed from the output vector x.)
!
!
!     Subroutines and functions used
!     ------------------------------
!
!                normlz,mvprd1,mtprd1
!     BLAS       scopy,snrm2,sscal  (SEE LAWSON ET AL. BELOW)
!                (snrm2 is used only in normlz)
!     FORTRAN    ABS,SQRT
!
!
!     References
!     ----------
!
!     Paige, C.C. and saunders, M.A.  lsqr, an algorithm for sparse
!        linear equations and sparse least squares.
!        ACM transactions on mathematical software 8, 1 (March 1982).
!
!     Lawson, C.L., Hanson, R.J., kincaid, D.R. and krogh, F.T.
!        BASIC linear algebra subprograms for Fortran usage.
!        ACM transactions on mathematical software 5, 3 (sept 1979),
!        308-323 and 324-325.
!
!     ------------------------------------------------------------------
!
!     Local variables
!
!
!
!     Initialize.
!
zero = 0.0
one = 1.0
ctol = zero
if (conlim > zero) ctol = one/conlim
dampsq = damp**2
anorm = zero
acond = zero
bbnorm = zero
ddnorm = zero
res2 = zero
xnorm = zero
xxnorm = zero
cs2 = -one
sn2 = zero
z = zero
itn = 0
istop = 0
nstop = 0
!
do i = 1, n
   w(i) = zero
   x(i) = zero
end do
!
!     Set up the first vectors for the bidiagonalization.
!     These satisfy   beta*u = B,   alfa*w = A(transpose)*u.
!
call normlz(m,u,beta)
call mvprd1(n,m,ta,ita,jta,u,w)
call normlz(n,w,alfa)
call scopy(n,w,1,w(n + 1),1)
!
rhobar = alfa
phibar = beta
bnorm = beta
rnorm = beta
arnorm = alfa*beta
if (arnorm <= zero) go to 800
!
!     ------------------------------------------------------------------
!     Main iteration loop.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     Perform the next step of the bidiagonalization to obtain the
!     next  beta, u, alfa, w.  these satisfy the relations
!                beta*u  =  A*w  -  alfa*u,
!                alfa*w  =  A(TRANSPOSE)*u  -  beta*w.
!
call sscal(m,(-alfa),u,1)
call mtprd1(n,m,ta,ita,jta,w,u)
call normlz(m,u,beta)
bbnorm = bbnorm + alfa**2 + beta**2 + dampsq
call sscal(n,(-beta),w,1)
call mvprd1(n,m,ta,ita,jta,u,w)
call normlz(n,w,alfa)
!
!
!     Use a plane rotation to eliminate the damping parameter.
!     This alters the diagonal (RHOBAR) of the lower-bidiagonal matrix.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1 = rhobar/rhbar1
sn1 = damp/rhbar1
psi = sn1*phibar
phibar = cs1*phibar
!
!
!     Use a plane rotation to eliminate the subdiagonal element (beta)
!     of the lower-bidiagonal matrix, giving an upper-bidiagonal matrix.
!
rho = sqrt(rhbar2 + beta**2)
cs = rhbar1/rho
sn = beta/rho
theta = sn*alfa
rhobar = -cs*alfa
phi = cs*phibar
phibar = sn*phibar
tau = sn*phi
!
!
!     Update x and w(n+1),...,w(2*n)
!
t1 = phi/rho
t2 = -theta/rho
t3 = one/rho
!
do i = 1, n
   npi = n + i
   t = w(npi)
   x(i) = t1*t + x(i)
   w(npi) = t2*t + w(i)
   t = (t3*t)**2
   ddnorm = t + ddnorm
end do
!
!
!     Use a plane rotation on the right to eliminate the
!     super-diagonal element (THETA) of the upper-bidiagonal matrix.
!     Then use the result to estimate norm(x).
!
delta = sn2*rho
gambar = -cs2*rho
rhs = phi - delta*z
zbar = rhs/gambar
xnorm = sqrt(xxnorm + zbar**2)
gamma = sqrt(gambar**2 + theta**2)
cs2 = gambar/gamma
sn2 = theta/gamma
z = rhs/gamma
xxnorm = xxnorm + z**2
!
!
!     Test for convergence.
!     First, estimate the norm and condition of the matrix abar,
!     and the norms of RBAR and ABAR(transpose)*RBAR.
!
anorm = sqrt(bbnorm)
acond = anorm*sqrt(ddnorm)
res1 = phibar**2
res2 = res2 + psi**2
rnorm = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     Now use these norms to estimate certain other quantities,
!     some of which will be small near a solution.
!
test1 = rnorm/bnorm
test2 = arnorm/(anorm*rnorm)
test3 = one/acond
t1 = test1/(one + anorm*xnorm/bnorm)
rtol = btol + atol*anorm*xnorm/bnorm
!
!     The following tests guard against extremely small values of
!     atol, btol, or CTOL.  (The user may have set any or all of
!     the parameters atol, btol, conlim to zero.)
!     the effect is equivalent to the normal tests using
!     atol = relpr,  btol = relpr,  conlim = 1/relpr.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn >= itnlim) istop = 7
if (t3 <= one   ) istop = 6
if (t2 <= one   ) istop = 5
if (t1 <= one   ) istop = 4
!
!     Allow for tolerances set by the user.
!
if (test3 <= ctol) istop = 3
if (test2 <= atol) istop = 2
if (test1 <= rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     The convergence criteria are required to be met on  nconv
!     consecutive iterations, where  nconv  is set below.
!     Suggested value --   nconv = 1, 2  or  3.
!
if (istop == 0) nstop = 0
if (istop == 0) go to 100
nconv = 1
nstop = nstop + 1
if (nstop < nconv  .and.  itn < itnlim) istop = 0
if (istop == 0) go to 100
!     ------------------------------------------------------------------
!     END OF ITERATION LOOP.
!     ------------------------------------------------------------------
!
800 return
end subroutine stlsq

subroutine blsq(m,n,a,ka,ml,mu,damp,u,x,atol,btol,conlim,itnlim, &
   & istop,itn,acond,rnorm,xnorm,w)
implicit none
integer, intent(in) :: m
integer :: n
integer, intent(in) :: ka, ml, mu, itnlim
integer, intent(inout) :: istop
real, intent(in) :: a(ka,n), damp
real, intent(inout) :: u(m), x(n)
real, intent(in) :: atol, btol, conlim
real, intent(inout) :: acond, rnorm, xnorm, w(*)
integer, intent(inout) :: itn
integer :: npi, i, nconv, nstop
real :: alfa, anorm, arnorm, bbnorm, beta, bnorm, cs, cs1, cs2, &
   & ctol, dampsq, ddnorm, delta, gamma, gambar, one, phi, phibar, psi, &
   & res1, res2, rho, rhobar, rhbar1, rhbar2, rhs, rtol, sn, sn1, sn2, &
   & t, tau, test1, test2, test3, theta, t1, t2, t3, xxnorm, z, zbar, &
   & zero
!
!     ------------------------------------------------------------------
!
!     blsq finds a solution x to the following problems ...
!
!     1. UNSYMMETRIC EQUATIONS --    SOLVE  a*x = B
!
!     2. Linear least squares  --    solve  a*x = B
!                                    in the least-squares sense
!
!     3. Damped least squares  --    solve  (   a    )*x = ( B )
!                                           ( damp*i )     ( 0 )
!                                    in the least-squares sense
!
!     Where A is a matrix with m rows and n columns, B an m-vector,
!     and damp a scalar. (All quantities are real.) The matrix a is
!     a banded matrix stored in band form.
!
!     The RHS vector B is input via u, and is subsequently overwritten.
!
!
!     Note. blsq uses an iterative method to approximate the solution.
!     The number of iterations required to reach a certain accuracy
!     depends strongly on the scaling of the problem. Poor scaling of
!     the rows or columns of A should therefore be avoided whenever
!     possible.
!
!     For example, in problem 1 the solution is unaltered by
!     row-scaling.  If a row of A is very small or large compared to
!     the other rows of A, the corresponding row of (A  B) should be
!     scaled up or down.
!
!     In problems 1 and 2, the solution x is easily recovered
!     following column scaling. In the absence of better information,
!     the nonzero columns of A should be scaled so that they all have
!     the same Euclidean norm (E.G.  1.0).
!
!     In problem 3, there is no freedom to RE-scale if damp is
!     nonzero. However, the value of damp should be assigned only
!     after attention has been paid to the scaling of A.
!
!     The parameter damp is intended to help regularize
!     ill-conditioned systems, by preventing the true solution from
!     being very large. Another aid to regularization is provided by
!     the parameter acond, which may be used to terminate iterations
!     before the computed solution becomes very large.
!
!
!     Notation
!     --------
!
!     The following quantities are used in discussing the subroutine
!     parameters...
!
!     abar   =  (   a    ),          bbar  =  ( b )
!               ( damp*i )                    ( 0 )
!
!     r      =  b  -  a*x,           rbar  =  bbar  -  abar*x
!
!     rnorm  =  sqrt( norm(r)**2  +  damp**2 * norm(x)**2 )
!            =  NORM( RBAR )
!
!     RELPR  =  The smallest floating point number for which
!               1 + RELPR .GT. 1.
!
!     blsq   MINIMIZES THE FUNCTION rnorm WITH RESPECT TO x.
!
!
!     Parameters
!     ----------
!
!     m       INPUT      THE NUMBER OF ROWS IN A.
!
!     n       INPUT      THE NUMBER OF COLUMNS IN A.
!
!     a       INPUT      THE MATRIX a STORED IN BAND FORM.
!
!     ka      INPUT      THE NUMBER OF ROWS IN THE DIMENSION STATEMENT
!                        for A in the calling program.
!
!     ml      INPUT      THE LOWER BAND WIDTH OF A.
!
!     mu      INPUT      THE UPPER BAND WIDTH OF A.
!
!     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
!                        (Damp  should be 0.0 for problems 1 and 2.)
!                        if the system  a*x = B  is incompatible, values
!                        of damp in the range 0 to sqrt(RELPR)*norm(a)
!                        will probably have a negligible effect.
!                        Larger values of damp will tend to decrease
!                        the norm of x and to reduce the number of
!                        iterations required by blsq.
!
!                        The work per iteration and the storage needed
!                        by blsq are the same for all values of damp.
!
!     u(m)    INPUT      THE RHS VECTOR B. BE AWARE THAT u IS
!                        over-written by blsq.
!
!     x(n)    OUTPUT     RETURNS THE COMPUTED SOLUTION x.
!
!     atol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the matrix a. for example,
!                        if A is accurate to about 6 digits, set
!                        atol = 1.0e-6 .
!
!     btol    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
!                        defining the RHS vector B. for example,
!                        if B is accurate to about 6 digits, set
!                        btol = 1.0e-6 .
!
!     conlim  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
!                        condition number of the matrix abar.
!                        Iterations will be terminated if a computed
!                        estimate of cond(ABAR) exceeds conlim.
!                        This is intended to prevent certain small or
!                        zero singular values of A or ABAR from
!                        coming into effect and causing unwanted growth
!                        in the computed solution.
!
!                        conlim and damp may be used separately or
!                        together to regularize ill-conditioned systems.
!
!                        Normally, conlim should be in the range
!                        1000  TO  1/RELPR.
!                        Suggested value --
!                        conlim = 1/(100*RELPR)  for compatible systems,
!                        conlim = 1/(10*sqrt(RELPR))  for least squares.
!
!             Note. If the user is not concerned about the parameters
!             atol, btol, and conlim, any or all of them may be set
!             to zero. The effect will be the same as the values
!             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
!
!     itnlim  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
!                        Suggested value --
!                        itnlim = n/2     for well conditioned systems,
!                        itnlim = 4*n     OTHERWISE.
!
!     istop   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
!
!                0       x = 0  Is the exact solution.
!                        No iterations were performed.
!
!                1       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is sufficiently
!                        small, given the values of atol and btol.
!
!                2       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is sufficiently accurate,
!                        given the value of atol.
!
!                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
!                        conlim. The system  a*x = B  appears to be
!                        ill-conditioned.
!
!                4       The equations  a*x = B  are probably
!                        compatible. Norm(a*x - B) is as small as
!                        seems reasonable on this machine.
!
!                5       The system  a*x = B  is probably not
!                        compatible. A least-squares solution has
!                        been obtained which is as accurate as seems
!                        reasonable on this machine.
!
!                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
!                        not much point in doing further iterations,
!                        given the precision of this machine.
!
!                7       THE ITERATION LIMIT itnlim WAS REACHED.
!
!
!     itn     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
!
!     acond   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
!                        number of ABAR.
!
!     rnorm   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
!                        the function being minimized (see notation
!                        above). This will be small if  a*x = B  has
!                        A SOLUTION.
!
!     xnorm   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
!                        solution vector x.
!
!     w(2*n)             WORKSPACE
!
!     anorm   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
!                        This is the square root of the sum of squares
!                        of the elements of ABAR.
!                        If damp is small and if the columns of A
!                        have all been scaled to have length  1.0,
!                        anorm should increase to roughly sqrt(n).
!
!     arnorm  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
!                        norm( ABAR(transpose)*RBAR ), the norm of
!                        the residual for the usual normal equations.
!                        This should be small in all cases. (arnorm
!                        will often be smaller than the true value
!                        computed from the output vector x.)
!
!
!     Subroutines and functions used
!     ------------------------------
!
!                normlz,bvprd1,btprd1
!     BLAS       scopy,snrm2,sscal  (SEE LAWSON ET AL. BELOW)
!                (snrm2 is used only in normlz)
!     FORTRAN    ABS,SQRT
!
!
!     References
!     ----------
!
!     Paige, C.C. and saunders, M.A.  lsqr, an algorithm for sparse
!        linear equations and sparse least squares.
!        ACM transactions on mathematical software 8, 1 (March 1982).
!
!     Lawson, C.L., Hanson, R.J., kincaid, D.R. and krogh, F.T.
!        BASIC linear algebra subprograms for Fortran usage.
!        ACM transactions on mathematical software 5, 3 (sept 1979),
!        308-323 and 324-325.
!
!     ------------------------------------------------------------------
!
!     Local variables
!
!
!
!     Initialize.
!
zero = 0.0
one = 1.0
ctol = zero
if (conlim > zero) ctol = one/conlim
dampsq = damp**2
anorm = zero
acond = zero
bbnorm = zero
ddnorm = zero
res2 = zero
xnorm = zero
xxnorm = zero
cs2 = -one
sn2 = zero
z = zero
itn = 0
istop = 0
nstop = 0
!
do i = 1, n
   w(i) = zero
   x(i) = zero
end do
!
!     Set up the first vectors for the bidiagonalization.
!     These satisfy   beta*u = B,   alfa*w = a(transpose)*u.
!
call normlz(m,u,beta)
call btprd1(m,n,a,ka,ml,mu,u,w)
call normlz(n,w,alfa)
call scopy(n,w,1,w(n + 1),1)
!
rhobar = alfa
phibar = beta
bnorm = beta
rnorm = beta
arnorm = alfa*beta
if (arnorm <= zero) go to 800
!
!     ------------------------------------------------------------------
!     Main iteration loop.
!     ------------------------------------------------------------------
100 itn = itn + 1
!
!     Perform the next step of the bidiagonalization to obtain the
!     next  beta, u, alfa, w.  these satisfy the relations
!                beta*u  =  a*w  -  alfa*u,
!                alfa*w  =  a(TRANSPOSE)*u  -  beta*w.
!
call sscal(m,(-alfa),u,1)
call bvprd1(m,n,a,ka,ml,mu,w,u)
call normlz(m,u,beta)
bbnorm = bbnorm + alfa**2 + beta**2 + dampsq
call sscal(n,(-beta),w,1)
call btprd1(m,n,a,ka,ml,mu,u,w)
call normlz(n,w,alfa)
!
!
!     Use a plane rotation to eliminate the damping parameter.
!     This alters the diagonal (RHOBAR) of the lower-bidiagonal matrix.
!
rhbar2 = rhobar**2 + dampsq
rhbar1 = sqrt(rhbar2)
cs1 = rhobar/rhbar1
sn1 = damp/rhbar1
psi = sn1*phibar
phibar = cs1*phibar
!
!
!     Use a plane rotation to eliminate the subdiagonal element (beta)
!     of the lower-bidiagonal matrix, giving an upper-bidiagonal matrix.
!
rho = sqrt(rhbar2 + beta**2)
cs = rhbar1/rho
sn = beta/rho
theta = sn*alfa
rhobar = -cs*alfa
phi = cs*phibar
phibar = sn*phibar
tau = sn*phi
!
!
!     Update x and w(n+1),...,w(2*n)
!
t1 = phi/rho
t2 = -theta/rho
t3 = one/rho
!
do i = 1, n
   npi = n + i
   t = w(npi)
   x(i) = t1*t + x(i)
   w(npi) = t2*t + w(i)
   t = (t3*t)**2
   ddnorm = t + ddnorm
end do
!
!
!     Use a plane rotation on the right to eliminate the
!     super-diagonal element (THETA) of the upper-bidiagonal matrix.
!     Then use the result to estimate norm(x).
!
delta = sn2*rho
gambar = -cs2*rho
rhs = phi - delta*z
zbar = rhs/gambar
xnorm = sqrt(xxnorm + zbar**2)
gamma = sqrt(gambar**2 + theta**2)
cs2 = gambar/gamma
sn2 = theta/gamma
z = rhs/gamma
xxnorm = xxnorm + z**2
!
!
!     Test for convergence.
!     First, estimate the norm and condition of the matrix abar,
!     and the norms of RBAR and ABAR(transpose)*RBAR.
!
anorm = sqrt(bbnorm)
acond = anorm*sqrt(ddnorm)
res1 = phibar**2
res2 = res2 + psi**2
rnorm = sqrt(res1 + res2)
arnorm = alfa*abs(tau)
!
!     Now use these norms to estimate certain other quantities,
!     some of which will be small near a solution.
!
test1 = rnorm/bnorm
test2 = arnorm/(anorm*rnorm)
test3 = one/acond
t1 = test1/(one + anorm*xnorm/bnorm)
rtol = btol + atol*anorm*xnorm/bnorm
!
!     The following tests guard against extremely small values of
!     atol, btol, or CTOL.  (The user may have set any or all of
!     the parameters atol, btol, conlim to zero.)
!     the effect is equivalent to the normal tests using
!     atol = relpr,  btol = relpr,  conlim = 1/relpr.
!
t3 = one + test3
t2 = one + test2
t1 = one + t1
if (itn >= itnlim) istop = 7
if (t3 <= one   ) istop = 6
if (t2 <= one   ) istop = 5
if (t1 <= one   ) istop = 4
!
!     Allow for tolerances set by the user.
!
if (test3 <= ctol) istop = 3
if (test2 <= atol) istop = 2
if (test1 <= rtol) istop = 1
!
!     STOP IF APPROPRIATE.
!     The convergence criteria are required to be met on  nconv
!     consecutive iterations, where  nconv  is set below.
!     Suggested value --   nconv = 1, 2  or  3.
!
if (istop == 0) nstop = 0
if (istop == 0) go to 100
nconv = 1
nstop = nstop + 1
if (nstop < nconv  .and.  itn < itnlim) istop = 0
if (istop == 0) go to 100
!     ------------------------------------------------------------------
!     END OF ITERATION LOOP.
!     ------------------------------------------------------------------
!
800 return
end subroutine blsq

subroutine fmin(f, a0, b0, x, w, aerr, rerr, error, ind)
implicit none
integer, intent(out) :: ind
real :: f
real, intent(in) :: a0, b0
real, intent(inout) :: x, w
real, intent(in) :: aerr, rerr
real, intent(inout) :: error
external f
real :: eps, atol, ftol, rtol, tol, a, b, e, fu, fv, u, v, nswc_ai_r4
real, parameter :: eps0 = 5.e-3
real, parameter :: c1 = .3819660112501052
real, parameter :: c2 = .6180339887498948
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     ******************************************************************
!     Golden section minimization of a function f(T)
!     ******************************************************************
!     -------------------
!     c1 = 1 - c2
!     c2 = 0.5*(-1 + sqrt(5))
!     -------------------
!     -------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1 + eps .GT. 1.
!
eps = spmpar(1)
!     -------------------
a = a0
b = b0
ind = 0
atol = max(aerr,1.e-20)
ftol = max(2.0*eps,rerr)
rtol = max(7.0*eps,rerr)
!
e = b - a
u = a + c1*e
v = a + c2*e
fu = f(u)
fv = f(v)
!
!        Location of the region of a local minimum
!
10 if (e <= eps0*(1.0 + abs(a))) go to 40
nswc_ai_r4 = fu - fv
if ( nswc_ai_r4 < 0 ) go to 20
if ( nswc_ai_r4 == 0 ) go to 11
go to 30
11 if (fu > f(b)) go to 30
!
20 b = v
e = b - a
v = u
u = a + c1*e
fv = fu
fu = f(u)
go to 10
!
30 a = u
e = b - a
u = v
v = a + c2*e
fu = fv
fv = f(v)
go to 10
!
40 if (a > 0.0 .or. b < 0.0) go to 41
w = f(0.0)
if (w <= min(fu,fv)) go to 100
41 if (a /= a0) go to 42
if (a == 0.0) go to 201
w = f(a)
if (w <= min(fu,fv)) go to 130
go to 201
42 if (b /= b0) go to 201
if (b == 0.0) go to 201
w = f(b)
if (w <= min(fu,fv)) go to 150
go to 201
!
!              Check if 0 is a local minimum
!
100 if (b <= atol) go to 110
x = 0.01*b
if (w > f(x)) go to 180
b = x
go to 100
!
110 if (abs(a) <= atol) go to 120
x = 0.01*a
if (w > f(x)) go to 180
a = x
go to 110
!
120 x = 0.0
error = max(abs(a),b)
return
!
!             Check if a0 is a local minimum
!
130 tol = max(rtol*abs(a),atol)
131 x = a + 0.01*e
if (w > f(x)) go to 180
b = x
e = b - a
if (e > tol) go to 131
!
x = a
error = e
return
!
!             Check if b0 is a local minimum
!
150 tol = max(rtol*abs(b),atol)
151 x = b - 0.01*e
if (w > f(x)) go to 180
a = x
e = b - a
if (e > tol) go to 151
!
x = b
error = e
return
!
180 e = b - a
u = a + c1*e
v = a + c2*e
fu = f(u)
fv = f(v)
!
!             Refinement of the local minimum
!
200 ind = 0
201 if (fu > fv) go to 210
!
b = v
e = b - a
v = u
u = a + c1*e
fv = fu
fu = f(u)
go to 220
!
210 a = u
e = b - a
u = v
v = a + c2*e
fu = fv
fv = f(v)
!
!        Checking the accuracy of the local minimum
!
220 if (e <= max(rtol*abs(a),atol)) go to 240
if (abs(fv - fu) > ftol*max(abs(fu),abs(fv))) go to 200
if (ind == 1) go to 241
ind = 1
go to 201
!
!                    Report the results
!
240 ind = 0
241 nswc_ai_r4 = fu - fv
if ( nswc_ai_r4 < 0 ) go to 242
if ( nswc_ai_r4 == 0 ) go to 243
go to 244
242 x = u
w = fu
error = c1*e
return
243 x = v
w = fv
error = e
return
244 x = v
w = fv
error = c1*e
end subroutine fmin

subroutine optf(fcn,n,rerr,iter,xpls,fpls,ierr,wrk)
implicit none
integer, intent(inout) :: ierr, iter
integer :: n
real, intent(inout) :: fpls
real, intent(in) :: rerr
real, intent(inout) :: xpls(n), wrk(n,*)
external fcn
integer :: i, itncnt, itnlim, mo
real :: eps, fscale, gradtl, stepmx, steptl
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!                 Interface to minimization package
!-----------------------------------------------------------------------
!
!     Input ...
!
!       FCN        NAME OF ROUTINE TO EVALUATE MINIMIZATION FUNCTION.
!                  Must be declared external in calling routine.
!       n          DIMENSION OF PROBLEM
!       rerr       RELATIVE ACCURACY OF SUBROUTINE fcn.
!
!     Input/output ...
!
!       ITER       ON INPUT ITER IS THE MAXIMUM NUMBER OF ITERATIONS
!                  that are permitted. On output iter is the number
!                  of iterations that were actually performed.
!       xpls(n)    LOCAL MINIMUM
!
!     Output ...
!
!       fpls       FUNCTION VALUE AT LOCAL MINIMUM xpls
!       ierr       TERMINATION CODE
!
!     Workspace ...
!
!       wrk(n,n+8)
!
!-----------------------------------------------------------------------
!
!     equivalence wrk(n,1) = x(n)
!                 wrk(n,2) = typsiz(n)
!                 wrk(n,3) = gpls(n)
!                 wrk(n,4) = g(n)
!                 wrk(n,5) = p(n)
!                 wrk(n,6) = wrk0(n)
!                 wrk(n,7) = wrk1(n)
!                 wrk(n,8) = wrk2(n)
!                 wrk(n,9) = a(n,n)
!
!
!     Set tolerances
!
eps = max(spmpar(1),abs(rerr))
gradtl = eps**0.4
stepmx = 0.0
steptl = eps
if (eps <= 1.e-10) steptl = 10.0*eps
if (eps < 1.e-13) steptl = 1.e2*eps
!
!     Initialization
!
mo = 0
itnlim = iter
iter = 0
do i = 1,n
   wrk(i,1) = xpls(i)
   wrk(i,2) = 1.0
10 continue
end do
fscale = 1.0
!
!     OPTIMIZE FCN
!
20 call optdrv(mo,n,n,wrk(1,1),fcn,wrk(1,2),fscale,rerr, &
   & itnlim,itncnt,gradtl,stepmx,steptl,xpls,fpls,wrk(1,3), &
   & ierr,wrk(1,9),wrk(1,4),wrk(1,5),wrk(1,6),wrk(1,7), &
   & wrk(1,8))
iter = iter + itncnt
if (ierr /= -10) return
itnlim = itnlim - itncnt
go to 20
end subroutine optf

subroutine optdrv(mo,nr,n,x,fcn,typsiz,fscale,rerr, &
   & itnlim,itncnt,gradtl,stepmx,steptl,xpls,fpls,gpls, &
   & ierr,a,g,p,wrk0,wrk1,wrk2)
implicit none
integer, intent(inout) :: ierr, itncnt
integer, intent(in) :: itnlim
integer, intent(inout) :: mo
integer :: n
integer, intent(in) :: nr
real, intent(inout) :: a(nr,n), fpls, fscale, g(n), gpls(n)
real, intent(in) :: gradtl
real, intent(inout) :: p(n)
real, intent(in) :: rerr
real, intent(inout) :: stepmx
real, intent(in) :: steptl
real, intent(inout) :: typsiz(n), wrk0(n), wrk1(n), wrk2(n), x(n), &
   & xpls(n)
external fcn
integer :: i, iagflg, icscmx, iretcd, j, jp1, nm1, ns, sptr
real :: cbrnf, f, fstack(30), rnf, sqrnf, stmx
logical :: mxtake, noupdt
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!             Driver for non-linear optimization problem
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr         ROW DIMENSION OF MATRIX
!       n          DIMENSION OF PROBLEM
!       FCN        SUBROUTINE.  FCN EVALUATES THE FUNCTION TO BE
!                  optimized. FCN must be declared external in the
!                  calling program. The routine HAS the format
!                         call fcn (n, x, fval)
!                  where x is a point and FVAL is the value of the
!                  function at the point.
!       rerr       RELATIVE ACCURACY OF SUBROUTINE fcn. IT IS
!                  assumed that rerr is nonnegative. If rerr = 0
!                  then FCN is accurate to machine precision.
!       itnlim     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       gradtl     TOLERANCE AT WHICH THE GRADIENT IS CONSIDERED
!                  close enough to zero to terminate algorithm.
!                  (Used only in the subroutine opstp.)
!       steptl     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                  considered close enough to terminate algorithm
!
!     Input/output ...
!
!       mo         NUMBER OF RESCALINGS OF THE VARIABLES.
!       x(n)       ESTIMATE OF A LOCAL MINIMUM OF FCN
!       typsiz(n)  typical size for each component of x
!       fscale     ESTIMATE OF SCALE OF MINIMUM VALUE OF FCN.
!                  (Used only in the subroutine opstp.)
!       stepmx     MAXIMUM ALLOWABLE STEP SIZE
!
!     Output ...
!
!       itncnt     NUMBER OF ITERATIONS COMPLETED
!       XPLS(n)    ESTIMATE OF A LOCAL MINIMUM OF FCN
!       fpls       FUNCTION VALUE AT XPLS
!       gpls(n)    GRADIENT AT XPLS
!       ierr       TERMINATION CODE
!
!     Work spaces ...
!
!       a(n,n)     CHOLESKY DECOMPOSITION OF HESSIAN
!       g(n)       GRADIENT AT THE CURRENT ITERATE
!       p(n)       STEP
!       wrk0(n)    WORKSPACE
!       wrk1(n)    WORKSPACE
!       wrk2(n)    WORKSPACE
!
!-----------------------------------------------------------------------
!     Internal parameters ...
!
!       rnf        NOISE IN THE SUBROUTINE fcn
!       f          FUNCTION VALUE  FCN(x)
!       fstack(ns) stack of previous function values
!       ns         LENGTH OF THE ARRAY fstack
!       sptr       POINTER TO AN ELEMENT IN fstack
!-----------------------------------------------------------------------
!
!     Initialization
!     --------------
ns = 30
stmx = stepmx
stepmx = 0.0
call opchk1(n,x,typsiz,fscale,gradtl,itnlim,rerr,stepmx,ierr)
if (ierr < 0) return
if (mo /= 0) stepmx = max(stmx,stepmx)
!
rnf = 2.0*max(rerr,spmpar(1))
sqrnf = sqrt(rnf)
!
itncnt = 0
iagflg = 0
iretcd = -1
icscmx = 0
!
!     Evaluate FCN(x)
!
call fcn(n,x,f)
!
!     Evaluate finite difference gradient
!
call fstofd(n, x, fcn, f, g, typsiz, sqrnf)
!
call opstp(n,x,f,g,wrk1,itncnt,icscmx,ierr,gradtl,steptl, &
   & typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
if (ierr == 0) go to 10
if (mo /= 0) go to 210
!
!        Apply the fixed step coordinate descent procedure
!        for one step and check if the gradient is nonzero
!
call fxdec(fcn, n, x, f, 10.0)
!
stepmx = 0.0
call opchk1(n,x,typsiz,fscale,gradtl,itnlim,rerr,stepmx,ierr)
call fstofd(n, x, fcn, f, g, typsiz, sqrnf)
call opstp(n,x,f,g,wrk1,itncnt,icscmx,ierr,gradtl,steptl, &
   & typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
if (ierr /= 0) go to 210
!
!     The hessian will be obtained by secant updates.
!     Set A to the initial hessian.
!
10 nm1 = n - 1
do j = 1,nm1
   a(j,j) = 1.0/typsiz(j)
   jp1 = j + 1
   do i = jp1,n
      a(i,j) = 0.0
   end do
end do
a(n,n) = 1.0/typsiz(n)
go to 101
!
!
!     Iteration
!     ---------
100 if (mo > 1) go to 101
if (mod(itncnt,10) /= 0) go to 101
if (itncnt + 10 >= itnlim) go to 101
call scalex(mo, x, typsiz, n, ierr)
if (ierr == 0) go to 101
mo = mo + 1
return
101 itncnt = itncnt + 1
!
!     Solve  a*p = -g  for Newton step
!
105 do i = 1,n
   wrk1(i) = -g(i)
end do
call lltslv(nr,n,a,p,wrk1)
!
!     Take a step, arriving at the point XPLS
!
call lnsrch(n,x,f,g,p,xpls,fpls,fcn,mxtake,iretcd, &
   & stepmx,steptl,typsiz)
!
!     If a satisfactory step could not be found and forward difference
!     gradient was used, retry using a central difference gradient.
!
if (iretcd /= 1 .or. iagflg /= 0) go to 120
!
!        Set iagflg for central differences
!
iagflg = -1
cbrnf = rnf**(1.0/3.0)
call fstocd(n, x, fcn, typsiz, cbrnf, g)
go to 105
!
!     Calculate gradient at XPLS
!
120 if (iagflg == 0) go to 130
call fstocd(n, xpls, fcn, typsiz, cbrnf, gpls)
go to 140
130 call fstofd(n, xpls, fcn, fpls, gpls, typsiz, sqrnf)
!
!     Check whether the stopping criteria satisfied
!
140 call opstp(n,xpls,fpls,gpls,x,itncnt,icscmx,ierr,gradtl,steptl, &
   & typsiz,fscale,itnlim,iretcd,mxtake,fstack,ns,sptr)
if (ierr /= 0) go to 200
!
!     Evaluate hessian at XPLS
!
call secfac(nr,n,x,g,a,xpls,gpls,itncnt,sqrnf, &
   & noupdt,wrk0,wrk1,wrk2)
!
!     Update f, x, and g
!
f = fpls
do i = 1,n
   x(i) = xpls(i)
   g(i) = gpls(i)
end do
go to 100
!
!     Termination
!     -----------
!     Reset XPLS,fpls,gpls  if previous iterate solution
!
200 if (ierr /= 3) return
!
210 fpls = f
do i = 1,n
   xpls(i) = x(i)
   gpls(i) = g(i)
end do
end subroutine optdrv

pure subroutine opchk1(n,x,typsiz,fscale,gradtl,itnlim,rerr, &
   & stepmx,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: itnlim, n
real, intent(inout) :: fscale
real, intent(in) :: gradtl, rerr
real, intent(inout) :: stepmx
real, intent(in) :: x(n)
real, intent(inout) :: typsiz(n)
integer :: i
real :: stpsiz
!-----------------------------------------------------------------------
!                  Check input for reasonableness
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       x(n)       ESTIMATE OF MINIMUM OF FCN
!       gradtl     TOLERANCE AT WHICH GRADIENT CONSIDERED CLOSE
!                  enough to zero to terminate algorithm
!       itnlim     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       rerr       RELATIVE ACCURACY OF SUBROUTINE fcn
!
!     Input/output ...
!
!       typsiz(n)  scaling vector for x
!       fscale     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION fcn
!       stepmx     MAXIMUM STEP SIZE
!
!     Output ...
!
!       ierr       ERROR INDICATOR
!
!-----------------------------------------------------------------------
!
!     Check that parameters only take on acceptable values.
!     If not, set them to default values.
!
ierr = 0
!
!     Check dimension of problem
!
if (n <= 0) go to 805
if (n == 1) go to 810
!
!     Compute scale matrix
!
do i = 1,n
   typsiz(i) = abs(typsiz(i))
   if (typsiz(i) == 0.0) typsiz(i) = 1.0
end do
!
!     Check maximum step size
!
if (stepmx > 0.0) go to 20
stpsiz = 0.0
do i = 1, n
   stpsiz = stpsiz + (x(i)/typsiz(i))**2
end do
stpsiz = sqrt(stpsiz)
stepmx = max(1.0e3*stpsiz, 1.0e3)
20 continue
!
!     Check function SCALE
!
fscale = abs(fscale)
if (fscale == 0.0) fscale = 1.0
!
!     Check gradient tolerance
!
if (gradtl < 0.0) go to 815
!
!     Check iteration limit
!
if (itnlim <= 0) go to 820
!
!     Check the accuracy of FCN
!
if (rerr < 0.0 .or. rerr > 1.e-4) go to 825
return
!
!     Error exits
!
805 ierr = -1
go to 895
810 ierr = -2
go to 895
815 ierr = -3
go to 895
820 ierr = -4
go to 895
825 ierr = -5
895 return
end subroutine opchk1

pure subroutine opstp(n,xpls,fpls,gpls,x,itncnt,icscmx,ierr, &
   & gradtl,steptl,typsiz,fscale,itnlim,iretcd,mxtake, &
   & fstack,ns,sptr)
implicit none
integer, intent(inout) :: icscmx
integer, intent(out) :: ierr
integer, intent(in) :: iretcd, itncnt, itnlim, n, ns
real, intent(in) :: fpls
real, intent(inout) :: fscale
real, intent(in) :: gradtl, steptl
real, intent(in) :: xpls(n), gpls(n), x(n), typsiz(n)
real, intent(inout) :: fstack(ns)
integer, intent(inout) :: sptr
logical, intent(in) :: mxtake
integer :: i, jerr
real :: d, grd, relstp, rgx, rsx
!-----------------------------------------------------------------------
!            Unconstrained minimization stopping criteria
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       xpls(n)    NEW ITERATE x(K)
!       fpls       FUNCTION VALUE AT NEW ITERATE, F(xpls)
!       gpls(n)    GRADIENT AT NEW ITERATE, G(xpls), OR APPROXIMATE
!       x(n)       OLD ITERATE x(K-1)
!       itncnt     CURRENT ITERATION K
!       icscmx     number consecutive steps .GE. STEPMX
!       gradtl     TOLERANCE AT WHICH RELATIVE GRADIENT CONSIDERED CLOSE
!                  enough to zero to terminate algorithm
!       steptl     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                  considered close enough to terminate algorithm
!       typsiz(n)  scaling vector for x
!       itnlim     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
!       iretcd     CODE WHICH WAS SET WHEN THE POINT xpls WAS OBTAINED
!       mxtake     BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
!       ns         LENGTH OF THE ARRAY fstack
!
!     Input/output ...
!
!       fscale     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION
!       fstack(ns) stack of previous function values
!       sptr       POINTER TO AN ELEMENT IN fstack
!
!     Output ...
!
!       icscmx     number consecutive steps .GE. STEPMX
!                  (retain value between successive calls)
!       ierr       TERMINATION CODE
!
!-----------------------------------------------------------------------
!
ierr = 0
!
!     Last global step failed to locate a point lower than x
!
if (iretcd /= 1) go to 10
ierr = 3
return
10 continue
!
!     Find direction in which relative gradient maximum.
!     Check whether within tolerance.
!
d = max(abs(fpls),fscale)
rgx = 0.0
do i = 1,n
   grd = abs(gpls(i))*max(abs(xpls(i)),typsiz(i))
   rgx = max(rgx, grd)
20 continue
end do
jerr = 1
if (rgx > gradtl*d) go to 30
if (abs(fpls) <= 1.e-9) go to 100
if (abs(fpls) > 0.5*fscale) go to 100
fscale = abs(fpls)
30 if (itncnt == 0) return
!
!     Find direction in which relative stepsize maximum
!     check whether within tolerance.
!
rsx = 0.0
do i = 1,n
   relstp = abs(xpls(i) - x(i))/max(abs(xpls(i)),typsiz(i))
   rsx = max(rsx,relstp)
end do
jerr = 2
if (rsx <= steptl) go to 100
!
!     Check if fpls is sufficiently less than the ns-TH
!     previous value of FCN.
!
if (itncnt > ns) go to 50
sptr = itncnt
fstack(sptr) = fpls
go to 60
50 sptr = sptr + 1
if (sptr > ns) sptr = 1
jerr = 3
if (fpls >= (fstack(sptr) - 1.e-3*abs(fstack(sptr)))) &
   & go to 100
fstack(sptr) = fpls
!
!     Check iteration limit
!
60 jerr = 4
if (itncnt >= itnlim) go to 100
!
!     Check number of consecutive steps of size STEPMX
!
if (mxtake) go to 70
icscmx = 0
return
70 icscmx = icscmx + 1
if (icscmx >= 20) ierr = 5
return
!
!     Terminate
!
100 ierr = jerr
end subroutine opstp

subroutine fxdec(fcn, n, x, fx, r)
implicit none
integer :: n
real, intent(inout) :: fx
real, intent(in) :: r
real, intent(inout) :: x(n)
external fcn
integer :: i
real :: fminus, fplus, h, xi, xminus, xplus
!-----------------------------------------------------------------------
!     Fixed step coordinate descent procedure / one iteration
!-----------------------------------------------------------------------
!
do i = 1,n
   h = r * max(abs(x(i)), 1.0)
   xi = x(i)
   xplus = xi + h
   x(i) = xplus
   call fcn(n, x, fplus)
   xminus = xi - 1.1*h
   x(i) = xminus
   call fcn(n, x, fminus)
   x(i) = xi
!
   if (fx <= fplus) go to 10
   fx = fplus
   x(i) = xplus
10 if (fx <= fminus) go to 20
   fx = fminus
   x(i) = xminus
20 continue
end do
end subroutine fxdec

pure subroutine scalex(mo, x, typsiz, n, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo, n
real, intent(in) :: x(n)
real, intent(inout) :: typsiz(n)
integer :: i
real :: big, c, t, xmin
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!     Rescale the variables
!-----------------------------------------------------------------------
xmin = 1.e-5*spmpar(3)
do i = 1,n
   t = max(abs(x(i)), 1.e-20)
   xmin = min(t, xmin)
10 continue
end do
!
c = 1.e3
if (mo /= 0) c = 1.e2
big = c*xmin
do i = 1,n
   if (abs(x(i)) >= big) go to 30
20 continue
end do
ierr = 0
return
!
30 do i = 1,n
   t = abs(x(i))/c
   typsiz(i) = max(t, xmin)
end do
ierr = -10
end subroutine scalex

pure subroutine lltslv(nr,n,a,x,b)
implicit none
integer, intent(in) :: n, nr
real, intent(in) :: a(nr,n)
real, intent(inout) :: x(n)
real, intent(in) :: b(n)
integer :: i, ii, im1, ip1, j
real :: sum
!-----------------------------------------------------------------------
!        Solution of AX = b where A has the form L(L-TRANSPOSE)
!           but only the lower triangular part L is stored.
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr       ROW DIMENSION OF MATRIX
!       n        ORDER OF THE MATRIX
!       a(n,n)   MATRIX OF FORM L(L-TRANSPOSE). A IS NOT
!                modified by the routine.
!       b(n)     RIGHT-HAND SIDE VECTOR
!
!     Output ...
!
!       x(n)     SOLUTION VECTOR
!
!-----------------------------------------------------------------------
!     Note.  b and x may share the same storage area.
!-----------------------------------------------------------------------
!
!                  Forward solve, result in x
!
x(1) = b(1)/a(1,1)
if (n == 1) go to 30
do i = 2,n
   sum = 0.0
   im1 = i - 1
   do j = 1,im1
      sum = sum + a(i,j)*x(j)
   end do
   x(i) = (b(i) - sum)/a(i,i)
end do
!
!                   Back solve, result in x
!
30 x(n) = x(n)/a(n,n)
if (n == 1) return
i = n
do ii = 2,n
   ip1 = i
   i = i - 1
   sum = 0.0
   do j = ip1,n
      sum = sum + a(j,i)*x(j)
   end do
   x(i) = (x(i) - sum)/a(i,i)
end do
end subroutine lltslv

subroutine fstofd(n, x, fcn, fx, g, typsiz, r)
implicit none
integer :: n
real, intent(in) :: fx
real, intent(inout) :: g(n)
real, intent(in) :: r
real :: typsiz(n)
real, intent(inout) :: x(n)
external fcn
integer :: j
real :: fplus, stepsz, xtmpj
!-----------------------------------------------------------------------
!     Find forward difference approximation g to the first derivative
!     (gradient) of the function defined by FCN at the point x.
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       x(n)       POINT AT WHICH THE GRADIENT IS TO BE APPROXIMATED
!       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       FX         VALUE OF FCN AT THE POINT x
!       typsiz(n)  scaling vector for x
!       r          STEPSIZE FACTOR
!
!     Output ...
!
!       g(n)       FINITE DIFFERENCE APPROXIMATION TO THE GRADIENT
!
!-----------------------------------------------------------------------
!
do j = 1,n
   stepsz = r * max(abs(x(j)),typsiz(j))
   xtmpj = x(j)
   x(j) = xtmpj + stepsz
   call fcn(n, x, fplus)
   x(j) = xtmpj
   g(j) = (fplus - fx)/stepsz
end do
end subroutine fstofd

subroutine fstocd(n, x, fcn, typsiz, r, g)
implicit none
integer :: n
real, intent(in) :: r
real, intent(inout) :: x(n)
real, intent(in) :: typsiz(n)
real, intent(inout) :: g(n)
external fcn
integer :: i
real :: fminus, fplus, stepi, xtempi
!-----------------------------------------------------------------------
!     Find central difference approximation g to the first derivative
!     (gradient) of the function defined by FCN at the point x.
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n          DIMENSION OF PROBLEM
!       x(n)       POINT AT WHICH GRADIENT IS TO BE APPROXIMATED
!       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       typsiz(n)  scaling vector for x
!       r          STEPSIZE FACTOR
!
!     Output ...
!
!       g(n)       CENTRAL DIFFERENCE APPROXIMATION TO GRADIENT
!
!-----------------------------------------------------------------------
!
!     Find i-TH  stepsize, evaluate two neighbors in direction of
!     i-TH unit vector, and evaluate i-TH  component of gradient.
!
do i = 1, n
   stepi = r * max(abs(x(i)),typsiz(i))
   xtempi = x(i)
   x(i) = xtempi + stepi
   call fcn(n, x, fplus)
   x(i) = xtempi - stepi
   call fcn(n, x, fminus)
   x(i) = xtempi
   g(i) = (fplus - fminus)/(2.0*stepi)
end do
end subroutine fstocd

subroutine lnsrch(n,x,f,g,p,xpls,fpls,fcn,mxtake,iretcd, &
   & stepmx,steptl,typsiz)
implicit none
integer, intent(out) :: iretcd
integer :: n
real, intent(in) :: f
real :: fpls
real, intent(in) :: stepmx, steptl
real, intent(in) :: x(n), g(n)
real, intent(inout) :: p(n), xpls(n)
real, intent(in) :: typsiz(n)
logical, intent(out) :: mxtake
external fcn
integer :: i
real :: a, b, disc, pfpls, plmbda, rln, rmnlmb, scl, sln, slp, t1, &
   & t2, t3, tlmbda, tmp, w
real :: sdot
real :: lambda
!-----------------------------------------------------------------------
!             Find a next Newton iterate by line search
!-----------------------------------------------------------------------
!
!     Input ...
!
!       n         DIMENSION OF PROBLEM
!       x(n)      OLD ITERATE x(K-1)
!       f         FUNCTION VALUE AT OLD ITERATE, f(x)
!       g(n)      GRADIENT AT OLD ITERATE, g(x)
!       p(n)      NON-ZERO NEWTON STEP
!       FCN       NAME OF SUBROUTINE TO EVALUATE FUNCTION
!       stepmx    MAXIMUM ALLOWABLE STEP SIZE
!       steptl    RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
!                 considered close enough to terminate algorithm
!       typsiz(n) scaling vector for x
!
!     Output ...
!
!       xpls(n)   NEW ITERATE x(K)
!       fpls      FUNCTION VALUE AT NEW ITERATE, f(xpls)
!       iretcd    RETURN CODE
!       mxtake    BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
!
!-----------------------------------------------------------------------
!     Internal variables ...
!
!       sln      NEWTON LENGTH
!       rln      RELATIVE LENGTH OF NEWTON STEP
!-----------------------------------------------------------------------
!
mxtake = .false.
iretcd = 2
tmp = 0.0
do i = 1,n
   tmp = tmp + (p(i)/typsiz(i))**2
10 continue
end do
sln = sqrt(tmp)
!
if (sln <= stepmx) go to 30
!
!     Newton step longer than maximum allowed
!
scl = stepmx/sln
do i = 1,n
   p(i) = scl*p(i)
end do
sln = stepmx
!
30 slp = sdot(n,g,1,p,1)
rln = 0.0
do i = 1,n
   rln = max(rln,abs(p(i))/max(abs(x(i)),typsiz(i)))
end do
rmnlmb = steptl/rln
lambda = 1.0
!
!     Loop.  Check if the new iterate is satisfactory.
!
100 do i = 1,n
   xpls(i) = x(i) + lambda*p(i)
end do
call fcn(n,xpls,fpls)
if (fpls <= f + slp*1.e-4*lambda) go to 200
!
!     Solution not (yet) found
!
if (lambda < rmnlmb) go to 210
!
!     Calculate new lambda
!
if (lambda /= 1.0) go to 120
!
!     First backtrack. Quadratic fit
!
tlmbda = min(-slp/(2.0*(fpls - f - slp)), 0.9)
go to 170
!
!     All subsequent backtracks. Cubic fit
!
120 t1 = (fpls - f - lambda*slp)/(lambda*lambda)
t2 = (pfpls - f - plmbda*slp)/(plmbda*plmbda)
t3 = 1.0/(lambda - plmbda)
a = t3*(t1 - t2)
b = t3*(t2*lambda - t1*plmbda)
w = 10.0*abs(t1*t3)
if ((abs(a) + w) /= w) go to 130
!
!     The cubic fit degenerates to a quadratic fit
!
tlmbda = -slp/(2.0*b)
go to 160
!
!     The cubic is nondegenerate
!
130 disc = b*b - 3.0*a*slp
if (disc <= b*b) go to 140
!
!     Only one positive critical point, must be minimum
!
tlmbda = (-b + sign(1.0,a)*sqrt(disc))/(3.0*a)
go to 160
!
!     Both critical points positive, first is minimum
!
140 if (disc > 0.0) go to 150
tlmbda = -b/(3.0*a)
go to 160
150 tlmbda = (-b - sign(1.0,a)*sqrt(disc))/(3.0*a)
!
160 if (tlmbda > 0.5*lambda) tlmbda = 0.5*lambda
!
!
170 plmbda = lambda
pfpls = fpls
if (tlmbda >= lambda*0.1) go to 180
lambda = lambda*0.1
go to 100
180 lambda = tlmbda
go to 100
!
!     A suitable value for xpls has been obtained
!
200 iretcd = 0
if (lambda == 1.0 .and. sln > 0.99*stepmx) mxtake = .true.
return
!
!     No satisfactory xpls found sufficiently distinct from x
!
210 iretcd = 1
end subroutine lnsrch

pure subroutine secfac(nr,n,x,g,a,xpls,gpls,itncnt,tol, &
   & noupdt,s,y,w)
implicit none
integer, intent(in) :: itncnt, n, nr
real, intent(in) :: tol
real, intent(in) :: x(n), xpls(n), g(n), gpls(n)
real, intent(inout) :: a(nr,n)
real, intent(inout) :: s(n), y(n), w(n)
logical, intent(inout) :: noupdt
integer :: i, im1, j
real :: alp, den1, den2, snorm2, sum, ynrm2
interface
   pure subroutine qrupdt(nr,n,a,u,v)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nr
      real, intent(inout) :: a(nr,n)
      real, intent(inout) :: u(n)
      real, intent(in) :: v(n)
   end subroutine qrupdt
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
end interface
!-----------------------------------------------------------------------
!           Update hessian by the BFGS factored method
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr        ROW DIMENSION OF MATRIX
!       n         ORDER OF THE MATRIX
!       x(n)      OLD ITERATE x(K-1)
!       g(n)      GRADIENT AT THE OLD ITERATE
!       xpls(n)   NEW ITERATE x(K)
!       gpls(n)   GRADIENT AT THE NEW ITERATE
!       itncnt    ITERATION COUNT
!       tol       RELATIVE TOLERANCE TO BE USED FOR NOISE
!
!     Input/output ...
!
!       a(n,n)    ON ENTRY, CHOLESKY DECOMPOSITION OF HESSIAN IN
!                    the lower part and diagonal.
!                 On exit,  updated Cholesky decomposition of hessian
!                    in the lower triangular part and diagonal.
!       noupdt    BOOLEAN. NO UPDATE YET.
!
!     Work spaces ...  s(n), y(n), w(n)
!
!-----------------------------------------------------------------------
!
if (itncnt == 1) noupdt = .true.
do i = 1,n
   s(i) = xpls(i) - x(i)
   y(i) = gpls(i) - g(i)
end do
den1 = sdot(n,s,1,y,1)
snorm2 = snrm2(n,s,1)
ynrm2 = snrm2(n,y,1)
if (den1 < tol*snorm2*ynrm2) return
!
!     SET s = TRANSPOSE(L)*s
!
do i = 1,n
   sum = 0.0
   do j = i,n
      sum = sum + a(j,i)*s(j)
   end do
   s(i) = sum
end do
den2 = sdot(n,s,1,s,1)
!
!     Set alp = sqrt(den1/den2)
!
alp = sqrt(den1/den2)
if (.not.noupdt) go to 40
!
!        On the initial update set L = alp*L. then s must be
!        reset to alp*s. after this is done then den2 = den1
!        and alp has the value 1.
!
do j = 1,n
   s(j) = alp*s(j)
   do i = j,n
      a(i,j) = alp*a(i,j)
   end do
end do
noupdt = .false.
alp = 1.0
!
!     SET w = L*s
!
40 do i = 1,n
   sum = 0.0
   do j = 1,i
      sum = sum + a(i,j)*s(j)
   end do
   w(i) = sum
end do
!
!     If abs(y(i) - w(i)) is less than the estimated noise in y(i)
!     for each i, then the update is skipped.
!
do i = 1,n
   if (abs(y(i) - w(i)) >= tol*max(abs(g(i)),abs(gpls(i)))) &
      & go to 70
end do
return
!
!     w = y - alp*l*s
!
70 do i = 1,n
   w(i) = y(i) - alp*w(i)
end do
!
!     s = s/sqrt(den1*den2)
!
alp = alp/den1
do i = 1,n
   s(i) = alp*s(i)
end do
!
!     Copy L into upper triangular part.  Zero L.
!
do i = 2,n
   im1 = i - 1
   do j = 1,im1
      a(j,i) = a(i,j)
      a(i,j) = 0.0
   end do
end do
!
!     Find Q and R such that  Q*R = (L+) + s*(w+)
!
call qrupdt(nr, n, a, s, w)
!
!     Upper triangular part and diagonal of a now contain updated
!     Cholesky decomposition of hessian.  Copy back to lower
!     triangular part.
!
do i = 2,n
   im1 = i - 1
   do j = 1,im1
      a(i,j) = a(j,i)
   end do
end do
end subroutine secfac

pure subroutine qrupdt(nr,n,a,u,v)
implicit none
integer, intent(in) :: n, nr
real, intent(inout) :: a(nr,n), u(n)
real, intent(in) :: v(n)
integer :: i, ii, j, k, km1
real :: r
interface
   pure subroutine jrot(nr,n,h,i,a,b,r)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nr
      real, intent(inout) :: h(nr,n)
      integer, intent(in) :: i
      real, intent(in) :: a
      real, intent(in) :: b
      real, intent(inout) :: r
   end subroutine jrot
end interface
!-----------------------------------------------------------------------
!     Find an orthogonal matrix (Q*) and an upper triangular
!          MATRIX (r*) SUCH THAT (Q*)(r*) = r + u(v+)
!-----------------------------------------------------------------------
!
!     Parameters ...
!
!       nr      ROW DIMENSION OF THE MATRIX
!       n       ORDER OF THE MATRIX
!       a(n,n)  on input,  contains r
!               on output, contains (r*)
!       u(n)    VECTOR
!       v(n)    VECTOR
!
!-----------------------------------------------------------------------
!
!                Determine last non-zero in u
!
k = n
10 if (u(k) /= 0.0 .or. k == 1) go to 20
k = k - 1
go to 10
!
!               k-1 Jacobi rotations transform
!             r + u(v+)  TO  (r*) + (u(1)*E1)(v+)
!                 which is upper Hessenberg
!
20 km1 = k - 1
if (k <= 1) go to 40
do ii = 1,km1
   i = k - ii
   call jrot(nr,n,a,i,u(i),-u(i + 1),r)
   u(i) = r
end do
!
! SET r = r + (u(1)*E1)(v+)
!
40 do j = 1,n
   a(1,j) = a(1,j) + u(1)*v(j)
end do
if (k <= 1) return
!
!       k-1 Jacobi rotations transform upper Hessenberg r
!                   to upper triangular r*
!
do i = 1,km1
   call jrot(nr,n,a,i,a(i,i),-a(i + 1,i),r)
end do
end subroutine qrupdt

pure subroutine jrot(nr,n,h,i,a,b,r)
implicit none
integer, intent(in) :: i, n, nr
real, intent(in) :: a, b
real, intent(inout) :: r
real, intent(inout) :: h(nr,n)
integer :: j
real :: c, s, t, z
!-----------------------------------------------------------------------
!         Pre-multiplication of an upper Hessenberg matrix h
!               by the Jacobian rotation j(i,i+1,a,b)
!-----------------------------------------------------------------------
!
!     Input ...
!
!       nr      ROW DIMENSION OF THE MATRIX
!       n       ORDER OF THE MATRIX
!       h(n,n)  upper hessenber matrix
!       i       INDEX OF ROW
!       A,b     SCALARS
!
!     Output ...
!
!       h(n,n)  the modified Hessenberg matrix
!       r       r = sqrt(a*a + b*b)
!
!-----------------------------------------------------------------------
!
!                COMPUTE c = a/r  AND s = b/r
!
if (abs(a) <= abs(b)) go to 10
t = b/a
z = sqrt(1.0 + t*t)
c = sign(1.0/z, a)
s = t*c
r = z*abs(a)
go to 20
10 if (a == 0.0) go to 40
t = a/b
z = sqrt(1.0 + t*t)
s = sign(1.0/z, b)
c = t*s
r = z*abs(b)
!
!            Apply the rotation when A is nonzero
!
20 do j = i,n
   t = h(i,j)
   z = h(i + 1,j)
   h(i,j) = c*t - s*z
   h(i + 1,j) = s*t + c*z
end do
return
!
!                     Case when a = 0
!
40 s = sign(1.0, b)
r = abs(b)
do j = i,n
   t = h(i,j)
   h(i,j) = - s*h(i + 1,j)
   h(i + 1,j) = s*t
end do
end subroutine jrot

subroutine lmdiff(fcn,m,n,x,fvec,epsfcn,tol,info,iwa,wa,lwa)
implicit none
integer :: m, n
integer, intent(out) :: info
integer, intent(in) :: lwa
integer, intent(inout) :: iwa(n)
real, intent(in) :: epsfcn, tol
real, intent(inout) :: x(n), fvec(m), wa(lwa)
external fcn
integer :: maxfev, mode, mp5n, nfev, nprint
real :: ftol, gtol, xtol
real, parameter :: factor = 1.0e2
!     **********
!
!     SUBROUTINE lmdiff
!
!     The purpose of lmdiff is to minimize the sum of the squares of
!     m nonlinear functions in n variables by a modification of the
!     Levenberg-Marquardt algorithm. This is done by using the more
!     general least-squares solver lmdif. The user must provide A
!     subroutine which calculates the functions. The Jacobian is
!     then calculated by a forward-difference approximation.
!
!     The subroutine statement is
!
!       subroutine lmdiff(fcn,m,n,x,fvec,epsfcn,tol,info,iwa,wa,lwa)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(m,n,x,fvec,iflag)
!         integer m,n,iflag
!         real x(n),fvec(m)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ----------
!         return
!         end
!
!         The value of IFLAG should not be changed by FCN unless
!         the user wants to terminate execution of lmdiff.
!         In this case set IFLAG to a negative integer.
!
!       m is a positive integer input variable SET to the number
!         of functions.
!
!       n is a positive integer input variable SET to the number
!         of variables. n must not exceed m.
!
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!
!       fvec is an output array of length m which contains
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
!         when the algorithm estimates either that the relative
!         error in the sum of squares is at most tol or that
!         the relative error between x and the solution is at
!         MOST tol.
!
!       Info is an integer output variable. If the user has
!         terminated execution, info is set to the (negative)
!         value of IFLAG. See description of FCN. Otherwise,
!         info is set as follows.
!
!         info = 0  Improper input parameters.
!
!         info = 1  Algorithm estimates that the relative error
!                   in the sum of squares is at most tol.
!
!         info = 2  Algorithm estimates that the relative error
!                   between x and the solution is at most tol.
!
!         info = 3  Conditions for info = 1 And info = 2 Both hold.
!
!         info = 4  fvec is orthogonal to the columns of the
!                   Jacobian to machine precision.
!
!         info = 5  Number of calls to FCN has reached or
!                   EXCEEDED 200*(n+1).
!
!         info = 6  tol is too small. No further reduction in
!                   the sum of squares is possible.
!
!         info = 7  tol is too small. No further improvement in
!                   the approximate solution x is possible.
!
!       iwa is an integer work array of length n.
!
!       wa is a work array of length lwa.
!
!       lwa is a positive integer input variable NOT less than
!         m*n+5*n+m.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... lmdif
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge J. more
!
!     **********
info = 0
!
!     Check the input parameters for errors.
!
if (n <= 0 .or. m < n .or. epsfcn < 0.0 &
   & .or. tol < 0.0 .or. lwa < m*n + 5*n + m) go to 10
!
!     CALL lmdif.
!
maxfev = 200*(n + 1)
ftol = tol
xtol = tol
gtol = 0.0
mode = 1
nprint = 0
mp5n = m + 5*n
call lmdif(fcn,m,n,x,fvec,ftol,xtol,gtol,maxfev,epsfcn,wa(1), &
   & mode,factor,nprint,info,nfev,wa(mp5n + 1),m,iwa, &
   & wa(n + 1),wa(2*n + 1),wa(3*n + 1),wa(4*n + 1),wa(5*n + 1))
if (info == 8) info = 4
10 continue
end subroutine lmdiff

subroutine lmdif(fcn,m,n,x,fvec,ftol,xtol,gtol,maxfev,epsfcn, &
   & diag,mode,factor,nprint,info,nfev,fjac,ldfjac, &
   & ipvt,qtf,wa1,wa2,wa3,wa4)
implicit none
integer :: m, n
integer, intent(in) :: maxfev, mode, nprint
integer, intent(out) :: info, nfev
integer, intent(in) :: ldfjac
integer, intent(inout) :: ipvt(n)
real, intent(in) :: ftol, xtol, gtol, epsfcn, factor
real, intent(inout) :: x(n), fvec(m), diag(n), fjac(ldfjac,n), &
   & qtf(n), wa1(n), wa2(n), wa3(n), wa4(m)
external fcn
integer :: i, iflag, iter, j, l
real :: actred, delta, dirder, eps, fnorm, fnorm1, gnorm, par, pnorm, prered, ratio, sum, temp, temp1, temp2, xnorm
real :: enorm
real, parameter :: p1 = 1.0e-1
real, parameter :: p5 = 5.0e-1
real, parameter :: p25 = 2.5e-1
real, parameter :: p75 = 7.5e-1
real, parameter :: p0001 = 1.0e-4
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     **********
!
!     SUBROUTINE lmdif
!
!     The purpose of lmdif is to minimize the sum of the squares of
!     m nonlinear functions in n variables by a modification of
!     the Levenberg-Marquardt algorithm. The user must provide A
!     subroutine which calculates the functions. The Jacobian is
!     then calculated by a forward-difference approximation.
!
!     The subroutine statement is
!
!       subroutine lmdif(fcn,m,n,x,fvec,ftol,xtol,gtol,maxfev,epsfcn,
!                        diag,mode,factor,nprint,info,nfev,fjac,
!                        ldfjac,ipvt,QTF,WA1,WA2,WA3,WA4)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(m,n,x,fvec,iflag)
!         integer m,n,iflag
!         real x(n),fvec(m)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ----------
!         return
!         end
!
!         The value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of lmdif.
!         In this case set iflag to a negative integer.
!
!       m is a positive integer input variable SET to the number
!         of functions.
!
!       n is a positive integer input variable SET to the number
!         of variables. n must not exceed m.
!
!       x is an array of length n. on input x must contain
!         an initial estimate of the solution vector. On output x
!         contains the final estimate of the solution vector.
!
!       fvec is an output array of length m which contains
!         the functions evaluated at the output x.
!
!       ftol is a nonnegative input variable. Termination
!         occurs when both the actual and predicted relative
!         reductions in the sum of squares are at most ftol.
!         Therefore, ftol measures the relative error desired
!         in the sum of squares.
!
!       xtol is a nonnegative input variable. Termination
!         occurs when the relative error between two consecutive
!         iterates is at most xtol. Therefore, xtol measures the
!         relative error desired in the approximate solution.
!
!       gtol is a nonnegative input variable. Termination
!         occurs when the cosine of the angle between fvec and
!         any column of the Jacobian is at most gtol in absolute
!         value. Therefore, gtol measures the orthogonality
!         desired between the function vector and the columns
!         of the Jacobian.
!
!       maxfev is a positive integer input variable. Termination
!         occurs when the number of calls to FCN is at least
!         maxfev by the end of an iteration.
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
!         info = 0  Improper input parameters.
!
!         info = 1  Both actual and predicted relative reductions
!                   in the sum of squares are at most ftol.
!
!         info = 2  Relative error between two consecutive iterates
!                   is at most xtol.
!
!         info = 3  Conditions for info = 1 And info = 2 Both hold.
!
!         info = 4  The cosine of the angle between fvec and any
!                   column of the Jacobian is at most gtol in
!                   absolute value.
!
!         info = 5  Number of calls to FCN has reached or
!                   EXCEEDED maxfev.
!
!         info = 6  ftol is too small. No further reduction in
!                   the sum of squares is possible.
!
!         info = 7  xtol is too small. No further improvement in
!                   the approximate solution x is possible.
!
!         info = 8  gtol is too small. fvec is orthogonal to the
!                   columns of the Jacobian to machine precision.
!
!       nfev is an integer output variable SET to the number of
!         calls to FCN.
!
!       fjac is an output m by n array. The upper n by n submatrix
!         of fjac contains an upper triangular matrix R with
!         diagonal elements of nonincreasing magnitude such that
!
!                T     T           T
!               P *(JAC *JAC)*P = R *R,
!
!         Where P is a permutation matrix and JAC is the final
!         calculated Jacobian. Column j of P is column ipvt(j)
!         (see below) of the identity matrix. The lower trapezoidal
!         part of fjac contains information generated during
!         the computation of R.
!
!       ldfjac is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array fjac.
!
!       ipvt is an integer output array of length n. ipvt
!         defines a permutation matrix P such that JAC*P = Q*R,
!         where JAC is the final calculated Jacobian, Q is
!         orthogonal (not stored), and R is upper triangular
!         with diagonal elements of nonincreasing magnitude.
!         Column j of P is column ipvt(j) of the identity matrix.
!
!       QTF is an output array of length n which contains
!         the first n elements of the vector (Q transpose)*fvec.
!
!       WA1, WA2, and WA3 are work arrays of length n.
!
!       WA4 is a work array of length m.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... spmpar,enorm,fdjac2,lmpar,qrfac
!
!       Fortran-supplied ... abs,AMAX1,AMIN1,sqrt,mod
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
!
!     Eps is the machine precision.
!
eps = spmpar(1)
!
info = 0
iflag = 0
nfev = 0
!
!     Check the input parameters for errors.
!
if (n <= 0 .or. m < n .or. ldfjac < m &
   & .or. ftol < 0.0 .or. xtol < 0.0 .or. gtol < 0.0 &
   & .or. maxfev <= 0 .or. factor <= 0.0) go to 300
if (mode /= 2) go to 20
do j = 1, n
   if (diag(j) <= 0.0) go to 300
end do
20 continue
!
!     Evaluate the function at the starting point
!     and calculate its norm.
!
iflag = 1
call fcn(m,n,x,fvec,iflag)
nfev = 1
if (iflag < 0) go to 300
fnorm = enorm(m,fvec)
!
!     Initialize Levenberg-Marquardt parameter and iteration counter.
!
par = 0.0
iter = 1
!
!     Beginning of the outer loop.
!
30 continue
!
!        Calculate the Jacobian matrix.
!
iflag = 2
call fdjac2(fcn,m,n,x,fvec,fjac,ldfjac,iflag,epsfcn,wa4)
nfev = nfev + n
if (iflag < 0) go to 300
!
!        If requested, call FCN to enable printing of iterates.
!
if (nprint <= 0) go to 40
iflag = 0
if (mod(iter - 1,nprint) == 0) call fcn(m,n,x,fvec,iflag)
if (iflag < 0) go to 300
40 continue
!
!        Compute the QR factorization of the Jacobian.
!
call qrfac(m,n,fjac,ldfjac,.true.,ipvt,n,wa1,wa2,wa3)
!
!        On the first iteration and if mode is 1, scale according
!        to the norms of the columns of the initial Jacobian.
!
if (iter /= 1) go to 80
if (mode == 2) go to 60
do j = 1, n
   diag(j) = wa2(j)
   if (wa2(j) == 0.0) diag(j) = 1.0
end do
60 continue
!
!        On the first iteration, calculate the norm of the scaled x
!        and initialize the step bound delta.
!
do j = 1, n
   wa3(j) = diag(j)*x(j)
end do
xnorm = enorm(n,wa3)
delta = factor*xnorm
if (delta == 0.0) delta = factor
80 continue
!
!        Form (Q transpose)*fvec and store the first n components in
!        QTF.
!
do i = 1, m
   wa4(i) = fvec(i)
end do
do j = 1, n
   if (fjac(j,j) == 0.0) go to 120
   sum = 0.0
   do i = j, m
      sum = sum + fjac(i,j)*wa4(i)
   end do
   temp = -sum/fjac(j,j)
   do i = j, m
      wa4(i) = wa4(i) + fjac(i,j)*temp
   end do
120 continue
   fjac(j,j) = wa1(j)
   qtf(j) = wa4(j)
end do
!
!        Compute the norm of the scaled gradient.
!
gnorm = 0.0
if (fnorm == 0.0) go to 170
do j = 1, n
   l = ipvt(j)
   if (wa2(l) == 0.0) go to 150
   sum = 0.0
   do i = 1, j
      sum = sum + fjac(i,j)*(qtf(i)/fnorm)
   end do
   gnorm = max(gnorm,abs(sum/wa2(l)))
150 continue
end do
170 continue
!
!        Test for convergence of the gradient norm.
!
if (gnorm <= gtol) info = 4
if (info /= 0) go to 300
!
!        Rescale if necessary.
!
if (mode == 2) go to 190
do j = 1, n
   diag(j) = max(diag(j),wa2(j))
end do
190 continue
!
!        Beginning of the inner loop.
!
200 continue
!
!           Determine the Levenberg-Marquardt parameter.
!
call lmpar(n,fjac,ldfjac,ipvt,diag,qtf,delta,par,wa1,wa2, &
   & wa3,wa4)
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
call fcn(m,n,wa2,wa4,iflag)
nfev = nfev + 1
if (iflag < 0) go to 300
fnorm1 = enorm(m,wa4)
!
!           Compute the scaled actual reduction.
!
actred = -1.0
if (p1*fnorm1 < fnorm) actred = 1.0 - (fnorm1/fnorm)**2
!
!           Compute the scaled predicted reduction and
!           the scaled directional derivative.
!
do j = 1, n
   wa3(j) = 0.0
   l = ipvt(j)
   temp = wa1(l)
   do i = 1, j
      wa3(i) = wa3(i) + fjac(i,j)*temp
   end do
end do
temp1 = enorm(n,wa3)/fnorm
temp2 = (sqrt(par)*pnorm)/fnorm
prered = temp1**2 + temp2**2/p5
dirder = -(temp1**2 + temp2**2)
!
!           Compute the ratio of the actual to the predicted
!           reduction.
!
ratio = 0.0
if (prered /= 0.0) ratio = actred/prered
!
!           Update the step bound.
!
if (ratio > p25) go to 240
if (actred >= 0.0) temp = p5
if (actred < 0.0) &
   & temp = p5*dirder/(dirder + p5*actred)
if (p1*fnorm1 >= fnorm .or. temp < p1) temp = p1
delta = temp*min(delta,pnorm/p1)
par = par/temp
go to 260
240 continue
if (par /= 0.0 .and. ratio < p75) go to 250
delta = pnorm/p5
par = p5*par
250 continue
260 continue
!
!           Test for successful iteration.
!
if (ratio < p0001) go to 290
!
!           Successful iteration. Update x, fvec, and their norms.
!
do j = 1, n
   x(j) = wa2(j)
   wa2(j) = diag(j)*x(j)
end do
do i = 1, m
   fvec(i) = wa4(i)
end do
xnorm = enorm(n,wa2)
fnorm = fnorm1
iter = iter + 1
290 continue
!
!           Tests for convergence.
!
if (abs(actred) <= ftol .and. prered <= ftol &
   & .and. p5*ratio <= 1.0) info = 1
if (delta <= xtol*xnorm) info = 2
if (abs(actred) <= ftol .and. prered <= ftol &
   & .and. p5*ratio <= 1.0 .and. info == 2) info = 3
if (info /= 0) go to 300
!
!           Tests for termination and stringent tolerances.
!
if (nfev >= maxfev) info = 5
if (abs(actred) <= eps .and. prered <= eps &
   & .and. p5*ratio <= 1.0) info = 6
if (delta <= eps*xnorm) info = 7
if (gnorm <= eps) info = 8
if (info /= 0) go to 300
!
!           END OF THE INNER LOOP. REPEAT IF ITERATION UNSUCCESSFUL.
!
if (ratio < p0001) go to 200
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
if (nprint > 0) call fcn(m,n,x,fvec,iflag)
end subroutine lmdif

pure real function enorm(n,x)
implicit none
integer, intent(in) :: n
real, intent(in) :: x(n)
integer :: i
real :: agiant, floatn, s1, s2, s3, xabs, x1max, x3max
real, parameter :: rdwarf = 3.834e-20
real, parameter :: rgiant = 1.304e19
!     **********
!
!     FUNCTION enorm
!
!     Given an n-vector x, this function calculates the
!     Euclidean norm of x.
!
!     The Euclidean norm is computed by accumulating the sum of
!     squares in three different sums. The sums of squares for the
!     small and large components are scaled so that no overflows
!     occur. Non-destructive underflows are permitted. Underflows
!     and overflows do not occur in the computation of the unscaled
!     sum of squares for the intermediate components.
!     The definitions of small, intermediate and large components
!     depend on two constants, rdwarf and rgiant. The main
!     restrictions on these constants are that rdwarf**2 not
!     underflow and rgiant**2 not overflow. The constants
!     given here are suitable for every known computer.
!
!     The function statement is
!
!       REAL FUNCTION enorm(n,x)
!
!     Where
!
!       n is a positive integer input variable.
!
!       x is an input array of length n.
!
!     Subprograms called
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge J. more
!
!     **********
!
s1 = 0.0
s2 = 0.0
s3 = 0.0
x1max = 0.0
x3max = 0.0
floatn = n
agiant = rgiant/floatn
do i = 1, n
   xabs = abs(x(i))
   if (xabs > rdwarf .and. xabs < agiant) go to 70
   if (xabs <= rdwarf) go to 30
!
!              Sum for large components.
!
   if (xabs <= x1max) go to 10
   s1 = 1.0 + s1*(x1max/xabs)**2
   x1max = xabs
   go to 20
10 continue
   s1 = s1 + (xabs/x1max)**2
20 continue
   go to 60
30 continue
!
!              Sum for small components.
!
   if (xabs <= x3max) go to 40
   s3 = 1.0 + s3*(x3max/xabs)**2
   x3max = xabs
   go to 50
40 continue
   if (xabs /= 0.0) s3 = s3 + (xabs/x3max)**2
50 continue
60 continue
   go to 80
70 continue
!
!           Sum for intermediate components.
!
   s2 = s2 + xabs**2
80 continue
90 continue
end do
!
!     Calculation of norm.
!
if (s1 == 0.0) go to 100
enorm = x1max*sqrt(s1 + (s2/x1max)/x1max)
go to 130
100 continue
if (s2 == 0.0) go to 110
if (s2 >= x3max) &
   & enorm = sqrt(s2*(1.0 + (x3max/s2)*(x3max*s3)))
if (s2 < x3max) &
   & enorm = sqrt(x3max*((s2/x3max) + (x3max*s3)))
go to 120
110 continue
enorm = x3max*sqrt(s3)
120 continue
130 continue
end function enorm

pure subroutine dogleg(n,r,lr,diag,qtb,delta,x,wa1,wa2)
implicit none
integer, intent(in) :: n, lr
real, intent(in) :: delta
real, intent(in) :: r(lr), diag(n), qtb(n)
real, intent(inout) :: x(n), wa1(n), wa2(n)
integer :: i, j, jj, jp1, k, l
real :: alpha, bnorm, epsmch, gnorm, qnorm, sgnorm, sum, temp
interface
   pure function enorm(n,x)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: x(n)
      real :: enorm
   end function enorm
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     **********
!
!     Subroutine dogleg
!
!     Given an M by n matrix A, an n by n nonsingular diagonal
!     matrix D, an M-vector B, and a positive number delta, the
!     problem is to determine the convex combination x of the
!     Gauss-Newton and scaled gradient directions that minimizes
!     (A*x - B) in the least squares sense, subject to the
!     restriction that the Euclidean norm of D*x be at most delta.
!
!     This subroutine completes the solution of the problem
!     if it is provided with the necessary information from the
!     QR factorization of A. that is, if A = Q*r, where Q has
!     orthogonal columns and r is an upper triangular matrix,
!     then dogleg expects the full upper triangle of r and
!     the first n components of (Q transpose)*B.
!
!     The subroutine statement is
!
!       subroutine dogleg(n,r,lr,diag,qtb,delta,x,wa1,wa2)
!
!     Where
!
!       n is a positive integer input variable SET to the order of r.
!
!       r is an input array of length lr which must contain the upper
!         triangular matrix r stored by rows.
!
!       lr is a positive integer input variable NOT less than
!         (n*(n+1))/2.
!
!       Diag is an input array of length n which must contain the
!         diagonal elements of the matrix D.
!
!       qtb is an input array of length n which must contain the first
!         n elements of the vector (Q transpose)*B.
!
!       delta is a positive input variable which specifies an upper
!         bound on the Euclidean norm of D*x.
!
!       x is an output array of length n which contains the desired
!         convex combination of the Gauss-Newton direction and the
!         scaled gradient direction.
!
!       wa1 and wa2 are work arrays of length n.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar,enorm
!
!       Fortran-supplied ... abs,AMAX1,AMIN1,sqrt
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
!     First, calculate the Gauss-Newton direction.
!
jj = (n*(n + 1))/2 + 1
do k = 1, n
   j = n - k + 1
   jp1 = j + 1
   jj = jj - k
   l = jj + 1
   sum = 0.0
   if (n < jp1) go to 20
   do i = jp1, n
      sum = sum + r(l)*x(i)
      l = l + 1
   end do
20 continue
   temp = r(jj)
   if (temp /= 0.0) go to 40
   l = j
   do i = 1, j
      temp = max(temp,abs(r(l)))
      l = l + n - i
   end do
   temp = epsmch*temp
   if (temp == 0.0) temp = epsmch
40 continue
   x(j) = (qtb(j) - sum)/temp
end do
!
!     Test whether the Gauss-Newton direction is acceptable.
!
do j = 1, n
   wa1(j) = 0.0
   wa2(j) = diag(j)*x(j)
end do
qnorm = enorm(n,wa2)
if (qnorm <= delta) go to 140
!
!     The Gauss-Newton direction is not acceptable.
!     Next, calculate the scaled gradient direction.
!
l = 1
do j = 1, n
   temp = qtb(j)
   do i = j, n
      wa1(i) = wa1(i) + r(l)*temp
      l = l + 1
   end do
   wa1(j) = wa1(j)/diag(j)
end do
!
!     Calculate the norm of the scaled gradient and test for
!     the special case in which the scaled gradient is zero.
!
gnorm = enorm(n,wa1)
sgnorm = 0.0
alpha = delta/qnorm
if (gnorm == 0.0) go to 120
!
!     Calculate the point along the scaled gradient
!     at which the quadratic is minimized.
!
do j = 1, n
   wa1(j) = (wa1(j)/gnorm)/diag(j)
end do
l = 1
do j = 1, n
   sum = 0.0
   do i = j, n
      sum = sum + r(l)*wa1(i)
      l = l + 1
   end do
   wa2(j) = sum
end do
temp = enorm(n,wa2)
sgnorm = (gnorm/temp)/temp
!
!     Test whether the scaled gradient direction is acceptable.
!
alpha = 0.0
if (sgnorm >= delta) go to 120
!
!     The scaled gradient direction is not acceptable.
!     Finally, calculate the point along the dogleg
!     at which the quadratic is minimized.
!
bnorm = enorm(n,qtb)
temp = (bnorm/gnorm)*(bnorm/qnorm)*(sgnorm/delta)
temp = temp - (delta/qnorm)*(sgnorm/delta)**2 &
   & + sqrt((temp - (delta/qnorm))**2 &
   & + (1.0 - (delta/qnorm)**2)*(1.0 - (sgnorm/delta)**2))
alpha = ((delta/qnorm)*(1.0 - (sgnorm/delta)**2))/temp
120 continue
!
!     Form appropriate convex combination of the Gauss-Newton
!     direction and the scaled gradient direction.
!
temp = (1.0 - alpha)*min(sgnorm,delta)
do j = 1, n
   x(j) = temp*wa1(j) + alpha*x(j)
end do
140 continue
end subroutine dogleg

subroutine fdjac1(fcn,n,x,fvec,fjac,ldfjac,iflag,ml,mu,epsfcn, &
   & wa1,wa2)
implicit none
integer :: n
integer, intent(in) :: ldfjac
integer :: iflag
integer, intent(in) :: ml, mu
real, intent(in) :: epsfcn
real, intent(inout) :: x(n)
real, intent(in) :: fvec(n)
real, intent(inout) :: fjac(ldfjac,n)
real :: wa1(n)
real, intent(inout) :: wa2(n)
external fcn
integer :: i, j, k, msum
real :: eps, epsmch, h, temp
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
!     SUBROUTINE fdjac1
!
!     This subroutine computes a forward-difference approximation
!     to the n by n Jacobian matrix associated with a specified
!     problem of n functions in n variables. If the Jacobian has
!     a banded form, then function evaluations are saved by only
!     approximating the nonzero terms.
!
!     The subroutine statement is
!
!       subroutine fdjac1(fcn,n,x,fvec,fjac,ldfjac,iflag,ml,mu,epsfcn,
!                         wa1,wa2)
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
!         ----------
!         return
!         end
!
!         The value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of fdjac1.
!         In this case set iflag to a negative integer.
!
!       n is a positive integer input variable SET to the number
!         of functions and variables.
!
!       x is an input array of length n.
!
!       fvec is an input array of length n which must contain the
!         functions evaluated at x.
!
!       fjac is an output n by n array which contains the
!         approximation to the Jacobian matrix evaluated at x.
!
!       ldfjac is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array fjac.
!
!       iflag is an integer variable which can be used to terminate
!         the execution of fdjac1. See description of FCN.
!
!       ml is a nonnegative integer input variable which specifies
!         the number of subdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         ml to at least n - 1.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       mu is a nonnegative integer input variable which specifies
!         the number of superdiagonals within the band of the
!         Jacobian matrix. If the Jacobian is not banded, set
!         mu to at least n - 1.
!
!       wa1 and wa2 are work arrays of length n. if ml + mu + 1 is at
!         least n, then the Jacobian is considered dense, and wa2 is
!         not referenced.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar
!
!       Fortran-supplied ... abs,AMAX1,sqrt
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
eps = sqrt(max(epsfcn,epsmch))
msum = ml + mu + 1
if (msum < n) go to 40
!
!        Computation of dense approximate Jacobian.
!
do j = 1, n
   temp = x(j)
   h = eps*abs(temp)
   if (h == zero) h = eps
   x(j) = temp + h
   call fcn(n,x,wa1,iflag)
   if (iflag < 0) go to 30
   x(j) = temp
   do i = 1, n
      fjac(i,j) = (wa1(i) - fvec(i))/h
   end do
end do
30 continue
go to 110
40 continue
!
!        Computation of banded approximate Jacobian.
!
do k = 1, msum
   do j = k, n, msum
      wa2(j) = x(j)
      h = eps*abs(wa2(j))
      if (h == zero) h = eps
      x(j) = wa2(j) + h
   end do
   call fcn(n,x,wa1,iflag)
   if (iflag < 0) go to 100
   do j = k, n, msum
      x(j) = wa2(j)
      h = eps*abs(wa2(j))
      if (h == zero) h = eps
      do i = 1, n
         fjac(i,j) = zero
         if (i >= j - mu .and. i <= j + ml) &
            & fjac(i,j) = (wa1(i) - fvec(i))/h
      end do
   end do
end do
100 continue
110 continue
!
!     Last card of subroutine fdjac1.
!
end subroutine fdjac1

subroutine fdjac2(fcn,m,n,x,fvec,fjac,ldfjac,iflag,epsfcn,wa)
implicit none
integer :: m, n
integer, intent(in) :: ldfjac
integer :: iflag
real, intent(in) :: epsfcn
real, intent(inout) :: x(n)
real, intent(in) :: fvec(m)
real, intent(inout) :: fjac(ldfjac,n)
real :: wa(m)
external fcn
integer :: i, j
real :: eps, epsmch, h, temp
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
!     SUBROUTINE fdjac2
!
!     This subroutine computes a forward-difference approximation
!     to the m by n Jacobian matrix associated with a specified
!     problem of m functions in n variables.
!
!     The subroutine statement is
!
!       subroutine fdjac2(fcn,m,n,x,fvec,fjac,ldfjac,iflag,epsfcn,wa)
!
!     Where
!
!       FCN is the name of the user-supplied subroutine which
!         calculates the functions. FCN must be declared
!         in an external statement in the user calling
!         program, and should be written as follows.
!
!         subroutine fcn(m,n,x,fvec,iflag)
!         integer m,n,iflag
!         real x(n),fvec(m)
!         ----------
!         Calculate the functions at x and
!         RETURN THIS VECTOR IN fvec.
!         ----------
!         return
!         end
!
!         The value of iflag should not be changed by FCN unless
!         the user wants to terminate execution of fdjac2.
!         In this case set iflag to a negative integer.
!
!       m is a positive integer input variable SET to the number
!         of functions.
!
!       n is a positive integer input variable SET to the number
!         of variables. n must not exceed m.
!
!       x is an input array of length n.
!
!       fvec is an input array of length m which must contain the
!         functions evaluated at x.
!
!       fjac is an output m by n array which contains the
!         approximation to the Jacobian matrix evaluated at x.
!
!       ldfjac is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array fjac.
!
!       iflag is an integer variable which can be used to terminate
!         the execution of fdjac2. See description of FCN.
!
!       epsfcn is an input variable used in determining a suitable
!         step length for the forward-difference approximation. This
!         approximation assumes that the relative errors in the
!         functions are of the order of epsfcn. If epsfcn is less
!         than the machine precision, it is assumed that the relative
!         errors in the functions are of the order of the machine
!         precision.
!
!       wa is a work array of length m.
!
!     Subprograms called
!
!       User-supplied ...... FCN
!
!       MINPACK-supplied ... spmpar
!
!       Fortran-supplied ... abs,AMAX1,sqrt
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
eps = sqrt(max(epsfcn,epsmch))
do j = 1, n
   temp = x(j)
   h = eps*abs(temp)
   if (h == zero) h = eps
   x(j) = temp + h
   call fcn(m,n,x,wa,iflag)
   if (iflag < 0) go to 30
   x(j) = temp
   do i = 1, m
      fjac(i,j) = (wa(i) - fvec(i))/h
   end do
end do
30 continue
!
!     Last card of subroutine fdjac2.
!
end subroutine fdjac2

pure subroutine lmpar(n,r,ldr,ipvt,diag,qtb,delta,par,x,sdiag,wa1, &
   & wa2)
implicit none
integer, intent(in) :: n, ldr
integer, intent(in) :: ipvt(n)
real, intent(in) :: delta
real, intent(inout) :: par
real, intent(inout) :: r(ldr,n)
real, intent(in) :: diag(n), qtb(n)
real, intent(inout) :: x(n), sdiag(n), wa1(n), wa2(n)
integer :: i, iter, j, jm1, jp1, k, l, nsing
real :: dxnorm, dwarf, fp, gnorm, parc, parl, paru, sum, temp
real, parameter :: p1 = 1.0e-1
real, parameter :: p001 = 1.0e-3
real, parameter :: zero = 0.0e0
interface
   pure function enorm(n,x)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: x(n)
      real :: enorm
   end function enorm
   pure subroutine qrsolv(n,r,ldr,ipvt,diag,qtb,x,sdiag,wa)
      implicit none
      integer, intent(in) :: ldr
      integer, intent(in) :: n
      real, intent(inout) :: r(ldr,n)
      integer, intent(in) :: ipvt(n)
      real, intent(in) :: diag(n)
      real, intent(in) :: qtb(n)
      real, intent(inout) :: x(n)
      real, intent(inout) :: sdiag(n)
      real, intent(inout) :: wa(n)
   end subroutine qrsolv
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     **********
!
!     SUBROUTINE lmpar
!
!     Given an M by n matrix A, an n by n nonsingular diagonal
!     matrix D, an M-vector B, and a positive number delta,
!     the problem is to determine a value for the parameter
!     par such that if x solves the system
!
!           A*x = B ,     sqrt(par)*D*x = 0 ,
!
!     In the least squares sense, and dxnorm is the Euclidean
!     norm of D*x, then either par is zero and
!
!           (dxnorm-delta) .LE. 0.1*delta ,
!
!     Or par is positive and
!
!           abs(dxnorm-delta) .LE. 0.1*delta .
!
!     This subroutine completes the solution of the problem
!     if it is provided with the necessary information from the
!     QR factorization, with column pivoting, of A. that is, if
!     A*P = Q*r, where P is a permutation matrix, Q has orthogonal
!     columns, and r is an upper triangular matrix with diagonal
!     elements of nonincreasing magnitude, then lmpar expects
!     the full upper triangle of r, the permutation matrix P,
!     and the first n components of (Q transpose)*B. on output
!     lmpar also provides an upper triangular matrix S such that
!
!            T   T                   T
!           P *(A *A + par*D*D)*P = S *S .
!
!     S is employed within lmpar and may be of separate interest.
!
!     Only a few iterations are generally needed for convergence
!     of the algorithm. If, however, the limit of 10 iterations
!     is reached, then the output par will contain the best
!     value obtained so far.
!
!     The subroutine statement is
!
!       subroutine lmpar(n,r,ldr,ipvt,diag,qtb,delta,par,x,sdiag,
!                        wa1,wa2)
!
!     Where
!
!       n is a positive integer input variable SET to the order of r.
!
!       r is an n by n array. On input the full upper triangle
!         must contain the full upper triangle of the matrix r.
!         On output the full upper triangle is unaltered, and the
!         strict lower triangle contains the strict upper triangle
!         (transposed) of the upper triangular matrix S.
!
!       ldr is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array r.
!
!       ipvt is an integer input array of length n which defines the
!         permutation matrix P such that A*P = Q*r. column j of P
!         is column ipvt(j) of the identity matrix.
!
!       Diag is an input array of length n which must contain the
!         diagonal elements of the matrix D.
!
!       qtb is an input array of length n which must contain the first
!         n elements of the vector (Q transpose)*B.
!
!       delta is a positive input variable which specifies an upper
!         bound on the Euclidean norm of D*x.
!
!       Par is a nonnegative variable. On input par contains an
!         initial estimate of the Levenberg-Marquardt parameter.
!         On output par contains the final estimate.
!
!       x is an output array of length n which contains the least
!         squares solution of the system A*x = B, sqrt(par)*D*x = 0,
!         for the output par.
!
!       sdiag is an output array of length n which contains the
!         diagonal elements of the upper triangular matrix S.
!
!       wa1 and wa2 are work arrays of length n.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar,enorm,qrsolv
!
!       Fortran-supplied ... abs,AMAX1,AMIN1,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
!
!     Dwarf is the smallest positive magnitude.
!
dwarf = spmpar(2)
!
!     Compute and store in x the Gauss-Newton direction. If the
!     Jacobian is rank-deficient, obtain a least squares solution.
!
nsing = n
do j = 1, n
   wa1(j) = qtb(j)
   if (r(j,j) == zero .and. nsing == n) nsing = j - 1
   if (nsing < n) wa1(j) = zero
10 continue
end do
if (nsing < 1) go to 50
do k = 1, nsing
   j = nsing - k + 1
   wa1(j) = wa1(j)/r(j,j)
   temp = wa1(j)
   jm1 = j - 1
   if (jm1 < 1) go to 30
   do i = 1, jm1
      wa1(i) = wa1(i) - r(i,j)*temp
   end do
30 continue
end do
50 continue
do j = 1, n
   l = ipvt(j)
   x(l) = wa1(j)
end do
!
!     Initialize the iteration counter.
!     Evaluate the function at the origin, and test
!     for acceptance of the Gauss-Newton direction.
!
iter = 0
do j = 1, n
   wa2(j) = diag(j)*x(j)
end do
dxnorm = enorm(n,wa2)
fp = dxnorm - delta
if (fp <= p1*delta) go to 220
!
!     If the Jacobian is not rank deficient, the Newton
!     step provides a lower bound, parl, for the zero of
!     the function. Otherwise set this bound to zero.
!
parl = zero
if (nsing < n) go to 120
do j = 1, n
   l = ipvt(j)
   wa1(j) = diag(l)*(wa2(l)/dxnorm)
end do
do j = 1, n
   sum = zero
   jm1 = j - 1
   if (jm1 < 1) go to 100
   do i = 1, jm1
      sum = sum + r(i,j)*wa1(i)
   end do
100 continue
   wa1(j) = (wa1(j) - sum)/r(j,j)
end do
temp = enorm(n,wa1)
parl = ((fp/delta)/temp)/temp
120 continue
!
!     Calculate an upper bound, paru, for the zero of the function.
!
do j = 1, n
   sum = zero
   do i = 1, j
      sum = sum + r(i,j)*qtb(i)
   end do
   l = ipvt(j)
   wa1(j) = sum/diag(l)
end do
gnorm = enorm(n,wa1)
paru = gnorm/delta
if (paru == zero) paru = dwarf/min(delta,p1)
!
!     If the input par lies outside of the interval (parl,paru),
!     set par to the closer endpoint.
!
par = max(par,parl)
par = min(par,paru)
if (par == zero) par = gnorm/dxnorm
!
!     Beginning of an iteration.
!
150 continue
iter = iter + 1
!
!        Evaluate the function at the current value of par.
!
if (par == zero) par = max(dwarf,p001*paru)
temp = sqrt(par)
do j = 1, n
   wa1(j) = temp*diag(j)
end do
call qrsolv(n,r,ldr,ipvt,wa1,qtb,x,sdiag,wa2)
do j = 1, n
   wa2(j) = diag(j)*x(j)
end do
dxnorm = enorm(n,wa2)
temp = fp
fp = dxnorm - delta
!
!        If the function is small enough, accept the current value
!        of par. Also test for the exceptional cases where parl
!        is zero or the number of iterations has reached 10.
!
if (abs(fp) <= p1*delta &
   & .or. parl == zero .and. fp <= temp &
   & .and. temp < zero .or. iter == 10) go to 220
!
!        Compute the Newton correction.
!
do j = 1, n
   l = ipvt(j)
   wa1(j) = diag(l)*(wa2(l)/dxnorm)
end do
do j = 1, n
   wa1(j) = wa1(j)/sdiag(j)
   temp = wa1(j)
   jp1 = j + 1
   if (n < jp1) go to 200
   do i = jp1, n
      wa1(i) = wa1(i) - r(i,j)*temp
   end do
200 continue
end do
temp = enorm(n,wa1)
parc = ((fp/delta)/temp)/temp
!
!        Depending on the sign of the function, update parl or paru.
!
if (fp > zero) parl = max(parl,par)
if (fp < zero) paru = min(paru,par)
!
!        Compute an improved estimate for par.
!
par = max(parl,par + parc)
!
!        END OF AN ITERATION.
!
go to 150
220 continue
!
!     Termination.
!
if (iter == 0) par = zero
!
!     Last card of subroutine lmpar.
!
end subroutine lmpar

pure subroutine qform(m,n,q,ldq,wa)
implicit none
integer, intent(in) :: m, n, ldq
real, intent(inout) :: q(ldq,m), wa(m)
integer :: i, j, jm1, k, l, minmn, np1
real :: sum, temp
real, parameter :: one = 1.0e0
real, parameter :: zero = 0.0e0
!     **********
!
!     SUBROUTINE qform
!
!     This subroutine proceeds from the computed QR factorization of
!     an m by n matrix A to accumulate the m by m orthogonal matrix
!     q from its factored form.
!
!     The subroutine statement is
!
!       subroutine qform(m,n,q,ldq,wa)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of A and the order of q.
!
!       n is a positive integer input variable SET to the number
!         of columns of A.
!
!       q is an m by m array. On input the full lower trapezoid in
!         the first min(m,n) columns of q contains the factored form.
!         On output q has been accumulated into a square matrix.
!
!       ldq is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array q.
!
!       wa is a work array of length m.
!
!     Subprograms called
!
!       Fortran-supplied ... MIN0
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
!
!     Zero out upper triangle of q in the first min(m,n) columns.
!
minmn = min(m,n)
if (minmn < 2) go to 30
do j = 2, minmn
   jm1 = j - 1
   do i = 1, jm1
      q(i,j) = zero
   end do
end do
30 continue
!
!     Initialize remaining columns to those of the identity matrix.
!
np1 = n + 1
if (m < np1) go to 60
do j = np1, m
   do i = 1, m
      q(i,j) = zero
   end do
   q(j,j) = one
end do
60 continue
!
!     Accumulate q from its factored form.
!
do l = 1, minmn
   k = minmn - l + 1
   do i = k, m
      wa(i) = q(i,k)
      q(i,k) = zero
   end do
   q(k,k) = one
   if (wa(k) == zero) go to 110
   do j = k, m
      sum = zero
      do i = k, m
         sum = sum + q(i,j)*wa(i)
      end do
      temp = sum/wa(k)
      do i = k, m
         q(i,j) = q(i,j) - temp*wa(i)
      end do
   end do
110 continue
end do
!
!     Last card of subroutine qform.
!
end subroutine qform

pure subroutine qrfac(m,n,a,lda,pivot,ipvt,lipvt,rdiag,acnorm,wa)
implicit none
integer, intent(in) :: m, n, lda, lipvt
integer, intent(inout) :: ipvt(lipvt)
logical, intent(in) :: pivot
real, intent(inout) :: a(lda,n), rdiag(n), acnorm(n), wa(n)
integer :: i, j, jp1, k, kmax, minmn
real :: ajnorm, epsmch, sum, temp
real, parameter :: one = 1.0e0
real, parameter :: p05 = 5.0e-2
real, parameter :: zero = 0.0e0
interface
   pure function enorm(n,x)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: x(n)
      real :: enorm
   end function enorm
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     **********
!
!     SUBROUTINE qrfac
!
!     This subroutine uses Householder transformations with column
!     pivoting (optional) to compute A QR factorization of the
!     m by n matrix a. that is, qrfac determines an orthogonal
!     matrix Q, a permutation matrix P, and an upper trapezoidal
!     matrix R with diagonal elements of nonincreasing magnitude,
!     such that a*P = Q*R. the Householder transformation for
!     column k, k = 1,2,...,min(m,n), is of the form
!
!                           T
!           i - (1/U(k))*U*U
!
!     Where U has zeros in the first k-1 positions. The form of
!     this transformation and the method of pivoting first
!     appeared in the corresponding LINPACK subroutine.
!
!     The subroutine statement is
!
!       subroutine qrfac(m,n,a,lda,pivot,ipvt,lipvt,rdiag,acnorm,wa)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of A.
!
!       n is a positive integer input variable SET to the number
!         of columns of A.
!
!       A is an m by n array. On input a contains the matrix for
!         which the QR factorization is to be computed. On output
!         the strict upper trapezoidal part of a contains the strict
!         upper trapezoidal part of R, and the lower trapezoidal
!         part of a contains a factored form of Q (the non-trivial
!         elements of the U vectors described above).
!
!       lda is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array a.
!
!       Pivot is a logical input variable. If pivot is set true,
!         then column pivoting is enforced. If pivot is set false,
!         then no column pivoting is done.
!
!       ipvt is an integer output array of length lipvt. ipvt
!         defines the permutation matrix P such that a*P = Q*R.
!         Column j of P is column ipvt(j) of the identity matrix.
!         If pivot is false, ipvt is not referenced.
!
!       lipvt is a positive integer input variable. If pivot is false,
!         then lipvt may be as small as 1. If pivot is true, then
!         lipvt must be at least n.
!
!       rdiag is an output array of length n which contains the
!         diagonal elements of R.
!
!       acnorm is an output array of length n which contains the
!         norms of the corresponding columns of the input matrix a.
!         If this information is not needed, then acnorm can coincide
!         WITH rdiag.
!
!       wa is a work array of length n. if pivot is false, then wa
!         can coincide with rdiag.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar,enorm
!
!       Fortran-supplied ... AMAX1,sqrt,MIN0
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
!     Compute the initial column norms and initialize several arrays.
!
do j = 1, n
   acnorm(j) = enorm(m,a(1,j))
   rdiag(j) = acnorm(j)
   wa(j) = rdiag(j)
   if (pivot) ipvt(j) = j
end do
!
!     Reduce A to R with Householder transformations.
!
minmn = min(m,n)
do j = 1, minmn
   if (.not.pivot) go to 40
!
!        Bring the column of largest norm into the pivot position.
!
   kmax = j
   do k = j, n
      if (rdiag(k) > rdiag(kmax)) kmax = k
   end do
   if (kmax == j) go to 40
   do i = 1, m
      temp = a(i,j)
      a(i,j) = a(i,kmax)
      a(i,kmax) = temp
   end do
   rdiag(kmax) = rdiag(j)
   wa(kmax) = wa(j)
   k = ipvt(j)
   ipvt(j) = ipvt(kmax)
   ipvt(kmax) = k
40 continue
!
!        Compute the Householder transformation to reduce the
!        j-TH column of A to a multiple of the j-TH unit vector.
!
   ajnorm = enorm(m - j + 1,a(j,j))
   if (ajnorm == zero) go to 100
   if (a(j,j) < zero) ajnorm = -ajnorm
   do i = j, m
      a(i,j) = a(i,j)/ajnorm
   end do
   a(j,j) = a(j,j) + one
!
!        Apply the transformation to the remaining columns
!        and update the norms.
!
   jp1 = j + 1
   if (n < jp1) go to 100
   do k = jp1, n
      sum = zero
      do i = j, m
         sum = sum + a(i,j)*a(i,k)
      end do
      temp = sum/a(j,j)
      do i = j, m
         a(i,k) = a(i,k) - temp*a(i,j)
      end do
      if (.not.pivot .or. rdiag(k) == zero) go to 80
      temp = a(j,k)/rdiag(k)
      rdiag(k) = rdiag(k)*sqrt(max(zero,one - temp**2))
      if (p05*(rdiag(k)/wa(k))**2 > epsmch) go to 80
      rdiag(k) = enorm(m - j,a(jp1,k))
      wa(k) = rdiag(k)
80    continue
   end do
100 continue
   rdiag(j) = -ajnorm
end do
!
!     Last card of subroutine qrfac.
!
end subroutine qrfac

pure subroutine qrsolv(n,r,ldr,ipvt,diag,qtb,x,sdiag,wa)
implicit none
integer, intent(in) :: n, ldr
integer, intent(in) :: ipvt(n)
real, intent(inout) :: r(ldr,n)
real, intent(in) :: diag(n), qtb(n)
real, intent(inout) :: x(n), sdiag(n), wa(n)
integer :: i, j, jp1, k, kp1, l, nsing
real :: cos, cotan, qtbpj, sin, sum, tan, temp
real, parameter :: p5 = 5.0e-1
real, parameter :: p25 = 2.5e-1
real, parameter :: zero = 0.0e0
!     **********
!
!     SUBROUTINE qrsolv
!
!     Given an M by n matrix A, an n by n diagonal matrix D,
!     and an M-vector B, the problem is to determine an x which
!     solves the system
!
!           A*x = B ,     D*x = 0 ,
!
!     In the least squares sense.
!
!     This subroutine completes the solution of the problem
!     if it is provided with the necessary information from the
!     QR factorization, with column pivoting, of A. that is, if
!     A*P = Q*r, where P is a permutation matrix, Q has orthogonal
!     columns, and r is an upper triangular matrix with diagonal
!     elements of nonincreasing magnitude, then qrsolv expects
!     the full upper triangle of r, the permutation matrix P,
!     and the first n components of (Q transpose)*B. the system
!     A*x = B, D*x = 0, is then equivalent to
!
!                  T       T
!           r*Z = Q *B ,  P *D*P*Z = 0 ,
!
!     Where x = P*Z. if this system does not have full rank,
!     then a least squares solution is obtained. On output qrsolv
!     also provides an upper triangular matrix S such that
!
!            T   T               T
!           P *(A *A + D*D)*P = S *S .
!
!     S is computed within qrsolv and may be of separate interest.
!
!     The subroutine statement is
!
!       subroutine qrsolv(n,r,ldr,ipvt,diag,qtb,x,sdiag,wa)
!
!     Where
!
!       n is a positive integer input variable SET to the order of r.
!
!       r is an n by n array. On input the full upper triangle
!         must contain the full upper triangle of the matrix r.
!         On output the full upper triangle is unaltered, and the
!         strict lower triangle contains the strict upper triangle
!         (transposed) of the upper triangular matrix S.
!
!       ldr is a positive integer input variable NOT less than n
!         which specifies the leading dimension of the array r.
!
!       ipvt is an integer input array of length n which defines the
!         permutation matrix P such that A*P = Q*r. column j of P
!         is column ipvt(j) of the identity matrix.
!
!       Diag is an input array of length n which must contain the
!         diagonal elements of the matrix D.
!
!       qtb is an input array of length n which must contain the first
!         n elements of the vector (Q transpose)*B.
!
!       x is an output array of length n which contains the least
!         squares solution of the system A*x = B, D*x = 0.
!
!       sdiag is an output array of length n which contains the
!         diagonal elements of the upper triangular matrix S.
!
!       wa is a work array of length n.
!
!     Subprograms called
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
!
!     Copy r and (Q transpose)*B to preserve input and initialize S.
!     In particular, save the diagonal elements of r in x.
!
do j = 1, n
   do i = j, n
      r(i,j) = r(j,i)
   end do
   x(j) = r(j,j)
   wa(j) = qtb(j)
end do
!
!     Eliminate the diagonal matrix D using a Givens rotation.
!
do j = 1, n
!
!        Prepare the row of D to be eliminated, locating the
!        diagonal element using P from the QR factorization.
!
   l = ipvt(j)
   if (diag(l) == zero) go to 90
   do k = j, n
      sdiag(k) = zero
   end do
   sdiag(j) = diag(l)
!
!        The transformations to eliminate the row of D
!        modify only a single element of (Q transpose)*B
!        beyond the first n, which is initially zero.
!
   qtbpj = zero
   do k = j, n
!
!           Determine a Givens rotation which eliminates the
!           appropriate element in the current row of D.
!
      if (sdiag(k) == zero) go to 70
      if (abs(r(k,k)) >= abs(sdiag(k))) go to 40
      cotan = r(k,k)/sdiag(k)
      sin = p5/sqrt(p25 + p25*cotan**2)
      cos = sin*cotan
      go to 50
40    continue
      tan = sdiag(k)/r(k,k)
      cos = p5/sqrt(p25 + p25*tan**2)
      sin = cos*tan
50    continue
!
!           Compute the modified diagonal element of r and
!           the modified element of ((Q transpose)*B,0).
!
      r(k,k) = cos*r(k,k) + sin*sdiag(k)
      temp = cos*wa(k) + sin*qtbpj
      qtbpj = -sin*wa(k) + cos*qtbpj
      wa(k) = temp
!
!           Accumulate the tranformation in the row of S.
!
      kp1 = k + 1
      if (n < kp1) go to 70
      do i = kp1, n
         temp = cos*r(i,k) + sin*sdiag(i)
         sdiag(i) = -sin*r(i,k) + cos*sdiag(i)
         r(i,k) = temp
      end do
70    continue
   end do
90 continue
!
!        Store the diagonal element of S and restore
!        the corresponding diagonal element of r.
!
   sdiag(j) = r(j,j)
   r(j,j) = x(j)
end do
!
!     Solve the triangular system for Z. if the system is
!     singular, then obtain a least squares solution.
!
nsing = n
do j = 1, n
   if (sdiag(j) == zero .and. nsing == n) nsing = j - 1
   if (nsing < n) wa(j) = zero
end do
if (nsing < 1) go to 150
do k = 1, nsing
   j = nsing - k + 1
   sum = zero
   jp1 = j + 1
   if (nsing < jp1) go to 130
   do i = jp1, nsing
      sum = sum + r(i,j)*wa(i)
   end do
130 continue
   wa(j) = (wa(j) - sum)/sdiag(j)
end do
150 continue
!
!     Permute the components of Z back to components of x.
!
do j = 1, n
   l = ipvt(j)
   x(l) = wa(j)
end do
!
!     Last card of subroutine qrsolv.
!
end subroutine qrsolv

pure subroutine r1mpyq(m,n,a,lda,v,w)
implicit none
integer, intent(in) :: m, n, lda
real, intent(inout) :: a(lda,n)
real, intent(in) :: v(n), w(n)
integer :: i, j, nmj, nm1
real :: cos, sin, temp
real, parameter :: one = 1.0e0
!     **********
!
!     SUBROUTINE r1mpyq
!
!     Given an m by n matrix a, this subroutine computes a*Q where
!     Q is the product of 2*(n - 1) transformations
!
!           GV(n-1)*...*GV(1)*GW(1)*...*GW(n-1)
!
!     And GV(i), GW(i) are Givens rotations in the (i,n) plane which
!     eliminate elements in the i-TH and n-TH planes, respectively.
!     Q itself is not given, rather the information to recover the
!     GV, GW ROTATIONS IS SUPPLIED.
!
!     The subroutine statement is
!
!       subroutine r1mpyq(m,n,a,lda,v,w)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of A.
!
!       n is a positive integer input variable SET to the number
!         of columns of A.
!
!       A is an m by n array. On input A must contain the matrix
!         to be postmultiplied by the orthogonal matrix Q
!         described above. On output a*Q has replaced A.
!
!       lda is a positive integer input variable NOT less than m
!         which specifies the leading dimension of the array a.
!
!       v is an input array of length n. v(i) must contain the
!         information necessary to recover the Givens rotation GV(i)
!         described above.
!
!       w is an input array of length n. w(i) must contain the
!         information necessary to recover the Givens rotation GW(i)
!         described above.
!
!     Subroutines called
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton S. Garbow, kenneth E. Hillstrom, jorge j. more
!
!     **********
!
!     Apply the first set of Givens rotations to A.
!
nm1 = n - 1
if (nm1 < 1) go to 50
do nmj = 1, nm1
   j = n - nmj
   if (abs(v(j)) > one) cos = one/v(j)
   if (abs(v(j)) > one) sin = sqrt(one - cos**2)
   if (abs(v(j)) <= one) sin = v(j)
   if (abs(v(j)) <= one) cos = sqrt(one - sin**2)
   do i = 1, m
      temp = cos*a(i,j) - sin*a(i,n)
      a(i,n) = sin*a(i,j) + cos*a(i,n)
      a(i,j) = temp
   end do
end do
!
!     Apply the second set of Givens rotations to A.
!
do j = 1, nm1
   if (abs(w(j)) > one) cos = one/w(j)
   if (abs(w(j)) > one) sin = sqrt(one - cos**2)
   if (abs(w(j)) <= one) sin = w(j)
   if (abs(w(j)) <= one) cos = sqrt(one - sin**2)
   do i = 1, m
      temp = cos*a(i,j) + sin*a(i,n)
      a(i,n) = -sin*a(i,j) + cos*a(i,n)
      a(i,j) = temp
   end do
end do
50 continue
!
!     Last card of subroutine r1mpyq.
!
end subroutine r1mpyq

pure subroutine r1updt(m,n,s,ls,u,v,w,sing)
implicit none
integer, intent(in) :: m, n, ls
logical, intent(inout) :: sing
real, intent(inout) :: s(ls)
real, intent(in) :: u(m)
real, intent(inout) :: v(n), w(m)
integer :: i, j, jj, l, nmj, nm1
real :: cos, cotan, giant, sin, tan, tau, temp
real, parameter :: one = 1.0e0
real, parameter :: p5 = 5.0e-1
real, parameter :: p25 = 2.5e-1
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
!     SUBROUTINE r1updt
!
!     Given an m by n lower trapezoidal matrix s, an m-vector u,
!     and an n-vector v, the problem is to determine an
!     orthogonal matrix Q such that
!
!                   T
!           (s + u*v )*Q
!
!     Is again lower trapezoidal.
!
!     This subroutine determines Q as the product of 2*(n - 1)
!     transformations
!
!           GV(n-1)*...*GV(1)*GW(1)*...*GW(n-1)
!
!     Where GV(i), GW(i) are Givens rotations in the (i,n) plane
!     which eliminate elements in the i-TH and n-TH planes,
!     respectively. Q itself is not accumulated, rather the
!     information to recover the GV, GW rotations is returned.
!
!     The subroutine statement is
!
!       subroutine r1updt(m,n,s,ls,u,v,w,sing)
!
!     Where
!
!       m is a positive integer input variable SET to the number
!         of rows of s.
!
!       n is a positive integer input variable SET to the number
!         of columns of s. n must not exceed m.
!
!       s is an array of length ls. On input s must contain the lower
!         trapezoidal matrix s stored by columns. On output s contains
!         the lower trapezoidal matrix produced as described above.
!
!       ls is a positive integer input variable NOT less than
!         (n*(2*m-n+1))/2.
!
!       u is an input array of length m which must contain the
!         VECTOR u.
!
!       v is an array of length n. on input v must contain the vector
!         v. on output v(i) contains the information necessary to
!         recover the Givens rotation GV(i) described above.
!
!       w is an output array of length m. w(i) contains information
!         necessary to recover the Givens rotation GW(i) described
!         above.
!
!       Sing is a logical output variable. Sing is set true if any
!         of the diagonal elements of the output s are zero. Otherwise
!         sing is set false.
!
!     Subprograms called
!
!       MINPACK-supplied ... spmpar
!
!       Fortran-supplied ... abs,sqrt
!
!     Argonne National Laboratory. MINPACK project. March 1980.
!     Burton s. Garbow, kenneth E. Hillstrom, jorge j. more,
!     john l. nazareth
!
!     **********
!
!     Giant is the largest magnitude.
!
giant = spmpar(3)
!
!     Initialize the diagonal element pointer.
!
jj = (n*(2*m - n + 1))/2 - (m - n)
!
!     Move the nontrivial part of the last column of s into w.
!
l = jj
do i = n, m
   w(i) = s(l)
   l = l + 1
end do
!
!     Rotate the vector v into a multiple of the n-TH unit vector
!     in such a way that a spike is introduced into w.
!
nm1 = n - 1
if (nm1 < 1) go to 70
do nmj = 1, nm1
   j = n - nmj
   jj = jj - (m - j + 1)
   w(j) = zero
   if (v(j) == zero) go to 50
!
!        Determine a Givens rotation which eliminates the
!        j-TH element of v.
!
   if (abs(v(n)) >= abs(v(j))) go to 20
   cotan = v(n)/v(j)
   sin = p5/sqrt(p25 + p25*cotan**2)
   cos = sin*cotan
   tau = one
   if (abs(cos)*giant > one) tau = one/cos
   go to 30
20 continue
   tan = v(j)/v(n)
   cos = p5/sqrt(p25 + p25*tan**2)
   sin = cos*tan
   tau = sin
30 continue
!
!        Apply the transformation to v and store the information
!        necessary to recover the Givens rotation.
!
   v(n) = sin*v(j) + cos*v(n)
   v(j) = tau
!
!        Apply the transformation to s and extend the spike in w.
!
   l = jj
   do i = j, m
      temp = cos*s(l) - sin*w(i)
      w(i) = sin*s(l) + cos*w(i)
      s(l) = temp
      l = l + 1
   end do
50 continue
end do
70 continue
!
!     Add the spike from the rank 1 update to w.
!
do i = 1, m
   w(i) = w(i) + v(n)*u(i)
end do
!
!     Eliminate the spike.
!
sing = .false.
if (nm1 < 1) go to 140
do j = 1, nm1
   if (w(j) == zero) go to 120
!
!        Determine a Givens rotation which eliminates the
!        j-TH element of the spike.
!
   if (abs(s(jj)) >= abs(w(j))) go to 90
   cotan = s(jj)/w(j)
   sin = p5/sqrt(p25 + p25*cotan**2)
   cos = sin*cotan
   tau = one
   if (abs(cos)*giant > one) tau = one/cos
   go to 100
90 continue
   tan = w(j)/s(jj)
   cos = p5/sqrt(p25 + p25*tan**2)
   sin = cos*tan
   tau = sin
100 continue
!
!        Apply the transformation to s and reduce the spike in w.
!
   l = jj
   do i = j, m
      temp = cos*s(l) + sin*w(i)
      w(i) = -sin*s(l) + cos*w(i)
      s(l) = temp
      l = l + 1
   end do
!
!        Store the information necessary to recover the
!        Givens rotation.
!
   w(j) = tau
120 continue
!
!        Test for zero diagonal elements in the output s.
!
   if (s(jj) == zero) sing = .true.
   jj = jj + (m - j + 1)
end do
140 continue
!
!     Move w back into the last column of the output s.
!
l = jj
do i = n, m
   s(l) = w(i)
   l = l + 1
end do
if (s(jj) == zero) sing = .true.
!
!     Last card of subroutine r1updt.
!
end subroutine r1updt

subroutine smplx(a,b0,c,ka,m,n0,ind,ibasis,x,z,iter,mxiter, &
   & numle,numge,bi,wk,iwk)
implicit none
integer, intent(inout) :: ibasis, ind, iter, iwk(*)
integer, intent(in) :: ka
integer :: m
integer, intent(in) :: mxiter, n0, numge, numle
real :: a(ka,n0), b0(m)
real, intent(inout) :: bi(m,m)
real :: c(n0)
real, intent(inout) :: wk(*), x(*), z
integer :: ip
real :: eps0, rerr, rerrmn, rerrmx
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!     Simplex procedure for solving linear programming problems
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!------------------------
!     Initial version  DEC  1977
!     LAST UPDATE      OCT  1990
!------------------------
dimension ibasis(m)
!------------------------
!     dimension x(n0+numle+numge)
!     dimension wk(2*m),iwk(2*m+n0)
!------------------------
!
!     ********** eps0 is a machine dependent parameter. Assign eps0
!                the value U where U is the smallest positive floating
!                point number such that 1.0 + U .GT. 1.0.
!
eps0 = spmpar(1)
!
!------------------------
rerrmn = 10.0*eps0
rerrmx = 1.e-4
if (eps0 < 1.e-13) rerrmx = 1.e-5
!
ip = m + n0 + 1
call smplx1(a,b0,c,ka,m,n0,ind,ibasis,x,z,iter,mxiter, &
   & eps0,rerrmn,rerrmx,rerr,numle,numge,bi, &
   & wk(1),wk(m + 1),iwk(1),iwk(ip))
end subroutine smplx

pure subroutine smplx1(a,b0,c,ka,m,n0,ind,ibasis,r,z,iter,mxiter, &
   & eps0,rerrmn,rerrmx,rerr,numle,numge,bi,xb,y,basis,index)
implicit none
integer, intent(inout) :: ind
integer, intent(out) :: iter
integer, intent(in) :: ka, m, mxiter, n0, numge, numle
real, intent(in) :: eps0
real, intent(inout) :: rerr
real, intent(in) :: rerrmn, rerrmx
real, intent(out) :: z
real, intent(in) :: a(ka,n0), b0(m), c(n0)
real, intent(inout) :: bi(m,m), xb(m), y(m), r(*)
integer, intent(inout) :: ibasis(m), basis(*)
integer, intent(inout) :: index(m)
integer :: i, ibeg, icount, iend, ierr, ii, il, imin, iout, ip, j, jcol, jj, jmin, jp, k, ki, kj, l, ll, lrow, m0, mcheck, ms, n, &
   & npos, nrow, ns, nstep, num, bflag, nswc_ai_i4
real :: amax, binorm, bmax, bmin, bnorm, cmin, const, eps, epsi, ratio, rerr1, rmin, rtol, s, sgn, sum, t, tol, w, xmax, nswc_ai_r4
double precision :: dsum, dsump, dsumn, dt
interface
   pure subroutine crout1(a,ka,n,iend,index,temp,jp,ierr)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: a(*)
      integer, intent(in) :: ka
      integer, intent(in) :: iend
      integer, intent(inout) :: index(*)
      real, intent(inout) :: temp(n)
      integer, intent(inout) :: jp
      integer, intent(inout) :: ierr
   end subroutine crout1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!----------------------
!     NSTEP = 1   Eliminate the negative variables
!     NSTEP = 2   Phase 1 of the simplex algorithm
!     NSTEP = 3   Phase 2 of the simplex algorithm
!----------------------
!     mxiter = The maximum number of iterations permitted
!     iter = The number of the current iteration
!     icount = The number of iterations since the last inversion
!----------------------
!     numle = The number of .LE. constraints
!     numge = The number of .GE. constraints
!----------------------
!     The routine assumes that the .LE. constraints precede the .GE.
!     Constraints and that the .EQ. constraints come last. There are
!     m constraints. X(n0+i) is the slack, surplus, or artificial
!     variable for the i-TH constraint (i=1,...,m).
!----------------------
!     n0 = The number of orginal variables
!     NS = The number of orginal and slack variables
!     N  = The number of orginal, slack, and surplus variables
!     NUM = The total number of variables
!----------------------
!     rerrmn = The smallest relative error tolerance used
!     rerrmx = The largest relative error TOLERACE used
!     rerr   = The estimated current relative error
!----------------------
!     Assume that
!         b0 = (b0(1),...,b0(m))
!         c  = (c(1),...,c(n0))
!         z  = c(1)*x(1)+...+c(n0)*x(n0)
!     the problem is to maximize z subject to
!         AX(le,EQ,GE)b0
!         X.GE.0
!----------------------
!     On input ind can have the values
!         ind = 0   No beginning basis is provided by the user
!         ind = 1   The array ibasis has been set by the user
!     on output ind is assigned one of the values
!         ind = 0   z was successfully maximized
!         ind = 1   The problem has no feasible solution
!         ind = 2   mxiter iterations were performed
!         ind = 3   Sufficient accuracy cannot be maintained
!         ind = 4   The problem has an unbounded solution
!         ind = 5   There is an input error
!         ind = 6   z was possibly maximized
!----------------------
!     Basis is an integer array of dimension n0+m. for j.LE.N
!         basis(j) = 1  If X(j) is a BASIC variable
!         basis(j) = 0  If X(j) is not a BASIC variable
!     if the BASIC variables are X(I1),...,X(IM) then
!         ibasis = (i1,...,im)
!     also xb(1),...,xb(m) are the corresponding values of the
!     BASIC variables.
!----------------------
!     bi is an MXM array containing the inverse of the basis matrix.
!----------------------
!     r is an array of dimension N. on output r contains the current
!     value of X. during computation r normally contains the reduced
!     costs used for the selection of the variable to be made BASIC.
!----------------------
!----------------------
!
!     ****** Xmax is a machine dependent constant. Xmax is the
!            largest positive floating point number.
!
xmax = spmpar(3)
!
!----------------------
iter = 0
icount = 0
mcheck = min(5,1 + m/15)
z = 0.0
!
!                Check for input errors
!
ms = numle + numge
if (m < 2 .or. n0 < 2 .or. ms > m .or. ka < m) &
   & go to 12
do i = 1,m
   if (b0(i) < 0.0) go to 12
10 xb(i) = 0.0
end do
rtol = xmax
do i = 1,n0
   if (c(i) /= 0.0) rtol = min(abs(c(i)),rtol)
end do
rtol = rerrmx*rtol
go to 20
!
12 ind = 5
return
!
!     Formation of the ibasis and basis arrays. (If ind = 1
!     then the ibasis array is defined by the user.)
!
20 ns = n0 + numle
n = ns + numge
if (ind == 0) go to 30
num = n
do i = 1,m
   if (ibasis(i) > n) num = num + 1
end do
go to 32
22 if (ind == 0) go to 590
ind = 0
!
30 num = n0 + m
do i = 1,m
31 ibasis(i) = n0 + i
end do
32 bflag = 0
do i = 1,n
33 basis(i) = 0
end do
do i = 1,m
   ki = ibasis(i)
34 basis(ki) = 1
end do
if (ind == 1) go to 100
!
!          Calculation of xb and bi when ind = 0
!
rerr = rerrmn
do j = 1,m
   xb(j) = b0(j)
   do i = 1,m
40    bi(i,j) = 0.0
   end do
   bi(j,j) = 1.0
end do
if (numge == 0) go to 630
jmin = numle + 1
do j = jmin,ms
   xb(j) = -xb(j)
   bi(j,j) = -1.0
end do
go to 601
!
!                  Reorder the basis
!
100 ibeg = 1
iend = m
do i = 1,m
   if (ibasis(i) <= n0) go to 101
   index(ibeg) = ibasis(i)
   ibeg = ibeg + 1
   go to 102
101 index(iend) = ibasis(i)
   iend = iend - 1
102 continue
end do
if (iend == m) go to 22
do i = 1,m
103 ibasis(i) = index(i)
end do
!
!            REINVERSION of the basis matrix
!
do j = 1,m
   kj = ibasis(j)
   if (kj <= n0) go to 110
   if (kj <= ns) go to 120
   if (kj <= n) go to 130
   go to 120
!
110 do i = 1,m
111   bi(i,j) = a(i,kj)
   end do
   go to 132
!
120 l = kj - n0
   do i = 1,m
121   bi(i,j) = 0.0
   end do
   bi(l,j) = 1.0
   go to 132
!
130 l = kj - n0
   do i = 1,m
131   bi(i,j) = 0.0
   end do
   bi(l,j) = -1.0
132 continue
end do
!
icount = 0
call crout1(bi, m, m, iend, index, y, jcol, ierr)
if (ierr /= 0) go to 580
!
!         Check the accuracy of bi and reset rerr
!
bnorm = 0.0
do j = 1,m
   kj = ibasis(j)
   if (kj <= n0) go to 140
   sum = 1.0
   go to 142
140 sum = 0.0
   do i = 1,m
141   sum = sum + abs(a(i,kj))
   end do
142 bnorm = max(bnorm,sum)
end do
!
binorm = 0.0
do j = 1,m
   sum = 0.0
   do i = 1,m
150   sum = sum + abs(bi(i,j))
   end do
   binorm = max(binorm,sum)
end do
rerr = max(rerrmn,eps0*bnorm*binorm)
if (rerr > 1.e-2) go to 580
bflag = 0
!
!                 Recalculation of xb
!
180 do i = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do l = 1,m
      dt = bi(i,l)*b0(l)
      if (dt > 0.d0) go to 181
      dsumn = dsumn + dt
      go to 182
181   dsump = dsump + dt
182   continue
   end do
   xb(i) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*max(s,-t)
   if (abs(xb(i)) < tol) xb(i) = 0.0
end do
go to 601
!
!     Find the next vector a(--,JP) to be inserted into
!                       the basis
!
200 jp = 0
rmin = 0.0
if (nstep == 3) rmin = -rtol
do j = 1,n0
   if (basis(j) /= 0) go to 201
   if (r(j) >= rmin) go to 201
   jp = j
   rmin = r(j)
201 continue
end do
if (n0 == n) go to 203
jmin = n0 + 1
rmin = rmin*1.1
do j = jmin,n
   if (basis(j) /= 0) go to 202
   if (r(j) >= rmin) go to 202
   jp = j
   rmin = r(j)
202 continue
end do
203 if (jp /= 0) go to 300
nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 800
if ( nswc_ai_i4 == 0 ) go to 230
go to 250
!
!     Insert the values of the orginal, slack, and surplus
!             variables into r. then terminate.
!
220 do j = 1,n
221 r(j) = 0.0
end do
do i = 1,m
   ki = ibasis(i)
   if (ki <= n) r(ki) = xb(i)
end do
return
!
!             Completion of the NSTEP = 2 Case
!
230 do i = 1,m
   if (ibasis(i) <= n) go to 231
   if (xb(i) > 0.0) go to 800
231 continue
end do
go to 680
!
240 if (icount >= 5) go to 100
ind = 1
go to 220
!
!             Completion of the NSTEP = 3 Case
!
250 if (rerr > 1.e-2) go to 251
ind = 0
go to 800
251 if (icount >= 5) go to 100
ind = 6
go to 800
!
!     If mxiter iterations have not been performed then
!     begin the next iteration. Compute the JP-TH column
!               of bi*a and store it in y.
!
300 if (iter < mxiter) go to 301
ind = 2
go to 220
301 iter = iter + 1
icount = icount + 1
if (jp > ns) go to 330
if (jp > n0) go to 320
!
nrow = 0
amax = 0.0
do i = 1,m
   if (a(i,jp) == 0.0) go to 305
   nrow = nrow + 1
   index(nrow) = i
   amax = max(abs(a(i,jp)),amax)
305 continue
end do
if (nrow /= 0) go to 310
ind = 4
go to 220
!
310 rerr1 = rerrmx*amax
do i = 1,m
   dsum = 0.d0
   do ll = 1,nrow
      l = index(ll)
      dsum = dsum + dble(bi(i,l)*a(l,jp))
   end do
   y(i) = dsum
   if (abs(y(i)) >= 5.e-3) go to 313
   bmax = 0.0
   do l = 1,m
      bmax = max(abs(bi(i,l)),bmax)
   end do
   tol = rerr1*bmax
   if (abs(y(i)) < tol) y(i) = 0.0
313 continue
end do
go to 350
!
320 l = jp - n0
do i = 1,m
   y(i) = bi(i,l)
end do
go to 350
!
330 l = jp - n0
do i = 1,m
   y(i) = -bi(i,l)
end do
!
350 do i = 1,m
   if (y(i) /= 0.0) go to 360
end do
r(jp) = 0.0
iter = iter - 1
icount = icount - 1
go to 200
!
360 nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 400
if ( nswc_ai_i4 == 0 ) go to 430
go to 440
!
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 1 Case
!
400 npos = 0
ip = 0
eps = 0.0
epsi = xmax
do i = 1,m
   if (xb(i) < 0.0 .or. y(i) <= 0.0) go to 403
   ratio = xb(i)/y(i)
   nswc_ai_r4 = ratio - epsi
   if ( nswc_ai_r4 < 0 ) go to 401
   if ( nswc_ai_r4 == 0 ) go to 402
   go to 403
401 epsi = ratio
   npos = 1
   index(1) = i
   go to 403
402 npos = npos + 1
   index(npos) = i
403 continue
end do
if (npos == 0) go to 420
if (epsi == 0.0) go to 460
!
do i = 1,m
   if (xb(i) >= 0.0 .or. y(i) >= 0.0) go to 410
   ratio = xb(i)/y(i)
   if (ratio > epsi) go to 410
   if (ratio < eps) go to 410
   eps = ratio
   ip = i
410 continue
end do
if (ip /= 0) go to 500
go to 460
!
420 do i = 1,m
   if (xb(i) >= 0.0 .or. y(i) >= 0.0) go to 421
   ratio = xb(i)/y(i)
   if (ratio < eps) go to 421
   eps = ratio
   ip = i
421 continue
end do
go to 500
!
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 2 Case
!
430 npos = 0
epsi = xmax
do i = 1,m
   if (y(i) <= 0.0) go to 433
   ratio = xb(i)/y(i)
   nswc_ai_r4 = ratio - epsi
   if ( nswc_ai_r4 < 0 ) go to 431
   if ( nswc_ai_r4 == 0 ) go to 432
   go to 433
431 epsi = ratio
   npos = 1
   index(1) = i
   go to 433
432 npos = npos + 1
   index(npos) = i
433 continue
end do
go to 450
!
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 3 Case
!
440 npos = 0
epsi = xmax
do i = 1,m
   nswc_ai_r4 = y ( i )
   if ( nswc_ai_r4 < 0 ) go to 441
   if ( nswc_ai_r4 == 0 ) go to 445
   go to 442
441 if (ibasis(i) <= n) go to 445
   ip = i
   go to 500
442 ratio = xb(i)/y(i)
   nswc_ai_r4 = ratio - epsi
   if ( nswc_ai_r4 < 0 ) go to 443
   if ( nswc_ai_r4 == 0 ) go to 444
   go to 445
443 epsi = ratio
   npos = 1
   index(1) = i
   go to 445
444 npos = npos + 1
   index(npos) = i
445 continue
end do
!
450 if (npos /= 0) go to 460
if (icount >= 5) go to 100
ind = 4
go to 220
!
!              Tie breaking procedure
!
460 ip = index(1)
if (npos == 1) go to 500
ip = 0
bmin = xmax
cmin = xmax
do ii = 1,npos
   i = index(ii)
   l = ibasis(i)
   if (l > n0) go to 461
   if (c(l) <= 0.0) cmin = min(0.0,cmin)
   if (c(l) > cmin) go to 464
   imin = i
   cmin = c(l)
   go to 464
461 if (l <= n) go to 462
   ip = i
   go to 500
462 lrow = l - n0
   s = b0(lrow)
   if (lrow > numle) go to 463
   if (s > bmin) go to 464
   ip = i
   bmin = s
   go to 464
463 s = -s
   bmin = min(0.0,bmin)
   if (s > bmin) go to 464
   ip = i
   bmin = s
464 continue
end do
if (cmin <= 0.0 .or. ip == 0) ip = imin
!
!               Transformation of xb
!
500 if (xb(ip) == 0.0) go to 510
const = xb(ip)/y(ip)
do i = 1,m
   s = xb(i)
   xb(i) = xb(i) - const*y(i)
   if (xb(i) >= 0.0) go to 501
   if (s >= 0.0 .or. xb(i) >= rerrmx*s) xb(i) = 0.0
501 continue
end do
xb(ip) = const
!
!               Transformation of bi
!
510 do j = 1,m
   if (bi(ip,j) == 0.0) go to 512
   const = bi(ip,j)/y(ip)
   do i = 1,m
511   bi(i,j) = bi(i,j) - const*y(i)
   end do
   bi(ip,j) = const
512 continue
end do
!
!             Updating ibasis and basis
!
iout = ibasis(ip)
ibasis(ip) = jp
basis(iout) = 0
basis(jp) = 1
if (iout > n) num = num - 1
!
!        Check the accuracy of bi and reset rerr
!
if (rerr > 1.e-2) go to 530
k = 0
do j = 1,m
   kj = ibasis(j)
   if (kj > n0) go to 521
   sum = 0.0
   do l = 1,m
      if (a(l,kj) /= 0.0) sum = sum + bi(j,l)*a(l,kj)
   end do
   rerr = max(rerr,abs(1.0 - sum))
   k = k + 1
   if (k >= mcheck) go to 522
521 continue
end do
522 if (rerr <= 1.e-2) go to 600
!
!        The accuracy criteria are not satisfied
!
530 if (icount < 5) go to 600
bflag = 1
go to 100
!
580 if (iter == 0) go to 12
if (bflag == 0) go to 590
bflag = 0
do ip = 1,m
   if (jp == ibasis(ip)) go to 582
end do
582 ibasis(ip) = iout
basis(jp) = 0
basis(iout) = 1
if (iout > n) num = num + 1
go to 100
!
590 ind = 3
go to 220
!
!       Set up the r array for the NSTEP = 1 Case
!
600 nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 601
if ( nswc_ai_i4 == 0 ) go to 630
go to 700
601 do j = 1,m
   if (xb(j) < 0.0) go to 610
end do
go to 630
!
610 nstep = 1
m0 = 0
do l = 1,m
   if (xb(l) >= 0.0) go to 611
   m0 = m0 + 1
   index(m0) = l
611 continue
end do
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do ll = 1,m0
      l = index(ll)
      nswc_ai_r4 = bi( l , j )
      if ( nswc_ai_r4 < 0 ) go to 620
      if ( nswc_ai_r4 == 0 ) go to 622
      go to 621
620   dsumn = dsumn + dble(bi(l,j))
      go to 622
621   dsump = dsump + dble(bi(l,j))
622   continue
   end do
   y(j) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*max(s,-t)
   if (abs(y(j)) < tol) y(j) = 0.0
end do
go to 650
!
!       Set up the r array for the NSTEP = 2 Case
!
630 if (n == num) go to 680
nstep = 2
m0 = 0
do l = 1,m
   if (ibasis(l) <= n) go to 631
   m0 = m0 + 1
   index(m0) = l
631 continue
end do
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do ll = 1,m0
      l = index(ll)
      nswc_ai_r4 = bi( l , j )
      if ( nswc_ai_r4 < 0 ) go to 640
      if ( nswc_ai_r4 == 0 ) go to 642
      go to 641
640   dsumn = dsumn + dble(bi(l,j))
      go to 642
641   dsump = dsump + dble(bi(l,j))
642   continue
   end do
   y(j) = -(dsump + dsumn)
   s = dsump
   t = dsumn
   tol = rerrmx*max(s,-t)
   if (abs(y(j)) < tol) y(j) = 0.0
end do
!
650 do j = 1,n0
   sum = 0.0
   if (basis(j) /= 0) go to 652
   do l = 1,m
      if (a(l,j) /= 0.0) sum = sum + y(l)*a(l,j)
   end do
652 r(j) = sum
end do
!
660 if (n0 == ns) go to 670
jmin = n0 + 1
do j = jmin,ns
   r(j) = 0.0
   if (basis(j) /= 0) go to 661
   jj = j - n0
   r(j) = y(jj)
661 continue
end do
!
670 if (ns == n) go to 200
jmin = ns + 1
do j = jmin,n
   r(j) = 0.0
   if (basis(j) /= 0) go to 671
   jj = j - n0
   r(j) = -y(jj)
671 continue
end do
go to 200
!
!      Set up a new r array for the NSTEP = 3 Case
!
680 nstep = 3
do j = 1,m
   dsum = 0.d0
   do l = 1,m
      il = ibasis(l)
      if (il <= n0) dsum = dsum + dble(c(il)*bi(l,j))
   end do
682 y(j) = dsum
end do
!
do j = 1,n0
   r(j) = 0.0
   if (basis(j) /= 0) go to 691
   dsum = -c(j)
   do l = 1,m
      if (a(l,j) /= 0.0) dsum = dsum + dble(y(l)*a(l,j))
   end do
   r(j) = dsum
   if (r(j) >= 0.0) go to 691
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) < tol) r(j) = 0.0
691 continue
end do
go to 660
!
!       Update the r array for the NSTEP = 3 Case
!
700 const = r(jp)
do j = 1,n0
   if (basis(j) == 0) go to 701
   r(j) = 0.0
   go to 703
701 sum = 0.0
   do l = 1,m
      if (a(l,j) /= 0.0) sum = sum + bi(ip,l)*a(l,j)
   end do
   r(j) = r(j) - const*sum
   if (r(j) >= 0.0) go to 703
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) < tol) r(j) = 0.0
703 continue
end do
!
710 if (n0 == ns) go to 720
jmin = n0 + 1
do j = jmin,ns
   if (basis(j) == 0) go to 711
   r(j) = 0.0
   go to 712
711 jj = j - n0
   r(j) = r(j) - const*bi(ip,jj)
712 continue
end do
!
720 if (ns == n) go to 200
jmin = ns + 1
do j = jmin,n
   if (basis(j) == 0) go to 721
   r(j) = 0.0
   go to 722
721 jj = j - n0
   r(j) = r(j) + const*bi(ip,jj)
722 continue
end do
go to 200
!-----------------------------------------------------------------------
!               Refine xb and store the result in y
!-----------------------------------------------------------------------
800 do i = 1,m
   y(i) = 0.0
end do
!
m0 = 0
do j = 1,m
   kj = ibasis(j)
   if (kj <= n0) go to 810
   if (kj <= ns) go to 820
   if (kj <= n) go to 830
   go to 820
!
810 m0 = m0 + 1
   index(m0) = j
   go to 831
!
820 l = kj - n0
   y(l) = xb(j)
   go to 831
!
830 l = kj - n0
   y(l) = -xb(j)
831 continue
end do
!
if (m0 /= 0) go to 841
do i = 1,m
840 r(i) = b0(i) - y(i)
end do
go to 850
841 do i = 1,m
   dsum = y(i)
   do jj = 1,m0
      j = index(jj)
      kj = ibasis(j)
      dsum = dsum + dble(a(i,kj)*xb(j))
   end do
   r(i) = b0(i) - dsum
end do
!
850 rerr1 = min(rerrmx,rerr)
do i = 1,m
   y(i) = 0.0
   nswc_ai_r4 = xb ( i )
   if ( nswc_ai_r4 < 0 ) go to 851
   if ( nswc_ai_r4 == 0 ) go to 856
   go to 852
851 sgn = -1.0
   dsump = 0.d0
   dsumn = xb(i)
   go to 853
852 sgn = 1.0
   dsump = xb(i)
   dsumn = 0.d0
853 do l = 1,m
      dt = bi(i,l)*r(l)
      if (dt > 0.d0) go to 854
      dsumn = dsumn + dt
      go to 855
854   dsump = dsump + dt
855   continue
   end do
   w = dsump + dsumn
   if (w == 0.0) go to 856
   if (sgn /= sign(1.0,w)) go to 856
   s = dsump
   t = dsumn
   tol = rerr1*max(s,-t)
   if (abs(w) > tol) y(i) = w
856 continue
end do
nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 860
if ( nswc_ai_i4 == 0 ) go to 870
go to 880
!
!         Check the refinement (NSTEP = 1)
!
860 do i = 1,m
   if (y(i) >= 0.0) go to 861
   if (y(i) < -rerrmx) go to 240
   y(i) = 0.0
861 xb(i) = y(i)
end do
go to 630
!
!         Check the refinement (NSTEP = 2)
!
870 do i = 1,m
   if (ibasis(i) <= n) go to 871
   if (y(i) > rerrmx) go to 240
   y(i) = 0.0
871 xb(i) = y(i)
end do
go to 680
!
!              COMPUTE z  (NSTEP = 3)
!
880 dsum = 0.d0
do i = 1,m
   ki = ibasis(i)
   if (ki > n0) go to 881
   dsum = dsum + dble(c(ki)*y(i))
881 xb(i) = y(i)
end do
z = dsum
go to 220
end subroutine smplx1

subroutine ssplx(ta,ita,jta,b0,c,m,n0,ind,ibasis,x,z,iter,mxiter, &
   & numle,numge,bi,wk,iwk)
implicit none
integer, intent(inout) :: ibasis, ind
integer :: ita(*)
integer, intent(inout) :: iter, iwk(*)
integer :: jta(*), m
integer, intent(in) :: mxiter, n0, numge, numle
real :: b0(m)
real, intent(inout) :: bi(m,m)
real :: c(n0), ta(*)
real, intent(inout) :: wk(*), x(*), z
integer :: ip
real :: eps0, rerr, rerrmn, rerrmx
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!     Simplex procedure for solving linear programming problems
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!------------------------
!     Initial version  DEC  1977
!     LAST UPDATE      OCT  1990
!------------------------
dimension ibasis(m)
!------------------------
!     dimension x(n0+numle+numge)
!     dimension wk(2*m),iwk(2*m+n0)
!------------------------
!
!     ********** eps0 is a machine dependent parameter. Assign eps0
!                the value U where U is the smallest positive floating
!                point number such that 1.0 + U .GT. 1.0.
!
eps0 = spmpar(1)
!
!------------------------
rerrmn = 10.0*eps0
rerrmx = 1.e-4
if (eps0 < 1.e-13) rerrmx = 1.e-5
!
ip = m + n0 + 1
call ssplx1(ta,ita,jta,b0,c,m,n0,ind,ibasis,x,z,iter,mxiter, &
   & eps0,rerrmn,rerrmx,rerr,numle,numge,bi, &
   & wk(1),wk(m + 1),iwk(1),iwk(ip))
end subroutine ssplx

pure subroutine ssplx1(ta,ita,jta,b0,c,m,n0,ind,ibasis,r,z, &
   & iter,mxiter,eps0,rerrmn,rerrmx,rerr,numle,numge, &
   & bi,xb,y,basis,index)
implicit none
integer, intent(inout) :: ind
integer, intent(out) :: iter
integer, intent(in) :: m, mxiter, n0, numge, numle
real, intent(in) :: eps0
real, intent(inout) :: rerr
real, intent(in) :: rerrmn, rerrmx
real, intent(out) :: z
real, intent(in) :: ta(*), b0(m), c(n0)
real, intent(inout) :: bi(m,m), xb(m), y(m), r(*)
integer, intent(in) :: ita(*), jta(*)
integer, intent(inout) :: ibasis(m), basis(*)
integer, intent(inout) :: index(m)
integer :: i, ibeg, icount, iend, ierr, ii, il, imin, iout, ip, j, jcol, jj, jmin, jp, k, ki, kj, l, ll, lmax, lmin, lrow, m0, &
   & mcheck, ms, n, npos, ns, nstep, num, bflag, nswc_ai_i4
real :: amax, binorm, bmax, bmin, bnorm, cmin, const, eps, epsi, ratio, rerr1, rmin, rtol, s, sgn, sum, t, tol, w, xmax, nswc_ai_r4
double precision :: dsum, dsump, dsumn, dt
interface
   pure subroutine crout1(a,ka,n,iend,index,temp,jp,ierr)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: a(*)
      integer, intent(in) :: ka
      integer, intent(in) :: iend
      integer, intent(inout) :: index(*)
      real, intent(inout) :: temp(n)
      integer, intent(inout) :: jp
      integer, intent(inout) :: ierr
   end subroutine crout1
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!----------------------
!     NSTEP = 1   Eliminate the negative variables
!     NSTEP = 2   Phase 1 of the simplex algorithm
!     NSTEP = 3   Phase 2 of the simplex algorithm
!----------------------
!     mxiter = The maximum number of iterations permitted
!     iter = The number of the current iteration
!     icount = The number of iterations since the last inversion
!----------------------
!     numle = The number of .LE. constraints
!     numge = The number of .GE. constraints
!----------------------
!     The routine assumes that the .LE. constraints precede the .GE.
!     Constraints and that the .EQ. constraints come last. There are
!     m constraints. X(n0+i) is the slack, surplus, or artificial
!     variable for the i-TH constraint (i=1,...,m).
!----------------------
!     n0 = The number of orginal variables
!     NS = The number of orginal and slack variables
!     N  = The number of orginal, slack, and surplus variables
!     NUM = The total number of variables
!----------------------
!     rerrmn = The smallest relative error tolerance used
!     rerrmx = The largest relative error tolerance used
!     rerr   = The estimated current relative error
!----------------------
!     Let a denote an MXN0 matrix. The transpose of A is stored in
!     sparse form in ta,ita,jta. Assume that
!         b0 = (b0(1),...,b0(m))
!         c  = (c(1),...,c(n0))
!         z  = c(1)*x(1)+...+c(n0)*x(n0)
!     the problem is to maximize z subject to
!         AX(le,EQ,GE)b0
!         X.GE.0
!----------------------
!     On input ind can have the values
!         ind = 0   No beginning basis is provided by the user
!         ind = 1   The array ibasis has been set by the user
!     on output ind is assigned one of the values
!         ind = 0   z was successfully maximized
!         ind = 1   The problem has no feasible solution
!         ind = 2   mxiter iterations were performed
!         ind = 3   Sufficient accuracy cannot be maintained
!         ind = 4   The problem has an unbounded solution
!         ind = 5   There is an input error
!         ind = 6   z was possibly maximized
!----------------------
!     Basis is an integer array of dimension n0+m. for j.LE.N
!         basis(j) = 1  If X(j) is a BASIC variable
!         basis(j) = 0  If X(j) is not a BASIC variable
!     if the BASIC variables are X(I1),...,X(IM) then
!         ibasis = (i1,...,im)
!     also xb(1),...,xb(m) are the corresponding values of the
!     BASIC variables.
!----------------------
!     bi is an MXM array containing the inverse of the basis matrix.
!----------------------
!     r is an array of dimension N. on output r contains the current
!     value of X. during computation r normally contains the reduced
!     costs used for the selection of the variable to be made BASIC.
!----------------------
!----------------------
!
!     ****** Xmax is a machine dependent constant. Xmax is the
!            largest positive floating point number.
!
xmax = spmpar(3)
!
!----------------------
iter = 0
icount = 0
mcheck = min(5,1 + m/15)
z = 0.0
!
!                Check for input errors
!
ms = numle + numge
if (m < 2 .or. n0 < 2 .or. ms > m) go to 12
do i = 1,m
   if (b0(i) < 0.0) go to 12
10 xb(i) = 0.0
end do
rtol = xmax
do i = 1,n0
   if (c(i) /= 0.0) rtol = min(abs(c(i)),rtol)
end do
rtol = rerrmx*rtol
go to 20
!
12 ind = 5
return
!
!     Formation of the ibasis and basis arrays. (If ind = 1
!     then the ibasis array is defined by the user.)
!
20 ns = n0 + numle
n = ns + numge
if (ind == 0) go to 30
num = n
do i = 1,m
   if (ibasis(i) > n) num = num + 1
end do
go to 32
22 if (ind == 0) go to 590
ind = 0
!
30 num = n0 + m
do i = 1,m
31 ibasis(i) = n0 + i
end do
32 bflag = 0
do i = 1,n
33 basis(i) = 0
end do
do i = 1,m
   ki = ibasis(i)
34 basis(ki) = 1
end do
if (ind == 1) go to 100
!
!          Calculation of xb and bi when ind = 0
!
rerr = rerrmn
do j = 1,m
   xb(j) = b0(j)
   do i = 1,m
40    bi(i,j) = 0.0
   end do
   bi(j,j) = 1.0
end do
if (numge == 0) go to 630
jmin = numle + 1
do j = jmin,ms
   xb(j) = -xb(j)
   bi(j,j) = -1.0
end do
go to 601
!
!                  Reorder the basis
!
100 ibeg = 1
iend = m
do i = 1,m
   if (ibasis(i) <= n0) go to 101
   index(ibeg) = ibasis(i)
   ibeg = ibeg + 1
   go to 102
101 index(iend) = ibasis(i)
   iend = iend - 1
102 continue
end do
if (iend == m) go to 22
do i = 1,m
103 ibasis(i) = index(i)
end do
!
!            REINVERSION of the basis matrix
!
do j = 1,m
   kj = ibasis(j)
   if (kj <= n0) go to 110
   if (kj <= ns) go to 120
   if (kj <= n) go to 130
   go to 120
!
110 do i = 1,m
111   bi(i,j) = 0.0
   end do
   lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   if (lmin > lmax) go to 132
   do ll = lmin,lmax
      l = jta(ll)
112   bi(l,j) = ta(ll)
   end do
   go to 132
!
120 l = kj - n0
   do i = 1,m
121   bi(i,j) = 0.0
   end do
   bi(l,j) = 1.0
   go to 132
!
130 l = kj - n0
   do i = 1,m
131   bi(i,j) = 0.0
   end do
   bi(l,j) = -1.0
132 continue
end do
!
icount = 0
call crout1(bi, m, m, iend, index, y, jcol, ierr)
if (ierr /= 0) go to 580
!
!         Check the accuracy of bi and reset rerr
!
bnorm = 0.0
do j = 1,m
   kj = ibasis(j)
   if (kj <= n0) go to 140
   sum = 1.0
   go to 142
140 sum = 0.0
   lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   do ll = lmin,lmax
141   sum = sum + abs(ta(ll))
   end do
142 bnorm = max(bnorm,sum)
end do
!
binorm = 0.0
do j = 1,m
   sum = 0.0
   do i = 1,m
150   sum = sum + abs(bi(i,j))
   end do
   binorm = max(binorm,sum)
end do
rerr = max(rerrmn,eps0*bnorm*binorm)
if (rerr > 1.e-2) go to 580
bflag = 0
!
!                 Recalculation of xb
!
180 do i = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do l = 1,m
      dt = bi(i,l)*b0(l)
      if (dt > 0.d0) go to 181
      dsumn = dsumn + dt
      go to 182
181   dsump = dsump + dt
182   continue
   end do
   xb(i) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*max(s,-t)
   if (abs(xb(i)) < tol) xb(i) = 0.0
end do
go to 601
!
!     Find the next vector A(--,JP) to be inserted into
!                       the basis
!
200 jp = 0
rmin = 0.0
if (nstep == 3) rmin = -rtol
do j = 1,n0
   if (basis(j) /= 0) go to 201
   if (r(j) >= rmin) go to 201
   jp = j
   rmin = r(j)
201 continue
end do
if (n0 == n) go to 203
jmin = n0 + 1
rmin = rmin*1.1
do j = jmin,n
   if (basis(j) /= 0) go to 202
   if (r(j) >= rmin) go to 202
   jp = j
   rmin = r(j)
202 continue
end do
203 if (jp /= 0) go to 300
nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 800
if ( nswc_ai_i4 == 0 ) go to 230
go to 250
!
!     Insert the values of the orginal, slack, and surplus
!             variables into r. then terminate.
!
220 do j = 1,n
221 r(j) = 0.0
end do
do i = 1,m
   ki = ibasis(i)
   if (ki <= n) r(ki) = xb(i)
end do
return
!
!             Completion of the NSTEP = 2 Case
!
230 do i = 1,m
   if (ibasis(i) <= n) go to 231
   if (xb(i) > 0.0) go to 800
231 continue
end do
go to 680
!
240 if (icount >= 5) go to 100
ind = 1
go to 220
!
!             Completion of the NSTEP = 3 Case
!
250 if (rerr > 1.e-2) go to 251
ind = 0
go to 800
251 if (icount >= 5) go to 100
ind = 6
go to 800
!
!     If mxiter iterations have not been performed then
!     begin the next iteration. Compute the JP-TH column
!               of bi*A and store it in y.
!
300 if (iter < mxiter) go to 301
ind = 2
go to 220
301 iter = iter + 1
icount = icount + 1
if (jp > ns) go to 330
if (jp > n0) go to 320
!
lmin = ita(jp)
lmax = ita(jp + 1) - 1
if (lmin <= lmax) go to 305
ind = 4
go to 220
305 amax = 0.0
do ll = lmin,lmax
   amax = max(abs(ta(ll)),amax)
end do
!
310 rerr1 = rerrmx*amax
do i = 1,m
   dsum = 0.d0
   do ll = lmin,lmax
      l = jta(ll)
      dsum = dsum + dble(bi(i,l)*ta(ll))
   end do
   y(i) = dsum
   if (abs(y(i)) >= 5.e-3) go to 313
   bmax = 0.0
   do l = 1,m
      bmax = max(abs(bi(i,l)),bmax)
   end do
   tol = rerr1*bmax
   if (abs(y(i)) < tol) y(i) = 0.0
313 continue
end do
go to 350
!
320 l = jp - n0
do i = 1,m
   y(i) = bi(i,l)
end do
go to 350
!
330 l = jp - n0
do i = 1,m
   y(i) = -bi(i,l)
end do
!
350 do i = 1,m
   if (y(i) /= 0.0) go to 360
end do
r(jp) = 0.0
iter = iter - 1
icount = icount - 1
go to 200
!
360 nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 400
if ( nswc_ai_i4 == 0 ) go to 430
go to 440
!
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 1 Case
!
400 npos = 0
ip = 0
eps = 0.0
epsi = xmax
do i = 1,m
   if (xb(i) < 0.0 .or. y(i) <= 0.0) go to 403
   ratio = xb(i)/y(i)
   nswc_ai_r4 = ratio - epsi
   if ( nswc_ai_r4 < 0 ) go to 401
   if ( nswc_ai_r4 == 0 ) go to 402
   go to 403
401 epsi = ratio
   npos = 1
   index(1) = i
   go to 403
402 npos = npos + 1
   index(npos) = i
403 continue
end do
if (npos == 0) go to 420
if (epsi == 0.0) go to 460
!
do i = 1,m
   if (xb(i) >= 0.0 .or. y(i) >= 0.0) go to 410
   ratio = xb(i)/y(i)
   if (ratio > epsi) go to 410
   if (ratio < eps) go to 410
   eps = ratio
   ip = i
410 continue
end do
if (ip /= 0) go to 500
go to 460
!
420 do i = 1,m
   if (xb(i) >= 0.0 .or. y(i) >= 0.0) go to 421
   ratio = xb(i)/y(i)
   if (ratio < eps) go to 421
   eps = ratio
   ip = i
421 continue
end do
go to 500
!
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 2 Case
!
430 npos = 0
epsi = xmax
do i = 1,m
   if (y(i) <= 0.0) go to 433
   ratio = xb(i)/y(i)
   nswc_ai_r4 = ratio - epsi
   if ( nswc_ai_r4 < 0 ) go to 431
   if ( nswc_ai_r4 == 0 ) go to 432
   go to 433
431 epsi = ratio
   npos = 1
   index(1) = i
   go to 433
432 npos = npos + 1
   index(npos) = i
433 continue
end do
go to 450
!
!     Finding the variable xb(ip) to be made nonbasic
!               for the NSTEP = 3 Case
!
440 npos = 0
epsi = xmax
do i = 1,m
   nswc_ai_r4 = y ( i )
   if ( nswc_ai_r4 < 0 ) go to 441
   if ( nswc_ai_r4 == 0 ) go to 445
   go to 442
441 if (ibasis(i) <= n) go to 445
   ip = i
   go to 500
442 ratio = xb(i)/y(i)
   nswc_ai_r4 = ratio - epsi
   if ( nswc_ai_r4 < 0 ) go to 443
   if ( nswc_ai_r4 == 0 ) go to 444
   go to 445
443 epsi = ratio
   npos = 1
   index(1) = i
   go to 445
444 npos = npos + 1
   index(npos) = i
445 continue
end do
!
450 if (npos /= 0) go to 460
if (icount >= 5) go to 100
ind = 4
go to 220
!
!              Tie breaking procedure
!
460 ip = index(1)
if (npos == 1) go to 500
ip = 0
bmin = xmax
cmin = xmax
do ii = 1,npos
   i = index(ii)
   l = ibasis(i)
   if (l > n0) go to 461
   if (c(l) <= 0.0) cmin = min(0.0,cmin)
   if (c(l) > cmin) go to 464
   imin = i
   cmin = c(l)
   go to 464
461 if (l <= n) go to 462
   ip = i
   go to 500
462 lrow = l - n0
   s = b0(lrow)
   if (lrow > numle) go to 463
   if (s > bmin) go to 464
   ip = i
   bmin = s
   go to 464
463 s = -s
   bmin = min(0.0,bmin)
   if (s > bmin) go to 464
   ip = i
   bmin = s
464 continue
end do
if (cmin <= 0.0 .or. ip == 0) ip = imin
!
!               Transformation of xb
!
500 if (xb(ip) == 0.0) go to 510
const = xb(ip)/y(ip)
do i = 1,m
   s = xb(i)
   xb(i) = xb(i) - const*y(i)
   if (xb(i) >= 0.0) go to 501
   if (s >= 0.0 .or. xb(i) >= rerrmx*s) xb(i) = 0.0
501 continue
end do
xb(ip) = const
!
!               Transformation of bi
!
510 do j = 1,m
   if (bi(ip,j) == 0.0) go to 512
   const = bi(ip,j)/y(ip)
   do i = 1,m
511   bi(i,j) = bi(i,j) - const*y(i)
   end do
   bi(ip,j) = const
512 continue
end do
!
!             Updating ibasis and basis
!
iout = ibasis(ip)
ibasis(ip) = jp
basis(iout) = 0
basis(jp) = 1
if (iout > n) num = num - 1
!
!        Check the accuracy of bi and reset rerr
!
if (rerr > 1.e-2) go to 530
k = 0
do j = 1,m
   kj = ibasis(j)
   if (kj > n0) go to 521
   sum = 0.0
   lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   do ll = lmin,lmax
      l = jta(ll)
      sum = sum + bi(j,l)*ta(ll)
   end do
   rerr = max(rerr,abs(1.0 - sum))
   k = k + 1
   if (k >= mcheck) go to 522
521 continue
end do
522 if (rerr <= 1.e-2) go to 600
!
!        The accuracy criteria are not satisfied
!
530 if (icount < 5) go to 600
bflag = 1
go to 100
!
580 if (iter == 0) go to 12
if (bflag == 0) go to 590
bflag = 0
do ip = 1,m
   if (jp == ibasis(ip)) go to 582
end do
582 ibasis(ip) = iout
basis(jp) = 0
basis(iout) = 1
if (iout > n) num = num + 1
go to 100
!
590 ind = 3
go to 220
!
!       Set up the r array for the NSTEP = 1 Case
!
600 nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 601
if ( nswc_ai_i4 == 0 ) go to 630
go to 700
601 do j = 1,m
   if (xb(j) < 0.0) go to 610
end do
go to 630
!
610 nstep = 1
m0 = 0
do l = 1,m
   if (xb(l) >= 0.0) go to 611
   m0 = m0 + 1
   index(m0) = l
611 continue
end do
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do ll = 1,m0
      l = index(ll)
      nswc_ai_r4 = bi( l , j )
      if ( nswc_ai_r4 < 0 ) go to 620
      if ( nswc_ai_r4 == 0 ) go to 622
      go to 621
620   dsumn = dsumn + dble(bi(l,j))
      go to 622
621   dsump = dsump + dble(bi(l,j))
622   continue
   end do
   y(j) = dsump + dsumn
   s = dsump
   t = dsumn
   tol = rerrmx*max(s,-t)
   if (abs(y(j)) < tol) y(j) = 0.0
end do
go to 650
!
!       Set up the r array for the NSTEP = 2 Case
!
630 if (n == num) go to 680
nstep = 2
m0 = 0
do l = 1,m
   if (ibasis(l) <= n) go to 631
   m0 = m0 + 1
   index(m0) = l
631 continue
end do
!
do j = 1,m
   dsump = 0.d0
   dsumn = 0.d0
   do ll = 1,m0
      l = index(ll)
      nswc_ai_r4 = bi( l , j )
      if ( nswc_ai_r4 < 0 ) go to 640
      if ( nswc_ai_r4 == 0 ) go to 642
      go to 641
640   dsumn = dsumn + dble(bi(l,j))
      go to 642
641   dsump = dsump + dble(bi(l,j))
642   continue
   end do
   y(j) = -(dsump + dsumn)
   s = dsump
   t = dsumn
   tol = rerrmx*max(s,-t)
   if (abs(y(j)) < tol) y(j) = 0.0
end do
!
650 do j = 1,n0
   sum = 0.0
   if (basis(j) /= 0) go to 652
   lmin = ita(j)
   lmax = ita(j + 1) - 1
   if (lmin > lmax) go to 652
   do ll = lmin,lmax
      l = jta(ll)
      sum = sum + y(l)*ta(ll)
   end do
652 r(j) = sum
end do
!
660 if (n0 == ns) go to 670
jmin = n0 + 1
do j = jmin,ns
   r(j) = 0.0
   if (basis(j) /= 0) go to 661
   jj = j - n0
   r(j) = y(jj)
661 continue
end do
!
670 if (ns == n) go to 200
jmin = ns + 1
do j = jmin,n
   r(j) = 0.0
   if (basis(j) /= 0) go to 671
   jj = j - n0
   r(j) = -y(jj)
671 continue
end do
go to 200
!
!      Set up a new r array for the NSTEP = 3 Case
!
680 nstep = 3
do j = 1,m
   dsum = 0.d0
   do l = 1,m
      il = ibasis(l)
      if (il <= n0) dsum = dsum + dble(c(il)*bi(l,j))
   end do
682 y(j) = dsum
end do
!
do j = 1,n0
   r(j) = 0.0
   if (basis(j) /= 0) go to 691
   dsum = -c(j)
   lmin = ita(j)
   lmax = ita(j + 1) - 1
   r(j) = -c(j)
   if (lmin > lmax) go to 691
   do ll = lmin,lmax
      l = jta(ll)
      dsum = dsum + dble(y(l)*ta(ll))
   end do
   r(j) = dsum
   if (r(j) >= 0.0) go to 691
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) < tol) r(j) = 0.0
691 continue
end do
go to 660
!
!       Update the r array for the NSTEP = 3 Case
!
700 const = r(jp)
do j = 1,n0
   if (basis(j) == 0) go to 701
   r(j) = 0.0
   go to 703
701 sum = 0.0
   lmin = ita(j)
   lmax = ita(j + 1) - 1
   if (lmin > lmax) go to 703
   do ll = lmin,lmax
      l = jta(ll)
      sum = sum + bi(ip,l)*ta(ll)
   end do
   r(j) = r(j) - const*sum
   if (r(j) >= 0.0) go to 703
   tol = rerrmx*abs(c(j))
   if (abs(r(j)) < tol) r(j) = 0.0
703 continue
end do
!
710 if (n0 == ns) go to 720
jmin = n0 + 1
do j = jmin,ns
   if (basis(j) == 0) go to 711
   r(j) = 0.0
   go to 712
711 jj = j - n0
   r(j) = r(j) - const*bi(ip,jj)
712 continue
end do
!
720 if (ns == n) go to 200
jmin = ns + 1
do j = jmin,n
   if (basis(j) == 0) go to 721
   r(j) = 0.0
   go to 722
721 jj = j - n0
   r(j) = r(j) + const*bi(ip,jj)
722 continue
end do
go to 200
!-----------------------------------------------------------------------
!               Refine xb and store the result in y
!-----------------------------------------------------------------------
800 do i = 1,m
   r(i) = 0.0
   y(i) = 0.0
end do
!
do j = 1,m
   kj = ibasis(j)
   if (kj <= n0) go to 810
   if (kj <= ns) go to 820
   if (kj <= n) go to 830
   go to 820
!
810 lmin = ita(kj)
   lmax = ita(kj + 1) - 1
   do ll = lmin,lmax
      l = jta(ll)
      dt = dble(r(l)) + dble(y(l))
      dt = dt + dble(ta(ll)*xb(j))
      r(l) = dt
      y(l) = dt - dble(r(l))
   end do
   go to 831
!
820 l = kj - n0
   dt = dble(r(l)) + dble(y(l))
   dt = dt + dble(xb(j))
   r(l) = dt
   y(l) = dt - dble(r(l))
   go to 831
!
830 l = kj - n0
   dt = dble(r(l)) + dble(y(l))
   dt = dt - dble(xb(j))
   r(l) = dt
   y(l) = dt - dble(r(l))
831 continue
end do
!
do i = 1,m
   dt = dble(r(i)) + dble(y(i))
   r(i) = dble(b0(i)) - dt
end do
!
850 rerr1 = min(rerrmx,rerr)
do i = 1,m
   y(i) = 0.0
   nswc_ai_r4 = xb ( i )
   if ( nswc_ai_r4 < 0 ) go to 851
   if ( nswc_ai_r4 == 0 ) go to 856
   go to 852
851 sgn = -1.0
   dsump = 0.d0
   dsumn = xb(i)
   go to 853
852 sgn = 1.0
   dsump = xb(i)
   dsumn = 0.d0
853 do l = 1,m
      dt = bi(i,l)*r(l)
      if (dt > 0.d0) go to 854
      dsumn = dsumn + dt
      go to 855
854   dsump = dsump + dt
855   continue
   end do
   w = dsump + dsumn
   if (w == 0.0) go to 856
   if (sgn /= sign(1.0,w)) go to 856
   s = dsump
   t = dsumn
   tol = rerr1*max(s,-t)
   if (abs(w) > tol) y(i) = w
856 continue
end do
nswc_ai_i4 = nstep - 2
if ( nswc_ai_i4 < 0 ) go to 860
if ( nswc_ai_i4 == 0 ) go to 870
go to 880
!
!         Check the refinement (NSTEP = 1)
!
860 do i = 1,m
   if (y(i) >= 0.0) go to 861
   if (y(i) < -rerrmx) go to 240
   y(i) = 0.0
861 xb(i) = y(i)
end do
go to 630
!
!         Check the refinement (NSTEP = 2)
!
870 do i = 1,m
   if (ibasis(i) <= n) go to 871
   if (y(i) > rerrmx) go to 240
   y(i) = 0.0
871 xb(i) = y(i)
end do
go to 680
!
!              COMPUTE z  (NSTEP = 3)
!
880 dsum = 0.d0
do i = 1,m
   ki = ibasis(i)
   if (ki > n0) go to 881
   dsum = dsum + dble(c(ki)*y(i))
881 xb(i) = y(i)
end do
z = dsum
go to 220
end subroutine ssplx1

