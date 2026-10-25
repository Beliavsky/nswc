integer function ipmpar (i)
implicit none
integer, intent(in) :: i
!-----------------------------------------------------------------------
!
!     ipmpar provides the integer machine constants for the computer
!     that is used. It is assumed that the argument i is an integer
!     having one of the values 1-10. ipmpar(i) has the value ...
!
!  Integers.
!
!     Assume integers are represented in the N-digit, base-A form
!
!               sign ( X(N-1)*A**(N-1) + ... + X(1)*A + X(0) )
!
!               WHERE 0 .LE. X(i) .LT. A FOR i=0,...,N-1.
!
!     ipmpar(1) = A, THE BASE.
!
!     ipmpar(2) = N, THE NUMBER OF BASE-A DIGITS.
!
!     ipmpar(3) = A**N - 1, THE LARGEST MAGNITUDE.
!
!  Floating-point numbers.
!
!     It is assumed that the single and double precision floating
!     point arithmetics have the same base, say B, and that the
!     nonzero numbers are represented in the form
!
!               sign (B**E) * (X(1)/B + ... + X(M)/B**M)
!
!               WHERE X(i) = 0,1,...,B-1 FOR i=1,...,M,
!               X(1) .GE. 1, AND EMIN .LE. E .LE. EMAX.
!
!     ipmpar(4) = B, THE BASE.
!
!  Single-precision
!
!     ipmpar(5) = M, THE NUMBER OF BASE-B DIGITS.
!
!     ipmpar(6) = EMIN, THE SMALLEST EXPONENT E.
!
!     ipmpar(7) = EMAX, THE LARGEST EXPONENT E.
!
!  Double-precision
!
!     ipmpar(8) = M, THE NUMBER OF BASE-B DIGITS.
!
!     ipmpar(9) = EMIN, THE SMALLEST EXPONENT E.
!
!     ipmpar(10) = EMAX, THE LARGEST EXPONENT E.
!
!-----------------------------------------------------------------------
!
!     To define this function for the computer being used, activate
!     the data statments for the computer by removing the C from
!     column 1. (All the other data statements should have C in
!     column 1.)
!
!     If data statements are not given for the computer being used,
!     then the Fortran manual for the computer normally gives the
!     constants ipmpar(1), ipmpar(2), and ipmpar(3) for the integer
!     arithmetic. However, help may be needed to obtain the constants
!     ipmpar(4),...,ipmpar(10) for the single and double precision
!     arithmetics. The subroutines mach and radix are provided for
!     this purpose.
!
!-----------------------------------------------------------------------
!
!     ipmpar IS AN ADAPTATION OF THE FUNCTION I1MACH, WRITTEN BY
!     P.A. FOX, A.D. HALL, AND N.L. SCHRYER (BELL LABORATORIES).
!     ipmpar WAS FORMED BY A.H. MORRIS (NSWC). THE CONSTANTS ARE
!     FROM BELL LABORATORIES, NSWC, AND OTHER SOURCES.
!
!-----------------------------------------------------------------------
integer :: imach(10)
!
!     Machine constants for the Alliant FX/8.
!
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
!
!     Machine constants for the Amdahl machines.
!
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
!
!     Machine constants for the AT&T 3B series, AT&T
!     PC 7300, and AT&T 6300.
!
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
!
!     Machine constants for the Burroughs 1700 system.
!
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
!
!     Machine constants for the Burroughs 5700 system.
!
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
!
!     Machine constants for the Burroughs 6700/7700 systems.
!
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
!
!     Machine constants for the CDC 6000/7000 series
!     computers, and the CDC Cyber 990 and 995 (nos
!     operating system).
!
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
!
!     Machine constants for the CDC Cyber 990 and 995
!     (nos/VE operating system).
!
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
!
!     Machine constants for the Convex computers
!     (native mode).
!
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
!
!     Machine constants for the Convex computers
!     (IEEE mode).
!
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
!
!     Machine constants for the Cray 2, X-MP, and Y-MP
!     (CFT77 compiler using the 64 bit integer arithmetic).
!
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
!
!     Machine constants for the Cray 2, X-MP, and Y-MP
!     (CFT77 compiler using the 46 bit integer arithmetic).
!
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
!
!     Machine constants for the Data General Eclipse S/200.
!
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
!
!     Machine constants for the Harris 220.
!
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
!
!     Machine constants for the Honeywell 600/6000
!     and dps 8/70 series.
!
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
!
!     Machine constants for the HP 9000.
!
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
!
!     Machine constants for the IBM 360/370 series,
!     the IBM 3033, the ICL 2900, the ITEL as/6, the
!     xerox sigma 5/7/9, and the SEL systems 85/86.
!
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
!
!     Machine constants for the IBM PC.
!
data imach( 1) /     2 /
data imach( 2) /    31 /
data imach( 3) / 2147483647 /
data imach( 4) /     2 /
data imach( 5) /    24 /
data imach( 6) /  -125 /
data imach( 7) /   128 /
data imach( 8) /    53 /
data imach( 9) / -1021 /
data imach(10) /  1024 /
!
!     Machine constants for the Macintosh II - Absoft
!     MACFORTRAN II.
!
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
!
!     Machine constants for the PDP-11 Fortran supporting
!     32-bit integer arithmetic.
!
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
!
!     Machine constants for the Sequent Balance 8000.
!
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
!
!     Machine constants for the Silicon Graphics IRIS-4D
!     series (mips R3000 processor).
!
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
!
!     Machine constants for the Sun 3.
!
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
!
!     Machine constants for the Univac 1100 series.
!
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
!
!     Machine constants for the VAX and MicroVAX
!     computers - F and D floating arithmetics.
!
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
!
!     Machine constants for the VAX and MicroVAX
!     computers - F and G floating arithmetics.
!
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
!
ipmpar = imach(i)
return
end function ipmpar

!-----------------------------------------------------------------------
subroutine mach (mo, n, ibeta, imax, idmax, imach, rmach, dmach)
implicit none
integer :: ibeta
integer, intent(in) :: idmax, imax, mo, n
integer :: m, maxexp, minexp, n0
real :: eps, xint, xmax, xmin
!-----------------------------------------------------------------------
real, intent(inout) :: rmach(3)
double precision, intent(inout) :: dmach(3)
integer, intent(inout) :: imach(10)
!-----------------------------------------------------------------------
!
!          Computation of the environmental constants for the
!        single and double precision floating point arithmetics
!
!                           -----------
!
!     It is assumed that the single and double precision floating
!     point arithmetics have the same base, say ibeta, and that
!     the nonzero numbers are represented in the form
!
!        sign (ibeta**K) * (X(1)/ibeta + ... + X(m)/ibeta ** m)
!
!     Where each X(I) is an integer such that
!
!        0 .LE. X(I) .LT. ibeta
!
!     AND  X(1) .GE. 1 . THE EXPONENT K IS AN INTEGER SUCH THAT
!
!        minexp .LE. K .LE. maxexp.
!
!     The values m, minexp, and maxexp are needed for both the
!     single and double precision arithmetics in order to define
!     the function ipmpar. This subroutine attempts to help the
!     user in obtaining this information.
!
!-----------------------------------------------------------------------
!                         Input and output
!-----------------------------------------------------------------------
!
!     Input ...
!
!       mo    - MODE OF OPERATION OF THE ROUTINE.
!
!               mo = 0  OUTPUT UNIT n IS NOT USED. THE SINGLE
!                       and double precision arithmetics are
!                       examined.
!               mo = 1  IT IS ASSUMED THAT UNIT n IS USED.
!                       Mach searches for the maximum exponent
!                       maxexp for the single precision arith-
!                       metic. The double precision arithmetic
!                       is not examined.
!               mo = 2  IT IS ASSUMED THAT UNIT n IS USED.
!                       Mach searches for the maximum exponent
!                       maxexp for the double precision arith-
!                       metic. The single precision arithmetic
!                       is not examined.
!
!       n     - IF n IS POSITIVE THEN n IS THE NUMBER OF AN
!               output unit, where any information written on
!               the unit will be available to the user if mach
!               TERMINATES BECAUSE OF OVERFLOW. IF n .LE. 0
!               then no such output unit is to be used. (If no
!               SUCH OUTPUT UNIT IS USED THEN SET mo = 0.)
!
!       ibeta - the base of the floating point arithmetics. (It
!               is assumed that the single and double precision
!               arithmetics have the same base.) If this value
!               is not known then
!
!                           call radix (ibeta)
!
!               Will (hopefully) provide the correct value. As
!               far as is known, the subroutine radix operates
!               properly on all computers. Nevertheless, the
!               value obtained for ibeta should be checked.
!
!       imax  - if imax is positive then imax is assumed to be
!               an approximation of the maximum exponent maxexp
!               for the single precision numbers. Otherwise, if
!               imax .LE. 0, THEN THE ROUTINE DEFINES ITS OWN
!               initial approximation for maxexp.
!
!       idmax - if idmax is positive then idmax is assumed to be
!               an approximation of the maximum exponent maxexp
!               for the double precision numbers. Otherwise, if
!               idmax .LE. 0, THEN THE ROUTINE DEFINES ITS OWN
!               initial approximation for maxexp.
!
!
!     OUTPUT (WHEN mo = 0) ...
!
!       imach - integer array of dimension 10 appearing in the
!               definition of the function ipmpar.
!               ipmpar(i) = imach(i)  i = 4,...,10
!
!       rmach - real array of dimension 3 giving the following
!               constants for the single precision arithmetic.
!               rmach(1) = B**(1-m), THE MACHINE PRECISION
!               rmach(2) = THE SMALLEST POSITIVE NUMBER
!               rmach(3) = THE LARGEST POSITIVE NUMBER
!
!       dmach - double precision array of dimension 3 giving the
!               following constants for the double precision
!               arithmetic.
!               dmach(1) = B**(1-m), THE MACHINE PRECISION
!               dmach(2) = THE SMALLEST POSITIVE NUMBER
!               dmach(3) = THE LARGEST POSITIVE NUMBER
!
!-----------------------------------------------------------------------
!                              Usage
!-----------------------------------------------------------------------
!
!     The following procedure is recommended for obtaining the
!     data needed for defining ipmpar.
!
!
!     Step (1). In this step we search for the maximum exponent
!     maxexp for the single precision arithmetic. The double
!     precision arithmetic is not considered. It is assumed that
!     an output unit n is being used. Given n and ibeta. Set
!     imax = 0 AND COMPUTE ...
!
!        call mach (1, n, ibeta, imax, idmax, imach, rmach, dmach)
!
!     When this code is run, information is given on unit n for
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
!
!
!     Step (2). In this step we search for the maximum exponent
!     maxexp for the double precision arithmetic. The single
!     precision arithmetic is not considered. It is assumed that
!     an output unit n is being used. Given n and ibeta. Set
!     idmax = 0 AND COMPUTE ...
!
!        call mach (2, n, ibeta, imax, idmax, imach, rmach, dmach)
!
!     The procedure used in this step for finding the maximum
!     exponent or obtaining a suitable approximation for the
!     maximum exponent is the same as in step (1), the only
!     difference being that now one works with idmax instead
!     of imax. When the maximum exponent is found or a suitable
!     approximation is obtained, then reset idmax to the maximum
!     exponent (or the approximation) and go to step (3).
!
!
!     Step (3). Given the values obtained for ibeta, imax, and
!     idmax. Then compute ...
!
!        call mach (0, 0, ibeta, imax, idmax, imach, rmach, dmach)
!
!     When this code terminates, all the data needed for defining
!     ipmpar(4),...,ipmpar(10) is given in the array imach. The
!     data given in the arrays rmach and dmach are provided so that
!     the user can check the information in imach.
!
!             rmach(1)  depends on imach(4) and imach(5)
!             rmach(2)  depends on imach(4) and imach(6)
!             rmach(3)  depends on imach(4) and imach(7)
!             dmach(1)  depends on imach(4) and imach(8)
!             dmach(2)  depends on imach(4) and imach(9)
!             dmach(3)  depends on imach(4) and imach(10)
!
!     The values in rmach and dmach should be checked to see if
!     they make sense. (For example, rmach(2) and dmach(2) should
!     never be 0.)
!
!-----------------------------------------------------------------------
!                       General information
!-----------------------------------------------------------------------
!
!     The values in imach(6) and imach(9) are the minimum exponents
!     for the numbers in the single and double precision arithmetics
!     which have full accuracy. On some computers, accuracy is lost
!     in the storage of some small numbers. This occurs in the double
!     precision arithmetics of the CDC 6000-7000 series computes. On
!     THESE MACHINES, THE DOUBLE PRECISION NUMBERS LESS THAT 2**(-927)
!     normally have only single precision accuracy. Consequently,
!     imach(9) will have the computed value -926 instead of -974
!     (which one would normally expect). In this case, -926 is the
!     value that is considered to be correct.
!
!     This package of subroutines includes mach, radix, mach1, store2,
!     mach2, dstor2. The package is experimental. It is provided as
!     an aid in defining the function ipmpar. The subroutines in the
!     package are not used by any of the functions or subroutines in
!     the NSWC library.
!
!     The purpose of the subroutines store2 and dstor2 is to force
!     data to be stored in memory. These routines are needed when
!     data are stored in oversized registers.
!
!     THE ALGORITHM FOR THE SUBROUTINE radix WAS DEVELOPED BY M.A.
!     MALCOLM (STANFORD UNIVERSITY). SEE REFERENCES (1) AND (2).
!
!-----------------
!
!     WRITTEN BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN VIRGINIA
!
!-----------------
!
!     Revised ... march 1992
!
!-----------------
!
!     REFERENCES ...
!
!     (1) Malcolm, M.A., Algorithms to reveal properties of floating
!         point arithmetic, comm. ACM (15), 1972, PP. 949-951.
!
!     (2) Gentlemen, W.M. And Marovich, S.B., More on algorithms that
!         reveal properties of floating point arithmetic units,
!         comm. ACM (17), 1974, PP. 276-277.
!
!     (3) CODY, W.J. AND WAITE, W., SOFTWARE MANUAL FOR THE ELEMENTARY
!         FUNCTIONS, PRENTICE-HALL, 1980, PP. 258-264.
!
!     (4) CODY, W.J., ALGORITHM 665. MACHAR, A SUBROUTINE TO DYNAMICALLY
!         DETERMINE MACHINE PARAMETERS, ACM TRANS. MATH SOFTWARE (14),
!         1988, PP. 303-311.
!
!-----------------------------------------------------------------------
double precision :: deps, dint, dmin, dmax
!-----------------
imach(1) = 0
imach(2) = 0
imach(3) = 0
!
n0 = n
if (mo .le. 0) n0 = 0
if (mo .ge. 2) go to 10
!-----------------------------------------------------------------------
!     Obtain the single precision information
!-----------------------------------------------------------------------
maxexp = imax
call mach1 (n0, ibeta, m, minexp, maxexp, eps, xint, xmin, xmax)
if (mo .eq. 1) stop
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
call mach2 (n0, ibeta, m, minexp, maxexp, deps, dint, dmin, dmax)
if (mo .ge. 2) stop
dmach(1) = deps
dmach(2) = dmin
dmach(3) = dmax
imach(8) = m
imach(9) = minexp
imach(10)= maxexp
return
end subroutine mach

subroutine radix (ibeta)
implicit none
integer :: ibeta
real :: a, b, one, y
real :: d1, d2
!-----------------------------------------------------------------------
!     SET  ibeta = THE RADIX OF THE FLOATING POINT ARITHMETIC
!-----------------------------------------------------------------------
common /spdata/ d1, d2
!
one  = float(1)
!
a = one
10 a = a + a
call store2 (a + one, a)
y = d1 - d2
if (y .eq. one) go to 10
!
b = one
20 b = b + b
call store2 (a + b, a)
if (d1 .eq.d2) go to 20
!
ibeta = int(d1 - d2)
return
end subroutine radix

subroutine mach1 (n, ibeta, m, minexp, maxexp, eps, xint, &
&xmin, xmax)
implicit none
integer :: ibeta, m, maxexp, minexp, n
integer :: j, k, km, l
real :: eps, xint, xmin, xmax
!-----------------------------------------------------------------------
!
!                 Computation of the environmental constants
!             for the single precision floating point arithmetic
!
!                            -----------
!
!     Input ...
!
!       n       - IF n IS POSITIVE THEN n IS THE NUMBER OF AN
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
!
!       ibeta   - THE BASE OF THE FLOATING POINT ARITHMETIC.
!
!       maxexp  - if maxexp is positive then maxexp is assumed to
!                 be an approximation of the maximum (base ibeta)
!                 exponent for the floating point numbers. Other-
!                 WISE, IF maxexp .LE. 0, THEN AN APPROXIMATION
!                 for the maximum exponent is obtained.
!
!     Output ...
!
!       m       - THE NUMBER OF BASE ibeta DIGITS IN THE FLOATING
!                 point representation.
!
!       minexp  - the largest in magnitude negative integer such
!                 THAT FLOAT(ibeta)**(minexp - 1) IS A POSITIVE
!                 number.
!
!       maxexp  - IF maxexp IS POSITIVE ON INPUT AND n .LE. 0
!                 then maxexp is not modified.
!
!                 IF maxexp .LE. 0 ON INPUT AND n .LE. 0 THEN
!                 ON OUTPUT maxexp = AN APPROXIMATION OF THE
!                 maximum (base ibeta) exponent for the floating
!                 point numbers.
!
!                 If n is positive then the routine searches for
!                 the exact maximum exponent for the floating
!                 point numbers. If maxexp is positive on input
!                 then the search begins with maxexp. If
!                 maxexp .LE. 0 ON INPUT THEN THE ROUTINE BEGINS
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
!                 INTEGER, SET n = 0, AND RERUN THE ROUTINE.
!
!       eps     - THE RELATIVE PRECISION OF THE FLOATING ARITHMETIC.
!                 eps = float(ibeta)**(1 - m)
!
!       xint    - THE LARGEST POSITIVE INTEGER THAT CAN
!                 be exactly represented as a floating
!                 POINT NUMBER. xint = b**m - 1  WHERE
!                 b = float(ibeta).
!
!       xmin    - THE SMALLEST NONZERO POWER OF THE BASE.
!                 xmin = float(ibeta)**(minexp - 1)
!
!       xmax    - THE LARGEST FOATING POINT NUMBER THAT CAN
!                 be obtained having the exponent maxexp.
!                 xmax = (1 - b**(-m)) * b**maxexp  WHERE
!                 b = FLOAT(ibeta). IF maxexp IS THE MAXIMUM
!                 exponent for the floating point numbers
!                 then xmax is the largest floating point
!                 number that exists. The value obtained
!                 for xmax may be affected slightly by
!                 roundoff error.
!
!-----------------------------------------------------------------------
real :: b, b2, binv, bm1, d1, d2, one, p, q, t, x, z, zero
!----------------
common /spdata/ d1, d2
!
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
   call store2 (t + one, t)
   x = d1*binv - z
   if (x .eq. binv) go to 10
!
xint = (z - one)*b + bm1
xmax = xint/t
if (xmax .lt. one) go to 20
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
!
!     minexp must be found. This loop obtains the largest
!     k = 2**I SUCH THAT b**(-k) DOES NOT UNDERFLOW.
!
k = 1
z = binv
30 x = z
   z = (x*x)*one
   call store2 (z*xint, z*t)
   if (d1 .eq.d2) go to 40
   if (z + z .eq. zero .or. abs(z) .ge. x) go to 40
   call store2 (z, p*z)
   if (t*d2 .eq. t*z) go to 40
   k = k + k
   go to 30
!
40 km = k + k
j = 0
!
!     Loop to determine minexp and xmin.
!
50 xmin = x
   x = (x*binv)*one
   call store2 (x*xint, x*t)
   if (d1 .eq.d2) go to 90
   if (x + x .eq. zero .or. abs(x) .ge. xmin) go to 90
   call store2 (x, p*x)
   if (t*d2 .eq. t*x) go to 80
   k = k + 1
   go to 50
!
!     If there is loss of accuracy not due to underflow
!     THEN SET j = NUMBER OF DIGITS POSSIBLY LOST DUE TO
!     this loss of accuracy.
!
80 call store2 (x, q*x)
if (t*d2 .ne. t*x) go to 90
81 z = x
   j = j + 1
   x = (x*binv)*one
   call store2 (x*xint, x*t)
   if (d1 .eq.d2) go to 90
   if (x + x .ne. zero .and. abs(x) .lt. z) go to 81
!
90 minexp = 1 - k
!-----------------------------------------------------------------------
!     Define an initial approximation for maxexp and xmax
!     WHEN maxexp .LE. 0 ON INPUT
!-----------------------------------------------------------------------
if (maxexp .gt. 0) go to 101
if (ibeta .eq. 2 .or. ibeta .eq. 8 .or. &
&ibeta .eq. 16) go to 100
!
   maxexp = k - 3
   if (n .gt. 0) write (n,200) maxexp
   t = one/(b2*b2*xmin)
   xmax = (xmax*t)*b
   go to 110
!
100 k = k + j
if (k + k .gt. km + 2) km = km + km
maxexp = km - k - 3
101 if (n .gt. 0) write (n,200) maxexp
t = b**(maxexp - 2)
xmax = ((xmax*t)*b)*b
!-----------------------------------------------------------------------
!     Check the approximation for maxexp
!-----------------------------------------------------------------------
110 call store2 (t, t*p)
if (d1 .eq.d2) go to 150
if (n .le. 0) return
!-----------------------------------------------------------------------
!     Loop to find the exact largest value for maxexp
!-----------------------------------------------------------------------
write (n,210) maxexp
do l = 1,500
   t = t*b
   xmax = xmax*b
   maxexp = maxexp + 1
   call store2 (t, t*p)
   if (d1 .eq.d2) go to 150
   write (n,220) maxexp
end do
write (n,240)
stop
!-----------------------------------------------------------------------
!     Reporting overflow on unit n
!-----------------------------------------------------------------------
150 if (n .gt. 0) write (n,230)
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

subroutine store2 (a, b)
implicit none
real :: a, b
real :: d1, d2
!-----------------------------------------------------------------------
!     Storage of single precision information into memory
!-----------------------------------------------------------------------
common /spdata/ d1, d2
d1 = a
d2 = b
return
end subroutine store2

subroutine mach2 (n, ibeta, m, minexp, maxexp, eps, xint, &
&xmin, xmax)
implicit none
integer :: ibeta, m, maxexp, minexp, n
integer :: j, k, km, l
double precision :: eps, xint, xmin, xmax
!-----------------------------------------------------------------------
!
!                 Computation of the environmental constants
!             for the double precision floating point arithmetic
!
!                            -----------
!
!     Input ...
!
!       n       - IF n IS POSITIVE THEN n IS THE NUMBER OF AN
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
!
!       ibeta   - THE BASE OF THE FLOATING POINT ARITHMETIC.
!
!       maxexp  - if maxexp is positive then maxexp is assumed to
!                 be an approximation of the maximum (base ibeta)
!                 exponent for the floating point numbers. Other-
!                 WISE, IF maxexp .LE. 0, THEN AN APPROXIMATION
!                 for the maximum exponent is obtained.
!
!     Output ...
!
!       m       - THE NUMBER OF BASE ibeta DIGITS IN THE FLOATING
!                 point representation.
!
!       minexp  - LET b = dble(FLOAT(ibeta)). THEN minexp IS THE
!                 largest in magnitude negative integer such that
!                 b**(minexp - 1) IS A POSITIVE NUMBER.
!
!       maxexp  - IF maxexp IS POSITIVE ON INPUT AND n .LE. 0
!                 then maxexp is not modified.
!
!                 IF maxexp .LE. 0 ON INPUT AND n .LE. 0 THEN
!                 ON OUTPUT maxexp = AN APPROXIMATION OF THE
!                 maximum (base ibeta) exponent for the floating
!                 point numbers.
!
!                 If n is positive then the routine searches for
!                 the exact maximum exponent for the floating
!                 point numbers. If maxexp is positive on input
!                 then the search begins with maxexp. If
!                 maxexp .LE. 0 ON INPUT THEN THE ROUTINE BEGINS
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
!                 INTEGER, SET n = 0, AND RERUN THE ROUTINE.
!
!       eps     - THE RELATIVE PRECISION OF THE FLOATING ARITHMETIC.
!                 eps = b**(1 - m) WHERE b = dble(FLOAT(ibeta)).
!
!       xint    - THE LARGEST POSITIVE INTEGER THAT CAN
!                 be exactly represented as a floating
!                 POINT NUMBER. xint = b**m - 1  WHERE
!                 b = dble(float(ibeta)).
!
!       xmin    - THE SMALLEST NONZERO POWER OF THE BASE.
!                 xmin = b**(minexp-1) WHERE b=dble(FLOAT(ibeta)).
!
!       xmax    - THE LARGEST FOATING POINT NUMBER THAT CAN
!                 be obtained having the exponent maxexp.
!                 xmax = (1 - b**(-m)) * b**maxexp  WHERE
!                 b = dble(FLOAT(ibeta)). IF maxexp IS THE
!                 maximum exponent for the floating point
!                 numbers then xmax is the largest floating
!                 point number that exists. The value
!                 obtained for xmax may be affected slightly
!                 by roundoff error.
!
!-----------------------------------------------------------------------
double precision :: b, b2, binv, bm1, d1, d2, one, p, q, t, x, z, &
&zero
!----------------
common /dpdata/ d1, d2
!
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
   call dstor2 (t + one, t)
   x = d1*binv - z
   if (x .eq. binv) go to 10
!
xint = (z - one)*b + bm1
xmax = xint/t
if (xmax .lt. one) go to 20
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
!
!     minexp must be found. This loop obtains the largest
!     k = 2**I SUCH THAT b**(-k) DOES NOT UNDERFLOW.
!
k = 1
z = binv
30 x = z
   z = (x*x)*one
   call dstor2 (z*xint, z*t)
   if (d1 .eq.d2) go to 40
   if (z + z .eq. zero .or. dabs(z) .ge. x) go to 40
   call dstor2 (z, p*z)
   if (t*d2 .eq. t*z) go to 40
   k = k + k
   go to 30
!
40 km = k + k
j = 0
!
!     Loop to determine minexp and xmin
!
50 xmin = x
   x = (x*binv)*one
   call dstor2 (x*xint, x*t)
   if (d1 .eq.d2) go to 90
   if (x + x .eq. zero .or. dabs(x) .ge. xmin) go to 90
   call dstor2 (x, p*x)
   if (t*d2 .eq. t*x) go to 80
   k = k + 1
   go to 50
!
!     If there is loss of accuracy not due to underflow
!     THEN SET j = NUMBER OF DIGITS POSSIBLY LOST DUE TO
!     this loss of accuracy.
!
80 call dstor2 (x, q*x)
if (t*d2 .ne. t*x) go to 90
81 z = x
   j = j + 1
   x = (x*binv)*one
   call dstor2 (x*xint, x*t)
   if (d1 .eq.d2) go to 90
   if (x + x .ne. zero .and. dabs(x) .lt. z) go to 81
!
90 minexp = 1 - k
!-----------------------------------------------------------------------
!     Define an initial approximation for maxexp and xmin
!     WHEN maxexp .LE. 0 ON INPUT
!-----------------------------------------------------------------------
if (maxexp .gt. 0) go to 101
if (ibeta .eq. 2 .or. ibeta .eq. 8 .or. &
&ibeta .eq. 16) go to 100
!
   maxexp = k - 3
   if (n .gt. 0) write (n,200) maxexp
   t = one/(b2*b2*xmin)
   xmax = (xmax*t)*b
   go to 110
!
100 k = k + j
if (k + k .gt. km + 2) km = km + km
maxexp = km - k - 3
101 if (n .gt. 0) write (n,200) maxexp
t = b**(maxexp - 2)
xmax = ((xmax*t)*b)*b
!-----------------------------------------------------------------------
!     Check the approximation for maxexp
!-----------------------------------------------------------------------
110 call dstor2 (t, t*p)
if (d1 .eq.d2) go to 150
if (n .le. 0) return
!-----------------------------------------------------------------------
!     Loop to find the exact largest value for maxexp
!-----------------------------------------------------------------------
write (n,210) maxexp
do l = 1,500
   t = t*b
   xmax = xmax*b
   maxexp = maxexp + 1
   call dstor2 (t, t*p)
   if (d1 .eq.d2) go to 150
   write (n,220) maxexp
end do
write (n,240)
stop
!-----------------------------------------------------------------------
!     Reporting overflow on unit n
!-----------------------------------------------------------------------
150 if (n .gt. 0) write (n,230)
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

subroutine dstor2 (a, b)
implicit none
!-----------------------------------------------------------------------
!     Storage of double precision information into memory
!-----------------------------------------------------------------------
double precision :: a, b, d1, d2
common /dpdata/ d1, d2
d1 = a
d2 = b
return
end subroutine dstor2

real function spmpar (i)
implicit none
integer, intent(in) :: i
integer :: ibeta, m
real :: b, binv, bm1, one, w, z
integer :: ipmpar
!-----------------------------------------------------------------------
!
!     spmpar provides the single precision machine constants for
!     the computer being used. It is assumed that the argument
!     i is an integer having one of the values 1, 2, or 3. If the
!     single precision arithmetic being used has m base b digits and
!     its smallest and largest exponents are emin and emax, then
!
!        spmpar(1) = b**(1 - m), THE MACHINE PRECISION,
!
!        spmpar(2) = b**(emin - 1), THE SMALLEST MAGNITUDE,
!
!        spmpar(3) = b**emax*(1 - b**(-m)), THE LARGEST MAGNITUDE.
!
!-----------------------------------------------------------------------
!     WRITTEN BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN VIRGINIA
!-----------------------------------------------------------------------
integer :: emin, emax
!
if (i .gt. 1) go to 10
   b = ipmpar(4)
   m = ipmpar(5)
   spmpar = b**(1 - m)
   return
!
10 if (i .gt. 2) go to 20
   b = ipmpar(4)
   emin = ipmpar(6)
   one = float(1)
   binv = one/b
   w = b**(emin + 2)
   spmpar = ((w * binv) * binv) * binv
   return
!
20 ibeta = ipmpar(4)
m = ipmpar(5)
emax = ipmpar(7)
!
b = ibeta
bm1 = ibeta - 1
one = float(1)
z = b**(m - 1)
w = ((z - one)*b + bm1)/(b*z)
!
z = b**(emax - 2)
spmpar = ((w * z) * b) * b
return
end function spmpar

double precision function dpmpar (i)
implicit none
integer, intent(in) :: i
integer :: ibeta, m
integer :: ipmpar
!-----------------------------------------------------------------------
!
!     dpmpar provides the double precision machine constants for
!     the computer being used. It is assumed that the argument
!     i is an integer having one of the values 1, 2, or 3. If the
!     double precision arithmetic being used has m base b digits and
!     its smallest and largest exponents are emin and emax, then
!
!        dpmpar(1) = b**(1 - m), THE MACHINE PRECISION,
!
!        dpmpar(2) = b**(emin - 1), THE SMALLEST MAGNITUDE,
!
!        dpmpar(3) = b**emax*(1 - b**(-m)), THE LARGEST MAGNITUDE.
!
!-----------------------------------------------------------------------
!     WRITTEN BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN VIRGINIA
!-----------------------------------------------------------------------
integer :: emin, emax
double precision :: b, binv, bm1, one, w, z
!
if (i .gt. 1) go to 10
   b = ipmpar(4)
   m = ipmpar(8)
   dpmpar = b**(1 - m)
   return
!
10 if (i .gt. 2) go to 20
   b = ipmpar(4)
   emin = ipmpar(9)
   one = float(1)
   binv = one/b
   w = b**(emin + 2)
   dpmpar = ((w * binv) * binv) * binv
   return
!
20 ibeta = ipmpar(4)
m = ipmpar(8)
emax = ipmpar(10)
!
b = ibeta
bm1 = ibeta - 1
one = float(1)
z = b**(m - 1)
w = ((z - one)*b + bm1)/(b*z)
!
z = b**(emax - 2)
dpmpar = ((w * z) * b) * b
return
end function dpmpar

real function epsln (l)
implicit none
integer, intent(in) :: l
integer :: m
integer :: ipmpar
!--------------------------------------------------------------------
!     The evaluation of LN(EPS) where eps is the smallest number
!     SUCH THAT 1.0 + EPS .GT. 1.0 .  l IS A DUMMY ARGUMENT.
!--------------------------------------------------------------------
integer :: b
real :: lnb
!
b = ipmpar(4)
if (b .ne. 2) go to 10
   lnb = .69314718055995
   go to 50
10 if (b .ne. 8) go to 20
   lnb = 2.0794415416798
   go to 50
20 if (b .ne. 16) go to 30
   lnb = 2.7725887222398
   go to 50
30 lnb = alog(float(b))
!
50 m = 1 - ipmpar(5)
epsln = m * lnb
return
end function epsln

double precision function depsln (l)
implicit none
integer, intent(in) :: l
integer :: ipmpar
!--------------------------------------------------------------------
!     The evaluation of LN(EPS) where eps is the smallest number
!     SUCH THAT 1.D0 + EPS .GT. 1.D0 .  l IS A DUMMY ARGUMENT.
!--------------------------------------------------------------------
integer :: b
double precision :: db, lnb, m
!
b = ipmpar(4)
if (b .ne. 2) go to 10
   lnb = .693147180559945309417232121458d+00
   go to 50
10 if (b .ne. 8) go to 20
   lnb = 2.07944154167983592825169636437d+00
   go to 50
20 if (b .ne. 16) go to 30
   lnb = 2.77258872223978123766892848583d+00
   go to 50
30 db = b
lnb = dlog(db)
!
50 m = 1 - ipmpar(8)
depsln = m * lnb
return
end function depsln

real function exparg (l)
implicit none
integer, intent(in) :: l
integer :: m
integer :: ipmpar
!--------------------------------------------------------------------
!     IF l = 0 THEN  exparg(l) = THE LARGEST POSITIVE W FOR WHICH
!     exp(W) can be computed.
!
!     IF l IS NONZERO THEN  exparg(l) = THE LARGEST NEGATIVE W FOR
!     which the computed value of exp(W) is nonzero.
!
!     Note... only an approximate value for exparg(l) is needed.
!--------------------------------------------------------------------
integer :: b
real :: lnb
!
b = ipmpar(4)
if (b .ne. 2) go to 10
   lnb = .69314718055995
   go to 50
10 if (b .ne. 8) go to 20
   lnb = 2.0794415416798
   go to 50
20 if (b .ne. 16) go to 30
   lnb = 2.7725887222398
   go to 50
30 lnb = alog(float(b))
!
50 if (l .eq. 0) go to 60
   m = ipmpar(6) - 1
   exparg = 0.99999 * (m * lnb)
   return
60 m = ipmpar(7)
exparg = 0.99999 * (m * lnb)
return
end function exparg

double precision function dxparg (l)
implicit none
integer, intent(in) :: l
integer :: m
integer :: ipmpar
!--------------------------------------------------------------------
!     IF l = 0 THEN  dxparg(l) = THE LARGEST POSITIVE W FOR WHICH
!     dexp(W) can be computed.
!
!     IF l IS NONZERO THEN  dxparg(l) = THE LARGEST NEGATIVE W FOR
!     which the computed value of dexp(W) is nonzero.
!
!     Note... only an approximate value for dxparg(l) is needed.
!--------------------------------------------------------------------
integer :: b
double precision :: db, lnb
!
b = ipmpar(4)
if (b .ne. 2) go to 10
   lnb = .693147180559945309417232121458d+00
   go to 50
10 if (b .ne. 8) go to 20
   lnb = 2.07944154167983592825169636437d+00
   go to 50
20 if (b .ne. 16) go to 30
   lnb = 2.77258872223978123766892848583d+00
   go to 50
30 db = b
lnb = dlog(db)
!
50 if (l .eq. 0) go to 60
   m = ipmpar(9) - 1
   dxparg = 0.999999999999d+00 * (m * lnb)
   return
60 m = ipmpar(10)
dxparg = 0.999999999999d+00 * (m * lnb)
return
end function dxparg

subroutine ishell (a, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
integer, intent(inout) :: a(n)
integer :: k(10), s
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do 31 j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
!
40 i = i - 1
return
end subroutine ishell

subroutine shell (a, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
real, intent(inout) :: a(n)
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do 31 j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
!
40 i = i - 1
return
end subroutine shell

subroutine shell2 (a, b, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s, t
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. THE SAME PERMUTATIONS ARE
!     PERFORMED ON b THAT ARE PERFORMED ON A. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
real, intent(inout) :: a(n), b(n)
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = b(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         b(ll) = b(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
      b(ll) = t
   end do
!
40 i = i - 1
return
end subroutine shell2

subroutine rsort (a, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
real, intent(inout) :: a(n)
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do 31 j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
!
40 i = i - 1
return
end subroutine rsort

subroutine risort (a, m, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. THE SAME PERMUTATIONS ARE
!     PERFORMED ON m THAT ARE PERFORMED ON A. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
real, intent(inout) :: a(n)
integer, intent(inout) :: m(n)
integer :: t
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = m(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         m(ll) = m(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
      m(ll) = t
   end do
!
40 i = i - 1
return
end subroutine risort

subroutine rrsort (a, b, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s, t
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. THE SAME PERMUTATIONS ARE
!     PERFORMED ON b THAT ARE PERFORMED ON A. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
real, intent(inout) :: a(n), b(n)
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = b(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         b(ll) = b(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
      b(ll) = t
   end do
!
40 i = i - 1
return
end subroutine rrsort

subroutine dsort (a, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(n)
double precision :: s
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do 31 j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
!
40 i = i - 1
return
end subroutine dsort

subroutine disort (a, m, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. THE SAME PERMUTATIONS ARE
!     PERFORMED ON m THAT ARE PERFORMED ON A. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(n)
double precision :: s
integer, intent(inout) :: m(n)
integer :: t
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = m(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         m(ll) = m(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
      m(ll) = t
   end do
!
40 i = i - 1
return
end subroutine disort

subroutine ddsort (a, b, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
!-----------------------------------------------------------------------
!     The shell sorting procedure is used to reorder the elements of A
!     SO THAT a(i).LE.a(i+1) FOR i=1,...,n-1. THE SAME PERMUTATIONS ARE
!     PERFORMED ON b THAT ARE PERFORMED ON A. IT IS ASSUMED THAT n.GE.1.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(n), b(n)
double precision :: s, t
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT a(j).LE.a(j+ki) FOR j=1,...,n-ki
!
   jmax = n - ki
   do j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
      t = b(ll)
30 if (s .ge. a(l)) go to 31
         a(ll) = a(l)
         b(ll) = b(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
      b(ll) = t
   end do
!
40 i = i - 1
return
end subroutine ddsort

subroutine aord (a, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
real :: s
!-----------------------------------------------------------------------
!     The aord sorting procedure is used to reorder the elements of
!     A SO THAT abs(a(i)) .LE. abs(a(i+1)) FOR i = 1,...,n-1. IT IS
!     ASSUMED THAT n .GE. 1.
!-----------------------------------------------------------------------
real, intent(inout) :: a(n)
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!                 SO THAT abs(a(j)) .LE. abs(a(j+ki))
!
   jmax = n - ki
   do 31 j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30 if (abs(s) .ge. abs(a(l))) go to 31
         a(ll) = a(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
!
40 i = i - 1
return
end subroutine aord

subroutine daord (a, n)
implicit none
integer, intent(in) :: n
integer :: i, ii, imax, j, jmax, ki, l, ll
!-----------------------------------------------------------------------
!     daord is used to reorder the elements of the double precision
!     ARRAY a SO THAT dabs(a(i)) .LE. dabs(a(i+1)) FOR i = 1,...,n-1.
!     IT IS ASSUMED THAT n .GE. 1.
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(n)
double precision :: s
integer :: k(10)
!------------------------
data k(1)/1/, k(2)/4/, k(3)/13/, k(4)/40/, k(5)/121/, k(6)/364/, &
&k(7)/1093/, k(8)/3280/, k(9)/9841/, k(10)/29524/
!------------------------
!
!             SELECTION OF THE INCREMENTS k(i) = (3**i-1)/2
!
if (n .lt. 2) return
imax = 1
do 10 i = 3,10
   if (n .le. k(i)) go to 20
   imax = imax + 1
10 continue
!
!            Stepping through the increments k(imax),...,k(1)
!
20 i = imax
do 40 ii = 1,imax
   ki = k(i)
!
!             Sorting elements that are ki positions apart
!               SO THAT dabs(a(j)) .LE. dabs(a(j+ki))
!
   jmax = n - ki
   do 31 j = 1,jmax
      l = j
      ll = j + ki
      s = a(ll)
30 if (dabs(s) .ge. dabs(a(l))) go to 31
         a(ll) = a(l)
         ll = l
         l = l - ki
         if (l .gt. 0) go to 30
31 a(ll) = s
!
40 i = i - 1
return
end subroutine daord

subroutine qsorti (x, ind, n)
implicit none
integer, intent(in) :: n, x(n)
integer, intent(inout) :: ind(n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!
!   This subroutine uses an order n*log(n) quick sort to
! sort an integer array x into increasing order.  The algor-
! ithm is as follows.  Ind is initialized to the ordered
! sequence of indices 1,...,n, and all interchanges are
! applied to ind.  x is divided into two portions by picking
! a central element t.  The first and last elements are com-
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
!
! INPUT PARAMETERS -   n - LENGTH OF THE ARRAY x.
!
!                      x - vector of length n to be sorted.
!
!                    ind - VECTOR OF LENGTH .GE. n.
!
! n and x are not altered by this routine.
!
! Output parameter - ind - sequence of indices 1,...,n
!                          permuted in the same fashion as x
!                          would be.  Thus, the ordering on
!                          x IS DEFINED BY Y(i) = x(ind(i)).
!
! Intrinsic functions called by qsorti - ifix, float
!
!***********************************************************
!
! NOTE -- iu AND il MUST BE DIMENSIONED .GE. log(n) WHERE
!         log has base 2.
!
!***********************************************************
!
integer :: iu(21), il(21)
integer :: m, i, j, k, l, ij, it, itt, indx, t
real :: r
!
! Local parameters -
!
! iu,il =  TEMPORARY STORAGE FOR THE UPPER AND LOWER
!            indices of portions of the array x
! m =      INDEX FOR iu AND il
! i,j =    LOWER AND UPPER INDICES OF A PORTION OF x
! k,l =    INDICES IN THE RANGE i,...,j
! ij =     RANDOMLY CHOSEN INDEX BETWEEN i AND j
! IT,itt = TEMPORARY STORAGE FOR INTERCHANGES IN IND
! indx =   TEMPORARY INDEX FOR x
! r =      PSEUDO RANDOM NUMBER FOR GENERATING ij
! t =      CENTRAL ELEMENT OF x
!
if (n .le. 0) return
!
! Initialize ind, m, i, j, and r
!
do 1 i = 1,n
1 ind(i) = i
m = 1
i = 1
j = n
r = .375
!
! Top of loop
!
2 if (i .ge. j) go to 10
if (r .gt. .5898437) go to 3
r = r + .0390625
go to 4
3 r = r - .21875
!
! Initialize k
!
4 k = i
!
! Select a central element of x and save it in t
!
ij = i + ifix(r*float(j-i))
it = ind(ij)
t = x(it)
!
! If the first element of the array is greater than t,
!   interchange it with t
!
indx = ind(i)
if (x(indx) .le. t) go to 5
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
!
! Initialize l
!
5 l = j
!
! If the last element of the array is less than t,
!   interchange it with t
!
indx = ind(j)
if (x(indx) .ge. t) go to 7
ind(ij) = indx
ind(j) = it
it = indx
t = x(it)
!
! If the first element of the array is greater than t,
!   interchange it with t
!
indx = ind(i)
if (x(indx) .le. t) go to 7
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
go to 7
!
! Interchange elements k and l
!
6 itt = ind(l)
ind(l) = ind(k)
ind(k) = itt
!
! Find an element in the upper part of the array which is
!   not larger than t
!
7 l = l - 1
indx = ind(l)
if (x(indx) .gt. t) go to 7
!
! Find an element in the lower part of the array whcih is
!   not smaller than t
!
8 k = k + 1
indx = ind(k)
if (x(indx) .lt. t) go to 8
!
! IF k .LE. l, INTERCHANGE ELEMENTS k AND l
!
if (k .le. l) go to 6
!
! Save the upper and lower subscripts of the portion of the
!   array yet to be sorted
!
if (l-i .le. j-k) go to 9
il(m) = i
iu(m) = l
i = k
m = m + 1
go to 11
!
9 il(m) = k
iu(m) = j
j = l
m = m + 1
go to 11
!
! Begin again on another unsorted portion of the array
!
10 m = m - 1
if (m .eq. 0) return
i = il(m)
j = iu(m)
!
11 if (j-i .ge. 11) go to 4
if (i .eq. 1) go to 2
i = i - 1
!
! SORT ELEMENTS i+1,...,j.  NOTE THAT 1 .LE. i .LT. j AND
!   j-i .LT. 11.
!
12 i = i + 1
if (i .eq. j) go to 10
indx = ind(i+1)
t = x(indx)
it = indx
indx = ind(i)
if (x(indx) .le. t) go to 12
k = i
!
13 ind(k+1) = ind(k)
k = k - 1
indx = ind(k)
if (t .lt. x(indx)) go to 13
ind(k+1) = it
go to 12
end subroutine qsorti

subroutine qsortr (x, ind, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ind(n)
real, intent(in) :: x(n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!
!   This subroutine uses an order n*log(n) quick sort to
! sort the real array x into increasing order.  The algor-
! ithm is as follows.  Ind is initialized to the ordered
! sequence of indices 1,...,n, and all interchanges are
! applied to ind.  x is divided into two portions by picking
! a central element t.  The first and last elements are com-
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
!
! INPUT PARAMETERS -   n - LENGTH OF THE ARRAY x.
!
!                      x - vector of length n to be sorted.
!
!                    ind - VECTOR OF LENGTH .GE. n.
!
! n and x are not altered by this routine.
!
! Output parameter - ind - sequence of indices 1,...,n
!                          permuted in the same fashion as x
!                          would be.  Thus, the ordering on
!                          x IS DEFINED BY Y(i) = x(ind(i)).
!
! Intrinsic functions called by qsortr - ifix, float
!
!***********************************************************
!
! NOTE -- iu AND il MUST BE DIMENSIONED .GE. log(n) WHERE
!         log has base 2.
!
!***********************************************************
!
integer :: iu(21), il(21)
integer :: m, i, j, k, l, ij, it, itt, indx
real :: r, t
!
! Local parameters -
!
! iu,il =  TEMPORARY STORAGE FOR THE UPPER AND LOWER
!            indices of portions of the array x
! m =      INDEX FOR iu AND il
! i,j =    LOWER AND UPPER INDICES OF A PORTION OF x
! k,l =    INDICES IN THE RANGE i,...,j
! ij =     RANDOMLY CHOSEN INDEX BETWEEN i AND j
! IT,itt = TEMPORARY STORAGE FOR INTERCHANGES IN IND
! indx =   TEMPORARY INDEX FOR x
! r =      PSEUDO RANDOM NUMBER FOR GENERATING ij
! t =      CENTRAL ELEMENT OF x
!
if (n .le. 0) return
!
! Initialize ind, m, i, j, and r
!
do 1 i = 1,n
1 ind(i) = i
m = 1
i = 1
j = n
r = .375
!
! Top of loop
!
2 if (i .ge. j) go to 10
if (r .gt. .5898437) go to 3
r = r + .0390625
go to 4
3 r = r - .21875
!
! Initialize k
!
4 k = i
!
! Select a central element of x and save it in t
!
ij = i + ifix(r*float(j-i))
it = ind(ij)
t = x(it)
!
! If the first element of the array is greater than t,
!   interchange it with t
!
indx = ind(i)
if (x(indx) .le. t) go to 5
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
!
! Initialize l
!
5 l = j
!
! If the last element of the array is less than t,
!   interchange it with t
!
indx = ind(j)
if (x(indx) .ge. t) go to 7
ind(ij) = indx
ind(j) = it
it = indx
t = x(it)
!
! If the first element of the array is greater than t,
!   interchange it with t
!
indx = ind(i)
if (x(indx) .le. t) go to 7
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
go to 7
!
! Interchange elements k and l
!
6 itt = ind(l)
ind(l) = ind(k)
ind(k) = itt
!
! Find an element in the upper part of the array which is
!   not larger than t
!
7 l = l - 1
indx = ind(l)
if (x(indx) .gt. t) go to 7
!
! Find an element in the lower part of the array whcih is
!   not smaller than t
!
8 k = k + 1
indx = ind(k)
if (x(indx) .lt. t) go to 8
!
! IF k .LE. l, INTERCHANGE ELEMENTS k AND l
!
if (k .le. l) go to 6
!
! Save the upper and lower subscripts of the portion of the
!   array yet to be sorted
!
if (l-i .le. j-k) go to 9
il(m) = i
iu(m) = l
i = k
m = m + 1
go to 11
!
9 il(m) = k
iu(m) = j
j = l
m = m + 1
go to 11
!
! Begin again on another unsorted portion of the array
!
10 m = m - 1
if (m .eq. 0) return
i = il(m)
j = iu(m)
!
11 if (j-i .ge. 11) go to 4
if (i .eq. 1) go to 2
i = i - 1
!
! SORT ELEMENTS i+1,...,j.  NOTE THAT 1 .LE. i .LT. j AND
!   j-i .LT. 11.
!
12 i = i + 1
if (i .eq. j) go to 10
indx = ind(i+1)
t = x(indx)
it = indx
indx = ind(i)
if (x(indx) .le. t) go to 12
k = i
!
13 ind(k+1) = ind(k)
k = k - 1
indx = ind(k)
if (t .lt. x(indx)) go to 13
ind(k+1) = it
go to 12
end subroutine qsortr

subroutine qsortd (x, ind, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ind(n)
double precision, intent(in) :: x(n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!
!   This subroutine uses an order n*log(n) quick sort to
! sort a double precision array x into increasing order. The
! algorithm is as follows. Ind is initialized to the ordered
! sequence of indices 1,...,n, and all interchanges are
! applied to ind.  x is divided into two portions by picking
! a central element t.  The first and last elements are com-
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
!
! INPUT PARAMETERS -   n - LENGTH OF THE ARRAY x.
!
!                      x - vector of length n to be sorted.
!
!                    ind - VECTOR OF LENGTH .GE. n.
!
! n and x are not altered by this routine.
!
! Output parameter - ind - sequence of indices 1,...,n
!                          permuted in the same fashion as x
!                          would be.  Thus, the ordering on
!                          x IS DEFINED BY Y(i) = x(ind(i)).
!
! Intrinsic functions called by qsortd - ifix, float
!
!***********************************************************
!
! NOTE -- iu AND il MUST BE DIMENSIONED .GE. log(n) WHERE
!         log has base 2.
!
!***********************************************************
!
integer :: iu(21), il(21)
integer :: m, i, j, k, l, ij, it, itt, indx
real :: r
double precision :: t
!
! Local parameters -
!
! iu,il =  TEMPORARY STORAGE FOR THE UPPER AND LOWER
!            indices of portions of the array x
! m =      INDEX FOR iu AND il
! i,j =    LOWER AND UPPER INDICES OF A PORTION OF x
! k,l =    INDICES IN THE RANGE i,...,j
! ij =     RANDOMLY CHOSEN INDEX BETWEEN i AND j
! IT,itt = TEMPORARY STORAGE FOR INTERCHANGES IN IND
! indx =   TEMPORARY INDEX FOR x
! r =      PSEUDO RANDOM NUMBER FOR GENERATING ij
! t =      CENTRAL ELEMENT OF x
!
if (n .le. 0) return
!
! Initialize ind, m, i, j, and r
!
do 1 i = 1,n
1 ind(i) = i
m = 1
i = 1
j = n
r = .375
!
! Top of loop
!
2 if (i .ge. j) go to 10
if (r .gt. .5898437) go to 3
r = r + .0390625
go to 4
3 r = r - .21875
!
! Initialize k
!
4 k = i
!
! Select a central element of x and save it in t
!
ij = i + ifix(r*float(j-i))
it = ind(ij)
t = x(it)
!
! If the first element of the array is greater than t,
!   interchange it with t
!
indx = ind(i)
if (x(indx) .le. t) go to 5
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
!
! Initialize l
!
5 l = j
!
! If the last element of the array is less than t,
!   interchange it with t
!
indx = ind(j)
if (x(indx) .ge. t) go to 7
ind(ij) = indx
ind(j) = it
it = indx
t = x(it)
!
! If the first element of the array is greater than t,
!   interchange it with t
!
indx = ind(i)
if (x(indx) .le. t) go to 7
ind(ij) = indx
ind(i) = it
it = indx
t = x(it)
go to 7
!
! Interchange elements k and l
!
6 itt = ind(l)
ind(l) = ind(k)
ind(k) = itt
!
! Find an element in the upper part of the array which is
!   not larger than t
!
7 l = l - 1
indx = ind(l)
if (x(indx) .gt. t) go to 7
!
! Find an element in the lower part of the array whcih is
!   not smaller than t
!
8 k = k + 1
indx = ind(k)
if (x(indx) .lt. t) go to 8
!
! IF k .LE. l, INTERCHANGE ELEMENTS k AND l
!
if (k .le. l) go to 6
!
! Save the upper and lower subscripts of the portion of the
!   array yet to be sorted
!
if (l-i .le. j-k) go to 9
il(m) = i
iu(m) = l
i = k
m = m + 1
go to 11
!
9 il(m) = k
iu(m) = j
j = l
m = m + 1
go to 11
!
! Begin again on another unsorted portion of the array
!
10 m = m - 1
if (m .eq. 0) return
i = il(m)
j = iu(m)
!
11 if (j-i .ge. 11) go to 4
if (i .eq. 1) go to 2
i = i - 1
!
! SORT ELEMENTS i+1,...,j.  NOTE THAT 1 .LE. i .LT. j AND
!   j-i .LT. 11.
!
12 i = i + 1
if (i .eq. j) go to 10
indx = ind(i+1)
t = x(indx)
it = indx
indx = ind(i)
if (x(indx) .le. t) go to 12
k = i
!
13 ind(k+1) = ind(k)
k = k - 1
indx = ind(k)
if (t .lt. x(indx)) go to 13
ind(k+1) = it
go to 12
end subroutine qsortd

subroutine iorder (a, ip, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: a(n), ip(n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!
!   This routine applies a set of permutations to a vector.
!
! Input parameters -  n - length of A and ip.
!
!                    ip - vector containing the sequence of
!                         integers 1,...,n permuted in the
!                         same fashion that A is to be per-
!                         muted.
!
!                     a - vector to be permuted.
!
! n and ip are not altered by this routine.
!
! Output parameter -  a - reordered vector reflecting the
!                         permutations defined by ip.
!
!***********************************************************
!
integer :: nn, k, j, ipj, temp
!
! Local parameters -
!
! nn =   LOCAL COPY OF n
! k =    INDEX FOR ip AND FOR THE FIRST ELEMENT OF A IN A
!          permutation
! j =    INDEX FOR ip AND A, j .GE. k
! ipj =  ip(j)
! temp = TEMPORARY STORAGE FOR a(k)
!
nn = n
if (nn .lt. 2) return
k = 1
!
! Loop on permutations
!
1 j = k
temp = a(k)
!
! Apply permutation to A.  ip(j) is marked (made negative)
!   as being included in the permutation.
!
2 ipj = ip(j)
ip(j) = -ipj
if (ipj .eq. k) go to 3
a(j) = a(ipj)
j = ipj
go to 2
3 a(j) = temp
!
! Search for an unmarked element of ip
!
4 k = k + 1
if (k .gt. nn) go to 5
if (ip(k) .gt. 0) go to 1
go to 4
!
! All permutations have been applied.  Unmark ip.
!
5 do 6 k = 1,nn
6 ip(k) = -ip(k)
return
end subroutine iorder

subroutine rorder (a, ip, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ip(n)
real, intent(inout) :: a(n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!
!   This routine applies a set of permutations to a vector.
!
! Input parameters -  n - length of A and ip.
!
!                    ip - vector containing the sequence of
!                         integers 1,...,n permuted in the
!                         same fashion that A is to be per-
!                         muted.
!
!                     a - vector to be permuted.
!
! n and ip are not altered by this routine.
!
! Output parameter -  a - reordered vector reflecting the
!                         permutations defined by ip.
!
!***********************************************************
!
integer :: nn, k, j, ipj
real :: temp
!
! Local parameters -
!
! nn =   LOCAL COPY OF n
! k =    INDEX FOR ip AND FOR THE FIRST ELEMENT OF A IN A
!          permutation
! j =    INDEX FOR ip AND A, j .GE. k
! ipj =  ip(j)
! temp = TEMPORARY STORAGE FOR a(k)
!
nn = n
if (nn .lt. 2) return
k = 1
!
! Loop on permutations
!
1 j = k
temp = a(k)
!
! Apply permutation to A.  ip(j) is marked (made negative)
!   as being included in the permutation.
!
2 ipj = ip(j)
ip(j) = -ipj
if (ipj .eq. k) go to 3
a(j) = a(ipj)
j = ipj
go to 2
3 a(j) = temp
!
! Search for an unmarked element of ip
!
4 k = k + 1
if (k .gt. nn) go to 5
if (ip(k) .gt. 0) go to 1
go to 4
!
! All permutations have been applied.  Unmark ip.
!
5 do 6 k = 1,nn
6 ip(k) = -ip(k)
return
end subroutine rorder

subroutine dorder (a, ip, n)
implicit none
integer, intent(in) :: n
integer, intent(inout) :: ip(n)
double precision, intent(inout) :: a(n)
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!
!   This routine applies a set of permutations to a vector.
!
! Input parameters -  n - length of A and ip.
!
!                    ip - vector containing the sequence of
!                         integers 1,...,n permuted in the
!                         same fashion that A is to be per-
!                         muted.
!
!                     a - vector to be permuted.
!
! n and ip are not altered by this routine.
!
! Output parameter -  a - reordered vector reflecting the
!                         permutations defined by ip.
!
!***********************************************************
!
integer :: nn, k, j, ipj
double precision :: temp
!
! Local parameters -
!
! nn =   LOCAL COPY OF n
! k =    INDEX FOR ip AND FOR THE FIRST ELEMENT OF A IN A
!          permutation
! j =    INDEX FOR ip AND A, j .GE. k
! ipj =  ip(j)
! temp = TEMPORARY STORAGE FOR a(k)
!
nn = n
if (nn .lt. 2) return
k = 1
!
! Loop on permutations
!
1 j = k
temp = a(k)
!
! Apply permutation to A.  ip(j) is marked (made negative)
!   as being included in the permutation.
!
2 ipj = ip(j)
ip(j) = -ipj
if (ipj .eq. k) go to 3
a(j) = a(ipj)
j = ipj
go to 2
3 a(j) = temp
!
! Search for an unmarked element of ip
!
4 k = k + 1
if (k .gt. nn) go to 5
if (ip(k) .gt. 0) go to 1
go to 4
!
! All permutations have been applied.  Unmark ip.
!
5 do 6 k = 1,nn
6 ip(k) = -ip(k)
return
end subroutine dorder

real function cbrt (x)
implicit none
real, intent(in) :: x
real :: r
!-----------------------------------------------------------------------
!                   Cube root of a real number
!-----------------------------------------------------------------------
if (x) 30, 10, 20
10 cbrt = 0.0
return
20 r = alog(x)/3.0
cbrt = exp(r)
return
30 r = alog(-x)/3.0
cbrt = -exp(r)
return
end function cbrt

double precision function dcbrt (x)
implicit none
!-----------------------------------------------------------------------
!                   Cube root of a real number
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: r
!
if (x) 30, 10, 20
10 dcbrt = 0.d0
return
20 r = dlog(x)/3.d0
dcbrt = dexp(r)
return
30 r = dlog(-x)/3.d0
dcbrt = -dexp(r)
return
end function dcbrt

function artnq(y,x)
implicit none
real, intent(in) :: x, y
real :: artnq
if (x) 1,2,5
1 artnq=atan(y/x)+3.1415926535898
return
2 if (y) 3,8,4
3 artnq=4.7123889803847
return
4 artnq=1.5707963267949
return
5 if (y) 6,8,7
6 artnq=atan(y/x)+6.2831853071795
return
7 artnq=atan(y/x)
return
8 artnq=0.
return
end function artnq

double precision function dartnq(y,x)
implicit none
double precision, intent(in) :: x, y
if (x) 1,2,5
1 dartnq=datan(y/x)+3.14159265358979323846264338328d0
return
2 if (y) 3,8,4
3 dartnq=4.71238898038468985769396507492d0
return
4 dartnq=1.57079632679489661923132169164d0
return
5 if (y) 6,8,7
6 dartnq=datan(y/x)+6.28318530717958647692528676656d0
return
7 dartnq=datan(y/x)
return
8 dartnq=0.d0
return
end function dartnq

real function cpabs(x, y)
implicit none
real, intent(in) :: x, y
real :: a
!     --------------------------------------
!     Evaluation of sqrt(x*x + y*y)
!     --------------------------------------
if (abs(x) .le. abs(y)) go to 10
   a = y/x
   cpabs = abs(x)*sqrt(1.0 + a*a)
   return
10 if (y .eq. 0.0) go to 20
   a = x/y
   cpabs = abs(y)*sqrt(1.0 + a*a)
   return
20 cpabs = 0.0
return
end function cpabs

double precision function dcpabs(x, y)
implicit none
double precision, intent(in) :: x, y
!     --------------------------------------
!     Evaluation of sqrt(x*x + y*y)
!     --------------------------------------
double precision :: a
!
if (dabs(x) .le. dabs(y)) go to 10
   a = y/x
   dcpabs = dabs(x)*dsqrt(1.d0 + a*a)
   return
10 if (y .eq. 0.d0) go to 20
   a = x/y
   dcpabs = dabs(y)*dsqrt(1.d0 + a*a)
   return
20 dcpabs = 0.d0
return
end function dcpabs

subroutine crec (x, y, u, v)
implicit none
real, intent(inout) :: u, v
real, intent(in) :: x, y
real :: d, t
!-----------------------------------------------------------------------
!             COMPLEX RECIPROCAL u + I*v = 1/(x + I*y)
!-----------------------------------------------------------------------
if (abs(x) .gt. abs(y)) go to 10
   t = x/y
   d = y + t*x
   u = t/d
   v = -1.0/d
   return
10 t = y/x
d = x + t*y
u = 1.0/d
v = -t/d
return
end subroutine crec

subroutine dcrec (x, y, u, v)
implicit none
!-----------------------------------------------------------------------
!             COMPLEX RECIPROCAL u + I*v = 1/(x + I*y)
!-----------------------------------------------------------------------
double precision, intent(in) :: x, y
double precision, intent(inout) :: u, v
double precision :: d, t
!
if (dabs(x) .gt. dabs(y)) go to 10
   t = x/y
   d = y + t*x
   u = t/d
   v = -1.d0/d
   return
10 t = y/x
d = x + t*y
u = 1.d0/d
v = -t/d
return
end subroutine dcrec

complex function cdiv (a, b)
implicit none
real :: ai, ar, bi, br, d, t, u, v
!-----------------------------------------------------------------------
!              COMPLEX DIVISION a/b WHERE b IS NONZERO
!-----------------------------------------------------------------------
complex, intent(in) :: a, b
!
ar = real(a)
ai = aimag(a)
br = real(b)
bi = aimag(b)
!
if (abs(br) .lt. abs(bi)) go to 10
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
return
end function cdiv

subroutine cdivid (ar,ai,br,bi,cr,ci)
implicit none
!-----------------------------------------------------------------------
!     DOUBLE PRECISION COMPLEX DIVISION C = A/B AVOIDING OVERFLOW
!-----------------------------------------------------------------------
double precision, intent(in) :: ar, ai, br, bi
double precision, intent(inout) :: cr, ci
double precision :: d, t, u, v
double precision :: dpmpar
!
if (dabs(br) .le. dabs(bi)) go to 10
t = bi/br
d = br + t*bi
u = (ar + ai*t)/d
v = (ai - ar*t)/d
cr = u
ci = v
return
!
10 if (bi .eq. 0.d0) go to 20
t = br/bi
d = bi + t*br
u = (ar*t + ai)/d
v = (ai*t - ar)/d
cr = u
ci = v
return
!
!     DIVISION BY ZERO. C = INFINITY
!
20 cr = dpmpar(3)
ci = cr
return
end subroutine cdivid

subroutine dcsqrt (z, w)
implicit none
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
! ----------------------------------------------------------------------
!        w = sqrt(z) FOR THE DOUBLE PRECISION COMPLEX NUMBER z
!
!                         -----------
!
!     z and w are interpreted as double precision complex numbers.
!     It is assumed that z(1) and z(2) are the real and imaginary
!     parts of the complex number z, and that w(1) and w(2) are
!     the real and imaginary parts of w.
! ----------------------------------------------------------------------
double precision :: x, y, r
double precision :: dcpabs
!
x = z(1)
y = z(2)
if (x) 30,10,20
!
10 if (y .ne. 0.d0) go to 11
   w(1) = 0.d0
   w(2) = 0.d0
   return
11 w(1) = dsqrt(0.5d0*dabs(y))
w(2) = dsign(w(1),y)
return
!
20 if (y .ne. 0.d0) go to 21
   w(1) = dsqrt(x)
   w(2) = 0.d0
   return
21 r = dcpabs(x,y)
w(1) = dsqrt(0.5d0*(r + x))
w(2) = 0.5d0*y/w(1)
return
!
30 if (y .ne. 0.d0) go to 31
   w(1) = 0.d0
   w(2) = dsqrt(dabs(x))
   return
31 r = dcpabs(x,y)
w(2) = dsqrt(0.5d0*(r - x))
w(2) = dsign(w(2),y)
w(1) = 0.5d0*y/w(2)
return
end subroutine dcsqrt

subroutine poca(r,a,x,y)
implicit none
real, intent(in) :: a, r
real, intent(out) :: x, y
x=r*cos(a)
y=r*sin(a)
return
end subroutine poca

subroutine capo(x,y,r,theta)
implicit none
real, intent(inout) :: r, theta
real, intent(in) :: x, y
real :: a
if (abs(x).le.abs(y)) go to 10
a=y/x
r=abs(x)*sqrt(1.0+a*a)
theta=atan2(y,x)
return
10 if (y.eq.0.) go to 20
a=x/y
r=abs(y)*sqrt(1.0+a*a)
theta=atan2(y,x)
return
20 r=0.0
theta=0.0
return
end subroutine capo

subroutine rota(x1,y1,a,x2,y2)
implicit none
real, intent(in) :: a, x1
real, intent(out) :: x2
real, intent(in) :: y1
real, intent(out) :: y2
real :: cosa, sina
sina=sin(a)
cosa=cos(a)
x2= x1*cosa+y1*sina
y2=-x1*sina+y1*cosa
return
end subroutine rota

subroutine srotg(sa,sb,sc,ss)
implicit none
real, intent(inout) :: sa, sb, sc, ss
real :: r, u, v
!
!     Designed by C.L.Lawson, JPL, 1977 sept 08
!
!
!     Construct the Givens transformation
!
!         ( sc  ss )
!     g = (        ) ,    sc**2 + ss**2 = 1 ,
!         (-ss  sc )
!
!     WHICH ZEROS THE SECOND ENTRY OF THE 2-VECTOR  (sa,sb)**T .
!
!     THE QUANTITY r = (+/-)sqrt(sa**2 + sb**2) OVERWRITES sa IN
!     STORAGE.  THE VALUE OF sb IS OVERWRITTEN BY A VALUE Z WHICH
!     ALLOWS sc AND ss TO BE RECOVERED BY THE FOLLOWING ALGORITHM:
!           IF Z=1  SET  sc=0.  AND  ss=1.
!           IF abs(Z) .LT. 1  SET  sc=sqrt(1-Z**2)  AND  ss=Z
!           IF abs(Z) .GT. 1  SET  sc=1/Z  AND  ss=sqrt(1-sc**2)
!
!     Normally, the subprogram srot(N,SX,INCX,SY,INCY,sc,ss) will
!     next be called to apply the transformation to A 2 by N matrix.
!
! ------------------------------------------------------------------
!
if (abs(sa) .le. abs(sb)) go to 10
!
! *** HERE abs(sa) .GT. abs(sb) ***
!
u = sa + sa
v = sb / u
!
!     Note that u and r have the sign of sa
!
r = sqrt(.25 + v**2) * u
!
!     Note that sc is positive
!
sc = sa / r
ss = v * (sc + sc)
sb = ss
sa = r
return
!
! *** HERE abs(sa) .LE. abs(sb) ***
!
10 if (sb .eq. 0.) go to 20
u = sb + sb
v = sa / u
!
!     Note that u and r have the sign of sb
!     (r is immediately stored in sa)
!
sa = sqrt(.25 + v**2) * u
!
!     Note that ss is positive
!
ss = sb / sa
sc = v * (ss + ss)
if (sc .eq. 0.) go to 15
sb = 1. / sc
return
15 sb = 1.
return
!
! *** HERE sa = sb = 0. ***
!
20 sc = 1.
ss = 0.
return
!
end subroutine srotg

subroutine drotg(da,db,dc,ds)
implicit none
!
!     Designed by C.L.Lawson, JPL, 1977 sept 08
!
!
!     Construct the Givens transformation
!
!         ( dc  ds )
!     g = (        ) ,    dc**2 + ds**2 = 1 ,
!         (-ds  dc )
!
!     WHICH ZEROS THE SECOND ENTRY OF THE 2-VECTOR  (da,db)**T .
!
!     THE QUANTITY r = (+/-)dsqrt(da**2 + db**2) OVERWRITES da IN
!     STORAGE.  THE VALUE OF db IS OVERWRITTEN BY A VALUE Z WHICH
!     ALLOWS dc AND ds TO BE RECOVERED BY THE FOLLOWING ALGORITHM:
!           IF Z=1  SET  dc=0.D0  AND  ds=1.D0
!           IF dabs(Z) .LT. 1  SET  dc=dsqrt(1-Z**2)  AND  ds=Z
!           IF dabs(Z) .GT. 1  SET  dc=1/Z  AND  ds=dsqrt(1-dc**2)
!
!     Normally, the subprogram drot(N,DX,INCX,DY,INCY,dc,ds) will
!     next be called to apply the transformation to A 2 by N matrix.
!
! ------------------------------------------------------------------
!
double precision, intent(inout) :: da, db, dc, ds
double precision :: u, v, r
if (dabs(da) .le. dabs(db)) go to 10
!
! *** HERE dabs(da) .GT. dabs(db) ***
!
u = da + da
v = db / u
!
!     Note that u and r have the sign of da
!
r = dsqrt(.25d0 + v**2) * u
!
!     Note that dc is positive
!
dc = da / r
ds = v * (dc + dc)
db = ds
da = r
return
!
! *** HERE dabs(da) .LE. dabs(db) ***
!
10 if (db .eq. 0.d0) go to 20
u = db + db
v = da / u
!
!     Note that u and r have the sign of db
!     (r is immediately stored in da)
!
da = dsqrt(.25d0 + v**2) * u
!
!     Note that ds is positive
!
ds = db / da
dc = v * (ds + ds)
if (dc .eq. 0.d0) go to 15
db = 1.d0 / dc
return
15 db = 1.d0
return
!
! *** HERE da = db = 0.D0 ***
!
20 dc = 1.d0
ds = 0.d0
return
!
end subroutine drotg

subroutine rot3 (a, theta)
implicit none
real :: a(3,3)
real, intent(inout) :: theta(3)
real :: pihalf, r, t, u, v
data pihalf/1.5707963267949/
!     --------------------
if (abs(a(1,1)) .gt. abs(a(2,1))) go to 10
if (a(2,1) .ne. 0.0) go to 11
!
!     CASE WHEN a(1,1) = a(2,1) = 0
!
theta(3) = 0.0
theta(2) = sign(pihalf,a(3,1))
u = a(2,2)
v = a(1,2)
if (a(3,1) .gt. 0.0) v = -v
theta(1) = atan2(v,u)
return
!
!     COMPUTATION OF r = sqrt(a(1,1)**2 + a(2,1)**2)
!
10 t = a(2,1)/a(1,1)
r = abs(a(1,1))*sqrt(1.0 + t*t)
go to 20
11 t = a(1,1)/a(2,1)
r = abs(a(2,1))*sqrt(1.0 + t*t)
!
!     Evaluation of the angles
!
20 theta(3) = atan2(a(2,1),a(1,1))
theta(2) = atan2(a(3,1),r)
u = dble(a(1,1))*dble(a(2,2)) - dble(a(1,2))*dble(a(2,1))
if (abs(theta(2)) .gt. 0.8) go to 21
u = u/r
v = a(3,2)/cos(theta(2))
go to 22
21 v = dble(a(1,1))*dble(a(1,2)) + dble(a(2,1))*dble(a(2,2))
v = -v/sin(theta(2))
22 theta(1) = atan2(v,u)
return
end subroutine rot3

subroutine constr (xk,yk,zk, cx,sx,cy,sy)
implicit none
real, intent(in) :: xk, yk, zk
real, intent(inout) :: cx, sx
real, intent(out) :: cy, sy
!
!***********************************************************
!
!                                               Robert renka
!                                       oak ridge natl. Lab.
!
!   This subroutine constructs the elements of A 3 by 3
! orthogonal matrix R which rotates a point (xk,yk,zk) on
! the unit sphere to the north pole, I.E.
!
!      (xk)     (cy  0 -sy)   (1   0   0)   (xk)     (0)
!  R * (yk)  =  ( 0  1   0) * (0  cx -sx) * (yk)  =  (0)
!      (zk)     (sy  0  cy)   (0  sx  cx)   (zk)     (1)
!
! Input parameters - xk,yk,zk - components of a unit vector
!                               to be rotated to (0,0,1).
!
! Input parameters are not altered by this routine.
!
! Output parameters - cx,sx,cy,sy - elements of R -- cx,sx
!                                   define a rotation about
!                                   the X-axis and cy,sy DE-
!                                   fine a rotation about
!                                   the Y-axis.
!
! Intrinsic function called by constr - sqrt
!
!***********************************************************
!
cy = sqrt(yk*yk + zk*zk)
sy = xk
if (cy .eq. 0.) go to 1
cx = zk/cy
sx = yk/cy
return
!
! (xk,yk,zk) lies on the X-axis
!
1 cx = 1.
sx = 0.
return
end subroutine constr

real function ang (n, x, y)
implicit none
integer, intent(in) :: n
integer :: i
real :: d, rx, ry
real :: snrm2
!-----------------------------------------------------------------------
!           Computation of the angle between two vectors
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n)
!
if (n .lt. 2) go to 30
rx = snrm2(n, x, 1)
if (rx .eq. 0.0) go to 30
ry = snrm2(n, y, 1)
if (ry .eq. 0.0) go to 30
!
d = 0.0
do i = 1,n
   d = d + (x(i)/rx - y(i)/ry)**2
end do
if (d .gt. 3.0) go to 20
ang = acos(0.5 + (0.5 - 0.5*d))
return
!
20 d = 0.0
do i = 1,n
   d = d + (x(i)/rx + y(i)/ry)**2
end do
ang = acos((0.5*d - 0.5) - 0.5)
return
!
!                           Error return
!
30 ang = -1.0
return
end function ang

real function sin0 (x)
implicit none
real, intent(in) :: x
real :: a0, a1, a2, a3, a4, a5, a6, t
!-----------------------------------------------------------------------
!          COMPUTATION OF sin(x*PI/2) FOR abs(x) .LE. 0.5
!-----------------------------------------------------------------------
data a0 /.157079632679490e+01/, a1 /-.645964097506244e+00/, &
&a2 /.796926262460396e-01/, a3 /-.468175413228242e-02/, &
&a4 /.160441150291651e-03/, a5 /-.359864175444606e-05/, &
&a6 /.563372101191893e-07/
!------------------------
t = x*x
sin0 = ((((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t &
&+ a1)*t + a0)*x
return
end function sin0

real function cos0 (x)
implicit none
real, intent(in) :: x
real :: a1, a2, a3, a4, a5, a6, t
!-----------------------------------------------------------------------
!          COMPUTATION OF cos(x*PI/2) FOR abs(x) .LE. 0.5
!-----------------------------------------------------------------------
data a1 /-.123370055013615e+01/, a2 /.253669507899753e+00/, &
&a3 /-.208634807330586e-01/, a4 /.919259935580283e-03/, &
&a5 /-.252000841382533e-04/, a6 /.465461768260405e-06/
!------------------------
t = x*x
cos0 = (((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t + a1)*t + 1.0
return
end function cos0

real function sin1 (x)
implicit none
real, intent(in) :: x
integer :: max, n
real :: a, a0, a1, a2, a3, a4, a5, a6, b1, b2, b3, b4, b5, b6, t
integer :: ipmpar
!-----------------------------------------------------------------------
!                   Evaluation  of sin(x*PI)
!-----------------------------------------------------------------------
data a0 /.314159265358979e+01/, a1 /-.516771278004995e+01/, &
&a2 /.255016403987327e+01/, a3 /-.599264528932149e+00/, &
&a4 /.821458689493251e-01/, a5 /-.737001831310553e-02/, &
&a6 /.461514425296398e-03/
data b1 /-.493480220054460e+01/, b2 /.405871212639605e+01/, &
&b3 /-.133526276691575e+01/, b4 /.235330543508553e+00/, &
&b5 /-.258048861575714e-01/, b6 /.190653140279462e-02/
!------------------------
!
!     ****** max IS A MACHINE DEPENDENT CONSTANT. MAX IS THE
!            largest positive integer that may be used.
!
                 max = ipmpar(3)
!
!------------------------
a = abs(x)
if (a .lt. float(max)) go to 10
   sin1 = 0.0
   return
!
10 n = a
a = a - float(n)
if (a .gt. 0.75) go to 20
if (a .lt. 0.25) go to 21
!
!                    0.25 .LE. a .LE. 0.75
!
a = 0.25 + (0.25 - a)
t = a*a
sin1 = ((((((b6*t + b5)*t + b4)*t + b3)*t + b2)*t &
&+ b1)*t + 0.5) + 0.5
go to 30
!
!                 a .LT. 0.25  OR  a .GT. 0.75
!
20 a = 0.25 + (0.75 - a)
21 t = a*a
sin1 = ((((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t &
&+ a1)*t + a0)*a
!
!                        Termination
!
30 if (x .lt. 0.0) sin1 = - sin1
if (mod(n,2) .ne. 0) sin1 = - sin1
return
end function sin1

real function cos1 (x)
implicit none
real, intent(in) :: x
integer :: max, n
real :: a, a0, a1, a2, a3, a4, a5, a6, b1, b2, b3, b4, b5, b6, t
integer :: ipmpar
!-----------------------------------------------------------------------
!                   Evaluation  of cos(x*PI)
!-----------------------------------------------------------------------
data a0 /.314159265358979e+01/, a1 /-.516771278004995e+01/, &
&a2 /.255016403987327e+01/, a3 /-.599264528932149e+00/, &
&a4 /.821458689493251e-01/, a5 /-.737001831310553e-02/, &
&a6 /.461514425296398e-03/
data b1 /-.493480220054460e+01/, b2 /.405871212639605e+01/, &
&b3 /-.133526276691575e+01/, b4 /.235330543508553e+00/, &
&b5 /-.258048861575714e-01/, b6 /.190653140279462e-02/
!------------------------
!
!     ****** max IS A MACHINE DEPENDENT CONSTANT. MAX IS THE
!            largest positive integer that may be used.
!
                 max = ipmpar(3)
!
!------------------------
a = abs(x)
if (a .lt. float(max)) go to 10
   cos1 = 1.0
   return
!
10 n = a
a = a - float(n)
if (a .gt. 0.75) go to 20
if (a .lt. 0.25) go to 21
!
!                    0.25 .LE. a .LE. 0.75
!
a = 0.25 + (0.25 - a)
t = a*a
cos1 = ((((((a6*t + a5)*t + a4)*t + a3)*t + a2)*t &
&+ a1)*t + a0)*a
go to 30
!
!                 a .LT. 0.25  OR  a .GT. 0.75
!
20 a = 0.25 + (0.75 - a)
n = n - 1
21 t = a*a
cos1 = ((((((b6*t + b5)*t + b4)*t + b3)*t + b2)*t &
&+ b1)*t + 0.5) + 0.5
!
!                        Termination
!
30 if (mod(n,2) .ne. 0) cos1 = - cos1
return
end function cos1

double precision function dsin1 (x)
implicit none
integer :: max, n
integer :: ipmpar
!-----------------------------------------------------------------------
!
!                Double precision evaluation of sin(pi*x)
!
!                             --------------
!
!     THE EXPANSION FOR sin(pi*a) (abs(a) .LE. pi/4) USING a1,...,A13
!     is accurate to within 2 units of the 40-TH significant digit, and
!     THE EXPANSION FOR cos(pi*a) (abs(a) .LE. pi/4) USING b1,...,B13
!     is accurate to within 4 units of the 40-TH significant digit.
!
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: a, pi, t, w
double precision :: a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, &
&a12, a13
double precision :: b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, &
&b12, b13
!------------------------
data pi /3.141592653589793238462643383279502884197d+00/
!------------------------
data a1  /-.1028083791780141522795259479153765743002d+00/, &
&a2  / .3170868848763100170457042079710451905600d-02/, &
&a3  /-.4657026956105571623449026167864697920000d-04/, &
&a4  / .3989844942879455643410226655783424000000d-06/, &
&a5  /-.2237397227721999776371894030796800000000d-08/, &
&a6  / .8847045483056962709715066675200000000000d-11/, &
&a7  /-.2598715447506450292885585920000000000000d-13/, &
&a8  / .5893449774331011070033920000000000000000d-16/, &
&a9  /-.1062975472045522550784000000000000000000d-18/, &
&a10 / .1561182648301780992000000000000000000000d-21/, &
&a11 /-.1903193516670976000000000000000000000000d-24/, &
&a12 / .1956617650176000000000000000000000000000d-27/, &
&a13 /-.1711276032000000000000000000000000000000d-30/
!------------------------
data b1  /-.3084251375340424568385778437461297229882d+00/, &
&b2  / .1585434424381550085228521039855226435920d-01/, &
&b3  /-.3259918869273900136414318317506279360000d-03/, &
&b4  / .3590860448591510079069203991239232000000d-05/, &
&b5  /-.2461136950494199754009084061808640000000d-07/, &
&b6  / .1150115912797405152263195572224000000000d-09/, &
&b7  /-.3898073171259675439899172864000000000000d-12/, &
&b8  / .1001886461636271969091584000000000000000d-14/, &
&b9  /-.2019653396886572027084800000000000000000d-17/, &
&b10 / .3278483561466560512000000000000000000000d-20/, &
&b11 /-.4377345082051788800000000000000000000000d-23/, &
&b12 / .4891532381388800000000000000000000000000d-26/, &
&b13 /-.4617089843200000000000000000000000000000d-29/
!------------------------
!
!     ****** max IS A MACHINE DEPENDENT CONSTANT. MAX IS THE
!            largest positive integer that may be used.
!
                 max = ipmpar(3)
!
!------------------------
a = dabs(x)
t = max
if (a .lt. t) go to 10
   dsin1 = 0.d0
   return
!
10 n = a
t = n
a = a - t
if (a .gt. 0.75d0) go to 20
if (a .lt. 0.25d0) go to 21
!
!                    0.25 .LE. a .LE. 0.75
!
a = 0.25d0 + (0.25d0 - a)
t = 16.d0*a*a
dsin1 = (((((((((((((b13*t + b12)*t + b11)*t + b10)*t + b9)*t + &
&b8)*t + b7)*t + b6)*t + b5)*t + b4)*t + b3)*t + &
&b2)*t + b1)*t + 0.5d0) + 0.5d0
go to 30
!
!                 a .LT. 0.25  OR  a .GT. 0.75
!
20 a = 0.25d0 + (0.75d0 - a)
21 t = 16.d0*a*a
w = (((((((((((((a13*t + a12)*t + a11)*t + a10)*t + a9)*t + &
&a8)*t + a7)*t + a6)*t + a5)*t + a4)*t + a3)*t + &
&a2)*t + a1)*t + 0.5d0) + 0.5d0
dsin1 = pi*a*w
!
!                        Termination
!
30 if (x .lt. 0.0) dsin1 = - dsin1
if (mod(n,2) .ne. 0) dsin1 = - dsin1
return
end function dsin1

double precision function dcos1 (x)
implicit none
integer :: max, n
integer :: ipmpar
!-----------------------------------------------------------------------
!
!                Double precision evaluation of cos(pi*x)
!
!                             --------------
!
!     THE EXPANSION FOR sin(pi*a) (abs(a) .LE. pi/4) USING a1,...,A13
!     is accurate to within 2 units of the 40-TH significant digit, and
!     THE EXPANSION FOR cos(pi*a) (abs(a) .LE. pi/4) USING b1,...,B13
!     is accurate to within 4 units of the 40-TH significant digit.
!
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: a, pi, t, w
double precision :: a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, &
&a12, a13
double precision :: b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, &
&b12, b13
!------------------------
data pi /3.141592653589793238462643383279502884197d+00/
!------------------------
data a1  /-.1028083791780141522795259479153765743002d+00/, &
&a2  / .3170868848763100170457042079710451905600d-02/, &
&a3  /-.4657026956105571623449026167864697920000d-04/, &
&a4  / .3989844942879455643410226655783424000000d-06/, &
&a5  /-.2237397227721999776371894030796800000000d-08/, &
&a6  / .8847045483056962709715066675200000000000d-11/, &
&a7  /-.2598715447506450292885585920000000000000d-13/, &
&a8  / .5893449774331011070033920000000000000000d-16/, &
&a9  /-.1062975472045522550784000000000000000000d-18/, &
&a10 / .1561182648301780992000000000000000000000d-21/, &
&a11 /-.1903193516670976000000000000000000000000d-24/, &
&a12 / .1956617650176000000000000000000000000000d-27/, &
&a13 /-.1711276032000000000000000000000000000000d-30/
!------------------------
data b1  /-.3084251375340424568385778437461297229882d+00/, &
&b2  / .1585434424381550085228521039855226435920d-01/, &
&b3  /-.3259918869273900136414318317506279360000d-03/, &
&b4  / .3590860448591510079069203991239232000000d-05/, &
&b5  /-.2461136950494199754009084061808640000000d-07/, &
&b6  / .1150115912797405152263195572224000000000d-09/, &
&b7  /-.3898073171259675439899172864000000000000d-12/, &
&b8  / .1001886461636271969091584000000000000000d-14/, &
&b9  /-.2019653396886572027084800000000000000000d-17/, &
&b10 / .3278483561466560512000000000000000000000d-20/, &
&b11 /-.4377345082051788800000000000000000000000d-23/, &
&b12 / .4891532381388800000000000000000000000000d-26/, &
&b13 /-.4617089843200000000000000000000000000000d-29/
!------------------------
!
!     ****** max IS A MACHINE DEPENDENT CONSTANT. MAX IS THE
!            largest positive integer that may be used.
!
                 max = ipmpar(3)
!
!------------------------
a = dabs(x)
t = max
if (a .lt. t) go to 10
   dcos1 = 1.d0
   return
!
10 n = a
t = n
a = a - t
if (a .gt. 0.75d0) go to 20
if (a .lt. 0.25d0) go to 21
!
!                    0.25 .LE. a .LE. 0.75
!
a = 0.25d0 + (0.25d0 - a)
t = 16.d0*a*a
w = (((((((((((((a13*t + a12)*t + a11)*t + a10)*t + a9)*t + &
&a8)*t + a7)*t + a6)*t + a5)*t + a4)*t + a3)*t + &
&a2)*t + a1)*t + 0.5d0) + 0.5d0
dcos1 = pi*a*w
go to 30
!
!                 a .LT. 0.25  OR  a .GT. 0.75
!
20 a = 0.25d0 + (0.75d0 - a)
n = n - 1
21 t = 16.d0*a*a
dcos1 = (((((((((((((b13*t + b12)*t + b11)*t + b10)*t + b9)*t + &
&b8)*t + b7)*t + b6)*t + b5)*t + b4)*t + b3)*t + &
&b2)*t + b1)*t + 0.5d0) + 0.5d0
!
!                        Termination
!
30 if (mod(n,2) .ne. 0) dcos1 = - dcos1
return
end function dcos1

subroutine snhcsh (sinhm,coshm,x,isw)
implicit none
real :: ax, cp1, cp2, cp3, cp4, cp5, cq1, expx, sp1, sp2, sp3, &
&sp4, sp5, sq1, xs, xx, zp1, zp2, zp3, zq1, zq2, zq3, zq4
!
integer, intent(in) :: isw
real, intent(inout) :: sinhm, coshm
real, intent(in) :: x
real :: cut(5)
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!                          MODIFIED BY A.H. MORRIS (NSWC/DL)
!
! This subroutine returns approximations to
!       sinhm(x) = sinh(x)-x
!       coshm(x) = cosh(x)-1
! and
!       coshmm(x) = cosh(x)-1-x*x/2
!
! On input--
!
!   x contains the value of the independent variable.
!
!   isw indicates the function desired
!           = -1 IF ONLY sinhm IS DESIRED,
!           =  0 IF BOTH sinhm AND coshm ARE DESIRED,
!           =  1 IF ONLY coshm IS DESIRED,
!           =  2 IF ONLY COSHMM IS DESIRED,
!           =  3 IF BOTH sinhm AND COSHMM ARE DESIRED.
!
! On output--
!
!   sinhm CONTAINS THE VALUE OF sinhm(x) IF isw .LE. 0 OR
!   isw .EQ. 3 (sinhm IS UNALTERED IF isw .EQ.1 OR isw .EQ.
!   2).
!
!   coshm CONTAINS THE VALUE OF coshm(x) IF isw .EQ. 0 OR
!   isw .EQ. 1 AND CONTAINS THE VALUE OF COSHMM(x) IF isw
!   .GE. 2 (coshm IS UNALTERED IF isw .EQ. -1).
!
! And
!
!   x and isw are unaltered.
!
!-----------------------------------------------------------
!
data sp5/.255251817302048e-09/, &
&sp4/.723809046696880e-07/, &
&sp3/.109233297700241e-04/, &
&sp2/.954811583154274e-03/, &
&sp1/.452867078563929e-01/, &
&sq1/-.471329214363072e-02/
data cp5/.116744361560051e-08/, &
&cp4/.280407224259429e-06/, &
&cp3/.344417983443219e-04/, &
&cp2/.232293648552398e-02/, &
&cp1/.778752378267155e-01/, &
&cq1/-.545809550662099e-02/
data zp3/5.59297116264720e-07/, &
&zp2/1.77943488030894e-04/, &
&zp1/1.69800461894792e-02/, &
&zq4/1.33412535492375e-09/, &
&zq3/-5.80858944138663e-07/, &
&zq2/1.27814964403863e-04/, &
&zq1/-1.63532871439181e-02/
data cut(1)/1.65/, cut(2)/1.2/, cut(3)/1.2/, cut(4)/2.7/, &
&cut(5)/1.65/
!
xx = x
ax = abs(xx)
xs = xx*xx
if (ax .ge. cut(isw+2)) expx = exp(ax)
!
! sinhm APPROXIMATION
!
if (isw .eq. 1 .or. isw .eq. 2) go to 2
if (ax .ge. 1.65) go to 1
sinhm = ((((((sp5*xs+sp4)*xs+sp3)*xs+sp2)*xs+sp1)*xs+1.) &
&*xs*xx)/((sq1*xs+1.)*6.)
go to 2
1 sinhm = -(((ax+ax)+1./expx)-expx)/2.
if (xx .lt. 0.) sinhm = -sinhm
!
! coshm APPROXIMATION
!
2 if (isw .ne. 0 .and. isw .ne. 1) go to 4
if (ax .ge. 1.2) go to 3
coshm = ((((((cp5*xs+cp4)*xs+cp3)*xs+cp2)*xs+cp1)*xs+1.) &
&*xs)/((cq1*xs+1.)*2.)
go to 4
3 coshm = ((1./expx-2.)+expx)/2.
!
! COSHMM APPROXIMATION
!
4 if (isw .le. 1) return
if (ax .ge. 2.70) go to 5
coshm = ((((zp3*xs+zp2)*xs+zp1)*xs+1.)*xs*xs)/(((((zq4 &
&*xs+zq3)*xs+zq2)*xs+zq1)*xs+1.)*24.)
return
5 coshm = (((1./expx-2.)-xs)+expx)/2.
return
end subroutine snhcsh

real function esum (mu, x)
implicit none
integer, intent(in) :: mu
real, intent(in) :: x
real :: w
!-----------------------------------------------------------------------
!                    Evaluation of exp(mu + x)
!-----------------------------------------------------------------------
if (x .gt. 0.0) go to 10
!
if (mu .lt. 0) go to 20
   w = mu + x
   if (w .gt. 0.0) go to 20
   esum = exp(w)
   return
!
10 if (mu .gt. 0) go to 20
   w = mu + x
   if (w .lt. 0.0) go to 20
   esum = exp(w)
   return
!
20 w = mu
esum = exp(w)*exp(x)
return
end function esum

double precision function desum (mu, x)
implicit none
integer, intent(in) :: mu
!-----------------------------------------------------------------------
!                    Evaluation of exp(mu + x)
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: w
!
if (x .gt. 0.d0) go to 10
!
if (mu .lt. 0) go to 20
   w = mu + x
   if (w .gt. 0.d0) go to 20
   desum = dexp(w)
   return
!
10 if (mu .gt. 0) go to 20
   w = mu + x
   if (w .lt. 0.d0) go to 20
   desum = dexp(w)
   return
!
20 w = mu
desum = dexp(w)*dexp(x)
return
end function desum

real function rexp (x)
implicit none
real, intent(in) :: x
real :: e, p1, p2, q1, q2, q3, q4
!-----------------------------------------------------------------------
!            Evaluation of the function exp(x) - 1
!-----------------------------------------------------------------------
data p1/ .914041914819518e-09/, p2/ .238082361044469e-01/, &
&q1/-.499999999085958e+00/, q2/ .107141568980644e+00/, &
&q3/-.119041179760821e-01/, q4/ .595130811860248e-03/
!-----------------------
if (abs(x) .gt. 0.15) go to 10
rexp = x*(((p2*x + p1)*x + 1.0)/((((q4*x + q3)*x + q2)*x &
&+ q1)*x + 1.0))
return
!
10 if (x .lt. 0.0) go to 20
   e = exp(x)
   rexp = e*(0.5 + (0.5 - 1.0/e))
   return
20 if (x .lt. -37.0) go to 30
   rexp = (exp(x) - 0.5) - 0.5
   return
30 rexp = -1.0
return
end function rexp

double precision function drexp (x)
implicit none
!-----------------------------------------------------------------------
!            Evaluation of the function exp(x) - 1
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: e, w, z
double precision :: a0, a1, a2, a3, a4, b1, b2, b3, b4
double precision :: c1, c2, c3, c4, c5
!---------------------------
data a0/ .248015873015873015873016d-04/, &
&a1/-.344452080605731005808147d-05/, &
&a2/ .206664230430046597475413d-06/, &
&a3/-.447300111094328162971036d-08/, &
&a4/ .114734027080634968083920d-11/
data b1/-.249994190011341852652396d+00/, &
&b2/ .249987228833107957725728d-01/, &
&b3/-.119037506846942249362528d-02/, &
&b4/ .228908693387350391768682d-04/
!---------------------------
!     ci = 1/factorial(i + 2)
!---------------------------
data c1 / .1666666666666666666666666666666667d+00/, &
&c2 / .4166666666666666666666666666666667d-01/, &
&c3 / .8333333333333333333333333333333333d-02/, &
&c4 / .1388888888888888888888888888888889d-02/, &
&c5 / .1984126984126984126984126984126984d-03/
!---------------------------
if (dabs(x) .gt. 0.15d0) go to 10
!
!        z is a minimax approximation of the series
!
!                C6 + C7*x + C8*x**2 + ....
!
!        This approximation is accurate to within
!        1 unit of the 23-RD significant digit.
!        The resulting value for w is accurate to
!        within 1 unit of the 33-RD significant
!        digit.
!
z = ((((a4*x + a3)*x + a2)*x + a1)*x + a0) / &
&((((b4*x + b3)*x + b2)*x + b1)*x + 1.d0)
w = ((((((z*x + c5)*x + c4)*x + c3)*x + c2)*x + &
&c1)*x + 0.5d0)*x + 1.d0
drexp = x*w
return
!
10 if (x .lt. 0.d0) go to 20
   e = dexp(x)
   drexp = e*(0.5d0 + (0.5d0 - 1.d0/e))
   return
20 if (x .lt. -77.d0) go to 30
   drexp = (dexp(x) - 0.5d0) - 0.5d0
   return
30 drexp = -1.d0
return
end function drexp

subroutine rexp1 (x, e, w)
implicit none
real, intent(inout) :: e, w
real, intent(in) :: x
real :: p1, p2, q1, q2, q3, q4
!-----------------------------------------------------------------------
!
!                  EVALUATION OF w = (exp(x) - 1)/x
!
!     e IS AN INPUT/OUTPUT VARIABLE. IF e .GE. 0 THEN IT IS ASSUMED
!     THAT e = exp(x). IN THIS CASE e IS NOT MODIFIED. IF e .LT. 0
!     then e is set to exp(x) when this value is needed.
!
!-----------------------------------------------------------------------
data p1/ .914041914819518e-09/, p2/ .238082361044469e-01/, &
&q1/-.499999999085958e+00/, q2/ .107141568980644e+00/, &
&q3/-.119041179760821e-01/, q4/ .595130811860248e-03/
!-----------------------
if (abs(x) .gt. 0.15) go to 10
w = ((p2*x + p1)*x + 1.0)/((((q4*x + q3)*x + q2)*x &
&+ q1)*x + 1.0)
return
!
10 if (x .lt. 0.0) go to 20
   if (e .lt. 0.0) e = exp(x)
   w = (e*(0.5 + (0.5 - 1.0/e)))/x
   return
20 if (x .lt. -37.0) go to 30
   if (e .lt. 0.0) e = exp(x)
   w = ((e - 0.5) - 0.5)/x
   return
30 w = -1.0/x
return
end subroutine rexp1

subroutine drexp1 (x, e, w)
implicit none
!-----------------------------------------------------------------------
!
!                  EVALUATION OF w = (exp(x) - 1)/x
!
!     e IS AN INPUT/OUTPUT VARIABLE. IF e .GE. 0 THEN IT IS ASSUMED
!     THAT e = exp(x). IN THIS CASE e IS NOT MODIFIED. IF e .LT. 0
!     then e is set to exp(x) when this value is needed.
!
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision, intent(inout) :: e
double precision, intent(out) :: w
double precision :: z
double precision :: a0, a1, a2, a3, a4, b1, b2, b3, b4
double precision :: c1, c2, c3, c4, c5
!---------------------------
data a0/ .248015873015873015873016d-04/, &
&a1/-.344452080605731005808147d-05/, &
&a2/ .206664230430046597475413d-06/, &
&a3/-.447300111094328162971036d-08/, &
&a4/ .114734027080634968083920d-11/
data b1/-.249994190011341852652396d+00/, &
&b2/ .249987228833107957725728d-01/, &
&b3/-.119037506846942249362528d-02/, &
&b4/ .228908693387350391768682d-04/
!---------------------------
!     ci = 1/factorial(i + 2)
!---------------------------
data c1 / .1666666666666666666666666666666667d+00/, &
&c2 / .4166666666666666666666666666666667d-01/, &
&c3 / .8333333333333333333333333333333333d-02/, &
&c4 / .1388888888888888888888888888888889d-02/, &
&c5 / .1984126984126984126984126984126984d-03/
!---------------------------
w = 1.d0
if (dabs(x) .lt. 1.d-33) return
if (dabs(x) .gt. 0.15d0) go to 10
!
!        z is a minimax approximation of the series
!
!                C6 + C7*x + C8*x**2 + ....
!
!        This approximation is accurate to within
!        1 unit of the 23-RD significant digit.
!        The resulting value for w is accurate to
!        within 1 unit of the 33-RD significant
!        digit.
!
z = ((((a4*x + a3)*x + a2)*x + a1)*x + a0) / &
&((((b4*x + b3)*x + b2)*x + b1)*x + 1.d0)
w = ((((((z*x + c5)*x + c4)*x + c3)*x + c2)*x + &
&c1)*x + 0.5d0)*x + 1.d0
return
!
10 if (x .lt. 0.d0) go to 20
   if (e .lt. 0.d0) e = dexp(x)
   w = (e*(0.5d0 + (0.5d0 - 1.d0/e)))/x
   return
20 if (x .lt. -77.d0) go to 30
   if (e .lt. 0.d0) e = dexp(x)
   w = ((e - 0.5d0) - 0.5d0)/x
   return
30 w = -1.d0/x
return
end subroutine drexp1

real function alnrel(a)
implicit none
real, intent(in) :: a
real :: p1, p2, p3, q1, q2, q3, t, t2, w, x
!-----------------------------------------------------------------------
!            Evaluation of the function LN(1 + a)
!-----------------------------------------------------------------------
data p1/-.129418923021993e+01/, p2/.405303492862024e+00/, &
&p3/-.178874546012214e-01/
data q1/-.162752256355323e+01/, q2/.747811014037616e+00/, &
&q3/-.845104217945565e-01/
!--------------------------
if (abs(a) .gt. 0.375) go to 10
t = a/(a + 2.0)
t2 = t*t
w = (((p3*t2 + p2)*t2 + p1)*t2 + 1.0)/ &
&(((q3*t2 + q2)*t2 + q1)*t2 + 1.0)
alnrel = 2.0*t*w
return
!
10 x = 1.0 + a
if (a .lt. 0.0) x = (a + 0.5) + 0.5
alnrel = alog(x)
return
end function alnrel

double precision function dlnrel (a)
implicit none
!-----------------------------------------------------------------------
!            Evaluation of the function LN(1 + a)
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision :: t, t2, w, z
double precision :: p0, p1, p2, p3, q1, q2, q3, q4
double precision :: c1, c2, c3, c4, c5
!-------------------------
data p0 / .7692307692307692307680d-01/, &
&p1 /-.1505958055914600184836d+00/, &
&p2 / .9302355725278521726994d-01/, &
&p3 /-.1787900022182327735804d-01/
data q1 /-.2824412139355646910683d+01/, &
&q2 / .2892424216041495392509d+01/, &
&q3 /-.1263560605948009364422d+01/, &
&q4 / .1966769435894561313526d+00/
!-------------------------
!     ci = 1/(2i + 1)
!-------------------------
data c1 /.3333333333333333333333333333333d+00/, &
&c2 /.2000000000000000000000000000000d+00/, &
&c3 /.1428571428571428571428571428571d+00/, &
&c4 /.1111111111111111111111111111111d+00/, &
&c5 /.9090909090909090909090909090909d-01/
!-------------------------
if (dabs(a) .lt. 0.375d0) go to 10
t = 1.d0 + a
if (a .lt. 0.d0) t = 0.5d0 + (0.5d0 + a)
dlnrel = dlog(t)
return
!
!        w is a minimax approximation of the series
!
!               C6 + C7*t**2 + C8*t**4 + ...
!
!        This approximation is accurate to within
!        1.6 units of the 21-ST significant digit.
!        The resulting value for 1.D0 + t2*z is
!        accurate to within 1 unit of the 30-TH
!        significant digit.
!
10 t = a/(a + 2.d0)
t2 = t*t
w = (((p3*t2 + p2)*t2 + p1)*t2 + p0)/ &
&((((q4*t2 + q3)*t2 + q2)*t2 + q1)*t2 + 1.d0)
!
z = ((((w*t2 + c5)*t2 + c4)*t2 + c3)*t2 + c2)*t2 + c1
dlnrel = 2.d0*t*(1.d0 + t2*z)
return
end function dlnrel

real function rlog(x)
implicit none
real, intent(in) :: x
real :: a, b, p0, p1, p2, q1, q2, r, t, u, up2, w, w1
!-----------------------------------------------------------------------
!             Evaluation of the function x - 1 - LN(x)
!-----------------------------------------------------------------------
!     a = rlog (0.7)
!     b = rlog (4/3)
!------------------------
data a/.566749439387324e-01/
data b/.456512608815524e-01/
!------------------------
data p0/ .333333333333333e+00/, p1/-.224696413112536e+00/, &
&p2/ .620886815375787e-02/
data q1/-.127408923933623e+01/, q2/ .354508718369557e+00/
!------------------------
if (x .lt. 0.61 .or. x .gt. 1.57) go to 100
if (x .lt. 0.82) go to 10
if (x .gt. 1.18) go to 20
!
!                 Argument reduction
!
u = (x - 0.5) - 0.5
up2 = u + 2.0
w1 = 0.0
go to 30
!
10 u = (x - 0.7)/0.7
up2 = u + 2.0
w1 = a - u*0.3
go to 30
!
20 t = 0.75*(x - 1.0)
u = t - 0.25
up2 = t + 1.75
w1 = b + u/3.0
!
!                  Series expansion
!
30 r = u/up2
t = r*r
w = ((p2*t + p1)*t + p0)/((q2*t + q1)*t + 1.0)
rlog = r*(u - 2.0*t*w) + w1
return
!
!
100 r = (x - 0.5) - 0.5
rlog = r - alog(x)
return
end function rlog

real function rlog1(x)
implicit none
real, intent(in) :: x
real :: a, b, p0, p1, p2, q1, q2, r, t, u, up2, w, w1
!-----------------------------------------------------------------------
!             Evaluation of the function x - LN(1 + x)
!-----------------------------------------------------------------------
!     a = rlog (0.7)
!     b = rlog (4/3)
!------------------------
data a/.566749439387324e-01/
data b/.456512608815524e-01/
!------------------------
data p0/ .333333333333333e+00/, p1/-.224696413112536e+00/, &
&p2/ .620886815375787e-02/
data q1/-.127408923933623e+01/, q2/ .354508718369557e+00/
!------------------------
if (x .lt. -0.39 .or. x .gt. 0.57) go to 100
if (x .lt. -0.18) go to 10
if (x .gt.  0.18) go to 20
!
!                 Argument reduction
!
u = x
up2 = u + 2.0
w1 = 0.0
go to 30
!
10 u = (x + 0.3)/0.7
up2 = u + 2.0
w1 = a - u*0.3
go to 30
!
20 t = 0.75*x
u = t - 0.25
up2 = t + 1.75
w1 = b + u/3.0
!
!                  Series expansion
!
30 r = u/up2
t = r*r
w = ((p2*t + p1)*t + p0)/((q2*t + q1)*t + 1.0)
rlog1 = r*(u - 2.0*t*w) + w1
return
!
!
100 w = (x + 0.5) + 0.5
rlog1 = x - alog(w)
return
end function rlog1

double precision function drlog (x)
implicit none
!-----------------------------------------------------------------------
!             Evaluation of the function x - 1 - LN(x)
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: a, b, r, t, u, up2, w, w1, z
double precision :: p0, p1, p2, p3, q1, q2, q3, q4
double precision :: c1, c2, c3, c4, c5
!-------------------------
!     a = drlog (0.7)
!     b = drlog (4/3)
!-------------------------
data a /.566749439387323789126387112411845d-01/
data b /.456512608815524058941143273395059d-01/
!-------------------------
data p0 / .7692307692307692307680d-01/, &
&p1 /-.1505958055914600184836d+00/, &
&p2 / .9302355725278521726994d-01/, &
&p3 /-.1787900022182327735804d-01/
data q1 /-.2824412139355646910683d+01/, &
&q2 / .2892424216041495392509d+01/, &
&q3 /-.1263560605948009364422d+01/, &
&q4 / .1966769435894561313526d+00/
!-------------------------
!     ci = 1/(2i + 1)
!-------------------------
data c1 /.333333333333333333333333333333333d+00/, &
&c2 /.200000000000000000000000000000000d+00/, &
&c3 /.142857142857142857142857142857143d+00/, &
&c4 /.111111111111111111111111111111111d+00/, &
&c5 /.909090909090909090909090909090909d-01/
!-------------------------
if (x .lt. 0.61d0 .or. x .gt. 1.57d0) go to 100
if (x .lt. 0.82d0) go to 10
if (x .gt. 1.18d0) go to 20
!
!                 Argument reduction
!
u = (x - 0.5d0) - 0.5d0
up2 = u + 2.d0
w1 = 0.d0
go to 30
!
10 u = (x - 0.7d0)/0.7d0
up2 = u + 2.d0
w1 = a - u*0.3d0
go to 30
!
20 t = 0.75d0*(x - 1.d0)
u = t - 0.25d0
up2 = t + 1.75d0
w1 = b + u/3.d0
!
!                  Series expansion
!
30 r = u/up2
t = r*r
!
!        z is a minimax approximation of the series
!
!               C6 + C7*r**2 + C8*r**4 + ...
!
!        For the interval (0.0, 0.375). The approx-
!        imation is accurate to within 1.6 units of
!        the 21-ST significant digit.
!
z = (((p3*t + p2)*t + p1)*t + p0)/ &
&((((q4*t + q3)*t + q2)*t + q1)*t + 1.d0)
!
w = ((((z*t + c5)*t + c4)*t + c3)*t + c2)*t + c1
drlog = r*(u - 2.d0*t*w) + w1
return
!
!
100 r = (x - 0.5d0) - 0.5d0
drlog = r - dlog(x)
return
end function drlog

double precision function drlog1 (x)
implicit none
!-----------------------------------------------------------------------
!             Evaluation of the function x - LN(1 + x)
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: a, b, r, t, u, up2, w, w1, z
double precision :: p0, p1, p2, p3, q1, q2, q3, q4
double precision :: c1, c2, c3, c4, c5
!-------------------------
!     a = drlog (0.7)
!     b = drlog (4/3)
!-------------------------
data a /.566749439387323789126387112411845d-01/
data b /.456512608815524058941143273395059d-01/
!-------------------------
data p0 / .7692307692307692307680d-01/, &
&p1 /-.1505958055914600184836d+00/, &
&p2 / .9302355725278521726994d-01/, &
&p3 /-.1787900022182327735804d-01/
data q1 /-.2824412139355646910683d+01/, &
&q2 / .2892424216041495392509d+01/, &
&q3 /-.1263560605948009364422d+01/, &
&q4 / .1966769435894561313526d+00/
!-------------------------
!     ci = 1/(2i + 1)
!-------------------------
data c1 /.333333333333333333333333333333333d+00/, &
&c2 /.200000000000000000000000000000000d+00/, &
&c3 /.142857142857142857142857142857143d+00/, &
&c4 /.111111111111111111111111111111111d+00/, &
&c5 /.909090909090909090909090909090909d-01/
!-------------------------
if (x .lt. -0.39d0 .or. x .gt. 0.57d0) go to 100
if (x .lt. -0.18d0) go to 10
if (x .gt.  0.18d0) go to 20
!
!                 Argument reduction
!
u = x
up2 = u + 2.d0
w1 = 0.d0
go to 30
!
10 u = (x + 0.3d0)/0.7d0
up2 = u + 2.d0
w1 = a - u*0.3d0
go to 30
!
20 t = 0.75d0*x
u = t - 0.25d0
up2 = t + 1.75d0
w1 = b + u/3.d0
!
!                  Series expansion
!
30 r = u/up2
t = r*r
!
!        z is a minimax approximation of the series
!
!               C6 + C7*r**2 + C8*r**4 + ...
!
!        For the interval (0.0, 0.375). The approx-
!        imation is accurate to within 1.6 units of
!        the 21-ST significant digit.
!
z = (((p3*t + p2)*t + p1)*t + p0)/ &
&((((q4*t + q3)*t + q2)*t + q1)*t + 1.d0)
!
w = ((((z*t + c5)*t + c4)*t + c3)*t + c2)*t + c1
drlog1 = r*(u - 2.d0*t*w) + w1
return
!
!
100 w = (x + 0.5d0) + 0.5d0
drlog1 = x - dlog(w)
return
end function drlog1

subroutine locpt (x0, y0, x, y, n, l, m)
implicit none
integer, intent(inout) :: l, m
integer, intent(in) :: n
real, intent(in) :: x0, y0
integer :: i, n0
real :: angle, eps, pi, pi2, sum, theta, theta1, thetai, tol, u, v
real :: spmpar
real, intent(in) :: x(n), y(n)
!-----------------------------------------------------------------------
!     Given a polygonal line connecting the vertices (x(i),y(i))
!     (i = 1,...,n) TAKEN IN THIS ORDER. IT IS ASSUMED THAT THE
!     POLYGONAL PATH IS A LOOP, WHERE (x(n),y(n)) = (x(1),y(1))
!     or there is an arc from (x(n),y(n)) to (x(1),y(1)).
!
!     (x0,y0) is an arbitrary point and l and m are variables.
!     l and m are assigned the following values ...
!
!        l = -1   IF (x0,y0) IS OUTSIDE THE POLYGONAL PATH
!        l =  0   IF (x0,y0) LIES ON THE POLYGONAL PATH
!        l =  1   IF (x0,y0) IS INSIDE THE POLYGONAL PATH
!
!     m = 0 IF (x0,y0) IS ON OR OUTSIDE THE PATH. IF (x0,y0)
!     is inside the path then m is the winding number of the
!     path around the point (x0,y0).
!
!-----------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0
!
               eps = spmpar(1)
!
!-----------------------------------------------------------------------
n0 = n
if (x(1) .eq. x(n) .and. y(1) .eq. y(n)) n0 = n - 1
pi = atan2(0.0, -1.0)
pi2 = 2.0*pi
tol = 4.0*eps*pi
l = -1
m = 0
!
u = x(1) - x0
v = y(1) - y0
if (u .eq. 0.0 .and. v .eq. 0.0) go to 20
if (n0 .lt. 2) return
theta1 = atan2(v, u)
!
sum = 0.0
theta = theta1
do i = 2,n0
   u = x(i) - x0
   v = y(i) - y0
   if (u .eq. 0.0 .and. v .eq. 0.0) go to 20
   thetai = atan2(v, u)
!
   angle = abs(thetai - theta)
   if (abs(angle - pi) .lt. tol) go to 20
   if (angle .gt. pi) angle = angle - pi2
   if (theta .gt. thetai) angle = -angle
   sum = sum + angle
   theta = thetai
end do
!
angle = abs(theta1 - theta)
if (abs(angle - pi) .lt. tol) go to 20
if (angle .gt. pi) angle = angle - pi2
if (theta .gt. theta1) angle = -angle
sum = sum + angle
!
!     sum = 2*pi*m WHERE m IS THE WINDING NUMBER
!
m = abs(sum)/pi2 + 0.2
if (m .eq. 0) return
l = 1
if (sum .lt. 0.0) m = -m
return
!
!     (x0, y0) is on the boundary of the path
!
20 l = 0
return
end subroutine locpt

subroutine pfind (a, b, x, y, n, u, v, m, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
integer, intent(out) :: num
integer :: i, ind, nm1
real :: d, diff, diff1, eps, h, hi, onem, onep, p, q, s, t, tmax, &
&tmin, tol, tol0
real :: spmpar
!-----------------------------------------------------------------------
!
!                 Intersection of a stright line
!                       and polygonal path
!
!-----------------------------------------------------------------------
real, intent(in) :: a(2), b(2), x(n), y(n)
real, intent(inout) :: u(m), v(m)
real :: k, ki
!----------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0 .
!
                eps = spmpar(1)
!
!----------------------
num = 0
if (n .lt. 2) go to 200
h = b(1) - a(1)
k = b(2) - a(2)
if (h .eq. 0.0 .and. k .eq. 0.0) go to 200
!
ierr = 0
nm1 = n - 1
tol = 4.0*eps
tol0 = 2.0*eps
onep = 1.0 + tol
onem = 0.5 + (0.5 - tol0)
!
ind = 0
do 100 i = 1, nm1
   hi = x(i + 1) - x(i)
   ki = y(i + 1) - y(i)
   if (hi .eq. 0.0 .and. ki .eq. 0.0) go to 100
   ind = 1
!
!           Check if the line from A to b and the i-TH
!                 line in the path are parallel
!
   s = hi*k
   t = h*ki
   d = s - t
   if (abs(d) .le. tol*amax1(abs(s),abs(t))) go to 40
!-----------------------------------------------------------------------
!                   The lines are not parallel
!-----------------------------------------------------------------------
   p = x(i) - a(1)
   q = y(i) - a(2)
   s = hi*q
   t = ki*p
   diff = s - t
   if (abs(diff) .le. tol*amax1(abs(s),abs(t))) diff = 0.0
   s = h*q
   t = k*p
   diff1 = s - t
   if (abs(diff1) .le. tol*amax1(abs(s),abs(t))) diff1 = 0.0
!
   s = diff/d
   t = diff1/d
   if (s .lt. 0.0 .or. s .gt. onep) go to 100
   if (t .lt. 0.0 .or. t .gt. onep) go to 100
   if (num .gt. 0 .and. t .eq. 0.0) go to 100
   if (s .gt. 0.0) go to 20
!
!                   Point A is on the i-TH line
!
10 num = num + 1
   if (num .gt. m) go to 210
   u(num) = a(1)
   v(num) = a(2)
   go to 100
!
!                   Point b is on the i-TH line
!
20 if (s .lt. onem) go to 30
21 num = num + 1
   if (num .gt. m) go to 210
   u(num) = b(1)
   v(num) = b(2)
   go to 100
!
!              The interior of the line from A to b
!                 intersects with the i-TH line
!
30 num = num + 1
   if (num .gt. m) go to 210
   u(num) = a(1) + s*h
   v(num) = a(2) + s*k
   go to 100
!-----------------------------------------------------------------------
!                     The lines are parallel
!-----------------------------------------------------------------------
40 if (abs(hi) .gt. abs(ki)) go to 50
!
      d = a(2) - y(i)
      if (abs(d) .le. tol0*amax1(abs(a(2)),abs(y(i)))) d = 0.0
      s = d/ki
!
      p = x(i) + s*hi
      if (abs(a(1) - p) .gt. tol*amax1(abs(a(1)),abs(p))) &
&go to 100
!
      d = b(2) - y(i)
      if (abs(d) .le. tol0*amax1(abs(b(2)),abs(y(i)))) d = 0.0
      t = d/ki
      go to 60
!
50 d = a(1) - x(i)
   if (abs(d) .le. tol0*amax1(abs(a(1)),abs(x(i)))) d = 0.0
   s = d/hi
!
   p = y(i) + s*ki
   if (abs(p - a(2)) .gt. tol*amax1(abs(p),abs(a(2)))) &
&go to 100
!
   d = b(1) - x(i)
   if (abs(d) .le. tol0*amax1(abs(b(1)),abs(x(i)))) d = 0.0
   t = d/hi
!
!              The 2 lines are portions of the same
!                     straight infinite line
!
60 if (s .gt. 0.0 .and. s .lt. onem) go to 220
   if (t .gt. 0.0 .and. t .lt. onem) go to 220
   tmin = amin1(s,t)
   tmax = amax1(s,t)
   if (tmax .le. 0.0) go to 70
   if (tmin .ge. onem) go to 80
   go to 220
!
70 if (tmax .lt. 0.0) go to 100
   if (num .gt. 0) go to 100
   if (tmax .eq. s) go to 10
   go to 21
!
80 if (tmin .gt. 1.0) go to 100
   if (tmin .eq. s) go to 10
   go to 21
!
100 continue
if (ind .eq. 0) go to 200
!
if (num .lt. 2) return
if (u(num) .eq. x(1) .and. v(num) .eq. y(1)) &
&num = num - 1
return
!
!                          Error return
!
200 ierr = 1
return
210 ierr = 2
num = num - 1
return
220 ierr = -i
return
end subroutine pfind

subroutine hull (x, y, m, bx, by, k, vx, vy, n)
implicit none
integer, intent(inout) :: k
integer, intent(in) :: m
integer, intent(inout) :: n
integer :: i, ii, isav, j, j0, k0, kp1, ksav, l, lbeg, lmax, lmin, &
&lsav, mm1, mp1, nn
real :: dx, dx0, dy, dy0, eps, h, onep, r, x1, xm, xmax, xmin, &
&ymax, ymin
real :: spmpar
!-----------------------------------------------------------------------
!           Obtaining the convex hull for a finite planar set
!-----------------------------------------------------------------------
real, intent(inout) :: x(m), y(m)
real, intent(inout) :: bx(*), by(*), vx(*), vy(*)
logical :: ibeg
!---------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0.
!
                  eps = spmpar(1)
!
!---------------------
mp1 = m + 1
onep = 1.0 + 4.0*eps
!
!                       Reorder x and y
!
call rrsort (y, x, m)
ymin = y(1)
ymax = y(m)
if (ymin .eq. ymax) go to 500
!
l = 1
10 l = l + 1
   if (y(l) .eq. ymin) go to 10
lmin = l
l = l - 1
call rrsort (x, y, l)
x1 = x(1)
!
i = m
20 i = i - 1
   if (y(i) .eq. ymax) go to 20
lmax = i
i = i + 1
call rrsort (x(i), y(i), m - lmax)
xm = x(m)
!
!                      Find xmin and xmax
!
xmin = x1
xmax = x(l)
do 31 i = lmin,m
   if (x(i) .gt. xmin) go to 30
      xmin = x(i)
      go to 31
30 if (x(i) .gt. xmax) xmax = x(i)
31 continue
!
!                   Going along the ymin axis
!
k = l
do i = 1,l
   bx(i) = x(i)
   by(i) = y(i)
end do
!
n = 1
vx(1) = x(1)
vy(1) = y(1)
if (l .eq. 1) go to 100
n = 2
vx(2) = x(l)
vy(2) = y(l)
!
!           Going from the ymin axis to the xmax axis
!
100 h = xmax - bx(k)
if (h .eq. 0.0) go to 150
k0 = k
ibeg = .true.
!
110 continue
   l = l + 1
   if (l .gt. lmax) l = m
   h = x(l) - bx(k)
   if (h .le. 0.0) go to 110
   dx = x(l) - bx(k0)
   dy = y(l) - by(k0)
   if (ibeg) go to 120
   r = (dx0/dx)*dy
   if (r .gt. onep*dy0) go to 130
   if (dy0 .gt. onep*r) go to 120
   if (dy0 .eq. 0.0 .and. dy .gt. 0.0) go to 140
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
if (h .gt. 0.0) go to 110
!
140 l = lsav
n = n + 1
vx(n) = bx(k)
vy(n) = by(k)
go to 100
!
!                   Going along the xmax axis
!
150 if (l .eq. m) go to 250
ksav = k
i = l
151 if (i .eq. lmax) go to 160
   i = i + 1
   if (x(i) .ne. xmax) go to 151
   l = i
   k = k + 1
   bx(k) = x(i)
   by(k) = y(i)
   go to 151
!
160 xmax = x(l)
h = xmax - xm
if (h .le. 0.0) go to 170
if (l .ne. lmax) go to 200
   if (k .eq. ksav) go to 170
   n = n + 1
   vx(n) = bx(k)
   vy(n) = by(k)
!
170 l = m
k = k + 1
bx(k) = xm
by(k) = y(m)
n = n + 1
vx(n) = xm
vy(n) = y(m)
go to 250
!
!           Going from the ymax axis to the xmax axis
!        (here we are traversing the boundary clockwise)
!
200 j = mp1
nn = mp1
bx(mp1) = xm
vx(mp1) = xm
by(mp1) = y(m)
vy(mp1) = y(m)
i = lmax + 1
201 j0 = j
ibeg = .true.
!
210 continue
   i = i - 1
   h = x(i) - bx(j)
   if (h .le. 0.0) go to 210
   dx = x(i) - bx(j0)
   dy = abs(y(i) - by(j0))
   if (ibeg) go to 220
   r = (dx0/dx)*dy
   if (r .gt. onep*dy0) go to 230
   if (dy0 .gt. onep*r) go to 220
   if (dy0 .eq. 0.0 .and. dy .gt. 0.0) go to 235
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
if (h .gt. 0.0) go to 210
!
235 i = isav
nn = nn - 1
vx(nn) = bx(j)
vy(nn) = by(j)
h = xmax - bx(j)
if (h .gt. 0.0) go to 201
!
!          Update bx,by and vx,vy so that the boundary
!           is again being traversed counterclockwise
!
if (i .eq. l .and. k .eq. ksav) nn = nn + 1
do ii = nn,mp1
   n = n + 1
   vx(n) = vx(ii)
   vy(n) = vy(ii)
end do
!
if (i .eq. l) j = j + 1
do ii = j,mp1
   k = k + 1
   bx(k) = bx(ii)
   by(k) = by(ii)
end do
l = m
!
!                   Going along the ymax axis
!
250 lbeg = lmax + 1
if (lbeg .eq. m) go to 260
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
!
260 if (k .eq. m) go to 370
h = xmax - bx(k)
if (h .gt. 0.0) go to 300
h = bx(k) - xmin
if (h .gt. 0.0) go to 301
go to 370
!
!           Going from the ymax axis to the xmin axis
!
300 h = bx(k) - xmin
if (h .eq. 0.0) go to 350
301 k0 = k
ibeg = .true.
!
310 continue
   l = l - 1
   if (l .lt. lmin) l = 1
   h = x(l) - bx(k)
   if (h .ge. 0.0) go to 310
   dx = abs(x(l) - bx(k0))
   dy = abs(y(l) - by(k0))
   if (ibeg) go to 320
   r = (dx0/dx)*dy
   if (r .gt. onep*dy0) go to 330
   if (dy0 .gt. onep*r) go to 320
   if (dy0 .eq. 0.0 .and. dy .gt. 0.0) go to 340
      if (k .eq. mp1) go to 330
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
if (h .gt. 0.0) go to 310
!
340 l = lsav
n = n + 1
vx(n) = bx(k)
vy(n) = by(k)
if (l .eq. 1) return
if (k .eq. m) go to 370
go to 300
!
!                   Going along the xmin axis
!
350 ksav = k
i = l
351 if (i .eq. lmin) go to 360
   i = i - 1
   if (x(i) .ne. xmin) go to 351
   l = i
   k = k + 1
   bx(k) = x(i)
   by(k) = y(i)
   go to 351
!
360 xmin = x(l)
h = x1 - xmin
if (h .le. 0.0) go to 370
if (k .eq. ksav) go to 365
   n = n + 1
   vx(n) = bx(k)
   vy(n) = by(k)
365 if (l .ne. lmin) go to 400
!
370 k = k + 1
bx(k) = x1
by(k) = y(1)
n = n + 1
vx(n) = x1
vy(n) = y(1)
return
!
!           Going from the ymin axis to the xmin axis
!        (here we are traversing the boundary clockwise)
!
400 if (k .eq. m) go to 370
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
!
410 continue
   i = i + 1
   h = x(i) - bx(j)
   if (h .ge. 0.0) go to 410
   dx = abs(x(i) - bx(j0))
   dy = y(i) - by(j0)
   if (ibeg) go to 420
   r = (dx0/dx)*dy
   if (r .gt. onep*dy0) go to 430
   if (dy0 .gt. onep*r) go to 420
   if (dy0 .eq. 0.0 .and. dy .gt. 0.0) go to 440
      if (j .eq. kp1) go to 430
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
if (h .gt. 0.0) go to 410
!
440 i = isav
nn = nn - 1
vx(nn) = bx(j)
vy(nn) = by(j)
if (j .eq. kp1) go to 450
h = bx(j) - xmin
if (h .gt. 0.0) go to 401
!
!          Update bx,by and vx,vy so that the boundary
!           is again being traversed counterclockwise
!
450 if (nn .eq. n) go to 470
if (i .eq. l) nn = nn + 1
do ii = nn,mp1
   n = n + 1
   vx(n) = vx(ii)
   vy(n) = vy(ii)
end do
!
if (j .eq. k) go to 471
if (i .eq. l) j = j + 1
do ii = j,mp1
   k = k + 1
   bx(k) = bx(ii)
   by(k) = by(ii)
end do
return
!
470 n = mp1
471 k = mp1
return
!
!                     CASE WHEN YMIN = YMAX
!
500 call rrsort (x, y, m)
do i = 1,m
   bx(i) = x(i)
   by(i) = y(i)
end do
k = mp1
bx(k) = bx(1)
by(k) = by(1)
!
n = 3
vx(1) = x(1)
vx(2) = x(m)
vx(3) = x(1)
vy(1) = y(1)
vy(2) = y(m)
vy(3) = y(1)
return
end subroutine hull

real function parea(x, y, nb)
implicit none
integer :: i, n, nm1
real :: a
integer, intent(in) :: nb
real, intent(in) :: x(nb), y(nb)
!
!*****************************************************************
!
!   Given a sequence of nb points (x(i),y(i)). parea computes
! the area bounded by the closed polygonal curve which passes
! through the points in the order that they are indexed. The
! final point of the curve is assumed to be the first point
! given. Therefore, it need not be listed at the end of x and
! y. The curve is not required to be simple.
!
!*****************************************************************
!
n = nb
if (x(1) .eq. x(n) .and. y(1) .eq. y(n)) n = n - 1
if (n - 3) 10, 20, 30
!
10 parea = 0.0
return
!
20 parea= 0.5*((x(2) - x(1))*(y(3) - y(1)) &
&- (x(3) - x(1))*(y(2) - y(1)))
return
!
30 nm1 = n - 1
a = x(1)*(y(2) - y(n)) + x(n)*(y(1) - y(nm1))
do 31 i = 2, nm1
31 a = a + x(i)*(y(i+1) - y(i-1))
parea = 0.5*a
return
end function parea

subroutine hc (ind, m, n, pr, ar, nb, s, iwk, num)
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: m, n
integer, intent(inout) :: nb
integer, intent(in) :: num
integer :: i, ii, np1
!
! Subroutine to find one or more hamiltonian circuits in A
! DIRECTED GRAPH OF  n  VERTICES ( n .GT. 1 ) REPRESENTED
! by the integers  1, 2, ..., n  and  m  arcs.
!
! Input ...
!
! ind   = 0  ON AN INITIAL CALL TO HC.
!       = 1  OBTAIN ANOTHER HAMILTONIAN CIRCUIT.
!       = 2  MORE BACK TRACKS ARE BEING PERMITTED.
!       = 3  RESTORE THE ORGINAL ARRAY ar.
! m     = NUMBER OF ARCS.
! n     = NUMBER OF VERTICES.
! pr(i) = SUM OF THE OUT-DEGREES OF VERTICES  1, ..., i-1
!         (pr(1) = 0 ,  pr(n+1) = m).
! ar    = ADJACENCY LIST. THE ELEMENTS FROM  ar(pr(i)+1) TO
!         ar(pr(i+1))  are a record containing,in any order,
!         all the vertices  J  such that arc  (i,J)  exists.
!         The graph should not contain arcs starting and
!         ending at the same vertex.
! nb    = UPPER BOUND ON THE NUMBER OF BACK TRACKS TO BE
!         PERFORMED. (nb = -1 IF NO LIMIT IS TO BE PLACED
!         on the number of back tracks taken.)
! num   = DIMENSION OF THE WORK SPACE iwk. IT IS ASSUMED THAT
!         num .GE. m + 8*n + 20.
!
! Output ...
!
! ind   = 1   A HAMILTONIAN CIRCUIT WAS FOUND. TO FIND ANOTHER
!             circuit, reset nb and recall the routine.
!             The array ar has been modified. If one does not
!             WISH TO OBTAIN ANOTHER CIRCUIT, SET ind = 3 AND
!             recall the routine. This will restore ar.
!       = 2   THE MAXIMUM NUMBER OF BACK TRACKS WERE PERFORMED.
!             To continue, reset nb and recall the routine.
!             The array ar has been modified. If one does not
!             WISH TO CONTINUE, SET ind = 3 AND RECALL THE
!             routine. This will restore ar.
!       = 4   NO CIRCUITS WERE FOUND. THE ARRAY  ar  HAS BEEN
!             restored (see the remark below) and the procedure
!             is finished.
!       = -1  (INPUT ERROR) ind .LT. 0  OR ind .GT. 3 ON INPUT.
!       = -2  (INPUT ERROR) IND WAS MODIFIED. RESET IND TO ITS
!              previous output value and rerun the code.
!       = -3  (INPUT ERROR) THE INPUT SETTING ind = 3 CAN BE
!              used only when the previous output value for
!              ind was 1 or 2. If the previous output value
!              for ind was 4, then the array ar has already
!              been restored and there is nothing to be done.
!       = -4  (INPUT ERROR) num .LT. m + 8*n + 20.
!       = -5  (INPUT ERROR) pr(1) .NE. 0  OR  pr(n+1) .NE. m.
!       = -6  (INPUT ERROR) pr(i) .GT. pr(i+1) FOR SOME i.
! nb    = NUMBER OF BACK TRACKS PERFORMED.
! s(i)  = i-TH  VERTEX IN THE HAMILTONIAN CIRCUIT FOUND.
!
! Work space ... iwk
!
! Remark. In ar, the order of the arcs in each record may be
! altered by the routine.
!
!     integer pr(n + 1), ar(m), s(n), iwk(m + 8*n + 20)
!
integer, intent(in) :: pr(*)
integer, intent(inout) :: ar(m), s(n), iwk(num)
integer :: s0, pc, ac, vr, vc, p, subr, rbus, tor
!
np1 = n + 1
if (ind .lt. 0 .or. ind .gt. 3) go to 20
if (num .lt. m + 8*n + 20) go to 30
if (pr(1) .ne. 0 .or. pr(np1) .ne. m) go to 40
!
s0 = 20
pc = s0 + n
ac = pc + np1
vr = ac + m
vc = vr + n
p  = vc + n
subr = p + n
rbus = subr + n
tor  = rbus + n
!
call hc1 (ind, m, n, pr, ar, nb, iwk(s0), np1, iwk(pc), &
&iwk(ac), iwk(vr), iwk(vc), iwk(p), iwk(subr), &
&iwk(rbus), iwk(tor), iwk(1), iwk(2), iwk(3))
if (ind .ne. 1) return
!
ii = s0
do i = 1,n
   s(i) = iwk(ii)
   ii = ii + 1
end do
return
!
!                   Error return
!
20 ind = -1
return
30 ind = -4
return
40 ind = -5
return
end subroutine hc

subroutine hc1 (ind, m, n, pr, ar, nb, s, np1, pc, ac, vr, &
&vc, p, subr, rbus, tor, jr, k, ind0)
implicit none
integer, intent(inout) :: ind, ind0, jr, k
integer, intent(in) :: m, n
integer, intent(inout) :: nb
integer, intent(in) :: np1
integer :: i, iend, iff, ipi, it1, it2, j, j1, j2, ja, jj, jl, &
&jsubr, k1, k2, l, l1, l2, ll, ll1, ll2, maxe, minu, mp1, nbo, np
real :: dens, score
!
! Meaning of the work arrays ...
!
! pc(i)   = SUM OF THE IN-DEGREES OF VERTICES  1, ..., i-1
!           ( pc(1) = 0 ).
! ac      = ADJACENCY LIST (BACKWARD). THE ELEMENTS FROM
!           ac(pc(i)+1)  to  ac(pc(i+1))  contain, in any
!           order, all the vertices  j  such that arc  (j,i)
!           exists.
! When an arc is removed from the graph at the  k-TH  level
! of the branch-decision tree, the corresponding elements
! ar(Q)  and  ac(T)  are set to  - (k*(n+1) + ar(Q))  and
! to  - (k*(n+1) + ac(T)) , respectively.
! vr(i)   = CURRENT OUT-DEGREE OF VERTEX i .
! VC(i)   = CURRENT IN-DEGREE OF VERTEX i .
! SUBR(i) = - (k*(n+1) + j)  IF ARC  (i,j)  WAS IMPLIED AT
!           the  k-TH  level of the branch-decision tree.
!         = 0  OTHERWISE.
! RBUS(i) = - j  IF ARC  (j,i)  IS CURRENTLY IMPLIED.
!         = 0  OTHERWISE.
! TOR(k)  = Q*(m+1) + T  IF THE ARC GOING FROM  s(k)  TO THE
!           root, corresponding to  ar(Q)  and to  ac(T),
!           was removed from the graph at the  k-TH  level
!           of the branch-decision tree.
!         = 0  OTHERWISE.
! P(i)    = POINTER FOR THE FORWARD STEP. THE NEXT ARC
!           starting from  i  to be considered in the
!           branch-decision tree is  (i,ar(pr(i)+P(i)).
!
! Meaning of the main simple variables ...
!
! jr   = ROOT. THE HAMILTONIAN CIRCUITS ARE DETERMINED AS
!        paths starting and ending at  jr .
! k    = CURRENT LEVEL OF THE BRANCH-DECISION TREE.
! ind0 = VALUE OF IND WHEN HC WAS PREVIOUSLY CALLED AND
!        there were no input errors.
!
integer, intent(in) :: pr(np1)
integer, intent(inout) :: pc(np1), ar(m), ac(m), s(n), vr(n), &
&vc(n), p(n), subr(n), rbus(n), tor(n)
!
nbo = nb
nb = 0
mp1 = m + 1
if (ind .ne. 0) go to 500
!
! s T E P   0   (INITIALIZE).
!
do i=1,n
  vc(i) = 0
  subr(i) = 0
  rbus(i) = 0
  p(i) = 1
end do
do i=1,n
  j1 = pr(i) + 1
  j2 = pr(i+1)
  vr(i) = j2 - j1 + 1
  if (vr(i) .eq. 0) go to 440
  if (vr(i) .lt. 0) go to 620
  do j=j1,j2
    ja = ar(j)
    vc(ja) = vc(ja) + 1
  end do
end do
pc(1) = 0
do i=1,n
  if (vc(i) .eq. 0) go to 440
  pc(i+1) = pc(i) + vc(i)
  vc(i) = 0
end do
do i=1,n
  j1 = pr(i) + 1
  j2 = pr(i+1)
  do j=j1,j2
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
do 100 i = 2,n
  if (vc(i)-maxe) 100, 70, 80
70 if (vr(i).ge.minu) go to 100
  go to 90
80 maxe = vc(i)
90 minu = vr(i)
  jr = i
100 continue
k1 = -np1
k = 1
s(1) = jr
!
! s T E P   1   (SEARCH FOR IMPLIED ARCS).
!
110 do j=1,n
  if (vr(j).eq.1) go to 130
  if (vc(j).eq.1) go to 170
end do
! No further arc can be implied.
go to 220
! ARC  (j,jl)  IS IMPLIED BECAUSE  vr(j) = 1 .
130 l1 = pr(j) + 1
l2 = pr(j+1)
do l=l1,l2
  if (ar(l).gt.0) go to 150
end do
150 jl = ar(l)
! Find the starting vertex  it1  and the ending vertex  it2
! of the largest path of implied arcs containing  (j,jl) .
call ipath(j, jl, subr, rbus, ar, pr, s, n, np, it1, it2, k, jr, &
&m, np1)
if (np.eq.0) go to 160
if (np.eq.(-1)) go to 340
! Subroutine ipath found a hamiltonian circuit.
k = k + 1
go to 320
160 subr(j) = k1 - jl
rbus(jl) = j
! Remove from the graph all arcs terminating at  jl .
call iupd(j, jl, l, ac, ar, pc, pr, vc, vr, k1, n, m, np1)
if (j.eq.0) go to 340
go to 210
! ARC  (jl,j)  IS IMPLIED BECAUSE  VC(j) = 1 .
170 l1 = pc(j) + 1
l2 = pc(j+1)
do l=l1,l2
  if (ac(l).gt.0) go to 190
end do
190 jl = ac(l)
! Find the starting vertex  it1  and the ending vertex  it2
! of the largest path of implied arcs containing  (jl,j) .
call ipath(jl, j, subr, rbus, ar, pr, s, n, np, it1, it2, k, jr, &
&m, np1)
if (np.eq.0) go to 200
if (np.eq.(-1)) go to 340
! Subroutine ipath found a hamiltonian circuit.
i = s(k)
k = k + 1
go to 320
200 subr(jl) = k1 - j
rbus(j) = jl
! Remove from the graph all arcs emanating from  jl .
call iupd(j, jl, l, ar, ac, pr, pc, vr, vc, k1, n, m, np1)
if (j.eq.0) go to 340
! If arc  (it2,it1)  is in the graph, remove it.
210 call rarc(it2, it1, ar, ac, pr, pc, vr, vc, k1, jj, ll, n, m, np1)
if (jj.eq.(-1)) go to 340
go to 110
!
! s T E P   2   (ADD IMPLIED ARCS TO s).
!
220 i = s(k)
if (subr(i).eq.0) go to 230
jsubr = -subr(i) + (subr(i)/np1)*np1
if (jsubr.eq.jr) go to 340
k = k + 1
s(k) = jsubr
if (k.ne.n) go to 220
if (subr(jsubr).lt.0) go to 320
go to 340
!
! s T E P   3   (BRANCH).
!
230 l1 = pr(i) + p(i)
l2 = pr(i+1)
if (l1.gt.l2) go to 340
! Find the next arc  (i,jl)  to be added to  s .
dens = n**3
j1 = 0
j2 = 0
do 310 j = l1,l2
  jl = ar(j)
  if (jl.lt.0) go to 310
  if (vr(jl).gt.0) go to 260
  if (subr(jl).eq.0) go to 310
  if (jl.eq.jr) go to 310
  iend = jl
240 iend = -subr(iend) + (subr(iend)/np1)*np1
  if (subr(iend).ne.0) go to 240
  if (vc(jl).lt.vr(iend)) go to 250
  score = vr(iend)*n + vc(jl)
  go to 280
250 score = vc(jl)*n + vr(iend)
  go to 280
260 if (vc(jl).lt.vr(jl)) go to 270
  score = vr(jl)*n + vc(jl)
  go to 280
270 score = vc(jl)*n + vr(jl)
280 if (dens.le.score) go to 290
  dens = score
  ipi = j
290 if (j1.eq.0) go to 300
  if (j2.eq.0) j2 = j
  go to 310
300 j1 = j
310 continue
if (j1.eq.0) go to 340
jl = ar(ipi)
ar(ipi) = ar(j1)
ar(j1) = jl
if (j2.eq.0) j2 = pr(i+1) + 1
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
if (jj.eq.0) go to 110
if (jj.eq.(-1)) go to 340
tor(k) = jj*mp1 + ll
go to 110
!
! s T E P   4   (HAMILTONIAN CIRCUIT FOUND).
!
320 ind = 1
ind0 = 1
k = k - 1
return
!
! s T E P   5   (BACKTRACK).
!
340 if (k .le. 1) go to 430
ja = s(k)
p(ja) = 1
ja = s(k-1)
if (subr(ja) .eq. 0) go to 350
! Backtracking for an implied arc.
k = k - 1
go to 340
350 if (nb .eq. nbo) go to 450
nb = nb + 1
k1 = -k*np1
k2 = -(k+1)*np1
i = s(k-1)
! Backtracking for the arcs implied at level  k .
iff = 0
do 360 j = 1,n
  if (subr(j).gt.k1) go to 360
  if (subr(j).lt.k2) go to 360
  ja = k1 - subr(j)
  rbus(ja) = 0
  subr(j) = 0
  iff = 1
360 continue
if (iff.eq.1) go to 370
! No arc was implied at level  k .
call bupd(ar, ac, pr, pc, vr, vc, i, k1, k2, n, m, np1)
call bupd(ac, ar, pc, pr, vc, vr, s(k), k1, k2, n, m, np1)
if (tor(k).eq.0) go to 420
j1 = tor(k)/mp1
j2 = tor(k) - j1*mp1
ar(j1) = jr
ja = s(k)
vr(ja) = vr(ja) + 1
ac(j2) = s(k)
vc(jr) = vc(jr) + 1
go to 420
! At least one arc was implied at level  k .
370 do j=1,n
  l1 = pr(j) + 1
  l2 = pr(j+1)
  do 400 l = l1,l2
    jl = ar(l)
    if (jl.gt.k1) go to 400
    if (jl.lt.k2) go to 400
    jl = k1 - jl
    ar(l) = jl
    vr(j) = vr(j) + 1
    ll1 = pc(jl) + 1
    ll2 = pc(jl+1)
    do ll=ll1,ll2
      if (k1-ac(ll).eq.j) go to 390
    end do
390 ac(ll) = j
    vc(jl) = vc(jl) + 1
400 continue
end do
420 k = k - 1
go to 230
!
! Restore the original vector  ar
!
430 do 431 j = 1,m
  if (ar(j) .gt. 0) go to 431
  ar(j) = -ar(j) + (ar(j)/np1)*np1
431 continue
!
! The algorithm is finished
!
440 ind = 4
ind0 = 4
return
!
! The maximum number of back tracks were performed
!
450 ind = 2
ind0 = 2
return
!
! CHECK IND WHEN ind = 1, 2, OR 3
!
500 if (ind .ne. 3) go to 510
   if (ind0 .eq. 1 .or. ind0 .eq. 2) go to 430
   go to 610
510 if (ind .ne. ind0) go to 600
if (ind .eq. 1) go to 340
go to 350
!
! Error return
!
600 ind = -2
return
610 ind = -3
return
620 ind = -6
return
end subroutine hc1

subroutine ipath (i, j, subr, rbus, ar, pr, s, n, np, i1, i2, k, &
&jr, m, np1)
implicit none
integer, intent(in) :: i
integer, intent(out) :: i1
integer, intent(inout) :: i2
integer, intent(in) :: j, jr, k, m, n
integer, intent(out) :: np
integer, intent(in) :: np1
integer :: ja, k1, l, l1, l2
!
! Subroutine to find the starting vertex  i1  and the ending
! vertex  i2  of the largest path of implied arcs containing
! ARC  (i,j) .
!
! Meaning of the output parameter  np ...
!
! np =  0  IF THE PATH CONTAINS  l .LT. n  VERTICES.
!    =  1  IF THE PATH CONTAINS  n  VERTICES AND ARC (i2,i1)
!          exists (the hamiltonian circuit is stored in  s )
!    = -1  IF THE PATH CONTAINS  n  VERTICES BUT ARC (i2,i1)
!          does not exist.
!
integer, intent(in) :: subr(n)
integer, intent(inout) :: rbus(n)
integer, intent(in) :: ar(m), pr(np1)
integer, intent(inout) :: s(n)
!
np = 0
l = 1
i1 = i
10 if (rbus(i1).eq.0) go to 20
i1 = rbus(i1)
l = l + 1
go to 10
20 i2 = j
l = l + 1
30 if (subr(i2).eq.0) go to 40
i2 = -subr(i2) + (subr(i2)/np1)*np1
l = l + 1
go to 30
40 continue
if (l.lt.n) return
! The path contains  n  vertices.
k1 = -k*np1
l1 = pr(i2) + 1
l2 = pr(i2+1)
do 60 l = l1,l2
  if (ar(l).lt.0) go to 50
  if (ar(l).eq.i1) go to 70
  go to 60
50 if (k1-ar(l).eq.i1) go to 70
60 continue
! No hamiltonian circuit can be determined.
np = -1
return
! A hamiltonian circuit exists. Store it in  s .
70 np = 1
rbus(j) = i
rbus(i1) = i2
s(n) = rbus(jr)
l = n - 1
80 if (l.eq.k) go to 90
ja = s(l+1)
s(l) = rbus(ja)
l = l - 1
go to 80
90 rbus(i1) = 0
rbus(j) = 0
return
end subroutine ipath

subroutine fupd (a1, a2, p1, p2, v1, v2, i1, k1, n, m, np1)
implicit none
integer, intent(in) :: i1, k1, m, n, np1
integer :: ia, j, j1, j2, l, l1, l2
!
! Forward step updating
!
integer, intent(inout) :: a1(m), a2(m)
integer, intent(in) :: p1(np1), p2(np1)
integer, intent(inout) :: v1(n), v2(n)
!
j1 = p1(i1) + 1
j2 = p1(i1+1)
do 30 j = j1,j2
  if (a1(j).lt.0) go to 30
  ia = a1(j)
  l1 = p2(ia) + 1
  l2 = p2(ia+1)
  do l=l1,l2
    if (a2(l).eq.i1) go to 20
  end do
20 v2(ia) = v2(ia) - 1
  a2(l) = k1 - a2(l)
  a1(j) = k1 - ia
30 continue
v1(i1) = 0
return
end subroutine fupd

subroutine bupd (a1, a2, p1, p2, v1, v2, ii, k1, k2, n, m, np1)
implicit none
integer, intent(in) :: ii, k1, k2, m, n, np1
integer :: ia, l, l1, l2, ll, ll1, ll2
!
! Backtracking step updating
!
integer, intent(inout) :: a1(m), a2(m)
integer, intent(in) :: p1(np1), p2(np1)
integer, intent(inout) :: v1(n), v2(n)
!
l1 = p1(ii) + 1
l2 = p1(ii+1)
do 30 l = l1,l2
  if (a1(l).gt.k1) go to 30
  if (a1(l).lt.k2) go to 30
  ia = k1 - a1(l)
  a1(l) = ia
  v1(ii) = v1(ii) + 1
  ll1 = p2(ia) + 1
  ll2 = p2(ia+1)
  do ll=ll1,ll2
    if (k1-a2(ll).eq.ii) go to 20
  end do
20 a2(ll) = ii
  v2(ia) = v2(ia) + 1
30 continue
return
end subroutine bupd

subroutine iupd(ia, ib, l, a1, a2, p1, p2, v1, v2, k1, n, m, np1)
implicit none
integer, intent(inout) :: ia
integer, intent(in) :: ib, k1, l, m, n, np1
integer :: iarc, j1, j2, jj, m1, m2, mm
!
! Updating for implied arc
!
integer, intent(inout) :: a1(m), a2(m)
integer, intent(in) :: p1(np1), p2(np1)
integer, intent(inout) :: v1(n), v2(n)
!
m1 = p1(ib) + 1
m2 = p1(ib+1)
do 40 mm = m1,m2
  iarc = a1(mm)
  if (iarc.lt.0) go to 40
  if (v2(iarc).ne.1) go to 10
  if (iarc.ne.ia) go to 50
  jj = l
  go to 30
10 j1 = p2(iarc) + 1
  j2 = p2(iarc+1)
  do jj=j1,j2
    if (a2(jj).eq.ib) go to 30
  end do
30 a2(jj) = k1 - a2(jj)
  v2(iarc) = v2(iarc) - 1
  a1(mm) = k1 - iarc
  v1(ib) = v1(ib) - 1
40 continue
return
50 ia = 0
return
end subroutine iupd

subroutine rarc(ia, ib, ar, ac, pr, pc, vr, vc, k1, jj, ll, n, m, &
&np1)
implicit none
integer, intent(in) :: ia, ib
integer, intent(inout) :: jj
integer, intent(in) :: k1
integer, intent(inout) :: ll
integer, intent(in) :: m, n, np1
integer :: j1, j2, l1, l2
!
! Subroutine to remove arc  (ia,ib)  from the graph.
!
! Meaning of the output parameters  jj  and  ll ...
!
! jj =  LOCATION OF THE ELEMENT OF  ar  CORRESPONDING TO THE
!       removed arc.
!    =  0  IF ARC  (ia,ib)  IS NOT IN THE GRAPH.
!    = -1  IF, AFTER THE REMOVAL OF ARC  (ia,ib) , THE GRAPH
!          would admit no hamiltonian circuit.
! ll =  LOCATION OF THE ELEMENT OF  ac  CORRESPONDING TO THE
!       REMOVED ARC (DEFINED ONLY IF  jj .GT. 0 ).
!
integer, intent(inout) :: ar(m), ac(m)
integer, intent(in) :: pr(np1), pc(np1)
integer, intent(inout) :: vr(n), vc(n)
!
j1 = pr(ia) + 1
j2 = pr(ia+1)
do 20 jj = j1,j2
  if (ar(jj).lt.0) go to 20
  if (ar(jj).ne.ib) go to 20
  l1 = pc(ib) + 1
  l2 = pc(ib+1)
  do ll=l1,l2
    if (ac(ll).eq.ia) go to 30
  end do
20 continue
! Arc  (ia,ib)  is not in the graph.
jj = 0
return
30 if (vr(ia).eq.1) go to 40
if (vc(ib).eq.1) go to 40
ar(jj) = k1 - ib
vr(ia) = vr(ia) - 1
ac(ll) = k1 - ia
vc(ib) = vc(ib) - 1
return
! Arc  (ia,ib)  cannot be removed from the graph.
40 jj = -1
return
end subroutine rarc

subroutine cerf (mo, z, w)
implicit none
integer, intent(in) :: mo
integer :: i
real :: c, c2, dm, pm, qm, r, sn, ss, x, y
!-----------------------------------------------------------------------
!
!               Computation of the complex error function
!
!                           ----------------
!
!                        w = erf(z)   IF mo = 0
!                        w = erfc(z)  otherwise
!
!-----------------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: w
real :: cd(18), ce(18), ef(2), qf(2), sm(2), sz(2), tm(2), ts(2)
!------------------------
!     c = 1/sqrt(pi)
!------------------------
data c /.564189583547756/
!------------------------
data cd(1) /0.00000000000000e00/,  cd(2) /2.08605856013476e-2/, &
&cd(3) /8.29806940495687e-2/,  cd(4) /1.85421653326079e-1/, &
&cd(5) /3.27963479382361e-1/,  cd(6) /5.12675279912828e-1/, &
&cd(7) /7.45412958045105e-1/,  cd(8) /1.03695067418297e00/, &
&cd(9) /1.40378061255437e00/,  cd(10)/1.86891662214001e00/, &
&cd(11)/2.46314830523929e00/,  cd(12)/3.22719383737352e00/, &
&cd(13)/4.21534348280013e00/,  cd(14)/5.50178873151549e00/, &
&cd(15)/7.19258966683102e00/,  cd(16)/9.45170208076408e00/, &
&cd(17)/1.25710718314784e+1/,  cd(18)/1.72483537216334e+1/
data ce(1) /8.15723083324096e-2/,  ce(2) /1.59285285253437e-1/, &
&ce(3) /1.48581625614499e-1/,  ce(4) /1.33219670836245e-1/, &
&ce(5) /1.15690392878957e-1/,  ce(6) /9.78580959447535e-2/, &
&ce(7) /8.05908834297624e-2/,  ce(8) /6.40204538609872e-2/, &
&ce(9) /4.81445242767885e-2/,  ce(10)/3.33540658473295e-2/, &
&ce(11)/2.05548099470193e-2/,  ce(12)/1.07847403887506e-2/, &
&ce(13)/4.55634892214219e-3/,  ce(14)/1.43984458138925e-3/, &
&ce(15)/3.07056139834171e-4/,  ce(16)/3.78156541168541e-5/, &
&ce(17)/2.05173509616121e-6/,  ce(18)/2.63564823682747e-8/
!------------------------
x = real(z)
y = aimag(z)
sn = 1.0
if (x .ge. 0.0) go to 10
   x = -x
   y = -y
   sn = -1.0
!
10 r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.0*x*y
!
if (r .le. 1.0) go to 20
if (r .ge. 38.0) go to 60
if (sz(1) + 0.064*sz(2)*sz(2) .gt. 0.0) go to 50
!
!                       Taylor series
!
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
   if (abs(sm(1)) + abs(ts(1)) .ne. abs(sm(1))) go to 31
   if (abs(sm(2)) + abs(ts(2)) .eq. abs(sm(2))) go to 40
31 sm(1) = sm(1) + ts(1)
   sm(2) = sm(2) + ts(2)
   go to 30
!
!                       Termination
!
40 if (mo .ne. 0) go to 41
   w = cmplx(sn*sm(1), sn*sm(2))
   return
41 if (sn .lt. 0.0) go to 42
   sm(1) = 0.5 + (0.5 - sm(1))
   sm(2) = -sm(2)
   w = cmplx(sm(1), sm(2))
   return
42 w = cmplx(1.0 + sm(1), sm(2))
return
!
!              Rational function APPROXIMATION
!
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
   tm(1) =  ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ef(1) = qf(1)*sm(1) - qf(2)*sm(2)
ef(2) = qf(1)*sm(2) + qf(2)*sm(1)
go to 100
!
!                   Asymptotic expansion
!
60 qf(1) =  sz(1)/(r*r)
qf(2) = -sz(2)/(r*r)
qm = c*exp(-sz(1))
ts(1) = qm*cos(-sz(2))
ts(2) = qm*sin(-sz(2))
tm(1) =  (ts(1)*x + ts(2)*y)/r
tm(2) = -(ts(1)*y - ts(2)*x)/r
sm(1) = tm(1)
sm(2) = tm(2)
pm = -0.5
70 pm = pm + 1.0
   ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
   ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
   tm(1) = -pm*ts(1)
   tm(2) = -pm*ts(2)
   if (abs(sm(1)) + abs(tm(1)) .ne. abs(sm(1))) go to 71
   if (abs(sm(2)) + abs(tm(2)) .eq. abs(sm(2))) go to 80
71 sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   if (pm .lt. 25.5) go to 70
!
80 if (x .ge. 0.01) go to 81
   sn = -sn
   go to 40
81 ef(1) = sm(1)
ef(2) = sm(2)
!
!                       Termination
!
100 if (mo .eq. 0) go to 101
   w = cmplx(ef(1), ef(2))
   if (sn .eq. 1.0) return
   w = cmplx(2.0 - ef(1), -ef(2))
   return
101 ef(1) = sn*(1.0 - ef(1))
ef(2) = -sn*ef(2)
w = cmplx(ef(1),ef(2))
return
end subroutine cerf

subroutine cerfc (mo, z, w)
implicit none
integer, intent(in) :: mo
integer :: i
real :: c, c2, dm, pm, qm, r, sn, ss, x, y
real :: exparg
!-----------------------------------------------------------------------
!
!              Computation of the complex coerror function
!
!                           ----------------
!
!           w = erfc(z)           IF mo = 0 OR real(z) .LT. 0
!           w = exp(x*x)*erfc(z)  otherwise
!
!-----------------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: w
real :: cd(18), ce(18), qf(2), sm(2), sz(2), tm(2), ts(2)
!------------------------
!     c = 1/sqrt(pi)
!------------------------
data c /.564189583547756/
!------------------------
data cd(1) /0.00000000000000e00/,  cd(2) /2.08605856013476e-2/, &
&cd(3) /8.29806940495687e-2/,  cd(4) /1.85421653326079e-1/, &
&cd(5) /3.27963479382361e-1/,  cd(6) /5.12675279912828e-1/, &
&cd(7) /7.45412958045105e-1/,  cd(8) /1.03695067418297e00/, &
&cd(9) /1.40378061255437e00/,  cd(10)/1.86891662214001e00/, &
&cd(11)/2.46314830523929e00/,  cd(12)/3.22719383737352e00/, &
&cd(13)/4.21534348280013e00/,  cd(14)/5.50178873151549e00/, &
&cd(15)/7.19258966683102e00/,  cd(16)/9.45170208076408e00/, &
&cd(17)/1.25710718314784e+1/,  cd(18)/1.72483537216334e+1/
data ce(1) /8.15723083324096e-2/,  ce(2) /1.59285285253437e-1/, &
&ce(3) /1.48581625614499e-1/,  ce(4) /1.33219670836245e-1/, &
&ce(5) /1.15690392878957e-1/,  ce(6) /9.78580959447535e-2/, &
&ce(7) /8.05908834297624e-2/,  ce(8) /6.40204538609872e-2/, &
&ce(9) /4.81445242767885e-2/,  ce(10)/3.33540658473295e-2/, &
&ce(11)/2.05548099470193e-2/,  ce(12)/1.07847403887506e-2/, &
&ce(13)/4.55634892214219e-3/,  ce(14)/1.43984458138925e-3/, &
&ce(15)/3.07056139834171e-4/,  ce(16)/3.78156541168541e-5/, &
&ce(17)/2.05173509616121e-6/,  ce(18)/2.63564823682747e-8/
!------------------------
x = real(z)
y = aimag(z)
sn = 1.0
if (x .ge. 0.0) go to 10
   x = -x
   y = -y
   sn = -1.0
!
10 if (mo .ne. 0  .and.  sn .eq. 1.0  .and. &
&amax1(x, abs(y)) .ge. 100.0) go to 60
r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.0*x*y
!
if (r .le. 1.0) go to 20
if (r .ge. 38.0) go to 60
if (sz(1) + 0.064*sz(2)*sz(2) .gt. 0.0) go to 50
!
!                       Taylor series
!
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
   if (abs(sm(1)) + abs(ts(1)) .ne. abs(sm(1))) go to 31
   if (abs(sm(2)) + abs(ts(2)) .eq. abs(sm(2))) go to 40
31 sm(1) = sm(1) + ts(1)
   sm(2) = sm(2) + ts(2)
   go to 30
!
!                       Termination
!
40 if (sn .eq. 1.0) go to 41
   w = cmplx(1.0 + sm(1), sm(2))
   return
41 sm(1) = 0.5 + (0.5 - sm(1))
sm(2) = -sm(2)
if (mo .eq. 0) go to 110
!
qm = exp(sz(1))
qf(1) = qm*cos(sz(2))
qf(2) = qm*sin(sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
w = cmplx(ts(1),ts(2))
return
!
!              Rational function APPROXIMATION
!
50 sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = sz(1) + cd(i)
   ts(2) = sz(2)
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) =  ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ts(1) = x*sm(1) - y*sm(2)
ts(2) = x*sm(2) + y*sm(1)
sm(1) = c*ts(1)
sm(2) = c*ts(2)
go to 100
!
!                   Asymptotic expansion
!
60 call crec (x, y, tm(1), tm(2))
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
   if (abs(sm(1)) + abs(tm(1)) .ne. abs(sm(1))) go to 71
   if (abs(sm(2)) + abs(tm(2)) .eq. abs(sm(2))) go to 80
71 sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   if (pm .lt. 25.5) go to 70
80 sm(1) = c*sm(1)
sm(2) = c*sm(2)
if (x .lt. 0.01) go to 200
!
!                       Termination
!
100 if (mo .ne. 0 .and. sn .eq. 1.0) go to 110
qm = exp(-sz(1))
qf(1) = qm*cos(-sz(2))
qf(2) = qm*sin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
!
if (sn .eq. 1.0) go to 110
   w = cmplx(2.0 - sm(1), -sm(2))
   return
110 w = cmplx(sm(1), sm(2))
return
!
!               Modified asymptotic expansion
!
200 if (mo .ne. 0 .and. sn .eq. 1.0) go to 210
qm = exp(-sz(1))
qf(1) = qm*cos(-sz(2))
qf(2) = qm*sin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = 1.0 + sn*ts(1)
sm(2) = sn*ts(2)
w = cmplx(sm(1),sm(2))
return
!
210 if (abs(y) .ge. 100.0) go to 110
if (sz(1) .le. exparg(1)) go to 110
qm = exp(sz(1))
sm(1) = qm*cos(sz(2)) + sm(1)
sm(2) = qm*sin(sz(2)) + sm(2)
w = cmplx(sm(1),sm(2))
return
end subroutine cerfc

real function erf (x)
implicit none
real, intent(in) :: x
real :: ax, bot, c, t, top, x2
!-----------------------------------------------------------------------
!             Evaluation of the real error function
!-----------------------------------------------------------------------
real :: a(5), b(3), p(8), q(8), r(5), s(4)
!-------------------------
data c /.564189583547756/
!-------------------------
data a(1) /.771058495001320e-04/, a(2)/-.133733772997339e-02/, &
&a(3) /.323076579225834e-01/, a(4) /.479137145607681e-01/, &
&a(5) /.128379167095513e+00/
data b(1) /.301048631703895e-02/, b(2) /.538971687740286e-01/, &
&b(3) /.375795757275549e+00/
!-------------------------
data p(1)/-1.36864857382717e-07/, p(2) /5.64195517478974e-01/, &
&p(3) /7.21175825088309e+00/, p(4) /4.31622272220567e+01/, &
&p(5) /1.52989285046940e+02/, p(6) /3.39320816734344e+02/, &
&p(7) /4.51918953711873e+02/, p(8) /3.00459261020162e+02/
data q(1) /1.00000000000000e+00/, q(2) /1.27827273196294e+01/, &
&q(3) /7.70001529352295e+01/, q(4) /2.77585444743988e+02/, &
&q(5) /6.38980264465631e+02/, q(6) /9.31354094850610e+02/, &
&q(7) /7.90950925327898e+02/, q(8) /3.00459260956983e+02/
!-------------------------
data r(1) /2.10144126479064e+00/, r(2) /2.62370141675169e+01/, &
&r(3) /2.13688200555087e+01/, r(4) /4.65807828718470e+00/, &
&r(5) /2.82094791773523e-01/
data s(1) /9.41537750555460e+01/, s(2) /1.87114811799590e+02/, &
&s(3) /9.90191814623914e+01/, s(4) /1.80124575948747e+01/
!-------------------------
ax = abs(x)
if (ax .gt. 0.5) go to 10
t = x*x
top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + 1.0
bot = ((b(1)*t + b(2))*t + b(3))*t + 1.0
erf = x*(top/bot)
return
!
10 if (ax .gt. 4.0) go to 20
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
&+ p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
&+ q(6))*ax + q(7))*ax + q(8)
erf = 0.5 + (0.5 - exp(-x*x)*top/bot)
if (x .lt. 0.0) erf = -erf
return
!
20 if (ax .ge. 5.8) go to 30
x2 = x*x
t = 1.0/x2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erf = (c - top/(x2*bot)) / ax
erf = 0.5 + (0.5 - exp(-x2)*erf)
if (x .lt. 0.0) erf = -erf
return
!
30 erf = sign(1.0,x)
return
end function erf

real function erfc (x)
implicit none
real, intent(in) :: x
real :: ax, bot, c, e, t, top
real :: exparg
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!-----------------------------------------------------------------------
real :: a(5), b(3), p(8), q(8), r(5), s(4)
double precision :: w
!-------------------------
data c /.564189583547756/
!-------------------------
data a(1) /.771058495001320e-04/, a(2)/-.133733772997339e-02/, &
&a(3) /.323076579225834e-01/, a(4) /.479137145607681e-01/, &
&a(5) /.128379167095513e+00/
data b(1) /.301048631703895e-02/, b(2) /.538971687740286e-01/, &
&b(3) /.375795757275549e+00/
!-------------------------
data p(1)/-1.36864857382717e-07/, p(2) /5.64195517478974e-01/, &
&p(3) /7.21175825088309e+00/, p(4) /4.31622272220567e+01/, &
&p(5) /1.52989285046940e+02/, p(6) /3.39320816734344e+02/, &
&p(7) /4.51918953711873e+02/, p(8) /3.00459261020162e+02/
data q(1) /1.00000000000000e+00/, q(2) /1.27827273196294e+01/, &
&q(3) /7.70001529352295e+01/, q(4) /2.77585444743988e+02/, &
&q(5) /6.38980264465631e+02/, q(6) /9.31354094850610e+02/, &
&q(7) /7.90950925327898e+02/, q(8) /3.00459260956983e+02/
!-------------------------
data r(1) /2.10144126479064e+00/, r(2) /2.62370141675169e+01/, &
&r(3) /2.13688200555087e+01/, r(4) /4.65807828718470e+00/, &
&r(5) /2.82094791773523e-01/
data s(1) /9.41537750555460e+01/, s(2) /1.87114811799590e+02/, &
&s(3) /9.90191814623914e+01/, s(4) /1.80124575948747e+01/
!-------------------------
!
!                     abs(x) .LE. 0.5
!
ax = abs(x)
if (ax .gt. 0.5) go to 10
t = x*x
top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + 1.0
bot = ((b(1)*t + b(2))*t + b(3))*t + 1.0
erfc = 0.5 + (0.5 - x*(top/bot))
return
!
!                  0.5 .LT. abs(x) .LE. 4
!
10 if (ax .gt. 4.0) go to 20
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
&+ p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
&+ q(6))*ax + q(7))*ax + q(8)
erfc = top/bot
go to 30
!
!                       abs(x) .GT. 4
!
20 if (x .le. -5.6) go to 40
if (x .gt. 100.0) go to 50
t = x*x
if (t .gt. -exparg(1)) go to 50
!
t = 1.0/t
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erfc = (c - t*top/bot)/ax
!
!                      Final assembly
!
30 w = dble(x)*dble(x)
t = w
e = w - dble(t)
erfc = ((0.5 + (0.5 - e)) * exp(-t)) * erfc
if (x .lt. 0.0) erfc = 2.0 - erfc
return
!
!             Limit value for large negative x
!
40 erfc = 2.0
return
!
!             Limit value for large positive x
!
50 erfc = 0.0
return
end function erfc

real function erfc1 (ind, x)
implicit none
real :: exparg
integer, intent(in) :: ind
real, intent(in) :: x
real :: ax, bot, c, e, t, top
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!
!          erfc1(ind,x) = erfc(x)            IF ind = 0
!          erfc1(ind,x) = exp(x*x)*erfc(x)   otherwise
!-----------------------------------------------------------------------
real :: a(5), b(3), p(8), q(8), r(5), s(4)
double precision :: w
!-------------------------
data c /.564189583547756/
!-------------------------
data a(1) /.771058495001320e-04/, a(2)/-.133733772997339e-02/, &
&a(3) /.323076579225834e-01/, a(4) /.479137145607681e-01/, &
&a(5) /.128379167095513e+00/
data b(1) /.301048631703895e-02/, b(2) /.538971687740286e-01/, &
&b(3) /.375795757275549e+00/
!-------------------------
data p(1)/-1.36864857382717e-07/, p(2) /5.64195517478974e-01/, &
&p(3) /7.21175825088309e+00/, p(4) /4.31622272220567e+01/, &
&p(5) /1.52989285046940e+02/, p(6) /3.39320816734344e+02/, &
&p(7) /4.51918953711873e+02/, p(8) /3.00459261020162e+02/
data q(1) /1.00000000000000e+00/, q(2) /1.27827273196294e+01/, &
&q(3) /7.70001529352295e+01/, q(4) /2.77585444743988e+02/, &
&q(5) /6.38980264465631e+02/, q(6) /9.31354094850610e+02/, &
&q(7) /7.90950925327898e+02/, q(8) /3.00459260956983e+02/
!-------------------------
data r(1) /2.10144126479064e+00/, r(2) /2.62370141675169e+01/, &
&r(3) /2.13688200555087e+01/, r(4) /4.65807828718470e+00/, &
&r(5) /2.82094791773523e-01/
data s(1) /9.41537750555460e+01/, s(2) /1.87114811799590e+02/, &
&s(3) /9.90191814623914e+01/, s(4) /1.80124575948747e+01/
!-------------------------
!
!                     abs(x) .LE. 0.5
!
ax = abs(x)
if (ax .gt. 0.5) go to 10
t = x*x
top = ((((a(1)*t + a(2))*t + a(3))*t + a(4))*t + a(5)) + 1.0
bot = ((b(1)*t + b(2))*t + b(3))*t + 1.0
erfc1 = 0.5 + (0.5 - x*(top/bot))
if (ind .ne. 0) erfc1 = exp(t) * erfc1
return
!
!                  0.5 .LT. abs(x) .LE. 4
!
10 if (ax .gt. 4.0) go to 20
top = ((((((p(1)*ax + p(2))*ax + p(3))*ax + p(4))*ax + p(5))*ax &
&+ p(6))*ax + p(7))*ax + p(8)
bot = ((((((q(1)*ax + q(2))*ax + q(3))*ax + q(4))*ax + q(5))*ax &
&+ q(6))*ax + q(7))*ax + q(8)
erfc1 = top/bot
go to 40
!
!                      abs(x) .GT. 4
!
20 if (x .le. -5.6) go to 50
if (ind .ne. 0) go to 30
if (x .gt. 100.0) go to 60
if (x*x .gt. -exparg(1)) go to 60
!
30 t = (1.0/x)**2
top = (((r(1)*t + r(2))*t + r(3))*t + r(4))*t + r(5)
bot = (((s(1)*t + s(2))*t + s(3))*t + s(4))*t + 1.0
erfc1 = (c - t*top/bot)/ax
!
!                      Final assembly
!
40 if (ind .eq. 0) go to 41
   if (x .lt. 0.0) erfc1 = 2.0*exp(x*x) - erfc1
   return
41 w = dble(x)*dble(x)
t = w
e = w - dble(t)
erfc1 = ((0.5 + (0.5 - e)) * exp(-t)) * erfc1
if (x .lt. 0.0) erfc1 = 2.0 - erfc1
return
!
!             Limit value for large negative x
!
50 erfc1 = 2.0
if (ind .ne. 0) erfc1 = 2.0*exp(x*x)
return
!
!             Limit value for large positive x
!                       WHEN ind = 0
!
60 erfc1 = 0.0
return
end function erfc1

subroutine dcerf (mo, z, w)
implicit none
integer, intent(in) :: mo
!-----------------------------------------------------------------------
!
!               Computation of the complex error function
!
!                          -----------------
!
!                       w = erf(z)    IF mo = 0
!                       w = erfc(z)   otherwise
!
!-----------------------------------------------------------------------
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
double precision :: m, n, n2, n4, np1
double precision :: c, c2, d, d2, e, eps, r, sn, tol, x, y
double precision :: a0(2), an(2), b0(2), bn(2)
double precision :: g0(2), gn(2), h0(2), hn(2)
double precision :: qf(2), sm(2), sz(2), tm(2), ts(2), w0(2), &
&wn(2)
double precision :: anorm, dpmpar
!------------------------
anorm(x,y) = dmax1(dabs(x),dabs(y))
!------------------------
!     c = 1/sqrt(pi)
!------------------------
data c /.56418958354775628694807945156077d0/
!------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0.
!
                eps = dpmpar(1)
!
!------------------------
x = z(1)
y = z(2)
sn = 1.d0
if (x .ge. 0.d0) go to 10
   x = -x
   y = -y
   sn = -1.d0
!
10 r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.d0*x*y
!
if (r .le. 1.d0) go to 20
if (r .ge. 144.d0) go to 100
if (dabs(y) .gt. 31.8d0*x) go to 50
if (dabs(y) .gt. 7.0d0*x .and. r .lt. 64.d0) go to 50
if (dabs(y) .gt. 3.2d0*x .and. r .lt. 49.d0) go to 50
if (dabs(y) .gt. 2.0d0*x .and. r .lt. 36.d0) go to 50
if (dabs(y) .gt. 1.2d0*x .and. r .lt. 25.d0) go to 50
if (dabs(y) .gt. 0.9d0*x .and. r .lt. 16.d0) go to 50
if (r .ge. 6.25d0) go to 80
if (dabs(y) .gt. 0.6d0*x) go to 50
if (r .ge. 4.0d0) go to 40
!
d = x - 2.d0
if (d*d + y*y .lt. 1.d0) go to 40
go to 50
!
!                          Taylor series
!
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
   if (anorm(ts(1),ts(2)) .gt. tol*anorm(sm(1),sm(2))) go to 21
!
if (mo .ne. 0) go to 30
   w(1) = sn*sm(1)
   w(2) = sn*sm(2)
   return
30 if (sn .eq. 1.d0) go to 31
   w(1) = 1.d0 + sm(1)
   w(2) = sm(2)
   return
31 w(1) = 0.5d0 + (0.5d0 - sm(1))
w(2) = -sm(2)
return
!
!                  TAYLOR SERIES AROUND Z0 = 2
!
40 tm(1) = x
tm(2) = y
call erfcm2 (0, tm, w)
if (mo .ne. 0) go to 41
   w(1) = sn*(0.5d0 + (0.5d0 - w(1)))
   w(2) = - sn*w(2)
   return
41 if (sn .gt. 0.d0) return
w(1) = 2.d0 - w(1)
w(2) = - w(2)
return
!
!            Pade approximation for the Taylor series
!                    for  (exp(z*z)/z)*erf(z)
!
50 d = 4.d0
if (r .gt. 16.d0) d = 16.d0
if (r .gt. 64.d0) d = 64.d0
d2 = d*d
call dcrec (sz(1), sz(2), w(1), w(2))
a0(1) = 1.d0
a0(2) = 0.d0
an(1) = (w(1) + 4.d0/15.d0)*d
an(2) = w(2)*d
b0(1) = 1.d0
b0(2) = 0.d0
bn(1) = (w(1) - 0.4d0)*d
bn(2) = w(2)*d
call cdivid (an(1), an(2), bn(1), bn(2), wn(1), wn(2))
tol = 10.d0*eps
n4 = 0.d0
!
60 n4 = n4 + 4.d0
   e = (n4 + 1.d0)*(n4 + 5.d0)
   tm(1) = d*(w(1) - 2.d0/e)
   tm(2) = d*w(2)
   e = d2*(n4*(n4 + 2.0))/((n4 - 1.0)*(n4 + 3.0)*(n4 + 1.0)**2)
!
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
!
   w0(1) = wn(1)
   w0(2) = wn(2)
   call cdivid (an(1), an(2), bn(1), bn(2), wn(1), wn(2))
   if (anorm(wn(1) - w0(1), wn(2) - w0(2)) .gt. &
&tol*anorm(wn(1), wn(2))) go to 60
!
c2 = c + c
sm(1) = c2*(x*wn(1) - y*wn(2))
sm(2) = c2*(x*wn(2) + y*wn(1))
e = dexp(-sz(1))
qf(1) = e*dcos(-sz(2))
qf(2) = e*dsin(-sz(2))
tm(1) = qf(1)*sm(1) - qf(2)*sm(2)
tm(2) = qf(1)*sm(2) + qf(2)*sm(1)
!
w(1) = sn*tm(1)
w(2) = sn*tm(2)
if (mo .eq. 0) return
w(1) = 1.d0 - w(1)
w(2) = - w(2)
return
!
!         Pade approximation for the asymptotic expansion
!                    for  z*exp(z*z)*erfc(z)
!
80 d = 4.d0*r
if (r .lt. 16.d0) d = 16.d0*r
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
call cdivid (gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
np1 = 1.d0
tol = 10.d0*eps
!
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
!
   w0(1) = wn(1)
   w0(2) = wn(2)
   call cdivid (gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
   if (anorm(wn(1) - w0(1), wn(2) - w0(2)) .gt. &
&tol*anorm(wn(1), wn(2))) go to 90
!
tm(1) = x*hn(1) - y*hn(2)
tm(2) = x*hn(2) + y*hn(1)
call cdivid (c*gn(1), c*gn(2), tm(1), tm(2), sm(1), sm(2))
go to 130
!
!                      Asymptotic expansion
!
100 call dcrec (x, y, tm(1), tm(2))
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
   if (anorm(tm(1),tm(2)) .gt. tol*anorm(sm(1),sm(2))) go to 110
sm(1) = c*sm(1)
sm(2) = c*sm(2)
if (x .lt. 1.d-2) go to 200
!
!                       Termination
!
130 e = dexp(-sz(1))
qf(1) = e*dcos(-sz(2))
qf(2) = e*dsin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
!
if (mo .ne. 0) go to 140
   w(1) = sn*(0.5d0 + (0.5d0 - sm(1)))
   w(2) = - sn*sm(2)
   return
140 if (sn .eq. 1.d0) go to 141
   w(1) = 2.d0 - sm(1)
   w(2) = -sm(2)
   return
141 w(1) = sm(1)
w(2) = sm(2)
return
!
!               Modified asymptotic expansion
!
200 e = dexp(-sz(1))
qf(1) = e*dcos(-sz(2))
qf(2) = e*dsin(-sz(2))
w(1) = qf(1)*sm(1) - qf(2)*sm(2)
w(2) = qf(1)*sm(2) + qf(2)*sm(1)
if (mo .eq. 0) go to 210
   w(1) = 1.d0 + sn*w(1)
   w(2) = sn*w(2)
   return
210 if (sn .lt. 0.0) return
w(1) = - w(1)
w(2) = - w(2)
return
end subroutine dcerf

subroutine dcerfc (mo, z, w)
implicit none
integer, intent(in) :: mo
!-----------------------------------------------------------------------
!
!              Computation of the complex coerror function
!
!                           ----------------
!
!           w = erfc(z)           IF mo = 0 OR real(z) .LT. 0
!           w = dexp(x*x)*erfc(z)  otherwise
!
!-----------------------------------------------------------------------
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
double precision :: m, n, n2, n4, np1
double precision :: c, c2, d, d2, e, eps, r, sn, tol, x, y
double precision :: a0(2), an(2), b0(2), bn(2)
double precision :: g0(2), gn(2), h0(2), hn(2)
double precision :: qf(2), sm(2), sz(2), tm(2), ts(2), w0(2), &
&wn(2)
double precision :: anorm, dpmpar, dxparg
!------------------------
anorm(x,y) = dmax1(dabs(x),dabs(y))
!------------------------
!     c = 1/sqrt(pi)
!------------------------
data c /.56418958354775628694807945156077d0/
!------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0.
!
                eps = dpmpar(1)
!
!------------------------
x = z(1)
y = z(2)
sn = 1.d0
if (x .ge. 0.d0) go to 10
   x = -x
   y = -y
   sn = -1.d0
!
10 if (mo .ne. 0  .and.  sn .eq. 1.d0  .and. &
&dmax1(x, dabs(y)) .ge. 144.d0) go to 100
r = x*x + y*y
sz(1) = x*x - y*y
sz(2) = 2.d0*x*y
!
if (r .le. 1.d0) go to 20
if (r .ge. 144.d0) go to 100
if (dabs(y) .gt. 31.8d0*x) go to 50
if (dabs(y) .gt. 7.0d0*x .and. r .lt. 64.d0) go to 50
if (dabs(y) .gt. 3.2d0*x .and. r .lt. 49.d0) go to 50
if (dabs(y) .gt. 2.0d0*x .and. r .lt. 36.d0) go to 50
if (dabs(y) .gt. 1.2d0*x .and. r .lt. 25.d0) go to 50
if (dabs(y) .gt. 0.9d0*x .and. r .lt. 16.d0) go to 50
if (r .ge. 6.25d0) go to 80
if (dabs(y) .gt. 0.6d0*x) go to 50
if (r .ge. 4.0d0) go to 40
!
d = x - 2.d0
if (d*d + y*y .lt. 1.d0) go to 40
go to 50
!
!                          Taylor series
!
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
   if (anorm(ts(1),ts(2)) .gt. tol*anorm(sm(1),sm(2))) go to 21
!
if (sn .eq. 1.d0) go to 30
   w(1) = 1.d0 + sm(1)
   w(2) = sm(2)
   return
30 sm(1) = 0.5d0 + (0.5d0 - sm(1))
sm(2) = -sm(2)
if (mo .eq. 0) go to 140
!
e = dexp(sz(1))
qf(1) = e*dcos(sz(2))
qf(2) = e*dsin(sz(2))
w(1) = qf(1)*sm(1) - qf(2)*sm(2)
w(2) = qf(1)*sm(2) + qf(2)*sm(1)
return
!
!                  TAYLOR SERIES AROUND Z0 = 2
!
40 if (sn .lt. 0.d0) go to 41
   call erfcm2 (mo, z, w)
   return
41 tm(1) = x
tm(2) = y
call erfcm2 (0, tm, w)
w(1) = 2.d0 - w(1)
w(2) = - w(2)
return
!
!            Pade approximation for the Taylor series
!                    for  (exp(z*z)/z)*erf(z)
!
50 d = 4.d0
if (r .gt. 16.d0) d = 16.d0
if (r .gt. 64.d0) d = 64.d0
d2 = d*d
call dcrec (sz(1), sz(2), w(1), w(2))
a0(1) = 1.d0
a0(2) = 0.d0
an(1) = (w(1) + 4.d0/15.d0)*d
an(2) = w(2)*d
b0(1) = 1.d0
b0(2) = 0.d0
bn(1) = (w(1) - 0.4d0)*d
bn(2) = w(2)*d
call cdivid (an(1), an(2), bn(1), bn(2), wn(1), wn(2))
tol = 10.d0*eps
n4 = 0.d0
!
60 n4 = n4 + 4.d0
   e = (n4 + 1.d0)*(n4 + 5.d0)
   tm(1) = d*(w(1) - 2.d0/e)
   tm(2) = d*w(2)
   e = d2*(n4*(n4 + 2.0))/((n4 - 1.0)*(n4 + 3.0)*(n4 + 1.0)**2)
!
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
!
   w0(1) = wn(1)
   w0(2) = wn(2)
   call cdivid (an(1), an(2), bn(1), bn(2), wn(1), wn(2))
   if (anorm(wn(1) - w0(1), wn(2) - w0(2)) .gt. &
&tol*anorm(wn(1), wn(2))) go to 60
!
c2 = c + c
sm(1) = c2*(x*wn(1) - y*wn(2))
sm(2) = c2*(x*wn(2) + y*wn(1))
!
if (mo .eq. 0 .or. sn .ne. 1.d0) go to 70
   e = dexp(sz(1))
   w(1) = e*dcos(sz(2)) - sm(1)
   w(2) = e*dsin(sz(2)) - sm(2)
   return
70 e = dexp(-sz(1))
qf(1) = e*dcos(-sz(2))
qf(2) = e*dsin(-sz(2))
tm(1) = qf(1)*sm(1) - qf(2)*sm(2)
tm(2) = qf(1)*sm(2) + qf(2)*sm(1)
w(1) = 1.d0 - sn*tm(1)
w(2) = - sn*tm(2)
return
!
!         Pade approximation for the asymptotic expansion
!                    for  z*exp(z*z)*erfc(z)
!
80 d = 4.d0*r
if (r .lt. 16.d0) d = 16.d0*r
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
call cdivid (gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
np1 = 1.d0
tol = 10.d0*eps
!
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
!
   w0(1) = wn(1)
   w0(2) = wn(2)
   call cdivid (gn(1), gn(2), hn(1), hn(2), wn(1), wn(2))
   if (anorm(wn(1) - w0(1), wn(2) - w0(2)) .gt. &
&tol*anorm(wn(1), wn(2))) go to 90
!
tm(1) = x*hn(1) - y*hn(2)
tm(2) = x*hn(2) + y*hn(1)
call cdivid (c*gn(1), c*gn(2), tm(1), tm(2), sm(1), sm(2))
go to 130
!
!                      Asymptotic expansion
!
100 call dcrec (x, y, tm(1), tm(2))
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
   if (anorm(tm(1),tm(2)) .gt. tol*anorm(sm(1),sm(2))) go to 110
sm(1) = c*sm(1)
sm(2) = c*sm(2)
if (x .lt. 1.d-2) go to 200
!
!                       Termination
!
130 if (mo .ne. 0 .and. sn .eq. 1.d0) go to 140
e = dexp(-sz(1))
qf(1) = e*dcos(-sz(2))
qf(2) = e*dsin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
!
if (sn .eq. 1.d0) go to 140
   w(1) = 2.d0 - sm(1)
   w(2) = -sm(2)
   return
140 w(1) = sm(1)
w(2) = sm(2)
return
!
!               Modified asymptotic expansion
!
200 if (mo .ne. 0 .and. sn .eq. 1.d0) go to 210
e = dexp(-sz(1))
qf(1) = e*dcos(-sz(2))
qf(2) = e*dsin(-sz(2))
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
w(1) = 1.d0 + sn*ts(1)
w(2) = sn*ts(2)
return
!
210 if (dabs(y) .ge. 100.d0) go to 140
if (sz(1) .le. dxparg(1)) go to 140
e = dexp(sz(1))
w(1) = e*dcos(sz(2)) + sm(1)
w(2) = e*dsin(sz(2)) + sm(2)
return
end subroutine dcerfc

subroutine erfcm2 (mo, z, w)
implicit none
integer, intent(in) :: mo
integer :: j, n
!-----------------------------------------------------------------------
!           Calculation of erfc(z) using the Taylor series
!                          AROUND Z0 = 2
!-----------------------------------------------------------------------
double precision, intent(in) :: z(2)
double precision, intent(inout) :: w(2)
double precision :: a(63), c, e, eps, h(2), t(2), tol, x, y
double precision :: anorm, dpmpar
!------------------------------
anorm(x,y) = dmax1(dabs(x),dabs(y))
!------------------------------
!     c = (2/sqrt(pi))*exp(-4)
!     e = erfc(2)
!------------------------------
data c /.20666985354092053857068941306585476d-01/
data e /.46777349810472658379307436327470714d-02/
!------------------------------
data a(1)  / .20000000000000000000000000000000000d+01/, &
&a(2)  / .23333333333333333333333333333333333d+01/, &
&a(3)  / .16666666666666666666666666666666667d+01/, &
&a(4)  / .63333333333333333333333333333333333d+00/, &
&a(5)  /-.22222222222222222222222222222222222d-01/, &
&a(6)  /-.16349206349206349206349206349206349d+00/, &
&a(7)  /-.76984126984126984126984126984126984d-01/, &
&a(8)  /-.24250440917107583774250440917107584d-02/, &
&a(9)  / .12716049382716049382716049382716049d-01/, &
&a(10) / .50208433541766875100208433541766875d-02/
data a(11) /-.25305969750414194858639303083747528d-03/, &
&a(12) /-.78593217482106370995259884148773038d-03/, &
&a(13) /-.19118154038788959423880058800693721d-03/, &
&a(14) / .46324144207742091339974937858535742d-04/, &
&a(15) / .33885549097189308829520469732109944d-04/, &
&a(16) / .28637897646612243562134629672756034d-05/, &
&a(17) /-.29071891082127275370004560446169188d-05/, &
&a(18) /-.89674405786490646425523560263096103d-06/, &
&a(19) / .96069103941908684338469767911200105d-07/, &
&a(20) / .99432863129093191401848891268744113d-07/
data a(21) / .97610310501460621303387795457283579d-08/, &
&a(22) /-.65557500375673133822289344530892436d-08/, &
&a(23) /-.18706782059105426900361744016236561d-08/, &
&a(24) / .20329898993447386223176373714372370d-09/, &
&a(25) / .16941915827254374668448114614201210d-09/, &
&a(26) / .10619149520827430973786114446699534d-10/, &
&a(27) /-.10136148256511788733365237088810952d-10/, &
&a(28) /-.21042890133669970575386166675721692d-11/, &
&a(29) / .37186985840699828780916522245407087d-12/, &
&a(30) / .17921843632701679986488128324051002d-12/
data a(31) /-.89823991804248069863542565948598397d-16/, &
&a(32) /-.10533182313660970970232171410372199d-13/, &
&a(33) /-.12340742690978398320850088252659714d-14/, &
&a(34) / .44315624546581333350568244777175883d-15/, &
&a(35) / .11584041639989442481950487524296214d-15/, &
&a(36) /-.10765703619385988116658460442219647d-16/, &
&a(37) /-.70653158723054941879586082239984222d-17/, &
&a(38) /-.18708903154917138727191793341667090d-18/, &
&a(39) / .32549879318817103966053527398133297d-18/, &
&a(40) / .40654116689599228385911733319215613d-19/
data a(41) /-.11250074516817311101947327325293424d-19/, &
&a(42) /-.28923865378584966737386008432031980d-20/, &
&a(43) / .23653053641701517160704870522922706d-21/, &
&a(44) / .14665384680061888088099002254334292d-21/, &
&a(45) / .26971039707314316218154193225264469d-23/, &
&a(46) /-.58753834789274356433279671015522650d-23/, &
&a(47) /-.59960357240498652932299485494869633d-24/, &
&a(48) / .18586826578121663981412155416486531d-24/, &
&a(49) / .38364131854692721721867481914852428d-25/, &
&a(50) /-.41342210492630142578080062451711039d-26/
data a(51) /-.17646283105274988992381528904600860d-26/, &
&a(52) / .19828685934364181151988692232131608d-28/, &
&a(53) / .65592252170840353572672782446212733d-28/, &
&a(54) / .40626551379996340638338449938639730d-29/, &
&a(55) /-.20097984104191034713653294173834095d-29/, &
&a(56) /-.28104226475997460044096389060743131d-30/, &
&a(57) / .48705319298749358709127987806547949d-31/, &
&a(58) / .12664655832830787747161769929972617d-31/, &
&a(59) /-.75168312488894341862391776330113688d-33/, &
&a(60) /-.45760473722605993842481669806804415d-33/
data a(61) /-.56725491529575395930156379514718000d-35/, &
&a(62) / .13932664042920082608489441616061541d-34/, &
&a(63) / .10452448992516358449586503951463322d-35/
!------------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0
!
       eps = dpmpar(1)
!
!------------------------------
tol = eps*1.d+12
h(1) = 1.d0 + (1.d0 - z(1))
h(2) = - z(2)
!
x = 1.d0
y = 0.d0
w(1) = a(30)
w(2) = 0.d0
do 10 n = 31,63
   t(1) = x*h(1) - y*h(2)
   t(2) = x*h(2) + y*h(1)
   x = t(1)
   y = t(2)
   t(1) = a(n)*x
   t(2) = a(n)*y
   w(1) = w(1) + t(1)
   w(2) = w(2) + t(2)
   if (anorm(t(1),t(2)) .le. tol*anorm(w(1),w(2))) go to 20
10 continue
!
20 do 21 j = 1,29
   n = 30 - j
   x = h(1)*w(1) - h(2)*w(2)
   w(2) = h(1)*w(2) + h(2)*w(1)
   w(1) = a(n) + x
21 continue
x = h(1)*w(1) - h(2)*w(2)
w(2) = h(1)*w(2) + h(2)*w(1)
w(1) = 1.d0 + x
!
x = c*(h(1)*w(1) - h(2)*w(2))
w(2) = c*(h(1)*w(2) + h(2)*w(1))
w(1) = e + x
if (mo .eq. 0) return
!
!                     Compute exp(z*z)*erfc(z)
!
x = z(1)*z(1) - z(2)*z(2)
y = 2.d0*z(1)*z(2)
x = dexp(x)
t(1) = x*dcos(y)
t(2) = x*dsin(y)
x = t(1)*w(1) - t(2)*w(2)
y = t(1)*w(2) + t(2)*w(1)
w(1) = x
w(2) = y
return
end subroutine erfcm2

double precision function derf (x)
implicit none
integer :: i, k
!-----------------------------------------------------------------------
!        Double precision evaluation of the error function
!-----------------------------------------------------------------------
double precision :: ax, t
double precision, intent(in) :: x
double precision :: w
double precision :: a(21)
double precision :: derfc0
!-------------------------------
data a(1)  / .1283791670955125738961589031215d+00/, &
&a(2)  /-.3761263890318375246320529677070d+00/, &
&a(3)  / .1128379167095512573896158902931d+00/, &
&a(4)  /-.2686617064513125175943235372542d-01/, &
&a(5)  / .5223977625442187842111812447877d-02/, &
&a(6)  /-.8548327023450852832540164081187d-03/, &
&a(7)  / .1205533298178966425020717182498d-03/, &
&a(8)  /-.1492565035840625090430728526820d-04/, &
&a(9)  / .1646211436588924261080723578109d-05/, &
&a(10) /-.1636584469123468757408968429674d-06/
data a(11) / .1480719281587021715400818627811d-07/, &
&a(12) /-.1229055530145120140800510155331d-08/, &
&a(13) / .9422759058437197017313055084212d-10/, &
&a(14) /-.6711366740969385085896257227159d-11/, &
&a(15) / .4463222608295664017461758843550d-12/, &
&a(16) /-.2783497395542995487275065856998d-13/, &
&a(17) / .1634095572365337143933023780777d-14/, &
&a(18) /-.9052845786901123985710019387938d-16/, &
&a(19) / .4708274559689744439341671426731d-17/, &
&a(20) /-.2187159356685015949749948252160d-18/, &
&a(21) / .7043407712019701609635599701333d-20/
!-------------------------------
!
!                     dabs(x) .LE. 1
!
ax = dabs(x)
if (ax .gt. 1.d0) go to 20
t = x*x
w = a(21)
do 10 i = 1,20
   k = 21 - i
   w = t*w + a(k)
10 continue
derf = x*(1.d0 + w)
return
!
!                     dabs(x) .GT. 1
!
20 if (ax .ge. 8.5d0) go to 30
derf = 0.5d0 + (0.5d0 - dexp(-x*x)*derfc0(ax))
if (x .lt. 0.d0) derf = -derf
return
!
!                 Limit value for large x
!
30 derf = dsign(1.d0,x)
return
end function derf

double precision function derfc (x)
implicit none
integer :: i, k
!-----------------------------------------------------------------------
!         Evaluation of the complementary error function
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: ax, t, w
double precision :: a(21)
double precision :: derfc0, dxparg
!-------------------------------
data a(1)  / .1283791670955125738961589031215d+00/, &
&a(2)  /-.3761263890318375246320529677070d+00/, &
&a(3)  / .1128379167095512573896158902931d+00/, &
&a(4)  /-.2686617064513125175943235372542d-01/, &
&a(5)  / .5223977625442187842111812447877d-02/, &
&a(6)  /-.8548327023450852832540164081187d-03/, &
&a(7)  / .1205533298178966425020717182498d-03/, &
&a(8)  /-.1492565035840625090430728526820d-04/, &
&a(9)  / .1646211436588924261080723578109d-05/, &
&a(10) /-.1636584469123468757408968429674d-06/
data a(11) / .1480719281587021715400818627811d-07/, &
&a(12) /-.1229055530145120140800510155331d-08/, &
&a(13) / .9422759058437197017313055084212d-10/, &
&a(14) /-.6711366740969385085896257227159d-11/, &
&a(15) / .4463222608295664017461758843550d-12/, &
&a(16) /-.2783497395542995487275065856998d-13/, &
&a(17) / .1634095572365337143933023780777d-14/, &
&a(18) /-.9052845786901123985710019387938d-16/, &
&a(19) / .4708274559689744439341671426731d-17/, &
&a(20) /-.2187159356685015949749948252160d-18/, &
&a(21) / .7043407712019701609635599701333d-20/
!-------------------------------
!
!                     dabs(x) .LE. 1
!
ax = dabs(x)
if (ax .gt. 1.d0) go to 20
t = x*x
w = a(21)
do 10 i = 1,20
   k = 21 - i
   w = t*w + a(k)
10 continue
derfc = 0.5d0 + (0.5d0 - x*(1.d0 + w))
return
!
!                       x .LT. -1
!
20 if (x .gt. 0.d0) go to 30
derfc = 2.d0
if (x .lt. -8.3d0) return
t = x*x
derfc = 2.d0 - dexp(-t) * derfc0(ax)
return
!
!                       x .GT. 1
!
30 derfc = 0.d0
if (x .gt. 100.d0) return
t = x*x
if (t .gt. -dxparg(1)) return
derfc = dexp(-t) * derfc0(x)
return
end function derfc

double precision function derfc1 (ind, x)
implicit none
integer, intent(in) :: ind
integer :: i, k
!-----------------------------------------------------------------------
!
!         Evaluation of the complementary error function
!
!          derfc1(ind,x) = erfc(x)           IF ind = 0
!          derfc1(ind,x) = exp(x*x)*erfc(x)  otherwise
!
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: ax, t, w
double precision :: a(21)
double precision :: derfc0, dxparg
!-------------------------------
data a(1)  / .1283791670955125738961589031215d+00/, &
&a(2)  /-.3761263890318375246320529677070d+00/, &
&a(3)  / .1128379167095512573896158902931d+00/, &
&a(4)  /-.2686617064513125175943235372542d-01/, &
&a(5)  / .5223977625442187842111812447877d-02/, &
&a(6)  /-.8548327023450852832540164081187d-03/, &
&a(7)  / .1205533298178966425020717182498d-03/, &
&a(8)  /-.1492565035840625090430728526820d-04/, &
&a(9)  / .1646211436588924261080723578109d-05/, &
&a(10) /-.1636584469123468757408968429674d-06/
data a(11) / .1480719281587021715400818627811d-07/, &
&a(12) /-.1229055530145120140800510155331d-08/, &
&a(13) / .9422759058437197017313055084212d-10/, &
&a(14) /-.6711366740969385085896257227159d-11/, &
&a(15) / .4463222608295664017461758843550d-12/, &
&a(16) /-.2783497395542995487275065856998d-13/, &
&a(17) / .1634095572365337143933023780777d-14/, &
&a(18) /-.9052845786901123985710019387938d-16/, &
&a(19) / .4708274559689744439341671426731d-17/, &
&a(20) /-.2187159356685015949749948252160d-18/, &
&a(21) / .7043407712019701609635599701333d-20/
!-------------------------------
!
!                     dabs(x) .LE. 1
!
ax = dabs(x)
if (ax .gt. 1.d0) go to 20
t = x*x
w = a(21)
do 10 i = 1,20
   k = 21 - i
   w = t*w + a(k)
10 continue
derfc1 = 0.5d0 + (0.5d0 - x*(1.d0 + w))
if (ind .ne. 0) derfc1 = dexp(t) * derfc1
return
!
!                       x .LT. -1
!
20 if (x .gt. 0.d0) go to 50
if (x .lt. -8.3d0) go to 80
if (ind .eq. 0) go to 30
   derfc1 = 2.d0*dexp(x*x) - derfc0(ax)
   return
30 derfc1 = 2.d0 - dexp(-x*x)*derfc0(ax)
return
!
!                       x .GT. 1
!
50 if (ind .eq. 0) go to 60
   derfc1 = derfc0(x)
   return
60 derfc1 = 0.d0
if (x .gt. 100.d0) return
t = x*x
if (t .gt. -dxparg(1)) return
derfc1 = dexp(-t) * derfc0(x)
return
!
!             Limit value for large negative x
!
80 derfc1 = 2.d0
if (ind .ne. 0) derfc1 = 2.d0*dexp(x*x)
return
end function derfc1

double precision function derfc0 (x)
implicit none
!-----------------------------------------------------------------------
!
!           EVALUATION OF exp(x**2)*erfc(x) FOR x .GE. 1
!
!-----------------------------------------------------------------------
!     WRITTEN BY ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN, VIRGINIA
!        APRIL 1992
!-------------------------------
double precision, intent(in) :: x
double precision :: t, u, v, z, rpinv
double precision :: p0, p1, p2, p3, p4, p5, p6, p7, q1, q2, q3, &
&q4, q5, q6, q7
double precision :: r0, r1, r2, r3, r4, r5, r6, r7, r8
double precision :: a0, a1, a2, a3, a4, a5, a6, a7, a8, b1, b2, &
&b3, b4, b5, b6, b7, b8, b9, b10, b11
double precision :: c0, c1, c2, c3, c4, c5, c6, c7, c8, d1, d2, &
&d3, d4, d5, d6, d7, d8, d9
double precision :: e0, e1, e2, e3
double precision :: s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11
!-------------------------------
!     rpinv = 1/sqrt(pi)
!-------------------------------
data rpinv /.56418958354775628694807945156077259d0/
!-------------------------------
data p0 / .16506148041280876191828601d-03/, &
&p1 / .15471455377139313353998665d-03/, &
&p2 / .44852548090298868465196794d-04/, &
&p3 /-.49177280017226285450486205d-05/, &
&p4 /-.69353602078656412367801676d-05/, &
&p5 /-.20508667787746282746857743d-05/, &
&p6 /-.28982842617824971177267380d-06/, &
&p7 /-.17272433544836633301127174d-07/
data q1  /.16272656776533322859856317d+01/, &
&q2  /.12040996037066026106794322d+01/, &
&q3  /.52400246352158386907601472d+00/, &
&q4  /.14497345252798672362384241d+00/, &
&q5  /.25592517111042546492590736d-01/, &
&q6  /.26869088293991371028123158d-02/, &
&q7  /.13133767840925681614496481d-03/
!-------------------------------
data r0  / .145589721275038539045668824025d+00/, &
&r1  /-.273421931495426482902320421863d+00/, &
&r2  / .226008066916621506788789064272d+00/, &
&r3  /-.163571895523923805648814425592d+00/, &
&r4  / .102604312032193978662297299832d+00/, &
&r5  /-.548023266949835519254211506880d-01/, &
&r6  / .241432239725390106956523668160d-01/, &
&r7  /-.822062115403915116036874169600d-02/, &
&r8  / .180296241564687154310619200000d-02/
!-------------------------------
data a0 /-.45894433406309678202825375d-03/, &
&a1 /-.12281298722544724287816236d-01/, &
&a2 /-.91144359512342900801764781d-01/, &
&a3 /-.28412489223839285652511367d-01/, &
&a4 / .14083827189977123530129812d+01/, &
&a5 / .11532175281537044570477189d+01/, &
&a6 /-.72170903389442152112483632d+01/, &
&a7 /-.19685597805218214001309225d+01/, &
&a8 / .93846891504541841150916038d+01/
data b1 / .25136329960926527692263725d+02/, &
&b2 / .15349442087145759184067981d+03/, &
&b3 /-.29971215958498680905476402d+03/, &
&b4 /-.33876477506888115226730368d+04/, &
&b5 / .28301829314924804988873701d+04/, &
&b6 / .22979620942196507068034887d+05/, &
&b7 /-.24280681522998071562462041d+05/, &
&b8 /-.36680620673264731899504580d+05/, &
&b9 / .42278731622295627627042436d+05/, &
&b10/ .28834257644413614344549790d+03/, &
&b11/ .70226293775648358646587341d+03/
!-------------------------------
data c0 /-.7040906288250128001000086d-04/, &
&c1 /-.3858822461760510359506941d-02/, &
&c2 /-.7708202127512212359395078d-01/, &
&c3 /-.6713655014557429480440263d+00/, &
&c4 /-.2081992124162995545731882d+01/, &
&c5 / .2898831421475282558867888d+01/, &
&c6 / .2199509380600429331650192d+02/, &
&c7 / .2907064664404115316722996d+01/, &
&c8 /-.4766208741588182425380950d+02/
data d1 / .5238852785508439144747174d+02/, &
&d2 / .9646843357714742409535148d+03/, &
&d3 / .7007152775135939601804416d+04/, &
&d4 / .8515386792259821780601162d+04/, &
&d5 /-.1002360095177164564992134d+06/, &
&d6 /-.2065250031331232815791912d+06/, &
&d7 / .5695324805290370358175984d+06/, &
&d8 / .6589752493461331195697873d+06/, &
&d9 /-.1192930193156561957631462d+07/
!-------------------------------
data e0 / .540464821348814822409610122136d+00/, &
&e1 /-.261515522487415653487049835220d-01/, &
&e2 /-.288573438386338758794591212600d-02/, &
&e3 /-.529353396945788057720258856000d-03/
!-------------------------------
!     Coefficients for the asymptotic expansion
!-------------------------------
data s1  / .75000000000000000000d+00/, &
&s2  /-.18750000000000000000d+01/, &
&s3  / .65625000000000000000d+01/, &
&s4  /-.29531250000000000000d+02/, &
&s5  / .16242187500000000000d+03/, &
&s6  /-.10557421875000000000d+04/, &
&s7  / .79180664062500000000d+04/, &
&s8  /-.67303564453125000000d+05/, &
&s9  / .63938386230468750000d+06/, &
&s10 /-.67135305541992187500d+07/, &
&s11 / .77205601373291015625d+08/
!-------------------------------
!
!                     1 .LE. x .LE. 2
!
if (x .gt. 2.d0) go to 10
u = ((((((p7*x + p6)*x + p5)*x + p4)*x + p3)*x + &
&p2)*x + p1)*x + p0
v = ((((((q7*x + q6)*x + q5)*x + q4)*x + q3)*x + &
&q2)*x + q1)*x + 1.d0
!
t = (x - 3.75d0)/(x + 3.75d0)
derfc0 = (((((((((u/v)*t + r8)*t + r7)*t + r6)*t + r5)*t + &
&r4)*t + r3)*t + r2)*t + r1)*t + r0
return
!
!                     2 .LT. x .LE. 4
!
10 if (x .gt. 4.d0) go to 20
z = 1.d0/(2.5d0 + x*x)
u = (((((((a8*z + a7)*z + a6)*z + a5)*z + a4)*z + a3)*z + &
&a2)*z + a1)*z + a0
v = ((((((((((b11*z + b10)*z + b9)*z + b8)*z + b7)*z + b6)*z + &
&b5)*z + b4)*z + b3)*z + b2)*z + b1)*z + 1.d0
!
t = 13.d0*z - 1.d0
derfc0 = ((((u/v)*t + e2)*t + e1)*t + e0)/x
return
!
!                     4 .LT. x .LT. 50
!
20 if (x .ge. 50.d0) go to 30
z = 1.d0/(2.5d0 + x*x)
u = (((((((c8*z + c7)*z + c6)*z + c5)*z + c4)*z + c3)*z + &
&c2)*z + c1)*z + c0
v = ((((((((d9*z + d8)*z + d7)*z + d6)*z + d5)*z + d4)*z + &
&d3)*z + d2)*z + d1)*z + 1.d0
!
t = 13.d0*z - 1.d0
derfc0 = (((((u/v)*t + e3)*t + e2)*t + e1)*t + e0)/x
return
!
!                        x .GE. 50
!
30 t = (1.d0/x)**2
z = (((((((((((s11*t + s10)*t + s9)*t + s8)*t + s7)*t + &
&s6)*t + s5)*t + s4)*t + s3)*t + s2)*t + s1)*t - &
&0.5d0)*t + 1.d0
derfc0 = rpinv*(z/x)
return
end function derfc0

real function erfi (p, q)
implicit none
real, intent(in) :: p, q
real :: c, c1, c2, eps, s, t, v, v1
real :: spmpar
!-----------------------------------------------------------------------
!
!              Evaluation of the inverse error function
!
!                        ---------------
!
!     FOR 0 .LE. p .LT. 1,  W = erfi(p,q) WHERE erf(W) = p. IT IS
!     ASSUMED THAT q = 1 - p.  IF p .LT. 0, q .LE. 0, OR p + q IS
!     not 1, then erfi(p,q) is set to a negative value.
!
!-----------------------------------------------------------------------
!     REFERENCE. MATHEMATICS OF COMPUTATION,OCT.1976,PP.827-830.
!                  J.M.BLAIR,C.A.EDWARDS,J.H.JOHNSON
!-----------------------------------------------------------------------
real :: a(6), b(6), a1(7), b1(7), a2(9), b2(8), a3(9), b3(6)
!-----------------------------------------------------------------------
!     c2 = ln(1.e-100)
!-----------------------------------------------------------------------
data c /.5625/, c1 /.87890625/
data c2 /-.2302585092994046e+03/
!-----------------------------------------------------------------------
!                            Table no.16
!-----------------------------------------------------------------------
data a(1)/.1400216916161353e+03/,  a(2)/-.7204275515686407e+03/, &
&a(3)/.1296708621660511e+04/,  a(4)/-.9697932901514031e+03/, &
&a(5)/.2762427049269425e+03/,  a(6)/-.2012940180552054e+02/
data b(1)/.1291046303114685e+03/,  b(2)/-.7312308064260973e+03/, &
&b(3)/.1494970492915789e+04/,  b(4)/-.1337793793683419e+04/, &
&b(5)/.5033747142783567e+03/,  b(6)/-.6220205554529216e+02/
!-----------------------------------------------------------------------
!                            Table no.36
!-----------------------------------------------------------------------
data a1(1)/-.1690478046781745e+00/, a1(2)/.3524374318100228e+01/, &
&a1(3)/-.2698143370550352e+02/, a1(4)/.9340783041018743e+02/, &
&a1(5)/-.1455364428646732e+03/, a1(6)/.8805852004723659e+02/, &
&a1(7)/-.1349018591231947e+02/
data b1(1)/-.1203221171313429e+00/, b1(2)/.2684812231556632e+01/, &
&b1(3)/-.2242485268704865e+02/, b1(4)/.8723495028643494e+02/, &
&b1(5)/-.1604352408444319e+03/, b1(6)/.1259117982101525e+03/, &
&b1(7)/-.3184861786248824e+02/
!-----------------------------------------------------------------------
!                            Table no.56
!-----------------------------------------------------------------------
data a2(1)/.3100808562552958e-04/, a2(2)/.4097487603011940e-02/, &
&a2(3)/.1214902662897276e+00/, a2(4)/.1109167694639028e+01/, &
&a2(5)/.3228379855663924e+01/, a2(6)/.2881691815651599e+01/, &
&a2(7)/.2047972087262996e+01/, a2(8)/.8545922081972148e+00/, &
&a2(9)/.3551095884622383e-02/
data b2(1)/.3100809298564522e-04/, b2(2)/.4097528678663915e-02/, &
&b2(3)/.1215907800748757e+00/, b2(4)/.1118627167631696e+01/, &
&b2(5)/.3432363984305290e+01/, b2(6)/.4140284677116202e+01/, &
&b2(7)/.4119797271272204e+01/, b2(8)/.2162961962641435e+01/
!-----------------------------------------------------------------------
!                            Table no.79
!-----------------------------------------------------------------------
data a3(1)/.3205405422062050e-08/, a3(2)/.1899479322632128e-05/, &
&a3(3)/.2814223189858532e-03/, a3(4)/.1370504879067817e-01/, &
&a3(5)/.2268143542005976e+00/, a3(6)/.1098421959892340e+01/, &
&a3(7)/.6791143397056208e+00/, a3(8)/-.834334189167721e+00/, &
&a3(9)/.3421951267240343e+00/
data b3(1)/.3205405053282398e-08/, b3(2)/.1899480592260143e-05/, &
&b3(3)/.2814349691098940e-03/, b3(4)/.1371092249602266e-01/, &
&b3(5)/.2275172815174473e+00/, b3(6)/.1125348514036959e+01/
!-----------------------------------------------------------------------
if (p .lt. 0.0 .or. q .le. 0.0) go to 100
eps = amax1(spmpar(1),1.e-15)
t = 0.5 + (0.5 - (p + q))
if (abs(t) .gt. 3.0*eps) go to 110
!
!                      0 .LE. p .LE. 0.75
!
if (p .gt. 0.75) go to 10
v = p*p - c
t = p *  (((((a(6)*v + a(5))*v + a(4))*v + a(3))*v &
&+ a(2))*v + a(1))
s = (((((v + b(6))*v + b(5))*v + b(4))*v + b(3))*v &
&+ b(2))*v + b(1)
go to 40
!
!                    0.75 .LT. p .LE. 0.9375
!
10 if (p .gt. 0.9375) go to 20
v = p*p - c1
t = p *  ((((((a1(7)*v + a1(6))*v + a1(5))*v + a1(4))*v &
&+ a1(3))*v + a1(2))*v + a1(1))
s = ((((((v + b1(7))*v + b1(6))*v + b1(5))*v + b1(4))*v &
&+ b1(3))*v + b1(2))*v + b1(1)
go to 40
!
!                  1.E-100 .LE. q .LT. 0.0625
!
20 v1 = alog(q)
v = 1.0/sqrt(-v1)
if (v1 .lt. c2) go to 30
t = (((((((a2(9)*v + a2(8))*v + a2(7))*v + a2(6))*v + a2(5))*v &
&+ a2(4))*v + a2(3))*v + a2(2))*v + a2(1)
s = v *  ((((((((v + b2(8))*v + b2(7))*v + b2(6))*v + b2(5))*v &
&+ b2(4))*v + b2(3))*v + b2(2))*v + b2(1))
go to 40
!
!                 1.E-10000 .LE. q .LT. 1.E-100
!
30 t = (((((((a3(9)*v + a3(8))*v + a3(7))*v + a3(6))*v + a3(5))*v &
&+ a3(4))*v + a3(3))*v + a3(2))*v + a3(1)
s = v * ((((((v + b3(6))*v + b3(5))*v + b3(4))*v + b3(3))*v &
&+ b3(2))*v + b3(1))
40 erfi = t/s
return
!
!                         Error return
!
100 erfi = -1.0
return
110 erfi = -2.0
return
end function erfi

double precision function derfi (p, q)
implicit none
!-----------------------------------------------------------------------
!
!                  Double precision computation of
!                    the inverse error function
!
!                         ----------------
!
!     FOR 0 .LE. p .LE. 1,  W = derfi(p,q) WHERE erf(W) = p. IT
!     IS ASSUMED THAT q = 1 - p. IF p .LT. 0, q .LE. 0, OR p + q
!     is not 1, then derfi(p,q) is set to a negative value.
!
!-----------------------------------------------------------------------
!     REFERENCE. MATHEMATICS OF COMPUTATION,OCT.1976,PP.827-830.
!                  J.M.BLAIR,C.A.EDWARDS,J.H.JOHNSON
!-----------------------------------------------------------------------
double precision, intent(in) :: p, q
double precision :: c, c1, c2, r, eps, f, lnq, s, t, x
double precision :: a(7), a1(7), a2(7), a3(11), a4(9), b(7), &
&b1(6), b2(6), b3(10), b4(9)
double precision :: dpmpar, derf, derfc1
!-----------------------------------------------------------------------
!     c2 = ln(1.e-100)
!     r  = sqrt(pi)/2
!-----------------------------------------------------------------------
data c /.5625d0/, c1 /.87890625d0/
data c2 /-.2302585092994045684017991454684364d+03/
data r   /.8862269254527580136490837416705726d+00/
!-----------------------
data a(1)/.841467547194693616d-01/, a(2)/.160499904248262200d+01/, &
&a(3)/.809451641478547505d+01/, a(4)/.164273396973002581d+02/, &
&a(5)/.154297507839223692d+02/, a(6)/.669584134660994039d+01/, &
&a(7)/.108455979679682472d+01/
data b(1)/.352281538790042405d-02/, b(2)/.293409069065309557d+00/, &
&b(3)/.326709873508963100d+01/, b(4)/.123611641257633210d+02/, &
&b(5)/.207984023857547070d+02/, b(6)/.170791197367677668d+02/, &
&b(7)/.669253523595376683d+01/
!-----------------------
data a1(1)/.552755110179178015d+2/, a1(2)/.657347545992519152d+3/, &
&a1(3)/.124276851197202733d+4/, a1(4)/.818859792456464820d+3/, &
&a1(5)/.234425632359410093d+3/, a1(6)/.299942187305427917d+2/, &
&a1(7)/.140496035731853946d+1/
data b1(1)/.179209835890172156d+3/, b1(2)/.991315839349539886d+3/, &
&b1(3)/.138271033653003487d+4/, b1(4)/.764020340925985926d+3/, &
&b1(5)/.194354053300991923d+3/, b1(6)/.228139510050586581d+2/
!-----------------------
data a2(1)/.500926197430588206d+1/, a2(2)/.111349802614499199d+3/, &
&a2(3)/.353872732756132161d+3/, a2(4)/.356000407341490731d+3/, &
&a2(5)/.143264457509959760d+3/, a2(6)/.240823237485307567d+2/, &
&a2(7)/.140496035273226366d+1/
data b2(1)/.209004294324106981d+2/, b2(2)/.198607335199741185d+3/, &
&b2(3)/.439311287748524270d+3/, b2(4)/.355415991280861051d+3/, &
&b2(5)/.123303672628828521d+3/, b2(6)/.186060775181898848d+2/
!-----------------------------------------------------------------------
!                       Modified table no.59
!-----------------------------------------------------------------------
data a3(1) /.237121026548776092d4/, a3(2) /.732899958728969905d6/, &
&a3(3) /.182063754893444775d7/, a3(4) /.269191299062422172d7/, &
&a3(5) /.304817224671614253d7/, a3(6) /.130643103351072345d7/, &
&a3(7) /.296799076241952125d6/, a3(8) /.457006532030955554d5/, &
&a3(9) /.373449801680687213d4/, a3(10)/.118062255483596543d3/, &
&a3(11)/.100000329157954960d1/
data b3(1) /.851911109952055378d6/, b3(2) /.194746720192729966d7/, &
&b3(3) /.373640079258593694d7/, b3(4) /.397271370110424145d7/, &
&b3(5) /.339457682064283712d7/, b3(6) /.136888294898155938d7/, &
&b3(7) /.303357770911491406d6/, b3(8) /.459721480357533823d5/, &
&b3(9) /.373762573565814355d4/, b3(10)/.118064334590001264d3/
!-----------------------------------------------------------------------
!                       Modified table no.82
!-----------------------------------------------------------------------
data a4(1)/.154269429680540807d12/, a4(2)/.430207405012067454d12/, &
&a4(3)/.182623446525965017d12/, a4(4)/.248740194409838713d11/, &
&a4(5)/.133506080294978121d10/, a4(6)/.302446226073105850d08/, &
&a4(7)/.285909602878724425d06/, a4(8)/.101789226017835707d04/, &
&a4(9)/.100000004821118676d01/
data b4(1)/.220533001293836387d12/, b4(2)/.347822938010402687d12/, &
&b4(3)/.468373326975152250d12/, b4(4)/.185251723580351631d12/, &
&b4(5)/.249464490520921771d11/, b4(6)/.133587491840784926d10/, &
&b4(7)/.302480682561295591d08/, b4(8)/.285913799407861384d06/, &
&b4(9)/.101789250893050230d04/
!-----------------------------------------------------------------------
if (p .lt. 0.d0 .or. q .le. 0.d0) go to 100
eps = dpmpar(1)
t = 0.5d0 + (0.5d0 - (p + q))
if (dabs(t) .gt. 3.d0*eps) go to 110
!
!                      0 .LE. p .LE. 0.75
!
if (p .gt. 0.75d0) go to 10
x = c - p*p
s = (((((a(1)*x + a(2))*x + a(3))*x + a(4))*x + a(5))*x &
&+ a(6))*x + a(7)
t = ((((((b(1)*x + b(2))*x + b(3))*x + b(4))*x + b(5))*x &
&+ b(6))*x + b(7))*x + 1.d0
derfi = p*(s/t)
if (eps .gt. 1.d-19) return
!
x = derfi
f = derf(x) - p
derfi = x - r * dexp(x*x) * f
return
!
!                    0.75 .LT. p .LE. 0.9375
!
10 if (p .gt. 0.9375d0) go to 40
x = c1 - p*p
if (x .gt. 0.1d0) go to 20
s = ((((((a1(1)*x + a1(2))*x + a1(3))*x + a1(4))*x &
&+ a1(5))*x + a1(6))*x + a1(7))
t = ((((((b1(1)*x + b1(2))*x + b1(3))*x + b1(4))*x &
&+ b1(5))*x + b1(6))*x + 1.d0)
go to 30
!
20 s = ((((((a2(1)*x + a2(2))*x + a2(3))*x + a2(4))*x &
&+ a2(5))*x + a2(6))*x + a2(7))
t = ((((((b2(1)*x + b2(2))*x + b2(3))*x + b2(4))*x &
&+ b2(5))*x + b2(6))*x + 1.d0)
!
30 derfi = p*(s/t)
if (eps .gt. 1.d-19) return
!
x = derfi
t = derfc1(1,x) - dexp(x*x)*q
derfi = x + r * t
return
!
!                  1.E-100 .LE. q .LT. 0.0625
!
40 lnq = dlog(q)
x = 1.d0/dsqrt(- lnq)
if (lnq .lt. c2) go to 50
s = (((((((((a3(1)*x + a3(2))*x + a3(3))*x + a3(4))*x + a3(5))*x &
&+ a3(6))*x + a3(7))*x + a3(8))*x + a3(9))*x &
&+ a3(10))*x + a3(11)
t = (((((((((b3(1)*x + b3(2))*x + b3(3))*x + b3(4))*x + b3(5))*x &
&+ b3(6))*x + b3(7))*x + b3(8))*x + b3(9))*x &
&+ b3(10))*x + 1.d0
go to 60
!
!                 1.E-10000 .LE. q .LT. 1.E-100
!
50 s = (((((((a4(1)*x + a4(2))*x + a4(3))*x + a4(4))*x + a4(5))*x &
&+ a4(6))*x + a4(7))*x + a4(8))*x + a4(9)
t = ((((((((b4(1)*x + b4(2))*x + b4(3))*x + b4(4))*x + b4(5))*x &
&+ b4(6))*x + b4(7))*x + b4(8))*x + b4(9))*x + 1.d0
!
60 derfi = s/(x*t)
if (eps .gt. 5.d-20) return
!
x = derfi
t = derfc1(1,x)
f = (dlog(t) - lnq) - x*x
derfi = x + r*t*f
return
!
!                         Error return
!
100 derfi = -1.d0
return
110 derfi = -2.d0
return
end function derfi

real function aerf (x, h)
implicit none
real, intent(in) :: h, x
integer :: j, n, n1
real :: a2, ah, ax, c, dn2, e, eps, h2, h3, hf, hg, p, s, st, t, &
&u, v, x2, xmh, xph, z
real :: epsln
real :: exparg
real :: spmpar
!-----------------------------------------------------------------------
!             Computation of erf(x + h) - erf(x - h)
!-----------------------------------------------------------------------
!     c = 2/sqrt(pi)
!     p = ln(9*sqrt(pi))
!---------------------
data c /1.12837916709551257/, p /2.76959/
!---------------------
!
!     **** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!          SMALLEST NUMBER SUCH THAT 1.0 + eps .GT. 1.0 .
!
                 eps = spmpar(1)
!
!---------------------
aerf = 0.0
if (h .eq. 0.0) return
!
ah = abs(h)
ax = abs(x)
xph = ax + ah
xmh = ax - ah
!
t = amax1(ah,ax)
t = t*t
if (1.6*t*t .lt. eps) go to 140
if ((ax*ah)**2 .lt. 0.5*eps) go to 150
if (ax .le. ah) go to 100
!
if (xmh .lt. 9.0) go to 5
   if (xmh*xmh + p .gt. -exparg(1)) return
5 if (4.0*ah*ax .gt. -epsln(0)) go to 120
!
if (ax .gt. 3.0*ah) go to 10
if (xph .lt. 1.0) go to 110
go to 130
!-------------------------------------------------
!        For (ax less than or equal to .40)
!-------------------------------------------------
10 e = amax1(1.e-15,eps)
if (ax .gt. 0.40) go to 30
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
  if (abs(t) .gt. e*abs(s)) go to 20
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
  if (abs(hg) .gt. e*abs(s)) go to 35
  if (j .ne. 0) go to 40
  j = 1
  go to 35
40 aerf = u*(s + z)
45 if (h .lt. 0.0) aerf = -aerf
return
!-------------------------------------------------
!        Special cases
!-------------------------------------------------
100 if (xph .lt. 5.8) go to 110
if (xmh .gt. -5.6) go to 120
aerf = sign(2.0,h)
return
!
110 aerf = erf(xph) - erf(xmh)
if (h .lt. 0.0) aerf = -aerf
return
!
120 aerf = erfc(xmh)
if (h .lt. 0.0) aerf = -aerf
return
!
130 aerf = erfc(xmh) - erfc(xph)
if (h .lt. 0.0) aerf = -aerf
return
!
140 aerf = 2.0*c*h*(0.5 + (0.5 - (x*x + h*h/3.0)))
return
!
!     The value is  2.0*exp(-x*x)*erf(h)
!
150 t = 2.0
x2 = x*x
if (x2 .ge. eps) t = 2.0*exp(-x2)
if (h*h .ge. 3.0*eps) go to 160
   aerf = c*h*t
   return
160 aerf = t*erf(h)
return
end function aerf

double precision function daerf (x, h)
implicit none
integer :: j
!-----------------------------------------------------------------------
!             Computation of erf(x + h) - erf(x - h)
!-----------------------------------------------------------------------
double precision, intent(in) :: x, h
double precision :: ah, ax, a2, c, dn2, e, eps, hf, hg, h2, h3, n, &
&n1, p, s, st, t, u, v, xmh, xph, x2, z
double precision :: derf, derfc, dpmpar, depsln, dxparg
!---------------------
!     c = 2/sqrt(pi)
!     p = ln(9*sqrt(pi))
!---------------------
data c /1.12837916709551257389615890312155d0/
data p /2.76959d0/
!---------------------
!
!     **** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!          SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0 .
!
                 eps = dpmpar(1)
!
!---------------------
daerf = 0.d0
if (h .eq. 0.d0) return
!
ah = dabs(h)
ax = dabs(x)
xph = ax + ah
xmh = ax - ah
!
t = dmax1(ah,ax)
t = t*t
if (1.6d0*t*t .lt. eps) go to 140
if ((ax*ah)**2 .lt. 0.5d0*eps) go to 150
if (ax .le. ah) go to 100
!
if (xmh .lt. 9.d0) go to 5
   if (xmh*xmh + p .gt. -dxparg(1)) return
5 if (4.d0*ah*ax .gt. -depsln(0)) go to 120
!
if (ax .gt. 3.d0*ah) go to 10
if (xph .lt. 1.d0) go to 110
go to 130
!-------------------------------------------------
!        For (ax less than or equal to .40)
!-------------------------------------------------
10 e = dmax1(1.d-30,eps)
if (ax .gt. 0.4d0) go to 30
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
  if (dabs(t) .gt. e*dabs(s)) go to 20
s = 0.5d0 + (0.5d0 + s)
daerf = 2.d0*c*ah*s
go to 45
!-------------------------------------------------
!        For (ax greater than .40)
!-------------------------------------------------
30 n = 1.d0
j = 0
h2 = 0.d0
z = dexp(-0.5d0*ax*ax)
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
  if (dabs(hg) .gt. e*dabs(s)) go to 35
  if (j .ne. 0) go to 40
  j = 1
  go to 35
40 daerf = u*(s + z)
45 if (h .lt. 0.d0) daerf = -daerf
return
!-------------------------------------------------
!        Special cases
!-------------------------------------------------
100 if (xph .lt. 8.5d0) go to 110
if (xmh .gt. -8.3d0) go to 120
daerf = dsign(2.d0,h)
return
!
110 daerf = derf(xph) - derf(xmh)
if (h .lt. 0.d0) daerf = -daerf
return
!
120 daerf = derfc(xmh)
if (h .lt. 0.d0) daerf = -daerf
return
!
130 daerf = derfc(xmh) - derfc(xph)
if (h .lt. 0.d0) daerf = -daerf
return
!
140 daerf = 2.d0*c*h*(0.5d0 + (0.5d0 - (x*x + h*h/3.d0)))
return
!
!     The value is  2.0*exp(-x*x)*erf(h)
!
150 t = 2.d0
x2 = x*x
if (x2 .ge. eps) t = 2.d0*dexp(-x2)
if (h*h .ge. 3.d0*eps) go to 160
   daerf = c*h*t
   return
160 daerf = t*derf(h)
return
end function daerf

function pndf(x,ind)
implicit none
integer, intent(in) :: ind
real, intent(in) :: x
real :: a, c, t
real :: pndf
real :: erfc1
!     ---------------
!     a = 1/sqrt(2)
!     c = sqrt(2/pi)
!     ---------------
data a/.707106781186548/
data c/.797884560802865/
!     ---------------
t = a*x
if (ind .ne. 0) go to 20
if (x .lt. -8.0) go to 10
pndf = 0.5*erfc1(0,-t)
return
10 pndf = c/erfc1(1,-t)
return
20 if (x .gt. 8.0) go to 30
pndf = 0.5*erfc1(0,t)
return
30 pndf = c/erfc1(1,t)
return
end function pndf

subroutine pni (p, q, d, w, ierr)
implicit none
integer, intent(inout) :: ierr
real, intent(in) :: d, p, q
real, intent(inout) :: w
real :: eps, rt2, t, u, v
real :: erfi
real :: spmpar
!-----------------------------------------------------------------------
!
!         Evaluation of the inverse normal distribution function
!
!                           ------------
!
!     LET F(t) = 1/(sqrt(2*PI)*exp(-t*t/2)). THEN THE FUNCTION
!
!        PROB(X) = INTEGRAL FROM MINUS INFINITY TO X OF F(t)
!
!     Is the normal distribution function of zero mean and unit
!     VARIANCE. IT IS ASSUMED THAT p .GT. 0, q .GT. 0, p + q = 1,
!     AND d = p - 0.5. THE VALUE w IS COMPUTED WHERE PROB(w) = p.
!
!     ierr is a variable that reports the status of the results.
!
!       ierr = 0  NO INPUT ERRORS WERE DETECTED. w WAS COMPUTED.
!       ierr = 1  EITHER p OR q IS INCORRECT.
!       ierr = 2  d IS INCORRECT.
!
!-----------------------------------------------------------------------
!     rt2 = sqrt(2)
!------------------------
data rt2 /1.414213562373095/
!------------------------
t = amin1(p,q)
if (t .le. 0.0) go to 10
eps = amax1(spmpar(1),1.e-15)
w = 0.5 + (0.5 - (p + q))
if (abs(w) .gt. 2.0*eps) go to 10
!
u = abs(d + d)
v = t + t
w = erfi(u, v)
if (w .lt. 0.0) go to 20
!
ierr = 0
w = rt2*w
if (d .lt. 0.0) w = - w
return
!
!                         Error return
!
10 ierr = 1
return
20 ierr = 2
return
end subroutine pni

subroutine dpni (p, q, d, w, ierr)
implicit none
integer, intent(inout) :: ierr
!-----------------------------------------------------------------------
!
!         Evaluation of the inverse normal distribution function
!
!                           ------------
!
!     LET F(t) = 1/(sqrt(2*PI)*exp(-t*t/2)). THEN THE FUNCTION
!
!        PROB(X) = INTEGRAL FROM MINUS INFINITY TO X OF F(t)
!
!     Is the normal distribution function of zero mean and unit
!     VARIANCE. IT IS ASSUMED THAT p .GT. 0, q .GT. 0, p + q = 1,
!     AND d = p - 0.5. THE VALUE w IS COMPUTED WHERE PROB(w) = p.
!
!     ierr is a variable that reports the status of the results.
!
!       ierr = 0  NO INPUT ERRORS WERE DETECTED. w WAS COMPUTED.
!       ierr = 1  EITHER p OR q IS INCORRECT.
!       ierr = 2  d IS INCORRECT.
!
!-----------------------------------------------------------------------
double precision, intent(in) :: p, q, d
double precision, intent(inout) :: w
double precision :: eps, rt2, u, v, t
double precision :: dpmpar, derfi
!------------------------
!     rt2 = sqrt(2)
!------------------------
data rt2 /1.4142135623730950488016887242097d0/
!------------------------
t = dmin1(p,q)
if (t .le. 0.d0) go to 10
eps = dpmpar(1)
w = 0.5d0 + (0.5d0 - (p + q))
if (dabs(w) .gt. 2.d0*eps) go to 10
!
u = dabs(d + d)
v = t + t
w = derfi(u, v)
if (w .lt. 0.d0) go to 20
!
ierr = 0
w = rt2*w
if (d .lt. 0.d0) w = - w
return
!
!                         Error return
!
10 ierr = 1
return
20 ierr = 2
return
end subroutine dpni

real function daw(x)
implicit none
integer :: i
!-----------------------------------------------------------------------
!
!     This function computes single precision values of dawsons
!     integral,
!
!        exp(-x*x) * integral (from 0 to x) exp(T*T) DT,
!
!     Defined for all real arguments.
!
!     The main computation involves evaluation of rational Chebyshev
!     approximations published in math. Comp. 24, 171-178(1970) By
!     cody, Paciorek and Thacher.
!
!-----------------------------------------------------------------------
real :: p1(9), q1(9), p2(8), q2(7), p3(8), q3(7), p4(7), q4(6), &
&frac, sump, sumq, w2
real, intent(in) :: x
real :: y, xlarge, xsmall
!---------------
data xlarge/16777216.0/, xsmall/.59604644775391e-07/
!---------------
!
!           Coefficients for R(8,8) approximation,
!           USED FOR abs(x)  .LT.  2.5
!
!---------------
data p1(1)/.100000000000000e+01/, p1(2)/-.135599049815353e+00/, &
&p1(3)/.456738974064825e-01/, p1(4)/-.258323495918050e-02/, &
&p1(5)/.360079463580992e-03/, p1(6)/-.944375029163387e-05/, &
&p1(7)/.634674256878843e-06/, p1(8)/-.711645839183817e-08/, &
&p1(9)/.977985913592343e-10/
data q1(1)/.100000000000000e+01/, q1(2)/.531067616851310e+00/, &
&q1(3)/.133052308640737e+00/, q1(4)/.206907491644210e-01/, &
&q1(5)/.220437428972266e-02/, q1(6)/.166706801664365e-03/, &
&q1(7)/.887964712053131e-05/, q1(8)/.311750854173480e-06/, &
&q1(9)/.574807177698046e-08/
!---------------
!
!           Coefficients for R(7,7) approximation,
!           in J-fraction form, used for
!           2.5 .LE. abs(x) .LT. 3.5
!
!---------------
data p2(1)/-.150695651187161e+01/, p2(2)/ .293365747395449e+02/, &
&p2(3)/-.400000893643550e+02/, p2(4)/-.757931918089369e-01/, &
&p2(5)/-.889106479747812e+01/, p2(6)/ .152644099623699e+02/, &
&p2(7)/-.597678086823489e+01/, p2(8)/ .500236896088668e+00/
data q2(1)/-.673106069744813e+00/, q2(2)/ .124486788262252e+04/, &
&q2(3)/ .721193217600229e+01/, q2(4)/ .112461662024575e+03/, &
&q2(5)/ .729177556415532e+02/, q2(6)/ .115840292551888e+03/, &
&q2(7)/ .226064666074309e+00/
!---------------
!
!           Coefficients for R(7,7) approximation,
!           in J-fraction form, used for
!           3.5 .LE. abs(x) .LE. 5.0
!
!---------------
data p3(1)/ .476405645273229e+01/, p3(2)/-.266167674896399e+02/, &
&p3(3)/-.916804879813552e+01/, p3(4)/-.150507703496692e+02/, &
&p3(5)/ .506460153742231e+01/, p3(6)/-.498544802986608e+01/, &
&p3(7)/-.149838042036691e+01/, p3(8)/ .499999902705054e+00/
data q3(1)/ .287776122973187e+03/, q3(2)/ .256105722342226e+02/, &
&q3(3)/ .751701277744067e+02/, q3(4)/ .146515167783109e+03/, &
&q3(5)/ .330707724676114e+02/, q3(6)/-.148715811787195e+01/, &
&q3(7)/ .250011459611839e+00/
!---------------
!
!           Coefficients for R(6,6) approximation,
!           IN J-FRACTION FORM, USED FOR abs(x) .GT. 5.0
!
!---------------
data p4(1)/-.315576735766984e+02/, p4(2)/-.100791496592972e+02/, &
&p4(3)/-.710713709224200e+01/, p4(4)/-.596879853243925e+01/, &
&p4(5)/-.449773645376092e+01/, p4(6)/-.249999965398199e+01/, &
&p4(7)/ .499999999999330e+00/
data q4(1)/ .168874162155616e+03/, q4(2)/ .698280748271071e+01/, &
&q4(3)/-.213029621139181e+02/, q4(4)/-.712157348463305e+01/, &
&q4(5)/-.250005973192356e+01/, q4(6)/ .750000000715687e+00/
!-----------------------------------------------------------------------
!
if (abs(x) .gt. xlarge) go to 500
if (abs(x) .lt. xsmall) go to 600
y = x * x
if (y .ge. 6.25e0) go to 200
!
!     ---------- abs(x) .LT. 2.5 ----------
!
sump = (((((((p1(9) * y + p1(8)) * y + p1(7)) * y + p1(6)) &
&* y + p1(5)) * y + p1(4)) * y + p1(3)) * y + p1(2)) &
&* y + p1(1)
sumq = (((((((q1(9) * y + q1(8)) * y + q1(7)) * y + q1(6)) &
&* y + q1(5)) * y + q1(4)) * y + q1(3)) * y + q1(2)) &
&* y + q1(1)
daw = x * sump / sumq
go to 1000
!
!     ---------- 2.5 .LE. abs(x) .LT. 3.5 ----------
!
200 if (y .ge. 12.25e0) go to 300
frac = 0.0e0
!
do 220 i = 1, 7
220 frac = q2(i) / (p2(i) + y + frac)
!
daw = (p2(8) + frac) / x
go to 1000
!
!     ---------- 3.5 .LE. abs(x) .LT. 5.0 ----------
!
300 if (y .ge. 25.0e0) go to 400
frac = 0.0e0
!
do 320 i = 1, 7
320 frac = q3(i) / (p3(i) + y + frac)
!
daw = (p3(8) + frac) / x
go to 1000
!
!     ---------- 5.0 .LE. abs(x) .LE. xlarge ----------
!
400 w2 = 1.0e0 / x / x
frac = 0.0e0
!
do 420 i = 1, 6
420 frac = q4(i) / (p4(i) + y + frac)
!
frac = p4(7) + frac
daw = (0.5e0 + 0.5e0 * w2 * frac) / x
go to 1000
!
!     ---------- xlarge .LT. abs(x) ----------
!
500 daw = 0.5e0 / x
go to 1000
!
!     ---------- Return for small x ----------
!
600 daw = x
!
1000 return
end function daw

double precision function dpdaw (x)
implicit none
integer :: i, k
!-----------------------------------------------------------------------
!            Double precision computation of dawsons integral
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: a(20), b(45), ax, eps, t, w
double precision :: dcsevl, dpdaw0
!----------------------------
data eps /1.d-31/
!----------------------------
data a(1)  /-.6666666666666666666666666666657d+00/, &
&a(2)  / .2666666666666666666666666665302d+00/, &
&a(3)  /-.7619047619047619047619046823290d-01/, &
&a(4)  / .1693121693121693121693097101950d-01/, &
&a(5)  /-.3078403078403078403073750370528d-02/, &
&a(6)  / .4736004736004736004148385001356d-03/, &
&a(7)  /-.6314672981339647953899064401849d-04/, &
&a(8)  / .7429027036870170692270376716931d-05/, &
&a(9)  /-.7820028459863171536925638117632d-06/, &
&a(10) / .7447646152244351276445219666744d-07/
data a(11) /-.6476214045244314289022051868963d-08/, &
&a(12) / .5180971231894821888421654461823d-09/, &
&a(13) /-.3837756389504541092817011259727d-10/, &
&a(14) / .2646727414301012080897585412600d-11/, &
&a(15) /-.1707553348198261876085879075486d-12/, &
&a(16) / .1034770025122653524451023758330d-13/, &
&a(17) /-.5905667147861158816695814259561d-15/, &
&a(18) / .3157018166820009192834256496230d-16/, &
&a(19) /-.1501742103181747984387915732309d-17/, &
&a(20) / .4921379778280206677674574916266d-19/
!----------------------------
data b(1)  /-.56886544105215527114160533733674d-01/, &
&b(2)  /-.31811346996168131279322878048822d+00/, &
&b(3)  / .20873845413642236789741580198858d+00/, &
&b(4)  /-.12475409913779131214073498314784d+00/, &
&b(5)  / .67869305186676777092847516423676d-01/, &
&b(6)  /-.33659144895270939503068230966587d-01/, &
&b(7)  / .15260781271987971743682460381640d-01/, &
&b(8)  /-.63483709625962148230586094788535d-02/, &
&b(9)  / .24326740920748520596865966109343d-02/, &
&b(10) /-.86219541491065032038526983549637d-03/
data b(11) / .28376573336321625302857636538295d-03/, &
&b(12) /-.87057549874170423699396581464335d-04/, &
&b(13) / .24986849985481658331800044137276d-04/, &
&b(14) /-.67319286764160294344603050339520d-05/, &
&b(15) / .17078578785573543710504524047844d-05/, &
&b(16) /-.40917551226475381271896592490038d-06/, &
&b(17) / .92828292216755773260751785312273d-07/, &
&b(18) /-.19991403610147617829845096332198d-07/, &
&b(19) / .40963490644082195241210487868917d-08/, &
&b(20) /-.80032409540993168075706781753561d-09/
data b(21) / .14938503128761465059143225550110d-09/, &
&b(22) /-.26687999885622329284924651063339d-10/, &
&b(23) / .45712216985159458151405617724103d-11/, &
&b(24) /-.75187305222043565872243727326771d-12/, &
&b(25) / .11893100052629681879029828987302d-12/, &
&b(26) /-.18116907933852346973490318263084d-13/, &
&b(27) / .26611733684358969193001612199626d-14/, &
&b(28) /-.37738863052129419795444109905930d-15/, &
&b(29) / .51727953789087172679680082229329d-16/, &
&b(30) /-.68603684084077500979419564670102d-17/
data b(31) / .88123751354161071806469337321745d-18/, &
&b(32) /-.10974248249996606292106299624652d-18/, &
&b(33) / .13261199326367178513595545891635d-19/, &
&b(34) /-.15562732768137380785488776571562d-20/, &
&b(35) / .17751425583655720607833415570773d-21/, &
&b(36) /-.19695006967006578384953608765439d-22/, &
&b(37) / .21270074896998699661924010120533d-23/, &
&b(38) /-.22375398124627973794182113962666d-24/, &
&b(39) / .22942768578582348946971383125333d-25/, &
&b(40) /-.22943788846552928693329592319999d-26/
data b(41) / .22391702100592453618342297600000d-27/, &
&b(42) /-.21338230616608897703678225066666d-28/, &
&b(43) / .19866196585123531518028458666666d-29/, &
&b(44) /-.18079295866694391771955199999999d-30/, &
&b(45) / .16090686015283030305450666666666d-31/
!----------------------------
ax = dabs(x)
if (ax .ge. 4.d0) go to 30
t = x*x
if (ax .gt. 1.d0) go to 20
!
!                       abs(x) .LE. 1
!
dpdaw = x
if (t .lt. eps) return
!
w = a(20)
do 10 i = 1,19
   k = 20 - i
   w = t*w + a(k)
10 continue
dpdaw = x * (0.75d0 + (0.25d0 + t*w))
return
!
!                    1 .LT. abs(x) .LT. 4
!
20 dpdaw = x * (.25d0 + dcsevl(.125d0*t - 1.d0, b, 45))
return
!
!                       abs(x) .GE. 4
!
30 dpdaw = dpdaw0(ax)/x
return
end function dpdaw

double precision function dpdaw0 (x)
implicit none
!-----------------------------------------------------------------------
!
!                EVALUATION OF x*daw(x) FOR x .GE. 4
!                where daw(x) is the Dawson integral
!
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: t, u, v, w
double precision :: a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, &
&a11, a12, a13, a14, a15, a16, a17, a18, b1, b2, b3, b4
double precision :: c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, &
&c11, c12, c13, c14, d1, d2, d3, d4, d5, d6, d7, d8
double precision :: e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, &
&f1, f2, f3, f4, f5, f6, f7, f8, f9, f10
double precision :: g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, &
&g11, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10
double precision :: s0, s1, s2, s3, s4, s5
double precision :: p0, p1, p2, p3, p4, p5, q1, q2, q3, q4, q5
!----------------------------
data a0  / .59682223611279114961181337d-06/, &
&a1  / .17685355947137064277328544d-05/, &
&a2  / .46539151619719879425847199d-05/, &
&a3  / .60206549750426063518629015d-05/, &
&a4  / .71968323029042065431569341d-05/, &
&a5  / .30632314265730271259576310d-05/, &
&a6  / .58023977792358623878717970d-06/, &
&a7  /-.79009104459686847104040749d-06/, &
&a8  /-.48136647436848802449955585d-06/, &
&a9  / .15516701696125663593787151d-05/
data a10 / .41907470564012404920368069d-05/, &
&a11 / .58027971313506864533128271d-05/, &
&a12 / .55370618938769991926278955d-05/, &
&a13 / .38921890500515083447099834d-05/, &
&a14 / .20373391058442140223632125d-05/, &
&a15 / .77894504402267231707108862d-06/, &
&a16 / .20671717275442647450228015d-06/, &
&a17 / .34163346266402336952767687d-07/, &
&a18 / .26550833614486808486653527d-08/
!----------------------------
data b1  / .24655153970246619491575782d+01/, &
&b2  / .62943144539382480033771054d+01/, &
&b3  / .62122304537339562619049238d+01/, &
&b4  / .72256247680648550388609993d+01/
!----------------------------
data c0  / .59682220964671964619429990d-06/, &
&c1  / .15714896176335781761895194d-05/, &
&c2  / .38969553030269966874001463d-05/, &
&c3  / .52383725295173020317044495d-05/, &
&c4  / .68105053752194312932660379d-05/, &
&c5  / .54424292166005622934118953d-05/, &
&c6  / .42426204827598626398351706d-05/, &
&c7  / .16034175582037599078896885d-05/, &
&c8  / .40869743822567069272296881d-06/, &
&c9  /-.28877279517645392833652391d-06/
data c10 /-.23330912423546272053845073d-06/, &
&c11 /-.52391219684126122047201575d-07/, &
&c12 / .21002079856304960793765863d-07/, &
&c13 / .15999459808634652894884878d-07/, &
&c14 / .30942877932880022278704223d-08/
!----------------------------
data d1  / .21353586303464124681525146d+01/, &
&d2  / .51903635881846225790635588d+01/, &
&d3  / .55426108503039000945912263d+01/, &
&d4  / .72404445472735688881512590d+01/, &
&d5  / .42043425514299588216548098d+01/, &
&d6  / .39555198251457455938284071d+01/, &
&d7  / .96558431899415447517392039d+00/, &
&d8  / .85802563214754700974536646d+00/
!----------------------------
data e0  / .59682220964671964619429989d-06/, &
&e1  / .84093250039847132132545694d-06/, &
&e2  / .21215362314612857942015465d-05/, &
&e3  / .17544801458346344458699925d-05/, &
&e4  / .23300467572238537581015267d-05/, &
&e5  / .10789302963153438789721000d-05/, &
&e6  / .84593690165753140097573765d-06/, &
&e7  / .58921927492401852305814815d-07/, &
&e8  / .88699252882391671775568852d-08/, &
&e9  /-.45367333700483839577191791d-07/
data e10 /-.57476692572774473717756092d-08/
!----------------------------
data f1  / .91128032791938035312580060d+00/, &
&f2  / .28248447610354665352098820d+01/, &
&f3  / .12208226691968579661669930d+01/, &
&f4  / .26127044898109340807106578d+01/, &
&f5  / .34850941500747816686718301d+00/, &
&f6  / .11058424028893031129155960d+01/, &
&f7  /-.58583432304677947215235382d-01/, &
&f8  / .22235753204903993496120223d+00/, &
&f9  /-.22116625272550591073419658d-01/, &
&f10 / .14938281115881437851795141d-01/
!----------------------------
data g0  / .59682220962853689178993039d-06/, &
&g1  / .10399202637216492921747166d-05/, &
&g2  / .20011159669496258291170369d-05/, &
&g3  / .19689301951834731308289277d-05/, &
&g4  / .18861506874082130108404839d-05/, &
&g5  / .10403672611266773427898830d-05/, &
&g6  / .42700287233074049241986613d-06/, &
&g7  /-.16199303908856237550380048d-07/, &
&g8  /-.73900110466591484816182863d-07/, &
&g9  /-.21369058482679700785965255d-07/
data g10 / .42853587024761116737793072d-08/, &
&g11 /-.27226352610679391576406666d-09/
!----------------------------
data h1  / .12446924554654251972427023d+01/, &
&h2  / .24571243397858142676189669d+01/, &
&h3  / .16710488988253927773151334d+01/, &
&h4  / .17260859791081983044753913d+01/, &
&h5  / .67406536368694046314885196d+00/, &
&h6  / .47403526893401885333000527d+00/, &
&h7  / .96251479080923959509108658d-01/, &
&h8  / .53334517885765587426678624d-01/, &
&h9  / .39450307003297031975491216d-02/, &
&h10 / .20209221166462656808887976d-02/
!----------------------------
data s0  / .8210986449041747719684610504710d-02/, &
&s1  / .8646073144815053170065230898334d-02/, &
&s2  / .4768322737615973285410030924398d-03/, &
&s3  / .4792593707378225992657970685396d-04/, &
&s4  / .7507677744363576693833551190204d-05/, &
&s5  / .1737929446861228512373840727547d-05/
!----------------------------
data p0 / .29531250000000000000002d+02/, &
&p1 /-.14571781607273299440392d+04/, &
&p2 / .24285318385898860175073d+05/, &
&p3 /-.15843555052114168113822d+06/, &
&p4 / .32969397422638395586636d+06/, &
&p5 /-.55331506994311967089636d+04/
data q1 /-.54843599093412230906873d+02/, &
&q2 / .10882497826844164906477d+04/, &
&q3 /-.96578534881552358457185d+04/, &
&q4 / .37803382357862589384458d+05/, &
&q5 /-.51283783372259864777146d+05/
!----------------------------
if (x .ge. 12.d0) go to 50
t = (32.d0/(x*x) - 0.5d0) - 0.5d0
if (t .ge. 0.d0) go to 20
!
!                    -7/9 .LE. t .LE. -0.4
!
if (t .gt. -0.4d0) go to 10
u = ((((((((a18*t + a17)*t + a16)*t + a15)*t + a14)*t + &
&a13)*t + a12)*t + a11)*t + a10)*t + a9
u = ((((((((u*t + a8)*t + a7)*t + a6)*t + a5)*t + &
&a4)*t + a3)*t + a2)*t + a1)*t + a0
v = (((b4*t + b3)*t + b2)*t + b1)*t + 1.d0
go to 40
!
!                     -0.4 .LT. t .LT. 0
!
10 u = ((((((((c14*t + c13)*t + c12)*t + c11)*t + c10)*t + &
&c9)*t + c8)*t + c7)*t + c6)*t + c5
u = ((((u*t + c4)*t + c3)*t + c2)*t + c1)*t + c0
v = (((((((d8*t + d7)*t + d6)*t + d5)*t + d4)*t + &
&d3)*t + d2)*t + d1)*t + 1.d0
go to 40
!
!                      0 .LE. t .LE. 0.4
!
20 if (t .gt. 0.4d0) go to 30
u = (((((((((e10*t + e9)*t + e8)*t + e7)*t + e6)*t + &
&e5)*t + e4)*t + e3)*t + e2)*t + e1)*t + e0
v = (((((((((f10*t + f9)*t + f8)*t + f7)*t + f6)*t + &
&f5)*t + f4)*t + f3)*t + f2)*t + f1)*t + 1.d0
go to 40
!
!                      0.4 .LT. t .LE. 1
!
30 u = ((((((((g11*t + g10)*t + g9)*t + g8)*t + g7)*t + &
&g6)*t + g5)*t + g4)*t + g3)*t + g2
u = (u*t + g1)*t + g0
v = (((((((((h10*t + h9)*t + h8)*t + h7)*t + h6)*t + &
&h5)*t + h4)*t + h3)*t + h2)*t + h1)*t + 1.d0
!
!          The above four minimax approximations u/v
!          are accurate to within 1 unit of the 25-TH
!          significant digit. Thus, the approximation
!          for w is accurate to within 1 unit of the
!          29-TH significant digit.
!
40 w = ((((((u/v)*t + s5)*t + s4)*t + s3)*t + s2)*t + &
&s1)*t + s0
dpdaw0 = 0.5d0 + w
return
!
!                          x .GE. 12
!
50 t = (1.d0/x)**2
w = (((((p5*t + p4)*t + p3)*t + p2)*t + p1)*t + p0)/ &
&(((((q5*t + q4)*t + q3)*t + q2)*t + q1)*t + 1.d0)
w = ((((w*t + 6.5625d0)*t + 1.875d0)*t + 0.75d0)*t + &
&0.5d0)*t + 1.d0
dpdaw0 = 0.5d0*w
return
end function dpdaw0

subroutine cfrnli (mo, z, w)
implicit none
integer, intent(in) :: mo
integer :: i
real :: c, c0, dm, pm, qm, r, ss, x, y
real :: exparg
real :: cpabs
!-----------------------------------------------------------------------
!
!            Computation of the complex fresnel integral E(z)
!
!                           ----------------
!
!                      w = E(z)          IF mo = 0
!                      w = exp(-z)*e(z)  otherwise
!
!-----------------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: w
real :: cd(18), ce(18), qf(2), sm(2), tm(2), ts(2), zr(2)
!------------------------
!     c = 1/sqrt(pi)
!     c0 = -1/sqrt(2)
!------------------------
data c  / .564189583547756/
data c0 /-.707106781186548/
!------------------------
data cd(1) /0.00000000000000e00/,  cd(2) /2.08605856013476e-2/, &
&cd(3) /8.29806940495687e-2/,  cd(4) /1.85421653326079e-1/, &
&cd(5) /3.27963479382361e-1/,  cd(6) /5.12675279912828e-1/, &
&cd(7) /7.45412958045105e-1/,  cd(8) /1.03695067418297e00/, &
&cd(9) /1.40378061255437e00/,  cd(10)/1.86891662214001e00/, &
&cd(11)/2.46314830523929e00/,  cd(12)/3.22719383737352e00/, &
&cd(13)/4.21534348280013e00/,  cd(14)/5.50178873151549e00/, &
&cd(15)/7.19258966683102e00/,  cd(16)/9.45170208076408e00/, &
&cd(17)/1.25710718314784e+1/,  cd(18)/1.72483537216334e+1/
data ce(1) /8.15723083324096e-2/,  ce(2) /1.59285285253437e-1/, &
&ce(3) /1.48581625614499e-1/,  ce(4) /1.33219670836245e-1/, &
&ce(5) /1.15690392878957e-1/,  ce(6) /9.78580959447535e-2/, &
&ce(7) /8.05908834297624e-2/,  ce(8) /6.40204538609872e-2/, &
&ce(9) /4.81445242767885e-2/,  ce(10)/3.33540658473295e-2/, &
&ce(11)/2.05548099470193e-2/,  ce(12)/1.07847403887506e-2/, &
&ce(13)/4.55634892214219e-3/,  ce(14)/1.43984458138925e-3/, &
&ce(15)/3.07056139834171e-4/,  ce(16)/3.78156541168541e-5/, &
&ce(17)/2.05173509616121e-6/,  ce(18)/2.63564823682747e-8/
!------------------------
x = real(z)
y = aimag(z)
r = cpabs(x, y)
if (r .eq. 0.0) go to 200
!
!              EVALUATION OF zr = sqrt(2*z/PI)
!
if (x .ge. 0.0) go to 10
   zr(2) = sqrt(r - x)
   zr(1) = y/zr(2)
   go to 11
10 zr(1) = sqrt(r + x)
if (y .lt. 0.0) zr(1) = -zr(1)
zr(2) = y/zr(1)
11 zr(1) = c*zr(1)
zr(2) = c*zr(2)
!
if (r .le. 1.0) go to 20
if (r .ge. 38.0) go to 60
if (x .lt. 0.016*y*y) go to 50
!
!                       Taylor series
!
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
   if (abs(sm(1)) + abs(ts(1)) .ne. abs(sm(1))) go to 31
   if (abs(sm(2)) + abs(ts(2)) .eq. abs(sm(2))) go to 40
31 sm(1) = sm(1) + ts(1)
   sm(2) = sm(2) + ts(2)
   go to 30
40 sm(1) = zr(1) + sm(1)
sm(2) = (c0 + zr(2)) + sm(2)
!
if (mo .eq. 0) go to 120
qm = exp(-x)
qf(1) = qm*cos(-y)
qf(2) = qm*sin(-y)
go to 110
!
!              Rational function APPROXIMATION
!
50 sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = x - cd(i)
   ts(2) = y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) =  ce(i)*ts(1)/ss
   tm(2) = -ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ts(1) = zr(1)*sm(1) - zr(2)*sm(2)
ts(2) = zr(1)*sm(2) + zr(2)*sm(1)
sm(1) = 0.5*ts(1)
sm(2) = 0.5*ts(2)
go to 100
!
!                   Asymptotic expansion
!
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
   if (abs(sm(1)) + abs(tm(1)) .ne. abs(sm(1))) go to 71
   if (abs(sm(2)) + abs(tm(2)) .eq. abs(sm(2))) go to 80
71 sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
   if (pm .lt. 25.5) go to 70
80 ts(1) = zr(1)*sm(1) - zr(2)*sm(2)
ts(2) = zr(1)*sm(2) + zr(2)*sm(1)
sm(1) = 0.5*ts(1)
sm(2) = 0.5*ts(2)
if (zr(2) .lt. 8.e-3) go to 210
!
!                       Termination
!
100 if (mo .ne. 0) go to 120
qm = exp(x)
qf(1) = qm*cos(y)
qf(2) = qm*sin(y)
!
110 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
!
120 w = cmplx(sm(1),sm(2))
return
!
!                      CASE WHEN z = 0
!
200 w = cmplx(0.0,c0)
return
!
!               Modified asymptotic expansion
!
210 if (mo .ne. 0) go to 220
qm = exp(x)
qf(1) = qm*cos(y)
qf(2) = qm*sin(y)
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
w = cmplx(ts(1), c0 + ts(2))
return
!
220 if (-x .le. exparg(1)) go to 120
qm = c0*exp(-x)
sm(1) = sm(1) + qm*sin(y)
sm(2) = sm(2) + qm*cos(y)
w = cmplx(sm(1),sm(2))
return
end subroutine cfrnli

subroutine frnl (t, c, s)
implicit none
real, intent(inout) :: c, s
real, intent(in) :: t
integer :: i, l, m, max
real :: cy, f, fd, fn, g, gd, gn, pi, pix, pixx, r, sy, x, xx, y
real :: sin1
real :: cos1
integer :: ipmpar
!-----------------------------------------------------------------------
!             Evaluation of the real fresnel integrals
!-----------------------------------------------------------------------
real :: n
real :: a(6), b(6), cp(13), sp(13)
real :: pn(6), pd(6), qn(6), qd(6)
real :: an(6), ad(6), bn(6), bd(6)
real :: cn(5), cd(5), dn(5), dd(5)
real :: fp(7), gp(7), p(6), q(6)
!--------------------------
data pi/3.1415926535898/
!--------------------------
data a(1)/-.119278241233760e-05/,  a(2)/.540730666359417e-04/, &
&a(3)/-.160488306381990e-02/,  a(4)/.281855008757077e-01/, &
&a(5)/-.246740110027210e+00/,  a(6)/.100000000000000e+01/
data b(1)/-.155653074871090e-06/,  b(2)/.844415353045065e-05/, &
&b(3)/-.312116934326082e-03/,  b(4)/.724478420395276e-02/, &
&b(5)/-.922805853580325e-01/,  b(6)/.523598775598300e+00/
!--------------------------
data cp(1) /.114739945188034e-20/,  cp(2) /-.384444827287950e-18/, &
&cp(3) /.832125729394275e-16/,  cp(4) /-.142979507360076e-13/, &
&cp(5) /.198954961821465e-11/,  cp(6) /-.220226545457144e-09/, &
&cp(7) /.188434924092257e-07/,  cp(8) /-.120009722914157e-05/, &
&cp(9) /.540741337442140e-04/,  cp(10)/-.160488313553028e-02/, &
&cp(11)/.281855008777956e-01/,  cp(12)/-.246740110027196e+00/, &
&cp(13)/.999999999999996e+00/
data sp(1) /.705700784853927e-22/,  sp(2) /-.252757991492418e-19/, &
&sp(3) /.594117488940008e-17/,  sp(4) /-.112161631555448e-14/, &
&sp(5) /.173332189994074e-12/,  sp(6) /-.215742302078015e-10/, &
&sp(7) /.210821173208116e-08/,  sp(8) /-.156471443116560e-06/, &
&sp(9) /.844427287845253e-05/,  sp(10)/-.312116942346186e-03/, &
&sp(11)/.724478420418951e-02/,  sp(12)/-.922805853580323e-01/, &
&sp(13)/.523598775598300e+00/
!--------------------------
data pn(1)/.318309816100920e+00/,  pn(2)/.134919391391516e+02/, &
&pn(3)/.158258097490377e+03/,  pn(4)/.598796451682535e+03/, &
&pn(5)/.632369782194966e+03/,  pn(6)/.967985390141920e+02/
data pd(1)/.100000000000000e+01/,  pd(2)/.426900960480796e+02/, &
&pd(3)/.509085485682426e+03/,  pd(4)/.200034664144742e+04/, &
&pd(5)/.231910140792937e+04/,  pd(6)/.486678558201084e+03/
data qn(1)/.101320876178478e+00/,  qn(2)/.490534697099052e+01/, &
&qn(3)/.652095157811808e+02/,  qn(4)/.274183825747887e+03/, &
&qn(5)/.305040725009211e+03/,  qn(6)/.364566615872326e+02/
data qd(1)/.100000000000000e+01/,  qd(2)/.499330024470621e+02/, &
&qd(3)/.709854097670206e+03/,  qd(4)/.343470762861172e+04/, &
&qd(5)/.522213879312684e+04/,  qd(6)/.168801831831851e+04/
!--------------------------
data an(1)/.318309885869756e+00/,  an(2)/.254179177393500e+02/, &
&an(3)/.575003792540838e+03/,  an(4)/.426673405867140e+04/, &
&an(5)/.891831887923938e+04/,  an(6)/.267955736537967e+04/
data ad(1)/.100000000000000e+01/,  ad(2)/.801567066285184e+02/, &
&ad(3)/.182971463354850e+04/,  ad(4)/.138848884373420e+05/, &
&ad(5)/.309228411873207e+05/,  ad(6)/.120421274105856e+05/
data bn(1)/.101321181932417e+00/,  bn(2)/.925021984290547e+01/, &
&bn(3)/.240932023056602e+03/,  bn(4)/.206079616836437e+04/, &
&bn(5)/.484901973010149e+04/,  bn(6)/.130680669688315e+04/
data bd(1)/.100000000000000e+01/,  bd(2)/.928158182389149e+02/, &
&bd(3)/.250926840439955e+04/,  bd(4)/.233924458152954e+05/, &
&bd(5)/.685638896406835e+05/,  bd(6)/.418593101455019e+05/
!--------------------------
data cn(1)/.318309886182000e+00/,  cn(2)/.299191968327887e+02/, &
&cn(3)/.691428839605668e+03/,  cn(4)/.394539800974744e+04/, &
&cn(5)/.290314254767015e+04/
data cd(1)/.100000000000000e+01/,  cd(2)/.942978925136851e+02/, &
&cd(3)/.219977296283666e+04/,  cd(4)/.129726479671006e+05/, &
&cd(5)/.114991427758165e+05/
data dn(1)/.101321183630876e+00/,  dn(2)/.110988033615242e+02/, &
&dn(3)/.306282306497228e+03/,  dn(4)/.213130259794164e+04/, &
&dn(5)/.171270676541694e+04/
data dd(1)/.100000000000000e+01/,  dd(2)/.111060616085627e+03/, &
&dd(3)/.318197586347414e+04/,  dd(4)/.249342095714049e+05/, &
&dd(5)/.359241903823488e+05/
!--------------------------
data fp(1)/.449763389301234e+05/,  fp(2)/-.188763642051836e+04/, &
&fp(3)/.669261097103246e+02/,  fp(4)/-.343966606879114e+01/, &
&fp(5)/.343112896133346e+00/,  fp(6)/-.967546019461500e-01/, &
&fp(7)/.318309886183465e+00/
data gp(1)/.316642183365360e+06/,  gp(2)/-.120618995106638e+05/, &
&gp(3)/.359164749179351e+03/,  gp(4)/-.142252603258172e+02/, &
&gp(5)/.982934118445454e+00/,  gp(6)/-.153989722912325e+00/, &
&gp(7)/.101321183639714e+00/
!--------------------------
data p(1)/-654729075.0/,  p(2)/2027025.0/,  p(3)/-10395.0/, &
&p(4)/105.0/,  p(5)/-3.0/,  p(6)/1.0/
data q(1)/-13749310575.0/,  q(2)/34459425.0/,  q(3)/-135135.0/, &
&q(4)/945.0/,  q(5)/-15.0/,  q(6)/1.0/
!--------------------------
!
!     ****** max IS A MACHINE DEPENDENT CONSTANT. MAX IS THE
!            largest positive integer that may be used.
!
               max = ipmpar(3)
!
!-----------------------------------------------------------------------
x = abs(t)
if (x .gt. 4.0) go to 50
xx = x*x
y = xx*xx
!-----------------------------------------------------------------------
!             EVALUATION OF c(x) AND s(x) FOR x .LT. 1.65
!                          WHERE x = abs(t)
!-----------------------------------------------------------------------
if (x .gt. 0.6) go to 10
c = ((((a(1)*y + a(2))*y + a(3))*y + a(4))*y + a(5))*y + a(6)
s = ((((b(1)*y + b(2))*y + b(3))*y + b(4))*y + b(5))*y + b(6)
c = t*c
s = t*xx*s
return
!
10 if (x .ge. 1.65) go to 20
c = cp(1)
s = sp(1)
do 11 i = 2,13
   c = cp(i) + c*y
11 s = sp(i) + s*y
c = t*c
s = t*xx*s
return
!-----------------------------------------------------------------------
!          Evaluation of the auxiliary functions f(x) and g(x)
!                        FOR x .GE. 1.65
!-----------------------------------------------------------------------
20 if (x .ge. 2.0) go to 30
fn = ((((pn(1)*y + pn(2))*y + pn(3))*y + pn(4))*y + pn(5))*y &
&+ pn(6)
fd = ((((pd(1)*y + pd(2))*y + pd(3))*y + pd(4))*y + pd(5))*y &
&+ pd(6)
gn = ((((qn(1)*y + qn(2))*y + qn(3))*y + qn(4))*y + qn(5))*y &
&+ qn(6)
gd = ((((qd(1)*y + qd(2))*y + qd(3))*y + qd(4))*y + qd(5))*y &
&+ qd(6)
f = fn/(x*fd)
g = gn/(x*xx*gd)
y = 0.5*xx
go to 80
!
30 if (x .ge. 3.0) go to 40
fn = ((((an(1)*y + an(2))*y + an(3))*y + an(4))*y + an(5))*y &
&+ an(6)
fd = ((((ad(1)*y + ad(2))*y + ad(3))*y + ad(4))*y + ad(5))*y &
&+ ad(6)
gn = ((((bn(1)*y + bn(2))*y + bn(3))*y + bn(4))*y + bn(5))*y &
&+ bn(6)
gd = ((((bd(1)*y + bd(2))*y + bd(3))*y + bd(4))*y + bd(5))*y &
&+ bd(6)
f = fn/(x*fd)
g = gn/(x*xx*gd)
go to 70
!
40 fn = (((cn(1)*y + cn(2))*y + cn(3))*y + cn(4))*y + cn(5)
fd = (((cd(1)*y + cd(2))*y + cd(3))*y + cd(4))*y + cd(5)
gn = (((dn(1)*y + dn(2))*y + dn(3))*y + dn(4))*y + dn(5)
gd = (((dd(1)*y + dd(2))*y + dd(3))*y + dd(4))*y + dd(5)
f = fn/(x*fd)
g = gn/(x*xx*gd)
go to 70
!
50 if (x .ge. 6.0) go to 60
xx = x*x
y = 1.0/(xx*xx)
f = (((((fp(1)*y + fp(2))*y + fp(3))*y + fp(4))*y + fp(5))*y &
&+ fp(6))*y + fp(7)
g = (((((gp(1)*y + gp(2))*y + gp(3))*y + gp(4))*y + gp(5))*y &
&+ gp(6))*y + gp(7)
f = f/x
g = g/(x*xx)
go to 70
!
60 if (x .ge. float(max)) go to 100
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
!
y = y*n
m = y
y = y - m
if (mod(m,2) .ne. 0) y = (y - 0.5) - 0.5
y = y + 0.5*r*r
!
80 sy = sin1(y)
cy = cos1(y)
!-----------------------------------------------------------------------
!                             Termination
!-----------------------------------------------------------------------
90 c = 0.5 + (f*sy - g*cy)
s = 0.5 - (f*cy + g*sy)
if (t .ge. 0.0) return
   c = - c
   s = - s
   return
!
100 if (t .lt. 0.0) go to 110
   c = 0.5
   s = 0.5
   return
110 c = -0.5
s = -0.5
return
end subroutine frnl

subroutine cexpli (mo, z, w)
implicit none
integer, intent(in) :: mo
integer :: i
real :: c, cy, d, e, eps, euler, pi, qm, r, ss, sy, tol, u, x, y
real :: anorm
real :: spmpar
real :: cpabs
!-----------------------------------------------------------------------
!           Evaluation of the complex exponential integral
!-----------------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: w
real :: n, np1
real :: cd(18), ce(18)
real :: qf(2), sm(2), tm(2), ts(2)
real :: g0(2), gn(2), h0(2), hn(2), wn(2)
logical :: ind
!-------------------------
anorm(x,y) = amax1(abs(x),abs(y))
!-------------------------
data pi /3.14159265358979/
data euler /.577215664901533/
!-------------------------
data cd(1)  /0.00000000000000e+00/, cd(2)  /.311105957086528e-01/, &
&cd(3)  /.103661260539112e+00/, cd(4)  /.216532335244554e+00/, &
&cd(5)  /.369931427960192e+00/, cd(6)  /.566766259990589e+00/, &
&cd(7)  /.814042066324748e+00/, cd(8)  /.112384247540813e+01/, &
&cd(9)  /.151400478148512e+01/, cd(10) /.200886795032284e+01/, &
&cd(11) /.264052411823592e+01/, cd(12) /.345098449933392e+01/, &
&cd(13) /.449583360763202e+01/, cd(14) /.585058263409822e+01/, &
&cd(15) /.762273501463380e+01/, cd(16) /.997814501584578e+01/, &
&cd(17) /.132122064896408e+02/, cd(18) /.180322948376021e+02/
data ce(1)  /.850156516121093e-02/, ce(2)  /.505037465849058e-01/, &
&ce(3)  /.836817368956407e-01/, ce(4)  /.107047582417607e+00/, &
&ce(5)  /.120424719029462e+00/, ce(6)  /.125096631582229e+00/, &
&ce(7)  /.122314435224685e+00/, ce(8)  /.112621417553907e+00/, &
&ce(9)  /.963419407392582e-01/, ce(10) /.747398422757511e-01/, &
&ce(11) /.508596135953441e-01/, ce(12) /.290822706773628e-01/, &
&ce(13) /.132201640530101e-01/, ce(14) /.443802939829067e-02/, &
&ce(15) /.992612478987576e-03/, ce(16) /.126579795112011e-03/, &
&ce(17) /.702150908253350e-05/, ce(18) /.910281532564632e-07/
!-------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0.
!
                eps = spmpar(1)
!
!-------------------------
!
x = real(z)
y = aimag(z)
r = cpabs(x,y)
eps = amax1(eps,1.e-15)
!
if (r .le. 1.0) go to 20
if (r .ge. 40.0) go to 60
if (r .lt. 4.0) go to 10
   if (x .le. 0.0 .or. abs(y) .gt. 8.0) go to 60
   if (r .lt. 10.0 .and. abs(y) .gt. 1.8*x) go to 60
   go to 20
10 if (x .lt. 0.09*y*y) go to 50
if (r .gt. 3.6 .and. abs(y) .gt. 1.8*x) go to 60
!
!                        Taylor series
!
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
   if (anorm(ts(1),ts(2)) .gt. eps*anorm(sm(1),sm(2))) &
&go to 30
sm(1) = x + sm(1)
sm(2) = y + sm(2)
!
sm(1) = (euler + alog(r)) + sm(1)
sm(2) = atan2(-y, -x) + sm(2)
go to 110
!
!                      Rational expansion
!
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
!
!         Pade approximation for the asymptotic expansion
!                       for exp(-z)*EI(z)
!
60 x = - x
y = - y
d = 4.0*r
if (r .lt. 10.0) d = 32.0
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
!
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
!
   tm(1) = wn(1)
   tm(2) = wn(2)
   w = cmplx(gn(1),gn(2))/cmplx(hn(1),hn(2))
   wn(1) = real(w)
   wn(2) = aimag(w)
   if (anorm(tm(1) - wn(1), tm(2) - wn(2)) .gt. &
&tol*anorm(wn(1), wn(2))) go to 70
!
x = real(z)
y = aimag(z)
w = w/z
sm(1) = real(w)
sm(2) = aimag(w)
!
!                         Termination
!
100 ind = x .le. 0.0 .or. abs(y) .gt. 1.e-2
if (ind .and. mo .ne. 0) go to 130
c = pi
if (y .gt. 0.0) c = -pi
qm = exp(x)
cy = cos(y)
sy = sin(y)
qf(1) = qm*cy
qf(2) = qm*sy
if (mo .eq. 0) go to 120
!
r = c/qm
sm(1) = sm(1) + r*sy
sm(2) = sm(2) + r*cy
go to 130
!
110 if (mo .eq. 0) go to 130
ind = .true.
qm = exp(-x)
qf(1) = qm*cos(-y)
qf(2) = qm*sin(-y)
!
120 ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
if (.not. ind) sm(2) = sm(2) + c
!
130 w = cmplx(sm(1),sm(2))
return
end subroutine cexpli

subroutine expli(int,arg,result,ierr)
implicit none
integer :: m
real :: csevl
real :: alnrel
!
real :: a(6), b(5), c(7), d(7), e(7), f(7), p1(8), q1(8), p2(8), &
&q2(7), p3(8), q3(7), p4(8), q4(7), r(20), px(9), qx(9), frac, &
&sump, sumq, t, w, x, x0, xx0, xmx0, y, dexp40, xmax, xmin, ei
real, intent(in) :: arg
real, intent(inout) :: result
real :: exparg
integer :: i
integer, intent(in) :: int
integer, intent(out) :: ierr
double precision :: dx0
!-----------------------------------------------------------------------
!
!     This subroutine computes the exponential integrals
!
!            EI(X),  e-SUB-1(X) = -EI(-X),  AND  exp(-X)*EI(X)
!
!     Where
!
!             INTEGRAL (FROM T=-INFINITY TO T=X) (exp(T)/T),  X .GT. 0,
!     ei(x) =
!             -INTEGRAL (FROM T=-X TO T=INFINITY) (exp(-T)/T),
!                                                         X .LT. 0,
!
!     And where the first integral is a principal value integral. The
!     arguments int, arg, and result have the following usage ...
!
!            INT              ARG             RESULT
!             1            X .NE. 0          EI(X)
!             2            X .GT. 0          e-SUB-1(X)
!             3            X .NE. 0          exp(-X)*EI(X)
!
!     THE EXPANSION FOR 4 .LE. X .LE. 8 IS DUE TO WAYNE FULLERTON (LOS
!     alamos). The remaining expansions are from math. Comp. 22, 641-649
!     (1968), and math. Comp. 23, 289-303(1969) By cody and Thacher.
!
!        ------------
!
!     Error monitoring
!
!        The parameter ierr is a variable that is set by the routine.
!     If no errors are detected then ierr is set to 0. The following
!     table indicates the types of errors that may be encountered in
!     the routine and the function values supplied in each case.
!
!     ierr    ERROR     ARGUMENT          FUNCTION VALUES FOR
!                        RANGE        EI(X)  exp(-X)*EI(X)  e-SUB-1(X)
!      1    UNDERFLOW   X .LT. XMIN     0          -          0
!      2    OVERFLOW    X .GT. XMAX     T          -          -
!      3    ILLEGAL X     X = 0         T          T          T
!      4    ILLEGAL X    X .LT. 0       -          -          T
!
!     T indicates that the routine terminates without assigning a value
!     to the function.
!
!        ----------
!
!     THIS SUBROUTINE WAS WRITTEN AT ARGONNE NATIONAL LABORATORY FOR
!     THE FUNPACK PACKAGE OF SPECIAL FUNCTION SUBROUTINES. THE ROUTINE
!     WAS MODIFIED BY BY A.H. MORRIS (NSWC).
!
!-----------------------------------------------------------------------
!
!     Xmax and xmin are machine dependent constants for detecting
!     underflow and overflow. Xmax and xmin are given approximate
!     values in statements 240 and 340.
!
!-----------------------------------------------------------------------
!
!     Value of exp(40.0)
!
!     ----------
data dexp40/.235385266837020e+18/
!     ----------
!
!     Zero of EI(X)
!
!     ----------
data x0/.372507410781366/,dx0/.37250741078136663446199186658d0/
!     ----------
!
!     Coefficients for R(5,4) approximation,
!     USED FOR -1.0 .LE. X .LT. 0.0
!
!     ----------
data a(1)/-.577215664901531e+00/, a(2) /.758833087029943e+00/, &
&a(3) /.125660818982053e+00/, a(4) /.204158408934305e-01/, &
&a(5) /.825035122466538e-03/, a(6) /.962949813453924e-05/
data b(1) /.100000000000000e+01/, b(2) /.417810755380398e+00/, &
&b(3) /.730228560396799e-01/, b(4) /.642720224671078e-02/, &
&b(5) /.245134203588369e-03/
!     ----------
!
!     Coefficients for R(6,6) approximation,
!     USED FOR -4.0 .LE. X .LT. -1.0
!
!     ----------
data c(1) /.465627107975096e-06/, c(2) /.999979577051595e+00/, &
&c(3) /.904161556946328e+01/, c(4) /.243784088791317e+02/, &
&c(5) /.230192559391334e+02/, c(6) /.690522522784443e+01/, &
&c(7) /.430967839469389e+00/
data d(1) /.100000000000000e+01/, d(2) /.100411643829054e+02/, &
&d(3) /.324264210695138e+02/, d(4) /.412807841891424e+02/, &
&d(5) /.204494785013794e+02/, d(6) /.331909213593302e+01/, &
&d(7) /.103400130404874e+00/
!     ----------
!
!     Coefficients for R(6,6) approximation,
!     USED FOR X .LT. -4.0
!
!     ----------
data e(1)/-.999999999998447e+00/, e(2)/-.266271060431811e+02/, &
&e(3)/-.241055827097015e+03/, e(4)/-.895927957772937e+03/, &
&e(5)/-.129885688746484e+04/, e(6)/-.545374158883133e+03/, &
&e(7)/-.566575206533869e+01/
data f(1) /.100000000000000e+01/, f(2) /.286271060422192e+02/, &
&f(3) /.292310039388533e+03/, f(4) /.133278537748257e+04/, &
&f(5) /.277761949509163e+04/, f(6) /.240401713225909e+04/, &
&f(7) /.631657483280800e+03/
!     ----------
!
!     Coefficients for R(7,7) approximation,
!     in Chebyshev polynomial form, used for
!     0.0 .LT. X .LT. 4.0
!
!     ----------
data p1(1)/-.866937339951070e+01/, p1(2)/-.549142265521085e+03/, &
&p1(3)/-.421001615357070e+04/, p1(4)/-.249301393458648e+06/, &
&p1(5)/-.119623669349247e+06/, p1(6)/-.221744627758845e+08/, &
&p1(7) /.389280421311201e+07/, p1(8)/-.195773036904548e+09/
data q1(1) /.341718750000000e+02/, q1(2)/-.160708926587221e+04/, &
&q1(3) /.357300298058508e+05/, q1(4)/-.483547436162164e+06/, &
&q1(5) /.428559624611749e+07/, q1(6)/-.249033375740540e+08/, &
&q1(7) /.891925767575612e+08/, q1(8)/-.826271498626055e+08/
!     ----------
!
!     Coefficients for Chebyshev expansion for
!     4.0 .LE. X .LE. 8.0
!
!     ----------
data r(1) / .636295897967470e+00/, r(2) /-.130811686750676e+00/, &
&r(3) /-.843674102130539e-02/, r(4) / .265684915310067e-02/, &
&r(5) / .328227217816581e-03/, r(6) /-.237834477714302e-04/, &
&r(7) /-.114398043081001e-04/, r(8) /-.144059434332383e-05/, &
&r(9) / .524159566511488e-08/, r(10)/ .384073064078443e-07/, &
&r(11)/ .858802448602672e-08/, r(12)/ .102192266258550e-08/, &
&r(13)/ .217491323232897e-10/, r(14)/-.220902381426231e-10/, &
&r(15)/-.634575335449288e-11/, r(16)/-.108377465668577e-11/, &
&r(17)/-.119098228722226e-12/, r(18)/-.284386823892656e-14/, &
&r(19)/ .250803270266868e-14/, r(20)/ .787296415285598e-15/
!
!     Coefficients for R(7,7) approximation,
!     in J-fraction form, used for
!     8.0 .LT. X .LT. 12.0
!
!     ----------
data p2(1)/-.218086381520723e+01/, p2(2)/-.219010233854881e+02/, &
&p2(3)/ .930816385662165e+01/, p2(4) /.250762811293560e+02/, &
&p2(5)/-.331842531997221e+02/, p2(6) /.601217990830080e+02/, &
&p2(7)/-.432531132878135e+02/, p2(8) /.100443109228078e+01/
data q2(1)/ .393707701852715e+01/, q2(2) /.300892648372915e+03/, &
&q2(3)/-.625041161671876e+01/, q2(4) /.100367439516726e+04/, &
&q2(5)/ .143256738121938e+02/, q2(6) /.273624119889328e+04/, &
&q2(7)/ .527468851962908e+00/
!     ----------
!
!     Coefficients for R(7,7) approximation,
!     in J-fraction form, used for
!     12.0 .LE. X .LT. 24.0
!
!     ----------
data p3(1)/-.348334653602852e+01/, p3(2)/-.186545454883399e+02/, &
&p3(3)/-.828561994140641e+01/, p3(4)/-.323467330305403e+02/, &
&p3(5)/ .179601688769252e+02/, p3(6) /.175656315469614e+01/, &
&p3(7)/-.195022321289660e+01/, p3(8) /.999994296074708e+00/
data q3(1) /.695000655887434e+02/, q3(2) /.572837193837324e+02/, &
&q3(3) /.257776384238440e+02/, q3(4) /.760761148007735e+03/, &
&q3(5) /.289516727925135e+02/, q3(6)/-.343942266899870e+01/, &
&q3(7) /.100083867402639e+01/
!     ----------
!
!     Coefficients for R(7.7) approximation,
!     IN J-FRACTION FORM, USED FOR X .GE. 24.0
!
!     ----------
data p4(1)/-.531686623494482e+02/, p4(2)/ .891263822573708e+01/, &
&p4(3)/-.139381360364405e+01/, p4(4)/-.308336269051763e+02/, &
&p4(5)/-.749289167792884e+01/, p4(6)/-.500140345515924e+01/, &
&p4(7)/-.300000016782086e+01/, p4(8)/ .100000000000058e+01/
data q4(1)/ .104745362652468e+04/, q4(2)/-.674704580465832e+01/, &
&q4(3)/ .295999399486831e+03/, q4(4)/-.431325836146628e+01/, &
&q4(5)/-.790404992298926e+01/, q4(6)/-.299996432944446e+01/, &
&q4(7)/ .199999999924131e+01/
!-----------------------------------------------------------------------
!
x = arg
ierr = 0
if (int .eq. 2) go to 450
if (x) 280, 640, 110
110 if (x .ge. 12.e0) go to 200
if (x .gt. 8.e0) go to 160
if (x .ge. 4.e0) go to 150
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
!
do i = 2, 7
   px(i+1) = t * px(i) - px(i-1) + p1(i)
   qx(i+1) = t * qx(i) - qx(i-1) + q1(i)
end do
!
sump = .5e0 * t * px(8) - px(7) + p1(8)
sumq = .5e0 * t * qx(8) - qx(7) + q1(8)
frac = sump / sumq
xmx0 = dble(x) - dx0
if (abs(xmx0) .lt. 0.07e0) go to 140
xx0 = x / x0
ei = alog(xx0) + xmx0 * frac
if (int .eq. 3) ei = exp(-x) * ei
go to 410
!     ---------- Evaluate approximation for LN(X/X0)
!                for X close to X0 ----------
140 y = xmx0 / x0
ei = alnrel(y) + xmx0 * frac
if (int .eq. 3) ei = exp(-x) * ei
go to 410
!     ---------- 4.0 .LE. X .LE. 8.0 ----------
150 m = 20
ei = (1.0 + csevl (3.0 - 16.0/x, r, m)) / x
if (int .eq. 3) go to 410
ei = ei * exp(x)
go to 410
!     ---------- 8.0 .LT. X .LT. 12.0 ----------
160 frac = 0.0e0
!
do 180 i = 1, 7
180 frac = q2(i) / (p2(i) + x + frac)
!
ei = (p2(8) + frac) / x
if (int .eq. 3) go to 410
ei = ei * exp(x)
go to 410
!     ---------- 12.0 .LE. X .LT. 24.0 ----------
200 if (x .ge. 24.e0) go to 240
frac = 0.0e0
!
do 220 i = 1, 7
220 frac = q3(i) / (p3(i) + x + frac)
!
ei = (p3(8) + frac) / x
if (int .eq. 3) go to 410
ei = ei * exp(x)
go to 410
!     ---------- 24.0 .LE. X ----------
240 xmax = exparg(0)
if ((x .gt. xmax) .and. (int .lt. 3)) go to 620
y = 1.0e0 / x
frac = 0.0e0
!
do 260 i = 1, 7
260 frac = q4(i) / (p4(i) + x + frac)
!
frac = p4(8) + frac
ei = y + y * y * frac
if (int .eq. 3) go to 410
if (x .gt. 150.0e0) go to 270
ei = ei * exp(x)
go to 410
!     ---------- Calculation reformulated to avoid
!                premature overflow ----------
270 ei = (ei * exp(x-40.0e0)) * dexp40
go to 410
!     ---------- Original X was negative.  Calculation of
!                e-sub-1 joins at label 300 ----------
280 y = -x
300 w = 1.0e0 / y
if (y .gt. 4.0e0) go to 340
if (y .gt. 1.0e0) go to 320
!     ---------- 0.0 .LT. -X .LE. 1.0 ----------
ei = alog(y) - (((((a(6) * y + a(5)) * y + a(4)) &
&* y + a(3)) * y + a(2)) * y + a(1)) / &
&((((b(5) * y + b(4)) * y + b(3)) &
&* y + b(2)) * y + b(1))
if (int .eq. 3) ei = ei * exp(y)
go to 400
!     ---------- 1.0 .LT. -X .LE. 4.0 ----------
320 ei = -((((((c(7) * w + c(6)) * w + c(5)) * w + c(4)) &
&* w + c(3)) * w + c(2)) * w + c(1))  / &
&((((((d(7) * w + d(6)) * w + d(5)) * w + d(4)) &
&* w + d(3)) * w + d(2)) * w + d(1))
if  (int .eq. 3) go to 410
ei = ei * exp(-y)
go to 400
!     ---------- 4.0 .LT. -X ----------
340 xmin = exparg(1)
if ((-abs(x) .lt. xmin) .and. (int .lt. 3)) go to 600
ei = -w * (1.0e0 + w * ((((((e(7) &
&* w + e(6)) * w + e(5)) * w + e(4)) &
&* w + e(3)) * w + e(2)) * w + e(1)) / &
&((((((f(7) * w + f(6)) * w + f(5)) &
&* w + f(4)) * w + f(3)) * w + f(2)) * w + f(1)))
if (int .eq. 3) go to 410
ei = ei * exp(-y)
t = 0.5e0 * ei
if (t .eq. 0.0e0) go to 600
400 if (int .eq. 2) ei = -ei
410 result = ei
return
450 y = x
if (y) 660, 640, 300
!     ---------- ERROR RETURN FOR X .LT. XMIN,
!                causing underflow ----------
600 ei = 0.0e0
ierr = 1
go to 410
!     ---------- ERROR RETURN FOR X .GT. XMAX,
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
return
end subroutine expli

double precision function dei (x)
implicit none
!-----------------------------------------------------------------------
!        Double precision evaluation of the exponential integral
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: de1e
!
dei = -de1e(-x)
if (x .gt. 4.d0 .or. x .lt. -1.d0) dei = dexp(x) * dei
return
end function dei

double precision function dei1 (x)
implicit none
!-----------------------------------------------------------------------
!          Double precision evaluation of exp(-x)*EI(x)
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: de1e
!
dei1  = -de1e(-x)
if (x .gt. 4.d0 .or. x .lt. -1.d0) return
dei1 = dexp(-x) * dei1
return
end function dei1

double precision function de1e(x)
implicit none
integer :: m
!-----------------------------------------------------------------------
!
!     Let E1(x) denote the exponential integral for positive x and
!     the Cauchy principal value for negative x. If x is nonzero
!     then de1e has the value ...
!
!          de1e(x) = e1(x)          if -4 .le. x .le. 1
!          de1e(x) = exp(x)*e1(x)   otherwise
!
!-----------------------------------------------------------------------
!     WRITTEN BY ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN, VIRGINIA
!-----------------------------------------------------------------------
!
!     THE FOLLOWING SERIES FOR E1 WERE DEVELOPED BY WAYNE FULLERTON
!     (LOS ALAMOS NATIONAL LABORATORY).
!
!     SERIES A             ON THE INTERVAL -3.12500e-02 TO  0.
!                                        WITH WEIGHTED ERROR   4.62e-32
!                                         log weighted error  31.34
!                               significant figures required  29.70
!                                    decimal places required  32.18
!
!
!     SERIES b             ON THE INTERVAL -1.25000e-01 TO -3.12500e-02
!                                        WITH WEIGHTED ERROR   2.22e-32
!                                         log weighted error  31.65
!                               significant figures required  30.75
!                                    decimal places required  32.54
!
!
!     SERIES d             ON THE INTERVAL -2.50000e-01 TO -1.25000e-01
!                                        WITH WEIGHTED ERROR   5.19e-32
!                                         log weighted error  31.28
!                               significant figures required  30.82
!                                    decimal places required  32.09
!
!
!     SERIES e             ON THE INTERVAL -4.00000e+00 TO -1.00000e+00
!                                        WITH WEIGHTED ERROR   8.49e-34
!                                         log weighted error  33.07
!                               significant figures required  34.13
!                                    decimal places required  33.80
!
!
!     SERIES r             ON THE INTERVAL -1.00000e+00 TO  1.00000e+00
!                                        WITH WEIGHTED ERROR   8.08e-33
!                                         log weighted error  32.09
!                        approx significant figures required  30.4
!                                    decimal places required  32.79
!
!
!     SERIES p             ON THE INTERVAL  2.50000e-01 TO  1.00000e+00
!                                        WITH WEIGHTED ERROR   6.65e-32
!                                         log weighted error  31.18
!                               significant figures required  30.69
!                                    decimal places required  32.03
!
!
!     SERIES Q             ON THE INTERVAL  0.          TO  2.50000e-01
!                                        WITH WEIGHTED ERROR   5.07e-32
!                                         log weighted error  31.30
!                               significant figures required  30.40
!                                    decimal places required  32.20
!
!-----------------------------------------------------------------------
double precision, intent(in) :: x
double precision :: c, eps, t, w
double precision :: a(50), b(60), d(41), e(29), r(25), p(50), &
&q(64)
double precision :: dei0, dcsevl, dpmpar
!------------------------------
data a(1)  / .3284394579616699087873844201881d-01/, &
&a(2)  /-.1669920452031362851476184343387d-01/, &
&a(3)  / .2845284724361346807424899853252d-03/, &
&a(4)  /-.7563944358516206489487866938533d-05/, &
&a(5)  / .2798971289450859157504843180879d-06/, &
&a(6)  /-.1357901828534531069525563926255d-07/, &
&a(7)  / .8343596202040469255856102904906d-09/, &
&a(8)  /-.6370971727640248438275242988532d-10/, &
&a(9)  / .6007247608811861235760831561584d-11/, &
&a(10) /-.7022876174679773590750626150088d-12/
data a(11) / .1018302673703687693096652346883d-12/, &
&a(12) /-.1761812903430880040406309966422d-13/, &
&a(13) / .3250828614235360694244030353877d-14/, &
&a(14) /-.5071770025505818678824872259044d-15/, &
&a(15) / .1665177387043294298172486084156d-16/, &
&a(16) / .3166753890797514400677003536555d-16/, &
&a(17) /-.1588403763664141515133118343538d-16/, &
&a(18) / .4175513256138018833003034618484d-17/, &
&a(19) /-.2892347749707141906710714478852d-18/, &
&a(20) /-.2800625903396608103506340589669d-18/
data a(21) / .1322938639539270903707580023781d-18/, &
&a(22) /-.1804447444177301627283887833557d-19/, &
&a(23) /-.7905384086522616076291644817604d-20/, &
&a(24) / .4435711366369570103946235838027d-20/, &
&a(25) /-.4264103994978120868865309206555d-21/, &
&a(26) /-.3920101766937117541553713162048d-21/, &
&a(27) / .1527378051343994266343752326971d-21/, &
&a(28) / .1024849527049372339310308783117d-22/, &
&a(29) /-.2134907874771433576262711405882d-22/, &
&a(30) / .3239139475160028267061694700366d-23/
data a(31) / .2142183762299889954762643168296d-23/, &
&a(32) /-.8234609419601018414700348082312d-24/, &
&a(33) /-.1524652829645809479613694401140d-24/, &
&a(34) / .1378208282460639134668480364325d-24/, &
&a(35) / .2131311202833947879523224999253d-26/, &
&a(36) /-.2012649651526484121817466763127d-25/, &
&a(37) / .1995535662263358016106311782673d-26/, &
&a(38) / .2798995808984003464948686520319d-26/, &
&a(39) /-.5534511845389626637640819277823d-27/, &
&a(40) /-.3884995396159968861682544026146d-27/
data a(41) / .1121304434507359382850680354679d-27/, &
&a(42) / .5566568152423740948256563833514d-28/, &
&a(43) /-.2045482929810499700448533938176d-28/, &
&a(44) /-.8453813992712336233411457493674d-29/, &
&a(45) / .3565758433431291562816111116287d-29/, &
&a(46) / .1383653872125634705539949098871d-29/, &
&a(47) /-.6062167864451372436584533764778d-30/, &
&a(48) /-.2447198043989313267437655119189d-30/, &
&a(49) / .1006850640933998348011548180480d-30/, &
&a(50) / .4623685555014869015664341461674d-31/
!------------------------------
data b(1)  / .20263150647078889499401236517381d+00/, &
&b(2)  /-.73655140991203130439536898728034d-01/, &
&b(3)  / .63909349118361915862753283840020d-02/, &
&b(4)  /-.60797252705247911780653153363999d-03/, &
&b(5)  /-.73706498620176629330681411493484d-04/, &
&b(6)  / .48732857449450183453464992488076d-04/, &
&b(7)  /-.23837064840448290766588489460235d-05/, &
&b(8)  /-.30518612628561521027027332246121d-05/, &
&b(9)  / .17050331572564559009688032992907d-06/, &
&b(10) / .23834204527487747258601598136403d-06/
data b(11) / .10781772556163166562596872364020d-07/, &
&b(12) /-.17955692847399102653642691446599d-07/, &
&b(13) /-.41284072341950457727912394640436d-08/, &
&b(14) / .68622148588631968618346844526664d-09/, &
&b(15) / .53130183120506356147602009675961d-09/, &
&b(16) / .78796880261490694831305022893515d-10/, &
&b(17) /-.26261762329356522290341675271232d-10/, &
&b(18) /-.15483687636308261963125756294100d-10/, &
&b(19) /-.25818962377261390492802405122591d-11/, &
&b(20) / .59542879191591072658903529959352d-12/
data b(21) / .46451400387681525833784919321405d-12/, &
&b(22) / .11557855023255861496288006203731d-12/, &
&b(23) /-.10475236870835799012317547189670d-14/, &
&b(24) /-.11896653502709004368104489260929d-13/, &
&b(25) /-.47749077490261778752643019349950d-14/, &
&b(26) /-.81077649615772777976249734754135d-15/, &
&b(27) / .13435569250031554199376987998178d-15/, &
&b(28) / .14134530022913106260248873881287d-15/, &
&b(29) / .49451592573953173115520663232883d-16/, &
&b(30) / .79884048480080665648858587399367d-17/
data b(31) /-.14008632188089809829248711935393d-17/, &
&b(32) /-.14814246958417372107722804001680d-17/, &
&b(33) /-.55826173646025601904010693937113d-18/, &
&b(34) /-.11442074542191647264783072544598d-18/, &
&b(35) / .25371823879566853500524018479923d-20/, &
&b(36) / .13205328154805359813278863389097d-19/, &
&b(37) / .62930261081586809166287426789485d-20/, &
&b(38) / .17688270424882713734999261332548d-20/, &
&b(39) / .23266187985146045209674296887432d-21/, &
&b(40) /-.67803060811125233043773831844113d-22/
data b(41) /-.59440876959676373802874150531891d-22/, &
&b(42) /-.23618214531184415968532592503466d-22/, &
&b(43) /-.60214499724601478214168478744576d-23/, &
&b(44) /-.65517906474348299071370444144639d-24/, &
&b(45) / .29388755297497724587042038699349d-24/, &
&b(46) / .22601606200642115173215728758510d-24/, &
&b(47) / .89534369245958628745091206873087d-25/, &
&b(48) / .24015923471098457555772067457706d-25/, &
&b(49) / .34118376888907172955666423043413d-26/, &
&b(50) /-.71617071694630342052355013345279d-27/
data b(51) /-.75620390659281725157928651980799d-27/, &
&b(52) /-.33774612157467324637952920780800d-27/, &
&b(53) /-.10479325703300941711526430332245d-27/, &
&b(54) /-.21654550252170342240854880201386d-28/, &
&b(55) /-.75297125745288269994689298432000d-30/, &
&b(56) / .19103179392798935768638084000426d-29/, &
&b(57) / .11492104966530338547790728833706d-29/, &
&b(58) / .43896970582661751514410359193600d-30/, &
&b(59) / .12320883239205686471647157725866d-30/, &
&b(60) / .22220174457553175317538581162666d-31/
!------------------------------
data d(1)  / .63629589796747038767129887806803d+00/, &
&d(2)  /-.13081168675067634385812671121135d+00/, &
&d(3)  /-.84367410213053930014487662129752d-02/, &
&d(4)  / .26568491531006685413029428068906d-02/, &
&d(5)  / .32822721781658133778792170142517d-03/, &
&d(6)  /-.23783447771430248269579807851050d-04/, &
&d(7)  /-.11439804308100055514447076797047d-04/, &
&d(8)  /-.14405943433238338455239717699323d-05/, &
&d(9)  / .52415956651148829963772818061664d-08/, &
&d(10) / .38407306407844323480979203059716d-07/
data d(11) / .85880244860267195879660515759344d-08/, &
&d(12) / .10219226625855003286339969553911d-08/, &
&d(13) / .21749132323289724542821339805992d-10/, &
&d(14) /-.22090238142623144809523503811741d-10/, &
&d(15) /-.63457533544928753294383622208801d-11/, &
&d(16) /-.10837746566857661115340539732919d-11/, &
&d(17) /-.11909822872222586730262200440277d-12/, &
&d(18) /-.28438682389265590299508766008661d-14/, &
&d(19) / .25080327026686769668587195487546d-14/, &
&d(20) / .78729641528559842431597726421265d-15/
data d(21) / .15475066347785217148484334637329d-15/, &
&d(22) / .22575322831665075055272608197290d-16/, &
&d(23) / .22233352867266608760281380836693d-17/, &
&d(24) / .16967819563544153513464194662399d-19/, &
&d(25) /-.57608316255947682105310087304533d-19/, &
&d(26) /-.17591235774646878055625369408853d-19/, &
&d(27) /-.36286056375103174394755328682666d-20/, &
&d(28) /-.59235569797328991652558143488000d-21/, &
&d(29) /-.76030380926310191114429136895999d-22/, &
&d(30) /-.62547843521711763842641428479999d-23/
data d(31) / .25483360759307648606037606400000d-24/, &
&d(32) / .25598615731739857020168874666666d-24/, &
&d(33) / .71376239357899318800207052800000d-25/, &
&d(34) / .14703759939567568181578956800000d-25/, &
&d(35) / .25105524765386733555198634666666d-26/, &
&d(36) / .35886666387790890886583637333333d-27/, &
&d(37) / .39886035156771301763317759999999d-28/, &
&d(38) / .21763676947356220478805333333333d-29/, &
&d(39) /-.46146998487618942367607466666666d-30/, &
&d(40) /-.20713517877481987707153066666666d-30/
data d(41) /-.51890378563534371596970666666666d-31/
!------------------------------
data e(1)  /-.16113461655571494025720663927566180d+02/, &
&e(2)  / .77940727787426802769272245891741497d+01/, &
&e(3)  /-.19554058188631419507127283812814491d+01/, &
&e(4)  / .37337293866277945611517190865690209d+00/, &
&e(5)  /-.56925031910929019385263892220051166d-01/, &
&e(6)  / .72110777696600918537847724812635813d-02/, &
&e(7)  /-.78104901449841593997715184089064148d-03/, &
&e(8)  / .73880933562621681878974881366177858d-04/, &
&e(9)  /-.62028618758082045134358133607909712d-05/, &
&e(10) / .46816002303176735524405823868362657d-06/
data e(11) /-.32092888533298649524072553027228719d-07/, &
&e(12) / .20151997487404533394826262213019548d-08/, &
&e(13) /-.11673686816697793105356271695015419d-09/, &
&e(14) / .62762706672039943397788748379615573d-11/, &
&e(15) /-.31481541672275441045246781802393600d-12/, &
&e(16) / .14799041744493474210894472251733333d-13/, &
&e(17) /-.65457091583979673774263401588053333d-15/, &
&e(18) / .27336872223137291142508012748799999d-16/, &
&e(19) /-.10813524349754406876721727624533333d-17/, &
&e(20) / .40628328040434303295300348586666666d-19/
data e(21) /-.14535539358960455858914372266666666d-20/, &
&e(22) / .49632746181648636830198442666666666d-22/, &
&e(23) /-.16208612696636044604866560000000000d-23/, &
&e(24) / .50721448038607422226431999999999999d-25/, &
&e(25) /-.15235811133372207813973333333333333d-26/, &
&e(26) / .44001511256103618696533333333333333d-28/, &
&e(27) /-.12236141945416231594666666666666666d-29/, &
&e(28) / .32809216661066001066666666666666666d-31/, &
&e(29) /-.84933452268306432000000000000000000d-33/
!------------------------------
data r(1)  /-.3739021479220279511668698204827d-01/, &
&r(2)  / .4272398606220957726049179176528d-01/, &
&r(3)  /-.130318207984970054415392055219726d+00/, &
&r(4)  / .144191240246988907341095893982137d-01/, &
&r(5)  /-.134617078051068022116121527983553d-02/, &
&r(6)  / .107310292530637799976115850970073d-03/, &
&r(7)  /-.742999951611943649610283062223163d-05/, &
&r(8)  / .453773256907537139386383211511827d-06/, &
&r(9)  /-.247641721139060131846547423802912d-07/, &
&r(10) / .122076581374590953700228167846102d-08/
data r(11) /-.548514148064092393821357398028261d-10/, &
&r(12) / .226362142130078799293688162377002d-11/, &
&r(13) /-.863589727169800979404172916282240d-13/, &
&r(14) / .306291553669332997581032894881279d-14/, &
&r(15) /-.101485718855944147557128906734933d-15/, &
&r(16) / .315482174034069877546855328426666d-17/, &
&r(17) /-.923604240769240954484015923200000d-19/, &
&r(18) / .255504267970814002440435029333333d-20/, &
&r(19) /-.669912805684566847217882453333333d-22/, &
&r(20) / .166925405435387319431987199999999d-23/
data r(21) /-.396254925184379641856000000000000d-25/, &
&r(22) / .898135896598511332010666666666666d-27/, &
&r(23) /-.194763366993016433322666666666666d-28/, &
&r(24) / .404836019024630033066666666666666d-30/, &
&r(25) /-.807981567699845120000000000000000d-32/
!------------------------------
data p(1)  /-.60577324664060345999319382737747d+00/, &
&p(2)  /-.11253524348366090030649768852718d+00/, &
&p(3)  / .13432266247902779492487859329414d-01/, &
&p(4)  /-.19268451873811457249246838991303d-02/, &
&p(5)  / .30911833772060318335586737475368d-03/, &
&p(6)  /-.53564132129618418776393559795147d-04/, &
&p(7)  / .98278128802474923952491882717237d-05/, &
&p(8)  /-.18853689849165182826902891938910d-05/, &
&p(9)  / .37494319356894735406964042190531d-06/, &
&p(10) /-.76823455870552639273733465680556d-07/
data p(11) / .16143270567198777552956300060868d-07/, &
&p(12) /-.34668022114907354566309060226027d-08/, &
&p(13) / .75875420919036277572889747054114d-09/, &
&p(14) /-.16886433329881412573514526636703d-09/, &
&p(15) / .38145706749552265682804250927272d-10/, &
&p(16) /-.87330266324446292706851718272334d-11/, &
&p(17) / .20236728645867960961794311064330d-11/, &
&p(18) /-.47413283039555834655210340820160d-12/, &
&p(19) / .11221172048389864324731799928920d-12/, &
&p(20) /-.26804225434840309912826809093395d-13/
data p(21) / .64578514417716530343580369067212d-14/, &
&p(22) /-.15682760501666478830305702849194d-14/, &
&p(23) / .38367865399315404861821516441408d-15/, &
&p(24) /-.94517173027579130478871048932556d-16/, &
&p(25) / .23434812288949573293896666439133d-16/, &
&p(26) /-.58458661580214714576123194419882d-17/, &
&p(27) / .14666229867947778605873617419195d-17/, &
&p(28) /-.36993923476444472706592538274474d-18/, &
&p(29) / .93790159936721242136014291817813d-19/, &
&p(30) /-.23893673221937873136308224087381d-19/
data p(31) / .61150624629497608051934223837866d-20/, &
&p(32) /-.15718585327554025507719853288106d-20/, &
&p(33) / .40572387285585397769519294491306d-21/, &
&p(34) /-.10514026554738034990566367122773d-21/, &
&p(35) / .27349664930638667785806003131733d-22/, &
&p(36) /-.71401604080205796099355574271999d-23/, &
&p(37) / .18705552432235079986756924211199d-23/, &
&p(38) /-.49167468166870480520478020949333d-24/, &
&p(39) / .12964988119684031730916087125333d-24/, &
&p(40) /-.34292515688362864461623940437333d-25/
data p(41) / .90972241643887034329104820906666d-26/, &
&p(42) /-.24202112314316856489934847999999d-26/, &
&p(43) / .64563612934639510757670475093333d-27/, &
&p(44) /-.17269132735340541122315987626666d-27/, &
&p(45) / .46308611659151500715194231466666d-28/, &
&p(46) /-.12448703637214131241755170133333d-28/, &
&p(47) / .33544574090520678532907007999999d-29/, &
&p(48) /-.90598868521070774437543935999999d-30/, &
&p(49) / .24524147051474238587273216000000d-30/, &
&p(50) /-.66528178733552062817107967999999d-31/
!------------------------------
data q(1)  /-.1892918000753016825495679942820d+00/, &
&q(2)  /-.8648117855259871489968817056824d-01/, &
&q(3)  / .7224101543746594747021514839184d-02/, &
&q(4)  /-.8097559457557386197159655610181d-03/, &
&q(5)  / .1099913443266138867179251157002d-03/, &
&q(6)  /-.1717332998937767371495358814487d-04/, &
&q(7)  / .2985627514479283322825342495003d-05/, &
&q(8)  /-.5659649145771930056560167267155d-06/, &
&q(9)  / .1152680839714140019226583501663d-06/, &
&q(10) /-.2495030440269338228842128765065d-07/
data q(11) / .5692324201833754367039370368140d-08/, &
&q(12) /-.1359957664805600338490030939176d-08/, &
&q(13) / .3384662888760884590184512925859d-09/, &
&q(14) /-.8737853904474681952350849316580d-10/, &
&q(15) / .2331588663222659718612613400470d-10/, &
&q(16) /-.6411481049213785969753165196326d-11/, &
&q(17) / .1812246980204816433384359484682d-11/, &
&q(18) /-.5253831761558460688819403840466d-12/, &
&q(19) / .1559218272591925698855028609825d-12/, &
&q(20) /-.4729168297080398718476429369466d-13/
data q(21) / .1463761864393243502076199493808d-13/, &
&q(22) /-.4617388988712924102232173623604d-14/, &
&q(23) / .1482710348289369323789239660371d-14/, &
&q(24) /-.4841672496239229146973165734417d-15/, &
&q(25) / .1606215575700290408116571966188d-15/, &
&q(26) /-.5408917538957170947895023784252d-16/, &
&q(27) / .1847470159346897881370231402310d-16/, &
&q(28) /-.6395830792759094470500610425050d-17/, &
&q(29) / .2242780721699759457250233276170d-17/, &
&q(30) /-.7961369173983947552744555308646d-18/
data q(31) / .2859308111540197459808619929272d-18/, &
&q(32) /-.1038450244701137145900697137446d-18/, &
&q(33) / .3812040607097975780866841008319d-19/, &
&q(34) /-.1413795417717200768717562723696d-19/, &
&q(35) / .5295367865182740958305442594815d-20/, &
&q(36) /-.2002264245026825902137211131439d-20/, &
&q(37) / .7640262751275196014736848610918d-21/, &
&q(38) /-.2941119006868787883311263523362d-21/, &
&q(39) / .1141823539078927193037691483586d-21/, &
&q(40) /-.4469308475955298425247020718489d-22/
data q(41) / .1763262410571750770630491408520d-22/, &
&q(42) /-.7009968187925902356351518262340d-23/, &
&q(43) / .2807573556558378922287757507515d-23/, &
&q(44) /-.1132560944981086432141888891562d-23/, &
&q(45) / .4600574684375017946156764233727d-24/, &
&q(46) /-.1881448598976133459864609148108d-24/, &
&q(47) / .7744916111507730845444328478037d-25/, &
&q(48) /-.3208512760585368926702703826261d-25/, &
&q(49) / .1337445542910839760619930421384d-25/, &
&q(50) /-.5608671881802217048894771735210d-26/
data q(51) / .2365839716528537483710069473279d-26/, &
&q(52) /-.1003656195025305334065834526856d-26/, &
&q(53) / .4281490878094161131286642556927d-27/, &
&q(54) /-.1836345261815318199691326958250d-27/, &
&q(55) / .7917798231349540000097468678144d-28/, &
&q(56) /-.3431542358742220361025015775231d-28/, &
&q(57) / .1494705493897103237475066008917d-28/, &
&q(58) /-.6542620279865705439739042420053d-29/, &
&q(59) / .2877581395199171114340487353685d-29/, &
&q(60) /-.1271557211796024711027981200042d-29/
data q(61) / .5644615555648722522388044622506d-30/, &
&q(62) /-.2516994994284095106080616830293d-30/, &
&q(63) / .1127259818927510206370368804181d-30/, &
&q(64) /-.5069814875800460855562584719360d-31/
!------------------------------
!
!     ****** eps IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
!            SMALLEST NUMBER SUCH THAT 1.D0 + eps .GT. 1.D0.
!
                 eps = dpmpar(1)
!
!------------------------------
if (dabs(x) .ge. 90.d0) go to 80
if (x .gt. -1.d0) go to 40
!
!                    -90 .LT. x .LT. -4
!
if (x .gt. -32.d0) go to 10
m = 50
if (eps .ge. 1.d-20) m = 25
de1e = (1.d0 + dcsevl (64.d0/x+1.d0, a, m))/x
return
!
10 if (x .gt. -8.d0) go to 20
m = 60
if (eps .ge. 1.d-20) m = 37
de1e = (1.d0 + dcsevl ((64.d0/x+5.d0)/3.d0, b, m))/x
return
!
20 if (x .ge. -4.d0) go to 30
m = 41
if (eps .ge. 1.d-20) m = 27
de1e = (1.d0 + dcsevl (16.d0/x+3.d0, d, m))/x
return
!
!                     -4 .LE. x .LE. 1
!
30 m = 29
if (eps .ge. 1.d-20) m = 20
de1e = -dlog(-x) + dcsevl ((2.d0*x+5.d0)/3.d0, e, m)
return
!
40 if (x .gt. 1.0d0) go to 60
if (x .lt. -0.4d0 .or. x .gt. -0.35d0) go to 50
   de1e = - dei0(-x, eps)
   return
50 m = 25
if (eps .ge. 1.d-20) m = 18
de1e = (-dlog(dabs(x)) - 0.6875d0 + x)  + dcsevl (x, r, m)
return
!
!                     1 .LT. x .LT. 90
!
60 if (x .gt. 4.0d0) go to 70
m = 50
if (eps .ge. 1.d-20) m = 31
de1e = (1.d0 + dcsevl ((8.d0/x-5.d0)/3.d0, p, m))/x
return
!
70 m = 64
if (eps .ge. 1.d-20) m = 35
de1e = (1.d0 + dcsevl (8.d0/x-1.d0, q, m))/x
return
!
!                   Asymptotic expansion
!
80 t = -1.d0/x
c = t
w = c
m = 1
81 m = m + 1
   c = (m*t)*c
   w = c + w
   if (dabs(c) .gt. eps) go to 81
de1e = (1.d0 + w)/x
return
end function de1e

double precision function dei0 (x, eps)
implicit none
integer :: n
!-----------------------------------------------------------------------
!
!            Taylor series expansion of EI(x) around X0,
!                  where X0 is the zero of EI(x).
!                    Eps is the tolerance used.
!
!-------------------------
!     WRITTEN BY A.H. MORRIS
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN, VIRGINIA
!-----------------------------------------------------------------------
double precision :: a(40), c
double precision, intent(in) :: eps
double precision :: h, t
double precision, intent(in) :: x
double precision :: w
double precision :: dk1, dk2, dk3, db, db2, dx
!-------------------------
data dk1 /25598514349.d0/, dk2 /12212826724.d0/, &
&dk3 /52346020729.d0/
data db  /68719476736.d0/
data dx  /.64725688445954142292644880487403537155379408215561d-33/
!-------------------------
data a(1)  / .3896215733907167310156502703593482682018d+01/, &
&a(2)  /-.3281607866398561670879044070702055058438d+01/, &
&a(3)  / .6522376145438925697728352767902339522245d+01/, &
&a(4)  /-.1296969738353651703636356975116693457132d+02/, &
&a(5)  / .2788629796294204997855360701398702087604d+02/, &
&a(6)  /-.6237880152891541873078526672920295283143d+02/, &
&a(7)  / .1435349488096750987841265647073135861344d+03/, &
&a(8)  /-.3371558271787468916821364466977375583658d+03/, &
&a(9)  / .8045318399821382506595322457265602778098d+03/, &
&a(10) /-.1943796645723498840655451915157946462648d+04/
data a(11) / .4743765650402430835228269085129777320454d+04/, &
&a(12) /-.1167346399116716364394668734600584330571d+05/, &
&a(13) / .2892695530543545087445160311373446386859d+05/, &
&a(14) /-.7210794586837158996878001987822898188198d+05/, &
&a(15) / .1806695585893919626172098163733836311447d+06/, &
&a(16) /-.4546962188544665746524572520110515778526d+06/, &
&a(17) / .1148834546817744310374556891236080193473d+07/, &
&a(18) /-.2912721663850837498392234670693435881386d+07/, &
&a(19) / .7407692958000587759747953639495510375408d+07/, &
&a(20) /-.1889172700038153127288849726417780854730d+08/
data a(21) / .4830003493086024720868271496253148288055d+08/, &
&a(22) /-.1237682190024917092137405370407916520821d+09/, &
&a(23) / .3178111056663621852260468265468336116367d+09/, &
&a(24) /-.8176185693184928170769596413793786736279d+09/, &
&a(25) / .2107109291864363741291032089276432438927d+10/, &
&a(26) /-.5438996831077284596300440196418865401363d+10/, &
&a(27) / .1406026390995585037838894210474681627693d+11/, &
&a(28) /-.3639689100149205333626392754168250384373d+11/, &
&a(29) / .9433859509219164512733865811047107199412d+11/, &
&a(30) /-.2448111705066430130314746602027041462835d+12/
data a(31) / .6359981818273706257655285041587660739835d+12/, &
&a(32) /-.1653989211524391716301960841541179924503d+13/, &
&a(33) / .4305601123377464671923711939926758523701d+13/, &
&a(34) /-.1121847693567642152208443795868288937687d+14/, &
&a(35) / .2925565695557339262045727352754930716608d+14/, &
&a(36) /-.7635552741959392076619218035480359307499d+14/, &
&a(37) / .1994372792759425025753893705017248674884d+15/, &
&a(38) /-.5213021921201092276891722450906568692592d+15/, &
&a(39) / .1363558024737805584657706536660107687818d+16/, &
&a(40) /-.3568973490569445692988895507297245137908d+16/
!-------------------------
!
!     SET  h = x - X0  WHERE X0 IS THE ZERO OF EI(x). X0 HAS THE
!     approximate 60 digit value ...
!
!      .37250741078136663446 19918665801191335356 89497771654051555657
!
!     A more accurate value is given by ...
!
!            x0 = dk1/8**12 + dk2/8**24 + dk3/8**36 + dx
!
!     The following code should yield the correct value for h if A
!     binary, octal, or hexadecimal double precision arithmetic is
!     being used.
!
db2 = db*db
h = (((x - dk1/db) - dk2/db2) - dk3/(db*db2)) - dx
!
!-------------------------
t = h
w = 0.d0
do 10 n = 2,40
   c = a(n)*t
   w = w + c
   if (dabs(c) .lt. eps) go to 20
   t = h*t
10 continue
!
20 dei0 = h * (a(1) + w)
return
end function dei0

function si(x)
implicit none
real, intent(in) :: x
integer :: i, j, m1, m2, n1, n2
real :: aic, amax, ax, b1, b2, bb(16), bx, cc(46), pio2, rc, temp, &
&tx
real :: si
real :: spmpar
!
!     WRITTEN BY D.E. AMOS AND S.L. DANIEL, NOVEMBER,1975.
!     MODIFIED BY A.H. MORRIS
!
!     REFERENCES
!         SAND76-006C
!         THE SPECIAL FUNCTIONS AND THEIR APPROXIMATIONS, VOL. II, BY
!         Y.L. LUKE. ACADEMIC PRESS, NEW YORK, 1969.
!
!     Abstract
!         si computes the integral of sin(T)/T on (0,x) by means
!         of Chebyshev expansions on (0,5) and (5,INFINITY).
!
!     Description of arguments
!
!         Input
!           x      - LIMIT OF INTEGRATION, UNRESTRICTED
!
!         Output
!           si     - VALUE OF THE INTEGRAL
!
!
!     -------------------
data n1,n2,m1,m2/16,46,14,21/
data pio2/1.5707963267949/
!     -------------------
data bb(1) / 6.84101190850653e-01/, bb(2) /-3.74538448460062e-01/, &
&bb(3) /-2.82656062651542e-02/, bb(4) / 3.06078454012071e-02/, &
&bb(5) /-8.99242948380352e-04/, bb(6) /-1.09884251456048e-03/, &
&bb(7) / 5.81151604367358e-05/, bb(8) / 2.28802638122969e-05/, &
&bb(9) /-1.35078982929539e-06/, bb(10)/-3.13213946132892e-07/, &
&bb(11)/ 1.86619586786257e-08/, bb(12)/ 3.03991719607226e-09/, &
&bb(13)/-1.76437788946489e-10/, bb(14)/-2.20236421792690e-11/, &
&bb(15)/ 1.22710107703240e-12/, bb(16)/ 1.23680681116783e-13/
!     -------------------
data cc(1) / 9.76155271128712e-01/, cc(2) / 8.96845854916423e-02/, &
&cc(3) /-3.04656658030696e-02/, cc(4) / 8.50892472922945e-02/, &
&cc(5) /-5.78073683148386e-03/, cc(6) /-5.07182677775691e-03/, &
&cc(7) / 8.38643256650893e-04/, cc(8) /-3.34223415981738e-04/, &
&cc(9) /-2.15746207281216e-05/, cc(10)/ 1.28560650086065e-04/, &
&cc(11)/-1.56456413510232e-05/, cc(12)/-1.52025513597262e-05/, &
&cc(13)/ 4.04001013843204e-06/, cc(14)/-5.95896122752160e-07/, &
&cc(15)/-4.34985305974340e-07/, cc(16)/ 7.13472533530840e-07/, &
&cc(17)/-5.34302186061100e-08/, cc(18)/-1.76003581156610e-07/, &
&cc(19)/ 3.85028855125900e-08/, cc(20)/ 1.92576544441700e-08/, &
&cc(21)/-1.00735358217200e-08/, cc(22)/ 3.36359194377000e-09/, &
&cc(23)/ 1.28049619406000e-09/, cc(24)/-2.42546870827000e-09/, &
&cc(25)/ 1.86917288950000e-10/, cc(26)/ 7.13431298340000e-10/, &
&cc(27)/-1.70673483710000e-10/, cc(28)/-1.14604070350000e-10/, &
&cc(29)/ 5.88004411500000e-11/, cc(30)/-6.78417843000000e-12/, &
&cc(31)/-1.21572380900000e-11/, cc(32)/ 1.26561248700000e-11/, &
&cc(33)/ 4.74814180000000e-13/, cc(34)/-5.32309477000000e-12/, &
&cc(35)/ 9.05903810000000e-13/, cc(36)/ 1.40046450000000e-12/, &
&cc(37)/-5.00968320000000e-13/, cc(38)/-1.80458040000000e-13/
data cc(39)/ 1.66162910000000e-13/, cc(40)/-5.02616400000000e-14/, &
&cc(41)/-3.48453600000000e-14/, cc(42)/ 4.60056600000000e-14/, &
&cc(43)/ 5.74000000000000e-16/, cc(44)/-1.95310700000000e-14/, &
&cc(45)/ 3.68837000000000e-15/, cc(46)/ 5.62862000000000e-15/
!     -------------------
!     ****** amax IS A MACHINE DEPENDENT CONSTANT. IT IS ASSUMED THAT
!            sin(x) AND cos(x) ARE DEFINED FOR  abs(x) .LE. amax, AND
!            THAT pio2 - (1 + 1/x)/x = pio2 FOR x .GT. amax.
!
amax = 1.0/spmpar(1)
!
!
ax=abs(x)
if (ax.gt.5.0) go to 20
j=n1
bx=0.40*ax-1.0
tx=bx+bx
b1=bb(j)
b2=0.
do 10 i = 1,m1
j=j-1
temp=b1
b1=tx*b1-b2+bb(j)
10 b2=temp
si=(bx*b1-b2+bb(1))*x
return
!
20 if (ax.gt.amax) go to 50
bx=10./ax-1.
tx=bx+bx
j=n2
b1=cc(j)
b2=0.0
do 30 i = 1,m2
j=j-2
temp=b1
b1=tx*b1-b2+cc(j)
30 b2=temp
aic=bx*b1-b2+cc(2)
!
j=n2-1
b1=cc(j)
b2=0.0
do 40 i = 1,m2
j=j-2
temp=b1
b1=tx*b1-b2+cc(j)
40 b2=temp
rc=bx*b1-b2+cc(1)
!
si=(rc*cos(ax)+aic*sin(ax))/ax
si=pio2-si
if (x.lt.0.0) si=-si
return
!
50 si=sign(pio2,x)
return
end function si

function cin(x)
implicit none
real, intent(in) :: x
integer :: i, j, m1, m2, n1, n2
real :: aic, amax, ax, b1, b2, bb(16), bx, cc(46), econ, rc, temp, &
&tx
real :: cin
real :: spmpar
!
!     WRITTEN BY D.E. AMOS AND S.L. DANIEL, NOVEMBER, 1975.
!     MODIFIED BY A.H. MORRIS
!
!     REFERENCES
!         SAND76-0062
!         THE SPECIAL FUNCTIONS AND THEIR APPROXIMATIONS, VOL. II, BY
!         Y.L. LUKE. ACADEMIC PRESS, NEW YORK, 1969.
!
!     Abstract
!         cin computes the integral of (1-cos(T))/T on (0,x) by means
!         of Chebyshev expansions on (0,5) and (5,INFINITY).
!
!     Description of arguments
!
!         Input
!           x      - LIMIT OF INTEGRATION, UNRESTRICTED
!
!         Output
!           cin    - VALUE OF THE INTEGRAL
!
!
!     -------------------
data n1,n2,m1,m2     / 16, 46, 14, 21 /
data econ            / 5.77215664901533e-01/
!     -------------------
data bb(1) / 1.82820351064538e-01/, bb(2) /-8.23768704567135e-02/, &
&bb(3) /-1.03468764544958e-02/, bb(4) / 5.05085201960312e-03/, &
&bb(5) / 5.73772812356328e-05/, bb(6) /-1.42717916181096e-04/, &
&bb(7) / 2.89263664732599e-06/, bb(8) / 2.43068098304909e-06/, &
&bb(9) /-7.90337487433443e-08/, bb(10)/-2.80205535437371e-08/, &
&bb(11)/ 1.05488738052065e-09/, bb(12)/ 2.34186901801115e-10/, &
&bb(13)/-9.27762554764014e-12/, bb(14)/-1.48682586858284e-12/, &
&bb(15)/ 5.95210263082868e-14/, bb(16)/ 7.42057835287916e-15/
!     -------------------
data cc(1) / 9.76155271128712e-01/, cc(2) / 8.96845854916423e-02/, &
&cc(3) /-3.04656658030696e-02/, cc(4) / 8.50892472922945e-02/, &
&cc(5) /-5.78073683148386e-03/, cc(6) /-5.07182677775691e-03/, &
&cc(7) / 8.38643256650893e-04/, cc(8) /-3.34223415981738e-04/, &
&cc(9) /-2.15746207281216e-05/, cc(10)/ 1.28560650086065e-04/, &
&cc(11)/-1.56456413510232e-05/, cc(12)/-1.52025513597262e-05/, &
&cc(13)/ 4.04001013843204e-06/, cc(14)/-5.95896122752160e-07/, &
&cc(15)/-4.34985305974340e-07/, cc(16)/ 7.13472533530840e-07/, &
&cc(17)/-5.34302186061100e-08/, cc(18)/-1.76003581156610e-07/, &
&cc(19)/ 3.85028855125900e-08/, cc(20)/ 1.92576544441700e-08/, &
&cc(21)/-1.00735358217200e-08/, cc(22)/ 3.36359194377000e-09/, &
&cc(23)/ 1.28049619406000e-09/, cc(24)/-2.42546870827000e-09/, &
&cc(25)/ 1.86917288950000e-10/, cc(26)/ 7.13431298340000e-10/, &
&cc(27)/-1.70673483710000e-10/, cc(28)/-1.14604070350000e-10/, &
&cc(29)/ 5.88004411500000e-11/, cc(30)/-6.78417843000000e-12/, &
&cc(31)/-1.21572380900000e-11/, cc(32)/ 1.26561248700000e-11/, &
&cc(33)/ 4.74814180000000e-13/, cc(34)/-5.32309477000000e-12/, &
&cc(35)/ 9.05903810000000e-13/, cc(36)/ 1.40046450000000e-12/, &
&cc(37)/-5.00968320000000e-13/, cc(38)/-1.80458040000000e-13/
data cc(39)/ 1.66162910000000e-13/, cc(40)/-5.02616400000000e-14/, &
&cc(41)/-3.48453600000000e-14/, cc(42)/ 4.60056600000000e-14/, &
&cc(43)/ 5.74000000000000e-16/, cc(44)/-1.95310700000000e-14/, &
&cc(45)/ 3.68837000000000e-15/, cc(46)/ 5.62862000000000e-15/
!     -------------------
!     ****** amax IS A MACHINE DEPENDENT CONSTANT. IT IS ASSUMED THAT
!            sin(x) AND cos(x) ARE DEFINED FOR  abs(x) .LE. amax, AND
!            THAT econ + LN(x) - (1 + 1/x)/x = econ + LN(x)
!            FOR x .GT. amax.
!
amax = 0.1/spmpar(1)
!
!
ax = abs(x)
if (ax.gt.5.0) go to 20
j=n1
bx=0.40*ax-1.0
tx=bx+bx
b1=bb(j)
b2=0.
do 10 i = 1,m1
j=j-1
temp=b1
b1=tx*b1-b2+bb(j)
10 b2=temp
cin=x*x*(bx*b1-b2+bb(1))
return
!
20 if (ax.gt.amax) go to 50
bx=10./ax-1.0
tx=bx+bx
j=n2
b1=cc(j)
b2=0.0
do 30 i = 1,m2
j=j-2
temp=b1
b1=tx*b1-b2+cc(j)
30 b2=temp
aic=bx*b1-b2+cc(2)
!
j=n2-1
b1=cc(j)
b2=0.0
do 40 i = 1,m2
j=j-2
temp=b1
b1=tx*b1-b2+cc(j)
40 b2=temp
rc=bx*b1-b2+cc(1)
!
cin=(rc*sin(ax)-aic*cos(ax))/ax
cin=(econ-cin)+alog(ax)
return
!
50 cin=econ+alog(ax)
return
end function cin

subroutine cexexi (z, w)
implicit none
integer :: i
real :: const, euler, pm, qm, r, ss, x, y, zeta2
!-----------------------------------------------------------------------
!        Computation of the exponential exponential integral
!-----------------------------------------------------------------------
complex, intent(in) :: z
complex, intent(inout) :: w
real :: ts(2), sr(2), sm(2), tm(2), qf(2), zl(2)
real :: ed(18), ee(18), dd(19), de(19), cd(18), ce(18)
!-------------------------
!     euler = euler CONSTANT
!     const = (pi*pi)/4
!     zeta2 = THE RIEMANN ZETA FUNCTION EVALUATED AT 2
!-------------------------
data const /2.46740110027234/
data euler /.577215664901533/
data zeta2 /1.64493406684823/
!-------------------------
data ed(1)  /0.00000000000000e+00/, ed(2)  /.311105957086528e-01/, &
&ed(3)  /.103661260539112e+00/, ed(4)  /.216532335244554e+00/, &
&ed(5)  /.369931427960192e+00/, ed(6)  /.566766259990589e+00/, &
&ed(7)  /.814042066324748e+00/, ed(8)  /.112384247540813e+01/, &
&ed(9)  /.151400478148512e+01/, ed(10) /.200886795032284e+01/, &
&ed(11) /.264052411823592e+01/, ed(12) /.345098449933392e+01/, &
&ed(13) /.449583360763202e+01/, ed(14) /.585058263409822e+01/, &
&ed(15) /.762273501463380e+01/, ed(16) /.997814501584578e+01/, &
&ed(17) /.132122064896408e+02/, ed(18) /.180322948376021e+02/
data ee(1)  /.850156516121093e-02/, ee(2)  /.505037465849058e-01/, &
&ee(3)  /.836817368956407e-01/, ee(4)  /.107047582417607e+00/, &
&ee(5)  /.120424719029462e+00/, ee(6)  /.125096631582229e+00/, &
&ee(7)  /.122314435224685e+00/, ee(8)  /.112621417553907e+00/, &
&ee(9)  /.963419407392582e-01/, ee(10) /.747398422757511e-01/, &
&ee(11) /.508596135953441e-01/, ee(12) /.290822706773628e-01/, &
&ee(13) /.132201640530101e-01/, ee(14) /.443802939829067e-02/, &
&ee(15) /.992612478987576e-03/, ee(16) /.126579795112011e-03/, &
&ee(17) /.702150908253350e-05/, ee(18) /.910281532564632e-07/
!-------------------------
data dd(1)  /0.00000000000000e+00/, dd(2)  /.419556678374293e-01/, &
&dd(3)  /.117533661648665e+00/, dd(4)  /.228560237455987e+00/, &
&dd(5)  /.375667350161240e+00/, dd(6)  /.791594846276672e+00/, &
&dd(7)  /.107546889623058e+01/, dd(8)  /.142659208030841e+01/, &
&dd(9)  /.186290554952377e+01/, dd(10) /.240730009509856e+01/, &
&dd(11) /.308854035607524e+01/, dd(12) /.394277605155259e+01/, &
&dd(13) /.501593196543981e+01/, dd(14) /.636759180748651e+01/, &
&dd(15) /.807776193096055e+01/, dd(16) /.102598961138887e+02/, &
&dd(17) /.130896768422610e+02/, dd(18) /.168832169085916e+02/, &
&dd(19) /.224083240941713e+02/
data de(1) /-.346911733535892e-03/, de(2) /-.603787732461745e-02/, &
&de(3) /-.152461305949249e-01/, de(4) /-.210582169827291e-01/, &
&de(5) /-.171894208720754e-01/, de(6)  /.314323467033032e-01/, &
&de(7)  /.750898531566972e-01/, de(8)  /.124689787807260e+00/, &
&de(9)  /.168579075090035e+00/, de(10) /.191715080699511e+00/, &
&de(11) /.182600794550836e+00/, de(12) /.142345674307147e+00/, &
&de(13) /.874862222419327e-01/, de(14) /.402175083288425e-01/, &
&de(15) /.128575005680180e-01/, de(16) /.257673782598441e-02/, &
&de(17) /.275955003784349e-03/, de(18) /.119139315517122e-04/, &
&de(19) /.107292980199386e-06/
!-------------------------
data cd(1)  /0.00000000000000e+00/, cd(2)  /.237286128313683e-01/, &
&cd(3)  /.854113210668760e-01/, cd(4)  /.185276627282059e+00/, &
&cd(5)  /.323741526616688e+00/, cd(6)  /.503045460381267e+00/, &
&cd(7)  /.728806607587188e+00/, cd(8)  /.101122770102872e+01/, &
&cd(9)  /.136598448171249e+01/, cd(10) /.181510139038929e+01/, &
&cd(11) /.238824701955419e+01/, cd(12) /.312490532008812e+01/, &
&cd(13) /.407802489894445e+01/, cd(14) /.532033545554865e+01/, &
&cd(15) /.695624307290579e+01/, cd(16) /.914759902547031e+01/, &
&cd(17) /.121829074388544e+02/, cd(18) /.167511311969873e+02/
data ce(1)  /.349517258926827e-01/, ce(2)  /.135849105925897e+00/, &
&ce(3)  /.158850581552296e+00/, ce(4)  /.153001434535435e+00/, &
&ce(5)  /.134520752856461e+00/, ce(6)  /.111913051619671e+00/, &
&ce(7)  /.892008386656190e-01/, ce(8)  /.679227205472067e-01/, &
&ce(9)  /.486723197887211e-01/, ce(10) /.320170976532266e-01/, &
&ce(11) /.187008965021111e-01/, ce(12) /.929708414427865e-02/, &
&ce(13) /.372604763161087e-02/, ce(14) /.111989537559823e-02/, &
&ce(15) /.228057496872353e-03/, ce(16) /.269596227781453e-04/, &
&ce(17) /.141255430224301e-05/, ce(18) /.176352326808806e-07/
!-------------------------
x = real(z)
y = aimag(z)
r = x*x + y*y
!
if (r .le. 1.0) go to 100
if (r .ge. 1296.0) go to 10
if (x .lt. 0.07*y*y) go to 30
go to 40
!-----------------------------------------------------------------------
!                     Asymptotic expansion
!-----------------------------------------------------------------------
10 qf(1) =  x/r
qf(2) = -y/r
sm(1) = -qf(1)
sm(2) = -qf(2)
tm(1) =  sm(1)
tm(2) =  sm(2)
pm = 1.0
20 ts(1) = tm(1)*qf(1) - tm(2)*qf(2)
   ts(2) = tm(1)*qf(2) + tm(2)*qf(1)
   tm(1) = pm*ts(1)
   tm(2) = pm*ts(2)
   pm = pm + 1.0
   ts(1) = tm(1)/pm
   ts(2) = tm(2)/pm
   if (abs(sm(1)) + abs(ts(1)) .ne. abs(sm(1))) go to 21
   if (abs(sm(2)) + abs(ts(2)) .eq. abs(sm(2))) go to 130
21 sm(1) = sm(1) + ts(1)
   sm(2) = sm(2) + ts(2)
   if (pm .lt. 36.0) go to 20
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
   tm(2) =  ce(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
go to 130
!-----------------------------------------------------------------------
!                 Expansion involving EI and DI
!-----------------------------------------------------------------------
40 zl(1) = euler + 0.5*alog(r)
zl(2) = atan2(-y, -x)
!
!                    SET sm = exp(z)*EI(-z)
!
sm(1) = 0.0
sm(2) = 0.0
do i = 1,18
   ts(1) = -x - ed(i)
   ts(2) = -y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) =  ee(i)*ts(1)/ss
   tm(2) = -ee(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
sr(1) = zl(1)*sm(1) - zl(2)*sm(2)
sr(2) = zl(1)*sm(2) + zl(2)*sm(1)
!
!                    SET sm = exp(z)*DI(-z)
!
sm(1) = 0.0
sm(2) = 0.0
do i = 1,19
   ts(1) = -x - dd(i)
   ts(2) = -y
   ss = ts(1)*ts(1) + ts(2)*ts(2)
   tm(1) =  de(i)*ts(1)/ss
   tm(2) = -de(i)*ts(2)/ss
   sm(1) = sm(1) + tm(1)
   sm(2) = sm(2) + tm(2)
end do
ts(1) = -(x*sm(1) + y*sm(2))/r
ts(2) = -(x*sm(2) - y*sm(1))/r
!
!                    Compute the expansion
!
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
   if (abs(sm(1)) + abs(ts(1)) .ne. abs(sm(1))) go to 71
   if (abs(sm(2)) + abs(ts(2)) .eq. abs(sm(2))) go to 80
71 sm(1) = sm(1) - ts(1)
   sm(2) = sm(2) - ts(2)
   go to 70
80 sm(1) = sr(1) + sm(1)
sm(2) = sr(2) + sm(2)
!
!                      Compute exp(-z)*sm
!
qm = exp(-x)
qf(1) = qm*cos(-y)
qf(2) = qm*sin(-y)
ts(1) = qf(1)*sm(1) - qf(2)*sm(2)
ts(2) = qf(1)*sm(2) + qf(2)*sm(1)
sm(1) = ts(1)
sm(2) = ts(2)
go to 130
!-----------------------------------------------------------------------
!                  SERIES FOR x*x + y*y .LE. 1
!-----------------------------------------------------------------------
100 sm(1) = 0.0
sm(2) = 0.0
zl(1) = euler + 0.5*alog(r)
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
   if (abs(sm(1)) + abs(ts(1)) .ne. abs(sm(1))) go to 111
   if (abs(sm(2)) + abs(ts(2)) .eq. abs(sm(2))) go to 120
111 sm(1) = sm(1) + ts(1)
   sm(2) = sm(2) + ts(2)
   go to 110
120 sm(1) = sr(1) + sm(1)
sm(2) = sr(2) + sm(2)
!-----------------------------------------------------------------------
!                         Termination
!-----------------------------------------------------------------------
130 w = cmplx(sm(1), sm(2))
return
end subroutine cexexi

