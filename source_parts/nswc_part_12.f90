subroutine extra(neqn,yinc2,f2,t,h,yinc1,y,f1,f,tex,yex,ypex)
implicit none
integer, intent(in) :: neqn
real :: f(neqn), f1(neqn), f2(neqn)
real, intent(in) :: h, t, tex
real :: y(neqn)
real, intent(inout) :: yex(neqn)
real :: yinc1(neqn), yinc2(neqn)
real, intent(inout) :: ypex(neqn)
integer :: n
real :: a1, a2, a3, a4, hf, hf1, hf2, sig
!
!     This version of extra is the third of the three changes
!     needed to make the interpolant derivative more stable.
!
!     t is the independent variable.
!     y is the value at t-2H. the values at t-h and t are
!     y + h*yinc1 and y + h*yinc2 respectively.
!     f,f1 and f2 are the derivatives at t-2H, t-h and t.
!     Tex is the point where the output is required.
!     yex will hold the approximate solution at tex and ypex will
!     hold the derivative approximation at this point.
!
!
!     Perform quintic interpolation based on the values
!     y(n),y(n)+h*yinc1(n),y(n)+h*yinc2(n),f(n),f1(n),f2(n) at the
!     points t-2H, t-h, t.  this polynomial is evaluated at the point
!     tex to obtain the approximate value of y(tex) and this is stored
!     in the array yex.  The derivative of the interpolating polynomial
!     is also evaluated at tex to obtain an approximation to DY/DT
!     at this point and this approximation is stored in ypex.
!
sig = (tex - t)/h + 2.0
do n = 1, neqn
   hf = h*f(n)
   hf1 = h*f1(n)
   hf2 = h*f2(n)
   a1 = 2.0*(hf2 + hf) - 6.0*h*yinc2(n) + 8.0*hf1
   a2 = h*yinc2(n) + 4.0*h*yinc1(n) - 4.0*hf1 - 2.0*hf
   a3 = hf1 + hf - 2.0*h*yinc1(n)
   a4 = h*yinc1(n) - hf
   yex(n) = ((((a1*0.125*(sig - 2.0) + 0.25*a2)*(sig - 1.0) + &
      & a3)*(sig - 1.0) + a4)*sig + hf)*sig + y(n)
   ypex(n) = ((((0.625*a1*sig + (a2 - 2.0*a1))*sig + (1.875*a1 - &
      & 1.5*a2 + 3.0*a3))*sig + (0.5*(a2 - a1) - &
      & 2.0*(a3 - a4)))*sig + hf)/h
end do
return
end subroutine extra

subroutine rkf45(f,neqn,y,t,tout,relerr,abserr,iflag,work,iwork)
implicit none
!
!     Fehlberg fourth-fifth order Runge-Kutta method
!
!     Written by H.A.Watts and L.F.Shampine
!                   Sandia Laboratories
!                  albuquerque,new mexico
!
!    rkf45 is primarily designed to solve non-stiff and mildly stiff
!    differential equations when derivative evaluations are inexpensive.
!    rkf45 should generally not be used when the user is demanding
!    high accuracy.
!
! Abstract
!
!    Subroutine  rkf45  integrates a system of neqn first order
!    ordinary differential equations of the form
!             DY(I)/DT = F(t,y(1),y(2),...,y(neqn))
!              where the y(I) are given at t .
!    Typically the subroutine is used to integrate from t to tout but it
!    can be used as a one-step integrator to advance the solution A
!    single step in the direction of tout.  On return the parameters in
!    the call list are set for continuing the integration. The user has
!    only to call rkf45 again (and perhaps define a new value for tout).
!    Actually, rkf45 is an interfacing routine which calls subroutine
!    rkfs for the solution.  rkfs in turn calls subroutine  fehl which
!    computes an approximate solution over one step.
!
!    rkf45  uses the Runge-Kutta-Fehlberg (4,5)  method described
!    in the reference
!    E.Fehlberg , low-order classical Runge-Kutta formulas with stepsize
!                 control , nasa TR R-315
!
!    The parameters represent-
!      F -- subroutine F(t,y,YP) to evaluate derivatives YP(I)=DY(I)/DT
!      neqn -- number of equations to be integrated
!      y(*) -- solution vector at t
!      t -- independent variable
!      tout -- output point at which solution is desired
!      relerr,abserr -- relative and absolute error tolerances for local
!            error test. At each step the code requires that
!                 abs(LOCAL ERROR) .LE. relerr*abs(y) + abserr
!            for each component of the local error and solution vectors
!      iflag -- indicator for status of integration
!      work(*) -- array to hold information internal to rkf45 which is
!            necessary for subsequent calls. Must be dimensioned
!            at least  3+6*neqn
!      iwork(*) -- integer array used to hold information internal to
!            rkf45 which is necessary for subsequent calls. Must be
!            dimensioned at least  5
!
!  First call to rkf45
!
!    The user must provide storage in his calling program for the arrays
!    IN THE CALL LIST  -      y(neqn) , work(3+6*neqn) , iwork(5)  ,
!    declare F in an external statement, supply subroutine F(t,y,YP) and
!    initialize the following parameters-
!
!      neqn -- number of equations to be integrated.  (neqn .GE. 1)
!      y(*) -- vector of initial conditions
!      t -- starting point of integration , must be a variable
!      tout -- output point at which solution is desired.
!            t=tout is allowed on the first call only, in which case
!            rkf45 returns with iflag=2 If continuation is possible.
!      relerr,abserr -- relative and absolute local error tolerances
!            which must be non-negative. relerr must be a variable while
!            abserr may be a constant. The code should normally not be
!            used with relative error control smaller than about 1.E-8 .
!            To avoid limiting precision difficulties the code requires
!            relerr to be larger than an internally computed relative
!            error parameter which is machine dependent. In particular,
!            pure absolute error is not permitted. If a smaller than
!            allowable value of relerr is attempted, rkf45 increases
!            relerr appropriately and returns control to the user before
!            continuing the integration.
!      iflag -- +1,-1  indicator to initialize the code for each new
!            problem. Normal input is +1. The user should set iflag=-1
!            only when one-step integrator control is essential. In this
!            case, rkf45 attempts to advance the solution a single step
!            in the direction of tout each time it is called. Since this
!            mode of operation results in extra computing overhead, it
!            should be avoided unless needed.
!
!  Output from rkf45
!
!      y(*) -- solution at t
!      t -- last point reached in integration.
!      iflag = 2 -- integration reached tout.
!            =-2 -- A single successful step in the direction of tout
!                   has been taken. Normal mode for continuing
!                   integration one step at a time.
!            = 3 -- Integration was not completed because relative error
!                   tolerance was too small. relerr has been increased
!                   appropriately for continuing.
!            = 4 -- Integration was not completed because more than
!                   3000 derivative evaluations were needed. This
!                   is approximately 500 steps.
!            = 5 -- Integration was not completed because solution
!                   vanished making a pure relative error test
!                   impossible. Must use non-zero abserr to continue.
!                   Using the one-step integration mode for one step
!                   is a good way to proceed.
!            = 6 -- Integration was not completed because requested
!                   accuracy could not be achieved using smallest
!                   allowable stepsize. User must increase the error
!                   tolerance before continued integration can be
!                   attempted.
!            = 7 -- It is likely that rkf45 is inefficient for solving
!                   this problem. Too much output is restricting the
!                   natural stepsize choice. Use the one-step integrator
!                   mode.
!            = 8 -- Invalid input parameters
!                   this indicator occurs if any of the following is
!                   SATISFIED -   neqn .LE. 0
!                                 t=tout  and  iflag .NE. +1 or -1
!                                 relerr OR abserr .LT. 0.
!                                 iflag .EQ. 0  OR  .LT. -2  OR  .GT. 8
!      work(*),iwork(*) -- information which is usually of no interest
!                   to the user but necessary for subsequent calls.
!                   work(1),...,work(neqn) contain the first derivatives
!                   of the solution vector y at t. work(neqn+1) contains
!                   the stepsize H to be attempted on the next step.
!                   iwork(1) contains the derivative evaluation counter.
!
!  Subsequent calls to rkf45
!
!    Subroutine rkf45 returns with all information needed to continue
!    integration. If the integration reached tout, the user need only
!    define a new tout and call rkf45 again. In the one-step integrator
!    mode (iflag=-2) the user must keep in mind that each step taken is
!    in the direction of the current tout. Upon reaching tout (indicated
!    by changing iflag to 2),the user must then define a new tout and
!    reset iflag to -2 To continue in the one-step integrator mode.
!
!    If the integration was not completed but the user still wants to
!    CONTINUE (iflag=3,4 CASES), HE JUST CALLS rkf45 AGAIN. WITH iflag=3
!    the relerr parameter HAS been adjusted appropriately for continuing
!    the integration. In the case of iflag=4 The function counter will
!    be reset to 0 and another 3000 function evaluations are allowed.
!
!    However,in the case iflag=5, the user must first alter the error
!    criterion to use a positive value of abserr before integration can
!    proceed. If he does not,execution is terminated.
!
!    Also,in the case iflag=6, it is necessary for the user to reset
!    iflag to 2 (or -2 When the one-step integration mode is being used)
!    as well as increasing either abserr,relerr or both before the
!    integration can be continued. If this is not done, execution will
!    be terminated. The occurrence of iflag=6 Indicates a trouble spot
!    (solution is changing rapidly,singularity may be present) and it
!    often is inadvisable to continue.
!
!    If iflag=7 Is encountered, the user should use the one-step mode
!    or switch to another routine. If the user insists upon continuing
!    the integration with rkf45, then he must reset iflag to 2 or -2
!    before recalling rkf45. Otherwise, execution will be terminated.
!
!    If iflag=8 Is obtained, integration cannot be continued unless
!    the invalid input parameters are corrected.
!
!    It should be noted that the arrays work,iwork contain information
!    required for subsequent integration. Accordingly, work and iwork
!    should not be altered.
!
integer, intent(in) :: neqn
integer, intent(inout) :: iflag, iwork(5)
real, intent(inout) :: y(neqn), t
real, intent(in) :: tout
real, intent(inout) :: relerr
real, intent(in) :: abserr
real, intent(inout) :: work(*)
external f
integer :: k1, k2, k3, k4, k5, k6, k1m
!
!
!
!     Compute indices for the splitting of the work array
!
k1m = neqn + 1
k1 = k1m + 1
k2 = k1 + neqn
k3 = k2 + neqn
k4 = k3 + neqn
k5 = k4 + neqn
k6 = k5 + neqn
!
!     This interfacing routine merely relieves the user of a long
!     calling list via the splitting apart of two working storage
!     arrays. If this is not compatible with the users compiler,
!     he must use rkfs directly.
!
call rkfs(f,neqn,y,t,tout,relerr,abserr,iflag,work(1),work(k1m), &
   & work(k1),work(k2),work(k3),work(k4),work(k5),work(k6), &
   & work(k6 + 1),iwork(1),iwork(2),iwork(3),iwork(4),iwork(5))
!
return
end subroutine rkf45

subroutine rkfs(f,neqn,y,t,tout,relerr,abserr,iflag,yp,h,f1,f2,f3, &
   & f4,f5,savre,savae,nfe,kop,init,jflag,kflag)
implicit none
!
!
!     rkfs integrates a system of first order ordinary differential
!     equations as described in the comments for rkf45 .
!     The arrays yp,f1,f2,f3,f4,and f5 (of dimension at least neqn) and
!     the variables h,savre,savae,nfe,kop,init,jflag,and kflag are used
!     internally by the code and appear in the call list to eliminate
!     local retention of variables between calls. Accordingly, they
!     should not be altered. Items of possible interest are
!         yp - Derivative of solution vector at t
!         h  - An appropriate stepsize to be used for the next step
!         nfe- counter on the number of derivative function evaluations
!
integer, intent(in) :: neqn
integer, intent(inout) :: iflag, nfe, kop, init, jflag, kflag
real, intent(inout) :: y(neqn), t
real, intent(in) :: tout
real, intent(inout) :: relerr
real, intent(in) :: abserr
real, intent(inout) :: h
real :: yp(neqn)
real, intent(inout) :: f1(neqn)
real :: f2(neqn), f3(neqn), f4(neqn)
real, intent(inout) :: f5(neqn), savre, savae
external f
logical :: hfaild, output
real :: a, ae, dt, ee, eeoet, esttol, et, hmin, rer, s, scale, tol, toln, u26, eps, ypk
integer :: k, mflag
real, parameter :: remin = 1.e-12
integer, parameter :: maxnfe = 3000
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
!
!
!
!
!     remin is the minimum acceptable value of relerr.  Attempts
!     to obtain higher accuracy with this subroutine are usually
!     very expensive and often unsuccessful.
!
!
!     The expense is controlled by restricting the number
!     of function evaluations to be approximately maxnfe.
!     As set, this corresponds to about 500 steps.
!
!
!     Check input parameters
!
if (neqn < 1) go to 10
if (relerr < 0.0 .or. abserr < 0.0) go to 10
mflag = abs(iflag)
if (mflag == 0 .or. mflag > 8) go to 10
!
!     Compute the relative machine precision
!
eps = spmpar(1)
u26 = 26.0*eps
if (mflag /= 1) go to 20
go to 50
!
!     Invalid input
!
10 iflag = 8
return
!
!     Check continuation possibilities
!
20 if (t == tout .and. kflag /= 3) go to 10
if (mflag /= 2) go to 25
!
!     iflag = +2 or -2
!
if (kflag == 3) go to 45
if (init == 0) go to 45
if (kflag == 4) go to 40
if ((kflag == 5)  .and.  (abserr == 0.0)) go to 30
if ((kflag == 6)  .and.  (relerr <= savre)  .and. &
   & (abserr <= savae)) go to 30
go to 50
!
!     iflag = 3,4,5,6,7 or 8
!
25 if (iflag == 3) go to 45
if (iflag == 4) go to 40
if (iflag == 5 .and. abserr > 0.0) go to 45
!
!     Integration cannot be continued since user did not respond to
!     the instructions pertaining to iflag=5,6,7 or 8
!
30 stop
!
!     Reset function evaluation counter
!
40 nfe = 0
if (mflag == 2) go to 50
!
!     Reset flag VALUE from previous call
!
45 iflag = jflag
if (kflag == 3) mflag = abs(iflag)
!
!     Save input iflag and set continuation flag VALUE for subsequent
!     input checking
!
50 jflag = iflag
kflag = 0
!
!     Save relerr and abserr for checking input on subsequent calls
!
savre = relerr
savae = abserr
!
!     Restrict relative error tolerance to be at least as large as
!     2*eps+remin to avoid limiting precision difficulties arising
!     from impossible accuracy requests
!
rer = 2.0*eps + remin
if (relerr >= rer) go to 55
!
!     Relative error tolerance too small
!
relerr = rer
iflag = 3
kflag = 3
return
!
55 dt = tout - t
!
if (mflag == 1) go to 60
if (init == 0) go to 65
go to 80
!
!     Initialization --
!                       set initialization completion indicator,init
!                       set indicator for too many output points,kop
!                       evaluate initial derivatives
!                       set counter for function evaluations,nfe
!                       estimate starting stepsize
!
60 init = 0
kop = 0
!
a = t
call f(a,y,yp)
nfe = 1
if (t /= tout) go to 65
iflag = 2
return
!
65 init = 1
h = abs(dt)
toln = 0.0
do 70 k = 1,neqn
   tol = relerr*abs(y(k)) + abserr
   if (tol <= 0.) go to 70
   toln = tol
   ypk = abs(yp(k))
   if (ypk*h**5 > tol) h = (tol/ypk)**0.2
70 continue
if (toln <= 0.0) h = 0.0
h = max(h,u26*max(abs(t),abs(dt)))
jflag = sign(2,iflag)
!
!     Set stepsize for integration in the direction from t to tout
!
80 h = sign(h,dt)
!
!     Test to see if rkf45 is being severely impacted by too many
!     output points
!
if (abs(h) >= 2.0*abs(dt)) kop = kop + 1
if (kop /= 100) go to 85
!
!     Unnecessary frequency of output
kop = 0
iflag = 7
return
!
85 if (abs(dt) > u26*abs(t)) go to 95
!
!     If too close to output point,extrapolate and return
!
do 90 k = 1,neqn
90 y(k) = y(k) + dt*yp(k)
a = tout
call f(a,y,yp)
nfe = nfe + 1
go to 300
!
!
!     Initialize output point indicator
!
95 output = .false.
!
!     To avoid premature underflow in the error tolerance function,
!     scale the error tolerances
!
scale = 2.0/relerr
ae = scale*abserr
!
!     Step by step integration
!
100 hfaild = .false.
!
!     Set smallest allowable stepsize
!
hmin = u26*abs(t)
!
!     Adjust stepsize if necessary to hit the output point.
!     Look ahead two steps to avoid drastic changes in the stepsize and
!     thus lessen the impact of output points on the code.
!
dt = tout - t
if (abs(dt) >= 2.0*abs(h)) go to 200
if (abs(dt) > abs(h)) go to 150
!
!     The next successful step will complete the integration to the
!     output point
!
output = .true.
h = dt
go to 200
!
150 h = 0.5*dt
!
!
!     Core integrator for taking a single step
!
!     The tolerances have been scaled to avoid premature underflow in
!     computing the error tolerance function et.
!     To avoid problems with zero crossings,relative error is measured
!     using the average of the magnitudes of the solution at the
!     beginning and end of a step.
!     The error estimate formula has been grouped to control loss of
!     significance.
!     To distinguish the various arguments, h is not permitted
!     to become smaller than 26 units of roundoff in t.
!     Practical limits on the change in the stepsize are enforced to
!     smooth the stepsize selection process and to avoid excessive
!     chattering on problems having discontinuities.
!     To prevent unnecessary failures, the code uses 9/10 the stepsize
!     it estimates will succeed.
!     After a step failure, the stepsize is not allowed to increase for
!     the next attempted step. This makes the code more efficient on
!     problems having discontinuities and more effective in general
!     since local extrapolation is being used and extra caution seems
!     warranted.
!
!     Test number of derivative function evaluations.
!     If okay,try to advance the integration from t to t+h
!
200 if (nfe <= maxnfe) go to 220
!
!     Too much work
!
iflag = 4
kflag = 4
return
!
!     Advance an approximate solution over one step of length h
!
220 call fehl(f,neqn,y,t,h,yp,f1,f2,f3,f4,f5,f1)
nfe = nfe + 5
!
!     Compute and test allowable tolerances versus local error estimates
!     and remove scaling of tolerances. Note that relative error is
!     measured with respect to the average of the magnitudes of the
!     solution at the beginning and end of the step.
!
eeoet = 0.0
do 250 k = 1,neqn
   et = abs(y(k)) + abs(f1(k)) + ae
   if (et > 0.0) go to 240
!
!        Inappropriate error tolerance
!
   iflag = 5
   return
!
240 ee = abs((-2090.0*yp(k) + (21970.0*f3(k) - 15048.0*f4(k))) + &
      & (22528.0*f2(k) - 27360.0*f5(k)))
250 eeoet = max(eeoet,ee/et)
!
esttol = abs(h)*eeoet*scale/752400.0
if (esttol <= 1.0) go to 260
!
!     Unsuccessful step
!                       reduce the stepsize , try again
!                       the decrease is limited to a factor of 1/10
!
hfaild = .true.
output = .false.
s = 0.1
if (esttol < 59049.0) s = 0.9/esttol**0.2
h = s*h
if (abs(h) > hmin) go to 200
!
!     Requested error unattainable at smallest allowable stepsize
!
iflag = 6
kflag = 6
return
!
!     Successful step
!                        store solution at t+h
!                        and evaluate derivatives there
!
260 t = t + h
do 270 k = 1,neqn
270 y(k) = f1(k)
a = t
call f(a,y,yp)
nfe = nfe + 1
!
!                       Choose next stepsize
!                       the increase is limited to a factor of 5
!                       if step failure has just occurred, next
!                          stepsize is not allowed to increase
!
s = 5.0
if (esttol > 1.889568e-4) s = 0.9/esttol**0.2
if (hfaild) s = min(s,1.0)
h = sign(max(s*abs(h),hmin),h)
!
!     END OF CORE INTEGRATOR
!
!
!     Should we take another step
!
if (output) go to 300
if (iflag > 0) go to 100
!
!     Integration successfully completed
!
!     One-step mode
!
iflag = -2
return
!
!     Interval mode
!
300 t = tout
iflag = 2
return
end subroutine rkfs

subroutine fehl(f,neqn,y,t,h,yp,f1,f2,f3,f4,f5,s)
implicit none
!
!     Fehlberg fourth-fifth order Runge-Kutta method
!
!    fehl integrates a system of neqn first order
!    ordinary differential equations of the form
!             DY(I)/DT=F(t,y(1),---,y(neqn))
!    where the initial values y(I) and the initial derivatives
!    yp(I) are specified at the starting point t. fehl advances
!    the solution over the fixed step h and returns
!    the fifth order (sixth order accurate locally) solution
!    approximation at t+h in array s(I).
!    f1,---,f5 are arrays of dimension neqn which are needed
!    for internal storage.
!    The formulas have been grouped to control loss of significance.
!    fehl should be called with an h not smaller than 13 units of
!    roundoff in t so that the various independent arguments can be
!    distinguished.
!
!
integer, intent(in) :: neqn
real, intent(in) :: y(neqn)
real :: t, h
real, intent(in) :: yp(neqn)
real, intent(inout) :: f1(neqn)
real :: f2(neqn), f3(neqn), f4(neqn)
real, intent(inout) :: f5(neqn), s(neqn)
external f
real :: ch
integer :: k
!
!
ch = h/4.0
do 221 k = 1,neqn
221 f5(k) = y(k) + ch*yp(k)
call f(t + ch,f5,f1)
!
ch = 3.0*h/32.0
do 222 k = 1,neqn
222 f5(k) = y(k) + ch*(yp(k) + 3.0*f1(k))
call f(t + 3.0*h/8.0,f5,f2)
!
ch = h/2197.0
do 223 k = 1,neqn
223 f5(k) = y(k) + ch*(1932.0*yp(k) + (7296.0*f2(k) - 7200.0*f1(k)))
call f(t + 12.0*h/13.0,f5,f3)
!
ch = h/4104.0
do 224 k = 1,neqn
224 f5(k) = y(k) + ch*((8341.0*yp(k) - 845.0*f3(k)) + &
      & (29440.0*f2(k) - 32832.0*f1(k)))
call f(t + h,f5,f4)
!
ch = h/20520.0
do 225 k = 1,neqn
225 f1(k) = y(k) + ch*((-6080.0*yp(k) + (9295.0*f3(k) - &
      & 5643.0*f4(k))) + (41040.0*f1(k) - 28352.0*f2(k)))
call f(t + h/2.0,f1,f5)
!
!     Compute approximate solution at t+h
!
ch = h/7618050.0
do 230 k = 1,neqn
230 s(k) = y(k) + ch*((902880.0*yp(k) + (3855735.0*f3(k) - &
      & 1371249.0*f4(k))) + (3953664.0*f2(k) + &
      & 277020.0*f5(k)))
!
return
end subroutine fehl

subroutine gerk(f,neqn,y,t,tout,relerr,abserr,iflag,gerror, &
   & work,iwork)
implicit none
integer, intent(inout) :: iflag, iwork(5)
integer, intent(in) :: neqn
real, intent(in) :: abserr
real, intent(inout) :: gerror(neqn)
real, intent(in) :: relerr
real, intent(inout) :: t
real, intent(in) :: tout
real, intent(inout) :: work(*), y(neqn)
external f
integer :: k1, k1m, k2, k3, k4, k5, k6, k7, k8
!
!     Fehlberg fourth(fifth) order Runge-Kutta method with
!     global error assessment
!
!     Written by H.A.Watts and L.F.Shampine
!                   Sandia Laboratories
!
!    gerk is designed to solve systems of differential equations when
!    it is important to have a readily available global error estimate.
!    Parallel integration is performed to yield two solutions on
!    different mesh spacings and global extrapolation is applied to
!    provide an estimate of the global error in the more accurate
!    solution.
!
!***********************************************************************
! Abstract
!***********************************************************************
!
!    Subroutine  gerk  integrates a system of neqn first order
!    ordinary differential equations of the form
!             DY(I)/DT = F(t,y(1),y(2),...,y(neqn))
!              where the y(I) are given at t .
!    Typically the subroutine is used to integrate from t to tout but it
!    can be used as a one-step integrator to advance the solution A
!    single step in the direction of tout. On return,an estimate of the
!    global error in the solution at t is provided and the parameters in
!    the call list are set for continuing the integration. The user has
!    only to call gerk again (and perhaps define a new value for tout).
!    Actually, gerk  is merely an interfacing routine which allocates
!    virtual storage in the arrays work,iwork and calls subroutine gerks
!    for the solution.  gerks  in turn calls subroutine  fehl  which
!    computes an approximate solution over one step.
!
!    gerk  uses the Runge-Kutta-Fehlberg (4,5)  method described
!    in the reference
!    E.Fehlberg , low-order classical Runge-Kutta formulas with stepsize
!                 control , nasa TR R-315
!
!
!    The parameters represent-
!      F -- subroutine F(t,y,YP) to evaluate derivatives YP(I)=DY(I)/DT
!      neqn -- number of equations to be integrated
!      y(*) -- solution vector at t
!      t -- independent variable
!      tout -- output point at which solution is desired
!      relerr,abserr -- relative and absolute error tolerances for local
!            error test. At each step the code requires that
!                 abs(LOCAL ERROR) .LE. relerr*abs(y) + abserr
!            for each component of the local error and solution vectors
!      iflag -- indicator for status of integration
!      gerror(*) -- vector which estimates the global error at t. that
!                   is, gerror(I) approximates  y(I)-true solution(I).
!      work(*) -- array to hold information internal to gerk which is
!            necessary for subsequent calls. Must be dimensioned
!            at least  3+8*neqn.
!      iwork(*) -- integer array used to hold information internal to
!            gerk which is necessary for subsequent calls. Must be
!            dimensioned at least  5.
!
!
!***********************************************************************
!  First call to gerk
!***********************************************************************
!
!    The user must provide storage in his calling program for the arrays
!    IN THE CALL LIST  -      y(neqn) , work(3+8*neqn) , iwork(5)  ,
!    declare F in an external statement, supply subroutine F(t,y,YP) and
!    initialize the following parameters-
!
!      neqn -- number of equations to be integrated.  (neqn .GE. 1)
!      y(*) -- vector of initial conditions
!      t -- starting point of integration , must be a variable
!      tout -- output point at which solution is desired.
!            t=tout is allowed on the first call only,in which case gerk
!            returns with iflag=2 If continuation is possible.
!      relerr,abserr -- relative and absolute local error tolerances
!            which must be non-negative but may be constants. We can
!            usually expect the global errors to be somewhat smaller
!            than the requested local error tolerances. To avoid
!            limiting precision difficulties the code always uses the
!            larger of relerr and an internal relative error parameter
!            which is machine dependent.
!      iflag -- +1,-1  indicator to initialize the code for each new
!            problem. Normal input is +1. The user should set iflag=-1
!            only when one-step integrator control is essential. In this
!            case, gerk attempts to advance the solution a single step
!            in the direction of tout each time it is called. Since this
!            mode of operation results in extra computing overhead, it
!            should be avoided unless needed.
!
!
!***********************************************************************
!  Output from gerk
!***********************************************************************
!
!      y(*) -- solution at t
!      t -- last point reached in integration.
!      iflag = 2 -- integration reached tout.Indicates successful return
!                   and is the normal mode for continuing integration.
!            =-2 -- A single successful step in the direction of tout
!                   has been taken. Normal mode for continuing
!                   integration one step at a time.
!            = 3 -- Integration was not completed because more than
!                   9000 derivative evaluations were needed. This
!                   is approximately 500 steps.
!            = 4 -- Integration was not completed because solution
!                   vanished making a pure relative error test
!                   impossible. Must use non-zero abserr to continue.
!                   Using the one-step integration mode for one step
!                   is a good way to proceed.
!            = 5 -- Integration was not completed because requested
!                   accuracy could not be achieved using smallest
!                   allowable stepsize. User must increase the error
!                   tolerance before continued integration can be
!                   attempted.
!            = 6 -- gerk is being used inefficiently in solving
!                   this problem. Too much output is restricting the
!                   natural stepsize choice. Use the one-step
!                   integrator mode.
!            = 7 -- Invalid input parameters
!                   this indicator occurs if any of the following is
!                   SATISFIED -   neqn .LE. 0
!                                 t=tout  and  iflag .NE. +1 or -1
!                                 relerr OR abserr .LT. 0.
!                                 iflag .EQ. 0  OR  .LT. -2  OR  .GT. 7
!      gerror(*) -- estimate of the global error in the solution at t
!      work(*),iwork(*) -- information which is usually of no interest
!                   to the user but necessary for subsequent calls.
!                   work(1),...,work(neqn) contain the first derivatives
!                   of the solution vector y at t. work(neqn+1) contains
!                   the stepsize H to be attempted on the next step.
!                   iwork(1) contains the derivative evaluation counter.
!
!
!***********************************************************************
!  Subsequent calls to gerk
!***********************************************************************
!
!    Subroutine gerk returns with all information needed to continue the
!    integration. If the integration reached tout,the user need only
!    define a new tout and call gerk again. In the one-step integrator
!    mode (iflag=-2) the user must keep in mind that each step taken is
!    in the direction of the current tout. Upon reaching tout (indicated
!    by changing iflag to 2),the user must then define a new tout and
!    reset iflag to -2 To continue in the one-step integrator mode.
!
!    If the integration was not completed but the user still wants to
!    CONTINUE (iflag=3 CASE), HE JUST CALLS gerk AGAIN. THE FUNCTION
!    counter is then reset to 0 and another 9000 function evaluations
!    are allowed.
!
!    However,in the case iflag=4, the user must first alter the error
!    criterion to use a positive value of abserr before integration can
!    proceed. If he does not,execution is terminated.
!
!    Also,in the case iflag=5, it is necessary for the user to reset
!    iflag to 2 (or -2 When the one-step integration mode is being used)
!    as well as increasing either abserr,relerr or both before the
!    integration can be continued. If this is not done, execution will
!    be terminated. The occurrence of iflag=5 Indicates a trouble spot
!    (solution is changing rapidly,singularity may be present) and it
!    often is inadvisable to continue.
!
!    If iflag=6 Is encountered, the user should use the one-step
!    integration mode with the stepsize determined by the code. If the
!    user insists upon continuing the integration with gerk in the
!    interval mode, he must reset iflag to 2 before calling gerk again.
!    Otherwise,execution will be terminated.
!
!    If iflag=7 Is obtained, integration can not be continued unless
!    the invalid input parameters are corrected.
!
!    It should be noted that the arrays work,iwork contain information
!    required for subsequent integration. Accordingly, work and iwork
!    should not be altered.
!
!***********************************************************************
!
!
!
!
!     Compute indices for the splitting of the work array
!
k1m = neqn + 1
k1 = k1m + 1
k2 = k1 + neqn
k3 = k2 + neqn
k4 = k3 + neqn
k5 = k4 + neqn
k6 = k5 + neqn
k7 = k6 + neqn
k8 = k7 + neqn
!
!***********************************************************************
!     This interfacing routine merely relieves the user of a long
!     calling list via the splitting apart of two working storage
!     arrays. If this is not compatible with the users compiler,
!     he must use gerks directly.
!***********************************************************************
!
call gerks(f,neqn,y,t,tout,relerr,abserr,iflag,gerror, &
   & work(1),work(k1m),work(k1),work(k2),work(k3),work(k4), &
   & work(k5),work(k6),work(k7),work(k8),work(k8 + 1), &
   & iwork(1),iwork(2),iwork(3),iwork(4),iwork(5))
!
return
end subroutine gerk

subroutine gerks(f,neqn,y,t,tout,relerr,abserr,iflag,gerror, &
   & yp,h,f1,f2,f3,f4,f5,yg,ygp,savre,savae, &
   & nfe,kop,init,jflag,kflag)
implicit none
integer, intent(inout) :: iflag, init, jflag, kflag, kop
integer, intent(in) :: neqn
integer, intent(inout) :: nfe
real, intent(in) :: abserr
real, intent(inout) :: f1(neqn)
real :: f2(neqn), f3(neqn), f4(neqn)
real, intent(inout) :: f5(neqn), gerror(neqn), h
real, intent(in) :: relerr
real, intent(inout) :: savae, savre, t
real, intent(in) :: tout
real, intent(inout) :: y(neqn), yg(neqn), ygp(neqn)
real :: yp(neqn)
external f
integer :: k, maxnfe, mflag
real :: a, ae, dt, ee, eeoet, esttol, et, hh, hmin, remin, rer, s, &
   & scale, tol, toln, ts, u, u26, ypk
