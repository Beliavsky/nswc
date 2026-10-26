subroutine taslv1(mo,n,a,na,u,nu,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc, nu
real, intent(inout) :: a(na,n), u(nu,n), c(nc,n), wk(*)
integer :: i, j, k
! ----------------------------------------------------------------------
!     taslv1 solves the real matrix equation transpose(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
!    If required, reduce A to upper real Schur form
if (mo /= 0) go to 10
call orthes(na,n,1,n,a,wk)
call ortrn1(n,1,n,a,na,u,nu,wk)
call schur(n,1,n,a,na,u,nu,wk(1),wk(n + 1),ierr)
if (ierr /= 0) go to 200
!     Transform c
10 do i = 1,n
   c(i,i) = c(i,i)/2.0
end do
do i = 1,n
   do j = 1,n
      wk(j) = 0.0
      do k = i,n
         wk(j) = wk(j) + c(i,k)*u(k,j)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
do j = 1,n
   do i = 1,n
      wk(i) = 0.0
      do k = 1,n
         wk(i) = wk(i) + u(k,i)*c(k,j)
      end do
   end do
   do i = 1,n
      c(i,j) = wk(i)
   end do
end do
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
!     Solve the transformed system
call symslv(a,c,n,na,nc,ierr)
if (ierr /= 0) go to 210
!     Transform c back to the solution
do i = 1,n
   c(i,i) = c(i,i)/2.0
end do
do i = 1,n
   do j = 1,n
      wk(j) = 0.0
      do k = i,n
         wk(j) = wk(j) + c(i,k)*u(j,k)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
do j = 1,n
   do i = 1,n
      wk(i) = 0.0
      do k = 1,n
         wk(i) = wk(i) + u(i,k)*c(k,j)
      end do
   end do
   do i = 1,n
      c(i,j) = wk(i)
   end do
end do
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
return
!     Error return
200 ierr = -1
return
210 ierr = 1
end subroutine taslv1

pure subroutine symslv(a,c,n,na,nc,ierr)
implicit none
! ----------------------------------------------------------------------
!     symslv solves the matrix equation transpose(a)*X + X*a = c
!     where A is in upper Schur form and c is symmetric.
! ----------------------------------------------------------------------
integer, intent(in) :: n, na, nc
integer, intent(inout) :: ierr
real, intent(in) :: a(na,n)
real, intent(inout) :: c(nc,n)
real :: sum, p(4), t(4,4)
integer :: dk, dl, i, ia, j, k, kk, km1, l, ll, ldl
interface
   pure subroutine slv(n,m,a,ka,b,kb,ierr)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: ka
      integer, intent(in) :: m
      integer, intent(in) :: n
      real, intent(inout) :: a(ka,n)
      real, intent(inout) :: b(kb,m)
      integer, intent(out) :: ierr
   end subroutine slv
end interface
l = 1
10 dl = 1
if (l == n) go to 20
if (a(l + 1,l) /= 0.0) dl = 2
20 ll = l + dl - 1
k = l
30 km1 = k - 1
dk = 1
if (k == n) go to 35
if (a(k + 1,k) /= 0.0) dk = 2
35 kk = k + dk - 1
if (k == l) go to 45
do i = k,kk
   do j = l,ll
      sum = c(i,j)
      do ia = l,km1
         sum = sum - a(ia,i)*c(ia,j)
      end do
      c(i,j) = sum
   end do
end do
45 if (dl == 2) go to 60
if (dk == 2 ) go to 50
t(1,1) = a(k,k) + a(l,l)
if (t(1,1) == 0.0) go to 200
c(k,l) = c(k,l)/t(1,1)
ierr = 0
go to 90
50 t(1,1) = a(k,k) + a(l,l)
t(1,2) = a(kk,k)
t(2,1) = a(k,kk)
t(2,2) = a(kk,kk) + a(l,l)
p(1) = c(k,l)
p(2) = c(kk,l)
call slv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
go to 90
60 if (dk == 2) go to 70
t(1,1) = a(k,k) + a(l,l)
t(1,2) = a(ll,l)
t(2,1) = a(l,ll)
t(2,2) = a(k,k) + a(ll,ll)
p(1) = c(k,l)
p(2) = c(k,ll)
call slv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(k,ll) = p(2)
go to 90
70 if (k /= l) go to 80
t(1,1) = a(l,l)
t(1,2) = a(ll,l)
t(1,3) = 0.0
t(2,1) = a(l,ll)
t(2,2) = a(l,l) + a(ll,ll)
t(2,3) = t(1,2)
t(3,1) = 0.0
t(3,2) = t(2,1)
t(3,3) = a(ll,ll)
p(1) = c(l,l)/2.0
p(2) = c(ll,l)
p(3) = c(ll,ll)/2.0
call slv(3, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(l,l) = p(1)
c(ll,l) = p(2)
c(l,ll) = p(2)
c(ll,ll) = p(3)
go to 90
80 t(1,1) = a(k,k) + a(l,l)
t(1,2) = a(kk,k)
t(1,3) = a(ll,l)
t(1,4) = 0.0
t(2,1) = a(k,kk)
t(2,2) = a(kk,kk) + a(l,l)
t(2,3) = 0.0
t(2,4) = t(1,3)
t(3,1) = a(l,ll)
t(3,2) = 0.0
t(3,3) = a(k,k) + a(ll,ll)
t(3,4) = t(1,2)
t(4,1) = 0.0
t(4,2) = t(3,1)
t(4,3) = t(2,1)
t(4,4) = a(kk,kk) + a(ll,ll)
p(1) = c(k,l)
p(2) = c(kk,l)
p(3) = c(k,ll)
p(4) = c(kk,ll)
call slv(4, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
c(k,ll) = p(3)
c(kk,ll) = p(4)
90 k = k + dk
if (k <= n) go to 30
ldl = l + dl
if (ldl > n) return
do j = ldl,n
   do i = l,ll
      c(i,j) = c(j,i)
   end do
   do i = j,n
      do k = l,ll
         c(i,j) = c(i,j) - c(i,k)*a(k,j) - a(k,i)*c(k,j)
      end do
      c(j,i) = c(i,j)
   end do
end do
l = ldl
go to 10
!     Error return
200 ierr = 1
end subroutine symslv

subroutine dtaslv(mo,n,a,na,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc
double precision, intent(inout) :: a(na,n), c(nc,n), wk(*)
integer :: iw
! ----------------------------------------------------------------------
!     dtaslv solves the real matrix equation transpose(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     being called for the first time. On an initial call mo = 0 And
!     we have the following setup.
!        a(na,n)
!           A is a matrix of order n. it is assumed that
!           na .GE. n .GE. 1.
!        c(nc,n)
!           c is a symmetric matrix of order n. it is
!           assumed that nc .GE. n.
!        wk(---)
!           wk is an array of dimension n**2 + 2n that
!           is a general storage area for the routine.
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!        ierr =  0  The solution was obtained and stored in c.
!        ierr =  1  The equations are inconsistent for A. the
!                   problem cannot be solved.
!        ierr = -1  A could not be REDUCEDTO upper Schur form.
!                   The problem cannot be solved.
!     When ierr = 0, a contains the upper Schur form of the matrix
!     A and wk contains the orthogonal matrix involved in the Schur
!     decomposition of A. this information can be reused to solve A
!     new set of equations transpose(a)*X + X*a = c without having
!     to redecompose A. in this case, the input argument mo may be
!     set to any nonzero value. When mo .NE. 0, it is assumed that
!     only c has been modified. On output the solution for the new
!     set of equations is stored in c.
! ----------------------------------------------------------------------
!     This subroutine is a modification by
!        Alfred H. Morris, Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!     of the subroutine atxpxa written by
!        R.H. Bartels and G.W. Stewart
!        University of Texas at Austin.
!     Reference. Bartels, R.H. and Stewart, G.W., algorithm 432,
!        solution of the matrix equation AX + XB = c, comm. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iw = n*n + 1
call dtasv1(mo,n,a,na,wk(1),n,c,nc,wk(iw),ierr)
end subroutine dtaslv

subroutine dtasv1(mo,n,a,na,u,nu,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc, nu
double precision, intent(inout) :: a(na,n), u(nu,n), c(nc,n), &
   & wk(*)
integer :: i, j, k
! ----------------------------------------------------------------------
!     dtasv1 solves the real matrix equation transpose(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
!    If required, reduce A to upper real Schur form
if (mo /= 0) go to 10
call dorth(na,n,1,n,a,wk)
call drtrn1(n,1,n,a,na,u,nu,wk)
call dschur(n,1,n,a,na,u,nu,wk(1),wk(n + 1),ierr)
if (ierr /= 0) go to 200
!     Transform c
10 do i = 1,n
   c(i,i) = c(i,i)/2.d0
end do
do i = 1,n
   do j = 1,n
      wk(j) = 0.d0
      do k = i,n
         wk(j) = wk(j) + c(i,k)*u(k,j)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
do j = 1,n
   do i = 1,n
      wk(i) = 0.d0
      do k = 1,n
         wk(i) = wk(i) + u(k,i)*c(k,j)
      end do
   end do
   do i = 1,n
      c(i,j) = wk(i)
   end do
end do
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
!     Solve the transformed system
call dsymsv(a,c,n,na,nc,ierr)
if (ierr /= 0) go to 210
!     Transform c back to the solution
do i = 1,n
   c(i,i) = c(i,i)/2.d0
end do
do i = 1,n
   do j = 1,n
      wk(j) = 0.d0
      do k = i,n
         wk(j) = wk(j) + c(i,k)*u(j,k)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
do j = 1,n
   do i = 1,n
      wk(i) = 0.d0
      do k = 1,n
         wk(i) = wk(i) + u(i,k)*c(k,j)
      end do
   end do
   do i = 1,n
      c(i,j) = wk(i)
   end do
end do
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
return
!     Error return
200 ierr = -1
return
210 ierr = 1
end subroutine dtasv1

pure subroutine dsymsv(a,c,n,na,nc,ierr)
implicit none
! ----------------------------------------------------------------------
!     dsymsv solves the matrix equation transpose(a)*X + X*a = c
!     where A is in upper Schur form and c is symmetric.
! ----------------------------------------------------------------------
integer, intent(in) :: n, na, nc
integer, intent(inout) :: ierr
double precision, intent(in) :: a(na,n)
double precision, intent(inout) :: c(nc,n)
double precision :: sum, p(4), t(4,4)
integer :: dk, dl, i, ia, j, k, kk, km1, l, ll, ldl
interface
   pure subroutine dpslv(n,m,a,ka,b,kb,ierr)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: ka
      integer, intent(in) :: m
      integer, intent(in) :: n
      double precision, intent(inout) :: a(ka,n)
      double precision, intent(inout) :: b(kb,m)
      integer, intent(out) :: ierr
   end subroutine dpslv
end interface
l = 1
10 dl = 1
if (l == n) go to 20
if (a(l + 1,l) /= 0.d0) dl = 2
20 ll = l + dl - 1
k = l
30 km1 = k - 1
dk = 1
if (k == n) go to 35
if (a(k + 1,k) /= 0.d0) dk = 2
35 kk = k + dk - 1
if (k == l) go to 45
do i = k,kk
   do j = l,ll
      sum = c(i,j)
      do ia = l,km1
         sum = sum - a(ia,i)*c(ia,j)
      end do
      c(i,j) = sum
   end do
end do
45 if (dl == 2) go to 60
if (dk == 2 ) go to 50
t(1,1) = a(k,k) + a(l,l)
if (t(1,1) == 0.d0) go to 200
c(k,l) = c(k,l)/t(1,1)
ierr = 0
go to 90
50 t(1,1) = a(k,k) + a(l,l)
t(1,2) = a(kk,k)
t(2,1) = a(k,kk)
t(2,2) = a(kk,kk) + a(l,l)
p(1) = c(k,l)
p(2) = c(kk,l)
call dpslv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
go to 90
60 if (dk == 2) go to 70
t(1,1) = a(k,k) + a(l,l)
t(1,2) = a(ll,l)
t(2,1) = a(l,ll)
t(2,2) = a(k,k) + a(ll,ll)
p(1) = c(k,l)
p(2) = c(k,ll)
call dpslv(2, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(k,ll) = p(2)
go to 90
70 if (k /= l) go to 80
t(1,1) = a(l,l)
t(1,2) = a(ll,l)
t(1,3) = 0.d0
t(2,1) = a(l,ll)
t(2,2) = a(l,l) + a(ll,ll)
t(2,3) = t(1,2)
t(3,1) = 0.d0
t(3,2) = t(2,1)
t(3,3) = a(ll,ll)
p(1) = c(l,l)/2.d0
p(2) = c(ll,l)
p(3) = c(ll,ll)/2.d0
call dpslv(3, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(l,l) = p(1)
c(ll,l) = p(2)
c(l,ll) = p(2)
c(ll,ll) = p(3)
go to 90
80 t(1,1) = a(k,k) + a(l,l)
t(1,2) = a(kk,k)
t(1,3) = a(ll,l)
t(1,4) = 0.d0
t(2,1) = a(k,kk)
t(2,2) = a(kk,kk) + a(l,l)
t(2,3) = 0.d0
t(2,4) = t(1,3)
t(3,1) = a(l,ll)
t(3,2) = 0.d0
t(3,3) = a(k,k) + a(ll,ll)
t(3,4) = t(1,2)
t(4,1) = 0.d0
t(4,2) = t(3,1)
t(4,3) = t(2,1)
t(4,4) = a(kk,kk) + a(ll,ll)
p(1) = c(k,l)
p(2) = c(kk,l)
p(3) = c(k,ll)
p(4) = c(kk,ll)
call dpslv(4, 1, t, 4, p, 4, ierr)
if (ierr /= 0) go to 200
c(k,l) = p(1)
c(kk,l) = p(2)
c(k,ll) = p(3)
c(kk,ll) = p(4)
90 k = k + dk
if (k <= n) go to 30
ldl = l + dl
if (ldl > n) return
do j = ldl,n
   do i = l,ll
      c(i,j) = c(j,i)
   end do
   do i = j,n
      do k = l,ll
         c(i,j) = c(i,j) - c(i,k)*a(k,j) - a(k,i)*c(k,j)
      end do
      c(j,i) = c(i,j)
   end do
end do
l = ldl
go to 10
!     Error return
200 ierr = 1
end subroutine dsymsv

subroutine squint(nm, n, a, b, c, iguess, s, work, nw, tol, &
   & maxits, ierr)
implicit none
!     Subroutine squint breaks down the work array  work  into
!     smaller pieces.  The actual solution to AX**2 + BX + c = 0 Is
!     done in subroutine squin2.  This subroutine merely relieves
!     the user from a long calling sequence.
!     On entry,
!     nm     IS THE LEADING DIMENSION OF ALL THE MATRICES
!            in the calling program.
!     n      IS THE ORDER OF THE MATRICES A, b AND c.
!     A      is the matrix coefficient of X**2.
!     b      IS THE MATRIX COEFFICIENT OF X.
!     c      IS THE CONSTANT MATRIX.
!     iguess is an integer. If iguess.NE.0, the user supplies an
!            initial guess at a solvent.  This guess is stored in
!            array s.  if iguess.EQ.0, the subroutine provides its
!            own initial guess.
!     s      CONTAINS THE USERS INITIAL GUESS AT A SOLVENT, IF iguess
!            has been set to a nonzero quantity.  Otherwise the input
!            contents in s are ignored.
!     WORK   IS A WORK VECTOR.  IT MUST BE DIMENSIONED AT LEAST
!            (7n**2 + n), where n is the order of A, b, c and s.
!     nw     IS THE DIMENSION OF THE ARRAY work IN THE CALLING
!            program.
!     tol    is a user-supplied accuracy tolerance.  Setting tol = 0.0
!            causes iteration to proceed until full machine precision
!            is attained.  Otherwise, execution terminates when
!            NORM(AS**2+BS+c).LT.TOL.
!     maxits is an integer.  If maxits.NE.0, the user specifies the
!            most interations the algorithm is to take.  If maxits.
!            .LE.0, it is reset to 30.
!     On return,
!     A,b,c  are destroyed.
!     iguess contains the number of iterations performed to
!            compute s.
!     s      CONTAINS THE RIGHT SOLVENT.
!     work(1) is a complex number with real part equal to the norm
!            of as**2+BS+c.
!     ierr   IS AN INTEGER ERROR RETURN.
!            ierr = 0 For a normal return.
!            ierr = 1 Indicates failure of squint to converge to
!                     a solvent in the maximum number of iterations.
!            ierr = 2 Indicates failure in the upper reduction in
!                     cqzit.
!            ierr = 3 Indicates failure in the lower reduction in
!                     cqzit.
!            ierr = 10 + n  indicates an error return from trislv
!                     on iteration n, designating inconsistency of
!                     the triangular system.
!            ierr = 999 Indicates improper dimensioning.  The
!                     CONDITIONS  nm.GE.n.GT.0   AND
!                     nw.GE.(7*n*n + n) must hold.
integer, intent(in) :: nm, n
integer, intent(inout) :: iguess
integer, intent(in) :: nw
integer, intent(inout) :: maxits, ierr
complex, intent(inout) :: work(nw)
complex, intent(inout) :: a(nm,n), b(nm,n), c(nm,n), s(nm,n)
real, intent(in) :: tol
integer :: i1, i2, i3, i4, i5, i6, i7
i1 = n*n + 1
i2 = n*n + i1
i3 = n*n + i2
i4 = n*n + i3
i5 = n*n + i4
i6 = n*n + i5
i7 = n*n + i6
call squin2(nm, n, a, b, c, iguess, s, work(1), work(i1), &
   & work(i2), work(i3), work(i4), work(i5), work(i6), work(i7), nw, &
   & tol, maxits, ierr)
end subroutine squint

subroutine squin2(nm, n, a, b, c, iguess, s, l, u, v, z, r, xold, &
   & eye, temp, nw, tol, maxits, ierr)
implicit none
!     Subroutine squin2 finds a right solvent of the matrix
!     EQUATION AX**2 + BX + c = 0.
!     On entry,
!     nm     IS THE LEADING DIMENSION OF ALL THE MATRICES IN
!            the calling program.
!     n      IS THE ORDER OF THE MATRICES A, b AND c.
!     A      is the matrix coefficient of X**2.
!     b      IS THE MATRIX COEFFICIENT OF X.
!     c      IS THE CONSTANT MATRIX.
!     iguess is an integer set in the call to squint.
!     s      IS A MATRIX SET IN THE CALL TO SQUINT.
!     nw, tol, and maxits are integer and real parameters set in
!            the call to squint.
!     The following are internal variables ...
!     L      IS A MATRIX CONTAINING THE ITERATE X(i) FOR
!            reduction to lower triangular form.
!     U      IS A MATRIX CONTAINING AX(i) + b FOR REDUCTION
!            to upper triangular form.
!     v      IS A MATRIX CONTAINING A FOR REDUCTION TO UPPER
!            triangular form.
!     z,r    ARE MATRICES CONTAINING THE HISTORY OF THE
!            transformations in the reductions.
!     xold   IS A MATRIX HOLDING THE CURRENT ITERATE X(i).
!     EYE    CONTAINS AN IDENTITY MATRIX FOR THE LOWER REDUCTION
!            step.
!     TEMP   IS A WORK VECTOR.
!     On return,
!     A, b, c, iguess, s and ierr have the same properties as
!            described in the return from subroutine squint.
!     L(1,1) is a complex number with real part equal to the norm
!            of as**2+BS+c.
integer, intent(in) :: nm, n
integer, intent(inout) :: iguess
integer, intent(in) :: nw
integer, intent(inout) :: maxits, ierr
complex, intent(inout) :: a(nm,n), b(nm,n), c(nm,n), s(nm,n), &
   & l(nm,n), u(nm,n)
complex, intent(inout) :: v(nm,n), z(nm,n), r(nm,n), xold(nm,n), &
   & eye(nm,n), temp(n)
real, intent(in) :: tol
integer :: its, mats, i, j, k
real :: anorm, ani, bnorm, bni, cnorm, cni, xnorm, xni, fxnorm, fxni, gnorm, tnorm, t
!     real sqrt, cabs, float
!     complex cmplx, conjg
k = 7*n*n + n
if (nw < k) go to 460
if (nm < n) go to 460
if (n <= 0) go to 460
if (maxits <= 0) maxits = 30
!     ********** Initialize arrays **********
do i = 1,n
   do j = 1,n
      l(i,j) = cmplx(0.0,0.0)
      u(i,j) = cmplx(0.0,0.0)
      v(i,j) = cmplx(0.0,0.0)
      z(i,j) = cmplx(0.0,0.0)
      xold(i,j) = cmplx(0.0,0.0)
      eye(i,j) = cmplx(0.0,0.0)
   end do
   temp(i) = cmplx(0.0,0.0)
end do
!     ********** Set initial guess(ES) **********
anorm = 0.0
bnorm = 0.0
cnorm = 0.0
do i = 1,n
   ani = 0.0
   bni = 0.0
   cni = 0.0
   do j = 1,n
      ani = ani + abs(a(i,j))
      bni = bni + abs(b(i,j))
      cni = cni + abs(c(i,j))
   end do
   if (ani > anorm) anorm = ani
   if (bni > bnorm) bnorm = bni
   if (cni > cnorm) cnorm = cni
end do
gnorm = (bnorm + sqrt(bnorm**2 + 4.0*anorm*cnorm))/(2.0*anorm)
if (iguess == 0) go to 70
do i = 1,n
   do j = 1,n
      xold(i,j) = s(i,j)
   end do
end do
go to 100
70 do i = 1,n
   do j = 1,n
      xold(i,j) = cmplx(0.0,0.0)
   end do
   xold(i,i) = cmplx(gnorm,0.0)
end do
100 do its = 1,maxits
   if (its /= 31) go to 130
   do i = 1,n
      do j = 1,n
         xold(i,j) = cmplx(0.0,0.0)
      end do
      xold(i,i) = cmplx(0.0,gnorm)
   end do
130 if (its /= 61) go to 160
   do i = 1,n
      do j = 1,n
         xold(i,j) = c(i,j)
      end do
   end do
!        ********** Set up U and right hand side **********
160 call cmprod(n, n, n, a, nm, xold, nm, u, nm, u)
   do i = 1,n
      do j = 1,n
         u(i,j) = u(i,j) + b(i,j)
      end do
   end do
   call cmprod(n, n, n, u, nm, xold, nm, s, nm, s)
   do i = 1,n
      do j = 1,n
         s(i,j) = s(i,j) + c(i,j)
      end do
   end do
!        ********** Check for convergence **********
   xnorm = 0.0
   fxnorm = 0.0
   do i = 1,n
      xni = 0.0
      fxni = 0.0
      do j = 1,n
         xni = xni + abs(xold(i,j))
         fxni = fxni + abs(s(i,j))
      end do
      if (xni > xnorm) xnorm = xni
      if (fxni > fxnorm) fxnorm = fxni
   end do
   if (tol <= 0.0) go to 230
   if ( fxnorm < tol ) exit
230 tnorm = 8.0*float(n)*anorm*xnorm**2 + 5.0*float(n)*bnorm*xnorm &
      & + cnorm
   t = 1.0 + fxnorm/tnorm
   if ( t == 1.0 ) exit
   if (its >= maxits) go to 400
!        ********** Upper triangularization **********
   if (its /= 1) go to 240
   mats = 1
   call cqzhes(nm, n, u, a, mats, z, s, b, c)
240 do i = 1,n
      do j = 1,n
         v(i,j) = a(i,j)
         l(i,j) = conjg(xold(j,i))
         eye(i,j) = cmplx(0.0,0.0)
      end do
      eye(i,i) = cmplx(1.0,0.0)
   end do
   if (its == 1) go to 270
   mats = 2
   call cqzhes(nm, n, u, v, mats, z, s, b, c)
270 call cqzit(nm, n, u, v, 0.0, mats, z, s, ierr)
   if (ierr /= 0) go to 430
!        ********** Lower triangularization **********
   mats = 3
   call cqzhes(nm, n, l, eye, mats, r, s, b, c)
   call cqzit(nm, n, l, eye, 0.0, mats, r, s, ierr)
   if (ierr /= 0) go to 440
   call ctrans(nm, n, l)
!        ********** UPDATE s WITH r **********
   do i = 1,n
      do j = 1,n
         temp(j) = s(i,j)
         s(i,j) = cmplx(0.0,0.0)
      end do
      do j = 1,n
         do k = 1,n
            s(i,j) = s(i,j) + temp(k)*r(k,j)
         end do
      end do
   end do
   do j = 1,n
      do i = 1,n
         l(i,j) = l(i,j)*eye(j,j)
      end do
      eye(j,j) = cmplx(1.0,0.0)
   end do
!        ********** Backsolve the transformed system **********
   call trislv(nm, n, u, v, l, s, temp, ierr)
   if (ierr /= 0) go to 450
!        ********** Translate back to the solution **********
   call cmprod(n, n, n, z, nm, s, nm, l, nm, l)
   call ctrans(nm, n, r)
   call cmprod(n, n, n, l, nm, r, nm, s, nm, s)
   do i = 1,n
      do j = 1,n
         xold(i,j) = xold(i,j) - s(i,j)
      end do
   end do
end do
!     ********** CONVERGENCE **********
iguess = its - 1
l(1,1) = cmplx(fxnorm,0.0)
do i = 1,n
   do j = 1,n
      s(i,j) = xold(i,j)
   end do
end do
ierr = 0
return
!     ********** Error returns **********
400 ierr = 1
l(1,1) = cmplx(fxnorm,0.0)
do i = 1,n
   do j = 1,n
      s(i,j) = xold(i,j)
   end do
end do
return
430 ierr = 2
return
440 ierr = 3
return
450 ierr = its + 10
return
460 ierr = 999
end subroutine squin2

pure subroutine cqzhes(nm, n, a, b, mats, z, f, g, h)
implicit none
!     Subroutine cqzhes is a modification of the EISPACK subroutine
!     QZHES.  All operations are performed in complex arithmetic,
!     and the left transformations may also be applied to auxiliary
!     matrices f, g and h.
!     On entry,
!     nm   IS THE LEADING DIMENSION OF THE MATRICES A AND b IN
!          the main program.
!     n    IS THE ORDER OF THE MATRICES A AND b.
!     A    CONTAINS THE MATRIX TO BE REDUCED TO UPPER HESSENBERG
!          form.
!     b    CONTAINS THE MATRIX TO BE REDUCED TO UPPER TRAINGULAR
!          form.
!     Mats is an integer input variable.
!          If mats = 0, the accumulation of the transformations
!             is not desired.
!          If mats = Any other number but 0, the transformations
!             are accumulated.
!          If mats = 1, the auxiliary matrices g and h are updated
!             with the unitary matrix Q.
!          If mats = 2, matrix b is assumed upper triangular.
!          If mats = 3, the auxiliary matrix f is not updated
!             with the unitary matrix Q.
!     f, g and h are auxiliary matrices.
!     On return,
!     A    IS UPPER HESSENBERG.
!     b    IS UPPER TRIANGULAR.
!     z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
!     f, g and h are updated, if desired.
integer, intent(in) :: n
integer, intent(in) :: nm
complex, intent(inout) :: a(nm,n), b(nm,n), z(nm,n)
complex, intent(inout) :: f(nm,n)
complex, intent(inout) :: g(nm,n)
complex, intent(inout) :: h(nm,n)
integer, intent(in) :: mats
integer :: i, j, k, l, lb, l1, nk1, nm1, nm2
complex :: rr, t, u1, u2, v1, v2, rho, tf, tg, th
real :: r, s
!     real sqrt, cabs
!     complex cmplx, conjg
if (mats == 0) go to 30
do i = 1,n
   do j = 1,n
      z(i,j) = cmplx(0.0,0.0)
   end do
   z(i,i) = cmplx(1.0,0.0)
end do
!     ********** Reduce b to upper triangular form **********
30 if (n <= 1) go to 260
nm1 = n - 1
if (mats == 2) go to 140
do l = 1,nm1
   l1 = l + 1
   s = 0.0
   do i = l1,n
      s = s + abs(b(i,l))
   end do
   if (s == 0.0) go to 130
   s = s + abs(b(l,l))
   r = 0.0
   do i = l,n
      b(i,l) = b(i,l)/cmplx(s,0.0)
      r = r + abs(b(i,l))**2
   end do
   r = sqrt(r)
   rr = cmplx(r,0.0)
   if (abs(b(l,l)) /= 0.0) rr = (b(l,l)/abs(b(l,l)))*rr
   b(l,l) = b(l,l) + rr
   rho = conjg(rr)*b(l,l)
   do j = l1,n
      t = cmplx(0.0,0.0)
      do i = l,n
         t = t + conjg(b(i,l))*b(i,j)
      end do
      t = -t/rho
      do i = l,n
         b(i,j) = b(i,j) + t*b(i,l)
      end do
   end do
   do j = 1,n
      t = cmplx(0.0,0.0)
      tf = cmplx(0.0,0.0)
      tg = cmplx(0.0,0.0)
      th = cmplx(0.0,0.0)
      do i = l,n
         t = t + conjg(b(i,l))*a(i,j)
         if (mats == 3) go to 90
         tf = tf + conjg(b(i,l))*f(i,j)
         if (mats /= 1) go to 90
         tg = tg + conjg(b(i,l))*g(i,j)
         th = th + conjg(b(i,l))*h(i,j)
90       continue
      end do
      t = -t/rho
      tf = -tf/rho
      tg = -tg/rho
      th = -th/rho
      do i = l,n
         a(i,j) = a(i,j) + t*b(i,l)
         if (mats == 3) go to 100
         f(i,j) = f(i,j) + tf*b(i,l)
         if (mats /= 1) go to 100
         g(i,j) = g(i,j) + tg*b(i,l)
         h(i,j) = h(i,j) + th*b(i,l)
100      continue
      end do
   end do
   b(l,l) = -cmplx(s,0.0)*rr
   do i = l1,n
      b(i,l) = cmplx(0.0,0.0)
   end do
130 continue
end do
!     ********** Reduce A to upper Hessenberg form, while
!                KEEPING b TRIANGULAR **********
140 if (n == 2) go to 260
nm2 = n - 2
do k = 1,nm2
   nk1 = nm1 - k
   do lb = 1,nk1
      l = n - lb
      l1 = l + 1
!     ********** ZERO a(l+1,k) **********
      s = abs(a(l,k)) + abs(a(l1,k))
      if (s == 0.0) go to 240
      u1 = a(l,k)/cmplx(s,0.0)
      u2 = a(l1,k)/cmplx(s,0.0)
      r = sqrt(abs(u1)**2 + abs(u2)**2)
      rr = cmplx(r,0.0)
      if (abs(u1) /= 0.0) rr = (u1/abs(u1))*rr
      v1 = -(u1 + rr)/rr
      v2 = -u2/rr
      u2 = v2/v1
      do j = k,n
         t = a(l,j) + conjg(u2)*a(l1,j)
         a(l,j) = a(l,j) + t*v1
         a(l1,j) = a(l1,j) + t*v2
      end do
      a(l1,k) = cmplx(0.0,0.0)
      do j = l,n
         t = b(l,j) + conjg(u2)*b(l1,j)
         b(l,j) = b(l,j) + t*v1
         b(l1,j) = b(l1,j) + t*v2
      end do
      if (mats == 3) go to 180
      do j = 1,n
         tf = f(l,j) + conjg(u2)*f(l1,j)
         f(l,j) = f(l,j) + tf*v1
         f(l1,j) = f(l1,j) + tf*v2
      end do
180   if (mats /= 1) go to 200
      do j = 1,n
         tg = g(l,j) + conjg(u2) + g(l1,j)
         th = h(l,j) + conjg(u2) + h(l1,j)
         g(l,j) = g(l,j) + tg*v1
         h(l,j) = h(l,j) + th*v1
         g(l1,j) = g(l1,j) + tg*v2
         h(l1,j) = h(l1,j) + th*v2
      end do
!     ********** ZERO b(l+1,l) **********
200   s = abs(b(l1,l1)) + abs(b(l1,l))
      if (s == 0.0) go to 240
      u1 = b(l1,l1)/cmplx(s,0.0)
      u2 = b(l1,l)/cmplx(s,0.0)
      r = sqrt(abs(u1)**2 + abs(u2)**2)
      rr = cmplx(r,0.0)
      if (abs(u1) /= 0.0) rr = (u1/abs(u1))*rr
      v1 = -(u1 + rr)/rr
      v2 = -u2/rr
      u2 = v2/v1
      do i = 1,l1
         t = b(i,l1) + conjg(u2)*b(i,l)
         b(i,l1) = b(i,l1) + t*v1
         b(i,l) = b(i,l) + t*v2
      end do
      b(l1,l) = cmplx(0.0,0.0)
      do i = 1,n
         t = a(i,l1) + conjg(u2)*a(i,l)
         a(i,l1) = a(i,l1) + t*v1
         a(i,l) = a(i,l) + t*v2
      end do
      if (mats == 0) go to 240
      do i = 1,n
         t = z(i,l1) + conjg(u2)*z(i,l)
         z(i,l1) = z(i,l1) + t*v1
         z(i,l) = z(i,l) + t*v2
      end do
240   continue
   end do
end do
260 return
end subroutine cqzhes

pure subroutine cqzit(nm, n, a, b, eps1, mats, z, f, ierr)
implicit none
!     Subroutine cqzit is a modification of the EISPACK subroutine
!     QZIT.  All operations are performed in complex arithmetic,
!     and the left transformations may also be applied to an auxiliary
!     matrix f.
!     On entry,
!     nm   IS THE LEADING DIMENSION OF THE MATRICES A AND b IN
!          the main program.
!     n    IS THE ORDER OF THE MATRICES A AND b.
!     A    CONTAINS AN UPPER HESSENBERG MATRIX FROM cqzhes.
!     b    CONTAINS AN UPPER TRIANGULAR MATRIX FROM cqzhes.
!     eps1 is a real number defining the tolerance used to determine
!          negligible elements of A and b in the course of the alg-
!          orithm.  An element of either matrix will be considered
!          negligible and reset to zero if it is not larger than the
!          product of eps1 and the norm of the matrix.  If eps1.LE.0,
!          relative machine precision will be computed and
!          used instead.
!     Mats is an integer input variable.  It is set prior
!          to the call to cqzhes.
!     f    CONTAINS AN AUXILIARY MATRIX.
!     On return,
!     A    IS UPPER TRIANGULAR.
!     b    IS UPPER TRIANGULAR.
!     z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
!     f    CONTAINS THE AUXILIARY MATRIX, UPDATED IF DESIRED.
!     ierr is an integer error return which indicates failure
!          of the QZ algorithm to reduce a subdiagonal element
!          to zero after 50 iterations.
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(out) :: ierr
complex, intent(inout) :: a(nm,n), b(nm,n), z(nm,n)
complex, intent(inout) :: f(nm,n)
real, intent(in) :: eps1
integer, intent(in) :: mats
integer :: i, j, k, l, en, jj, k1, k2, ld, ll, l1, na, ish, its, km1, lm1, enm2, lor1, enorn
complex :: a11, a21, a33, a34, a43, a44, b11, b22, b33, b34, b44, a1, a2, u1, u2, v1, v2, t, rr, sh, ss, tf
real :: epsa, epsb, anorm, bnorm, ani, bni, srelpr, r, s
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     integer max0, min0
!     real sqrt, cabs
!     complex cmplx, conjg, csqrt
ierr = 0
!     ********** COMPUTE epsa, epsb **********
anorm = 0.0
bnorm = 0.0
do i = 1,n
   ani = 0.0
   if (i /= 1) ani = abs(a(i,i - 1))
   bni = 0.0
   do j = i,n
      ani = ani + abs(a(i,j))
      bni = bni + abs(b(i,j))
   end do
   if (ani > anorm) anorm = ani
   if (bni > bnorm) bnorm = bni
end do
if (anorm == 0.0) anorm = 1.0
if (bnorm == 0.0) bnorm = 1.0
srelpr = eps1
if (srelpr > 0.0) go to 40
!     ***** When eps1 = 0 Then set srelpr to be the smallest
!           number for which 1 + srelpr .GT. 1 *****
srelpr = spmpar(1)
40 epsa = srelpr*anorm
epsb = srelpr*bnorm
!     ********** Reduce A to triangular form, while
!                KEEPING b TRIANGULAR **********
lor1 = 1
enorn = n
en = n
!     ********** BEGIN QZ STEP **********
50 if (en <= 1) go to 220
if (mats == 0) enorn = en
its = 0
na = en - 1
enm2 = na - 1
60 ish = 1
!     ********** Check for convergence or reducibility **********
do ll = 1,en
   lm1 = en - ll
   l = lm1 + 1
   if (l == 1) go to 90
   if ( abs ( a ( l , lm1 ) ) <= epsa ) exit
end do
80 a(l,lm1) = cmplx(0.0,0.0)
if (l < na) go to 90
!     ********** 1-By-1 block isolated **********
en = lm1
go to 50
!     ********** Check for small top of b **********
90 ld = l
l1 = l + 1
b11 = b(l,l)
if (abs(b11) > epsb) go to 120
b(l,l) = cmplx(0.0,0.0)
s = abs(a(l,l)) + abs(a(l1,l))
u1 = a(l,l)/cmplx(s,0.0)
u2 = a(l1,l)/cmplx(s,0.0)
r = sqrt(abs(u1)**2 + abs(u2)**2)
rr = cmplx(r,0.0)
if (abs(u1) /= 0.0) rr = (u1/abs(u1))*rr
v1 = -(u1 + rr)/rr
v2 = -u2/rr
u2 = v2/v1
do j = l,enorn
   t = a(l,j) + conjg(u2)*a(l1,j)
   a(l,j) = a(l,j) + t*v1
   a(l1,j) = a(l1,j) + t*v2
   t = b(l,j) + conjg(u2)*b(l1,j)
   b(l,j) = b(l,j) + t*v1
   b(l1,j) = b(l1,j) + t*v2
   if (mats == 3) go to 110
   do jj = 1,n
      tf = f(l,jj) + conjg(u2)*f(l1,jj)
      f(l,jj) = f(l,jj) + tf*v1
      f(l1,jj) = f(l1,jj) + tf*v2
   end do
110 continue
end do
if (l /= 1) a(l,lm1) = -a(l,lm1)
lm1 = l
l = l1
go to 80
120 a11 = a(l,l)/b11
a21 = a(l1,l)/b11
!     ********** Iteration strategy **********
if (its == 50) go to 210
!     ********** Determine shift **********
b22 = b(l1,l1)
if (abs(b22) < epsb) b22 = cmplx(epsb,0.0)
b33 = b(na,na)
if (abs(b33) < epsb) b33 = cmplx(epsb,0.0)
b44 = b(en,en)
if (abs(b44) < epsb) b44 = cmplx(epsb,0.0)
a33 = a(na,na)/b33
a34 = a(na,en)/b44
a43 = a(en,na)/b33
a44 = a(en,en)/b44
b34 = b(na,en)/b44
t = cmplx(0.5,0.0)*(a43*b34 - a33 - a44)
rr = t*t + a34*a43 - a33*a44
!     ********** Determine single shift zeroth column of a **********
rr = sqrt(rr)
sh = -t + rr
ss = -t - rr
if (abs(ss - a44) < abs(sh - a44)) sh = ss
a1 = a11 - sh
a2 = a21
if (l /= ld) a(l,lm1) = -a(l,lm1)
if (its /= 10) go to 130
a1 = cmplx(1.0,0.0)
a2 = cmplx(1.1605,0.0)
130 its = its + 1
if (mats == 0) lor1 = ld
!     ********** Main loop **********
do k = l,na
   k1 = k + 1
   k2 = k + 2
   km1 = max(k - 1,l)
   ll = min(en,k1 + ish)
!     ********** ZERO a(k+1,k-1) **********
   if (k == l) go to 140
   a1 = a(k,km1)
   a2 = a(k1,km1)
140 s = abs(a1) + abs(a2)
   if (s == 0.0) go to 60
   u1 = a1/cmplx(s,0.0)
   u2 = a2/cmplx(s,0.0)
   r = sqrt(abs(u1)**2 + abs(u2)**2)
   rr = cmplx(r,0.0)
   if (abs(u1) /= 0.0) rr = (u1/abs(u1))*rr
   v1 = -(u1 + rr)/rr
   v2 = -u2/rr
   u2 = v2/v1
   do j = km1,enorn
      t = a(k,j) + conjg(u2)*a(k1,j)
      a(k,j) = a(k,j) + t*v1
      a(k1,j) = a(k1,j) + t*v2
      t = b(k,j) + conjg(u2)*b(k1,j)
      b(k,j) = b(k,j) + t*v1
      b(k1,j) = b(k1,j) + t*v2
   end do
   if (k /= l) a(k1,km1) = cmplx(0.0,0.0)
   if (mats == 3) go to 170
   do j = 1,n
      tf = f(k,j) + conjg(u2)*f(k1,j)
      f(k,j) = f(k,j) + tf*v1
      f(k1,j) = f(k1,j) + tf*v2
   end do
!     ********** ZERO b(k+1,k) **********
170 s = abs(b(k1,k1)) + abs(b(k1,k))
   if (s == 0.0) go to 200
   u1 = b(k1,k1)/cmplx(s,0.0)
   u2 = b(k1,k)/cmplx(s,0.0)
   r = sqrt(abs(u1)**2 + abs(u2)**2)
   rr = cmplx(r,0.0)
   if (abs(u1) /= 0.0) rr = (u1/abs(u1))*rr
   v1 = -(u1 + rr)/rr
   v2 = -u2/rr
   u2 = v2/v1
   do i = lor1,ll
      t = a(i,k1) + conjg(u2)*a(i,k)
      a(i,k1) = a(i,k1) + t*v1
      a(i,k) = a(i,k) + t*v2
      t = b(i,k1) + conjg(u2)*b(i,k)
      b(i,k1) = b(i,k1) + t*v1
      b(i,k) = b(i,k) + t*v2
   end do
   b(k1,k) = cmplx(0.0,0.0)
   if (mats == 0) go to 200
   do i = 1,n
      t = z(i,k1) + conjg(u2)*z(i,k)
      z(i,k1) = z(i,k1) + t*v1
      z(i,k) = z(i,k) + t*v2
   end do
200 continue
end do
!     ********** END QZ STEP **********
go to 60
!     ********** Set error -- neither bottom subdiagonal element
!                has become negligible after 50 iterations **********
210 ierr = en
!     ********** Save epsb for use by CQZVEC **********
220 if (n > 1) b(n,1) = cmplx(epsb,0.0)
end subroutine cqzit

pure subroutine trislv(nm, n, u, v, l, f, temp, ierr)
implicit none
!     Subroutine trislv backsolves a system of the form
!     UY + VYL = f, where u and v are upper triangular, and
!     l is lower triangular.
!     On entry,
!     nm   IS THE LEADING DIMENSION OF THE MATRICES u, v, l AND f IN
!          the main program.
!     n    IS THE ORDER OF THE MATRICES u, v, l AND f.
!     u    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
!          coefficient of Y in the first term in UY + VYL.
!     v    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
!          coefficient of Y in the second term of UY + VYL.
!     l    CONTAINS A LOWER TRIANGULAR MATRIX.  IT IS THE RIGHT
!          coefficient of Y in the second term of UY + VYL.
!     f    contains the right hand side of UY + VYL = f.
!     Temp contains a work vector of length at least n.
!     On return,
!     f    CONTAINS THE SOLUTION Y.
!     ierr is an error return designating inconsistency of the
!          original system.
!          ierr.EQ.0 for a normal return.
!          ierr.EQ.1 if the triangular system is inconsistent.
integer, intent(out) :: ierr
integer, intent(in) :: n, nm
complex, intent(in) :: u(nm,n), v(nm,n), l(nm,n)
complex, intent(inout) :: f(nm,n)
complex, intent(inout) :: temp(n)
integer :: i, j, jp1, k, kk, km1, m, nm1
complex :: denom, sum
real :: s, t
!     real cabs
!     complex cmplx
ierr = 0
nm1 = n - 1
do kk = 1,n
!        ********** Backsubstitute for row k. **********
   k = n - kk + 1
   if (abs(f(k,n)) /= 0.0) go to 10
   f(k,n) = cmplx(0.0,0.0)
   go to 30
10 denom = u(k,k) + v(k,k)*l(n,n)
   s = abs(denom)
   t = 1.0 + s/abs(f(k,n))
   if (t > 1.0) go to 20
   ierr = 1
   return
20 f(k,n) = f(k,n)/denom
   if (n == 1) return
30 do i = 1,nm1
      j = n - i
      jp1 = j + 1
      sum = cmplx(0.0,0.0)
      do m = jp1,n
         sum = sum + f(k,m)*l(m,j)
      end do
      sum = f(k,j) - v(k,k)*sum
      if (abs(sum) /= 0.0) go to 50
      f(k,j) = cmplx(0.0,0.0)
      go to 70
50    denom = u(k,k) + v(k,k)*l(j,j)
      s = abs(denom)
      t = 1.0 + s/abs(sum)
      if (t > 1.0) go to 60
      ierr = 1
      return
60    f(k,j) = sum/denom
70    continue
   end do
!        ********** Form temp = YK-trans*l. **********
   if (k == 1) return
   km1 = k - 1
   do i = 1,n
      temp(i) = cmplx(0.0,0.0)
      do j = 1,n
         temp(i) = temp(i) + f(k,j)*l(j,i)
      end do
   end do
!        ********** Prepare f' which is (k-1) by n. **********
   do i = 1,km1
      do j = 1,n
         f(i,j) = f(i,j) - u(i,k)*f(k,j) - v(i,k)*temp(j)
      end do
   end do
end do
end subroutine trislv

subroutine mexp(a, ka, n, z, kz, wk, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kz
integer :: n
real, intent(inout) :: a(ka,n), z(kz,n), wk(n,*)
integer :: i, igh, j, k, kp1, l, ll, low, m, np1, np6
real :: anorm, anorm1, factor, p, q, s, s1
real, parameter :: c(8) = [.500000000000000e+00, .116666666666667e+00, .166666666666667e-01, .160256410256410e-02, &
   & .106837606837607e-03, .485625485625486e-05, .138750138750139e-06, .192708526041859e-08]
! ----------------------------------------------------------------------
!     mexp computes exp(a) and stores it in z where A is a matrix
!     of order n. A is destroyed by the routine.
!     wk is an array of dimension (n,n+8). wk is a work space
!     for the routine.
!     ierr is a variable that reports the status of the results.
!        ierr = 0  exp(a) was successfully computed.
!        ierr = 1  The norm of A is too large.
!        ierr = 2  The Pade denominator matrix is
!                  singular.
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren Virginia
!     ---------------
!     Coefficients for (8,8) Pade table entry
!     ---------------
! ----------------------------------------------------------------------
ierr = 0
if (n > 1) go to 10
z(1,1) = exp(a(1,1))
return
!       Balance A and select the smaller of the 1-norm
!              and infinity-norm of the result
10 call balanc(ka,n,a,low,igh,wk(1,n + 8))
anorm = 0.0
anorm1 = 0.0
do j = 1,n
   s = 0.0
   s1 = 0.0
   do i = 1,n
      s = s + abs(a(j,i))
      s1 = s1 + abs(a(i,j))
   end do
   anorm = max(s,anorm)
   anorm1 = max(s1,anorm1)
end do
anorm = min(anorm,anorm1)
s = anorm + 0.1
if (s == anorm) go to 200
!              Select the normalization factor
m = 0
if (anorm <= 1.0) go to 40
factor = 1.0
20 m = m + 1
factor = 2.0*factor
if (anorm > factor) go to 20
!                Normalize the matrix a
do j = 1,n
   do i = 1,n
      a(i,j) = a(i,j)/factor
   end do
end do
40 np1 = n + 1
np6 = n + 6
do j = 1,n
!     Compute the j-TH column of first eight powers of A
   do i = 1,n
      s = 0.0
      do l = 1,n
         s = s + a(i,l)*a(l,j)
      end do
      wk(i,np1) = s
   end do
   do k = np1,np6
      kp1 = k + 1
      do i = 1,n
         s = 0.0
         do l = 1,n
            s = s + a(i,l)*wk(l,k)
         end do
         wk(i,kp1) = s
      end do
   end do
!     Compute the j-TH column of the numerator and denominator
!                  of the Pade approximation
   do i = 1,n
      p = 0.0
      q = 0.0
      k = 8
      l = n + 7
      do ll = 1,7
         s = c(k)*wk(i,l)
         p = s + p
         q = s - q
         k = k - 1
         l = l - 1
      end do
      s = c(1)*a(i,j)
      z(i,j) = p + s
      wk(i,j) = q - s
      if (i /= j) go to 90
      z(i,j) = z(i,j) + 1.0
      wk(i,j) = wk(i,j) + 1.0
90    continue
   end do
end do
!        Calculate exp(a) by solving  wk * exp(a) = z
call slv(n, n, wk, n, z, kz, ierr)
if (ierr /= 0) go to 210
if (m == 0) go to 150
!          Take out the effect of the normalization
!                   operation on exp(a)
do k = 1,m
   do j = 1,n
      do i = 1,n
         s = 0.0
         do l = 1,n
            s = s + z(i,l)*z(l,j)
         end do
         wk(i,j) = s
      end do
   end do
   do j = 1,n
      do i = 1,n
         z(i,j) = wk(i,j)
      end do
   end do
end do
!            Take out the effect of the balancing
!                   operation on exp(a)
150 call balinv(kz,n,z,low,igh,wk(1,n + 8))
return
!                     Error return
200 ierr = 1
return
210 ierr = 2
end subroutine mexp

subroutine dmexp(a, ka, n, z, kz, wk, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kz
integer :: n
double precision, intent(inout) :: a(ka,n), z(kz,n), wk(n,*)
integer :: i, igh, j, k, kp1, l, ll, low, m, np1, np10
double precision :: anorm, anorm1, factor, p, q, s, s1
double precision, parameter :: c(12) = [.500000000000000000000000000000d+00, &
   & .119565217391304347826086956522d+00, .181159420289855072463768115942d-01, .194099378881987577639751552795d-02, &
   & .155279503105590062111801242236d-03, .953470633104500381388253241800d-05, .454033634811666848280120591333d-06, &
   & .166924130445465753044161982108d-07, .463678140126293758456005505855d-09, .927356280252587516912011011710d-11, &
   & .120435880552284093105455975547d-12, .772024875335154442983692150941d-15]
! ----------------------------------------------------------------------
!     dmexp computes exp(a) and stores it in z where A is a matrix
!     of order n. A is destroyed by the routine.
!     wk is an array of dimension (n,n+12). wk is a work space
!     for the routine.
!     ierr is a variable that reports the status of the results.
!        ierr = 0  exp(a) was successfully computed.
!        ierr = 1  The norm of A is too large.
!        ierr = 2  The Pade denominator matrix is
!                  singular.
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren Virginia
!     ---------------
!     Coefficients for (12,12) Pade table entry
!     ---------------
! ----------------------------------------------------------------------
ierr = 0
if (n > 1) go to 10
z(1,1) = exp(a(1,1))
return
!       Balance A and select the smaller of the 1-norm
!              and infinity-norm of the result
10 call dbal(ka,n,a,low,igh,wk(1,n + 12))
anorm = 0.d0
anorm1 = 0.d0
do j = 1,n
   s = 0.d0
   s1 = 0.d0
   do i = 1,n
      s = s + abs(a(j,i))
      s1 = s1 + abs(a(i,j))
   end do
   anorm = max(s,anorm)
   anorm1 = max(s1,anorm1)
end do
anorm = min(anorm,anorm1)
s = anorm + 0.1d0
if (s == anorm) go to 200
!              Select the normalization factor
m = 0
if (anorm <= 1.d0) go to 40
factor = 1.d0
20 m = m + 1
factor = 2.d0*factor
if (anorm > factor) go to 20
!                Normalize the matrix a
do j = 1,n
   do i = 1,n
      a(i,j) = a(i,j)/factor
   end do
end do
40 np1 = n + 1
np10 = n + 10
do j = 1,n
!     Compute the j-TH column of the first 12 powers of A
   do i = 1,n
      s = 0.d0
      do l = 1,n
         s = s + a(i,l)*a(l,j)
      end do
      wk(i,np1) = s
   end do
   do k = np1,np10
      kp1 = k + 1
      do i = 1,n
         s = 0.d0
         do l = 1,n
            s = s + a(i,l)*wk(l,k)
         end do
         wk(i,kp1) = s
      end do
   end do
!     Compute the j-TH column of the numerator and denominator
!                  of the Pade approximation
   do i = 1,n
      p = 0.d0
      q = 0.d0
      k = 12
      l = n + 11
      do ll = 1,11
         s = c(k)*wk(i,l)
         p = s + p
         q = s - q
         k = k - 1
         l = l - 1
      end do
      s = c(1)*a(i,j)
      z(i,j) = p + s
      wk(i,j) = q - s
      if (i /= j) go to 90
      z(i,j) = z(i,j) + 1.d0
      wk(i,j) = wk(i,j) + 1.d0
90    continue
   end do
end do
!        Calculate exp(a) by solving  wk * exp(a) = z
call dpslv(n, n, wk, n, z, kz, ierr)
if (ierr /= 0) go to 210
if (m == 0) go to 150
!          Take out the effect of the normalization
!                   operation on exp(a)
do k = 1,m
   do j = 1,n
      do i = 1,n
         s = 0.d0
         do l = 1,n
            s = s + z(i,l)*z(l,j)
         end do
         wk(i,j) = s
      end do
   end do
   do j = 1,n
      do i = 1,n
         z(i,j) = wk(i,j)
      end do
   end do
end do
!            Take out the effect of the balancing
!                   operation on exp(a)
150 call dbalnv(kz,n,z,low,igh,wk(1,n + 12))
return
!                     Error return
200 ierr = 1
return
210 ierr = 2
end subroutine dmexp

subroutine le(rowk,n,b,c,d,ip,ierr)
implicit none
integer, intent(out) :: ierr
integer :: n
real, intent(in) :: b(n)
real, intent(inout) :: c(n), d(*)
integer, intent(inout) :: ip(*)
external rowk
integer :: i, iflag, ij, ijold, ik, j, k, kjold, km1, kp1, last, &
   & lastm1, lcol, lcolp1, m, max, mjold, nm1, np1
real :: bk, c1, cj, ck, dkj
real, parameter :: zero = 0.0
!     ******************************************************************
!     Solution of linear equations with reduced storage
!     ******************************************************************
!     Set the necessary constants
ierr = 0
np1 = n + 1
max = n*n/4 + n + 3
k = 1
iflag = -1
!     Get the first column of the transposed system
call rowk(n,1,c)
bk = b(1)
if (n > 1) go to 10
if (c(1) == zero) go to 200
c(1) = bk/c(1)
return
!     Find the pivot for column 1
10 m = 1
do i = 2,n
   if (abs(c(m)) < abs(c(i))) m = i
end do
ip(1) = m
c1 = c(m)
c(m) = c(1)
c(1) = c1
if (c(1) == zero) go to 200
!     Find the first elementary matrix and store it in d
do i = 2,n
   d(i - 1) = -c(i)/c(1)
end do
d(n) = bk/c(1)
!     k loop - Each k for a new column of the transposed system
do k = 2,n
   kp1 = k + 1
   km1 = k - 1
!       Get column k
   call rowk(n,k,c)
   do j = 1,km1
      m = ip(j)
      cj = c(j)
      c(j) = c(m)
      c(m) = cj
   end do
   bk = b(k)
   iflag = -iflag
   lcol = np1 - k
   lcolp1 = lcol + 1
   lastm1 = 1
   last = max - n + k
   if (k == 2) go to 50
   lastm1 = max - n + km1
   if (iflag < 0) last = last - n + k - 2
   if (iflag > 0) lastm1 = lastm1 - n + k - 3
!     j loop - Effect of columns 1 to k-1 of L-inverse
50 do j = 1,km1
      cj = c(j)
      ij = (j - 1)*lcolp1
      if (j == km1) ij = lastm1 - 1
!     i loop - Effect of L-inverse on rows k to n+1
      do i = k,n
         ij = ij + 1
         c(i) = c(i) + d(ij)*cj
      end do
      bk = bk - d(ij + 1)*cj
   end do
!       k=n CASE
   m = k
   if (k < n) go to 70
   if (c(k) == zero) go to 200
   d(last) = bk/c(k)
   go to 90
!     Find the pivot
70 do i = kp1,n
      if (abs(c(m)) < abs(c(i))) m = i
   end do
   ip(k) = m
   ck = c(m)
   c(m) = c(k)
   c(k) = ck
   if (c(k) == zero) go to 200
!     Find the k-TH elementary matrix
   ik = last
   do i = kp1,n
      d(ik) = -c(i)/c(k)
      ik = ik + 1
   end do
   d(ik) = bk/c(k)
!     Form the product of the elementary matrices
90 do j = 1,km1
      kjold = j*lcolp1 + k - np1
      mjold = kjold + m - k
      ij = (j - 1)*lcol
      ijold = ij + j
      if (j /= km1) go to 100
      kjold = lastm1
      mjold = lastm1 + m - k
      ijold = lastm1
100   ik = last - 1
      dkj = d(mjold)
      d(mjold) = d(kjold)
      do i = kp1,np1
         ij = ij + 1
         ijold = ijold + 1
         ik = ik + 1
         d(ij) = d(ijold) + d(ik)*dkj
      end do
   end do
end do
last = max
if (iflag < 0) last = max - 2
d(n) = d(last)
!     Insert the solution in c
do i = 1,n
   c(i) = d(i)
end do
nm1 = n - 1
do i = 1,nm1
   k = n - i
   m = ip(k)
   ck = c(k)
   c(k) = c(m)
   c(m) = ck
end do
return
!     The system is singular
200 ierr = k
end subroutine le

subroutine dple(rowk,n,b,c,d,ip,ierr)
implicit none
integer, intent(out) :: ierr
integer :: n
double precision, intent(in) :: b(n)
double precision, intent(inout) :: c(n), d(*)
integer, intent(inout) :: ip(*)
external rowk
integer :: i, iflag, ij, ijold, ik, j, k, kjold, km1, kp1, last, &
   & lastm1, lcol, lcolp1, m, max, mjold, nm1, np1
double precision :: bk, cj, ck, c1, dkj
double precision, parameter :: zero = 0.d0
!     ******************************************************************
!     Solution of linear equations with reduced storage
!     ******************************************************************
!     Set the necessary constants
ierr = 0
np1 = n + 1
max = n*n/4 + n + 3
k = 1
iflag = -1
!     Get the first column of the transposed system
call rowk(n,1,c)
bk = b(1)
if (n > 1) go to 10
if (c(1) == zero) go to 200
c(1) = bk/c(1)
return
!     Find the pivot for column 1
10 m = 1
do i = 2,n
   if (abs(c(m)) < abs(c(i))) m = i
end do
ip(1) = m
c1 = c(m)
c(m) = c(1)
c(1) = c1
if (c(1) == zero) go to 200
!     Find the first elementary matrix and store it in d
do i = 2,n
   d(i - 1) = -c(i)/c(1)
end do
d(n) = bk/c(1)
!     k loop - Each k for a new column of the transposed system
do k = 2,n
   kp1 = k + 1
   km1 = k - 1
!       Get column k
   call rowk(n,k,c)
   do j = 1,km1
      m = ip(j)
      cj = c(j)
      c(j) = c(m)
      c(m) = cj
   end do
   bk = b(k)
   iflag = -iflag
   lcol = np1 - k
   lcolp1 = lcol + 1
   lastm1 = 1
   last = max - n + k
   if (k == 2) go to 50
   lastm1 = max - n + km1
   if (iflag < 0) last = last - n + k - 2
   if (iflag > 0) lastm1 = lastm1 - n + k - 3
!     j loop - Effect of columns 1 to k-1 of L-inverse
50 do j = 1,km1
      cj = c(j)
      ij = (j - 1)*lcolp1
      if (j == km1) ij = lastm1 - 1
!     i loop - Effect of L-inverse on rows k to n+1
      do i = k,n
         ij = ij + 1
         c(i) = c(i) + d(ij)*cj
      end do
      bk = bk - d(ij + 1)*cj
   end do
!       k=n CASE
   m = k
   if (k < n) go to 70
   if (c(k) == zero) go to 200
   d(last) = bk/c(k)
   go to 90
!     Find the pivot
70 do i = kp1,n
      if (abs(c(m)) < abs(c(i))) m = i
   end do
   ip(k) = m
   ck = c(m)
   c(m) = c(k)
   c(k) = ck
   if (c(k) == zero) go to 200
!     Find the k-TH elementary matrix
   ik = last
   do i = kp1,n
      d(ik) = -c(i)/c(k)
      ik = ik + 1
   end do
   d(ik) = bk/c(k)
!     Form the product of the elementary matrices
90 do j = 1,km1
      kjold = j*lcolp1 + k - np1
      mjold = kjold + m - k
      ij = (j - 1)*lcol
      ijold = ij + j
      if (j /= km1) go to 100
      kjold = lastm1
      mjold = lastm1 + m - k
      ijold = lastm1
100   ik = last - 1
      dkj = d(mjold)
      d(mjold) = d(kjold)
      do i = kp1,np1
         ij = ij + 1
         ijold = ijold + 1
         ik = ik + 1
         d(ij) = d(ijold) + d(ik)*dkj
      end do
   end do
end do
last = max
if (iflag < 0) last = max - 2
d(n) = d(last)
!     Insert the solution in c
do i = 1,n
   c(i) = d(i)
end do
nm1 = n - 1
do i = 1,nm1
   k = n - i
   m = ip(k)
   ck = c(k)
   c(k) = c(m)
   c(m) = ck
end do
return
!     The system is singular
200 ierr = k
end subroutine dple

subroutine cle(rowk,n,b,c,d,ip,ierr)
implicit none
integer, intent(out) :: ierr
integer :: n
complex, intent(in) :: b(n)
complex, intent(inout) :: c(n), d(*)
integer, intent(inout) :: ip(*)
external rowk
integer :: i, iflag, ij, ijold, ik, j, k, kjold, km1, kp1, last, &
   & lastm1, lcol, lcolp1, m, max, mjold, nm1, np1
real :: s, si
complex :: bk, cj, ck, c1, dkj
complex, parameter :: zero = (0.0,0.0)
!     ******************************************************************
!     Solution of complex linear equations with reduced storage
!     ******************************************************************
!     Set the necessary constants
ierr = 0
np1 = n + 1
max = n*n/4 + n + 3
k = 1
iflag = -1
!     Get the first column of the transposed system
call rowk(n,1,c)
bk = b(1)
if (n > 1) go to 10
if (c(1) == zero) go to 200
c(1) = bk/c(1)
return
!     Find the pivot for column 1
10 m = 1
s = abs(real(c(1))) + abs(aimag(c(1)))
do i = 2,n
   si = abs(real(c(i))) + abs(aimag(c(i)))
   if (si <= s) go to 20
   m = i
   s = si
20 continue
end do
ip(1) = m
c1 = c(m)
c(m) = c(1)
c(1) = c1
if (c(1) == zero) go to 200
!     Find the first elementary matrix and store it in d
do i = 2,n
   d(i - 1) = -c(i)/c(1)
end do
d(n) = bk/c(1)
!     k loop - Each k for a new column of the transposed system
do k = 2,n
   kp1 = k + 1
   km1 = k - 1
!       Get column k
   call rowk(n,k,c)
   do j = 1,km1
      m = ip(j)
      cj = c(j)
      c(j) = c(m)
      c(m) = cj
   end do
   bk = b(k)
   iflag = -iflag
   lcol = np1 - k
   lcolp1 = lcol + 1
   lastm1 = 1
   last = max - n + k
   if (k == 2) go to 50
   lastm1 = max - n + km1
   if (iflag < 0) last = last - n + k - 2
   if (iflag > 0) lastm1 = lastm1 - n + k - 3
!     j loop - Effect of columns 1 to k-1 of L-inverse
50 do j = 1,km1
      cj = c(j)
      ij = (j - 1)*lcolp1
      if (j == km1) ij = lastm1 - 1
!     i loop - Effect of L-inverse on rows k to n+1
      do i = k,n
         ij = ij + 1
         c(i) = c(i) + d(ij)*cj
      end do
      bk = bk - d(ij + 1)*cj
   end do
!       k=n CASE
   m = k
   if (k < n) go to 70
   if (c(k) == zero) go to 200
   d(last) = bk/c(k)
   go to 90
!     Find the pivot
70 s = abs(real(c(k))) + abs(aimag(c(k)))
   do i = kp1,n
      si = abs(real(c(i))) + abs(aimag(c(i)))
      if (si <= s) go to 71
      m = i
      s = si
71    continue
   end do
   ip(k) = m
   ck = c(m)
   c(m) = c(k)
   c(k) = ck
   if (c(k) == zero) go to 200
!     Find the k-TH elementary matrix
   ik = last
   do i = kp1,n
      d(ik) = -c(i)/c(k)
      ik = ik + 1
   end do
   d(ik) = bk/c(k)
!     Form the product of the elementary matrices
90 do j = 1,km1
      kjold = j*lcolp1 + k - np1
      mjold = kjold + m - k
      ij = (j - 1)*lcol
      ijold = ij + j
      if (j /= km1) go to 100
      kjold = lastm1
      mjold = lastm1 + m - k
      ijold = lastm1
100   ik = last - 1
      dkj = d(mjold)
      d(mjold) = d(kjold)
      do i = kp1,np1
         ij = ij + 1
         ijold = ijold + 1
         ik = ik + 1
         d(ij) = d(ijold) + d(ik)*dkj
      end do
   end do
end do
last = max
if (iflag < 0) last = max - 2
d(n) = d(last)
!     Insert the solution in c
do i = 1,n
   c(i) = d(i)
end do
nm1 = n - 1
do i = 1,nm1
   k = n - i
   m = ip(k)
   ck = c(k)
   c(k) = c(m)
   c(m) = ck
end do
return
!     The system is singular
200 ierr = k
end subroutine cle

pure subroutine cvbr(b,kb,m,n,ml,mu,a,ka)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
real, intent(inout) :: a(ka,n)
real, intent(in) :: b(kb,*)
integer :: i, imax, imax0, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!           Conversion of real matrices from banded to
!                         standard form
!-----------------------------------------------------------------------
!     Store the nonzero data of the first ml rows
if (ml == 0) go to 20
do i = 1,ml
   jmax = min(n,i + mu)
   k = ml + 1 - i
   do j = 1,jmax
      k = k + 1
      a(i,j) = b(i,k)
   end do
end do
!     Store the remaining nonzero data
20 imin = ml + 1
imax = min(m,ml + n)
l = 0
do i = imin,imax
   jmin = i - ml
   jmax = min(n,i + mu)
   j = jmax
   do jj = jmin,jmax
      k = j - l
      a(i,j) = b(i,k)
      j = j - 1
   end do
   l = l + 1
end do
!     Insert zeros in the upper right corner
jmin = mu + 2
if (jmin > n) go to 40
imax0 = 1
do j = jmin,n
   do i = 1,imax0
      a(i,j) = 0.0
   end do
   imax0 = min(imax,imax0 + 1)
end do
!     Insert zeros in the lower left corner
40 if (imin == imax) go to 50
jmax = imax - imin
do j = 1,jmax
   imin = imin + 1
   do i = imin,imax
      a(i,j) = 0.0
   end do
end do
!     Store zeros in the final m-imax rows
50 if (imax == m) return
imin = imax + 1
do j = 1,n
   do i = imin,m
      a(i,j) = 0.0
   end do
end do
end subroutine cvbr

pure subroutine cvrb(a,ka,m,n,ml,mu,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,*)
integer :: i, imax, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of real matrices from standard to banded
!                    form when ml and mu are given
!-----------------------------------------------------------------------
!     Store the nonzero data of the first ml rows
if (ml == 0) go to 30
l = ml
do i = 1,ml
   jmax = min(n,i + mu)
   j = jmax
   do jj = 1,jmax
      k = j + l
      b(i,k) = a(i,j)
      j = j - 1
   end do
   l = l - 1
end do
!     Insert zeros in the upper left corner
imax = ml
do j = 1,ml
   do i = 1,imax
      b(i,j) = 0.0
   end do
   imax = imax - 1
end do
!     Store the remaining nonzero data
30 imin = ml + 1
imax = min(m,ml + n)
do i = imin,imax
   jmin = i - ml
   jmax = min(n,i + mu)
   k = 0
   do j = jmin,jmax
      k = k + 1
      b(i,k) = a(i,j)
   end do
end do
!     Insert zeros in the lower right corner
jmax = ml + mu + 1
if (k == jmax) go to 50
jmin = k + 1
imin = imax
do j = jmin,jmax
   do i = imin,imax
      b(i,j) = 0.0
   end do
   imin = imin - 1
end do
!     Store zeros in the final m-imax rows
50 if (imax == m) return
imin = imax + 1
do j = 1,jmax
   do i = imin,m
      b(i,j) = 0.0
   end do
end do
end subroutine cvrb

pure subroutine cvrb1(a,ka,m,n,ml,mu,b,kb,nb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m
integer, intent(inout) :: ml, mu
integer, intent(in) :: n, nb
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,nb)
integer :: i, imax, imin, j, jmax, jmin, kmax, l, mm1, nm1
interface
   pure subroutine cvrb(a,ka,m,n,ml,mu,b,kb)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: n
      integer, intent(in) :: ka
      real, intent(in) :: a(ka,n)
      integer, intent(in) :: m
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      real, intent(inout) :: b(kb,*)
   end subroutine cvrb
end interface
!-----------------------------------------------------------------------
!           Conversion of real matrices from standard
!                        to banded form
!-----------------------------------------------------------------------
!     Computation of ml and mu
nm1 = n - 1
imin = m
if (m == 1) go to 20
nswc_exit_1 : do l = 2 , m
   j = 1
   imax = min(m,imin + nm1)
   do i = imin,imax
      if ( a ( i , j ) /= 0.0 ) exit nswc_exit_1
      j = j + 1
   end do
   imin = imin - 1
end do nswc_exit_1
20 mm1 = m - 1
jmin = n
if (n == 1) go to 30
nswc_exit_2 : do l = 2 , n
   i = 1
   jmax = min(n,jmin + mm1)
   do j = jmin,jmax
      if ( a ( i , j ) /= 0.0 ) exit nswc_exit_2
      i = i + 1
   end do
   jmin = jmin - 1
end do nswc_exit_2
30 ml = imin - 1
mu = jmin - 1
kmax = ml + mu + 1
if (kmax > nb) go to 40
!     Store the matrix in b
ierr = 0
call cvrb(a,ka,m,n,ml,mu,b,kb)
return
!     Error return
40 ierr = kmax
end subroutine cvrb1

pure subroutine cvbd(b,kb,m,n,ml,mu,a,ka)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
double precision, intent(inout) :: a(ka,n)
double precision, intent(in) :: b(kb,*)
integer :: i, imax, imax0, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of double precision matrices from banded
!                         to standard form
!-----------------------------------------------------------------------
!     Store the nonzero data of the first ml rows
if (ml == 0) go to 20
do i = 1,ml
   jmax = min(n,i + mu)
   k = ml + 1 - i
   do j = 1,jmax
      k = k + 1
      a(i,j) = b(i,k)
   end do
end do
!     Store the remaining nonzero data
20 imin = ml + 1
imax = min(m,ml + n)
l = 0
do i = imin,imax
   jmin = i - ml
   jmax = min(n,i + mu)
   j = jmax
   do jj = jmin,jmax
      k = j - l
      a(i,j) = b(i,k)
      j = j - 1
   end do
   l = l + 1
end do
!     Insert zeros in the upper right corner
jmin = mu + 2
if (jmin > n) go to 40
imax0 = 1
do j = jmin,n
   do i = 1,imax0
      a(i,j) = 0.d0
   end do
   imax0 = min(imax,imax0 + 1)
end do
!     Insert zeros in the lower left corner
40 if (imin == imax) go to 50
jmax = imax - imin
do j = 1,jmax
   imin = imin + 1
   do i = imin,imax
      a(i,j) = 0.d0
   end do
end do
!     Store zeros in the final m-imax rows
50 if (imax == m) return
imin = imax + 1
do j = 1,n
   do i = imin,m
      a(i,j) = 0.d0
   end do
end do
end subroutine cvbd

pure subroutine cvdb(a,ka,m,n,ml,mu,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,*)
integer :: i, imax, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of double precision matrices from standard
!               to banded form when ml and mu are given
!-----------------------------------------------------------------------
!     Store the nonzero data of the first ml rows
if (ml == 0) go to 30
l = ml
do i = 1,ml
   jmax = min(n,i + mu)
   j = jmax
   do jj = 1,jmax
      k = j + l
      b(i,k) = a(i,j)
      j = j - 1
   end do
   l = l - 1
end do
!     Insert zeros in the upper left corner
imax = ml
do j = 1,ml
   do i = 1,imax
      b(i,j) = 0.d0
   end do
   imax = imax - 1
end do
!     Store the remaining nonzero data
30 imin = ml + 1
imax = min(m,ml + n)
do i = imin,imax
   jmin = i - ml
   jmax = min(n,i + mu)
   k = 0
   do j = jmin,jmax
      k = k + 1
      b(i,k) = a(i,j)
   end do
end do
!     Insert zeros in the lower right corner
jmax = ml + mu + 1
if (k == jmax) go to 50
jmin = k + 1
imin = imax
do j = jmin,jmax
   do i = imin,imax
      b(i,j) = 0.d0
   end do
   imin = imin - 1
end do
!     Store zeros in the final m-imax rows
50 if (imax == m) return
imin = imax + 1
do j = 1,jmax
   do i = imin,m
      b(i,j) = 0.d0
   end do
end do
end subroutine cvdb

pure subroutine cvdb1(a,ka,m,n,ml,mu,b,kb,nb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m
integer, intent(inout) :: ml, mu
integer, intent(in) :: n, nb
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,nb)
integer :: i, imax, imin, j, jmax, jmin, kmax, l, mm1, nm1
interface
   pure subroutine cvdb(a,ka,m,n,ml,mu,b,kb)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: n
      integer, intent(in) :: ka
      double precision, intent(in) :: a(ka,n)
      integer, intent(in) :: m
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      double precision, intent(inout) :: b(kb,*)
   end subroutine cvdb
end interface
!-----------------------------------------------------------------------
!        Conversion of double precision matrices from standard
!                         to banded form
!-----------------------------------------------------------------------
!     Computation of ml and mu
nm1 = n - 1
imin = m
if (m == 1) go to 20
nswc_exit_1 : do l = 2 , m
   j = 1
   imax = min(m,imin + nm1)
   do i = imin,imax
      if ( a ( i , j ) /= 0.d0 ) exit nswc_exit_1
      j = j + 1
   end do
   imin = imin - 1
end do nswc_exit_1
20 mm1 = m - 1
jmin = n
if (n == 1) go to 30
nswc_exit_2 : do l = 2 , n
   i = 1
   jmax = min(n,jmin + mm1)
   do j = jmin,jmax
      if ( a ( i , j ) /= 0.d0 ) exit nswc_exit_2
      i = i + 1
   end do
   jmin = jmin - 1
end do nswc_exit_2
30 ml = imin - 1
mu = jmin - 1
kmax = ml + mu + 1
if (kmax > nb) go to 40
!     Store the matrix in b
ierr = 0
call cvdb(a,ka,m,n,ml,mu,b,kb)
return
!     Error return
40 ierr = kmax
end subroutine cvdb1

pure subroutine cvbc(b,kb,m,n,ml,mu,a,ka)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
complex, intent(inout) :: a(ka,n)
complex, intent(in) :: b(kb,*)
integer :: i, imax, imax0, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!          Conversion of complex matrices from banded to
!                          standard form
!-----------------------------------------------------------------------
!     Store the nonzero data of the first ml rows
if (ml == 0) go to 20
do i = 1,ml
   jmax = min(n,i + mu)
   k = ml + 1 - i
   do j = 1,jmax
      k = k + 1
      a(i,j) = b(i,k)
   end do
end do
!     Store the remaining nonzero data
20 imin = ml + 1
imax = min(m,ml + n)
l = 0
do i = imin,imax
   jmin = i - ml
   jmax = min(n,i + mu)
   j = jmax
   do jj = jmin,jmax
      k = j - l
      a(i,j) = b(i,k)
      j = j - 1
   end do
   l = l + 1
end do
!     Insert zeros in the upper right corner
jmin = mu + 2
if (jmin > n) go to 40
imax0 = 1
do j = jmin,n
   do i = 1,imax0
      a(i,j) = (0.0,0.0)
   end do
   imax0 = min(imax,imax0 + 1)
end do
!     Insert zeros in the lower left corner
40 if (imin == imax) go to 50
jmax = imax - imin
do j = 1,jmax
   imin = imin + 1
   do i = imin,imax
      a(i,j) = (0.0,0.0)
   end do
end do
!     Store zeros in the final m-imax rows
50 if (imax == m) return
imin = imax + 1
do j = 1,n
   do i = imin,m
      a(i,j) = (0.0,0.0)
   end do
end do
end subroutine cvbc

pure subroutine cvcb(a,ka,m,n,ml,mu,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,*)
integer :: i, imax, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of complex matrices from standard to banded
!                    form when ml and mu are given
!-----------------------------------------------------------------------
!     Store the nonzero data of the first ml rows
if (ml == 0) go to 30
l = ml
do i = 1,ml
   jmax = min(n,i + mu)
   j = jmax
   do jj = 1,jmax
      k = j + l
      b(i,k) = a(i,j)
      j = j - 1
   end do
   l = l - 1
end do
!     Insert zeros in the upper left corner
imax = ml
do j = 1,ml
   do i = 1,imax
      b(i,j) = (0.0,0.0)
   end do
   imax = imax - 1
end do
!     Store the remaining nonzero data
30 imin = ml + 1
imax = min(m,ml + n)
do i = imin,imax
   jmin = i - ml
   jmax = min(n,i + mu)
   k = 0
   do j = jmin,jmax
      k = k + 1
      b(i,k) = a(i,j)
   end do
end do
!     Insert zeros in the lower right corner
jmax = ml + mu + 1
if (k == jmax) go to 50
jmin = k + 1
imin = imax
do j = jmin,jmax
   do i = imin,imax
      b(i,j) = (0.0,0.0)
   end do
   imin = imin - 1
end do
!     Store zeros in the final m-imax rows
50 if (imax == m) return
imin = imax + 1
do j = 1,jmax
   do i = imin,m
      b(i,j) = (0.0,0.0)
   end do
end do
end subroutine cvcb

pure subroutine cvcb1(a,ka,m,n,ml,mu,b,kb,nb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m
integer, intent(inout) :: ml, mu
integer, intent(in) :: n, nb
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,nb)
integer :: i, imax, imin, j, jmax, jmin, kmax, l, mm1, nm1
interface
   pure subroutine cvcb(a,ka,m,n,ml,mu,b,kb)
      implicit none
      integer, intent(in) :: kb
      integer, intent(in) :: n
      integer, intent(in) :: ka
      complex, intent(in) :: a(ka,n)
      integer, intent(in) :: m
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      complex, intent(inout) :: b(kb,*)
   end subroutine cvcb
end interface
!-----------------------------------------------------------------------
!           Conversion of complex matrices from standard
!                          to banded form
!-----------------------------------------------------------------------
!     Computation of ml and mu
nm1 = n - 1
imin = m
if (m == 1) go to 20
nswc_exit_1 : do l = 2 , m
   j = 1
   imax = min(m,imin + nm1)
   do i = imin,imax
      if ( a ( i , j ) /= ( 0.0 , 0.0 ) ) exit nswc_exit_1
      j = j + 1
   end do
   imin = imin - 1
end do nswc_exit_1
20 mm1 = m - 1
jmin = n
if (n == 1) go to 30
nswc_exit_2 : do l = 2 , n
   i = 1
   jmax = min(n,jmin + mm1)
   do j = jmin,jmax
      if ( a ( i , j ) /= ( 0.0 , 0.0 ) ) exit nswc_exit_2
      i = i + 1
   end do
   jmin = jmin - 1
end do nswc_exit_2
30 ml = imin - 1
mu = jmin - 1
kmax = ml + mu + 1
if (kmax > nb) go to 40
!     Store the matrix in b
ierr = 0
call cvcb(a,ka,m,n,ml,mu,b,kb)
return
!     Error return
40 ierr = kmax
end subroutine cvcb1

pure subroutine mcvbs(a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, ml, mu, n, num
real, intent(in) :: a(ka,*)
real, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, imax, imin, j0, k, kmax, kmin, l, mp1
!-----------------------------------------------------------------------
!                Conversion of real matrices from banded
!                            to sparse form
!-----------------------------------------------------------------------
l = 1
kmax = ml + mu + 1
!     Store the nonzero data of the first ml rows
j0 = ml
if (ml == 0) go to 20
do i = 1,ml
   ib(i) = l
   kmin = 1 + j0
   do k = kmin,kmax
      if (a(i,k) == 0.0) go to 10
      if (l > num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
10    continue
   end do
   j0 = j0 - 1
end do
!     Store the remaining nonzero data
20 imin = ml + 1
imax = min(m,ml + n)
do i = imin,imax
   ib(i) = l
   do k = 1,kmax
      if (a(i,k) == 0.0) go to 21
      if (l > num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
21    continue
   end do
   j0 = j0 - 1
end do
ierr = 0
!     Set up the remaining m-imax rows
imin = imax + 1
mp1 = m + 1
do i = imin,mp1
   ib(i) = l
end do
return
!     Error return
40 ierr = i
end subroutine mcvbs

pure subroutine dmcvbs(a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, ml, mu, n, num
double precision, intent(in) :: a(ka,*)
double precision, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, imax, imin, j0, k, kmax, kmin, l, mp1
!-----------------------------------------------------------------------
!          Conversion of double precision matrices from banded
!                            to sparse form
!-----------------------------------------------------------------------
l = 1
kmax = ml + mu + 1
!     Store the nonzero data of the first ml rows
j0 = ml
if (ml == 0) go to 20
do i = 1,ml
   ib(i) = l
   kmin = 1 + j0
   do k = kmin,kmax
      if (a(i,k) == 0.d0) go to 10
      if (l > num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
10    continue
   end do
   j0 = j0 - 1
end do
!     Store the remaining nonzero data
20 imin = ml + 1
imax = min(m,ml + n)
do i = imin,imax
   ib(i) = l
   do k = 1,kmax
      if (a(i,k) == 0.d0) go to 21
      if (l > num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
21    continue
   end do
   j0 = j0 - 1
end do
ierr = 0
!     Set up the remaining m-imax rows
imin = imax + 1
mp1 = m + 1
do i = imin,mp1
   ib(i) = l
end do
return
!     Error return
40 ierr = i
end subroutine dmcvbs

pure subroutine cmcvbs(a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, ml, mu, n, num
complex, intent(in) :: a(ka,*)
complex, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, imax, imin, j0, k, kmax, kmin, l, mp1
!-----------------------------------------------------------------------
!              Conversion of complex matrices from banded
!                            to sparse form
!-----------------------------------------------------------------------
l = 1
kmax = ml + mu + 1
!     Store the nonzero data of the first ml rows
j0 = ml
if (ml == 0) go to 20
do i = 1,ml
   ib(i) = l
   kmin = 1 + j0
   do k = kmin,kmax
      if (a(i,k) == (0.0,0.0)) go to 10
      if (l > num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
10    continue
   end do
   j0 = j0 - 1
end do
!     Store the remaining nonzero data
20 imin = ml + 1
imax = min(m,ml + n)
do i = imin,imax
   ib(i) = l
   do k = 1,kmax
      if (a(i,k) == (0.0,0.0)) go to 21
      if (l > num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
21    continue
   end do
   j0 = j0 - 1
end do
ierr = 0
!     Set up the remaining m-imax rows
imin = imax + 1
mp1 = m + 1
do i = imin,mp1
   ib(i) = l
end do
return
!     Error return
40 ierr = i
end subroutine cmcvbs

subroutine mcvsb(a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m
integer, intent(out) :: ml, mu
integer, intent(in) :: n, nb
real, intent(in) :: a(*)
real, intent(inout) :: b(kb,nb)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j0, k, kmax, l, lmax, lmin
!-----------------------------------------------------------------------
!                Conversion of real matrices from sparse
!                            to banded form
!-----------------------------------------------------------------------
!     Computation of ml and mu
ml = 0
mu = 0
do i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      if (a(l) == 0.0) go to 10
      k = ja(l) - i
      mu = max(mu,k)
      ml = max(ml,-k)
10    continue
   end do
11 continue
end do
!     Set b = 0 If b provides sufficient storage
kmax = ml + mu + 1
if (kmax > nb) go to 40
ierr = 0
do k = 1,kmax
   do i = 1,m
      b(i,k) = 0.0
   end do
end do
!     Store the matrix in b
j0 = ml
do i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 31
   do l = lmin,lmax
      if (a(l) == 0.0) go to 30
      k = ja(l) + j0
      b(i,k) = a(l)
30    continue
   end do
   j0 = j0 - 1
31 continue
end do
return
!     Error return
40 ierr = kmax
end subroutine mcvsb

subroutine dmcvsb(a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m
integer, intent(out) :: ml, mu
integer, intent(in) :: n, nb
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(kb,nb)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j0, k, kmax, l, lmax, lmin
!-----------------------------------------------------------------------
!          Conversion of double precision matrices from sparse
!                            to banded form
!-----------------------------------------------------------------------
!     Computation of ml and mu
ml = 0
mu = 0
do i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      if (a(l) == 0.d0) go to 10
      k = ja(l) - i
      mu = max(mu,k)
      ml = max(ml,-k)
10    continue
   end do
11 continue
end do
!     Set b = 0 If b provides sufficient storage
kmax = ml + mu + 1
if (kmax > nb) go to 40
ierr = 0
do k = 1,kmax
   do i = 1,m
      b(i,k) = 0.d0
   end do
end do
!     Store the matrix in b
j0 = ml
do i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 31
   do l = lmin,lmax
      if (a(l) == 0.d0) go to 30
      k = ja(l) + j0
      b(i,k) = a(l)
30    continue
   end do
   j0 = j0 - 1
31 continue
end do
return
!     Error return
40 ierr = kmax
end subroutine dmcvsb

subroutine cmcvsb(a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m
integer, intent(out) :: ml, mu
integer, intent(in) :: n, nb
complex, intent(in) :: a(*)
complex, intent(inout) :: b(kb,nb)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j0, k, kmax, l, lmax, lmin
!-----------------------------------------------------------------------
!              Conversion of complex matrices from sparse
!                            to banded form
!-----------------------------------------------------------------------
!     Computation of ml and mu
ml = 0
mu = 0
do i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      if (a(l) == (0.0,0.0)) go to 10
      k = ja(l) - i
      mu = max(mu,k)
      ml = max(ml,-k)
10    continue
   end do
11 continue
end do
!     Set b = 0 If b provides sufficient storage
kmax = ml + mu + 1
if (kmax > nb) go to 40
ierr = 0
do k = 1,kmax
   do i = 1,m
      b(i,k) = (0.0,0.0)
   end do
end do
!     Store the matrix in b
j0 = ml
do i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 31
   do l = lmin,lmax
      if (a(l) == (0.0,0.0)) go to 30
      k = ja(l) + j0
      b(i,k) = a(l)
30    continue
   end do
   j0 = j0 - 1
31 continue
end do
return
!     Error return
40 ierr = kmax
end subroutine cmcvsb

pure subroutine bcvrd(a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
real, intent(in) :: a(ka,*)
double precision, intent(inout) :: b(kb,*)
integer :: i, j, num
!-----------------------------------------------------------------------
!        Conversion of banded matrices from single to double
!                          precision form
!-----------------------------------------------------------------------
num = ml + mu + 1
do j = 1,num
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
end subroutine bcvrd

pure subroutine bcvdr(a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
double precision, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,*)
integer :: i, j, num
!-----------------------------------------------------------------------
!        Conversion of banded matrices from double to single
!                          precision form
!-----------------------------------------------------------------------
num = ml + mu + 1
do j = 1,num
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
end subroutine bcvdr

pure subroutine breal(a, ka, m, n, ml, mu, b, kb, l, nl, nu, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, l, m, ml, mu, n
integer, intent(out) :: nl
integer, intent(inout) :: nu
complex, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,l)
integer :: i, imin, j, k, num
!-----------------------------------------------------------------------
!              Real part of a banded complex matrix
!-----------------------------------------------------------------------
!     Computation of nl and nu
nl = ml
if (ml == 0) go to 30
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( real ( a ( i , j ) ) /= 0.0 ) exit nswc_exit_1
   end do
   nl = nl - 1
   imin = imin - 1
end do nswc_exit_1
30 nu = mu
if (mu == 0) go to 60
j = ml + mu + 1
nswc_exit_2 : do k = 1 , mu
   do i = 1,m
      if ( real ( a ( i , j ) ) /= 0.0 ) exit nswc_exit_2
   end do
   nu = nu - 1
   j = j - 1
end do nswc_exit_2
!     Store the real part of A in b
60 num = nl + nu + 1
if (num > l) go to 100
ierr = 0
k = ml - nl
do j = 1,num
   k = k + 1
   do i = 1,m
      b(i,j) = real(a(i,k))
   end do
end do
return
!     Error return
100 ierr = num
end subroutine breal

pure subroutine bimag(a, ka, m, n, ml, mu, b, kb, l, nl, nu, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, l, m, ml, mu, n
integer, intent(out) :: nl
integer, intent(inout) :: nu
complex, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,l)
integer :: i, imin, j, k, num
!-----------------------------------------------------------------------
!            Imaginary part of a banded complex matrix
!-----------------------------------------------------------------------
!     Computation of nl and nu
nl = ml
if (ml == 0) go to 30
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( aimag ( a ( i , j ) ) /= 0.0 ) exit nswc_exit_1
   end do
   nl = nl - 1
   imin = imin - 1
end do nswc_exit_1
30 nu = mu
if (mu == 0) go to 60
j = ml + mu + 1
nswc_exit_2 : do k = 1 , mu
   do i = 1,m
      if ( aimag ( a ( i , j ) ) /= 0.0 ) exit nswc_exit_2
   end do
   nu = nu - 1
   j = j - 1
end do nswc_exit_2
!     Store the imaginary part of A in b
60 num = nl + nu + 1
if (num > l) go to 100
ierr = 0
k = ml - nl
do j = 1,num
   k = k + 1
   do i = 1,m
      b(i,j) = aimag(a(i,k))
   end do
end do
return
!     Error return
100 ierr = num
end subroutine bimag

pure subroutine bcvrc(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(out) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
real, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,l)
integer :: i, j, ja, jb, jc, jmax, k, num
!-----------------------------------------------------------------------
!        Compute a + bi for the banded real matrices A and b
!-----------------------------------------------------------------------
mcl = max(ml,nl)
mcu = max(mu,nu)
num = mcl + mcu + 1
if (num > l) go to 200
ierr = 0
k = min(mu,nu) + 1
!     Insert the first abs(ml - nl) diagonals
if (nl >= ml) go to 30
ja = ml - nl
jb = 0
jc = ja
jmax = nl + k
do j = 1,jc
   do i = 1,m
      c(i,j) = cmplx(a(i,j),0.0)
   end do
end do
go to 60
30 ja = 0
jb = nl - ml
jc = jb
jmax = ml + k
if (jc == 0) go to 60
do j = 1,jc
   do i = 1,m
      c(i,j) = cmplx(0.0,b(i,j))
   end do
end do
!     Addition of the common diagonals
60 do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = cmplx(a(i,ja),b(i,jb))
   end do
end do
!     Insertion of the remaining diagonals
if (nu >= mu) go to 120
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = cmplx(a(i,ja),0.0)
   end do
end do
return
120 jmax = nu - mu
if (jmax == 0) return
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = cmplx(0.0,b(i,jb))
   end do
end do
return
!     Error return
200 ierr = num
end subroutine bcvrc

pure subroutine bpose(a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
real, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,*)
integer :: i, imax, imin, j, jmin, k, l, lj, lp1, ndiag
!-----------------------------------------------------------------------
!                Transposition of real banded matrices
!-----------------------------------------------------------------------
l = ml + mu + 1
lp1 = l + 1
if (mu == 0) go to 40
!     Define the first mu columns of b
ndiag = mu
do j = 1,mu
   do i = 1,ndiag
      b(i,j) = 0.0
   end do
   lj = lp1 - j
   imax = min(m,n - ndiag)
   do i = 1,imax
      k = ndiag + i
      b(k,j) = a(i,lj)
   end do
   if (k == n) go to 31
   imin = k + 1
   do i = imin,n
      b(i,j) = 0.0
   end do
31 ndiag = ndiag - 1
end do
!     Define the remaining columns of b
40 jmin = mu + 1
ndiag = 0
do j = jmin,l
   lj = lp1 - j
   imax = min(m - ndiag,n)
   do i = 1,imax
      k = ndiag + i
      b(i,j) = a(k,lj)
   end do
   if (imax == n) go to 61
   imin = imax + 1
   do i = imin,n
      b(i,j) = 0.0
   end do
61 ndiag = ndiag + 1
end do
end subroutine bpose

pure subroutine dbpose(a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
double precision, intent(in) :: a(ka,*)
double precision, intent(inout) :: b(kb,*)
integer :: i, imax, imin, j, jmin, k, l, lj, lp1, ndiag
!-----------------------------------------------------------------------
!          Transposition of double precision banded matrices
!-----------------------------------------------------------------------
l = ml + mu + 1
lp1 = l + 1
if (mu == 0) go to 40
!     Define the first mu columns of b
ndiag = mu
do j = 1,mu
   do i = 1,ndiag
      b(i,j) = 0.d0
   end do
   lj = lp1 - j
   imax = min(m,n - ndiag)
   do i = 1,imax
      k = ndiag + i
      b(k,j) = a(i,lj)
   end do
   if (k == n) go to 31
   imin = k + 1
   do i = imin,n
      b(i,j) = 0.d0
   end do
31 ndiag = ndiag - 1
end do
!     Define the remaining columns of b
40 jmin = mu + 1
ndiag = 0
do j = jmin,l
   lj = lp1 - j
   imax = min(m - ndiag,n)
   do i = 1,imax
      k = ndiag + i
      b(i,j) = a(k,lj)
   end do
   if (imax == n) go to 61
   imin = imax + 1
   do i = imin,n
      b(i,j) = 0.d0
   end do
61 ndiag = ndiag + 1
end do
end subroutine dbpose

pure subroutine cbpose(a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
complex, intent(in) :: a(ka,*)
complex, intent(inout) :: b(kb,*)
integer :: i, imax, imin, j, jmin, k, l, lj, lp1, ndiag
!-----------------------------------------------------------------------
!              Transposition of complex banded matrices
!-----------------------------------------------------------------------
l = ml + mu + 1
lp1 = l + 1
if (mu == 0) go to 40
!     Define the first mu columns of b
ndiag = mu
do j = 1,mu
   do i = 1,ndiag
      b(i,j) = (0.0,0.0)
   end do
   lj = lp1 - j
   imax = min(m,n - ndiag)
   do i = 1,imax
      k = ndiag + i
      b(k,j) = a(i,lj)
   end do
   if (k == n) go to 31
   imin = k + 1
   do i = imin,n
      b(i,j) = (0.0,0.0)
   end do
31 ndiag = ndiag - 1
end do
!     Define the remaining columns of b
40 jmin = mu + 1
ndiag = 0
do j = jmin,l
   lj = lp1 - j
   imax = min(m - ndiag,n)
   do i = 1,imax
      k = ndiag + i
      b(i,j) = a(k,lj)
   end do
   if (imax == n) go to 61
   imin = imax + 1
   do i = imin,n
      b(i,j) = (0.0,0.0)
   end do
61 ndiag = ndiag + 1
end do
end subroutine cbpose

pure subroutine badd(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
real, intent(in) :: a(ka,*), b(kb,*)
real, intent(inout) :: c(kc,l)
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num, nswc_ai_i4
!-----------------------------------------------------------------------
!                 Addition of real banded matrices
!-----------------------------------------------------------------------
ierr = 0
nswc_ai_i4 = nl - ml
if ( nswc_ai_i4 < 0 ) go to 10
if ( nswc_ai_i4 == 0 ) go to 30
go to 20
!     Insert the first abs(ml - nl) diagonals
10 mcl = ml
if (ml >= l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = a(i,j)
   end do
end do
go to 50
20 mcl = nl
if (nl >= l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = b(i,j)
   end do
end do
go to 50
!     COMPUTE mcl WHEN ml = nl
30 mcl = ml
if (ml == 0) go to 40
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( ( a ( i , j ) + b ( i , j ) ) /= 0.0 ) exit nswc_exit_1
   end do
   mcl = mcl - 1
   imin = imin - 1
end do nswc_exit_1
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
50 nswc_ai_i4 = nu - mu
if ( nswc_ai_i4 < 0 ) go to 100
if ( nswc_ai_i4 == 0 ) go to 160
go to 130
!     Insertion of the remaining diagonals when mu .NE. nu
100 mcu = mu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja)
   end do
end do
return
130 mcu = nu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = b(i,jb)
   end do
end do
return
!     Compute mcu when mu = nu
160 mcu = mu
if (mu == 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
nswc_exit_2 : do j = 1 , mu
   do i = 1,m
      if ( ( a ( i , la ) + b ( i , lb ) ) /= 0.0 ) exit nswc_exit_2
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do nswc_exit_2
!     Addition of the remaining columns when mu = nu
170 num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mcu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
return
!     Error return
200 ierr = num
end subroutine badd

pure subroutine dbadd(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
double precision, intent(in) :: a(ka,*), b(kb,*)
double precision, intent(inout) :: c(kc,l)
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num, nswc_ai_i4
!-----------------------------------------------------------------------
!           Addition of double precision banded matrices
!-----------------------------------------------------------------------
ierr = 0
nswc_ai_i4 = nl - ml
if ( nswc_ai_i4 < 0 ) go to 10
if ( nswc_ai_i4 == 0 ) go to 30
go to 20
!     Insert the first abs(ml - nl) diagonals
10 mcl = ml
if (ml >= l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = a(i,j)
   end do
end do
go to 50
20 mcl = nl
if (nl >= l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = b(i,j)
   end do
end do
go to 50
!     COMPUTE mcl WHEN ml = nl
30 mcl = ml
if (ml == 0) go to 40
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( ( a ( i , j ) + b ( i , j ) ) /= 0.d0 ) exit nswc_exit_1
   end do
   mcl = mcl - 1
   imin = imin - 1
end do nswc_exit_1
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
50 nswc_ai_i4 = nu - mu
if ( nswc_ai_i4 < 0 ) go to 100
if ( nswc_ai_i4 == 0 ) go to 160
go to 130
!     Insertion of the remaining diagonals when mu .NE. nu
100 mcu = mu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja)
   end do
end do
return
130 mcu = nu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = b(i,jb)
   end do
end do
return
!     Compute mcu when mu = nu
160 mcu = mu
if (mu == 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
nswc_exit_2 : do j = 1 , mu
   do i = 1,m
      if ( ( a ( i , la ) + b ( i , lb ) ) /= 0.d0 ) exit nswc_exit_2
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do nswc_exit_2
!     Addition of the remaining columns when mu = nu
170 num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mcu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
return
!     Error return
200 ierr = num
end subroutine dbadd

pure subroutine cbadd(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
complex, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,l)
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num, nswc_ai_i4
!-----------------------------------------------------------------------
!                Addition of complex banded matrices
!-----------------------------------------------------------------------
ierr = 0
nswc_ai_i4 = nl - ml
if ( nswc_ai_i4 < 0 ) go to 10
if ( nswc_ai_i4 == 0 ) go to 30
go to 20
!     Insert the first abs(ml - nl) diagonals
10 mcl = ml
if (ml >= l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = a(i,j)
   end do
end do
go to 50
20 mcl = nl
if (nl >= l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = b(i,j)
   end do
end do
go to 50
!     COMPUTE mcl WHEN ml = nl
30 mcl = ml
if (ml == 0) go to 40
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( ( a ( i , j ) + b ( i , j ) ) /= ( 0.0 , 0.0 ) ) exit nswc_exit_1
   end do
   mcl = mcl - 1
   imin = imin - 1
end do nswc_exit_1
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
50 nswc_ai_i4 = nu - mu
if ( nswc_ai_i4 < 0 ) go to 100
if ( nswc_ai_i4 == 0 ) go to 160
go to 130
!     Insertion of the remaining diagonals when mu .NE. nu
100 mcu = mu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja)
   end do
end do
return
130 mcu = nu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = b(i,jb)
   end do
end do
return
!     Compute mcu when mu = nu
160 mcu = mu
if (mu == 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
nswc_exit_2 : do j = 1 , mu
   do i = 1,m
      if ( ( a ( i , la ) + b ( i , lb ) ) /= ( 0.0 , 0.0 ) ) &
         & exit nswc_exit_2
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do nswc_exit_2
!     Addition of the remaining columns when mu = nu
170 num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mcu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
return
!     Error return
200 ierr = num
end subroutine cbadd

pure subroutine bsubt(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
real, intent(in) :: a(ka,*), b(kb,*)
real, intent(inout) :: c(kc,l)
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num, nswc_ai_i4
!-----------------------------------------------------------------------
!                Subtraction of real banded matrices
!-----------------------------------------------------------------------
ierr = 0
nswc_ai_i4 = nl - ml
if ( nswc_ai_i4 < 0 ) go to 10
if ( nswc_ai_i4 == 0 ) go to 30
go to 20
!     Insert the first abs(ml - nl) diagonals
10 mcl = ml
if (ml >= l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = a(i,j)
   end do
end do
go to 50
20 mcl = nl
if (nl >= l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = -b(i,j)
   end do
end do
go to 50
!     COMPUTE mcl WHEN ml = nl
30 mcl = ml
if (ml == 0) go to 40
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( ( a ( i , j ) - b ( i , j ) ) /= 0.0 ) exit nswc_exit_1
   end do
   mcl = mcl - 1
   imin = imin - 1
end do nswc_exit_1
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
50 nswc_ai_i4 = nu - mu
if ( nswc_ai_i4 < 0 ) go to 100
if ( nswc_ai_i4 == 0 ) go to 160
go to 130
!     Insertion of the remaining diagonals when mu .NE. nu
100 mcu = mu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja)
   end do
end do
return
130 mcu = nu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = -b(i,jb)
   end do
end do
return
!     Compute mcu when mu = nu
160 mcu = mu
if (mu == 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
nswc_exit_2 : do j = 1 , mu
   do i = 1,m
      if ( ( a ( i , la ) - b ( i , lb ) ) /= 0.0 ) exit nswc_exit_2
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do nswc_exit_2
!     Addition of the remaining columns when mu = nu
170 num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mcu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
return
!     Error return
200 ierr = num
end subroutine bsubt

pure subroutine dbsubt(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
double precision, intent(in) :: a(ka,*), b(kb,*)
double precision, intent(inout) :: c(kc,l)
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num, nswc_ai_i4
!-----------------------------------------------------------------------
!          Subtraction of double precision banded matrices
!-----------------------------------------------------------------------
ierr = 0
nswc_ai_i4 = nl - ml
if ( nswc_ai_i4 < 0 ) go to 10
if ( nswc_ai_i4 == 0 ) go to 30
go to 20
!     Insert the first abs(ml - nl) diagonals
10 mcl = ml
if (ml >= l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = a(i,j)
   end do
end do
go to 50
20 mcl = nl
if (nl >= l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = -b(i,j)
   end do
end do
go to 50
!     COMPUTE mcl WHEN ml = nl
30 mcl = ml
if (ml == 0) go to 40
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( ( a ( i , j ) - b ( i , j ) ) /= 0.d0 ) exit nswc_exit_1
   end do
   mcl = mcl - 1
   imin = imin - 1
end do nswc_exit_1
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
50 nswc_ai_i4 = nu - mu
if ( nswc_ai_i4 < 0 ) go to 100
if ( nswc_ai_i4 == 0 ) go to 160
go to 130
!     Insertion of the remaining diagonals when mu .NE. nu
100 mcu = mu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja)
   end do
end do
return
130 mcu = nu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = -b(i,jb)
   end do
end do
return
!     Compute mcu when mu = nu
160 mcu = mu
if (mu == 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
nswc_exit_2 : do j = 1 , mu
   do i = 1,m
      if ( ( a ( i , la ) - b ( i , lb ) ) /= 0.d0 ) exit nswc_exit_2
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do nswc_exit_2
!     Addition of the remaining columns when mu = nu
170 num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mcu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
return
!     Error return
200 ierr = num
end subroutine dbsubt

pure subroutine cbsubt(m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
complex, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,l)
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num, nswc_ai_i4
!-----------------------------------------------------------------------
!             Subtraction of complex banded matrices
!-----------------------------------------------------------------------
ierr = 0
nswc_ai_i4 = nl - ml
if ( nswc_ai_i4 < 0 ) go to 10
if ( nswc_ai_i4 == 0 ) go to 30
go to 20
!     Insert the first abs(ml - nl) diagonals
10 mcl = ml
if (ml >= l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = a(i,j)
   end do
end do
go to 50
20 mcl = nl
if (nl >= l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do i = 1,m
      c(i,j) = -b(i,j)
   end do
end do
go to 50
!     COMPUTE mcl WHEN ml = nl
30 mcl = ml
if (ml == 0) go to 40
imin = ml + 1
nswc_exit_1 : do j = 1 , ml
   do i = imin,m
      if ( ( a ( i , j ) - b ( i , j ) ) /= ( 0.0 , 0.0 ) ) exit nswc_exit_1
   end do
   mcl = mcl - 1
   imin = imin - 1
end do nswc_exit_1
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
50 nswc_ai_i4 = nu - mu
if ( nswc_ai_i4 < 0 ) go to 100
if ( nswc_ai_i4 == 0 ) go to 160
go to 130
!     Insertion of the remaining diagonals when mu .NE. nu
100 mcu = mu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja)
   end do
end do
return
130 mcu = nu
num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = -b(i,jb)
   end do
end do
return
!     Compute mcu when mu = nu
160 mcu = mu
if (mu == 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
nswc_exit_2 : do j = 1 , mu
   do i = 1,m
      if ( ( a ( i , la ) - b ( i , lb ) ) /= ( 0.0 , 0.0 ) ) &
         & exit nswc_exit_2
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do nswc_exit_2
!     Addition of the remaining columns when mu = nu
170 num = mcl + mcu + 1
if (num > l) go to 200
jmax = jmax + mcu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
return
!     Error return
200 ierr = num
end subroutine cbsubt

pure subroutine bprod(m, n, l, a, ka, ml, mu, b, kb, nl, nu, &
   & c, kc, nc, mcl, mcu, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nc, nl, nu
real, intent(in) :: a(ka,*), b(kb,*)
real, intent(inout) :: c(kc,nc)
integer :: i, imax, imj, j, jc, jj, jmax, jmi, k, kk, kmax, kmin, &
   & last, maxd, mind, mlp1, ndiag, nlp1, npml, npnu
real :: sum
!-----------------------------------------------------------------------
!                Multiplication of real banded matrices
!-----------------------------------------------------------------------
ierr = 0
do j = 1,nc
   do i = 1,m
      c(i,j) = 0.0
   end do
end do
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min(m - 1,ml + nl)
jc = 0
if (mcl == 0) go to 100
!     Find the first nonzero lower diagonal
maxd = mcl
do ndiag = 1,maxd
   imj = maxd + 1 - ndiag
   jmax = min(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,1) = sum
   end do
   do j = 1,jmax
      i = j + imj
      if (c(i,1) /= 0.0) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
40 if (mcl >= nc) go to 100
jc = 1
if (mcl == 1) go to 100
!     Compute the remaining lower diagonals
mind = ndiag + 1
do ndiag = mind,maxd
   jc = jc + 1
   imj = maxd + 1 - ndiag
   jmax = min(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
end do
!     Find the last nonzero upper diagonal
100 jc = jc + 1
mcu = min(l - 1,mu + nu)
if (mcu == 0) go to 130
maxd = mcu
nswc_exit_1 : do ndiag = 1 , maxd
   jmi = maxd + 1 - ndiag
   imax = min(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
   do i = 1,imax
      if ( c ( i , jc ) /= 0.0 ) exit nswc_exit_1
   end do
   mcu = mcu - 1
end do nswc_exit_1
130 last = mcl + mcu + 1
if (last > nc) go to 200
if (mcu == 0) go to 140
do i = 1,imax
   c(i,last) = c(i,jc)
   c(i,jc) = 0.0
end do
!     Compute the main diagonal and the remaining upper diagonals
140 maxd = max(1,mcu)
do ndiag = 1,maxd
   jmi = ndiag - 1
   imax = min(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
   jc = jc + 1
end do
return
!     Error return
200 ierr = last
end subroutine bprod

pure subroutine dbprod(m, n, l, a, ka, ml, mu, b, kb, nl, nu, &
   & c, kc, nc, mcl, mcu, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nc, nl, nu
double precision, intent(in) :: a(ka,*), b(kb,*)
double precision, intent(inout) :: c(kc,nc)
integer :: i, imax, imj, j, jc, jj, jmax, jmi, k, kk, kmax, kmin, &
   & last, maxd, mind, mlp1, ndiag, nlp1, npml, npnu
double precision :: sum
!-----------------------------------------------------------------------
!          Multiplication of double precision banded matrices
!-----------------------------------------------------------------------
ierr = 0
do j = 1,nc
   do i = 1,m
      c(i,j) = 0.d0
   end do
end do
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min(m - 1,ml + nl)
jc = 0
if (mcl == 0) go to 100
!     Find the first nonzero lower diagonal
maxd = mcl
do ndiag = 1,maxd
   imj = maxd + 1 - ndiag
   jmax = min(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.d0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,1) = sum
   end do
   do j = 1,jmax
      i = j + imj
      if (c(i,1) /= 0.d0) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
40 if (mcl >= nc) go to 100
jc = 1
if (mcl == 1) go to 100
!     Compute the remaining lower diagonals
mind = ndiag + 1
do ndiag = mind,maxd
   jc = jc + 1
   imj = maxd + 1 - ndiag
   jmax = min(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.d0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
end do
!     Find the last nonzero upper diagonal
100 jc = jc + 1
mcu = min(l - 1,mu + nu)
if (mcu == 0) go to 130
maxd = mcu
nswc_exit_1 : do ndiag = 1 , maxd
   jmi = maxd + 1 - ndiag
   imax = min(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.d0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
   do i = 1,imax
      if ( c ( i , jc ) /= 0.d0 ) exit nswc_exit_1
   end do
   mcu = mcu - 1
end do nswc_exit_1
130 last = mcl + mcu + 1
if (last > nc) go to 200
if (mcu == 0) go to 140
do i = 1,imax
   c(i,last) = c(i,jc)
   c(i,jc) = 0.d0
end do
!     Compute the main diagonal and the remaining upper diagonals
140 maxd = max(1,mcu)
do ndiag = 1,maxd
   jmi = ndiag - 1
   imax = min(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.d0
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
   jc = jc + 1
end do
return
!     Error return
200 ierr = last
end subroutine dbprod

pure subroutine cbprod(m, n, l, a, ka, ml, mu, b, kb, nl, nu, &
   & c, kc, nc, mcl, mcu, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nc, nl, nu
complex, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,nc)
integer :: i, imax, imj, j, jc, jj, jmax, jmi, k, kk, kmax, kmin, &
   & last, maxd, mind, mlp1, ndiag, nlp1, npml, npnu
complex :: sum
!-----------------------------------------------------------------------
!             Multiplication of complex banded matrices
!-----------------------------------------------------------------------
ierr = 0
do j = 1,nc
   do i = 1,m
      c(i,j) = (0.0,0.0)
   end do
end do
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min(m - 1,ml + nl)
jc = 0
if (mcl == 0) go to 100
!     Find the first nonzero lower diagonal
maxd = mcl
do ndiag = 1,maxd
   imj = maxd + 1 - ndiag
   jmax = min(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = (0.0,0.0)
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,1) = sum
   end do
   do j = 1,jmax
      i = j + imj
      if (c(i,1) /= (0.0,0.0)) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
40 if (mcl >= nc) go to 100
jc = 1
if (mcl == 1) go to 100
!     Compute the remaining lower diagonals
mind = ndiag + 1
do ndiag = mind,maxd
   jc = jc + 1
   imj = maxd + 1 - ndiag
   jmax = min(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = (0.0,0.0)
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
end do
!     Find the last nonzero upper diagonal
100 jc = jc + 1
mcu = min(l - 1,mu + nu)
if (mcu == 0) go to 130
maxd = mcu
nswc_exit_1 : do ndiag = 1 , maxd
   jmi = maxd + 1 - ndiag
   imax = min(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = (0.0,0.0)
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
   do i = 1,imax
      if ( c ( i , jc ) /= ( 0.0 , 0.0 ) ) exit nswc_exit_1
   end do
   mcu = mcu - 1
end do nswc_exit_1
130 last = mcl + mcu + 1
if (last > nc) go to 200
if (mcu == 0) go to 140
do i = 1,imax
   c(i,last) = c(i,jc)
   c(i,jc) = (0.0,0.0)
end do
!     Compute the main diagonal and the remaining upper diagonals
140 maxd = max(1,mcu)
do ndiag = 1,maxd
   jmi = ndiag - 1
   imax = min(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = (0.0,0.0)
      kmin = max(1,i - ml,j - nu)
      kmax = min(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
   jc = jc + 1
end do
return
!     Error return
200 ierr = last
end subroutine cbprod

pure subroutine bvprd(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
real, intent(in) :: a(ka,*), x(n)
real, intent(inout) :: y(m)
integer :: i, imax, imin, jmin, k, kk, kmax, kmin, mlp1
real :: sum
!-----------------------------------------------------------------------
!         Product of a real banded matrix and a real vector
!-----------------------------------------------------------------------
!     Compute the first ml components
mlp1 = ml + 1
if (ml == 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min(n,i + mu)
   kk = jmin
   sum = 0.0
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!     Compute the remaining nonzero components
20 imax = min(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min(n,i + mu)
   kk = 1
   sum = 0.0
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
!     Store zeros in the final m-imax components
if (imax == m) return
imin = imax + 1
do i = imin,m
   y(i) = 0.0
end do
end subroutine bvprd

pure subroutine bvprd1(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
real, intent(in) :: a(ka,*), x(n)
real, intent(inout) :: y(m)
integer :: i, imax, jmin, k, kk, kmax, kmin, mlp1
real :: sum
!-----------------------------------------------------------------------
!        Setting y = a*x + y where A is a real banded matrix
!                     and x,y are real vectors
!-----------------------------------------------------------------------
!     Compute the first ml components
mlp1 = ml + 1
if (ml == 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min(n,i + mu)
   kk = jmin
   sum = y(i)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!     Compute the remaining components
20 imax = min(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min(n,i + mu)
   kk = 1
   sum = y(i)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
end subroutine bvprd1

pure subroutine dbvpd(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
double precision, intent(in) :: a(ka,*), x(n)
double precision, intent(inout) :: y(m)
integer :: i, imax, imin, jmin, k, kk, kmax, kmin, mlp1
double precision :: sum
!-----------------------------------------------------------------------
!           Product of a double precision banded matrix
!                  and a double precision vector
!-----------------------------------------------------------------------
!     Compute the first ml components
mlp1 = ml + 1
if (ml == 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min(n,i + mu)
   kk = jmin
   sum = 0.d0
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!     Compute the remaining nonzero components
20 imax = min(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min(n,i + mu)
   kk = 1
   sum = 0.d0
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
!     Store zeros in the final m-imax components
if (imax == m) return
imin = imax + 1
do i = imin,m
   y(i) = 0.d0
end do
end subroutine dbvpd

pure subroutine dbvpd1(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
double precision, intent(in) :: a(ka,*), x(n)
double precision, intent(inout) :: y(m)
integer :: i, imax, jmin, k, kk, kmax, kmin, mlp1
double precision :: sum
!-----------------------------------------------------------------------
!         SETTING y = a*x + y WHERE A IS A DOUBLE PRECISION
!         banded matrix and x,y are double precision vectors
!-----------------------------------------------------------------------
!     Compute the first ml components
mlp1 = ml + 1
if (ml == 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min(n,i + mu)
   kk = jmin
   sum = y(i)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!     Compute the remaining components
20 imax = min(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min(n,i + mu)
   kk = 1
   sum = y(i)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
end subroutine dbvpd1

pure subroutine cbvpd(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
complex, intent(in) :: a(ka,*), x(n)
complex, intent(inout) :: y(m)
integer :: i, imax, imin, jmin, k, kk, kmax, kmin, mlp1
complex :: sum
!-----------------------------------------------------------------------
!        Product of a complex banded matrix and a complex vector
!-----------------------------------------------------------------------
!     Compute the first ml components
mlp1 = ml + 1
if (ml == 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min(n,i + mu)
   kk = jmin
   sum = (0.0,0.0)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!     Compute the remaining nonzero components
20 imax = min(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min(n,i + mu)
   kk = 1
   sum = (0.0,0.0)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
!     Store zeros in the final m-imax components
if (imax == m) return
imin = imax + 1
do i = imin,m
   y(i) = (0.0,0.0)
end do
end subroutine cbvpd

pure subroutine cbvpd1(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
complex, intent(in) :: a(ka,*), x(n)
complex, intent(inout) :: y(m)
integer :: i, imax, jmin, k, kk, kmax, kmin, mlp1
complex :: sum
!-----------------------------------------------------------------------
!        Setting y = a*x + y where A is a complex banded matrix
!                     and x,y are complex vectors
!-----------------------------------------------------------------------
!     Compute the first ml components
mlp1 = ml + 1
if (ml == 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min(n,i + mu)
   kk = jmin
   sum = y(i)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!     Compute the remaining components
20 imax = min(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min(n,i + mu)
   kk = 1
   sum = y(i)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
end subroutine cbvpd1

pure subroutine btprd(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
real, intent(in) :: a(ka,*), x(m)
real, intent(inout) :: y(n)
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
real :: sum
!-----------------------------------------------------------------------
!         Product of a real vector and a real banded matrix
!-----------------------------------------------------------------------
!     Compute the first mu components
if (mu == 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min(m,jj)
   sum = 0.0
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Compute the remaining nonzero components
20 num = ml + mu + 1
jmin = mu + 1
jmax = min(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min(m,j + ml)
   jj = num
   sum = 0.0
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Store zeros in the final n-jmax components
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = 0.0
end do
end subroutine btprd

pure subroutine btprd1(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
real, intent(in) :: a(ka,*), x(m)
real, intent(inout) :: y(n)
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
real :: sum
!-----------------------------------------------------------------------
!        Setting y = x*a + y where A is a real banded matrix
!                     and x,y are real vectors
!-----------------------------------------------------------------------
!     Compute the first mu components
if (mu == 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min(m,jj)
   sum = y(j)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Compute the remaining components
20 num = ml + mu + 1
jmin = mu + 1
jmax = min(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min(m,j + ml)
   jj = num
   sum = y(j)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
end subroutine btprd1

pure subroutine dbtpd(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
double precision, intent(in) :: a(ka,*), x(m)
double precision, intent(inout) :: y(n)
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
double precision :: sum
!-----------------------------------------------------------------------
!              Product of a double precision vector and
!                  a double precision banded matrix
!-----------------------------------------------------------------------
!     Compute the first mu components
if (mu == 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min(m,jj)
   sum = 0.d0
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Compute the remaining nonzero components
20 num = ml + mu + 1
jmin = mu + 1
jmax = min(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min(m,j + ml)
   jj = num
   sum = 0.d0
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Store zeros in the final n-jmax components
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = 0.d0
end do
end subroutine dbtpd

pure subroutine dbtpd1(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
double precision, intent(in) :: a(ka,*), x(m)
double precision, intent(inout) :: y(n)
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
double precision :: sum
!-----------------------------------------------------------------------
!         SETTING y = x*a + y WHERE A IS A DOUBLE PRECISION
!         banded matrix and x,y are double precision vectors
!-----------------------------------------------------------------------
!     Compute the first mu components
if (mu == 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min(m,jj)
   sum = y(j)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Compute the remaining components
20 num = ml + mu + 1
jmin = mu + 1
jmax = min(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min(m,j + ml)
   jj = num
   sum = y(j)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
end subroutine dbtpd1

pure subroutine cbtpd(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
complex, intent(in) :: a(ka,*), x(m)
complex, intent(inout) :: y(n)
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
complex :: sum
!-----------------------------------------------------------------------
!        Product of a complex vector and a complex banded matrix
!-----------------------------------------------------------------------
!     Compute the first mu components
if (mu == 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min(m,jj)
   sum = (0.0,0.0)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Compute the remaining nonzero components
20 num = ml + mu + 1
jmin = mu + 1
jmax = min(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min(m,j + ml)
   jj = num
   sum = (0.0,0.0)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Store zeros in the final n-jmax components
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = (0.0,0.0)
end do
end subroutine cbtpd

pure subroutine cbtpd1(m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
complex, intent(in) :: a(ka,*), x(m)
complex, intent(inout) :: y(n)
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
complex :: sum
!-----------------------------------------------------------------------
!        Setting y = x*a + y where A is a complex banded matrix
!                     and x,y are complex vectors
!-----------------------------------------------------------------------
!     Compute the first mu components
if (mu == 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min(m,jj)
   sum = y(j)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!     Compute the remaining components
20 num = ml + mu + 1
jmin = mu + 1
jmax = min(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min(m,j + ml)
   jj = num
   sum = y(j)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
end subroutine cbtpd1

pure real function bnrm(a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
real, intent(in) :: a(ka,*)
integer :: i, j, num
real :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                      real banded matrix a
!-----------------------------------------------------------------------
num = ml + mu + 1
bnrm = 0.0
do i = 1,m
   sum = 0.0
   do j = 1,num
      sum = sum + abs(a(i,j))
   end do
   bnrm = max(bnrm, sum)
end do
end function bnrm

pure real function b1nrm(a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
real, intent(in) :: a(*)
integer :: i, imax, imin, incr, j, jmax, jmin, num
interface
   pure function sasum(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: sasum
   end function sasum
end interface
!-----------------------------------------------------------------------
!            Computation of the L1 norm of a banded matrix a
!-----------------------------------------------------------------------
incr = ka - 1
b1nrm = 0.0
!     Go down the first column of A
imin = ml + 1
imax = min(m, imin + mu)
do i = imin,imax
   b1nrm = max(b1nrm, sasum(i,a(i),incr))
end do
i = imax
j = i - ml
num = i
if (j == n) return
if (i == m) go to 30
imin = i + 1
imax = min(m, ml + n)
do i = imin,imax
   b1nrm = max(b1nrm, sasum(num,a(i),incr))
end do
i = imax
j = i - ml
go to 50
!     Proceed along the last row of A
30 jmax = mu + 1
if (j == jmax) go to 50
jmin = j + 1
do j = jmin,jmax
   i = i + ka
   b1nrm = max(b1nrm, sasum(num,a(i),incr))
end do
j = jmax
50 if (j == n .or. num == 1) return
i = i + ka
j = j + 1
num = num - 1
b1nrm = max(b1nrm, sasum(num,a(i),incr))
go to 50
end function b1nrm

pure double precision function dbnrm(a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
double precision, intent(in) :: a(ka,*)
integer :: i, j, num
double precision :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                double precision banded matrix a
!-----------------------------------------------------------------------
num = ml + mu + 1
dbnrm = 0.d0
do i = 1,m
   sum = 0.d0
   do j = 1,num
      sum = sum + abs(a(i,j))
   end do
   dbnrm = max(dbnrm, sum)
end do
end function dbnrm

pure double precision function db1nrm(a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
double precision, intent(in) :: a(*)
integer :: i, imax, imin, incr, j, jmax, jmin, num
interface
   pure function dasum(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dasum
   end function dasum
end interface
!-----------------------------------------------------------------------
!            Computation of the L1 norm of a double precision
!                            banded matrix a
!-----------------------------------------------------------------------
incr = ka - 1
db1nrm = 0.d0
!     Go down the first column of A
imin = ml + 1
imax = min(m, imin + mu)
do i = imin,imax
   db1nrm = max(db1nrm, dasum(i,a(i),incr))
end do
i = imax
j = i - ml
num = i
if (j == n) return
if (i == m) go to 30
imin = i + 1
imax = min(m, ml + n)
do i = imin,imax
   db1nrm = max(db1nrm, dasum(num,a(i),incr))
end do
i = imax
j = i - ml
go to 50
!     Proceed along the last row of A
30 jmax = mu + 1
if (j == jmax) go to 50
jmin = j + 1
do j = jmin,jmax
   i = i + ka
   db1nrm = max(db1nrm, dasum(num,a(i),incr))
end do
j = jmax
50 if (j == n .or. num == 1) return
i = i + ka
j = j + 1
num = num - 1
db1nrm = max(db1nrm, dasum(num,a(i),incr))
go to 50
end function db1nrm

pure subroutine bslv(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
real, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
interface
   pure subroutine snbfa(a,lda,n,ml,mu,ipvt,info)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      real, intent(inout) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(inout) :: ipvt(n)
      integer, intent(out) :: info
   end subroutine snbfa
   pure subroutine snbsl(a,lda,n,ml,mu,ipvt,b,job)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      real, intent(in) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(in) :: ipvt(n)
      real, intent(inout) :: b(n)
      integer, intent(in) :: job
   end subroutine snbsl
end interface
! ----------------------------------------------------------------------
!     bslv employs Gauss elimination with row interchanges to solve
!     the NXN banded linear system AX = b. the argument m0 specifies
!     if bslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) an LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     On subsequent calls (when m0.NE.0) the equations are solved
!     using the decomposition obtained on the initial call to bslv.
!     Input arguments when m0=0 ---
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!     Output arguments when m0=0 ---
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!     b         THE SOLUTION OF THE EQUATIONS.
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of AX = b is obtained.
!               OTHERWISE ierr.NE.0.
!     After an initial call to bslv, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. bslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     bslv and solves the new equations AX = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!     Error checking
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!     Obtain an LU decomposition of A
call snbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!     Solve the system of equations
10 call snbsl(a,ka,n,ml,mu,iwk,b,0)
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine bslv

pure subroutine bslv1(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
real, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
interface
   pure subroutine snbfa(a,lda,n,ml,mu,ipvt,info)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      real, intent(inout) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(inout) :: ipvt(n)
      integer, intent(out) :: info
   end subroutine snbfa
   pure subroutine snbsl(a,lda,n,ml,mu,ipvt,b,job)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      real, intent(in) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(in) :: ipvt(n)
      real, intent(inout) :: b(n)
      integer, intent(in) :: job
   end subroutine snbsl
end interface
! ----------------------------------------------------------------------
!     bslv1 employs Gauss elimination with row interchanges to solve
!     the NXN banded linear system XA = b. the argument m0 specifies
!     if bslv1 is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) an LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     On subsequent calls (when m0.NE.0) the equations are solved
!     using the decomposition obtained on the initial call to bslv1.
!     Input arguments when m0=0 ---
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!     Output arguments when m0=0 ---
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!     b         THE SOLUTION OF THE EQUATIONS.
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of XA = b is obtained.
!               OTHERWISE ierr.NE.0.
!     After an initial call to bslv1, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. bslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     bslv1 and solves the new equations XA = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!     Error checking
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!     Obtain an LU decomposition of A
call snbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!     Solve the system of equations
10 call snbsl(a,ka,n,ml,mu,iwk,b,1)
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine bslv1

pure subroutine snbfa(a, lda, n, ml, mu, ipvt, info)
implicit none
integer, intent(in) :: lda, n, ml, mu
integer, intent(out) :: info
real, intent(inout) :: a(lda,*)
integer, intent(inout) :: ipvt(n)
integer :: i, j, j1, jj, k, l, ldb, ll, lm, lm1, lm2, lmk, m, mb, &
   & ml1, mp, n1
real :: t
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
   pure subroutine sswap(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine sswap
end interface
! ----------------------------------------------------------------------
!               snbfa factors a real band matrix BY elimination.
!                               --------
!     On entry
!        A       real(lda, NC)
!                contains the matrix in band storage. The rows
!                of the original matrix are stored in the rows
!                of A and the diagonals of the original matrix
!                are stored in columns 1 through ml+mu+1 of A.
!                NC MUST BE .GE. 2*ml+mu+1 .
!                See the comments below for details.
!        lda     INTEGER
!                the leading dimension of the array a. it is
!                assumed that lda .GE. n.
!        n       INTEGER
!                the order of the original matrix.
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!                0 .LE. ml .LT. n .
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!                0 .LE. mu .LT. n .
!                More efficient if ml .LE. mu .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                =0  Normal value
!                =k  if  U(k,k) .EQ. 0. this is not an error
!                condition for this subroutine, but it does
!                indicate that snbsl will divide by zero if
!                it is called.
!     Band storage
!           if A0 is the matrix THEN the following code will store
!           A0 in band form.
!                   ml = (band width below the diagonal)
!                   mu = (band width above the diagonal)
!                   do 20 i = 1, n
!                      j1 = max0(1, i-ml)
!                      j2 = min0(n, i+mu)
!                      do 10 j = j1, j2
!                         k = j - i + ml + 1
!                         a(i,k) = a0(i,j)
!                10    continue
!                20 continue
!           this uses columns 1 through  ml + mu + 1  of A.
!           Furthermore, ml additional columns are needed in
!           A (starting with column  ml+mu+2) for elements
!           generated during the triangularization. The total
!           number of columns needed in A is  2*ml+mu+1 .
!     Example..  if the original matrix is
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!      Then  n = 6, ml = 1, mu = 2, lda .GE. 6  and A should contain
!              11 12 13  +     , + = Used for pivoting
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!     Written by E.A.Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H.Morris, naval surface weapons center.
!     Subroutines and functions
!        MIN0,isamax,saxpy,sscal,sswap
! ----------------------------------------------------------------------
info = 0
if (ml == 0) go to 100
m = ml + mu + 1
!     Set fill-in columns to zero
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = 0.0
   end do
end do
!     Gaussian elimination with partial pivoting
ml1 = ml + 1
mb = ml + mu
n1 = n - 1
ldb = lda - 1
do k = 1,n1
   lm = min(n - k,ml)
   lmk = lm + k
   lm1 = lm + 1
   lm2 = ml1 - lm
!     Search for pivot index
   l = -isamax(lm1, a(lmk,lm2), ldb) + lm1 + k
   ipvt(k) = l
   mp = min(mb,n - k)
!     Swap rows if necessary
   ll = ml1 + k - l
   if (l /= k) call sswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!     Skip column reduction if pivot is zero
   if (a(k,ml1) /= 0.0) go to 20
   info = k
   go to 40
!     Compute multipliers
20 t = -1.0/a(k,ml1)
   call sscal(lm, t, a(lmk,lm2), ldb)
!     Row elimination with column indexing
   do j = 1,mp
      jj = ml1 + j
      j1 = lm2 + j
      call saxpy(lm, a(k,jj), a(lmk,lm2), ldb, a(lmk,j1), ldb)
   end do
40 continue
end do
ipvt(n) = n
if (a(n,ml1) == 0.0) info = n
return
!     Case when ml = 0
100 do k = 1,n
   ipvt(k) = k
   if (a(k,1) == 0.0) info = k
end do
end subroutine snbfa

pure subroutine snbsl(a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, job
real, intent(in) :: a(lda,*)
real, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
integer :: ml1, ml2, k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
real :: t
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
! ----------------------------------------------------------------------
!     snbsl solves the real band system a*X = b or trans(a)*X = b
!     using the factors computed by snbfa.
!                         ----------
!     On entry
!        A       real(lda, NC)
!                the output from snbfa.
!                NC MUST BE .GE. 2*ml+mu+1 .
!        lda     INTEGER
!                the leading dimension of the array a.
!        n       INTEGER
!                the order of the original matrix.
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!        ipvt    INTEGER(n)
!                the pivot vector from snbfa.
!        b       real(n)
!                the right hand side vector.
!        JOB     INTEGER
!                = 0         To solve  a*X = b .
!                = Nonzero   to solve  trans(a)*X = b , where
!                            trans(a)  is the transpose.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda.  It will not occur if snbfa and snbsl are
!        called correctly and snbfa has set info = 0.
!     Written by E.A. Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H. Morris, naval surface weapons center.
!     Subroutines and functions
!      saxpy,sdot
!     Fortran  MIN0
! ----------------------------------------------------------------------
m = mu + ml + 1
if (m == 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job /= 0) go to 50
!     job = 0 , SOLVE  a * X = b
!       first solve l*Y = b
if (ml == 0) go to 30
do k = 1,nm1
   lm = min(ml,n - k)
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call saxpy(lm, t, a(klm,mlm), ldb, b(k + 1), 1)
end do
!       Now solve  U*X = Y
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min(k,m) - 1
   lb = k - lm
   t = -b(k)
   call saxpy(lm, t, a(k - 1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       first solve  trans(U)*Y = b
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min(k,m) - 1
   lb = k - lm
   t = sdot(lm, a(k - 1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml == 0) return
!       Now solve trans(l)*X = Y
do kb = 1,nm1
   k = n - kb
   lm = min(ml,n - k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + sdot(lm, a(klm,mlm), ldb, b(k + 1), 1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
return
!     Case when ml = 0 And mu = 0
100 do k = 1,n
   b(k) = b(k)/a(k,1)
end do
end subroutine snbsl

pure subroutine dbslv(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
double precision, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
interface
   pure subroutine dbfa(a,lda,n,ml,mu,ipvt,info)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      double precision, intent(inout) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(inout) :: ipvt(n)
      integer, intent(out) :: info
   end subroutine dbfa
   pure subroutine dbsl(a,lda,n,ml,mu,ipvt,b,job)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      double precision, intent(in) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(in) :: ipvt(n)
      double precision, intent(inout) :: b(n)
      integer, intent(in) :: job
   end subroutine dbsl
end interface
! ----------------------------------------------------------------------
!     dbslv employs Gauss elimination with row interchanges to solve
!     the NXN banded linear system AX = b. the argument m0 specifies
!     if dbslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) an LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     On subsequent calls (when m0.NE.0) the equations are solved
!     using the decomposition obtained on the initial call to dbslv.
!     Input arguments when m0=0 ---
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!     Output arguments when m0=0 ---
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!     b         THE SOLUTION OF THE EQUATIONS.
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of AX = b is obtained.
!               OTHERWISE ierr.NE.0.
!     After an initial call to dbslv, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. dbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     dbslv and solves the new equations AX = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!     Error checking
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!     Obtain an LU decomposition of A
call dbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!     Solve the system of equations
10 call dbsl(a,ka,n,ml,mu,iwk,b,0)
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine dbslv

pure subroutine dbslv1(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
double precision, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
interface
   pure subroutine dbfa(a,lda,n,ml,mu,ipvt,info)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      double precision, intent(inout) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(inout) :: ipvt(n)
      integer, intent(out) :: info
   end subroutine dbfa
   pure subroutine dbsl(a,lda,n,ml,mu,ipvt,b,job)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: lda
      double precision, intent(in) :: a(lda,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      integer, intent(in) :: ipvt(n)
      double precision, intent(inout) :: b(n)
      integer, intent(in) :: job
   end subroutine dbsl
end interface
! ----------------------------------------------------------------------
!     dbslv1 employs Gauss elimination with row interchanges to solve
!     the NXN banded linear system XA = b. the argument m0 specifies
!     if dbslv1 is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) an LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     On subsequent calls (when m0.NE.0) the equations are solved
!     using the decomposition obtained on the initial call to dbslv1.
!     Input arguments when m0=0 ---
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!     Output arguments when m0=0 ---
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!     b         THE SOLUTION OF THE EQUATIONS.
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of XA = b is obtained.
!               OTHERWISE ierr.NE.0.
!     After an initial call to dbslv1, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. dbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     dbslv1 and solves the new equations XA = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!     Error checking
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!     Obtain an LU decomposition of A
call dbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!     Solve the system of equations
10 call dbsl(a,ka,n,ml,mu,iwk,b,1)
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine dbslv1

pure subroutine dbfa(a, lda, n, ml, mu, ipvt, info)
implicit none
integer, intent(in) :: lda, n, ml, mu
integer, intent(out) :: info
double precision, intent(inout) :: a(lda,*)
integer, intent(inout) :: ipvt(n)
integer :: i, j, j1, jj, k, l, ldb, ll, lm, lm1, lm2, lmk, m, mb, &
   & ml1, mp, n1
double precision :: t
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure subroutine dscal(n,da,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
   end subroutine dscal
   pure subroutine dswap(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dswap
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
end interface
! ----------------------------------------------------------------------
!               dbfa factors a real band matrix BY elimination.
!                               --------
!     On entry
!        A       DOUBLE PRECISION(lda, NC)
!                contains the matrix in band storage. The rows
!                of the original matrix are stored in the rows
!                of A and the diagonals of the original matrix
!                are stored in columns 1 through ml+mu+1 of A.
!                NC MUST BE .GE. 2*ml+mu+1 .
!                See the comments below for details.
!        lda     INTEGER
!                the leading dimension of the array a. it is
!                assumed that lda .GE. n.
!        n       INTEGER
!                the order of the original matrix.
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!                0 .LE. ml .LT. n .
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!                0 .LE. mu .LT. n .
!                More efficient if ml .LE. mu .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                =0  Normal value
!                =k  if  U(k,k) .EQ. 0. this is not an error
!                condition for this subroutine, but it does
!                indicate that dbsl will divide by zero if
!                it is called.
!     Band storage
!           if A0 is the matrix THEN the following code will store
!           A0 in band form.
!                   ml = (band width below the diagonal)
!                   mu = (band width above the diagonal)
!                   do 20 i = 1, n
!                      j1 = max0(1, i-ml)
!                      j2 = min0(n, i+mu)
!                      do 10 j = j1, j2
!                         k = j - i + ml + 1
!                         a(i,k) = a0(i,j)
!                10    continue
!                20 continue
!           this uses columns 1 through  ml + mu + 1  of A.
!           Furthermore, ml additional columns are needed in
!           A (starting with column  ml+mu+2) for elements
!           generated during the triangularization. The total
!           number of columns needed in A is  2*ml+mu+1 .
!     Example..  if the original matrix is
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!      Then  n = 6, ml = 1, mu = 2, lda .GE. 6  and A should contain
!              11 12 13  +     , + = Used for pivoting
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!     Written by E.A.Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H.Morris, naval surface weapons center.
!     Subroutines and functions
!        MIN0,idamax,daxpy,dscal,dswap
! ----------------------------------------------------------------------
info = 0
if (ml == 0) go to 100
m = ml + mu + 1
!     Set fill-in columns to zero
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = 0.d0
   end do
end do
!     Gaussian elimination with partial pivoting
ml1 = ml + 1
mb = ml + mu
n1 = n - 1
ldb = lda - 1
do k = 1,n1
   lm = min(n - k,ml)
   lmk = lm + k
   lm1 = lm + 1
   lm2 = ml1 - lm
!     Search for pivot index
   l = -idamax(lm1, a(lmk,lm2), ldb) + lm1 + k
   ipvt(k) = l
   mp = min(mb,n - k)
!     Swap rows if necessary
   ll = ml1 + k - l
   if (l /= k) call dswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!     Skip column reduction if pivot is zero
   if (a(k,ml1) /= 0.d0) go to 20
   info = k
   go to 40
!     Compute multipliers
20 t = -1.d0/a(k,ml1)
   call dscal(lm, t, a(lmk,lm2), ldb)
!     Row elimination with column indexing
   do j = 1,mp
      jj = ml1 + j
      j1 = lm2 + j
      call daxpy(lm, a(k,jj), a(lmk,lm2), ldb, a(lmk,j1), ldb)
   end do
40 continue
end do
ipvt(n) = n
if (a(n,ml1) == 0.d0) info = n
return
!     Case when ml = 0
100 do k = 1,n
   ipvt(k) = k
   if (a(k,1) == 0.d0) info = k
end do
end subroutine dbfa

pure subroutine dbsl(a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, job
double precision, intent(in) :: a(lda,*)
double precision, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
integer :: ml1, ml2, k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
double precision :: t
interface
   pure subroutine daxpy(n,da,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: da
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine daxpy
   pure function ddot(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(in) :: dy(*)
      integer, intent(in) :: incy
      double precision :: ddot
   end function ddot
end interface
! ----------------------------------------------------------------------
!     dbsl solves the real band system a*X = b or trans(a)*X = b
!     using the factors computed by dbfa.
!                         ----------
!     On entry
!        A       DOUBLE PRECISION(lda, NC)
!                the output from dbfa.
!                NC MUST BE .GE. 2*ml+mu+1 .
!        lda     INTEGER
!                the leading dimension of the array a.
!        n       INTEGER
!                the order of the original matrix.
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!        ipvt    INTEGER(n)
!                the pivot vector from dbfa.
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!        JOB     INTEGER
!                = 0         To solve  a*X = b .
!                = Nonzero   to solve  trans(a)*X = b , where
!                            trans(a)  is the transpose.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda.  It will not occur if dbfa and dbsl are
!        called correctly and dbfa has set info = 0.
!     Written by E.A. Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H. Morris, naval surface weapons center.
!     Subroutines and functions
!      daxpy,ddot
!     Fortran  MIN0
! ----------------------------------------------------------------------
m = mu + ml + 1
if (m == 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job /= 0) go to 50
!     job = 0 , SOLVE  a * X = b
!       first solve l*Y = b
if (ml == 0) go to 30
do k = 1,nm1
   lm = min(ml,n - k)
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call daxpy(lm, t, a(klm,mlm), ldb, b(k + 1), 1)
end do
!       Now solve  U*X = Y
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min(k,m) - 1
   lb = k - lm
   t = -b(k)
   call daxpy(lm, t, a(k - 1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       first solve  trans(U)*Y = b
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min(k,m) - 1
   lb = k - lm
   t = ddot(lm, a(k - 1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml == 0) return
!       Now solve trans(l)*X = Y
do kb = 1,nm1
   k = n - kb
   lm = min(ml,n - k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + ddot(lm, a(klm,mlm), ldb, b(k + 1), 1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
return
!     Case when ml = 0 And mu = 0
100 do k = 1,n
   b(k) = b(k)/a(k,1)
end do
end subroutine dbsl

pure subroutine b1cnd(a, ka, n, ml, mu, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, ml, mu, n
real, intent(out) :: cond
real, intent(inout) :: a(ka,*), wk(*)
integer, intent(inout) :: iwk(*)
integer :: isgn, iter, iv, ix, j, jump, kase
real :: ainorm, anorm
interface
   pure function b1nrm(a,ka,m,n,ml,mu)
      implicit none
      real, intent(in) :: a(*)
      integer, intent(in) :: ka
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      real :: b1nrm
   end function b1nrm
   pure subroutine bslv(m0,a,ka,n,ml,mu,b,iwk,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: ka
      integer, intent(in) :: m0
      real, intent(inout) :: a(ka,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      real, intent(inout) :: b(n)
      integer, intent(inout) :: iwk(n)
      integer, intent(inout) :: ierr
   end subroutine bslv
   pure subroutine bslv1(m0,a,ka,n,ml,mu,b,iwk,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: ka
      integer, intent(in) :: m0
      real, intent(inout) :: a(ka,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      real, intent(inout) :: b(n)
      integer, intent(inout) :: iwk(n)
      integer, intent(inout) :: ierr
   end subroutine bslv1
   pure subroutine sonest(n,v,x,isgn,anorm,kase,iter,j,jump)
      implicit none
      integer, intent(in) :: n
      real, intent(inout) :: v(n)
      real, intent(inout) :: x(n)
      integer, intent(inout) :: isgn(n)
      real, intent(inout) :: anorm
      integer, intent(inout) :: kase
      integer, intent(inout) :: iter
      integer, intent(inout) :: j
      integer, intent(inout) :: jump
   end subroutine sonest
end interface
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a banded matrix a
!-----------------------------------------------------------------------
!-----------------------
!     real wk(2*n)
!     integer iwk(2*n)
!-----------------------
cond = 0.0
if (n <= 0 .or. ka < n) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
anorm = b1nrm(a, ka, n, n, ml, mu)
if (anorm == 0.0) go to 40
ix = 1
iv = n + 1
isgn = n + 1
kase = 0
ainorm = 0.0
call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call bslv(0, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
!     Check if A is singular
if (ierr > 0) go to 40
!     General loop to estimate the norm  ainorm
!     of the inverse of A
10 call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 30
if (kase /= 1) go to 20
call bslv(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
20 call bslv1(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
!     Compute the value of cond
30 cond = anorm*ainorm
return
!     Singular case
40 ierr = 1
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine b1cnd

pure subroutine db1cnd(a, ka, n, ml, mu, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, ml, mu, n
double precision, intent(inout) :: a(ka,*)
double precision, intent(out) :: cond
double precision, intent(inout) :: wk(*)
integer, intent(inout) :: iwk(*)
integer :: isgn, iter, iv, ix, j, jump, kase
double precision :: anorm, ainorm
interface
   pure function db1nrm(a,ka,m,n,ml,mu)
      implicit none
      double precision, intent(in) :: a(*)
      integer, intent(in) :: ka
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      double precision :: db1nrm
   end function db1nrm
   pure subroutine dbslv(m0,a,ka,n,ml,mu,b,iwk,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: ka
      integer, intent(in) :: m0
      double precision, intent(inout) :: a(ka,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      double precision, intent(inout) :: b(n)
      integer, intent(inout) :: iwk(n)
      integer, intent(inout) :: ierr
   end subroutine dbslv
   pure subroutine dbslv1(m0,a,ka,n,ml,mu,b,iwk,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: ka
      integer, intent(in) :: m0
      double precision, intent(inout) :: a(ka,*)
      integer, intent(in) :: ml
      integer, intent(in) :: mu
      double precision, intent(inout) :: b(n)
      integer, intent(inout) :: iwk(n)
      integer, intent(inout) :: ierr
   end subroutine dbslv1
   pure subroutine donest(n,v,x,isgn,anorm,kase,iter,j,jump)
      implicit none
      integer, intent(in) :: n
      double precision, intent(inout) :: v(n)
      double precision, intent(inout) :: x(n)
      integer, intent(inout) :: isgn(n)
      double precision, intent(inout) :: anorm
      integer, intent(inout) :: kase
      integer, intent(inout) :: iter
      integer, intent(inout) :: j
      integer, intent(inout) :: jump
   end subroutine donest
end interface
!-----------------------------------------------------------------------
!            Computation of the L1 condition number of
!               a double precision banded matrix a
!-----------------------------------------------------------------------
!-----------------------
!     double precision wk(2*n)
!     integer iwk(2*n)
!-----------------------
cond = 0.d0
if (n <= 0 .or. ka < n) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
anorm = db1nrm(a, ka, n, n, ml, mu)
if (anorm == 0.d0) go to 40
ix = 1
iv = n + 1
isgn = n + 1
kase = 0
ainorm = 0.d0
call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call dbslv(0, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
!     Check if A is singular
if (ierr > 0) go to 40
!     General loop to estimate the norm  ainorm
!     of the inverse of A
10 call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 30
if (kase /= 1) go to 20
call dbslv(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
20 call dbslv1(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
!     Compute the value of cond
30 cond = anorm*ainorm
return
!     Singular case
40 ierr = 1
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine db1cnd

subroutine cbslv(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
complex, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
! ----------------------------------------------------------------------
!     cbslv employs Gauss elimination with row interchanges to solve
!     the NXN complex banded system AX = b. the argument m0 specifies
!     if cbslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) an LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     On subsequent calls (when m0.NE.0) the equations are solved
!     using the decomposition obtained on the initial call to cbslv.
!     Input arguments when m0=0 ---
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!               A is a complex array.
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!     b         COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT
!               hand side data.
!     Output arguments when m0=0 ---
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!     b         THE SOLUTION OF THE EQUATIONS.
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of AX = b is obtained.
!               OTHERWISE ierr.NE.0.
!     After an initial call to cbslv, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. cbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     cbslv and solves the new equations AX = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!     Error checking
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!     Obtain an LU decomposition of A
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!     Solve the system of equations
10 call cbsl(a,ka,n,ml,mu,iwk,b,0)
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine cbslv

subroutine cbslv1(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
complex, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
! ----------------------------------------------------------------------
!     cbslv1 employs Gauss elimination with row interchanges to solve
!     the NXN complex banded system XA = b. the argument m0 specifies
!     if cbslv1 is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) an LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     On subsequent calls (when m0.NE.0) the equations are solved
!     using the decomposition obtained on the initial call to cbslv1.
!     Input arguments when m0=0 ---
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!               A is a complex array.
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!     b         COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT
!               hand side data.
!     Output arguments when m0=0 ---
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!     b         THE SOLUTION OF THE EQUATIONS.
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of XA = b is obtained.
!               OTHERWISE ierr.NE.0.
!     After an initial call to cbslv1, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. cbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     cbslv1 and solves the new equations XA = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!     Error checking
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!     Obtain an LU decomposition of A
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!     Solve the system of equations
10 call cbsl(a,ka,n,ml,mu,iwk,b,1)
return
!     Error return
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
end subroutine cbslv1

subroutine cbfa(a, lda, n, ml, mu, ipvt, info)
implicit none
integer, intent(in) :: lda, n, ml, mu
integer, intent(out) :: info
complex, intent(inout) :: a(lda,*)
integer, intent(inout) :: ipvt(n)
integer :: i, j, j1, jj, k, l, ldb, ll, lm, lm1, lm2, lmk, m, mb, &
   & ml1, mp, n1
integer :: icamax
complex :: t
! ----------------------------------------------------------------------
!               cbfa factors a complex band matrix BY elimination.
!                              ----------
!     On entry
!        A       COMPLEX(lda, NC)
!                contains the matrix in band storage. The rows
!                of the original matrix are stored in the rows
!                of A and the diagonals of the original matrix
!                are stored in columns 1 through ml+mu+1 of A.
!                NC MUST BE .GE. 2*ml+mu+1 .
!                See the comments below for details.
!        lda     INTEGER
!                the leading dimension of the array a. it is
!                assumed that lda .GE. n.
!        n       INTEGER
!                the order of the original matrix.
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!                0 .LE. ml .LT. n .
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!                0 .LE. mu .LT. n .
!                More efficient if ml .LE. mu .
!     On return
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!        INFO    INTEGER
!                =0  Normal value
!                =k  if  U(k,k) .EQ. 0. this is not an error
!                condition for this subroutine, but it does
!                indicate that cbsl will divide by zero if
!                it is called.
!     Band storage
!           if A0 is the matrix THEN the following code will store
!           A0 in band form.
!                   ml = (band width below the diagonal)
!                   mu = (band width above the diagonal)
!                   do 20 i = 1, n
!                      j1 = max0(1, i-ml)
!                      j2 = min0(n, i+mu)
!                      do 10 j = j1, j2
!                         k = j - i + ml + 1
!                         a(i,k) = a0(i,j)
!                10    continue
!                20 continue
!           this uses columns 1 through  ml + mu + 1  of A.
!           Furthermore, ml additional columns are needed in
!           A (starting with column  ml+mu+2) for elements
!           generated during the triangularization. The total
!           number of columns needed in A is  2*ml+mu+1 .
!     Example..  if the original matrix is
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!      Then  n = 6, ml = 1, mu = 2, lda .GE. 6  and A should contain
!              11 12 13  +     , + = Used for pivoting
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!     Written by E.A.Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H.Morris, naval surface weapons center.
!     Subroutines and functions
!        MIN0,icamax,caxpy,cscal,cswap
! ----------------------------------------------------------------------
info = 0
if (ml == 0) go to 100
m = ml + mu + 1
!     Set fill-in columns to zero
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = (0.0,0.0)
   end do
end do
!     Gaussian elimination with partial pivoting
ml1 = ml + 1
mb = ml + mu
n1 = n - 1
ldb = lda - 1
do k = 1,n1
   lm = min(n - k,ml)
   lmk = lm + k
   lm1 = lm + 1
   lm2 = ml1 - lm
!     Search for pivot index
   l = -icamax(lm1, a(lmk,lm2), ldb) + lm1 + k
   ipvt(k) = l
   mp = min(mb,n - k)
!     Swap rows if necessary
   ll = ml1 + k - l
   if (l /= k) call cswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!     Skip column reduction if pivot is zero
   if (a(k,ml1) /= (0.0,0.0)) go to 20
   info = k
   go to 40
!     Compute multipliers
20 t = (-1.0,0.0)/a(k,ml1)
   call cscal(lm, t, a(lmk,lm2), ldb)
!     Row elimination with column indexing
   do j = 1,mp
      jj = ml1 + j
      j1 = lm2 + j
      call caxpy(lm, a(k,jj), a(lmk,lm2), ldb, a(lmk,j1), ldb)
   end do
40 continue
end do
ipvt(n) = n
if (a(n,ml1) == (0.0,0.0)) info = n
return
!     Case when ml = 0
100 do k = 1,n
   ipvt(k) = k
   if (a(k,1) == (0.0,0.0)) info = k
end do
end subroutine cbfa

pure subroutine cbsl(a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, job
complex, intent(in) :: a(lda,*)
complex, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
integer :: ml1, ml2, k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
complex :: t
interface
   pure subroutine caxpy(n,ca,cx,incx,cy,incy)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: ca
      complex, intent(in) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(inout) :: cy(*)
      integer, intent(in) :: incy
   end subroutine caxpy
   pure function cdotu(n,cx,incx,cy,incy)
      implicit none
      integer, intent(in) :: n
      complex, intent(in) :: cx(*)
      integer, intent(in) :: incx
      complex, intent(in) :: cy(*)
      integer, intent(in) :: incy
      complex :: cdotu
   end function cdotu
end interface
! ----------------------------------------------------------------------
!     cbsl solves the complex band system a*X = b or trans(a)*X = b
!     using the factors computed by cbfa.
!                         ----------
!     On entry
!        A       COMPLEX(lda, NC)
!                the output from cbfa.
!                NC MUST BE .GE. 2*ml+mu+1 .
!        lda     INTEGER
!                the leading dimension of the array a.
!        n       INTEGER
!                the order of the original matrix.
!        ml      INTEGER
!                number of diagonals below the main diagonal.
!        mu      INTEGER
!                number of diagonals above the main diagonal.
!        ipvt    INTEGER(n)
!                the pivot vector from cbfa.
!        b       COMPLEX(n)
!                the right hand side vector.
!        JOB     INTEGER
!                = 0         To solve  a*X = b .
!                = Nonzero   to solve  trans(a)*X = b , where
!                            trans(a)  is the transpose.
!     On return
!        b       THE SOLUTION VECTOR  X .
!     Error condition
!        a division by zero will occur if the input factor contains A
!        zero on the diagonal.  Technically this indicates singularity
!        but it is often caused by improper arguments or improper
!        setting of lda.  It will not occur if cbfa and cbsl are
!        called correctly and cbfa has set info = 0.
!     Written by E.A. Voorhees, Los Alamos scientific laboratory.
!     Adapted by A.H. Morris, naval surface weapons center.
!     Subroutines and functions
!      caxpy,cdotu
!     Fortran  MIN0
! ----------------------------------------------------------------------
m = mu + ml + 1
if (m == 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job /= 0) go to 50
!     job = 0 , SOLVE  a * X = b
!       first solve l*Y = b
if (ml == 0) go to 30
do k = 1,nm1
   lm = min(ml,n - k)
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call caxpy(lm, t, a(klm,mlm), ldb, b(k + 1), 1)
end do
!       Now solve  U*X = Y
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min(k,m) - 1
   lb = k - lm
   t = -b(k)
   call caxpy(lm, t, a(k - 1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       first solve  trans(U)*Y = b
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min(k,m) - 1
   lb = k - lm
   t = cdotu(lm, a(k - 1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml == 0) return
!       Now solve trans(l)*X = Y
do kb = 1, nm1
   k = n - kb
   lm = min(ml,n - k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + cdotu(lm, a(klm,mlm), ldb, b(k + 1), 1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
end do
return
!     Case when ml = 0 And mu = 0
100 do k = 1,n
   b(k) = b(k)/a(k,1)
end do
end subroutine cbsl

pure subroutine cvrs(a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, j
!                 Store the i-TH row
ip = 1
do i = 1,m
   ib(i) = ip
   do j = 1,n
      if (a(i,j) == 0.0) go to 10
      if (ip > num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10    continue
   end do
end do
!                 Complete the setup
ib(m + 1) = ip
ierr = 0
return
!                   Error return
20 ierr = i
end subroutine cvrs

pure subroutine cvds(a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, j
!                 Store the i-TH row
ip = 1
do i = 1,m
   ib(i) = ip
   do j = 1,n
      if (a(i,j) == 0.d0) go to 10
      if (ip > num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10    continue
   end do
end do
!                 Complete the setup
ib(m + 1) = ip
ierr = 0
return
!                   Error return
20 ierr = i
end subroutine cvds

pure subroutine cvcs(a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, j
complex, parameter :: zero = (0.0,0.0)
!                 Store the i-TH row
ip = 1
do i = 1,m
   ib(i) = ip
   do j = 1,n
      if (a(i,j) == zero) go to 10
      if (ip > num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10    continue
   end do
end do
!                 Complete the setup
ib(m + 1) = ip
ierr = 0
return
!                   Error return
20 ierr = i
end subroutine cvcs

subroutine cvsr(a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
real, intent(in) :: a(*)
real, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin, j
do i = 1,m
!                 Clear the i-TH row
   do j = 1,n
      b(i,j) = 0.0
   end do
!                 Store the i-TH row
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
30 continue
end do
end subroutine cvsr

subroutine cvsd(a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin, j
do i = 1,m
!                 Clear the i-TH row
   do j = 1,n
      b(i,j) = 0.d0
   end do
!                 Store the i-TH row
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
30 continue
end do
end subroutine cvsd

subroutine cvsc(a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
complex, intent(in) :: a(*)
complex, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin, j
do i = 1,m
!                 Clear the i-TH row
   do j = 1,n
      b(i,j) = (0.0,0.0)
   end do
!                 Store the i-TH row
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
30 continue
end do
end subroutine cvsc

subroutine scvrd(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
real, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
l = 1
do i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do ip = ibeg,iend
      if (a(ip) == 0.0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
   end do
20 continue
end do
ib(m + 1) = l
end subroutine scvrd

subroutine scvdr(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
double precision, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
l = 1
do i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do ip = ibeg,iend
      if (a(ip) == 0.d0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
   end do
20 continue
end do
ib(m + 1) = l
end subroutine scvdr

subroutine csreal(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
complex, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
real :: t
!-----------------------------------------------------------------------
!              Real part of a sparse complex matrix
!-----------------------------------------------------------------------
l = 1
do i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do ip = ibeg,iend
      t = real(a(ip))
      if (t == 0.0) go to 10
      b(l) = t
      jb(l) = ja(ip)
      l = l + 1
10    continue
   end do
20 continue
end do
ib(m + 1) = l
end subroutine csreal

subroutine csimag(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
complex, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
real :: t
!-----------------------------------------------------------------------
!            Imaginary part of a sparse complex matrix
!-----------------------------------------------------------------------
l = 1
do i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do ip = ibeg,iend
      t = aimag(a(ip))
      if (t == 0.0) go to 10
      b(l) = t
      jb(l) = ja(ip)
      l = l + 1
10    continue
   end do
20 continue
end do
ib(m + 1) = l
end subroutine csimag

subroutine scvrc(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
real, intent(in) :: a(*), b(*)
real, intent(inout) :: wk(n)
complex, intent(inout) :: c(*)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, l, maxa, maxb, mina, minb
complex :: t
!-----------------------------------------------------------------------
!       Compute a + bi for the sparse real matrices A and b
!-----------------------------------------------------------------------
!-------------------------
do j = 1,n
   wk(j) = 0.0
end do
!                  Compute the i-TH row of c
ip = 1
do i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do l = minb,maxb
      if (b(l) == 0.0) go to 31
      j = jb(l)
      t = cmplx (wk(j), b(l))
      wk(j) = 0.0
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
   end do
40 if (mina > maxa) go to 42
   do l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.0) go to 41
      if (ip > num) go to 50
      c(ip) = cmplx (wk(j), 0.0)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41    continue
   end do
42 continue
end do
ic(m + 1) = ip
ierr = 0
return
!                        Error return
50 ierr = i
end subroutine scvrc

subroutine rscopy(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
!-----------------------------------------------------------------------
!                  Copying a sparse real matrix
!-----------------------------------------------------------------------
l = 1
do i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do ip = ibeg,iend
      if (a(ip) == 0.0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
   end do
20 continue
end do
ib(m + 1) = l
end subroutine rscopy

subroutine dscopy(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
!-----------------------------------------------------------------------
!              Copying a sparse double precision matrix
!-----------------------------------------------------------------------
l = 1
do i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do ip = ibeg,iend
      if (a(ip) == 0.d0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
   end do
20 continue
end do
ib(m + 1) = l
end subroutine dscopy

subroutine cscopy(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
complex, parameter :: zero = (0.0,0.0)
!-----------------------------------------------------------------------
!                 Copying a sparse complex matrix
!-----------------------------------------------------------------------
l = 1
do i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do ip = ibeg,iend
      if (a(ip) == zero) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
   end do
20 continue
end do
ib(m + 1) = l
end subroutine cscopy

subroutine sconj(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l, mp1
!-----------------------------------------------------------------------
!     Computation of the conjugate of a sparse complex matrix
!-----------------------------------------------------------------------
mp1 = m + 1
l = ia(1) - 1
do i = 1,mp1
   ib(i) = ia(i) - l
end do
ibeg = ia(1)
iend = ia(mp1) - 1
if (ibeg > iend) return
l = 1
do ip = ibeg,iend
   b(l) = conjg(a(ip))
   jb(l) = ja(ip)
   l = l + 1
end do
end subroutine sconj

subroutine rpose(a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!                 Transposing a sparse real matrix
!-----------------------------------------------------------------------
!           Compute the number of elements in each column
!                 of A and store the results in ib
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
do i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j + 1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j + 1) = jp + 1
   end do
31 continue
end do
ib(1) = 1
return
!                    Transpose a zero matrix a
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
end subroutine rpose

subroutine rpose1(p, a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: p(m)
real, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ii, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!                 Transposing a sparse real matrix
!                 where the rows are interchanged
!-----------------------------------------------------------------------
!           Compute the number of elements in each column
!                 of A and store the results in ib
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
do i = 1,m
   ii = p(i)
   ipmin = ia(ii)
   ipmax = ia(ii + 1) - 1
   if (ipmin > ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j + 1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j + 1) = jp + 1
   end do
31 continue
end do
ib(1) = 1
return
!                    Transpose a zero matrix a
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
end subroutine rpose1

subroutine dpose(a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!           Transposing a sparse double precision matrix
!-----------------------------------------------------------------------
!           Compute the number of elements in each column
!                 of A and store the results in ib
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
do i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j + 1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j + 1) = jp + 1
   end do
31 continue
end do
ib(1) = 1
return
!                    Transpose a zero matrix a
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
end subroutine dpose

subroutine dpose1(p, a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: p(m)
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ii, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!           Transposing a sparse double precision matrix
!                 where the rows are interchanged
!-----------------------------------------------------------------------
!           Compute the number of elements in each column
!                 of A and store the results in ib
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
do i = 1,m
   ii = p(i)
   ipmin = ia(ii)
   ipmax = ia(ii + 1) - 1
   if (ipmin > ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j + 1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j + 1) = jp + 1
   end do
31 continue
end do
ib(1) = 1
return
!                    Transpose a zero matrix a
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
end subroutine dpose1

subroutine cpose(a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!               Transposing a sparse complex matrix
!-----------------------------------------------------------------------
!           Compute the number of elements in each column
!                 of A and store the results in ib
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
do i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j + 1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j + 1) = jp + 1
   end do
31 continue
end do
ib(1) = 1
return
!                    Transpose a zero matrix a
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
end subroutine cpose

subroutine cpose1(p, a, ia, ja, b, ib, jb, m, n)
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: p(m)
complex, intent(in) :: a(*)
complex, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ii, ip, ipmax, ipmin, j, jj, jp, np1, num
!-----------------------------------------------------------------------
!               Transposing a sparse complex matrix
!                 where the rows are interchanged
!-----------------------------------------------------------------------
!           Compute the number of elements in each column
!                 of A and store the results in ib
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) go to 40
do j = 1,n
   ib(j) = 0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   ib(j) = ib(j) + 1
end do
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
do i = 1,m
   ii = p(i)
   ipmin = ia(ii)
   ipmax = ia(ii + 1) - 1
   if (ipmin > ipmax) go to 31
   do ip = ipmin,ipmax
      j = ja(ip)
      jp = ib(j + 1)
      jb(jp) = i
      b(jp) = a(ip)
      ib(j + 1) = jp + 1
   end do
31 continue
end do
ib(1) = 1
return
!                    Transpose a zero matrix a
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
end subroutine cpose1

subroutine sadd(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, l, maxa, maxb, mina, minb
real :: t
!-----------------------------------------------------------------------
!               Addition of sparse real matrices
!-----------------------------------------------------------------------
!-------------------------
do j = 1,n
   wk(j) = 0.0
end do
!                  Compute the i-TH row of c
ip = 1
do i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = 0.0
      if (t == 0.0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
   end do
40 if (mina > maxa) go to 42
   do l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41    continue
   end do
42 continue
end do
ic(m + 1) = ip
ierr = 0
return
!                        Error return
50 ierr = i
end subroutine sadd

subroutine dsadd(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, l, maxa, maxb, mina, minb
double precision :: t
!-----------------------------------------------------------------------
!         Addition of sparse double precision matrices
!-----------------------------------------------------------------------
!-------------------------
do j = 1,n
   wk(j) = 0.d0
end do
!                  Compute the i-TH row of c
ip = 1
do i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = 0.d0
      if (t == 0.d0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
   end do
40 if (mina > maxa) go to 42
   do l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.d0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.d0
      jc(ip) = j
      ip = ip + 1
41    continue
   end do
42 continue
end do
ic(m + 1) = ip
ierr = 0
return
!                        Error return
50 ierr = i
end subroutine dsadd

subroutine csadd(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
complex, intent(in) :: a(*), b(*)
complex, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, l, maxa, maxb, mina, minb
complex :: t
!-----------------------------------------------------------------------
!              Addition of sparse complex matrices
!-----------------------------------------------------------------------
!-------------------------
do j = 1,n
   wk(j) = (0.0, 0.0)
end do
!                  Compute the i-TH row of c
ip = 1
do i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = (0.0, 0.0)
      if (t == (0.0, 0.0)) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
   end do
40 if (mina > maxa) go to 42
   do l = mina,maxa
      j = ja(l)
      if (wk(j) == (0.0, 0.0)) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = (0.0, 0.0)
      jc(ip) = j
      ip = ip + 1
41    continue
   end do
42 continue
end do
ic(m + 1) = ip
ierr = 0
return
!                        Error return
50 ierr = i
end subroutine csadd

subroutine ssubt(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, l, maxa, maxb, mina, minb
real :: t
!-----------------------------------------------------------------------
!             Subtraction of sparse real matrices
!-----------------------------------------------------------------------
!-------------------------
do j = 1,n
   wk(j) = 0.0
end do
!                  Compute the i-TH row of c
ip = 1
do i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = 0.0
      if (t == 0.0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
   end do
40 if (mina > maxa) go to 42
   do l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41    continue
   end do
42 continue
end do
ic(m + 1) = ip
ierr = 0
return
!                        Error return
50 ierr = i
end subroutine ssubt

subroutine dssubt(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, l, maxa, maxb, mina, minb
double precision :: t
!-----------------------------------------------------------------------
!        Subtraction of sparse double precision matrices
!-----------------------------------------------------------------------
!-------------------------
do j = 1,n
   wk(j) = 0.d0
end do
!                  Compute the i-TH row of c
ip = 1
do i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = 0.d0
      if (t == 0.d0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
   end do
40 if (mina > maxa) go to 42
   do l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.d0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.d0
      jc(ip) = j
      ip = ip + 1
41    continue
   end do
42 continue
end do
ic(m + 1) = ip
ierr = 0
return
!                        Error return
50 ierr = i
end subroutine dssubt

subroutine cssubt(a,ia,ja,b,ib,jb,c,ic,jc,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, num
complex, intent(in) :: a(*), b(*)
complex, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, l, maxa, maxb, mina, minb
complex :: t
!-----------------------------------------------------------------------
!            Subtraction of sparse complex matrices
!-----------------------------------------------------------------------
!-------------------------
do j = 1,n
   wk(j) = (0.0, 0.0)
end do
!                  Compute the i-TH row of c
ip = 1
do i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = (0.0, 0.0)
      if (t == (0.0, 0.0)) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
   end do
40 if (mina > maxa) go to 42
   do l = mina,maxa
      j = ja(l)
      if (wk(j) == (0.0, 0.0)) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = (0.0, 0.0)
      jc(ip) = j
      ip = ip + 1
41    continue
   end do
42 continue
end do
ic(m + 1) = ip
ierr = 0
return
!                        Error return
50 ierr = i
end subroutine cssubt

subroutine sprod(a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, num
real, intent(in) :: a(*), b(*)
real, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, jp, jpmax, jpmin, k, kp, kpmax, kpmin
real :: t
!-----------------------------------------------------------------------
!               Multiplication of sparse real matrices
!-----------------------------------------------------------------------
!-------------------------
do k = 1,n
   wk(k) = 0.0
end do
!                     Compute the i-TH row of c
ip = 1
do i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i + 1) - 1
   if (jpmin > jpmax) go to 31
   do jp = jpmin,jpmax
      t = a(jp)
      if (t == 0.0) go to 21
      j = ja(jp)
      kpmin = ib(j)
      kpmax = ib(j + 1) - 1
      if (kpmin > kpmax) go to 21
      do kp = kpmin,kpmax
         k = jb(kp)
         wk(k) = wk(k) + t*b(kp)
      end do
21    continue
   end do
   do k = 1,n
      if (wk(k) == 0.0) go to 30
      if (ip > num) go to 40
      c(ip) = wk(k)
      wk(k) = 0.0
      jc(ip) = k
      ip = ip + 1
30    continue
   end do
31 continue
end do
ic(l + 1) = ip
ierr = 0
return
!                           Error return
40 ierr = i
end subroutine sprod

subroutine dsprod(a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, num
double precision, intent(in) :: a(*), b(*)
double precision, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, jp, jpmax, jpmin, k, kp, kpmax, kpmin
double precision :: t
!-----------------------------------------------------------------------
!         Multiplication of sparse double precision matrices
!-----------------------------------------------------------------------
!-------------------------
do k = 1,n
   wk(k) = 0.d0
end do
!                     Compute the i-TH row of c
ip = 1
do i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i + 1) - 1
   if (jpmin > jpmax) go to 31
   do jp = jpmin,jpmax
      t = a(jp)
      if (t == 0.d0) go to 21
      j = ja(jp)
      kpmin = ib(j)
      kpmax = ib(j + 1) - 1
      if (kpmin > kpmax) go to 21
      do kp = kpmin,kpmax
         k = jb(kp)
         wk(k) = wk(k) + t*b(kp)
      end do
21    continue
   end do
   do k = 1,n
      if (wk(k) == 0.d0) go to 30
      if (ip > num) go to 40
      c(ip) = wk(k)
      wk(k) = 0.d0
      jc(ip) = k
      ip = ip + 1
30    continue
   end do
31 continue
end do
ic(l + 1) = ip
ierr = 0
return
!                           Error return
40 ierr = i
end subroutine dsprod

subroutine csprod(a,ia,ja,b,ib,jb,c,ic,jc,l,m,n,num,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, num
complex, intent(in) :: a(*), b(*)
complex, intent(inout) :: c(*), wk(n)
integer, intent(in) :: ia(*), ja(*), ib(*), jb(*)
integer, intent(inout) :: ic(*), jc(*)
integer :: i, ip, j, jp, jpmax, jpmin, k, kp, kpmax, kpmin
complex :: t
!-----------------------------------------------------------------------
!             Multiplication of sparse complex matrices
!-----------------------------------------------------------------------
!-------------------------
do k = 1,n
   wk(k) = (0.0, 0.0)
end do
!                     Compute the i-TH row of c
ip = 1
do i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i + 1) - 1
   if (jpmin > jpmax) go to 31
   do jp = jpmin,jpmax
      t = a(jp)
      if (t == (0.0, 0.0)) go to 21
      j = ja(jp)
      kpmin = ib(j)
      kpmax = ib(j + 1) - 1
      if (kpmin > kpmax) go to 21
      do kp = kpmin,kpmax
         k = jb(kp)
         wk(k) = wk(k) + t*b(kp)
      end do
21    continue
   end do
   do k = 1,n
      if (wk(k) == (0.0, 0.0)) go to 30
      if (ip > num) go to 40
      c(ip) = wk(k)
      wk(k) = (0.0, 0.0)
      jc(ip) = k
      ip = ip + 1
30    continue
   end do
31 continue
end do
ic(l + 1) = ip
ierr = 0
return
!                           Error return
40 ierr = i
end subroutine csprod

subroutine mvprd(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
real :: sum
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
do i = 1,m
   sum = 0.0
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine mvprd

subroutine mvprd1(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(n)
real, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
real :: sum
!-----------------------------------------------------------------------
!     Set y = a*x + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine mvprd1

subroutine mtprd(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(m)
real, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
real :: t
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
do j = 1,n
   y(j) = 0.0
end do
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
end do
end subroutine mtprd

subroutine mtprd1(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*), x(m)
real, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
real :: t
!-----------------------------------------------------------------------
!     Set y = x*a + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
end do
end subroutine mtprd1

subroutine dvprd(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
double precision :: sum
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
do i = 1,m
   sum = 0.d0
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine dvprd

subroutine dvprd1(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(n)
double precision, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
double precision :: sum
!-----------------------------------------------------------------------
!     Set y = a*x + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine dvprd1

subroutine dtprd(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(m)
double precision, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
double precision :: t
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
do j = 1,n
   y(j) = 0.d0
end do
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
end do
end subroutine dtprd

subroutine dtprd1(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*), x(m)
double precision, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
double precision :: t
!-----------------------------------------------------------------------
!     Set y = x*a + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
end do
end subroutine dtprd1

subroutine cvprd(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(n)
complex, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
complex :: sum
!-----------------------------------------------------------------------
!              Product of a sparse matrix and a vector
!-----------------------------------------------------------------------
do i = 1,m
   sum = (0.0, 0.0)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine cvprd

subroutine cvprd1(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(n)
complex, intent(inout) :: y(m)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
complex :: sum
!-----------------------------------------------------------------------
!     Set y = a*x + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
end do
end subroutine cvprd1

subroutine ctprd(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(m)
complex, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
complex :: t
!-----------------------------------------------------------------------
!              Product of a vector and a sparse matrix
!-----------------------------------------------------------------------
do j = 1,n
   y(j) = (0.0, 0.0)
end do
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
end do
end subroutine ctprd

subroutine ctprd1(m, n, a, ia, ja, x, y)
implicit none
integer, intent(in) :: m, n
complex, intent(in) :: a(*), x(m)
complex, intent(inout) :: y(n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, j, l, lmax, lmin
complex :: t
!-----------------------------------------------------------------------
!     Set y = x*a + y where A is a sparse matrix and x,y are vectors
!-----------------------------------------------------------------------
do i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
end do
end subroutine ctprd1

real function snrm(a, ia, ja, m, n)
implicit none
integer, intent(in) :: m, n
real, intent(in) :: a(*)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin
real :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                      real sparse matrix a
!-----------------------------------------------------------------------
snrm = 0.0
do i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 20
   sum = 0.0
   do ip = ipmin,ipmax
      sum = sum + abs(a(ip))
   end do
   snrm = max(snrm, sum)
20 continue
end do
end function snrm

subroutine s1nrm(a, ia, ja, m, n, anorm, wk)
implicit none
integer, intent(in) :: m, n
real, intent(out) :: anorm
real, intent(in) :: a(*)
real, intent(inout) :: wk(n)
integer, intent(in) :: ia(*), ja(*)
integer :: ip, ipmax, ipmin, j
!-----------------------------------------------------------------------
!        Computation of the L1 norm of a real sparse matrix a
!-----------------------------------------------------------------------
anorm = 0.0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) return
!     Compute the L1 norm of A
do j = 1,n
   wk(j) = 0.0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + abs(a(ip))
end do
do j = 1,n
   anorm = max(anorm,wk(j))
end do
end subroutine s1nrm

double precision function dsnrm(a, ia, ja, m, n)
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin
double precision :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                double precision sparse matrix a
!-----------------------------------------------------------------------
dsnrm = 0.d0
do i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 20
   sum = 0.d0
   do ip = ipmin,ipmax
      sum = sum + abs(a(ip))
   end do
   dsnrm = max(dsnrm, sum)
20 continue
end do
end function dsnrm

subroutine ds1nrm(a, ia, ja, m, n, anorm, wk)
implicit none
integer, intent(in) :: m, n
double precision, intent(in) :: a(*)
double precision, intent(out) :: anorm
double precision, intent(inout) :: wk(n)
integer, intent(in) :: ia(*), ja(*)
integer :: ip, ipmax, ipmin, j
!-----------------------------------------------------------------------
!               Computation of the L1 norm of a sparse
!                     double precision matrix a
!-----------------------------------------------------------------------
anorm = 0.d0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) return
!     Compute the L1 norm of A
do j = 1,n
   wk(j) = 0.d0
end do
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + abs(a(ip))
end do
do j = 1,n
   anorm = max(anorm,wk(j))
end do
end subroutine ds1nrm

subroutine spord(m, n, ia, r, iwk)
implicit none
integer, intent(in) :: m, n
integer, intent(in) :: ia(*)
integer, intent(inout) :: r(m), iwk(*)
integer :: i, ii, k, l, np1, num
!-----------------------------------------------------------------------
!        spord orders the rows of an MXN sparse matrix A,ia,ja
!        by increasing length. The row ordering is given in r.
!-----------------------------------------------------------------------
!     iwk is a work space of dimension m + n + 1.
!----------------------
np1 = n + 1
do i = 1,np1
   iwk(i) = 0
end do
i = m
do ii = 1,m
   num = ia(i + 1) - ia(i) + 1
   l = np1 + i
   iwk(l) = iwk(num)
   iwk(num) = i
   i = i - 1
end do
num = 1
k = iwk(num)
do i = 1,m
30 if (k /= 0) go to 31
   num = num + 1
   k = iwk(num)
   go to 30
31 r(i) = k
   l = np1 + k
   k = iwk(l)
end do
end subroutine spord

subroutine blkord(n, ia, ja, r, c, ib, num, iwk, ierr)
implicit none
integer, intent(inout) :: ierr
integer :: n
integer, intent(inout) :: num
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: r(n), c(n), ib(n)
integer, intent(inout) :: iwk(*)
integer :: i, length, li, np1, npi
!-----------------------------------------------------------------------
!        Reordering a sparse matrix into block triangular form
!-----------------------------------------------------------------------
!     integer iwk(5*n)
np1 = n + 1
length = ia(np1) - ia(1)
do i = 1,n
   iwk(i) = ia(i + 1) - ia(i)
end do
call mc21a(n,ja,length,ia,iwk(1),r,num,iwk(np1))
ierr = n - num
if (ierr /= 0) return
do i = 1,n
   li = r(i)
   iwk(i) = ia(li)
   npi = n + i
   iwk(npi) = ia(li + 1) - ia(li)
end do
call mc13d(n,ja,length,iwk(1),iwk(np1),c,ib,num,iwk(2*n + 1))
do i = 1,n
   li = c(i)
   iwk(i) = r(li)
end do
do i = 1,n
   r(i) = iwk(i)
end do
end subroutine blkord

pure subroutine mc21a(n,icn,licn,ip,lenr,iperm,numnz,iw)
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: numnz
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: iperm(n), iw(n,4)
interface
   pure subroutine mc21b(n,icn,licn,ip,lenr,iperm,numnz,pr,arp, &
      & cv,out)
      implicit none
      integer, intent(in) :: licn
      integer, intent(in) :: n
      integer, intent(in) :: icn(licn)
      integer, intent(in) :: ip(n)
      integer, intent(in) :: lenr(n)
      integer, intent(inout) :: iperm(n)
      integer, intent(inout) :: numnz
      integer, intent(inout) :: pr(n)
      integer, intent(inout) :: arp(n)
      integer, intent(inout) :: cv(n)
      integer, intent(inout) :: out(n)
   end subroutine mc21b
end interface
!-----------------------------------------------------------------------
! Description of parameters.
! INPUT VARIABLES   n,icn,licn,ip,lenr
! output variables  iperm,numnz
! n   ORDER OF MATRIX.
! icn array containing the column indices of the non-zeros.  Those
!     belonging to a single row must be contiguous but the ordering
!     of column indices within each row is unimportant and wasted
!     space between rows is permitted.
! licn  length of array icn.
! ip  ip(I), I=1,2,...n, is the position in array icn of the first
!     column index of a non-zero in row I.
! lenr  lenr(I) is the number of non-zeros in row I, I=1,2,..N.
! iperm contains permutation to make diagonal have the smallest
!     number of zeros on it.  Elements (iperm(I),I) I=1, ... n are
!     non-zero at the end of the algorithm unless matrix
!     is structurally singular.  In this case, (iperm(I),I) will
!     be zero for n-numnz entries.
! numnz number of non-zeros on diagonal of permuted matrix.
! iw  work array  ..  see later comments.
!-----------------------------------------------------------------------
call mc21b(n,icn,licn,ip,lenr,iperm,numnz,iw(1,1),iw(1,2), &
   & iw(1,3),iw(1,4))
end subroutine mc21a

pure subroutine mc21b(n,icn,licn,ip,lenr,iperm,numnz,pr,arp,cv,out)
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: numnz
integer, intent(in) :: ip(n), icn(licn), lenr(n)
integer, intent(inout) :: iperm(n), pr(n), cv(n), arp(n), out(n)
integer :: i, ii, in1, in2, ioutk, j, j1, jord, k, kk
!-----------------------------------------------------------------------
!     Division of work array is now described.
! pr(i) is the previous row to i in the depth first search.
! arp(i) is one less than the number of non-zeros in row i
!     which have not been scanned when looking for a cheap assignment.
! cv(i) is the most recent row extension at which column i
!     was visited.
! out(i) is one less than the number of non-zeros in row i
!     which have not been scanned during one pass through the
!     main loop.
!-----------------------------------------------------------------------
!     Initialization of arrays
do i = 1,n
   arp(i) = lenr(i) - 1
   cv(i) = 0
   iperm(i) = 0
end do
numnz = 0
!     Main loop.
!     Each pass round this loop either results in a new assignment
!     or gives a row with no assignment.
do jord = 1,n
   j = jord
   pr(j) = -1
   nswc_exit_1 : do k = 1 , jord
!     Look for a cheap assignment
      in1 = arp(j)
      if (in1 < 0) go to 60
      in2 = ip(j) + lenr(j) - 1
      in1 = in2 - in1
      do ii = in1,in2
         i = icn(ii)
         if ( iperm ( i ) == 0 ) exit nswc_exit_1
      end do
!     No cheap assignment in row
      arp(j) = -1
!     Begin looking for assignment chain starting with row j
60    out(j) = lenr(j) - 1
!     Inner loop.  Extends chain by one or backtracks.
      nswc_exit_2 : do kk = 1 , jord
         in1 = out(j)
         if (in1 < 0) go to 80
         in2 = ip(j) + lenr(j) - 1
         in1 = in2 - in1
!        Forward scan
         do ii = in1,in2
            i = icn(ii)
            if (cv(i) == jord) go to 70
!           Column i has not yet been accessed during this pass
            j1 = j
            j = iperm(i)
            cv(i) = jord
            pr(j) = j1
            out(j1) = in2 - ii - 1
            exit nswc_exit_2
70          continue
         end do
!        Backtracking step
80       j = pr(j)
         if (j == -1) go to 130
      end do nswc_exit_2
   end do nswc_exit_1
!     New assignment is made
   iperm(i) = j
   arp(j) = in2 - ii - 1
   numnz = numnz + 1
   do k = 1,jord
      j = pr(j)
      if ( j == - 1 ) exit
      ii = ip(j) + lenr(j) - out(j) - 2
      i = icn(ii)
      iperm(i) = j
   end do
130 continue
end do
!     If matrix is structurally singular, we now complete the
!     permutation iperm.
if (numnz == n) go to 500
do i = 1,n
   arp(i) = 0
end do
k = 0
do i = 1,n
   if (iperm(i) /= 0) go to 150
   k = k + 1
   out(k) = i
   go to 160
150 j = iperm(i)
   arp(j) = i
160 continue
end do
k = 0
do i = 1,n
   if (arp(i) /= 0) go to 170
   k = k + 1
   ioutk = out(k)
   iperm(ioutk) = i
170 continue
end do
500 return
end subroutine mc21b

pure subroutine mc13d(n, icn, licn, ip, lenr, ior, ib, num, iw)
implicit none
integer, intent(in) :: licn, n
integer, intent(inout) :: num
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: ior(n), ib(n), iw(n,3)
interface
   pure subroutine mc13e(n,icn,licn,ip,lenr,arp,ib,num,lowl, &
      & numb,prev)
      implicit none
      integer, intent(in) :: licn
      integer, intent(in) :: n
      integer, intent(in) :: icn(licn)
      integer, intent(in) :: ip(n)
      integer, intent(in) :: lenr(n)
      integer, intent(inout) :: arp(n)
      integer, intent(inout) :: ib(n)
      integer, intent(out) :: num
      integer, intent(inout) :: lowl(n)
      integer, intent(inout) :: numb(n)
      integer, intent(inout) :: prev(n)
   end subroutine mc13e
end interface
! Description of parameters.
! Input variables  .... n,icn,licn,ip,lenr.
! Output variables  ior,ib,num.
! n   ORDER OF THE MATRIX.
! icn array containing the column indices of the non-zeros.  Those
!     belonging to a single row must be contiguous but the ordering
!     of column indices within each row is unimportant and wasted
!     space between rows is permitted.
! licn  length of array icn.
! ip  ip(I), I=1,2,...n, is the position in array icn of the first
!     column index of a non-zero in row I.
! lenr  lenr(I) is the number of non-zeros in row I, I=1,2,...N.
! ior  ior(I) gives the position in the original ordering of the row
!     or column which is in position I in the permuted form, I=1,2,..N.
! ib  ib(I) is the row number in the permuted matrix of the beginning
!     of block I, I=1,2,...NUM.
! num number of blocks found.
! iw  work array of length 3*n.
call mc13e(n, icn, licn, ip, lenr, ior, ib, num, iw(1,1), &
   & iw(1,2), iw(1,3))
end subroutine mc13d

pure subroutine mc13e(n, icn, licn, ip, lenr, arp, ib, num, lowl, &
   & numb, prev)
implicit none
integer, intent(in) :: licn, n
integer, intent(out) :: num
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: arp(n), ib(n), lowl(n), numb(n), prev(n)
integer :: i, i1, i2, icnt, ii, isn, ist, ist1, iv, iw, j, k, lcnt, nnm1, stp, dummy
! arp(i) is one less than the number of unsearched edges leaving
!     node i.  at the end of the algorithm it is set to A
!     permutation which puts the matrix in block lower
!     triangular form.
! ib(i) is the position in the ordering of the start of the ith
!     block.  ib(n+1-i) holds the node number of the ith node
!     on the stack.
! lowl(i) is the smallest stack position of any node to which a path
!     from node i has been found.  It is set to n+1 when node i
!     is removed from the stack.
! numb(i) is the position of node i in the stack if it is on
!     it, is the permuted order of node i for those nodes
!     whose final position has been found and is otherwise zero.
! prev(i) is the node at the end of the path when node i was
!     placed on the stack.
!   icnt is the number of nodes whose positions in final ordering have
!     been found.
icnt = 0
! num is the number of blocks that have been found.
num = 0
nnm1 = n + n - 1
! Initialization of arrays.
do j = 1,n
   numb(j) = 0
   arp(j) = lenr(j) - 1
end do
nswc_exit_1 : do isn = 1 , n
! Look for a starting node
   if (numb(isn) /= 0) go to 90
   iv = isn
! ist is the number of nodes on the stack ... it is the stack pointer.
   ist = 1
! Put node iv at beginning of stack.
   lowl(iv) = 1
   numb(iv) = 1
   ib(n) = iv
! The body of this loop puts a new node on the stack or backtracks.
   do dummy = 1,nnm1
      i1 = arp(iv)
! Have all edges leaving node iv been searched.
      if (i1 < 0) go to 30
      i2 = ip(iv) + lenr(iv) - 1
      i1 = i2 - i1
! Look at edges leaving node iv until one enters a new node or
!     all edges are exhausted.
      do ii = i1,i2
         iw = icn(ii)
! Has node iw been on stack already.
         if (numb(iw) == 0) go to 70
! Update value of lowl(iv) if necessary.
         if (lowl(iw) < lowl(iv)) lowl(iv) = lowl(iw)
      end do
! There are no more edges leaving node iv.
      arp(iv) = -1
! Is node iv the root of a block.
30    if (lowl(iv) < numb(iv)) go to 60
! Order nodes in a block.
      num = num + 1
      ist1 = n + 1 - ist
      lcnt = icnt + 1
! Peel block off the top of the stack starting at the top and
!     working down to the root of the block.
      do stp = ist1,n
         iw = ib(stp)
         lowl(iw) = n + 1
         icnt = icnt + 1
         numb(iw) = icnt
         if ( iw == iv ) exit
      end do
      ist = n - stp
      ib(num) = lcnt
! Are there any nodes left on the stack.
      if (ist /= 0) go to 60
! Have all the nodes been ordered.
      if ( icnt < n ) exit
      exit nswc_exit_1
! Backtrack to previous node on path.
60    iw = iv
      iv = prev(iv)
! Update value of lowl(iv) if necessary.
      if (lowl(iw) < lowl(iv)) lowl(iv) = lowl(iw)
      go to 80
! Put new node on the stack.
70    arp(iv) = i2 - ii - 1
      prev(iw) = iv
      iv = iw
      ist = ist + 1
      lowl(iv) = ist
      numb(iv) = ist
      k = n + 1 - ist
      ib(k) = iv
80    continue
   end do
90 continue
end do nswc_exit_1
! Put permutation in the required form.
do i = 1,n
   ii = numb(i)
   arp(ii) = i
end do
end subroutine mc13e

subroutine spslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: k, l, iu, ju, u, y, p
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!  spslv calls nspiv1 which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  Input arguments---
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!  A      REAL ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING THE
!         actual nonzeros.  (See matrix storage description below)
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!  b      REAL ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!  rtemp  real array of n + max entries for internal use
!  output arguments---
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!  x      REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!         ierr values are---
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!         ierr = 0              Error.  n is less than or equal to 0
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column J, then ja(k) = J).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!  elements in A.
!------------------------
ierr = 0
if (n <= 0) return
!  Set indices to divide temporary storage for nspiv1
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!  Compute the inverse permutation of c
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!  CALL nspiv1 TO PERFORM COMPUTATIONS
call nspiv1(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
end subroutine spslv

subroutine nspiv1(n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: u(max), x(n), y(n)
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, nzcnt, ck, pk, ppk, pv, v, vi, vj, vk, nswc_ai_i4
real :: dk, lki, xpv, xpvmax, yk
!  nspiv1 uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  See spslv for descriptions of all input and output arguments
!  other than those described below
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!  Input arguments (used internally only)---
!  y   REAL ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!      right hand side
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!  u   REAL ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      the strict upper triangle of u.  (See matrix storage
!      description below)
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column j, then ja(k) = j).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
!  initialize work storage and pointers to ju
do j = 1,n
   x(j) = 0.0
end do
iu(1) = 1
juptr = 0
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
do k = 1,n
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
   p(n + 1) = n + 1
   vk = r(k)
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!  Store a(k,j) in work vector
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   nswc_ai_i4 = ppk - vj
   if ( nswc_ai_i4 < 0 ) go to 30
   if ( nswc_ai_i4 == 0 ) go to 1003
   go to 40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!  The following code computes the k-TH row of u
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
   lki = - x(vi)
   x(vi) = 0.0
!  Adjust right hand side to reflect elimination
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!  If vj is already in the adjacency of vk,
!  skip the insertion
      if (x(vj) /= 0.0) go to 90
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
      nswc_ai_i4 = vj - ppk
      if ( nswc_ai_i4 < 0 ) go to 60
      if ( nswc_ai_i4 == 0 ) go to 90
      go to 70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      nswc_ai_i4 = ppk - vj
      if ( nswc_ai_i4 < 0 ) go to 70
      if ( nswc_ai_i4 == 0 ) go to 90
      go to 80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!  Find largest entry, counting off-diagonal nonzeros
110 if (vi > n) go to 1004
   xpvmax = abs(x(vi))
   maxc = vi
   nzcnt = 0
   pv = vi
120 v = pv
   pv = p(pv)
   if (pv > n) go to 130
   nzcnt = nzcnt + 1
   xpv = abs(x(pv))
   if (xpv <= xpvmax) go to 120
   xpvmax = xpv
   maxc = pv
   maxcl = v
   go to 120
130 if (xpvmax == 0.0) go to 1004
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!  Compute D(k) = 1/L(k,k) and perform interchange.
150 dk = 1.0 / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = 0.0
!  Update right hand side.
   y(k) = yk * dk
!  Compute value for iu(k+1) and check for storage overflow
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = 0.0
   j = p(j)
   if (j <= n) go to 160
170 continue
end do
!  Backsolve u x = y, and reorder x to correspond with A
k = n
do i = 1,n
   yk = y(k)
   jmin = iu(k)
   jmax = iu(k + 1) - 1
   if (jmin > jmax) go to 190
   do j = jmin,jmax
      juj = ju(j)
      juj = ic(juj)
      yk = yk - u(j) * y(juj)
   end do
190 y(k) = yk
   ck = c(k)
   x(ck) = yk
   k = k - 1
end do
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
ierr = iu(n + 1) - iu(1)
return
!  Error returns
!  row k of A is null
1002 ierr = -k
return
!  Row k of A has a duplicate entry
1003 ierr = -(n + k)
return
!  Zero pivot in row k
1004 ierr = -(2*n + k)
return
!  Storage for u exceeded on row k
1005 ierr = -(3*n + k)
end subroutine nspiv1

subroutine rslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!     rslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system AX = b. the argument m0 specifies
!     if rslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to rslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the matrix a stored in sparse form.
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!     After an initial call to rslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to rslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call splu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call rslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine rslv

pure subroutine rslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
real, intent(in) :: b(n), d(n), t(*)
real, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
real :: sum
!            Solve LY = b by forward substitution
do k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
end do
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
21 y(k) = sum
   lk = c(k)
   x(lk) = y(k)
   k = k - 1
end do
end subroutine rslv1

subroutine tslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!     tslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system XA = b. the argument m0 specifies
!     if tslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to tslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the matrix a stored in sparse form.
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!     After an initial call to tslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to tslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call splu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call tslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine tslv

pure subroutine tslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
real, intent(in) :: b(n), d(n), t(*)
real, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
!            Solve YU = b by forward substitution
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
do k = 1,n
   if (y(k) == 0.0) go to 21
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
end do
!            Solve XL = y by backward substitution
x(n) = y(n)/d(n)
if (n == 1) return
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
end subroutine tslv1

subroutine splu(a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
real, intent(in) :: a(*)
real, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, maxil, pm, nswc_ai_i4
real :: const, wi, wmax
!-----------------------------------------------------------------------
!     splu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a real sparse matrix.
!     U is a unit upper triangular matrix.
!     Input arguments ---
!     A,ia,ja  the sparse matrix to be decomposed.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!     n        ORDER OF THE MATRIX a.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!     Output arguments ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!     d        REAL ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!     Work spaces ---
!     w        REAL ARRAY OF DIMENSION n.
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.0
end do
!     Perform the LU factorization of the r(k)-TH row of A
do k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!     Set p to the reordered row of A
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   nswc_ai_i4 = pm - j
   if ( nswc_ai_i4 < 0 ) go to 21
   if ( nswc_ai_i4 == 0 ) go to 210
   go to 22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!     Process the entries in the lower triangle of A
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == 0.0) go to 30
!     L(k,i) is nonzero. Therefore store it in L.
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = 0.0
!     Perform elimination using the i-TH row of U
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= 0.0) go to 43
      nswc_ai_i4 = j - pm
      if ( nswc_ai_i4 < 0 ) go to 40
      if ( nswc_ai_i4 == 0 ) go to 43
      go to 41
40    pm = i
41    m = pm
      pm = p(m)
      nswc_ai_i4 = pm - j
      if ( nswc_ai_i4 < 0 ) go to 41
      if ( nswc_ai_i4 == 0 ) go to 43
      go to 42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   end do
   go to 30
!     Search for the k-TH pivot element
50 if (i > n) go to 220
   wmax = abs(w(i))
   maxi = i
   pm = i
51 m = pm
   pm = p(m)
   if (pm > n) go to 60
   wi = abs(w(pm))
   if (wi <= wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!     Store the pivot in d
60 if (wmax == 0.0) go to 220
   d(k) = w(maxi)
!     Perform the column interchange
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
80 w(maxi) = w(k)
   w(k) = 0.0
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!     The remaining elements of p form the k-TH row of U
   iu(k) = jptr + 1
90 if (i > n) go to 100
   if (w(i) == 0.0) go to 91
   jptr = jptr + 1
   if (jptr > max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = 0.0
91 i = p(i)
   go to 90
!     Prepare for the next row
100 it(k + 1) = jptr + 1
end do
ierr = jptr
return
!     -------------------- Error return --------------------
!     row r(k) is null
200 ierr = -k
return
!     Row r(k) has a duplicate entry
210 ierr = -(n + k)
return
!     Zero pivot in row r(k)
220 ierr = -(2*n + k)
return
!     Storage for L and U exceeded on row r(k)
230 ierr = -(3*n + k)
end subroutine splu

subroutine dspslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: k, l, iu, ju, u, y, p
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!  dspslv calls dnspiv which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  Input arguments---
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!  A      DOUBLE PRECISION ARRAY WITH ONE ENTRY PER NONZERO IN A,
!         containing the actual nonzeros. (See the matrix storage
!         description below)
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!  b      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE RIGHT
!         hand side data
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!  rtemp  double precision array of n + max entries for internal use
!  output arguments---
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!  x      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!         solution vector
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!         ierr values are---
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!         ierr = 0              Error.  n is less than or equal to 0
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column J, then ja(k) = J).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(I))/ja(ia(I)) is the first entry for row I in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzero
!  elements in A.
!------------------------
ierr = 0
if (n <= 0) return
!  Set indices to divide temporary storage for dnspiv
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!  Compute the inverse permutation of c
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!  CALL dnspiv TO PERFORM COMPUTATIONS
call dnspiv(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
end subroutine dspslv

subroutine dnspiv(n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: u(max), x(n), y(n)
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, nzcnt, ck, pk, ppk, pv, v, vi, vj, vk, nswc_ai_i4
double precision :: dk, lki, xpv, xpvmax, yk
!  dnspiv uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!  See dspslv for descriptions of all input and output arguments
!  other than those described below
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!  Input arguments (used internally only)---
!  y   DOUBLE PRECISION ARRAY OF n ENTRIES USED TO COMPUTE
!      the updated right hand side
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!  u   DOUBLE PRECISION ARRAY OF MAX ENTRIES USED FOR THE ACTUAL
!      nonzeros in the strict upper triangle of u. (See matrix
!      storage description below)
!  storage of sparse matrices---
!  the sparse matrix a is stored using three arrays ia, ja, and a.
!  The array a contains the nonzeros of the matrix ROW-by-ROW, not
!  necessarily in order of increasing column number.  The array ja
!  contains the column numbers corresponding to the nonzeros stored
!  in the array a (I.E., if the nonzero stored in a(k) is in
!  column j, then ja(k) = j).  The array ia contains pointers to the
!  rows of nonzeros/column indices in the array a/ja (I.E.,
!  a(ia(i))/ja(ia(i)) is the first entry for row i in the array a/ja).
!  ia(n+1) is set so that ia(n+1) - ia(1) = The number of nonzeros in
!  A.  iu, ju, and u are used in a similar way to store the strict upper
!  triangle of u, except that ju actually contains c(j) instead of j
!  initialize work storage and pointers to ju
do j = 1,n
   x(j) = 0.d0
end do
iu(1) = 1
juptr = 0
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
do k = 1,n
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
   p(n + 1) = n + 1
   vk = r(k)
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!  Store a(k,j) in work vector
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   nswc_ai_i4 = ppk - vj
   if ( nswc_ai_i4 < 0 ) go to 30
   if ( nswc_ai_i4 == 0 ) go to 1003
   go to 40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!  The following code computes the k-TH row of u
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
   lki = - x(vi)
   x(vi) = 0.d0
!  Adjust right hand side to reflect elimination
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!  If vj is already in the adjacency of vk,
!  skip the insertion
      if (x(vj) /= 0.d0) go to 90
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
      nswc_ai_i4 = vj - ppk
      if ( nswc_ai_i4 < 0 ) go to 60
      if ( nswc_ai_i4 == 0 ) go to 90
      go to 70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      nswc_ai_i4 = ppk - vj
      if ( nswc_ai_i4 < 0 ) go to 70
      if ( nswc_ai_i4 == 0 ) go to 90
      go to 80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!  Find largest entry, counting off-diagonal nonzeros
110 if (vi > n) go to 1004
   xpvmax = abs(x(vi))
   maxc = vi
   nzcnt = 0
   pv = vi
120 v = pv
   pv = p(pv)
   if (pv > n) go to 130
   nzcnt = nzcnt + 1
   xpv = abs(x(pv))
   if (xpv <= xpvmax) go to 120
   xpvmax = xpv
   maxc = pv
   maxcl = v
   go to 120
130 if (xpvmax == 0.d0) go to 1004
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!  Compute D(k) = 1/L(k,k) and perform interchange.
150 dk = 1.d0 / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = 0.d0
!  Update right hand side.
   y(k) = yk * dk
!  Compute value for iu(k+1) and check for storage overflow
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = 0.d0
   j = p(j)
   if (j <= n) go to 160
170 continue
end do
!  Backsolve u x = y, and reorder x to correspond with A
k = n
do i = 1,n
   yk = y(k)
   jmin = iu(k)
   jmax = iu(k + 1) - 1
   if (jmin > jmax) go to 190
   do j = jmin,jmax
      juj = ju(j)
      juj = ic(juj)
      yk = yk - u(j) * y(juj)
   end do
190 y(k) = yk
   ck = c(k)
   x(ck) = yk
   k = k - 1
end do
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
ierr = iu(n + 1) - iu(1)
return
!  Error returns
!  row k of A is null
1002 ierr = -k
return
!  Row k of A has a duplicate entry
1003 ierr = -(n + k)
return
!  Zero pivot in row k
1004 ierr = -(2*n + k)
return
!  Storage for u exceeded on row k
1005 ierr = -(3*n + k)
end subroutine dnspiv

subroutine dslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!     dslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system AX = b. the argument m0 specifies
!     if dslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to dslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the double precision matrix a stored in sparse form.
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!     After an initial call to dslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call dsplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call dslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine dslv

pure subroutine dslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
double precision, intent(in) :: b(n), d(n), t(*)
double precision, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
double precision :: sum
!            Solve LY = b by forward substitution
do k = 1,n
   lk = r(k)
   sum = b(lk)
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 11
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
11 y(k) = sum/d(k)
end do
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
k = n
do i = 1,n
   sum = y(k)
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      sum = sum - t(jj)*y(j)
   end do
21 y(k) = sum
   lk = c(k)
   x(lk) = y(k)
   k = k - 1
end do
end subroutine dslv1

subroutine dtslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: it, iu, jt, k, l, y, t, p
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!     dtslv employs Gaussian elimination with column interchanges to
!     solve the NXN linear system XA = b. the argument m0 specifies
!     if dtslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to dtslv.
!     Input arguments when m0=0 ---
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!     a,ia,ja  the double precision matrix a stored in sparse form.
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!     Output arguments when m0=0 ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!     General storage areas ---
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!     After an initial call to dtslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dtslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!     Set indices to divide temporary storage
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!     Compute the inverse permutation of c
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!     Obtain the LU decomposition of A
call dsplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!     Solve the system of equations
20 call dtslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
end subroutine dtslv

pure subroutine dtslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
double precision, intent(in) :: b(n), d(n), t(*)
double precision, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
!            Solve YU = b by forward substitution
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
do k = 1,n
   if (y(k) == 0.d0) go to 21
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
end do
!            Solve XL = y by backward substitution
x(n) = y(n)/d(n)
if (n == 1) return
k = n
y(n) = x(n)
do i = 2,n
   jmin = it(k)
   jmax = iu(k) - 1
   if (jmin > jmax) go to 31
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
31 k = k - 1
   y(k) = y(k)/d(k)
end do
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
end subroutine dtslv1

subroutine dsplu(a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, maxil, pm, nswc_ai_i4
double precision :: const, wi, wmax
!-----------------------------------------------------------------------
!     dsplu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a double precision sparse
!     matrix. U is a unit upper triangular matrix.
!     Input arguments ---
!     A,ia,ja  the sparse matrix to be decomposed.
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!     n        ORDER OF THE MATRIX a.
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!     Output arguments ---
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!     d        DOUBLE PRECISION ARRAY CONTAINING THE n DIAGONAL
!              elements of L.
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!     Work spaces ---
!     w        DOUBLE PRECISION ARRAY OF DIMENSION n.
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.d0
end do
!     Perform the LU factorization of the r(k)-TH row of A
do k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!     Set p to the reordered row of A
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   nswc_ai_i4 = pm - j
   if ( nswc_ai_i4 < 0 ) go to 21
   if ( nswc_ai_i4 == 0 ) go to 210
   go to 22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!     Process the entries in the lower triangle of A
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == 0.d0) go to 30
!     L(k,i) is nonzero. Therefore store it in L.
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = 0.d0
!     Perform elimination using the i-TH row of U
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= 0.d0) go to 43
      nswc_ai_i4 = j - pm
      if ( nswc_ai_i4 < 0 ) go to 40
      if ( nswc_ai_i4 == 0 ) go to 43
      go to 41
40    pm = i
41    m = pm
      pm = p(m)
      nswc_ai_i4 = pm - j
      if ( nswc_ai_i4 < 0 ) go to 41
      if ( nswc_ai_i4 == 0 ) go to 43
      go to 42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   end do
   go to 30
!     Search for the k-TH pivot element
50 if (i > n) go to 220
   wmax = abs(w(i))
   maxi = i
   pm = i
51 m = pm
   pm = p(m)
   if (pm > n) go to 60
   wi = abs(w(pm))
   if (wi <= wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!     Store the pivot in d
60 if (wmax == 0.d0) go to 220
   d(k) = w(maxi)
!     Perform the column interchange
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
80 w(maxi) = w(k)
   w(k) = 0.d0
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!     The remaining elements of p form the k-TH row of U
   iu(k) = jptr + 1
90 if (i > n) go to 100
   if (w(i) == 0.d0) go to 91
   jptr = jptr + 1
   if (jptr > max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = 0.d0
91 i = p(i)
   go to 90
!     Prepare for the next row
100 it(k + 1) = jptr + 1
end do
ierr = jptr
return
!     -------------------- Error return --------------------
!     row r(k) is null
200 ierr = -k
return
!     Row r(k) has a duplicate entry
210 ierr = -(n + k)
return
!     Zero pivot in row r(k)
220 ierr = -(2*n + k)
return
!     Storage for L and U exceeded on row r(k)
230 ierr = -(3*n + k)
end subroutine dsplu

subroutine s1cnd(n, a, ia, ja, r, c, max, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
real, intent(out) :: cond
real, intent(in) :: a(*)
real, intent(inout) :: wk(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
integer :: isgn, iter, iv, ix, j, jump, kase
real :: ainorm, anorm
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a sparse matrix a
!-----------------------------------------------------------------------
!-----------------------
!     real wk(4*n + max)
!     integer iwk(5*n + max + 2)
!-----------------------
cond = 0.0
call s1nrm(a, ia, ja, n, n, anorm, wk)
if (anorm == 0.0) go to 50
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
kase = 0
ainorm = 0.0
call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call rslv(0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
!     Check if A is singular or if there are errors
if (ierr > 0) go to 20
if (abs(ierr) <= n) go to 50
ierr = ierr + n
if (abs(ierr) <= n) return
ierr = ierr + n
if (abs(ierr) <= n) go to 50
return
!     General loop to estimate the norm  ainorm
!     of the inverse of A
20 call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 40
if (kase /= 1) go to 30
call rslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
30 call tslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
!     Compute the value of cond
40 cond = anorm*ainorm
return
!     Singular case
50 ierr = 0
end subroutine s1cnd

subroutine ds1cnd(n, a, ia, ja, r, c, max, cond, iwk, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*)
double precision, intent(out) :: cond
double precision, intent(inout) :: wk(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), iwk(*)
integer :: isgn, iter, iv, ix, j, jump, kase
double precision :: anorm, ainorm
!-----------------------------------------------------------------------
!              Computation of the L1 condition number
!                       of a sparse matrix a
!-----------------------------------------------------------------------
!-----------------------
!     double precision wk(4*n + max)
!     integer iwk(5*n + max + 2)
!-----------------------
cond = 0.d0
call ds1nrm(a, ia, ja, n, n, anorm, wk)
if (anorm == 0.d0) go to 50
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
kase = 0
ainorm = 0.d0
call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call dslv(0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
!     Check if A is singular or if there are errors
if (ierr > 0) go to 20
if (abs(ierr) <= n) go to 50
ierr = ierr + n
if (abs(ierr) <= n) return
ierr = ierr + n
if (abs(ierr) <= n) go to 50
return
!     General loop to estimate the norm  ainorm
!     of the inverse of A
20 call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 40
if (kase /= 1) go to 30
call dslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
30 call dtslv(1, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
go to 20
!     Compute the value of cond
40 cond = anorm*ainorm
return
!     Singular case
50 ierr = 0
end subroutine ds1cnd

pure subroutine sonest(n, v, x, isgn, anorm, kase, iter, j, jump)
implicit none
integer, intent(inout) :: iter, j, jump, kase
integer, intent(in) :: n
real, intent(inout) :: anorm
real, intent(inout) :: v(n), x(n)
integer, intent(inout) :: isgn(n)
integer :: i, jlast, l
real :: altsgn, anrm, t
integer, parameter :: itmax = 5
interface
   pure function isamax(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      integer :: isamax
   end function isamax
   pure function sasum(n,sx,incx)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real :: sasum
   end function sasum
   pure subroutine scopy(n,sx,incx,sy,incy)
      implicit none
      integer, intent(in) :: n
      real, intent(in) :: sx(*)
      integer, intent(in) :: incx
      real, intent(inout) :: sy(*)
      integer, intent(in) :: incy
   end subroutine scopy
end interface
!-----------------------------------------------------------------------
!     sonest estimates the 1-norm of A square, real matrix  A.
!     Reverse communication is used for evaluating
!     matrix-vector products.
!     On entry
!        n       the order of the matrix.  n .GE. 1.
!        kase    INTEGER  (= 0).
!     On intermediate returns
!        kase    = 1 or 2.
!        x       MUST BE OVERWRITTEN BY
!                     A*x,             IF kase = 1,
!                     TRANSPOSE(A)*x,  IF kase = 2,
!                and sonest must be RE-called, with all the other
!                parameters unchanged.
!        ITER    NUMBER OF THE CURRENT ITERATION.
!     On final return
!        kase    = 0.
!        anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!        v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!                         (W  is not returned).
!        ITER    NUMBER OF INTERATIONS TAKEN.
!        Written by nick Higham, university of manchester. Modified
!        by A.H. Morris (NSWC).
!     Reference
!     N.J. Higham (1987) Fortran codes for estimating
!     the 1-norm of a real or complex matrix, with applications
!     to condition  estimation, numerical analysis report no. 135,
!     university of manchester, manchester M13 9PL, england.
!-----------------------------------------------------------------------
if (kase /= 0) go to 20
t = 1.0/float(n)
do i = 1,n
   x(i) = t
end do
iter = 0
kase = 1
jump = 1
return
20 select case (jump)
case (1)
   go to 100
case (2)
   go to 200
case (3)
   go to 300
case (4)
   go to 400
case (5)
   go to 500
end select
!     ................ ENTRY   (jump = 1)
!     first iteration.  x has been overwritten by A*x.
100 iter = 1
if (n > 1) go to 110
v(1) = x(1)
anorm = abs(v(1))
go to 510
110 anorm = sasum(n,x,1)
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 2
return
!     ................ ENTRY   (jump = 2)
!     first iteration.  x has been overwritten by transpose(A)*x.
200 iter = 2
j = isamax(n,x,1)
!     Main loop - Iterations 2,3,...,itmax.
210 do i = 1,n
   x(i) = 0.0
end do
x(j) = 1.0
kase = 1
jump = 3
return
!     ................ ENTRY   (jump = 3)
!     x has been overwritten by A*x.
300 call scopy(n,x,1,v,1)
anrm = anorm
anorm = sasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) < 0.0) l = -1
   if (l /= isgn(i)) go to 320
end do
!     Repeated sign vector detected, hence algorithm has converged.
go to 410
!     Test for cycling.
320 if (anorm <= anrm) go to 410
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 4
return
!     ................ ENTRY   (jump = 4)
!     x has been overwritten by transpose(A)*x.
400 jlast = j
j = isamax(n,x,1)
if (x(jlast) == abs(x(j)) .or. &
   & iter >= itmax) go to 410
iter = iter + 1
go to 210
!     Iteration complete.  Final stage.
410 altsgn = 1.0
do i = 1,n
   x(i) = altsgn * (1.0 + float(i - 1)/float(n - 1))
   altsgn = -altsgn
end do
kase = 1
jump = 5
return
!     ................ ENTRY   (jump = 5)
!     x has been overwritten by A*x.
500 anrm = 2.0*sasum(n,x,1)/float(3*n)
if (anrm <= anorm) go to 510
call scopy(n,x,1,v,1)
anorm = anrm
510 kase = 0
end subroutine sonest

