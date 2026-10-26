pure subroutine nrvg1(mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
real, intent(inout) :: a(m)
real, intent(in) :: fmu(m)
real, intent(inout) :: x(kx,n)
integer :: i, j
integer, parameter :: max = 2147483647
interface
   pure subroutine rnor(ix,a,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      real, intent(inout) :: a(n)
      integer, intent(inout) :: ierr
   end subroutine rnor
end interface
!-----------------------------------------------------------------------
!
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a. it is
!           assumed that A is a diagonal matrix.
!
!                          ---------------
!
!     Input...
!
!        mo      - Integer specifying if the routine is
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. set mo = 0 On an initial call to
!                  the routine, and mo .NE. 0 on a later
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!
!        ix      - Integer seed used to initialize the
!                  sequence of variates.
!
!        n       - Number of random vectors to be generated.
!
!        m       - Length of the desired random vectors.
!                  It is assumed that m .GE. 2. m should
!                  not be modified by the user on a later
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!
!        a       - Variance-covariance matrix of order m.
!                  A is a diagonal matrix with positive
!                  diagonal elements. The diagonal elements
!                  are stored in the array a. a is an array
!                  of length m or larger.
!
!                  On an initial call to the routine, the
!                  square roots of the elements of a replace
!                  the original data in A. A should not be
!                  modified by the user on a later call to
!                  THE ROUTINE (WHEN mo .NE. 0).
!
!        fmu     - Mean vector of dimension m of the
!                  multivariate normal distribution
!
!        kx      - Row dimension of the matrix x (see the
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!
!     Output...
!
!        ix      - Seed to be used for obtaining more variates.
!
!        x       - Output array of dimension kx by n containing
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a(i) .LE. 0 for some i
!                   4 - Seed out of range      )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (m <= 1 .or. m > kx) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!
!        Compute the roots of the diagonal elements
!
if (mo /= 0) go to 20
do i = 1,m
   if (a(i) <= 0.0) go to 120
   a(i) = sqrt(a(i))
end do
!
!           Generate the n random normal vectors
!
20 do j = 1,n
   call rnor(ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!
!                       Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine nrvg1

pure subroutine dnrvg(mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
double precision, intent(inout) :: a(*)
double precision, intent(in) :: fmu(m)
double precision, intent(inout) :: x(kx,n)
integer :: i, ii, j, k, l, l0, ldim
double precision :: sum
integer, parameter :: max = 2147483647
interface
   pure subroutine dppfa(ap,n,info)
      implicit none
      double precision, intent(inout) :: ap(*)
      integer, intent(in) :: n
      integer, intent(inout) :: info
   end subroutine dppfa
   pure subroutine drnor(ix,a,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      double precision, intent(inout) :: a(n)
      integer, intent(inout) :: ierr
   end subroutine drnor
end interface
!-----------------------------------------------------------------------
!
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a.
!
!                          ---------------
!
!     Input...
!
!        mo      - Integer specifying if the routine is
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. set mo = 0 On an initial call to
!                  the routine, and mo .NE. 0 on a later
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!
!        ix      - Integer seed used to initialize the
!                  sequence of variates.
!
!        n       - Number of random vectors to be generated.
!
!        m       - Length of the desired random vectors.
!                  It is assumed that m .GE. 2. m should
!                  not be modified by the user on a later
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!
!        a       - Variance-covariance matrix of order m.
!                  A is a symmetric positive definite matrix
!                  stored in packed form. The array a must
!                  be of length (m*(m + 1))/2 or larger.
!
!                  On an initial call to the routine, the
!                  lower triangular matrix in the Cholesky
!                  decomposition of a replaces the original
!                  data in the array a. a should never be
!                  modified by the user on a later call to
!                  THE ROUTINE (WHEN mo .NE. 0).
!
!        fmu     - Mean vector of dimension m of the
!                  multivariate normal distribution
!
!        kx      - Row dimension of the matrix x (see the
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!
!     Output...
!
!        ix      - Seed to be used for obtaining more variates.
!
!        x       - Output array of dimension kx by n containing
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a is not positive definite
!                   4 - Seed out of range         )
!
!-----------------------------------------------------------------------
!
!        ***REFERENCES***
!
!     Fishman, george S., Concepts and methods in discrete event
!     digital simulation, john wiley and sons, new york, 1973,
!     PP. 215 - 217.
!
!     Morrison, Donald F., Multivariate statistical methods,
!     mcgraw-hill, new york, 1967, PP. 80 - 81.
!
!     Scheuer, E. and Stoller, D. S., On the generation of
!     normal random vectors, Technometrics, volume 4, may, 1962,
!     PP. 278 - 281.
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (m <= 1 .or. m > kx) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!
!           Compute the lower triangular matrix
!           l having positive diagonal elements
!           and satisfying a = l*transpose(l).
!
if (mo /= 0) go to 10
call dppfa(a, m, ierr)
if (ierr /= 0) go to 120
!
!           Generate the n random normal vectors
!
10 ldim = (m*(m + 1))/2
do j = 1,n
   call drnor(ix, x(1,j), m, ierr)
!
!         Obtain the components of the j-TH vector
!                    in reverse order
!
   l0 = ldim
   i = m
   do ii = 1,m
      l0 = l0 - i
      l = l0
      sum = 0.d0
      do k = 1,i
         l = l + 1
20       sum = sum + a(l)*x(k,j)
      end do
      x(i,j) = sum + fmu(i)
      i = i - 1
   end do
end do
return
!
!                      Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine dnrvg

pure subroutine dnrvg1(mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
double precision, intent(inout) :: a(m)
double precision, intent(in) :: fmu(m)
double precision, intent(inout) :: x(kx,n)
integer :: i, j
integer, parameter :: max = 2147483647
interface
   pure subroutine drnor(ix,a,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      double precision, intent(inout) :: a(n)
      integer, intent(inout) :: ierr
   end subroutine drnor
end interface
!-----------------------------------------------------------------------
!
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a. it is
!           assumed that A is a diagonal matrix.
!
!                          ---------------
!
!     Input...
!
!        mo      - Integer specifying if the routine is
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. set mo = 0 On an initial call to
!                  the routine, and mo .NE. 0 on a later
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!
!        ix      - Integer seed used to initialize the
!                  sequence of variates.
!
!        n       - Number of random vectors to be generated.
!
!        m       - Length of the desired random vectors.
!                  It is assumed that m .GE. 2. m should
!                  not be modified by the user on a later
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!
!        a       - Variance-covariance matrix of order m.
!                  A is a diagonal matrix with positive
!                  diagonal elements. The diagonal elements
!                  are stored in the array a. a is an array
!                  of length m or larger.
!
!                  On an initial call to the routine, the
!                  square roots of the elements of a replace
!                  the original data in A. A should not be
!                  modified by the user on a later call to
!                  THE ROUTINE (WHEN mo .NE. 0).
!
!        fmu     - Mean vector of dimension m of the
!                  multivariate normal distribution
!
!        kx      - Row dimension of the matrix x (see the
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!
!     Output...
!
!        ix      - Seed to be used for obtaining more variates.
!
!        x       - Output array of dimension kx by n containing
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a(i) .LE. 0 for some i
!                   4 - Seed out of range      )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (m <= 1 .or. m > kx) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!
!        Compute the roots of the diagonal elements
!
if (mo /= 0) go to 20
do i = 1,m
   if (a(i) <= 0.d0) go to 120
   a(i) = sqrt(a(i))
end do
!
!           Generate the n random normal vectors
!
20 do j = 1,n
   call drnor(ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!
!                       Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine dnrvg1

pure subroutine ranexp(n,a,iseed,x,ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
real, intent(in) :: a
real, intent(inout) :: x(n)
integer :: i
interface
   pure subroutine urng(ix,x,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      real, intent(inout) :: x(n)
      integer, intent(inout) :: ierr
   end subroutine urng
end interface
!
!              ***Subroutine purpose and description***
!
!           ranexp generates n exponential random variates from an
!           exponential distribution with parameter a (a .GT. 0).
!           A is the mean of the distribution.  Hence, A is interpreted
!           as the average rate per unit of time or the average time
!           to failure (average lifetime).
!
!           Form of the exponential probability density function...
!
!                   f(x) = (1/a) * exp(-x/a)      , x .ge. 0
!                                                   a .GT. 0
!
!           Mean and variance of the exponential distribution...
!
!                    mean = a
!
!                    variance = a**2
!
!           ***Parameter list***
!
!           Input...
!
!           n       - Number of variates to be generated
!           a       - Mean of the exponential distribution
!           iseed   - Integer seed used to initialize the
!                     sequence of variates generated
!
!           Output...
!
!           iseed   - Seed to be used on the next call to the
!                     routine
!           x       - Output array of dimension n containing
!                     the generated real variates
!           ierror  - Input error flag
!                     ( 0 - No input errors
!                       1 - n .LE. 0
!                       2 - a .LE. 0.0
!                       3 - Seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           P. 203.
!
!
!        Check to ensure that the desired number of variates is within
!        acceptable range
!
if (n <= 0) go to 100
!
!        Check to ensure that the exponential parameter HAS been
!        properly specified
!
if (a <= 0.0) go to 110
!
!        Generation of uniform random variates
!
call urng(iseed, x, n, ierror)
if (ierror /= 0) go to 120
!
!        Loop which generates the n desired variates
!
do i = 1,n
   x(i) = - a*log(x(i))
end do
return
!
!              Error return
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
end subroutine ranexp

pure subroutine drnexp(n,a,iseed,x,ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
double precision, intent(in) :: a
double precision, intent(inout) :: x(n)
integer :: i
interface
   pure subroutine durng(ix,x,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      double precision, intent(inout) :: x(n)
      integer, intent(inout) :: ierr
   end subroutine durng
end interface
!
!              ***Subroutine purpose and description***
!
!           drnexp generates n exponential random variates from an
!           exponential distribution with parameter a (a .GT. 0).
!           A is the mean of the distribution.  Hence, A is interpreted
!           as the average rate per unit of time or the average time
!           to failure (average lifetime).
!
!           Form of the exponential probability density function...
!
!                   f(x) = (1/a) * exp(-x/a)      , x .ge. 0
!                                                   a .GT. 0
!
!           Mean and variance of the exponential distribution...
!
!                    mean = a
!
!                    variance = a**2
!
!           ***Parameter list***
!
!           Input...
!
!           n       - Number of variates to be generated
!           a       - Mean of the exponential distribution
!           iseed   - Integer seed used to initialize the
!                     sequence of variates generated
!
!           Output...
!
!           iseed   - Seed to be used on the next call to the
!                     routine
!           x       - Output array of dimension n containing
!                     the generated real variates
!           ierror  - Input error flag
!                     ( 0 - No input errors
!                       1 - n .LE. 0
!                       2 - a .LE. 0.0
!                       3 - Seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           P. 203.
!
!
!        Check to ensure that the desired number of variates is within
!        acceptable range
!
if (n <= 0) go to 100
!
!        Check to ensure that the exponential parameter HAS been
!        properly specified
!
if (a <= 0.d0) go to 110
!
!        Generation of uniform random variates
!
call durng(iseed, x, n, ierror)
if (ierror /= 0) go to 120
!
!        Loop which generates the n desired variates
!
do i = 1,n
   x(i) = - a*log(x(i))
end do
return
!
!              Error return
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
end subroutine drnexp

pure subroutine rgam(ix, a, n, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a
real, intent(inout) :: x(n)
integer :: i, ind
real :: u, v, w
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine gaminv(a,x,x0,p,q,ierr)
      implicit none
      real, intent(in) :: a
      real, intent(out) :: x
      real, intent(in) :: x0
      real, intent(in) :: p
      real, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine gaminv
   pure elemental subroutine urng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine urng0
end interface
!-----------------------------------------------------------------------
!
!               Computation of n variates x(1),...,x(n)
!               from the gamma distribution having the
!                    probability density function
!
!                 f(t) = exp(-t)*t**(a-1)/gamma(a)
!
!                        ------------------
!
!     ix is a variable. On input ix is a seed for initializing the
!     sequence of variates. On output ix is a new seed for obtaining
!     more variates. It is assumed that 1 .LE. ix .LT. 2**31 - 1.
!
!     ierr is a variable which reports the status of the results.
!     When the subroutine terminates ierr has one of the following
!     values ...
!
!          ierr = 0   The gamma variates were obtained.
!          ierr = 1   (INPUT ERROR) n .LE. 0
!          ierr = 2   (INPUT ERROR) a .LT. 0.1
!          ierr = 3   (INPUT ERROR) ix IS NOT A PROPER
!                      seed.
!
!-----------------------------------------------------------------------
!
!
if (n <= 0) go to 100
if (a < 0.1) go to 110
if (ix < 1 .or. ix >= max) go to 120
ierr = 0
!
!             The following code assumes that the uniform
!             variates are far enough from 0 and 1 so that
!                   the setting ind = -8 Is avoided
!
do i = 1,n
   call urng0(ix, u, v)
   call gaminv(a, w, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) w = 0.0
   x(i) = w
end do
return
!
!                            Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine rgam

pure subroutine drgam(ix, a, n, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(in) :: a
double precision, intent(inout) :: x(n)
integer :: i, ind
double precision :: u, v, w
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine dginv(a,x,p,q,ierr)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(out) :: x
      double precision, intent(in) :: p
      double precision, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine dginv
   pure elemental subroutine durng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      double precision, intent(inout) :: u
      double precision, intent(inout) :: v
   end subroutine durng0
end interface
!-----------------------------------------------------------------------
!
!             Computation of n double precision variates
!             x(1),...,x(n)  from the gamma distribution
!              having the probability density function
!
!                 f(t) = exp(-t)*t**(a-1)/gamma(a)
!
!                        ------------------
!
!     ix is a variable. On input ix is a seed for initializing the
!     sequence of variates. On output ix is a new seed for obtaining
!     more variates. It is assumed that 1 .LE. ix .LT. 2**31 - 1.
!
!     ierr is a variable which reports the status of the results.
!     When the subroutine terminates ierr has one of the following
!     values ...
!
!          ierr = 0   The gamma variates were obtained.
!          ierr = 1   (INPUT ERROR) n .LE. 0
!          ierr = 2   (INPUT ERROR) a .LT. 0.1
!          ierr = 3   (INPUT ERROR) ix IS NOT A PROPER
!                      seed.
!
!-----------------------------------------------------------------------
!
!
if (n <= 0) go to 100
if (a < 0.1d0) go to 110
if (ix < 1 .or. ix >= max) go to 120
ierr = 0
!
!             The following code assumes that the uniform
!             variates are far enough from 0 and 1 so that
!                   the setting ind = -8 Is avoided
!
do i = 1,n
   call durng0(ix, u, v)
   call dginv(a, w, u, v, ind)
   if (ind == -3 .or. ind == -7) w = 0.d0
   x(i) = w
end do
return
!
!                            Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine drgam

pure subroutine rbeta(n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a, b
real, intent(inout) :: x(n)
integer :: i, ind
real :: u, v, x1, x2
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine gaminv(a,x,x0,p,q,ierr)
      implicit none
      real, intent(in) :: a
      real, intent(out) :: x
      real, intent(in) :: x0
      real, intent(in) :: p
      real, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine gaminv
   pure elemental subroutine urng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine urng0
end interface
!-----------------------------------------------------------------------
!
!                Generation of beta random variates
!
!                           ------------
!
!     rbeta generates n variates from the beta distribution with
!     PARAMETERS A AND b WHERE a .GE. 0.25 AND b .GE. 0.25. THE
!     generation scheme is based on the fact that x1 / (x1 + x2)
!     is a variate from the beta distribution when x1 and x2 are
!     independent variates from the standard gamma distributions
!     with parameters A and b respectively.
!
!     Form of the beta probability density function used...
!
!       f(x) = x**(a - 1) * (1 - x)**(b - 1) / beta(a,b)
!
!              WHERE  0 .LE. x .LE. 1  AND
!              beta(a,b) is the beta function.
!
!     Mean and variance of the beta distribution...
!
!              mean = a / (a + b)
!
!              variance = (a * b) / ((a + b)**2 * (a + b + 1))
!
!     Input...
!
!        n       - Number of variates to be generated
!        a       - Parameter of the beta distribution
!        b       - Parameter of the beta distribution
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!
!     Output...
!
!        ix      - Seed to be used for obtaining more
!                  variates
!        x       - Array of dimension n containing the
!                  beta variates
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.25
!                   3 - Seed out of range        )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.25) go to 110
if (ix <= 0 .or. ix >= max) go to 120
ierr = 0
!
do i = 1,n
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
!
   call urng0(ix, u, v)
   call gaminv(a, x1, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.0
!
   call urng0(ix, u, v)
   call gaminv(b, x2, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) x2 = 0.0
!
!        It is required that A and b not be less
!        than 0.25 so that x1 + x2 is nonzero.
!
   x(i) = x1/(x1 + x2)
!
end do
return
!
!                      Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine rbeta

pure subroutine drbeta(n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(in) :: a, b
double precision, intent(inout) :: x(n)
integer :: i, ind
double precision :: u, v, x1, x2
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine dginv(a,x,p,q,ierr)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(out) :: x
      double precision, intent(in) :: p
      double precision, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine dginv
   pure elemental subroutine durng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      double precision, intent(inout) :: u
      double precision, intent(inout) :: v
   end subroutine durng0
end interface
!-----------------------------------------------------------------------
!
!                         Double precision
!                generation of beta random variates
!
!                           ------------
!
!     drbeta generates n double precision variates from the beta
!     distribution with parameters A and b where a .GE. 0.25 and
!     b .GE. 0.25. The generation scheme is based on the fact
!     that x1 / (x1 + x2) is a variate from the beta distribution
!     when x1 and x2 are independent variates from the standard
!     gamma distributions with parameters A and b respectively.
!
!     Form of the beta probability density function used...
!
!       f(x) = x**(a - 1) * (1 - x)**(b - 1) / beta(a,b)
!
!              WHERE  0 .LE. x .LE. 1  AND
!              beta(a,b) is the beta function.
!
!     Mean and variance of the beta distribution...
!
!              mean = a / (a + b)
!
!              variance = (a * b) / ((a + b)**2 * (a + b + 1))
!
!     Input...
!
!        n       - Number of variates to be generated
!        a       - Parameter of the beta distribution
!        b       - Parameter of the beta distribution
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!
!     Output...
!
!        ix      - Seed to be used for obtaining more
!                  variates
!        x       - Array of dimension n containing the
!                  beta variates
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.25
!                   3 - Seed out of range        )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.25d0) go to 110
if (ix <= 0 .or. ix >= max) go to 120
ierr = 0
!
do i = 1,n
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
!
   call durng0(ix, u, v)
   call dginv(a, x1, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.d0
!
   call durng0(ix, u, v)
   call dginv(b, x2, u, v, ind)
   if (ind == -3 .or. ind == -7) x2 = 0.d0
!
!        It is required that A and b not be less
!        than 0.25 so that x1 + x2 is nonzero.
!
   x(i) = x1/(x1 + x2)
!
end do
return
!
!                      Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine drbeta

pure subroutine fran(n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a, b
real, intent(inout) :: x(n)
integer :: i, ind
real :: ahalf, bhalf, big, bound, c, t, u, v, x1, x2, xmax
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine gaminv(a,x,x0,p,q,ierr)
      implicit none
      real, intent(in) :: a
      real, intent(out) :: x
      real, intent(in) :: x0
      real, intent(in) :: p
      real, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine gaminv
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
   pure elemental subroutine urng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine urng0
end interface
!-----------------------------------------------------------------------
!
!          Generation of variates from the F-distribution
!
!                          --------------
!
!     Fran generates n variates from the F-distribution with
!     parameters A and b (called the numerator and denominator
!     degrees of freedom) where a .GE. 0.5 and b .GE. 0.5. The
!     generation scheme is based on the fact that (b/a)*(x1/x2)
!     is a variate from the F-distribution when x1 and x2 are
!     independent variates from the standard gamma distributions
!     with parameters a/2 and b/2 respectively.
!
!
!     Input...
!
!        n       - Number of variates to be generated
!        a       - Numerator degrees of freedom parameter
!        b       - Denominator degrees of freedom parameter
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!
!     Output...
!
!        ix      - Seed to be used for obtaining more
!                  variates
!        x       - Array of dimension n containing the
!                  F distribution variates
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.5
!                   3 - b is too small for the
!                       floating arithmetic used
!                   4 - Seed out of range       )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
!
!     ****** xmax is a machine dependent constant. Xmax is the
!            largest number in the floating arithmetic used.
!
xmax = spmpar(3)
!
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.5) go to 110
if (ix <= 0 .or. ix >= max) go to 130
ierr = 0
!
ahalf = 0.5*a
bhalf = 0.5*b
c = b/a
big = 0.5*xmax
bound = amax1(c, 1.0)
!
do i = 1,n
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
!
   call urng0(ix, u, v)
   call gaminv(ahalf, x1, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.0
!
   call urng0(ix, u, v)
   call gaminv(bhalf, x2, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
!
!        Protect against overflow in computing the
!        VARIATE c*(x1/x2).
!
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big <= bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!
!                      Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine fran

pure subroutine dfran(n, a, b, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(in) :: a, b
double precision, intent(inout) :: x(n)
integer :: i, ind
double precision :: ahalf, bhalf, big, bound, c, t, u, v, xmax, &
   & x1, x2
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine dginv(a,x,p,q,ierr)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(out) :: x
      double precision, intent(in) :: p
      double precision, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine dginv
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental subroutine durng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      double precision, intent(inout) :: u
      double precision, intent(inout) :: v
   end subroutine durng0
end interface
!-----------------------------------------------------------------------
!
!                  Double precision generation of
!                 variates from the F-distribution
!
!                          --------------
!
!     dfran generates n variates from the F-distribution with
!     parameters A and b (called the numerator and denominator
!     degrees of freedom) where a .GE. 0.5 and b .GE. 0.5. The
!     generation scheme is based on the fact that (b/a)*(X1/X2)
!     is a variate from the F-distribution when X1 and X2 are
!     independent variates from the standard gamma distributions
!     with parameters a/2 and b/2 respectively.
!
!
!     Input...
!
!        n       - Number of variates to be generated
!        a       - Numerator degrees of freedom parameter
!        b       - Denominator degrees of freedom parameter
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!
!     Output...
!
!        ix      - Seed to be used for obtaining more
!                  variates
!        x       - Array of dimension n containing the
!                  F distribution variates
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.5
!                   3 - b is too small for the
!                       floating arithmetic used
!                   4 - Seed out of range       )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
!
!     ****** xmax is a machine dependent constant. Xmax is the
!            largest number in the floating arithmetic used.
!
xmax = dpmpar(3)
!
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.5d0) go to 110
if (ix <= 0 .or. ix >= max) go to 130
ierr = 0
!
ahalf = 0.5d0*a
bhalf = 0.5d0*b
c = b/a
big = 0.5d0*xmax
bound = dmax1(c, 1.d0)
!
do i = 1,n
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
!
   call durng0(ix, u, v)
   call dginv(ahalf, x1, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.d0
!
   call durng0(ix, u, v)
   call dginv(bhalf, x2, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
!
!        Protect against overflow in computing the
!        VARIATE c*(X1/X2).
!
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big <= bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!
!                      Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine dfran

pure subroutine tran(n, a, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(in) :: a
real, intent(inout) :: x(n)
integer :: i, ind
real :: ahalf, d, s, u, v, w, z
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine gaminv(a,x,x0,p,q,ierr)
      implicit none
      real, intent(in) :: a
      real, intent(out) :: x
      real, intent(in) :: x0
      real, intent(in) :: p
      real, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine gaminv
   pure elemental subroutine pni(p,q,d,w,ierr)
      implicit none
      real, intent(in) :: p
      real, intent(in) :: q
      real, intent(in) :: d
      real, intent(inout) :: w
      integer, intent(inout) :: ierr
   end subroutine pni
   pure elemental subroutine urng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      real, intent(inout) :: u
      real, intent(inout) :: v
   end subroutine urng0
   pure elemental subroutine urng1(ix,u,v,d)
      implicit none
      integer, intent(inout) :: ix
      real, intent(inout) :: u
      real, intent(inout) :: v
      real, intent(inout) :: d
   end subroutine urng1
end interface
!-----------------------------------------------------------------------
!
!          Generation of variates from the T-distribution
!
!                          --------------
!
!        Tran generates n random variates from A T-distribution
!        with parameter a (called the degrees of freedom) where
!        a .GE. 0.5. The generation scheme is based on the fact
!        that x/sqrt(Y/a) is a variate from the T-distribution
!        when x is a standard normal variate and Y a chi-square
!        variate with a degrees of freedom.
!
!
!        Input...
!
!           n    - Number of variates to be generated
!           a    - Degrees of freedom parameter
!           ix   - Integer seed used to initialize the
!                  sequence of variates
!
!        Output...
!
!           ix   - Seed to be used for obtaining more
!                  variates
!           x    - Array of dimension n containing the
!                  T-distribution variates
!           ierr - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a .LT. 0.5
!                   3 - a is too small for the
!                       floating arithmetic used
!                   4 - Seed out of range       )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (a < 0.5) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!
ierr = 0
ahalf = 0.5*a
!
do i = 1,n
!
!                    Get a normal variate
!
   call urng1(ix, u, v, d)
   call pni(u, v, d, z, ind)
!
!                    Get a gamma variate
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
!
   call urng0(ix, u, v)
   call gaminv(ahalf, w, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
!
   s = sqrt(w/ahalf)
   x(i) = z/s
end do
return
!
!              Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine tran

pure subroutine dtran(n, a, ix, x, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(in) :: a
double precision, intent(inout) :: x(n)
integer :: i, ind
double precision :: ahalf, d, s, u, v, w, z
integer, parameter :: max = 2147483647
interface
   pure elemental subroutine dginv(a,x,p,q,ierr)
      implicit none
      double precision, intent(in) :: a
      double precision, intent(out) :: x
      double precision, intent(in) :: p
      double precision, intent(in) :: q
      integer, intent(inout) :: ierr
   end subroutine dginv
   pure elemental subroutine dpni(p,q,d,w,ierr)
      implicit none
      double precision, intent(in) :: p
      double precision, intent(in) :: q
      double precision, intent(in) :: d
      double precision, intent(inout) :: w
      integer, intent(inout) :: ierr
   end subroutine dpni
   pure elemental subroutine durng0(ix,u,v)
      implicit none
      integer, intent(inout) :: ix
      double precision, intent(inout) :: u
      double precision, intent(inout) :: v
   end subroutine durng0
   pure elemental subroutine durng1(ix,u,v,d)
      implicit none
      integer, intent(inout) :: ix
      double precision, intent(inout) :: u
      double precision, intent(inout) :: v
      double precision, intent(inout) :: d
   end subroutine durng1
end interface
!-----------------------------------------------------------------------
!
!                  Double precision generation of
!                 variates from the T-distribution
!
!                          --------------
!
!        dtran generates n random variates from A T-distribution
!        with parameter a (called the degrees of freedom) where
!        a .GE. 0.5. The generation scheme is based on the fact
!        that x/sqrt(Y/a) is a variate from the T-distribution
!        when x is a standard normal variate and Y a chi-square
!        variate with a degrees of freedom.
!
!
!        Input...
!
!           n    - Number of variates to be generated
!           a    - Degrees of freedom parameter
!           ix   - Integer seed used to initialize the
!                  sequence of variates
!
!        Output...
!
!           ix   - Seed to be used for obtaining more
!                  variates
!           x    - Array of dimension n containing the
!                  T-distribution variates
!           ierr - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a .LT. 0.5
!                   3 - a is too small for the
!                       floating arithmetic used
!                   4 - Seed out of range       )
!
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (a < 0.5d0) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!
ierr = 0
ahalf = 0.5d0*a
!
do i = 1,n
!
!                    Get a normal variate
!
   call durng1(ix, u, v, d)
   call dpni(u, v, d, z, ind)
!
!                    Get a gamma variate
!
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
!
   call durng0(ix, u, v)
   call dginv(ahalf, w, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
!
   s = sqrt(w/ahalf)
   x(i) = z/s
end do
return
!
!              Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine dtran

pure subroutine rmk1(n, fmu, sig, alpha, iseed, x, ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
real, intent(in) :: alpha, fmu, sig
real, intent(inout) :: x(n)
integer :: i
real :: c, sigi, t
interface
   pure subroutine rnor(ix,a,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      real, intent(inout) :: a(n)
      integer, intent(inout) :: ierr
   end subroutine rnor
end interface
!
!              ***Subroutine purpose and description***
!
!           rmk1 generates an autocorrelated sequence x of
!           length n where x is a first-order markov process
!           with parameter alpha (abs(alpha) .LT. 1). The sequence
!           x(J) (J = 2,...,n) is generated by
!
!                  x(J) - fmu = alpha*(x(J-1) - fmu) + Z(J).
!
!           Z(J) is the random error term, assumed to be normally
!           distributed with mean 0 and standard deviation sig
!           (sig .GE. 0). The generation scheme assumes that x is
!           a normal process with mean fmu and variance
!
!                      sig*sig / (1 - alpha*alpha) .
!
!           x is a stationary process provided that abs(alpha) .LT.
!           1. The autocorrelation structure of the sequence is
!           characterized by the fact that the correlation between
!           terms becomes progressively weaker with increasing lag.
!           We note that a first-order markov process is synonomous
!           with a first-order autoregressive (AR) process.
!
!           ***Parameter list***
!
!           Input...
!
!           n       - Length of the sequence to be generated.
!                     It is assumed that n .GE. 2.
!           fmu     - Mean of the normal process
!           sig     - Standard deviation of the normally
!                     distributed error term
!           alpha   - Value of the markov model parameter
!           iseed   - Integer seed used to initialize the
!                     sequence of normal variates generated
!                     by subroutine rnor
!
!           Output...
!
!           iseed   - Seed to be used on the next call to the
!                     routine
!           x       - Output array of dimension n containing
!                     the generated first-order markov sequence
!           ierror  - Input error flag
!                     ( 0 - No input errors
!                       1 - n .LE. 1
!                       2 - sig .LT. 0
!                       3 - abs(alpha) .GE. 1
!                       4 - Seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           PP. 236 - 237.
!
!
!        Check to ensure that the desired sequence length is within
!        acceptable range
!
if (n <= 1) go to 100
!
!        Check to ensure that the standard deviation of the error term
!        is within acceptable range
!
if (sig <= 0.0) go to 110
!
!        Check to ensure that the first-order markov model
!        parameter is within the range required to guarantee
!        PROCESS STATIONARITY
!
if (abs(alpha) >= 1.0) go to 120
!
!        Generation of standard normal random variates
!
call rnor(iseed,x,n,ierror)
if (ierror /= 0) go to 130
!
!        Computes the standard deviation of the initial term of the
!        autocorrelated sequence
!
c = 0.5 + (0.5 - alpha)
t = 0.5 + (0.5 + alpha)
sigi = sig/sqrt(c*t)
!
!        Computes the initial term of the required autocorrelated
!        sequence
!
x(1) = fmu + sigi*x(1)
!
!        Generates the last n - 1 Terms of the required autocorrelated
!        sequence
!
c = fmu*c
do i = 2,n
   x(i) = alpha*x(i - 1) + c + sig*x(i)
end do
return
!
!        Error return
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
return
130 ierror = 4
end subroutine rmk1

pure subroutine drmk1(n, fmu, sig, alpha, iseed, x, ierror)
implicit none
integer, intent(inout) :: ierror, iseed
integer, intent(in) :: n
double precision, intent(in) :: fmu, sig, alpha
double precision, intent(inout) :: x(n)
integer :: i
double precision :: c, sigi, t
interface
   pure subroutine drnor(ix,a,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      double precision, intent(inout) :: a(n)
      integer, intent(inout) :: ierr
   end subroutine drnor
end interface
!
!              ***Subroutine purpose and description***
!
!           drmk1 generates an autocorrelated sequence x of
!           length n where x is a first-order markov process
!           with parameter alpha (abs(alpha) .LT. 1). The sequence
!           x(J) (J = 2,...,n) is generated by
!
!                  x(J) - fmu = alpha*(x(J-1) - fmu) + Z(J).
!
!           Z(J) is the random error term, assumed to be normally
!           distributed with mean 0 and standard deviation sig
!           (sig .GE. 0). The generation scheme assumes that x is
!           a normal process with mean fmu and variance
!
!                      sig*sig / (1 - alpha*alpha) .
!
!           x is a stationary process provided that abs(alpha) .LT.
!           1. The autocorrelation structure of the sequence is
!           characterized by the fact that the correlation between
!           terms becomes progressively weaker with increasing lag.
!           We note that a first-order markov process is synonomous
!           with a first-order autoregressive (AR) process.
!
!           ***Parameter list***
!
!           Input...
!
!           n       - Length of the sequence to be generated.
!                     It is assumed that n .GE. 2.
!           fmu     - Mean of the normal process
!           sig     - Standard deviation of the normally
!                     distributed error term
!           alpha   - Value of the markov model parameter
!           iseed   - Integer seed used to initialize the
!                     sequence of normal variates generated
!                     by subroutine drnor
!
!           Output...
!
!           iseed   - Seed to be used on the next call to the
!                     routine
!           x       - Output array of dimension n containing
!                     the generated first-order markov sequence
!           ierror  - Input error flag
!                     ( 0 - No input errors
!                       1 - n .LE. 1
!                       2 - sig .LT. 0
!                       3 - abs(alpha) .GE. 1
!                       4 - Seed out of range )
!
!           ***REFERENCE***
!
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           PP. 236 - 237.
!
!
!        Check to ensure that the desired sequence length is within
!        acceptable range
!
if (n <= 1) go to 100
!
!        Check to ensure that the standard deviation of the error term
!        is within acceptable range
!
if (sig <= 0.d0) go to 110
!
!        Check to ensure that the first-order markov model
!        parameter is within the range required to guarantee
!        PROCESS STATIONARITY
!
if (abs(alpha) >= 1.d0) go to 120
!
!        Generation of standard normal random variates
!
call drnor(iseed,x,n,ierror)
if (ierror /= 0) go to 130
!
!        Computes the standard deviation of the initial term of the
!        autocorrelated sequence
!
c = 0.5d0 + (0.5d0 - alpha)
t = 0.5d0 + (0.5d0 + alpha)
sigi = sig/sqrt(c*t)
!
!        Computes the initial term of the required autocorrelated
!        sequence
!
x(1) = fmu + sigi*x(1)
!
!        Generates the last n - 1 Terms of the required autocorrelated
!        sequence
!
c = fmu*c
do i = 2,n
   x(i) = alpha*x(i - 1) + c + sig*x(i)
end do
return
!
!        Error return
!
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
return
130 ierror = 4
end subroutine drmk1