logical :: hfaild, output
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
!     Fehlberg fourth(fifth) order Runge-Kutta method with
!     global error assessment
!
!***********************************************************************
!
!     gerks integrates a system of first order ordinary differential
!     equations as described in the comments for gerk.  The arrays
!     yp,f1,f2,f3,f4,f5,yg and ygp (of dimension at least neqn) and
!     the variables h,savre,savae,nfe,kop,init,jflag,and kflag are used
!     internally by the code and appear in the call list to eliminate
!     local retention of variables between calls. Accordingly, they
!     should not be altered. Items of possible interest are
!         yp - Derivative of solution vector at t
!         h  - An appropriate stepsize to be used for the next step
!         nfe- counter on the number of derivative function evaluations
!
!***********************************************************************
!
!
!
!
!***********************************************************************
!  The computer unit roundoff error U is the smallest positive value
!  representable in the machine such that  1.+ U .GT. 1.
!
u = spmpar(1)
!
!***********************************************************************
!
!  remin is a tolerance threshold which is also determined by the
!  integration method. In particular, a fifth order method will
!  generally not be capable of delivering accuracies near limiting
!  precision on computers with long wordlengths.
!
remin = 3.e-11
!
!***********************************************************************
!
!     The expense is controlled by restricting the number
!     of function evaluations to be approximately maxnfe.
!     As set,this corresponds to about 500 steps.
!
maxnfe = 9000
!
!***********************************************************************
!
!
!     Check input parameters
!
!
if (neqn < 1) go to 10
if ((relerr < 0.)  .or.  (abserr < 0.)) go to 10
mflag = abs(iflag)
if ((mflag >= 1)  .and.  (mflag <= 7)) go to 20
!
!     Invalid input
10 iflag = 7
return
!
!     Is this the first call
20 if (mflag == 1) go to 50
!
!     Check continuation possibilities
!
if (t == tout) go to 10
if (mflag /= 2) go to 25
!
!     iflag = +2 or -2
if (init == 0) go to 45
if (kflag == 3) go to 40
if ((kflag == 4)  .and.  (abserr == 0.)) go to 30
if ((kflag == 5)  .and.  (relerr <= savre)  .and. &
   & (abserr <= savae)) go to 30
go to 50
!
!     iflag = 3,4,5,6, or 7
25 if (iflag == 3) go to 40
if ((iflag == 4) .and. (abserr > 0.)) go to 45
!
!     Integration cannot be continued since user did not respond to
!     the instructions pertaining to iflag=4,5,6 or 7
30 stop
!
!***********************************************************************
!
!     Reset function evaluation counter
40 nfe = 0
if (mflag == 2) go to 50
!
!     Reset flag VALUE from previous call
45 iflag = jflag
!
!     Save input iflag and set continuation flag VALUE for subsequent
!     input checking
50 jflag = iflag
kflag = 0
!
!     Save relerr and abserr for checking input on subsequent calls
savre = relerr
savae = abserr
!
!     Restrict relative error tolerance to be at least as large as
!     32U+remin to avoid limiting precision difficulties arising from
!     impossible accuracy requests
!
rer = max(relerr,32.*u + remin)
!
u26 = 26.*u
!
dt = tout - t
!
if (mflag == 1) go to 60
if (init == 0) go to 65
go to 80
!
!
!***********************************************************************
!
!     Initialization --
!                       set initialization completion indicator,init
!                       set indicator for too many output points,kop
!                       evaluate initial derivatives
!                       copy initial values and derivatives for the
!                             parallel solution
!                       set counter for function evaluations,nfe
!                       estimate starting stepsize
!
60 init = 0
kop = 0
!
a = t
call f(a,y,yp)
nfe = 1
if (t /= tout) go to 65
iflag = 2
return
!
!
65 init = 1
h = abs(dt)
toln = 0.
do 70 k = 1,neqn
   yg(k) = y(k)
   ygp(k) = yp(k)
   tol = rer*abs(y(k)) + abserr
   if (tol <= 0.) go to 70
   toln = tol
   ypk = abs(yp(k))
   if (ypk*h**5 > tol) h = (tol/ypk)**0.2
70 continue
if (toln <= 0.) h = 0.
h = max(h,u26*max(abs(t),abs(dt)))
!
!
!***********************************************************************
!
!     Set stepsize for integration in the direction from t to tout
!
80 h = sign(h,dt)
!
!     Test to see if gerk is being severely impacted by too many
!     output points
!
if (abs(h) > 2.*abs(dt)) kop = kop + 1
if (kop /= 100) go to 85
kop = 0
iflag = 6
return
!
85 if (abs(dt) > u26*abs(t)) go to 95
!
!     If too close to output point,extrapolate and return
!
do 90 k = 1,neqn
   yg(k) = yg(k) + dt*ygp(k)
90 y(k) = y(k) + dt*yp(k)
a = tout
call f(a,yg,ygp)
call f(a,y,yp)
nfe = nfe + 2
go to 300
!
!     Initialize output point indicator
!
95 output = .false.
!
!     To avoid premature underflow in the error tolerance function,
!     scale the error tolerances
!
scale = 2./rer
ae = scale*abserr
!
!
!***********************************************************************
!***********************************************************************
!     Step by step integration
!
100 hfaild = .false.
!
!     Set smallest allowable stepsize
!
hmin = u26*abs(t)
!
!     Adjust stepsize if necessary to hit the output point.
!     Look ahead two steps to avoid drastic changes in the stepsize
!     and thus lessen the impact of output points on the code.
!
dt = tout - t
if (abs(dt) >= 2.*abs(h)) go to 200
if (abs(dt) > abs(h)) go to 150
!
!     The next successful step will complete the integration to the
!     output point
!
output = .true.
h = dt
go to 200
!
150 h = 0.5*dt
!
!
!
!***********************************************************************
!     Core integrator for taking a single step
!***********************************************************************
!     The tolerances have been scaled to avoid premature underflow in
!     computing the error tolerance function et.
!     To avoid problems with zero crossings,relative error is measured
!     using the average of the magnitudes of the solution at the
!     beginning and end of a step.
!     The error estimate formula has been grouped to control loss of
!     significance.
!     To distinguish the various arguments, h is not permitted
!     to become smaller than 26 units of roundoff in t.
!     Practical limits on the change in the stepsize are enforced to
!     smooth the stepsize selection process and to avoid excessive
!     chattering on problems having discontinuities.
!     To prevent unnecessary failures, the code uses 9/10 the stepsize
!     it estimates will succeed.
!     After a step failure, the stepsize is not allowed to increase for
!     the next attempted step. This makes the code more efficient on
!     problems having discontinuities and more effective in general
!     since local extrapolation is being used and the error estimate
!     may be unreliable or unacceptable when a step fails.
!***********************************************************************
!
!
!     Test number of derivative function evaluations.
!     If okay,try to advance the integration from t to t+h
!
200 if (nfe <= maxnfe) go to 220
!
!     Too much work
iflag = 3
kflag = 3
return
!
!     Advance an approximate solution over one step of length h
!
220 call fehl(f,neqn,yg,t,h,ygp,f1,f2,f3,f4,f5,f1)
nfe = nfe + 5
!
!     Compute and test allowable tolerances versus local error estimates
!     and remove scaling of tolerances. Note that relative error is
!     measured with respect to the average of the magnitudes of the
!     solution at the beginning and end of the step.
!
eeoet = 0.
do 250 k = 1,neqn
   et = abs(yg(k)) + abs(f1(k)) + ae
   if (et > 0.) go to 240
!
!       Inappropriate error tolerance
   iflag = 4
   kflag = 4
   return
!
240 ee = abs((-2090.*ygp(k) + (21970.*f3(k) - 15048.*f4(k))) + &
      & (22528.*f2(k) - 27360.*f5(k)))
250 eeoet = max(eeoet,ee/et)
!
esttol = abs(h)*eeoet*scale/752400.
!
if (esttol <= 1.) go to 260
!
!
!     Unsuccessful step
!                       reduce the stepsize , try again
!                       the decrease is limited to a factor of 1/10
!
hfaild = .true.
output = .false.
s = 0.1
if (esttol < 59049.) s = 0.9/esttol**0.2
h = s*h
if (abs(h) > hmin) go to 200
!
!     Requested error unattainable at smallest allowable stepsize
iflag = 5
kflag = 5
return
!
!
!     Successful step
!                        store one-step solution yg at t+h
!                        and evaluate derivatives there
!
260 ts = t
t = t + h
do 270 k = 1,neqn
270 yg(k) = f1(k)
a = t
call f(a,yg,ygp)
nfe = nfe + 1
!
!                        Now advance the y solution over two steps of
!                        length h/2 and evaluate derivatives there
!
hh = 0.5*h
call fehl(f,neqn,y,ts,hh,yp,f1,f2,f3,f4,f5,y)
ts = ts + hh
a = ts
call f(a,y,yp)
call fehl(f,neqn,y,ts,hh,yp,f1,f2,f3,f4,f5,y)
a = t
call f(a,y,yp)
nfe = nfe + 12
!
!
!                       Choose next stepsize
!                       the increase is limited to a factor of 5
!                       if step failure has just occurred, next
!                          stepsize is not allowed to increase
!
s = 5.
if (esttol > 1.889568e-4) s = 0.9/esttol**0.2
if (hfaild) s = min(s,1.)
h = sign(max(s*abs(h),hmin),h)
!
!***********************************************************************
!     END OF CORE INTEGRATOR
!***********************************************************************
!
!
!
!     Should we take another step
!
if (output) go to 300
if (iflag > 0) go to 100
!
!***********************************************************************
!***********************************************************************
!
!
!     Integration successfully completed
!
!     One-step mode
iflag = -2
go to 400
!
!     Interval mode
300 t = tout
iflag = 2
!
400 do 450 k = 1,neqn
450 gerror(k) = (yg(k) - y(k))/31.
!
return
end subroutine gerks

subroutine sfode(f,neq,y,t,tout,info,rerr,aerr,idid, &
   & rwork,lrw,iwork,liw,rpar,ipar)
implicit none
integer, intent(inout) :: idid
integer :: liw, lrw, neq
real, intent(inout) :: aerr, rerr, t
real :: tout
external f
real, intent(inout) :: y(neq)
real, intent(inout) :: rwork(lrw)
real :: rpar(*)
integer, intent(inout) :: info(*)
integer, intent(inout) :: iwork(liw)
integer :: ipar(*)
external zzzjac
real :: rtol(1), atol(1)
integer :: info1(15)
!     --------------
!     --------------
info1(1) = info(1)
info1(2) = 0
info1(3) = info(2)
info1(4) = info(3)
info1(5) = 0
info1(6) = info(4)
!
rtol(1) = rerr
atol(1) = aerr
call stfode(f,neq,y,t,tout,info1,rtol,atol,idid, &
   & rwork,lrw,iwork,liw,rpar,ipar,zzzjac)
info(1) = info1(1)
rerr = rtol(1)
aerr = atol(1)
return
end subroutine sfode

subroutine sfode1(f,neq,y,t,tout,info,rtol,atol,idid, &
   & rwork,lrw,iwork,liw,rpar,ipar)
implicit none
integer, intent(inout) :: idid
integer :: liw, lrw, neq
real, intent(inout) :: t
real :: tout
external f
real, intent(inout) :: y(neq), rtol(neq), atol(neq), rwork(lrw)
real :: rpar(*)
integer, intent(inout) :: info(*)
integer, intent(inout) :: iwork(liw)
integer :: ipar(*)
external zzzjac
integer :: info1(15)
!     --------------
!     --------------
info1(1) = info(1)
info1(2) = 1
info1(3) = info(2)
info1(4) = info(3)
info1(5) = 0
info1(6) = info(4)
!
call stfode(f,neq,y,t,tout,info1,rtol,atol,idid, &
   & rwork,lrw,iwork,liw,rpar,ipar,zzzjac)
info(1) = info1(1)
return
end subroutine sfode1

subroutine zzzjac(t,y,pd,n,rpar,ipar)
implicit none
integer :: ipar(*)
integer, intent(in) :: n
real :: pd(n,*), rpar(*)
real, intent(out) :: t
real :: y(n)
!     -------------
!     Dummy Jacobian subroutine
!     -------------
!     -------------
t = 0.0
return
end subroutine zzzjac

subroutine stfode(f,neq,y,t,tout,info,rtol,atol,idid, &
   & rwork,lrw,iwork,liw,rpar,ipar,jac)
implicit none
integer :: idid, info( *), ipar(*), iwork, liw, lrw, neq
real :: atol(*), rpar(*), rtol(*), rwork(lrw), t, tout, y(neq)
external f, jac
integer :: icomi, icomr, idelsn, iinout, ilrw, itstar, iypout, ml, &
   & mu
integer :: iacor, iband, ibegin, ier, iewt, iinteg, ijac, init, &
   & iowns, iquit, isavf, itol, itstop, iwm, iyh, jstart, kflag, &
   & ksteps, l, maxord, meth, miter, n, nfe, nje, nq, nqu, nst
real :: el0, h, hmin, hmxi, hu, rowns, tn, told, uround
logical :: intout
!***********************************************************************
!***PURPOSE
!   stfode solves initial value problems in ordinary differential
!   equations using backward differentiation formulas. It is
!   both variable order (1-5) and variable step.
!***DESCRIPTION
!
!   This is a modification by A. H. Morris (NSWC) of the code
!   DEBDF, designed by  L. F. Shampine and H. A. Watts (1980).
!   DEBDF is documented in
!        SAND79-2374 , DEPAC - Design of a user oriented package
!                              of ODE solvers.
!
!   stfode is a driver for a modification of the code lsode written by
!             A. C. Hindmarsh
!             Lawrence Livermore Laboratory
!             livermore, california 94550
!
!***********************************************************************
!** ABSTRACT **
!**************
!
!   Subroutine stfode uses the backward differentiation formulas of
!   orders one through five to integrate a system of neq first order
!   ordinary differential equations of the form
!                         DU/DX = F(X,U)
!   when the vector y(*) of initial values for U(*) at X=t is given.
!   The subroutine integrates from t to tout. It is easy to continue the
!   integration to get results at additional tout. This is the interval
!   mode of operation. It is also easy for the routine to return with
!   the solution at each intermediate step on the way to tout. This is
!   the intermediate-output mode of operation.
!
!   stfode uses subprograms lsod1, intyd, stod, cfod, pjac, slvs,vnwrms,
!   hstart, vnorm, svco, rsco, spmpar, and the LINPACK routines sgefa,
!   sgesl, sgbfa, sgbsl (which also use the BLAS routines saxpy, sscal,
!   isamax and sdot). The only machine dependent parameters used appear
!   IN spmpar.
!
!***********************************************************************
!** Description of the arguments to stfode (an overview) **
!**********************************************************
!
!   The parameters are
!
!      F -- this is the name of a subroutine which you provide to
!             define the differential equations.
!
!      neq -- this is the number of (first order) differential
!             equations to be integrated.
!
!      t -- this is a value of the independent variable.
!
!      y(*) -- this array contains the solution components at t.
!
!      tout -- this is a point at which a solution is desired.
!
!      info(*) -- the BASIC task of the code is to integrate the
!             differential equations from t to tout and return an
!             answer at tout. info(*) is an integer array which is used
!             to communicate exactly how you want this task to be
!             carried out.
!
!      rtol, atol -- these quantities represent relative and absolute
!             error tolerances which you provide to indicate how
!             accurately you wish the solution to be computed. You may
!             choose them to be both scalars or else both vectors.
!
!      idid -- this scalar quantity is an indicator reporting what
!             the code did. You must monitor this integer variable to
!             decide what action to take next.
!
!      rwork(*), lrw -- rwork(*) is a real work array of length lrw
!             which provides the code with needed storage space.
!
!      iwork(*), liw -- iwork(*) is an integer work array of length liw
!             which provides the code with needed storage space.
!
!      Rpar, ipar -- these are real and integer parameter arrays which
!             you can use for communication between your calling
!             program and the F subroutine (and the JAC subroutine).
!
!      JAC -- this is the name of a subroutine which you may choose to
!             provide for defining the Jacobian matrix of partial
!             DERIVATIVES DF/DU.
!
!  Quantities which are used as input items are
!             neq, t, y(*), tout, info(*),
!             rtol, atol, rwork(1), lrw,
!             iwork(1), iwork(2), AND liw.
!
!  Quantities which may be altered by the code are
!             t, y(*), info(1), rtol, atol,
!             idid, rwork(*) AND iwork(*).
!
!***********************************************************************
!** Input -- what to do on the first call to stfode **
!*****************************************************
!
!   The first call of the code is defined to be the start of each new
!   problem. Read through the descriptions of all the following items,
!   provide sufficient storage space for designated arrays, set
!   appropriate variables for the initialization of the problem, and
!   give information about how you want the problem to be solved.
!
!
!      F -- provide a subroutine of the form
!                               F(X,U,UPRIME,rpar,ipar)
!             to define the system of first order differential equations
!             which is to be solved. For the given values of X and the
!             vector  U(*)=(U(1),U(2),...,U(neq)) , the subroutine must
!             evaluate the neq components of the system of differential
!             equations  DU/DX=F(X,U)  and store the derivatives in the
!             array uprime(*), that is,  uprime(I) = * DU(I)/DX *  for
!             EQUATIONS I=1,...,neq.
!
!             Subroutine F must not alter X or U(*). You must declare
!             the name F in an external statement in your program that
!             calls stfode. You must dimension U and UPRIME in F.
!
!             Rpar and ipar are real and integer parameter arrays which
!             you can use for communication between your calling program
!             and subroutine F. they are not used or altered by stfode.
!             If you do not need rpar or ipar, ignore these parameters
!             by treating them as dummy arguments. If you do choose to
!             use them, dimension them in your calling program and in F
!             as arrays of appropriate length.
!
!      neq -- set it to the number of differential equations.
!             (neq .GE. 1)
!
!      t -- set it to the initial point of the integration.
!             You must use a program variable for t because the code
!             changes its value.
!
!      y(*) -- set this vector to the initial values of the neq solution
!             components at the initial point. You must dimension y at
!             least neq in your calling program.
!
!      tout -- set it to the first point at which a solution
!             is desired. You can take tout = t, in which case the code
!             will evaluate the derivative of the solution at t and
!             RETURN. INTEGRATION EITHER FORWARD IN t  (tout .GT. t)  OR
!             backward in t  (tout .LT. t)  is permitted.
!
!             The code advances the solution from t to tout using
!             step sizes which are automatically selected so as to
!             achieve the desired accuracy. If you wish, the code will
!             RETURN WITH THE SOLUTION AND ITS DERIVATIVE FOLLOWING
!             each intermediate step (intermediate-output mode) so that
!             you can monitor them, but you still must provide tout in
!             accord with the BASIC aim of the code.
!
!             The first step taken by the code is a critical one
!             because it must reflect how fast the solution changes near
!             the initial point. The code automatically selects an
!             initial step size which is practically always suitable for
!             the problem. By using the fact that the code will not step
!             past tout in the first step, you could, if necessary,
!             restrict the length of the initial step size.
!
!             For some problems it may not be permissible to integrate
!             past a point TSTOP because a discontinuity occurs there
!             or the solution or its derivative is not defined beyond
!             TSTOP. When you have declared A TSTOP point (see info(4)
!             and rwork(1)), you have told the code not to integrate
!             past TSTOP. In this case any tout beyond TSTOP is invalid
!             input.
!
!      info(*) -- use the info array to give the code more details about
!             how you want your problem solved. This array should be
!             dimensioned of length 15 to accomodate other members of
!             DEPAC or possible future extensions, though stfode uses
!             only the first six entries. You must respond to all of
!             the following items which are arranged as questions. The
!             simplest use of the code corresponds to answering all
!             questions as yes ,I.E. setting all entries of info to 0.
!
!        info(1) -- this parameter enables the code to initialize
!               itself. You must set it to indicate the start of every
!               new problem.
!
!            **** Is this the first call for this problem ...
!                  YES -- SET info(1) = 0
!                   no -- not applicable here.
!                         See below for continuation calls.  ****
!
!        info(2) -- how much accuracy you want of your solution
!               is specified by the error tolerances rtol and atol.
!               The simplest use is to take them both to be scalars.
!               To obtain more flexibility, they can both be vectors.
!               The code must be told your choice.
!
!            **** Are both error tolerances rtol, atol scalars ...
!                  YES -- SET info(2) = 0
!                         and input scalars for both rtol and atol
!                   NO -- SET info(2) = 1
!                         and input arrays for both rtol and atol ****
!
!        info(3) -- the code integrates from t in the direction
!               of tout by steps. If you wish, it will return the
!               computed solution and derivative at the next
!               intermediate step (the intermediate-output mode) or
!               tout, whichever comes first. This is a good way to
!               proceed if you want to see the behavior of the solution.
!               If you must have solutions at a great many specific
!               tout points, this code will compute them efficiently.
!
!            **** Do you want the solution only at
!                 tout (and not at the next intermediate step) ...
!                  YES -- SET info(3) = 0
!                   NO -- SET info(3) = 1 ****
!
!        info(4) -- to handle solutions at a great many specific
!               values tout efficiently, this code may integrate past
!               tout and interpolate to obtain the result at tout.
!               Sometimes it is not possible to integrate beyond some
!               point TSTOP because the equation changes there or it is
!               not defined past TSTOP. Then you must tell the code
!               not to go past.
!
!            **** Can the integration be carried out without any
!                 restrictions on the independent variable t ...
!                  YES -- SET info(4)=0
!                   NO -- SET info(4)=1
!                         and define the stopping point TSTOP by
!                         SETTING rwork(1)=TSTOP ****
!
!        info(5) -- to solve stiff problems it is necessary to use the
!               Jacobian matrix of partial derivatives of the system
!               of differential equations. If you do not provide A
!               subroutine to evaluate it analytically (see the
!               description of the item JAC in the call list), it will
!               be approximated by numerical differencing in this code.
!               Although it is less trouble for you to have the code
!               compute partial derivatives by numerical differencing,
!               the solution will be more reliable if you provide the
!               derivatives via JAC. Sometimes numerical differencing
!               is cheaper than evaluating derivatives in JAC and
!               sometimes it is not - This depends on your problem.
!
!               If your problem is linear, I.E. has the form
!               DU/DX = F(X,U) = J(X)*U + G(X)   for some matrix J(X)
!               and vector G(X), the Jacobian matrix  df/DU = J(X).
!               Since you must provide a subroutine to evaluate F(X,U)
!               analytically, it is little extra trouble to provide
!               subroutine jac for evaluating J(X) analytically.
!               Furthermore, in such cases, numerical differencing is
!               much more expensive than analytic evaluation.
!
!            **** Do you want the code to evaluate the partial
!                 derivatives automatically by numerical differences ...
!                  YES -- SET info(5)=0
!                   NO -- SET info(5)=1
!                         and provide subroutine jac for evaluating the
!                         Jacobian matrix ****
!
!        info(6) -- stfode will perform much better if the Jacobian
!               matrix is banded and the code is told this. In this
!               case, the storage needed will be greatly reduced,
!               numerical differencing will be performed more cheaply,
!               and a number of important algorithms will execute much
!               faster. The differential equation is said to have
!               half-bandwidths ml (lower) and mu (UPPER) if equation I
!               involves only unknowns y(J) with
!                              I-ml .LE. J .LE. I+MU
!               for all I=1,2,...,neq. Thus, ml and mu are the widths
!               of the lower and upper parts of the band, respectively,
!               with the main diagonal being excluded. If you do not
!               indicate that the equation has a banded Jacobian,
!               the code works with a full matrix of neq**2 elements
!               (stored in the conventional way). Computations with
!               banded matrices cost less time and storage than with
!               full matrices if  2*ml+mu .LT. neq.  If you tell the
!               code that the Jacobian matrix HAS a banded structure and
!               you want to provide subroutine jac to compute the
!               partial derivatives, then you must be careful to store
!               the elements of the Jacobian matrix in the special form
!               indicated in the description of JAC.
!
!            **** Do you want to solve the problem using a full
!                 (dense) Jacobian matrix (and not a special banded
!                 structure) ...
!                  YES -- SET info(6)=0
!                   NO -- SET info(6)=1
!                         and provide the lower (ml) and upper (MU)
!                         bandwidths by setting
!                         iwork(1)=ml
!                         iwork(2)=mu ****
!
!      rtol, atol -- you must assign relative (rtol) and absolute (atol)
!             error tolerances to tell the code how accurately you want
!             the solution to be computed. They must be defined as
!             program variables because the code may change them. You
!             have two choices --
!                  both rtol and atol are scalars. (info(2)=0)
!                  both rtol and atol are vectors. (info(2)=1)
!             in either case all components must be non-negative.
!
!             The tolerances are used by the code in a local error test
!             at each step which requires roughly that
!                     abs(LOCAL ERROR) .LE. rtol*abs(y)+atol
!             for each vector component.
!             (More specifically, a root-mean-square norm is used to
!             measure the size of vectors, and the error test uses the
!             magnitude of the solution at the beginning of the step.)
!
!             The true (GLOBAL) error is the difference between the true
!             solution of the initial value problem and the computed
!             approximation. Practically all present day codes,
!             including this one, control the local error at each step
!             and do not even attempt to control the global error
!             directly. Roughly speaking, they produce a solution y(t)
!             which satisfies the differential equations with A
!             RESIDUAL R(t),    DY(t)/DT = F(t,y(t)) + R(t)   ,
!             and, almost always, R(t) is bounded by the error
!             tolerances. Usually, but not always, the true accuracy of
!             the computed y is comparable to the error tolerances. This
!             code will usually, but not always, deliver a more accurate
!             solution if you reduce the tolerances and integrate again.
!             By comparing two such solutions you can get a fairly
!             reliable idea of the true error in the solution at the
!             bigger tolerances.
!
!             Setting atol=0. Results in a pure relative error test on
!             that component. Setting rtol=0. Results in a pure absolute
!             error test on that component. A mixed test with non-zero
!             rtol and atol corresponds roughly to a relative error
!             test when the solution component is much bigger than atol
!             and to an absolute error test when the solution component
!             is smaller than the threshold atol.
!
!             Proper selection of the absolute error control parameters
!             atol  requires you to have some idea of the scale of the
!             solution components. To acquire this information may mean
!             that you will have to solve the problem more than once. In
!             the absence of scale information, you should ask for some
!             relative accuracy in all the components (by setting  rtol
!             values non-zero) and perhaps impose extremely small
!             absolute error tolerances to protect against the danger of
!             a solution component becoming zero.
!
!             The code will not attempt to compute a solution at an
!             accuracy unreasonable for the machine being used. It will
!             advise you if you ask for too much accuracy and inform
!             you as to the maximum accuracy it believes possible.
!
!      rwork(*) -- dimension this real work array of length lrw in your
!             calling program.
!
!      rwork(1) -- if you have set info(4)=0, you can ignore this
!             optional input parameter. Otherwise you must define A
!             stopping point TSTOP by setting   rwork(1) = TSTOP.
!             (For some problems it may not be permissible to integrate
!             past a point TSTOP because a discontinuity occurs there
!             or the solution or its derivative is not defined beyond
!             TSTOP.)
!
!      lrw -- set it to the declared length of the rwork array.
!             You must have
!                  lrw .GE. 250+10*neq+neq**2
!             for the full (dense) Jacobian case (when info(6)=0),  or
!                  lrw .GE. 250+10*neq+(2*ml+MU+1)*neq
!             for the banded Jacobian case (when info(6)=1).
!
!      iwork(*) -- dimension this integer work array of length liw in
!             your calling program.
!
!      iwork(1), iwork(2) -- if you have set info(6)=0, you can ignore
!             these optional input parameters. Otherwise you must define
!             the half-bandwidths ml (lower) and mu (UPPER) of the
!             Jacobian matrix BY setting    iwork(1) = ml   and
!             iwork(2) = Mu.  (The code will work with a full matrix
!             of neq**2 elements unless it is told that the problem has
!             a banded Jacobian, in which case the code will work with
!             a matrix containing at most  (2*ml+MU+1)*neq  elements.)
!
!      liw -- set it to the declared length of the iwork array.
!             You must have liw .GE. 55+neq.
!
!      Rpar, ipar -- these are parameter arrays, of real and integer
!             type, respectively. You can use them for communication
!             between your program that calls stfode and the  F
!             subroutine (and the JAC subroutine). They are not used or
!             altered by stfode. If you do not need rpar or ipar, ignore
!             these parameters by treating them as dummy arguments. If
!             you do choose to use them, dimension them in your calling
!             program and in F (and in JAC) as arrays of appropriate
!             length.
!
!      JAC -- if you have set info(5)=0, you can ignore this parameter
!             by treating it as a dummy argument. (For some compilers
!             you may have to write a dummy subroutine named  jac  in
!             order to avoid problems associated with missing external
!             routine names.)  Otherwise, you must provide a subroutine
!             of the form
!                          JAC(X,U,PD,NROWPD,rpar,ipar)
!             to define the Jacobian matrix of partial derivatives DF/DU
!             of the system of differential equations   DU/DX = F(X,U).
!             For the given values of X and the vector
!             U(*)=(U(1),U(2),...,U(neq)), the subroutine must evaluate
!             the non-zero partial derivatives  DF(I)/DU(J)  for each
!             differential equation I=1,...,neq and each solution
!             component J=1,...,neq , and store these values in the
!             matrix pd. The elements of pd are set to zero before each
!             CALL TO JAC SO ONLY NON-ZERO ELEMENTS NEED TO BE DEFINED.
!
!             Subroutine jac must not alter X, U(*), or NROWPD. You must
!             declare the name JAC in an external statement in your
!             program that calls stfode. NROWPD is the row dimension of
!             the PD matrix and is assigned by the code. Therefore you
!             must dimension PD in JAC according to
!                              dimension pd(nrowpd,1)
!             you must also dimension U in JAC.
!
!             The way you must store the elements into the PD matrix
!             depends on the structure of the Jacobian which you
!             indicated by info(6).
!             *** info(6)=0 -- FULL (DENSE) JACOBIAN ***
!                 when you evaluate the (NON-ZERO) partial derivative
!                 of equation I with respect to variable J, you must
!                 store it in PD according to
!                                pd(i,j) = * df(i)/du(j) *
!             *** info(6)=1 -- banded Jacobian with ml lower and mu
!                 upper diagonal bands (refer to info(6) description of
!                 ml AND MU) ***
!                 when you evaluate the (NON-ZERO) partial derivative
!                 of equation I with respect to variable J, you must
!                 store it in PD according to
!                                irow = i - j + ml + mu + 1
!                                pd(irow,j) = * df(i)/du(j) *
!
!             Rpar and ipar are real and integer parameter arrays which
!             you can use for communication between your calling
!             program and your Jacobian subroutine jac. They are not
!             altered by stfode. If you do not need rpar or ipar, ignore
!             these parameters by treating them as dummy arguments. If
!             you do choose to use them, dimension them in your calling
!             program and in JAC as arrays of appropriate length.
!
!***********************************************************************
!** Output -- after any return from stfode **
!********************************************
!
!   The principal aim of the code is to return a computed solution at
!   tout, although it is also possible to obtain intermediate results
!   along the way. To find out whether the code achieved its goal
!   or if the integration process was interrupted before the task was
!   completed, you must check the idid parameter.
!
!
!      t -- the solution was successfully advanced to the
!             output value of t.
!
!      y(*) -- contains the computed solution approximation at t.
!             You may also be interested in the approximate derivative
!             of the solution at t. it is contained in
!             rwork(21),...,rwork(20+neq).
!
!      idid -- reports what the code did
!
!                         *** Task completed ***
!                   reported by positive values of idid
!
!             idid = 1 -- a step was successfully taken in the
!                       intermediate-output mode. The code has not
!                       yet reached tout.
!
!             idid = 2 -- the integration to tout was successfully
!                       completed (t=tout) by stepping exactly to tout.
!
!             idid = 3 -- the integration to tout was successfully
!                       completed (t=tout) by stepping past tout.
!                       y(*) is obtained by interpolation.
!
!                         *** Task interrupted ***
!                   reported by negative values of idid
!
!             idid = -1 -- a large amount of work has been expended.
!                       (500 Steps performed)
!
!             idid = -2 -- the error tolerances are too stringent.
!
!             idid = -3 -- the local error test cannot be satisfied
!                       since the L-TH solution component is 0 and
!                       the corresponding absolute error tolerance
!                       is 0 for L = -info(1). A pure relative error
!                       test cannot be applied to this component.
!
!             idid = -4,-5  -- not applicable for this code.
!
!             idid = -6 -- stfode had repeated convergence test failures
!                       on the last attempted step.
!
!             idid = -7 -- stfode had repeated error test failures on
!                       the last attempted step.
!
!             idid = -8,..,-32  -- not applicable for this code.
!
!                         *** Task terminated ***
!                 reported by the value of idid .LE. -33
!
!             idid = -33  -- neq .lt. 1
!
!             idid = -34  -- rtol(K) .LT. 0 for some K
!
!             idid = -35  -- atol(K) .LT. 0 for some K
!
!             idid = -36  -- the code has been called with tout but
!                       the code has also been told not to integrate
!                       past the point TSTOP.
!
!             idid = -37  -- the code has been called with t = tout.
!                       This is not permitted on continuation calls.
!
!             idid = -38  -- the user has modified the value of t.
!                       This is not permitted on continuation calls.
!
!             idid = -39  -- by calling the code with tout, an
!                       attempt is being made to change the direction
!                       of integration without restarting.
!
!             idid = -40  -- the Jacobian matrix is banded. However
!                       the bandwidths ml and mu do not satisfy the
!                       CONSTRAINTS  0 .LE. ml,MU .LT. neq.
!
!             idid = -41  -- lrw .lt. 250 + 10*neq + neq*neq
!
!             idid = -42  -- lrw .lt. 250 + 10*neq + (2*ml+mu+1)*neq
!
!             idid = -43  -- liw .lt. 55 + neq
!
!             idid = -44  -- info(1) is incorrect.
!
!      rtol, atol -- these quantities remain unchanged except when
!             idid = -2. In this case, the error tolerances have been
!             increased by the code to values which are estimated to be
!             appropriate for continuing the integration. However, the
!             reported solution at t was obtained using the input values
!             of rtol and atol.
!
!      rwork, iwork -- contain information which is usually of no
!             interest to the user but necessary for subsequent calls.
!             However, you may find use for
!
!             rwork(11)--which contains the step size h to be
!                        attempted on the next step.
!
!             rwork(12)--if the tolerances have been increased by the
!                        code (idid = -2) , they were multiplied by the
!                        value in rwork(12).
!
!             rwork(13)--which contains the current value of the
!                        independent variable, I.E. the farthest point
!                        integration has reached. This will be different
!                        from t only when interpolation has been
!                        PERFORMED (idid=3).
!
!             rwork(20+I)--which contains the approximate derivative
!                        of the solution component y(I). In stfode it is
!                        never obtained by calling subroutine F to
!                        evaluate the differential equation using t and
!                        y(*), except at the initial point of
!                        integration.
!
!***********************************************************************
!** Input -- what to do to continue the integration **
!**             (calls after the first)             **
!*****************************************************
!
!        This code is organized so that subsequent calls to continue the
!        integration involve little (if any) additional effort on your
!        part. You must monitor the idid parameter in order to determine
!        what to do next.
!
!        Recalling that the principal task of the code is to integrate
!        from t to tout (the interval mode), usually all you will need
!        to do is specify a new tout upon reaching the current tout.
!
!        Do not alter any quantity not specifically permitted below,
!        in particular do not alter neq, t, y(*), rwork(*), iwork(*) or
!        the differential equation in subroutine F. any such alteration
!        constitutes a new problem and must be treated as such, I.E.
!        You must start afresh.
!
!        You cannot change from vector to scalar error control or vice
!        versa (info(2)) but you can change the size of the entries of
!        rtol, atol. Increasing a tolerance makes the equation easier
!        to integrate. Decreasing a tolerance will make the equation
!        harder to integrate and should generally be avoided.
!
!        You can switch from the intermediate-output mode to the
!        interval mode (info(3)) or vice versa at any time.
!
!        If it has been necessary to prevent the integration from going
!        past a point TSTOP (info(4), rwork(1)), keep in mind that the
!        code will not integrate to any tout beyond the currently
!        specified TSTOP. Once TSTOP has been reached you must change
!        the value of TSTOP or set info(4)=0. You may change info(4)
!        or TSTOP at any time but you must supply the value of TSTOP in
!        rwork(1) whenever you set info(4)=1.
!
!        Do not change info(5), info(6), iwork(1), or iwork(2)
!        unless you are going to restart the code.
!
!        The parameter info(1) is used by the code to indicate the
!        beginning of a new problem and to indicate whether integration
!        is to be continued. You must input the value  info(1) = 0
!        when starting a new problem. You must input the value
!        info(1) = 1  If you wish to continue after an interrupted task
!        for which idid = -3, -6, or -7. Do not set info(1) = 0 On A
!        continuation call unless you want the code to restart at the
!        CURRENT t.
!
!                         *** Following a completed task ***
!         if
!             idid = 1, call the code again to continue the integration
!                     another step in the direction of tout.
!
!             idid = 2 Or 3, define a new tout and call the code again.
!                     Tout must be different from t. you cannot change
!                     the direction of integration without restarting.
!
!                         *** Following an interrupted task ***
!         if
!             idid = -1, the code has performed 500 steps.
!                     If you want to continue, call the code again.
!
!             idid = -2, the error tolerances rtol and atol have been
!                     increased to values the code estimates appropriate
!                     for continuing. You may want to change them
!                     yourself. If you want to continue, call the code
!                     again.
!
!             idid = -3, the L-TH solution component is 0 and the
!                     corresponding absolute error tolerance is 0
!                     for L = -info(1). To continue, reset the
!                     absolute tolerance to a positive value, set
!                     info(1) = 1, and call the code again.
!
!             idid = -4,-5  --- cannot occur with this code.
!
!             idid = -6, repeated convergence test failures occurred
!                     on the last attempted step. An inaccurate
!                     Jacobian may be the problem. If you are absolutely
!                     certain you want to continue, restart the
!                     integration at the current t by setting  info(1)=0
!                     and call the code again.
!
!             idid = -7, repeated error test failures occurred on the
!                     last attempted step. A singularity in the
!                     solution may be present. You should RE-examine the
!                     problem being solved. If you are absolutely
!                     certain you want to continue, restart the
!                     integration at the current t by setting  info(1)=0
!                     and call the code again.
!
!             idid = -8,..,-32  --- cannot occur with this code.
!
!                         *** Following a terminated task ***
!         if
!             idid .LE. -33, an input error has been detected. After the
!                     error is corrected, restart by setting info(1) = 0
!                     and call the code again.
!
!***********************************************************************
!
!         ***** WARNING *****
!
!     If stfode is to be used in an overlay situation, you must save and
!     restore certain items used internally by stfode  (values in the
!     common block debdf1). This can be accomplished as follows.
!
!     To save the necessary values upon return from stfode, simply call
!        svco(rwork(22+neq),iwork(21+neq)).
!
!     To restore the necessary values before the next call to stfode,
!     SIMPLY CALL    rsco(rwork(22+neq),iwork(21+neq)).
!
!***********************************************************************
!
!***REFERENCES
!   Shampine L.F., Watts H.A., *DEPAC - Design of a user oriented
!   package of ODE solvers*, SAND79-2374, Sandia Laboratories, 1979.
!
!
!
dimension iwork(liw)
!
common /debdf1/ told, rowns(210), &
   & el0, h, hmin, hmxi, hu, tn, uround, &
   & iquit, init, iyh, iewt, iacor, isavf, iwm, ksteps, &
   & ibegin, itol, iinteg, itstop, ijac, iband, iowns(6), &
   & ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
   & nje, nqu
