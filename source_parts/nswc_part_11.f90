function vnorm(v,ncomp)
implicit none
integer, intent(in) :: ncomp
real :: v(ncomp)
real :: vnorm
!     beginning of local variable declarations
integer :: k
!     Compute the maximum norm of the vector v(*) of length ncomp and
!     RETURN THE RESULT AS vnorm
vnorm = 0.
do k = 1,ncomp
   vnorm = max(vnorm,abs(v(k)))
end do
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
!     beginning of local variable declarations
integer :: i
real :: sum
sum = 0.0e0
do i = 1,n
   sum = sum + (v(i)/w(i))**2
end do
vnwrms = sqrt(sum/float(n))
!----------------------- End of function vnwrms ------------------------
end function vnwrms

subroutine rk(n,t,h,a,f)
implicit none
integer, intent(in) :: n
real, intent(inout) :: a(*)
real, intent(in) :: h
real, intent(inout) :: t
external f
!     beginning of local variable declarations
integer :: k, m, m1, mk, nk, np1
real :: ha, ta
!     ******************************************************************
!     Fourth order Runge-Kutta procedure for solving DY=F(t,Y)
!     ******************************************************************
np1 = n + 1
if (h == 0.0) go to 50
ha = .5*h
ta = t + ha
m = n + n
m1 = m + 1
do k = 1,n
   nk = n + k
   mk = m + k
   a(nk) = ha*a(nk)
   a(mk) = a(k) + a(nk)
end do
call f(ta,a(m1))
do k = 1,n
   nk = n + k
   mk = m + k
   a(nk) = a(nk) + h*a(mk)
   a(mk) = a(k) + ha*a(mk)
end do
call f(ta,a(m1))
t = t + h
do k = 1,n
   nk = n + k
   mk = m + k
   a(mk) = h*a(mk)
   a(nk) = a(nk) + a(mk)
   a(mk) = a(k) + a(mk)
end do
call f(t,a(m1))
do k = 1,n
   nk = n + k
   mk = m + k
   a(k) = a(k) + (a(nk) + ha*a(mk))/3.0
   a(nk) = a(k)
end do
call f(t,a(np1))
return
50 do k = 1,n
   nk = n + k
   a(nk) = a(k)
end do
call f(t,a(np1))
end subroutine rk

subroutine rk8(n,t,h,y,dy,w,f)
implicit none
integer, intent(in) :: n
real :: h
real, intent(inout) :: t
real, intent(inout) :: y(n), dy(n), w(*)
external f
!     beginning of local variable declarations
integer :: i, j, k, l, m, m1
real :: ha, sum, b(8,7)
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
do k = 1,n
   w(k) = y(k) + ha*dy(k)
end do
call f(t + ha,w(1))
do k = 1,n
   w(k) = y(k) + h*(dy(k)/18. + w(k)/6.)
end do
call f(t + h*2./9.,w(1))
i = 1
do m = 2,8
   i = i + n
   m1 = m - 1
   do k = 1,n
      sum = b(1,m1)*dy(k)
      l = k
      do j = 2,m
         sum = sum + b(j,m1)*w(l)
         l = l + n
      end do
      w(l) = y(k) + sum*h/c(m1)
   end do
   call f(t + a(m1)*h,w(i))
end do
do k = 1,n
   sum = d(1)*dy(k)
   l = k
   do m = 2,9
      sum = sum + d(m)*w(l)
      l = l + n
   end do
   y(k) = y(k) + h*sum/840.
   dy(k) = y(k)
end do
t = t + h
call f(t,dy)
return
40 do k = 1,n
   dy(k) = y(k)
end do
call f(t,dy)
end subroutine rk8

