subroutine cslvmp(mo, n, a, ka, b, x, wk, iwk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, mo
integer :: n
integer :: i, ir
!     ******************************************************************
!     Solution of complex linear equations with iterative improvement
!     ******************************************************************
complex, intent(in) :: a(ka,n), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(inout) :: iwk(n)
!     -----------------
!     complex wk(n*n + n)
!     -----------------
if (mo .ne. 0) go to 10
!
!             Compute the LU decomposition of A
!
call cmcopy(n, n, a, ka, wk, n)
call cgefa(wk, n, n, iwk, ierr)
if (ierr .eq. 0) go to 10
ierr = -ierr
return
!
!            SOLVE THE SYSTEM OF EQUATIONS AX = b
!
10 do 11 i = 1,n
11 x(i) = b(i)
!
ir = n*n + 1
call cgesl(wk, n, n, iwk, x, 0)
call cluimp(a, ka, n, wk(1), n, iwk, b, x, wk(ir), ierr)
return
end subroutine cslvmp

subroutine cluimp(a, ka, n, q, kq, ipvt, b, x, r, ind)
implicit none
integer, intent(out) :: ind
integer, intent(in) :: ka, kq, n
integer :: i, j
real :: eps, eps2, rat, ratio, rnrm, xnrm
real :: spmpar
! ----------------------------------------------------------------------
!     Purpose
!       GIVEN AN APPROXIMATE SOLUTION x OF A COMPLEX SYSTEM AX = b
!       obtained using cgeco or cgefa. cluimp attempts to compute
!       an improved solution correct to machine precision.
!
!     Parameters
!
!       A    A COMPLEX ARRAY OF DIMENSION (ka,n) CONTAINING THE
!            matrix a of order n.
!       q    A COMPLEX ARRAY OF DIMENSION (kq,n) CONTAINING THE
!            LU decomposition of a produced by cgeco or cgefa.
!       ipvt an array of dimension n containing the permutation
!            information given by cgeco or cgefa.
!       b    THE RIGHT HAND SIDE OF THE EQUATION AX = b.
!       x    ON INPUT x IS THE APPROXIMATE SOLUTION OF AX = b TO
!            be improved. On output x is the solution obtained.
!       r    A COMPLEX ARRAY FOR INTERNAL USE BY THE ROUTINE.
!       Ind  variable that reports the status of the results.
!            ind = 0 IF IMPROVEMENT OF x IS SUCCESSFUL WITH A
!            gain in accuracy of at least 50 per cent each
!            ITERATION. OTHERWISE ind = 1.
!
! ----------------------------------------------------------------------
complex, intent(in) :: a(ka,n), q(kq,n), b(n)
complex, intent(inout) :: x(n), r(n)
integer, intent(in) :: ipvt(n)
double precision :: ra, ia, rx, ix, rsum, isum
!
!     ********** eps IS A MACHINE DEPENDENT PARAMETER. ASSIGN EPS
!                the value U where U is the smallest floating point
!                NUMBER SUCH THAT 1.0 + U .GT. 1.0.
!
eps = spmpar(1)
!
ind = 0
xnrm = 0.0
do 10 i = 1,n
10 xnrm = xnrm + (real(x(i))**2 + aimag(x(i))**2)
if (xnrm .eq. 0.0) return
eps2 = eps*eps
ratio = 1.0
!
!                  Compute the residual vector
!
20 do 22 i = 1,n
rsum = dble(real(b(i)))
isum = dble(aimag(b(i)))
  do 21 j = 1,n
  ra = dble(real(a(i,j)))
  ia = dble(aimag(a(i,j)))
  rx = dble(real(x(j)))
  ix = dble(aimag(x(j)))
  rsum = rsum - ra*rx + ia*ix
21 isum = isum - ra*ix - ia*rx
22 r(i) = cmplx(sngl(rsum),sngl(isum))
!
!                  Find the correction vector
!
call cgesl(q, kq, n, ipvt, r, 0)
rnrm = 0.0
do 30 i = 1,n
30 rnrm = rnrm + (real(r(i))**2 + aimag(r(i))**2)
if (rnrm .le. eps2*xnrm) return
!
!                Form a new approximate solution
!
do 40 i = 1,n
40 x(i) = x(i) + r(i)
xnrm = 0.0
do 41 i = 1,n
41 xnrm = xnrm + (real(x(i))**2 + aimag(x(i))**2)
!
if (xnrm .eq. 0.0) return
rat = ratio
ratio = rnrm/xnrm
if (ratio .le. 0.25*rat) go to 20
!
if (ratio .gt. amin1(rat,4.0*eps2)) ind = 1
return
end subroutine cluimp

subroutine cgeco(a,lda,n,ipvt,rcond,z)
implicit none
integer, intent(in) :: lda
integer :: n
integer, intent(inout) :: ipvt(*)
complex, intent(inout) :: a(lda,*), z(*)
real, intent(inout) :: rcond
!
!     cgeco factors a complex matrix BY Gaussian elimination
!     and estimates the condition of the matrix.
!
!     If  rcond  is not needed, cgefa is slightly faster.
!     TO SOLVE  a*X = B , FOLLOW cgeco BY cgesl.
!     To compute  INVERSE(a)*C , follow cgeco by cgesl.
!     To compute  DETERMINANT(a) , follow cgeco by cgedi.
!     To compute  INVERSE(a) , follow cgeco by cgedi.
!
!     On entry
!
!        A       COMPLEX(lda, n)
!                the matrix to be factored.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                THE FACTORIZATION CAN BE WRITTEN  a = l*U  WHERE
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        rcond   REAL
!                an estimate of the reciprocal condition of  A .
!                FOR THE SYSTEM  a*X = B , RELATIVE PERTURBATIONS
!                in  A  and  B  of size  epsilon  may cause
!                relative perturbations in  X  of size  epsilon/rcond .
!                If  rcond  is so small that the logical expression
!                           1.0 + rcond .EQ. 1.0
!                is true, then  A  may be singular to working
!                precision.  In particular,  rcond  is zero  if
!                exact singularity is detected or the estimate
!                underflows.
!
!        z       COMPLEX(n)
!                a work vector whose contents are usually unimportant.
!                If  A  is close to a singular matrix, then  z  is
!                an approximate null vector in the sense that
!                norm(a*z) = rcond*norm(a)*norm(z) .
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     LINPACK cgefa
!     BLAS caxpy,cdotc,csscal,scasum
!     Fortran abs,aimag,AMAX1,cmplx,CONJG,real
!
!     Internal variables
!
complex :: cdotc, ek, t, wk, wkm
real :: anorm, s, scasum, sm, ynorm
integer :: info, j, k, kb, kp1, l
!
complex :: zdum, zdum1, zdum2, csign1
real :: cabs1
cabs1(zdum) = abs(real(zdum)) + abs(aimag(zdum))
csign1(zdum1,zdum2) = cabs1(zdum1)*(zdum2/cabs1(zdum2))
!
!     Compute 1-norm of A
!
anorm = 0.0e0
do j = 1, n
   anorm = amax1(anorm,scasum(n,a(1,j),1))
end do
!
!     Factor
!
call cgefa(a,lda,n,ipvt,info)
!
!     rcond = 1/(NORM(a)*(ESTIMATE OF NORM(INVERSE(a)))) .
!     ESTIMATE = NORM(z)/NORM(Y) WHERE  a*z = Y  AND  ctrans(a)*Y = E .
!     ctrans(a)  is the conjugate transpose of A .
!     The components of  E  are chosen to cause maximum local
!     GROWTH IN THE ELEMENTS OF W  WHERE  ctrans(U)*W = E .
!     The vectors are frequently rescaled to avoid overflow.
!
!     SOLVE ctrans(U)*W = E
!
ek = (1.0e0,0.0e0)
do j = 1, n
   z(j) = (0.0e0,0.0e0)
end do
do k = 1, n
   if (cabs1(z(k)) .ne. 0.0e0) ek = csign1(ek,-z(k))
   if (cabs1(ek-z(k)) .le. cabs1(a(k,k))) go to 30
      s = cabs1(a(k,k))/cabs1(ek-z(k))
      call csscal(n,s,z,1)
      ek = cmplx(s,0.0e0)*ek
30 continue
   wk = ek - z(k)
   wkm = -ek - z(k)
   s = cabs1(wk)
   sm = cabs1(wkm)
   if (cabs1(a(k,k)) .eq. 0.0e0) go to 40
      wk = wk/conjg(a(k,k))
      wkm = wkm/conjg(a(k,k))
   go to 50
40 continue
      wk = (1.0e0,0.0e0)
      wkm = (1.0e0,0.0e0)
50 continue
   kp1 = k + 1
   if (kp1 .gt. n) go to 90
      do j = kp1, n
         sm = sm + cabs1(z(j)+wkm*conjg(a(k,j)))
         z(j) = z(j) + wk*conjg(a(k,j))
         s = s + cabs1(z(j))
      end do
      if (s .ge. sm) go to 80
         t = wkm - wk
         wk = wkm
         do j = kp1, n
            z(j) = z(j) + t*conjg(a(k,j))
         end do
80 continue
90 continue
   z(k) = wk
end do
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
!
!     SOLVE ctrans(l)*Y = W
!
do kb = 1, n
   k = n + 1 - kb
   if (k .lt. n) z(k) = z(k) + cdotc(n-k,a(k+1,k),1,z(k+1),1)
   if (cabs1(z(k)) .le. 1.0e0) go to 110
      s = 1.0e0/cabs1(z(k))
      call csscal(n,s,z,1)
110 continue
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
end do
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
!
ynorm = 1.0e0
!
!     SOLVE l*V = Y
!
do k = 1, n
   l = ipvt(k)
   t = z(l)
   z(l) = z(k)
   z(k) = t
   if (k .lt. n) call caxpy(n-k,t,a(k+1,k),1,z(k+1),1)
   if (cabs1(z(k)) .le. 1.0e0) go to 130
      s = 1.0e0/cabs1(z(k))
      call csscal(n,s,z,1)
      ynorm = s*ynorm
130 continue
end do
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
ynorm = s*ynorm
!
!     SOLVE  U*z = V
!
do kb = 1, n
   k = n + 1 - kb
   if (cabs1(z(k)) .le. cabs1(a(k,k))) go to 150
      s = cabs1(a(k,k))/cabs1(z(k))
      call csscal(n,s,z,1)
      ynorm = s*ynorm
150 continue
   if (cabs1(a(k,k)) .ne. 0.0e0) z(k) = z(k)/a(k,k)
   if (cabs1(a(k,k)) .eq. 0.0e0) z(k) = (1.0e0,0.0e0)
   t = -z(k)
   call caxpy(k-1,t,a(1,k),1,z(1),1)
end do
!     MAKE ZNORM = 1.0
s = 1.0e0/scasum(n,z,1)
call csscal(n,s,z,1)
ynorm = s*ynorm
!
if (anorm .ne. 0.0e0) rcond = ynorm/anorm
if (anorm .eq. 0.0e0) rcond = 0.0e0
return
end subroutine cgeco

subroutine cgefa(a,lda,n,ipvt,info)
implicit none
integer, intent(in) :: lda
integer :: n
integer, intent(inout) :: ipvt(*), info
complex, intent(inout) :: a(lda,*)
!
!     cgefa factors a complex matrix BY Gaussian elimination.
!
!     cgefa is usually called by cgeco, but it can be called
!     directly with a saving in time if  RCOND  is not needed.
!     (TIME FOR cgeco) = (1 + 9/n)*(TIME FOR cgefa) .
!
!     On entry
!
!        A       COMPLEX(lda, n)
!                the matrix to be factored.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX AND THE MULTIPLIERS
!                which were used to obtain it.
!                THE FACTORIZATION CAN BE WRITTEN  a = l*U  WHERE
!                l  is a product of permutation and unit lower
!                triangular matrices and  U  is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                = 0  NORMAL VALUE.
!                = k  IF  U(k,k) .EQ. 0.0 .  THIS IS NOT AN ERROR
!                     condition for this subroutine, but it does
!                     indicate that cgesl or cgedi will divide by zero
!                     if called.  Use  RCOND  in cgeco for a reliable
!                     indication of singularity.
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS caxpy,cscal,icamax
!     Fortran abs,aimag,real
!
!     Internal variables
!
complex :: t
integer :: icamax, j, k, kp1, l, nm1
!
complex :: zdum
real :: cabs1
cabs1(zdum) = abs(real(zdum)) + abs(aimag(zdum))
!
!     Gaussian elimination with partial pivoting
!
info = 0
nm1 = n - 1
if (nm1 .lt. 1) go to 70
do k = 1, nm1
   kp1 = k + 1
!
!        FIND l = PIVOT INDEX
!
   l = icamax(n-k+1,a(k,k),1) + k - 1
   ipvt(k) = l
!
!        Zero pivot implies this column already triangularized
!
   if (cabs1(a(l,k)) .eq. 0.0e0) go to 40
!
!           Interchange if necessary
!
      if (l .eq. k) go to 10
         t = a(l,k)
         a(l,k) = a(k,k)
         a(k,k) = t
10 continue
!
!           Compute multipliers
!
      t = -(1.0e0,0.0e0)/a(k,k)
      call cscal(n-k,t,a(k+1,k),1)
!
!           Row elimination with column indexing
!
      do j = kp1, n
         t = a(l,j)
         if (l .eq. k) go to 20
            a(l,j) = a(k,j)
            a(k,j) = t
20 continue
         call caxpy(n-k,t,a(k+1,k),1,a(k+1,j),1)
      end do
   go to 50
40 continue
      info = k
50 continue
end do
70 continue
ipvt(n) = n
if (cabs1(a(n,n)) .eq. 0.0e0) info = n
return
end subroutine cgefa

subroutine cgesl(a,lda,n,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
complex, intent(in) :: a(lda,*)
complex, intent(inout) :: b(*)
!
!     cgesl solves the complex system
!     a * X = b  OR  ctrans(a) * X = b
!     using the factors computed by cgeco or cgefa.
!
!     On entry
!
!        A       COMPLEX(lda, n)
!                the output from cgeco or cgefa.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!        ipvt    INTEGER(n)
!                the pivot vector from cgeco or cgefa.
!
!        b       COMPLEX(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  a*X = b ,
!                = NONZERO   TO SOLVE  ctrans(a)*X = b  WHERE
!                            ctrans(a)  is the conjugate transpose.
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
!        CALLED CORRECTLY AND IF cgeco HAS SET RCOND .GT. 0.0
!        OR cgefa HAS SET INFO .EQ. 0 .
!
!     To compute  INVERSE(a) * C  where  C  is a matrix
!     with  P  columns
!           call cgeco(a,lda,n,ipvt,rcond,z)
!           if (rcond is too small) go to ...
!           do 10 j = 1, p
!              call cgesl(a,lda,n,ipvt,c(1,j),0)
!        10 continue
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS caxpy,cdotc
!     FORTRAN CONJG
!
!     Internal variables
!
complex :: cdotc, t
integer :: k, kb, l, nm1
!
nm1 = n - 1
if (job .ne. 0) go to 50
!
!        job = 0 , SOLVE  a * X = b
!        FIRST SOLVE  l*Y = b
!
   if (nm1 .lt. 1) go to 30
   do k = 1, nm1
      l = ipvt(k)
      t = b(l)
      if (l .eq. k) go to 10
         b(l) = b(k)
         b(k) = t
10 continue
      call caxpy(n-k,t,a(k+1,k),1,b(k+1),1)
   end do
30 continue
!
!        NOW SOLVE  U*X = Y
!
   do kb = 1, n
      k = n + 1 - kb
      b(k) = b(k)/a(k,k)
      t = -b(k)
      call caxpy(k-1,t,a(1,k),1,b(1),1)
   end do
go to 100
50 continue
!
!        job = NONZERO, SOLVE  ctrans(a) * X = b
!        FIRST SOLVE  ctrans(U)*Y = b
!
   do k = 1, n
      t = cdotc(k-1,a(1,k),1,b(1),1)
      b(k) = (b(k) - t)/conjg(a(k,k))
   end do
!
!        NOW SOLVE ctrans(l)*X = Y
!
   if (nm1 .lt. 1) go to 90
   do kb = 1, nm1
      k = n - kb
      b(k) = b(k) + cdotc(n-k,a(k+1,k),1,b(k+1),1)
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
end subroutine cgesl

subroutine cgedi(a,lda,n,ipvt,det,work,job)
implicit none
integer, intent(in) :: lda, n, ipvt(*), job
complex, intent(inout) :: a(lda,*), det(2), work(*)
!
!     cgedi computes the determinant and inverse of a matrix
!     using the factors computed by cgeco or cgefa.
!
!     On entry
!
!        A       COMPLEX(lda, n)
!                the output from cgeco or cgefa.
!
!        lda     INTEGER
!                the leading dimension of the array  a .
!
!        n       INTEGER
!                the order of the matrix  a .
!
!        ipvt    INTEGER(n)
!                the pivot vector from cgeco or cgefa.
!
!        WORK    COMPLEX(n)
!                work vector.  Contents destroyed.
!
!        JOB     INTEGER
!                = 11   BOTH DETERMINANT AND INVERSE.
!                = 01   INVERSE ONLY.
!                = 10   DETERMINANT ONLY.
!
!     On return
!
!        A       INVERSE OF ORIGINAL MATRIX IF REQUESTED.
!                Otherwise unchanged.
!
!        det     COMPLEX(2)
!                determinant of original matrix IF requested.
!                Otherwise not referenced.
!                determinant = det(1) * 10.0**det(2)
!                WITH  1.0 .LE. cabs1(det(1)) .LT. 10.0
!                OR  det(1) .EQ. 0.0 .
!
!     Error condition
!
!        A division by zero will occur if the input factor contains
!        a zero on the diagonal and the inverse is requested.
!        It will not occur if the subroutines are called correctly
!        AND IF cgeco HAS SET RCOND .GT. 0.0 OR cgefa HAS SET
!        INFO .EQ. 0 .
!
!     LINPACK. This version dated 08/14/78 .
!     Cleve Moler, University of New Mexico, Argonne National Lab.
!
!     Subroutines and functions
!
!     BLAS caxpy,cscal,cswap
!     Fortran abs,aimag,cmplx,mod,real
!
!     Internal variables
!
complex :: t
real :: ten
integer :: i, j, k, kb, kp1, l, nm1
!
complex :: zdum
real :: cabs1
cabs1(zdum) = abs(real(zdum)) + abs(aimag(zdum))
!
!     Compute determinant
!
if (job/10 .eq. 0) go to 70
   det(1) = (1.0e0,0.0e0)
   det(2) = (0.0e0,0.0e0)
   ten = 10.0e0
   do 50 i = 1, n
      if (ipvt(i) .ne. i) det(1) = -det(1)
      det(1) = a(i,i)*det(1)
!        ...Exit
      if (cabs1(det(1)) .eq. 0.0e0) go to 60
10 if (cabs1(det(1)) .ge. 1.0e0) go to 20
         det(1) = cmplx(ten,0.0e0)*det(1)
         det(2) = det(2) - (1.0e0,0.0e0)
      go to 10
20 continue
30 if (cabs1(det(1)) .lt. ten) go to 40
         det(1) = det(1)/cmplx(ten,0.0e0)
         det(2) = det(2) + (1.0e0,0.0e0)
      go to 30
40 continue
50 continue
60 continue
70 continue
!
!     Compute INVERSE(U)
!
if (mod(job,10) .eq. 0) go to 150
   do k = 1, n
      a(k,k) = (1.0e0,0.0e0)/a(k,k)
      t = -a(k,k)
      call cscal(k-1,t,a(1,k),1)
      kp1 = k + 1
      if (n .lt. kp1) go to 90
      do j = kp1, n
         t = a(k,j)
         a(k,j) = (0.0e0,0.0e0)
         call caxpy(k,t,a(1,k),1,a(1,j),1)
      end do
90 continue
   end do
!
!        Form INVERSE(U)*INVERSE(l)
!
   nm1 = n - 1
   if (nm1 .lt. 1) go to 140
   do kb = 1, nm1
      k = n - kb
      kp1 = k + 1
      do i = kp1, n
         work(i) = a(i,k)
         a(i,k) = (0.0e0,0.0e0)
      end do
      do j = kp1, n
         t = work(j)
         call caxpy(n,t,a(1,j),1,a(1,k),1)
      end do
      l = ipvt(k)
      if (l .ne. k) call cswap(n,a(1,k),1,a(1,l),1)
   end do
140 continue
150 continue
return
end subroutine cgedi

subroutine dcmslv (mo,n,m,ar,ai,ka,br,bi,kb,ierr,ipvt,wk)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m, mo
integer :: n
!-----------------------------------------------------------------------
!     Partial pivot Gauss procedure for inverting double precision
!     complex matrices and solving double precision complex equations
!-----------------------------------------------------------------------
double precision, intent(inout) :: ar(ka,n), ai(ka,n), br(*), &
&bi(*), wk(*)
integer, intent(inout) :: ipvt(n)
!
if (n .lt. 1 .or. ka .lt. n) go to 30
if (m .le. 0) go to 10
if (kb .lt. n) go to 30
!
!                      Matrix factorization
!
10 call dcfact (ar, ai, ka, n, ipvt, ierr)
if (ierr .ne. 0) return
!
!                 SOLUTION OF THE EQUATION AX = B
!
if (m .le. 0) go to 20
call dcsol (n, m, ar, ai, ka, br, bi, kb, ipvt)
!
!                 Calculation of the inverse of A
!
20 if (mo .eq. 0) call dcminv (ar, ai, ka, n, ipvt, wk)
return
!
!                          Error return
!
30 ierr = -1
return
end subroutine dcmslv

subroutine dcfact (ar, ai, ka, n, ipvt, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, n
integer :: i, j, k, kp1, l, nm1
!-----------------------------------------------------------------------
!     Decomposes a complex matrix BY partial pivot Gauss elimination
!-----------------------------------------------------------------------
!
!     Input ...
!
!        ar and ai are the real and imaginary parts of the matrix A
!        to be decomposed.
!
!        ka = DECLARED ROW DIMENSION OF THE ARRAYS ar AND ai
!
!        n  = ORDER OF THE MATRIX A
!
!     Output ...
!
!        ar and ai contain an upper triangular matrix U and the
!        MULTIPLIERS NEEDED TO CONSTRUCT l SO THAT A = l*U .
!
!        ipvt = THE PIVOT VECTOR.
!            ipvt(i) = THE INDEX OF THE k-TH PIVOT ROW (i .LT. n)
!            ipvt(n) = (-1)**(NUMBER OF INTERCHANGES)
!
!        ierr is a variable that reports the status of the results.
!        ierr has one of the following values ...
!            ierr = 0   THE DECOMPOSITION OF A WAS OBTAINED.
!            ierr = k   THE k-TH PIVOT ELEMENT IS 0.
!
!     IF ierr = 0 THEN THE DETERMINANT OF A HAS THE VALUE ...
!        det(a) = ipvt(n) * a(1,1) * a(2,2) * ... * a(n,n)
!-----------------------------------------------------------------------
double precision, intent(inout) :: ar(ka,n), ai(ka,n)
integer, intent(inout) :: ipvt(n)
double precision :: p, pr, pi, t, tr, ti
!
ierr = 0
ipvt(n) = 1
if (n .eq. 1) go to 50
nm1 = n - 1
!
do k = 1,nm1
   kp1 = k + 1
!
!               Search for the k-TH pivot element
!
   p = dabs(ar(k,k)) + dabs(ai(k,k))
   l = k
   do 10 i = kp1,n
      t = dabs(ar(i,k)) + dabs(ai(i,k))
      if (p .ge. t) go to 10
      p = t
      l = i
10 continue
   if (p .eq. 0.d0) go to 100
!
   pr = ar(l,k)
   pi = ai(l,k)
   ipvt(k) = l
   if (l .eq. k) go to 20
   ipvt(n) = -ipvt(n)
   ar(l,k) = ar(k,k)
   ar(k,k) = pr
   ai(l,k) = ai(k,k)
   ai(k,k) = pi
!
!                    Compute the multipliers
!
20 call cdivid(1.d0, 0.d0, pr, pi, pr, pi)
   do i = kp1,n
      tr = ar(i,k)
      ti = ai(i,k)
      ar(i,k) = tr*pr - ti*pi
      ai(i,k) = tr*pi + ti*pr
   end do
!
!              Interchange and eliminate by columns
!
   do 31 j = kp1,n
      tr = ar(l,j)
      ar(l,j) = ar(k,j)
      ar(k,j) = tr
      ti = ai(l,j)
      ai(l,j) = ai(k,j)
      ai(k,j) = ti
      if (dabs(tr) + dabs(ti) .eq. 0.d0) go to 31
      do i = kp1,n
         ar(i,j) = ar(i,j) - ar(i,k)*tr + ai(i,k)*ti
         ai(i,j) = ai(i,j) - ar(i,k)*ti - ai(i,k)*tr
      end do
31 continue
end do
!
!                  Check the n-TH pivot element
!
50 if (dabs(ar(n,n)) + dabs(ai(n,n)) .eq. 0.d0) ierr = n
return
!
!                    k-TH pivot element is 0
!
100 ierr = k
return
end subroutine dcfact

subroutine dcsol (n, m, ar, ai, ka, br, bi, kb, ipvt)
implicit none
integer, intent(in) :: ka, kb, m, n
integer :: i, j, k, km1, kp1, l, nm1
!-----------------------------------------------------------------------
!     SOLUTION OF THE SYSTEM OF m EQUATIONS A*X = B USING THE
!     decomposition obtained by dcfact. This routine CANNOT be
!     used when dcfact terminates with nonzero IERR.
!-----------------------------------------------------------------------
!
!     Input ...
!
!        ar and ai contain the LU decomposition of the matrix
!        obtained by dcfact.
!
!        ka = DECLARED ROW DIMENSION OF THE ARRAYS ar AND ai
!
!        n  = ORDER OF THE MATRIX
!
!        br and bi are the real and imaginary parts of the
!        right hand side matrix.
!
!        kb = DECLARED ROW DIMENSION OF THE ARRAYS br AND bi
!
!        m  = NUMBER OF COLUMNS OF B
!
!        ipvt = PIVOT VECTOR OBTAINED FROM dcfact
!
!     Output ...
!
!        br and bi contain the real and imaginary parts of the
!        solution X.
!
!-----------------------------------------------------------------------
double precision, intent(in) :: ar(ka,n), ai(ka,n)
double precision, intent(inout) :: br(kb,m), bi(kb,m)
integer, intent(in) :: ipvt(n)
double precision :: pr, pi, tr, ti
!
!                    Forward elimination
!
if (n .eq. 1) go to 50
nm1 = n - 1
do k = 1, nm1
   kp1 = k + 1
   l = ipvt(k)
   do 11 j = 1,m
      tr = br(l,j)
      br(l,j) = br(k,j)
      br(k,j) = tr
      ti = bi(l,j)
      bi(l,j) = bi(k,j)
      bi(k,j) = ti
      if (dabs(tr) + dabs(ti) .eq. 0.d0) go to 11
      do i = kp1, n
         br(i,j) = br(i,j) - ar(i,k)*tr + ai(i,k)*ti
         bi(i,j) = bi(i,j) - ar(i,k)*ti - ai(i,k)*tr
      end do
11 continue
end do
!
!                   Backward elimination
!               for the last n - 1 variables
!
do l = 1,nm1
   km1 = n - l
   k = km1 + 1
   call cdivid (1.d0, 0.d0, ar(k,k), ai(k,k), pr, pi)
   do j = 1,m
      tr = br(k,j)
      ti = bi(k,j)
      br(k,j) = tr*pr - ti*pi
      bi(k,j) = tr*pi + ti*pr
      tr = br(k,j)
      ti = bi(k,j)
      do i = 1, km1
         br(i,j) = br(i,j) - ar(i,k)*tr + ai(i,k)*ti
         bi(i,j) = bi(i,j) - ar(i,k)*ti - ai(i,k)*tr
      end do
   end do
end do
!
50 call cdivid (1.d0, 0.d0, ar(1,1), ai(1,1), pr, pi)
do j = 1,m
   tr = br(1,j)
   ti = bi(1,j)
   br(1,j) = tr*pr - ti*pi
   bi(1,j) = tr*pi + ti*pr
end do
return
end subroutine dcsol

subroutine dcminv (ar, ai, ka, n, ipvt, temp)
implicit none
integer, intent(in) :: ka
integer :: n
integer :: i, ip1, j, jb, k, kp1, l, nm1, nmi, nmk, np1
!-----------------------------------------------------------------------
!     Computation of the inverse of A matrix A using the LU
!     decomposition obtained by dcfact. This routine CANNOT
!     be used when dcfact terminates with nonzero IERR.
!-----------------------------------------------------------------------
!
!     Input ...
!
!        ar and ai contain the LU decomposition of the matrix
!        obtained by dcfact.
!
!        ka = DECLARED ROW DIMENSION OF THE ARRAYS ar AND ai
!
!        n  = ORDER OF THE MATRIX
!
!        ipvt = PIVOT VECTOR OBTAINED FROM dcfact
!
!        temp = TEMPORARY STORAGE AREA FOR THE SUBROUTINE
!
!     Output ...
!
!        ar and ai contain the inverse of the matrix.
!
!-----------------------------------------------------------------------
double precision, intent(inout) :: ar(ka,n), ai(ka,n), temp(2,n)
integer, intent(in) :: ipvt(n)
double precision :: sr, si, tr, ti
!
call cdivid (1.d0, 0.d0, ar(n,n), ai(n,n), ar(n,n), ai(n,n))
if (n .eq. 1) return
np1 = n + 1
nm1 = n - 1
!
!                Replace U with the inverse of U
!
do nmi = 1,nm1
   i = n - nmi
   ip1 = i + 1
   call cdivid (1.d0, 0.d0, ar(i,i), ai(i,i), tr, ti)
   do jb = 1,nmi
      j = np1 - jb
      sr = 0.d0
      si = 0.d0
      do l = ip1,j
         sr = sr + ar(i,l)*ar(l,j) - ai(i,l)*ai(l,j)
         si = si + ar(i,l)*ai(l,j) + ai(i,l)*ar(l,j)
      end do
      ar(i,j) = -sr*tr + si*ti
      ai(i,j) = -sr*ti - si*tr
   end do
   ar(i,i) = tr
   ai(i,i) = ti
end do
!
!                Compute  INVERSE(U)*INVERSE(l)
!
do 60 nmk = 1,nm1
   k = n - nmk
   kp1 = k + 1
   do i = kp1,n
      temp(1,i) = ar(i,k)
      temp(2,i) = ai(i,k)
      ar(i,k) = 0.d0
      ai(i,k) = 0.d0
   end do
!
   do j = kp1,n
      tr = temp(1,j)
      ti = temp(2,j)
      do i = 1,n
         ar(i,k) = ar(i,k) - ar(i,j)*tr + ai(i,j)*ti
         ai(i,k) = ai(i,k) - ar(i,j)*ti - ai(i,j)*tr
      end do
   end do
!
   l = ipvt(k)
   if (k .eq. l) go to 60
   do 50 i = 1,n
      tr = ar(i,k)
      ar(i,k) = ar(i,l)
      ar(i,l) = tr
      ti = ai(i,k)
      ai(i,k) = ai(i,l)
50 ai(i,l) = ti
60 continue
return
end subroutine dcminv

subroutine ssvdc(x,ldx,n,p,s,e,u,ldu,v,ldv,work,job,info)
implicit none
integer, intent(in) :: ldx, n, p, ldu, ldv, job
integer, intent(inout) :: info
real, intent(inout) :: x(ldx,*), s(*), e(*), u(ldu,*), v(ldv,*), &
&work(*)
!
!
!     ssvdc is a subroutine to reduce a real NXP matrix x by
!     orthogonal transformations u and v to diagonal form.  The
!     diagonal elements s(i) are the singular values of x.  the
!     columns of u are the corresponding left singular vectors,
!     and the columns of v the right singular vectors.
!
!     On entry
!
!         x         real(ldx,p), WHERE ldx.GE.n.
!                   x contains the matrix whose singular value
!                   decomposition is to be computed.  x is
!                   destroyed by ssvdc.
!
!         ldx       INTEGER.
!                   ldx is the leading dimension of the array x.
!
!         n         INTEGER.
!                   n is the number of rows of the matrix x.
!
!         p         INTEGER.
!                   p is the number of columns of the matrix x.
!
!         ldu       INTEGER.
!                   ldu is the leading dimension of the array u.
!                   (See below).
!
!         ldv       INTEGER.
!                   ldv is the leading dimension of the array v.
!                   (See below).
!
!         WORK      real(n).
!                   Work is a scratch array.
!
!         JOB       INTEGER.
!                   Job controls the computation of the singular
!                   vectors.  It has the decimal expansion AB
!                   with the following meaning
!
!                        A.EQ.0    DO NOT COMPUTE THE LEFT SINGULAR
!                                  vectors.
!                        A.EQ.1    RETURN THE n LEFT SINGULAR VECTORS
!                                  IN u.
!                        A.GE.2    RETURN THE FIRST min(n,p) SINGULAR
!                                  vectors in u.
!                        b.EQ.0    DO NOT COMPUTE THE RIGHT SINGULAR
!                                  vectors.
!                        b.EQ.1    RETURN THE RIGHT SINGULAR VECTORS
!                                  IN v.
!
!     On return
!
!         s         real(MM), WHERE MM=min(n+1,p).
!                   The first min(n,p) entries of s contain the
!                   singular values of x arranged in descending
!                   order of magnitude.
!
!         e         real(p).
!                   e ordinarily contains zeros.  However see the
!                   discussion of info for exceptions.
!
!         u         real(ldu,k), WHERE ldu.GE.n.  IF JOBA.EQ.1 THEN
!                                   k.EQ.n, IF JOBA.GE.2 THEN
!                                   k.EQ.min(n,p).
!                   u contains the matrix of left singular vectors.
!                   u IS NOT REFERENCED IF JOBA.EQ.0.  IF n.LE.p
!                   OR IF JOBA.EQ.2, THEN u MAY BE IDENTIFIED WITH x
!                   in the subroutine CALL.
!
!         v         real(ldv,p), WHERE ldv.GE.p.
!                   v contains the matrix of right singular vectors.
!                   v IS NOT REFERENCED IF job.EQ.0.  IF p.LE.n,
!                   then v may be identified with x in the
!                   subroutine CALL.
!
!         INFO      INTEGER.
!                   The singular values (and their corresponding
!                   singular vectors) s(info+1),s(info+2),...,s(M)
!                   ARE CORRECT (HERE M=min(n,p)).  THUS IF
!                   info.EQ.0, ALL THE SINGULAR VALUES AND THEIR
!                   vectors are correct.  In any event, the matrix
!                   b = TRANS(u)*x*v IS THE BIDIAGONAL MATRIX
!                   with the elements of s on its diagonal and the
!                   elements of e on its super-diagonal (TRANS(u)
!                   is the transpose of u).  Thus the singular
!                   values of x and b are the same.
!
!     LINPACK. This version dated 03/19/79 .
!     G.W. Stewart, university of maryland, Argonne National Lab.
!
!     ***** USES THE FOLLOWING FUNCTIONS AND SUBPROGRAMS.
!
!     external srot
!     BLAS saxpy,sdot,sscal,sswap,snrm2,srotg
!     Fortran abs,AMAX1,MAX0,MIN0,mod,sqrt
!
!     Internal variables
!
integer :: i, iter, j, jobu, k, kase, kk, l, ll, lls, lm1, lp1, &
&ls, lu, m, maxit, mm, mm1, mp1, nct, nctp1, ncu, nrt, nrtp1
real :: sdot, t
real :: b, c, cs, el, emm1, f, g, snrm2, scale, shift, sl, sm, sn, &
&smm1, t1, test, ztest
logical :: wantu, wantv
!
!
!     Set the maximum number of iterations.
!
maxit = 30
!
!     Determine what is to be computed.
!
wantu = .false.
wantv = .false.
jobu = mod(job,100)/10
ncu = n
if (jobu .gt. 1) ncu = min0(n,p)
if (jobu .ne. 0) wantu = .true.
if (mod(job,10) .ne. 0) wantv = .true.
!
!     Reduce x to bidiagonal form, storing the diagonal elements
!     in s and the super-diagonal elements in e.
!
info = 0
nct = min0(n-1,p)
nrt = max0(0,min0(p-2,n))
lu = max0(nct,nrt)
if (lu .lt. 1) go to 170
do 160 l = 1, lu
   lp1 = l + 1
   if (l .gt. nct) go to 20
!
!           Compute the transformation for the l-TH column and
!           place the l-TH diagonal in s(l).
!
      s(l) = snrm2(n-l+1,x(l,l),1)
      if (s(l) .eq. 0.0e0) go to 10
         if (x(l,l) .ne. 0.0e0) s(l) = sign(s(l),x(l,l))
         call sscal(n-l+1,1.0e0/s(l),x(l,l),1)
         x(l,l) = 1.0e0 + x(l,l)
10 continue
      s(l) = -s(l)
20 continue
   if (p .lt. lp1) go to 50
   do 40 j = lp1, p
      if (l .gt. nct) go to 30
      if (s(l) .eq. 0.0e0) go to 30
!
!              Apply the transformation.
!
         t = -sdot(n-l+1,x(l,l),1,x(l,j),1)/x(l,l)
         call saxpy(n-l+1,t,x(l,l),1,x(l,j),1)
30 continue
!
!           Place the l-TH row of x into  e for the
!           subsequent calculation of the row transformation.
!
      e(j) = x(l,j)
40 continue
50 continue
   if (.not.wantu .or. l .gt. nct) go to 70
!
!           Place the transformation in u for subsequent back
!           multiplication.
!
      do i = l, n
         u(i,l) = x(i,l)
      end do
70 continue
   if (l .gt. nrt) go to 150
!
!           Compute the l-TH row transformation and place the
!           l-TH super-diagonal in e(l).
!
      e(l) = snrm2(p-l,e(lp1),1)
      if (e(l) .eq. 0.0e0) go to 80
         if (e(lp1) .ne. 0.0e0) e(l) = sign(e(l),e(lp1))
         call sscal(p-l,1.0e0/e(l),e(lp1),1)
         e(lp1) = 1.0e0 + e(lp1)
80 continue
      e(l) = -e(l)
      if (lp1 .gt. n .or. e(l) .eq. 0.0e0) go to 120
!
!              Apply the transformation.
!
         do i = lp1, n
            work(i) = 0.0e0
         end do
         do 100 j = lp1, p
            call saxpy(n-l,e(j),x(lp1,j),1,work(lp1),1)
100 continue
         do j = lp1, p
            call saxpy(n-l,-e(j)/e(lp1),work(lp1),1,x(lp1,j),1)
         end do
120 continue
      if (.not.wantv) go to 140
!
!              Place the transformation in v for subsequent
!              back multiplication.
!
         do i = lp1, p
            v(i,l) = e(i)
         end do
140 continue
150 continue
160 continue
170 continue
!
!     Set up the final bidiagonal matrix of order M.
!
m = min0(p,n+1)
nctp1 = nct + 1
nrtp1 = nrt + 1
if (nct .lt. p) s(nctp1) = x(nctp1,nctp1)
if (n .lt. m) s(m) = 0.0e0
if (nrtp1 .lt. m) e(nrtp1) = x(nrtp1,m)
e(m) = 0.0e0
!
!     If required, generate u.
!
if (.not.wantu) go to 300
   if (ncu .lt. nctp1) go to 200
   do j = nctp1, ncu
      do i = 1, n
         u(i,j) = 0.0e0
      end do
      u(j,j) = 1.0e0
   end do
200 continue
   if (nct .lt. 1) go to 290
   do ll = 1, nct
      l = nct - ll + 1
      if (s(l) .eq. 0.0e0) go to 250
         lp1 = l + 1
         if (ncu .lt. lp1) go to 220
         do j = lp1, ncu
            t = -sdot(n-l+1,u(l,l),1,u(l,j),1)/u(l,l)
            call saxpy(n-l+1,t,u(l,l),1,u(l,j),1)
         end do
220 continue
         call sscal(n-l+1,-1.0e0,u(l,l),1)
         u(l,l) = 1.0e0 + u(l,l)
         lm1 = l - 1
         if (lm1 .lt. 1) go to 240
         do i = 1, lm1
            u(i,l) = 0.0e0
         end do
240 continue
      go to 270
250 continue
         do i = 1, n
            u(i,l) = 0.0e0
         end do
         u(l,l) = 1.0e0
270 continue
   end do
290 continue
300 continue
!
!     If it is required, generate v.
!
if (.not.wantv) go to 350
   do ll = 1, p
      l = p - ll + 1
      lp1 = l + 1
      if (l .gt. nrt) go to 320
      if (e(l) .eq. 0.0e0) go to 320
         do j = lp1, p
            t = -sdot(p-l,v(lp1,l),1,v(lp1,j),1)/v(lp1,l)
            call saxpy(p-l,t,v(lp1,l),1,v(lp1,j),1)
         end do
320 continue
      do i = 1, p
         v(i,l) = 0.0e0
      end do
      v(l,l) = 1.0e0
   end do
350 continue
!
!     Main iteration loop for the singular values.
!
mm = m
iter = 0
360 continue
!
!        Quit if all the singular values have been found.
!
!     ...Exit
   if (m .eq. 0) go to 620
!
!        If too many iterations have been performed, set
!        flag and return.
!
   if (iter .lt. maxit) go to 370
      info = m
!     ......Exit
      go to 620
370 continue
!
!        This section of the program inspects for
!        negligible elements in the s and e arrays.  On
!        completion the variables kase and l are set as follows.
!
!           kase = 1     IF s(M) AND e(l-1) ARE NEGLIGIBLE AND l.LT.M
!           kase = 2     IF s(l) IS NEGLIGIBLE AND l.LT.M
!           kase = 3     IF e(l-1) IS NEGLIGIBLE, l.LT.M, AND
!                        s(l), ..., s(M) are not negligible (QR step).
!           kase = 4     IF e(M-1) IS NEGLIGIBLE (CONVERGENCE).
!
   do ll = 1, m
      l = m - ll
!        ...Exit
      if (l .eq. 0) go to 400
      test = abs(s(l)) + abs(s(l+1))
      ztest = test + abs(e(l))
      if (ztest .ne. test) go to 380
         e(l) = 0.0e0
!        ......Exit
         go to 400
380 continue
   end do
400 continue
   if (l .ne. m - 1) go to 410
      kase = 4
   go to 480
410 continue
      lp1 = l + 1
      mp1 = m + 1
      do lls = lp1, mp1
         ls = m - lls + lp1
!           ...Exit
         if (ls .eq. l) go to 440
         test = 0.0e0
         if (ls .ne. m) test = test + abs(e(ls))
         if (ls .ne. l + 1) test = test + abs(e(ls-1))
         ztest = test + abs(s(ls))
         if (ztest .ne. test) go to 420
            s(ls) = 0.0e0
!           ......Exit
            go to 440
420 continue
      end do
440 continue
      if (ls .ne. l) go to 450
         kase = 3
      go to 470
450 continue
      if (ls .ne. m) go to 460
         kase = 1
      go to 470
460 continue
         kase = 2
         l = ls
470 continue
480 continue
   l = l + 1
!
!        Perform the task indicated by kase.
!
   go to (490,520,540,570), kase
!
!        Deflate negligible s(M).
!
490 continue
      mm1 = m - 1
      f = e(m-1)
      e(m-1) = 0.0e0
      do kk = l, mm1
         k = mm1 - kk + l
         t1 = s(k)
         call srotg(t1,f,cs,sn)
         s(k) = t1
         if (k .eq. l) go to 500
            f = -sn*e(k-1)
            e(k-1) = cs*e(k-1)
500 continue
         if (wantv) call srot(p,v(1,k),1,v(1,m),1,cs,sn)
      end do
   go to 610
!
!        Split at negligible s(l).
!
520 continue
      f = e(l-1)
      e(l-1) = 0.0e0
      do k = l, m
         t1 = s(k)
         call srotg(t1,f,cs,sn)
         s(k) = t1
         f = -sn*e(k)
         e(k) = cs*e(k)
         if (wantu) call srot(n,u(1,k),1,u(1,l-1),1,cs,sn)
      end do
   go to 610
!
!        Perform one QR step.
!
540 continue
!
!           Calculate the shift.
!
      scale = amax1(abs(s(m)),abs(s(m-1)),abs(e(m-1)),abs(s(l)), &
&abs(e(l)))
      sm = s(m)/scale
      smm1 = s(m-1)/scale
      emm1 = e(m-1)/scale
      sl = s(l)/scale
      el = e(l)/scale
      b = ((smm1 + sm)*(smm1 - sm) + emm1**2)/2.0e0
      c = (sm*emm1)**2
      shift = 0.0e0
      if (b .eq. 0.0e0 .and. c .eq. 0.0e0) go to 550
         shift = sqrt(b**2+c)
         if (b .lt. 0.0e0) shift = -shift
         shift = c/(b + shift)
550 continue
      f = (sl + sm)*(sl - sm) - shift
      g = sl*el
!
!           Chase zeros.
!
      mm1 = m - 1
      do k = l, mm1
         call srotg(f,g,cs,sn)
         if (k .ne. l) e(k-1) = f
         f = cs*s(k) + sn*e(k)
         e(k) = cs*e(k) - sn*s(k)
         g = sn*s(k+1)
         s(k+1) = cs*s(k+1)
         if (wantv) call srot(p,v(1,k),1,v(1,k+1),1,cs,sn)
         call srotg(f,g,cs,sn)
         s(k) = f
         f = cs*e(k) + sn*s(k+1)
         s(k+1) = -sn*e(k) + cs*s(k+1)
         g = sn*e(k+1)
         e(k+1) = cs*e(k+1)
         if (wantu .and. k .lt. n) &
&call srot(n,u(1,k),1,u(1,k+1),1,cs,sn)
      end do
      e(m-1) = f
      iter = iter + 1
   go to 610
!
!        Convergence.
!
570 continue
!
!           Make the singular value  positive.
!
      if (s(l) .ge. 0.0e0) go to 580
         s(l) = -s(l)
         if (wantv) call sscal(p,-1.0e0,v(1,l),1)
580 continue
!
!           Order the singular value.
!
590 if (l .eq. mm) go to 600
!           ...Exit
         if (s(l) .ge. s(l+1)) go to 600
         t = s(l)
         s(l) = s(l+1)
         s(l+1) = t
         if (wantv .and. l .lt. p) &
&call sswap(p,v(1,l),1,v(1,l+1),1)
         if (wantu .and. l .lt. n) &
&call sswap(n,u(1,l),1,u(1,l+1),1)
         l = l + 1
      go to 590
600 continue
      iter = 0
      m = m - 1
610 continue
go to 360
620 continue
return
end subroutine ssvdc

subroutine dsvdc(x,ldx,n,p,s,e,u,ldu,v,ldv,work,job,info)
implicit none
integer, intent(in) :: ldx, n, p, ldu, ldv, job
integer, intent(inout) :: info
double precision, intent(inout) :: x(ldx,*), s(*), e(*), u(ldu,*), &
&v(ldv,*), work(*)
!
!
!     dsvdc is a subroutine to reduce a double precision NXP matrix x
!     by orthogonal transformations u and V to diagonal form.  The
!     diagonal elements s(i) are the singular values of x.  the
!     columns of u are the corresponding left singular vectors,
!     and the columns of V the right singular vectors.
!
!     On entry
!
!         x         DOUBLE PRECISION(ldx,p), WHERE ldx.GE.n.
!                   x contains the matrix whose singular value
!                   decomposition is to be computed.  x is
!                   destroyed by dsvdc.
!
!         ldx       INTEGER.
!                   ldx is the leading dimension of the array x.
!
!         n         INTEGER.
!                   n is the number of rows of the matrix x.
!
!         p         INTEGER.
!                   p is the number of columns of the matrix x.
!
!         ldu       INTEGER.
!                   ldu is the leading dimension of the array u.
!                   (See below).
!
!         ldv       INTEGER.
!                   ldv is the leading dimension of the array V.
!                   (See below).
!
!         WORK      DOUBLE PRECISION(n).
!                   Work is a scratch array.
!
!         JOB       INTEGER.
!                   Job controls the computation of the singular
!                   vectors.  It has the decimal expansion AB
!                   with the following meaning
!
!                        A.EQ.0    DO NOT COMPUTE THE LEFT SINGULAR
!                                  vectors.
!                        A.EQ.1    RETURN THE n LEFT SINGULAR VECTORS
!                                  IN u.
!                        A.GE.2    RETURN THE FIRST min(n,p) SINGULAR
!                                  vectors in u.
!                        b.EQ.0    DO NOT COMPUTE THE RIGHT SINGULAR
!                                  vectors.
!                        b.EQ.1    RETURN THE RIGHT SINGULAR VECTORS
!                                  IN V.
!
!     On return
!
!         s         DOUBLE PRECISION(MM), WHERE MM=min(n+1,p).
!                   The first min(n,p) entries of s contain the
!                   singular values of x arranged in descending
!                   order of magnitude.
!
!         e         DOUBLE PRECISION(p).
!                   e ordinarily contains zeros.  However see the
!                   discussion of info for exceptions.
!
!         u         DOUBLE PRECISION(ldu,k), WHERE ldu.GE.n.  IF
!                                   JOBA.EQ.1 THEN k.EQ.n, IF JOBA.GE.2
!                                   THEN k.EQ.min(n,p).
!                   u contains the matrix of left singular vectors.
!                   u IS NOT REFERENCED IF JOBA.EQ.0.  IF n.LE.p
!                   OR IF JOBA.EQ.2, THEN u MAY BE IDENTIFIED WITH x
!                   in the subroutine CALL.
!
!         V         DOUBLE PRECISION(ldv,p), WHERE ldv.GE.p.
!                   V contains the matrix of right singular vectors.
!                   V IS NOT REFERENCED IF job.EQ.0.  IF p.LE.n,
!                   then V may be identified with x in the
!                   subroutine CALL.
!
!         INFO      INTEGER.
!                   The singular values (and their corresponding
!                   singular vectors) s(info+1),s(info+2),...,s(M)
!                   ARE CORRECT (HERE M=min(n,p)).  THUS IF
!                   info.EQ.0, ALL THE SINGULAR VALUES AND THEIR
!                   vectors are correct.  In any event, the matrix
!                   b = TRANS(u)*x*V IS THE BIDIAGONAL MATRIX
!                   with the elements of s on its diagonal and the
!                   elements of e on its super-diagonal (TRANS(u)
!                   is the transpose of u).  Thus the singular
!                   values of x and b are the same.
!
!     LINPACK. This version dated 03/19/79 .
!     G.W. Stewart, university of maryland, Argonne National Lab.
!
!     dsvdc uses the following functions and subprograms.
!
!     external drot
!     BLAS daxpy,ddot,dscal,dswap,dnrm2,drotg
!     Fortran dabs,DMAX1,MAX0,MIN0,mod,DSQRT
!
!     Internal variables
!
integer :: i, iter, j, jobu, k, kase, kk, l, ll, lls, lm1, lp1, &
&ls, lu, m, maxit, mm, mm1, mp1, nct, nctp1, ncu, nrt, nrtp1
double precision :: ddot, t
double precision :: b, c, cs, el, emm1, f, g, dnrm2, scale, shift, &
&sl, sm, sn, smm1, t1, test, ztest
logical :: wantu, wantv
!
!
!     Set the maximum number of iterations.
!
maxit = 30
!
!     Determine what is to be computed.
!
wantu = .false.
wantv = .false.
jobu = mod(job,100)/10
ncu = n
if (jobu .gt. 1) ncu = min0(n,p)
if (jobu .ne. 0) wantu = .true.
if (mod(job,10) .ne. 0) wantv = .true.
!
!     Reduce x to bidiagonal form, storing the diagonal elements
!     in s and the super-diagonal elements in e.
!
info = 0
nct = min0(n-1,p)
nrt = max0(0,min0(p-2,n))
lu = max0(nct,nrt)
if (lu .lt. 1) go to 170
do 160 l = 1, lu
   lp1 = l + 1
   if (l .gt. nct) go to 20
!
!           Compute the transformation for the l-TH column and
!           place the l-TH diagonal in s(l).
!
      s(l) = dnrm2(n-l+1,x(l,l),1)
      if (s(l) .eq. 0.0d0) go to 10
         if (x(l,l) .ne. 0.0d0) s(l) = dsign(s(l),x(l,l))
         call dscal(n-l+1,1.0d0/s(l),x(l,l),1)
         x(l,l) = 1.0d0 + x(l,l)
10 continue
      s(l) = -s(l)
20 continue
   if (p .lt. lp1) go to 50
   do 40 j = lp1, p
      if (l .gt. nct) go to 30
      if (s(l) .eq. 0.0d0) go to 30
!
!              Apply the transformation.
!
         t = -ddot(n-l+1,x(l,l),1,x(l,j),1)/x(l,l)
         call daxpy(n-l+1,t,x(l,l),1,x(l,j),1)
30 continue
!
!           Place the l-TH row of x into  e for the
!           subsequent calculation of the row transformation.
!
      e(j) = x(l,j)
40 continue
50 continue
   if (.not.wantu .or. l .gt. nct) go to 70
!
!           Place the transformation in u for subsequent back
!           multiplication.
!
      do i = l, n
         u(i,l) = x(i,l)
      end do
70 continue
   if (l .gt. nrt) go to 150
!
!           Compute the l-TH row transformation and place the
!           l-TH super-diagonal in e(l).
!
      e(l) = dnrm2(p-l,e(lp1),1)
      if (e(l) .eq. 0.0d0) go to 80
         if (e(lp1) .ne. 0.0d0) e(l) = dsign(e(l),e(lp1))
         call dscal(p-l,1.0d0/e(l),e(lp1),1)
         e(lp1) = 1.0d0 + e(lp1)
80 continue
      e(l) = -e(l)
      if (lp1 .gt. n .or. e(l) .eq. 0.0d0) go to 120
!
!              Apply the transformation.
!
         do i = lp1, n
            work(i) = 0.0d0
         end do
         do 100 j = lp1, p
            call daxpy(n-l,e(j),x(lp1,j),1,work(lp1),1)
100 continue
         do j = lp1, p
            call daxpy(n-l,-e(j)/e(lp1),work(lp1),1,x(lp1,j),1)
         end do
120 continue
      if (.not.wantv) go to 140
!
!              Place the transformation in V for subsequent
!              back multiplication.
!
         do i = lp1, p
            v(i,l) = e(i)
         end do
140 continue
150 continue
160 continue
170 continue
!
!     Set up the final bidiagonal matrix of order M.
!
m = min0(p,n+1)
nctp1 = nct + 1
nrtp1 = nrt + 1
if (nct .lt. p) s(nctp1) = x(nctp1,nctp1)
if (n .lt. m) s(m) = 0.0d0
if (nrtp1 .lt. m) e(nrtp1) = x(nrtp1,m)
e(m) = 0.0d0
!
!     If required, generate u.
!
if (.not.wantu) go to 300
   if (ncu .lt. nctp1) go to 200
   do j = nctp1, ncu
      do i = 1, n
         u(i,j) = 0.0d0
      end do
      u(j,j) = 1.0d0
   end do
200 continue
   if (nct .lt. 1) go to 290
   do ll = 1, nct
      l = nct - ll + 1
      if (s(l) .eq. 0.0d0) go to 250
         lp1 = l + 1
         if (ncu .lt. lp1) go to 220
         do j = lp1, ncu
            t = -ddot(n-l+1,u(l,l),1,u(l,j),1)/u(l,l)
            call daxpy(n-l+1,t,u(l,l),1,u(l,j),1)
         end do
220 continue
         call dscal(n-l+1,-1.0d0,u(l,l),1)
         u(l,l) = 1.0d0 + u(l,l)
         lm1 = l - 1
         if (lm1 .lt. 1) go to 240
         do i = 1, lm1
            u(i,l) = 0.0d0
         end do
240 continue
      go to 270
250 continue
         do i = 1, n
            u(i,l) = 0.0d0
         end do
         u(l,l) = 1.0d0
270 continue
   end do
290 continue
300 continue
!
!     If it is required, generate V.
!
if (.not.wantv) go to 350
   do ll = 1, p
      l = p - ll + 1
      lp1 = l + 1
      if (l .gt. nrt) go to 320
      if (e(l) .eq. 0.0d0) go to 320
         do j = lp1, p
            t = -ddot(p-l,v(lp1,l),1,v(lp1,j),1)/v(lp1,l)
            call daxpy(p-l,t,v(lp1,l),1,v(lp1,j),1)
         end do
320 continue
      do i = 1, p
         v(i,l) = 0.0d0
      end do
      v(l,l) = 1.0d0
   end do
350 continue
!
!     Main iteration loop for the singular values.
!
mm = m
iter = 0
360 continue
!
!        Quit if all the singular values have been found.
!
!     ...Exit
   if (m .eq. 0) go to 620
!
!        If too many iterations have been performed, set
!        flag and return.
!
   if (iter .lt. maxit) go to 370
      info = m
!     ......Exit
      go to 620
370 continue
!
!        This section of the program inspects for
!        negligible elements in the s and e arrays.  On
!        completion the variables kase and l are set as follows.
!
!           kase = 1     IF s(M) AND e(l-1) ARE NEGLIGIBLE AND l.LT.M
!           kase = 2     IF s(l) IS NEGLIGIBLE AND l.LT.M
!           kase = 3     IF e(l-1) IS NEGLIGIBLE, l.LT.M, AND
!                        s(l), ..., s(M) are not negligible (QR step).
!           kase = 4     IF e(M-1) IS NEGLIGIBLE (CONVERGENCE).
!
   do ll = 1, m
      l = m - ll
!        ...Exit
      if (l .eq. 0) go to 400
      test = dabs(s(l)) + dabs(s(l+1))
      ztest = test + dabs(e(l))
      if (ztest .ne. test) go to 380
         e(l) = 0.0d0
!        ......Exit
         go to 400
380 continue
   end do
400 continue
   if (l .ne. m - 1) go to 410
      kase = 4
   go to 480
410 continue
      lp1 = l + 1
      mp1 = m + 1
      do lls = lp1, mp1
         ls = m - lls + lp1
!           ...Exit
         if (ls .eq. l) go to 440
         test = 0.0d0
         if (ls .ne. m) test = test + dabs(e(ls))
         if (ls .ne. l + 1) test = test + dabs(e(ls-1))
         ztest = test + dabs(s(ls))
         if (ztest .ne. test) go to 420
            s(ls) = 0.0d0
!           ......Exit
            go to 440
420 continue
      end do
440 continue
      if (ls .ne. l) go to 450
         kase = 3
      go to 470
450 continue
      if (ls .ne. m) go to 460
         kase = 1
      go to 470
460 continue
         kase = 2
         l = ls
470 continue
480 continue
   l = l + 1
!
!        Perform the task indicated by kase.
!
   go to (490,520,540,570), kase
!
!        Deflate negligible s(M).
!
490 continue
      mm1 = m - 1
      f = e(m-1)
      e(m-1) = 0.0d0
      do kk = l, mm1
         k = mm1 - kk + l
         t1 = s(k)
         call drotg(t1,f,cs,sn)
         s(k) = t1
         if (k .eq. l) go to 500
            f = -sn*e(k-1)
            e(k-1) = cs*e(k-1)
500 continue
         if (wantv) call drot(p,v(1,k),1,v(1,m),1,cs,sn)
      end do
   go to 610
!
!        Split at negligible s(l).
!
520 continue
      f = e(l-1)
      e(l-1) = 0.0d0
      do k = l, m
         t1 = s(k)
         call drotg(t1,f,cs,sn)
         s(k) = t1
         f = -sn*e(k)
         e(k) = cs*e(k)
         if (wantu) call drot(n,u(1,k),1,u(1,l-1),1,cs,sn)
      end do
   go to 610
!
!        Perform one QR step.
!
540 continue
!
!           Calculate the shift.
!
      scale = dmax1(dabs(s(m)),dabs(s(m-1)),dabs(e(m-1)), &
&dabs(s(l)),dabs(e(l)))
      sm = s(m)/scale
      smm1 = s(m-1)/scale
      emm1 = e(m-1)/scale
      sl = s(l)/scale
      el = e(l)/scale
      b = ((smm1 + sm)*(smm1 - sm) + emm1**2)/2.0d0
      c = (sm*emm1)**2
      shift = 0.0d0
      if (b .eq. 0.0d0 .and. c .eq. 0.0d0) go to 550
         shift = dsqrt(b**2+c)
         if (b .lt. 0.0d0) shift = -shift
         shift = c/(b + shift)
550 continue
      f = (sl + sm)*(sl - sm) - shift
      g = sl*el
!
!           Chase zeros.
!
      mm1 = m - 1
      do k = l, mm1
         call drotg(f,g,cs,sn)
         if (k .ne. l) e(k-1) = f
         f = cs*s(k) + sn*e(k)
         e(k) = cs*e(k) - sn*s(k)
         g = sn*s(k+1)
         s(k+1) = cs*s(k+1)
         if (wantv) call drot(p,v(1,k),1,v(1,k+1),1,cs,sn)
         call drotg(f,g,cs,sn)
         s(k) = f
         f = cs*e(k) + sn*s(k+1)
         s(k+1) = -sn*e(k) + cs*s(k+1)
         g = sn*e(k+1)
         e(k+1) = cs*e(k+1)
         if (wantu .and. k .lt. n) &
&call drot(n,u(1,k),1,u(1,k+1),1,cs,sn)
      end do
      e(m-1) = f
      iter = iter + 1
   go to 610
!
!        Convergence.
!
570 continue
!
!           Make the singular value  positive.
!
      if (s(l) .ge. 0.0d0) go to 580
         s(l) = -s(l)
         if (wantv) call dscal(p,-1.0d0,v(1,l),1)
580 continue
!
!           Order the singular value.
!
590 if (l .eq. mm) go to 600
!           ...Exit
         if (s(l) .ge. s(l+1)) go to 600
         t = s(l)
         s(l) = s(l+1)
         s(l+1) = t
         if (wantv .and. l .lt. p) &
&call dswap(p,v(1,l),1,v(1,l+1),1)
         if (wantu .and. l .lt. n) &
&call dswap(n,u(1,l),1,u(1,l+1),1)
         l = l + 1
      go to 590
600 continue
      iter = 0
      m = m - 1
610 continue
go to 360
620 continue
return
end subroutine dsvdc

subroutine csvdc(x,ldx,n,p,s,e,u,ldu,v,ldv,work,job,info)
implicit none
integer, intent(in) :: ldx, n, p, ldu, ldv, job
integer, intent(inout) :: info
complex, intent(inout) :: x(ldx,*), s(*), e(*), u(ldu,*), &
&v(ldv,*), work(*)
!
!
!     csvdc is a subroutine to reduce a complex NXP matrix x by
!     unitary transformations u and V to diagonal form.  The
!     diagonal elements s(i) are the singular values of x.  the
!     columns of u are the corresponding left singular vectors,
!     and the columns of V the right singular vectors.
!
!     On entry
!
!         x         COMPLEX(ldx,p), WHERE ldx.GE.n.
!                   x contains the matrix whose singular value
!                   decomposition is to be computed.  x is
!                   destroyed by csvdc.
!
!         ldx       INTEGER.
!                   ldx is the leading dimension of the array x.
!
!         n         INTEGER.
!                   n is the number of rows of the matrix x.
!
!         p         INTEGER.
!                   p is the number of columns of the matrix x.
!
!         ldu       INTEGER.
!                   ldu is the leading dimension of the array u
!                   (see below).
!
!         ldv       INTEGER.
!                   ldv is the leading dimension of the array V
!                   (see below).
!
!         WORK      COMPLEX(n).
!                   Work is a scratch array.
!
!         JOB       INTEGER.
!                   Job controls the computation of the singular
!                   vectors.  It has the decimal expansion AB
!                   with the following meaning
!
!                        A.EQ.0    DO NOT COMPUTE THE LEFT SINGULAR
!                                  vectors.
!                        A.EQ.1    RETURN THE n LEFT SINGULAR VECTORS
!                                  IN u.
!                        A.GE.2    RETURNS THE FIRST min(n,p)
!                                  left singular vectors in u.
!                        b.EQ.0    DO NOT COMPUTE THE RIGHT SINGULAR
!                                  vectors.
!                        b.EQ.1    RETURN THE RIGHT SINGULAR VECTORS
!                                  IN V.
!
!     On return
!
!         s         COMPLEX(MM), WHERE MM=min(n+1,p).
!                   The first min(n,p) entries of s contain the
!                   singular values of x arranged in descending
!                   order of magnitude.
!
!         e         COMPLEX(p).
!                   e ordinarily contains zeros.  However see the
!                   discussion of info for exceptions.
!
!         u         COMPLEX(ldu,k), WHERE ldu.GE.n.  IF JOBA.EQ.1 THEN
!                                   k.EQ.n, IF JOBA.GE.2 THEN
!                                   k.EQ.min(n,p).
!                   u contains the matrix of left singular vectors.
!                   u IS NOT REFERENCED IF JOBA.EQ.0.  IF n.LE.p
!                   OR IF JOBA.GT.2, THEN u MAY BE IDENTIFIED WITH x
!                   in the subroutine CALL.
!
!         V         COMPLEX(ldv,p), WHERE ldv.GE.p.
!                   V contains the matrix of right singular vectors.
!                   V IS NOT REFERENCED IF JOBB.EQ.0.  IF p.LE.n,
!                   then V may be identified whth x in the
!                   subroutine CALL.
!
!         INFO      INTEGER.
!                   The singular values (and their corresponding
!                   singular vectors) s(info+1),s(info+2),...,s(M)
!                   ARE CORRECT (HERE M=min(n,p)).  THUS IF
!                   info.EQ.0, ALL THE SINGULAR VALUES AND THEIR
!                   vectors are correct.  In any event, the matrix
!                   b = ctrans(u)*x*V IS THE BIDIAGONAL MATRIX
!                   with the elements of s on its diagonal and the
!                   elements of e on its super-diagonal (ctrans(u)
!                   is the conjugate-transpose of u).  Thus the
!                   singular values of x and b are the same.
!
!     LINPACK. This version dated 03/19/79 .
!     G.W. Stewart, university of maryland, Argonne National Lab.
!
!     csvdc uses the following functions and subprograms.
!
!     external csrot
!     BLAS caxpy,cdotc,cscal,cswap,scnrm2,srotg
!     Fortran abs,aimag,AMAX1,cabs,cmplx
!     Fortran CONJG,MAX0,MIN0,mod,real,sqrt
!
!     Internal variables
!
integer :: i, iter, j, jobu, k, kase, kk, l, ll, lls, lm1, lp1, &
&ls, lu, m, maxit, mm, mm1, mp1, nct, nctp1, ncu, nrt, nrtp1
complex :: cdotc, t, r
real :: b, c, cs, el, emm1, f, g, scnrm2, scale, shift, sl, sm, &
&sn, smm1, t1, test, ztest
logical :: wantu, wantv
!
complex :: csign, zdum, zdum1, zdum2
real :: cabs1
cabs1(zdum) = abs(real(zdum)) + abs(aimag(zdum))
csign(zdum1,zdum2) = cabs(zdum1)*(zdum2/cabs(zdum2))
!
!     Set the maximum number of iterations.
!
maxit = 30
!
!     Determine what is to be computed.
!
wantu = .false.
wantv = .false.
jobu = mod(job,100)/10
ncu = n
if (jobu .gt. 1) ncu = min0(n,p)
if (jobu .ne. 0) wantu = .true.
if (mod(job,10) .ne. 0) wantv = .true.
!
!     Reduce x to bidiagonal form, storing the diagonal elements
!     in s and the super-diagonal elements in e.
!
info = 0
nct = min0(n-1,p)
nrt = max0(0,min0(p-2,n))
lu = max0(nct,nrt)
if (lu .lt. 1) go to 170
do 160 l = 1, lu
   lp1 = l + 1
   if (l .gt. nct) go to 20
!
!           Compute the transformation for the l-TH column and
!           place the l-TH diagonal in s(l).
!
      s(l) = cmplx(scnrm2(n-l+1,x(l,l),1),0.0e0)
      if (cabs1(s(l)) .eq. 0.0e0) go to 10
         if (cabs1(x(l,l)) .ne. 0.0e0) s(l) = csign(s(l),x(l,l))
         call cscal(n-l+1,1.0e0/s(l),x(l,l),1)
         x(l,l) = (1.0e0,0.0e0) + x(l,l)
10 continue
      s(l) = -s(l)
20 continue
   if (p .lt. lp1) go to 50
   do 40 j = lp1, p
      if (l .gt. nct) go to 30
      if (cabs1(s(l)) .eq. 0.0e0) go to 30
!
!              Apply the transformation.
!
         t = -cdotc(n-l+1,x(l,l),1,x(l,j),1)/x(l,l)
         call caxpy(n-l+1,t,x(l,l),1,x(l,j),1)
30 continue
!
!           Place the l-TH row of x into  e for the
!           subsequent calculation of the row transformation.
!
      e(j) = conjg(x(l,j))
40 continue
50 continue
   if (.not.wantu .or. l .gt. nct) go to 70
!
!           Place the transformation in u for subsequent back
!           multiplication.
!
      do i = l, n
         u(i,l) = x(i,l)
      end do
70 continue
   if (l .gt. nrt) go to 150
!
!           Compute the l-TH row transformation and place the
!           l-TH super-diagonal in e(l).
!
      e(l) = cmplx(scnrm2(p-l,e(lp1),1),0.0e0)
      if (cabs1(e(l)) .eq. 0.0e0) go to 80
         if (cabs1(e(lp1)) .ne. 0.0e0) e(l) = csign(e(l),e(lp1))
         call cscal(p-l,1.0e0/e(l),e(lp1),1)
         e(lp1) = (1.0e0,0.0e0) + e(lp1)
80 continue
      e(l) = -conjg(e(l))
      if (lp1 .gt. n .or. cabs1(e(l)) .eq. 0.0e0) go to 120
!
!              Apply the transformation.
!
         do i = lp1, n
            work(i) = (0.0e0,0.0e0)
         end do
         do 100 j = lp1, p
            call caxpy(n-l,e(j),x(lp1,j),1,work(lp1),1)
100 continue
         do j = lp1, p
            call caxpy(n-l,conjg(-e(j)/e(lp1)),work(lp1),1, &
&x(lp1,j),1)
         end do
120 continue
      if (.not.wantv) go to 140
!
!              Place the transformation in V for subsequent
!              back multiplication.
!
         do i = lp1, p
            v(i,l) = e(i)
         end do
140 continue
150 continue
160 continue
170 continue
!
!     Set up the final bidiagonal matrix of order M.
!
m = min0(p,n+1)
nctp1 = nct + 1
nrtp1 = nrt + 1
if (nct .lt. p) s(nctp1) = x(nctp1,nctp1)
if (n .lt. m) s(m) = (0.0e0,0.0e0)
if (nrtp1 .lt. m) e(nrtp1) = x(nrtp1,m)
e(m) = (0.0e0,0.0e0)
!
!     If required, generate u.
!
if (.not.wantu) go to 300
   if (ncu .lt. nctp1) go to 200
   do j = nctp1, ncu
      do i = 1, n
         u(i,j) = (0.0e0,0.0e0)
      end do
      u(j,j) = (1.0e0,0.0e0)
   end do
200 continue
   if (nct .lt. 1) go to 290
   do ll = 1, nct
      l = nct - ll + 1
      if (cabs1(s(l)) .eq. 0.0e0) go to 250
         lp1 = l + 1
         if (ncu .lt. lp1) go to 220
         do j = lp1, ncu
            t = -cdotc(n-l+1,u(l,l),1,u(l,j),1)/u(l,l)
            call caxpy(n-l+1,t,u(l,l),1,u(l,j),1)
         end do
220 continue
         call cscal(n-l+1,(-1.0e0,0.0e0),u(l,l),1)
         u(l,l) = (1.0e0,0.0e0) + u(l,l)
         lm1 = l - 1
         if (lm1 .lt. 1) go to 240
         do i = 1, lm1
            u(i,l) = (0.0e0,0.0e0)
         end do
240 continue
      go to 270
250 continue
         do i = 1, n
            u(i,l) = (0.0e0,0.0e0)
         end do
         u(l,l) = (1.0e0,0.0e0)
270 continue
   end do
290 continue
300 continue
!
!     If it is required, generate V.
!
if (.not.wantv) go to 350
   do ll = 1, p
      l = p - ll + 1
      lp1 = l + 1
      if (l .gt. nrt) go to 320
      if (cabs1(e(l)) .eq. 0.0e0) go to 320
         do j = lp1, p
            t = -cdotc(p-l,v(lp1,l),1,v(lp1,j),1)/v(lp1,l)
            call caxpy(p-l,t,v(lp1,l),1,v(lp1,j),1)
         end do
320 continue
      do i = 1, p
         v(i,l) = (0.0e0,0.0e0)
      end do
      v(l,l) = (1.0e0,0.0e0)
   end do
350 continue
!
!     Transform s and e so that they are real.
!
do i = 1, m
   if (cabs1(s(i)) .eq. 0.0e0) go to 360
      t = cmplx(cabs(s(i)),0.0e0)
      r = s(i)/t
      s(i) = t
      if (i .lt. m) e(i) = e(i)/r
      if (wantu) call cscal(n,r,u(1,i),1)
360 continue
!     ...Exit
   if (i .eq. m) go to 390
   if (cabs1(e(i)) .eq. 0.0e0) go to 370
      t = cmplx(cabs(e(i)),0.0e0)
      r = t/e(i)
      e(i) = t
      s(i+1) = s(i+1)*r
      if (wantv) call cscal(p,r,v(1,i+1),1)
370 continue
end do
390 continue
!
!     Main iteration loop for the singular values.
!
mm = m
iter = 0
400 continue
!
!        Quit if all the singular values have been found.
!
!     ...Exit
   if (m .eq. 0) go to 660
!
!        If too many iterations have been performed, set
!        flag and return.
!
   if (iter .lt. maxit) go to 410
      info = m
!     ......Exit
      go to 660
410 continue
!
!        This section of the program inspects for
!        negligible elements in the s and e arrays.  On
!        completion the variables kase and l are set as follows.
!
!           kase = 1     IF s(M) AND e(l-1) ARE NEGLIGIBLE AND l.LT.M
!           kase = 2     IF s(l) IS NEGLIGIBLE AND l.LT.M
!           kase = 3     IF e(l-1) IS NEGLIGIBLE, l.LT.M, AND
!                        s(l), ..., s(M) are not negligible (QR step).
!           kase = 4     IF e(M-1) IS NEGLIGIBLE (CONVERGENCE).
!
   do ll = 1, m
      l = m - ll
!        ...Exit
      if (l .eq. 0) go to 440
      test = cabs(s(l)) + cabs(s(l+1))
      ztest = test + cabs(e(l))
      if (ztest .ne. test) go to 420
         e(l) = (0.0e0,0.0e0)
!        ......Exit
         go to 440
420 continue
   end do
440 continue
   if (l .ne. m - 1) go to 450
      kase = 4
   go to 520
450 continue
      lp1 = l + 1
      mp1 = m + 1
      do lls = lp1, mp1
         ls = m - lls + lp1
!           ...Exit
         if (ls .eq. l) go to 480
         test = 0.0e0
         if (ls .ne. m) test = test + cabs(e(ls))
         if (ls .ne. l + 1) test = test + cabs(e(ls-1))
         ztest = test + cabs(s(ls))
         if (ztest .ne. test) go to 460
            s(ls) = (0.0e0,0.0e0)
!           ......Exit
            go to 480
460 continue
      end do
480 continue
      if (ls .ne. l) go to 490
         kase = 3
      go to 510
490 continue
      if (ls .ne. m) go to 500
         kase = 1
      go to 510
500 continue
         kase = 2
         l = ls
510 continue
520 continue
   l = l + 1
!
!        Perform the task indicated by kase.
!
   go to (530, 560, 580, 610), kase
!
!        Deflate negligible s(M).
!
530 continue
      mm1 = m - 1
      f = real(e(m-1))
      e(m-1) = (0.0e0,0.0e0)
      do kk = l, mm1
         k = mm1 - kk + l
         t1 = real(s(k))
         call srotg(t1,f,cs,sn)
         s(k) = cmplx(t1,0.0e0)
         if (k .eq. l) go to 540
            f = -sn*real(e(k-1))
            e(k-1) = cs*e(k-1)
540 continue
         if (wantv) call csrot(p,v(1,k),1,v(1,m),1,cs,sn)
      end do
   go to 650
!
!        Split at negligible s(l).
!
560 continue
      f = real(e(l-1))
      e(l-1) = (0.0e0,0.0e0)
      do k = l, m
         t1 = real(s(k))
         call srotg(t1,f,cs,sn)
         s(k) = cmplx(t1,0.0e0)
         f = -sn*real(e(k))
         e(k) = cs*e(k)
         if (wantu) call csrot(n,u(1,k),1,u(1,l-1),1,cs,sn)
      end do
   go to 650
!
!        Perform one QR step.
!
580 continue
!
!           Calculate the shift.
!
      scale = amax1(cabs(s(m)),cabs(s(m-1)),cabs(e(m-1)), &
&cabs(s(l)),cabs(e(l)))
      sm = real(s(m))/scale
      smm1 = real(s(m-1))/scale
      emm1 = real(e(m-1))/scale
      sl = real(s(l))/scale
      el = real(e(l))/scale
      b = ((smm1 + sm)*(smm1 - sm) + emm1**2)/2.0e0
      c = (sm*emm1)**2
      shift = 0.0e0
      if (b .eq. 0.0e0 .and. c .eq. 0.0e0) go to 590
         shift = sqrt(b**2+c)
         if (b .lt. 0.0e0) shift = -shift
         shift = c/(b + shift)
590 continue
      f = (sl + sm)*(sl - sm) - shift
      g = sl*el
!
!           Chase zeros.
!
      mm1 = m - 1
      do k = l, mm1
         call srotg(f,g,cs,sn)
         if (k .ne. l) e(k-1) = cmplx(f,0.0e0)
         f = cs*real(s(k)) + sn*real(e(k))
         e(k) = cs*e(k) - sn*s(k)
         g = sn*real(s(k+1))
         s(k+1) = cs*s(k+1)
         if (wantv) call csrot(p,v(1,k),1,v(1,k+1),1,cs,sn)
         call srotg(f,g,cs,sn)
         s(k) = cmplx(f,0.0e0)
         f = cs*real(e(k)) + sn*real(s(k+1))
         s(k+1) = -sn*e(k) + cs*s(k+1)
         g = sn*real(e(k+1))
         e(k+1) = cs*e(k+1)
         if (wantu .and. k .lt. n) &
&call csrot(n,u(1,k),1,u(1,k+1),1,cs,sn)
      end do
      e(m-1) = cmplx(f,0.0e0)
      iter = iter + 1
   go to 650
!
!        Convergence.
!
610 continue
!
!           Make the singular value  positive
!
      if (real(s(l)) .ge. 0.0e0) go to 620
         s(l) = -s(l)
         if (wantv) call cscal(p,(-1.0e0,0.0e0),v(1,l),1)
620 continue
!
!           Order the singular value.
!
630 if (l .eq. mm) go to 640
!           ...Exit
         if (real(s(l)) .ge. real(s(l+1))) go to 640
         t = s(l)
         s(l) = s(l+1)
         s(l+1) = t
         if (wantv .and. l .lt. p) &
&call cswap(p,v(1,l),1,v(1,l+1),1)
         if (wantu .and. l .lt. n) &
&call cswap(n,u(1,l),1,u(1,l+1),1)
         l = l + 1
      go to 630
640 continue
      iter = 0
      m = m - 1
650 continue
go to 400
660 continue
return
end subroutine csvdc

function det(a,ka,n,x)
implicit none
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n)
real, intent(in) :: x
integer :: i, j, k, kp1, l, nm1
real :: c, pivot, s
real :: det
!     -------------------
!     Evaluation of the determinant of a-xi where A is an NXN matrix,
!     x is a scalar, and i is the NXN identity matrix.
!     -------------------
!     ka is the row dimension of A in the calling program. It is
!     assumed that ka is greater than or equal to n.
!     -------------------
if (n .ge. 2) go to 10
det = a(1,1)-x
return
!
!              Replace A with a-xi
!
10 if (x .eq. 0.0) go to 20
do 11 k = 1,n
11 a(k,k) = a(k,k)-x
!
!                Initialization
!
20 det = 1.0
nm1 = n-1
do k=1,nm1
kp1 = k+1
!
!       Search for the k-TH pivot element
!
s = abs(a(k,k))
l = k
do 30 i = kp1,n
c = abs(a(i,k))
if (s .ge. c) go to 30
s = c
l = i
30 continue
pivot = a(l,k)
!
!         Update the calculation of det
!
det = det*pivot
if (det .eq. 0.0) return
if (k .eq. l) go to 50
det = -det
!
!          Interchanging rows k and l
!
do 40 j = k,n
c = a(k,j)
a(k,j) = a(l,j)
40 a(l,j) = c
!
!        Reduction of the non-pivot rows
!
50 do 51 i = kp1,n
c = a(i,k)/pivot
do 51 j = kp1,n
51 a(i,j) = a(i,j)-c*a(k,j)
end do
!
!         Final determinant calculation
!
det = det*a(n,n)
return
end function det

double precision function dpdet(a,ka,n,x)
implicit none
integer, intent(in) :: ka, n
integer :: i, j, k, kp1, l, nm1
!     -------------------
!     Evaluation of the determinant of a-xi where A is an NXN matrix,
!     x is a scalar, and i is the NXN identity matrix.
!     -------------------
!     ka is the row dimension of A in the calling program. It is
!     assumed that ka is greater than or equal to n.
!     -------------------
double precision, intent(inout) :: a(ka,n)
double precision, intent(in) :: x
double precision :: pivot, s, c
if (n .ge. 2) go to 10
dpdet = a(1,1) - x
return
!
!              Replace A with a-xi
!
10 if (x .eq. 0.d0) go to 20
do 11 k = 1,n
11 a(k,k) = a(k,k) - x
!
!                Initialization
!
20 dpdet = 1.d0
nm1 = n - 1
do k=1,nm1
kp1 = k + 1
!
!       Search for the k-TH pivot element
!
s = dabs(a(k,k))
l = k
do 30 i = kp1,n
c = dabs(a(i,k))
if (s .ge. c) go to 30
s = c
l = i
30 continue
pivot = a(l,k)
!
!         Update the calculation of det
!
dpdet = dpdet*pivot
if (dpdet .eq. 0.d0) return
if (k .eq. l) go to 50
dpdet = -dpdet
!
!          Interchanging rows k and l
!
do 40 j = k,n
c = a(k,j)
a(k,j) = a(l,j)
40 a(l,j) = c
!
!        Reduction of the non-pivot rows
!
50 do 51 i = kp1,n
c = a(i,k)/pivot
do 51 j = kp1,n
51 a(i,j) = a(i,j) - c*a(k,j)
end do
!
!         Final determinant calculation
!
dpdet = dpdet*a(n,n)
return
end function dpdet

complex function cdet(a,ka,n,x)
implicit none
integer, intent(in) :: ka, n
integer :: i, j, k, kp1, l, nm1
!     -------------------
!     Evaluation of the determinant of a-xi where A is an NXN matrix,
!     x is a scalar, and i is the NXN identity matrix.
!     -------------------
!     ka is the row dimension of A in the calling program. It is
!     assumed that ka is greater than or equal to n.
!     -------------------
complex, intent(inout) :: a(ka,n)
complex, intent(in) :: x
complex :: pivot, t, zero
real :: s, c
data zero/(0.0,0.0)/
!
if (n .ge. 2) go to 10
cdet = a(1,1)-x
return
!
!              Replace A with a-xi
!
10 if (x .eq. zero) go to 20
do 11 k = 1,n
11 a(k,k) = a(k,k)-x
!
!                Initialization
!
20 cdet = (1.0,0.0)
nm1 = n-1
do k=1,nm1
kp1 = k+1
!
!       Search for the k-TH pivot element
!
s = abs(real(a(k,k))) + abs(aimag(a(k,k)))
l = k
do 30 i = kp1,n
c = abs(real(a(i,k))) + abs(aimag(a(i,k)))
if (s .ge. c) go to 30
s = c
l = i
30 continue
pivot = a(l,k)
!
!         Update the calculation of cdet
!
cdet = cdet*pivot
if (cdet .eq. zero) return
if (k .eq. l) go to 50
cdet = -cdet
!
!          Interchanging rows k and l
!
do 40 j = k,n
t = a(k,j)
a(k,j) = a(l,j)
40 a(l,j) = t
!
!        Reduction of the non-pivot rows
!
50 do 51 i = kp1,n
t = a(i,k)/pivot
do 51 j = kp1,n
51 a(i,j) = a(i,j)-t*a(k,j)
end do
!
!         Final determinant calculation
!
cdet = cdet*a(n,n)
return
end function cdet

subroutine abslv (mo,m,n,a,na,b,nb,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc
integer :: iu, iv, iw
real, intent(inout) :: a(na,m), b(nb,n), c(nc,n), wk(*)
! ----------------------------------------------------------------------
!     abslv SOLVES THE REAL MATRIX EQUATION AX + XB = c. A IS REDUCED
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL mo = 0 AND
!     we have the following setup.
!
!        a(na,m)
!           A is a matrix of order m. it is assumed that
!           na .GE. m .GE. 1.
!
!        b(nb,n)
!           b is a matrix of order n. it is assumed that
!           nb .GE. n .GE. 1.
!
!        c(nc,n)
!           c is a matrix having m rows and n columns.
!           IT IS ASSUMED THAT nc .GE. m.
!
!        wk(---)
!           wk IS AN ARRAY OF DIMENSION m**2  + n**2 + 2K
!           WHERE K = max(m,n). wk IS A GENERAL STORAGE
!           area for the routine.
!
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!
!        ierr =  0  THE SOLUTION WAS OBTAINED AND STORED IN c.
!        ierr =  1  THE EQUATIONS ARE INCONSISTENT FOR A AND b.
!                   The problem cannot be solved.
!        ierr = -1  A COULD NOT BE REDUCED TO LOWER SCHUR FORM.
!                   The problem cannot be solved.
!        ierr = -2  b COULD NOT BE REDUCED TO UPPER SCHUR FORM.
!                   The problem cannot be solved.
!
!     WHEN ierr = 0, a CONTAINS THE LOWER SCHUR FORM OF THE MATRIX a,
!     b contains the upper Schur form of the matrix b, and wk contains
!     the orthonal matrices involved in the Schur decompositions of
!     A and b. this information can be reused to solve a new set of
!     EQUATIONS AX + XB = c WITHOUT HAVING TO REDECOMPOSE A AND b.
!     The following options are available...
!
!        mo = 1      NEW MATRICES A AND c ARE GIVEN. THE DATA FOR b
!                    is reused in solving the new set of equations.
!
!        mo = 2      NEW MATRICES b AND c ARE GIVEN. THE DATA FOR A
!                    is reused in solving the new set of equations.
!
!     mo .NE. 0,1,2  A NEW MATRIX c IS GIVEN. THE DATA FOR A AND b
!                    is reused in solving the new set of equations.
!
!     When abslv is recalled, it is assumed that m, n, and wk have
!     not been modified.
! ----------------------------------------------------------------------
!     This subroutine is a modification by
!        Alfred H. Morris, Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!     of the subroutine axpxb written by
!        R.H. Bartels and G.W.Stewart
!        University of Texas at Austin.
!
!     Reference. Bartels, R.H. and Stewart, G.W., Algorithm 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = c, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iu = 1
iv = m*m + 1
iw = n*n + iv
call abslv1 (mo,m,n,a,na,wk(iu),m,b,nb,wk(iv),n, &
&c,nc,wk(iw),ierr)
return
end subroutine abslv

subroutine abslv1 (mo,m,n,a,na,u,nu,b,nb,v,nv,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc, nu, nv
integer :: i, j, k
! ----------------------------------------------------------------------
!     abslv1 SOLVES THE REAL MATRIX EQUATION AX + XB = c. A IS REDUCED
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
real, intent(inout) :: a(na,m), b(nb,n), c(nc,n)
real, intent(inout) :: u(nu,m), v(nv,n)
real :: temp
real, intent(inout) :: wk(*)
!
!     If required, reduce A to lower real Schur form
!
if (mo .ne. 0 .and. mo .ne. 1) go to 35
do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
call orthes (na,m,1,m,a,wk)
call ortrn1 (m,1,m,a,na,u,nu,wk)
!
if (m .eq. 1) go to 20
call schur (m,1,m,a,na,u,nu,wk(1),wk(m+1),ierr)
if (ierr .ne. 0) go to 200
!
20 do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
!
!     If required, reduce b to upper real Schur form
!
35 if (mo .ne. 0 .and. mo .ne. 2) go to 45
call orthes (nb,n,1,n,b,wk)
call ortrn1 (n,1,n,b,nb,v,nv,wk)
!
if (n .eq. 1) go to 45
call schur (n,1,n,b,nb,v,nv,wk(1),wk(n+1),ierr)
if (ierr .ne. 0) go to 210
!
!     Transform c
!
45 do j = 1,n
   do i = 1,m
      wk(i) = 0.0
      do k = 1,m
         wk(i) = wk(i) + u(k,i)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
!
do i = 1,m
   do j = 1,n
      wk(j) = 0.0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(k,j)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
!
!     Solve the transformed system
!
call shrslv (a,b,c,m,n,na,nb,nc,ierr)
if (ierr .ne. 0) go to 220
!
!     Transform c back to the solution
!
do j = 1,n
   do i = 1,m
      wk(i) = 0.0
      do k = 1,m
         wk(i) = wk(i) + u(i,k)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
!
do i = 1,m
   do j = 1,n
      wk(j) = 0.0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(j,k)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
return
!
!     Error return
!
200 ierr = -1
return
210 ierr = -2
return
220 ierr = 1
return
end subroutine abslv1

subroutine schur (n, low, igh, h, nh, z, nz, wr, wi, ierr)
implicit none
integer :: ip1
! ----------------------------------------------------------------------
!     It is assumed that h is an upper Hessenberg matrix. Schur
!     obtains an orthogonal matrix q for which TRANSPOSE(q)*h*q
!     is in Schur form. The eigenvalues of h are also computed.
!
!     On input-
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          SET low=1, igh=n, (balanc IS AN EISPACK SUBROUTINE).
!
!        h contains the upper Hessenberg matrix,
!
!        nh is the first dimension of h,
!
!        z contains a matrix of order n,
!
!        nz is the first dimension of z.
!
!     On output-
!
!        h contains the transformed matrix in upper Schur form,
!
!        z contains the matrix z*q where q is the orthogonal
!          matrix which reduces h to upper Schur form,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n.
!
!        ierr is set to
!          0          FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
! -----------------
!     Written by jack dongarra
!          Argonne National Laboratory
!          may 1961
!     modified by A.H. Morris (NSWC)
! ----------------------------------------------------------------------
!     This subroutine is a modification of the EISPACK subroutine
!     hqr2,  which is based on the Algol procedure hqr by peters
!     and Wilkinson, NUM. Math. 16 (1970), PP.181-204.
! ----------------------------------------------------------------------
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ll, mm, na
integer, intent(in) :: nh, nz, igh
integer :: its
integer, intent(in) :: low
integer :: mp2, enm2
integer, intent(out) :: ierr
real, intent(inout) :: h(nh,n), wr(n), wi(n), z(nz,n)
real :: p, q, r, s, t, w, x, y, zz, norm, s1, s2
logical :: notlas
!     real sqrt, abs
!     integer min0
!
ierr = 0
norm = 0.0
k = 1
!     ********** STORE ROOTS ISOLATED BY balanc
!                AND COMPUTE MATRIX norm **********
do 20 i = 1,n
!
  do 10 j = k,n
    norm = norm + abs(h(i,j))
10 continue
!
  k = i
  if (i .ge. low .and. i .le. igh) go to 20
  wr(i) = h(i,i)
  wi(i) = 0.0
20 continue
!
en = igh
t = 0.0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
30 if (en .lt. low) go to 300
its = 0
na = en - 1
enm2 = na - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
40 do ll = low,en
  l = en + low - ll
  if (l .eq. low) go to 60
  s = abs(h(l-1,l-1)) + abs(h(l,l))
  if (s .eq. 0.0) s = norm
  s1 = s
  s2 = s1 + abs(h(l,l-1))
  if (s1 .eq. s2) go to 60
end do
!     ********** FORM SHIFT **********
60 x = h(en,en)
if (l .eq. en) go to 220
y = h(na,na)
w = h(en,na)*h(na,en)
if (l .eq.na) go to 230
if (its .eq. 30) go to 290
if (its .ne. 10 .and. its .ne. 20) go to 80
!     ********** FORM EXCEPTIONAL SHIFT **********
t = t + x
!
do i = low,en
  h(i,i) = h(i,i) - x
end do
!
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75*s
y = x
w = -0.4375*s*s
80 its = its + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l,enm2
  m = enm2 + l - mm
  zz = h(m,m)
  r = x - zz
  s = y - zz
  p = (r*s-w)/h(m+1,m) + h(m,m+1)
  q = h(m+1,m+1) - zz - r - s
  r = h(m+2,m+1)
  s = abs(p) + abs(q) + abs(r)
  p = p/s
  q = q/s
  r = r/s
  if (m .eq. l) go to 100
  s1 = abs(p)*(abs(h(m-1,m-1))+abs(zz)+abs(h(m+1,m+1)))
  s2 = s1 + abs(h(m,m-1))*(abs(q) + abs(r))
  if (s1 .eq. s2) go to 100
end do
!
100 mp2 = m + 2
!
do 110 i = mp2,en
  h(i,i-2) = 0.0
  if (i .eq. mp2) go to 110
  h(i,i-3) = 0.0
110 continue
!     ********** DOUBLE QR STEP INVOLVING ROWS l TO en AND
!                COLUMNS m TO en **********
do 210 k = m,na
  notlas = k.ne.na
  if (k .eq. m) go to 120
  p = h(k,k-1)
  q = h(k+1,k-1)
  r = 0.0
  if (notlas) r = h(k+2,k-1)
  x = abs(p) + abs(q) + abs(r)
  if (x .eq. 0.0) go to 210
  p = p/x
  q = q/x
  r = r/x
120 s = sqrt(p*p + q*q + r*r)
  if (p .lt. 0.0) s = -s
  if (k .eq. m) go to 130
  h(k,k-1) = -s*x
  go to 140
130 if (l .ne. m) h(k,k-1) = -h(k,k-1)
140 p = p + s
  x = p/s
  y = q/s
  zz = r/s
  q = q/p
  r = r/p
!     ********** ROW MODIFICATION **********
  do j = k,n
    p = h(k,j) + q*h(k+1,j)
    if (.not.notlas) go to 150
    p = p + r*h(k+2,j)
    h(k+2,j) = h(k+2,j) - p*zz
150 h(k+1,j) = h(k+1,j) - p*y
    h(k,j) = h(k,j) - p*x
  end do
!
  j = min0(en,k+3)
!     ********** COLUMN MODIFICATION **********
  do i = 1,j
    p = x*h(i,k) + y*h(i,k+1)
    if (.not.notlas) go to 170
    p = p + zz*h(i,k+2)
    h(i,k+2) = h(i,k+2) - p*r
170 h(i,k+1) = h(i,k+1) - p*q
    h(i,k) = h(i,k) - p
  end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
  do i = low,igh
    p = x*z(i,k) + y*z(i,k+1)
    if (.not.notlas) go to 190
    p = p + zz*z(i,k+2)
    z(i,k+2) = z(i,k+2) - p*r
190 z(i,k+1) = z(i,k+1) - p*q
    z(i,k) = z(i,k) - p
  end do
!
210 continue
!
go to 40
!     ********** ONE ROOT FOUND **********
220 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.0
en = na
go to 30
!     ********** TWO ROOTS FOUND **********
230 p = (y - x)/2.0
q = p*p + w
zz = sqrt(abs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q .lt. 0.0) go to 270
!     ********** REAL PAIR **********
if (p .lt. 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz .ne. 0.0) wr(en) = x - w/zz
wi(na) = 0.0
wi(en) = 0.0
x = h(en,na)
s = abs(x) + abs(zz)
p = x/s
q = zz/s
r = sqrt(p*p + q*q)
p = p/r
q = q/r
!     ********** ROW MODIFICATION **********
do j = na,n
  zz = h(na,j)
  h(na,j) = q*zz + p*h(en,j)
  h(en,j) = q*h(en,j) - p*zz
end do
!     ********** COLUMN MODIFICATION **********
do i = 1,en
  zz = h(i,na)
  h(i,na) = q*zz + p*h(i,en)
  h(i,en) = q*h(i,en) - p*zz
end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
do i = low,igh
  zz = z(i,na)
  z(i,na) = q*zz + p*z(i,en)
  z(i,en) = q*z(i,en) - p*zz
end do
!
go to 280
!     ********** COMPLEX PAIR **********
270 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
280 en = enm2
go to 30
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
290 ierr = en
return
300 do 320 i = 1,n
  ip1 = i + 1
  if (abs(wi(i)) .ne. 0.0) ip1 = ip1 + 1
  if (ip1 .gt. n) go to 320
  do j = ip1,n
    h(j,i) = 0.0
  end do
320 continue
return
end subroutine schur

subroutine shrslv (a,b,c,m,n,na,nb,nc,ierr)
implicit none
!     ------------------------------------------------------------------
!     shrslv SOLVES THE MATRIX EQUATION AX + XB = c WHERE
!     A is in lower Schur form and b in upper Schur form.
!     ------------------------------------------------------------------
integer, intent(in) :: m, n, na, nb, nc
integer, intent(inout) :: ierr
real, intent(in) :: a(na,m), b(nb,n)
real, intent(inout) :: c(nc,n)
real :: sum, p(4), t(4,4)
integer :: dk, dl, i, ib, j, ja, k, km1, kk, l, lm1, ll
!
l = 1
10 lm1 = l - 1
   dl = 1
   if (l .eq. n) go to 15
   if (b(l+1,l) .ne. 0.0) dl = 2
15 ll = l + dl - 1
   if (l .eq. 1) go to 30
!
   do j = l,ll
      do 21 i = 1,m
      sum = c(i,j)
         do 20 ib = 1,lm1
20 sum = sum - c(i,ib)*b(ib,j)
21 c(i,j) = sum
   end do
!
30 k = 1
40 km1 = k - 1
      dk = 1
      if (k .eq. m) go to 45
      if (a(k,k+1) .ne. 0.0) dk = 2
45 kk = k + dk - 1
      if (k .eq. 1) go to 60
!
      do i = k,kk
         do 51 j = l,ll
         sum = c(i,j)
            do 50 ja = 1,km1
50 sum = sum - a(i,ja)*c(ja,j)
51 c(i,j) = sum
      end do
!
60 if (dl .eq. 2) go to 80
      if (dk .eq. 2) go to 70
      t(1,1) = a(k,k) + b(l,l)
      if (t(1,1) .eq. 0.0) go to 200
      c(k,l) = c(k,l)/t(1,1)
      ierr = 0
      go to 100
!
70 t(1,1) = a(k,k) + b(l,l)
      t(1,2) = a(k,kk)
      t(2,1) = a(kk,k)
      t(2,2) = a(kk,kk) + b(l,l)
      p(1) = c(k,l)
      p(2) = c(kk,l)
      call slv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      go to 100
!
80 if (dk .eq. 2) go to 90
      t(1,1) = a(k,k) + b(l,l)
      t(1,2) = b(ll,l)
      t(2,1) = b(l,ll)
      t(2,2) = a(k,k) + b(ll,ll)
      p(1) = c(k,l)
      p(2) = c(k,ll)
      call slv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(k,ll) = p(2)
      go to 100
!
90 t(1,1) = a(k,k) + b(l,l)
      t(1,2) = a(k,kk)
      t(1,3) = b(ll,l)
      t(1,4) = 0.0
      t(2,1) = a(kk,k)
      t(2,2) = a(kk,kk) + b(l,l)
      t(2,3) = 0.0
      t(2,4) = t(1,3)
      t(3,1) = b(l,ll)
      t(3,2) = 0.0
      t(3,3) = a(k,k) + b(ll,ll)
      t(3,4) = t(1,2)
      t(4,1) = 0.0
      t(4,2) = t(3,1)
      t(4,3) = t(2,1)
      t(4,4) = a(kk,kk) + b(ll,ll)
      p(1) = c(k,l)
      p(2) = c(kk,l)
      p(3) = c(k,ll)
      p(4) = c(kk,ll)
      call slv (4, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      c(k,ll) = p(3)
      c(kk,ll) = p(4)
!
100 k = k + dk
   if (k .le. m) go to 40
l = l + dl
if (l .le. n) go to 10
return
!
!     Error return
!
200 ierr = 1
return
end subroutine shrslv

subroutine dabslv (mo,m,n,a,na,b,nb,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc
integer :: iu, iv, iw
double precision, intent(inout) :: a(na,m), b(nb,n), c(nc,n), &
&wk(*)
! ----------------------------------------------------------------------
!     dabslv SOLVES THE REAL MATRIX EQUATION AX + XB = c. A IS REDUCED
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL mo = 0 AND
!     we have the following setup.
!
!        a(na,m)
!           A is a matrix of order m. it is assumed that
!           na .GE. m .GE. 1.
!
!        b(nb,n)
!           b is a matrix of order n. it is assumed that
!           nb .GE. n .GE. 1.
!
!        c(nc,n)
!           c is a matrix having m rows and n columns.
!           IT IS ASSUMED THAT nc .GE. m.
!
!        WK(---)
!           WK IS AN ARRAY OF DIMENSION m**2  + n**2 + 2K
!           WHERE K = max(m,n). WK IS A GENERAL STORAGE
!           area for the routine.
!
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!
!        ierr =  0  THE SOLUTION WAS OBTAINED AND STORED IN c.
!        ierr =  1  THE EQUATIONS ARE INCONSISTENT FOR A AND b.
!                   The problem cannot be solved.
!        ierr = -1  A COULD NOT BE REDUCED TO LOWER SCHUR FORM.
!                   The problem cannot be solved.
!        ierr = -2  b COULD NOT BE REDUCED TO UPPER SCHUR FORM.
!                   The problem cannot be solved.
!
!     WHEN ierr = 0, a CONTAINS THE LOWER SCHUR FORM OF THE MATRIX a,
!     b contains the upper Schur form of the matrix b, and WK contains
!     the orthonal matrices involved in the Schur decompositions of
!     A and b. this information can be reused to solve a new set of
!     EQUATIONS AX + XB = c WITHOUT HAVING TO REDECOMPOSE A AND b.
!     The following options are available...
!
!        mo = 1      NEW MATRICES A AND c ARE GIVEN. THE DATA FOR b
!                    is reused in solving the new set of equations.
!
!        mo = 2      NEW MATRICES b AND c ARE GIVEN. THE DATA FOR A
!                    is reused in solving the new set of equations.
!
!     mo .NE. 0,1,2  A NEW MATRIX c IS GIVEN. THE DATA FOR A AND b
!                    is reused in solving the new set of equations.
!
!     When dabslv is recalled, it is assumed that m, n, and WK have
!     not been modified.
! ----------------------------------------------------------------------
!     This subroutine is a modification by
!        Alfred H. Morris, Jr.
!        naval surface weapons center
!        Dahlgren, Virginia
!     of the subroutine axpxb written by
!        R.H. Bartels and G.W.Stewart
!        University of Texas at Austin.
!
!     Reference. Bartels, R.H. and Stewart, G.W., Algorithm 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = c, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iu = 1
iv = m*m + 1
iw = n*n + iv
call dabsv1 (mo,m,n,a,na,wk(iu),m,b,nb,wk(iv),n, &
&c,nc,wk(iw),ierr)
return
end subroutine dabslv

subroutine dabsv1 (mo,m,n,a,na,u,nu,b,nb,v,nv,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer :: m
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nb, nc, nu, nv
integer :: i, j, k
! ----------------------------------------------------------------------
!     dabsv1 SOLVES THE REAL MATRIX EQUATION AX + XB = c. A IS REDUCED
!     to lower Schur form, b is reduced to upper Schur form, and the
!     transformed system is solved by back substitution.
! ----------------------------------------------------------------------
double precision, intent(inout) :: a(na,m), b(nb,n), c(nc,n)
double precision, intent(inout) :: u(nu,m), v(nv,n)
double precision :: temp
double precision, intent(inout) :: wk(*)
!
!     If required, reduce A to lower real Schur form
!
if (mo .ne. 0 .and. mo .ne. 1) go to 35
do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
call dorth (na,m,1,m,a,wk)
call drtrn1 (m,1,m,a,na,u,nu,wk)
!
if (m .eq. 1) go to 20
call dschur (m,1,m,a,na,u,nu,wk(1),wk(m+1),ierr)
if (ierr .ne. 0) go to 200
!
20 do i = 1,m
   do j = i,m
      temp = a(i,j)
      a(i,j) = a(j,i)
      a(j,i) = temp
   end do
end do
!
!     If required, reduce b to upper real Schur form
!
35 if (mo .ne. 0 .and. mo .ne. 2) go to 45
call dorth (nb,n,1,n,b,wk)
call drtrn1 (n,1,n,b,nb,v,nv,wk)
!
if (n .eq. 1) go to 45
call dschur (n,1,n,b,nb,v,nv,wk(1),wk(n+1),ierr)
if (ierr .ne. 0) go to 210
!
!     Transform c
!
45 do j = 1,n
   do i = 1,m
      wk(i) = 0.d0
      do k = 1,m
         wk(i) = wk(i) + u(k,i)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
!
do i = 1,m
   do j = 1,n
      wk(j) = 0.d0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(k,j)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
!
!     Solve the transformed system
!
call dshslv (a,b,c,m,n,na,nb,nc,ierr)
if (ierr .ne. 0) go to 220
!
!     Transform c back to the solution
!
do j = 1,n
   do i = 1,m
      wk(i) = 0.d0
      do k = 1,m
         wk(i) = wk(i) + u(i,k)*c(k,j)
      end do
   end do
   do i = 1,m
      c(i,j) = wk(i)
   end do
end do
!
do i = 1,m
   do j = 1,n
      wk(j) = 0.d0
      do k = 1,n
         wk(j) = wk(j) + c(i,k)*v(j,k)
      end do
   end do
   do j = 1,n
      c(i,j) = wk(j)
   end do
end do
return
!
!     Error return
!
200 ierr = -1
return
210 ierr = -2
return
220 ierr = 1
return
end subroutine dabsv1

subroutine dschur (n, low, igh, h, nh, z, nz, wr, wi, ierr)
implicit none
integer :: ip1
! ----------------------------------------------------------------------
!     It is assumed that h is an upper Hessenberg matrix. dschur
!     obtains an orthogonal matrix q for which  TRANSPOSE(q)*h*q
!     is in Schur form. The eigenvalues of h are also computed.
!
!     On input-
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine dbal.  If  dbal  has not been used, set
!          low = 1, igh = n.
!
!        h contains the upper Hessenberg matrix,
!
!        nh is the first dimension of h,
!
!        z contains a matrix of order n,
!
!        nz is the first dimension of z.
!
!     On output-
!
!        h contains the transformed matrix in upper Schur form,
!
!        z contains the matrix z*q where q is the orthogonal
!          matrix which reduces h to upper Schur form,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n.
!
!        ierr is set to
!          0          FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 50 iterations.
!
! -----------------
!     Written by jack dongarra
!          Argonne National Laboratory
!          may 1961
!     modified by A.H. Morris (NSWC)
! ----------------------------------------------------------------------
!     This subroutine is a modification of the EISPACK subroutine
!     hqr2,  which is based on the Algol procedure hqr by peters
!     and Wilkinson, NUM. Math. 16 (1970), PP.181-204.
! ----------------------------------------------------------------------
integer :: i, j, k, l, m
integer, intent(in) :: n
integer :: en, ll, mm, na
integer, intent(in) :: nh, nz, igh
integer :: its
integer, intent(in) :: low
integer :: mp2, enm2
integer, intent(out) :: ierr
double precision, intent(inout) :: h(nh,n), wr(n), wi(n), z(nz,n)
double precision :: p, q, r, s, t, w, x, y, zz, norm, s1, s2
logical :: notlas
!     double precision dsqrt, dabs
!     integer min0
!
ierr = 0
norm = 0.d0
k = 1
!     ********** STORE ROOTS ISOLATED BY balanc
!                AND COMPUTE MATRIX norm **********
do 20 i = 1,n
!
  do 10 j = k,n
    norm = norm + dabs(h(i,j))
10 continue
!
  k = i
  if (i .ge. low .and. i .le. igh) go to 20
  wr(i) = h(i,i)
  wi(i) = 0.d0
20 continue
!
en = igh
t = 0.d0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
30 if (en .lt. low) go to 300
its = 0
na = en - 1
enm2 = na - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR l=en STEP -1 UNTIL LOW DO -- **********
40 do 50 ll = low,en
  l = en + low - ll
  if (l .eq. low) go to 60
  s = dabs(h(l-1,l-1)) + dabs(h(l,l))
  if (s .eq. 0.d0) s = norm
  s1 = s
  s2 = s1 + dabs(h(l,l-1))
  if (s1 .eq. s2) go to 60
50 continue
!     ********** FORM SHIFT **********
60 x = h(en,en)
if (l .eq. en) go to 220
y = h(na,na)
w = h(en,na)*h(na,en)
if (l .eq.na) go to 230
if (its .eq. 50) go to 290
if (its .ne. 10 .and. its .ne. 20 .and. its .ne. 30) go to 80
!     ********** FORM EXCEPTIONAL SHIFT **********
t = t + x
!
do i = low,en
  h(i,i) = h(i,i) - x
end do
!
s = dabs(h(en,na)) + dabs(h(na,enm2))
x = 0.75d0*s
y = x
w = -0.4375d0*s*s
80 its = its + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l,enm2
  m = enm2 + l - mm
  zz = h(m,m)
  r = x - zz
  s = y - zz
  p = (r*s-w)/h(m+1,m) + h(m,m+1)
  q = h(m+1,m+1) - zz - r - s
  r = h(m+2,m+1)
  s = dabs(p) + dabs(q) + dabs(r)
  p = p/s
  q = q/s
  r = r/s
  if (m .eq. l) go to 100
  s1 = dabs(p)*(dabs(h(m-1,m-1))+dabs(zz)+dabs(h(m+1,m+1)))
  s2 = s1 + dabs(h(m,m-1))*(dabs(q) + dabs(r))
  if (s1 .eq. s2) go to 100
end do
!
100 mp2 = m + 2
!
do 110 i = mp2,en
  h(i,i-2) = 0.d0
  if (i .eq. mp2) go to 110
  h(i,i-3) = 0.d0
110 continue
!     ********** DOUBLE QR STEP INVOLVING ROWS l TO en AND
!                COLUMNS m TO en **********
do 210 k = m,na
  notlas = k.ne.na
  if (k .eq. m) go to 120
  p = h(k,k-1)
  q = h(k+1,k-1)
  r = 0.d0
  if (notlas) r = h(k+2,k-1)
  x = dabs(p) + dabs(q) + dabs(r)
  if (x .eq. 0.d0) go to 210
  p = p/x
  q = q/x
  r = r/x
120 s = dsqrt(p*p + q*q + r*r)
  if (p .lt. 0.d0) s = -s
  if (k .eq. m) go to 130
  h(k,k-1) = -s*x
  go to 140
130 if (l .ne. m) h(k,k-1) = -h(k,k-1)
140 p = p + s
  x = p/s
  y = q/s
  zz = r/s
  q = q/p
  r = r/p
!     ********** ROW MODIFICATION **********
  do j = k,n
    p = h(k,j) + q*h(k+1,j)
    if (.not.notlas) go to 150
    p = p + r*h(k+2,j)
    h(k+2,j) = h(k+2,j) - p*zz
150 h(k+1,j) = h(k+1,j) - p*y
    h(k,j) = h(k,j) - p*x
  end do
!
  j = min0(en,k+3)
!     ********** COLUMN MODIFICATION **********
  do i = 1,j
    p = x*h(i,k) + y*h(i,k+1)
    if (.not.notlas) go to 170
    p = p + zz*h(i,k+2)
    h(i,k+2) = h(i,k+2) - p*r
170 h(i,k+1) = h(i,k+1) - p*q
    h(i,k) = h(i,k) - p
  end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
  do i = low,igh
    p = x*z(i,k) + y*z(i,k+1)
    if (.not.notlas) go to 190
    p = p + zz*z(i,k+2)
    z(i,k+2) = z(i,k+2) - p*r
190 z(i,k+1) = z(i,k+1) - p*q
    z(i,k) = z(i,k) - p
  end do
!
210 continue
!
go to 40
!     ********** ONE ROOT FOUND **********
220 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.d0
en = na
go to 30
!     ********** TWO ROOTS FOUND **********
230 p = (y - x)/2.d0
q = p*p + w
zz = dsqrt(dabs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q .lt. 0.d0) go to 270
!     ********** REAL PAIR **********
if (p .lt. 0.d0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz .ne. 0.d0) wr(en) = x - w/zz
wi(na) = 0.d0
wi(en) = 0.d0
x = h(en,na)
s = dabs(x) + dabs(zz)
p = x/s
q = zz/s
r = dsqrt(p*p + q*q)
p = p/r
q = q/r
!     ********** ROW MODIFICATION **********
do j = na,n
  zz = h(na,j)
  h(na,j) = q*zz + p*h(en,j)
  h(en,j) = q*h(en,j) - p*zz
end do
!     ********** COLUMN MODIFICATION **********
do i = 1,en
  zz = h(i,na)
  h(i,na) = q*zz + p*h(i,en)
  h(i,en) = q*h(i,en) - p*zz
end do
!     ********** ACCUMULATE TRANSFORMATIONS **********
do i = low,igh
  zz = z(i,na)
  z(i,na) = q*zz + p*z(i,en)
  z(i,en) = q*z(i,en) - p*zz
end do
!
go to 280
!     ********** COMPLEX PAIR **********
270 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
280 en = enm2
go to 30
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
290 ierr = en
return
300 do 320 i = 1,n
  ip1 = i + 1
  if (dabs(wi(i)) .ne. 0.d0) ip1 = ip1 + 1
  if (ip1 .gt. n) go to 320
  do j = ip1,n
    h(j,i) = 0.d0
  end do
320 continue
return
end subroutine dschur

subroutine dshslv (a,b,c,m,n,na,nb,nc,ierr)
implicit none
!     ------------------------------------------------------------------
!     dshslv SOLVES THE MATRIX EQUATION AX + XB = c WHERE
!     A is in lower Schur form and b in upper Schur form.
!     ------------------------------------------------------------------
integer, intent(in) :: m, n, na, nb, nc
integer, intent(inout) :: ierr
double precision, intent(in) :: a(na,m), b(nb,n)
double precision, intent(inout) :: c(nc,n)
double precision :: sum, p(4), t(4,4)
integer :: dk, dl, i, ib, j, ja, k, km1, kk, l, lm1, ll
!
l = 1
10 lm1 = l - 1
   dl = 1
   if (l .eq. n) go to 15
   if (b(l+1,l) .ne. 0.d0) dl = 2
15 ll = l + dl - 1
   if (l .eq. 1) go to 30
!
   do j = l,ll
      do 21 i = 1,m
      sum = c(i,j)
         do 20 ib = 1,lm1
20 sum = sum - c(i,ib)*b(ib,j)
21 c(i,j) = sum
   end do
!
30 k = 1
40 km1 = k - 1
      dk = 1
      if (k .eq. m) go to 45
      if (a(k,k+1) .ne. 0.d0) dk = 2
45 kk = k + dk - 1
      if (k .eq. 1) go to 60
!
      do i = k,kk
         do 51 j = l,ll
         sum = c(i,j)
            do 50 ja = 1,km1
50 sum = sum - a(i,ja)*c(ja,j)
51 c(i,j) = sum
      end do
!
60 if (dl .eq. 2) go to 80
      if (dk .eq. 2) go to 70
      t(1,1) = a(k,k) + b(l,l)
      if (t(1,1) .eq. 0.d0) go to 200
      c(k,l) = c(k,l)/t(1,1)
      ierr = 0
      go to 100
!
70 t(1,1) = a(k,k) + b(l,l)
      t(1,2) = a(k,kk)
      t(2,1) = a(kk,k)
      t(2,2) = a(kk,kk) + b(l,l)
      p(1) = c(k,l)
      p(2) = c(kk,l)
      call dpslv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      go to 100
!
80 if (dk .eq. 2) go to 90
      t(1,1) = a(k,k) + b(l,l)
      t(1,2) = b(ll,l)
      t(2,1) = b(l,ll)
      t(2,2) = a(k,k) + b(ll,ll)
      p(1) = c(k,l)
      p(2) = c(k,ll)
      call dpslv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(k,ll) = p(2)
      go to 100
!
90 t(1,1) = a(k,k) + b(l,l)
      t(1,2) = a(k,kk)
      t(1,3) = b(ll,l)
      t(1,4) = 0.d0
      t(2,1) = a(kk,k)
      t(2,2) = a(kk,kk) + b(l,l)
      t(2,3) = 0.d0
      t(2,4) = t(1,3)
      t(3,1) = b(l,ll)
      t(3,2) = 0.d0
      t(3,3) = a(k,k) + b(ll,ll)
      t(3,4) = t(1,2)
      t(4,1) = 0.d0
      t(4,2) = t(3,1)
      t(4,3) = t(2,1)
      t(4,4) = a(kk,kk) + b(ll,ll)
      p(1) = c(k,l)
      p(2) = c(kk,l)
      p(3) = c(k,ll)
      p(4) = c(kk,ll)
      call dpslv (4, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      c(k,ll) = p(3)
      c(kk,ll) = p(4)
!
100 k = k + dk
   if (k .le. m) go to 40
l = l + dl
if (l .le. n) go to 10
return
!
!     Error return
!
200 ierr = 1
return
end subroutine dshslv

subroutine taslv (mo,n,a,na,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc
integer :: iw
real, intent(inout) :: a(na,n), c(nc,n), wk(*)
! ----------------------------------------------------------------------
!     taslv SOLVES THE REAL MATRIX EQUATION TRANSPOSE(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL mo = 0 AND
!     we have the following setup.
!
!        a(na,n)
!           A is a matrix of order n. it is assumed that
!           na .GE. n .GE. 1.
!
!        c(nc,n)
!           c is a symmetric matrix of order n. it is
!           ASSUMED THAT nc .GE. n.
!
!        wk(---)
!           wk IS AN ARRAY OF DIMENSION n**2 + 2n THAT
!           is a general storage area for the routine.
!
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!
!        ierr =  0  THE SOLUTION WAS OBTAINED AND STORED IN c.
!        ierr =  1  THE EQUATIONS ARE INCONSISTENT FOR A. THE
!                   problem cannot be solved.
!        ierr = -1  A COULD NOT BE REDUCEDTO UPPER SCHUR FORM.
!                   The problem cannot be solved.
!
!     WHEN ierr = 0, A CONTAINS THE UPPER SCHUR FORM OF THE MATRIX
!     A and wk contains the orthogonal matrix involved in the Schur
!     decomposition of A. this information can be reused to solve A
!     NEW SET OF EQUATIONS TRANSPOSE(a)*X + X*a = c WITHOUT HAVING
!     to redecompose A. in this case, the input argument mo may be
!     SET TO ANY NONZERO VALUE. WHEN mo .NE. 0, IT IS ASSUMED THAT
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
!
!     Reference. Bartels, R.H. and Stewart, G.W., Algorithm 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = c, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iw = n*n + 1
call taslv1 (mo,n,a,na,wk(1),n,c,nc,wk(iw),ierr)
return
end subroutine taslv

subroutine taslv1 (mo,n,a,na,u,nu,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc, nu
integer :: i, j, k
! ----------------------------------------------------------------------
!     taslv1 SOLVES THE REAL MATRIX EQUATION TRANSPOSE(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
real, intent(inout) :: a(na,n), u(nu,n), c(nc,n), wk(*)
!
!    If required, reduce A to upper real Schur form
!
if (mo .ne. 0) go to 10
call orthes (na,n,1,n,a,wk)
call ortrn1 (n,1,n,a,na,u,nu,wk)
call schur (n,1,n,a,na,u,nu,wk(1),wk(n+1),ierr)
if (ierr .ne. 0) go to 200
!
!     Transform c
!
10 do i = 1,n
   c(i,i) = c(i,i)/2.0
end do
!
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
!
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
!
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
!
!     Solve the transformed system
!
call symslv (a,c,n,na,nc,ierr)
if (ierr .ne. 0) go to 210
!
!     Transform c back to the solution
!
do i = 1,n
   c(i,i) = c(i,i)/2.0
end do
!
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
!
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
!
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
return
!
!     Error return
!
200 ierr = -1
return
210 ierr = 1
return
end subroutine taslv1

subroutine symslv (a,c,n,na,nc,ierr)
implicit none
! ----------------------------------------------------------------------
!     symslv SOLVES THE MATRIX EQUATION TRANSPOSE(a)*X + X*a = c
!     where A is in upper Schur form and c is symmetric.
! ----------------------------------------------------------------------
integer, intent(in) :: n, na, nc
integer, intent(inout) :: ierr
real, intent(in) :: a(na,n)
real, intent(inout) :: c(nc,n)
real :: sum, p(4), t(4,4)
integer :: dk, dl, i, ia, j, k, kk, km1, l, ll, ldl
!
l = 1
10 dl = 1
   if (l .eq. n) go to 20
   if (a(l+1,l) .ne. 0.0) dl = 2
20 ll = l + dl - 1
!
   k = l
30 km1 = k - 1
      dk = 1
      if (k .eq. n) go to 35
      if (a(k+1,k) .ne. 0.0) dk = 2
35 kk = k + dk - 1
      if (k .eq. l) go to 45
!
      do i = k,kk
         do 41 j = l,ll
         sum = c(i,j)
            do 40 ia = l,km1
40 sum = sum - a(ia,i)*c(ia,j)
41 c(i,j) = sum
      end do
!
45 if (dl .eq. 2) go to 60
      if (dk .eq. 2 ) go to 50
      t(1,1) = a(k,k) + a(l,l)
      if (t(1,1) .eq. 0.0) go to 200
      c(k,l) = c(k,l)/t(1,1)
      ierr = 0
      go to 90
!
50 t(1,1) = a(k,k) + a(l,l)
      t(1,2) = a(kk,k)
      t(2,1) = a(k,kk)
      t(2,2) = a(kk,kk) + a(l,l)
      p(1) = c(k,l)
      p(2) = c(kk,l)
      call slv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      go to 90
!
60 if (dk .eq. 2) go to 70
      t(1,1) = a(k,k) + a(l,l)
      t(1,2) = a(ll,l)
      t(2,1) = a(l,ll)
      t(2,2) = a(k,k) + a(ll,ll)
      p(1) = c(k,l)
      p(2) = c(k,ll)
      call slv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(k,ll) = p(2)
      go to 90
!
70 if (k .ne. l) go to 80
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
      call slv (3, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(l,l) = p(1)
      c(ll,l) = p(2)
      c(l,ll) = p(2)
      c(ll,ll) = p(3)
      go to 90
!
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
      call slv (4, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      c(k,ll) = p(3)
      c(kk,ll) = p(4)
!
90 k = k + dk
   if (k .le. n) go to 30
ldl = l + dl
if (ldl .gt. n) return
!
do j = ldl,n
   do i = l,ll
      c(i,j) = c(j,i)
   end do
   do 120 i = j,n
      do 110 k = l,ll
110 c(i,j) = c(i,j) - c(i,k)*a(k,j) - a(k,i)*c(k,j)
120 c(j,i) = c(i,j)
end do
l = ldl
go to 10
!
!     Error return
!
200 ierr = 1
return
end subroutine symslv

subroutine dtaslv (mo,n,a,na,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc
integer :: iw
double precision, intent(inout) :: a(na,n), c(nc,n), wk(*)
! ----------------------------------------------------------------------
!     dtaslv SOLVES THE REAL MATRIX EQUATION TRANSPOSE(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
!        mo is an input argument which specifies if the routine is
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL mo = 0 AND
!     we have the following setup.
!
!        a(na,n)
!           A is a matrix of order n. it is assumed that
!           na .GE. n .GE. 1.
!
!        c(nc,n)
!           c is a symmetric matrix of order n. it is
!           ASSUMED THAT nc .GE. n.
!
!        wk(---)
!           wk IS AN ARRAY OF DIMENSION n**2 + 2n THAT
!           is a general storage area for the routine.
!
!     ierr is a variable that reports the status of the results. When
!     the routine terminates, ierr has one of the following values...
!
!        ierr =  0  THE SOLUTION WAS OBTAINED AND STORED IN c.
!        ierr =  1  THE EQUATIONS ARE INCONSISTENT FOR A. THE
!                   problem cannot be solved.
!        ierr = -1  A COULD NOT BE REDUCEDTO UPPER SCHUR FORM.
!                   The problem cannot be solved.
!
!     WHEN ierr = 0, A CONTAINS THE UPPER SCHUR FORM OF THE MATRIX
!     A and wk contains the orthogonal matrix involved in the Schur
!     decomposition of A. this information can be reused to solve A
!     NEW SET OF EQUATIONS TRANSPOSE(a)*X + X*a = c WITHOUT HAVING
!     to redecompose A. in this case, the input argument mo may be
!     SET TO ANY NONZERO VALUE. WHEN mo .NE. 0, IT IS ASSUMED THAT
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
!
!     Reference. Bartels, R.H. and Stewart, G.W., Algorithm 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = c, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
iw = n*n + 1
call dtasv1 (mo,n,a,na,wk(1),n,c,nc,wk(iw),ierr)
return
end subroutine dtaslv

subroutine dtasv1 (mo,n,a,na,u,nu,c,nc,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: mo
integer :: n
integer, intent(in) :: na, nc, nu
integer :: i, j, k
! ----------------------------------------------------------------------
!     dtasv1 SOLVES THE REAL MATRIX EQUATION TRANSPOSE(a)*X + X*a = c
!     where c is a symmetric matrix. A is reduced to upper Schur form
!     and the transformed system is solved.
! ----------------------------------------------------------------------
double precision, intent(inout) :: a(na,n), u(nu,n), c(nc,n), &
&wk(*)
!
!    If required, reduce A to upper real Schur form
!
if (mo .ne. 0) go to 10
call dorth (na,n,1,n,a,wk)
call drtrn1 (n,1,n,a,na,u,nu,wk)
call dschur (n,1,n,a,na,u,nu,wk(1),wk(n+1),ierr)
if (ierr .ne. 0) go to 200
!
!     Transform c
!
10 do i = 1,n
   c(i,i) = c(i,i)/2.d0
end do
!
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
!
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
!
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
!
!     Solve the transformed system
!
call dsymsv (a,c,n,na,nc,ierr)
if (ierr .ne. 0) go to 210
!
!     Transform c back to the solution
!
do i = 1,n
   c(i,i) = c(i,i)/2.d0
end do
!
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
!
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
!
do i = 1,n
   do j = i,n
      c(i,j) = c(i,j) + c(j,i)
      c(j,i) = c(i,j)
   end do
end do
return
!
!     Error return
!
200 ierr = -1
return
210 ierr = 1
return
end subroutine dtasv1

subroutine dsymsv (a,c,n,na,nc,ierr)
implicit none
! ----------------------------------------------------------------------
!     dsymsv SOLVES THE MATRIX EQUATION TRANSPOSE(a)*X + X*a = c
!     where A is in upper Schur form and c is symmetric.
! ----------------------------------------------------------------------
integer, intent(in) :: n, na, nc
integer, intent(inout) :: ierr
double precision, intent(in) :: a(na,n)
double precision, intent(inout) :: c(nc,n)
double precision :: sum, p(4), t(4,4)
integer :: dk, dl, i, ia, j, k, kk, km1, l, ll, ldl
!
l = 1
10 dl = 1
   if (l .eq. n) go to 20
   if (a(l+1,l) .ne. 0.d0) dl = 2
20 ll = l + dl - 1
!
   k = l
30 km1 = k - 1
      dk = 1
      if (k .eq. n) go to 35
      if (a(k+1,k) .ne. 0.d0) dk = 2
35 kk = k + dk - 1
      if (k .eq. l) go to 45
!
      do i = k,kk
         do 41 j = l,ll
         sum = c(i,j)
            do 40 ia = l,km1
40 sum = sum - a(ia,i)*c(ia,j)
41 c(i,j) = sum
      end do
!
45 if (dl .eq. 2) go to 60
      if (dk .eq. 2 ) go to 50
      t(1,1) = a(k,k) + a(l,l)
      if (t(1,1) .eq. 0.d0) go to 200
      c(k,l) = c(k,l)/t(1,1)
      ierr = 0
      go to 90
!
50 t(1,1) = a(k,k) + a(l,l)
      t(1,2) = a(kk,k)
      t(2,1) = a(k,kk)
      t(2,2) = a(kk,kk) + a(l,l)
      p(1) = c(k,l)
      p(2) = c(kk,l)
      call dpslv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      go to 90
!
60 if (dk .eq. 2) go to 70
      t(1,1) = a(k,k) + a(l,l)
      t(1,2) = a(ll,l)
      t(2,1) = a(l,ll)
      t(2,2) = a(k,k) + a(ll,ll)
      p(1) = c(k,l)
      p(2) = c(k,ll)
      call dpslv (2, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(k,ll) = p(2)
      go to 90
!
70 if (k .ne. l) go to 80
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
      call dpslv (3, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(l,l) = p(1)
      c(ll,l) = p(2)
      c(l,ll) = p(2)
      c(ll,ll) = p(3)
      go to 90
!
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
      call dpslv (4, 1, t, 4, p, 4, ierr)
      if (ierr .ne. 0) go to 200
      c(k,l) = p(1)
      c(kk,l) = p(2)
      c(k,ll) = p(3)
      c(kk,ll) = p(4)
!
90 k = k + dk
   if (k .le. n) go to 30
ldl = l + dl
if (ldl .gt. n) return
!
do j = ldl,n
   do i = l,ll
      c(i,j) = c(j,i)
   end do
   do 120 i = j,n
      do 110 k = l,ll
110 c(i,j) = c(i,j) - c(i,k)*a(k,j) - a(k,i)*c(k,j)
120 c(j,i) = c(i,j)
end do
l = ldl
go to 10
!
!     Error return
!
200 ierr = 1
return
end subroutine dsymsv

subroutine squint(nm, n, a, b, c, iguess, s, work, nw, tol, &
&maxits, ierr)
implicit none
!
!
!     Subroutine squint breaks down the work array  work  into
!     SMALLER PIECES.  THE ACTUAL SOLUTION TO AX**2 + BX + c = 0 IS
!     done in subroutine squin2.  This subroutine merely relieves
!     the user from a long calling sequence.
!
!
!     On entry,
!
!     nm     IS THE LEADING DIMENSION OF ALL THE MATRICES
!            in the calling program.
!
!     n      IS THE ORDER OF THE MATRICES A, b AND c.
!
!     A      IS THE MATRIX COEFFICIENT OF X**2.
!
!     b      IS THE MATRIX COEFFICIENT OF X.
!
!     c      IS THE CONSTANT MATRIX.
!
!     iguess IS AN INTEGER. IF iguess.NE.0, THE USER SUPPLIES AN
!            initial guess at a solvent.  This guess is stored in
!            ARRAY s.  IF iguess.EQ.0, THE SUBROUTINE PROVIDES ITS
!            own initial guess.
!
!     s      CONTAINS THE USERS INITIAL GUESS AT A SOLVENT, IF iguess
!            has been set to a nonzero quantity.  Otherwise the input
!            contents in s are ignored.
!
!     WORK   IS A WORK VECTOR.  IT MUST BE DIMENSIONED AT LEAST
!            (7n**2 + n), WHERE n IS THE ORDER OF A, b, c AND s.
!
!     nw     IS THE DIMENSION OF THE ARRAY work IN THE CALLING
!            program.
!
!     tol    IS A USER-SUPPLIED ACCURACY TOLERANCE.  SETTING tol = 0.0
!            causes iteration to proceed until full machine precision
!            is attained.  Otherwise, execution terminates when
!            NORM(AS**2+BS+c).LT.tol.
!
!     maxits IS AN INTEGER.  IF maxits.NE.0, THE USER SPECIFIES THE
!            most interations the algorithm is to take.  If maxits.
!            .LE.0, IT IS RESET TO 30.
!
!
!     On return,
!
!     A,b,c  are destroyed.
!
!     iguess contains the number of iterations performed to
!            compute s.
!
!     s      CONTAINS THE RIGHT SOLVENT.
!
!     work(1) is a complex number with real part equal to the norm
!            OF AS**2+BS+c.
!
!     ierr   IS AN INTEGER ERROR RETURN.
!
!            ierr = 0 FOR A NORMAL RETURN.
!
!            ierr = 1 INDICATES FAILURE OF SQUINT TO CONVERGE TO
!                     a solvent in the maximum number of iterations.
!
!            ierr = 2 INDICATES FAILURE IN THE UPPER REDUCTION IN
!                     cqzit.
!
!            ierr = 3 INDICATES FAILURE IN THE LOWER REDUCTION IN
!                     cqzit.
!
!            ierr = 10 + n  INDICATES AN ERROR RETURN FROM trislv
!                     on iteration n, designating inconsistency of
!                     the triangular system.
!
!            ierr = 999 INDICATES IMPROPER DIMENSIONING.  THE
!                     CONDITIONS  nm.GE.n.GT.0   AND
!                     nw.GE.(7*n*n + n) MUST HOLD.
!
integer, intent(in) :: nm, n
integer, intent(inout) :: iguess
integer, intent(in) :: nw
integer, intent(inout) :: maxits, ierr
integer :: i1, i2, i3, i4, i5, i6, i7
complex, intent(inout) :: work(nw)
complex, intent(inout) :: a(nm,n), b(nm,n), c(nm,n), s(nm,n)
real, intent(in) :: tol
i1 = n*n + 1
i2 = n*n + i1
i3 = n*n + i2
i4 = n*n + i3
i5 = n*n + i4
i6 = n*n + i5
i7 = n*n + i6
call squin2(nm, n, a, b, c, iguess, s, work(1), work(i1), &
&work(i2), work(i3), work(i4), work(i5), work(i6), work(i7), nw, &
&tol, maxits, ierr)
return
end subroutine squint

subroutine squin2(nm, n, a, b, c, iguess, s, l, u, v, z, r, xold, &
&eye, temp, nw, tol, maxits, ierr)
implicit none
!
!     Subroutine squin2 finds a right solvent of the matrix
!     EQUATION AX**2 + BX + c = 0.
!
!     On entry,
!
!     nm     IS THE LEADING DIMENSION OF ALL THE MATRICES IN
!            the calling program.
!
!     n      IS THE ORDER OF THE MATRICES A, b AND c.
!
!     A      IS THE MATRIX COEFFICIENT OF X**2.
!
!     b      IS THE MATRIX COEFFICIENT OF X.
!
!     c      IS THE CONSTANT MATRIX.
!
!     iguess is an integer set in the call to squint.
!
!     s      IS A MATRIX SET IN THE CALL TO SQUINT.
!
!     nw, tol, and maxits are integer and real parameters set in
!            the call to squint.
!
!
!     The following are internal variables ...
!
!
!     L      IS A MATRIX CONTAINING THE ITERATE X(i) FOR
!            reduction to lower triangular form.
!
!     U      IS A MATRIX CONTAINING AX(i) + b FOR REDUCTION
!            to upper triangular form.
!
!     v      IS A MATRIX CONTAINING A FOR REDUCTION TO UPPER
!            triangular form.
!
!     z,r    ARE MATRICES CONTAINING THE HISTORY OF THE
!            transformations in the reductions.
!
!     xold   IS A MATRIX HOLDING THE CURRENT ITERATE X(i).
!
!     EYE    CONTAINS AN IDENTITY MATRIX FOR THE LOWER REDUCTION
!            step.
!
!     TEMP   IS A WORK VECTOR.
!
!
!     On return,
!
!     A, b, c, iguess, s and ierr have the same properties as
!            described in the return from subroutine squint.
!
!     L(1,1) is a complex number with real part equal to the norm
!            OF AS**2+BS+c.
!
!
integer, intent(in) :: nm, n
integer, intent(inout) :: iguess
integer, intent(in) :: nw
integer, intent(inout) :: maxits, ierr
integer :: its, mats, i, j, k
complex, intent(inout) :: a(nm,n), b(nm,n), c(nm,n), s(nm,n), &
&l(nm,n), u(nm,n)
complex, intent(inout) :: v(nm,n), z(nm,n), r(nm,n), xold(nm,n), &
&eye(nm,n), temp(n)
real :: anorm, ani, bnorm, bni, cnorm, cni, xnorm, xni
real :: fxnorm, fxni, gnorm, tnorm, t
real, intent(in) :: tol
!     real sqrt, cabs, float
!     complex cmplx, conjg
k = 7*n*n + n
if (nw.lt.k) go to 460
if (nm.lt.n) go to 460
if (n.le.0) go to 460
if (maxits.le.0) maxits = 30
!     ********** INITIALIZE ARRAYS **********
do 20 i = 1,n
  do 10 j = 1,n
    l(i,j) = cmplx(0.0,0.0)
    u(i,j) = cmplx(0.0,0.0)
    v(i,j) = cmplx(0.0,0.0)
    z(i,j) = cmplx(0.0,0.0)
    xold(i,j) = cmplx(0.0,0.0)
    eye(i,j) = cmplx(0.0,0.0)
10 continue
  temp(i) = cmplx(0.0,0.0)
20 continue
!     ********** SET INITIAL GUESS(ES) **********
anorm = 0.0
bnorm = 0.0
cnorm = 0.0
do 40 i = 1,n
  ani = 0.0
  bni = 0.0
  cni = 0.0
  do 30 j = 1,n
    ani = ani + cabs(a(i,j))
    bni = bni + cabs(b(i,j))
    cni = cni + cabs(c(i,j))
30 continue
  if (ani.gt.anorm) anorm = ani
  if (bni.gt.bnorm) bnorm = bni
  if (cni.gt.cnorm) cnorm = cni
40 continue
gnorm = (bnorm+sqrt(bnorm**2+4.0*anorm*cnorm))/(2.0*anorm)
if (iguess.eq.0) go to 70
do i=1,n
  do j=1,n
    xold(i,j) = s(i,j)
  end do
end do
go to 100
!
70 do i=1,n
  do j=1,n
    xold(i,j) = cmplx(0.0,0.0)
  end do
  xold(i,i) = cmplx(gnorm,0.0)
end do
!
100 do its=1,maxits
  if (its.ne.31) go to 130
  do i=1,n
    do j=1,n
      xold(i,j) = cmplx(0.0,0.0)
    end do
    xold(i,i) = cmplx(0.0,gnorm)
  end do
!
130 if (its.ne.61) go to 160
  do i=1,n
    do j=1,n
      xold(i,j) = c(i,j)
    end do
  end do
!        ********** SET UP U AND RIGHT HAND SIDE **********
160 call cmprod(n, n, n, a, nm, xold, nm, u, nm, u)
  do i=1,n
    do j=1,n
      u(i,j) = u(i,j) + b(i,j)
    end do
  end do
  call cmprod(n, n, n, u, nm, xold, nm, s, nm, s)
  do i=1,n
    do j=1,n
      s(i,j) = s(i,j) + c(i,j)
    end do
  end do
!        ********** CHECK FOR CONVERGENCE **********
  xnorm = 0.0
  fxnorm = 0.0
  do i=1,n
    xni = 0.0
    fxni = 0.0
    do j=1,n
      xni = xni + cabs(xold(i,j))
      fxni = fxni + cabs(s(i,j))
    end do
    if (xni.gt.xnorm) xnorm = xni
    if (fxni.gt.fxnorm) fxnorm = fxni
  end do
  if (tol.le.0.0) go to 230
  if (fxnorm.lt.tol) go to 370
230 tnorm = 8.0*float(n)*anorm*xnorm**2 + 5.0*float(n)*bnorm*xnorm &
&+ cnorm
  t = 1.0 + fxnorm/tnorm
  if (t.eq.1.0) go to 370
  if (its.ge.maxits) go to 400
!        ********** UPPER TRIANGULARIZATION **********
  if (its.ne.1) go to 240
  mats = 1
  call cqzhes(nm, n, u, a, mats, z, s, b, c)
240 do i=1,n
    do j=1,n
      v(i,j) = a(i,j)
      l(i,j) = conjg(xold(j,i))
      eye(i,j) = cmplx(0.0,0.0)
    end do
    eye(i,i) = cmplx(1.0,0.0)
  end do
  if (its.eq.1) go to 270
  mats = 2
  call cqzhes(nm, n, u, v, mats, z, s, b, c)
270 call cqzit(nm, n, u, v, 0.0, mats, z, s, ierr)
  if (ierr.ne.0) go to 430
!        ********** LOWER TRIANGULARIZATION **********
  mats = 3
  call cqzhes(nm, n, l, eye, mats, r, s, b, c)
  call cqzit(nm, n, l, eye, 0.0, mats, r, s, ierr)
  if (ierr.ne.0) go to 440
  call ctrans(nm, n, l)
!        ********** UPDATE s WITH r **********
  do i=1,n
    do j=1,n
      temp(j) = s(i,j)
      s(i,j) = cmplx(0.0,0.0)
    end do
    do j=1,n
      do k=1,n
        s(i,j) = s(i,j) + temp(k)*r(k,j)
      end do
    end do
  end do
  do j=1,n
    do i=1,n
      l(i,j) = l(i,j)*eye(j,j)
    end do
    eye(j,j) = cmplx(1.0,0.0)
  end do
!        ********** BACKSOLVE THE TRANSFORMED SYSTEM **********
  call trislv(nm, n, u, v, l, s, temp, ierr)
  if (ierr.ne.0) go to 450
!        ********** TRANSLATE BACK TO THE SOLUTION **********
  call cmprod(n, n, n, z, nm, s, nm, l, nm, l)
  call ctrans(nm, n, r)
  call cmprod(n, n, n, l, nm, r, nm, s, nm, s)
  do i=1,n
    do j=1,n
      xold(i,j) = xold(i,j) - s(i,j)
    end do
  end do
end do
!     ********** CONVERGENCE **********
370 iguess = its - 1
l(1,1) = cmplx(fxnorm,0.0)
do i=1,n
  do j=1,n
    s(i,j) = xold(i,j)
  end do
end do
ierr = 0
return
!     ********** ERROR RETURNS **********
400 ierr = 1
l(1,1) = cmplx(fxnorm,0.0)
do i=1,n
  do j=1,n
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
return
end subroutine squin2

subroutine cqzhes(nm, n, a, b, mats, z, f, g, h)
implicit none
!
!
!     Subroutine cqzhes is a modification of the EISPACK subroutine
!     QZHES.  All operations are performed in complex arithmetic,
!     and the left transformations may also be applied to auxiliary
!     matrices f, g and h.
!
!
!     On entry,
!
!     nm   IS THE LEADING DIMENSION OF THE MATRICES A AND b IN
!          the main program.
!
!     n    IS THE ORDER OF THE MATRICES A AND b.
!
!     A    CONTAINS THE MATRIX TO BE REDUCED TO UPPER HESSENBERG
!          form.
!
!     b    CONTAINS THE MATRIX TO BE REDUCED TO UPPER TRAINGULAR
!          form.
!
!     Mats is an integer input variable.
!
!          IF mats = 0, THE ACCUMULATION OF THE TRANSFORMATIONS
!             is not desired.
!
!          IF mats = ANY OTHER NUMBER BUT 0, THE TRANSFORMATIONS
!             are accumulated.
!
!          IF mats = 1, THE AUXILIARY MATRICES g AND h ARE UPDATED
!             with the unitary matrix Q.
!
!          IF mats = 2, MATRIX b IS ASSUMED UPPER TRIANGULAR.
!
!          IF mats = 3, THE AUXILIARY MATRIX f IS NOT UPDATED
!             with the unitary matrix Q.
!
!     f, g and h are auxiliary matrices.
!
!
!     On return,
!
!     A    IS UPPER HESSENBERG.
!
!     b    IS UPPER TRIANGULAR.
!
!     z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
!
!     f, g and h are updated, if desired.
!
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: lb, l1
integer, intent(in) :: nm
integer :: nk1, nm1, nm2
complex, intent(inout) :: a(nm,n), b(nm,n), z(nm,n)
complex :: rr, t, u1, u2, v1, v2, rho
complex, intent(inout) :: f(nm,n)
complex :: tf
complex, intent(inout) :: g(nm,n)
complex :: tg
complex, intent(inout) :: h(nm,n)
complex :: th
real :: r, s
integer, intent(in) :: mats
!     real sqrt, cabs
!     complex cmplx, conjg
if (mats.eq.0) go to 30
do i=1,n
  do j=1,n
    z(i,j) = cmplx(0.0,0.0)
  end do
  z(i,i) = cmplx(1.0,0.0)
end do
!     ********** REDUCE b TO UPPER TRIANGULAR FORM **********
30 if (n.le.1) go to 260
nm1 = n - 1
if (mats.eq.2) go to 140
do 130 l = 1,nm1
  l1 = l + 1
  s = 0.0
  do i=l1,n
    s = s + cabs(b(i,l))
  end do
  if (s.eq.0.0) go to 130
  s = s + cabs(b(l,l))
  r = 0.0
  do i=l,n
    b(i,l) = b(i,l)/cmplx(s,0.0)
    r = r + cabs(b(i,l))**2
  end do
  r = sqrt(r)
  rr = cmplx(r,0.0)
  if (cabs(b(l,l)).ne.0.0) rr = (b(l,l)/cabs(b(l,l)))*rr
  b(l,l) = b(l,l) + rr
  rho = conjg(rr)*b(l,l)
  do j=l1,n
    t = cmplx(0.0,0.0)
    do i=l,n
      t = t + conjg(b(i,l))*b(i,j)
    end do
    t = -t/rho
    do i=l,n
      b(i,j) = b(i,j) + t*b(i,l)
    end do
  end do
  do j=1,n
    t = cmplx(0.0,0.0)
    tf = cmplx(0.0,0.0)
    tg = cmplx(0.0,0.0)
    th = cmplx(0.0,0.0)
    do 90 i = l,n
      t = t + conjg(b(i,l))*a(i,j)
      if (mats.eq.3) go to 90
      tf = tf + conjg(b(i,l))*f(i,j)
      if (mats.ne.1) go to 90
      tg = tg + conjg(b(i,l))*g(i,j)
      th = th + conjg(b(i,l))*h(i,j)
90 continue
    t = -t/rho
    tf = -tf/rho
    tg = -tg/rho
    th = -th/rho
    do 100 i = l,n
      a(i,j) = a(i,j) + t*b(i,l)
      if (mats.eq.3) go to 100
      f(i,j) = f(i,j) + tf*b(i,l)
      if (mats.ne.1) go to 100
      g(i,j) = g(i,j) + tg*b(i,l)
      h(i,j) = h(i,j) + th*b(i,l)
100 continue
  end do
  b(l,l) = -cmplx(s,0.0)*rr
  do i=l1,n
    b(i,l) = cmplx(0.0,0.0)
  end do
130 continue
!     ********** REDUCE A TO UPPER HESSENBERG FORM, WHILE
!                KEEPING b TRIANGULAR **********
140 if (n.eq.2) go to 260
nm2 = n - 2
do k=1,nm2
  nk1 = nm1 - k
  do 240 lb = 1,nk1
    l = n - lb
    l1 = l + 1
!     ********** ZERO a(l+1,k) **********
    s = cabs(a(l,k)) + cabs(a(l1,k))
    if (s.eq.0.0) go to 240
    u1 = a(l,k)/cmplx(s,0.0)
    u2 = a(l1,k)/cmplx(s,0.0)
    r = sqrt(cabs(u1)**2+cabs(u2)**2)
    rr = cmplx(r,0.0)
    if (cabs(u1).ne.0.0) rr = (u1/cabs(u1))*rr
    v1 = -(u1+rr)/rr
    v2 = -u2/rr
    u2 = v2/v1
    do j=k,n
      t = a(l,j) + conjg(u2)*a(l1,j)
      a(l,j) = a(l,j) + t*v1
      a(l1,j) = a(l1,j) + t*v2
    end do
    a(l1,k) = cmplx(0.0,0.0)
    do j=l,n
      t = b(l,j) + conjg(u2)*b(l1,j)
      b(l,j) = b(l,j) + t*v1
      b(l1,j) = b(l1,j) + t*v2
    end do
    if (mats.eq.3) go to 180
    do j=1,n
      tf = f(l,j) + conjg(u2)*f(l1,j)
      f(l,j) = f(l,j) + tf*v1
      f(l1,j) = f(l1,j) + tf*v2
    end do
180 if (mats.ne.1) go to 200
    do j=1,n
      tg = g(l,j) + conjg(u2) + g(l1,j)
      th = h(l,j) + conjg(u2) + h(l1,j)
      g(l,j) = g(l,j) + tg*v1
      h(l,j) = h(l,j) + th*v1
      g(l1,j) = g(l1,j) + tg*v2
      h(l1,j) = h(l1,j) + th*v2
    end do
!     ********** ZERO b(l+1,l) **********
200 s = cabs(b(l1,l1)) + cabs(b(l1,l))
    if (s.eq.0.0) go to 240
    u1 = b(l1,l1)/cmplx(s,0.0)
    u2 = b(l1,l)/cmplx(s,0.0)
    r = sqrt(cabs(u1)**2+cabs(u2)**2)
    rr = cmplx(r,0.0)
    if (cabs(u1).ne.0.0) rr = (u1/cabs(u1))*rr
    v1 = -(u1+rr)/rr
    v2 = -u2/rr
    u2 = v2/v1
    do i=1,l1
      t = b(i,l1) + conjg(u2)*b(i,l)
      b(i,l1) = b(i,l1) + t*v1
      b(i,l) = b(i,l) + t*v2
    end do
    b(l1,l) = cmplx(0.0,0.0)
    do i=1,n
      t = a(i,l1) + conjg(u2)*a(i,l)
      a(i,l1) = a(i,l1) + t*v1
      a(i,l) = a(i,l) + t*v2
    end do
    if (mats.eq.0) go to 240
    do i=1,n
      t = z(i,l1) + conjg(u2)*z(i,l)
      z(i,l1) = z(i,l1) + t*v1
      z(i,l) = z(i,l) + t*v2
    end do
240 continue
end do
260 return
end subroutine cqzhes

subroutine cqzit(nm, n, a, b, eps1, mats, z, f, ierr)
implicit none
!
!
!     Subroutine cqzit is a modification of the EISPACK subroutine
!     QZIT.  All operations are performed in complex arithmetic,
!     and the left transformations may also be applied to an auxiliary
!     MATRIX f.
!
!
!     On entry,
!
!     nm   IS THE LEADING DIMENSION OF THE MATRICES A AND b IN
!          the main program.
!
!     n    IS THE ORDER OF THE MATRICES A AND b.
!
!     A    CONTAINS AN UPPER HESSENBERG MATRIX FROM cqzhes.
!
!     b    CONTAINS AN UPPER TRIANGULAR MATRIX FROM cqzhes.
!
!     eps1 is a real number defining the tolerance used to determine
!          negligible elements of A and b in the course of the alg-
!          orithm.  An element of either matrix will be considered
!          negligible and reset to zero if it is not larger than the
!          PRODUCT OF eps1 AND THE NORM OF THE MATRIX.  IF eps1.LE.0,
!          relative machine precision will be computed and
!          used instead.
!
!     Mats is an integer input variable.  It is set prior
!          to the call to cqzhes.
!
!     f    CONTAINS AN AUXILIARY MATRIX.
!
!
!     On return,
!
!     A    IS UPPER TRIANGULAR.
!
!     b    IS UPPER TRIANGULAR.
!
!     z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
!
!     f    CONTAINS THE AUXILIARY MATRIX, UPDATED IF DESIRED.
!
!     ierr is an integer error return which indicates failure
!          of the QZ algorithm to reduce a subdiagonal element
!          to zero after 50 iterations.
!
integer :: i, j, k, l
integer, intent(in) :: n
integer :: en, jj, k1, k2, ld, ll, l1, na
integer, intent(in) :: nm
integer :: ish, its, km1, lm1
integer :: enm2
integer, intent(out) :: ierr
integer :: lor1, enorn
complex, intent(inout) :: a(nm,n), b(nm,n), z(nm,n)
complex :: a11, a21, a33, a34, a43, a44, b11, b22, b33, b34, b44
complex :: a1, a2, u1, u2, v1, v2, t, rr, sh, ss
complex, intent(inout) :: f(nm,n)
complex :: tf
real, intent(in) :: eps1
real :: epsa, epsb, anorm, bnorm, ani, bni, srelpr, r, s
integer, intent(in) :: mats
real :: spmpar
!     integer max0, min0
!     real sqrt, cabs
!     complex cmplx, conjg, csqrt
ierr = 0
!     ********** COMPUTE epsa, epsb **********
anorm = 0.0
bnorm = 0.0
do 20 i = 1,n
  ani = 0.0
  if (i.ne.1) ani = cabs(a(i,i-1))
  bni = 0.0
  do 10 j = i,n
    ani = ani + cabs(a(i,j))
    bni = bni + cabs(b(i,j))
10 continue
  if (ani.gt.anorm) anorm = ani
  if (bni.gt.bnorm) bnorm = bni
20 continue
if (anorm.eq.0.0) anorm = 1.0
if (bnorm.eq.0.0) bnorm = 1.0
srelpr = eps1
if (srelpr.gt.0.0) go to 40
!
!     ***** WHEN eps1 = 0 THEN SET srelpr TO BE THE SMALLEST
!           NUMBER FOR WHICH 1 + srelpr .GT. 1 *****
!
srelpr = spmpar(1)
!
40 epsa = srelpr*anorm
epsb = srelpr*bnorm
!     ********** REDUCE A TO TRIANGULAR FORM, WHILE
!                KEEPING b TRIANGULAR **********
lor1 = 1
enorn = n
en = n
!     ********** BEGIN QZ STEP **********
50 if (en.le.1) go to 220
if (mats.eq.0) enorn = en
its = 0
na = en - 1
enm2 = na - 1
60 ish = 1
!     ********** CHECK FOR CONVERGENCE OR REDUCIBILITY **********
do ll=1,en
  lm1 = en - ll
  l = lm1 + 1
  if (l.eq.1) go to 90
  if (cabs(a(l,lm1)).le.epsa) go to 80
end do
80 a(l,lm1) = cmplx(0.0,0.0)
if (l.lt.na) go to 90
!     ********** 1-BY-1 BLOCK ISOLATED **********
en = lm1
go to 50
!     ********** CHECK FOR SMALL TOP OF b **********
90 ld = l
l1 = l + 1
b11 = b(l,l)
if (cabs(b11).gt.epsb) go to 120
b(l,l) = cmplx(0.0,0.0)
s = cabs(a(l,l)) + cabs(a(l1,l))
u1 = a(l,l)/cmplx(s,0.0)
u2 = a(l1,l)/cmplx(s,0.0)
r = sqrt(cabs(u1)**2+cabs(u2)**2)
rr = cmplx(r,0.0)
if (cabs(u1).ne.0.0) rr = (u1/cabs(u1))*rr
v1 = -(u1+rr)/rr
v2 = -u2/rr
u2 = v2/v1
do 110 j = l,enorn
  t = a(l,j) + conjg(u2)*a(l1,j)
  a(l,j) = a(l,j) + t*v1
  a(l1,j) = a(l1,j) + t*v2
  t = b(l,j) + conjg(u2)*b(l1,j)
  b(l,j) = b(l,j) + t*v1
  b(l1,j) = b(l1,j) + t*v2
  if (mats.eq.3) go to 110
  do jj=1,n
    tf = f(l,jj) + conjg(u2)*f(l1,jj)
    f(l,jj) = f(l,jj) + tf*v1
    f(l1,jj) = f(l1,jj) + tf*v2
  end do
110 continue
if (l.ne.1) a(l,lm1) = -a(l,lm1)
lm1 = l
l = l1
go to 80
120 a11 = a(l,l)/b11
a21 = a(l1,l)/b11
!     ********** ITERATION STRATEGY **********
if (its.eq.50) go to 210
!     ********** DETERMINE SHIFT **********
b22 = b(l1,l1)
if (cabs(b22).lt.epsb) b22 = cmplx(epsb,0.0)
b33 = b(na,na)
if (cabs(b33).lt.epsb) b33 = cmplx(epsb,0.0)
b44 = b(en,en)
if (cabs(b44).lt.epsb) b44 = cmplx(epsb,0.0)
a33 = a(na,na)/b33
a34 = a(na,en)/b44
a43 = a(en,na)/b33
a44 = a(en,en)/b44
b34 = b(na,en)/b44
t = cmplx(0.5,0.0)*(a43*b34-a33-a44)
rr = t*t + a34*a43 - a33*a44
!     ********** DETERMINE SINGLE SHIFT ZEROTH COLUMN OF a **********
rr = csqrt(rr)
sh = -t + rr
ss = -t - rr
if (cabs(ss-a44).lt.cabs(sh-a44)) sh = ss
a1 = a11 - sh
a2 = a21
if (l.ne.ld) a(l,lm1) = -a(l,lm1)
if (its.ne.10) go to 130
a1 = cmplx(1.0,0.0)
a2 = cmplx(1.1605,0.0)
130 its = its + 1
if (mats.eq.0) lor1 = ld
!     ********** MAIN LOOP **********
do 200 k = l,na
  k1 = k + 1
  k2 = k + 2
  km1 = max0(k-1,l)
  ll = min0(en,k1+ish)
!     ********** ZERO a(k+1,k-1) **********
  if (k.eq.l) go to 140
  a1 = a(k,km1)
  a2 = a(k1,km1)
140 s = cabs(a1) + cabs(a2)
  if (s.eq.0.0) go to 60
  u1 = a1/cmplx(s,0.0)
  u2 = a2/cmplx(s,0.0)
  r = sqrt(cabs(u1)**2+cabs(u2)**2)
  rr = cmplx(r,0.0)
  if (cabs(u1).ne.0.0) rr = (u1/cabs(u1))*rr
  v1 = -(u1+rr)/rr
  v2 = -u2/rr
  u2 = v2/v1
  do j=km1,enorn
    t = a(k,j) + conjg(u2)*a(k1,j)
    a(k,j) = a(k,j) + t*v1
    a(k1,j) = a(k1,j) + t*v2
    t = b(k,j) + conjg(u2)*b(k1,j)
    b(k,j) = b(k,j) + t*v1
    b(k1,j) = b(k1,j) + t*v2
  end do
  if (k.ne.l) a(k1,km1) = cmplx(0.0,0.0)
  if (mats.eq.3) go to 170
  do j=1,n
    tf = f(k,j) + conjg(u2)*f(k1,j)
    f(k,j) = f(k,j) + tf*v1
    f(k1,j) = f(k1,j) + tf*v2
  end do
!     ********** ZERO b(k+1,k) **********
170 s = cabs(b(k1,k1)) + cabs(b(k1,k))
  if (s.eq.0.0) go to 200
  u1 = b(k1,k1)/cmplx(s,0.0)
  u2 = b(k1,k)/cmplx(s,0.0)
  r = sqrt(cabs(u1)**2+cabs(u2)**2)
  rr = cmplx(r,0.0)
  if (cabs(u1).ne.0.0) rr = (u1/cabs(u1))*rr
  v1 = -(u1+rr)/rr
  v2 = -u2/rr
  u2 = v2/v1
  do i=lor1,ll
    t = a(i,k1) + conjg(u2)*a(i,k)
    a(i,k1) = a(i,k1) + t*v1
    a(i,k) = a(i,k) + t*v2
    t = b(i,k1) + conjg(u2)*b(i,k)
    b(i,k1) = b(i,k1) + t*v1
    b(i,k) = b(i,k) + t*v2
  end do
  b(k1,k) = cmplx(0.0,0.0)
  if (mats.eq.0) go to 200
  do i=1,n
    t = z(i,k1) + conjg(u2)*z(i,k)
    z(i,k1) = z(i,k1) + t*v1
    z(i,k) = z(i,k) + t*v2
  end do
200 continue
!     ********** END QZ STEP **********
go to 60
!     ********** SET ERROR -- NEITHER BOTTOM SUBDIAGONAL ELEMENT
!                HAS BECOME NEGLIGIBLE AFTER 50 ITERATIONS **********
210 ierr = en
!     ********** SAVE epsb FOR USE BY CQZVEC **********
220 if (n.gt.1) b(n,1) = cmplx(epsb,0.0)
return
end subroutine cqzit

subroutine trislv(nm, n, u, v, l, f, temp, ierr)
implicit none
!
!
!     Subroutine trislv backsolves a system of the form
!     UY + VYL = f, WHERE u AND v ARE UPPER TRIANGULAR, AND
!     l is lower triangular.
!
!
!     On entry,
!
!     nm   IS THE LEADING DIMENSION OF THE MATRICES u, v, l AND f IN
!          the main program.
!
!     n    IS THE ORDER OF THE MATRICES u, v, l AND f.
!
!     u    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
!          coefficient of Y in the first term in UY + VYL.
!
!     v    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
!          coefficient of Y in the second term of UY + VYL.
!
!     l    CONTAINS A LOWER TRIANGULAR MATRIX.  IT IS THE RIGHT
!          coefficient of Y in the second term of UY + VYL.
!
!     f    CONTAINS THE RIGHT HAND SIDE OF UY + VYL = f.
!
!     Temp contains a work vector of length at least n.
!
!     On return,
!
!     f    CONTAINS THE SOLUTION Y.
!
!     ierr is an error return designating inconsistency of the
!          original system.
!          ierr.EQ.0 FOR A NORMAL RETURN.
!          ierr.EQ.1 IF THE TRIANGULAR SYSTEM IS INCONSISTENT.
!
!
integer :: i
integer, intent(out) :: ierr
integer :: j, jp1, k, kk, km1, m
integer, intent(in) :: n, nm
integer :: nm1
complex, intent(in) :: u(nm,n), v(nm,n), l(nm,n)
complex, intent(inout) :: f(nm,n)
complex, intent(inout) :: temp(n)
complex :: denom, sum
real :: s, t
!     real cabs
!     complex cmplx
ierr = 0
nm1 = n - 1
do kk=1,n
!        ********** BACKSUBSTITUTE FOR ROW k. **********
  k = n - kk + 1
  if (cabs(f(k,n)).ne.0.0) go to 10
  f(k,n) = cmplx(0.0,0.0)
  go to 30
10 denom = u(k,k) + v(k,k)*l(n,n)
  s = cabs(denom)
  t = 1.0 + s/cabs(f(k,n))
  if (t.gt.1.0) go to 20
  ierr = 1
  return
20 f(k,n) = f(k,n)/denom
  if (n.eq.1) return
30 do 70 i = 1,nm1
    j = n - i
    jp1 = j + 1
    sum = cmplx(0.0,0.0)
    do m=jp1,n
      sum = sum + f(k,m)*l(m,j)
    end do
    sum = f(k,j) - v(k,k)*sum
    if (cabs(sum).ne.0.0) go to 50
    f(k,j) = cmplx(0.0,0.0)
    go to 70
50 denom = u(k,k) + v(k,k)*l(j,j)
    s = cabs(denom)
    t = 1.0 + s/cabs(sum)
    if (t.gt.1.0) go to 60
    ierr = 1
    return
60 f(k,j) = sum/denom
70 continue
!        ********** FORM temp = YK-TRANS*l. **********
  if (k.eq.1) return
  km1 = k - 1
  do i=1,n
    temp(i) = cmplx(0.0,0.0)
    do j=1,n
      temp(i) = temp(i) + f(k,j)*l(j,i)
    end do
  end do
!        ********** PREPARE f' WHICH IS (k-1) BY n. **********
  do i=1,km1
    do j=1,n
      f(i,j) = f(i,j) - u(i,k)*f(k,j) - v(i,k)*temp(j)
    end do
  end do
end do
return
end subroutine trislv

subroutine mexp (a, ka, n, z, kz, wk, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kz
integer :: n
integer :: i, igh, j, k, kp1, l, ll, low, m, np1, np6
real :: anorm, anorm1, factor, p, q, s, s1
real, intent(inout) :: a(ka,n), z(kz,n), wk(n,*)
real :: c(8)
! ----------------------------------------------------------------------
!     mexp computes exp(a) and stores it in z where A is a matrix
!     of order n. A is destroyed by the routine.
!
!     wk is an array of dimension (n,n+8). wk is a work space
!     for the routine.
!
!     ierr is a variable that reports the status of the results.
!        ierr = 0  exp(a) WAS SUCCESSFULLY COMPUTED.
!        ierr = 1  THE NORM OF A IS TOO LARGE.
!        ierr = 2  THE PADE DENOMINATOR MATRIX IS
!                  singular.
!
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren Virginia
!     ---------------
!     Coefficients for (8,8) Pade table entry
!     ---------------
data c(1)/.500000000000000e+00/, c(2)/.116666666666667e+00/, &
&c(3)/.166666666666667e-01/, c(4)/.160256410256410e-02/, &
&c(5)/.106837606837607e-03/, c(6)/.485625485625486e-05/, &
&c(7)/.138750138750139e-06/, c(8)/.192708526041859e-08/
! ----------------------------------------------------------------------
ierr = 0
if (n .gt. 1) go to 10
   z(1,1) = exp(a(1,1))
   return
!
!       Balance A and select the smaller of the 1-norm
!              and infinity-norm of the result
!
10 call balanc (ka,n,a,low,igh,wk(1,n+8))
anorm = 0.0
anorm1 = 0.0
do 12 j = 1,n
s = 0.0
s1 = 0.0
   do 11 i = 1,n
   s = s + abs(a(j,i))
11 s1 = s1 + abs(a(i,j))
anorm = amax1(s,anorm)
12 anorm1 = amax1(s1,anorm1)
!
anorm = amin1(anorm,anorm1)
s = anorm + 0.1
if (s .eq. anorm) go to 200
!
!              Select the normalization factor
!
m = 0
if (anorm .le. 1.0)  go to 40
factor = 1.0
20 m = m + 1
factor = 2.0*factor
if (anorm .gt. factor) go to 20
!
!                Normalize the matrix a
!
do j = 1,n
   do 30 i = 1,n
30 a(i,j) = a(i,j)/factor
end do
!
40 np1 = n + 1
np6 = n + 6
do j = 1,n
!
!     Compute the j-TH column of first eight powers of A
!
   do 51 i = 1,n
   s = 0.0
      do 50 l = 1,n
50 s = s + a(i,l)*a(l,j)
51 wk(i,np1) = s
!
   do k = np1,np6
   kp1 = k + 1
      do 61 i = 1,n
      s = 0.0
         do 60 l = 1,n
60 s = s + a(i,l)*wk(l,k)
61 wk(i,kp1) = s
   end do
!
!     Compute the j-TH column of the numerator and denominator
!                  of the Pade approximation
!
   do 90 i = 1,n
   p = 0.0
   q = 0.0
   k = 8
   l = n + 7
      do 80 ll = 1,7
      s = c(k)*wk(i,l)
      p = s + p
      q = s - q
      k = k - 1
80 l = l - 1
   s = c(1)*a(i,j)
   z(i,j) = p + s
   wk(i,j) = q - s
   if (i .ne. j) go to 90
      z(i,j) = z(i,j) + 1.0
      wk(i,j) = wk(i,j) + 1.0
90 continue
end do
!
!        CALCULATE exp(a) BY SOLVING  wk * exp(a) = z
!
call slv (n, n, wk, n, z, kz, ierr)
if (ierr .ne. 0) go to 210
if (m .eq. 0)  go to 150
!
!          Take out the effect of the normalization
!                   operation on exp(a)
!
do k = 1,m
   do j = 1,n
      do 120 i = 1,n
      s = 0.0
         do 110 l = 1,n
110 s = s + z(i,l)*z(l,j)
120 wk(i,j) = s
   end do
!
   do j = 1,n
      do 130 i = 1,n
130 z(i,j) = wk(i,j)
   end do
end do
!
!            Take out the effect of the balancing
!                   operation on exp(a)
!
150 call balinv (kz,n,z,low,igh,wk(1,n+8))
return
!
!                     Error return
!
200 ierr = 1
return
210 ierr = 2
return
end subroutine mexp

subroutine dmexp (a, ka, n, z, kz, wk, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kz
integer :: n
integer :: i, igh, j, k, kp1, l, ll, low, m, np1, np10
double precision, intent(inout) :: a(ka,n), z(kz,n), wk(n,*)
double precision :: anorm, anorm1, c(12), factor, p, q, s, s1
! ----------------------------------------------------------------------
!     dmexp computes exp(a) and stores it in z where A is a matrix
!     of order n. A is destroyed by the routine.
!
!     wk is an array of dimension (n,n+12). wk is a work space
!     for the routine.
!
!     ierr is a variable that reports the status of the results.
!        ierr = 0  exp(a) WAS SUCCESSFULLY COMPUTED.
!        ierr = 1  THE NORM OF A IS TOO LARGE.
!        ierr = 2  THE PADE DENOMINATOR MATRIX IS
!                  singular.
!
!     Written by Alfred H. Morris
!        naval surface weapons center
!        Dahlgren Virginia
!     ---------------
!     Coefficients for (12,12) Pade table entry
!     ---------------
data c(1) /.500000000000000000000000000000d+00/, &
&c(2) /.119565217391304347826086956522d+00/, &
&c(3) /.181159420289855072463768115942d-01/, &
&c(4) /.194099378881987577639751552795d-02/, &
&c(5) /.155279503105590062111801242236d-03/, &
&c(6) /.953470633104500381388253241800d-05/, &
&c(7) /.454033634811666848280120591333d-06/, &
&c(8) /.166924130445465753044161982108d-07/, &
&c(9) /.463678140126293758456005505855d-09/
data c(10)/.927356280252587516912011011710d-11/, &
&c(11)/.120435880552284093105455975547d-12/, &
&c(12)/.772024875335154442983692150941d-15/
! ----------------------------------------------------------------------
ierr = 0
if (n .gt. 1) go to 10
   z(1,1) = dexp(a(1,1))
   return
!
!       Balance A and select the smaller of the 1-norm
!              and infinity-norm of the result
!
10 call dbal (ka,n,a,low,igh,wk(1,n+12))
anorm = 0.d0
anorm1 = 0.d0
do 12 j = 1,n
s = 0.d0
s1 = 0.d0
   do 11 i = 1,n
   s = s + dabs(a(j,i))
11 s1 = s1 + dabs(a(i,j))
anorm = dmax1(s,anorm)
12 anorm1 = dmax1(s1,anorm1)
!
anorm = dmin1(anorm,anorm1)
s = anorm + 0.1d0
if (s .eq. anorm) go to 200
!
!              Select the normalization factor
!
m = 0
if (anorm .le. 1.d0)  go to 40
factor = 1.d0
20 m = m + 1
factor = 2.d0*factor
if (anorm .gt. factor) go to 20
!
!                Normalize the matrix a
!
do j = 1,n
   do 30 i = 1,n
30 a(i,j) = a(i,j)/factor
end do
!
40 np1 = n + 1
np10 = n + 10
do j = 1,n
!
!     Compute the j-TH column of the first 12 powers of A
!
   do 51 i = 1,n
   s = 0.d0
      do 50 l = 1,n
50 s = s + a(i,l)*a(l,j)
51 wk(i,np1) = s
!
   do k = np1,np10
   kp1 = k + 1
      do 61 i = 1,n
      s = 0.d0
         do 60 l = 1,n
60 s = s + a(i,l)*wk(l,k)
61 wk(i,kp1) = s
   end do
!
!     Compute the j-TH column of the numerator and denominator
!                  of the Pade approximation
!
   do 90 i = 1,n
   p = 0.d0
   q = 0.d0
   k = 12
   l = n + 11
      do 80 ll = 1,11
      s = c(k)*wk(i,l)
      p = s + p
      q = s - q
      k = k - 1
80 l = l - 1
   s = c(1)*a(i,j)
   z(i,j) = p + s
   wk(i,j) = q - s
   if (i .ne. j) go to 90
      z(i,j) = z(i,j) + 1.d0
      wk(i,j) = wk(i,j) + 1.d0
90 continue
end do
!
!        CALCULATE exp(a) BY SOLVING  wk * exp(a) = z
!
call dpslv (n, n, wk, n, z, kz, ierr)
if (ierr .ne. 0) go to 210
if (m .eq. 0)  go to 150
!
!          Take out the effect of the normalization
!                   operation on exp(a)
!
do k = 1,m
   do j = 1,n
      do 120 i = 1,n
      s = 0.d0
         do 110 l = 1,n
110 s = s + z(i,l)*z(l,j)
120 wk(i,j) = s
   end do
!
   do j = 1,n
      do 130 i = 1,n
130 z(i,j) = wk(i,j)
   end do
end do
!
!            Take out the effect of the balancing
!                   operation on exp(a)
!
150 call dbalnv (kz,n,z,low,igh,wk(1,n+12))
return
!
!                     Error return
!
200 ierr = 1
return
210 ierr = 2
return
end subroutine dmexp

subroutine le (rowk,n,b,c,d,ip,ierr)
implicit none
integer, intent(out) :: ierr
integer :: n
integer :: i, iflag, ij, ijold, ik, j, k, kjold, km1, kp1, last, &
&lastm1, lcol, lcolp1, m, max, mjold, nm1, np1
real :: bk, c1, cj, ck, dkj, zero
!     ******************************************************************
!     Solution of linear equations with reduced storage
!     ******************************************************************
real, intent(in) :: b(n)
real, intent(inout) :: c(n), d(*)
integer, intent(inout) :: ip(*)
external rowk
data zero/0.0/
!
!     Set the necessary constants
!
ierr = 0
np1 = n + 1
max = n*n/4 + n + 3
k = 1
iflag = -1
!
!     Get the first column of the transposed system
!
call rowk(n,1,c)
bk = b(1)
!
if (n .gt. 1) go to 10
if (c(1) .eq. zero) go to 200
c(1) = bk/c(1)
return
!
!     Find the pivot for column 1
!
10 m = 1
do i = 2,n
if (abs(c(m)) .lt. abs(c(i))) m = i
end do
!
ip(1) = m
c1 = c(m)
c(m) = c(1)
c(1) = c1
if (c(1) .eq. zero) go to 200
!
!     Find the first elementary matrix and store it in d
!
do 30 i = 2,n
30 d(i-1) = -c(i)/c(1)
d(n) = bk/c(1)
!
!     k loop - each k for a new column of the transposed system
!
do k = 2,n
kp1 = k + 1
km1 = k - 1
!
!       Get column k
!
call rowk(n,k,c)
do 40 j = 1,km1
m = ip(j)
cj = c(j)
c(j) = c(m)
40 c(m) = cj
bk = b(k)
!
iflag = -iflag
lcol = np1 - k
lcolp1 = lcol + 1
lastm1 = 1
last = max - n + k
if (k .eq. 2) go to 50
!
lastm1 = max - n + km1
if (iflag .lt. 0) last = last - n + k - 2
if (iflag .gt. 0) lastm1 = lastm1 - n + k - 3
!
!     j loop - effect of columns 1 to k-1 of L-inverse
!
50 do 61 j = 1,km1
cj = c(j)
ij = (j-1)*lcolp1
if (j .eq. km1) ij = lastm1 - 1
!
!     i loop - effect of L-inverse on rows k to n+1
!
do 60 i = k,n
ij = ij + 1
60 c(i) = c(i) + d(ij)*cj
61 bk = bk - d(ij+1)*cj
!
!       k=n CASE
!
m = k
if (k .lt. n) go to 70
if (c(k) .eq. zero) go to 200
d(last) = bk/c(k)
go to 90
!
!     Find the pivot
!
70 do i = kp1,n
if (abs(c(m)) .lt. abs(c(i))) m = i
end do
!
ip(k) = m
ck = c(m)
c(m) = c(k)
c(k) = ck
if (c(k) .eq. zero) go to 200
!
!     Find the k-TH elementary matrix
!
ik = last
do 80 i = kp1,n
d(ik) = -c(i)/c(k)
80 ik = ik + 1
d(ik) = bk/c(k)
!
!     Form the product of the elementary matrices
!
90 do 110 j = 1,km1
kjold = j*lcolp1 + k - np1
mjold = kjold + m - k
ij = (j-1)*lcol
ijold = ij + j
if (j .ne. km1) go to 100
!
kjold = lastm1
mjold = lastm1 + m - k
ijold = lastm1
!
100 ik = last - 1
dkj = d(mjold)
d(mjold) = d(kjold)
do 110 i = kp1,np1
ij = ij + 1
ijold = ijold + 1
ik = ik + 1
d(ij) = d(ijold) + d(ik)*dkj
110 continue
end do
!
last = max
if (iflag .lt. 0) last = max - 2
d(n) = d(last)
!
!     Insert the solution in c
!
do 130 i = 1,n
130 c(i) = d(i)
!
nm1 = n - 1
do 140 i = 1,nm1
k = n - i
m = ip(k)
ck = c(k)
c(k) = c(m)
140 c(m) = ck
return
!
!     The system is singular
!
200 ierr = k
return
end subroutine le

subroutine dple (rowk,n,b,c,d,ip,ierr)
implicit none
integer, intent(out) :: ierr
integer :: n
integer :: i, iflag, ij, ijold, ik, j, k, kjold, km1, kp1, last, &
&lastm1, lcol, lcolp1, m, max, mjold, nm1, np1
!     ******************************************************************
!     Solution of linear equations with reduced storage
!     ******************************************************************
double precision, intent(in) :: b(n)
double precision, intent(inout) :: c(n), d(*)
integer, intent(inout) :: ip(*)
double precision :: bk, cj, ck, c1, dkj, zero
external rowk
data zero/0.d0/
!
!     Set the necessary constants
!
ierr = 0
np1 = n + 1
max = n*n/4 + n + 3
k = 1
iflag = -1
!
!     Get the first column of the transposed system
!
call rowk(n,1,c)
bk = b(1)
!
if (n .gt. 1) go to 10
if (c(1) .eq. zero) go to 200
c(1) = bk/c(1)
return
!
!     Find the pivot for column 1
!
10 m = 1
do i = 2,n
if (dabs(c(m)) .lt. dabs(c(i))) m = i
end do
!
ip(1) = m
c1 = c(m)
c(m) = c(1)
c(1) = c1
if (c(1) .eq. zero) go to 200
!
!     Find the first elementary matrix and store it in d
!
do 30 i = 2,n
30 d(i-1) = -c(i)/c(1)
d(n) = bk/c(1)
!
!     k loop - each k for a new column of the transposed system
!
do k = 2,n
kp1 = k + 1
km1 = k - 1
!
!       Get column k
!
call rowk(n,k,c)
do 40 j = 1,km1
m = ip(j)
cj = c(j)
c(j) = c(m)
40 c(m) = cj
bk = b(k)
!
iflag = -iflag
lcol = np1 - k
lcolp1 = lcol + 1
lastm1 = 1
last = max - n + k
if (k .eq. 2) go to 50
!
lastm1 = max - n + km1
if (iflag .lt. 0) last = last - n + k - 2
if (iflag .gt. 0) lastm1 = lastm1 - n + k - 3
!
!     j loop - effect of columns 1 to k-1 of L-inverse
!
50 do 61 j = 1,km1
cj = c(j)
ij = (j-1)*lcolp1
if (j .eq. km1) ij = lastm1 - 1
!
!     i loop - effect of L-inverse on rows k to n+1
!
do 60 i = k,n
ij = ij + 1
60 c(i) = c(i) + d(ij)*cj
61 bk = bk - d(ij+1)*cj
!
!       k=n CASE
!
m = k
if (k .lt. n) go to 70
if (c(k) .eq. zero) go to 200
d(last) = bk/c(k)
go to 90
!
!     Find the pivot
!
70 do i = kp1,n
if (dabs(c(m)) .lt. dabs(c(i))) m = i
end do
!
ip(k) = m
ck = c(m)
c(m) = c(k)
c(k) = ck
if (c(k) .eq. zero) go to 200
!
!     Find the k-TH elementary matrix
!
ik = last
do 80 i = kp1,n
d(ik) = -c(i)/c(k)
80 ik = ik + 1
d(ik) = bk/c(k)
!
!     Form the product of the elementary matrices
!
90 do 110 j = 1,km1
kjold = j*lcolp1 + k - np1
mjold = kjold + m - k
ij = (j-1)*lcol
ijold = ij + j
if (j .ne. km1) go to 100
!
kjold = lastm1
mjold = lastm1 + m - k
ijold = lastm1
!
100 ik = last - 1
dkj = d(mjold)
d(mjold) = d(kjold)
do 110 i = kp1,np1
ij = ij + 1
ijold = ijold + 1
ik = ik + 1
d(ij) = d(ijold) + d(ik)*dkj
110 continue
end do
!
last = max
if (iflag .lt. 0) last = max - 2
d(n) = d(last)
!
!     Insert the solution in c
!
do 130 i = 1,n
130 c(i) = d(i)
!
nm1 = n - 1
do 140 i = 1,nm1
k = n - i
m = ip(k)
ck = c(k)
c(k) = c(m)
140 c(m) = ck
return
!
!     The system is singular
!
200 ierr = k
return
end subroutine dple

subroutine cle (rowk,n,b,c,d,ip,ierr)
implicit none
integer, intent(out) :: ierr
integer :: n
integer :: i, iflag, ij, ijold, ik, j, k, kjold, km1, kp1, last, &
&lastm1, lcol, lcolp1, m, max, mjold, nm1, np1
real :: s, si
!     ******************************************************************
!     Solution of complex linear equations with reduced storage
!     ******************************************************************
complex, intent(in) :: b(n)
complex, intent(inout) :: c(n), d(*)
integer, intent(inout) :: ip(*)
complex :: bk, cj, ck, c1, dkj, zero
external rowk
data zero/(0.0,0.0)/
!
!     Set the necessary constants
!
ierr = 0
np1 = n + 1
max = n*n/4 + n + 3
k = 1
iflag = -1
!
!     Get the first column of the transposed system
!
call rowk(n,1,c)
bk = b(1)
!
if (n .gt. 1) go to 10
if (c(1) .eq. zero) go to 200
c(1) = bk/c(1)
return
!
!     Find the pivot for column 1
!
10 m = 1
s = abs(real(c(1))) + abs(aimag(c(1)))
do 20 i = 2,n
si = abs(real(c(i))) + abs(aimag(c(i)))
if (si .le. s) go to 20
m = i
s = si
20 continue
!
ip(1) = m
c1 = c(m)
c(m) = c(1)
c(1) = c1
if (c(1) .eq. zero) go to 200
!
!     Find the first elementary matrix and store it in d
!
do 30 i = 2,n
30 d(i-1) = -c(i)/c(1)
d(n) = bk/c(1)
!
!     k loop - each k for a new column of the transposed system
!
do k = 2,n
kp1 = k + 1
km1 = k - 1
!
!       Get column k
!
call rowk(n,k,c)
do 40 j = 1,km1
m = ip(j)
cj = c(j)
c(j) = c(m)
40 c(m) = cj
bk = b(k)
!
iflag = -iflag
lcol = np1 - k
lcolp1 = lcol + 1
lastm1 = 1
last = max - n + k
if (k .eq. 2) go to 50
!
lastm1 = max - n + km1
if (iflag .lt. 0) last = last - n + k - 2
if (iflag .gt. 0) lastm1 = lastm1 - n + k - 3
!
!     j loop - effect of columns 1 to k-1 of L-inverse
!
50 do 61 j = 1,km1
cj = c(j)
ij = (j-1)*lcolp1
if (j .eq. km1) ij = lastm1 - 1
!
!     i loop - effect of L-inverse on rows k to n+1
!
do 60 i = k,n
ij = ij + 1
60 c(i) = c(i) + d(ij)*cj
61 bk = bk - d(ij+1)*cj
!
!       k=n CASE
!
m = k
if (k .lt. n) go to 70
if (c(k) .eq. zero) go to 200
d(last) = bk/c(k)
go to 90
!
!     Find the pivot
!
70 s = abs(real(c(k))) + abs(aimag(c(k)))
do 71 i = kp1,n
si = abs(real(c(i))) + abs(aimag(c(i)))
if (si .le. s) go to 71
m = i
s = si
71 continue
!
ip(k) = m
ck = c(m)
c(m) = c(k)
c(k) = ck
if (c(k) .eq. zero) go to 200
!
!     Find the k-TH elementary matrix
!
ik = last
do 80 i = kp1,n
d(ik) = -c(i)/c(k)
80 ik = ik + 1
d(ik) = bk/c(k)
!
!     Form the product of the elementary matrices
!
90 do 110 j = 1,km1
kjold = j*lcolp1 + k - np1
mjold = kjold + m - k
ij = (j-1)*lcol
ijold = ij + j
if (j .ne. km1) go to 100
!
kjold = lastm1
mjold = lastm1 + m - k
ijold = lastm1
!
100 ik = last - 1
dkj = d(mjold)
d(mjold) = d(kjold)
do 110 i = kp1,np1
ij = ij + 1
ijold = ijold + 1
ik = ik + 1
d(ij) = d(ijold) + d(ik)*dkj
110 continue
end do
!
last = max
if (iflag .lt. 0) last = max - 2
d(n) = d(last)
!
!     Insert the solution in c
!
do 130 i = 1,n
130 c(i) = d(i)
!
nm1 = n - 1
do 140 i = 1,nm1
k = n - i
m = ip(k)
ck = c(k)
c(k) = c(m)
140 c(m) = ck
return
!
!     The system is singular
!
200 ierr = k
return
end subroutine cle

subroutine cvbr (b,kb,m,n,ml,mu,a,ka)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imax0, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!           Conversion of real matrices from banded to
!                         standard form
!-----------------------------------------------------------------------
real, intent(inout) :: a(ka,n)
real, intent(in) :: b(kb,*)
!
!     Store the nonzero data of the first ml rows
!
if (ml .eq. 0) go to 20
do i = 1,ml
   jmax = min0(n,i + mu)
   k = ml + 1 - i
   do 10 j = 1,jmax
      k = k + 1
10 a(i,j) = b(i,k)
end do
!
!     Store the remaining nonzero data
!
20 imin = ml + 1
imax = min0(m,ml + n)
l = 0
do i = imin,imax
   jmin = i - ml
   jmax = min0(n,i + mu)
   j = jmax
   do 21 jj = jmin,jmax
      k = j - l
      a(i,j) = b(i,k)
21 j = j - 1
   l = l + 1
end do
!
!     Insert zeros in the upper right corner
!
jmin = mu + 2
if (jmin .gt. n) go to 40
imax0 = 1
do j = jmin,n
   do 30 i = 1,imax0
30 a(i,j) = 0.0
   imax0 = min0(imax,imax0 + 1)
end do
!
!     Insert zeros in the lower left corner
!
40 if (imin .eq. imax) go to 50
jmax = imax - imin
do j = 1,jmax
   imin = imin + 1
   do 41 i = imin,imax
41 a(i,j) = 0.0
end do
!
!     Store zeros in the final m-imax rows
!
50 if (imax .eq. m) return
imin = imax + 1
do j = 1,n
   do 51 i = imin,m
51 a(i,j) = 0.0
end do
return
end subroutine cvbr

subroutine cvrb (a,ka,m,n,ml,mu,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of real matrices from standard to banded
!                    form when ml and mu are given
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,*)
!
!     Store the nonzero data of the first ml rows
!
if (ml .eq. 0) go to 30
l = ml
do i = 1,ml
   jmax = min0(n,i + mu)
   j = jmax
   do 10 jj = 1,jmax
      k = j + l
      b(i,k) = a(i,j)
10 j = j - 1
   l = l - 1
end do
!
!     Insert zeros in the upper left corner
!
imax = ml
do j = 1,ml
   do 20 i = 1,imax
20 b(i,j) = 0.0
   imax = imax - 1
end do
!
!     Store the remaining nonzero data
!
30 imin = ml + 1
imax = min0(m,ml + n)
do i = imin,imax
   jmin = i - ml
   jmax = min0(n,i + mu)
   k = 0
   do 31 j = jmin,jmax
      k = k + 1
31 b(i,k) = a(i,j)
end do
!
!     Insert zeros in the lower right corner
!
jmax = ml + mu + 1
if (k .eq. jmax) go to 50
jmin = k + 1
imin = imax
do j = jmin,jmax
   do 40 i = imin,imax
40 b(i,j) = 0.0
   imin = imin - 1
end do
!
!     Store zeros in the final m-imax rows
!
50 if (imax .eq. m) return
imin = imax + 1
do j = 1,jmax
   do 51 i = imin,m
51 b(i,j) = 0.0
end do
return
end subroutine cvrb

subroutine cvrb1 (a,ka,m,n,ml,mu,b,kb,nb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m
integer, intent(inout) :: ml, mu
integer, intent(in) :: n, nb
integer :: i, imax, imin, j, jmax, jmin, kmax, l, mm1, nm1
!-----------------------------------------------------------------------
!           Conversion of real matrices from standard
!                        to banded form
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(kb,nb)
!
!     Computation of ml and mu
!
nm1 = n - 1
imin = m
if (m .eq. 1) go to 20
do l = 2,m
   j = 1
   imax = min0(m,imin + nm1)
   do 10 i = imin,imax
      if (a(i,j) .ne. 0.0) go to 20
10 j = j + 1
   imin = imin - 1
end do
!
20 mm1 = m - 1
jmin = n
if (n .eq. 1) go to 30
do l = 2,n
   i = 1
   jmax = min0(n,jmin + mm1)
   do 21 j = jmin,jmax
      if (a(i,j) .ne. 0.0) go to 30
21 i = i + 1
   jmin = jmin - 1
end do
!
30 ml = imin - 1
mu = jmin - 1
kmax = ml + mu + 1
if (kmax .gt. nb) go to 40
!
!     Store the matrix in b
!
ierr = 0
call cvrb (a,ka,m,n,ml,mu,b,kb)
return
!
!     Error return
!
40 ierr = kmax
return
end subroutine cvrb1

subroutine cvbd (b,kb,m,n,ml,mu,a,ka)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imax0, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of double precision matrices from banded
!                         to standard form
!-----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,n)
double precision, intent(in) :: b(kb,*)
!
!     Store the nonzero data of the first ml rows
!
if (ml .eq. 0) go to 20
do i = 1,ml
   jmax = min0(n,i + mu)
   k = ml + 1 - i
   do 10 j = 1,jmax
      k = k + 1
10 a(i,j) = b(i,k)
end do
!
!     Store the remaining nonzero data
!
20 imin = ml + 1
imax = min0(m,ml + n)
l = 0
do i = imin,imax
   jmin = i - ml
   jmax = min0(n,i + mu)
   j = jmax
   do 21 jj = jmin,jmax
      k = j - l
      a(i,j) = b(i,k)
21 j = j - 1
   l = l + 1
end do
!
!     Insert zeros in the upper right corner
!
jmin = mu + 2
if (jmin .gt. n) go to 40
imax0 = 1
do j = jmin,n
   do 30 i = 1,imax0
30 a(i,j) = 0.d0
   imax0 = min0(imax,imax0 + 1)
end do
!
!     Insert zeros in the lower left corner
!
40 if (imin .eq. imax) go to 50
jmax = imax - imin
do j = 1,jmax
   imin = imin + 1
   do 41 i = imin,imax
41 a(i,j) = 0.d0
end do
!
!     Store zeros in the final m-imax rows
!
50 if (imax .eq. m) return
imin = imax + 1
do j = 1,n
   do 51 i = imin,m
51 a(i,j) = 0.d0
end do
return
end subroutine cvbd

subroutine cvdb (a,ka,m,n,ml,mu,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of double precision matrices from standard
!               to banded form when ml and mu are given
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,*)
!
!     Store the nonzero data of the first ml rows
!
if (ml .eq. 0) go to 30
l = ml
do i = 1,ml
   jmax = min0(n,i + mu)
   j = jmax
   do 10 jj = 1,jmax
      k = j + l
      b(i,k) = a(i,j)
10 j = j - 1
   l = l - 1
end do
!
!     Insert zeros in the upper left corner
!
imax = ml
do j = 1,ml
   do 20 i = 1,imax
20 b(i,j) = 0.d0
   imax = imax - 1
end do
!
!     Store the remaining nonzero data
!
30 imin = ml + 1
imax = min0(m,ml + n)
do i = imin,imax
   jmin = i - ml
   jmax = min0(n,i + mu)
   k = 0
   do 31 j = jmin,jmax
      k = k + 1
31 b(i,k) = a(i,j)
end do
!
!     Insert zeros in the lower right corner
!
jmax = ml + mu + 1
if (k .eq. jmax) go to 50
jmin = k + 1
imin = imax
do j = jmin,jmax
   do 40 i = imin,imax
40 b(i,j) = 0.d0
   imin = imin - 1
end do
!
!     Store zeros in the final m-imax rows
!
50 if (imax .eq. m) return
imin = imax + 1
do j = 1,jmax
   do 51 i = imin,m
51 b(i,j) = 0.d0
end do
return
end subroutine cvdb

subroutine cvdb1 (a,ka,m,n,ml,mu,b,kb,nb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m
integer, intent(inout) :: ml, mu
integer, intent(in) :: n, nb
integer :: i, imax, imin, j, jmax, jmin, kmax, l, mm1, nm1
!-----------------------------------------------------------------------
!        Conversion of double precision matrices from standard
!                         to banded form
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(kb,nb)
!
!     Computation of ml and mu
!
nm1 = n - 1
imin = m
if (m .eq. 1) go to 20
do l = 2,m
   j = 1
   imax = min0(m,imin + nm1)
   do 10 i = imin,imax
      if (a(i,j) .ne. 0.d0) go to 20
10 j = j + 1
   imin = imin - 1
end do
!
20 mm1 = m - 1
jmin = n
if (n .eq. 1) go to 30
do l = 2,n
   i = 1
   jmax = min0(n,jmin + mm1)
   do 21 j = jmin,jmax
      if (a(i,j) .ne. 0.d0) go to 30
21 i = i + 1
   jmin = jmin - 1
end do
!
30 ml = imin - 1
mu = jmin - 1
kmax = ml + mu + 1
if (kmax .gt. nb) go to 40
!
!     Store the matrix in b
!
ierr = 0
call cvdb (a,ka,m,n,ml,mu,b,kb)
return
!
!     Error return
!
40 ierr = kmax
return
end subroutine cvdb1

subroutine cvbc (b,kb,m,n,ml,mu,a,ka)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imax0, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!          Conversion of complex matrices from banded to
!                          standard form
!-----------------------------------------------------------------------
complex, intent(inout) :: a(ka,n)
complex, intent(in) :: b(kb,*)
!
!     Store the nonzero data of the first ml rows
!
if (ml .eq. 0) go to 20
do i = 1,ml
   jmax = min0(n,i + mu)
   k = ml + 1 - i
   do 10 j = 1,jmax
      k = k + 1
10 a(i,j) = b(i,k)
end do
!
!     Store the remaining nonzero data
!
20 imin = ml + 1
imax = min0(m,ml + n)
l = 0
do i = imin,imax
   jmin = i - ml
   jmax = min0(n,i + mu)
   j = jmax
   do 21 jj = jmin,jmax
      k = j - l
      a(i,j) = b(i,k)
21 j = j - 1
   l = l + 1
end do
!
!     Insert zeros in the upper right corner
!
jmin = mu + 2
if (jmin .gt. n) go to 40
imax0 = 1
do j = jmin,n
   do 30 i = 1,imax0
30 a(i,j) = (0.0,0.0)
   imax0 = min0(imax,imax0 + 1)
end do
!
!     Insert zeros in the lower left corner
!
40 if (imin .eq. imax) go to 50
jmax = imax - imin
do j = 1,jmax
   imin = imin + 1
   do 41 i = imin,imax
41 a(i,j) = (0.0,0.0)
end do
!
!     Store zeros in the final m-imax rows
!
50 if (imax .eq. m) return
imin = imax + 1
do j = 1,n
   do 51 i = imin,m
51 a(i,j) = (0.0,0.0)
end do
return
end subroutine cvbc

subroutine cvcb (a,ka,m,n,ml,mu,b,kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imin, j, jj, jmax, jmin, k, l
!-----------------------------------------------------------------------
!        Conversion of complex matrices from standard to banded
!                    form when ml and mu are given
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,*)
!
!     Store the nonzero data of the first ml rows
!
if (ml .eq. 0) go to 30
l = ml
do i = 1,ml
   jmax = min0(n,i + mu)
   j = jmax
   do 10 jj = 1,jmax
      k = j + l
      b(i,k) = a(i,j)
10 j = j - 1
   l = l - 1
end do
!
!     Insert zeros in the upper left corner
!
imax = ml
do j = 1,ml
   do 20 i = 1,imax
20 b(i,j) = (0.0,0.0)
   imax = imax - 1
end do
!
!     Store the remaining nonzero data
!
30 imin = ml + 1
imax = min0(m,ml + n)
do i = imin,imax
   jmin = i - ml
   jmax = min0(n,i + mu)
   k = 0
   do 31 j = jmin,jmax
      k = k + 1
31 b(i,k) = a(i,j)
end do
!
!     Insert zeros in the lower right corner
!
jmax = ml + mu + 1
if (k .eq. jmax) go to 50
jmin = k + 1
imin = imax
do j = jmin,jmax
   do 40 i = imin,imax
40 b(i,j) = (0.0,0.0)
   imin = imin - 1
end do
!
!     Store zeros in the final m-imax rows
!
50 if (imax .eq. m) return
imin = imax + 1
do j = 1,jmax
   do 51 i = imin,m
51 b(i,j) = (0.0,0.0)
end do
return
end subroutine cvcb

subroutine cvcb1 (a,ka,m,n,ml,mu,b,kb,nb,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, m
integer, intent(inout) :: ml, mu
integer, intent(in) :: n, nb
integer :: i, imax, imin, j, jmax, jmin, kmax, l, mm1, nm1
!-----------------------------------------------------------------------
!           Conversion of complex matrices from standard
!                          to banded form
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,n)
complex, intent(inout) :: b(kb,nb)
!
!     Computation of ml and mu
!
nm1 = n - 1
imin = m
if (m .eq. 1) go to 20
do l = 2,m
   j = 1
   imax = min0(m,imin + nm1)
   do 10 i = imin,imax
      if (a(i,j) .ne. (0.0,0.0)) go to 20
10 j = j + 1
   imin = imin - 1
end do
!
20 mm1 = m - 1
jmin = n
if (n .eq. 1) go to 30
do l = 2,n
   i = 1
   jmax = min0(n,jmin + mm1)
   do 21 j = jmin,jmax
      if (a(i,j) .ne. (0.0,0.0)) go to 30
21 i = i + 1
   jmin = jmin - 1
end do
!
30 ml = imin - 1
mu = jmin - 1
kmax = ml + mu + 1
if (kmax .gt. nb) go to 40
!
!     Store the matrix in b
!
ierr = 0
call cvcb (a,ka,m,n,ml,mu,b,kb)
return
!
!     Error return
!
40 ierr = kmax
return
end subroutine cvcb1

subroutine mcvbs (a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, ml, mu, n, num
integer :: i, imax, imin, j0, k, kmax, kmin, l, mp1
!-----------------------------------------------------------------------
!                Conversion of real matrices from banded
!                            to sparse form
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*)
real, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
kmax = ml + mu + 1
!
!     Store the nonzero data of the first ml rows
!
j0 = ml
if (ml .eq. 0) go to 20
do i = 1,ml
   ib(i) = l
   kmin = 1 + j0
   do 10 k = kmin,kmax
      if (a(i,k) .eq. 0.0) go to 10
      if (l .gt. num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
10 continue
   j0 = j0 - 1
end do
!
!     Store the remaining nonzero data
!
20 imin = ml + 1
imax = min0(m,ml + n)
do i = imin,imax
   ib(i) = l
   do 21 k = 1,kmax
      if (a(i,k) .eq. 0.0) go to 21
      if (l .gt. num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
21 continue
   j0 = j0 - 1
end do
ierr = 0
!
!     Set up the remaining m-imax rows
!
imin = imax + 1
mp1 = m + 1
do i = imin,mp1
   ib(i) = l
end do
return
!
!     Error return
!
40 ierr = i
return
end subroutine mcvbs

subroutine dmcvbs (a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, ml, mu, n, num
integer :: i, imax, imin, j0, k, kmax, kmin, l, mp1
!-----------------------------------------------------------------------
!          Conversion of double precision matrices from banded
!                            to sparse form
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*)
double precision, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
kmax = ml + mu + 1
!
!     Store the nonzero data of the first ml rows
!
j0 = ml
if (ml .eq. 0) go to 20
do i = 1,ml
   ib(i) = l
   kmin = 1 + j0
   do 10 k = kmin,kmax
      if (a(i,k) .eq. 0.d0) go to 10
      if (l .gt. num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
10 continue
   j0 = j0 - 1
end do
!
!     Store the remaining nonzero data
!
20 imin = ml + 1
imax = min0(m,ml + n)
do i = imin,imax
   ib(i) = l
   do 21 k = 1,kmax
      if (a(i,k) .eq. 0.d0) go to 21
      if (l .gt. num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
21 continue
   j0 = j0 - 1
end do
ierr = 0
!
!     Set up the remaining m-imax rows
!
imin = imax + 1
mp1 = m + 1
do i = imin,mp1
   ib(i) = l
end do
return
!
!     Error return
!
40 ierr = i
return
end subroutine dmcvbs

subroutine cmcvbs (a,ka,m,n,ml,mu,b,ib,jb,num,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, ml, mu, n, num
integer :: i, imax, imin, j0, k, kmax, kmin, l, mp1
!-----------------------------------------------------------------------
!              Conversion of complex matrices from banded
!                            to sparse form
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*)
complex, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
!
l = 1
kmax = ml + mu + 1
!
!     Store the nonzero data of the first ml rows
!
j0 = ml
if (ml .eq. 0) go to 20
do i = 1,ml
   ib(i) = l
   kmin = 1 + j0
   do 10 k = kmin,kmax
      if (a(i,k) .eq. (0.0,0.0)) go to 10
      if (l .gt. num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
10 continue
   j0 = j0 - 1
end do
!
!     Store the remaining nonzero data
!
20 imin = ml + 1
imax = min0(m,ml + n)
do i = imin,imax
   ib(i) = l
   do 21 k = 1,kmax
      if (a(i,k) .eq. (0.0,0.0)) go to 21
      if (l .gt. num) go to 40
      b(l) = a(i,k)
      jb(l) = k - j0
      l = l + 1
21 continue
   j0 = j0 - 1
end do
ierr = 0
!
!     Set up the remaining m-imax rows
!
imin = imax + 1
mp1 = m + 1
do i = imin,mp1
   ib(i) = l
end do
return
!
!     Error return
!
40 ierr = i
return
end subroutine cmcvbs

subroutine mcvsb (a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m
integer, intent(out) :: ml, mu
integer, intent(in) :: n, nb
integer :: i, j0, k, kmax, l, lmax, lmin
!-----------------------------------------------------------------------
!                Conversion of real matrices from sparse
!                            to banded form
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
real, intent(inout) :: b(kb,nb)
integer, intent(in) :: ia(*), ja(*)
!
!     Computation of ml and mu
!
ml = 0
mu = 0
do 11 i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin .gt. lmax) go to 11
   do 10 l = lmin,lmax
      if (a(l) .eq. 0.0) go to 10
      k = ja(l) - i
      mu = max0(mu,k)
      ml = max0(ml,-k)
10 continue
11 continue
!
!     SET b = 0 IF b PROVIDES SUFFICIENT STORAGE
!
kmax = ml + mu + 1
if (kmax .gt. nb) go to 40
!
ierr = 0
do k = 1,kmax
   do 20 i = 1,m
20 b(i,k) = 0.0
end do
!
!     Store the matrix in b
!
j0 = ml
do 31 i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin .gt. lmax) go to 31
   do 30 l = lmin,lmax
      if (a(l) .eq. 0.0) go to 30
      k = ja(l) + j0
      b(i,k) = a(l)
30 continue
   j0 = j0 - 1
31 continue
return
!
!     Error return
!
40 ierr = kmax
return
end subroutine mcvsb

subroutine dmcvsb (a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m
integer, intent(out) :: ml, mu
integer, intent(in) :: n, nb
integer :: i, j0, k, kmax, l, lmax, lmin
!-----------------------------------------------------------------------
!          Conversion of double precision matrices from sparse
!                            to banded form
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(kb,nb)
integer, intent(in) :: ia(*), ja(*)
!
!     Computation of ml and mu
!
ml = 0
mu = 0
do 11 i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin .gt. lmax) go to 11
   do 10 l = lmin,lmax
      if (a(l) .eq. 0.d0) go to 10
      k = ja(l) - i
      mu = max0(mu,k)
      ml = max0(ml,-k)
10 continue
11 continue
!
!     SET b = 0 IF b PROVIDES SUFFICIENT STORAGE
!
kmax = ml + mu + 1
if (kmax .gt. nb) go to 40
!
ierr = 0
do k = 1,kmax
   do 20 i = 1,m
20 b(i,k) = 0.d0
end do
!
!     Store the matrix in b
!
j0 = ml
do 31 i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin .gt. lmax) go to 31
   do 30 l = lmin,lmax
      if (a(l) .eq. 0.d0) go to 30
      k = ja(l) + j0
      b(i,k) = a(l)
30 continue
   j0 = j0 - 1
31 continue
return
!
!     Error return
!
40 ierr = kmax
return
end subroutine dmcvsb

subroutine cmcvsb (a,ia,ja,m,n,b,kb,nb,ml,mu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kb, m
integer, intent(out) :: ml, mu
integer, intent(in) :: n, nb
integer :: i, j0, k, kmax, l, lmax, lmin
!-----------------------------------------------------------------------
!              Conversion of complex matrices from sparse
!                            to banded form
!-----------------------------------------------------------------------
complex, intent(in) :: a(*)
complex, intent(inout) :: b(kb,nb)
integer, intent(in) :: ia(*), ja(*)
!
!     Computation of ml and mu
!
ml = 0
mu = 0
do 11 i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin .gt. lmax) go to 11
   do 10 l = lmin,lmax
      if (a(l) .eq. (0.0,0.0)) go to 10
      k = ja(l) - i
      mu = max0(mu,k)
      ml = max0(ml,-k)
10 continue
11 continue
!
!     SET b = 0 IF b PROVIDES SUFFICIENT STORAGE
!
kmax = ml + mu + 1
if (kmax .gt. nb) go to 40
!
ierr = 0
do k = 1,kmax
   do 20 i = 1,m
20 b(i,k) = (0.0,0.0)
end do
!
!     Store the matrix in b
!
j0 = ml
do 31 i = 1,m
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin .gt. lmax) go to 31
   do 30 l = lmin,lmax
      if (a(l) .eq. (0.0,0.0)) go to 30
      k = ja(l) + j0
      b(i,k) = a(l)
30 continue
   j0 = j0 - 1
31 continue
return
!
!     Error return
!
40 ierr = kmax
return
end subroutine cmcvsb

subroutine bcvrd (a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, j, num
!-----------------------------------------------------------------------
!        Conversion of banded matrices from single to double
!                          precision form
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*)
double precision, intent(inout) :: b(kb,*)
!
num = ml + mu + 1
do j = 1,num
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
return
end subroutine bcvrd

subroutine bcvdr (a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, j, num
!-----------------------------------------------------------------------
!        Conversion of banded matrices from double to single
!                          precision form
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,*)
!
num = ml + mu + 1
do j = 1,num
   do i = 1,m
      b(i,j) = a(i,j)
   end do
end do
return
end subroutine bcvdr

subroutine breal (a, ka, m, n, ml, mu, b, kb, l, nl, nu, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, l, m, ml, mu, n
integer, intent(out) :: nl
integer, intent(inout) :: nu
integer :: i, imin, j, k, num
!-----------------------------------------------------------------------
!              Real part of a banded complex matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,l)
!
!     Computation of nl and nu
!
nl = ml
if (ml .eq. 0) go to 30
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if (real(a(i,j)) .ne. 0.0) go to 30
   end do
   nl = nl - 1
   imin = imin - 1
end do
!
30 nu = mu
if (mu .eq. 0) go to 60
j = ml + mu + 1
do k = 1,mu
   do i = 1,m
      if (real(a(i,j)) .ne. 0.0) go to 60
   end do
   nu = nu - 1
   j = j - 1
end do
!
!     Store the real part of A in b
!
60 num = nl + nu + 1
if (num .gt. l) go to 100
ierr = 0
k = ml - nl
do j = 1,num
   k = k + 1
   do i = 1,m
      b(i,j) = real(a(i,k))
   end do
end do
return
!
!     Error return
!
100 ierr = num
return
end subroutine breal

subroutine bimag (a, ka, m, n, ml, mu, b, kb, l, nl, nu, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, l, m, ml, mu, n
integer, intent(out) :: nl
integer, intent(inout) :: nu
integer :: i, imin, j, k, num
!-----------------------------------------------------------------------
!            Imaginary part of a banded complex matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,l)
!
!     Computation of nl and nu
!
nl = ml
if (ml .eq. 0) go to 30
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if (aimag(a(i,j)) .ne. 0.0) go to 30
   end do
   nl = nl - 1
   imin = imin - 1
end do
!
30 nu = mu
if (mu .eq. 0) go to 60
j = ml + mu + 1
do k = 1,mu
   do i = 1,m
      if (aimag(a(i,j)) .ne. 0.0) go to 60
   end do
   nu = nu - 1
   j = j - 1
end do
!
!     Store the imaginary part of A in b
!
60 num = nl + nu + 1
if (num .gt. l) go to 100
ierr = 0
k = ml - nl
do j = 1,num
   k = k + 1
   do i = 1,m
      b(i,j) = aimag(a(i,k))
   end do
end do
return
!
!     Error return
!
100 ierr = num
return
end subroutine bimag

subroutine bcvrc (m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(out) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
integer :: i, j, ja, jb, jc, jmax, k, num
!-----------------------------------------------------------------------
!        Compute a + BI for the banded real matrices A and b
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,l)
!
mcl = max0(ml,nl)
mcu = max0(mu,nu)
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
ierr = 0
k = min0(mu,nu) + 1
!
!     Insert the first abs(ml - nl) diagonals
!
if (nl .ge. ml) go to 30
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
!
30 ja = 0
jb = nl - ml
jc = jb
jmax = ml + k
if (jc .eq. 0) go to 60
do j = 1,jc
   do i = 1,m
      c(i,j) = cmplx(0.0,b(i,j))
   end do
end do
!
!     Addition of the common diagonals
!
60 do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = cmplx(a(i,ja),b(i,jb))
   end do
end do
!
!     Insertion of the remaining diagonals
!
if (nu .ge. mu) go to 120
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = cmplx(a(i,ja),0.0)
   end do
end do
return
!
120 jmax = nu - mu
if (jmax .eq. 0) return
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = cmplx(0.0,b(i,jb))
   end do
end do
return
!
!     Error return
!
200 ierr = num
return
end subroutine bcvrc

subroutine bpose (a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imin, j, jmin, k, l, lj, lp1, ndiag
!-----------------------------------------------------------------------
!                Transposition of real banded matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*)
real, intent(inout) :: b(kb,*)
!
l = ml + mu + 1
lp1 = l + 1
if (mu .eq. 0) go to 40
!
!     Define the first mu columns of b
!
ndiag = mu
do 31 j = 1,mu
   do i = 1,ndiag
      b(i,j) = 0.0
   end do
!
   lj = lp1 - j
   imax = min0(m,n - ndiag)
   do i = 1,imax
      k = ndiag + i
      b(k,j) = a(i,lj)
   end do
!
   if (k .eq. n) go to 31
   imin = k + 1
   do i = imin,n
      b(i,j) = 0.0
   end do
31 ndiag = ndiag - 1
!
!     Define the remaining columns of b
!
40 jmin = mu + 1
ndiag = 0
do 61 j = jmin,l
   lj = lp1 - j
   imax = min0(m - ndiag,n)
   do i = 1,imax
      k = ndiag + i
      b(i,j) = a(k,lj)
   end do
!
   if (imax .eq. n) go to 61
   imin = imax + 1
   do i = imin,n
      b(i,j) = 0.0
   end do
61 ndiag = ndiag + 1
return
end subroutine bpose

subroutine dbpose (a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imin, j, jmin, k, l, lj, lp1, ndiag
!-----------------------------------------------------------------------
!          Transposition of double precision banded matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*)
double precision, intent(inout) :: b(kb,*)
!
l = ml + mu + 1
lp1 = l + 1
if (mu .eq. 0) go to 40
!
!     Define the first mu columns of b
!
ndiag = mu
do 31 j = 1,mu
   do i = 1,ndiag
      b(i,j) = 0.d0
   end do
!
   lj = lp1 - j
   imax = min0(m,n - ndiag)
   do i = 1,imax
      k = ndiag + i
      b(k,j) = a(i,lj)
   end do
!
   if (k .eq. n) go to 31
   imin = k + 1
   do i = imin,n
      b(i,j) = 0.d0
   end do
31 ndiag = ndiag - 1
!
!     Define the remaining columns of b
!
40 jmin = mu + 1
ndiag = 0
do 61 j = jmin,l
   lj = lp1 - j
   imax = min0(m - ndiag,n)
   do i = 1,imax
      k = ndiag + i
      b(i,j) = a(k,lj)
   end do
!
   if (imax .eq. n) go to 61
   imin = imax + 1
   do i = imin,n
      b(i,j) = 0.d0
   end do
61 ndiag = ndiag + 1
return
end subroutine dbpose

subroutine cbpose (a, ka, m, n, ml, mu, b, kb)
implicit none
integer, intent(in) :: ka, kb, m, ml, mu, n
integer :: i, imax, imin, j, jmin, k, l, lj, lp1, ndiag
!-----------------------------------------------------------------------
!              Transposition of complex banded matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*)
complex, intent(inout) :: b(kb,*)
!
l = ml + mu + 1
lp1 = l + 1
if (mu .eq. 0) go to 40
!
!     Define the first mu columns of b
!
ndiag = mu
do 31 j = 1,mu
   do i = 1,ndiag
      b(i,j) = (0.0,0.0)
   end do
!
   lj = lp1 - j
   imax = min0(m,n - ndiag)
   do i = 1,imax
      k = ndiag + i
      b(k,j) = a(i,lj)
   end do
!
   if (k .eq. n) go to 31
   imin = k + 1
   do i = imin,n
      b(i,j) = (0.0,0.0)
   end do
31 ndiag = ndiag - 1
!
!     Define the remaining columns of b
!
40 jmin = mu + 1
ndiag = 0
do 61 j = jmin,l
   lj = lp1 - j
   imax = min0(m - ndiag,n)
   do i = 1,imax
      k = ndiag + i
      b(i,j) = a(k,lj)
   end do
!
   if (imax .eq. n) go to 61
   imin = imax + 1
   do i = imin,n
      b(i,j) = (0.0,0.0)
   end do
61 ndiag = ndiag + 1
return
end subroutine cbpose

subroutine badd (m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num
!-----------------------------------------------------------------------
!                 Addition of real banded matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), b(kb,*)
real, intent(inout) :: c(kc,l)
!
ierr = 0
if (nl - ml) 10,30,20
!
!     Insert the first abs(ml - nl) diagonals
!
10 mcl = ml
if (ml .ge. l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do 11 i = 1,m
11 c(i,j) = a(i,j)
end do
go to 50
!
20 mcl = nl
if (nl .ge. l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do 21 i = 1,m
21 c(i,j) = b(i,j)
end do
go to 50
!
!     COMPUTE mcl WHEN ml = nl
!
30 mcl = ml
if (ml .eq. 0) go to 40
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if ((a(i,j) + b(i,j)) .ne. 0.0) go to 40
   end do
   mcl = mcl - 1
   imin = imin - 1
end do
!
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
!
50 if (nu - mu) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN mu .NE. nu
!
100 mcu = mu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
!
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do 120 i = 1,m
120 c(i,jc) = a(i,ja)
end do
return
!
130 mcu = nu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
!
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do 150 i = 1,m
150 c(i,jc) = b(i,jb)
end do
return
!
!     COMPUTE mcu WHEN mu = nu
!
160 mcu = mu
if (mu .eq. 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
do j = 1,mu
   do i = 1,m
      if ((a(i,la) + b(i,lb)) .ne. 0.0) go to 170
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do
!
!     ADDITION OF THE REMAINING COLUMNS WHEN mu = nu
!
170 num = mcl + mcu + 1
if (num .gt. l) go to 200
!
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
!
!     Error return
!
200 ierr = num
return
end subroutine badd

subroutine dbadd (m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num
!-----------------------------------------------------------------------
!           Addition of double precision banded matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*), b(kb,*)
double precision, intent(inout) :: c(kc,l)
!
ierr = 0
if (nl - ml) 10,30,20
!
!     Insert the first abs(ml - nl) diagonals
!
10 mcl = ml
if (ml .ge. l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do 11 i = 1,m
11 c(i,j) = a(i,j)
end do
go to 50
!
20 mcl = nl
if (nl .ge. l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do 21 i = 1,m
21 c(i,j) = b(i,j)
end do
go to 50
!
!     COMPUTE mcl WHEN ml = nl
!
30 mcl = ml
if (ml .eq. 0) go to 40
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if ((a(i,j) + b(i,j)) .ne. 0.d0) go to 40
   end do
   mcl = mcl - 1
   imin = imin - 1
end do
!
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
!
50 if (nu - mu) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN mu .NE. nu
!
100 mcu = mu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
!
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do 120 i = 1,m
120 c(i,jc) = a(i,ja)
end do
return
!
130 mcu = nu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
!
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do 150 i = 1,m
150 c(i,jc) = b(i,jb)
end do
return
!
!     COMPUTE mcu WHEN mu = nu
!
160 mcu = mu
if (mu .eq. 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
do j = 1,mu
   do i = 1,m
      if ((a(i,la) + b(i,lb)) .ne. 0.d0) go to 170
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do
!
!     ADDITION OF THE REMAINING COLUMNS WHEN mu = nu
!
170 num = mcl + mcu + 1
if (num .gt. l) go to 200
!
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
!
!     Error return
!
200 ierr = num
return
end subroutine dbadd

subroutine cbadd (m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num
!-----------------------------------------------------------------------
!                Addition of complex banded matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,l)
!
ierr = 0
if (nl - ml) 10,30,20
!
!     Insert the first abs(ml - nl) diagonals
!
10 mcl = ml
if (ml .ge. l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do 11 i = 1,m
11 c(i,j) = a(i,j)
end do
go to 50
!
20 mcl = nl
if (nl .ge. l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do 21 i = 1,m
21 c(i,j) = b(i,j)
end do
go to 50
!
!     COMPUTE mcl WHEN ml = nl
!
30 mcl = ml
if (ml .eq. 0) go to 40
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if ((a(i,j) + b(i,j)) .ne. (0.0,0.0)) go to 40
   end do
   mcl = mcl - 1
   imin = imin - 1
end do
!
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
!
50 if (nu - mu) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN mu .NE. nu
!
100 mcu = mu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
!
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do 120 i = 1,m
120 c(i,jc) = a(i,ja)
end do
return
!
130 mcu = nu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) + b(i,jb)
   end do
end do
!
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do 150 i = 1,m
150 c(i,jc) = b(i,jb)
end do
return
!
!     COMPUTE mcu WHEN mu = nu
!
160 mcu = mu
if (mu .eq. 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
do j = 1,mu
   do i = 1,m
      if ((a(i,la) + b(i,lb)) .ne. (0.0,0.0)) go to 170
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do
!
!     ADDITION OF THE REMAINING COLUMNS WHEN mu = nu
!
170 num = mcl + mcu + 1
if (num .gt. l) go to 200
!
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
!
!     Error return
!
200 ierr = num
return
end subroutine cbadd

subroutine bsubt (m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num
!-----------------------------------------------------------------------
!                Subtraction of real banded matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), b(kb,*)
real, intent(inout) :: c(kc,l)
!
ierr = 0
if (nl - ml) 10,30,20
!
!     Insert the first abs(ml - nl) diagonals
!
10 mcl = ml
if (ml .ge. l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do 11 i = 1,m
11 c(i,j) = a(i,j)
end do
go to 50
!
20 mcl = nl
if (nl .ge. l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do 21 i = 1,m
21 c(i,j) = -b(i,j)
end do
go to 50
!
!     COMPUTE mcl WHEN ml = nl
!
30 mcl = ml
if (ml .eq. 0) go to 40
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if ((a(i,j) - b(i,j)) .ne. 0.0) go to 40
   end do
   mcl = mcl - 1
   imin = imin - 1
end do
!
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
!
50 if (nu - mu) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN mu .NE. nu
!
100 mcu = mu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
!
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do 120 i = 1,m
120 c(i,jc) = a(i,ja)
end do
return
!
130 mcu = nu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
!
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do 150 i = 1,m
150 c(i,jc) = -b(i,jb)
end do
return
!
!     COMPUTE mcu WHEN mu = nu
!
160 mcu = mu
if (mu .eq. 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
do j = 1,mu
   do i = 1,m
      if ((a(i,la) - b(i,lb)) .ne. 0.0) go to 170
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do
!
!     ADDITION OF THE REMAINING COLUMNS WHEN mu = nu
!
170 num = mcl + mcu + 1
if (num .gt. l) go to 200
!
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
!
!     Error return
!
200 ierr = num
return
end subroutine bsubt

subroutine dbsubt (m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num
!-----------------------------------------------------------------------
!          Subtraction of double precision banded matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*), b(kb,*)
double precision, intent(inout) :: c(kc,l)
!
ierr = 0
if (nl - ml) 10,30,20
!
!     Insert the first abs(ml - nl) diagonals
!
10 mcl = ml
if (ml .ge. l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do 11 i = 1,m
11 c(i,j) = a(i,j)
end do
go to 50
!
20 mcl = nl
if (nl .ge. l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do 21 i = 1,m
21 c(i,j) = -b(i,j)
end do
go to 50
!
!     COMPUTE mcl WHEN ml = nl
!
30 mcl = ml
if (ml .eq. 0) go to 40
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if ((a(i,j) - b(i,j)) .ne. 0.d0) go to 40
   end do
   mcl = mcl - 1
   imin = imin - 1
end do
!
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
!
50 if (nu - mu) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN mu .NE. nu
!
100 mcu = mu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
!
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do 120 i = 1,m
120 c(i,jc) = a(i,ja)
end do
return
!
130 mcu = nu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
!
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do 150 i = 1,m
150 c(i,jc) = -b(i,jb)
end do
return
!
!     COMPUTE mcu WHEN mu = nu
!
160 mcu = mu
if (mu .eq. 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
do j = 1,mu
   do i = 1,m
      if ((a(i,la) - b(i,lb)) .ne. 0.d0) go to 170
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do
!
!     ADDITION OF THE REMAINING COLUMNS WHEN mu = nu
!
170 num = mcl + mcu + 1
if (num .gt. l) go to 200
!
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
!
!     Error return
!
200 ierr = num
return
end subroutine dbsubt

subroutine cbsubt (m,n,a,ka,ml,mu,b,kb,nl,nu,c,kc,l,mcl,mcu,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nl, nu
integer :: i, imin, j, ja, jb, jc, jmax, la, lb, num
!-----------------------------------------------------------------------
!             Subtraction of complex banded matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,l)
!
ierr = 0
if (nl - ml) 10,30,20
!
!     Insert the first abs(ml - nl) diagonals
!
10 mcl = ml
if (ml .ge. l) go to 50
ja = ml - nl
jb = 0
jc = ja
jmax = nl + 1
do j = 1,jc
   do 11 i = 1,m
11 c(i,j) = a(i,j)
end do
go to 50
!
20 mcl = nl
if (nl .ge. l) go to 50
ja = 0
jb = nl - ml
jc = jb
jmax = ml + 1
do j = 1,jc
   do 21 i = 1,m
21 c(i,j) = -b(i,j)
end do
go to 50
!
!     COMPUTE mcl WHEN ml = nl
!
30 mcl = ml
if (ml .eq. 0) go to 40
imin = ml + 1
do j = 1,ml
   do i = imin,m
      if ((a(i,j) - b(i,j)) .ne. (0.0,0.0)) go to 40
   end do
   mcl = mcl - 1
   imin = imin - 1
end do
!
40 ja = ml - mcl
jb = ja
jc = 0
jmax = mcl + 1
!
50 if (nu - mu) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN mu .NE. nu
!
100 mcu = mu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + nu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
!
jmax = mu - nu
do j = 1,jmax
   ja = ja + 1
   jc = jc + 1
   do 120 i = 1,m
120 c(i,jc) = a(i,ja)
end do
return
!
130 mcu = nu
num = mcl + mcu + 1
if (num .gt. l) go to 200
!
jmax = jmax + mu
do j = 1,jmax
   ja = ja + 1
   jb = jb + 1
   jc = jc + 1
   do i = 1,m
      c(i,jc) = a(i,ja) - b(i,jb)
   end do
end do
!
jmax = nu - mu
do j = 1,jmax
   jb = jb + 1
   jc = jc + 1
   do 150 i = 1,m
150 c(i,jc) = -b(i,jb)
end do
return
!
!     COMPUTE mcu WHEN mu = nu
!
160 mcu = mu
if (mu .eq. 0) go to 170
la = ml + mu + 1
lb = nl + nu + 1
do j = 1,mu
   do i = 1,m
      if ((a(i,la) - b(i,lb)) .ne. (0.0,0.0)) go to 170
   end do
   mcu = mcu - 1
   la = la - 1
   lb = lb - 1
end do
!
!     ADDITION OF THE REMAINING COLUMNS WHEN mu = nu
!
170 num = mcl + mcu + 1
if (num .gt. l) go to 200
!
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
!
!     Error return
!
200 ierr = num
return
end subroutine cbsubt

subroutine bprod (m, n, l, a, ka, ml, mu, b, kb, nl, nu, &
&c, kc, nc, mcl, mcu, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nc, nl, nu
integer :: i, imax, imj, j, jc, jj, jmax, jmi, k, kk, kmax, kmin, &
&last, maxd, mind, mlp1, ndiag, nlp1, npml, npnu
real :: sum
!-----------------------------------------------------------------------
!                Multiplication of real banded matrices
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), b(kb,*)
real, intent(inout) :: c(kc,nc)
!
ierr = 0
do j = 1,nc
   do 10 i = 1,m
10 c(i,j) = 0.0
end do
!
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min0(m - 1,ml + nl)
jc = 0
if (mcl .eq. 0) go to 100
!
!     Find the first nonzero lower diagonal
!
maxd = mcl
do ndiag = 1,maxd
   imj = maxd + 1 - ndiag
   jmax = min0(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,1) = sum
   end do
!
   do j = 1,jmax
      i = j + imj
      if (c(i,1) .ne. 0.0) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
!
40 if (mcl .ge. nc) go to 100
jc = 1
if (mcl .eq. 1) go to 100
!
!     Compute the remaining lower diagonals
!
mind = ndiag + 1
do ndiag = mind,maxd
   jc = jc + 1
   imj = maxd + 1 - ndiag
   jmax = min0(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
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
!
!     Find the last nonzero upper diagonal
!
100 jc = jc + 1
mcu = min0(l - 1,mu + nu)
if (mcu .eq. 0) go to 130
!
maxd = mcu
do ndiag = 1,maxd
   jmi = maxd + 1 - ndiag
   imax = min0(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
!
   do i = 1,imax
      if (c(i,jc) .ne. 0.0) go to 130
   end do
   mcu = mcu - 1
end do
!
130 last = mcl + mcu + 1
if (last .gt. nc) go to 200
if (mcu .eq. 0) go to 140
do i = 1,imax
   c(i,last) = c(i,jc)
   c(i,jc) = 0.0
end do
!
!     Compute the main diagonal and the remaining upper diagonals
!
140 maxd = max0(1,mcu)
do ndiag = 1,maxd
   jmi = ndiag - 1
   imax = min0(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
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
!
!     Error return
!
200 ierr = last
return
end subroutine bprod

subroutine dbprod (m, n, l, a, ka, ml, mu, b, kb, nl, nu, &
&c, kc, nc, mcl, mcu, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nc, nl, nu
integer :: i, imax, imj, j, jc, jj, jmax, jmi, k, kk, kmax, kmin, &
&last, maxd, mind, mlp1, ndiag, nlp1, npml, npnu
!-----------------------------------------------------------------------
!          Multiplication of double precision banded matrices
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*), b(kb,*)
double precision, intent(inout) :: c(kc,nc)
double precision :: sum
!
ierr = 0
do j = 1,nc
   do 10 i = 1,m
10 c(i,j) = 0.d0
end do
!
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min0(m - 1,ml + nl)
jc = 0
if (mcl .eq. 0) go to 100
!
!     Find the first nonzero lower diagonal
!
maxd = mcl
do ndiag = 1,maxd
   imj = maxd + 1 - ndiag
   jmax = min0(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.d0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,1) = sum
   end do
!
   do j = 1,jmax
      i = j + imj
      if (c(i,1) .ne. 0.d0) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
!
40 if (mcl .ge. nc) go to 100
jc = 1
if (mcl .eq. 1) go to 100
!
!     Compute the remaining lower diagonals
!
mind = ndiag + 1
do ndiag = mind,maxd
   jc = jc + 1
   imj = maxd + 1 - ndiag
   jmax = min0(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = 0.d0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
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
!
!     Find the last nonzero upper diagonal
!
100 jc = jc + 1
mcu = min0(l - 1,mu + nu)
if (mcu .eq. 0) go to 130
!
maxd = mcu
do ndiag = 1,maxd
   jmi = maxd + 1 - ndiag
   imax = min0(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.d0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
!
   do i = 1,imax
      if (c(i,jc) .ne. 0.d0) go to 130
   end do
   mcu = mcu - 1
end do
!
130 last = mcl + mcu + 1
if (last .gt. nc) go to 200
if (mcu .eq. 0) go to 140
do i = 1,imax
   c(i,last) = c(i,jc)
   c(i,jc) = 0.d0
end do
!
!     Compute the main diagonal and the remaining upper diagonals
!
140 maxd = max0(1,mcu)
do ndiag = 1,maxd
   jmi = ndiag - 1
   imax = min0(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = 0.d0
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
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
!
!     Error return
!
200 ierr = last
return
end subroutine dbprod

subroutine cbprod (m, n, l, a, ka, ml, mu, b, kb, nl, nu, &
&c, kc, nc, mcl, mcu, ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ka, kb, kc, l, m
integer, intent(inout) :: mcl, mcu
integer, intent(in) :: ml, mu, n, nc, nl, nu
integer :: i, imax, imj, j, jc, jj, jmax, jmi, k, kk, kmax, kmin, &
&last, maxd, mind, mlp1, ndiag, nlp1, npml, npnu
!-----------------------------------------------------------------------
!             Multiplication of complex banded matrices
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*), b(kb,*)
complex, intent(inout) :: c(kc,nc)
complex :: sum
!
ierr = 0
do j = 1,nc
   do 10 i = 1,m
10 c(i,j) = (0.0,0.0)
end do
!
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min0(m - 1,ml + nl)
jc = 0
if (mcl .eq. 0) go to 100
!
!     Find the first nonzero lower diagonal
!
maxd = mcl
do ndiag = 1,maxd
   imj = maxd + 1 - ndiag
   jmax = min0(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = (0.0,0.0)
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,1) = sum
   end do
!
   do j = 1,jmax
      i = j + imj
      if (c(i,1) .ne. (0.0,0.0)) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
!
40 if (mcl .ge. nc) go to 100
jc = 1
if (mcl .eq. 1) go to 100
!
!     Compute the remaining lower diagonals
!
mind = ndiag + 1
do ndiag = mind,maxd
   jc = jc + 1
   imj = maxd + 1 - ndiag
   jmax = min0(l,m - imj,npml - imj,npnu)
   do j = 1,jmax
      i = j + imj
      sum = (0.0,0.0)
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
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
!
!     Find the last nonzero upper diagonal
!
100 jc = jc + 1
mcu = min0(l - 1,mu + nu)
if (mcu .eq. 0) go to 130
!
maxd = mcu
do ndiag = 1,maxd
   jmi = maxd + 1 - ndiag
   imax = min0(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = (0.0,0.0)
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
      kk = mlp1 - i + kmin
      jj = nlp1 + j - kmin
      do k = kmin,kmax
         sum = sum + a(i,kk)*b(k,jj)
         kk = kk + 1
         jj = jj - 1
      end do
      c(i,jc) = sum
   end do
!
   do i = 1,imax
      if (c(i,jc) .ne. (0.0,0.0)) go to 130
   end do
   mcu = mcu - 1
end do
!
130 last = mcl + mcu + 1
if (last .gt. nc) go to 200
if (mcu .eq. 0) go to 140
do i = 1,imax
   c(i,last) = c(i,jc)
   c(i,jc) = (0.0,0.0)
end do
!
!     Compute the main diagonal and the remaining upper diagonals
!
140 maxd = max0(1,mcu)
do ndiag = 1,maxd
   jmi = ndiag - 1
   imax = min0(m,l - jmi,npml,npnu - jmi)
   do i = 1,imax
      j = i + jmi
      sum = (0.0,0.0)
      kmin = max0(1,i - ml,j - nu)
      kmax = min0(n,i + mu,j + nl)
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
!
!     Error return
!
200 ierr = last
return
end subroutine cbprod

subroutine bvprd (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, imin, jmin, k, kk, kmax, kmin, mlp1
real :: sum
!-----------------------------------------------------------------------
!         Product of a real banded matrix and a real vector
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), x(n)
real, intent(inout) :: y(m)
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml .eq. 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min0(n,i + mu)
   kk = jmin
   sum = 0.0
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!
!     Compute the remaining nonzero components
!
20 imax = min0(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min0(n,i + mu)
   kk = 1
   sum = 0.0
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
!
!     Store zeros in the final m-imax components
!
if (imax .eq. m) return
imin = imax + 1
do i = imin,m
   y(i) = 0.0
end do
return
end subroutine bvprd

subroutine bvprd1 (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, jmin, k, kk, kmax, kmin, mlp1
real :: sum
!-----------------------------------------------------------------------
!        SETTING y = a*x + y WHERE A IS A REAL BANDED MATRIX
!                     and x,y are real vectors
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), x(n)
real, intent(inout) :: y(m)
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml .eq. 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min0(n,i + mu)
   kk = jmin
   sum = y(i)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!
!     Compute the remaining components
!
20 imax = min0(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min0(n,i + mu)
   kk = 1
   sum = y(i)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
return
end subroutine bvprd1

subroutine dbvpd (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, imin, jmin, k, kk, kmax, kmin, mlp1
!-----------------------------------------------------------------------
!           Product of a double precision banded matrix
!                  and a double precision vector
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*), x(n)
double precision, intent(inout) :: y(m)
double precision :: sum
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml .eq. 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min0(n,i + mu)
   kk = jmin
   sum = 0.d0
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!
!     Compute the remaining nonzero components
!
20 imax = min0(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min0(n,i + mu)
   kk = 1
   sum = 0.d0
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
!
!     Store zeros in the final m-imax components
!
if (imax .eq. m) return
imin = imax + 1
do i = imin,m
   y(i) = 0.d0
end do
return
end subroutine dbvpd

subroutine dbvpd1 (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, jmin, k, kk, kmax, kmin, mlp1
!-----------------------------------------------------------------------
!         SETTING y = a*x + y WHERE A IS A DOUBLE PRECISION
!         banded matrix and x,y are double precision vectors
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*), x(n)
double precision, intent(inout) :: y(m)
double precision :: sum
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml .eq. 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min0(n,i + mu)
   kk = jmin
   sum = y(i)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!
!     Compute the remaining components
!
20 imax = min0(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min0(n,i + mu)
   kk = 1
   sum = y(i)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
return
end subroutine dbvpd1

subroutine cbvpd (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, imin, jmin, k, kk, kmax, kmin, mlp1
!-----------------------------------------------------------------------
!        Product of a complex banded matrix and a complex vector
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*), x(n)
complex, intent(inout) :: y(m)
complex :: sum
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml .eq. 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min0(n,i + mu)
   kk = jmin
   sum = (0.0,0.0)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!
!     Compute the remaining nonzero components
!
20 imax = min0(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min0(n,i + mu)
   kk = 1
   sum = (0.0,0.0)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
!
!     Store zeros in the final m-imax components
!
if (imax .eq. m) return
imin = imax + 1
do i = imin,m
   y(i) = (0.0,0.0)
end do
return
end subroutine cbvpd

subroutine cbvpd1 (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, jmin, k, kk, kmax, kmin, mlp1
!-----------------------------------------------------------------------
!        SETTING y = a*x + y WHERE A IS A COMPLEX BANDED MATRIX
!                     and x,y are complex vectors
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*), x(n)
complex, intent(inout) :: y(m)
complex :: sum
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml .eq. 0) go to 20
jmin = mlp1
do i = 1,ml
   kmax = min0(n,i + mu)
   kk = jmin
   sum = y(i)
   do k = 1,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
   jmin = jmin - 1
end do
!
!     Compute the remaining components
!
20 imax = min0(m,n + ml)
do i = mlp1,imax
   kmin = i - ml
   kmax = min0(n,i + mu)
   kk = 1
   sum = y(i)
   do k = kmin,kmax
      sum = sum + a(i,kk)*x(k)
      kk = kk + 1
   end do
   y(i) = sum
end do
return
end subroutine cbvpd1

subroutine btprd (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
real :: sum
!-----------------------------------------------------------------------
!         Product of a real vector and a real banded matrix
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), x(m)
real, intent(inout) :: y(n)
!
!     Compute the first mu components
!
if (mu .eq. 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min0(m,jj)
   sum = 0.0
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Compute the remaining nonzero components
!
20 num = ml + mu + 1
jmin = mu + 1
jmax = min0(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min0(m,j + ml)
   jj = num
   sum = 0.0
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Store zeros in the final n-jmax components
!
if (jmax .eq. n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = 0.0
end do
return
end subroutine btprd

subroutine btprd1 (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
real :: sum
!-----------------------------------------------------------------------
!        SETTING y = x*a + y WHERE A IS A REAL BANDED MATRIX
!                     and x,y are real vectors
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*), x(m)
real, intent(inout) :: y(n)
!
!     Compute the first mu components
!
if (mu .eq. 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min0(m,jj)
   sum = y(j)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Compute the remaining components
!
20 num = ml + mu + 1
jmin = mu + 1
jmax = min0(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min0(m,j + ml)
   jj = num
   sum = y(j)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
return
end subroutine btprd1

subroutine dbtpd (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
!-----------------------------------------------------------------------
!              Product of a double precision vector and
!                  a double precision banded matrix
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*), x(m)
double precision, intent(inout) :: y(n)
double precision :: sum
!
!     Compute the first mu components
!
if (mu .eq. 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min0(m,jj)
   sum = 0.d0
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Compute the remaining nonzero components
!
20 num = ml + mu + 1
jmin = mu + 1
jmax = min0(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min0(m,j + ml)
   jj = num
   sum = 0.d0
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Store zeros in the final n-jmax components
!
if (jmax .eq. n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = 0.d0
end do
return
end subroutine dbtpd

subroutine dbtpd1 (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
!-----------------------------------------------------------------------
!         SETTING y = x*a + y WHERE A IS A DOUBLE PRECISION
!         banded matrix and x,y are double precision vectors
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*), x(m)
double precision, intent(inout) :: y(n)
double precision :: sum
!
!     Compute the first mu components
!
if (mu .eq. 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min0(m,jj)
   sum = y(j)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Compute the remaining components
!
20 num = ml + mu + 1
jmin = mu + 1
jmax = min0(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min0(m,j + ml)
   jj = num
   sum = y(j)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
return
end subroutine dbtpd1

subroutine cbtpd (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
!-----------------------------------------------------------------------
!        Product of a complex vector and a complex banded matrix
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*), x(m)
complex, intent(inout) :: y(n)
complex :: sum
!
!     Compute the first mu components
!
if (mu .eq. 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min0(m,jj)
   sum = (0.0,0.0)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Compute the remaining nonzero components
!
20 num = ml + mu + 1
jmin = mu + 1
jmax = min0(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min0(m,j + ml)
   jj = num
   sum = (0.0,0.0)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Store zeros in the final n-jmax components
!
if (jmax .eq. n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = (0.0,0.0)
end do
return
end subroutine cbtpd

subroutine cbtpd1 (m,n,a,ka,ml,mu,x,y)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: j, jj, jmax, jmin, k, kmax, kmin, num
!-----------------------------------------------------------------------
!        SETTING y = x*a + y WHERE A IS A COMPLEX BANDED MATRIX
!                     and x,y are complex vectors
!-----------------------------------------------------------------------
complex, intent(in) :: a(ka,*), x(m)
complex, intent(inout) :: y(n)
complex :: sum
!
!     Compute the first mu components
!
if (mu .eq. 0) go to 20
do j = 1,mu
   jj = ml + j
   kmax = min0(m,jj)
   sum = y(j)
   do k = 1,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
!
!     Compute the remaining components
!
20 num = ml + mu + 1
jmin = mu + 1
jmax = min0(n,m + mu)
do j = jmin,jmax
   kmin = j - mu
   kmax = min0(m,j + ml)
   jj = num
   sum = y(j)
   do k = kmin,kmax
      sum = sum + a(k,jj)*x(k)
      jj = jj - 1
   end do
   y(j) = sum
end do
return
end subroutine cbtpd1

real function bnrm (a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, j, num
real :: sum
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                      real banded matrix a
!-----------------------------------------------------------------------
real, intent(in) :: a(ka,*)
!
num = ml + mu + 1
bnrm = 0.0
do i = 1,m
   sum = 0.0
   do j = 1,num
      sum = sum + abs(a(i,j))
   end do
   bnrm = amax1(bnrm, sum)
end do
return
end function bnrm

real function b1nrm (a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, imin, incr, j, jmax, jmin, num
real :: sasum
!-----------------------------------------------------------------------
!            Computation of the L1 norm of a banded matrix a
!-----------------------------------------------------------------------
real, intent(in) :: a(*)
!
incr = ka - 1
b1nrm = 0.0
!
!     Go down the first column of A
!
imin = ml + 1
imax = min0(m, imin + mu)
do i = imin,imax
   b1nrm = amax1(b1nrm, sasum(i,a(i),incr))
end do
i = imax
j = i - ml
num = i
if (j .eq. n) return
if (i .eq. m) go to 30
!
imin = i + 1
imax = min0(m, ml + n)
do i = imin,imax
   b1nrm = amax1(b1nrm, sasum(num,a(i),incr))
end do
i = imax
j = i - ml
go to 50
!
!     Proceed along the last row of A
!
30 jmax = mu + 1
if (j .eq. jmax) go to 50
jmin = j + 1
do j = jmin,jmax
   i = i + ka
   b1nrm = amax1(b1nrm, sasum(num,a(i),incr))
end do
j = jmax
!
50 if (j .eq. n .or. num .eq. 1) return
   i = i + ka
   j = j + 1
   num = num - 1
   b1nrm = amax1(b1nrm, sasum(num,a(i),incr))
   go to 50
end function b1nrm

double precision function dbnrm (a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, j, num
!-----------------------------------------------------------------------
!             Computation of the L-infinity norm of A
!                double precision banded matrix a
!-----------------------------------------------------------------------
double precision, intent(in) :: a(ka,*)
double precision :: sum
!
num = ml + mu + 1
dbnrm = 0.d0
do i = 1,m
   sum = 0.d0
   do j = 1,num
      sum = sum + dabs(a(i,j))
   end do
   dbnrm = dmax1(dbnrm, sum)
end do
return
end function dbnrm

double precision function db1nrm (a, ka, m, n, ml, mu)
implicit none
integer, intent(in) :: ka, m, ml, mu, n
integer :: i, imax, imin, incr, j, jmax, jmin, num
!-----------------------------------------------------------------------
!            Computation of the L1 norm of a double precision
!                            banded matrix a
!-----------------------------------------------------------------------
double precision, intent(in) :: a(*)
double precision :: dasum
!
incr = ka - 1
db1nrm = 0.d0
!
!     Go down the first column of A
!
imin = ml + 1
imax = min0(m, imin + mu)
do i = imin,imax
   db1nrm = dmax1(db1nrm, dasum(i,a(i),incr))
end do
i = imax
j = i - ml
num = i
if (j .eq. n) return
if (i .eq. m) go to 30
!
imin = i + 1
imax = min0(m, ml + n)
do i = imin,imax
   db1nrm = dmax1(db1nrm, dasum(num,a(i),incr))
end do
i = imax
j = i - ml
go to 50
!
!     Proceed along the last row of A
!
30 jmax = mu + 1
if (j .eq. jmax) go to 50
jmin = j + 1
do j = jmin,jmax
   i = i + ka
   db1nrm = dmax1(db1nrm, dasum(num,a(i),incr))
end do
j = jmax
!
50 if (j .eq. n .or. num .eq. 1) return
   i = i + ka
   j = j + 1
   num = num - 1
   db1nrm = dmax1(db1nrm, dasum(num,a(i),incr))
   go to 50
end function db1nrm

subroutine bslv(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
! ----------------------------------------------------------------------
!     bslv employs Gauss elimination with row interchanges to solve
!     THE NXN BANDED LINEAR SYSTEM AX = b. THE ARGUMENT m0 SPECIFIES
!     if bslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) AN LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     ON SUBSEQUENT CALLS (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED
!     using the decomposition obtained on the initial call to bslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n AND M.GE.2*ml+mu+1. THE FIRST ml+mu+1
!               columns contain the matrix a in banded form.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 IF THE SOLUTION OF AX = b IS OBTAINED.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to bslv, the routine may be recalled
!     WITH m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT
!     A,ka,n,ml,mu,iwk have not been modified. bslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     bslv AND SOLVES THE NEW EQUATIONS AX = b. IN THIS CASE ierr
!     is not referenced.
! ----------------------------------------------------------------------
real, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     Error checking
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     Obtain an LU decomposition of A
!
call snbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     Solve the system of equations
!
10 call snbsl(a,ka,n,ml,mu,iwk,b,0)
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine bslv

subroutine bslv1(m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
! ----------------------------------------------------------------------
!     bslv1 employs Gauss elimination with row interchanges to solve
!     THE NXN BANDED LINEAR SYSTEM XA = b. THE ARGUMENT m0 SPECIFIES
!     if bslv1 is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) AN LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     ON SUBSEQUENT CALLS (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED
!     using the decomposition obtained on the initial call to bslv1.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n AND M.GE.2*ml+mu+1. THE FIRST ml+mu+1
!               columns contain the matrix a in banded form.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 IF THE SOLUTION OF XA = b IS OBTAINED.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to bslv1, the routine may be recalled
!     WITH m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT
!     A,ka,n,ml,mu,iwk have not been modified. bslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     bslv1 AND SOLVES THE NEW EQUATIONS XA = b. IN THIS CASE ierr
!     is not referenced.
! ----------------------------------------------------------------------
real, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     Error checking
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     Obtain an LU decomposition of A
!
call snbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     Solve the system of equations
!
10 call snbsl(a,ka,n,ml,mu,iwk,b,1)
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine bslv1

subroutine snbfa (a, lda, n, ml, mu, ipvt, info)
implicit none
integer :: i, j, j1, jj, k, l, ldb, ll, lm, lm1, lm2, lmk, m, mb, &
&ml1, mp, n1
integer :: isamax
! ----------------------------------------------------------------------
!
!               snbfa factors a real band matrix BY elimination.
!
!                               --------
!     On entry
!
!        A       real(lda, NC)
!                contains the matrix in band storage. The rows
!                of the original matrix are stored in the rows
!                of A and the diagonals of the original matrix
!                are stored in columns 1 through ml+mu+1 of A.
!                NC MUST BE .GE. 2*ml+mu+1 .
!                See the comments below for details.
!
!        lda     INTEGER
!                the leading dimension of the array a. it is
!                ASSUMED THAT lda .GE. n.
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
!                MORE EFFICIENT IF ml .LE. mu .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                THE FACTORIZATION CAN BE WRITTEN  a = l*U  WHERE
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                =0  NORMAL VALUE
!                =k  IF  U(k,k) .EQ. 0. THIS IS NOT AN ERROR
!                condition for this subroutine, but it does
!                indicate that snbsl will divide by zero if
!                it is called.
!
!     Band storage
!
!           If A0 is the matrix THEN the following code will store
!           A0 in band form.
!
!                   ml = (BAND WIDTH BELOW THE DIAGONAL)
!                   mu = (BAND WIDTH ABOVE THE DIAGONAL)
!                   do 20 i = 1, n
!                      j1 = max0(1, i-ml)
!                      j2 = min0(n, i+mu)
!                      do 10 j = j1, j2
!                         k = j - i + ml + 1
!                         a(i,k) = a0(i,j)
!                10    continue
!                20 continue
!
!           This uses columns 1 through  ml + mu + 1  of A.
!           Furthermore, ml additional columns are needed in
!           A (starting with column  ml+mu+2) for elements
!           generated during the triangularization. The total
!           number of columns needed in A is  2*ml+mu+1 .
!
!     Example..  if the original matrix is
!
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!
!      THEN  n = 6, ml = 1, mu = 2, lda .GE. 6  AND A SHOULD CONTAIN
!
!              11 12 13  +     , + = USED FOR PIVOTING
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!
!     Written by E.A.Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H.Morris, naval surface weapons center.
!
!     Subroutines and functions
!        MIN0,isamax,saxpy,sscal,sswap
! ----------------------------------------------------------------------
integer, intent(in) :: lda, n, ml, mu
integer, intent(out) :: info
real, intent(inout) :: a(lda,*)
integer, intent(inout) :: ipvt(n)
real :: t
!
info = 0
if (ml .eq. 0) go to 100
m = ml + mu + 1
!
!     Set fill-in columns to zero
!
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = 0.0
   end do
end do
!
!     Gaussian elimination with partial pivoting
!
ml1 = ml + 1
mb = ml + mu
n1 = n - 1
ldb = lda - 1
do 40 k = 1,n1
  lm = min0(n-k,ml)
  lmk = lm + k
  lm1 = lm + 1
  lm2 = ml1 - lm
!
!     Search for pivot index
!
  l = -isamax(lm1, a(lmk,lm2), ldb) + lm1 + k
  ipvt(k) = l
  mp = min0(mb,n-k)
!
!     Swap rows if necessary
!
  ll = ml1 + k - l
  if (l .ne. k) call sswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!
!     Skip column reduction if pivot is zero
!
  if (a(k,ml1) .ne. 0.0) go to 20
     info = k
     go to 40
!
!     Compute multipliers
!
20 t = -1.0/a(k,ml1)
  call sscal(lm, t, a(lmk,lm2), ldb)
!
!     Row elimination with column indexing
!
  do j = 1,mp
     jj = ml1 + j
     j1 = lm2 + j
     call saxpy(lm, a(k,jj), a(lmk,lm2), ldb, a(lmk,j1), ldb)
  end do
40 continue
!
ipvt(n) = n
if (a(n,ml1) .eq. 0.0) info = n
return
!
!     CASE WHEN ml = 0
!
100 do k = 1,n
  ipvt(k) = k
  if (a(k,1) .eq. 0.0) info = k
end do
return
end subroutine snbfa

subroutine snbsl (a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer :: ml1, ml2
! ----------------------------------------------------------------------
!
!     snbsl SOLVES THE REAL BAND SYSTEM a*X = b OR TRANS(a)*X = b
!     using the factors computed by snbfa.
!
!                         ----------
!     On entry
!
!        A       real(lda, NC)
!                the output from snbfa.
!                NC MUST BE .GE. 2*ml+mu+1 .
!
!        lda     INTEGER
!                the leading dimension of the array a.
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
!                the pivot vector from snbfa.
!
!        b       real(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  a*X = b .
!                = NONZERO   TO SOLVE  TRANS(a)*X = b , WHERE
!                            TRANS(a)  is the transpose.
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
!        setting of lda.  It will not occur if snbfa and snbsl are
!        CALLED CORRECTLY AND snbfa HAS SET INFO = 0.
!
!     Written by E.A. Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H. Morris, naval surface weapons center.
!
!     Subroutines and functions
!      saxpy,sdot
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
integer, intent(in) :: lda, n, ml, mu, job
real, intent(in) :: a(lda,*)
real, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
real :: sdot, t
integer :: k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
!
m = mu + ml + 1
if (m .eq. 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job .ne. 0) go to 50
!
!     job = 0 , SOLVE  a * X = b
!       FIRST SOLVE l*Y = b
!
if (ml .eq. 0) go to 30
do k = 1,nm1
   lm = min0(ml,n-k)
   l = ipvt(k)
   t = b(l)
   if (l .eq. k) go to 10
      b(l) = b(k)
      b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call saxpy(lm, t, a(klm,mlm), ldb, b(k+1), 1)
end do
!
!       NOW SOLVE  U*X = Y
!
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min0(k,m) - 1
   lb = k - lm
   t = -b(k)
   call saxpy(lm, t, a(k-1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       FIRST SOLVE  TRANS(U)*Y = b
!
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min0(k,m) - 1
   lb = k - lm
   t = sdot(lm, a(k-1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml .eq. 0) return
!
!       NOW SOLVE TRANS(l)*X = Y
!
do 70 kb = 1,nm1
   k = n - kb
   lm = min0(ml,n-k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + sdot(lm, a(klm,mlm), ldb, b(k+1), 1)
   l = ipvt(k)
   if (l .eq. k) go to 70
      t = b(l)
      b(l) = b(k)
      b(k) = t
70 continue
return
!
!     CASE WHEN ml = 0 AND mu = 0
!
100 do 110 k = 1,n
110 b(k) = b(k)/a(k,1)
return
end subroutine snbsl

subroutine dbslv (m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
! ----------------------------------------------------------------------
!     dbslv employs Gauss elimination with row interchanges to solve
!     THE NXN BANDED LINEAR SYSTEM AX = b. THE ARGUMENT m0 SPECIFIES
!     if dbslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) AN LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     ON SUBSEQUENT CALLS (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED
!     using the decomposition obtained on the initial call to dbslv.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n AND M.GE.2*ml+mu+1. THE FIRST ml+mu+1
!               columns contain the matrix a in banded form.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 IF THE SOLUTION OF AX = b IS OBTAINED.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to dbslv, the routine may be recalled
!     WITH m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT
!     A,ka,n,ml,mu,iwk have not been modified. dbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     dbslv AND SOLVES THE NEW EQUATIONS AX = b. IN THIS CASE ierr
!     is not referenced.
! ----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     Error checking
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     Obtain an LU decomposition of A
!
call dbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     Solve the system of equations
!
10 call dbsl(a,ka,n,ml,mu,iwk,b,0)
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine dbslv

subroutine dbslv1 (m0,a,ka,n,ml,mu,b,iwk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m0, ml, mu, n
! ----------------------------------------------------------------------
!     dbslv1 employs Gauss elimination with row interchanges to solve
!     THE NXN BANDED LINEAR SYSTEM XA = b. THE ARGUMENT m0 SPECIFIES
!     if dbslv1 is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN m0=0) AN LU DECOMPO-
!     sition of A is obtained and then the equations are solved.
!     ON SUBSEQUENT CALLS (WHEN m0.NE.0) THE EQUATIONS ARE SOLVED
!     using the decomposition obtained on the initial call to dbslv1.
!
!
!     INPUT ARGUMENTS WHEN m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n AND M.GE.2*ml+mu+1. THE FIRST ml+mu+1
!               columns contain the matrix a in banded form.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!               side data.
!
!
!     OUTPUT ARGUMENTS WHEN m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 IF THE SOLUTION OF XA = b IS OBTAINED.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to dbslv1, the routine may be recalled
!     WITH m0.NE.0 FOR A NEW b. WHEN m0.NE.0 IT IS ASSUMED THAT
!     A,ka,n,ml,mu,iwk have not been modified. dbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     dbslv1 AND SOLVES THE NEW EQUATIONS XA = b. IN THIS CASE ierr
!     is not referenced.
! ----------------------------------------------------------------------
double precision, intent(inout) :: a(ka,*), b(n)
integer, intent(inout) :: iwk(n)
if (m0 .ne. 0) go to 10
!
!     Error checking
!
if (n .le. 0 .or. n .gt. ka) go to 100
if (ml .lt. 0 .or. ml .ge. n) go to 110
if (mu .lt. 0 .or. mu .ge. n) go to 120
!
!     Obtain an LU decomposition of A
!
call dbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr .ne. 0) return
!
!     Solve the system of equations
!
10 call dbsl(a,ka,n,ml,mu,iwk,b,1)
return
!
!     Error return
!
100 ierr = -1
return
110 ierr = -2
return
120 ierr = -3
return
end subroutine dbslv1

subroutine dbfa (a, lda, n, ml, mu, ipvt, info)
implicit none
integer :: i, j, j1, jj, k, l, ldb, ll, lm, lm1, lm2, lmk, m, mb, &
&ml1, mp, n1
integer :: idamax
! ----------------------------------------------------------------------
!
!               dbfa factors a real band matrix BY elimination.
!
!                               --------
!     On entry
!
!        A       DOUBLE PRECISION(lda, NC)
!                contains the matrix in band storage. The rows
!                of the original matrix are stored in the rows
!                of A and the diagonals of the original matrix
!                are stored in columns 1 through ml+mu+1 of A.
!                NC MUST BE .GE. 2*ml+mu+1 .
!                See the comments below for details.
!
!        lda     INTEGER
!                the leading dimension of the array a. it is
!                ASSUMED THAT lda .GE. n.
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
!                MORE EFFICIENT IF ml .LE. mu .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                THE FACTORIZATION CAN BE WRITTEN  a = l*U  WHERE
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                =0  NORMAL VALUE
!                =k  IF  U(k,k) .EQ. 0. THIS IS NOT AN ERROR
!                condition for this subroutine, but it does
!                indicate that dbsl will divide by zero if
!                it is called.
!
!     Band storage
!
!           If A0 is the matrix THEN the following code will store
!           A0 in band form.
!
!                   ml = (BAND WIDTH BELOW THE DIAGONAL)
!                   mu = (BAND WIDTH ABOVE THE DIAGONAL)
!                   do 20 i = 1, n
!                      j1 = max0(1, i-ml)
!                      j2 = min0(n, i+mu)
!                      do 10 j = j1, j2
!                         k = j - i + ml + 1
!                         a(i,k) = a0(i,j)
!                10    continue
!                20 continue
!
!           This uses columns 1 through  ml + mu + 1  of A.
!           Furthermore, ml additional columns are needed in
!           A (starting with column  ml+mu+2) for elements
!           generated during the triangularization. The total
!           number of columns needed in A is  2*ml+mu+1 .
!
!     Example..  if the original matrix is
!
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!
!      THEN  n = 6, ml = 1, mu = 2, lda .GE. 6  AND A SHOULD CONTAIN
!
!              11 12 13  +     , + = USED FOR PIVOTING
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!
!     Written by E.A.Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H.Morris, naval surface weapons center.
!
!     Subroutines and functions
!        MIN0,idamax,daxpy,dscal,dswap
! ----------------------------------------------------------------------
integer, intent(in) :: lda, n, ml, mu
integer, intent(out) :: info
double precision, intent(inout) :: a(lda,*)
integer, intent(inout) :: ipvt(n)
double precision :: t
!
info = 0
if (ml .eq. 0) go to 100
m = ml + mu + 1
!
!     Set fill-in columns to zero
!
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = 0.d0
   end do
end do
!
!     Gaussian elimination with partial pivoting
!
ml1 = ml + 1
mb = ml + mu
n1 = n - 1
ldb = lda - 1
do 40 k = 1,n1
  lm = min0(n-k,ml)
  lmk = lm + k
  lm1 = lm + 1
  lm2 = ml1 - lm
!
!     Search for pivot index
!
  l = -idamax(lm1, a(lmk,lm2), ldb) + lm1 + k
  ipvt(k) = l
  mp = min0(mb,n-k)
!
!     Swap rows if necessary
!
  ll = ml1 + k - l
  if (l .ne. k) call dswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!
!     Skip column reduction if pivot is zero
!
  if (a(k,ml1) .ne. 0.d0) go to 20
     info = k
     go to 40
!
!     Compute multipliers
!
20 t = -1.d0/a(k,ml1)
  call dscal(lm, t, a(lmk,lm2), ldb)
!
!     Row elimination with column indexing
!
  do j = 1,mp
     jj = ml1 + j
     j1 = lm2 + j
     call daxpy(lm, a(k,jj), a(lmk,lm2), ldb, a(lmk,j1), ldb)
  end do
40 continue
!
ipvt(n) = n
if (a(n,ml1) .eq. 0.d0) info = n
return
!
!     CASE WHEN ml = 0
!
100 do k = 1,n
  ipvt(k) = k
  if (a(k,1) .eq. 0.d0) info = k
end do
return
end subroutine dbfa

