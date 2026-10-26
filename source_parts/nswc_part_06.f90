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
!
ierr = 0
do j = 1,nc
   do 10 i = 1,m
10    c(i,j) = 0.0
end do
!
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min0(m - 1,ml + nl)
jc = 0
if (mcl == 0) go to 100
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
      if (c(i,1) /= 0.0) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
!
40 if (mcl >= nc) go to 100
jc = 1
if (mcl == 1) go to 100
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
if (mcu == 0) go to 130
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
      if (c(i,jc) /= 0.0) go to 130
   end do
   mcu = mcu - 1
end do
!
130 last = mcl + mcu + 1
if (last > nc) go to 200
if (mcu == 0) go to 140
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
!
ierr = 0
do j = 1,nc
   do 10 i = 1,m
10    c(i,j) = 0.d0
end do
!
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min0(m - 1,ml + nl)
jc = 0
if (mcl == 0) go to 100
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
      if (c(i,1) /= 0.d0) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
!
40 if (mcl >= nc) go to 100
jc = 1
if (mcl == 1) go to 100
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
if (mcu == 0) go to 130
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
      if (c(i,jc) /= 0.d0) go to 130
   end do
   mcu = mcu - 1
end do
!
130 last = mcl + mcu + 1
if (last > nc) go to 200
if (mcu == 0) go to 140
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
!
ierr = 0
do j = 1,nc
   do 10 i = 1,m
10    c(i,j) = (0.0,0.0)
end do
!
mlp1 = ml + 1
nlp1 = nl + 1
npml = n + ml
npnu = n + nu
mcl = min0(m - 1,ml + nl)
jc = 0
if (mcl == 0) go to 100
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
      if (c(i,1) /= (0.0,0.0)) go to 40
   end do
   mcl = mcl - 1
end do
go to 100
!
40 if (mcl >= nc) go to 100
jc = 1
if (mcl == 1) go to 100
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
if (mcu == 0) go to 130
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
      if (c(i,jc) /= (0.0,0.0)) go to 130
   end do
   mcu = mcu - 1
end do
!
130 last = mcl + mcu + 1
if (last > nc) go to 200
if (mcu == 0) go to 140
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
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml == 0) go to 20
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
if (imax == m) return
imin = imax + 1
do i = imin,m
   y(i) = 0.0
end do
return
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
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml == 0) go to 20
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
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml == 0) go to 20
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
if (imax == m) return
imin = imax + 1
do i = imin,m
   y(i) = 0.d0
end do
return
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
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml == 0) go to 20
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
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml == 0) go to 20
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
if (imax == m) return
imin = imax + 1
do i = imin,m
   y(i) = (0.0,0.0)
end do
return
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
!
!     Compute the first ml components
!
mlp1 = ml + 1
if (ml == 0) go to 20
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
!
!     Compute the first mu components
!
if (mu == 0) go to 20
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
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = 0.0
end do
return
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
!
!     Compute the first mu components
!
if (mu == 0) go to 20
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
!
!     Compute the first mu components
!
if (mu == 0) go to 20
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
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = 0.d0
end do
return
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
!
!     Compute the first mu components
!
if (mu == 0) go to 20
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
!
!     Compute the first mu components
!
if (mu == 0) go to 20
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
if (jmax == n) return
jmin = jmax + 1
do j = jmin,n
   y(j) = (0.0,0.0)
end do
return
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
!
!     Compute the first mu components
!
if (mu == 0) go to 20
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
if (j == n) return
if (i == m) go to 30
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
if (j == jmax) go to 50
jmin = j + 1
do j = jmin,jmax
   i = i + ka
   b1nrm = amax1(b1nrm, sasum(num,a(i),incr))
end do
j = jmax
!
50 if (j == n .or. num == 1) return
i = i + ka
j = j + 1
num = num - 1
b1nrm = amax1(b1nrm, sasum(num,a(i),incr))
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
if (j == n) return
if (i == m) go to 30
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
if (j == jmax) go to 50
jmin = j + 1
do j = jmin,jmax
   i = i + ka
   db1nrm = dmax1(db1nrm, dasum(num,a(i),incr))
end do
j = jmax
!
50 if (j == n .or. num == 1) return
i = i + ka
j = j + 1
num = num - 1
db1nrm = dmax1(db1nrm, dasum(num,a(i),incr))
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
!
!
!     Input arguments when m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
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
!     Output arguments when m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of AX = b is obtained.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to bslv, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. bslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     bslv and solves the new equations AX = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!
!     Error checking
!
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!
!     Obtain an LU decomposition of A
!
call snbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
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
!
!
!     Input arguments when m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
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
!     Output arguments when m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of XA = b is obtained.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to bslv1, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. bslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     bslv1 and solves the new equations XA = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!
!     Error checking
!
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!
!     Obtain an LU decomposition of A
!
call snbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
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
!                assumed that lda .GE. n.
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
!                More efficient if ml .LE. mu .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                =0  Normal value
!                =k  if  U(k,k) .EQ. 0. this is not an error
!                condition for this subroutine, but it does
!                indicate that snbsl will divide by zero if
!                it is called.
!
!     Band storage
!
!           If A0 is the matrix THEN the following code will store
!           A0 in band form.
!
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
!      Then  n = 6, ml = 1, mu = 2, lda .GE. 6  and A should contain
!
!              11 12 13  +     , + = Used for pivoting
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
!
info = 0
if (ml == 0) go to 100
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
   lm = min0(n - k,ml)
   lmk = lm + k
   lm1 = lm + 1
   lm2 = ml1 - lm
!
!     Search for pivot index
!
   l = -isamax(lm1, a(lmk,lm2), ldb) + lm1 + k
   ipvt(k) = l
   mp = min0(mb,n - k)
!
!     Swap rows if necessary
!
   ll = ml1 + k - l
   if (l /= k) call sswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!
!     Skip column reduction if pivot is zero
!
   if (a(k,ml1) /= 0.0) go to 20
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
if (a(n,ml1) == 0.0) info = n
return
!
!     Case when ml = 0
!
100 do k = 1,n
   ipvt(k) = k
   if (a(k,1) == 0.0) info = k
end do
return
end subroutine snbfa

