[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-413"></a>
## Ordinary Differential Equations / Initial Value Problems

<small>Original source: [View scanned PDF page 413](../scans/page_0413.png)</small>

<a id="topic-413-01"></a>
### The Initial Value Solvers - Introductory Comments


where f(t,y) = (filt,y), Salt, y)). Assume that y(a) is known. Then for 6 3 a the subroutines ODE, BRK F45, RKF45, GERK, SFODE, and SFODE1 are available for computing y{o). These routines are adaptive variable step, multistep differential equations solvers. ‘The remaining subroutines (RK and RK8} are one step procedures. Given the values y(t) and h, the one step solvers compute a value for y(t -+ h). The problem of selecting a suitable value for h is left to the user. Given y{a) and b, the one step solvers must be repeatedly called to step along the interval from a to b. In contrast, given y(a), 6, and error tolerances that are to be satisfied, the adaptive solvers continually adjust their step size (and possibly order) as they automatically step along the interval from a to b.

The adaptive subroutines differ in their capabilities. ODE, BRKF45, RKF45, and GERK are recommended for nonstiff equations, and SFODE and SFODE! for stiff equations. If one does not know whether the equations are stiff, then ODE should be tried. ODE maintains greater accuracy than the other subroutines, and it notifies the user if the equations appear to be stiff. ODE, BRKF45, RKF45, and GERK are able to handle mildly stiff problems satisfactorily, but SFODE and SFODEI are the only subroutines that can be used for solving extremely stiff problems.

If the equations are nonstiff, then ODE and BRKF45 should first be considered for solving the equations. If accuracy to 10 or more digits is needed then CDE should be used. Otherwise, if accuracy to 8 or fewer digits is desired and the derivative evaluations are inexpensive, thea BRKF45 may be the most efficient subroutine for solving the problem. BRKF45 normally requires more derivative evaluations than ODE, but its overhead is less than that for ODE. The nonstiff solvers RKF45 and GERK may also be used if accuracy to & or fewer digits is desired. However, these routines are not recommended since interpolation is not employed (see the output comments below).

When the user specifies error tolerances to be satisfied, normally he is interested only in the global error (the error of y(b)). However, the adaptive subroutines employ the tolerances for controlling local error (the error generated at each step in the interval from a to 6). No attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. GERK is the only su. routine that estimates the global error. his subroutine employs the same Runge-Kutta-Fehlberg formulae used by RKF45. GERKE js 2-3 times slower than RKF45, but it is more accurate. RK E45 and BRKF45 take roughly the same amount of time, and have approximately the same accuracy.

Output Considerations. Generally, when the equations y’(t) - f(t,u(t)) are to be solved and y(ay) is known, then solutions will be needed at a sequence of points dy, -..,@ya. Tf ODE, BRKF45, SFODE, or SFODEL is used, then the closeness of the output points a, should be of no concern. ‘The subroutines partially ignore a, 4, in the selection of the step size when going from a, to a,j. Instead, they step along the interval using the largest steps that are appropriate (accuracy aud efficiency are the prime concerns). Normally ayy 4

will be passed in the process Hf a,,j is passed then a quick interpolation yields the desired


<small>Original source: [View scanned PDF page 414](../scans/page_0414.png)</small>

result for y(a;41). Thus, the process of solving the equations at a,4, when y(a,) is known may require that no steps be taken (a, may have been passed on a previous call to the routine), or it may require that one or more steps be taken.

The situation is considerably different when RKF45 or GERK is used. Since these subroutines do not have an interpolation procedure, they must select a step size so as not to bypass a;41 when going from a, to aj41. Thus, the output points a, may be so close to one another that inordinately small step sizes are required. If this occurs then the performance of RKF45 and GERK may deteriorate dramatically. The subroutines notify the user when this occurs.

pot)


<small>Original source: [View scanned PDF page 415](../scans/page_0415.png)</small>

<a id="topic-415-01"></a>
### Adaptive Adams Solution Of Nonstiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `ODE` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [`L105715`](../source_parts/nswc_part_10.f90#L10114) |


Let y'(t) = f(t, y(t)) denote a system of n ordinary first order differential equations where f(t,y) = (filt,y), .--.fa(t,y)) and y(t) = (yi(t), ...,yn(t}). Assume that y(a) is known. Then for 6 + @ the subroutine ODE is available for computing y(b). ODE is recommended for nonstiff equations. The algorithm used is a variable order, variable step Adams predictor-correcter procedure.

```fortran
CALL ODE(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
```

The argument F is the name of a user defined subroutine that has the format: CALL F(t, ¥,DY) Y and DY are arrays of dimension n. On input Y contains the values y;(t),...,y,(t) for the argument t. F computes the derivatives yj(t), ...,y/,(¢) using y'(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 100 -++ 21n or larger, and [WK is an array of dimension 5 or larger. WK and IWK contain information needed for subsequent calls to ODE.

it is assumed that a 3 6. The argument Y of ODE is an array of dimension n, and the arguments T,R@RR,AERR,IND are variables. (TOUT need not be a variable.) When ODE is initially called, it is assumed that:

T=a

TOUT = 6

Y(1),...,¥(n) contain the values y;(a), ..., yn(a)

RERR = the relative error tolerance to be satisfied

AERR = the absolute error tolerance to be satisfied