subroutine sepde(cofx, cofy, g, edge, bval, iord, a, b, mp1, &
   & c, d, np1, u, ku, w, nw, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: iord
integer :: ku, mp1
integer, intent(in) :: np1
integer, intent(inout) :: nw
real :: a, b, c, d
real :: g
real :: bval
real, intent(inout) :: u(ku,np1), w(nw)
integer, intent(in) :: edge(4)
external cofx, cofy
!     beginning of local variable declarations
integer :: i, ia, ib, ic, id, ij, imax, imin, indx, indy, iw, j, &
   & jcol, jmax, jmin, l, m, mn, n
real :: alpha, beta, del, gam, hx, hy, p, xi, xmin, yj, ymin, dum(1)
! ----------------------------------------------------------------------
!     Solution of separable elliptic partial differential equations
!                     on rectangular domains
! ----------------------------------------------------------------------
!     --------------
data alpha/0.0/, beta/0.0/, gam/0.0/, del/0.0/
!     --------------
call pdedge(edge, indx, indy, ierr)
if (ierr /= 0) return
if (a >= b .or. c >= d) go to 300
if (mp1 < 7) go to 320
if (np1 < 6) go to 330
m = mp1 - 1
n = np1 - 1
hx = (b - a)/float(m)
hy = (d - c)/float(n)
!     Define the maximum and minimum row and column
!     that is needed for the right-hand side matrix
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
!     Define the right-hand side matrix for iord = 2
if (ku < mp1) go to 310
if (iord /= 2) go to 40
mn = 0
yj = ymin
do j = jmin,jmax
   xi = xmin
   do i = imin,imax
      u(i,j) = g(xi, yj)
      xi = xi + hx
   end do
   yj = yj + hy
end do
go to 60
!     Define the right-hand side matrix for iord = 4
40 if (iord /= 4) go to 340
mn = mp1*np1
if (mn >= nw) go to 100
yj = ymin
do j = jmin,jmax
   xi = xmin
   do i = imin,imax
      ij = i + jcol
      w(ij) = g(xi, yj)
      xi = xi + hx
   end do
   yj = yj + hy
   jcol = jcol + mp1
end do
!     Store the boundary values of u
60 if (edge(1) /= 0) go to 70
xi = a
do i = 1,mp1
   u(i,1) = bval(1,xi,c)
   xi = xi + hx
end do
70 if (edge(2) /= 0) go to 80
yj = c
do j = 1,np1
   u(1,j) = bval(2,a,yj)
   yj = yj + hy
end do
80 if (edge(3) /= 0) go to 90
xi = a
do i = 1,mp1
   u(i,np1) = bval(3,xi,d)
   xi = xi + hx
end do
90 if (edge(4) /= 0) go to 100
yj = c
do j = 1,np1
   u(mp1,j) = bval(4,b,yj)
   yj = yj + hy
end do
!     Store the mixed boundary conditions
100 ic = mn + 1
if (edge(1) /= 1) go to 120
mn = mn + mp1
if (mn >= nw) go to 120
xi = a
l = ic
do i = 1,mp1
   w(l) = bval(1,xi,c)
   xi = xi + hx
   l = l + 1
end do
120 ia = mn + 1
if (edge(2) /= 1) go to 140
mn = mn + np1
if (mn >= nw) go to 140
yj = c
l = ia
do j = 1,np1
   w(l) = bval(2,a,yj)
   yj = yj + hy
   l = l + 1
end do
140 id = mn + 1
if (edge(3) /= 1) go to 160
mn = mn + mp1
if (mn >= nw) go to 160
xi = a
l = id
do i = 1,mp1
   w(l) = bval(3,xi,d)
   xi = xi + hx
   l = l + 1
end do
160 ib = mn + 1
if (edge(4) /= 1) go to 200
mn = mn + np1
if (mn >= nw) go to 200
yj = c
l = ib
do j = 1,np1
   w(l) = bval(4,b,yj)
   yj = yj + hy
   l = l + 1
end do
!     CALL THE DIFFERENTIAL EQUATION SOLVER
200 if (mn >= nw) go to 350
iw = mn + 1
w(iw) = nw - mn
if (iord == 4) go to 210
call sepell(0, iord, a, b, m, indx, w(ia), alpha, w(ib), beta, &
   & c, d, n, indy, w(ic), gam, w(id), del, cofx, cofy, &
   & u, ku, u, ku, w(iw), p, ierr)
go to 220
210 call sepell(0, iord, a, b, m, indx, w(ia), alpha, w(ib), beta, &
   & c, d, n, indy, w(ic), gam, w(id), del, cofx, cofy, &
   & w(1),mp1, u, ku, w(iw), p, ierr)
220 nw = w(iw) + mn
if (ierr /= 0) return
if (p == 0.0) return
ierr = -1
w(1) = p
return
!     Error return
300 ierr = 1
return
310 ierr = 5
return
320 ierr = 6
return
330 ierr = 7
return
340 ierr = 8
return
350 dum(1) = 1.0
call sepell(0, iord, a, b, m, indx, dum, alpha, dum, beta, &
   & c, d, n, indy, dum, gam, dum, del, cofx, cofy, &
   & u, ku, u, ku, dum, p, ierr)
nw = dum(1) + mn
end subroutine sepde

pure subroutine pdedge(edge, indx, indy, ierr)
implicit none
integer, intent(inout) :: ierr, indx, indy
integer, intent(in) :: edge(4)
!     beginning of local variable declarations
integer :: nswc_ai_i4
if (abs(edge(1)) > 1) go to 200
if (abs(edge(2)) > 1) go to 200
if (abs(edge(3)) > 1) go to 200
if (abs(edge(4)) > 1) go to 200
ierr = 0
!               Process edges 1 and 3
nswc_ai_i4 = edge(1)
if (nswc_ai_i4 < 0) go to 10
if (nswc_ai_i4 == 0) go to 20
go to 30
10 if (edge(3) /= -1) go to 210
indy = 0
go to 100
20 if (edge(3) == -1) go to 210
indy = 1 + edge(3)
go to 100
30 if (edge(3) == -1) go to 210
indy = 4 - edge(3)
!               Process edges 2 and 4
100 nswc_ai_i4 = edge(2)
if (nswc_ai_i4 < 0) go to 110
if (nswc_ai_i4 == 0) go to 120
go to 130
110 if (edge(4) /= -1) go to 220
indx = 0
return
120 if (edge(4) == -1) go to 220
indx = 1 + edge(4)
return
130 if (edge(4) == -1) go to 220
indx = 4 - edge(4)
return
!                   Error return
200 ierr = 2
return
210 ierr = 12
return
220 ierr = 13
end subroutine pdedge

subroutine sepell(intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c, &
   & d,n,nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,grhs,mn, &
   & usol,idmn,w,pertrb,ierror)
implicit none
integer :: idmn
integer, intent(inout) :: ierror
integer, intent(in) :: intl, iorder, m, mbdcnd
integer :: mn
integer, intent(in) :: n, nbdcnd
real, intent(in) :: a, alpha, b, beta, c, d, gama
real, intent(inout) :: pertrb
real, intent(in) :: xnu
real, intent(inout) :: grhs(mn,*), usol(idmn,*)
real :: bda(*), bdb(*), bdc(*), bdd(*)
real, intent(inout) :: w(*)
external cofx, cofy
!     beginning of local variable declarations
integer :: i1, i10, i11, i12, i13, i2, i3, i4, i5, i6, i7, i8, i9, &
   & k, l, length, linput, ll, logb2n, loutpt
! DIMENSION OF           bda(n+1), bdb(n+1), bdc(m+1), bdd(m+1),
! ARGUMENTS              usol(idmn,n+1), grhs(mn,n+1),
!                        w (see argument list)
! LATEST REVISION        JANUARY 1978 (BY THE AUTHORS)
!                        modified 1986 by A.H. Morris (NSWC)
! PURPOSE                sepell SOLVES FOR EITHER THE SECOND-ORDER
!                        finite difference approximation or A
!                        fourth-order approximation to a separable
!                        elliptic equation
!                                    2    2
!                             AF(X)*d U/DX + BF(X)*DU/DX  + CF(X)*U +
!                                    2    2
!                             DF(Y)*d U/DY  + EF(Y)*DU/DY + FF(Y)*U
!                             = G(X,Y)
!                        on a rectangle (X greater than or equal to A
!                        and less than or equal to b, Y greater than
!                        or equal to c and less than or equal to d).
!                        Any combination of periodic or mixed boundary
!                        conditions is allowed.
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
!                        in the Y-direction..
!                         (0) Periodic, U(X,Y+d-c)=U(X,Y) for all X,Y
!                         (1) U(X,c),U(X,d) are specified for all X
!                         (2) U(X,c),DU(X,d)/DY+xnu*U(X,d) are specified
!                             for all X
!                         (3) DU(X,c)/DY+gama*U(X,c),DU(X,d)/DY+
!                             xnu*U(X,d) are specified for all X
!                         (4) DU(X,c)/DY+gama*U(X,c),U(X,d) are
!                             specified for all X
! arguments
! ON INPUT               INTL
!                          = 0 On initial entry to sepell or if any of
!                              the arguments c, d, n, nbdcnd, COFY are
!                              changed from a previous call
!                          = 1 IF c, d, n, nbdcnd, COFY ARE UNCHANGED
!                              from the previous call.
!                        iorder
!                          = 2 If a second-order approximation is sought
!                          = 4 If a fourth-order approximation is sought
!                        A,b
!                          the range of the X-independent variable,
!                          I.E., X is greater than or equal to A and
!                          less than or equal to b. A must be less than
!                          b.
!                        m
!                          the number of panels into which the interval
!                          (A,b) is subdivided.  Hence, there will be
!                          m+1 grid points in the X-direction given by
!                          XI=a+(I-1)*DLX FOR I=1,2,...,m+1 WHERE
!                          DLX=(b-a)/m is the panel width.  m must be
!                          less than idmn and greater than 5.
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
!                        bda
!                          a one-dimensional array of length n+1 that
!                          specifies the values of DU(a,Y)/DX+
!                          alpha*U(a,Y) AT X=a. WHEN mbdcnd=3 OR 4
!                               bda(j) = du(a,yj)/dx+alpha*u(a,yj),
!                               j=1,2,...,n+1.
!                          When mbdcnd has any other value, bda is A
!                          dummy parameter.
! ON INPUT               alpha
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at X=a (see
!                          argument bda). If mbdcnd.NE.3,4 then alpha
!                          is a dummy parameter.
!                        bdb
!                          a one-dimensional array of length n+1 that
!                          specifies the values of DU(b,Y)/DX+
!                          beta*U(b,Y) AT X=b.  WHEN mbdcnd=2 OR 3
!                               bdb(j) = du(b,yj)/dx+beta*u(b,yj),
!                               j=1,2,...,n+1.
!                          When mbdcnd has any other value, bdb is A
!                          dummy parameter.
!                        beta
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at X=b (see
!                          argument bdb). If mbdcnd.NE.2,3 then beta is
!                          a dummy parameter.
!                        c,d
!                          the range of the Y-independent variable,
!                          I.E., Y is greater than or equal to c and
!                          less than or equal to d.  c must be less
!                          THAN d.
!                        n
!                          the number of panels into which the interval
!                          (c,d) is subdivided.  Hence, there will be
!                          n+1 grid points in the Y-direction given by
!                          YJ=c+(J-1)*DLY FOR J=1,2,...,n+1 WHERE
!                          DLY=(d-c)/n is the panel width. In addition,
!                          n must be greater than 4.
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
!                        bdc
!                          a one-dimensional array of length m+1 that
!                          specifies the value of DU(X,c)/DY+gama*U(X,c)
!                          AT Y=c.  WHEN nbdcnd=3 OR 4
!                             bdc(i) = du(xi,c)/dy + gama*u(xi,c),
!                             i=1,2,...,m+1.
!                          When nbdcnd has any other value, bdc is A
!                          dummy parameter.
!                        Gama
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at Y=c (see
!                          argument bdc). If nbdcnd.NE.3,4 then gama is
!                          a dummy parameter.
!                        bdd
!                          a one-dimensional array of length m+1 that
!                          specifies the value of DU(X,d)/DY +
!                          xnu*U(X,d) AT Y=c.  WHEN nbdcnd=2 OR 3
!                            bdd(i) = du(xi,d)/dy + xnu*u(xi,d),
!                            i=1,2,...,m+1.
!                          When nbdcnd has any other value, bdd is A
!                          dummy parameter.
!                        xnu
!                          the scalar multiplying the solution in case
!                          of a mixed boundary condition at Y=d (see
!                          ARGUMENT bdd). IF nbdcnd.NE.2 OR 3 THEN xnu
!                          is a dummy parameter.
!                        COFX
!                          a user-supplied subprogram with
!                          PARAMETERS X, AFUN, BFUN, CFUN WHICH
!                          returns the values of the X-dependent
!                          coefficients AF(X), BF(X), CF(X) in
!                          the elliptic equation at X.
!                        COFY
!                          a user-supplied subprogram with
!                          PARAMETERS Y, DFUN, EFUN, FFUN WHICH
!                          returns the values of the Y-dependent
!                          coefficients DF(Y), EF(Y), FF(Y) in
!                          the elliptic equation at Y.
!                        Note.  COFX and COFY must be declared external
!                        in the calling routine. The values returned in
!                        AFUN AND DFUN MUST SATISFY AFUN*DFUN GREATER
!                        than 0 for a less than X less than b,
!                        c less than Y less than d (see ierror=10).
!                        The coefficients provided may lead to a matrix
!                        equation which is not diagonally dominant in
!                        which case solution may fail (see ierror=4).
!                        grhs
!                          a two-dimensional array that specifies the
!                          values of the right-hand side of the elliptic
!                          EQUATION, I.E., grhs(I,J)=G(XI,YI), FOR
!                          I=2,...,m, J=2,...,n.  at the boundaries,
!                          grhs is defined by
!                          mbdcnd   grhs(1,J)   grhs(m+1,J)
!                          ------   ---------   -----------
!                            0      G(a,YJ)     G(b,YJ)
!                            1         *           *
!                            2         *        G(b,YJ)  J=1,2,...,n+1
!                            3      G(a,YJ)     G(b,YJ)
!                            4      G(a,YJ)        *
!                          nbdcnd   grhs(I,1)   grhs(I,n+1)
!                          ------   ---------   -----------
!                            0      G(XI,c)     G(XI,d)
!                            1         *           *
!                            2         *        G(XI,d)  I=1,2,...,m+1
!                            3      G(XI,c)     G(XI,d)
!                            4      G(XI,c)        *
!                          where * means these quantites are not used.
!                          grhs should be dimensioned mn by at least
!                          n+1 in the calling routine.
!                        mn
!                          the row (or first) dimension of the array
!                          grhs as it appears in the program calling
!                          sepell. mn must be at least 7 and greater
!                          than or equal to m+1.
!                        usol
!                          a two-dimensional array that specifies the
!                          values of the solution along the boundaries.
!                          At the boundaries, usol is defined by
!                          mbdcnd   usol(1,J)   usol(m+1,J)
!                          ------   ---------   -----------
!                            0         *           *
!                            1      U(a,YJ)     U(b,YJ)
!                            2      U(a,YJ)        *     J=1,2,...,n+1
!                            3         *           *
!                            4         *        U(b,YJ)
!                          nbdcnd   usol(I,1)   usol(I,n+1)
!                          ------   ---------   -----------
!                            0         *           *
!                            1      U(XI,c)     U(XI,d)
!                            2      U(XI,c)        *     I=1,2,...,m+1
!                            3         *           *
!                            4         *        U(XI,d)
!                          where * means the quantites are not used in
!                          the solution.
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
!                          If iorder=4, then the two arrays, usol and
!                          grhs, must be distinct.
!                          usol should be dimensioned idmn by at least
!                          n+1 in the calling routine.
!                        idmn
!                          the row (or first) dimension of the array
!                          usol as it appears in the program calling
!                          sepell. idmn must be at least 7 and greater
!                          than or equal to m+1.
!                        w
!                          a one-dimensional array that must be provided
!                          by the user for work space.  Let
!                          K=int(LOG2(n+1))+1 and set  L=2**(K+1).
!                          Then (K-2)*L+K+10*n+12*m+27 will suffice
!                          as a length of w.  the actual length of w in
!                          the calling routine must be set in w(1) (see
!                          ierror=11).
! ON OUTPUT              usol
!                          contains the approximate solution to the
!                          elliptic equation.  usol(I,J) is the
!                          approximation to U(XI,YJ) for I=1,2...,m+1
!                          and J=1,2,...,n+1.  The approximation has
!                          error O(DLX**2+DLY**2) if called with
!                          iorder=2 And O(DLX**4+DLY**4) if called with
!                          iorder=4.
!                        w
!                          contains intermediate values that must not be
!                          destroyed if sepell is called again with
!                          intl=1.  In addition w(1) contains the exact
!                          minimal length (in floating point) required
!                          for the work space (see ierror=11).
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
!                          or n.
! ENTRY POINTS           sepell, sepel1, chkprm, chksng, orthg, minsol,
!                        trisp, defer, dxfn, dyfn, blktri, blktr1,indxb,
!                        indxa, indxc, prod0, prodp, cprod0, cprodp,
!                        ppadd, psgf, bsrh, ppsgf, ppspf, compb,
!                        tqlrt0, spmpar
! SPECIAL CONDITIONS     NONE
! COMMON BLOCKS          SPLP, CBLKT
! I/O                    NONE
! PRECISION              SINGLE
! SPECIALIST             JOHN c. ADAMS, NCAR, BOULDER, COLORADO  80307
! HISTORY                DEVELOPED AT NCAR DURING 1975-76.
! ALGORITHM              sepell AUTOMATICALLY DISCRETIZES THE SEPARABLE
!                        elliptic equation which is then solved by A
!                        generalized cyclic reduction algorithm in the
!                        subroutine, blktri.  The fourth-order solution
!                        is obtained using deferred corrections, which
!                        is described and referenced in sections,
!                        references and method.
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
!              SECOND-ORDER    FOURTH-ORDER   SECOND-ORDER  FOURTH-ORDER
!    m    n   EXECUTION TIME  EXECUTION TIME    ERROR         ERROR
!               (m SEC)         (m SEC)
!     6    6         6              14          6.8E-1        1.2E0
!    14   14        23              58          1.4E-1        1.8E-1
!    30   30       100             247          3.2E-2        9.7E-3
!    62   62       445           1,091          7.5E-3        3.0E-4
!   126  126     2,002           4,772          1.8E-3        3.5E-6
! PORTABILITY            THE VALUE GIVEN BY spmpar(1) IS THE ONLY
!                        machine dependent constant that is used.
! REFERENCES             KELLER, H.B., NUMERICAL METHODS FOR TWO-POINT
!                          boundary-value problems, Blaisdel (1968),
!                          WALTHAM, mass.
!                        Swarztrauber, P., And R. sweet (1975),
!                          efficient Fortran subprograms for the
!                          solution of elliptic partial differential
!                          equations.  NCAR technical note
!                          NCAR-TN/ia-109, PP. 135-137.
!     check input parameters
call chkprm(intl,iorder,a,b,m,mbdcnd,c,d,n,nbdcnd,cofx,cofy, &
   & idmn,mn,ierror)
if (ierror /= 0) return
!     Compute minimum work space and check work space length input
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
!     Set work space indices
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
end subroutine sepell

subroutine sepel1(intl,iorder,a,b,m,mbdcnd,bda,alpha,bdb,beta,c, &
   & d,n,nbdcnd,bdc,gama,bdd,xnu,cofx,cofy,an,bn, &
   & cn,dn,un,zn,am,bm,cm,dm,um,zm,grhs,mn,usol, &
   & idmn,w,pertrb,ierror)
implicit none
integer :: idmn
integer, intent(inout) :: ierror
integer, intent(in) :: intl, iorder, m, mbdcnd
integer :: mn
integer, intent(in) :: n, nbdcnd
real, intent(in) :: a, alpha
real :: am(*), an(*)
real, intent(in) :: b
real :: bda(*), bdb(*), bdc(*), bdd(*)
real, intent(in) :: beta
real :: bm(*), bn(*)
real, intent(in) :: c
real :: cm(*), cn(*)
real, intent(in) :: d
real :: dm(*), dn(*)
real, intent(in) :: gama
real :: grhs(mn,*)
real, intent(inout) :: pertrb
real :: um(*), un(*), usol(idmn,*), w(*)
real, intent(in) :: xnu
real :: zm(*), zn(*)
external cofx, cofy
!     beginning of local variable declarations
integer :: i, i1, iord, j, mp, np
real :: ai, ax1, axi, bi, bxi, ci, cxi, cxm, dj, dy1, dyj, ej, &
   & eyj, fj, fyj, fyn, prtrb, xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
logical :: singlr
!     sepel1 sets up vectors and arrays for input to blktri
!     and computes a second order solution in usol.  A return jump to
!     sepell OCCURRS IF iorder=2.  IF iorder=4 A FOURTH ORDER
!     solution is generated in usol.
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!     Set parameters internally
kswx = mbdcnd + 1
kswy = nbdcnd + 1
k = m + 1
l = n + 1
ait = a
bit = b
cit = c
dit = d
!     Set right hand side values from grhs in usol on the interior
!     and non-specified boundaries.
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
!     Set switches for periodic or non-periodic boundaries
mp = 1
np = 1
if (kswx == 1) mp = 0
if (kswy == 1) np = 0
!     Set dlx,dly and size of block tri-diagonal system generated
!     in NINT,mint
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
!     Set subscript limits for portion of array to input to blktri
is = 1
js = 1
if (kswx == 2 .or. kswx == 3) is = 2
if (kswy == 2 .or. kswy == 3) js = 2
ns = nit + js - 1
ms = mit + is - 1
!     Set X - Direction
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
!     Set Y direction
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
!     Adjust edges in X direction unless periodic
ax1 = am(1)
cxm = cm(mit)
select case (kswx)
case (1)
   go to 170
case (2)
   go to 130
case (3)
   go to 150
case (4)
   go to 160
case (5)
   go to 140
end select
!     Dirichlet-Dirichlet in X direction
130 am(1) = 0.0
cm(mit) = 0.0
go to 170
!     Mixed-Dirichlet in X direction
140 am(1) = 0.0
bm(1) = bm(1) + 2.*alpha*dlx*ax1
cm(1) = cm(1) + ax1
cm(mit) = 0.0
go to 170
!     Dirichlet-mixed in X direction
150 am(1) = 0.0
am(mit) = am(mit) + cxm
bm(mit) = bm(mit) - 2.*beta*dlx*cxm
cm(mit) = 0.0
go to 170
!     Mixed - Mixed in X direction
160 continue
am(1) = 0.0
bm(1) = bm(1) + 2.*dlx*alpha*ax1
cm(1) = cm(1) + ax1
am(mit) = am(mit) + cxm
bm(mit) = bm(mit) - 2.*dlx*beta*cxm
cm(mit) = 0.0
170 continue
!     Adjust in Y direction unless periodic
dy1 = an(1)
fyn = cn(nit)
select case (kswy)
case (1)
   go to 220
case (2)
   go to 180
case (3)
   go to 200
case (4)
   go to 210
case (5)
   go to 190
end select
!     Dirichlet-Dirichlet in Y direction
180 continue
an(1) = 0.0
cn(nit) = 0.0
go to 220
!     Mixed-Dirichlet in Y direction
190 continue
an(1) = 0.0
bn(1) = bn(1) + 2.*dly*gama*dy1
cn(1) = cn(1) + dy1
cn(nit) = 0.0
go to 220
!     Dirichlet-mixed in Y direction
200 an(1) = 0.0
an(nit) = an(nit) + fyn
bn(nit) = bn(nit) - 2.*dly*xnu*fyn
cn(nit) = 0.0
go to 220
!     Mixed - Mixed direction in Y direction
210 continue
an(1) = 0.0
bn(1) = bn(1) + 2.*dly*gama*dy1
cn(1) = cn(1) + dy1
an(nit) = an(nit) + fyn
bn(nit) = bn(nit) - 2.0*dly*xnu*fyn
cn(nit) = 0.0
220 if (kswx == 1) go to 270
!     Adjust usol along X edge
do j = js,ns
   if (kswx /= 2 .and. kswx /= 3) go to 230
   usol(is,j) = usol(is,j) - ax1*usol(1,j)
   go to 240
230 usol(is,j) = usol(is,j) + 2.0*dlx*ax1*bda(j)
240 if (kswx /= 2 .and. kswx /= 5) go to 250
   usol(ms,j) = usol(ms,j) - cxm*usol(k,j)
   go to 260
250 usol(ms,j) = usol(ms,j) - 2.0*dlx*cxm*bdb(j)
260 continue
end do
270 if (kswy == 1) go to 320
!     Adjust usol along Y edge
do i = is,ms
   if (kswy /= 2 .and. kswy /= 3) go to 280
   usol(i,js) = usol(i,js) - dy1*usol(i,1)
   go to 290
280 usol(i,js) = usol(i,js) + 2.0*dly*dy1*bdc(i)
290 if (kswy /= 2 .and. kswy /= 5) go to 300
   usol(i,ns) = usol(i,ns) - fyn*usol(i,l)
   go to 310
300 usol(i,ns) = usol(i,ns) - 2.0*dly*fyn*bdd(i)
310 continue
end do
320 continue
!     Save adjusted edges in grhs if iorder=4
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
!     Check if operator is singular
call chksng(mbdcnd,nbdcnd,alpha,beta,gama,xnu,cofx,cofy,singlr)
!     Compute non-zero eigenvector in null space of transpose
!     if singular
if (singlr) call trisp(mit,am,bm,cm,dm,um,zm)
if (singlr) call trisp(nit,an,bn,cn,dn,un,zn)
!     Make initialization call to blktri
if (intl == 0) &
   & call blktri(intl,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn, &
   & usol(is,js),ierror,w)
if (ierror /= 0) return
!     Adjust right hand side if necessary
360 continue
if (singlr) call orthg(usol,idmn,zn,zm,pertrb)
!     Compute solution
call blktri(i1,np,nit,an,bn,cn,mp,mit,am,bm,cm,idmn,usol(is,js), &
   & ierror,w)
if (ierror /= 0) return
!     Set periodic boundaries if necessary
if (kswx /= 1) go to 380
do j = 1,l
   usol(k,j) = usol(1,j)
end do
380 if (kswy /= 1) go to 400
do i = 1,k
   usol(i,l) = usol(i,1)
end do
400 continue
!     Minimize solution with respect to weighted least squares
!     norm if operator is singular
if (singlr) call minsol(usol,idmn,zn,zm,prtrb)
!     RETURN IF DEFERRED CORRECTIONS AND A FOURTH ORDER SOLUTION ARE
!     not flagged
if (iord == 2) return
iord = 2
!     Compute new right hand side for fourth order solution
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
!     beginning of local variable declarations
integer :: i, j
real :: ai, bi, ci, dj, dlx, dly, ej, fj, xi, yj
!     This program checks the input parameters for errors
!     check definition of solution region
ierror = 1
if (a >= b .or. c >= d) return
!     Check boundary switches
ierror = 2
if (mbdcnd < 0 .or. mbdcnd > 4) return
ierror = 3
if (nbdcnd < 0 .or. nbdcnd > 4) return
!     Check first dimension in calling routine
ierror = 5
if (mn < 7 .or. idmn < 7) return
!     Check m
ierror = 6
if (m > (idmn - 1) .or. m < 6) return
if (m > mn - 1) return
!     Check n
ierror = 7
if (n < 5) return
!     Check iorder
ierror = 8
if (iorder /= 2 .and. iorder /= 4) return
!     Check intl
ierror = 9
if (intl /= 0 .and. intl /= 1) return
!     Check that equation is elliptic
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
!     No error found
ierror = 0
end subroutine chkprm

subroutine chksng(mbdcnd,nbdcnd,alpha,beta,gama,xnu,cofx,cofy, &
   & singlr)
implicit none
integer, intent(in) :: mbdcnd, nbdcnd
real, intent(in) :: alpha, beta, gama, xnu
logical, intent(inout) :: singlr
!     beginning of local variable declarations
integer :: i, j
real :: ai, bi, ci, dj, ej, fj, xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!     THIS SUBROUTINE CHECKS IF THE PDE   sepell
!     must solve is a singular operator
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
singlr = .false.
!     Check if the boundary conditions are
!     entirely periodic and/or mixed
if ((mbdcnd /= 0 .and. mbdcnd /= 3) .or. &
   & (nbdcnd /= 0 .and. nbdcnd /= 3)) return
!     Check that mixed conditions are pure neuman
if (mbdcnd /= 3) go to  10
if (alpha /= 0.0 .or. beta /= 0.0) return
10 if (nbdcnd /= 3) go to  20
if (gama /= 0.0 .or. xnu /= 0.0) return
20 continue
!     Check that non-derivative coefficient functions
!     are zero
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
!     The operator must be singular if this point is reached
singlr = .true.
end subroutine chksng

subroutine orthg(usol,idmn,zn,zm,pertrb)
implicit none
integer :: idmn
real, intent(inout) :: pertrb
real :: usol(idmn,*), zm(*), zn(*)
!     beginning of local variable declarations
integer :: i, ifnl, ii, istr, j, jfnl, jj, jstr
real :: ete, ute
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!     This subroutine orthogonalizes the array usol with respect to
!     the constant array in a weighted least squares norm
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
istr = is
ifnl = ms
jstr = js
jfnl = ns
!     Compute weighted inner products
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
!     Set perturbation parameter
pertrb = ute/ete
!     Subtract off constant pertrb
do i = istr,ifnl
   do j = jstr,jfnl
      usol(i,j) = usol(i,j) - pertrb
   end do
end do
end subroutine orthg

subroutine minsol(usol,idmn,zn,zm,pertb)
implicit none
integer :: idmn
real, intent(in) :: pertb
real :: usol(idmn,*), zm(*), zn(*)
!     beginning of local variable declarations
integer :: i, ifnl, ii, istr, j, jfnl, jj, jstr
real :: ete, pertrb, ute
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!     This subroutine orthogonalizes the array usol with respect to
!     the constant array in a weighted least squares norm
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!     Entry at minsol occurrs when the final solution is
!     to be minimized with respect to the weighted
!     least squares norm
istr = 1
ifnl = k
jstr = 1
jfnl = l
!     Compute weighted inner products
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
!     Set perturbation parameter
pertrb = ute/ete
!     Subtract off constant pertrb
do i = istr,ifnl
   do j = jstr,jfnl
      usol(i,j) = usol(i,j) - pertrb
   end do
end do
end subroutine minsol

subroutine trisp(n,a,b,c,d,u,z)
implicit none
integer, intent(in) :: n
real :: a(n), b(n), c(n)
real, intent(inout) :: d(n), u(n), z(n)
!     beginning of local variable declarations
integer :: j, k, nm1, nm2
real :: an, bn, den, v
!     This subroutine solves for a non-zero eigenvector corresponding
!     to the zero eigenvalue of the transpose of the rank
!     deficient one matrix with subdiagonal A, diagonal b, and
!     superdiagonal c , with a(1) in the (1,n) position, with
!     c(n) in the (n,1) position, and all other elements zero.
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
!     Set last component equal to one
z(n) = 1.0
z(n - 1) = -d(n - 1)
nm1 = n - 1
do j = 2,nm1
   k = n - j
   z(k) = -d(k)*z(k + 1) - u(k)*z(n)
end do
end subroutine trisp

subroutine defer(cofx,cofy,usol,idmn,grhs,mn)
implicit none
integer :: idmn, mn
real :: grhs(mn,*), usol(idmn,*)
!     beginning of local variable declarations
integer :: i, j
real :: ai, bi, ci, dj, ej, fj, tx, ty, uxxx, uxxxx, uyyy, uyyyy, &
   & xi, yj
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
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
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
!     Compute truncation error approximation over the entire mesh
do j = js,ns
   yj = cit + float(j - 1)*dly
   call cofy(yj,dj,ej,fj)
   do i = is,ms
      xi = ait + float(i - 1)*dlx
      call cofx(xi,ai,bi,ci)
!     Compute partial derivative approximations at (XI,YJ)
      call dxfn(usol,idmn,i,j,uxxx,uxxxx)
      call dyfn(usol,idmn,i,j,uyyy,uyyyy)
      tx = ai*uxxxx/12.0 + bi*uxxx/6.0
      ty = dj*uyyyy/12.0 + ej*uyyy/6.0
!     Reset form of truncation if at boundary which is non-periodic
      if (kswx == 1 .or. (i > 1 .and. i < k)) go to  10
      tx = ai/3.0*(uxxxx/4.0 + uxxx/dlx)
10    if (kswy == 1 .or. (j > 1 .and. j < l)) go to  20
      ty = dj/3.0*(uyyyy/4.0 + uyyy/dly)
20    grhs(i,j) = grhs(i,j) + dlx**2*tx + dly**2*ty
   end do
end do
!     Reset the right hand side in usol
do i = is,ms
   do j = js,ns
      usol(i,j) = grhs(i,j)
   end do
end do
end subroutine defer

subroutine dxfn(u,idmn,i,j,uxxx,uxxxx)
implicit none
integer, intent(in) :: i
integer :: idmn
integer, intent(in) :: j
real :: u(idmn,*)
real, intent(inout) :: uxxx, uxxxx
!     beginning of local variable declarations
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!     This program computes second order finite difference
!     approximations to the third and fourth X
!     partial derivatives of u at the (i,j) mesh point
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
if (i > 2 .and. i < (k - 1)) go to  50
if (i == 1) go to  10
if (i == 2) go to  30
if (i == k - 1) go to  60
if (i == k) go to  80
!     Compute partial derivative approximations at X=A
10 if (kswx == 1) go to  20
uxxx = (-5.0*u(1,j) + 18.0*u(2,j) - 24.0*u(3,j) + 14.0*u(4,j) - &
   & 3.0*u(5,j))/(tdlx3)
uxxxx = (3.0*u(1,j) - 14.0*u(2,j) + 26.0*u(3,j) - 24.0*u(4,j) + &
   & 11.0*u(5,j) - 2.0*u(6,j))/dlx4
return
!     Periodic at X=A
20 uxxx = (-u(k - 2,j) + 2.0*u(k - 1,j) - 2.0*u(2,j) + u(3,j))/(tdlx3)
uxxxx = (u(k - 2,j) - 4.0*u(k - 1,j) + 6.0*u(1,j) - 4.0*u(2,j) + u(3,j))/dlx4
return
!     Compute partial derivative approximations at X=A+dlx
30 if (kswx == 1) go to  40
uxxx = (-3.0*u(1,j) + 10.0*u(2,j) - 12.0*u(3,j) + 6.0*u(4,j) - u(5,j))/ &
   & tdlx3
uxxxx = (2.0*u(1,j) - 9.0*u(2,j) + 16.0*u(3,j) - 14.0*u(4,j) + 6.0*u(5,j) - &
   & u(6,j))/dlx4
return
!     Periodic at X=A+dlx
40 uxxx = (-u(k - 1,j) + 2.0*u(1,j) - 2.0*u(3,j) + u(4,j))/(tdlx3)
uxxxx = (u(k - 1,j) - 4.0*u(1,j) + 6.0*u(2,j) - 4.0*u(3,j) + u(4,j))/dlx4
return
!     Compute partial derivative approximations on the interior
50 continue
uxxx = (-u(i - 2,j) + 2.0*u(i - 1,j) - 2.0*u(i + 1,j) + u(i + 2,j))/tdlx3
uxxxx = (u(i - 2,j) - 4.0*u(i - 1,j) + 6.0*u(i,j) - 4.0*u(i + 1,j) + u(i + 2,j))/ &
   & dlx4
return
!     Compute partial derivative approximations at X=B-dlx
60 if (kswx == 1) go to  70
uxxx = (u(k - 4,j) - 6.0*u(k - 3,j) + 12.0*u(k - 2,j) - 10.0*u(k - 1,j) + &
   & 3.0*u(k,j))/tdlx3
uxxxx = (-u(k - 5,j) + 6.0*u(k - 4,j) - 14.0*u(k - 3,j) + 16.0*u(k - 2,j) - &
   & 9.0*u(k - 1,j) + 2.0*u(k,j))/dlx4
return
!     Periodic at X=B-dlx
70 uxxx = (-u(k - 3,j) + 2.0*u(k - 2,j) - 2.0*u(1,j) + u(2,j))/tdlx3
uxxxx = (u(k - 3,j) - 4.0*u(k - 2,j) + 6.0*u(k - 1,j) - 4.0*u(1,j) + u(2,j))/ &
   & dlx4
return
!     Compute partial derivative approximations at X=B
80 uxxx = -(3.0*u(k - 4,j) - 14.0*u(k - 3,j) + 24.0*u(k - 2,j) - 18.0*u(k - 1,j) + &
   & 5.0*u(k,j))/tdlx3
uxxxx = (-2.0*u(k - 5,j) + 11.0*u(k - 4,j) - 24.0*u(k - 3,j) + 26.0*u(k - 2,j) - &
   & 14.0*u(k - 1,j) + 3.0*u(k,j))/dlx4
end subroutine dxfn

subroutine dyfn(u,idmn,i,j,uyyy,uyyyy)
implicit none
integer, intent(in) :: i
integer :: idmn
integer, intent(in) :: j
real :: u(idmn,*)
real, intent(inout) :: uyyy, uyyyy
!     beginning of local variable declarations
integer :: is, js, k, kswx, kswy, l, mit, ms, nit, ns
real :: ait, bit, cit, dit, dlx, dlx4, dly, dly4, tdlx3, tdly3
!     This program computes second order finite difference
!     approximations to the third and fourth Y
!     partial derivatives of u at the (i,j) mesh point
common /splp/   kswx       ,kswy       ,k          ,l          , &
   & ait        ,bit        ,cit        ,dit        , &
   & mit        ,nit        ,is         ,ms         , &
   & js         ,ns         ,dlx        ,dly        , &
   & tdlx3      ,tdly3      ,dlx4       ,dly4
if (j > 2 .and. j < (l - 1)) go to  50
if (j == 1) go to  10
if (j == 2) go to  30
if (j == l - 1) go to  60
if (j == l) go to  80
!     Compute partial derivative approximations at Y=C
10 if (kswy == 1) go to  20
uyyy = (-5.0*u(i,1) + 18.0*u(i,2) - 24.0*u(i,3) + 14.0*u(i,4) - &
   & 3.0*u(i,5))/tdly3
uyyyy = (3.0*u(i,1) - 14.0*u(i,2) + 26.0*u(i,3) - 24.0*u(i,4) + &
   & 11.0*u(i,5) - 2.0*u(i,6))/dly4
return
!     Periodic at X=A
20 uyyy = (-u(i,l - 2) + 2.0*u(i,l - 1) - 2.0*u(i,2) + u(i,3))/tdly3
uyyyy = (u(i,l - 2) - 4.0*u(i,l - 1) + 6.0*u(i,1) - 4.0*u(i,2) + u(i,3))/dly4
return
!     Compute partial derivative approximations at Y=C+dly
30 if (kswy == 1) go to  40
uyyy = (-3.0*u(i,1) + 10.0*u(i,2) - 12.0*u(i,3) + 6.0*u(i,4) - u(i,5))/ &
   & tdly3
uyyyy = (2.0*u(i,1) - 9.0*u(i,2) + 16.0*u(i,3) - 14.0*u(i,4) + 6.0*u(i,5) - &
   & u(i,6))/dly4
return
!     Periodic at Y=C+dly
40 uyyy = (-u(i,l - 1) + 2.0*u(i,1) - 2.0*u(i,3) + u(i,4))/tdly3
uyyyy = (u(i,l - 1) - 4.0*u(i,1) + 6.0*u(i,2) - 4.0*u(i,3) + u(i,4))/dly4
return
!     Compute partial derivative approximations on the interior
50 continue
uyyy = (-u(i,j - 2) + 2.0*u(i,j - 1) - 2.0*u(i,j + 1) + u(i,j + 2))/tdly3
uyyyy = (u(i,j - 2) - 4.0*u(i,j - 1) + 6.0*u(i,j) - 4.0*u(i,j + 1) + u(i,j + 2))/ &
   & dly4
return
!     Compute partial derivative approximations at Y=D-dly
60 if (kswy == 1) go to  70
uyyy = (u(i,l - 4) - 6.0*u(i,l - 3) + 12.0*u(i,l - 2) - 10.0*u(i,l - 1) + &
   & 3.0*u(i,l))/tdly3
uyyyy = (-u(i,l - 5) + 6.0*u(i,l - 4) - 14.0*u(i,l - 3) + 16.0*u(i,l - 2) - &
   & 9.0*u(i,l - 1) + 2.0*u(i,l))/dly4
return
!     Periodic at Y=D-dly
70 continue
uyyy = (-u(i,l - 3) + 2.0*u(i,l - 2) - 2.0*u(i,1) + u(i,2))/tdly3
uyyyy = (u(i,l - 3) - 4.0*u(i,l - 2) + 6.0*u(i,l - 1) - 4.0*u(i,1) + u(i,2))/ &
   & dly4
return
!     Compute partial derivative approximations at Y=D
80 uyyy = -(3.0*u(i,l - 4) - 14.0*u(i,l - 3) + 24.0*u(i,l - 2) - 18.0*u(i,l - 1) + &
   & 5.0*u(i,l))/tdly3
uyyyy = (-2.0*u(i,l - 5) + 11.0*u(i,l - 4) - 24.0*u(i,l - 3) + 26.0*u(i,l - 2) - &
   & 14.0*u(i,l - 1) + 3.0*u(i,l))/dly4
end subroutine dyfn

subroutine blktri(iflg,np,n,an,bn,cn,mp,m,am,bm,cm,idimy,y, &
   & ierror,w)
implicit none
integer :: idimy
integer, intent(inout) :: ierror
integer, intent(in) :: iflg
integer :: m
integer, intent(in) :: mp
integer :: n
integer, intent(in) :: np
real :: am(*), an(*), bm(*), bn(*), cm(*), cn(*), w(*), y(idimy,*)
!     beginning of local variable declarations
integer :: iw1, iw2, iw3, iwah, iwbh, iwd, iwu, iww, nh, nl
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
external prod0, prodp, cprod0, cprodp
!***********************************************************************
!          Version  2  October 1976  including errata  October 1976
!         documentation for this program is given in
!        efficient Fortran subprograms for the solution of
!            elliptic partial differential equations
!                              by
!          PAUL SWARZTRAUBER   AND  ROLAND SWEET
!             TECHNICAL NOTE TN/ia-109   JULY 1975
!       national center for atmospheric research  boulder,colorado 80307
!        which is sponsored by the national science foundation
!***********************************************************************
!     Subroutine blktri solves a system of linear equations of the form
!          an(J)*X(I,J-1) + am(I)*X(I-1,J) + (bn(J)+bm(I))*X(I,J)
!          + cn(J)*X(I,J+1) + cm(I)*X(I+1,J) = y(I,J)
!               FOR I = 1,2,...,m  AND  J = 1,2,...,n.
!     I+1 and I-1 are evaluated modulo m and J+1 and J-1 modulo n, I.E.,
!          x(i,0) = x(i,n),  x(i,n+1) = x(i,1),
!          x(0,j) = x(m,j),  x(m+1,j) = x(1,j).
!     These equations usually result from the discretization of
!     separable elliptic equations.  Boundary conditions may be
!     Dirichlet, Neumann, or periodic.
!     * * * * * * * * * *     ON INPUT     * * * * * * * * * *
!     iflg
!       = 0  Initialization only.  Certain quantities that depend on np,
!                                  n, an, bn, and cn are computed and
!                                  STOR1D in the work array  w.
!       = 1  The quantities that were computed in the initialization are
!            used to obtain the solution X(I,J).
!       Note   a call with iflg=0 Takes approximately one half the time
!              time as a call with iflg = 1  .  However, the
!              initialization does not have to be repeated unless np, n,
!              an, bn, or cn change.
!     np
!       = 0  If an(1) and cn(n) are not zero, which corresponds to
!            periodic bounary conditions.
!       = 1  If an(1) and cn(n) are zero.
!     n
!       the number of unknowns in the J-direction. n must be greater
!       than 2. The operation count is proportional to MNLOG2(n), hence
!       n should be selected less than or equal to m.
!     AN,bn,cn
!       one-dimensional arrays of length n that specify the coefficients
!       in the linear equations given above.
!     MP
!       = 0  If am(1) and cm(m) are not zero, which corresponds to
!            periodic boundary conditions.
!       = 1  IF am(1) = cm(m) = 0  .
!     m
!       the number of unknowns in the I-direction. m must be greater
!       than 2.
!     AM,bm,cm
!       one-dimensional arrays of length m that specify the coefficients
!       in the linear equations given above.
!     idimy
!       the row (or first) dimension of the two-dimensional array y as
!       it appears in the program calling blktri.  This parameter is
!       used to specify the variable DIMENSION of y.  idimy must be at
!       LEAST m.
!     y
!       a two-dimensional array that specifies the values of the right
!       side of the linear system of equations given above.  y must be
!       dimensioned at least m*n.
!     w
!       a one-dimensional array that must be provided by the user for
!       work space.
!             If np=1 Define k=int(LOG2(n))+1 and set L=2**(k+1) then
!                     w must have dimension (k-2)*L+k+4+max(2n,6m)
!             if np=0 Define k=int(LOG2(n-1))+1 and set L=2**(k+1) then
!                     w must have dimension (k-2)*L+k+4+2n+max(2n,6m)
!       **important** for purposes of checking, the required dimension
!                     of w is computed by blktri and STOR1D in w(1)
!                     in floating point format.
!     * * * * * * * * * *     ON OUTPUT     * * * * * * * * * *
!     y
!       contains the solution X.
!     Ierror
!       an error flag that indicates invalid input parameters.  Except
!       for number zero, a solution is not attempted.
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
!     w
!       contains intermediate values that must not be destroyed if
!       blktri will be called again with iflg = 1  .
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
! Test m and n for the proper form
nm = n
ierror = 0
if ((m - 5) < 0) go to 10
go to 20
10 ierror = 1
go to 190
20 if ((nm - 3) < 0) go to 30
go to 40
30 ierror = 2
go to 190
40 if ((idimy - m) < 0) go to 50
go to 60
50 ierror = 3
go to 190
60 nh = n
npp = np
if ((npp) == 0) go to 80
go to 70
70 nh = nh + 1
80 ik = 2
k = 1
90 ik = ik + ik
k = k + 1
if ((nh - ik) <= 0) go to 100
go to 90
100 nl = ik
ik = ik + ik
nl = nl - 1
iwah = (k - 2)*ik + k + 6
if ((npp) == 0) go to 120
go to 110
!     Divide w into working sub arrays
110 iw1 = iwah
iwbh = iw1 + nm
w(1) = float(iw1 - 1 + max(2*nm,6*m))
go to 130
120 iwbh = iwah + nm + nm
iw1 = iwbh
w(1) = float(iw1 - 1 + max(2*nm,6*m))
nm = nm - 1
! Subroutine compb computes the roots of the B polynomials
130 if ((ierror) == 0) go to 140
go to 190
140 iw2 = iw1 + m
iw3 = iw2 + m
iwd = iw3 + m
iww = iwd + m
iwu = iww + m
if ((iflg) == 0) go to 150
go to 160
150 call compb(nl,ierror,an,bn,cn,w(2),w(iwah),w(iwbh))
go to 190
160 if ((mp) == 0) go to 180
go to 170
! Subroutine blktr1 solves the linear system
170 call blktr1(nl,an,bn,cn,m,am,bm,cm,idimy,y,w(2),w(iw1),w(iw2), &
   & w(iw3),w(iwd),w(iww),w(iwu),prod0,cprod0)
go to 190
180 call blktr1(nl,an,bn,cn,m,am,bm,cm,idimy,y,w(2),w(iw1),w(iw2), &
   & w(iw3),w(iwd),w(iww),w(iwu),prodp,cprodp)
190 continue
end subroutine blktri

subroutine blktr1(n,an,bn,cn,m,am,bm,cm,idimy,y,b,w1,w2,w3,wd, &
   & ww,wu,prdct,cprdct)
implicit none
integer :: idimy, m
integer, intent(in) :: n
real :: am(*), an(*), b(*), bm(*), bn(*), cm(*), cn(*), w1(*), &
   & w2(*), w3(*), wd(*), wu(*), ww(*), y(idimy,*)
!     beginning of local variable declarations
integer :: i, i1, i2, i3, i4, idxa, idxc, if, ifd, im1, im2, im3, &
   & imi1, imi2, ip, ip1, ip2, ip3, ipi1, ipi2, ipi3, ir, irm1, iz, &
   & izr, j, kdo, l, ll, na, nc, nm1, nm2, nm3, np, np1, np2, np3, nz
real :: dum
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
! blktr1 solves the linear system
! b  contains the roots of all the b polynomials
! w1,W2,W3,WD,WW,WU  are all working arrays
! PRDCT is either prodp or prod0 depending on whether the boundary
! conditions in the m direction are periodic or not
! CPRDCT is either cprodp or cprod0 which are the complex versions
! of prodp and prod0. These are called in the event that some
! of the roots of the b sub P polynomial are complex
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
! Begin reduction phase
kdo = k - 1
do l = 1,kdo
   ir = l - 1
   i2 = 2**ir
   i1 = i2/2
   i3 = i2 + i1
   i4 = i2 + i2
   irm1 = ir - 1
   call indxb(i2,ir,im2,nm2)
   if (nm2 == 0) im2 = 1
   call indxb(i1,irm1,im3,nm3)
   if (nm3 == 0) im3 = 1
   call indxb(i3,irm1,im1,nm1)
   if (nm1 == 0) im1 = 1
   call prdct(nm2,b(im2),nm3,b(im3),nm1,b(im1),0,dum,y(1,i2),w3, &
      & m,am,bm,cm,wd,ww,wu)
   if = 2**k
   do i = i4,if,i4
      if ((i - nm) <= 0) go to 10
      go to 80
10    ipi1 = i + i1
      ipi2 = i + i2
      ipi3 = i + i3
      call indxc(i,ir,idxc,nc)
      if ((i - if) < 0) go to 20
      go to 80
20    call indxa(i,ir,idxa,na)
      call indxb(i - i1,irm1,im1,nm1)
      if (nm1 == 0) im1 = 1
      call indxb(ipi2,ir,ip2,np2)
      if (np2 == 0) ip2 = 1
      call indxb(ipi1,irm1,ip1,np1)
      if (np1 == 0) ip1 = 1
      call indxb(ipi3,irm1,ip3,np3)
      if (np3 == 0) ip3 = 1
      call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),w3,w1,m,am, &
         & bm,cm,wd,ww,wu)
      if ((ipi2 - nm) <= 0) go to 50
      go to 30
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
end do
if ((npp) == 0) go to 100
go to 320
!     The periodic case is treated using the capacitance matrix method
100 if = 2**k
i = if/2
i1 = i/2
call indxb(i - i1,k - 2,im1,nm1)
if (nm1 == 0) im1 = 1
call indxb(i + i1,k - 2,ip1,np1)
if (np1 == 0) ip1 = 1
call indxb(i,k - 1,iz,nz)
if (nz == 0) iz = 1
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
   if (nz == 0) iz = 1
   call indxb(i - i1,ir - 1,im1,nm1)
   if (nm1 == 0) im1 = 1
   call indxb(i + i1,ir - 1,ip1,np1)
   if (np1 == 0) ip1 = 1
   call prdct(np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w1,w1,m,am,bm, &
      & cm,wd,ww,wu)
   do j = 1,m
      w1(j) = y(j,i) + w1(j)
   end do
   call prdct(nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w1,w1,m,am, &
      & bm,cm,wd,ww,wu)
