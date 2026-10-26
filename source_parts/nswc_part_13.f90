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
