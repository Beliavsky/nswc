subroutine qagie (f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!
!                   Integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!
!            bound  - Real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!
!            epsabs - REAL
!                     absolute accuracy requested
!
!            epsrel - REAL
!                     relative accuracy requested
!
!            limit  - Integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     limit.GE.1
!
!         On return
!            result - Real
!                     approximation to the integral
!
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            neval  - INTEGER
!                     number of integrand evaluations
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     ier = 1 Maximum number of subdivisions allowed
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
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             elist(1) and iord(1) are set to zero.
!                             alist(1) and blist(1) are set to 0
!                             and 1 respectively.
!
!            alist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            blist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            rlist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            elist  - REAL
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!
!            iord   - INTEGER
!                     vector of dimension limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!
!            last   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!
!        Subroutines or functions needed
!              - qk15i
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - spmpar
!
!-----------------------------------------------------------------------
real, intent(out) :: abserr
real, intent(inout) :: alist
real, intent(inout) :: blist
real, intent(in) :: bound
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
real :: abseps
real :: area, area1, area12, area2, a1, a2
real :: boun
real :: b1, b2, correc, defabs, defab1, defab2, dres
real :: epmach
real :: erlarg, erlast, errbnd, errmax, error1, error2, erro12, &
   & errsum, ertest, oflow, rerr, resabs, reseps
real :: res3la(3)
real :: rlist2(52), small, spmpar, t, uflow
integer :: id
integer :: ierro
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer :: maxerr
integer :: nres, nrmax, numrl2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!
!
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine qelg.
!
!
!            List of major variables
!            -----------------------
!
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left subinterval
!           *****2    - Variable for the right subinterval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered up
!                       to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (TRUE-VALUE)
!
!            Machine dependent constants
!            ---------------------------
!
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!           Check epsabs and epsrel
!           -----------------------
!
neval = 0
last = 0
result = 0.0
abserr = 0.0
alist(1) = 0.0
blist(1) = 1.0
rlist(1) = 0.0
elist(1) = 0.0
iord(1) = 0
ier = 6
if (epsabs .lt. 0.0 .or. epsrel .lt. 0.0) go to 999
ier = 0
rerr = amax1(epsrel, 50.0*epmach, 0.5e-14)
!
!           First approximation to the integral
!           -----------------------------------
!
!           Determine the interval to be mapped onto (0,1).
!           If inf = 2 The integral is computed as I = I1+I2, where
!           I1 = Integral of f over (-INFINITY,0),
!           I2 = Integral of f over (0,+INFINITY).
!
boun = bound
if (inf .eq. 2) boun = 0.0
call qk15i (f, boun, inf, 0.0, 1.0, result, abserr, &
   & defabs, resabs, epmach, uflow)
!
!           Test on accuracy
!
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = abs(result)
errbnd = amax1(epsabs,rerr*dres)
if (abserr .le. 100.0*epmach*defabs .and. abserr .gt. errbnd) &
   & ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr .le. errbnd .and. abserr .ne. resabs) &
   & .or. abserr .eq. 0.0) go to 130
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
correc = 0.0
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
if (dres .ge. (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with nrmax-TH largest
!           error estimate.
!
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qk15i (f, boun, inf, a1, b1, area1, error1, &
      & resabs, defab1, epmach, uflow)
   call qk15i (f, boun, inf, a2, b2, area2, error2, &
      & resabs, defab2, epmach, uflow)
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
   if (abs(rlist(maxerr) - area12) .gt. 0.1e-04*abs(area12) &
      & .or. erro12 .lt. 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last .gt. 10 .and. erro12 .gt. errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = amax1(epsabs,rerr*abs(area))
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

   if (amax1(abs(a1),abs(b2)) .le. &
      & t*(abs(a2) + 0.1e+04*uflow)) ier = 4
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
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
!
30 call qpsrt (limit,last,maxerr,errmax,elist,iord,nrmax)
   if (errsum .le. errbnd) go to 115
   if (ier .ne. 0) go to 100
   if (last .eq. 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) .gt. small) erlarg = erlarg + erro12
   if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
   if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro .eq. 3 .or. erlarg .le. ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (erlarg) and perform
!           extrapolation.
!
   id = nrmax
   jupbnd = last
   if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
   do 50 k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
      if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
      nrmax = nrmax + 1
50    continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin .gt. 5 .and. abserr .lt. 0.1e-02*errsum) ier = 5
   if (abseps .ge. abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = amax1(epsabs,rerr*abs(reseps))
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
   small = small*0.5
   erlarg = errsum
   go to 90
80 small = 0.375
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
if (result .ne. 0.0 .and. area .ne. 0.0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.0) go to 130
go to 110
105 if (abserr/abs(result) .gt. errsum/abs(area)) go to 115
!
!           Test on divergence
!
110 if (ksgn .eq. -1 .and. amax1(abs(result),abs(area)) .le. &
   & defabs*0.1e-01) go to 130
if (0.1e-01 .gt. (result/area) .or. (result/area) .gt. 0.1e+03 &
   & .or. errsum .gt. abs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf .eq. 2) neval = 2*neval
if (ier .gt. 2) ier = ier - 1
999 return
end subroutine qagie

subroutine qk15i (f, boun, inf, a, b, result, abserr, resabs, &
   & resasc, epmach, uflow)
implicit none
integer, intent(in) :: inf
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, boun, epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
real :: f
external f
integer :: j
real :: absc, absc1, absc2, centr, dinf, fc, fsum, fval1, fval2, &
   & hlgth, resg, resk, reskh, tabsc1, tabsc2, tol
real :: fv1(7), fv2(7), xgk(8), wgk(8), wg(8)
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (a,b) is a part of (0,1).
!              It is the purpose to compute
!              I = Integral of transformed integrand over (a,b),
!              j = Integral of abs(transformed integrand) over (a,b).
!
! 2.        PARAMETERS
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!
!              boun   - REAL
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF inf = +2)
!
!              inf    - INTEGER
!                       if inf = -1, the original interval is
!                                   (-INFINITY,BOUND),
!                       if inf = +1, the original interval is
!                                   (BOUND,+INFINITY),
!                       if inf = +2, the original interval is
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!
!              a      - REAL
!                       lower limit for integration over subrange
!                       of (0,1)
!
!              b      - REAL
!                       upper limit for integration over subrange
!                       of (0,1)
!
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              uflow  - REAL
!                       the smallest positive magnitude.
!
!            On return
!              result - Real
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod rule(RESK) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(RESG).
!
!              abserr - REAL
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed abs(I-result)
!
!              resabs - REAL
!                       approximation to the integral j
!
!              resasc - REAL
!                       approximation to the integral of
!                       abs((transformed integrand)-I/(b-a))
!                       OVER (a,b)
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!
!-----------------------------------------------------------------------
!
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!
!           xgk    - Abscissae of the 15-point Kronrod rule
!                    xgk(2), xgk(4), ... abscissae of the 7-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!
!           wgk    - Weights of the 15-point Kronrod rule
!
!           wg     - Weights of the 7-point Gauss rule, corresponding
!                    to the abscissae xgk(2), xgk(4), ...
!                    wg(1), wg(3), ... are set to zero.
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
   & xgk(8)/ &
   & 0.9914553711208126e+00,     0.9491079123427585e+00, &
   & 0.8648644233597691e+00,     0.7415311855993944e+00, &
   & 0.5860872354676911e+00,     0.4058451513773972e+00, &
   & 0.2077849550078985e+00,     0.0000000000000000e+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
   & wgk(8)/ &
   & 0.2293532201052922e-01,     0.6309209262997855e-01, &
   & 0.1047900103222502e+00,     0.1406532597155259e+00, &
   & 0.1690047266392679e+00,     0.1903505780647854e+00, &
   & 0.2044329400752989e+00,     0.2094821410847278e+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5),wg(6),wg(7),wg(8)/ &
   & 0.0000000000000000e+00,     0.1294849661688697e+00, &
   & 0.0000000000000000e+00,     0.2797053914892767e+00, &
   & 0.0000000000000000e+00,     0.3818300505051189e+00, &
   & 0.0000000000000000e+00,     0.4179591836734694e+00/
!
!
!           List of major variables
!           -----------------------
!
!           centr  - Mid point of the interval
!           HLGTH  - Half-length of the interval
!           absc*  - ABSCISSA
!           TABSC* - Transformed abscissa
!           FVAL*  - Function VALUE
!           RESG   - result of the 7-point Gauss formula
!           RESK   - result of the 15-point Kronrod formula
!           RESKH  - Approximation to the mean value of the transformed
!                    integrand over (a,b), I.E. to I/(b-a)
!
!
dinf = min0(1,inf)
!
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
tabsc1 = boun + dinf*(1.0 - centr)/centr
fval1 = f(tabsc1)
if (inf .eq. 2) fval1 = fval1 + f(-tabsc1)
fc = (fval1/centr)/centr
!
!           Compute the 15-point Kronrod approximation to
!           the integral, and estimate the error.
!
resg = wg(8)*fc
resk = wgk(8)*fc
resabs = abs(resk)
do j = 1,7
   absc = hlgth*xgk(j)
   absc1 = centr - absc
   absc2 = centr + absc
   tabsc1 = boun + dinf*(1.0 - absc1)/absc1
   tabsc2 = boun + dinf*(1.0 - absc2)/absc2
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
   resabs = resabs + wgk(j)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5
resasc = wgk(8)*abs(fc - reskh)
do j = 1,7
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) + &
      & abs(fv2(j) - reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = abs((resk - resg)*hlgth)
if (resasc .ne. 0.0 .and. abserr .ne. 0.0) abserr = resasc* &
   & amin1(1.0, (0.2e+03*abserr/resasc)**1.5)
tol = 50.0*epmach
if (resabs .gt. uflow/tol) abserr = amax1(abserr, tol*resabs)
return
end subroutine qk15i

subroutine qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
implicit none
!     ..................................................................
!
! 1.        qpsrt
!           ordering routine
!              standard Fortran subroutine
!              real version
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
!              call qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!
!           Parameters (meaning at output)
!              limit  - Integer
!                       maximum number of error estimates the list
!                       can contain
!
!              last   - INTEGER
!                       number of error estimates currently
!                       in the list
!
!              maxerr - INTEGER
!                       maxerr points to the nrmax-TH largest error
!                       estimate currently in the list
!
!              ermax  - REAL
!                       nrmax-TH largest error estimate
!                       ermax = elist(maxerr)
!
!              elist  - REAL
!                       vector of dimension last containing
!                       the error estimates
!
!              iord   - INTEGER
!                       vector of dimension last, the first k
!                       elements of which contain pointers
!                       to the error estimates, such that
!                       elist(iord(1)),... , elist(iord(k))
!                       form a decreasing sequence, with
!                       k = last if last.LE.(limit/2+2), and
!                       k = limit+1-last otherwise
!
!              nrmax  - INTEGER
!                       maxerr = iord(nrmax)
!
! 4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!
!     ..................................................................
!
real :: elist
real, intent(inout) :: ermax
integer, intent(inout) :: iord
integer, intent(in) :: last, limit
integer, intent(inout) :: maxerr, nrmax
real :: errmax, errmin
integer :: i, ibeg, ido
integer :: isucc, j, jbnd, jupbn, k
dimension elist(last),iord(last)
!
!           Check whether the list contains more than
!           two error estimates.
!
!***First executable statement  qpsrt
if (last.gt.2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!
!           This part of the routine is only executed
!           if, due to a difficult integrand, subdivision
!           increased the error estimate. In the normal case
!           the insert procedure should start after the
!           nrmax-TH largest error estimate.
!
10 errmax = elist(maxerr)
if (nrmax.eq.1) go to 30
ido = nrmax - 1
do i = 1,ido
   isucc = iord(nrmax - 1)
! ***Jump out of do-loop
   if (errmax.le.elist(isucc)) go to 30
   iord(nrmax) = isucc
   nrmax = nrmax - 1
end do
!
!           Compute the number of elements in the list to
!           be maintained in descending order. This number
!           depends on the number of subdivisions still
!           allowed.
!
30 jupbn = last
if (last.gt.(limit/2 + 2)) jupbn = limit + 3 - last
errmin = elist(last)
!
!           Insert errmax by traversing the list top-down,
!           starting comparison from the element elist(iord(nrmax+1)).
!
jbnd = jupbn - 1
ibeg = nrmax + 1
if (ibeg.gt.jbnd) go to 50
do i = ibeg,jbnd
   isucc = iord(i)
! ***Jump out of do-loop
   if (errmax.ge.elist(isucc)) go to 60
   iord(i - 1) = isucc
end do
50 iord(jbnd) = maxerr
iord(jupbn) = last
go to 90
!
!           Insert errmin by traversing the list bottom-up.
!
60 iord(i - 1) = maxerr
k = jbnd
do j = i,jbnd
   isucc = iord(k)
! ***Jump out of do-loop
   if (errmin.lt.elist(isucc)) go to 80
   iord(k + 1) = isucc
   k = k - 1
end do
iord(i) = last
go to 90
80 iord(k + 1) = last
!
!           Set maxerr and ermax.
!
90 maxerr = iord(nrmax)
ermax = elist(maxerr)
return
end subroutine qpsrt

pure subroutine qelg (n, epstab, result, abserr, res3la, nres, &
   & epmach, oflow)
implicit none
integer, intent(inout) :: n, nres
real, intent(out) :: abserr
real, intent(in) :: epmach, oflow
real, intent(out) :: result
real, intent(inout) :: epstab(52), res3la(3)
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp, newelm, num
real :: delta1, delta2, delta3, e0, e1, e1abs, e2, e3, epsinf, &
   & err1, err2, err3, error, res, ss, tol1, tol2, tol3
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
!
! 2.        PARAMETERS
!              n      - INTEGER
!                       epstab(n) contains the new element in the
!                       first column of the epsilon table.
!
!              epstab - REAL
!                       vector of dimension 52 containing the
!                       elements of the two lower diagonals of
!                       the triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!
!              result - Real
!                       resulting approximation to the integral
!
!              abserr - REAL
!                       estimate of the absolute error computed from
!                       result and the 3 previous results
!
!              res3la - REAL
!                       vector of dimension 3 containing the last 3
!                       results
!
!              nres   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              oflow  - REAL
!                       the largest positive magnitude.
!
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!
!-----------------------------------------------------------------------
!---------------------
!
!           List of major variables
!           -----------------------
!
!           e0     - The 4 elements on which the
!           e1       COMPUTATION OF A NEW ELEMENT IN
!           e2       THE EPSILON TABLE IS BASED
!           e3                 e0
!                        e3    e1    NEW
!                              e2
!           newelm - Number of elements to be computed in the new
!                    diagonal
!           ERROR  - ERROR = abs(e1-e0)+abs(e2-e1)+abs(NEW-e2)
!           result - The element in the new diagonal with least value
!                    of error
!
!           limexp is the maximum number of elements the epsilon
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
   e1abs = abs(e1)
   delta2 = e2 - e1
   err2 = abs(delta2)
   tol2 = amax1(abs(e2),e1abs)*epmach
   delta3 = e1 - e0
   err3 = abs(delta3)
   tol3 = amax1(e1abs,abs(e0))*epmach
   if (err2 .gt. tol2 .or. err3 .gt. tol3) go to 10
!
!           If e0, e1 and e2 are equal to within machine
!           accuracy, convergence is assumed.
!           result = e2
!           abserr = abs(e1-e0) + abs(e2-e1)
!
   result = res
   abserr = err2 + err3
! ***Jump out of do-loop
   go to 100
10 e3 = epstab(k1)
   epstab(k1) = e1
   delta1 = e1 - e3
   err1 = abs(delta1)
   tol1 = amax1(e1abs,abs(e3))*epmach
!
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of n
!
   if (err1.le.tol1 .or. err2.le.tol2 .or. err3.le.tol3) go to 20
   ss = 1.0/delta1 + 1.0/delta2 - 1.0/delta3
   epsinf = abs(ss*e1)
!
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF n.
!
   if (epsinf .gt. 0.1e-03) go to 30
20 n = i + i - 1
! ***Jump out of do-loop
   go to 50
!
!           Compute a new element and eventually adjust
!           the value of result.
!
30 res = e1 + 1.0/ss
   epstab(k1) = res
   k1 = k1 - 2
   error = err2 + abs(res - e2) + err3
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
90 abserr = abs(result - res3la(3)) + abs(result - res3la(2)) + &
   & abs(result - res3la(1))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = amax1(abserr,5.0*epmach*abs(result))
return
end subroutine qelg

subroutine qxgs (f,a,b,epsabs,epsrel,result,abserr,ier, &
   & limit,leniw,lenw,last,iwork,work)
implicit none
!
!            The routine calculates an approximation result to a given
!            definite integral  I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!
!            a      - REAL
!                     lower limit of integration
!
!            b      - REAL
!                     upper limit of integration
!
!            epsabs - REAL
!                     absolute accuracy requested
!
!            epsrel - REAL
!                     relative accuracy requested
!
!         On return
!            result - Real
!                     approximation to the integral
!
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account. However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table. It is presumed that
!                             the requested tolerance cannot be
!                             achieved, and that the returned result is
!                             the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel IS NEGATIVE, limit .LT. 1,
!                             lenw .LT. 46*limit, OR
!                             leniw .LT. 3*limit.
!                             Result, abserr, last are set to
!                             zero. Except when limit or lenw or leniw
!                             is invalid, iwork(1), work(limit*2+1) and
!                             work(limit*3+1) are set to zero, work(1)
!                             is set to A, and work(limit+1) to b.
!
!         Dimensioning parameters
!            limit - Integer
!                    limit determines the maximum number of subintervals
!                    in the partition of the given integration interval
!                    (A,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with ier = 6.
!
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*46.
!                    If lenw.LT.limit*46, the routine will end
!                    with ier = 6.
!
!            leniw - INTEGER
!                    dimensioning parameter for iwork
!                    leniw must be at least limit*3.
!                    If lenw.LT.limit*3, the routine will end
!                    with ier = 6.
!
!            last  - Integer
!                    on return, last equals the number of subintervals
!                    produced in the subdivision process, which deter-
!                    mines the number of significant elements actually
!                    in the work arrays.
!
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least 3*limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2),
!                    and K = limit+1-last otherwise.
!
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END-POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end-points,
!                    work(limit*2+1), ..., work(limit*2+last) contain
!                     the integral approximations over the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!                    work(limit*4+1), ... is the area reserved to store
!                     functional values.
!
real :: a
real, intent(out) :: abserr
real :: b
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(out) :: last
integer, intent(in) :: leniw, lenw, limit
external f
integer :: l1, l2, l3, l4, l5
!
dimension iwork(leniw),work(lenw)
!
!
!         Check validity of limit,leniw and lenw.
!
ier = 6
last = 0
result = 0.0
abserr = 0.0
if (limit.lt.1 .or. leniw.lt.limit*3 .or. lenw.lt.limit*46) &
   & return
!
!         Prepare call for qxgse.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
l4 = limit + l3
l5 = 21*limit + l4
!
call qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last, &
   & work(l4),work(l5),iwork(l1),iwork(l2))
!
return
end subroutine qxgs

subroutine qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,alist,blist,rlist,elist,iord,last,valp,valn,lp,ln)
implicit none
!
!            The routine calculates an approximation result to A
!            definite integral I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!
!            a      - REAL
!                     lower limit of integration
!
!            b      - REAL
!                     upper limit of integration
!
!            epsabs - REAL
!                     absolute accuracy requested
!
!            epsrel - REAL
!                     relative accuracy requested
!
!            limit  - Integer
!                     gives an upperbound on the number of subintervals
!                     in the partition of (a,b)
!
!         On return
!            result - Real
!                     approximation to the integral
!
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                         = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account). However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel is negative. Result, abserr,
!                             last, rlist(1), iord(1), and elist(1)
!                             are set to zero. alist(1) and blist(1)
!                             are set to A and b respectively.
!
!            alist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left end points
!                     of the subintervals in the partition of the
!                     given integration range (a,b)
!
!            blist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right end points
!                     of the subintervals in the partition of the given
!                     integration range (a,b)
!
!            rlist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            elist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli of the
!                     absolute error estimates on the subintervals
!
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!
!            valp   - REAL
!            valn     ARRAYS OF DIMENSION AT LEAST (21,limit) USED TO
!                     save the functional values
!
!            lp     - INTEGER
!            ln       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!                     store the actual number of functional values
!                     saved in the corresponding column
!                     OF valp,valn
!
!***Routines called  f,spmpar,qelg,qxlqm,qpsrt,qxrrd,qxcpy
!
real :: a
real, intent(out) :: abserr
real, intent(inout) :: alist
real :: b
real, intent(inout) :: blist
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
real, intent(inout) :: valp, valn
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(inout) :: lp(limit), ln(limit)
external f
real :: abseps
real :: area, area1, area12, area2, a1, a2
real :: b1, b2, correc, defabs, defab1, defab2, dres
real :: epmach
real :: erlarg, erlast, errbnd, errmax, error1, error2, erro12, &
   & errsum, ertest, oflow, rerr, resabs, reseps
real :: res3la(3)
real :: rlist2(52), small, t, uflow
real :: vp1(21), vp2(21), vn1(21), vn2(21), spmpar
integer :: id
integer :: ierro
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer :: maxerr, nres, nrmax, numrl2
integer :: lp1, lp2, ln1, ln2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit), valp(21,limit), valn(21,limit)
!
!
!            Machine dependent constants
!            ---------------------------
!
!          epmach is the largest relative spacing.
!          uflow is the smallest positive magnitude.
!          OFLOW is the largest positive magnitude.
!
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!
!            Test on validity of parameters
!            ------------------------------
last = 0
result = 0.0
abserr = 0.0
alist(1) = a
blist(1) = b
rlist(1) = 0.0
elist(1) = 0.0
ier = 6
if (epsabs .lt. 0.0 .or. epsrel.lt. 0.0) go to 999
ier = 0
rerr = amax1(epsrel, 50.0*epmach)
!
!           First approximation to the integral
!           -----------------------------------
!
ierro = 0
lp(1) = 1
ln(1) = 1
valp(1,1) = f((a + b)*0.5)
valn(1,1) = valp(1,1)
call qxlqm (f,a,b,result,abserr,defabs,resabs, &
   & valp(1,1),valn(1,1),lp(1),ln(1),2, &
   & epmach,uflow,oflow)
!
!           Test on accuracy.
!
dres = abs(result)
errbnd = amax1(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr .le. 100.0*epmach*defabs .and. abserr .gt. &
   & errbnd) ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr.le.errbnd.and.abserr.ne.resabs) .or. &
   & abserr .eq. 0.0) go to 999
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
if (dres .ge. (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!
!           Main do-loop
!           ------------
!
do 90 last = 2,limit
!
!           Bisect the subinterval with the nrmax-TH largest error
!           estimate.
!
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qxrrd(f,valn(1,maxerr),ln(maxerr),b1,a1,vn1,vp1,ln1,lp1)
   call qxlqm(f,a1,b1,area1,error1,resabs,defab1,vp1,vn1,lp1,ln1, &
      & 2,epmach,uflow,oflow)
   call qxrrd(f,valp(1,maxerr),lp(maxerr),a2,b2,vp2,vn2,lp2,ln2)
   call qxlqm(f,a2,b2,area2,error2,resabs,defab2,vp2,vn2,lp2,ln2, &
      & 2,epmach,uflow,oflow)
!
!           Improve previous approximations to integral
!           and error and test for accuracy.
!
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 .eq. error1 .or. defab2 .eq. error2) go to 15
   if (abs(rlist(maxerr) - area12) .gt. 0.1e-04*abs(area12) &
      & .or. erro12 .lt. 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last.gt.10 .and. erro12.gt.errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = amax1(epsabs,rerr*abs(area))
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
   if (amax1(abs(a1),abs(b2)) .le. &
      & t*(abs(a2) + 1.e+03*uflow)) ier = 4
!
!           Append the newly-created intervals to the list.
!
   if (error2 .gt. error1) go to 20
   alist(last) = a2
   blist(maxerr) = b1
   blist(last) = b2
   elist(maxerr) = error1
   elist(last) = error2
   call qxcpy(valp(1,maxerr),vp1,lp1)
   lp(maxerr) = lp1
   call qxcpy(valn(1,maxerr),vn1,ln1)
   ln(maxerr) = ln1
   call qxcpy(valp(1,last),vp2,lp2)
   lp(last) = lp2
   call qxcpy(valn(1,last),vn2,ln2)
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
   call qxcpy(valp(1,maxerr),vp2,lp2)
   lp(maxerr) = lp2
   call qxcpy(valn(1,maxerr),vn2,ln2)
   ln(maxerr) = ln2
   call qxcpy(valp(1,last),vp1,lp1)
   lp(last) = lp1
   call qxcpy(valn(1,last),vn1,ln1)
   ln(last) = ln1
!
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the subinterval
!           with nrmax-TH largest error estimate (to be bisected next).
!
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum .le. errbnd) go to 115
! ***Jump out of do-loop
   if (ier .ne. 0) go to 100
   if (last .eq. 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) .gt. small) erlarg = erlarg + erro12
   if (extrap) go to 40
!
!           Test whether the interval to be bisected next is the
!           smallest interval.
!
   if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
   extrap = .true.
   nrmax = 2