IND = +1 It is preferable, both for efficiency and accuracy, that ODE be permitted to step along the axis from a to 6 using the largest steps that are appropriate. This is what is done when IND is set to 1. If IND = 1 then ODE will step along the axis, possibly passing 6 and going as far as the point a + 10{6 ~ aj. Uf 6 is passed, then the solution for the equations

not defined at all points between 6 and a+ i0(b ~ a). In a situation such 2s this, when integration cannot be permitted to step internally past TOUT, IND must pe set to ~L. If IND =<: -1 then it is required that the subroutine # be defined at TOUT. However, F need not be defined at points t past TOUT. If the equations y’(t) = f(t, y(t)) are not defined at t = TOUT, then it should suffice to let F set each DY(1) 0 when ¢ = TOUT. A solution (if one exists) will be obtained by extrapolation.

If IND is positive (negative), then when ODE terminates IND will have been reset by ODE to one of the values 2,3,4,5,6,7(2, ~3, -4, = 5,--6,7). These values have the following meanings:

IND = 2 The equations have been solved at TOUT. 7 now has the value

TOUT and FY contains the solution al POUT,

IND oo £3 ‘The error tolerances RERK and ARRR are too small. ‘fis set to

the point closest to TOUT for which the equations were solved


<small>Original source: [View scanned PDF page 416](../scans/page_0416.png)</small>

and Y contains the solution at the point. RERR and AERR have been reset to larger acceptable values.

IND = +4 MAXNUM steps were performed.! More steps are needed to reach TOOT. T is set to the point closest to TOUT for which the equations were solved and Y contains the solution at the point.

IND = +5 MAXNUM steps were performed. More steps are needed to reach TOUT. T is set to the point closest to TOUT for which the equations were solved and Y contains the solution at the point. The equations appear to be stiff,

IND = +6 ODE did not reach TOUT because AERR = 0. T is set to the point closest to TOUT for which the equations were solved and Y contains the solution at the point.

IND = 7 No computation was performed. An input error was detected. The user must correct the error and call ODE again.

WIND = +3,+4,+5 then to continue the integration just call ODE again. Similarly, if IND = +6 then reset AERR to be positive and call ODE again. In these cases do not modify T,Y,IND. The output values for these parameters are the appropriate input values for the next call to ODE. However, AERR and RERR may always be modified when continuing an integration.

If the equations appear to be stiff (i.e., if IND = +5) then ODE may not be suitable for solving the equations. In this case it is recommended that a routine designed specifically for stiff equations be used.

Whenever IND = 2 occurs, then the equations have been solved at TOUT = 8. WK and tWK contain information that can often be reused in continuing along the axis and solving the equations at a new point c. To continue the integration, normally one need only reset TOUT to the new value c and call ODE again. Do not modify T, Y,IND. The output values for these parameters are normally the appropriate input values for the next call to ODE. The one exception is when the equations are not defined at points past c. If this occurs, then one should also reset the output value IND = 2 (from the last call to ODE) to the input value IND = —2 for the next call to ODE. If IND is reset to —-2, then integration will not proceed internally past the new TOUT when ODE is recalled. In this case, the subroutine F need not be defined for points past TOUT. However, it is required that F be defined at TOUT.

If after going from a to 6, ODE is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +2 for the next call to ODE. Setting IND to +1! causes the integration procedure to be restarted, thereby eliminating the information being saved in WK and IWK. Restarting not only can take more time, but also can lead to less accurate results. H IND is set to 12, then the integration procedure restarts itself only if the direction of integration is being reversed or IND was negative when ODE was last recalled. The direction of integration is reversed when & does not lie between a@ and c.

‘Mach step normally requires two calls to the subroutine F. Currently the internal parameter MAXNUM

is set at 500,

oad te


<small>Original source: [View scanned PDF page 417](../scans/page_0417.png)</small>

ff one has a choice between setting IND to be positive or negative, then always set IND to be positive. Extrapolation is normally involved when IND is negative. The extrapolation can require more time and be less accurate than the procedures employed when IND is positive.

**Input Errors.** IND =: 7 when one of the following conditions is violated:

(I)n>1

(2) T# TOUT

(3) RERR > 0 and AERR > 0

(4) RERR and AERR are not both 0

(5) 1 < [IND] < 5, or IND = +6 and AERR > 0

(6) When continuing an integration, the input value for T is the output value of TOUT from the previous call to ODE.

The last condition is automatically satisfied if the user has not inadvertently modified T.

Error Control. Assuming that ODE has obtained the correct value for y(t), let e; denote the error generated in the computation Y(t) of y,(t+h) for# = 1, ...,n when ODE steps from t tot+h. The routine attempts at each step to maintain the accuracy D,(e;/w,;)? < 1 where w; =RERR|Y (#)|+AERR. When this criterion is satisfied, then |e,| < w,; for ¢ = 1, ...,n. This criterion includes as special cases relative error (AERR = GC) and absolute error (RERR = 0). However, if AERR = 0 and Y(t) = 0 for some #, then w; = 0 and IND = +46.

When going from T to TOUT, ODE continually adjusts its order and step size so as to maintain accuracy at each step. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion of accuracy can be significant, at times one may wish to double-check the results by rerunning the problem. If this is done, then in the second run ask for greater accuracy.

**Programming.** ODE employs the subroutines DE1, STEP1, and INTRP. These routines were written by L. F. Shampine and M. K. Gordon (Sandia Laboratories). The function SPMPAR is also used.

**Reference.** Shampine, L. F., and Gordon, M. K., Computer Solution of Ordinary Differential Equations, W. H. Freeman and Company, San Francisco, 1975.

eal qt biel


<small>Original source: [View scanned PDF page 418](../scans/page_0418.png)</small>

<a id="topic-418-01"></a>
### Adaptive Block RKF Solution Of Nonstiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `BRKF45` | `SUBROUTINE` | `FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK` | [`L106608`](../source_parts/nswc_part_11.f90#L80) |


Let y/(t) = f(t,y(2)) denote a system of n ordinary first order differential equations where f(t,y) = (fi(t,y),--.,fn(t,y)) and y(t) = (v(t), ...,y,(¢)). Assume that y(a) is known, and that f is defined and continuous on the interval from a to TIEND. Then for any 6 in this interval the subroutine BRKF45 1s available for computing y(6) and its derivative y'(6). BRKE45 was designed for solving nonstiff differential equations when derivative evaluations are inexpensive and the accuracy requirements are low (8 or fewer significant digits). The subroutine employs the Cash block Runge-Kutta-Fehlberg procedure.

```fortran
CALL BRKF45(FCN, NEQN, Y, T, TOUT, TEND, YP, RELERR, ABSERR, IFLAG, WORK, IWORK)
```

The argument F' is the name of a user defined subroutine that has the format: CALL F(t, Y,DY) Y and DY are arrays of dimension n. On input Y contains the values y;(t), ..., yn(t) for the argument t. F computes the derivatives y’,(t), ...,y’,(t) using y’(t) = f(t, y(é)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 6 + 9n or larger, and [WK an array of dimension 5 or larger. WK and IWK contain information needed by subsequent calls to BRKF45.

The arguments Y and DY of BRKF45 are arrays of dimension n, and the arguments T, RERR, and IND are variables. (TOUT, TEND, and AERR need not be variables.) When BRKF45 is initially called, it is assumed that:

T=a

TOUT = 6b

TEND = end of the interval of integration (TEND # a)

Y (1), ...,¥(n) contain the values yi(a),...,yn(a}

RERR = the relative error tolerance to be satisfied (RERR > 0)

AERR = the absolute error tolerance to be satisfied (AERR > 0)

IND = +1 For efficiency, BRK F45 will step along the interval (in 2-step blocks) from a to b, using the largest steps that are appropriate. If IND = --1 then only a single 2-step block will be taken. Otherwise, if IND = 1 then BRKF45 will step along the interval, possibly passing 6 (but never passing TEND). If 6 is passed then the solution for the equations at 6 will be obtained by interpolation.

On output T is set to the point closest to TOUT for which the equations were solved, Y contains the solution y{7') at T, and DY contains the derivative y/(7') at T. Also, IND reports the status of the results. BRKF45 sets IND to one cf the following values: IND >. 2 Hither the equations were solved at TOUT (in which case, T u0w has the value TOUT), or TOUT was beyond TEND and the equations were solved at TREND (in which case, 7 now has the value TEND). IND 2 A single 2 -step block in the direction of TOUT was taken.


<small>Original source: [View scanned PDF page 419](../scans/page_0419.png)</small>

IND =: 3 The error tolerance RERR was too small. RERR has been reset to a larger acceptable value.

IND == 4 18000 derivative evaluations (involving approximately 2000 2- step blocks) were performed. More derivative evaluations are needed to reach TOUT.

IND = & BRKF45 did not reach TOUT because AERR =: 0. AERR must be made positive.

IND = 6 Too much accuracy was requested. RERR or AERR must be increased in value.

IND = 7 An input error was detected (see below).

If IND = 2 and T now has the value TOUT, then the equations have been solved at TOUT = 8. The arrays WK and [WK contain information that can be reused in continuing along the interval from 6 to TEND and solving the equation at a new point c. 'To continue the integration the user need only reset TOUT to the new point c and call BRKF45 again.

If IND = —2 then to continue the integration another 2-step block just call BRKF45 again. In the single 2-step block mode (IND = —-1, —2) the user must keep in mind that each step taken is in the direction of the current TOUT. Upon reaching TOUT (which is indicated by IND = 2 and T = TOUT), the user may define a new TOUT and set IND = +2 for further integration.

If IND = 3 or 4 then to continue the integration just call BRKF45 again. However if IND = 5 then the user must first reset AERR to be positive before BRKF45 can be recalled. If this is not done then the run will be terminated by a STOP instruction! If IND = 6 then it is required that IND be reset to +2 and that AERR or RERR be increased in value. If this is not done then the run will be terminated by a STOP instruction.

If after going from a to b, BRKF45 is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +2 instead of +1. Setting IND = :£1 causes the integration process to be restarted, thereby eliminating the information being saved in WK and IWK. Restarting wastes time and is normally not needed. The only exceptions are when the direction of integration is reversed or TEND is modified. Then the integration must be restarted. (TEND must be modified when the direction of integration is reversed.)

The purpose for the argument TEND is to ensure that no integration is performed past, this point. This is important since F may not be continuous at TEND, or F may not be defined beyond TEND, When the equations are solved at TEND (which is indicated by IND = 2 and T = TEND), then no further integration can be performed. It is always assumed that T ¢ TEND on input.

**Notes.**

(1) 7, n, WK, IWK must never be modified on a continuation call to BRKF45. However, AERR and RERR may be modified at any time.

(2) When continuing an integration, one may switch from the standard multistep mode (IND -. 2) to the single 2 step block mode (IND ~~ 2) when it is convenient to do so.


<small>Original source: [View scanned PDF page 420](../scans/page_0420.png)</small>

**Input Errors.** IND = 7 when one of the following errors is detected:

(I) n<0

(2) T = TEND

(3) Either AERR or RERR is negative.

(4) TOUT and TEND are in opposite directions from T.

(5) IND = 0 or [IND] > 7.

If (2) occurs then integration cannot be continued. Otherwise, the error must be corrected and IND reset to +1 (or +2 when the previous call was a continuation call). If this is not done then the run will be terminated by a STOP instruction when BRKF45 is recalled.

Error Control. When going from T to TOUT, BRKF45 continually adjusts its step size go aS to maintain accuracy at each 2-step block. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion of accuracy can be significant, at times one may wish to double-check the results by rerunning the problem with BRKF45 or ODE. If this is done then in the second run ask for greater accuracy.

**Programming.** BRKF45 employs the subroutines RKFC and EXTRA. These routines were written by J. R. Cash (Imperial College, London), and modified by Desmond J. Higham and A. H. Morris. The function SPMPAR is also used.

**References.** (1) Cash, J.R.,“A Block 6(4) Runge-Kutta Formula for Nonstiff Initial Value Problems,”

ACM Trans. Math Software 15 (1989), pp. 15-28. (2) Higham, D.J., “Remark on Algorithm 669,” ACM Trans. Math Software 17 (1991),

pp. 424-426.


<small>Original source: [View scanned PDF page 421](../scans/page_0421.png)</small>

<a id="topic-421-01"></a>
### Adaptive RKF Solution Of Nonstiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RKF45` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK` | [`L107514`](../source_parts/nswc_part_11.f90#L986) |


Let y/(t) = f(t, y(t)) denote a system of n ordinary first order differential equations where f{t,y) = (fi (t,y), ..-, fa (t, y)) and y(t) = (y1 (¢), ..-, yn (t)). Assume that y(a) is known. Then for 6 # a the subroutine RKF46 is available for computing y(b). RKF45 was designed for solving nonstiff differential equations when derivative evaluations are inexpensive and the accuracy requirements are low (less than 8 significant digits). The routine employs the fourth-fifth order Runge-Kutta-Fehlberg formulae.

```fortran
CALL RKF45(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, WORK, IWORK)
```

The argument F is the name of a user defined subroutine that has the format: CALL F(t, Y,DY) Y and DY are arrays of dimension n. On input Y contains the values y,(t), ..., y(t) for the argument t. F computes the derivatives y}(t), ...,y/(t) using y’(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 3+ 6n or larger, and IWK is an array of dimension 5 or larger. WK and IWK contain information needed for subsequent calls to RKF45.

The argument Y of RKF45 is an array of dimension n, and the arguments 7, KERR, IND are variables. (TOUT and AERR need not be variables.) When RKF45 is initially called, it is assumed that:

T=a

TOUT = 6

Y(1), ...,¥(n) contain the values y;(a), ...,¥,.(a)

RERR = the relative error tolerance to be satisfied (RERR > 0)

AERR =: the absolute error tolerance to be satisfied (AF RR > 0)

```text
IND = x1
Normally IND -= 1. However, if only a single step in the direction of TOUT is to be taken,
then set IND == ~ 1.
```

On output T is set to the point closest to TOUT for which the equations were solved, and Y contains the solution at 7. Also IND reports the status of the results RKB AS sets IND to one of the following values:

IND. 2 The equations were successfully solved at TOUT. Tonow has the

value TOUT. IND- .2 A single step in the direction of TOU'T was taken.

IND 3 The error tolerance RE RR was too small. RERR has been reset to a larger acceptable value.

IND 4 3000 derivative evaluations were performed. More derivative evaluations are needed to reach TOUTE.

IND 5 RRE4AS did not reach TOUT because AIERR oO.) ARERR mast be made positive

IND 6 Poo much accuracy has been requested. ALR o> REER must be

Increased tn value

ner O09


<small>Original source: [View scanned PDF page 422](../scans/page_0422.png)</small>

```text
IND = 7 The closeness of the output points is restricting the natural step
size choice.
IND = 8 An input error was detected (see below).
```

If IND = 2 then the equations have been solved at TOUT == 5. The arrays WK and IWK contain information that can often be reused in continuing along the axis and solving the equations at a new point c. To continue the integration the user need only reset TOUT to the new point c and call RKF45 again.

If IND = —2 then to continue the integration another single step just call RKF45 again. In the single step mode (IND = --1, —2) the user must keep in mind that each step taken is in the direction of the current TOUT. Upon reaching TOUT (which is indicated by IND being set to 2), the user may then define a new TOUT and set IND to +2 for further integration.

If IND = 3 or 4 then to continue the integration just call RKF45 again. However, if IND = 5 then the user must first reset AERR to be positive before RKF45 can be recalled. If this is not done then the run will be terminated by a STOP instruction! If IND == 6 then it is required that IND be reset to +2 and that AERR or RERR be increased in value. If this is not done then the run will be terminated by a STOP instruction.

If IND = 7 then the user should switch to a routine (such as ODE or BRKF45) which performs interpolation. If the user insists on continuing the integration with RKF45 then it is required that IND be reset to +2 before RKF45 is recalled. If this is not done then the run will be terminated by a STOP instruction.

If after going from a@ to 6, RKF45 is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +:2 instead of 4:1. Setting IND => £1 causes the integration process to be restarted, thereby eliminating the information being saved in WK and IWK,. Restarting wastes time and is normally not needed, The one exception is when the direction of integration is to be reversed. Then the integration must be restarted.

**Notes.**

(1) AERR and RERR can be modified each time that RK #45 is called.

(2) When continuing an integration, one may switch from the standard multistep mode (IND © 2) to the one step mode (IND 2) whenever it is convenient to do so.

**Input Errors.** IND) © 8 occurs when one of the following conditions is violated:

(1) nool

(2) FP 4 POUT when IND / 11

(3) RERR + O and ABRR + 0

(END 44, 42,3)4,.. 8

IPIND oS then the error must be corrected and END) reset te tt (or i 2 when the previous call was a continuation call). this ts not done then the ron wil be terminated by a S’POR