end do
nswc_exit_1 : do ll = 2 , k
   l = k - ll + 1
   ir = l - 1
   i2 = 2**ir
   i1 = i2/2
   i4 = i2 + i2
   ifd = if - i2
   do i = i2,ifd,i4
      if ((i - i2 - izr) == 0) go to 140
      go to 170
140   if ((i - nm) <= 0) go to 150
      exit
150   call indxa(i,ir,idxa,na)
      call indxb(i,ir,iz,nz)
      if (nz == 0) iz = 1
      call indxb(i - i1,ir - 1,im1,nm1)
      if (nm1 == 0) im1 = 1
      call indxb(i + i1,ir - 1,ip1,np1)
      if (np1 == 0) ip1 = 1
      call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),w2,w2,m,am, &
         & bm,cm,wd,ww,wu)
      do j = 1,m
         w2(j) = y(j,i) + w2(j)
      end do
      call prdct(nz,b(iz),nm1,b(im1),np1,b(ip1),0,dum,w2,w2,m, &
         & am,bm,cm,wd,ww,wu)
      izr = i
      if ((i - nm) == 0) exit nswc_exit_1
      go to 170
170   continue
   end do
end do nswc_exit_1
do j = 1,m
   y(j,nm + 1) = y(j,nm + 1) - cn(nm + 1)*w1(j) - an(nm + 1)*w2(j)