pure subroutine snbsl(a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, job
real, intent(in) :: a(lda,*)
real, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
integer :: ml1, ml2
real :: t
integer :: k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
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
!
!     snbsl solves the real band system a*X = b or trans(a)*X = b
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
!                = 0         To solve  a*X = b .
!                = Nonzero   to solve  trans(a)*X = b , where
!                            trans(a)  is the transpose.
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
!        called correctly and snbfa has set info = 0.
!
!     Written by E.A. Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H. Morris, naval surface weapons center.
!
!     Subroutines and functions
!      saxpy,sdot
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
!
m = mu + ml + 1
if (m == 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job /= 0) go to 50
!
!     job = 0 , SOLVE  a * X = b
!       first solve l*Y = b
!
if (ml == 0) go to 30
do k = 1,nm1
   lm = min0(ml,n - k)
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call saxpy(lm, t, a(klm,mlm), ldb, b(k + 1), 1)
end do
!
!       Now solve  U*X = Y
!
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min0(k,m) - 1
   lb = k - lm
   t = -b(k)
   call saxpy(lm, t, a(k - 1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       first solve  trans(U)*Y = b
!
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min0(k,m) - 1
   lb = k - lm
   t = sdot(lm, a(k - 1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml == 0) return
!
!       Now solve trans(l)*X = Y
!
do 70 kb = 1,nm1
   k = n - kb
   lm = min0(ml,n - k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + sdot(lm, a(klm,mlm), ldb, b(k + 1), 1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
return
!
!     Case when ml = 0 And mu = 0
!
100 do 110 k = 1,n
110 b(k) = b(k)/a(k,1)
return
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
!
!
!     Input arguments when m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
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
!     Output arguments when m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of AX = b is obtained.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to dbslv, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. dbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     dbslv and solves the new equations AX = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!
!     Error checking
!
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!
!     Obtain an LU decomposition of A
!
call dbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
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
!
!
!     Input arguments when m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
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
!     Output arguments when m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of XA = b is obtained.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to dbslv1, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. dbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     dbslv1 and solves the new equations XA = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!
!     Error checking
!
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!
!     Obtain an LU decomposition of A
!
call dbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
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
!                assumed that lda .GE. n.
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
!                More efficient if ml .LE. mu .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                =0  Normal value
!                =k  if  U(k,k) .EQ. 0. this is not an error
!                condition for this subroutine, but it does
!                indicate that dbsl will divide by zero if
!                it is called.
!
!     Band storage
!
!           If A0 is the matrix THEN the following code will store
!           A0 in band form.
!
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
!      Then  n = 6, ml = 1, mu = 2, lda .GE. 6  and A should contain
!
!              11 12 13  +     , + = Used for pivoting
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
!
info = 0
if (ml == 0) go to 100
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
   lm = min0(n - k,ml)
   lmk = lm + k
   lm1 = lm + 1
   lm2 = ml1 - lm
!
!     Search for pivot index
!
   l = -idamax(lm1, a(lmk,lm2), ldb) + lm1 + k
   ipvt(k) = l
   mp = min0(mb,n - k)
!
!     Swap rows if necessary
!
   ll = ml1 + k - l
   if (l /= k) call dswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!
!     Skip column reduction if pivot is zero
!
   if (a(k,ml1) /= 0.d0) go to 20
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
if (a(n,ml1) == 0.d0) info = n
return
!
!     Case when ml = 0
!
100 do k = 1,n
   ipvt(k) = k
   if (a(k,1) == 0.d0) info = k
end do
return
end subroutine dbfa

pure subroutine dbsl(a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, job
double precision, intent(in) :: a(lda,*)
double precision, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
integer :: ml1, ml2
double precision :: t
integer :: k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
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
!
!     dbsl solves the real band system a*X = b or trans(a)*X = b
!     using the factors computed by dbfa.
!
!                         ----------
!     On entry
!
!        A       DOUBLE PRECISION(lda, NC)
!                the output from dbfa.
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
!                the pivot vector from dbfa.
!
!        b       DOUBLE PRECISION(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         To solve  a*X = b .
!                = Nonzero   to solve  trans(a)*X = b , where
!                            trans(a)  is the transpose.
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
!        setting of lda.  It will not occur if dbfa and dbsl are
!        called correctly and dbfa has set info = 0.
!
!     Written by E.A. Voorhees, Los Alamos scientific laboratory.
!     Modified by A.H. Morris, naval surface weapons center.
!
!     Subroutines and functions
!      daxpy,ddot
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
!
m = mu + ml + 1
if (m == 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job /= 0) go to 50
!
!     job = 0 , SOLVE  a * X = b
!       first solve l*Y = b
!
if (ml == 0) go to 30
do k = 1,nm1
   lm = min0(ml,n - k)
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call daxpy(lm, t, a(klm,mlm), ldb, b(k + 1), 1)
end do
!
!       Now solve  U*X = Y
!
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min0(k,m) - 1
   lb = k - lm
   t = -b(k)
   call daxpy(lm, t, a(k - 1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       first solve  trans(U)*Y = b
!
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min0(k,m) - 1
   lb = k - lm
   t = ddot(lm, a(k - 1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml == 0) return
!
!       Now solve trans(l)*X = Y
!
do 70 kb = 1,nm1
   k = n - kb
   lm = min0(ml,n - k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + ddot(lm, a(klm,mlm), ldb, b(k + 1), 1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
return
!
!     Case when ml = 0 And mu = 0
!
100 do 110 k = 1,n
110 b(k) = b(k)/a(k,1)
return
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
!
anorm = b1nrm(a, ka, n, n, ml, mu)
if (anorm == 0.0) go to 40
!
ix = 1
iv = n + 1
isgn = n + 1
!
kase = 0
ainorm = 0.0
call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call bslv(0, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
!
!     Check if A is singular
!
if (ierr > 0) go to 40
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
10 call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 30
if (kase /= 1) go to 20
call bslv(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
20 call bslv1(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
!
!     Compute the value of cond
!
30 cond = anorm*ainorm
return
!
!     Singular case
!
40 ierr = 1
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
!
anorm = db1nrm(a, ka, n, n, ml, mu)
if (anorm == 0.d0) go to 40
!
ix = 1
iv = n + 1
isgn = n + 1
!
kase = 0
ainorm = 0.d0
call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call dbslv(0, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
!
!     Check if A is singular
!
if (ierr > 0) go to 40
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
10 call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
if (kase == 0) go to 30
if (kase /= 1) go to 20
call dbslv(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
20 call dbslv1(1, a, ka, n, ml, mu, wk(ix), iwk(1), ierr)
go to 10
!
!     Compute the value of cond
!
30 cond = anorm*ainorm
return
!
!     Singular case
!
40 ierr = 1
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
!
!
!     Input arguments when m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!               A is a complex array.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT
!               hand side data.
!
!
!     Output arguments when m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of AX = b is obtained.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to cbslv, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. cbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     cbslv and solves the new equations AX = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!
!     Error checking
!
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!
!     Obtain an LU decomposition of A
!
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!
!     Solve the system of equations
!
10 call cbsl(a,ka,n,ml,mu,iwk,b,0)
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
!
!
!     Input arguments when m0=0 ---
!
!     A,ka      2-DIMENSIONAL ARRAY OF DIMENSION (ka,M) WHERE
!               ka.GE.n and M.GE.2*ml+mu+1. The first ml+mu+1
!               columns contain the matrix a in banded form.
!               A is a complex array.
!
!     n         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ml        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     mu        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     b         COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT
!               hand side data.
!
!
!     Output arguments when m0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               the multipliers which were used to obtain it.
!
!     b         THE SOLUTION OF THE EQUATIONS.
!
!     iwk       ARRAY OF LENGTH n CONTAINING THE PIVOT INDICES.
!
!     ierr      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               ierr=0 If the solution of XA = b is obtained.
!               OTHERWISE ierr.NE.0.
!
!
!     After an initial call to cbslv1, the routine may be recalled
!     with m0.NE.0 for a new b. when m0.NE.0 it is assumed that
!     A,ka,n,ml,mu,iwk have not been modified. cbslv retrieves the
!     LU decomposition which was obtained on the initial call to
!     cbslv1 and solves the new equations XA = b. in this case ierr
!     is not referenced.
! ----------------------------------------------------------------------
if (m0 /= 0) go to 10
!
!     Error checking
!
if (n <= 0 .or. n > ka) go to 100
if (ml < 0 .or. ml >= n) go to 110
if (mu < 0 .or. mu >= n) go to 120
!
!     Obtain an LU decomposition of A
!
call cbfa(a,ka,n,ml,mu,iwk,ierr)
if (ierr /= 0) return
!
!     Solve the system of equations
!
10 call cbsl(a,ka,n,ml,mu,iwk,b,1)
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
!
!               cbfa factors a complex band matrix BY elimination.
!
!                              ----------
!     On entry
!
!        A       COMPLEX(lda, NC)
!                contains the matrix in band storage. The rows
!                of the original matrix are stored in the rows
!                of A and the diagonals of the original matrix
!                are stored in columns 1 through ml+mu+1 of A.
!                NC MUST BE .GE. 2*ml+mu+1 .
!                See the comments below for details.
!
!        lda     INTEGER
!                the leading dimension of the array a. it is
!                assumed that lda .GE. n.
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
!                More efficient if ml .LE. mu .
!
!     On return
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                and the multipliers which were used to obtain it.
!                The factorization can be written  a = l*U  where
!                l is a product of permutation and unit lower
!                triangular matrices and U is upper triangular.
!
!        ipvt    INTEGER(n)
!                an integer vector of pivot indices.
!
!        INFO    INTEGER
!                =0  Normal value
!                =k  if  U(k,k) .EQ. 0. this is not an error
!                condition for this subroutine, but it does
!                indicate that cbsl will divide by zero if
!                it is called.
!
!     Band storage
!
!           If A0 is the matrix THEN the following code will store
!           A0 in band form.
!
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
!      Then  n = 6, ml = 1, mu = 2, lda .GE. 6  and A should contain
!
!              11 12 13  +     , + = Used for pivoting
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
!        MIN0,icamax,caxpy,cscal,cswap
! ----------------------------------------------------------------------
!
info = 0
if (ml == 0) go to 100
m = ml + mu + 1
!
!     Set fill-in columns to zero
!
do j = 1,ml
   jj = m + j
   do i = 1,n
      a(i,jj) = (0.0,0.0)
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
   lm = min0(n - k,ml)
   lmk = lm + k
   lm1 = lm + 1
   lm2 = ml1 - lm
!
!     Search for pivot index
!
   l = -icamax(lm1, a(lmk,lm2), ldb) + lm1 + k
   ipvt(k) = l
   mp = min0(mb,n - k)
!
!     Swap rows if necessary
!
   ll = ml1 + k - l
   if (l /= k) call cswap(mp + 1, a(k,ml1), lda, a(l,ll), lda)
!
!     Skip column reduction if pivot is zero
!
   if (a(k,ml1) /= (0.0,0.0)) go to 20
   info = k
   go to 40
!
!     Compute multipliers
!
20 t = (-1.0,0.0)/a(k,ml1)
   call cscal(lm, t, a(lmk,lm2), ldb)
!
!     Row elimination with column indexing
!
   do j = 1,mp
      jj = ml1 + j
      j1 = lm2 + j
      call caxpy(lm, a(k,jj), a(lmk,lm2), ldb, a(lmk,j1), ldb)
   end do
40 continue
!
ipvt(n) = n
if (a(n,ml1) == (0.0,0.0)) info = n
return
!
!     Case when ml = 0
!
100 do k = 1,n
   ipvt(k) = k
   if (a(k,1) == (0.0,0.0)) info = k
end do
return
end subroutine cbfa

pure subroutine cbsl(a,lda,n,ml,mu,ipvt,b,job)
implicit none
integer, intent(in) :: lda, n, ml, mu, job
complex, intent(in) :: a(lda,*)
complex, intent(inout) :: b(n)
integer, intent(in) :: ipvt(n)
integer :: ml1, ml2
complex :: t
integer :: k, kb, klm, l, lb, ldb, lm, m, mlm, nm1
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
!
!     cbsl solves the complex band system a*X = b or trans(a)*X = b
!     using the factors computed by cbfa.
!
!                         ----------
!     On entry
!
!        A       COMPLEX(lda, NC)
!                the output from cbfa.
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
!                the pivot vector from cbfa.
!
!        b       COMPLEX(n)
!                the right hand side vector.
!
!        JOB     INTEGER
!                = 0         To solve  a*X = b .
!                = Nonzero   to solve  trans(a)*X = b , where
!                            trans(a)  is the transpose.
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
!        setting of lda.  It will not occur if cbfa and cbsl are
!        called correctly and cbfa has set info = 0.
!
!     Written by E.A. Voorhees, Los Alamos scientific laboratory.
!     Adapted by A.H. Morris, naval surface weapons center.
!
!     Subroutines and functions
!      caxpy,cdotu
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
!
m = mu + ml + 1
if (m == 1) go to 100
ml1 = ml + 1
ml2 = ml + 2
nm1 = n - 1
ldb = 1 - lda
if (job /= 0) go to 50
!
!     job = 0 , SOLVE  a * X = b
!       first solve l*Y = b
!
if (ml == 0) go to 30
do k = 1,nm1
   lm = min0(ml,n - k)
   l = ipvt(k)
   t = b(l)
   if (l == k) go to 10
   b(l) = b(k)
   b(k) = t
10 klm = k + lm
   mlm = ml1 - lm
   call caxpy(lm, t, a(klm,mlm), ldb, b(k + 1), 1)
end do
!
!       Now solve  U*X = Y
!
30 k = n
do kb = 2,n
   b(k) = b(k)/a(k,ml1)
   lm = min0(k,m) - 1
   lb = k - lm
   t = -b(k)
   call caxpy(lm, t, a(k - 1,ml2), ldb, b(lb), 1)
   k = k - 1
end do
b(1) = b(1)/a(1,ml1)
return
!
!     job = NONZERO, SOLVE TRANS(a) * X = b
!       first solve  trans(U)*Y = b
!
50 b(1) = b(1)/a(1,ml1)
do k = 2,n
   lm = min0(k,m) - 1
   lb = k - lm
   t = cdotu(lm, a(k - 1,ml2), ldb, b(lb), 1)
   b(k) = (b(k) - t)/a(k,ml1)
end do
if (ml == 0) return
!
!       Now solve trans(l)*X = Y
!
do 70 kb = 1, nm1
   k = n - kb
   lm = min0(ml,n - k)
   klm = k + lm
   mlm = ml1 - lm
   b(k) = b(k) + cdotu(lm, a(klm,mlm), ldb, b(k + 1), 1)
   l = ipvt(k)
   if (l == k) go to 70
   t = b(l)
   b(l) = b(k)
   b(k) = t
70 continue
return
!
!     Case when ml = 0 And mu = 0
!
100 do 110 k = 1,n
110 b(k) = b(k)/a(k,1)
return
end subroutine cbsl

pure subroutine cvrs(a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
real, intent(in) :: a(ka,n)
real, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, j
!
!                 Store the i-TH row
!
ip = 1
do i = 1,m
   ib(i) = ip
   do 10 j = 1,n
      if (a(i,j) == 0.0) go to 10
      if (ip > num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10    continue
end do
!
!                 Complete the setup
!
ib(m + 1) = ip
ierr = 0
return
!
!                   Error return
!
20 ierr = i
return
end subroutine cvrs

pure subroutine cvds(a, ka, m, n, b, ib, jb, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: ka, m, n, num
double precision, intent(in) :: a(ka,n)
double precision, intent(inout) :: b(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ip, j
!
!                 Store the i-TH row
!
ip = 1
do i = 1,m
   ib(i) = ip
   do 10 j = 1,n
      if (a(i,j) == 0.d0) go to 10
      if (ip > num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10    continue
end do
!
!                 Complete the setup
!
ib(m + 1) = ip
ierr = 0
return
!
!                   Error return
!
20 ierr = i
return
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
!
!                 Store the i-TH row
!
ip = 1
do i = 1,m
   ib(i) = ip
   do 10 j = 1,n
      if (a(i,j) == zero) go to 10
      if (ip > num) go to 20
      b(ip) = a(i,j)
      jb(ip) = j
      ip = ip + 1
10    continue
end do
!
!                 Complete the setup
!
ib(m + 1) = ip
ierr = 0
return
!
!                   Error return
!
20 ierr = i
return
end subroutine cvcs

subroutine cvsr(a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
real, intent(in) :: a(*)
real, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin, j
!
do 30 i = 1,m
!
!                 Clear the i-TH row
!
   do j = 1,n
      b(i,j) = 0.0
   end do
!
!                 Store the i-TH row
!
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
!
30 continue
return
end subroutine cvsr

subroutine cvsd(a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
double precision, intent(in) :: a(*)
double precision, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin, j
!
do 30 i = 1,m
!
!                 Clear the i-TH row
!
   do j = 1,n
      b(i,j) = 0.d0
   end do
!
!                 Store the i-TH row
!
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
!
30 continue
return
end subroutine cvsd

subroutine cvsc(a, ia, ja, b, kb, m, n)
implicit none
integer, intent(in) :: kb, m, n
complex, intent(in) :: a(*)
complex, intent(inout) :: b(kb,n)
integer, intent(in) :: ia(*), ja(*)
integer :: i, ip, ipmax, ipmin, j
!
do 30 i = 1,m
!
!                 Clear the i-TH row
!
   do j = 1,n
      b(i,j) = (0.0,0.0)
   end do
!
!                 Store the i-TH row
!
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 30
   do ip = ipmin,ipmax
      j = ja(ip)
      b(i,j) = a(ip)
   end do
!
30 continue
return
end subroutine cvsc

subroutine scvrd(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
real, intent(in) :: a(*)
double precision, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) == 0.0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
20 continue
ib(m + 1) = l
return
end subroutine scvrd

subroutine scvdr(a, ia, ja, b, ib, jb, m)
implicit none
integer, intent(in) :: m
double precision, intent(in) :: a(*)
real, intent(inout) :: b(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: ib(*), jb(*)
integer :: i, ibeg, iend, ip, l
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) == 0.d0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
20 continue
ib(m + 1) = l
return
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
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do 10 ip = ibeg,iend
      t = real(a(ip))
      if (t == 0.0) go to 10
      b(l) = t
      jb(l) = ja(ip)
      l = l + 1
10    continue
20 continue
ib(m + 1) = l
return
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
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do 10 ip = ibeg,iend
      t = aimag(a(ip))
      if (t == 0.0) go to 10
      b(l) = t
      jb(l) = ja(ip)
      l = l + 1
10    continue
20 continue
ib(m + 1) = l
return
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
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do 31 l = minb,maxb
      if (b(l) == 0.0) go to 31
      j = jb(l)
      t = cmplx (wk(j), b(l))
      wk(j) = 0.0
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
!
40 if (mina > maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.0) go to 41
      if (ip > num) go to 50
      c(ip) = cmplx (wk(j), 0.0)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41    continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
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
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) == 0.0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
20 continue
ib(m + 1) = l
return
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
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) == 0.d0) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
20 continue
ib(m + 1) = l
return
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
!
l = 1
do 20 i = 1,m
   ib(i) = l
   ibeg = ia(i)
   iend = ia(i + 1) - 1
   if (ibeg > iend) go to 20
   do 10 ip = ibeg,iend
      if (a(ip) == zero) go to 10
      b(l) = a(ip)
      jb(l) = ja(ip)
      l = l + 1
10    continue
20 continue
ib(m + 1) = l
return
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
!
mp1 = m + 1
l = ia(1) - 1
do i = 1,mp1
   ib(i) = ia(i) - l
end do
!
ibeg = ia(1)
iend = ia(mp1) - 1
if (ibeg > iend) return
l = 1
do ip = ibeg,iend
   b(l) = conjg(a(ip))
   jb(l) = ja(ip)
   l = l + 1
end do
return
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
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
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
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
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
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
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
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
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
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
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
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
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
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
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
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
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
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
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
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
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
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
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
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
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
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
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
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
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
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
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
!
!           Compute the number of elements in each column
!                 of A and store the results in ib
!
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
!
!          Compute the row pointers of the transpose matrix
!                and store them in ib(2),...,ib(n+1)
!
num = ia(m + 1) - ia(1) + 1
j = n
do jj = 1,n
   num = num - ib(j)
   ib(j + 1) = num
   j = j - 1
end do
!
!                Store the i-TH row of A in b and jb
!                  and update the pointers in ib
!
do 31 i = 1,m
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
ib(1) = 1
return
!
!                    Transpose a zero matrix a
!
40 np1 = n + 1
do j = 1,np1
   ib(j) = 1
end do
return
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
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = 0.0
      if (t == 0.0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
!
40 if (mina > maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41    continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
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
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = 0.d0
      if (t == 0.d0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
!
40 if (mina > maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.d0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.d0
      jc(ip) = j
      ip = ip + 1
41    continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
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
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) + b(l)
      wk(j) = (0.0, 0.0)
      if (t == (0.0, 0.0)) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
!
40 if (mina > maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) == (0.0, 0.0)) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = (0.0, 0.0)
      jc(ip) = j
      ip = ip + 1
41    continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
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
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = 0.0
      if (t == 0.0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
!
40 if (mina > maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.0
      jc(ip) = j
      ip = ip + 1
41    continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
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
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = 0.d0
      if (t == 0.d0) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
!
40 if (mina > maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) == 0.d0) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = 0.d0
      jc(ip) = j
      ip = ip + 1
41    continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
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
!
!                  Compute the i-TH row of c
!
ip = 1
do 42 i = 1,m
   ic(i) = ip
   mina = ia(i)
   maxa = ia(i + 1) - 1
   if (mina > maxa) go to 30
   do l = mina,maxa
      j = ja(l)
      wk(j) = a(l)
   end do
!
30 minb = ib(i)
   maxb = ib(i + 1) - 1
   if (minb > maxb) go to 40
   do 31 l = minb,maxb
      j = jb(l)
      t = wk(j) - b(l)
      wk(j) = (0.0, 0.0)
      if (t == (0.0, 0.0)) go to 31
      if (ip > num) go to 50
      c(ip) = t
      jc(ip) = j
      ip = ip + 1
31    continue
!
40 if (mina > maxa) go to 42
   do 41 l = mina,maxa
      j = ja(l)
      if (wk(j) == (0.0, 0.0)) go to 41
      if (ip > num) go to 50
      c(ip) = wk(j)
      wk(j) = (0.0, 0.0)
      jc(ip) = j
      ip = ip + 1
41    continue
42 continue
ic(m + 1) = ip
ierr = 0
return
!
!                        Error return
!
50 ierr = i
return
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
!
!                     Compute the i-TH row of c
!
ip = 1
do 31 i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i + 1) - 1
   if (jpmin > jpmax) go to 31
!
   do 21 jp = jpmin,jpmax
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
!
   do 30 k = 1,n
      if (wk(k) == 0.0) go to 30
      if (ip > num) go to 40
      c(ip) = wk(k)
      wk(k) = 0.0
      jc(ip) = k
      ip = ip + 1
30    continue
31 continue
ic(l + 1) = ip
ierr = 0
return
!
!                           Error return
!
40 ierr = i
return
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
!
!                     Compute the i-TH row of c
!
ip = 1
do 31 i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i + 1) - 1
   if (jpmin > jpmax) go to 31
!
   do 21 jp = jpmin,jpmax
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
!
   do 30 k = 1,n
      if (wk(k) == 0.d0) go to 30
      if (ip > num) go to 40
      c(ip) = wk(k)
      wk(k) = 0.d0
      jc(ip) = k
      ip = ip + 1
30    continue
31 continue
ic(l + 1) = ip
ierr = 0
return
!
!                           Error return
!
40 ierr = i
return
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
!
!                     Compute the i-TH row of c
!
ip = 1
do 31 i = 1,l
   ic(i) = ip
   jpmin = ia(i)
   jpmax = ia(i + 1) - 1
   if (jpmin > jpmax) go to 31
!
   do 21 jp = jpmin,jpmax
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
!
   do 30 k = 1,n
      if (wk(k) == (0.0, 0.0)) go to 30
      if (ip > num) go to 40
      c(ip) = wk(k)
      wk(k) = (0.0, 0.0)
      jc(ip) = k
      ip = ip + 1
30    continue
31 continue
ic(l + 1) = ip
ierr = 0
return
!
!                           Error return
!
40 ierr = i
return
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
!
do 11 i = 1,m
   sum = 0.0
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
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
!
do 11 i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
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
!
do j = 1,n
   y(j) = 0.0
end do
!
do 21 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
return
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
!
do 11 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
return
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
!
do 11 i = 1,m
   sum = 0.d0
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
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
!
do 11 i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
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
!
do j = 1,n
   y(j) = 0.d0
end do
!
do 21 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
return
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
!
do 11 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
return
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
!
do 11 i = 1,m
   sum = (0.0, 0.0)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
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
!
do 11 i = 1,m
   sum = y(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      sum = sum + a(l)*x(j)
   end do
11 y(i) = sum
return
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
!
do j = 1,n
   y(j) = (0.0, 0.0)
end do
!
do 21 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 21
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
21 continue
return
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
!
do 11 i = 1,m
   t = x(i)
   lmin = ia(i)
   lmax = ia(i + 1) - 1
   if (lmin > lmax) go to 11
   do l = lmin,lmax
      j = ja(l)
      y(j) = y(j) + t*a(l)
   end do
11 continue
return
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
!
snrm = 0.0
do 20 i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 20
   sum = 0.0
   do ip = ipmin,ipmax
      sum = sum + abs(a(ip))
   end do
   snrm = amax1(snrm, sum)
20 continue
return
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
!
anorm = 0.0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) return
!
!     Compute the L1 norm of A
!
do j = 1,n
   wk(j) = 0.0
end do
!
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + abs(a(ip))
end do
!
do j = 1,n
   anorm = amax1(anorm,wk(j))
end do
return
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
!
dsnrm = 0.d0
do 20 i = 1,m
   ipmin = ia(i)
   ipmax = ia(i + 1) - 1
   if (ipmin > ipmax) go to 20
   sum = 0.d0
   do ip = ipmin,ipmax
      sum = sum + dabs(a(ip))
   end do
   dsnrm = dmax1(dsnrm, sum)
20 continue
return
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
!
anorm = 0.d0
ipmin = ia(1)
ipmax = ia(m + 1) - 1
if (ipmin > ipmax) return
!
!     Compute the L1 norm of A
!
do j = 1,n
   wk(j) = 0.d0
end do
!
do ip = ipmin,ipmax
   j = ja(ip)
   wk(j) = wk(j) + dabs(a(ip))
end do
!
do j = 1,n
   anorm = dmax1(anorm,wk(j))
end do
return
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
!
np1 = n + 1
do i = 1,np1
   iwk(i) = 0
end do
!
i = m
do ii = 1,m
   num = ia(i + 1) - ia(i) + 1
   l = np1 + i
   iwk(l) = iwk(num)
   iwk(num) = i
   i = i - 1
end do
!
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
return
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
!
np1 = n + 1
length = ia(np1) - ia(1)
do i = 1,n
   iwk(i) = ia(i + 1) - ia(i)
end do
call mc21a(n,ja,length,ia,iwk(1),r,num,iwk(np1))
ierr = n - num
if (ierr /= 0) return
!
do i = 1,n
   li = r(i)
   iwk(i) = ia(li)
   npi = n + i
   iwk(npi) = ia(li + 1) - ia(li)
end do
call mc13d(n,ja,length,iwk(1),iwk(np1),c,ib,num,iwk(2*n + 1))
!
do i = 1,n
   li = c(i)
   iwk(i) = r(li)
end do
do i = 1,n
   r(i) = iwk(i)
end do
return
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
!
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
!
call mc21b(n,icn,licn,ip,lenr,iperm,numnz,iw(1,1),iw(1,2), &
   & iw(1,3),iw(1,4))
return
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
!
! pr(i) is the previous row to i in the depth first search.
! arp(i) is one less than the number of non-zeros in row i
!     which have not been scanned when looking for a cheap assignment.
! cv(i) is the most recent row extension at which column i
!     was visited.
! out(i) is one less than the number of non-zeros in row i
!     which have not been scanned during one pass through the
!     main loop.
!-----------------------------------------------------------------------
!
!     Initialization of arrays
!
do i = 1,n
   arp(i) = lenr(i) - 1
   cv(i) = 0
   iperm(i) = 0
end do
numnz = 0
!
!     Main loop.
!     Each pass round this loop either results in a new assignment
!     or gives a row with no assignment.
!
do 130 jord = 1,n
   j = jord
   pr(j) = -1
   do 100 k = 1,jord
!
!     Look for a cheap assignment
!
      in1 = arp(j)
      if (in1 < 0) go to 60
      in2 = ip(j) + lenr(j) - 1
      in1 = in2 - in1
      do ii = in1,in2
         i = icn(ii)
         if (iperm(i) == 0) go to 110
      end do
!
!     No cheap assignment in row
!
      arp(j) = -1
!
!     Begin looking for assignment chain starting with row j
!
60    out(j) = lenr(j) - 1
!
!     Inner loop.  Extends chain by one or backtracks.
!
      do kk = 1,jord
         in1 = out(j)
         if (in1 < 0) go to 80
         in2 = ip(j) + lenr(j) - 1
         in1 = in2 - in1
!
!        Forward scan
!
         do 70 ii = in1,in2
            i = icn(ii)
            if (cv(i) == jord) go to 70
!
!           Column i has not yet been accessed during this pass
!
            j1 = j
            j = iperm(i)
            cv(i) = jord
            pr(j) = j1
            out(j1) = in2 - ii - 1
            go to 100
70          continue
!
!        Backtracking step
!
80       j = pr(j)
         if (j == -1) go to 130
      end do
!
100   continue
!
!     New assignment is made
!
110 iperm(i) = j
   arp(j) = in2 - ii - 1
   numnz = numnz + 1
   do k = 1,jord
      j = pr(j)
      if (j == -1) go to 130
      ii = ip(j) + lenr(j) - out(j) - 2
      i = icn(ii)
      iperm(i) = j
   end do
!
130 continue
!
!     If matrix is structurally singular, we now complete the
!     permutation iperm.
!
if (numnz == n) go to 500
do i = 1,n
   arp(i) = 0
end do
k = 0
do 160 i = 1,n
   if (iperm(i) /= 0) go to 150
   k = k + 1
   out(k) = i
   go to 160
150 j = iperm(i)
   arp(j) = i
160 continue
k = 0
do 170 i = 1,n
   if (arp(i) /= 0) go to 170
   k = k + 1
   ioutk = out(k)
   iperm(ioutk) = i
170 continue
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
!
! Description of parameters.
! Input variables  .... n,icn,licn,ip,lenr.
! Output variables  ior,ib,num.
!
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
!
!
call mc13e(n, icn, licn, ip, lenr, ior, ib, num, iw(1,1), &
   & iw(1,2), iw(1,3))
return
end subroutine mc13d

pure subroutine mc13e(n, icn, licn, ip, lenr, arp, ib, num, lowl, &
   & numb, prev)
implicit none
integer, intent(in) :: licn, n
integer, intent(out) :: num
integer, intent(in) :: ip(n)
integer, intent(in) :: icn(licn), lenr(n)
integer, intent(inout) :: arp(n), ib(n), lowl(n), numb(n), prev(n)
integer :: i, i1, i2, icnt, ii, isn, ist, ist1, iv, iw, j, k, &
   & lcnt, nnm1
integer :: stp, dummy
!
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
!
!
!   icnt is the number of nodes whose positions in final ordering have
!     been found.
!
icnt = 0
! num is the number of blocks that have been found.
num = 0
nnm1 = n + n - 1
!
! Initialization of arrays.
!
do j = 1,n
   numb(j) = 0
   arp(j) = lenr(j) - 1
end do
!
!
do 90 isn = 1,n
! Look for a starting node
   if (numb(isn) /= 0) go to 90
   iv = isn
! ist is the number of nodes on the stack ... it is the stack pointer.
   ist = 1
! Put node iv at beginning of stack.
   lowl(iv) = 1
   numb(iv) = 1
   ib(n) = iv
!
! The body of this loop puts a new node on the stack or backtracks.
!
   do 80 dummy = 1,nnm1
      i1 = arp(iv)
! Have all edges leaving node iv been searched.
      if (i1 < 0) go to 30
      i2 = ip(iv) + lenr(iv) - 1
      i1 = i2 - i1
!
! Look at edges leaving node iv until one enters a new node or
!     all edges are exhausted.
!
      do ii = i1,i2
         iw = icn(ii)
! Has node iw been on stack already.
         if (numb(iw) == 0) go to 70
! Update value of lowl(iv) if necessary.
         if (lowl(iw) < lowl(iv)) lowl(iv) = lowl(iw)
      end do
!
! There are no more edges leaving node iv.
!
      arp(iv) = -1
! Is node iv the root of a block.
30    if (lowl(iv) < numb(iv)) go to 60
!
! Order nodes in a block.
!
      num = num + 1
      ist1 = n + 1 - ist
      lcnt = icnt + 1
!
! Peel block off the top of the stack starting at the top and
!     working down to the root of the block.
!
      do stp = ist1,n
         iw = ib(stp)
         lowl(iw) = n + 1
         icnt = icnt + 1
         numb(iw) = icnt
         if (iw == iv) go to 50
      end do
50    ist = n - stp
      ib(num) = lcnt
! Are there any nodes left on the stack.
      if (ist /= 0) go to 60
! Have all the nodes been ordered.
      if (icnt < n) go to 90
      go to 100
!
! Backtrack to previous node on path.
!
60    iw = iv
      iv = prev(iv)
! Update value of lowl(iv) if necessary.
      if (lowl(iw) < lowl(iv)) lowl(iv) = lowl(iw)
      go to 80
!
! Put new node on the stack.
!
70    arp(iv) = i2 - ii - 1
      prev(iw) = iv
      iv = iw
      ist = ist + 1
      lowl(iv) = ist
      numb(iv) = ist
      k = n + 1 - ist
      ib(k) = iv
80    continue
!
90 continue
!
! Put permutation in the required form.
!
100 do i = 1,n
   ii = numb(i)
   arp(ii) = i
end do
return
end subroutine mc13e

subroutine spslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
real, intent(in) :: a(*), b(n)
real, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: k, l
integer :: iu, ju, u, y, p
!-----------------------------------------------------------------------
!                 Solution of real sparse equations
!-----------------------------------------------------------------------
!  spslv calls nspiv1 which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!
!  Input arguments---
!
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      REAL ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING THE
!         actual nonzeros.  (See matrix storage description below)
!
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!
!  b      REAL ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!
!  rtemp  real array of n + max entries for internal use
!
!
!  Output arguments---
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!
!  x      REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!
!         ierr values are---
!
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!
!         ierr = 0              Error.  n is less than or equal to 0
!
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
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
!
ierr = 0
if (n <= 0) return
!
!  Set indices to divide temporary storage for nspiv1
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  Compute the inverse permutation of c
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL nspiv1 TO PERFORM COMPUTATIONS
!
call nspiv1(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
return
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
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, &
   & nzcnt
real :: dk, lki, xpv, xpvmax, yk
integer :: ck, pk, ppk, pv, v, vi, vj, vk
!
!
!  nspiv1 uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!
!
!  See spslv for descriptions of all input and output arguments
!  other than those described below
!
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!
!  Input arguments (used internally only)---
!
!  y   REAL ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!      right hand side
!
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!
!  u   REAL ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      the strict upper triangle of u.  (See matrix storage
!      description below)
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
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
!
!
!
!  Initialize work storage and pointers to ju
!
do j = 1,n
   x(j) = 0.0
end do
iu(1) = 1
juptr = 0
!
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
!
do 170 k = 1,n
!
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
!
   p(n + 1) = n + 1
   vk = r(k)
!
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
!
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!
!  Store a(k,j) in work vector
!
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   if (ppk - vj) 30,1003,40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!
!  The following code computes the k-TH row of u
!
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
!
   lki = - x(vi)
   x(vi) = 0.0
!
!  Adjust right hand side to reflect elimination
!
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!
!  If vj is already in the adjacency of vk,
!  skip the insertion
!
      if (x(vj) /= 0.0) go to 90
!
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
!
      if (vj - ppk) 60,90,70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      if (ppk - vj) 70,90,80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
!
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!
!  Find largest entry, counting off-diagonal nonzeros
!
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
!
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
!
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!
!  Compute D(k) = 1/L(k,k) and perform interchange.
!
150 dk = 1.0 / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = 0.0
!
!  Update right hand side.
!
   y(k) = yk * dk
!
!  Compute value for iu(k+1) and check for storage overflow
!
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
!
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = 0.0
   j = p(j)
   if (j <= n) go to 160
170 continue
!
!  Backsolve u x = y, and reorder x to correspond with A
!
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
!
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
!
ierr = iu(n + 1) - iu(1)
return
!
!  Error returns
!
!  Row k of A is null
!
1002 ierr = -k
return
!
!  Row k of A has a duplicate entry
!
1003 ierr = -(n + k)
return
!
!  Zero pivot in row k
!
1004 ierr = -(2*n + k)
return
!
!  Storage for u exceeded on row k
!
1005 ierr = -(3*n + k)
return
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
integer :: it, iu, jt, k, l
integer :: y, t, p
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
!
!
!     Input arguments when m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the matrix a stored in sparse form.
!
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     Output arguments when m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to rslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to rslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call splu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call rslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
return
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
!
!            Solve LY = b by forward substitution
!
do 11 k = 1,n
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
!
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
!
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
return
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
integer :: it, iu, jt, k, l
integer :: y, t, p
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
!
!
!     Input arguments when m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the matrix a stored in sparse form.
!
!     b        ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND SIDE DATA.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     Output arguments when m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        REAL ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       REAL ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to tslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to tslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call splu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call tslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
return
end subroutine tslv

pure subroutine tslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
real, intent(in) :: b(n), d(n), t(*)
real, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
!
!            Solve YU = b by forward substitution
!
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
!
do 21 k = 1,n
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
!
!            Solve XL = y by backward substitution
!
x(n) = y(n)/d(n)
if (n == 1) return
!
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
!
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
return
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
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, &
   & maxil
integer :: pm
real :: const, wi, wmax
!-----------------------------------------------------------------------
!     splu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a real sparse matrix.
!     U is a unit upper triangular matrix.
!
!
!     Input arguments ---
!
!     A,ia,ja  the sparse matrix to be decomposed.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!
!     n        ORDER OF THE MATRIX a.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!
!
!     Output arguments ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!
!     d        REAL ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!
!
!     Work spaces ---
!
!     w        REAL ARRAY OF DIMENSION n.
!
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
!
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.0
end do
!
!     Perform the LU factorization of the r(k)-TH row of A
!
do 100 k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!
!     Set p to the reordered row of A
!
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   if (pm - j) 21,210,22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!
!     Process the entries in the lower triangle of A
!
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == 0.0) go to 30
!
!     L(k,i) is nonzero. Therefore store it in L.
!
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = 0.0
!
!     Perform elimination using the i-TH row of U
!
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do 43 jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= 0.0) go to 43
      if (j - pm) 40,43,41
40    pm = i
41    m = pm
      pm = p(m)
      if (pm - j) 41,43,42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   go to 30
!
!     Search for the k-TH pivot element
!
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
!
!     Store the pivot in d
!
60 if (wmax == 0.0) go to 220
   d(k) = w(maxi)
!
!     Perform the column interchange
!
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
!
80 w(maxi) = w(k)
   w(k) = 0.0
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!
!     The remaining elements of p form the k-TH row of U
!
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
!
!     Prepare for the next row
!
100 it(k + 1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- Error return --------------------
!
!     Row r(k) is null
!
200 ierr = -k
return
!
!     Row r(k) has a duplicate entry
!
210 ierr = -(n + k)
return
!
!     Zero pivot in row r(k)
!
220 ierr = -(2*n + k)
return
!
!     Storage for L and U exceeded on row r(k)
!
230 ierr = -(3*n + k)
return
end subroutine splu

subroutine dspslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
double precision, intent(in) :: a(*), b(n)
double precision, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: k, l
integer :: iu, ju, u, y, p
!-----------------------------------------------------------------------
!          Solution of double precision sparse equations
!-----------------------------------------------------------------------
!  dspslv calls dnspiv which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!
!  Input arguments---
!
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      DOUBLE PRECISION ARRAY WITH ONE ENTRY PER NONZERO IN A,
!         containing the actual nonzeros. (See the matrix storage
!         description below)
!
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!
!  b      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE RIGHT
!         hand side data
!
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!
!  rtemp  double precision array of n + max entries for internal use
!
!
!  Output arguments---
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!
!  x      DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!         solution vector
!
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!
!         ierr values are---
!
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!
!         ierr = 0              Error.  n is less than or equal to 0
!
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
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
!
ierr = 0
if (n <= 0) return
!
!  Set indices to divide temporary storage for dnspiv
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  Compute the inverse permutation of c
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL dnspiv TO PERFORM COMPUTATIONS
!
call dnspiv(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
return
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
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, &
   & nzcnt
double precision :: dk, lki, xpv, xpvmax, yk
integer :: ck, pk, ppk, pv, v, vi, vj, vk
!
!
!  dnspiv uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!
!
!  See dspslv for descriptions of all input and output arguments
!  other than those described below
!
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!
!  Input arguments (used internally only)---
!
!  y   DOUBLE PRECISION ARRAY OF n ENTRIES USED TO COMPUTE
!      the updated right hand side
!
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!
!  u   DOUBLE PRECISION ARRAY OF MAX ENTRIES USED FOR THE ACTUAL
!      nonzeros in the strict upper triangle of u. (See matrix
!      storage description below)
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
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
!
!
!
!  Initialize work storage and pointers to ju
!
do j = 1,n
   x(j) = 0.d0
end do
iu(1) = 1
juptr = 0
!
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
!
do 170 k = 1,n
!
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
!
   p(n + 1) = n + 1
   vk = r(k)
!
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
!
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!
!  Store a(k,j) in work vector
!
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   if (ppk - vj) 30,1003,40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!
!  The following code computes the k-TH row of u
!
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
!
   lki = - x(vi)
   x(vi) = 0.d0
!
!  Adjust right hand side to reflect elimination
!
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!
!  If vj is already in the adjacency of vk,
!  skip the insertion
!
      if (x(vj) /= 0.d0) go to 90
!
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
!
      if (vj - ppk) 60,90,70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      if (ppk - vj) 70,90,80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
!
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!
!  Find largest entry, counting off-diagonal nonzeros
!
110 if (vi > n) go to 1004
   xpvmax = dabs(x(vi))
   maxc = vi
   nzcnt = 0
   pv = vi
120 v = pv
   pv = p(pv)
   if (pv > n) go to 130
   nzcnt = nzcnt + 1
   xpv = dabs(x(pv))
   if (xpv <= xpvmax) go to 120
   xpvmax = xpv
   maxc = pv
   maxcl = v
   go to 120
130 if (xpvmax == 0.d0) go to 1004
!
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
!
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!
!  Compute D(k) = 1/L(k,k) and perform interchange.
!
150 dk = 1.d0 / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = 0.d0
!
!  Update right hand side.
!
   y(k) = yk * dk
!
!  Compute value for iu(k+1) and check for storage overflow
!
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
!
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = 0.d0
   j = p(j)
   if (j <= n) go to 160
170 continue
!
!  Backsolve u x = y, and reorder x to correspond with A
!
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
!
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
!
ierr = iu(n + 1) - iu(1)
return
!
!  Error returns
!
!  Row k of A is null
!
1002 ierr = -k
return
!
!  Row k of A has a duplicate entry
!
1003 ierr = -(n + k)
return
!
!  Zero pivot in row k
!
1004 ierr = -(2*n + k)
return
!
!  Storage for u exceeded on row k
!
1005 ierr = -(3*n + k)
return
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
integer :: it, iu, jt, k, l
integer :: y, t, p
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
!
!
!     Input arguments when m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the double precision matrix a stored in sparse form.
!
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     Output arguments when m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to dslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call dsplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call dslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
return
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
!
!            Solve LY = b by forward substitution
!
do 11 k = 1,n
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
!
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
!
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
return
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
integer :: it, iu, jt, k, l
integer :: y, t, p
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
!
!
!     Input arguments when m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the double precision matrix a stored in sparse form.
!
!     b        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              right hand side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     Output arguments when m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        DOUBLE PRECISION ARRAY OF n ENTRIES CONTAINING THE
!              solution. b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       DOUBLE PRECISION ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to dtslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to dtslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call dsplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call dtslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
return
end subroutine dtslv

pure subroutine dtslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
double precision, intent(in) :: b(n), d(n), t(*)
double precision, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
!
!            Solve YU = b by forward substitution
!
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
!
do 21 k = 1,n
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
!
!            Solve XL = y by backward substitution
!
x(n) = y(n)/d(n)
if (n == 1) return
!
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
!
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
return
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
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, &
   & maxil
integer :: pm
double precision :: const, wi, wmax
!-----------------------------------------------------------------------
!     dsplu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a double precision sparse
!     matrix. U is a unit upper triangular matrix.
!
!
!     Input arguments ---
!
!     A,ia,ja  the sparse matrix to be decomposed.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!
!     n        ORDER OF THE MATRIX a.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!
!
!     Output arguments ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!
!     d        DOUBLE PRECISION ARRAY CONTAINING THE n DIAGONAL
!              elements of L.
!
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t.
!
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!
!
!     Work spaces ---
!
!     w        DOUBLE PRECISION ARRAY OF DIMENSION n.
!
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
!
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = 0.d0
end do
!
!     Perform the LU factorization of the r(k)-TH row of A
!
do 100 k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!
!     Set p to the reordered row of A
!
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   if (pm - j) 21,210,22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!
!     Process the entries in the lower triangle of A
!
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == 0.d0) go to 30
!
!     L(k,i) is nonzero. Therefore store it in L.
!
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = 0.d0
!
!     Perform elimination using the i-TH row of U
!
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do 43 jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= 0.d0) go to 43
      if (j - pm) 40,43,41
40    pm = i
41    m = pm
      pm = p(m)
      if (pm - j) 41,43,42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   go to 30
!
!     Search for the k-TH pivot element
!
50 if (i > n) go to 220
   wmax = dabs(w(i))
   maxi = i
   pm = i
51 m = pm
   pm = p(m)
   if (pm > n) go to 60
   wi = dabs(w(pm))
   if (wi <= wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!
!     Store the pivot in d
!
60 if (wmax == 0.d0) go to 220
   d(k) = w(maxi)
!
!     Perform the column interchange
!
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
!
80 w(maxi) = w(k)
   w(k) = 0.d0
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!
!     The remaining elements of p form the k-TH row of U
!
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
!
!     Prepare for the next row
!
100 it(k + 1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- Error return --------------------
!
!     Row r(k) is null
!
200 ierr = -k
return
!
!     Row r(k) has a duplicate entry
!
210 ierr = -(n + k)
return
!
!     Zero pivot in row r(k)
!
220 ierr = -(2*n + k)
return
!
!     Storage for L and U exceeded on row r(k)
!
230 ierr = -(3*n + k)
return
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
!
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
!
kase = 0
ainorm = 0.0
call sonest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call rslv(0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
!
!     Check if A is singular or if there are errors
!
if (ierr > 0) go to 20
if (iabs(ierr) <= n) go to 50
ierr = ierr + n
if (iabs(ierr) <= n) return
ierr = ierr + n
if (iabs(ierr) <= n) go to 50
return
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
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
!
!     Compute the value of cond
!
40 cond = anorm*ainorm
return
!
!     Singular case
!
50 ierr = 0
return
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
!
ix = 2*n + max + 1
iv = ix + n
isgn = 4*n + max + 3
!
kase = 0
ainorm = 0.d0
call donest(n, wk(iv), wk(ix), iwk(isgn), ainorm, kase, &
   & iter, j, jump)
call dslv(0, n, a, ia, ja, wk(ix), r, c, max, wk(ix), &
   & iwk(1), wk(1), ierr)
!
!     Check if A is singular or if there are errors
!
if (ierr > 0) go to 20
if (iabs(ierr) <= n) go to 50
ierr = ierr + n
if (iabs(ierr) <= n) return
ierr = ierr + n
if (iabs(ierr) <= n) go to 50
return
!
!     General loop to estimate the norm  ainorm
!     of the inverse of A
!
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
!
!     Compute the value of cond
!
40 cond = anorm*ainorm
return
!
!     Singular case
!
50 ierr = 0
return
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
!
!     sonest estimates the 1-norm of A square, real matrix  A.
!     Reverse communication is used for evaluating
!     matrix-vector products.
!
!     On entry
!
!        n       the order of the matrix.  n .GE. 1.
!
!        kase    INTEGER  (= 0).
!
!     On intermediate returns
!
!        kase    = 1 or 2.
!
!        x       MUST BE OVERWRITTEN BY
!
!                     A*x,             IF kase = 1,
!                     TRANSPOSE(A)*x,  IF kase = 2,
!
!                And sonest must be RE-called, with all the other
!                parameters unchanged.
!
!        ITER    NUMBER OF THE CURRENT ITERATION.
!
!     On final return
!
!        kase    = 0.
!
!        anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!
!        v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!                         (W  is not returned).
!
!        ITER    NUMBER OF INTERATIONS TAKEN.
!
!        Written by nick Higham, university of manchester. Modified
!        by A.H. Morris (NSWC).
!
!     Reference
!     N.J. Higham (1987) Fortran codes for estimating
!     the 1-norm of a real or complex matrix, with applications
!     to condition  estimation, numerical analysis report no. 135,
!     university of manchester, manchester M13 9PL, england.
!
!-----------------------------------------------------------------------
!
if (kase /= 0) go to 20
t = 1.0/float(n)
do i = 1,n
   x(i) = t
end do
iter = 0
kase = 1
jump = 1
return
20 go to (100, 200, 300, 400, 500), jump
!
!     ................ ENTRY   (jump = 1)
!     first iteration.  x has been overwritten by A*x.
!
100 iter = 1
if (n > 1) go to 110
v(1) = x(1)
anorm = abs(v(1))
go to 510
!
110 anorm = sasum(n,x,1)
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 2
return
!
!     ................ ENTRY   (jump = 2)
!     first iteration.  x has been overwritten by transpose(A)*x.
!
200 iter = 2
j = isamax(n,x,1)
!
!     Main loop - Iterations 2,3,...,itmax.
!
210 do i = 1,n
   x(i) = 0.0
end do
x(j) = 1.0
kase = 1
jump = 3
return
!
!     ................ ENTRY   (jump = 3)
!     x has been overwritten by A*x.
!
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
!
!     Test for cycling.
!
320 if (anorm <= anrm) go to 410
!
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 4
return
!
!     ................ ENTRY   (jump = 4)
!     x has been overwritten by transpose(A)*x.
!
400 jlast = j
j = isamax(n,x,1)
if (x(jlast) == abs(x(j)) .or. &
   & iter >= itmax) go to 410
iter = iter + 1
go to 210
!
!     Iteration complete.  Final stage.
!
410 altsgn = 1.0
do i = 1,n
   x(i) = altsgn * (1.0 + float(i - 1)/float(n - 1))
   altsgn = -altsgn
end do
kase = 1
jump = 5
return
!
!     ................ ENTRY   (jump = 5)
!     x has been overwritten by A*x.
!
500 anrm = 2.0*sasum(n,x,1)/float(3*n)
if (anrm <= anorm) go to 510
call scopy(n,x,1,v,1)
anorm = anrm
510 kase = 0
return
end subroutine sonest

pure subroutine donest(n, v, x, isgn, anorm, kase, iter, j, jump)
implicit none
integer, intent(inout) :: iter, j, jump, kase
integer, intent(in) :: n
double precision, intent(inout) :: anorm, v(n), x(n)
integer, intent(inout) :: isgn(n)
integer :: i, jlast, l
double precision :: altsgn, an, anm1, anrm, t
integer, parameter :: itmax = 5
interface
   pure function dasum(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision :: dasum
   end function dasum
   pure subroutine dcopy(n,dx,incx,dy,incy)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      double precision, intent(inout) :: dy(*)
      integer, intent(in) :: incy
   end subroutine dcopy
   pure function idamax(n,dx,incx)
      implicit none
      integer, intent(in) :: n
      double precision, intent(in) :: dx(*)
      integer, intent(in) :: incx
      integer :: idamax
   end function idamax
end interface
!-----------------------------------------------------------------------
!
!     donest estimates the 1-norm of A square, real matrix  A.
!     Reverse communication is used for evaluating
!     matrix-vector products.
!
!     On entry
!
!        n       the order of the matrix.  n .GE. 1.
!
!        kase    INTEGER  (= 0).
!
!     On intermediate returns
!
!        kase    = 1 or 2.
!
!        x       MUST BE OVERWRITTEN BY
!
!                     A*x,             IF kase = 1,
!                     TRANSPOSE(A)*x,  IF kase = 2,
!
!                And donest must be RE-called, with all the other
!                parameters unchanged.
!
!        ITER    NUMBER OF THE CURRENT ITERATION.
!
!     On final return
!
!        kase    = 0.
!
!        anorm   CONTAINS AN ESTIMATE (A LOWER BOUND) FOR NORM(A).
!
!        v       = A*W,   WHERE  anorm = NORM(v)/NORM(W)
!                         (W  is not returned).
!
!        ITER    NUMBER OF INTERATIONS TAKEN.
!
!        Written by nick Higham, university of manchester. Modified
!        by A.H. Morris (NSWC).
!
!     Reference
!     N.J. Higham (1987) Fortran codes for estimating
!     the 1-norm of a real or complex matrix, with applications
!     to condition  estimation, numerical analysis report no. 135,
!     university of manchester, manchester M13 9PL, england.
!
!-----------------------------------------------------------------------
!
an = n
anm1 = n - 1
if (kase /= 0) go to 20
t = 1.d0/an
do i = 1,n
   x(i) = t
end do
iter = 0
kase = 1
jump = 1
return
20 go to (100, 200, 300, 400, 500), jump
!
!     ................ ENTRY   (jump = 1)
!     first iteration.  x has been overwritten by A*x.
!
100 iter = 1
if (n > 1) go to 110
v(1) = x(1)
anorm = dabs(v(1))
go to 510
!
110 anorm = dasum(n,x,1)
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.d0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 2
return
!
!     ................ ENTRY   (jump = 2)
!     first iteration.  x has been overwritten by transpose(A)*x.
!
200 iter = 2
j = idamax(n,x,1)
!
!     Main loop - Iterations 2,3,...,itmax.
!
210 do i = 1,n
   x(i) = 0.d0
end do
x(j) = 1.d0
kase = 1
jump = 3
return
!
!     ................ ENTRY   (jump = 3)
!     x has been overwritten by A*x.
!
300 call dcopy(n,x,1,v,1)
anrm = anorm
anorm = dasum(n,v,1)
do i = 1,n
   l = 1
   if (x(i) < 0.d0) l = -1
   if (l /= isgn(i)) go to 320
end do
!     Repeated sign vector detected, hence algorithm has converged.
go to 410
!
!     Test for cycling.
!
320 if (anorm <= anrm) go to 410
!
do i = 1,n
   isgn(i) = 1
   if (x(i) < 0.d0) isgn(i) = -1
   x(i) = isgn(i)
end do
kase = 2
jump = 4
return
!
!     ................ ENTRY   (jump = 4)
!     x has been overwritten by transpose(A)*x.
!
400 jlast = j
j = idamax(n,x,1)
if (x(jlast) == dabs(x(j)) .or. &
   & iter >= itmax) go to 410
iter = iter + 1
go to 210
!
!     Iteration complete.  Final stage.
!
410 altsgn = 1.d0
do i = 1,n
   t = i - 1
   x(i) = altsgn * (1.d0 + t/anm1)
   altsgn = -altsgn
end do
kase = 1
jump = 5
return
!
!     ................ ENTRY   (jump = 5)
!     x has been overwritten by A*x.
!
500 anrm = 2.d0*dasum(n,x,1)/(3.d0*an)
if (anrm <= anorm) go to 510
call dcopy(n,x,1,v,1)
anorm = anrm
510 kase = 0
return
end subroutine donest

subroutine cspslv(n,a,ia,ja,b,r,c,max,x,itemp,rtemp,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), rtemp(*)
integer, intent(in) :: ia(*), ja(*), r(n)
integer, intent(inout) :: c(n), itemp(*)
integer :: k, l
integer :: iu, ju, u, y, p
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!  spslv calls cnspiv which uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!
!  Input arguments---
!
!  n      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
!
!  A      COMPLEX ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         the actual nonzeros.  (See storage description below)
!
!  ia     INTEGER ARRAY OF n+1 ENTRIES CONTAINING ROW POINTERS TO A
!         (see matrix storage description below)
!
!  ja     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
!         column numbers of the nonzeros of A.  (See matrix storage
!         description below)
!
!  b      COMPLEX ARRAY OF n ENTRIES CONTAINING RIGHT HAND SIDE DATA
!
!  r      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         rows of A (I.E., the elimination order for the equations)
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of A.  c is also an output argument
!
!  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
!         nonzero entries of u which may be stored
!
!  itemp  integer array of 3*n + max + 2 entries, for internal use
!
!  rtemp  complex array of n + max entries for internal use
!
!
!  Output arguments---
!
!  c      INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF THE
!         columns of u.  c is also an input argument
!
!  x      COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION VECTOR
!
!  ierr   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
!         the actual number of off-diagonal entries in u (for
!         successful completion)
!
!         ierr values are---
!
!         0 LT ierr             successful completion. ierr=max(1,M)
!                               where M is the number of off-diagonal
!                               nonzero entries of u.
!
!         ierr = 0              Error.  n is less than or equal to 0
!
!         -n le ierr LT 0       ERROR.  ROW NUMBER IABS(ierr) OF A IS
!                               is null
!
!         -2*n le ierr LT -n    ERROR.  ROW NUMBER IABS(ierr+n) HAS A
!                               duplicate entry
!
!         -3*n le ierr LT -2*n  error.  Row number IABS(ierr+2*n)
!                               has a zero pivot
!
!         -4*n le ierr LT -3*n  error.  Row number IABS(ierr+3*n)
!                               exceeds storage
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
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
!
ierr = 0
if (n <= 0) return
!
!  Set indices to divide temporary storage for cnspiv
!
y = 1
u = y + n
p = n + 1
iu = p + n + 1
ju = iu + n + 1
!
!  Compute the inverse permutation of c
!
do k = 1,n
   l = c(k)
   itemp(l) = k
end do
!
!  CALL cnspiv TO PERFORM COMPUTATIONS
!
call cnspiv(n,ia,ja,a,b,max,r,c,itemp(1),x,rtemp(y),itemp(p), &
   & itemp(iu),itemp(ju),rtemp(u),ierr)
if (ierr == 0) ierr = 1
return
end subroutine cspslv

subroutine cnspiv(n,ia,ja,a,b,max,r,c,ic,x,y,p,iu,ju,u,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: u(max), x(n), y(n)
integer, intent(inout) :: c(n)
integer, intent(in) :: ia(*)
integer, intent(inout) :: ic(n), iu(*)
integer, intent(in) :: ja(*)
integer, intent(inout) :: ju(max), p(*)
integer, intent(in) :: r(n)
integer :: i, j, jaj, jmax, jmin, juj, juptr, k, maxc, maxcl, &
   & nzcnt
complex :: dk, lki, one, yk, zero
real :: xpv, xpvmax
integer :: ck, pk, ppk, pv, v, vi, vj, vk
!
!
!  cnspiv uses sparse Gaussian elimination with
!  column interchanges to solve the linear system A x = b.  the
!  elimination phase performs row operations on A and b to obtain
!  a unit upper triangular matrix u and a vector y.  the solution
!  phase solves u x = y.
!
!
!  See cspslv for descriptions of all input and output arguments
!  other than those described below
!
!  ic  integer array of n entries which is the inverse of c
!      (I.E., ic(c(i)) = i). ic is both an input and output
!      argument.
!
!  Input arguments (used internally only)---
!
!  y   COMPLEX ARRAY OF n ENTRIES USED TO COMPUTE THE UPDATED
!      right hand side
!
!  p   INTEGER ARRAY OF n+1 ENTRIES USED FOR A LINKED LIST.
!      p(n+1) is the list header, and the entry following
!      p(k) is in p(p(k)).  Thus, p(n+1) is the first data
!      item, p(p(n+1)) is the second, etc.  a pointer of
!      n+1 marks the end of the list
!
!  iu  integer array of n+1 entries used for row pointers to u
!      (see matrix storage description below)
!
!  ju  integer array of max entries used for column numbers of
!      the nonzeros in the strict upper triangle of u.  (See
!      matrix storage description below)
!
!  u   COMPLEX ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
!      the strict upper triangle of u.  (See matrix storage
!      description below)
!
!
!  Storage of sparse matrices---
!
!  The sparse matrix a is stored using three arrays ia, ja, and a.
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
!
!
!
one = (1.0,0.0)
zero = (0.0,0.0)
!
!  Initialize work storage and pointers to ju
!
do j = 1,n
   x(j) = zero
end do
iu(1) = 1
juptr = 0
!
!  Perform symbolic and numeric factorization row by row
!  vk (vi,vj) is the graph vertex for row k (i,j) of u
!
do 170 k = 1,n
!
!  Initialize linked list and free storage for this row
!  the r(k)-TH row of a becomes the k-TH row of u.
!
   p(n + 1) = n + 1
   vk = r(k)
!
!  Set up adjacency list for vk, ordered in
!  current column order of u.  the loop index
!  goes downward to exploit any columns
!  from A in correct relative order
!
   jmin = ia(vk)
   jmax = ia(vk + 1) - 1
   if (jmin > jmax) go to 1002
   j = jmax
20 jaj = ja(j)
   vj = ic(jaj)
!
!  Store a(k,j) in work vector
!
   x(vj) = a(j)
!  This code inserts vj into adjacency list of vk
   ppk = n + 1
30 pk = ppk
   ppk = p(pk)
   if (ppk - vj) 30,1003,40
40 p(vj) = ppk
   p(pk) = vj
   j = j - 1
   if (j >= jmin) go to 20
!
!  The following code computes the k-TH row of u
!
   vi = n + 1
   yk = b(vk)
50 vi = p(vi)
   if (vi >= k) go to 110
!
!  vi LT vk -- process the L(k,i) element and merge the
!  adjacency of vi with the ordered adjacency of vk
!
   lki = - x(vi)
   x(vi) = zero
!
!  Adjust right hand side to reflect elimination
!
   yk = yk + lki * y(vi)
   ppk = vi
   jmin = iu(vi)
   jmax = iu(vi + 1) - 1
   if (jmin > jmax) go to 50
   do j = jmin,jmax
      juj = ju(j)
      vj = ic(juj)
!
!  If vj is already in the adjacency of vk,
!  skip the insertion
!
      if (x(vj) /= zero) go to 90
!
!  Insert vj in adjacency list of vk.
!  Reset ppk to vi if we have passed the correct
!  insertion spot.  (This happens when the adjacency of
!  vi is not in current column order due to pivoting.)
!
      if (vj - ppk) 60,90,70
60    ppk = vi
70    pk = ppk
      ppk = p(pk)
      if (ppk - vj) 70,90,80
80    p(vj) = ppk
      p(pk) = vj
      ppk = vj
!
!  Compute L(k,j) = L(k,j) - L(k,i)*u(i,j) for L(k,i) nonzero
!  compute u*(k,j) = u*(k,j) - L(k,i)*u(i,j) for u(k,j) nonzero
!  (u*(k,j) = u(k,j)*D(k,k))
!
90    x(vj) = x(vj) + lki * u(j)
   end do
   go to 50
!
!  Pivot--interchange largest entry of k-TH row of u with
!  the diagonal entry.
!
!  Find largest entry, counting off-diagonal nonzeros
!
110 if (vi > n) go to 1004
   xpvmax = abs(real(x(vi))) + abs(aimag(x(vi)))
   maxc = vi
   nzcnt = 0
   pv = vi
120 v = pv
   pv = p(pv)
   if (pv > n) go to 130
   nzcnt = nzcnt + 1
   xpv = abs(real(x(pv))) + abs(aimag(x(pv)))
   if (xpv <= xpvmax) go to 120
   xpvmax = xpv
   maxc = pv
   maxcl = v
   go to 120
130 if (xpvmax == 0.0) go to 1004
!
!  If vi = k, then there is an entry for diagonal
!  which must be deleted.  Otherwise, delete the
!  entry which will become the diagonal entry
!
   if (vi == k) go to 140
   if (vi == maxc) go to 140
   p(maxcl) = p(maxc)
   go to 150
140 vi = p(vi)
!
!  Compute D(k) = 1/L(k,k) and perform interchange.
!
150 dk = one / x(maxc)
   x(maxc) = x(k)
   i = c(k)
   c(k) = c(maxc)
   c(maxc) = i
   ck = c(k)
   ic(ck) = k
   ic(i) = maxc
   x(k) = zero
!
!  Update right hand side.
!
   y(k) = yk * dk
!
!  Compute value for iu(k+1) and check for storage overflow
!
   iu(k + 1) = iu(k) + nzcnt
   if (iu(k + 1) > max + 1) go to 1005
!
!  Move column indices from linked list to ju.
!  Columns are stored in current order with original
!  column number (c(j)) stored for current column j
!
   if (vi > n) go to 170
   j = vi
160 juptr = juptr + 1
   ju(juptr) = c(j)
   u(juptr) = x(j) * dk
   x(j) = zero
   j = p(j)
   if (j <= n) go to 160
170 continue
!
!  Backsolve u x = y, and reorder x to correspond with A
!
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
!
!  RETURN WITH ierr = NUMBER OF OFF-DIAGONAL NONZEROS IN u
!
ierr = iu(n + 1) - iu(1)
return
!
!  Error returns
!
!  Row k of A is null
!
1002 ierr = -k
return
!
!  Row k of A has a duplicate entry
!
1003 ierr = -(n + k)
return
!
!  Zero pivot in row k
!
1004 ierr = -(2*n + k)
return
!
!  Storage for u exceeded on row k
!
1005 ierr = -(3*n + k)
return
end subroutine cnspiv

subroutine cslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: it, iu, jt, k, l
integer :: y, t, p
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!     cslv employs Gaussian elimination with column interchanges to
!     solve the NXN complex system AX = b. the argument m0 specifies
!     if cslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to cslv.
!
!
!     Input arguments when m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the complex matrix a stored in sparse form.
!
!     b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!              side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     Output arguments when m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to cslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to cslv
!     and solves the new equations AX = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call csplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call cslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
return
end subroutine cslv

pure subroutine cslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
complex, intent(in) :: b(n), d(n), t(*)
complex, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
complex :: sum
!
!            Solve LY = b by forward substitution
!
do 11 k = 1,n
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
!
!            Solve UX = b by backward substitution
!             and reorder x to correspond with A
!
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
return
end subroutine cslv1

subroutine ctslv(m0,n,a,ia,ja,b,r,c,max,x,iwk,wk,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m0, max, n
complex, intent(in) :: a(*), b(n)
complex, intent(inout) :: x(n), wk(*)
integer, intent(in) :: ia(*), ja(*)
integer, intent(inout) :: iwk(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n)
integer :: it, iu, jt, k, l
integer :: y, t, p
!-----------------------------------------------------------------------
!                 Solution of complex sparse matrices
!-----------------------------------------------------------------------
!     ctslv employs Gaussian elimination with column interchanges to
!     solve the NXN complex system XA = b. the argument m0 specifies
!     if ctslv is being called for the first time, or if it is being
!     recalled where A is the same matrix but b has been modified.
!     On an initial call to the routine (when m0=0) the LU DECOMPO-
!     sition of A is obtained where U is a unit upper triangular
!     matrix. Then the equations are solved. On subsequent calls
!     (when m0.NE.0) the equations are solved using the decomposition
!     obtained on the initial call to ctslv.
!
!
!     Input arguments when m0=0 ---
!
!     n        NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     a,ia,ja  the complex matrix a stored in sparse form.
!
!     b        COMPLEX ARRAY OF n ENTRIES CONTAINING THE RIGHT HAND
!              side data.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of l and U which may be stored.
!
!
!     Output arguments when m0=0 ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     x        COMPLEX ARRAY OF n ENTRIES CONTAINING THE SOLUTION.
!              b and x may share the same storage area.
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              solution of AX = b is obtained then ierr = max(1,M)
!              where M is the total number of off-diagonal nonzero
!              entries of l and U. otherwise ierr.LE.0.
!
!
!     General storage areas ---
!
!     iwk      INTEGER ARRAY OF DIMENSION 4*n + max + 2.
!
!     wk       COMPLEX ARRAY OF DIMENSION 2*n + max.
!
!
!     After an initial call to ctslv, the routine may be recalled with
!     m0.NE.0 for a new b. when m0.NE.0 it is assumed that n,A,ia,ja,
!     r,c,iwk,wk have not been modified. The routine retrieves the LU
!     decomposition which was obtained on the initial call to ctslv
!     and solves the new equations XA = b. in this case A,ia,ja,max,
!     and ierr are not referenced.
!-----------------------------------------------------------------------
!
!     Set indices to divide temporary storage
!
y = n + 1
t = y + n
p = n + 1
it = p + n + 1
iu = it + n + 1
jt = iu + n
if (m0 /= 0) go to 20
!
!     Compute the inverse permutation of c
!
ierr = 0
if (n <= 0) return
do k = 1,n
   l = c(k)
   iwk(l) = k
end do
!
!     Obtain the LU decomposition of A
!
call csplu(a,ia,ja,r,c,iwk(1),n,max,wk(1),wk(t),iwk(it),iwk(jt), &
   & iwk(iu),wk(y),iwk(p),ierr)
if (ierr < 0) return
ierr = max0(1,ierr)
!
!     Solve the system of equations
!
20 call ctslv1(n,r,c,iwk(1),wk(1),wk(t),iwk(it),iwk(jt),iwk(iu), &
   & b,x,wk(y))
return
end subroutine ctslv

pure subroutine ctslv1(n,r,c,ic,d,t,it,jt,iu,b,x,y)
implicit none
integer, intent(in) :: n
integer, intent(in) :: r(n), c(n), ic(n)
integer, intent(in) :: it(*), jt(*), iu(n)
complex, intent(in) :: b(n), d(n), t(*)
complex, intent(inout) :: x(n), y(n)
integer :: i, j, jj, jmax, jmin, k, lj, lk
!
!            Solve YU = b by forward substitution
!
do k = 1,n
   lk = c(k)
   y(k) = b(lk)
end do
!
do 21 k = 1,n
   if (y(k) == (0.0, 0.0)) go to 21
   jmin = iu(k)
   jmax = it(k + 1) - 1
   if (jmin > jmax) go to 21
   do jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      y(j) = y(j) - t(jj)*y(k)
   end do
21 continue
!
!            Solve XL = y by backward substitution
!
x(n) = y(n)/d(n)
if (n == 1) return
!
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
!
do k = 1,n
   lk = r(k)
   x(lk) = y(k)
end do
return
end subroutine ctslv1

subroutine csplu(a,ia,ja,r,c,ic,n,max,d,t,it,jt,iu,w,p,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: max, n
complex, intent(in) :: a(*)
complex, intent(inout) :: d(n), t(max), w(n)
integer, intent(in) :: ia(*), ja(*)
integer, intent(in) :: r(n)
integer, intent(inout) :: c(n), ic(n)
integer, intent(inout) :: it(*), jt(max), iu(n)
integer, intent(inout) :: p(*)
integer :: i, j, jj, jmax, jmin, jptr, k, lj, lk, ll, m, maxi, &
   & maxil
integer :: pm
complex :: const
real :: wi, wmax
complex, parameter :: zero = (0.0, 0.0)
!-----------------------------------------------------------------------
!     csplu employs Gaussian elimination with column interchanges
!     to perform the LU decomposition of a complex sparse matrix.
!     U is a unit upper triangular matrix.
!
!
!     Input arguments ---
!
!     A,ia,ja  the complex sparse matrix to be decomposed.
!
!     r        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the rows of A.
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING A SUGGESTED
!              order of the columns. c is also an output argument.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c
!              (I.E., ic(c(i)) = i). ic is also an output argument.
!
!     n        ORDER OF THE MATRIX a.
!
!     MAX      INTEGER SPECIFYING THE MAXIMUM NUMBER OF OFF-DIAGONAL
!              nonzero entries of L and U which may be stored.
!
!
!     Output arguments ---
!
!     c        INTEGER ARRAY OF n ENTRIES SPECIFYING THE ORDER OF
!              the columns that was selected by the routine.
!
!     ic       INTEGER ARRAY OF n ENTRIES WHICH IS THE INVERSE OF c.
!
!     d        COMPLEX ARRAY CONTAINING THE n DIAGONAL ELEMENTS OF L.
!
!     t,it,iu  t contains the off-diagonal nonzero elements of L and
!              U. for i = 1,...,n the off-diagonal nonzero elements
!              of the i-TH row of L are stored in locations
!              it(i),...,iu(i)-1 of t, and the off-diagonal nonzero
!              elements of the i-TH row of U are stored in locations
!              iu(i),...,it(i+1)-1 of t. t is a complex array.
!
!     jt       INTEGER ARRAY CONTAINING THE COLUMN INDICES (ACCORDING
!              to the orginal column ordering) of the elements of t
!              (I.E., for each L(i,j) and U(i,j) in t, c(j) is the
!              corresponding column index in jt).
!
!     ierr     INTEGER SPECIFYING THE STATUS OF THE RESULTS. IF THE
!              LU decomposition is obtained then ierr = The number
!              of off-diagonal entries of L and U which were stored
!              in t. otherwise ierr is assigned a negative value.
!
!
!     Work spaces ---
!
!     w        COMPLEX ARRAY OF DIMENSION n.
!
!     p        INTEGER ARRAY OF DIMENSION n+1.
!-----------------------------------------------------------------------
!--------------------
!--------------------
jptr = 0
it(1) = 1
do j = 1,n
   w(j) = zero
end do
!
!     Perform the LU factorization of the r(k)-TH row of A
!
do 100 k = 1,n
   lk = r(k)
   jmin = ia(lk)
   jmax = ia(lk + 1) - 1
   if (jmin > jmax) go to 200
!
!     Set p to the reordered row of A
!
   p(n + 1) = n + 1
   jj = jmax
20 lj = ja(jj)
   j = ic(lj)
   w(j) = a(jj)
   pm = n + 1
21 m = pm
   pm = p(m)
   if (pm - j) 21,210,22
22 p(m) = j
   p(j) = pm
   jj = jj - 1
   if (jj >= jmin) go to 20
!
!     Process the entries in the lower triangle of A
!
   i = n + 1
30 i = p(i)
   if (i >= k) go to 50
   if (w(i) == zero) go to 30
!
!     L(k,i) is nonzero. Therefore store it in L.
!
   jptr = jptr + 1
   if (jptr > max) go to 230
   const = w(i)
   t(jptr) = const
   jt(jptr) = c(i)
   w(i) = zero
!
!     Perform elimination using the i-TH row of U
!
   jmin = iu(i)
   jmax = it(i + 1) - 1
   if (jmin > jmax) go to 30
   pm = i
   do 43 jj = jmin,jmax
      lj = jt(jj)
      j = ic(lj)
      if (w(j) /= zero) go to 43
      if (j - pm) 40,43,41
40    pm = i
41    m = pm
      pm = p(m)
      if (pm - j) 41,43,42
42    p(m) = j
      p(j) = pm
      pm = j
43    w(j) = w(j) - const*t(jj)
   go to 30
!
!     Search for the k-TH pivot element
!
50 if (i > n) go to 220
   wmax = abs(real(w(i))) + abs(aimag(w(i)))
   maxi = i
   pm = i
51 m = pm
   pm = p(m)
   if (pm > n) go to 60
   wi = abs(real(w(pm))) + abs(aimag(w(pm)))
   if (wi <= wmax) go to 51
   wmax = wi
   maxi = pm
   maxil = m
   go to 51
!
!     Store the pivot in d
!
60 if (wmax == 0.0) go to 220
   d(k) = w(maxi)
!
!     Perform the column interchange
!
   if (i == k) go to 70
   if (i == maxi) go to 70
   p(maxil) = p(maxi)
   go to 80
70 i = p(i)
!
80 w(maxi) = w(k)
   w(k) = zero
   lk = c(k)
   ll = c(maxi)
   c(k) = ll
   c(maxi) = lk
   ic(lk) = maxi
   ic(ll) = k
!
!     The remaining elements of p form the k-TH row of U
!
   iu(k) = jptr + 1
90 if (i > n) go to 100
   if (w(i) == zero) go to 91
   jptr = jptr + 1
   if (jptr > max) go to 230
   t(jptr) = w(i)/d(k)
   jt(jptr) = c(i)
   w(i) = zero
91 i = p(i)
   go to 90
!
!     Prepare for the next row
!
100 it(k + 1) = jptr + 1
!
ierr = jptr
return
!
!     -------------------- Error return --------------------
!
!     Row r(k) is null
!
200 ierr = -k
return
!
!     Row r(k) has a duplicate entry
!
210 ierr = -(n + k)
return
!
!     Zero pivot in row r(k)
!
220 ierr = -(2*n + k)
return
!
!     Storage for L and U exceeded on row r(k)
!
230 ierr = -(3*n + k)
return
end subroutine csplu

pure subroutine eig(ibal,a,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n)
integer :: igh, low
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine elmhs0(nm,n,low,igh,a,int)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: int(igh)
   end subroutine elmhs0
   pure subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine hqr
end interface
!-----------------------------------------------------------------------
!                    Eigenvalues of real matrices
!-----------------------------------------------------------------------
!
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,wr)
call elmhs0(ka,n,low,igh,a,wr)
call hqr(ka,n,low,igh,a,wr,wi,ierr)
return
end subroutine eig

pure subroutine eig1(ibal,a,ka,n,wr,wi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n)
integer :: igh, low
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      integer, intent(out) :: ierr
   end subroutine hqr
   pure subroutine orthes(nm,n,low,igh,a,ort)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: ort(igh)
   end subroutine orthes
end interface
!-----------------------------------------------------------------------
!                    Eigenvalues of real matrices
!-----------------------------------------------------------------------
!
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,wr)
call orthes(ka,n,low,igh,a,wr)
call hqr(ka,n,low,igh,a,wr,wi,ierr)
return
end subroutine eig1

pure subroutine eigv(ibal,a,ka,n,wr,wi,zr,zi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n), zr(ka,n), zi(ka,n)
integer :: igh, j, k, kp1, low
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine balbak(nm,n,low,igh,scale,m,z)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(in) :: scale(n)
      real, intent(inout) :: z(nm,m)
   end subroutine balbak
   pure subroutine elmhs0(nm,n,low,igh,a,int)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: int(igh)
   end subroutine elmhs0
   pure subroutine eltrn0(nm,n,low,igh,a,int,z)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(in) :: a(nm,igh)
      real, intent(in) :: int(igh)
      real, intent(inout) :: z(nm,n)
   end subroutine eltrn0
   pure subroutine hqr2(nm,n,low,igh,h,wr,wi,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      real, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine hqr2
end interface
!-----------------------------------------------------------------------
!           Eigenvalues and eigenvectors of real matrices
!-----------------------------------------------------------------------
!
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,zi)
call elmhs0(ka,n,low,igh,a,wr)
call eltrn0(ka,n,low,igh,a,wr,zr)
call hqr2(ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr /= 0) return
if (ibal /= 0) call balbak(ka,n,low,igh,zi,n,zr)
!
do 30 k = 1,n
   if (wi(k)) 30,10,20
10 do 11 j = 1,n
11    zi(j,k) = 0.0
   go to 30
20 kp1 = k + 1
   do 21 j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
21    zi(j,kp1) = -zi(j,k)
30 continue
return
end subroutine eigv

pure subroutine eigv1(ibal,a,ka,n,wr,wi,zr,zi,ierr)
implicit none
integer, intent(in) :: ibal
integer, intent(inout) :: ierr
integer, intent(in) :: ka, n
real, intent(inout) :: a(ka,n), wr(n), wi(n), zr(ka,n), zi(ka,n)
integer :: igh, j, k, kp1, low
interface
   pure subroutine balanc(nm,n,a,low,igh,scale)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      real, intent(inout) :: a(nm,n)
      integer, intent(inout) :: low
      integer, intent(inout) :: igh
      real, intent(inout) :: scale(n)
   end subroutine balanc
   pure subroutine balbak(nm,n,low,igh,scale,m,z)
      implicit none
      integer, intent(in) :: m
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(in) :: scale(n)
      real, intent(inout) :: z(nm,m)
   end subroutine balbak
   pure subroutine hqr2(nm,n,low,igh,h,wr,wi,z,ierr)
      implicit none
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      integer, intent(in) :: igh
      real, intent(inout) :: h(nm,n)
      real, intent(inout) :: wr(n)
      real, intent(inout) :: wi(n)
      real, intent(inout) :: z(nm,n)
      integer, intent(out) :: ierr
   end subroutine hqr2
   pure subroutine orthes(nm,n,low,igh,a,ort)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(inout) :: a(nm,n)
      real, intent(inout) :: ort(igh)
   end subroutine orthes
   pure subroutine ortran(nm,n,low,igh,a,ort,z)
      implicit none
      integer, intent(in) :: igh
      integer, intent(in) :: n
      integer, intent(in) :: nm
      integer, intent(in) :: low
      real, intent(in) :: a(nm,igh)
      real, intent(inout) :: ort(igh)
      real, intent(inout) :: z(nm,n)
   end subroutine ortran
end interface
!-----------------------------------------------------------------------
!           Eigenvalues and eigenvectors of real matrices
!-----------------------------------------------------------------------
!
low = 1
igh = n
if (ibal /= 0) call balanc(ka,n,a,low,igh,zi)
call orthes(ka,n,low,igh,a,wr)
call ortran(ka,n,low,igh,a,wr,zr)
call hqr2(ka,n,low,igh,a,wr,wi,zr,ierr)
if (ierr /= 0) return
if (ibal /= 0) call balbak(ka,n,low,igh,zi,n,zr)
!
do 30 k = 1,n
   if (wi(k)) 30,10,20
10 do 11 j = 1,n
11    zi(j,k) = 0.0
   go to 30
20 kp1 = k + 1
   do 21 j = 1,n
      zi(j,k) = zr(j,kp1)
      zr(j,kp1) = zr(j,k)
21    zi(j,kp1) = -zi(j,k)
30 continue
return
end subroutine eigv1

pure subroutine balanc(nm,n,a,low,igh,scale)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(inout) :: igh, low
real, intent(inout) :: a(nm,n), scale(n)
integer :: i, j, k, l, m
integer :: jj
integer :: iexc
real :: c, f, g, r, s, b2, radix
logical :: noconv
interface
   pure elemental function ipmpar(i)
      implicit none
      integer, intent(in) :: i
      integer :: ipmpar
   end function ipmpar
end interface
!     real abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure balance,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.II-linear algebra, 315-326(1971).
!
!     This subroutine balances a real matrix and isolates
!     eigenvalues whenever possible.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        A contains the input matrix to be balanced.
!
!     On output-
!
!        A contains the balanced matrix,
!
!        Low and igh are two integers such that a(i,j)
!          is equal to zero if
!           (1) i is greater than j and
!           (2) j=1,...,low-1 OR i=igh+1,...,n,
!
!        Scale contains information determining the
!           permutations and scaling factors used.
!
!     Suppose that the principal submatrix in rows low through igh
!     has been balanced, that P(j) denotes the index interchanged
!     with j during the permutation step, and that the elements
!     of the diagonal matrix used are denoted by D(i,j).  Then
!        scale(j) = P(j),    FOR j = 1,...,low-1
!                 = D(j,j),      j = low,...,igh
!                 = P(j)         j = igh+1,...,n.
!     The order in which the interchanges are made is n to igh+1,
!     then 1 to low-1.
!
!     Note that 1 is returned for igh if igh is zero formally.
!
!     The Algol procedure exc contained in balance appears in
!     balanc  in line.  (Note that the Algol roles of identifiers
!     k,l have been reversed.)
!
!-----------------------------------------------------------------------
!
!     ********** radix is a machine dependent parameter specifying
!                the base of the machine floating point representation.
!
radix = ipmpar(4)
!
!                **********
!
b2 = radix * radix
k = 1
l = n
go to 100
!     ********** In-line procedure for row and
!                column exchange **********
20 scale(m) = j
if (j == m) go to 50
!
do i = 1, l
   f = a(i,j)
   a(i,j) = a(i,m)
   a(i,m) = f
end do
!
do i = k, n
   f = a(j,i)
   a(j,i) = a(m,i)
   a(m,i) = f
end do
!
50 go to (80,130), iexc
!     ********** Search for rows isolating an eigenvalue
!                and push them down **********
80 if (l == 1) go to 280
l = l - 1
!     ********** FOR j=l STEP -1 UNTIL 1 DO -- **********
100 do 120 jj = 1, l
   j = l + 1 - jj
!
   do 110 i = 1, l
      if (i == j) go to 110
      if (a(j,i) /= 0.0) go to 120
110   continue
!
   m = l
   iexc = 1
   go to 20
120 continue
!
go to 140
!     ********** Search for columns isolating an eigenvalue
!                and push them left **********
130 k = k + 1
!
140 do 170 j = k, l
!
   do 150 i = k, l
      if (i == j) go to 150
      if (a(i,j) /= 0.0) go to 170
150   continue
!
   m = k
   iexc = 2
   go to 20
170 continue
!     ********** Now balance the submatrix in rows k to l **********
do 180 i = k, l
180 scale(i) = 1.0
!     ********** Iterative loop for norm reduction **********
190 noconv = .false.
!
do 270 i = k, l
   c = 0.0
   r = 0.0
!
   do 200 j = k, l
      if (j == i) go to 200
      c = c + abs(a(j,i))
      r = r + abs(a(i,j))
200   continue
!     ********** Guard against zero c or r due to underflow **********
   if (c == 0.0 .or. r == 0.0) go to 270
   g = r / radix
   f = 1.0
   s = c + r
210 if (c >= g) go to 220
   f = f * radix
   c = c * b2
   go to 210
220 g = r * radix
230 if (c < g) go to 240
   f = f / radix
   c = c / b2
   go to 230
!     ********** Now balance **********
240 if ((c + r) / f >= 0.95 * s) go to 270
   g = 1.0 / f
   scale(i) = scale(i) * f
   noconv = .true.
!
   do 250 j = k, n
250   a(i,j) = a(i,j) * g
!
   do 260 j = 1, l
260   a(j,i) = a(j,i) * f
!
270 continue
!
if (noconv) go to 190
!
280 low = k
igh = l
return
end subroutine balanc

pure subroutine balinv(nz,n,z,low,igh,scale)
implicit none
integer, intent(in) :: n
integer, intent(in) :: nz, igh, low
real, intent(inout) :: z(nz,n)
real, intent(in) :: scale(n)
integer :: i, j, k
integer :: ii
real :: s
!-----------------------------------------------------------------------
!        Given A matrix A of order n. balanc transforms A into
!     the matrix B by the similarity transformation
!             b = d**(-1)*transpose(p)*a*p*d
!     where D is a diagonal matrix and P a permutation matrix.
!     The information concerning D and P is stored in igh, low,
!     and scale. The order in which the interchanges were made
!     is n to igh + 1, and then 1 to low - 1.
!
!        z is a matrix of order n. balinv transforms z into the
!     matrix W using the inverse similarity transform
!             w = p*d*z*d**(-1)*transpose(p)
!
!     On input-
!
!        nz is the row dimension of the matrix z in the calling
!          program,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by  balanc,
!
!        Scale contains information determining the permutations
!          and scaling factors used by  balanc,
!
!     On output-
!
!        z contains the transformed matrix W
!
!-----------------------------------------------------------------------
!
if (igh == low) go to 30
!
do i = low, igh
   s = scale(i)
   do 10 j = 1, n
10    z(i,j) = z(i,j) * s
end do
!
do j = low, igh
   s = 1.0/scale(j)
   do 20 i = 1, n
20    z(i,j) = z(i,j) * s
end do
!
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
!
30 do 60 ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 60
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 60
!
   do 40 j = 1, n
      s = z(i,j)
      z(i,j) = z(k,j)
40    z(k,j) = s
!
   do 50 j = 1, n
      s = z(j,i)
      z(j,i) = z(j,k)
50    z(j,k) = s
60 continue
return
end subroutine balinv

pure subroutine elmhes(nm,n,low,igh,a,int)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: a(nm,n)
integer, intent(inout) :: int(igh)
integer :: i, j, m
integer :: la
integer :: kp1
integer :: mm1, mp1
real :: x, y
!     real abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure elmhes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     stabilized elementary similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        A contains the input matrix.
!
!     On output-
!
!        A contains the Hessenberg matrix.  The multipliers
!          which were used in the reduction are stored in the
!          remaining triangle under the Hessenberg matrix,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction.
!          Only elements low through igh are used.
!
!-----------------------------------------------------------------------
!
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
!
do 180 m = kp1, la
   mm1 = m - 1
   x = 0.0
   i = m
!
   do 100 j = m, igh
      if (abs(a(j,mm1)) <= abs(x)) go to 100
      x = a(j,mm1)
      i = j
100   continue
!
   int(m) = i
   if (i == m) go to 130
!    ********** Interchange rows and columns of a **********
   do j = mm1, n
      y = a(i,j)
      a(i,j) = a(m,j)
      a(m,j) = y
   end do
!
   do j = 1, igh
      y = a(j,i)
      a(j,i) = a(j,m)
      a(j,m) = y
   end do
!    ********** End interchange **********
130 if (x == 0.0) go to 180
   mp1 = m + 1
!
   do 160 i = mp1, igh
      y = a(i,mm1)
      if (y == 0.0) go to 160
      y = y / x
      a(i,mm1) = y
!
      do 140 j = m, n
140      a(i,j) = a(i,j) - y * a(m,j)
!
      do 150 j = 1, igh
150      a(j,m) = a(j,m) + y * a(j,i)
!
160   continue
!
180 continue
!
200 return
end subroutine elmhes

pure subroutine elmhs0(nm,n,low,igh,a,int)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: a(nm,n)
real, intent(inout) :: int(igh)
integer :: i, j, m
integer :: la
integer :: kp1
integer :: mm1, mp1
real :: x, y
!     real abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure elmhes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 339-358(1971).
!
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     stabilized elementary similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        A contains the input matrix.
!
!     On output-
!
!        A contains the Hessenberg matrix.  The multipliers
!          which were used in the reduction are stored in the
!          remaining triangle under the Hessenberg matrix,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction.
!          Only elements low through igh are used.
!
!-----------------------------------------------------------------------
!
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
!
do 180 m = kp1, la
   mm1 = m - 1
   x = 0.0
   i = m
!
   do 100 j = m, igh
      if (abs(a(j,mm1)) <= abs(x)) go to 100
      x = a(j,mm1)
      i = j
100   continue
!
   int(m) = i
   if (i == m) go to 130
!    ********** Interchange rows and columns of a **********
   do j = mm1, n
      y = a(i,j)
      a(i,j) = a(m,j)
      a(m,j) = y
   end do
!
   do j = 1, igh
      y = a(j,i)
      a(j,i) = a(j,m)
      a(j,m) = y
   end do
!    ********** End interchange **********
130 if (x == 0.0) go to 180
   mp1 = m + 1
!
   do 160 i = mp1, igh
      y = a(i,mm1)
      if (y == 0.0) go to 160
      y = y / x
      a(i,mm1) = y
!
      do 140 j = m, n
140      a(i,j) = a(i,j) - y * a(m,j)
!
      do 150 j = 1, igh
150      a(j,m) = a(j,m) + y * a(j,i)
!
160   continue
!
180 continue
!
200 return
end subroutine elmhs0

pure subroutine orthes(nm,n,low,igh,a,ort)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
real, intent(inout) :: a(nm,n), ort(igh)
integer :: i, j, m
integer :: ii, jj, la, mp
integer :: kp1
real :: f, g, h, scale
!     real sqrt,abs
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure orthes,
!     NUM. Math. 12, 349-368(1968) By Martin and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 339-358(1971).
!
!     Given a real general matrix, this subroutine
!     reduces a submatrix situated in rows and columns
!     low through igh to upper Hessenberg form by
!     orthogonal similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        A contains the input matrix.
!
!     On output-
!
!        A contains the Hessenberg matrix.  Information about
!          the orthogonal transformations used in the reduction
!          is stored in the remaining triangle under the
!          Hessenberg matrix,
!
!        Ort contains further information about the transformations.
!          Only elements low through igh are used.
!
!-----------------------------------------------------------------------
!
la = igh - 1
kp1 = low + 1
if (la < kp1) go to 200
!
do 180 m = kp1, la
   h = 0.0
   ort(m) = 0.0
   scale = 0.0
!     ********** scale COLUMN (ALGOL TOL THEN NOT NEEDED) **********
   do 90 i = m, igh
90    scale = scale + abs(a(i,m - 1))
!
   if (scale == 0.0) go to 180
   mp = m + igh
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
   do ii = m, igh
      i = mp - ii
      ort(i) = a(i,m - 1) / scale
      h = h + ort(i) * ort(i)
   end do
!
   g = sqrt(h)
   if (ort(m) >= 0.0) g = -g
   h = h - ort(m) * g
   ort(m) = ort(m) - g
!     ********** FORM (i-(U*UT)/h) * a **********
   do j = m, n
      f = 0.0
!     ********** FOR i=igh STEP -1 UNTIL m DO -- **********
      do ii = m, igh
         i = mp - ii
         f = f + ort(i) * a(i,j)
      end do
!
      f = f / h
!
      do 120 i = m, igh
120      a(i,j) = a(i,j) - f * ort(i)
!
   end do
!     ********** FORM (i-(U*UT)/h)*a*(i-(U*UT)/h) **********
   do i = 1, igh
      f = 0.0
!     ********** FOR j=igh STEP -1 UNTIL m DO -- **********
      do jj = m, igh
         j = mp - jj
         f = f + ort(j) * a(i,j)
      end do
!
      f = f / h
!
      do 150 j = m, igh
150      a(i,j) = a(i,j) - f * ort(j)
!
   end do
!
   ort(m) = scale * ort(m)
   a(m,m - 1) = scale * g
180 continue
!
200 return
end subroutine orthes

pure subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm, igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: h(nm,n), wr(n), wi(n)
integer :: i, j, k, l, m
integer :: en, ll, mm, na
integer :: its
integer :: mp2, enm2
real :: p, q, r, s, t, w, x, y, zz, norm, machep
logical :: notlas
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs
!     integer min0
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure hqr,
!     NUM. Math. 14, 219-231(1970) By Martin, peters, and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 359-371(1971).
!
!     This subroutine finds the eigenvalues of a real
!     upper Hessenberg matrix BY the QR method.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        h contains the upper Hessenberg matrix.  Information about
!          the transformations used in the reduction to Hessenberg
!          form by  elmhes  or  orthes, if performed, is stored
!          in the remaining triangle under the Hessenberg matrix.
!
!     On output-
!
!        h has been destroyed.  Therefore, it must be saved
!          before calling  hqr  if subsequent calculation and
!          back transformation of eigenvectors is to be performed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!-----------------------------------------------------------------------
!
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
!
machep = spmpar(1)
!
!                **********
!
ierr = 0
norm = 0.0
k = 1
!     ********** Store roots isolated by balanc
!                and compute matrix norm **********
do 50 i = 1, n
!
   do 40 j = k, n
40    norm = norm + abs(h(i,j))
!
   k = i
   if (i >= low .and. i <= igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.0
50 continue
!
en = igh
t = 0.0
!     ********** Search for next eigenvalues **********
60 if (en < low) go to 1001
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
70 do ll = low, en
   l = en + low - ll
   if (l == low) go to 100
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.0) s = norm
   if (abs(h(l,l - 1)) <= machep * s) go to 100
end do
!     ********** Form shift **********
100 x = h(en,en)
if (l == en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l == na) go to 280
if (its == 30) go to 1000
if (its /= 10 .and. its /= 20) go to 130
!     ********** Form exceptional shift **********
t = t + x
!
do 120 i = low, en
120 h(i,i) = h(i,i) - x
!
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75 * s
y = x
w = -0.4375 * s * s
130 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m == l) go to 150
   if (abs(h(m,m - 1)) * (abs(q) + abs(r)) <= machep * abs(p) &
      & * (abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))) go to 150
end do
!
150 mp2 = m + 2
!
do 160 i = mp2, en
   h(i,i - 2) = 0.0
   if (i == mp2) go to 160
   h(i,i - 3) = 0.0
160 continue
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do 260 k = m, na
   notlas = k /= na
   if (k == m) go to 170
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p < 0.0) s = -s
   if (k == m) go to 180
   h(k,k - 1) = -s * x
   go to 190
180 if (l /= m) h(k,k - 1) = -h(k,k - 1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** Row modification **********
   do j = k, en
      p = h(k,j) + q * h(k + 1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p * zz
200   h(k + 1,j) = h(k + 1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
!
   j = min0(en,k + 3)
!     ********** Column modification **********
   do i = l, j
      p = x * h(i,k) + y * h(i,k + 1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p * r
220   h(i,k + 1) = h(i,k + 1) - p * q
      h(i,k) = h(i,k) - p
   end do
!
260 continue
!
go to 70
!     ********** One root found **********
270 wr(en) = x + t
wi(en) = 0.0
en = na
go to 60
!     ********** Two roots found **********
280 p = (y - x) / 2.0
q = p * p + w
zz = sqrt(abs(q))
x = x + t
if (q < 0.0) go to 320
!     ********** Real pair **********
if (p < 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.0) wr(en) = x - w / zz
wi(na) = 0.0
wi(en) = 0.0
go to 330
!     ********** Complex pair **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
end subroutine hqr

pure subroutine balbak(nm,n,low,igh,scale,m,z)
implicit none
!
integer, intent(in) :: m, n
integer, intent(in) :: nm, igh, low
real, intent(in) :: scale(n)
real, intent(inout) :: z(nm,m)
integer :: i, j, k
integer :: ii
real :: s
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure balbak,
!     NUM. Math. 13, 293-304(1969) By Parlett and Reinsch.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 315-326(1971).
!
!     This subroutine forms the eigenvectors of a real general
!     matrix BY back transforming those of the corresponding
!     balanced matrix determined by  balanc.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by  balanc,
!
!        Scale contains information determining the permutations
!          and scaling factors used by  balanc,
!
!        m is the number of columns of z to be back transformed,
!
!        z contains the real and imaginary parts of the eigen-
!          vectors to be back transformed in its first m columns.
!
!     On output-
!
!        z contains the real and imaginary parts of the
!          transformed eigenvectors in its first m columns.
!
!-----------------------------------------------------------------------
!
if (m == 0) go to 200
if (igh == low) go to 120
!
do i = low, igh
   s = scale(i)
!     ********** Left hand eigenvectors are back transformed
!                if the foregoing statement is replaced by
!                s=1.0/scale(i). **********
   do 100 j = 1, m
100   z(i,j) = z(i,j) * s
!
end do
!     ********- FOR i=low-1 STEP -1 UNTIL 1,
!               igh+1 STEP 1 UNTIL n DO -- **********
120 do 140 ii = 1, n
   i = ii
   if (i >= low .and. i <= igh) go to 140
   if (i < low) i = low - ii
   k = scale(i)
   if (k == i) go to 140
!
   do j = 1, m
      s = z(i,j)
      z(i,j) = z(k,j)
      z(k,j) = s
   end do
!
140 continue
!
200 return
end subroutine balbak

pure subroutine eltran(nm,n,low,igh,a,int,z)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm, igh, low
real, intent(in) :: a(nm,igh)
real, intent(inout) :: z(nm,n)
integer, intent(in) :: int(igh)
integer :: i, j
integer :: kl, mm, mp
integer :: mp1
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ELMTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the stabilized elementary
!     similarity transformations used in the reduction of A
!     real general matrix to upper Hessenberg form by  elmhes.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        A contains the multipliers which were used in the
!          reduction by  elmhes  in its lower triangle
!          below the subdiagonal,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction by  elmhes.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  elmhes.
!
!-----------------------------------------------------------------------
!
!     ********** Initialize z to identity matrix **********
do i = 1, n
!
   do 60 j = 1, n
60    z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do 140 mm = 1, kl
   mp = igh - mm
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100   z(i,mp) = a(i,mp - 1)
!
   i = int(mp)
   if (i == mp) go to 140
!
   do j = mp, igh
      z(mp,j) = z(i,j)
      z(i,j) = 0.0
   end do
!
   z(i,mp) = 1.0
140 continue
!
200 return
end subroutine eltran

pure subroutine eltrn0(nm,n,low,igh,a,int,z)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm, igh, low
real, intent(in) :: a(nm,igh)
real, intent(inout) :: z(nm,n)
real, intent(in) :: int(igh)
integer :: i, j
integer :: kl, mm, mp
integer :: mp1
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ELMTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the stabilized elementary
!     similarity transformations used in the reduction of A
!     real general matrix to upper Hessenberg form by  elmhs0.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        A contains the multipliers which were used in the
!          reduction by  elmhs0  in its lower triangle
!          below the subdiagonal,
!
!        Int contains information on the rows and columns
!          interchanged in the reduction by  elmhs0.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  elmhs0.
!
!-----------------------------------------------------------------------
!
!     ********** Initialize z to identity matrix **********
do i = 1, n
!
   do 60 j = 1, n
60    z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do 140 mm = 1, kl
   mp = igh - mm
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100   z(i,mp) = a(i,mp - 1)
!
   i = int(mp)
   if (i == mp) go to 140
!
   do j = mp, igh
      z(mp,j) = z(i,j)
      z(i,j) = 0.0
   end do
!
   z(i,mp) = 1.0
140 continue
!
200 return
end subroutine eltrn0

pure subroutine ortran(nm,n,low,igh,a,ort,z)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm, igh, low
real, intent(in) :: a(nm,igh)
real, intent(inout) :: ort(igh), z(nm,n)
integer :: i, j
integer :: kl, mm, mp
integer :: mp1
real :: g
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real general
!     matrix to upper Hessenberg form by  orthes.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction by  orthes
!          in its strict lower triangle,
!
!        Ort contains further information about the trans-
!          formations used in the reduction by  orthes.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  orthes,
!
!        Ort has been altered.
!
!-----------------------------------------------------------------------
!
!     ********** Initialize z to identity matrix **********
do i = 1, n
!
   do 60 j = 1, n
60    z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do 140 mm = 1, kl
   mp = igh - mm
   if (a(mp,mp - 1) == 0.0) go to 140
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100   ort(i) = a(i,mp - 1)
!
   do j = mp, igh
      g = 0.0
!
      do 110 i = mp, igh
110      g = g + ort(i) * z(i,j)
!     ********** Divisor below is negative of H formed in orthes.
!                Double division avoids possible underflow **********
      g = (g / ort(mp)) / a(mp,mp - 1)
!
      do 120 i = mp, igh
120      z(i,j) = z(i,j) + g * ort(i)
!
   end do
!
140 continue
!
200 return
end subroutine ortran

pure subroutine ortrn1(n,low,igh,a,na,z,nz,ort)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: na, igh, low
integer, intent(in) :: nz
real, intent(in) :: a(na,igh)
real, intent(inout) :: ort(igh), z(nz,n)
integer :: i, j
integer :: kl, mm, mp
integer :: mp1
real :: g
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure ORTRANS,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.II-linear algebra, 372-395(1971).
!
!     This subroutine accumulates the orthogonal similarity
!     transformations used in the reduction of a real general
!     matrix to upper Hessenberg form by  orthes.
!
!     On input-
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        A contains information about the orthogonal trans-
!          formations used in the reduction by  orthes
!          in its strict lower triangle,
!
!        na must be set to the row dimension of the 2-dimensional
!          array parameter  a  as declared in the calling program
!          dimension statement,
!
!        nz must be set to the row dimension of the 2-dimensional
!          array parameter  z  as declared in the calling program
!          dimension statement,
!
!        Ort contains further information about the trans-
!          formations used in the reduction by  orthes.
!          Only elements low through igh are used.
!
!     On output-
!
!        z contains the transformation matrix produced in the
!          reduction by  orthes,
!
!        Ort has been altered.
!
!-----------------------------------------------------------------------
!
!     ********** Initialize z to identity matrix **********
do i = 1, n
!
   do 60 j = 1, n
60    z(i,j) = 0.0
!
   z(i,i) = 1.0
end do
!
kl = igh - low - 1
if (kl < 1) go to 200
!     ********** For mp=igh-1 step -1 Until low+1 do -- **********
do 140 mm = 1, kl
   mp = igh - mm
   if (a(mp,mp - 1) == 0.0) go to 140
   mp1 = mp + 1
!
   do 100 i = mp1, igh
100   ort(i) = a(i,mp - 1)
!
   do j = mp, igh
      g = 0.0
!
      do 110 i = mp, igh
110      g = g + ort(i) * z(i,j)
!     ********** Divisor below is negative of H formed in orthes.
!                Double division avoids possible underflow **********
      g = (g / ort(mp)) / a(mp,mp - 1)
!
      do 120 i = mp, igh
120      z(i,j) = z(i,j) + g * ort(i)
!
   end do
!
140 continue
!
200 return
end subroutine ortrn1

pure subroutine hqr2(nm,n,low,igh,h,wr,wi,z,ierr)
implicit none
!
integer, intent(in) :: n
integer, intent(in) :: nm
integer, intent(in) :: igh
integer, intent(in) :: low
integer, intent(out) :: ierr
real, intent(inout) :: h(nm,n), wr(n), wi(n), z(nm,n)
integer :: i, j, k, l, m
integer :: en, ii, jj, ll, mm, na
integer :: nn
integer :: its
integer :: mp2, enm2
real :: p, q, r, s, t, w, x, y, ra, sa, vi, vr, zz, norm, machep
logical :: notlas
complex :: z3
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!     real sqrt,abs
!     integer min0
!     complex cmplx
!     real real,aimag
!-----------------------------------------------------------------------
!
!     This subroutine is a translation of the Algol procedure hqr2,
!     NUM. Math. 16, 181-204(1970) By peters and Wilkinson.
!     Handbook for auto. Comp., Vol.ii-linear algebra, 372-395(1971).
!
!     This subroutine finds the eigenvalues and eigenvectors
!     of a real upper Hessenberg matrix BY the QR method.  The
!     eigenvectors of a real general matrix can also be found
!     if  elmhes  and  eltran  or  orthes  and  ortran  have
!     been used to reduce this general matrix to Hessenberg form
!     and to accumulate the similarity transformations.
!
!     On input-
!
!        nm must be set to the row dimension of two-dimensional
!          array parameters as declared in the calling program
!          dimension statement,
!
!        n is the order of the matrix,
!
!        Low and igh are integers determined by the balancing
!          subroutine  balanc.  If  balanc  has not been used,
!          set low=1, igh=n,
!
!        h contains the upper Hessenberg matrix,
!
!        z contains the transformation matrix produced by  eltran
!          after the reduction by  elmhes, or by  ortran  after the
!          reduction by  orthes, if performed.  If the eigenvectors
!          of the Hessenberg matrix are desired, z must contain the
!          identity matrix.
!
!     On output-
!
!        h has been destroyed,
!
!        wr and wi contain the real and imaginary parts,
!          respectively, of the eigenvalues.  The eigenvalues
!          are unordered except that complex conjugate pairs
!          of values appear consecutively with the eigenvalue
!          having the positive imaginary part first.  If an
!          error exit is made, the eigenvalues should be correct
!          for indices ierr+1,...,n,
!
!        z contains the real and imaginary parts of the eigenvectors.
!          If the i-TH eigenvalue is real, the i-TH column of z
!          contains its eigenvector.  If the i-TH eigenvalue is complex
!          with positive imaginary part, the i-TH and (i+1)-TH
!          columns of z contain the real and imaginary parts of its
!          eigenvector.  The eigenvectors are unnormalized.  If an
!          error exit is made, none of the eigenvectors has been found,
!
!        ierr is set to
!          ZERO       FOR NORMAL RETURN,
!          j          IF THE j-TH EIGENVALUE HAS NOT BEEN
!                     determined after 30 iterations.
!
!     Arithmetic is real except for the replacement of the Algol
!     procedure cdiv by complex division.
!
!-----------------------------------------------------------------------
!
!     ********** machep is a machine dependent parameter. Assign
!                machep the value U where U is the smallest positive
!                floating point number such that 1.0 + U .GT. 1.0 .
!
machep = spmpar(1)
!
!                **********
!
ierr = 0
norm = 0.0
k = 1
!     ********** Store roots isolated by balanc
!                and compute matrix norm **********
do 50 i = 1, n
!
   do 40 j = k, n
40    norm = norm + abs(h(i,j))
!
   k = i
   if (i >= low .and. i <= igh) go to 50
   wr(i) = h(i,i)
   wi(i) = 0.0
50 continue
!
en = igh
t = 0.0
!     ********** Search for next eigenvalues **********
60 if (en < low) go to 340
its = 0
na = en - 1
enm2 = na - 1
!     ********** Look for single small sub-diagonal element
!                for l=en step -1 Until low do -- **********
70 do ll = low, en
   l = en + low - ll
   if (l == low) go to 100
   s = abs(h(l - 1,l - 1)) + abs(h(l,l))
   if (s == 0.0) s = norm
   if (abs(h(l,l - 1)) <= machep * s) go to 100
end do
!     ********** Form shift **********
100 x = h(en,en)
if (l == en) go to 270
y = h(na,na)
w = h(en,na) * h(na,en)
if (l == na) go to 280
if (its == 30) go to 1000
if (its /= 10 .and. its /= 20) go to 130
!     ********** Form exceptional shift **********
t = t + x
!
do 120 i = low, en
120 h(i,i) = h(i,i) - x
!
s = abs(h(en,na)) + abs(h(na,enm2))
x = 0.75 * s
y = x
w = -0.4375 * s * s
130 its = its + 1
!     ********** Look for two consecutive small
!                sub-diagonal elements.
!                FOR m=en-2 STEP -1 UNTIL l DO -- **********
do mm = l, enm2
   m = enm2 + l - mm
   zz = h(m,m)
   r = x - zz
   s = y - zz
   p = (r * s - w) / h(m + 1,m) + h(m,m + 1)
   q = h(m + 1,m + 1) - zz - r - s
   r = h(m + 2,m + 1)
   s = abs(p) + abs(q) + abs(r)
   p = p / s
   q = q / s
   r = r / s
   if (m == l) go to 150
   if (abs(h(m,m - 1)) * (abs(q) + abs(r)) <= machep * abs(p) &
      & * (abs(h(m - 1,m - 1)) + abs(zz) + abs(h(m + 1,m + 1)))) go to 150
end do
!
150 mp2 = m + 2
!
do 160 i = mp2, en
   h(i,i - 2) = 0.0
   if (i == mp2) go to 160
   h(i,i - 3) = 0.0
160 continue
!     ********** Double QR step involving rows l to en and
!                COLUMNS m TO en **********
do 260 k = m, na
   notlas = k /= na
   if (k == m) go to 170
   p = h(k,k - 1)
   q = h(k + 1,k - 1)
   r = 0.0
   if (notlas) r = h(k + 2,k - 1)
   x = abs(p) + abs(q) + abs(r)
   if (x == 0.0) go to 260
   p = p / x
   q = q / x
   r = r / x
170 s = sqrt(p*p + q*q + r*r)
   if (p < 0.0) s = -s
   if (k == m) go to 180
   h(k,k - 1) = -s * x
   go to 190
180 if (l /= m) h(k,k - 1) = -h(k,k - 1)
190 p = p + s
   x = p / s
   y = q / s
   zz = r / s
   q = q / p
   r = r / p
!     ********** Row modification **********
   do j = k, n
      p = h(k,j) + q * h(k + 1,j)
      if (.not. notlas) go to 200
      p = p + r * h(k + 2,j)
      h(k + 2,j) = h(k + 2,j) - p * zz
200   h(k + 1,j) = h(k + 1,j) - p * y
      h(k,j) = h(k,j) - p * x
   end do
!
   j = min0(en,k + 3)
!     ********** Column modification **********
   do i = 1, j
      p = x * h(i,k) + y * h(i,k + 1)
      if (.not. notlas) go to 220
      p = p + zz * h(i,k + 2)
      h(i,k + 2) = h(i,k + 2) - p * r
220   h(i,k + 1) = h(i,k + 1) - p * q
      h(i,k) = h(i,k) - p
   end do
!     ********** Accumulate transformations **********
   do i = low, igh
      p = x * z(i,k) + y * z(i,k + 1)
      if (.not. notlas) go to 240
      p = p + zz * z(i,k + 2)
      z(i,k + 2) = z(i,k + 2) - p * r
240   z(i,k + 1) = z(i,k + 1) - p * q
      z(i,k) = z(i,k) - p
   end do
!
260 continue
!
go to 70
!     ********** One root found **********
270 h(en,en) = x + t
wr(en) = h(en,en)
wi(en) = 0.0
en = na
go to 60
!     ********** Two roots found **********
280 p = (y - x) / 2.0
q = p * p + w
zz = sqrt(abs(q))
h(en,en) = x + t
x = h(en,en)
h(na,na) = y + t
if (q < 0.0) go to 320
!     ********** Real pair **********
if (p < 0.0) zz = -zz
zz = p + zz
wr(na) = x + zz
wr(en) = wr(na)
if (zz /= 0.0) wr(en) = x - w / zz
wi(na) = 0.0
wi(en) = 0.0
x = h(en,na)
s = abs(x) + abs(zz)
p = x / s
q = zz / s
r = sqrt(p*p + q*q)
p = p / r
q = q / r
!     ********** Row modification **********
do j = na, n
   zz = h(na,j)
   h(na,j) = q * zz + p * h(en,j)
   h(en,j) = q * h(en,j) - p * zz
end do
!     ********** Column modification **********
do i = 1, en
   zz = h(i,na)
   h(i,na) = q * zz + p * h(i,en)
   h(i,en) = q * h(i,en) - p * zz
end do
!     ********** Accumulate transformations **********
do i = low, igh
   zz = z(i,na)
   z(i,na) = q * zz + p * z(i,en)
   z(i,en) = q * z(i,en) - p * zz
end do
!
go to 330
!     ********** Complex pair **********
320 wr(na) = x + p
wr(en) = x + p
wi(na) = zz
wi(en) = -zz
330 en = enm2
go to 60
!     ********** All roots found.  Backsubstitute to find
!                vectors of upper triangular form **********
340 if (norm == 0.0) go to 1001
!     ********** FOR en=n STEP -1 UNTIL 1 DO -- **********
do 800 nn = 1, n
   en = n + 1 - nn
   p = wr(en)
   q = wi(en)
   na = en - 1
   if (q) 710, 600, 800
!     ********** Real vector **********
600 m = en
   h(en,en) = 1.0
   if (na == 0) go to 800
!     ********** FOR i=en-1 STEP -1 UNTIL 1 DO -- **********
   do 700 ii = 1, na
      i = en - ii
      w = h(i,i) - p
      r = h(i,en)
      if (m > na) go to 620
!
      do 610 j = m, na
610      r = r + h(i,j) * h(j,en)
!
620   if (wi(i) >= 0.0) go to 630
      zz = w
      s = r
      go to 700
630   m = i
      if (wi(i) /= 0.0) go to 640
      t = w
      if (w == 0.0) t = machep * norm
      h(i,en) = -r / t
      go to 700
!     ********** Solve real equations **********
640   x = h(i,i + 1)
      y = h(i + 1,i)
      q = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i)
      t = (x * s - zz * r) / q
      h(i,en) = t
      if (abs(x) <= abs(zz)) go to 650
      h(i + 1,en) = (-r - w * t) / x
      go to 700
650   h(i + 1,en) = (-s - y * t) / zz
700   continue
!     ********** End real vector **********
   go to 800
!     ********** Complex vector **********
710 m = na
!     ********** Last vector component chosen imaginary so that
!                eigenvector matrix is triangular **********
   if (abs(h(en,na)) <= abs(h(na,en))) go to 720
   h(na,na) = q / h(en,na)
   h(na,en) = -(h(en,en) - p) / h(en,na)
   go to 730
720 z3 = cmplx(0.0,-h(na,en)) / cmplx(h(na,na) - p,q)
   h(na,na) = real(z3)
   h(na,en) = aimag(z3)
730 h(en,na) = 0.0
   h(en,en) = 1.0
   enm2 = na - 1
   if (enm2 == 0) go to 800
!     ********** FOR i=en-2 STEP -1 UNTIL 1 DO -- **********
   do 790 ii = 1, enm2
      i = na - ii
      w = h(i,i) - p
      ra = 0.0
      sa = h(i,en)
!
      do j = m, na
         ra = ra + h(i,j) * h(j,na)
         sa = sa + h(i,j) * h(j,en)
      end do
!
      if (wi(i) >= 0.0) go to 770
      zz = w
      r = ra
      s = sa
      go to 790
770   m = i
      if (wi(i) /= 0.0) go to 780
      z3 = cmplx(-ra,-sa) / cmplx(w,q)
      h(i,na) = real(z3)
      h(i,en) = aimag(z3)
      go to 790
!     ********** Solve complex equations **********
780   x = h(i,i + 1)
      y = h(i + 1,i)
      vr = (wr(i) - p) * (wr(i) - p) + wi(i) * wi(i) - q * q
      vi = (wr(i) - p) * 2.0 * q
      if (vr == 0.0 .and. vi == 0.0) vr = machep * norm &
         & * (abs(w) + abs(q) + abs(x) + abs(y) + abs(zz))
      z3 = cmplx(x*r - zz*ra + q*sa,x*s - zz*sa - q*ra) / cmplx(vr,vi)
      h(i,na) = real(z3)
      h(i,en) = aimag(z3)
      if (abs(x) <= abs(zz) + abs(q)) go to 785
      h(i + 1,na) = (-ra - w * h(i,na) + q * h(i,en)) / x
      h(i + 1,en) = (-sa - w * h(i,en) - q * h(i,na)) / x
      go to 790
785   z3 = cmplx(-r - y*h(i,na),-s - y*h(i,en)) / cmplx(zz,q)
      h(i + 1,na) = real(z3)
      h(i + 1,en) = aimag(z3)
790   continue
!     ********** End complex vector **********
800 continue
!     ********** End back substitution.
!                Vectors of isolated roots **********
do 840 i = 1, n
   if (i >= low .and. i <= igh) go to 840
!
   do 820 j = i, n
820   z(i,j) = h(i,j)
!
840 continue
!     ********** Multiply by transformation matrix to give
!                vectors of original full matrix.
!                For j=n step -1 Until low do -- **********
do 880 jj = low, n
   j = n + low - jj
   m = min0(j,igh)
!
   do 880 i = low, igh
      zz = 0.0
!
      do 860 k = low, m
860      zz = zz + z(i,k) * h(k,j)
!
      z(i,j) = zz
880   continue
!
go to 1001
!     ********** Set error -- no convergence to an
!                eigenvalue after 30 iterations **********
1000 ierr = en
1001 return
end subroutine hqr2