instruction when RA PAS os recalled


<small>Original source: [View scanned PDF page 423](../scans/page_0423.png)</small>

Error Control. When going from T to TOUT, RKF45 continually adjusts its step size so as to maintain accuracy at each step. Assuming that RKF45 has obtained the correct value for y(t), let e; denote the error generated in the computation of y(t +A) fort =1,...,n when RKF‘45 steps from ¢ to t+ A. Then at each step the error is controlled so that

les| < RERR + AERR

[ys(t)| + [ys (t + 4)] 2 fort = 1,...,n. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion of accuracy can be significant, at times one may wish to double-check the results. This can best be done by comparing the results obtained by RKF45 with those obtained by ODE or GERK. If ODE is used then ask for greater accuracy. However, if GERK is used then the current error tolerances can be used. GERK is more accurate than RKF45, and it estimates the global error generated.

**Programming.** RKF45 employs the subroutines RKFS and FEHL. These routines were written by H. A. Watts and L. F. Shampine (Sandia Laboratories). The function SPMPAR

is also used.

**References.** Shampine, L. F.,and Allen, R. C., Numerical Computing: An Introduction, W.B. Sanders, Philadelphia, 1973.


<small>Original source: [View scanned PDF page 424](../scans/page_0424.png)</small>

<a id="topic-424-01"></a>
### Adaptive RKF Solution Of Nonstiff Differential Equations With Global Error Estimation

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `GERK` | `SUBROUTINE` | `F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK` | [`L108117`](../source_parts/nswc_part_11.f90#L1589) |


Lei y'(t) == f(t,y(t)) denote a system of n ordinary first order differential equations where f(t,y) = (fi (t,y), ---, fn (t,y)) and y(t) = (yi (t), ..., yn (t)}. Assume that y(a) is known. Then for b 4 a the subroutine GERK is available for computing y(b). GERK was designed for solving nonstiff differential equations when derivative evaluations are inexpensive and the accuracy requirements are low (less than 8 significant digits). The routine employs the fourth-fifth order Runge-Kutta-Fehlberg formulae. GERK estimates the accuracy of the solution y(b).

```fortran
CALL GERK(F, NEQN, Y, T, TOUT, RELERR, ABSERR, IFLAG, GERROR, WORK, IWORK)
```

The argument F is the name of a user defined subroutine that has the format: CALL F(t, Y, DY) Y and DY are arrays of dimension n. On input Y contains the values y; (tj, -.-, yn (t) for the argument t. F computes the derivatives yj(t),...,y/,(t) using y/(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

WK is an array of dimension 3 +4- 8n or larger, and 1WK is an array of dimension 5 or larger. WK and JWK contain information needed for subsequent calls to GERK.

The argument Y of GERK ts an array of dimension n or larger, and the arguments 7° and IND are variables. (TOUT, RERR, AERR need not be variables.) When GERK is initially called, it is assumed that:

Teoa

TOUT ~ b

Y(1),.-..¥(n) contain the values y; (a), ..., yn (@)

RERR | the relative error tolerance to be satisfied (RERR > 0)

AERR -. the absolute error tolerance to be satisfied (ARBRE > 0)

IND t | Normally IND LL. However, if only a single step in the direction of TOUT is to be taken then set IND I.

GERROR is an array of dimension nor larger. Qn output Vis set to Che point closest to TOUT for which the equations were solved, Y contains the solution at 7) and GEEK ROR(s)

is an estimate of the error of V(r) fora I, oooym. Also IND reports the status of the results. GERK sets IND to one of the following values: IND 2 ‘The equations were successfully solved at POUT 7 now has the

value POUT

IND 2 A single step in the direction of “POUT was taken,

IND 3 9000 derivative evaluations were performed More derivative evaluations are needed to reach POUT

INI) A GERB did not reach POUR because AR RR O00 ARERR nous be

Ihade positive

Aig


<small>Original source: [View scanned PDF page 425](../scans/page_0425.png)</small>

IND == 5 Too much accuracy has been requested. AERR or RERR must be increased in value.

```text
IND = 6 The closeness of th2 ouput points is restricting the natural step
size choice.
IND = 7 An input error was detected (see below)
```

If IND) == 2 then the equations have been solved at TOUT = 5. The arrays WK and TWK contain information that can often be reused in continuing along the axis and solving the equations at a new point c. To continue the integration the user need only reset TOUT to the new point c and call GEEK again.

If IND = —2 then to continue the integra‘icn another single step just call GERK again. In the sing! step mode (IND = ~1,—2) the user must keep in mind that each step taken

is in the direction of the current TOUT. Upon reaching TOUT (which is indicated by IND being set to 2), the user may then define a new TOUT and set IND to +2 for further integration.

if IND = 3 then to continue the integration just call GERK again. However, if IND = 4 then the user must first reset AERR to be positive before GERh can be recalled. If this is not done then the run will be terminated by a STOP instruction! If IND = 5 then it is required that IND he reset to 4:2 and that AERR or RERR be increased in value. If this is not done then the run will be terminated by a STOP instr. ction.

If IND := 6 then the user should switch to a routine (such as ODE or BRKF45) which performs interpolation. If the user insists sn continuing the integration with GERK then it is required that IND be reset to +2 before GERK is recalled. I* this is not dene then the run will be terminated by a STOP instruction.

If after going from a to 6, GERK is recalled to continue the integration and solve the equations at a new point c, then it is important that IND be set to +2 instead of LL. Setting IND = +1 causes the integration process to be restarted, thereby eliminating the information being saved in WK and IWK. Restarting wastes time and is normally not needed. The one exception is when the direction of integration is to be reversed. Then the integration must be restarted.

**Notes.**

(1) AERR and RERR can be modified each time that GERK is called.

(2) When continuing an integration, one may switch from the standard multistep mode (INL. 2) to the one step mode (IND © -2) whenever it is convenient to do so.

**Input Errors.** IND ©: 7 occurs when one of the following conditions is violated: thno>

2) 7 4 TOUT when IND 4 1)