end do
call indxb(if/2,k - 1,im1,nm1)
if (nm1 == 0) im1 = 1
call indxb(if,k - 1,ip,np)
if ((ncmplx) == 0) go to 220
go to 210
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
   if (nm2 == 0) im2 = 1
   call indxb(i - i2 - i1,ir - 1,im3,nm3)
   if (nm3 == 0) im3 = 1
   call indxb(i - i1,ir - 1,im1,nm1)
   if (nm1 == 0) im1 = 1
   call prdct(nm2,b(im2),nm3,b(im3),nm1,b(im1),0,dum,w1,w1,m,am, &
      & bm,cm,wd,ww,wu)
   call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),w1,w1,m,am,bm, &
      & cm,wd,ww,wu)
   do j = 1,m
      y(j,i) = y(j,i) - w1(j)
   end do
end do
izr = nm
do l = 1,kdo
   ir = l - 1
   i2 = 2**ir
   i1 = i2/2
   i3 = i2 + i1
   i4 = i2 + i2
   irm1 = ir - 1
   do i = i4,if,i4
      ipi1 = i + i1
      ipi2 = i + i2
      ipi3 = i + i3
      if ((ipi2 - izr) == 0) go to 280
      go to 270
270   if ((i - izr) == 0) exit
      go to 300
280   call indxc(i,ir,idxc,nc)
      call indxb(ipi2,ir,ip2,np2)
      if (np2 == 0) ip2 = 1
      call indxb(ipi1,irm1,ip1,np1)
      if (np1 == 0) ip1 = 1
      call indxb(ipi3,irm1,ip3,np3)
      if (np3 == 0) ip3 = 1
      call prdct(np2,b(ip2),np1,b(ip1),np3,b(ip3),0,dum,w2,w2,m, &
         & am,bm,cm,wd,ww,wu)
      call prdct(np1,b(ip1),0,dum,0,dum,nc,cn(idxc),w2,w2,m,am, &
         & bm,cm,wd,ww,wu)
      do j = 1,m
         y(j,i) = y(j,i) - w2(j)
      end do
      izr = i
      exit
300   continue
   end do
end do
! Begin back substitution phase
320 do ll = 1,k
   l = k - ll + 1
   ir = l - 1
   irm1 = ir - 1
   i2 = 2**ir
   i1 = i2/2
   i4 = i2 + i2
   ifd = if - i2
   do i = i2,ifd,i4
      if ((i - nm) <= 0) go to 330
      go to 430
330   imi1 = i - i1
      imi2 = i - i2
      ipi1 = i + i1
      ipi2 = i + i2
      call indxa(i,ir,idxa,na)
      call indxc(i,ir,idxc,nc)
      call indxb(i,ir,iz,nz)
      if (nz == 0) iz = 1
      call indxb(imi1,irm1,im1,nm1)
      if (nm1 == 0) im1 = 1
      call indxb(ipi1,irm1,ip1,np1)
      if (np1 == 0) ip1 = 1
      if ((i - i2) <= 0) go to 340
      go to 360
340   do j = 1,m
         w1(j) = 0.
      end do
      go to 370
360   call prdct(nm1,b(im1),0,dum,0,dum,na,an(idxa),y(1,imi2), &
         & w1,m,am,bm,cm,wd,ww,wu)
370   if ((ipi2 - nm) <= 0) go to 400
      go to 380
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
end do
end subroutine blktr1

subroutine indxa(i,ir,idxa,na)
implicit none
integer, intent(in) :: i
integer, intent(inout) :: idxa
integer, intent(in) :: ir
integer, intent(inout) :: na
!     beginning of local variable declarations
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
na = 2**ir
idxa = i - na + 1
if ((i - nm) <= 0) go to 20
go to 10
10 na = 0
20 return
end subroutine indxa

subroutine indxc(i,ir,idxc,nc)
implicit none
integer, intent(in) :: i
integer, intent(inout) :: idxc
integer, intent(in) :: ir
integer, intent(inout) :: nc
!     beginning of local variable declarations
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
nc = 2**ir
idxc = i
if ((idxc + nc - 1 - nm) <= 0) go to 20
go to 10
10 nc = 0
20 return
end subroutine indxc

subroutine indxb(i,ir,idx,idp)
implicit none
integer :: i, idp, idx, ir
!     beginning of local variable declarations
integer :: id, ipl, izh
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
integer :: nswc_ai_i4
! B(idx) is the location of the first root of the B(i,ir) polynomial
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
idp = 0
nswc_ai_i4 = ir
if (nswc_ai_i4 < 0) go to 70
if (nswc_ai_i4 == 0) go to 10
go to 30
10 if ((i - nm) <= 0) go to 20
go to 70
20 idx = i
idp = 1
return
30 izh = 2**ir
id = i - izh - izh
idx = id + id + (ir - 1)*ik + ir + (ik - i)/izh + 4
ipl = izh - 1
idp = izh + izh - 1
if ((i - ipl - nm) <= 0) go to 50
go to 40
40 idp = 0
return
50 if ((i + ipl - nm) <= 0) go to 70
go to 60
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
!     beginning of local variable declarations
integer :: ia, ibr, id, j, k, m1, m2, mm
real :: den, rt
! prod0 applies a sequence of matrix operations to the vector x and
! stores the result in y.
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         THE LENGTH OF THE ARRAY aa.
! x,y        MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS y.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,w,u      WORKING ARRAYS.
! IS         DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
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
20 if ((ia) <= 0) go to 50
go to 30
30 rt = aa(ia)
if (nd == 0) rt = -rt
ia = ia - 1
! Scalar multiplication
do j = 1,m
   y(j) = rt*w(j)
end do
50 if ((id) <= 0) go to 250
go to 60
60 rt = bd(id)
id = id - 1
if (id == 0) ibr = 1
! Begin solution to system
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
if ((den) == 0) go to 90
go to 80
80 w(1) = (y(1) - c(1)*w(2))/den
90 do j = 2,m
   w(j) = w(j) - d(j)*w(j - 1)
end do
if ((na) <= 0) go to 130
go to 20
110 do j = 1,m
   y(j) = w(j)
end do
ibr = 1
go to  20
130 if ((m1) <= 0) go to 140
go to 150
140 if ((m2) <= 0) go to 110
go to 200
150 if ((m2) <= 0) go to 170
go to 160
160 if ((abs(bm1(m1)) - abs(bm2(m2))) <= 0) &
   & go to 200
go to 170
170 if ((ibr) <= 0) go to 180
go to 190
180 if ((abs(bm1(m1) - bd(id)) - abs(bm1(m1) - rt)) &
   & < 0) go to 110
go to 190
190 rt = rt - bm1(m1)
m1 = m1 - 1
go to 230
200 if ((ibr) <= 0) go to 210
go to 220
210 if ((abs(bm2(m2) - bd(id)) - abs(bm2(m2) - rt)) &
   & < 0) go to 110
go to 220
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
!     beginning of local variable declarations
integer :: ia, ibr, id, j, k, m1, m2, mm, mm2
real :: am, bh, den, rt, v, ym
! prodp applies a sequence of matrix operations to the vector x and
! STORES THE RESULT IN y.   (PERIODIC BOUNDARY CONDITIONS)
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         LENGTH OF THE ARRAY aa.
! x,y        MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS y.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,u,w      WORKING ARRAYS.
! IS         DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
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
20 if ((ia) <= 0) go to 50
go to 30
30 rt = aa(ia)
if (nd == 0) rt = -rt
ia = ia - 1
do j = 1,m
   y(j) = rt*w(j)
end do
50 if ((id) <= 0) go to 280
go to 60
60 rt = bd(id)
id = id - 1
if (id == 0) ibr = 1
! Begin solution to system
bh = b(m) - rt
ym = y(m)
den = b(1) - rt
d(1) = c(1)/den
u(1) = a(1)/den
w(1) = y(1)/den
v = c(m)
if ((mm2 - 2) < 0) go to 90
go to 70
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
if ((den) == 0) go to 110
go to 100
100 w(m) = (ym - am*w(m - 1))/den
go to 120
110 w(m) = 1.
120 w(m - 1) = w(m - 1) - d(m - 1)*w(m)
do j = 2,mm
   k = m - j
   w(k) = w(k) - d(k)*w(k + 1) - u(k)*w(m)
end do
if ((na) <= 0) go to 160
go to 20
140 do j = 1,m
   y(j) = w(j)