!
!
!.......................................................................
!
idid = 0
!
if (info(1) == 0) go to 20
if (info(1) /= 1) go to 10
if (iquit == 0) go to 20
10 idid = -44
return
!
20 if (info(2) /= 0) info(2) = 1
if (info(3) /= 0) info(3) = 1
if (info(4) /= 0) info(4) = 1
if (info(5) /= 0) info(5) = 1
if (info(6) /= 0) info(6) = 1
!
ilrw = neq
if (info(6) == 0) go to 80
!
!     Check bandwidth parameters
!
ml = iwork(1)
mu = iwork(2)
ilrw = 2*ml + mu + 1
if (ml >= 0  .and.  ml < neq      .and. &
   & mu >= 0  .and.  mu < neq) go to 80
idid = -40
return
!
!     Check lrw and liw for sufficient storage allocation
!
80 if (lrw >= 250 + (10 + ilrw)*neq) go to 100
!
if (info(6) == 1) go to 90
idid = -41
return
!
90 idid = -42
return
!
100 if (liw >= 55 + neq) go to 200
idid = -43
return
!
!     Compute the indices for the arrays to be stored in the work array
!     and restore common block DATA
!
200 icomi = 21 + neq
iinout = icomi + 33
!
iypout = 21
itstar = 21 + neq
icomr = 22 + neq
!
if (info(1) == 0) go to 250
intout = iwork(iinout) /= (-1)
!     call rsco(rwork(icomr),iwork(icomi))
!
250 iyh = icomr + 218
iewt = iyh + 6*neq
isavf = iewt + neq
iacor = isavf + neq
iwm = iacor + neq
idelsn = iwm + 2 + ilrw*neq
!
ibegin = info(1)
itol = info(2)
iinteg = info(3)
itstop = info(4)
ijac = info(5)
iband = info(6)
rwork(itstar) = t
!
call lsod1(f,neq,t,y,tout,rtol,atol,idid,rwork(iypout), &
   & rwork(iyh),rwork(iyh),rwork(iewt),rwork(isavf), &
   & rwork(iacor),rwork(iwm),iwork(1),jac,intout, &
   & rwork(1),rwork(12),rwork(idelsn),rpar,ipar)
!
iwork(iinout) = -1
if (intout) iwork(iinout) = 1
!
!     call svco(rwork(icomr),iwork(icomi))
rwork(11) = h
rwork(13) = tn
info(1) = ibegin
!
return
end subroutine stfode

subroutine rsco(rsav, isav)
implicit none
!-----------------------------------------------------------------------
! This routine restores from rsav and isav the contents of common
! block debdf1, which is used internally in the sfode package.
!-----------------------------------------------------------------------
integer :: isav(*)
real :: rsav(*)
integer :: i, ils
real :: rls
common /debdf1/ rls(218), ils(33)
integer, parameter :: lenrls = 218
integer, parameter :: lenils = 33
!
do 10 i = 1,lenrls
10 rls(i) = rsav(i)
do 20 i = 1,lenils
20 ils(i) = isav(i)
return
!----------------------- End of subroutine rsco -----------------------
end subroutine rsco

subroutine svco(rsav, isav)
implicit none
!-----------------------------------------------------------------------
! This routine stores in rsav and isav the contents of common block
! DEBDF1, which is used internally in the sfode package.
!
! rsav = Real array of length 218 or more.
! isav = Integer array of length 33 or more.
!-----------------------------------------------------------------------
integer :: isav(*)
real :: rsav(*)
integer :: i, ils
real :: rls
common /debdf1/ rls(218), ils(33)
integer, parameter :: lenrls = 218
integer, parameter :: lenils = 33
!
do 10 i = 1,lenrls
10 rsav(i) = rls(i)
do 20 i = 1,lenils
20 isav(i) = ils(i)
return
!----------------------- End of subroutine svco -----------------------
end subroutine svco

subroutine lsod1(f,neq,t,y,tout,rtol,atol,idid,ypout, &
   & yh,yh1,ewt,savf,acor,wm,iwm,jac,intout, &
   & tstop,tolfac,delsgn,rpar,ipar)
implicit none
integer :: idid, ipar(*), iwm(*), neq
real :: acor(neq), atol(*), delsgn, ewt(neq), rpar(*), rtol(*), &
   & savf(neq), t, tolfac, tout, tstop, wm(*), y(neq), yh(neq,*), &
   & yh1(*), ypout(neq)
logical :: intout
external f, jac
integer :: intflg, k, l, ltol, max
real :: absdel, big, del, dt, ha, tol
integer :: iband, ibegin, ier, iinteg, ijac, init, iowns, iquit, &
   & itol, itstop, jstart, kflag, ksteps, lacor, ldum, lewt, lsavf, &
   & lwm, lyh, maxord, meth, miter, n, nfe, nje, nq, nqu, nst
real :: el0, h, hmin, hmxi, hu, rowns, told, u, x
real :: vnwrms
!
!   stfode  merely allocates storage for lsod1 to relieve the user of
!   the inconvenience of a long call list.  Consequently lsod1 is used
!   as described in the comments for  stfode.
!
!***Routines called  stod,intyd,vnwrms,hstart,spmpar
!
!
!
common /debdf1/ told, rowns(210), &
   & el0, h, hmin, hmxi, hu, x, u, &
   & iquit, init, lyh, lewt, lacor, lsavf, lwm, ksteps, &
   & ibegin, itol, iinteg, itstop, ijac, iband, iowns(6), &
   & ier, jstart, kflag, ldum, meth, miter, maxord, n, nq, nst, &
   & nfe, nje, nqu
integer, parameter :: maxnum = 500
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
!
!.......................................................................
!
!  The expense of solving the problem is monitored by counting the
!  number of  steps attempted. When this exceeds  maxnum, the counter
!  is reset to zero and the user is informed about possible excessive
!  work.
!
!
!.......................................................................
!
if (ibegin /= 0) go to 10
!
! On the first call , perform initialization --
!        define the machine unit roundoff quantity  u  by calling the
!        function routine  spmpar. The user must make sure that the
!        values set in spmpar are relevant to the computer being used.
!
u = spmpar(1)
!                       -- Set associated machine dependent parameter
wm(1) = sqrt(u)
!                       -- Set termination flag
iquit = 0
!                       -- Set initialization indicator
init = 0
!                       -- Set counter for attempted steps
ksteps = 0
!                       -- Set indicator for intermediate-output
intout = .false.
!                       -- Set start indicator for stod code
jstart = 0
!                       -- Set BDF method indicator
meth = 2
!                       -- Set maximum order for BDF method
maxord = 5
!                       -- Set iteration matrix indicator
!
if (ijac == 0  .and.  iband == 0) miter = 2
if (ijac == 1  .and.  iband == 0) miter = 1
if (ijac == 0  .and.  iband == 1) miter = 5
if (ijac == 1  .and.  iband == 1) miter = 4
!
!                       -- Set other necessary items in common block
n = neq
nst = 0
nje = 0
hmxi = 0.
nq = 1
h = 1.
!                       -- Reset ibegin for subsequent calls
ibegin = 1
!
!.......................................................................
!
!      Check validity of input paramaters on each entry
!
10 if (neq >= 1) go to 20
idid = -33
go to 110
!
20 max = 1
if (itol /= 0) max = neq
do 60 k = 1,max
   if (rtol(k) >= 0.) go to 30
   idid = -34
   go to 110
30 if (atol(k) >= 0.) go to 60
   idid = -35
   go to 110
60 continue
!
if (itstop /= 1) go to 80
if ((tout - t)*(tstop - t) >= 0.0 &
   & .and. abs(tout - t) <= abs(tstop - t)) go to 80
idid = -36
go to 110
!
80 if (init == 0) go to 150
!                       Check some continuation possibilities
if (t /= tout) go to 90
idid = -37
go to 110
!
90 if (t == told) go to 100
idid = -38
go to 110
!
100 if (init == 1) go to 150
if (delsgn*(tout - t) >= 0.) go to 150
idid = -39
!
!                       Invalid input detected
110 iquit = -33
ibegin = -1
return
!
!.......................................................................
!
!     rtol = atol = 0. Is allowed as valid input and interpreted as
!     asking for the most accurate solution possible. In this case,
!     the relative error tolerance rtol is reset to the smallest value
!     100*u which is likely to be reasonable for this method and machine
!
150 do 170 k = 1,max
   if (rtol(k) + atol(k) > 0.) go to 170
   rtol(k) = 100.*u
   idid = -2
170 continue
if (idid == -2) return
!
!     Branch on status of initialization indicator
!            init=0 Means initial derivatives and nominal step size
!                   and direction not yet set
!            init=1 Means nominal step size and direction not yet set
!            init=2 Means no FUTHER initialization required
!
if (init == 0) go to 200
if (init == 1) go to 220
go to 240
!
!.......................................................................
!
!     More initialization --
!                         -- evaluate initial derivatives
!
200 init = 1
call f(t,y,yh(1,2),rpar,ipar)
nfe = 1
if (t /= tout) go to 220
idid = 2
do 210 l = 1,neq
210 ypout(l) = yh(l,2)
told = t
return
!
!                         -- Compute initial step size
!                         -- save sign of integration direction
!                         -- set independent and dependent variables
!                                              x and YH(*) for stod
!
220 ltol = 1
do 225 l = 1,neq
   if (itol == 1) ltol = l
   tol = rtol(ltol)*abs(y(l)) + atol(ltol)
   if (tol == 0.) go to 380
225 ewt(l) = tol
!
big = sqrt(spmpar(3))
call hstart(f,neq,t,tout,y,yh(1,2),ewt,1,u,big, &
   & yh(1,3),yh(1,4),yh(1,5),yh(1,6),rpar,ipar,h)
!
delsgn = sign(1.0,tout - t)
x = t
do 230 l = 1,neq
   yh(l,1) = y(l)
230 yh(l,2) = h*yh(l,2)
init = 2
!
!.......................................................................
!
!   On each call set information which determines the allowed interval
!   of integration before returning with an answer at tout
!
240 del = tout - t
absdel = abs(del)
!
!.......................................................................
!
!   If already past output point, interpolate and return
!
250 if (abs(x - t) < absdel) go to 270
call intyd(tout,0,yh,neq,y,intflg)
call intyd(tout,1,yh,neq,ypout,intflg)
idid = 3
if (x /= tout) go to 260
idid = 2
intout = .false.
260 t = tout
told = t
return
!
!   If cannot go past TSTOP and sufficiently close,
!   extrapolate and return
!
270 if (itstop /= 1) go to 290
if (abs(tstop - x) >= 100.*u*abs(x)) go to 290
dt = tout - x
do 280 l = 1,neq
280 y(l) = yh(l,1) + (dt/h)*yh(l,2)
call f(tout,y,ypout,rpar,ipar)
nfe = nfe + 1
idid = 3
t = tout
told = t
return
!
290 if (iinteg == 0  .or.  .not.intout) go to 300
!
!   Intermediate-output mode
!
idid = 1
go to 500
!
!.......................................................................
!
!     Monitor number of steps attempted
!
300 if (ksteps <= maxnum) go to 330
!
!                       A significant amount of work has been expended
idid = -1
ksteps = 0
go to 500
!
!.......................................................................
!
!   Limit step size and set weight vector
!
330 hmin = 100.*u*abs(x)
ha = amax1(abs(h),hmin)
if (itstop /= 1) go to 340
ha = min(ha,abs(tstop - x))
340 h = sign(ha,h)
ltol = 1
do l = 1,neq
   if (itol == 1) ltol = l
   ewt(l) = rtol(ltol)*abs(yh(l,1)) + atol(ltol)
   if (ewt(l) <= 0.0) go to 380
end do
tolfac = u*vnwrms(neq,yh,ewt)
if (tolfac <= 1.) go to 400
!
!                       Tolerances too small
idid = -2
tolfac = 2.*tolfac
do 360 l = 1,max
   rtol(l) = tolfac*rtol(l)
360 atol(l) = tolfac*atol(l)
go to 500
!
!                       Relative error criterion inappropriate
380 idid = -3
ibegin = -l
go to 500
!
!.......................................................................
!
!     Take a step
!
400 call stod(neq,y,yh,neq,yh1,ewt,savf,acor,wm,iwm,f,jac,rpar,ipar)
!
jstart = -2
intout = .true.
if (kflag == 0) go to 250
!
!.......................................................................
!
if (kflag == -1) go to 450
!
!                       Repeated corrector convergence failures
idid = -6
iquit = -6
ibegin = -1
go to 500
!
!                       Repeated error test failures
450 idid = -7
iquit = -7
ibegin = -1
!
!.......................................................................
!
!                       Store values before returning to stfode
500 do 555 l = 1,neq
   y(l) = yh(l,1)
555 ypout(l) = yh(l,2)/h
t = x
told = t
intout = .false.
return
end subroutine lsod1

subroutine hstart(f,neq,a,b,y,yprime,etol,morder,small,big, &
   & spy,pv,yp,sf,rpar,ipar,h)
implicit none
integer :: ipar(*)
integer, intent(in) :: morder, neq
real :: a
real, intent(in) :: b, big
real :: etol(neq)
real, intent(inout) :: h, pv(neq)
real :: rpar(*), sf(neq)
real, intent(in) :: small
real, intent(inout) :: spy(neq)
real :: y(neq)
real, intent(inout) :: yp(neq)
real :: yprime(neq)
external f
integer :: j, k, lk
real :: absdx, da, delf, dely, dfdub, dfdxb, dx, dy, fbnd, relper, &
   & srydpb, tolexp, tolmin, tolp, tolsum, ydpb
real :: vnorm
!
!   hstart computes a starting step size to be used in solving initial
!   value problems in ordinary differential equations.
!
!
!***********************************************************************
!  Abstract
!
!     Subroutine hstart computes a starting step size to be used by an
!     initial value method in solving ordinary differential equations.
!     It is based on an estimate of the local Lipschitz constant for the
!     DIFFERENTIAL EQUATION   (LOWER BOUND ON A NORM OF THE JACOBIAN) ,
!     a bound on the differential equation  (first derivative) , and
!     a bound on the partial derivative of the equation with respect to
!     the independent variable.
!     (All approximated near the initial point A)
!
!     Subroutine hstart uses a function subprogram vnorm for computing
!     a vector NORM. The maximum NORM is presently utilized though it
!     can easily be replaced by any other vector NORM. It is presumed
!     that any replacement norm routine would be carefully coded to
!     prevent unnecessary underflows or overflows from occurring, and
!     also, would not alter the vector or number of components.
!
!***********************************************************************
!  On input you must provide the following
!
!      F -- this is a subroutine of the form
!                               F(X,U,UPRIME,rpar,ipar)
!             which defines the system of first order differential
!             equations to be solved. For the given values of X and the
!             vector  U(*)=(U(1),U(2),...,U(neq)) , the subroutine must
!             evaluate the neq components of the system of differential
!             equations  DU/dx=F(X,U)  and store the derivatives in the
!             array uprime(*), that is,  uprime(I) = * DU(I)/dx *  for
!             EQUATIONS I=1,...,neq.
!
!             Subroutine F must not alter X or U(*). You must declare
!             the name F in an external statement in your program that
!             calls hstart. You must dimension U and UPRIME in F.
!
!             Rpar and ipar are real and integer parameter arrays which
!             you can use for communication between your program and
!             subroutine F. they are not used or altered by hstart. If
!             you do not need rpar or ipar, ignore these parameters by
!             treating them as dummy arguments. If you do choose to use
!             them, dimension them in your program and in F as arrays
!             of appropriate length.
!
!      neq -- this is the number of (first order) differential equations
!             to be integrated.
!
!      a -- this is the initial point of integration.
!
!      b -- this is a value of the independent variable used to define
!             the direction of integration. A reasonable choice is to
!             set  b  to the first point at which a solution is desired.
!             You can also use  b, if necessary, to restrict the length
!             of the first integration step because the algorithm will
!             not compute a starting step length which is bigger than
!             abs(b-a), unless  b  has been chosen too close to  A.
!             (It is presumed that hstart has been called with  b
!             different from  A  on the machine being used. Also see the
!             discussion about the parameter  small.)
!
!      y(*) -- this is the vector of initial values of the neq solution
!             components at the initial point  A.
!
!      yprime(*) -- this is the vector of derivatives of the neq
!             solution components at the initial point  A.
!             (Defined by the differential equations in subroutine F)
!
!      etol -- this is the vector of error tolerances corresponding to
!             the neq solution components. It is assumed that all
!             elements are positive. Following the first integration
!             step, the tolerances are expected to be used by the
!             integrator in an error test which roughly requires that
!                        abs(LOCAL ERROR)  .LE.  etol
!             for each vector component.
!
!      morder -- this is the order of the formula which will be used by
!             the initial value method for taking the first integration
!             step.
!
!      small -- this is a small positive machine dependent constant
!             which is used for protecting against computations with
!             numbers which are too small relative to the precision of
!             floating point arithmetic.  Small  should be set to
!             (approximately) the smallest positive real number such
!             that  (1.+small) .GT. 1.  On the machine being used. The
!             quantity  small**(3/8)  is used in computing increments of
!             variables for approximating derivatives by differences.
!             Also the algorithm will not compute a starting step length
!             which is smaller than  100*small*abs(a).
!
!      big -- this is a large positive machine dependent constant which
!             is used for preventing machine overflows. A reasonable
!             choice is to set big to (approximately) the square root of
!             the largest real number which can be held in the machine.
!
!      spy(*),pv(*),yp(*),sf(*) -- these are real work arrays of length
!             neq which provide the routine with needed storage space.
!
!      Rpar,ipar -- these are parameter arrays, of real and integer
!             type, respectively, which can be used for communication
!             between your program and the F subroutine. They are not
!             used or altered by hstart.
!
!***********************************************************************
!  On output  (after the return from hstart),
!
!      h -- is an appropriate starting step size to be attempted by the
!             differential equation method.
!
!           All parameters in the call list remain unchanged except for
!           the working arrays spy(*),pv(*),yp(*), and sf(*).
!
!***********************************************************************
!
!***Routines called  vnorm
!
!
!.......................................................................
!
dx = b - a
absdx = abs(dx)
relper = small**0.375
!
!.......................................................................
!
!     Compute an approximate bound (dfdxb) on the partial
!     derivative of the equation with respect to the
!     independent variable. Protect against an overflow.
!     Also compute a bound (fbnd) on the first derivative locally.
!
da = sign(max(min(relper*abs(a),absdx),100.*small*abs(a)),dx)
if (da == 0.) da = relper*dx
call f(a + da,y,sf,rpar,ipar)
do 10 j = 1,neq
10 yp(j) = sf(j) - yprime(j)
delf = vnorm(yp,neq)
dfdxb = big
if (delf < big*abs(da)) dfdxb = delf/abs(da)
fbnd = vnorm(sf,neq)
!
!.......................................................................
!
!     Compute an estimate (dfdub) of the local Lipschitz constant for
!     the system of differential equations. This also represents an
!     estimate of the norm of the Jacobian locally.
!     Three iterations (two when neq=1) are used to estimate the
!     Lipschitz constant by numerical differences. The first
!     perturbation vector is based on the initial derivatives and
!     direction of integration. The second perturbation vector is
!     formed using another evaluation of the differential equation.
!     The third perturbation vector is formed using perturbations based
!     only on the initial values. Components that are zero are always
!     changed to non-zero values (except on the first iteration). When
!     information is available, care is taken to ensure that components
!     of the perturbation vector have signs which are consistent with
!     the slopes of local solution curves.
!     Also choose the largest bound (fbnd) for the first derivative.
!
!                       Perturbation vector SIZE is held constant for
!                       all iterations. Compute this change from the
!                               size of the vector of initial values.
dely = relper*vnorm(y,neq)
if (dely == 0.) dely = relper
dely = sign(dely,dx)
delf = vnorm(yprime,neq)
fbnd = max(fbnd,delf)
if (delf == 0.) go to 30
!                       Use initial derivatives for first perturbation
do 20 j = 1,neq
   spy(j) = yprime(j)
20 yp(j) = yprime(j)
go to 50
!                       Cannot have a null perturbation vector
30 do 40 j = 1,neq
   spy(j) = 0.
40 yp(j) = 1.
delf = vnorm(yp,neq)
!
50 dfdub = 0.
lk = min(neq + 1,3)
do 140 k = 1,lk
!                       Define perturbed vector of initial values
   do 60 j = 1,neq
60    pv(j) = y(j) + dely*(yp(j)/delf)
   if (k == 2) go to 80
!                       Evaluate derivatives associated with perturbed
!                       vector  and  compute corresponding differences
   call f(a,pv,yp,rpar,ipar)
   do 70 j = 1,neq
70    pv(j) = yp(j) - yprime(j)
   go to 100
!                       Use a shifted value of the independent variable
!                                             in computing one estimate
80 call f(a + da,pv,yp,rpar,ipar)
   do 90 j = 1,neq
90    pv(j) = yp(j) - sf(j)
!                       Choose largest bounds on the first derivative
!                                      and a local Lipschitz constant
100 fbnd = max(fbnd,vnorm(yp,neq))
   delf = vnorm(pv,neq)
   if (delf >= big*abs(dely)) go to 150
   dfdub = max(dfdub,delf/abs(dely))
   if (k == lk) go to 160
!                       Choose next perturbation vector
   if (delf == 0.) delf = 1.
   do 130 j = 1,neq
      if (k == 2) go to 110
      dy = abs(pv(j))
      if (dy == 0.) dy = delf
      go to 120
110   dy = y(j)
      if (dy == 0.) dy = dely/relper
120   if (spy(j) == 0.) spy(j) = yp(j)
      if (spy(j) /= 0.) dy = sign(dy,spy(j))
130   yp(j) = dy
140 delf = vnorm(yp,neq)
!
!                       Protect against an overflow
150 dfdub = big
!
!.......................................................................
!
!     Compute a bound (YDPB) on the norm of the second derivative
!
160 ydpb = dfdxb + dfdub*fbnd
!
!.......................................................................
!
!     Define the tolerance parameter upon which the starting step size
!     is to be based.  A value in the middle of the error tolerance
!     range is selected.
!
tolmin = big
tolsum = 0.
do 170 k = 1,neq
   tolexp = log10(etol(k))
   tolmin = min(tolmin,tolexp)
170 tolsum = tolsum + tolexp
tolp = 10.**(0.5*(tolsum/float(neq) + tolmin)/float(morder + 1))
!
!.......................................................................
!
!     Compute a starting step size based on the above first and second
!     derivative information
!
!                       Restrict the step length to be not bigger than
!                       abs(b-a).   (UNLESS  b  IS TOO CLOSE TO  A)
h = absdx
!
if (ydpb /= 0.  .or.  fbnd /= 0.) go to 180
!
!                       Both first derivative term (fbnd) and second
!                                    derivative term (YDPB) are zero
if (tolp < 1.) h = absdx*tolp
go to 200
!
180 if (ydpb /= 0.) go to 190
!
!                       Only second derivative term (YDPB) is zero
if (tolp < fbnd*absdx) h = tolp/fbnd
go to 200
!
!                       Second derivative term (YDPB) is non-zero
190 srydpb = sqrt(0.5*ydpb)
if (tolp < srydpb*absdx) h = tolp/srydpb
!
!                       Further restrict the step length to be not
!                                                 bigger than  1/dfdub
200 if (h*dfdub > 1.) h = 1./dfdub
!
!                       Finally, restrict the step length to be not
!                       smaller than  100*small*abs(a).  However, if
!                       a=0. And the computed h UNDERFLOWED to zero,
!                       the algorithm returns  small*abs(b)  for the
!                                                       step length.
h = max(h,100.*small*abs(a))
if (h == 0.) h = small*abs(b)
!
!                       Now set direction of integration
h = sign(h,dx)
!
return
end subroutine hstart

subroutine intyd(t, k, yh, nyh, dky, iflag)
implicit none
!
!   intyd approximates the solution and derivatives at t by polynomial
!   interpolation. Must be used in conjunction with the integrator
!   PACKAGE sfode.
!-----------------------------------------------------------------------
! intyd computes interpolated values of the k-TH derivative of the
! dependent variable vector Y, and stores it in dky.
! This routine is called by stfode with k = 0,1 and t = Tout, but may
! also be called by the user for any k up to the current order.
! (See detailed instructions in lsode usage documentation.)
!-----------------------------------------------------------------------
! The computed values in dky are gotten by interpolation using the
! Nordsieck history array yh.  This array corresponds uniquely to A
! vector-valued polynomial of degree NQCUR or less, and dky is set
! to the k-TH derivative of this polynomial at t.
! The formula for dky is..
!              Q
!  dky(i)  =  SUM  c(j,k) * (t - tn)**(j-k) * h**(-j) * yh(i,j+1)
!             j=k
! WHERE  c(j,k) = j*(j-1)*...*(j-k+1), Q = NQCUR, tn = TCUR, h = HCUR.
! The quantities  NQ = NQCUR, L = NQ+1, N = NEQ, tn, and h are
! communicated by common.  The above sum is done in reverse order.
! iflag is returned negative if either k or t is out of bounds.
!-----------------------------------------------------------------------
integer :: k, nyh, iflag
real :: t, yh(nyh,*), dky(*)
integer :: i, ic, ier, iownd, iowns, j, jb, jb2, jj, jj1, jp1, &
   & jstart, kflag, l, maxord, meth, miter, n, nfe, nje, nq, nqu, nst
real :: rownd, rowns, el0, h, hmin, hmxi, hu, tn, uround, c, r, s, &
   & tp
common /debdf1/ rownd, rowns(210), &
   & el0, h, hmin, hmxi, hu, tn, uround, iownd(14), iowns(6), &
   & ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
   & nje, nqu