3) RERR > 0 and AERR > 9

4) IND . £4,°62,38,4,....7

IND 7 then the error must be corrected and IND) reset to ti for $2 when the prev sors

{ ( cell was a continuation call). Pf this is not done then the run will be terminated by a SEO"


<small>Original source: [View scanned PDF page 426](../scans/page_0426.png)</small>

instruction when GERK is recalled.

Accuracy Considerations. Error control in GERK is almost identical to that in RKF45. One minor difference is that GERK never employs relative error tolerances less than 3-107 1, whereas RKF45 never employs relative error tolerances less than 107 !?.

The only significant difference between GERK and RKI45 is that GERK generates two solutions for the differential equations, whereas RKF45 generates only one. Let y(t) and g(t) denote the solutions generated by GERK at point t. One of these solutions, say y(t), will frequently be identical to the solution computed by RKF45. When going from t to t+ h, the step size A is selected so thai ¥(t + 4) satisfies the local error criterion. After a suitable A is found then GERK takes two steps, each of length h/2, to generate g(t + h) from ¥(t). When GERK terminates, say at point 7’, then the §(T) solution is stored in the Y array and GERK estimates the error of 9,(7) to be (y,{T) — §:(T))/31 for # =1, ...,n.

**Programming.** GERK employs the subroutines «ERKS and FEHL. These routines were written by H. A. Watts and L. F. Shampine (Sandia Laboratories). The function SPMPAR

is also used.

**Reference.** Shampine, L. F., and Allen, R. C., Numerical Computing: An Introduction, W. B. Saunders, Philadelphia, 1973.

Ny a3)


