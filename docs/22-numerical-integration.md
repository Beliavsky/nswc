[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-398"></a>
## Numerical Integration

<small>Original source: [View scanned PDF page 398](../scans/page_0398.png)</small>

<a id="topic-398-01"></a>
### Evaluation Of Integrals Over Finite Intervals

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QSUBA` | `REAL FUNCTION` | `F, A, B, EPSIL, MCOUNT, RELERR, IND` | [`L102125`](../source_parts/nswc_part_10.f90#L6543) |
| `QAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L102617`](../source_parts/nswc_part_10.f90#L7035) |
| `QXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [`L104639`](../source_parts/nswc_part_10.f90#L9057) |
| `DQAGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L105702`](../source_parts/nswc_part_10.f90#L10120) |
| `DQXGS` | `SUBROUTINE` | `F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK` | [`L107772`](../source_parts/nswc_part_11.f90#L1413) |


QAGS, QXGS, QSUBA, DQAGS, and DQXGS are available for computing integrals L F(x) dz over finite intervals. The subroutines QAGS and QXGS and the function QOQUBA yield single precision results. These procedures are adaptive. In such procedures, the selection of the points at which the integrand is evaluated depends on the nature of the integrand. DQAGS and DQXGS are double precision versions of the subroutines QAGS and QXGS.

QSUBA is applicable only when F and its derivatives have no singularities in the closed interval [a,b]. Otherwise, QAGS or QXGS should be used. These subroutines are appropriate when F(z) is continuous except possibly for a finite number of singularities. QAGS and QXGS generally yield accurate results when any singularities which exist are ‘ocated at the endpoints of the interval [a, b|. However, if F has an exceedingly narrow spike which contributes significantly to the value of the integral, then the subroutines may overlook the spike and produce incorrect results. QAGS and QXGS normally have approximately the same accuracy. QAGS uses less storage than QXGS, but it frequently requires considerably more function evaluations than QXGS. Consequently, QXGS is recommended when the integrand F(z) is expensive to compute.

```fortran
CALL QAGS(F, A, B, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK)
```

F(a) is a user defined function whose arguments and values are assumed to be real numbers. The purpose of QAGS is to compute the integral i F(x) dz. F need not be defined at a and 6, and it is not required that a < 6b. F must be declared in the calling program to be of type EXTERNAL.

AERR and RERR. are the absolute and relative error tolerances to be used, and z is a variable. When QAGS is called, z is assigned the value obtained for J = fp F(z)dz. The subroutine attempts to obtain a value z which satisfies [J — z| < max{AERR, RERR.- [/]}. it is assumed that AERR > 0 and RERR > 0. If one wants accuracy to k significant digits then set NERR = 107%. If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR and NUM are variables. When QAGS terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an array of dimension #@ and WK an array of dimension m. IWK and WK are work spaces for the routine. The input argument # is the maximum number of subintervals in which the interval of integration may be partition:d. It is assumed that @ > land m > 4€. The argument nis a variable. When QACS terminated, n =: the number of subintervals that appeared in the partition. Normally n < 100.

HERR is a variable that reports the status of the results. When the routine terminates, HERR has one of the following values:

IERR = O The routine s satisfied that the integral has been computed to the desired accuracy.


<small>Original source: [View scanned PDF page 399](../scans/page_0399.png)</small>

[ERR =: f The interval of integration was partitioned into & subintervals. 5 I More subintervals are needed to compute the integral to the desired accuracy.

a

HERR = 2 The integral has been computed, but because of roundoff error

QAGS is not certain of the accuracy of the result. The error may

be greater than that reported by BRROR.,

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

TERR = 4 The algorithm does not converge. If, is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

TERR = 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR == 6 (Input Error) Hither 2 < 1, m < 4@, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to 0.

**Remark.** NUM < 42(€-- 1) + 21 Algorithm. The 21 point Kronrod rule and ¢-algorithm of P. Wynn are used.

**Programming.** QAGS employs the subroutines QAGSE, QK21F, QPSRT, and QELG. These routines were developed by Robert Piessens and Elise de Doncker-Kapenga (Katholiek Universiteit Leuven, Belgium), and modified by A. H. Morris and Los Alamos National Laboratory. The function SPMPAR is also used.

**Reference.** Piessens, R., de Doncker-Kapenga, E., Uberhuber, C. W., and Kahaner, D. K., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.

```fortran
CALL QXGS(F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK)
```

F is a user defined function whose arguments and values are assumed to be real numbers, The purpose of QXGS is to compute the integral fp F(x) dz. F must be defined at a and 6, but it is not required that a < 6. F must be declared in the calling program to be of type EXTERNAL.

AFRR and RERR are the absolute and relative error tolerances to be used, and z is a variable. When QXGS is called, z is assigned the value obtained for J = fr F(z2)dz. The subroutine attempts to obtain a value z which satisfies [J ~ z| < max{AERR, RERR- |/|}. It is assumed that AIERR > 0 and RERR > 0. If one wants accuracy to k significant digits then set RERR = 10° *. If RERR = 0 then if, is ass. ned that machine accuracy is desired.

ERROR is a variable. When QXGS terminates, ERROR is the estimated absolute error of z.

IWK is an array of dimension j and WK an array of dimension m. [WK and WK are work spaces for the routine. The input argument @ is the maximum number of subintervals


<small>Original source: [View scanned PDF page 400](../scans/page_0400.png)</small>

in which the interval of integration may be partitioned. It is assumed that £ > 1, ys > 32, and m > 462. The argument n is a variable. When QXGS terminates, n = the number of subintervals that appeared in the partition. Normally n < 100.

TERR is a variable that reports the status of the results. When the routine terminates, TERR he: one of the following es;

TERR = 0 The routine; ied that the integral has been computed to the desired accu: «.

IERR. = 1 The interval 1 2gration was partitioned into & subintervals. More subinte ¥i.: ‘re needed to compute the integral to the de-

sired accurac ;.

TERR = 2 The integral hus en computed, but because of roundoff error QXGS is not cer i of the accuracy of the result. The error may be greater thar : 4 reported by ERROR.

IERR = 3 Extremely bad in grand behavior occurs in the interval of inte-

gration. The + 2 is not certain of the accuracy obtained. TERR = 4 The algorithm: aot converge. It is assumed that the requested accuracy can! achieved and that the result is the best which

can be obtain

{ERR = 5 The integral ma,’ be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR = 6 (Input Error). Either 2 < 1, p < 38, m < 462, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, and n are set to 0.

**Remarks.**

```text
(1) If F is unbounded at a or b, then set F(a) or F(5) to a dummy value, say 9.
(2) The first 4@ locations of WK serve the same purpose for QXGS as for QAGS. Fiinctiona!
values are stored in the remaining 422 locations of WK.
```

**Algorithm.** The recursive monotone quadrature formulas of P. Favati, G. Lotti, and F. Romani, and the e-algorithm of P. Wynn are used.

**Programming.** QXGS employs the subroutines QXGSE, QXCPY, QKLQM, QXRUL, QXRRD, QPSRT, and QELG. QXGS js an adaptation of QAGS where the Gauss~Kronrod formulae have been replaced with the recursive monotone formulae. QXGS wag designed by Paola Favati (Instituio di Elaborazione dell’ Informazione, CNR, Pisa), Grazia Lotti, and Francesco Romani (Universita di Pisa, Italy), and modified by A. U. Morris. The function SPMPAR is also used.

**Reference.** Favati, P., Lotti, G., and Romani, F., “Algorithm 691. Improving QUADPACK Automatic Integration Routines,” ACM Trans. Math Software 17 (1991), pp. 218-282 QSUBA(F, a,b, RERR,MCOUNT, ERROR, IERR) F(z) is a user defined function whose arguments and values are assumed to be real


<small>Original source: [View scanned PDF page 401](../scans/page_0401.png)</small>

numbers. The purpose of QSUBA is to compute the integral i F(x) dz. F need not be defined at the points a and 6. However, it is assumed that a < 6. F must be declared in the calling program to be of type EXTERNAL.

RER is the relative error tolerance to be satisfied. lt is assumed that RERR > O. If ~e wants accuracy to k significant digits then set RLRR = 107*.

The input argument MCOUNT is the maximum: number of points at which # may be evaluated. It is recommended that MCOUNT > 1000.

ERROR is a variable that is set by QSUBA. If the value of QSUBA is not 0 then ERROR is an estimate of the relative error of the computed result. Otherwise, if the value of OSUBA is 0 then ERROR is an estimate of the absolute error.

IERR is a variable that reports the status of the results. When QSUBA terminates, TERR has one of the following values: IERR = 0 The function QSUBA is satisfied that the integral has been computed to the desired accuracy. JERR = 1 The integral has been computed, but QSUBA is not certain of the accuracy of the result. {ERR = 2 F(x) was evaluated at MCOUNT points. More evaluations are needed to complete the computation of the integral. IERR = 3 The function QSUBA cannot compute the integral te the desired accuracy. If IER =: 0 or 1 then the function QSUBA is assigned the value obtained for the integral. If TERR = 2 then QSUBA has for its value the most recent acceptable partial estimate made

the value of the integral that it can make.

**Remark.** QSUBA assumes that F and its derivatives have no singularities in the closed interval la, 6}. If this is not the case then QAGS or QXGS should be used.

**Algorithm.** Gaussian quadrature is employed.

**Programming.** QSUBA calls the subroutine QUAD. QSUBA and QUAD were written by T. N. L. Patterson (Queen’s University, Belfast, Northern Ireland}, and QSUBA was modified by A. dl. Morris. The function SPMPAR is used.

**Reference.** Patterson, T. N. L.,“Algorithm: for Automatic Numerical Integration Over a Finite Interval,” Comm. ACM 16 (1973), pp. 694-€99, CALL DQAGS(?, a,b, APRR,RERR,z, ERROR,NUM,IERR, 8, 1, nIWK,WK)

F(z) is a user defined function whose arguments and values are assumed to be double precision numbers. The purpose of DQAGS is to compute the integral f, F(r)dr. The arguments @ and 6 are double precision numbers. # need not be defined at a and 6, and


<small>Original source: [View scanned PDF page 402](../scans/page_0402.png)</small>

it is not required that a < t. F must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL.

AERR and RERR are double precision numbers and z a double precision variable. AERR and RERR are the absolute and relative error tolerances to be used. When DQAGS is called, z is assigned the value obtained for J = sf F(x) dz. The subroutine attempts to obtain a value z which satisfies |J — z| < max{AERR, RERR- |/|}. It is assumed that AERR > 0 and RERR > O. If one wants accuracy to k significant digits then set RERR = i0-*, If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR is a double precision variable and NUM an integer variable. When DQAGS terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an integer array of dimension @ and WK a double precision array of dimension m. IWK and WK are work spaces for the routine. The argument @ is the maximum number of subintervals in which the interval of integration may be partitioned. It is assumed that €> land m > 4é@. the argument n is a variable. When DQAGS terminates, n = the number of subintervals that appeared in the partition. Normally n < 100.

```text
IERR is a variable that reports the status of the results. When the routine terminates,
IERR has one of the following values:
```

IERR = 0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

IERR = 2 The integral has been computed, but because of roundoff error DQAGS is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

TERR = 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

IERR := 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR = 6 (Input Error) Either 2< 1, m < 4@, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to 0.

**Remark.** NUM < 42(@-- 1) 4 21.

**Algorithm.** The 2! point Kronrod rule and e-algorithm of P. Wynn are used. Programming. DQAGS employs the routines DQAGSE, DQK21, DQPSR, and DQELG. These subroutines are double precision versions by A. H. Morris of the routines QAGSE,

QKR2UF, QPSRT, and QHLG. The function DPMPAR is also used.


<small>Original source: [View scanned PDF page 403](../scans/page_0403.png)</small>

**Reference.** Piessens, R., de Doncker-Kapenga, &., Uberhuber, C. W., and Kahaner, D. K., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.

```fortran
CALL DQXGS(F, A, B, EPSABS, EPSREL, RESULT, ABSERR, IER, LIMIT, LENIW, LENW, LAST, IWORK, WORK)
```

F is a user defined function whose arguments and values are assumed to be double precision numbers. The purpose of DQXGS is to compute the integral fp F(x)dz. The arguments a and 6 are double precision numbers. F must be defined at a and 6, but it is not required that a < b. F must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL.

AERR and RERR are double precision numbers and z a double precision variable. AERR and RERR are the absolute and relative error tolerances to be used. When DQXGS is called, z is assigned the value obtained for J = fp F(z)dz. The subroutine attempts to obtain a value z which satisfies {J — z| < max{AERR, RERR- |/|}. It is assumed that AERR > 0 and RERR > 0. If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR is a double precision variable. When DXQGS terminates, ERROR is the estimated absolute error cf z.

IWK is an integer array of dimension » and WK a double precision array of dimension m. IWK and WK are work spaces for the routine. The argument @ is the maximum number of subintervals in which the interval of integration may ke partitioned. It is assumed that €> 1, > 3é, and m > 46é. The argument n is a variable. When DQXGS terminates, n = the number of subintervals that appeared in the partition. Normally n < 100.

```text
IERR is a variable that reports the status of the results. When the routine terminates,
IERR has one of the following values:
```

IERR = 0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

IRR = 2 The integral has been computed, but because of roundoff error DQXGS is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad int2grand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

IERR <= 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

IERR -. 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

IERR~ 6 (Input Error). Hither @ < 1, < 30, m < 46£ AERR < OQ, or RERR < 6. In this case, the variables z, ERROR, and n are set to 0.


<small>Original source: [View scanned PDF page 404](../scans/page_0404.png)</small>

**Remarks.**

(1) If F is unbounded at a or 6, then set F(a) or #(b) to a dummy value, say 0.

(2) The first 4@ locations of WK serve the same purpose for DQXGS as for DQAGS. Functional values are stored in the remaining 422 locations of WK.

**Algorithm.** The recursive monotone quadrature formulas of P. Favati, G. Lotti, and F. Romani, and the e-algorithm of P. Wynn are used.

**Programming.** DQXGS employs the routines DQXGSE, DQXCPY, DQXLQM, DQXRUL, DQXRRD, DQPSRT, and DQELG. DQXGS is an adaptation of DQAGS where the Gauss— Kronrod formulae have been replaced with the recursive monotone formulae. DQXGS was designed by Paola Favati (Instituto di Elaborazione dell’Informazione, CNR, Pisa), Grazia Lotti, and Francesco Romani (Universita di Pisa, Italy) and modified by A. H. Morris. The function DPMPAR is also used.

**Reference.** Favati, P., Lotti, G., and Romani, F., “Algorithm 691. Improving QUADPACK Automatic Integration Routines,” ACM Trans. Math Software 17 (1991), pp. 218-232.


<small>Original source: [View scanned PDF page 405](../scans/page_0405.png)</small>

<a id="topic-405-01"></a>
### Evaluation of Integrals over Infinite Intervals

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `QAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L103452`](../source_parts/nswc_part_10.f90#L7870) |
| `DQAGI` | `SUBROUTINE` | `F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK` | [`L106561`](../source_parts/nswc_part_11.f90#L202) |


The subroutines QAGI and DQAGI are available for computing integrals over infinite intervals. QAGI yields single precision results and DQAGI yields double precision results. QAGI and DQAGI are adaptive routines.

```fortran
CALL QAGI(F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK)
```

F(x) is a user defined function whose arguments and values are assumed to be real numbers. The argument a is a real number, z is a variable, and MO may be 1, —1, or 2. When QAGI is called, z is assigned the value f° F(x) dz if MO = 1 and the value f°. F(z) dz if MO = -1. Otherwise, if MO = 2 then z is assigned the value [| F(x) dz. If MO = +1 then F need not be defined at a. Otherwise, if MO = 2 then a is not used. F must be declared in the calling program to be of type EXTERNAL.

AERR and RERR are the absolute and relative error tolerances to be used. The subroutine attempts to obtain a value z which satisfies | [ F(z) dz—z| < max{AERR,RERR: | f F(z)dz|}. It is assumed that AERR > 0 and RERR > 0. If one wants accuracy to k significant digits then set RERR = 10~*. If RERR = 0 then it is assumed that machine accuracy is desired.

ERROR and NUM are variables. When QAGI terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an array of dimension £ and WK is an array of dimension m. IWK and WK are work spaces for the routine. The input argument @ is the maximum number of subintervals in which the interval of integration may be partitioned. It is assumed that @> 1 and m > 4@. The argument n is a variable. When QAGI terminates, n == the number of subintervals that appeared in the partition. Normally n < 100.

IERK is a variable that reports the status of the results. When the routine terminates, TERR has one of the following values:

IERR =0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

IERR = 2 The integral has been computed, but because of roundoff error QAGI is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

IERR == 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which

|

can be obtained. IERR = 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.


<small>Original source: [View scanned PDF page 406](../scans/page_0406.png)</small>

TERR = 6 (Input Error, Either €< 1, m < 42, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to 0.

**Note.** F may have a singularity at a when MO = +1. However, it is recommended that no singularities appear in the interior of the interval of integration.

**Algorithm.** The integrals are transformed 4s follows:

ek

re dt J Fe) de = | F(a-14+1/t)5 a 9

[ F(2) dz = [ Fla+1— 1)

f P(2)dz = fire +1/t) +P -1/))S

The transformed integrals are computed by the 15 point Kronrod rule and the e-algorithm of P. Wynn.

**Programming.** QAGI employs the subroutines QAGIE, QK15I, QPSRT, and QELG. These routines were developed by Robert Piessens and Elise de Doncker-Kapenga (Katholieke Universiteit Leuven, lieverlee, Belgium), and modified by A. H. Morris and Los Alamos National Laboratory. The function SPMPAR is also used.

**Reference.** Piessens, R., de Doncker-Kapenga, E., Uberhuber, C. W., and Kahaner, D. K.., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.

```fortran
CALL DQAGI(F, BOUND, INF, EPSABS, EPSREL, RESULT, ABSERR, NEVAL, IER, LIMIT, LENW, LAST, IWORK, WORK)
```

F(x) is a user defined function whose arguments and values are assumed to be double precision numbers. The argument @ is a double precision number, z is a double precision variable, and MO may be 1, --1, or 2. When DQAGI is called, z is assigned the value f<° F(z) dz if MO = 1 and the value f°. #(z)dz if MO = —1. Otherwise, if MO = 2 then z is assigned the value ine F(x) dx. If MO = +1 then F need not be defined at a. Otherwise, if MO = 2 then a is not used. F must be declared in the calling program to be of types DOUBLE PRECISION and EXTERNAL.

AERR and RERR are the absolute and relative error tolerances to be used. The subroutine attempts to obtain a value z which satisfies | [ F(z) dz - z| < mar{AERR,RERR- | f F(z) dz|}. %t is assumed that AFRR and RERR are nonnegative double precision numbers. If one wants accuracy to k significant digits then set RERR = 10°*. If RERR - 0 then it is assumed that machine accuracy is desired.

ERROR is a double precision variable and NUM an integer variable. When DQAGI] terminates, ERROR is the estimated absolute error of z and NUM the number of points at which F was evaluated.

IWK is an integer array of dimension @ and WK a double precision array of dimension m. IWK and WK are work spaces for the routine. The argument @ 1s the maximum number


<small>Original source: [View scanned PDF page 407](../scans/page_0407.png)</small>

of subintervals ix which the interval of integration may be partitioned. It is assumed that £'> Land m > 4é. The argument n is a variable. When DQAGI terminates, n= the number of subintervals that appeared in the partition. Normally n < 100.

TERR is a variable that reports the status of the results. When the routine terminates, IERR has of the following values:

JERR = 0 The routine is satisfied that the integral has been computed to the desired accuracy.

IERR = 1 The interval of integration was partitioned into @ subintervals. More subintervals are needed to compute the integral to the desired accuracy.

{ERR = 2 The integral has been computed, but because of roundoff error DQAGI is not certain of the accuracy of the result. The error may be greater than that reported by ERROR.

IERR = 3 Extremely bad integrand behavior occurs in the interval of integration. The routine is not certain of the accuracy obtained.

TERR = 4 The algorithm does not converge. It is assumed that the requested accuracy cannot be achieved and that the result is the best which can be obtained.

IERR = 5 The integral may be divergent or it may converge extremely slowly. In this case, the value for z may be meaningless.

TERR = 6 (Input Error) Either <1, m < 42, AERR < 0, or RERR < 0. In this case, the variables z, ERROR, NUM, and n are set to O.

**Remarks.** F may have a singularity at a when MO = +1. However, it is recommended that no singularities appear in the interior of the interval of integration. DQAGI is a double precision version of the routine QAGI.

**Programming.** DQAGI employs the routines DQAGIE, DQKI5I, DQPSRT, and DQELG. ‘These subroutines are double precision versions by A. H. Morris of the subroutines QAGIK, QK15I, QPSRT, and QELG. The function DPMPAR is also used.

**Reference.** Piessens, R., de Doncker-Kapenga, ., Uberhuber, C. W., and Kahaner, D. K., QUADPACK: A Subroutine Package for Automatic Integration, Springer-Verlag, 1983.


<small>Original source: [View scanned PDF page 408](../scans/page_0408.png)</small>

<a id="topic-408-01"></a>
### Evaluation Of Double Integrals Over Triangles

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `CUBTRI` | `SUBROUTINE` | `F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER` | [`L108835`](../source_parts/nswc_part_11.f90#L2476) |


Let f(z,y) be a real-valued function defined on a triangle T. Then the subroutine CUBTRI is available for computing the integral Sy f(z, y) dz dy. CUBTRI is an adaptive routine.

```fortran
CALL CUBTRI(F, T, EPS, MCALLS, ANS, ERR, NCALLS, W, NW, IDATA, RDATA, IER)
```

T ig a 2-dimensional real array of dimension 2 x 3 where T(1,7) and T(2,7) are the x and y coordinates of the j** vertex of the given triangle (7 = 1,2, 3).

IDATA and RDATA are arrays provided by the user containing any integer or real data needed for computing the integrand f(z,y). The arrays may be of any size. F is a user defined real-valued function having the arguments z,y,IDATA,RDATA. It is assumed that F(z,y,IDATA,RDATA) = f(z,y) for any point (z,y) in the triangle of integration T. F must be declared in the calling program to be of type EXTERNAL.

The input argument € is the error tolerance to be satisfied, and A is a variable. When CUBTRI is called, A is assigned the value obtained for ff, f(z,y)dzdy. The routine attempts to obtain a value A which satisfies | ff f(z,y)dzdy — A] < mar{e,e|Al}. Thus if |A| < 1 then ¢ is an absolute tolerance, whereas if |A| > | then ¢ is a relative tolerance. If one wants k digit accuracy then set « = (0-*. ERR is a variable. When CUPTRI terminates, ERR is the estimated error | ff f(x,y) dx dy ~- A| of the result.

The input argument MAX is the maximum number of points (2, y) at which F may be evaluated, and n is a variable. On an initial call to CUBTRI, the user must set n> 0. When the routine terminates, n will have for its value the number of points at which F was evaluated. (For subsequent calls concerning the same integral, see below.)

W is an array of dimension @ for internal use by the routine. The input argument é specifies the maximum number of subtriangles in which the triangle of integration 7 may be partitioned. The subtriangles are stored in W, each subtriangle requiring © storage locations. “Thus @/6 is an estimate of the maximum number of subtriangles that might have to be stored (@ 0 mar{1,3m 4 1} where m= (MAX/19 — I)/4).

TERR is an integer variable that reports the status of the results. When the routine terminates, HERR has one of the following values:

TERR 0 "The integral was computed to the desired accuracy.

IFRR ot MAN Gs too small A must be evaluated at more points.

IERR 2 The storage space Woois full) [ts dimension #imust be increased,

IERR 3 Further subdivision of the subtriangles impossible. This normally occurs when f(r, y) has a singularity in (he region. “The situation can frequently be eliminated by placing the singularity at a vertex of the triangle of integration 7.

TERR 4 No further improvement in accuracy as possible because of roundoff

error in the computation of F or the irregular behavior of Fe

HAS


<small>Original source: [View scanned PDF page 409](../scans/page_0409.png)</small>

IERR = 5 No further improvement in accuracy is possible because subdivision does not change the estimated integral value A. Machine accuracy has probably been reached.

After an initial call to CUBTRI, the routine may be recalled to continue the computation of [fp f(x,y) dxdy. When the routine is recalled, the value of n obtained on the previous call to CUBTRI is used for the next call. This value for n tells the routine where computation should be resumed (using the information previously stored in W). At, least one of the values «, MAX, or € must be modified before CUBTRI is recalled. F, T, n, W, IDATA, and RDATA may not be changed when the routine is recalled.

**Remark.** F may have a singularity at one of the vertices of T (such as in the case when we are computing fo Jo (2? +3y?)~1/? dy dz). However, it is recommended that no singularities appear in the interior of the triangle of integration.

**Algorithm.** The 7-point degree 5 rule of Radon and a new 19-point degree 8 rule are used.

**Programming.** CUBTRI calls the function RNDERR and subroutine CUBRUL. Information is saved in labeled common blocks. The block names are CUBSTA and CUBATB. The routines were written by D. P. Laurie (National Research Institute for the Mathematical Sciences, Pretoria, South Africa),

**Reference.** Laurie, D. P., “Algorithm 584, CUBTRE: Automatic Cubature over a Triangle,” ACM Trans. Math Software 8 (1982), pp. 210-218.