!
iflag = 0
if (k < 0 .or. k > nq) go to 80
tp = tn - hu*(1.0e0 + 100.0e0*uround)
if ((t - tp)*(t - tn) > 0.0e0) go to 90
!
s = (t - tn)/h
ic = 1
if (k == 0) go to 15
jj1 = l - k
do 10 jj = jj1,nq
10 ic = ic*jj
15 c = float(ic)
do 20 i = 1,n
20 dky(i) = c*yh(i,l)
if (k == nq) go to 55
jb2 = nq - k
do jb = 1,jb2
   j = nq - jb
   jp1 = j + 1
   ic = 1
   if (k == 0) go to 35
   jj1 = jp1 - k
   do 30 jj = jj1,j
30    ic = ic*jj
35 c = float(ic)
   do 40 i = 1,n
40    dky(i) = c*yh(i,jp1) + s*dky(i)
end do
if (k == 0) return
55 r = h**(-k)
do 60 i = 1,n
60 dky(i) = r*dky(i)
return
!
80 iflag = -1
return
90 iflag = -2
return
!----------------------- End of subroutine intyd -----------------------
end subroutine intyd

subroutine stod(neq, y, yh, nyh, yh1, ewt, savf, acor, &
   & wm, iwm, f, jac, rpar, ipar)
implicit none
integer :: ipar(*)
real :: rpar(*)
external f, jac
integer :: neq, nyh, iwm(*)
real :: y(*), yh(nyh,*), yh1(*), ewt(*), savf(*), acor(*), wm(*)
integer :: ipnyh
integer :: iod, ksteps
integer :: i, i1, ialth, ier, iownd, iredo, iret, ipup, j, jb, &
   & jstart, kflag, l, lmax, m, maxord, meo, meth, miter, n, ncf, newq, &
   & nfe, nje, nq, nqnyh, nqu, nst, nstepj
real :: rownd, conit, crate, el, elco, hold, rc, rmax, tesco, el0, &
   & h, hmin, hmxi, hu, tn, uround, dcon, ddn, del, delp, dsm, dup, &
   & exdn, exsm, exup, r, rh, rhdn, rhsm, rhup, told, vnwrms
!-----------------------------------------------------------------------
! stod  performs one step of the integration of an initial value
! problem for a system of ordinary differential equations.
! Note.. stod  is independent of the value of the iteration method
! indicator miter, when this is .NE. 0, and hence is independent
! of the type of chord method used, or the Jacobian structure.
! Communication with stod  is done with the following variables..
!
! y      = An array of length .GE. N used as the y argument in
!          all calls to F and JAC.
! neq    = Integer array containing problem size in neq(1), and
!          passed as the neq argument in all calls to F and JAC.
! yh     = An nyh by LMAX array containing the dependent variables
!          and their approximate scaled derivatives, where
!          LMAX = MAXORD + 1.  yh(i,j+1) contains the approximate
!          j-TH derivative of y(i), scaled by H**j/factorial(j)
!          (j = 0,1,...,NQ).  On entry for the first step, the first
!          two columns of yh must be set from the initial values.
! nyh    = A constant integer .GE. N, the first dimension of yh.
! yh1    = A one-dimensional array occupying the same space as yh.
! ewt    = An array of N elements with which the estimated local
!          errors in yh are compared.
! savf   = An array of working storage, of length N.
! acor   = A work array of length N, used for the accumulated
!          corrections.  On a successful return, acor(i) contains
!          the estimated one-step local error in y(i).
! wm,iwm = Real and integer work arrays associated with matrix
!          operations in chord iteration (miter .NE. 0).
! pjac   = Name of routine to evaluate and preprocess Jacobian matrix
!          if a chord method is being used.
! slvs   = Name of routine to solve linear system in chord iteration.
! H      = The step size to be attempted on the next step.
!          H is altered by the error control algorithm during the
!          problem.  H can be either positive or negative, but its
!          sign must remain constant throughout the problem.
! HMIN   = The minimum absolute value of the step size H to be used.
! HMXI   = Inverse of the maximum absolute value of H to be used.
!          HMXI = 0.0 is allowed and corresponds to an infinite HMAX.
!          HMIN and HMXI may be changed at any time, but will not
!          take effect until the next change of H is considered.
! TN     = The independent variable. TN is updated on each step taken.
! JSTART = An integer used for input only, with the following
!          values and meanings..
!               0  Perform the first step.
!           .GT.0  take a new step continuing from the last.
!              -1  Take the next step with a new value of H, MAXORD,
!                    N, meth, miter, and/or matrix parameters.
!              -2  Take the next step with a new value of H,
!                    but with other inputs unchanged.
!          On return, JSTART is set to 1 to facilitate continuation.
! KFLAG  = A completion code with the following meanings..
!               0  The step was succesful.
!              -1  The requested error could not be achieved.
!              -2  Corrector convergence could not be achieved.
!          A return with KFLAG = -1 Or -2 Means either
!          abs(H) = HMIN or 10 consecutive failures occurred.
!          On a return with KFLAG negative, the values of TN and
!          the yh array are as of the beginning of the last
!          step, and H is the last step size attempted.
! MAXORD = The maximum order of integration method to be allowed.
! Meth/miter = The method flags.  See description in driver.
! N      = The number of first-order differential equations.
!-----------------------------------------------------------------------
!***Routines called  cfod,slvs,pjac,vnwrms
!
!
common /debdf1/ rownd, conit, crate, el(13), elco(13,12), &
   & hold, rc, rmax, tesco(3,12), &
   & el0, h, hmin, hmxi, hu, tn, uround, iownd(7), ksteps, iod(6), &
   & ialth, ipup, lmax, meo, nqnyh, nstepj, &
   & ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
   & nje, nqu
!
!
kflag = 0
told = tn
ncf = 0
if (jstart > 0) go to 200
if (jstart == -1) go to 100
if (jstart == -2) go to 160
!-----------------------------------------------------------------------
! On the first call, the order is set to 1, and other variables are
! initialized.  rmax is the maximum ratio by which H can be increased
! in a single step.  It is initially 1.E4 to compensate for the small
! initial H, but then is normally equal to 10.  If a failure
! occurs (in corrector convergence or error test), rmax is set at 2
! for the next increase.
!-----------------------------------------------------------------------
lmax = maxord + 1
nq = 1
l = 2
ialth = 2
rmax = 10000.0e0
rc = 0.0e0
el0 = 1.0e0
crate = 0.7e0
delp = 0.0e0
hold = h
meo = meth
nstepj = 0
iret = 3
go to 140
!-----------------------------------------------------------------------
! The following block handles preliminaries needed when JSTART = -1.
! ipup is set to miter to force a matrix update.
! If an order increase is about to be considered (ialth = 1),
! ialth is reset to 2 to postpone consideration one more step.
! If the caller has changed meth, cfod  is called to reset
! the coefficients of the method.
! If the caller has changed MAXORD to a value less than the current
! order NQ, NQ is reduced to MAXORD, and a new H chosen accordingly.
! If H is to be changed, yh must be rescaled.
! If H or meth is being changed, ialth is reset to L = NQ + 1
! to prevent further changes in H for that many steps.
!-----------------------------------------------------------------------
100 ipup = miter
lmax = maxord + 1
if (ialth == 1) ialth = 2
if (meth == meo) go to 110
call cfod(meth, elco, tesco)
meo = meth
if (nq > maxord) go to 120
ialth = l
iret = 1
go to 150
110 if (nq <= maxord) go to 160
120 nq = maxord
l = lmax
do 125 i = 1,l
125 el(i) = elco(i,nq)
nqnyh = nq*nyh
rc = rc*el(1)/el0
el0 = el(1)
conit = 0.5e0/float(nq + 2)
ddn = vnwrms(n, savf, ewt)/tesco(1,l)
exdn = 1.0e0/float(l)
rhdn = 1.0e0/(1.3e0*ddn**exdn + 0.0000013e0)
rh = min(rhdn,1.0e0)
iredo = 3
if (h == hold) go to 170
rh = min(rh,abs(h/hold))
h = hold
go to 175
!-----------------------------------------------------------------------
! cfod  is called to get all the integration coefficients for the
! current meth.  Then the el vector and related constants are reset
! whenever the order NQ is changed, or at the start of the problem.
!-----------------------------------------------------------------------
140 call cfod(meth, elco, tesco)
150 do 155 i = 1,l
155 el(i) = elco(i,nq)
nqnyh = nq*nyh
rc = rc*el(1)/el0
el0 = el(1)
conit = 0.5e0/float(nq + 2)
go to (160, 170, 200), iret
!-----------------------------------------------------------------------
! If H is being changed, the H ratio RH is checked against
! rmax, HMIN, and HMXI, and the yh array rescaled.  ialth is set to
! L = NQ + 1 to prevent a change of H for that many steps, unless
! forced by a convergence or error test failure.
!-----------------------------------------------------------------------
160 if (h == hold) go to 200
rh = h/hold
h = hold
iredo = 3
go to 175
170 rh = max(rh,hmin/abs(h))
175 rh = min(rh,rmax)
rh = rh/max(1.0e0,abs(h)*hmxi*rh)
r = 1.0e0
do 180 j = 2,l
   r = r*rh
   do 180 i = 1,n
180   yh(i,j) = yh(i,j)*r
h = h*rh
rc = rc*rh
ialth = l
if (iredo == 0) go to 680
!-----------------------------------------------------------------------
! This section computes the predicted values by effectively
! multiplying the yh array BY the Pascal triangle matrix.
! rc is the ratio of new to old values of the coefficient  H*el(1).
! When rc differs from 1 by more than 30 percent, ipup is set to miter
! to force pjac to be called, if a Jacobian is involved.
! In any case, pjac is called at least every 20-TH step.
!-----------------------------------------------------------------------
200 if (abs(rc - 1.0e0) > 0.3e0) ipup = miter
if (nst >= nstepj + 20) ipup = miter
tn = tn + h
i1 = nqnyh + 1
do jb = 1,nq
   i1 = i1 - nyh
   do 210 i = i1,nqnyh
      ipnyh = i + nyh
210   yh1(i) = yh1(i) + yh1(ipnyh)
end do
ksteps = ksteps + 1
!-----------------------------------------------------------------------
! Up to 3 corrector iterations are taken.  A convergence test is
! made on the R.M.S. norm of each correction, weighted by the error
! weight vector ewt.  The sum of the corrections is accumulated in the
! vector acor(i).  The yh array is not altered in the corrector loop.
!-----------------------------------------------------------------------
220 m = 0
do 230 i = 1,n
230 y(i) = yh(i,1)
call f(tn, y, savf, rpar, ipar)
nfe = nfe + 1
if (ipup <= 0) go to 250
!-----------------------------------------------------------------------
! If indicated, the matrix P = i - H*el(1)*j is reevaluated and
! preprocessed before starting the corrector iteration.  ipup is set
! to 0 as an indicator that this has been done.
!-----------------------------------------------------------------------
ipup = 0
rc = 1.0e0
nstepj = nst
crate = 0.7e0
call pjac(neq, y, yh, nyh, ewt, acor, savf, wm, iwm, f, jac, &
   & rpar, ipar)
if (ier /= 0) go to 430
250 do 260 i = 1,n
260 acor(i) = 0.0e0
270 if (miter /= 0) go to 350
!-----------------------------------------------------------------------
! In the case of functional iteration, update y directly from
! the result of the last function evaluation.
!-----------------------------------------------------------------------
do 290 i = 1,n
   savf(i) = h*savf(i) - yh(i,2)
290 y(i) = savf(i) - acor(i)
del = vnwrms(n, y, ewt)
do 300 i = 1,n
   y(i) = yh(i,1) + el(1)*savf(i)
300 acor(i) = savf(i)
go to 400
!-----------------------------------------------------------------------
! In the case of the chord method, compute the corrector error,
! and solve the linear system with that as right-hand side and
! P as coefficient matrix.
!-----------------------------------------------------------------------
350 do 360 i = 1,n
360 y(i) = h*savf(i) - (yh(i,2) + acor(i))
call slvs(wm, iwm, y, savf)
if (ier /= 0) go to 410
del = vnwrms(n, y, ewt)
do 380 i = 1,n
   acor(i) = acor(i) + y(i)
380 y(i) = yh(i,1) + el(1)*acor(i)
!-----------------------------------------------------------------------
! Test for convergence.  If M.GT.0, an estimate of the convergence
! rate constant is stored in crate, and this is used in the test.
!-----------------------------------------------------------------------
400 if (m /= 0) crate = max(0.2e0*crate,del/delp)
dcon = del*min(1.0e0,1.5e0*crate)/(tesco(2,nq)*conit)
if (dcon <= 1.0e0) go to 450
m = m + 1
if (m == 3) go to 410
if (m >= 2 .and. del > 2.0e0*delp) go to 410
delp = del
call f(tn, y, savf, rpar, ipar)
nfe = nfe + 1
go to 270
!-----------------------------------------------------------------------
! The corrector iteration failed to converge in 3 tries.
! If miter .NE. 0 and the Jacobian is out of date, pjac is called for
! the next try.  Otherwise the yh array is retracted to its values
! before prediction, and H is reduced, if possible.  If H cannot be
! reduced or 10 failures have occurred, exit with KFLAG = -2.
!-----------------------------------------------------------------------
410 if (ipup == 0) go to 430
ipup = miter
go to 220
430 tn = told
ncf = ncf + 1
rmax = 2.0e0
i1 = nqnyh + 1
do jb = 1,nq
   i1 = i1 - nyh
   do 440 i = i1,nqnyh
      ipnyh = i + nyh
440   yh1(i) = yh1(i) - yh1(ipnyh)
end do
if (abs(h) <= hmin*1.00001e0) go to 670
if (ncf == 10) go to 670
rh = 0.25e0
ipup = miter
iredo = 1
go to 170
!-----------------------------------------------------------------------
! The corrector has converged.  ipup is set to -1 If miter .NE. 0,
! to signal that the Jacobian involved may need updating later.
! The local error test is made and control passes to statement 500
! if it fails.
!-----------------------------------------------------------------------
450 if (miter /= 0) ipup = -1
if (m == 0) dsm = del/tesco(2,nq)
if (m > 0) dsm = vnwrms(n, acor, ewt)/tesco(2,nq)
if (dsm > 1.0e0) go to 500
!-----------------------------------------------------------------------
! After a successful step, update the yh array.
! Consider changing H if ialth = 1.  Otherwise decrease ialth by 1.
! If ialth is then 1 and NQ .LT. MAXORD, then acor is saved for
! use in a possible order increase on the next step.
! If a change in H is considered, an increase or decrease in order
! by one is considered also.  A change in H is made only if it is by A
! factor of at least 1.1.  If not, ialth is set to 3 to prevent
! testing for that many steps.
!-----------------------------------------------------------------------
kflag = 0
iredo = 0
nst = nst + 1
hu = h
nqu = nq
do 470 j = 1,l
   do 470 i = 1,n
470   yh(i,j) = yh(i,j) + el(j)*acor(i)
ialth = ialth - 1
if (ialth == 0) go to 520
if (ialth > 1) go to 690
if (l == lmax) go to 690
do 490 i = 1,n
490 yh(i,lmax) = acor(i)
go to 690
!-----------------------------------------------------------------------
! The error test failed.  KFLAG keeps track of multiple failures.
! Restore TN and the yh array to their previous values, and prepare
! to try the step again.  Compute the optimum step size for this or
! one lower order.  After 2 or more failures, H is forced to decrease
! by a factor of 0.2 or less.
!-----------------------------------------------------------------------
500 kflag = kflag - 1
tn = told
i1 = nqnyh + 1
do jb = 1,nq
   i1 = i1 - nyh
   do 510 i = i1,nqnyh
      ipnyh = i + nyh
510   yh1(i) = yh1(i) - yh1(ipnyh)
end do
rmax = 2.0e0
if (abs(h) <= hmin*1.00001e0) go to 660
if (kflag <= -3) go to 640
iredo = 2
rhup = 0.0e0
go to 540
!-----------------------------------------------------------------------
! Regardless of the success or failure of the step, factors
! RHDN, RHSM, and RHUP are computed, by which H could be multiplied
! at order NQ - 1, order NQ, or order NQ + 1, respectively.
! In the case of failure, RHUP = 0.0 to avoid an order increase.
! The largest of these is determined and the new order chosen
! accordingly.  If the order is to be increased, we compute one
! additional scaled derivative.
!-----------------------------------------------------------------------
520 rhup = 0.0e0
if (l == lmax) go to 540
do 530 i = 1,n
530 savf(i) = acor(i) - yh(i,lmax)
dup = vnwrms(n, savf, ewt)/tesco(3,nq)
exup = 1.0e0/float(l + 1)
rhup = 1.0e0/(1.4e0*dup**exup + 0.0000014e0)
540 exsm = 1.0e0/float(l)
rhsm = 1.0e0/(1.2e0*dsm**exsm + 0.0000012e0)
rhdn = 0.0e0
if (nq == 1) go to 560
ddn = vnwrms(n, yh(1,l), ewt)/tesco(1,nq)
exdn = 1.0e0/float(nq)
rhdn = 1.0e0/(1.3e0*ddn**exdn + 0.0000013e0)
560 if (rhsm >= rhup) go to 570
if (rhup > rhdn) go to 590
go to 580
570 if (rhsm < rhdn) go to 580
newq = nq
rh = rhsm
go to 620
580 newq = nq - 1
rh = rhdn
if (kflag < 0 .and. rh > 1.0e0) rh = 1.0e0
go to 620
590 newq = l
rh = rhup
if (rh < 1.1e0) go to 610
r = el(l)/float(l)
do 600 i = 1,n
600 yh(i,newq + 1) = acor(i)*r
go to 630
610 ialth = 3
go to 690
620 if ((kflag == 0) .and. (rh < 1.1e0)) go to 610
if (kflag <= -2) rh = min(rh,0.2e0)
!-----------------------------------------------------------------------
! If there is a change of order, reset NQ, L, and the coefficients.
! In any case H is reset according to RH and the yh array is rescaled.
! Then exit from 680 if the step was OK, or redo the step otherwise.
!-----------------------------------------------------------------------
if (newq == nq) go to 170
630 nq = newq
l = nq + 1
iret = 2
go to 150
!-----------------------------------------------------------------------
! Control reaches this section if 3 or more failures have occured.
! If 10 failures have occurred, exit with KFLAG = -1.
! It is assumed that the derivatives that have accumulated in the
! yh array have errors of the wrong order.  Hence the first
! derivative is recomputed, and the order is set to 1.  Then
! H is reduced by a factor of 10, and the step is retried,
! until it succeeds or H reaches HMIN.
!-----------------------------------------------------------------------
640 if (kflag == -10) go to 660
rh = 0.1e0
rh = max(hmin/abs(h),rh)
h = h*rh
do 645 i = 1,n
645 y(i) = yh(i,1)
call f(tn, y, savf, rpar, ipar)
nfe = nfe + 1
do 650 i = 1,n
650 yh(i,2) = h*savf(i)
ipup = miter
ialth = 5
if (nq == 1) go to 200
nq = 1
l = 2
iret = 3
go to 150
!-----------------------------------------------------------------------
! All returns are made through this section.  H is saved in hold
! to allow the caller to change H on the next step.
!-----------------------------------------------------------------------
660 kflag = -1
go to 700
670 kflag = -2
go to 700
680 rmax = 10.0e0
690 r = 1.0e0/tesco(2,nqu)
do 695 i = 1,n
695 acor(i) = acor(i)*r
700 hold = h
jstart = 1
return
!----------------------- End of subroutine stod  -----------------------
end subroutine stod

pure subroutine cfod(meth, elco, tesco)
implicit none
!
!   cfod defines coefficients needed in the integrator package sfode
!
integer, intent(in) :: meth
real, intent(inout) :: elco(13, *), tesco(3, *)
integer :: i, ib, nq, nqm1, nqp1
real :: agamq, fnq, fnqm1, pc(12), pint, ragq, rqfac, rq1fac, &
   & tsign, xpin
!-----------------------------------------------------------------------
! cfod  is called by the integrator routine to set coefficients
! needed there.  The coefficients for the current method, as
! given by the value of meth, are set for all orders and saved.
! The maximum order assumed here is 12 if meth = 1 And 5 if meth = 2.
! (A smaller value of the maximum order is also allowed.)
! cfod  is called once at the beginning of the problem,
! and is not called again unless and until meth is changed.
!
! The elco array contains the BASIC method coefficients.
! The coefficients EL(i), 1 .LE. i .LE. nq+1, for the method of
! order nq are stored in elco(i,nq).  They are given by a genetrating
! POLYNOMIAL, I.E.,
!     l(x) = el(1) + el(2)*x + ... + el(nq+1)*x**nq.
! For the implicit Adams methods, L(X) is given by
!     DL/DX = (X+1)*(X+2)*...*(X+nq-1)/FACTORIAL(nq-1),    L(-1) = 0.
! For the BDF methods, L(X) is given by
!     l(x) = (x+1)*(x+2)* ... *(x+nq)/k,
! WHERE         K = FACTORIAL(nq)*(1 + 1/2 + ... + 1/nq).
!
! The tesco array contains test constants used for the
! local error test and the selection of step size and/or order.
! At order nq, tesco(K,nq) is used for the selection of step
! size at order nq - 1 If K = 1, at order nq if K = 2, and at order
! nq + 1 IF K = 3.
!-----------------------------------------------------------------------
!
go to (100, 200), meth
!
100 elco(1,1) = 1.0e0
elco(2,1) = 1.0e0
tesco(1,1) = 0.0e0
tesco(2,1) = 2.0e0
tesco(1,2) = 1.0e0
tesco(3,12) = 0.0e0
pc(1) = 1.0e0
rqfac = 1.0e0
do nq = 2,12
!-----------------------------------------------------------------------
! The PC array will contain the coefficients of the polynomial
!     p(x) = (x+1)*(x+2)*...*(x+nq-1).
! INITIALLY, P(X) = 1.
!-----------------------------------------------------------------------
   rq1fac = rqfac
   rqfac = rqfac/float(nq)
   nqm1 = nq - 1
   fnqm1 = float(nqm1)
   nqp1 = nq + 1
! Form coefficients of P(X)*(X+nq-1). ----------------------------------
   pc(nq) = 0.0e0
   do 110 ib = 1,nqm1
      i = nqp1 - ib
110   pc(i) = pc(i - 1) + fnqm1*pc(i)
   pc(1) = fnqm1*pc(1)
! Compute integral, -1 To 0, of P(X) and X*P(X). -----------------------
   pint = pc(1)
   xpin = pc(1)/2.0e0
   tsign = 1.0e0
   do 120 i = 2,nq
      tsign = -tsign
      pint = pint + tsign*pc(i)/float(i)
120   xpin = xpin + tsign*pc(i)/float(i + 1)
! Store coefficients in elco and tesco. --------------------------------
   elco(1,nq) = pint*rq1fac
   elco(2,nq) = 1.0e0
   do 130 i = 2,nq
130   elco(i + 1,nq) = rq1fac*pc(i)/float(i)
   agamq = rqfac*xpin
   ragq = 1.0e0/agamq
   tesco(2,nq) = ragq
   if (nq < 12) tesco(1,nqp1) = ragq*rqfac/float(nqp1)
   tesco(3,nqm1) = ragq
end do
return
!
200 pc(1) = 1.0e0
rq1fac = 1.0e0
do nq = 1,5
!-----------------------------------------------------------------------
! The PC array will contain the coefficients of the polynomial
!     p(x) = (x+1)*(x+2)*...*(x+nq).
! INITIALLY, P(X) = 1.
!-----------------------------------------------------------------------
   fnq = float(nq)
   nqp1 = nq + 1
! Form coefficients of P(X)*(X+nq). ------------------------------------
   pc(nqp1) = 0.0e0
   do 210 ib = 1,nq
      i = nq + 2 - ib
210   pc(i) = pc(i - 1) + fnq*pc(i)
   pc(1) = fnq*pc(1)
! Store coefficients in elco and tesco. --------------------------------
   do 220 i = 1,nqp1
220   elco(i,nq) = pc(i)/pc(2)
   elco(2,nq) = 1.0e0
   tesco(1,nq) = rq1fac
   tesco(2,nq) = float(nqp1)/elco(1,nq)
   tesco(3,nq) = float(nq + 2)/elco(1,nq)
   rq1fac = rq1fac/fnq
end do
return
!----------------------- End of subroutine cfod  -----------------------
end subroutine cfod

subroutine pjac(neq, y, yh, nyh, ewt, ftem, savf, wm, iwm, &
   & f, jac, rpar, ipar)
implicit none
integer :: ipar(*)
real :: rpar(*)
integer :: neq, nyh, iwm( *)
external f, jac
real :: y(*), yh(nyh,*), ewt(*), ftem(*), savf(*), wm(*)
integer :: i, i1, i2, ier, ii, iownd, iowns, j, j1, jj, jstart, &
   & kflag, l, lenp, maxord, mba, mband, meb1, meband, meth, miter, ml, &
   & ml3, mu, n, nfe, nje, nq, nqu, nst
real :: rownd, rowns, el0, h, hmin, hmxi, hu, tn, uround, con, di, &
   & fac, hl0, r, r0, srur, yi, yj, yjj, vnwrms
!
!   pjac sets up the iteration matrix (involving the Jacobian) for the
!   integration package sfode.
!
!***Routines called  vnwrms,sgefa,sgbfa
!
common /debdf1/ rownd, rowns(210), &
   & el0, h, hmin, hmxi, hu, tn, uround, iownd(14), iowns(6), &
   & ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
   & nje, nqu
!-----------------------------------------------------------------------
! pjac is called by stod  to compute and process the matrix
! P = i - h*EL(1)*j , where j is an approximation to the Jacobian.
! Here j is computed by the user-supplied routine jac if
! miter = 1 Or 4, or by finite differencing if miter = 2, 3, or 5.
! If miter = 3, a diagonal approximation to j is used.
! j is stored in wm and replaced by P.  if miter .NE. 3, P is then
! subjected to LU decomposition in preparation for later solution
! of linear systems with P as coefficient matrix. This is done
! by sgefa if miter = 1 Or 2, and by sgbfa if miter = 4 Or 5.
!
! In addition to variables described previously, communication
! with pjac uses the following..
! y    = Array containing predicted values on entry.
! ftem = Work array of length N (ACOR in stod ).
! savf = Array containing F evaluated at predicted y.
! wm   = Real work space for matrices.  On output it contains the
!        inverse diagonal matrix IF miter = 3 And the LU decomposition
!        of P if miter is 1, 2 , 4, or 5.
!        Storage of matrix elements starts at wm(3).
!        wm also contains the following matrix-related data..
!        wm(1) = sqrt(uround), used in numerical Jacobian increments.
!        wm(2) = h*el0, saved for later use if miter = 3.
! iwm  = Integer work space containing pivot information, starting at
!        iwm(21), if miter is 1, 2, 4, or 5.  iwm also contains the
!        band parameters ML = iwm(1) and mu = iwm(2) if miter is 4 or 5.
! el0  = el(1) (input).
! ier  = Output error flag,  = 0 If no trouble, .NE. 0 if
!        P matrix FOUND to be singular.
! This routine also uses the common variables el0, h, tn, uround,
! miter, N, NFE, and NJE.
!-----------------------------------------------------------------------
nje = nje + 1
hl0 = h*el0
go to (100, 200, 300, 400, 500), miter
! If miter = 1, call JAC and multiply by scalar. -----------------------
100 lenp = n*n
do 110 i = 1,lenp
110 wm(i + 2) = 0.0e0
call jac(tn, y, wm(3), n, rpar, ipar)
con = -hl0
do 120 i = 1,lenp
120 wm(i + 2) = wm(i + 2)*con
go to 240
! If miter = 2, make N calls to F to approximate j. --------------------
200 fac = vnwrms(n, savf, ewt)
r0 = 1000.0e0*abs(h)*uround*float(n)*fac
if (r0 == 0.0e0) r0 = 1.0e0
srur = wm(1)
j1 = 2
do j = 1,n
   yj = y(j)
   r = max(srur*abs(yj),r0*ewt(j))
   y(j) = y(j) + r
   fac = -hl0/r
   call f(tn, y, ftem, rpar, ipar)
   do 220 i = 1,n
220   wm(i + j1) = (ftem(i) - savf(i))*fac
   y(j) = yj
   j1 = j1 + n
end do
nfe = nfe + n
! Add identity matrix. -------------------------------------------------
240 j = 3
do 250 i = 1,n
   wm(j) = wm(j) + 1.0e0
250 j = j + (n + 1)
! Do LU decomposition on P. --------------------------------------------
call sgefa(wm(3), n, n, iwm(21), ier)
return
! If miter = 3, construct a diagonal approximation to j and P. ---------
300 wm(2) = hl0
ier = 0
r = el0*0.1e0
do 310 i = 1,n
310 y(i) = y(i) + r*(h*savf(i) - yh(i,2))
call f(tn, y, wm(3), rpar, ipar)
nfe = nfe + 1
do 320 i = 1,n
   r0 = h*savf(i) - yh(i,2)
   di = 0.1e0*r0 - h*(wm(i + 2) - savf(i))
   wm(i + 2) = 1.0e0
   if (abs(r0) < uround*ewt(i)) go to 320
   if (abs(di) == 0.0e0) go to 330
   wm(i + 2) = 0.1e0*r0/di
320 continue
return
330 ier = -1
return
! If miter = 4, call JAC and multiply by scalar. -----------------------
400 ml = iwm(1)
mu = iwm(2)
ml3 = 3
mband = ml + mu + 1
meband = mband + ml
lenp = meband*n
do 410 i = 1,lenp
410 wm(i + 2) = 0.0e0
call jac(tn, y, wm(ml3), meband, rpar, ipar)
con = -hl0
do 420 i = 1,lenp
420 wm(i + 2) = wm(i + 2)*con
go to 570
! If miter = 5, make MBAND calls to F to approximate j. ----------------
500 ml = iwm(1)
mu = iwm(2)
mband = ml + mu + 1
mba = min(mband,n)
meband = mband + ml
meb1 = meband - 1
srur = wm(1)
fac = vnwrms(n, savf, ewt)
r0 = 1000.0e0*abs(h)*uround*float(n)*fac
if (r0 == 0.0e0) r0 = 1.0e0
do j = 1,mba
   do 530 i = j,n,mband
      yi = y(i)
      r = max(srur*abs(yi),r0*ewt(i))
530   y(i) = y(i) + r
   call f(tn, y, ftem, rpar, ipar)
   do jj = j,n,mband
      y(jj) = yh(jj,1)
      yjj = y(jj)
      r = max(srur*abs(yjj),r0*ewt(jj))
      fac = -hl0/r
      i1 = max(jj - mu,1)
      i2 = min(jj + ml,n)
      ii = jj*meb1 - ml + 2
      do 540 i = i1,i2
540      wm(ii + i) = (ftem(i) - savf(i))*fac
   end do
end do
nfe = nfe + mba
! Add identity matrix. -------------------------------------------------
570 ii = mband + 2
do 580 i = 1,n
   wm(ii) = wm(ii) + 1.0e0
580 ii = ii + meband
! Do LU decomposition of P. --------------------------------------------
call sgbfa(wm(3), meband, n, ml, mu, iwm(21), ier)
return
!----------------------- End of subroutine pjac -----------------------
end subroutine pjac

subroutine slvs(wm, iwm, x, tem)
implicit none
!
!   slvs solves the linear system in the iteration scheme for the
!   integrator package sfode.
!
!***Routines called  sgesl,sgbsl
!
integer :: iwm( *)
real :: wm(*), x(*), tem(*)
integer :: i, ier, iownd, iowns, jstart, kflag, l, maxord, meband, &
   & meth, miter, ml, mu, n, nfe, nje, nq, nqu, nst
real :: rownd, rowns, el0, h, hmin, hmxi, hu, tn, uround, di, hl0, &
   & phl0, r
common /debdf1/ rownd, rowns(210), &
   & el0, h, hmin, hmxi, hu, tn, uround, iownd(14), iowns(6), &
   & ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
   & nje, nqu
!-----------------------------------------------------------------------
! This routine manages the solution of the linear system arising from
! a chord iteration.  It is called by stod  if miter .NE. 0.
! If miter is 1 or 2, it calls sgesl to accomplish this.
! If miter = 3 It updates the coefficient h*el0 in the diagonal
! matrix, and then computes the solution.
! If miter is 4 or 5, it calls sgbsl.
! Communication with slvs uses the following variables..
! wm  = Real work space containing the inverse diagonal matrix IF miter
!       is 3 and the LU decomposition of the matrix otherwise.
!       Storage of matrix elements starts at wm(3).
!       wm also contains the following matrix-related data..
!       wm(1) = sqrt(uround) (not used here),
!       wm(2) = hl0, the previous value of h*el0, used if miter = 3.
! iwm = Integer work space containing pivot information, starting at
!       iwm(21), if miter is 1, 2, 4, or 5.  iwm also contains the
!       band parameters ML = iwm(1) and mu = iwm(2) if miter is 4 or 5.
! x   = The right-hand side vector on input, and the solution vector
!       on output, of length N.
! tem = Vector of work space of length N, not used in this version.
! ier = Output flag (in common).  ier = 0 If no trouble occurred.
!       ier = -1 If a singular matrix arose with miter = 3.
! This routine also uses the common variables el0, h, miter, and N.
!-----------------------------------------------------------------------
ier = 0
go to (100, 100, 300, 400, 400), miter
100 call sgesl(wm(3), n, n, iwm(21), x, 0)
return
!
300 phl0 = wm(2)
hl0 = h*el0
wm(2) = hl0
if (hl0 == phl0) go to 330
r = hl0/phl0
do 320 i = 1,n
   di = 1.0e0 - r*(1.0e0 - 1.0e0/wm(i + 2))
   if (abs(di) == 0.0e0) go to 390