<small>Original source: [View scanned PDF page 427](../scans/page_0427.png)</small>

<a id="topic-427-01"></a>
### Adaptive Solution Of Stiff Differential Equations

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `SFODE` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RERR, AERR, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [`L108719`](../source_parts/nswc_part_11.f90#L2191) |
| `SFODE1` | `SUBROUTINE` | `F, NEQ, Y, T, TOUT, INFO, RTOL, ATOL, IDID, RWORK, LRW, IWORK, LIW, RPAR, IPAR` | [`L108743`](../source_parts/nswc_part_11.f90#L2215) |


Let y’(t) = f(t, y(t)) denote a system of n ordinary first order differential equations where flt,y) = Cit, y). ..-, fn (t, y)) and y(t) = (yi (t), --.,yn(t)). Assume that y(a) is known. Then for 6 # a the following subroutines are available for computing y(b). These routines are designed for stiff differential equations. The algorithm used is a variable order, variable step backward differentiation procedure.

CALL SFODE(£,n, Y,7,/TOUT,INFO,RERR,AERR,IER, WK,é,1WK,m,RD, ID)

RD and ID are arrays defined by the user containing any real and integer data that is needed for computing {. These arrays may contain any information that the user desires. The argument F is the name of a user defined subroutine that has the format:

CALL Fit, Y ,DY,RD,ID) Y and DY are arrays of dimension n. On input Y contains the values yi(t), ..., ya(t) for the argument t. F computes the derivatives y(t), ...,y/(¢) using y/(t) = f(t, y(t)) and stores the results in DY. F must be declared in the calling program to be of type EXTERNAL.