!
!           The bound 0.3*ERTEST has been introduced to perform A
!           more cautious extrapolation than in the original dqagse
!           routine
!
40 if (ierro .eq. 3 .or. erlarg .le. 0.3*ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors over the
!           larger intervals (erlarg) and perform extrapolation.
!
   id = nrmax
   jupbnd = last
   if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
   do 50 k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (abs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
      nrmax = nrmax + 1
50    continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg (numrl2,rlist2,reseps,abseps,res3la,nres, &
      & epmach,oflow)
   ktmin = ktmin + 1
   if (ktmin .gt. 5 .and. abserr .lt. 0.1e-02*errsum) ier = 5
   if (abseps .ge. abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = amax1(epsabs,rerr*abs(reseps))
! ***Jump out of do-loop
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
   small = small*0.5
   erlarg = errsum
   go to 90
80 small = abs(b - a)*0.375
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
if (result .ne. 0.0 .and. area .ne. 0.0) go to 105
if (abserr .gt. errsum) go to 115
if (area .eq. 0.0) go to 130
go to 110
105 if (abserr/abs(result) .gt. errsum/abs(area)) go to 115
!
!           Test on divergence.
!
110 if (ksgn.eq.(-1).and.amax1(abs(result),abs(area)).le. &
   & defabs*0.1e-01) go to 130
if (0.1e-01.gt.(result/area).or.(result/area).gt.0.1e+03 &
   & .or.errsum.gt.abs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier .gt. 2) ier = ier - 1
999 return
end subroutine qxgse

pure subroutine qxcpy (a, b, l)
implicit none
integer, intent(in) :: l
real, intent(inout) :: a(l)
real, intent(in) :: b(l)
integer :: i
!
!  TO COPY THE REAL VECTOR b OF LENGTH l   i N T O
!          the real vector a of length l
!
!
do 10 i = 1,l
10 a(i) = b(i)
return
end subroutine qxcpy

subroutine qxlqm (f,a,b,result,abserr,resabs,resasc,vr,vs,lr,ls, &
   & key,epmach,uflow,oflow)
implicit none
!
!            To compute I = Integral of f over (a,b), with error
!                           estimate
!                       J = Integral of abs(f) over (a,b)
!
!           Parameters
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X t E R N A L in the driver program.
!
!              a      - REAL
!                       lower limit of integration
!
!              b      - REAL
!                       upper limit of integration
!
!              vr     - REAL
!                       vector of length lr containing the
!                       saved  functional values of positive abscissas
!
!              vs     - REAL
!                       vector of length ls containing the
!                       saved  functional values of negative abscissas
!
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTS IN
!                       vr,vs respectively
!
!            key    - INTEGER
!                     key for choice of local integration rule
!                     rms formulas are used with
!                      13 - 19               Points if key.LT.1,
!                      13 - 19 - (27)        points if key = 1,
!                      13 - 19 - (27) - (41) points if key = 2,
!                           19 -  27  - (41) points if key = 3,
!                                 27  -  41  Points if key.GT.3.
!
!                         (Rules) used if the function APPEARS
!                         enough regular
!
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              uflow  - REAL
!                       the smallest positive magnitude.
!
!              oflow  - REAL
!                       the largest positive magnitude.
!
!            On return
!              result - Real
!                       approximation to the integral I
!
!              abserr - REAL
!                       estimate of the modulus of the absolute error,
!                       which should not exceed abs(I-result)
!
!              resabs - REAL
!                       approximation to the integral J
!
!              resasc - REAL
!                       approximation to the integral of abs(f-I/(b-a))
!                       OVER (a,b)
!
!              vr     - REAL
!                       vector of length lr containing the
!                       saved  functional values of positive abscissas
!
!              vs     - REAL
!                       vector of length ls containing the
!                       saved  functional values of negative abscissas
!
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTS IN
!                       vr,vs respectively
!
!***Routines called  qxrul
!
real :: f
real, intent(in) :: a, b
real, intent(inout) :: result, abserr, resabs, resasc
real, intent(in) :: epmach, oflow, uflow
real, intent(inout) :: vr(21), vs(21)
integer, intent(in) :: key
integer, intent(inout) :: lr, ls
external f
real :: t
real :: resg, resk, errold
integer :: k, k0, k1, k2
integer :: key1
!
key1 = max0(key ,  0)
key1 = min0(key1,  4)
k0 = max0(key1 - 2,0)
k1 = k0 + 1
k2 = min0(key1 + 1,3)
!
call qxrul (f,a,b,resg,resabs,resasc,k0,k1,vr,vs,lr,ls)
errold = oflow
t = 10.0*epmach
do 10 k = k1,k2
   call qxrul (f,a,b,resk,resabs,resasc,k,k1,vr,vs,lr,ls)
   result = resk
   abserr = abs(resk - resg)
   if (resasc .ne. 0.0 .and. abserr .ne. 0.0) &
      & abserr = resasc*amin1(1.0,(200.0*abserr/resasc)**1.5)
   if (resabs .gt. uflow/t) abserr = amax1(t*resabs,abserr)
   resg = resk
   if (abserr .gt. errold*0.16) go to 3000
   if (abserr .lt. 1000.0*epmach*resabs) go to 3000
   errold = abserr
10 continue
3000 continue
return
end subroutine qxlqm

subroutine qxrul (f,xl,xu,y,ya,ym,ke,k1,fv1,fv2,l1,l2)
implicit none
real :: f
real, intent(in) :: xl, xu
real, intent(out) :: y
real, intent(inout) :: ya, ym
real, intent(inout) :: fv1(21), fv2(21)
integer, intent(in) :: ke, k1
integer, intent(inout) :: l1, l2
external f
integer :: i, is, k, ks
real :: ldl
real :: y2, xx(41), ww(52)
real :: aa, bb, c
integer :: istart(4), len(4), j
!
!            To compute i = Integral of f over (A,B), with error
!                           estimate
!            and conditionally compute
!                       j = Integral of abs(f) over (A,B)
!                       by using an  rms rule
!           parameters
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X T E R N A L in the driver program.
!
!              xl     - REAL
!                       lower limit of integration
!
!              xu     - REAL
!                       upper limit of integration
!
!              ke     - INTEGER
!                     key for choice of local integration rule
!                     an rms rule is used with
!                         13      points if ke  = 2,
!                         19      points if ke  = 3,
!                         27      points if ke  = 4,
!                         42      points if ke  = 5
!
!              k1     INTEGER
!                     value of key for which the additional estimates
!                     ya, ym are to be computed
!
!              fv1    - REAL
!                       vector containing l1
!                       saved  functional values of positive abscissas
!
!              fv2    - REAL
!                       vector containing l2
!                       saved  functional values of negative abscissas
!
!              l1     - INTEGER
!              l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!
!            On return
!              y      - REAL
!                       approximation to the integral i
!                       result is computed by applying the
!                       requested rms rule
!
!              ya     - REAL
!                       if key = k1  approximation to the integral j
!                       ELSE UNCHANGED
!
!              ym     - REAL
!                       if key = k1  approximation to the integral of
!                                      abs(f-i/(xu-xl)   OVER (xl,xu)
!                       ELSE UNCHANGED
!
!              fv1    - REAL
!                       vector containing l1
!                       saved  functional values of positive abscissas
!
!              fv2    - REAL
!                       vector containing l2
!                       saved  functional values of negative abscissas
!
!              l1     - INTEGER
!              l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!
!------------------------
!------------------------
data istart(1)/0/, istart(2)/7/, istart(3)/17/, istart(4)/31/
data len(1)/7/, len(2)/10/, len(3)/14/, len(4)/21/
!------------------------
data xx( 1)/.0                       /
data xx( 2)/.25000000000000000000e+00/
data xx( 3)/.50000000000000000000e+00/
data xx( 4)/.75000000000000000000e+00/
data xx( 5)/.87500000000000000000e+00/
data xx( 6)/.93750000000000000000e+00/
data xx( 7)/.10000000000000000000e+01/
data xx( 8)/.37500000000000000000e+00/
data xx( 9)/.62500000000000000000e+00/
data xx(10)/.96875000000000000000e+00/
data xx(11)/.12500000000000000000e+00/
data xx(12)/.68750000000000000000e+00/
data xx(13)/.81250000000000000000e+00/
data xx(14)/.98437500000000000000e+00/
data xx(15)/.18750000000000000000e+00/
data xx(16)/.31250000000000000000e+00/
data xx(17)/.43750000000000000000e+00/
data xx(18)/.56250000000000000000e+00/
data xx(19)/.84375000000000000000e+00/
data xx(20)/.90625000000000000000e+00/
data xx(21)/.99218750000000000000e+00/
!   Number of nodes 13
data ww(1)/1.303262173284849021810473057638590518409112513421e-1/
data ww(2)/2.390632866847646220320329836544615917290026806242e-1/
data ww(3)/2.630626354774670227333506083741355715758124943143e-1/
data ww(4)/2.186819313830574175167853094864355208948886875898e-1/
data ww(5)/2.757897646642836865859601197607471574336674206700e-2/
data ww(6)/1.055750100538458443365034879086669791305550493830e-1/
data ww(7)/1.571194260595182254168429283636656908546309467968e-2/
!   Number of nodes 19
data ww(8)/1.298751627936015783241173611320651866834051160074e-1/
data ww(9)/2.249996826462523640447834514709508786970828213187e-1/
data ww(15)/5.542699233295875168406783695143646338274805359780e-2/
data ww(10)/1.680415725925575286319046726692683040162290325505e-1/
data ww(16)/9.986735247403367525720377847755415293097913496236e-2/
data ww(11)/1.415567675701225879892811622832845252125600939627e-1/
data ww(12)/1.006482260551160175038684459742336605269707889822e-1/
data ww(13)/2.510604860724282479058338820428989444699235030871e-2/
data ww(17)/4.507523056810492466415880450799432587809828791196e-2/
data ww(14)/9.402964360009747110031098328922608224934320397592e-3/
!   Number of nodes 27
data ww(18)/6.300942249647773931746170540321811473310938661469e-2/
data ww(28)/1.239572396231834242194189674243818619042280816640e-1/
data ww(19)/1.261383225537664703012999637242003647020326905948e-1/
data ww(25)/1.235837891364555000245004813294817451524633100256e-1/
data ww(20)/1.273864433581028272878709981850307363453523117880e-1/
data ww(26)/1.148933497158144016800199601785309838604146040215e-1/
data ww(29)/2.501306413750310579525950767549691151739047969345e-2/
data ww(21)/8.576500414311820514214087864326799153427368592787e-2/
data ww(30)/4.915957918146130094258849161350510503556792927578e-2/
data ww(22)/7.102884842310253397447305465997026228407227220665e-2/
data ww(23)/5.026383572857942403759829860675892897279675661654e-2/
data ww(27)/1.252575774226122633391477702593585307254527198070e-2/
data ww(31)/2.259167374956474713302030584548274729936249753832e-2/
data ww(24)/4.683670010609093810432609684738393586390722052124e-3/
!   Number of nodes 41
data ww(32)/6.362762978782724559269342300509058175967124446839e-2/
data ww(42)/1.187141856692283347609436153545356484256869129472e-1/
data ww(46)/1.533126874056586959338368742803997744815413565014e-2/
data ww(33)/9.950065827346794643193261975720606296171462239514e-2/
data ww(47)/3.527159369750123100455704702965541866345781113903e-2/
data ww(39)/8.140326425945938045967829319725797511040878579808e-2/
data ww(48)/5.000556431653955124212795201196389006184693561679e-2/
data ww(34)/7.048220002718565366098742295389607994441704889441e-2/
data ww(49)/5.744164831179720106340717579281831675999717767532e-2/
data ww(40)/6.583213447600552906273539578430361199084485578379e-2/
data ww(43)/5.999947605385971985589674757013565610751028128731e-2/
data ww(35)/6.512297339398335645872697307762912795346716454337e-2/
data ww(44)/5.500937980198041736910257988346101839062581489820e-2/
data ww(50)/1.598823797283813438301248206397233634639162043386e-2/
data ww(36)/3.998229150313659724790527138690215186863915308702e-2/
data ww(51)/2.635660410220884993472478832884065450876913559421e-2/
data ww(37)/3.456512257080287509832054272964315588028252136044e-2/
data ww(41)/2.592913726450792546064232192976262988065252032902e-2/
data ww(45)/5.264422421764655969760271538981443718440340270116e-3/
data ww(52)/1.196003937945541091670106760660561117114584656319e-2/
data ww(38)/2.212167975884114432760321569298651047876071264944e-3/
!------------------------
k = ke + 1
is = istart(k)
ks = len(k)
ldl = xu - xl
bb = ldl*0.5
aa = xl + bb
!
y = 0.0
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
ya = 0.0
do 20 i = 1,ks
   j = is + i
   ya = ya + (abs(fv1(i)) + abs(fv2(i)))*ww(j)
20 continue
ya = ya*abs(bb)
!
y2 = y2*0.5
ym = 0.0
do 30 i = 1,ks
   j = is + i
   ym = ym + (abs(fv1(i) - y2) + abs(fv2(i) - y2))*ww(j)
30 continue
ym = ym*abs(bb)
return
end subroutine qxrul

subroutine qxrrd (f,z,lz,xl,xu,r,s,lr,ls)
implicit none
!
!            To reorder the computed functional values before
!            the bisection of an interval
!
!           Parameters
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X T E r N A L in the driver program.
!
!              xl     - REAL
!                       lower limit of interval
!
!              xu     - REAL
!                       upper limit of interval
!
!              z      - REAL
!                       vector containing lz
!                       saved  functional values
!
!              lz     - INTEGER
!                       number of elements in lz
!
!            On return
!              r      - REAL
!              s        VECTORS CONTAINING lr, ls
!                       saved  functional values for the new intervals
!
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTES IN r,s RESPECTIVELY
!
!***Routines called  f
!
real :: f
real, intent(inout) :: r(21), s(21)
real :: z(21)
real, intent(in) :: xu, xl
integer, intent(inout) :: lr, ls
integer, intent(in) :: lz
real :: dlen, centr
!
dlen = (xu - xl)*0.5
centr = xl + dlen
r(1) = z(3)
r(2) = z(9)
r(3) = z(4)
r(4) = z(5)
r(5) = z(6)
r(6) = z(10)
r(7) = z(7)
s(1) = z(3)
s(2) = z(8)
s(3) = z(2)
s(7) = z(1)
if (lz .gt. 11) go to 10
!
r(8) = f(centr + dlen*0.375)
r(9) = f(centr + dlen*0.625)
r(10) = f(centr + dlen*0.96875)
lr = 10
if (lz .ne. 11) s(4) = f(centr - dlen*0.75)
if (lz .eq. 11) s(4) = z(11)
s(5) = f(centr - dlen*0.875)
s(6) = f(centr - dlen*0.9375)
s(8) = f(centr - dlen*0.375)
s(9) = f(centr - dlen*0.625)
s(10) = f(centr - dlen*0.96875)
ls = 10
return
!
10 r(8) = z(12)
r(9) = z(13)
r(10) = z(14)
lr = 10
s(4) = z(11)
s(5) = f(centr - dlen*0.875)
s(6) = f(centr - dlen*0.9375)
if (lz .gt. 14) go to 20
s(8) = f(centr - dlen*0.375)
s(9) = f(centr - dlen*0.625)
s(10) = f(centr - dlen*0.96875)
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
s(10) = f(centr - dlen*0.96875)
s(11) = z(17)
ls = 11
return
end subroutine qxrrd

subroutine dqags (f, a, b, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
implicit none
integer, intent(out) :: last
double precision, intent(in) :: a
double precision, intent(out) :: abserr
double precision, intent(in) :: b, epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
external f
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!
!           Double precision computation of a definite integral
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!
!            a      - Double precision
!                     lower limit of integration
!
!            b      - Double precision
!                     upper limit of integration
!
!            epsabs - Double precision
!                     absolute accuracy requested
!
!            epsrel - Double precision
!                     relative accuracy requested
!
!         On return
!            result - Double precision
!                     approximation to the integral
!
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            neval  - INTEGER
!                     number of integrand evaluations
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (a,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of
!                    significant elements actually in the work
!                    arrays.
!
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!
!            work  - Double precision
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!
!         Subroutines or functions needed
!              - dqagse
!              - dqk21
!              - dqpsrt
!              - dqelg
!              - f (user-provided function)
!              - dpmpar
!
!-----------------------------------------------------------------------
!
dimension iwork(limit), work(lenw)
!
!         Check validity of limit and lenw.
!
ier = 6
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         Prepare call for dqagse.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call dqagse (f,a,b,epsabs,epsrel,limit,result,abserr,neval, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last)
return
end subroutine dqags

subroutine dqagse (f,a,b,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!
!           Double precision computation of a definite integral
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!
!            a      - Double precision
!                     lower limit of integration
!
!            b      - Double precision
!                     upper limit of integration
!
!            epsabs - Double precision
!                     absolute accuracy requested
!
!            epsrel - Double precision
!                     relative accuracy requested
!
!            limit  - Integer
!                     gives an upperbound on the number of
!                     subintervals in the partition of (a,b)
!
!         On return
!            result - Double precision
!                     approximation to the integral
!
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            neval  - INTEGER
!                     number of integrand evaluations
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!
!                         = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             iord(1) and elist(1) are set to zero.
!                             alist(1) and blist(1) are set to A and b
!                             respectively.
!
!            alist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!
!            blist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!
!            rlist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            elist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     SUBINERVALS
!
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the error
!                     estimates over the subintervals, such
!                     THAT elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!
!         Subroutines or functions needed
!              - dqk21
!              - dqpsrt
!              - dqelg
!              - f (user-provided function)
!              - dpmpar
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision, intent(in) :: b
double precision, intent(inout) :: blist
double precision, intent(inout) :: elist
double precision, intent(in) :: epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
double precision :: abseps
double precision :: area, area1, area12, area2, a1, a2
double precision :: b1, b2, correc, defabs, defab1, defab2, &
   & dpmpar, dres
double precision :: epmach
double precision :: erlarg, erlast, errbnd, errmax, error1, &
   & error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps
double precision :: res3la(3)
double precision :: rlist2(52), small, t, uflow
integer :: id
integer :: ierro
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer :: maxerr
integer :: nres, nrmax, numrl2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!
!
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine dqelg (rlist2 should be of dimension
!            (LIMEXP+2) at least).
!
!            List of major variables
!            -----------------------
!
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least LIMEXP+2
!                       containing the part of the epsilon table
!                       which is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left interval
!           *****2    - Variable for the right interval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered
!                       up to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation
!                       I.E. before subdividing the smallest interval
!                       we try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (true value)
!
!            Machine dependent constants
!            ---------------------------
!
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!
!            Check epsabs and epsrel
!            -----------------------
!
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
alist(1) = a
blist(1) = b
rlist(1) = 0.d0
elist(1) = 0.d0
ier = 6
if (epsabs .lt. 0.d0 .or. epsrel .lt. 0.d0) go to 999
ier = 0
rerr = dmax1(epsrel, 50.d0*epmach, 0.5d-28)
!
!           First approximation to the integral
!           -----------------------------------
!
ierro = 0
call dqk21 (f, a, b, result, abserr, defabs, resabs, &
   & epmach, uflow, id)
if (id .ne. 0) go to 999
neval = 21
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
   & errbnd) ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0) go to 999
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
!           Bisect the subinterval with the nrmax-TH largest
!           error estimate.
!
   a1 = alist(maxerr)
   b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call dqk21 (f, a1, b1, area1, error1, resabs, defab1, &
      & epmach, uflow, ier)
   if (ier .ne. 0) go to 100
   call dqk21 (f, a2, b2, area2, error2, resabs, defab2, &
      & epmach, uflow, ier)
   neval = neval + 42
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
      & .or. erro12 .lt. 0.99d0*errmax) go to 10
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
!           at a point of the integration range.
!
   if (dmax1(dabs(a1),dabs(b2)) .le. &
      & t*(dabs(a2) + 0.1d+04*uflow)) ier = 4
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
!           CALL SUBROUTINE dqpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
!
30 call dqpsrt (limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum .le. errbnd) go to 115
! ***Jump out of do-loop
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
!           over the larger intervals (erlarg) and perform
!           extrapolation.
!
   id = nrmax
   jupbnd = last
   if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
   do 50 k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
      nrmax = nrmax + 1
50    continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call dqelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin .gt. 5 .and. abserr .lt. 0.1d-02*errsum) ier = 5
   if (abseps .ge. abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = dmax1(epsabs,rerr*dabs(reseps))
! ***Jump out of do-loop
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
110 if (ksgn .eq. -1 .and. dmax1(dabs(result),dabs(area)) .le. &
   & defabs*0.1d-01) go to 130
if (0.1d-01 .gt. (result/area) .or. (result/area) .gt. 0.1d+03 &
   & .or. errsum .gt. dabs(area)) ier = 6
go to 130
!
!           Compute global integral sum.
!
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier .gt. 2) ier = ier - 1
999 return
end subroutine dqagse

subroutine dqk21 (f, a, b, result, abserr, resabs, resasc, &
   & epmach, uflow, isig)
implicit none
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              to compute I = Integral of f over (a,b), with error
!                             estimate
!                         j = Integral of dabs(f) over (a,b)
!
! 2.        PARAMETERS
!            on entry
!              f      - Double precision
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!
!              a      - Double precision
!                       lower limit of integration
!
!              b      - Double precision
!                       upper limit of integration
!
!              epmach - Double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              uflow  - Double precision
!                       the smallest positive magnitude.
!
!            On return
!              result - Double precision
!                       approximation to the integral I
!                       result is computed by applying the 21-point
!                       Kronrod rule (resk) obtained by optimal
!                       addition of abscissae to the 10-point Gauss
!                       RULE (resg).
!
!              abserr - Double precision
!                       estimate of the modulus of the absolute error,
!                       which should not exceed abs(I-result)
!
!              resabs - Double precision
!                       approximation to the integral j
!
!              resasc - Double precision
!                       approximation to the integral of abs(f-I/(b-a))
!                       OVER (a,b)
!
!              isig   - INTEGER
!                       isig=0  The integral was approximated.
!                       isig=5  The interval (a,b) is too short.
!                               The integral cannot be computed.
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision, intent(inout) :: abserr
double precision, intent(in) :: b
double precision, intent(in) :: epmach
double precision :: f
double precision, intent(inout) :: resabs
double precision, intent(inout) :: result
double precision, intent(in) :: uflow
double precision, intent(inout) :: resasc
integer, intent(out) :: isig
external f
double precision :: absc
double precision :: centr, dhlgth
double precision :: fc, fsum, fval1, fval2, fv1(10), fv2(10), &
   & hlgth
double precision :: resg, resk, reskh
double precision :: tol
double precision :: wg(5), wgk(11), xgk(11)
integer :: j, jtw, jtwm1
!
!
!           The abscissae and weights are given for the interval (-1,1).
!           Because of symmetry only the positive abscissae and their
!           corresponding weights are given.
!
!           xgk    - Abscissae of the 21-point Kronrod rule
!                    xgk(2), xgk(4), ...  abscissae of the 10-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 10-point Gauss rule
!
!           wgk    - Weights of the 21-point Kronrod rule
!
!           wg     - Weights of the 10-point Gauss rule
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
   & xgk(8),xgk(9),xgk(10),xgk(11)/ &
   & 0.995657163025808080735527280689d+00, &
   & 0.973906528517171720077964012084d+00, &
   & 0.930157491355708226001207180060d+00, &
   & 0.865063366688984510732096688423d+00, &
   & 0.780817726586416897063717578345d+00, &
   & 0.679409568299024406234327365115d+00, &
   & 0.562757134668604683339000099273d+00, &
   & 0.433395394129247190799265943166d+00, &
   & 0.294392862701460198131126603104d+00, &
   & 0.148874338981631210884826001130d+00, &
   & 0.000000000000000000000000000000d+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
   & wgk(8),wgk(9),wgk(10),wgk(11)/ &
   & 0.116946388673718742780643960622d-01, &
   & 0.325581623079647274788189724594d-01, &
   & 0.547558965743519960313813002446d-01, &
   & 0.750396748109199527670431409162d-01, &
   & 0.931254545836976055350654650834d-01, &
   & 0.109387158802297641899210590326d+00, &
   & 0.123491976262065851077958109831d+00, &
   & 0.134709217311473325928054001772d+00, &
   & 0.142775938577060080797094273139d+00, &
   & 0.147739104901338491374841515972d+00, &
   & 0.149445554002916905664936468390d+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5)/ &
   & 0.666713443086881375935688098933d-01, &
   & 0.149451349150580593145776339658d+00, &
   & 0.219086362515982043995534934228d+00, &
   & 0.269266719309996355091226921569d+00, &
   & 0.295524224714752870173892994651d+00/
!
!
!           List of major variables
!           -----------------------
!
!           centr  - Mid point of the interval
!           HLGTH  - Half-length of the interval
!           absc   - ABSCISSA
!           FVAL*  - Function VALUE
!           resg   - result of the 10-point Gauss formula
!           resk   - result of the 21-point Kronrod formula
!           reskh  - Approximation to the mean value of f over (a,b),
!                    I.E. TO I/(b-a)
!
!
centr = 0.5d0*(a + b)
hlgth = 0.5d0*(b - a)
dhlgth = dabs(hlgth)
!
!             Check if the interval (a,b) is too short
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
   resasc = resasc + wgk(j)*(dabs(fv1(j) - reskh) &
      & + dabs(fv2(j) - reskh))
end do
result = resk*hlgth
resabs = resabs*dhlgth
resasc = resasc*dhlgth
abserr = dabs((resk - resg)*hlgth)
if (resasc .ne. 0.d0 .and. abserr .ne. 0.d0) &
   & abserr = resasc*dmin1(1.d0, &
   & (0.2d+03*abserr/resasc)**1.5d0)
tol = epmach*0.5d+02
if (resabs .gt. uflow/tol) abserr = dmax1(abserr,tol*resabs)
return
end subroutine dqk21

subroutine dqagi (f, bound, inf, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
implicit none
integer, intent(in) :: inf
integer, intent(out) :: last
double precision, intent(out) :: abserr
double precision, intent(in) :: bound, epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
external f
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!
!         Double precision integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!
!            bound  - Double precision
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!
!            epsabs - Double precision
!                     absolute accuracy requested
!
!            epsrel - Double precision
!                     relative accuracy requested
!
!         On return
!            result - Double precision
!                     approximation to the integral
!
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            neval  - INTEGER
!                     number of integrand evaluations
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     ier = 1 Maximum number of subdivisions allowed
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
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of significant
!                    elements actually in the work arrays.
!
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first
!                    K elements of which contain pointers
!                    to the error estimates over the subintervals,
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!
!            work  - Double precision
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!
!        Subroutines or functions needed
!              - dqagie
!              - dqk15i
!              - dqpsrt
!              - dqelg
!              - f (user provided function)
!              - dpmpar
!
!-----------------------------------------------------------------------
!
dimension iwork(limit),work(lenw)
!
!
!         Check validity of limit and lenw.
!
ier = 6
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
if (limit .lt. 1 .or. lenw .lt. limit*4) return
!
!         Prepare call for dqagie
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
!
call dqagie (f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
return
end subroutine dqagi

subroutine dqagie (f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
implicit none
!-----------------------------------------------------------------------
!
!                   Integration over infinite intervals
!
!-----------------------------------------------------------------------
!
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!
!            bound  - Double precision
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!
!            epsabs - Double precision
!                     absolute accuracy requested
!
!            epsrel - Double precision
!                     relative accuracy requested
!
!            limit  - Integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     limit.GE.1
!
!         On return
!            result - Double precision
!                     approximation to the integral
!
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!
!            neval  - INTEGER
!                     number of integrand evaluations
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!
!                     ier = 1 Maximum number of subdivisions allowed
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
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             elist(1) and iord(1) are set to zero.
!                             alist(1) and blist(1) are set to 0
!                             and 1 respectively.
!
!            alist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            blist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!
!            rlist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            elist  - Double precision
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!
!            iord   - INTEGER
!                     vector of dimension limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!
!            last   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!
!        Subroutines or functions needed
!              - dqk15i
!              - dqpsrt
!              - dqelg
!              - f (user-provided function)
!              - dpmpar
!
!-----------------------------------------------------------------------
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision, intent(inout) :: blist
double precision, intent(in) :: bound
double precision, intent(inout) :: elist
double precision, intent(in) :: epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
double precision :: abseps
double precision :: area, area1, area12, area2, a1, a2
double precision :: boun
double precision :: b1, b2, correc, defabs, defab1, defab2, dres, &
   & dpmpar
double precision :: epmach
double precision :: erlarg, erlast, errbnd, errmax, error1, &
   & error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps
double precision :: res3la(3)
double precision :: rlist2(52), small, t, uflow
integer :: id
integer :: ierro
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer :: maxerr
integer :: nres, nrmax, numrl2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!
!
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine dqelg.
!
!
!            List of major variables
!            -----------------------
!
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left subinterval
!           *****2    - Variable for the right subinterval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered up
!                       to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (TRUE-VALUE)
!
!            Machine dependent constants
!            ---------------------------
!
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
!
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!
!           Check epsabs and epsrel
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
!           If inf = 2 The integral is computed as I = I1+I2, where
!           I1 = Integral of f over (-INFINITY,0),
!           I2 = Integral of f over (0,+INFINITY).
!
boun = bound
if (inf .eq. 2) boun = 0.d0
call dqk15i (f, boun, inf, 0.d0, 1.d0, result, abserr, &
   & defabs, resabs, epmach, uflow)
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
   & ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr .le. errbnd .and. abserr .ne. resabs) &
   & .or. abserr .eq. 0.d0) go to 130
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
!           Bisect the subinterval with nrmax-TH largest
!           error estimate.
!
   a1 = alist(maxerr)
   b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call dqk15i (f, boun, inf, a1, b1, area1, error1, &
      & resabs, defab1, epmach, uflow)
   call dqk15i (f, boun, inf, a2, b2, area2, error2, &
      & resabs, defab2, epmach, uflow)
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
      & .or. erro12 .lt. 0.99d0*errmax) go to 10
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
      & t*(dabs(a2) + 0.1d+04*uflow)) ier = 4
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
!           CALL SUBROUTINE dqpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
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
!           over the larger intervals (erlarg) and perform
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
50    continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call dqelg (numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
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
   & defabs*0.1d-01) go to 130
if (0.1d-01 .gt. (result/area) .or. (result/area) .gt. 0.1d+03 &
   & .or. errsum .gt. dabs(area)) ier = 6
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
   & resasc, epmach, uflow)