320 wm(i + 2) = 1.0e0/di
330 do 340 i = 1,n
340 x(i) = wm(i + 2)*x(i)
return
390 ier = -1
return
!
400 ml = iwm(1)
mu = iwm(2)
meband = 2*ml + mu + 1
call sgbsl(wm(3), meband, n, ml, mu, iwm(21), x, 0)
return
!----------------------- End of subroutine slvs -----------------------
end subroutine slvs

pure subroutine sgbfa(abd,lda,n,ml,mu,ipvt,info)
implicit none
integer, intent(in) :: lda, n, ml, mu
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
real, intent(inout) :: abd(lda,*)
real :: t
integer :: i, i0, j, ju, jz, j0, j1, k, kp1, l, lm, m, mm, nm1
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure subroutine sscal(n,sa,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
   end subroutine sscal
end interface
!
!     sgbfa factors a real band matrix BY elimination.
!
!     sgbfa is usually called by SGBCO, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!
!     On entry
!
!        ABD     real(lda, n)
!                contains the matrix in band storage.  The columns
!                of the matrix are stored in the columns of  abd  and
!                the diagonals of the matrix are stored in rows
!                ml+1 through 2*ml+mu+1 of  abd .
!                See the comments below for details.
!
!        lda     INTEGER
!                the leading dimension of the array  abd .
!                lda MUST BE .GE. 2*ml + mu + 1 .
!
!        n       INTEGER
!                the order of the original matrix.
!
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!                0 .LE. ml .LT. n .
!
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!                0 .LE. mu .LT. n .
!                More efficient if  ml .LE. mu .
!     On return
!
!        ABD     AN UPPER TRIANGULAR MATRIX IN BAND STORAGE AND
!                the multipliers which were used to obtain it.
!                The factorization can be written  A = l*U  where
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                = 0  Normal value.
!                = k  if  U(k,k) .EQ. 0.0 .  this is not an error
!                     condition for this subroutine, but it does
!                     indicate that sgbsl will divide by zero if
!                     called.  Use  RCOND  in SGBCO for a reliable
!                     indication of singularity.
!
!     Band storage
!
!           If  A  is a band matrix, the following program segment
!           will set up the input.
!
!                   ml = (band width below the diagonal)
!                   mu = (band width above the diagonal)
!                   m = ml + mu + 1
!                   do 20 j = 1, n
!                      i1 = max0(1, j-mu)
!                      i2 = min0(n, j+ml)
!                      do 10 i = i1, i2
!                         k = i - j + m
!                         abd(k,j) = a(i,j)
!                10    continue
!                20 continue
!
!           This uses rows  ml+1  through  2*ml+mu+1  of  abd .
!           In addition, the first  ml  rows in  abd  are used for
!           elements generated during the triangularization.
!           The total number of rows needed in  abd  is  2*ml+mu+1 .
!           The  ml+mu by ml+mu  upper left triangle and the
!           ml by ml  lower right triangle are not referenced.
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sscal,isamax
!     FORTRAN MAX0,MIN0
!
!
m = ml + mu + 1
info = 0
!
!     Zero initial fill-in columns
!
j0 = mu + 2
j1 = min(n,m) - 1
if (j1 < j0) go to 30
do jz = j0, j1
   i0 = m + 1 - jz
   do i = i0, ml
      abd(i,jz) = 0.0e0
   end do
end do
30 continue
jz = j1
ju = 0
!
!     Gaussian elimination with partial pivoting
!
nm1 = n - 1
if (nm1 < 1) go to 130
do k = 1, nm1
   kp1 = k + 1
!
!        Zero next fill-in column
!
   jz = jz + 1
   if (jz > n) go to 50
   if (ml < 1) go to 50
   do i = 1, ml
      abd(i,jz) = 0.0e0
   end do
50 continue
!
!        Find l = Pivot index
!
   lm = min(ml,n - k)
   l = isamax(lm + 1,abd(m,k),1) + m - 1
   ipvt(k) = l + k - m
!
!        Zero pivot implies this column already triangularized
!
   if (abd(l,k) == 0.0e0) go to 100
!
!           Interchange if necessary
!
   if (l == m) go to 60
   t = abd(l,k)
   abd(l,k) = abd(m,k)
   abd(m,k) = t
60 continue
!
!           Compute multipliers
!
   t = -1.0e0/abd(m,k)
   call sscal(lm,t,abd(m + 1,k),1)
!
!           Row elimination with column indexing
!
   ju = min(max(ju,mu + ipvt(k)),n)
   mm = m
   if (ju < kp1) go to 90
   do j = kp1, ju
      l = l - 1
      mm = mm - 1
      t = abd(l,j)
      if (l == mm) go to 70
      abd(l,j) = abd(mm,j)
      abd(mm,j) = t
70    continue
      call saxpy(lm,t,abd(m + 1,k),1,abd(mm + 1,j),1)
   end do
90 continue
   go to 110
100 continue
   info = k
110 continue
end do
130 continue
ipvt(n) = n
if (abd(m,n) == 0.0e0) info = n
return
end subroutine sgbfa

pure subroutine sgbsl(abd,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, ipvt(*), job
real, intent(in) :: abd(lda,*)
real, intent(inout) :: b(*)
real :: t
integer :: k, kb, l, la, lb, lm, m, nm1
interface
   pure subroutine saxpy(n,sa,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sa
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine saxpy
   pure function sdot(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(in) :: sy(*)
      integer, intent(in) :: incy
      real :: sdot
   end function sdot
end interface
!
!     sgbsl solves the real band system
!     A * X = b  OR  TRANS(A) * X = b
!     using the factors computed by SGBCO or sgbfa.
!
!     On entry
!
!        ABD     real(lda, n)
!                the output from SGBCO or sgbfa.
!
!        lda     INTEGER
!                the leading dimension of the array  abd .
!
!        n       INTEGER
!                the order of the original matrix.
!
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!
!        ipvt    INTEGER(n)
!                the pivot vector from SGBCO or sgbfa.
!
!        b       real(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         To solve  A*X = b ,
!                = Nonzero   to solve  trans(A)*X = b , where
!                            trans(A)  is the transpose.
!
!     On return
!
!        b       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda .  It will not occur if the subroutines are
!        called correctly and if SGBCO has set RCOND .GT. 0.0
!        or sgbfa has set info .EQ. 0 .
!
!     To compute  inverse(A) * C  where  C  is a matrix
!     with  P  columns
!           call sgbco(abd,lda,n,ml,mu,ipvt,rcond,z)
!           if (rcond is too small) go to ...
!           do 10 j = 1, p
!              call sgbsl(abd,lda,n,ml,mu,ipvt,c(1,j),0)
!        10 continue
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS saxpy,sdot
!     FORTRAN MIN0
!
!
m = mu + ml + 1
nm1 = n - 1
if (job /= 0) go to 50
!
!        job = 0 , SOLVE  A * X = b
!        first solve l*Y = b
!
if (ml == 0) go to 30
if (nm1 < 1) go to 30
do k = 1, nm1
   lm = min(ml,n - k)
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 continue
   call saxpy(lm,t,abd(m + 1,k),1,b(k + 1),1)
end do
30 continue
!
!        Now solve  U*X = Y
!
do kb = 1, n
   k = n + 1 - kb
   b(k) = b(k)/abd(m,k)
   lm = min(k,m) - 1
   la = m - lm
   lb = k - lm
   t = -b(k)
   call saxpy(lm,t,abd(la,k),1,b(lb),1)
end do
go to 100
50 continue
!
!        job = NONZERO, SOLVE  TRANS(A) * X = b
!        first solve  trans(U)*Y = b
!
do k = 1, n
   lm = min(k,m) - 1
   la = m - lm
   lb = k - lm
   t = sdot(lm,abd(la,k),1,b(lb),1)
   b(k) = (b(k) - t)/abd(m,k)
end do
!
!        Now solve trans(l)*X = Y
!
if (ml == 0) go to 90
if (nm1 < 1) go to 90
do kb = 1, nm1
   k = n - kb
   lm = min(ml,n - k)
   b(k) = b(k) + sdot(lm,abd(m + 1,k),1,b(k + 1),1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
90 continue
100 continue
return
end subroutine sgbsl

function vnorm(v,ncomp)
implicit none
integer, intent(in) :: ncomp
real :: v(ncomp)
integer :: k
real :: vnorm
!
!     Compute the maximum norm of the vector v(*) of length ncomp and
!     RETURN THE RESULT AS vnorm
!
!
vnorm = 0.
do 10 k = 1,ncomp
10 vnorm = max(vnorm,abs(v(k)))
return
end function vnorm

real function vnwrms(n, v, w)
implicit none
!-----------------------------------------------------------------------
! This function routine computes the weighted root-mean-square norm
! of the vector of length n contained in the array v, with weights
! contained in the array w of length n..
!   vnwrms = sqrt( (1/n) * sum( v(i)/w(i) )**2 )
!-----------------------------------------------------------------------
integer, intent(in) :: n
real :: v(n), w(n)
integer :: i
real :: sum
!
sum = 0.0e0
do 10 i = 1,n
10 sum = sum + (v(i)/w(i))**2
vnwrms = sqrt(sum/float(n))
return
!----------------------- End of function vnwrms ------------------------
end function vnwrms

subroutine rk(n,t,h,a,f)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(*)
real, intent(in) :: h
real, intent(inout) :: t
external f
integer :: k, m, m1, mk, nk, np1
real :: ha, ta
!     ******************************************************************
!     Fourth order Runge-Kutta procedure for solving DY=F(t,Y)
!     ******************************************************************
np1 = n + 1
if (h == 0.0) go to 50
!
ha = .5*h
ta = t + ha
m = n + n
m1 = m + 1
!
do 10 k = 1,n
   nk = n + k
   mk = m + k
   a(nk) = ha*a(nk)
10 a(mk) = a(k) + a(nk)
call f(ta,a(m1))
!
do 20 k = 1,n
   nk = n + k
   mk = m + k
   a(nk) = a(nk) + h*a(mk)
20 a(mk) = a(k) + ha*a(mk)
call f(ta,a(m1))
!
t = t + h
do 30 k = 1,n
   nk = n + k
   mk = m + k
   a(mk) = h*a(mk)
   a(nk) = a(nk) + a(mk)
30 a(mk) = a(k) + a(mk)
call f(t,a(m1))
!
do 40 k = 1,n
   nk = n + k
   mk = m + k
   a(k) = a(k) + (a(nk) + ha*a(mk))/3.0
40 a(nk) = a(k)
call f(t,a(np1))
return
!
50 do 51 k = 1,n
   nk = n + k
51 a(nk) = a(k)
call f(t,a(np1))
return
end subroutine rk

subroutine rk8(n,t,h,y,dy,w,f)
implicit none
integer, intent(in) :: n
real :: h
real, intent(inout) :: t
real, intent(inout) :: y(n), dy(n), w(*)
external f
integer :: i, j, k, l, m, m1
real :: ha, sum
real :: b(8,7)
real, parameter :: a(7) = [.3333333333333333, .5, .6666666666666666, .1666666666666666, 1., .8333333333333333, 1.]
real, parameter :: c(7) = [12., 8., 54., 4320., 20., 288., 820.]
real, parameter :: d(9) = [41., 0., 27., 272., 27., 216., 0., 216., 41.]
!     ******************************************************************
!     Eighth order Runge-Kutta procedure for solving dy=F(t,y)
!     ******************************************************************
!     -------------------
data b(1,1)/1./,  b(2,1)/3./
data b(1,2)/1./,  b(2,2)/0./,  b(3,2)/3./
data b(1,3)/13./,  b(2,3)/-27./,  b(3,3)/42./,  b(4,3)/8./
data b(1,4)/389./,  b(2,4)/-54./,  b(3,4)/966./,  b(4,4)/-824./, &
   & b(5,4)/243./
data b(1,5)/-231./,  b(2,5)/81./,  b(3,5)/-1164./,  b(4,5)/656./, &
   & b(5,5)/-122./,  b(6,5)/800./
data b(1,6)/-127./,  b(2,6)/18./,  b(3,6)/-678./,  b(4,6)/456./, &
   & b(5,6)/-9./,  b(6,6)/576./,  b(7,6)/4./
data b(1,7)/1481./,  b(2,7)/-81./,  b(3,7)/7104./, &
   & b(4,7)/-3376./,  b(5,7)/72./,  b(6,7)/-5040./, &
   & b(7,7)/-60./,  b(8,7)/720./
!     -------------------
if (h == 0.) go to 40
ha = h*4./27.
do 10 k = 1,n
10 w(k) = y(k) + ha*dy(k)
call f(t + ha,w(1))
do 11 k = 1,n
11 w(k) = y(k) + h*(dy(k)/18. + w(k)/6.)
call f(t + h*2./9.,w(1))
!
i = 1
do 22 m = 2,8
   i = i + n
   m1 = m - 1
   do 21 k = 1,n
      sum = b(1,m1)*dy(k)
      l = k
      do 20 j = 2,m
         sum = sum + b(j,m1)*w(l)
20       l = l + n
21    w(l) = y(k) + sum*h/c(m1)
22 call f(t + a(m1)*h,w(i))
!
do 31 k = 1,n
   sum = d(1)*dy(k)
   l = k
   do 30 m = 2,9
      sum = sum + d(m)*w(l)
30    l = l + n
   y(k) = y(k) + h*sum/840.
31 dy(k) = y(k)
t = t + h
call f(t,dy)
return
!
40 do 41 k = 1,n
41 dy(k) = y(k)
call f(t,dy)
return
end subroutine rk8

subroutine sepde(cofx, cofy, g, edge, bval, iord, a, b, mp1, &
   & c, d, np1, u, ku, w, nw, ierr)
implicit none
integer, intent(inout) :: ierr
integer :: iord, ku, mp1
integer, intent(in) :: np1
integer, intent(inout) :: nw
real :: a, b, c, d
real :: g
real :: bval
real, intent(inout) :: u(ku,np1), w(nw)
integer, intent(in) :: edge(4)
external cofx, cofy
integer :: i, ia, ib, ic, id, ij, imax, imin, indx, indy, iw, j, &
   & jcol, jmax, jmin, l, m, mn, n
real :: alpha, beta, del, gam, hx, hy, p, xi, xmin, yj, ymin
real :: dum(1)
! ----------------------------------------------------------------------
!     Solution of separable elliptic partial differential equations
!                     on rectangular domains
! ----------------------------------------------------------------------
!     --------------
data alpha/0.0/, beta/0.0/, gam/0.0/, del/0.0/
!     --------------
call pdedge(edge, indx, indy, ierr)
if (ierr /= 0) return
!
if (a >= b .or. c >= d) go to 300
if (mp1 < 7) go to 320
if (np1 < 6) go to 330
m = mp1 - 1
n = np1 - 1
hx = (b - a)/float(m)
hy = (d - c)/float(n)
!
!     Define the maximum and minimum row and column
!     that is needed for the right-hand side matrix
!
xmin = a
ymin = c
imin = 1
imax = mp1
jmin = 1
jmax = np1
jcol = 0
if (edge(1) /= 0) go to 10
jmin = 2
ymin = c + hy
jcol = mp1
10 if (edge(2) /= 0) go to 20
imin = 2
xmin = a + hx
20 if (edge(3) == 0) jmax = n
if (edge(4) == 0) imax = m
!
!     Define the right-hand side matrix for iord = 2
!
if (ku < mp1) go to 310
if (iord /= 2) go to 40
mn = 0
!
yj = ymin
do 31 j = jmin,jmax
   xi = xmin
   do 30 i = imin,imax
      u(i,j) = g(xi, yj)
30    xi = xi + hx
31 yj = yj + hy
go to 60
!
!     Define the right-hand side matrix for iord = 4
!
40 if (iord /= 4) go to 340
mn = mp1*np1
if (mn >= nw) go to 100
!
yj = ymin
do 51 j = jmin,jmax
   xi = xmin
   do 50 i = imin,imax
      ij = i + jcol
      w(ij) = g(xi, yj)
50    xi = xi + hx
   yj = yj + hy
51 jcol = jcol + mp1
!
!     Store the boundary values of u
!
60 if (edge(1) /= 0) go to 70
xi = a
do 61 i = 1,mp1
   u(i,1) = bval(1,xi,c)
61 xi = xi + hx
!
70 if (edge(2) /= 0) go to 80
yj = c
do 71 j = 1,np1
   u(1,j) = bval(2,a,yj)
71 yj = yj + hy
!
80 if (edge(3) /= 0) go to 90
xi = a
do 81 i = 1,mp1
   u(i,np1) = bval(3,xi,d)
81 xi = xi + hx
!
90 if (edge(4) /= 0) go to 100
yj = c
do 91 j = 1,np1
   u(mp1,j) = bval(4,b,yj)
91 yj = yj + hy
!
!     Store the mixed boundary conditions
!
100 ic = mn + 1
if (edge(1) /= 1) go to 120
mn = mn + mp1
if (mn >= nw) go to 120
!
xi = a
l = ic
do i = 1,mp1
   w(l) = bval(1,xi,c)
   xi = xi + hx
   l = l + 1
end do
!
120 ia = mn + 1
if (edge(2) /= 1) go to 140
mn = mn + np1
if (mn >= nw) go to 140
!
yj = c
l = ia
do j = 1,np1
   w(l) = bval(2,a,yj)
   yj = yj + hy
   l = l + 1
end do
!
140 id = mn + 1
if (edge(3) /= 1) go to 160
mn = mn + mp1
if (mn >= nw) go to 160
!
xi = a
l = id
do i = 1,mp1
   w(l) = bval(3,xi,d)
   xi = xi + hx
   l = l + 1
end do
!
160 ib = mn + 1
if (edge(4) /= 1) go to 200
mn = mn + np1
if (mn >= nw) go to 200
!
yj = c
l = ib
do j = 1,np1
   w(l) = bval(4,b,yj)
   yj = yj + hy
   l = l + 1
end do
!
!     CALL THE DIFFERENTIAL EQUATION SOLVER
!
200 if (mn >= nw) go to 350
iw = mn + 1
w(iw) = nw - mn
if (iord == 4) go to 210
!
call sepell(0, iord, a, b, m, indx, w(ia), alpha, w(ib), beta, &
   & c, d, n, indy, w(ic), gam, w(id), del, cofx, cofy, &
   & u, ku, u, ku, w(iw), p, ierr)
go to 220
!
210 call sepell(0, iord, a, b, m, indx, w(ia), alpha, w(ib), beta, &
   & c, d, n, indy, w(ic), gam, w(id), del, cofx, cofy, &
   & w(1),mp1, u, ku, w(iw), p, ierr)
!
220 nw = w(iw) + mn
if (ierr /= 0) return
if (p == 0.0) return
ierr = -1
w(1) = p
return
!
!     Error return
!
300 ierr = 1
return
!
310 ierr = 5
return
!
320 ierr = 6
return
!
330 ierr = 7
return
!
340 ierr = 8
return
!
350 dum(1) = 1.0
call sepell(0, iord, a, b, m, indx, dum, alpha, dum, beta, &
   & c, d, n, indy, dum, gam, dum, del, cofx, cofy, &
   & u, ku, u, ku, dum, p, ierr)
nw = dum(1) + mn
return
end subroutine sepde

pure subroutine pdedge(edge, indx, indy, ierr)
implicit none
integer, intent(inout) :: ierr, indx, indy
integer, intent(in) :: edge(4)
!
if (abs(edge(1)) > 1) go to 200
if (abs(edge(2)) > 1) go to 200
if (abs(edge(3)) > 1) go to 200
if (abs(edge(4)) > 1) go to 200
ierr = 0
!
!               Process edges 1 and 3
!
if (edge(1)) 10,20,30
!
10 if (edge(3) /= -1) go to 210
indy = 0
go to 100
!
20 if (edge(3) == -1) go to 210
indy = 1 + edge(3)
go to 100
!
30 if (edge(3) == -1) go to 210
indy = 4 - edge(3)
!
!               Process edges 2 and 4
!
100 if (edge(2)) 110,120,130
!
110 if (edge(4) /= -1) go to 220
indx = 0
return
!
120 if (edge(4) == -1) go to 220
indx = 1 + edge(4)
return
!
130 if (edge(4) == -1) go to 220
indx = 4 - edge(4)
return
!
!                   Error return
!
200 ierr = 2
return
210 ierr = 12
return
220 ierr = 13
return
end subroutine pdedge

subroutine sepell(intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c, &
   & d,n,nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,grhs,mn, &
   & usol,idmn,w,pertrb,ierror)
implicit none
integer :: idmn
integer, intent(inout) :: ierror
integer :: intl, iorder, m, mbdcnd, mn, n, nbdcnd
real :: a, alpha, b, beta, c, d, gama
real, intent(inout) :: pertrb
real :: xnu
real, intent(inout) :: grhs(mn,*), usol(idmn,*)
real :: bda(*), bdb(*), bdc(*), bdd(*)
real, intent(inout) :: w(*)
external cofx, cofy
integer :: i1, i10, i11, i12, i13, i2, i3, i4, i5, i6, i7, i8, i9, &
   & k, l, length, linput, ll, logb2n, loutpt
!
!
! DIMENSION OF           bda(n+1), bdb(n+1), bdc(m+1), bdd(m+1),
! ARGUMENTS              usol(idmn,n+1), grhs(mn,n+1),
!                        w (see argument list)
!
! LATEST REVISION        JANUARY 1978 (BY THE AUTHORS)
!                        modified 1986 by A.H. Morris (NSWC)
!
! PURPOSE                sepell SOLVES FOR EITHER THE SECOND-ORDER
!                        finite difference approximation or A
!                        fourth-order approximation to a separable
!                        elliptic equation
!
!                                    2    2
!                             AF(X)*d U/DX + BF(X)*DU/DX  + CF(X)*U +
!                                    2    2
!                             DF(Y)*d U/DY  + EF(Y)*DU/DY + FF(Y)*U
!
!                             = G(X,Y)
!
!                        On a rectangle (X greater than or equal to A
!                        and less than or equal to b, Y greater than
!                        or equal to c and less than or equal to d).
!                        Any combination of periodic or mixed boundary
!                        conditions is allowed.
!
! PURPOSE                THE POSSIBLE BOUNDARY CONDITIONS ARE ...
!                        In the X-direction..
!                         (0) Periodic, U(X+b-a,Y)=U(X,Y) for all Y,X
!                         (1) U(a,Y), U(b,Y) are specified for all Y
!                         (2) U(a,Y), DU(b,Y)/DX+beta*U(b,Y) are
!                             specified for all Y
!                         (3) DU(a,Y)/DX+alpha*U(a,Y),DU(b,Y)/DX+
!                             beta*U(b,Y) are specified for all Y
!                         (4) DU(a,Y)/DX+alpha*U(a,Y),U(b,Y) are
!                             specified for all Y
!
!                        In the Y-direction..
!                         (0) Periodic, U(X,Y+d-c)=U(X,Y) for all X,Y
!                         (1) U(X,c),U(X,d) are specified for all X
!                         (2) U(X,c),DU(X,d)/DY+xnu*U(X,d) are specified
!                             for all X
!                         (3) DU(X,c)/DY+gama*U(X,c),DU(X,d)/DY+
!                             xnu*U(X,d) are specified for all X
!                         (4) DU(X,c)/DY+gama*U(X,c),U(X,d) are
!                             specified for all X
!
! Arguments
!
! ON INPUT               INTL
!                          = 0 On initial entry to sepell or if any of
!                              the arguments c, d, n, nbdcnd, COFY are
!                              changed from a previous call
!                          = 1 IF c, d, n, nbdcnd, COFY ARE UNCHANGED
!                              from the previous call.
!
!                        iorder
!                          = 2 If a second-order approximation is sought
!                          = 4 If a fourth-order approximation is sought
!
!                        A,b
!                          the range of the X-independent variable,
!                          I.E., X is greater than or equal to A and
!                          less than or equal to b. A must be less than
!                          b.
!
!                        m
!                          the number of panels into which the interval
!                          (A,b) is subdivided.  Hence, there will be
!                          m+1 grid points in the X-direction given by
!                          XI=a+(I-1)*DLX FOR I=1,2,...,m+1 WHERE
!                          DLX=(b-a)/m is the panel width.  m must be
!                          less than idmn and greater than 5.
!
!                        mbdcnd
!                          indicates the type of boundary condition at
!                          X=a AND X=b
!                          = 0 If the solution is periodic in X, I.E.,
!                              U(X+b-a,Y)=U(X,Y) for all Y,X
!                          = 1 If the solution is specified at X=a and
!                              X=b, I.E., U(a,Y) and U(b,Y) are
!                              specified for all Y
!                          = 2 If the solution is specified at X=a and
!                              the boundary condition is mixed at X=b,
!                              I.E., U(a,Y) and DU(b,Y)/DX+beta*U(b,Y)
!                              are specified for all Y
!                          = 3 If the boundary conditions at X=a and X=b
!                              are mixed, I.E., DU(a,Y)/DX+alpha*U(a,Y)
!                              and DU(b,Y)/DX+beta*U(b,Y) are specified
!                              for all Y
!                          = 4 If the boundary condition at X=a is mixed
!                              and the solution is specified at X=b,
!                              I.E., DU(a,Y)/DX+alpha*U(a,Y) and U(b,Y)
!                              are specified for all Y
!
!                        bda
!                          a one-dimensional array of length n+1 that
!                          specifies the values of DU(a,Y)/DX+
!                          alpha*U(a,Y) AT X=a. WHEN mbdcnd=3 OR 4
!                               bda(j) = du(a,yj)/dx+alpha*u(a,yj),
!                               j=1,2,...,n+1.
!                          When mbdcnd has any other value, bda is A
!                          dummy parameter.
!
! ON INPUT               alpha
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at X=a (see
!                          argument bda). If mbdcnd.NE.3,4 then alpha
!                          is a dummy parameter.
!
!                        bdb
!                          a one-dimensional array of length n+1 that
!                          specifies the values of DU(b,Y)/DX+
!                          beta*U(b,Y) AT X=b.  WHEN mbdcnd=2 OR 3
!                               bdb(j) = du(b,yj)/dx+beta*u(b,yj),
!                               j=1,2,...,n+1.
!                          When mbdcnd has any other value, bdb is A
!                          dummy parameter.
!
!                        beta
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at X=b (see
!                          argument bdb). If mbdcnd.NE.2,3 then beta is
!                          a dummy parameter.
!
!                        c,d
!                          the range of the Y-independent variable,
!                          I.E., Y is greater than or equal to c and
!                          less than or equal to d.  c must be less
!                          THAN d.
!
!                        n
!                          the number of panels into which the interval
!                          (c,d) is subdivided.  Hence, there will be
!                          n+1 grid points in the Y-direction given by
!                          YJ=c+(J-1)*DLY FOR J=1,2,...,n+1 WHERE
!                          DLY=(d-c)/n is the panel width. In addition,
!                          n must be greater than 4.
!
!                        nbdcnd
!                          indicates the types of boundary conditions
!                          AT Y=c AND Y=d
!                          = 0 If the solution is periodic in Y, I.E.,
!                              U(X,Y+d-c)=U(X,Y) for all X,Y
!                          = 1 If the solution is specified at Y=c and
!                              Y = d, I.E., U(X,c) and U(X,d) are
!                              specified for all X
!                          = 2 If the solution is specified at Y=c and
!                              the boundary condition is mixed at Y=d,
!                              I.E., U(X,c) AND DU(X,d)/DY+xnu*U(X,d)
!                              are specified for all X
!                          = 3 If the boundary conditions are mixed at
!                              Y=c AND Y=d, I.E., DU(X,d)/DY+gama*U(X,c)
!                              and DU(X,d)/DY+xnu*U(X,d) are specified
!                              for all X
!                          = 4 If the boundary condition is mixed at Y=c
!                              and the solution is specified at Y=d,
!                              I.E. DU(X,c)/DY+gama*U(X,c) and U(X,d)
!                              are specified for all X
!
!                        bdc
!                          a one-dimensional array of length m+1 that
!                          specifies the value of DU(X,c)/DY+gama*U(X,c)
!                          AT Y=c.  WHEN nbdcnd=3 OR 4
!                             bdc(i) = du(xi,c)/dy + gama*u(xi,c),
!                             i=1,2,...,m+1.
!                          When nbdcnd has any other value, bdc is A
!                          dummy parameter.
!
!                        Gama
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at Y=c (see
!                          argument bdc). If nbdcnd.NE.3,4 then gama is
!                          a dummy parameter.
!
!                        bdd
!                          a one-dimensional array of length m+1 that
!                          specifies the value of DU(X,d)/DY +
!                          xnu*U(X,d) AT Y=c.  WHEN nbdcnd=2 OR 3
!                            bdd(i) = du(xi,d)/dy + xnu*u(xi,d),
!                            i=1,2,...,m+1.
!                          When nbdcnd has any other value, bdd is A
!                          dummy parameter.
!
!                        xnu
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at Y=d (see
!                          ARGUMENT bdd). IF nbdcnd.NE.2 OR 3 THEN xnu
!                          is a dummy parameter.
!
!                        COFX
!                          a user-supplied subprogram with
!                          PARAMETERS X, AFUN, BFUN, CFUN WHICH
!                          returns the values of the X-dependent
!                          coefficients AF(X), BF(X), CF(X) in
!                          the elliptic equation at X.
!
!                        COFY
!                          a user-supplied subprogram with
!                          PARAMETERS Y, DFUN, EFUN, FFUN WHICH
!                          returns the values of the Y-dependent
!                          coefficients DF(Y), EF(Y), FF(Y) in
!                          the elliptic equation at Y.
!
!                        Note.  COFX and COFY must be declared external
!                        in the calling routine. The values returned in
!                        AFUN AND DFUN MUST SATISFY AFUN*DFUN GREATER
!                        than 0 for a less than X less than b,
!                        c less than Y less than d (see ierror=10).
!                        The coefficients provided may lead to a matrix
!                        equation which is not diagonally dominant in
!                        which case solution may fail (see ierror=4).
!
!                        grhs
!                          a two-dimensional array that specifies the
!                          values of the right-hand side of the elliptic
!                          EQUATION, I.E., grhs(I,J)=G(XI,YI), FOR
!                          I=2,...,m, J=2,...,n.  at the boundaries,
!                          grhs is defined by
!
!                          mbdcnd   grhs(1,J)   grhs(m+1,J)
!                          ------   ---------   -----------
!                            0      G(a,YJ)     G(b,YJ)
!                            1         *           *
!                            2         *        G(b,YJ)  J=1,2,...,n+1
!                            3      G(a,YJ)     G(b,YJ)
!                            4      G(a,YJ)        *
!
!                          nbdcnd   grhs(I,1)   grhs(I,n+1)
!                          ------   ---------   -----------
!                            0      G(XI,c)     G(XI,d)
!                            1         *           *
!                            2         *        G(XI,d)  I=1,2,...,m+1
!                            3      G(XI,c)     G(XI,d)
!                            4      G(XI,c)        *
!
!                          Where * means these quantites are not used.
!                          grhs should be dimensioned mn by at least
!                          n+1 in the calling routine.
!
!                        mn
!                          the row (or first) dimension of the array
!                          grhs as it appears in the program calling
!                          sepell. mn must be at least 7 and greater
!                          than or equal to m+1.
!
!                        usol
!                          a two-dimensional array that specifies the
!                          values of the solution along the boundaries.
!                          At the boundaries, usol is defined by
!
!                          mbdcnd   usol(1,J)   usol(m+1,J)
!                          ------   ---------   -----------
!                            0         *           *
!                            1      U(a,YJ)     U(b,YJ)
!                            2      U(a,YJ)        *     J=1,2,...,n+1
!                            3         *           *
!                            4         *        U(b,YJ)
!
!                          nbdcnd   usol(I,1)   usol(I,n+1)
!                          ------   ---------   -----------
!                            0         *           *
!                            1      U(XI,c)     U(XI,d)
!                            2      U(XI,c)        *     I=1,2,...,m+1
!                            3         *           *
!                            4         *        U(XI,d)
!
!                          Where * means the quantites are not used in
!                          the solution.
!
!                          If iorder=2 And idmn=mn, then the user may
!                          equivalence grhs and usol. Note that in this
!                          case the tables specifying the boundaries of
!                          the grhs and usol arrays determine the
!                          boundaries uniquely except at the corners.
!                          If the tables call for both G(X,Y) and
!                          U(X,Y) at a corner then the solution must be
!                          chosen.  For example, if mbdcnd=2 And
!                          nbdcnd=4, then U(a,c), U(a,d), U(b,d) must be
!                          chosen at the corners in addition to G(b,c).
!
!                          If iorder=4, then the two arrays, usol and
!                          grhs, must be distinct.
!
!                          usol should be dimensioned idmn by at least
!                          n+1 in the calling routine.
!
!                        idmn
!                          the row (or first) dimension of the array
!                          usol as it appears in the program calling
!                          sepell. idmn must be at least 7 and greater
!                          than or equal to m+1.
!
!                        w
!                          a one-dimensional array that must be provided
!                          by the user for work space.  Let
!                          K=int(LOG2(n+1))+1 and set  L=2**(K+1).
!                          Then (K-2)*L+K+10*n+12*m+27 will suffice
!                          as a length of w.  the actual length of w in
!                          the calling routine must be set in w(1) (see
!                          ierror=11).
!
! ON OUTPUT              usol
!                          contains the approximate solution to the
!                          elliptic equation.  usol(I,J) is the
!                          approximation to U(XI,YJ) for I=1,2...,m+1
!                          and J=1,2,...,n+1.  The approximation has
!                          error O(DLX**2+DLY**2) if called with
!                          iorder=2 And O(DLX**4+DLY**4) if called with
!                          iorder=4.
!
!                        w
!                          contains intermediate values that must not be
!                          destroyed if sepell is called again with
!                          intl=1.  In addition w(1) contains the exact
!                          minimal length (in floating point) required
!                          for the work space (see ierror=11).
!
!                        pertrb
!                          if a combination of periodic or derivative
!                          boundary conditions (I.E., alpha=beta=0 If
!                          mbdcnd=3, gama=xnu=0 IF nbdcnd=3) IS
!                          specified and if the coefficients of U(X,Y)
!                          in the separable elliptic equation are zero
!                          (I.E., CF(X)=0 For X greater than or equal to
!                          A and less than or equal to b, FF(Y)=0 For
!                          Y greater than or equal to c and less than
!                          or equal to d) then a solution may not exist.
!                          pertrb is a constant calculated and
!                          subtracted from the right-hand side of the
!                          matrix equations generated by sepell which
!                          insures that a solution exists.  sepell then
!                          computes this solution which is a weighted
!                          minimal least squares solution to the
!                          original problem.
!
!                        Ierror
!                          an error flag that indicates invalid input
!                          parameters or failure to find a solution
!                          = 0 No error
!                          = 1 If a greater than b or c greater than d
!                          = 2 If mbdcnd less than 0 or mbdcnd greater
!                              than 4
!                          = 3 If nbdcnd less than 0 or nbdcnd greater
!                              than 4
!                          = 4 If attempt to find a solution fails.
!                              (The linear system generated is not
!                              diagonally dominant.)
!                          = 5 If idmn or mn is too small.
!                          = 6 If m is too small or too large (see
!                              discussion of m)
!                          = 7 If n is too small (see discussion of n)
!                          = 8 If iorder is not 2 or 4
!                          = 9 If intl is not 0 or 1
!                          = 10 If AFUN*DFUN less than or equal to 0 for
!                               some interior mesh point (XI,YJ)
!                          = 11 If the work space length input in w(1)
!                               is less than the exact minimal work
!                               space length required output in w(1).
!
!                          Note (concerning ierror=4).  For the
!                          coefficients input through COFX, COFY, the
!                          discretization may lead to a block
!                          tridiagonal linear system which is not
!                          diagonally dominant (for example, this
!                          happens if CFUN=0 And BFUN/(2.*DLX) greater
!                          than AFUN/DLX**2).  In this case solution may
!                          fail.  This cannot happen in the limit as
!                          DLX, DLY approach zero.  Hence, the condition
!                          may be remedied by taking larger values for m
!                          OR n.
!
! ENTRY POINTS           sepell, sepel1, chkprm, chksng, orthg, minsol,
!                        trisp, DEFER, dxfn, dyfn, blktri, blktr1,indxb,
!                        indxa, indxc, prod0, prodp, cprod0, cprodp,
!                        ppadd, psgf, bsrh, ppsgf, ppspf, compb,
!                        tqlrt0, spmpar
!
! SPECIAL CONDITIONS     NONE
!
! COMMON BLOCKS          SPLP, CBLKT
!
! I/O                    NONE
!
! PRECISION              SINGLE
!
! SPECIALIST             JOHN c. ADAMS, NCAR, BOULDER, COLORADO  80307
!
! HISTORY                DEVELOPED AT NCAR DURING 1975-76.
!
! ALGORITHM              sepell AUTOMATICALLY DISCRETIZES THE SEPARABLE
!                        elliptic equation which is then solved by A
!                        generalized cyclic reduction algorithm in the
!                        subroutine, blktri.  The fourth-order solution
!                        is obtained using deferred corrections, which
!                        is described and referenced in sections,
!                        references and method.
!
! ACCURACY AND TIMING    THE FOLLOWING COMPUTATIONAL RESULTS WERE
!                        obtained by solving the sample problem at the
!                        END OF THIS WRITE-UP ON THE CONTROL DATA 7600.
!                        The OP count is proportional to m*n*LOG2(n).
!                        In contrast to the other routines in this
!                        chapter, accuracy is tested by computing and
!                        tabulating second- and fourth-order
!                        discretization errors.  Below is a table
!                        containing computational results.  The times
!                        given do not include initialization (I.E.,
!                        times are for intl=1).  Note that the
!                        fourth-order accuracy is not realized until the
!                        mesh is sufficiently refined.
!
!              SECOND-ORDER    FOURTH-ORDER   SECOND-ORDER  FOURTH-ORDER
!    m    n   EXECUTION TIME  EXECUTION TIME    ERROR         ERROR
!               (m SEC)         (m SEC)
!     6    6         6              14          6.8E-1        1.2E0
!    14   14        23              58          1.4E-1        1.8E-1
!    30   30       100             247          3.2E-2        9.7E-3
!    62   62       445           1,091          7.5E-3        3.0E-4
!   126  126     2,002           4,772          1.8E-3        3.5E-6
!
! PORTABILITY            THE VALUE GIVEN BY spmpar(1) IS THE ONLY
!                        machine dependent constant that is used.
!
! REFERENCES             KELLER, H.B., NUMERICAL METHODS FOR TWO-POINT
!                          boundary-value problems, Blaisdel (1968),
!                          WALTHAM, mass.
!
!                        Swarztrauber, P., And R. sweet (1975),
!                          efficient Fortran subprograms for the
!                          solution of elliptic partial differential
!                          equations.  NCAR technical note
!                          NCAR-TN/ia-109, PP. 135-137.
!
!
!
!
!
!     Check input parameters
!
call chkprm(intl,iorder,a,b,m,mbdcnd,c,d,n,nbdcnd,cofx,cofy, &
   & idmn,mn,ierror)
if (ierror /= 0) return
!
!     Compute minimum work space and check work space length input
!
l = n + 1
if (nbdcnd == 0) l = n
logb2n = int(log(float(l) + 0.5)/log(2.0)) + 1
ll = 2**(logb2n + 1)
k = m + 1
l = n + 1
length = (logb2n - 2)*ll + logb2n + max(2*l,6*k) + 5
if (nbdcnd == 0) length = length + 2*l
ierror = 11
linput = int(w(1) + 0.5)
loutpt = length + 6*(k + l) + 1
w(1) = float(loutpt)
if (loutpt > linput) return
ierror = 0
!
!     Set work space indices
!
i1 = length + 2
i2 = i1 + l
i3 = i2 + l
i4 = i3 + l
i5 = i4 + l
i6 = i5 + l
i7 = i6 + l
i8 = i7 + k
i9 = i8 + k
i10 = i9 + k
i11 = i10 + k
i12 = i11 + k
i13 = 2
call sepel1(intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c,d,n, &
   & nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,w(i1),w(i2),w(i3), &
   & w(i4),w(i5),w(i6),w(i7),w(i8),w(i9),w(i10),w(i11), &
   & w(i12),grhs,mn,usol,idmn,w(i13),pertrb,ierror)
return
end subroutine sepell

subroutine sepel1(intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c, &
   & d,n,nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,an,bn, &
   & cn,dn,un,zn,am,bm,cm,dm,um,zm,grhs,mn,usol, &
   & idmn,w,pertrb,ierror)
implicit none
integer :: idmn, ierror, intl, iorder, m, mbdcnd, mn, n, nbdcnd
real :: a, alpha, am(*), an(*), b, bda(*), bdb(*), bdc(*), bdd(*), &
   & beta, bm(*), bn(*), c, cm(*), cn(*), d, dm(*), dn(*), gama, &
   & grhs(mn,*), pertrb, um(*), un(*), usol(idmn,*), w(*), xnu, zm(*), &
   & zn(*)
external cofx, cofy
integer :: i, i1, iord, j, mp, np
real :: ai, ax1, axi, bi, bxi, ci, cxi, cxm, dj, dy1, dyj, ej, &
   & eyj, fj, fyj, fyn, prtrb, xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
logical :: singlr
!
!     sepel1 sets up vectors and arrays for input to blktri
!     and computes a second order solution in USOL.  A return jump to
!     sepell OCCURRS IF iorder=2.  IF iorder=4 A FOURTH ORDER
!     solution is generated in USOL.
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!
!
!     Set parameters internally
!
kswx = mbdcnd + 1
kswy = nbdcnd + 1
k = m + 1
l = n + 1
ait = a
bit = b
cit = c
dit = d
!
!     Set right hand side values from GRHS in USOL on the interior
!     and non-specified boundaries.
!
do i = 2,m
   do j = 2,n
      usol(i,j) = grhs(i,j)
   end do
end do
if (kswx == 2 .or. kswx == 3) go to  40
do j = 2,n
   usol(1,j) = grhs(1,j)
end do
40 continue
if (kswx == 2 .or. kswx == 5) go to  60
do j = 2,n
   usol(k,j) = grhs(k,j)
end do
60 continue
if (kswy == 2 .or. kswy == 3) go to  80
do i = 2,m
   usol(i,1) = grhs(i,1)
end do
80 continue
if (kswy == 2 .or. kswy == 5) go to 100
do i = 2,m
   usol(i,l) = grhs(i,l)
end do
100 continue
if (kswx /= 2 .and. kswx /= 3 .and. kswy /= 2 .and. kswy /= 3) &
   & usol(1,1) = grhs(1,1)
if (kswx /= 2 .and. kswx /= 5 .and. kswy /= 2 .and. kswy /= 3) &
   & usol(k,1) = grhs(k,1)
if (kswx /= 2 .and. kswx /= 3 .and. kswy /= 2 .and. kswy /= 5) &
   & usol(1,l) = grhs(1,l)
if (kswx /= 2 .and. kswx /= 5 .and. kswy /= 2 .and. kswy /= 5) &
   & usol(k,l) = grhs(k,l)
i1 = 1
!
!     Set switches for periodic or non-periodic boundaries
!
mp = 1
np = 1
if (kswx == 1) mp = 0
if (kswy == 1) np = 0
!
!     Set dlx,dly and size of block tri-diagonal system generated
!     in NINT,mint
!
dlx = (bit - ait)/float(m)
mit = k - 1
if (kswx == 2) mit = k - 2
if (kswx == 4) mit = k
dly = (dit - cit)/float(n)
nit = l - 1
if (kswy == 2) nit = l - 2
if (kswy == 4) nit = l
tdlx3 = 2.0*dlx**3
dlx4 = dlx**4
tdly3 = 2.0*dly**3
dly4 = dly**4
!
!     Set subscript limits for portion of array to input to blktri
!
is = 1
js = 1
if (kswx == 2 .or. kswx == 3) is = 2
if (kswy == 2 .or. kswy == 3) js = 2
ns = nit + js - 1
ms = mit + is - 1
!
!     Set X - Direction
!
do i = 1,mit
   xi = ait + float(is + i - 2)*dlx
   call cofx(xi,ai,bi,ci)
   axi = (ai/dlx - 0.5*bi)/dlx
   bxi = -2.*ai/dlx**2 + ci
   cxi = (ai/dlx + 0.5*bi)/dlx
   am(i) = axi
   bm(i) = bxi
   cm(i) = cxi
end do
!
!     Set Y direction
!
do j = 1,nit
   yj = cit + float(js + j - 2)*dly
   call cofy(yj,dj,ej,fj)
   dyj = (dj/dly - 0.5*ej)/dly
   eyj = (-2.*dj/dly**2 + fj)
   fyj = (dj/dly + 0.5*ej)/dly
   an(j) = dyj
   bn(j) = eyj
   cn(j) = fyj
end do
!
!     Adjust edges in X direction unless periodic
!
ax1 = am(1)
cxm = cm(mit)
go to (170,130,150,160,140),kswx
!
!     Dirichlet-Dirichlet in X direction
!
130 am(1) = 0.0
cm(mit) = 0.0
go to 170
!
!     Mixed-Dirichlet in X direction
!
140 am(1) = 0.0
bm(1) = bm(1) + 2.*alpha*dlx*ax1
cm(1) = cm(1) + ax1
cm(mit) = 0.0
go to 170
!
!     Dirichlet-mixed in X direction
!
150 am(1) = 0.0
am(mit) = am(mit) + cxm
bm(mit) = bm(mit) - 2.*beta*dlx*cxm
cm(mit) = 0.0
go to 170
!
!     Mixed - Mixed in X direction
!
160 continue
am(1) = 0.0
bm(1) = bm(1) + 2.*dlx*alpha*ax1
cm(1) = cm(1) + ax1
am(mit) = am(mit) + cxm
bm(mit) = bm(mit) - 2.*dlx*beta*cxm
cm(mit) = 0.0
170 continue
!
!     Adjust in Y direction unless periodic
!
dy1 = an(1)
fyn = cn(nit)
go to (220,180,200,210,190),kswy
!
!     Dirichlet-Dirichlet in Y direction
!
180 continue
an(1) = 0.0
cn(nit) = 0.0
go to 220
!
!     Mixed-Dirichlet in Y direction
!
190 continue
an(1) = 0.0
bn(1) = bn(1) + 2.*dly*gama*dy1
cn(1) = cn(1) + dy1
cn(nit) = 0.0
go to 220
!
!     Dirichlet-mixed in Y direction
!
200 an(1) = 0.0
an(nit) = an(nit) + fyn
bn(nit) = bn(nit) - 2.*dly*xnu*fyn
cn(nit) = 0.0
go to 220
!
!     Mixed - Mixed direction in Y direction
!
210 continue
an(1) = 0.0
bn(1) = bn(1) + 2.*dly*gama*dy1
cn(1) = cn(1) + dy1
an(nit) = an(nit) + fyn
bn(nit) = bn(nit) - 2.0*dly*xnu*fyn
cn(nit) = 0.0
220 if (kswx == 1) go to 270
!
!     Adjust USOL along X edge
!
do 260 j = js,ns
   if (kswx /= 2 .and. kswx /= 3) go to 230
   usol(is,j) = usol(is,j) - ax1*usol(1,j)
   go to 240
230 usol(is,j) = usol(is,j) + 2.0*dlx*ax1*bda(j)
240 if (kswx /= 2 .and. kswx /= 5) go to 250
   usol(ms,j) = usol(ms,j) - cxm*usol(k,j)
   go to 260
250 usol(ms,j) = usol(ms,j) - 2.0*dlx*cxm*bdb(j)
260 continue
270 if (kswy == 1) go to 320
!
!     Adjust USOL along Y edge
!
do 310 i = is,ms
   if (kswy /= 2 .and. kswy /= 3) go to 280
   usol(i,js) = usol(i,js) - dy1*usol(i,1)
   go to 290
280 usol(i,js) = usol(i,js) + 2.0*dly*dy1*bdc(i)
290 if (kswy /= 2 .and. kswy /= 5) go to 300
   usol(i,ns) = usol(i,ns) - fyn*usol(i,l)
   go to 310
300 usol(i,ns) = usol(i,ns) - 2.0*dly*fyn*bdd(i)
310 continue
320 continue
!
!     Save adjusted edges in GRHS if iorder=4
!
if (iorder /= 4) go to 350
do j = js,ns
   grhs(is,j) = usol(is,j)
   grhs(ms,j) = usol(ms,j)
end do
do i = is,ms
   grhs(i,js) = usol(i,js)
   grhs(i,ns) = usol(i,ns)
end do
350 continue
iord = iorder
pertrb = 0.0
!
!     Check if operator is singular
!
call chksng(mbdcnd,nbdcnd,alpha,beta,gama,xnu,cofx,cofy,singlr)
!
!     Compute non-zero eigenvector in null space of transpose
!     if singular
!
if (singlr) call trisp(mit,am,bm,cm,dm,um,zm)
if (singlr) call trisp(nit,an,bn,cn,dn,un,zn)
!
!     Make initialization call to blktri
!
if (intl == 0) &
   & call blktri(intl,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn, &
   & usol(is,js),ierror,w)
if (ierror /= 0) return
!
!     Adjust right hand side if necessary
!
360 continue
if (singlr) call orthg(usol,idmn,zn,zm,pertrb)
!
!     Compute solution
!
call blktri(i1,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn,usol(is,js), &
   & ierror,w)
if (ierror /= 0) return
!
!     Set periodic boundaries if necessary
!
if (kswx /= 1) go to 380
do j = 1,l
   usol(k,j) = usol(1,j)
end do
380 if (kswy /= 1) go to 400
do i = 1,k
   usol(i,l) = usol(i,1)
end do
400 continue
!
!     Minimize solution with respect to weighted least squares
!     norm if operator is singular
!
if (singlr) call minsol(usol,idmn,zn,zm,prtrb)
!
!     RETURN IF DEFERRED CORRECTIONS AND A FOURTH ORDER SOLUTION ARE
!     not flagged
!
if (iord == 2) return
iord = 2
!
!     Compute new right hand side for fourth order solution
!
call defer(cofx,cofy,usol,idmn,grhs,mn)
go to 360
end subroutine sepel1

subroutine chkprm(intl,iorder,a,b,m,mbdcnd,c,d,n,nbdcnd,cofx, &
   & cofy,idmn,mn,ierror)
implicit none
integer, intent(in) :: idmn
integer, intent(out) :: ierror
integer, intent(in) :: intl, iorder, m, mbdcnd, mn, n, nbdcnd
real, intent(in) :: a, b, c, d
integer :: i, j
real :: ai, bi, ci, dj, dlx, dly, ej, fj, xi, yj
!
!     This program checks the input parameters for errors
!
!
!     Check definition of solution region
!
ierror = 1
if (a >= b .or. c >= d) return
!
!     Check boundary switches
!
ierror = 2
if (mbdcnd < 0 .or. mbdcnd > 4) return
ierror = 3
if (nbdcnd < 0 .or. nbdcnd > 4) return
!
!     Check first dimension in calling routine
!
ierror = 5
if (mn < 7 .or. idmn < 7) return
!
!     Check m
!
ierror = 6
if (m > (idmn - 1) .or. m < 6) return
if (m > mn - 1) return
!
!     Check n
!
ierror = 7
if (n < 5) return
!
!     Check iorder
!
ierror = 8
if (iorder /= 2 .and. iorder /= 4) return
!
!     Check intl
!
ierror = 9
if (intl /= 0 .and. intl /= 1) return
!
!     Check that equation is elliptic
!
dlx = (b - a)/float(m)
dly = (d - c)/float(n)
do i = 2,m
   xi = a + float(i - 1)*dlx
   call cofx(xi,ai,bi,ci)
   do j = 2,n
      yj = c + float(j - 1)*dly
      call cofy(yj,dj,ej,fj)
      if (ai*dj > 0.0) go to  10
      ierror = 10
      return
10    continue
   end do
end do
!
!     No error found
!
ierror = 0
return
end subroutine chkprm

subroutine chksng(mbdcnd,nbdcnd,alpha,beta,gama,xnu,cofx,cofy, &
   & singlr)
implicit none
integer :: mbdcnd, nbdcnd
real :: alpha, beta, gama, xnu
logical :: singlr
integer :: i, j
real :: ai, bi, ci, dj, ej, fj, xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     THIS SUBROUTINE CHECKS IF THE PDE   sepell
!     must solve is a singular operator
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!
!
singlr = .false.
!
!     Check if the boundary conditions are
!     entirely periodic and/or mixed
!
if ((mbdcnd /= 0 .and. mbdcnd /= 3) .or. &
   & (nbdcnd /= 0 .and. nbdcnd /= 3)) return
!
!     Check that mixed conditions are pure neuman
!
if (mbdcnd /= 3) go to  10
if (alpha /= 0.0 .or. beta /= 0.0) return
10 if (nbdcnd /= 3) go to  20
if (gama /= 0.0 .or. xnu /= 0.0) return
20 continue
!
!     Check that non-derivative coefficient functions
!     are zero
!
do i = is,ms
   xi = ait + float(i - 1)*dlx
   call cofx(xi,ai,bi,ci)
   if (ci /= 0.0) return
end do
do j = js,ns
   yj = cit + float(j - 1)*dly
   call cofy(yj,dj,ej,fj)
   if (fj /= 0.0) return
end do
!
!     The operator must be singular if this point is reached
!
singlr = .true.
return
end subroutine chksng

subroutine orthg(usol,idmn,zn,zm,pertrb)
implicit none
integer :: idmn
real :: pertrb, usol(idmn,*), zm(*), zn(*)
integer :: i, ifnl, ii, istr, j, jfnl, jj, jstr
real :: ete, ute
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     This subroutine orthogonalizes the array usol with respect to
!     the constant array in a weighted least squares norm
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!
istr = is
ifnl = ms
jstr = js
jfnl = ns
!
!     Compute weighted inner products
!
ute = 0.0
ete = 0.0
do i = is,ms
   ii = i - is + 1
   do j = js,ns
      jj = j - js + 1
      ete = ete + zm(ii)*zn(jj)
      ute = ute + usol(i,j)*zm(ii)*zn(jj)
   end do
end do
!
!     Set perturbation parameter
!
pertrb = ute/ete
!
!     Subtract off constant pertrb
!
do i = istr,ifnl
   do j = jstr,jfnl
      usol(i,j) = usol(i,j) - pertrb
   end do
end do
return
end subroutine orthg

subroutine minsol(usol,idmn,zn,zm,pertb)
implicit none
integer :: idmn
real :: pertb, usol(idmn,*), zm(*), zn(*)
integer :: i, ifnl, ii, istr, j, jfnl, jj, jstr
real :: ete, pertrb, ute
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     This subroutine orthogonalizes the array usol with respect to
!     the constant array in a weighted least squares norm
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!
!     Entry at minsol occurrs when the final solution is
!     to be minimized with respect to the weighted
!     least squares norm
!
istr = 1
ifnl = k
jstr = 1
jfnl = l
!
!     Compute weighted inner products
!
ute = 0.0
ete = 0.0
do i = is,ms
   ii = i - is + 1
   do j = js,ns
      jj = j - js + 1
      ete = ete + zm(ii)*zn(jj)
      ute = ute + usol(i,j)*zm(ii)*zn(jj)
   end do
end do
!
!     Set perturbation parameter
!
pertrb = ute/ete
!
!     Subtract off constant pertrb
!
do i = istr,ifnl
   do j = jstr,jfnl
      usol(i,j) = usol(i,j) - pertrb
   end do
end do
return
end subroutine minsol

subroutine trisp(n,a,b,c,d,u,z)
implicit none
integer, intent(in) :: n
real :: a(n), b(n), c(n)
real, intent(inout) :: d(n), u(n), z(n)
integer :: j, k, nm1, nm2
real :: an, bn, den, v
!
!     This subroutine solves for a non-zero eigenvector corresponding
!     to the zero eigenvalue of the transpose of the rank
!     deficient one matrix with subdiagonal A, diagonal b, and
!     superdiagonal c , with a(1) in the (1,n) position, with
!     c(n) in the (n,1) position, and all other elements zero.
!
!
bn = b(n)
d(1) = a(2)/b(1)
v = a(1)
u(1) = c(n)/b(1)
nm2 = n - 2
do j = 2,nm2
   den = b(j) - c(j - 1)*d(j - 1)
   d(j) = a(j + 1)/den
   u(j) = -c(j - 1)*u(j - 1)/den
   bn = bn - v*u(j - 1)
   v = -v*d(j - 1)
end do
den = b(n - 1) - c(n - 2)*d(n - 2)
d(n - 1) = (a(n) - c(n - 2)*u(n - 2))/den
an = c(n - 1) - v*d(n - 2)
bn = bn - v*u(n - 2)
den = bn - an*d(n - 1)
!
!     Set last component equal to one
!
z(n) = 1.0
z(n - 1) = -d(n - 1)
nm1 = n - 1
do j = 2,nm1
   k = n - j
   z(k) = -d(k)*z(k + 1) - u(k)*z(n)
end do
return
end subroutine trisp

subroutine defer(cofx,cofy,usol,idmn,grhs,mn)
implicit none
integer :: idmn, mn
real :: grhs(mn,*), usol(idmn,*)
integer :: i, j
real :: ai, bi, ci, dj, ej, fj, tx, ty, uxxx, uxxxx, uyyy, uyyyy, &
   & xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     This subroutine first approximates the truncation error given
!     BY  TRUN1(X,Y)=dlx**2*tx+dly**2*ty WHERE
!     tx=AFUN(X)*uxxxx/12.0+BFUN(X)*uxxx/6.0 on the interior and
!     at the boundaries if periodic (here uxxx,uxxxx are the third
!     and fourth partial derivatives of U with respect to X).
!     tx is of the form AFUN(X)/3.0*(uxxxx/4.0+uxxx/dlx)
!     at X=A or X=B if the boundary condition there is mixed.
!     tx=0.0 along specified boundaries.  ty has symmetric form
!     in Y with X,AFUN(X),BFUN(X) replaced by Y,DFUN(Y),EFUN(Y).
!     The second order solution in usol is used to approximate
!     (via second order finite differencing) the TRUN1ATION error
!     and the result is added to the right hand side in grhs
!     and then transferred to usol to be used as a new right
!     hand side when calling blktri for a fourth order solution.
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!
!
!     Compute truncation error approximation over the entire mesh
!
do j = js,ns
   yj = cit + float(j - 1)*dly
   call cofy(yj,dj,ej,fj)
   do i = is,ms
      xi = ait + float(i - 1)*dlx
      call cofx(xi,ai,bi,ci)
!
!     Compute partial derivative approximations at (XI,YJ)
!
      call dxfn(usol,idmn,i,j,uxxx,uxxxx)
      call dyfn(usol,idmn,i,j,uyyy,uyyyy)
      tx = ai*uxxxx/12.0 + bi*uxxx/6.0
      ty = dj*uyyyy/12.0 + ej*uyyy/6.0
!
!     Reset form of truncation if at boundary which is non-periodic
!
      if (kswx == 1 .or. (i > 1 .and. i < k)) go to  10
      tx = ai/3.0*(uxxxx/4.0 + uxxx/dlx)
10    if (kswy == 1 .or. (j > 1 .and. j < l)) go to  20
      ty = dj/3.0*(uyyyy/4.0 + uyyy/dly)
20    grhs(i,j) = grhs(i,j) + dlx**2*tx + dly**2*ty
   end do
end do
!
!     Reset the right hand side in usol
!
do i = is,ms
   do j = js,ns
      usol(i,j) = grhs(i,j)
   end do
end do
return
end subroutine defer

subroutine dxfn(u,idmn,i,j,uxxx,uxxxx)
implicit none
integer :: i, idmn, j
real :: u(idmn,*), uxxx, uxxxx
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     This program computes second order finite difference
!     approximations to the third and fourth X
!     partial derivatives of u at the (i,j) mesh point
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!
if (i > 2 .and. i < (k - 1)) go to  50
if (i == 1) go to  10
if (i == 2) go to  30
if (i == k - 1) go to  60
if (i == k) go to  80
!
!     Compute partial derivative approximations at X=A
!
10 if (kswx == 1) go to  20
uxxx = (-5.0*u(1,j) + 18.0*u(2,j) - 24.0*u(3,j) + 14.0*u(4,j) - &
   & 3.0*u(5,j))/(tdlx3)
uxxxx = (3.0*u(1,j) - 14.0*u(2,j) + 26.0*u(3,j) - 24.0*u(4,j) + &
   & 11.0*u(5,j) - 2.0*u(6,j))/dlx4
return
!
!     Periodic at X=A
!
20 uxxx = (-u(k - 2,j) + 2.0*u(k - 1,j) - 2.0*u(2,j) + u(3,j))/(tdlx3)
uxxxx = (u(k - 2,j) - 4.0*u(k - 1,j) + 6.0*u(1,j) - 4.0*u(2,j) + u(3,j))/dlx4
return
!
!     Compute partial derivative approximations at X=A+dlx
!
30 if (kswx == 1) go to  40
uxxx = (-3.0*u(1,j) + 10.0*u(2,j) - 12.0*u(3,j) + 6.0*u(4,j) - u(5,j))/ &
   & tdlx3
uxxxx = (2.0*u(1,j) - 9.0*u(2,j) + 16.0*u(3,j) - 14.0*u(4,j) + 6.0*u(5,j) - &
   & u(6,j))/dlx4
return
!
!     Periodic at X=A+dlx
!
40 uxxx = (-u(k - 1,j) + 2.0*u(1,j) - 2.0*u(3,j) + u(4,j))/(tdlx3)
uxxxx = (u(k - 1,j) - 4.0*u(1,j) + 6.0*u(2,j) - 4.0*u(3,j) + u(4,j))/dlx4
return
!
!     Compute partial derivative approximations on the interior
!
50 continue
uxxx = (-u(i - 2,j) + 2.0*u(i - 1,j) - 2.0*u(i + 1,j) + u(i + 2,j))/tdlx3
uxxxx = (u(i - 2,j) - 4.0*u(i - 1,j) + 6.0*u(i,j) - 4.0*u(i + 1,j) + u(i + 2,j))/ &
   & dlx4
return
!
!     Compute partial derivative approximations at X=B-dlx
!
60 if (kswx == 1) go to  70
uxxx = (u(k - 4,j) - 6.0*u(k - 3,j) + 12.0*u(k - 2,j) - 10.0*u(k - 1,j) + &
   & 3.0*u(k,j))/tdlx3
uxxxx = (-u(k - 5,j) + 6.0*u(k - 4,j) - 14.0*u(k - 3,j) + 16.0*u(k - 2,j) - &
   & 9.0*u(k - 1,j) + 2.0*u(k,j))/dlx4
return
!
!     Periodic at X=B-dlx
!
70 uxxx = (-u(k - 3,j) + 2.0*u(k - 2,j) - 2.0*u(1,j) + u(2,j))/tdlx3
uxxxx = (u(k - 3,j) - 4.0*u(k - 2,j) + 6.0*u(k - 1,j) - 4.0*u(1,j) + u(2,j))/ &
   & dlx4
return
!
!     Compute partial derivative approximations at X=B
!
80 uxxx = -(3.0*u(k - 4,j) - 14.0*u(k - 3,j) + 24.0*u(k - 2,j) - 18.0*u(k - 1,j) + &
   & 5.0*u(k,j))/tdlx3
uxxxx = (-2.0*u(k - 5,j) + 11.0*u(k - 4,j) - 24.0*u(k - 3,j) + 26.0*u(k - 2,j) - &
   & 14.0*u(k - 1,j) + 3.0*u(k,j))/dlx4
return
end subroutine dxfn

subroutine dyfn(u,idmn,i,j,uyyy,uyyyy)
implicit none
integer :: i, idmn, j
real :: u(idmn,*), uyyy, uyyyy
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!
!     This program computes second order finite difference
!     approximations to the third and fourth Y
!     partial derivatives of u at the (i,j) mesh point
!
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!
if (j > 2 .and. j < (l - 1)) go to  50
if (j == 1) go to  10
if (j == 2) go to  30
if (j == l - 1) go to  60
if (j == l) go to  80
!
!     Compute partial derivative approximations at Y=C
!
10 if (kswy == 1) go to  20
uyyy = (-5.0*u(i,1) + 18.0*u(i,2) - 24.0*u(i,3) + 14.0*u(i,4) - &
   & 3.0*u(i,5))/tdly3
uyyyy = (3.0*u(i,1) - 14.0*u(i,2) + 26.0*u(i,3) - 24.0*u(i,4) + &
   & 11.0*u(i,5) - 2.0*u(i,6))/dly4
return
!
!     Periodic at X=A
!
20 uyyy = (-u(i,l - 2) + 2.0*u(i,l - 1) - 2.0*u(i,2) + u(i,3))/tdly3
uyyyy = (u(i,l - 2) - 4.0*u(i,l - 1) + 6.0*u(i,1) - 4.0*u(i,2) + u(i,3))/dly4
return
!
!     Compute partial derivative approximations at Y=C+dly
!
30 if (kswy == 1) go to  40
uyyy = (-3.0*u(i,1) + 10.0*u(i,2) - 12.0*u(i,3) + 6.0*u(i,4) - u(i,5))/ &
   & tdly3
uyyyy = (2.0*u(i,1) - 9.0*u(i,2) + 16.0*u(i,3) - 14.0*u(i,4) + 6.0*u(i,5) - &
   & u(i,6))/dly4
return
!
!     Periodic at Y=C+dly
!
40 uyyy = (-u(i,l - 1) + 2.0*u(i,1) - 2.0*u(i,3) + u(i,4))/tdly3
uyyyy = (u(i,l - 1) - 4.0*u(i,1) + 6.0*u(i,2) - 4.0*u(i,3) + u(i,4))/dly4
return
!
!     Compute partial derivative approximations on the interior
!
50 continue
uyyy = (-u(i,j - 2) + 2.0*u(i,j - 1) - 2.0*u(i,j + 1) + u(i,j + 2))/tdly3
uyyyy = (u(i,j - 2) - 4.0*u(i,j - 1) + 6.0*u(i,j) - 4.0*u(i,j + 1) + u(i,j + 2))/ &
   & dly4
return
!
!     Compute partial derivative approximations at Y=D-dly
!
60 if (kswy == 1) go to  70
uyyy = (u(i,l - 4) - 6.0*u(i,l - 3) + 12.0*u(i,l - 2) - 10.0*u(i,l - 1) + &
   & 3.0*u(i,l))/tdly3
uyyyy = (-u(i,l - 5) + 6.0*u(i,l - 4) - 14.0*u(i,l - 3) + 16.0*u(i,l - 2) - &
   & 9.0*u(i,l - 1) + 2.0*u(i,l))/dly4
return
!
!     Periodic at Y=D-dly
!
70 continue
uyyy = (-u(i,l - 3) + 2.0*u(i,l - 2) - 2.0*u(i,1) + u(i,2))/tdly3
uyyyy = (u(i,l - 3) - 4.0*u(i,l - 2) + 6.0*u(i,l - 1) - 4.0*u(i,1) + u(i,2))/ &
   & dly4
return
!
!     Compute partial derivative approximations at Y=D
!
80 uyyy = -(3.0*u(i,l - 4) - 14.0*u(i,l - 3) + 24.0*u(i,l - 2) - 18.0*u(i,l - 1) + &
   & 5.0*u(i,l))/tdly3
uyyyy = (-2.0*u(i,l - 5) + 11.0*u(i,l - 4) - 24.0*u(i,l - 3) + 26.0*u(i,l - 2) - &
   & 14.0*u(i,l - 1) + 3.0*u(i,l))/dly4
return
end subroutine dyfn

subroutine blktri(iflg,np,n,an,bn,cn,mp,m,am,bm,cm,idimy,y, &
   & ierror,w)
implicit none
integer :: idimy, ierror, iflg, m, mp, n, np
real :: am(*), an(*), bm(*), bn(*), cm(*), cn(*), w(*), y(idimy,*)
integer :: iw1, iw2, iw3, iwah, iwbh, iwd, iwu, iww, nh, nl
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
external prod0, prodp, cprod0, cprodp
!
!
!***********************************************************************
!
!          Version  2  October 1976  including errata  October 1976
!
!         Documentation for this program is given in
!
!        Efficient Fortran subprograms for the solution of
!            elliptic partial differential equations
!
!                              By
!
!          PAUL SWARZTRAUBER   AND  ROLAND SWEET
!
!             TECHNICAL NOTE TN/ia-109   JULY 1975
!
!       National center for atmospheric research  boulder,colorado 80307
!
!        Which is sponsored by the national science foundation
!
!***********************************************************************
!
!
!
!     Subroutine blktri solves a system of linear equations of the form
!
!          an(J)*X(I,J-1) + am(I)*X(I-1,J) + (bn(J)+bm(I))*X(I,J)
!
!          + cn(J)*X(I,J+1) + cm(I)*X(I+1,J) = y(I,J)
!
!               FOR I = 1,2,...,m  AND  J = 1,2,...,n.
!
!     I+1 and I-1 are evaluated modulo m and J+1 and J-1 modulo n, I.E.,
!
!          x(i,0) = x(i,n),  x(i,n+1) = x(i,1),
!          x(0,j) = x(m,j),  x(m+1,j) = x(1,j).
!
!     These equations usually result from the discretization of
!     separable elliptic equations.  Boundary conditions may be
!     Dirichlet, Neumann, or periodic.
!
!
!     * * * * * * * * * *     ON INPUT     * * * * * * * * * *
!
!     iflg
!       = 0  Initialization only.  Certain quantities that depend on np,
!                                  n, an, bn, and cn are computed and
!                                  STOR1D in the work array  w.
!       = 1  The quantities that were computed in the initialization are
!            used to obtain the solution X(I,J).
!
!       Note   a call with iflg=0 Takes approximately one half the time
!              time as a call with iflg = 1  .  However, the
!              initialization does not have to be repeated unless np, n,
!              an, bn, or cn change.
!
!     np
!       = 0  If an(1) and cn(n) are not zero, which corresponds to
!            periodic bounary conditions.
!       = 1  If an(1) and cn(n) are zero.
!
!     n
!       the number of unknowns in the J-direction. n must be greater
!       than 2. The operation count is proportional to MNLOG2(n), hence
!       n should be selected less than or equal to m.
!
!     AN,bn,cn
!       one-dimensional arrays of length n that specify the coefficients
!       in the linear equations given above.
!
!     MP
!       = 0  If am(1) and cm(m) are not zero, which corresponds to
!            periodic boundary conditions.
!       = 1  IF am(1) = cm(m) = 0  .
!
!     m
!       the number of unknowns in the I-direction. m must be greater
!       than 2.
!
!     AM,bm,cm
!       one-dimensional arrays of length m that specify the coefficients
!       in the linear equations given above.
!
!     idimy
!       the row (or first) dimension of the two-dimensional array y as
!       it appears in the program calling blktri.  This parameter is
!       used to specify the variable DIMENSION of y.  idimy must be at
!       LEAST m.
!
!     y
!       a two-dimensional array that specifies the values of the right
!       side of the linear system of equations given above.  y must be
!       dimensioned at least m*n.
!
!     w
!       a one-dimensional array that must be provided by the user for
!       work space.
!             If np=1 Define k=int(LOG2(n))+1 and set L=2**(k+1) then
!                     w must have dimension (k-2)*L+k+4+max(2n,6m)
!
!             If np=0 Define k=int(LOG2(n-1))+1 and set L=2**(k+1) then
!                     w must have dimension (k-2)*L+k+4+2n+max(2n,6m)
!
!       **Important** for purposes of checking, the required dimension
!                     of w is computed by blktri and STOR1D in w(1)
!                     in floating point format.
!
!     * * * * * * * * * *     ON OUTPUT     * * * * * * * * * *
!
!     y
!       contains the solution X.
!
!     Ierror
!       an error flag that indicates invalid input parameters.  Except
!       for number zero, a solution is not attempted.
!
!       = 0  No error.
!       = 1  m is less than 5
!       = 2  n is less than 3.
!       = 3  idimy is less than m.
!       = 4  blktri failed while computing results that depend on the
!            coefficient arrays an, bn, cn.  Check these arrays.
!       = 5  an(J)*cn(J-1) is less than 0 for some J. possible reasons
!            for this condition are
!            1. The arrays an and cn are not correct
!            2. Too large a grid spacing was used in the discretization
!               of the elliptic equation
!            3. The linear equations resulted from a partial
!               differential equation which was not elliptic
!
!     w
!       contains intermediate values that must not be destroyed if
!       blktri will be called again with iflg = 1  .
!
!
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
!
! Test m and n for the proper form
!
nm = n
ierror = 0
if (m - 5) 10, 20, 20
10 ierror = 1
go to 190
20 if (nm - 3) 30, 40, 40
30 ierror = 2
go to 190
40 if (idimy - m) 50, 60, 60
50 ierror = 3
go to 190
60 nh = n
npp = np
if (npp) 70, 80, 70
70 nh = nh + 1
80 ik = 2
k = 1
90 ik = ik + ik
k = k + 1
if (nh - ik) 100,100, 90
100 nl = ik
ik = ik + ik
nl = nl - 1
iwah = (k - 2)*ik + k + 6
if (npp) 110,120,110
!
!     Divide w into working sub arrays
!
110 iw1 = iwah
iwbh = iw1 + nm
w(1) = float(iw1 - 1 + max(2*nm,6*m))
go to 130
120 iwbh = iwah + nm + nm
iw1 = iwbh
w(1) = float(iw1 - 1 + max(2*nm,6*m))
nm = nm - 1
!
! Subroutine compb computes the roots of the B polynomials
!
130 if (ierror) 190,140,190
140 iw2 = iw1 + m
iw3 = iw2 + m
iwd = iw3 + m
iww = iwd + m
iwu = iww + m
if (iflg) 160,150,160
150 call compb(nl,ierror,an,bn,cn,w(2),w(iwah),w(iwbh))
go to 190
160 if (mp) 170,180,170
!
! Subroutine blktr1 solves the linear system
!
170 call blktr1(nl,an,bn,cn,m,am,bm,cm,idimy,y,w(2),w(iw1),w(iw2), &
   & w(iw3),w(iwd),w(iww),w(iwu),prod0,cprod0)
go to 190
180 call blktr1(nl,an,bn,cn,m,am,bm,cm,idimy,y,w(2),w(iw1),w(iw2), &
   & w(iw3),w(iwd),w(iww),w(iwu),prodp,cprodp)
190 continue
return
end subroutine blktri

subroutine blktr1(n,an,bn,cn,m,am,bm,cm,idimy,y,b,w1,w2,w3,wd, &
   & ww,wu,prdct,cprdct)
implicit none
integer :: idimy, m, n
real :: am(*), an(*), b(*), bm(*), bn(*), cm(*), cn(*), w1(*), &
   & w2(*), w3(*), wd(*), wu(*), ww(*), y(idimy,*)
integer :: i, i1, i2, i3, i4, idxa, idxc, if, ifd, im1, im2, im3, &
   & imi1, imi2, ip, ip1, ip2, ip3, ipi1, ipi2, ipi3, ir, irm1, iz, &
   & izr, j, kdo, l, ll, na, nc, nm1, nm2, nm3, np, np1, np2, np3, nz
real :: dum
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
!
! blktr1 solves the linear system
!
! b  contains the roots of all the b polynomials
! w1,W2,W3,WD,WW,WU  are all working arrays
! PRDCT is either prodp or prod0 depending on whether the boundary
! conditions in the m direction are periodic or not
! CPRDCT is either cprodp or cprod0 which are the complex versions
! of prodp and prod0. These are called in the event that some
! of the roots of the b sub P polynomial are complex
!
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
!
! Begin reduction phase
!
kdo = k - 1
do l = 1,kdo
   ir = l - 1
   i2 = 2**ir
   i1 = i2/2
   i3 = i2 + i1
   i4 = i2 + i2
   irm1 = ir - 1
   call indxb(i2,ir,im2,nm2)
   call indxb(i1,irm1,im3,nm3)
   call indxb(i3,irm1,im1,nm1)
   call prdct(nm2,b(im2),nm3,b(im3),nm1,b(im1),0,dum,y(1,i2),w3, &
      & m,am,bm,cm,wd,ww,wu)
   if = 2**k
   do 80 i = i4,if,i4
      if (i - nm) 10, 10, 80
10    ipi1 = i + i1
      ipi2 = i + i2
      ipi3 = i + i3
      call indxc(i,ir,idxc,nc)
      if (i - if) 20, 80, 80
20    call indxa(i,ir,idxa,na)
      call indxb(i - i1,irm1,im1,nm1)
      call indxb(ipi2,ir,ip2,np2)
      call indxb(ipi1,irm1,ip1,np1)
      call indxb(ipi3,irm1,ip3,np3)
      call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),w3,w1,m,am, &
         & bm,cm,wd,ww,wu)
      if (ipi2 - nm) 50, 50, 30
30    do j = 1,m
         w3(j) = 0.
         w2(j) = 0.
      end do
      go to  60
50    call prdct(np2,b(ip2),np1,b(ip1),np3,b(ip3),0,dum, &
         & y(1,ipi2),w3,m,am,bm,cm,wd,ww,wu)
      call prdct(np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w3,w2,m,am, &
         & bm,cm,wd,ww,wu)
60    do j = 1,m
         y(j,i) = w1(j) + w2(j) + y(j,i)
      end do
80    continue
end do
if (npp) 320,100,320
!
!     The periodic case is treated using the capacitance matrix method
!
100 if = 2**k
i = if/2
i1 = i/2
call indxb(i - i1,k - 2,im1,nm1)
call indxb(i + i1,k - 2,ip1,np1)
call indxb(i,k - 1,iz,nz)
call prdct(nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,y(1,i),w1,m,am, &
   & bm,cm,wd,ww,wu)
izr = i
do j = 1,m
   w2(j) = w1(j)
end do
do ll = 2,k
   l = k - ll + 1
   ir = l - 1
   i2 = 2**ir
   i1 = i2/2
   i = i2
   call indxc(i,ir,idxc,nc)
   call indxb(i,ir,iz,nz)
   call indxb(i - i1,ir - 1,im1,nm1)
   call indxb(i + i1,ir - 1,ip1,np1)
   call prdct(np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w1,w1,m,am,bm, &
      & cm,wd,ww,wu)
   do j = 1,m
      w1(j) = y(j,i) + w1(j)
   end do
   call prdct(nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w1,w1,m,am, &
      & bm,cm,wd,ww,wu)
end do
do 180 ll = 2,k
   l = k - ll + 1
   ir = l - 1
   i2 = 2**ir
   i1 = i2/2
   i4 = i2 + i2
   ifd = if - i2
   do 170 i = i2,ifd,i4
      if (i - i2 - izr) 170,140,170
140   if (i - nm) 150,150,180
150   call indxa(i,ir,idxa,na)
      call indxb(i,ir,iz,nz)
      call indxb(i - i1,ir - 1,im1,nm1)
      call indxb(i + i1,ir - 1,ip1,np1)
      call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),w2,w2,m,am, &
         & bm,cm,wd,ww,wu)
      do j = 1,m
         w2(j) = y(j,i) + w2(j)
      end do
      call prdct(nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w2,w2,m, &
         & am,bm,cm,wd,ww,wu)
      izr = i
      if (i - nm) 170,190,170
170   continue
180 continue
190 do j = 1,m
   y(j,nm + 1) = y(j,nm + 1) - cn(nm + 1)*w1(j) - an(nm + 1)*w2(j)
end do
call indxb(if/2,k - 1,im1,nm1)
call indxb(if,k - 1,ip,np)
if (ncmplx) 210,220,210
210 call cprdct(nm + 1,b(ip),nm1,b(im1),0,dum,0,dum,y(1,nm + 1), &
   & y(1,nm + 1),m,am,bm,cm,w1,w3,ww)
go to 230
220 call prdct(nm + 1,b(ip),nm1,b(im1),0,dum,0,dum,y(1,nm + 1), &
   & y(1,nm + 1),m,am,bm,cm,wd,ww,wu)
230 do j = 1,m
   w1(j) = an(1)*y(j,nm + 1)
   w2(j) = cn(nm)*y(j,nm + 1)
   y(j,1) = y(j,1) - w1(j)
   y(j,nm) = y(j,nm) - w2(j)
end do
do l = 1,kdo
   ir = l - 1
   i2 = 2**ir
   i4 = i2 + i2
   i1 = i2/2
   i = i4
   call indxa(i,ir,idxa,na)
   call indxb(i - i2,ir,im2,nm2)
   call indxb(i - i2 - i1,ir - 1,im3,nm3)
   call indxb(i - i1,ir - 1,im1,nm1)
   call prdct(nm2,b(im2),nm3,b(im3),nm1,b(im1),0,dum,w1,w1,m,am, &
      & bm,cm,wd,ww,wu)
   call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),w1,w1,m,am,bm, &
      & cm,wd,ww,wu)
   do j = 1,m
      y(j,i) = y(j,i) - w1(j)
   end do