INFO is an array of dimension 4, WK an array of dimension @, and [WK an array of dimension m. WK and IWK are work spaces for the routine, and INFO is an array defined by the user containing information on how the equations are to be treated.

```text
INFO(1): Set INFO(i) = 0 on an initial call to the routine. On a continua-
tion call INFO(i) = 1.
```

INFO/2): Normally INFO(2) = 0. However, INFO(2) = 1 when the intermediate output mode is desired (see below).

INFO(3): When INFO(3) = 0, SFODE proceeds from a to b using the largest stops that are appropriate. If b is passed then y(6) is obtained by interpolation. However, for some problems the routine cannot be permitted to step past a point TSTOP because y(t) = f(t, y(t) is discontinuous or not defined beyond TSTOP. When this is the case set INFO(3) = 1 and WK(1) = TSTOP.

INFO(4): When proceeding from a to 6, the n x n Jacobian matrix J f(t) = (Of; /0y,) is computed and stored in WK. Normally it is assumed that

INFO(4) = 0

2 > 250° 10n+n?

m™> 55-n. However, if J f(¢) is banded for all t, having the lower and upper band widths my, and m, where 2rny +m, <n, then the following setup can be used:

IWK(L) ome

IWK(2) < ony,

€ © 2504 ln b (2re bang! tn

mo Gh obon


<small>Original source: [View scanned PDF page 428](../scans/page_0428.png)</small>

T, TOUT, RERR, and AERR are variables, and the argument Y of SFODE is an

array of dimension n. On an initial call to the routine it is assumed that

INFO(1) = 0

Tae

TOUT =6

Y(1),...,¥(n) contain the values y1(a), ..., yn(a)

RERR =: the relative error tolerance to be satisfied (RERR > 0)

AERR = the absolute error tolerance to be satisfied (AERR > 9).

IER is a variable. When SFODE terminates T is the final point where the equations were solved, Y contains the solution at T, and IER reports the status of the results. IE is assigned one of the following values:

IER = 1 A step was taken in the intermediate output mode. TOUT was not reached. To continue, call the routine again.

IER = 2 The solution at TOUT was obtained by stepping exactly to TOUT.

```text
IER = 3 The solution at TOUT was obtained by stepping past TOUT and
then interpolating. On output T = TOUT.
```

IER = —1 500 steps have been taken. TOUT has not been reached. To continue, call the routine again.

IER = —2 The tolerances RERR and AERR were too stringent. RERR and AERR have been modified by the routine. The tolerances may be further modified by the user if he desires. To continue, call the routine again.

IER = —3 In this case AERR = 0. SFODE stopped when y; became 0. INFO(1) was set to -?. To continue set AERR to be positive, INFO(1) = 1, and call the routine again.

TER == —6 Convergence failed on the last attempted step. An inaccurate Jacobian matrix may be the problem. To continue, restart the routine by setting INFO(1) = 0 and call the routine again.

IER = —7 Repeated error test failures occurred on the last attempted step. The problem should be reexamined. A singularity may be present in the solution. To continue, restart by setting INFO(1) = 0 and call the routine again.

IER < --33 An input error was detected (see below),

When IER > —2, then INFO(J) = 1 on output.

When the equations are solved at TOUT (IER = 2 or 3), integration can be continued along the axis to solve the equations ai a new point c beyond TOUT. To continue, one need only set TOUT to the new value c and call the routine again. When continuing an integration where INFO(1) = 1, never modify 7, Y, WK, IWK, INFO(3), and INFO/4). However, INFO(2), RERR, AERR, RD, and 1D may be modified at any time.

Intermediate Output Mode. Uf one wishes to study the behavior of the solution y(t) as the routine steps from 7 to VOU'T, then sei INFO(2) 2 1. Then SFODE will stop after each successful step (yielding He © 1y ung) TOUT is reached. One may switch from the standard mode of operation (INFO(2) 0) to the intermediate output mode (INFO(2)

1} or vice versa ab any tire