implicit none
integer, intent(in) :: inf
double precision, intent(in) :: a
double precision, intent(inout) :: abserr
double precision, intent(in) :: b, boun
double precision, intent(in) :: epmach
double precision :: f
double precision, intent(inout) :: resabs, resasc
double precision, intent(inout) :: result
double precision, intent(in) :: uflow
external f
integer :: j
double precision :: absc, absc1, absc2
double precision :: centr, dinf
double precision :: fc, fsum, fval1, fval2, hlgth
double precision :: resg, resk, reskh
double precision :: tabsc1, tabsc2, tol
double precision :: fv1(7), fv2(7), xgk(8), wgk(8), wg(8)
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (a,b) is a part of (0,1).
!              It is the purpose to compute
!              I = Integral of transformed integrand over (a,b),
!              j = Integral of abs(transformed integrand) over (a,b).
!
! 2.        PARAMETERS
!            on entry
!              f      - Double precision
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!
!              boun   - Double precision
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF inf = +2)
!
!              inf    - INTEGER
!                       if inf = -1, the original interval is
!                                   (-INFINITY,BOUND),
!                       if inf = +1, the original interval is
!                                   (BOUND,+INFINITY),
!                       if inf = +2, the original interval is
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!
!              a      - Double precision
!                       lower limit for integration over subrange
!                       of (0,1)
!
!              b      - Double precision
!                       upper limit for integration over subrange
!                       of (0,1)
!
!              epmach - Double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              uflow  - Double precision
!                       the smallest positive magnitude.
!
!            On return
!              result - Double precision
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod rule(resk) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(resg).
!
!              abserr - Double precision
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed abs(I-result)
!
!              resabs - Double precision
!                       approximation to the integral j
!
!              resasc - Double precision
!                       approximation to the integral of
!                       abs((transformed integrand)-I/(b-a))
!                       OVER (a,b)
!
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!
!-----------------------------------------------------------------------
!
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!
!           xgk    - Abscissae of the 15-point Kronrod rule
!                    xgk(2), xgk(4), ... abscissae of the 7-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!
!           wgk    - Weights of the 15-point Kronrod rule
!
!           wg     - Weights of the 7-point Gauss rule, corresponding
!                    to the abscissae xgk(2), xgk(4), ...
!                    wg(1), wg(3), ... are set to zero.
!
data xgk(1),xgk(2),xgk(3),xgk(4),xgk(5),xgk(6),xgk(7), &
   & xgk(8)/ &
   & 0.991455371120812639206854697526d+00, &
   & 0.949107912342758524526189684048d+00, &
   & 0.864864423359769072789712788641d+00, &
   & 0.741531185599394439863864773281d+00, &
   & 0.586087235467691130294144838259d+00, &
   & 0.405845151377397166906606412077d+00, &
   & 0.207784955007898467600689403773d+00, &
   & 0.000000000000000000000000000000d+00/
!
data wgk(1),wgk(2),wgk(3),wgk(4),wgk(5),wgk(6),wgk(7), &
   & wgk(8)/ &
   & 0.229353220105292249637320080590d-01, &
   & 0.630920926299785532907006631892d-01, &
   & 0.104790010322250183839876322542d+00, &
   & 0.140653259715525918745189590510d+00, &
   & 0.169004726639267902826583426599d+00, &
   & 0.190350578064785409913256402421d+00, &
   & 0.204432940075298892414161999235d+00, &
   & 0.209482141084727828012999174892d+00/
!
data wg(1),wg(2),wg(3),wg(4),wg(5),wg(6),wg(7),wg(8)/ &
   & 0.0d+00,    0.129484966168869693270611432679d+00, &
   & 0.0d+00,    0.279705391489276667901467771424d+00, &
   & 0.0d+00,    0.381830050505118944950369775489d+00, &
   & 0.0d+00,    0.417959183673469387755102040816d+00/
!
!
!           List of major variables
!           -----------------------
!
!           centr  - Mid point of the interval
!           hlgth  - Half-length of the interval
!           absc*  - ABSCISSA
!           TABSC* - Transformed abscissa
!           FVAL*  - Function VALUE
!           resg   - result of the 7-point Gauss formula
!           resk   - result of the 15-point Kronrod formula
!           reskh  - Approximation to the mean value of the transformed
!                    integrand over (a,b), I.E. to I/(b-a)
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
   resasc = resasc + wgk(j)*(dabs(fv1(j) - reskh) + &
      & dabs(fv2(j) - reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = dabs((resk - resg)*hlgth)
if (resasc .ne. 0.d0 .and. abserr .ne. 0.d0) abserr = resasc* &
   & dmin1(1.d0, (0.2d+03*abserr/resasc)**1.5d0)
tol = 50.d0*epmach
if (resabs .gt. uflow/tol) abserr = dmax1(abserr, tol*resabs)
return
end subroutine dqk15i

subroutine dqpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
implicit none
!     ..................................................................
!
! 1.        dqpsrt
!           ordering routine
!              standard Fortran subroutine
!              double precision version
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
!              call dqpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!
!           Parameters (meaning at output)
!              limit  - Integer
!                       maximum number of error estimates the list
!                       can contain
!
!              last   - INTEGER
!                       number of error estimates currently
!                       in the list
!
!              maxerr - INTEGER
!                       maxerr points to the nrmax-TH largest error
!                       estimate currently in the list
!
!              ermax  - Double precision
!                       nrmax-TH largest error estimate
!                       ermax = elist(maxerr)
!
!              elist  - Double precision
!                       vector of dimension last containing
!                       the error estimates
!
!              iord   - INTEGER
!                       vector of dimension last, the first k
!                       elements of which contain pointers
!                       to the error estimates, such that
!                       elist(iord(1)),... , elist(iord(k))
!                       form a decreasing sequence, with
!                       k = last if last.LE.(limit/2+2), and
!                       k = limit+1-last otherwise
!
!              nrmax  - INTEGER
!                       maxerr = iord(nrmax)
!
! 4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!
!     ..................................................................
!
double precision :: elist
double precision, intent(inout) :: ermax
integer, intent(inout) :: iord
integer, intent(in) :: last, limit
integer, intent(inout) :: maxerr, nrmax
double precision :: errmax, errmin
integer :: i, ibeg, ido
integer :: isucc, j, jbnd, jupbn, k
dimension elist(last),iord(last)
!
!           Check whether the list contains more than
!           two error estimates.
!
!***First executable statement dqpsrt
if (last.gt.2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!
!           This part of the routine is only executed
!           if, due to a difficult integrand, subdivision
!           increased the error estimate. In the normal case
!           the insert procedure should start after the
!           nrmax-TH largest error estimate.
!
10 errmax = elist(maxerr)
if (nrmax.eq.1) go to 30
ido = nrmax - 1
do i = 1,ido
   isucc = iord(nrmax - 1)
! ***Jump out of do-loop
   if (errmax.le.elist(isucc)) go to 30
   iord(nrmax) = isucc
   nrmax = nrmax - 1
end do
!
!           Compute the number of elements in the list to
!           be maintained in descending order. This number
!           depends on the number of subdivisions still
!           allowed.
!
30 jupbn = last
if (last.gt.(limit/2 + 2)) jupbn = limit + 3 - last
errmin = elist(last)
!
!           Insert errmax by traversing the list top-down,
!           starting comparison from the element elist(iord(nrmax+1)).
!
jbnd = jupbn - 1
ibeg = nrmax + 1
if (ibeg.gt.jbnd) go to 50
do i = ibeg,jbnd
   isucc = iord(i)
! ***Jump out of do-loop
   if (errmax.ge.elist(isucc)) go to 60
   iord(i - 1) = isucc
end do
50 iord(jbnd) = maxerr
iord(jupbn) = last
go to 90
!
!           Insert errmin by traversing the list bottom-up.
!
60 iord(i - 1) = maxerr
k = jbnd
do j = i,jbnd
   isucc = iord(k)
! ***Jump out of do-loop
   if (errmin.lt.elist(isucc)) go to 80
   iord(k + 1) = isucc
   k = k - 1
end do
iord(i) = last
go to 90
80 iord(k + 1) = last
!
!           Set maxerr and ermax.
!
90 maxerr = iord(nrmax)
ermax = elist(maxerr)
return
end subroutine dqpsrt

pure subroutine dqelg (n, epstab, result, abserr, res3la, nres, &
   & epmach, oflow)
implicit none
!-----------------------------------------------------------------------
!
! 1.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
!
! 2.        PARAMETERS
!              n      - INTEGER
!                       epstab(n) contains the new element in the
!                       first column of the epsilon table.
!
!              epstab - Double precision
!                       vector of dimension 52 containing the
!                       elements of the two lower diagonals of
!                       the triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!
!              result - Double precision
!                       resulting approximation to the integral
!
!              abserr - Double precision
!                       estimate of the absolute error computed from
!                       result and the 3 previous results
!
!              res3la - Double precision
!                       vector of dimension 3 containing the last 3
!                       results
!
!              nres   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!
!              epmach - Double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              oflow  - Double precision
!                       the largest positive magnitude.
!
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!
!-----------------------------------------------------------------------
double precision, intent(out) :: abserr
double precision, intent(in) :: epmach
double precision, intent(inout) :: epstab(52)
double precision, intent(in) :: oflow
double precision, intent(out) :: result
double precision, intent(inout) :: res3la(3)
integer, intent(inout) :: n
integer, intent(inout) :: nres
double precision :: delta1, delta2, delta3
double precision :: epsinf
double precision :: error, err1, err2, err3, e0, e1, e1abs, e2, e3
double precision :: res
double precision :: ss, tol1, tol2, tol3
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp
integer :: newelm
integer :: num
!---------------------
!
!           List of major variables
!           -----------------------
!
!           e0     - The 4 elements on which the
!           e1       COMPUTATION OF A NEW ELEMENT IN
!           e2       THE EPSILON TABLE IS BASED
!           e3                 e0
!                        e3    e1    NEW
!                              e2
!           newelm - Number of elements to be computed in the new
!                    diagonal
!           error  - error = abs(e1-e0) + abs(e2-e1) + abs(NEW-e2)
!           result - The element in the new diagonal with least value
!                    of error
!
!           limexp is the maximum number of elements the epsilon
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
!           If e0, e1 and e2 are equal to within machine
!           accuracy, convergence is assumed.
!           result = e2
!           abserr = abs(e1-e0) + abs(e2-e1)
!
   result = res
   abserr = err2 + err3
! ***Jump out of do-loop
   go to 100
10 e3 = epstab(k1)
   epstab(k1) = e1
   delta1 = e1 - e3
   err1 = dabs(delta1)
   tol1 = dmax1(e1abs,dabs(e3))*epmach
!
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of n
!
   if (err1.le.tol1 .or. err2.le.tol2 .or. err3.le.tol3) go to 20
   ss = 1.d0/delta1 + 1.d0/delta2 - 1.d0/delta3
   epsinf = dabs(ss*e1)
!
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF n.
!
   if (epsinf .gt. 0.1d-03) go to 30
20 n = i + i - 1
! ***Jump out of do-loop
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
   & dabs(result - res3la(1))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = dmax1(abserr,5.d0*epmach*dabs(result))
return
end subroutine dqelg

subroutine dqxgs (f,a,b,epsabs,epsrel,result,abserr,ier, &
   & limit,leniw,lenw,last,iwork,work)
implicit none
!
!            The routine calculates an approximation result to a given
!            definite integral  I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            dabs(I-result).LE.max(epsabs,epsrel*dabs(I)).
!
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!
!            a      - Double precision
!                     lower limit of integration
!
!            b      - Double precision
!                     upper limit of integration
!
!            epsabs - Double precision
!                     absolute accuracy requested
!
!            epsrel - Double precision
!                     relative accuracy requested
!
!         On return
!            result - Double precision
!                     approximation to the integral
!
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed dabs(I-result)
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account. However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table. It is presumed that
!                             the requested tolerance cannot be
!                             achieved, and that the returned result is
!                             the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel IS NEGATIVE, limit .LT. 1,
!                             lenw .LT. 46*limit, OR
!                             leniw .LT. 3*limit.
!                             Result, abserr, last are set to
!                             zero. Except when limit or lenw or leniw
!                             is invalid, iwork(1), work(limit*2+1) and
!                             work(limit*3+1) are set to zero, work(1)
!                             is set to A, and work(limit+1) to b.
!
!         Dimensioning parameters
!            limit - Integer
!                    limit determines the maximum number of subintervals
!                    in the partition of the given integration interval
!                    (A,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with ier = 6.
!
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*46.
!                    If lenw.LT.limit*46, the routine will end
!                    with ier = 6.
!
!            leniw - INTEGER
!                    dimensioning parameter for iwork
!                    leniw must be at least limit*3.
!                    If lenw.LT.limit*3, the routine will end
!                    with ier = 6.
!
!            last  - Integer
!                    on return, last equals the number of subintervals
!                    produced in the subdivision process, which deter-
!                    mines the number of significant elements actually
!                    in the work arrays.
!
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least 3*limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2),
!                    and K = limit+1-last otherwise.
!
!            work  - Double precision
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END-POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end-points,
!                    work(limit*2+1), ..., work(limit*2+last) contain
!                     the integral approximations over the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!                    work(limit*4+1), ... is the area reserved to store
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
external f
integer :: l1, l2, l3, l4, l5
!
dimension iwork(leniw),work(lenw)
!
!
!         Check validity of limit,leniw and lenw.
!
ier = 6
last = 0
result = 0.d0
abserr = 0.d0
if (limit.lt.1 .or. leniw.lt.limit*3 .or. lenw.lt.limit*46) &
   & return
!
!         Prepare call for dqxgse.
!
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
l4 = limit + l3
l5 = 21*limit + l4
!
call dqxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last, &
   & work(l4),work(l5),iwork(l1),iwork(l2))
!
return
end subroutine dqxgs

subroutine dqxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,alist,blist,rlist,elist,iord,last,valp,valn,lp,ln)
implicit none
!
!            The routine calculates an approximation result to A
!            definite integral I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            dabs(I-result).LE.max(epsabs,epsrel*dabs(I)).
!
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!
!            a      - Double precision
!                     lower limit of integration
!
!            b      - Double precision
!                     upper limit of integration
!
!            epsabs - Double precision
!                     absolute accuracy requested
!
!            epsrel - Double precision
!                     relative accuracy requested
!
!            limit  - Integer
!                     gives an upperbound on the number of subintervals
!                     in the partition of (a,b)
!
!         On return
!            result - Double precision
!                     approximation to the integral
!
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed dabs(I-result)
!
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                         = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account). However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel is negative. Result, abserr,
!                             last, rlist(1), iord(1), and elist(1)
!                             are set to zero. alist(1) and blist(1)
!                             are set to A and b respectively.
!
!            alist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left end points
!                     of the subintervals in the partition of the
!                     given integration range (a,b)
!
!            blist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right end points
!                     of the subintervals in the partition of the given
!                     integration range (a,b)
!
!            rlist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!
!            elist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli of the
!                     absolute error estimates on the subintervals
!
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!
!            valp   - Double precision
!            valn     ARRAYS OF DIMENSION AT LEAST (21,limit) USED TO
!                     save the functional values
!
!            lp     - INTEGER
!            ln       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!                     store the actual number of functional values
!                     saved in the corresponding column
!                     OF valp,valn
!
!***Routines called  f,dpmpar,dqelg,dqxlqm,dqpsrt,dqxrrd,dqxcpy
!
double precision :: a
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision :: b
double precision, intent(inout) :: blist
double precision, intent(inout) :: elist
double precision, intent(in) :: epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: rlist
double precision, intent(inout) :: valp, valn
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(inout) :: lp(limit), ln(limit)
external f
double precision :: abseps
double precision :: area, area1, area12, area2, a1, a2
double precision :: b1, b2, correc, defabs, defab1, defab2, dres
double precision :: epmach
double precision :: erlarg, erlast, errbnd, errmax, error1, &
   & error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps
double precision :: res3la(3)
double precision :: rlist2(52), small, t, uflow
double precision :: vp1(21), vp2(21), vn1(21), vn2(21), dpmpar
integer :: id
integer :: ierro
integer :: iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin
integer :: maxerr, nres, nrmax, numrl2
integer :: lp1, lp2, ln1, ln2
logical :: extrap, noext
!
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit), valp(21,limit), valn(21,limit)
!
!
!            Machine dependent constants
!            ---------------------------
!
!          epmach is the largest relative spacing.
!          uflow is the smallest positive magnitude.
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
   & valp(1,1),valn(1,1),lp(1),ln(1),2, &
   & epmach,uflow,oflow)
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
   & errbnd) ier = 2
if (limit .eq. 1) ier = 1
if (ier .ne. 0 .or. (abserr.le.errbnd.and.abserr.ne.resabs) .or. &
   & abserr .eq. 0.d0) go to 999
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
!           Bisect the subinterval with the nrmax-TH largest error
!           estimate.
!
   a1 = alist(maxerr)
   b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call dqxrrd(f,valn(1,maxerr),ln(maxerr),b1,a1,vn1,vp1,ln1,lp1)
   call dqxlqm(f,a1,b1,area1,error1,resabs,defab1,vp1,vn1,lp1,ln1, &
      & 2,epmach,uflow,oflow)
   call dqxrrd(f,valp(1,maxerr),lp(maxerr),a2,b2,vp2,vn2,lp2,ln2)
   call dqxlqm(f,a2,b2,area2,error2,resabs,defab2,vp2,vn2,lp2,ln2, &
      & 2,epmach,uflow,oflow)
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
      & .or. erro12 .lt. 0.99d0*errmax) go to 10
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
      & t*(dabs(a2) + 1.d+03*uflow)) ier = 4
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
!           CALL SUBROUTINE dqpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the subinterval
!           with nrmax-TH largest error estimate (to be bisected next).
!
30 call dqpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum .le. errbnd) go to 115
! ***Jump out of do-loop
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
!           more cautious extrapolation than in the original dqagse
!           routine
!
40 if (ierro .eq. 3 .or. erlarg .le. 0.3d0*ertest) go to 60
!
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors over the
!           larger intervals (erlarg) and perform extrapolation.
!
   id = nrmax
   jupbnd = last
   if (last .gt. (2 + limit/2)) jupbnd = limit + 3 - last
   do 50 k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (dabs(blist(maxerr) - alist(maxerr)) .gt. small) go to 90
      nrmax = nrmax + 1