end do
!
izr = nm
do 310 l = 1,kdo
   ir = l - 1
   i2 = 2**ir
   i1 = i2/2
   i3 = i2 + i1
   i4 = i2 + i2
   irm1 = ir - 1
   do 300 i = i4,if,i4
      ipi1 = i + i1
      ipi2 = i + i2
      ipi3 = i + i3
      if (ipi2 - izr) 270,280,270
270   if (i - izr) 300,310,300
280   call indxc(i,ir,idxc,nc)
      call indxb(ipi2,ir,ip2,np2)
      call indxb(ipi1,irm1,ip1,np1)
      call indxb(ipi3,irm1,ip3,np3)
      call prdct(np2,b(ip2),np1,b(ip1),np3,b(ip3),0,dum,w2,w2,m, &
         & am,bm,cm,wd,ww,wu)
      call prdct(np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w2,w2,m,am, &
         & bm,cm,wd,ww,wu)
      do j = 1,m
         y(j,i) = y(j,i) - w2(j)
      end do
      izr = i
      go to 310
300   continue
310 continue
!
! Begin back substitution phase
!
320 do ll = 1,k
   l = k - ll + 1
   ir = l - 1
   irm1 = ir - 1
   i2 = 2**ir
   i1 = i2/2
   i4 = i2 + i2
   ifd = if - i2
   do 430 i = i2,ifd,i4
      if (i - nm) 330,330,430
