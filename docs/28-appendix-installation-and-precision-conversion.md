[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-458"></a>
## Appendix: Installation and Precision Conversion

<small>Original source: [View scanned PDF page 458](../scans/page_0458.png)</small>

Installation Of The NSWC Library And Conversion Of Codes From Single To Double Precision Form

Code for the library can be obtained on 9-track tape and on Bd inch disks that can be read by the IBM PC. Two copies of the code are given on a tape.

The first function in the library, namely IPMPAR, must be modified for the particular Fortran being used. IPMPAR provides the integer constants which characterize the integer, single precision, and double precision arithmetics being used (see pp. 3-4).

Instructions are given in the in-line documentation of IPMPAR for defining the constants that are needed. If constants are not provided for the compiler being used, then the Fortran manual for the compiler normally gives the constants for che integer arithmetic. However, help may be needed in obtaining the constants for the single and double precision arithmetics. The subroutines MACH and RADIX are provided for this purpose.

MACH and RADIX, and their subroutines MACH1, STORE2, MACH2, DSTOR2 are the next subprograms after IPMPAR. Instructions for the use of MACH and RADIX are given in MACH. These subroutines are experimental. They are provided only as an aid for obtaining the constants for the single and double precision arithmetics. They are not used by any of the functions and subroutines in the NSWC library, and they are not considered to be part of the library. MACH1 and MACH2 perform some writing. None of the functions and subroutines in the NSWC library perform I/O.

After IPMPAR has been defined, the remainder of the library can be installed. None of the remaining code needs any modification. Codes for the functions and subroutines appear approximately in the order that they appear in the manual.

Single /Double Precision Conversion. The following modifications must be made when a subroutine is converted from single to double precision form.

(2) Replace the functions SPMPAR, EPSLN, and EXPARG with DPMPAR, DEPSLN, and DXPARG. Do not modify the arguments of these functions. DPMPAR, DEPSLN, and DXPARG must be declared to be of type DOUBLE PRECISION when they are employed.

(2) If the function IPMPAR appears in the subroutine then replace [IPMPAR(5) with IPMPAR(8), IPMPAR(6) with IPMPAR(9), and IPMPAR(7) with IPMPAR(10).