end do
ibr = 1
go to  20
160 if ((m1) <= 0) go to 170
go to 180
170 if ((m2) <= 0) go to 140
go to 230
180 if ((m2) <= 0) go to 200
go to 190
190 if ((abs(bm1(m1)) - abs(bm2(m2))) <= 0) &
   & go to 230
go to 200
200 if ((ibr) <= 0) go to 210
go to 220
210 if ((abs(bm1(m1) - bd(id)) - abs(bm1(m1) - rt)) &
   & < 0) go to 140
go to 220
220 rt = rt - bm1(m1)
m1 = m1 - 1
go to 260
230 if ((ibr) <= 0) go to 240
go to 250
240 if ((abs(bm2(m2) - bd(id)) - abs(bm2(m2) - rt)) &
   & < 0) go to 140
go to 250
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
!     beginning of local variable declarations
integer :: ia, id, iflg, j, k, m1, m2, mm
real :: rt
complex :: crt, den, y1, y2
! cprod0 applies a sequence of matrix operations to the vector x and
! STORES THE RESULT IN yy.   (COMPLEX CASE)
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! na         THE LENGTH OF THE ARRAY aa.
! x,yy       MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS yy.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,w,y      WORKING ARRAYS.
! ISGN       DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
do j = 1,m
   y(j) = cmplx(x(j),0.)
end do
mm = m - 1
id = nd
m1 = nm1
m2 = nm2
ia = na
20 iflg = 0
if ((id) <= 0) go to 90
go to 30
30 crt = bd(id)
id = id - 1
! Begin solution to system
d(m) = a(m)/(b(m) - crt)
w(m) = y(m)/(b(m) - crt)
do j = 2,mm
   k = m - j
   den = b(k + 1) - crt - c(k + 1)*d(k + 2)
   d(k + 1) = a(k + 1)/den
   w(k + 1) = (y(k + 1) - c(k + 1)*w(k + 2))/den
end do
den = b(1) - crt - c(1)*d(2)
if ((abs(den)) == 0) go to 60
go to 50
50 y(1) = (y(1) - c(1)*w(2))/den
go to  70
60 y(1) = (1.,0.)
70 do j = 2,m
   y(j) = w(j) - d(j)*y(j - 1)
end do
90 if ((m1) <= 0) go to 100
go to 120
100 if ((m2) <= 0) go to 210
go to 110
110 rt = bm2(m2)
m2 = m2 - 1
go to 170
120 if ((m2) <= 0) go to 130
go to 140
130 rt = bm1(m1)
m1 = m1 - 1
go to 170
140 if ((abs(bm1(m1)) - abs(bm2(m2))) <= 0) &
   & go to 160
go to 150
150 rt = bm1(m1)
m1 = m1 - 1
go to 170
160 rt = bm2(m2)
m2 = m2 - 1
170 y1 = (b(1) - rt)*y(1) + c(1)*y(2)
if ((mm - 2) < 0) go to 200
go to 180
! Matrix multiplication
180 do j = 2,mm
   y2 = a(j)*y(j - 1) + (b(j) - rt)*y(j) + c(j)*y(j + 1)
   y(j - 1) = y1
   y1 = y2
end do
200 y(m) = a(m)*y(m - 1) + (b(m) - rt)*y(m)
y(m - 1) = y1
iflg = 1
go to  20
210 if ((ia) <= 0) go to 240
go to 220
220 rt = aa(ia)
ia = ia - 1
iflg = 1
! Scalar multiplication
do j = 1,m
   y(j) = rt*y(j)
end do
240 if ((iflg) <= 0) go to 250
go to 20
250 do j = 1,m
   yy(j) = real(y(j))
end do
end subroutine cprod0

subroutine cprodp(nd,bd,nm1,bm1,nm2,bm2,na,aa,x,yy,m,a,b,c,d,u,y)
implicit none
integer, intent(in) :: m, na, nd, nm1, nm2
real :: a(*), aa(*), b(*), bm1(*), bm2(*), c(*), x(*)
real, intent(inout) :: yy(*)
complex, intent(inout) :: y(*), d(*), u(*)
complex :: bd(*)
!     beginning of local variable declarations
integer :: ia, id, iflg, j, k, m1, m2, mm, mm2
real :: rt
complex :: v, den, bh, ym, am, y1, y2, yh, crt
! prodp applies a sequence of matrix operations to the vector x and
! stores the result in yy.  (Periodic boundary conditions and
! complex case)
! bd,bm1,bm2 arrays containing roots of certian b polynomials.
! nd,nm1,nm2 the lengths of the arrays bd,bm1,bm2 respectively.
! aa         ARRAY CONTAINING SCALAR MULTIPLIERS OF THE VECTOR x.
! na         THE LENGTH OF THE ARRAY aa.
! x,yy       MATRIX OPERATIONS ARE APPLIED TO x AND THE RESULT IS yy.
! A,b,c      ARRAYS WHICH CONTAIN THE TRIDIAGONAL MATRIX.
! m          THE ORDER OF THE MATRIX.
! d,u,y      WORKING ARRAYS.
! ISGN       DETERMINES WHETHER OR NOT A CHANGE IN SIGN IS MADE.
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
if ((id) <= 0) go to 110
go to 30
30 crt = bd(id)
id = id - 1
iflg = 1
! Begin solution to system
bh = b(m) - crt
ym = y(m)
den = b(1) - crt
d(1) = c(1)/den
u(1) = a(1)/den
y(1) = y(1)/den
v = cmplx(c(m),0.)
if ((mm2 - 2) < 0) go to 60
go to 40
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
if ((abs(den)) == 0) go to 80
go to 70
70 y(m) = (ym - am*y(m - 1))/den
go to  90
80 y(m) = (1.,0.)
90 y(m - 1) = y(m - 1) - d(m - 1)*y(m)
do j = 2,mm
   k = m - j
   y(k) = y(k) - d(k)*y(k + 1) - u(k)*y(m)
end do
110 if ((m1) <= 0) go to 120
go to 140
120 if ((m2) <= 0) go to 230
go to 130
130 rt = bm2(m2)
m2 = m2 - 1
go to 190
140 if ((m2) <= 0) go to 150
go to 160
150 rt = bm1(m1)
m1 = m1 - 1
go to 190
160 if ((abs(bm1(m1)) - abs(bm2(m2))) <= 0) &
   & go to 180
go to 170
170 rt = bm1(m1)
m1 = m1 - 1
go to 190
180 rt = bm2(m2)
m2 = m2 - 1
! Matrix multiplication
190 yh = y(1)
y1 = (b(1) - rt)*y(1) + c(1)*y(2) + a(1)*y(m)
if ((mm - 2) < 0) go to 220
go to 200
200 do j = 2,mm
   y2 = a(j)*y(j - 1) + (b(j) - rt)*y(j) + c(j)*y(j + 1)
   y(j - 1) = y1
   y1 = y2
end do
220 y(m) = a(m)*y(m - 1) + (b(m) - rt)*y(m) + c(m)*yh
y(m - 1) = y1
iflg = 1
go to  20
230 if ((ia) <= 0) go to 260
go to 240
240 rt = aa(ia)
ia = ia - 1
iflg = 1
! Scalar multiplication
do j = 1,m
   y(j) = rt*y(j)
end do
260 if ((iflg) <= 0) go to 270
go to 20
270 do j = 1,m
   yy(j) = real(y(j))
end do
end subroutine cprodp

subroutine compb(n,ierror,an,bn,cn,b,ah,bh)
implicit none
integer :: ierror, n
real :: ah(*), an(*), b(*), bh(*), bn(*), cn(*)
!     beginning of local variable declarations
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
!     compb computes the roots of the b polynomials using tqlrt0,
!     which is a modification of the EISPACK subroutine tqlrat.
!     Ierror is set to 4 if either tqlrt0 fails or A(j+1)*C(j) is
!     less than 0 for some j. ah and bh are temporary work arrays.
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
eps = spmpar(1)
bnorm = abs(bn(1))
do j = 2,nm
   bnorm = max(bnorm,abs(bn(j)))
   arg = an(j)*cn(j - 1)
   if ((arg) < 0) go to 220
   go to 30
30 b(j) = sign(sqrt(arg),an(j))
end do
cnv = eps*bnorm
if = 2**k
kdo = k - 1
do l = 1,kdo
   ir = l - 1
   i2 = 2**ir
   i4 = i2 + i2
   ipl = i4 - 1
   ifd = if - i4
   do i = i4,ifd,i4
      call indxb(i,l,ib,nb)
      if ((nb) <= 0) exit
      go to 50
50    js = i - ipl
      jf = js + nb - 1
      ls = 0
      do j = js,jf
         ls = ls + 1
         bh(ls) = bn(j)
         ah(ls) = b(j)
      end do
      call tqlrt0(nb,bh,ah,ierror)
      if ((ierror) == 0) go to 70
      go to 210
70    lh = ib - 1
      do j = 1,nb
         lh = lh + 1
         b(lh) = -bh(j)
      end do
   end do
end do
do j = 1,nm
   b(j) = -bn(j)
end do
if (npp /= 0) return
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
if ((j2 - n2m2) <= 0) go to 170
go to 190
180 j2 = j2 + 1
j1 = j1 + 1
if ((j2 - n2m2) <= 0) go to 170
go to 190
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
!     Error return
210 ierror = 4
return
220 ierror = 5
end subroutine compb

subroutine tqlrt0(n,d,e2,ierr)
implicit none
integer :: n, ierr
real :: d(n), e2(n)
!     beginning of local variable declarations
integer :: nhalf, ntop
real :: dhold
integer :: ik, k, ncmplx, nm, npp
real :: cnv
integer :: i, j, l, m, ii, l1, mml
real :: b, c, f, g, h, p, r, s, machep
common /cblkt/  npp        ,k          ,machep     ,cnv        , &
   & nm         ,ncmplx     ,ik
!     This subroutine is a modification of the EISPACK subroutine
!     tqlrat. The subroutine finds the eigenvalues of a symmetric
!     tridiagonal matrix BY the rational QL method.
!     On input-
!        n is the order of the matrix,
!        d contains the diagonal elements of the input matrix,
!        e2 CONTAINS THE                SUBDIAGONAL ELEMENTS OF THE
!          input matrix in its last n-1 positions.  e2(1) is arbitrary.
!      On output-
!        d contains the eigenvalues in ascending order.  If an
!          error exit is made, the eigenvalues are correct and
!          ordered for indices 1,2,...ierr-1, but may not be
!          the smallest eigenvalues,
!        e2 has been destroyed,
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!     ********** machep is a machine dependent parameter specifying
!                the relative precision of floating point arithmetic.
!                **********
ierr = 0
if (n == 1) go to 150
do i = 2,n
   e2(i - 1) = e2(i)*e2(i)
end do
f = 0.0
b = 0.0
e2(n) = 0.0
do l = 1,n
   j = 0
   h = machep*(abs(d(l)) + sqrt(e2(l)))
   if (b > h) go to  20
   b = h
   c = b*b
!     ********** Look for small squared sub-diagonal element **********
20 do m = l,n
      if (e2(m) <= c) exit
!     ********** e2(n) is always zero, so there is no exit
!                through the bottom of the loop **********
   end do
   if (m == l) go to  80
50 if (j == 30) go to 140
   j = j + 1
!     ********** Form shift **********
   l1 = l + 1
   s = sqrt(e2(l))
   g = d(l)
   p = (d(l1) - g)/(2.0*s)
   r = sqrt(p*p + 1.0)
   d(l) = s/(p + sign(r,p))
   h = g - d(l)
   do i = l1,n
      d(i) = d(i) - h
   end do
   f = f + h
!     ********** RATIONAL QL TRANSFORMATION **********
   g = d(m)
   if (g == 0.0) g = b
   h = g
   s = 0.0
   mml = m - l
!     ********** FOR i=m-1 STEP -1 UNTIL l DO -- **********
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
   e2(l) = s*g
   d(l) = h
!     ********** Guard against UNDERFLOWED h **********
   if (h == 0.0) go to  80
   if (abs(e2(l)) <= abs(c/h)) go to  80
   e2(l) = h*e2(l)
   if (e2(l) /= 0.0) go to  50
80 p = d(l) + f
!     ********** Order eigenvalues **********
   if (l == 1) go to 100
!     ********** FOR i=l STEP -1 UNTIL 2 DO -- **********
   do ii = 2,l
      i = l + 2 - ii
      if (p >= d(i - 1)) go to 110
      d(i) = d(i - 1)
   end do
100 i = 1
110 d(i) = p
end do
if (abs(d(n)) >= abs(d(1))) go to 150
nhalf = n/2
do i = 1,nhalf
   ntop = n - i
   dhold = d(i)
   d(i) = d(ntop + 1)
   d(ntop + 1) = dhold
end do
go to 150
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
140 ierr = l
150 return
end subroutine tqlrt0

subroutine ppadd(n,ierror,a,c,cbp,bp,bh)
implicit none
integer :: ierror, n
real :: a(*), bh(*), bp(*), c(*)
complex :: cbp(*)
!     beginning of local variable declarations
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
real :: nswc_ai_r4
!     ppadd computes the eigenvalues of the periodic tridiagonal matrix
!     with coefficients an,BN,CN
! n   IS THE ORDER OF THE bh AND bp POLYNOMIALS.
!     On output bp contains the eigenvalues.
! cbp is the same as bp except type complex.
! bh  is used to temporarily store the roots of the B hat polynomial
!     which enters through bp.
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
scnv = sqrt(cnv)
iz = n
izm = iz - 1
izm2 = iz - 2
nswc_ai_r4 = bp(n) - bp(1)
if (nswc_ai_r4 < 0) go to 10
if (nswc_ai_r4 == 0) go to 420
go to 30
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
if ((modiz) == 0) go to 70
go to 60
60 nswc_ai_r4 = a(1)
if (nswc_ai_r4 < 0) go to 100
if (nswc_ai_r4 == 0) go to 420
go to 70
70 xl = bh(1)
db = bh(3) - bh(1)
80 xl = xl - db
if ((psgf(xl , iz , c , a , bh)) <= 0) go to 80
go to 90
90 sgn = -1.
cbp(1) = cmplx(bsrh(xl,bh(1),iz,c,a,bh,psgf,sgn),0.)
is = 2
100 if = iz - 1
if ((modiz) == 0) go to 120
go to 110
110 nswc_ai_r4 = a(1)
if (nswc_ai_r4 < 0) go to 120
if (nswc_ai_r4 == 0) go to 420
go to 150
120 xr = bh(iz)
db = bh(iz) - bh(iz - 2)
130 xr = xr + db
if ((psgf(xr , iz , c , a , bh)) < 0) go to 130
go to 140
140 sgn = 1.
cbp(iz) = cmplx(bsrh(bh(iz),xr,iz,c,a,bh,psgf,sgn),0.)
if = iz - 2
150 do ig = is,if,2
   xl = bh(ig)
   xr = bh(ig + 1)
   sgn = -1.
   xm = bsrh(xl,xr,iz,c,a,bh,ppspf,sgn)
   psg = psgf(xm,iz,c,a,bh)
   if ((abs(psg) - eps) <= 0) go to 180
   go to 160
160 nswc_ai_r4 = psg * ppsgf(xm , iz , c , a , bh)
   if (nswc_ai_r4 < 0) go to 170
   if (nswc_ai_r4 == 0) go to 180
   go to 190
!     Case of a real zero
170 sgn = 1.
   cbp(ig) = cmplx(bsrh(bh(ig),xm,iz,c,a,bh,psgf,sgn),0.)
   sgn = -1.
   cbp(ig + 1) = cmplx(bsrh(xm,bh(ig + 1),iz,c,a,bh,psgf,sgn),0.)
   go to 360
!     Case of a multiple zero
180 cbp(ig) = cmplx(xm,0.)
   cbp(ig + 1) = cmplx(xm,0.)
   go to 360
!     Case of a complex zero
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
   if ((modiz) == 0) go to 220
   go to 230
220 f = (1.,0.) - fsg - hsg
   go to 240
230 f = (1.,0.) + fsg + hsg
240 i3 = 0
   if ((abs(fp)) <= 0) go to 260
   go to 250
250 i3 = 1
   r3 = -f/fp
260 i2 = 0
   if ((abs(fpp)) <= 0) go to 320
   go to 270
270 i2 = 1
   cdis = sqrt(fp**2 - 2.*f*fpp)
   r1 = cdis - fp
   r2 = -fp - cdis
   if ((abs(r1) - abs(r2)) <= 0) go to 290
   go to 280
