subroutine dqk21 (f, a, b, result, abserr, resabs, resasc, &
&epmach, uflow, isig)
implicit none
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              TO COMPUTE I = INTEGRAL OF F OVER (A,B), WITH ERROR
!                             estimate
!                         J = INTEGRAL OF DABS(F) OVER (A,B)
!
! 2.        PARAMETERS
!            on entry
!              F      - DOUBLE PRECISION
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
!                       to be declared E X T E R N A L in the
!                       calling program.
!
!              A      - DOUBLE PRECISION
!                       lower limit of integration
!
!              B      - DOUBLE PRECISION
!                       upper limit of integration
!
!              EPMACH - double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              UFLOW  - double precision
!                       the smallest positive magnitude.
!
!            On return
!              result - double precision
!                       approximation to the integral I
!                       result is computed by applying the 21-point
!                       Kronrod rule (RESK) obtained by optimal
!                       addition of abscissae to the 10-point Gauss
!                       RULE (RESG).
!
!              ABSERR - double precision
!                       estimate of the modulus of the absolute error,
!                       which should not exceed ABS(I-RESULT)
!
!              RESABS - double precision
!                       approximation to the integral J
!
!              RESASC - double precision
!                       approximation to the integral of ABS(F-I/(B-A))
!                       OVER (A,B)
!
!              ISIG   - INTEGER
!                       ISIG=0  THE INTEGRAL WAS APPROXIMATED.
!                       ISIG=5  THE INTERVAL (A,B) IS TOO SHORT.
!                               The integral cannot be computed.
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - F (user-provided function)
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision :: absc
double precision, intent(inout) :: abserr
double precision, intent(in) :: b
double precision :: centr, dhlgth
double precision, intent(in) :: epmach
double precision :: f, fc, fsum, fval1, fval2, fv1(10), fv2(10), &
&hlgth
double precision, intent(inout) :: resabs
double precision :: resg, resk, reskh
double precision, intent(inout) :: result
double precision :: tol
double precision, intent(in) :: uflow
double precision :: wg(5), wgk(11), xgk(11)
double precision, intent(inout) :: resasc
integer, intent(out) :: isig
integer :: j, jtw, jtwm1
!
external f
!
!           The abscissae and weights are given for the interval (-1,1).
!           Because of symmetry only the positive abscissae and their
!           corresponding weights are given.
!
!           XGK    - ABSCISSAE OF THE 21-POINT KRONROD RULE
!                    XGK(2), XGK(4), ...  abscissae of the 10-point
!                    Gauss rule
!                    XGK(1), XGK(3), ...  abscissae which are optimally
!                    added to the 10-point Gauss rule
!
!           WGK    - WEIGHTS OF THE 21-POINT KRONROD RULE
!
!           WG     - WEIGHTS OF THE 10-POINT GAUSS RULE
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
&xgk(8),xgk(9),xgk(10),xgk(11)/ &
&0.995657163025808080735527280689d+00, &
&0.973906528517171720077964012084d+00, &
&0.930157491355708226001207180060d+00, &
&0.865063366688984510732096688423d+00, &
&0.780817726586416897063717578345d+00, &
&0.679409568299024406234327365115d+00, &
&0.562757134668604683339000099273d+00, &
&0.433395394129247190799265943166d+00, &
&0.294392862701460198131126603104d+00, &
&0.148874338981631210884826001130d+00, &
&0.000000000000000000000000000000d+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
&wgk(8),wgk(9),wgk(10),wgk(11)/ &
&0.116946388673718742780643960622d-01, &
&0.325581623079647274788189724594d-01, &
&0.547558965743519960313813002446d-01, &
&0.750396748109199527670431409162d-01, &
&0.931254545836976055350654650834d-01, &
&0.109387158802297641899210590326d+00, &
&0.123491976262065851077958109831d+00, &
&0.134709217311473325928054001772d+00, &
&0.142775938577060080797094273139d+00, &
&0.147739104901338491374841515972d+00, &
&0.149445554002916905664936468390d+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5)/ &
&0.666713443086881375935688098933d-01, &
&0.149451349150580593145776339658d+00, &
&0.219086362515982043995534934228d+00, &
&0.269266719309996355091226921569d+00, &
&0.295524224714752870173892994651d+00/
!
!
!           List of major variables
!           -----------------------
!
!           CENTR  - mid point of the interval
!           HLGTH  - half-length of the interval
!           ABSC   - ABSCISSA
!           FVAL*  - function VALUE
!           RESG   - RESULT OF THE 10-POINT GAUSS FORMULA
!           RESK   - RESULT OF THE 21-POINT KRONROD FORMULA
!           RESKH  - approximation to the mean value of F over (A,B),
!                    I.E. TO I/(B-A)
!
!
centr = 0.5d0*(a + b)
hlgth = 0.5d0*(b - a)
dhlgth = dabs(hlgth)
!
!             Check if the interval (A,B) is too short
!
isig = 5
absc = dabs(centr) + dhlgth*0.14d0
if (absc .eq. dabs(centr)) return
!
!           Compute the 21-point Kronrod approximation to
!           the integral, and estimate the absolute error.
!
isig = 0
resg = 0.d0
fc = f(centr)
resk = wgk(11)*fc
resabs = dabs(resk)
do 10 j = 1,5
  jtw = 2*j
  absc = hlgth*xgk(jtw)
  fval1 = f(centr - absc)
  fval2 = f(centr + absc)
  fv1(jtw) = fval1
  fv2(jtw) = fval2
  fsum = fval1 + fval2
  resg = resg + wg(j)*fsum
  resk = resk + wgk(jtw)*fsum
  resabs = resabs + wgk(jtw)*(dabs(fval1) + dabs(fval2))
10 continue
do j = 1,5
  jtwm1 = 2*j - 1
  absc = hlgth*xgk(jtwm1)
  fval1 = f(centr - absc)
  fval2 = f(centr + absc)
  fv1(jtwm1) = fval1
  fv2(jtwm1) = fval2
  fsum = fval1 + fval2
  resk = resk + wgk(jtwm1)*fsum
  resabs = resabs + wgk(jtwm1)*(dabs(fval1) + dabs(fval2))
end do
reskh = resk*0.5d0
resasc = wgk(11)*dabs(fc - reskh)
do j = 1,10
  resasc = resasc + wgk(j)*(dabs(fv1(j)-reskh) &
&+ dabs(fv2(j)-reskh))
end do
result = resk*hlgth
resabs = resabs*dhlgth
resasc = resasc*dhlgth
abserr = dabs((resk - resg)*hlgth)
if (resasc .ne. 0.d0 .and. abserr .ne. 0.d0) &
&abserr = resasc*dmin1(1.d0, &
&(0.2d+03*abserr/resasc)**1.5d0)
tol = epmach*0.5d+02
if (resabs .gt. uflow/tol) abserr = dmax1(abserr,tol*resabs)
return
end subroutine dqk21

subroutine dqagi (f, bound, inf, epsabs, epsrel, result, abserr, &
&neval, ier, limit, lenw, last, iwork, work)
implicit none
integer, intent(in) :: inf
integer, intent(out) :: last
!-----------------------------------------------------------------------
!
!         Double precision integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - DOUBLE PRECISION
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            Bound  - double precision
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            INF    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - double precision
!                     absolute accuracy requested
!
!            EPSREL - double precision
!                     relative accuracy requested
!
!         On return
!            result - double precision
!                     approximation to the integral
!
!            ABSERR - double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             OR LENW .LT. 4 * LIMIT.
!                             Result, ABSERR, NEVAL, last are
!                             set to zero.
!
!         Dimensioning parameters
!            limit - integer
!                    dimensioning parameter for IWORK
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
!                    IER = 6.
!
!            LENW  - INTEGER
!                    dimensioning parameter for work
!                    LENW must be at least limit*4.
!                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            Last  - integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of significant
!                    elements actually in the work arrays.
!
!         Work arrays
!            IWORK - INTEGER
!                    vector of dimension at least limit, the first
!                    K elements of which contain pointers
!                    to the error estimates over the subintervals,
!                    such that WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) form a decreasing
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                    K = LIMIT+1-LAST OTHERWISE
!
!            Work  - double precision
!                    vector of dimension at least LENW
!                    on return
!                    WORK(1), ..., WORK(LAST) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) contain
!                     the right end points,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
!                     contain the integral approximations over
!                     the subintervals,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     contain the error estimates.
!
!        Subroutines or functions needed
!              - DQAGIE
!              - DQK15I
!              - DQPSRT
!              - DQELG
!              - F (user provided function)
!              - DPMPAR
!
!-----------------------------------------------------------------------
double precision, intent(out) :: abserr
double precision, intent(in) :: bound, epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(in) :: lenw, limit
integer :: l1, l2, l3
integer, intent(out) :: neval
!
dimension iwork(limit),work(lenw)
!
external f
!
!         Check validity of limit and LENW.
!
ier = 6
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         Prepare call for DQAGIE
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call dqagie (f,bound,inf,epsabs,epsrel,limit,result,abserr, &
&neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
return
end subroutine dqagi

subroutine dqagie (f,bound,inf,epsabs,epsrel,limit,result,abserr, &
&neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!
!                   Integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
!                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
!
!        Parameters
!         on entry
!            F      - DOUBLE PRECISION
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            Bound  - double precision
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            INF    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
!                     INF = -1            TO  (-INFINITY,BOUND),
!                     INF = 2             TO (-INFINITY,+INFINITY).
!
!            EPSABS - double precision
!                     absolute accuracy requested
!
!            EPSREL - double precision
!                     relative accuracy requested
!
!            Limit  - integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     LIMIT.GE.1
!
!         On return
!            result - double precision
!                     approximation to the integral
!
!            ABSERR - double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed ABS(I-RESULT)
!
!            NEVAL  - INTEGER
!                     number of integrand evaluations
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
!                             at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
!                             or EPSREL is negative.
!                             Result, ABSERR, NEVAL, last, RLIST(1),
!                             ELIST(1) and IORD(1) are set to zero.
!                             ALIST(1) and BLIST(1) are set to 0
!                             and 1 respectively.
!
!            ALIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            BLIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            RLIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            ELIST  - double precision
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!
!            IORD   - INTEGER
!                     vector of dimension limit, the first K
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     otherwise
!
!            LAST   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!
!        Subroutines or functions needed
!              - DQK15I
!              - DQPSRT
!              - DQELG
!              - F (user-provided function)
!              - DPMPAR
!
!-----------------------------------------------------------------------
double precision :: abseps
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision :: area, area1, area12, area2, a1, a2
double precision, intent(inout) :: blist
double precision :: boun
double precision, intent(in) :: bound
double precision :: b1, b2, correc, defabs, defab1, defab2, dres, &
&dpmpar
double precision, intent(inout) :: elist
double precision :: epmach
double precision, intent(in) :: epsabs, epsrel
double precision :: erlarg, erlast, errbnd, errmax, error1, &
&error2, erro12, errsum, ertest, f, oflow, rerr, resabs, reseps
double precision, intent(out) :: result
double precision :: res3la(3)
double precision, intent(inout) :: rlist
double precision :: rlist2(52), small, t, uflow
integer :: id
integer, intent(out) :: ier
integer :: ierro
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer, intent(out) :: last
integer, intent(in) :: limit
integer :: maxerr
integer, intent(out) :: neval
integer :: nres, nrmax, numrl2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
&rlist(limit)
!
external f
!
!            The dimension of RLIST2 is determined by the value of
!            LIMEXP in subroutine DQELG.
!
!
!            List of major variables
!            -----------------------
!
!           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
!                       considered up to now
!           RLIST(I)  - approximation to the integral over
!                       (ALIST(I),BLIST(I))
!           RLIST2    - ARRAY OF DIMENSION AT LEAST (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           ELIST(I)  - error estimate applying to RLIST(I)
!           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
!                       estimate
!           ERRMAX    - ELIST(MAXERR)
!           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
!                       (before that subdivision has taken place)
!           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
!           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
!           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
!                       ABS(RESULT))
!           *****1    - VARIABLE FOR THE LEFT SUBINTERVAL
!           *****2    - VARIABLE FOR THE RIGHT SUBINTERVAL
!           LAST      - INDEX FOR SUBDIVISION
!           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
!           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       RLIST2(NUMRL2) after NUMRL2 has been increased
!                       by one.
!           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED UP
!                       to now, multiplied by 1.5
!           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
!                       than the smallest interval considered up to now
!           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of ERLARG.
!           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
!                       is no longer allowed (TRUE-VALUE)
!
!            Machine dependent constants
!            ---------------------------
!
!           EPMACH is the largest relative spacing.
!           UFLOW is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!
!           Check EPSABS and EPSREL
!           -----------------------
!
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
alist(1) = 0.d0
blist(1) = 1.d0
rlist(1) = 0.d0
elist(1) = 0.d0
iord(1) = 0
ier = 6
if (epsabs .lt. 0.d0 .or. epsrel .lt. 0.d0) go to 999
ier = 0
rerr = dmax1(epsrel, 50.d0*epmach, 0.5d-28)
!
!           First approximation to the integral
!           -----------------------------------
!
!           Determine the interval to be mapped onto (0,1).
!           IF INF = 2 THE INTEGRAL IS COMPUTED AS I = I1+I2, WHERE
!           I1 = INTEGRAL OF F OVER (-INFINITY,0),
!           I2 = INTEGRAL OF F OVER (0,+INFINITY).
!
boun = bound
if (inf .eq. 2) boun = 0.d0
call dqk15i (f, boun, inf, 0.d0, 1.d0, result, abserr, &
&defabs, resabs, epmach, uflow)
!
!           Test on accuracy
!
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = dabs(result)
errbnd = dmax1(epsabs,rerr*dres)
if (abserr .le. 100.d0*epmach*defabs .and. abserr .gt. errbnd) &
&ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr .le. errbnd .and. abserr .ne. resabs) &
&.or. abserr .eq. 0.d0) go to 130
!
!           Initialization
!           --------------
!
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.d0
nrmax = 1
nres = 0
ktmin = 0
numrl2 = 2
extrap = .false.
noext = .false.
ierro = 0
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres .ge. (1.d0 - 50.d0*epmach)*defabs) ksgn = 1
t = 1.d0 + 100.d0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with NRMAX-TH largest
!           error estimate.
!
  a1 = alist(maxerr)
  b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
  a2 = b1
  b2 = blist(maxerr)
  erlast = errmax
  call dqk15i (f, boun, inf, a1, b1, area1, error1, &
&resabs, defab1, epmach, uflow)
  call dqk15i (f, boun, inf, a2, b2, area2, error2, &
&resabs, defab2, epmach, uflow)
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
  area12 = area1 + area2
  erro12 = error1 + error2
  errsum = errsum + erro12 - errmax
  area = area + area12 - rlist(maxerr)
  if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
  if (dabs(rlist(maxerr) - area12) .gt. 0.1d-04*dabs(area12) &
&.or. erro12 .lt. 0.99d0*errmax) go to 10
  if (extrap) iroff2 = iroff2 + 1
  if (.not.extrap) iroff1 = iroff1 + 1
10 if (last .gt. 10 .and. erro12 .gt. errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
  rlist(last) = area2
  errbnd = dmax1(epsabs,rerr*dabs(area))
!
!           Test for roundoff error and eventually
!           set error flag.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           Set error flag in the case that the number of
!           subintervals equals limit.
!
  if (last .eq. limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at some points of the integration range.
!

  if (dmax1(dabs(a1),dabs(b2)) .le. &
&t*(dabs(a2) + 0.1d+04*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
  if (error2 .gt. error1) go to 20
  alist(last) = a2
  blist(maxerr) = b1
  blist(last) = b2
  elist(maxerr) = error1
  elist(last) = error2
  go to 30
20 alist(maxerr) = a2
  alist(last) = a1
  blist(last) = b1
  rlist(maxerr) = area2
  rlist(last) = area1
  elist(maxerr) = error2
  elist(last) = error1
!
!           CALL SUBROUTINE DQPSRT TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with NRMAX-TH largest error estimate (to be
!           bisected next).
!
30 call dqpsrt (limit,last,maxerr,errmax,elist,iord,nrmax)
  if (errsum .le. errbnd) go to 115
  if (ier .ne. 0) go to 100
  if (last .eq. 2) go to 80
  if (noext) go to 90
  erlarg = erlarg - erlast
  if (dabs(b1 - a1) .gt. small) erlarg = erlarg + erro12
  if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
  if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (ERLARG) and perform
!           extrapolation.
!
  id = nrmax
  jupbnd = last
  if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
  do 50 k = id,jupbnd
    maxerr = iord(nrmax)
    errmax = elist(maxerr)
    if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
    nrmax = nrmax + 1
50 continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
  rlist2(numrl2) = area
  call dqelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
&epmach, oflow)
  ktmin = ktmin + 1
  if (ktmin .gt. 5 .and. abserr .lt. 0.1d-02*errsum) ier = 5
  if (abseps .ge. abserr) go to 70
  ktmin = 0
  abserr = abseps
  result = reseps
  correc = erlarg
  ertest = dmax1(epsabs,rerr*dabs(reseps))
  if (abserr .le. ertest) go to 100
!
!            Prepare bisection of the smallest interval.
!
70 if (numrl2 .eq. 1) noext = .true.
  if (ier .eq. 5) go to 100
  maxerr = iord(1)
  errmax = elist(maxerr)
  nrmax = 1
  extrap = .false.
  small = small*0.5d0
  erlarg = errsum
  go to 90
80 small = 0.375d0
  erlarg = errsum
  ertest = errbnd
  rlist2(2) = area
90 continue
!
!           Set final result and error estimate.
!           ------------------------------------
!
100 if (abserr .eq. oflow) go to 115
if (ier + ierro .eq. 0) go to 110
if (ierro .eq. 3) abserr = abserr + correc
if (ier .eq. 0) ier = 3
if (result .ne. 0.d0 .and. area .ne. 0.d0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.d0) go to 130
go to 110
105 if (abserr/dabs(result) .gt. errsum/dabs(area)) go to 115
!
!           Test on divergence
!
110 if (ksgn .eq. -1 .and. dmax1(dabs(result),dabs(area)) .le. &
&defabs*0.1d-01) go to 130
if (0.1d-01 .gt. (result/area) .or. (result/area) .gt. 0.1d+03 &
&.or. errsum .gt. dabs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.d0
do k = 1,last
  result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf .eq. 2) neval = 2*neval
if (ier .gt. 2) ier = ier - 1
999 return
end subroutine dqagie

subroutine dqk15i (f, boun, inf, a, b, result, abserr, resabs, &
&resasc, epmach, uflow)
implicit none
integer, intent(in) :: inf
integer :: j
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (A,B) is a part of (0,1).
!              It is the purpose to compute
!              I = INTEGRAL OF TRANSFORMED INTEGRAND OVER (A,B),
!              J = INTEGRAL OF ABS(TRANSFORMED INTEGRAND) OVER (A,B).
!
! 2.        PARAMETERS
!            on entry
!              F      - DOUBLE PRECISION
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
!                       to be declared E X T E R N A L in the
!                       calling program.
!
!              BOUN   - DOUBLE PRECISION
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF INF = +2)
!
!              INF    - INTEGER
!                       IF INF = -1, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,BOUND),
!                       IF INF = +1, THE ORIGINAL INTERVAL IS
!                                   (BOUND,+INFINITY),
!                       IF INF = +2, THE ORIGINAL INTERVAL IS
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!
!              A      - DOUBLE PRECISION
!                       lower limit for integration over subrange
!                       of (0,1)
!
!              B      - DOUBLE PRECISION
!                       upper limit for integration over subrange
!                       of (0,1)
!
!              EPMACH - double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              UFLOW  - double precision
!                       the smallest positive magnitude.
!
!            On return
!              result - double precision
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod RULE(RESK) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(RESG).
!
!              ABSERR - double precision
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed ABS(I-RESULT)
!
!              RESABS - double precision
!                       approximation to the integral J
!
!              RESASC - double precision
!                       approximation to the integral of
!                       ABS((TRANSFORMED INTEGRAND)-I/(B-A))
!                       OVER (A,B)
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - F (user-provided function)
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision :: absc, absc1, absc2
double precision, intent(inout) :: abserr
double precision, intent(in) :: b, boun
double precision :: centr, dinf
double precision, intent(in) :: epmach
double precision :: f, fc, fsum, fval1, fval2, hlgth
double precision, intent(inout) :: resabs, resasc
double precision :: resg, resk, reskh
double precision, intent(inout) :: result
double precision :: tabsc1, tabsc2, tol
double precision, intent(in) :: uflow
double precision :: fv1(7), fv2(7), xgk(8), wgk(8), wg(8)
external f
!
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!
!           XGK    - ABSCISSAE OF THE 15-POINT KRONROD RULE
!                    XGK(2), XGK(4), ... abscissae of the 7-point
!                    Gauss rule
!                    XGK(1), XGK(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!
!           WGK    - WEIGHTS OF THE 15-POINT KRONROD RULE
!
!           WG     - WEIGHTS OF THE 7-POINT GAUSS RULE, CORRESPONDING
!                    to the abscissae XGK(2), XGK(4), ...
!                    WG(1), WG(3), ... are set to zero.
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
&xgk(8)/ &
&0.991455371120812639206854697526d+00, &
&0.949107912342758524526189684048d+00, &
&0.864864423359769072789712788641d+00, &
&0.741531185599394439863864773281d+00, &
&0.586087235467691130294144838259d+00, &
&0.405845151377397166906606412077d+00, &
&0.207784955007898467600689403773d+00, &
&0.000000000000000000000000000000d+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
&wgk(8)/ &
&0.229353220105292249637320080590d-01, &
&0.630920926299785532907006631892d-01, &
&0.104790010322250183839876322542d+00, &
&0.140653259715525918745189590510d+00, &
&0.169004726639267902826583426599d+00, &
&0.190350578064785409913256402421d+00, &
&0.204432940075298892414161999235d+00, &
&0.209482141084727828012999174892d+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5),wg(6),wg(7),wg(8)/ &
&0.0d+00,    0.129484966168869693270611432679d+00, &
&0.0d+00,    0.279705391489276667901467771424d+00, &
&0.0d+00,    0.381830050505118944950369775489d+00, &
&0.0d+00,    0.417959183673469387755102040816d+00/
!
!
!           List of major variables
!           -----------------------
!
!           CENTR  - mid point of the interval
!           HLGTH  - half-length of the interval
!           ABSC*  - ABSCISSA
!           TABSC* - transformed abscissa
!           FVAL*  - function VALUE
!           RESG   - RESULT OF THE 7-POINT GAUSS FORMULA
!           RESK   - RESULT OF THE 15-POINT KRONROD FORMULA
!           RESKH  - approximation to the mean value of the transformed
!                    integrand over (A,B), I.E. To I/(B-A)
!
!
dinf = min0(1,inf)
!
centr = 0.5d0*(a + b)
hlgth = 0.5d0*(b - a)
tabsc1 = boun + dinf*(1.d0 - centr)/centr
fval1 = f(tabsc1)
if (inf .eq. 2) fval1 = fval1 + f(-tabsc1)
fc = (fval1/centr)/centr
!
!           Compute the 15-point Kronrod approximation to
!           the integral, and estimate the error.
!
resg = wg(8)*fc
resk = wgk(8)*fc
resabs = dabs(resk)
do j = 1,7
  absc = hlgth*xgk(j)
  absc1 = centr - absc
  absc2 = centr + absc
  tabsc1 = boun + dinf*(1.d0 - absc1)/absc1
  tabsc2 = boun + dinf*(1.d0 - absc2)/absc2
  fval1 = f(tabsc1)
  fval2 = f(tabsc2)
  if (inf .eq. 2) fval1 = fval1 + f(-tabsc1)
  if (inf .eq. 2) fval2 = fval2 + f(-tabsc2)
  fval1 = (fval1/absc1)/absc1
  fval2 = (fval2/absc2)/absc2
  fv1(j) = fval1
  fv2(j) = fval2
  fsum = fval1 + fval2
  resg = resg + wg(j)*fsum
  resk = resk + wgk(j)*fsum
  resabs = resabs + wgk(j)*(dabs(fval1) + dabs(fval2))
end do
reskh = resk*0.5d0
resasc = wgk(8)*dabs(fc - reskh)
do j = 1,7
  resasc = resasc + wgk(j)*(dabs(fv1(j)-reskh) + &
&dabs(fv2(j)-reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = dabs((resk - resg)*hlgth)
if (resasc .ne. 0.d0 .and. abserr .ne. 0.d0) abserr = resasc* &
&dmin1(1.d0, (0.2d+03*abserr/resasc)**1.5d0)
tol = 50.d0*epmach
if (resabs .gt. uflow/tol) abserr = dmax1(abserr, tol*resabs)
return
end subroutine dqk15i

subroutine dqpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
implicit none
!     ..................................................................
!
! 1.        DQPSRT
!           ORDERING ROUTINE
!              STANDARD FORTRAN SUBROUTINE
!              DOUBLE PRECISION VERSION
!
! 2.        PURPOSE
!              this routine maintains the descending ordering
!              in the list of the local error estimates resulting from
!              the interval subdivision process. At each call two error
!              estimates are inserted using the sequential search
!              method, top-down for the largest error estimate
!              and bottom-up for the smallest error estimate.
!
! 3.        CALLING SEQUENCE
!              CALL DQPSRT(LIMIT,LAST,MAXERR,ERMAX,ELIST,IORD,NRMAX)
!
!           Parameters (meaning at output)
!              limit  - integer
!                       maximum number of error estimates the list
!                       can contain
!
!              LAST   - INTEGER
!                       number of error estimates currently
!                       in the list
!
!              MAXERR - INTEGER
!                       MAXERR points to the NRMAX-TH largest error
!                       estimate currently in the list
!
!              ERMAX  - double precision
!                       NRMAX-TH largest error estimate
!                       ERMAX = ELIST(MAXERR)
!
!              ELIST  - double precision
!                       vector of dimension last containing
!                       the error estimates
!
!              IORD   - INTEGER
!                       vector of dimension last, the first K
!                       elements of which contain pointers
!                       to the error estimates, such that
!                       ELIST(IORD(1)),... , ELIST(IORD(K))
!                       form a decreasing sequence, with
!                       K = LAST IF LAST.LE.(LIMIT/2+2), AND
!                       K = LIMIT+1-LAST OTHERWISE
!
!              NRMAX  - INTEGER
!                       MAXERR = IORD(NRMAX)
!
! 4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!
!     ..................................................................
!
double precision :: elist
double precision, intent(inout) :: ermax
double precision :: errmax, errmin
integer :: i, ibeg, ido
integer, intent(inout) :: iord
integer :: isucc, j, jbnd, jupbn, k
integer, intent(in) :: last, limit
integer, intent(inout) :: maxerr, nrmax
dimension elist(last),iord(last)
!
!           Check whether the list contains more than
!           two error estimates.
!
!***FIRST EXECUTABLE STATEMENT DQPSRT
if(last.gt.2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!
!           This part of the routine is only executed
!           if, due to a difficult integrand, subdivision
!           increased the error estimate. In the normal case
!           the insert procedure should start after the
!           NRMAX-TH largest error estimate.
!
10 errmax = elist(maxerr)
if(nrmax.eq.1) go to 30
ido = nrmax-1
do i = 1,ido
  isucc = iord(nrmax-1)
! ***JUMP OUT OF DO-LOOP
  if(errmax.le.elist(isucc)) go to 30
  iord(nrmax) = isucc
  nrmax = nrmax-1
   end do
!
!           Compute the number of elements in the list to
!           be maintained in descending order. This number
!           depends on the number of subdivisions still
!           allowed.
!
30 jupbn = last
if(last.gt.(limit/2+2)) jupbn = limit+3-last
errmin = elist(last)
!
!           Insert ERRMAX by traversing the list top-down,
!           starting comparison from the element ELIST(IORD(NRMAX+1)).
!
jbnd = jupbn-1
ibeg = nrmax+1
if(ibeg.gt.jbnd) go to 50
do i=ibeg,jbnd
  isucc = iord(i)
! ***JUMP OUT OF DO-LOOP
  if(errmax.ge.elist(isucc)) go to 60
  iord(i-1) = isucc
end do
50 iord(jbnd) = maxerr
iord(jupbn) = last
go to 90
!
!           Insert ERRMIN by traversing the list bottom-up.
!
60 iord(i-1) = maxerr
k = jbnd
do j=i,jbnd
  isucc = iord(k)
! ***JUMP OUT OF DO-LOOP
  if(errmin.lt.elist(isucc)) go to 80
  iord(k+1) = isucc
  k = k-1
end do
iord(i) = last
go to 90
80 iord(k+1) = last
!
!           Set MAXERR and ERMAX.
!
90 maxerr = iord(nrmax)
ermax = elist(maxerr)
return
end subroutine dqpsrt

subroutine dqelg (n, epstab, result, abserr, res3la, nres, &
&epmach, oflow)
implicit none
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. Wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
!
! 2.        PARAMETERS
!              N      - INTEGER
!                       EPSTAB(N) contains the new element in the
!                       first column of the epsilon table.
!
!              EPSTAB - double precision
!                       vector of dimension 52 containing the
!                       elements of the two lower diagonals of
!                       the triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!
!              Result - double precision
!                       resulting approximation to the integral
!
!              ABSERR - double precision
!                       estimate of the absolute error computed from
!                       result and the 3 previous results
!
!              RES3LA - double precision
!                       vector of dimension 3 containing the last 3
!                       results
!
!              NRES   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!
!              EPMACH - double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              OFLOW  - double precision
!                       the largest positive magnitude.
!
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!
!-----------------------------------------------------------------------
double precision, intent(out) :: abserr
double precision :: delta1, delta2, delta3
double precision, intent(in) :: epmach
double precision :: epsinf
double precision, intent(inout) :: epstab(52)
double precision :: error, err1, err2, err3, e0, e1, e1abs, e2, e3
double precision, intent(in) :: oflow
double precision :: res
double precision, intent(out) :: result
double precision, intent(inout) :: res3la(3)
double precision :: ss, tol1, tol2, tol3
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp
integer, intent(inout) :: n
integer :: newelm
integer, intent(inout) :: nres
integer :: num
!---------------------
!
!           List of major variables
!           -----------------------
!
!           E0     - THE 4 ELEMENTS ON WHICH THE
!           E1       COMPUTATION OF A NEW ELEMENT IN
!           E2       THE EPSILON TABLE IS BASED
!           E3                 E0
!                        E3    E1    NEW
!                              E2
!           NEWELM - number of elements to be computed in the new
!                    diagonal
!           ERROR  - ERROR = ABS(E1-E0) + ABS(E2-E1) + ABS(NEW-E2)
!           result - the element in the new diagonal with least value
!                    of error
!
!           LIMEXP is the maximum number of elements the epsilon
!           table can contain. If this number is reached, the upper
!           diagonal of the epsilon table is deleted.
!
nres = nres + 1
abserr = oflow
result = epstab(n)
if (n .lt. 3) go to 100
limexp = 50
epstab(n + 2) = epstab(n)
newelm = (n - 1)/2
epstab(n) = oflow
num = n
k1 = n
do 40 i = 1,newelm
  k2 = k1 - 1
  k3 = k1 - 2
  res = epstab(k1 + 2)
  e0 = epstab(k3)
  e1 = epstab(k2)
  e2 = res
  e1abs = dabs(e1)
  delta2 = e2 - e1
  err2 = dabs(delta2)
  tol2 = dmax1(dabs(e2),e1abs)*epmach
  delta3 = e1 - e0
  err3 = dabs(delta3)
  tol3 = dmax1(e1abs,dabs(e0))*epmach
  if (err2 .gt. tol2 .or. err3 .gt. tol3) go to 10
!
!           If E0, E1 and E2 are equal to within machine
!           accuracy, convergence is assumed.
!           RESULT = E2
!           ABSERR = ABS(E1-E0) + ABS(E2-E1)
!
  result = res
  abserr = err2 + err3
! ***JUMP OUT OF DO-LOOP
  go to 100
10 e3 = epstab(k1)
  epstab(k1) = e1
  delta1 = e1 - e3
  err1 = dabs(delta1)
  tol1 = dmax1(e1abs,dabs(e3))*epmach
!
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of N
!
  if (err1.le.tol1 .or. err2.le.tol2 .or. err3.le.tol3) go to 20
  ss = 1.d0/delta1 + 1.d0/delta2 - 1.d0/delta3
  epsinf = dabs(ss*e1)
!
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF N.
!
  if (epsinf .gt. 0.1d-03) go to 30
20 n = i + i - 1
! ***JUMP OUT OF DO-LOOP
  go to 50
!
!           Compute a new element and eventually adjust
!           the value of result.
!
30 res = e1 + 1.d0/ss
  epstab(k1) = res
  k1 = k1 - 2
  error = err2 + dabs(res - e2) + err3
  if (error .gt. abserr) go to 40
  abserr = error
  result = res
40 continue
!
!           Shift the table.
!
50 if (n .eq. limexp) n = 2*(limexp/2) - 1
ib = 1
if ((num/2)*2 .eq. num) ib = 2
ie = newelm + 1
do i = 1,ie
  ib2 = ib + 2
  epstab(ib) = epstab(ib2)
  ib = ib2
end do
if (num .eq. n) go to 80
indx = num - n + 1
do i = 1,n
  epstab(i) = epstab(indx)
  indx = indx + 1
end do
80 if (nres .ge. 4) go to 90
res3la(nres) = result
abserr = oflow
go to 100
!
!           Compute error estimate
!
90 abserr = dabs(result - res3la(3)) + dabs(result - res3la(2)) + &
&dabs(result - res3la(1))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = dmax1(abserr,5.d0*epmach*dabs(result))
return
end subroutine dqelg

subroutine dqxgs (f,a,b,epsabs,epsrel,result,abserr,ier, &
&limit,leniw,lenw,last,iwork,work)
implicit none
!
!            The routine calculates an approximation result to a given
!            DEFINITE INTEGRAL  I = INTEGRAL OF F OVER (A,B),
!            hopefully satisfying following claim for accuracy
!            DABS(I-RESULT).LE.MAX(EPSABS,EPSREL*DABS(I)).
!
!        Parameters
!         on entry
!            F      - DOUBLE PRECISION
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - DOUBLE PRECISION
!                     lower limit of integration
!
!            B      - DOUBLE PRECISION
!                     upper limit of integration
!
!            EPSABS - double precision
!                     absolute accuracy requested
!
!            EPSREL - double precision
!                     relative accuracy requested
!
!         On return
!            result - double precision
!                     approximation to the integral
!
!            ABSERR - double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed DABS(I-RESULT)
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account. However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. Singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table. It is presumed that
!                             the requested tolerance cannot be
!                             achieved, and that the returned result is
!                             the best which can be obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS OR
!                             EPSREL IS NEGATIVE, LIMIT .LT. 1,
!                             LENW .LT. 46*LIMIT, OR
!                             LENIW .LT. 3*LIMIT.
!                             Result, ABSERR, last are set to
!                             zero. Except when limit or LENW or LENIW
!                             is invalid, IWORK(1), WORK(LIMIT*2+1) and
!                             WORK(LIMIT*3+1) are set to zero, WORK(1)
!                             is set to A, and WORK(LIMIT+1) to B.
!
!         Dimensioning parameters
!            limit - integer
!                    limit determines the maximum number of subintervals
!                    in the partition of the given integration interval
!                    (A,B), LIMIT.GE.1.
!                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH IER = 6.
!
!            LENW  - INTEGER
!                    dimensioning parameter for work
!                    LENW must be at least limit*46.
!                    IF LENW.LT.LIMIT*46, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            LENIW - INTEGER
!                    dimensioning parameter for IWORK
!                    LENIW must be at least limit*3.
!                    IF LENW.LT.LIMIT*3, THE ROUTINE WILL END
!                    WITH IER = 6.
!
!            Last  - integer
!                    on return, last equals the number of subintervals
!                    produced in the subdivision process, which deter-
!                    mines the number of significant elements actually
!                    in the work arrays.
!
!         Work arrays
!            IWORK - INTEGER
!                    vector of dimension at least 3*limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that WORK(LIMIT*3+IWORK(1)),... ,
!                    WORK(LIMIT*3+IWORK(K)) form a decreasing
!                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2),
!                    AND K = LIMIT+1-LAST OTHERWISE.
!
!            Work  - double precision
!                    vector of dimension at least LENW
!                    on return
!                    WORK(1), ..., WORK(LAST) contain the left
!                     END-POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) contain
!                     the right end-points,
!                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST) contain
!                     the integral approximations over the subintervals,
!                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
!                     contain the error estimates.
!                    WORK(LIMIT*4+1), ... is the area reserved to store
!                     functional values.
!
double precision :: a
double precision, intent(out) :: abserr
double precision :: b
double precision, intent(in) :: epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(out) :: last
integer, intent(in) :: leniw, lenw, limit
integer :: l1, l2, l3, l4, l5
!
dimension iwork(leniw),work(lenw)
!
external f
!
!         Check validity of limit,LENIW and LENW.
!
ier = 6
last = 0
result = 0.d0
abserr = 0.d0
if (limit.lt.1 .or. leniw.lt.limit*3 .or. lenw.lt.limit*46) &
&return
!
!         Prepare call for DQXGSE.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
l4 = limit + l3
l5 = 21*limit + l4
!
call dqxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
&ier,work(1),work(l1),work(l2),work(l3),iwork,last, &
&work(l4),work(l5),iwork(l1),iwork(l2))
!
return
end subroutine dqxgs

subroutine dqxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
&ier,alist,blist,rlist,elist,iord,last,valp,valn,lp,ln)
implicit none
!
!            The routine calculates an approximation result to A
!            DEFINITE INTEGRAL I = INTEGRAL OF F OVER (A,B),
!            hopefully satisfying following claim for accuracy
!            DABS(I-RESULT).LE.MAX(EPSABS,EPSREL*DABS(I)).
!
!        Parameters
!         on entry
!            F      - DOUBLE PRECISION
!                     function subprogram defining the integrand
!                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                     declared E X T E R N A L in the driver program.
!
!            A      - DOUBLE PRECISION
!                     lower limit of integration
!
!            B      - DOUBLE PRECISION
!                     upper limit of integration
!
!            EPSABS - double precision
!                     absolute accuracy requested
!
!            EPSREL - double precision
!                     relative accuracy requested
!
!            Limit  - integer
!                     gives an upperbound on the number of subintervals
!                     in the partition of (A,B)
!
!         On return
!            result - double precision
!                     approximation to the integral
!
!            ABSERR - double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed DABS(I-RESULT)
!
!            IER    - INTEGER
!                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                         = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account). However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. Singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR
!                             occurs at some points of the integration
!                             interval.
!                         = 4 THE ALGORITHM DOES NOT CONVERGE.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 THE INPUT IS INVALID BECAUSE EPSABS OR
!                             EPSREL is negative. Result, ABSERR,
!                             last, RLIST(1), IORD(1), and ELIST(1)
!                             are set to zero. ALIST(1) and BLIST(1)
!                             are set to A and B respectively.
!
!            ALIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left end points
!                     of the subintervals in the partition of the
!                     given integration range (A,B)
!
!            BLIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right end points
!                     of the subintervals in the partition of the given
!                     integration range (A,B)
!
!            RLIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            ELIST  - double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli of the
!                     absolute error estimates on the subintervals
!
!            IORD   - INTEGER
!                     vector of dimension at least limit, the first K
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that ELIST(IORD(1)), ..., ELIST(IORD(K))
!                     FORM A DECREASING SEQUENCE, WITH K = LAST
!                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
!                     otherwise
!
!            LAST   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!
!            VALP   - DOUBLE PRECISION
!            VALN     ARRAYS OF DIMENSION AT LEAST (21,LIMIT) USED TO
!                     save the functional values
!
!            LP     - INTEGER
!            LN       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!                     store the actual number of functional values
!                     saved in the corresponding column
!                     OF VALP,VALN
!
!***ROUTINES CALLED  F,DPMPAR,DQELG,DQXLQM,DQPSRT,DQXRRD,DQXCPY
!
double precision :: a, abseps
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision :: area, area1, area12, area2, a1, a2, b
double precision, intent(inout) :: blist
double precision :: b1, b2, correc, defabs, defab1, defab2, dres
double precision, intent(inout) :: elist
double precision :: epmach
double precision, intent(in) :: epsabs, epsrel
double precision :: erlarg, erlast, errbnd, errmax, error1, &
&error2, erro12, errsum, ertest, f, oflow, rerr, resabs, reseps
double precision, intent(out) :: result
double precision :: res3la(3)
double precision, intent(inout) :: rlist
double precision :: rlist2(52), small, t, uflow
double precision, intent(inout) :: valp, valn
double precision :: vp1(21), vp2(21), vn1(21), vn2(21), dpmpar
integer :: id
integer, intent(out) :: ier
integer :: ierro
integer, intent(inout) :: iord
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer, intent(out) :: last
integer, intent(in) :: limit
integer :: maxerr, nres, nrmax, numrl2
integer, intent(inout) :: lp(limit), ln(limit)
integer :: lp1, lp2, ln1, ln2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
&rlist(limit), valp(21,limit), valn(21,limit)
!
external f
!
!            Machine dependent constants
!            ---------------------------
!
!          EPMACH is the largest relative spacing.
!          UFLOW is the smallest positive magnitude.
!          OFLOW is the largest positive magnitude.
!
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!
!            Test on validity of parameters
!            ------------------------------
last = 0
result = 0.d0
abserr = 0.d0
alist(1) = a
blist(1) = b
rlist(1) = 0.d0
elist(1) = 0.d0
ier = 6
if (epsabs .lt. 0.d0 .or. epsrel.lt. 0.d0) go to 999
ier = 0
rerr = dmax1(epsrel, 50.d0*epmach)
!
!           First approximation to the integral
!           -----------------------------------
!
ierro = 0
lp(1) = 1
ln(1) = 1
valp(1,1) = f((a + b)*0.5d0)
valn(1,1) = valp(1,1)
call dqxlqm (f,a,b,result,abserr,defabs,resabs, &
&valp(1,1),valn(1,1),lp(1),ln(1),2, &
&epmach,uflow,oflow)
!
!           Test on accuracy.
!
dres = dabs(result)
errbnd = dmax1(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr .le. 100.d0*epmach*defabs .and. abserr .gt. &
&errbnd) ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr.le.errbnd.and.abserr.ne.resabs) .or. &
&abserr .eq. 0.d0) go to 999
!
!           Initialization
!           --------------
!
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
nrmax = 1
nres = 0
numrl2 = 2
ktmin = 0
extrap = .false.
noext = .false.
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres .ge. (1.d0 - 50.d0*epmach)*defabs) ksgn = 1
t = 1.d0 + 100.d0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with the NRMAX-TH largest error
!           estimate.
!
  a1 = alist(maxerr)
  b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
  a2 = b1
  b2 = blist(maxerr)
  erlast = errmax
  call dqxrrd(f,valn(1,maxerr),ln(maxerr),b1,a1,vn1,vp1,ln1,lp1)
  call dqxlqm(f,a1,b1,area1,error1,resabs,defab1,vp1,vn1,lp1,ln1, &
&2,epmach,uflow,oflow)
  call dqxrrd(f,valp(1,maxerr),lp(maxerr),a2,b2,vp2,vn2,lp2,ln2)
  call dqxlqm(f,a2,b2,area2,error2,resabs,defab2,vp2,vn2,lp2,ln2, &
&2,epmach,uflow,oflow)
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
  area12 = area1 + area2
  erro12 = error1 + error2
  errsum = errsum + erro12 - errmax
  area = area + area12 - rlist(maxerr)
  if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
  if (dabs(rlist(maxerr) - area12) .gt. 0.1d-04*dabs(area12) &
&.or. erro12 .lt. 0.99d0*errmax) go to 10
  if (extrap) iroff2 = iroff2 + 1
  if (.not.extrap) iroff1 = iroff1 + 1
10 if (last.gt.10 .and. erro12.gt.errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
  rlist(last) = area2
  errbnd = dmax1(epsabs,rerr*dabs(area))
!
!           Test for roundoff error and eventually set error flag.
!
  if (iroff1 + iroff2 .ge. 10 .or. iroff3 .ge. 20) ier = 2
  if (iroff2 .ge. 5) ierro = 3
!
!           Set error flag in the case that the number of subintervals
!           equals limit.
!
  if (last .eq. limit) ier = 1
!
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
!
  if (dmax1(dabs(a1),dabs(b2)) .le. &
&t*(dabs(a2) + 1.d+03*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
  if (error2 .gt. error1) go to 20
  alist(last) = a2
  blist(maxerr) = b1
  blist(last) = b2
  elist(maxerr) = error1
  elist(last) = error2
  call dqxcpy(valp(1,maxerr),vp1,lp1)
  lp(maxerr) = lp1
  call dqxcpy(valn(1,maxerr),vn1,ln1)
  ln(maxerr) = ln1
  call dqxcpy(valp(1,last),vp2,lp2)
  lp(last) = lp2
  call dqxcpy(valn(1,last),vn2,ln2)
  ln(last) = ln2
  go to 30
!
20 alist(maxerr) = a2
  alist(last) = a1
  blist(last) = b1
  rlist(maxerr) = area2
  rlist(last) = area1
  elist(maxerr) = error2
  elist(last) = error1
  call dqxcpy(valp(1,maxerr),vp2,lp2)
  lp(maxerr) = lp2
  call dqxcpy(valn(1,maxerr),vn2,ln2)
  ln(maxerr) = ln2
  call dqxcpy(valp(1,last),vp1,lp1)
  lp(last) = lp1
  call dqxcpy(valn(1,last),vn1,ln1)
  ln(last) = ln1
!
!           CALL SUBROUTINE DQPSRT TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the subinterval
!           with NRMAX-TH largest error estimate (to be bisected next).
!
30 call dqpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***JUMP OUT OF DO-LOOP
  if(errsum .le. errbnd) go to 115
! ***JUMP OUT OF DO-LOOP
  if (ier .ne. 0) go to 100
  if (last .eq. 2) go to 80
  if (noext) go to 90
  erlarg = erlarg - erlast
  if (dabs(b1 - a1) .gt. small) erlarg = erlarg + erro12
  if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
  if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
  extrap = .true.
  nrmax = 2
!
!           The bound 0.3*ERTEST has been introduced to perform A
!           more cautious extrapolation than in the original DQAGSE
!           routine
!
40 if (ierro .eq. 3 .or. erlarg .le. 0.3d0*ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors over the
!           larger intervals (ERLARG) and perform extrapolation.
!
  id = nrmax
  jupbnd = last
  if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
  do 50 k = id,jupbnd
    maxerr = iord(nrmax)
    errmax = elist(maxerr)
! ***JUMP OUT OF DO-LOOP
    if(dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
    nrmax = nrmax + 1
50 continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
  rlist2(numrl2) = area
  call dqelg (numrl2,rlist2,reseps,abseps,res3la,nres, &
&epmach,oflow)
  ktmin = ktmin + 1
  if (ktmin .gt. 5 .and. abserr .lt. 0.1d-02*errsum) ier = 5
  if (abseps .ge. abserr) go to 70
  ktmin = 0
  abserr = abseps
  result = reseps
  correc = erlarg
  ertest = dmax1(epsabs,rerr*dabs(reseps))
! ***JUMP OUT OF DO-LOOP
  if (abserr .le. ertest) go to 100
!
!           Prepare bisection of the smallest interval.
!
70 if (numrl2 .eq. 1) noext = .true.
  if (ier .eq. 5) go to 100
  maxerr = iord(1)
  errmax = elist(maxerr)
  nrmax = 1
  extrap = .false.
  small = small*0.5d0
  erlarg = errsum
  go to 90
80 small = dabs(b - a)*0.375d0
  erlarg = errsum
  ertest = errbnd
  rlist2(2) = area
90 continue
!
!           Set final result and error estimate.
!           ------------------------------------
!
100 if (abserr .eq. oflow) go to 115
if (ier + ierro .eq. 0) go to 110
if (ierro .eq. 3) abserr = abserr + correc
if (ier .eq. 0) ier = 3
if (result .ne. 0.d0 .and. area .ne. 0.d0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.d0) go to 130
go to 110
105 if (abserr/dabs(result) .gt. errsum/dabs(area)) go to 115
!
!           Test on divergence.
!
110 if(ksgn.eq.(-1).and.dmax1(dabs(result),dabs(area)).le. &
&defabs*0.1d-01) go to 130
if(0.1d-01.gt.(result/area).or.(result/area).gt.0.1d+03 &
&.or.errsum.gt.dabs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.d0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier .gt. 2) ier = ier - 1
999 return
end subroutine dqxgse

subroutine dqxcpy (a, b, l)
implicit none
integer :: i
!
!  TO COPY THE DOUBLE PRECISION VECTOR B OF LENGTH L   I N T O
!          the double precision vector A of length L
!
integer, intent(in) :: l
double precision, intent(inout) :: a(l)
double precision, intent(in) :: b(l)
!
do 10 i = 1,l
10 a(i) = b(i)
return
end subroutine dqxcpy

subroutine dqxlqm (f,a,b,result,abserr,resabs,resasc,vr,vs,lr,ls, &
&key,epmach,uflow,oflow)
implicit none
!
!            TO COMPUTE I = INTEGRAL OF F OVER (A,B), WITH ERROR
!                           estimate
!                       J = INTEGRAL OF DABS(F) OVER (A,B)
!
!           Parameters
!            on entry
!              F      - DOUBLE PRECISION
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       declared E X T E R N A L in the driver program.
!
!              A      - DOUBLE PRECISION
!                       lower limit of integration
!
!              B      - DOUBLE PRECISION
!                       upper limit of integration
!
!              VR     - DOUBLE PRECISION
!                       vector of length LR containing the
!                       saved  functional values of positive abscissas
!
!              VS     - DOUBLE PRECISION
!                       vector of length LS containing the
!                       saved  functional values of negative abscissas
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTS IN
!                       VR,vs respectively
!
!            KEY    - INTEGER
!                     key for choice of local integration rule
!                     rms formulas are used with
!                      13 - 19               POINTS IF KEY.LT.1,
!                      13 - 19 - (27)        POINTS IF KEY = 1,
!                      13 - 19 - (27) - (41) POINTS IF KEY = 2,
!                           19 -  27  - (41) POINTS IF KEY = 3,
!                                 27  -  41  POINTS IF KEY.GT.3.
!
!                         (Rules) used if the function APPEARS
!                         enough regular
!
!              EPMACH - double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              UFLOW  - double precision
!                       the smallest positive magnitude.
!
!              OFLOW  - double precision
!                       the largest positive magnitude.
!
!            On return
!              result - double precision
!                       approximation to the integral I
!
!              ABSERR - double precision
!                       estimate of the modulus of the absolute error,
!                       which should not exceed DABS(I-RESULT)
!
!              RESABS - double precision
!                       approximation to the integral J
!
!              RESASC - double precision
!                       approximation to the integral of DABS(F-I/(B-A))
!                       OVER (A,B)
!
!              VR     - DOUBLE PRECISION
!                       vector of length LR containing the
!                       saved  functional values of positive abscissas
!
!              VS     - DOUBLE PRECISION
!                       vector of length LS containing the
!                       saved  functional values of negative abscissas
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTS IN
!                       VR,vs respectively
!
!***ROUTINES CALLED  DQXRUL
!
double precision :: f
double precision, intent(in) :: a, b
double precision, intent(inout) :: result, abserr, resabs, resasc
double precision :: t
double precision, intent(in) :: epmach, oflow, uflow
double precision :: resg, resk, errold
double precision, intent(inout) :: vr(21), vs(21)
integer :: k, k0, k1, k2
integer, intent(in) :: key
integer :: key1
integer, intent(inout) :: lr, ls
external f
!
key1 = max0(key ,  0)
key1 = min0(key1,  4)
k0   = max0(key1-2,0)
k1   = k0 + 1
k2   = min0(key1+1,3)
!
call dqxrul (f,a,b,resg,resabs,resasc,k0,k1,vr,vs,lr,ls)
errold = oflow
t = 10.d0*epmach
do 10 k = k1,k2
  call dqxrul (f,a,b,resk,resabs,resasc,k,k1,vr,vs,lr,ls)
  result = resk
  abserr = dabs(resk - resg)
  if (resasc .ne. 0.d0 .and. abserr .ne. 0.d0) &
&abserr = resasc*dmin1(1.d0,(200.d0*abserr/resasc)**1.5d0)
  if (resabs .gt. uflow/t) abserr = dmax1(t*resabs,abserr)
  resg = resk
  if (abserr .gt. errold*0.16d0) go to 3000
  if (abserr .lt. 1000.d0*epmach*resabs) go to 3000
  errold = abserr
10 continue
3000 continue
return
end subroutine dqxlqm

subroutine dqxrul (f,xl,xu,y,ya,ym,ke,k1,fv1,fv2,l1,l2)
implicit none
integer :: i, is, k, ks
!
!            TO COMPUTE I = INTEGRAL OF F OVER (A,B), WITH ERROR
!                           estimate
!            and conditionally compute
!                       J = INTEGRAL OF DABS(F) OVER (A,B)
!                       by using an  rms rule
!           parameters
!            on entry
!              F      - DOUBLE PRECISION
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       declared E X T E R N A L in the driver program.
!
!              XL     - DOUBLE PRECISION
!                       lower limit of integration
!
!              XU     - DOUBLE PRECISION
!                       upper limit of integration
!
!              KE     - INTEGER
!                     key for choice of local integration rule
!                     an rms rule is used with
!                         13      POINTS IF KE  = 2,
!                         19      POINTS IF KE  = 3,
!                         27      POINTS IF KE  = 4,
!                         42      POINTS IF KE  = 5
!
!              K1     INTEGER
!                     value of key for which the additional estimates
!                     YA, YM are to be computed
!
!              FV1    - DOUBLE PRECISION
!                       vector containing L1
!                       saved  functional values of positive abscissas
!
!              FV2    - DOUBLE PRECISION
!                       vector containing L2
!                       saved  functional values of negative abscissas
!
!              L1     - INTEGER
!              L2       NUMBER OF ELEMENTS IN FV1,FV2  RESPECTIVELY
!
!            On return
!              Y      - DOUBLE PRECISION
!                       approximation to the integral I
!                       result is computed by applying the
!                       requested rms rule
!
!              YA     - DOUBLE PRECISION
!                       IF KEY = K1  APPROXIMATION TO THE INTEGRAL J
!                       ELSE UNCHANGED
!
!              YM     - DOUBLE PRECISION
!                       IF KEY = K1  APPROXIMATION TO THE INTEGRAL OF
!                                      DABS(F-I/(XU-XL)   OVER (XL,XU)
!                       ELSE UNCHANGED
!
!              FV1    - DOUBLE PRECISION
!                       vector containing L1
!                       saved  functional values of positive abscissas
!
!              FV2    - DOUBLE PRECISION
!                       vector containing L2
!                       saved  functional values of negative abscissas
!
!              L1     - INTEGER
!              L2       NUMBER OF ELEMENTS IN FV1,FV2  RESPECTIVELY
!
!------------------------
double precision :: f
double precision, intent(in) :: xl, xu
double precision :: ldl
double precision, intent(out) :: y
double precision, intent(inout) :: ya, ym
double precision :: y2, xx(41), ww(52)
double precision, intent(inout) :: fv1(21), fv2(21)
double precision :: aa, bb, c
integer :: istart(4), len(4), j
integer, intent(in) :: ke, k1
integer, intent(inout) :: l1, l2
external f
!------------------------
data istart(1)/0/, istart(2)/7/, istart(3)/17/, istart(4)/31/
data len(1)/7/, len(2)/10/, len(3)/14/, len(4)/21/
!------------------------
data xx( 1)/0.d0                     /
data xx( 2)/.25000000000000000000d+00/
data xx( 3)/.50000000000000000000d+00/
data xx( 4)/.75000000000000000000d+00/
data xx( 5)/.87500000000000000000d+00/
data xx( 6)/.93750000000000000000d+00/
data xx( 7)/.10000000000000000000d+01/
data xx( 8)/.37500000000000000000d+00/
data xx( 9)/.62500000000000000000d+00/
data xx(10)/.96875000000000000000d+00/
data xx(11)/.12500000000000000000d+00/
data xx(12)/.68750000000000000000d+00/
data xx(13)/.81250000000000000000d+00/
data xx(14)/.98437500000000000000d+00/
data xx(15)/.18750000000000000000d+00/
data xx(16)/.31250000000000000000d+00/
data xx(17)/.43750000000000000000d+00/
data xx(18)/.56250000000000000000d+00/
data xx(19)/.84375000000000000000d+00/
data xx(20)/.90625000000000000000d+00/
data xx(21)/.99218750000000000000d+00/
!   Number of nodes 13
data ww(1)/1.303262173284849021810473057638590518409112513421d-1/
data ww(2)/2.390632866847646220320329836544615917290026806242d-1/
data ww(3)/2.630626354774670227333506083741355715758124943143d-1/
data ww(4)/2.186819313830574175167853094864355208948886875898d-1/
data ww(5)/2.757897646642836865859601197607471574336674206700d-2/
data ww(6)/1.055750100538458443365034879086669791305550493830d-1/
data ww(7)/1.571194260595182254168429283636656908546309467968d-2/
!   Number of nodes 19
data ww(8)/1.298751627936015783241173611320651866834051160074d-1/
data ww(9)/2.249996826462523640447834514709508786970828213187d-1/
data ww(15)/5.542699233295875168406783695143646338274805359780d-2/
data ww(10)/1.680415725925575286319046726692683040162290325505d-1/
data ww(16)/9.986735247403367525720377847755415293097913496236d-2/
data ww(11)/1.415567675701225879892811622832845252125600939627d-1/
data ww(12)/1.006482260551160175038684459742336605269707889822d-1/
data ww(13)/2.510604860724282479058338820428989444699235030871d-2/
data ww(17)/4.507523056810492466415880450799432587809828791196d-2/
data ww(14)/9.402964360009747110031098328922608224934320397592d-3/
!   Number of nodes 27
data ww(18)/6.300942249647773931746170540321811473310938661469d-2/
data ww(28)/1.239572396231834242194189674243818619042280816640d-1/
data ww(19)/1.261383225537664703012999637242003647020326905948d-1/
data ww(25)/1.235837891364555000245004813294817451524633100256d-1/
data ww(20)/1.273864433581028272878709981850307363453523117880d-1/
data ww(26)/1.148933497158144016800199601785309838604146040215d-1/
data ww(29)/2.501306413750310579525950767549691151739047969345d-2/
data ww(21)/8.576500414311820514214087864326799153427368592787d-2/
data ww(30)/4.915957918146130094258849161350510503556792927578d-2/
data ww(22)/7.102884842310253397447305465997026228407227220665d-2/
data ww(23)/5.026383572857942403759829860675892897279675661654d-2/
data ww(27)/1.252575774226122633391477702593585307254527198070d-2/
data ww(31)/2.259167374956474713302030584548274729936249753832d-2/
data ww(24)/4.683670010609093810432609684738393586390722052124d-3/
!   Number of nodes 41
data ww(32)/6.362762978782724559269342300509058175967124446839d-2/
data ww(42)/1.187141856692283347609436153545356484256869129472d-1/
data ww(46)/1.533126874056586959338368742803997744815413565014d-2/
data ww(33)/9.950065827346794643193261975720606296171462239514d-2/
data ww(47)/3.527159369750123100455704702965541866345781113903d-2/
data ww(39)/8.140326425945938045967829319725797511040878579808d-2/
data ww(48)/5.000556431653955124212795201196389006184693561679d-2/
data ww(34)/7.048220002718565366098742295389607994441704889441d-2/
data ww(49)/5.744164831179720106340717579281831675999717767532d-2/
data ww(40)/6.583213447600552906273539578430361199084485578379d-2/
data ww(43)/5.999947605385971985589674757013565610751028128731d-2/
data ww(35)/6.512297339398335645872697307762912795346716454337d-2/
data ww(44)/5.500937980198041736910257988346101839062581489820d-2/
data ww(50)/1.598823797283813438301248206397233634639162043386d-2/
data ww(36)/3.998229150313659724790527138690215186863915308702d-2/
data ww(51)/2.635660410220884993472478832884065450876913559421d-2/
data ww(37)/3.456512257080287509832054272964315588028252136044d-2/
data ww(41)/2.592913726450792546064232192976262988065252032902d-2/
data ww(45)/5.264422421764655969760271538981443718440340270116d-3/
data ww(52)/1.196003937945541091670106760660561117114584656319d-2/
data ww(38)/2.212167975884114432760321569298651047876071264944d-3/
!------------------------
k = ke + 1
is = istart(k)
ks = len(k)
ldl = xu - xl
bb = ldl*0.5d0
aa = xl + bb
!
y = 0.d0
do 10 i = 1,ks
   c = bb*xx(i)
   if (i .gt. l1) fv1(i) = f(aa + c)
   if (i .gt. l2) fv2(i) = f(aa - c)
   j = is + i
   y = y + (fv1(i) + fv2(i))*ww(j)
10 continue
!
y2 = y
y = y*bb
if (l1 .lt. ks) l1 = ks
if (l2 .lt. ks) l2 = ks
if (ke .ne. k1) return
!
ya = 0.d0
do 20 i = 1,ks
   j = is + i
   ya = ya + (dabs(fv1(i)) + dabs(fv2(i)))*ww(j)
20 continue
ya = ya*dabs(bb)
!
y2 = y2*0.5d0
ym = 0.d0
do 30 i = 1,ks
   j = is + i
   ym = ym + (dabs(fv1(i) - y2) + dabs(fv2(i) - y2))*ww(j)
30 continue
ym = ym*dabs(bb)
return
end subroutine dqxrul

subroutine dqxrrd (f,z,lz,xl,xu,r,s,lr,ls)
implicit none
!
!            To reorder the computed functional values before
!            the bisection of an interval
!
!           Parameters
!            on entry
!              F      - DOUBLE PRECISION
!                       function subprogram defining the integrand
!                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
!                       declared E X T E R N A L in the driver program.
!
!              XL     - DOUBLE PRECISION
!                       lower limit of interval
!
!              XU     - DOUBLE PRECISION
!                       upper limit of interval
!
!              Z      - DOUBLE PRECISION
!                       vector containing LZ
!                       saved  functional values
!
!              LZ     - INTEGER
!                       number of elements in LZ
!
!            On return
!              R      - DOUBLE PRECISION
!              S        VECTORS CONTAINING LR, LS
!                       saved  functional values for the new intervals
!
!              LR     - INTEGER
!              LS       NUMBER OF ELEMENTES IN R,S RESPECTIVELY
!
!***ROUTINES CALLED  F
!
double precision :: f
double precision, intent(inout) :: r(21), s(21)
double precision :: z(21)
double precision, intent(in) :: xu, xl
double precision :: dlen, centr
integer, intent(inout) :: lr, ls
integer, intent(in) :: lz
!
dlen = (xu - xl)*0.5d0
centr = xl + dlen
r(1) =  z(3)
r(2) =  z(9)
r(3) =  z(4)
r(4) =  z(5)
r(5) =  z(6)
r(6) =  z(10)
r(7) =  z(7)
s(1) =  z(3)
s(2) =  z(8)
s(3) =  z(2)
s(7) =  z(1)
if (lz .gt. 11) go to 10
!
r(8) =  f(centr + dlen*0.375d0)
r(9) =  f(centr + dlen*0.625d0)
r(10) = f(centr + dlen*0.96875d0)
lr = 10
if (lz .ne. 11) s(4) = f(centr - dlen*0.75d0)
if (lz .eq. 11) s(4) = z(11)
s(5) =  f(centr - dlen*0.875d0)
s(6) =  f(centr - dlen*0.9375d0)
s(8) =  f(centr - dlen*0.375d0)
s(9) =  f(centr - dlen*0.625d0)
s(10) = f(centr - dlen*0.96875d0)
ls = 10
return
!
10 r(8) = z(12)
r(9) = z(13)
r(10) = z(14)
lr = 10
s(4) = z(11)
s(5) = f(centr - dlen*0.875d0)
s(6) = f(centr - dlen*0.9375d0)
if (lz .gt. 14) go to 20
s(8)  = f(centr - dlen*0.375d0)
s(9)  = f(centr - dlen*0.625d0)
s(10) = f(centr - dlen*0.96875d0)
ls = 10
return
!
20 r(11) = z(18)
r(12) = z(19)
r(13) = z(20)
r(14) = z(21)
lr = 14
s(8) = z(16)
s(9) = z(15)
s(10) = f(centr - dlen*0.96875d0)
s(11) = z(17)
ls = 11
return
end subroutine dqxrrd

subroutine cubtri(f, t, eps, mcalls, ans, err, ncalls, w, nw, &
&idata, rdata, ier)
implicit none
integer :: i, j, jkp, k, l, maxc, maxk, mw, nfe
real :: one, point5, zero
real :: rnderr
real :: f
!
!       Adaptive cubature over a triangle
!
!       Parameters
!          F     - USER SUPPLIED EXTERNAL FUNCTION OF THE FORM
!                  F(X,Y,IDATA,RDATA)
!                  where X and Y are the cartesian coordinates of A
!                  point in the plane, and idata and RDATA are integer
!                  and real vectors in which data may be passed.
!          T     - ARRAY OF DIMENSION (2,3) WHERE T(1,J) AND T(2,J)
!                  are the X and Y coordinates of the J-TH vertex of
!                  the given triangle (input)
!          EPS   - REQUIRED TOLERANCE (INPUT).  IF THE COMPUTED
!                  integral is between-1 and 1, an absolute error
!                  test is used, else a relative error test is used.
!          MCALLS- maximum permitted number of calls to F (input)
!          ANS   - ESTIMATE FOR THE VALUE OF THE INTEGRAL OF F OVER
!                  the given triangle (OUTPUT)
!          ERR   - ESTIMATED ABSOLUTE ERROR IN ANS (OUTPUT)
!          NCALLS- actual number of calls to F (OUTPUT).  This
!                  parameter must be initialized to 0 on the first
!                  CALL TO CUBTRI FOR A GIVEN INTEGRAL (INPUT)
!          W     - WORK SPACE.  MAY NOT BE DESTROYED BETWEEN CALLS TO
!                  CUBTRI if restarting is intended
!          NW    - LENGTH OF WORK SPACE (INPUT).
!                  IF NW .GE. 3*(19+3*MCALLS)/38, TERMINATION DUE TO
!                  full work space will not occur.
!          IER   - TERMINATION INDICATOR (OUTPUT)
!                  IER=0   NORMAL TERMINATION, TOLERANCE SATISFIED
!                  IER=1   MAXIMUM NUMBER OF CALLS REACHED
!                  IER=2   WORK SPACE FULL
!                  IER=3   FURTHER SUBDIVISION OF TRIANGLES IMPOSSIBLE
!                  IER=4   NO FURTHER IMPROVEMENT IN ACCURACY IS
!                        possible due to rounding errors in function
!                        values
!                  IER=5   NO FURTHER IMPROVEMENT IN ACCURACY IS
!                        possible because subdivision does not
!                        change the estimated integral. Machine
!                        accuracy has probably been reached but
!                        the error estimate is not sharp enough.
!
!       CUBTRI is designed to be called repeatedly without wasting
!       earlier work.  The parameter NCALLS is used to indicate to
!       CUBTRI at what point to restart, and must be RE-initialized
!       to 0 when a new integral is to be computed.  At least one of
!       the parameters eps, MCALLS and NW must be changed between
!       calls to CUBTRI, according to the returned value of ier. None
!       of the other parameters may be changed if restarting is done.
!       IF IER=3 IS ENCOUNTERED, THERE PROBABLY IS A SINGULARITY
!       somewhere in the region.  The error message indicates that
!       further subdivision is impossible because the vertices of the
!       smaller triangles produced will begin to coalesce to the
!       precision of the computer.  This situation can usually be
!       relieved by specifying the region in such a way that the
!       singularity is located at the third vertex of the triangle.
!       IF IER=4 IS ENCOUNTERED, THE VALUE OF THE INTEGRAL CANNOT BE
!       improved any further. The only exception to this occurs when A
!       function with highly irregular behaviour is integrated (E.G.
!       Functions with jump discontinuities or very highly oscillatory
!       functions). In such a case the user can disable the rounding
!       error test by removing the if statement immediately preceding
!       statement number 90.
!
external f
integer :: idata(*), ier, mcalls, ncalls, nw
real :: alfa, ans, anskp, area, eps, err, errmax, h, q1, q2, r1, &
&r2, rdata(*), d(2,4), s(4), t(2,*), vec(2,3), w(6,nw), x(2)
!       Actual dimension of W is (6,NW/6)
!
double precision :: tans, terr, dzero
common /cubsta/ tans, terr
!       This common is required to preserve tans and terr between calls
!       and to save variables in function RNDERR
data nfe /19/, s(1), s(2), s(3), s(4) /3*1e0,-1e0/, d(1,1), &
&d(2,1) /0.0,0.0/, d(1,2), d(2,2) /0.0,1.0/, d(1,3), d(2,3) &
&/1.0,0.0/, d(1,4), d(2,4) /1.0,1.0/
!       NFE is the number of function evaluations per call to CUBRUL.
data zero /0.e0/, one /1.e0/, dzero /0.d0/, point5 /.5e0/
!
!      Calculate direction vectors, area and maximum number
!      of subdivisions that may be performed
do i=1,2
  vec(i,3) = t(i,3)
  do j=1,2
    vec(i,j) = t(i,j) - t(i,3)
  end do
end do
maxc = (mcalls/nfe+3)/4
ier = 1
maxk = min0(maxc,(nw/6+2)/3)
if (maxc.gt.maxk) ier = 2
area = abs(vec(1,1)*vec(2,2)-vec(1,2)*vec(2,1))*point5
k = (ncalls/nfe+3)/4
mw = 3*(k-1) + 1
if (ncalls.gt.0) go to 30
!
!       Test for trivial cases
tans = dzero
terr = dzero
if (area.eq.zero) go to 90
if (mcalls.lt.nfe) go to 100
if (nw.lt.6) go to 110
!
!       Initialize data list
k = 1
mw = 1
w(1,1) = zero
w(2,1) = zero
w(3,1) = one
call cubrul(f, vec, w(1,1), idata, rdata)
tans = w(5,1)
terr = w(6,1)
ncalls = nfe
!
!       Test termination criteria
30 ans = tans
err = terr
if (err.lt.amax1(one,abs(ans))*eps) go to 90
if (k.eq.maxk) go to 120
!
!       Find triangle with largest error
errmax = zero
do 40 i = 1,mw
  if (w(6,i).le.errmax) go to 40
  errmax = w(6,i)
  j = i
40 continue
!
!       Subdivide triangle into four subtriangles and update data list
do i=1,2
  x(i) = w(i,j)
end do
h = w(3,j)*point5
if (rnderr(x(1),h,x(1),h).ne.zero) go to 130
if (rnderr(x(2),h,x(2),h).ne.zero) go to 130
anskp = sngl(tans)
tans = tans - dble(w(5,j))
terr = terr - dble(w(6,j))
r1 = w(4,j)
r2 = w(5,j)
jkp = j
q1 = zero
q2 = zero
do i=1,4
  do l=1,2
    w(l,j) = x(l) + h*d(l,i)
  end do
  w(3,j) = h*s(i)
  call cubrul(f, vec, w(1,j), idata, rdata)
  q2 = q2 + w(5,j)
  q1 = q1 + w(4,j)
  j = mw + i
end do
alfa = 1e15
if (q2.ne.r2) alfa = abs((q1-r1)/(q2-r2)-one)
j = jkp
do i=1,4
  w(6,j) = w(6,j)/alfa
  tans = tans + w(5,j)
  terr = terr + w(6,j)
  j = mw + i
end do
mw = mw + 3
ncalls = ncalls + 4*nfe
k = k + 1
!
!       If answer is unchanged, it cannot be improved
if (anskp.eq.sngl(tans)) go to 150
!
!       Remove this if statement to disable rounding error test
if (k.gt.3 .and. abs(q2-r2).gt.abs(q1-r1)) go to 140
go to 30
!
!       Exits from subroutine
90 ier = 0
go to 120
100 ier = 1
go to 120
110 ier = 2
120 ans = tans
err = terr
return
130 ier = 3
go to 120
140 ier = 4
go to 120
150 ier = 5
go to 120
end subroutine cubtri

function rnderr(x, a, y, b)
implicit none
real :: a, b, x, y
real :: s, t
real :: rnderr
!       This function computes the rounding error committed when the
!       sum X+A is formed.  In the calling program, Y must be the same
!       as X and B must be the same as A.  They are declared as
!       distinct variables in this function, and the intermediate
!       variables S and T are put into common, in order to defend
!       against the well-meaning actions of some officious optimizing
!       Fortran compilers.
common /cubatb/ s, t
s = x + a
t = s - y
rnderr = t - b
return
end function rnderr

subroutine cubrul(f, vec, p, idata, rdata)
implicit none
integer :: i, j, k, nquad
real :: point5, x, y
real :: f
!
!       BASIC cubature rule pair over a triangle
!
!       Parameters
!         F  - external function - see comments to CUBTRI
!         VEC- matrix of base vectors and origin (input)
!         P  - triangle description vector of dimension 6
!               P(1) - transformed X coordinate of origin VERTEX(INPUT)
!               P(2) - transformed Y coordinate of origin VERTEX(INPUT)
!               P(3) - distance of other vertices in the directions
!                     of the base vectors (input)
!               P(4) - less accurate estimated integral (OUTPUT)
!               P(5) - more accurate estimated integral (OUTPUT)
!               P(6) - ABS(P(5)-P(4))   (OUTPUT)
!
!       CUBRUL evaluates a linear combination of BASIC integration
!       rules having D3 symmetry.  The areal coordinates pertaining to
!       THE J-TH RULE ARE STORED IN W(I,J),I=1,2,3.  THE CORRESPONDING
!       weights are W(4,J) and W(5,J), with W(5,J) belonging to the
!       MORE ACCURATE FORMULA.  IF W(1,J).EQ.W(2,J), THE INTEGRATION
!       POINT IS THE CENTROID, ELSE IF W(2,J).EQ.W(3,J), THE EVALUATION
!       points are on the medians.  In both cases advantage is taken of
!       symmetry to avoid repeating function evaluations.
!
!       The following double precision variables are used to avoid
!       unnecessary rounding errors in floating point addition.
!       They may be declared single precision if double precision is
!       not available and full accuracy is not needed.
!
double precision :: a1, a2, s, sn, dzero, done, dthree, dsix
real :: area, origin(2)
real, intent(inout) :: p(*)
real :: rdata(*), tvec(2,3)
real, intent(in) :: vec(2,*)
real :: w(5,6)
integer :: idata(*)
external f
!
!       W contains points and weights of the integration formulae
!       NQUAD - number of BASIC rules used
!
!       This particular rule is the 19 point extension (degree 8) of
!       the familiar 7 point rule (degree 5).
!
!     SIGMA=SQRT(7)
!     PHI=SQRT(15)
!     W(1,1),W(2,1),W(3,1) = 1/3
!     W(4,1) = 9/40
!     W(5,1) = 7137/62720 - 45*SIGMA/1568
!     W(1,2) = 3/7 + 2*PHI/21
!     W(2,2),W(3,2) = 2/7 - PHI/21
!     W(4,2) = 31/80 - PHI/400
!     W(5,2) = - 9301697/4695040 - 13517313*PHI/23475200
!            + 764885*sigma/939008 + 198763*phi*sigma/939008
!     W(*,3) = W(*,2) WITH PHI REPLACED BY -PHI
!     W(1,5) = 4/9 + PHI/9 + SIGMA/9 - SIGMA*PHI/45
!     W(2,5),W(3,5) = 5/18 - PHI/18 - SIGMA/18 + SIGMA*PHI/90
!     W(4,5) = 0
!     W(5,5) = 102791225/59157504 + 23876225*PHI/59157504
!            - 34500875*sigma/59157504 - 9914825*phi*sigma/59157504
!     W(*,4) = W(*,5) WITH PHI REPLACED BY -PHI
!     W(1,6) = 4/9 + SIGMA/9
!     W(2,6) = W(2,4)
!     W(3,6) = W(2,5)
!     W(4,6) = 0
!     W(5,6) = 11075/8064 - 125*SIGMA/288
!
data nquad /6/
data w(1,1), w(2,1), w(3,1) /3*.3333333333333333333333333e0/, &
&w(4,1), w(5,1) /.225e0,.3786109120031468330830822e-1/, &
&w(1,2), w(2,2), w(3,2) /.7974269853530873223980253e0,2* &
&.1012865073234563388009874e0/, w(4,2), w(5,2) &
&/.3778175416344814577870518e0,.1128612762395489164329420e0/, &
&w(1,3), w(2,3), w(3,3) /.5971587178976982045911758e-1,2* &
&.4701420641051150897704412e0/, w(4,3), w(5,3) &
&/.3971824583655185422129482e0,.2350720567323520126663380e0/
data w(1,4), w(2,4), w(3,4) /.5357953464498992646629509e0,2* &
&.2321023267750503676685246e0/, w(4,4), w(5,4) &
&/0.e0,.3488144389708976891842461e0/, w(1,5), w(2,5), w(3,5) &
&/.9410382782311208665596304e0,2*.2948086088443956672018481e-1/, &
&w(4,5), w(5,5) /0.e0,.4033280212549620569433320e-1/, w(1,6), &
&w(2,6), w(3,6) /.7384168123405100656112906e0, &
&.2321023267750503676685246e0,.2948086088443956672018481e-1/, &
&w(4,6), w(5,6) /0.e0,.2250583347313904927138324e0/
!
data dzero /0.d0/, done /1.d0/, dthree /3.d0/, dsix /6.d0/, &
&point5 /.5e0/
!
!       Scale base vectors and obtain area
!
do i=1,2
  origin(i) = vec(i,3) + p(1)*vec(i,1) + p(2)*vec(i,2)
  do j=1,2
    tvec(i,j) = p(3)*vec(i,j)
  end do
end do
area = point5*abs(tvec(1,1)*tvec(2,2)-tvec(1,2)*tvec(2,1))
a1 = dzero
a2 = dzero
!
!       Compute estimates for integral and error
!
do k=1,nquad
  x = origin(1) + w(1,k)*tvec(1,1) + w(2,k)*tvec(1,2)
  y = origin(2) + w(1,k)*tvec(2,1) + w(2,k)*tvec(2,2)
  s = dble(f(x,y,idata,rdata))
  sn = done
  if (w(1,k).eq.w(2,k)) go to 30
  x = origin(1) + w(2,k)*tvec(1,1) + w(1,k)*tvec(1,2)
  y = origin(2) + w(2,k)*tvec(2,1) + w(1,k)*tvec(2,2)
  s = s + dble(f(x,y,idata,rdata))
  x = origin(1) + w(2,k)*tvec(1,1) + w(3,k)*tvec(1,2)
  y = origin(2) + w(2,k)*tvec(2,1) + w(3,k)*tvec(2,2)
  s = s + dble(f(x,y,idata,rdata))
  sn = dthree
  if (w(2,k).eq.w(3,k)) go to 30
  x = origin(1) + w(1,k)*tvec(1,1) + w(3,k)*tvec(1,2)
  y = origin(2) + w(1,k)*tvec(2,1) + w(3,k)*tvec(2,2)
  s = s + dble(f(x,y,idata,rdata))
  x = origin(1) + w(3,k)*tvec(1,1) + w(1,k)*tvec(1,2)
  y = origin(2) + w(3,k)*tvec(2,1) + w(1,k)*tvec(2,2)
  s = s + dble(f(x,y,idata,rdata))
  x = origin(1) + w(3,k)*tvec(1,1) + w(2,k)*tvec(1,2)
  y = origin(2) + w(3,k)*tvec(2,1) + w(2,k)*tvec(2,2)
  s = s + dble(f(x,y,idata,rdata))
  sn = dsix
30 s = s/sn
  a1 = a1 + w(4,k)*s
  a2 = a2 + w(5,k)*s
end do
p(4) = sngl(a1)*area
p(5) = sngl(a2)*area
p(6) = abs(p(5)-p(4))
return
end subroutine cubrul

subroutine ieslv (kernel,rhfcn,a,b,ep,iflag,t,x,nt,nupper, &
&mupper,nf,mf,norm,w,ier)
implicit none
integer :: ier, iflag, mf, mupper, nf, nt, nupper
real :: a, b, ep, t(*), w(*), x(*)
integer :: i1, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, &
&i2, i20, i21, i3, i4, i5, i6, i7, i8, i9, m, n, nhalf, nmax, nsq, &
&nup
real :: cutoff, rootrt, unitrd
integer :: mfinal, nfinal
real :: finlep, r1, r2
real :: rhfcn
real :: spmpar
!
!   The integral equation being solved is
!
!                     B
!          X(S) -  INT  KERNEL(S,T)*X(T)*DT = RHFCN(S)
!                     A
!
!   The method being used is based on the Nystrom method with
!   Gaussian quadrature, with an iterative technique of solution
!   for the resulting linear system.
!
!   KERNEL     THESE ARE REAL FUNCTIONS OF TWO AND ONE
!   RHFCN      VARIABLES, RESPECTIVELY. THEY MUST BE DECLARED IN AN
!              external statement in the program calling IESLV.
!   EP         THE DESIRED ERROR. THE VARIABLE EP IS CHANGED ON
!              completion of the program. See the discussion of ier
!              and IFLAG for more information.
!   IFLAG =0   EP IS INTERPRETED AS AN ABSOLUTE ERROR TOLERANCE.
!         =1   EP IS INTERPRETED AS A RELATIVE ERROR TOLERANCE.
!   T          CONTAINS THE NODE POINTS AT WHICH THE SOLUTION OF THE
!              integral equation is desired. See the variable NT for
!              more information.
!   X          THE COMPUTED APPROXIMATE SOLUTION OF THE INTEGRAL
!              equation, evaluated at the node points in T, is
!              stored in X on completion of the routine. This is
!              true irregardless of whether or not the desired error
!              tolerance was attained.
!   NT         IF NT=0, THEN T AND X WILL BE SET EQUAL TO THE FINAL
!              Gaussian nodes and the corresponding solution values,
!              and NT will be set to the number of the solution
!              values stored in X and T. The arrays T and X should
!              have dimension at least MUPPER, assigned in the
!              calling program.
!              IF NT .GT. 0, THEN T CONTAINS NT USER SUPPLIED NODES
!              at which the solution X is desired.
!   NUPPER     AN UPPER LIMIT ON THE VARIABLE N IN THIS PROGRAM.
!              N is the order of a linear system which is being
!              used to iteratively solve a larger linear system of
!              order M which approximates the integral equation.
!              (For further details concerning the maximum value
!              that N can take, see the description of NMAX below.)
!   MUPPER     AN UPPER LIMIT ON THE VARIABLE M IN THE PROGRAM.
!              N and M are always powers of two.
!   NF         SAME AS NFINAL (SEE BELOW)
!   MF         SAME AS MFINAL (SEE BELOW)
!   NORM       SAME AS NORMK (SEE BELOW)
!   W          TEMPORARY WORKING STORAGE FOR THE PROGRAM. IT MUST
!              contain at least 5*nu*nu+9*(NU+MU) positions, with
!              NU=NUPPER, MU=MUPPER.
!   IER =0     THIS ERROR COMPLETION CODE MEANS THE ROUTINE WAS
!              completed satisfactorily. EP contains the predicted
!              error.
!       =1     THE ERROR TEST WAS NOT SATISFIED. EP CONTAINS THE
!              predicted error.
!       =2     THE ERROR TEST WAS NOT SATISFIED. EP HAS BEEN SET
!              to zero.
!       =3     THE ORIGINAL VALUE OF EP WAS TOO SMALL, DUE TO
!              possible ill-conditioning problems in the integral
!              equation. The value of EP was reset to a more
!              realistic value, and that tolerance was attained.
!       =4     THE ERROR WAS SATISFACTORY AT THE GAUSSIAN NODE
!              POINTS (IER=0), BUT THE INTERPOLATION PROCESS(DUE TO
!              NT .GT. 0) MAY NOT PRESERVE THIS ACCURACY. CHECK THE
!              value of NORM(K) for possible indications that the
!              integral equation may be almost first kind. Such
!              equations are quite ill-conditioned. The error in EP
!              is the predicted error for the solution at the
!              Gaussian node points of order MFINAL.
!       =5     THE ANALOGUE OF IER=4, BUT WITH IER=1 AT THE
!              Gaussian node points.
!       =6     THE ANALOGUE OF IER=4, BUT WITH IER=3 AT THE
!              Gaussian node points.
!
!
!   *** REFERENCES ***
!   (1) AN AUTOMATIC PROGRAM FOR FREDHOLM INTEGRAL EQUATIONS OF THE
!       SECOND KIND, ACM TRANS. MATH SOFTWARE 2(1976), PP.154-171.
!   (2) A SURVEY OF NUMERICAL METHODS FOR THE SOLUTION OF FREDHOLM
!       INTEGRAL EQUATIONS OF THE SECOND KIND, SIAM PUB., 1976,
!       PART II, CHAP. 5.
!
real :: kernel, norm, normk
external kernel,rhfcn
!
!*******************************************************************
!                                                                  *
common/xxinfo/r1,r2,finlep,normk,nfinal,mfinal
!                                                                  *
!   THE NUMBERS IN XXINFO GIVE ADDITIONAL INFORMATION ABOUT THE    *
!   functioning of IESLV. R1 is the iterative rate of convergence  *
!   in the most recently computed linear system. R2 is the rate of *
!   convergence of the Gaussian quadrature variant of the Nystrom  *
!   METHOD. FINLEP IS THE FINAL VALUE OF EP USED AS THE DESIRED    *
!   error tolerance. Usually FINLEP will equal the input value of  *
!   EP, UNLESS EP WAS MUCH TOO SMALL. NORMK IS AN APPROXIMATE      *
!   VALUE FOR THE NORM OF THE INTEGRAL OPERATOR K, AND IT IS       *
!   CALCULATED ONLY IF NT .GT. 0.                                  *
!   NFINAL AND MFINAL ARE THE FINAL VALUES OF N AND M USED IN      *
!   IESLV.  IF NFINAL=MFINAL, THEN ITERATION WAS NOT INVOKED       *
!   SUCCESSFULLY.                                                  *
!                                                                  *
!*******************************************************************
!                                                                  *
!   NMAX IS THE MAXIMUM VALUE FOR N THAT IS PERMITTED BY IESLV.    *
!   thus MIN0(NUPPER,NMAX) is the maximum value for N that can be  *
!   used. There is also an upper limit of 128 on N imposed by the  *
!   SUBROUTINE LNSYS.                                              *
!                                                                  *
        data nmax /64/
!                                                                  *
!*******************************************************************
!                                                                  *
!     UNITRD IS A MACHINE DEPENDENT PARAMETER. ASSIGN UNITRD THE   *
!     VALUE U WHERE U IS THE SMALLEST FLOATING POINT NUMBER SUCH   *
!     THAT 1.0 + U .GT. 1.0.                                       *
!                                                                  *
        unitrd = spmpar(1)
!                                                                  *
!*******************************************************************
!
cutoff = 0.5
rootrt = 0.1
nup = min0(nupper,nmax)
!
!   Set up the relative base addresses for the various arrays into
!   which W is to be split.
n=nup
m=mupper
nsq=n*n
i1=1
i2=i1+nsq
i3=i2+nsq
i4=i3+nsq/2
i5=i4+nsq/2
i6=i5+m
i7=i6+m
i8=i7+n
i9=i8+n
i10=i9+m
i11=i10+n
i12=i11+m
i13=i12+m
i14=i13+m
i15=i14+n
i16=i15+m
i17=i16+m
i18=i17+n
i19=i18+m
i20=i19+4*n
i21=i20+nsq
nhalf=n/2
call iegs(kernel,rhfcn,a,b,ep,iflag,x,t,nt,nup,mupper,ier, &
&cutoff,rootrt,unitrd,nhalf,w(i1),w(i2),w(i3),w(i4),w(i5), &
&w(i6),w(i7),w(i8),w(i9),w(i10),w(i11),w(i12),w(i13), &
&w(i14),w(i15),w(i16),w(i17),w(i18),w(i19),w(i20),w(i21))
norm=normk
nf=nfinal
mf=mfinal
return
end subroutine ieslv

subroutine iegs(kernel,rhfcn,a,b,ep,iflag,x,t,nt,nup,mup,ier, &
&cutoff,rootrt,unitrd,nhalf,lufact,kmm,kmn,knm,rhs,r,rh, &
&deln,tm,tn,xm,xmz,wm,wn,oldx,save,xn,save2,aside,aside3, &
&imknn)
implicit none
integer :: ier, iflag, mup, nhalf, nt, nup
real :: a, aside(nup,*), aside3(nup,nup), b, cutoff, deln(nup), &
&ep, oldx(mup), r(mup), rh(nup), rhs(mup), rootrt, save(mup), &
&save2(mup), t(*), tm(mup), tn(nup), unitrd, wm(mup), wn(nup), &
&x(*), xm(mup), xmz(mup), xn(nup)
integer :: i, ind, j, loop, m, mnew, n
real :: aside2(5), averr, cond, denr1, denr2, eps, error, esterr, &
&pastc, pastre, r1rat, rate, relerr, relmin, rt, temp, temp2, test, &
&xnorm
integer :: mfinal, nfinal
real :: finlep, r1, r2
real :: elinsy, relrsd
real :: rhfcn
real :: rnrm
real :: conew
real :: rmin
!
!   This routine controls the solution of the integral equation.
!
real :: kernel, lufact(nup,nup), kmm(nup,nup), kmn(nup,nhalf), &
&knm(nhalf,nup), imknn(nup,nup), normk, numr1, numr2
integer :: flag, oldm, pivot(128)
common/xxlin/elinsy,relrsd,pivot
common/xxinfo/r1,r2,finlep,normk,nfinal,mfinal
external kernel,rhfcn
!
!   Initialization
!
loop=1
n=2
r2=0.5
m=2*n
r1rat=rootrt
cond=1.0
pastc=1.0
pastre=0.0
eps=ep
!
!   STAGE A. DIRECT SOLUTION OF LINEAR SYSTEM (I-KN)*XN=RHS, WHILE
!   trying to find a good approximate inverse to implement
!   iterative method of solution.
!
!   CREATE THE NODES AND WEIGHTS TN(I) AND WN(I), I=1,...,N
call wandt(wn,tn,n,a,b)
!   SET UP MATRIX FOR (I-KN)*XN=RHFCN
do 2 j = 1,n
do 1 i = 1,n
1 imknn(i,j)=-wn(j)*kernel(tn(i),tn(j))
xmz(j)=rhfcn(tn(j))
2 imknn(j,j)=imknn(j,j)+1.0
go to 6
!   This is entrance for an increased value of N, using previously
!   STORED VALUES IN KMM TO DEFINE MATRIX FOR (I-KN)*XN=RHFCN WITH
!   new value of N.
3 do 5 j = 1,n
do 4 i = 1,n
4 imknn(i,j)=-kmm(i,j)
wn(j)=wm(j)
tn(j)=tm(j)
xmz(j)=rhs(j)
5 imknn(j,j)=imknn(j,j)+1.0
!   This is the entrance when iteration in stage B fails and we need
!   to increase N to obtain a better iterative rate.
6 continue
!   SOLVE (I-KN)*XN=RHFCN AT ALL TN(I).ALSO OBTAIN THE LU
!   decomposition for later use in the stage B iterative method.
!
!*******************************************************************
!                                                                  *
call lnsys(imknn,lufact,nup,n,xmz,xn,2,ind)
!                                                                  *
!   LNSYS IS A GENERAL LINEAR EQUATION SOLVER. IT HAS SPECIAL      *
!   OPTIONS WHICH ARE USED IN THE FOLLOWING PROGRAM. THUS IT       *
!   SHOULD NOT BE REPLACED WITH ANOTHER SOLVER. LNSYS IS ALSO      *
!   USED IN THE SUBROUTINE ITERT.                                  *
!                                                                  *
!*******************************************************************
!
cond=conew(cond,elinsy,relrsd,averr,pastc,pastre)
relmin=rmin(n,n,cond,unitrd,averr)
if(loop .eq. 1) go to 11
if(loop .eq. 2) go to 9
!   Set up approximate rate of convergence of solutions XN to true
!   solution X. Also set up desired ratio for iterative method.
numr2=rnrm(xn,oldx,n,1)
r2=amin1(0.5,amax1(numr2/denr2,1.0e-4))
r1rat=amin1(rootrt,sqrt(r2))
!   Check for error in XN using test involving R2 and OLDX,according
!   to theory for asymptotic error bounds. Modify error if it is
!   outside precision range of computer, possibly due to
!   ill-conditioning.
8 error=(r2/(1.0-r2))*numr2
xnorm=rnrm(xn,xn,n,0)
relerr=error/xnorm
if(iflag .eq. 0) eps=amax1(ep,xnorm*relmin)
if(iflag .eq. 1) eps=amax1(ep,relmin)
if(iflag .eq. 1)error=amax1(relerr,relmin)
if((iflag .eq. 0) .and. (relerr .lt. relmin)) &
&error=relmin*xnorm
if(error .le. eps) go to 10
denr2=numr2
go to 11
!   ENTRANCE FOR LOOP=2.
9 numr2=rnrm(xn,oldx,n,1)
denr2=0.0
go to 8
!   Exit for successful return. Iteration was not necessary.
10 call leave(0,n,n,xn,tn,wn,error, &
&kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
&xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
!
!   ATTEMPT TO SOLVE (I-KM)*XM=RHFCN ITERATIVELY, CHECKING TO SEE IF
!   the rate of convergence is sufficiently fast so as to enter
!   STAGE B.
!
!   CALCULATE TM(I) AND WM(I), I=1,...,M.
11 call wandt(wm,tm,m,a,b)
flag=0
!   Calculate initial guess XMZ for iteration method.
call nsterp(tm,wm,xmz,m,tn,wn,xn,n, &
&kernel,rhfcn,rhs,kmn,nhalf,nup)
do 12 i = 1,m
12 oldx(i)=xmz(i)
!   Calculate first iterate.
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
&rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond=conew(cond,elinsy,relrsd,averr,pastc,pastre)
denr1=rnrm(xm,xmz,m,1)
flag=1
do 13 i = 1,m
13 xmz(i)=xm(i)
!   Calculate second iterate.
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
&rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond=conew(cond,elinsy,relrsd,averr,pastc,pastre)
numr1=rnrm(xm,xmz,m,1)
!   Check on the speed of convergence of iterative method. If it is
!   sufficiently rapid, then fix N and go to stage B.
r1=amax1(numr1/denr1,.0001)
rate=r1
if(m .gt. nup) go to 19
if(r1 .le. r1rat) go to 15
!   The iteration did not work well enough, and stage A is to be
!   REPEATED. RE-INITIALIZE FOR SOLVING (I-KN)*XN=RHFCN AGAIN
!   with a larger N.
14 n=m
loop=loop+1
m=2*n
go to 3
!   The iterative rate is sufficiently rapid, and control will go to
!   stage B. Save information in case stage B aborts at a larger
!   value of M and stage A has to be returned to.
15 do 16 i = 1,m
aside(i,1)=oldx(i)
aside(i,2)=wm(i)
aside(i,3)=tm(i)
16 aside(i,4)=rhs(i)
aside2(1)=loop
aside2(3)=r2
aside2(4)=denr2
aside2(5)=r1rat
do 17 j = 1,m
do 17 i = 1,m
17 aside3(i,j)=kmm(i,j)
!
!   STAGE B. ITERATIVE METHOD OF SOLUTION OF (I-KM)*XM=RHS.
!
19 oldm=n
aside2(2)=m
if(r1 .le. cutoff) go to 22
!   The iterates are converging very slowly or not at all. Thus
!   RETURN WITHOUT FURTHER ATTEMPTS TO LESSEN THE ERROR.
if(loop .ne. 1) go to 21
20 call leave(2,n,n,xn,tn,wn,0.0, &
&kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
&xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
21 call leave(1,n,n,xn,tn,wn,error, &
&kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
&xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
!   Test to see if the current iterate XM is sufficiently accurate
!   compared to the true XM.
22 rate=r1*rate
temp=rnrm(xm,oldx,m,1)
if(loop .eq. 1) temp2=0.5
if(loop .gt. 1) temp2=temp/denr2
rt=  amin1(0.01,amax1(temp2,0.0001))/2.0
xnorm=rnrm(xm,xm,m,0)
esterr=(rt/(1.0-rt))*temp/xnorm
if(esterr .lt. relmin) esterr=relmin
esterr=esterr*xnorm
test=((1.0-r1)/r1)*esterr
if(numr1 .le. test) go to 33
!   Iterate not sufficiently accurate. Initialize for computation
!   of another iterate.
25 denr1=numr1
do 26 i = 1,m
26 xmz(i)=xm(i)
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
&rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond=conew(cond,elinsy,relrsd,averr,pastc,pastre)
numr1=rnrm(xm,xmz,m,1)
r1=amax1(numr1/denr1,.0001)
if(r1 .le. cutoff) go to 22
!   This is entrance for case where iteration fails in stage B.
!   Parameters must be reset for a return to stage A or for an
!   abortive exit if N cannot be increased any further.
27 mnew=aside2(2)
if(mnew .gt. nup) go to 30
n=mnew
do 29 j = 1,n
do 28 i = 1,n
28 imknn(i,j)=-aside3(i,j)
oldx(j)=aside(j,1)
wn(j)=aside(j,2)
tn(j)=aside(j,3)
xmz(j)=aside(j,4)
29 imknn(j,j)=imknn(j,j)+1.0
m=2*n
loop=aside2(1)+1.0
r2=aside2(3)
denr2=aside2(4)
r1rat=aside2(5)
go to 6
!   Abortive exit from stage B. N cannot be increased further, and
!   R1 is not sufficiently small.
30 if(loop .eq. 1) go to 20
call wandt(wm,tm,oldm,a,b)
call leave(1,n,oldm,save,tm,wm,error, &
&kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
&xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
!   An accurate value of XM has been obtained. R2 is to be tested as
!   to whether it should be reset. Then check error in XM compared
!   with the true solution X.
33 if(loop .eq. 1) go to 37
numr2=temp
r2=amax1(1.0e-4,rate,amin1(numr2/denr2,0.5))
denr2=numr2
34 error=(r2/(1.0-r2))*temp
xnorm=rnrm(xm,xm,m,0)
relerr=error/xnorm
relmin=rmin(n,m,cond,unitrd,averr)
if(iflag .eq. 0) eps=amax1(ep,xnorm*relmin)
if(iflag .eq. 1) eps=amax1(ep,relmin)
if(iflag .eq. 1)error=amax1(relerr,relmin)
if((iflag .eq. 0) .and. (relerr .lt. relmin)) &
&error=relmin*xnorm
if(error .gt. eps) go to 35
call leave(0,n,m,xm,tm,wm,error, &
&kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
&xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
35 mnew=2*m
if(mnew .le. mup) go to 39
!   M cannot be increased any further.
call leave(1,n,m,xm,tm,wm,error, &
&kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
&xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
37 denr2=temp
loop=2
go to 34
!   Error not sufficiently small. M is increased and two more
!   more iterates are computed with the new M.
39 oldm=m
m=mnew
do 41 i = 1,oldm
save2(i)=wm(i)
41 save(i)=tm(i)
call wandt(wm,tm,m,a,b)
flag=0
call nsterp(tm,wm,xmz,m,save,save2,xm,oldm, &
&kernel,rhfcn,rhs,kmn,nhalf,nup)
do 43 i = 1,oldm
43 save(i)=xm(i)
do 45 i = 1,m
45 oldx(i)=xmz(i)
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
&rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond=conew(cond,elinsy,relrsd,averr,pastc,pastre)
denr1=rnrm(xm,xmz,m,1)
flag=1
do 47 i = 1,m
47 xmz(i)=xm(i)
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
&rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond=conew(cond,elinsy,relrsd,averr,pastc,pastre)
numr1=rnrm(xm,xmz,m,1)
r1=amax1(numr1/denr1,.0001)
rate=r1
if(r1 .le. cutoff) go to 22
go to 27
end subroutine iegs

subroutine nsterp(tm,wm,xm,m,tn,wn,xn,n,kernel,rhfcn,rhs,kmn, &
&nhalf,nup)
implicit none
integer, intent(in) :: m, n, nhalf, nup
real, intent(inout) :: rhs(m)
real :: tm(m), tn(n), wm(m), wn(n)
real, intent(inout) :: xm(m)
real :: xn(n)
integer :: i, j
real :: rhfcn
!
!   USE THE VALUES OF XN(I), I=1,...,N, TO CALCULATE THE NYSTROM
!   INTERPOLATES XM(I), I=1,...,M.
!
real :: kernel
real, intent(inout) :: kmn(nup,nhalf)
external kernel,rhfcn
!
if(m .gt. nup) go to 4
!   SINCE M .LE. NUPPER, SAVE K(TM(I),TN(J))=KMN(I,J) AND
!   RHS(I)=RHFCN(TM(I)) FOR LATER USE IN ITERT.
do 1 i = 1,m
do 1 j = 1,n
1 kmn(i,j)=wn(j)*kernel(tm(i),tn(j))
do 2 i = 1,m
rhs(i)=rhfcn(tm(i))
2 xm(i)=rhs(i)
!   Calculate Nystrom interpolating formula.
do 3 i = 1,m
do 3 j = 1,n
3 xm(i)=xm(i)+kmn(i,j)*xn(j)
return
!   M .GT. NUPPER, SO SAVE JUST RHS(I) FOR LATER USE IN ITERT.
!   Calculate Nystrom interpolating formula.
4 do 5 i = 1,m
rhs(i)=rhfcn(tm(i))
xm(i)=rhs(i)
do 5 j = 1,n
5 xm(i)=xm(i)+wn(j)*kernel(tm(i),tn(j))*xn(j)
return
end subroutine nsterp

function rmin(n,m,cond,unitrd,averr)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: averr, cond, unitrd
real :: float1, float2
real :: rmin
!
!   FOR A LINEAR SYSTEM   (I-KMM)*XM=RHFCN   OF ORDER M, THIS IS THE
!   value of RELMIN used in IEGS. The variable UNITRD is defined in
!   IEGAUS, and the variables cond and AVERR are defined in IEGS
!   USING CONEW.
!   It is unlikely that a solution X can be found for the original
!   integral equation with a smaller relative error than RMIN.
!
float1=m
float2=float(m)/float(n)
rmin=amax1((float1**1.5)*cond*unitrd, &
&(float2**1.5)*averr)
return
end function rmin

real function rnrm(x,y,n,iflag)
implicit none
integer, intent(in) :: iflag, n
real :: x(n), y(n)
integer :: i
!
!   IFLAG=0    CALCULATE THE MAXIMUM NORM OF X.
!   IFLAG=1    CALCULATE THE MAXIMUM NORM OF X-Y.
!
if(iflag .eq. 1) go to 2
!   Find the norm of X.
rnrm=0.0
do 1 i = 1,n
1 rnrm=amax1(rnrm,abs(x(i)))
return
!   Find the norm of X-Y.
2 rnrm=0.0
do 3 i = 1,n
3 rnrm=amax1(rnrm,abs(x(i)-y(i)))
return
end function rnrm

function conew(cond,elinsy,relrsd,averr,pastc,pastre)
implicit none
real, intent(out) :: averr
real, intent(in) :: cond, elinsy
real, intent(inout) :: pastc, pastre
real, intent(in) :: relrsd
real :: c
real :: conew
!
!   This is used in updating the value of the condition number
!   IN IEGS.
!
averr=sqrt(elinsy*pastre)
pastre=elinsy
if(relrsd .eq. 0.0) go to 1
c=amax1(1.0,elinsy/relrsd)
conew=sqrt(c*pastc)
pastc=c
return
1 conew=cond
return
end function conew

subroutine wandt(wv,tv,n,a,b)
implicit none
integer, intent(in) :: n
real, intent(in) :: a, b
real, intent(inout) :: tv(n), wv(n)
integer :: i, i1, i2, k, l, loop, m, mt, npi, nplace
real :: al, bl, fl, floop, h, r, s, scale, t(255), w(255)
!
!   Integration weights and nodes are to be calculated and stored in
!   WV and TV, respectively. N is assumed to be a power of two. If
!   2 .LE. N .LE. 256, THEN GAUSSIAN QUADRATURE IS USED. IF N .GT.
!   256, Then the interval (A,B) is divided N/256 times and the 256
!   point formula is applied to each subinterval.
!
data t(1),t(2),t(3),t(4),t(5),t(6),t(7),t(8),t(9),t(10),t(11), &
&t(12),t(13),t(14),t(15)/.577350269189626e0, &
&.861136311594053e0,.339981043584856e0,.960289856497536e0, &
&.796666477413627e0,.525532409916329e0,.183434642495650e0, &
&.989400934991650e0,.944575023073233e0,.865631202387832e0, &
&.755404408355003e0,.617876244402644e0,.458016777657227e0, &
&.281603550779259e0,.950125098376374e-1/
data t(16),t(17),t(18),t(19),t(20),t(21),t(22),t(23),t(24),t(25), &
&t(26),t(27),t(28),t(29),t(30),t(31)/.997263861849482e0, &
&.985611511545268e0,.964762255587506e0,.934906075937740e0, &
&.896321155766052e0,.849367613732570e0,.794483795967942e0, &
&.732182118740290e0,.663044266930215e0,.587715757240762e0, &
&.506899908932229e0,.421351276130635e0,.331868602282128e0, &
&.239287362252137e0,.144471961582796e0,.483076656877383e-1/
data t(32),t(33),t(34),t(35),t(36),t(37),t(38),t(39),t(40),t(41), &
&t(42),t(43),t(44),t(45),t(46),t(47)/.999305041735772e0, &
&.996340116771955e0,.991013371476744e0,.983336253884626e0, &
&.973326827789911e0,.961008799652054e0,.946411374858403e0, &
&.929569172131940e0,.910522137078503e0,.889315445995114e0, &
&.865999398154093e0,.840629296252580e0,.813265315122798e0, &
&.783972358943341e0,.752819907260532e0,.719881850171611e0/
data t(48),t(49),t(50),t(51),t(52),t(53),t(54),t(55),t(56),t(57), &
&t(58),t(59),t(60),t(61),t(62),t(63)/.685236313054233e0, &
&.648965471254657e0,.611155355172393e0,.571895646202634e0, &
&.531279464019895e0,.489403145707053e0,.446366017253464e0, &
&.402270157963992e0,.357220158337668e0,.311322871990211e0, &
&.264687162208767e0,.217423643740007e0,.169644420423993e0, &
&.121462819296121e0,.729931217877990e-1,.243502926634244e-1/
data t(64),t(65),t(66),t(67),t(68),t(69),t(70),t(71),t(72),t(73), &
&t(74),t(75),t(76),t(77),t(78),t(79)/.999824887947132e0, &
&.999077459977376e0,.997733248625514e0,.995792758534981e0, &
&.993257112900213e0,.990127818491734e0,.986406742724586e0, &
&.982096108435719e0,.977198491463907e0,.971716818747137e0, &
&.965654366431965e0,.959014757853700e0,.951801961341264e0, &
&.944020287830220e0,.935674388277916e0,.926769250878948e0/
data t(80),t(81),t(82),t(83),t(84),t(85),t(86),t(87),t(88),t(89), &
&t(90),t(91),t(92),t(93),t(94),t(95),t(96),t(97)/ &
&.917310198080961e0,.907302883401757e0,.896753288049158e0, &
&.885667717345397e0,.874052796958032e0,.861915468939548e0, &
&.849262987577969e0,.836102915060907e0,.822443116955644e0, &
&.808291757507914e0,.793657294762193e0,.778548475506412e0, &
&.762974330044095e0,.746944166797062e0,.730467566741909e0, &
&.713554377683587e0,.696214708369514e0,.678458922447719e0/
data t(98),t(99),t(100),t(101),t(102),t(103),t(104),t(105),t(106), &
&t(107),t(108),t(109),t(110),t(111),t(112),t(113),t(114)/ &
&.660297632272646e0,.641741692562308e0,.622802193910585e0, &
&.603490456158549e0,.583818021628763e0,.563796648226618e0, &
&.543438302412810e0,.522755152051175e0,.501759559136144e0, &
&.480464072404172e0,.458881419833552e0,.437024501037104e0, &
&.414906379552275e0,.392540275033267e0,.369939555349859e0, &
&.347117728597636e0,.324088435024413e0/
data t(115),t(116),t(117),t(118),t(119),t(120),t(121),t(122), &
&t(123),t(124),t(125),t(126),t(127)/.300865438877677e0, &
&.277462620177904e0,.253893966422694e0,.230173564226660e0, &
&.206315590902079e0,.182334305985337e0,.158244042714225e0, &
&.134059199461188e0,.109794231127644e0, &
&.854636405045155e-1,.610819696041396e-1,.366637909687335e-1, &
&.122236989606158e-1/
data t(128),t(129),t(130),t(131),t(132),t(133),t(134),t(135), &
&t(136),t(137),t(138),t(139),t(140),t(141),t(142)/ &
&.999956050018992e0,.999768437409263e0,.999430937466261e0, &
&.998943525843409e0,.998306266473006e0,.997519252756721e0, &
&.996582602023382e0,.995496454481096e0,.994260972922410e0, &
&.992876342608822e0,.991342771207583e0,.989660488745065e0, &
&.987829747564861e0,.985850822286126e0,.983724009760315e0/
data t(143),t(144),t(145),t(146),t(147),t(148),t(149),t(150), &
&t(151),t(152),t(153),t(154),t(155),t(156),t(157)/ &
&.981449629025464e0,.979028021257622e0,.976459549719234e0, &
&.973744599704370e0,.970883578480743e0,.967876915228489e0, &
&.964725060975706e0,.961428488530732e0,.957987692411178e0, &
&.954403188769716e0,.950675515316628e0,.946805231239127e0, &
&.942792917117462e0,.938639174837814e0, .934344627502003e0/
data t(158),t(159),t(160),t(161),t(162),t(163),t(164),t(165), &
&t(166),t(167),t(168),t(169),t(170),t(171),t(172)/ &
&.929909919334006e0,.925335715583316e0,.920622702425146e0, &
&.915771586857490e0,.910783096595065e0,.905657979960145e0, &
&.900397005770304e0,.895000963223085e0,.889470661777611e0, &
&.883806931033158e0,.878010620604707e0,.872082599995488e0, &
&.866023758466555e0,.859835004903376e0,.853517267679503e0/
data t(173),t(174),t(175),t(176),t(177),t(178),t(179),t(180), &
&t(181),t(182),t(183),t(184),t(185),t(186),t(187)/ &
&.847071494517296e0,.840498652345763e0,.833799727155505e0, &
&.826975723850813e0,.820027666098917e0,.812956596176432e0, &
&.805763574812999e0,.798449681032171e0,.791016011989546e0, &
&.783463682808184e0,.775793826411326e0,.768007593352446e0, &
&.760106151642655e0,.752090686575492e0,.743962400549112e0/
data t(188),t(189),t(190),t(191),t(192),t(193),t(194),t(195), &
&t(196),t(197),t(198),t(199),t(200),t(201),t(202)/ &
&.735722512885918e0,.727372259649652e0,.718912893459971e0, &
&.710345683304543e0,.701671914348685e0,.692892887742577e0, &
&.684009920426076e0,.675024344931163e0,.665937509182049e0, &
&.656750776292973e0,.647465524363725e0,.638083146272911e0, &
&.628605049469015e0,.619032655759261e0,.609367401096334e0/
data t(203),t(204),t(205),t(206),t(207),t(208),t(209),t(210), &
&t(211),t(212),t(213),t(214),t(215),t(216),t(217)/ &
&.599610735362968e0,.589764122154454e0,.579829038559083e0, &
&.569806974936569e0,.559699434694481e0,.549507934062719e0, &
&.539234001866059e0,.528879179294822e0,.518445019673674e0, &
&.507933088228616e0,.497344961852181e0,.486682228866890e0, &
&.475946488786983e0,.465139352078479e0,.454262439917590e0/
data t(218),t(219),t(220),t(221),t(222),t(223),t(224),t(225), &
&t(226),t(227),t(228),t(229),t(230),t(231),t(232)/ &
&.443317383947527e0,.432305826033741e0,.421229418017624e0, &
&.410089821468717e0,.398888707435459e0,.387627756194516e0, &
&.376308656998716e0,.364933107823654e0,.353502815112970e0, &
&.342019493522372e0,.330484865662417e0,.318900661840106e0, &
&.307268619799319e0,.295590484460136e0,.283868007657082e0/
data t(233),t(234),t(235),t(236),t(237),t(238),t(239),t(240), &
&t(241),t(242),t(243),t(244),t(245),t(246),t(247)/ &
&.272102947876337e0,.260297069991943e0,.248452145001057e0, &
&.236569949758284e0,.224652266709132e0,.212700883622626e0, &
&.200717593323127e0,.188704193421389e0,.176662486044902e0, &
&.164594277567554e0,.152501378338656e0,.140385602411376e0, &
&.128248767270607e0,.116092693560333e0,.103919204810509e0/
data   t(248),t(249),t(250),t(251),t(252),t(253),t(254),t(255)/ &
&.917301271635196e-1,.795272891002330e-1,.673125211657164e-1, &
&.550876556946340e-1,.428545265363791e-1,.306149687799790e-1, &
&.183708184788137e-1,.612391237518953e-2/
data w(1),w(2),w(3),w(4),w(5),w(6),w(7),w(8),w(9),w(10),w(11), &
&w(12),w(13),w(14),w(15)/1.0e0,.347854845137454e0, &
&.652145154862546e0,.101228536290376e0,.222381034453374e0, &
&.313706645877887e0,.362683783378362e0,.271524594117541e-1, &
&.622535239386479e-1,.951585116824928e-1,.124628971255534e0, &
&.149595988816577e0,.169156519395003e0,.182603415044924e0, &
&.189450610455068e0/
data w(16),w(17),w(18),w(19),w(20),w(21),w(22),w(23),w(24),w(25), &
&w(26),w(27),w(28),w(29),w(30),w(31)/.701861000947010e-2, &
&.162743947309057e-1,.253920653092621e-1,.342738629130214e-1, &
&.428358980222267e-1,.509980592623762e-1,.586840934785355e-1, &
&.658222227763618e-1,.723457941088485e-1,.781938957870703e-1, &
&.833119242269468e-1,.876520930044038e-1,.911738786957639e-1, &
&.938443990808046e-1,.956387200792749e-1,.965400885147278e-1/
data w(32),w(33),w(34),w(35),w(36),w(37),w(38),w(39),w(40),w(41), &
&w(42),w(43),w(44),w(45),w(46),w(47)/.178328072169643e-2, &
&.414703326056247e-2,.650445796897836e-2,.884675982636395e-2, &
&.111681394601311e-1,.134630478967186e-1,.157260304760247e-1, &
&.179517157756973e-1,.201348231535302e-1,.222701738083833e-1, &
&.243527025687109e-1,.263774697150547e-1,.283396726142595e-1, &
&.302346570724025e-1,.320579283548516e-1,.338051618371416e-1/
data w(48),w(49),w(50),w(51),w(52),w(53),w(54),w(55),w(56),w(57), &
&w(58),w(59),w(60),w(61),w(62),w(63)/ .354722132568824e-1, &
&.370551285402400e-1,.385501531786156e-1,.399537411327203e-1, &
&.412625632426235e-1,.424735151236536e-1,.435837245293235e-1, &
&.445905581637566e-1,.454916279274181e-1, .462847965813144e-1, &
&.469681828162100e-1,.475401657148303e-1,.479993885964583e-1, &
&.483447622348030e-1,.485754674415034e-1,.486909570091397e-1/
data w(64),w(65),w(66),w(67),w(68),w(69),w(70),w(71),w(72),w(73), &
&w(74),w(75),w(76),w(77),w(78),w(79)/ .449380960292090e-3, &
&.104581267934035e-2,.164250301866903e-2,.223828843096262e-2, &
&.283275147145799e-2,.342552604091022e-2,.401625498373864e-2, &
&.460458425670296e-2,.519016183267633e-2,.577263754286570e-2, &
&.635166316170719e-2,.692689256689881e-2,.749798192563473e-2, &
&.806458989048606e-2,.862637779861675e-2,.918300987166087e-2/
data w(80),w(81),w(82),w(83),w(84),w(85),w(86),w(87),w(88), &
&w(89),w(90),w(91),w(92),w(93),w(94),w(95)/.973415341500681e-2, &
&.102794790158322e-1,.108186607395031e-1,.113513763240804e-1, &
&.118773073727403e-1,.123961395439509e-1,.129075627392673e-1, &
&.134112712886163e-1,.139069641329520e-1,.143943450041668e-1, &
&.148731226021473e-1,.153430107688651e-1,.158037286593993e-1, &
&.162550009097852e-1,.166965578015892e-1,.171281354231114e-1/
data w(96),w(97),w(98),w(99),w(100),w(101),w(102),w(103),w(104), &
&w(105),w(106),w(107),w(108),w(109),w(110),w(111),w(112)/ &
&.175494758271177e-1,.179603271850087e-1,.183604439373313e-1, &
&.187495869405447e-1,.191275236099509e-1,.194940280587066e-1, &
&.198488812328309e-1,.201918710421300e-1,.205227924869601e-1, &
&.208414477807511e-1,.211476464682213e-1,.214412055392085e-1, &
&.217219495380521e-1,.219897106684605e-1,.222443288937998e-1, &
&.224856520327450e-1,.227135358502365e-1/
data w(113),w(114),w(115),w(116),w(117),w(118),w(119),w(120), &
&w(121),w(122),w(123),w(124),w(125),w(126),w(127)/ &
&.229278441436868e-1,.231284488243870e-1,.233152299940628e-1, &
&.234880760165359e-1,.236468835844476e-1,.237915577810034e-1, &
&.239220121367035e-1,.240381686810241e-1,.241399579890193e-1, &
&.242273192228152e-1,.243002001679719e-1,.243585572646906e-1, &
&.244023556338496e-1,.244315690978500e-1,.244461801962625e-1/
data w(128),w(129),w(130),w(131),w(132),w(133),w(134),w(135), &
&w(136),w(137),w(138),w(139),w(140),w(141),w(142)/ &
&.112789017822272e-3,.262534944296446e-3,.412463254426176e-3, &
&.562348954031410e-3,.712154163473321e-3,.861853701420089e-3, &
&.101142439320844e-2,.116084355756772e-2,.131008868190250e-2, &
&.145913733331073e-2,.160796713074933e-2,.175655573633073e-2, &
&.190488085349972e-2,.205292022796614e-2,.220065164983991e-2/
data w(143),w(144),w(145),w(146),w(147),w(148),w(149),w(150), &
&w(151),w(152),w(153),w(154),w(155),w(156),w(157)/ &
&.234805295632731e-2,.249510203470371e-2,.264177682542749e-2, &
&.278805532532771e-2,.293391559082972e-2,.307933574119934e-2, &
&.322429396179420e-2,.336876850731555e-2,.351273770505631e-2, &
&.365617995814250e-2,.379907374876626e-2,.394139764140883e-2, &
&.408313028605267e-2,.422425042138154e-2,.436473687796806e-2/
data w(158),w(159),w(160),w(161),w(162),w(163),w(164),w(165), &
&w(166),w(167),w(168),w(169),w(170),w(171),w(172)/ &
&.450456858144790e-2,.464372455568006e-2,.478218392589269e-2, &
&.491992592181387e-2,.505692988078684e-2,.519317525086928e-2, &
&.532864159391593e-2,.546330858864431e-2,.559715603368291e-2, &
&.573016385060144e-2,.586231208692265e-2,.599358091911534e-2, &
&.612395065556793e-2,.625340173954240e-2,.638191475210788e-2/
data w(173),w(174),w(175),w(176),w(177),w(178),w(179),w(180), &
&w(181),w(182),w(183),w(184),w(185),w(186),w(187)/ &
&.650947041505366e-2,.663604959378107e-2,.676163330017380e-2, &
&.688620269544632e-2,.700973909296982e-2,.713222396107539e-2, &
&.725363892583391e-2,.737396577381235e-2,.749318645480588e-2, &
&.761128308454566e-2,.772823794738156e-2,.784403349893971e-2, &
&.795865236875435e-2,.807207736287350e-2,.818429146643827e-2/
data w(188),w(189),w(190),w(191),w(192),w(193),w(194),w(195), &
&w(196),w(197),w(198),w(199),w(200),w(201),w(202)/ &
&.829527784623523e-2,.840501985322154e-2,.851350102502249e-2, &
&.862070508840101e-2,.872661596169881e-2,.883121775724875e-2, &
&.893449478375821e-2,.903643154866287e-2,.913701276045081e-2, &
&.923622333095630e-2,.933404837762327e-2,.943047322573775e-2, &
&.952548341062928e-2,.961906467984073e-2,.971120299526628e-2/
data w(203),w(204),w(205),w(206),w(207),w(208),w(209),w(210), &
&w(211),w(212),w(213),w(214),w(215),w(216),w(217)/ &
&.980188453525733e-2,.989109569669583e-2,.997882309703491e-2, &
&.100650535763064e-1,.101497741990949e-1,.102329722564782e-1, &
&.103146352679340e-1,.103947509832117e-1,.104733073841704e-1, &
&.105502926865815e-1,.106256953418966e-1,.106995040389798e-1, &
&.107717077058046e-1,.108422955111148e-1,.109112568660490e-1/
data w(218),w(219),w(220),w(221),w(222),w(223),w(224),w(225), &
&w(226),w(227),w(228),w(229),w(230),w(231),w(232)/ &
&.109785814257296e-1,.110442590908139e-1,.111082800090098e-1, &
&.111706345765534e-1,.112313134396497e-1,.112903074958755e-1, &
&.113476078955455e-1,.114032060430392e-1,.114570935980906e-1, &
&.115092624770395e-1,.115597048540436e-1,.116084131622531e-1, &
&.116553800949452e-1,.117005986066207e-1,.117440619140606e-1/
data w(233),w(234),w(235),w(236),w(237),w(238),w(239),w(240), &
&w(241),w(242),w(243),w(244),w(245),w(246),w(247)/ &
&.117857634973434e-1,.118256971008240e-1,.118638567340711e-1, &
&.119002366727665e-1,.119348314595636e-1,.119676359049059e-1, &
&.119986450878058e-1,.120278543565826e-1,.120552593295601e-1, &
&.120808558957245e-1,.121046402153405e-1,.121266087205273e-1, &
&.121467581157945e-1,.121650853785355e-1,.121815877594818e-1/
data w(248),w(249),w(250),w(251),w(252),w(253),w(254),w(255)/ &
&.121962627831147e-1,.122091082480372e-1,.122201222273040e-1, &
&.122293030687103e-1,.122366493950402e-1,.122421601042728e-1, &
&.122458343697479e-1,.122476716402898e-1/
loop=max0(1,n/256)
floop=loop
h=(b-a)/floop
scale=h/2.0
m=min0(128,n/2)
mt=2*m
nplace=m-1
do 1 l = 1,loop
fl=l
al=a+(fl-1.0)*h
bl=a+fl*h
k=256*(l-1)
do 1 i = 1,m
npi=nplace+i
s=t(npi)
r=w(npi)*scale
i1=k+i
i2=k+mt+1-i
tv(i1)=  (al*(1.0+s)+(1.0-s)*bl)/2.0
tv(i2)=  (al*(1.0-s)+(1.0+s)*bl)/2.0
wv(i1)=r
1 wv(i2)=r
return
end subroutine wandt

subroutine leave(ierset,nf,mf,xv,tv,wv,error,kernel,rhfcn,ep, &
&iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm,xmz,kmm,kmn,knm, &
&rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
implicit none
integer :: ier, ierset, iflag, mf, nf, nhalf, nt, nup
real :: deln(nf), elinsy, ep, eps, error, r(mf), rh(nf), rhs(mf), &
&t(*), tm(mf), tn(nf), tv(mf), wm(mf), wn(nf), wv(mf), x(*), &
&xm(mf), xmz(mf), xnorm, xv(mf)
integer :: i, itloop, j
real :: derror, savep, sum, temp
integer :: mfinal, nfinal
real :: finlep, r1, r2
real :: rhfcn
real :: rnrm
!
!   This routine sets all necessary parameters for leaving IEGAUS.
!   IF NT .GT. 0, IT ALSO PERFORMS THE NECESSARY NYSTROM
!   interpolation at the nodes given in T.
!
real :: kernel, kmm(nup,nup), kmn(nup,nhalf), knm(nhalf,nup), &
&imknn(nup,nup), lufact(nup,nup), normk, numr1
common/xxinfo/r1,r2,finlep,normk,nfinal,mfinal
external kernel,rhfcn
!
!   Set error parameters for return.
!
normk=0.0
nfinal=nf
mfinal=mf
finlep=eps
if((eps .gt. ep) .and. (error .le. eps)) go to 10
ier=ierset
ep=error
if(nt .eq. 0) go to 20
go to 30
10 ier=3
!
!   SINCE EPS IS THE SMALLEST ERROR POSSIBLE, SET EP=EPS FOR THE
!   RETURN ERROR ESTIMATE.
!
ep=eps
if(nt .gt. 0) go to 30
!
!   No Nystrom interpolation is desired. Return the values at the
!   Gaussian node points.
!
20 do 21 i = 1,mf
x(i)=xv(i)
21 t(i)=tv(i)
nt=mf
return
!   Calculate NORM(K).
30 savep=ep
do 31 i = 1,nf
31 imknn(i,i)=imknn(i,i)-1.0
normk=0.0
do 33 i = 1,nf
sum=0.0
do 32 j = 1,nf
32 sum=sum+abs(imknn(i,j))
33 normk=amax1(normk,sum)
do 34 i = 1,nf
34 imknn(i,i)=imknn(i,i)+1.0
if(nf .eq. mf) go to 50
!
!   Iterate to decrease the noise level in X. This should reduce
!   possible errors in Nystrom interpolation.
!
derror=((1.0-r1)/r1)*eps/normk
if(iflag .eq. 1) derror=derror*xnorm
itloop=0
do 41 i = 1,mf
41 xm(i)=xv(i)
42 do 43 i = 1,mf
43 xmz(i)=xm(i)
call itert(kernel,rhfcn,nf,tn,wn,mf,tm,wm,xm,xmz,kmm,kmn,knm, &
&rhs,imknn,lufact,r,rh,deln,nup,nhalf,1)
numr1=rnrm(xm,xmz,mf,1)
itloop=itloop+1
if((numr1 .gt. derror) .and. (itloop .lt. 5)) go to 42
do 44 i = 1,mf
44 xv(i)=xm(i)
!
!   Estimate new error bound for Nystrom interpolates.
!
temp=normk*(r1/(1.0-r1))*numr1
if(iflag .eq. 1) temp=temp/xnorm
ep=amax1(ep,temp)
go to 60
!
!   No iteration used in computing X. Just compute error estimate
!   in Nystrom interpolate.
!
50 temp=normk*elinsy
if(iflag .eq. 0) temp=temp*xnorm
if(ier .ne. 2) ep=amax1(ep,temp)
!
!   Compute Nystrom interpolates at the nodes in T.
!
60 do 62 i = 1,nt
sum=0.0
do 61 j = 1,mf
61 sum=sum+wv(j)*kernel(t(i),tv(j))*xv(j)
62 x(i)=rhfcn(t(i))+sum
if((ier .eq. 0) .and. (ep .gt. eps)) ier=4
if((ier .eq. 1) .and. (ep .gt. error)) ier=5
if((ier .eq. 3) .and. (ep .gt. eps)) ier=6
ep=savep
return
end subroutine leave

subroutine itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn, &
&knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,iflg)
implicit none
integer, intent(in) :: iflg, m
integer :: n
integer, intent(in) :: nhalf
integer :: nup
real, intent(inout) :: deln(n), r(m), rh(n)
real :: rhfcn, rhs(m), tm(m), tn(n), wm(m), wn(n)
real, intent(inout) :: xm(m)
real :: xmz(m)
integer :: i, ind, j
real :: sum
!
!   This routine calculates one iterate XM given the initial guess
!   XMZ. The routine is divided according to whether or not
!   M .GT. NUPPER.
!
real :: kernel
real, intent(inout) :: kmm(nup,nup)
real :: kmn(nup,nhalf)
real, intent(inout) :: knm(nhalf,nup)
real :: imknn(nup,nup)
real, intent(inout) :: lufact(nup,nup)
external kernel,rhfcn
!
!   M .GT. NUPPER MEANS THAT THE MATRICES KMM,KMN,KNM CAN NO LONGER
!   be stored due to lack of space.
if (m .gt. nup) go to 13
if(iflg .eq. 1) go to 3
!   IF IFLG=0, THEN THE MATRICES KMM AND KNM MUST BE COMPUTED
!   and stored.
do 2 j = 1,m
do 1 i = 1,m
1 kmm(i,j)=wm(j)*kernel(tm(i),tm(j))
do 2 i = 1,n
2 knm(i,j)=wm(j)*kernel(tn(i),tm(j))
!   COMPUTE  RESIDUALS R(I)=RHFCN(TM(I))-XMZ(I)+KM(TM(I))*XMZ(I)
3 do 5 i = 1,m
sum=0.0
do 4 j = 1,m
4 sum=sum+kmm(i,j)*xmz(j)
5 r(i)=rhs(i)-(xmz(i)-sum)
!
!   COMPUTE RH=KM*R AT ALL TN(I).
do 7 i = 1,n
rh(i)=0.0
do 7 j = 1,m
7 rh(i)=rh(i)+knm(i,j)*r(j)
!   CALCULATE DELN=((I-KN)**(-1))*KM*R AT ALL TN(I).
!
!*******************************************************************
!                                                                  *
call lnsys(imknn,lufact,nup,n,rh,deln,4,ind)
!                                                                  *
!   SEE THE ORIGINAL REFERENCE IN IEGS.                            *
!*******************************************************************
!
!   Calculate new XM.
do 12 i = 1,m
sum=0.0
do 10 j = 1,m
10 sum=sum+kmm(i,j)*r(j)
do 11 j = 1,n
11 sum=sum+kmn(i,j)*deln(j)
12 xm(i)=sum+r(i)+xmz(i)
return
!   ENTRANCE WHEN M .GT. NUP.
!   Calculate residuals.
13 do 15 i = 1,m
sum=0.0
do 14 j = 1,m
14 sum=sum+wm(j)*kernel(tm(i),tm(j))*xmz(j)
15 r(i)=rhs(i)-(xmz(i)-sum)
!   CALCULATE RH=KM*R.
do 17 i = 1,n
rh(i)=0.0
do 17 j = 1,m
17 rh(i)=rh(i)+wm(j)*kernel(tn(i),tm(j))*r(j)
!
!*******************************************************************
!                                                                  *
call lnsys(imknn,lufact,nup,n,rh,deln,4,ind)
!                                                                  *
!   SEE THE ORIGINAL REFERENCE IN IEGS.                            *
!*******************************************************************
!
!   CALCULATE XM.
do 22 i = 1,m
sum=0.0
do 20 j = 1,m
20 sum=sum+wm(j)*kernel(tm(i),tm(j))*r(j)
do 21 j = 1,n
21 sum=sum+wn(j)*kernel(tm(i),tn(j))*deln(j)
22 xm(i)=sum+r(i)+xmz(i)
return
end subroutine itert

subroutine lnsys(a,d,m,n,b,x,option,ierr)
implicit none
integer :: ierr, m, n
integer :: i, ip1, iswit, j, k, kp1, l, nm1, nmi
real :: c, sum, t
real :: error, relrsd
!
!   SOLVE AX = B WHERE A IS A MATRIX OF ORDER N. M IS THE NUMBER OF
!   rows in the dimension statement for A in the calling program.
!
!   OPTION=1   COMPUTE AN LU DECOMPOSITION OF A AND STORE IT IN D.
!              STORE THE PIVOT INDICES IN PIVOT AND SOLVE AX = B.
!   OPTION=2   COMPUTE AN LU DECOMPOSITION OF A AND STORE IT IN D.
!              STORE THE PIVOT INDICES IN PIVOT AND SOLVE AX = B.
!              Then compute the residual and one correction. The
!              correction is stored in R, the new value X1 in X,
!              the relative error
!                         NORM(X0-X1)/NORM(X1)
!              in the variable ERROR, and the relative residual
!                         NORM(RESIDUAL)/NORM(B)
!              in the variable RELRSD. These values can be obtained
!              using the common/XXLIN/ given below.
!   OPTION=3   SAME AS OPTION=1, EXCEPT THAT THE LU DECOMPOSITION
!              has already been stored in D and the pivot indices
!              in pivot.
!   OPTION=4   SAME AS OPTION=2, EXCEPT THAT THE LU DECOMPOSITION
!              has already been stored in D and the pivot indices
!              in pivot.
!
!   The LU decomposition is obtained using scaled partial pivoting.
!   For options 1 and 2, IERR is a variable that reports the status
!   OF THE RESULTS. IERR = 0 IF THE LU DECOMPOSITION IS OBTAINED.
!   OTHERWISE, IERR = -K WHEN THE K-TH ROW OF A CONTAINS ONLY ZEROS
!   OR IERR = K WHEN THE K-TH PIVOT ELEMENT IS 0.
!
!   IT IS ASSUMED THAT N .LE. 128. THIS ASSUMPTION MAY BE MODIFIED
!   by changing the dimension statements for the arrays pivot, R,
!   and scale. Also modify the dimension statement for pivot in the
!   SUBROUTINE IEGS.
!
real :: a(m,n), d(m,n), b(n), x(n)
integer :: option, pivot(128)
real :: normx, norme, normb, normr, r(128), scale(128)
common /xxlin/ error,relrsd,pivot
!
nm1 = n - 1
iswit = 1
if (option .gt. 2) go to 100
!
do 11 i = 1,n
scale(i) = 0.0
  do 10 j = 1,n
  d(i,j) = a(i,j)
10 scale(i) = scale(i) + abs(d(i,j))
if (scale(i) .ne. 0.0) go to 11
ierr = -i
return
11 continue
!
!             Obtain the LU decomposition of A
!
ierr = 0
do k = 1,nm1
c = abs(d(k,k))/scale(k)
l = k
kp1 = k + 1
  do 20 i = kp1,n
  t = abs(d(i,k))/scale(i)
  if (t .le. c) go to 20
  c = t
  l = i
20 continue
!
if (c .ne. 0.0) go to 30
ierr = k
return
!
!     Interchange rows K and L
!
30 pivot(k) = l
if (k .eq. l) go to 40
  do 31 j = k,n
  t = d(k,j)
  d(k,j) = d(l,j)
31 d(l,j) = t
t = scale(k)
scale(k) = scale(l)
scale(l) = t
!
!     Eliminate the K-TH unknown below the diagonal
!
40 do i = kp1,n
  d(i,k) = d(i,k)/d(k,k)
  t = d(i,k)
    do 41 j = kp1,n
41 d(i,j) = d(i,j) - t*d(k,j)
  end do
end do
!
if (d(n,n) .ne. 0.0) go to 100
ierr = n
return
!
!               STORE B IN R AND SET X = 0
!
100 do 110 i = 1,n
r(i) = b(i)
110 x(i) = 0.0
go to 200
!
!             COMPUTE THE RESIDUAL R = B - AX
!
120 do 131 i = 1,n
sum = 0.0
  do 130 j = 1,n
130 sum = sum + a(i,j)*x(j)
131 r(i) = b(i) - sum
!
normb = 0.0
normr = 0.0
do 140 i = 1,n
normb = amax1(normb,abs(b(i)))
140 normr = amax1(normr,abs(r(i)))
relrsd = 0.0
if (normb .ne. 0.0) relrsd = normr/normb
iswit = 2
!
!             SOLVE LZ = R AND STORE Z IN R
!
200 do k = 1,nm1
l = pivot(k)
if (k .eq. l) go to 210
t = r(k)
r(k) = r(l)
r(l) = t
210 kp1 = k + 1
  do 211 i = kp1,n
211 r(i) = r(i) - d(i,k)*r(k)
end do
!
!      SOLVE UE = R, STORE E IN R, AND SET X = X + E
!
r(n) = r(n)/d(n,n)
x(n) = x(n) + r(n)
do 221 nmi = 1,nm1
i = n - nmi
ip1 = i + 1
sum = 0.0
  do 220 j = ip1,n
220 sum = sum + d(i,j)*r(j)
r(i) = (r(i) - sum)/d(i,i)
221 x(i) = x(i) + r(i)
!
go to (300,230,300,230),option
230 if (iswit .eq. 1) go to 120
!
!             Calculate the correction error
!
normx = 0.0
norme = 0.0
do 250 i = 1,n
normx = amax1(normx,abs(x(i)))
250 norme = amax1(norme,abs(r(i)))
error = 0.0
if (normx .ne. 0.0) error = norme/normx
300 return
end subroutine lnsys

subroutine ode(f,neqn,y,t,tout,relerr,abserr,iflag,work,iwork)
implicit none
integer, intent(inout) :: iflag, iwork(5)
integer, intent(in) :: neqn
real, intent(inout) :: abserr, relerr, t
real, intent(in) :: tout
real, intent(inout) :: work(*), y(neqn)
integer :: ialpha, ibeta, idelsn, ig, ih, ihold, ip, iphase, iphi, &
&ipsi, isig, istart, itold, iv, iw, iwt, ix, iyp, iypout, iyy
!
!     Sandia mathematical program library
!     applied mathematics division 2642
!     sandia laboratories
!     albuquerque, new mexico  87115
!     january 1976
!   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
!   *                 ISSUED BY SANDIA LABORATORIES,
!   *                   A PRIME CONTRACTOR TO THE
!   *   UNITED STATES ENERGY RESEARCH AND DEVELOPMENT ADMINISTRATION
!   * * * * * * * * * * * * * *  NOTICE   * * * * * * * * * * * * * * *
!   * this report was prepared as an account of work sponsored by the
!   * united states government.  Neither the united states nor the
!   * united states energy research and development administration,
!   * nor any of their employees, nor any of their contractors,
!   * subcontractors, or their employees, makes any warranty, express
!   * or implied, or assumes any legal liability or responsibility
!   * for the accuracy, completeness or usefulness of any information,
!   * apparatus, product or process disclosed, or represents that its
!   * use would not infringe privately owned rights.
!   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
!
!   WRITTEN BY L. F. SHAMPINE AND M. K. GORDON
!
!   Abstract
!
!   Subroutine  ODE  integrates a system of  NEQN  first order
!   ordinary differential equations of the form
!             DY(I)/DT = F(T,Y(1),Y(2),...,Y(NEQN))
!             Y(I) given at  T .
!   The subroutine integrates from  T  to  tout .  On return the
!   parameters in the call list are set for continuing the integration.
!   The user has only to define a new value  tout  and call  ODE  again.
!
!   The differential equations are actually solved by a suite of codes
!   DE1,  STEP1, and  INTRP .  ODE  allocates virtual storage in the
!   arrays  work  and  IWORK  and calls  DE1.  DE1 is a supervisor which
!   directs the solution.  It calls on the routines  STEP1 and  INTRP
!   to advance the integration and to interpolate at output points.
!   STEP1 uses a modified divided difference form of the Adams PECE
!   formulas and local extrapolation.  It adjusts the order and step
!   size to control the local error per unit step in a generalized
!   sense.  Normally each call to  STEP1 advances the solution one step
!   in the direction of  tout .  For reasons of efficiency  DE1
!   integrates beyond  tout  internally, though never beyond
!   T+10*(TOUT-T), and calls  INTRP  to interpolate the solution at
!   tout .  An option is provided to stop the integration at  tout  but
!   it should be used only if it is impossible to continue the
!   integration beyond  tout .
!
!   This code is completely explained and documented in the text,
!   computer solution of ordinary differential equations,  the initial
!   value problem  by L. F. Shampine and M. K. Gordon.
!
!   The parameters represent...
!      F -- SUBROUTINE F(T,Y,YP) TO EVALUATE DERIVATIVES YP(I)=DY(I)/DT
!      NEQN -- number of equations to be integrated
!      Y(*) -- solution vector at  T
!      T -- independent variable
!      tout -- point at which solution is desired
!      RELERR,ABSERR -- relative and absolute error tolerances for local
!           error test.  At each step the code requires
!             ABS(LOCAL ERROR) .LE. ABS(Y)*RELERR + ABSERR
!           for each component of the local error and solution vectors
!      IFLAG -- indicates status of integration
!      WORK(*),IWORK(*) -- arrays to hold information internal to code
!           which is necessary for subsequent calls
!
!   First call to ODE --
!
!   The user must provide storage in his calling program for the arrays
!   in the call list,
!      Y(NEQN), WORK(100+21*NEQN), IWORK(5),
!   declare  F  in an external statement, supply the subroutine
!   F(T,Y,YP) to evaluate
!      DY(I)/DT = YP(I) = F(T,Y(1),Y(2),...,Y(NEQN))
!   and initialize the parameters...
!      NEQN -- number of equations to be integrated
!      Y(*) -- vector of initial conditions
!      T -- starting point of integration
!      tout -- point at which solution is desired
!      RELERR,ABSERR -- relative and absolute local error tolerances
!      IFLAG -- +1,-1.  Indicator to initialize the code.  Normal input
!           IS +1.  THE USER SHOULD SET IFLAG=-1 ONLY IF IT IS
!           impossible to continue the integration beyond  tout .
!   All parameters except  F ,  NEQN  and  tout  may be altered by the
!   code on output so must be variables in the calling program.
!
!   Output from  ODE  --
!
!      NEQN -- UNCHANGED
!      Y(*) -- solution at  T
!      T -- last point reached in integration.  Normal return has
!           T = TOUT .
!      Tout -- unchanged
!      RELERR,ABSERR -- NORMAL RETURN HAS TOLERANCES UNCHANGED.  IFLAG=3
!           signals tolerances increased
!      IFLAG = 2 -- NORMAL RETURN.  INTEGRATION REACHED  TOUT
!            = 3 -- INTEGRATION DID NOT REACH  TOUT  BECAUSE ERROR
!                   tolerances too small.  RELERR ,  ABSERR  increased
!                   appropriately for continuing
!            = 4 -- INTEGRATION DID NOT REACH  TOUT  BECAUSE MORE THAN
!                   MAXNUM steps needed
!            = 5 -- INTEGRATION DID NOT REACH  TOUT  BECAUSE EQUATIONS
!                   appear to be stiff
!            = 6 -- INTEGRATION DID NOT REACH  TOUT  BECAUSE SOLUTION
!                   vanished making pure relative error impossible.
!                   Must use non-zero  ABSERR  to continue.
!            = 7 -- INVALID INPUT PARAMETERS (FATAL ERROR)
!           the value of  IFLAG  is returned negative when the input
!           value is negative and the integration does not reach  tout ,
!           I.E., -3, -4, -5, -6.
!      WORK(*),IWORK(*) -- information generally of no interest to the
!           user but necessary for subsequent calls.
!
!   Subsequent calls to  ODE --
!
!   Subroutine  ODE  returns with all information needed to continue
!   the integration.  If the integration reached  tout , the user need
!   only define a new  tout  and call again.  If the integration did not
!   reach  tout  and the user wants to continue, he just calls again.
!   IN THE CASE  IFLAG=6 , THE USER MUST ALSO ALTER THE ERROR CRITERION.
!   The output value of  IFLAG  is the appropriate input value for
!   subsequent calls.  The only situation in which it should be altered
!   is to stop the integration internally at the new  tout , I.E.,
!   CHANGE OUTPUT  IFLAG=2  TO INPUT  IFLAG=-2 .  ERROR TOLERANCES MAY
!   be changed by the user before continuing.  All other parameters must
!   remain unchanged.
!
logical :: start, phase1, nornd
external f
data ialpha,ibeta,isig,iv,iw,ig,iphase,ipsi,ix,ih,ihold,istart, &
&itold,idelsn/1,13,25,38,50,62,75,76,88,89,90,91,92,93/
!
iyy = 100
iwt = iyy + neqn
ip = iwt + neqn
iyp = ip + neqn
iypout = iyp + neqn
iphi = iypout + neqn
if(iabs(iflag) .lt. 2  .or.  iabs(iflag) .gt. 6) go to 1
start = work(istart) .gt. 0.0
phase1 = work(iphase) .gt. 0.0
nornd = iwork(2) .ne. -1
1 call de1(f,neqn,y,t,tout,relerr,abserr,iflag,work(iyy), &
&work(iwt),work(ip),work(iyp),work(iypout),work(iphi), &
&work(ialpha),work(ibeta),work(isig),work(iv),work(iw),work(ig), &
&phase1,work(ipsi),work(ix),work(ih),work(ihold),start, &
&work(itold),work(idelsn),iwork(1),nornd,iwork(3),iwork(4), &
&iwork(5))
work(istart) = -1.0
if(start) work(istart) = 1.0
work(iphase) = -1.0
if(phase1) work(iphase) = 1.0
iwork(2) = -1
if(nornd) iwork(2) = 1
return
end subroutine ode

subroutine de1(f,neqn,y,t,tout,relerr,abserr,iflag, &
&yy,wt,p,yp,ypout,phi,alpha,beta,sig,v,w,g,phase1,psi,x,h,hold, &
&start,told,delsgn,ns,nornd,k,kold,isnold)
implicit none
integer, intent(inout) :: iflag, isnold, k, kold
integer, intent(in) :: neqn
integer, intent(inout) :: ns
real, intent(inout) :: abserr, alpha(12), beta(12), delsgn, g(13), &
&h, hold, p(neqn), phi(neqn,16), psi(12), relerr, sig(13), t, told
real, intent(in) :: tout
real, intent(inout) :: v(12), w(12), wt(neqn), x, y(neqn)
real :: yp(neqn)
real, intent(inout) :: ypout(neqn), yy(neqn)
integer :: isn, kle4, l, maxnum, nostep
real :: absdel, abseps, del, eps, fouru, releps, tend, u
real :: spmpar
!
!   ODE  merely allocates storage for  DE1 to relieve the user of the
!   inconvenience of a long call list.  Consequently  DE1 is used as
!   described in the comments for  ODE .
!
!   This code is completely explained and documented in the text,
!   computer solution of ordinary differential equations,  the initial
!   value problem  by L. F. Shampine and M. K. Gordon.
!
logical :: stiff, crash
logical, intent(inout) :: start, phase1, nornd
external f
!
!   The constant  MAXNUM  is the maximum number of steps allowed in one
!   CALL TO  DE1.  THE USER MAY CHANGE THIS LIMIT BY ALTERING THE
!   following statement
!
data maxnum/500/
!
!   ****** U IS A MACHINE DEPENDENT PARAMETER. U IS THE SMALLEST
!          POSITIVE NUMBER FOR WHICH 1.0 + U .GT. 1.0.
!
u = spmpar(1)
fouru = 4.0*u
!
!            ***            ***            ***
!
!   Test for improper parameters
!
if(neqn .lt. 1) go to 10
if(t .eq. tout) go to 10
if(relerr .lt. 0.0  .or.  abserr .lt. 0.0) go to 10
eps = amax1(relerr,abserr)
if(eps .le. 0.0) go to 10
if(iflag .eq. 0) go to 10
isn = isign(1,iflag)
iflag = iabs(iflag)
if(iflag .eq. 1) go to 20
if(t .ne. told) go to 10
if(iflag .ge. 2  .and.  iflag .le. 5) go to 20
if(iflag .eq. 6  .and.  abserr .gt. 0.0) go to 20
10 iflag = 7
return
!
!   On each call set interval of integration and counter for number of
!   steps.  Adjust input error tolerances to define weight vector for
!   SUBROUTINE  STEP1
!
20 del = tout - t
absdel = abs(del)
tend = t + 10.0*del
if(isn .lt. 0) tend = tout
nostep = 0
kle4 = 0
stiff = .false.
releps = relerr/eps
abseps = abserr/eps
if(iflag .eq. 1) go to 30
if(isnold .lt. 0) go to 30
if(delsgn*del .gt. 0.0) go to 50
!
!   On start and restart also set work variables X and YY(*), store the
!   direction of integration and initialize the step size
!
30 start = .true.
x = t
do 40 l = 1,neqn
40 yy(l) = y(l)
delsgn = sign(1.0,del)
h = sign(amax1(fouru*abs(x),abs(tout-x)),tout-x)
!
!   If already past output point, interpolate and return
!
50 if(abs(x-t) .lt. absdel) go to 60
call intrp(x,yy,tout,y,ypout,neqn,kold,phi,psi)
iflag = 2
t = tout
told = t
isnold = isn
return
!
!   If cannot go past output point and sufficiently close,
!   extrapolate and return
!
60 if(isn .gt. 0  .or.  abs(tout-x) .ge. fouru*abs(x)) go to 80
h = tout - x
call f(x,yy,yp)
do 70 l = 1,neqn
70 y(l) = yy(l) + h*yp(l)
iflag = 2
t = tout
told = t
isnold = isn
return
!
!   Test for too many steps
!
80 if(nostep .lt. maxnum) go to 100
iflag = isn*4
if(stiff) iflag = isn*5
do 90 l = 1,neqn
90 y(l) = yy(l)
t = x
told = t
isnold = 1
return
!
!   Limit step size, set weight vector and take a step
!
100 h = sign(amin1(abs(h),abs(tend-x)),h)
do l = 1,neqn
  wt(l) = releps*abs(yy(l)) + abseps
  if(wt(l) .le. 0.0) go to 140
  end do
call step1(f,neqn,yy,x,h,eps,wt,start, &
&hold,k,kold,crash,phi,p,yp,psi, &
&alpha,beta,sig,v,w,g,phase1,ns,nornd)
!
!   Test for tolerances too small
!
if(.not.crash) go to 130
iflag = isn*3
relerr = eps*releps
abserr = eps*abseps
do 120 l = 1,neqn
120 y(l) = yy(l)
t = x
told = t
isnold = 1
return
!
!   Augment counter on number of steps and test for stiffness
!
130 nostep = nostep + 1
kle4 = kle4 + 1
if(kold .gt. 4) kle4 = 0
if(kle4 .ge. 50) stiff = .true.
go to 50
!
!   Relative error criterion inappropriate
!
140 iflag = isn*6
do 150 l = 1,neqn
150 y(l) = yy(l)
t = x
told = t
isnold = 1
return
end subroutine de1

subroutine step1(f,neqn,y,x,h,eps,wt,start, &
&hold,k,kold,crash,phi,p,yp,psi, &
&alpha,beta,sig,v,w,g,phase1,ns,nornd)
implicit none
integer, intent(inout) :: k, kold
integer, intent(in) :: neqn
integer, intent(inout) :: ns
real, intent(inout) :: alpha(12), beta(12), eps, g(13), h, hold, &
&p(neqn), phi(neqn,16), psi(12), sig(13), v(12), w(12)
real :: wt(neqn)
real, intent(inout) :: x, y(neqn)
real :: yp(neqn)
integer :: i, ifail, im1, ip1, iq, j, km1, km2, knew, kp1, kp2, l, &
&limit1, limit2, nsm2, nsp1, nsp2
real :: absh, erk, erkm1, erkm2, erkp1, err, fouru, gstr(13), &
&hnew, p5eps, r, reali, realns, rho, round, sum, tau, temp1, temp2, &
&temp3, temp4, temp5, temp6, two(13), twou, u, xold
real :: spmpar
!
!   WRITTEN BY L. F. SHAMPINE AND M. K. GORDON
!
!   Abstract
!
!   Subroutine  STEP1  is normally used indirectly through subroutine
!   ODE .  Because  ODE  suffices for most problems and is much easier
!   to use, using it should be considered before using  STEP1  alone.
!
!   Subroutine STEP1 integrates a system of  NEQN  first order ordinary
!   differential equations one step, normally from X to X+H, using A
!   modified divided difference form of the Adams PECE formulas.  Local
!   extrapolation is used to improve absolute stability and accuracy.
!   The code adjusts its order and step size to control the local error
!   per unit step in a generalized sense.  Special devices are included
!   to control roundoff error and to detect when the user is requesting
!   too much accuracy.
!
!   This code is completely explained and documented in the text,
!   computer solution of ordinary differential equations,  the initial
!   value problem  by L. F. Shampine and M. K. Gordon.
!
!
!   The parameters represent...
!      F -- subroutine to evaluate derivatives
!      NEQN -- number of equations to be integrated
!      Y(*) -- solution vector at X
!      X -- independent variable
!      H -- appropriate step size for next step.  Normally determined by
!           code
!      eps -- local error tolerance
!      WT(*) -- vector of weights for error criterion
!      start -- logical variable SET .True. For first step,  .False.
!           Otherwise
!      hold -- step size used for last successful step
!      K -- appropriate order for next step (determined by code)
!      KOLD -- order used for last successful step
!      crash -- logical variable SET .True. When no step can be taken,
!           .False. Otherwise.
!      YP(*) -- derivative of solution vector at  X  after successful
!           step
!   the arrays  phi, psi  are required for the interpolation subroutine
!   INTRP .  The array  P  is internal to the code.  The remaining nine
!   variables and arrays are included in the call list only to eliminate
!   local retention of variables between calls.
!
!   Input to STEP1
!
!      First call --
!
!   The user must provide storage in his calling program for all arrays
!   in the call list, namely
!
!     DIMENSION Y(NEQN),WT(NEQN),PHI(NEQN,16),P(NEQN),YP(NEQN),PSI(12),
!    1  ALPHA(12),BETA(12),SIG(13),V(12),W(12),G(13)
!
!   The user must also declare  start ,  crash ,  PHASE1  and  NORND
!   LOGICAL VARIABLES AND  F  AN EXTERNAL SUBROUTINE, SUPPLY THE
!   SUBROUTINE  F(X,Y,YP)  TO EVALUATE
!      DY(I)/DX = YP(I) = F(X,Y(1),Y(2),...,Y(NEQN))
!   and initialize only the following parameters...
!      NEQN -- number of equations to be integrated
!      Y(*) -- vector of initial values of dependent variables
!      X -- initial value of the independent variable
!      H -- nominal step size indicating direction of integration
!           and maximum size of step.  Must be variable
!      eps -- local error tolerance per step.  Must be variable
!      WT(*) -- vector of non-zero weights for error criterion
!      start -- .True.
!
!   STEP1  requires that the L2 norm of the vector with components
!   local ERROR(L)/WT(L)  be less than  eps  for a successful step.  The
!   array  WT  allows the user to specify an error test appropriate
!   for his problem.  For example,
!      WT(L) = 1.0  SPECIFIES ABSOLUTE ERROR,
!            = ABS(Y(L))  ERROR RELATIVE TO THE MOST RECENT VALUE OF THE
!                 L-TH component of the solution,
!            = ABS(YP(L))  ERROR RELATIVE TO THE MOST RECENT VALUE OF
!                 the L-TH component of the derivative,
!            = AMAX1(WT(L),ABS(Y(L)))  ERROR RELATIVE TO THE LARGEST
!                 magnitude of L-TH component obtained so far,
!            = ABS(Y(L))*RELERR/EPS + ABSERR/EPS  SPECIFIES A MIXED
!                 relative-absolute test where  RELERR  is relative
!                 ERROR,  ABSERR  IS ABSOLUTE ERROR AND  EPS =
!                 AMAX1(RELERR,ABSERR) .
!
!      Subsequent calls --
!
!   Subroutine  STEP1  is designed so that all information needed to
!   CONTINUE THE INTEGRATION, INCLUDING THE STEP SIZE  H  AND THE ORDER
!   K , is returned with each step.  With the exception of the step
!   size, the error tolerance, and the weights, none of the parameters
!   should be altered.  The array  WT  must be updated after each step
!   to maintain relative error tests like those above.  Normally the
!   integration is continued just beyond the desired endpoint and the
!   solution interpolated there with subroutine  INTRP .  If it is
!   impossible to integrate beyond the endpoint, the step size may be
!   reduced to hit the endpoint since the code will not take a step
!   larger than the  H  input.  Changing the direction of integration,
!   I.E., THE SIGN OF  H , REQUIRES THE USER SET  START = .TRUE. BEFORE
!   calling  STEP1  again.  This is the only situation in which  start
!   should be altered.
!
!   Output from STEP1
!
!      Successful step --
!
!   The subroutine returns after each successful step with  start  and
!   crash  set .False. .  X  represents the independent variable
!   advanced one step of length  hold  from its value on input and  Y
!   the solution vector at the new value of  X .  All other parameters
!   represent information corresponding to the new  X  needed to
!   CONTINUE THE INTEGRATION.
!
!      Unsuccessful step --
!
!   When the error tolerance is too small for the machine precision,
!   THE SUBROUTINE RETURNS WITHOUT TAKING A STEP AND  CRASH = .TRUE. .
!   An appropriate step size and error tolerance for continuing are
!   estimated and all other information is restored as upon input
!   before returning.  To continue with the larger tolerance, the user
!   just calls the code again.  A restart is neither required nor
!   desirable.
!
logical, intent(inout) :: start
logical, intent(out) :: crash
logical, intent(inout) :: phase1, nornd
external f
!
data two(1)/2.0/, two(2)/4.0/, two(3)/8.0/, two(4)/16.0/, &
&two(5)/32.0/, two(6)/64.0/, two(7)/128.0/, two(8)/256.0/, &
&two(9)/512.0/, two(10)/1024.0/, two(11)/2048.0/, &
&two(12)/4096.0/, two(13)/8192.0/
data gstr(1)/0.500/, gstr(2)/0.0833/, gstr(3)/0.0417/, &
&gstr(4)/0.0264/, gstr(5)/0.0188/, gstr(6)/0.0143/, &
&gstr(7)/0.0114/, gstr(8)/0.00936/, gstr(9)/0.00789/, &
&gstr(10)/0.00679/, gstr(11)/0.00592/, gstr(12)/0.00524/, &
&gstr(13)/0.00468/
!
!   ****** U IS A MACHINE DEPENDENT PARAMETER. IT IS THE SMALLEST
!          POSITIVE NUMBER FOR WHICH 1.0 + U .GT. 1.0.
!
u = spmpar(1)
twou = 2.0*u
fouru = 4.0*u
!
!       ***     BEGIN BLOCK 0     ***
!
!   Check if step size or error tolerance is too small for machine
!   precision.  If first step, initialize phi array and estimate A
!   starting step size.
!
!                   ***
!
!   If step size is too small, determine an acceptable one
!
crash = .true.
if(abs(h) .ge. fouru*abs(x)) go to 5
h = sign(fouru*abs(x),h)
return
5 p5eps = 0.5*eps
!
!   If error tolerance is too small, increase it to an acceptable value
!
round = 0.0
do 10 l = 1,neqn
10 round = round + (y(l)/wt(l))**2
round = twou*sqrt(round)
if(p5eps .ge. round) go to 15
eps = 2.0*round*(1.0 + fouru)
return
15 crash = .false.
g(1) = 1.0
g(2) = 0.5
sig(1) = 1.0
if(.not.start) go to 99
!
!   Initialize.  Compute appropriate step size for first step
!
call f(x,y,yp)
sum = 0.0
do 20 l = 1,neqn
  phi(l,1) = yp(l)
  phi(l,2) = 0.0
20 sum = sum + (yp(l)/wt(l))**2
sum = sqrt(sum)
absh = abs(h)
if(eps .lt. 16.0*sum*h*h) absh = 0.25*sqrt(eps/sum)
h = sign(amax1(absh,fouru*abs(x)),h)
hold = 0.0
k = 1
kold = 0
start = .false.
phase1 = .true.
nornd = .true.
if(p5eps .gt. 100.0*round) go to 99
nornd = .false.
do 25 l = 1,neqn
25 phi(l,15) = 0.0
99 ifail = 0
!
!       ***     END BLOCK 0     ***
!
!       ***     BEGIN BLOCK 1     ***
!
!   Compute coefficients of formulas for this step.  Avoid computing
!   those quantities not changed when step size is not changed.
!
!                   ***
!
100 kp1 = k+1
kp2 = k+2
km1 = k-1
km2 = k-2
!
!   NS is the number of steps taken with size H, including the current
!   ONE.  WHEN K.LT.NS, NO COEFFICIENTS CHANGE
!
if(h .ne. hold) ns = 0
if (ns.le.kold) ns = ns+1
nsp1 = ns+1
if (k .lt. ns) go to 199
!
!   Compute those components of ALPHA(*),BETA(*),PSI(*),SIG(*) which
!   are changed
!
beta(ns) = 1.0
realns = ns
alpha(ns) = 1.0/realns
temp1 = h*realns
sig(nsp1) = 1.0
if(k .lt. nsp1) go to 110
do 105 i = nsp1,k
  im1 = i-1
  temp2 = psi(im1)
  psi(im1) = temp1
  beta(i) = beta(im1)*psi(im1)/temp2
  temp1 = temp2 + h
  alpha(i) = h/temp1
  reali = i
105 sig(i+1) = reali*alpha(i)*sig(i)
110 psi(k) = temp1
!
!   Compute coefficients G(*)
!
!   Initialize V(*) and set W(*).
!
if(ns .gt. 1) go to 120
do 115 iq = 1,k
  temp3 = iq*(iq+1)
  v(iq) = 1.0/temp3
115 w(iq) = v(iq)
go to 140
!
!   If order was raised, update diagonal part of V(*)
!
120 if(k .le. kold) go to 130
temp4 = k*kp1
v(k) = 1.0/temp4
nsm2 = ns-2
if(nsm2 .lt. 1) go to 130
do 125 j = 1,nsm2
  i = k-j
125 v(i) = v(i) - alpha(j+1)*v(i+1)
!
!   Update V(*) and set W(*)
!
130 limit1 = kp1 - ns
temp5 = alpha(ns)
do 135 iq = 1,limit1
  v(iq) = v(iq) - temp5*v(iq+1)
135 w(iq) = v(iq)
g(nsp1) = w(1)
!
!   Compute the G(*) in the work vector W(*)
!
140 nsp2 = ns + 2
if(kp1 .lt. nsp2) go to 199
do 150 i = nsp2,kp1
  limit2 = kp2 - i
  temp6 = alpha(i-1)
  do 145 iq = 1,limit2
145 w(iq) = w(iq) - temp6*w(iq+1)
150 g(i) = w(1)
199 continue
!
!       ***     END BLOCK 1     ***
!
!       ***     BEGIN BLOCK 2     ***
!
!   Predict a solution P(*), evaluate derivatives using predicted
!   solution, estimate local error at order K and errors at orders K,
!   K-1, K-2 as if constant step size were used.
!
!                   ***
!
!   Change phi to phi star
!
if(k .lt. nsp1) go to 215
do i = nsp1,k
  temp1 = beta(i)
  do 205 l = 1,neqn
205 phi(l,i) = temp1*phi(l,i)
  end do
!
!   Predict solution and differences
!
215 do 220 l = 1,neqn
  phi(l,kp2) = phi(l,kp1)
  phi(l,kp1) = 0.0
220 p(l) = 0.0
do j = 1,k
  i = kp1 - j
  ip1 = i+1
  temp2 = g(i)
  do 225 l = 1,neqn
    p(l) = p(l) + temp2*phi(l,i)
225 phi(l,i) = phi(l,i) + phi(l,ip1)
  end do
if(nornd) go to 240
do 235 l = 1,neqn
  tau = h*p(l) - phi(l,15)
  p(l) = y(l) + tau
235 phi(l,16) = (p(l) - y(l)) - tau
go to 250
240 do 245 l = 1,neqn
245 p(l) = y(l) + h*p(l)
250 xold = x
x = x + h
absh = abs(h)
call f(x,p,yp)
!
!   Estimate errors at orders K,K-1,K-2
!
erkm2 = 0.0
erkm1 = 0.0
erk = 0.0
do 265 l = 1,neqn
  temp3 = 1.0/wt(l)
  temp4 = yp(l) - phi(l,1)
  if(km2)265,260,255
255 erkm2 = erkm2 + ((phi(l,km1)+temp4)*temp3)**2
260 erkm1 = erkm1 + ((phi(l,k)+temp4)*temp3)**2
265 erk = erk + (temp4*temp3)**2
if(km2)280,275,270
270 erkm2 = absh*sig(km1)*gstr(km2)*sqrt(erkm2)
275 erkm1 = absh*sig(k)*gstr(km1)*sqrt(erkm1)
280 temp5 = absh*sqrt(erk)
err = temp5*(g(k)-g(kp1))
erk = temp5*sig(kp1)*gstr(k)
knew = k
!
!   Test if order should be lowered
!
if(km2)299,290,285
285 if(amax1(erkm1,erkm2) .le. erk) knew = km1
go to 299
290 if(erkm1 .le. 0.5*erk) knew = km1
!
!   Test if step successful
!
299 if(err .le. eps) go to 400
!
!       ***     END BLOCK 2     ***
!
!       ***     BEGIN BLOCK 3     ***
!
!   The step is unsuccessful.  Restore  X, PHI(*,*), PSI(*) .
!   If third consecutive failure, set order to one.  If step fails more
!   than three times, consider an optimal step size.  Double error
!   tolerance and return if estimated step size is too small for machine
!   precision.
!                   ***
!
!   Restore X, PHI(*,*) and PSI(*)
!
phase1 = .false.
x = xold
do i = 1,k
  temp1 = 1.0/beta(i)
  ip1 = i+1
  do 305 l = 1,neqn
305 phi(l,i) = temp1*(phi(l,i) - phi(l,ip1))
  end do
if(k .lt. 2) go to 320
do 315 i = 2,k
315 psi(i-1) = psi(i) - h
!
!   On third failure, set order to one.  Thereafter, use optimal step
!   size
!
320 ifail = ifail + 1
temp2 = 0.5
if(ifail - 3) 335,330,325
325 if(p5eps .lt. 0.25*erk) temp2 = sqrt(p5eps/erk)
330 knew = 1
335 h = temp2*h
k = knew
if(abs(h) .ge. fouru*abs(x)) go to 340
crash = .true.
h = sign(fouru*abs(x),h)
eps = eps + eps
return
340 go to 100
!
!       ***     END BLOCK 3     ***
!
!       ***     BEGIN BLOCK 4     ***
!
!   The step is successful.  Correct the predicted solution, evaluate
!   the derivatives using the corrected solution and update the
!   differences.  Determine best order and step size for next step.
!
!                   ***
400 kold = k
hold = h
!
!   Correct and evaluate
!
temp1 = h*g(kp1)
if(nornd) go to 410
do 405 l = 1,neqn
  rho = temp1*(yp(l) - phi(l,1)) - phi(l,16)
  y(l) = p(l) + rho
405 phi(l,15) = (y(l) - p(l)) - rho
go to 420
410 do 415 l = 1,neqn
415 y(l) = p(l) + temp1*(yp(l) - phi(l,1))
420 call f(x,y,yp)
!
!   Update differences for next step
!
do 425 l = 1,neqn
  phi(l,kp1) = yp(l) - phi(l,1)
425 phi(l,kp2) = phi(l,kp1) - phi(l,kp2)
do i = 1,k
  do 430 l = 1,neqn
430 phi(l,i) = phi(l,i) + phi(l,kp1)
  end do
!
!   Estimate error at order K+1 unless...
!     in first phase when always raise order,
!     already decided to lower order,
!     step size not constant so estimate unreliable
!
erkp1 = 0.0
if(knew .eq. km1  .or.  k .eq. 12) phase1 = .false.
if(phase1) go to 450
if(knew .eq. km1) go to 455
if(kp1 .gt. ns) go to 460
do 440 l = 1,neqn
440 erkp1 = erkp1 + (phi(l,kp2)/wt(l))**2
erkp1 = absh*gstr(kp1)*sqrt(erkp1)
!
!   Using estimated error at order K+1, determine appropriate order
!   for next step
!
if(k .gt. 1) go to 445
if(erkp1 .ge. 0.5*erk) go to 460
go to 450
445 if(erkm1 .le. amin1(erk,erkp1)) go to 455
if(erkp1 .ge. erk  .or.  k .eq. 12) go to 460
!
!   HERE ERKP1 .LT. ERK .LT. AMAX1(ERKM1,ERKM2) ELSE ORDER WOULD HAVE
!   been lowered in block 2.  Thus order is to be raised
!
!   Raise order
!
450 k = kp1
erk = erkp1
go to 460
!
!   Lower order
!
455 k = km1
erk = erkm1
!
!   With new order determine appropriate step size for next step
!
460 hnew = h + h
if(phase1) go to 465
if(p5eps .ge. erk*two(k+1)) go to 465
hnew = h
if(p5eps .ge. erk) go to 465
temp2 = k+1
r = (p5eps/erk)**(1.0/temp2)
hnew = absh*amax1(0.5,amin1(0.9,r))
hnew = sign(amax1(hnew,fouru*abs(x)),h)
465 h = hnew
return
!
!       ***     END BLOCK 4     ***
!
end subroutine step1

subroutine intrp(x,y,xout,yout,ypout,neqn,kold,phi,psi)
implicit none
integer, intent(in) :: kold, neqn
real :: phi(neqn,16), psi(12)
real, intent(in) :: x, xout
real :: y(neqn)
real, intent(inout) :: yout(neqn), ypout(neqn)
integer :: i, j, jm1, ki, kip1, l, limit1
real :: eta, g(13), gamma, hi, psijm1, rho(13), temp1, temp2, &
&temp3, term, w(13)
!
!   WRITTEN BY L. F. SHAMPINE AND M. K. GORDON
!
!   Abstract
!
!   The methods in subroutine  STEP1  approximate the solution near  X
!   by a polynomial.  Subroutine  INTRP  approximates the solution at
!   XOUT  by evaluating the polynomial there.  Information defining this
!   polynomial is passed from  STEP1  so  INTRP  cannot be used alone.
!
!   This code is completely explained and documented in the text,
!   computer solution of ordinary differential equations,  the initial
!   value problem  by L. F. Shampine and M. K. Gordon.
!
!   Input to INTRP --
!
!   The user provides storage in the calling program for the arrays in
!   the call list
!      DIMENSION Y(NEQN),YOUT(NEQN),YPOUT(NEQN),PHI(NEQN,16),PSI(12)
!   and defines
!      XOUT -- point at which solution is desired.
!   The remaining parameters are defined in  STEP1  and passed to  INTRP
!   from that subroutine.
!
!   Output from  INTRP --
!
!      YOUT(*) -- solution at  XOUT
!      YPOUT(*) -- derivative of solution at  XOUT
!   the remaining parameters are returned unaltered from their input
!   values.  Integration with  STEP1  may be continued.
!
data g(1)/1.0/,rho(1)/1.0/
!
hi = xout - x
ki = kold + 1
kip1 = ki + 1
!
!   Initialize W(*) for computing G(*)
!
do 5 i = 1,ki
  temp1 = i
5 w(i) = 1.0/temp1
term = 0.0
!
!   Compute G(*)
!
do 15 j = 2,ki
  jm1 = j - 1
  psijm1 = psi(jm1)
  gamma = (hi + term)/psijm1
  eta = hi/psijm1
  limit1 = kip1 - j
  do 10 i = 1,limit1
10 w(i) = gamma*w(i) - eta*w(i+1)
  g(j) = w(1)
  rho(j) = gamma*rho(jm1)
15 term = psijm1
!
!   Interpolate
!
do 20 l = 1,neqn
  ypout(l) = 0.0
20 yout(l) = 0.0
do j = 1,ki
  i = kip1 - j
  temp2 = g(i)
  temp3 = rho(i)
  do 25 l = 1,neqn
    yout(l) = yout(l) + temp2*phi(l,i)
25 ypout(l) = ypout(l) + temp3*phi(l,i)
  end do
do 35 l = 1,neqn
35 yout(l) = y(l) + hi*yout(l)
return
end subroutine intrp

subroutine brkf45 (fcn,neqn,y,t,tout,tend,yp,relerr,abserr,iflag, &
&work,iwork)
implicit none
integer, intent(inout) :: iflag, iwork(5)
integer, intent(in) :: neqn
real, intent(in) :: abserr
real, intent(inout) :: relerr, t
real, intent(in) :: tend, tout
real, intent(inout) :: work(*), y(neqn), yp(neqn)
integer :: kf1, kf2, kf3, kf4, kf7, kh, khi, ksa, ksr, kt, kw, &
&kwp, kx, ky1, ky2
!
!     Block Fehlberg fourth-fifth order Runge-Kutta method advancing
!     a block of two equal steps.  The formula at the first step is
!     5(4) while at the second step it is 6(4).
!
!     WRITTEN BY J.R.CASH,
!        DEPARTMENT OF MATHEMATICS,
!        IMPERIAL COLLEGE,
!        SOUTH KENSINGTON, LONDON SW7 2AZ,
!        ENGLAND.
!     MODIFIED BY D. HIGHAM AND A.H. MORRIS.
!
!    THIS IS A HEAVILY REVISED VERSION OF RKF45 OF L.F. SHAMPINE AND
!    H.A. WATTS.
!    BRKF45 IS PRIMARILY DESIGNED TO SOLVE NON-STIFF AND MILDLY STIFF
!    INITIAL VALUE ORDINARY DIFFERENTIAL EQUATIONS WHEN DERIVATIVE
!    EVALUATIONS ARE INEXPENSIVE. BRKF45 USES INTERPOLATION TO PRODUCE
!    OUTPUT AT OFF-STEP POINTS EFFICIENTLY. BRKF45 SHOULD GENERALLY
!    NOT BE USED WHEN THE USER IS DEMANDING HIGH ACCURACY.  IN SUCH
!    CASES A GOOD ADAMS CODE WILL OFTEN BE MORE EFFICIENT.
!
!***********************************************************************
! Abstract
!***********************************************************************
!
!    Subroutine  BRKF45  integrates a system of NEQN first order
!    ordinary differential equations of the form
!
!             DY(I)/DT = FCN(T,Y(1),Y(2),...,Y(NEQN))
!
!    WHERE THE Y(I) ARE KNOWN AT TIME T.
!    TYPICALLY THE SUBROUTINE IS USED TO INTEGRATE FROM T TO TEND
!    (WHILE RETURNING ANSWERS AT SPECIFIED OUTPUT POINTS TOUT), BUT
!    IT CAN ALSO BE USED AS A ONE-BLOCK INTEGRATOR TO ADVANCE THE
!    SOLUTION A SINGLE BLOCK STEP IN THE DIRECTION OF TEND.  ON RETURN
!    THE PARAMETERS IN THE CALL LIST ARE SET FOR CONTINUING THE
!    INTEGRATION. THE USER HAS ONLY TO CALL BRKF45 AGAIN (AND PERHAPS
!    DEFINE A NEW VALUE FOR TOUT). ACTUALLY, BRKF45 IS AN INTERFACING
!    ROUTINE WHICH CALLS SUBROUTINE RKFC FOR THE SOLUTION.  SUBROUTINE
!    RKFC COMPUTES AN APPROXIMATE SOLUTION OVER ONE BLOCK OF LENGTH 2H.
!    BRKF45 IS PARTICULARLY USEFUL WHEN OUTPUT IS REQUIRED AT MANY
!    OFF-STEP POINTS SINCE THE OUTPUT VALUES CAN BE OBTAINED BY
!    INTERPOLATION.  THIS IS IN CONTRAST TO MANY OTHER RUNGE-KUTTA
!    PROGRAMS WHICH CHOOSE THE STEP SEQUENCE SO AS TO HIT ALL OUTPUT
!    POINTS EXACTLY AND SO BECOME INEFFICIENT WHEN OUTPUT IS REQUIRED
!    AT MANY POINTS WITHIN A STEP.
!    BRKF45 USES THE (5,4), (6,4) BLOCK FORMULA DESCRIBED IN
!    J.R. CASH,  A BLOCK 6(4) RUNGE-KUTTA FORMULA FOR NON-STIFF
!    INITIAL VALUE PROBLEMS, ACM TRANS. MATH SOFTWARE 15 (1989),
!    PP. 15-28.
!
!    The parameters represent-
!      FCN -- subroutine FCN(T,Y,YP) to evaluate derivatives
!              YP(I)=DY(I)/DT
!      NEQN -- number of differential equations to be integrated.
!      Y(*) -- approximation to the solution vector at T.
!      T -- independent variable.
!      Tout -- the next point where intermediate output is
!              required.  Approximate solutions at these points
!              will be obained by interpolation.
!      Tend -- end of the integration range.  This will be hit exactly.
!      YP(*) -- approximation to the derivative vector DY/DT at T.
!      RELERR,ABSERR -- relative and absolute error tolerances for
!            LOCAL ERROR TEST. AT THE NTH POINT OF EACH BLOCK (N=1,2)
!            the code requires that
!                 ABS(LOCAL ERROR)/N .LE. RELERR*ABS(Y) + ABSERR
!            for each component of the local error and solution vectors
!      IFLAG -- indicator for status of integration.
!      WORK(*) -- array to hold information internal to BRKF45 which
!            is necessary for subsequent calls. Must be dimensioned
!            at least  6+9*NEQN
!      IWORK(*) -- integer array used to hold information internal to
!            BRKF45 which is necessary for subsequent calls. Must be
!            dimensioned at least  5
!
!***********************************************************************
!  First call to BRKF45
!***********************************************************************
!
!    The user must provide storage in his calling program for the arrays
!    in the call list  -  Y(NEQN) , YP(NEQN) , WORK(6+9*NEQN)
!    IWORK(5), declare FCN in an external statement, supply subroutine
!    FCN(T,Y,YP) and initialize the following parameters-
!
!      NEQN -- NUMBER OF EQUATIONS TO BE INTEGRATED.  (NEQN .GE. 1)
!      Y(*) -- vector of initial conditions.
!      T -- starting point of integration , must be a variable.
!      Tout -- output point at which solution, and possibly the
!              derivative, is desired.
!      Tend -- end of the range of integration. If the solution is
!              REQUIRED ONLY AT TEND THEN THE USER SHOULD SET TOUT=TEND.
!      RELERR,ABSERR -- relative and absolute local error tolerances
!            which must be non-negative. RELERR must be a variable while
!            ABSERR may be a constant. The code should normally not be
!            used with relative error control smaller than about 1.E-8,
!            unless an appropriate nonzero absolute tolerance is given.
!            To avoid limiting precision difficulties the code requires
!            RELERR to be larger than an internally computed relative
!            error parameter which is machine dependent. In particular,
!            pure absolute error is not permitted. If a smaller than
!            allowable value of RELERR is attempted, BRKF45 increases
!            RELERR appropriately and returns control to the user before
!            continuing the integration.
!      IFLAG -- +1,-1  indicator to initialize the code for each new
!            PROBLEM. NORMAL INPUT IS +1. THE USER SHOULD SET IFLAG=-1
!            only when one-block integrator control is essential. In
!            this case, BRKF45 attempts to advance the solution A
!            single block in the direction of tend each time it is
!            called.  Since this mode of operation results in extra
!            computing overhead, it should be avoided unless needed.
!
!***********************************************************************
!  Output from BRKF45
!***********************************************************************
!
!      Y(*) -- computed solution approximation at T.
!      T -- value of the independent variable where the solution is
!           reported.
!      IFLAG = 2 -- SUCCESSFUL RETURN.  EITHER THE INTEGRATION REACHED
!                   T=TEND OR A SUCCESSFUL INTERPOLATION HAS BEEN
!                   PERFORMED AT T=TOUT.  IF T.EQ.TEND THEN THE
!                   integration is finished.  If not, the code should be
!                   CALLED WITH THE NEXT VALUE OF TOUT AND WITH IFLAG=+2
!                   FOR NORMAL INTEGRATION OR IFLAG=-2 FOR ONE-BLOCK
!                   integration.
!            =-2 -- A SINGLE SUCCESSFUL BLOCK IN THE DIRECTION OF TEND
!                   has been taken. Normal mode for continuing
!                   integration one block at a time.
!            = 3 -- INTEGRATION WAS NOT COMPLETED BECAUSE RELATIVE ERROR
!                   tolerance was too small. RELERR has been increased
!                   appropriately for continuing.
!            = 4 -- INTEGRATION WAS NOT COMPLETED BECAUSE MORE THAN
!                   18000 derivative evaluations were needed. This
!                   is approximately 2000 blocks.
!            = 5 -- INTEGRATION WAS NOT COMPLETED BECAUSE SOLUTION
!                   vanished making a pure relative error test
!                   impossible. Must use non-zero ABSERR to continue.
!                   Using the one-block integration mode for one block
!                   is a good way to proceed.
!            = 6 -- INTEGRATION WAS NOT COMPLETED BECAUSE REQUESTED
!                   accuracy could not be achieved using smallest
!                   allowable stepsize. User must increase the error
!                   tolerance before continued integration can be
!                   attempted.
!            = 7 -- INVALID INPUT PARAMETERS
!                   this indicator occurs if any of the following is
!                   SATISFIED -   NEQN .LE. 0
!                                 T = TEND
!                                 RELERR OR ABSERR .LT. 0.
!                                 ABS(IFLAG) .LT. 1 OR .GT. 7
!      WORK(*),IWORK(*) -- information which is usually of no interest
!                   to the user but necessary for subsequent calls.
!                   WORK(1),...,WORK(NEQN) contain the solution vector
!                   and WORK(NEQN+1),...,WORK(2*NEQN) contain the
!                   derivative vector at the end point (which is itself
!                   contained in WORK(2*NEQN+1)) of the block step just
!                   computed. WORK(2*NEQN+2) contains the stepsize H
!                   just used. (This is the stepsize being used by the
!                   interpolant over this block.) WORK(2*NEQN+3)
!                   contains the stepsize H to be attempted on the next
!                   block. IWORK(1) contains the derivative evaluation
!                   counter.
!
!***********************************************************************
!  Subsequent calls to BRKF45
!***********************************************************************
!
!    Subroutine BRKF45 returns with all information needed to continue
!    the integration. After the code reports a successful solution at
!    TOUT (INDICATED BY IFLAG=2), THE USER NEEDS TO DEFINE A NEW TOUT
!    before simply calling BRKF45 again to continue in the normal mode.
!    (But the user must first reset IFLAG to -2 to continue in the
!    one-block integrator mode.)
!    if the integration was not completed but the user still wants to
!    CONTINUE (IFLAG=3,4), HE JUST CALLS BRKF45 AGAIN. IN THE CASE
!    IFLAG=3 THE RELERR PARAMETER HAS BEEN ADJUSTED APPROPRIATELY FOR
!    CONTINUING THE INTEGRATION. IN THE CASE OF IFLAG=4 THE FUNCTION
!    counter will be reset to 0 and another 18000 function evaluations
!    are allowed.
!    HOWEVER,IN THE CASE IFLAG=5, THE USER MUST FIRST ALTER THE ERROR
!    criterion to use a positive value of ABSERR before integration can
!    proceed. If he does not,execution is terminated.
!    ALSO,IN THE CASE IFLAG=6, IT IS NECESSARY FOR THE USER TO RESET
!    IFLAG to 2 (or -2 when the one-block integration mode is being
!    used) as well as increasing either ABSERR,RELERR or both before
!    the integration can be continued. If this is not done, execution
!    WILL BE TERMINATED. THE OCCURRENCE OF IFLAG=6 INDICATES A TROUBLE
!    SPOT(SOLUTION IS CHANGING RAPIDLY,SINGULARITY MAY BE PRESENT) and
!    it often is inadvisable to continue.
!    IF IFLAG=7 IS OBTAINED, INTEGRATION CAN NOT BE CONTINUED UNLESS
!    the invalid input parameters are corrected.
!    It should be noted that the arrays work,IWORK contain information
!    required for subsequent integration. Accordingly, work and IWORK
!    should not be altered.
!
!***********************************************************************
!  User calls to the interpolant routine EXTRA
!***********************************************************************
!
!    Subroutine EXTRA can also be called by the user, in conjunction
!    with usage of BRKF45, to provide approximate solutions at off-step
!    points by use of the interpolating polynomial. While BRKF45
!    handles the usual situations, it can be helpful to the user to be
!    able to access the interpolant directly, such as when doing root
!    finding. Also, it is possible that the user may have some need for
!    extrapolating outside of the block step on which the underlying
!    interpolant is based. BRKF45 will not do this.
!    The form of the usage call is
!
!    CALL EXTRA ( NEQN, WORK(6*NEQN+4), WORK(NEQN+1), WORK(2*NEQN+1),
!                WORK(2*NEQN+2), WORK(2*NEQN+4), WORK(3*NEQN+4),
!                WORK(4*NEQN+4), WORK(5*NEQN+4), tex, YEX, YPEX )
!
!    WHERE YEX AND YPEX ARE THE SOLUTION VECTOR AND DERIVATIVE VECTOR
!    APPROXIMATIONS DEFINED BY THE INTERPOLANT AT THE POINT TEX, AND
!    WORK IS THE WORKING ARRAY SET UP BY BRKF45. THIS VERSION OF
!    EXTRA HAS BEEN WRITTEN BY D. HIGMAN (SEE BELOW).
!
!***********************************************************************
!  More about the interpolant routine EXTRA
!***********************************************************************
!
!    THE FIRST DERIVATIVE APPROXIMATIONS GIVEN BY J.R. CASH HAVE BEEN
!    MODIFIED BY D. HIGMAN. THREE CHANGES HAVE BEEN MADE AND ARE
!    CLEARLY DOCUMENTED IN THE CODE. JUST SEARCH FOR THE WORD *CHANGES*.
!    FOR AN EXPLANATION OF THESE MODIFICATIONS SEE
!    REMARK ON ALGORITHM 669, BY D. HIGHAM,
!    ACM TRANS. MATH SOFTWARE 17, PP. 424-426.
!
!***********************************************************************
!
logical :: endpnt, blkout
external fcn
!
!     Compute indices for the splitting of the work array
!
kw = 1
kwp = kw + neqn
kx = kwp + neqn
khi = kx + 1
kh = khi + 1
ky1 = kh + 1
ky2 = ky1 + neqn
kf1 = ky2 + neqn
kf2 = kf1 + neqn
kf3 = kf2 + neqn
kf4 = kf3 + neqn
kf7 = kf4 + neqn
ksr = kf7 + neqn
ksa = ksr + 1
kt = ksa + 1
!
!     The work space totals  6 + 9*NEQN .
!
if (iabs(iflag) .eq. 1) go to 10
   endpnt = (iwork(4) .eq. -1)
   blkout = (iwork(5) .eq. -1)
!
!***********************************************************************
!     This interfacing routine merely relieves the user of a long
!     calling list via the splitting apart of two working storage
!     arrays. If this is not compatible with the users compiler,
!     he must use RKFC directly.
!***********************************************************************
!
10 call rkfc (fcn,neqn,y,t,tout,tend,yp,relerr,abserr,iflag,work(kw), &
&work(kwp),work(kx),work(khi),work(kh),work(ky1),work(ky2), &
&work(kf1),work(kf2),work(kf3),work(kf4),work(kf7),work(ksr), &
&work(ksa),work(kt),iwork(1),iwork(2),iwork(3),endpnt,blkout)
!
iwork(4) = 0
if (endpnt) iwork(4) = -1
iwork(5) = 0
if (blkout) iwork(5) = -1
!
return
end subroutine brkf45

subroutine rkfc (fcn,neqn,y,t,tout,tend,yp,relerr,abserr,iflag, &
&w,wp,x,hint,h,y1,y2,f1,f2,f3,f4,f7,savre,savae, &
&told,nfe,jflag,kflag,endpnt,blkout)
implicit none
integer, intent(inout) :: iflag, jflag, kflag
integer, intent(in) :: neqn
integer, intent(inout) :: nfe
real, intent(in) :: abserr
real :: f1(neqn)
real, intent(inout) :: f2(neqn), f3(neqn)
real :: f4(neqn), f7(neqn)
real, intent(inout) :: h, hint, relerr, savae, savre, t
real, intent(in) :: tend
real, intent(inout) :: told
real, intent(in) :: tout
real, intent(inout) :: w(neqn), wp(neqn), x, y(neqn), y1(neqn), &
&y2(neqn), yp(neqn)
integer :: k, maxnfe, mflag, n
real :: a, a21, a31, a32, a41, a42, a43, a51, a52, a53, a54, a61, &
&a62, a63, a64, a65, a81, a82, a83, a84, a85, a86, a87, a91, a92, &
&a93, a94, a95, a96, a97, a98, ae, b1, b1b, b3, b3b, b4, b4b, b5, &
&b5b, b6, b6b, b7, b8, b9, c2, c3, c4, c6, c8, c9, dt, dtsign, ee, &
&eeoet, erc11, erc13, erc14, erc15, erc21, erc23, erc24, erc25, &
&erc26, erc27, erc28, erc29, errtol, esttol, ez, hmin, hstop, &
&remin, rer, s, scale, sf, swap, tol, toler, toln, u, u26, ypk
real :: spmpar
!
!     Two step block Runge-Kutta Fehlberg method.
!     A standard 5(4) formula is used at the first point in the block
!     and A 6(4) formula is used at the second point.
!
logical :: hfaild
logical, intent(inout) :: endpnt
logical :: interp
logical, intent(inout) :: blkout
external fcn
!
!***********************************************************************
!
!     Coefficients defining the method ...
!
!                C2=0.25E+0
!                C3=3.0E+0/8.0E+0
!                C4=12.0E+0/13.0E+0
!                C6=0.5E+0
!                C8=3.0E+0/2.0E+0
!                C9=2.0E+0
!
!                A21=1.0E+0/4.0E+0
!                A31=3.0E+0/32.0E+0
!                A32=9.0E+0/32.0E+0
!                A41=1932.0E+0/2197.0E+0
!                A42=-7200.0E+0/2197.0E+0
!                A43=7296.0E+0/2197.0E+0
!                A51=439.0E+0/216.0E+0
!                A52=-8.0E+0
!                A53=3680.0E+0/513.0E+0
!                A54=-845.0E+0/4104.0E+0
!                A61=-8.0E+0/27.0E+0
!                A62=2.0E+0
!                A63=-3544.0E+0/2565.0E+0
!                A64=1859.0E+0/4104.0E+0
!                A65=-11.0E+0/40.0E+0
!
!                B1B=16.0E+0/135.0E+0
!                B3B=6656.0E+0/12825.0E+0
!                B4B=28561.0E+0/56430.0E+0
!                B5B=-9.0E+0/50.0E+0
!                B6B=2.0E+0/55.0E+0
!
!                ERC11=1.0E+0/360.0E+0
!                ERC13=-128.0E+0/4275.0E+0
!                ERC14=-2197.0E+0/75240.0E+0
!                ERC15=1.0E+0/50.0E+0
!
data c2 /.250000000000000e+00/, c3 /.375000000000000e+00/, &
&c4 /.923076923076923e+00/, c6 /.500000000000000e+00/, &
&c8 /.150000000000000e+01/, c9 /.200000000000000e+01/
!
data a21 / .250000000000000e+00/, a31 / .937500000000000e-01/, &
&a32 / .281250000000000e+00/, a41 / .879380974055530e+00/, &
&a42 /-.327719617660446e+01/, a43 / .332089212562585e+01/, &
&a51 / .203240740740741e+01/, a52 /-.800000000000000e+01/, &
&a53 / .717348927875244e+01/, a54 /-.205896686159844e+00/, &
&a61 /-.296296296296296e+00/, a62 / .200000000000000e+01/, &
&a63 /-.138167641325536e+01/, a64 / .452972709551657e+00/, &
&a65 /-.275000000000000e+00/
!
data b1b /.118518518518519e+00/, b3b / .518986354775828e+00/, &
&b4b /.506131490342017e+00/, b5b /-.180000000000000e+00/, &
&b6b /.363636363636364e-01/
!
data erc11/ .277777777777778e-02/, erc13/-.299415204678363e-01/, &
&erc14/-.291998936735779e-01/, erc15/ .200000000000000e-01/
!
!     The above define the coefficients for BRKF45 used to generate
!     the solution at the first block point. Below are additional
!     coefficients needed to generate the solution at the second block
!     point.
!
!                B1=931.0E+0/6480.0E+0
!                B3=315392.0E+0/1500525.0E+0
!                B4=371293.0E+0/615600.0E+0
!                B5=1.0E+0/50.0E+0
!                B6=0.4E+0
!                B7=-4.0E+0/15.0E+0
!                B8=85006.0E+0/115425.0E+0
!                B9=239.0E+0/1560.0E+0
!
!                A81=-119397029895.0E+0/151948225000.0E+0
!                A82=78390.0E+0/29081.0E+0
!                A83=-51517464.0E+0/132821875.0E+0
!                A84=-3780749193.0E+0/1168832500.0E+0
!                A85=79268193.0E+0/55925000.0E+0
!                A86=-11370591.0E+0/15379375.0E+0
!                A87=5670.0E+0/2237.0E+0
!
!                A91=23406188597.0E+0/8429231250.0E+0
!                A92=-62928.0E+0/13623.0E+0
!                A93=-31066887488.0E+0/5747203125.0E+0
!                A94=164486461399.0E+0/8429231250.0E+0
!                A95=-70336084.0E+0/11203125.0E+0
!                A96=185680664.0E+0/24646875.0E+0
!                A97=-3385330161.0E+0/243117160.0E+0
!                A98=232648.0E+0/96795.0E+0
!
data b1 /.143672839506173e+00/, b3 / .210187767614668e+00/, &
&b4 /.603140025990903e+00/, b5 / .200000000000000e-01/, &
&b6 /.400000000000000e+00/, b7 /-.266666666666667e+00/, &
&b8 /.736460905349794e+00/, b9 / .153205128205128e+00/
!
data a81 /-.785774430040232e+00/, a82 / .269557443004023e+01/, &
&a83 /-.387868820553843e+00/, a84 /-.323463729234086e+01/, &
&a85 / .141740175234689e+01/, a86 /-.739340252773601e+00/, &
&a87 / .253464461332141e+01/
!
data a91 / .277678804896947e+01/, a92 /-.461924686192469e+01/, &
&a93 /-.540556629238679e+01/, a94 / .195138152603181e+02/, &
&a95 /-.627825575453278e+01/, a96 / .753363921389629e+01/, &
&a97 /-.139246861924514e+02/, a98 / .240351257812904e+01/
!
!     Next we define coefficients for the error estimate formula.
!
!     B3E = 1067091077380.0E+0/1829119027671.0E+0
!     B4E = 3284168845918.0E+0/21339721989495.0E+0
!     B5E = 110317750789.0E+0/240996319200.0E+0-
!    *      4448925830089.0E+0/12329617149531.0E+0
!     B6E = 1.0E+0/25.0E+0
!     B7E = 0.2E+0
!     B8E = 239992027043.0E+0/361494478800.0E+0
!     B9E = 1273.0E+0/7800.0E+0
!     B1E = 2.0E+0-B3E-B4E-B5E-B6E-B7E-B8E-B9E
!
!     ERC21 = (B1-B1E)/2.0E+0
!     ERC23 = (B3-B3E)/2.0E+0
!     ERC24 = (B4-B4E)/2.0E+0
!     ERC25 = (B5-B5E)/2.0E+0
!     ERC26 = 9.0E+0/50.0E+0
!     ERC27 = -7.0E+0/30.0E+0
!     ERC28 = (B8 - B8E)/2.0E+0
!     ERC29 = -0.005E+0
!
data erc21 /.224905375494686e-01/, erc23 /-.186601479161668e+00/, &
&erc24 /.224620349650851e+00/, erc25 /-.384622777202128e-01/, &
&erc26 /.180000000000000e+00/, erc27 /-.233333333333333e+00/, &
&erc28 /.362862030148937e-01/, erc29 /-.500000000000000e-02/
!
!***********************************************************************
!
!  REMIN is a tolerance threshold which is also determined by the
!  integration method. In particular, a fifth order method will
!  generally not be capable of delivering accuracies near limiting
!  precision on computers with long wordlengths. This does not have
!  to be changed for different machines.
!
data remin / 1.e-12 /
!
!***********************************************************************
!
!     The expense is controlled by restricting the number
!     of function evaluations to be approximately MAXNFE.
!
data maxnfe / 18000 /
!
!***********************************************************************
!
!  The computer unit roundoff error U is the smallest positive value
!  REPRESENTABLE IN THE MACHINE SUCH THAT  1 + U .GT. 1.
!
 u = spmpar(1)
!
!***********************************************************************
!
!     Check input parameters
!
if (neqn .lt. 1) go to 500
if (relerr .lt. 0.0 .or. abserr .lt. 0.0) go to 500
if (t .eq. tend) go to 500
mflag = iabs(iflag)
if (mflag .ne. 1) go to 10
   told = t
   if (tout .eq. t) go to 70
   if (sign(1.0, tend-t) .ne. sign(1.0, tout-t)) go to 500
   go to 70
10 if (mflag .eq. 0 .or. mflag .gt. 7) go to 500
if (tout .eq. told) go to 20
if (sign(1.0, tend-told) .ne. sign(1.0, tout-told)) go to 500
!
!     Check continuation possibilities
!
20 if (mflag .ne. 2) go to 30
!
!     IFLAG = +2 OR -2
!
if (kflag .lt. 3) go to 70
if (kflag .eq. 3) go to 60
if (kflag .eq. 4) go to 50
if (kflag .eq. 5 .and. abserr .eq. 0.0) go to 40
if (kflag .eq. 6 .and. relerr .le. savre .and. abserr .le. savae) &
&go to 40
go to 70
!
!     IFLAG = 3,4,5,6 OR 7
!
30 if (iflag .eq. 3) go to 60
if (iflag .eq. 4) go to 50
if (iflag .eq. 5 .and. abserr .gt. 0.0) go to 60
!
!     Integration cannot be continued since user did not respond to
!     THE INSTRUCTIONS PERTAINING TO IFLAG=5,6 OR 7
!
40 stop
!
!***********************************************************************
!
!     Reset function evaluation counter
!
50 nfe = 0
if (mflag .eq. 2) go to 70
!
!     Reset flag VALUE from previous call
!
60 iflag = jflag
if (kflag .eq. 3) mflag = iabs(iflag)
!
!     Save input IFLAG and set continuation flag VALUE for subsequent
!     input checking
!
70 jflag = iflag
kflag = 0
!
!     Save RELERR and ABSERR for checking input on subsequent calls
!
savre = relerr
savae = abserr
!
!     Restrict relative error tolerance to be at least as large as
!     2U+REMIN to avoid limiting precision difficulties arising from
!     impossible accuracy requests. If tolerance too small, increase
!     and return.
!
rer = 2.0*u + remin
if (relerr .lt. rer) go to 520
!
u26 = 26.0*u
if (mflag .ne. 1) go to 100
!
!***********************************************************************
!
!     Initialization --
!                       define integration independent variable X
!                       evaluate initial derivatives
!                       set up working arrays for integration variables
!                       set counter for function evaluations,NFE
!                       estimate starting stepsize
!
x = t
endpnt = .false.
blkout = .false.
!
a = t
call fcn (a, y, yp)
nfe = 1
do n = 1, neqn
   w(n) = y(n)
   wp(n) = yp(n)
end do
!
!     Compute initial steplength.
!
dt = tout - t
if (dt .eq. 0.0) dt = tend - t
h = abs(dt)
toln = 0.0
do 90 k = 1, neqn
   tol = relerr*abs(y(k)) + abserr
   if (tol .le. 0.0) go to 90
   toln = tol
   ypk = abs(yp(k))
   if (ypk*h**5 .gt. tol) h = (tol/ypk)**0.2
90 continue
if (toln .le. 0.0) h = 0.0
h = amax1(h, u26*amax1(abs(t),abs(dt)))
jflag = isign(2,iflag)
h = sign(h,dt)
!
!     Initial steplength now computed. Compute first solution.
!
!***********************************************************************
!
!     To avoid premature underflow in the error tolerance function,
!     scale the error tolerances.
!
100 scale = 2.0/relerr
ae = scale*abserr
!
!     Set safety factor for stepsize adjustment, based on tolerances.
!
toler = amax1(abserr,relerr)
sf = 0.85
if (toler .ge. 1.e-5) sf = 0.8
if (toler .le. 1.e-9) sf = 0.9
!
!     Restore integration variable to end of last block step taken
!     and set the sign of the direction of integration.
!
t = x
dtsign = sign(1.0, tend-t)
!
!     Have we already integrated past the present data output point?
!     If so jump to 390 and perform interpolation.
!     If not, see if we have reached the end point of integration.
!     If not, see if results at the end of the block step need to be
!     reported.
!
if ((tout-t)*dtsign .gt. 0.0) go to 110
   if (tout .eq. t) go to 510
   go to 390
110 if (endpnt) go to 510
if (iflag .ne. -2  .or. .not.blkout) go to 150
   blkout = .false.
   go to 400
!
!***********************************************************************
!***********************************************************************
!     Block BY block integration
!
!     See if we are too close to the end point.  If so, do linear
!     extrapolation and return.
!
150 if (abs(tend-t) .gt. u26*abs(t)) go to 190
if (dtsign*(tend-tout) .le. 0.0) go to 160
   dt = tout - t
   endpnt = .false.
   t = tout
   go to 170
160 dt = tend - t
endpnt = .true.
t = tend
x = tend
!
170 do k = 1, neqn
   y(k) = w(k) + dt*wp(k)
end do
call fcn (t, y, yp)
nfe = nfe + 1
iflag = 2
if (.not.endpnt) return
!
do n = 1,neqn
   w(n) = y(n)
   wp(n) = yp(n)
end do
endpnt = .false.
return
!
!     Set smallest allowable stepsize and step failure flag.
!     Adjust stepsize if necessary to hit the end point of integration.
!
190 hmin = u26*abs(t)
hfaild = .false.
hstop = 0.5*(tend-t)
if (abs(hstop) .gt. abs(h)) go to 200
endpnt = .true.
h = hstop
!
!***********************************************************************
!     Core integrator for a single block
!***********************************************************************
!     The tolerances have been scaled to avoid premature underflow in
!     computing the error tolerance function ERRTOL.
!     To avoid problems with zero crossings,relative error is measured
!     using the average of the magnitudes of the solution at the
!     beginning and end  points of a block.
!     To distinguish the various arguments, H is not permitted
!     to become smaller than 26 units of roundoff in T.
!     Practical limits on the change in the stepsize are enforced to
!     smooth the stepsize selection process and to avoid excessive
!     chattering on problems having discontinuities.
!***********************************************************************
!
!     Test number of derivative function evaluations.
!     If okay,try to advance the integration from T to T+H
!
200 if (nfe .gt. maxnfe) go to 530
!
!     Advance an approximate solution over one step of length H
!
do n = 1, neqn
   y1(n) = w(n) + a21*h*wp(n)
end do
call fcn (t + c2*h, y1, f2)
do n = 1, neqn
   y1(n) = w(n) + h*(a31*wp(n) + a32*f2(n))
end do
call fcn (t + c3*h, y1, f3)
do n = 1, neqn
   y1(n) = w(n) + h*(a41*wp(n) + a42*f2(n) + a43*f3(n))
end do
call fcn (t + c4*h, y1, f4)
do n = 1, neqn
   y1(n) = w(n) + h*(a51*wp(n)+a52*f2(n)+a53*f3(n)+a54*f4(n))
end do
call fcn (t + h, y1, y)
do n = 1, neqn
   y1(n) = w(n) + h*(a61*wp(n)+a62*f2(n)+a63*f3(n)+a64*f4(n)+ &
&a65*y(n))
end do
call fcn (t + c6*h, y1, yp)
nfe = nfe + 5
eeoet = 0.0
do n = 1, neqn
   y1(n) = w(n) + h*(b1b*wp(n)+b3b*f3(n)+b4b*f4(n)+b5b*y(n)+ &
&b6b*yp(n))
   errtol = abs(w(n)) + abs(y1(n)) + ae
   if (errtol .le. 0.0) go to 540
   ez = abs(h*(erc11*wp(n)+erc13*f3(n)+erc14*f4(n)+erc15*y(n)+ &
&b6b*yp(n)))
   eeoet = amax1(eeoet,ez/errtol)
end do
esttol = eeoet*scale
!
!     Check the error estimate. If steplength has failed for first step
!     in the block, go and compute a smaller step for A RE-try.
!
if (esttol .gt. 1.0) go to 320
!
!     Integration successful for first step.  Now integrate over
!     the second step in the block
!
call fcn (t + h, y1, f1)
do n = 1, neqn
   y2(n) = w(n) + h*(a81*wp(n)+a82*f2(n)+a83*f3(n)+a84*f4(n)+ &
&a85*y(n)+a86*yp(n)+a87*f1(n))
end do
call fcn (t + c8*h, y2, f7)
do n = 1, neqn
   y2(n) = w(n) + h*(a91*wp(n)+a92*f2(n)+a93*f3(n)+a94*f4(n)+ &
&a95*y(n)+a96*yp(n)+a97*f1(n)+a98*f7(n))
end do
call fcn (t + c9*h, y2, f2)
nfe = nfe + 3
eeoet = 0.0
do n = 1, neqn
   ee = abs(h*(erc21*wp(n)+erc23*f3(n)+erc24*f4(n)+erc25*y(n)+ &
&erc26*yp(n)+erc27*f1(n)+erc28*f7(n)+erc29*f2(n)))
   y2(n) = w(n)+h*(b1*wp(n)+b3*f3(n)+b4*f4(n)+b5*y(n)+b6*yp(n)+ &
&b7*f1(n)+b8*f7(n)+b9*f2(n))
   errtol = abs(y2(n)) + abs(y1(n)) + ae
   if (errtol .le. 0.0) go to 540
   eeoet = amax1(eeoet,ee/errtol)
end do
esttol = eeoet*scale
!
!     The first of the three changes needed to make the interpolant
!     derivative more stable is the following do-loop.
!
do n = 1, neqn
   y1(n) = b1b*wp(n)+b3b*f3(n)+b4b*f4(n)+b5b*y(n)+ &
&b6b*yp(n)
   f3(n) = b1*wp(n)+b3*f3(n)+b4*f4(n)+b5*y(n)+b6*yp(n)+ &
&b7*f1(n)+b8*f7(n)+b9*f2(n)
end do
!
!     Check the error estimate over the second step of the block.
!
if (esttol .le. 1.0) go to 330
!
!     Unsuccessful block
!     reduce the stepsize , try again
!     the decrease is limited to a factor of about 1/10
!
320 hfaild = .true.
s = 0.1
endpnt = .false.
if (esttol .lt. 1.0e+5) s = sf/esttol**0.2
h = s*h
if (abs(h) .lt. hmin) go to 550
go to 200
!
!     Successful block. Check for need to interpolate.
!     Store solution at T+2*H.
!
330 t = t + 2.0*h
if (endpnt) t = tend
told = x
x = t
hint = h
interp = .false.
if ((t-tout)*dtsign .ge. 0.0) interp = .true.
!
if (interp) go to 350
   do n = 1,neqn
      w(n) = y2(n)
   end do
   go to 360
!
350 do n = 1,neqn
   swap = w(n)
   w(n) = y2(n)
   y2(n) = swap
   f2(n) = wp(n)
end do
!
360 a = t
call fcn (a, w, wp)
nfe = nfe + 1
!
!     Choose next stepsize
!     the increase is limited to a factor of about 10
!     if step failure has just occured, next step is not allowed
!     to increase.
!
s = 10.0
if (esttol .gt. 1.e-5) s = sf/esttol**0.2
if (hfaild) s = amin1(s,1.0)
h = sign(amax1(s*abs(h),hmin), h)
!
!     Have we integrated past an output point?
!     IF SO, CALL THE INTERPOLATION ROUTINE AT T=TOUT.
!     If not, see if we are at the end point of integration.
!     Otherwise, check if user wants solutions at the end of the block
!     step, or else continue the integration.
!
if (interp) go to 390
if (endpnt) go to 510
if (iflag .gt. 0) go to 150
iflag = -2
go to 400
!
!     Interpolate to get data at off-step point and return.
!
!     The second of the three changes needed to make the interpolant
!     derivative more stable is the new statement 390 given below.
!
390 call extra (neqn,f3,wp,x,hint,y1,y2,f1,f2,tout,y,yp)
t = tout
if (iflag .lt. 0 .and. tout .ne. x) blkout = .true.
iflag = 2
return
!
!     RETURN WITH THE SOLUTION AT THE END OF THE LAST SUCCESSFUL
!     block step.
!
400 do n = 1,neqn
   y(n) = w(n)
   yp(n) = wp(n)
end do
return
!
!     Invalid input, return
!
500 iflag = 7
return
!
!     We have reached the endpoint
!
510 iflag = 2
endpnt = .false.
go to 400
!
!     Relative error tolerance too small
!
520 relerr = rer
iflag = 3
kflag = 3
return
!
!     Too much work
!
530 iflag = 4
kflag = 4
go to 400
!
!     Inappropriate error tolerance
!
540 iflag = 5
kflag = 5
go to 400
!
!     Requested error unattainable at smallest allowable stepsize
!
550 iflag = 6
kflag = 6
go to 400
end subroutine rkfc

subroutine extra (neqn,yinc2,f2,t,h,yinc1,y,f1,f,tex,yex,ypex)
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
!     THIS VERSION OF EXTRA IS THE THIRD OF THE THREE CHANGES
!     NEEDED TO MAKE THE INTERPOLANT DERIVATIVE MORE STABLE.
!
!     T is the independent variable.
!     Y is the value at T-2H. The values at T-H and T are
!     Y + H*YINC1 and Y + H*YINC2 respectively.
!     F,F1 and F2 are the derivatives at T-2H, T-H and T.
!     Tex is the point where the output is required.
!     YEX will hold the approximate solution at tex and YPEX will
!     hold the derivative approximation at this point.
!
!
!     Perform quintic interpolation based on the values
!     Y(N),Y(N)+H*YINC1(N),Y(N)+H*YINC2(N),F(N),F1(N),F2(N) at the
!     points T-2H, T-H, T.  This polynomial is evaluated at the point
!     tex to obtain the approximate value of Y(TEX) and this is stored
!     in the array YEX.  The derivative of the interpolating polynomial
!     is also evaluated at tex to obtain an approximation to DY/DT
!     at this point and this approximation is stored in YPEX.
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
&a3)*(sig - 1.0) + a4)*sig + hf)*sig + y(n)
   ypex(n) = ((((0.625*a1*sig + (a2 - 2.0*a1))*sig + (1.875*a1 - &
&1.5*a2 + 3.0*a3))*sig + (0.5*(a2 - a1) - &
&2.0*(a3 - a4)))*sig + hf)/h
end do
return
end subroutine extra

subroutine rkf45 (f,neqn,y,t,tout,relerr,abserr,iflag,work,iwork)
implicit none
!
!     Fehlberg fourth-fifth order Runge-Kutta method
!
!     WRITTEN BY H.A.WATTS AND L.F.SHAMPINE
!                   SANDIA LABORATORIES
!                  ALBUQUERQUE,NEW MEXICO
!
!    RKF45 is primarily designed to solve non-stiff and mildly stiff
!    differential equations when derivative evaluations are inexpensive.
!    RKF45 should generally not be used when the user is demanding
!    high accuracy.
!
! Abstract
!
!    Subroutine  RKF45  integrates a system of NEQN first order
!    ordinary differential equations of the form
!             DY(I)/DT = F(T,Y(1),Y(2),...,Y(NEQN))
!              where the Y(I) are given at T .
!    Typically the subroutine is used to integrate from T to tout but it
!    can be used as a one-step integrator to advance the solution A
!    single step in the direction of tout.  On return the parameters in
!    the call list are set for continuing the integration. The user has
!    only to call RKF45 again (and perhaps define a new value for tout).
!    Actually, RKF45 is an interfacing routine which calls subroutine
!    RKFS for the solution.  RKFS in turn calls subroutine  FEHL which
!    computes an approximate solution over one step.
!
!    RKF45  USES THE RUNGE-KUTTA-FEHLBERG (4,5)  METHOD DESCRIBED
!    IN THE REFERENCE
!    E.FEHLBERG , LOW-ORDER CLASSICAL RUNGE-KUTTA FORMULAS WITH STEPSIZE
!                 CONTROL , NASA TR R-315
!
!    The parameters represent-
!      F -- SUBROUTINE F(T,Y,YP) TO EVALUATE DERIVATIVES YP(I)=DY(I)/DT
!      NEQN -- number of equations to be integrated
!      Y(*) -- solution vector at T
!      T -- independent variable
!      tout -- output point at which solution is desired
!      RELERR,ABSERR -- relative and absolute error tolerances for local
!            error test. At each step the code requires that
!                 ABS(LOCAL ERROR) .LE. RELERR*ABS(Y) + ABSERR
!            for each component of the local error and solution vectors
!      IFLAG -- indicator for status of integration
!      WORK(*) -- array to hold information internal to RKF45 which is
!            necessary for subsequent calls. Must be dimensioned
!            at least  3+6*NEQN
!      IWORK(*) -- integer array used to hold information internal to
!            RKF45 which is necessary for subsequent calls. Must be
!            dimensioned at least  5
!
!  First call to RKF45
!
!    The user must provide storage in his calling program for the arrays
!    IN THE CALL LIST  -      Y(NEQN) , WORK(3+6*NEQN) , IWORK(5)  ,
!    declare F in an external statement, supply subroutine F(T,Y,YP) and
!    initialize the following parameters-
!
!      NEQN -- NUMBER OF EQUATIONS TO BE INTEGRATED.  (NEQN .GE. 1)
!      Y(*) -- vector of initial conditions
!      T -- starting point of integration , must be a variable
!      tout -- output point at which solution is desired.
!            T=TOUT IS ALLOWED ON THE FIRST CALL ONLY, IN WHICH CASE
!            RKF45 RETURNS WITH IFLAG=2 IF CONTINUATION IS POSSIBLE.
!      RELERR,ABSERR -- relative and absolute local error tolerances
!            which must be non-negative. RELERR must be a variable while
!            ABSERR may be a constant. The code should normally not be
!            used with relative error control smaller than about 1.E-8 .
!            To avoid limiting precision difficulties the code requires
!            RELERR to be larger than an internally computed relative
!            error parameter which is machine dependent. In particular,
!            pure absolute error is not permitted. If a smaller than
!            allowable value of RELERR is attempted, RKF45 increases
!            RELERR appropriately and returns control to the user before
!            continuing the integration.
!      IFLAG -- +1,-1  indicator to initialize the code for each new
!            PROBLEM. NORMAL INPUT IS +1. THE USER SHOULD SET IFLAG=-1
!            only when one-step integrator control is essential. In this
!            case, RKF45 attempts to advance the solution a single step
!            in the direction of tout each time it is called. Since this
!            mode of operation results in extra computing overhead, it
!            should be avoided unless needed.
!
!  Output from RKF45
!
!      Y(*) -- solution at T
!      T -- last point reached in integration.
!      IFLAG = 2 -- INTEGRATION REACHED TOUT.
!            =-2 -- A SINGLE SUCCESSFUL STEP IN THE DIRECTION OF TOUT
!                   has been taken. Normal mode for continuing
!                   integration one step at a time.
!            = 3 -- INTEGRATION WAS NOT COMPLETED BECAUSE RELATIVE ERROR
!                   tolerance was too small. RELERR has been increased
!                   appropriately for continuing.
!            = 4 -- INTEGRATION WAS NOT COMPLETED BECAUSE MORE THAN
!                   3000 derivative evaluations were needed. This
!                   is approximately 500 steps.
!            = 5 -- INTEGRATION WAS NOT COMPLETED BECAUSE SOLUTION
!                   vanished making a pure relative error test
!                   impossible. Must use non-zero ABSERR to continue.
!                   Using the one-step integration mode for one step
!                   is a good way to proceed.
!            = 6 -- INTEGRATION WAS NOT COMPLETED BECAUSE REQUESTED
!                   accuracy could not be achieved using smallest
!                   allowable stepsize. User must increase the error
!                   tolerance before continued integration can be
!                   attempted.
!            = 7 -- IT IS LIKELY THAT RKF45 IS INEFFICIENT FOR SOLVING
!                   this problem. Too much output is restricting the
!                   natural stepsize choice. Use the one-step integrator
!                   mode.
!            = 8 -- INVALID INPUT PARAMETERS
!                   this indicator occurs if any of the following is
!                   SATISFIED -   NEQN .LE. 0
!                                 T=TOUT  AND  IFLAG .NE. +1 OR -1
!                                 RELERR OR ABSERR .LT. 0.
!                                 IFLAG .EQ. 0  OR  .LT. -2  OR  .GT. 8
!      WORK(*),IWORK(*) -- information which is usually of no interest
!                   to the user but necessary for subsequent calls.
!                   WORK(1),...,WORK(NEQN) contain the first derivatives
!                   of the solution vector Y at T. WORK(NEQN+1) contains
!                   the stepsize H to be attempted on the next step.
!                   IWORK(1) contains the derivative evaluation counter.
!
!  Subsequent calls to RKF45
!
!    Subroutine RKF45 returns with all information needed to continue
!    integration. If the integration reached tout, the user need only
!    define a new tout and call RKF45 again. In the one-step integrator
!    MODE (IFLAG=-2) THE USER MUST KEEP IN MIND THAT EACH STEP TAKEN IS
!    in the direction of the current tout. Upon reaching tout (indicated
!    by changing IFLAG to 2),the user must then define a new tout and
!    reset IFLAG to -2 to continue in the one-step integrator mode.
!
!    If the integration was not completed but the user still wants to
!    CONTINUE (IFLAG=3,4 CASES), HE JUST CALLS RKF45 AGAIN. WITH IFLAG=3
!    the RELERR parameter HAS been adjusted appropriately for continuing
!    THE INTEGRATION. IN THE CASE OF IFLAG=4 THE FUNCTION COUNTER WILL
!    be reset to 0 and another 3000 function evaluations are allowed.
!
!    HOWEVER,IN THE CASE IFLAG=5, THE USER MUST FIRST ALTER THE ERROR
!    criterion to use a positive value of ABSERR before integration can
!    proceed. If he does not,execution is terminated.
!
!    ALSO,IN THE CASE IFLAG=6, IT IS NECESSARY FOR THE USER TO RESET
!    IFLAG to 2 (or -2 when the one-step integration mode is being used)
!    as well as increasing either ABSERR,RELERR or both before the
!    integration can be continued. If this is not done, execution will
!    BE TERMINATED. THE OCCURRENCE OF IFLAG=6 INDICATES A TROUBLE SPOT
!    (solution is changing rapidly,singularity may be present) and it
!    often is inadvisable to continue.
!
!    IF IFLAG=7 IS ENCOUNTERED, THE USER SHOULD USE THE ONE-STEP MODE
!    or switch to another routine. If the user insists upon continuing
!    the integration with RKF45, then he must reset IFLAG to 2 or -2
!    before recalling RKF45. Otherwise, execution will be terminated.
!
!    IF IFLAG=8 IS OBTAINED, INTEGRATION CANNOT BE CONTINUED UNLESS
!    the invalid input parameters are corrected.
!
!    It should be noted that the arrays work,IWORK contain information
!    required for subsequent integration. Accordingly, work and IWORK
!    should not be altered.
!
integer, intent(in) :: neqn
integer, intent(inout) :: iflag, iwork(5)
real, intent(inout) :: y(neqn), t
real, intent(in) :: tout
real, intent(inout) :: relerr
real, intent(in) :: abserr
real, intent(inout) :: work(*)
!
external f
!
integer :: k1, k2, k3, k4, k5, k6, k1m
!
!     Compute indices for the splitting of the work array
!
k1m=neqn+1
k1=k1m+1
k2=k1+neqn
k3=k2+neqn
k4=k3+neqn
k5=k4+neqn
k6=k5+neqn
!
!     This interfacing routine merely relieves the user of a long
!     calling list via the splitting apart of two working storage
!     arrays. If this is not compatible with the users compiler,
!     he must use RKFS directly.
!
call rkfs(f,neqn,y,t,tout,relerr,abserr,iflag,work(1),work(k1m), &
&work(k1),work(k2),work(k3),work(k4),work(k5),work(k6), &
&work(k6+1),iwork(1),iwork(2),iwork(3),iwork(4),iwork(5))
!
return
end subroutine rkf45

subroutine rkfs(f,neqn,y,t,tout,relerr,abserr,iflag,yp,h,f1,f2,f3, &
&f4,f5,savre,savae,nfe,kop,init,jflag,kflag)
implicit none
!
!
!     RKFS integrates a system of first order ordinary differential
!     equations as described in the comments for RKF45 .
!     The arrays YP,F1,F2,F3,F4,and F5 (of dimension at least NEQN) and
!     the variables H,SAVRE,SAVAE,NFE,kop,init,JFLAG,and KFLAG are used
!     internally by the code and appear in the call list to eliminate
!     local retention of variables between calls. Accordingly, they
!     should not be altered. Items of possible interest are
!         YP - derivative of solution vector at T
!         H  - an appropriate stepsize to be used for the next step
!         NFE- counter on the number of derivative function evaluations
!
logical :: hfaild, output
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
!
external f
!
real :: a, ae, dt, ee, eeoet, esttol, et, hmin, remin, rer, s, &
&scale, tol, toln, u26, eps, ypk, spmpar
!
integer :: k, maxnfe, mflag
!
!     REMIN is the minimum acceptable value of RELERR.  Attempts
!     to obtain higher accuracy with this subroutine are usually
!     very expensive and often unsuccessful.
!
data remin/1.e-12/
!
!     The expense is controlled by restricting the number
!     of function evaluations to be approximately MAXNFE.
!     As set, this corresponds to about 500 steps.
!
data maxnfe/3000/
!
!     Check input parameters
!
if (neqn .lt. 1) go to 10
if (relerr .lt. 0.0 .or. abserr .lt. 0.0) go to 10
mflag = iabs(iflag)
if (mflag .eq. 0 .or. mflag .gt. 8) go to 10
!
!     Compute the relative machine precision
!
eps = spmpar(1)
u26 = 26.0*eps
if (mflag .ne. 1) go to 20
go to 50
!
!     Invalid input
!
10 iflag = 8
return
!
!     Check continuation possibilities
!
20 if (t .eq. tout .and. kflag .ne. 3) go to 10
if (mflag .ne. 2) go to 25
!
!     IFLAG = +2 OR -2
!
if (kflag .eq. 3) go to 45
if (init .eq. 0) go to 45
if (kflag .eq. 4) go to 40
if ((kflag .eq. 5)  .and.  (abserr .eq. 0.0)) go to 30
if ((kflag .eq. 6)  .and.  (relerr .le. savre)  .and. &
&(abserr .le. savae)) go to 30
go to 50
!
!     IFLAG = 3,4,5,6,7 OR 8
!
25 if (iflag .eq. 3) go to 45
if (iflag .eq. 4) go to 40
if (iflag .eq. 5 .and. abserr .gt. 0.0) go to 45
!
!     Integration cannot be continued since user did not respond to
!     THE INSTRUCTIONS PERTAINING TO IFLAG=5,6,7 OR 8
!
30 stop
!
!     Reset function evaluation counter
!
40 nfe = 0
if (mflag .eq. 2) go to 50
!
!     Reset flag VALUE from previous call
!
45 iflag = jflag
if (kflag .eq. 3) mflag = iabs(iflag)
!
!     Save input IFLAG and set continuation flag VALUE for subsequent
!     input checking
!
50 jflag = iflag
kflag = 0
!
!     Save RELERR and ABSERR for checking input on subsequent calls
!
savre = relerr
savae = abserr
!
!     Restrict relative error tolerance to be at least as large as
!     2*eps+REMIN to avoid limiting precision difficulties arising
!     from impossible accuracy requests
!
rer = 2.0*eps + remin
if (relerr .ge. rer) go to 55
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
if (mflag .eq. 1) go to 60
if (init .eq. 0) go to 65
go to 80
!
!     Initialization --
!                       set initialization completion indicator,init
!                       set indicator for too many output points,kop
!                       evaluate initial derivatives
!                       set counter for function evaluations,NFE
!                       estimate starting stepsize
!
60 init = 0
kop = 0
!
a = t
call f(a,y,yp)
nfe = 1
if (t .ne. tout) go to 65
iflag = 2
return
!
65 init = 1
h = abs(dt)
toln = 0.0
do 70 k = 1,neqn
   tol = relerr*abs(y(k)) + abserr
   if (tol .le. 0.) go to 70
   toln = tol
   ypk = abs(yp(k))
   if (ypk*h**5 .gt. tol) h=(tol/ypk)**0.2
70 continue
if (toln .le. 0.0) h=0.0
h = amax1(h,u26*amax1(abs(t),abs(dt)))
jflag = isign(2,iflag)
!
!     Set stepsize for integration in the direction from T to tout
!
80 h = sign(h,dt)
!
!     Test to see if RKF45 is being severely impacted by too many
!     output points
!
if (abs(h) .ge. 2.0*abs(dt)) kop = kop + 1
if (kop .ne. 100) go to 85
!
!     Unnecessary frequency of output
kop = 0
iflag = 7
return
!
85 if (abs(dt) .gt. u26*abs(t)) go to 95
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
if (abs(dt) .ge. 2.0*abs(h)) go to 200
if (abs(dt) .gt. abs(h)) go to 150
!
!     The next successful step will complete the integration to the
!     output point
!
output = .true.
h = dt
go to 200
!
150 h=0.5*dt
!
!
!     Core integrator for taking a single step
!
!     The tolerances have been scaled to avoid premature underflow in
!     computing the error tolerance function ET.
!     To avoid problems with zero crossings,relative error is measured
!     using the average of the magnitudes of the solution at the
!     beginning and end of a step.
!     The error estimate formula has been grouped to control loss of
!     significance.
!     To distinguish the various arguments, H is not permitted
!     to become smaller than 26 units of roundoff in T.
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
!     If okay,try to advance the integration from T to T+H
!
200 if (nfe .le. maxnfe) go to 220
!
!     Too much work
!
iflag = 4
kflag = 4
return
!
!     Advance an approximate solution over one step of length H
!
220 call fehl (f,neqn,y,t,h,yp,f1,f2,f3,f4,f5,f1)
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
   if (et .gt. 0.0) go to 240
!
!        Inappropriate error tolerance
!
   iflag = 5
   return
!
240 ee = abs((-2090.0*yp(k)+(21970.0*f3(k)-15048.0*f4(k)))+ &
&(22528.0*f2(k)-27360.0*f5(k)))
250 eeoet = amax1(eeoet,ee/et)
!
esttol = abs(h)*eeoet*scale/752400.0
if (esttol .le. 1.0) go to 260
!
!     Unsuccessful step
!                       reduce the stepsize , try again
!                       the decrease is limited to a factor of 1/10
!
hfaild = .true.
output = .false.
s = 0.1
if (esttol .lt. 59049.0) s = 0.9/esttol**0.2
h = s*h
if (abs(h) .gt. hmin) go to 200
!
!     Requested error unattainable at smallest allowable stepsize
!
iflag = 6
kflag = 6
return
!
!     Successful step
!                        store solution at T+H
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
s=5.0
if (esttol .gt. 1.889568e-4) s=0.9/esttol**0.2
if (hfaild) s=amin1(s,1.0)
h=sign(amax1(s*abs(h),hmin),h)
!
!     END OF CORE INTEGRATOR
!
!
!     Should we take another step
!
if (output) go to 300
if (iflag .gt. 0) go to 100
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
!    FEHL integrates a system of NEQN first order
!    ordinary differential equations of the form
!             DY(I)/DT=F(T,Y(1),---,Y(NEQN))
!    where the initial values Y(I) and the initial derivatives
!    YP(I) are specified at the starting point T. FEHL advances
!    the solution over the fixed step H and returns
!    the fifth order (sixth order accurate locally) solution
!    approximation at T+H in array S(I).
!    F1,---,F5 are arrays of dimension NEQN which are needed
!    for internal storage.
!    The formulas have been grouped to control loss of significance.
!    FEHL should be called with an H not smaller than 13 units of
!    roundoff in T so that the various independent arguments can be
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
!
real :: ch
integer :: k
external f
!
ch=h/4.0
do 221 k = 1,neqn
221 f5(k)=y(k)+ch*yp(k)
call f(t+ch,f5,f1)
!
ch=3.0*h/32.0
do 222 k = 1,neqn
222 f5(k)=y(k)+ch*(yp(k)+3.0*f1(k))
call f(t+3.0*h/8.0,f5,f2)
!
ch=h/2197.0
do 223 k = 1,neqn
223 f5(k)=y(k)+ch*(1932.0*yp(k)+(7296.0*f2(k)-7200.0*f1(k)))
call f(t+12.0*h/13.0,f5,f3)
!
ch=h/4104.0
do 224 k = 1,neqn
224 f5(k)=y(k)+ch*((8341.0*yp(k)-845.0*f3(k))+ &
&(29440.0*f2(k)-32832.0*f1(k)))
call f(t+h,f5,f4)
!
ch=h/20520.0
do 225 k = 1,neqn
225 f1(k)=y(k)+ch*((-6080.0*yp(k)+(9295.0*f3(k)- &
&5643.0*f4(k)))+(41040.0*f1(k)-28352.0*f2(k)))
call f(t+h/2.0,f1,f5)
!
!     Compute approximate solution at T+H
!
ch=h/7618050.0
do 230 k = 1,neqn
230 s(k)=y(k)+ch*((902880.0*yp(k)+(3855735.0*f3(k)- &
&1371249.0*f4(k)))+(3953664.0*f2(k)+ &
&277020.0*f5(k)))
!
return
end subroutine fehl

subroutine gerk(f,neqn,y,t,tout,relerr,abserr,iflag,gerror, &
&work,iwork)
implicit none
integer, intent(inout) :: iflag, iwork(5)
integer, intent(in) :: neqn
real, intent(in) :: abserr
real, intent(inout) :: gerror(neqn)
real, intent(in) :: relerr
real, intent(inout) :: t
real, intent(in) :: tout
real, intent(inout) :: work(*), y(neqn)
integer :: k1, k1m, k2, k3, k4, k5, k6, k7, k8
!
!     Fehlberg FOURTH(FIFTH) order Runge-Kutta method with
!     global error assessment
!
!     WRITTEN BY H.A.WATTS AND L.F.SHAMPINE
!                   SANDIA LABORATORIES
!
!    GERK is designed to solve systems of differential equations when
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
!    Subroutine  GERK  integrates a system of NEQN first order
!    ordinary differential equations of the form
!             DY(I)/DT = F(T,Y(1),Y(2),...,Y(NEQN))
!              where the Y(I) are given at T .
!    Typically the subroutine is used to integrate from T to tout but it
!    can be used as a one-step integrator to advance the solution A
!    single step in the direction of tout. On return,an estimate of the
!    global error in the solution at T is provided and the parameters in
!    the call list are set for continuing the integration. The user has
!    only to call GERK again (and perhaps define a new value for tout).
!    Actually, GERK  is merely an interfacing routine which allocates
!    virtual storage in the arrays work,IWORK and calls subroutine GERKS
!    for the solution.  GERKS  in turn calls subroutine  FEHL  which
!    computes an approximate solution over one step.
!
!    GERK  USES THE RUNGE-KUTTA-FEHLBERG (4,5)  METHOD DESCRIBED
!    IN THE REFERENCE
!    E.FEHLBERG , LOW-ORDER CLASSICAL RUNGE-KUTTA FORMULAS WITH STEPSIZE
!                 CONTROL , NASA TR R-315
!
!
!    The parameters represent-
!      F -- SUBROUTINE F(T,Y,YP) TO EVALUATE DERIVATIVES YP(I)=DY(I)/DT
!      NEQN -- number of equations to be integrated
!      Y(*) -- solution vector at T
!      T -- independent variable
!      tout -- output point at which solution is desired
!      RELERR,ABSERR -- relative and absolute error tolerances for local
!            error test. At each step the code requires that
!                 ABS(LOCAL ERROR) .LE. RELERR*ABS(Y) + ABSERR
!            for each component of the local error and solution vectors
!      IFLAG -- indicator for status of integration
!      GERROR(*) -- vector which estimates the global error at T. That
!                   is, GERROR(I) approximates  Y(I)-true SOLUTION(I).
!      WORK(*) -- array to hold information internal to GERK which is
!            necessary for subsequent calls. Must be dimensioned
!            at least  3+8*NEQN.
!      IWORK(*) -- integer array used to hold information internal to
!            GERK which is necessary for subsequent calls. Must be
!            dimensioned at least  5.
!
!
!***********************************************************************
!  First call to GERK
!***********************************************************************
!
!    The user must provide storage in his calling program for the arrays
!    IN THE CALL LIST  -      Y(NEQN) , WORK(3+8*NEQN) , IWORK(5)  ,
!    declare F in an external statement, supply subroutine F(T,Y,YP) and
!    initialize the following parameters-
!
!      NEQN -- NUMBER OF EQUATIONS TO BE INTEGRATED.  (NEQN .GE. 1)
!      Y(*) -- vector of initial conditions
!      T -- starting point of integration , must be a variable
!      tout -- output point at which solution is desired.
!            T=TOUT IS ALLOWED ON THE FIRST CALL ONLY,IN WHICH CASE GERK
!            RETURNS WITH IFLAG=2 IF CONTINUATION IS POSSIBLE.
!      RELERR,ABSERR -- relative and absolute local error tolerances
!            which must be non-negative but may be constants. We can
!            usually expect the global errors to be somewhat smaller
!            than the requested local error tolerances. To avoid
!            limiting precision difficulties the code always uses the
!            larger of RELERR and an internal relative error parameter
!            which is machine dependent.
!      IFLAG -- +1,-1  indicator to initialize the code for each new
!            PROBLEM. NORMAL INPUT IS +1. THE USER SHOULD SET IFLAG=-1
!            only when one-step integrator control is essential. In this
!            case, GERK attempts to advance the solution a single step
!            in the direction of tout each time it is called. Since this
!            mode of operation results in extra computing overhead, it
!            should be avoided unless needed.
!
!
!***********************************************************************
!  Output from GERK
!***********************************************************************
!
!      Y(*) -- solution at T
!      T -- last point reached in integration.
!      IFLAG = 2 -- INTEGRATION REACHED TOUT.INDICATES SUCCESSFUL RETURN
!                   and is the normal mode for continuing integration.
!            =-2 -- A SINGLE SUCCESSFUL STEP IN THE DIRECTION OF TOUT
!                   has been taken. Normal mode for continuing
!                   integration one step at a time.
!            = 3 -- INTEGRATION WAS NOT COMPLETED BECAUSE MORE THAN
!                   9000 derivative evaluations were needed. This
!                   is approximately 500 steps.
!            = 4 -- INTEGRATION WAS NOT COMPLETED BECAUSE SOLUTION
!                   vanished making a pure relative error test
!                   impossible. Must use non-zero ABSERR to continue.
!                   Using the one-step integration mode for one step
!                   is a good way to proceed.
!            = 5 -- INTEGRATION WAS NOT COMPLETED BECAUSE REQUESTED
!                   accuracy could not be achieved using smallest
!                   allowable stepsize. User must increase the error
!                   tolerance before continued integration can be
!                   attempted.
!            = 6 -- GERK IS BEING USED INEFFICIENTLY IN SOLVING
!                   this problem. Too much output is restricting the
!                   natural stepsize choice. Use the one-step
!                   integrator mode.
!            = 7 -- INVALID INPUT PARAMETERS
!                   this indicator occurs if any of the following is
!                   SATISFIED -   NEQN .LE. 0
!                                 T=TOUT  AND  IFLAG .NE. +1 OR -1
!                                 RELERR OR ABSERR .LT. 0.
!                                 IFLAG .EQ. 0  OR  .LT. -2  OR  .GT. 7
!      GERROR(*) -- estimate of the global error in the solution at T
!      WORK(*),IWORK(*) -- information which is usually of no interest
!                   to the user but necessary for subsequent calls.
!                   WORK(1),...,WORK(NEQN) contain the first derivatives
!                   of the solution vector Y at T. WORK(NEQN+1) contains
!                   the stepsize H to be attempted on the next step.
!                   IWORK(1) contains the derivative evaluation counter.
!
!
!***********************************************************************
!  Subsequent calls to GERK
!***********************************************************************
!
!    Subroutine GERK returns with all information needed to continue the
!    integration. If the integration reached tout,the user need only
!    define a new tout and call GERK again. In the one-step integrator
!    MODE (IFLAG=-2) THE USER MUST KEEP IN MIND THAT EACH STEP TAKEN IS
!    in the direction of the current tout. Upon reaching tout (indicated
!    by changing IFLAG to 2),the user must then define a new tout and
!    reset IFLAG to -2 to continue in the one-step integrator mode.
!
!    If the integration was not completed but the user still wants to
!    CONTINUE (IFLAG=3 CASE), HE JUST CALLS GERK AGAIN. THE FUNCTION
!    counter is then reset to 0 and another 9000 function evaluations
!    are allowed.
!
!    HOWEVER,IN THE CASE IFLAG=4, THE USER MUST FIRST ALTER THE ERROR
!    criterion to use a positive value of ABSERR before integration can
!    proceed. If he does not,execution is terminated.
!
!    ALSO,IN THE CASE IFLAG=5, IT IS NECESSARY FOR THE USER TO RESET
!    IFLAG to 2 (or -2 when the one-step integration mode is being used)
!    as well as increasing either ABSERR,RELERR or both before the
!    integration can be continued. If this is not done, execution will
!    BE TERMINATED. THE OCCURRENCE OF IFLAG=5 INDICATES A TROUBLE SPOT
!    (solution is changing rapidly,singularity may be present) and it
!    often is inadvisable to continue.
!
!    IF IFLAG=6 IS ENCOUNTERED, THE USER SHOULD USE THE ONE-STEP
!    integration mode with the stepsize determined by the code. If the
!    user insists upon continuing the integration with GERK in the
!    interval mode, he must reset IFLAG to 2 before calling GERK again.
!    Otherwise,execution will be terminated.
!
!    IF IFLAG=7 IS OBTAINED, INTEGRATION CAN NOT BE CONTINUED UNLESS
!    the invalid input parameters are corrected.
!
!    It should be noted that the arrays work,IWORK contain information
!    required for subsequent integration. Accordingly, work and IWORK
!    should not be altered.
!
!***********************************************************************
!
!
external f
!
!
!     Compute indices for the splitting of the work array
!
k1m=neqn+1
k1=k1m+1
k2=k1+neqn
k3=k2+neqn
k4=k3+neqn
k5=k4+neqn
k6=k5+neqn
k7=k6+neqn
k8=k7+neqn
!
!***********************************************************************
!     This interfacing routine merely relieves the user of a long
!     calling list via the splitting apart of two working storage
!     arrays. If this is not compatible with the users compiler,
!     he must use GERKS directly.
!***********************************************************************
!
call gerks(f,neqn,y,t,tout,relerr,abserr,iflag,gerror, &
&work(1),work(k1m),work(k1),work(k2),work(k3),work(k4), &
&work(k5),work(k6),work(k7),work(k8),work(k8+1), &
&iwork(1),iwork(2),iwork(3),iwork(4),iwork(5))
!
return
end subroutine gerk

subroutine gerks(f,neqn,y,t,tout,relerr,abserr,iflag,gerror, &
&yp,h,f1,f2,f3,f4,f5,yg,ygp,savre,savae, &
&nfe,kop,init,jflag,kflag)
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
integer :: k, maxnfe, mflag
real :: a, ae, dt, ee, eeoet, esttol, et, hh, hmin, remin, rer, s, &
&scale, tol, toln, ts, u, u26, ypk
real :: spmpar
!
!     Fehlberg FOURTH(FIFTH) order Runge-Kutta method with
!     global error assessment
!
!***********************************************************************
!
!     GERKS integrates a system of first order ordinary differential
!     equations as described in the comments for GERK.  The arrays
!     YP,F1,F2,F3,F4,F5,YG and YGP (of dimension at least NEQN) and
!     the variables H,SAVRE,SAVAE,NFE,kop,init,JFLAG,and KFLAG are used
!     internally by the code and appear in the call list to eliminate
!     local retention of variables between calls. Accordingly, they
!     should not be altered. Items of possible interest are
!         YP - derivative of solution vector at T
!         H  - an appropriate stepsize to be used for the next step
!         NFE- counter on the number of derivative function evaluations
!
!***********************************************************************
!
logical :: hfaild, output
!
!
external f
!
!***********************************************************************
!  The computer unit roundoff error U is the smallest positive value
!  REPRESENTABLE IN THE MACHINE SUCH THAT  1.+ U .GT. 1.
!
u = spmpar(1)
!
!***********************************************************************
!
!  REMIN is a tolerance threshold which is also determined by the
!  integration method. In particular, a fifth order method will
!  generally not be capable of delivering accuracies near limiting
!  precision on computers with long wordlengths.
!
remin = 3.e-11
!
!***********************************************************************
!
!     The expense is controlled by restricting the number
!     of function evaluations to be approximately MAXNFE.
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
if (neqn .lt. 1) go to 10
if ((relerr .lt. 0.)  .or.  (abserr .lt. 0.)) go to 10
mflag=iabs(iflag)
if ((mflag .ge. 1)  .and.  (mflag .le. 7)) go to 20
!
!     Invalid input
10 iflag=7
return
!
!     Is this the first call
20 if (mflag .eq. 1) go to 50
!
!     Check continuation possibilities
!
if (t .eq. tout) go to 10
if (mflag .ne. 2) go to 25
!
!     IFLAG = +2 OR -2
if (init .eq. 0) go to 45
if (kflag .eq. 3) go to 40
if ((kflag .eq. 4)  .and.  (abserr .eq. 0.)) go to 30
if ((kflag .eq. 5)  .and.  (relerr .le. savre)  .and. &
&(abserr .le. savae)) go to 30
go to 50
!
!     IFLAG = 3,4,5,6, OR 7
25 if (iflag .eq. 3) go to 40
if ((iflag .eq. 4) .and. (abserr .gt. 0.)) go to 45
!
!     Integration cannot be continued since user did not respond to
!     THE INSTRUCTIONS PERTAINING TO IFLAG=4,5,6 OR 7
30 stop
!
!***********************************************************************
!
!     Reset function evaluation counter
40 nfe=0
if (mflag .eq. 2) go to 50
!
!     Reset flag VALUE from previous call
45 iflag=jflag
!
!     Save input IFLAG and set continuation flag VALUE for subsequent
!     input checking
50 jflag=iflag
kflag=0
!
!     Save RELERR and ABSERR for checking input on subsequent calls
savre=relerr
savae=abserr
!
!     Restrict relative error tolerance to be at least as large as
!     32U+REMIN to avoid limiting precision difficulties arising from
!     impossible accuracy requests
!
rer=amax1(relerr,32.*u+remin)
!
u26=26.*u
!
dt=tout-t
!
if (mflag .eq. 1) go to 60
if (init .eq. 0) go to 65
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
!                       set counter for function evaluations,NFE
!                       estimate starting stepsize
!
60 init=0
kop=0
!
a=t
call f(a,y,yp)
nfe=1
if (t .ne. tout) go to 65
iflag=2
return
!
!
65 init=1
h=abs(dt)
toln=0.
do 70 k = 1,neqn
  yg(k)=y(k)
  ygp(k)=yp(k)
  tol=rer*abs(y(k))+abserr
  if (tol .le. 0.) go to 70
  toln=tol
  ypk=abs(yp(k))
  if (ypk*h**5 .gt. tol) h=(tol/ypk)**0.2
70 continue
if (toln .le. 0.) h=0.
h=amax1(h,u26*amax1(abs(t),abs(dt)))
!
!
!***********************************************************************
!
!     Set stepsize for integration in the direction from T to tout
!
80 h=sign(h,dt)
!
!     Test to see if GERK is being severely impacted by too many
!     output points
!
if (abs(h) .gt. 2.*abs(dt)) kop=kop+1
if (kop .ne. 100) go to 85
kop=0
iflag=6
return
!
85 if (abs(dt) .gt. u26*abs(t)) go to 95
!
!     If too close to output point,extrapolate and return
!
do 90 k = 1,neqn
  yg(k)=yg(k)+dt*ygp(k)
90 y(k)=y(k)+dt*yp(k)
a=tout
call f(a,yg,ygp)
call f(a,y,yp)
nfe=nfe+2
go to 300
!
!     Initialize output point indicator
!
95 output= .false.
!
!     To avoid premature underflow in the error tolerance function,
!     scale the error tolerances
!
scale=2./rer
ae=scale*abserr
!
!
!***********************************************************************
!***********************************************************************
!     Step by step integration
!
100 hfaild= .false.
!
!     Set smallest allowable stepsize
!
hmin=u26*abs(t)
!
!     Adjust stepsize if necessary to hit the output point.
!     Look ahead two steps to avoid drastic changes in the stepsize
!     and thus lessen the impact of output points on the code.
!
dt=tout-t
if (abs(dt) .ge. 2.*abs(h)) go to 200
if (abs(dt) .gt. abs(h)) go to 150
!
!     The next successful step will complete the integration to the
!     output point
!
output= .true.
h=dt
go to 200
!
150 h=0.5*dt
!
!
!
!***********************************************************************
!     Core integrator for taking a single step
!***********************************************************************
!     The tolerances have been scaled to avoid premature underflow in
!     computing the error tolerance function ET.
!     To avoid problems with zero crossings,relative error is measured
!     using the average of the magnitudes of the solution at the
!     beginning and end of a step.
!     The error estimate formula has been grouped to control loss of
!     significance.
!     To distinguish the various arguments, H is not permitted
!     to become smaller than 26 units of roundoff in T.
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
!     If okay,try to advance the integration from T to T+H
!
200 if (nfe .le. maxnfe) go to 220
!
!     Too much work
iflag=3
kflag=3
return
!
!     Advance an approximate solution over one step of length H
!
220 call fehl(f,neqn,yg,t,h,ygp,f1,f2,f3,f4,f5,f1)
nfe=nfe+5
!
!     Compute and test allowable tolerances versus local error estimates
!     and remove scaling of tolerances. Note that relative error is
!     measured with respect to the average of the magnitudes of the
!     solution at the beginning and end of the step.
!
eeoet=0.
do 250 k = 1,neqn
  et=abs(yg(k))+abs(f1(k))+ae
  if (et .gt. 0.) go to 240
!
!       Inappropriate error tolerance
  iflag=4
  kflag=4
  return
!
240 ee=abs((-2090.*ygp(k)+(21970.*f3(k)-15048.*f4(k)))+ &
&(22528.*f2(k)-27360.*f5(k)))
250 eeoet=amax1(eeoet,ee/et)
!
esttol=abs(h)*eeoet*scale/752400.
!
if (esttol .le. 1.) go to 260
!
!
!     Unsuccessful step
!                       reduce the stepsize , try again
!                       the decrease is limited to a factor of 1/10
!
hfaild= .true.
output= .false.
s=0.1
if (esttol .lt. 59049.) s=0.9/esttol**0.2
h=s*h
if (abs(h) .gt. hmin) go to 200
!
!     Requested error unattainable at smallest allowable stepsize
iflag=5
kflag=5
return
!
!
!     Successful step
!                        store one-step solution YG at T+H
!                        and evaluate derivatives there
!
260 ts=t
t=t+h
do 270 k = 1,neqn
270 yg(k)=f1(k)
a=t
call f(a,yg,ygp)
nfe=nfe+1
!
!                        Now advance the Y solution over two steps of
!                        length H/2 and evaluate derivatives there
!
hh=0.5*h
call fehl(f,neqn,y,ts,hh,yp,f1,f2,f3,f4,f5,y)
ts=ts+hh
a=ts
call f(a,y,yp)
call fehl(f,neqn,y,ts,hh,yp,f1,f2,f3,f4,f5,y)
a=t
call f(a,y,yp)
nfe=nfe+12
!
!
!                       Choose next stepsize
!                       the increase is limited to a factor of 5
!                       if step failure has just occurred, next
!                          stepsize is not allowed to increase
!
s=5.
if (esttol .gt. 1.889568e-4) s=0.9/esttol**0.2
if (hfaild) s=amin1(s,1.)
h=sign(amax1(s*abs(h),hmin),h)
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
if (iflag .gt. 0) go to 100
!
!***********************************************************************
!***********************************************************************
!
!
!     Integration successfully completed
!
!     One-step mode
iflag=-2
go to 400
!
!     Interval mode
300 t=tout
iflag=2
!
400 do 450 k = 1,neqn
450 gerror(k)=(yg(k)-y(k))/31.
!
return
end subroutine gerks

subroutine sfode (f,neq,y,t,tout,info,rerr,aerr,idid, &
&rwork,lrw,iwork,liw,rpar,ipar)
implicit none
integer, intent(inout) :: idid
integer :: liw, lrw, neq
real, intent(inout) :: aerr, rerr, t
real :: tout
!     --------------
external f, zzzjac
real, intent(inout) :: y(neq)
real :: rtol(1), atol(1)
real, intent(inout) :: rwork(lrw)
real :: rpar(*)
integer, intent(inout) :: info(*)
integer :: info1(15)
integer, intent(inout) :: iwork(liw)
integer :: ipar(*)
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
call stfode (f,neq,y,t,tout,info1,rtol,atol,idid, &
&rwork,lrw,iwork,liw,rpar,ipar,zzzjac)
info(1) = info1(1)
rerr = rtol(1)
aerr = atol(1)
return
end subroutine sfode

subroutine sfode1 (f,neq,y,t,tout,info,rtol,atol,idid, &
&rwork,lrw,iwork,liw,rpar,ipar)
implicit none
integer, intent(inout) :: idid
integer :: liw, lrw, neq
real, intent(inout) :: t
real :: tout
!     --------------
external f, zzzjac
real, intent(inout) :: y(neq), rtol(neq), atol(neq), rwork(lrw)
real :: rpar(*)
integer, intent(inout) :: info(*)
integer :: info1(15)
integer, intent(inout) :: iwork(liw)
integer :: ipar(*)
!     --------------
info1(1) = info(1)
info1(2) = 1
info1(3) = info(2)
info1(4) = info(3)
info1(5) = 0
info1(6) = info(4)
!
call stfode (f,neq,y,t,tout,info1,rtol,atol,idid, &
&rwork,lrw,iwork,liw,rpar,ipar,zzzjac)
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

subroutine stfode (f,neq,y,t,tout,info,rtol,atol,idid, &
&rwork,lrw,iwork,liw,rpar,ipar,jac)
implicit none
integer :: idid, info( *), ipar(*), iwork, liw, lrw, neq
real :: atol(*), rpar(*), rtol(*), rwork(lrw), t, tout, y(neq)
integer :: icomi, icomr, idelsn, iinout, ilrw, itstar, iypout, ml, &
&mu
integer :: iacor, iband, ibegin, ier, iewt, iinteg, ijac, init, &
&iowns, iquit, isavf, itol, itstop, iwm, iyh, jstart, kflag, &
&ksteps, l, maxord, meth, miter, n, nfe, nje, nq, nqu, nst
real :: el0, h, hmin, hmxi, hu, rowns, tn, told, uround
!***********************************************************************
!***PURPOSE
!   STFODE solves initial value problems in ordinary differential
!   equations using backward differentiation formulas. It is
!   both variable order (1-5) and variable step.
!***DESCRIPTION
!
!   This is a modification by A. H. Morris (NSWC) of the code
!   DEBDF, designed by  L. F. Shampine and H. A. Watts (1980).
!   DEBDF is documented in
!        SAND79-2374 , DEPAC - design of a user oriented package
!                              of ODE solvers.
!
!   STFODE IS A DRIVER FOR A MODIFICATION OF THE CODE LSODE WRITTEN BY
!             A. C. HINDMARSH
!             LAWRENCE LIVERMORE LABORATORY
!             LIVERMORE, CALIFORNIA 94550
!
!***********************************************************************
!** ABSTRACT **
!**************
!
!   Subroutine STFODE uses the backward differentiation formulas of
!   orders one through five to integrate a system of NEQ first order
!   ordinary differential equations of the form
!                         DU/DX = F(X,U)
!   WHEN THE VECTOR Y(*) OF INITIAL VALUES FOR U(*) AT X=T IS GIVEN.
!   The subroutine integrates from T to tout. It is easy to continue the
!   integration to get results at additional tout. This is the interval
!   mode of operation. It is also easy for the routine to return with
!   the solution at each intermediate step on the way to tout. This is
!   the intermediate-output mode of operation.
!
!   STFODE uses subprograms LSOD1, INTYD, STOD, CFOD, PJAC, SLVS,VNWRMS,
!   HSTART, VNORM, SVCO, RSCO, SPMPAR, and the LINPACK routines SGEFA,
!   SGESL, SGBFA, SGBSL (which also use the BLAS routines SAXPY, SSCAL,
!   ISAMAX and SDOT). The only machine dependent parameters used appear
!   IN SPMPAR.
!
!***********************************************************************
!** DESCRIPTION OF THE ARGUMENTS TO STFODE (AN OVERVIEW) **
!**********************************************************
!
!   The parameters are
!
!      F -- this is the name of a subroutine which you provide to
!             define the differential equations.
!
!      NEQ -- this is the number of (first order) differential
!             equations to be integrated.
!
!      T -- this is a value of the independent variable.
!
!      Y(*) -- this array contains the solution components at T.
!
!      Tout -- this is a point at which a solution is desired.
!
!      INFO(*) -- the BASIC task of the code is to integrate the
!             differential equations from T to tout and return an
!             answer at tout. INFO(*) is an integer array which is used
!             to communicate exactly how you want this task to be
!             carried out.
!
!      RTOL, ATOL -- these quantities represent relative and absolute
!             error tolerances which you provide to indicate how
!             accurately you wish the solution to be computed. You may
!             choose them to be both scalars or else both vectors.
!
!      IDID -- this scalar quantity is an indicator reporting what
!             the code did. You must monitor this integer variable to
!             decide what action to take next.
!
!      RWORK(*), LRW -- RWORK(*) is a real work array of length LRW
!             which provides the code with needed storage space.
!
!      IWORK(*), LIW -- IWORK(*) is an integer work array of length LIW
!             which provides the code with needed storage space.
!
!      Rpar, IPAR -- these are real and integer parameter arrays which
!             you can use for communication between your calling
!             program and the F subroutine (and the JAC subroutine).
!
!      JAC -- this is the name of a subroutine which you may choose to
!             provide for defining the Jacobian matrix of partial
!             DERIVATIVES DF/DU.
!
!  Quantities which are used as input items are
!             NEQ, T, Y(*), tout, INFO(*),
!             RTOL, ATOL, RWORK(1), LRW,
!             IWORK(1), IWORK(2), AND LIW.
!
!  Quantities which may be altered by the code are
!             T, Y(*), INFO(1), RTOL, ATOL,
!             IDID, RWORK(*) AND IWORK(*).
!
!***********************************************************************
!** INPUT -- WHAT TO DO ON THE FIRST CALL TO STFODE **
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
!                               F(X,U,UPRIME,RPAR,IPAR)
!             to define the system of first order differential equations
!             which is to be solved. For the given values of X and the
!             VECTOR  U(*)=(U(1),U(2),...,U(NEQ)) , THE SUBROUTINE MUST
!             evaluate the NEQ components of the system of differential
!             EQUATIONS  DU/DX=F(X,U)  AND STORE THE DERIVATIVES IN THE
!             ARRAY UPRIME(*), THAT IS,  UPRIME(I) = * DU(I)/DX *  FOR
!             EQUATIONS I=1,...,NEQ.
!
!             Subroutine F must not alter X or U(*). You must declare
!             the name F in an external statement in your program that
!             calls STFODE. You must dimension U and UPRIME in F.
!
!             Rpar and IPAR are real and integer parameter arrays which
!             you can use for communication between your calling program
!             and subroutine F. They are not used or altered by STFODE.
!             If you do not need rpar or IPAR, ignore these parameters
!             by treating them as dummy arguments. If you do choose to
!             use them, dimension them in your calling program and in F
!             as arrays of appropriate length.
!
!      NEQ -- set it to the number of differential equations.
!             (NEQ .GE. 1)
!
!      T -- set it to the initial point of the integration.
!             You must use a program variable for T because the code
!             changes its value.
!
!      Y(*) -- set this vector to the initial values of the NEQ solution
!             components at the initial point. You must dimension Y at
!             least NEQ in your calling program.
!
!      Tout -- set it to the first point at which a solution
!             IS DESIRED. YOU CAN TAKE TOUT = T, IN WHICH CASE THE CODE
!             will evaluate the derivative of the solution at T and
!             RETURN. INTEGRATION EITHER FORWARD IN T  (TOUT .GT. T)  OR
!             BACKWARD IN T  (TOUT .LT. T)  IS PERMITTED.
!
!             The code advances the solution from T to tout using
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
!             TSTOP. When you have declared A TSTOP point (see INFO(4)
!             and RWORK(1)), you have told the code not to integrate
!             past TSTOP. In this case any tout beyond TSTOP is invalid
!             input.
!
!      INFO(*) -- use the info array to give the code more details about
!             how you want your problem solved. This array should be
!             dimensioned of length 15 to accomodate other members of
!             DEPAC or possible future extensions, though STFODE uses
!             only the first six entries. You must respond to all of
!             the following items which are arranged as questions. The
!             simplest use of the code corresponds to answering all
!             questions as yes ,I.E. Setting all entries of info to 0.
!
!        INFO(1) -- this parameter enables the code to initialize
!               itself. You must set it to indicate the start of every
!               new problem.
!
!            **** IS THIS THE FIRST CALL FOR THIS PROBLEM ...
!                  YES -- SET INFO(1) = 0
!                   no -- not applicable here.
!                         SEE BELOW FOR CONTINUATION CALLS.  ****
!
!        INFO(2) -- how much accuracy you want of your solution
!               is specified by the error tolerances RTOL and ATOL.
!               The simplest use is to take them both to be scalars.
!               To obtain more flexibility, they can both be vectors.
!               The code must be told your choice.
!
!            **** ARE BOTH ERROR TOLERANCES RTOL, ATOL SCALARS ...
!                  YES -- SET INFO(2) = 0
!                         and input scalars for both RTOL and ATOL
!                   NO -- SET INFO(2) = 1
!                         AND INPUT ARRAYS FOR BOTH RTOL AND ATOL ****
!
!        INFO(3) -- the code integrates from T in the direction
!               of tout by steps. If you wish, it will return the
!               computed solution and derivative at the next
!               intermediate step (the intermediate-output mode) or
!               tout, whichever comes first. This is a good way to
!               proceed if you want to see the behavior of the solution.
!               If you must have solutions at a great many specific
!               tout points, this code will compute them efficiently.
!
!            **** DO YOU WANT THE SOLUTION ONLY AT
!                 tout (and not at the next intermediate step) ...
!                  YES -- SET INFO(3) = 0
!                   NO -- SET INFO(3) = 1 ****
!
!        INFO(4) -- to handle solutions at a great many specific
!               values tout efficiently, this code may integrate past
!               tout and interpolate to obtain the result at tout.
!               Sometimes it is not possible to integrate beyond some
!               point TSTOP because the equation changes there or it is
!               not defined past TSTOP. Then you must tell the code
!               not to go past.
!
!            **** CAN THE INTEGRATION BE CARRIED OUT WITHOUT ANY
!                 restrictions on the independent variable T ...
!                  YES -- SET INFO(4)=0
!                   NO -- SET INFO(4)=1
!                         and define the stopping point TSTOP by
!                         SETTING RWORK(1)=TSTOP ****
!
!        INFO(5) -- to solve stiff problems it is necessary to use the
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
!               sometimes it is not - this depends on your problem.
!
!               If your problem is linear, I.E. Has the form
!               DU/DX = F(X,U) = J(X)*U + G(X)   FOR SOME MATRIX J(X)
!               AND VECTOR G(X), THE JACOBIAN MATRIX  DF/DU = J(X).
!               Since you must provide a subroutine to evaluate F(X,U)
!               analytically, it is little extra trouble to provide
!               subroutine JAC for evaluating J(X) analytically.
!               Furthermore, in such cases, numerical differencing is
!               much more expensive than analytic evaluation.
!
!            **** DO YOU WANT THE CODE TO EVALUATE THE PARTIAL
!                 derivatives automatically by numerical differences ...
!                  YES -- SET INFO(5)=0
!                   NO -- SET INFO(5)=1
!                         and provide subroutine JAC for evaluating the
!                         JACOBIAN MATRIX ****
!
!        INFO(6) -- STFODE will perform much better if the Jacobian
!               matrix is banded and the code is told this. In this
!               case, the storage needed will be greatly reduced,
!               numerical differencing will be performed more cheaply,
!               and a number of important algorithms will execute much
!               faster. The differential equation is said to have
!               half-bandwidths ML (lower) and mu (UPPER) if equation I
!               involves only unknowns Y(J) with
!                              I-ML .LE. J .LE. I+MU
!               FOR ALL I=1,2,...,NEQ. THUS, ML AND MU ARE THE WIDTHS
!               of the lower and upper parts of the band, respectively,
!               with the main diagonal being excluded. If you do not
!               indicate that the equation has a banded Jacobian,
!               THE CODE WORKS WITH A FULL MATRIX OF NEQ**2 ELEMENTS
!               (stored in the conventional way). Computations with
!               banded matrices cost less time and storage than with
!               FULL MATRICES IF  2*ML+MU .LT. NEQ.  IF YOU TELL THE
!               code that the Jacobian matrix HAS a banded structure and
!               you want to provide subroutine JAC to compute the
!               partial derivatives, then you must be careful to store
!               the elements of the Jacobian matrix in the special form
!               indicated in the description of JAC.
!
!            **** DO YOU WANT TO SOLVE THE PROBLEM USING A FULL
!                 (dense) Jacobian matrix (and not a special banded
!                 structure) ...
!                  YES -- SET INFO(6)=0
!                   NO -- SET INFO(6)=1
!                         and provide the lower (ML) and upper (MU)
!                         bandwidths by setting
!                         IWORK(1)=ML
!                         IWORK(2)=MU ****
!
!      RTOL, ATOL -- you must assign relative (RTOL) and absolute (ATOL)
!             error tolerances to tell the code how accurately you want
!             the solution to be computed. They must be defined as
!             program variables because the code may change them. You
!             have two choices --
!                  BOTH RTOL AND ATOL ARE SCALARS. (INFO(2)=0)
!                  BOTH RTOL AND ATOL ARE VECTORS. (INFO(2)=1)
!             in either case all components must be non-negative.
!
!             The tolerances are used by the code in a local error test
!             at each step which requires roughly that
!                     ABS(LOCAL ERROR) .LE. RTOL*ABS(Y)+ATOL
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
!             directly. Roughly speaking, they produce a solution Y(T)
!             which satisfies the differential equations with A
!             RESIDUAL R(T),    DY(T)/DT = F(T,Y(T)) + R(T)   ,
!             and, almost always, R(T) is bounded by the error
!             tolerances. Usually, but not always, the true accuracy of
!             the computed Y is comparable to the error tolerances. This
!             code will usually, but not always, deliver a more accurate
!             solution if you reduce the tolerances and integrate again.
!             By comparing two such solutions you can get a fairly
!             reliable idea of the true error in the solution at the
!             bigger tolerances.
!
!             SETTING ATOL=0. RESULTS IN A PURE RELATIVE ERROR TEST ON
!             THAT COMPONENT. SETTING RTOL=0. RESULTS IN A PURE ABSOLUTE
!             error test on that component. A mixed test with non-zero
!             RTOL and ATOL corresponds roughly to a relative error
!             test when the solution component is much bigger than ATOL
!             and to an absolute error test when the solution component
!             is smaller than the threshold ATOL.
!
!             Proper selection of the absolute error control parameters
!             ATOL  requires you to have some idea of the scale of the
!             solution components. To acquire this information may mean
!             that you will have to solve the problem more than once. In
!             the absence of scale information, you should ask for some
!             relative accuracy in all the components (by setting  RTOL
!             values non-zero) and perhaps impose extremely small
!             absolute error tolerances to protect against the danger of
!             a solution component becoming zero.
!
!             The code will not attempt to compute a solution at an
!             accuracy unreasonable for the machine being used. It will
!             advise you if you ask for too much accuracy and inform
!             you as to the maximum accuracy it believes possible.
!
!      RWORK(*) -- dimension this real work array of length LRW in your
!             calling program.
!
!      RWORK(1) -- IF YOU HAVE SET INFO(4)=0, YOU CAN IGNORE THIS
!             optional input parameter. Otherwise you must define A
!             STOPPING POINT TSTOP BY SETTING   RWORK(1) = TSTOP.
!             (For some problems it may not be permissible to integrate
!             past a point TSTOP because a discontinuity occurs there
!             or the solution or its derivative is not defined beyond
!             TSTOP.)
!
!      LRW -- set it to the declared length of the RWORK array.
!             You must have
!                  LRW .GE. 250+10*NEQ+NEQ**2
!             FOR THE FULL (DENSE) JACOBIAN CASE (WHEN INFO(6)=0),  OR
!                  LRW .GE. 250+10*NEQ+(2*ML+MU+1)*NEQ
!             FOR THE BANDED JACOBIAN CASE (WHEN INFO(6)=1).
!
!      IWORK(*) -- dimension this integer work array of length LIW in
!             your calling program.
!
!      IWORK(1), IWORK(2) -- IF YOU HAVE SET INFO(6)=0, YOU CAN IGNORE
!             these optional input parameters. Otherwise you must define
!             the half-bandwidths ML (lower) and mu (UPPER) of the
!             JACOBIAN MATRIX BY SETTING    IWORK(1) = ML   AND
!             IWORK(2) = MU.  (THE CODE WILL WORK WITH A FULL MATRIX
!             OF NEQ**2 ELEMENTS UNLESS IT IS TOLD THAT THE PROBLEM HAS
!             a banded Jacobian, in which case the code will work with
!             a matrix containing at most  (2*ML+MU+1)*NEQ  elements.)
!
!      LIW -- set it to the declared length of the IWORK array.
!             YOU MUST HAVE LIW .GE. 55+NEQ.
!
!      Rpar, IPAR -- these are parameter arrays, of real and integer
!             type, respectively. You can use them for communication
!             between your program that calls STFODE and the  F
!             subroutine (and the JAC subroutine). They are not used or
!             altered by STFODE. If you do not need rpar or IPAR, ignore
!             these parameters by treating them as dummy arguments. If
!             you do choose to use them, dimension them in your calling
!             program and in F (and in JAC) as arrays of appropriate
!             length.
!
!      JAC -- IF YOU HAVE SET INFO(5)=0, YOU CAN IGNORE THIS PARAMETER
!             by treating it as a dummy argument. (For some compilers
!             you may have to write a dummy subroutine named  JAC  in
!             order to avoid problems associated with missing external
!             routine names.)  Otherwise, you must provide a subroutine
!             of the form
!                          JAC(X,U,PD,NROWPD,RPAR,IPAR)
!             to define the Jacobian matrix of partial derivatives DF/DU
!             OF THE SYSTEM OF DIFFERENTIAL EQUATIONS   DU/DX = F(X,U).
!             For the given values of X and the vector
!             U(*)=(U(1),U(2),...,U(NEQ)), THE SUBROUTINE MUST EVALUATE
!             the non-zero partial derivatives  DF(I)/DU(J)  for each
!             DIFFERENTIAL EQUATION I=1,...,NEQ AND EACH SOLUTION
!             COMPONENT J=1,...,NEQ , AND STORE THESE VALUES IN THE
!             matrix PD. The elements of PD are set to zero before each
!             CALL TO JAC SO ONLY NON-ZERO ELEMENTS NEED TO BE DEFINED.
!
!             Subroutine JAC must not alter X, U(*), or NROWPD. You must
!             declare the name JAC in an external statement in your
!             program that calls STFODE. NROWPD is the row dimension of
!             the PD matrix and is assigned by the code. Therefore you
!             must dimension PD in JAC according to
!                              DIMENSION PD(NROWPD,1)
!             you must also dimension U in JAC.
!
!             The way you must store the elements into the PD matrix
!             depends on the structure of the Jacobian which you
!             indicated by INFO(6).
!             *** INFO(6)=0 -- FULL (DENSE) JACOBIAN ***
!                 when you evaluate the (NON-ZERO) partial derivative
!                 of equation I with respect to variable J, you must
!                 store it in PD according to
!                                PD(I,J) = * DF(I)/DU(J) *
!             *** INFO(6)=1 -- BANDED JACOBIAN WITH ML LOWER AND MU
!                 upper diagonal bands (refer to INFO(6) description of
!                 ML AND MU) ***
!                 when you evaluate the (NON-ZERO) partial derivative
!                 of equation I with respect to variable J, you must
!                 store it in PD according to
!                                IROW = I - J + ML + MU + 1
!                                PD(IROW,J) = * DF(I)/DU(J) *
!
!             Rpar and IPAR are real and integer parameter arrays which
!             you can use for communication between your calling
!             program and your Jacobian subroutine JAC. They are not
!             altered by STFODE. If you do not need rpar or IPAR, ignore
!             these parameters by treating them as dummy arguments. If
!             you do choose to use them, dimension them in your calling
!             program and in JAC as arrays of appropriate length.
!
!***********************************************************************
!** OUTPUT -- AFTER ANY RETURN FROM STFODE **
!********************************************
!
!   The principal aim of the code is to return a computed solution at
!   tout, although it is also possible to obtain intermediate results
!   along the way. To find out whether the code achieved its goal
!   or if the integration process was interrupted before the task was
!   completed, you must check the IDID parameter.
!
!
!      T -- the solution was successfully advanced to the
!             output value of T.
!
!      Y(*) -- contains the computed solution approximation at T.
!             You may also be interested in the approximate derivative
!             of the solution at T. It is contained in
!             RWORK(21),...,RWORK(20+NEQ).
!
!      IDID -- reports what the code did
!
!                         *** TASK COMPLETED ***
!                   reported by positive values of IDID
!
!             IDID = 1 -- A STEP WAS SUCCESSFULLY TAKEN IN THE
!                       intermediate-output mode. The code has not
!                       yet reached tout.
!
!             IDID = 2 -- THE INTEGRATION TO TOUT WAS SUCCESSFULLY
!                       COMPLETED (T=TOUT) BY STEPPING EXACTLY TO TOUT.
!
!             IDID = 3 -- THE INTEGRATION TO TOUT WAS SUCCESSFULLY
!                       COMPLETED (T=TOUT) BY STEPPING PAST TOUT.
!                       Y(*) is obtained by interpolation.
!
!                         *** TASK INTERRUPTED ***
!                   reported by negative values of IDID
!
!             IDID = -1 -- A LARGE AMOUNT OF WORK HAS BEEN EXPENDED.
!                       (500 Steps performed)
!
!             IDID = -2 -- THE ERROR TOLERANCES ARE TOO STRINGENT.
!
!             IDID = -3 -- THE LOCAL ERROR TEST CANNOT BE SATISFIED
!                       since the L-TH solution component is 0 and
!                       the corresponding absolute error tolerance
!                       IS 0 FOR L = -INFO(1). A PURE RELATIVE ERROR
!                       test cannot be applied to this component.
!
!             IDID = -4,-5  -- NOT APPLICABLE FOR THIS CODE.
!
!             IDID = -6 -- STFODE HAD REPEATED CONVERGENCE TEST FAILURES
!                       on the last attempted step.
!
!             IDID = -7 -- STFODE HAD REPEATED ERROR TEST FAILURES ON
!                       the last attempted step.
!
!             IDID = -8,..,-32  -- NOT APPLICABLE FOR THIS CODE.
!
!                         *** TASK TERMINATED ***
!                 REPORTED BY THE VALUE OF IDID .LE. -33
!
!             IDID = -33  -- NEQ .LT. 1
!
!             IDID = -34  -- RTOL(K) .LT. 0 FOR SOME K
!
!             IDID = -35  -- ATOL(K) .LT. 0 FOR SOME K
!
!             IDID = -36  -- THE CODE HAS BEEN CALLED WITH TOUT BUT
!                       the code has also been told not to integrate
!                       past the point TSTOP.
!
!             IDID = -37  -- THE CODE HAS BEEN CALLED WITH T = TOUT.
!                       This is not permitted on continuation calls.
!
!             IDID = -38  -- THE USER HAS MODIFIED THE VALUE OF T.
!                       This is not permitted on continuation calls.
!
!             IDID = -39  -- BY CALLING THE CODE WITH TOUT, AN
!                       attempt is being made to change the direction
!                       of integration without restarting.
!
!             IDID = -40  -- THE JACOBIAN MATRIX IS BANDED. HOWEVER
!                       the bandwidths ML and mu do not satisfy the
!                       CONSTRAINTS  0 .LE. ML,MU .LT. NEQ.
!
!             IDID = -41  -- LRW .LT. 250 + 10*NEQ + NEQ*NEQ
!
!             IDID = -42  -- LRW .LT. 250 + 10*NEQ + (2*ML+MU+1)*NEQ
!
!             IDID = -43  -- LIW .LT. 55 + NEQ
!
!             IDID = -44  -- INFO(1) IS INCORRECT.
!
!      RTOL, ATOL -- these quantities remain unchanged except when
!             IDID = -2. IN THIS CASE, THE ERROR TOLERANCES HAVE BEEN
!             increased by the code to values which are estimated to be
!             appropriate for continuing the integration. However, the
!             reported solution at T was obtained using the input values
!             of RTOL and ATOL.
!
!      RWORK, IWORK -- contain information which is usually of no
!             interest to the user but necessary for subsequent calls.
!             However, you may find use for
!
!             RWORK(11)--which contains the step size H to be
!                        attempted on the next step.
!
!             RWORK(12)--if the tolerances have been increased by the
!                        CODE (IDID = -2) , THEY WERE MULTIPLIED BY THE
!                        value in RWORK(12).
!
!             RWORK(13)--which contains the current value of the
!                        independent variable, I.E. The farthest point
!                        integration has reached. This will be different
!                        from T only when interpolation has been
!                        PERFORMED (IDID=3).
!
!             RWORK(20+I)--which contains the approximate derivative
!                        of the solution component Y(I). In STFODE it is
!                        never obtained by calling subroutine F to
!                        evaluate the differential equation using T and
!                        Y(*), except at the initial point of
!                        integration.
!
!***********************************************************************
!** INPUT -- WHAT TO DO TO CONTINUE THE INTEGRATION **
!**             (CALLS AFTER THE FIRST)             **
!*****************************************************
!
!        This code is organized so that subsequent calls to continue the
!        integration involve little (if any) additional effort on your
!        part. You must monitor the IDID parameter in order to determine
!        what to do next.
!
!        Recalling that the principal task of the code is to integrate
!        from T to tout (the interval mode), usually all you will need
!        to do is specify a new tout upon reaching the current tout.
!
!        Do not alter any quantity not specifically permitted below,
!        in particular do not alter NEQ, T, Y(*), RWORK(*), IWORK(*) or
!        the differential equation in subroutine F. Any such alteration
!        constitutes a new problem and must be treated as such, I.E.
!        You must start afresh.
!
!        You cannot change from vector to scalar error control or vice
!        versa (INFO(2)) but you can change the size of the entries of
!        RTOL, ATOL. Increasing a tolerance makes the equation easier
!        to integrate. Decreasing a tolerance will make the equation
!        harder to integrate and should generally be avoided.
!
!        You can switch from the intermediate-output mode to the
!        interval mode (INFO(3)) or vice versa at any time.
!
!        If it has been necessary to prevent the integration from going
!        past a point TSTOP (INFO(4), RWORK(1)), keep in mind that the
!        code will not integrate to any tout beyond the currently
!        specified TSTOP. Once TSTOP has been reached you must change
!        THE VALUE OF TSTOP OR SET INFO(4)=0. YOU MAY CHANGE INFO(4)
!        or TSTOP at any time but you must supply the value of TSTOP in
!        RWORK(1) WHENEVER YOU SET INFO(4)=1.
!
!        Do not change INFO(5), INFO(6), IWORK(1), or IWORK(2)
!        unless you are going to restart the code.
!
!        The parameter INFO(1) is used by the code to indicate the
!        beginning of a new problem and to indicate whether integration
!        IS TO BE CONTINUED. YOU MUST INPUT THE VALUE  INFO(1) = 0
!        when starting a new problem. You must input the value
!        INFO(1) = 1  IF YOU WISH TO CONTINUE AFTER AN INTERRUPTED TASK
!        FOR WHICH IDID = -3, -6, OR -7. DO NOT SET INFO(1) = 0 ON A
!        continuation call unless you want the code to restart at the
!        CURRENT T.
!
!                         *** FOLLOWING A COMPLETED TASK ***
!         if
!             IDID = 1, CALL THE CODE AGAIN TO CONTINUE THE INTEGRATION
!                     another step in the direction of tout.
!
!             IDID = 2 OR 3, DEFINE A NEW TOUT AND CALL THE CODE AGAIN.
!                     Tout must be different from T. You cannot change
!                     the direction of integration without restarting.
!
!                         *** FOLLOWING AN INTERRUPTED TASK ***
!         if
!             IDID = -1, THE CODE HAS PERFORMED 500 STEPS.
!                     If you want to continue, call the code again.
!
!             IDID = -2, THE ERROR TOLERANCES RTOL AND ATOL HAVE BEEN
!                     increased to values the code estimates appropriate
!                     for continuing. You may want to change them
!                     yourself. If you want to continue, call the code
!                     again.
!
!             IDID = -3, THE L-TH SOLUTION COMPONENT IS 0 AND THE
!                     corresponding absolute error tolerance is 0
!                     FOR L = -INFO(1). TO CONTINUE, RESET THE
!                     absolute tolerance to a positive value, set
!                     INFO(1) = 1, AND CALL THE CODE AGAIN.
!
!             IDID = -4,-5  --- CANNOT OCCUR WITH THIS CODE.
!
!             IDID = -6, REPEATED CONVERGENCE TEST FAILURES OCCURRED
!                     on the last attempted step. An inaccurate
!                     Jacobian may be the problem. If you are absolutely
!                     certain you want to continue, restart the
!                     INTEGRATION AT THE CURRENT T BY SETTING  INFO(1)=0
!                     and call the code again.
!
!             IDID = -7, REPEATED ERROR TEST FAILURES OCCURRED ON THE
!                     last attempted step. A singularity in the
!                     solution may be present. You should RE-examine the
!                     problem being solved. If you are absolutely
!                     certain you want to continue, restart the
!                     INTEGRATION AT THE CURRENT T BY SETTING  INFO(1)=0
!                     and call the code again.
!
!             IDID = -8,..,-32  --- CANNOT OCCUR WITH THIS CODE.
!
!                         *** FOLLOWING A TERMINATED TASK ***
!         if
!             IDID .LE. -33, AN INPUT ERROR HAS BEEN DETECTED. AFTER THE
!                     ERROR IS CORRECTED, RESTART BY SETTING INFO(1) = 0
!                     and call the code again.
!
!***********************************************************************
!
!         ***** WARNING *****
!
!     If STFODE is to be used in an overlay situation, you must save and
!     restore certain items used internally by STFODE  (values in the
!     common block DEBDF1). This can be accomplished as follows.
!
!     To save the necessary values upon return from STFODE, simply call
!        SVCO(RWORK(22+NEQ),IWORK(21+NEQ)).
!
!     To restore the necessary values before the next call to STFODE,
!     SIMPLY CALL    RSCO(RWORK(22+NEQ),IWORK(21+NEQ)).
!
!***********************************************************************
!
!***REFERENCES
!   SHAMPINE L.F., WATTS H.A., *DEPAC - DESIGN OF A USER ORIENTED
!   PACKAGE OF ODE SOLVERS*, SAND79-2374, SANDIA LABORATORIES, 1979.
!
!
logical :: intout
!
dimension iwork(liw)
!
common /debdf1/ told, rowns(210), &
&el0, h, hmin, hmxi, hu, tn, uround, &
&iquit, init, iyh, iewt, iacor, isavf, iwm, ksteps, &
&ibegin, itol, iinteg, itstop, ijac, iband, iowns(6), &
&ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
&nje, nqu
!
external f , jac
!
!.......................................................................
!
idid = 0
!
if (info(1) .eq. 0) go to 20
if (info(1) .ne. 1) go to 10
if (iquit .eq. 0) go to 20
10 idid = -44
return
!
20 if (info(2) .ne. 0) info(2) = 1
if (info(3) .ne. 0) info(3) = 1
if (info(4) .ne. 0) info(4) = 1
if (info(5) .ne. 0) info(5) = 1
if (info(6) .ne. 0) info(6) = 1
!
ilrw = neq
if (info(6) .eq. 0) go to 80
!
!     Check bandwidth parameters
!
ml = iwork(1)
mu = iwork(2)
ilrw = 2*ml + mu + 1
if (ml .ge. 0  .and.  ml .lt. neq      .and. &
&mu .ge. 0  .and.  mu .lt. neq)    go to 80
idid = -40
return
!
!     Check LRW and LIW for sufficient storage allocation
!
80 if (lrw .ge. 250+(10+ilrw)*neq) go to 100
!
if (info(6) .eq. 1) go to 90
idid = -41
return
!
90 idid = -42
return
!
100 if (liw .ge. 55+neq) go to 200
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
if (info(1) .eq. 0) go to 250
intout = iwork(iinout) .ne. (-1)
!     CALL RSCO(RWORK(ICOMR),IWORK(ICOMI))
!
250 iyh = icomr + 218
iewt = iyh + 6*neq
isavf = iewt + neq
iacor = isavf + neq
iwm = iacor + neq
idelsn = iwm + 2+ilrw*neq
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
&rwork(iyh),rwork(iyh),rwork(iewt),rwork(isavf), &
&rwork(iacor),rwork(iwm),iwork(1),jac,intout, &
&rwork(1),rwork(12),rwork(idelsn),rpar,ipar)
!
iwork(iinout) = -1
if (intout) iwork(iinout) = 1
!
!     CALL SVCO(RWORK(ICOMR),IWORK(ICOMI))
rwork(11) = h
rwork(13) = tn
info(1) = ibegin
!
return
end subroutine stfode

subroutine rsco (rsav, isav)
implicit none
!-----------------------------------------------------------------------
! This routine restores from RSAV and ISAV the contents of common
! block DEBDF1, which is used internally in the SFODE package.
!-----------------------------------------------------------------------
integer :: isav(*), i, ils, lenils, lenrls
real :: rsav(*), rls
common /debdf1/ rls(218), ils(33)
data lenrls/218/, lenils/33/
!
do 10 i = 1,lenrls
10 rls(i) = rsav(i)
do 20 i = 1,lenils
20 ils(i) = isav(i)
return
!----------------------- End of subroutine RSCO -----------------------
end subroutine rsco

subroutine svco (rsav, isav)
implicit none
!-----------------------------------------------------------------------
! This routine stores in RSAV and ISAV the contents of common block
! DEBDF1, which is used internally in the SFODE package.
!
! RSAV = REAL ARRAY OF LENGTH 218 OR MORE.
! ISAV = INTEGER ARRAY OF LENGTH 33 OR MORE.
!-----------------------------------------------------------------------
integer :: isav(*), i, ils, lenils, lenrls
real :: rsav(*), rls
common /debdf1/ rls(218), ils(33)
data lenrls/218/, lenils/33/
!
do 10 i = 1,lenrls
10 rsav(i) = rls(i)
do 20 i = 1,lenils
20 isav(i) = ils(i)
return
!----------------------- End of subroutine SVCO -----------------------
end subroutine svco

subroutine lsod1 (f,neq,t,y,tout,rtol,atol,idid,ypout, &
&yh,yh1,ewt,savf,acor,wm,iwm,jac,intout, &
&tstop,tolfac,delsgn,rpar,ipar)
implicit none
integer :: idid, ipar(*), iwm(*), neq
real :: acor(neq), atol(*), delsgn, ewt(neq), rpar(*), rtol(*), &
&savf(neq), t, tolfac, tout, tstop, wm(*), y(neq), yh(neq,*), &
&yh1(*), ypout(neq)
integer :: intflg, k, l, ltol, max, maxnum
real :: absdel, big, del, dt, ha, tol
integer :: iband, ibegin, ier, iinteg, ijac, init, iowns, iquit, &
&itol, itstop, jstart, kflag, ksteps, lacor, ldum, lewt, lsavf, &
&lwm, lyh, maxord, meth, miter, n, nfe, nje, nq, nqu, nst
real :: el0, h, hmin, hmxi, hu, rowns, told, u, x
real :: vnwrms
real :: spmpar
!
!   STFODE  merely allocates storage for LSOD1 to relieve the user of
!   the inconvenience of a long call list.  Consequently LSOD1 is used
!   as described in the comments for  STFODE.
!
!***ROUTINES CALLED  STOD,INTYD,VNWRMS,HSTART,SPMPAR
!
logical :: intout
!
!
common /debdf1/ told, rowns(210), &
&el0, h, hmin, hmxi, hu, x, u, &
&iquit, init, lyh, lewt, lacor, lsavf, lwm, ksteps, &
&ibegin, itol, iinteg, itstop, ijac, iband, iowns(6), &
&ier, jstart, kflag, ldum, meth, miter, maxord, n, nq, nst, &
&nfe, nje, nqu
!
external f , jac
!
!.......................................................................
!
!  The expense of solving the problem is monitored by counting the
!  number of  steps attempted. When this exceeds  MAXNUM, the counter
!  is reset to zero and the user is informed about possible excessive
!  work.
!
data maxnum/500/
!
!.......................................................................
!
if (ibegin .ne. 0) go to 10
!
! On the first call , perform initialization --
!        define the machine unit roundoff quantity  U  by calling the
!        function routine  SPMPAR. The user must make sure that the
!        values set in SPMPAR are relevant to the computer being used.
!
u=spmpar(1)
!                       -- Set associated machine dependent parameter
wm(1)=sqrt(u)
!                       -- Set termination flag
iquit=0
!                       -- Set initialization indicator
init=0
!                       -- Set counter for attempted steps
ksteps=0
!                       -- Set indicator for intermediate-output
intout= .false.
!                       -- Set start indicator for STOD code
jstart= 0
!                       -- Set BDF method indicator
meth = 2
!                       -- Set maximum order for BDF method
maxord = 5
!                       -- Set iteration matrix indicator
!
if (ijac .eq. 0  .and.  iband .eq. 0) miter = 2
if (ijac .eq. 1  .and.  iband .eq. 0) miter = 1
if (ijac .eq. 0  .and.  iband .eq. 1) miter = 5
if (ijac .eq. 1  .and.  iband .eq. 1) miter = 4
!
!                       -- Set other necessary items in common block
n = neq
nst = 0
nje = 0
hmxi = 0.
nq = 1
h = 1.
!                       -- Reset IBEGIN for subsequent calls
ibegin = 1
!
!.......................................................................
!
!      Check validity of input paramaters on each entry
!
10 if (neq .ge. 1) go to 20
idid = -33
go to 110
!
20 max = 1
if (itol .ne. 0) max = neq
do 60 k = 1,max
  if (rtol(k) .ge. 0.) go to 30
     idid = -34
     go to 110
30 if (atol(k) .ge. 0.) go to 60
     idid = -35
     go to 110
60 continue
!
if (itstop .ne. 1) go to 80
if ((tout - t)*(tstop - t) .ge. 0.0 &
&.and. abs(tout-t) .le. abs(tstop-t)) go to 80
idid = -36
go to 110
!
80 if (init .eq. 0) go to 150
!                       Check some continuation possibilities
if (t .ne. tout) go to 90
idid = -37
go to 110
!
90 if (t .eq. told) go to 100
idid = -38
go to 110
!
100 if (init .eq. 1) go to 150
if (delsgn*(tout-t) .ge. 0.) go to 150
idid = -39
!
!                       Invalid input detected
110 iquit = -33
ibegin = -1
return
!
!.......................................................................
!
!     RTOL = ATOL = 0. IS ALLOWED AS VALID INPUT AND INTERPRETED AS
!     asking for the most accurate solution possible. In this case,
!     the relative error tolerance RTOL is reset to the smallest value
!     100*U which is likely to be reasonable for this method and machine
!
150 do 170 k = 1,max
  if (rtol(k) + atol(k) .gt. 0.) go to 170
  rtol(k) = 100.*u
  idid = -2
170 continue
if (idid .eq. -2) return
!
!     Branch on status of initialization indicator
!            INIT=0 MEANS INITIAL DERIVATIVES AND NOMINAL STEP SIZE
!                   and direction not yet set
!            INIT=1 MEANS NOMINAL STEP SIZE AND DIRECTION NOT YET SET
!            INIT=2 MEANS NO FUTHER INITIALIZATION REQUIRED
!
if (init .eq. 0) go to 200
if (init .eq. 1) go to 220
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
if (t .ne. tout) go to 220
idid = 2
do 210 l = 1,neq
210 ypout(l) = yh(l,2)
told = t
return
!
!                         -- Compute initial step size
!                         -- save sign of integration direction
!                         -- set independent and dependent variables
!                                              X and YH(*) for STOD
!
220 ltol = 1
do 225 l = 1,neq
  if (itol .eq. 1) ltol = l
  tol = rtol(ltol)*abs(y(l)) + atol(ltol)
  if (tol .eq. 0.) go to 380
225 ewt(l) = tol
!
big = sqrt(spmpar(3))
call hstart (f,neq,t,tout,y,yh(1,2),ewt,1,u,big, &
&yh(1,3),yh(1,4),yh(1,5),yh(1,6),rpar,ipar,h)
!
delsgn = sign(1.0,tout-t)
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
250 if (abs(x-t) .lt. absdel) go to 270
call intyd(tout,0,yh,neq,y,intflg)
call intyd(tout,1,yh,neq,ypout,intflg)
idid = 3
if (x .ne. tout) go to 260
idid = 2
intout = .false.
260 t = tout
told = t
return
!
!   If cannot go past TSTOP and sufficiently close,
!   extrapolate and return
!
270 if (itstop .ne. 1) go to 290
if (abs(tstop-x) .ge. 100.*u*abs(x)) go to 290
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
290 if (iinteg .eq. 0  .or.  .not.intout) go to 300
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
300 if (ksteps .le. maxnum) go to 330
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
if (itstop .ne. 1) go to 340
ha = amin1(ha,abs(tstop-x))
340 h = sign(ha,h)
ltol = 1
do l = 1,neq
  if (itol .eq. 1) ltol = l
  ewt(l) = rtol(ltol)*abs(yh(l,1)) + atol(ltol)
  if (ewt(l) .le. 0.0) go to 380
  end do
tolfac = u*vnwrms(neq,yh,ewt)
if (tolfac .le. 1.) go to 400
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
if (kflag .eq. 0) go to 250
!
!.......................................................................
!
if (kflag .eq. -1) go to 450
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
!                       Store values before returning to STFODE
500 do 555 l = 1,neq
  y(l) = yh(l,1)
555 ypout(l) = yh(l,2)/h
t = x
told = t
intout = .false.
return
end subroutine lsod1

subroutine hstart(f,neq,a,b,y,yprime,etol,morder,small,big, &
&spy,pv,yp,sf,rpar,ipar,h)
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
integer :: j, k, lk
real :: absdx, da, delf, dely, dfdub, dfdxb, dx, dy, fbnd, relper, &
&srydpb, tolexp, tolmin, tolp, tolsum, ydpb
real :: vnorm
!
!   HSTART computes a starting step size to be used in solving initial
!   value problems in ordinary differential equations.
!
!
!***********************************************************************
!  Abstract
!
!     Subroutine HSTART computes a starting step size to be used by an
!     initial value method in solving ordinary differential equations.
!     It is based on an estimate of the local Lipschitz constant for the
!     DIFFERENTIAL EQUATION   (LOWER BOUND ON A NORM OF THE JACOBIAN) ,
!     a bound on the differential equation  (first derivative) , and
!     a bound on the partial derivative of the equation with respect to
!     the independent variable.
!     (All approximated near the initial point A)
!
!     Subroutine HSTART uses a function subprogram VNORM for computing
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
!                               F(X,U,UPRIME,RPAR,IPAR)
!             which defines the system of first order differential
!             equations to be solved. For the given values of X and the
!             VECTOR  U(*)=(U(1),U(2),...,U(NEQ)) , THE SUBROUTINE MUST
!             evaluate the NEQ components of the system of differential
!             EQUATIONS  DU/DX=F(X,U)  AND STORE THE DERIVATIVES IN THE
!             ARRAY UPRIME(*), THAT IS,  UPRIME(I) = * DU(I)/DX *  FOR
!             EQUATIONS I=1,...,NEQ.
!
!             Subroutine F must not alter X or U(*). You must declare
!             the name F in an external statement in your program that
!             calls HSTART. You must dimension U and UPRIME in F.
!
!             Rpar and IPAR are real and integer parameter arrays which
!             you can use for communication between your program and
!             subroutine F. They are not used or altered by HSTART. If
!             you do not need rpar or IPAR, ignore these parameters by
!             treating them as dummy arguments. If you do choose to use
!             them, dimension them in your program and in F as arrays
!             of appropriate length.
!
!      NEQ -- this is the number of (first order) differential equations
!             to be integrated.
!
!      A -- this is the initial point of integration.
!
!      B -- this is a value of the independent variable used to define
!             the direction of integration. A reasonable choice is to
!             set  B  to the first point at which a solution is desired.
!             You can also use  B, if necessary, to restrict the length
!             of the first integration step because the algorithm will
!             not compute a starting step length which is bigger than
!             ABS(B-A), unless  B  has been chosen too close to  A.
!             (It is presumed that HSTART has been called with  B
!             different from  A  on the machine being used. Also see the
!             discussion about the parameter  SMALL.)
!
!      Y(*) -- this is the vector of initial values of the NEQ solution
!             components at the initial point  A.
!
!      YPRIME(*) -- this is the vector of derivatives of the NEQ
!             solution components at the initial point  A.
!             (Defined by the differential equations in subroutine F)
!
!      ETOL -- this is the vector of error tolerances corresponding to
!             the NEQ solution components. It is assumed that all
!             elements are positive. Following the first integration
!             step, the tolerances are expected to be used by the
!             integrator in an error test which roughly requires that
!                        ABS(LOCAL ERROR)  .LE.  ETOL
!             for each vector component.
!
!      MORDER -- this is the order of the formula which will be used by
!             the initial value method for taking the first integration
!             step.
!
!      Small -- this is a small positive machine dependent constant
!             which is used for protecting against computations with
!             numbers which are too small relative to the precision of
!             floating point arithmetic.  Small  should be set to
!             (approximately) the smallest positive real number such
!             THAT  (1.+SMALL) .GT. 1.  ON THE MACHINE BEING USED. THE
!             QUANTITY  SMALL**(3/8)  IS USED IN COMPUTING INCREMENTS OF
!             variables for approximating derivatives by differences.
!             Also the algorithm will not compute a starting step length
!             which is smaller than  100*small*ABS(A).
!
!      Big -- this is a large positive machine dependent constant which
!             is used for preventing machine overflows. A reasonable
!             choice is to set big to (approximately) the square root of
!             the largest real number which can be held in the machine.
!
!      SPY(*),PV(*),YP(*),SF(*) -- these are real work arrays of length
!             NEQ which provide the routine with needed storage space.
!
!      Rpar,IPAR -- these are parameter arrays, of real and integer
!             type, respectively, which can be used for communication
!             between your program and the F subroutine. They are not
!             used or altered by HSTART.
!
!***********************************************************************
!  On output  (after the return from HSTART),
!
!      H -- is an appropriate starting step size to be attempted by the
!             differential equation method.
!
!           All parameters in the call list remain unchanged except for
!           the working arrays SPY(*),PV(*),YP(*), and SF(*).
!
!***********************************************************************
!
!***ROUTINES CALLED  VNORM
!
external f
!
!.......................................................................
!
dx=b-a
absdx=abs(dx)
relper=small**0.375
!
!.......................................................................
!
!     Compute an approximate bound (DFDXB) on the partial
!     derivative of the equation with respect to the
!     independent variable. Protect against an overflow.
!     Also compute a bound (FBND) on the first derivative locally.
!
da=sign(amax1(amin1(relper*abs(a),absdx),100.*small*abs(a)),dx)
if (da .eq. 0.) da=relper*dx
call f(a+da,y,sf,rpar,ipar)
do 10 j = 1,neq
10 yp(j)=sf(j)-yprime(j)
delf=vnorm(yp,neq)
dfdxb=big
if (delf .lt. big*abs(da)) dfdxb=delf/abs(da)
fbnd=vnorm(sf,neq)
!
!.......................................................................
!
!     Compute an estimate (DFDUB) of the local Lipschitz constant for
!     the system of differential equations. This also represents an
!     estimate of the norm of the Jacobian locally.
!     THREE ITERATIONS (TWO WHEN NEQ=1) ARE USED TO ESTIMATE THE
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
!     Also choose the largest bound (FBND) for the first derivative.
!
!                       Perturbation vector SIZE is held constant for
!                       all iterations. Compute this change from the
!                               size of the vector of initial values.
dely=relper*vnorm(y,neq)
if (dely .eq. 0.) dely=relper
dely=sign(dely,dx)
delf=vnorm(yprime,neq)
fbnd=amax1(fbnd,delf)
if (delf .eq. 0.) go to 30
!                       Use initial derivatives for first perturbation
do 20 j = 1,neq
  spy(j)=yprime(j)
20 yp(j)=yprime(j)
go to 50
!                       Cannot have a null perturbation vector
30 do 40 j = 1,neq
  spy(j)=0.
40 yp(j)=1.
delf=vnorm(yp,neq)
!
50 dfdub=0.
lk=min0(neq+1,3)
do 140 k = 1,lk
!                       Define perturbed vector of initial values
  do 60 j = 1,neq
60 pv(j)=y(j)+dely*(yp(j)/delf)
  if (k .eq. 2) go to 80
!                       Evaluate derivatives associated with perturbed
!                       vector  and  compute corresponding differences
  call f(a,pv,yp,rpar,ipar)
  do 70 j = 1,neq
70 pv(j)=yp(j)-yprime(j)
  go to 100
!                       Use a shifted value of the independent variable
!                                             in computing one estimate
80 call f(a+da,pv,yp,rpar,ipar)
  do 90 j = 1,neq
90 pv(j)=yp(j)-sf(j)
!                       Choose largest bounds on the first derivative
!                                      and a local Lipschitz constant
100 fbnd=amax1(fbnd,vnorm(yp,neq))
  delf=vnorm(pv,neq)
  if (delf .ge. big*abs(dely)) go to 150
  dfdub=amax1(dfdub,delf/abs(dely))
  if (k .eq. lk) go to 160
!                       Choose next perturbation vector
  if (delf .eq. 0.) delf=1.
  do 130 j = 1,neq
    if (k .eq. 2) go to 110
    dy=abs(pv(j))
    if (dy .eq. 0.) dy=delf
    go to 120
110 dy=y(j)
    if (dy .eq. 0.) dy=dely/relper
120 if (spy(j) .eq. 0.) spy(j)=yp(j)
    if (spy(j) .ne. 0.) dy=sign(dy,spy(j))
130 yp(j)=dy
140 delf=vnorm(yp,neq)
!
!                       Protect against an overflow
150 dfdub=big
!
!.......................................................................
!
!     Compute a bound (YDPB) on the norm of the second derivative
!
160 ydpb=dfdxb+dfdub*fbnd
!
!.......................................................................
!
!     Define the tolerance parameter upon which the starting step size
!     is to be based.  A value in the middle of the error tolerance
!     range is selected.
!
tolmin=big
tolsum=0.
do 170 k = 1,neq
  tolexp=alog10(etol(k))
  tolmin=amin1(tolmin,tolexp)
170 tolsum=tolsum+tolexp
tolp=10.**(0.5*(tolsum/float(neq)+tolmin)/float(morder+1))
!
!.......................................................................
!
!     Compute a starting step size based on the above first and second
!     derivative information
!
!                       Restrict the step length to be not bigger than
!                       ABS(B-A).   (UNLESS  B  IS TOO CLOSE TO  A)
h=absdx
!
if (ydpb .ne. 0.  .or.  fbnd .ne. 0.) go to 180
!
!                       Both first derivative term (FBND) and second
!                                    derivative term (YDPB) are zero
if (tolp .lt. 1.) h=absdx*tolp
go to 200
!
180 if (ydpb .ne. 0.) go to 190
!
!                       Only second derivative term (YDPB) is zero
if (tolp .lt. fbnd*absdx) h=tolp/fbnd
go to 200
!
!                       Second derivative term (YDPB) is non-zero
190 srydpb=sqrt(0.5*ydpb)
if (tolp .lt. srydpb*absdx) h=tolp/srydpb
!
!                       Further restrict the step length to be not
!                                                 bigger than  1/DFDUB
200 if (h*dfdub .gt. 1.) h=1./dfdub
!
!                       Finally, restrict the step length to be not
!                       smaller than  100*small*ABS(A).  However, if
!                       A=0. AND THE COMPUTED H UNDERFLOWED TO ZERO,
!                       the algorithm returns  small*ABS(B)  for the
!                                                       step length.
h=amax1(h,100.*small*abs(a))
if (h .eq. 0.) h=small*abs(b)
!
!                       Now set direction of integration
h=sign(h,dx)
!
return
end subroutine hstart

subroutine intyd (t, k, yh, nyh, dky, iflag)
implicit none
!
!   INTYD approximates the solution and derivatives at T by polynomial
!   interpolation. Must be used in conjunction with the integrator
!   PACKAGE SFODE.
!-----------------------------------------------------------------------
! INTYD computes interpolated values of the K-TH derivative of the
! dependent variable vector Y, and stores it in DKY.
! THIS ROUTINE IS CALLED BY STFODE WITH K = 0,1 AND T = TOUT, BUT MAY
! also be called by the user for any K up to the current order.
! (See detailed instructions in lsode usage documentation.)
!-----------------------------------------------------------------------
! THE COMPUTED VALUES IN DKY ARE GOTTEN BY INTERPOLATION USING THE
! NORDSIECK HISTORY ARRAY YH.  THIS ARRAY CORRESPONDS UNIQUELY TO A
! VECTOR-VALUED POLYNOMIAL OF DEGREE NQCUR OR LESS, AND DKY IS SET
! TO THE K-TH DERIVATIVE OF THIS POLYNOMIAL AT T.
! THE FORMULA FOR DKY IS..
!              Q
!  DKY(I)  =  SUM  C(J,K) * (T - TN)**(J-K) * H**(-J) * YH(I,J+1)
!             J=K
! WHERE  C(J,K) = J*(J-1)*...*(J-K+1), Q = NQCUR, TN = TCUR, H = HCUR.
! THE QUANTITIES  NQ = NQCUR, L = NQ+1, N = NEQ, TN, AND H ARE
! COMMUNICATED BY COMMON.  THE ABOVE SUM IS DONE IN REVERSE ORDER.
! IFLAG IS RETURNED NEGATIVE IF EITHER K OR T IS OUT OF BOUNDS.
!-----------------------------------------------------------------------
integer :: k, nyh, iflag, i, ic, ier, iownd, iowns, j, jb, jb2, &
&jj, jj1, jp1, jstart, kflag, l, maxord, meth, miter, n, nfe, nje, &
&nq, nqu, nst
real :: t, yh(nyh,*), dky(*), rownd, rowns, el0, h, hmin, hmxi, &
&hu, tn, uround, c, r, s, tp
common /debdf1/ rownd, rowns(210), &
&el0, h, hmin, hmxi, hu, tn, uround, iownd(14), iowns(6), &
&ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
&nje, nqu
!
iflag = 0
if (k .lt. 0 .or. k .gt. nq) go to 80
tp = tn - hu*(1.0e0 + 100.0e0*uround)
if ((t-tp)*(t-tn) .gt. 0.0e0) go to 90
!
s = (t - tn)/h
ic = 1
if (k .eq. 0) go to 15
jj1 = l - k
do 10 jj = jj1,nq
10 ic = ic*jj
15 c = float(ic)
do 20 i = 1,n
20 dky(i) = c*yh(i,l)
if (k .eq. nq) go to 55
jb2 = nq - k
do jb = 1,jb2
  j = nq - jb
  jp1 = j + 1
  ic = 1
  if (k .eq. 0) go to 35
  jj1 = jp1 - k
  do 30 jj = jj1,j
30 ic = ic*jj
35 c = float(ic)
  do 40 i = 1,n
40 dky(i) = c*yh(i,jp1) + s*dky(i)
  end do
if (k .eq. 0) return
55 r = h**(-k)
do 60 i = 1,n
60 dky(i) = r*dky(i)
return
!
80 iflag = -1
return
90 iflag = -2
return
!----------------------- End of subroutine INTYD -----------------------
end subroutine intyd

subroutine stod  (neq, y, yh, nyh, yh1, ewt, savf, acor, &
&wm, iwm, f, jac, rpar, ipar)
implicit none
integer :: ipar(*)
real :: rpar(*)
integer :: ipnyh
integer :: iod, ksteps
!-----------------------------------------------------------------------
! STOD  performs one step of the integration of an initial value
! problem for a system of ordinary differential equations.
! Note.. STOD  is independent of the value of the iteration method
! INDICATOR MITER, WHEN THIS IS .NE. 0, AND HENCE IS INDEPENDENT
! of the type of chord method used, or the Jacobian structure.
! Communication with STOD  is done with the following variables..
!
! Y      = AN ARRAY OF LENGTH .GE. N USED AS THE Y ARGUMENT IN
!          all calls to F and JAC.
! NEQ    = INTEGER ARRAY CONTAINING PROBLEM SIZE IN NEQ(1), AND
!          passed as the NEQ argument in all calls to F and JAC.
! YH     = AN NYH BY LMAX ARRAY CONTAINING THE DEPENDENT VARIABLES
!          and their approximate scaled derivatives, where
!          LMAX = MAXORD + 1.  YH(I,J+1) CONTAINS THE APPROXIMATE
!          J-TH DERIVATIVE OF Y(I), SCALED BY H**J/FACTORIAL(J)
!          (J = 0,1,...,NQ).  ON ENTRY FOR THE FIRST STEP, THE FIRST
!          two columns of YH must be set from the initial values.
! NYH    = A CONSTANT INTEGER .GE. N, THE FIRST DIMENSION OF YH.
! YH1    = A ONE-DIMENSIONAL ARRAY OCCUPYING THE SAME SPACE AS YH.
! EWT    = AN ARRAY OF N ELEMENTS WITH WHICH THE ESTIMATED LOCAL
!          errors in YH are compared.
! SAVF   = AN ARRAY OF WORKING STORAGE, OF LENGTH N.
! ACOR   = A WORK ARRAY OF LENGTH N, USED FOR THE ACCUMULATED
!          corrections.  On a successful return, ACOR(I) contains
!          the estimated one-step local error in Y(I).
! WM,IWM = REAL AND INTEGER WORK ARRAYS ASSOCIATED WITH MATRIX
!          OPERATIONS IN CHORD ITERATION (MITER .NE. 0).
! PJAC   = NAME OF ROUTINE TO EVALUATE AND PREPROCESS JACOBIAN MATRIX
!          if a chord method is being used.
! SLVS   = NAME OF ROUTINE TO SOLVE LINEAR SYSTEM IN CHORD ITERATION.
! H      = THE STEP SIZE TO BE ATTEMPTED ON THE NEXT STEP.
!          H is altered by the error control algorithm during the
!          problem.  H can be either positive or negative, but its
!          sign must remain constant throughout the problem.
! HMIN   = THE MINIMUM ABSOLUTE VALUE OF THE STEP SIZE H TO BE USED.
! HMXI   = INVERSE OF THE MAXIMUM ABSOLUTE VALUE OF H TO BE USED.
!          HMXI = 0.0 IS ALLOWED AND CORRESPONDS TO AN INFINITE HMAX.
!          HMIN and HMXI may be changed at any time, but will not
!          take effect until the next change of H is considered.
! TN     = THE INDEPENDENT VARIABLE. TN IS UPDATED ON EACH STEP TAKEN.
! JSTART = AN INTEGER USED FOR INPUT ONLY, WITH THE FOLLOWING
!          values and meanings..
!               0  Perform the first step.
!           .GT.0  TAKE A NEW STEP CONTINUING FROM THE LAST.
!              -1  Take the next step with a new value of H, MAXORD,
!                    N, meth, miter, and/or matrix parameters.
!              -2  Take the next step with a new value of H,
!                    but with other inputs unchanged.
!          On return, JSTART is set to 1 to facilitate continuation.
! KFLAG  = A COMPLETION CODE WITH THE FOLLOWING MEANINGS..
!               0  The step was succesful.
!              -1  The requested error could not be achieved.
!              -2  Corrector convergence could not be achieved.
!          A RETURN WITH KFLAG = -1 OR -2 MEANS EITHER
!          ABS(H) = HMIN OR 10 CONSECUTIVE FAILURES OCCURRED.
!          On a return with KFLAG negative, the values of TN and
!          the YH array are as of the beginning of the last
!          step, and H is the last step size attempted.
! MAXORD = THE MAXIMUM ORDER OF INTEGRATION METHOD TO BE ALLOWED.
! METH/MITER = THE METHOD FLAGS.  SEE DESCRIPTION IN DRIVER.
! N      = THE NUMBER OF FIRST-ORDER DIFFERENTIAL EQUATIONS.
!-----------------------------------------------------------------------
!***ROUTINES CALLED  CFOD,SLVS,PJAC,VNWRMS
!
external f, jac
!
integer :: neq, nyh, iwm(*), i, i1, ialth, ier, iownd, iredo, &
&iret, ipup, j, jb, jstart, kflag, l, lmax, m, maxord, meo, meth, &
&miter, n, ncf, newq, nfe, nje, nq, nqnyh, nqu, nst, nstepj
real :: y(*), yh(nyh,*), yh1(*), ewt(*), savf(*), acor(*), wm(*), &
&rownd, conit, crate, el, elco, hold, rc, rmax, tesco, el0, h, &
&hmin, hmxi, hu, tn, uround, dcon, ddn, del, delp, dsm, dup, exdn, &
&exsm, exup, r, rh, rhdn, rhsm, rhup, told, vnwrms
common /debdf1/ rownd, conit, crate, el(13), elco(13,12), &
&hold, rc, rmax, tesco(3,12), &
&el0, h, hmin, hmxi, hu, tn, uround, iownd(7), ksteps, iod(6), &
&ialth, ipup, lmax, meo, nqnyh, nstepj, &
&ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
&nje, nqu
!
!
kflag = 0
told = tn
ncf = 0
if (jstart .gt. 0) go to 200
if (jstart .eq. -1) go to 100
if (jstart .eq. -2) go to 160
!-----------------------------------------------------------------------
! On the first call, the order is set to 1, and other variables are
! initialized.  RMAX is the maximum ratio by which H can be increased
! in a single step.  It is initially 1.E4 to compensate for the small
! initial H, but then is normally equal to 10.  If a failure
! occurs (in corrector convergence or error test), RMAX is set at 2
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
! THE FOLLOWING BLOCK HANDLES PRELIMINARIES NEEDED WHEN JSTART = -1.
! IPUP is set to miter to force a matrix update.
! IF AN ORDER INCREASE IS ABOUT TO BE CONSIDERED (IALTH = 1),
! IALTH is reset to 2 to postpone consideration one more step.
! If the caller has changed meth, CFOD  is called to reset
! the coefficients of the method.
! If the caller has changed MAXORD to a value less than the current
! order NQ, NQ is reduced to MAXORD, and a new H chosen accordingly.
! If H is to be changed, YH must be rescaled.
! IF H OR METH IS BEING CHANGED, IALTH IS RESET TO L = NQ + 1
! to prevent further changes in H for that many steps.
!-----------------------------------------------------------------------
100 ipup = miter
lmax = maxord + 1
if (ialth .eq. 1) ialth = 2
if (meth .eq. meo) go to 110
call cfod  (meth, elco, tesco)
meo = meth
if (nq .gt. maxord) go to 120
ialth = l
iret = 1
go to 150
110 if (nq .le. maxord) go to 160
120 nq = maxord
l = lmax
do 125 i = 1,l
125 el(i) = elco(i,nq)
nqnyh = nq*nyh
rc = rc*el(1)/el0
el0 = el(1)
conit = 0.5e0/float(nq+2)
ddn = vnwrms (n, savf, ewt)/tesco(1,l)
exdn = 1.0e0/float(l)
rhdn = 1.0e0/(1.3e0*ddn**exdn + 0.0000013e0)
rh = amin1(rhdn,1.0e0)
iredo = 3
if (h .eq. hold) go to 170
rh = amin1(rh,abs(h/hold))
h = hold
go to 175
!-----------------------------------------------------------------------
! CFOD  is called to get all the integration coefficients for the
! current meth.  Then the EL vector and related constants are reset
! whenever the order NQ is changed, or at the start of the problem.
!-----------------------------------------------------------------------
140 call cfod  (meth, elco, tesco)
150 do 155 i = 1,l
155 el(i) = elco(i,nq)
nqnyh = nq*nyh
rc = rc*el(1)/el0
el0 = el(1)
conit = 0.5e0/float(nq+2)
go to (160, 170, 200), iret
!-----------------------------------------------------------------------
! If H is being changed, the H ratio RH is checked against
! RMAX, HMIN, and HMXI, and the YH array rescaled.  IALTH is set to
! L = NQ + 1 TO PREVENT A CHANGE OF H FOR THAT MANY STEPS, UNLESS
! forced by a convergence or error test failure.
!-----------------------------------------------------------------------
160 if (h .eq. hold) go to 200
rh = h/hold
h = hold
iredo = 3
go to 175
170 rh = amax1(rh,hmin/abs(h))
175 rh = amin1(rh,rmax)
rh = rh/amax1(1.0e0,abs(h)*hmxi*rh)
r = 1.0e0
do 180 j = 2,l
  r = r*rh
  do 180 i = 1,n
180 yh(i,j) = yh(i,j)*r
h = h*rh
rc = rc*rh
ialth = l
if (iredo .eq. 0) go to 680
!-----------------------------------------------------------------------
! This section computes the predicted values by effectively
! multiplying the YH array BY the Pascal triangle matrix.
! RC is the ratio of new to old values of the coefficient  H*EL(1).
! When RC differs from 1 by more than 30 percent, IPUP is set to miter
! to force PJAC to be called, if a Jacobian is involved.
! In any case, PJAC is called at least every 20-TH step.
!-----------------------------------------------------------------------
200 if (abs(rc-1.0e0) .gt. 0.3e0) ipup = miter
if (nst .ge. nstepj+20) ipup = miter
tn = tn + h
i1 = nqnyh + 1
do jb = 1,nq
  i1 = i1 - nyh
  do 210 i = i1,nqnyh
    ipnyh = i + nyh
210 yh1(i) = yh1(i) + yh1(ipnyh)
  end do
ksteps = ksteps + 1
!-----------------------------------------------------------------------
! Up to 3 corrector iterations are taken.  A convergence test is
! made on the R.M.S. Norm of each correction, weighted by the error
! weight vector EWT.  The sum of the corrections is accumulated in the
! vector ACOR(I).  The YH array is not altered in the corrector loop.
!-----------------------------------------------------------------------
220 m = 0
do 230 i = 1,n
230 y(i) = yh(i,1)
call f (tn, y, savf, rpar, ipar)
nfe = nfe + 1
if (ipup .le. 0) go to 250
!-----------------------------------------------------------------------
! IF INDICATED, THE MATRIX P = I - H*EL(1)*J IS REEVALUATED AND
! preprocessed before starting the corrector iteration.  IPUP is set
! to 0 as an indicator that this has been done.
!-----------------------------------------------------------------------
ipup = 0
rc = 1.0e0
nstepj = nst
crate = 0.7e0
call pjac (neq, y, yh, nyh, ewt, acor, savf, wm, iwm, f, jac, &
&rpar, ipar)
if (ier .ne. 0) go to 430
250 do 260 i = 1,n
260 acor(i) = 0.0e0
270 if (miter .ne. 0) go to 350
!-----------------------------------------------------------------------
! In the case of functional iteration, update Y directly from
! the result of the last function evaluation.
!-----------------------------------------------------------------------
do 290 i = 1,n
  savf(i) = h*savf(i) - yh(i,2)
290 y(i) = savf(i) - acor(i)
del = vnwrms (n, y, ewt)
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
call slvs (wm, iwm, y, savf)
if (ier .ne. 0) go to 410
del = vnwrms (n, y, ewt)
do 380 i = 1,n
  acor(i) = acor(i) + y(i)
380 y(i) = yh(i,1) + el(1)*acor(i)
!-----------------------------------------------------------------------
! TEST FOR CONVERGENCE.  IF M.GT.0, AN ESTIMATE OF THE CONVERGENCE
! rate constant is stored in crate, and this is used in the test.
!-----------------------------------------------------------------------
400 if (m .ne. 0) crate = amax1(0.2e0*crate,del/delp)
dcon = del*amin1(1.0e0,1.5e0*crate)/(tesco(2,nq)*conit)
if (dcon .le. 1.0e0) go to 450
m = m + 1
if (m .eq. 3) go to 410
if (m .ge. 2 .and. del .gt. 2.0e0*delp) go to 410
delp = del
call f (tn, y, savf, rpar, ipar)
nfe = nfe + 1
go to 270
!-----------------------------------------------------------------------
! The corrector iteration failed to converge in 3 tries.
! IF MITER .NE. 0 AND THE JACOBIAN IS OUT OF DATE, PJAC IS CALLED FOR
! the next try.  Otherwise the YH array is retracted to its values
! before prediction, and H is reduced, if possible.  If H cannot be
! REDUCED OR 10 FAILURES HAVE OCCURRED, EXIT WITH KFLAG = -2.
!-----------------------------------------------------------------------
410 if (ipup .eq. 0) go to 430
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
440 yh1(i) = yh1(i) - yh1(ipnyh)
  end do
if (abs(h) .le. hmin*1.00001e0) go to 670
if (ncf .eq. 10) go to 670
rh = 0.25e0
ipup = miter
iredo = 1
go to 170
!-----------------------------------------------------------------------
! THE CORRECTOR HAS CONVERGED.  IPUP IS SET TO -1 IF MITER .NE. 0,
! to signal that the Jacobian involved may need updating later.
! The local error test is made and control passes to statement 500
! if it fails.
!-----------------------------------------------------------------------
450 if (miter .ne. 0) ipup = -1
if (m .eq. 0) dsm = del/tesco(2,nq)
if (m .gt. 0) dsm = vnwrms (n, acor, ewt)/tesco(2,nq)
if (dsm .gt. 1.0e0) go to 500
!-----------------------------------------------------------------------
! After a successful step, update the YH array.
! CONSIDER CHANGING H IF IALTH = 1.  OTHERWISE DECREASE IALTH BY 1.
! IF IALTH IS THEN 1 AND NQ .LT. MAXORD, THEN ACOR IS SAVED FOR
! use in a possible order increase on the next step.
! If a change in H is considered, an increase or decrease in order
! by one is considered also.  A change in H is made only if it is by A
! factor of at least 1.1.  If not, IALTH is set to 3 to prevent
! testing for that many steps.
!-----------------------------------------------------------------------
kflag = 0
iredo = 0
nst = nst + 1
hu = h
nqu = nq
do 470 j = 1,l
  do 470 i = 1,n
470 yh(i,j) = yh(i,j) + el(j)*acor(i)
ialth = ialth - 1
if (ialth .eq. 0) go to 520
if (ialth .gt. 1) go to 690
if (l .eq. lmax) go to 690
do 490 i = 1,n
490 yh(i,lmax) = acor(i)
go to 690
!-----------------------------------------------------------------------
! The error test failed.  KFLAG keeps track of multiple failures.
! Restore TN and the YH array to their previous values, and prepare
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
510 yh1(i) = yh1(i) - yh1(ipnyh)
  end do
rmax = 2.0e0
if (abs(h) .le. hmin*1.00001e0) go to 660
if (kflag .le. -3) go to 640
iredo = 2
rhup = 0.0e0
go to 540
!-----------------------------------------------------------------------
! Regardless of the success or failure of the step, factors
! RHDN, RHSM, and RHUP are computed, by which H could be multiplied
! at order NQ - 1, order NQ, or order NQ + 1, respectively.
! IN THE CASE OF FAILURE, RHUP = 0.0 TO AVOID AN ORDER INCREASE.
! The largest of these is determined and the new order chosen
! accordingly.  If the order is to be increased, we compute one
! additional scaled derivative.
!-----------------------------------------------------------------------
520 rhup = 0.0e0
if (l .eq. lmax) go to 540
do 530 i = 1,n
530 savf(i) = acor(i) - yh(i,lmax)
dup = vnwrms (n, savf, ewt)/tesco(3,nq)
exup = 1.0e0/float(l+1)
rhup = 1.0e0/(1.4e0*dup**exup + 0.0000014e0)
540 exsm = 1.0e0/float(l)
rhsm = 1.0e0/(1.2e0*dsm**exsm + 0.0000012e0)
rhdn = 0.0e0
if (nq .eq. 1) go to 560
ddn = vnwrms (n, yh(1,l), ewt)/tesco(1,nq)
exdn = 1.0e0/float(nq)
rhdn = 1.0e0/(1.3e0*ddn**exdn + 0.0000013e0)
560 if (rhsm .ge. rhup) go to 570
if (rhup .gt. rhdn) go to 590
go to 580
570 if (rhsm .lt. rhdn) go to 580
newq = nq
rh = rhsm
go to 620
580 newq = nq - 1
rh = rhdn
if (kflag .lt. 0 .and. rh .gt. 1.0e0) rh = 1.0e0
go to 620
590 newq = l
rh = rhup
if (rh .lt. 1.1e0) go to 610
r = el(l)/float(l)
do 600 i = 1,n
600 yh(i,newq+1) = acor(i)*r
go to 630
610 ialth = 3
go to 690
620 if ((kflag .eq. 0) .and. (rh .lt. 1.1e0)) go to 610
if (kflag .le. -2) rh = amin1(rh,0.2e0)
!-----------------------------------------------------------------------
! If there is a change of order, reset NQ, L, and the coefficients.
! In any case H is reset according to RH and the YH array is rescaled.
! Then exit from 680 if the step was OK, or redo the step otherwise.
!-----------------------------------------------------------------------
if (newq .eq. nq) go to 170
630 nq = newq
l = nq + 1
iret = 2
go to 150
!-----------------------------------------------------------------------
! Control reaches this section if 3 or more failures have occured.
! IF 10 FAILURES HAVE OCCURRED, EXIT WITH KFLAG = -1.
! It is assumed that the derivatives that have accumulated in the
! YH array have errors of the wrong order.  Hence the first
! derivative is recomputed, and the order is set to 1.  Then
! H is reduced by a factor of 10, and the step is retried,
! until it succeeds or H reaches HMIN.
!-----------------------------------------------------------------------
640 if (kflag .eq. -10) go to 660
rh = 0.1e0
rh = amax1(hmin/abs(h),rh)
h = h*rh
do 645 i = 1,n
645 y(i) = yh(i,1)
call f (tn, y, savf, rpar, ipar)
nfe = nfe + 1
do 650 i = 1,n
650 yh(i,2) = h*savf(i)
ipup = miter
ialth = 5
if (nq .eq. 1) go to 200
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
!----------------------- End of subroutine STOD  -----------------------
end subroutine stod

subroutine cfod  (meth, elco, tesco)
implicit none
!
!   CFOD defines coefficients needed in the integrator package SFODE
!
integer, intent(in) :: meth
integer :: i, ib, nq, nqm1, nqp1
real, intent(inout) :: elco(13, *), tesco(3, *)
real :: agamq, fnq, fnqm1, pc(12), pint, ragq, rqfac, rq1fac, &
&tsign, xpin
!-----------------------------------------------------------------------
! CFOD  is called by the integrator routine to set coefficients
! needed there.  The coefficients for the current method, as
! given by the value of meth, are set for all orders and saved.
! THE MAXIMUM ORDER ASSUMED HERE IS 12 IF METH = 1 AND 5 IF METH = 2.
! (A smaller value of the maximum order is also allowed.)
! CFOD  is called once at the beginning of the problem,
! and is not called again unless and until meth is changed.
!
! The ELCO array contains the BASIC method coefficients.
! THE COEFFICIENTS EL(I), 1 .LE. I .LE. NQ+1, FOR THE METHOD OF
! order NQ are stored in ELCO(I,NQ).  They are given by a genetrating
! POLYNOMIAL, I.E.,
!     L(X) = EL(1) + EL(2)*X + ... + EL(NQ+1)*X**NQ.
! For the implicit Adams methods, L(X) is given by
!     DL/DX = (X+1)*(X+2)*...*(X+NQ-1)/FACTORIAL(NQ-1),    L(-1) = 0.
! For the BDF methods, L(X) is given by
!     L(X) = (X+1)*(X+2)* ... *(X+NQ)/K,
! WHERE         K = FACTORIAL(NQ)*(1 + 1/2 + ... + 1/NQ).
!
! The tesco array contains test constants used for the
! local error test and the selection of step size and/or order.
! At order NQ, TESCO(K,NQ) is used for the selection of step
! SIZE AT ORDER NQ - 1 IF K = 1, AT ORDER NQ IF K = 2, AND AT ORDER
! NQ + 1 IF K = 3.
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
!     P(X) = (X+1)*(X+2)*...*(X+NQ-1).
! INITIALLY, P(X) = 1.
!-----------------------------------------------------------------------
  rq1fac = rqfac
  rqfac = rqfac/float(nq)
  nqm1 = nq - 1
  fnqm1 = float(nqm1)
  nqp1 = nq + 1
! Form coefficients of P(X)*(X+NQ-1). ----------------------------------
  pc(nq) = 0.0e0
  do 110 ib = 1,nqm1
    i = nqp1 - ib
110 pc(i) = pc(i-1) + fnqm1*pc(i)
  pc(1) = fnqm1*pc(1)
! Compute integral, -1 to 0, of P(X) and X*P(X). -----------------------
  pint = pc(1)
  xpin = pc(1)/2.0e0
  tsign = 1.0e0
  do 120 i = 2,nq
    tsign = -tsign
    pint = pint + tsign*pc(i)/float(i)
120 xpin = xpin + tsign*pc(i)/float(i+1)
! Store coefficients in ELCO and tesco. --------------------------------
  elco(1,nq) = pint*rq1fac
  elco(2,nq) = 1.0e0
  do 130 i = 2,nq
130 elco(i+1,nq) = rq1fac*pc(i)/float(i)
  agamq = rqfac*xpin
  ragq = 1.0e0/agamq
  tesco(2,nq) = ragq
if(nq.lt.12)tesco(1,nqp1)=ragq*rqfac/float(nqp1)
  tesco(3,nqm1) = ragq
  end do
return
!
200 pc(1) = 1.0e0
rq1fac = 1.0e0
do nq = 1,5
!-----------------------------------------------------------------------
! The PC array will contain the coefficients of the polynomial
!     P(X) = (X+1)*(X+2)*...*(X+NQ).
! INITIALLY, P(X) = 1.
!-----------------------------------------------------------------------
  fnq = float(nq)
  nqp1 = nq + 1
! Form coefficients of P(X)*(X+NQ). ------------------------------------
  pc(nqp1) = 0.0e0
  do 210 ib = 1,nq
    i = nq + 2 - ib
210 pc(i) = pc(i-1) + fnq*pc(i)
  pc(1) = fnq*pc(1)
! Store coefficients in ELCO and tesco. --------------------------------
  do 220 i = 1,nqp1
220 elco(i,nq) = pc(i)/pc(2)
  elco(2,nq) = 1.0e0
  tesco(1,nq) = rq1fac
  tesco(2,nq) = float(nqp1)/elco(1,nq)
  tesco(3,nq) = float(nq+2)/elco(1,nq)
  rq1fac = rq1fac/fnq
  end do
return
!----------------------- End of subroutine CFOD  -----------------------
end subroutine cfod

subroutine pjac (neq, y, yh, nyh, ewt, ftem, savf, wm, iwm, &
&f, jac, rpar, ipar)
implicit none
integer :: ipar(*)
real :: rpar(*)
!
!   PJAC sets up the iteration matrix (involving the Jacobian) for the
!   integration package SFODE.
!
!***ROUTINES CALLED  VNWRMS,SGEFA,SGBFA
!
integer :: neq, nyh, iwm( *), i, i1, i2, ier, ii, iownd, iowns, j, &
&j1, jj, jstart, kflag, l, lenp, maxord, mba, mband, meb1, meband, &
&meth, miter, ml, ml3, mu, n, nfe, nje, nq, nqu, nst
external f, jac
real :: y(*), yh(nyh,*), ewt(*), ftem(*), savf(*), wm(*), rownd, &
&rowns, el0, h, hmin, hmxi, hu, tn, uround, con, di, fac, hl0, r, &
&r0, srur, yi, yj, yjj, vnwrms
common /debdf1/ rownd, rowns(210), &
&el0, h, hmin, hmxi, hu, tn, uround, iownd(14), iowns(6), &
&ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
&nje, nqu
!-----------------------------------------------------------------------
! PJAC is called by STOD  to compute and process the matrix
! P = I - H*EL(1)*J , WHERE J IS AN APPROXIMATION TO THE JACOBIAN.
! Here J is computed by the user-supplied routine JAC if
! MITER = 1 OR 4, OR BY FINITE DIFFERENCING IF MITER = 2, 3, OR 5.
! IF MITER = 3, A DIAGONAL APPROXIMATION TO J IS USED.
! J IS STORED IN WM AND REPLACED BY P.  IF MITER .NE. 3, P IS THEN
! subjected to LU decomposition in preparation for later solution
! of linear systems with P as coefficient matrix. This is done
! BY SGEFA IF MITER = 1 OR 2, AND BY SGBFA IF MITER = 4 OR 5.
!
! In addition to variables described previously, communication
! with PJAC uses the following..
! Y    = ARRAY CONTAINING PREDICTED VALUES ON ENTRY.
! FTEM = WORK ARRAY OF LENGTH N (ACOR IN STOD ).
! SAVF = ARRAY CONTAINING F EVALUATED AT PREDICTED Y.
! WM   = REAL WORK SPACE FOR MATRICES.  ON OUTPUT IT CONTAINS THE
!        INVERSE DIAGONAL MATRIX IF MITER = 3 AND THE LU DECOMPOSITION
!        of P if miter is 1, 2 , 4, or 5.
!        Storage of matrix elements starts at WM(3).
!        WM also contains the following matrix-related data..
!        WM(1) = SQRT(UROUND), USED IN NUMERICAL JACOBIAN INCREMENTS.
!        WM(2) = H*EL0, SAVED FOR LATER USE IF MITER = 3.
! IWM  = INTEGER WORK SPACE CONTAINING PIVOT INFORMATION, STARTING AT
!        IWM(21), if miter is 1, 2, 4, or 5.  IWM also contains the
!        BAND PARAMETERS ML = IWM(1) AND MU = IWM(2) IF MITER IS 4 OR 5.
! EL0  = EL(1) (INPUT).
! IER  = OUTPUT ERROR FLAG,  = 0 IF NO TROUBLE, .NE. 0 IF
!        P matrix FOUND to be singular.
! This routine also uses the common variables EL0, H, TN, UROUND,
! miter, N, NFE, and NJE.
!-----------------------------------------------------------------------
nje = nje + 1
hl0 = h*el0
go to (100, 200, 300, 400, 500), miter
! IF MITER = 1, CALL JAC AND MULTIPLY BY SCALAR. -----------------------
100 lenp = n*n
do 110 i = 1,lenp
110 wm(i+2) = 0.0e0
call jac (tn, y, wm(3), n, rpar, ipar)
con = -hl0
do 120 i = 1,lenp
120 wm(i+2) = wm(i+2)*con
go to 240
! IF MITER = 2, MAKE N CALLS TO F TO APPROXIMATE J. --------------------
200 fac = vnwrms (n, savf, ewt)
r0 = 1000.0e0*abs(h)*uround*float(n)*fac
if (r0 .eq. 0.0e0) r0 = 1.0e0
srur = wm(1)
j1 = 2
do j = 1,n
  yj = y(j)
  r = amax1(srur*abs(yj),r0*ewt(j))
  y(j) = y(j) + r
  fac = -hl0/r
  call f (tn, y, ftem, rpar, ipar)
  do 220 i = 1,n
220 wm(i+j1) = (ftem(i) - savf(i))*fac
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
call sgefa (wm(3), n, n, iwm(21), ier)
return
! IF MITER = 3, CONSTRUCT A DIAGONAL APPROXIMATION TO J AND P. ---------
300 wm(2) = hl0
ier = 0
r = el0*0.1e0
do 310 i = 1,n
310 y(i) = y(i) + r*(h*savf(i) - yh(i,2))
call f (tn, y, wm(3), rpar, ipar)
nfe = nfe + 1
do 320 i = 1,n
  r0 = h*savf(i) - yh(i,2)
  di = 0.1e0*r0 - h*(wm(i+2) - savf(i))
  wm(i+2) = 1.0e0
  if (abs(r0) .lt. uround*ewt(i)) go to 320
  if (abs(di) .eq. 0.0e0) go to 330
  wm(i+2) = 0.1e0*r0/di
320 continue
return
330 ier = -1
return
! IF MITER = 4, CALL JAC AND MULTIPLY BY SCALAR. -----------------------
400 ml = iwm(1)
mu = iwm(2)
ml3 =  3
mband = ml + mu + 1
meband = mband + ml
lenp = meband*n
do 410 i = 1,lenp
410 wm(i+2) = 0.0e0
call jac (tn, y, wm(ml3), meband, rpar, ipar)
con = -hl0
do 420 i = 1,lenp
420 wm(i+2) = wm(i+2)*con
go to 570
! IF MITER = 5, MAKE MBAND CALLS TO F TO APPROXIMATE J. ----------------
500 ml = iwm(1)
mu = iwm(2)
mband = ml + mu + 1
mba = min0(mband,n)
meband = mband + ml
meb1 = meband - 1
srur = wm(1)
fac = vnwrms (n, savf, ewt)
r0 = 1000.0e0*abs(h)*uround*float(n)*fac
if (r0 .eq. 0.0e0) r0 = 1.0e0
do j = 1,mba
  do 530 i = j,n,mband
    yi = y(i)
    r = amax1(srur*abs(yi),r0*ewt(i))
530 y(i) = y(i) + r
  call f (tn, y, ftem, rpar, ipar)
  do jj = j,n,mband
    y(jj) = yh(jj,1)
    yjj = y(jj)
    r = amax1(srur*abs(yjj),r0*ewt(jj))
    fac = -hl0/r
    i1 = max0(jj-mu,1)
    i2 = min0(jj+ml,n)
    ii = jj*meb1 - ml + 2
    do 540 i = i1,i2
540 wm(ii+i) = (ftem(i) - savf(i))*fac
    end do
  end do
nfe = nfe + mba
! Add identity matrix. -------------------------------------------------
570 ii = mband + 2
do 580 i = 1,n
  wm(ii) = wm(ii) + 1.0e0
580 ii = ii + meband
! Do LU decomposition of P. --------------------------------------------
call sgbfa (wm(3), meband, n, ml, mu, iwm(21), ier)
return
!----------------------- End of subroutine PJAC -----------------------
end subroutine pjac

subroutine slvs (wm, iwm, x, tem)
implicit none
!
!   SLVS solves the linear system in the iteration scheme for the
!   integrator package SFODE.
!
!***ROUTINES CALLED  SGESL,SGBSL
!
integer :: iwm( *), i, ier, iownd, iowns, jstart, kflag, l, &
&maxord, meband, meth, miter, ml, mu, n, nfe, nje, nq, nqu, nst
real :: wm(*), x(*), tem(*), rownd, rowns, el0, h, hmin, hmxi, hu, &
&tn, uround, di, hl0, phl0, r
common /debdf1/ rownd, rowns(210), &
&el0, h, hmin, hmxi, hu, tn, uround, iownd(14), iowns(6), &
&ier, jstart, kflag, l, meth, miter, maxord, n, nq, nst, nfe, &
&nje, nqu
!-----------------------------------------------------------------------
! THIS ROUTINE MANAGES THE SOLUTION OF THE LINEAR SYSTEM ARISING FROM
! A CHORD ITERATION.  IT IS CALLED BY STOD  IF MITER .NE. 0.
! IF MITER IS 1 OR 2, IT CALLS SGESL TO ACCOMPLISH THIS.
! IF MITER = 3 IT UPDATES THE COEFFICIENT H*EL0 IN THE DIAGONAL
! MATRIX, AND THEN COMPUTES THE SOLUTION.
! IF MITER IS 4 OR 5, IT CALLS SGBSL.
! COMMUNICATION WITH SLVS USES THE FOLLOWING VARIABLES..
! WM  = REAL WORK SPACE CONTAINING THE INVERSE DIAGONAL MATRIX IF MITER
!       IS 3 AND THE LU DECOMPOSITION OF THE MATRIX OTHERWISE.
!       STORAGE OF MATRIX ELEMENTS STARTS AT WM(3).
!       WM ALSO CONTAINS THE FOLLOWING MATRIX-RELATED DATA..
!       WM(1) = SQRT(UROUND) (NOT USED HERE),
!       WM(2) = HL0, THE PREVIOUS VALUE OF H*EL0, USED IF MITER = 3.
! IWM = INTEGER WORK SPACE CONTAINING PIVOT INFORMATION, STARTING AT
!       IWM(21), IF MITER IS 1, 2, 4, OR 5.  IWM ALSO CONTAINS THE
!       BAND PARAMETERS ML = IWM(1) AND MU = IWM(2) IF MITER IS 4 OR 5.
! X   = THE RIGHT-HAND SIDE VECTOR ON INPUT, AND THE SOLUTION VECTOR
!       ON OUTPUT, OF LENGTH N.
! TEM = VECTOR OF WORK SPACE OF LENGTH N, NOT USED IN THIS VERSION.
! IER = OUTPUT FLAG (IN COMMON).  IER = 0 IF NO TROUBLE OCCURRED.
!       IER = -1 IF A SINGULAR MATRIX AROSE WITH MITER = 3.
! THIS ROUTINE ALSO USES THE COMMON VARIABLES EL0, H, MITER, AND N.
!-----------------------------------------------------------------------
ier = 0
go to (100, 100, 300, 400, 400), miter
100 call sgesl (wm(3), n, n, iwm(21), x, 0)
return
!
300 phl0 = wm(2)
hl0 = h*el0
wm(2) = hl0
if (hl0 .eq. phl0) go to 330
r = hl0/phl0
do 320 i = 1,n
  di = 1.0e0 - r*(1.0e0 - 1.0e0/wm(i+2))
  if (abs(di) .eq. 0.0e0) go to 390
320 wm(i+2) = 1.0e0/di
330 do 340 i = 1,n
340 x(i) = wm(i+2)*x(i)
return
390 ier = -1
return
!
400 ml = iwm(1)
mu = iwm(2)
meband = 2*ml + mu + 1
call sgbsl (wm(3), meband, n, ml, mu, iwm(21), x, 0)
return
!----------------------- End of subroutine SLVS -----------------------
end subroutine slvs

subroutine sgbfa(abd,lda,n,ml,mu,ipvt,info)
implicit none
integer, intent(in) :: lda, n, ml, mu
integer, intent(inout) :: ipvt(*)
integer, intent(out) :: info
real, intent(inout) :: abd(lda,*)
!
!     SGBFA factors a real band matrix BY elimination.
!
!     SGBFA is usually called by SGBCO, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!
!     On entry
!
!        ABD     REAL(LDA, N)
!                contains the matrix in band storage.  The columns
!                of the matrix are stored in the columns of  abd  and
!                the diagonals of the matrix are stored in rows
!                ML+1 through 2*ML+mu+1 of  abd .
!                See the comments below for details.
!
!        LDA     INTEGER
!                the leading dimension of the array  ABD .
!                LDA MUST BE .GE. 2*ML + MU + 1 .
!
!        N       INTEGER
!                the order of the original matrix.
!
!        ML      INTEGER
!                number of diagonals below the main diagonal.
!                0 .LE. ML .LT. N .
!
!        MU      INTEGER
!                number of diagonals above the main diagonal.
!                0 .LE. MU .LT. N .
!                MORE EFFICIENT IF  ML .LE. MU .
!     On return
!
!        ABD     AN UPPER TRIANGULAR MATRIX IN BAND STORAGE AND
!                the multipliers which were used to obtain it.
!                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
!                L  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        IPVT    INTEGER(N)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                = 0  NORMAL VALUE.
!                = K  IF  U(K,K) .EQ. 0.0 .  THIS IS NOT AN ERROR
!                     condition for this subroutine, but it does
!                     indicate that SGBSL will divide by zero if
!                     called.  Use  RCOND  in SGBCO for a reliable
!                     indication of singularity.
!
!     Band storage
!
!           If  A  is a band matrix, the following program segment
!           will set up the input.
!
!                   ML = (BAND WIDTH BELOW THE DIAGONAL)
!                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
!                   M = ML + MU + 1
!                   DO 20 J = 1, N
!                      I1 = MAX0(1, J-MU)
!                      I2 = MIN0(N, J+ML)
!                      DO 10 I = I1, I2
!                         K = I - J + M
!                         ABD(K,J) = A(I,J)
!                10    CONTINUE
!                20 continue
!
!           This uses rows  ML+1  through  2*ML+mu+1  of  abd .
!           In addition, the first  ML  rows in  abd  are used for
!           elements generated during the triangularization.
!           The total number of rows needed in  abd  is  2*ML+mu+1 .
!           The  ML+mu by ML+mu  upper left triangle and the
!           ML by ML  lower right triangle are not referenced.
!
!     LINPACK. THIS VERSION DATED 08/14/78 .
!     CLEVE MOLER, UNIVERSITY OF NEW MEXICO, ARGONNE NATIONAL LAB.
!
!     Subroutines and functions
!
!     BLAS SAXPY,SSCAL,ISAMAX
!     FORTRAN MAX0,MIN0
!
real :: t
integer :: i, isamax, i0, j, ju, jz, j0, j1, k, kp1, l, lm, m, mm, &
&nm1
!
m = ml + mu + 1
info = 0
!
!     Zero initial fill-in columns
!
j0 = mu + 2
j1 = min0(n,m) - 1
if (j1 .lt. j0) go to 30
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
if (nm1 .lt. 1) go to 130
do k = 1, nm1
   kp1 = k + 1
!
!        Zero next fill-in column
!
   jz = jz + 1
   if (jz .gt. n) go to 50
   if (ml .lt. 1) go to 50
      do i = 1, ml
         abd(i,jz) = 0.0e0
      end do
50 continue
!
!        FIND L = PIVOT INDEX
!
   lm = min0(ml,n-k)
   l = isamax(lm+1,abd(m,k),1) + m - 1
   ipvt(k) = l + k - m
!
!        Zero pivot implies this column already triangularized
!
   if (abd(l,k) .eq. 0.0e0) go to 100
!
!           Interchange if necessary
!
      if (l .eq. m) go to 60
         t = abd(l,k)
         abd(l,k) = abd(m,k)
         abd(m,k) = t
60 continue
!
!           Compute multipliers
!
      t = -1.0e0/abd(m,k)
      call sscal(lm,t,abd(m+1,k),1)
!
!           Row elimination with column indexing
!
      ju = min0(max0(ju,mu+ipvt(k)),n)
      mm = m
      if (ju .lt. kp1) go to 90
      do j = kp1, ju
         l = l - 1
         mm = mm - 1
         t = abd(l,j)
         if (l .eq. mm) go to 70
            abd(l,j) = abd(mm,j)
            abd(mm,j) = t
70 continue
         call saxpy(lm,t,abd(m+1,k),1,abd(mm+1,j),1)
      end do
90 continue
   go to 110
100 continue
      info = k
110 continue
end do
130 continue
ipvt(n) = n
if (abd(m,n) .eq. 0.0e0) info = n
return
end subroutine sgbfa

subroutine sgbsl(abd,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, ipvt(*), job
real, intent(in) :: abd(lda,*)
real, intent(inout) :: b(*)
!
!     SGBSL solves the real band system
!     A * X = B  OR  TRANS(A) * X = B
!     using the factors computed by SGBCO or SGBFA.
!
!     On entry
!
!        ABD     REAL(LDA, N)
!                the output from SGBCO or SGBFA.
!
!        LDA     INTEGER
!                the leading dimension of the array  ABD .
!
!        N       INTEGER
!                the order of the original matrix.
!
!        ML      INTEGER
!                number of diagonals below the main diagonal.
!
!        MU      INTEGER
!                number of diagonals above the main diagonal.
!
!        IPVT    INTEGER(N)
!                the pivot vector from SGBCO or SGBFA.
!
!        B       REAL(N)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  A*X = B ,
!                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
!                            TRANS(A)  is the transpose.
!
!     On return
!
!        B       THE SOLUTION VECTOR  X .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of LDA .  It will not occur if the subroutines are
!        CALLED CORRECTLY AND IF SGBCO HAS SET RCOND .GT. 0.0
!        OR SGBFA HAS SET INFO .EQ. 0 .
!
!     To compute  INVERSE(A) * C  where  C  is a matrix
!     with  P  columns
!           CALL SGBCO(ABD,LDA,N,ML,MU,IPVT,RCOND,Z)
!           IF (RCOND IS TOO SMALL) GO TO ...
!           DO 10 J = 1, P
!              CALL SGBSL(ABD,LDA,N,ML,MU,IPVT,C(1,J),0)
!        10 continue
!
!     LINPACK. THIS VERSION DATED 08/14/78 .
!     CLEVE MOLER, UNIVERSITY OF NEW MEXICO, ARGONNE NATIONAL LAB.
!
!     Subroutines and functions
!
!     BLAS SAXPY,SDOT
!     FORTRAN MIN0
!
real :: sdot, t
integer :: k, kb, l, la, lb, lm, m, nm1
!
m = mu + ml + 1
nm1 = n - 1
if (job .ne. 0) go to 50
!
!        JOB = 0 , SOLVE  A * X = B
!        FIRST SOLVE L*Y = B
!
   if (ml .eq. 0) go to 30
   if (nm1 .lt. 1) go to 30
      do k = 1, nm1
         lm = min0(ml,n-k)
         l = ipvt(k)
         t = b(l)
         if (l .eq. k) go to 10
            b(l) = b(k)
            b(k) = t
10 continue
         call saxpy(lm,t,abd(m+1,k),1,b(k+1),1)
      end do
30 continue
!
!        NOW SOLVE  U*X = Y
!
   do kb = 1, n
      k = n + 1 - kb
      b(k) = b(k)/abd(m,k)
      lm = min0(k,m) - 1
      la = m - lm
      lb = k - lm
      t = -b(k)
      call saxpy(lm,t,abd(la,k),1,b(lb),1)
   end do
go to 100
50 continue
!
!        JOB = NONZERO, SOLVE  TRANS(A) * X = B
!        FIRST SOLVE  TRANS(U)*Y = B
!
   do k = 1, n
      lm = min0(k,m) - 1
      la = m - lm
      lb = k - lm
      t = sdot(lm,abd(la,k),1,b(lb),1)
      b(k) = (b(k) - t)/abd(m,k)
   end do
!
!        NOW SOLVE TRANS(L)*X = Y
!
   if (ml .eq. 0) go to 90
   if (nm1 .lt. 1) go to 90
      do kb = 1, nm1
         k = n - kb
         lm = min0(ml,n-k)
         b(k) = b(k) + sdot(lm,abd(m+1,k),1,b(k+1),1)
         l = ipvt(k)
         if (l .eq. k) go to 70
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
!     Compute the maximum norm of the vector V(*) of length NCOMP and
!     RETURN THE RESULT AS VNORM
!
!
vnorm=0.
do 10 k = 1,ncomp
10 vnorm=amax1(vnorm,abs(v(k)))
return
end function vnorm

real function vnwrms (n, v, w)
implicit none
!-----------------------------------------------------------------------
! This function routine computes the weighted root-mean-square norm
! of the vector of length N contained in the array V, with weights
! contained in the array W of length N..
!   VNWRMS = SQRT( (1/N) * SUM( V(I)/W(I) )**2 )
!-----------------------------------------------------------------------
integer, intent(in) :: n
integer :: i
real :: v(n), w(n), sum
!
sum = 0.0e0
do 10 i = 1,n
10 sum = sum + (v(i)/w(i))**2
vnwrms = sqrt(sum/float(n))
return
!----------------------- End of function VNWRMS ------------------------
end function vnwrms

subroutine rk(n,t,h,a,f)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(*)
real, intent(in) :: h
real, intent(inout) :: t
integer :: k, m, m1, mk, nk, np1
real :: ha, ta
!     ******************************************************************
!     FOURTH ORDER RUNGE-KUTTA PROCEDURE FOR SOLVING DY=F(T,Y)
!     ******************************************************************
external f
np1=n+1
if (h.eq.0.0) go to 50
!
ha=.5*h
ta=t+ha
m=n+n
m1=m+1
!
do 10 k = 1,n
nk=n+k
mk=m+k
a(nk)=ha*a(nk)
10 a(mk)=a(k)+a(nk)
call f(ta,a(m1))
!
do 20 k = 1,n
nk=n+k
mk=m+k
a(nk)=a(nk)+h*a(mk)
20 a(mk)=a(k)+ha*a(mk)
call f(ta,a(m1))
!
t=t+h
do 30 k = 1,n
nk=n+k
mk=m+k
a(mk)=h*a(mk)
a(nk)=a(nk)+a(mk)
30 a(mk)=a(k)+a(mk)
call f(t,a(m1))
!
do 40 k = 1,n
nk=n+k
mk=m+k
a(k)=a(k)+(a(nk)+ha*a(mk))/3.0
40 a(nk)=a(k)
call f(t,a(np1))
return
!
50 do 51 k = 1,n
nk=n+k
51 a(nk)=a(k)
call f(t,a(np1))
return
end subroutine rk

subroutine rk8(n,t,h,y,dy,w,f)
implicit none
integer, intent(in) :: n
real :: h
real, intent(inout) :: t
integer :: i, j, k, l, m, m1
real :: ha, sum
!     ******************************************************************
!     EIGHTH ORDER RUNGE-KUTTA PROCEDURE FOR SOLVING DY=F(T,Y)
!     ******************************************************************
real, intent(inout) :: y(n), dy(n), w(*)
real :: a(7), b(8,7), c(7), d(9)
external f
!     -------------------
data a(1)/.3333333333333333/,  a(2)/.5/,  a(3)/.6666666666666666/, &
&a(4)/.1666666666666666/,  a(5)/1./,  a(6)/.8333333333333333/, &
&a(7)/1./
data b(1,1)/1./,  b(2,1)/3./
data b(1,2)/1./,  b(2,2)/0./,  b(3,2)/3./
data b(1,3)/13./,  b(2,3)/-27./,  b(3,3)/42./,  b(4,3)/8./
data b(1,4)/389./,  b(2,4)/-54./,  b(3,4)/966./,  b(4,4)/-824./, &
&b(5,4)/243./
data b(1,5)/-231./,  b(2,5)/81./,  b(3,5)/-1164./,  b(4,5)/656./, &
&b(5,5)/-122./,  b(6,5)/800./
data b(1,6)/-127./,  b(2,6)/18./,  b(3,6)/-678./,  b(4,6)/456./, &
&b(5,6)/-9./,  b(6,6)/576./,  b(7,6)/4./
data b(1,7)/1481./,  b(2,7)/-81./,  b(3,7)/7104./, &
&b(4,7)/-3376./,  b(5,7)/72./,  b(6,7)/-5040./, &
&b(7,7)/-60./,  b(8,7)/720./
data c(1)/12./,  c(2)/8./,  c(3)/54./,  c(4)/4320./,  c(5)/20./, &
&c(6)/288./,  c(7)/820./
data d(1)/41./,  d(2)/0./,  d(3)/27./,  d(4)/272./,  d(5)/27./, &
&d(6)/216./,  d(7)/0./,  d(8)/216./,  d(9)/41./
!     -------------------
if (h.eq.0.) go to 40
ha=h*4./27.
do 10 k = 1,n
10 w(k)=y(k)+ha*dy(k)
call f(t+ha,w(1))
do 11 k = 1,n
11 w(k)=y(k)+h*(dy(k)/18.+w(k)/6.)
call f(t+h*2./9.,w(1))
!
i=1
do 22 m = 2,8
i=i+n
m1=m-1
do 21 k = 1,n
sum=b(1,m1)*dy(k)
l=k
do 20 j = 2,m
sum=sum+b(j,m1)*w(l)
20 l=l+n
21 w(l)=y(k)+sum*h/c(m1)
22 call f(t+a(m1)*h,w(i))
!
do 31 k = 1,n
sum=d(1)*dy(k)
l=k
do 30 m = 2,9
sum=sum+d(m)*w(l)
30 l=l+n
y(k)=y(k)+h*sum/840.
31 dy(k)=y(k)
t=t+h
call f(t,dy)
return
!
40 do 41 k = 1,n
41 dy(k)=y(k)
call f(t,dy)
return
end subroutine rk8

subroutine sepde (cofx, cofy, g, edge, bval, iord, a, b, mp1, &
&c, d, np1, u, ku, w, nw, ierr)
implicit none
integer, intent(inout) :: ierr
integer :: iord, ku, mp1
integer, intent(in) :: np1
integer, intent(inout) :: nw
real :: a, b, c, d
integer :: i, ia, ib, ic, id, ij, imax, imin, indx, indy, iw, j, &
&jcol, jmax, jmin, l, m, mn, n
real :: alpha, beta, del, gam, hx, hy, p, xi, xmin, yj, ymin
real :: g
real :: bval
! ----------------------------------------------------------------------
!     Solution of separable elliptic partial differential equations
!                     on rectangular domains
! ----------------------------------------------------------------------
real, intent(inout) :: u(ku,np1), w(nw)
real :: dum(1)
integer, intent(in) :: edge(4)
external cofx, cofy
!     --------------
data alpha/0.0/, beta/0.0/, gam/0.0/, del/0.0/
!     --------------
call pdedge (edge, indx, indy, ierr)
if (ierr .ne. 0) return
!
if (a .ge. b .or. c .ge. d) go to 300
if (mp1 .lt. 7) go to 320
if (np1 .lt. 6) go to 330
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
if (edge(1) .ne. 0) go to 10
jmin = 2
ymin = c + hy
jcol = mp1
10 if (edge(2) .ne. 0) go to 20
imin = 2
xmin = a + hx
20 if (edge(3) .eq. 0) jmax = n
if (edge(4) .eq. 0) imax = m
!
!     DEFINE THE RIGHT-HAND SIDE MATRIX FOR IORD = 2
!
if (ku .lt. mp1) go to 310
if (iord .ne. 2) go to 40
mn = 0
!
yj = ymin
do 31 j = jmin,jmax
xi = xmin
   do 30 i = imin,imax
   u(i,j) = g(xi, yj)
30 xi = xi + hx
31 yj = yj + hy
go to 60
!
!     DEFINE THE RIGHT-HAND SIDE MATRIX FOR IORD = 4
!
40 if (iord .ne. 4) go to 340
mn = mp1*np1
if (mn .ge. nw) go to 100
!
yj = ymin
do 51 j = jmin,jmax
xi = xmin
   do 50 i = imin,imax
   ij = i + jcol
   w(ij) = g(xi, yj)
50 xi = xi + hx
yj = yj + hy
51 jcol = jcol + mp1
!
!     Store the boundary values of U
!
60 if (edge(1) .ne. 0) go to 70
xi = a
do 61 i = 1,mp1
   u(i,1) = bval(1,xi,c)
61 xi = xi + hx
!
70 if (edge(2) .ne. 0) go to 80
yj = c
do 71 j = 1,np1
   u(1,j) = bval(2,a,yj)
71 yj = yj + hy
!
80 if (edge(3) .ne. 0) go to 90
xi = a
do 81 i = 1,mp1
   u(i,np1) = bval(3,xi,d)
81 xi = xi + hx
!
90 if (edge(4) .ne. 0) go to 100
yj = c
do 91 j = 1,np1
   u(mp1,j) = bval(4,b,yj)
91 yj = yj + hy
!
!     Store the mixed boundary conditions
!
100 ic = mn + 1
if (edge(1) .ne. 1) go to 120
mn = mn + mp1
if (mn .ge. nw) go to 120
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
if (edge(2) .ne. 1) go to 140
mn = mn + np1
if (mn .ge. nw) go to 140
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
if (edge(3) .ne. 1) go to 160
mn = mn + mp1
if (mn .ge. nw) go to 160
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
if (edge(4) .ne. 1) go to 200
mn = mn + np1
if (mn .ge. nw) go to 200
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
200 if (mn .ge. nw) go to 350
iw = mn + 1
w(iw) = nw - mn
if (iord .eq. 4) go to 210
!
call sepell (0, iord, a, b, m, indx, w(ia), alpha, w(ib), beta, &
&c, d, n, indy, w(ic), gam, w(id), del, cofx, cofy, &
&u, ku, u, ku, w(iw), p, ierr)
go to 220
!
210 call sepell (0, iord, a, b, m, indx, w(ia), alpha, w(ib), beta, &
&c, d, n, indy, w(ic), gam, w(id), del, cofx, cofy, &
&w(1),mp1, u, ku, w(iw), p, ierr)
!
220 nw = w(iw) + mn
if (ierr .ne. 0) return
if (p .eq. 0.0) return
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
call sepell (0, iord, a, b, m, indx, dum, alpha, dum, beta, &
&c, d, n, indy, dum, gam, dum, del, cofx, cofy, &
&u, ku, u, ku, dum, p, ierr)
nw = dum(1) + mn
return
end subroutine sepde

subroutine pdedge (edge, indx, indy, ierr)
implicit none
integer, intent(inout) :: ierr, indx, indy
integer, intent(in) :: edge(4)
!
if (iabs(edge(1)) .gt. 1) go to 200
if (iabs(edge(2)) .gt. 1) go to 200
if (iabs(edge(3)) .gt. 1) go to 200
if (iabs(edge(4)) .gt. 1) go to 200
ierr = 0
!
!               Process edges 1 and 3
!
if (edge(1)) 10,20,30
!
10 if (edge(3) .ne. -1) go to 210
indy = 0
go to 100
!
20 if (edge(3) .eq. -1) go to 210
indy = 1 + edge(3)
go to 100
!
30 if (edge(3) .eq. -1) go to 210
indy = 4 - edge(3)
!
!               Process edges 2 and 4
!
100 if (edge(2)) 110,120,130
!
110 if (edge(4) .ne. -1) go to 220
indx = 0
return
!
120 if (edge(4) .eq. -1) go to 220
indx = 1 + edge(4)
return
!
130 if (edge(4) .eq. -1) go to 220
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

subroutine sepell (intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c, &
&d,n,nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,grhs,mn, &
&usol,idmn,w,pertrb,ierror)
implicit none
integer :: idmn
integer, intent(inout) :: ierror
integer :: intl, iorder, m, mbdcnd, mn, n, nbdcnd
real :: a, alpha, b, beta, c, d, gama
real, intent(inout) :: pertrb
real :: xnu
integer :: i1, i10, i11, i12, i13, i2, i3, i4, i5, i6, i7, i8, i9, &
&k, l, length, linput, ll, logb2n, loutpt
!
!
! DIMENSION OF           BDA(N+1), BDB(N+1), BDC(M+1), BDD(M+1),
! ARGUMENTS              USOL(IDMN,N+1), GRHS(MN,N+1),
!                        W (see argument list)
!
! LATEST REVISION        JANUARY 1978 (BY THE AUTHORS)
!                        MODIFIED 1986 BY A.H. MORRIS (NSWC)
!
! PURPOSE                SEPELL SOLVES FOR EITHER THE SECOND-ORDER
!                        finite difference approximation or A
!                        fourth-order approximation to a separable
!                        elliptic equation
!
!                                    2    2
!                             AF(X)*D U/DX + BF(X)*DU/DX  + CF(X)*U +
!                                    2    2
!                             DF(Y)*D U/DY  + EF(Y)*DU/DY + FF(Y)*U
!
!                             = G(X,Y)
!
!                        On a rectangle (X greater than or equal to A
!                        and less than or equal to B, Y greater than
!                        or equal to C and less than or equal to D).
!                        Any combination of periodic or mixed boundary
!                        conditions is allowed.
!
! PURPOSE                THE POSSIBLE BOUNDARY CONDITIONS ARE ...
!                        In the X-direction..
!                         (0) PERIODIC, U(X+B-A,Y)=U(X,Y) FOR ALL Y,X
!                         (1) U(A,Y), U(B,Y) are specified for all Y
!                         (2) U(A,Y), DU(B,Y)/DX+beta*U(B,Y) are
!                             specified for all Y
!                         (3) DU(A,Y)/DX+ALPHA*U(A,Y),DU(B,Y)/DX+
!                             beta*U(B,Y) are specified for all Y
!                         (4) DU(A,Y)/DX+alpha*U(A,Y),U(B,Y) are
!                             specified for all Y
!
!                        In the Y-direction..
!                         (0) PERIODIC, U(X,Y+D-C)=U(X,Y) FOR ALL X,Y
!                         (1) U(X,C),U(X,D) are specified for all X
!                         (2) U(X,C),DU(X,D)/DY+XNU*U(X,D) are specified
!                             for all X
!                         (3) DU(X,C)/DY+GAMA*U(X,C),DU(X,D)/DY+
!                             XNU*U(X,D) are specified for all X
!                         (4) DU(X,C)/DY+gama*U(X,C),U(X,D) are
!                             specified for all X
!
! Arguments
!
! ON INPUT               INTL
!                          = 0 ON INITIAL ENTRY TO SEPELL OR IF ANY OF
!                              the arguments C, D, N, NBDCND, COFY are
!                              changed from a previous call
!                          = 1 IF C, D, N, NBDCND, COFY ARE UNCHANGED
!                              from the previous call.
!
!                        IORDER
!                          = 2 IF A SECOND-ORDER APPROXIMATION IS SOUGHT
!                          = 4 IF A FOURTH-ORDER APPROXIMATION IS SOUGHT
!
!                        A,B
!                          the range of the X-independent variable,
!                          I.E., X is greater than or equal to A and
!                          less than or equal to B. A must be less than
!                          B.
!
!                        M
!                          the number of panels into which the interval
!                          (A,B) is subdivided.  Hence, there will be
!                          M+1 grid points in the X-direction given by
!                          XI=A+(I-1)*DLX FOR I=1,2,...,M+1 WHERE
!                          DLX=(B-A)/M IS THE PANEL WIDTH.  M MUST BE
!                          less than IDMN and greater than 5.
!
!                        MBDCND
!                          indicates the type of boundary condition at
!                          X=A AND X=B
!                          = 0 IF THE SOLUTION IS PERIODIC IN X, I.E.,
!                              U(X+B-A,Y)=U(X,Y) FOR ALL Y,X
!                          = 1 IF THE SOLUTION IS SPECIFIED AT X=A AND
!                              X=B, I.E., U(A,Y) AND U(B,Y) ARE
!                              specified for all Y
!                          = 2 IF THE SOLUTION IS SPECIFIED AT X=A AND
!                              THE BOUNDARY CONDITION IS MIXED AT X=B,
!                              I.E., U(A,Y) and DU(B,Y)/DX+beta*U(B,Y)
!                              are specified for all Y
!                          = 3 IF THE BOUNDARY CONDITIONS AT X=A AND X=B
!                              are mixed, I.E., DU(A,Y)/DX+alpha*U(A,Y)
!                              and DU(B,Y)/DX+beta*U(B,Y) are specified
!                              for all Y
!                          = 4 IF THE BOUNDARY CONDITION AT X=A IS MIXED
!                              AND THE SOLUTION IS SPECIFIED AT X=B,
!                              I.E., DU(A,Y)/DX+alpha*U(A,Y) and U(B,Y)
!                              are specified for all Y
!
!                        BDA
!                          a one-dimensional array of length N+1 that
!                          specifies the values of DU(A,Y)/DX+
!                          ALPHA*U(A,Y) AT X=A. WHEN MBDCND=3 OR 4
!                               BDA(J) = DU(A,YJ)/DX+ALPHA*U(A,YJ),
!                               J=1,2,...,N+1.
!                          When MBDCND has any other value, BDA is A
!                          dummy parameter.
!
! ON INPUT               ALPHA
!                          the scalar multiplying the solution in case
!                          OF A MIXED BOUNDARY CONDITION AT X=A (SEE
!                          ARGUMENT BDA). IF MBDCND.NE.3,4 THEN ALPHA
!                          is a dummy parameter.
!
!                        BDB
!                          a one-dimensional array of length N+1 that
!                          specifies the values of DU(B,Y)/DX+
!                          BETA*U(B,Y) AT X=B.  WHEN MBDCND=2 OR 3
!                               BDB(J) = DU(B,YJ)/DX+BETA*U(B,YJ),
!                               J=1,2,...,N+1.
!                          When MBDCND has any other value, BDB is A
!                          dummy parameter.
!
!                        Beta
!                          the scalar multiplying the solution in case
!                          OF A MIXED BOUNDARY CONDITION AT X=B (SEE
!                          ARGUMENT BDB). IF MBDCND.NE.2,3 THEN BETA IS
!                          a dummy parameter.
!
!                        C,D
!                          the range of the Y-independent variable,
!                          I.E., Y is greater than or equal to C and
!                          less than or equal to D.  C must be less
!                          THAN D.
!
!                        N
!                          the number of panels into which the interval
!                          (C,D) is subdivided.  Hence, there will be
!                          N+1 grid points in the Y-direction given by
!                          YJ=C+(J-1)*DLY FOR J=1,2,...,N+1 WHERE
!                          DLY=(D-C)/N IS THE PANEL WIDTH. IN ADDITION,
!                          N must be greater than 4.
!
!                        NBDCND
!                          indicates the types of boundary conditions
!                          AT Y=C AND Y=D
!                          = 0 IF THE SOLUTION IS PERIODIC IN Y, I.E.,
!                              U(X,Y+D-C)=U(X,Y) FOR ALL X,Y
!                          = 1 IF THE SOLUTION IS SPECIFIED AT Y=C AND
!                              Y = D, I.E., U(X,C) AND U(X,D) ARE
!                              specified for all X
!                          = 2 IF THE SOLUTION IS SPECIFIED AT Y=C AND
!                              THE BOUNDARY CONDITION IS MIXED AT Y=D,
!                              I.E., U(X,C) AND DU(X,D)/DY+XNU*U(X,D)
!                              are specified for all X
!                          = 3 IF THE BOUNDARY CONDITIONS ARE MIXED AT
!                              Y=C AND Y=D, I.E., DU(X,D)/DY+GAMA*U(X,C)
!                              and DU(X,D)/DY+XNU*U(X,D) are specified
!                              for all X
!                          = 4 IF THE BOUNDARY CONDITION IS MIXED AT Y=C
!                              AND THE SOLUTION IS SPECIFIED AT Y=D,
!                              I.E. DU(X,C)/DY+gama*U(X,C) and U(X,D)
!                              are specified for all X
!
!                        BDC
!                          a one-dimensional array of length M+1 that
!                          specifies the value of DU(X,C)/DY+gama*U(X,C)
!                          AT Y=C.  WHEN NBDCND=3 OR 4
!                             BDC(I) = DU(XI,C)/DY + GAMA*U(XI,C),
!                             I=1,2,...,M+1.
!                          When NBDCND has any other value, BDC is A
!                          dummy parameter.
!
!                        Gama
!                          the scalar multiplying the solution in case
!                          OF A MIXED BOUNDARY CONDITION AT Y=C (SEE
!                          ARGUMENT BDC). IF NBDCND.NE.3,4 THEN GAMA IS
!                          a dummy parameter.
!
!                        BDD
!                          a one-dimensional array of length M+1 that
!                          specifies the value of DU(X,D)/DY +
!                          XNU*U(X,D) AT Y=C.  WHEN NBDCND=2 OR 3
!                            BDD(I) = DU(XI,D)/DY + XNU*U(XI,D),
!                            I=1,2,...,M+1.
!                          When NBDCND has any other value, BDD is A
!                          dummy parameter.
!
!                        XNU
!                          the scalar multiplying the solution in case
!                          OF A MIXED BOUNDARY CONDITION AT Y=D (SEE
!                          ARGUMENT BDD). IF NBDCND.NE.2 OR 3 THEN XNU
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
!                        than 0 for a less than X less than B,
!                        C LESS THAN Y LESS THAN D (SEE IERROR=10).
!                        The coefficients provided may lead to a matrix
!                        equation which is not diagonally dominant in
!                        WHICH CASE SOLUTION MAY FAIL (SEE IERROR=4).
!
!                        GRHS
!                          a two-dimensional array that specifies the
!                          values of the right-hand side of the elliptic
!                          EQUATION, I.E., GRHS(I,J)=G(XI,YI), FOR
!                          I=2,...,M, J=2,...,N.  AT THE BOUNDARIES,
!                          GRHS is defined by
!
!                          MBDCND   GRHS(1,J)   GRHS(M+1,J)
!                          ------   ---------   -----------
!                            0      G(A,YJ)     G(B,YJ)
!                            1         *           *
!                            2         *        G(B,YJ)  J=1,2,...,N+1
!                            3      G(A,YJ)     G(B,YJ)
!                            4      G(A,YJ)        *
!
!                          NBDCND   GRHS(I,1)   GRHS(I,N+1)
!                          ------   ---------   -----------
!                            0      G(XI,C)     G(XI,D)
!                            1         *           *
!                            2         *        G(XI,D)  I=1,2,...,M+1
!                            3      G(XI,C)     G(XI,D)
!                            4      G(XI,C)        *
!
!                          Where * means these quantites are not used.
!                          GRHS should be dimensioned MN by at least
!                          N+1 in the calling routine.
!
!                        MN
!                          the row (or first) dimension of the array
!                          GRHS as it appears in the program calling
!                          SEPELL. MN must be at least 7 and greater
!                          than or equal to M+1.
!
!                        USOL
!                          a two-dimensional array that specifies the
!                          values of the solution along the boundaries.
!                          At the boundaries, USOL is defined by
!
!                          MBDCND   USOL(1,J)   USOL(M+1,J)
!                          ------   ---------   -----------
!                            0         *           *
!                            1      U(A,YJ)     U(B,YJ)
!                            2      U(A,YJ)        *     J=1,2,...,N+1
!                            3         *           *
!                            4         *        U(B,YJ)
!
!                          NBDCND   USOL(I,1)   USOL(I,N+1)
!                          ------   ---------   -----------
!                            0         *           *
!                            1      U(XI,C)     U(XI,D)
!                            2      U(XI,C)        *     I=1,2,...,M+1
!                            3         *           *
!                            4         *        U(XI,D)
!
!                          Where * means the quantites are not used in
!                          the solution.
!
!                          IF IORDER=2 AND IDMN=MN, THEN THE USER MAY
!                          equivalence GRHS and USOL. Note that in this
!                          case the tables specifying the boundaries of
!                          the GRHS and USOL arrays determine the
!                          boundaries uniquely except at the corners.
!                          If the tables call for both G(X,Y) and
!                          U(X,Y) at a corner then the solution must be
!                          CHOSEN.  FOR EXAMPLE, IF MBDCND=2 AND
!                          NBDCND=4, THEN U(A,C), U(A,D), U(B,D) MUST BE
!                          chosen at the corners in addition to G(B,C).
!
!                          IF IORDER=4, THEN THE TWO ARRAYS, USOL AND
!                          GRHS, must be distinct.
!
!                          USOL should be dimensioned IDMN by at least
!                          N+1 in the calling routine.
!
!                        IDMN
!                          the row (or first) dimension of the array
!                          USOL as it appears in the program calling
!                          SEPELL. IDMN must be at least 7 and greater
!                          than or equal to M+1.
!
!                        W
!                          a one-dimensional array that must be provided
!                          by the user for work space.  Let
!                          K=INT(LOG2(N+1))+1 AND SET  L=2**(K+1).
!                          Then (K-2)*L+K+10*N+12*M+27 will suffice
!                          as a length of W.  The actual length of W in
!                          the calling routine must be set in W(1) (see
!                          IERROR=11).
!
! ON OUTPUT              USOL
!                          contains the approximate solution to the
!                          elliptic equation.  USOL(I,J) is the
!                          APPROXIMATION TO U(XI,YJ) FOR I=1,2...,M+1
!                          AND J=1,2,...,N+1.  THE APPROXIMATION HAS
!                          ERROR O(DLX**2+DLY**2) IF CALLED WITH
!                          IORDER=2 AND O(DLX**4+DLY**4) IF CALLED WITH
!                          IORDER=4.
!
!                        W
!                          contains intermediate values that must not be
!                          destroyed if SEPELL is called again with
!                          INTL=1.  IN ADDITION W(1) CONTAINS THE EXACT
!                          minimal length (in floating point) required
!                          FOR THE WORK SPACE (SEE IERROR=11).
!
!                        PERTRB
!                          if a combination of periodic or derivative
!                          BOUNDARY CONDITIONS (I.E., ALPHA=BETA=0 IF
!                          MBDCND=3, GAMA=XNU=0 IF NBDCND=3) IS
!                          specified and if the coefficients of U(X,Y)
!                          in the separable elliptic equation are zero
!                          (I.E., CF(X)=0 FOR X GREATER THAN OR EQUAL TO
!                          A AND LESS THAN OR EQUAL TO B, FF(Y)=0 FOR
!                          Y greater than or equal to C and less than
!                          or equal to D) then a solution may not exist.
!                          PERTRB is a constant calculated and
!                          subtracted from the right-hand side of the
!                          matrix equations generated by SEPELL which
!                          insures that a solution exists.  SEPELL then
!                          computes this solution which is a weighted
!                          minimal least squares solution to the
!                          original problem.
!
!                        Ierror
!                          an error flag that indicates invalid input
!                          parameters or failure to find a solution
!                          = 0 NO ERROR
!                          = 1 IF A GREATER THAN B OR C GREATER THAN D
!                          = 2 IF MBDCND LESS THAN 0 OR MBDCND GREATER
!                              than 4
!                          = 3 IF NBDCND LESS THAN 0 OR NBDCND GREATER
!                              than 4
!                          = 4 IF ATTEMPT TO FIND A SOLUTION FAILS.
!                              (The linear system generated is not
!                              diagonally dominant.)
!                          = 5 IF IDMN OR MN IS TOO SMALL.
!                          = 6 IF M IS TOO SMALL OR TOO LARGE (SEE
!                              discussion of M)
!                          = 7 IF N IS TOO SMALL (SEE DISCUSSION OF N)
!                          = 8 IF IORDER IS NOT 2 OR 4
!                          = 9 IF INTL IS NOT 0 OR 1
!                          = 10 IF AFUN*DFUN LESS THAN OR EQUAL TO 0 FOR
!                               some interior mesh point (XI,YJ)
!                          = 11 IF THE WORK SPACE LENGTH INPUT IN W(1)
!                               is less than the exact minimal work
!                               space length required output in W(1).
!
!                          NOTE (CONCERNING IERROR=4).  FOR THE
!                          coefficients input through COFX, COFY, the
!                          discretization may lead to a block
!                          tridiagonal linear system which is not
!                          diagonally dominant (for example, this
!                          HAPPENS IF CFUN=0 AND BFUN/(2.*DLX) GREATER
!                          THAN AFUN/DLX**2).  IN THIS CASE SOLUTION MAY
!                          fail.  This cannot happen in the limit as
!                          DLX, DLY approach zero.  Hence, the condition
!                          may be remedied by taking larger values for M
!                          OR N.
!
! ENTRY POINTS           SEPELL, SEPEL1, CHKPRM, CHKSNG, ORTHG, MINSOL,
!                        TRISP, DEFER, DXFN, DYFN, BLKTRI, BLKTR1,INDXB,
!                        INDXA, INDXC, PROD0, PRODP, CPROD0, CPRODP,
!                        PPADD, PSGF, BSRH, PPSGF, PPSPF, COMPB,
!                        TQLRT0, SPMPAR
!
! SPECIAL CONDITIONS     NONE
!
! COMMON BLOCKS          SPLP, CBLKT
!
! I/O                    NONE
!
! PRECISION              SINGLE
!
! SPECIALIST             JOHN C. ADAMS, NCAR, BOULDER, COLORADO  80307
!
! HISTORY                DEVELOPED AT NCAR DURING 1975-76.
!
! ALGORITHM              SEPELL AUTOMATICALLY DISCRETIZES THE SEPARABLE
!                        ELLIPTIC EQUATION WHICH IS THEN SOLVED BY A
!                        GENERALIZED CYCLIC REDUCTION ALGORITHM IN THE
!                        SUBROUTINE, BLKTRI.  THE FOURTH-ORDER SOLUTION
!                        IS OBTAINED USING DEFERRED CORRECTIONS, WHICH
!                        IS DESCRIBED AND REFERENCED IN SECTIONS,
!                        REFERENCES AND METHOD.
!
! ACCURACY AND TIMING    THE FOLLOWING COMPUTATIONAL RESULTS WERE
!                        obtained by solving the sample problem at the
!                        END OF THIS WRITE-UP ON THE CONTROL DATA 7600.
!                        The OP count is proportional to M*N*LOG2(N).
!                        In contrast to the other routines in this
!                        chapter, accuracy is tested by computing and
!                        tabulating second- and fourth-order
!                        discretization errors.  Below is a table
!                        containing computational results.  The times
!                        given do not include initialization (I.E.,
!                        TIMES ARE FOR INTL=1).  NOTE THAT THE
!                        fourth-order accuracy is not realized until the
!                        mesh is sufficiently refined.
!
!              SECOND-ORDER    FOURTH-ORDER   SECOND-ORDER  FOURTH-ORDER
!    M    N   EXECUTION TIME  EXECUTION TIME    ERROR         ERROR
!               (M SEC)         (M SEC)
!     6    6         6              14          6.8E-1        1.2E0
!    14   14        23              58          1.4E-1        1.8E-1
!    30   30       100             247          3.2E-2        9.7E-3
!    62   62       445           1,091          7.5E-3        3.0E-4
!   126  126     2,002           4,772          1.8E-3        3.5E-6
!
! PORTABILITY            THE VALUE GIVEN BY SPMPAR(1) IS THE ONLY
!                        machine dependent constant that is used.
!
! REFERENCES             KELLER, H.B., NUMERICAL METHODS FOR TWO-POINT
!                          BOUNDARY-VALUE PROBLEMS, BLAISDEL (1968),
!                          WALTHAM, MASS.
!
!                        Swarztrauber, P., And R. Sweet (1975),
!                          efficient Fortran subprograms for the
!                          solution of elliptic partial differential
!                          equations.  NCAR technical note
!                          NCAR-TN/IA-109, PP. 135-137.
!
!
!
real, intent(inout) :: grhs(mn,*), usol(idmn,*)
real :: bda(*), bdb(*), bdc(*), bdd(*)
real, intent(inout) :: w(*)
external cofx, cofy
!
!
!     Check input parameters
!
call chkprm (intl,iorder,a,b,m,mbdcnd,c,d,n,nbdcnd,cofx,cofy, &
&idmn,mn,ierror)
if (ierror .ne. 0) return
!
!     Compute minimum work space and check work space length input
!
l = n+1
if (nbdcnd .eq. 0) l = n
logb2n = int(alog(float(l)+0.5)/alog(2.0))+1
ll = 2**(logb2n+1)
k = m+1
l = n+1
length = (logb2n-2)*ll+logb2n+max0(2*l,6*k)+5
if (nbdcnd .eq. 0) length = length+2*l
ierror = 11
linput = int(w(1)+0.5)
loutpt = length+6*(k+l)+1
w(1) = float(loutpt)
if (loutpt .gt. linput) return
ierror = 0
!
!     Set work space indices
!
i1 = length+2
i2 = i1+l
i3 = i2+l
i4 = i3+l
i5 = i4+l
i6 = i5+l
i7 = i6+l
i8 = i7+k
i9 = i8+k
i10 = i9+k
i11 = i10+k
i12 = i11+k
i13 = 2
call sepel1 (intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c,d,n, &
&nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,w(i1),w(i2),w(i3), &
&w(i4),w(i5),w(i6),w(i7),w(i8),w(i9),w(i10),w(i11), &
&w(i12),grhs,mn,usol,idmn,w(i13),pertrb,ierror)
return
end subroutine sepell