50    continue
!
!           Perform extrapolation.
!
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call dqelg (numrl2,rlist2,reseps,abseps,res3la,nres, &
      & epmach,oflow)
   ktmin = ktmin + 1
   if (ktmin .gt. 5 .and. abserr .lt. 0.1d-02*errsum) ier = 5
   if (abseps .ge. abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = dmax1(epsabs,rerr*dabs(reseps))
! ***Jump out of do-loop
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
110 if (ksgn.eq.(-1).and.dmax1(dabs(result),dabs(area)).le. &
   & defabs*0.1d-01) go to 130
if (0.1d-01.gt.(result/area).or.(result/area).gt.0.1d+03 &
   & .or.errsum.gt.dabs(area)) ier = 6
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

pure subroutine dqxcpy (a, b, l)
implicit none
integer, intent(in) :: l
double precision, intent(inout) :: a(l)
double precision, intent(in) :: b(l)
integer :: i
!
!  TO COPY THE DOUBLE PRECISION VECTOR b OF LENGTH l   i N T O
!          the double precision vector a of length l
!
!
do 10 i = 1,l
10 a(i) = b(i)
return
end subroutine dqxcpy

subroutine dqxlqm (f,a,b,result,abserr,resabs,resasc,vr,vs,lr,ls, &
   & key,epmach,uflow,oflow)
implicit none
!
!            To compute I = Integral of f over (a,b), with error
!                           estimate
!                       J = Integral of dabs(f) over (a,b)
!
!           Parameters
!            on entry
!              f      - Double precision
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X t E R N A L in the driver program.
!
!              a      - Double precision
!                       lower limit of integration
!
!              b      - Double precision
!                       upper limit of integration
!
!              vr     - Double precision
!                       vector of length lr containing the
!                       saved  functional values of positive abscissas
!
!              vs     - Double precision
!                       vector of length ls containing the
!                       saved  functional values of negative abscissas
!
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTS IN
!                       vr,vs respectively
!
!            key    - INTEGER
!                     key for choice of local integration rule
!                     rms formulas are used with
!                      13 - 19               Points if key.LT.1,
!                      13 - 19 - (27)        points if key = 1,
!                      13 - 19 - (27) - (41) points if key = 2,
!                           19 -  27  - (41) points if key = 3,
!                                 27  -  41  Points if key.GT.3.
!
!                         (Rules) used if the function APPEARS
!                         enough regular
!
!              epmach - Double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!
!              uflow  - Double precision
!                       the smallest positive magnitude.
!
!              oflow  - Double precision
!                       the largest positive magnitude.
!
!            On return
!              result - Double precision
!                       approximation to the integral I
!
!              abserr - Double precision
!                       estimate of the modulus of the absolute error,
!                       which should not exceed dabs(I-result)
!
!              resabs - Double precision
!                       approximation to the integral J
!
!              resasc - Double precision
!                       approximation to the integral of dabs(f-I/(b-a))
!                       OVER (a,b)
!
!              vr     - Double precision
!                       vector of length lr containing the
!                       saved  functional values of positive abscissas
!
!              vs     - Double precision
!                       vector of length ls containing the
!                       saved  functional values of negative abscissas
!
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTS IN
!                       vr,vs respectively
!
!***Routines called  dqxrul
!
double precision :: f
double precision, intent(in) :: a, b
double precision, intent(inout) :: result, abserr, resabs, resasc
double precision, intent(in) :: epmach, oflow, uflow
double precision, intent(inout) :: vr(21), vs(21)
integer, intent(in) :: key
integer, intent(inout) :: lr, ls
external f
double precision :: t
double precision :: resg, resk, errold
integer :: k, k0, k1, k2
integer :: key1
!
key1 = max0(key ,  0)
key1 = min0(key1,  4)
k0 = max0(key1 - 2,0)
k1 = k0 + 1
k2 = min0(key1 + 1,3)
!
call dqxrul (f,a,b,resg,resabs,resasc,k0,k1,vr,vs,lr,ls)
errold = oflow
t = 10.d0*epmach
do 10 k = k1,k2
   call dqxrul (f,a,b,resk,resabs,resasc,k,k1,vr,vs,lr,ls)
   result = resk
   abserr = dabs(resk - resg)
   if (resasc .ne. 0.d0 .and. abserr .ne. 0.d0) &
      & abserr = resasc*dmin1(1.d0,(200.d0*abserr/resasc)**1.5d0)
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
double precision :: f
double precision, intent(in) :: xl, xu
double precision, intent(out) :: y
double precision, intent(inout) :: ya, ym
double precision, intent(inout) :: fv1(21), fv2(21)
integer, intent(in) :: ke, k1
integer, intent(inout) :: l1, l2
external f
integer :: i, is, k, ks
double precision :: ldl
double precision :: y2, xx(41), ww(52)
double precision :: aa, bb, c
integer :: istart(4), len(4), j
!
!            To compute i = Integral of f over (A,B), with error
!                           estimate
!            and conditionally compute
!                       j = Integral of dabs(f) over (A,B)
!                       by using an  rms rule
!           parameters
!            on entry
!              f      - Double precision
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X T E R N A L in the driver program.
!
!              xl     - Double precision
!                       lower limit of integration
!
!              xu     - Double precision
!                       upper limit of integration
!
!              ke     - INTEGER
!                     key for choice of local integration rule
!                     an rms rule is used with
!                         13      points if ke  = 2,
!                         19      points if ke  = 3,
!                         27      points if ke  = 4,
!                         42      points if ke  = 5
!
!              k1     INTEGER
!                     value of key for which the additional estimates
!                     ya, ym are to be computed
!
!              fv1    - Double precision
!                       vector containing l1
!                       saved  functional values of positive abscissas
!
!              fv2    - Double precision
!                       vector containing l2
!                       saved  functional values of negative abscissas
!
!              l1     - INTEGER
!              l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!
!            On return
!              y      - Double precision
!                       approximation to the integral i
!                       result is computed by applying the
!                       requested rms rule
!
!              ya     - Double precision
!                       if key = k1  approximation to the integral j
!                       ELSE UNCHANGED
!
!              ym     - Double precision
!                       if key = k1  approximation to the integral of
!                                      dabs(f-i/(xu-xl)   OVER (xl,xu)
!                       ELSE UNCHANGED
!
!              fv1    - Double precision
!                       vector containing l1
!                       saved  functional values of positive abscissas
!
!              fv2    - Double precision
!                       vector containing l2
!                       saved  functional values of negative abscissas
!
!              l1     - INTEGER
!              l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!
!------------------------
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
!              f      - Double precision
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X T E r N A L in the driver program.
!
!              xl     - Double precision
!                       lower limit of interval
!
!              xu     - Double precision
!                       upper limit of interval
!
!              z      - Double precision
!                       vector containing lz
!                       saved  functional values
!
!              lz     - INTEGER
!                       number of elements in lz
!
!            On return
!              r      - Double precision
!              s        VECTORS CONTAINING lr, ls
!                       saved  functional values for the new intervals
!
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTES IN r,s RESPECTIVELY
!
!***Routines called  f
!
double precision :: f
double precision, intent(inout) :: r(21), s(21)
double precision :: z(21)
double precision, intent(in) :: xu, xl
integer, intent(inout) :: lr, ls
integer, intent(in) :: lz
double precision :: dlen, centr
!
dlen = (xu - xl)*0.5d0
centr = xl + dlen
r(1) = z(3)
r(2) = z(9)
r(3) = z(4)
r(4) = z(5)
r(5) = z(6)
r(6) = z(10)
r(7) = z(7)
s(1) = z(3)
s(2) = z(8)
s(3) = z(2)
s(7) = z(1)
if (lz .gt. 11) go to 10
!
r(8) = f(centr + dlen*0.375d0)
r(9) = f(centr + dlen*0.625d0)
r(10) = f(centr + dlen*0.96875d0)
lr = 10
if (lz .ne. 11) s(4) = f(centr - dlen*0.75d0)
if (lz .eq. 11) s(4) = z(11)
s(5) = f(centr - dlen*0.875d0)
s(6) = f(centr - dlen*0.9375d0)
s(8) = f(centr - dlen*0.375d0)
s(9) = f(centr - dlen*0.625d0)
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
s(8) = f(centr - dlen*0.375d0)
s(9) = f(centr - dlen*0.625d0)
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
   & idata, rdata, ier)
implicit none
real :: f
external f
integer :: idata(*), ier, mcalls, ncalls, nw
real :: ans, eps, err, rdata(*), t(2,*), w(6,nw)
integer :: i, j, jkp, k, l, maxc, maxk, mw, nfe
real :: one, point5, zero
real :: rnderr
real :: alfa, anskp, area, errmax, h, q1, q2, r1, r2, d(2,4), &
   & s(4), vec(2,3), x(2)
double precision :: tans, terr, dzero
!
!       Adaptive cubature over a triangle
!
!       Parameters
!          f     - User supplied external function of the form
!                  f(X,Y,idata,rdata)
!                  where X and Y are the cartesian coordinates of A
!                  point in the plane, and idata and rdata are integer
!                  and real vectors in which data may be passed.
!          t     - Array of dimension (2,3) where t(1,j) and t(2,j)
!                  are the X and Y coordinates of the j-TH vertex of
!                  the given triangle (input)
!          eps   - Required tolerance (input).  If the computed
!                  integral is between-1 and 1, an absolute error
!                  test is used, else a relative error test is used.
!          mcalls- maximum permitted number of calls to f (input)
!          ans   - Estimate for the value of the integral of f over
!                  the given triangle (OUTPUT)
!          err   - Estimated absolute error in ans (OUTPUT)
!          ncalls- actual number of calls to f (OUTPUT).  This
!                  parameter must be initialized to 0 on the first
!                  CALL TO cubtri FOR A GIVEN INTEGRAL (INPUT)
!          w     - Work space.  May not be destroyed between calls to
!                  cubtri if restarting is intended
!          nw    - Length of work space (input).
!                  If nw .GE. 3*(19+3*mcalls)/38, termination due to
!                  full work space will not occur.
!          ier   - TERMINATION INDICATOR (OUTPUT)
!                  ier=0   Normal termination, tolerance satisfied
!                  ier=1   Maximum number of calls reached
!                  ier=2   Work space full
!                  ier=3   Further subdivision of triangles impossible
!                  ier=4   No further improvement in accuracy is
!                        possible due to rounding errors in function
!                        values
!                  ier=5   No further improvement in accuracy is
!                        possible because subdivision does not
!                        change the estimated integral. Machine
!                        accuracy has probably been reached but
!                        the error estimate is not sharp enough.
!
!       cubtri is designed to be called repeatedly without wasting
!       earlier work.  The parameter ncalls is used to indicate to
!       cubtri at what point to restart, and must be RE-initialized
!       to 0 when a new integral is to be computed.  At least one of
!       the parameters eps, mcalls and nw must be changed between
!       calls to cubtri, according to the returned value of ier. None
!       of the other parameters may be changed if restarting is done.
!       If ier=3 Is encountered, there probably is a singularity
!       somewhere in the region.  The error message indicates that
!       further subdivision is impossible because the vertices of the
!       smaller triangles produced will begin to coalesce to the
!       precision of the computer.  This situation can usually be
!       relieved by specifying the region in such a way that the
!       singularity is located at the third vertex of the triangle.
!       If ier=4 Is encountered, the value of the integral cannot be
!       improved any further. The only exception to this occurs when A
!       function with highly irregular behaviour is integrated (E.G.
!       Functions with jump discontinuities or very highly oscillatory
!       functions). In such a case the user can disable the rounding
!       error test by removing the if statement immediately preceding
!       statement number 90.
!
!       Actual dimension of w is (6,nw/6)
!
common /cubsta/ tans, terr
!       This common is required to preserve tans and terr between calls
!       and to save variables in function rnderr
data nfe /19/, s(1), s(2), s(3), s(4) /3*1e0,-1e0/, d(1,1), &
   & d(2,1) /0.0,0.0/, d(1,2), d(2,2) /0.0,1.0/, d(1,3), d(2,3) &
   & /1.0,0.0/, d(1,4), d(2,4) /1.0,1.0/
!       nfe is the number of function evaluations per call to cubrul.
data zero /0.e0/, one /1.e0/, dzero /0.d0/, point5 /.5e0/
!
!      Calculate direction vectors, area and maximum number
!      of subdivisions that may be performed
do i = 1,2
   vec(i,3) = t(i,3)
   do j = 1,2
      vec(i,j) = t(i,j) - t(i,3)
   end do
end do
maxc = (mcalls/nfe + 3)/4
ier = 1
maxk = min0(maxc,(nw/6 + 2)/3)
if (maxc.gt.maxk) ier = 2
area = abs(vec(1,1)*vec(2,2) - vec(1,2)*vec(2,1))*point5
k = (ncalls/nfe + 3)/4
mw = 3*(k - 1) + 1
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
do i = 1,2
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
do i = 1,4
   do l = 1,2
      w(l,j) = x(l) + h*d(l,i)
   end do
   w(3,j) = h*s(i)
   call cubrul(f, vec, w(1,j), idata, rdata)
   q2 = q2 + w(5,j)
   q1 = q1 + w(4,j)
   j = mw + i
end do
alfa = 1e15
if (q2.ne.r2) alfa = abs((q1 - r1)/(q2 - r2) - one)
j = jkp
do i = 1,4
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
if (k.gt.3 .and. abs(q2 - r2).gt.abs(q1 - r1)) go to 140
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
!       sum x+a is formed.  In the calling program, y must be the same
!       as x and b must be the same as A.  they are declared as
!       distinct variables in this function, and the intermediate
!       variables s and t are put into common, in order to defend
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
real :: f
real, intent(inout) :: p(*)
real :: rdata(*)
real, intent(in) :: vec(2,*)
integer :: idata(*)
external f
integer :: i, j, k, nquad
real :: point5, x, y
double precision :: a1, a2, s, sn, dzero, done, dthree, dsix
real :: area, origin(2)
real :: tvec(2,3)
real :: w(5,6)
!
!       BASIC cubature rule pair over a triangle
!
!       Parameters
!         f  - External function - See comments to cubtri
!         vec- matrix of base vectors and origin (input)
!         p  - Triangle description vector of dimension 6
!               p(1) - Transformed x coordinate of origin vertex(input)
!               p(2) - Transformed y coordinate of origin vertex(input)
!               p(3) - Distance of other vertices in the directions
!                     of the base vectors (input)
!               p(4) - Less accurate estimated integral (OUTPUT)
!               p(5) - More accurate estimated integral (OUTPUT)
!               p(6) - abs(p(5)-p(4))   (OUTPUT)
!
!       cubrul evaluates a linear combination of BASIC integration
!       rules having D3 symmetry.  The areal coordinates pertaining to
!       the j-TH rule are stored in w(i,j),i=1,2,3.  The corresponding
!       weights are w(4,j) and w(5,j), with w(5,j) belonging to the
!       more accurate formula.  If w(1,j).EQ.w(2,j), the integration
!       point is the centroid, else if w(2,j).EQ.w(3,j), the evaluation
!       points are on the medians.  In both cases advantage is taken of
!       symmetry to avoid repeating function evaluations.
!
!       The following double precision variables are used to avoid
!       unnecessary rounding errors in floating point addition.
!       They may be declared single precision if double precision is
!       not available and full accuracy is not needed.
!
!
!       w contains points and weights of the integration formulae
!       nquad - Number of BASIC rules used
!
!       This particular rule is the 19 point extension (degree 8) of
!       the familiar 7 point rule (degree 5).
!
!     sigma=sqrt(7)
!     phi=sqrt(15)
!     w(1,1),w(2,1),w(3,1) = 1/3
!     w(4,1) = 9/40
!     w(5,1) = 7137/62720 - 45*sigma/1568
!     w(1,2) = 3/7 + 2*phi/21
!     w(2,2),w(3,2) = 2/7 - PHI/21
!     w(4,2) = 31/80 - phi/400
!     w(5,2) = - 9301697/4695040 - 13517313*phi/23475200
!            + 764885*sigma/939008 + 198763*phi*sigma/939008
!     w(*,3) = w(*,2) with phi replaced by -Phi
!     w(1,5) = 4/9 + phi/9 + sigma/9 - sigma*phi/45
!     w(2,5),w(3,5) = 5/18 - PHI/18 - SIGMA/18 + SIGMA*PHI/90
!     w(4,5) = 0
!     w(5,5) = 102791225/59157504 + 23876225*phi/59157504
!            - 34500875*sigma/59157504 - 9914825*phi*sigma/59157504
!     w(*,4) = w(*,5) with phi replaced by -Phi
!     w(1,6) = 4/9 + sigma/9
!     w(2,6) = w(2,4)
!     w(3,6) = w(2,5)
!     w(4,6) = 0
!     w(5,6) = 11075/8064 - 125*sigma/288
!
data nquad /6/
data w(1,1), w(2,1), w(3,1) /3*.3333333333333333333333333e0/, &
   & w(4,1), w(5,1) /.225e0,.3786109120031468330830822e-1/, &
   & w(1,2), w(2,2), w(3,2) /.7974269853530873223980253e0,2* &
   & .1012865073234563388009874e0/, w(4,2), w(5,2) &
   & /.3778175416344814577870518e0,.1128612762395489164329420e0/, &
   & w(1,3), w(2,3), w(3,3) /.5971587178976982045911758e-1,2* &
   & .4701420641051150897704412e0/, w(4,3), w(5,3) &
   & /.3971824583655185422129482e0,.2350720567323520126663380e0/
data w(1,4), w(2,4), w(3,4) /.5357953464498992646629509e0,2* &
   & .2321023267750503676685246e0/, w(4,4), w(5,4) &
   & /0.e0,.3488144389708976891842461e0/, w(1,5), w(2,5), w(3,5) &
   & /.9410382782311208665596304e0,2*.2948086088443956672018481e-1/, &
   & w(4,5), w(5,5) /0.e0,.4033280212549620569433320e-1/, w(1,6), &
   & w(2,6), w(3,6) /.7384168123405100656112906e0, &
   & .2321023267750503676685246e0,.2948086088443956672018481e-1/, &
   & w(4,6), w(5,6) /0.e0,.2250583347313904927138324e0/
!
data dzero /0.d0/, done /1.d0/, dthree /3.d0/, dsix /6.d0/, &
   & point5 /.5e0/
!
!       Scale base vectors and obtain area
!
do i = 1,2
   origin(i) = vec(i,3) + p(1)*vec(i,1) + p(2)*vec(i,2)
   do j = 1,2
      tvec(i,j) = p(3)*vec(i,j)
   end do
end do
area = point5*abs(tvec(1,1)*tvec(2,2) - tvec(1,2)*tvec(2,1))
a1 = dzero
a2 = dzero
!
!       Compute estimates for integral and error
!
do k = 1,nquad
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
p(6) = abs(p(5) - p(4))
return
end subroutine cubrul

subroutine ieslv (kernel,rhfcn,a,b,ep,iflag,t,x,nt,nupper, &
   & mupper,nf,mf,norm,w,ier)
implicit none
integer :: ier, iflag, mf, mupper, nf, nt, nupper
real :: a, b, ep, t(*), w(*), x(*)
real :: rhfcn
real :: kernel, norm
external kernel, rhfcn
integer :: i1, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, &
   & i2, i20, i21, i3, i4, i5, i6, i7, i8, i9, m, n, nhalf, nmax, nsq, &
   & nup
real :: cutoff, rootrt, unitrd
integer :: mfinal, nfinal
real :: finlep, r1, r2
real :: spmpar
real :: normk
!
!   The integral equation being solved is
!
!                     b
!          x(S) -  INT  kernel(S,t)*x(t)*DT = rhfcn(S)
!                     A
!
!   The method being used is based on the Nystrom method with
!   Gaussian quadrature, with an iterative technique of solution
!   for the resulting linear system.
!
!   KERNEL     THESE ARE REAL FUNCTIONS OF TWO AND ONE
!   rhfcn      VARIABLES, RESPECTIVELY. THEY MUST BE DECLARED IN AN
!              external statement in the program calling ieslv.
!   ep         THE DESIRED ERROR. THE VARIABLE ep IS CHANGED ON
!              completion of the program. See the discussion of ier
!              and iflag for more information.
!   iflag =0   ep is interpreted as an absolute error tolerance.
!         =1   ep is interpreted as a relative error tolerance.
!   t          CONTAINS THE NODE POINTS AT WHICH THE SOLUTION OF THE
!              integral equation is desired. See the variable nt for
!              more information.
!   x          THE COMPUTED APPROXIMATE SOLUTION OF THE INTEGRAL
!              equation, evaluated at the node points in t, is
!              stored in x on completion of the routine. This is
!              true irregardless of whether or not the desired error
!              tolerance was attained.
!   nt         if nt=0, then t and x will be set equal to the final
!              Gaussian nodes and the corresponding solution values,
!              and nt will be set to the number of the solution
!              values stored in x and t. the arrays t and x should
!              have dimension at least mupper, assigned in the
!              calling program.
!              If nt .GT. 0, then t contains nt user supplied nodes
!              at which the solution x is desired.
!   nupper     AN UPPER LIMIT ON THE VARIABLE N IN THIS PROGRAM.
!              N is the order of a linear system which is being
!              used to iteratively solve a larger linear system of
!              order M which approximates the integral equation.
!              (For further details concerning the maximum value
!              that N can take, see the description of NMAX below.)
!   mupper     AN UPPER LIMIT ON THE VARIABLE M IN THE PROGRAM.
!              N and M are always powers of two.
!   nf         SAME AS nfinal (SEE BELOW)
!   mf         SAME AS mfinal (SEE BELOW)
!   NORM       SAME AS normk (SEE BELOW)
!   w          TEMPORARY WORKING STORAGE FOR THE PROGRAM. IT MUST
!              contain at least 5*nu*nu+9*(NU+MU) positions, with
!              nu=nupper, mu=mupper.
!   ier =0     This error completion code means the routine was
!              completed satisfactorily. ep contains the predicted
!              error.
!       =1     The error test was not satisfied. ep contains the
!              predicted error.
!       =2     The error test was not satisfied. ep has been set
!              to zero.
!       =3     The original value of ep was too small, due to
!              possible ill-conditioning problems in the integral
!              equation. The value of ep was reset to a more
!              realistic value, and that tolerance was attained.
!       =4     The error was satisfactory at the Gaussian node
!              points (ier=0), but the interpolation process(due to
!              nt .GT. 0) may not preserve this accuracy. Check the
!              value of norm(K) for possible indications that the
!              integral equation may be almost first kind. Such
!              equations are quite ill-conditioned. The error in ep
!              is the predicted error for the solution at the
!              Gaussian node points of order mfinal.
!       =5     The analogue of ier=4, but with ier=1 At the
!              Gaussian node points.
!       =6     The analogue of ier=4, but with ier=3 At the
!              Gaussian node points.
!
!
!   *** REFERENCES ***
!   (1) an automatic program for Fredholm integral equations of the
!       second kind, ACM Trans. Math Software 2(1976), PP.154-171.
!   (2) a survey of numerical methods for the solution of Fredholm
!       integral equations of the second kind, SIAM pub., 1976,
!       part II, chap. 5.
!
!
!*******************************************************************
!                                                                  *
common/xxinfo/r1,r2,finlep,normk,nfinal,mfinal
!                                                                  *
!   THE NUMBERS IN XXINFO GIVE ADDITIONAL INFORMATION ABOUT THE    *
!   functioning of ieslv. r1 is the iterative rate of convergence  *
!   in the most recently computed linear system. r2 is the rate of *
!   convergence of the Gaussian quadrature variant of the Nystrom  *
!   METHOD. finlep IS THE FINAL VALUE OF ep USED AS THE DESIRED    *
!   error tolerance. Usually finlep will equal the input value of  *
!   ep, UNLESS ep WAS MUCH TOO SMALL. normk IS AN APPROXIMATE      *
!   VALUE FOR THE NORM OF THE INTEGRAL OPERATOR K, AND IT IS       *
!   calculated only if nt .GT. 0.                                  *
!   nfinal AND mfinal ARE THE FINAL VALUES OF N AND M USED IN      *
!   ieslv.  If nfinal=mfinal, then iteration was not invoked       *
!   SUCCESSFULLY.                                                  *
!                                                                  *
!*******************************************************************
!                                                                  *
!   NMAX IS THE MAXIMUM VALUE FOR N THAT IS PERMITTED BY ieslv.    *
!   thus MIN0(nupper,NMAX) is the maximum value for N that can be  *
!   used. There is also an upper limit of 128 on N imposed by the  *
!   SUBROUTINE lnsys.                                              *
!                                                                  *
data nmax /64/
!                                                                  *
!*******************************************************************
!                                                                  *
!     unitrd IS A MACHINE DEPENDENT PARAMETER. ASSIGN unitrd THE   *
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
!   which w is to be split.
n = nup
m = mupper
nsq = n*n
i1 = 1
i2 = i1 + nsq
i3 = i2 + nsq
i4 = i3 + nsq/2
i5 = i4 + nsq/2
i6 = i5 + m
i7 = i6 + m
i8 = i7 + n
i9 = i8 + n
i10 = i9 + m
i11 = i10 + n
i12 = i11 + m
i13 = i12 + m
i14 = i13 + m
i15 = i14 + n
i16 = i15 + m
i17 = i16 + m
i18 = i17 + n
i19 = i18 + m
i20 = i19 + 4*n
i21 = i20 + nsq
nhalf = n/2
call iegs(kernel,rhfcn,a,b,ep,iflag,x,t,nt,nup,mupper,ier, &
   & cutoff,rootrt,unitrd,nhalf,w(i1),w(i2),w(i3),w(i4),w(i5), &
   & w(i6),w(i7),w(i8),w(i9),w(i10),w(i11),w(i12),w(i13), &
   & w(i14),w(i15),w(i16),w(i17),w(i18),w(i19),w(i20),w(i21))
norm = normk
nf = nfinal
mf = mfinal
return
end subroutine ieslv

subroutine iegs(kernel,rhfcn,a,b,ep,iflag,x,t,nt,nup,mup,ier, &
   & cutoff,rootrt,unitrd,nhalf,lufact,kmm,kmn,knm,rhs,r,rh, &
   & deln,tm,tn,xm,xmz,wm,wn,oldx,save,xn,save2,aside,aside3, &
   & imknn)
implicit none
integer :: ier, iflag, mup, nhalf, nt, nup
real :: a, aside(nup,*), aside3(nup,nup), b, cutoff, deln(nup), &
   & ep, oldx(mup), r(mup), rh(nup), rhs(mup), rootrt, save(mup), &
   & save2(mup), t(*), tm(mup), tn(nup), unitrd, wm(mup), wn(nup), &
   & x(*), xm(mup), xmz(mup), xn(nup)
real :: rhfcn
real :: kernel, lufact(nup,nup), kmm(nup,nup), kmn(nup,nhalf), &
   & knm(nhalf,nup), imknn(nup,nup)
external kernel, rhfcn
integer :: i, ind, j, loop, m, mnew, n
real :: aside2(5), averr, cond, denr1, denr2, eps, error, esterr, &
   & pastc, pastre, r1rat, rate, relerr, relmin, rt, temp, temp2, test, &
   & xnorm
integer :: mfinal, nfinal
real :: finlep, r1, r2
real :: elinsy, relrsd
real :: rnrm
real :: conew
real :: normk, numr1, numr2
integer :: flag, oldm, pivot(128)
interface
   pure elemental function rmin(n,m,cond,unitrd,averr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: m
      real, intent(in) :: cond
      real, intent(in) :: unitrd
      real, intent(in) :: averr
      real :: rmin
   end function rmin
end interface
!
!   This routine controls the solution of the integral equation.
!
common/xxlin/elinsy,relrsd,pivot
common/xxinfo/r1,r2,finlep,normk,nfinal,mfinal
!
!   Initialization
!
loop = 1
n = 2
r2 = 0.5
m = 2*n
r1rat = rootrt
cond = 1.0
pastc = 1.0
pastre = 0.0
eps = ep
!
!   Stage A. direct solution of linear system (i-KN)*XN=RHS, while
!   trying to find a good approximate inverse to implement
!   iterative method of solution.
!
!   Create the nodes and weights TN(i) and WN(i), i=1,...,n
call wandt(wn,tn,n,a,b)
!   Set up matrix for (i-KN)*XN=rhfcn
do 2 j = 1,n
   do 1 i = 1,n
1     imknn(i,j) = -wn(j)*kernel(tn(i),tn(j))
   xmz(j) = rhfcn(tn(j))
2  imknn(j,j) = imknn(j,j) + 1.0
go to 6
!   This is entrance for an increased value of n, using previously
!   stored values in kmm to define matrix for (i-KN)*XN=rhfcn with
!   new value of n.
3 do 5 j = 1,n
   do 4 i = 1,n
4     imknn(i,j) = -kmm(i,j)
   wn(j) = wm(j)
   tn(j) = tm(j)
   xmz(j) = rhs(j)
5  imknn(j,j) = imknn(j,j) + 1.0
!   This is the entrance when iteration in stage b fails and we need
!   to increase n to obtain a better iterative rate.
6 continue
!   Solve (i-KN)*XN=rhfcn at all TN(i).Also obtain the LU
!   decomposition for later use in the stage b iterative method.
!
!*******************************************************************
!                                                                  *
call lnsys(imknn,lufact,nup,n,xmz,xn,2,ind)
!                                                                  *
!   lnsys IS A GENERAL LINEAR EQUATION SOLVER. IT HAS SPECIAL      *
!   OPTIONS WHICH ARE USED IN THE FOLLOWING PROGRAM. THUS IT       *
!   SHOULD NOT BE REPLACED WITH ANOTHER SOLVER. lnsys IS ALSO      *
!   USED IN THE SUBROUTINE itert.                                  *
!                                                                  *
!*******************************************************************
!
cond = conew(cond,elinsy,relrsd,averr,pastc,pastre)
relmin = rmin(n,n,cond,unitrd,averr)
if (loop .eq. 1) go to 11
if (loop .eq. 2) go to 9
!   Set up approximate rate of convergence of solutions XN to true
!   solution X. also set up desired ratio for iterative method.
numr2 = rnrm(xn,oldx,n,1)
r2 = amin1(0.5,amax1(numr2/denr2,1.0e-4))
r1rat = amin1(rootrt,sqrt(r2))
!   Check for error in XN using test involving r2 and OLDX,according
!   to theory for asymptotic error bounds. Modify error if it is
!   outside precision range of computer, possibly due to
!   ill-conditioning.
8 error = (r2/(1.0 - r2))*numr2
xnorm = rnrm(xn,xn,n,0)
relerr = error/xnorm
if (iflag .eq. 0) eps = amax1(ep,xnorm*relmin)
if (iflag .eq. 1) eps = amax1(ep,relmin)
if (iflag .eq. 1) error = amax1(relerr,relmin)
if ((iflag .eq. 0) .and. (relerr .lt. relmin)) &
   & error = relmin*xnorm
if (error .le. eps) go to 10
denr2 = numr2
go to 11
!   Entrance for loop=2.
9 numr2 = rnrm(xn,oldx,n,1)
denr2 = 0.0
go to 8
!   Exit for successful return. Iteration was not necessary.
10 call leave(0,n,n,xn,tn,wn,error, &
   & kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
   & xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
!
!   Attempt to solve (i-km)*XM=rhfcn iteratively, checking to see if
!   the rate of convergence is sufficiently fast so as to enter
!   STAGE b.
!
!   Calculate TM(i) and WM(i), i=1,...,m.
11 call wandt(wm,tm,m,a,b)
flag = 0
!   Calculate initial guess XMZ for iteration method.
call nsterp(tm,wm,xmz,m,tn,wn,xn,n, &
   & kernel,rhfcn,rhs,kmn,nhalf,nup)
do 12 i = 1,m
12 oldx(i) = xmz(i)
!   Calculate first iterate.
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
   & rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond = conew(cond,elinsy,relrsd,averr,pastc,pastre)
denr1 = rnrm(xm,xmz,m,1)
flag = 1
do 13 i = 1,m
13 xmz(i) = xm(i)
!   Calculate second iterate.
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
   & rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond = conew(cond,elinsy,relrsd,averr,pastc,pastre)
numr1 = rnrm(xm,xmz,m,1)
!   Check on the speed of convergence of iterative method. If it is
!   sufficiently rapid, then fix n and go to stage b.
r1 = amax1(numr1/denr1,.0001)
rate = r1
if (m .gt. nup) go to 19
if (r1 .le. r1rat) go to 15
!   The iteration did not work well enough, and stage A is to be
!   repeated. RE-initialize for solving (i-KN)*XN=rhfcn again
!   with a larger n.
14 n = m
loop = loop + 1
m = 2*n
go to 3
!   The iterative rate is sufficiently rapid, and control will go to
!   stage b. save information in case stage b aborts at a larger
!   value of m and stage A has to be returned to.
15 do 16 i = 1,m
   aside(i,1) = oldx(i)
   aside(i,2) = wm(i)
   aside(i,3) = tm(i)
16 aside(i,4) = rhs(i)
aside2(1) = loop
aside2(3) = r2
aside2(4) = denr2
aside2(5) = r1rat
do 17 j = 1,m
   do 17 i = 1,m
17    aside3(i,j) = kmm(i,j)
!
!   Stage b. iterative method of solution of (i-km)*XM=RHS.
!
19 oldm = n
aside2(2) = m
if (r1 .le. cutoff) go to 22
!   The iterates are converging very slowly or not at all. Thus
!   RETURN WITHOUT FURTHER ATTEMPTS TO LESSEN THE ERROR.
if (loop .ne. 1) go to 21
20 call leave(2,n,n,xn,tn,wn,0.0, &
   & kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
   & xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
21 call leave(1,n,n,xn,tn,wn,error, &
   & kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
   & xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
!   Test to see if the current iterate XM is sufficiently accurate
!   compared to the true XM.
22 rate = r1*rate
temp = rnrm(xm,oldx,m,1)
if (loop .eq. 1) temp2 = 0.5
if (loop .gt. 1) temp2 = temp/denr2
rt = amin1(0.01,amax1(temp2,0.0001))/2.0
xnorm = rnrm(xm,xm,m,0)
esterr = (rt/(1.0 - rt))*temp/xnorm
if (esterr .lt. relmin) esterr = relmin
esterr = esterr*xnorm
test = ((1.0 - r1)/r1)*esterr
if (numr1 .le. test) go to 33
!   Iterate not sufficiently accurate. Initialize for computation
!   of another iterate.
25 denr1 = numr1
do 26 i = 1,m
26 xmz(i) = xm(i)
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
   & rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond = conew(cond,elinsy,relrsd,averr,pastc,pastre)
numr1 = rnrm(xm,xmz,m,1)
r1 = amax1(numr1/denr1,.0001)
if (r1 .le. cutoff) go to 22
!   This is entrance for case where iteration fails in stage b.
!   Parameters must be reset for a return to stage A or for an
!   abortive exit if n cannot be increased any further.
27 mnew = aside2(2)
if (mnew .gt. nup) go to 30
n = mnew
do 29 j = 1,n
   do 28 i = 1,n
28    imknn(i,j) = -aside3(i,j)
   oldx(j) = aside(j,1)
   wn(j) = aside(j,2)
   tn(j) = aside(j,3)
   xmz(j) = aside(j,4)
29 imknn(j,j) = imknn(j,j) + 1.0
m = 2*n
loop = aside2(1) + 1.0
r2 = aside2(3)
denr2 = aside2(4)
r1rat = aside2(5)
go to 6
!   Abortive exit from stage b. n cannot be increased further, and
!   r1 is not sufficiently small.
30 if (loop .eq. 1) go to 20
call wandt(wm,tm,oldm,a,b)
call leave(1,n,oldm,save,tm,wm,error, &
   & kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
   & xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
!   An accurate value of XM has been obtained. r2 is to be tested as
!   to whether it should be reset. Then check error in XM compared
!   with the true solution X.
33 if (loop .eq. 1) go to 37
numr2 = temp
r2 = amax1(1.0e-4,rate,amin1(numr2/denr2,0.5))
denr2 = numr2
34 error = (r2/(1.0 - r2))*temp
xnorm = rnrm(xm,xm,m,0)
relerr = error/xnorm
relmin = rmin(n,m,cond,unitrd,averr)
if (iflag .eq. 0) eps = amax1(ep,xnorm*relmin)
if (iflag .eq. 1) eps = amax1(ep,relmin)
if (iflag .eq. 1) error = amax1(relerr,relmin)
if ((iflag .eq. 0) .and. (relerr .lt. relmin)) &
   & error = relmin*xnorm
if (error .gt. eps) go to 35
call leave(0,n,m,xm,tm,wm,error, &
   & kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
   & xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
35 mnew = 2*m
if (mnew .le. mup) go to 39
!   m cannot be increased any further.
call leave(1,n,m,xm,tm,wm,error, &
   & kernel,rhfcn,ep,iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm, &
   & xmz,kmm,kmn,knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
return
37 denr2 = temp
loop = 2
go to 34
!   Error not sufficiently small. m is increased and two more
!   more iterates are computed with the new m.
39 oldm = m
m = mnew
do 41 i = 1,oldm
   save2(i) = wm(i)
41 save(i) = tm(i)
call wandt(wm,tm,m,a,b)
flag = 0
call nsterp(tm,wm,xmz,m,save,save2,xm,oldm, &
   & kernel,rhfcn,rhs,kmn,nhalf,nup)
do 43 i = 1,oldm
43 save(i) = xm(i)
do 45 i = 1,m
45 oldx(i) = xmz(i)
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
   & rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond = conew(cond,elinsy,relrsd,averr,pastc,pastre)
denr1 = rnrm(xm,xmz,m,1)
flag = 1
do 47 i = 1,m
47 xmz(i) = xm(i)
call itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn,knm, &
   & rhs,imknn,lufact,r,rh,deln,nup,nhalf,flag)
cond = conew(cond,elinsy,relrsd,averr,pastc,pastre)
numr1 = rnrm(xm,xmz,m,1)
r1 = amax1(numr1/denr1,.0001)
rate = r1
if (r1 .le. cutoff) go to 22
go to 27
end subroutine iegs

subroutine nsterp(tm,wm,xm,m,tn,wn,xn,n,kernel,rhfcn,rhs,kmn, &
   & nhalf,nup)
implicit none
integer, intent(in) :: m, n, nhalf, nup
real, intent(inout) :: rhs(m)
real :: tm(m), tn(n), wm(m), wn(n)
real, intent(inout) :: xm(m)
real :: xn(n)
real :: rhfcn
real :: kernel
real, intent(inout) :: kmn(nup,nhalf)
external kernel, rhfcn
integer :: i, j
!
!   Use the values of xn(i), i=1,...,n, to calculate the Nystrom
!   INTERPOLATES xm(i), i=1,...,m.
!
!
if (m .gt. nup) go to 4
!   SINCE m .LE. NUPPER, SAVE K(tm(i),tn(j))=kmn(i,j) AND
!   rhs(i)=rhfcn(tm(i)) for later use in itert.
do 1 i = 1,m
   do 1 j = 1,n
1     kmn(i,j) = wn(j)*kernel(tm(i),tn(j))
do 2 i = 1,m
   rhs(i) = rhfcn(tm(i))
2  xm(i) = rhs(i)
!   Calculate Nystrom interpolating formula.
do 3 i = 1,m
   do 3 j = 1,n
3     xm(i) = xm(i) + kmn(i,j)*xn(j)
return
!   m .GT. NUPPER, so save just rhs(i) for later use in itert.
!   Calculate Nystrom interpolating formula.
4 do 5 i = 1,m
   rhs(i) = rhfcn(tm(i))
   xm(i) = rhs(i)
   do 5 j = 1,n
5     xm(i) = xm(i) + wn(j)*kernel(tm(i),tn(j))*xn(j)
return
end subroutine nsterp

pure elemental function rmin(n,m,cond,unitrd,averr)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: averr, cond, unitrd
real :: float1, float2
real :: rmin
!
!   For a linear system   (I-KMM)*XM=RHFCN   of order m, this is the
!   value of RELMIN used in iegs. The variable unitrd is defined in
!   IEGAUS, and the variables cond and averr are defined in iegs
!   USING conew.
!   It is unlikely that a solution X can be found for the original
!   integral equation with a smaller relative error than rmin.
!
float1 = m
float2 = float(m)/float(n)
rmin = amax1((float1**1.5)*cond*unitrd, &
   & (float2**1.5)*averr)
return
end function rmin

real function rnrm(x,y,n,iflag)
implicit none
integer, intent(in) :: iflag, n
real :: x(n), y(n)
integer :: i
!
!   iflag=0    Calculate the maximum norm of x.
!   iflag=1    Calculate the maximum norm of x-y.
!
if (iflag .eq. 1) go to 2
!   Find the norm of x.
rnrm = 0.0
do 1 i = 1,n
1  rnrm = amax1(rnrm,abs(x(i)))
return
!   Find the norm of x-y.
2 rnrm = 0.0
do 3 i = 1,n
3  rnrm = amax1(rnrm,abs(x(i) - y(i)))
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
!   IN iegs.
!
averr = sqrt(elinsy*pastre)
pastre = elinsy
if (relrsd .eq. 0.0) go to 1
c = amax1(1.0,elinsy/relrsd)
conew = sqrt(c*pastc)
pastc = c
return
1 conew = cond
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
!   wv and tv, respectively. n is assumed to be a power of two. If
!   2 .LE. n .LE. 256, then Gaussian quadrature is used. If n .GT.
!   256, Then the interval (a,b) is divided n/256 times and the 256
!   point formula is applied to each subinterval.
!
data t(1),t(2),t(3),t(4),t(5),t(6),t(7),t(8),t(9),t(10),t(11), &
   & t(12),t(13),t(14),t(15)/.577350269189626e0, &
   & .861136311594053e0,.339981043584856e0,.960289856497536e0, &
   & .796666477413627e0,.525532409916329e0,.183434642495650e0, &
   & .989400934991650e0,.944575023073233e0,.865631202387832e0, &
   & .755404408355003e0,.617876244402644e0,.458016777657227e0, &
   & .281603550779259e0,.950125098376374e-1/
data t(16),t(17),t(18),t(19),t(20),t(21),t(22),t(23),t(24),t(25), &
   & t(26),t(27),t(28),t(29),t(30),t(31)/.997263861849482e0, &
   & .985611511545268e0,.964762255587506e0,.934906075937740e0, &
   & .896321155766052e0,.849367613732570e0,.794483795967942e0, &
   & .732182118740290e0,.663044266930215e0,.587715757240762e0, &
   & .506899908932229e0,.421351276130635e0,.331868602282128e0, &
   & .239287362252137e0,.144471961582796e0,.483076656877383e-1/
data t(32),t(33),t(34),t(35),t(36),t(37),t(38),t(39),t(40),t(41), &
   & t(42),t(43),t(44),t(45),t(46),t(47)/.999305041735772e0, &
   & .996340116771955e0,.991013371476744e0,.983336253884626e0, &
   & .973326827789911e0,.961008799652054e0,.946411374858403e0, &
   & .929569172131940e0,.910522137078503e0,.889315445995114e0, &
   & .865999398154093e0,.840629296252580e0,.813265315122798e0, &
   & .783972358943341e0,.752819907260532e0,.719881850171611e0/
data t(48),t(49),t(50),t(51),t(52),t(53),t(54),t(55),t(56),t(57), &
   & t(58),t(59),t(60),t(61),t(62),t(63)/.685236313054233e0, &
   & .648965471254657e0,.611155355172393e0,.571895646202634e0, &
   & .531279464019895e0,.489403145707053e0,.446366017253464e0, &
   & .402270157963992e0,.357220158337668e0,.311322871990211e0, &
   & .264687162208767e0,.217423643740007e0,.169644420423993e0, &
   & .121462819296121e0,.729931217877990e-1,.243502926634244e-1/
data t(64),t(65),t(66),t(67),t(68),t(69),t(70),t(71),t(72),t(73), &
   & t(74),t(75),t(76),t(77),t(78),t(79)/.999824887947132e0, &
   & .999077459977376e0,.997733248625514e0,.995792758534981e0, &
   & .993257112900213e0,.990127818491734e0,.986406742724586e0, &
   & .982096108435719e0,.977198491463907e0,.971716818747137e0, &
   & .965654366431965e0,.959014757853700e0,.951801961341264e0, &
   & .944020287830220e0,.935674388277916e0,.926769250878948e0/
data t(80),t(81),t(82),t(83),t(84),t(85),t(86),t(87),t(88),t(89), &
   & t(90),t(91),t(92),t(93),t(94),t(95),t(96),t(97)/ &
   & .917310198080961e0,.907302883401757e0,.896753288049158e0, &
   & .885667717345397e0,.874052796958032e0,.861915468939548e0, &
   & .849262987577969e0,.836102915060907e0,.822443116955644e0, &
   & .808291757507914e0,.793657294762193e0,.778548475506412e0, &
   & .762974330044095e0,.746944166797062e0,.730467566741909e0, &
   & .713554377683587e0,.696214708369514e0,.678458922447719e0/
data t(98),t(99),t(100),t(101),t(102),t(103),t(104),t(105),t(106), &
   & t(107),t(108),t(109),t(110),t(111),t(112),t(113),t(114)/ &
   & .660297632272646e0,.641741692562308e0,.622802193910585e0, &
   & .603490456158549e0,.583818021628763e0,.563796648226618e0, &
   & .543438302412810e0,.522755152051175e0,.501759559136144e0, &
   & .480464072404172e0,.458881419833552e0,.437024501037104e0, &
   & .414906379552275e0,.392540275033267e0,.369939555349859e0, &
   & .347117728597636e0,.324088435024413e0/
data t(115),t(116),t(117),t(118),t(119),t(120),t(121),t(122), &
   & t(123),t(124),t(125),t(126),t(127)/.300865438877677e0, &
   & .277462620177904e0,.253893966422694e0,.230173564226660e0, &
   & .206315590902079e0,.182334305985337e0,.158244042714225e0, &
   & .134059199461188e0,.109794231127644e0, &
   & .854636405045155e-1,.610819696041396e-1,.366637909687335e-1, &
   & .122236989606158e-1/
data t(128),t(129),t(130),t(131),t(132),t(133),t(134),t(135), &
   & t(136),t(137),t(138),t(139),t(140),t(141),t(142)/ &
   & .999956050018992e0,.999768437409263e0,.999430937466261e0, &
   & .998943525843409e0,.998306266473006e0,.997519252756721e0, &
   & .996582602023382e0,.995496454481096e0,.994260972922410e0, &
   & .992876342608822e0,.991342771207583e0,.989660488745065e0, &
   & .987829747564861e0,.985850822286126e0,.983724009760315e0/
data t(143),t(144),t(145),t(146),t(147),t(148),t(149),t(150), &
   & t(151),t(152),t(153),t(154),t(155),t(156),t(157)/ &
   & .981449629025464e0,.979028021257622e0,.976459549719234e0, &
   & .973744599704370e0,.970883578480743e0,.967876915228489e0, &
   & .964725060975706e0,.961428488530732e0,.957987692411178e0, &
   & .954403188769716e0,.950675515316628e0,.946805231239127e0, &
   & .942792917117462e0,.938639174837814e0, .934344627502003e0/
data t(158),t(159),t(160),t(161),t(162),t(163),t(164),t(165), &
   & t(166),t(167),t(168),t(169),t(170),t(171),t(172)/ &
   & .929909919334006e0,.925335715583316e0,.920622702425146e0, &
   & .915771586857490e0,.910783096595065e0,.905657979960145e0, &
   & .900397005770304e0,.895000963223085e0,.889470661777611e0, &
   & .883806931033158e0,.878010620604707e0,.872082599995488e0, &
   & .866023758466555e0,.859835004903376e0,.853517267679503e0/
data t(173),t(174),t(175),t(176),t(177),t(178),t(179),t(180), &
   & t(181),t(182),t(183),t(184),t(185),t(186),t(187)/ &
   & .847071494517296e0,.840498652345763e0,.833799727155505e0, &
   & .826975723850813e0,.820027666098917e0,.812956596176432e0, &
   & .805763574812999e0,.798449681032171e0,.791016011989546e0, &
   & .783463682808184e0,.775793826411326e0,.768007593352446e0, &
   & .760106151642655e0,.752090686575492e0,.743962400549112e0/
data t(188),t(189),t(190),t(191),t(192),t(193),t(194),t(195), &
   & t(196),t(197),t(198),t(199),t(200),t(201),t(202)/ &
   & .735722512885918e0,.727372259649652e0,.718912893459971e0, &
   & .710345683304543e0,.701671914348685e0,.692892887742577e0, &
   & .684009920426076e0,.675024344931163e0,.665937509182049e0, &
   & .656750776292973e0,.647465524363725e0,.638083146272911e0, &
   & .628605049469015e0,.619032655759261e0,.609367401096334e0/
data t(203),t(204),t(205),t(206),t(207),t(208),t(209),t(210), &
   & t(211),t(212),t(213),t(214),t(215),t(216),t(217)/ &
   & .599610735362968e0,.589764122154454e0,.579829038559083e0, &
   & .569806974936569e0,.559699434694481e0,.549507934062719e0, &
   & .539234001866059e0,.528879179294822e0,.518445019673674e0, &
   & .507933088228616e0,.497344961852181e0,.486682228866890e0, &
   & .475946488786983e0,.465139352078479e0,.454262439917590e0/
data t(218),t(219),t(220),t(221),t(222),t(223),t(224),t(225), &
   & t(226),t(227),t(228),t(229),t(230),t(231),t(232)/ &
   & .443317383947527e0,.432305826033741e0,.421229418017624e0, &
   & .410089821468717e0,.398888707435459e0,.387627756194516e0, &
   & .376308656998716e0,.364933107823654e0,.353502815112970e0, &
   & .342019493522372e0,.330484865662417e0,.318900661840106e0, &
   & .307268619799319e0,.295590484460136e0,.283868007657082e0/
data t(233),t(234),t(235),t(236),t(237),t(238),t(239),t(240), &
   & t(241),t(242),t(243),t(244),t(245),t(246),t(247)/ &
   & .272102947876337e0,.260297069991943e0,.248452145001057e0, &
   & .236569949758284e0,.224652266709132e0,.212700883622626e0, &
   & .200717593323127e0,.188704193421389e0,.176662486044902e0, &
   & .164594277567554e0,.152501378338656e0,.140385602411376e0, &
   & .128248767270607e0,.116092693560333e0,.103919204810509e0/
data   t(248),t(249),t(250),t(251),t(252),t(253),t(254),t(255)/ &
   & .917301271635196e-1,.795272891002330e-1,.673125211657164e-1, &
   & .550876556946340e-1,.428545265363791e-1,.306149687799790e-1, &
   & .183708184788137e-1,.612391237518953e-2/
data w(1),w(2),w(3),w(4),w(5),w(6),w(7),w(8),w(9),w(10),w(11), &
   & w(12),w(13),w(14),w(15)/1.0e0,.347854845137454e0, &
   & .652145154862546e0,.101228536290376e0,.222381034453374e0, &
   & .313706645877887e0,.362683783378362e0,.271524594117541e-1, &
   & .622535239386479e-1,.951585116824928e-1,.124628971255534e0, &
   & .149595988816577e0,.169156519395003e0,.182603415044924e0, &
   & .189450610455068e0/
data w(16),w(17),w(18),w(19),w(20),w(21),w(22),w(23),w(24),w(25), &
   & w(26),w(27),w(28),w(29),w(30),w(31)/.701861000947010e-2, &
   & .162743947309057e-1,.253920653092621e-1,.342738629130214e-1, &
   & .428358980222267e-1,.509980592623762e-1,.586840934785355e-1, &
   & .658222227763618e-1,.723457941088485e-1,.781938957870703e-1, &
   & .833119242269468e-1,.876520930044038e-1,.911738786957639e-1, &
   & .938443990808046e-1,.956387200792749e-1,.965400885147278e-1/
data w(32),w(33),w(34),w(35),w(36),w(37),w(38),w(39),w(40),w(41), &
   & w(42),w(43),w(44),w(45),w(46),w(47)/.178328072169643e-2, &
   & .414703326056247e-2,.650445796897836e-2,.884675982636395e-2, &
   & .111681394601311e-1,.134630478967186e-1,.157260304760247e-1, &
   & .179517157756973e-1,.201348231535302e-1,.222701738083833e-1, &
   & .243527025687109e-1,.263774697150547e-1,.283396726142595e-1, &
   & .302346570724025e-1,.320579283548516e-1,.338051618371416e-1/
data w(48),w(49),w(50),w(51),w(52),w(53),w(54),w(55),w(56),w(57), &
   & w(58),w(59),w(60),w(61),w(62),w(63)/ .354722132568824e-1, &
   & .370551285402400e-1,.385501531786156e-1,.399537411327203e-1, &
   & .412625632426235e-1,.424735151236536e-1,.435837245293235e-1, &
   & .445905581637566e-1,.454916279274181e-1, .462847965813144e-1, &
   & .469681828162100e-1,.475401657148303e-1,.479993885964583e-1, &
   & .483447622348030e-1,.485754674415034e-1,.486909570091397e-1/
data w(64),w(65),w(66),w(67),w(68),w(69),w(70),w(71),w(72),w(73), &
   & w(74),w(75),w(76),w(77),w(78),w(79)/ .449380960292090e-3, &
   & .104581267934035e-2,.164250301866903e-2,.223828843096262e-2, &
   & .283275147145799e-2,.342552604091022e-2,.401625498373864e-2, &
   & .460458425670296e-2,.519016183267633e-2,.577263754286570e-2, &
   & .635166316170719e-2,.692689256689881e-2,.749798192563473e-2, &
   & .806458989048606e-2,.862637779861675e-2,.918300987166087e-2/
data w(80),w(81),w(82),w(83),w(84),w(85),w(86),w(87),w(88), &
   & w(89),w(90),w(91),w(92),w(93),w(94),w(95)/.973415341500681e-2, &
   & .102794790158322e-1,.108186607395031e-1,.113513763240804e-1, &
   & .118773073727403e-1,.123961395439509e-1,.129075627392673e-1, &
   & .134112712886163e-1,.139069641329520e-1,.143943450041668e-1, &
   & .148731226021473e-1,.153430107688651e-1,.158037286593993e-1, &
   & .162550009097852e-1,.166965578015892e-1,.171281354231114e-1/
data w(96),w(97),w(98),w(99),w(100),w(101),w(102),w(103),w(104), &
   & w(105),w(106),w(107),w(108),w(109),w(110),w(111),w(112)/ &
   & .175494758271177e-1,.179603271850087e-1,.183604439373313e-1, &
   & .187495869405447e-1,.191275236099509e-1,.194940280587066e-1, &
   & .198488812328309e-1,.201918710421300e-1,.205227924869601e-1, &
   & .208414477807511e-1,.211476464682213e-1,.214412055392085e-1, &
   & .217219495380521e-1,.219897106684605e-1,.222443288937998e-1, &
   & .224856520327450e-1,.227135358502365e-1/
data w(113),w(114),w(115),w(116),w(117),w(118),w(119),w(120), &
   & w(121),w(122),w(123),w(124),w(125),w(126),w(127)/ &
   & .229278441436868e-1,.231284488243870e-1,.233152299940628e-1, &
   & .234880760165359e-1,.236468835844476e-1,.237915577810034e-1, &
   & .239220121367035e-1,.240381686810241e-1,.241399579890193e-1, &
   & .242273192228152e-1,.243002001679719e-1,.243585572646906e-1, &
   & .244023556338496e-1,.244315690978500e-1,.244461801962625e-1/
data w(128),w(129),w(130),w(131),w(132),w(133),w(134),w(135), &
   & w(136),w(137),w(138),w(139),w(140),w(141),w(142)/ &
   & .112789017822272e-3,.262534944296446e-3,.412463254426176e-3, &
   & .562348954031410e-3,.712154163473321e-3,.861853701420089e-3, &
   & .101142439320844e-2,.116084355756772e-2,.131008868190250e-2, &
   & .145913733331073e-2,.160796713074933e-2,.175655573633073e-2, &
   & .190488085349972e-2,.205292022796614e-2,.220065164983991e-2/
data w(143),w(144),w(145),w(146),w(147),w(148),w(149),w(150), &
   & w(151),w(152),w(153),w(154),w(155),w(156),w(157)/ &
   & .234805295632731e-2,.249510203470371e-2,.264177682542749e-2, &
   & .278805532532771e-2,.293391559082972e-2,.307933574119934e-2, &
   & .322429396179420e-2,.336876850731555e-2,.351273770505631e-2, &
   & .365617995814250e-2,.379907374876626e-2,.394139764140883e-2, &
   & .408313028605267e-2,.422425042138154e-2,.436473687796806e-2/
data w(158),w(159),w(160),w(161),w(162),w(163),w(164),w(165), &
   & w(166),w(167),w(168),w(169),w(170),w(171),w(172)/ &
   & .450456858144790e-2,.464372455568006e-2,.478218392589269e-2, &
   & .491992592181387e-2,.505692988078684e-2,.519317525086928e-2, &
   & .532864159391593e-2,.546330858864431e-2,.559715603368291e-2, &
   & .573016385060144e-2,.586231208692265e-2,.599358091911534e-2, &
   & .612395065556793e-2,.625340173954240e-2,.638191475210788e-2/
data w(173),w(174),w(175),w(176),w(177),w(178),w(179),w(180), &
   & w(181),w(182),w(183),w(184),w(185),w(186),w(187)/ &
   & .650947041505366e-2,.663604959378107e-2,.676163330017380e-2, &
   & .688620269544632e-2,.700973909296982e-2,.713222396107539e-2, &
   & .725363892583391e-2,.737396577381235e-2,.749318645480588e-2, &
   & .761128308454566e-2,.772823794738156e-2,.784403349893971e-2, &
   & .795865236875435e-2,.807207736287350e-2,.818429146643827e-2/
data w(188),w(189),w(190),w(191),w(192),w(193),w(194),w(195), &
   & w(196),w(197),w(198),w(199),w(200),w(201),w(202)/ &
   & .829527784623523e-2,.840501985322154e-2,.851350102502249e-2, &
   & .862070508840101e-2,.872661596169881e-2,.883121775724875e-2, &
   & .893449478375821e-2,.903643154866287e-2,.913701276045081e-2, &
   & .923622333095630e-2,.933404837762327e-2,.943047322573775e-2, &
   & .952548341062928e-2,.961906467984073e-2,.971120299526628e-2/
data w(203),w(204),w(205),w(206),w(207),w(208),w(209),w(210), &
   & w(211),w(212),w(213),w(214),w(215),w(216),w(217)/ &
   & .980188453525733e-2,.989109569669583e-2,.997882309703491e-2, &
   & .100650535763064e-1,.101497741990949e-1,.102329722564782e-1, &
   & .103146352679340e-1,.103947509832117e-1,.104733073841704e-1, &
   & .105502926865815e-1,.106256953418966e-1,.106995040389798e-1, &
   & .107717077058046e-1,.108422955111148e-1,.109112568660490e-1/
data w(218),w(219),w(220),w(221),w(222),w(223),w(224),w(225), &
   & w(226),w(227),w(228),w(229),w(230),w(231),w(232)/ &
   & .109785814257296e-1,.110442590908139e-1,.111082800090098e-1, &
   & .111706345765534e-1,.112313134396497e-1,.112903074958755e-1, &
   & .113476078955455e-1,.114032060430392e-1,.114570935980906e-1, &
   & .115092624770395e-1,.115597048540436e-1,.116084131622531e-1, &
   & .116553800949452e-1,.117005986066207e-1,.117440619140606e-1/
data w(233),w(234),w(235),w(236),w(237),w(238),w(239),w(240), &
   & w(241),w(242),w(243),w(244),w(245),w(246),w(247)/ &
   & .117857634973434e-1,.118256971008240e-1,.118638567340711e-1, &
   & .119002366727665e-1,.119348314595636e-1,.119676359049059e-1, &
   & .119986450878058e-1,.120278543565826e-1,.120552593295601e-1, &
   & .120808558957245e-1,.121046402153405e-1,.121266087205273e-1, &
   & .121467581157945e-1,.121650853785355e-1,.121815877594818e-1/
data w(248),w(249),w(250),w(251),w(252),w(253),w(254),w(255)/ &
   & .121962627831147e-1,.122091082480372e-1,.122201222273040e-1, &
   & .122293030687103e-1,.122366493950402e-1,.122421601042728e-1, &
   & .122458343697479e-1,.122476716402898e-1/
loop = max0(1,n/256)
floop = loop
h = (b - a)/floop
scale = h/2.0
m = min0(128,n/2)
mt = 2*m
nplace = m - 1
do 1 l = 1,loop
   fl = l
   al = a + (fl - 1.0)*h
   bl = a + fl*h
   k = 256*(l - 1)
   do 1 i = 1,m
      npi = nplace + i
      s = t(npi)
      r = w(npi)*scale
      i1 = k + i
      i2 = k + mt + 1 - i
      tv(i1) = (al*(1.0 + s) + (1.0 - s)*bl)/2.0
      tv(i2) = (al*(1.0 - s) + (1.0 + s)*bl)/2.0
      wv(i1) = r
1     wv(i2) = r
return
end subroutine wandt

subroutine leave(ierset,nf,mf,xv,tv,wv,error,kernel,rhfcn,ep, &
   & iflag,x,t,nt,ier,eps,elinsy,tn,wn,tm,wm,xm,xmz,kmm,kmn,knm, &
   & rhs,imknn,lufact,r,rh,deln,nup,nhalf,xnorm)
implicit none
integer :: ier, ierset, iflag, mf, nf, nhalf, nt, nup
real :: deln(nf), elinsy, ep, eps, error, r(mf), rh(nf), rhs(mf), &
   & t(*), tm(mf), tn(nf), tv(mf), wm(mf), wn(nf), wv(mf), x(*), &
   & xm(mf), xmz(mf), xnorm, xv(mf)
real :: rhfcn
real :: kernel, kmm(nup,nup), kmn(nup,nhalf), knm(nhalf,nup), &
   & imknn(nup,nup), lufact(nup,nup)
external kernel, rhfcn
integer :: i, itloop, j
real :: derror, savep, sum, temp
integer :: mfinal, nfinal
real :: finlep, r1, r2
real :: rnrm
real :: normk, numr1
!
!   This routine sets all necessary parameters for leaving IEGAUS.
!   If nt .GT. 0, it also performs the necessary Nystrom
!   interpolation at the nodes given in T.
!
common/xxinfo/r1,r2,finlep,normk,nfinal,mfinal
!
!   Set error parameters for return.
!
normk = 0.0
nfinal = nf
mfinal = mf
finlep = eps
if ((eps .gt. ep) .and. (error .le. eps)) go to 10
ier = ierset
ep = error
if (nt .eq. 0) go to 20
go to 30
10 ier = 3
!
!   Since eps is the smallest error possible, set ep=eps for the
!   RETURN ERROR ESTIMATE.
!
ep = eps
if (nt .gt. 0) go to 30
!
!   No Nystrom interpolation is desired. Return the values at the
!   Gaussian node points.
!
20 do 21 i = 1,mf
   x(i) = xv(i)
21 t(i) = tv(i)
nt = mf
return
!   Calculate norm(K).
30 savep = ep
do 31 i = 1,nf
31 imknn(i,i) = imknn(i,i) - 1.0
normk = 0.0
do 33 i = 1,nf
   sum = 0.0
   do 32 j = 1,nf
32    sum = sum + abs(imknn(i,j))
33 normk = amax1(normk,sum)
do 34 i = 1,nf
34 imknn(i,i) = imknn(i,i) + 1.0
if (nf .eq. mf) go to 50
!
!   Iterate to decrease the noise level in X. this should reduce
!   possible errors in Nystrom interpolation.
!
derror = ((1.0 - r1)/r1)*eps/normk
if (iflag .eq. 1) derror = derror*xnorm
itloop = 0
do 41 i = 1,mf
41 xm(i) = xv(i)
42 do 43 i = 1,mf
43 xmz(i) = xm(i)
call itert(kernel,rhfcn,nf,tn,wn,mf,tm,wm,xm,xmz,kmm,kmn,knm, &
   & rhs,imknn,lufact,r,rh,deln,nup,nhalf,1)
numr1 = rnrm(xm,xmz,mf,1)
itloop = itloop + 1
if ((numr1 .gt. derror) .and. (itloop .lt. 5)) go to 42
do 44 i = 1,mf
44 xv(i) = xm(i)
!
!   Estimate new error bound for Nystrom interpolates.
!
temp = normk*(r1/(1.0 - r1))*numr1
if (iflag .eq. 1) temp = temp/xnorm
ep = amax1(ep,temp)
go to 60
!
!   No iteration used in computing X. just compute error estimate
!   in Nystrom interpolate.
!
50 temp = normk*elinsy
if (iflag .eq. 0) temp = temp*xnorm
if (ier .ne. 2) ep = amax1(ep,temp)
!
!   Compute Nystrom interpolates at the nodes in T.
!
60 do 62 i = 1,nt
   sum = 0.0
   do 61 j = 1,mf
61    sum = sum + wv(j)*kernel(t(i),tv(j))*xv(j)
62 x(i) = rhfcn(t(i)) + sum
if ((ier .eq. 0) .and. (ep .gt. eps)) ier = 4
if ((ier .eq. 1) .and. (ep .gt. error)) ier = 5
if ((ier .eq. 3) .and. (ep .gt. eps)) ier = 6
ep = savep
return
end subroutine leave

subroutine itert(kernel,rhfcn,n,tn,wn,m,tm,wm,xm,xmz,kmm,kmn, &
   & knm,rhs,imknn,lufact,r,rh,deln,nup,nhalf,iflg)
implicit none
integer, intent(in) :: iflg, m
integer :: n
integer, intent(in) :: nhalf
integer :: nup
real, intent(inout) :: deln(n), r(m), rh(n)
real :: rhfcn, rhs(m), tm(m), tn(n), wm(m), wn(n)
real, intent(inout) :: xm(m)
real :: xmz(m)
real :: kernel
real, intent(inout) :: kmm(nup,nup)
real :: kmn(nup,nhalf)
real, intent(inout) :: knm(nhalf,nup)
real :: imknn(nup,nup)
real, intent(inout) :: lufact(nup,nup)
external kernel, rhfcn
integer :: i, ind, j
real :: sum
!
!   This routine calculates one iterate xm given the initial guess
!   xmz. The routine is divided according to whether or not
!   m .GT. NUPPER.
!
!
!   m .GT. NUPPER means that the matrices kmm,kmn,knm can no longer
!   be stored due to lack of space.
if (m .gt. nup) go to 13
if (iflg .eq. 1) go to 3
!   If iflg=0, then the matrices kmm and knm must be computed
!   and stored.
do 2 j = 1,m
   do 1 i = 1,m
1     kmm(i,j) = wm(j)*kernel(tm(i),tm(j))
   do 2 i = 1,n
2     knm(i,j) = wm(j)*kernel(tn(i),tm(j))
!   Compute  residuals r(i)=rhfcn(tm(i))-xmz(i)+km(tm(i))*xmz(i)
3 do 5 i = 1,m
   sum = 0.0
   do 4 j = 1,m
4     sum = sum + kmm(i,j)*xmz(j)
5  r(i) = rhs(i) - (xmz(i) - sum)
!
!   COMPUTE rh=km*r AT ALL tn(i).
do 7 i = 1,n
   rh(i) = 0.0
   do 7 j = 1,m
7     rh(i) = rh(i) + knm(i,j)*r(j)
!   CALCULATE deln=((i-KN)**(-1))*km*r AT ALL tn(i).
!
!*******************************************************************
!                                                                  *
call lnsys(imknn,lufact,nup,n,rh,deln,4,ind)
!                                                                  *
!   SEE THE ORIGINAL REFERENCE IN iegs.                            *
!*******************************************************************
!
!   Calculate new xm.
do 12 i = 1,m
   sum = 0.0
   do 10 j = 1,m
10    sum = sum + kmm(i,j)*r(j)
   do 11 j = 1,n
11    sum = sum + kmn(i,j)*deln(j)
12 xm(i) = sum + r(i) + xmz(i)
return
!   Entrance when m .GT. nup.
!   Calculate residuals.
13 do 15 i = 1,m
   sum = 0.0
   do 14 j = 1,m
14    sum = sum + wm(j)*kernel(tm(i),tm(j))*xmz(j)
15 r(i) = rhs(i) - (xmz(i) - sum)
!   CALCULATE rh=km*r.
do 17 i = 1,n
   rh(i) = 0.0
   do 17 j = 1,m
17    rh(i) = rh(i) + wm(j)*kernel(tn(i),tm(j))*r(j)
!
!*******************************************************************
!                                                                  *
call lnsys(imknn,lufact,nup,n,rh,deln,4,ind)
!                                                                  *
!   SEE THE ORIGINAL REFERENCE IN iegs.                            *
!*******************************************************************
!
!   CALCULATE xm.
do 22 i = 1,m
   sum = 0.0
   do 20 j = 1,m
20    sum = sum + wm(j)*kernel(tm(i),tm(j))*r(j)
   do 21 j = 1,n
21    sum = sum + wn(j)*kernel(tm(i),tn(j))*deln(j)
22 xm(i) = sum + r(i) + xmz(i)
return
end subroutine itert

subroutine lnsys(a,d,m,n,b,x,option,ierr)
implicit none
integer :: ierr, m, n
real :: a(m,n), d(m,n), b(n), x(n)
integer :: option
integer :: i, ip1, iswit, j, k, kp1, l, nm1, nmi
real :: c, sum, t
real :: error, relrsd
integer :: pivot(128)
real :: normx, norme, normb, normr, r(128), scale(128)
!
!   Solve AX = b where A is a matrix of order n. m is the number of
!   rows in the dimension statement for A in the calling program.
!
!   option=1   Compute an LU decomposition of A and store it in d.
!              Store the pivot indices in pivot and solve AX = b.
!   option=2   Compute an LU decomposition of A and store it in d.
!              Store the pivot indices in pivot and solve AX = b.
!              Then compute the residual and one correction. The
!              correction is stored in r, the new value X1 in x,
!              the relative error
!                         norm(X0-X1)/norm(X1)
!              in the variable error, and the relative residual
!                         norm(residual)/norm(b)
!              in the variable relrsd. These values can be obtained
!              using the common/XXLIN/ given below.
!   option=3   Same as option=1, except that the LU decomposition
!              has already been stored in d and the pivot indices
!              in pivot.
!   option=4   Same as option=2, except that the LU decomposition
!              has already been stored in d and the pivot indices
!              in pivot.
!
!   The LU decomposition is obtained using scaled partial pivoting.
!   For options 1 and 2, ierr is a variable that reports the status
!   of the results. ierr = 0 If the LU decomposition is obtained.
!   Otherwise, ierr = -k when the k-TH row of a contains only zeros
!   or ierr = k when the k-TH pivot element is 0.
!
!   It is assumed that n .LE. 128. This assumption may be modified
!   by changing the dimension statements for the arrays pivot, r,
!   and scale. Also modify the dimension statement for pivot in the
!   SUBROUTINE iegs.
!
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
10    scale(i) = scale(i) + abs(d(i,j))
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
20    continue
!
   if (c .ne. 0.0) go to 30
   ierr = k
   return
!
!     Interchange rows k and l
!
30 pivot(k) = l
   if (k .eq. l) go to 40
   do 31 j = k,n
      t = d(k,j)
      d(k,j) = d(l,j)
31    d(l,j) = t
   t = scale(k)
   scale(k) = scale(l)
   scale(l) = t
!
!     Eliminate the k-TH unknown below the diagonal
!
40 do i = kp1,n
      d(i,k) = d(i,k)/d(k,k)
      t = d(i,k)
      do 41 j = kp1,n
41       d(i,j) = d(i,j) - t*d(k,j)
   end do
end do
!
if (d(n,n) .ne. 0.0) go to 100
ierr = n
return
!
!               Store b in r and set x = 0
!
100 do 110 i = 1,n
   r(i) = b(i)
110 x(i) = 0.0
go to 200
!
!             Compute the residual r = b - AX
!
120 do 131 i = 1,n
   sum = 0.0
   do 130 j = 1,n
130   sum = sum + a(i,j)*x(j)
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
!             SOLVE LZ = r AND STORE Z IN r
!
200 do k = 1,nm1
   l = pivot(k)
   if (k .eq. l) go to 210
   t = r(k)
   r(k) = r(l)
   r(l) = t
210 kp1 = k + 1
   do 211 i = kp1,n
211   r(i) = r(i) - d(i,k)*r(k)
end do
!
!      Solve UE = r, store E in r, and set x = x + E
!
r(n) = r(n)/d(n,n)
x(n) = x(n) + r(n)
do 221 nmi = 1,nm1
   i = n - nmi
   ip1 = i + 1
   sum = 0.0
   do 220 j = ip1,n
220   sum = sum + d(i,j)*r(j)
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
external f
integer :: ialpha, ibeta, idelsn, ig, ih, ihold, ip, iphase, iphi, &
   & ipsi, isig, istart, itold, iv, iw, iwt, ix, iyp, iypout, iyy
logical :: start, phase1, nornd
!
!     Sandia mathematical program library
!     applied mathematics division 2642
!     Sandia Laboratories
!     albuquerque, new mexico  87115
!     January 1976
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
!   Written by L. F. Shampine and M. K. Gordon
!
!   Abstract
!
!   Subroutine  ode  integrates a system of  neqn  first order
!   ordinary differential equations of the form
!             DY(I)/DT = F(t,y(1),y(2),...,y(neqn))
!             y(I) given at  t .
!   The subroutine integrates from  t  to  tout .  On return the
!   parameters in the call list are set for continuing the integration.
!   The user has only to define a new value  tout  and call  ODE  again.
!
!   The differential equations are actually solved by a suite of codes
!   de1,  step1, and  intrp .  ODE  allocates virtual storage in the
!   arrays  work  and  iwork  and calls  de1.  de1 is a supervisor which
!   directs the solution.  It calls on the routines  step1 and  intrp
!   to advance the integration and to interpolate at output points.
!   step1 uses a modified divided difference form of the Adams PECE
!   formulas and local extrapolation.  It adjusts the order and step
!   size to control the local error per unit step in a generalized
!   sense.  Normally each call to  step1 advances the solution one step
!   in the direction of  tout .  For reasons of efficiency  de1
!   integrates beyond  tout  internally, though never beyond
!   t+10*(tout-t), and calls  intrp  to interpolate the solution at
!   tout .  An option is provided to stop the integration at  tout  but
!   it should be used only if it is impossible to continue the
!   integration beyond  tout .
!
!   This code is completely explained and documented in the text,
!   computer solution of ordinary differential equations,  the initial
!   value problem  by L. F. Shampine and M. K. Gordon.
!
!   The parameters represent...
!      F -- subroutine F(t,y,YP) to evaluate derivatives YP(I)=DY(I)/DT
!      neqn -- number of equations to be integrated
!      y(*) -- solution vector at  t
!      t -- independent variable
!      tout -- point at which solution is desired
!      relerr,abserr -- relative and absolute error tolerances for local
!           error test.  At each step the code requires
!             abs(LOCAL ERROR) .LE. abs(y)*relerr + abserr
!           for each component of the local error and solution vectors
!      iflag -- indicates status of integration
!      work(*),iwork(*) -- arrays to hold information internal to code
!           which is necessary for subsequent calls
!
!   First call to ODE --
!
!   The user must provide storage in his calling program for the arrays
!   in the call list,
!      y(neqn), work(100+21*neqn), iwork(5),
!   declare  F  in an external statement, supply the subroutine
!   F(t,y,YP) to evaluate
!      DY(I)/DT = YP(I) = F(t,y(1),y(2),...,y(neqn))
!   and initialize the parameters...
!      neqn -- number of equations to be integrated
!      y(*) -- vector of initial conditions
!      t -- starting point of integration
!      tout -- point at which solution is desired
!      relerr,abserr -- relative and absolute local error tolerances
!      iflag -- +1,-1.  Indicator to initialize the code.  Normal input
!           is +1.  The user should set iflag=-1 Only if it is
!           impossible to continue the integration beyond  tout .
!   All parameters except  F ,  neqn  and  tout  may be altered by the
!   code on output so must be variables in the calling program.
!
!   Output from  ODE  --
!
!      neqn -- UNCHANGED
!      y(*) -- solution at  t
!      t -- last point reached in integration.  Normal return has
!           t = tout .
!      tout -- unchanged
!      relerr,abserr -- normal return has tolerances unchanged.  iflag=3
!           signals tolerances increased
!      iflag = 2 -- normal return.  Integration reached  tout
!            = 3 -- integration did not reach  tout  because error
!                   tolerances too small.  relerr ,  abserr  increased
!                   appropriately for continuing
!            = 4 -- integration did not reach  tout  because more than
!                   MAXNUM steps needed
!            = 5 -- integration did not reach  tout  because equations
!                   appear to be stiff
!            = 6 -- integration did not reach  tout  because solution
!                   vanished making pure relative error impossible.
!                   Must use non-zero  abserr  to continue.
!            = 7 -- Invalid input parameters (fatal error)
!           the value of  iflag  is returned negative when the input
!           value is negative and the integration does not reach  tout ,
!           I.E., -3, -4, -5, -6.
!      work(*),iwork(*) -- information generally of no interest to the
!           user but necessary for subsequent calls.
!
!   Subsequent calls to  ODE --
!
!   Subroutine  ode  returns with all information needed to continue
!   the integration.  If the integration reached  tout , the user need
!   only define a new  tout  and call again.  If the integration did not
!   reach  tout  and the user wants to continue, he just calls again.
!   In the case  iflag=6 , the user must also alter the error criterion.
!   The output value of  iflag  is the appropriate input value for
!   subsequent calls.  The only situation in which it should be altered
!   is to stop the integration internally at the new  tout , I.E.,
!   change output  iflag=2  To input  iflag=-2 .  Error tolerances may
!   be changed by the user before continuing.  All other parameters must
!   remain unchanged.
!
data ialpha,ibeta,isig,iv,iw,ig,iphase,ipsi,ix,ih,ihold,istart, &
   & itold,idelsn/1,13,25,38,50,62,75,76,88,89,90,91,92,93/
!
iyy = 100
iwt = iyy + neqn
ip = iwt + neqn
iyp = ip + neqn
iypout = iyp + neqn
iphi = iypout + neqn
if (iabs(iflag) .lt. 2  .or.  iabs(iflag) .gt. 6) go to 1
start = work(istart) .gt. 0.0
phase1 = work(iphase) .gt. 0.0
nornd = iwork(2) .ne. -1
1 call de1(f,neqn,y,t,tout,relerr,abserr,iflag,work(iyy), &
   & work(iwt),work(ip),work(iyp),work(iypout),work(iphi), &
   & work(ialpha),work(ibeta),work(isig),work(iv),work(iw),work(ig), &
   & phase1,work(ipsi),work(ix),work(ih),work(ihold),start, &
   & work(itold),work(idelsn),iwork(1),nornd,iwork(3),iwork(4), &
   & iwork(5))
work(istart) = -1.0
if (start) work(istart) = 1.0
work(iphase) = -1.0
if (phase1) work(iphase) = 1.0
iwork(2) = -1
if (nornd) iwork(2) = 1
return
end subroutine ode

subroutine de1(f,neqn,y,t,tout,relerr,abserr,iflag, &
   & yy,wt,p,yp,ypout,phi,alpha,beta,sig,v,w,g,phase1,psi,x,h,hold, &
   & start,told,delsgn,ns,nornd,k,kold,isnold)
implicit none
integer, intent(inout) :: iflag, isnold, k, kold
integer, intent(in) :: neqn
integer, intent(inout) :: ns
real, intent(inout) :: abserr, alpha(12), beta(12), delsgn, g(13), &
   & h, hold, p(neqn), phi(neqn,16), psi(12), relerr, sig(13), t, told
real, intent(in) :: tout
real, intent(inout) :: v(12), w(12), wt(neqn), x, y(neqn)
real :: yp(neqn)
real, intent(inout) :: ypout(neqn), yy(neqn)
logical, intent(inout) :: start, phase1, nornd
external f
integer :: isn, kle4, l, maxnum, nostep
real :: absdel, abseps, del, eps, fouru, releps, tend, u
real :: spmpar
logical :: stiff, crash
!
!   ODE  merely allocates storage for  de1 to relieve the user of the
!   inconvenience of a long call list.  Consequently  de1 is used as
!   described in the comments for  ODE .
!
!   This code is completely explained and documented in the text,
!   computer solution of ordinary differential equations,  the initial
!   value problem  by L. F. Shampine and M. K. Gordon.
!
!
!   The constant  maxnum  is the maximum number of steps allowed in one
!   CALL TO  de1.  THE USER MAY CHANGE THIS LIMIT BY ALTERING THE
!   following statement
!
data maxnum/500/
!
!   ****** u is a machine dependent parameter. u is the smallest
!          positive number for which 1.0 + u .GT. 1.0.
!
u = spmpar(1)
fouru = 4.0*u
!
!            ***            ***            ***
!
!   Test for improper parameters
!
if (neqn .lt. 1) go to 10
if (t .eq. tout) go to 10
if (relerr .lt. 0.0  .or.  abserr .lt. 0.0) go to 10
eps = amax1(relerr,abserr)
if (eps .le. 0.0) go to 10
if (iflag .eq. 0) go to 10
isn = isign(1,iflag)
iflag = iabs(iflag)
if (iflag .eq. 1) go to 20
if (t .ne. told) go to 10
if (iflag .ge. 2  .and.  iflag .le. 5) go to 20
if (iflag .eq. 6  .and.  abserr .gt. 0.0) go to 20
10 iflag = 7
return
!
!   On each call set interval of integration and counter for number of
!   steps.  Adjust input error tolerances to define weight vector for
!   SUBROUTINE  step1
!
20 del = tout - t
absdel = abs(del)
tend = t + 10.0*del
if (isn .lt. 0) tend = tout
nostep = 0
kle4 = 0
stiff = .false.
releps = relerr/eps
abseps = abserr/eps
if (iflag .eq. 1) go to 30
if (isnold .lt. 0) go to 30
if (delsgn*del .gt. 0.0) go to 50
!
!   On start and restart also set work variables x and yy(*), store the
!   direction of integration and initialize the step size
!
30 start = .true.
x = t
do 40 l = 1,neqn
40 yy(l) = y(l)
delsgn = sign(1.0,del)
h = sign(amax1(fouru*abs(x),abs(tout - x)),tout - x)
!
!   If already past output point, interpolate and return
!
50 if (abs(x - t) .lt. absdel) go to 60
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
60 if (isn .gt. 0  .or.  abs(tout - x) .ge. fouru*abs(x)) go to 80
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
80 if (nostep .lt. maxnum) go to 100
iflag = isn*4
if (stiff) iflag = isn*5
do 90 l = 1,neqn
90 y(l) = yy(l)
t = x
told = t
isnold = 1
return
!
!   Limit step size, set weight vector and take a step
!
100 h = sign(amin1(abs(h),abs(tend - x)),h)
do l = 1,neqn
   wt(l) = releps*abs(yy(l)) + abseps
   if (wt(l) .le. 0.0) go to 140
end do
call step1(f,neqn,yy,x,h,eps,wt,start, &
   & hold,k,kold,crash,phi,p,yp,psi, &
   & alpha,beta,sig,v,w,g,phase1,ns,nornd)
!
!   Test for tolerances too small
!
if (.not.crash) go to 130
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
if (kold .gt. 4) kle4 = 0
if (kle4 .ge. 50) stiff = .true.
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
   & hold,k,kold,crash,phi,p,yp,psi, &
   & alpha,beta,sig,v,w,g,phase1,ns,nornd)
implicit none
integer, intent(inout) :: k, kold
integer, intent(in) :: neqn
integer, intent(inout) :: ns
real, intent(inout) :: alpha(12), beta(12), eps, g(13), h, hold, &
   & p(neqn), phi(neqn,16), psi(12), sig(13), v(12), w(12)
real :: wt(neqn)
real, intent(inout) :: x, y(neqn)
real :: yp(neqn)
logical, intent(inout) :: start
logical, intent(out) :: crash
logical, intent(inout) :: phase1, nornd
external f
integer :: i, ifail, im1, ip1, iq, j, km1, km2, knew, kp1, kp2, l, &
   & limit1, limit2, nsm2, nsp1, nsp2
real :: absh, erk, erkm1, erkm2, erkp1, err, fouru, gstr(13), &
   & hnew, p5eps, r, reali, realns, rho, round, sum, tau, temp1, temp2, &
   & temp3, temp4, temp5, temp6, two(13), twou, u, xold
real :: spmpar
!
!   Written by L. F. Shampine and M. K. Gordon
!
!   Abstract
!
!   Subroutine  step1  is normally used indirectly through subroutine
!   ODE .  Because  ODE  suffices for most problems and is much easier
!   to use, using it should be considered before using  step1  alone.
!
!   Subroutine step1 integrates a system of  neqn  first order ordinary
!   differential equations one step, normally from x to x+h, using A
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
!      neqn -- number of equations to be integrated
!      y(*) -- solution vector at x
!      x -- independent variable
!      h -- appropriate step size for next step.  Normally determined by
!           code
!      eps -- local error tolerance
!      wt(*) -- vector of weights for error criterion
!      start -- logical variable SET .TRUE. for first step,  .FALSE.
!           Otherwise
!      hold -- step size used for last successful step
!      k -- appropriate order for next step (determined by code)
!      kold -- order used for last successful step
!      crash -- logical variable SET .TRUE. when no step can be taken,
!           .FALSE. otherwise.
!      yp(*) -- derivative of solution vector at  x  after successful
!           step
!   the arrays  phi, psi  are required for the interpolation subroutine
!   intrp .  The array  P  is internal to the code.  The remaining nine
!   variables and arrays are included in the call list only to eliminate
!   local retention of variables between calls.
!
!   Input to step1
!
!      First call --
!
!   The user must provide storage in his calling program for all arrays
!   in the call list, namely
!
!     dimension y(neqn),wt(neqn),phi(neqn,16),p(neqn),yp(neqn),psi(12),
!    1  alpha(12),beta(12),sig(13),V(12),W(12),g(13)
!
!   The user must also declare  start ,  crash ,  phase1  and  nornd
!   LOGICAL VARIABLES AND  F  AN EXTERNAL SUBROUTINE, SUPPLY THE
!   subroutine  f(x,y,yp)  to evaluate
!      DY(i)/DX = yp(i) = F(x,y(1),y(2),...,y(neqn))
!   and initialize only the following parameters...
!      neqn -- number of equations to be integrated
!      y(*) -- vector of initial values of dependent variables
!      x -- initial value of the independent variable
!      h -- nominal step size indicating direction of integration
!           and maximum size of step.  Must be variable
!      eps -- local error tolerance per step.  Must be variable
!      wt(*) -- vector of non-zero weights for error criterion
!      start -- .TRUE.
!
!   step1  requires that the L2 norm of the vector with components
!   local error(l)/wt(l)  be less than  eps  for a successful step.  The
!   array  wt  allows the user to specify an error test appropriate
!   for his problem.  For example,
!      wt(l) = 1.0  specifies absolute error,
!            = abs(y(l))  error relative to the most recent value of the
!                 l-TH component of the solution,
!            = abs(yp(l))  error relative to the most recent value of
!                 the l-TH component of the derivative,
!            = AMAX1(wt(l),abs(y(l)))  error relative to the largest
!                 magnitude of l-TH component obtained so far,
!            = abs(y(l))*RELERR/eps + ABSERR/eps  specifies a mixed
!                 relative-absolute test where  RELERR  is relative
!                 error,  ABSERR  is absolute error and  eps =
!                 AMAX1(RELERR,ABSERR) .
!
!      Subsequent calls --
!
!   Subroutine  step1  is designed so that all information needed to
!   CONTINUE THE INTEGRATION, INCLUDING THE STEP SIZE  h  AND THE ORDER
!   k , is returned with each step.  With the exception of the step
!   size, the error tolerance, and the weights, none of the parameters
!   should be altered.  The array  wt  must be updated after each step
!   to maintain relative error tests like those above.  Normally the
!   integration is continued just beyond the desired endpoint and the
!   solution interpolated there with subroutine  intrp .  If it is
!   impossible to integrate beyond the endpoint, the step size may be
!   reduced to hit the endpoint since the code will not take a step
!   larger than the  h  input.  Changing the direction of integration,
!   I.E., the sign of  h , requires the user set  start = .TRUE. before
!   calling  step1  again.  This is the only situation in which  start
!   should be altered.
!
!   Output from step1
!
!      Successful step --
!
!   The subroutine returns after each successful step with  start  and
!   crash  set .FALSE. .  x  represents the independent variable
!   advanced one step of length  hold  from its value on input and  y
!   the solution vector at the new value of  x .  All other parameters
!   represent information corresponding to the new  x  needed to
!   CONTINUE THE INTEGRATION.
!
!      Unsuccessful step --
!
!   When the error tolerance is too small for the machine precision,
!   the subroutine returns without taking a step and  crash = .TRUE. .
!   An appropriate step size and error tolerance for continuing are
!   estimated and all other information is restored as upon input
!   before returning.  To continue with the larger tolerance, the user
!   just calls the code again.  A restart is neither required nor
!   desirable.
!
!
data two(1)/2.0/, two(2)/4.0/, two(3)/8.0/, two(4)/16.0/, &
   & two(5)/32.0/, two(6)/64.0/, two(7)/128.0/, two(8)/256.0/, &
   & two(9)/512.0/, two(10)/1024.0/, two(11)/2048.0/, &
   & two(12)/4096.0/, two(13)/8192.0/
data gstr(1)/0.500/, gstr(2)/0.0833/, gstr(3)/0.0417/, &
   & gstr(4)/0.0264/, gstr(5)/0.0188/, gstr(6)/0.0143/, &
   & gstr(7)/0.0114/, gstr(8)/0.00936/, gstr(9)/0.00789/, &
   & gstr(10)/0.00679/, gstr(11)/0.00592/, gstr(12)/0.00524/, &
   & gstr(13)/0.00468/
!
!   ****** U is a machine dependent parameter. It is the smallest
!          positive number for which 1.0 + U .GT. 1.0.
!
u = spmpar(1)
twou = 2.0*u
fouru = 4.0*u
!
!       ***     Begin block 0     ***
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
if (abs(h) .ge. fouru*abs(x)) go to 5
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
if (p5eps .ge. round) go to 15
eps = 2.0*round*(1.0 + fouru)
return
15 crash = .false.
g(1) = 1.0
g(2) = 0.5
sig(1) = 1.0
if (.not.start) go to 99
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
if (eps .lt. 16.0*sum*h*h) absh = 0.25*sqrt(eps/sum)
h = sign(amax1(absh,fouru*abs(x)),h)
hold = 0.0
k = 1
kold = 0
start = .false.
phase1 = .true.
nornd = .true.
if (p5eps .gt. 100.0*round) go to 99
nornd = .false.
do 25 l = 1,neqn
25 phi(l,15) = 0.0
99 ifail = 0
!
!       ***     End block 0     ***
!
!       ***     Begin block 1     ***
!
!   Compute coefficients of formulas for this step.  Avoid computing
!   those quantities not changed when step size is not changed.
!
!                   ***
!
100 kp1 = k + 1
kp2 = k + 2
km1 = k - 1
km2 = k - 2
!
!   ns is the number of steps taken with size h, including the current
!   one.  When k.LT.ns, no coefficients change
!
if (h .ne. hold) ns = 0
if (ns.le.kold) ns = ns + 1
nsp1 = ns + 1
if (k .lt. ns) go to 199
!
!   Compute those components of alpha(*),beta(*),psi(*),sig(*) which
!   are changed
!
beta(ns) = 1.0
realns = ns
alpha(ns) = 1.0/realns
temp1 = h*realns
sig(nsp1) = 1.0
if (k .lt. nsp1) go to 110
do 105 i = nsp1,k
   im1 = i - 1
   temp2 = psi(im1)
   psi(im1) = temp1
   beta(i) = beta(im1)*psi(im1)/temp2
   temp1 = temp2 + h
   alpha(i) = h/temp1
   reali = i
105 sig(i + 1) = reali*alpha(i)*sig(i)
110 psi(k) = temp1
!
!   Compute coefficients g(*)
!
!   Initialize V(*) and set W(*).
!
if (ns .gt. 1) go to 120
do 115 iq = 1,k
   temp3 = iq*(iq + 1)
   v(iq) = 1.0/temp3
115 w(iq) = v(iq)
go to 140
!
!   If order was raised, update diagonal part of V(*)
!
120 if (k .le. kold) go to 130
temp4 = k*kp1
v(k) = 1.0/temp4
nsm2 = ns - 2
if (nsm2 .lt. 1) go to 130
do 125 j = 1,nsm2
   i = k - j
125 v(i) = v(i) - alpha(j + 1)*v(i + 1)
!
!   Update V(*) and set W(*)
!
130 limit1 = kp1 - ns
temp5 = alpha(ns)
do 135 iq = 1,limit1
   v(iq) = v(iq) - temp5*v(iq + 1)
135 w(iq) = v(iq)
g(nsp1) = w(1)
!
!   Compute the g(*) in the work vector W(*)
!
140 nsp2 = ns + 2
if (kp1 .lt. nsp2) go to 199
do 150 i = nsp2,kp1
   limit2 = kp2 - i
   temp6 = alpha(i - 1)
   do 145 iq = 1,limit2
145   w(iq) = w(iq) - temp6*w(iq + 1)
150 g(i) = w(1)
199 continue
!
!       ***     End block 1     ***
!
!       ***     Begin block 2     ***
!
!   Predict a solution P(*), evaluate derivatives using predicted
!   solution, estimate local error at order k and errors at orders k,
!   k-1, k-2 as if constant step size were used.
!
!                   ***
!
!   Change phi to phi star
!
if (k .lt. nsp1) go to 215
do i = nsp1,k
   temp1 = beta(i)
   do 205 l = 1,neqn
205   phi(l,i) = temp1*phi(l,i)
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
   ip1 = i + 1
   temp2 = g(i)
   do 225 l = 1,neqn
      p(l) = p(l) + temp2*phi(l,i)
225   phi(l,i) = phi(l,i) + phi(l,ip1)
end do
if (nornd) go to 240
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
!   Estimate errors at orders k,k-1,k-2
!
erkm2 = 0.0
erkm1 = 0.0
erk = 0.0
do 265 l = 1,neqn
   temp3 = 1.0/wt(l)
   temp4 = yp(l) - phi(l,1)
   if (km2) 265,260,255
255 erkm2 = erkm2 + ((phi(l,km1) + temp4)*temp3)**2
260 erkm1 = erkm1 + ((phi(l,k) + temp4)*temp3)**2
265 erk = erk + (temp4*temp3)**2
if (km2) 280,275,270
270 erkm2 = absh*sig(km1)*gstr(km2)*sqrt(erkm2)
275 erkm1 = absh*sig(k)*gstr(km1)*sqrt(erkm1)
280 temp5 = absh*sqrt(erk)
err = temp5*(g(k) - g(kp1))
erk = temp5*sig(kp1)*gstr(k)
knew = k
!
!   Test if order should be lowered
!
if (km2) 299,290,285
285 if (amax1(erkm1,erkm2) .le. erk) knew = km1
go to 299
290 if (erkm1 .le. 0.5*erk) knew = km1
!
!   Test if step successful
!
299 if (err .le. eps) go to 400
!
!       ***     End block 2     ***
!
!       ***     Begin block 3     ***
!
!   The step is unsuccessful.  Restore  x, phi(*,*), psi(*) .
!   If third consecutive failure, set order to one.  If step fails more
!   than three times, consider an optimal step size.  Double error
!   tolerance and return if estimated step size is too small for machine
!   precision.
!                   ***
!
!   Restore x, phi(*,*) and psi(*)
!
phase1 = .false.
x = xold
do i = 1,k
   temp1 = 1.0/beta(i)
   ip1 = i + 1
   do 305 l = 1,neqn
305   phi(l,i) = temp1*(phi(l,i) - phi(l,ip1))
end do
if (k .lt. 2) go to 320
do 315 i = 2,k
315 psi(i - 1) = psi(i) - h
!
!   On third failure, set order to one.  Thereafter, use optimal step
!   size
!
320 ifail = ifail + 1
temp2 = 0.5
if (ifail - 3) 335,330,325
325 if (p5eps .lt. 0.25*erk) temp2 = sqrt(p5eps/erk)
330 knew = 1
335 h = temp2*h
k = knew
if (abs(h) .ge. fouru*abs(x)) go to 340
crash = .true.
h = sign(fouru*abs(x),h)
eps = eps + eps
return
340 go to 100
!
!       ***     End block 3     ***
!
!       ***     Begin block 4     ***
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
if (nornd) go to 410
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
430   phi(l,i) = phi(l,i) + phi(l,kp1)
end do
!
!   Estimate error at order k+1 unless...
!     in first phase when always raise order,
!     already decided to lower order,
!     step size not constant so estimate unreliable
!
erkp1 = 0.0
if (knew .eq. km1  .or.  k .eq. 12) phase1 = .false.
if (phase1) go to 450
if (knew .eq. km1) go to 455
if (kp1 .gt. ns) go to 460
do 440 l = 1,neqn
440 erkp1 = erkp1 + (phi(l,kp2)/wt(l))**2
erkp1 = absh*gstr(kp1)*sqrt(erkp1)
!
!   Using estimated error at order k+1, determine appropriate order
!   for next step
!
if (k .gt. 1) go to 445
if (erkp1 .ge. 0.5*erk) go to 460
go to 450
445 if (erkm1 .le. amin1(erk,erkp1)) go to 455
if (erkp1 .ge. erk  .or.  k .eq. 12) go to 460
!
!   Here erkp1 .LT. erk .LT. AMAX1(erkm1,erkm2) else order would have
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
if (phase1) go to 465
if (p5eps .ge. erk*two(k + 1)) go to 465
hnew = h
if (p5eps .ge. erk) go to 465
temp2 = k + 1
r = (p5eps/erk)**(1.0/temp2)
hnew = absh*amax1(0.5,amin1(0.9,r))
hnew = sign(amax1(hnew,fouru*abs(x)),h)
465 h = hnew
return
!
!       ***     End block 4     ***
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
   & temp3, term, w(13)
!
!   Written by L. F. Shampine and M. K. Gordon
!
!   Abstract
!
!   The methods in subroutine  step1  approximate the solution near  x
!   by a polynomial.  Subroutine  intrp  approximates the solution at
!   xout  by evaluating the polynomial there.  Information defining this
!   polynomial is passed from  step1  so  intrp  cannot be used alone.
!
!   This code is completely explained and documented in the text,
!   computer solution of ordinary differential equations,  the initial
!   value problem  by L. F. Shampine and M. K. Gordon.
!
!   Input to intrp --
!
!   The user provides storage in the calling program for the arrays in
!   the call list
!      dimension y(neqn),yout(neqn),ypout(neqn),phi(neqn,16),psi(12)
!   and defines
!      xout -- point at which solution is desired.
!   The remaining parameters are defined in  step1  and passed to  intrp
!   from that subroutine.
!
!   Output from  intrp --
!
!      yout(*) -- solution at  xout
!      ypout(*) -- derivative of solution at  xout
!   the remaining parameters are returned unaltered from their input
!   values.  Integration with  step1  may be continued.
!
data g(1)/1.0/,rho(1)/1.0/
!
hi = xout - x
ki = kold + 1
kip1 = ki + 1
!
!   Initialize W(*) for computing g(*)
!
do 5 i = 1,ki
   temp1 = i
5  w(i) = 1.0/temp1
term = 0.0
!
!   Compute g(*)
!
do 15 j = 2,ki
   jm1 = j - 1
   psijm1 = psi(jm1)
   gamma = (hi + term)/psijm1
   eta = hi/psijm1
   limit1 = kip1 - j
   do 10 i = 1,limit1
10    w(i) = gamma*w(i) - eta*w(i + 1)
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
25    ypout(l) = ypout(l) + temp3*phi(l,i)
end do
do 35 l = 1,neqn
35 yout(l) = y(l) + hi*yout(l)
return
end subroutine intrp

subroutine brkf45 (fcn,neqn,y,t,tout,tend,yp,relerr,abserr,iflag, &
   & work,iwork)
implicit none
integer, intent(inout) :: iflag, iwork(5)
integer, intent(in) :: neqn
real, intent(in) :: abserr
real, intent(inout) :: relerr, t
real, intent(in) :: tend, tout
real, intent(inout) :: work(*), y(neqn), yp(neqn)
external fcn
integer :: kf1, kf2, kf3, kf4, kf7, kh, khi, ksa, ksr, kt, kw, &
   & kwp, kx, ky1, ky2
logical :: endpnt, blkout
!
!     Block Fehlberg fourth-fifth order Runge-Kutta method advancing
!     a block of two equal steps.  The formula at the first step is
!     5(4) while at the second step it is 6(4).
!
!     Written by J.R.Cash,
!        department of mathematics,
!        imperial college,
!        south KENSINGTON, london SW7 2AZ,
!        england.
!     Modified by D. Higham and A.H. Morris.
!
!    This is a heavily revised version of rkf45 of L.F. Shampine and
!    H.A. Watts.
!    brkf45 is primarily designed to solve non-stiff and mildly stiff
!    initial value ordinary differential equations when derivative
!    evaluations are inexpensive. brkf45 uses interpolation to produce
!    output at off-step points efficiently. brkf45 should generally
!    not be used when the user is demanding high accuracy.  In such
!    cases a good Adams code will often be more efficient.
!
!***********************************************************************
! Abstract
!***********************************************************************
!
!    Subroutine  brkf45  integrates a system of neqn first order
!    ordinary differential equations of the form
!
!             DY(I)/DT = FCN(t,y(1),y(2),...,y(neqn))
!
!    Where the y(I) are known at time t.
!    Typically the subroutine is used to integrate from t to tend
!    (while returning answers at specified output points tout), but
!    it can also be used as a one-block integrator to advance the
!    solution a single block step in the direction of tend.  On return
!    the parameters in the call list are set for continuing the
!    integration. The user has only to call brkf45 again (and perhaps
!    define a new value for tout). Actually, brkf45 is an interfacing
!    routine which calls subroutine rkfc for the solution.  Subroutine
!    rkfc computes an approximate solution over one block of length 2H.
!    brkf45 is particularly useful when output is required at many
!    off-step points since the output values can be obtained by
!    interpolation.  This is in contrast to many other Runge-Kutta
!    programs which choose the step sequence so as to hit all output
!    points exactly and so become inefficient when output is required
!    at many points within a step.
!    brkf45 uses the (5,4), (6,4) block formula described in
!    J.R. Cash,  a block 6(4) Runge-Kutta formula for non-stiff
!    initial value problems, ACM Trans. Math Software 15 (1989),
!    PP. 15-28.
!
!    The parameters represent-
!      fcn -- subroutine fcn(t,y,yp) to evaluate derivatives
!              yp(i)=dy(i)/dt
!      neqn -- number of differential equations to be integrated.
!      y(*) -- approximation to the solution vector at t.
!      t -- independent variable.
!      tout -- the next point where intermediate output is
!              required.  Approximate solutions at these points
!              will be obained by interpolation.
!      tend -- end of the integration range.  This will be hit exactly.
!      yp(*) -- approximation to the derivative vector dy/DT at t.
!      relerr,abserr -- relative and absolute error tolerances for
!            local error test. At the nth point of each block (N=1,2)
!            the code requires that
!                 abs(LOCAL ERROR)/N .LE. relerr*abs(y) + abserr
!            for each component of the local error and solution vectors
!      iflag -- indicator for status of integration.
!      work(*) -- array to hold information internal to brkf45 which
!            is necessary for subsequent calls. Must be dimensioned
!            at least  6+9*neqn
!      iwork(*) -- integer array used to hold information internal to
!            brkf45 which is necessary for subsequent calls. Must be
!            dimensioned at least  5
!
!***********************************************************************
!  First call to brkf45
!***********************************************************************
!
!    The user must provide storage in his calling program for the arrays
!    in the call list  -  y(neqn) , yp(neqn) , work(6+9*neqn)
!    iwork(5), declare FCN in an external statement, supply subroutine
!    FCN(t,y,yp) and initialize the following parameters-
!
!      neqn -- number of equations to be integrated.  (neqn .GE. 1)
!      y(*) -- vector of initial conditions.
!      t -- starting point of integration , must be a variable.
!      tout -- output point at which solution, and possibly the
!              derivative, is desired.
!      tend -- end of the range of integration. If the solution is
!              required only at tend then the user should set tout=tend.
!      relerr,abserr -- relative and absolute local error tolerances
!            which must be non-negative. relerr must be a variable while
!            abserr may be a constant. The code should normally not be
!            used with relative error control smaller than about 1.E-8,
!            unless an appropriate nonzero absolute tolerance is given.
!            To avoid limiting precision difficulties the code requires
!            relerr to be larger than an internally computed relative
!            error parameter which is machine dependent. In particular,
!            pure absolute error is not permitted. If a smaller than
!            allowable value of relerr is attempted, brkf45 increases
!            relerr appropriately and returns control to the user before
!            continuing the integration.
!      iflag -- +1,-1  indicator to initialize the code for each new
!            problem. Normal input is +1. The user should set iflag=-1
!            only when one-block integrator control is essential. In
!            this case, brkf45 attempts to advance the solution A
!            single block in the direction of tend each time it is
!            called.  Since this mode of operation results in extra
!            computing overhead, it should be avoided unless needed.
!
!***********************************************************************
!  Output from brkf45
!***********************************************************************
!
!      y(*) -- computed solution approximation at t.
!      t -- value of the independent variable where the solution is
!           reported.
!      iflag = 2 -- successful return.  Either the integration reached
!                   t=tend or a successful interpolation has been
!                   performed at t=tout.  If t.EQ.tend then the
!                   integration is finished.  If not, the code should be
!                   called with the next value of tout and with iflag=+2
!                   for normal integration or iflag=-2 For one-block
!                   integration.
!            =-2 -- A single successful block in the direction of tend
!                   has been taken. Normal mode for continuing
!                   integration one block at a time.
!            = 3 -- Integration was not completed because relative error
!                   tolerance was too small. relerr has been increased
!                   appropriately for continuing.
!            = 4 -- Integration was not completed because more than
!                   18000 derivative evaluations were needed. This
!                   is approximately 2000 blocks.
!            = 5 -- Integration was not completed because solution
!                   vanished making a pure relative error test
!                   impossible. Must use non-zero abserr to continue.
!                   Using the one-block integration mode for one block
!                   is a good way to proceed.
!            = 6 -- Integration was not completed because requested
!                   accuracy could not be achieved using smallest
!                   allowable stepsize. User must increase the error
!                   tolerance before continued integration can be
!                   attempted.
!            = 7 -- Invalid input parameters
!                   this indicator occurs if any of the following is
!                   SATISFIED -   neqn .LE. 0
!                                 t = tend
!                                 relerr OR abserr .LT. 0.
!                                 abs(iflag) .LT. 1 OR .GT. 7
!      work(*),iwork(*) -- information which is usually of no interest
!                   to the user but necessary for subsequent calls.
!                   work(1),...,work(neqn) contain the solution vector
!                   and work(neqn+1),...,work(2*neqn) contain the
!                   derivative vector at the end point (which is itself
!                   contained in work(2*neqn+1)) of the block step just
!                   computed. work(2*neqn+2) contains the stepsize H
!                   just used. (This is the stepsize being used by the
!                   interpolant over this block.) work(2*neqn+3)
!                   contains the stepsize H to be attempted on the next
!                   block. iwork(1) contains the derivative evaluation
!                   counter.
!
!***********************************************************************
!  Subsequent calls to brkf45
!***********************************************************************
!
!    Subroutine brkf45 returns with all information needed to continue
!    the integration. After the code reports a successful solution at
!    tout (indicated by iflag=2), the user needs to define a new tout
!    before simply calling brkf45 again to continue in the normal mode.
!    (But the user must first reset iflag to -2 To continue in the
!    one-block integrator mode.)
!    if the integration was not completed but the user still wants to
!    CONTINUE (iflag=3,4), HE JUST CALLS brkf45 AGAIN. IN THE CASE
!    iflag=3 The relerr parameter HAS been adjusted appropriately for
!    continuing the integration. In the case of iflag=4 The function
!    counter will be reset to 0 and another 18000 function evaluations
!    are allowed.
!    However,in the case iflag=5, the user must first alter the error
!    criterion to use a positive value of abserr before integration can
!    proceed. If he does not,execution is terminated.
!    Also,in the case iflag=6, it is necessary for the user to reset
!    iflag to 2 (or -2 When the one-block integration mode is being
!    used) as well as increasing either abserr,relerr or both before
!    the integration can be continued. If this is not done, execution
!    will be terminated. The occurrence of iflag=6 Indicates a trouble
!    spot(solution is changing rapidly,singularity may be present) and
!    it often is inadvisable to continue.
!    If iflag=7 Is obtained, integration can not be continued unless
!    the invalid input parameters are corrected.
!    It should be noted that the arrays work,iwork contain information
!    required for subsequent integration. Accordingly, work and iwork
!    should not be altered.
!
!***********************************************************************
!  User calls to the interpolant routine extra
!***********************************************************************
!
!    Subroutine extra can also be called by the user, in conjunction
!    with usage of brkf45, to provide approximate solutions at off-step
!    points by use of the interpolating polynomial. While brkf45
!    handles the usual situations, it can be helpful to the user to be
!    able to access the interpolant directly, such as when doing root
!    finding. Also, it is possible that the user may have some need for
!    extrapolating outside of the block step on which the underlying
!    interpolant is based. brkf45 will not do this.
!    The form of the usage call is
!
!    call extra ( neqn, work(6*neqn+4), work(neqn+1), work(2*neqn+1),
!                work(2*neqn+2), work(2*neqn+4), work(3*neqn+4),
!                work(4*neqn+4), work(5*neqn+4), tex, YEX, YPEX )
!
!    Where YEX and YPEX are the solution vector and derivative vector
!    approximations defined by the interpolant at the point tex, and
!    work is the working array SET up by brkf45. This version of
!    extra has been written by D. Higman (see below).
!
!***********************************************************************
!  More about the interpolant routine extra
!***********************************************************************
!
!    The first derivative approximations given by J.R. Cash have been
!    modified by D. Higman. Three changes have been made and are
!    clearly documented in the code. Just search for the word *changes*.
!    For an explanation of these modifications see
!    remark on algorithm 669, by D. Higham,
!    ACM Trans. Math Software 17, PP. 424-426.
!
!***********************************************************************
!
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
!     The work space totals  6 + 9*neqn .
!
if (iabs(iflag) .eq. 1) go to 10
endpnt = (iwork(4) .eq. -1)
blkout = (iwork(5) .eq. -1)
!
!***********************************************************************
!     This interfacing routine merely relieves the user of a long
!     calling list via the splitting apart of two working storage
!     arrays. If this is not compatible with the users compiler,
!     he must use rkfc directly.
!***********************************************************************
!
10 call rkfc (fcn,neqn,y,t,tout,tend,yp,relerr,abserr,iflag,work(kw), &
   & work(kwp),work(kx),work(khi),work(kh),work(ky1),work(ky2), &
   & work(kf1),work(kf2),work(kf3),work(kf4),work(kf7),work(ksr), &
   & work(ksa),work(kt),iwork(1),iwork(2),iwork(3),endpnt,blkout)
!
iwork(4) = 0
if (endpnt) iwork(4) = -1
iwork(5) = 0
if (blkout) iwork(5) = -1
!
return
end subroutine brkf45

subroutine rkfc (fcn,neqn,y,t,tout,tend,yp,relerr,abserr,iflag, &
   & w,wp,x,hint,h,y1,y2,f1,f2,f3,f4,f7,savre,savae, &
   & told,nfe,jflag,kflag,endpnt,blkout)
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
   & y2(neqn), yp(neqn)
logical, intent(inout) :: endpnt
logical, intent(inout) :: blkout
external fcn
integer :: k, maxnfe, mflag, n
real :: a, a21, a31, a32, a41, a42, a43, a51, a52, a53, a54, a61, &
   & a62, a63, a64, a65, a81, a82, a83, a84, a85, a86, a87, a91, a92, &
   & a93, a94, a95, a96, a97, a98, ae, b1, b1b, b3, b3b, b4, b4b, b5, &
   & b5b, b6, b6b, b7, b8, b9, c2, c3, c4, c6, c8, c9, dt, dtsign, ee, &
   & eeoet, erc11, erc13, erc14, erc15, erc21, erc23, erc24, erc25, &
   & erc26, erc27, erc28, erc29, errtol, esttol, ez, hmin, hstop, &
   & remin, rer, s, scale, sf, swap, tol, toler, toln, u, u26, ypk
real :: spmpar
logical :: hfaild
logical :: interp
!
!     Two step block Runge-Kutta Fehlberg method.
!     A standard 5(4) formula is used at the first point in the block
!     and A 6(4) formula is used at the second point.
!
!
!***********************************************************************
!
!     Coefficients defining the method ...
!
!                c2=0.25e+0
!                c3=3.0e+0/8.0e+0
!                c4=12.0e+0/13.0e+0
!                c6=0.5e+0
!                c8=3.0e+0/2.0e+0
!                c9=2.0e+0
!
!                a21=1.0e+0/4.0e+0
!                a31=3.0e+0/32.0e+0
!                a32=9.0e+0/32.0e+0
!                a41=1932.0e+0/2197.0e+0
!                a42=-7200.0e+0/2197.0e+0
!                a43=7296.0e+0/2197.0e+0
!                a51=439.0e+0/216.0e+0
!                a52=-8.0e+0
!                a53=3680.0e+0/513.0e+0
!                a54=-845.0e+0/4104.0e+0
!                a61=-8.0e+0/27.0e+0
!                a62=2.0e+0
!                a63=-3544.0e+0/2565.0e+0
!                a64=1859.0e+0/4104.0e+0
!                a65=-11.0e+0/40.0e+0
!
!                b1b=16.0e+0/135.0e+0
!                b3b=6656.0e+0/12825.0e+0
!                b4b=28561.0e+0/56430.0e+0
!                b5b=-9.0e+0/50.0e+0
!                b6b=2.0e+0/55.0e+0
!
!                erc11=1.0e+0/360.0e+0
!                erc13=-128.0e+0/4275.0e+0
!                erc14=-2197.0e+0/75240.0e+0
!                erc15=1.0e+0/50.0e+0
!
data c2 /.250000000000000e+00/, c3 /.375000000000000e+00/, &
   & c4 /.923076923076923e+00/, c6 /.500000000000000e+00/, &
   & c8 /.150000000000000e+01/, c9 /.200000000000000e+01/
!
data a21 / .250000000000000e+00/, a31 / .937500000000000e-01/, &
   & a32 / .281250000000000e+00/, a41 / .879380974055530e+00/, &
   & a42 /-.327719617660446e+01/, a43 / .332089212562585e+01/, &
   & a51 / .203240740740741e+01/, a52 /-.800000000000000e+01/, &
   & a53 / .717348927875244e+01/, a54 /-.205896686159844e+00/, &
   & a61 /-.296296296296296e+00/, a62 / .200000000000000e+01/, &
   & a63 /-.138167641325536e+01/, a64 / .452972709551657e+00/, &
   & a65 /-.275000000000000e+00/
!
data b1b /.118518518518519e+00/, b3b / .518986354775828e+00/, &
   & b4b /.506131490342017e+00/, b5b /-.180000000000000e+00/, &
   & b6b /.363636363636364e-01/
!
data erc11/ .277777777777778e-02/, erc13/-.299415204678363e-01/, &
   & erc14/-.291998936735779e-01/, erc15/ .200000000000000e-01/
!
!     The above define the coefficients for brkf45 used to generate
!     the solution at the first block point. Below are additional
!     coefficients needed to generate the solution at the second block
!     point.
!
!                b1=931.0e+0/6480.0e+0
!                b3=315392.0e+0/1500525.0e+0
!                b4=371293.0e+0/615600.0e+0
!                b5=1.0e+0/50.0e+0
!                b6=0.4e+0
!                b7=-4.0e+0/15.0e+0
!                b8=85006.0e+0/115425.0e+0
!                b9=239.0e+0/1560.0e+0
!
!                a81=-119397029895.0e+0/151948225000.0e+0
!                a82=78390.0e+0/29081.0e+0
!                a83=-51517464.0e+0/132821875.0e+0
!                a84=-3780749193.0e+0/1168832500.0e+0
!                a85=79268193.0e+0/55925000.0e+0
!                a86=-11370591.0e+0/15379375.0e+0
!                a87=5670.0e+0/2237.0e+0
!
!                a91=23406188597.0e+0/8429231250.0e+0
!                a92=-62928.0e+0/13623.0e+0
!                a93=-31066887488.0e+0/5747203125.0e+0
!                a94=164486461399.0e+0/8429231250.0e+0
!                a95=-70336084.0e+0/11203125.0e+0
!                a96=185680664.0e+0/24646875.0e+0
!                a97=-3385330161.0e+0/243117160.0e+0
!                a98=232648.0e+0/96795.0e+0
!
data b1 /.143672839506173e+00/, b3 / .210187767614668e+00/, &
   & b4 /.603140025990903e+00/, b5 / .200000000000000e-01/, &
   & b6 /.400000000000000e+00/, b7 /-.266666666666667e+00/, &
   & b8 /.736460905349794e+00/, b9 / .153205128205128e+00/
!
data a81 /-.785774430040232e+00/, a82 / .269557443004023e+01/, &
   & a83 /-.387868820553843e+00/, a84 /-.323463729234086e+01/, &
   & a85 / .141740175234689e+01/, a86 /-.739340252773601e+00/, &
   & a87 / .253464461332141e+01/
!
data a91 / .277678804896947e+01/, a92 /-.461924686192469e+01/, &
   & a93 /-.540556629238679e+01/, a94 / .195138152603181e+02/, &
   & a95 /-.627825575453278e+01/, a96 / .753363921389629e+01/, &
   & a97 /-.139246861924514e+02/, a98 / .240351257812904e+01/
!
!     Next we define coefficients for the error estimate formula.
!
!     b3e = 1067091077380.0e+0/1829119027671.0e+0
!     b4e = 3284168845918.0e+0/21339721989495.0e+0
!     b5e = 110317750789.0e+0/240996319200.0e+0-
!    *      4448925830089.0E+0/12329617149531.0E+0
!     b6e = 1.0e+0/25.0e+0
!     b7e = 0.2e+0
!     b8e = 239992027043.0e+0/361494478800.0e+0
!     b9e = 1273.0e+0/7800.0e+0
!     b1e = 2.0e+0-b3e-b4e-b5e-b6e-b7e-b8e-b9e
!
!     erc21 = (b1-b1e)/2.0e+0
!     erc23 = (b3-b3e)/2.0e+0
!     erc24 = (b4-b4e)/2.0e+0
!     erc25 = (b5-b5e)/2.0e+0
!     erc26 = 9.0e+0/50.0e+0
!     erc27 = -7.0e+0/30.0e+0
!     erc28 = (b8 - b8e)/2.0e+0
!     erc29 = -0.005e+0
!
data erc21 /.224905375494686e-01/, erc23 /-.186601479161668e+00/, &
   & erc24 /.224620349650851e+00/, erc25 /-.384622777202128e-01/, &
   & erc26 /.180000000000000e+00/, erc27 /-.233333333333333e+00/, &
   & erc28 /.362862030148937e-01/, erc29 /-.500000000000000e-02/
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
!     of function evaluations to be approximately maxnfe.
!
data maxnfe / 18000 /
!
!***********************************************************************
!
!  The computer unit roundoff error U is the smallest positive value
!  representable in the machine such that  1 + U .GT. 1.
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
if (sign(1.0, tend - t) .ne. sign(1.0, tout - t)) go to 500
go to 70
10 if (mflag .eq. 0 .or. mflag .gt. 7) go to 500
if (tout .eq. told) go to 20
if (sign(1.0, tend - told) .ne. sign(1.0, tout - told)) go to 500
!
!     Check continuation possibilities
!
20 if (mflag .ne. 2) go to 30
!
!     iflag = +2 or -2
!
if (kflag .lt. 3) go to 70
if (kflag .eq. 3) go to 60
if (kflag .eq. 4) go to 50
if (kflag .eq. 5 .and. abserr .eq. 0.0) go to 40
if (kflag .eq. 6 .and. relerr .le. savre .and. abserr .le. savae) &
   & go to 40
go to 70
!
!     iflag = 3,4,5,6 or 7
!
30 if (iflag .eq. 3) go to 60
if (iflag .eq. 4) go to 50
if (iflag .eq. 5 .and. abserr .gt. 0.0) go to 60
!
!     Integration cannot be continued since user did not respond to
!     the instructions pertaining to iflag=5,6 or 7
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
!     Save input iflag and set continuation flag VALUE for subsequent
!     input checking
!
70 jflag = iflag
kflag = 0
!
!     Save relerr and abserr for checking input on subsequent calls
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
!                       define integration independent variable x
!                       evaluate initial derivatives
!                       set up working arrays for integration variables
!                       set counter for function evaluations,nfe
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
dtsign = sign(1.0, tend - t)
!
!     Have we already integrated past the present data output point?
!     If so jump to 390 and perform interpolation.
!     If not, see if we have reached the end point of integration.
!     If not, see if results at the end of the block step need to be
!     reported.
!
if ((tout - t)*dtsign .gt. 0.0) go to 110
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
150 if (abs(tend - t) .gt. u26*abs(t)) go to 190
if (dtsign*(tend - tout) .le. 0.0) go to 160
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
hstop = 0.5*(tend - t)
if (abs(hstop) .gt. abs(h)) go to 200
endpnt = .true.
h = hstop
!
!***********************************************************************
!     Core integrator for a single block
!***********************************************************************
!     The tolerances have been scaled to avoid premature underflow in
!     computing the error tolerance function errtol.
!     To avoid problems with zero crossings,relative error is measured
!     using the average of the magnitudes of the solution at the
!     beginning and end  points of a block.
!     To distinguish the various arguments, h is not permitted
!     to become smaller than 26 units of roundoff in t.
!     Practical limits on the change in the stepsize are enforced to
!     smooth the stepsize selection process and to avoid excessive
!     chattering on problems having discontinuities.
!***********************************************************************
!
!     Test number of derivative function evaluations.
!     If okay,try to advance the integration from t to t+h
!
200 if (nfe .gt. maxnfe) go to 530
!
!     Advance an approximate solution over one step of length h
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
   y1(n) = w(n) + h*(a51*wp(n) + a52*f2(n) + a53*f3(n) + a54*f4(n))
end do
call fcn (t + h, y1, y)
do n = 1, neqn
   y1(n) = w(n) + h*(a61*wp(n) + a62*f2(n) + a63*f3(n) + a64*f4(n) + &
      & a65*y(n))
end do
call fcn (t + c6*h, y1, yp)
nfe = nfe + 5
eeoet = 0.0
do n = 1, neqn
   y1(n) = w(n) + h*(b1b*wp(n) + b3b*f3(n) + b4b*f4(n) + b5b*y(n) + &
      & b6b*yp(n))
   errtol = abs(w(n)) + abs(y1(n)) + ae
   if (errtol .le. 0.0) go to 540
   ez = abs(h*(erc11*wp(n) + erc13*f3(n) + erc14*f4(n) + erc15*y(n) + &
      & b6b*yp(n)))
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
   y2(n) = w(n) + h*(a81*wp(n) + a82*f2(n) + a83*f3(n) + a84*f4(n) + &
      & a85*y(n) + a86*yp(n) + a87*f1(n))
end do
call fcn (t + c8*h, y2, f7)
do n = 1, neqn
   y2(n) = w(n) + h*(a91*wp(n) + a92*f2(n) + a93*f3(n) + a94*f4(n) + &
      & a95*y(n) + a96*yp(n) + a97*f1(n) + a98*f7(n))
end do
call fcn (t + c9*h, y2, f2)
nfe = nfe + 3
eeoet = 0.0
do n = 1, neqn
   ee = abs(h*(erc21*wp(n) + erc23*f3(n) + erc24*f4(n) + erc25*y(n) + &
      & erc26*yp(n) + erc27*f1(n) + erc28*f7(n) + erc29*f2(n)))
   y2(n) = w(n) + h*(b1*wp(n) + b3*f3(n) + b4*f4(n) + b5*y(n) + b6*yp(n) + &
      & b7*f1(n) + b8*f7(n) + b9*f2(n))
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
   y1(n) = b1b*wp(n) + b3b*f3(n) + b4b*f4(n) + b5b*y(n) + &
      & b6b*yp(n)
   f3(n) = b1*wp(n) + b3*f3(n) + b4*f4(n) + b5*y(n) + b6*yp(n) + &
      & b7*f1(n) + b8*f7(n) + b9*f2(n)
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
!     Store solution at t+2*h.
!
330 t = t + 2.0*h
if (endpnt) t = tend
told = x
x = t
hint = h
interp = .false.
if ((t - tout)*dtsign .ge. 0.0) interp = .true.
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
!     If so, call the interpolation routine at t=tout.
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

subroutine rkf45 (f,neqn,y,t,tout,relerr,abserr,iflag,work,iwork)
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
real :: a, ae, dt, ee, eeoet, esttol, et, hmin, remin, rer, s, &
   & scale, tol, toln, u26, eps, ypk, spmpar
integer :: k, maxnfe, mflag
!
!
!
!
!
!     remin is the minimum acceptable value of relerr.  Attempts
!     to obtain higher accuracy with this subroutine are usually
!     very expensive and often unsuccessful.
!
data remin/1.e-12/
!
!     The expense is controlled by restricting the number
!     of function evaluations to be approximately maxnfe.
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
!     iflag = +2 or -2
!
if (kflag .eq. 3) go to 45
if (init .eq. 0) go to 45
if (kflag .eq. 4) go to 40
if ((kflag .eq. 5)  .and.  (abserr .eq. 0.0)) go to 30
if ((kflag .eq. 6)  .and.  (relerr .le. savre)  .and. &
   & (abserr .le. savae)) go to 30
go to 50
!
!     iflag = 3,4,5,6,7 or 8
!
25 if (iflag .eq. 3) go to 45
if (iflag .eq. 4) go to 40
if (iflag .eq. 5 .and. abserr .gt. 0.0) go to 45
!
!     Integration cannot be continued since user did not respond to
!     the instructions pertaining to iflag=5,6,7 or 8
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
!                       set counter for function evaluations,nfe
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
   if (ypk*h**5 .gt. tol) h = (tol/ypk)**0.2
70 continue
if (toln .le. 0.0) h = 0.0
h = amax1(h,u26*amax1(abs(t),abs(dt)))
jflag = isign(2,iflag)
!
!     Set stepsize for integration in the direction from t to tout
!
80 h = sign(h,dt)
!
!     Test to see if rkf45 is being severely impacted by too many
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
200 if (nfe .le. maxnfe) go to 220
!
!     Too much work
!
iflag = 4
kflag = 4
return
!
!     Advance an approximate solution over one step of length h
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
240 ee = abs((-2090.0*yp(k) + (21970.0*f3(k) - 15048.0*f4(k))) + &
      & (22528.0*f2(k) - 27360.0*f5(k)))
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
if (esttol .gt. 1.889568e-4) s = 0.9/esttol**0.2
if (hfaild) s = amin1(s,1.0)
h = sign(amax1(s*abs(h),hmin),h)
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
real :: spmpar
logical :: hfaild, output
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
if (neqn .lt. 1) go to 10
if ((relerr .lt. 0.)  .or.  (abserr .lt. 0.)) go to 10
mflag = iabs(iflag)
if ((mflag .ge. 1)  .and.  (mflag .le. 7)) go to 20
!
!     Invalid input
10 iflag = 7
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
!     iflag = +2 or -2
if (init .eq. 0) go to 45
if (kflag .eq. 3) go to 40
if ((kflag .eq. 4)  .and.  (abserr .eq. 0.)) go to 30
if ((kflag .eq. 5)  .and.  (relerr .le. savre)  .and. &
   & (abserr .le. savae)) go to 30
go to 50
!
!     iflag = 3,4,5,6, or 7
25 if (iflag .eq. 3) go to 40
if ((iflag .eq. 4) .and. (abserr .gt. 0.)) go to 45
!
!     Integration cannot be continued since user did not respond to
!     the instructions pertaining to iflag=4,5,6 or 7
30 stop
!
!***********************************************************************
!
!     Reset function evaluation counter
40 nfe = 0
if (mflag .eq. 2) go to 50
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
rer = amax1(relerr,32.*u + remin)
!
u26 = 26.*u
!
dt = tout - t
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
!                       set counter for function evaluations,nfe
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
!
65 init = 1
h = abs(dt)
toln = 0.
do 70 k = 1,neqn
   yg(k) = y(k)
   ygp(k) = yp(k)
   tol = rer*abs(y(k)) + abserr
   if (tol .le. 0.) go to 70
   toln = tol
   ypk = abs(yp(k))
   if (ypk*h**5 .gt. tol) h = (tol/ypk)**0.2
70 continue
if (toln .le. 0.) h = 0.
h = amax1(h,u26*amax1(abs(t),abs(dt)))
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
if (abs(h) .gt. 2.*abs(dt)) kop = kop + 1
if (kop .ne. 100) go to 85
kop = 0
iflag = 6
return
!
85 if (abs(dt) .gt. u26*abs(t)) go to 95
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
if (abs(dt) .ge. 2.*abs(h)) go to 200
if (abs(dt) .gt. abs(h)) go to 150
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
200 if (nfe .le. maxnfe) go to 220
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
   if (et .gt. 0.) go to 240
!
!       Inappropriate error tolerance
   iflag = 4
   kflag = 4
   return
!
240 ee = abs((-2090.*ygp(k) + (21970.*f3(k) - 15048.*f4(k))) + &
      & (22528.*f2(k) - 27360.*f5(k)))
250 eeoet = amax1(eeoet,ee/et)
!
esttol = abs(h)*eeoet*scale/752400.
!
if (esttol .le. 1.) go to 260
!
!
!     Unsuccessful step
!                       reduce the stepsize , try again
!                       the decrease is limited to a factor of 1/10
!
hfaild = .true.
output = .false.
s = 0.1
if (esttol .lt. 59049.) s = 0.9/esttol**0.2
h = s*h
if (abs(h) .gt. hmin) go to 200
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
if (esttol .gt. 1.889568e-4) s = 0.9/esttol**0.2
if (hfaild) s = amin1(s,1.)
h = sign(amax1(s*abs(h),hmin),h)
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

subroutine sfode (f,neq,y,t,tout,info,rerr,aerr,idid, &
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
call stfode (f,neq,y,t,tout,info1,rtol,atol,idid, &
   & rwork,lrw,iwork,liw,rpar,ipar,zzzjac)
info(1) = info1(1)
rerr = rtol(1)
aerr = atol(1)
return
end subroutine sfode

subroutine sfode1 (f,neq,y,t,tout,info,rtol,atol,idid, &
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
call stfode (f,neq,y,t,tout,info1,rtol,atol,idid, &
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

subroutine stfode (f,neq,y,t,tout,info,rtol,atol,idid, &
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
   & mu .ge. 0  .and.  mu .lt. neq) go to 80
idid = -40
return
!
!     Check lrw and liw for sufficient storage allocation
!
80 if (lrw .ge. 250 + (10 + ilrw)*neq) go to 100
!
if (info(6) .eq. 1) go to 90
idid = -41
return
!
90 idid = -42
return
!
100 if (liw .ge. 55 + neq) go to 200
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