280 r1 = r1/fpp
   go to 300
290 r1 = r2/fpp
300 r2 = 2.*f/fpp/r1
   if (abs(r2) < abs(r1)) r1 = r2
   if ((i3) <= 0) go to 330
   go to 310
310 if (abs(r3) < abs(r1)) r1 = r3
   go to 330
320 r1 = r3
330 cx = cx + r1
   it = it + 1
   if (it > 50) go to 420
   if (abs(r1) > scnv) go to 200
   if ((icv) <= 0) go to 340
   go to 350
340 icv = 1
   go to 200
350 cbp(ig) = cx
   cbp(ig + 1) = conjg(cx)
360 continue
end do
nswc_ai_r4 = abs(cbp(n)) - abs(cbp(1))
if (nswc_ai_r4 < 0) go to 370
if (nswc_ai_r4 == 0) go to 420
go to 390
370 nhalf = n/2
do j = 1,nhalf
   nt = n - j
   cx = cbp(j)
   cbp(j) = cbp(nt + 1)
   cbp(nt + 1) = cx
end do
390 ncmplx = 1
do j = 2,iz
   if ((aimag(cbp(j))) == 0) go to 400
   go to 430
400 continue
end do
ncmplx = 0
do j = 2,iz
   bp(j) = real(cbp(j))
end do
go to 430
420 ierror = 4
430 continue
end subroutine ppadd