330   imi1 = i - i1
      imi2 = i - i2
      ipi1 = i + i1
      ipi2 = i + i2
      call indxa(i,ir,idxa,na)
      call indxc(i,ir,idxc,nc)
      call indxb(i,ir,iz,nz)
      call indxb(imi1,irm1,im1,nm1)
      call indxb(ipi1,irm1,ip1,np1)
      if (i - i2) 340,340,360
340   do j = 1,m
         w1(j) = 0.
      end do
      go to 370
360   call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),y(1,imi2), &
         & w1,m,am,bm,cm,wd,ww,wu)
370   if (ipi2 - nm) 400,400,380
380   do j = 1,m
         w2(j) = 0.
      end do
      go to 410
400   call prdct(np1,b(ip1),0,dum,0,dum,nc,cn(idxc),y(1,ipi2), &
         & w2,m,am,bm,cm,wd,ww,wu)
410   do j = 1,m
         w1(j) = y(j,i) + w1(j) + w2(j)
      end do
      call prdct(nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w1,y(1,i), &
         & m,am,bm,cm,wd,ww,wu)
430   continue
end do
return
end subroutine blktr1

subroutine indxa(i,ir,idxa,na)
implicit none
integer :: i, idxa, ir, na
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
!
na = 2**ir
idxa = i - na + 1
if (i - nm) 20, 20, 10
10 na = 0
20 return
end subroutine indxa

subroutine indxc(i,ir,idxc,nc)
implicit none
integer :: i, idxc, ir, nc
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
!
nc = 2**ir
idxc = i
if (idxc + nc - 1 - nm) 20, 20, 10
10 nc = 0
20 return
end subroutine indxc

subroutine indxb(i,ir,idx,idp)
implicit none
integer :: i, idp, idx, ir
integer :: id, ipl, izh
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
!
! B(idx) is the location of the first root of the B(i,ir) polynomial
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
!
idp = 0
if (ir) 70, 10, 30
10 if (i - nm) 20, 20, 70
20 idx = i
idp = 1
return
30 izh = 2**ir
id = i - izh - izh
idx = id + id + (ir - 1)*ik + ir + (ik - i)/izh + 4
ipl = izh - 1
idp = izh + izh - 1
if (i - ipl - nm) 50, 50, 40
40 idp = 0
return
50 if (i + ipl - nm) 70, 70, 60
60 idp = nm + ipl - i + 1
70 return
end subroutine indxb

subroutine prod0(nd,bd,nm1,bm1,nm2,bm2,na,aa,x,y,m,a,b,c,d,w,u)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bd(*), bm1(*), bm2(*), c(*)
real, intent(inout) :: d(*)
real :: u(*)
real, intent(inout) :: w(*)
real :: x(*)
real, intent(inout) :: y(*)
integer :: ia, ibr, id, j, k, m1, m2, mm
real :: den, rt
!
! prod0 applies a sequence of matrix operations to the vector x and
! stores the result in y.
!
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         THE LENGTH OF THE ARRAY aa.
! x,y        MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS y.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,w,u      WORKING ARRAYS.
! IS         DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
!
do j = 1,m
   w(j) = x(j)
   y(j) = w(j)
end do
mm = m - 1
id = nd
ibr = 0
m1 = nm1
m2 = nm2
ia = na
20 if (ia) 50, 50, 30
30 rt = aa(ia)
if (nd == 0) rt = -rt
ia = ia - 1
!
! Scalar multiplication
!
do j = 1,m
   y(j) = rt*w(j)
end do
50 if (id) 250,250, 60
60 rt = bd(id)
id = id - 1
if (id == 0) ibr = 1
!
! Begin solution to system
!
d(m) = a(m)/(b(m) - rt)
w(m) = y(m)/(b(m) - rt)
do j = 2,mm
   k = m - j
   den = b(k + 1) - rt - c(k + 1)*d(k + 2)
   d(k + 1) = a(k + 1)/den
   w(k + 1) = (y(k + 1) - c(k + 1)*w(k + 2))/den
end do
den = b(1) - rt - c(1)*d(2)
w(1) = 1.
if (den) 80, 90, 80
80 w(1) = (y(1) - c(1)*w(2))/den
90 do j = 2,m
   w(j) = w(j) - d(j)*w(j - 1)
end do
if (na) 130,130, 20
110 do j = 1,m
   y(j) = w(j)
end do
ibr = 1
go to  20
130 if (m1) 140,140,150
140 if (m2) 110,110,200
150 if (m2) 170,170,160
160 if (abs(bm1(m1)) - abs(bm2(m2))) 200,200,170
170 if (ibr) 180,180,190
180 if (abs(bm1(m1) - bd(id)) - abs(bm1(m1) - rt)) 110,190,190
190 rt = rt - bm1(m1)
m1 = m1 - 1
go to 230
200 if (ibr) 210,210,220
210 if (abs(bm2(m2) - bd(id)) - abs(bm2(m2) - rt)) 110,220,220
220 rt = rt - bm2(m2)
m2 = m2 - 1
230 do j = 1,m
   y(j) = y(j) + rt*w(j)
end do
go to  20
250 return
end subroutine prod0

subroutine prodp(nd,bd,nm1,bm1,nm2,bm2,na,aa,x,y,m,a,b,c,d,u,w)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bd(*), bm1(*), bm2(*), c(*)
real, intent(inout) :: d(*), u(*), w(*)
real :: x(*)
real, intent(inout) :: y(*)
integer :: ia, ibr, id, j, k, m1, m2, mm, mm2
real :: am, bh, den, rt, v, ym
!
! prodp applies a sequence of matrix operations to the vector x and
! STORES THE RESULT IN y.   (PERIODIC BOUNDARY CONDITIONS)
!
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         LENGTH OF THE ARRAY aa.
! x,y        MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS y.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,u,w      WORKING ARRAYS.
! IS         DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
!
do j = 1,m
   y(j) = x(j)
   w(j) = y(j)
end do
mm = m - 1
mm2 = m - 2
id = nd
ibr = 0
m1 = nm1
m2 = nm2
ia = na
20 if (ia) 50, 50, 30
30 rt = aa(ia)
if (nd == 0) rt = -rt
ia = ia - 1
do j = 1,m
   y(j) = rt*w(j)
end do
50 if (id) 280,280, 60
60 rt = bd(id)
id = id - 1
if (id == 0) ibr = 1
!
! Begin solution to system
!
bh = b(m) - rt
ym = y(m)
den = b(1) - rt
d(1) = c(1)/den
u(1) = a(1)/den
w(1) = y(1)/den
v = c(m)
if (mm2 - 2) 90, 70, 70
70 do j = 2,mm2
   den = b(j) - rt - a(j)*d(j - 1)
   d(j) = c(j)/den
   u(j) = -a(j)*u(j - 1)/den
   w(j) = (y(j) - a(j)*w(j - 1))/den
   bh = bh - v*u(j - 1)
   ym = ym - v*w(j - 1)
   v = -v*d(j - 1)
end do
90 den = b(m - 1) - rt - a(m - 1)*d(m - 2)
d(m - 1) = (c(m - 1) - a(m - 1)*u(m - 2))/den
w(m - 1) = (y(m - 1) - a(m - 1)*w(m - 2))/den
am = a(m) - v*d(m - 2)
bh = bh - v*u(m - 2)
ym = ym - v*w(m - 2)
den = bh - am*d(m - 1)
if (den) 100,110,100
100 w(m) = (ym - am*w(m - 1))/den
go to 120
110 w(m) = 1.
120 w(m - 1) = w(m - 1) - d(m - 1)*w(m)
do j = 2,mm
   k = m - j
   w(k) = w(k) - d(k)*w(k + 1) - u(k)*w(m)
end do
if (na) 160,160, 20
140 do j = 1,m
   y(j) = w(j)
end do
ibr = 1
go to  20
160 if (m1) 170,170,180
170 if (m2) 140,140,230
180 if (m2) 200,200,190
190 if (abs(bm1(m1)) - abs(bm2(m2))) 230,230,200
200 if (ibr) 210,210,220
210 if (abs(bm1(m1) - bd(id)) - abs(bm1(m1) - rt)) 140,220,220
220 rt = rt - bm1(m1)
m1 = m1 - 1
go to 260
230 if (ibr) 240,240,250
240 if (abs(bm2(m2) - bd(id)) - abs(bm2(m2) - rt)) 140,250,250
250 rt = rt - bm2(m2)
m2 = m2 - 1
260 do j = 1,m
   y(j) = y(j) + rt*w(j)
end do
go to  20
280 return
end subroutine prodp

subroutine cprod0(nd,bd,nm1,bm1,nm2,bm2,na,aa,x,yy,m,a,b,c,d,w,y)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bm1(*), bm2(*), c(*), x(*)
real, intent(inout) :: yy(*)
complex, intent(inout) :: y(*), d(*), w(*)
complex :: bd(*)
integer :: ia, id, iflg, j, k, m1, m2, mm
real :: rt
complex :: crt, den, y1, y2
!
! cprod0 applies a sequence of matrix operations to the vector x and
! STORES THE RESULT IN yy.   (COMPLEX CASE)
!
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! na         THE LENGTH OF THE ARRAY aa.
! x,yy       MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS yy.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,w,y      WORKING ARRAYS.
! ISGN       DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
!
do j = 1,m
   y(j) = cmplx(x(j),0.)
end do
mm = m - 1
id = nd
m1 = nm1
m2 = nm2
ia = na
20 iflg = 0
if (id) 90, 90, 30
30 crt = bd(id)
id = id - 1
!
! Begin solution to system
!
d(m) = a(m)/(b(m) - crt)
w(m) = y(m)/(b(m) - crt)
do j = 2,mm
   k = m - j
   den = b(k + 1) - crt - c(k + 1)*d(k + 2)
   d(k + 1) = a(k + 1)/den
   w(k + 1) = (y(k + 1) - c(k + 1)*w(k + 2))/den
end do
den = b(1) - crt - c(1)*d(2)
if (abs(den)) 50, 60, 50
50 y(1) = (y(1) - c(1)*w(2))/den
go to  70
60 y(1) = (1.,0.)
70 do j = 2,m
   y(j) = w(j) - d(j)*y(j - 1)
end do
90 if (m1) 100,100,120
100 if (m2) 210,210,110
110 rt = bm2(m2)
m2 = m2 - 1
go to 170
120 if (m2) 130,130,140
130 rt = bm1(m1)
m1 = m1 - 1
go to 170
140 if (abs(bm1(m1)) - abs(bm2(m2))) 160,160,150
150 rt = bm1(m1)
m1 = m1 - 1
go to 170
160 rt = bm2(m2)
m2 = m2 - 1
170 y1 = (b(1) - rt)*y(1) + c(1)*y(2)
if (mm - 2) 200,180,180
!
! Matrix multiplication
!
180 do j = 2,mm
   y2 = a(j)*y(j - 1) + (b(j) - rt)*y(j) + c(j)*y(j + 1)
   y(j - 1) = y1
   y1 = y2
end do
200 y(m) = a(m)*y(m - 1) + (b(m) - rt)*y(m)
y(m - 1) = y1
iflg = 1
go to  20
210 if (ia) 240,240,220
220 rt = aa(ia)
ia = ia - 1
iflg = 1
!
! Scalar multiplication
!
do j = 1,m
   y(j) = rt*y(j)
end do
240 if (iflg) 250,250, 20
250 do j = 1,m
   yy(j) = real(y(j))
end do
return
end subroutine cprod0

subroutine cprodp(nd,bd,nm1,bm1,nm2,bm2,na,aa,x,yy,m,a,b,c,d,u,y)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bm1(*), bm2(*), c(*), x(*)
real, intent(inout) :: yy(*)
complex, intent(inout) :: y(*), d(*), u(*)
complex :: bd(*)
integer :: ia, id, iflg, j, k, m1, m2, mm, mm2
real :: rt
complex :: v, den, bh, ym, am, y1, y2, yh, crt
!
! prodp applies a sequence of matrix operations to the vector x and
! stores the result in yy.  (Periodic boundary conditions and
! complex case)
!
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         THE LENGTH OF THE ARRAY aa.
! x,yy       MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS yy.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,u,y      WORKING ARRAYS.
! ISGN       DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
!
!
do j = 1,m
   y(j) = cmplx(x(j),0.)
end do
mm = m - 1
mm2 = m - 2
id = nd
m1 = nm1
m2 = nm2
ia = na
20 iflg = 0
if (id) 110,110, 30
30 crt = bd(id)
id = id - 1
iflg = 1
!
! Begin solution to system
!
bh = b(m) - crt
ym = y(m)
den = b(1) - crt
d(1) = c(1)/den
u(1) = a(1)/den
y(1) = y(1)/den
v = cmplx(c(m),0.)
if (mm2 - 2) 60, 40, 40
40 do j = 2,mm2
   den = b(j) - crt - a(j)*d(j - 1)
   d(j) = c(j)/den
   u(j) = -a(j)*u(j - 1)/den
   y(j) = (y(j) - a(j)*y(j - 1))/den
   bh = bh - v*u(j - 1)
   ym = ym - v*y(j - 1)
   v = -v*d(j - 1)
end do
60 den = b(m - 1) - crt - a(m - 1)*d(m - 2)
d(m - 1) = (c(m - 1) - a(m - 1)*u(m - 2))/den
y(m - 1) = (y(m - 1) - a(m - 1)*y(m - 2))/den
am = a(m) - v*d(m - 2)
bh = bh - v*u(m - 2)
ym = ym - v*y(m - 2)
den = bh - am*d(m - 1)
if (abs(den)) 70, 80, 70
70 y(m) = (ym - am*y(m - 1))/den
go to  90
80 y(m) = (1.,0.)
90 y(m - 1) = y(m - 1) - d(m - 1)*y(m)
do j = 2,mm
   k = m - j
   y(k) = y(k) - d(k)*y(k + 1) - u(k)*y(m)
end do
110 if (m1) 120,120,140
120 if (m2) 230,230,130
130 rt = bm2(m2)
m2 = m2 - 1
go to 190
140 if (m2) 150,150,160
150 rt = bm1(m1)
m1 = m1 - 1
go to 190
160 if (abs(bm1(m1)) - abs(bm2(m2))) 180,180,170
170 rt = bm1(m1)
m1 = m1 - 1
go to 190
180 rt = bm2(m2)
m2 = m2 - 1
!
! Matrix multiplication
!
190 yh = y(1)
y1 = (b(1) - rt)*y(1) + c(1)*y(2) + a(1)*y(m)
if (mm - 2) 220,200,200
200 do j = 2,mm
   y2 = a(j)*y(j - 1) + (b(j) - rt)*y(j) + c(j)*y(j + 1)
   y(j - 1) = y1
   y1 = y2
end do
220 y(m) = a(m)*y(m - 1) + (b(m) - rt)*y(m) + c(m)*yh
y(m - 1) = y1
iflg = 1
go to  20
230 if (ia) 260,260,240
240 rt = aa(ia)
ia = ia - 1
iflg = 1
!
! Scalar multiplication
!
do j = 1,m
   y(j) = rt*y(j)
end do
260 if (iflg) 270,270, 20
270 do j = 1,m
   yy(j) = real(y(j))
end do
return
end subroutine cprodp

