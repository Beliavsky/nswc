pure elemental integer function ipmpar(i)
implicit none
integer, intent(in) :: i
integer, parameter :: imach(10) = [2, 31, 2147483647, 2, 24, -125, 128, 53, -1021, 1024]
!-----------------------------------------------------------------------
!     ipmpar provides the integer machine constants for the computer
!     that is used. It is assumed that the argument i is an integer
!     having one of the values 1-10. ipmpar(i) has the value ...
!  integers.
!     Assume integers are represented in the N-digit, base-A form
!               sign ( X(N-1)*A**(N-1) + ... + X(1)*A + X(0) )
!               WHERE 0 .LE. X(i) .LT. A FOR i=0,...,N-1.
!     ipmpar(1) = A, the base.
!     ipmpar(2) = N, the number of base-A digits.
!     ipmpar(3) = A**N - 1, the largest magnitude.
!  Floating-point numbers.
!     It is assumed that the single and double precision floating
!     point arithmetics have the same base, say B, and that the
!     nonzero numbers are represented in the form
!               sign (B**E) * (X(1)/B + ... + X(M)/B**M)
!               WHERE X(i) = 0,1,...,B-1 FOR i=1,...,M,
!               X(1) .GE. 1, AND EMIN .LE. E .LE. EMAX.
!     ipmpar(4) = B, the base.
!  Single-precision
!     ipmpar(5) = M, the number of base-B digits.
!     ipmpar(6) = EMIN, the smallest exponent E.
!     ipmpar(7) = EMAX, the largest exponent E.
!  Double-precision
!     ipmpar(8) = M, the number of base-B digits.
!     ipmpar(9) = EMIN, the smallest exponent E.
!     ipmpar(10) = EMAX, the largest exponent E.
!-----------------------------------------------------------------------
!     To define this function for the computer being used, activate
!     the data statments for the computer by removing the C from
!     column 1. (All the other data statements should have C in
!     column 1.)
!     if data statements are not given for the computer being used,
!     then the Fortran manual for the computer normally gives the
!     constants ipmpar(1), ipmpar(2), and ipmpar(3) for the integer
!     arithmetic. However, help may be needed to obtain the constants
!     ipmpar(4),...,ipmpar(10) for the single and double precision
!     arithmetics. The subroutines mach and radix are provided for
!     this purpose.
!-----------------------------------------------------------------------
!     ipmpar is an adaptation of the function i1mach, written by
!     P.A. Fox, A.D. Hall, and N.L. Schryer (Bell Laboratories).
!     ipmpar was formed by A.H. Morris (NSWC). The constants are
!     from Bell Laboratories, NSWC, and other sources.
!-----------------------------------------------------------------------
!     Machine constants for the Alliant FX/8.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -125 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the Amdahl machines.
!     data imach( 1) /    2 /
!     data imach( 2) /   31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /   16 /
!     data imach( 5) /    6 /
!     data imach( 6) /  -64 /
!     data imach( 7) /   63 /
!     data imach( 8) /   14 /
!     data imach( 9) /  -64 /
!     data imach(10) /   63 /
!     machine constants for the AT&T 3B series, AT&T
!     PC 7300, and AT&T 6300.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -125 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the Burroughs 1700 system.
!     data imach( 1) /    2 /
!     data imach( 2) /   33 /
!     data imach( 3) / 8589934591 /
!     data imach( 4) /    2 /
!     data imach( 5) /   24 /
!     data imach( 6) / -256 /
!     data imach( 7) /  255 /
!     data imach( 8) /   60 /
!     data imach( 9) / -256 /
!     data imach(10) /  255 /
!     machine constants for the Burroughs 5700 system.
!     data imach( 1) /    2 /
!     data imach( 2) /   39 /
!     data imach( 3) / 549755813887 /
!     data imach( 4) /    8 /
!     data imach( 5) /   13 /
!     data imach( 6) /  -50 /
!     data imach( 7) /   76 /
!     data imach( 8) /   26 /
!     data imach( 9) /  -50 /
!     data imach(10) /   76 /
!     machine constants for the Burroughs 6700/7700 systems.
!     data imach( 1) /      2 /
!     data imach( 2) /     39 /
!     data imach( 3) / 549755813887 /
!     data imach( 4) /      8 /
!     data imach( 5) /     13 /
!     data imach( 6) /    -50 /
!     data imach( 7) /     76 /
!     data imach( 8) /     26 /
!     data imach( 9) / -32754 /
!     data imach(10) /  32780 /
!     machine constants for the CDC 6000/7000 series
!     computers, and the CDC Cyber 990 and 995 (nos
!     operating system).
!     data imach( 1) /    2 /
!     data imach( 2) /   48 /
!     data imach( 3) / 281474976710655 /
!     data imach( 4) /    2 /
!     data imach( 5) /   48 /
!     data imach( 6) / -974 /
!     data imach( 7) / 1070 /
!     data imach( 8) /   95 /
!     data imach( 9) / -926 /
!     data imach(10) / 1070 /
!     machine constants for the CDC Cyber 990 and 995
!     (nos/VE operating system).
!     data imach( 1) /     2 /
!     data imach( 2) /    63 /
!     data imach( 3) / 9223372036854775807 /
!     data imach( 4) /     2 /
!     data imach( 5) /    48 /
!     data imach( 6) / -4096 /
!     data imach( 7) /  4095 /
!     data imach( 8) /    96 /
!     data imach( 9) / -4096 /
!     data imach(10) /  4095 /
!     machine constants for the Convex computers
!     (native mode).
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -127 /
!     data imach( 7) /   127 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1023 /
!     data imach(10) /  1023 /
!     machine constants for the Convex computers
!     (IEEE mode).
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -125 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the Cray 2, X-MP, and Y-MP
!     (CFT77 compiler using the 64 bit integer arithmetic).
!     data imach( 1) /     2 /
!     data imach( 2) /    63 /
!     data imach( 3) / 9223372036854775807 /
!     data imach( 4) /     2 /
!     data imach( 5) /    48 /
!     data imach( 6) / -8188 /
!     data imach( 7) /  8189 /
!     data imach( 8) /    96 /
!     data imach( 9) / -8188 /
!     data imach(10) /  8189 /
!     machine constants for the Cray 2, X-MP, and Y-MP
!     (CFT77 compiler using the 46 bit integer arithmetic).
!     data imach( 1) /     2 /
!     data imach( 2) /    46 /
!     data imach( 3) / 70368744177663 /
!     data imach( 4) /     2 /
!     data imach( 5) /    48 /
!     data imach( 6) / -8188 /
!     data imach( 7) /  8189 /
!     data imach( 8) /    96 /
!     data imach( 9) / -8188 /
!     data imach(10) /  8189 /
!     machine constants for the Data General Eclipse S/200.
!     data imach( 1) /    2 /
!     data imach( 2) /   15 /
!     data imach( 3) / 32767 /
!     data imach( 4) /   16 /
!     data imach( 5) /    6 /
!     data imach( 6) /  -64 /
!     data imach( 7) /   63 /
!     data imach( 8) /   14 /
!     data imach( 9) /  -64 /
!     data imach(10) /   63 /
!     machine constants for the Harris 220.
!     data imach( 1) /    2 /
!     data imach( 2) /   23 /
!     data imach( 3) / 8388607 /
!     data imach( 4) /    2 /
!     data imach( 5) /   23 /
!     data imach( 6) / -127 /
!     data imach( 7) /  127 /
!     data imach( 8) /   38 /
!     data imach( 9) / -127 /
!     data imach(10) /  127 /
!     machine constants for the Honeywell 600/6000
!     and dps 8/70 series.
!     data imach( 1) /    2 /
!     data imach( 2) /   35 /
!     data imach( 3) / 34359738367 /
!     data imach( 4) /    2 /
!     data imach( 5) /   27 /
!     data imach( 6) / -127 /
!     data imach( 7) /  127 /
!     data imach( 8) /   63 /
!     data imach( 9) / -127 /
!     data imach(10) /  127 /
!     machine constants for the HP 9000.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -126 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the IBM 360/370 series,
!     the IBM 3033, the ICL 2900, the ITEL as/6, the
!     xerox sigma 5/7/9, and the SEL systems 85/86.
!     data imach( 1) /    2 /
!     data imach( 2) /   31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /   16 /
!     data imach( 5) /    6 /
!     data imach( 6) /  -64 /
!     data imach( 7) /   63 /
!     data imach( 8) /   14 /
!     data imach( 9) /  -64 /
!     data imach(10) /   63 /
!     machine constants for the IBM PC.
!     Machine constants for the Macintosh II - Absoft
!     MACFORTRAN II.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -125 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the PDP-11 Fortran supporting
!     32-bit integer arithmetic.
!     data imach( 1) /    2 /
!     data imach( 2) /   31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /    2 /
!     data imach( 5) /   24 /
!     data imach( 6) / -127 /
!     data imach( 7) /  127 /
!     data imach( 8) /   56 /
!     data imach( 9) / -127 /
!     data imach(10) /  127 /
!     machine constants for the Sequent Balance 8000.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -125 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the Silicon Graphics IRIS-4D
!     series (mips R3000 processor).
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -125 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the Sun 3.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -125 /
!     data imach( 7) /   128 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1021 /
!     data imach(10) /  1024 /
!     machine constants for the Univac 1100 series.
!     data imach( 1) /     2 /
!     data imach( 2) /    35 /
!     data imach( 3) / 34359738367 /
!     data imach( 4) /     2 /
!     data imach( 5) /    27 /
!     data imach( 6) /  -128 /
!     data imach( 7) /   127 /
!     data imach( 8) /    60 /
!     data imach( 9) / -1024 /
!     data imach(10) /  1023 /
!     machine constants for the VAX and MicroVAX
!     computers - F and D floating arithmetics.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -127 /
!     data imach( 7) /   127 /
!     data imach( 8) /    56 /
!     data imach( 9) /  -127 /
!     data imach(10) /   127 /
!     machine constants for the VAX and MicroVAX
!     computers - F and G floating arithmetics.
!     data imach( 1) /     2 /
!     data imach( 2) /    31 /
!     data imach( 3) / 2147483647 /
!     data imach( 4) /     2 /
!     data imach( 5) /    24 /
!     data imach( 6) /  -127 /
!     data imach( 7) /   127 /
!     data imach( 8) /    53 /
!     data imach( 9) / -1023 /
!     data imach(10) /  1023 /
ipmpar = imach(i)
end function ipmpar

!-----------------------------------------------------------------------
subroutine mach(mo, n, ibeta, imax, idmax, imach, rmach, dmach)
implicit none
integer :: ibeta
integer, intent(in) :: idmax, imax, mo, n
real, intent(inout) :: rmach(3)
double precision, intent(inout) :: dmach(3)
integer, intent(inout) :: imach(10)
integer :: m, maxexp, minexp, n0
real :: eps, xint, xmax, xmin
double precision :: deps, dint, dmin, dmax
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!          Computation of the environmental constants for the
!        single and double precision floating point arithmetics
!                           -----------
!     It is assumed that the single and double precision floating
!     point arithmetics have the same base, say ibeta, and that
!     the nonzero numbers are represented in the form
!        sign (ibeta**K) * (X(1)/ibeta + ... + X(m)/ibeta ** m)
!     where each X(I) is an integer such that
!        0 .LE. X(I) .LT. ibeta
!     and  X(1) .GE. 1 . The exponent K is an integer such that
!        minexp .LE. K .LE. maxexp.
!     The values m, minexp, and maxexp are needed for both the
!     single and double precision arithmetics in order to define
!     the function ipmpar. This subroutine attempts to help the
!     user in obtaining this information.
!-----------------------------------------------------------------------
!                         Input and output
!-----------------------------------------------------------------------
!     Input ...
!       mo    - Mode of operation of the routine.
!               mo = 0  Output unit n is not used. The single
!                       and double precision arithmetics are
!                       examined.
!               mo = 1  It is assumed that unit n is used.
!                       Mach searches for the maximum exponent
!                       maxexp for the single precision arith-
!                       metic. The double precision arithmetic
!                       is not examined.
!               mo = 2  It is assumed that unit n is used.
!                       Mach searches for the maximum exponent
!                       maxexp for the double precision arith-
!                       metic. The single precision arithmetic
!                       is not examined.
!       n     - If n is positive then n is the number of an
!               output unit, where any information written on
!               the unit will be available to the user if mach
!               terminates because of overflow. If n .LE. 0
!               then no such output unit is to be used. (If no
!               such output unit is used then set mo = 0.)
!       ibeta - The base of the floating point arithmetics. (It
!               is assumed that the single and double precision
!               arithmetics have the same base.) If this value
!               is not known then
!                           call radix (ibeta)
!               will (hopefully) provide the correct value. As
!               far as is known, the subroutine radix operates
!               properly on all computers. Nevertheless, the
!               value obtained for ibeta should be checked.
!       imax  - If imax is positive then imax is assumed to be
!               an approximation of the maximum exponent maxexp
!               for the single precision numbers. Otherwise, if
!               imax .LE. 0, then the routine defines its own
!               initial approximation for maxexp.
!       idmax - If idmax is positive then idmax is assumed to be
!               an approximation of the maximum exponent maxexp
!               for the double precision numbers. Otherwise, if
!               idmax .LE. 0, then the routine defines its own
!               initial approximation for maxexp.
!     OUTPUT (WHEN mo = 0) ...
!       imach - Integer array of dimension 10 appearing in the
!               definition of the function ipmpar.
!               ipmpar(i) = imach(i)  i = 4,...,10
!       rmach - Real array of dimension 3 giving the following
!               constants for the single precision arithmetic.
!               rmach(1) = B**(1-m), the machine precision
!               rmach(2) = The smallest positive number
!               rmach(3) = The largest positive number
!       dmach - Double precision array of dimension 3 giving the
!               following constants for the double precision
!               arithmetic.
!               dmach(1) = B**(1-m), the machine precision
!               dmach(2) = The smallest positive number
!               dmach(3) = The largest positive number
!-----------------------------------------------------------------------
!                              Usage
!-----------------------------------------------------------------------
!     The following procedure is recommended for obtaining the
!     data needed for defining ipmpar.
!     Step (1). In this step we search for the maximum exponent
!     maxexp for the single precision arithmetic. The double
!     precision arithmetic is not considered. It is assumed that
!     an output unit n is being used. Given n and ibeta. Set
!     imax = 0 And compute ...
!        call mach (1, n, ibeta, imax, idmax, imach, rmach, dmach)
!     when this code is run, information is given on unit n for
!     resetting imax. If the maximum exponent has been found
!     (in this case, the last integer written on unit n will not
!     be followed by any statement except possibly an overflow
!     statement), then set imax to the last integer written on
!     unit n and go to step (2). Otherwise, if the maximum
!     exponent has not been found, then reset imax according to
!     the instructions given on unit n and rerun the code. The
!     code may be rerun with different values of imax until the
!     the maximum exponent has been found or a satisfactory
!     approximation for the maximum exponent has been obtained.
!     Then set imax to the maximum exponent (or the approximation)
!     and go to step (2).
!     Step (2). In this step we search for the maximum exponent
!     maxexp for the double precision arithmetic. The single
!     precision arithmetic is not considered. It is assumed that
!     an output unit n is being used. Given n and ibeta. Set
!     idmax = 0 And compute ...
!        call mach (2, n, ibeta, imax, idmax, imach, rmach, dmach)
!     the procedure used in this step for finding the maximum
!     exponent or obtaining a suitable approximation for the
!     maximum exponent is the same as in step (1), the only
!     difference being that now one works with idmax instead
!     of imax. When the maximum exponent is found or a suitable
!     approximation is obtained, then reset idmax to the maximum
!     exponent (or the approximation) and go to step (3).
!     Step (3). Given the values obtained for ibeta, imax, and
!     idmax. Then compute ...
!        call mach (0, 0, ibeta, imax, idmax, imach, rmach, dmach)
!     when this code terminates, all the data needed for defining
!     ipmpar(4),...,ipmpar(10) is given in the array imach. The
!     data given in the arrays rmach and dmach are provided so that
!     the user can check the information in imach.
!             rmach(1)  depends on imach(4) and imach(5)
!             rmach(2)  depends on imach(4) and imach(6)
!             rmach(3)  depends on imach(4) and imach(7)
!             dmach(1)  depends on imach(4) and imach(8)
!             dmach(2)  depends on imach(4) and imach(9)
!             dmach(3)  depends on imach(4) and imach(10)
!     the values in rmach and dmach should be checked to see if
!     they make sense. (For example, rmach(2) and dmach(2) should
!     never be 0.)
!-----------------------------------------------------------------------
!                       General information
!-----------------------------------------------------------------------
!     The values in imach(6) and imach(9) are the minimum exponents
!     for the numbers in the single and double precision arithmetics
!     which have full accuracy. On some computers, accuracy is lost
!     in the storage of some small numbers. This occurs in the double
!     precision arithmetics of the CDC 6000-7000 series computes. On
!     these machines, the double precision numbers less that 2**(-927)
!     normally have only single precision accuracy. Consequently,
!     imach(9) will have the computed value -926 Instead of -974
!     (which one would normally expect). In this case, -926 Is the
!     value that is considered to be correct.
!     This package of subroutines includes mach, radix, mach1, store2,
!     mach2, dstor2. The package is experimental. It is provided as
!     an aid in defining the function ipmpar. The subroutines in the
!     package are not used by any of the functions or subroutines in
!     the NSWC library.
!     The purpose of the subroutines store2 and dstor2 is to force
!     data to be stored in memory. These routines are needed when
!     data are stored in oversized registers.
!     The algorithm for the subroutine radix was developed by M.A.
!     Malcolm (Stanford University). See references (1) and (2).
!-----------------
!     Written by
!        Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren Virginia
!-----------------
!     Revised ... March 1992
!-----------------
!     References ...
!     (1) Malcolm, M.A., algorithms to reveal properties of floating
!         point arithmetic, comm. ACM (15), 1972, PP. 949-951.
!     (2) gentlemen, W.M. and Marovich, S.B., more on algorithms that
!         reveal properties of floating point arithmetic units,
!         comm. ACM (17), 1974, PP. 276-277.
!     (3) Cody, W.J. and Waite, W., Software manual for the elementary
!         functions, Prentice-Hall, 1980, PP. 258-264.
!     (4) Cody, W.J., algorithm 665. MACHAR, a subroutine to dynamically
!         determine machine parameters, ACM Trans. Math Software (14),
!         1988, PP. 303-311.
!-----------------------------------------------------------------------
!-----------------
imach(1) = 0
imach(2) = 0
imach(3) = 0
n0 = n
if (mo <= 0) n0 = 0
if (mo >= 2) go to 10
!-----------------------------------------------------------------------
!     Obtain the single precision information
!-----------------------------------------------------------------------
maxexp = imax
call mach1(n0, ibeta, m, minexp, maxexp, eps, xint, xmin, xmax)
if (mo == 1) stop
rmach(1) = eps
rmach(2) = xmin
rmach(3) = xmax
imach(4) = ibeta
imach(5) = m
imach(6) = minexp
imach(7) = maxexp
!-----------------------------------------------------------------------
!     Obtain the double precision information
!-----------------------------------------------------------------------
10 maxexp = idmax
call mach2(n0, ibeta, m, minexp, maxexp, deps, dint, dmin, dmax)
if (mo >= 2) stop
dmach(1) = deps
dmach(2) = dmin
dmach(3) = dmax
imach(8) = m
imach(9) = minexp
imach(10) = maxexp
end subroutine mach

subroutine radix(ibeta)
implicit none
integer :: ibeta
real :: a, b, one, y
real :: d1, d2
!-----------------------------------------------------------------------
!     Set  ibeta = The radix of the floating point arithmetic
!-----------------------------------------------------------------------
common /spdata/ d1, d2
one = float(1)
a = one
10 a = a + a
call store2(a + one, a)
y = d1 - d2
if (y == one) go to 10
b = one
20 b = b + b
call store2(a + b, a)
if (d1 == d2) go to 20
ibeta = int(d1 - d2)
end subroutine radix

subroutine mach1(n, ibeta, m, minexp, maxexp, eps, xint, &
   & xmin, xmax)
implicit none
integer :: ibeta, m, maxexp, minexp, n
real :: eps, xint, xmin, xmax
integer :: j, k, km, l
real :: b, b2, binv, bm1, d1, d2, one, p, q, t, x, z, zero
!-----------------------------------------------------------------------
!                 Computation of the environmental constants
!             for the single precision floating point arithmetic
!                            -----------
!     Input ...
!       n       - If n is positive then n is the number of an
!                 output unit. In this case it is assumed that
!                 any information that is written on the unit
!                 will be available to the user if the routine
!                 terminates because of overflow. Unit n is
!                 used only for computing the exact maximum
!                 base ibeta exponent for the floating point
!                 numbers (this exponent is stored in maxexp).
!                 If the exact maximum exponent is not needed
!                 (or has already been obtained) then set n
!                 to 0 or a negative value.
!       ibeta   - The base of the floating point arithmetic.
!       maxexp  - If maxexp is positive then maxexp is assumed to
!                 be an approximation of the maximum (base ibeta)
!                 exponent for the floating point numbers. Other-
!                 wise, if maxexp .LE. 0, then an approximation
!                 for the maximum exponent is obtained.
!     Output ...
!       m       - The number of base ibeta digits in the floating
!                 point representation.
!       minexp  - The largest in magnitude negative integer such
!                 THAT FLOAT(ibeta)**(minexp - 1) IS A POSITIVE
!                 number.
!       maxexp  - If maxexp is positive on input and n .LE. 0
!                 then maxexp is not modified.
!                 If maxexp .LE. 0 on input and n .LE. 0 then
!                 on output maxexp = An approximation of the
!                 maximum (base ibeta) exponent for the floating
!                 point numbers.
!                 If n is positive then the routine searches for
!                 the exact maximum exponent for the floating
!                 point numbers. If maxexp is positive on input
!                 then the search begins with maxexp. If
!                 maxexp .LE. 0 on input then the routine begins
!                 the search with its own initial approximation
!                 for maxexp. The following loop is performed.
!                     (1) Check the current value of maxexp
!                         for overflow. If overflow occurs
!                         then the routine will (hopefully)
!                         abort. Otherwise, if overflow does
!                         not occur then go to (2).
!                     (2) Write on unit n the current value
!                         of maxexp and go to (3).
!                     (3) Increase the value of maxexp by 1
!                         and return to (1).
!                 If the overflow test in (1) fails then the
!                 routine aborts after 500 passes through the
!                 loop. If the overflow test works properly
!                 then the last integer written on unit n is
!                 the desired maximum exponent for the float-
!                 ing point numbers. Reset maxexp to this
!                 integer, set n = 0, and rerun the routine.
!       eps     - The relative precision of the floating arithmetic.
!                 eps = float(ibeta)**(1 - m)
!       xint    - The largest positive integer that can
!                 be exactly represented as a floating
!                 point number. xint = b**m - 1  Where
!                 b = float(ibeta).
!       xmin    - The smallest nonzero power of the base.
!                 xmin = float(ibeta)**(minexp - 1)
!       xmax    - The largest FOATING point number that can
!                 be obtained having the exponent maxexp.
!                 xmax = (1 - b**(-m)) * b**maxexp  WHERE
!                 b = Float(ibeta). If maxexp is the maximum
!                 exponent for the floating point numbers
!                 then xmax is the largest floating point
!                 number that exists. The value obtained
!                 for xmax may be affected slightly by
!                 roundoff error.
!-----------------------------------------------------------------------
!----------------
common /spdata/ d1, d2
zero = float(0)
one = float(1)
b = float(ibeta)
b2 = b*b
bm1 = float(ibeta - 1)
binv = one/b
!-----------------------------------------------------------------------
!     Compute m and eps
!-----------------------------------------------------------------------
m = 1
t = b
10 m = m + 1
z = t
t = b*t
call store2(t + one, t)
x = d1*binv - z
if (x == binv) go to 10
xint = (z - one)*b + bm1
xmax = xint/t
if (xmax < one) go to 20
m = m - 1
t = z
z = z*binv
xint = (z - one)*b + bm1
xmax = xint/t
20 eps = one/z
!-----------------------------------------------------------------------
!     Compute minexp and xmin
!-----------------------------------------------------------------------
p = one + eps
q = one + eps*b2
!     minexp must be found. This loop obtains the largest
!     k = 2**I such that b**(-k) does not underflow.
k = 1
z = binv
30 x = z
z = (x*x)*one
call store2(z*xint, z*t)
if (d1 == d2) go to 40
if (z + z == zero .or. abs(z) >= x) go to 40
call store2(z, p*z)
if (t*d2 == t*z) go to 40
k = k + k
go to 30
40 km = k + k
j = 0
!     Loop to determine minexp and xmin.
50 xmin = x
x = (x*binv)*one
call store2(x*xint, x*t)
if (d1 == d2) go to 90
if (x + x == zero .or. abs(x) >= xmin) go to 90
call store2(x, p*x)
if (t*d2 == t*x) go to 80
k = k + 1
go to 50
!     If there is loss of accuracy not due to underflow
!     then set j = Number of digits possibly lost due to
!     this loss of accuracy.
80 call store2(x, q*x)
if (t*d2 /= t*x) go to 90
81 z = x
j = j + 1
x = (x*binv)*one
call store2(x*xint, x*t)
if (d1 == d2) go to 90
if (x + x /= zero .and. abs(x) < z) go to 81
90 minexp = 1 - k
!-----------------------------------------------------------------------
!     Define an initial approximation for maxexp and xmax
!     when maxexp .LE. 0 on input
!-----------------------------------------------------------------------
if (maxexp > 0) go to 101
if (ibeta == 2 .or. ibeta == 8 .or. &
   & ibeta == 16) go to 100
maxexp = k - 3
if (n > 0) write (n,200) maxexp
t = one/(b2*b2*xmin)
xmax = (xmax*t)*b
go to 110
100 k = k + j
if (k + k > km + 2) km = km + km
maxexp = km - k - 3
101 if (n > 0) write (n,200) maxexp
t = b**(maxexp - 2)
xmax = ((xmax*t)*b)*b
!-----------------------------------------------------------------------
!     Check the approximation for maxexp
!-----------------------------------------------------------------------
110 call store2(t, t*p)
if (d1 == d2) go to 150
if (n <= 0) return
!-----------------------------------------------------------------------
!     Loop to find the exact largest value for maxexp
!-----------------------------------------------------------------------
write (n,210) maxexp
do l = 1,500
   t = t*b
   xmax = xmax*b
   maxexp = maxexp + 1
   call store2(t, t*p)
   if (d1 == d2) go to 150
   write (n,220) maxexp
end do
write (n,240)
stop
!-----------------------------------------------------------------------
!     Reporting overflow on unit n
!-----------------------------------------------------------------------
150 if (n > 0) write (n,230)
stop
!-----------------------------------------------------------------------
!     Format statements
!-----------------------------------------------------------------------
200 format (' THE INITIAL APPROXIMATION FOR IMAX (OR MAXEXP) IS'// &
&i25// &
&' IF NO FURTHER INFORMATION APPEARS ON THIS FILE'/ &
&' THEN SET IMAX (OR MAXEXP) TO A SMALLER VALUE THAN'/ &
&' THIS APPROXIMATION AND RERUN THE CODE.'//)
210 format (' THE LOOP TO FIND THE LARGEST POSSIBLE EXPONENT HAS'/ &
&' BEGUN. SET IMAX (OR MAXEXP) TO THE LAST INTEGER'/ &
&' THAT FOLLOWS.'//i25)
220 format (i25)
230 format (/'   ****** OVERFLOW OCCURS ******')
240 format (/' ****** 500 PASSES WERE MADE THROUGH THE LOOP.'/ &
&'        THE MAXIMUM EXPONENT CANNOT BE FOUND.'/ &
&'        IF ONE WISHES, SET IMAX (OR MAXEXP)'/ &
&'        TO A LARGER VALUE AND RERUN THE CODE.'/)
!-----------------------------------------------------------------------
end subroutine mach1

subroutine store2(a, b)
implicit none
real :: a, b
real :: d1, d2
!-----------------------------------------------------------------------
!     Storage of single precision information into memory
!-----------------------------------------------------------------------
common /spdata/ d1, d2
d1 = a
d2 = b
end subroutine store2

subroutine mach2(n, ibeta, m, minexp, maxexp, eps, xint, &
   & xmin, xmax)
implicit none
integer :: ibeta, m, maxexp, minexp, n
double precision :: eps, xint, xmin, xmax
integer :: j, k, km, l
double precision :: b, b2, binv, bm1, d1, d2, one, p, q, t, x, z, &
   & zero
!-----------------------------------------------------------------------
!                 Computation of the environmental constants
!             for the double precision floating point arithmetic
!                            -----------
!     Input ...
!       n       - If n is positive then n is the number of an
!                 output unit. In this case it is assumed that
!                 any information that is written on the unit
!                 will be available to the user if the routine
!                 terminates because of overflow. Unit n is
!                 used only for computing the exact maximum
!                 base ibeta exponent for the floating point
!                 numbers (this exponent is stored in maxexp).
!                 If the exact maximum exponent is not needed
!                 (or has already been obtained) then set n
!                 to 0 or a negative value.
!       ibeta   - The base of the floating point arithmetic.
!       maxexp  - If maxexp is positive then maxexp is assumed to
!                 be an approximation of the maximum (base ibeta)
!                 exponent for the floating point numbers. Other-
!                 wise, if maxexp .LE. 0, then an approximation
!                 for the maximum exponent is obtained.
!     Output ...
!       m       - The number of base ibeta digits in the floating
!                 point representation.
!       minexp  - Let b = dble(float(ibeta)). Then minexp is the
!                 largest in magnitude negative integer such that
!                 b**(minexp - 1) is a positive number.
!       maxexp  - If maxexp is positive on input and n .LE. 0
!                 then maxexp is not modified.
!                 If maxexp .LE. 0 on input and n .LE. 0 then
!                 on output maxexp = An approximation of the
!                 maximum (base ibeta) exponent for the floating
!                 point numbers.
!                 If n is positive then the routine searches for
!                 the exact maximum exponent for the floating
!                 point numbers. If maxexp is positive on input
!                 then the search begins with maxexp. If
!                 maxexp .LE. 0 on input then the routine begins
!                 the search with its own initial approximation
!                 for maxexp. The following loop is performed.
!                     (1) Check the current value of maxexp
!                         for overflow. If overflow occurs
!                         then the routine will (hopefully)
!                         abort. Otherwise, if overflow does
!                         not occur then go to (2).
!                     (2) Write on unit n the current value
!                         of maxexp and go to (3).
!                     (3) Increase the value of maxexp by 1
!                         and return to (1).
!                 If the overflow test in (1) fails then the
!                 routine aborts after 500 passes through the
!                 loop. If the overflow test works properly
!                 then the last integer written on unit n is
!                 the desired maximum exponent for the float-
!                 ing point numbers. Reset maxexp to this
!                 integer, set n = 0, and rerun the routine.
!       eps     - The relative precision of the floating arithmetic.
!                 eps = b**(1 - m) WHERE b = dble(FLOAT(ibeta)).
!       xint    - The largest positive integer that can
!                 be exactly represented as a floating
!                 point number. xint = b**m - 1  Where
!                 b = dble(float(ibeta)).
!       xmin    - The smallest nonzero power of the base.
!                 xmin = b**(minexp-1) WHERE b=dble(FLOAT(ibeta)).
!       xmax    - The largest FOATING point number that can
!                 be obtained having the exponent maxexp.
!                 xmax = (1 - b**(-m)) * b**maxexp  WHERE
!                 b = dble(float(ibeta)). If maxexp is the
!                 maximum exponent for the floating point
!                 numbers then xmax is the largest floating
!                 point number that exists. The value
!                 obtained for xmax may be affected slightly
!                 by roundoff error.
!-----------------------------------------------------------------------
!----------------
common /dpdata/ d1, d2
zero = dble(float(0))
one = dble(float(1))
b = dble(float(ibeta))
b2 = b*b
bm1 = dble(float(ibeta - 1))
binv = one/b
!-----------------------------------------------------------------------
!     Compute m and eps
!-----------------------------------------------------------------------
m = 1
t = b
10 m = m + 1
z = t
t = b*t
call dstor2(t + one, t)
x = d1*binv - z
if (x == binv) go to 10
xint = (z - one)*b + bm1
xmax = xint/t
if (xmax < one) go to 20
m = m - 1
t = z
z = z*binv
xint = (z - one)*b + bm1
xmax = xint/t
20 eps = one/z
!-----------------------------------------------------------------------
!     Compute minexp and xmin
!-----------------------------------------------------------------------
p = one + eps
q = one + eps*b2
!     minexp must be found. This loop obtains the largest
!     k = 2**I such that b**(-k) does not underflow.
k = 1
z = binv
30 x = z
z = (x*x)*one
call dstor2(z*xint, z*t)
if (d1 == d2) go to 40
if (z + z == zero .or. abs(z) >= x) go to 40
call dstor2(z, p*z)
if (t*d2 == t*z) go to 40
k = k + k
go to 30
40 km = k + k
j = 0
!     Loop to determine minexp and xmin
50 xmin = x
x = (x*binv)*one
call dstor2(x*xint, x*t)
if (d1 == d2) go to 90
if (x + x == zero .or. abs(x) >= xmin) go to 90
call dstor2(x, p*x)
if (t*d2 == t*x) go to 80
k = k + 1
go to 50
!     If there is loss of accuracy not due to underflow
!     then set j = Number of digits possibly lost due to
!     this loss of accuracy.
80 call dstor2(x, q*x)
if (t*d2 /= t*x) go to 90
81 z = x
j = j + 1
x = (x*binv)*one
call dstor2(x*xint, x*t)
if (d1 == d2) go to 90
if (x + x /= zero .and. abs(x) < z) go to 81
90 minexp = 1 - k
!-----------------------------------------------------------------------
!     Define an initial approximation for maxexp and xmin
!     when maxexp .LE. 0 on input
!-----------------------------------------------------------------------
if (maxexp > 0) go to 101
if (ibeta == 2 .or. ibeta == 8 .or. &
   & ibeta == 16) go to 100
maxexp = k - 3
if (n > 0) write (n,200) maxexp
t = one/(b2*b2*xmin)
xmax = (xmax*t)*b
go to 110
100 k = k + j
if (k + k > km + 2) km = km + km
maxexp = km - k - 3
101 if (n > 0) write (n,200) maxexp
t = b**(maxexp - 2)
xmax = ((xmax*t)*b)*b
!-----------------------------------------------------------------------
!     Check the approximation for maxexp
!-----------------------------------------------------------------------
110 call dstor2(t, t*p)
if (d1 == d2) go to 150
if (n <= 0) return
!-----------------------------------------------------------------------
!     Loop to find the exact largest value for maxexp
!-----------------------------------------------------------------------
write (n,210) maxexp
do l = 1,500
   t = t*b
   xmax = xmax*b
   maxexp = maxexp + 1
   call dstor2(t, t*p)
   if (d1 == d2) go to 150
   write (n,220) maxexp
end do
write (n,240)
stop
!-----------------------------------------------------------------------
!     Reporting overflow on unit n
!-----------------------------------------------------------------------
150 if (n > 0) write (n,230)
stop
!-----------------------------------------------------------------------
!     Format statements
!-----------------------------------------------------------------------
200 format (' THE INITIAL APPROXIMATION FOR IDMAX (OR MAXEXP) IS'// &
&i25// &
&' IF NO FURTHER INFORMATION APPEARS ON THIS FILE'/ &
&' THEN SET IDMAX (OR MAXEXP) TO A SMALLER VALUE THAN'/ &
&' THIS APPROXIMATION AND RERUN THE CODE.'//)
210 format (' THE LOOP TO FIND THE LARGEST POSSIBLE EXPONENT HAS'/ &
&' BEGUN. SET IDMAX (OR MAXEXP) TO THE LAST INTEGER'/ &
&' THAT FOLLOWS.'//i25)
220 format (i25)
230 format ('0  ****** OVERFLOW OCCURS ******')
240 format (/' ****** 500 PASSES WERE MADE THROUGH THE LOOP.'/ &
&'        THE MAXIMUM EXPONENT CANNOT BE FOUND.'/ &
&'        IF ONE WISHES, SET IDMAX (OR MAXEXP)'/ &
&'        TO A LARGER VALUE AND RERUN THE CODE.'/)
!-----------------------------------------------------------------------
end subroutine mach2

subroutine dstor2(a, b)
implicit none
!-----------------------------------------------------------------------
!     Storage of double precision information into memory
!-----------------------------------------------------------------------
double precision :: a, b
double precision :: d1, d2
common /dpdata/ d1, d2
d1 = a
d2 = b
end subroutine dstor2

pure elemental real function spmpar(i)
implicit none
integer, intent(in) :: i
integer :: ibeta, m, emin, emax
real :: b, binv, bm1, one, w, z
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!     spmpar provides the single precision machine constants for
!     the computer being used. It is assumed that the argument
!     i is an integer having one of the values 1, 2, or 3. If the
!     single precision arithmetic being used has m base b digits and
!     its smallest and largest exponents are emin and emax, then
!        spmpar(1) = b**(1 - m), the machine precision,
!        spmpar(2) = b**(emin - 1), the smallest magnitude,
!        spmpar(3) = b**emax*(1 - b**(-m)), the largest magnitude.
!-----------------------------------------------------------------------
!     Written by
!        Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren Virginia
!-----------------------------------------------------------------------
if (i > 1) go to 10
b = ipmpar(4)
m = ipmpar(5)
spmpar = b**(1 - m)
return
10 if (i > 2) go to 20
b = ipmpar(4)
emin = ipmpar(6)
one = float(1)
binv = one/b
w = b**(emin + 2)
spmpar = ((w * binv) * binv) * binv
return
20 ibeta = ipmpar(4)
m = ipmpar(5)
emax = ipmpar(7)
b = ibeta
bm1 = ibeta - 1
one = float(1)
z = b**(m - 1)
w = ((z - one)*b + bm1)/(b*z)
z = b**(emax - 2)
spmpar = ((w * z) * b) * b
end function spmpar

pure elemental double precision function dpmpar(i)
implicit none
integer, intent(in) :: i
integer :: ibeta, m, emin, emax
double precision :: b, binv, bm1, one, w, z
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!     dpmpar provides the double precision machine constants for
!     the computer being used. It is assumed that the argument
!     i is an integer having one of the values 1, 2, or 3. If the
!     double precision arithmetic being used has m base b digits and
!     its smallest and largest exponents are emin and emax, then
!        dpmpar(1) = b**(1 - m), the machine precision,
!        dpmpar(2) = b**(emin - 1), the smallest magnitude,
!        dpmpar(3) = b**emax*(1 - b**(-m)), the largest magnitude.
!-----------------------------------------------------------------------
!     Written by
!        Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren Virginia
!-----------------------------------------------------------------------
if (i > 1) go to 10
b = ipmpar(4)
m = ipmpar(8)
dpmpar = b**(1 - m)
return
10 if (i > 2) go to 20
b = ipmpar(4)
emin = ipmpar(9)
one = float(1)
binv = one/b
w = b**(emin + 2)
dpmpar = ((w * binv) * binv) * binv
return
20 ibeta = ipmpar(4)
m = ipmpar(8)
emax = ipmpar(10)
b = ibeta
bm1 = ibeta - 1
one = float(1)
z = b**(m - 1)
w = ((z - one)*b + bm1)/(b*z)
z = b**(emax - 2)
dpmpar = ((w * z) * b) * b
end function dpmpar

pure real function epsln(l)
implicit none
integer, intent(in) :: l
integer :: m, b
real :: lnb
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!--------------------------------------------------------------------
!     The evaluation of LN(EPS) where eps is the smallest number
!     such that 1.0 + eps .GT. 1.0 .  l is a dummy argument.
!--------------------------------------------------------------------
b = ipmpar(4)
if (b /= 2) go to 10
lnb = .69314718055995
go to 50
10 if (b /= 8) go to 20
lnb = 2.0794415416798
go to 50
20 if (b /= 16) go to 30
lnb = 2.7725887222398
go to 50
30 lnb = log(float(b))
50 m = 1 - ipmpar(5)
epsln = m * lnb
end function epsln

pure elemental double precision function depsln(l)
implicit none
integer, intent(in) :: l
integer :: b
double precision :: db, lnb, m
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!--------------------------------------------------------------------
!     The evaluation of LN(EPS) where eps is the smallest number
!     such that 1.D0 + eps .GT. 1.D0 .  l is a dummy argument.
!--------------------------------------------------------------------
b = ipmpar(4)
if (b /= 2) go to 10
lnb = .693147180559945309417232121458d+00
go to 50
10 if (b /= 8) go to 20
lnb = 2.07944154167983592825169636437d+00
go to 50
20 if (b /= 16) go to 30
lnb = 2.77258872223978123766892848583d+00
go to 50
30 db = b
lnb = log(db)
50 m = 1 - ipmpar(8)
depsln = m * lnb
end function depsln

pure elemental real function exparg(l)
implicit none
integer, intent(in) :: l
integer :: m, b
real :: lnb
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!--------------------------------------------------------------------
!     If l = 0 Then  exparg(l) = The largest positive W for which
!     exp(W) can be computed.
!     If l is nonzero then  exparg(l) = The largest negative W for
!     which the computed value of exp(W) is nonzero.
!     Note... only an approximate value for exparg(l) is needed.
!--------------------------------------------------------------------
b = ipmpar(4)
if (b /= 2) go to 10
lnb = .69314718055995
go to 50
10 if (b /= 8) go to 20
lnb = 2.0794415416798
go to 50
20 if (b /= 16) go to 30
lnb = 2.7725887222398
go to 50
30 lnb = log(float(b))
50 if (l == 0) go to 60
m = ipmpar(6) - 1
exparg = 0.99999 * (m * lnb)
return
60 m = ipmpar(7)
exparg = 0.99999 * (m * lnb)
end function exparg

pure elemental double precision function dxparg(l)
implicit none
integer, intent(in) :: l
integer :: m, b
double precision :: db, lnb
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!--------------------------------------------------------------------
!     If l = 0 Then  dxparg(l) = The largest positive W for which
!     dexp(W) can be computed.
!     If l is nonzero then  dxparg(l) = The largest negative W for
!     which the computed value of dexp(W) is nonzero.
!     Note... only an approximate value for dxparg(l) is needed.
!--------------------------------------------------------------------
b = ipmpar(4)
if (b /= 2) go to 10
lnb = .693147180559945309417232121458d+00
go to 50
10 if (b /= 8) go to 20
lnb = 2.07944154167983592825169636437d+00
go to 50
20 if (b /= 16) go to 30
lnb = 2.77258872223978123766892848583d+00
go to 50
30 db = b
lnb = log(db)
50 if (l == 0) go to 60
m = ipmpar(9) - 1
dxparg = 0.999999999999d+00 * (m * lnb)
return
60 m = ipmpar(10)
dxparg = 0.999999999999d+00 * (m * lnb)
end function dxparg

pure subroutine ishell(a, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: a(n)
integer :: i, ii, imax, j, jmax, ki, l, ll, s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. It is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
   end do
   i = i - 1
end do
end subroutine ishell

pure subroutine shell(a, n)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. It is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
   end do
   i = i - 1
end do
end subroutine shell

pure subroutine shell2(a, b, n)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(n), b(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s, t
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. The same permutations are
!     performed on b that are performed on A. it is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = b(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      b(ll) = b(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
      b(ll) = t
   end do
   i = i - 1
end do
end subroutine shell2

pure subroutine rsort(a, n)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. It is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
   end do
   i = i - 1
end do
end subroutine rsort

pure subroutine risort(a, m, n)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(n)
integer, intent(inout) :: m(n)
integer :: i, ii, imax, j, jmax, ki, l, ll, t
real :: s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. The same permutations are
!     performed on m that are performed on A. it is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = m(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      m(ll) = m(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
      m(ll) = t
   end do
   i = i - 1
end do
end subroutine risort

pure subroutine rrsort(a, b, n)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(n), b(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s, t
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. The same permutations are
!     performed on b that are performed on A. it is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = b(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      b(ll) = b(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
      b(ll) = t
   end do
   i = i - 1
end do
end subroutine rrsort

pure subroutine dsort(a, n)
implicit none
integer, intent(in) :: n
double precision, intent(inout) :: a(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
double precision :: s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. It is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
   end do
   i = i - 1
end do
end subroutine dsort

pure subroutine disort(a, m, n)
implicit none
integer, intent(in) :: n
double precision, intent(inout) :: a(n)
integer, intent(inout) :: m(n)
integer :: i, ii, imax, j, jmax, ki, l, ll, t
double precision :: s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. The same permutations are
!     performed on m that are performed on A. it is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = m(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      m(ll) = m(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
      m(ll) = t
   end do
   i = i - 1
end do
end subroutine disort

pure subroutine ddsort(a, b, n)
implicit none
integer, intent(in) :: n
double precision, intent(inout) :: a(n), b(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
double precision :: s, t
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     so that a(i).LE.a(i+1) for i=1,...,n-1. The same permutations are
!     performed on b that are performed on A. it is assumed that n.GE.1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that a(j).LE.a(j+ki) for j=1,...,n-ki
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = b(ll)
30    if (s >= a(l)) go to 31
      a(ll) = a(l)
      b(ll) = b(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
      b(ll) = t
   end do
   i = i - 1
end do
end subroutine ddsort

pure subroutine aord(a, n)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     The aord sorting procedure is used to reorder the elements of
!     a so that abs(a(i)) .LE. abs(a(i+1)) for i = 1,...,n-1. It is
!     assumed that n .GE. 1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!                 so that abs(a(j)) .LE. abs(a(j+ki))
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30    if (abs(s) >= abs(a(l))) go to 31
      a(ll) = a(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
   end do
   i = i - 1
end do
end subroutine aord

pure subroutine daord(a, n)
implicit none
integer, intent(in) :: n
double precision, intent(inout) :: a(n)
integer :: i, ii, imax, j, jmax, ki, l, ll
double precision :: s
integer, parameter :: k(10) = [1, 4, 13, 40, 121, 364, 1093, 3280, 9841, 29524]
!-----------------------------------------------------------------------
!     daord is used to reorder the elements of the double precision
!     array a so that dabs(a(i)) .LE. dabs(a(i+1)) for i = 1,...,n-1.
!     It is assumed that n .GE. 1.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!             Selection of the increments k(i) = (3**i-1)/2
if (n < 2) return
imax = 1
do i = 3,10
   if (n <= k(i)) exit
   imax = imax + 1
end do
!            Stepping through the increments k(imax),...,k(1)
i = imax
do ii = 1,imax
   ki = k(i)
!             Sorting elements that are ki positions apart
!               so that dabs(a(j)) .LE. dabs(a(j+ki))
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30    if (abs(s) >= abs(a(l))) go to 31
      a(ll) = a(l)
      ll = l
      l = l - ki
      if (l > 0) go to 30
31    a(ll) = s
   end do
   i = i - 1
end do
end subroutine daord

pure subroutine qsorti(x, ind, n)
implicit none
integer, intent(in) :: n, x(n)
integer, intent(inout) :: ind(n)
integer :: iu(21), il(21), m, i, j, k, l, ij, it, itt, indx, t
real :: r
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!   This subroutine uses an order n*log(n) quick sort to
! sort an integer array x into increasing order.  The algor-
! ithm is as follows.  Ind is initialized to the ordered
! sequence of indices 1,...,n, and all interchanges are
! applied to ind.  x is divided into two portions by picking
! a central element t.  the first and last elements are com-
! pared with t, and interchanges are applied as necessary so
! that the three values are in ascending order.  Inter-
! changes are then applied so that all elements greater than
! t are in the upper portion of the array and all elements
! less than t are in the lower portion.  The upper and lower
! indices of one of the portions are saved in local arrays,
! and the process is repeated iteratively on the other
! portion.  When a portion is completely sorted, the process
! begins again by retrieving the indices bounding another
! unsorted portion.
! INPUT PARAMETERS -   n - LENGTH OF THE ARRAY x.
!                      x - Vector of length n to be sorted.
!                    ind - Vector of length .GE. n.
! n and x are not altered by this routine.
! Output parameter - ind - Sequence of indices 1,...,n
!                          permuted in the same fashion as x
!                          would be.  Thus, the ordering on
!                          x is defined by Y(i) = x(ind(i)).
! Intrinsic functions called by qsorti - Ifix, float
!***********************************************************
! Note -- iu and il must be dimensioned .GE. log(n) where
!         log has base 2.
!***********************************************************
! Local parameters -
! iu,il =  Temporary storage for the upper and lower
!            indices of portions of the array x
! m =      Index for iu and il
! i,j =    Lower and upper indices of a portion of x
! k,l =    Indices in the range i,...,j
! ij =     Randomly chosen index between i and j
! it,itt = Temporary storage for interchanges in ind
! indx =   Temporary index for x
! r =      Pseudo random number for generating ij
! t =      Central element of x
if (n <= 0) return
! Initialize ind, m, i, j, and r
do i = 1,n
   ind(i) = i
end do
m = 1
i = 1
j = n
r = .375
! Top of loop
2 if (i >= j) go to 10
if (r > .5898437) go to 3
r = r + .0390625
go to 4
3 r = r - .21875
! Initialize k
4 k = i
! Select a central element of x and save it in t
ij = i + ifix(r*float(j - i))
it = ind(ij)
t = x(it)
! If the first element of the array is greater than t,
!   interchange it with t
indx = ind(i)
if (x(indx) <= t) go to 5
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
! Initialize l
5 l = j
! If the last element of the array is less than t,
!   interchange it with t
indx = ind(j)
if (x(indx) >= t) go to 7
ind(ij) = indx
ind(j) = it
it = indx
t = x(it)
! If the first element of the array is greater than t,
!   interchange it with t
indx = ind(i)
if (x(indx) <= t) go to 7
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
go to 7
! Interchange elements k and l
6 itt = ind(l)
ind(l) = ind(k)
ind(k) = itt
! Find an element in the upper part of the array which is
!   not larger than t
7 l = l - 1
indx = ind(l)
if (x(indx) > t) go to 7
! Find an element in the lower part of the array whcih is
!   not smaller than t
8 k = k + 1
indx = ind(k)
if (x(indx) < t) go to 8
! If k .LE. l, interchange elements k and l
if (k <= l) go to 6
! Save the upper and lower subscripts of the portion of the
!   array yet to be sorted
if (l - i <= j - k) go to 9
il(m) = i
iu(m) = l
i = k
m = m + 1
go to 11
9 il(m) = k
iu(m) = j
j = l
m = m + 1
go to 11
! Begin again on another unsorted portion of the array
10 m = m - 1
if (m == 0) return
i = il(m)
j = iu(m)
11 if (j - i >= 11) go to 4
if (i == 1) go to 2
i = i - 1
! Sort elements i+1,...,j.  note that 1 .LE. i .LT. j and
!   j-i .LT. 11.
12 i = i + 1
if (i == j) go to 10
indx = ind(i + 1)
t = x(indx)
it = indx
indx = ind(i)
if (x(indx) <= t) go to 12
k = i
13 ind(k + 1) = ind(k)
k = k - 1
indx = ind(k)
if (t < x(indx)) go to 13
ind(k + 1) = it
go to 12
end subroutine qsorti

pure subroutine qsortr(x, ind, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ind(n)
real, intent(in) :: x(n)
integer :: iu(21), il(21), m, i, j, k, l, ij, it, itt, indx
real :: r, t
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!   This subroutine uses an order n*log(n) quick sort to
! sort the real array x into increasing order.  The algor-
! ithm is as follows.  Ind is initialized to the ordered
! sequence of indices 1,...,n, and all interchanges are
! applied to ind.  x is divided into two portions by picking
! a central element t.  the first and last elements are com-
! pared with t, and interchanges are applied as necessary so
! that the three values are in ascending order.  Inter-
! changes are then applied so that all elements greater than
! t are in the upper portion of the array and all elements
! less than t are in the lower portion.  The upper and lower
! indices of one of the portions are saved in local arrays,
! and the process is repeated iteratively on the other
! portion.  When a portion is completely sorted, the process
! begins again by retrieving the indices bounding another
! unsorted portion.
! INPUT PARAMETERS -   n - LENGTH OF THE ARRAY x.
!                      x - Vector of length n to be sorted.
!                    ind - Vector of length .GE. n.
! n and x are not altered by this routine.
! Output parameter - ind - Sequence of indices 1,...,n
!                          permuted in the same fashion as x
!                          would be.  Thus, the ordering on
!                          x is defined by Y(i) = x(ind(i)).
! Intrinsic functions called by qsortr - Ifix, float
!***********************************************************
! Note -- iu and il must be dimensioned .GE. log(n) where
!         log has base 2.
!***********************************************************
! Local parameters -
! iu,il =  Temporary storage for the upper and lower
!            indices of portions of the array x
! m =      Index for iu and il
! i,j =    Lower and upper indices of a portion of x
! k,l =    Indices in the range i,...,j
! ij =     Randomly chosen index between i and j
! it,itt = Temporary storage for interchanges in ind
! indx =   Temporary index for x
! r =      Pseudo random number for generating ij
! t =      Central element of x
if (n <= 0) return
! Initialize ind, m, i, j, and r
do i = 1,n
   ind(i) = i
end do
m = 1
i = 1
j = n
r = .375
! Top of loop
2 if (i >= j) go to 10
if (r > .5898437) go to 3
r = r + .0390625
go to 4
3 r = r - .21875
! Initialize k
4 k = i
! Select a central element of x and save it in t
ij = i + ifix(r*float(j - i))
it = ind(ij)
t = x(it)
! If the first element of the array is greater than t,
!   interchange it with t
indx = ind(i)
if (x(indx) <= t) go to 5
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
! Initialize l
5 l = j
! If the last element of the array is less than t,
!   interchange it with t
indx = ind(j)
if (x(indx) >= t) go to 7
ind(ij) = indx
ind(j) = it
it = indx
t = x(it)
! If the first element of the array is greater than t,
!   interchange it with t
indx = ind(i)
if (x(indx) <= t) go to 7
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
go to 7
! Interchange elements k and l
6 itt = ind(l)
ind(l) = ind(k)
ind(k) = itt
! Find an element in the upper part of the array which is
!   not larger than t
7 l = l - 1
indx = ind(l)
if (x(indx) > t) go to 7
! Find an element in the lower part of the array whcih is
!   not smaller than t
8 k = k + 1
indx = ind(k)
if (x(indx) < t) go to 8
! If k .LE. l, interchange elements k and l
if (k <= l) go to 6
! Save the upper and lower subscripts of the portion of the
!   array yet to be sorted
if (l - i <= j - k) go to 9
il(m) = i
iu(m) = l
i = k
m = m + 1
go to 11
9 il(m) = k
iu(m) = j
j = l
m = m + 1
go to 11
! Begin again on another unsorted portion of the array
10 m = m - 1
if (m == 0) return
i = il(m)
j = iu(m)
11 if (j - i >= 11) go to 4
if (i == 1) go to 2
i = i - 1
! Sort elements i+1,...,j.  note that 1 .LE. i .LT. j and
!   j-i .LT. 11.
12 i = i + 1
if (i == j) go to 10
indx = ind(i + 1)
t = x(indx)
it = indx
indx = ind(i)
if (x(indx) <= t) go to 12
k = i
13 ind(k + 1) = ind(k)
k = k - 1
indx = ind(k)
if (t < x(indx)) go to 13
ind(k + 1) = it
go to 12
end subroutine qsortr

pure subroutine qsortd(x, ind, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ind(n)
double precision, intent(in) :: x(n)
integer :: iu(21), il(21), m, i, j, k, l, ij, it, itt, indx
real :: r
double precision :: t
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!   This subroutine uses an order n*log(n) quick sort to
! sort a double precision array x into increasing order. The
! algorithm is as follows. Ind is initialized to the ordered
! sequence of indices 1,...,n, and all interchanges are
! applied to ind.  x is divided into two portions by picking
! a central element t.  the first and last elements are com-
! pared with t, and interchanges are applied as necessary so
! that the three values are in ascending order.  Inter-
! changes are then applied so that all elements greater than
! t are in the upper portion of the array and all elements
! less than t are in the lower portion.  The upper and lower
! indices of one of the portions are saved in local arrays,
! and the process is repeated iteratively on the other
! portion.  When a portion is completely sorted, the process
! begins again by retrieving the indices bounding another
! unsorted portion.
! INPUT PARAMETERS -   n - LENGTH OF THE ARRAY x.
!                      x - Vector of length n to be sorted.
!                    ind - Vector of length .GE. n.
! n and x are not altered by this routine.
! Output parameter - ind - Sequence of indices 1,...,n
!                          permuted in the same fashion as x
!                          would be.  Thus, the ordering on
!                          x is defined by Y(i) = x(ind(i)).
! Intrinsic functions called by qsortd - Ifix, float
!***********************************************************
! Note -- iu and il must be dimensioned .GE. log(n) where
!         log has base 2.
!***********************************************************
! Local parameters -
! iu,il =  Temporary storage for the upper and lower
!            indices of portions of the array x
! m =      Index for iu and il
! i,j =    Lower and upper indices of a portion of x
! k,l =    Indices in the range i,...,j
! ij =     Randomly chosen index between i and j
! it,itt = Temporary storage for interchanges in ind
! indx =   Temporary index for x
! r =      Pseudo random number for generating ij
! t =      Central element of x
if (n <= 0) return
! Initialize ind, m, i, j, and r
do i = 1,n
   ind(i) = i
end do
m = 1
i = 1
j = n
r = .375
! Top of loop
2 if (i >= j) go to 10
if (r > .5898437) go to 3
r = r + .0390625
go to 4
3 r = r - .21875
! Initialize k
4 k = i
! Select a central element of x and save it in t
ij = i + ifix(r*float(j - i))
it = ind(ij)
t = x(it)
! If the first element of the array is greater than t,
!   interchange it with t
indx = ind(i)
if (x(indx) <= t) go to 5
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
! Initialize l
5 l = j
! If the last element of the array is less than t,
!   interchange it with t
indx = ind(j)
if (x(indx) >= t) go to 7
ind(ij) = indx
ind(j) = it
it = indx
t = x(it)
! If the first element of the array is greater than t,
!   interchange it with t
indx = ind(i)
if (x(indx) <= t) go to 7
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
go to 7
! Interchange elements k and l
6 itt = ind(l)
ind(l) = ind(k)
ind(k) = itt
! Find an element in the upper part of the array which is
!   not larger than t
7 l = l - 1
indx = ind(l)
if (x(indx) > t) go to 7
! Find an element in the lower part of the array whcih is
!   not smaller than t
8 k = k + 1
indx = ind(k)
if (x(indx) < t) go to 8
! If k .LE. l, interchange elements k and l
if (k <= l) go to 6
! Save the upper and lower subscripts of the portion of the
!   array yet to be sorted
if (l - i <= j - k) go to 9
il(m) = i
iu(m) = l
i = k
m = m + 1
go to 11
9 il(m) = k
iu(m) = j
j = l
m = m + 1
go to 11
! Begin again on another unsorted portion of the array
10 m = m - 1
if (m == 0) return
i = il(m)
j = iu(m)
11 if (j - i >= 11) go to 4
if (i == 1) go to 2
i = i - 1
! Sort elements i+1,...,j.  note that 1 .LE. i .LT. j and
!   j-i .LT. 11.
12 i = i + 1
if (i == j) go to 10
indx = ind(i + 1)
t = x(indx)
it = indx
indx = ind(i)
if (x(indx) <= t) go to 12
k = i
13 ind(k + 1) = ind(k)
k = k - 1
indx = ind(k)
if (t < x(indx)) go to 13
ind(k + 1) = it
go to 12
end subroutine qsortd

pure subroutine iorder(a, ip, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: a(n), ip(n)
integer :: nn, k, j, ipj, temp
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!   This routine applies a set of permutations to a vector.
! Input parameters -  n - Length of A and ip.
!                    ip - Vector containing the sequence of
!                         integers 1,...,n permuted in the
!                         same fashion that A is to be per-
!                         muted.
!                     a - Vector to be permuted.
! n and ip are not altered by this routine.
! Output parameter -  a - Reordered vector reflecting the
!                         permutations defined by ip.
!***********************************************************
! Local parameters -
! nn =   Local copy of n
! k =    Index for ip and for the first element of A in A
!          permutation
! j =    Index for ip and A, j .GE. k
! ipj =  ip(j)
! temp = Temporary storage for a(k)
nn = n
if (nn < 2) return
k = 1
! Loop on permutations
1 j = k
temp = a(k)
! Apply permutation to A.  ip(j) is marked (made negative)
!   as being included in the permutation.
2 ipj = ip(j)
ip(j) = -ipj
if (ipj == k) go to 3
a(j) = a(ipj)
j = ipj
go to 2
3 a(j) = temp
! Search for an unmarked element of ip
4 k = k + 1
if (k > nn) go to 5
if (ip(k) > 0) go to 1
go to 4
! All permutations have been applied.  Unmark ip.
5 do k = 1,nn
   ip(k) = -ip(k)
end do
end subroutine iorder

pure subroutine rorder(a, ip, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ip(n)
real, intent(inout) :: a(n)
integer :: nn, k, j, ipj
real :: temp
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!   This routine applies a set of permutations to a vector.
! Input parameters -  n - Length of A and ip.
!                    ip - Vector containing the sequence of
!                         integers 1,...,n permuted in the
!                         same fashion that A is to be per-
!                         muted.
!                     a - Vector to be permuted.
! n and ip are not altered by this routine.
! Output parameter -  a - Reordered vector reflecting the
!                         permutations defined by ip.
!***********************************************************
! Local parameters -
! nn =   Local copy of n
! k =    Index for ip and for the first element of A in A
!          permutation
! j =    Index for ip and A, j .GE. k
! ipj =  ip(j)
! temp = Temporary storage for a(k)
nn = n
if (nn < 2) return
k = 1
! Loop on permutations
1 j = k
temp = a(k)
! Apply permutation to A.  ip(j) is marked (made negative)
!   as being included in the permutation.
2 ipj = ip(j)
ip(j) = -ipj
if (ipj == k) go to 3
a(j) = a(ipj)
j = ipj
go to 2
3 a(j) = temp
! Search for an unmarked element of ip
4 k = k + 1
if (k > nn) go to 5
if (ip(k) > 0) go to 1
go to 4
! All permutations have been applied.  Unmark ip.
5 do k = 1,nn
   ip(k) = -ip(k)
end do
end subroutine rorder

pure subroutine dorder(a, ip, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ip(n)
double precision, intent(inout) :: a(n)
integer :: nn, k, j, ipj
double precision :: temp
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!   This routine applies a set of permutations to a vector.
! Input parameters -  n - Length of A and ip.
!                    ip - Vector containing the sequence of
!                         integers 1,...,n permuted in the
!                         same fashion that A is to be per-
!                         muted.
!                     a - Vector to be permuted.
! n and ip are not altered by this routine.
! Output parameter -  a - Reordered vector reflecting the
!                         permutations defined by ip.
!***********************************************************
! Local parameters -
! nn =   Local copy of n
! k =    Index for ip and for the first element of A in A
!          permutation
! j =    Index for ip and A, j .GE. k
! ipj =  ip(j)
! temp = Temporary storage for a(k)
nn = n
if (nn < 2) return
k = 1
! Loop on permutations
1 j = k
temp = a(k)
! Apply permutation to A.  ip(j) is marked (made negative)
!   as being included in the permutation.
2 ipj = ip(j)
ip(j) = -ipj
if (ipj == k) go to 3
a(j) = a(ipj)
j = ipj
go to 2
3 a(j) = temp
! Search for an unmarked element of ip
4 k = k + 1
if (k > nn) go to 5
if (ip(k) > 0) go to 1
go to 4
! All permutations have been applied.  Unmark ip.
5 do k = 1,nn
   ip(k) = -ip(k)
end do
end subroutine dorder

pure elemental real function cbrt(x)
implicit none
real, intent(in) :: x
real :: r, nswc_ai_r4
!-----------------------------------------------------------------------
!                   Cube root of a real number
!-----------------------------------------------------------------------
nswc_ai_r4 = x
if (nswc_ai_r4 < 0) then
   r = log(-x)/3.0
   cbrt = -exp(r)
else if (nswc_ai_r4 == 0) then
   cbrt = 0.0
else
   r = log(x)/3.0
   cbrt = exp(r)
end if
end function cbrt

pure elemental double precision function dcbrt(x)
implicit none
!-----------------------------------------------------------------------
!                   Cube root of a real number
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: r, nswc_ai_r8
nswc_ai_r8 = x
if (nswc_ai_r8 < 0) then
   r = log(-x)/3.d0
   dcbrt = -exp(r)
else if (nswc_ai_r8 == 0) then
   dcbrt = 0.d0
else
   r = log(x)/3.d0
   dcbrt = exp(r)
end if
end function dcbrt

pure elemental function artnq(y,x)
implicit none
real, intent(in) :: x, y
real :: artnq
real :: nswc_ai_r4
nswc_ai_r4 = x
if (nswc_ai_r4 < 0) go to 1
if (nswc_ai_r4 == 0) go to 2
go to 5
1 artnq = atan(y/x) + 3.1415926535898
return
2 nswc_ai_r4 = y
if (nswc_ai_r4 < 0) go to 3
if (nswc_ai_r4 == 0) go to 8
go to 4
3 artnq = 4.7123889803847
return
4 artnq = 1.5707963267949
return
5 nswc_ai_r4 = y
if (nswc_ai_r4 < 0) go to 6
if (nswc_ai_r4 == 0) go to 8
go to 7
6 artnq = atan(y/x) + 6.2831853071795
return
7 artnq = atan(y/x)
return
8 artnq = 0.
end function artnq

pure elemental double precision function dartnq(y,x)
implicit none
double precision, intent(in) :: x, y
double precision :: nswc_ai_r8
nswc_ai_r8 = x
if (nswc_ai_r8 < 0) go to 1
if (nswc_ai_r8 == 0) go to 2
go to 5
1 dartnq = atan(y/x) + 3.14159265358979323846264338328d0
return
2 nswc_ai_r8 = y
if (nswc_ai_r8 < 0) go to 3
if (nswc_ai_r8 == 0) go to 8
go to 4
3 dartnq = 4.71238898038468985769396507492d0
return
4 dartnq = 1.57079632679489661923132169164d0
return
5 nswc_ai_r8 = y
if (nswc_ai_r8 < 0) go to 6
if (nswc_ai_r8 == 0) go to 8
go to 7
6 dartnq = atan(y/x) + 6.28318530717958647692528676656d0
return
7 dartnq = atan(y/x)
return
8 dartnq = 0.d0
end function dartnq

pure elemental real function cpabs(x, y)
implicit none
real, intent(in) :: x, y
real :: a
!     --------------------------------------
!     Evaluation of sqrt(x*x + y*y)
!     --------------------------------------
if (abs(x) <= abs(y)) go to 10
a = y/x
cpabs = abs(x)*sqrt(1.0 + a*a)
return
10 if (y == 0.0) go to 20
a = x/y
cpabs = abs(y)*sqrt(1.0 + a*a)
return
20 cpabs = 0.0
end function cpabs

pure elemental double precision function dcpabs(x, y)
implicit none
double precision, intent(in) :: x, y
double precision :: a
!     --------------------------------------
!     Evaluation of sqrt(x*x + y*y)
!     --------------------------------------
if (abs(x) <= abs(y)) go to 10
a = y/x
dcpabs = abs(x)*sqrt(1.d0 + a*a)
return
10 if (y == 0.d0) go to 20
a = x/y
dcpabs = abs(y)*sqrt(1.d0 + a*a)
return
20 dcpabs = 0.d0
end function dcpabs

pure elemental subroutine crec(x, y, u, v)
implicit none
real, intent(inout) :: u, v
real, intent(in) :: x, y
real :: d, t
!-----------------------------------------------------------------------
!             COMPLEX RECIPROCAL u + I*v = 1/(x + I*y)
!-----------------------------------------------------------------------
if (abs(x) > abs(y)) go to 10
t = x/y
d = y + t*x
u = t/d
v = -1.0/d
return
10 t = y/x
d = x + t*y
u = 1.0/d
v = -t/d
end subroutine crec

pure elemental subroutine dcrec(x, y, u, v)
implicit none
!-----------------------------------------------------------------------
!             COMPLEX RECIPROCAL u + I*v = 1/(x + I*y)
!-----------------------------------------------------------------------
double precision, intent(in) :: x, y
double precision, intent(inout) :: u, v
double precision :: d, t
if (abs(x) > abs(y)) go to 10
t = x/y
d = y + t*x
u = t/d
v = -1.d0/d
return
10 t = y/x
d = x + t*y
u = 1.d0/d
v = -t/d
end subroutine dcrec

pure elemental complex function cdiv(a, b)
implicit none
complex, intent(in) :: a, b
real :: ai, ar, bi, br, d, t, u, v
!-----------------------------------------------------------------------
!              COMPLEX DIVISION a/b WHERE b IS NONZERO
!-----------------------------------------------------------------------
ar = real(a)
ai = aimag(a)
br = real(b)
bi = aimag(b)
if (abs(br) < abs(bi)) go to 10
t = bi/br
d = br + t*bi
u = (ar + ai*t)/d
v = (ai - ar*t)/d
cdiv = cmplx(u,v)
return
10 t = br/bi
d = bi + t*br
u = (ar*t + ai)/d
v = (ai*t - ar)/d
cdiv = cmplx(u,v)
end function cdiv

pure elemental subroutine cdivid(ar,ai,br,bi,cr,ci)
implicit none
!-----------------------------------------------------------------------
!     Double precision complex division C = A/B avoiding overflow
!-----------------------------------------------------------------------
double precision, intent(in) :: ar, ai, br, bi
double precision, intent(inout) :: cr, ci
double precision :: d, t, u, v
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
if (abs(br) <= abs(bi)) go to 10
t = bi/br
d = br + t*bi
u = (ar + ai*t)/d
v = (ai - ar*t)/d
cr = u
ci = v
return
10 if (bi == 0.d0) go to 20
t = br/bi
d = bi + t*br
u = (ar*t + ai)/d
v = (ai*t - ar)/d
cr = u
ci = v
return
!     Division by zero. C = Infinity
20 cr = dpmpar(3)
ci = cr
end subroutine cdivid

pure subroutine dcsqrt(z, w)
implicit none
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
double precision :: x, y, r, nswc_ai_r8
interface
   pure elemental function dcpabs(x,y)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: dcpabs
   end function dcpabs
end interface
! ----------------------------------------------------------------------
!        w = sqrt(z) for the double precision complex number z
!                         -----------
!     z and w are interpreted as double precision complex numbers.
!     It is assumed that z(1) and z(2) are the real and imaginary
!     parts of the complex number z, and that w(1) and w(2) are
!     the real and imaginary parts of w.
! ----------------------------------------------------------------------
x = z(1)
y = z(2)
nswc_ai_r8 = x
if (nswc_ai_r8 < 0) go to 30
if (nswc_ai_r8 == 0) go to 10
go to 20
10 if (y /= 0.d0) go to 11
w(1) = 0.d0
w(2) = 0.d0
return
11 w(1) = sqrt(0.5d0*abs(y))
w(2) = sign(w(1),y)
return
20 if (y /= 0.d0) go to 21
w(1) = sqrt(x)
w(2) = 0.d0
return
21 r = dcpabs(x,y)
w(1) = sqrt(0.5d0*(r + x))
w(2) = 0.5d0*y/w(1)
return
30 if (y /= 0.d0) go to 31
w(1) = 0.d0
w(2) = sqrt(abs(x))
return
31 r = dcpabs(x,y)
w(2) = sqrt(0.5d0*(r - x))
w(2) = sign(w(2),y)
w(1) = 0.5d0*y/w(2)
end subroutine dcsqrt

pure elemental subroutine poca(r,a,x,y)
implicit none
real, intent(in) :: a, r
real, intent(out) :: x, y
x = r*cos(a)
y = r*sin(a)
end subroutine poca

pure elemental subroutine capo(x,y,r,theta)
implicit none
real, intent(inout) :: r, theta
real, intent(in) :: x, y
real :: a
if (abs(x) <= abs(y)) go to 10
a = y/x
r = abs(x)*sqrt(1.0 + a*a)
theta = atan2(y,x)
return
10 if (y == 0.) go to 20
a = x/y
r = abs(y)*sqrt(1.0 + a*a)
theta = atan2(y,x)
return
20 r = 0.0
theta = 0.0
end subroutine capo

pure elemental subroutine rota(x1,y1,a,x2,y2)
implicit none
real, intent(in) :: a, x1
real, intent(out) :: x2
real, intent(in) :: y1
real, intent(out) :: y2
real :: cosa, sina
sina = sin(a)
cosa = cos(a)
x2 = x1*cosa + y1*sina
y2 = -x1*sina + y1*cosa
end subroutine rota

pure elemental subroutine srotg(sa,sb,sc,ss)
implicit none
real, intent(inout) :: sa, sb, sc, ss
real :: r, u, v
!     Designed by C.L.Lawson, JPL, 1977 sept 08
!     construct the Givens transformation
!         ( sc  ss )
!     g = (        ) ,    sc**2 + ss**2 = 1 ,
!         (-ss  sc )
!     which zeros the second entry of the 2-vector  (sa,sb)**T .
!     The quantity r = (+/-)sqrt(sa**2 + sb**2) overwrites sa in
!     storage.  The value of sb is overwritten by a value Z which
!     allows sc and ss to be recovered by the following algorithm:
!           IF Z=1  SET  sc=0.  AND  ss=1.
!           IF abs(Z) .LT. 1  SET  sc=sqrt(1-Z**2)  AND  ss=Z
!           IF abs(Z) .GT. 1  SET  sc=1/Z  AND  ss=sqrt(1-sc**2)
!     normally, the subprogram srot(N,SX,INCX,SY,INCY,sc,ss) will
!     next be called to apply the transformation to A 2 by N matrix.
! ------------------------------------------------------------------
if (abs(sa) <= abs(sb)) go to 10
! *** HERE abs(sa) .GT. abs(sb) ***
u = sa + sa
v = sb / u
!     Note that u and r have the sign of sa
r = sqrt(.25 + v**2) * u
!     Note that sc is positive
sc = sa / r
ss = v * (sc + sc)
sb = ss
sa = r
return
! *** HERE abs(sa) .LE. abs(sb) ***
10 if (sb == 0.) go to 20
u = sb + sb
v = sa / u
!     Note that u and r have the sign of sb
!     (r is immediately stored in sa)
sa = sqrt(.25 + v**2) * u
!     Note that ss is positive
ss = sb / sa
sc = v * (ss + ss)
if (sc == 0.) go to 15
sb = 1. / sc
return
15 sb = 1.
return
! *** HERE sa = sb = 0. ***
20 sc = 1.
ss = 0.
end subroutine srotg

pure elemental subroutine drotg(da,db,dc,ds)
implicit none
!     Designed by C.L.Lawson, JPL, 1977 sept 08
!     construct the Givens transformation
!         ( dc  ds )
!     g = (        ) ,    dc**2 + ds**2 = 1 ,
!         (-ds  dc )
!     which zeros the second entry of the 2-vector  (da,db)**T .
!     The quantity r = (+/-)dsqrt(da**2 + db**2) overwrites da in
!     storage.  The value of db is overwritten by a value Z which
!     allows dc and ds to be recovered by the following algorithm:
!           IF Z=1  SET  dc=0.D0  AND  ds=1.D0
!           IF dabs(Z) .LT. 1  SET  dc=dsqrt(1-Z**2)  AND  ds=Z
!           IF dabs(Z) .GT. 1  SET  dc=1/Z  AND  ds=dsqrt(1-dc**2)
!     normally, the subprogram drot(N,DX,INCX,DY,INCY,dc,ds) will
!     next be called to apply the transformation to A 2 by N matrix.
! ------------------------------------------------------------------
double precision, intent(inout) :: da, db, dc, ds
double precision :: u, v, r
if (abs(da) <= abs(db)) go to 10
! *** HERE dabs(da) .GT. dabs(db) ***
u = da + da
v = db / u
!     Note that u and r have the sign of da
r = sqrt(.25d0 + v**2) * u
!     Note that dc is positive
dc = da / r
ds = v * (dc + dc)
db = ds
da = r
return
! *** HERE dabs(da) .LE. dabs(db) ***
10 if (db == 0.d0) go to 20
u = db + db
v = da / u
!     Note that u and r have the sign of db
!     (r is immediately stored in da)
da = sqrt(.25d0 + v**2) * u
!     Note that ds is positive
ds = db / da
dc = v * (ds + ds)
if (dc == 0.d0) go to 15
db = 1.d0 / dc
return
15 db = 1.d0
return
! *** HERE da = db = 0.D0 ***
20 dc = 1.d0
ds = 0.d0
end subroutine drotg

subroutine rot3(a, theta)
implicit none
real :: a(3,3)
real, intent(inout) :: theta(3)
real :: r, t, u, v
real, parameter :: pihalf = 1.5707963267949
!     --------------------
if (abs(a(1,1)) > abs(a(2,1))) go to 10
if (a(2,1) /= 0.0) go to 11
!     Case when a(1,1) = a(2,1) = 0
theta(3) = 0.0
theta(2) = sign(pihalf,a(3,1))
u = a(2,2)
v = a(1,2)
if (a(3,1) > 0.0) v = -v
theta(1) = atan2(v,u)
return
!     Computation of r = sqrt(a(1,1)**2 + a(2,1)**2)
10 t = a(2,1)/a(1,1)
r = abs(a(1,1))*sqrt(1.0 + t*t)
go to 20
11 t = a(1,1)/a(2,1)
r = abs(a(2,1))*sqrt(1.0 + t*t)
!     Evaluation of the angles
20 theta(3) = atan2(a(2,1),a(1,1))
theta(2) = atan2(a(3,1),r)
u = dble(a(1,1))*dble(a(2,2)) - dble(a(1,2))*dble(a(2,1))
if (abs(theta(2)) > 0.8) go to 21
u = u/r
v = a(3,2)/cos(theta(2))
go to 22
21 v = dble(a(1,1))*dble(a(1,2)) + dble(a(2,1))*dble(a(2,2))
v = -v/sin(theta(2))
22 theta(1) = atan2(v,u)
end subroutine rot3

pure elemental subroutine constr(xk,yk,zk, cx,sx,cy,sy)
implicit none
real, intent(in) :: xk, yk, zk
real, intent(inout) :: cx, sx
real, intent(out) :: cy, sy
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!   This subroutine constructs the elements of A 3 by 3
! orthogonal matrix R which rotates a point (xk,yk,zk) on
! the unit sphere to the north pole, I.E.
!      (xk)     (cy  0 -sy)   (1   0   0)   (xk)     (0)
!  R * (yk)  =  ( 0  1   0) * (0  cx -sx) * (yk)  =  (0)
!      (zk)     (sy  0  cy)   (0  sx  cx)   (zk)     (1)
! input parameters - xk,yk,zk - Components of a unit vector
!                               to be rotated to (0,0,1).
! Input parameters are not altered by this routine.
! Output parameters - cx,sx,cy,sy - Elements of R -- cx,sx
!                                   define a rotation about
!                                   the X-axis and cy,sy DE-
!                                   fine a rotation about
!                                   the Y-axis.
! Intrinsic function called by constr - Sqrt
!***********************************************************
cy = sqrt(yk*yk + zk*zk)
sy = xk
if (cy == 0.) go to 1
cx = zk/cy
sx = yk/cy
return
! (xk,yk,zk) lies on the X-axis
1 cx = 1.
sx = 0.
end subroutine constr

pure real function ang(n, x, y)
implicit none
integer, intent(in) :: n
real, intent(in) :: x(n), y(n)
integer :: i
real :: d, rx, ry
interface
   pure function snrm2(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: snrm2
   end function snrm2
end interface
!-----------------------------------------------------------------------
!           Computation of the angle between two vectors
!-----------------------------------------------------------------------
if (n < 2) go to 30
rx = snrm2(n, x, 1)
if (rx == 0.0) go to 30
ry = snrm2(n, y, 1)
if (ry == 0.0) go to 30
d = 0.0
do i = 1,n
   d = d + (x(i)/rx - y(i)/ry)**2
end do
if (d > 3.0) go to 20
ang = acos(0.5 + (0.5 - 0.5*d))
return
20 d = 0.0
do i = 1,n
   d = d + (x(i)/rx + y(i)/ry)**2
end do
ang = acos((0.5*d - 0.5) - 0.5)
return
!                           Error return
30 ang = -1.0
end function ang

pure elemental real function sin0(x)
implicit none
real, intent(in) :: x
real :: t
real, parameter :: a0 = .157079632679490e+01
real, parameter :: a1 = -.645964097506244e+00
real, parameter :: a2 = .796926262460396e-01
real, parameter :: a3 = -.468175413228242e-02
real, parameter :: a4 = .160441150291651e-03
real, parameter :: a5 = -.359864175444606e-05
real, parameter :: a6 = .563372101191893e-07
!-----------------------------------------------------------------------
!          Computation of sin(x*PI/2) for abs(x) .LE. 0.5
!-----------------------------------------------------------------------
!------------------------
t = x*x
sin0 = ((((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t &
   & + a1)*t + a0)*x
end function sin0

pure elemental real function cos0(x)
implicit none
real, intent(in) :: x
real :: t
real, parameter :: a1 = -.123370055013615e+01
real, parameter :: a2 = .253669507899753e+00
real, parameter :: a3 = -.208634807330586e-01
real, parameter :: a4 = .919259935580283e-03
real, parameter :: a5 = -.252000841382533e-04
real, parameter :: a6 = .465461768260405e-06
!-----------------------------------------------------------------------
!          Computation of cos(x*PI/2) for abs(x) .LE. 0.5
!-----------------------------------------------------------------------
!------------------------
t = x*x
cos0 = (((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t + a1)*t + 1.0
end function cos0

pure elemental real function sin1(x)
implicit none
real, intent(in) :: x
integer :: max, n
real :: a, t
real, parameter :: a0 = .314159265358979e+01
real, parameter :: a1 = -.516771278004995e+01
real, parameter :: a2 = .255016403987327e+01
real, parameter :: a3 = -.599264528932149e+00
real, parameter :: a4 = .821458689493251e-01
real, parameter :: a5 = -.737001831310553e-02
real, parameter :: a6 = .461514425296398e-03
real, parameter :: b1 = -.493480220054460e+01
real, parameter :: b2 = .405871212639605e+01
real, parameter :: b3 = -.133526276691575e+01
real, parameter :: b4 = .235330543508553e+00
real, parameter :: b5 = -.258048861575714e-01
real, parameter :: b6 = .190653140279462e-02
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!                   Evaluation  of sin(x*PI)
!-----------------------------------------------------------------------
!------------------------
!     ****** max is a machine dependent constant. Max is the
!            largest positive integer that may be used.
max = ipmpar(3)
!------------------------
a = abs(x)
if (a < float(max)) go to 10
sin1 = 0.0
return
10 n = a
a = a - float(n)
if (a > 0.75) go to 20
if (a < 0.25) go to 21
!                    0.25 .LE. a .LE. 0.75
a = 0.25 + (0.25 - a)
t = a*a
sin1 = ((((((b6*t + b5)*t + b4)*t + b3)*t + b2)*t &
   & + b1)*t + 0.5) + 0.5
go to 30
!                 a .LT. 0.25  OR  a .GT. 0.75
20 a = 0.25 + (0.75 - a)
21 t = a*a
sin1 = ((((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t &
   & + a1)*t + a0)*a
!                        Termination
30 if (x < 0.0) sin1 = - sin1
if (mod(n,2) /= 0) sin1 = - sin1
end function sin1

pure elemental real function cos1(x)
implicit none
real, intent(in) :: x
integer :: max, n
real :: a, t
real, parameter :: a0 = .314159265358979e+01
real, parameter :: a1 = -.516771278004995e+01
real, parameter :: a2 = .255016403987327e+01
real, parameter :: a3 = -.599264528932149e+00
real, parameter :: a4 = .821458689493251e-01
real, parameter :: a5 = -.737001831310553e-02
real, parameter :: a6 = .461514425296398e-03
real, parameter :: b1 = -.493480220054460e+01
real, parameter :: b2 = .405871212639605e+01
real, parameter :: b3 = -.133526276691575e+01
real, parameter :: b4 = .235330543508553e+00
real, parameter :: b5 = -.258048861575714e-01
real, parameter :: b6 = .190653140279462e-02
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!                   Evaluation  of cos(x*PI)
!-----------------------------------------------------------------------
!------------------------
!     ****** max is a machine dependent constant. Max is the
!            largest positive integer that may be used.
max = ipmpar(3)
!------------------------
a = abs(x)
if (a < float(max)) go to 10
cos1 = 1.0
return
10 n = a
a = a - float(n)
if (a > 0.75) go to 20
if (a < 0.25) go to 21
!                    0.25 .LE. a .LE. 0.75
a = 0.25 + (0.25 - a)
t = a*a
cos1 = ((((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t &
   & + a1)*t + a0)*a
go to 30
!                 a .LT. 0.25  OR  a .GT. 0.75
20 a = 0.25 + (0.75 - a)
n = n - 1
21 t = a*a
cos1 = ((((((b6*t + b5)*t + b4)*t + b3)*t + b2)*t &
   & + b1)*t + 0.5) + 0.5
!                        Termination
30 if (mod(n,2) /= 0) cos1 = - cos1
end function cos1

pure elemental double precision function dsin1(x)
implicit none
double precision, intent(in) :: x
integer :: max, n
double precision :: a, t, w
double precision, parameter :: pi = 3.141592653589793238462643383279502884197d+00
double precision, parameter :: a1 = -.1028083791780141522795259479153765743002d+00
double precision, parameter :: a2 = .3170868848763100170457042079710451905600d-02
double precision, parameter :: a3 = -.4657026956105571623449026167864697920000d-04
double precision, parameter :: a4 = .3989844942879455643410226655783424000000d-06
double precision, parameter :: a5 = -.2237397227721999776371894030796800000000d-08
double precision, parameter :: a6 = .8847045483056962709715066675200000000000d-11
double precision, parameter :: a7 = -.2598715447506450292885585920000000000000d-13
double precision, parameter :: a8 = .5893449774331011070033920000000000000000d-16
double precision, parameter :: a9 = -.1062975472045522550784000000000000000000d-18
double precision, parameter :: a10 = .1561182648301780992000000000000000000000d-21
double precision, parameter :: a11 = -.1903193516670976000000000000000000000000d-24
double precision, parameter :: a12 = .1956617650176000000000000000000000000000d-27
double precision, parameter :: a13 = -.1711276032000000000000000000000000000000d-30
double precision, parameter :: b1 = -.3084251375340424568385778437461297229882d+00
double precision, parameter :: b2 = .1585434424381550085228521039855226435920d-01
double precision, parameter :: b3 = -.3259918869273900136414318317506279360000d-03
double precision, parameter :: b4 = .3590860448591510079069203991239232000000d-05
double precision, parameter :: b5 = -.2461136950494199754009084061808640000000d-07
double precision, parameter :: b6 = .1150115912797405152263195572224000000000d-09
double precision, parameter :: b7 = -.3898073171259675439899172864000000000000d-12
double precision, parameter :: b8 = .1001886461636271969091584000000000000000d-14
double precision, parameter :: b9 = -.2019653396886572027084800000000000000000d-17
double precision, parameter :: b10 = .3278483561466560512000000000000000000000d-20
double precision, parameter :: b11 = -.4377345082051788800000000000000000000000d-23
double precision, parameter :: b12 = .4891532381388800000000000000000000000000d-26
double precision, parameter :: b13 = -.4617089843200000000000000000000000000000d-29
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!                Double precision evaluation of sin(pi*x)
!                             --------------
!     The expansion for sin(pi*a) (abs(a) .LE. pi/4) using a1,...,A13
!     is accurate to within 2 units of the 40-TH significant digit, and
!     the expansion for cos(pi*a) (abs(a) .LE. pi/4) using b1,...,B13
!     is accurate to within 4 units of the 40-TH significant digit.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!     ****** max is a machine dependent constant. Max is the
!            largest positive integer that may be used.
max = ipmpar(3)
!------------------------
a = abs(x)
t = max
if (a < t) go to 10
dsin1 = 0.d0
return
10 n = a
t = n
a = a - t
if (a > 0.75d0) go to 20
if (a < 0.25d0) go to 21
!                    0.25 .LE. a .LE. 0.75
a = 0.25d0 + (0.25d0 - a)
t = 16.d0*a*a
dsin1 = (((((((((((((b13*t + b12)*t + b11)*t + b10)*t + b9)*t + &
   & b8)*t + b7)*t + b6)*t + b5)*t + b4)*t + b3)*t + &
   & b2)*t + b1)*t + 0.5d0) + 0.5d0
go to 30
!                 a .LT. 0.25  OR  a .GT. 0.75
20 a = 0.25d0 + (0.75d0 - a)
21 t = 16.d0*a*a
w = (((((((((((((a13*t + a12)*t + a11)*t + a10)*t + a9)*t + &
   & a8)*t + a7)*t + a6)*t + a5)*t + a4)*t + a3)*t + &
   & a2)*t + a1)*t + 0.5d0) + 0.5d0
dsin1 = pi*a*w
!                        Termination
30 if (x < 0.0) dsin1 = - dsin1
if (mod(n,2) /= 0) dsin1 = - dsin1
end function dsin1

pure elemental double precision function dcos1(x)
implicit none
double precision, intent(in) :: x
integer :: max, n
double precision :: a, t, w
double precision, parameter :: pi = 3.141592653589793238462643383279502884197d+00
double precision, parameter :: a1 = -.1028083791780141522795259479153765743002d+00
double precision, parameter :: a2 = .3170868848763100170457042079710451905600d-02
double precision, parameter :: a3 = -.4657026956105571623449026167864697920000d-04
double precision, parameter :: a4 = .3989844942879455643410226655783424000000d-06
double precision, parameter :: a5 = -.2237397227721999776371894030796800000000d-08
double precision, parameter :: a6 = .8847045483056962709715066675200000000000d-11
double precision, parameter :: a7 = -.2598715447506450292885585920000000000000d-13
double precision, parameter :: a8 = .5893449774331011070033920000000000000000d-16
double precision, parameter :: a9 = -.1062975472045522550784000000000000000000d-18
double precision, parameter :: a10 = .1561182648301780992000000000000000000000d-21
double precision, parameter :: a11 = -.1903193516670976000000000000000000000000d-24
double precision, parameter :: a12 = .1956617650176000000000000000000000000000d-27
double precision, parameter :: a13 = -.1711276032000000000000000000000000000000d-30
double precision, parameter :: b1 = -.3084251375340424568385778437461297229882d+00
double precision, parameter :: b2 = .1585434424381550085228521039855226435920d-01
double precision, parameter :: b3 = -.3259918869273900136414318317506279360000d-03
double precision, parameter :: b4 = .3590860448591510079069203991239232000000d-05
double precision, parameter :: b5 = -.2461136950494199754009084061808640000000d-07
double precision, parameter :: b6 = .1150115912797405152263195572224000000000d-09
double precision, parameter :: b7 = -.3898073171259675439899172864000000000000d-12
double precision, parameter :: b8 = .1001886461636271969091584000000000000000d-14
double precision, parameter :: b9 = -.2019653396886572027084800000000000000000d-17
double precision, parameter :: b10 = .3278483561466560512000000000000000000000d-20
double precision, parameter :: b11 = -.4377345082051788800000000000000000000000d-23
double precision, parameter :: b12 = .4891532381388800000000000000000000000000d-26
double precision, parameter :: b13 = -.4617089843200000000000000000000000000000d-29
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!                Double precision evaluation of cos(pi*x)
!                             --------------
!     The expansion for sin(pi*a) (abs(a) .LE. pi/4) using a1,...,A13
!     is accurate to within 2 units of the 40-TH significant digit, and
!     the expansion for cos(pi*a) (abs(a) .LE. pi/4) using b1,...,B13
!     is accurate to within 4 units of the 40-TH significant digit.
!-----------------------------------------------------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!     ****** max is a machine dependent constant. Max is the
!            largest positive integer that may be used.
max = ipmpar(3)
!------------------------
a = abs(x)
t = max
if (a < t) go to 10
dcos1 = 1.d0
return
10 n = a
t = n
a = a - t
if (a > 0.75d0) go to 20
if (a < 0.25d0) go to 21
!                    0.25 .LE. a .LE. 0.75
a = 0.25d0 + (0.25d0 - a)
t = 16.d0*a*a
w = (((((((((((((a13*t + a12)*t + a11)*t + a10)*t + a9)*t + &
   & a8)*t + a7)*t + a6)*t + a5)*t + a4)*t + a3)*t + &
   & a2)*t + a1)*t + 0.5d0) + 0.5d0
dcos1 = pi*a*w
go to 30
!                 a .LT. 0.25  OR  a .GT. 0.75
20 a = 0.25d0 + (0.75d0 - a)
n = n - 1
21 t = 16.d0*a*a
dcos1 = (((((((((((((b13*t + b12)*t + b11)*t + b10)*t + b9)*t + &
   & b8)*t + b7)*t + b6)*t + b5)*t + b4)*t + b3)*t + &
   & b2)*t + b1)*t + 0.5d0) + 0.5d0
!                        Termination
30 if (mod(n,2) /= 0) dcos1 = - dcos1
end function dcos1

pure elemental subroutine snhcsh(sinhm,coshm,x,isw)
implicit none
integer, intent(in) :: isw
real, intent(inout) :: sinhm, coshm
real, intent(in) :: x
real :: ax, expx, xs, xx
real, parameter :: sp5 = .255251817302048e-09
real, parameter :: sp4 = .723809046696880e-07
real, parameter :: sp3 = .109233297700241e-04
real, parameter :: sp2 = .954811583154274e-03
real, parameter :: sp1 = .452867078563929e-01
real, parameter :: sq1 = -.471329214363072e-02
real, parameter :: cp5 = .116744361560051e-08
real, parameter :: cp4 = .280407224259429e-06
real, parameter :: cp3 = .344417983443219e-04
real, parameter :: cp2 = .232293648552398e-02
real, parameter :: cp1 = .778752378267155e-01
real, parameter :: cq1 = -.545809550662099e-02
real, parameter :: zp3 = 5.59297116264720e-07
real, parameter :: zp2 = 1.77943488030894e-04
real, parameter :: zp1 = 1.69800461894792e-02
real, parameter :: zq4 = 1.33412535492375e-09
real, parameter :: zq3 = -5.80858944138663e-07
real, parameter :: zq2 = 1.27814964403863e-04
real, parameter :: zq1 = -1.63532871439181e-02
real, parameter :: cut(5) = [1.65, 1.2, 1.2, 2.7, 1.65]
!                      From the spline under tension package
!                       coded by A. K. Cline and R. J. Renka
!                            department of computer sciences
!                              University of Texas at Austin
!                          modified by A.H. Morris (NSWC/DL)
! this subroutine returns approximations to
!       sinhm(x) = sinh(x)-x
!       coshm(x) = cosh(x)-1
! and
!       coshmm(x) = cosh(x)-1-x*x/2
! on input--
!   x contains the value of the independent variable.
!   isw indicates the function desired
!           = -1 If only sinhm is desired,
!           =  0 If both sinhm and coshm are desired,
!           =  1 If only coshm is desired,
!           =  2 If only COSHMM is desired,
!           =  3 If both sinhm and COSHMM are desired.
! On output--
!   sinhm contains the value of sinhm(x) if isw .LE. 0 or
!   isw .EQ. 3 (sinhm is unaltered if isw .EQ.1 or isw .EQ.
!   2).
!   coshm contains the value of coshm(x) if isw .EQ. 0 or
!   isw .EQ. 1 and contains the value of COSHMM(x) if isw
!   .GE. 2 (coshm IS UNALTERED IF isw .EQ. -1).
! And
!   x and isw are unaltered.
!-----------------------------------------------------------
xx = x
ax = abs(xx)
xs = xx*xx
if (ax >= cut(isw + 2)) expx = exp(ax)
! sinhm APPROXIMATION
if (isw == 1 .or. isw == 2) go to 2
if (ax >= 1.65) go to 1
sinhm = ((((((sp5*xs + sp4)*xs + sp3)*xs + sp2)*xs + sp1)*xs + 1.) &
   & *xs*xx)/((sq1*xs + 1.)*6.)
go to 2
1 sinhm = -(((ax + ax) + 1./expx) - expx)/2.
if (xx < 0.) sinhm = -sinhm
! coshm APPROXIMATION
2 if (isw /= 0 .and. isw /= 1) go to 4
if (ax >= 1.2) go to 3
coshm = ((((((cp5*xs + cp4)*xs + cp3)*xs + cp2)*xs + cp1)*xs + 1.) &
   & *xs)/((cq1*xs + 1.)*2.)
go to 4
3 coshm = ((1./expx - 2.) + expx)/2.
! COSHMM APPROXIMATION
4 if (isw <= 1) return
if (ax >= 2.70) go to 5
coshm = ((((zp3*xs + zp2)*xs + zp1)*xs + 1.)*xs*xs)/(((((zq4 &
   & *xs + zq3)*xs + zq2)*xs + zq1)*xs + 1.)*24.)
return
5 coshm = (((1./expx - 2.) - xs) + expx)/2.
end subroutine snhcsh

pure elemental real function esum(mu, x)
implicit none
integer, intent(in) :: mu
real, intent(in) :: x
real :: w
!-----------------------------------------------------------------------
!                    Evaluation of exp(mu + x)
!-----------------------------------------------------------------------
if (x > 0.0) go to 10
if (mu < 0) go to 20
w = mu + x
if (w > 0.0) go to 20
esum = exp(w)
return
10 if (mu > 0) go to 20
w = mu + x
if (w < 0.0) go to 20
esum = exp(w)
return
20 w = mu
esum = exp(w)*exp(x)
end function esum

pure elemental double precision function desum(mu, x)
implicit none
integer, intent(in) :: mu
double precision, intent(in) :: x
double precision :: w
!-----------------------------------------------------------------------
!                    Evaluation of exp(mu + x)
!-----------------------------------------------------------------------
if (x > 0.d0) go to 10
if (mu < 0) go to 20
w = mu + x
if (w > 0.d0) go to 20
desum = exp(w)
return
10 if (mu > 0) go to 20
w = mu + x
if (w < 0.d0) go to 20
desum = exp(w)
return
20 w = mu
desum = exp(w)*exp(x)
end function desum

pure elemental real function rexp(x)
implicit none
real, intent(in) :: x
real :: e
real, parameter :: p1 = .914041914819518e-09
real, parameter :: p2 = .238082361044469e-01
real, parameter :: q1 = -.499999999085958e+00
real, parameter :: q2 = .107141568980644e+00
real, parameter :: q3 = -.119041179760821e-01
real, parameter :: q4 = .595130811860248e-03
!-----------------------------------------------------------------------
!            Evaluation of the function exp(x) - 1
!-----------------------------------------------------------------------
!-----------------------
if (abs(x) > 0.15) go to 10
rexp = x*(((p2*x + p1)*x + 1.0)/((((q4*x + q3)*x + q2)*x &
   & + q1)*x + 1.0))
return
10 if (x < 0.0) go to 20
e = exp(x)
rexp = e*(0.5 + (0.5 - 1.0/e))
return
20 if (x < -37.0) go to 30
rexp = (exp(x) - 0.5) - 0.5
return
30 rexp = -1.0
end function rexp

pure elemental double precision function drexp(x)
implicit none
!-----------------------------------------------------------------------
!            Evaluation of the function exp(x) - 1
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: e, w, z
double precision, parameter :: a0 = .248015873015873015873016d-04
double precision, parameter :: a1 = -.344452080605731005808147d-05
double precision, parameter :: a2 = .206664230430046597475413d-06
double precision, parameter :: a3 = -.447300111094328162971036d-08
double precision, parameter :: a4 = .114734027080634968083920d-11
double precision, parameter :: b1 = -.249994190011341852652396d+00
double precision, parameter :: b2 = .249987228833107957725728d-01
double precision, parameter :: b3 = -.119037506846942249362528d-02
double precision, parameter :: b4 = .228908693387350391768682d-04
double precision, parameter :: c1 = .1666666666666666666666666666666667d+00
double precision, parameter :: c2 = .4166666666666666666666666666666667d-01
double precision, parameter :: c3 = .8333333333333333333333333333333333d-02
double precision, parameter :: c4 = .1388888888888888888888888888888889d-02
double precision, parameter :: c5 = .1984126984126984126984126984126984d-03
!---------------------------
!---------------------------
!     ci = 1/factorial(i + 2)
!---------------------------
!---------------------------
if (abs(x) > 0.15d0) go to 10
!        z is a minimax approximation of the series
!                C6 + C7*x + C8*x**2 + ....
!        This approximation is accurate to within
!        1 unit of the 23-RD significant digit.
!        The resulting value for w is accurate to
!        within 1 unit of the 33-RD significant
!        digit.
z = ((((a4*x + a3)*x + a2)*x + a1)*x + a0) / &
   & ((((b4*x + b3)*x + b2)*x + b1)*x + 1.d0)
w = ((((((z*x + c5)*x + c4)*x + c3)*x + c2)*x + &
   & c1)*x + 0.5d0)*x + 1.d0
drexp = x*w
return
10 if (x < 0.d0) go to 20
e = exp(x)
drexp = e*(0.5d0 + (0.5d0 - 1.d0/e))
return
20 if (x < -77.d0) go to 30
drexp = (exp(x) - 0.5d0) - 0.5d0
return
30 drexp = -1.d0
end function drexp

pure elemental subroutine rexp1(x, e, w)
implicit none
real, intent(inout) :: e, w
real, intent(in) :: x
real, parameter :: p1 = .914041914819518e-09
real, parameter :: p2 = .238082361044469e-01
real, parameter :: q1 = -.499999999085958e+00
real, parameter :: q2 = .107141568980644e+00
real, parameter :: q3 = -.119041179760821e-01
real, parameter :: q4 = .595130811860248e-03
!-----------------------------------------------------------------------
!                  Evaluation of w = (exp(x) - 1)/x
!     e is an input/output variable. If e .GE. 0 then it is assumed
!     that e = exp(x). In this case e is not modified. If e .LT. 0
!     then e is set to exp(x) when this value is needed.
!-----------------------------------------------------------------------
!-----------------------
if (abs(x) > 0.15) go to 10
w = ((p2*x + p1)*x + 1.0)/((((q4*x + q3)*x + q2)*x &
   & + q1)*x + 1.0)
return
10 if (x < 0.0) go to 20
if (e < 0.0) e = exp(x)
w = (e*(0.5 + (0.5 - 1.0/e)))/x
return
20 if (x < -37.0) go to 30
if (e < 0.0) e = exp(x)
w = ((e - 0.5) - 0.5)/x
return
30 w = -1.0/x
end subroutine rexp1

pure elemental subroutine drexp1(x, e, w)
implicit none
!-----------------------------------------------------------------------
!                  Evaluation of w = (exp(x) - 1)/x
!     e is an input/output variable. If e .GE. 0 then it is assumed
!     that e = exp(x). In this case e is not modified. If e .LT. 0
!     then e is set to exp(x) when this value is needed.
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision, intent(inout) :: e
double precision, intent(out) :: w
double precision :: z
double precision, parameter :: a0 = .248015873015873015873016d-04
double precision, parameter :: a1 = -.344452080605731005808147d-05
double precision, parameter :: a2 = .206664230430046597475413d-06
double precision, parameter :: a3 = -.447300111094328162971036d-08
double precision, parameter :: a4 = .114734027080634968083920d-11
double precision, parameter :: b1 = -.249994190011341852652396d+00
double precision, parameter :: b2 = .249987228833107957725728d-01
double precision, parameter :: b3 = -.119037506846942249362528d-02
double precision, parameter :: b4 = .228908693387350391768682d-04
double precision, parameter :: c1 = .1666666666666666666666666666666667d+00
double precision, parameter :: c2 = .4166666666666666666666666666666667d-01
double precision, parameter :: c3 = .8333333333333333333333333333333333d-02
double precision, parameter :: c4 = .1388888888888888888888888888888889d-02
double precision, parameter :: c5 = .1984126984126984126984126984126984d-03
!---------------------------
!---------------------------
!     ci = 1/factorial(i + 2)
!---------------------------
!---------------------------
w = 1.d0
if (abs(x) < 1.d-33) return
if (abs(x) > 0.15d0) go to 10
!        z is a minimax approximation of the series
!                C6 + C7*x + C8*x**2 + ....
!        This approximation is accurate to within
!        1 unit of the 23-RD significant digit.
!        The resulting value for w is accurate to
!        within 1 unit of the 33-RD significant
!        digit.
z = ((((a4*x + a3)*x + a2)*x + a1)*x + a0) / &
   & ((((b4*x + b3)*x + b2)*x + b1)*x + 1.d0)
w = ((((((z*x + c5)*x + c4)*x + c3)*x + c2)*x + &
   & c1)*x + 0.5d0)*x + 1.d0
return
10 if (x < 0.d0) go to 20
if (e < 0.d0) e = exp(x)
w = (e*(0.5d0 + (0.5d0 - 1.d0/e)))/x
return
20 if (x < -77.d0) go to 30
if (e < 0.d0) e = exp(x)
w = ((e - 0.5d0) - 0.5d0)/x
return
30 w = -1.d0/x
end subroutine drexp1

pure elemental real function alnrel(a)
implicit none
real, intent(in) :: a
real :: t, t2, w, x
real, parameter :: p1 = -.129418923021993e+01
real, parameter :: p2 = .405303492862024e+00
real, parameter :: p3 = -.178874546012214e-01
real, parameter :: q1 = -.162752256355323e+01
real, parameter :: q2 = .747811014037616e+00
real, parameter :: q3 = -.845104217945565e-01
!-----------------------------------------------------------------------
!            Evaluation of the function ln(1 + a)
!-----------------------------------------------------------------------
!--------------------------
if (abs(a) > 0.375) go to 10
t = a/(a + 2.0)
t2 = t*t
w = (((p3*t2 + p2)*t2 + p1)*t2 + 1.0)/ &
   & (((q3*t2 + q2)*t2 + q1)*t2 + 1.0)
alnrel = 2.0*t*w
return
10 x = 1.0 + a
if (a < 0.0) x = (a + 0.5) + 0.5
alnrel = log(x)
end function alnrel

pure elemental double precision function dlnrel(a)
implicit none
!-----------------------------------------------------------------------
!            Evaluation of the function ln(1 + a)
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision :: t, t2, w, z
double precision, parameter :: p0 = .7692307692307692307680d-01
double precision, parameter :: p1 = -.1505958055914600184836d+00
double precision, parameter :: p2 = .9302355725278521726994d-01
double precision, parameter :: p3 = -.1787900022182327735804d-01
double precision, parameter :: q1 = -.2824412139355646910683d+01
double precision, parameter :: q2 = .2892424216041495392509d+01
double precision, parameter :: q3 = -.1263560605948009364422d+01
double precision, parameter :: q4 = .1966769435894561313526d+00
double precision, parameter :: c1 = .3333333333333333333333333333333d+00
double precision, parameter :: c2 = .2000000000000000000000000000000d+00
double precision, parameter :: c3 = .1428571428571428571428571428571d+00
double precision, parameter :: c4 = .1111111111111111111111111111111d+00
double precision, parameter :: c5 = .9090909090909090909090909090909d-01
!-------------------------
!-------------------------
!     ci = 1/(2i + 1)
!-------------------------
!-------------------------
if (abs(a) < 0.375d0) go to 10
t = 1.d0 + a
if (a < 0.d0) t = 0.5d0 + (0.5d0 + a)
dlnrel = log(t)
return
!        w is a minimax approximation of the series
!               C6 + C7*t**2 + C8*t**4 + ...
!        This approximation is accurate to within
!        1.6 units of the 21-ST significant digit.
!        The resulting value for 1.D0 + t2*z is
!        accurate to within 1 unit of the 30-TH
!        significant digit.
10 t = a/(a + 2.d0)
t2 = t*t
w = (((p3*t2 + p2)*t2 + p1)*t2 + p0)/ &
   & ((((q4*t2 + q3)*t2 + q2)*t2 + q1)*t2 + 1.d0)
z = ((((w*t2 + c5)*t2 + c4)*t2 + c3)*t2 + c2)*t2 + c1
dlnrel = 2.d0*t*(1.d0 + t2*z)
end function dlnrel

pure elemental real function rlog(x)
implicit none
real, intent(in) :: x
real :: r, t, u, up2, w, w1
real, parameter :: a = .566749439387324e-01
real, parameter :: b = .456512608815524e-01
real, parameter :: p0 = .333333333333333e+00
real, parameter :: p1 = -.224696413112536e+00
real, parameter :: p2 = .620886815375787e-02
real, parameter :: q1 = -.127408923933623e+01
real, parameter :: q2 = .354508718369557e+00
!-----------------------------------------------------------------------
!             Evaluation of the function x - 1 - LN(x)
!-----------------------------------------------------------------------
!     a = rlog (0.7)
!     b = rlog (4/3)
!------------------------
!------------------------
!------------------------
if (x < 0.61 .or. x > 1.57) go to 100
if (x < 0.82) go to 10
if (x > 1.18) go to 20
!                 Argument reduction
u = (x - 0.5) - 0.5
up2 = u + 2.0
w1 = 0.0
go to 30
10 u = (x - 0.7)/0.7
up2 = u + 2.0
w1 = a - u*0.3
go to 30
20 t = 0.75*(x - 1.0)
u = t - 0.25
up2 = t + 1.75
w1 = b + u/3.0
!                  Series expansion
30 r = u/up2
t = r*r
w = ((p2*t + p1)*t + p0)/((q2*t + q1)*t + 1.0)
rlog = r*(u - 2.0*t*w) + w1
return
100 r = (x - 0.5) - 0.5
rlog = r - log(x)
end function rlog

pure elemental real function rlog1(x)
implicit none
real, intent(in) :: x
real :: r, t, u, up2, w, w1
real, parameter :: a = .566749439387324e-01
real, parameter :: b = .456512608815524e-01
real, parameter :: p0 = .333333333333333e+00
real, parameter :: p1 = -.224696413112536e+00
real, parameter :: p2 = .620886815375787e-02
real, parameter :: q1 = -.127408923933623e+01
real, parameter :: q2 = .354508718369557e+00
!-----------------------------------------------------------------------
!             Evaluation of the function x - LN(1 + x)
!-----------------------------------------------------------------------
!     a = rlog (0.7)
!     b = rlog (4/3)
!------------------------
!------------------------
!------------------------
if (x < -0.39 .or. x > 0.57) go to 100
if (x < -0.18) go to 10
if (x > 0.18) go to 20
!                 Argument reduction
u = x
up2 = u + 2.0
w1 = 0.0
go to 30
10 u = (x + 0.3)/0.7
up2 = u + 2.0
w1 = a - u*0.3
go to 30
20 t = 0.75*x
u = t - 0.25
up2 = t + 1.75
w1 = b + u/3.0
!                  Series expansion
30 r = u/up2
t = r*r
w = ((p2*t + p1)*t + p0)/((q2*t + q1)*t + 1.0)
rlog1 = r*(u - 2.0*t*w) + w1
return
100 w = (x + 0.5) + 0.5
rlog1 = x - log(w)
end function rlog1

pure elemental double precision function drlog(x)
implicit none
!-----------------------------------------------------------------------
!             Evaluation of the function x - 1 - LN(x)
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: r, t, u, up2, w, w1, z
double precision, parameter :: a = .566749439387323789126387112411845d-01
double precision, parameter :: b = .456512608815524058941143273395059d-01
double precision, parameter :: p0 = .7692307692307692307680d-01
double precision, parameter :: p1 = -.1505958055914600184836d+00
double precision, parameter :: p2 = .9302355725278521726994d-01
double precision, parameter :: p3 = -.1787900022182327735804d-01
double precision, parameter :: q1 = -.2824412139355646910683d+01
double precision, parameter :: q2 = .2892424216041495392509d+01
double precision, parameter :: q3 = -.1263560605948009364422d+01
double precision, parameter :: q4 = .1966769435894561313526d+00
double precision, parameter :: c1 = .333333333333333333333333333333333d+00
double precision, parameter :: c2 = .200000000000000000000000000000000d+00
double precision, parameter :: c3 = .142857142857142857142857142857143d+00
double precision, parameter :: c4 = .111111111111111111111111111111111d+00
double precision, parameter :: c5 = .909090909090909090909090909090909d-01
!-------------------------
!     a = drlog (0.7)
!     b = drlog (4/3)
!-------------------------
!-------------------------
!-------------------------
!     ci = 1/(2i + 1)
!-------------------------
!-------------------------
if (x < 0.61d0 .or. x > 1.57d0) go to 100
if (x < 0.82d0) go to 10
if (x > 1.18d0) go to 20
!                 Argument reduction
u = (x - 0.5d0) - 0.5d0
up2 = u + 2.d0
w1 = 0.d0
go to 30
10 u = (x - 0.7d0)/0.7d0
up2 = u + 2.d0
w1 = a - u*0.3d0
go to 30
20 t = 0.75d0*(x - 1.d0)
u = t - 0.25d0
up2 = t + 1.75d0
w1 = b + u/3.d0
!                  Series expansion
30 r = u/up2
t = r*r
!        z is a minimax approximation of the series
!               C6 + C7*r**2 + C8*r**4 + ...
!        For the interval (0.0, 0.375). The approx-
!        imation is accurate to within 1.6 units of
!        the 21-ST significant digit.
z = (((p3*t + p2)*t + p1)*t + p0)/ &
   & ((((q4*t + q3)*t + q2)*t + q1)*t + 1.d0)
w = ((((z*t + c5)*t + c4)*t + c3)*t + c2)*t + c1
drlog = r*(u - 2.d0*t*w) + w1
return
100 r = (x - 0.5d0) - 0.5d0
drlog = r - log(x)
end function drlog

pure elemental double precision function drlog1(x)
implicit none
!-----------------------------------------------------------------------
!             Evaluation of the function x - LN(1 + x)
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: r, t, u, up2, w, w1, z
double precision, parameter :: a = .566749439387323789126387112411845d-01
double precision, parameter :: b = .456512608815524058941143273395059d-01
double precision, parameter :: p0 = .7692307692307692307680d-01
double precision, parameter :: p1 = -.1505958055914600184836d+00
double precision, parameter :: p2 = .9302355725278521726994d-01
double precision, parameter :: p3 = -.1787900022182327735804d-01
double precision, parameter :: q1 = -.2824412139355646910683d+01
double precision, parameter :: q2 = .2892424216041495392509d+01
double precision, parameter :: q3 = -.1263560605948009364422d+01
double precision, parameter :: q4 = .1966769435894561313526d+00
double precision, parameter :: c1 = .333333333333333333333333333333333d+00
double precision, parameter :: c2 = .200000000000000000000000000000000d+00
double precision, parameter :: c3 = .142857142857142857142857142857143d+00
double precision, parameter :: c4 = .111111111111111111111111111111111d+00
double precision, parameter :: c5 = .909090909090909090909090909090909d-01
!-------------------------
!     a = drlog (0.7)
!     b = drlog (4/3)
!-------------------------
!-------------------------
!-------------------------
!     ci = 1/(2i + 1)
!-------------------------
!-------------------------
if (x < -0.39d0 .or. x > 0.57d0) go to 100
if (x < -0.18d0) go to 10
if (x > 0.18d0) go to 20
!                 Argument reduction
u = x
up2 = u + 2.d0
w1 = 0.d0
go to 30
10 u = (x + 0.3d0)/0.7d0
up2 = u + 2.d0
w1 = a - u*0.3d0
go to 30
20 t = 0.75d0*x
u = t - 0.25d0
up2 = t + 1.75d0
w1 = b + u/3.d0
!                  Series expansion
30 r = u/up2
t = r*r
!        z is a minimax approximation of the series
!               C6 + C7*r**2 + C8*r**4 + ...
!        For the interval (0.0, 0.375). The approx-
!        imation is accurate to within 1.6 units of
!        the 21-ST significant digit.
z = (((p3*t + p2)*t + p1)*t + p0)/ &
   & ((((q4*t + q3)*t + q2)*t + q1)*t + 1.d0)
w = ((((z*t + c5)*t + c4)*t + c3)*t + c2)*t + c1
drlog1 = r*(u - 2.d0*t*w) + w1
return
100 w = (x + 0.5d0) + 0.5d0
drlog1 = x - log(w)
end function drlog1

pure subroutine locpt(x0, y0, x, y, n, l, m)
implicit none
integer, intent(inout) :: l, m
integer, intent(in) :: n
real, intent(in) :: x0, y0
real, intent(in) :: x(n), y(n)
integer :: i, n0
real :: angle, eps, pi, pi2, sum, theta, theta1, thetai, tol, u, v
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!     Given a polygonal line connecting the vertices (x(i),y(i))
!     (i = 1,...,n) taken in this order. It is assumed that the
!     polygonal path is a loop, where (x(n),y(n)) = (x(1),y(1))
!     or there is an arc from (x(n),y(n)) to (x(1),y(1)).
!     (x0,y0) is an arbitrary point and l and m are variables.
!     l and m are assigned the following values ...
!        l = -1   If (x0,y0) is outside the polygonal path
!        l =  0   If (x0,y0) lies on the polygonal path
!        l =  1   If (x0,y0) is inside the polygonal path
!     m = 0 If (x0,y0) is on or outside the path. If (x0,y0)
!     is inside the path then m is the winding number of the
!     path around the point (x0,y0).
!-----------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0
eps = spmpar(1)
!-----------------------------------------------------------------------
n0 = n
if (x(1) == x(n) .and. y(1) == y(n)) n0 = n - 1
pi = atan2(0.0, -1.0)
pi2 = 2.0*pi
tol = 4.0*eps*pi
l = -1
m = 0
u = x(1) - x0
v = y(1) - y0
if (u == 0.0 .and. v == 0.0) go to 20
if (n0 < 2) return
theta1 = atan2(v, u)
sum = 0.0
theta = theta1
do i = 2,n0
   u = x(i) - x0
   v = y(i) - y0
   if (u == 0.0 .and. v == 0.0) go to 20
   thetai = atan2(v, u)
   angle = abs(thetai - theta)
   if (abs(angle - pi) < tol) go to 20
   if (angle > pi) angle = angle - pi2
   if (theta > thetai) angle = -angle
   sum = sum + angle
   theta = thetai
end do
angle = abs(theta1 - theta)
if (abs(angle - pi) < tol) go to 20
if (angle > pi) angle = angle - pi2
if (theta > theta1) angle = -angle
sum = sum + angle
!     sum = 2*pi*m where m is the winding number
m = abs(sum)/pi2 + 0.2
if (m == 0) return
l = 1
if (sum < 0.0) m = -m
return
!     (x0, y0) is on the boundary of the path
20 l = 0
end subroutine locpt

pure subroutine pfind(a, b, x, y, n, u, v, m, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
integer, intent(out) :: num
real, intent(in) :: a(2), b(2), x(n), y(n)
real, intent(inout) :: u(m), v(m)
integer :: i, ind, nm1
real :: d, diff, diff1, eps, h, hi, onem, onep, p, q, s, t, tmax, tmin, tol, tol0, k, ki
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!                 Intersection of a stright line
!                       and polygonal path
!-----------------------------------------------------------------------
!----------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0 .
eps = spmpar(1)
!----------------------
num = 0
if (n < 2) go to 200
h = b(1) - a(1)
k = b(2) - a(2)
if (h == 0.0 .and. k == 0.0) go to 200
ierr = 0
nm1 = n - 1
tol = 4.0*eps
tol0 = 2.0*eps
onep = 1.0 + tol
onem = 0.5 + (0.5 - tol0)
ind = 0
do i = 1, nm1
   hi = x(i + 1) - x(i)
   ki = y(i + 1) - y(i)
   if (hi == 0.0 .and. ki == 0.0) go to 100
   ind = 1
!           Check if the line from A to b and the i-TH
!                 line in the path are parallel
   s = hi*k
   t = h*ki
   d = s - t
   if (abs(d) <= tol*max(abs(s),abs(t))) go to 40
!-----------------------------------------------------------------------
!                   The lines are not parallel
!-----------------------------------------------------------------------
   p = x(i) - a(1)
   q = y(i) - a(2)
   s = hi*q
   t = ki*p
   diff = s - t
   if (abs(diff) <= tol*max(abs(s),abs(t))) diff = 0.0
   s = h*q
   t = k*p
   diff1 = s - t
   if (abs(diff1) <= tol*max(abs(s),abs(t))) diff1 = 0.0
   s = diff/d
   t = diff1/d
   if (s < 0.0 .or. s > onep) go to 100
   if (t < 0.0 .or. t > onep) go to 100
   if (num > 0 .and. t == 0.0) go to 100
   if (s > 0.0) go to 20
!                   Point A is on the i-TH line
10 num = num + 1
   if (num > m) go to 210
   u(num) = a(1)
   v(num) = a(2)
   go to 100
!                   Point b is on the i-TH line
20 if (s < onem) go to 30
21 num = num + 1
   if (num > m) go to 210
   u(num) = b(1)
   v(num) = b(2)
   go to 100
!              The interior of the line from A to b
!                 intersects with the i-TH line
30 num = num + 1
   if (num > m) go to 210
   u(num) = a(1) + s*h
   v(num) = a(2) + s*k
   go to 100
!-----------------------------------------------------------------------
!                     The lines are parallel
!-----------------------------------------------------------------------
40 if (abs(hi) > abs(ki)) go to 50
   d = a(2) - y(i)
   if (abs(d) <= tol0*max(abs(a(2)),abs(y(i)))) d = 0.0
   s = d/ki
   p = x(i) + s*hi
   if (abs(a(1) - p) > tol*max(abs(a(1)),abs(p))) &
      & go to 100
   d = b(2) - y(i)
   if (abs(d) <= tol0*max(abs(b(2)),abs(y(i)))) d = 0.0
   t = d/ki
   go to 60
50 d = a(1) - x(i)
   if (abs(d) <= tol0*max(abs(a(1)),abs(x(i)))) d = 0.0
   s = d/hi
   p = y(i) + s*ki
   if (abs(p - a(2)) > tol*max(abs(p),abs(a(2)))) &
      & go to 100
   d = b(1) - x(i)
   if (abs(d) <= tol0*max(abs(b(1)),abs(x(i)))) d = 0.0
   t = d/hi
!              The 2 lines are portions of the same
!                     straight infinite line
60 if (s > 0.0 .and. s < onem) go to 220
   if (t > 0.0 .and. t < onem) go to 220
   tmin = min(s,t)
   tmax = max(s,t)
   if (tmax <= 0.0) go to 70
   if (tmin >= onem) go to 80
   go to 220
70 if (tmax < 0.0) go to 100
   if (num > 0) go to 100
   if (tmax == s) go to 10
   go to 21
80 if (tmin > 1.0) go to 100
   if (tmin == s) go to 10
   go to 21
100 continue
end do
if (ind == 0) go to 200
if (num < 2) return
if (u(num) == x(1) .and. v(num) == y(1)) &
   & num = num - 1
return
!                          Error return
200 ierr = 1
return
210 ierr = 2
num = num - 1
return
220 ierr = -i
end subroutine pfind

pure subroutine hull(x, y, m, bx, by, k, vx, vy, n)
implicit none
integer, intent(inout) :: k
integer, intent(in) :: m
integer, intent(inout) :: n
real, intent(inout) :: x(m), y(m)
real, intent(inout) :: bx(*), by(*), vx(*), vy(*)
integer :: i, ii, isav, j, j0, k0, kp1, ksav, l, lbeg, lmax, lmin, &
   & lsav, mm1, mp1, nn
real :: dx, dx0, dy, dy0, eps, h, onep, r, x1, xm, xmax, xmin, &
   & ymax, ymin
logical :: ibeg
interface
   pure subroutine rrsort(a,b,n)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: a(n)
      real, intent(inout) :: b(n)
   end subroutine rrsort
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!           Obtaining the convex hull for a finite planar set
!-----------------------------------------------------------------------
!---------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0.
eps = spmpar(1)
!---------------------
mp1 = m + 1
onep = 1.0 + 4.0*eps
!                       Reorder x and y
call rrsort(y, x, m)
ymin = y(1)
ymax = y(m)
if (ymin == ymax) go to 500
l = 1
10 l = l + 1
if (y(l) == ymin) go to 10
lmin = l
l = l - 1
call rrsort(x, y, l)
x1 = x(1)
i = m
20 i = i - 1
if (y(i) == ymax) go to 20
lmax = i
i = i + 1
call rrsort(x(i), y(i), m - lmax)
xm = x(m)
!                      Find xmin and xmax
xmin = x1
xmax = x(l)
do i = lmin,m
   if (x(i) > xmin) go to 30
   xmin = x(i)
   go to 31
30 if (x(i) > xmax) xmax = x(i)
31 continue
end do
!                   Going along the ymin axis
k = l
do i = 1,l
   bx(i) = x(i)
   by(i) = y(i)
end do
n = 1
vx(1) = x(1)
vy(1) = y(1)
if (l == 1) go to 100
n = 2
vx(2) = x(l)
vy(2) = y(l)
!           Going from the ymin axis to the xmax axis
100 h = xmax - bx(k)
if (h == 0.0) go to 150
k0 = k
ibeg = .true.
110 continue
l = l + 1
if (l > lmax) l = m
h = x(l) - bx(k)
if (h <= 0.0) go to 110
dx = x(l) - bx(k0)
dy = y(l) - by(k0)
if (ibeg) go to 120
r = (dx0/dx)*dy
if (r > onep*dy0) go to 130
if (dy0 > onep*r) go to 120
if (dy0 == 0.0 .and. dy > 0.0) go to 140
k = k + 1
go to 121
120 ibeg = .false.
dx0 = dx
dy0 = dy
k = k0 + 1
121 bx(k) = x(l)
by(k) = y(l)
lsav = l
130 h = xmax - x(l)
if (h > 0.0) go to 110
140 l = lsav
n = n + 1
vx(n) = bx(k)
vy(n) = by(k)
go to 100
!                   Going along the xmax axis
150 if (l == m) go to 250
ksav = k
i = l
151 if (i == lmax) go to 160
i = i + 1
if (x(i) /= xmax) go to 151
l = i
k = k + 1
bx(k) = x(i)
by(k) = y(i)
go to 151
160 xmax = x(l)
h = xmax - xm
if (h <= 0.0) go to 170
if (l /= lmax) go to 200
if (k == ksav) go to 170
n = n + 1
vx(n) = bx(k)
vy(n) = by(k)
170 l = m
k = k + 1
bx(k) = xm
by(k) = y(m)
n = n + 1
vx(n) = xm
vy(n) = y(m)
go to 250
!           Going from the ymax axis to the xmax axis
!        (here we are traversing the boundary clockwise)
200 j = mp1
nn = mp1
bx(mp1) = xm
vx(mp1) = xm
by(mp1) = y(m)
vy(mp1) = y(m)
i = lmax + 1
201 j0 = j
ibeg = .true.
210 continue
i = i - 1
h = x(i) - bx(j)
if (h <= 0.0) go to 210
dx = x(i) - bx(j0)
dy = abs(y(i) - by(j0))
if (ibeg) go to 220
r = (dx0/dx)*dy
if (r > onep*dy0) go to 230
if (dy0 > onep*r) go to 220
if (dy0 == 0.0 .and. dy > 0.0) go to 235
j = j - 1
go to 221
220 ibeg = .false.
dx0 = dx
dy0 = dy
j = j0 - 1
221 bx(j) = x(i)
by(j) = y(i)
isav = i
230 h = xmax - x(i)
if (h > 0.0) go to 210
235 i = isav
nn = nn - 1
vx(nn) = bx(j)
vy(nn) = by(j)
h = xmax - bx(j)
if (h > 0.0) go to 201
!          Update bx,by and vx,vy so that the boundary
!           is again being traversed counterclockwise
if (i == l .and. k == ksav) nn = nn + 1
do ii = nn,mp1
   n = n + 1
   vx(n) = vx(ii)
   vy(n) = vy(ii)
end do
if (i == l) j = j + 1
do ii = j,mp1
   k = k + 1
   bx(k) = bx(ii)
   by(k) = by(ii)
end do
l = m
!                   Going along the ymax axis
250 lbeg = lmax + 1
if (lbeg == m) go to 260
mm1 = m - 1
do i = lbeg,mm1
   l = l - 1
   k = k + 1
   bx(k) = x(l)
   by(k) = y(l)
end do
n = n + 1
vx(n) = bx(k)
vy(n) = by(k)
260 if (k == m) go to 370
h = xmax - bx(k)
if (h > 0.0) go to 300
h = bx(k) - xmin
if (h > 0.0) go to 301
go to 370
!           Going from the ymax axis to the xmin axis
300 h = bx(k) - xmin
if (h == 0.0) go to 350
301 k0 = k
ibeg = .true.
310 continue
l = l - 1
if (l < lmin) l = 1
h = x(l) - bx(k)
if (h >= 0.0) go to 310
dx = abs(x(l) - bx(k0))
dy = abs(y(l) - by(k0))
if (ibeg) go to 320
r = (dx0/dx)*dy
if (r > onep*dy0) go to 330
if (dy0 > onep*r) go to 320
if (dy0 == 0.0 .and. dy > 0.0) go to 340
if (k == mp1) go to 330
k = k + 1
go to 321
320 ibeg = .false.
dx0 = dx
dy0 = dy
k = k0 + 1
321 bx(k) = x(l)
by(k) = y(l)
lsav = l
330 h = x(l) - xmin
if (h > 0.0) go to 310
340 l = lsav
n = n + 1
vx(n) = bx(k)
vy(n) = by(k)
if (l == 1) return
if (k == m) go to 370
go to 300
!                   Going along the xmin axis
350 ksav = k
i = l
351 if (i == lmin) go to 360
i = i - 1
if (x(i) /= xmin) go to 351
l = i
k = k + 1
bx(k) = x(i)
by(k) = y(i)
go to 351
360 xmin = x(l)
h = x1 - xmin
if (h <= 0.0) go to 370
if (k == ksav) go to 365
n = n + 1
vx(n) = bx(k)
vy(n) = by(k)
365 if (l /= lmin) go to 400
370 k = k + 1
bx(k) = x1
by(k) = y(1)
n = n + 1
vx(n) = x1
vy(n) = y(1)
return
!           Going from the ymin axis to the xmin axis
!        (here we are traversing the boundary clockwise)
400 if (k == m) go to 370
kp1 = k + 1
j = mp1
nn = mp1
bx(mp1) = x1
vx(mp1) = x1
by(mp1) = y(1)
vy(mp1) = y(1)
i = lmin - 1
401 j0 = j
ibeg = .true.
410 continue
i = i + 1
h = x(i) - bx(j)
if (h >= 0.0) go to 410
dx = abs(x(i) - bx(j0))
dy = y(i) - by(j0)
if (ibeg) go to 420
r = (dx0/dx)*dy
if (r > onep*dy0) go to 430
if (dy0 > onep*r) go to 420
if (dy0 == 0.0 .and. dy > 0.0) go to 440
if (j == kp1) go to 430
j = j - 1
go to 421
420 ibeg = .false.
dx0 = dx
dy0 = dy
j = j0 - 1
421 bx(j) = x(i)
by(j) = y(i)
isav = i
430 h = x(i) - xmin
if (h > 0.0) go to 410
440 i = isav
nn = nn - 1
vx(nn) = bx(j)
vy(nn) = by(j)
if (j == kp1) go to 450
h = bx(j) - xmin
if (h > 0.0) go to 401
!          Update bx,by and vx,vy so that the boundary
!           is again being traversed counterclockwise
450 if (nn == n) go to 470
if (i == l) nn = nn + 1
do ii = nn,mp1
   n = n + 1
   vx(n) = vx(ii)
   vy(n) = vy(ii)
end do
if (j == k) go to 471
if (i == l) j = j + 1
do ii = j,mp1
   k = k + 1
   bx(k) = bx(ii)
   by(k) = by(ii)
end do
return
470 n = mp1
471 k = mp1
return
!                     Case when ymin = Ymax
500 call rrsort(x, y, m)
do i = 1,m
   bx(i) = x(i)
   by(i) = y(i)
end do
k = mp1
bx(k) = bx(1)
by(k) = by(1)
n = 3
vx(1) = x(1)
vx(2) = x(m)
vx(3) = x(1)
vy(1) = y(1)
vy(2) = y(m)
vy(3) = y(1)
end subroutine hull

pure real function parea(x, y, nb)
implicit none
integer, intent(in) :: nb
real, intent(in) :: x(nb), y(nb)
integer :: i, n, nm1, nswc_ai_i4
real :: a
!*****************************************************************
!   Given a sequence of nb points (x(i),y(i)). parea computes
! the area bounded by the closed polygonal curve which passes
! through the points in the order that they are indexed. The
! final point of the curve is assumed to be the first point
! given. Therefore, it need not be listed at the end of x and
! y. the curve is not required to be simple.
!*****************************************************************
n = nb
if (x(1) == x(n) .and. y(1) == y(n)) n = n - 1
nswc_ai_i4 = n - 3
if (nswc_ai_i4 < 0) go to 10
if (nswc_ai_i4 == 0) go to 20
go to 30
10 parea = 0.0
return
20 parea = 0.5*((x(2) - x(1))*(y(3) - y(1)) &
   & - (x(3) - x(1))*(y(2) - y(1)))
return
30 nm1 = n - 1
a = x(1)*(y(2) - y(n)) + x(n)*(y(1) - y(nm1))
do i = 2, nm1
   a = a + x(i)*(y(i + 1) - y(i - 1))
end do
parea = 0.5*a
end function parea

pure subroutine hc(ind, m, n, pr, ar, nb, s, iwk, num)
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: m, n
integer, intent(inout) :: nb
integer, intent(in) :: num
integer, intent(in) :: pr(*)
integer, intent(inout) :: ar(m), s(n), iwk(num)
integer :: i, ii, np1, s0, pc, ac, vr, vc, p, subr, rbus, tor
interface
   pure subroutine hc1(ind,m,n,pr,ar,nb,s,np1,pc,ac,vr,vc,p, &
      & subr,rbus,tor,jr,k,ind0)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: n
      integer, intent(in) :: m
      integer, intent(inout) :: ind
      integer, intent(in) :: pr(np1)
      integer, intent(inout) :: ar(m)
      integer, intent(inout) :: nb
      integer, intent(inout) :: s(n)
      integer, intent(inout) :: pc(np1)
      integer, intent(inout) :: ac(m)
      integer, intent(inout) :: vr(n)
      integer, intent(inout) :: vc(n)
      integer, intent(inout) :: p(n)
      integer, intent(inout) :: subr(n)
      integer, intent(inout) :: rbus(n)
      integer, intent(inout) :: tor(n)
      integer, intent(inout) :: jr
      integer, intent(inout) :: k
      integer, intent(inout) :: ind0
   end subroutine hc1
end interface
! Subroutine to find one or more hamiltonian circuits in A
! directed graph of  n  vertices ( n .GT. 1 ) represented
! by the integers  1, 2, ..., n  and  m  arcs.
! Input ...
! ind   = 0  On an initial call to hc.
!       = 1  Obtain another hamiltonian circuit.
!       = 2  More back tracks are being permitted.
!       = 3  Restore the orginal array ar.
! m     = Number of arcs.
! n     = Number of vertices.
! pr(i) = Sum of the out-degrees of vertices  1, ..., i-1
!         (pr(1) = 0 ,  pr(n+1) = m).
! ar    = Adjacency list. The elements from  ar(pr(i)+1) to
!         ar(pr(i+1))  are a record containing,in any order,
!         all the vertices  J  such that arc  (i,J)  exists.
!         The graph should not contain arcs starting and
!         ending at the same vertex.
! nb    = Upper bound on the number of back tracks to be
!         performed. (nb = -1 If no limit is to be placed
!         on the number of back tracks taken.)
! num   = Dimension of the work space iwk. It is assumed that
!         num .GE. m + 8*n + 20.
! Output ...
! ind   = 1   A hamiltonian circuit was found. To find another
!             circuit, reset nb and recall the routine.
!             The array ar has been modified. If one does not
!             wish to obtain another circuit, set ind = 3 And
!             recall the routine. This will restore ar.
!       = 2   The maximum number of back tracks were performed.
!             To continue, reset nb and recall the routine.
!             The array ar has been modified. If one does not
!             wish to continue, set ind = 3 And recall the
!             routine. This will restore ar.
!       = 4   No circuits were found. The array  ar  has been
!             restored (see the remark below) and the procedure
!             is finished.
!       = -1  (Input error) ind .LT. 0  or ind .GT. 3 on input.
!       = -2  (Input error) ind was modified. Reset ind to its
!              previous output value and rerun the code.
!       = -3  (Input error) the input setting ind = 3 Can be
!              used only when the previous output value for
!              ind was 1 or 2. If the previous output value
!              for ind was 4, then the array ar has already
!              been restored and there is nothing to be done.
!       = -4  (INPUT ERROR) num .LT. m + 8*n + 20.
!       = -5  (INPUT ERROR) pr(1) .NE. 0  OR  pr(n+1) .NE. m.
!       = -6  (Input error) pr(i) .GT. pr(i+1) for some i.
! nb    = Number of back tracks performed.
! s(i)  = i-TH  vertex in the hamiltonian circuit found.
! Work space ... iwk
! remark. In ar, the order of the arcs in each record may be
! altered by the routine.
!     integer pr(n + 1), ar(m), s(n), iwk(m + 8*n + 20)
np1 = n + 1
if (ind < 0 .or. ind > 3) go to 20
if (num < m + 8*n + 20) go to 30
if (pr(1) /= 0 .or. pr(np1) /= m) go to 40
s0 = 20
pc = s0 + n
ac = pc + np1
vr = ac + m
vc = vr + n
p = vc + n
subr = p + n
rbus = subr + n
tor = rbus + n
call hc1(ind, m, n, pr, ar, nb, iwk(s0), np1, iwk(pc), &
   & iwk(ac), iwk(vr), iwk(vc), iwk(p), iwk(subr), &
   & iwk(rbus), iwk(tor), iwk(1), iwk(2), iwk(3))
if (ind /= 1) return
ii = s0
do i = 1,n
   s(i) = iwk(ii)
   ii = ii + 1
end do
return
!                   Error return
20 ind = -1
return
30 ind = -4
return
40 ind = -5
end subroutine hc

pure subroutine hc1(ind, m, n, pr, ar, nb, s, np1, pc, ac, vr, &
   & vc, p, subr, rbus, tor, jr, k, ind0)
implicit none
integer, intent(inout) :: ind, ind0, jr, k
integer, intent(in) :: m, n
integer, intent(inout) :: nb
integer, intent(in) :: np1
integer, intent(in) :: pr(np1)
integer, intent(inout) :: pc(np1), ar(m), ac(m), s(n), vr(n), &
   & vc(n), p(n), subr(n), rbus(n), tor(n)
integer :: i, iend, iff, ipi, it1, it2, j, j1, j2, ja, jj, jl, jsubr, k1, k2, l, l1, l2, ll, ll1, ll2, maxe, minu, mp1, nbo, np, &
   & nswc_ai_i4
real :: dens, score
interface
   pure subroutine bupd(a1,a2,p1,p2,v1,v2,ii,k1,k2,n,m,np1)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(inout) :: a1(m)
      integer, intent(inout) :: a2(m)
      integer, intent(in) :: p1(np1)
      integer, intent(in) :: p2(np1)
      integer, intent(inout) :: v1(n)
      integer, intent(inout) :: v2(n)
      integer, intent(in) :: ii
      integer, intent(in) :: k1
      integer, intent(in) :: k2
   end subroutine bupd
   pure subroutine fupd(a1,a2,p1,p2,v1,v2,i1,k1,n,m,np1)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(inout) :: a1(m)
      integer, intent(inout) :: a2(m)
      integer, intent(in) :: p1(np1)
      integer, intent(in) :: p2(np1)
      integer, intent(inout) :: v1(n)
      integer, intent(inout) :: v2(n)
      integer, intent(in) :: i1
      integer, intent(in) :: k1
   end subroutine fupd
   pure subroutine ipath(i,j,subr,rbus,ar,pr,s,n,np,i1,i2,k,jr, &
      & m,np1)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: i
      integer, intent(in) :: j
      integer, intent(in) :: subr(n)
      integer, intent(inout) :: rbus(n)
      integer, intent(in) :: ar(m)
      integer, intent(in) :: pr(np1)
      integer, intent(inout) :: s(n)
      integer, intent(out) :: np
      integer, intent(out) :: i1
      integer, intent(inout) :: i2
      integer, intent(in) :: k
      integer, intent(in) :: jr
   end subroutine ipath
   pure subroutine iupd(ia,ib,l,a1,a2,p1,p2,v1,v2,k1,n,m,np1)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(inout) :: ia
      integer, intent(in) :: ib
      integer, intent(in) :: l
      integer, intent(inout) :: a1(m)
      integer, intent(inout) :: a2(m)
      integer, intent(in) :: p1(np1)
      integer, intent(in) :: p2(np1)
      integer, intent(inout) :: v1(n)
      integer, intent(inout) :: v2(n)
      integer, intent(in) :: k1
   end subroutine iupd
   pure subroutine rarc(ia,ib,ar,ac,pr,pc,vr,vc,k1,jj,ll,n,m, &
      & np1)
      implicit none
      integer, intent(in) :: np1
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: ia
      integer, intent(in) :: ib
      integer, intent(inout) :: ar(m)
      integer, intent(inout) :: ac(m)
      integer, intent(in) :: pr(np1)
      integer, intent(in) :: pc(np1)
      integer, intent(inout) :: vr(n)
      integer, intent(inout) :: vc(n)
      integer, intent(in) :: k1
      integer, intent(inout) :: jj
      integer, intent(inout) :: ll
   end subroutine rarc
end interface
! Meaning of the work arrays ...
! pc(i)   = Sum of the in-degrees of vertices  1, ..., i-1
!           ( pc(1) = 0 ).
! ac      = Adjacency list (backward). The elements from
!           ac(pc(i)+1)  to  ac(pc(i+1))  contain, in any
!           order, all the vertices  j  such that arc  (j,i)
!           exists.
! When an arc is removed from the graph at the  k-TH  level
! of the branch-decision tree, the corresponding elements
! ar(Q)  and  ac(T)  are set to  - (k*(n+1) + ar(Q))  and
! to  - (k*(n+1) + ac(T)) , respectively.
! vr(i)   = Current out-degree of vertex i .
! VC(i)   = Current in-degree of vertex i .
! SUBR(i) = - (k*(n+1) + j)  if arc  (i,j)  was implied at
!           the  k-TH  level of the branch-decision tree.
!         = 0  OTHERWISE.
! RBUS(i) = - j  if arc  (j,i)  is currently implied.
!         = 0  OTHERWISE.
! Tor(k)  = Q*(m+1) + T  if the arc going from  s(k)  to the
!           root, corresponding to  ar(Q)  and to  ac(T),
!           was removed from the graph at the  k-TH  level
!           of the branch-decision tree.
!         = 0  OTHERWISE.
! P(i)    = Pointer for the forward step. The next arc
!           starting from  i  to be considered in the
!           branch-decision tree is  (i,ar(pr(i)+P(i)).
! Meaning of the main simple variables ...
! jr   = Root. The hamiltonian circuits are determined as
!        paths starting and ending at  jr .
! k    = Current level of the branch-decision tree.
! ind0 = Value of ind when hc was previously called and
!        there were no input errors.
nbo = nb
nb = 0
mp1 = m + 1
if (ind /= 0) go to 500
! s T E P   0   (INITIALIZE).
do i = 1,n
   vc(i) = 0
   subr(i) = 0
   rbus(i) = 0
   p(i) = 1
end do
do i = 1,n
   j1 = pr(i) + 1
   j2 = pr(i + 1)
   vr(i) = j2 - j1 + 1
   if (vr(i) == 0) go to 440
   if (vr(i) < 0) go to 620
   do j = j1,j2
      ja = ar(j)
      vc(ja) = vc(ja) + 1
   end do
end do
pc(1) = 0
do i = 1,n
   if (vc(i) == 0) go to 440
   pc(i + 1) = pc(i) + vc(i)
   vc(i) = 0
end do
do i = 1,n
   j1 = pr(i) + 1
   j2 = pr(i + 1)
   do j = j1,j2
      jj = ar(j)
      vc(jj) = vc(jj) + 1
      ja = pc(jj) + vc(jj)
      ac(ja) = i
   end do
end do
! Select as root  jr  the vertex  i  with maximum  VC(i)
! (break ties by choosing  i  with minimum  vr(i) ).
maxe = vc(1)
minu = vr(1)
jr = 1
do i = 2,n
   nswc_ai_i4 = vc(i) - maxe
   if (nswc_ai_i4 < 0) go to 100
   if (nswc_ai_i4 == 0) go to 70
   go to 80
70 if (vr(i) >= minu) go to 100
   go to 90
80 maxe = vc(i)
90 minu = vr(i)
   jr = i
100 continue
end do
k1 = -np1
k = 1
s(1) = jr
! s T E P   1   (SEARCH FOR IMPLIED ARCS).
110 do j = 1,n
   if (vr(j) == 1) go to 130
   if (vc(j) == 1) go to 170
end do
! No further arc can be implied.
go to 220
! Arc  (j,jl)  is implied because  vr(j) = 1 .
130 l1 = pr(j) + 1
l2 = pr(j + 1)
do l = l1,l2
   if (ar(l) > 0) exit
end do
jl = ar(l)
! Find the starting vertex  it1  and the ending vertex  it2
! of the largest path of implied arcs containing  (j,jl) .
call ipath(j, jl, subr, rbus, ar, pr, s, n, np, it1, it2, k, jr, &
   & m, np1)
if (np == 0) go to 160
if (np == (-1)) go to 340
! Subroutine ipath found a hamiltonian circuit.
k = k + 1
go to 320
160 subr(j) = k1 - jl
rbus(jl) = j
! Remove from the graph all arcs terminating at  jl .
call iupd(j, jl, l, ac, ar, pc, pr, vc, vr, k1, n, m, np1)
if (j == 0) go to 340
go to 210
! Arc  (jl,j)  is implied because  VC(j) = 1 .
170 l1 = pc(j) + 1
l2 = pc(j + 1)
do l = l1,l2
   if (ac(l) > 0) exit
end do
jl = ac(l)
! Find the starting vertex  it1  and the ending vertex  it2
! of the largest path of implied arcs containing  (jl,j) .
call ipath(jl, j, subr, rbus, ar, pr, s, n, np, it1, it2, k, jr, &
   & m, np1)
if (np == 0) go to 200
if (np == (-1)) go to 340
! Subroutine ipath found a hamiltonian circuit.
i = s(k)
k = k + 1
go to 320
200 subr(jl) = k1 - j
rbus(j) = jl
! Remove from the graph all arcs emanating from  jl .
call iupd(j, jl, l, ar, ac, pr, pc, vr, vc, k1, n, m, np1)
if (j == 0) go to 340
! If arc  (it2,it1)  is in the graph, remove it.
210 call rarc(it2, it1, ar, ac, pr, pc, vr, vc, k1, jj, ll, n, m, np1)
if (jj == (-1)) go to 340
go to 110
! s T E P   2   (ADD IMPLIED ARCS TO s).
220 i = s(k)
if (subr(i) == 0) go to 230
jsubr = -subr(i) + (subr(i)/np1)*np1
if (jsubr == jr) go to 340
k = k + 1
s(k) = jsubr
if (k /= n) go to 220
if (subr(jsubr) < 0) go to 320
go to 340
! s T E P   3   (BRANCH).
230 l1 = pr(i) + p(i)
l2 = pr(i + 1)
if (l1 > l2) go to 340
! Find the next arc  (i,jl)  to be added to  s .
dens = n**3
j1 = 0
j2 = 0
do j = l1,l2
   jl = ar(j)
   if (jl < 0) go to 310
   if (vr(jl) > 0) go to 260
   if (subr(jl) == 0) go to 310
   if (jl == jr) go to 310
   iend = jl
240 iend = -subr(iend) + (subr(iend)/np1)*np1
   if (subr(iend) /= 0) go to 240
   if (vc(jl) < vr(iend)) go to 250
   score = vr(iend)*n + vc(jl)
   go to 280
250 score = vc(jl)*n + vr(iend)
   go to 280
260 if (vc(jl) < vr(jl)) go to 270
   score = vr(jl)*n + vc(jl)
   go to 280
270 score = vc(jl)*n + vr(jl)
280 if (dens <= score) go to 290
   dens = score
   ipi = j
290 if (j1 == 0) go to 300
   if (j2 == 0) j2 = j
   go to 310
300 j1 = j
310 continue
end do
if (j1 == 0) go to 340
jl = ar(ipi)
ar(ipi) = ar(j1)
ar(j1) = jl
if (j2 == 0) j2 = pr(i + 1) + 1
p(i) = j2 - pr(i)
k = k + 1
s(k) = jl
k1 = -k*np1
! Remove from the graph all arcs emanating from  i .
call fupd(ar, ac, pr, pc, vr, vc, i, k1, n, m, np1)
! Remove from the graph all arcs terminating at jl .
call fupd(ac, ar, pc, pr, vc, vr, jl, k1, n, m, np1)
tor(k) = 0
! If arc  (jl,jr)  is in the graph, remove it.
call rarc(jl, jr, ar, ac, pr, pc, vr, vc, k1, jj, ll, n, m, np1)
if (jj == 0) go to 110
if (jj == (-1)) go to 340
tor(k) = jj*mp1 + ll
go to 110
! s T E P   4   (HAMILTONIAN CIRCUIT FOUND).
320 ind = 1
ind0 = 1
k = k - 1
return
! s T E P   5   (BACKTRACK).
340 if (k <= 1) go to 430
ja = s(k)
p(ja) = 1
ja = s(k - 1)
if (subr(ja) == 0) go to 350
! Backtracking for an implied arc.
k = k - 1
go to 340
350 if (nb == nbo) go to 450
nb = nb + 1
k1 = -k*np1
k2 = -(k + 1)*np1
i = s(k - 1)
! Backtracking for the arcs implied at level  k .
iff = 0
do j = 1,n
   if (subr(j) > k1) go to 360
   if (subr(j) < k2) go to 360
   ja = k1 - subr(j)
   rbus(ja) = 0
   subr(j) = 0
   iff = 1
360 continue
end do
if (iff == 1) go to 370
! No arc was implied at level  k .
call bupd(ar, ac, pr, pc, vr, vc, i, k1, k2, n, m, np1)
call bupd(ac, ar, pc, pr, vc, vr, s(k), k1, k2, n, m, np1)
if (tor(k) == 0) go to 420
j1 = tor(k)/mp1
j2 = tor(k) - j1*mp1
ar(j1) = jr
ja = s(k)
vr(ja) = vr(ja) + 1
ac(j2) = s(k)
vc(jr) = vc(jr) + 1
go to 420
! At least one arc was implied at level  k .
370 do j = 1,n
   l1 = pr(j) + 1
   l2 = pr(j + 1)
   do l = l1,l2
      jl = ar(l)
      if (jl > k1) go to 400
      if (jl < k2) go to 400
      jl = k1 - jl
      ar(l) = jl
      vr(j) = vr(j) + 1
      ll1 = pc(jl) + 1
      ll2 = pc(jl + 1)
      do ll = ll1,ll2
         if (k1 - ac(ll) == j) exit
      end do
      ac(ll) = j
      vc(jl) = vc(jl) + 1
400   continue
   end do
end do
420 k = k - 1
go to 230
! Restore the original vector  ar
430 do j = 1,m
   if (ar(j) > 0) go to 431
   ar(j) = -ar(j) + (ar(j)/np1)*np1
431 continue
end do
! The algorithm is finished
440 ind = 4
ind0 = 4
return
! The maximum number of back tracks were performed
450 ind = 2
ind0 = 2
return
! Check ind when ind = 1, 2, or 3
500 if (ind /= 3) go to 510
if (ind0 == 1 .or. ind0 == 2) go to 430
go to 610
510 if (ind /= ind0) go to 600
if (ind == 1) go to 340
go to 350
! Error return
600 ind = -2
return
610 ind = -3
return
620 ind = -6
end subroutine hc1

pure subroutine ipath(i, j, subr, rbus, ar, pr, s, n, np, i1, i2, k, &
   & jr, m, np1)
implicit none
integer, intent(in) :: i
integer, intent(out) :: i1
integer, intent(inout) :: i2
integer, intent(in) :: j, jr, k, m, n
integer, intent(out) :: np
integer, intent(in) :: np1
integer, intent(in) :: subr(n)
integer, intent(inout) :: rbus(n)
integer, intent(in) :: ar(m), pr(np1)
integer, intent(inout) :: s(n)
integer :: ja, k1, l, l1, l2
! Subroutine to find the starting vertex  i1  and the ending
! vertex  i2  of the largest path of implied arcs containing
! ARC  (i,j) .
! Meaning of the output parameter  np ...
! np =  0  If the path contains  l .LT. n  vertices.
!    =  1  If the path contains  n  vertices and arc (i2,i1)
!          exists (the hamiltonian circuit is stored in  s )
!    = -1  If the path contains  n  vertices but arc (i2,i1)
!          does not exist.
np = 0
l = 1
i1 = i
10 if (rbus(i1) == 0) go to 20
i1 = rbus(i1)
l = l + 1
go to 10
20 i2 = j
l = l + 1
30 if (subr(i2) == 0) go to 40
i2 = -subr(i2) + (subr(i2)/np1)*np1
l = l + 1
go to 30
40 continue
if (l < n) return
! The path contains  n  vertices.
k1 = -k*np1
l1 = pr(i2) + 1
l2 = pr(i2 + 1)
do l = l1,l2
   if (ar(l) < 0) go to 50
   if (ar(l) == i1) go to 70
   go to 60
50 if (k1 - ar(l) == i1) go to 70
60 continue
end do
! No hamiltonian circuit can be determined.
np = -1
return
! A hamiltonian circuit exists. Store it in  s .
70 np = 1
rbus(j) = i
rbus(i1) = i2
s(n) = rbus(jr)
l = n - 1
80 if (l == k) go to 90
ja = s(l + 1)
s(l) = rbus(ja)
l = l - 1
go to 80
90 rbus(i1) = 0
rbus(j) = 0
end subroutine ipath

pure subroutine fupd(a1, a2, p1, p2, v1, v2, i1, k1, n, m, np1)
implicit none
integer, intent(in) :: i1, k1, m, n, np1
integer, intent(inout) :: a1(m), a2(m)
integer, intent(in) :: p1(np1), p2(np1)
integer, intent(inout) :: v1(n), v2(n)
integer :: ia, j, j1, j2, l, l1, l2
! Forward step updating
j1 = p1(i1) + 1
j2 = p1(i1 + 1)
do j = j1,j2
   if (a1(j) < 0) go to 30
   ia = a1(j)
   l1 = p2(ia) + 1
   l2 = p2(ia + 1)
   do l = l1,l2
      if (a2(l) == i1) exit
   end do
   v2(ia) = v2(ia) - 1
   a2(l) = k1 - a2(l)
   a1(j) = k1 - ia
30 continue
end do
v1(i1) = 0
end subroutine fupd

pure subroutine bupd(a1, a2, p1, p2, v1, v2, ii, k1, k2, n, m, np1)
implicit none
integer, intent(in) :: ii, k1, k2, m, n, np1
integer, intent(inout) :: a1(m), a2(m)
integer, intent(in) :: p1(np1), p2(np1)
integer, intent(inout) :: v1(n), v2(n)
integer :: ia, l, l1, l2, ll, ll1, ll2
! Backtracking step updating
l1 = p1(ii) + 1
l2 = p1(ii + 1)
do l = l1,l2
   if (a1(l) > k1) go to 30
   if (a1(l) < k2) go to 30
   ia = k1 - a1(l)
   a1(l) = ia
   v1(ii) = v1(ii) + 1
   ll1 = p2(ia) + 1
   ll2 = p2(ia + 1)
   do ll = ll1,ll2
      if (k1 - a2(ll) == ii) exit
   end do
   a2(ll) = ii
   v2(ia) = v2(ia) + 1
30 continue
end do
end subroutine bupd

pure subroutine iupd(ia, ib, l, a1, a2, p1, p2, v1, v2, k1, n, m, np1)
implicit none
integer, intent(inout) :: ia
integer, intent(in) :: ib, k1, l, m, n, np1
integer, intent(inout) :: a1(m), a2(m)
integer, intent(in) :: p1(np1), p2(np1)
integer, intent(inout) :: v1(n), v2(n)
integer :: iarc, j1, j2, jj, m1, m2, mm
! Updating for implied arc
m1 = p1(ib) + 1
m2 = p1(ib + 1)
do mm = m1,m2
   iarc = a1(mm)
   if (iarc < 0) go to 40
   if (v2(iarc) /= 1) go to 10
   if (iarc /= ia) go to 50
   jj = l
   go to 30
10 j1 = p2(iarc) + 1
   j2 = p2(iarc + 1)
   do jj = j1,j2
      if (a2(jj) == ib) exit
   end do
30 a2(jj) = k1 - a2(jj)
   v2(iarc) = v2(iarc) - 1
   a1(mm) = k1 - iarc
   v1(ib) = v1(ib) - 1
40 continue
end do
return
50 ia = 0
end subroutine iupd

pure subroutine rarc(ia, ib, ar, ac, pr, pc, vr, vc, k1, jj, ll, n, m, &
   & np1)
implicit none
integer, intent(in) :: ia, ib
integer, intent(inout) :: jj
integer, intent(in) :: k1
integer, intent(inout) :: ll
integer, intent(in) :: m, n, np1
integer, intent(inout) :: ar(m), ac(m)
integer, intent(in) :: pr(np1), pc(np1)
integer, intent(inout) :: vr(n), vc(n)
integer :: j1, j2, l1, l2
! Subroutine to remove arc  (ia,ib)  from the graph.
! Meaning of the output parameters  jj  and  ll ...
! jj =  Location of the element of  ar  corresponding to the
!       removed arc.
!    =  0  If arc  (ia,ib)  is not in the graph.
!    = -1  If, after the removal of arc  (ia,ib) , the graph
!          would admit no hamiltonian circuit.
! ll =  Location of the element of  ac  corresponding to the
!       REMOVED ARC (DEFINED ONLY IF  jj .GT. 0 ).
j1 = pr(ia) + 1
j2 = pr(ia + 1)
do jj = j1,j2
   if (ar(jj) < 0) go to 20
   if (ar(jj) /= ib) go to 20
   l1 = pc(ib) + 1
   l2 = pc(ib + 1)
   do ll = l1,l2
      if (ac(ll) == ia) go to 30
   end do
20 continue
end do
! Arc  (ia,ib)  is not in the graph.
jj = 0
return
30 if (vr(ia) == 1) go to 40
if (vc(ib) == 1) go to 40
ar(jj) = k1 - ib
vr(ia) = vr(ia) - 1
ac(ll) = k1 - ia
vc(ib) = vc(ib) - 1
return
! Arc  (ia,ib)  cannot be removed from the graph.
40 jj = -1
end subroutine rarc

pure elemental subroutine cerf(mo, z, w)
implicit none
integer, intent(in) :: mo
complex, intent(in) :: z
complex, intent(inout) :: w
integer :: i
real :: c2, dm, pm, qm, r, sn, ss, x, y, ef(2), qf(2), sm(2), sz(2), tm(2), ts(2)
real, parameter :: c = .564189583547756
real, parameter :: cd(18) = [0.00000000000000e00, 2.08605856013476e-2, 8.29806940495687e-2, 1.85421653326079e-1, &
   & 3.27963479382361e-1, 5.12675279912828e-1, 7.45412958045105e-1, 1.03695067418297e00, 1.40378061255437e00, 1.86891662214001e00, &
   & 2.46314830523929e00, 3.22719383737352e00, 4.21534348280013e00, 5.50178873151549e00, 7.19258966683102e00, 9.45170208076408e00, &
   & 1.25710718314784e+1, 1.72483537216334e+1]
real, parameter :: ce(18) = [8.15723083324096e-2, 1.59285285253437e-1, 1.48581625614499e-1, 1.33219670836245e-1, &
   & 1.15690392878957e-1, 9.78580959447535e-2, 8.05908834297624e-2, 6.40204538609872e-2, 4.81445242767885e-2, 3.33540658473295e-2, &
   & 2.05548099470193e-2, 1.07847403887506e-2, 4.55634892214219e-3, 1.43984458138925e-3, 3.07056139834171e-4, 3.78156541168541e-5, &
   & 2.05173509616121e-6, 2.63564823682747e-8]
!-----------------------------------------------------------------------
!               Computation of the complex error function
!                           ----------------
!                        w = erf(z)   IF mo = 0
!                        w = erfc(z)  otherwise
!-----------------------------------------------------------------------
!------------------------
!     c = 1/sqrt(pi)
!------------------------
!------------------------
!------------------------
x = real(z)
y = aimag(z)
sn = 1.0
if (x >= 0.0) go to 10
x = -x
y = -y
sn = -1.0
10 r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.0*x*y
if (r <= 1.0) go to 20
if (r >= 38.0) go to 60
if (sz(1) + 0.064*sz(2)*sz(2) > 0.0) go to 50
!                       Taylor series
20 c2 = c + c
tm(1) = c2*x
tm(2) = c2*y
sm(1) = tm(1)
sm(2) = tm(2)
pm = 0.0
30 pm = pm + 1.0
dm = 2.0*pm + 1.0
ts(1) = tm(1)*sz(1) - tm(2)*sz(2)
ts(2) = tm(1)*sz(2) + tm(2)*sz(1)
tm(1) = -ts(1)/pm
tm(2) = -ts(2)/pm
ts(1) = tm(1)/dm
ts(2) = tm(2)/dm
if (abs(sm(1)) + abs(ts(1)) /= abs(sm(1))) go to 31
if (abs(sm(2)) + abs(ts(2)) == abs(sm(2))) go to 40
31 sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
go to 30
!                       Termination
40 if (mo /= 0) go to 41
w = cmplx(sn*sm(1), sn*sm(2))
return
41 if (sn < 0.0) go to 42
sm(1) = 0.5 + (0.5 - sm(1))
sm(2) = -sm(2)
w = cmplx(sm(1), sm(2))
return
42 w = cmplx(1.0 + sm(1), sm(2))
return
!              Rational function APPROXIMATION
50 sm(1) = 0.0
sm(2) = 0.0
qm = c*exp(-sz(1))
ts(1) = qm*cos(-sz(2))
ts(2) = qm*sin(-sz(2))
qf(1) = ts(1)*x - ts(2)*y
qf(2) = ts(1)*y + ts(2)*x
do i = 1,18
   ts(1) = sz(1) + cd(i)
   ts(2) = sz(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ef(1) = qf(1)*sm(1) - qf(2)*sm(2)
ef(2) = qf(1)*sm(2) + qf(2)*sm(1)
go to 100
!                   Asymptotic expansion
60 qf(1) = sz(1)/(r*r)
qf(2) = -sz(2)/(r*r)
qm = c*exp(-sz(1))
ts(1) = qm*cos(-sz(2))
ts(2) = qm*sin(-sz(2))
tm(1) = (ts(1)*x + ts(2)*y)/r
tm(2) = -(ts(1)*y - ts(2)*x)/r
sm(1) = tm(1)
sm(2) = tm(2)
pm = -0.5
70 pm = pm + 1.0
ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
tm(1) = -pm*ts(1)
tm(2) = -pm*ts(2)
if (abs(sm(1)) + abs(tm(1)) /= abs(sm(1))) go to 71
if (abs(sm(2)) + abs(tm(2)) == abs(sm(2))) go to 80
71 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (pm < 25.5) go to 70
80 if (x >= 0.01) go to 81
sn = -sn
go to 40
81 ef(1) = sm(1)
ef(2) = sm(2)
!                       Termination
100 if (mo == 0) go to 101
w = cmplx(ef(1), ef(2))
if (sn == 1.0) return
w = cmplx(2.0 - ef(1), -ef(2))
return
101 ef(1) = sn*(1.0 - ef(1))
ef(2) = -sn*ef(2)
w = cmplx(ef(1),ef(2))
end subroutine cerf

pure elemental subroutine cerfc(mo, z, w)
implicit none
integer, intent(in) :: mo
complex, intent(in) :: z
complex, intent(inout) :: w
integer :: i
real :: c2, dm, pm, qm, r, sn, ss, x, y, qf(2), sm(2), sz(2), tm(2), ts(2)
real, parameter :: c = .564189583547756
real, parameter :: cd(18) = [0.00000000000000e00, 2.08605856013476e-2, 8.29806940495687e-2, 1.85421653326079e-1, &
   & 3.27963479382361e-1, 5.12675279912828e-1, 7.45412958045105e-1, 1.03695067418297e00, 1.40378061255437e00, 1.86891662214001e00, &
   & 2.46314830523929e00, 3.22719383737352e00, 4.21534348280013e00, 5.50178873151549e00, 7.19258966683102e00, 9.45170208076408e00, &
   & 1.25710718314784e+1, 1.72483537216334e+1]
real, parameter :: ce(18) = [8.15723083324096e-2, 1.59285285253437e-1, 1.48581625614499e-1, 1.33219670836245e-1, &
   & 1.15690392878957e-1, 9.78580959447535e-2, 8.05908834297624e-2, 6.40204538609872e-2, 4.81445242767885e-2, 3.33540658473295e-2, &
   & 2.05548099470193e-2, 1.07847403887506e-2, 4.55634892214219e-3, 1.43984458138925e-3, 3.07056139834171e-4, 3.78156541168541e-5, &
   & 2.05173509616121e-6, 2.63564823682747e-8]
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
end interface
!-----------------------------------------------------------------------
!              Computation of the complex coerror function
!                           ----------------
!           w = erfc(z)           IF mo = 0 OR real(z) .LT. 0
!           w = exp(x*x)*erfc(z)  otherwise
!-----------------------------------------------------------------------
!------------------------
!     c = 1/sqrt(pi)
!------------------------
!------------------------
!------------------------
x = real(z)
y = aimag(z)
sn = 1.0
if (x >= 0.0) go to 10
x = -x
y = -y
sn = -1.0
10 if (mo /= 0  .and.  sn == 1.0  .and. &
   & max(x, abs(y)) >= 100.0) go to 60
r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.0*x*y
if (r <= 1.0) go to 20
if (r >= 38.0) go to 60
if (sz(1) + 0.064*sz(2)*sz(2) > 0.0) go to 50
!                       Taylor series
20 c2 = c + c
tm(1) = c2*x
tm(2) = c2*y
sm(1) = tm(1)
sm(2) = tm(2)
pm = 0.0
30 pm = pm + 1.0
dm = 2.0*pm + 1.0
ts(1) = tm(1)*sz(1) - tm(2)*sz(2)
ts(2) = tm(1)*sz(2) + tm(2)*sz(1)
tm(1) = -ts(1)/pm
tm(2) = -ts(2)/pm
ts(1) = tm(1)/dm
ts(2) = tm(2)/dm
if (abs(sm(1)) + abs(ts(1)) /= abs(sm(1))) go to 31
if (abs(sm(2)) + abs(ts(2)) == abs(sm(2))) go to 40
31 sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
go to 30
!                       Termination
40 if (sn == 1.0) go to 41
w = cmplx(1.0 + sm(1), sm(2))
return
41 sm(1) = 0.5 + (0.5 - sm(1))
sm(2) = -sm(2)
if (mo == 0) go to 110
qm = exp(sz(1))
qf(1) = qm*cos(sz(2))
qf(2) = qm*sin(sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
w = cmplx(ts(1),ts(2))
return
!              Rational function APPROXIMATION
50 sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = sz(1) + cd(i)
   ts(2) = sz(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ts(1) = x*sm(1) - y*sm(2)
ts(2) = x*sm(2) + y*sm(1)
sm(1) = c*ts(1)
sm(2) = c*ts(2)
go to 100
!                   Asymptotic expansion
60 call crec(x, y, tm(1), tm(2))
sm(1) = tm(1)
sm(2) = tm(2)
qf(1) = tm(1)*tm(1) - tm(2)*tm(2)
qf(2) = 2.0*tm(1)*tm(2)
pm = -0.5
70 pm = pm + 1.0
ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
tm(1) = -pm*ts(1)
tm(2) = -pm*ts(2)
if (abs(sm(1)) + abs(tm(1)) /= abs(sm(1))) go to 71
if (abs(sm(2)) + abs(tm(2)) == abs(sm(2))) go to 80
71 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (pm < 25.5) go to 70
80 sm(1) = c*sm(1)
sm(2) = c*sm(2)
if (x < 0.01) go to 200
!                       Termination
100 if (mo /= 0 .and. sn == 1.0) go to 110
qm = exp(-sz(1))
qf(1) = qm*cos(-sz(2))
qf(2) = qm*sin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
if (sn == 1.0) go to 110
w = cmplx(2.0 - sm(1), -sm(2))
return
110 w = cmplx(sm(1), sm(2))
return
!               Modified asymptotic expansion
200 if (mo /= 0 .and. sn == 1.0) go to 210
qm = exp(-sz(1))
qf(1) = qm*cos(-sz(2))
qf(2) = qm*sin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = 1.0 + sn*ts(1)
sm(2) = sn*ts(2)
w = cmplx(sm(1),sm(2))
return
210 if (abs(y) >= 100.0) go to 110
if (sz(1) <= exparg(1)) go to 110
qm = exp(sz(1))
sm(1) = qm*cos(sz(2)) + sm(1)
sm(2) = qm*sin(sz(2)) + sm(2)
w = cmplx(sm(1),sm(2))
end subroutine cerfc

pure elemental real function erf(x)
implicit none
real, intent(in) :: x
real :: ax, bot, t, top, x2
real, parameter :: c = .564189583547756
real, parameter :: a(5) = [.771058495001320e-04, -.133733772997339e-02, .323076579225834e-01, .479137145607681e-01, &
   & .128379167095513e+00]
real, parameter :: b(3) = [.301048631703895e-02, .538971687740286e-01, .375795757275549e+00]
real, parameter :: p(8) = [-1.36864857382717e-07, 5.64195517478974e-01, 7.21175825088309e+00, 4.31622272220567e+01, &
   & 1.52989285046940e+02, 3.39320816734344e+02, 4.51918953711873e+02, 3.00459261020162e+02]
real, parameter :: q(8) = [1.00000000000000e+00, 1.27827273196294e+01, 7.70001529352295e+01, 2.77585444743988e+02, &
   & 6.38980264465631e+02, 9.31354094850610e+02, 7.90950925327898e+02, 3.00459260956983e+02]
real, parameter :: r(5) = [2.10144126479064e+00, 2.62370141675169e+01, 2.13688200555087e+01, 4.65807828718470e+00, &
   & 2.82094791773523e-01]
real, parameter :: s(4) = [9.41537750555460e+01, 1.87114811799590e+02, 9.90191814623914e+01, 1.80124575948747e+01]
!-----------------------------------------------------------------------
!             Evaluation of the real error function
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
ax = abs(x)
if (ax > 0.5) go to 10
t = x*x
top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + 1.0
bot = ((b(1)*t + b(2))*t + b(3))*t + 1.0
erf = x*(top/bot)
return
10 if (ax > 4.0) go to 20
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
   & + p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
   & + q(6))*ax + q(7))*ax + q(8)
erf = 0.5 + (0.5 - exp(-x*x)*top/bot)
if (x < 0.0) erf = -erf
return
20 if (ax >= 5.8) go to 30
x2 = x*x
t = 1.0/x2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erf = (c - top/(x2*bot)) / ax
erf = 0.5 + (0.5 - exp(-x2)*erf)
if (x < 0.0) erf = -erf
return
30 erf = sign(1.0,x)
end function erf

pure elemental real function erfc(x)
implicit none
real, intent(in) :: x
real :: ax, bot, e, t, top
double precision :: w
real, parameter :: c = .564189583547756
real, parameter :: a(5) = [.771058495001320e-04, -.133733772997339e-02, .323076579225834e-01, .479137145607681e-01, &
   & .128379167095513e+00]
real, parameter :: b(3) = [.301048631703895e-02, .538971687740286e-01, .375795757275549e+00]
real, parameter :: p(8) = [-1.36864857382717e-07, 5.64195517478974e-01, 7.21175825088309e+00, 4.31622272220567e+01, &
   & 1.52989285046940e+02, 3.39320816734344e+02, 4.51918953711873e+02, 3.00459261020162e+02]
real, parameter :: q(8) = [1.00000000000000e+00, 1.27827273196294e+01, 7.70001529352295e+01, 2.77585444743988e+02, &
   & 6.38980264465631e+02, 9.31354094850610e+02, 7.90950925327898e+02, 3.00459260956983e+02]
real, parameter :: r(5) = [2.10144126479064e+00, 2.62370141675169e+01, 2.13688200555087e+01, 4.65807828718470e+00, &
   & 2.82094791773523e-01]
real, parameter :: s(4) = [9.41537750555460e+01, 1.87114811799590e+02, 9.90191814623914e+01, 1.80124575948747e+01]
interface
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!                     abs(x) .LE. 0.5
ax = abs(x)
if (ax > 0.5) go to 10
t = x*x
top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + 1.0
bot = ((b(1)*t + b(2))*t + b(3))*t + 1.0
erfc = 0.5 + (0.5 - x*(top/bot))
return
!                  0.5 .LT. abs(x) .LE. 4
10 if (ax > 4.0) go to 20
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
   & + p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
   & + q(6))*ax + q(7))*ax + q(8)
erfc = top/bot
go to 30
!                       abs(x) .GT. 4
20 if (x <= -5.6) go to 40
if (x > 100.0) go to 50
t = x*x
if (t > -exparg(1)) go to 50
t = 1.0/t
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erfc = (c - t*top/bot)/ax
!                      Final assembly
30 w = dble(x)*dble(x)
t = w
e = w - dble(t)
erfc = ((0.5 + (0.5 - e)) * exp(-t)) * erfc
if (x < 0.0) erfc = 2.0 - erfc
return
!             Limit value for large negative x
40 erfc = 2.0
return
!             Limit value for large positive x
50 erfc = 0.0
end function erfc

pure elemental real function erfc1(ind, x)
implicit none
integer, intent(in) :: ind
real, intent(in) :: x
real :: ax, bot, e, t, top
double precision :: w
real, parameter :: c = .564189583547756
real, parameter :: a(5) = [.771058495001320e-04, -.133733772997339e-02, .323076579225834e-01, .479137145607681e-01, &
   & .128379167095513e+00]
real, parameter :: b(3) = [.301048631703895e-02, .538971687740286e-01, .375795757275549e+00]
real, parameter :: p(8) = [-1.36864857382717e-07, 5.64195517478974e-01, 7.21175825088309e+00, 4.31622272220567e+01, &
   & 1.52989285046940e+02, 3.39320816734344e+02, 4.51918953711873e+02, 3.00459261020162e+02]
real, parameter :: q(8) = [1.00000000000000e+00, 1.27827273196294e+01, 7.70001529352295e+01, 2.77585444743988e+02, &
   & 6.38980264465631e+02, 9.31354094850610e+02, 7.90950925327898e+02, 3.00459260956983e+02]
real, parameter :: r(5) = [2.10144126479064e+00, 2.62370141675169e+01, 2.13688200555087e+01, 4.65807828718470e+00, &
   & 2.82094791773523e-01]
real, parameter :: s(4) = [9.41537750555460e+01, 1.87114811799590e+02, 9.90191814623914e+01, 1.80124575948747e+01]
interface
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!          erfc1(ind,x) = erfc(x)            if ind = 0
!          erfc1(ind,x) = exp(x*x)*erfc(x)   otherwise
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!                     abs(x) .LE. 0.5
ax = abs(x)
if (ax > 0.5) go to 10
t = x*x
top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + 1.0
bot = ((b(1)*t + b(2))*t + b(3))*t + 1.0
erfc1 = 0.5 + (0.5 - x*(top/bot))
if (ind /= 0) erfc1 = exp(t) * erfc1
return
!                  0.5 .LT. abs(x) .LE. 4
10 if (ax > 4.0) go to 20
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
   & + p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
   & + q(6))*ax + q(7))*ax + q(8)
erfc1 = top/bot
go to 40
!                      abs(x) .GT. 4
20 if (x <= -5.6) go to 50
if (ind /= 0) go to 30
if (x > 100.0) go to 60
if (x*x > -exparg(1)) go to 60
30 t = (1.0/x)**2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erfc1 = (c - t*top/bot)/ax
!                      Final assembly
40 if (ind == 0) go to 41
if (x < 0.0) erfc1 = 2.0*exp(x*x) - erfc1
return
41 w = dble(x)*dble(x)
t = w
e = w - dble(t)
erfc1 = ((0.5 + (0.5 - e)) * exp(-t)) * erfc1
if (x < 0.0) erfc1 = 2.0 - erfc1
return
!             Limit value for large negative x
50 erfc1 = 2.0
if (ind /= 0) erfc1 = 2.0*exp(x*x)
return
!             Limit value for large positive x
!                       when ind = 0
60 erfc1 = 0.0
end function erfc1

pure subroutine dcerf(mo, z, w)
implicit none
integer, intent(in) :: mo
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
double precision :: m, n, n2, n4, np1, c2, d, d2, e, eps, r, sn, tol, x, y, a0(2), an(2), b0(2), bn(2), g0(2), gn(2), h0(2), &
   & hn(2), qf(2), sm(2), sz(2), tm(2), ts(2), w0(2), wn(2)
double precision, parameter :: c = .56418958354775628694807945156077d0
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
   pure elemental subroutine dcrec(x,y,u,v)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision, intent(inout) :: u
      double precision, intent(inout) :: v
   end subroutine dcrec
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure subroutine erfcm2(mo,z,w)
      implicit none
      integer, intent(in) :: mo
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine erfcm2
end interface
!-----------------------------------------------------------------------
!               Computation of the complex error function
!                          -----------------
!                       w = erf(z)    IF mo = 0
!                       w = erfc(z)   otherwise
!-----------------------------------------------------------------------
!------------------------
!------------------------
!     c = 1/sqrt(pi)
!------------------------
!------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.D0 + eps .GT. 1.D0.
eps = dpmpar(1)
!------------------------
x = z(1)
y = z(2)
sn = 1.d0
if (x >= 0.d0) go to 10
x = -x
y = -y
sn = -1.d0
10 r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.d0*x*y
if (r <= 1.d0) go to 20
if (r >= 144.d0) go to 100
if (abs(y) > 31.8d0*x) go to 50
if (abs(y) > 7.0d0*x .and. r < 64.d0) go to 50
if (abs(y) > 3.2d0*x .and. r < 49.d0) go to 50
if (abs(y) > 2.0d0*x .and. r < 36.d0) go to 50
if (abs(y) > 1.2d0*x .and. r < 25.d0) go to 50
if (abs(y) > 0.9d0*x .and. r < 16.d0) go to 50
if (r >= 6.25d0) go to 80
if (abs(y) > 0.6d0*x) go to 50
if (r >= 4.0d0) go to 40
d = x - 2.d0
if (d*d + y*y < 1.d0) go to 40
go to 50
!                          Taylor series
20 c2 = c + c
tm(1) = c2*x
tm(2) = c2*y
sm(1) = tm(1)
sm(2) = tm(2)
tol = 2.d0*eps
m = 0.d0
21 m = m + 1.d0
d = m + m + 1.d0
ts(1) = tm(1)*sz(1) - tm(2)*sz(2)
ts(2) = tm(1)*sz(2) + tm(2)*sz(1)
tm(1) = -ts(1)/m
tm(2) = -ts(2)/m
ts(1) = tm(1)/d
ts(2) = tm(2)/d
sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
if (anorm(ts(1),ts(2)) > tol*anorm(sm(1),sm(2))) go to 21
if (mo /= 0) go to 30
w(1) = sn*sm(1)
w(2) = sn*sm(2)
return
30 if (sn == 1.d0) go to 31
w(1) = 1.d0 + sm(1)
w(2) = sm(2)
return
31 w(1) = 0.5d0 + (0.5d0 - sm(1))
w(2) = -sm(2)
return
!                  Taylor series around Z0 = 2
40 tm(1) = x
tm(2) = y
call erfcm2(0, tm, w)
if (mo /= 0) go to 41
w(1) = sn*(0.5d0 + (0.5d0 - w(1)))
w(2) = - sn*w(2)
return
41 if (sn > 0.d0) return
w(1) = 2.d0 - w(1)
w(2) = - w(2)
return
!            Pade approximation for the Taylor series
!                    for  (exp(z*z)/z)*erf(z)
50 d = 4.d0
if (r > 16.d0) d = 16.d0
if (r > 64.d0) d = 64.d0
d2 = d*d
call dcrec(sz(1), sz(2), w(1), w(2))
a0(1) = 1.d0
a0(2) = 0.d0
an(1) = (w(1) + 4.d0/15.d0)*d
an(2) = w(2)*d
b0(1) = 1.d0
b0(2) = 0.d0
bn(1) = (w(1) - 0.4d0)*d
bn(2) = w(2)*d
call cdivid(an(1), an(2), bn(1), bn(2), wn(1), wn(2))
tol = 10.d0*eps
n4 = 0.d0
60 n4 = n4 + 4.d0
e = (n4 + 1.d0)*(n4 + 5.d0)
tm(1) = d*(w(1) - 2.d0/e)
tm(2) = d*w(2)
e = d2*(n4*(n4 + 2.0))/((n4 - 1.0)*(n4 + 3.0)*(n4 + 1.0)**2)
qf(1) = (tm(1)*an(1) - tm(2)*an(2)) + e*a0(1)
qf(2) = (tm(1)*an(2) + tm(2)*an(1)) + e*a0(2)
a0(1) = an(1)
a0(2) = an(2)
an(1) = qf(1)
an(2) = qf(2)
qf(1) = (tm(1)*bn(1) - tm(2)*bn(2)) + e*b0(1)
qf(2) = (tm(1)*bn(2) + tm(2)*bn(1)) + e*b0(2)
b0(1) = bn(1)
b0(2) = bn(2)
bn(1) = qf(1)
bn(2) = qf(2)
w0(1) = wn(1)
w0(2) = wn(2)
call cdivid(an(1), an(2), bn(1), bn(2), wn(1), wn(2))
if (anorm(wn(1) - w0(1), wn(2) - w0(2)) > &
   & tol*anorm(wn(1), wn(2))) go to 60
c2 = c + c
sm(1) = c2*(x*wn(1) - y*wn(2))
sm(2) = c2*(x*wn(2) + y*wn(1))
e = exp(-sz(1))
qf(1) = e*cos(-sz(2))
qf(2) = e*sin(-sz(2))
tm(1) = qf(1)*sm(1) - qf(2)*sm(2)
tm(2) = qf(1)*sm(2) + qf(2)*sm(1)
w(1) = sn*tm(1)
w(2) = sn*tm(2)
if (mo == 0) return
w(1) = 1.d0 - w(1)
w(2) = - w(2)
return
!         Pade approximation for the asymptotic expansion
!                    for  z*exp(z*z)*erfc(z)
80 d = 4.d0*r
if (r < 16.d0) d = 16.d0*r
d2 = d*d
tm(1) = sz(1) + sz(1)
tm(2) = sz(2) + sz(2)
g0(1) = 1.d0
g0(2) = 0.d0
gn(1) = (2.d0 + tm(1))/d
gn(2) = tm(2)/d
h0(1) = 1.d0
h0(2) = 0.d0
tm(1) = 3.d0 + tm(1)
hn(1) = tm(1)/d
hn(2) = tm(2)/d
call cdivid(gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
np1 = 1.d0
tol = 10.d0*eps
90 n = np1
np1 = n + 1.d0
n2 = n + n
e = (n2*(n2 + 1.d0))/d2
tm(1) = tm(1) + 4.d0
qf(1) = (tm(1)*gn(1) - tm(2)*gn(2))/d - e*g0(1)
qf(2) = (tm(1)*gn(2) + tm(2)*gn(1))/d - e*g0(2)
g0(1) = gn(1)
g0(2) = gn(2)
gn(1) = qf(1)
gn(2) = qf(2)
qf(1) = (tm(1)*hn(1) - tm(2)*hn(2))/d - e*h0(1)
qf(2) = (tm(1)*hn(2) + tm(2)*hn(1))/d - e*h0(2)
h0(1) = hn(1)
h0(2) = hn(2)
hn(1) = qf(1)
hn(2) = qf(2)
w0(1) = wn(1)
w0(2) = wn(2)
call cdivid(gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
if (anorm(wn(1) - w0(1), wn(2) - w0(2)) > &
   & tol*anorm(wn(1), wn(2))) go to 90
tm(1) = x*hn(1) - y*hn(2)
tm(2) = x*hn(2) + y*hn(1)
call cdivid(c*gn(1), c*gn(2), tm(1), tm(2), sm(1), sm(2))
go to 130
!                      Asymptotic expansion
100 call dcrec(x, y, tm(1), tm(2))
sm(1) = tm(1)
sm(2) = tm(2)
qf(1) = tm(1)*tm(1) - tm(2)*tm(2)
qf(2) = 2.d0*tm(1)*tm(2)
tol = 2.d0*eps
d = -0.5d0
110 d = d + 1.d0
ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
tm(1) = -d*ts(1)
tm(2) = -d*ts(2)
sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (anorm(tm(1),tm(2)) > tol*anorm(sm(1),sm(2))) go to 110
sm(1) = c*sm(1)
sm(2) = c*sm(2)
if (x < 1.d-2) go to 200
!                       Termination
130 e = exp(-sz(1))
qf(1) = e*cos(-sz(2))
qf(2) = e*sin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
if (mo /= 0) go to 140
w(1) = sn*(0.5d0 + (0.5d0 - sm(1)))
w(2) = - sn*sm(2)
return
140 if (sn == 1.d0) go to 141
w(1) = 2.d0 - sm(1)
w(2) = -sm(2)
return
141 w(1) = sm(1)
w(2) = sm(2)
return
!               Modified asymptotic expansion
200 e = exp(-sz(1))
qf(1) = e*cos(-sz(2))
qf(2) = e*sin(-sz(2))
w(1) = qf(1)*sm(1) - qf(2)*sm(2)
w(2) = qf(1)*sm(2) + qf(2)*sm(1)
if (mo == 0) go to 210
w(1) = 1.d0 + sn*w(1)
w(2) = sn*w(2)
return
210 if (sn < 0.0) return
w(1) = - w(1)
w(2) = - w(2)
contains
   pure function anorm(x, y) result(nswc_sf_result)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: nswc_sf_result
      nswc_sf_result = max(abs(x),abs(y))
   end function anorm
end subroutine dcerf

pure subroutine dcerfc(mo, z, w)
implicit none
integer, intent(in) :: mo
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
double precision :: m, n, n2, n4, np1, c2, d, d2, e, eps, r, sn, tol, x, y, a0(2), an(2), b0(2), bn(2), g0(2), gn(2), h0(2), &
   & hn(2), qf(2), sm(2), sz(2), tm(2), ts(2), w0(2), wn(2)
double precision, parameter :: c = .56418958354775628694807945156077d0
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
   pure elemental subroutine dcrec(x,y,u,v)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision, intent(inout) :: u
      double precision, intent(inout) :: v
   end subroutine dcrec
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function dxparg(l)
      implicit none
      integer, intent(in) :: l
      double precision :: dxparg
   end function dxparg
   pure subroutine erfcm2(mo,z,w)
      implicit none
      integer, intent(in) :: mo
      double precision, intent(in) :: z(2)
      double precision, intent(inout) :: w(2)
   end subroutine erfcm2
end interface
!-----------------------------------------------------------------------
!              Computation of the complex coerror function
!                           ----------------
!           w = erfc(z)           IF mo = 0 OR real(z) .LT. 0
!           w = dexp(x*x)*erfc(z)  otherwise
!-----------------------------------------------------------------------
!------------------------
!------------------------
!     c = 1/sqrt(pi)
!------------------------
!------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.D0 + eps .GT. 1.D0.
eps = dpmpar(1)
!------------------------
x = z(1)
y = z(2)
sn = 1.d0
if (x >= 0.d0) go to 10
x = -x
y = -y
sn = -1.d0
10 if (mo /= 0  .and.  sn == 1.d0  .and. &
   & max(x, abs(y)) >= 144.d0) go to 100
r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.d0*x*y
if (r <= 1.d0) go to 20
if (r >= 144.d0) go to 100
if (abs(y) > 31.8d0*x) go to 50
if (abs(y) > 7.0d0*x .and. r < 64.d0) go to 50
if (abs(y) > 3.2d0*x .and. r < 49.d0) go to 50
if (abs(y) > 2.0d0*x .and. r < 36.d0) go to 50
if (abs(y) > 1.2d0*x .and. r < 25.d0) go to 50
if (abs(y) > 0.9d0*x .and. r < 16.d0) go to 50
if (r >= 6.25d0) go to 80
if (abs(y) > 0.6d0*x) go to 50
if (r >= 4.0d0) go to 40
d = x - 2.d0
if (d*d + y*y < 1.d0) go to 40
go to 50
!                          Taylor series
20 c2 = c + c
tm(1) = c2*x
tm(2) = c2*y
sm(1) = tm(1)
sm(2) = tm(2)
tol = 2.d0*eps
m = 0.d0
21 m = m + 1.d0
d = m + m + 1.d0
ts(1) = tm(1)*sz(1) - tm(2)*sz(2)
ts(2) = tm(1)*sz(2) + tm(2)*sz(1)
tm(1) = -ts(1)/m
tm(2) = -ts(2)/m
ts(1) = tm(1)/d
ts(2) = tm(2)/d
sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
if (anorm(ts(1),ts(2)) > tol*anorm(sm(1),sm(2))) go to 21
if (sn == 1.d0) go to 30
w(1) = 1.d0 + sm(1)
w(2) = sm(2)
return
30 sm(1) = 0.5d0 + (0.5d0 - sm(1))
sm(2) = -sm(2)
if (mo == 0) go to 140
e = exp(sz(1))
qf(1) = e*cos(sz(2))
qf(2) = e*sin(sz(2))
w(1) = qf(1)*sm(1) - qf(2)*sm(2)
w(2) = qf(1)*sm(2) + qf(2)*sm(1)
return
!                  Taylor series around Z0 = 2
40 if (sn < 0.d0) go to 41
call erfcm2(mo, z, w)
return
41 tm(1) = x
tm(2) = y
call erfcm2(0, tm, w)
w(1) = 2.d0 - w(1)
w(2) = - w(2)
return
!            Pade approximation for the Taylor series
!                    for  (exp(z*z)/z)*erf(z)
50 d = 4.d0
if (r > 16.d0) d = 16.d0
if (r > 64.d0) d = 64.d0
d2 = d*d
call dcrec(sz(1), sz(2), w(1), w(2))
a0(1) = 1.d0
a0(2) = 0.d0
an(1) = (w(1) + 4.d0/15.d0)*d
an(2) = w(2)*d
b0(1) = 1.d0
b0(2) = 0.d0
bn(1) = (w(1) - 0.4d0)*d
bn(2) = w(2)*d
call cdivid(an(1), an(2), bn(1), bn(2), wn(1), wn(2))
tol = 10.d0*eps
n4 = 0.d0
60 n4 = n4 + 4.d0
e = (n4 + 1.d0)*(n4 + 5.d0)
tm(1) = d*(w(1) - 2.d0/e)
tm(2) = d*w(2)
e = d2*(n4*(n4 + 2.0))/((n4 - 1.0)*(n4 + 3.0)*(n4 + 1.0)**2)
qf(1) = (tm(1)*an(1) - tm(2)*an(2)) + e*a0(1)
qf(2) = (tm(1)*an(2) + tm(2)*an(1)) + e*a0(2)
a0(1) = an(1)
a0(2) = an(2)
an(1) = qf(1)
an(2) = qf(2)
qf(1) = (tm(1)*bn(1) - tm(2)*bn(2)) + e*b0(1)
qf(2) = (tm(1)*bn(2) + tm(2)*bn(1)) + e*b0(2)
b0(1) = bn(1)
b0(2) = bn(2)
bn(1) = qf(1)
bn(2) = qf(2)
w0(1) = wn(1)
w0(2) = wn(2)
call cdivid(an(1), an(2), bn(1), bn(2), wn(1), wn(2))
if (anorm(wn(1) - w0(1), wn(2) - w0(2)) > &
   & tol*anorm(wn(1), wn(2))) go to 60
c2 = c + c
sm(1) = c2*(x*wn(1) - y*wn(2))
sm(2) = c2*(x*wn(2) + y*wn(1))
if (mo == 0 .or. sn /= 1.d0) go to 70
e = exp(sz(1))
w(1) = e*cos(sz(2)) - sm(1)
w(2) = e*sin(sz(2)) - sm(2)
return
70 e = exp(-sz(1))
qf(1) = e*cos(-sz(2))
qf(2) = e*sin(-sz(2))
tm(1) = qf(1)*sm(1) - qf(2)*sm(2)
tm(2) = qf(1)*sm(2) + qf(2)*sm(1)
w(1) = 1.d0 - sn*tm(1)
w(2) = - sn*tm(2)
return
!         Pade approximation for the asymptotic expansion
!                    for  z*exp(z*z)*erfc(z)
80 d = 4.d0*r
if (r < 16.d0) d = 16.d0*r
d2 = d*d
tm(1) = sz(1) + sz(1)
tm(2) = sz(2) + sz(2)
g0(1) = 1.d0
g0(2) = 0.d0
gn(1) = (2.d0 + tm(1))/d
gn(2) = tm(2)/d
h0(1) = 1.d0
h0(2) = 0.d0
tm(1) = 3.d0 + tm(1)
hn(1) = tm(1)/d
hn(2) = tm(2)/d
call cdivid(gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
np1 = 1.d0
tol = 10.d0*eps
90 n = np1
np1 = n + 1.d0
n2 = n + n
e = (n2*(n2 + 1.d0))/d2
tm(1) = tm(1) + 4.d0
qf(1) = (tm(1)*gn(1) - tm(2)*gn(2))/d - e*g0(1)
qf(2) = (tm(1)*gn(2) + tm(2)*gn(1))/d - e*g0(2)
g0(1) = gn(1)
g0(2) = gn(2)
gn(1) = qf(1)
gn(2) = qf(2)
qf(1) = (tm(1)*hn(1) - tm(2)*hn(2))/d - e*h0(1)
qf(2) = (tm(1)*hn(2) + tm(2)*hn(1))/d - e*h0(2)
h0(1) = hn(1)
h0(2) = hn(2)
hn(1) = qf(1)
hn(2) = qf(2)
w0(1) = wn(1)
w0(2) = wn(2)
call cdivid(gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
if (anorm(wn(1) - w0(1), wn(2) - w0(2)) > &
   & tol*anorm(wn(1), wn(2))) go to 90
tm(1) = x*hn(1) - y*hn(2)
tm(2) = x*hn(2) + y*hn(1)
call cdivid(c*gn(1), c*gn(2), tm(1), tm(2), sm(1), sm(2))
go to 130
!                      Asymptotic expansion
100 call dcrec(x, y, tm(1), tm(2))
sm(1) = tm(1)
sm(2) = tm(2)
qf(1) = tm(1)*tm(1) - tm(2)*tm(2)
qf(2) = 2.d0*tm(1)*tm(2)
tol = 2.d0*eps
d = -0.5d0
110 d = d + 1.d0
ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
tm(1) = -d*ts(1)
tm(2) = -d*ts(2)
sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (anorm(tm(1),tm(2)) > tol*anorm(sm(1),sm(2))) go to 110
sm(1) = c*sm(1)
sm(2) = c*sm(2)
if (x < 1.d-2) go to 200
!                       Termination
130 if (mo /= 0 .and. sn == 1.d0) go to 140
e = exp(-sz(1))
qf(1) = e*cos(-sz(2))
qf(2) = e*sin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
if (sn == 1.d0) go to 140
w(1) = 2.d0 - sm(1)
w(2) = -sm(2)
return
140 w(1) = sm(1)
w(2) = sm(2)
return
!               Modified asymptotic expansion
200 if (mo /= 0 .and. sn == 1.d0) go to 210
e = exp(-sz(1))
qf(1) = e*cos(-sz(2))
qf(2) = e*sin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
w(1) = 1.d0 + sn*ts(1)
w(2) = sn*ts(2)
return
210 if (abs(y) >= 100.d0) go to 140
if (sz(1) <= dxparg(1)) go to 140
e = exp(sz(1))
w(1) = e*cos(sz(2)) + sm(1)
w(2) = e*sin(sz(2)) + sm(2)
contains
   pure function anorm(x, y) result(nswc_sf_result)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: nswc_sf_result
      nswc_sf_result = max(abs(x),abs(y))
   end function anorm
end subroutine dcerfc

pure subroutine erfcm2(mo, z, w)
implicit none
integer, intent(in) :: mo
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
integer :: j, n
double precision :: eps, h(2), t(2), tol, x, y
double precision, parameter :: c = .20666985354092053857068941306585476d-01
double precision, parameter :: e = .46777349810472658379307436327470714d-02
double precision, parameter :: a(63) = [.20000000000000000000000000000000000d+01, &
   & .23333333333333333333333333333333333d+01, .16666666666666666666666666666666667d+01, .63333333333333333333333333333333333d+00, &
   & -.22222222222222222222222222222222222d-01, -.16349206349206349206349206349206349d+00, - &
   & .76984126984126984126984126984126984d-01, -.24250440917107583774250440917107584d-02, .12716049382716049382716049382716049d-01 &
   & , .50208433541766875100208433541766875d-02, -.25305969750414194858639303083747528d-03, - &
   & .78593217482106370995259884148773038d-03, -.19118154038788959423880058800693721d-03, .46324144207742091339974937858535742d-04 &
   & , .33885549097189308829520469732109944d-04, .28637897646612243562134629672756034d-05, - &
   & .29071891082127275370004560446169188d-05, -.89674405786490646425523560263096103d-06, .96069103941908684338469767911200105d-07 &
   & , .99432863129093191401848891268744113d-07, .97610310501460621303387795457283579d-08, - &
   & .65557500375673133822289344530892436d-08, -.18706782059105426900361744016236561d-08, .20329898993447386223176373714372370d-09 &
   & , .16941915827254374668448114614201210d-09, .10619149520827430973786114446699534d-10, - &
   & .10136148256511788733365237088810952d-10, -.21042890133669970575386166675721692d-11, .37186985840699828780916522245407087d-12 &
   & , .17921843632701679986488128324051002d-12, -.89823991804248069863542565948598397d-16, - &
   & .10533182313660970970232171410372199d-13, -.12340742690978398320850088252659714d-14, .44315624546581333350568244777175883d-15 &
   & , .11584041639989442481950487524296214d-15, -.10765703619385988116658460442219647d-16, - &
   & .70653158723054941879586082239984222d-17, -.18708903154917138727191793341667090d-18, .32549879318817103966053527398133297d-18 &
   & , .40654116689599228385911733319215613d-19, -.11250074516817311101947327325293424d-19, - &
   & .28923865378584966737386008432031980d-20, .23653053641701517160704870522922706d-21, .14665384680061888088099002254334292d-21, &
   & .26971039707314316218154193225264469d-23, -.58753834789274356433279671015522650d-23, - &
   & .59960357240498652932299485494869633d-24, .18586826578121663981412155416486531d-24, .38364131854692721721867481914852428d-25, &
   & -.41342210492630142578080062451711039d-26, -.17646283105274988992381528904600860d-26, &
   & .19828685934364181151988692232131608d-28, .65592252170840353572672782446212733d-28, .40626551379996340638338449938639730d-29, &
   & -.20097984104191034713653294173834095d-29, -.28104226475997460044096389060743131d-30, &
   & .48705319298749358709127987806547949d-31, .12664655832830787747161769929972617d-31, -.75168312488894341862391776330113688d-33 &
   & , -.45760473722605993842481669806804415d-33, -.56725491529575395930156379514718000d-35, &
   & .13932664042920082608489441616061541d-34, .10452448992516358449586503951463322d-35]
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!           Calculation of erfc(z) using the Taylor series
!                          AROUND Z0 = 2
!-----------------------------------------------------------------------
!------------------------------
!------------------------------
!     c = (2/sqrt(pi))*exp(-4)
!     e = erfc(2)
!------------------------------
!------------------------------
!------------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.D0 + eps .GT. 1.D0
eps = dpmpar(1)
!------------------------------
tol = eps*1.d+12
h(1) = 1.d0 + (1.d0 - z(1))
h(2) = - z(2)
x = 1.d0
y = 0.d0
w(1) = a(30)
w(2) = 0.d0
do n = 31,63
   t(1) = x*h(1) - y*h(2)
   t(2) = x*h(2) + y*h(1)
   x = t(1)
   y = t(2)
   t(1) = a(n)*x
   t(2) = a(n)*y
   w(1) = w(1) + t(1)
   w(2) = w(2) + t(2)
   if (anorm(t(1) , t(2)) <= tol * anorm(w(1) , w &
      & (2))) exit
end do
do j = 1,29
   n = 30 - j
   x = h(1)*w(1) - h(2)*w(2)
   w(2) = h(1)*w(2) + h(2)*w(1)
   w(1) = a(n) + x
end do
x = h(1)*w(1) - h(2)*w(2)
w(2) = h(1)*w(2) + h(2)*w(1)
w(1) = 1.d0 + x
x = c*(h(1)*w(1) - h(2)*w(2))
w(2) = c*(h(1)*w(2) + h(2)*w(1))
w(1) = e + x
if (mo == 0) return
!                     Compute exp(z*z)*erfc(z)
x = z(1)*z(1) - z(2)*z(2)
y = 2.d0*z(1)*z(2)
x = exp(x)
t(1) = x*cos(y)
t(2) = x*sin(y)
x = t(1)*w(1) - t(2)*w(2)
y = t(1)*w(2) + t(2)*w(1)
w(1) = x
w(2) = y
contains
   pure function anorm(x, y) result(nswc_sf_result)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: y
      double precision :: nswc_sf_result
      nswc_sf_result = max(abs(x),abs(y))
   end function anorm
end subroutine erfcm2

pure elemental double precision function derf(x)
implicit none
double precision, intent(in) :: x
integer :: i, k
double precision :: ax, t, w
double precision, parameter :: a(21) = [.1283791670955125738961589031215d+00, - &
   & .3761263890318375246320529677070d+00, .1128379167095512573896158902931d+00, -.2686617064513125175943235372542d-01, &
   & .5223977625442187842111812447877d-02, -.8548327023450852832540164081187d-03, .1205533298178966425020717182498d-03, - &
   & .1492565035840625090430728526820d-04, .1646211436588924261080723578109d-05, -.1636584469123468757408968429674d-06, &
   & .1480719281587021715400818627811d-07, -.1229055530145120140800510155331d-08, .9422759058437197017313055084212d-10, - &
   & .6711366740969385085896257227159d-11, .4463222608295664017461758843550d-12, -.2783497395542995487275065856998d-13, &
   & .1634095572365337143933023780777d-14, -.9052845786901123985710019387938d-16, .4708274559689744439341671426731d-17, - &
   & .2187159356685015949749948252160d-18, .7043407712019701609635599701333d-20]
interface
   pure elemental function derfc0(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: derfc0
   end function derfc0
end interface
!-----------------------------------------------------------------------
!        Double precision evaluation of the error function
!-----------------------------------------------------------------------
!-------------------------------
!-------------------------------
!                     dabs(x) .LE. 1
ax = abs(x)
if (ax > 1.d0) go to 20
t = x*x
w = a(21)
do i = 1,20
   k = 21 - i
   w = t*w + a(k)
end do
derf = x*(1.d0 + w)
return
!                     dabs(x) .GT. 1
20 if (ax >= 8.5d0) go to 30
derf = 0.5d0 + (0.5d0 - exp(-x*x)*derfc0(ax))
if (x < 0.d0) derf = -derf
return
!                 Limit value for large x
30 derf = sign(1.d0,x)
end function derf

pure elemental double precision function derfc(x)
implicit none
double precision, intent(in) :: x
integer :: i, k
double precision :: ax, t, w
double precision, parameter :: a(21) = [.1283791670955125738961589031215d+00, - &
   & .3761263890318375246320529677070d+00, .1128379167095512573896158902931d+00, -.2686617064513125175943235372542d-01, &
   & .5223977625442187842111812447877d-02, -.8548327023450852832540164081187d-03, .1205533298178966425020717182498d-03, - &
   & .1492565035840625090430728526820d-04, .1646211436588924261080723578109d-05, -.1636584469123468757408968429674d-06, &
   & .1480719281587021715400818627811d-07, -.1229055530145120140800510155331d-08, .9422759058437197017313055084212d-10, - &
   & .6711366740969385085896257227159d-11, .4463222608295664017461758843550d-12, -.2783497395542995487275065856998d-13, &
   & .1634095572365337143933023780777d-14, -.9052845786901123985710019387938d-16, .4708274559689744439341671426731d-17, - &
   & .2187159356685015949749948252160d-18, .7043407712019701609635599701333d-20]
interface
   pure elemental function derfc0(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: derfc0
   end function derfc0
   pure elemental function dxparg(l)
      implicit none
      integer, intent(in) :: l
      double precision :: dxparg
   end function dxparg
end interface
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!-----------------------------------------------------------------------
!-------------------------------
!-------------------------------
!                     dabs(x) .LE. 1
ax = abs(x)
if (ax > 1.d0) go to 20
t = x*x
w = a(21)
do i = 1,20
   k = 21 - i
   w = t*w + a(k)
end do
derfc = 0.5d0 + (0.5d0 - x*(1.d0 + w))
return
!                       x .LT. -1
20 if (x > 0.d0) go to 30
derfc = 2.d0
if (x < -8.3d0) return
t = x*x
derfc = 2.d0 - exp(-t) * derfc0(ax)
return
!                       x .GT. 1
30 derfc = 0.d0
if (x > 100.d0) return
t = x*x
if (t > -dxparg(1)) return
derfc = exp(-t) * derfc0(x)
end function derfc

pure elemental double precision function derfc1(ind, x)
implicit none
integer, intent(in) :: ind
double precision, intent(in) :: x
integer :: i, k
double precision :: ax, t, w
double precision, parameter :: a(21) = [.1283791670955125738961589031215d+00, - &
   & .3761263890318375246320529677070d+00, .1128379167095512573896158902931d+00, -.2686617064513125175943235372542d-01, &
   & .5223977625442187842111812447877d-02, -.8548327023450852832540164081187d-03, .1205533298178966425020717182498d-03, - &
   & .1492565035840625090430728526820d-04, .1646211436588924261080723578109d-05, -.1636584469123468757408968429674d-06, &
   & .1480719281587021715400818627811d-07, -.1229055530145120140800510155331d-08, .9422759058437197017313055084212d-10, - &
   & .6711366740969385085896257227159d-11, .4463222608295664017461758843550d-12, -.2783497395542995487275065856998d-13, &
   & .1634095572365337143933023780777d-14, -.9052845786901123985710019387938d-16, .4708274559689744439341671426731d-17, - &
   & .2187159356685015949749948252160d-18, .7043407712019701609635599701333d-20]
interface
   pure elemental function derfc0(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: derfc0
   end function derfc0
   pure elemental function dxparg(l)
      implicit none
      integer, intent(in) :: l
      double precision :: dxparg
   end function dxparg
end interface
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!          derfc1(ind,x) = erfc(x)           if ind = 0
!          derfc1(ind,x) = exp(x*x)*erfc(x)  otherwise
!-----------------------------------------------------------------------
!-------------------------------
!-------------------------------
!                     dabs(x) .LE. 1
ax = abs(x)
if (ax > 1.d0) go to 20
t = x*x
w = a(21)
do i = 1,20
   k = 21 - i
   w = t*w + a(k)
end do
derfc1 = 0.5d0 + (0.5d0 - x*(1.d0 + w))
if (ind /= 0) derfc1 = exp(t) * derfc1
return
!                       x .LT. -1
20 if (x > 0.d0) go to 50
if (x < -8.3d0) go to 80
if (ind == 0) go to 30
derfc1 = 2.d0*exp(x*x) - derfc0(ax)
return
30 derfc1 = 2.d0 - exp(-x*x)*derfc0(ax)
return
!                       x .GT. 1
50 if (ind == 0) go to 60
derfc1 = derfc0(x)
return
60 derfc1 = 0.d0
if (x > 100.d0) return
t = x*x
if (t > -dxparg(1)) return
derfc1 = exp(-t) * derfc0(x)
return
!             Limit value for large negative x
80 derfc1 = 2.d0
if (ind /= 0) derfc1 = 2.d0*exp(x*x)
end function derfc1

pure elemental double precision function derfc0(x)
implicit none
!-----------------------------------------------------------------------
!           Evaluation of exp(x**2)*erfc(x) for x .GE. 1
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!        April 1992
!-------------------------------
double precision, intent(in) :: x
double precision :: t, u, v, z
double precision, parameter :: rpinv = .56418958354775628694807945156077259d0
double precision, parameter :: p0 = .16506148041280876191828601d-03
double precision, parameter :: p1 = .15471455377139313353998665d-03
double precision, parameter :: p2 = .44852548090298868465196794d-04
double precision, parameter :: p3 = -.49177280017226285450486205d-05
double precision, parameter :: p4 = -.69353602078656412367801676d-05
double precision, parameter :: p5 = -.20508667787746282746857743d-05
double precision, parameter :: p6 = -.28982842617824971177267380d-06
double precision, parameter :: p7 = -.17272433544836633301127174d-07
double precision, parameter :: q1 = .16272656776533322859856317d+01
double precision, parameter :: q2 = .12040996037066026106794322d+01
double precision, parameter :: q3 = .52400246352158386907601472d+00
double precision, parameter :: q4 = .14497345252798672362384241d+00
double precision, parameter :: q5 = .25592517111042546492590736d-01
double precision, parameter :: q6 = .26869088293991371028123158d-02
double precision, parameter :: q7 = .13133767840925681614496481d-03
double precision, parameter :: r0 = .145589721275038539045668824025d+00
double precision, parameter :: r1 = -.273421931495426482902320421863d+00
double precision, parameter :: r2 = .226008066916621506788789064272d+00
double precision, parameter :: r3 = -.163571895523923805648814425592d+00
double precision, parameter :: r4 = .102604312032193978662297299832d+00
double precision, parameter :: r5 = -.548023266949835519254211506880d-01
double precision, parameter :: r6 = .241432239725390106956523668160d-01
double precision, parameter :: r7 = -.822062115403915116036874169600d-02
double precision, parameter :: r8 = .180296241564687154310619200000d-02
double precision, parameter :: a0 = -.45894433406309678202825375d-03
double precision, parameter :: a1 = -.12281298722544724287816236d-01
double precision, parameter :: a2 = -.91144359512342900801764781d-01
double precision, parameter :: a3 = -.28412489223839285652511367d-01
double precision, parameter :: a4 = .14083827189977123530129812d+01
double precision, parameter :: a5 = .11532175281537044570477189d+01
double precision, parameter :: a6 = -.72170903389442152112483632d+01
double precision, parameter :: a7 = -.19685597805218214001309225d+01
double precision, parameter :: a8 = .93846891504541841150916038d+01
double precision, parameter :: b1 = .25136329960926527692263725d+02
double precision, parameter :: b2 = .15349442087145759184067981d+03
double precision, parameter :: b3 = -.29971215958498680905476402d+03
double precision, parameter :: b4 = -.33876477506888115226730368d+04
double precision, parameter :: b5 = .28301829314924804988873701d+04
double precision, parameter :: b6 = .22979620942196507068034887d+05
double precision, parameter :: b7 = -.24280681522998071562462041d+05
double precision, parameter :: b8 = -.36680620673264731899504580d+05
double precision, parameter :: b9 = .42278731622295627627042436d+05
double precision, parameter :: b10 = .28834257644413614344549790d+03
double precision, parameter :: b11 = .70226293775648358646587341d+03
double precision, parameter :: c0 = -.7040906288250128001000086d-04
double precision, parameter :: c1 = -.3858822461760510359506941d-02
double precision, parameter :: c2 = -.7708202127512212359395078d-01
double precision, parameter :: c3 = -.6713655014557429480440263d+00
double precision, parameter :: c4 = -.2081992124162995545731882d+01
double precision, parameter :: c5 = .2898831421475282558867888d+01
double precision, parameter :: c6 = .2199509380600429331650192d+02
double precision, parameter :: c7 = .2907064664404115316722996d+01
double precision, parameter :: c8 = -.4766208741588182425380950d+02
double precision, parameter :: d1 = .5238852785508439144747174d+02
double precision, parameter :: d2 = .9646843357714742409535148d+03
double precision, parameter :: d3 = .7007152775135939601804416d+04
double precision, parameter :: d4 = .8515386792259821780601162d+04
double precision, parameter :: d5 = -.1002360095177164564992134d+06
double precision, parameter :: d6 = -.2065250031331232815791912d+06
double precision, parameter :: d7 = .5695324805290370358175984d+06
double precision, parameter :: d8 = .6589752493461331195697873d+06
double precision, parameter :: d9 = -.1192930193156561957631462d+07
double precision, parameter :: e0 = .540464821348814822409610122136d+00
double precision, parameter :: e1 = -.261515522487415653487049835220d-01
double precision, parameter :: e2 = -.288573438386338758794591212600d-02
double precision, parameter :: e3 = -.529353396945788057720258856000d-03
double precision, parameter :: s1 = .75000000000000000000d+00
double precision, parameter :: s2 = -.18750000000000000000d+01
double precision, parameter :: s3 = .65625000000000000000d+01
double precision, parameter :: s4 = -.29531250000000000000d+02
double precision, parameter :: s5 = .16242187500000000000d+03
double precision, parameter :: s6 = -.10557421875000000000d+04
double precision, parameter :: s7 = .79180664062500000000d+04
double precision, parameter :: s8 = -.67303564453125000000d+05
double precision, parameter :: s9 = .63938386230468750000d+06
double precision, parameter :: s10 = -.67135305541992187500d+07
double precision, parameter :: s11 = .77205601373291015625d+08
!-------------------------------
!     rpinv = 1/sqrt(pi)
!-------------------------------
!-------------------------------
!-------------------------------
!-------------------------------
!-------------------------------
!-------------------------------
!-------------------------------
!     Coefficients for the asymptotic expansion
!-------------------------------
!-------------------------------
!                     1 .LE. x .LE. 2
if (x > 2.d0) go to 10
u = ((((((p7*x + p6)*x + p5)*x + p4)*x + p3)*x + &
   & p2)*x + p1)*x + p0
v = ((((((q7*x + q6)*x + q5)*x + q4)*x + q3)*x + &
   & q2)*x + q1)*x + 1.d0
t = (x - 3.75d0)/(x + 3.75d0)
derfc0 = (((((((((u/v)*t + r8)*t + r7)*t + r6)*t + r5)*t + &
   & r4)*t + r3)*t + r2)*t + r1)*t + r0
return
!                     2 .LT. x .LE. 4
10 if (x > 4.d0) go to 20
z = 1.d0/(2.5d0 + x*x)
u = (((((((a8*z + a7)*z + a6)*z + a5)*z + a4)*z + a3)*z + &
   & a2)*z + a1)*z + a0
v = ((((((((((b11*z + b10)*z + b9)*z + b8)*z + b7)*z + b6)*z + &
   & b5)*z + b4)*z + b3)*z + b2)*z + b1)*z + 1.d0
t = 13.d0*z - 1.d0
derfc0 = ((((u/v)*t + e2)*t + e1)*t + e0)/x
return
!                     4 .LT. x .LT. 50
20 if (x >= 50.d0) go to 30
z = 1.d0/(2.5d0 + x*x)
u = (((((((c8*z + c7)*z + c6)*z + c5)*z + c4)*z + c3)*z + &
   & c2)*z + c1)*z + c0
v = ((((((((d9*z + d8)*z + d7)*z + d6)*z + d5)*z + d4)*z + &
   & d3)*z + d2)*z + d1)*z + 1.d0
t = 13.d0*z - 1.d0
derfc0 = (((((u/v)*t + e3)*t + e2)*t + e1)*t + e0)/x
return
!                        x .GE. 50
30 t = (1.d0/x)**2
z = (((((((((((s11*t + s10)*t + s9)*t + s8)*t + s7)*t + &
   & s6)*t + s5)*t + s4)*t + s3)*t + s2)*t + s1)*t - &
   & 0.5d0)*t + 1.d0
derfc0 = rpinv*(z/x)
end function derfc0

pure elemental real function erfi(p, q)
implicit none
real, intent(in) :: p, q
real :: eps, s, t, v, v1
real, parameter :: c = .5625
real, parameter :: c1 = .87890625
real, parameter :: c2 = -.2302585092994046e+03
real, parameter :: a(6) = [.1400216916161353e+03, -.7204275515686407e+03, .1296708621660511e+04, -.9697932901514031e+03, &
   & .2762427049269425e+03, -.2012940180552054e+02]
real, parameter :: b(6) = [.1291046303114685e+03, -.7312308064260973e+03, .1494970492915789e+04, -.1337793793683419e+04, &
   & .5033747142783567e+03, -.6220205554529216e+02]
real, parameter :: a1(7) = [-.1690478046781745e+00, .3524374318100228e+01, -.2698143370550352e+02, .9340783041018743e+02, &
   & -.1455364428646732e+03, .8805852004723659e+02, -.1349018591231947e+02]
real, parameter :: b1(7) = [-.1203221171313429e+00, .2684812231556632e+01, -.2242485268704865e+02, .8723495028643494e+02, &
   & -.1604352408444319e+03, .1259117982101525e+03, -.3184861786248824e+02]
real, parameter :: a2(9) = [.3100808562552958e-04, .4097487603011940e-02, .1214902662897276e+00, .1109167694639028e+01, &
   & .3228379855663924e+01, .2881691815651599e+01, .2047972087262996e+01, .8545922081972148e+00, .3551095884622383e-02]
real, parameter :: b2(8) = [.3100809298564522e-04, .4097528678663915e-02, .1215907800748757e+00, .1118627167631696e+01, &
   & .3432363984305290e+01, .4140284677116202e+01, .4119797271272204e+01, .2162961962641435e+01]
real, parameter :: a3(9) = [.3205405422062050e-08, .1899479322632128e-05, .2814223189858532e-03, .1370504879067817e-01, &
   & .2268143542005976e+00, .1098421959892340e+01, .6791143397056208e+00, -.834334189167721e+00, .3421951267240343e+00]
real, parameter :: b3(6) = [.3205405053282398e-08, .1899480592260143e-05, .2814349691098940e-03, .1371092249602266e-01, &
   & .2275172815174473e+00, .1125348514036959e+01]
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!              Evaluation of the inverse error function
!                        ---------------
!     For 0 .LE. p .LT. 1,  W = erfi(p,q) where erf(W) = p. it is
!     assumed that q = 1 - p.  if p .LT. 0, q .LE. 0, or p + q is
!     not 1, then erfi(p,q) is set to a negative value.
!-----------------------------------------------------------------------
!     Reference. Mathematics of computation,oct.1976,PP.827-830.
!                  J.M.Blair,C.A.Edwards,J.H.Johnson
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     c2 = ln(1.e-100)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!                            Table no.16
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!                            Table no.36
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!                            Table no.56
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!                            Table no.79
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
if (p < 0.0 .or. q <= 0.0) go to 100
eps = max(spmpar(1),1.e-15)
t = 0.5 + (0.5 - (p + q))
if (abs(t) > 3.0*eps) go to 110
!                      0 .LE. p .LE. 0.75
if (p > 0.75) go to 10
v = p*p - c
t = p *  (((((a(6)*v + a(5))*v + a(4))*v + a(3))*v &
   & + a(2))*v + a(1))
s = (((((v + b(6))*v + b(5))*v + b(4))*v + b(3))*v &
   & + b(2))*v + b(1)
go to 40
!                    0.75 .LT. p .LE. 0.9375
10 if (p > 0.9375) go to 20
v = p*p - c1
t = p *  ((((((a1(7)*v + a1(6))*v + a1(5))*v + a1(4))*v &
   & + a1(3))*v + a1(2))*v + a1(1))
s = ((((((v + b1(7))*v + b1(6))*v + b1(5))*v + b1(4))*v &
   & + b1(3))*v + b1(2))*v + b1(1)
go to 40
!                  1.E-100 .LE. q .LT. 0.0625
20 v1 = log(q)
v = 1.0/sqrt(-v1)
if (v1 < c2) go to 30
t = (((((((a2(9)*v + a2(8))*v + a2(7))*v + a2(6))*v + a2(5))*v &
   & + a2(4))*v + a2(3))*v + a2(2))*v + a2(1)
s = v *  ((((((((v + b2(8))*v + b2(7))*v + b2(6))*v + b2(5))*v &
   & + b2(4))*v + b2(3))*v + b2(2))*v + b2(1))
go to 40
!                 1.E-10000 .LE. q .LT. 1.E-100
30 t = (((((((a3(9)*v + a3(8))*v + a3(7))*v + a3(6))*v + a3(5))*v &
   & + a3(4))*v + a3(3))*v + a3(2))*v + a3(1)
s = v * ((((((v + b3(6))*v + b3(5))*v + b3(4))*v + b3(3))*v &
   & + b3(2))*v + b3(1))
40 erfi = t/s
return
!                         Error return
100 erfi = -1.0
return
110 erfi = -2.0
end function erfi

pure elemental double precision function derfi(p, q)
implicit none
intrinsic :: erf
!-----------------------------------------------------------------------
!                  Double precision computation of
!                    the inverse error function
!                         ----------------
!     FOR 0 .LE. p .LE. 1,  W = derfi(p,q) WHERE erf(W) = p. IT
!     is assumed that q = 1 - p. if p .LT. 0, q .LE. 0, or p + q
!     is not 1, then derfi(p,q) is set to a negative value.
!-----------------------------------------------------------------------
!     Reference. Mathematics of computation,oct.1976,PP.827-830.
!                  J.M.Blair,C.A.Edwards,J.H.Johnson
!-----------------------------------------------------------------------
double precision, intent(in) :: p, q
double precision :: eps, f, lnq, s, t, x
double precision, parameter :: c = .5625d0
double precision, parameter :: c1 = .87890625d0
double precision, parameter :: c2 = -.2302585092994045684017991454684364d+03
double precision, parameter :: r = .8862269254527580136490837416705726d+00
double precision, parameter :: a(7) = [.841467547194693616d-01, .160499904248262200d+01, &
   & .809451641478547505d+01, .164273396973002581d+02, .154297507839223692d+02, .669584134660994039d+01, .108455979679682472d+01]
double precision, parameter :: b(7) = [.352281538790042405d-02, .293409069065309557d+00, &
   & .326709873508963100d+01, .123611641257633210d+02, .207984023857547070d+02, .170791197367677668d+02, .669253523595376683d+01]
double precision, parameter :: a1(7) = [.552755110179178015d+2, .657347545992519152d+3, .124276851197202733d+4 &
   & , .818859792456464820d+3, .234425632359410093d+3, .299942187305427917d+2, .140496035731853946d+1]
double precision, parameter :: b1(6) = [.179209835890172156d+3, .991315839349539886d+3, .138271033653003487d+4 &
   & , .764020340925985926d+3, .194354053300991923d+3, .228139510050586581d+2]
double precision, parameter :: a2(7) = [.500926197430588206d+1, .111349802614499199d+3, .353872732756132161d+3 &
   & , .356000407341490731d+3, .143264457509959760d+3, .240823237485307567d+2, .140496035273226366d+1]
double precision, parameter :: b2(6) = [.209004294324106981d+2, .198607335199741185d+3, .439311287748524270d+3 &
   & , .355415991280861051d+3, .123303672628828521d+3, .186060775181898848d+2]
double precision, parameter :: a3(11) = [.237121026548776092d4, .732899958728969905d6, .182063754893444775d7, &
   & .269191299062422172d7, .304817224671614253d7, .130643103351072345d7, .296799076241952125d6, .457006532030955554d5, &
   & .373449801680687213d4, .118062255483596543d3, .100000329157954960d1]
double precision, parameter :: b3(10) = [.851911109952055378d6, .194746720192729966d7, .373640079258593694d7, &
   & .397271370110424145d7, .339457682064283712d7, .136888294898155938d7, .303357770911491406d6, .459721480357533823d5, &
   & .373762573565814355d4, .118064334590001264d3]
double precision, parameter :: a4(9) = [.154269429680540807d12, .430207405012067454d12, .182623446525965017d12 &
   & , .248740194409838713d11, .133506080294978121d10, .302446226073105850d08, .285909602878724425d06, .101789226017835707d04, &
   & .100000004821118676d01]
double precision, parameter :: b4(9) = [.220533001293836387d12, .347822938010402687d12, .468373326975152250d12 &
   & , .185251723580351631d12, .249464490520921771d11, .133587491840784926d10, .302480682561295591d08, .285913799407861384d06, &
   & .101789250893050230d04]
interface
   pure elemental function derfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      double precision, intent(in) :: x
      double precision :: derfc1
   end function derfc1
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     c2 = ln(1.e-100)
!     r  = sqrt(pi)/2
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
!-----------------------
!-----------------------------------------------------------------------
!                       Modified table no.59
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!                       Modified table no.82
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
if (p < 0.d0 .or. q <= 0.d0) go to 100
eps = dpmpar(1)
t = 0.5d0 + (0.5d0 - (p + q))
if (abs(t) > 3.d0*eps) go to 110
!                      0 .LE. p .LE. 0.75
if (p > 0.75d0) go to 10
x = c - p*p
s = (((((a(1)*x + a(2))*x + a(3))*x + a(4))*x + a(5))*x &
   & + a(6))*x + a(7)
t = ((((((b(1)*x + b(2))*x + b(3))*x + b(4))*x + b(5))*x &
   & + b(6))*x + b(7))*x + 1.d0
derfi = p*(s/t)
if (eps > 1.d-19) return
x = derfi
f = erf(x) - p
derfi = x - r * exp(x*x) * f
return
!                    0.75 .LT. p .LE. 0.9375
10 if (p > 0.9375d0) go to 40
x = c1 - p*p
if (x > 0.1d0) go to 20
s = ((((((a1(1)*x + a1(2))*x + a1(3))*x + a1(4))*x &
   & + a1(5))*x + a1(6))*x + a1(7))
t = ((((((b1(1)*x + b1(2))*x + b1(3))*x + b1(4))*x &
   & + b1(5))*x + b1(6))*x + 1.d0)
go to 30
20 s = ((((((a2(1)*x + a2(2))*x + a2(3))*x + a2(4))*x &
   & + a2(5))*x + a2(6))*x + a2(7))
t = ((((((b2(1)*x + b2(2))*x + b2(3))*x + b2(4))*x &
   & + b2(5))*x + b2(6))*x + 1.d0)
30 derfi = p*(s/t)
if (eps > 1.d-19) return
x = derfi
t = derfc1(1,x) - exp(x*x)*q
derfi = x + r * t
return
!                  1.E-100 .LE. q .LT. 0.0625
40 lnq = log(q)
x = 1.d0/sqrt(- lnq)
if (lnq < c2) go to 50
s = (((((((((a3(1)*x + a3(2))*x + a3(3))*x + a3(4))*x + a3(5))*x &
   & + a3(6))*x + a3(7))*x + a3(8))*x + a3(9))*x &
   & + a3(10))*x + a3(11)
t = (((((((((b3(1)*x + b3(2))*x + b3(3))*x + b3(4))*x + b3(5))*x &
   & + b3(6))*x + b3(7))*x + b3(8))*x + b3(9))*x &
   & + b3(10))*x + 1.d0
go to 60
!                 1.E-10000 .LE. q .LT. 1.E-100
50 s = (((((((a4(1)*x + a4(2))*x + a4(3))*x + a4(4))*x + a4(5))*x &
   & + a4(6))*x + a4(7))*x + a4(8))*x + a4(9)
t = ((((((((b4(1)*x + b4(2))*x + b4(3))*x + b4(4))*x + b4(5))*x &
   & + b4(6))*x + b4(7))*x + b4(8))*x + b4(9))*x + 1.d0
60 derfi = s/(x*t)
if (eps > 5.d-20) return
x = derfi
t = derfc1(1,x)
f = (log(t) - lnq) - x*x
derfi = x + r*t*f
return
!                         Error return
100 derfi = -1.d0
return
110 derfi = -2.d0
end function derfi

pure elemental real function aerf(x, h)
implicit none
real, intent(in) :: h, x
integer :: j, n, n1
real :: a2, ah, ax, dn2, e, eps, h2, h3, hf, hg, s, st, t, u, v, x2, xmh, xph, z
real, parameter :: c = 1.12837916709551257
real, parameter :: p = 2.76959
interface
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
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!             Computation of erf(x + h) - erf(x - h)
!-----------------------------------------------------------------------
!     c = 2/sqrt(pi)
!     p = ln(9*sqrt(pi))
!---------------------
!---------------------
!     **** eps is a machine dependent constant. Eps is the
!          smallest number such that 1.0 + eps .GT. 1.0 .
eps = spmpar(1)
!---------------------
aerf = 0.0
if (h == 0.0) return
ah = abs(h)
ax = abs(x)
xph = ax + ah
xmh = ax - ah
t = max(ah,ax)
t = t*t
if (1.6*t*t < eps) go to 140
if ((ax*ah)**2 < 0.5*eps) go to 150
if (ax <= ah) go to 100
if (xmh < 9.0) go to 5
if (xmh*xmh + p > -exparg(1)) return
5 if (4.0*ah*ax > -epsln(0)) go to 120
if (ax > 3.0*ah) go to 10
if (xph < 1.0) go to 110
go to 130
!-------------------------------------------------
!        For (ax less than or equal to .40)
!-------------------------------------------------
10 e = max(1.e-15,eps)
if (ax > 0.40) go to 30
h2 = xph*xph
a2 = xmh*xmh
x2 = ax + ax
st = 1.
hf = xmh
n = 0
n1 = 1
dn2 = 1.
s = 0.
20 n = n + 1
n1 = n1 + 2
dn2 = -dn2/n
st = h2*st + x2*hf
hf = a2*hf
t = st*dn2/n1
s = s + t
if (abs(t) > e*abs(s)) go to 20
s = 0.5 + (s + 0.5)
aerf = 2.0*c*ah*s
go to 45
!-------------------------------------------------
!        For (ax greater than .40)
!-------------------------------------------------
30 n = 1
j = 0
h2 = 0.
z = exp(-0.5*ax*ax)
u = 2.0*ah*c*z
h3 = z
v = 2.0*h*h
hf = 2.0*ax*ah
s = 0.
35 h2 = (hf*h3 - v*h2)/n
n = n + 1
h3 = (hf*h2 - v*h3)/n
n = n + 1
hg = h3/n
s = s + hg
if (abs(hg) > e*abs(s)) go to 35
if (j /= 0) go to 40
j = 1
go to 35
40 aerf = u*(s + z)
45 if (h < 0.0) aerf = -aerf
return
!-------------------------------------------------
!        Special cases
!-------------------------------------------------
100 if (xph < 5.8) go to 110
if (xmh > -5.6) go to 120
aerf = sign(2.0,h)
return
110 aerf = erf(xph) - erf(xmh)
if (h < 0.0) aerf = -aerf
return
120 aerf = erfc(xmh)
if (h < 0.0) aerf = -aerf
return
130 aerf = erfc(xmh) - erfc(xph)
if (h < 0.0) aerf = -aerf
return
140 aerf = 2.0*c*h*(0.5 + (0.5 - (x*x + h*h/3.0)))
return
!     The value is  2.0*exp(-x*x)*erf(h)
150 t = 2.0
x2 = x*x
if (x2 >= eps) t = 2.0*exp(-x2)
if (h*h >= 3.0*eps) go to 160
aerf = c*h*t
return
160 aerf = t*erf(h)
end function aerf

pure elemental double precision function daerf(x, h)
implicit none
intrinsic :: erf, erfc
double precision, intent(in) :: x, h
integer :: j
double precision :: ah, ax, a2, dn2, e, eps, hf, hg, h2, h3, n, n1, s, st, t, u, v, xmh, xph, x2, z
double precision, parameter :: c = 1.12837916709551257389615890312155d0
double precision, parameter :: p = 2.76959d0
interface
   pure elemental function depsln(l)
      implicit none
      integer, intent(in) :: l
      double precision :: depsln
   end function depsln
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function dxparg(l)
      implicit none
      integer, intent(in) :: l
      double precision :: dxparg
   end function dxparg
end interface
!-----------------------------------------------------------------------
!             Computation of erf(x + h) - erf(x - h)
!-----------------------------------------------------------------------
!---------------------
!     c = 2/sqrt(pi)
!     p = ln(9*sqrt(pi))
!---------------------
!---------------------
!     **** eps is a machine dependent constant. Eps is the
!          smallest number such that 1.D0 + eps .GT. 1.D0 .
eps = dpmpar(1)
!---------------------
daerf = 0.d0
if (h == 0.d0) return
ah = abs(h)
ax = abs(x)
xph = ax + ah
xmh = ax - ah
t = max(ah,ax)
t = t*t
if (1.6d0*t*t < eps) go to 140
if ((ax*ah)**2 < 0.5d0*eps) go to 150
if (ax <= ah) go to 100
if (xmh < 9.d0) go to 5
if (xmh*xmh + p > -dxparg(1)) return
5 if (4.d0*ah*ax > -depsln(0)) go to 120
if (ax > 3.d0*ah) go to 10
if (xph < 1.d0) go to 110
go to 130
!-------------------------------------------------
!        For (ax less than or equal to .40)
!-------------------------------------------------
10 e = max(1.d-30,eps)
if (ax > 0.4d0) go to 30
h2 = xph*xph
a2 = xmh*xmh
x2 = ax + ax
st = 1.d0
hf = xmh
n = 0.d0
n1 = 1.d0
dn2 = 1.d0
s = 0.d0
20 n = n + 1.d0
n1 = n1 + 2.d0
dn2 = -dn2/n
st = h2*st + x2*hf
hf = a2*hf
t = st*dn2/n1
s = s + t
if (abs(t) > e*abs(s)) go to 20
s = 0.5d0 + (0.5d0 + s)
daerf = 2.d0*c*ah*s
go to 45
!-------------------------------------------------
!        For (ax greater than .40)
!-------------------------------------------------
30 n = 1.d0
j = 0
h2 = 0.d0
z = exp(-0.5d0*ax*ax)
u = 2.d0*ah*c*z
h3 = z
v = 2.d0*h*h
hf = 2.d0*ax*ah
s = 0.d0
35 h2 = (hf*h3 - v*h2)/n
n = n + 1.d0
h3 = (hf*h2 - v*h3)/n
n = n + 1.d0
hg = h3/n
s = s + hg
if (abs(hg) > e*abs(s)) go to 35
if (j /= 0) go to 40
j = 1
go to 35
40 daerf = u*(s + z)
45 if (h < 0.d0) daerf = -daerf
return
!-------------------------------------------------
!        Special cases
!-------------------------------------------------
100 if (xph < 8.5d0) go to 110
if (xmh > -8.3d0) go to 120
daerf = sign(2.d0,h)
return
110 daerf = erf(xph) - erf(xmh)
if (h < 0.d0) daerf = -daerf
return
120 daerf = erfc(xmh)
if (h < 0.d0) daerf = -daerf
return
130 daerf = erfc(xmh) - erfc(xph)
if (h < 0.d0) daerf = -daerf
return
140 daerf = 2.d0*c*h*(0.5d0 + (0.5d0 - (x*x + h*h/3.d0)))
return
!     The value is  2.0*exp(-x*x)*erf(h)
150 t = 2.d0
x2 = x*x
if (x2 >= eps) t = 2.d0*exp(-x2)
if (h*h >= 3.d0*eps) go to 160
daerf = c*h*t
return
160 daerf = t*erf(h)
end function daerf

pure elemental function pndf(x,ind)
implicit none
integer, intent(in) :: ind
real, intent(in) :: x
real :: t
real :: pndf
real, parameter :: a = .707106781186548
real, parameter :: c = .797884560802865
interface
   pure elemental function erfc1(ind,x)
      implicit none
      integer, intent(in) :: ind
      real, intent(in) :: x
      real :: erfc1
   end function erfc1
end interface
!     ---------------
!     a = 1/sqrt(2)
!     c = sqrt(2/pi)
!     ---------------
!     ---------------
t = a*x
if (ind /= 0) go to 20
if (x < -8.0) go to 10
pndf = 0.5*erfc1(0,-t)
return
10 pndf = c/erfc1(1,-t)
return
20 if (x > 8.0) go to 30
pndf = 0.5*erfc1(0,t)
return
30 pndf = c/erfc1(1,t)
end function pndf

pure elemental subroutine pni(p, q, d, w, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: d, p, q
real, intent(inout) :: w
real :: eps, t, u, v
real, parameter :: rt2 = 1.414213562373095
interface
   pure elemental function erfi(p,q)
      implicit none
      real, intent(in) :: p
      real, intent(in) :: q
      real :: erfi
   end function erfi
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!         Evaluation of the inverse normal distribution function
!                           ------------
!     Let F(t) = 1/(sqrt(2*pi)*exp(-t*t/2)). Then the function
!        prob(X) = Integral from minus infinity to X of F(t)
!     is the normal distribution function of zero mean and unit
!     variance. It is assumed that p .GT. 0, q .GT. 0, p + q = 1,
!     and d = p - 0.5. The value w is computed where prob(w) = p.
!     ierr is a variable that reports the status of the results.
!       ierr = 0  No input errors were detected. w was computed.
!       ierr = 1  Either p or q is incorrect.
!       ierr = 2  d IS INCORRECT.
!-----------------------------------------------------------------------
!     rt2 = sqrt(2)
!------------------------
!------------------------
t = min(p,q)
if (t <= 0.0) go to 10
eps = max(spmpar(1),1.e-15)
w = 0.5 + (0.5 - (p + q))
if (abs(w) > 2.0*eps) go to 10
u = abs(d + d)
v = t + t
w = erfi(u, v)
if (w < 0.0) go to 20
ierr = 0
w = rt2*w
if (d < 0.0) w = - w
return
!                         Error return
10 ierr = 1
return
20 ierr = 2
end subroutine pni

pure elemental subroutine dpni(p, q, d, w, ierr)
implicit none
integer, intent(inout) :: ierr
double precision, intent(in) :: p, q, d
double precision, intent(inout) :: w
double precision :: eps, u, v, t
double precision, parameter :: rt2 = 1.4142135623730950488016887242097d0
interface
   pure elemental function derfi(p,q)
      implicit none
      double precision, intent(in) :: p
      double precision, intent(in) :: q
      double precision :: derfi
   end function derfi
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!         Evaluation of the inverse normal distribution function
!                           ------------
!     Let F(t) = 1/(sqrt(2*pi)*exp(-t*t/2)). Then the function
!        prob(X) = Integral from minus infinity to X of F(t)
!     is the normal distribution function of zero mean and unit
!     variance. It is assumed that p .GT. 0, q .GT. 0, p + q = 1,
!     and d = p - 0.5. The value w is computed where prob(w) = p.
!     ierr is a variable that reports the status of the results.
!       ierr = 0  No input errors were detected. w was computed.
!       ierr = 1  Either p or q is incorrect.
!       ierr = 2  d IS INCORRECT.
!-----------------------------------------------------------------------
!------------------------
!     rt2 = sqrt(2)
!------------------------
!------------------------
t = min(p,q)
if (t <= 0.d0) go to 10
eps = dpmpar(1)
w = 0.5d0 + (0.5d0 - (p + q))
if (abs(w) > 2.d0*eps) go to 10
u = abs(d + d)
v = t + t
w = derfi(u, v)
if (w < 0.d0) go to 20
ierr = 0
w = rt2*w
if (d < 0.d0) w = - w
return
!                         Error return
10 ierr = 1
return
20 ierr = 2
end subroutine dpni

pure elemental real function daw(x)
implicit none
real, intent(in) :: x
integer :: i
real :: frac, sump, sumq, w2, y
real, parameter :: xlarge = 16777216.0
real, parameter :: xsmall = .59604644775391e-07
real, parameter :: p1(9) = [.100000000000000e+01, -.135599049815353e+00, .456738974064825e-01, -.258323495918050e-02, &
   & .360079463580992e-03, -.944375029163387e-05, .634674256878843e-06, -.711645839183817e-08, .977985913592343e-10]
real, parameter :: q1(9) = [.100000000000000e+01, .531067616851310e+00, .133052308640737e+00, .206907491644210e-01, &
   & .220437428972266e-02, .166706801664365e-03, .887964712053131e-05, .311750854173480e-06, .574807177698046e-08]
real, parameter :: p2(8) = [-.150695651187161e+01, .293365747395449e+02, -.400000893643550e+02, -.757931918089369e-01, - &
   & .889106479747812e+01, .152644099623699e+02, -.597678086823489e+01, .500236896088668e+00]
real, parameter :: q2(7) = [-.673106069744813e+00, .124486788262252e+04, .721193217600229e+01, .112461662024575e+03, &
   & .729177556415532e+02, .115840292551888e+03, .226064666074309e+00]
real, parameter :: p3(8) = [.476405645273229e+01, -.266167674896399e+02, -.916804879813552e+01, -.150507703496692e+02, &
   & .506460153742231e+01, -.498544802986608e+01, -.149838042036691e+01, .499999902705054e+00]
real, parameter :: q3(7) = [.287776122973187e+03, .256105722342226e+02, .751701277744067e+02, .146515167783109e+03, &
   & .330707724676114e+02, -.148715811787195e+01, .250011459611839e+00]
real, parameter :: p4(7) = [-.315576735766984e+02, -.100791496592972e+02, -.710713709224200e+01, -.596879853243925e+01, - &
   & .449773645376092e+01, -.249999965398199e+01, .499999999999330e+00]
real, parameter :: q4(6) = [.168874162155616e+03, .698280748271071e+01, -.213029621139181e+02, -.712157348463305e+01, - &
   & .250005973192356e+01, .750000000715687e+00]
!-----------------------------------------------------------------------
!     This function computes single precision values of dawsons
!     integral,
!        exp(-x*x) * integral (from 0 to x) exp(T*T) DT,
!     defined for all real arguments.
!     The main computation involves evaluation of rational Chebyshev
!     approximations published in math. Comp. 24, 171-178(1970) By
!     Cody, Paciorek and Thacher.
!-----------------------------------------------------------------------
!---------------
!---------------
!           Coefficients for R(8,8) approximation,
!           used for abs(x)  .LT.  2.5
!---------------
!---------------
!           Coefficients for R(7,7) approximation,
!           in J-fraction form, used for
!           2.5 .LE. abs(x) .LT. 3.5
!---------------
!---------------
!           Coefficients for R(7,7) approximation,
!           in J-fraction form, used for
!           3.5 .LE. abs(x) .LE. 5.0
!---------------
!---------------
!           Coefficients for R(6,6) approximation,
!           in J-fraction form, used for abs(x) .GT. 5.0
!---------------
!-----------------------------------------------------------------------
if (abs(x) > xlarge) go to 500
if (abs(x) < xsmall) go to 600
y = x * x
if (y >= 6.25e0) go to 200
!     ---------- abs(x) .LT. 2.5 ----------
sump = (((((((p1(9) * y + p1(8)) * y + p1(7)) * y + p1(6)) &
   & * y + p1(5)) * y + p1(4)) * y + p1(3)) * y + p1(2)) &
   & * y + p1(1)
sumq = (((((((q1(9) * y + q1(8)) * y + q1(7)) * y + q1(6)) &
   & * y + q1(5)) * y + q1(4)) * y + q1(3)) * y + q1(2)) &
   & * y + q1(1)
daw = x * sump / sumq
go to 1000
!     ---------- 2.5 .LE. abs(x) .LT. 3.5 ----------
200 if (y >= 12.25e0) go to 300
frac = 0.0e0
do i = 1, 7
   frac = q2(i) / (p2(i) + y + frac)
end do
daw = (p2(8) + frac) / x
go to 1000
!     ---------- 3.5 .LE. abs(x) .LT. 5.0 ----------
300 if (y >= 25.0e0) go to 400
frac = 0.0e0
do i = 1, 7
   frac = q3(i) / (p3(i) + y + frac)
end do
daw = (p3(8) + frac) / x
go to 1000
!     ---------- 5.0 .LE. abs(x) .LE. xlarge ----------
400 w2 = 1.0e0 / x / x
frac = 0.0e0
do i = 1, 6
   frac = q4(i) / (p4(i) + y + frac)
end do
frac = p4(7) + frac
daw = (0.5e0 + 0.5e0 * w2 * frac) / x
go to 1000
!     ---------- xlarge .LT. abs(x) ----------
500 daw = 0.5e0 / x
go to 1000
!     ---------- Return for small x ----------
600 daw = x
1000 return
end function daw

pure elemental double precision function dpdaw(x)
implicit none
double precision, intent(in) :: x
integer :: i, k
double precision :: ax, t, w
double precision, parameter :: eps = 1.d-31
double precision, parameter :: a(20) = [-.6666666666666666666666666666657d+00, &
   & .2666666666666666666666666665302d+00, -.7619047619047619047619046823290d-01, .1693121693121693121693097101950d-01, - &
   & .3078403078403078403073750370528d-02, .4736004736004736004148385001356d-03, -.6314672981339647953899064401849d-04, &
   & .7429027036870170692270376716931d-05, -.7820028459863171536925638117632d-06, .7447646152244351276445219666744d-07, - &
   & .6476214045244314289022051868963d-08, .5180971231894821888421654461823d-09, -.3837756389504541092817011259727d-10, &
   & .2646727414301012080897585412600d-11, -.1707553348198261876085879075486d-12, .1034770025122653524451023758330d-13, - &
   & .5905667147861158816695814259561d-15, .3157018166820009192834256496230d-16, -.1501742103181747984387915732309d-17, &
   & .4921379778280206677674574916266d-19]
double precision, parameter :: b(45) = [-.56886544105215527114160533733674d-01, - &
   & .31811346996168131279322878048822d+00, .20873845413642236789741580198858d+00, -.12475409913779131214073498314784d+00, &
   & .67869305186676777092847516423676d-01, -.33659144895270939503068230966587d-01, .15260781271987971743682460381640d-01, - &
   & .63483709625962148230586094788535d-02, .24326740920748520596865966109343d-02, -.86219541491065032038526983549637d-03, &
   & .28376573336321625302857636538295d-03, -.87057549874170423699396581464335d-04, .24986849985481658331800044137276d-04, - &
   & .67319286764160294344603050339520d-05, .17078578785573543710504524047844d-05, -.40917551226475381271896592490038d-06, &
   & .92828292216755773260751785312273d-07, -.19991403610147617829845096332198d-07, .40963490644082195241210487868917d-08, - &
   & .80032409540993168075706781753561d-09, .14938503128761465059143225550110d-09, -.26687999885622329284924651063339d-10, &
   & .45712216985159458151405617724103d-11, -.75187305222043565872243727326771d-12, .11893100052629681879029828987302d-12, - &
   & .18116907933852346973490318263084d-13, .26611733684358969193001612199626d-14, -.37738863052129419795444109905930d-15, &
   & .51727953789087172679680082229329d-16, -.68603684084077500979419564670102d-17, .88123751354161071806469337321745d-18, - &
   & .10974248249996606292106299624652d-18, .13261199326367178513595545891635d-19, -.15562732768137380785488776571562d-20, &
   & .17751425583655720607833415570773d-21, -.19695006967006578384953608765439d-22, .21270074896998699661924010120533d-23, - &
   & .22375398124627973794182113962666d-24, .22942768578582348946971383125333d-25, -.22943788846552928693329592319999d-26, &
   & .22391702100592453618342297600000d-27, -.21338230616608897703678225066666d-28, .19866196585123531518028458666666d-29, - &
   & .18079295866694391771955199999999d-30, .16090686015283030305450666666666d-31]
interface
   pure function dcsevl(x,a,n)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: x
      double precision, intent(in) :: a(n)
      double precision :: dcsevl
   end function dcsevl
   pure elemental function dpdaw0(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dpdaw0
   end function dpdaw0
end interface
!-----------------------------------------------------------------------
!            Double precision computation of dawsons integral
!-----------------------------------------------------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
ax = abs(x)
if (ax >= 4.d0) go to 30
t = x*x
if (ax > 1.d0) go to 20
!                       abs(x) .LE. 1
dpdaw = x
if (t < eps) return
w = a(20)
do i = 1,19
   k = 20 - i
   w = t*w + a(k)
end do
dpdaw = x * (0.75d0 + (0.25d0 + t*w))
return
!                    1 .LT. abs(x) .LT. 4
20 dpdaw = x * (.25d0 + dcsevl(.125d0*t - 1.d0, b, 45))
return
!                       abs(x) .GE. 4
30 dpdaw = dpdaw0(ax)/x
end function dpdaw

pure elemental double precision function dpdaw0(x)
implicit none
!-----------------------------------------------------------------------
!                Evaluation of x*daw(x) for x .GE. 4
!                where daw(x) is the Dawson integral
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: t, u, v, w
double precision, parameter :: a0 = .59682223611279114961181337d-06
double precision, parameter :: a1 = .17685355947137064277328544d-05
double precision, parameter :: a2 = .46539151619719879425847199d-05
double precision, parameter :: a3 = .60206549750426063518629015d-05
double precision, parameter :: a4 = .71968323029042065431569341d-05
double precision, parameter :: a5 = .30632314265730271259576310d-05
double precision, parameter :: a6 = .58023977792358623878717970d-06
double precision, parameter :: a7 = -.79009104459686847104040749d-06
double precision, parameter :: a8 = -.48136647436848802449955585d-06
double precision, parameter :: a9 = .15516701696125663593787151d-05
double precision, parameter :: a10 = .41907470564012404920368069d-05
double precision, parameter :: a11 = .58027971313506864533128271d-05
double precision, parameter :: a12 = .55370618938769991926278955d-05
double precision, parameter :: a13 = .38921890500515083447099834d-05
double precision, parameter :: a14 = .20373391058442140223632125d-05
double precision, parameter :: a15 = .77894504402267231707108862d-06
double precision, parameter :: a16 = .20671717275442647450228015d-06
double precision, parameter :: a17 = .34163346266402336952767687d-07
double precision, parameter :: a18 = .26550833614486808486653527d-08
double precision, parameter :: b1 = .24655153970246619491575782d+01
double precision, parameter :: b2 = .62943144539382480033771054d+01
double precision, parameter :: b3 = .62122304537339562619049238d+01
double precision, parameter :: b4 = .72256247680648550388609993d+01
double precision, parameter :: c0 = .59682220964671964619429990d-06
double precision, parameter :: c1 = .15714896176335781761895194d-05
double precision, parameter :: c2 = .38969553030269966874001463d-05
double precision, parameter :: c3 = .52383725295173020317044495d-05
double precision, parameter :: c4 = .68105053752194312932660379d-05
double precision, parameter :: c5 = .54424292166005622934118953d-05
double precision, parameter :: c6 = .42426204827598626398351706d-05
double precision, parameter :: c7 = .16034175582037599078896885d-05
double precision, parameter :: c8 = .40869743822567069272296881d-06
double precision, parameter :: c9 = -.28877279517645392833652391d-06
double precision, parameter :: c10 = -.23330912423546272053845073d-06
double precision, parameter :: c11 = -.52391219684126122047201575d-07
double precision, parameter :: c12 = .21002079856304960793765863d-07
double precision, parameter :: c13 = .15999459808634652894884878d-07
double precision, parameter :: c14 = .30942877932880022278704223d-08
double precision, parameter :: d1 = .21353586303464124681525146d+01
double precision, parameter :: d2 = .51903635881846225790635588d+01
double precision, parameter :: d3 = .55426108503039000945912263d+01
double precision, parameter :: d4 = .72404445472735688881512590d+01
double precision, parameter :: d5 = .42043425514299588216548098d+01
double precision, parameter :: d6 = .39555198251457455938284071d+01
double precision, parameter :: d7 = .96558431899415447517392039d+00
double precision, parameter :: d8 = .85802563214754700974536646d+00
double precision, parameter :: e0 = .59682220964671964619429989d-06
double precision, parameter :: e1 = .84093250039847132132545694d-06
double precision, parameter :: e2 = .21215362314612857942015465d-05
double precision, parameter :: e3 = .17544801458346344458699925d-05
double precision, parameter :: e4 = .23300467572238537581015267d-05
double precision, parameter :: e5 = .10789302963153438789721000d-05
double precision, parameter :: e6 = .84593690165753140097573765d-06
double precision, parameter :: e7 = .58921927492401852305814815d-07
double precision, parameter :: e8 = .88699252882391671775568852d-08
double precision, parameter :: e9 = -.45367333700483839577191791d-07
double precision, parameter :: e10 = -.57476692572774473717756092d-08
double precision, parameter :: f1 = .91128032791938035312580060d+00
double precision, parameter :: f2 = .28248447610354665352098820d+01
double precision, parameter :: f3 = .12208226691968579661669930d+01
double precision, parameter :: f4 = .26127044898109340807106578d+01
double precision, parameter :: f5 = .34850941500747816686718301d+00
double precision, parameter :: f6 = .11058424028893031129155960d+01
double precision, parameter :: f7 = -.58583432304677947215235382d-01
double precision, parameter :: f8 = .22235753204903993496120223d+00
double precision, parameter :: f9 = -.22116625272550591073419658d-01
double precision, parameter :: f10 = .14938281115881437851795141d-01
double precision, parameter :: g0 = .59682220962853689178993039d-06
double precision, parameter :: g1 = .10399202637216492921747166d-05
double precision, parameter :: g2 = .20011159669496258291170369d-05
double precision, parameter :: g3 = .19689301951834731308289277d-05
double precision, parameter :: g4 = .18861506874082130108404839d-05
double precision, parameter :: g5 = .10403672611266773427898830d-05
double precision, parameter :: g6 = .42700287233074049241986613d-06
double precision, parameter :: g7 = -.16199303908856237550380048d-07
double precision, parameter :: g8 = -.73900110466591484816182863d-07
double precision, parameter :: g9 = -.21369058482679700785965255d-07
double precision, parameter :: g10 = .42853587024761116737793072d-08
double precision, parameter :: g11 = -.27226352610679391576406666d-09
double precision, parameter :: h1 = .12446924554654251972427023d+01
double precision, parameter :: h2 = .24571243397858142676189669d+01
double precision, parameter :: h3 = .16710488988253927773151334d+01
double precision, parameter :: h4 = .17260859791081983044753913d+01
double precision, parameter :: h5 = .67406536368694046314885196d+00
double precision, parameter :: h6 = .47403526893401885333000527d+00
double precision, parameter :: h7 = .96251479080923959509108658d-01
double precision, parameter :: h8 = .53334517885765587426678624d-01
double precision, parameter :: h9 = .39450307003297031975491216d-02
double precision, parameter :: h10 = .20209221166462656808887976d-02
double precision, parameter :: s0 = .8210986449041747719684610504710d-02
double precision, parameter :: s1 = .8646073144815053170065230898334d-02
double precision, parameter :: s2 = .4768322737615973285410030924398d-03
double precision, parameter :: s3 = .4792593707378225992657970685396d-04
double precision, parameter :: s4 = .7507677744363576693833551190204d-05
double precision, parameter :: s5 = .1737929446861228512373840727547d-05
double precision, parameter :: p0 = .29531250000000000000002d+02
double precision, parameter :: p1 = -.14571781607273299440392d+04
double precision, parameter :: p2 = .24285318385898860175073d+05
double precision, parameter :: p3 = -.15843555052114168113822d+06
double precision, parameter :: p4 = .32969397422638395586636d+06
double precision, parameter :: p5 = -.55331506994311967089636d+04
double precision, parameter :: q1 = -.54843599093412230906873d+02
double precision, parameter :: q2 = .10882497826844164906477d+04
double precision, parameter :: q3 = -.96578534881552358457185d+04
double precision, parameter :: q4 = .37803382357862589384458d+05
double precision, parameter :: q5 = -.51283783372259864777146d+05
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
!----------------------------
if (x >= 12.d0) go to 50
t = (32.d0/(x*x) - 0.5d0) - 0.5d0
if (t >= 0.d0) go to 20
!                    -7/9 .LE. t .LE. -0.4
if (t > -0.4d0) go to 10
u = ((((((((a18*t + a17)*t + a16)*t + a15)*t + a14)*t + &
   & a13)*t + a12)*t + a11)*t + a10)*t + a9
u = ((((((((u*t + a8)*t + a7)*t + a6)*t + a5)*t + &
   & a4)*t + a3)*t + a2)*t + a1)*t + a0
v = (((b4*t + b3)*t + b2)*t + b1)*t + 1.d0
go to 40
!                     -0.4 .LT. t .LT. 0
10 u = ((((((((c14*t + c13)*t + c12)*t + c11)*t + c10)*t + &
   & c9)*t + c8)*t + c7)*t + c6)*t + c5
u = ((((u*t + c4)*t + c3)*t + c2)*t + c1)*t + c0
v = (((((((d8*t + d7)*t + d6)*t + d5)*t + d4)*t + &
   & d3)*t + d2)*t + d1)*t + 1.d0
go to 40
!                      0 .LE. t .LE. 0.4
20 if (t > 0.4d0) go to 30
u = (((((((((e10*t + e9)*t + e8)*t + e7)*t + e6)*t + &
   & e5)*t + e4)*t + e3)*t + e2)*t + e1)*t + e0
v = (((((((((f10*t + f9)*t + f8)*t + f7)*t + f6)*t + &
   & f5)*t + f4)*t + f3)*t + f2)*t + f1)*t + 1.d0
go to 40
!                      0.4 .LT. t .LE. 1
30 u = ((((((((g11*t + g10)*t + g9)*t + g8)*t + g7)*t + &
   & g6)*t + g5)*t + g4)*t + g3)*t + g2
u = (u*t + g1)*t + g0
v = (((((((((h10*t + h9)*t + h8)*t + h7)*t + h6)*t + &
   & h5)*t + h4)*t + h3)*t + h2)*t + h1)*t + 1.d0
!          The above four minimax approximations u/v
!          are accurate to within 1 unit of the 25-TH
!          significant digit. Thus, the approximation
!          for w is accurate to within 1 unit of the
!          29-TH significant digit.
40 w = ((((((u/v)*t + s5)*t + s4)*t + s3)*t + s2)*t + &
   & s1)*t + s0
dpdaw0 = 0.5d0 + w
return
!                          x .GE. 12
50 t = (1.d0/x)**2
w = (((((p5*t + p4)*t + p3)*t + p2)*t + p1)*t + p0)/ &
   & (((((q5*t + q4)*t + q3)*t + q2)*t + q1)*t + 1.d0)
w = ((((w*t + 6.5625d0)*t + 1.875d0)*t + 0.75d0)*t + &
   & 0.5d0)*t + 1.d0
dpdaw0 = 0.5d0*w
end function dpdaw0

pure elemental subroutine cfrnli(mo, z, w)
implicit none
integer, intent(in) :: mo
complex, intent(in) :: z
complex, intent(inout) :: w
integer :: i
real :: dm, pm, qm, r, ss, x, y, qf(2), sm(2), tm(2), ts(2), zr(2)
real, parameter :: c = .564189583547756
real, parameter :: c0 = -.707106781186548
real, parameter :: cd(18) = [0.00000000000000e00, 2.08605856013476e-2, 8.29806940495687e-2, 1.85421653326079e-1, &
   & 3.27963479382361e-1, 5.12675279912828e-1, 7.45412958045105e-1, 1.03695067418297e00, 1.40378061255437e00, 1.86891662214001e00, &
   & 2.46314830523929e00, 3.22719383737352e00, 4.21534348280013e00, 5.50178873151549e00, 7.19258966683102e00, 9.45170208076408e00, &
   & 1.25710718314784e+1, 1.72483537216334e+1]
real, parameter :: ce(18) = [8.15723083324096e-2, 1.59285285253437e-1, 1.48581625614499e-1, 1.33219670836245e-1, &
   & 1.15690392878957e-1, 9.78580959447535e-2, 8.05908834297624e-2, 6.40204538609872e-2, 4.81445242767885e-2, 3.33540658473295e-2, &
   & 2.05548099470193e-2, 1.07847403887506e-2, 4.55634892214219e-3, 1.43984458138925e-3, 3.07056139834171e-4, 3.78156541168541e-5, &
   & 2.05173509616121e-6, 2.63564823682747e-8]
interface
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!            Computation of the complex fresnel integral E(z)
!                           ----------------
!                      w = E(z)          IF mo = 0
!                      w = exp(-z)*e(z)  otherwise
!-----------------------------------------------------------------------
!------------------------
!     c = 1/sqrt(pi)
!     c0 = -1/sqrt(2)
!------------------------
!------------------------
!------------------------
x = real(z)
y = aimag(z)
r = cpabs(x, y)
if (r == 0.0) go to 200
!              Evaluation of zr = sqrt(2*z/PI)
if (x >= 0.0) go to 10
zr(2) = sqrt(r - x)
zr(1) = y/zr(2)
go to 11
10 zr(1) = sqrt(r + x)
if (y < 0.0) zr(1) = -zr(1)
zr(2) = y/zr(1)
11 zr(1) = c*zr(1)
zr(2) = c*zr(2)
if (r <= 1.0) go to 20
if (r >= 38.0) go to 60
if (x < 0.016*y*y) go to 50
!                       Taylor series
20 sm(1) = 0.0
sm(2) = 0.0
tm(1) = zr(1)
tm(2) = zr(2)
pm = 0.0
30 pm = pm + 1.0
dm = 2.0*pm + 1.0
ts(1) = tm(1)*x - tm(2)*y
ts(2) = tm(1)*y + tm(2)*x
tm(1) = ts(1)/pm
tm(2) = ts(2)/pm
ts(1) = tm(1)/dm
ts(2) = tm(2)/dm
if (abs(sm(1)) + abs(ts(1)) /= abs(sm(1))) go to 31
if (abs(sm(2)) + abs(ts(2)) == abs(sm(2))) go to 40
31 sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
go to 30
40 sm(1) = zr(1) + sm(1)
sm(2) = (c0 + zr(2)) + sm(2)
if (mo == 0) go to 120
qm = exp(-x)
qf(1) = qm*cos(-y)
qf(2) = qm*sin(-y)
go to 110
!              Rational function APPROXIMATION
50 sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = x - cd(i)
   ts(2) = y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ts(1) = zr(1)*sm(1) - zr(2)*sm(2)
ts(2) = zr(1)*sm(2) + zr(2)*sm(1)
sm(1) = 0.5*ts(1)
sm(2) = 0.5*ts(2)
go to 100
!                   Asymptotic expansion
60 qf(1) = (x/r)/r
qf(2) = -(y/r)/r
tm(1) = qf(1)
tm(2) = qf(2)
sm(1) = tm(1)
sm(2) = tm(2)
pm = -0.5
70 pm = pm + 1.0
ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
tm(1) = pm*ts(1)
tm(2) = pm*ts(2)
if (abs(sm(1)) + abs(tm(1)) /= abs(sm(1))) go to 71
if (abs(sm(2)) + abs(tm(2)) == abs(sm(2))) go to 80
71 sm(1) = sm(1) + tm(1)
sm(2) = sm(2) + tm(2)
if (pm < 25.5) go to 70
80 ts(1) = zr(1)*sm(1) - zr(2)*sm(2)
ts(2) = zr(1)*sm(2) + zr(2)*sm(1)
sm(1) = 0.5*ts(1)
sm(2) = 0.5*ts(2)
if (zr(2) < 8.e-3) go to 210
!                       Termination
100 if (mo /= 0) go to 120
qm = exp(x)
qf(1) = qm*cos(y)
qf(2) = qm*sin(y)
110 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
120 w = cmplx(sm(1),sm(2))
return
!                      Case when z = 0
200 w = cmplx(0.0,c0)
return
!               Modified asymptotic expansion
210 if (mo /= 0) go to 220
qm = exp(x)
qf(1) = qm*cos(y)
qf(2) = qm*sin(y)
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
w = cmplx(ts(1), c0 + ts(2))
return
220 if (-x <= exparg(1)) go to 120
qm = c0*exp(-x)
sm(1) = sm(1) + qm*sin(y)
sm(2) = sm(2) + qm*cos(y)
w = cmplx(sm(1),sm(2))
end subroutine cfrnli

pure elemental subroutine frnl(t, c, s)
implicit none
real, intent(inout) :: c, s
real, intent(in) :: t
integer :: i, l, m, max
real :: cy, f, fd, fn, g, gd, gn, pix, pixx, r, sy, x, xx, y, n
real, parameter :: pi = 3.1415926535898
real, parameter :: a(6) = [-.119278241233760e-05, .540730666359417e-04, -.160488306381990e-02, .281855008757077e-01, - &
   & .246740110027210e+00, .100000000000000e+01]
real, parameter :: b(6) = [-.155653074871090e-06, .844415353045065e-05, -.312116934326082e-03, .724478420395276e-02, - &
   & .922805853580325e-01, .523598775598300e+00]
real, parameter :: cp(13) = [.114739945188034e-20, -.384444827287950e-18, .832125729394275e-16, -.142979507360076e-13, &
   & .198954961821465e-11, -.220226545457144e-09, .188434924092257e-07, -.120009722914157e-05, .540741337442140e-04, - &
   & .160488313553028e-02, .281855008777956e-01, -.246740110027196e+00, .999999999999996e+00]
real, parameter :: sp(13) = [.705700784853927e-22, -.252757991492418e-19, .594117488940008e-17, -.112161631555448e-14, &
   & .173332189994074e-12, -.215742302078015e-10, .210821173208116e-08, -.156471443116560e-06, .844427287845253e-05, - &
   & .312116942346186e-03, .724478420418951e-02, -.922805853580323e-01, .523598775598300e+00]
real, parameter :: pn(6) = [.318309816100920e+00, .134919391391516e+02, .158258097490377e+03, .598796451682535e+03, &
   & .632369782194966e+03, .967985390141920e+02]
real, parameter :: pd(6) = [.100000000000000e+01, .426900960480796e+02, .509085485682426e+03, .200034664144742e+04, &
   & .231910140792937e+04, .486678558201084e+03]
real, parameter :: qn(6) = [.101320876178478e+00, .490534697099052e+01, .652095157811808e+02, .274183825747887e+03, &
   & .305040725009211e+03, .364566615872326e+02]
real, parameter :: qd(6) = [.100000000000000e+01, .499330024470621e+02, .709854097670206e+03, .343470762861172e+04, &
   & .522213879312684e+04, .168801831831851e+04]
real, parameter :: an(6) = [.318309885869756e+00, .254179177393500e+02, .575003792540838e+03, .426673405867140e+04, &
   & .891831887923938e+04, .267955736537967e+04]
real, parameter :: ad(6) = [.100000000000000e+01, .801567066285184e+02, .182971463354850e+04, .138848884373420e+05, &
   & .309228411873207e+05, .120421274105856e+05]
real, parameter :: bn(6) = [.101321181932417e+00, .925021984290547e+01, .240932023056602e+03, .206079616836437e+04, &
   & .484901973010149e+04, .130680669688315e+04]
real, parameter :: bd(6) = [.100000000000000e+01, .928158182389149e+02, .250926840439955e+04, .233924458152954e+05, &
   & .685638896406835e+05, .418593101455019e+05]
real, parameter :: cn(5) = [.318309886182000e+00, .299191968327887e+02, .691428839605668e+03, .394539800974744e+04, &
   & .290314254767015e+04]
real, parameter :: cd(5) = [.100000000000000e+01, .942978925136851e+02, .219977296283666e+04, .129726479671006e+05, &
   & .114991427758165e+05]
real, parameter :: dn(5) = [.101321183630876e+00, .110988033615242e+02, .306282306497228e+03, .213130259794164e+04, &
   & .171270676541694e+04]
real, parameter :: dd(5) = [.100000000000000e+01, .111060616085627e+03, .318197586347414e+04, .249342095714049e+05, &
   & .359241903823488e+05]
real, parameter :: fp(7) = [.449763389301234e+05, -.188763642051836e+04, .669261097103246e+02, -.343966606879114e+01, &
   & .343112896133346e+00, -.967546019461500e-01, .318309886183465e+00]
real, parameter :: gp(7) = [.316642183365360e+06, -.120618995106638e+05, .359164749179351e+03, -.142252603258172e+02, &
   & .982934118445454e+00, -.153989722912325e+00, .101321183639714e+00]
real, parameter :: p(6) = [-654729075.0, 2027025.0, -10395.0, 105.0, -3.0, 1.0]
real, parameter :: q(6) = [-13749310575.0, 34459425.0, -135135.0, 945.0, -15.0, 1.0]
interface
   pure elemental function cos1(x)
      implicit none
      real, intent(in) :: x
      real :: cos1
   end function cos1
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
   pure elemental function sin1(x)
      implicit none
      real, intent(in) :: x
      real :: sin1
   end function sin1
end interface
!-----------------------------------------------------------------------
!             Evaluation of the real fresnel integrals
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!     ****** max is a machine dependent constant. Max is the
!            largest positive integer that may be used.
max = ipmpar(3)
!-----------------------------------------------------------------------
x = abs(t)
if (x > 4.0) go to 50
xx = x*x
y = xx*xx
!-----------------------------------------------------------------------
!             Evaluation of c(x) and s(x) for x .LT. 1.65
!                          WHERE x = abs(t)
!-----------------------------------------------------------------------
if (x > 0.6) go to 10
c = ((((a(1)*y + a(2))*y + a(3))*y + a(4))*y + a(5))*y + a(6)
s = ((((b(1)*y + b(2))*y + b(3))*y + b(4))*y + b(5))*y + b(6)
c = t*c
s = t*xx*s
return
10 if (x >= 1.65) go to 20
c = cp(1)
s = sp(1)
do i = 2,13
   c = cp(i) + c*y
   s = sp(i) + s*y
end do
c = t*c
s = t*xx*s
return
!-----------------------------------------------------------------------
!          Evaluation of the auxiliary functions f(x) and g(x)
!                        FOR x .GE. 1.65
!-----------------------------------------------------------------------
20 if (x >= 2.0) go to 30
fn = ((((pn(1)*y + pn(2))*y + pn(3))*y + pn(4))*y + pn(5))*y &
   & + pn(6)
fd = ((((pd(1)*y + pd(2))*y + pd(3))*y + pd(4))*y + pd(5))*y &
   & + pd(6)
gn = ((((qn(1)*y + qn(2))*y + qn(3))*y + qn(4))*y + qn(5))*y &
   & + qn(6)
gd = ((((qd(1)*y + qd(2))*y + qd(3))*y + qd(4))*y + qd(5))*y &
   & + qd(6)
f = fn/(x*fd)
g = gn/(x*xx*gd)
y = 0.5*xx
go to 80
30 if (x >= 3.0) go to 40
fn = ((((an(1)*y + an(2))*y + an(3))*y + an(4))*y + an(5))*y &
   & + an(6)
fd = ((((ad(1)*y + ad(2))*y + ad(3))*y + ad(4))*y + ad(5))*y &
   & + ad(6)
gn = ((((bn(1)*y + bn(2))*y + bn(3))*y + bn(4))*y + bn(5))*y &
   & + bn(6)
gd = ((((bd(1)*y + bd(2))*y + bd(3))*y + bd(4))*y + bd(5))*y &
   & + bd(6)
f = fn/(x*fd)
g = gn/(x*xx*gd)
go to 70
40 fn = (((cn(1)*y + cn(2))*y + cn(3))*y + cn(4))*y + cn(5)
fd = (((cd(1)*y + cd(2))*y + cd(3))*y + cd(4))*y + cd(5)
gn = (((dn(1)*y + dn(2))*y + dn(3))*y + dn(4))*y + dn(5)
gd = (((dd(1)*y + dd(2))*y + dd(3))*y + dd(4))*y + dd(5)
f = fn/(x*fd)
g = gn/(x*xx*gd)
go to 70
50 if (x >= 6.0) go to 60
xx = x*x
y = 1.0/(xx*xx)
f = (((((fp(1)*y + fp(2))*y + fp(3))*y + fp(4))*y + fp(5))*y &
   & + fp(6))*y + fp(7)
g = (((((gp(1)*y + gp(2))*y + gp(3))*y + gp(4))*y + gp(5))*y &
   & + gp(6))*y + gp(7)
f = f/x
g = g/(x*xx)
go to 70
60 if (x >= float(max)) go to 100
pix = pi*x
pixx = pix*x
y = 1.0/pixx
y = y*y
f = ((((p(1)*y + p(2))*y + p(3))*y + p(4))*y + p(5))*y + p(6)
g = ((((q(1)*y + q(2))*y + q(3))*y + q(4))*y + q(5))*y + q(6)
f = f/pix
g = g/(pix*pixx)
!-----------------------------------------------------------------------
!           Evaluation of sin(0.5*pi*x*x) and cos(0.5*pi*x*x)
!                 the results are stored in sy and cy
!-----------------------------------------------------------------------
70 m = x
l = mod(m,2)
n = m - l
y = x - m
r = x - n
y = y*n
m = y
y = y - m
if (mod(m,2) /= 0) y = (y - 0.5) - 0.5
y = y + 0.5*r*r
80 sy = sin1(y)
cy = cos1(y)
!-----------------------------------------------------------------------
!                             Termination
!-----------------------------------------------------------------------
c = 0.5 + (f*sy - g*cy)
s = 0.5 - (f*cy + g*sy)
if (t >= 0.0) return
c = - c
s = - s
return
100 if (t < 0.0) go to 110
c = 0.5
s = 0.5
return
110 c = -0.5
s = -0.5
end subroutine frnl

pure elemental subroutine cexpli(mo, z, w)
implicit none
integer, intent(in) :: mo
complex, intent(in) :: z
complex, intent(inout) :: w
integer :: i
real :: c, cy, d, e, eps, qm, r, ss, sy, tol, u, x, y
real :: n, np1, qf(2), sm(2), tm(2), ts(2), g0(2), gn(2), h0(2), hn(2), wn(2)
logical :: ind
real, parameter :: pi = 3.14159265358979
real, parameter :: euler = .577215664901533
real, parameter :: cd(18) = [0.00000000000000e+00, .311105957086528e-01, .103661260539112e+00, .216532335244554e+00, &
   & .369931427960192e+00, .566766259990589e+00, .814042066324748e+00, .112384247540813e+01, .151400478148512e+01, &
   & .200886795032284e+01, .264052411823592e+01, .345098449933392e+01, .449583360763202e+01, .585058263409822e+01, &
   & .762273501463380e+01, .997814501584578e+01, .132122064896408e+02, .180322948376021e+02]
real, parameter :: ce(18) = [.850156516121093e-02, .505037465849058e-01, .836817368956407e-01, .107047582417607e+00, &
   & .120424719029462e+00, .125096631582229e+00, .122314435224685e+00, .112621417553907e+00, .963419407392582e-01, &
   & .747398422757511e-01, .508596135953441e-01, .290822706773628e-01, .132201640530101e-01, .443802939829067e-02, &
   & .992612478987576e-03, .126579795112011e-03, .702150908253350e-05, .910281532564632e-07]
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
!           Evaluation of the complex exponential integral
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.D0 + eps .GT. 1.D0.
eps = spmpar(1)
!-------------------------
x = real(z)
y = aimag(z)
r = cpabs(x,y)
eps = max(eps,1.e-15)
if (r <= 1.0) go to 20
if (r >= 40.0) go to 60
if (r < 4.0) go to 10
if (x <= 0.0 .or. abs(y) > 8.0) go to 60
if (r < 10.0 .and. abs(y) > 1.8*x) go to 60
go to 20
10 if (x < 0.09*y*y) go to 50
if (r > 3.6 .and. abs(y) > 1.8*x) go to 60
!                        Taylor series
20 sm(1) = 0.0
sm(2) = 0.0
tm(1) = x
tm(2) = y
n = 1.0
30 n = n + 1.0
ts(1) = tm(1)*x - tm(2)*y
ts(2) = tm(1)*y + tm(2)*x
tm(1) = ts(1)/n
tm(2) = ts(2)/n
ts(1) = tm(1)/n
ts(2) = tm(2)/n
sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
if (anorm(ts(1),ts(2)) > eps*anorm(sm(1),sm(2))) &
   & go to 30
sm(1) = x + sm(1)
sm(2) = y + sm(2)
sm(1) = (euler + log(r)) + sm(1)
sm(2) = atan2(-y, -x) + sm(2)
go to 110
!                      Rational expansion
50 sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = x - cd(i)
   ts(2) = y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   sm(1) = sm(1) + ce(i)*ts(1)/ss
   sm(2) = sm(2) - ce(i)*ts(2)/ss
end do
go to 100
!         Pade approximation for the asymptotic expansion
!                       for exp(-z)*EI(z)
60 x = - x
y = - y
d = 4.0*r
if (r < 10.0) d = 32.0
g0(1) = 1.0
g0(2) = 0.0
gn(1) = (1.0 + x)/d
gn(2) = y/d
h0(1) = 1.0
h0(2) = 0.0
u = x + 2.0
hn(1) = u/d
hn(2) = gn(2)
w = cmplx(1.0 + x, y)/cmplx(u,y)
wn(1) = real(w)
wn(2) = aimag(w)
np1 = 1.0
tol = 4.0*eps
70 n = np1
np1 = n + 1.0
e = (n*np1)/d
u = u + 2.0
tm(1) = ((u*gn(1) - y*gn(2)) - e*g0(1))/d
tm(2) = ((u*gn(2) + y*gn(1)) - e*g0(2))/d
g0(1) = gn(1)
g0(2) = gn(2)
gn(1) = tm(1)
gn(2) = tm(2)
tm(1) = ((u*hn(1) - y*hn(2)) - e*h0(1))/d
tm(2) = ((u*hn(2) + y*hn(1)) - e*h0(2))/d
h0(1) = hn(1)
h0(2) = hn(2)
hn(1) = tm(1)
hn(2) = tm(2)
tm(1) = wn(1)
tm(2) = wn(2)
w = cmplx(gn(1),gn(2))/cmplx(hn(1),hn(2))
wn(1) = real(w)
wn(2) = aimag(w)
if (anorm(tm(1) - wn(1), tm(2) - wn(2)) > &
   & tol*anorm(wn(1), wn(2))) go to 70
x = real(z)
y = aimag(z)
w = w/z
sm(1) = real(w)
sm(2) = aimag(w)
!                         Termination
100 ind = x <= 0.0 .or. abs(y) > 1.e-2
if (ind .and. mo /= 0) go to 130
c = pi
if (y > 0.0) c = -pi
qm = exp(x)
cy = cos(y)
sy = sin(y)
qf(1) = qm*cy
qf(2) = qm*sy
if (mo == 0) go to 120
r = c/qm
sm(1) = sm(1) + r*sy
sm(2) = sm(2) + r*cy
go to 130
110 if (mo == 0) go to 130
ind = .true.
qm = exp(-x)
qf(1) = qm*cos(-y)
qf(2) = qm*sin(-y)
120 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
if (.not. ind) sm(2) = sm(2) + c
130 w = cmplx(sm(1),sm(2))
contains
   pure function anorm(x, y) result(nswc_sf_result)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: nswc_sf_result
      nswc_sf_result = max(abs(x),abs(y))
   end function anorm
end subroutine cexpli

pure elemental subroutine expli(int,arg,result,ierr)
implicit none
real, intent(in) :: arg
real, intent(inout) :: result
integer, intent(in) :: int
integer, intent(out) :: ierr
integer :: m, i
real :: px(9), qx(9), frac, sump, sumq, t, w, x, xx0, xmx0, y, xmax, xmin, ei, nswc_ai_r4
real, parameter :: dexp40 = .235385266837020e+18
real, parameter :: x0 = .372507410781366
double precision, parameter :: dx0 = .37250741078136663446199186658d0
real, parameter :: a(6) = [-.577215664901531e+00, .758833087029943e+00, .125660818982053e+00, .204158408934305e-01, &
   & .825035122466538e-03, .962949813453924e-05]
real, parameter :: b(5) = [.100000000000000e+01, .417810755380398e+00, .730228560396799e-01, .642720224671078e-02, &
   & .245134203588369e-03]
real, parameter :: c(7) = [.465627107975096e-06, .999979577051595e+00, .904161556946328e+01, .243784088791317e+02, &
   & .230192559391334e+02, .690522522784443e+01, .430967839469389e+00]
real, parameter :: d(7) = [.100000000000000e+01, .100411643829054e+02, .324264210695138e+02, .412807841891424e+02, &
   & .204494785013794e+02, .331909213593302e+01, .103400130404874e+00]
real, parameter :: e(7) = [-.999999999998447e+00, -.266271060431811e+02, -.241055827097015e+03, -.895927957772937e+03, - &
   & .129885688746484e+04, -.545374158883133e+03, -.566575206533869e+01]
real, parameter :: f(7) = [.100000000000000e+01, .286271060422192e+02, .292310039388533e+03, .133278537748257e+04, &
   & .277761949509163e+04, .240401713225909e+04, .631657483280800e+03]
real, parameter :: p1(8) = [-.866937339951070e+01, -.549142265521085e+03, -.421001615357070e+04, -.249301393458648e+06, - &
   & .119623669349247e+06, -.221744627758845e+08, .389280421311201e+07, -.195773036904548e+09]
real, parameter :: q1(8) = [.341718750000000e+02, -.160708926587221e+04, .357300298058508e+05, -.483547436162164e+06, &
   & .428559624611749e+07, -.249033375740540e+08, .891925767575612e+08, -.826271498626055e+08]
real, parameter :: r(20) = [.636295897967470e+00, -.130811686750676e+00, -.843674102130539e-02, .265684915310067e-02, &
   & .328227217816581e-03, -.237834477714302e-04, -.114398043081001e-04, -.144059434332383e-05, .524159566511488e-08, &
   & .384073064078443e-07, .858802448602672e-08, .102192266258550e-08, .217491323232897e-10, -.220902381426231e-10, - &
   & .634575335449288e-11, -.108377465668577e-11, -.119098228722226e-12, -.284386823892656e-14, .250803270266868e-14, &
   & .787296415285598e-15]
real, parameter :: p2(8) = [-.218086381520723e+01, -.219010233854881e+02, .930816385662165e+01, .250762811293560e+02, - &
   & .331842531997221e+02, .601217990830080e+02, -.432531132878135e+02, .100443109228078e+01]
real, parameter :: q2(7) = [.393707701852715e+01, .300892648372915e+03, -.625041161671876e+01, .100367439516726e+04, &
   & .143256738121938e+02, .273624119889328e+04, .527468851962908e+00]
real, parameter :: p3(8) = [-.348334653602852e+01, -.186545454883399e+02, -.828561994140641e+01, -.323467330305403e+02, &
   & .179601688769252e+02, .175656315469614e+01, -.195022321289660e+01, .999994296074708e+00]
real, parameter :: q3(7) = [.695000655887434e+02, .572837193837324e+02, .257776384238440e+02, .760761148007735e+03, &
   & .289516727925135e+02, -.343942266899870e+01, .100083867402639e+01]
real, parameter :: p4(8) = [-.531686623494482e+02, .891263822573708e+01, -.139381360364405e+01, -.308336269051763e+02, - &
   & .749289167792884e+01, -.500140345515924e+01, -.300000016782086e+01, .100000000000058e+01]
real, parameter :: q4(7) = [.104745362652468e+04, -.674704580465832e+01, .295999399486831e+03, -.431325836146628e+01, - &
   & .790404992298926e+01, -.299996432944446e+01, .199999999924131e+01]
interface
   pure elemental function alnrel(a)
      implicit none
      real, intent(in) :: a
      real :: alnrel
   end function alnrel
   pure function csevl(x,a,n)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: x
      real, intent(in) :: a(n)
      real :: csevl
   end function csevl
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
end interface
!-----------------------------------------------------------------------
!     This subroutine computes the exponential integrals
!            EI(X),  e-SUB-1(X) = -EI(-X),  AND  exp(-X)*EI(X)
!     where
!             INTEGRAL (FROM T=-INFINITY TO T=X) (exp(T)/T),  X .GT. 0,
!     ei(x) =
!             -INTEGRAL (FROM T=-X TO T=INFINITY) (exp(-T)/T),
!                                                         X .LT. 0,
!     and where the first integral is a principal value integral. The
!     arguments int, arg, and result have the following usage ...
!            INT              ARG             RESULT
!             1            X .NE. 0          EI(X)
!             2            X .GT. 0          e-SUB-1(X)
!             3            X .NE. 0          exp(-X)*EI(X)
!     the expansion for 4 .LE. X .LE. 8 is due to Wayne Fullerton (los
!     alamos). The remaining expansions are from math. Comp. 22, 641-649
!     (1968), and math. Comp. 23, 289-303(1969) By Cody and Thacher.
!        ------------
!     Error monitoring
!        the parameter ierr is a variable that is set by the routine.
!     If no errors are detected then ierr is set to 0. The following
!     table indicates the types of errors that may be encountered in
!     the routine and the function values supplied in each case.
!     ierr    ERROR     ARGUMENT          FUNCTION VALUES FOR
!                        RANGE        EI(X)  exp(-X)*EI(X)  e-SUB-1(X)
!      1    UNDERFLOW   X .LT. XMIN     0          -          0
!      2    OVERFLOW    X .GT. XMAX     T          -          -
!      3    ILLEGAL X     X = 0         T          T          T
!      4    ILLEGAL X    X .LT. 0       -          -          T
!     T indicates that the routine terminates without assigning a value
!     to the function.
!        ----------
!     This subroutine was written at Argonne National Laboratory for
!     the funpack package of special function subroutines. The routine
!     was modified by by A.H. Morris (NSWC).
!-----------------------------------------------------------------------
!     Xmax and xmin are machine dependent constants for detecting
!     underflow and overflow. Xmax and xmin are given approximate
!     values in statements 240 and 340.
!-----------------------------------------------------------------------
!     Value of exp(40.0)
!     ----------
!     ----------
!     Zero of EI(X)
!     ----------
!     ----------
!     Coefficients for R(5,4) approximation,
!     used for -1.0 .LE. X .LT. 0.0
!     ----------
!     ----------
!     Coefficients for R(6,6) approximation,
!     used for -4.0 .LE. X .LT. -1.0
!     ----------
!     ----------
!     Coefficients for R(6,6) approximation,
!     used for X .LT. -4.0
!     ----------
!     ----------
!     Coefficients for R(7,7) approximation,
!     in Chebyshev polynomial form, used for
!     0.0 .LT. X .LT. 4.0
!     ----------
!     ----------
!     Coefficients for Chebyshev expansion for
!     4.0 .LE. X .LE. 8.0
!     ----------
!     Coefficients for R(7,7) approximation,
!     in J-fraction form, used for
!     8.0 .LT. X .LT. 12.0
!     ----------
!     ----------
!     Coefficients for R(7,7) approximation,
!     in J-fraction form, used for
!     12.0 .LE. X .LT. 24.0
!     ----------
!     ----------
!     Coefficients for R(7.7) approximation,
!     in J-fraction form, used for X .GE. 24.0
!     ----------
!-----------------------------------------------------------------------
x = arg
ierr = 0
if (int == 2) go to 450
nswc_ai_r4 = x
if (nswc_ai_r4 < 0) go to 280
if (nswc_ai_r4 == 0) go to 640
go to 110
110 if (x >= 12.e0) go to 200
if (x > 8.e0) go to 160
if (x >= 4.e0) go to 150
!     ---------- 0.0 .LT. X .LT. 4.0.
!                Rational approximation used is expressed
!                in terms of Chebyshev polynomials to
!                improve conditioning  ----------
t = x + x
t = t / 3.0e0 - 2.0e0
px(1) = 0.0e0
qx(1) = 0.0e0
px(2) = p1(1)
qx(2) = q1(1)
do i = 2, 7
   px(i + 1) = t * px(i) - px(i - 1) + p1(i)
   qx(i + 1) = t * qx(i) - qx(i - 1) + q1(i)
end do
sump = .5e0 * t * px(8) - px(7) + p1(8)
sumq = .5e0 * t * qx(8) - qx(7) + q1(8)
frac = sump / sumq
xmx0 = dble(x) - dx0
if (abs(xmx0) < 0.07e0) go to 140
xx0 = x / x0
ei = log(xx0) + xmx0 * frac
if (int == 3) ei = exp(-x) * ei
go to 410
!     ---------- Evaluate approximation for LN(X/X0)
!                for X close to X0 ----------
140 y = xmx0 / x0
ei = alnrel(y) + xmx0 * frac
if (int == 3) ei = exp(-x) * ei
go to 410
!     ---------- 4.0 .LE. X .LE. 8.0 ----------
150 m = 20
ei = (1.0 + csevl(3.0 - 16.0/x, r, m)) / x
if (int == 3) go to 410
ei = ei * exp(x)
go to 410
!     ---------- 8.0 .LT. X .LT. 12.0 ----------
160 frac = 0.0e0
do i = 1, 7
   frac = q2(i) / (p2(i) + x + frac)
end do
ei = (p2(8) + frac) / x
if (int == 3) go to 410
ei = ei * exp(x)
go to 410
!     ---------- 12.0 .LE. X .LT. 24.0 ----------
200 if (x >= 24.e0) go to 240
frac = 0.0e0
do i = 1, 7
   frac = q3(i) / (p3(i) + x + frac)
end do
ei = (p3(8) + frac) / x
if (int == 3) go to 410
ei = ei * exp(x)
go to 410
!     ---------- 24.0 .LE. X ----------
240 xmax = exparg(0)
if ((x > xmax) .and. (int < 3)) go to 620
y = 1.0e0 / x
frac = 0.0e0
do i = 1, 7
   frac = q4(i) / (p4(i) + x + frac)
end do
frac = p4(8) + frac
ei = y + y * y * frac
if (int == 3) go to 410
if (x > 150.0e0) go to 270
ei = ei * exp(x)
go to 410
!     ---------- Calculation reformulated to avoid
!                premature overflow ----------
270 ei = (ei * exp(x - 40.0e0)) * dexp40
go to 410
!     ---------- Original X was negative.  Calculation of
!                e-sub-1 joins at label 300 ----------
280 y = -x
300 w = 1.0e0 / y
if (y > 4.0e0) go to 340
if (y > 1.0e0) go to 320
!     ---------- 0.0 .LT. -X .LE. 1.0 ----------
ei = log(y) - (((((a(6) * y + a(5)) * y + a(4)) &
   & * y + a(3)) * y + a(2)) * y + a(1)) / &
   & ((((b(5) * y + b(4)) * y + b(3)) &
   & * y + b(2)) * y + b(1))
if (int == 3) ei = ei * exp(y)
go to 400
!     ---------- 1.0 .LT. -X .LE. 4.0 ----------
320 ei = -((((((c(7) * w + c(6)) * w + c(5)) * w + c(4)) &
   & * w + c(3)) * w + c(2)) * w + c(1))  / &
   & ((((((d(7) * w + d(6)) * w + d(5)) * w + d(4)) &
   & * w + d(3)) * w + d(2)) * w + d(1))
if (int == 3) go to 410
ei = ei * exp(-y)
go to 400
!     ---------- 4.0 .LT. -X ----------
340 xmin = exparg(1)
if ((-abs(x) < xmin) .and. (int < 3)) go to 600
ei = -w * (1.0e0 + w * ((((((e(7) &
   & * w + e(6)) * w + e(5)) * w + e(4)) &
   & * w + e(3)) * w + e(2)) * w + e(1)) / &
   & ((((((f(7) * w + f(6)) * w + f(5)) &
   & * w + f(4)) * w + f(3)) * w + f(2)) * w + f(1)))
if (int == 3) go to 410
ei = ei * exp(-y)
t = 0.5e0 * ei
if (t == 0.0e0) go to 600
400 if (int == 2) ei = -ei
410 result = ei
return
450 y = x
nswc_ai_r4 = y
if (nswc_ai_r4 < 0) go to 660
if (nswc_ai_r4 == 0) go to 640
go to 300
!     ---------- Error return for X .LT. xmin,
!                causing underflow ----------
600 ei = 0.0e0
ierr = 1
go to 410
!     ---------- Error return for X .GT. xmax,
!                causing overflow ----------
620 ierr = 2
return
!     ---------- Error return for illegal
!                ARGUMENT, X = 0 ----------
640 ierr = 3
return
!     ---------- Error return for negative
!                argument in e-sub-1 ----------
660 ierr = 4
end subroutine expli

pure elemental double precision function dei(x)
implicit none
!-----------------------------------------------------------------------
!        Double precision evaluation of the exponential integral
!-----------------------------------------------------------------------
double precision, intent(in) :: x
interface
   pure elemental function de1e(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: de1e
   end function de1e
end interface
dei = -de1e(-x)
if (x > 4.d0 .or. x < -1.d0) dei = exp(x) * dei
end function dei

pure elemental double precision function dei1(x)
implicit none
!-----------------------------------------------------------------------
!          Double precision evaluation of exp(-x)*EI(x)
!-----------------------------------------------------------------------
double precision, intent(in) :: x
interface
   pure elemental function de1e(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: de1e
   end function de1e
end interface
dei1 = -de1e(-x)
if (x > 4.d0 .or. x < -1.d0) return
dei1 = exp(-x) * dei1
end function dei1

pure elemental double precision function de1e(x)
implicit none
double precision, intent(in) :: x
integer :: m
double precision :: c, eps, t, w
double precision, parameter :: a(50) = [.3284394579616699087873844201881d-01, - &
   & .1669920452031362851476184343387d-01, .2845284724361346807424899853252d-03, -.7563944358516206489487866938533d-05, &
   & .2798971289450859157504843180879d-06, -.1357901828534531069525563926255d-07, .8343596202040469255856102904906d-09, - &
   & .6370971727640248438275242988532d-10, .6007247608811861235760831561584d-11, -.7022876174679773590750626150088d-12, &
   & .1018302673703687693096652346883d-12, -.1761812903430880040406309966422d-13, .3250828614235360694244030353877d-14, - &
   & .5071770025505818678824872259044d-15, .1665177387043294298172486084156d-16, .3166753890797514400677003536555d-16, - &
   & .1588403763664141515133118343538d-16, .4175513256138018833003034618484d-17, -.2892347749707141906710714478852d-18, - &
   & .2800625903396608103506340589669d-18, .1322938639539270903707580023781d-18, -.1804447444177301627283887833557d-19, - &
   & .7905384086522616076291644817604d-20, .4435711366369570103946235838027d-20, -.4264103994978120868865309206555d-21, - &
   & .3920101766937117541553713162048d-21, .1527378051343994266343752326971d-21, .1024849527049372339310308783117d-22, - &
   & .2134907874771433576262711405882d-22, .3239139475160028267061694700366d-23, .2142183762299889954762643168296d-23, - &
   & .8234609419601018414700348082312d-24, -.1524652829645809479613694401140d-24, .1378208282460639134668480364325d-24, &
   & .2131311202833947879523224999253d-26, -.2012649651526484121817466763127d-25, .1995535662263358016106311782673d-26, &
   & .2798995808984003464948686520319d-26, -.5534511845389626637640819277823d-27, -.3884995396159968861682544026146d-27, &
   & .1121304434507359382850680354679d-27, .5566568152423740948256563833514d-28, -.2045482929810499700448533938176d-28, - &
   & .8453813992712336233411457493674d-29, .3565758433431291562816111116287d-29, .1383653872125634705539949098871d-29, - &
   & .6062167864451372436584533764778d-30, -.2447198043989313267437655119189d-30, .1006850640933998348011548180480d-30, &
   & .4623685555014869015664341461674d-31]
double precision, parameter :: b(60) = [.20263150647078889499401236517381d+00, - &
   & .73655140991203130439536898728034d-01, .63909349118361915862753283840020d-02, -.60797252705247911780653153363999d-03, - &
   & .73706498620176629330681411493484d-04, .48732857449450183453464992488076d-04, -.23837064840448290766588489460235d-05, - &
   & .30518612628561521027027332246121d-05, .17050331572564559009688032992907d-06, .23834204527487747258601598136403d-06, &
   & .10781772556163166562596872364020d-07, -.17955692847399102653642691446599d-07, -.41284072341950457727912394640436d-08, &
   & .68622148588631968618346844526664d-09, .53130183120506356147602009675961d-09, .78796880261490694831305022893515d-10, - &
   & .26261762329356522290341675271232d-10, -.15483687636308261963125756294100d-10, -.25818962377261390492802405122591d-11, &
   & .59542879191591072658903529959352d-12, .46451400387681525833784919321405d-12, .11557855023255861496288006203731d-12, - &
   & .10475236870835799012317547189670d-14, -.11896653502709004368104489260929d-13, -.47749077490261778752643019349950d-14, - &
   & .81077649615772777976249734754135d-15, .13435569250031554199376987998178d-15, .14134530022913106260248873881287d-15, &
   & .49451592573953173115520663232883d-16, .79884048480080665648858587399367d-17, -.14008632188089809829248711935393d-17, - &
   & .14814246958417372107722804001680d-17, -.55826173646025601904010693937113d-18, -.11442074542191647264783072544598d-18, &
   & .25371823879566853500524018479923d-20, .13205328154805359813278863389097d-19, .62930261081586809166287426789485d-20, &
   & .17688270424882713734999261332548d-20, .23266187985146045209674296887432d-21, -.67803060811125233043773831844113d-22, - &
   & .59440876959676373802874150531891d-22, -.23618214531184415968532592503466d-22, -.60214499724601478214168478744576d-23, - &
   & .65517906474348299071370444144639d-24, .29388755297497724587042038699349d-24, .22601606200642115173215728758510d-24, &
   & .89534369245958628745091206873087d-25, .24015923471098457555772067457706d-25, .34118376888907172955666423043413d-26, - &
   & .71617071694630342052355013345279d-27, -.75620390659281725157928651980799d-27, -.33774612157467324637952920780800d-27, - &
   & .10479325703300941711526430332245d-27, -.21654550252170342240854880201386d-28, -.75297125745288269994689298432000d-30, &
   & .19103179392798935768638084000426d-29, .11492104966530338547790728833706d-29, .43896970582661751514410359193600d-30, &
   & .12320883239205686471647157725866d-30, .22220174457553175317538581162666d-31]
double precision, parameter :: d(41) = [.63629589796747038767129887806803d+00, - &
   & .13081168675067634385812671121135d+00, -.84367410213053930014487662129752d-02, .26568491531006685413029428068906d-02, &
   & .32822721781658133778792170142517d-03, -.23783447771430248269579807851050d-04, -.11439804308100055514447076797047d-04, - &
   & .14405943433238338455239717699323d-05, .52415956651148829963772818061664d-08, .38407306407844323480979203059716d-07, &
   & .85880244860267195879660515759344d-08, .10219226625855003286339969553911d-08, .21749132323289724542821339805992d-10, - &
   & .22090238142623144809523503811741d-10, -.63457533544928753294383622208801d-11, -.10837746566857661115340539732919d-11, - &
   & .11909822872222586730262200440277d-12, -.28438682389265590299508766008661d-14, .25080327026686769668587195487546d-14, &
   & .78729641528559842431597726421265d-15, .15475066347785217148484334637329d-15, .22575322831665075055272608197290d-16, &
   & .22233352867266608760281380836693d-17, .16967819563544153513464194662399d-19, -.57608316255947682105310087304533d-19, - &
   & .17591235774646878055625369408853d-19, -.36286056375103174394755328682666d-20, -.59235569797328991652558143488000d-21, - &
   & .76030380926310191114429136895999d-22, -.62547843521711763842641428479999d-23, .25483360759307648606037606400000d-24, &
   & .25598615731739857020168874666666d-24, .71376239357899318800207052800000d-25, .14703759939567568181578956800000d-25, &
   & .25105524765386733555198634666666d-26, .35886666387790890886583637333333d-27, .39886035156771301763317759999999d-28, &
   & .21763676947356220478805333333333d-29, -.46146998487618942367607466666666d-30, -.20713517877481987707153066666666d-30, - &
   & .51890378563534371596970666666666d-31]
double precision, parameter :: e(29) = [-.16113461655571494025720663927566180d+02, &
   & .77940727787426802769272245891741497d+01, -.19554058188631419507127283812814491d+01, .37337293866277945611517190865690209d+00 &
   & , -.56925031910929019385263892220051166d-01, .72110777696600918537847724812635813d-02, - &
   & .78104901449841593997715184089064148d-03, .73880933562621681878974881366177858d-04, -.62028618758082045134358133607909712d-05 &
   & , .46816002303176735524405823868362657d-06, -.32092888533298649524072553027228719d-07, &
   & .20151997487404533394826262213019548d-08, -.11673686816697793105356271695015419d-09, .62762706672039943397788748379615573d-11 &
   & , -.31481541672275441045246781802393600d-12, .14799041744493474210894472251733333d-13, - &
   & .65457091583979673774263401588053333d-15, .27336872223137291142508012748799999d-16, -.10813524349754406876721727624533333d-17 &
   & , .40628328040434303295300348586666666d-19, -.14535539358960455858914372266666666d-20, &
   & .49632746181648636830198442666666666d-22, -.16208612696636044604866560000000000d-23, .50721448038607422226431999999999999d-25 &
   & , -.15235811133372207813973333333333333d-26, .44001511256103618696533333333333333d-28, - &
   & .12236141945416231594666666666666666d-29, .32809216661066001066666666666666666d-31, -.84933452268306432000000000000000000d-33]
double precision, parameter :: r(25) = [-.3739021479220279511668698204827d-01, &
   & .4272398606220957726049179176528d-01, -.130318207984970054415392055219726d+00, .144191240246988907341095893982137d-01, - &
   & .134617078051068022116121527983553d-02, .107310292530637799976115850970073d-03, -.742999951611943649610283062223163d-05, &
   & .453773256907537139386383211511827d-06, -.247641721139060131846547423802912d-07, .122076581374590953700228167846102d-08, - &
   & .548514148064092393821357398028261d-10, .226362142130078799293688162377002d-11, -.863589727169800979404172916282240d-13, &
   & .306291553669332997581032894881279d-14, -.101485718855944147557128906734933d-15, .315482174034069877546855328426666d-17, - &
   & .923604240769240954484015923200000d-19, .255504267970814002440435029333333d-20, -.669912805684566847217882453333333d-22, &
   & .166925405435387319431987199999999d-23, -.396254925184379641856000000000000d-25, .898135896598511332010666666666666d-27, - &
   & .194763366993016433322666666666666d-28, .404836019024630033066666666666666d-30, -.807981567699845120000000000000000d-32]
double precision, parameter :: p(50) = [-.60577324664060345999319382737747d+00, - &
   & .11253524348366090030649768852718d+00, .13432266247902779492487859329414d-01, -.19268451873811457249246838991303d-02, &
   & .30911833772060318335586737475368d-03, -.53564132129618418776393559795147d-04, .98278128802474923952491882717237d-05, - &
   & .18853689849165182826902891938910d-05, .37494319356894735406964042190531d-06, -.76823455870552639273733465680556d-07, &
   & .16143270567198777552956300060868d-07, -.34668022114907354566309060226027d-08, .75875420919036277572889747054114d-09, - &
   & .16886433329881412573514526636703d-09, .38145706749552265682804250927272d-10, -.87330266324446292706851718272334d-11, &
   & .20236728645867960961794311064330d-11, -.47413283039555834655210340820160d-12, .11221172048389864324731799928920d-12, - &
   & .26804225434840309912826809093395d-13, .64578514417716530343580369067212d-14, -.15682760501666478830305702849194d-14, &
   & .38367865399315404861821516441408d-15, -.94517173027579130478871048932556d-16, .23434812288949573293896666439133d-16, - &
   & .58458661580214714576123194419882d-17, .14666229867947778605873617419195d-17, -.36993923476444472706592538274474d-18, &
   & .93790159936721242136014291817813d-19, -.23893673221937873136308224087381d-19, .61150624629497608051934223837866d-20, - &
   & .15718585327554025507719853288106d-20, .40572387285585397769519294491306d-21, -.10514026554738034990566367122773d-21, &
   & .27349664930638667785806003131733d-22, -.71401604080205796099355574271999d-23, .18705552432235079986756924211199d-23, - &
   & .49167468166870480520478020949333d-24, .12964988119684031730916087125333d-24, -.34292515688362864461623940437333d-25, &
   & .90972241643887034329104820906666d-26, -.24202112314316856489934847999999d-26, .64563612934639510757670475093333d-27, - &
   & .17269132735340541122315987626666d-27, .46308611659151500715194231466666d-28, -.12448703637214131241755170133333d-28, &
   & .33544574090520678532907007999999d-29, -.90598868521070774437543935999999d-30, .24524147051474238587273216000000d-30, - &
   & .66528178733552062817107967999999d-31]
double precision, parameter :: q(64) = [-.1892918000753016825495679942820d+00, - &
   & .8648117855259871489968817056824d-01, .7224101543746594747021514839184d-02, -.8097559457557386197159655610181d-03, &
   & .1099913443266138867179251157002d-03, -.1717332998937767371495358814487d-04, .2985627514479283322825342495003d-05, - &
   & .5659649145771930056560167267155d-06, .1152680839714140019226583501663d-06, -.2495030440269338228842128765065d-07, &
   & .5692324201833754367039370368140d-08, -.1359957664805600338490030939176d-08, .3384662888760884590184512925859d-09, - &
   & .8737853904474681952350849316580d-10, .2331588663222659718612613400470d-10, -.6411481049213785969753165196326d-11, &
   & .1812246980204816433384359484682d-11, -.5253831761558460688819403840466d-12, .1559218272591925698855028609825d-12, - &
   & .4729168297080398718476429369466d-13, .1463761864393243502076199493808d-13, -.4617388988712924102232173623604d-14, &
   & .1482710348289369323789239660371d-14, -.4841672496239229146973165734417d-15, .1606215575700290408116571966188d-15, - &
   & .5408917538957170947895023784252d-16, .1847470159346897881370231402310d-16, -.6395830792759094470500610425050d-17, &
   & .2242780721699759457250233276170d-17, -.7961369173983947552744555308646d-18, .2859308111540197459808619929272d-18, - &
   & .1038450244701137145900697137446d-18, .3812040607097975780866841008319d-19, -.1413795417717200768717562723696d-19, &
   & .5295367865182740958305442594815d-20, -.2002264245026825902137211131439d-20, .7640262751275196014736848610918d-21, - &
   & .2941119006868787883311263523362d-21, .1141823539078927193037691483586d-21, -.4469308475955298425247020718489d-22, &
   & .1763262410571750770630491408520d-22, -.7009968187925902356351518262340d-23, .2807573556558378922287757507515d-23, - &
   & .1132560944981086432141888891562d-23, .4600574684375017946156764233727d-24, -.1881448598976133459864609148108d-24, &
   & .7744916111507730845444328478037d-25, -.3208512760585368926702703826261d-25, .1337445542910839760619930421384d-25, - &
   & .5608671881802217048894771735210d-26, .2365839716528537483710069473279d-26, -.1003656195025305334065834526856d-26, &
   & .4281490878094161131286642556927d-27, -.1836345261815318199691326958250d-27, .7917798231349540000097468678144d-28, - &
   & .3431542358742220361025015775231d-28, .1494705493897103237475066008917d-28, -.6542620279865705439739042420053d-29, &
   & .2877581395199171114340487353685d-29, -.1271557211796024711027981200042d-29, .5644615555648722522388044622506d-30, - &
   & .2516994994284095106080616830293d-30, .1127259818927510206370368804181d-30, -.5069814875800460855562584719360d-31]
interface
   pure function dcsevl(x,a,n)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: x
      double precision, intent(in) :: a(n)
      double precision :: dcsevl
   end function dcsevl
   pure elemental function dei0(x,eps)
      implicit none
      double precision, intent(in) :: x
      double precision, intent(in) :: eps
      double precision :: dei0
   end function dei0
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!-----------------------------------------------------------------------
!     Let E1(x) denote the exponential integral for positive x and
!     the Cauchy principal value for negative x. if x is nonzero
!     then de1e has the value ...
!          de1e(x) = e1(x)          if -4 .le. x .le. 1
!          de1e(x) = exp(x)*e1(x)   otherwise
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
!     The following series for E1 were developed by Wayne Fullerton
!     (Los Alamos National Laboratory).
!     SERIES A             ON THE INTERVAL -3.12500e-02 TO  0.
!                                        WITH WEIGHTED ERROR   4.62e-32
!                                         log weighted error  31.34
!                               significant figures required  29.70
!                                    decimal places required  32.18
!     SERIES b             ON THE INTERVAL -1.25000e-01 TO -3.12500e-02
!                                        WITH WEIGHTED ERROR   2.22e-32
!                                         log weighted error  31.65
!                               significant figures required  30.75
!                                    decimal places required  32.54
!     SERIES d             ON THE INTERVAL -2.50000e-01 TO -1.25000e-01
!                                        WITH WEIGHTED ERROR   5.19e-32
!                                         log weighted error  31.28
!                               significant figures required  30.82
!                                    decimal places required  32.09
!     SERIES e             ON THE INTERVAL -4.00000e+00 TO -1.00000e+00
!                                        WITH WEIGHTED ERROR   8.49e-34
!                                         log weighted error  33.07
!                               significant figures required  34.13
!                                    decimal places required  33.80
!     SERIES r             ON THE INTERVAL -1.00000e+00 TO  1.00000e+00
!                                        WITH WEIGHTED ERROR   8.08e-33
!                                         log weighted error  32.09
!                        approx significant figures required  30.4
!                                    decimal places required  32.79
!     SERIES p             ON THE INTERVAL  2.50000e-01 TO  1.00000e+00
!                                        WITH WEIGHTED ERROR   6.65e-32
!                                         log weighted error  31.18
!                               significant figures required  30.69
!                                    decimal places required  32.03
!     SERIES Q             ON THE INTERVAL  0.          TO  2.50000e-01
!                                        WITH WEIGHTED ERROR   5.07e-32
!                                         log weighted error  31.30
!                               significant figures required  30.40
!                                    decimal places required  32.20
!-----------------------------------------------------------------------
!------------------------------
!------------------------------
!------------------------------
!------------------------------
!------------------------------
!------------------------------
!------------------------------
!------------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.D0 + eps .GT. 1.D0.
eps = dpmpar(1)
!------------------------------
if (abs(x) >= 90.d0) go to 80
if (x > -1.d0) go to 40
!                    -90 .LT. x .LT. -4
if (x > -32.d0) go to 10
m = 50
if (eps >= 1.d-20) m = 25
de1e = (1.d0 + dcsevl(64.d0/x + 1.d0, a, m))/x
return
10 if (x > -8.d0) go to 20
m = 60
if (eps >= 1.d-20) m = 37
de1e = (1.d0 + dcsevl((64.d0/x + 5.d0)/3.d0, b, m))/x
return
20 if (x >= -4.d0) go to 30
m = 41
if (eps >= 1.d-20) m = 27
de1e = (1.d0 + dcsevl(16.d0/x + 3.d0, d, m))/x
return
!                     -4 .LE. x .LE. 1
30 m = 29
if (eps >= 1.d-20) m = 20
de1e = -log(-x) + dcsevl((2.d0*x + 5.d0)/3.d0, e, m)
return
40 if (x > 1.0d0) go to 60
if (x < -0.4d0 .or. x > -0.35d0) go to 50
de1e = - dei0(-x, eps)
return
50 m = 25
if (eps >= 1.d-20) m = 18
de1e = (-log(abs(x)) - 0.6875d0 + x) + dcsevl(x, r, m)
return
!                     1 .LT. x .LT. 90
60 if (x > 4.0d0) go to 70
m = 50
if (eps >= 1.d-20) m = 31
de1e = (1.d0 + dcsevl((8.d0/x - 5.d0)/3.d0, p, m))/x
return
70 m = 64
if (eps >= 1.d-20) m = 35
de1e = (1.d0 + dcsevl(8.d0/x - 1.d0, q, m))/x
return
!                   Asymptotic expansion
80 t = -1.d0/x
c = t
w = c
m = 1
81 m = m + 1
c = (m*t)*c
w = c + w
if (abs(c) > eps) go to 81
de1e = (1.d0 + w)/x
end function de1e

pure elemental double precision function dei0(x, eps)
implicit none
double precision, intent(in) :: eps
double precision, intent(in) :: x
integer :: n
double precision :: c, h, t, w, db2
double precision, parameter :: dk1 = 25598514349.d0
double precision, parameter :: dk2 = 12212826724.d0
double precision, parameter :: dk3 = 52346020729.d0
double precision, parameter :: db = 68719476736.d0
double precision, parameter :: dx = .64725688445954142292644880487403537155379408215561d-33
double precision, parameter :: a(40) = [.3896215733907167310156502703593482682018d+01, - &
   & .3281607866398561670879044070702055058438d+01, .6522376145438925697728352767902339522245d+01, - &
   & .1296969738353651703636356975116693457132d+02, .2788629796294204997855360701398702087604d+02, - &
   & .6237880152891541873078526672920295283143d+02, .1435349488096750987841265647073135861344d+03, - &
   & .3371558271787468916821364466977375583658d+03, .8045318399821382506595322457265602778098d+03, - &
   & .1943796645723498840655451915157946462648d+04, .4743765650402430835228269085129777320454d+04, - &
   & .1167346399116716364394668734600584330571d+05, .2892695530543545087445160311373446386859d+05, - &
   & .7210794586837158996878001987822898188198d+05, .1806695585893919626172098163733836311447d+06, - &
   & .4546962188544665746524572520110515778526d+06, .1148834546817744310374556891236080193473d+07, - &
   & .2912721663850837498392234670693435881386d+07, .7407692958000587759747953639495510375408d+07, - &
   & .1889172700038153127288849726417780854730d+08, .4830003493086024720868271496253148288055d+08, - &
   & .1237682190024917092137405370407916520821d+09, .3178111056663621852260468265468336116367d+09, - &
   & .8176185693184928170769596413793786736279d+09, .2107109291864363741291032089276432438927d+10, - &
   & .5438996831077284596300440196418865401363d+10, .1406026390995585037838894210474681627693d+11, - &
   & .3639689100149205333626392754168250384373d+11, .9433859509219164512733865811047107199412d+11, - &
   & .2448111705066430130314746602027041462835d+12, .6359981818273706257655285041587660739835d+12, - &
   & .1653989211524391716301960841541179924503d+13, .4305601123377464671923711939926758523701d+13, - &
   & .1121847693567642152208443795868288937687d+14, .2925565695557339262045727352754930716608d+14, - &
   & .7635552741959392076619218035480359307499d+14, .1994372792759425025753893705017248674884d+15, - &
   & .5213021921201092276891722450906568692592d+15, .1363558024737805584657706536660107687818d+16, - &
   & .3568973490569445692988895507297245137908d+16]
!-----------------------------------------------------------------------
!            Taylor series expansion of EI(x) around X0,
!                  where X0 is the zero of EI(x).
!                    Eps is the tolerance used.
!-------------------------
!     Written by A.H. Morris
!        Naval Surface Warfare Center
!        Dahlgren, Virginia
!-----------------------------------------------------------------------
!-------------------------
!-------------------------
!-------------------------
!     Set  h = x - X0  where X0 is the zero of EI(x). X0 has the
!     approximate 60 digit value ...
!      .37250741078136663446 19918665801191335356 89497771654051555657
!     A more accurate value is given by ...
!            x0 = dk1/8**12 + dk2/8**24 + dk3/8**36 + dx
!     the following code should yield the correct value for h if A
!     binary, octal, or hexadecimal double precision arithmetic is
!     being used.
db2 = db*db
h = (((x - dk1/db) - dk2/db2) - dk3/(db*db2)) - dx
!-------------------------
t = h
w = 0.d0
do n = 2,40
   c = a(n)*t
   w = w + c
   if (abs(c) < eps) exit
   t = h*t
end do
dei0 = h * (a(1) + w)
end function dei0

pure function si(x)
implicit none
real, intent(in) :: x
integer :: i, j
real :: aic, amax, ax, b1, b2, bx, rc, temp, tx
real :: si
integer, parameter :: n1 = 16
integer, parameter :: n2 = 46
integer, parameter :: m1 = 14
integer, parameter :: m2 = 21
real, parameter :: pio2 = 1.5707963267949
real, parameter :: bb(16) = [6.84101190850653e-01, -3.74538448460062e-01, -2.82656062651542e-02, 3.06078454012071e-02, - &
   & 8.99242948380352e-04, -1.09884251456048e-03, 5.81151604367358e-05, 2.28802638122969e-05, -1.35078982929539e-06, - &
   & 3.13213946132892e-07, 1.86619586786257e-08, 3.03991719607226e-09, -1.76437788946489e-10, -2.20236421792690e-11, &
   & 1.22710107703240e-12, 1.23680681116783e-13]
real, parameter :: cc(46) = [9.76155271128712e-01, 8.96845854916423e-02, -3.04656658030696e-02, 8.50892472922945e-02, - &
   & 5.78073683148386e-03, -5.07182677775691e-03, 8.38643256650893e-04, -3.34223415981738e-04, -2.15746207281216e-05, &
   & 1.28560650086065e-04, -1.56456413510232e-05, -1.52025513597262e-05, 4.04001013843204e-06, -5.95896122752160e-07, - &
   & 4.34985305974340e-07, 7.13472533530840e-07, -5.34302186061100e-08, -1.76003581156610e-07, 3.85028855125900e-08, &
   & 1.92576544441700e-08, -1.00735358217200e-08, 3.36359194377000e-09, 1.28049619406000e-09, -2.42546870827000e-09, &
   & 1.86917288950000e-10, 7.13431298340000e-10, -1.70673483710000e-10, -1.14604070350000e-10, 5.88004411500000e-11, - &
   & 6.78417843000000e-12, -1.21572380900000e-11, 1.26561248700000e-11, 4.74814180000000e-13, -5.32309477000000e-12, &
   & 9.05903810000000e-13, 1.40046450000000e-12, -5.00968320000000e-13, -1.80458040000000e-13, 1.66162910000000e-13, - &
   & 5.02616400000000e-14, -3.48453600000000e-14, 4.60056600000000e-14, 5.74000000000000e-16, -1.95310700000000e-14, &
   & 3.68837000000000e-15, 5.62862000000000e-15]
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     Written by D.E. Amos and S.L. Daniel, November,1975.
!     Modified by A.H. Morris
!     references
!         SAND76-006C
!         the special functions and their approximations, vol. II, by
!         Y.L. Luke. Academic press, new york, 1969.
!     Abstract
!         si computes the integral of sin(T)/T on (0,x) by means
!         of Chebyshev expansions on (0,5) and (5,INFINITY).
!     Description of arguments
!         input
!           x      - Limit of integration, unrestricted
!         output
!           si     - Value of the integral
!     -------------------
!     -------------------
!     -------------------
!     -------------------
!     ****** amax is a machine dependent constant. It is assumed that
!            sin(x) and cos(x) are defined for  abs(x) .LE. amax, and
!            THAT pio2 - (1 + 1/x)/x = pio2 FOR x .GT. amax.
amax = 1.0/spmpar(1)
ax = abs(x)
if (ax > 5.0) go to 20
j = n1
bx = 0.40*ax - 1.0
tx = bx + bx
b1 = bb(j)
b2 = 0.
do i = 1,m1
   j = j - 1
   temp = b1
   b1 = tx*b1 - b2 + bb(j)
   b2 = temp
end do
si = (bx*b1 - b2 + bb(1))*x
return
20 if (ax > amax) go to 50
bx = 10./ax - 1.
tx = bx + bx
j = n2
b1 = cc(j)
b2 = 0.0
do i = 1,m2
   j = j - 2
   temp = b1
   b1 = tx*b1 - b2 + cc(j)
   b2 = temp
end do
aic = bx*b1 - b2 + cc(2)
j = n2 - 1
b1 = cc(j)
b2 = 0.0
do i = 1,m2
   j = j - 2
   temp = b1
   b1 = tx*b1 - b2 + cc(j)
   b2 = temp
end do
rc = bx*b1 - b2 + cc(1)
si = (rc*cos(ax) + aic*sin(ax))/ax
si = pio2 - si
if (x < 0.0) si = -si
return
50 si = sign(pio2,x)
end function si

pure elemental function cin(x)
implicit none
real, intent(in) :: x
integer :: i, j
real :: aic, amax, ax, b1, b2, bx, rc, temp, tx
real :: cin
integer, parameter :: n1 = 16
integer, parameter :: n2 = 46
integer, parameter :: m1 = 14
integer, parameter :: m2 = 21
real, parameter :: econ = 5.77215664901533e-01
real, parameter :: bb(16) = [1.82820351064538e-01, -8.23768704567135e-02, -1.03468764544958e-02, 5.05085201960312e-03, &
   & 5.73772812356328e-05, -1.42717916181096e-04, 2.89263664732599e-06, 2.43068098304909e-06, -7.90337487433443e-08, - &
   & 2.80205535437371e-08, 1.05488738052065e-09, 2.34186901801115e-10, -9.27762554764014e-12, -1.48682586858284e-12, &
   & 5.95210263082868e-14, 7.42057835287916e-15]
real, parameter :: cc(46) = [9.76155271128712e-01, 8.96845854916423e-02, -3.04656658030696e-02, 8.50892472922945e-02, - &
   & 5.78073683148386e-03, -5.07182677775691e-03, 8.38643256650893e-04, -3.34223415981738e-04, -2.15746207281216e-05, &
   & 1.28560650086065e-04, -1.56456413510232e-05, -1.52025513597262e-05, 4.04001013843204e-06, -5.95896122752160e-07, - &
   & 4.34985305974340e-07, 7.13472533530840e-07, -5.34302186061100e-08, -1.76003581156610e-07, 3.85028855125900e-08, &
   & 1.92576544441700e-08, -1.00735358217200e-08, 3.36359194377000e-09, 1.28049619406000e-09, -2.42546870827000e-09, &
   & 1.86917288950000e-10, 7.13431298340000e-10, -1.70673483710000e-10, -1.14604070350000e-10, 5.88004411500000e-11, - &
   & 6.78417843000000e-12, -1.21572380900000e-11, 1.26561248700000e-11, 4.74814180000000e-13, -5.32309477000000e-12, &
   & 9.05903810000000e-13, 1.40046450000000e-12, -5.00968320000000e-13, -1.80458040000000e-13, 1.66162910000000e-13, - &
   & 5.02616400000000e-14, -3.48453600000000e-14, 4.60056600000000e-14, 5.74000000000000e-16, -1.95310700000000e-14, &
   & 3.68837000000000e-15, 5.62862000000000e-15]
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     Written by D.E. Amos and S.L. Daniel, November, 1975.
!     Modified by A.H. Morris
!     references
!         SAND76-0062
!         the special functions and their approximations, vol. II, by
!         Y.L. Luke. Academic press, new york, 1969.
!     Abstract
!         cin computes the integral of (1-cos(T))/T on (0,x) by means
!         of Chebyshev expansions on (0,5) and (5,INFINITY).
!     Description of arguments
!         input
!           x      - Limit of integration, unrestricted
!         output
!           cin    - Value of the integral
!     -------------------
!     -------------------
!     -------------------
!     -------------------
!     ****** amax is a machine dependent constant. It is assumed that
!            sin(x) and cos(x) are defined for  abs(x) .LE. amax, and
!            that econ + LN(x) - (1 + 1/x)/x = econ + LN(x)
!            FOR x .GT. amax.
amax = 0.1/spmpar(1)
ax = abs(x)
if (ax > 5.0) go to 20
j = n1
bx = 0.40*ax - 1.0
tx = bx + bx
b1 = bb(j)
b2 = 0.
do i = 1,m1
   j = j - 1
   temp = b1
   b1 = tx*b1 - b2 + bb(j)
   b2 = temp
end do
cin = x*x*(bx*b1 - b2 + bb(1))
return
20 if (ax > amax) go to 50
bx = 10./ax - 1.0
tx = bx + bx
j = n2
b1 = cc(j)
b2 = 0.0
do i = 1,m2
   j = j - 2
   temp = b1
   b1 = tx*b1 - b2 + cc(j)
   b2 = temp
end do
aic = bx*b1 - b2 + cc(2)
j = n2 - 1
b1 = cc(j)
b2 = 0.0
do i = 1,m2
   j = j - 2
   temp = b1
   b1 = tx*b1 - b2 + cc(j)
   b2 = temp
end do
rc = bx*b1 - b2 + cc(1)
cin = (rc*sin(ax) - aic*cos(ax))/ax
cin = (econ - cin) + log(ax)
return
50 cin = econ + log(ax)
end function cin

pure elemental subroutine cexexi(z, w)
implicit none
complex, intent(in) :: z
complex, intent(inout) :: w
integer :: i
real :: pm, qm, r, ss, x, y, ts(2), sr(2), sm(2), tm(2), qf(2), zl(2)
real, parameter :: const = 2.46740110027234
real, parameter :: euler = .577215664901533
real, parameter :: zeta2 = 1.64493406684823
real, parameter :: ed(18) = [0.00000000000000e+00, .311105957086528e-01, .103661260539112e+00, .216532335244554e+00, &
   & .369931427960192e+00, .566766259990589e+00, .814042066324748e+00, .112384247540813e+01, .151400478148512e+01, &
   & .200886795032284e+01, .264052411823592e+01, .345098449933392e+01, .449583360763202e+01, .585058263409822e+01, &
   & .762273501463380e+01, .997814501584578e+01, .132122064896408e+02, .180322948376021e+02]
real, parameter :: ee(18) = [.850156516121093e-02, .505037465849058e-01, .836817368956407e-01, .107047582417607e+00, &
   & .120424719029462e+00, .125096631582229e+00, .122314435224685e+00, .112621417553907e+00, .963419407392582e-01, &
   & .747398422757511e-01, .508596135953441e-01, .290822706773628e-01, .132201640530101e-01, .443802939829067e-02, &
   & .992612478987576e-03, .126579795112011e-03, .702150908253350e-05, .910281532564632e-07]
real, parameter :: dd(19) = [0.00000000000000e+00, .419556678374293e-01, .117533661648665e+00, .228560237455987e+00, &
   & .375667350161240e+00, .791594846276672e+00, .107546889623058e+01, .142659208030841e+01, .186290554952377e+01, &
   & .240730009509856e+01, .308854035607524e+01, .394277605155259e+01, .501593196543981e+01, .636759180748651e+01, &
   & .807776193096055e+01, .102598961138887e+02, .130896768422610e+02, .168832169085916e+02, .224083240941713e+02]
real, parameter :: de(19) = [-.346911733535892e-03, -.603787732461745e-02, -.152461305949249e-01, -.210582169827291e-01, - &
   & .171894208720754e-01, .314323467033032e-01, .750898531566972e-01, .124689787807260e+00, .168579075090035e+00, &
   & .191715080699511e+00, .182600794550836e+00, .142345674307147e+00, .874862222419327e-01, .402175083288425e-01, &
   & .128575005680180e-01, .257673782598441e-02, .275955003784349e-03, .119139315517122e-04, .107292980199386e-06]
real, parameter :: cd(18) = [0.00000000000000e+00, .237286128313683e-01, .854113210668760e-01, .185276627282059e+00, &
   & .323741526616688e+00, .503045460381267e+00, .728806607587188e+00, .101122770102872e+01, .136598448171249e+01, &
   & .181510139038929e+01, .238824701955419e+01, .312490532008812e+01, .407802489894445e+01, .532033545554865e+01, &
   & .695624307290579e+01, .914759902547031e+01, .121829074388544e+02, .167511311969873e+02]
real, parameter :: ce(18) = [.349517258926827e-01, .135849105925897e+00, .158850581552296e+00, .153001434535435e+00, &
   & .134520752856461e+00, .111913051619671e+00, .892008386656190e-01, .679227205472067e-01, .486723197887211e-01, &
   & .320170976532266e-01, .187008965021111e-01, .929708414427865e-02, .372604763161087e-02, .111989537559823e-02, &
   & .228057496872353e-03, .269596227781453e-04, .141255430224301e-05, .176352326808806e-07]
!-----------------------------------------------------------------------
!        Computation of the exponential exponential integral
!-----------------------------------------------------------------------
!-------------------------
!     euler = euler constant
!     const = (pi*pi)/4
!     zeta2 = The Riemann zeta function evaluated at 2
!-------------------------
!-------------------------
!-------------------------
!-------------------------
!-------------------------
x = real(z)
y = aimag(z)
r = x*x + y*y
if (r <= 1.0) go to 100
if (r >= 1296.0) go to 10
if (x < 0.07*y*y) go to 30
go to 40
!-----------------------------------------------------------------------
!                     Asymptotic expansion
!-----------------------------------------------------------------------
10 qf(1) = x/r
qf(2) = -y/r
sm(1) = -qf(1)
sm(2) = -qf(2)
tm(1) = sm(1)
tm(2) = sm(2)
pm = 1.0
20 ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
tm(1) = pm*ts(1)
tm(2) = pm*ts(2)
pm = pm + 1.0
ts(1) = tm(1)/pm
ts(2) = tm(2)/pm
if (abs(sm(1)) + abs(ts(1)) /= abs(sm(1))) go to 21
if (abs(sm(2)) + abs(ts(2)) == abs(sm(2))) go to 130
21 sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
if (pm < 36.0) go to 20
go to 130
!-----------------------------------------------------------------------
!                      Rational expansion
!-----------------------------------------------------------------------
30 sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = x - cd(i)
   ts(2) = y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = -ce(i)*ts(1)/ss
   tm(2) = ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
go to 130
!-----------------------------------------------------------------------
!                 Expansion involving EI and DI
!-----------------------------------------------------------------------
40 zl(1) = euler + 0.5*log(r)
zl(2) = atan2(-y, -x)
!                    SET sm = exp(z)*EI(-z)
sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = -x - ed(i)
   ts(2) = -y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = ee(i)*ts(1)/ss
   tm(2) = -ee(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
sr(1) = zl(1)*sm(1) - zl(2)*sm(2)
sr(2) = zl(1)*sm(2) + zl(2)*sm(1)
!                    SET sm = exp(z)*DI(-z)
sm(1) = 0.0
sm(2) = 0.0
do i = 1,19
   ts(1) = -x - dd(i)
   ts(2) = -y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) = de(i)*ts(1)/ss
   tm(2) = -de(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ts(1) = -(x*sm(1) + y*sm(2))/r
ts(2) = -(x*sm(2) - y*sm(1))/r
!                    Compute the expansion
sr(1) = sr(1) - ts(1) - zeta2
sr(2) = sr(2) - ts(2)
sm(1) = 0.0
sm(2) = 0.0
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
qm = zeta2
70 pm = pm + 1.0
qm = qm - 1.0/(pm*pm)
ts(1) = tm(1)*x - tm(2)*y
ts(2) = tm(1)*y + tm(2)*x
tm(1) = ts(1)/pm
tm(2) = ts(2)/pm
ts(1) = qm*tm(1)
ts(2) = qm*tm(2)
if (abs(sm(1)) + abs(ts(1)) /= abs(sm(1))) go to 71
if (abs(sm(2)) + abs(ts(2)) == abs(sm(2))) go to 80
71 sm(1) = sm(1) - ts(1)
sm(2) = sm(2) - ts(2)
go to 70
80 sm(1) = sr(1) + sm(1)
sm(2) = sr(2) + sm(2)
!                      Compute exp(-z)*sm
qm = exp(-x)
qf(1) = qm*cos(-y)
qf(2) = qm*sin(-y)
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 130
!-----------------------------------------------------------------------
!                  Series for x*x + y*y .LE. 1
!-----------------------------------------------------------------------
100 sm(1) = 0.0
sm(2) = 0.0
zl(1) = euler + 0.5*log(r)
zl(2) = atan2(-y, -x)
sr(1) = const + 0.5*(zl(1)*zl(1) - zl(2)*zl(2))
sr(2) = zl(1)*zl(2)
tm(1) = 1.0
tm(2) = 0.0
pm = 0.0
qm = 0.0
110 pm = pm + 1.0
qm = qm + 1.0/pm
ts(1) = -tm(1)*x + tm(2)*y
ts(2) = -tm(1)*y - tm(2)*x
tm(1) = ts(1)/pm
tm(2) = ts(2)/pm
r = (zl(1) - 1.0/pm) - qm
ts(1) = (r*tm(1) - zl(2)*tm(2))/pm
ts(2) = (r*tm(2) + zl(2)*tm(1))/pm
if (abs(sm(1)) + abs(ts(1)) /= abs(sm(1))) go to 111
if (abs(sm(2)) + abs(ts(2)) == abs(sm(2))) go to 120
111 sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
go to 110
120 sm(1) = sr(1) + sm(1)
sm(2) = sr(2) + sm(2)
!-----------------------------------------------------------------------
!                         Termination
!-----------------------------------------------------------------------
130 w = cmplx(sm(1), sm(2))
end subroutine cexexi

pure elemental complex function cli(z)
implicit none
complex, intent(in) :: z
integer :: n
real :: qf(2), dl(2), ds, zd(2), zl(2), az(2), pm, r, sm(2), tm(2), ts(2), sr(2)
real, parameter :: c = 1.64493406684823
real, parameter :: qb(25) = [2.77777777777778e-2, -1.00000000000000e-2, -1.70068027210884e-2, -1.94444444444444e-2, - &
   & 2.06611570247934e-2, -2.14173006480699e-2, -2.19488663772311e-2, -2.23492338111715e-2, -2.26636891351914e-2, - &
   & 2.29178211549926e-2, -2.31276449354844e-2, -2.33038680700203e-2, -2.34539766464373e-2, -2.35833786876607e-2, - &
   & 2.36960832049849e-2, -2.37951264448373e-2, -2.38828504258091e-2, -2.39610907251825e-2, -2.40313063764460e-2, - &
   & 2.40946717197585e-2, -2.41521426124012e-2, -2.42045049812210e-2, -2.42524109782181e-2, -2.42964062815807e-2, - &
   & 2.43369509729144e-2]
interface
   pure elemental function cpabs(x,y)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real :: cpabs
   end function cpabs
end interface
!     ******************************************************************
!     Computation of the complex logarithmic integral
!     ******************************************************************
!     ---------------------
!     c = pi**2/6
!     ---------------------
!     ---------------------
!     ---------------------
az(1) = real(z)
az(2) = aimag(z)
r = cpabs(az(1),az(2))
if (r > 0.5) go to 10
sr(1) = 0.0
sr(2) = 0.0
qf(1) = -az(1)
qf(2) = -az(2)
tm(1) = az(1)
tm(2) = az(2)
go to 30
10 if (r < 3.0) go to 20
zl(1) = log(r)
zl(2) = atan2(az(2),az(1))
sr(1) = c + 0.5*(zl(1)*zl(1) - zl(2)*zl(2))
sr(2) = zl(1)*zl(2)
qf(1) = (-az(1)/r)/r
qf(2) = (az(2)/r)/r
tm(1) = qf(1)
tm(2) = qf(2)
go to 30
20 zd(1) = 1.0 + az(1)
zd(2) = az(2)
ds = zd(1)*zd(1) + zd(2)*zd(2)
if (ds == 0.0) go to 100
dl(1) = 0.5*log(ds)
dl(2) = atan2(zd(2),zd(1))
if (ds > 0.25) go to 50
zl(1) = log(r)
zl(2) = atan2(-az(2),-az(1))
sr(1) = -c + (dl(1)*zl(1) - dl(2)*zl(2))
sr(2) = dl(1)*zl(2) + dl(2)*zl(1)
qf(1) = zd(1)
qf(2) = zd(2)
tm(1) = qf(1)
tm(2) = qf(2)
!             Evaluation of the Taylor series
30 sr(1) = sr(1) + tm(1)
sr(2) = sr(2) + tm(2)
sm(1) = 0.0
sm(2) = 0.0
pm = 1.0
40 pm = pm + 1.0
ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
tm(1) = ts(1)
tm(2) = ts(2)
ts(1) = tm(1)/(pm*pm)
ts(2) = tm(2)/(pm*pm)
if (abs(sm(1)) + abs(ts(1)) /= abs(sm(1))) go to 41
if (abs(sm(2)) + abs(ts(2)) == abs(sm(2))) go to 80
41 sm(1) = sm(1) + ts(1)
sm(2) = sm(2) + ts(2)
go to 40
!        Evaluation of the series in  U = -LN(1 + z)
50 qf(1) = dl(1)*dl(1) - dl(2)*dl(2)
qf(2) = 2.0*dl(1)*dl(2)
sr(1) = dl(1) + 0.25*qf(1)
sr(2) = dl(2) + 0.25*qf(2)
sm(1) = 0.0
sm(2) = 0.0
tm(1) = dl(1)
tm(2) = dl(2)
do n = 1,25
   ts(1) = qb(n)*(tm(1)*qf(1) - tm(2)*qf(2))
   ts(2) = qb(n)*(tm(1)*qf(2) + tm(2)*qf(1))
   tm(1) = ts(1)
   tm(2) = ts(2)
   if (abs(sm(1)) + abs(tm(1)) /= abs(sm(1))) go to 60
   if (abs(sm(2)) + abs(tm(2)) == abs(sm(2)) &
      & ) exit
60 sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
80 cli = cmplx(sr(1) + sm(1), sr(2) + sm(2))
return
!                  Evaluation at z = -1
100 cli = cmplx(-c, 0.0)
end function cli

pure elemental real function ali(x)
implicit none
real, intent(in) :: x
integer :: i, l
real :: t, w
real, parameter :: const = 1.64493406684823
double precision, parameter :: x0 = -12.5951703698450161286398965d0
real, parameter :: a(5) = [.217590467528373e+01, .165569610692639e+01, .522944061702389e+00, .626073688152965e-01, &
   & .187280204672313e-02]
real, parameter :: b(6) = [.242590467528371e+01, .215106116463796e+01, .853664388896516e+00, .148635712775060e+00, &
   & .936304016023909e-02, .115362459229893e-03]
real, parameter :: c(10) = [-.139792925233661e+01, .368504569727477e+00, .467406917183686e-01, .113795257294490e-01, &
   & .369638462505741e-02, .140888669464352e-02, .580505641503297e-03, .279065584075104e-03, .727678355839120e-04, &
   & .941452067850052e-04]
real, parameter :: d(2) = [-.164792925233634e+01, .669375771675355e+00]
real, parameter :: e(18) = [-.194565741631859e+00, -.430017756528812e-02, -.129188263110634e-03, -.344864872694838e-05, &
   & .566899694553089e-09, .126641834906132e-07, .163966793864421e-08, .164221074630109e-09, .149644905021032e-10, &
   & .130214292886747e-11, .110415518123737e-12, .921674760163207e-14, .761646464974859e-15, .625216733700975e-16, &
   & .510910937990370e-17, .416215390793180e-18, .338357379188308e-19, .274674744366340e-20]
real, parameter :: p(4) = [-.124827318209942e+01, -.593706951284264e-01, .368603360394688e-01, .243497524184253e-02]
real, parameter :: q(8) = [.100000000000000e+01, .252618047164349e+00, .171618729068655e-01, .234444792844727e-03, - &
   & .174928841869743e-05, .347369010951250e-07, -.713275908929482e-09, .958397514026421e-11]
real, parameter :: r(7) = [.265189940015693e+00, .230201018075415e+00, .315999623504943e-01, .154066621939470e-02, &
   & .286697611038892e-04, .163031291368652e-06, .838957807732251e-10]
real, parameter :: s(6) = [.100000000000000e+01, .177195068872258e+00, .110559275223905e-01, .291916852717175e-03, &
   & .304793254397420e-05, .882114921507386e-08]
!-----------------------------------------------------------------------
!            Computation of the real dilogarithm function
!-----------------------------------------------------------------------
!     Written by
!        Alfred H. Morris, Jr.
!        naval surface weapons center
!        Dahlgren Virginia
!-----------------------------------------------------------------------
!--------------------------
!     const = pi**2/6
!     x0 = Zero of the real dilogarithm function
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
!--------------------------
if (x > 1.0) go to 50
if (x >= 0.0) go to 40
if (x >= -0.5) go to 30
if (x >= -1.0) go to 20
if (x >= -2.0) go to 10
!                            x .LT. -2
if (x >= -26.63 .and. x <= -6.97) go to 100
t = -1.0/x
w = (((((((((((c(10)*t + c(9))*t + c(8))*t + c(7))*t + c(6))*t + &
   & c(5))*t + c(4))*t + c(3))*t + c(2))*t + c(1))*t + &
   & 0.5) + 0.5) / ((d(2)*t + d(1))*t + 1.0)
ali = 0.5*log(-x)**2 - (2.0*const + w/x)
return
!                        -2 .LE. x .LT. -1
10 t = -(1.0 + x)
w = (((((a(5)*t + a(4))*t + a(3))*t + a(2))*t + a(1))*t + 1.0)/ &
   & ((((((b(6)*t + b(5))*t + b(4))*t + b(3))*t + b(2))*t + &
   & b(1))*t + 1.0)
ali = -(const + t*w) + log(-x)*log(t)
return
!                       -1 .LE. x .LT. -1/2
20 t = 0.5 + (0.5 + x)
ali = -const
if (t == 0.0) return
w = (((((((((((c(10)*t + c(9))*t + c(8))*t + c(7))*t + c(6))*t + &
   & c(5))*t + c(4))*t + c(3))*t + c(2))*t + c(1))*t + &
   & 0.5) + 0.5) / ((d(2)*t + d(1))*t + 1.0)
ali = (-const + t*w) + log(-x)*log(t)
return
!                       -1/2 .LE. x .LT. 0
30 t = -x
w = (((((((((((c(10)*t + c(9))*t + c(8))*t + c(7))*t + c(6))*t + &
   & c(5))*t + c(4))*t + c(3))*t + c(2))*t + c(1))*t + &
   & 0.5) + 0.5) / ((d(2)*t + d(1))*t + 1.0)
ali = x*w
return
!                         0 .LE. x .LE. 1
40 w = (((((a(5)*x + a(4))*x + a(3))*x + a(2))*x + a(1))*x + 1.0)/ &
   & ((((((b(6)*x + b(5))*x + b(4))*x + b(3))*x + b(2))*x + &
   & b(1))*x + 1.0)
ali = x*w
return
!                            x .GT. 1
50 t = 1.0/x
w = (((((a(5)*t + a(4))*t + a(3))*t + a(2))*t + a(1))*t + 1.0)/ &
   & ((((((b(6)*t + b(5))*t + b(4))*t + b(3))*t + b(2))*t + &
   & b(1))*t + 1.0)
ali = (const - w/x) + 0.5*log(x)**2
return
!-----------------------------------------------------------------------
!              Evaluation for  -26.63 .LE. x .LE. -6.97
!-----------------------------------------------------------------------
100 if (x <= -14.0) go to 120
if (x <= -11.1) go to 110
!                    -11.1 .LT. x .LE. -6.97
t = -(x + 7.0)
ali = (((p(4)*t + p(3))*t + p(2))*t + p(1)) / (((((((q(8)*t + &
   & q(7))*t + q(6))*t + q(5))*t + q(4))*t + q(3))*t + &
   & q(2))*t + q(1))
return

!                     -14 .LT. x .LE. -11.1
110 t = dble(x) - x0
w = e(14)
do l = 1,13
   i = 14 - l
   w = w*t + e(i)
end do
ali = t*w
return
!                     -26.63 .LE. x .LE. -14
120 t = -(x + 14.0)
ali = ((((((r(7)*t + r(6))*t + r(5))*t + r(4))*t + r(3))*t + &
   & r(2))*t + r(1)) / (((((s(6)*t + s(5))*t + &
   & s(4))*t + s(3))*t + s(2))*t + s(1))
end function ali

pure elemental subroutine cgamma(mo, z, w)
implicit none
integer, intent(in) :: mo
complex, intent(in) :: z
complex, intent(inout) :: w
integer :: j, k, l, m, max, n, nm1
real :: a, a1, a2, c, cn, cut, d, e2t, eps, et, h1, h2, s, s1, s2, sn, t, t1, t2, u, u1, u2, v1, v2, w1, w2, x, y, y2
complex :: eta, eta2, sum
real, parameter :: pi = 3.14159265358979
real, parameter :: pi2 = 6.28318530717959
real, parameter :: alpi = 1.14472988584940
real, parameter :: hl2p = .918938533204673
real, parameter :: c0(12) = [.833333333333333e-01, -.277777777777778e-02, .793650793650794e-03, -.595238095238095e-03, &
   & .841750841750842e-03, -.191752691752692e-02, .641025641025641e-02, -.295506535947712e-01, .179644372368831e+00, - &
   & .139243221690590e+01, .134028640441684e+02, -.156848284626002e+03]
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
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
!        Evaluation of the complex gamma and LOGGAMMA functions
!                        ---------------
!     mo is an integer, z a complex argument, and w a complex variable.
!                 w = gamma(z)       IF mo = 0
!                 w = ln(gamma(z))   otherwise
!-----------------------------------------------------------------------
!---------------------------
!     alpi = log(pi)
!     hl2p = 0.5 * log(2*pi)
!---------------------------
!---------------------------
!---------------------------
!     ****** max and eps are machine dependent constants.
!            Max is the largest positive integer that may
!            be used, and eps is the smallest real number
!            such that 1.0 + eps .GT. 1.0.
max = ipmpar(3)
eps = spmpar(1)
!---------------------------
x = real(z)
y = aimag(z)
if (x >= 0.0) go to 50
!-----------------------------------------------------------------------
!            Case when the real part of z is negative
!-----------------------------------------------------------------------
y = abs(y)
t = -pi*y
et = exp(t)
e2t = et*et
!     SET  a1 = (1 + e2t)/2  AND  a2 = (1 - e2t)/2
a1 = 0.5*(1.0 + e2t)
t2 = t + t
if (t2 < -0.15) go to 10
a2 = -0.5*rexp(t2)
go to 20
10 a2 = 0.5*(0.5 + (0.5 - e2t))
!     Compute sin(PI*X) and cos(PI*X)
20 if (abs(x) >= min(float(max), 1.0/eps)) go to 200
k = abs(x)
u = x + k
k = mod(k,2)
if (u > -0.5) go to 21
u = 0.5 + (0.5 + u)
k = k + 1
21 u = pi*u
sn = sin(u)
cn = cos(u)
if (k /= 1) go to 30
sn = -sn
cn = -cn
!     Set  h1 + h2*I  to  pi/sin(PI*z)  or  log(pi/sin(pi*z))
30 a1 = sn*a1
a2 = cn*a2
a = a1*a1 + a2*a2
if (a == 0.0) go to 200
if (mo /= 0) go to 40
h1 = a1/a
h2 = -a2/a
c = pi*et
h1 = c*h1
h2 = c*h2
go to 41
40 h1 = (alpi + t) - 0.5*log(a)
h2 = -atan2(a2,a1)
41 if (aimag(z) < 0.0) go to 42
x = 1.0 - x
y = -y
go to 50
42 h2 = -h2
x = 1.0 - x
!-----------------------------------------------------------------------
!           Case when the real part of z is nonnegative
!-----------------------------------------------------------------------
50 w1 = 0.0
w2 = 0.0
n = 0
t = x
y2 = y*y
a = t*t + y2
cut = 36.0
if (eps > 1.e-8) cut = 16.0
if (a >= cut) go to 80
if (a == 0.0) go to 200
51 n = n + 1
t = t + 1.0
a = t*t + y2
if (a < cut) go to 51
!     Let S1 + S2*I be the product of the terms (z+j)/(z+n)
u1 = (x*t + y2)/a
u2 = y/a
s1 = u1
s2 = n*u2
if (n < 2) go to 70
u = t/a
nm1 = n - 1
do j = 1,nm1
   v1 = u1 + j*u
   v2 = (n - j)*u2
   c = s1*v1 - s2*v2
   d = s1*v2 + s2*v1
   s1 = c
   s2 = d
end do
!     Set  W1 + W2*I = log(S1 + S2*I)  when mo is nonzero
70 s = s1*s1 + s2*s2
if (mo == 0) go to 80
w1 = 0.5 * log(s)
w2 = atan2(s2,s1)
!     SET  V1 + V2*I = (z - 0.5) * log(z + n) - z
80 t1 = 0.5 * log(a) - 1.0
t2 = atan2(y,t)
u = x - 0.5
v1 = (u*t1 - 0.5) - y*t2
v2 = u*t2 + y*t1
!     Let a1 + a2*I be the asymptotic sum
eta = cmplx(t/a,-y/a)
eta2 = eta*eta
m = 12
if (a >= 289.0) m = 6
if (eps > 1.e-8) m = m/2
sum = cmplx(c0(m),0.0)
l = m
do j = 2,m
   l = l - 1
   sum = cmplx(c0(l),0.0) + sum*eta2
end do
sum = sum*eta
a1 = real(sum)
a2 = aimag(sum)
!-----------------------------------------------------------------------
!                 Gathering together the results
!-----------------------------------------------------------------------
w1 = (((a1 + hl2p) - w1) + v1) - n
w2 = (a2 - w2) + v2
if (real(z) < 0.0) go to 120
if (mo /= 0) go to 110
!     Case when the real part of z is nonnegative and mo = 0
a = exp(w1)
w1 = a * cos(w2)
w2 = a * sin(w2)
if (n == 0) go to 140
c = (s1*w1 + s2*w2)/s
d = (s1*w2 - s2*w1)/s
w1 = c
w2 = d
go to 140
!     Case when the real part of z is nonnegative and mo is nonzero.
!     The angle W2 is reduced to the interval -Pi .LT. W2 .LE. pi.
110 if (w2 > pi) go to 111
k = 0.5 - w2/pi2
w2 = w2 + pi2*k
go to 140
111 k = w2/pi2 - 0.5
w2 = w2 - pi2*float(k + 1)
if (w2 <= -pi) w2 = pi
go to 140
!     Case when the real part of z is negative and mo is nonzero
120 if (mo == 0) go to 130
w1 = h1 - w1
w2 = h2 - w2
go to 110
!     Case when the real part of z is negative and mo = 0
130 a = exp(-w1)
t1 = a * cos(-w2)
t2 = a * sin(-w2)
w1 = h1*t1 - h2*t2
w2 = h1*t2 + h2*t1
if (n == 0) go to 140
c = w1*s1 - w2*s2
d = w1*s2 + w2*s1
w1 = c
w2 = d
!     Termination
140 w = cmplx(w1,w2)
return
!-----------------------------------------------------------------------
!             The requested value cannot be computed
!-----------------------------------------------------------------------
200 w = (0.0, 0.0)
end subroutine cgamma

pure elemental complex function cgam0(z)
implicit none
complex, intent(in) :: z
integer :: i, k, n
real :: x, y
complex :: w
real, parameter :: a(25) = [.577215664901533e+00, -.655878071520254e+00, -.420026350340952e-01, .166538611382291e+00, - &
   & .421977345555443e-01, -.962197152787697e-02, .721894324666310e-02, -.116516759185907e-02, -.215241674114951e-03, &
   & .128050282388116e-03, -.201348547807882e-04, -.125049348214267e-05, .113302723198170e-05, -.205633841697761e-06, &
   & .611609510448142e-08, .500200764446922e-08, -.118127457048702e-08, .104342671169110e-09, .778226343990507e-11, - &
   & .369680561864221e-11, .510037028745448e-12, -.205832605356651e-13, -.534812253942302e-14, .122677862823826e-14, - &
   & .118125930169746e-15]
!-----------------------------------------------------------------------
!          Evaluation of 1/gamma(1 + z)  for abs(z) .LT. 1.0
!-----------------------------------------------------------------------
!-----------------------
!-----------------------
n = 25
x = real(z)
y = aimag(z)
if (x*x + y*y <= 0.04) n = 14
k = n
w = a(n)
do i = 2,n
   k = k - 1
   w = a(k) + z*w
end do
cgam0 = 1.0 + z*w
end function cgam0

pure elemental real function gamma(a)
implicit none
real, intent(in) :: a
integer :: i, j, m, n, nswc_ai_i4
real :: bot, s, t, top, w, x
double precision :: g, z, lnx
real, parameter :: pi = 3.1415926535898
double precision, parameter :: d = .41893853320467274178d0
real, parameter :: p(7) = [.539637273585445e-03, .261939260042690e-02, .204493667594920e-01, .730981088720487e-01, &
   & .279648642639792e+00, .553413866010467e+00, 1.0]
real, parameter :: q(7) = [-.832979206704073e-03, .470059485860584e-02, .225211131035340e-01, -.170458969313360e+00, - &
   & .567902761974940e-01, .113062953091122e+01, 1.0]
real, parameter :: r1 = .820756370353826e-03
real, parameter :: r2 = -.595156336428591e-03
real, parameter :: r3 = .793650663183693e-03
real, parameter :: r4 = -.277777777770481e-02
real, parameter :: r5 = .833333333333333e-01
interface
   pure elemental function exparg(l)
      implicit none
      integer, intent(in) :: l
      real :: exparg
   end function exparg
   pure elemental function glog(x)
      implicit none
      real, intent(in) :: x
      double precision :: glog
   end function glog
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!         Evaluation of the gamma function for real arguments
!                           -----------
!     gamma(a) is assigned the value 0 when the gamma function CANNOT
!     be computed.
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!          naval surface weapons center
!          Dahlgren, Virginia
!-----------------------------------------------------------------------
!--------------------------
!     d = 0.5*(ln(2*pi) - 1)
!--------------------------
!--------------------------
!--------------------------
!--------------------------
gamma = 0.0
x = a
if (abs(a) >= 15.0) go to 60
!-----------------------------------------------------------------------
!            Evaluation of gamma(a) for abs(a) .LT. 15
!-----------------------------------------------------------------------
t = 1.0
m = int(a) - 1
!     Let t be the product of a-j when a .GE. 2
nswc_ai_i4 = m
if (nswc_ai_i4 < 0) go to 20
if (nswc_ai_i4 == 0) go to 12
go to 10
10 do j = 1,m
   x = x - 1.0
   t = x*t
end do
12 x = x - 1.0
go to 40
!     Let t be the product of a+j when a .LT. 1
20 t = a
if (a > 0.0) go to 30
m = - m - 1
if (m == 0) go to 22
do j = 1,m
   x = x + 1.0
   t = x*t
end do
22 x = (x + 0.5) + 0.5
t = x*t
if (t == 0.0) return
30 continue
!     The following code checks if 1/t can overflow. This
!     code may be omitted if desired.
if (abs(t) >= 1.e-30) go to 40
if (abs(t)*spmpar(3) <= 1.0001) return
gamma = 1.0/t
return
!     Compute gamma(1 + x) for  0 .LE. x .LT. 1
40 top = p(1)
bot = q(1)
do i = 2,7
   top = p(i) + x*top
   bot = q(i) + x*bot
end do
gamma = top/bot
!     Termination
if (a < 1.0) go to 50
gamma = gamma*t
return
50 gamma = gamma/t
return
!-----------------------------------------------------------------------
!            Evaluation of gamma(a) for abs(a) .GE. 15
!-----------------------------------------------------------------------
60 if (abs(a) >= 1.e3) return
if (a > 0.0) go to 70
x = -a
n = x
t = x - n
if (t > 0.9) t = 1.0 - t
s = sin(pi*t)/pi
if (mod(n,2) == 0) s = -s
if (s == 0.0) return
!     Compute the modified asymptotic sum
70 t = 1.0/(x*x)
g = ((((r1*t + r2)*t + r3)*t + r4)*t + r5)/x
!     One may replace the next statement with  lnx = ALOG(x)
!     but less accuracy will normally be obtained.
lnx = glog(x)
!     Final assembly
z = x
g = (d + g) + (z - 0.5d0)*(lnx - 1.d0)
w = g
t = g - dble(w)
if (w > 0.99999*exparg(0)) return
gamma = exp(w)*(1.0 + t)
if (a < 0.0) gamma = (1.0/(gamma*s))/x
end function gamma

pure elemental double precision function glog(x)
implicit none
real, intent(in) :: x
integer :: n
real :: t, t2
double precision :: z
real, parameter :: c1 = .286228750476730
real, parameter :: c2 = .399999628131494
real, parameter :: c3 = .666666666752663
double precision, parameter :: w(163) = [.270805020110221007d+01, .277258872223978124d+01, &
   & .283321334405621608d+01, .289037175789616469d+01, .294443897916644046d+01, .299573227355399099d+01, .304452243772342300d+01, &
   & .309104245335831585d+01, .313549421592914969d+01, .317805383034794562d+01, .321887582486820075d+01, .325809653802148205d+01, &
   & .329583686600432907d+01, .333220451017520392d+01, .336729582998647403d+01, .340119738166215538d+01, .343398720448514625d+01, &
   & .346573590279972655d+01, .349650756146648024d+01, .352636052461616139d+01, .355534806148941368d+01, .358351893845611000d+01, &
   & .361091791264422444d+01, .363758615972638577d+01, .366356164612964643d+01, .368887945411393630d+01, .371357206670430780d+01, &
   & .373766961828336831d+01, .376120011569356242d+01, .378418963391826116d+01, .380666248977031976d+01, .382864139648909500d+01, &
   & .385014760171005859d+01, .387120101090789093d+01, .389182029811062661d+01, .391202300542814606d+01, .393182563272432577d+01, &
   & .395124371858142735d+01, .397029191355212183d+01, .398898404656427438d+01, .400733318523247092d+01, .402535169073514923d+01, &
   & .404305126783455015d+01, .406044301054641934d+01, .407753744390571945d+01, .409434456222210068d+01, .411087386417331125d+01, &
   & .412713438504509156d+01, .414313472639153269d+01, .415888308335967186d+01, .417438726989563711d+01, .418965474202642554d+01, &
   & .420469261939096606d+01, .421950770517610670d+01, .423410650459725938d+01, .424849524204935899d+01, .426267987704131542d+01, &
   & .427666611901605531d+01, .429045944114839113d+01, .430406509320416975d+01, .431748811353631044d+01, .433073334028633108d+01, &
   & .434380542185368385d+01, .435670882668959174d+01, .436944785246702149d+01, .438202663467388161d+01, .439444915467243877d+01, &
   & .440671924726425311d+01, .441884060779659792d+01, .443081679884331362d+01, .444265125649031645d+01, .445434729625350773d+01, &
   & .446590811865458372d+01, .447733681447820647d+01, .448863636973213984d+01, .449980967033026507d+01, .451085950651685004d+01, &
   & .452178857704904031d+01, .453259949315325594d+01, .454329478227000390d+01, .455387689160054083d+01, .456434819146783624d+01, &
   & .457471097850338282d+01, .458496747867057192d+01, .459511985013458993d+01, .460517018598809137d+01, .461512051684125945d+01, &
   & .462497281328427108d+01, .463472898822963577d+01, .464439089914137266d+01, .465396035015752337d+01, .466343909411206714d+01, &
   & .467282883446190617d+01, .468213122712421969d+01, .469134788222914370d+01, .470048036579241623d+01, .470953020131233414d+01, &
   & .471849887129509454d+01, .472738781871234057d+01, .473619844839449546d+01, .474493212836325007d+01, .475359019110636465d+01, &
   & .476217393479775612d+01, .477068462446566476d+01, .477912349311152939d+01, .478749174278204599d+01, .479579054559674109d+01, &
   & .480402104473325656d+01, .481218435537241750d+01, .482028156560503686d+01, .482831373730230112d+01, .483628190695147800d+01, &
   & .484418708645859127d+01, .485203026391961717d+01, .485981240436167211d+01, .486753445045558242d+01, .487519732320115154d+01, &
   & .488280192258637085d+01, .489034912822175377d+01, .489783979995091137d+01, .490527477843842945d+01, .491265488573605201d+01, &
   & .491998092582812492d+01, .492725368515720469d+01, .493447393313069176d+01, .494164242260930430d+01, .494875989037816828d+01, &
   & .495582705760126073d+01, .496284463025990728d+01, .496981329957600062d+01, .497673374242057440d+01, .498360662170833644d+01, &
   & .499043258677873630d+01, .499721227376411506d+01, .500394630594545914d+01, .501063529409625575d+01, .501727983681492433d+01, &
   & .502388052084627639d+01, .503043792139243546d+01, .503695260241362916d+01, .504342511691924662d+01, .504985600724953705d+01, &
   & .505624580534830806d+01, .506259503302696680d+01, .506890420222023153d+01, .507517381523382692d+01, .508140436498446300d+01, &
   & .508759633523238407d+01, .509375020080676233d+01, .509986642782419842d+01, .510594547390058061d+01, .511198778835654323d+01, &
   & .511799381241675511d+01, .512396397940325892d+01, .512989871492307347d+01, .513579843705026176d+01, .514166355650265984d+01, &
   & .514749447681345304d+01, .515329159449777895d+01, .515905529921452903d+01, .516478597392351405d+01, .517048399503815178d+01, &
   & .517614973257382914d+01]
!     -------------------
!     Evaluation of LN(x) for x .GE. 15
!     -------------------
!     -------------------
!     -------------------
!     w(J) = LN(J + 14) for each J
!     -------------------
if (x >= 178.0) go to 10
n = x
t = (x - n)/(x + n)
t2 = t*t
z = (((c1*t2 + c2)*t2 + c3)*t2 + 2.0)*t
glog = w(n - 14) + z
return
10 glog = log(x)
end function glog

pure elemental real function gam1(a)
implicit none
real, intent(in) :: a
real :: bot, d, t, top, w, nswc_ai_r4
real, parameter :: p(7) = [.577215664901533e+00, -.409078193005776e+00, -.230975380857675e+00, .597275330452234e-01, &
   & .766968181649490e-02, -.514889771323592e-02, .589597428611429e-03]
real, parameter :: q(5) = [.100000000000000e+01, .427569613095214e+00, .158451672430138e+00, .261132021441447e-01, &
   & .423244297896961e-02]
real, parameter :: r(9) = [-.422784335098468e+00, -.771330383816272e+00, -.244757765222226e+00, .118378989872749e+00, &
   & .930357293360349e-03, -.118290993445146e-01, .223047661158249e-02, .266505979058923e-03, -.132674909766242e-03]
real, parameter :: s1 = .273076135303957e+00
real, parameter :: s2 = .559398236957378e-01
!-----------------------------------------------------------------------
!     Computation of 1/gamma(a+1) - 1  For -0.5 .LE. a .LE. 1.5
!-----------------------------------------------------------------------
!------------------------
!------------------------
!------------------------
!------------------------
!------------------------
t = a
d = a - 0.5
if (d > 0.0) t = d - 0.5
nswc_ai_r4 = t
if (nswc_ai_r4 < 0) go to 30
if (nswc_ai_r4 == 0) go to 10
go to 20
10 gam1 = 0.0
return
20 top = (((((p(7)*t + p(6))*t + p(5))*t + p(4))*t + p(3))*t &
   & + p(2))*t + p(1)
bot = (((q(5)*t + q(4))*t + q(3))*t + q(2))*t + 1.0
w = top/bot
if (d > 0.0) go to 21
gam1 = a*w
return
21 gam1 = (t/a)*((w - 0.5) - 0.5)
return
30 top = (((((((r(9)*t + r(8))*t + r(7))*t + r(6))*t + r(5))*t &
   & + r(4))*t + r(3))*t + r(2))*t + r(1)
bot = (s2*t + s1)*t + 1.0
w = top/bot
if (d > 0.0) go to 31
gam1 = a*((w + 0.5) + 0.5)
return
31 gam1 = t*w/a
end function gam1

pure elemental real function gamln(a)
implicit none
real, intent(in) :: a
integer :: i, n
real :: t, w
real, parameter :: d = .418938533204673
real, parameter :: c0 = .833333333333333e-01
real, parameter :: c1 = -.277777777760991e-02
real, parameter :: c2 = .793650666825390e-03
real, parameter :: c3 = -.595202931351870e-03
real, parameter :: c4 = .837308034031215e-03
real, parameter :: c5 = -.165322962780713e-02
interface
   pure elemental function gamln1(a)
      implicit none
      real, intent(in) :: a
      real :: gamln1
   end function gamln1
end interface
!-----------------------------------------------------------------------
!            Evaluation of LN(gamma(a)) for positive A
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris
!          Naval Surface Warfare Center
!          Dahlgren, Virginia
!--------------------------
!     d = 0.5*(ln(2*pi) - 1)
!--------------------------
!--------------------------
!-----------------------------------------------------------------------
if (a > 0.8) go to 10
gamln = gamln1(a) - log(a)
return
10 if (a > 2.25) go to 20
t = (a - 0.5) - 0.5
gamln = gamln1(t)
return
20 if (a >= 10.0) go to 30
n = a - 1.25
t = a
w = 1.0
do i = 1,n
   t = t - 1.0
   w = t*w
end do
gamln = gamln1(t - 1.0) + log(w)
return
30 t = (1.0/a)**2
w = (((((c5*t + c4)*t + c3)*t + c2)*t + c1)*t + c0)/a
gamln = (d + w) + (a - 0.5)*(log(a) - 1.0)
end function gamln

pure elemental real function gamln1(a)
implicit none
real, intent(in) :: a
real :: w, x
real, parameter :: p0 = .577215664901533e+00
real, parameter :: p1 = .844203922187225e+00
real, parameter :: p2 = -.168860593646662e+00
real, parameter :: p3 = -.780427615533591e+00
real, parameter :: p4 = -.402055799310489e+00
real, parameter :: p5 = -.673562214325671e-01
real, parameter :: p6 = -.271935708322958e-02
real, parameter :: q1 = .288743195473681e+01
real, parameter :: q2 = .312755088914843e+01
real, parameter :: q3 = .156875193295039e+01
real, parameter :: q4 = .361951990101499e+00
real, parameter :: q5 = .325038868253937e-01
real, parameter :: q6 = .667465618796164e-03
real, parameter :: r0 = .422784335098467e+00
real, parameter :: r1 = .848044614534529e+00
real, parameter :: r2 = .565221050691933e+00
real, parameter :: r3 = .156513060486551e+00
real, parameter :: r4 = .170502484022650e-01
real, parameter :: r5 = .497958207639485e-03
real, parameter :: s1 = .124313399877507e+01
real, parameter :: s2 = .548042109832463e+00
real, parameter :: s3 = .101552187439830e+00
real, parameter :: s4 = .713309612391000e-02
real, parameter :: s5 = .116165475989616e-03
!-----------------------------------------------------------------------
!     Evaluation of LN(gamma(1 + a)) for -0.2 .LE. a .LE. 1.25
!-----------------------------------------------------------------------
!----------------------
!----------------------
if (a >= 0.6) go to 10
w = ((((((p6*a + p5)*a + p4)*a + p3)*a + p2)*a + p1)*a + p0)/ &
   & ((((((q6*a + q5)*a + q4)*a + q3)*a + q2)*a + q1)*a + 1.0)
gamln1 = -a*w
return
10 x = (a - 0.5) - 0.5
w = (((((r5*x + r4)*x + r3)*x + r2)*x + r1)*x + r0)/ &
   & (((((s5*x + s4)*x + s3)*x + s2)*x + s1)*x + 1.0)
gamln1 = x*w
end function gamln1

pure subroutine dcgama(mo, z, w)
implicit none
integer, intent(in) :: mo
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
integer :: j, k, max, n, nm1
double precision :: a, a1, a2, c, cn, cut, d, eps, et, e2t, h1, &
   & h2, q1, q2, s, sn, s1, s2, t, t1, t2, u, u1, u2, v1, v2, w1, w2, &
   & x, y, y2
double precision, parameter :: pi = 3.141592653589793238462643383279502884197d0
double precision, parameter :: pi2 = 6.283185307179586476925286766559005768394d0
double precision, parameter :: dlpi = 1.144729885849400174143427351353058711647d0
double precision, parameter :: hl2p = .9189385332046727417803297364056176398614d0
double precision, parameter :: c0(30) = [.8333333333333333333333333333333333333333d-01, - &
   & .2777777777777777777777777777777777777778d-02, .7936507936507936507936507936507936507937d-03, - &
   & .5952380952380952380952380952380952380952d-03, .8417508417508417508417508417508417508418d-03, - &
   & .1917526917526917526917526917526917526918d-02, .6410256410256410256410256410256410256410d-02, - &
   & .2955065359477124183006535947712418300654d-01, .1796443723688305731649384900158893966944d+00, - &
   & .1392432216905901116427432216905901116427d+01, .1340286404416839199447895100069013112491d+02, - &
   & .1568482846260020173063651324520889738281d+03, .2193103333333333333333333333333333333333d+04, - &
   & .3610877125372498935717326521924223073648d+05, .6914722688513130671083952507756734675533d+06, - &
   & .1523822153940741619228336495888678051866d+08, .3829007513914141414141414141414141414141d+09, - &
   & .1088226603578439108901514916552510537473d+11, .3473202837650022522522522522522522522523d+12, - &
   & .1236960214226927445425171034927132488108d+14, .4887880647930793350758151625180229021085d+15, - &
   & .2132033396091937389697505898213683855747d+17, .1021775296525700077565287628053585500394d+19, - &
   & .5357547217330020361082770919196920448485d+20, .3061578263704883415043151051329622758194d+22, - &
   & .1899991742639920405029371429306942902947d+24, .1276337403382883414923495137769782597654d+26, - &
   & .9252847176120416307230242348347622779519d+27, .7218822595185610297836050187301637922490d+29, - &
   & .6045183405995856967743148238754547286066d+31]
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function drexp(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: drexp
   end function drexp
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!-----------------------------------------------------------------------
!        Evaluation of the complex gamma and LOGGAMMA functions
!                        ---------------
!     mo is an integer. z and w are interpreted as double precision
!     COMPLEX NUMBERS. IT IS ASSUMED THAT z(1) AND z(2) ARE THE REAL
!     and imaginary parts of the complex number z, and that w(1) and
!     w(2) are the real and imaginary parts of w.
!                 w = gamma(z)       IF mo = 0
!                 w = ln(gamma(z))   otherwise
!-----------------------------------------------------------------------
!---------------------------
!     dlpi = log(pi)
!     hl2p = 0.5 * log(2*pi)
!---------------------------
!---------------------------
!---------------------------
!     ****** max and eps are machine dependent constants.
!            Max is the largest positive integer that may
!            be used, and eps is the smallest number such
!            THAT  1.D0 + eps .GT. 1.D0.
max = ipmpar(3)
eps = dpmpar(1)
!---------------------------
x = z(1)
y = z(2)
if (x >= 0.d0) go to 50
!-----------------------------------------------------------------------
!            Case when the real part of z is negative
!-----------------------------------------------------------------------
y = abs(y)
t = -pi*y
et = exp(t)
e2t = et*et
!     SET  a1 = (1 + e2t)/2  AND  a2 = (1 - e2t)/2
a1 = 0.5d0*(1.d0 + e2t)
t2 = t + t
if (t2 < -0.15d0) go to 10
a2 = -0.5d0*drexp(t2)
go to 20
10 a2 = 0.5d0*(0.5d0 + (0.5d0 - e2t))
!     Compute sin(pi*X) and cos(pi*X)
20 u = max
if (abs(x) >= min(u, 1.d0/eps)) go to 200
k = abs(x)
u = x + k
k = mod(k,2)
if (u > -0.5d0) go to 21
u = 0.5d0 + (0.5d0 + u)
k = k + 1
21 u = pi*u
sn = sin(u)
cn = cos(u)
if (k /= 1) go to 30
sn = -sn
cn = -cn
!     Set  h1 + H2*I  to  pi/sin(pi*z)  or  log(pi/sin(pi*z))
30 a1 = sn*a1
a2 = cn*a2
a = a1*a1 + a2*a2
if (a == 0.d0) go to 200
if (mo /= 0) go to 40
h1 = a1/a
h2 = -a2/a
c = pi*et
h1 = c*h1
h2 = c*h2
go to 41
40 h1 = (dlpi + t) - 0.5d0*log(a)
h2 = -atan2(a2,a1)
41 if (z(2) < 0.d0) go to 42
x = 1.0 - x
y = -y
go to 50
42 h2 = -h2
x = 1.0 - x
!-----------------------------------------------------------------------
!           Case when the real part of z is nonnegative
!-----------------------------------------------------------------------
50 w1 = 0.d0
w2 = 0.d0
n = 0
t = x
y2 = y*y
a = t*t + y2
cut = 225.d0
if (eps > 1.d-30) cut = 144.d0
if (eps > 1.d-20) cut = 64.d0
if (a >= cut) go to 80
if (a == 0.d0) go to 200
51 n = n + 1
t = t + 1.d0
a = t*t + y2
if (a < cut) go to 51
!     Let S1 + S2*I be the product of the terms (z+j)/(z+n)
u1 = (x*t + y2)/a
u2 = y/a
s1 = u1
s2 = n*u2
if (n < 2) go to 70
u = t/a
nm1 = n - 1
do j = 1,nm1
   v1 = u1 + j*u
   v2 = (n - j)*u2
   c = s1*v1 - s2*v2
   d = s1*v2 + s2*v1
   s1 = c
   s2 = d
end do
!     Set  W1 + W2*I = log(S1 + S2*I)  when mo is nonzero
70 s = s1*s1 + s2*s2
if (mo == 0) go to 80
w1 = 0.5d0 * log(s)
w2 = atan2(s2,s1)
!     SET  V1 + V2*I = (z - 0.5) * log(z + n) - z
80 t1 = 0.5d0 * log(a) - 1.d0
t2 = atan2(y,t)
u = x - 0.5d0
v1 = (u*t1 - 0.5d0) - y*t2
v2 = u*t2 + y*t1
!     Let a1 + a2*I be the asymptotic sum
u1 = t/a
u2 = -y/a
q1 = u1*u1 - u2*u2
q2 = 2.d0*u1*u2
a1 = 0.d0
a2 = 0.d0
do j = 1,30
   t1 = a1
   t2 = a2
   a1 = a1 + c0(j)*u1
   a2 = a2 + c0(j)*u2
   if (a1 /= t1) go to 90
   if (a2 == t2) exit
90 t1 = u1*q1 - u2*q2
   t2 = u1*q2 + u2*q1
   u1 = t1
   u2 = t2
end do
!-----------------------------------------------------------------------
!                 Gathering together the results
!-----------------------------------------------------------------------
w1 = (((a1 + hl2p) - w1) + v1) - n
w2 = (a2 - w2) + v2
if (z(1) < 0.d0) go to 120
if (mo /= 0) go to 110
!     Case when the real part of z is nonnegative and mo = 0
a = exp(w1)
w1 = a * cos(w2)
w2 = a * sin(w2)
if (n == 0) go to 140
c = (s1*w1 + s2*w2)/s
d = (s1*w2 - s2*w1)/s
w1 = c
w2 = d
go to 140
!     Case when the real part of z is nonnegative and mo is nonzero.
!     The angle W2 is reduced to the interval -pi .LT. W2 .LE. pi.
110 if (w2 > pi) go to 111
k = 0.5d0 - w2/pi2
w2 = w2 + pi2*k
go to 140
111 k = w2/pi2 - 0.5d0
u = k + 1
w2 = w2 - pi2*u
if (w2 <= -pi) w2 = pi
go to 140
!     Case when the real part of z is negative and mo is nonzero
120 if (mo == 0) go to 130
w1 = h1 - w1
w2 = h2 - w2
go to 110
!     Case when the real part of z is negative and mo = 0
130 a = exp(-w1)
t1 = a * cos(-w2)
t2 = a * sin(-w2)
w1 = h1*t1 - h2*t2
w2 = h1*t2 + h2*t1
if (n == 0) go to 140
c = w1*s1 - w2*s2
d = w1*s2 + w2*s1
w1 = c
w2 = d
!     Termination
140 w(1) = w1
w(2) = w2
return
!-----------------------------------------------------------------------
!             The requested value cannot be computed
!-----------------------------------------------------------------------
200 w(1) = 0.d0
w(2) = 0.d0
end subroutine dcgama

pure elemental double precision function dgamma(a)
implicit none
double precision, intent(in) :: a
integer :: j, n, nswc_ai_i4
double precision :: s, t, x, w
double precision, parameter :: pi = 3.14159265358979323846264338327950d0
double precision, parameter :: d = 0.41893853320467274178032973640562d0
interface
   pure elemental function dgam1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dgam1
   end function dgam1
   pure elemental function dpdel(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dpdel
   end function dpdel
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
   pure elemental function dsin1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dsin1
   end function dsin1
   pure elemental function dxparg(l)
      implicit none
      integer, intent(in) :: l
      double precision :: dxparg
   end function dxparg
end interface
!-----------------------------------------------------------------------
!                Evaluation of the gamma function for
!                     double precision arguments
!                           -----------
!     dgamma(a) is assigned the value 0 when the gamma function CANNOT
!     be computed.
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris, Jr.
!          naval surface weapons center
!          Dahlgren, Virginia
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     d = 0.5*(ln(2*pi) - 1)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
dgamma = 0.d0
x = a
if (abs(a) > 20.d0) go to 60
!-----------------------------------------------------------------------
!             Evaluation of dgamma(a) for dabs(a) .LE. 20
!-----------------------------------------------------------------------
t = 1.d0
n = x
n = n - 1
!     Let t be the product of a-j when a .GE. 2
nswc_ai_i4 = n
if (nswc_ai_i4 < 0) go to 20
if (nswc_ai_i4 == 0) go to 12
go to 10
10 do j = 1,n
   x = x - 1.d0
   t = x*t
end do
12 x = x - 1.d0
go to 40
!     Let t be the product of a+j when a .LT. 1
20 t = a
if (a > 0.d0) go to 30
n = - n - 1
if (n == 0) go to 22
do j = 1,n
   x = x + 1.d0
   t = x*t
end do
22 x = (x + 0.5d0) + 0.5d0
t = x*t
if (t == 0.d0) return
30 continue
!     The following code checks if 1/t can overflow. This
!     code may be omitted if desired.
if (abs(t) >= 1.d-33) go to 40
if (abs(t)*dpmpar(3) <= 1.000000001d0) return
dgamma = 1.d0/t
return
!     Compute dgamma(1 + x) for 0 .LE. x .LT. 1
40 dgamma = 1.d0/(1.d0 + dgam1(x))
!     Termination
if (a < 1.d0) go to 50
dgamma = dgamma * t
return
50 dgamma = dgamma / t
return
!-----------------------------------------------------------------------
!           Evaluation of dgamma(a) for dabs(a) .GT. 20
!-----------------------------------------------------------------------
60 if (abs(a) >= 1.d3) return
if (a > 0.d0) go to 70
s = dsin1(a)/pi
if (s == 0.d0) return
x = -a
!     Compute the modified asymptotic sum
70 w = dpdel(x)
!     Final assembly
w = (d + w) + (x - 0.5d0)*(log(x) - 1.d0)
if (w > dxparg(0)) return
dgamma = exp(w)
if (a < 0.d0) dgamma = (1.d0/(dgamma*s))/x
end function dgamma

pure elemental double precision function dpdel(x)
implicit none
double precision, intent(in) :: x
integer :: i, k
double precision :: t, w
double precision, parameter :: a(15) = [.833333333333333333333333333333d-01, - &
   & .277777777777777777777777752282d-04, .793650793650793650791732130419d-07, -.595238095238095232389839236182d-09, &
   & .841750841750832853294451671990d-11, -.191752691751854612334149171243d-12, .641025640510325475730918472625d-14, - &
   & .295506514125338232839867823991d-15, .179643716359402238723287696452d-16, -.139228964661627791231203060395d-17, &
   & .133802855014020915603275339093d-18, -.154246009867966094273710216533d-19, .197701992980957427278370133333d-20, - &
   & .234065664793997056856992426667d-21, .171348014966398575409015466667d-22]
!-----------------------------------------------------------------------
!     Computation of the function DEL(x) for  x .GE. 10  where
!     LN(gamma(x)) = (x - 0.5)*LN(x) - x + 0.5*LN(2*PI) + DEL(x)
!                         --------
!     The series for dpdel on the interval 0.0 to 1.0 derived by
!     A.H. Morris from the Chebyshev series in the SLATEC library
!     obtained by Wayne Fullerton (Los Alamos).
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
t = (10.d0/x)**2
w = a(15)
do i = 1,14
   k = 15 - i
   w = t*w + a(k)
end do
dpdel = w/x
end function dpdel

pure elemental double precision function dgam1(x)
implicit none
!-----------------------------------------------------------------------
!     Evaluation of 1/gamma(1 + x) - 1  For -0.5 .LE. x .LE. 1.5
!-----------------------------------------------------------------------
!     The following are the first 49 coefficients of the Maclaurin
!     expansion for 1/gamma(1 + x) - 1. The coefficients are
!     correct to 40 digits. The coefficients were obtained by
!     Alfred H. Morris Jr. (Naval Surface Warfare Center) and are
!     given here for reference. Only the first 14 coefficients are
!     used in this code.
!                           -----------
!     data a(1)  / .5772156649015328606065120900824024310422d+00/,
!    *     A(2)  /-.6558780715202538810770195151453904812798d+00/,
!    *     A(3)  /-.4200263503409523552900393487542981871139d-01/,
!    *     A(4)  / .1665386113822914895017007951021052357178d+00/,
!    *     A(5)  /-.4219773455554433674820830128918739130165d-01/,
!    *     A(6)  /-.9621971527876973562114921672348198975363d-02/,
!    *     A(7)  / .7218943246663099542395010340446572709905d-02/,
!    *     A(8)  /-.1165167591859065112113971084018388666809d-02/,
!    *     A(9)  /-.2152416741149509728157299630536478064782d-03/,
!    *     A(10) / .1280502823881161861531986263281643233949d-03/
!     data a(11) /-.2013485478078823865568939142102181838229d-04/,
!    *     A(12) /-.1250493482142670657345359473833092242323d-05/,
!    *     A(13) / .1133027231981695882374129620330744943324d-05/,
!    *     A(14) /-.2056338416977607103450154130020572836513d-06/,
!    *     A(15) / .6116095104481415817862498682855342867276d-08/,
!    *     A(16) / .5002007644469222930055665048059991303045d-08/,
!    *     A(17) /-.1181274570487020144588126565436505577739d-08/,
!    *     A(18) / .1043426711691100510491540332312250191401d-09/,
!    *     A(19) / .7782263439905071254049937311360777226068d-11/,
!    *     A(20) /-.3696805618642205708187815878085766236571d-11/
!     data a(21) / .5100370287454475979015481322863231802727d-12/,
!    *     A(22) /-.2058326053566506783222429544855237419746d-13/,
!    *     A(23) /-.5348122539423017982370017318727939948990d-14/,
!    *     A(24) / .1226778628238260790158893846622422428165d-14/,
!    *     A(25) /-.1181259301697458769513764586842297831212d-15/,
!    *     A(26) / .1186692254751600332579777242928674071088d-17/,
!    *     A(27) / .1412380655318031781555803947566709037086d-17/,
!    *     A(28) /-.2298745684435370206592478580633699260285d-18/,
!    *     A(29) / .1714406321927337433383963370267257066813d-19/,
!    *     A(30) / .1337351730493693114864781395122268022875d-21/
!     data a(31) /-.2054233551766672789325025351355733796682d-21/,
!    *     A(32) / .2736030048607999844831509904330982014865d-22/,
!    *     A(33) /-.1732356445910516639057428451564779799070d-23/,
!    *     A(34) /-.2360619024499287287343450735427531007926d-25/,
!    *     A(35) / .1864982941717294430718413161878666898946d-25/,
!    *     A(36) /-.2218095624207197204399716913626860379732d-26/,
!    *     A(37) / .1297781974947993668824414486330594165619d-27/,
!    *     A(38) / .1180697474966528406222745415509971518560d-29/,
!    *     A(39) /-.1124584349277088090293654674261439512119d-29/,
!    *     A(40) / .1277085175140866203990206677751124647749d-30/
!     data a(41) /-.7391451169615140823461289330108552823711d-32/,
!    *     A(42) / .1134750257554215760954165259469306393009d-34/,
!    *     A(43) / .4639134641058722029944804907952228463058d-34/,
!    *     A(44) /-.5347336818439198875077418196709893320905d-35/,
!    *     A(45) / .3207995923613352622861237279082794391090d-36/,
!    *     A(46) /-.4445829736550756882101590352124643637401d-38/,
!    *     A(47) /-.1311174518881988712901058494389922190237d-38/,
!    *     A(48) / .1647033352543813886818259327906394145400d-39/,
!    *     A(49) /-.1056233178503581218600561071538285049997d-40/
!                           -----------
!     c = A(1) - 1 Is also frequently needed. c has the value ...
!     data c /-.4227843350984671393934879099175975689578d+00/
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: d, t, w, z, nswc_ai_r8
double precision, parameter :: a0 = .611609510448141581788d-08
double precision, parameter :: a1 = .624730830116465516210d-08
double precision, parameter :: b1 = .203610414066806987300d+00
double precision, parameter :: b2 = .266205348428949217746d-01
double precision, parameter :: b3 = .493944979382446875238d-03
double precision, parameter :: b4 = -.851419432440314906588d-05
double precision, parameter :: b5 = -.643045481779353022248d-05
double precision, parameter :: b6 = .992641840672773722196d-06
double precision, parameter :: b7 = -.607761895722825260739d-07
double precision, parameter :: b8 = .195755836614639731882d-09
double precision, parameter :: p0 = .6116095104481415817861d-08
double precision, parameter :: p1 = .6871674113067198736152d-08
double precision, parameter :: p2 = .6820161668496170657918d-09
double precision, parameter :: p3 = .4686843322948848031080d-10
double precision, parameter :: p4 = .1572833027710446286995d-11
double precision, parameter :: p5 = -.1249441572276366213222d-12
double precision, parameter :: p6 = .4343529937408594255178d-14
double precision, parameter :: q1 = .3056961078365221025009d+00
double precision, parameter :: q2 = .5464213086042296536016d-01
double precision, parameter :: q3 = .4956830093825887312020d-02
double precision, parameter :: q4 = .2692369466186361192876d-03
double precision, parameter :: c = -.422784335098467139393487909917598d+00
double precision, parameter :: c0 = .577215664901532860606512090082402d+00
double precision, parameter :: c1 = -.655878071520253881077019515145390d+00
double precision, parameter :: c2 = -.420026350340952355290039348754298d-01
double precision, parameter :: c3 = .166538611382291489501700795102105d+00
double precision, parameter :: c4 = -.421977345555443367482083012891874d-01
double precision, parameter :: c5 = -.962197152787697356211492167234820d-02
double precision, parameter :: c6 = .721894324666309954239501034044657d-02
double precision, parameter :: c7 = -.116516759185906511211397108401839d-02
double precision, parameter :: c8 = -.215241674114950972815729963053648d-03
double precision, parameter :: c9 = .128050282388116186153198626328164d-03
double precision, parameter :: c10 = -.201348547807882386556893914210218d-04
double precision, parameter :: c11 = -.125049348214267065734535947383309d-05
double precision, parameter :: c12 = .113302723198169588237412962033074d-05
double precision, parameter :: c13 = -.205633841697760710345015413002057d-06
!----------------------------
!----------------------------
!----------------------------
!     c = c0 - 1
!----------------------------
!----------------------------
!----------------------------
t = x
d = x - 0.5d0
if (d > 0.d0) t = d - 0.5d0
nswc_ai_r8 = t
if (nswc_ai_r8 < 0) go to 40
if (nswc_ai_r8 == 0) go to 10
go to 20
10 dgam1 = 0.d0
return
!------------
!                Case when 0 .LT. t .LE. 0.5
!              w is a minimax approximation for
!              the series A(15) + A(16)*t + ...
!------------
20 w = ((((((p6*t + p5)*t + p4)*t + p3)*t + p2)*t + p1)*t + p0)/ &
   & ((((q4*t + q3)*t + q2)*t + q1)*t + 1.d0)
z = (((((((((((((w*t + c13)*t + c12)*t + c11)*t + c10)*t + &
   & c9)*t + c8)*t + c7)*t + c6)*t + c5)*t + c4)*t + &
   & c3)*t + c2)*t + c1)*t + c0
if (d > 0.d0) go to 30
dgam1 = x*z
return
30 dgam1 = (t/x)*((z - 0.5d0) - 0.5d0)
return
!------------
!                Case when -0.5 .LE. t .LT. 0
!              w is a minimax approximation for
!              the series A(15) + A(16)*t + ...
!------------
40 w = (a1*t + a0)/((((((((b8*t + b7)*t + b6)*t + b5)*t + &
   & b4)*t + b3)*t + b2)*t + b1)*t + 1.d0)
z = (((((((((((((w*t + c13)*t + c12)*t + c11)*t + c10)*t + &
   & c9)*t + c8)*t + c7)*t + c6)*t + c5)*t + c4)*t + &
   & c3)*t + c2)*t + c1)*t + c
if (d > 0.d0) go to 50
dgam1 = x*((z + 0.5d0) + 0.5d0)
return
50 dgam1 = t*z/x
end function dgam1

pure elemental double precision function dgamln(a)
implicit none
double precision, intent(in) :: a
integer :: i, n
double precision :: x, w
double precision, parameter :: d = 0.41893853320467274178032973640562d0
interface
   pure elemental function dgmln1(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dgmln1
   end function dgmln1
   pure elemental function dpdel(x)
      implicit none
      double precision, intent(in) :: x
      double precision :: dpdel
   end function dpdel
end interface
!-----------------------------------------------------------------------
!           Evaluation of LN(gamma(a)) for positive A
!-----------------------------------------------------------------------
!     Written by Alfred H. Morris
!          naval surface weapons center
!          Dahlgren, Virginia
!-----------------------------------------------------------------------
!     d = 0.5*(ln(2*pi) - 1)
!-----------------------------------------------------------------------
!--------------------------
!--------------------------
if (a >= 0.5d0) go to 10
dgamln = dgmln1(a) - log(a)
return
10 if (a > 2.5d0) go to 20
x = a - 1.d0
if (a < 1.d0) x = (a - 0.5d0) - 0.5d0
dgamln = dgmln1(x)
return
20 if (a >= 10.d0) go to 30
n = a - 1.5d0
x = a
w = 1.d0
do i = 1,n
   x = x - 1.d0
   w = x*w
end do
dgamln = dgmln1(x - 1.d0) + log(w)
return
30 w = dpdel(a)
dgamln = (d + w) + (a - 0.5d0)*(log(a) - 1.d0)
end function dgamln