function psgf(x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
real :: psgf
!     beginning of local variable declarations
integer :: j
real :: dd, fsg, hsg
fsg = 1.
hsg = 1.
do j = 1,iz
   dd = 1./(x - bh(j))
   fsg = fsg*a(j)*dd
   hsg = hsg*c(j)*dd
end do
if ((mod(iz , 2)) == 0) go to 20
go to 30
20 psgf = 1. - fsg - hsg
return
30 psgf = 1. + fsg + hsg
end function psgf

function bsrh(xll,xrr,iz,c,a,bh,f,sgn)
implicit none
integer :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: sgn
real :: xll, xrr
real :: f
real :: bsrh
!     beginning of local variable declarations
real :: dx, x, xl, xr
integer :: ik, k, ncmplx, nm, npp
real :: cnv, eps
real :: nswc_ai_r4
common /cblkt/  npp        ,k          ,eps        ,cnv        , &
   & nm         ,ncmplx     ,ik
xl = xll
xr = xrr
dx = .5*abs(xr - xl)
10 x = .5*(xl + xr)
nswc_ai_r4 = sgn * f(x , iz , c , a , bh)
if (nswc_ai_r4 < 0) go to 30
if (nswc_ai_r4 == 0) go to 50
go to 20
20 xr = x
go to  40
30 xl = x
40 dx = .5*dx
if ((dx - cnv) <= 0) go to 50
go to 10
50 bsrh = .5*(xl + xr)
end function bsrh

function ppsgf(x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
real :: ppsgf
!     beginning of local variable declarations
integer :: j
real :: sum
sum = 0.
do j = 1,iz
   sum = sum - 1./(x - bh(j))**2
end do
ppsgf = sum
end function ppsgf

function ppspf(x,iz,c,a,bh)
implicit none
integer, intent(in) :: iz
real :: a(*), bh(*), c(*)
real, intent(in) :: x
real :: ppspf
!     beginning of local variable declarations
integer :: j
real :: sum
sum = 0.
do j = 1,iz
   sum = sum + 1./(x - bh(j))
end do
ppspf = sum
end function ppspf

pure subroutine urget(n, ibeg, iend, ix, l, ierr)
implicit none
integer, intent(in) :: ibeg, iend
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
integer, intent(inout) :: l(n)
!     beginning of local variable declarations
integer :: i, k, leftlo, fhi, xalo, xhi
double precision :: c, m, t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
double precision, parameter :: s = .4656612877413d-09
!-----------------------------------------------------------------------
!               Uniform random selection of values from
!                       a finite set of integers
!                           ----------------
!     urget selects n values from the set of integers from ibeg to
!     iend where ibeg .LT. iend. The selection is performed so that
!     any integer is equally likely to occur with proability 1/m
!     where m = iend - ibeg + 1. As n becomes large the mean and
!     variance of the values will closely approximate the mean and
!     variance of the discrete uniform distribution where
!               mean = ibeg + (iend - ibeg)/2
!               variance = (m**2 - 1)/12 .
!     Input...
!       n     - Number of variates to be generated
!       ibeg  - Lower limit of generation interval
!       iend  - Upper limit of generation interval
!       ix    - Integer seed used to initialize the
!               sequence of variates generated
!     output...
!       ix    - Seed for obtaining more variates
!       l     - Output array of dimension n containing
!               the generated integers
!       ierr  - Input error flag
!               ( 0 - No input errors
!                 1 - n .LE. 0
!                 2 - ibeg .GE. iend  OR  m .GE. p.
!                 3 - Seed out of range )
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
ierr = 0
c = m*s
do i = 1,n
!        Use the linus schrage code to obtain the next seed ix.
!        Reference. Schrage, linus, a more portable Fortran
!        random number generator, ACM Trans. Math Software 5
!        (1979), PP. 132-138.
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
!        Map ix to an integer in the closed interval (ibeg,iend).
!        This mapping is 1-1 only when m = p - 1, in which case
!        ix is mapped to the value (ibeg - 1) + ix.
   t = ix
   k = c*t
   l(i) = ibeg + k
end do
return
!                         Error return
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
end subroutine urget

pure subroutine urng(ix, x, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: x(n)
!     beginning of local variable declarations
integer :: k, l, leftlo, fhi, xalo, xhi
real :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
real, parameter :: s = .465661e-09
!-----------------------------------------------------------------------
!         Uniform random number generator using the recursion
!                       ix = ix*a MOD p
!     it is assumed that 0 .LT. ix .LT. p
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
!                 Get 15 high order bits of ix
   xhi = ix/b16
!           Get 16 lower bits of ix and multiply with A
   xalo = (ix - xhi*b16)*a
!             Get 15 high order bits of the product
   leftlo = xalo/b16
!               Form the 31 highest bits of a*ix
   fhi = xhi*a + leftlo
!           Obtain the overflow past the 31ST bit of a*ix
   k = fhi/b15
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!                      Add p if necessary
   if (ix < 0) ix = ix + p
!     Rescale ix, to interpret it as a value between 0 and 1.
!     The scale factor s is selected to be as near 1/p as is
!     appropriate in order that the floating value for ix = 1,
!     namely s, be roughly the same distance from 0 as (p-1)*s
!     is from 1. The current value for s assures us that x(l)
!     is less than 1 for any floating point arithmetic of 6
!     or more digits.
   t = ix
   x(l) = s*t
end do
return
!                         Error return
100 ierr = 1
return
110 ierr = 2
end subroutine urng

pure subroutine durng(ix, x, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: x(n)
!     beginning of local variable declarations
integer :: k, l, leftlo, fhi, xalo, xhi
double precision :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
double precision, parameter :: s = .465661d-09
!-----------------------------------------------------------------------
!         Uniform random number generator using the recursion
!                       ix = ix*a MOD p
!     it is assumed that 0 .LT. ix .LT. p
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
!                 Get 15 high order bits of ix
   xhi = ix/b16
!           Get 16 lower bits of ix and multiply with A
   xalo = (ix - xhi*b16)*a
!             Get 15 high order bits of the product
   leftlo = xalo/b16
!               Form the 31 highest bits of a*ix
   fhi = xhi*a + leftlo
!           Obtain the overflow past the 31ST bit of a*ix
   k = fhi/b15
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!                      Add p if necessary
   if (ix < 0) ix = ix + p
!     Rescale ix, to interpret it as a value between 0 and 1.
!     The scale factor s is selected to be as near 1/p as is
!     appropriate in order that the floating value for ix = 1,
!     namely s, be roughly the same distance from 0 as (p-1)*s
!     is from 1. The current value for s assures us that x(l)
!     is less than 1 for any double precision arithmetic.
   t = ix
   x(l) = s*t
end do
return
!                         Error return
100 ierr = 1
return
110 ierr = 2
end subroutine durng

pure elemental subroutine urng0(ix, u, v)
implicit none
integer, intent(inout) :: ix
real, intent(inout) :: u, v
!     beginning of local variable declarations
integer :: k, leftlo, fhi, xalo, xhi
real :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!                       ix = ix*a MOD p
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
!                 Get 15 high order bits of ix
xhi = ix/b16
!           Get 16 lower bits of ix and multiply with A
xalo = (ix - xhi*b16)*a
!             Get 15 high order bits of the product
leftlo = xalo/b16
!               Form the 31 highest bits of a*ix
fhi = xhi*a + leftlo
!           Obtain the overflow past the 31ST bit of a*ix
k = fhi/b15
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!                      Add p if necessary
if (ix < 0) ix = ix + p
!         Rescale ix, to interpret it as a value between 0 and 1
t = p
if (ix > p0) go to 10
u = ix
u = u/t
v = 0.5 + (0.5 - u)
return
10 v = p - ix
v = v/t
u = 0.5 + (0.5 - v)
end subroutine urng0

pure elemental subroutine durng0(ix, u, v)
implicit none
integer, intent(inout) :: ix
double precision, intent(inout) :: u, v
!     beginning of local variable declarations
integer :: k, leftlo, fhi, xalo, xhi
double precision :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!                       ix = ix*a MOD p
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
!                 Get 15 high order bits of ix
xhi = ix/b16
!           Get 16 lower bits of ix and multiply with A
xalo = (ix - xhi*b16)*a
!             Get 15 high order bits of the product
leftlo = xalo/b16
!               Form the 31 highest bits of a*ix
fhi = xhi*a + leftlo
!           Obtain the overflow past the 31ST bit of a*ix
k = fhi/b15
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!                      Add p if necessary
if (ix < 0) ix = ix + p
!         Rescale ix, to interpret it as a value between 0 and 1
t = p
if (ix > p0) go to 10
u = ix
u = u/t
v = 0.5d0 + (0.5d0 - u)
return
10 v = p - ix
v = v/t
u = 0.5d0 + (0.5d0 - v)
end subroutine durng0

pure elemental subroutine urng1(ix, u, v, d)
implicit none
integer, intent(inout) :: ix
real, intent(inout) :: d, u, v
!     beginning of local variable declarations
integer :: j, k, leftlo, fhi, xalo, xhi
real :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!                       ix = ix*a MOD p
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
!                 Get 15 high order bits of ix
xhi = ix/b16
!           Get 16 lower bits of ix and multiply with A
xalo = (ix - xhi*b16)*a
!             Get 15 high order bits of the product
leftlo = xalo/b16
!               Form the 31 highest bits of a*ix
fhi = xhi*a + leftlo
!           Obtain the overflow past the 31ST bit of a*ix
k = fhi/b15
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!                      Add p if necessary
if (ix < 0) ix = ix + p
!         Rescale ix, to interpret it as a value between 0 and 1
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
end subroutine urng1

pure elemental subroutine durng1(ix, u, v, d)
implicit none
integer, intent(inout) :: ix
double precision, intent(inout) :: u, v, d
!     beginning of local variable declarations
integer :: j, k, leftlo, fhi, xalo, xhi
double precision :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
!-----------------------------------------------------------------------
!       Uniform random number generator using the recursion
!                       ix = ix*a MOD p
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
!                 Get 15 high order bits of ix
xhi = ix/b16
!           Get 16 lower bits of ix and multiply with A
xalo = (ix - xhi*b16)*a
!             Get 15 high order bits of the product
leftlo = xalo/b16
!               Form the 31 highest bits of a*ix
fhi = xhi*a + leftlo
!           Obtain the overflow past the 31ST bit of a*ix
k = fhi/b15
!             Assemble all the parts and presubtract p
!                  the parentheses are essential
ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
!                      Add p if necessary
if (ix < 0) ix = ix + p
!         Rescale ix, to interpret it as a value between 0 and 1
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
end subroutine durng1

pure subroutine urng2(ix, x, y, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: k, l, leftlo, fhi, xalo, xhi
real :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
real, parameter :: s = .465661e-09
!-----------------------------------------------------------------------
!         Generation of uniform random points (x(I),y(I))
!                     FOR I = 1,...,n WHERE
!                      0 .LT. x(I) .LT. 1
!                      0 .LT. y(I) .LT. 1
!     it is assumed that 0 .LT. ix .LT. p
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
!         See the comments in the subroutine urng for the
!                statements in the following loop
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
!                         Error return
100 ierr = 1
return
110 ierr = 2
end subroutine urng2

pure subroutine durng2(ix, x, y, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: x(n), y(n)
!     beginning of local variable declarations
integer :: k, l, leftlo, fhi, xalo, xhi
double precision :: t
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
double precision, parameter :: s = .465661d-09
!-----------------------------------------------------------------------
!         Generation of uniform random points (x(I),y(I))
!                     FOR I = 1,...,n WHERE
!                      0 .LT. x(I) .LT. 1
!                      0 .LT. y(I) .LT. 1
!     it is assumed that 0 .LT. ix .LT. p
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
!         See the comments in the subroutine durng for the
!                 statements in the following loop
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
!                         Error return
100 ierr = 1
return
110 ierr = 2
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
!          Generation of n uniform random points (x(I),y(I))
!              in the unit circle centered at the origin
!-----------------------------------------------------------------------
!------------------
call rcir1(n, ix, x, 1, y, 1, ierr)
end subroutine rcir

pure subroutine rcir1(n, ix, x, kx, y, ky, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, ky, n
real, intent(inout) :: x(*), y(*)
!     beginning of local variable declarations
integer :: i, i1, i2, j, k, leftlo, fhi, xalo, xhi
real :: r, u, v
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
real, parameter :: s = .931322e-09
!-----------------------------------------------------------------------
!      Generation of n uniform random points in the unit circle
!      centered at the origin. The abscissa and ordinate of the
!      i-TH point are stored in x(i1) and y(i2) where
!                      i1 = 1 + kx*(i - 1)
!                      i2 = 1 + ky*(i - 1) .
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
i1 = 1
i2 = 1
do i = 1,n
!        Use the linus schrage code to obtain new seeds ix.
!        Reference. Schrage, linus, a more portable Fortran
!        random number generator, ACM Trans. Math Software 5
!        (1979), PP. 132-138.
10 xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   j = ix
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
!        Subtract the midpoint p0 and rescale so that the
!          uniform variates are in the interval (-1,1).
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!         Check if the point (u,v) is in the unit circle
   r = (u*u + v*v) - 1.0
   if (r >= 0.0) go to 10
!            Store the point when it is in the circle
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!                          Error return
100 ierr = 1
return
110 ierr = 2
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
!          Generation of n uniform random points (x(I),y(I))
!              in the unit circle centered at the origin
!-----------------------------------------------------------------------
!------------------
call drcir1(n, ix, x, 1, y, 1, ierr)
end subroutine drcir

pure subroutine drcir1(n, ix, x, kx, y, ky, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, ky, n
double precision, intent(inout) :: x(*), y(*)
!     beginning of local variable declarations
integer :: i, i1, i2, j, k, leftlo, fhi, xalo, xhi
double precision :: r, u, v
integer, parameter :: a = 16807
integer, parameter :: b15 = 32768
integer, parameter :: b16 = 65536
integer, parameter :: p = 2147483647
integer, parameter :: p0 = 1073741823
double precision, parameter :: s = .931322d-09
!-----------------------------------------------------------------------
!      Generation of n uniform random points in the unit circle
!      centered at the origin. The abscissa and ordinate of the
!      i-TH point are stored in x(i1) and y(i2) where
!                      i1 = 1 + kx*(i - 1)
!                      i2 = 1 + ky*(i - 1) .
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
i1 = 1
i2 = 1
do i = 1,n
!        Use the linus schrage code to obtain new seeds ix.
!        Reference. Schrage, linus, a more portable Fortran
!        random number generator, ACM Trans. Math Software 5
!        (1979), PP. 132-138.
10 xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
   j = ix
   xhi = ix/b16
   xalo = (ix - xhi*b16)*a
   leftlo = xalo/b16
   fhi = xhi*a + leftlo
   k = fhi/b15
   ix = (((xalo - leftlo*b16) - p) + (fhi - k*b15)*b16) + k
   if (ix < 0) ix = ix + p
!        Subtract the midpoint p0 and rescale so that the
!          uniform variates are in the interval (-1,1).
   u = j - p0
   u = s*u
   v = ix - p0
   v = s*v
!         Check if the point (u,v) is in the unit circle
   r = (u*u + v*v) - 1.d0
   if (r >= 0.d0) go to 10
!            Store the point when it is in the circle
   x(i1) = u
   y(i2) = v
   i1 = i1 + kx
   i2 = i2 + ky
end do
return
!                          Error return
100 ierr = 1
return
110 ierr = 2
end subroutine drcir1

pure subroutine rnor(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: a(n)
!     beginning of local variable declarations
integer :: i, m
real :: r, s, u, v, t(2)
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
if (n == 1) go to 20
m = n/2
call rcir1(m, ix, a(1), 2, a(2), 2, ierr)
m = m + m
!                  Obtain the first m variates
do i = 1,m,2
   u = a(i)
   v = a(i + 1)
   r = u*u + v*v
   s = sqrt(-2.0*log(r)/r)
   a(i) = s*u
   a(i + 1) = s*v
end do
if (m == n) return
!            Obtain the last variate (when n is odd)
20 call rcir1(1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = sqrt(-2.0*log(r)/r)
a(n) = s*t(1)
return
!                         Error return
100 ierr = 1
return
110 ierr = 2
end subroutine rnor

pure subroutine drnor(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: a(n)
!     beginning of local variable declarations
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
if (n == 1) go to 20
m = n/2
call drcir1(m, ix, a(1), 2, a(2), 2, ierr)
m = m + m
!                  Obtain the first m variates
do i = 1,m,2
   u = a(i)
   v = a(i + 1)
   r = u*u + v*v
   s = sqrt(-2.d0*log(r)/r)
   a(i) = s*u
   a(i + 1) = s*v
end do
if (m == n) return
!            Obtain the last variate (when n is odd)
20 call drcir1(1, ix, t(1), 1, t(2), 1, ierr)
r = t(1)*t(1) + t(2)*t(2)
s = sqrt(-2.d0*log(r)/r)
a(n) = s*t(1)
return
!                         Error return
100 ierr = 1
return
110 ierr = 2
end subroutine drnor

pure subroutine nrng(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
real, intent(inout) :: a(n)
!     beginning of local variable declarations
integer :: i, m
real :: phi, r, temp(1)
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
call urng(ix,a,n,ierr)
if (ierr /= 0) return
if (n == 1) go to 20
m = n/2
m = m + m
do i = 1,m,2
   r = sqrt(-2.0*log(a(i)))
   phi = pi2*a(i + 1)
   a(i) = r*cos(phi)
   a(i + 1) = r*sin(phi)
end do
if (m == n) return
20 call urng(ix,temp,1,ierr)
r = sqrt(-2.0*log(a(n)))
a(n) = r*cos(pi2*temp(1))
end subroutine nrng

pure subroutine dnrng(ix, a, n, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: n
double precision, intent(inout) :: a(n)
!     beginning of local variable declarations
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
call durng(ix, a, n, ierr)
if (ierr /= 0) return
if (n == 1) go to 20
m = n/2
m = m + m
do i = 1,m,2
   r = sqrt(-2.d0*log(a(i)))
   phi = pi2*a(i + 1)
   a(i) = r*cos(phi)
   a(i + 1) = r*sin(phi)
end do
if (m == n) return
20 call durng(ix, temp, 1, ierr)
r = sqrt(-2.d0*log(a(n)))
a(n) = r*cos(pi2*temp(1))
end subroutine dnrng

pure subroutine nrvg(mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
real, intent(inout) :: a(*)
real, intent(in) :: fmu(m)
real, intent(inout) :: x(kx,n)
!     beginning of local variable declarations
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a.
!                          ---------------
!     Input...
!        mo      - Integer specifying if the routine is
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. set mo = 0 On an initial call to
!                  the routine, and mo .NE. 0 on a later
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!        ix      - Integer seed used to initialize the
!                  sequence of variates.
!        n       - Number of random vectors to be generated.
!        m       - Length of the desired random vectors.
!                  It is assumed that m .GE. 2. m should
!                  not be modified by the user on a later
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!        a       - Variance-covariance matrix of order m.
!                  A is a symmetric positive definite matrix
!                  stored in packed form. The array a must
!                  be of length (m*(m + 1))/2 or larger.
!                  On an initial call to the routine, the
!                  lower triangular matrix in the Cholesky
!                  decomposition of a replaces the original
!                  data in the array a. a should never be
!                  modified by the user on a later call to
!                  THE ROUTINE (WHEN mo .NE. 0).
!        fmu     - Mean vector of dimension m of the
!                  multivariate normal distribution
!        kx      - Row dimension of the matrix x (see the
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!     Output...
!        ix      - Seed to be used for obtaining more variates.
!        x       - Output array of dimension kx by n containing
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a is not positive definite
!                   4 - Seed out of range         )
!-----------------------------------------------------------------------
!        ***REFERENCES***
!     Fishman, george S., Concepts and methods in discrete event
!     digital simulation, john wiley and sons, new york, 1973,
!     PP. 215 - 217.
!     Morrison, Donald F., Multivariate statistical methods,
!     mcgraw-hill, new york, 1967, PP. 80 - 81.
!     Scheuer, E. and Stoller, D. S., On the generation of
!     normal random vectors, Technometrics, volume 4, may, 1962,
!     PP. 278 - 281.
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (m <= 1 .or. m > kx) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!           Compute the lower triangular matrix
!           l having positive diagonal elements
!           and satisfying a = l*transpose(l).
if (mo /= 0) go to 10
call sppfa(a, m, ierr)
if (ierr /= 0) go to 120
!           Generate the n random normal vectors
10 ldim = (m*(m + 1))/2
do j = 1,n
   call rnor(ix, x(1,j), m, ierr)
!         Obtain the components of the j-TH vector
!                    in reverse order
   l0 = ldim
   i = m
   do ii = 1,m
      l0 = l0 - i
      l = l0
      sum = 0.0
      do k = 1,i
         l = l + 1
         sum = sum + a(l)*x(k,j)
      end do
      x(i,j) = sum + fmu(i)
      i = i - 1
   end do
end do
return
!                      Error return
100 ierr = 1
return
110 ierr = 2
return
120 ierr = 3
return
130 ierr = 4
end subroutine nrvg

pure subroutine nrvg1(mo, ix, n, m, a, fmu, x, kx, ierr)
implicit none
integer, intent(inout) :: ierr, ix
integer, intent(in) :: kx, m, mo, n
real, intent(inout) :: a(m)
real, intent(in) :: fmu(m)
real, intent(inout) :: x(kx,n)
!     beginning of local variable declarations
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a. it is
!           assumed that A is a diagonal matrix.
!                          ---------------
!     Input...
!        mo      - Integer specifying if the routine is
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. set mo = 0 On an initial call to
!                  the routine, and mo .NE. 0 on a later
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!        ix      - Integer seed used to initialize the
!                  sequence of variates.
!        n       - Number of random vectors to be generated.
!        m       - Length of the desired random vectors.
!                  It is assumed that m .GE. 2. m should
!                  not be modified by the user on a later
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!        a       - Variance-covariance matrix of order m.
!                  A is a diagonal matrix with positive
!                  diagonal elements. The diagonal elements
!                  are stored in the array a. a is an array
!                  of length m or larger.
!                  On an initial call to the routine, the
!                  square roots of the elements of a replace
!                  the original data in A. A should not be
!                  modified by the user on a later call to
!                  THE ROUTINE (WHEN mo .NE. 0).
!        fmu     - Mean vector of dimension m of the
!                  multivariate normal distribution
!        kx      - Row dimension of the matrix x (see the
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!     Output...
!        ix      - Seed to be used for obtaining more variates.
!        x       - Output array of dimension kx by n containing
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a(i) .LE. 0 for some i
!                   4 - Seed out of range      )
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (m <= 1 .or. m > kx) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!        Compute the roots of the diagonal elements
if (mo /= 0) go to 20
do i = 1,m
   if (a(i) <= 0.0) go to 120
   a(i) = sqrt(a(i))
end do
!           Generate the n random normal vectors
20 do j = 1,n
   call rnor(ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!                       Error return
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
!     beginning of local variable declarations
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a.
!                          ---------------
!     Input...
!        mo      - Integer specifying if the routine is
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. set mo = 0 On an initial call to
!                  the routine, and mo .NE. 0 on a later
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!        ix      - Integer seed used to initialize the
!                  sequence of variates.
!        n       - Number of random vectors to be generated.
!        m       - Length of the desired random vectors.
!                  It is assumed that m .GE. 2. m should
!                  not be modified by the user on a later
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!        a       - Variance-covariance matrix of order m.
!                  A is a symmetric positive definite matrix
!                  stored in packed form. The array a must
!                  be of length (m*(m + 1))/2 or larger.
!                  On an initial call to the routine, the
!                  lower triangular matrix in the Cholesky
!                  decomposition of a replaces the original
!                  data in the array a. a should never be
!                  modified by the user on a later call to
!                  THE ROUTINE (WHEN mo .NE. 0).
!        fmu     - Mean vector of dimension m of the
!                  multivariate normal distribution
!        kx      - Row dimension of the matrix x (see the
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!     Output...
!        ix      - Seed to be used for obtaining more variates.
!        x       - Output array of dimension kx by n containing
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a is not positive definite
!                   4 - Seed out of range         )
!-----------------------------------------------------------------------
!        ***REFERENCES***
!     Fishman, george S., Concepts and methods in discrete event
!     digital simulation, john wiley and sons, new york, 1973,
!     PP. 215 - 217.
!     Morrison, Donald F., Multivariate statistical methods,
!     mcgraw-hill, new york, 1967, PP. 80 - 81.
!     Scheuer, E. and Stoller, D. S., On the generation of
!     normal random vectors, Technometrics, volume 4, may, 1962,
!     PP. 278 - 281.
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (m <= 1 .or. m > kx) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!           Compute the lower triangular matrix
!           l having positive diagonal elements
!           and satisfying a = l*transpose(l).
if (mo /= 0) go to 10
call dppfa(a, m, ierr)
if (ierr /= 0) go to 120
!           Generate the n random normal vectors
10 ldim = (m*(m + 1))/2
do j = 1,n
   call drnor(ix, x(1,j), m, ierr)
!         Obtain the components of the j-TH vector
!                    in reverse order
   l0 = ldim
   i = m
   do ii = 1,m
      l0 = l0 - i
      l = l0
      sum = 0.d0
      do k = 1,i
         l = l + 1
         sum = sum + a(l)*x(k,j)
      end do
      x(i,j) = sum + fmu(i)
      i = i - 1
   end do
end do
return
!                      Error return
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
!     beginning of local variable declarations
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
!           Generation of n random normal vectors of length m
!           from a multivariate normal distribution with mean
!           vector fmu and variance-covariance matrix a. it is
!           assumed that A is a diagonal matrix.
!                          ---------------
!     Input...
!        mo      - Integer specifying if the routine is
!                  being called for the first time to
!                  generate normal vectors from a matrix
!                  A. set mo = 0 On an initial call to
!                  the routine, and mo .NE. 0 on a later
!                  CALL TO GENERATE MORE VECTORS FROM
!                  the same matrix a.
!        ix      - Integer seed used to initialize the
!                  sequence of variates.
!        n       - Number of random vectors to be generated.
!        m       - Length of the desired random vectors.
!                  It is assumed that m .GE. 2. m should
!                  not be modified by the user on a later
!                  CALL TO THE ROUTINE (WHEN mo .NE. 0).
!        a       - Variance-covariance matrix of order m.
!                  A is a diagonal matrix with positive
!                  diagonal elements. The diagonal elements
!                  are stored in the array a. a is an array
!                  of length m or larger.
!                  On an initial call to the routine, the
!                  square roots of the elements of a replace
!                  the original data in A. A should not be
!                  modified by the user on a later call to
!                  THE ROUTINE (WHEN mo .NE. 0).
!        fmu     - Mean vector of dimension m of the
!                  multivariate normal distribution
!        kx      - Row dimension of the matrix x (see the
!                  description of x below). It is assumed
!                  THAT kx .GE. m.
!     Output...
!        ix      - Seed to be used for obtaining more variates.
!        x       - Output array of dimension kx by n containing
!                  the n generated random normal vectors. The
!                  j-TH vector is stored in the j-TH column of
!                  x FOR j = 1,...,n.
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - m .LE. 1  OR  m .GT. kx
!                   3 - a(i) .LE. 0 for some i
!                   4 - Seed out of range      )
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (m <= 1 .or. m > kx) go to 110
if (ix <= 0 .or. ix >= max) go to 130
!        Compute the roots of the diagonal elements
if (mo /= 0) go to 20
do i = 1,m
   if (a(i) <= 0.d0) go to 120
   a(i) = sqrt(a(i))
end do
!           Generate the n random normal vectors
20 do j = 1,n
   call drnor(ix, x(1,j), m, ierr)
   do i = 1,m
      x(i,j) = a(i)*x(i,j) + fmu(i)
   end do
end do
return
!                       Error return
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
!     beginning of local variable declarations
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
!              ***Subroutine purpose and description***
!           ranexp generates n exponential random variates from an
!           exponential distribution with parameter a (a .GT. 0).
!           A is the mean of the distribution.  Hence, A is interpreted
!           as the average rate per unit of time or the average time
!           to failure (average lifetime).
!           Form of the exponential probability density function...
!                   f(x) = (1/a) * exp(-x/a)      , x .ge. 0
!                                                   a .GT. 0
!           mean and variance of the exponential distribution...
!                    mean = a
!                    variance = a**2
!           ***parameter list***
!           input...
!           n       - Number of variates to be generated
!           a       - Mean of the exponential distribution
!           iseed   - Integer seed used to initialize the
!                     sequence of variates generated
!           output...
!           iseed   - Seed to be used on the next call to the
!                     routine
!           x       - Output array of dimension n containing
!                     the generated real variates
!           ierror  - Input error flag
!                     ( 0 - No input errors
!                       1 - n .LE. 0
!                       2 - a .LE. 0.0
!                       3 - Seed out of range )
!           ***REFERENCE***
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           P. 203.
!        Check to ensure that the desired number of variates is within
!        acceptable range
if (n <= 0) go to 100
!        Check to ensure that the exponential parameter HAS been
!        properly specified
if (a <= 0.0) go to 110
!        Generation of uniform random variates
call urng(iseed, x, n, ierror)
if (ierror /= 0) go to 120
!        Loop which generates the n desired variates
do i = 1,n
   x(i) = - a*log(x(i))
end do
return
!              Error return
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
!     beginning of local variable declarations
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
!              ***Subroutine purpose and description***
!           drnexp generates n exponential random variates from an
!           exponential distribution with parameter a (a .GT. 0).
!           A is the mean of the distribution.  Hence, A is interpreted
!           as the average rate per unit of time or the average time
!           to failure (average lifetime).
!           Form of the exponential probability density function...
!                   f(x) = (1/a) * exp(-x/a)      , x .ge. 0
!                                                   a .GT. 0
!           mean and variance of the exponential distribution...
!                    mean = a
!                    variance = a**2
!           ***parameter list***
!           input...
!           n       - Number of variates to be generated
!           a       - Mean of the exponential distribution
!           iseed   - Integer seed used to initialize the
!                     sequence of variates generated
!           output...
!           iseed   - Seed to be used on the next call to the
!                     routine
!           x       - Output array of dimension n containing
!                     the generated real variates
!           ierror  - Input error flag
!                     ( 0 - No input errors
!                       1 - n .LE. 0
!                       2 - a .LE. 0.0
!                       3 - Seed out of range )
!           ***REFERENCE***
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           P. 203.
!        Check to ensure that the desired number of variates is within
!        acceptable range
if (n <= 0) go to 100
!        Check to ensure that the exponential parameter HAS been
!        properly specified
if (a <= 0.d0) go to 110
!        Generation of uniform random variates
call durng(iseed, x, n, ierror)
if (ierror /= 0) go to 120
!        Loop which generates the n desired variates
do i = 1,n
   x(i) = - a*log(x(i))
end do
return
!              Error return
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
!     beginning of local variable declarations
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
!               Computation of n variates x(1),...,x(n)
!               from the gamma distribution having the
!                    probability density function
!                 f(t) = exp(-t)*t**(a-1)/gamma(a)
!                        ------------------
!     ix is a variable. On input ix is a seed for initializing the
!     sequence of variates. On output ix is a new seed for obtaining
!     more variates. It is assumed that 1 .LE. ix .LT. 2**31 - 1.
!     ierr is a variable which reports the status of the results.
!     When the subroutine terminates ierr has one of the following
!     values ...
!          ierr = 0   The gamma variates were obtained.
!          ierr = 1   (INPUT ERROR) n .LE. 0
!          ierr = 2   (INPUT ERROR) a .LT. 0.1
!          ierr = 3   (INPUT ERROR) ix IS NOT A PROPER
!                      seed.
!-----------------------------------------------------------------------
if (n <= 0) go to 100
if (a < 0.1) go to 110
if (ix < 1 .or. ix >= max) go to 120
ierr = 0
!             The following code assumes that the uniform
!             variates are far enough from 0 and 1 so that
!                   the setting ind = -8 Is avoided
do i = 1,n
   call urng0(ix, u, v)
   call gaminv(a, w, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) w = 0.0
   x(i) = w
end do
return
!                            Error return
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
!     beginning of local variable declarations
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
!             Computation of n double precision variates
!             x(1),...,x(n)  from the gamma distribution
!              having the probability density function
!                 f(t) = exp(-t)*t**(a-1)/gamma(a)
!                        ------------------
!     ix is a variable. On input ix is a seed for initializing the
!     sequence of variates. On output ix is a new seed for obtaining
!     more variates. It is assumed that 1 .LE. ix .LT. 2**31 - 1.
!     ierr is a variable which reports the status of the results.
!     When the subroutine terminates ierr has one of the following
!     values ...
!          ierr = 0   The gamma variates were obtained.
!          ierr = 1   (INPUT ERROR) n .LE. 0
!          ierr = 2   (INPUT ERROR) a .LT. 0.1
!          ierr = 3   (INPUT ERROR) ix IS NOT A PROPER
!                      seed.
!-----------------------------------------------------------------------
if (n <= 0) go to 100
if (a < 0.1d0) go to 110
if (ix < 1 .or. ix >= max) go to 120
ierr = 0
!             The following code assumes that the uniform
!             variates are far enough from 0 and 1 so that
!                   the setting ind = -8 Is avoided
do i = 1,n
   call durng0(ix, u, v)
   call dginv(a, w, u, v, ind)
   if (ind == -3 .or. ind == -7) w = 0.d0
   x(i) = w
end do
return
!                            Error return
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
!     beginning of local variable declarations
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
!                Generation of beta random variates
!                           ------------
!     rbeta generates n variates from the beta distribution with
!     PARAMETERS A AND b WHERE a .GE. 0.25 AND b .GE. 0.25. THE
!     generation scheme is based on the fact that x1 / (x1 + x2)
!     is a variate from the beta distribution when x1 and x2 are
!     independent variates from the standard gamma distributions
!     with parameters A and b respectively.
!     Form of the beta probability density function used...
!       f(x) = x**(a - 1) * (1 - x)**(b - 1) / beta(a,b)
!              WHERE  0 .LE. x .LE. 1  AND
!              beta(a,b) is the beta function.
!     Mean and variance of the beta distribution...
!              mean = a / (a + b)
!              variance = (a * b) / ((a + b)**2 * (a + b + 1))
!     input...
!        n       - Number of variates to be generated
!        a       - Parameter of the beta distribution
!        b       - Parameter of the beta distribution
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!     output...
!        ix      - Seed to be used for obtaining more
!                  variates
!        x       - Array of dimension n containing the
!                  beta variates
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.25
!                   3 - Seed out of range        )
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.25) go to 110
if (ix <= 0 .or. ix >= max) go to 120
ierr = 0
do i = 1,n
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
   call urng0(ix, u, v)
   call gaminv(a, x1, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.0
   call urng0(ix, u, v)
   call gaminv(b, x2, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) x2 = 0.0
!        It is required that A and b not be less
!        than 0.25 so that x1 + x2 is nonzero.
   x(i) = x1/(x1 + x2)
end do
return
!                      Error return
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
!     beginning of local variable declarations
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
!                         Double precision
!                generation of beta random variates
!                           ------------
!     drbeta generates n double precision variates from the beta
!     distribution with parameters A and b where a .GE. 0.25 and
!     b .GE. 0.25. The generation scheme is based on the fact
!     that x1 / (x1 + x2) is a variate from the beta distribution
!     when x1 and x2 are independent variates from the standard
!     gamma distributions with parameters A and b respectively.
!     Form of the beta probability density function used...
!       f(x) = x**(a - 1) * (1 - x)**(b - 1) / beta(a,b)
!              WHERE  0 .LE. x .LE. 1  AND
!              beta(a,b) is the beta function.
!     Mean and variance of the beta distribution...
!              mean = a / (a + b)
!              variance = (a * b) / ((a + b)**2 * (a + b + 1))
!     input...
!        n       - Number of variates to be generated
!        a       - Parameter of the beta distribution
!        b       - Parameter of the beta distribution
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!     output...
!        ix      - Seed to be used for obtaining more
!                  variates
!        x       - Array of dimension n containing the
!                  beta variates
!        ierr    - Input error flag
!                  (0 - No input errors
!                   1 - n .LE. 0
!                   2 - a or b is less than 0.25
!                   3 - Seed out of range        )
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.25d0) go to 110
if (ix <= 0 .or. ix >= max) go to 120
ierr = 0
do i = 1,n
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
   call durng0(ix, u, v)
   call dginv(a, x1, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.d0
   call durng0(ix, u, v)
   call dginv(b, x2, u, v, ind)
   if (ind == -3 .or. ind == -7) x2 = 0.d0
!        It is required that A and b not be less
!        than 0.25 so that x1 + x2 is nonzero.
   x(i) = x1/(x1 + x2)
end do
return
!                      Error return
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
!     beginning of local variable declarations
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
!          Generation of variates from the F-distribution
!                          --------------
!     Fran generates n variates from the F-distribution with
!     parameters A and b (called the numerator and denominator
!     degrees of freedom) where a .GE. 0.5 and b .GE. 0.5. The
!     generation scheme is based on the fact that (b/a)*(x1/x2)
!     is a variate from the F-distribution when x1 and x2 are
!     independent variates from the standard gamma distributions
!     with parameters a/2 and b/2 respectively.
!     Input...
!        n       - Number of variates to be generated
!        a       - Numerator degrees of freedom parameter
!        b       - Denominator degrees of freedom parameter
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!     output...
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
!-----------------------------------------------------------------------
!--------------------
!--------------------
!     ****** xmax is a machine dependent constant. Xmax is the
!            largest number in the floating arithmetic used.
xmax = spmpar(3)
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.5) go to 110
if (ix <= 0 .or. ix >= max) go to 130
ierr = 0
ahalf = 0.5*a
bhalf = 0.5*b
c = b/a
big = 0.5*xmax
bound = amax1(c, 1.0)
do i = 1,n
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
   call urng0(ix, u, v)
   call gaminv(ahalf, x1, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.0
   call urng0(ix, u, v)
   call gaminv(bhalf, x2, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
!        Protect against overflow in computing the
!        VARIATE c*(x1/x2).
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big <= bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!                      Error return
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
!     beginning of local variable declarations
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
!                  Double precision generation of
!                 variates from the F-distribution
!                          --------------
!     dfran generates n variates from the F-distribution with
!     parameters A and b (called the numerator and denominator
!     degrees of freedom) where a .GE. 0.5 and b .GE. 0.5. The
!     generation scheme is based on the fact that (b/a)*(X1/X2)
!     is a variate from the F-distribution when X1 and X2 are
!     independent variates from the standard gamma distributions
!     with parameters a/2 and b/2 respectively.
!     Input...
!        n       - Number of variates to be generated
!        a       - Numerator degrees of freedom parameter
!        b       - Denominator degrees of freedom parameter
!        ix      - Integer seed used to initialize the
!                  sequence of variates
!     output...
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
!-----------------------------------------------------------------------
!--------------------
!--------------------
!     ****** xmax is a machine dependent constant. Xmax is the
!            largest number in the floating arithmetic used.
xmax = dpmpar(3)
!--------------------
if (n <= 0) go to 100
if (min(a,b) < 0.5d0) go to 110
if (ix <= 0 .or. ix >= max) go to 130
ierr = 0
ahalf = 0.5d0*a
bhalf = 0.5d0*b
c = b/a
big = 0.5d0*xmax
bound = dmax1(c, 1.d0)
do i = 1,n
!        The following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
   call durng0(ix, u, v)
   call dginv(ahalf, x1, u, v, ind)
   if (ind == -3 .or. ind == -7) x1 = 0.d0
   call durng0(ix, u, v)
   call dginv(bhalf, x2, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
!        Protect against overflow in computing the
!        VARIATE c*(X1/X2).
   t = x1 + x2
   x1 = x1/t
   x2 = x2/t
   if (x2*big <= bound) go to 120
   x(i) = c * (x1/x2)
end do
return
!                      Error return
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
!     beginning of local variable declarations
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
!          Generation of variates from the T-distribution
!                          --------------
!        Tran generates n random variates from A T-distribution
!        with parameter a (called the degrees of freedom) where
!        a .GE. 0.5. The generation scheme is based on the fact
!        that x/sqrt(Y/a) is a variate from the T-distribution
!        when x is a standard normal variate and Y a chi-square
!        variate with a degrees of freedom.
!        Input...
!           n    - Number of variates to be generated
!           a    - Degrees of freedom parameter
!           ix   - Integer seed used to initialize the
!                  sequence of variates
!        output...
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
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (a < 0.5) go to 110
if (ix <= 0 .or. ix >= max) go to 130
ierr = 0
ahalf = 0.5*a
do i = 1,n
!                    Get a normal variate
   call urng1(ix, u, v, d)
   call pni(u, v, d, z, ind)
!                    Get a gamma variate
!        the following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
   call urng0(ix, u, v)
   call gaminv(ahalf, w, 0.0, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
   s = sqrt(w/ahalf)
   x(i) = z/s
end do
return
!              Error return
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
!     beginning of local variable declarations
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
!                  Double precision generation of
!                 variates from the T-distribution
!                          --------------
!        dtran generates n random variates from A T-distribution
!        with parameter a (called the degrees of freedom) where
!        a .GE. 0.5. The generation scheme is based on the fact
!        that x/sqrt(Y/a) is a variate from the T-distribution
!        when x is a standard normal variate and Y a chi-square
!        variate with a degrees of freedom.
!        Input...
!           n    - Number of variates to be generated
!           a    - Degrees of freedom parameter
!           ix   - Integer seed used to initialize the
!                  sequence of variates
!        output...
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
!-----------------------------------------------------------------------
!--------------------
!--------------------
if (n <= 0) go to 100
if (a < 0.5d0) go to 110
if (ix <= 0 .or. ix >= max) go to 130
ierr = 0
ahalf = 0.5d0*a
do i = 1,n
!                    Get a normal variate
   call durng1(ix, u, v, d)
   call dpni(u, v, d, z, ind)
!                    Get a gamma variate
!        the following code assumes that the uniform
!        variates are far enough from 0 and 1 so that
!        the setting ind = -8 In gaminv is avoided.
   call durng0(ix, u, v)
   call dginv(ahalf, w, u, v, ind)
   if (ind == -3 .or. ind == -7) go to 120
   s = sqrt(w/ahalf)
   x(i) = z/s
end do
return
!              Error return
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
!     beginning of local variable declarations
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
!              ***Subroutine purpose and description***
!           rmk1 generates an autocorrelated sequence x of
!           length n where x is a first-order markov process
!           with parameter alpha (abs(alpha) .LT. 1). The sequence
!           x(J) (J = 2,...,n) is generated by
!                  x(J) - fmu = alpha*(x(J-1) - fmu) + Z(J).
!           Z(J) is the random error term, assumed to be normally
!           distributed with mean 0 and standard deviation sig
!           (sig .GE. 0). The generation scheme assumes that x is
!           a normal process with mean fmu and variance
!                      sig*sig / (1 - alpha*alpha) .
!           x is a stationary process provided that abs(alpha) .LT.
!           1. The autocorrelation structure of the sequence is
!           characterized by the fact that the correlation between
!           terms becomes progressively weaker with increasing lag.
!           We note that a first-order markov process is synonomous
!           with a first-order autoregressive (AR) process.
!           ***Parameter list***
!           input...
!           n       - Length of the sequence to be generated.
!                     It is assumed that n .GE. 2.
!           fmu     - Mean of the normal process
!           sig     - Standard deviation of the normally
!                     distributed error term
!           alpha   - Value of the markov model parameter
!           iseed   - Integer seed used to initialize the
!                     sequence of normal variates generated
!                     by subroutine rnor
!           output...
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
!           ***REFERENCE***
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           PP. 236 - 237.
!        check to ensure that the desired sequence length is within
!        acceptable range
if (n <= 1) go to 100
!        Check to ensure that the standard deviation of the error term
!        is within acceptable range
if (sig <= 0.0) go to 110
!        Check to ensure that the first-order markov model
!        parameter is within the range required to guarantee
!        PROCESS STATIONARITY
if (abs(alpha) >= 1.0) go to 120
!        Generation of standard normal random variates
call rnor(iseed,x,n,ierror)
if (ierror /= 0) go to 130
!        Computes the standard deviation of the initial term of the
!        autocorrelated sequence
c = 0.5 + (0.5 - alpha)
t = 0.5 + (0.5 + alpha)
sigi = sig/sqrt(c*t)
!        Computes the initial term of the required autocorrelated
!        sequence
x(1) = fmu + sigi*x(1)
!        Generates the last n - 1 Terms of the required autocorrelated
!        sequence
c = fmu*c
do i = 2,n
   x(i) = alpha*x(i - 1) + c + sig*x(i)
end do
return
!        Error return
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
!     beginning of local variable declarations
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
!              ***Subroutine purpose and description***
!           drmk1 generates an autocorrelated sequence x of
!           length n where x is a first-order markov process
!           with parameter alpha (abs(alpha) .LT. 1). The sequence
!           x(J) (J = 2,...,n) is generated by
!                  x(J) - fmu = alpha*(x(J-1) - fmu) + Z(J).
!           Z(J) is the random error term, assumed to be normally
!           distributed with mean 0 and standard deviation sig
!           (sig .GE. 0). The generation scheme assumes that x is
!           a normal process with mean fmu and variance
!                      sig*sig / (1 - alpha*alpha) .
!           x is a stationary process provided that abs(alpha) .LT.
!           1. The autocorrelation structure of the sequence is
!           characterized by the fact that the correlation between
!           terms becomes progressively weaker with increasing lag.
!           We note that a first-order markov process is synonomous
!           with a first-order autoregressive (AR) process.
!           ***Parameter list***
!           input...
!           n       - Length of the sequence to be generated.
!                     It is assumed that n .GE. 2.
!           fmu     - Mean of the normal process
!           sig     - Standard deviation of the normally
!                     distributed error term
!           alpha   - Value of the markov model parameter
!           iseed   - Integer seed used to initialize the
!                     sequence of normal variates generated
!                     by subroutine drnor
!           output...
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
!           ***REFERENCE***
!           Fishman, george S., Concepts and methods in discrete event
!           digital simulation, john wiley and sons, new york, 1973,
!           PP. 236 - 237.
!        check to ensure that the desired sequence length is within
!        acceptable range
if (n <= 1) go to 100
!        Check to ensure that the standard deviation of the error term
!        is within acceptable range
if (sig <= 0.d0) go to 110
!        Check to ensure that the first-order markov model
!        parameter is within the range required to guarantee
!        PROCESS STATIONARITY
if (abs(alpha) >= 1.d0) go to 120
!        Generation of standard normal random variates
call drnor(iseed,x,n,ierror)
if (ierror /= 0) go to 130
!        Computes the standard deviation of the initial term of the
!        autocorrelated sequence
c = 0.5d0 + (0.5d0 - alpha)
t = 0.5d0 + (0.5d0 + alpha)
sigi = sig/sqrt(c*t)
!        Computes the initial term of the required autocorrelated
!        sequence
x(1) = fmu + sigi*x(1)
!        Generates the last n - 1 Terms of the required autocorrelated
!        sequence
c = fmu*c
do i = 2,n
   x(i) = alpha*x(i - 1) + c + sig*x(i)
end do
return
!        Error return
100 ierror = 1
return
110 ierror = 2
return
120 ierror = 3
return
130 ierror = 4
end subroutine drmk1