<small>Original source: [View scanned PDF page 429](../scans/page_0429.png)</small>

**Remark.** The diagnostic IER =: --1 does not state that 500 steps have been taken on the current call to SFODE. On an initial call to the routine the step counter is set to 0, On continuation calls, the counter continues to increase until 500 steps have accumulated. When IER = --1 is reported, the counter is reset to 0, and only then does the step counting begin again.

```text
Input Errors. IER is set to one of the following values when an input error is detected.
IER = -33 n< 1
IER = —34 RERR < 0
IER = —35 AERR < 0
TER = -36 The routine has been called with TOUT, but it has also been told
not to step past the point TSTOP.
IiR =: ~87 T = TOUT. This is not permitted on continuation calls.
iER == --38 The user has modified 7.
TER = ~39 TOUT is not beyond 7. An attempt is being made to change the
direction cf integration without restarting.
[ER = ~—40 The Jacobian mztrix is banded. However, mz, and m,, do not
satisfy 0 < my < aandO< m, <n.
IER = --41 £< 250+ 10n +n?
TER = —42 €< 250+ 10n + (2mye+ my, + 1)n
IER = —43 m<'5+a
IER = —44 INFO(1) is incorrect.
After the error is corrected, set INFO(1) = 0 and call the routine again.
```

```text
Error Contrel. Assuming that SFODE has the correct value for y(t}, let e, denote the
error generated in computing y(t +A) for’ = 1, ...,n when SFODE steps from t tot +h.
The routine attempts at each step to maintain the accuracy 13 (e:/wi)? < 1 where w; =
RERR |y,(t)| 4+- AERR. When this criterion is satisfied, le,| < /nw, fort =1,...,n. This
criterion includes as special cases relative error (AERR = 0) and absolute error (RERR =:
0). However, if AERR = 0 and y(t) = 0 for some :, then this criterion cannot be applied
and JER = -3 occurs.
```

When proceeding from T to TOUT, the routin» continually readjusts its order and step size so as to maintain accuracy at each step. However, no attempt is made to control the progressive erosion of accuracy that can occur when the steps accumulate. Since the erosion cf accuracy can be significant, at times one may wish to double-check the results. If the problem is nonstiff or mildly stiff fur an interval, then the best procedure 1s to compare the results obtained by SFODE with those obtained by ODE for the interval. ODE normally maintains greater accuracy than SFODE. However, if the problem is extremely s iff then rerun the problem with SFODE. On the second run, request greater accuracy.

**Programming.** SFODE calls the subroutines STFODE and ZZZJAC. STFODE employs the subroutines LSODt, HSTART, IN'TYD, STOD, CFOD, PIAC, SLVS, SGBFA, SGBSL, SGEPA. SGESL, SAXPY, and SSCAL, and the functions VNORM, VNWRMS, ISAMAX, SPOT, and SPMPAR. The routines save and exchange information in a labeled common block having the block name DEBDF!. STEODE is a modification by A. HE Morris of the

HOG


<small>Original source: [View scanned PDF page 430](../scans/page_0430.png)</small>

subroutine DEBDF, designed by L. F. Shampine and H. A. Watts (Sandia Laboratories). DEBDF appears in the SLATEC library. STFODE is a driver for a modification of the code LSODE, written by A. C. Hindmarsh (Lawrence Livermore Laboratory).

CALL SFODE1(F, n, Y,7,TOUT,INFO,RERR,AERR,IEK, WK, é,1WK,m,RD,ID)

SFODE1 differs from SFODE only in the treatment of RERR and AERR. In SFODE1, RERR and AERR are arrays of dimension n. RERR(t) and AERR(t) are relative and absolute error tolerances to control the accuracy of the #** solution component y,(t) for t= 1,...,n. Let e; denote the error generated in the computation of y,(t +h) from y,({t) when SPODE] steps from t tot-+ h. Then SFODEI attempts at each step to maintain the accuracy +5,(e;/w,)? < 1 where w; = RERR(s)|y,(£)]| + AERR(1), When this criterion is satisfied les! < J/nw, fori = =1,...,n. However, if AERR(t) = 0 and y,(t) = 0 for some ¢, then the criterion cannot be applied and [ER = --3 occurs.

When IER references RERR and AERR, the settings for IER provide the following

information:

IER = -2 The accuracy required by RERR and AERR is too stringent. RERR and AERR have been modified by the routine. RERR and AERR may be further modified by the user if he desires.

To continue, call SFODEI again.

IER = -3 SFODEI stopped when y; became 0 and AERR(i) = 0. INFO(1) was set to —1. To continue set AERR(t) to be positive, INFO(1) = 1, and call the routine again.

IER = --34 (Input error) RERR(t) < 0 for some 1.

IER = —35 (Input error) AERR(t) < 0 for some #.

RERR and AERR may Le modified on any continuation call to SFODEL1.

**Programming.** SFODE1 calls the subroutines STFODE and ZZZJAC.


<small>Original source: [View scanned PDF page 431](../scans/page_0431.png)</small>

<a id="topic-431-01"></a>
### Fourth-Order Runge-Kutta

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RK` | `SUBROUTINE` | `N, T, H, A, F` | [`L111428`](../source_parts/nswc_part_11.f90#L4900) |


Let y’(¢) = f(t,y(t)) denote a system of n ordinary first order nonstiff differential equations where f(t,y) = (fi(t,y),...,fn(t,y)) and y(t) = (yi(t), ...,yn(t)). Assume that y(to) is known. Then for a small real number A, the subroutine RK is available for computing y(to +h). RK employs the standard fourth-order Runge-Kutta procedure.

```fortran
CALL RK(N, T, H, A, F)
```

The argument F is the name of a user defined subroutine that bas the format: CALL F(t, Z) Z is an array of dimension n containing the values y(t), .. .Yn(t) for the :rgument t. F computes the derivatives y}(¢),...,y),(t) using y’(t) = f(t, y(¢)) and stores the results in Z, thereby destroying the original data in Z. F must be declared in the calling program to be of type EXTERNAL.

T is a variable having the value tg and A an array of dimension 3n or larger. It is assumed that A(i),...,A(n) contain the values yi(to), ...,yn(to). If A = 0 then RK computes the derivatives yi(to), -..,y),(to) and stores them in A(n + i), ...,A(2n). If h # 0 then it is assumed that the derivatives yj (to), ..., y/, (ty) have already been computed and stored in A(n + 1),...,A(2n). In this case, when RK is called, the values yi(to + h), ..-,yn(to + h) and derivatives yi(to +A), ... , yi (to +h) are computed and stored in A(1), ...,A(2n). Also T is reset to the value tg +A.

**Note.** The area 4(2n + 1}, ...,A(3n) serves as work space for the routine.

**Example.** Consider the equations

x'(t) = y(t)

y'(t) = —2(t) where z(0) = 0 and y(0) = 1. The following code may be used for solving these equations at the points .01,.02, ...,1.00, and storing the results in the arrays X and Y.

DIMENSION A(6), X(100), Y(100) EXTERNAL FUN

H = Ol

A(1) = 0.0 A(2) - 1.0 A(3) — 1.0 A(4) = 0.0

bO 101 1, 100 CALL RK(2,7T,H,A,FUN) tO YC) A(2)


<small>Original source: [View scanned PDF page 432](../scans/page_0432.png)</small>

Here FUN may be defined by:

SUBROUTINE FUN(T,Z) DIMENSION 2(2)

X = Z(t)

Y = Z(2)

Z(1) = Y

z(2) = -X

RETURN

END

Note that the statements A(3) = 1.0 and A(4) = 0.0, which store the derivatives z/(0) and y'(0) in A(3) and A(4), can be replaced with CALL RK(2,T,0.0,A,FUN).

**Programmer.** A.H. Morris.


<small>Original source: [View scanned PDF page 433](../scans/page_0433.png)</small>

<a id="topic-433-01"></a>
### Eighth-Order Runge-Kutta

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `RK8` | `SUBROUTINE` | `N, T, H, Y, DY, W, F` | [`L111485`](../source_parts/nswc_part_11.f90#L4957) |


Let y(t) = f(t,y(t)) denote a system of n ordinary first. order nonstiff differential

equations where f(t,y) = (fi(t,y),..-,fn(t,y)) and y(t) = (y(t), ...,yn(t)). Assume that y(to) is known. Then for a small real number A, the subroutine RK8 is available for

computing y(to + A). CALL RK8(n,T, h, Y, DY,WK, F)

The argument F is the name of a user defined subroutine that has the format: CALL F(t, Z) Z is an array of dimension n containing the values y;(t),...,yn(t) for the argument t. F computes the derivatives yi (t),...,y;,(t) using y’(t) = f(t, y(¢)) and stores the results in Z, thereby destroying the original data in Z. F must be declared in the calling program to be of type EXTERNAL.

T is a variable having the value tg, and Y and DY are arrays of dimension n. It is assumed that Y contains the values yi(to), ...,tn(to). If h = 0 then RK8 computes the derivatives yi(to), ...,y),(to) and stores them in DY. If kh 0 then it is assumed that the derivatives yi (to), ...,y!,(to) have already been computed and stored in DY. In this case, when RK& is called, the values yi(to + A), ...,yn(to + A) and derivatives yi(to+h),..., Yn (to +h) are computed and stored in ¥Y and DY, thereby destroying the original data in Y and DY. Also T is reset to the value to + A.

WK is an array of dimension 8n or larger that is used for a work space by the routine. Algorithm. The routine employs formulae (8-12) given on p. 34 of the reference.

**Remarks.** RK&8 is used in the same manner as the routine RK. RK8 takes more time and storage than RK, but may be mure accurate.

**Reference.** Shanks, E. B., “Solutions of Differential Equations by Evaluations of Functions,” Math. Comp. 26 (1966), pp. 21-38.

**Programmer.** A. IH. Morris.