subroutine compb(n,ierror,an,bn,cn,b,ah,bh)
implicit none
integer :: ierror, n
real :: ah(*), an(*), b(*), bh(*), bn(*), cn(*)
integer :: i, i2, i4, ib, if, ifd, ipl, ir, j, j1, j2, jf, js, &
   & kdo, l, l1, l2, lh, ls, n2m2, nb, nmp
real :: arg, bnorm, d1, d2, d3
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
complex, allocatable :: root_complex(:)
real, allocatable :: root_real(:)
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!
!     compb computes the roots of the b polynomials using tqlrt0,
!     which is a modification of the EISPACK subroutine tqlrat.
!     Ierror is set to 4 if either tqlrt0 fails or A(j+1)*C(j) is
!     less than 0 for some j. ah and bh are temporary work arrays.
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
!
eps = spmpar(1)
bnorm = abs(bn(1))
do j = 2,nm
   bnorm = max(bnorm,abs(bn(j)))
   arg = an(j)*cn(j - 1)
   if (arg) 220, 30, 30
30 b(j) = sign(sqrt(arg),an(j))
end do
cnv = eps*bnorm
if = 2**k
kdo = k - 1
do 100 l = 1,kdo
   ir = l - 1
   i2 = 2**ir
   i4 = i2 + i2
   ipl = i4 - 1
   ifd = if - i4
   do i = i4,ifd,i4
      call indxb(i,l,ib,nb)
      if (nb) 100,100, 50
50    js = i - ipl
      jf = js + nb - 1
      ls = 0
      do j = js,jf
         ls = ls + 1
         bh(ls) = bn(j)
         ah(ls) = b(j)
      end do
      call tqlrt0(nb,bh,ah,ierror)
      if (ierror) 210, 70,210
70    lh = ib - 1
      do j = 1,nb
         lh = lh + 1
         b(lh) = -bh(j)
      end do
   end do
100 continue
do j = 1,nm
   b(j) = -bn(j)
end do
if (npp /= 0) return
!
nmp = nm + 1
nb = nm + nmp
do j = 1,nb
   l1 = mod(j - 1,nmp) + 1
   l2 = mod(j + nm - 1,nmp) + 1
   arg = an(l1)*cn(l2)
   if (arg < 0.0) go to 220
   bh(j) = sign(sqrt(arg),-an(l1))
   ah(j) = -bn(l1)
end do
call tqlrt0(nb,ah,bh,ierror)
if (ierror /= 0) go to 210
!
call indxb(if,k - 1,j2,lh)
call indxb(if/2,k - 1,j1,lh)
j2 = j2 + 1
lh = j2
n2m2 = j2 + nm + nm - 2
170 d1 = abs(b(j1) - b(j2 - 1))
d2 = abs(b(j1) - b(j2))
d3 = abs(b(j1) - b(j2 + 1))
if ((d2 < d1) .and. (d2 < d3)) go to 180
b(lh) = b(j2)
j2 = j2 + 1
lh = lh + 1
if (j2 - n2m2) 170,170,190
180 j2 = j2 + 1
j1 = j1 + 1
if (j2 - n2m2) 170,170,190
190 b(lh) = b(n2m2 + 1)
call indxb(if,k - 1,j1,j2)
j2 = j1 + nmp + nmp
allocate(root_complex(nmp),root_real(nmp))
root_real = b(j1:j1 + nm)
call ppadd(nmp,ierror,an,cn,root_complex,root_real,b(j2))
if (ierror /= 0) return
b(j1:j1 + 2*nmp - 1) = transfer(root_complex,b(j1),2*nmp)
if (ncmplx == 0) then
   root_real(1) = real(root_complex(1))
   b(j1:j1 + nm) = root_real
end if
return
!
!     Error return
!
210 ierror = 4
return
220 ierror = 5
return
end subroutine compb

subroutine tqlrt0(n,d,e2,ierr)
implicit none
integer :: n, ierr
real :: d(n), e2(n)
integer :: nhalf, ntop
real :: dhold
integer :: ik, k, ncmplx, nm, npp
real :: cnv
integer :: i, j, l, m, ii, l1, mml
real :: b, c, f, g, h, p, r, s, machep
!
!
common /cblkt/  npp        ,k          ,machep     ,cnv        , &
   & nm         ,ncmplx     ,ik
!
!
!     This subroutine is a modification of the EISPACK subroutine
!     tqlrat. The subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the rational QL method.
!
!     On input-
!
!        n is the order of the matrix,
!
!        d contains the diagonal elements of the input matrix,
!
!        e2 CONTAINS THE                SUBDIAGONAL ELEMENTS OF THE
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
!                     determined after 30 iterations.
!
!
!     ********** machep is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
!
!                **********
!
ierr = 0
if (n == 1) go to 150
!
do i = 2,n
   e2(i - 1) = e2(i)*e2(i)
end do
!
f = 0.0
b = 0.0
e2(n) = 0.0
!
do l = 1,n
   j = 0
   h = machep*(abs(d(l)) + sqrt(e2(l)))
   if (b > h) go to  20
   b = h
   c = b*b
!
!     ********** Look for small squared sub-diagonal element **********
!
20 do 30 m = l,n
      if (e2(m) <= c) go to  40
!
!     ********** e2(n) is always zero, so there is no exit
!                through the bottom of the loop **********
!
30    continue
!
40 if (m == l) go to  80
50 if (j == 30) go to 140
   j = j + 1
!
!     ********** Form shift **********
!
   l1 = l + 1
   s = sqrt(e2(l))
   g = d(l)
   p = (d(l1) - g)/(2.0*s)
   r = sqrt(p*p + 1.0)
   d(l) = s/(p + sign(r,p))
   h = g - d(l)
!
   do i = l1,n
      d(i) = d(i) - h
   end do
!
   f = f + h
!
!     ********** RATIONAL QL TRANSFORMATION **********
!
   g = d(m)
   if (g == 0.0) g = b
   h = g
   s = 0.0
   mml = m - l
!
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
!
   do ii = 1,mml
      i = m - ii
      p = g*h
      r = p + e2(i)
      e2(i + 1) = s*r
      s = e2(i)/r
      d(i + 1) = h + s*(h + d(i))
      g = d(i) - e2(i)/g
      if (g == 0.0) g = b
      h = g*p/r
   end do
!
   e2(l) = s*g
   d(l) = h
!
!     ********** Guard against UNDERFLOWED h **********
!
   if (h == 0.0) go to  80
   if (abs(e2(l)) <= abs(c/h)) go to  80
   e2(l) = h*e2(l)
   if (e2(l) /= 0.0) go to  50
80 p = d(l) + f
!
!     ********** Order eigenvalues **********
!
   if (l == 1) go to 100
!
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
!
   do ii = 2,l
      i = l + 2 - ii
      if (p >= d(i - 1)) go to 110
      d(i) = d(i - 1)
   end do
!
100 i = 1
110 d(i) = p
end do
!
if (abs(d(n)) >= abs(d(1))) go to 150
nhalf = n/2
do i = 1,nhalf
   ntop = n - i
   dhold = d(i)
   d(i) = d(ntop + 1)
   d(ntop + 1) = dhold
end do
go to 150
!
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
!
140 ierr = l
150 return
end subroutine tqlrt0

subroutine ppadd(n,ierror,a,c,cbp,bp,bh)
implicit none
integer :: ierror, n
real :: a(*), bh(*), bp(*), c(*)
complex :: cbp(*)
integer :: i2, i3, icv, if, ig, is, it, iz, izm, izm2, j, modiz, &
   & nhalf, nt
real :: db, psg, scnv, sgn, xl, xm, xr
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
real :: ppsgf
real :: ppspf
real :: bsrh
real :: psgf
complex :: cf, cx, fsg, hsg, dd, f, fp, fpp, cdis, r1, r2, r3
external psgf, ppspf, ppsgf
!
!     ppadd computes the eigenvalues of the periodic tridiagonal matrix
!     with coefficients an,BN,CN
!
! n   IS THE ORDER OF THE bh AND bp POLYNOMIALS.
!     On output bp contains the eigenvalues.
! cbp is the same as bp except type complex.
! bh  is used to temporarily store the roots of the B hat polynomial
!     which enters through bp.
!
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
!
scnv = sqrt(cnv)
iz = n
izm = iz - 1
izm2 = iz - 2
if (bp(n) - bp(1)) 10,420, 30
10 do j = 1,n
   nt = n - j
   bh(j) = bp(nt + 1)
end do
go to  50
30 do j = 1,n
   bh(j) = bp(j)
end do
50 ncmplx = 0
modiz = mod(iz,2)
is = 1
if (modiz) 60, 70, 60
60 if (a(1)) 100,420, 70
70 xl = bh(1)
db = bh(3) - bh(1)
80 xl = xl - db
if (psgf(xl,iz,c,a,bh)) 80, 80, 90
90 sgn = -1.
cbp(1) = cmplx(bsrh(xl,bh(1),iz,c,a,bh,psgf,sgn),0.)
is = 2
100 if = iz - 1
if (modiz) 110,120,110
110 if (a(1)) 120,420,150
120 xr = bh(iz)
db = bh(iz) - bh(iz - 2)
130 xr = xr + db
if (psgf(xr,iz,c,a,bh)) 130,140,140
140 sgn = 1.
cbp(iz) = cmplx(bsrh(bh(iz),xr,iz,c,a,bh,psgf,sgn),0.)
if = iz - 2
150 do 360 ig = is,if,2
   xl = bh(ig)
   xr = bh(ig + 1)
   sgn = -1.
   xm = bsrh(xl,xr,iz,c,a,bh,ppspf,sgn)
   psg = psgf(xm,iz,c,a,bh)
   if (abs(psg) - eps) 180,180,160
160 if (psg*ppsgf(xm,iz,c,a,bh)) 170,180,190
!
!     Case of a real zero
!
170 sgn = 1.
   cbp(ig) = cmplx(bsrh(bh(ig),xm,iz,c,a,bh,psgf,sgn),0.)
   sgn = -1.
   cbp(ig + 1) = cmplx(bsrh(xm,bh(ig + 1),iz,c,a,bh,psgf,sgn),0.)
   go to 360
!
!     Case of a multiple zero
!
180 cbp(ig) = cmplx(xm,0.)
   cbp(ig + 1) = cmplx(xm,0.)
   go to 360
!
!     Case of a complex zero
!
190 it = 0
   icv = 0
   cx = cmplx(xm,0.)
200 fsg = (1.,0.)
   hsg = (1.,0.)
   fp = (0.,0.)
   fpp = (0.,0.)
   do j = 1,iz
      dd = 1./(cx - bh(j))
      fsg = fsg*a(j)*dd
      hsg = hsg*c(j)*dd
      fp = fp + dd
      fpp = fpp - dd*dd
   end do
   if (modiz) 230,220,230
220 f = (1.,0.) - fsg - hsg
   go to 240
230 f = (1.,0.) + fsg + hsg
240 i3 = 0
   if (abs(fp)) 260,260,250
250 i3 = 1
   r3 = -f/fp
260 i2 = 0
   if (abs(fpp)) 320,320,270
270 i2 = 1
   cdis = sqrt(fp**2 - 2.*f*fpp)
   r1 = cdis - fp
   r2 = -fp - cdis
   if (abs(r1) - abs(r2)) 290,290,280
280 r1 = r1/fpp
   go to 300
290 r1 = r2/fpp
300 r2 = 2.*f/fpp/r1
   if (abs(r2) < abs(r1)) r1 = r2
   if (i3) 330,330,310
310 if (abs(r3) < abs(r1)) r1 = r3
   go to 330
320 r1 = r3
330 cx = cx + r1
   it = it + 1
   if (it > 50) go to 420
   if (abs(r1) > scnv) go to 200
   if (icv) 340,340,350
340 icv = 1
   go to 200
350 cbp(ig) = cx
   cbp(ig + 1) = conjg(cx)
360 continue
if (abs(cbp(n)) - abs(cbp(1))) 370,420,390
370 nhalf = n/2
do j = 1,nhalf
   nt = n - j
   cx = cbp(j)
   cbp(j) = cbp(nt + 1)
   cbp(nt + 1) = cx
end do
390 ncmplx = 1
do 400 j = 2,iz
   if (aimag(cbp(j))) 430,400,430
400 continue
ncmplx = 0
do j = 2,iz
   bp(j) = real(cbp(j))
end do
go to 430
420 ierror = 4
430 continue
return
end subroutine ppadd

function psgf(x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
integer :: j
real :: dd, fsg, hsg
real :: psgf
fsg = 1.
hsg = 1.
do j = 1,iz
   dd = 1./(x - bh(j))
   fsg = fsg*a(j)*dd
   hsg = hsg*c(j)*dd
end do
if (mod(iz,2)) 30, 20, 30
20 psgf = 1. - fsg - hsg
return
30 psgf = 1. + fsg + hsg
return
end function psgf

function bsrh(xll,xrr,iz,c,a,bh,f,sgn)
implicit none
integer :: iz
real :: a(*), bh(*), c(*), sgn, xll, xrr
real :: f
real :: dx, x, xl, xr
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
real :: bsrh
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
xl = xll
xr = xrr
dx = .5*abs(xr - xl)
10 x = .5*(xl + xr)
if (sgn*f(x,iz,c,a,bh)) 30, 50, 20
20 xr = x
go to  40
30 xl = x
40 dx = .5*dx
if (dx - cnv) 50, 50, 10
50 bsrh = .5*(xl + xr)
return
end function bsrh

function ppsgf(x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
integer :: j
real :: sum
real :: ppsgf
sum = 0.
do j = 1,iz
   sum = sum - 1./(x - bh(j))**2
end do
ppsgf = sum
return
end function ppsgf

function ppspf(x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
integer :: j
real :: sum
real :: ppspf
sum = 0.
do j = 1,iz
   sum = sum + 1./(x - bh(j))
end do
ppspf = sum
return
end function ppspf

pure subroutine urget(n, ibeg, iend, ix, l, ierr)
implicit none
integer, intent(in) :: ibeg, iend
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer, intent(inout) :: l(n)
integer :: i, k, leftlo
integer :: fhi, xalo, xhi
double precision :: c, m, t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
double precision, parameter :: s = .4656612877413d-09
!-----------------------------------------------------------------------
!
!               Uniform random selection of values from
!                       a finite set of integers
!
!                           ----------------
!
!     urget selects n values from the set of integers from ibeg to
!     iend where ibeg .LT. iend. The selection is performed so that
!     any integer is equally likely to occur with proability 1/m
!     where m = iend - ibeg + 1. As n becomes large the mean and
!     variance of the values will closely approximate the mean and
!     variance of the discrete uniform distribution where
!
!               mean = ibeg + (iend - ibeg)/2
!
!               variance = (m**2 - 1)/12 .
!
!     Input...
!
!       n     - Number of variates to be generated
!       ibeg  - Lower limit of generation interval
!       iend  - Upper limit of generation interval
!       ix    - Integer seed used to initialize the
!               sequence of variates generated
!
!     Output...
!
!       ix    - Seed for obtaining more variates
!       l     - Output array of dimension n containing
!               the generated integers
!       ierr  - Input error flag
!               ( 0 - No input errors
!                 1 - n .LE. 0
!                 2 - ibeg .GE. iend  OR  m .GE. p.
!                 3 - Seed out of range )
!
!-----------------------------------------------------------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     s = 1/(p-1)   (it is assumed that the arithmetic being
!                    used is accurate to at least 14 digits.
!                    s has been set to a value slightly less
!                    than 1/(p-1) to ensure that rounding
!                    error does not produce variates that
!                    EXCEED iend.)
!-------------------
!-------------------
if (n <= 0) go to 100
if (ibeg >= iend) go to 110
if (ix <= 0 .or. ix >= p) go to 120
m = iend - ibeg + 1
t = p
if (m >= t) go to 110
!
ierr = 0
c = m*s
do i = 1,n
!
!        Use the linus schrage code to obtain the next seed ix.
!
!        Reference. Schrage, linus, a more portable Fortran
!        random number generator, ACM Trans. Math Software 5
!        (1979), PP. 132-138.
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
!
!        Map ix to an integer in the closed interval (ibeg,iend).
!        This mapping is 1-1 only when m = p - 1, in which case
!        ix is mapped to the value (ibeg - 1) + ix.
!
   t = ix
   k = c*t
   l(i) = ibeg + k
end do
return
!
!                         Error return
!
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
end subroutine urget

pure subroutine urng(ix, x, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: x(n)
integer :: k, l, leftlo
real :: t
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
real, parameter :: s = .465661e-09
!-----------------------------------------------------------------------
!         Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     It is assumed that 0 .LT. ix .LT. p
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
!-------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= p) go to 110
ierr = 0
do l = 1,n
!
!                 Get 15 high order bits of ix
!
   xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
   xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
   leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
   fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
   k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
   if (ix < 0) ix = ix + p
!
!     Rescale ix, to interpret it as a value between 0 and 1.
!     The scale factor s is selected to be as near 1/p as is
!     appropriate in order that the floating value for ix = 1,
!     namely s, be roughly the same distance from 0 as (p-1)*s
!     is from 1. The current value for s assures us that x(l)
!     is less than 1 for any floating point arithmetic of 6
!     or more digits.
!
   t = ix
   x(l) = s*t
end do
return
!
!                         Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine urng

pure subroutine durng(ix, x, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: x(n)
integer :: k, l, leftlo
integer :: fhi, xalo, xhi
double precision :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
double precision, parameter :: s = .465661d-09
!-----------------------------------------------------------------------
!         Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     It is assumed that 0 .LT. ix .LT. p
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
!-------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= p) go to 110
ierr = 0
do l = 1,n
!
!                 Get 15 high order bits of ix
!
   xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
   xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
   leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
   fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
   k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
   if (ix < 0) ix = ix + p
!
!     Rescale ix, to interpret it as a value between 0 and 1.
!     The scale factor s is selected to be as near 1/p as is
!     appropriate in order that the floating value for ix = 1,
!     namely s, be roughly the same distance from 0 as (p-1)*s
!     is from 1. The current value for s assures us that x(l)
!     is less than 1 for any double precision arithmetic.
!
   t = ix
   x(l) = s*t
end do
return
!
!                         Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine durng

pure elemental subroutine urng0(ix, u, v)
implicit none
integer, intent(inout) :: ix
real, intent(inout) :: u, v
integer :: k, leftlo
real :: t
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u is the uniform variate that is generated and v = 1 - u.
!     u and v are positive. It is assumed that 1 .LE. ix .LT. p.
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix < 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
!
t = p
if (ix > p0) go to 10
u = ix
u = u/t
v = 0.5 + (0.5 - u)
return
10 v = p - ix
v = v/t
u = 0.5 + (0.5 - v)
return
end subroutine urng0

pure elemental subroutine durng0(ix, u, v)
implicit none
integer, intent(inout) :: ix
double precision, intent(inout) :: u, v
integer :: k, leftlo
double precision :: t
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u is the uniform variate that is generated and v = 1 - u.
!     u and v are positive. It is assumed that 1 .LE. ix .LT. p.
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix < 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
!
t = p
if (ix > p0) go to 10
u = ix
u = u/t
v = 0.5d0 + (0.5d0 - u)
return
10 v = p - ix
v = v/t
u = 0.5d0 + (0.5d0 - v)
return
end subroutine durng0

pure elemental subroutine urng1(ix, u, v, d)
implicit none
integer, intent(inout) :: ix
real, intent(inout) :: d, u, v
integer :: j, k, leftlo
real :: t
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u is the uniform variate that is generated and v = 1 - u.
!     u and v are positive and d = u - 0.5. It is assumed that
!     1 .LE. ix .LT. p.
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix < 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
!
j = p - ix
t = p
d = ix - j
d = 0.5*(d/t)
if (ix > p0) go to 10
u = ix
u = u/t
v = 0.5 + (0.5 - u)
return
10 v = j
v = v/t
u = 0.5 + (0.5 - v)
return
end subroutine urng1

pure elemental subroutine durng1(ix, u, v, d)
implicit none
integer, intent(inout) :: ix
double precision, intent(inout) :: u, v, d
integer :: j, k, leftlo
double precision :: t
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!
!                       ix = ix*a MOD p
!
!     u is the uniform variate that is generated and v = 1 - u.
!     u and v are positive and d = u - 0.5. It is assumed that
!     1 .LE. ix .LT. p.
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     data p0/2**30 - 1/
!-------------------
!-------------------
!
!                 Get 15 high order bits of ix
!
xhi = ix/b16
!
!           Get 16 lower bits of ix and multiply with A
!
xalo = (ix - xhi*b16)*a
!
!             Get 15 high order bits of the product
!
leftlo = xalo/b16
!
!               Form the 31 highest bits of a*ix
!
fhi = xhi*a + leftlo
!
!           Obtain the overflow past the 31ST bit of a*ix
!
k = fhi/b15
!
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
!
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!
!                      Add p if necessary
!
if (ix < 0) ix = ix + p
!
!         Rescale ix, to interpret it as a value between 0 and 1
!
j = p - ix
t = p
d = ix - j
d = 0.5d0*(d/t)
if (ix > p0) go to 10
u = ix
u = u/t
v = 0.5d0 + (0.5d0 - u)
return
10 v = j
v = v/t
u = 0.5d0 + (0.5d0 - v)
return
end subroutine durng1

pure subroutine urng2(ix, x, y, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: x(n), y(n)
integer :: k, l, leftlo
real :: t
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
real, parameter :: s = .465661e-09
!-----------------------------------------------------------------------
!
!         Generation of uniform random points (x(I),y(I))
!                     FOR I = 1,...,n WHERE
!
!                      0 .LT. x(I) .LT. 1
!                      0 .LT. y(I) .LT. 1
!
!     It is assumed that 0 .LT. ix .LT. p
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
!-------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= p) go to 110
ierr = 0
!
!         See the comments in the subroutine urng for the
!                statements in the following loop
!
do l = 1,n
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   t = ix
   x(l) = s*t
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   t = ix
   y(l) = s*t
end do
return
!
!                         Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine urng2

pure subroutine durng2(ix, x, y, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: x(n), y(n)
integer :: k, l, leftlo
double precision :: t
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
double precision, parameter :: s = .465661d-09
!-----------------------------------------------------------------------
!
!         Generation of uniform random points (x(I),y(I))
!                     FOR I = 1,...,n WHERE
!
!                      0 .LT. x(I) .LT. 1
!                      0 .LT. y(I) .LT. 1
!
!     It is assumed that 0 .LT. ix .LT. p
!-----------------------------------------------------------------------
!     Written by
!        linus schrage
!        University of Chicago
!     adapted by A.H. Morris (NSWC)
!-------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!-------------------
!-------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= p) go to 110
ierr = 0
!
!         See the comments in the subroutine durng for the
!                 statements in the following loop
!
do l = 1,n
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   t = ix
   x(l) = s*t
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   t = ix
   y(l) = s*t
end do
return
!
!                         Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine durng2

pure subroutine rcir(n, ix, x, y, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: x(n), y(n)
interface
   pure subroutine rcir1(n,ix,x,kx,y,ky,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      real, intent(inout) :: x(*)
      integer, intent(in) :: kx
      real, intent(inout) :: y(*)
      integer, intent(in) :: ky
      integer, intent(inout) :: ierr
   end subroutine rcir1
end interface
!-----------------------------------------------------------------------
!
!          Generation of n uniform random points (x(I),y(I))
!              in the unit circle centered at the origin
!
!-----------------------------------------------------------------------
!------------------
call rcir1(n, ix, x, 1, y, 1, ierr)
return
end subroutine rcir

pure subroutine rcir1(n, ix, x, kx, y, ky, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, ky, n
real, intent(inout) :: x(*), y(*)
integer :: i, i1, i2, j, k, leftlo
real :: r, u, v
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
real, parameter :: s = .931322e-09
!-----------------------------------------------------------------------
!
!      Generation of n uniform random points in the unit circle
!      centered at the origin. The abscissa and ordinate of the
!      i-TH point are stored in x(i1) and y(i2) where
!
!                      i1 = 1 + kx*(i - 1)
!                      i2 = 1 + ky*(i - 1) .
!
!-----------------------------------------------------------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     p0 = 2**30 - 1
!     s  = 2/p
!-------------------
!-------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= p) go to 110
ierr = 0
!
i1 = 1
i2 = 1
do i = 1,n
!
!        Use the linus schrage code to obtain new seeds ix.
!
!        Reference. Schrage, linus, a more portable Fortran
!        random number generator, ACM Trans. Math Software 5
!        (1979), PP. 132-138.
!
10 xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   j = ix
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
!
!        Subtract the midpoint p0 and rescale so that the
!          uniform variates are in the interval (-1,1).
!
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!
!         Check if the point (u,v) is in the unit circle
!
   r = (u*u + v*v) - 1.0
   if (r >= 0.0) go to 10
!
!            Store the point when it is in the circle
!
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!
!                          Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine rcir1

pure subroutine drcir(n, ix, x, y, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: x(n), y(n)
interface
   pure subroutine drcir1(n,ix,x,kx,y,ky,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      double precision, intent(inout) :: x(*)
      integer, intent(in) :: kx
      double precision, intent(inout) :: y(*)
      integer, intent(in) :: ky
      integer, intent(inout) :: ierr
   end subroutine drcir1
end interface
!-----------------------------------------------------------------------
!
!          Generation of n uniform random points (x(I),y(I))
!              in the unit circle centered at the origin
!
!-----------------------------------------------------------------------
!------------------
call drcir1(n, ix, x, 1, y, 1, ierr)
return
end subroutine drcir

pure subroutine drcir1(n, ix, x, kx, y, ky, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, ky, n
double precision, intent(inout) :: x(*), y(*)
integer :: i, i1, i2, j, k, leftlo
double precision :: r, u, v
integer :: fhi, xalo, xhi
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
double precision, parameter :: s = .931322d-09
!-----------------------------------------------------------------------
!
!      Generation of n uniform random points in the unit circle
!      centered at the origin. The abscissa and ordinate of the
!      i-TH point are stored in x(i1) and y(i2) where
!
!                      i1 = 1 + kx*(i - 1)
!                      i2 = 1 + ky*(i - 1) .
!
!-----------------------------------------------------------------------
!-------------------
!     data a/7**5/,  b15/2**15/, b16/2**16/, p/2**31 - 1/
!     p0 = 2**30 - 1
!     s  = 2/p
!-------------------
!-------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= p) go to 110
ierr = 0
!
i1 = 1
i2 = 1
do i = 1,n
!
!        Use the linus schrage code to obtain new seeds ix.
!
!        Reference. Schrage, linus, a more portable Fortran
!        random number generator, ACM Trans. Math Software 5
!        (1979), PP. 132-138.
!
10 xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   j = ix
!
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
!
!        Subtract the midpoint p0 and rescale so that the
!          uniform variates are in the interval (-1,1).
!
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!
!         Check if the point (u,v) is in the unit circle
!
   r = (u*u + v*v) - 1.d0
   if (r >= 0.d0) go to 10
!
!            Store the point when it is in the circle
!
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!
!                          Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine drcir1

pure subroutine rnor(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: a(n)
integer :: i, m
real :: r, s, u, v
real :: t(2)
integer, parameter :: max = 2147483647
interface
   pure subroutine rcir1(n,ix,x,kx,y,ky,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      real, intent(inout) :: x(*)
      integer, intent(in) :: kx
      real, intent(inout) :: y(*)
      integer, intent(in) :: ky
      integer, intent(inout) :: ierr
   end subroutine rcir1
end interface
!-----------------------------------------------------------------------
!                 Normal random number generator
!-----------------------------------------------------------------------
!---------------------
!---------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= max) go to 110
ierr = 0
!
if (n == 1) go to 20
m = n/2
call rcir1(m, ix, a(1), 2, a(2), 2, ierr)
m = m + m
!
!                  Obtain the first m variates
!
do i = 1,m,2
   u = a(i)
   v = a(i + 1)
   r = u*u + v*v
   s = sqrt(-2.0*log(r)/r)
   a(i) = s*u
   a(i + 1) = s*v
end do
if (m == n) return
!
!            Obtain the last variate (when n is odd)
!
20 call rcir1(1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = sqrt(-2.0*log(r)/r)
a(n) = s*t(1)
return
!
!                         Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine rnor

pure subroutine drnor(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: a(n)
integer :: i, m
double precision :: r, s, u, v, t(2)
integer, parameter :: max = 2147483647
interface
   pure subroutine drcir1(n,ix,x,kx,y,ky,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      double precision, intent(inout) :: x(*)
      integer, intent(in) :: kx
      double precision, intent(inout) :: y(*)
      integer, intent(in) :: ky
      integer, intent(inout) :: ierr
   end subroutine drcir1
end interface
!-----------------------------------------------------------------------
!                 Normal random number generator
!-----------------------------------------------------------------------
!---------------------
!---------------------
if (n <= 0) go to 100
if (ix <= 0 .or. ix >= max) go to 110
ierr = 0
!
if (n == 1) go to 20
m = n/2
call drcir1(m, ix, a(1), 2, a(2), 2, ierr)
m = m + m
!
!                  Obtain the first m variates
!
do i = 1,m,2
   u = a(i)
   v = a(i + 1)
   r = u*u + v*v
   s = sqrt(-2.d0*log(r)/r)
   a(i) = s*u
   a(i + 1) = s*v
end do
if (m == n) return
!
!            Obtain the last variate (when n is odd)
!
20 call drcir1(1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = sqrt(-2.d0*log(r)/r)
a(n) = s*t(1)
return
!
!                         Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine drnor

pure subroutine nrng(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: a(n)
integer :: i, m
real :: phi, r
real :: temp(1)
real, parameter :: pi2 = 6.2831853071796
interface
   pure subroutine urng(ix,x,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      real, intent(inout) :: x(n)
      integer, intent(inout) :: ierr
   end subroutine urng
end interface
!-----------------------------------------------------------------------
!                 Gaussian random number generator
!-----------------------------------------------------------------------
!
call urng(ix,a,n,ierr)
if (ierr /= 0) return
if (n == 1) go to 20
!
m = n/2
m = m + m
do 10 i = 1,m,2
   r = sqrt(-2.0*log(a(i)))
   phi = pi2*a(i + 1)
   a(i) = r*cos(phi)
10 a(i + 1) = r*sin(phi)
if (m == n) return
!
20 call urng(ix,temp,1,ierr)
r = sqrt(-2.0*log(a(n)))
a(n) = r*cos(pi2*temp(1))
return
end subroutine nrng

pure subroutine dnrng(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: a(n)
integer :: i, m
double precision :: phi, r, temp(1)
double precision, parameter :: pi2 = 6.28318530717958647692528676656d0
interface
   pure subroutine durng(ix,x,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      double precision, intent(inout) :: x(n)
      integer, intent(inout) :: ierr
   end subroutine durng
end interface
!-----------------------------------------------------------------------
!                 Gaussian random number generator
!-----------------------------------------------------------------------
!
!
call durng(ix, a, n, ierr)
if (ierr /= 0) return
if (n == 1) go to 20
!
m = n/2
m = m + m
do 10 i = 1,m,2
   r = sqrt(-2.d0*log(a(i)))
   phi = pi2*a(i + 1)
   a(i) = r*cos(phi)
10 a(i + 1) = r*sin(phi)
if (m == n) return
!
20 call durng(ix, temp, 1, ierr)
r = sqrt(-2.d0*log(a(n)))
a(n) = r*cos(pi2*temp(1))
return
end subroutine dnrng

pure subroutine nrvg(mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
real, intent(inout) :: a(*)
real, intent(in) :: fmu(m)
real, intent(inout) :: x(kx,n)
integer :: i, ii, j, k, l, l0, ldim
real :: sum
integer, parameter :: max = 2147483647
interface
   pure subroutine rnor(ix,a,n,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(inout) :: ix
      real, intent(inout) :: a(n)
      integer, intent(inout) :: ierr
   end subroutine rnor
   pure subroutine sppfa(ap,n,info)
      implicit none
      real, intent(inout) :: ap(*)
      integer, intent(in) :: n
      integer, intent(inout) :: info
   end subroutine sppfa
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
call sppfa(a, m, ierr)
if (ierr /= 0) go to 120
!
!           Generate the n random normal vectors
!
10 ldim = (m*(m + 1))/2
do j = 1,n
   call rnor(ix, x(1,j), m, ierr)
!
!         Obtain the components of the j-TH vector
!                    in reverse order
!
   l0 = ldim
   i = m
   do ii = 1,m
      l0 = l0 - i
      l = l0
      sum = 0.0
      do 20 k = 1,i
         l = l + 1
20       sum = sum + a(l)*x(k,j)
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
return
end subroutine nrvg

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
return
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
      do 20 k = 1,i
         l = l + 1
20       sum = sum + a(l)*x(k,j)
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
return
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
return
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
return
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
return
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
return
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
return
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
return
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
return
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
return
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
return
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
return
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
return
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
return
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
return
end subroutine drmk1
