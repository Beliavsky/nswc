subroutine cosqi (n,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*)
integer :: k
real :: dt, fk, pih
data pih /1.57079632679491/
dt = pih/float(n)
fk = 0.
do k=1,n
   fk = fk+1.
   wsave(k) = cos(fk*dt)
end do
call rffti (n,wsave(n+1))
return
end subroutine cosqi

!     ******************************************************************
!
!     SUBROUTINE COSQF(N,X,WSAVE)
!
!     ******************************************************************
!
!     Subroutine COSQF computes the fast Fourier transform of quarter
!     wave data. That is , COSQF computes the coefficients in a cosine
!     series representation with only odd wave numbers. The transform
!     is defined below at output parameter X
!
!     COSQF is the unnormalized inverse of COSQB since a call of COSQF
!     followed by a call of COSQB will multiply the input sequence X
!     BY 4*N.
!
!     The array WSAVE which is used by subroutine COSQF must be
!     initialized by calling subroutine COSQI(N,WSAVE).
!
!
!     Input parameters
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             is most efficient when N is a product of small primes.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15
!             in the program that calls COSQF. The WSAVE array must be
!             initialized by calling subroutine COSQI(N,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of N. This initialization does not have to be
!             repeated so long as N remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     X       FOR I=1,...,N
!
!                  X(I) = X(1) PLUS THE SUM FROM K=2 TO K=N OF
!
!                     2*X(K)*COS((2*I-1)*(K-1)*pi/(2*N))
!
!                  A call of COSQF followed by a call of
!                  COSQB will multiply the sequence X by 4*N.
!                  Therefore COSQB is the unnormalized inverse
!                  OF COSQF.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of COSQF or COSQB.
!
subroutine cosqf (n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
real :: sqrt2, tsqx
data sqrt2 /1.4142135623731/
if (n-2) 102,101,103
101 tsqx = sqrt2*x(2)
x(2) = x(1)-tsqx
x(1) = x(1)+tsqx
102 return
103 call cosqf1 (n,x,wsave,wsave(n+1))
return
end subroutine cosqf

subroutine cosqf1 (n,x,w,xh)
implicit none
integer :: n
real :: w(*)
real, intent(inout) :: x(*), xh(*)
integer :: i, k, kc, modn, np2, ns2
real :: xim1
ns2 = (n+1)/2
np2 = n+2
do k=2,ns2
   kc = np2-k
   xh(k) = x(k)+x(kc)
   xh(kc) = x(k)-x(kc)
end do
modn = mod(n,2)
if (modn .eq. 0) xh(ns2+1) = x(ns2+1)+x(ns2+1)
do k=2,ns2
   kc = np2-k
   x(k) = w(k-1)*xh(kc)+w(kc-1)*xh(k)
   x(kc) = w(k-1)*xh(k)-w(kc-1)*xh(kc)
end do
if (modn .eq. 0) x(ns2+1) = w(ns2)*xh(ns2+1)
call rfftf (n,x,xh)
do i=3,n,2
   xim1 = x(i-1)-x(i)
   x(i) = x(i-1)+x(i)
   x(i-1) = xim1
end do
return
end subroutine cosqf1

!     ******************************************************************
!
!     SUBROUTINE COSQB(N,X,WSAVE)
!
!     ******************************************************************
!
!     Subroutine COSQB computes the fast Fourier transform of quarter
!     wave data. That is , COSQB computes a sequence from its
!     representation in terms of a cosine series with odd wave numbers.
!     The transform is defined below at output parameter X.
!
!     COSQB is the unnormalized inverse of COSQF since a call of COSQB
!     followed by a call of COSQF will multiply the input sequence X
!     BY 4*N.
!
!     The array WSAVE which is used by subroutine COSQB must be
!     initialized by calling subroutine COSQI(N,WSAVE).
!
!
!     Input parameters
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             is most efficient when N is a product of small primes.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY THAT MUST BE DIMENSIONED AT LEAST 3*N+15
!             in the program that calls COSQB. The WSAVE array must be
!             initialized by calling subroutine COSQI(N,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of N. This initialization does not have to be
!             repeated so long as N remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     X       FOR I=1,...,N
!
!                  X(I)= THE SUM FROM K=1 TO K=N OF
!
!                    4*X(K)*COS((2*K-1)*(I-1)*pi/(2*N))
!
!                  A call of COSQB followed by a call of
!                  COSQF will multiply the sequence X by 4*N.
!                  Therefore COSQF is the unnormalized inverse
!                  OF COSQB.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of COSQB or COSQF.
!
subroutine cosqb (n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
real :: tsqrt2, x1
data tsqrt2 /2.82842712474619/
if (n-2) 101,102,103
101 x(1) = 4.*x(1)
return
102 x1 = 4.*(x(1)+x(2))
x(2) = tsqrt2*(x(1)-x(2))
x(1) = x1
return
103 call cosqb1 (n,x,wsave,wsave(n+1))
return
end subroutine cosqb

subroutine cosqb1 (n,x,w,xh)
implicit none
integer :: n
real :: w(*)
real, intent(inout) :: x(*), xh(*)
integer :: i, k, kc, modn, np2, ns2
real :: xim1
ns2 = (n+1)/2
np2 = n+2
do i=3,n,2
   xim1 = x(i-1)+x(i)
   x(i) = x(i)-x(i-1)
   x(i-1) = xim1
end do
x(1) = x(1)+x(1)
modn = mod(n,2)
if (modn .eq. 0) x(n) = x(n)+x(n)
call rfftb (n,x,xh)
do k=2,ns2
   kc = np2-k
   xh(k) = w(k-1)*x(kc)+w(kc-1)*x(k)
   xh(kc) = w(k-1)*x(k)-w(kc-1)*x(kc)
end do
if (modn .eq. 0) x(ns2+1) = w(ns2)*(x(ns2+1)+x(ns2+1))
do k=2,ns2
   kc = np2-k
   x(k) = xh(k)+xh(kc)
   x(kc) = xh(k)-xh(kc)
end do
x(1) = x(1)+x(1)
return
end subroutine cosqb1

!     ******************************************************************
!
!     SUBROUTINE SINQF(N,X,WSAVE)
!
!     ******************************************************************
!
!     Subroutine SINQF computes the fast Fourier transform of quarter
!     wave data. That is , SINQF computes the coefficients in a sine
!     series representation with only odd wave numbers. The transform
!     is defined below at output parameter X.
!
!     SINQB is the unnormalized inverse of SINQF since a call of SINQF
!     followed by a call of SINQB will multiply the input sequence X
!     BY 4*N.
!
!     The array WSAVE which is used by subroutine SINQF must be
!     initialized by calling subroutine SINQI(N,WSAVE).
!
!
!     Input parameters
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             is most efficient when N is a product of small primes.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
!             In the program that calls SINQF. The WSAVE array must be
!             initialized by calling subroutine SINQI(N,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of N. This initialization does not have to be
!             repeated so long as N remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     X       FOR I=1,...,N
!
!                  X(I) = (-1)**(I-1)*X(N)
!
!                     + THE SUM FROM K=1 TO K=N-1 OF
!
!                     2*X(K)*SIN((2*I-1)*K*pi/(2*N))
!
!                  A call of SINQF followed by a call of
!                  SINQB will multiply the sequence X by 4*N.
!                  Therefore SINQB is the unnormalized inverse
!                  OF SINQF.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of SINQF or SINQB.
!
subroutine sinqf (n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
integer :: k, kc, ns2
real :: xhold
if (n .eq. 1) return
ns2 = n/2
do k=1,ns2
   kc = n-k
   xhold = x(k)
   x(k) = x(kc+1)
   x(kc+1) = xhold
end do
call cosqf (n,x,wsave)
do k=2,n,2
   x(k) = -x(k)
end do
return
end subroutine sinqf

!     ******************************************************************
!
!     SUBROUTINE SINQB(N,X,WSAVE)
!
!     ******************************************************************
!
!     Subroutine SINQB computes the fast Fourier transform of quarter
!     wave data. That is , SINQB computes a sequence from its
!     representation in terms of a sine series with odd wave numbers.
!     The transform is defined below at output parameter X.
!
!     SINQF is the unnormalized inverse of SINQB since a call of SINQB
!     followed by a call of SINQF will multiply the input sequence X
!     BY 4*N.
!
!     The array WSAVE which is used by subroutine SINQB must be
!     initialized by calling subroutine SINQI(N,WSAVE).
!
!
!     Input parameters
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             is most efficient when N is a product of small primes.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
!             In the program that calls SINQB. The WSAVE array must be
!             initialized by calling subroutine SINQI(N,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of N. This initialization does not have to be
!             repeated so long as N remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!
!     Output parameters
!
!     X       FOR I=1,...,N
!
!                  X(I)= THE SUM FROM K=1 TO K=N OF
!
!                    4*X(K)*SIN((2K-1)*I*pi/(2*N))
!
!                  A call of SINQB followed by a call of
!                  SINQF will multiply the sequence X by 4*N.
!                  Therefore SINQF is the unnormalized inverse
!                  OF SINQB.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             be destroyed between calls of SINQB or SINQF.
!
subroutine sinqb (n,x,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*), x(*)
integer :: k, kc, ns2
real :: xhold
if (n .gt. 1) go to 101
x(1) = 4.*x(1)
return
101 ns2 = n/2
do k=2,n,2
   x(k) = -x(k)
end do
call cosqb (n,x,wsave)
do k=1,ns2
   kc = n-k
   xhold = x(k)
   x(k) = x(kc+1)
   x(kc+1) = xhold
end do
return
end subroutine sinqb

!     ******************************************************************
!
!     SUBROUTINE RFFTI(N,WSAVE)
!
!       ****************************************************************
!
!     Subroutine RFFTI initializes the array WSAVE which is used in
!     both RFFTF and RFFTB. The prime factorization of N together with
!     a tabulation of the trigonometric functions are computed and
!     stored in WSAVE.
!
!     Input parameter
!
!     N       THE LENGTH OF THE SEQUENCE TO BE TRANSFORMED.
!
!     Output parameter
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
!             The same work array can be used for both RFFTF and RFFTB
!             as long as N remains unchanged. Different WSAVE arrays
!             are required for different values of N. The contents of
!             WSAVE must not be changed between calls of RFFTF or RFFTB.
!
subroutine rffti (n,wsave)
implicit none
integer :: n
real, intent(inout) :: wsave(*)
if (n .eq. 1) return
call rffti1 (n,wsave(n+1),wsave(2*n+1))
return
end subroutine rffti

subroutine rffti1 (n,wa,ifac)
implicit none
integer, intent(in) :: n
integer :: i, ib, ido, ii, ip, ipm, is, j, k1, l1, l2, ld, nf, &
&nfm1, nl, nq, nr, ntry
real :: arg, argh, argld, fi, tpi
real, intent(inout) :: wa(*), ifac(*)
integer :: ntryh(4)
data ntryh(1),ntryh(2),ntryh(3),ntryh(4)/4,2,3,5/
nl = n
nf = 0
j = 0
101 j = j+1
if (j-4) 102,102,103
102 ntry = ntryh(j)
go to 104
103 ntry = ntry+2
104 nq = nl/ntry
nr = nl-ntry*nq
if (nr) 101,105,101
105 nf = nf+1
ifac(nf+2) = ntry
nl = nq
if (ntry .ne. 2) go to 107
if (nf .eq. 1) go to 107
do i=2,nf
   ib = nf-i+2
   ifac(ib+2) = ifac(ib+1)
end do
ifac(3) = 2
107 if (nl .ne. 1) go to 104
ifac(1) = n
ifac(2) = nf
tpi = 6.28318530717959
argh = tpi/float(n)
is = 0
nfm1 = nf-1
l1 = 1
if (nfm1 .eq. 0) return
do k1=1,nfm1
   ip = ifac(k1+2)
   ld = 0
   l2 = l1*ip
   ido = n/l2
   ipm = ip-1
   do j=1,ipm
      ld = ld+l1
      i = is
      argld = float(ld)*argh
      fi = 0.
      do ii=3,ido,2
         i = i+2
         fi = fi+1.
         arg = fi*argld
         wa(i-1) = cos(arg)
         wa(i) = sin(arg)
      end do
      is = is+ido
   end do
   l1 = l2
end do
return
end subroutine rffti1

!     ******************************************************************
!
!     SUBROUTINE RFFTB(N,R,WSAVE)
!
!     ******************************************************************
!
!     Subroutine RFFTB computes the real perodic sequence from its
!     Fourier coefficients (Fourier synthesis). The transform is defined
!     below at output parameter R.
!
!     Input parameters
!
!     N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
!             is most efficient when N is a product of small primes.
!             N may change so long as different work arrays are provided
!
!     R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE
!             to be transformed
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
!             In the program that calls RFFTB. The WSAVE array must be
!             initialized by calling subroutine RFFTI(N,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of N. This initialization does not have to be
!             repeated so long as N remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!             The same WSAVE array can be used by RFFTF and RFFTB.
!
!
!     Output parameters
!
!     R       FOR N EVEN AND FOR I = 1,...,N
!
!                  R(I) = R(1)+(-1)**(I-1)*R(N)
!
!                       PLUS THE SUM FROM K=2 TO K=N/2 OF
!
!                        2.*R(2*K-2)*COS((K-1)*(I-1)*2*pi/N)
!
!                       -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*pi/N)
!
!             FOR N ODD AND FOR I = 1,...,N
!
!                  R(I) = R(1) PLUS THE SUM FROM K=2 TO K=(N+1)/2 OF
!
!                       2.*R(2*K-2)*COS((K-1)*(I-1)*2*pi/N)
!
!                      -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*pi/N)
!
!      *****  NOTE
!                  this transform is unnormalized since a call of RFFTF
!                  followed by a call of RFFTB will multiply the input
!                  sequence by N.
!
!     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
!             calls of RFFTB or RFFTF.
!
!
subroutine rfftb (n,r,wsave)
implicit none
integer :: n
real, intent(inout) :: r(*), wsave(*)
if (n .eq. 1) return
call rfftb1 (n,r,wsave,wsave(n+1),wsave(2*n+1))
return
end subroutine rfftb

subroutine rfftb1 (n,c,ch,wa,ifac)
implicit none
integer, intent(in) :: n
integer :: i, idl1, ido, ip, iw, ix2, ix3, ix4, k1, l1, l2, na, nf
real, intent(inout) :: c(*), ch(*)
real :: wa(*)
real, intent(in) :: ifac(*)
nf = ifac(2)
na = 0
l1 = 1
iw = 1
do k1=1,nf
   ip = ifac(k1+2)
   l2 = ip*l1
   ido = n/l2
   idl1 = ido*l1
   if (ip .ne. 4) go to 103
   ix2 = iw+ido
   ix3 = ix2+ido
   if (na .ne. 0) go to 101
   call radb4 (ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3))
   go to 102
101 call radb4 (ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3))
102 na = 1-na
   go to 115
103 if (ip .ne. 2) go to 106
   if (na .ne. 0) go to 104
   call radb2 (ido,l1,c,ch,wa(iw))
   go to 105
104 call radb2 (ido,l1,ch,c,wa(iw))
105 na = 1-na
   go to 115
106 if (ip .ne. 3) go to 109
   ix2 = iw+ido
   if (na .ne. 0) go to 107
   call radb3 (ido,l1,c,ch,wa(iw),wa(ix2))
   go to 108
107 call radb3 (ido,l1,ch,c,wa(iw),wa(ix2))
108 na = 1-na
   go to 115
109 if (ip .ne. 5) go to 112
   ix2 = iw+ido
   ix3 = ix2+ido
   ix4 = ix3+ido
   if (na .ne. 0) go to 110
   call radb5 (ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3),wa(ix4))
   go to 111
110 call radb5 (ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3),wa(ix4))
111 na = 1-na
   go to 115
112 if (na .ne. 0) go to 113
   call radbg (ido,ip,l1,idl1,c,c,c,ch,ch,wa(iw))
   go to 114
113 call radbg (ido,ip,l1,idl1,ch,ch,ch,c,c,wa(iw))
114 if (ido .eq. 1) na = 1-na
115 l1 = l2
   iw = iw+(ip-1)*ido
end do
if (na .eq. 0) return
do i=1,n
   c(i) = ch(i)
end do
return
end subroutine rfftb1

subroutine radb2 (ido,l1,cc,ch,wa1)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,2,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*)
integer :: i, ic, idp2, k
real :: ti2, tr2
do k=1,l1
   ch(1,k,1) = cc(1,1,k)+cc(ido,2,k)
   ch(1,k,2) = cc(1,1,k)-cc(ido,2,k)
end do
if (ido-2) 107,105,102
102 idp2 = ido+2
if((ido-1)/2.lt.l1) go to 108
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      ch(i-1,k,1) = cc(i-1,1,k)+cc(ic-1,2,k)
      tr2 = cc(i-1,1,k)-cc(ic-1,2,k)
      ch(i,k,1) = cc(i,1,k)-cc(ic,2,k)
      ti2 = cc(i,1,k)+cc(ic,2,k)
      ch(i-1,k,2) = wa1(i-2)*tr2-wa1(i-1)*ti2
      ch(i,k,2) = wa1(i-2)*ti2+wa1(i-1)*tr2
   end do
end do
go to 111
108 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      ch(i-1,k,1) = cc(i-1,1,k)+cc(ic-1,2,k)
      tr2 = cc(i-1,1,k)-cc(ic-1,2,k)
      ch(i,k,1) = cc(i,1,k)-cc(ic,2,k)
      ti2 = cc(i,1,k)+cc(ic,2,k)
      ch(i-1,k,2) = wa1(i-2)*tr2-wa1(i-1)*ti2
      ch(i,k,2) = wa1(i-2)*ti2+wa1(i-1)*tr2
   end do
end do
111 if (mod(ido,2) .eq. 1) return
105 do k=1,l1
   ch(ido,k,1) = cc(ido,1,k)+cc(ido,1,k)
   ch(ido,k,2) = -(cc(1,2,k)+cc(1,2,k))
end do
107 return
end subroutine radb2

subroutine radb3 (ido,l1,cc,ch,wa1,wa2)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,3,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*), wa2(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, cr2, cr3, di2, di3, dr2, dr3, taui, taur, ti2, &
&tr2
data taur,taui /-.5,.866025403784439/
do k=1,l1
   tr2 = cc(ido,2,k)+cc(ido,2,k)
   cr2 = cc(1,1,k)+taur*tr2
   ch(1,k,1) = cc(1,1,k)+tr2
   ci3 = taui*(cc(1,3,k)+cc(1,3,k))
   ch(1,k,2) = cr2-ci3
   ch(1,k,3) = cr2+ci3
end do
if (ido .eq. 1) return
idp2 = ido+2
if((ido-1)/2.lt.l1) go to 104
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      tr2 = cc(i-1,3,k)+cc(ic-1,2,k)
      cr2 = cc(i-1,1,k)+taur*tr2
      ch(i-1,k,1) = cc(i-1,1,k)+tr2
      ti2 = cc(i,3,k)-cc(ic,2,k)
      ci2 = cc(i,1,k)+taur*ti2
      ch(i,k,1) = cc(i,1,k)+ti2
      cr3 = taui*(cc(i-1,3,k)-cc(ic-1,2,k))
      ci3 = taui*(cc(i,3,k)+cc(ic,2,k))
      dr2 = cr2-ci3
      dr3 = cr2+ci3
      di2 = ci2+cr3
      di3 = ci2-cr3
      ch(i-1,k,2) = wa1(i-2)*dr2-wa1(i-1)*di2
      ch(i,k,2) = wa1(i-2)*di2+wa1(i-1)*dr2
      ch(i-1,k,3) = wa2(i-2)*dr3-wa2(i-1)*di3
      ch(i,k,3) = wa2(i-2)*di3+wa2(i-1)*dr3
   end do
end do
return
104 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      tr2 = cc(i-1,3,k)+cc(ic-1,2,k)
      cr2 = cc(i-1,1,k)+taur*tr2
      ch(i-1,k,1) = cc(i-1,1,k)+tr2
      ti2 = cc(i,3,k)-cc(ic,2,k)
      ci2 = cc(i,1,k)+taur*ti2
      ch(i,k,1) = cc(i,1,k)+ti2
      cr3 = taui*(cc(i-1,3,k)-cc(ic-1,2,k))
      ci3 = taui*(cc(i,3,k)+cc(ic,2,k))
      dr2 = cr2-ci3
      dr3 = cr2+ci3
      di2 = ci2+cr3
      di3 = ci2-cr3
      ch(i-1,k,2) = wa1(i-2)*dr2-wa1(i-1)*di2
      ch(i,k,2) = wa1(i-2)*di2+wa1(i-1)*dr2
      ch(i-1,k,3) = wa2(i-2)*dr3-wa2(i-1)*di3
      ch(i,k,3) = wa2(i-2)*di3+wa2(i-1)*dr3
   end do
end do
return
end subroutine radb3

subroutine radb4 (ido,l1,cc,ch,wa1,wa2,wa3)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,4,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*), wa2(*), wa3(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, ci4, cr2, cr3, cr4, sqrt2, ti1, ti2, ti3, ti4, &
&tr1, tr2, tr3, tr4
data sqrt2 /1.414213562373095/
do k=1,l1
   tr1 = cc(1,1,k)-cc(ido,4,k)
   tr2 = cc(1,1,k)+cc(ido,4,k)
   tr3 = cc(ido,2,k)+cc(ido,2,k)
   tr4 = cc(1,3,k)+cc(1,3,k)
   ch(1,k,1) = tr2+tr3
   ch(1,k,2) = tr1-tr4
   ch(1,k,3) = tr2-tr3
   ch(1,k,4) = tr1+tr4
end do
if (ido-2) 107,105,102
102 idp2 = ido+2
if((ido-1)/2.lt.l1) go to 108
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      ti1 = cc(i,1,k)+cc(ic,4,k)
      ti2 = cc(i,1,k)-cc(ic,4,k)
      ti3 = cc(i,3,k)-cc(ic,2,k)
      tr4 = cc(i,3,k)+cc(ic,2,k)
      tr1 = cc(i-1,1,k)-cc(ic-1,4,k)
      tr2 = cc(i-1,1,k)+cc(ic-1,4,k)
      ti4 = cc(i-1,3,k)-cc(ic-1,2,k)
      tr3 = cc(i-1,3,k)+cc(ic-1,2,k)
      ch(i-1,k,1) = tr2+tr3
      cr3 = tr2-tr3
      ch(i,k,1) = ti2+ti3
      ci3 = ti2-ti3
      cr2 = tr1-tr4
      cr4 = tr1+tr4
      ci2 = ti1+ti4
      ci4 = ti1-ti4
      ch(i-1,k,2) = wa1(i-2)*cr2-wa1(i-1)*ci2
      ch(i,k,2) = wa1(i-2)*ci2+wa1(i-1)*cr2
      ch(i-1,k,3) = wa2(i-2)*cr3-wa2(i-1)*ci3
      ch(i,k,3) = wa2(i-2)*ci3+wa2(i-1)*cr3
      ch(i-1,k,4) = wa3(i-2)*cr4-wa3(i-1)*ci4
      ch(i,k,4) = wa3(i-2)*ci4+wa3(i-1)*cr4
   end do
end do
go to 111
108 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      ti1 = cc(i,1,k)+cc(ic,4,k)
      ti2 = cc(i,1,k)-cc(ic,4,k)
      ti3 = cc(i,3,k)-cc(ic,2,k)
      tr4 = cc(i,3,k)+cc(ic,2,k)
      tr1 = cc(i-1,1,k)-cc(ic-1,4,k)
      tr2 = cc(i-1,1,k)+cc(ic-1,4,k)
      ti4 = cc(i-1,3,k)-cc(ic-1,2,k)
      tr3 = cc(i-1,3,k)+cc(ic-1,2,k)
      ch(i-1,k,1) = tr2+tr3
      cr3 = tr2-tr3
      ch(i,k,1) = ti2+ti3
      ci3 = ti2-ti3
      cr2 = tr1-tr4
      cr4 = tr1+tr4
      ci2 = ti1+ti4
      ci4 = ti1-ti4
      ch(i-1,k,2) = wa1(i-2)*cr2-wa1(i-1)*ci2
      ch(i,k,2) = wa1(i-2)*ci2+wa1(i-1)*cr2
      ch(i-1,k,3) = wa2(i-2)*cr3-wa2(i-1)*ci3
      ch(i,k,3) = wa2(i-2)*ci3+wa2(i-1)*cr3
      ch(i-1,k,4) = wa3(i-2)*cr4-wa3(i-1)*ci4
      ch(i,k,4) = wa3(i-2)*ci4+wa3(i-1)*cr4
   end do
end do
111 if (mod(ido,2) .eq. 1) return
105 do k=1,l1
   ti1 = cc(1,2,k)+cc(1,4,k)
   ti2 = cc(1,4,k)-cc(1,2,k)
   tr1 = cc(ido,1,k)-cc(ido,3,k)
   tr2 = cc(ido,1,k)+cc(ido,3,k)
   ch(ido,k,1) = tr2+tr2
   ch(ido,k,2) = sqrt2*(tr1-ti1)
   ch(ido,k,3) = ti2+ti2
   ch(ido,k,4) = -sqrt2*(tr1+ti1)
end do
107 return
end subroutine radb4

subroutine radb5 (ido,l1,cc,ch,wa1,wa2,wa3,wa4)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,5,l1)
real, intent(inout) :: ch(ido,l1,*)
real :: wa1(*), wa2(*), wa3(*), wa4(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, ci4, ci5, cr2, cr3, cr4, cr5, di2, di3, di4, &
&di5, dr2, dr3, dr4, dr5, ti11, ti12, ti2, ti3, ti4, ti5, tr11, &
&tr12, tr2, tr3, tr4, tr5
data tr11,ti11,tr12,ti12 /.309016994374947,.951056516295154, &
&-.809016994374947,.587785252292473/
do k=1,l1
   ti5 = cc(1,3,k)+cc(1,3,k)
   ti4 = cc(1,5,k)+cc(1,5,k)
   tr2 = cc(ido,2,k)+cc(ido,2,k)
   tr3 = cc(ido,4,k)+cc(ido,4,k)
   ch(1,k,1) = cc(1,1,k)+tr2+tr3
   cr2 = cc(1,1,k)+tr11*tr2+tr12*tr3
   cr3 = cc(1,1,k)+tr12*tr2+tr11*tr3
   ci5 = ti11*ti5+ti12*ti4
   ci4 = ti12*ti5-ti11*ti4
   ch(1,k,2) = cr2-ci5
   ch(1,k,3) = cr3-ci4
   ch(1,k,4) = cr3+ci4
   ch(1,k,5) = cr2+ci5
end do
if (ido .eq. 1) return
idp2 = ido+2
if((ido-1)/2.lt.l1) go to 104
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      ti5 = cc(i,3,k)+cc(ic,2,k)
      ti2 = cc(i,3,k)-cc(ic,2,k)
      ti4 = cc(i,5,k)+cc(ic,4,k)
      ti3 = cc(i,5,k)-cc(ic,4,k)
      tr5 = cc(i-1,3,k)-cc(ic-1,2,k)
      tr2 = cc(i-1,3,k)+cc(ic-1,2,k)
      tr4 = cc(i-1,5,k)-cc(ic-1,4,k)
      tr3 = cc(i-1,5,k)+cc(ic-1,4,k)
      ch(i-1,k,1) = cc(i-1,1,k)+tr2+tr3
      ch(i,k,1) = cc(i,1,k)+ti2+ti3
      cr2 = cc(i-1,1,k)+tr11*tr2+tr12*tr3
      ci2 = cc(i,1,k)+tr11*ti2+tr12*ti3
      cr3 = cc(i-1,1,k)+tr12*tr2+tr11*tr3
      ci3 = cc(i,1,k)+tr12*ti2+tr11*ti3
      cr5 = ti11*tr5+ti12*tr4
      ci5 = ti11*ti5+ti12*ti4
      cr4 = ti12*tr5-ti11*tr4
      ci4 = ti12*ti5-ti11*ti4
      dr3 = cr3-ci4
      dr4 = cr3+ci4
      di3 = ci3+cr4
      di4 = ci3-cr4
      dr5 = cr2+ci5
      dr2 = cr2-ci5
      di5 = ci2-cr5
      di2 = ci2+cr5
      ch(i-1,k,2) = wa1(i-2)*dr2-wa1(i-1)*di2
      ch(i,k,2) = wa1(i-2)*di2+wa1(i-1)*dr2
      ch(i-1,k,3) = wa2(i-2)*dr3-wa2(i-1)*di3
      ch(i,k,3) = wa2(i-2)*di3+wa2(i-1)*dr3
      ch(i-1,k,4) = wa3(i-2)*dr4-wa3(i-1)*di4
      ch(i,k,4) = wa3(i-2)*di4+wa3(i-1)*dr4
      ch(i-1,k,5) = wa4(i-2)*dr5-wa4(i-1)*di5
      ch(i,k,5) = wa4(i-2)*di5+wa4(i-1)*dr5
   end do
end do
return
104 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      ti5 = cc(i,3,k)+cc(ic,2,k)
      ti2 = cc(i,3,k)-cc(ic,2,k)
      ti4 = cc(i,5,k)+cc(ic,4,k)
      ti3 = cc(i,5,k)-cc(ic,4,k)
      tr5 = cc(i-1,3,k)-cc(ic-1,2,k)
      tr2 = cc(i-1,3,k)+cc(ic-1,2,k)
      tr4 = cc(i-1,5,k)-cc(ic-1,4,k)
      tr3 = cc(i-1,5,k)+cc(ic-1,4,k)
      ch(i-1,k,1) = cc(i-1,1,k)+tr2+tr3
      ch(i,k,1) = cc(i,1,k)+ti2+ti3
      cr2 = cc(i-1,1,k)+tr11*tr2+tr12*tr3
      ci2 = cc(i,1,k)+tr11*ti2+tr12*ti3
      cr3 = cc(i-1,1,k)+tr12*tr2+tr11*tr3
      ci3 = cc(i,1,k)+tr12*ti2+tr11*ti3
      cr5 = ti11*tr5+ti12*tr4
      ci5 = ti11*ti5+ti12*ti4
      cr4 = ti12*tr5-ti11*tr4
      ci4 = ti12*ti5-ti11*ti4
      dr3 = cr3-ci4
      dr4 = cr3+ci4
      di3 = ci3+cr4
      di4 = ci3-cr4
      dr5 = cr2+ci5
      dr2 = cr2-ci5
      di5 = ci2-cr5
      di2 = ci2+cr5
      ch(i-1,k,2) = wa1(i-2)*dr2-wa1(i-1)*di2
      ch(i,k,2) = wa1(i-2)*di2+wa1(i-1)*dr2
      ch(i-1,k,3) = wa2(i-2)*dr3-wa2(i-1)*di3
      ch(i,k,3) = wa2(i-2)*di3+wa2(i-1)*dr3
      ch(i-1,k,4) = wa3(i-2)*dr4-wa3(i-1)*di4
      ch(i,k,4) = wa3(i-2)*di4+wa3(i-1)*dr4
      ch(i-1,k,5) = wa4(i-2)*dr5-wa4(i-1)*di5
      ch(i,k,5) = wa4(i-2)*di5+wa4(i-1)*dr5
   end do
end do
return
end subroutine radb5

subroutine radbg (ido,ip,l1,idl1,cc,c1,c2,ch,ch2,wa)
implicit none
integer, intent(in) :: idl1, ido, ip, l1
real, intent(inout) :: c1(ido,l1,ip), c2(idl1,ip)
real :: cc(ido,ip,l1)
real, intent(inout) :: ch(ido,l1,ip), ch2(idl1,ip)
real :: wa(*)
integer :: i, ic, idij, idp2, ik, ipp2, ipph, is, j, j2, jc, k, l, &
&lc, nbd
real :: ai1, ai2, ar1, ar1h, ar2, ar2h, arg, dc2, dcp, ds2, dsp, &
&tpi
data tpi/6.28318530717959/
arg = tpi/float(ip)
dcp = cos(arg)
dsp = sin(arg)
idp2 = ido+2
nbd = (ido-1)/2
ipp2 = ip+2
ipph = (ip+1)/2
if (ido .lt. l1) go to 103
do k=1,l1
   do i=1,ido
      ch(i,k,1) = cc(i,1,k)
   end do
end do
go to 106
103 do i=1,ido
   do k=1,l1
      ch(i,k,1) = cc(i,1,k)
   end do
end do
106 do j=2,ipph
   jc = ipp2-j
   j2 = j+j
   do k=1,l1
      ch(1,k,j) = cc(ido,j2-2,k)+cc(ido,j2-2,k)
      ch(1,k,jc) = cc(1,j2-1,k)+cc(1,j2-1,k)
   end do
end do
if (ido .eq. 1) go to 116
if (nbd .lt. l1) go to 112
do j=2,ipph
   jc = ipp2-j
   do k=1,l1
      do i=3,ido,2
         ic = idp2-i
         ch(i-1,k,j) = cc(i-1,2*j-1,k)+cc(ic-1,2*j-2,k)
         ch(i-1,k,jc) = cc(i-1,2*j-1,k)-cc(ic-1,2*j-2,k)
         ch(i,k,j) = cc(i,2*j-1,k)-cc(ic,2*j-2,k)
         ch(i,k,jc) = cc(i,2*j-1,k)+cc(ic,2*j-2,k)
      end do
   end do
end do
go to 116
112 do j=2,ipph
   jc = ipp2-j
   do i=3,ido,2
      ic = idp2-i
      do k=1,l1
         ch(i-1,k,j) = cc(i-1,2*j-1,k)+cc(ic-1,2*j-2,k)
         ch(i-1,k,jc) = cc(i-1,2*j-1,k)-cc(ic-1,2*j-2,k)
         ch(i,k,j) = cc(i,2*j-1,k)-cc(ic,2*j-2,k)
         ch(i,k,jc) = cc(i,2*j-1,k)+cc(ic,2*j-2,k)
      end do
   end do
end do
116 ar1 = 1.
ai1 = 0.
do l=2,ipph
   lc = ipp2-l
   ar1h = dcp*ar1-dsp*ai1
   ai1 = dcp*ai1+dsp*ar1
   ar1 = ar1h
   do ik=1,idl1
      c2(ik,l) = ch2(ik,1)+ar1*ch2(ik,2)
      c2(ik,lc) = ai1*ch2(ik,ip)
   end do
   dc2 = ar1
   ds2 = ai1
   ar2 = ar1
   ai2 = ai1
   do j=3,ipph
      jc = ipp2-j
      ar2h = dc2*ar2-ds2*ai2
      ai2 = dc2*ai2+ds2*ar2
      ar2 = ar2h
      do ik=1,idl1
         c2(ik,l) = c2(ik,l)+ar2*ch2(ik,j)
         c2(ik,lc) = c2(ik,lc)+ai2*ch2(ik,jc)
      end do
   end do
end do
do j=2,ipph
   do ik=1,idl1
      ch2(ik,1) = ch2(ik,1)+ch2(ik,j)
   end do
end do
do j=2,ipph
   jc = ipp2-j
   do k=1,l1
      ch(1,k,j) = c1(1,k,j)-c1(1,k,jc)
      ch(1,k,jc) = c1(1,k,j)+c1(1,k,jc)
   end do
end do
if (ido .eq. 1) go to 132
if (nbd .lt. l1) go to 128
do j=2,ipph
   jc = ipp2-j
   do k=1,l1
      do i=3,ido,2
         ch(i-1,k,j) = c1(i-1,k,j)-c1(i,k,jc)
         ch(i-1,k,jc) = c1(i-1,k,j)+c1(i,k,jc)
         ch(i,k,j) = c1(i,k,j)+c1(i-1,k,jc)
         ch(i,k,jc) = c1(i,k,j)-c1(i-1,k,jc)
      end do
   end do
end do
go to 132
128 do j=2,ipph
   jc = ipp2-j
   do i=3,ido,2
      do k=1,l1
         ch(i-1,k,j) = c1(i-1,k,j)-c1(i,k,jc)
         ch(i-1,k,jc) = c1(i-1,k,j)+c1(i,k,jc)
         ch(i,k,j) = c1(i,k,j)+c1(i-1,k,jc)
         ch(i,k,jc) = c1(i,k,j)-c1(i-1,k,jc)
      end do
   end do
end do
132 continue
if (ido .eq. 1) return
do ik=1,idl1
   c2(ik,1) = ch2(ik,1)
end do
do j=2,ip
   do k=1,l1
      c1(1,k,j) = ch(1,k,j)
   end do
end do
if (nbd .gt. l1) go to 139
is = -ido
do j=2,ip
   is = is+ido
   idij = is
   do i=3,ido,2
      idij = idij+2
      do k=1,l1
         c1(i-1,k,j) = wa(idij-1)*ch(i-1,k,j)-wa(idij)*ch(i,k,j)
         c1(i,k,j) = wa(idij-1)*ch(i,k,j)+wa(idij)*ch(i-1,k,j)
      end do
   end do
end do
go to 143
139 is = -ido
do j=2,ip
   is = is+ido
   do k=1,l1
      idij = is
      do i=3,ido,2
         idij = idij+2
         c1(i-1,k,j) = wa(idij-1)*ch(i-1,k,j)-wa(idij)*ch(i,k,j)
         c1(i,k,j) = wa(idij-1)*ch(i,k,j)+wa(idij)*ch(i-1,k,j)
      end do
   end do
end do
143 return
end subroutine radbg

!     ******************************************************************
!
!     SUBROUTINE RFFTF(N,R,WSAVE)
!
!     ******************************************************************
!
!     Subroutine RFFTF computes the Fourier coefficients of a real
!     perodic sequence (Fourier analysis). The transform is defined
!     below at output parameter R.
!
!     Input parameters
!
!     N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
!             is most efficient when N is a product of small primes.
!             N may change so long as different work arrays are provided
!
!     R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE
!             to be transformed
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
!             In the program that calls RFFTF. The WSAVE array must be
!             initialized by calling subroutine RFFTI(N,WSAVE) and A
!             different WSAVE array must be used for each different
!             value of N. This initialization does not have to be
!             repeated so long as N remains unchanged thus subsequent
!             transforms can be obtained faster than the first.
!             The same WSAVE array can be used by RFFTF and RFFTB.
!
!
!     Output parameters
!
!     R       R(1) = THE SUM FROM I=1 TO I=N OF R(I)
!
!             IF N IS EVEN SET L =N/2   , IF N IS ODD SET L = (N+1)/2
!
!               THEN FOR K = 2,...,L
!
!                  R(2*K-2) = THE SUM FROM I = 1 TO I = N OF
!
!                       R(I)*COS((K-1)*(I-1)*2*pi/N)
!
!                  R(2*K-1) = THE SUM FROM I = 1 TO I = N OF
!
!                      -R(I)*SIN((K-1)*(I-1)*2*pi/N)
!
!             If N is even
!
!                  R(N) = THE SUM FROM I = 1 TO I = N OF
!
!                       (-1)**(I-1)*R(I)
!
!      *****  NOTE
!                  this transform is unnormalized since a call of RFFTF
!                  followed by a call of RFFTB will multiply the input
!                  sequence by N.
!
!     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
!             calls of RFFTF or RFFTB.
!
!
subroutine rfftf (n,r,wsave)
implicit none
integer :: n
real, intent(inout) :: r(*), wsave(*)
if (n .eq. 1) return
call rfftf1 (n,r,wsave,wsave(n+1),wsave(2*n+1))
return
end subroutine rfftf

subroutine rfftf1 (n,c,ch,wa,ifac)
implicit none
integer, intent(in) :: n
integer :: i, idl1, ido, ip, iw, ix2, ix3, ix4, k1, kh, l1, l2, &
&na, nf
real, intent(inout) :: c(*), ch(*)
real :: wa(*)
real, intent(in) :: ifac(*)
nf = ifac(2)
na = 1
l2 = n
iw = n
do k1=1,nf
   kh = nf-k1
   ip = ifac(kh+3)
   l1 = l2/ip
   ido = n/l2
   idl1 = ido*l1
   iw = iw-(ip-1)*ido
   na = 1-na
   if (ip .ne. 4) go to 102
   ix2 = iw+ido
   ix3 = ix2+ido
   if (na .ne. 0) go to 101
   call radf4 (ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3))
   go to 110
101 call radf4 (ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3))
   go to 110
102 if (ip .ne. 2) go to 104
   if (na .ne. 0) go to 103
   call radf2 (ido,l1,c,ch,wa(iw))
   go to 110
103 call radf2 (ido,l1,ch,c,wa(iw))
   go to 110
104 if (ip .ne. 3) go to 106
   ix2 = iw+ido
   if (na .ne. 0) go to 105
   call radf3 (ido,l1,c,ch,wa(iw),wa(ix2))
   go to 110
105 call radf3 (ido,l1,ch,c,wa(iw),wa(ix2))
   go to 110
106 if (ip .ne. 5) go to 108
   ix2 = iw+ido
   ix3 = ix2+ido
   ix4 = ix3+ido
   if (na .ne. 0) go to 107
   call radf5 (ido,l1,c,ch,wa(iw),wa(ix2),wa(ix3),wa(ix4))
   go to 110
107 call radf5 (ido,l1,ch,c,wa(iw),wa(ix2),wa(ix3),wa(ix4))
   go to 110
108 if (ido .eq. 1) na = 1-na
   if (na .ne. 0) go to 109
   call radfg (ido,ip,l1,idl1,c,c,c,ch,ch,wa(iw))
   na = 1
   go to 110
109 call radfg (ido,ip,l1,idl1,ch,ch,ch,c,c,wa(iw))
   na = 0
110 l2 = l1
end do
if (na .eq. 1) return
do i=1,n
   c(i) = ch(i)
end do
return
end subroutine rfftf1

subroutine radf2 (ido,l1,cc,ch,wa1)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,2,l1)
real :: wa1(*)
integer :: i, ic, idp2, k
real :: ti2, tr2
do k=1,l1
   ch(1,1,k) = cc(1,k,1)+cc(1,k,2)
   ch(ido,2,k) = cc(1,k,1)-cc(1,k,2)
end do
if (ido-2) 107,105,102
102 idp2 = ido+2
if((ido-1)/2.lt.l1) go to 108
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      tr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      ti2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      ch(i,1,k) = cc(i,k,1)+ti2
      ch(ic,2,k) = ti2-cc(i,k,1)
      ch(i-1,1,k) = cc(i-1,k,1)+tr2
      ch(ic-1,2,k) = cc(i-1,k,1)-tr2
   end do
end do
go to 111
108 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      tr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      ti2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      ch(i,1,k) = cc(i,k,1)+ti2
      ch(ic,2,k) = ti2-cc(i,k,1)
      ch(i-1,1,k) = cc(i-1,k,1)+tr2
      ch(ic-1,2,k) = cc(i-1,k,1)-tr2
   end do
end do
111 if (mod(ido,2) .eq. 1) return
105 do k=1,l1
   ch(1,2,k) = -cc(ido,k,2)
   ch(ido,1,k) = cc(ido,k,1)
end do
107 return
end subroutine radf2

subroutine radf3 (ido,l1,cc,ch,wa1,wa2)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,3,l1)
real :: wa1(*), wa2(*)
integer :: i, ic, idp2, k
real :: ci2, cr2, di2, di3, dr2, dr3, taui, taur, ti2, ti3, tr2, &
&tr3
data taur,taui /-.5,.866025403784439/
do k=1,l1
   cr2 = cc(1,k,2)+cc(1,k,3)
   ch(1,1,k) = cc(1,k,1)+cr2
   ch(1,3,k) = taui*(cc(1,k,3)-cc(1,k,2))
   ch(ido,2,k) = cc(1,k,1)+taur*cr2
end do
if (ido .eq. 1) return
idp2 = ido+2
if((ido-1)/2.lt.l1) go to 104
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      dr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      di2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      dr3 = wa2(i-2)*cc(i-1,k,3)+wa2(i-1)*cc(i,k,3)
      di3 = wa2(i-2)*cc(i,k,3)-wa2(i-1)*cc(i-1,k,3)
      cr2 = dr2+dr3
      ci2 = di2+di3
      ch(i-1,1,k) = cc(i-1,k,1)+cr2
      ch(i,1,k) = cc(i,k,1)+ci2
      tr2 = cc(i-1,k,1)+taur*cr2
      ti2 = cc(i,k,1)+taur*ci2
      tr3 = taui*(di2-di3)
      ti3 = taui*(dr3-dr2)
      ch(i-1,3,k) = tr2+tr3
      ch(ic-1,2,k) = tr2-tr3
      ch(i,3,k) = ti2+ti3
      ch(ic,2,k) = ti3-ti2
   end do
end do
return
104 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      dr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      di2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      dr3 = wa2(i-2)*cc(i-1,k,3)+wa2(i-1)*cc(i,k,3)
      di3 = wa2(i-2)*cc(i,k,3)-wa2(i-1)*cc(i-1,k,3)
      cr2 = dr2+dr3
      ci2 = di2+di3
      ch(i-1,1,k) = cc(i-1,k,1)+cr2
      ch(i,1,k) = cc(i,k,1)+ci2
      tr2 = cc(i-1,k,1)+taur*cr2
      ti2 = cc(i,k,1)+taur*ci2
      tr3 = taui*(di2-di3)
      ti3 = taui*(dr3-dr2)
      ch(i-1,3,k) = tr2+tr3
      ch(ic-1,2,k) = tr2-tr3
      ch(i,3,k) = ti2+ti3
      ch(ic,2,k) = ti3-ti2
   end do
end do
return
end subroutine radf3

subroutine radf4 (ido,l1,cc,ch,wa1,wa2,wa3)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,4,l1)
real :: wa1(*), wa2(*), wa3(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, ci4, cr2, cr3, cr4, hsqt2, ti1, ti2, ti3, ti4, &
&tr1, tr2, tr3, tr4
data hsqt2 /.7071067811865475/
do k=1,l1
   tr1 = cc(1,k,2)+cc(1,k,4)
   tr2 = cc(1,k,1)+cc(1,k,3)
   ch(1,1,k) = tr1+tr2
   ch(ido,4,k) = tr2-tr1
   ch(ido,2,k) = cc(1,k,1)-cc(1,k,3)
   ch(1,3,k) = cc(1,k,4)-cc(1,k,2)
end do
if (ido-2) 107,105,102
102 idp2 = ido+2
if((ido-1)/2.lt.l1) go to 111
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      cr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      ci2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      cr3 = wa2(i-2)*cc(i-1,k,3)+wa2(i-1)*cc(i,k,3)
      ci3 = wa2(i-2)*cc(i,k,3)-wa2(i-1)*cc(i-1,k,3)
      cr4 = wa3(i-2)*cc(i-1,k,4)+wa3(i-1)*cc(i,k,4)
      ci4 = wa3(i-2)*cc(i,k,4)-wa3(i-1)*cc(i-1,k,4)
      tr1 = cr2+cr4
      tr4 = cr4-cr2
      ti1 = ci2+ci4
      ti4 = ci2-ci4
      ti2 = cc(i,k,1)+ci3
      ti3 = cc(i,k,1)-ci3
      tr2 = cc(i-1,k,1)+cr3
      tr3 = cc(i-1,k,1)-cr3
      ch(i-1,1,k) = tr1+tr2
      ch(ic-1,4,k) = tr2-tr1
      ch(i,1,k) = ti1+ti2
      ch(ic,4,k) = ti1-ti2
      ch(i-1,3,k) = ti4+tr3
      ch(ic-1,2,k) = tr3-ti4
      ch(i,3,k) = tr4+ti3
      ch(ic,2,k) = tr4-ti3
   end do
end do
go to 110
111 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      cr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      ci2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      cr3 = wa2(i-2)*cc(i-1,k,3)+wa2(i-1)*cc(i,k,3)
      ci3 = wa2(i-2)*cc(i,k,3)-wa2(i-1)*cc(i-1,k,3)
      cr4 = wa3(i-2)*cc(i-1,k,4)+wa3(i-1)*cc(i,k,4)
      ci4 = wa3(i-2)*cc(i,k,4)-wa3(i-1)*cc(i-1,k,4)
      tr1 = cr2+cr4
      tr4 = cr4-cr2
      ti1 = ci2+ci4
      ti4 = ci2-ci4
      ti2 = cc(i,k,1)+ci3
      ti3 = cc(i,k,1)-ci3
      tr2 = cc(i-1,k,1)+cr3
      tr3 = cc(i-1,k,1)-cr3
      ch(i-1,1,k) = tr1+tr2
      ch(ic-1,4,k) = tr2-tr1
      ch(i,1,k) = ti1+ti2
      ch(ic,4,k) = ti1-ti2
      ch(i-1,3,k) = ti4+tr3
      ch(ic-1,2,k) = tr3-ti4
      ch(i,3,k) = tr4+ti3
      ch(ic,2,k) = tr4-ti3
   end do
end do
110 if (mod(ido,2) .eq. 1) return
105 do k=1,l1
   ti1 = -hsqt2*(cc(ido,k,2)+cc(ido,k,4))
   tr1 = hsqt2*(cc(ido,k,2)-cc(ido,k,4))
   ch(ido,1,k) = tr1+cc(ido,k,1)
   ch(ido,3,k) = cc(ido,k,1)-tr1
   ch(1,2,k) = ti1-cc(ido,k,3)
   ch(1,4,k) = ti1+cc(ido,k,3)
end do
107 return
end subroutine radf4

subroutine radf5 (ido,l1,cc,ch,wa1,wa2,wa3,wa4)
implicit none
integer, intent(in) :: ido, l1
real :: cc(ido,l1,*)
real, intent(inout) :: ch(ido,5,l1)
real :: wa1(*), wa2(*), wa3(*), wa4(*)
integer :: i, ic, idp2, k
real :: ci2, ci3, ci4, ci5, cr2, cr3, cr4, cr5, di2, di3, di4, &
&di5, dr2, dr3, dr4, dr5, ti11, ti12, ti2, ti3, ti4, ti5, tr11, &
&tr12, tr2, tr3, tr4, tr5
data tr11,ti11,tr12,ti12 /.309016994374947,.951056516295154, &
&-.809016994374947,.587785252292473/
do k=1,l1
   cr2 = cc(1,k,5)+cc(1,k,2)
   ci5 = cc(1,k,5)-cc(1,k,2)
   cr3 = cc(1,k,4)+cc(1,k,3)
   ci4 = cc(1,k,4)-cc(1,k,3)
   ch(1,1,k) = cc(1,k,1)+cr2+cr3
   ch(ido,2,k) = cc(1,k,1)+tr11*cr2+tr12*cr3
   ch(1,3,k) = ti11*ci5+ti12*ci4
   ch(ido,4,k) = cc(1,k,1)+tr12*cr2+tr11*cr3
   ch(1,5,k) = ti12*ci5-ti11*ci4
end do
if (ido .eq. 1) return
idp2 = ido+2
if((ido-1)/2.lt.l1) go to 104
do k=1,l1
   do i=3,ido,2
      ic = idp2-i
      dr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      di2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      dr3 = wa2(i-2)*cc(i-1,k,3)+wa2(i-1)*cc(i,k,3)
      di3 = wa2(i-2)*cc(i,k,3)-wa2(i-1)*cc(i-1,k,3)
      dr4 = wa3(i-2)*cc(i-1,k,4)+wa3(i-1)*cc(i,k,4)
      di4 = wa3(i-2)*cc(i,k,4)-wa3(i-1)*cc(i-1,k,4)
      dr5 = wa4(i-2)*cc(i-1,k,5)+wa4(i-1)*cc(i,k,5)
      di5 = wa4(i-2)*cc(i,k,5)-wa4(i-1)*cc(i-1,k,5)
      cr2 = dr2+dr5
      ci5 = dr5-dr2
      cr5 = di2-di5
      ci2 = di2+di5
      cr3 = dr3+dr4
      ci4 = dr4-dr3
      cr4 = di3-di4
      ci3 = di3+di4
      ch(i-1,1,k) = cc(i-1,k,1)+cr2+cr3
      ch(i,1,k) = cc(i,k,1)+ci2+ci3
      tr2 = cc(i-1,k,1)+tr11*cr2+tr12*cr3
      ti2 = cc(i,k,1)+tr11*ci2+tr12*ci3
      tr3 = cc(i-1,k,1)+tr12*cr2+tr11*cr3
      ti3 = cc(i,k,1)+tr12*ci2+tr11*ci3
      tr5 = ti11*cr5+ti12*cr4
      ti5 = ti11*ci5+ti12*ci4
      tr4 = ti12*cr5-ti11*cr4
      ti4 = ti12*ci5-ti11*ci4
      ch(i-1,3,k) = tr2+tr5
      ch(ic-1,2,k) = tr2-tr5
      ch(i,3,k) = ti2+ti5
      ch(ic,2,k) = ti5-ti2
      ch(i-1,5,k) = tr3+tr4
      ch(ic-1,4,k) = tr3-tr4
      ch(i,5,k) = ti3+ti4
      ch(ic,4,k) = ti4-ti3
   end do
end do
return
104 do i=3,ido,2
   ic = idp2-i
   do k=1,l1
      dr2 = wa1(i-2)*cc(i-1,k,2)+wa1(i-1)*cc(i,k,2)
      di2 = wa1(i-2)*cc(i,k,2)-wa1(i-1)*cc(i-1,k,2)
      dr3 = wa2(i-2)*cc(i-1,k,3)+wa2(i-1)*cc(i,k,3)
      di3 = wa2(i-2)*cc(i,k,3)-wa2(i-1)*cc(i-1,k,3)
      dr4 = wa3(i-2)*cc(i-1,k,4)+wa3(i-1)*cc(i,k,4)
      di4 = wa3(i-2)*cc(i,k,4)-wa3(i-1)*cc(i-1,k,4)
      dr5 = wa4(i-2)*cc(i-1,k,5)+wa4(i-1)*cc(i,k,5)
      di5 = wa4(i-2)*cc(i,k,5)-wa4(i-1)*cc(i-1,k,5)
      cr2 = dr2+dr5
      ci5 = dr5-dr2
      cr5 = di2-di5
      ci2 = di2+di5
      cr3 = dr3+dr4
      ci4 = dr4-dr3
      cr4 = di3-di4
      ci3 = di3+di4
      ch(i-1,1,k) = cc(i-1,k,1)+cr2+cr3
      ch(i,1,k) = cc(i,k,1)+ci2+ci3
      tr2 = cc(i-1,k,1)+tr11*cr2+tr12*cr3
      ti2 = cc(i,k,1)+tr11*ci2+tr12*ci3
      tr3 = cc(i-1,k,1)+tr12*cr2+tr11*cr3
      ti3 = cc(i,k,1)+tr12*ci2+tr11*ci3
      tr5 = ti11*cr5+ti12*cr4
      ti5 = ti11*ci5+ti12*ci4
      tr4 = ti12*cr5-ti11*cr4
      ti4 = ti12*ci5-ti11*ci4
      ch(i-1,3,k) = tr2+tr5
      ch(ic-1,2,k) = tr2-tr5
      ch(i,3,k) = ti2+ti5
      ch(ic,2,k) = ti5-ti2
      ch(i-1,5,k) = tr3+tr4
      ch(ic-1,4,k) = tr3-tr4
      ch(i,5,k) = ti3+ti4
      ch(ic,4,k) = ti4-ti3
   end do
end do
return
end subroutine radf5

subroutine radfg (ido,ip,l1,idl1,cc,c1,c2,ch,ch2,wa)
implicit none
integer, intent(in) :: idl1, ido, ip, l1
real, intent(inout) :: c1(ido,l1,ip), c2(idl1,ip), cc(ido,ip,l1), &
&ch(ido,l1,ip), ch2(idl1,ip)
real :: wa(*)
integer :: i, ic, idij, idp2, ik, ipp2, ipph, is, j, j2, jc, k, l, &
&lc, nbd
real :: ai1, ai2, ar1, ar1h, ar2, ar2h, arg, dc2, dcp, ds2, dsp, &
&tpi
data tpi/6.28318530717959/
arg = tpi/float(ip)
dcp = cos(arg)
dsp = sin(arg)
ipph = (ip+1)/2
ipp2 = ip+2
idp2 = ido+2
nbd = (ido-1)/2
if (ido .eq. 1) go to 119
do ik=1,idl1
   ch2(ik,1) = c2(ik,1)
end do
do j=2,ip
   do k=1,l1
      ch(1,k,j) = c1(1,k,j)
   end do
end do
if (nbd .gt. l1) go to 107
is = -ido
do j=2,ip
   is = is+ido
   idij = is
   do i=3,ido,2
      idij = idij+2
      do k=1,l1
         ch(i-1,k,j) = wa(idij-1)*c1(i-1,k,j)+wa(idij)*c1(i,k,j)
         ch(i,k,j) = wa(idij-1)*c1(i,k,j)-wa(idij)*c1(i-1,k,j)
      end do
   end do
end do
go to 111
107 is = -ido
do j=2,ip
   is = is+ido
   do k=1,l1
      idij = is
      do i=3,ido,2
         idij = idij+2
         ch(i-1,k,j) = wa(idij-1)*c1(i-1,k,j)+wa(idij)*c1(i,k,j)
         ch(i,k,j) = wa(idij-1)*c1(i,k,j)-wa(idij)*c1(i-1,k,j)
      end do
   end do
end do
111 if (nbd .lt. l1) go to 115
do j=2,ipph
   jc = ipp2-j
   do k=1,l1
      do i=3,ido,2
         c1(i-1,k,j) = ch(i-1,k,j)+ch(i-1,k,jc)
         c1(i-1,k,jc) = ch(i,k,j)-ch(i,k,jc)
         c1(i,k,j) = ch(i,k,j)+ch(i,k,jc)
         c1(i,k,jc) = ch(i-1,k,jc)-ch(i-1,k,j)
      end do
   end do
end do
go to 121
115 do j=2,ipph
   jc = ipp2-j
   do i=3,ido,2
      do k=1,l1
         c1(i-1,k,j) = ch(i-1,k,j)+ch(i-1,k,jc)
         c1(i-1,k,jc) = ch(i,k,j)-ch(i,k,jc)
         c1(i,k,j) = ch(i,k,j)+ch(i,k,jc)
         c1(i,k,jc) = ch(i-1,k,jc)-ch(i-1,k,j)
      end do
   end do
end do
go to 121
119 do ik=1,idl1
   c2(ik,1) = ch2(ik,1)
end do
121 do j=2,ipph
   jc = ipp2-j
   do k=1,l1
      c1(1,k,j) = ch(1,k,j)+ch(1,k,jc)
      c1(1,k,jc) = ch(1,k,jc)-ch(1,k,j)
   end do
end do
!
ar1 = 1.
ai1 = 0.
do l=2,ipph
   lc = ipp2-l
   ar1h = dcp*ar1-dsp*ai1
   ai1 = dcp*ai1+dsp*ar1
   ar1 = ar1h
   do ik=1,idl1
      ch2(ik,l) = c2(ik,1)+ar1*c2(ik,2)
      ch2(ik,lc) = ai1*c2(ik,ip)
   end do
   dc2 = ar1
   ds2 = ai1
   ar2 = ar1
   ai2 = ai1
   do j=3,ipph
      jc = ipp2-j
      ar2h = dc2*ar2-ds2*ai2
      ai2 = dc2*ai2+ds2*ar2
      ar2 = ar2h
      do ik=1,idl1
         ch2(ik,l) = ch2(ik,l)+ar2*c2(ik,j)
         ch2(ik,lc) = ch2(ik,lc)+ai2*c2(ik,jc)
      end do
   end do
end do
do j=2,ipph
   do ik=1,idl1
      ch2(ik,1) = ch2(ik,1)+c2(ik,j)
   end do
end do
!
if (ido .lt. l1) go to 132
do k=1,l1
   do i=1,ido
      cc(i,1,k) = ch(i,k,1)
   end do
end do
go to 135
132 do i=1,ido
   do k=1,l1
      cc(i,1,k) = ch(i,k,1)
   end do
end do
135 do j=2,ipph
   jc = ipp2-j
   j2 = j+j
   do k=1,l1
      cc(ido,j2-2,k) = ch(1,k,j)
      cc(1,j2-1,k) = ch(1,k,jc)
   end do
end do
if (ido .eq. 1) return
if (nbd .lt. l1) go to 141
do j=2,ipph
   jc = ipp2-j
   j2 = j+j
   do k=1,l1
      do i=3,ido,2
         ic = idp2-i
         cc(i-1,j2-1,k) = ch(i-1,k,j)+ch(i-1,k,jc)
         cc(ic-1,j2-2,k) = ch(i-1,k,j)-ch(i-1,k,jc)
         cc(i,j2-1,k) = ch(i,k,j)+ch(i,k,jc)
         cc(ic,j2-2,k) = ch(i,k,jc)-ch(i,k,j)
      end do
   end do
end do
return
141 do j=2,ipph
   jc = ipp2-j
   j2 = j+j
   do i=3,ido,2
      ic = idp2-i
      do k=1,l1
         cc(i-1,j2-1,k) = ch(i-1,k,j)+ch(i-1,k,jc)
         cc(ic-1,j2-2,k) = ch(i-1,k,j)-ch(i-1,k,jc)
         cc(i,j2-1,k) = ch(i,k,j)+ch(i,k,jc)
         cc(ic,j2-2,k) = ch(i,k,jc)-ch(i,k,j)
      end do
   end do
end do
return
end subroutine radfg

subroutine cheby (a, b, f, g, phi, eps, itno, mxiter, l, m, &
&p, q, error, ierr, w)
implicit none
integer, intent(inout) :: ierr, itno
integer, intent(in) :: l, m, mxiter
integer :: i1, i2, i3, i4, i5, lp1, lpm, mp1, n, np1
!     ******************************************************************
!     Rational Chebychev approximation of continuous functions
!     ******************************************************************
double precision, intent(in) :: a, b
double precision :: f, g, phi
double precision, intent(in) :: eps
double precision, intent(inout) :: error
double precision, intent(inout) :: p(*), q(*), w(*)
external f, g, phi
!     -------------------
if (l .lt. 0 .or. m .lt. 0) go to 10
lp1 = l + 1
mp1 = m + 1
lpm = l + m
n = lpm + 1
np1 = n + 1
!     -------------------
i1 = np1 + 1
i2 = i1 + np1
i3 = i2 + np1*np1
i4 = i3 + np1
i5 = i4 + np1
call cheby1 (a, b, f, g, phi, eps, itno, mxiter, l, m, p, q, &
&error, ierr, lp1, mp1, lpm, n, np1, w(1), &
&w(i1), w(i2), w(i3), w(i4), w(i5))
return
!     ------------------------------------------------------------------
!     Error return
!     ------------------------------------------------------------------
10 ierr = 1
return
end subroutine cheby

subroutine cheby1 (a, b, f, g, phi, eps, itno, mxiter, l, m, &
&p, q, error, ierr, lp1, mp1, lpm, n, np1, &
&x, xval, c, d, err, h)
implicit none
integer, intent(inout) :: ierr, itno
integer, intent(in) :: l, lp1, lpm, m, mp1, mxiter, n, np1
integer :: i, ii, j, k, kount, lpi
!     ------------------------------------------------------------------
double precision, intent(in) :: a, b
double precision :: f, g, phi
double precision, intent(in) :: eps
double precision, intent(out) :: error
double precision, intent(inout) :: p(lp1), q(mp1), x(np1), &
&xval(np1), c(np1,np1), d(np1), err(np1), h(np1)
double precision :: b1, c0, del, dn, dnp1, eps0, half, h1, olderr, &
&one, pi, sign, sum, tau, templ, ten, test, u, xi, xlb, xm1, y, y2, &
&y3, z, zero, zz, z1, z2, z3
external f, g, phi
!     -------------------
data pi/3.14159265358979323846264338328d0/
data zero/0.d0/, half/.5d0/, one/1.d0/, ten/10.d0/
data eps0/1.d-2/, tau/.015d0/, c0/.0625d0/
!     -------------------
error = zero
if (eps .le. zero .or. eps .ge. eps0) go to 200
ierr = 0
!
itno = 1
xlb = zero
dn = n
dnp1 = np1
!
do 10 i = 1,lp1
10 p(i) = zero
do 11 i = 1,mp1
11 q(i) = zero
q(1) = one
!
!     Compute initial approximations of the critical points
!
x(1) = a
x(np1) = b
k = n/2
if (k .le. 0) go to 30
b1 = half*(b - a)
xm1 = half*(a + b)
do 20 i = 1,k
xi = i
z = -b1*dcos(pi*(xi/dn))
x(i+1) = z + xm1
ii = np1 - i
20 x(ii) = xm1 - z
!
!     Evaluate phi at the critical points
!
30 do 31 i = 1,np1
31 xval(i) = phi(x(i))
kount = 1
!
!     Set up the linear equations
!
40 k = l + 2
sign = one
do i = 1,np1
sign = -sign
c(i,1) = one
if (l .le. 0) go to 42
do 41 j = 2,lp1
41 c(i,j) = c(i,j-1)*xval(i)
42 d(i) = f(x(i))
if (m .le. 0) go to 44
templ = sign*xlb*g(x(i)) - d(i)
c(i,k) = xval(i)*templ
if (k .gt. lpm) go to 44
do 43 j = k,lpm
43 c(i,j+1) = c(i,j)*xval(i)
44 c(i,np1) = sign*g(x(i))
end do
!
!     SOLVE THE EQUATIONS CX = D AND STORE THE RESULTS IN D
!
call dpslv (np1, 1, c, np1, d, np1, ierr)
if (ierr .ne. 0) go to 220
if (kount .gt. 1) go to 50
!
!     Redefine the equations and solve
!
xlb = (d(np1) + xlb*dn)/dnp1
if (m .le. 0) go to 61
kount = 2
go to 40
!
50 test = dabs(xlb - d(np1))
xlb = (d(np1) + xlb*dn)/dnp1
kount = kount + 1
if (kount .le. 4 .and. test .gt. eps0*dabs(xlb)) go to 40
!
!     Store the results in P and Q
!
do 60 i = 2,mp1
lpi = l + i
60 q(i) = d(lpi)
61 do 62 i = 1,lp1
62 p(i) = d(i)
!
!     Search for new critical points
!
olderr = error
error = zero
z1 = zero
u = one
if (xlb .lt. zero) u = -u
!
if (n .gt. 1) go to 70
h(1) = tau*(x(2) - x(1))
h(2) = -h(1)
go to 72
70 do 71 i = 2,n
71 h(i) = tau*(x(i+1) - x(i-1))
h(1) = half*h(2)
h(np1) = -half*h(n)
72 continue
!
do i = 1,np1
y2 = x(i)
h1 = h(i)
y3 = y2 + h1
call cerr(y2, f(y2), g(y2), phi(y2), del, ierr, l, lp1, m, np1, d)
if (ierr .ne. 0) return
z2 = u*del
call cerr(y3, f(y3), g(y3), phi(y3), del, ierr, l, lp1, m, np1, d)
if (ierr .ne. 0) return
z3 = u*del
if (z2 .lt. z3) go to 80
h1 = -h1
z = z3
z3 = z2
z2 = z
y = y3
y3 = y2
y2 = y
!
80 y = y3 + h1
if (y .ge. a) go to 81
y = a
go to 90
81 if (y .le. b) go to 82
y = b
go to 90
82 call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
if (ierr .ne. 0) return
z = u*del
if (z .le. z3) go to 83
y2 = y3
y3 = y
z2 = z3
z3 = z
go to 80
83 y = (z - z3) + (z2 - z3)
if (y .ne. zero) go to 84
y = y3
go to 90
84 y = half*(y2 + y3) + h1*(z2 - z3)/y
!
90 x(i) = y
call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
if (ierr .ne. 0) return
err(i) = del
u = -u
if (i .eq. 1) go to 91
if (x(i) .le. x(i-1)) go to 230
91 z = dabs(err(i))
error = dmax1(error, z)
if (z .ge. ten) go to 240
y = dabs(xlb)
zz = one
if (y .ne. zero) zz = dabs(z - y)/y
if (z1 .lt. zz) z1 = zz
end do
!
!     Search for an extra extremal point between the endpoints
!     of the interval and the critical points
!
if (x(1) .le. a) go to 110
h1 = c0*(x(1) - a)
u = one
if (xlb .ge. zero) u = -u
z3 = zero
y = a
do 100 i = 1,16
call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
if (ierr .ne. 0) return
z = u*del
if (z .le. z3) go to 100
z3 = z
z2 = y
100 y = y + h1
error = dmax1(error, z3)
z = dabs(xlb)
if (z3 .le. z) go to 110
i = np1
do 101 ii = 2,np1
err(i) = err(i-1)
x(i) = x(i-1)
101 i = i - 1
x(1) = z2
err(1) = u*z3
go to 113
!
110 if (x(np1) .ge. b) go to 120
h1 = c0*(b - x(np1))
u = one
if (err(np1) .ge. zero) u = -u
z3 = zero
y = b
do 111 i = 1,16
call cerr(y, f(y), g(y), phi(y), del, ierr, l, lp1, m, np1, d)
if (ierr .ne. 0) return
z = u*del
if (z .le. z3) go to 111
z3 = z
z2 = y
111 y = y - h1
error = dmax1(error, z3)
z = dabs(xlb)
if (z3 .le. z) go to 120
do 112 i = 1,n
err(i) = err(i+1)
112 x(i) = x(i+1)
x(np1) = z2
err(np1) = u*z3
113 xlb = -xlb
zz = one
if (z .ne. zero) zz = dabs(z3 - z)/z
if (z1 .lt. zz) z1 = zz
!
!     Check for convergence
!
120 if (z1 .le. eps) return
!
!     Set up for the next iteration
!
if (itno .ge. mxiter) go to 210
sum = zero
sign = one
do 130 i = 1,np1
sum = sum + sign*err(i)
130 sign = -sign
xlb = sum/dnp1
itno = itno + 1
go to 30
!     ------------------------------------------------------------------
!     Error return
!     ------------------------------------------------------------------
!     Input error
!
200 ierr = 1
return
!
!     MXITER iterations were performed - more iterations are needed
!
210 ierr = 2
return
!
!     The linear equations cannot be solved
!
220 if (itno .eq. 1) go to 250
ierr = 3
return
!
!     The sequence of critical points is not monotonically increasing
!
230 ierr = 4
if (i .le. n) error = olderr
return
!
!     It appears that the algorithm has failed to converge
!     there may be poles in the rational approximation
!
240 ierr = 5
return
!
!     The routine HAS completely failed - the results should be ignored
!
250 ierr = 6
return
end subroutine cheby1

subroutine cerr (t, ft, gt, phit, del, ierr, l, lp1, m, np1, d)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, lp1, m, np1
integer :: i, ii
!     ------------------------------------------------------------------
!     Compute the approximation error at point T
!     ------------------------------------------------------------------
double precision, intent(in) :: t, ft, gt, phit
double precision, intent(inout) :: del
double precision, intent(in) :: d(np1)
double precision :: p, q, r, zero, one
data zero/0.d0/, one/1.d0/
!     -------------------
p = d(lp1)
if (l .le. 0) go to 20
do 10 i = 1,l
ii = lp1 - i
10 p = p*phit + d(ii)
!
20 q = zero
if (m .le. 0) go to 22
do 21 i = 1,m
ii = np1 - i
21 q = (q + d(ii))*phit
22 q = q + one
!
if (q .eq. zero) go to 110
if (gt .eq. zero) go to 100
r = p/q
del = (r - ft)/gt
return
!     ------------------------------------------------------------------
!     Error return
!     ------------------------------------------------------------------
!     The function G is zero at point T
!
100 ierr = 1
return
!
!     The routine HAS completely failed - the results should be ignored
!
110 ierr = 6
return
end subroutine cerr

subroutine adapt (f, xlft, xrgt, epsln, npiece, errest, xknots, &
&coefs, ierr, kmax, ndeg, nsmth, anorm, dx, mo, kbreak, brakpt, &
&kdiff, vallft, valrgt)
implicit none
integer :: ierr, kbreak, kdiff(kbreak), kmax, mo, ndeg, npiece, &
&nsmth
integer :: k, kdimen, ndimen
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
!     Tabulation of the internal and external names of the arguments.
!
!
!    INTERNAL   EXTERNAL
!     F          F
!     A          XLFT
!     B          XRGT
!     ACCUR      EPSLN
!     KNOTS      NPIECE
!     ERROR      ERREST
!     XKNOTS     XKNOTS
!     COEFS      COEFS
!     IERR       IERR
!     KMAX       KMAX
!     DEGREE     NDEG
!     SMOOTH     NSMTH
!     NORM       ANORM
!     CHARF      DX
!     EDIST      MO
!     NBREAK     KBREAK
!     XBREAK     BRAKPT
!     DBREAK     KDIFF
!     BLEFT      VALLFT
!     BRIGHT     VALRGT
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: xknots(*), coefs(kmax,*)
double precision :: anorm, brakpt(kbreak), dx, epsln, errest, &
&vallft(kbreak), valrgt(kbreak), xlft, xrgt
double precision :: f
external f
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
!
10 a = xlft
b = xrgt
accur = epsln
degree = ndeg
smooth = nsmth
norm = anorm
charf = dx
edist = mo
nbreak = kbreak
if (nbreak.le.0 .or. nbreak.ge.21) go to 30
do 20 k = 1,nbreak
  xbreak(k) = brakpt(k)
  dbreak(k) = kdiff(k)
  bleft(k) = vallft(k)
  bright(k) = valrgt(k)
20 continue
30 continue
!
kdimen = kmax+1
ndimen = ndeg+1
call adapt1(f, xknots, coefs, kdimen, kmax, ndimen, ierr)
npiece = knots
errest = error
return
end subroutine adapt

subroutine adapt1(f, xknots, coefs, kdimen, kmax, ndimen, ierr)
implicit none
integer :: ierr, kdimen, kmax, ndimen
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!     This algorithm computes a piecewise polynomial approximation
!  of specified smoothness, accuracy and degree.  The input to the
!  computation is
!
!   F      - FUNCTION BEING APPROXIMATED. IT MUST PROVIDE VALUES OF
!            derivatives up to the order of smoothness specified for
!            the approximation.  The calling sequence is F(X,FDERV) and
!            FDERV contains the DERIVATIVES( SEE CONSTRAINT BELOW)
!   A,B    - THE ENDPOINTS OF THE INTERVAL OF APPROXIMATION
!   ACCUR  - the accuracy required for the approximation
!   smooth - the smoothness required for the approximation
!              = 0  MEANS CONTINUOUS
!              = 1  MEANS CONTINUOUS SLOPE
!              = 2  MEANS CONTINUOUS SECOND DERIVATIVE, ETC.
!   Degree - the degree of the polynomial pieces.
!            Must have degree GT 2*smooth
!   CHARF  - characteristic length of the function F(X). Pieces are not
!            longer than this length.
!   NORM   - NORM TO MEASURE THE APPROXIMATION ERROR
!              = 1  L1 APPROXIMATION (LEAST DEVIATIONS)
!              = 2  L2 APPROXIMATION (LEAST SQUARES)
!              = 3  TCHEBYCHEFF (MINIMAX) APPROXIMATION
!              =-P  (NEGATIVE VALUE) GENERAL LP APPROXIMATION
!   NBREAK - number of special break points in the approximation.
!            Associated input variables are
!              XBREAK(J)  - location of break points
!              DBREAK(J)  - derivative broken at XBREAK
!              BLEFT (J)  - value from left for DBREAK derivative
!              BRIGHT(J)  -   -    -   RIGHT -    -        -
!   EDIST  - switch to change from proportional error distribution
!            to fixed distribution. This is primarily of use in
!            approximation of functions with singularities. One should
!            USE NORM = 1. OR SO IN SUCH CASES
!              = 0  PROPORTIONAL DISTRIBUTION
!              = 1  APPROXIMATE FIXED ERROR DISTRIBUTION
!                   attempts to achieve specified accuracy value ACCUR
!              = 2  TRUE FIXED ERROR DISTRIBUTION
!
!  ********** OUTPUT **********
!     the output of the computation consists of 4 parts, each returned
!     to the user in a different way. They are
!
!   XKNOTS,COEFS - arrays defining the piecewise polynomial result.
!            XKNOTS(K)  = KNOTS OF THE APPROXIMATION ( K = 1 TO KNOTS)
!                         the last one is right end point of interval
!            COEFS(K,N) = COEFFICIENT OF (X - XKNOT(K))**(N-1) IN THE
!                         interval XKNOT(K) to XKNOT(K+1)
!                           K = 1 TO KNOTS-1  AND  N = 1 TO DEGREE+1
!            these arrays are passed as arguments so as to use variable
!            dimensions. The arrays are of dimension XKNOTS(KDIMEN) and
!            COEFS(KMAX,NDIMEN). IT IS ASSUMED THAT KDIMEN = KMAX+1.
!               ***** NOTE ***** SEVERAL SMALL ARRAYS HERE HAVE FIXED
!                        dimensions that limit degree and thus NDIMEN
!                        SHOULD NOT EXCEED THIS LIMIT (CURRENTLY = 20)
!
!   RESULZ - a labeled common block containing knots and error
!              knots - number of knots of the approximation
!              error - estimated accuracy of the approximation
!
!   IERR - status indicator. IERR takes the values
!      0   THE APPROXIMATION WAS SUCCESSFULLY CONSTRUCTED.
!     -1   INPUT ERROR REPORTED BY ADSET.
!     -2   A AND B ARE TOO CLOSE.
!     -3   CHARF IS TOO SMALL.
!     -4   EITHER ALL THE BREAK POINTS ARE NOT BETWEEN A AND B, OR
!          XBREAK(I).GE.XBREAK(I+1) FOR SOME I.
!     -5   DBREAK(I).LT.0 .OR. DBREAK(I).GT.(DEGREE-1)/2 FOR SOME I.
!      1   THE KNOT LIMIT WAS EXCEEDED.
!      2   BREAK POINT ADJUSTMENT REQUIRES THAT A SUBINTERVAL BE
!          partitioned. However, this cannot be done either because
!          the interval stack is full, or partitioning will produce
!          too small an interval.
!      3   A SUBINTERVAL MUST BE PARTITIONED BECAUSE ITS LENGTH IS
!          greater than CHARF. However, this cannot be done since the
!          interval stack is full.
!      4   A SUBINTERVAL MUST BE PARTITIONED SO THAT THE ACCURACY
!          criteria can be satisfied. However, this cannot be done
!          either because the interval stack is full, or partitioning
!          will produce too small an interval.
!
!  ********** DIMENSION CONSTRAINTS **********
!     MAXKNT - max number of knots taken from user via KDIMEN
!              arrays with this dimension (or related values)
!                   COEFS   XKNOTS
!     MAXPAR - MAX NUMBER OF PARAMETERS PER INTERVAL (CURRENTLY = 20)
!                   user provided NDIMEN must have NDIMEN LE MAXPAR
!                   must have  degree + 1 LE MAXPAR
!              arrays with this dimension (or related values)
!                D       DDTEMP  FDERVL  FDERVR  FDUMB   FACTOR
!                FINTRP  FLEFT   FRIGHT  POWERS  XTEMP   XINTRP  XDD
!              ***** NOTE ***** MAXPAR ALSO AFFECTS ARGUMENT FDERV
!              of function F.  FDERVL, FDERVR are also involved.
!              Should declare FDERV of size 10 in F to be safe.
!     MAXAUX - MAXIMUM NUMBER OF AUXILIARY INPUT ( = 20 NOW ). ARRAYS
!                 XBREAK  DBREAK  BLEFT   BRIGHT
!     MAXSTK - max size of active interval stack
!              MIN INTERVAL LENGTH IS 2**(-MAXSTK)*(B-A). ARRAYS
!                 XLEFT   XRIGHT
!
!  **********  PORTABILITY CONSIDERATIONS  **********
!
!     All the routines in this package (except adapt) are written in
!     ANSI standard Fortran. In addition, they meet all the requirements
!     of the Bell labs portable Fortran -PFORT-.  Nevertheless, the
!     routines are affected by a change in machine word length and
!     changing to single precision.
!
!     ***** THE GAUSS WEIGHTS AND ABSCISSAE IN ADCOMP ARE GIVEN TO
!           30 digits. The parameter EPS0 in ADSET specifies the
!           accuracy of these constants. If the accuracy is changed
!           TO K DECIMAL DIGITS THEN SET EPS0 = 10**(-K).
!
!     ***** THE INTERVAL STACK SIZE MAXSTK IS DEFINED IN ADSET TO
!           be 50. If MAXSTK is modified then set the dimensions of
!           XLEFT and XRIGHT to the new value for MAXSTK. Note that
!           THE MINIMUM INTERVAL LENGTH IS 2**(-MAXSTK)*(B-A).
!
!  SINGLE PRECISION CONVERSION -- REQUIRES FOUR STEPS
!     1. DECLARE ALL DOUBLE PRECISION VARIABLES TO BE REAL.
!
!     2. Change all double precision numbers in the data statements.
!        (Floating point numbers appear only in data statements.)
!
!     3. Change dabs,DMAX1,DMIN1 at many places.
!
!     4. Change DPMPAR to SPMPAR in ADSET.
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: xknots(kdimen), coefs(kmax,ndimen)
double precision :: f
external f
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
!                      KNTDIM - KDIMEN, name changed to put in common
!                      NPARDM - NDIMEN, name changed to put in common
common /resulz/ error, knots
!                      KNOTS = FINAL NO. OF KNOTS, INCLUDES B AS ONE.
!                      ERROR = ESTIMATE OF ERROR ACTUALLY ACHIEVED.
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
!             KONTRL contains generally useful variables
!                      MAXSTK - see comments above
!                      buffer - the machine dependent tolerance used
!                               by the algorithm
!                      NSTACK - counter for interval stack, consists of
!                               (XLEFT(J),XRIGHT(J))  J = 1 TO NSTACK
!                      ERRORI - error estimate for top interval
!                      DSCTOL - tolerance to check discarding intervals
!                      DISCRD - switch to signal discard of top interval
!                      factor - array of factorials
!                      NPAR   - NUMBER OF PAREMETERS = DEGREE + 1
!                      INTERP - number of interior interpolation points
!                               in the normal interval
!                      IBREAK - counter on break points
!                      break  - switch for break point in top interval
!                               0     = NO BREAK PRESENT
!                               LEFT  = BREAK AT XLEFT(NSTACK)
!                               RIGHT = BREAK AT XRIGHT(NSTACK)
!                               BOTH  = BREAK AT BOTH ENDS
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!             COMDIF contains variables used only by ADCOMP and friends.
!                      NINTRP - number of interior interpolation points
!                               for the current interval
!                      XINTRP - interior interpolation points
!                      FINTRP - F values at XINTRP points
!                      LEFTX  - multiplicity of interpolation at XLEFT
!                               = NO. OF DERIVATIVES MATCHED AT XLEFT
!                      FLEFT  - values of F and its derivatives at XLEFT
!                      RIGHTX - multiplicity of interpolation at XRIGHT
!                      fright - values of F and derivatives at XRIGHT
!                      DDTEMP - the array of divided differences
!                      XDD    - THE X VALUES FOR DDTEMP WITH PROPER
!                               multiplicities of XLEFT and XRIGHT
!
!------------------------ Main control program -------------------------
!
!            Check the input and initialize all the parameters
!
call adset(xknots, coefs, kdimen, kmax, ndimen, ierr)
if (ierr.ne.0) return
!
!                  Loop over processing of intervals
!
10 call adtake(ierr)
if (ierr.ne.0) return
call adcomp(f)
!
!                   Check for discarding intervals
!
call adchk
!
!            Put new intervals on stack or discard, update status
!
call adput(xknots, coefs, kdimen, kmax, ndimen, ierr)
if (ierr.ne.0) return
!
!                    Test for normal termination
!
if (nstack.eq.0) return
!
!                Check on the number of knots generated
!
if (knots.lt.maxknt) go to 10
ierr = 1
return
end subroutine adapt1

subroutine adset(xknots, coefs, kdimen, kmax, ndimen, ierr)
implicit none
integer :: ierr, kdimen, kmax, ndimen
integer :: j, k, kboth, kleft, kright, limsm
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS PROGRAM CHECKS THE INPUT DATA AND INITIALIZES THE COMPUTATION
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: xknots(kdimen), coefs(kmax,ndimen)
double precision :: akmax, eps, eps0, km1, ratio, zero, one, two, &
&three, c100
double precision :: dpmpar
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
data eps0/1.d-30/
data zero,one,two,three,c100/0.d0,1.d0,2.d0,3.d0,100.d0/
data kleft, kright, kboth /1, 2, 3/
!
eps = dpmpar(1)
buffer = c100*dmax1(eps,eps0)
!
!         Put data statement items into common variables
!
left = kleft
right = kright
both = kboth
!
! -------- Set current values of limits on dimensions ------------------
!
kntdim = kdimen
npardm = ndimen
maxknt = kntdim
maxstk = 50
maxpar = min0(20,npardm)
maxaux = 20
!
! -------- Check input data --------------------------------------------
!
ierr = 0
if (a.ge.b .or. accur.le.zero) go to 200
if (degree.ge.maxpar .or. 2*smooth.ge.degree) go to 200
akmax = kmax
ratio = (b-a)/(dabs(a)+dabs(b))
if (ratio.le.two*buffer*akmax) go to 210
if (charf.lt.(b-a)/akmax) go to 220
if (norm.ge.zero .and. (norm-one)*(norm-two)*(norm-three).ne.zero) &
&go to 200
if (edist*(edist-1)*(edist-2).ne.0) go to 200
if (nbreak.lt.0 .or. nbreak.gt.maxaux) go to 200
if (nbreak.eq.0) go to 150
!
!         Check the break point data, monotonicity and degree
!
j = 1
if (xbreak(1).lt.a .or. xbreak(nbreak).gt.b) go to 230
if (nbreak.eq.1) go to 110
do 100 j = 2,nbreak
  if (xbreak(j-1).ge.xbreak(j)) go to 230
100 continue
110 limsm = (degree-1)/2
do j=1,nbreak
  if (dbreak(j).lt.0 .or. dbreak(j).gt.limsm) go to 240
end do
!
! -------- Initialization of variables ---------------------------------
!
!             Active interval stack
!
150 nstack = 1
xleft(1) = a
xright(1) = b
!
!             Termination and error values
!
error = zero
dsctol = accur**dabs(norm)
if (edist.eq.0) dsctol = dsctol/(b-a)
if (norm.eq.three) dsctol = accur
!
!             Miscellaneous variables and pointers
!
ibreak = 1
knots = 1
interp = degree + 2 - 2*smooth
xknots(1) = a
npar = degree + 1
!
!             Compute array of NPAR factorials
!
factor(1) = one
factor(2) = one
do k=3,npar
  km1 = k-1
  factor(k) = km1*factor(k-1)
end do
return
!
! -------- Error return ------------------------------------------------
!
200 ierr = -1
return
!
!         A and B are too close
!
210 ierr = -2
return
!
!         CHARF is too small
!
220 ierr = -3
return
!
!         Break points are not monotonic
!
230 ierr = -4
return
!
!         Bad value in derivative breaks
!
240 ierr = -5
return
end subroutine adset

subroutine adtake(ierr)
implicit none
integer :: ierr
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS PROGRAM TAKES AN ACTIVE INTERVAL OFF THE TOP OF THE STACK
!     it also does most of the work of locating and handling
!     break points
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: dx, ratio
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
!         Check for break point
break = 0
if (nbreak.eq.0 .or. ibreak.gt.nbreak) go to 20
if (xbreak(ibreak).gt.xright(nstack)) go to 20
!
!               Set control variable BREAK, check for location
if (xbreak(ibreak).gt.xleft(nstack)) go to 10
break = left
if (ibreak.eq.nbreak) go to 20
!             Check for second break point in this interval
if (xbreak(ibreak+1).ge.xright(nstack)) go to 20
!                 Next break is inside interval, split top interval
break = both
!                  Check exceeding stack limit. If so, stop
if (nstack.eq.maxstk) go to 30
!                     Dont split very small intervals, stop instead
dx = xbreak(ibreak+1) - xleft(nstack)
ratio = dx/(dabs(a)+dabs(b))
if (ratio.le.buffer) go to 30
nstack = nstack + 1
xleft(nstack) = xleft(nstack-1)
xright(nstack) = xbreak(ibreak+1)
xleft(nstack-1) = xright(nstack)
go to 20
!
10 break = right
!                 Check to see if break is already at right end point
if (xbreak(ibreak).ge.xright(nstack)) go to 20
!                 The break is inside interval, split top interval
!                  check exceeding stack limit. If so, stop
if (nstack.eq.maxstk) go to 30
!                     Dont split very small intervals, stop instead
dx = xbreak(ibreak) - xleft(nstack)
ratio = dx/(dabs(a)+dabs(b))
if (ratio.le.buffer) go to 30
nstack = nstack + 1
xleft(nstack) = xleft(nstack-1)
xright(nstack) = xbreak(ibreak)
xleft(nstack-1) = xright(nstack)
20 continue
return
!
!        A break point is in the interior of the top subinterval of
!        the stack.  The subinterval cannot be partitioned either
!        because the stack is full, or because partitioning leads to
!        too small an interval.
!
30 ierr = 2
return
end subroutine adtake

subroutine adcomp(f)
implicit none
integer :: j
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS PROGRAM COMPUTES THE PIECEWISE POLYNOMIAL APPROXIMATION ON
!     the current interval. It also estimates the error
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: absc(4), aj, dx, fdervl(9), fdervr(9), &
&fdumb(9), r, wgts(4)
double precision :: errint, f, polydd
external f, polydd
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
equivalence (fleft(2),fdervl(1)), (fright(2),fdervr(1))
data r/1.5d0/
!
!     Thirty digit values for the Gauss integration constants
!                    .861136311594052575223946488893D0
!                    .339981043584856264802665759103D0
!                    .347854845137453857373063949222D0
!                    .652145154862546142626936050778D0
!
!     ***** THE ABSISSAE AND WEIGHTS ARE GIVEN BELOW TO 30 DIGITS.
!           The parameter EPS0 in ADSET specifies the accuracy of
!           these constants. If the accuracy is changed to K decimal
!           DIGITS THEN SET EPS0 = 10**(-K).
!
data absc(1) /-.861136311594052575223946488893d0 /
data absc(2) /-.339981043584856264802665759103d0 /
data absc(3) / .339981043584856264802665759103d0 /
data absc(4) / .861136311594052575223946488893d0 /
data wgts(1) / .347854845137453857373063949222d0 /
data wgts(2) / .652145154862546142626936050778d0 /
data wgts(3) / .652145154862546142626936050778d0 /
data wgts(4) / .347854845137453857373063949222d0 /
!
!             Compute interpolation information
nintrp = degree - 2*smooth - 1
!
!          Increase number of interpolation points if break points are
!          specified with fewer derivatives than smooth
if (break.eq.left .or. break.eq.right) nintrp = nintrp + smooth - &
&dbreak(ibreak)
if (break.eq.both) nintrp = nintrp + 2*smooth - dbreak(ibreak) - &
&dbreak(ibreak+1)
if (nintrp.eq.0) go to 20
!
!             Generate equal spaced interpolation points
aj = nintrp+1
dx = (xright(nstack)-xleft(nstack))/aj
do 10 j = 1,nintrp
  aj = j
  xintrp(j) = xleft(nstack) + aj*dx
10 continue
!
!             Get left and right F-values, put F-value in first element
!             of arrays FLEFT and fright.  Get derivatives back as
!             other elements via the subarrays FDERVL and FDERVR.
20 fleft(1) = f(xleft(nstack),fdervl)
fright(1) = f(xright(nstack),fdervr)
leftx = smooth + 1
rightx = leftx
!            Get F-values at other interpolation points, if any
if (nintrp.eq.0) go to 40
do j=1,nintrp
  fintrp(j) = f(xintrp(j),fdumb)
end do
!
!          Check for break points, modify values if necessary
40 continue
if (break.ne.left) go to 50
leftx = dbreak(ibreak) + 1
fleft(leftx) = bright(ibreak)
50 if (break.ne.right) go to 60
rightx = dbreak(ibreak) + 1
fright(rightx) = bleft(ibreak)
60 if (break.ne.both) go to 70
leftx = dbreak(ibreak) + 1
rightx = dbreak(ibreak+1) + 1
fleft(leftx) = bright(ibreak)
fright(rightx) = bleft(ibreak+1)
70 continue
!
!           Compute divided differences, Newton form of polynomial
call newton(leftx, rightx, nintrp)
!
!         Compute norm of error of this appromimation using four pts
!         add 50 percent fudge factor
errori = errint(f,polydd,xleft(nstack),xright(nstack),absc,wgts)
errori = r*errori
return
end subroutine adcomp

double precision function errint(f, fit, aaa, bbb, points, weight)
implicit none
integer :: j
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS FUNCTION DOES A FOUR POINT INTEGRATION RULE FOR THE
!     absolute value of the difference of two FUNCTIONS( F AND FIT )
!                   ABS( F(X) - FIT(X) )**NORM
!     the integration uses the points and weights given and scaled
!     from (-1,1) to (AAA,BBB)
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: aaa, abmid, ba, bbb, fdumb(9), fit, p, pj, &
&points(*), weight(*), er, f1, f2, two, three
double precision :: f
external f, fit
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
data two,three/2.0d0,3.0d0/
!
!         COMPUTE MIDPOINT = ABMID AND HALF LENGTH = BA OF INTERVAL
abmid = (aaa+bbb)/two
ba = (bbb-aaa)/two
pj = abmid + ba*points(1)
!
!         Test for Tchebycheff (minimax) norm which uses special code
if (norm.eq.three) go to 20
!
!         Have general LP norm or least squares or least deviations
p = dabs(norm)
!              Initialize the quadrature rule
errint = dabs(f(pj,fdumb)-fit(pj))**p*weight(1)
!              Loop through remaining points
do 10 j = 2,4
  pj = abmid + ba*points(j)
  f1 = f(pj,fdumb)
  f2 = fit(pj)
  er = dabs(f1-f2)**p
  errint = errint + dabs(f(pj,fdumb)-fit(pj))**p*weight(j)
10 continue
errint = errint*ba
go to 40
!
!         Tchebycheff norm
20 continue
!             Find max error on points
!               initialize
errint = dabs(f(pj,fdumb)-fit(pj))
!              Loop through the remaining points
do j=2,4
  pj = abmid + ba*points(j)
  errint = dmax1(errint,dabs(f(pj,fdumb)-fit(pj)))
end do
40 continue
return
end function errint

subroutine newton(nl, nr, ni)
implicit none
integer :: ni, nl, nr
integer :: idif, ipt, ipt2, j, k, nddx, nl1, nl2, nr1, nr2, nrl, &
&nrlj, nrlj1
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS PROGRAM COMPUTES THE DIVIDED DIFFERENCES ARRAY AS FOLLOWS
!         NL COALESCED POINTS ON LEFT   - DERIV VALUES IN FLEFT
!         NR COALESCED POINTS ON RIGHT  -   -      -    - FRIGHT
!         NI DISTINCT  POINTS INBETWEEN - FNCTN    -    - FINTRP
!
!     THE POINTS ARE ORDERED XL = XLEFT (NSTACK)
!                            XR = XRIGHT(NSTACK)
!                            XINTRP ARRAY
!
!         Layout of the DDTEMP divided difference array
!
!     NL=6    LLLLLL****II
!     NR=4    LLLLL****II     L = FIRST TRIANGLE
!     NI=2    LLLL****II
!             LLL****II       R = SECOND TRIANGLE
!             LL****II
!             L****II         * = FILL BETWEEN TRIANGLES
!             RRRRII
!             RRRII           I = COMPLETION FOR INTERPOLATION POINTS
!             RRII
!             RII       IDIF = HORIZONTAL COORD. = DIFFERENCE ORDER
!             II        IPT  = VERTICAL COORD. ASSOCIATED WITH POINTS
!             I
!
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: difff, diffx
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
!                 Main calculation of divided differences
!         define a few short constants
nl1 = nl - 1
nl2 = nl + 1
nr1 = nr - 1
nr2 = nr + 1
nrl = nr + nl
!
!         PUT X-VALUES IN A SINGLE ARRAY WITH NDDX = NL+NR+NI POINTS
do 10 nddx = 1,nl
  xdd(nddx) = xleft(nstack)
10 continue
nddx = nl
do 20 k = 1,nr
  nddx = nddx + 1
  xdd(nddx) = xright(nstack)
20 continue
!            Check if there are any interpolation points to add to XDD
if (ni.eq.0) go to 40
do k=1,ni
  nddx = nddx + 1
  xdd(nddx) = xintrp(k)
end do
!
!           Fill border of first triangle - size NL.
40 continue
!         Top border
do 50 idif = 1,nl
  ddtemp(idif,1) = fleft(idif)/factor(idif)
50 continue
if (nl1.eq.0) go to 70
!                   Bottom border
do idif=1,nl1
  ipt = nl2 - idif
  ddtemp(idif,ipt) = ddtemp(idif,1)
end do
!
!          Fill border of second triangle - size NR
70 continue
!         Top border
do idif=1,nr
  ddtemp(idif,nl2) = fright(idif)/factor(idif)
end do
if (nrl.eq.nl2) go to 100
!                   Bottom border
do idif=1,nr1
  ipt = nrl + 1 - idif
  ddtemp(idif,ipt) = ddtemp(idif,nl2)
end do
!
!           Fill parallogram between the two triangles just filled
!          fill entries parallel to bottom of first triangle
100 continue
!
!         Loop stepping along top side of second triangle
do j=2,nr2
  idif = j
!             Loop stepping parallel to bottom side of first triangle
  do k=2,nl2
    ipt = nl + 2 - k
    difff = ddtemp(idif-1,ipt+1) - ddtemp(idif-1,ipt)
    ipt2 = ipt - 1 + idif
    diffx = xdd(ipt2) - xdd(ipt)
    ddtemp(idif,ipt) = difff/diffx
    idif = idif + 1
  end do
end do
!
!         Fill in bottom diagonals for interpolation points, if any
if (ni.eq.0) go to 150
!         Loop through the interpolatation points
do j=1,ni
  idif = 2
  nrlj = nrl + j
  ddtemp(1,nrlj) = fintrp(j)
!         Loop through the differences (IDIF index)
  nrlj1 = nrlj - 1
  do k=1,nrlj1
    ipt = nrlj - k
    difff = ddtemp(idif-1,ipt+1) - ddtemp(idif-1,ipt)
    diffx = xdd(nrlj) - xdd(ipt)
    ddtemp(idif,ipt) = difff/diffx
    idif = idif + 1
  end do
end do
150 continue
return
end subroutine newton

double precision function polydd(x)
implicit none
integer :: j, k
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS FUNCTION EVALUATES THE CURRENT POLYNOMIAL PIECE REPRESENTED
!     by the divided differences DDTEMP on the point set XDD.
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: x
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
polydd = ddtemp(degree+1,1)
do 10 k = 1,degree
  j = degree + 1 - k
  polydd = ddtemp(j,1) + (x-xdd(j))*polydd
10 continue
return
end function polydd

subroutine adchk
implicit none
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS PROGRAM CHECKS FOR DISCARDING INTERVAL, APPLIES VARIOUS
!     tests about discarding involving EDIST and CHARF.
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: aknots, dtest, dx, three, five
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
data three,five/3.0d0,5.0d0/
!
discrd = .false.
dx = xright(nstack) - xleft(nstack)
if (dx.gt.charf) return
!
!         Compute DTEST for the local error criterion
!
if (norm.eq.three) go to 30
if (edist-1) 10,20,30
10 dtest = dx*dsctol
go to 40
!         For the approximate fixed error distribution type we estimate
!         the final number of knots BY( LIMITING IT A LITTLE )
!             (NSTACK+KNOTS+2)((B-A)/(XRIGHT-A))
20 aknots = nstack+knots+2
dtest = dsctol/(aknots*dmin1((b-a)/(xright(nstack)-a),five))
go to 40
30 dtest = dsctol
!
!             Check for discard of interval
!
40 if (errori.le.dtest) discrd = .true.
return
end subroutine adchk

subroutine adput(xknots, coefs, kdimen, kmax, ndimen, ierr)
implicit none
integer :: ierr, kdimen, kmax, ndimen
integer :: k
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
! **  THIS PROGRAM PUTS INTERVALS ON THE STACK OR DISCARDS THEM.
!     When an interval is discarded a new knot is found. Then this
!     program updates the error estimate, the XKNOT array, transforms
!     the polynomial to the power form and put the coefficients into
!     the array COEFS.  It also checks for passing break points
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: xknots(kdimen), coefs(kmax,ndimen)
double precision :: dx, half, one, powers(20), p, ratio, three
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
data half,one,three/.5d0,1.d0,3.d0/
!
!            Check for discarding the interval
if (discrd) go to 30
!
!         Subdivide interval and place on stack
if (nstack.lt.maxstk) go to 10
!             Fatal error, exceeded active stack size
ierr = 4
dx = xright(nstack)-xleft(nstack)
if (dx.gt.charf) ierr = 3
return
!
10 dx = (xright(nstack)-xleft(nstack))*half
!              Check for small intervals
ratio = dx/(dabs(a)+dabs(b))
if (ratio.gt.buffer) go to 20
ierr = 4
return
!
20 nstack = nstack + 1
xleft(nstack) = xleft(nstack-1)
xleft(nstack-1) = xright(nstack-1) - dx
xright(nstack) = xleft(nstack-1)
return
!
!            Discard interval, update global error, XKNOTS and COEFS
30 p = dabs(norm)
if (norm.eq.three) error = dmax1(error,errori)
if (norm.ne.three) error = (error**p+errori)**(one/p)
!
!              Check for passing break points
if (break.eq.left .or. break.eq.both) ibreak = ibreak + 1
!
!             Transform representation of polynomial from divided
!             differences to powers of X with origin at XKNOTS (KNOTS)
call adtran(ddtemp, powers)
!
!             Put COEFS into the main array
do k=1,npar
  coefs(knots,k) = powers(k)
end do
!            Put the new knots in XKNOTS
knots = knots + 1
xknots(knots) = xright(nstack)
nstack = nstack - 1
return
end subroutine adput

subroutine adtran(d, powers)
implicit none
integer :: i, ii, j, k, khi, koef, l, ltop, ni, ni1, nl, nr, nri, &
&nri1, nrl, nrli, nrlk
integer :: leftx, nintrp
integer :: kntdim, level, nbreak, npardm
integer :: ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack
integer :: knots
!
!        ===============================================================
!
! **  THIS PROGRAM CONVERTS POLYNOMIAL REPRESENTATION FROM DIVIDED
!     difference to power form.  There are coalesced points on each
!     END OF THE INTERVAL (XL,XR) = (XLEFT(NSTACK),XRIGHT(NSTACK)).
!     The number coalesced at each end is LEFTX and RIGHTX.
!     And there are NINTRP other pts XINTRP(K)  inbetween them.
!     See subroutine NEWTON for more details
!
double precision :: a, accur, b, bleft(20), bright(20), charf, &
&ddtemp(20,20), dsctol, error, errori, factor(20), fintrp(18), &
&fleft(10), fright(10), norm, xbreak(20), xdd(20), xintrp(18), &
&xleft(50), xright(50), buffer
integer :: both, break, dbreak(20), degree, edist, right, rightx, &
&smooth
logical :: discrd
double precision :: d(20,*), powers(*), shift, xl, xr, xtemp(20)
!
common /inputz/ a, b, accur, norm, charf, xbreak, bleft, bright, &
&dbreak, degree, smooth, level, edist, nbreak, kntdim, npardm
common /resulz/ error, knots
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!
!         Set some short local variable names
!
xl = xleft(nstack)
xr = xright(nstack)
nl = leftx
nr = rightx
ni = nintrp
nrl = nr + nl
nri = nr + ni
nri1 = nri - 1
nrli = nrl + ni
!
!         STARTING REPRESENTATION IS (ASSUMING XL = 0 )
!
!    D(1) +D(2)X +D(3)X**2 + --- +D(NL)X**(NL-1)
!   +(X**NL)*( D(NL+1)(+D(NL+2)(X-XR)**2 + --- +D(NL+NR)*(X-XR)**(NR-1)
!        *((X-XR)**NR)*(D(NL+NR+1) + D(NL+NR+2)*(X-XINTRP(1))
!                      +D(NL+NR+3)*(X-XINTRP(1))(X-XINTRP(2)) + ---))
!
!         Strategy is to first convert the part from the INTERP. Pts.
!         To poly in (X-XR).  This poly then has origin shifted to XL.
!
!     THE CONVERSION OF THE INTERP PART IS DONE EXPLICITLY FOR DEGREE
!     TWO OR LESS AND DONE BY SYNTHETIC DIVISION FOR HIGHER DEGREES
!
!   D1 + D2(X-X1) +D3(X**2-(X1+X2)X +X1*X2)
!
!     The resulting coefficients are put in the array POWERS
!
if (ni.eq.0) go to 100
!
!             Build up the polynomial for the interpolation points
!
!         Use special formulas for NI less than 3
if (ni.eq.1) go to 10
if (ni.eq.2) go to 20
go to 30
10 powers(1) = d(nrl+1,1)
go to 80
20 powers(1) = d(nrl+1,1) + (xr-xintrp(1))*d(nrl+2,1)
powers(2) = d(nrl+2,1)
go to 80
!
!         CONVERSION BY REPEATED SYNTHETIC DIVISION
30 ni1 = ni - 1
!         Initialize the powers and XTEMP arrays
do k=1,ni
  xtemp(k) = xintrp(k)
  nrlk = nrl + k
  powers(k) = d(nrlk,1)
end do
!
!         Do the repeated synthetic division to replace the XTEMP
!         = XINTRP POINTS OF THE NEWTON EXPANSION BY THE XR POINTS
do 70 k = 1,ni1
!              POWERS(NI) is fixed and set above
  do 50 ii = 1,ni1
    i = ni - ii
    powers(i) = powers(i) + (xr-xtemp(i))*powers(i+1)
50 continue
!              Shift the Newton expansion pts. Up, put in one more XR
  do ii=1,ni1
    i = ni - ii
    xtemp(i+1) = xtemp(i)
  end do
  xtemp(1) = xr
70 continue
80 continue
!             Shift the coefficients to the top of the powers array
do k=1,ni
  l = ni + 1 - k
  ltop = l + nrl
  powers(ltop) = powers(l)
end do
!
!             Have the interpolation PT. COEFS. In the array POWERS
100 continue
!             Put the remaining divided diffs into the powers array
do j=1,nrl
  powers(j) = d(j,1)
end do
!
!         Transform the origin of the polynomial from XR to XL
!         we use repeated synthetic division
if (nri.eq.1) go to 140
shift = xr - xl
khi = nri1
!             Loop through the coefficients
do j=2,nri
!                   Synthetic division loop
  do k=1,khi
    koef = nrli - k
    powers(koef) = powers(koef) - shift*powers(koef+1)
  end do
  khi = khi - 1
end do
140 continue
!     The coefficients are now of the power form with origin XL
return
end subroutine adtran

subroutine cpsc (f, z, n, ic, tol, r, rs, err)
implicit none
integer, intent(in) :: ic, n
real, intent(inout) :: err(n), r
real, intent(in) :: tol
integer :: i, ia, inr, ip(32), iq, is, it, iw(7), ix, j, jn, kl, &
&km, kn, l, l1, l2, lf, ln, m, np, nr
real :: ang, b, c(4), cm, cp, ct, cx, ep6, eps, eps0, fac, fact, &
&fc(3), pi, r1, ra, re, sc(4), sf, sp, sr
real :: spmpar
!
!  Evaluation of complex power series coefficients or derivatives.
!
!  *** INPUT PARAMETERS ***
!    F   COMPLEX FUNCTION, OF WHICH THE COEFFICIENTS OR DERIVATIVES
!        are sought. This function must be declared external in the
!        calling program.
!    Z   COMPLEX POINT AROUND WHICH F IS TO BE EXPANDED OR AT WHICH
!        derivatives are to be evaluated.
!    N   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
!        N must be GE 1 and LE 51.
!    IC  selects between power series coefficients and derivatives.
!        IC .EQ. 0   ROUTINE RETURNS POWER SERIES COEFFICIENTS IN RS.
!        IC .NE. 0   ROUTINE RETURNS DERIVATIVES IN RS.
!    TOL estimated relative accuracy of F. It is assumed that TOL
!        IS NONNEGATIVE. IF TOL = 0 THEN F IS ASSUMED TO BE CORRECT
!        to machine accuracy.
!
!  *** INPUT AND OUTPUT PARAMETER ***
!    R   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
!        radius is left in R. The provided guess may be in error with at
!        most a factor of 3.E4 .
!
!  *** OUTPUT PARAMETERS ***
!    RS  complex array RS(N) containing the N first
!        coefficients (corresponding to the powers 0 to N-1) or deriva-
!        tives (orders 0 to N-1).
!    ERR real array ERR(N) containing absolute error estimates for the
!        numbers in RS.
!
complex :: f, a(64), v
complex, intent(inout) :: rs(n)
complex :: rt(51,3), fv(6), u, w, t, z, rv(3), rq, s, xk, mult, co
!
!  List of the variables initialized in the data statement below.
!   IW   2**( 0 , 1 , 2 , 3 , 4 , 5 , 6 ) .
!   IP   PERMUTATION CONSTANTS FOR THE FFT.
!   RV   CONSTANTS FOR THE LAURENT SERIES TEST.
!
data iw(1),iw(2),iw(3),iw(4),iw(5),iw(6),iw(7)/1,2,4,8,16,32,64/
data ip( 1),ip( 2),ip( 3),ip( 4),ip( 5),ip( 6),ip( 7),ip( 8), &
&ip( 9),ip(10),ip(11),ip(12),ip(13),ip(14),ip(15),ip(16), &
&ip(17),ip(18),ip(19),ip(20),ip(21),ip(22),ip(23),ip(24), &
&ip(25),ip(26),ip(27),ip(28),ip(29),ip(30),ip(31),ip(32)/ &
&64,32,48,16,56,24,40,8,60,28,44,12,52,20,36,4,62,30,46,14, &
&54,22,38,6,58,26,42,10,50,18,34,2/
data rv(1)/(-.4,.3)/, rv(2)/(.7,.2)/, rv(3)/(.02,-.06)/
!
!  Statement function for multiplication of a complex number
!  by a real number.
!
mult(re,co) = cmplx(re*real(co),re*aimag(co))
!
!  -------------------
!
!  ****** EPS0 IS A MACHINE DEPENDENT CONSTANT. EPS0 IS THE
!         SMALLEST NUMBER SUCH THAT 1 + EPS0 .GT. 1.
!
              eps0 = spmpar(1)
!
!  -------------------
!
!  Initialization.
!
eps = amax1(eps0,tol)
sc(1) = .125
c(1) = eps**(1./28.)
ep6 = c(1)**6
pi = 4.0*atan(1.0)
fv(1) = (-1.,0.)
fv(2) = (0.,-1.)
r1 = sqrt(0.5)
ra = 1.0/r1
fv(3) = cmplx(r1,-r1)
do 10 i = 2,4
  sc(i) = .5*sc(i-1)
  c(i) = sqrt(c(i-1))
  ang = pi*sc(i-1)
10 fv(i+2) = cmplx(cos(ang),-sin(ang))
!
!  Start execution.
!
if (n .gt. 51 .or. n .lt. 1) go to 260
l2 = 1
lf = 0
np = 0
m = 0
nr = -1
!
!  Find if A FFT over 8, 16, 32, or 64 points should be used.
!
kl = 1
if (n .gt. 6) kl = 2
if (n .gt. 12) kl = 3
if (n .gt. 25) kl = 4
km = kl + 2
kn = 7 - km
ix = iw(km + 1)
is = iw(kn)
30 v = cmplx(r,0.0)
!
!  Function values of F are stored ready permutated for the FFT.
!
do 40 i = is,32,is
  iq = ip(i)
  v = v*fv(km)
  a(iq) = f(z + v)
40 a(iq - 1) = f(z - v)
ln = 2
jn = 1
!
!  The loop  do 70 ... constitutes the FFT.
!
do 70 l = 1,km
  u = (1.,0.)
  w = fv(l)
  do 60 j = 1,jn
    do 50 i = j,ix,ln
      it = i + jn
      t = a(it)*u
      a(it) = a(i) - t
50 a(i) = a(i) + t
60 u = u*w
  ln = ln + ln
70 jn = jn + jn
cx = 0.0
b = 1.0
!
!  Test on how fast the coefficients obtained decrease.
!
do 80 i = 1,ix
  ct = cabs(a(i))/b
  if (ct .lt. cx) go to 80
  cx = ct
  inr = i
80 b = b*c(kl)
if (m .le. 1) go to 100
!
!  Estimate of the rounding error level for the last radius.
!
err(1) = cx*eps
do 90 i = 2,n
90 err(i) = err(i-1)/r
100 sf = sc(kl)
do 110 i = 1,ix
  a(i) = mult(sf,a(i))
110 sf = sf/r
l1 = l2
l2 = 1
if (inr .gt. iw(km)) go to 150
if (lf .eq. 1) go to 140
!
!  Test if the series is a Taylor or a Laurent series.
!
sr = 0.0
sp = 0.0
do 130 j = 1,3
  rq = mult(r,rv(j))
  s = a(ix)
  do 120 i = 2,ix
    ia = ix + 1 - i
120 s = s*rq + a(ia)
  cp = cabs(s)
  if (cp .gt. sp) sp = cp
  cm = cabs(s - f(z + rq))
130 if (cm .gt. sr) sr = cm
if (sr .gt. 1.e-3*sp) go to 150
lf = 1
140 l2 = -1
!
!  Determination of the next radius to be used.
!
150 if (nr .ge. 0) go to 160
  fact = 2.0
  if (l2 .eq. 1) fact = 0.5
  l1 = l2
  nr = 0
160 if (l1 .ne. l2) go to 180
  if (nr .gt. 0) go to 170
    np = np + 1
    if (np-15) 190,190,260
170 fact = 1.0/fact
180 fact = 1.0/sqrt(fact)
nr = nr + 1
190 r = r*fact
m = nr - kl - 1
if (m .le. 0) go to 30
!
!  The results for the last three radii are stored.
!
do 200 i = 1,n
200 rt(i,m) = a(i)
if (m .eq. 1) go to 220
!
!  Extrapolation.
!
do 210 i = 1,n
  xk = rt(i,m-1) - rt(i,m)
210 rt(i,m-1) = rt(i,m) - mult(fc(m-1),xk)
if (m .eq. 3) go to 230
!
!  Calculation of the extrapolation constants.
!
220 fc(m) = 1.5 + sign(.5,fact-1.)
if (m .eq. 2) fc(m) = fc(m) + ra
if (fact .gt. 1.0) fc(m) = -fc(m)
go to 30
230 fc(3) = fc(1)*fc(2)/(fc(1) + fc(2) + 1.0)
!
!  Final extrapolation and error estimate.
!
do 240 i = 1,n
  xk = rt(i,1) - rt(i,2)
  err(i) = err(i) + ep6*cabs(xk)
240 rs(i) = rt(i,2) - mult(fc(3),xk)
!
!  Multiply power series coefficients and error estimate by factorials
!  if derivatives wanted.
!
if (ic .eq. 0) return
fac = 0.0
fact = 1.0
do 250 i = 1,n
  rs(i) = mult(fact,rs(i))
  err(i) = fact*err(i)
  fac = fac + 1.0
250 fact = fact*fac
return
!
!  Error return.
!
260 do 270 i = 1,n
  rs(i) = (0.,0.)
270 err(i) = 1.e10
return
end subroutine cpsc

subroutine dcpsc (fun, x, y, n, ic, tol, r, rs1, rs2, err)
implicit none
integer, intent(in) :: ic, n
integer :: i, ia, inr, iq, is, it, ix, j, jn, kl, km, kn, l, l1, &
&l2, lf, ln, m, mm1, np, nr
double precision :: x, y
double precision, intent(in) :: tol
double precision, intent(inout) :: r, rs1(n), rs2(n), err(n)
!
!  Evaluation of complex power series coefficients or derivatives.
!
!  *** INPUT PARAMETERS ***
!    fun subroutine which computes the complex function F for which
!        the coefficients or derivatives are sought. We write
!                   CALL FUN(U1,U2,W1,W2)
!        WHEN W = F(U) IS TO BE COMPUTED FOR THE COMPLEX ARGUMENT U.
!        Here U1 and U2 are the real and imaginary parts of U, and W1
!        and W2 are the real and imaginary parts of W.  U1,U2,W1,W2
!        have double precision values. The subroutine FUN must be
!        declared in the calling program to be of type external.
!    X   REAL PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
!        expanded or at which its derivatives are to be computed.
!    Y   IMAGINARY PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
!        expanded or at which its derivatives are to be computed.
!    N   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
!        N must be GE 1 and LE 51.
!    IC  selects between power series coefficients and derivatives.
!        IC .EQ. 0   ROUTINE RETURNS POWER SERIES COEFFICIENTS IN
!                    RS1 AND RS2.
!        IC .NE. 0   ROUTINE RETURNS DERIVATIVES IN RS1 AND RS2.
!    TOL estimated relative accuracy of fun. It is assumed that TOL
!        IS NONNEGATIVE. IF TOL = 0 THEN FUN IS ASSUMED TO BE CORRECT
!        to machine accuracy.
!
!  *** INPUT AND OUTPUT PARAMETER ***
!    R   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
!        radius is left in R. The provided guess may be in error with at
!        most a factor of 3.E4 .
!
!  *** OUTPUT PARAMETERS ***
!    RS1 array RS1(N) containing the real parts of the first N complex
!        coefficients (corresponding to the powers 0 to N-1) or deriva-
!        tives (orders 0 to N-1).
!    RS2 array RS2(N) containing the imaginary parts of the first N
!        coefficients (corresponding to the powers 0 to N-1) or deriva-
!        tives (orders 0 to N-1).
!    ERR real array ERR(N) containing absolute error estimates for the
!        COMPLEX NUMBERS WHOSE REAL AND IMAGINARY PARTS ARE IN RS1,RS2.
!
integer :: ip(32), iw(7)
double precision :: ang, b, cm, cp, ct, cx, eps, eps0, ep6, fac, &
&fact, pi, ra, r1, s, sf, sp, sr, t, u, v, w
double precision :: c(4), fc(3), sc(4)
double precision :: a1(64), a2(64), fv1(6), fv2(6), rt1(51,3), &
&rt2(51,3), rv1(3), rv2(3)
double precision :: dcpabs, dpmpar
!
!  List of the variables initialized in the data statement below.
!   IW   2**( 0 , 1 , 2 , 3 , 4 , 5 , 6 ) .
!   IP   PERMUTATION CONSTANTS FOR THE FFT.
!   RV1  real parts of the constants for the Laurent series test.
!   RV2  imaginary parts of the constants for the Laurent series test.
!
data iw(1),iw(2),iw(3),iw(4),iw(5),iw(6),iw(7)/1,2,4,8,16,32,64/
data ip( 1),ip( 2),ip( 3),ip( 4),ip( 5),ip( 6),ip( 7),ip( 8), &
&ip( 9),ip(10),ip(11),ip(12),ip(13),ip(14),ip(15),ip(16), &
&ip(17),ip(18),ip(19),ip(20),ip(21),ip(22),ip(23),ip(24), &
&ip(25),ip(26),ip(27),ip(28),ip(29),ip(30),ip(31),ip(32)/ &
&64,32,48,16,56,24,40,8,60,28,44,12,52,20,36,4,62,30,46,14, &
&54,22,38,6,58,26,42,10,50,18,34,2/
data rv1(1)/-.4d0/, rv2(1)/.3d0/, &
&rv1(2)/ .7d0/, rv2(2)/.2d0/, &
&rv1(3)/.02d0/, rv2(3)/-.06d0/
!
!  -------------------
!
!  ****** EPS0 IS A MACHINE DEPENDENT CONSTANT. EPS0 IS THE
!         SMALLEST NUMBER SUCH THAT 1 + EPS0 .GT. 1.
!
              eps0 = dpmpar(1)
!
!  -------------------
!
!  Initialization.
!
eps = dmax1(eps0,tol)
sc(1) = .125d0
c(1) = eps**(1.d0/28.d0)
ep6 = c(1)**6
pi = 4.d0*datan(1.d0)
fv1(1) = -1.d0
fv2(1) =  0.d0
fv1(2) =  0.d0
fv2(2) = -1.d0
r1 = dsqrt(0.5d0)
ra = 1.d0/r1
fv1(3) =  r1
fv2(3) = -r1
do 10 i = 2,4
   sc(i) = 0.5d0*sc(i-1)
   c(i) = dsqrt(c(i-1))
   ang = pi*sc(i-1)
   fv1(i + 2) =  dcos(ang)
10 fv2(i + 2) = -dsin(ang)
!
!  Start execution.
!
if (n .gt. 51 .or. n .lt. 1) go to 260
l2 = 1
lf = 0
np = 0
m = 0
nr = -1
!
!  Find if A FFT over 8, 16, 32, or 64 points should be used.
!
kl = 1
if (n .gt. 6) kl = 2
if (n .gt. 12) kl = 3
if (n .gt. 25) kl = 4
km = kl + 2
kn = 7 - km
ix = iw(km + 1)
is = iw(kn)
30 u = r
v = 0.d0
!
!  Function values of F are stored ready permutated for the FFT.
!
do 40 i = is,32,is
   iq = ip(i)
   t = u*fv1(km) - v*fv2(km)
   v = u*fv2(km) + v*fv1(km)
   u = t
   call fun(x + u, y + v, a1(iq), a2(iq))
   call fun(x - u, y - v, a1(iq-1), a2(iq-1))
40 continue
ln = 2
jn = 1
!
!  The loop  do 70 ... constitutes the FFT.
!
do 70 l = 1,km
   u = 1.0
   v = 0.0
   do 60 j = 1,jn
      do 50 i = j,ix,ln
         it = i + jn
         s = u*a1(it) - v*a2(it)
         t = u*a2(it) + v*a1(it)
         a1(it) = a1(i) - s
         a2(it) = a2(i) - t
         a1(i) = a1(i) + s
50 a2(i) = a2(i) + t
      t = u*fv1(l) - v*fv2(l)
      v = u*fv2(l) + v*fv1(l)
60 u = t
   ln = ln + ln
70 jn = jn + jn
cx = 0.d0
b = 1.d0
!
!  Test on how fast the coefficients obtained decrease.
!
do 80 i = 1,ix
   ct = dcpabs(a1(i),a2(i))/b
   if (ct .lt. cx) go to 80
   cx = ct
   inr = i
80 b = b*c(kl)
if (m .le. 1) go to 100
!
!  Estimate of the rounding error level for the last radius.
!
err(1) = cx*eps
do 90 i = 2,n
90 err(i) = err(i-1)/r
!
100 sf = sc(kl)
do 110 i = 1,ix
   a1(i) = sf*a1(i)
   a2(i) = sf*a2(i)
110 sf = sf/r
l1 = l2
l2 = 1
if (inr .gt. iw(km)) go to 150
if (lf .eq. 1) go to 140
!
!  Test if the series is a Taylor or a Laurent series.
!
sr = 0.d0
sp = 0.d0
do 130 j = 1,3
   s = a1(ix)
   t = a2(ix)
   u = r*rv1(j)
   v = r*rv2(j)
   do 120 i = 2,ix
      ia = ix + 1 - i
      w = (s*u - t*v) + a1(ia)
      t = (s*v + t*u) + a2(ia)
120 s = w
   cp = dcpabs(s,t)
   if (cp .gt. sp) sp = cp
   call fun(x + u, y + v, u, v)
   cm = dcpabs(s - u, t - v)
130 if (cm .gt. sr) sr = cm
if (sr .gt. 1.d-3*sp) go to 150
lf = 1
140 l2 = -1
!
!  Determination of the next radius to be used.
!
150 if (nr .ge. 0) go to 160
   fact = 2.d0
   if (l2 .eq. 1) fact = 0.5d0
   l1 = l2
   nr = 0
160 if (l1 .ne. l2) go to 180
   if (nr .gt. 0) go to 170
      np = np + 1
      if (np-15) 190,190,260
170 fact = 1.d0/fact
180 fact = 1.d0/dsqrt(fact)
nr = nr + 1
190 r = r*fact
m = nr - kl - 1
if (m .le. 0) go to 30
!
!  The results for the last three radii are stored.
!
do 200 i = 1,n
   rt1(i,m) = a1(i)
200 rt2(i,m) = a2(i)
if (m .eq. 1) go to 220
!
!  Extrapolation.
!
mm1 = m - 1
do 210 i = 1,n
   u = rt1(i,mm1) - rt1(i,m)
   v = rt2(i,mm1) - rt2(i,m)
   rt1(i,mm1) = rt1(i,m) - fc(mm1)*u
210 rt2(i,mm1) = rt2(i,m) - fc(mm1)*v
if (m .eq. 3) go to 230
!
!  Calculation of the extrapolation constants.
!
220 fc(m) = 1.5d0 + dsign(0.5d0,fact-1.d0)
if (m .eq. 2) fc(m) = fc(m) + ra
if (fact .gt. 1.d0) fc(m) = -fc(m)
go to 30
230 fc(3) = fc(1)*fc(2)/(fc(1) + fc(2) + 1.d0)
!
!  Final extrapolation and error estimate.
!
do 240 i = 1,n
   u = rt1(i,1) - rt1(i,2)
   v = rt2(i,1) - rt2(i,2)
   err(i) = err(i) + ep6*dcpabs(u,v)
   rs1(i) = rt1(i,2) - fc(3)*u
240 rs2(i) = rt2(i,2) - fc(3)*v
!
!  Multiply power series coefficients and error estimate by factorials
!  if derivatives wanted.
!
if (ic .eq. 0) return
fac = 0.d0
fact = 1.d0
do 250 i = 1,n
   rs1(i) = fact*rs1(i)
   rs2(i) = fact*rs2(i)
   err(i) = fact*err(i)
   fac = fac + 1.d0
250 fact = fact*fac
return
!
!  Error return.
!
260 do 270 i = 1,n
   rs1(i) = 0.d0
   rs2(i) = 0.d0
270 err(i) = 1.d10
return
end subroutine dcpsc

function trp(a,n,x,y)
implicit none
integer, intent(in) :: n
real, intent(in) :: a
real :: x(n), y(n)
integer :: i, il, ir, nm1
real :: r
real :: trp
!
nm1 = n-1
if (a.lt.x(2)) go to 50
if (a.ge.x(nm1)) go to 40
il = 2
ir = nm1
!
!     Bisection search
!
10 i = (il+ir)/2
if (i.eq.il) go to 60
if (a-x(i)) 20,60,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     A.LT.X(2) .OR. A.GE.X(N-1)
!
40 i = nm1
go to 60
50 i = 1
!
!     Evaluation
!
60 r = (a-x(i))/(x(i+1)-x(i))
trp = y(i)+r*(y(i+1)-y(i))
return
end function trp

subroutine ltrp (m,x,y,n,xi,yi,ni,t,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n, ni
real, intent(inout) :: t(m)
real :: x(n), xi(ni), y(n)
real, intent(inout) :: yi(ni)
integer :: i, ii, il, ilm1, ilold, ipm, ir, istep, j, jmax, k, l, &
&mm1, num
real :: dl, dr, xx
!     ******************************************************************
!     Lagrange interpolation
!     ******************************************************************
!
!     Check input
!
if (m.lt.2) go to 130
if (m.gt.n) go to 131
if (ni.lt.1) go to 132
ierr = 0
!
!     Initialization
!
mm1 = m-1
k  = 1
xx = xi(1)
ilold = 0
!
!     FIND THE SUBINTERVAL WHICH CONTAINS XX. I = 1 IF XX.LT.X(2)
!     AND I = N IF XX.GE.X(N). OTHERWISE X(I).LE.XX.LT.X(I+1).
!
if (xx-x(1)) 10,11,20
10 i = 1
il = 1
ir = m
go to 80
11 i = 1
yi(k) = y(1)
go to 110
!
20 if (x(n)-xx) 21,22,23
21 i = n
il = n-m+1
ir = n
go to 80
22 i = n
yi(k) = y(n)
go to 110
23 il = 1
ir = n
!
!     Bisection search
!
30 i = (il+ir)/2
if (i.eq.il) go to 50
if (xx-x(i)) 31,32,33
31 ir = i
go to 30
32 yi(k) = y(i)
go to 110
33 il = i
go to 30
!
!     Linear forward search
!
40 if (xx-x(i+1)) 50,41,42
41 i = i+1
yi(k) = y(i)
go to 110
42 i = i+1
go to 40
!
!     Point XX lies in the open subinterval (X(I),X(I+1)).
!     Find the M closest points X(IL),...,X(IR) to XX.
!
50 if (i.gt.m) go to 51
il = 1
num = i
go to 60
51 il = i-m+1
num = m
!
60 ipm = i+m
if (ipm.le.n) go to 61
ir = n
num = num+n-i
go to 70
61 ir = ipm
num = num+m
!
70 num = num-m
if (num.eq.0) go to 80
dl = xx-x(il)
dr = x(ir)-xx
do 72 l = 1,num
if (dl.le.dr) go to 71
il = il+1
dl = xx-x(il)
go to 72
71 ir = ir-1
dr = x(ir)-xx
72 continue
!
!     Compute the coefficients T(1),...,T(M) of the backward
!     Newton form of the interpolating polynomial.
!
80 if (il.eq.ilold) go to 100
ilold = il
ilm1 = il-1
do 81 j = 1,m
l = ilm1+j
81 t(j) = y(l)
!
do istep=1,mm1
jmax = m-istep
do 90 j = 1,jmax
ii = ilm1+j
l = ii+istep
90 t(j) = (t(j)-t(j+1))/(x(ii)-x(l))
end do
!
!     Evaluation of the interpolating polynomial
!
100 yi(k) = t(1)
do 101 j = 2,m
l = ilm1+j
101 yi(k) = t(j)+yi(k)*(xx-x(l))
!
!     Next point
!
110 if (k.ge.ni) return
k = k+1
xx = xi(k)
if (xx-x(1)) 10,11,111
111 if (x(n)-xx) 21,22,120
!
120 if (xx-xi(k-1)) 121,122,40
121 il = 1
ir = min0(i+1,n)
go to 30
122 yi(k) = yi(k-1)
go to 110
!
!     Error return
!
130 ierr = 1
return
131 ierr = 2
return
132 ierr = 3
return
end subroutine ltrp

subroutine htrp (n,x,y,a,t,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(inout) :: a(n), t(n)
real :: x(n), y(n)
integer :: i, ibeg, iend, k
real :: diff, f, r
!     ******************************************************************
!     Hermite interpolation
!     ******************************************************************
if (n.le.0) go to 30
ierr = 0
a(1) = y(1)
if (n.eq.1) return
f = 1.0
r = 0.0
iend = 0
ibeg = 1
!
do 22 k = 2,n
if (x(k)-x(k-1)) 10,20,10
!
10 f = 1.0
r = 0.0
iend = k-1
ibeg = k
t(1) = y(k)
do 11 i = 1,iend
diff = x(i)-x(k)
if (diff) 11,31,11
11 t(i+1) = (a(i)-t(i))/diff
go to 22
!
20 r = r+1.0
f = f*r
t(1) = y(k)/f
if (iend.eq.0) go to 22
do 21 i = 1,iend
21 t(i+1) = (t(i+1)-t(i))/(x(i)-x(k))
22 a(k) = t(ibeg)
return
!
30 ierr = 1
return
31 ierr = 2
t(1) = i
t(2) = k
return
end subroutine htrp

subroutine pcoeff(alpha,n,x,a,c,t)
implicit none
integer, intent(in) :: n
real, intent(in) :: alpha
integer :: i, j, k, nm1
real, intent(in) :: x(*), a(n)
real, intent(inout) :: c(n)
double precision :: xx, r
double precision, intent(inout) :: t(n)
if (n.gt.1) go to 10
c(1) = a(1)
return
!
10 xx = alpha
nm1 = n-1
do 11 i = 1,n
11 t(i) = a(i)
!
do i=1,nm1
j = n-i
r = xx-dble(x(j))
do 20 k = j,nm1
20 t(k) = t(k)+r*t(k+1)
end do
!
do 30 i = 1,n
30 c(i) = t(i)
return
end subroutine pcoeff

subroutine pfit(nd,np,x,y,a,rnorm,phi,phix,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: nd, np
real, intent(inout) :: rnorm
integer :: k, la, lb, ls, m, mp1, nd1
real :: alpha, c, temp, xmax, xmin, za, zb
!     ******************************************************************
!     Unweighted least squares polynomial fit
!     ******************************************************************
real, intent(in) :: x(np), y(np)
real, intent(inout) :: a(*), phi(2,*), phix(4,np)
real :: lambda
double precision :: dalpha, dsum
!     ---------------------
ierr=0
if (1.le.nd.and.nd.lt.np) go to 10
ierr=1
return
!
!                      Initialization
!
10 nd1=nd+1
do 11 k = 1,nd1
a(k)=0.0
phi(1,k)=0.0
11 phi(2,k)=0.0
!
!                SET Z=A+B*X WHERE ABS(Z).LE.1
!
xmin=x(1)
xmax=x(1)
do 21 k = 2,np
if (x(k).ge.xmin) go to 20
xmin=x(k)
go to 21
20 if (x(k).gt.xmax) xmax=x(k)
21 continue
zb=2.0/(xmax-xmin)
za=-xmin*zb-1.0
do 22 k = 1,np
22 phix(3,k)=za+zb*x(k)
!
!           Compute the closest polynomial of degree 0
!
lambda=np
phi(1,1)=1.0/sqrt(lambda)
dalpha=0.d0
dsum=0.d0
do 30 k = 1,np
phix(1,k)=phi(1,1)
dalpha=dalpha+dble(phix(3,k))
30 dsum=dsum+dble(y(k))
alpha=sngl(dalpha)/lambda
a(1)=sngl(dsum)/lambda
do 31 k = 1,np
31 phix(4,k)=a(1)
!
la=2
lb=1
do 90 m = 1,nd
mp1=m+1
!
!          Generate LAMBDA(M)*PHI(M) and evaluate it at Z
!
if (m.ne.1) go to 50
phi(2,1)=-alpha*phi(1,1)
phi(2,2)=phi(1,1)
do 40 k = 1,np
40 phix(2,k)=(phix(3,k)-alpha)*phi(1,1)
go to 60
!
50 c=0.0
do 51 k = 1,m
phi(la,k)=dble(c)-dble(alpha*phi(lb,k))-dble(lambda*phi(la,k))
51 c=phi(lb,k)
phi(la,mp1)=c
do 52 k = 1,np
52 phix(la,k)=(phix(3,k)-alpha)*phix(lb,k)-lambda*phix(la,k)
!
!                Compute ALPHA(M) and LAMBDA(M)
!
60 dalpha=0.d0
dsum=0.d0
do 61 k = 1,np
c=phix(la,k)*phix(la,k)
dalpha=dalpha+dble(c*phix(3,k))
61 dsum=dsum+dble(c)
lambda=dsum
alpha=sngl(dalpha)/lambda
lambda=sqrt(lambda)
!
!              Generate PHI(M) and evaluate it at Z
!
do 70 k = 1,mp1
70 phi(la,k)=phi(la,k)/lambda
do 71 k = 1,np
71 phix(la,k)=phix(la,k)/lambda
!
!        Compute the closest polynomial of degree M or less
!                     and evaluate it at Z
!
dsum=0.d0
do 80 k = 1,np
80 dsum=dsum+dble((y(k)-phix(4,k))*phix(la,k))
c=dsum
do 81 k = 1,mp1
81 a(k)=a(k)+c*phi(la,k)
do 82 k = 1,np
82 phix(4,k)=phix(4,k)+c*phix(la,k)
!
ls=la
la=lb
90 lb=ls
!
!                        Compute RNORM
!
dsum=0.d0
do 95 k = 1,np
95 dsum=dsum+dble((y(k)-phix(4,k))**2)
rnorm=sqrt(sngl(dsum))
!
!        Convert the closest polynomial from a polynomial
!                  in Z to a polynomial in X
!
a(1)=a(1)+za*a(2)
a(2)=zb*a(2)
if (nd.eq.1) return
phi(1,1)=za
phi(1,2)=zb
do 102 m = 2,nd
mp1=m+1
c=0.0
do 100 k = 1,m
temp=phi(1,k)*zb
phi(1,k)=phi(1,k)*za+c
100 c=temp
phi(1,mp1)=c
do 101 k = 1,m
101 a(k)=a(k)+a(mp1)*phi(1,k)
102 a(mp1)=a(mp1)*phi(1,mp1)
return
end subroutine pfit

subroutine wpfit(nd,np,x,y,w,a,rnorm,phi,phix,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: nd, np
real, intent(inout) :: rnorm
integer :: k, la, lb, ls, m, mp1, nd1, nw
real :: alpha, c, temp, xmax, xmin, za, zb
!     ******************************************************************
!     Weighted least squares polynomial fit
!     ******************************************************************
real, intent(in) :: x(np), y(np), w(np)
real, intent(inout) :: a(*), phi(2,*), phix(4,np)
real :: lambda
double precision :: dalpha, dsum
!     ---------------------
!
!                      Error checking
!
if (nd.lt.1.or.np.lt.2) go to 200
nw=0
dsum=0.d0
do 13 k = 1,np
if (w(k)) 202,13,10
10 nw=nw+1
dsum=dsum+dble(w(k))
if (nw.gt.1) go to 11
xmin=x(k)
xmax=x(k)
go to 13
11 if (x(k).ge.xmin) go to 12
xmin=x(k)
go to 13
12 if (x(k).gt.xmax) xmax=x(k)
13 continue
if (nd.ge.nw) go to 200
!
!                      Initialization
!
ierr=0
nd1=nd+1
do 20 k = 1,nd1
a(k)=0.0
phi(1,k)=0.0
20 phi(2,k)=0.0
!
!                SET Z=A+B*X WHERE ABS(Z).LE.1
!
zb=2.0/(xmax-xmin)
za=-xmin*zb-1.0
do 25 k = 1,np
25 phix(3,k)=za+zb*x(k)
!
!           Compute the closest polynomial of degree 0
!
lambda=dsum
phi(1,1)=1.0/sqrt(lambda)
dalpha=0.d0
dsum=0.d0
do 30 k = 1,np
phix(1,k)=phi(1,1)
dalpha=dalpha+dble(w(k)*phix(3,k))
30 dsum=dsum+dble(w(k)*y(k))
alpha=sngl(dalpha)/lambda
a(1)=sngl(dsum)/lambda
do 31 k = 1,np
31 phix(4,k)=a(1)
!
la=2
lb=1
do 90 m = 1,nd
mp1=m+1
!
!          Generate LAMBDA(M)*PHI(M) and evaluate it at Z
!
if (m.ne.1) go to 50
phi(2,1)=-alpha*phi(1,1)
phi(2,2)=phi(1,1)
do 40 k = 1,np
40 phix(2,k)=(phix(3,k)-alpha)*phi(1,1)
go to 60
!
50 c=0.0
do 51 k = 1,m
phi(la,k)=dble(c)-dble(alpha*phi(lb,k))-dble(lambda*phi(la,k))
51 c=phi(lb,k)
phi(la,mp1)=c
do 52 k = 1,np
52 phix(la,k)=(phix(3,k)-alpha)*phix(lb,k)-lambda*phix(la,k)
!
!                Compute ALPHA(M) and LAMBDA(M)
!
60 dalpha=0.d0
dsum=0.d0
do 61 k = 1,np
c=w(k)*phix(la,k)*phix(la,k)
dalpha=dalpha+dble(c*phix(3,k))
61 dsum=dsum+dble(c)
lambda=dsum
alpha=sngl(dalpha)/lambda
lambda=sqrt(lambda)
!
!              Generate PHI(M) and evaluate it at Z
!
do 70 k = 1,mp1
70 phi(la,k)=phi(la,k)/lambda
do 71 k = 1,np
71 phix(la,k)=phix(la,k)/lambda
!
!        Compute the closest polynomial of degree M or less
!                     and evaluate it at Z
!
dsum=0.d0
do 80 k = 1,np
80 dsum=dsum+dble(w(k)*(y(k)-phix(4,k))*phix(la,k))
c=dsum
do 81 k = 1,mp1
81 a(k)=a(k)+c*phi(la,k)
do 82 k = 1,np
82 phix(4,k)=phix(4,k)+c*phix(la,k)
!
ls=la
la=lb
90 lb=ls
!
!                        Compute RNORM
!
dsum=0.d0
do 95 k = 1,np
95 dsum=dsum+dble(w(k)*(y(k)-phix(4,k))**2)
rnorm=sqrt(sngl(dsum))
!
!        Convert the closest polynomial from a polynomial
!                  in Z to a polynomial in X
!
a(1)=a(1)+za*a(2)
a(2)=zb*a(2)
if (nd.eq.1) return
phi(1,1)=za
phi(1,2)=zb
do 102 m = 2,nd
mp1=m+1
c=0.0
do 100 k = 1,m
temp=phi(1,k)*zb
phi(1,k)=phi(1,k)*za+c
100 c=temp
phi(1,mp1)=c
do 101 k = 1,m
101 a(k)=a(k)+a(mp1)*phi(1,k)
102 a(mp1)=a(mp1)*phi(1,mp1)
return
!
!                        Error return
!
200 ierr=1
return
202 ierr=3
return
end subroutine wpfit

subroutine cbspl (x, y, a, b, c, n, ibeg, iend, alpha, beta, ierr)
implicit none
integer, intent(in) :: ibeg, iend
integer, intent(inout) :: ierr
integer, intent(in) :: n
real, intent(in) :: alpha, beta
integer :: i, j, m, nm1
real :: del, h, r, t
!-----------------------------------------------------------------------
!                   Cubic spline interpolation
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n)
real, intent(inout) :: a(n), b(n), c(n)
!
if (n .lt. 3) go to 200

!     A tridiagonal linear system for the unknown slopes S(I) of
!     F AT X(I), I=1,...,N, IS GENERATED AND THEN SOLVED BY GAUSS
!     elimination, with S(I) ending up in A(I) for all I. A, B, C
!     are used initially for work spaces.
!
do m = 2,n
   b(m) = x(m) - x(m-1)
   if (b(m) .le. 0.0) go to 210
   c(m) = (y(m) - y(m-1))/b(m)
end do
ierr = 0
!
!     Construct the first equation from the boundary condition, of
!     the form
!
!             C(1)*S(1) + B(1)*S(2) = A(1)
!
if (ibeg - 1) 20,30,40
!
!     No condition at left end.
!
20 c(1) = b(3)
b(1) = x(3) - x(1)
a(1) = ((b(2) + 2.0*b(1))*b(3)*c(2) + b(2)*b(2)*c(3))/b(1)
go to 50
!
!     Slope prescribed at left end.
!
30 c(1) = 1.0
b(1) = 0.0
a(1) = alpha
go to 50
!
!     Second derivative prescribed at left end.
!
40 c(1) = 2.0
b(1) = 1.0
a(1) = 3.0*c(2) - 0.5*alpha*b(2)
!
!     For the interior knots, generate the corresponding equations and
!     carry out the forward pass of Gauss elimination, after which the
!     M-TH EQUATION READS  C(M)*S(M) + B(M)*S(M+1) = A(M).
!
50 nm1 = n - 1
do m = 2,nm1
   t = -b(m+1)/c(m-1)
   a(m) = t*a(m-1) + 3.0*(b(m)*c(m+1) + b(m+1)*c(m))
   c(m) = t*b(m-1) + 2.0*(b(m) + b(m+1))
end do
!
!     If the slope at the right end is given, then set A(N) to the
!     slope and go to back substitution. Otherwise, construct the
!     last equation from the second boundary condition, of the form
!
!                R*S(N-1) + C(N)*S(N) = A(N)
!
if (iend - 1) 60,80,90
60 if (n .eq. 3 .and. ibeg .eq. 0) go to 70
!
!     NO CONDITION AT THE RIGHT END. EITHER  N .GE. 4  OR
!     there is a condition at the left end.
!
r = x(n) - x(n-2)
del  = (y(nm1) - y(n-2))/b(nm1)
a(n) = ((b(n) + 2.0*r)*b(nm1)*c(n) + b(n)*b(n)*del)/r
c(n) = b(nm1)
go to 100
!
!     NO CONDITIONS AT THE END POINTS AND N = 3. IN THIS CASE,
!     the second boundary condition does not provide us with A
!     new equation. For convenience, we use the following...
!
70 a(n) = 2.0*c(n)
c(n) = 1.0
r = 1.0
go to 100
!
!     Slope prescribed at right end.
!
80 a(n) = beta
go to 110
!
!     Second derivative prescribed at right end.
!
90 a(n) = 3.0*c(n) + 0.5*beta*b(n)
c(n) = 2.0
r = 1.0
!
!     Complete forward pass of Gauss elimination.
!
100 t = -r/c(nm1)
a(n) = (t*a(nm1) + a(n))/(t*b(nm1) + c(n))
!
!     Carry out back substitution.
!
110 do i = 1,nm1
   j = n - i
   a(j) = (a(j) - b(j)*a(j+1))/c(j)
end do
!
!     Generate the cubic coefficients B(I) and C(I).
!
do i = 1,nm1
   h = b(i+1)
   del = (y(i+1) - y(i))/h
   t = a(i) + a(i+1) - 2.0*del
   b(i) = (del - a(i) - t)/h
   c(i) = (t/h)/h
end do
return
!
!     Error return
!
200 ierr = 1
return
210 ierr = 2
return
end subroutine cbspl

subroutine splift (x,y,yp,ypp,n,w,ierr,isx,a1,b1,an,bn)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: isx, n
real, intent(in) :: a1, an, b1, bn
integer :: i, j, nm1, nm2
real :: dnew, dold, h
!
!     WRITTEN BY RONDALL E. JONES
!        SANDIA LABORATORIES
!        ALBUQUERQUE, NEW MEXICO  87115
!        JANUARY 1976
!
!     Abstract
!         SPLIFT fits an interpolating cubic spline to the N data points
!         given in X and Y and returns the first and second derivatives
!         in YP and YPP.
!
!     Description of arguments
!
!       --Input--
!
!         X    - ARRAY OF ABSCISSAS OF DATA (IN INCREASING ORDER)
!         Y    - ARRAY OF ORDINATES OF DATA
!         N    - THE NUMBER OF DATA POINTS.  THE ARRAYS X, Y, YP, AND
!                YPP MUST BE DIMENSIONED AT LEAST N.  (N .GE. 4)
!         ISX  - must be zero on the initial call to SPLIFT.
!                If a spline is to be fitted to a second set of data
!                that has the same set of abscissas as a previous set,
!                and if the contents of W have not been changed since
!                that previous fit was computed, then ISX may be
!                set to one for faster execution.
!         A1,B1,an,BN - specify the end conditions for the spline which
!                are expressed as constraints on the second derivative
!                of the spline at the end points (see YPP).
!                The end condition constraints are
!                        YPP(1) = A1*YPP(2) + B1
!                and
!                        YPP(N) = AN*YPP(N-1) + BN
!                where
!                        ABS(A1).LT. 1.0  AND  ABS(AN).LT. 1.0.
!
!                The smoothest spline (I.E., Least integral of square
!                OF SECOND DERIVATIVE) IS OBTAINED BY A1=B1=AN=BN=0.
!                In this case there is an inflection at X(1) and X(N).
!                If the data is to be extrapolated (say, by using splint
!                to evaluate the spline outside the range X(1) to X(N)),
!                THEN TAKING A1=AN=0.5 AND B1=BN=0 MAY YIELD BETTER
!                results.  In this case there is an inflection
!                at X(1) - (X(2)-X(1)) and at X(N) + (X(N)-X(N-1)).
!                IN THE MORE GENERAL CASE OF A1=AN=A  AND B1=BN=0,
!                there is an inflection at X(1) - (X(2)-X(1))*A/(1.0-A)
!                and at X(N) + (X(N)-X(N-1))*A/(1.0-A).
!
!                A spline that has a given first derivative YP1 at X(1)
!                and YPN at Y(N) may be defined by using the
!                following conditions.
!
!                A1=-0.5
!
!                B1= 3.0*((Y(2)-Y(1))/(X(2)-X(1))-YP1)/(X(2)-X(1))
!
!                AN=-0.5
!
!                BN=-3.0*((Y(N)-Y(N-1))/(X(N)-X(N-1))-YPN)/(X(N)-X(N-1))
!
!       --Output--
!
!         YP   - ARRAY OF FIRST DERIVATIVES OF SPLINE (AT THE X(I))
!         YPP  - array of second derivatives of spline (at the X(I))
!         IERR - a status code
!              --normal code
!                 0 means that the requested spline was computed.
!              --Abnormal codes
!                 1 MEANS THAT ABS(A1) OR ABS(AN) WAS .GE. 1.
!                 2 MEANS THAT N, THE NUMBER OF POINTS, WAS .LT. 4.
!                 3 Means the abscissas were not strictly increasing.
!
!       --Work--
!
!         W    - ARRAY OF WORKING STORAGE DIMENSIONED AT LEAST 3N.
!
real, intent(in) :: x(n), y(n)
real, intent(inout) :: yp(n), ypp(n), w(n,3)
!
if (abs(a1) .ge. 1.0 .or. abs(an) .ge. 1.0) go to 100
if (n .lt. 4) go to 200
nm1 = n - 1
nm2 = n - 2
if (isx .gt. 0) go to 40
do 10 i = 2,n
   if (x(i) .le. x(i-1)) go to 300
10 continue
!
!     Define the tridiagonal matrix
!
w(1,3) = x(2) - x(1)
do 20 i = 2,nm1
   w(i,2) = w(i-1,3)
   w(i,3) = x(i+1) - x(i)
   w(i,1) = 2.0*(w(i,2) + w(i,3))
20 continue
w(1,1) = 4.0
w(1,3) =-4.0*a1
w(n,1) = 4.0
w(n,2) =-4.0*an
!
!     LU decomposition
!
do 30 i = 2,n
   w(i-1,3) = w(i-1,3)/w(i-1,1)
   w(i,1)   = w(i,1) - w(i,2)*w(i-1,3)
30 continue
!
!     Define *constant* vector
!
40 ypp(1) = 4.0*b1
dold = (y(2) - y(1))/w(2,2)
do 50 i = 2,nm2
   dnew   = (y(i+1) - y(i))/w(i+1,2)
   ypp(i) = 6.0*(dnew - dold)
   yp(i)  = dold
   dold   = dnew
50 continue
dnew = (y(n) - y(nm1))/(x(n) - x(nm1))
ypp(nm1) = 6.0*(dnew - dold)
ypp(n) = 4.0*bn
yp(nm1)= dold
yp(n)  = dnew
!
!     Forward substitution
!
ypp(1) = ypp(1)/w(1,1)
do 60 i = 2,n
   ypp(i) = (ypp(i) - w(i,2)*ypp(i-1))/w(i,1)
60 continue
!
!     Backward substitution
!
do 70 j = 1,nm1
   i = n - j
   ypp(i) = ypp(i) - w(i,3)*ypp(i+1)
70 continue
!
!     Compute first derivatives
!
h = x(2) - x(1)
yp(1) = (y(2) - y(1))/h - h*(2.0*ypp(1) + ypp(2))/6.0
do 80 i = 2,nm1
   yp(i) = yp(i) + w(i,2)*(ypp(i-1) + 2.0*ypp(i))/6.0
80 continue
yp(n) = yp(n) + (x(n) - x(nm1))*(ypp(nm1) + 2.0*ypp(n))/6.0
ierr = 0
return
!
100 ierr = 1
return
200 ierr = 2
return
300 ierr = 3
return
end subroutine splift

subroutine spfit (x, y, wgt, m, break, l, z, a, b, c, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m
integer :: j, k, la, lm1, lq, lw, n
!-----------------------------------------------------------------------
!            Weighted least squares cubic spline fitting
!-----------------------------------------------------------------------
real, intent(in) :: x(m), y(m), wgt(m)
real, intent(inout) :: break(l)
real, intent(inout) :: z(*), a(*), b(*), c(*), wk(*)
real :: temp(20)
!---------------------
!     REAL Z(L-1), A(L-1), B(L-1), C(L-1), WK(7*L + 18)
!---------------------
if (l .lt. 2) go to 100
n = l + 2
!
!                Define the knots for the B-splines
!
wk(1) = break(1)
wk(2) = break(1)
wk(3) = break(1)
wk(4) = break(1)
do j = 2,l
   if (break(j - 1) .ge. break(j)) go to 110
   wk(j + 3) = break(j)
end do
wk(l + 4) = break(l)
wk(l + 5) = break(l)
wk(l + 6) = break(l)
!
!     Obtain the B-spline coefficients of the least squares fit
!
la = n + 5
lw = la + n
lq = lw + n
call bslsq (x, y, wgt, m, wk(1), n, 4, wk(la), &
&wk(lw), wk(lq), ierr)
if (ierr .lt. 0) go to 120
ierr = 0
!
!     Obtain the coefficients of the fit in Taylor series form
!
call bspp (wk(1), wk(la), n, 4, break, &
&wk(lq), lm1, temp)
k = lq
do 20 j = 1,lm1
   z(j) = wk(k)
   a(j) = wk(k + 1)
   b(j) = wk(k + 2)
   c(j) = wk(k + 3)
   k = k + 4
20 continue
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
end subroutine spfit

subroutine cspfit (x, y, m, break, l, xcon, con, nder, nc, &
&z, a, b, c, wk, iwk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, nc
integer :: j, k, la, lm1, lw, n
real :: r
!-----------------------------------------------------------------------
!                Least squares cubic spline fitting with
!                  equality and inequality constraints
!-----------------------------------------------------------------------
real, intent(in) :: x(m), y(m)
real, intent(inout) :: break(l)
real, intent(in) :: xcon(*), con(*)
real, intent(inout) :: z(*), a(*), b(*), c(*), wk(*)
integer, intent(in) :: nder(*)
integer, intent(inout) :: iwk(*)
!
real :: temp(20)
!---------------------
!     XCON, con, NDER are arrays of dimension MAX(1,NC).
!     Z, A, B, C are arrays of dimension L - 1.
!     WK and IWK are arrays of dimension IWK(1) and IWK(2)
!        RESPECTIVELY. IT IS REQUIRED THAT IWK(2) .GE. 2
!        AND IWK(1) .GE. 7(L + 7) FOR ALL NC. IF NC .GE. 1
!        then more storage will be needed.
!---------------------
if (l .lt. 2) go to 100
n = l + 2
!
!                Define the knots for the B-splines
!
wk(1) = break(1)
wk(2) = break(1)
wk(3) = break(1)
wk(4) = break(1)
do j = 2,l
   if (break(j - 1) .ge. break(j)) go to 110
   wk(j + 3) = break(j)
end do
wk(l + 4) = break(l)
wk(l + 5) = break(l)
wk(l + 6) = break(l)
!
!     Obtain the B-spline coefficients of the least squares fit
!
k = 7*n + 35
if (iwk(1) .lt. k) go to 120
la = n + 5
lw = la + n
ierr = 0
!
k = lw - 1
iwk(1) = iwk(1) - k
call bfit (wk(1), n, 4, x, y, m, xcon, con, nder, nc, ierr, &
&wk(la), r, wk(lw), iwk)
iwk(1) = iwk(1) + k
if (ierr .lt. 0 .or. ierr .eq. 2) return
!
!     Obtain the coefficients of the fit in Taylor series form
!
call bspp (wk(1), wk(la), n, 4, break, &
&wk(lw), lm1, temp)
k = lw
do 20 j = 1,lm1
   z(j) = wk(k)
   a(j) = wk(k + 1)
   b(j) = wk(k + 2)
   c(j) = wk(k + 3)
   k = k + 4
20 continue
return
!
!                       Error return
!
100 ierr = -1
return
!
110 ierr = -3
return
!
120 ierr = -6
iwk(1) = k
return
end subroutine cspfit

subroutine scomp (x,y,a,b,c,n,xi,yi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
integer :: i, il, ir, k
real :: dx, xx
!
!     Abstract
!
!         SCOMP evaluates a cubic spline at the abscissas in xi.
!         It is assumed that the coefficients of the polynomials
!         which form the spline are provided.
!
!     Description of arguments
!
!       --Input--
!
!         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!               that define the spline.
!         Y   - ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!         A,B,C arrays that contain the coefficients of the polynomials
!               WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
!               has the value
!                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
!               FOR X(I) .LE. XX .LE. X(I+1).  HERE DX = XX-X(I).
!         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
!               The arrays X, Y, A, B, C  must be dimensioned at
!               least N.  N must be greater than or equal to 1.
!         Xi  - the abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         NI  - the number of abscissas at which the spline is to be
!               evaluated.  If NI is greater than 1 then xi and YI
!               must be arrays of dimension NI or larger.
!               It is assumed that NI is greater than or equal to 1.
!
!       --Output--
!
!         YI  - array of values of the spline (ordinates) at xi.
!         IERR- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - NI is not positive.
!
real, intent(in) :: x(n), y(n), a(n), b(n), c(n), xi(ni)
real, intent(inout) :: yi(ni)
!
!     Check input
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
!
!     K is index on value of xi being worked on.  XX is that value.
!     I is current index into X array.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
il = 1
ir = n
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX is greater than X(N) or less than X(1)
!
80 i = n
go to 100
90 i = 1
!
!     Evaluation
!
100 dx = xx - x(i)
yi(k) = y(i) + dx*(a(i) + dx*(b(i) + dx*c(i)))
!
!     Next point
!
if (k .ge. ni) return
k = k + 1
xx = xi(k)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
if (xx - xi(k-1)) 110,100,50
110 il = 1
ir = min0(i+1,n)
go to 10
end subroutine scomp

subroutine scomp1 (x,y,yp,n,xi,yi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
integer :: i, il, ir, k, nm1
real :: a, b, c, d, dx, h, xx
!
!     Abstract
!
!         SCOMP1 evaluates a cubic spline at the abscissas in xi.
!         It is assumed that the first derivatives at the nodes
!         have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               spline.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YP  - array of first derivatives that define the spline.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               The arrays X, Y, and YP must be dimensioned at least N.
!               N must be greater than or equal to 2.
!         Xi  - the abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         NI  - the number of abscissas at which the spline is to be
!               evaluated.  If NI is greater than 1 then xi and YI
!               must be arrays of dimension NI or larger.
!               It is assumed that NI is greater than or equal to 1.
!
!       --Output--
!
!         YI  - array of values of the spline (ordinates) at xi.
!         IERR- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - NI is not positive.
!
real, intent(in) :: x(n), y(n), yp(n), xi(ni)
real, intent(inout) :: yi(ni)
!
!     Check input
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K is index on value of xi being worked on.  XX is that value.
!     I is current index into X array.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX is greater than X(N) or less than X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h = x(i+1) - x(i)
d = (y(i+1) - y(i))/h
a = yp(i) + yp(i+1)
b = (-a - yp(i) + 3.0*d)/h
c = (a - d - d)/(h*h)
dx = xx - x(i)
yi(k) = y(i) + dx*(yp(i) + dx*(b + dx*c))
!
!     Next point
!
if (k .ge. ni) return
k = k + 1
xx = xi(k)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
if (xx - xi(k-1)) 110,100,50
110 il = 1
ir = min0(i+1,nm1)
go to 10
end subroutine scomp1

subroutine scomp2 (x,y,ypp,n,xi,yi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
integer :: i, il, ir, k, nm1
real :: h, h2, xl, xl2, xl3, xr, xr2, xr3, xx
!
!     Abstract
!
!         SCOMP2 evaluates a cubic spline at the abscissas in xi.
!         It is assumed that the second derivatives at the nodes
!         have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               spline.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YPP - array of second derivatives that define the spline.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               The arrays X, Y, and YPP must be dimensioned at least N.
!               N must be greater than or equal to 2.
!         Xi  - the abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         NI  - the number of abscissas at which the spline is to be
!               evaluated.  If NI is greater than 1 then xi and YI
!               must be arrays of dimension NI or larger.
!               It is assumed that NI is greater than or equal to 1.
!
!       --Output--
!
!         YI  - array of values of the spline (ordinates) at xi.
!         IERR- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - NI is not positive.
!
real, intent(in) :: x(n), y(n), ypp(n), xi(ni)
real, intent(inout) :: yi(ni)
!
!     Check input
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K is index on value of xi being worked on.  XX is that value.
!     I is current index into X array.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX is greater than X(N) or less than X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h  = x(i+1) - x(i)
h2 = h*h
xr = (x(i+1) - xx)/h
xr2 = xr*xr
xr3 = xr*xr2
xl = (xx - x(i))/h
xl2 = xl*xl
xl3 = xl*xl2
yi(k) = y(i)*xr + y(i+1)*xl &
&- h2*(ypp(i)*(xr-xr3) + ypp(i+1)*(xl-xl3))/6.0
!
!     Next point
!
if (k .ge. ni) return
k = k + 1
xx = xi(k)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
if (xx - xi(k-1)) 110,100,50
110 il = 1
ir = min0(i+1,nm1)
go to 10
end subroutine scomp2

subroutine seval (x,y,a,b,c,n,xi,yi,ypi,yppi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
integer :: i, il, ir, k
real :: bi, ci, dx, xx
!
!     Abstract
!
!         SEVAL evaluates a cubic spline and its first and second
!         derivatives at the abscissas in xi.  It is assumed that
!         the coefficients of the polynomials which form the spline
!         are provided.
!
!     Description of arguments
!
!       --Input--
!
!         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!               that define the spline.
!         Y   - ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!         A,B,C arrays that contain the coefficients of the polynomials
!               WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
!               has the value
!                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
!               FOR X(I) .LE. XX .LE. X(I+1).  HERE DX = XX-X(I).
!         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
!               The arrays X, Y, A, B, C  must be dimensioned at
!               least N.  N must be greater than or equal to 1.
!         Xi  - the abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         NI  - the number of abscissas at which the spline is to be
!               evaluated.  If NI is greater than 1, then xi, YI, YPI,
!               and YPPI must be arrays dimensioned at least NI.
!               NI must be greater than or equal to 1.
!
!       --Output--
!
!         YI  - array of values of the spline (ordinates) at xi.
!         YPI - array of values of the first derivative of spline at xi.
!         YPPI- array of values of second derivatives of spline at xi.
!         IERR- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - NI is not positive.
!
real, intent(in) :: x(n), y(n), a(n), b(n), c(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
!
!     Check input
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
!
!     K is index on value of xi being worked on.  XX is that value.
!     I is current index into X array.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
il = 1
ir = n
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX is greater than X(N) or less than X(1)
!
80 i = n
go to 100
90 i = 1
!
!     Evaluation
!
100 dx = xx - x(i)
yi(k) = y(i) + dx*(a(i) + dx*(b(i) + dx*c(i)))
bi = b(i) + b(i)
ci = 3.0*c(i)
ypi(k) = a(i) + dx*(bi + dx*ci)
yppi(k) = bi + dx*(ci + ci)
!
!     Next point
!
if (k .ge. ni) return
k = k + 1
xx = xi(k)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
if (xx - xi(k-1)) 110,100,50
110 il = 1
ir = min0(i+1,n)
go to 10
end subroutine seval

subroutine seval1 (x,y,yp,n,xi,yi,ypi,yppi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
integer :: i, il, ir, k, nm1
real :: a, b, c, d, dx, h, xx
!
!     Abstract
!
!         SEVAL1 evaluates a cubic spline and its first and second
!         derivatives at the abscissas in xi.  It is assumed that
!         the first derivatives at the nodes have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               spline.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YP  - array of first derivatives that define the spline.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               The arrays X, Y, and YP must be dimensioned at least N.
!               N must be greater than or equal to 2.
!         Xi  - the abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         NI  - the number of abscissas at which the spline is to be
!               evaluated.  If NI is greater than 1, then xi, YI, YPI,
!               and YPPI must be arrays dimensioned at least NI.
!               NI must be greater than or equal to 1.
!
!       --Output--
!
!         YI  - array of values of the spline (ordinates) at xi.
!         YPI - array of values of the first derivative of spline at xi.
!         YPPI- array of values of second derivatives of spline at xi.
!         IERR- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - NI is not positive.
!
real, intent(in) :: x(n), y(n), yp(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
!
!     Check input
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K is index on value of xi being worked on.  XX is that value.
!     I is current index into X array.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX is greater than X(N) or less than X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h = x(i+1) - x(i)
d = (y(i+1) - y(i))/h
a = yp(i) + yp(i+1)
b = (-a - yp(i) + 3.0*d)/h
c = (a - d - d)/(h*h)
dx = xx - x(i)
yi(k) = y(i) + dx*(yp(i) + dx*(b + dx*c))
b = b + b
c = 3.0*c
ypi(k) = yp(i) + dx*(b + dx*c)
yppi(k) = b + dx*(c + c)
!
!     Next point
!
if (k .ge. ni) return
k = k + 1
xx = xi(k)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
if (xx - xi(k-1)) 110,100,50
110 il = 1
ir = min0(i+1,nm1)
go to 10
end subroutine seval1

subroutine seval2 (x,y,ypp,n,xi,yi,ypi,yppi,ni,ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n, ni
integer :: i, il, ir, k, nm1
real :: h, h2, xl, xl2, xl3, xr, xr2, xr3, xx
!
!     Abstract
!
!         SEVAL2 evaluates a cubic spline and its first and second
!         derivatives at the abscissas in xi.  It is assumed that
!         the second derivatives at the nodes have been provided.
!
!     Description of arguments
!
!       --Input--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               spline.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YPP - array of second derivatives that define the spline.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               The arrays X, Y, and YPP must be dimensioned at least N.
!               N must be greater than or equal to 2.
!         Xi  - the abscissa or array of abscissas (in arbitrary order)
!               at which the spline is to be evaluated.
!         NI  - the number of abscissas at which the spline is to be
!               evaluated.  If NI is greater than 1, then xi, YI, YPI,
!               and YPPI must be arrays dimensioned at least NI.
!               NI must be greater than or equal to 1.
!
!       --Output--
!
!         YI  - array of values of the spline (ordinates) at xi.
!         YPI - array of values of the first derivative of spline at xi.
!         YPPI- array of values of second derivatives of spline at xi.
!         IERR- status code
!               0  the spline was evaluated at each abscissa in xi.
!               1  Input error - NI is not positive.
!
real, intent(in) :: x(n), y(n), ypp(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
!
!     Check input
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K is index on value of xi being worked on.  XX is that value.
!     I is current index into X array.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX is greater than X(N) or less than X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     Evaluation
!
100 h  = x(i+1) - x(i)
h2 = h*h
xr = (x(i+1) - xx)/h
xr2 = xr*xr
xr3 = xr*xr2
xl = (xx - x(i))/h
xl2 = xl*xl
xl3 = xl*xl2
yi(k) = y(i)*xr + y(i+1)*xl &
&- h2*(ypp(i)*(xr-xr3) + ypp(i+1)*(xl-xl3))/6.0
ypi(k) = (y(i+1)-y(i))/h &
&+ h*(ypp(i)*(1.0-3.0*xr2) - ypp(i+1)*(1.0-3.0*xl2))/6.0
yppi(k) = ypp(i)*xr + ypp(i+1)*xl
!
!     Next point
!
if (k .ge. ni) return
k = k + 1
xx = xi(k)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
if (xx - xi(k-1)) 110,100,50
110 il = 1
ir = min0(i+1,nm1)
go to 10
end subroutine seval2

real function csint (x, y, a, b, c, n, alpha, beta)
implicit none
integer, intent(in) :: n
real, intent(in) :: alpha, beta
integer :: i, k, kp1, l, lm1
real :: a0, b0, d, d2, h, h2, r, s, sum
integer :: intrvl
!-----------------------------------------------------------------------
!
!                    Integrating a cubic spline
!
!                         --------------
!
!     X      ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!            that define the spline.
!
!     Y      ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!
!     A,B,C  arrays that contain the coefficients of the polynomials
!            WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
!            has the value
!                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
!            FOR X(I) .LE. XX .LE. X(I+1). HERE DX = XX - X(I).
!
!     N      THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
!            The arrays X, Y, A, B, C  must be dimensioned at
!            least N.  N must be greater than or equal to 1.
!
!     Alpha  lower limit of the integral.
!
!     BETA   UPPER LIMIT OF THE INTEGRAL. BETA MAY BE LESS THAN
!            or greater than alpha.
!
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n), a(n), b(n), c(n)
!
csint = 0.0
h = beta - alpha
if (h .eq. 0.0) return
if (h .gt. 0.0) go to 10
   a0 = beta
   b0 = alpha
   go to 20
10 a0 = alpha
b0 = beta
!
!     Locate the intervals containing A0 and B0
!
20 if (n .eq. 1) go to 50
if (a0 .ge. x(n)) go to 50
k = intrvl (a0, x, n)
l = intrvl (b0, x, n)
if (b0 .ge. x(n)) l = n
if (k .eq. l) go to 51
!
!     Integrate from A0 to X(K + 1)
!
kp1 = k + 1
h = x(kp1) - x(k)
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*a(k)*r + b(k)*(s + h*d)/3.0 &
&+ 0.25*c(k)*r*s
sum = (x(kp1) - a0)*sum
!
!     Integrate over the interior intervals
!
if (kp1 .eq. l) go to 40
lm1 = l - 1
do i = kp1,lm1
   h = x(i + 1) - x(i)
   s = (((0.25*c(i)*h + b(i)/3.0)*h + 0.5*a(i))*h + y(i))*h
   sum = sum + s
end do
!
!     Integrate from X(L) to B0
!
40 h = b0 - x(l)
s = (((0.25*c(l)*h + b(l)/3.0)*h + 0.5*a(l))*h + y(l))*h
csint = sum + s
if (alpha .gt. beta) csint = -csint
return
!
!     Case when A0 and B0 are in the same interval
!
50 k = n
51 h = b0 - x(k)
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*a(k)*r + b(k)*(s + h*d)/3.0 &
&+ 0.25*c(k)*r*s
csint = (beta - alpha)*sum
return
end function csint

real function csint1 (x, y, yp, n, a, b)
implicit none
integer, intent(in) :: n
real, intent(in) :: a, b
integer :: i, ip1, k, kp1, l, lm1, lp1
real :: a0, b0, bi, ci, d, d2, h, h2, r, s, sum
integer :: intrvl
!-----------------------------------------------------------------------
!
!                    Integrating a cubic spline
!
!                         --------------
!
!     X    ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!          that define the spline.
!
!     Y    ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!
!     YP   ARRAY OF THE FIRST DERIVATIVES THAT DEFINE THE SPLINE.
!
!     N    THE NUMBER OF KNOTS OF THE SPLINE. THE ARRAYS X, Y,
!          AND YP MUST HAVE DIMENSION AT LEAST N WHERE N .GE. 2.
!
!     A    LOWER LIMIT OF THE INTEGRAL.
!
!     B    UPPER LIMIT OF THE INTEGRAL. B MAY BE LESS THAN
!          or greater than A.
!
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n), yp(n)
!
csint1 = 0.0
h = b - a
if (h .eq. 0.0) return
if (h .gt. 0.0) go to 10
   a0 = b
   b0 = a
   go to 20
10 a0 = a
b0 = b
!
!     Locate the intervals containing A0 and B0
!
20 k = intrvl (a0, x, n)
l = intrvl (b0, x, n)
if (k .eq. l) go to 50
!
!     Integrate from A0 to X(K + 1)
!
kp1 = k + 1
h = x(kp1) - x(k)
d = (y(kp1) - y(k))/h
r = yp(k) + yp(kp1)
bi = (-r - yp(k) + 3.0*d)/h
ci = (r - d - d)/(h*h)
!
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*yp(k)*r + bi*(s + h*d)/3.0 &
&+ 0.25*ci*r*s
sum = (x(kp1) - a0)*sum
!
!     Integrate over the interior intervals
!
if (kp1 .eq. l) go to 40
lm1 = l - 1
do i = kp1,lm1
   ip1 = i + 1
   h = x(ip1) - x(i)
   d = (y(ip1) - y(i))/h
   r = yp(i) + yp(ip1)
   bi = (-r - yp(i) + 3.0*d)/h
   ci = (r - d - d)/(h*h)
   s = (((0.25*ci*h + bi/3.0)*h + 0.5*yp(i))*h + y(i))*h
   sum = sum + s
end do
!
!     Integrate from X(L) to B0
!
40 lp1 = l + 1
h = x(lp1) - x(l)
d = (y(lp1) - y(l))/h
r = yp(l) + yp(lp1)
bi = (-r - yp(l) + 3.0*d)/h
ci = (r - d - d)/(h*h)
h = b0 - x(l)
s = (((0.25*ci*h + bi/3.0)*h + 0.5*yp(l))*h + y(l))*h
csint1 = sum + s
if (a .gt. b) csint1 = -csint1
return
!
!     Case when A0 and B0 are in the same interval
!
50 kp1 = k + 1
h = x(kp1) - x(k)
d = (y(kp1) - y(k))/h
r = yp(k) + yp(kp1)
bi = (-r - yp(k) + 3.0*d)/h
ci = (r - d - d)/(h*h)
!
h = b0 - x(k)
d = a0 - x(k)
r = h + d
h2 = h*h
d2 = d*d
s = h2 + d2
sum = y(k) + 0.5*yp(k)*r + bi*(s + h*d)/3.0 &
&+ 0.25*ci*r*s
csint1 = (b - a)*sum
return
end function csint1

real function csint2 (x, y, ypp, n, a, b)
implicit none
integer, intent(in) :: n
real, intent(in) :: a, b
integer :: i, ip1, k, kp1, l, lm1, lp1
real :: a0, b0, d, dma, dmb, dpa, dpb, h, r, s, sum
integer :: intrvl
!-----------------------------------------------------------------------
!
!                    Integrating a cubic spline
!
!                         --------------
!
!     X    ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!          that define the spline.
!
!     Y    ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!
!     YPP  array of the second derivatives that define the spline.
!
!     N    THE NUMBER OF KNOTS OF THE SPLINE. THE ARRAYS X, Y,
!          AND YPP MUST HAVE DIMENSION AT LEAST N WHERE N .GE. 2.
!
!     A    LOWER LIMIT OF THE INTEGRAL.
!
!     B    UPPER LIMIT OF THE INTEGRAL. B MAY BE LESS THAN
!          or greater than A.
!
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n), ypp(n)
!
csint2 = 0.0
h = b - a
if (h .eq. 0.0) return
if (h .gt. 0.0) go to 10
   a0 = b
   b0 = a
   go to 20
10 a0 = a
b0 = b
!
!     Locate the intervals containing A0 and B0
!
20 k = intrvl (a0, x, n)
l = intrvl (b0, x, n)
if (k .eq. l) go to 50
!
!     Integrate from A0 to X(K + 1)
!
kp1 = k + 1
h = x(kp1) - x(k)
d = (x(kp1) - a0)/h
r = y(k)*d + y(kp1)*(2.0 - d)
s = ypp(k)*(2.0 - d*d) + ypp(kp1)*(2.0 - d)**2
sum = h*d*(0.5*r - h*h*d*s/24.0)
!
!
!     Integrate over the interior intervals
!
if (kp1 .eq. l) go to 40
lm1 = l - 1
do i = kp1,lm1
   ip1 = i + 1
   h = x(ip1) - x(i)
   r = y(i) + y(ip1)
   s = ypp(i) + ypp(ip1)
   sum = sum + h*(0.5*r - h*h*s/24.0)
end do
!
!     Integrate from X(L) to B0
!
40 lp1 = l + 1
h = x(lp1) - x(l)
d = (b0 - x(l))/h
r = y(l)*(2.0 - d) + y(lp1)*d
s = ypp(l)*(2.0 - d)**2 + ypp(lp1)*(2.0 - d*d)
csint2 = sum + h*d*(0.5*r - h*h*d*s/24.0)
if (a .gt. b) csint2 = -csint2
return
!
!     Case when A0 and B0 are in the same interval
!
50 kp1 = k + 1
h = x(kp1) - x(k)
dma = (a - x(k))/h
dmb = (b - x(k))/h
dpa = (x(kp1) - a)/h
dpb = (x(kp1) - b)/h
r = (dpa + dpb)*y(k) + (dma + dmb)*y(kp1)
s = ypp(k) * (dpa + dpb)*(dma*(2.0 - dma) + dmb*(2.0 - dmb)) + &
&ypp(kp1)*(dma + dmb)*(dpa*(2.0 - dpa) + dpb*(2.0 - dpb))
csint2 = (b - a)*(0.5*r - h*h*s/24.0)
return
end function csint2

subroutine pdspl (x, y, a, b, c, n, t, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: n
integer :: i, j, nm1, nm2, nm3
real :: alpha, del, del0, deli, delta, e, h, hi, r, s, si, w
!-----------------------------------------------------------------------
!                Periodic cubic spline interpolation
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(*)
real, intent(inout) :: a(*), b(*), c(*), t(*)
!----------------------
!     REAL X(N), Y(N-1), A(N-1), B(N-1), C(N-1), T(N-2)
!----------------------
if (n .lt. 3) go to 100
nm1 = n - 1
nm2 = n - 2
nm3 = n - 3
!
!     A strictly diagonally dominant set of equations for the
!     SLOPES S(I) OF THE SPLINE AT X(I) (I = 1,...,N-1) IS
!     generated and solved by Gauss elimination. The first of
!     these equations is obtained from the requirement that
!     the spline be periodic. This equation has the form ...
!
!        A(1)*S(1) + B(1)*S(2) + C(1)*S(N-1) = T(1)
!
b(1) = x(n) - x(nm1)
h = x(2) - x(1)
if (h .le. 0.0 .or. b(1) .le. 0.0) go to 110
del = (y(1) - y(nm1))/b(1)
deli = (y(2) - y(1))/h
!
c(1) = h
a(1) = 2.0*(h + b(1))
t(1) = 3.0*(h*del + b(1)*deli)
if (n .eq. 3) go to 20
!
!     FOR THE KNOTS X(I) (I = 2,...N-2) GENERATE THE CORRESPOND-
!     ing equations and carry out the pivot reduction of Gauss
!     elimination. Then the I-TH equation has the form ...
!
!        A(I)*S(I) + B(I)*S(I+1) + C(I)*S(N-1) = T(I)
!
do i = 2,nm2
   b(i) = h
   h = x(i+1) - x(i)
   if (h .le. 0.0) go to 110
!
   e = h/a(i-1)
   c(i) = - e*c(i-1)
   a(i) = 2.0*(b(i) + h) - e*b(i-1)
!
   del0 = deli
   deli = (y(i+1) - y(i))/h
   t(i) = 3.0*(h*del0 + b(i)*deli) - e*t(i-1)
end do
!
20 ierr = 0
b(nm1) = h
!
!     Since it is required that the spline be periodic, the
!     equation for the knot X(N-1) has the form ...
!
!        ALPHA*S(1) + B(1)*S(N-2) + DELTA*S(N-1) = R
!
!     Applying the pivots to this equation, one obtains after
!     each pivot operation the modified equation ...
!
!        ALPHA*S(I+1) + B(1)*S(N-2) + DELTA*S(N-1) = R
!
!     Thus, when this pivot reduction is complete, the (N-1)-ST
!     equation to be solved has the form ...
!
!        (ALPHA + B(1))*S(N-2) + DELTA*S(N-1) = R
!
alpha = h
delta = 2.0*(h + b(1))
r = 3.0*(b(1)*deli + h*del)
if (n .eq. 3) go to 40
!
do i = 1,nm3
   e = alpha/a(i)
   alpha = - e*b(i)
   delta = delta - e*c(i)
   r = r - e*t(i)
end do
!
!     Solve the last two equations for S(N-1) and S(N-2), and
!     store these slopes in A.
!
40 e = (alpha + b(1))/a(nm2)
w = b(nm2) + c(nm2)
s = (r - e*t(nm2))/(delta - e*w)
a(nm1) = s
a(nm2) = (t(nm2) - w*s)/a(nm2)
if (n .eq. 3) go to 60
!
!     Back substitution to obtain the remaining slopes S(I).
!     These slopes are stored in A.
!
si = a(nm2)
do j = 3,nm1
   i = n - j
   si = (t(i) - b(i)*si - c(i)*s)/a(i)
   a(i) = si
end do
!
!     Generate the cubic coefficients B(I) and C(I)
!
60 h = b(1)
do i = 1,nm2
   hi = b(i + 1)
   deli = (y(i+1) - y(i))/hi
   w = a(i) + a(i+1) - 2.0*deli
   b(i) = (deli - a(i) - w)/hi
   c(i) = (w/hi)/hi
end do
w = a(1) + a(nm1) - 2.0*del
b(nm1) = (del - a(nm1) - w)/h
c(nm1) = (w/h)/h
return
!
!     Error return
!
100 ierr = 1
return
110 ierr = 2
return
end subroutine pdspl

subroutine pdfit (x, y, m, break, l, z, a, b, c, wk, iwk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m
integer :: j, k, la, lm1, lw, n
real :: r
!-----------------------------------------------------------------------
!            Least squares periodic cubic spline fitting
!-----------------------------------------------------------------------
real, intent(in) :: x(m), y(m)
real, intent(inout) :: break(l)
real, intent(inout) :: z(*), a(*), b(*), c(*), wk(*)
integer, intent(inout) :: iwk(*)
!--------------------
!     REAL Z(L-1), A(L-1), B(L-1), C(L-1)
!     REAL WK((L + 6)*(L + 15) + 10)
!     INTEGER IWK(2*L + 6)
!--------------------
real :: temp(20)
real :: con(3), xcon(3)
integer :: nder(3)
!--------------------
data nder(1) /3/, nder(2) /7/, nder(3) /11/
!--------------------
if (m .le. 0 .or. l .lt. 2) go to 100
n = l + 2
!
!                Define the nodes for the B-splines
!
wk(1) = break(1)
wk(2) = break(1)
wk(3) = break(1)
wk(4) = break(1)
do j = 2,l
   if (break(j - 1) .ge. break(j)) go to 110
   wk(j + 3) = break(j)
end do
wk(l + 4) = break(l)
wk(l + 5) = break(l)
wk(l + 6) = break(l)
!
!                Define the periodicity constraints
!
con(1) = break(1)
con(2) = break(1)
con(3) = break(1)
xcon(1) = break(l)
xcon(2) = break(l)
xcon(3) = break(l)
!
!     Obtain the B-spline coefficients of the periodic spline
!
ierr = 0
la = n + 5
lw = la + n
iwk(1) = iwk(1) - (l + l + 8)
call bfit (wk(1), n, 4, x, y, m, xcon, con, nder, 3, ierr, &
&wk(la), r, wk(lw), iwk)
iwk(1) = iwk(1) + (l + l + 8)
if (ierr .ne. 0) go to 30
!
!     Obtain the coefficients of the spline in Taylor series form
!
call bspp (wk(1), wk(la), n, 4, break, wk(lw), lm1, temp)
k = lw
do 20 j = 1,lm1
   z(j) = wk(k)
   a(j) = wk(k + 1)
   b(j) = wk(k + 2)
   c(j) = wk(k + 3)
   k = k + 4
20 continue
return
!
!                The coefficients were not obtained
!
30 if (ierr .eq. -4) go to 120
if (ierr .eq. -6) go to 130
if (ierr .eq. -7) go to 140
ierr = 1
return
!
!                           Error return
!
100 ierr = 2
return
110 ierr = 3
return
120 ierr = 4
return
130 ierr = 5
return
140 ierr = 6
return
end subroutine pdfit

subroutine pscmp (x, y, a, b, c, n, xi, yi, m, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
integer :: i, il, ir, j, k
real :: dx, h, t, t0, x1, xold, xx
!-----------------------------------------------------------------------
!              Evaluation of a periodic cubic spline
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(*), a(*), b(*), c(*), xi(m)
real, intent(inout) :: yi(m)
!----------------------
!     REAL X(N), Y(N-1), A(N-1), B(N-1), C(N-1), XI(M), YI(M)
!----------------------
if (n .ge. 3 .and. m .ge. 1) go to 1
   ierr = 1
   return
1 ierr = 0
x1 = x(1)
h = x(n) - x1
!
!     REDUCTION OF XI(K) TO XX WHERE X(1) .LE. XX .LT. X(N)
!
k = 1
t = (xi(1) - x1)/h
j = t
t0 = t - j
if (t0 .lt. 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx .ge. x(n)) go to 120
il = 1
ir = n
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 90
if (xx - x(i)) 20,90,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
40 if (xx .lt. x(i+1)) go to 90
i = i + 1
go to 40
!
!     COMPUTATION WHEN X(I) .LE. XX .LT. X(I+1)
!
90 dx = xx - x(i)
yi(k) = ((c(i)*dx + b(i))*dx + a(i))*dx + y(i)
!
!     Next point
!
100 if (k .ge. m) return
xold = xx
k = k + 1
t = (xi(k) - x1)/h
j = t
t0 = t - j
if (t0 .lt. 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx .ge. x(n)) go to 120
if (xx - xold) 110,90,40
!
110 il = 1
ir = min0(i+1,n)
go to 10
!
!     Case when roundoff produces a value for XX where
!     XX .GE. X(N). THIS CASE MAY NEVER OCCUR.
!
120 i = 1
xx = x1
yi(k) = y(1)
go to 100
end subroutine pscmp

subroutine psevl (x, y, a, b, c, n, xi, yi, ypi, yppi, m, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
integer :: i, il, ir, j, k
real :: bi2, ci3, dx, h, t, t0, x1, xold, xx
!-----------------------------------------------------------------------
!     Evaluation and differentiation of a periodic cubic spline
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(*), a(*), b(*), c(*), xi(m)
real, intent(inout) :: yi(m), ypi(m), yppi(m)
!----------------------
!     REAL X(N), Y(N-1), A(N-1), B(N-1), C(N-1), XI(M), YI(M), YPI(M),
!    *     YPPI(M)
!----------------------
if (n .ge. 3 .and. m .ge. 1) go to 1
   ierr = 1
   return
1 ierr = 0
x1 = x(1)
h = x(n) - x1
!
!     REDUCTION OF XI(K) TO XX WHERE X(1) .LE. XX .LT. X(N)
!
k = 1
t = (xi(1) - x1)/h
j = t
t0 = t - j
if (t0 .lt. 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx .ge. x(n)) go to 120
il = 1
ir = n
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 90
if (xx - x(i)) 20,90,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
40 if (xx .lt. x(i+1)) go to 90
i = i + 1
go to 40
!
!     COMPUTATION WHEN X(I) .LE. XX .LT. X(I+1)
!
90 dx = xx - x(i)
yi(k) = ((c(i)*dx + b(i))*dx + a(i))*dx + y(i)
bi2 = b(i) + b(i)
ci3 = 3.0*c(i)
ypi(k) = (ci3*dx + bi2)*dx + a(i)
yppi(k) = bi2 + (ci3 + ci3)*dx
!
!     Next point
!
100 if (k .ge. m) return
xold = xx
k = k + 1
t = (xi(k) - x1)/h
j = t
t0 = t - j
if (t0 .lt. 0.0) t0 = 1.0 + t0
xx = x1 + t0*h
if (xx .ge. x(n)) go to 120
if (xx - xold) 110,90,40
!
110 il = 1
ir = min0(i+1,n)
go to 10
!
!     Case when roundoff produces a value for XX where
!     XX .GE. X(N). THIS CASE MAY NEVER OCCUR.
!
120 i = 1
xx = x1
yi(k) = y(1)
ypi(k) = a(1)
yppi(k) = b(1) + b(1)
go to 100
end subroutine psevl

subroutine csloop (m, n, x, kx, t, dx, kdx, wk, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kdx, kx, m, n
integer :: ia, ib, ic, ie, mm1
!-----------------------------------------------------------------------
!               Closed curve cubic spline fitting
!                    in N-dimensional space
!-----------------------------------------------------------------------
!     WRITTEN BY
!        ALFRED H. MORRIS
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN, VIRGINIA
!----------------------
real, intent(in) :: x(kx,n)
real, intent(inout) :: t(m), dx(kdx,n), wk(*)
!----------------------
!     M = THE NUMBER OF N-DIMENSIONAL POINTS GIVEN IN X
!     WK is an array of dimension 4*(M-1)
!----------------------
if (min0(m, n) .lt. 2) go to 10
!
mm1 = m - 1
ie = 1
ia = mm1
ib = ia + mm1
ic = ib + m
call cslop1 (m, n, x, kx, t, dx, kdx, wk(ia), wk(ib), &
&wk(ic), wk(ie), ierr)
return
!
!     Error return
!
10 ierr = 1
return
end subroutine csloop

subroutine cslop1 (m, n, x, kx, t, dx, kdx, a, b, c, e, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kdx, kx, m, n
integer :: i, im1, j, l, mm1, mm2
real :: alpha, del, del0, del1, deli, delm, eta, h, hm, p, r, si, &
&sm, sum, tau
real :: snrm2
!-----------------------------------------------------------------------
!               Closed curve cubic spline fitting
!                    in N-dimensional space
!-----------------------------------------------------------------------
real, intent(in) :: x(kx,n)
real, intent(inout) :: t(m), dx(kdx,n), a(*), b(m), c(*), e(*)
!----------------------
!     REAL A(M-1), C(M-1), E(K)  (K = MAX0(1,M-2))
!     THE E ARRAY IS NOT USED WHEN M = 2.
!----------------------
mm1 = m - 1
mm2 = m - 2
!
!     DEFINITION OF THE KNOTS T(I) (I = 1,...,M). ALSO T(M+1) = 1.
!     This last knot is not stored.
!
t(1) = 0.0
do i = 2,m
   im1 = i - 1
   do j = 1,n
      dx(i,j) = x(i,j) - x(im1,j)
   end do
   t(i) = t(im1) + snrm2(n,dx(i,1),kdx)
   r = t(i) - t(im1)
   if (r .eq. 0.0) go to 200
end do
!
do j = 1,n
   dx(1,j) = x(1,j) - x(m,j)
end do
sum = t(m) + snrm2(n,dx(1,1),kdx)
r = sum - t(m)
if (r .eq. 0.0) go to 210
!
do i = 2,m
   t(i) = t(i)/sum
end do
ierr = 0
!
!     FOR J = 1,...,N, A DIAGONALLY DOMINANT SET OF EQUATIONS
!     for the slopes S(I,J) of the J-TH periodic spline at T(I)
!     (I = 1,...,M) IS GENERATED AND SOLVED BY GAUSS ELIMINATION.
!     The first equation is obtained from the requirement that
!     the spline be periodic. This equation has the form ...
!
!        A(1)*S(1,J) + B(1)*S(2,J) + C(1)*S(M,J) = DX(1,J)
!
h = t(2)
hm = 1.0 - t(m)
c(1) = h
b(1) = hm
a(1) = 2.0*(h + hm)
b(2) = h
!
do j = 1,n
   delm = dx(1,j)/hm
   del1 = dx(2,j)/h
   dx(1,j) = 3.0*(h*delm + hm*del1)
   dx(2,j) = del1
end do
if (m .eq. 2) go to 70
!
!     FOR THE KNOTS T(I) (I = 2,...M-1), GENERATE THE CORRESPOND-
!     ing equations and carry out the pivot reduction of Gauss
!     elimination. Then the I-TH equation has the form ...
!
!        A(I)*S(I,J) + B(I)*S(I+1,J) + C(I)*S(M,J) = DX(I,J)
!
do i = 2,mm1
   im1 = i - 1
   b(i) = h
   h = t(i+1) - t(i)
   e(im1) = h/a(im1)
   c(i) = - e(im1)*c(im1)
   a(i) = 2.0*(b(i) + h) - e(im1)*b(im1)
end do
b(m) = h
!
do j = 1,n
   deli = dx(2,j)
   do i = 2,mm1
      h = b(i+1)
      del0 = deli
      deli = dx(i+1,j)/h
      dx(i,j) = 3.0*(h*del0 + b(i)*deli) - e(i-1)*dx(i-1,j)
   end do
   dx(m,j) = deli
end do
!
!     Since it is required that the spline be periodic, the
!     equation for the knot T(M) has the form ...
!
!        ALPHA*S(1,J) + HM*S(M-1,J) + ETA*S(M,J) = DX(M,J)
!
!     Applying the pivots to this equation, one obtains after
!     each pivot operation the modified equation ...
!
!        ALPHA*S(I+1,J) + HM*S(M-1,J) + ETA*S(M,J) = DX(M,J)
!
!     Thus, when this pivot reduction is complete, the M-TH
!     equation to be solved has the form ...
!
!        (ALPHA + HM)*S(M-1,J) + ETA*S(M,J) = DX(M,J)
!
70 alpha = h
eta = 2.0*(h + hm)
do j = 1,n
   del  = dx(m,j)
   delm = (x(1,j) - x(m,j))/hm
   dx(m,j) = 3.0*(hm*del + h*delm)
end do
if (m .eq. 2) go to 90
!
do i = 1,mm2
   p = alpha/a(i)
   alpha = - p*b(i)
   eta = eta - p*c(i)
   do j = 1,n
      dx(m,j) = dx(m,j) - p*dx(i,j)
   end do
end do
!
!     Solve the last two equations for S(M,J) and S(M-1,J),
!     and store these slopes in DX.
!
90 p = (alpha + hm)/a(mm1)
tau = b(mm1) + c(mm1)
do j = 1,n
   sm = (dx(m,j) - p*dx(mm1,j))/(eta - p*tau)
   dx(m,j) = sm
   dx(mm1,j) = (dx(mm1,j) - tau*sm)/a(mm1)
end do
if (m .eq. 2) return
!
!     Back substitution to obtain the remaining slopes S(I,J).
!     These slopes are stored in DX.
!
do j = 1,n
   sm = dx(m,j)
   si = dx(mm1,j)
   i = mm1
   do l = 3,m
      i = i - 1
      si = (dx(i,j) - b(i)*si - c(i)*sm)/a(i)
      dx(i,j) = si
   end do
end do
return
!
!     Error return
!
200 ierr = 2
return
210 ierr = 3
return
end subroutine cslop1

subroutine lopcmp (m, n, t, x, kx, dx, kdx, l, ti, z, kz)
implicit none
integer, intent(in) :: kdx, kx, kz, l, m, n
integer :: i, il, ir, j, k
real :: a, b, c, d, dt, h, t0, told, w
!-----------------------------------------------------------------------
!            Evaluation of a cubic spline closed curve
!                     in N-dimensional space
!-----------------------------------------------------------------------
real, intent(in) :: t(m), x(kx,n), dx(kdx,n), ti(l)
real, intent(inout) :: z(kz, n)
!
!     REDUCTION OF TI(K) TO T0 WHERE 0 .LE. T0 .LT. 1
!
k = 1
j = ti(1)
t0 = ti(1) - j
if (t0 .lt. 0.0) t0 = 1.0 + t0
if (t0 .ge. t(m)) go to 60
il = 1
ir = m
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 50
if (t0 - t(i)) 20,50,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
40 if (t0 .lt. t(i+1)) go to 50
i = i + 1
go to 40
!
!     COMPUTATION WHEN T(I) .LE. T0 .LT. T(I+1)
!
50 h = t(i+1) - t(i)
dt = t0 - t(i)
do j = 1,n
   a = dx(i,j)
   d = (x(i+1,j) - x(i,j))/h
   w = a + dx(i+1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(k,j) = x(i,j) + dt*(a + dt*(b + dt*c))
end do
go to 100
!
!     COMPUTATION WHEN T0 .GE. T(M)
!
60 i = m
h = 1.0 - t(m)
dt = t0 - t(m)
do j = 1,n
   a = dx(m,j)
   d = (x(1,j) - x(m,j))/h
   w = a + dx(1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(k,j) = x(m,j) + dt*(a + dt*(b + dt*c))
end do
!
!     Next point
!
100 if (k .ge. l) return
told = t0
k = k + 1
j = ti(k)
t0 = ti(k) - j
if (t0 .lt. 0.0) t0 = 1.0 + t0
if (t0 .ge. t(m)) go to 60
if (t0 - told) 110,50,40
!
110 il = 1
ir = min0(i+1,m)
go to 10
end subroutine lopcmp

subroutine lopdf (m, n, t, x, kx, dx, kdx, ti, z, dz, ddz)
implicit none
integer, intent(in) :: kdx, kx, m, n
real, intent(in) :: ti
integer :: i, il, ir, j
real :: a, b, c, d, dt, h, t0, w
!-----------------------------------------------------------------------
!          Evaluation and differentiation of a cubic spline
!                closed curve in N-dimensional space
!-----------------------------------------------------------------------
real, intent(in) :: t(m), x(kx,n), dx(kdx,n)
real, intent(inout) :: z(n), dz(n), ddz(n)
!
!     REDUCTION OF TI TO T0 WHERE 0 .LE. T0 .LT. 1
!
j = ti
t0 = ti - j
if (t0 .lt. 0.0) t0 = 1.0 + t0
if (t0 .ge. t(m)) go to 50
il = 1
ir = m
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 40
if (t0 - t(i)) 20,40,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     COMPUTATION WHEN T(I) .LE. T0 .LT. T(I+1)
!
40 h = t(i+1) - t(i)
dt = t0 - t(i)
do j = 1,n
   a = dx(i,j)
   d = (x(i+1,j) - x(i,j))/h
   w = a + dx(i+1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(j) = x(i,j) + dt*(a + dt*(b + dt*c))
   b = b + b
   c = 3.0*c
   dz(j) = a + dt*(b + c*dt)
   ddz(j) = b + (c + c)*dt
end do
return
!
!     COMPUTATION WHEN T0 .GE. T(M)
!
50 h = 1.0 - t(m)
dt = t0 - t(m)
do j = 1,n
   a = dx(m,j)
   d = (x(1,j) - x(m,j))/h
   w = a + dx(1,j)
   b = (-w - a + 3.0*d)/h
   c = ((w - d - d)/h)/h
   z(j) = x(m,j) + dt*(a + dt*(b + dt*c))
   b = b + b
   c = 3.0*c
   dz(j) = a + dt*(b + c*dt)
   ddz(j) = b + (c + c)*dt
end do
return
end subroutine lopdf

subroutine curv1 (n,x,y,slp1,slpn,islpsw,yp,temp, &
&sigma,ierr)
implicit none
integer :: i, ibak, nm1, np1
real :: c1, c2, c3, delx1, delx2, delxn, delxnm, diag, diag1, &
&diag2, dx1, dx2, sdiag1, sdiag2, sigmap, slpp1, slppn
!
integer, intent(in) :: n, islpsw
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n), slp1, slpn
real, intent(inout) :: yp(n), temp(n)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine determines the parameters necessary to
! compute an interpolatory spline under tension through
! a sequence of functional values. The slopes at the two
! ends of the curve may be specified or omitted.  For actual
! computation of points on the curve it is necessary to call
! the function CURV2.
!
! On input--
!
!   N IS THE NUMBER OF VALUES TO BE INTERPOLATED (N.GE.2).
!
!   X is an array of the N increasing abscissae of the
!   functional values.
!
!   Y is an array of the N ordinates of the values, (I. E.
!   Y(K) is the functional value corresponding to X(K) ).
!
!   SLP1 and SLPN contain the desired values for the first
!   derivative of the curve at X(1) and X(N), respectively.
!   The user may omit values for either or both of these
!   parameters and signal this with ISLPSW.
!
!   ISLPSW contains a switch indicating which slope data
!   should be used and which should be estimated by this
!   subroutine,
!          = 0 IF SLP1 AND SLPN ARE TO BE USED,
!          = 1 IF SLP1 IS TO BE USED BUT NOT SLPN,
!          = 2 IF SLPN IS TO BE USED BUT NOT SLP1,
!          = 3 IF BOTH SLP1 AND SLPN ARE TO BE ESTIMATED
!              internally.
!
!   YP is an array of length at least N.
!
!   Temp is an array of length at least N which is used for
!   scratch storage.
!
! And
!
!   Sigma contains the tension factor. This value indicates
!   the curviness desired. If ABS(SIGMA) is nearly zero
!   (E.G. .001) The resulting curve is approximately A
!   cubic spline. If ABS(SIGMA) is large (E.G. 50.) The
!   resulting curve is nearly a polygonal line. If sigma
!   equals zero a cubic spline results.  A standard value
!   for sigma is approximately 1. In absolute value.
!
! On output--
!
!   YP contains the values of the second derivative of the
!   curve at the given nodes.
!
!   IERR contains an error flag,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF X-VALUES ARE NOT STRICTLY INCREASING.
!
! And
!
!   N, X, Y, SLP1, SLPN, ISLPSW and sigma are unaltered.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
! AND SNHCSH.
!
!-----------------------------------------------------------
!
nm1 = n-1
np1 = n+1
ierr = 0
if (n .le. 1) go to 8
if (x(n) .le. x(1)) go to 9
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! Approximate end slopes
!
if (islpsw .ge. 2) go to 1
slpp1 = slp1
go to 2
1 delx1 = x(2)-x(1)
delx2 = delx1+delx1
if (n .gt. 2) delx2 = x(3)-x(1)
if (delx1 .le. 0. .or. delx2 .le. delx1) go to 9
call ceez (delx1,delx2,sigmap,c1,c2,c3,n)
slpp1 = c1*y(1)+c2*y(2)
if (n .gt. 2) slpp1 = slpp1+c3*y(3)
2 if (islpsw .eq. 1 .or. islpsw .eq. 3) go to 3
slppn = slpn
go to 4
3 delxn = x(n)-x(nm1)
delxnm = delxn+delxn
if (n .gt. 2) delxnm = x(n)-x(n-2)
if (delxn .le. 0. .or. delxnm .le. delxn) go to 9
call ceez (-delxn,-delxnm,sigmap,c1,c2,c3,n)
slppn = c1*y(n)+c2*y(nm1)
if (n .gt. 2) slppn = slppn+c3*y(n-2)
!
! Set up right hand side and tridiagonal system for YP and
! perform forward elimination
!
4 delx1 = x(2)-x(1)
if (delx1 .le. 0.) go to 9
dx1 = (y(2)-y(1))/delx1
call terms (diag1,sdiag1,sigmap,delx1)
yp(1) = (dx1-slpp1)/diag1
temp(1) = sdiag1/diag1
if (n .eq. 2) go to 6
do 5 i = 2,nm1
  delx2 = x(i+1)-x(i)
  if (delx2 .le. 0.) go to 9
  dx2 = (y(i+1)-y(i))/delx2
  call terms (diag2,sdiag2,sigmap,delx2)
  diag = diag1+diag2-sdiag1*temp(i-1)
  yp(i) = (dx2-dx1-sdiag1*yp(i-1))/diag
  temp(i) = sdiag2/diag
  dx1 = dx2
  diag1 = diag2
5 sdiag1 = sdiag2
6 diag = diag1-sdiag1*temp(nm1)
yp(n) = (slppn-dx1-sdiag1*yp(nm1))/diag
!
! Perform back substitution
!
do 7 i = 2,n
  ibak = np1-i
7 yp(ibak) = yp(ibak)-temp(ibak)*yp(ibak+1)
return
!
! Too few points
!
8 ierr = 1
return
!
! X-values not strictly increasing
!
9 ierr = 2
return
end subroutine curv1

function curv2 (t,n,x,y,yp,sigma)
implicit none
integer :: i, im1
real :: coshp1, coshp2, del1, del2, delp1, delp2, dels, dummy, &
&sigmap, sinhm1, sinhm2, sinhms, sinhp1, sinhp2, sum
integer :: intrvl
real :: curv2
!
integer, intent(in) :: n
real, intent(in) :: t, x(n), y(n), yp(n), sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This function interpolates a curve at a given point
! using a spline under tension. The subroutine CURV1 should
! be called earlier to determine certain necessary
! parameters.
!
! On input--
!
!   T contains a real value to be mapped onto the interpo-
!   LATING CURVE.
!
!   N contains the number of points which were specified to
!   determine the curve.
!
!   X and Y are arrays containing the abscissae and
!   ordinates, respectively, of the specified points.
!
!   YP is an array of second derivative values of the curve
!   at the nodes.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters N, X, Y, YP, and sigma should be input
! unaltered from the output of CURV1.
!
! On output--
!
!   CURV2 contains the interpolated value.
!
! None of the input parameters are altered.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! Determine interval
!
im1 = intrvl(t,x,n)
i = im1+1
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! Set up and perform interpolation
!
del1 = t-x(im1)
del2 = x(i)-t
dels = x(i)-x(im1)
sum = (y(i)*del1+y(im1)*del2)/dels
if (sigmap .ne. 0.) go to 1
curv2 = sum-del1*del2*(yp(i)*(del1+dels)+yp(im1)* &
&(del2+dels))/(6.*dels)
return
1 delp1 = sigmap*(del1+dels)/2.
delp2 = sigmap*(del2+dels)/2.
call snhcsh (sinhm1,dummy,sigmap*del1,-1)
call snhcsh (sinhm2,dummy,sigmap*del2,-1)
call snhcsh (sinhms,dummy,sigmap*dels,-1)
call snhcsh (sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh (sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh (dummy,coshp1,delp1,1)
call snhcsh (dummy,coshp2,delp2,1)
curv2 = sum+(yp(i)*(sinhm1*del2-del1*(2.*(coshp1+1.)* &
&sinhp2+sigmap*coshp1*del2))+yp(im1)*(sinhm2* &
&del1-del2*(2.*(coshp2+1.)*sinhp1+sigmap* &
&coshp2*del1)))/(sigmap*sigmap*dels*(sinhms+ &
&sigmap*dels))
return
end function curv2

function curvd (t,n,x,y,yp,sigma)
implicit none
integer :: i, im1
real :: coshm1, coshm2, del1, del2, dels, dummy, sigmap, sinhms, &
&sum
integer :: intrvl
real :: curvd
!
integer, intent(in) :: n
real, intent(in) :: t, x(n), y(n), yp(n), sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This function differentiates a curve at a given point
! using a spline under tension. The subroutine CURV1 should
! be called earlier to determine certain necessary
! parameters.
!
! On input--
!
!   T contains a real value at which the derivative is to be
!   determined.
!
!   N contains the number of points which were specified to
!   determine the curve.
!
!   X and Y are arrays containing the abscissae and
!   ordinates, respectively, of the specified points.
!
!   YP is an array of second derivative values of the curve
!   at the nodes.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters N, X, Y, YP, and sigma should be input
! unaltered from the output of CURV1.
!
! On output--
!
!   CURVD contains the derivative value.
!
! None of the input parameters are altered.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! Determine interval
!
im1 = intrvl(t,x,n)
i = im1+1
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! Set up and perform differentiation
!
del1 = t-x(im1)
del2 = x(i)-t
dels = x(i)-x(im1)
sum = (y(i)-y(im1))/dels
if (sigmap .ne. 0.) go to 1
curvd = sum+(yp(i)*(2.*del1*del1-del2*(del1+dels))- &
&yp(im1)*(2.*del2*del2-del1*(del2+dels))) &
&/(6.*dels)
return
1 call snhcsh (dummy,coshm1,sigmap*del1,1)
call snhcsh (dummy,coshm2,sigmap*del2,1)
call snhcsh (sinhms,dummy,sigmap*dels,-1)
curvd = sum+(yp(i)*(dels*sigmap*coshm1-sinhms)- &
&yp(im1)*(dels*sigmap*coshm2-sinhms))/ &
&(sigmap*sigmap*dels*(sinhms+sigmap*dels))
return
end function curvd

function curvi (xl,xu,n,x,y,yp,sigma)
implicit none
integer :: i, il, ilm1, ilp1, iu, ium1
real :: c1, c2, cl1, cl2, cmm1, cmm2, cs, cu1, cu2, del1, del2, &
&deli, dell1, dell2, dels, delu1, delu2, dummy, sigmap, ss, ssign, &
&sum, t, t1, t2, xxl, xxu
integer :: intrvl
real :: curvi
real :: term
!
integer, intent(in) :: n
real, intent(in) :: xl, xu, x(n), y(n), yp(n), sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This function integrates a curve specified by a spline
! under tension between two given limits. The subroutine
! CURV1 should be called earlier to determine necessary
! parameters.
!
! On input--
!
!   XL and XU contain the lower and upper limits of inte-
!   gration, respectively. (XL need not be less than or
!   EQUAL TO XU, CURVI (XL,XU,...) .EQ. -CURVI (XU,XL,...) ).
!
!   N contains the number of points which were specified to
!   determine the curve.
!
!   X and Y are arrays containing the abscissae and
!   ordinates, respectively, of the specified points.
!
!   YP is an array of second derivative values of the curve
!   at the nodes.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters N, X, Y, YP, and sigma should be input
! unaltered from the output of CURV1.
!
! On output--
!
!   CURVI contains the integral value.
!
! None of the input parameters are altered.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! Statement function for coefficient associated with
! derivative terms
!
term (cmm1,cmm2,t) = (cmm1-cmm2-sigmap*t*ss)/(sigmap* &
&sigmap*sigmap*(ss+sigmap*dels))
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! Determine actual upper and lower bounds
!
xxl = xl
xxu = xu
ssign = 1.
if (xl .lt. xu) go to 1
xxl = xu
xxu = xl
ssign = -1.
if (xl .gt. xu) go to 1
!
! RETURN ZERO IF XL .EQ. XU
!
curvi = 0.
return
!
! Search for proper intervals
!
1 ilm1 = intrvl (xxl,x,n)
il = ilm1+1
ium1 = intrvl (xxu,x,n)
iu = ium1+1
if (il .eq. iu) go to 8
!
! Integrate from xxl to X(IL)
!
sum = 0.
if (xxl .eq. x(il)) go to 3
del1 = xxl-x(ilm1)
del2 = x(il)-xxl
dels = x(il)-x(ilm1)
t1 = (del1+dels)*del2/(2.*dels)
t2 = del2*del2/(2.*dels)
sum = t1*y(il)+t2*y(ilm1)
if (sigma .eq. 0.) go to 2
call snhcsh (dummy,c1,sigmap*del1,2)
call snhcsh (dummy,c2,sigmap*del2,2)
call snhcsh (ss,cs,sigmap*dels,3)
sum = sum+term(cs,c1,t1)*yp(il) &
&+term(c2,0.,t2)*yp(ilm1)
go to 3
2 sum = sum-t1*t1*dels*yp(il)/6. &
&-t2*(del1*(del2+dels)+dels*dels)*yp(ilm1)/12.
!
! Integrate over interior intervals
!
3 if (iu-il .eq. 1) go to 6
ilp1 = il+1
do 5 i = ilp1,ium1
  dels = x(i)-x(i-1)
  sum = sum+(y(i)+y(i-1))*dels/2.
  if (sigma .eq. 0.) go to 4
  call snhcsh (ss,cs,sigmap*dels,3)
  sum = sum+(yp(i)+yp(i-1))*(cs-ss*sigmap*dels/2.)/ &
&(sigmap*sigmap*sigmap*(ss+sigmap*dels))
  go to 5
4 sum = sum-(yp(i)+yp(i-1))*dels*dels*dels/24.
5 continue
!
! Integrate from X(IU-1) to XXU
!
6 if (xxu .eq. x(ium1)) go to 10
del1 = xxu-x(ium1)
del2 = x(iu)-xxu
dels = x(iu)-x(ium1)
t1 = del1*del1/(2.*dels)
t2 = (del2+dels)*del1/(2.*dels)
sum = sum+t1*y(iu)+t2*y(ium1)
if (sigma .eq. 0.) go to 7
call snhcsh (dummy,c1,sigmap*del1,2)
call snhcsh (dummy,c2,sigmap*del2,2)
call snhcsh (ss,cs,sigmap*dels,3)
sum = sum+term(c1,0.,t1)*yp(iu) &
&+term(cs,c2,t2)*yp(ium1)
go to 10
7 sum = sum-t1*(del2*(del1+dels)+dels*dels)*yp(iu)/12. &
&-t2*t2*dels*yp(ium1)/6.
go to 10
!
! Integrate from xxl to XXU
!
8 delu1 = xxu-x(ium1)
delu2 = x(iu)-xxu
dell1 = xxl-x(ium1)
dell2 = x(iu)-xxl
dels = x(iu)-x(ium1)
deli = xxu-xxl
t1 = (delu1+dell1)*deli/(2.*dels)
t2 = (delu2+dell2)*deli/(2.*dels)
sum = t1*y(iu)+t2*y(ium1)
if (sigma .eq. 0.) go to 9
call snhcsh (dummy,cu1,sigmap*delu1,2)
call snhcsh (dummy,cu2,sigmap*delu2,2)
call snhcsh (dummy,cl1,sigmap*dell1,2)
call snhcsh (dummy,cl2,sigmap*dell2,2)
call snhcsh (ss,dummy,sigmap*dels,-1)
sum = sum+term(cu1,cl1,t1)*yp(iu) &
&+term(cl2,cu2,t2)*yp(ium1)
go to 10
9 sum = sum-t1*(delu2*(dels+delu1)+dell2*(dels+dell1))* &
&yp(iu)/12. &
&-t2*(dell1*(dels+dell2)+delu1*(dels+delu2))* &
&yp(ium1)/12.
!
! Correct sign and return
!
10 curvi = ssign*sum
return
end function curvi

subroutine kurv1 (n,x,y,slp1,slpn,islpsw,xp,yp,temp,s, &
&sigma,ierr)
implicit none
integer :: i, ibak, im1, nm1, np1
real :: c1, c2, c3, dels1, dels2, delsn, delsnm, delt, diag, &
&diag1, diag2, diagin, dx1, dx2, dy1, dy2, sdiag1, sdiag2, sigmap, &
&slpp1x, slpp1y, slppnx, slppny, sx, sy
!
integer, intent(in) :: n, islpsw
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n), slp1, slpn
real, intent(inout) :: xp(n), yp(n), temp(n), s(n)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine determines the parameters necessary to
! compute a spline under tension forming a curve in the
! plane and passing through a sequence of pairs (X(1),Y(1)),
! ...,(X(N),Y(N)). For actual computation of points on the
! curve it is necessary to call the subroutine KURV2.
!
! On input--
!
!   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
!
!   X is an array containing the N X-coordinates of the
!   points.
!
!   Y is an array containing the N Y-coordinates of the
!   points. (Adjacent X-Y pairs must be distinct, I. E.
!   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1), FOR
!   I = 1,...,N-1.)
!
!   SLP1 and SLPN contain the desired values for the angles
!   (in radians) of the slope at (X(1),Y(1)) and (X(N),Y(N))
!   respectively. The angles are measured counter-clock-
!   wise from the X-axis and the positive sense of the curve
!   is assumed to be that moving from point 1 to point N.
!   The user may omit values for either or both of these
!   parameters and signal this with ISLPSW.
!
!   ISLPSW contains a switch indicating which slope data
!   should be used and which should be estimated by this
!   subroutine,
!          = 0 IF SLP1 AND SLPN ARE TO BE USED,
!          = 1 IF SLP1 IS TO BE USED BUT NOT SLPN,
!          = 2 IF SLPN IS TO BE USED BUT NOT SLP1,
!          = 3 IF BOTH SLP1 AND SLPN ARE TO BE ESTIMATED
!              internally.
!
!   XP and YP are arrays of length at least N.
!
!   Temp is an array of length at least N which is used
!   for scratch storage.
!
!   S is an array of length at least N.
!
! And
!
!   Sigma contains the tension factor. This value indicates
!   the curviness desired. If ABS(SIGMA) is nearly zero
!   (E.G. .001) The resulting curve is approximately a cubic
!   spline. If ABS(SIGMA) is large (E. G. 50.) The resulting
!   curve is nearly a polygonal line. If sigma equals zero A
!   cubic spline results. A standard value for sigma is
!   approximately 1. In absolute value.
!
! On output--
!
!   XP and YP contain information about the curvature of the
!   curve at the given nodes.
!
!   S contains the polygonal arclengths of the curve.
!
!   IERR contains an error flag,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF ADJACENT COORDINATE PAIRS COINCIDE.
!
! And
!
!   N, X, Y, SLP1, SLPN, ISLPSW, and sigma are unaltered.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
! AND SNHCSH.
!
!-----------------------------------------------------------
!
nm1 = n-1
np1 = n+1
ierr = 0
if (n .le. 1) go to 11
!
! Determine polygonal arclengths
!
s(1) = 0.
do 1 i = 2,n
  im1 = i-1
1 s(i) = s(im1)+sqrt((x(i)-x(im1))**2+ &
&(y(i)-y(im1))**2)
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! Approximate end slopes
!
if (islpsw .ge. 2) go to 2
slpp1x = cos(slp1)
slpp1y = sin(slp1)
go to 4
2 dels1 = s(2)-s(1)
dels2 = dels1+dels1
if (n .gt. 2) dels2 = s(3)-s(1)
if (dels1 .eq. 0. .or. dels2 .eq. 0.) go to 12
call ceez (dels1,dels2,sigmap,c1,c2,c3,n)
sx = c1*x(1)+c2*x(2)
sy = c1*y(1)+c2*y(2)
if (n .eq. 2) go to 3
sx = sx+c3*x(3)
sy = sy+c3*y(3)
3 delt = sqrt(sx*sx+sy*sy)
slpp1x = sx/delt
slpp1y = sy/delt
4 if (islpsw .eq. 1 .or. islpsw .eq. 3) go to 5
slppnx = cos(slpn)
slppny = sin(slpn)
go to 7
5 delsn = s(n)-s(nm1)
delsnm = delsn+delsn
if (n .gt. 2) delsnm = s(n)-s(n-2)
if (delsn .eq. 0. .or. delsnm .eq. 0.) go to 12
call ceez (-delsn,-delsnm,sigmap,c1,c2,c3,n)
sx = c1*x(n)+c2*x(nm1)
sy = c1*y(n)+c2*y(nm1)
if (n .eq. 2) go to 6
sx = sx+c3*x(n-2)
sy = sy+c3*y(n-2)
6 delt = sqrt(sx*sx+sy*sy)
slppnx = sx/delt
slppny = sy/delt
!
! Set up right hand sides and tridiagonal system for XP and
! YP and perform forward elimination
!
7 dx1 = (x(2)-x(1))/s(2)
dy1 = (y(2)-y(1))/s(2)
call terms (diag1,sdiag1,sigmap,s(2))
xp(1) = (dx1-slpp1x)/diag1
yp(1) = (dy1-slpp1y)/diag1
temp(1) = sdiag1/diag1
if (n .eq. 2) go to 9
do 8 i = 2,nm1
  dels2 = s(i+1)-s(i)
  if (dels2 .eq. 0.) go to 12
  dx2 = (x(i+1)-x(i))/dels2
  dy2 = (y(i+1)-y(i))/dels2
  call terms (diag2,sdiag2,sigmap,dels2)
  diag = diag1+diag2-sdiag1*temp(i-1)
  diagin = 1./diag
  xp(i) = (dx2-dx1-sdiag1*xp(i-1))*diagin
  yp(i) = (dy2-dy1-sdiag1*yp(i-1))*diagin
  temp(i) = sdiag2*diagin
  dx1 = dx2
  dy1 = dy2
  diag1 = diag2
8 sdiag1 = sdiag2
9 diag = diag1-sdiag1*temp(nm1)
xp(n) = (slppnx-dx1-sdiag1*xp(nm1))/diag
yp(n) = (slppny-dy1-sdiag1*yp(nm1))/diag
!
! Perform back substitution
!
do 10 i = 2,n
  ibak = np1-i
  xp(ibak) = xp(ibak)-temp(ibak)*xp(ibak+1)
10 yp(ibak) = yp(ibak)-temp(ibak)*yp(ibak+1)
return
!
! Too few points
!
11 ierr = 1
return
!
! Coincident adjacent points
!
12 ierr = 2
return
end subroutine kurv1

subroutine kurv2 (t,xs,ys,n,x,y,xp,yp,s,sigma)
implicit none
integer :: i, im1
real :: c1, c2, coshp1, coshp2, d, del1, del2, delp1, delp2, dels, &
&dummy, sigmap, sinhm1, sinhm2, sinhms, sinhp1, sinhp2, sumx, sumy, &
&tn
integer :: intrvl
!
integer, intent(in) :: n
real, intent(in) :: t
real, intent(inout) :: xs, ys
real, intent(in) :: x(n), y(n), xp(n), yp(n), s(n), sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine performs the mapping of points in the
! interval (0.,1.) Onto a curve in the plane. The subroutine
! KURV1 should be called earlier to determine certain
! necessary parameters. The resulting curve has a parametric
! representation both of whose components are splines under
! tension and functions of the polygonal arclength
! parameter.
!
! On input--
!
!   T contains a real value to be mapped to a point on the
!   curve. The interval (0.,1.) Is mapped onto the entire
!   curve, with 0. Mapping to (X(1),Y(1)) and 1. Mapping
!   to (X(N),Y(N)). Values outside this interval result in
!   extrapolation.
!
!   N contains the number of points which were specified
!   to determine the curve.
!
!   X and Y are arrays containing the X- and Y-coordinates
!   of the specified points.
!
!   XP and YP are the arrays output from KURV1 containing
!   curvature information.
!
!   S is an array containing the polygonal arclengths of
!   the curve.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters N, X, Y, XP, YP, S, and sigma should be
! input unaltered from the output of KURV1.
!
! On output--
!
!   XS and YS contain the X- and Y-coordinates of the image
!   point on the curve.
!
! None of the input parameters are altered.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! Determine interval
!
tn = s(n)*t
im1 = intrvl(tn,s,n)
i = im1+1
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! Set up and perform interpolation
!
del1 = tn-s(im1)
del2 = s(i)-tn
dels = s(i)-s(im1)
sumx = (x(i)*del1+x(im1)*del2)/dels
sumy = (y(i)*del1+y(im1)*del2)/dels
if (sigmap .ne. 0.) go to 1
d = del1*del2/(6.*dels)
c1 = (del1+dels)*d
c2 = (del2+dels)*d
xs = sumx-xp(i)*c1-xp(im1)*c2
ys = sumy-yp(i)*c1-yp(im1)*c2
return
1 delp1 = sigmap*(del1+dels)/2.
delp2 = sigmap*(del2+dels)/2.
call snhcsh(sinhm1,dummy,sigmap*del1,-1)
call snhcsh(sinhm2,dummy,sigmap*del2,-1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
call snhcsh (sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh (sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh (dummy,coshp1,delp1,1)
call snhcsh (dummy,coshp2,delp2,1)
d = sigmap*sigmap*dels*(sinhms+sigmap*dels)
c1 = (sinhm1*del2-del1*(2.*(coshp1+1.)*sinhp2+sigmap* &
&coshp1*del2))/d
c2 = (sinhm2*del1-del2*(2.*(coshp2+1.)*sinhp1+sigmap* &
&coshp2*del1))/d
xs = sumx+xp(i)*c1+xp(im1)*c2
ys = sumy+yp(i)*c1+yp(im1)*c2
return
end subroutine kurv2

subroutine kurvp1 (n,x,y,xp,yp,temp,s,sigma,ierr)
implicit none
integer :: i, ibak, im1, nm1, np1, npi, npibak
real :: dels1, dels2, diag, diag1, diag2, diagin, dx1, dx2, dy1, &
&dy2, sdiag1, sdiag2, sigmap, xpn, ypn
!
integer, intent(in) :: n
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n)
real, intent(inout) :: xp(n), yp(n), temp(*), s(n)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine determines the parameters necessary to
! compute a spline under tension forming a closed curve in
! the plane and passing through a sequence of pairs
! (X(1),Y(1)),...,(X(N),Y(N)). For actual computation of
! points on the curve it is necessary to call the subroutine
! KURVP2.
!
! On input--
!
!   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
!
!   X is an array containing the N X-coordinates of the
!   points.
!
!   Y is an array containing the N Y-coordinates of the
!   points. (Adjacent X-Y pairs must be distinct, I. E.
!   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1), FOR
!   I = 1,...,N-1.)
!
!   XP and YP are arrays of length at least N.
!
!   Temp is an array of length at least 2*N which is used
!   for scratch storage.
!
!   S is an array of length at least N.
!
! And
!
!   Sigma contains the tension factor. This value indicates
!   the curviness desired. If ABS(SIGMA) is nearly zero
!   (E.G. .001) The resulting curve is approximately a cubic
!   spline. If ABS(SIGMA) is large (E. G. 50.) The resulting
!   curve is nearly a polygonal line. If sigma equals zero A
!   cubic spline results. A standard value for sigma is
!   approximately 1. In absolute value.
!
! On output--
!
!   XP and YP contain information about the curvature of the
!   curve at the given nodes.
!
!   S contains the polygonal arclengths of the curve.
!
!   IERR contains an error flag,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF ADJACENT COORDINATE PAIRS COINCIDE.
!
! And
!
!   N, X, Y, and sigma are unaltered,
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES TERMS AND
! SNHCSH.
!
!-----------------------------------------------------------
!
nm1 = n-1
np1 = n+1
ierr = 0
if (n .le. 1) go to 7
!
! Determine polygonal arclengths
!
s(1) = sqrt((x(n)-x(1))**2+(y(n)-y(1))**2)
do 1 i = 2,n
  im1 = i-1
1 s(i) = s(im1)+sqrt((x(i)-x(im1))**2+ &
&(y(i)-y(im1))**2)
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n)/s(n)
!
! Set up right hand sides of tridiagonal (with corner
! elements) linear system for XP and YP
!
dels1 = s(1)
if (dels1 .eq. 0.) go to 8
dx1 = (x(1)-x(n))/dels1
dy1 = (y(1)-y(n))/dels1
call terms(diag1,sdiag1,sigmap,dels1)
dels2 = s(2)-s(1)
if (dels2 .eq. 0.) go to 8
dx2 = (x(2)-x(1))/dels2
dy2 = (y(2)-y(1))/dels2
call terms(diag2,sdiag2,sigmap,dels2)
diag = diag1+diag2
diagin = 1./diag
xp(1) = (dx2-dx1)*diagin
yp(1) = (dy2-dy1)*diagin
temp(np1) = -sdiag1*diagin
temp(1) = sdiag2*diagin
dx1 = dx2
dy1 = dy2
diag1 = diag2
sdiag1 = sdiag2
if (n .eq. 2) go to 3
do 2 i = 2,nm1
  npi = n+i
  dels2 = s(i+1)-s(i)
  if (dels2 .eq. 0.) go to 8
  dx2 = (x(i+1)-x(i))/dels2
  dy2 = (y(i+1)-y(i))/dels2
  call terms(diag2,sdiag2,sigmap,dels2)
  diag = diag1+diag2-sdiag1*temp(i-1)
  diagin = 1./diag
  xp(i) = (dx2-dx1-sdiag1*xp(i-1))*diagin
  yp(i) = (dy2-dy1-sdiag1*yp(i-1))*diagin
  temp(npi) = -temp(npi-1)*sdiag1*diagin
  temp(i) = sdiag2*diagin
  dx1 = dx2
  dy1 = dy2
  diag1 = diag2
2 sdiag1 = sdiag2
3 dels2 = s(1)
dx2 = (x(1)-x(n))/dels2
dy2 = (y(1)-y(n))/dels2
call terms(diag2,sdiag2,sigmap,dels2)
xp(n) = dx2-dx1
yp(n) = dy2-dy1
temp(nm1) = temp(2*n-1)-temp(nm1)
if (n.eq.2) go to 5
!
! Perform first step of back substitution
!
do 4 i = 3,n
  ibak = np1-i
  npibak = n+ibak
  xp(ibak) = xp(ibak)-temp(ibak)*xp(ibak+1)
  yp(ibak) = yp(ibak)-temp(ibak)*yp(ibak+1)
4 temp(ibak) = temp(npibak)-temp(ibak)*temp(ibak+1)
5 xp(n) = (xp(n)-sdiag2*xp(1)-sdiag1*xp(nm1))/ &
&(diag1+diag2+sdiag2*temp(1)+sdiag1*temp(nm1))
yp(n) = (yp(n)-sdiag2*yp(1)-sdiag1*yp(nm1))/ &
&(diag1+diag2+sdiag2*temp(1)+sdiag1*temp(nm1))
!
! Perform second step of back substitution
!
xpn = xp(n)
ypn = yp(n)
do 6 i = 1,nm1
  xp(i) = xp(i)+temp(i)*xpn
6 yp(i) = yp(i)+temp(i)*ypn
return
!
! Too few points
!
7 ierr = 1
return
!
! Coincident adjacent points
!
8 ierr = 2
return
end subroutine kurvp1

subroutine kurvp2 (t,xs,ys,n,x,y,xp,yp,s,sigma)
implicit none
integer :: i, im1
real :: c1, c2, ci, cim1, coshp1, coshp2, d, del1, del2, delp1, &
&delp2, dels, dummy, si, sigmap, sinhm1, sinhm2, sinhms, sinhp1, &
&sinhp2, sumx, sumy, tn
integer :: intrvl
!
integer, intent(in) :: n
real, intent(in) :: t
real, intent(inout) :: xs, ys
real, intent(in) :: x(n), y(n), xp(n), yp(n), s(n), sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine performs the mapping of points in the
! interval (0.,1.) Onto a closed curve in the plane. The
! subroutine KURVP1 should be called earlier to determine
! certain necessary parameters. The resulting curve has A
! parametric representation both of whose components are
! periodic splines under tension and functions of the poly-
! gonal arclength parameter.
!
! On input--
!
!   T contains a value to be mapped onto the curve. The
!   interval (0.,1.) Is mapped onto the entire closed curve
!   with both 0. And 1. Mapping to (X(1),Y(1)). The mapping
!   is periodic with period one thus any interval of the
!   form (TT,TT+1.) Maps onto the entire curve.
!
!   N contains the number of points which were specified
!   to determine the curve.
!
!   X and Y are arrays containing the X- and Y-coordinates
!   of the specified points.
!
!   XP and YP are the arrays output from KURVP1 containing
!   curvature information.
!
!   S is an array containing the polygonal arclengths of
!   the curve.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters N, X, Y, XP, YP, S and sigma should
! be input unaltered from the output of KURVP1.
!
! On output--
!
!   XS and YS contain the X- and Y-coordinates of the image
!   point on the curve.
!
! None of the input parameters are altered.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! Determine interval
!
tn = t-float(ifix(t))
if (tn .lt. 0.) tn = tn+1.
tn = s(n)*tn+s(1)
im1 = n
if (tn .lt. s(n)) im1 = intrvl(tn,s,n)
i = im1+1
if (i .gt. n) i = 1
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n)/s(n)
!
! Set up and perform interpolation
!
si = s(i)
if (im1 .eq. n) si = s(n)+s(1)
del1 = tn-s(im1)
del2 = si-tn
dels = si-s(im1)
sumx = (x(i)*del1+x(im1)*del2)/dels
sumy = (y(i)*del1+y(im1)*del2)/dels
if (sigmap .ne. 0.) go to 1
d = del1*del2/(6.*dels)
c1 = (del1+dels)*d
c2 = (del2+dels)*d
xs = sumx-xp(i)*c1-xp(im1)*c2
ys = sumy-yp(i)*c1-yp(im1)*c2
return
1 delp1 = sigmap*(del1+dels)/2.
delp2 = sigmap*(del2+dels)/2.
call snhcsh(sinhm1,dummy,sigmap*del1,-1)
call snhcsh(sinhm2,dummy,sigmap*del2,-1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
call snhcsh (sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh (sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh (dummy,coshp1,delp1,1)
call snhcsh (dummy,coshp2,delp2,1)
d = sigmap*sigmap*dels*(sinhms+sigmap*dels)
ci = (sinhm1*del2-del1*(2.*(coshp1+1.)*sinhp2+sigmap* &
&coshp1*del2))/d
cim1 = (sinhm2*del1-del2*(2.*(coshp2+1.)*sinhp1+ &
&sigmap*coshp2*del1))/d
xs = sumx+ci*xp(i)+cim1*xp(im1)
ys = sumy+ci*yp(i)+cim1*yp(im1)
return
end subroutine kurvp2

subroutine qurv1 (n,x,y,z,slp1x,slp1y,slp1z,slpnx, &
&slpny,slpnz,islpsw,xp,yp,zp,temp, &
&s,sigma,ierr)
implicit none
integer :: i, ibak, im1, nm1, np1
real :: c1, c2, c3, dels1, dels2, delsn, delsnm, delt, diag, &
&diag1, diag2, diagin, dx1, dx2, dy1, dy2, dz1, dz2, sdiag1, &
&sdiag2, sigmap, slpp1x, slpp1y, slpp1z, slppnx, slppny, slppnz, t
!
integer, intent(in) :: n, islpsw
integer, intent(out) :: ierr
real, intent(in) :: x(n), y(n), z(n), slp1x, slp1y, slp1z, slpnx, &
&slpny, slpnz
real, intent(inout) :: xp(n), yp(n), zp(n), temp(n), s(n)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine determines the parameters necessary to
! compute a spline under tension passing through a sequence
! of triples (X(1),Y(1),Z(1)),...,(X(N),Y(N),Z(N)). The
! slopes at the two ends of the curve may be specified or
! omitted. For actual computation of points on the curve
! it is necessary to call the subroutine QURV2.
!
! On input--
!
!   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
!
!   X is an array containing the N X-coordinates of the
!   points.
!
!   Y is an array containing the N Y-coordinates of the
!   points.
!
!   Z is an array containing the N Z-coordinates of the
!   points. (Adjacent X-Y-Z triples must be distinct, I. E.
!   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1) OR Z(I) .NE.
!   Z(I+1), FOR I = 1,...,N-1 ).
!
!   SLP1X, SLP1Y, SLP1Z and SLPNX, SLPNY, SLPNZ contain the
!   desired values of the components of tangent vectors to
!   the curve at (X(1),Y(1),Z(1)) AND(X(N),Y(N),Z(N)),
!   respectively. The positive sense of the curve is assumed
!   to be that moving from point 1 to point N. The user may
!   omit values for either or both of these triples and
!   signal this with ISLPSW.
!
!   ISLPSW contains a switch indicating which slope data
!   should be used and which should be estimated by this
!   subroutine,
!          = 0 IF SLP1X, SLP1Y, SLP1Z AND SLPNX, SLPNY,
!              SLPNZ are to be used,
!          = 1 IF SLP1X, SLP1Y, SLP1Z ARE TO BE USED BUT
!              NOT SLPNX, SLPNY, SLPNZ,
!          = 2 IF SLPNX, SLPNY, SLPNZ ARE TO BE USED BUT
!              NOT SLP1X, SLP1Y, SLP1Z,
!          = 3 IF BOTH END-TANGENTS ARE TO BE ESTIMATED
!              internally.
!
!   XP, YP, and ZP are arrays of length at least N.
!
!   Temp is an array of length at least N which is used
!   for scratch storage.
!
!   S is an array of length at least N.
!
! And
!
!   Sigma contains the tension factor. This value indicates
!   the curviness desired. If ABS(SIGMA) is nearly zero
!   (E.G. .001) The resulting curve is approximately a cubic
!   spline. If ABS(SIGMA) is large (E. G. 50.) The resulting
!   curve is nearly a polygonal line. If sigma equals zero A
!   cubic spline results. A standard value for sigma is
!   approximately 1. In absolute value.
!
! On output--
!
!   XP, YP, and ZP contain information about the curvature
!   of the curve at the given nodes.
!
!   S contains the polygonal arclengths of the curve.
!
!   IERR contains an error flag,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF ADJACENT TRIPLES COINCIDE.
!
! And
!
!   N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ,
!   ISLPSW, and sigma are unaltered,
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
! AND SNHCSH.
!
!-----------------------------------------------------------
!
nm1 = n-1
np1 = n+1
ierr = 0
if (n .le. 1) go to 9
!
! Determine polygonal arclengths
!
s(1) = 0.
do 1 i = 2,n
  im1 = i-1
1 s(i) = s(im1)+sqrt((x(i)-x(im1))**2+(y(i)-y(im1))**2 &
&+(z(i)-z(im1))**2)
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! Approximate end slopes
!
if (islpsw .ge. 2) go to 2
slpp1x = slp1x
slpp1y = slp1y
slpp1z = slp1z
go to 3
2 dels1 = s(2)-s(1)
dels2 = dels1+dels1
if (n .gt. 2) dels2 = s(3)-s(1)
if (dels1 .eq. 0. .or. dels2 .eq. 0.) go to 9
call ceez (dels1,dels2,sigmap,c1,c2,c3,n)
slpp1x = c1*x(1)+c2*x(2)
slpp1y = c1*y(1)+c2*y(2)
slpp1z = c1*z(1)+c2*z(2)
if (n .eq. 2) go to 3
slpp1x = slpp1x+c3*x(3)
slpp1y = slpp1y+c3*y(3)
slpp1z = slpp1z+c3*z(3)
3 delt = sqrt(slpp1x*slpp1x+slpp1y*slpp1y+slpp1z*slpp1z)
slpp1x = slpp1x/delt
slpp1y = slpp1y/delt
slpp1z = slpp1z/delt
if (islpsw .eq. 1 .or. islpsw .eq. 3) go to 4
slppnx = slpnx
slppny = slpny
slppnz = slpnz
go to 5
4 delsn = s(n)-s(nm1)
delsnm = delsn+delsn
if (n .gt. 2) delsnm = s(n)-s(n-2)
if (delsn .eq. 0. .or. delsnm .eq. 0.) go to 10
call ceez (-delsn,-delsnm,sigmap,c1,c2,c3,n)
slppnx = c1*x(n)+c2*x(nm1)
slppny = c1*y(n)+c2*y(nm1)
slppnz = c1*z(n)+c2*z(nm1)
if (n .eq. 2) go to 5
slppnx = slppnx+c3*x(n-2)
slppny = slppny+c3*y(n-2)
slppnz = slppnz+c3*z(n-2)
5 delt = sqrt(slppnx*slppnx+slppny*slppny+slppnz*slppnz)
slppnx = slppnx/delt
slppny = slppny/delt
slppnz = slppnz/delt
!
! Set up right hand sides and tridiagonal system for XP, YP
! and ZP and perform forward elimination
!
dx1 = (x(2)-x(1))/s(2)
dy1 = (y(2)-y(1))/s(2)
dz1 = (z(2)-z(1))/s(2)
call terms (diag1,sdiag1,sigmap,s(2))
xp(1) = (dx1-slpp1x)/diag1
yp(1) = (dy1-slpp1y)/diag1
zp(1) = (dz1-slpp1z)/diag1
temp(1) = sdiag1/diag1
if (n .eq. 2) go to 7
do 6 i = 2,nm1
  dels2 = s(i+1)-s(i)
  if (dels2 .eq. 0.) go to 10
  dx2 = (x(i+1)-x(i))/dels2
  dy2 = (y(i+1)-y(i))/dels2
  dz2 = (z(i+1)-z(i))/dels2
  call terms (diag2,sdiag2,sigmap,dels2)
  diag = diag1+diag2-sdiag1*temp(i-1)
  diagin = 1./diag
  xp(i) = (dx2-dx1-sdiag1*xp(i-1))*diagin
  yp(i) = (dy2-dy1-sdiag1*yp(i-1))*diagin
  zp(i) = (dz2-dz1-sdiag1*zp(i-1))*diagin
  temp(i) = sdiag2*diagin
  dx1 = dx2
  dy1 = dy2
  dz1 = dz2
  diag1 = diag2
6 sdiag1 = sdiag2
7 diag = diag1-sdiag1*temp(nm1)
xp(n) = (slppnx-dx1-sdiag1*xp(nm1))/diag
yp(n) = (slppny-dy1-sdiag1*yp(nm1))/diag
zp(n) = (slppnz-dz1-sdiag1*zp(nm1))/diag
!
! Perform back substitution
!
do 8 i = 2,n
  ibak = np1-i
  t = temp(ibak)
  xp(ibak) = xp(ibak)-t*xp(ibak+1)
  yp(ibak) = yp(ibak)-t*yp(ibak+1)
8 zp(ibak) = zp(ibak)-t*zp(ibak+1)
return
!
! Too few points
!
9 ierr = 1
return
!
! Coincident adjacent points
!
10 ierr = 2
return
end subroutine qurv1

subroutine qurv2 (t,xs,ys,zs,n,x,y,z,xp,yp,zp,s,sigma)
implicit none
integer :: i, im1
real :: c1, c2, coshp1, coshp2, d, del1, del2, delp1, delp2, dels, &
&dummy, sigmap, sinhm1, sinhm2, sinhms, sinhp1, sinhp2, sumx, sumy, &
&sumz, tn
integer :: intrvl
!
integer, intent(in) :: n
real, intent(in) :: t
real, intent(inout) :: xs, ys, zs
real, intent(in) :: x(n), y(n), z(n), xp(n), yp(n), zp(n), s(n)
real, intent(in) :: sigma
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine performs the mapping of points in the
! interval (0.,1.) Onto a curve in space.  The subroutine
! QURV1 should be called earlier to determine certain
! necessary parameters. The resulting curve has a parametric
! representation all of whose components are splines under
! tension and functions of the polygonal arclength
! parameter.
!
! On input--
!
!   T contains a real value to be mapped to a point on the
!   curve. The interval (0.,1.) Is mapped onto the entire
!   curve, with 0. Mapping to (X(1),Y(1,Z(1)) and 1. Mapping
!   to (X(N),Y(N),Z(N)). Values outside this interval result
!   in extrapolation.
!
!   N contains the number of points which were specified
!   to determine the curve.
!
!   X, Y, and Z are arrays containing the X-, Y- and Z-
!   coordinates of the specified points.
!
!   XP, YP, and ZP are the arrays output from QURV1
!   containing curvature information.
!
!   S is an array containing the polygonal arclengths of
!   the curve.
!
! And
!
!   Sigma contains the tension factor (its sign is ignored).
!
! The parameters N, X, Y, Z, XP, YP, ZP, S, and sigma
! should be input unaltered from the output of QURV1.
!
! On output--
!
!   XS, YS and ZS contain the X-, Y- and Z-coordinates of
!   the image point on the curve.
!
! None of the input parameters are altered.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! Determine interval
!
tn = s(n)*t
im1 = intrvl(tn,s,n)
i = im1+1
!
! Denormalize tension factor
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! Set up and perform interpolation
!
del1 = tn-s(im1)
del2 = s(i)-tn
dels = s(i)-s(im1)
sumx = (x(i)*del1+x(im1)*del2)/dels
sumy = (y(i)*del1+y(im1)*del2)/dels
sumz = (z(i)*del1+z(im1)*del2)/dels
if (sigmap .ne. 0.) go to 1
d = del1*del2/(6.*dels)
c1 = (del1+dels)*d
c2 = (del2+dels)*d
xs = sumx-xp(i)*c1-xp(im1)*c2
ys = sumy-yp(i)*c1-yp(im1)*c2
zs = sumz-zp(i)*c1-zp(im1)*c2
return
1 delp1 = sigmap*(del1+dels)/2.
delp2 = sigmap*(del2+dels)/2.
call snhcsh(sinhm1,dummy,sigmap*del1,-1)
call snhcsh(sinhm2,dummy,sigmap*del2,-1)
call snhcsh(sinhms,dummy,sigmap*dels,-1)
call snhcsh (sinhp1,dummy,sigmap*del1/2.,-1)
call snhcsh (sinhp2,dummy,sigmap*del2/2.,-1)
call snhcsh (dummy,coshp1,delp1,1)
call snhcsh (dummy,coshp2,delp2,1)
d = sigmap*sigmap*dels*(sinhms+sigmap*dels)
c1 = (sinhm1*del2-del1*(2.*(coshp1+1.)*sinhp2+sigmap* &
&coshp1*del2))/d
c2 = (sinhm2*del1-del2*(2.*(coshp2+1.)*sinhp1+sigmap* &
&coshp2*del1))/d
xs = sumx+xp(i)*c1+xp(im1)*c2
ys = sumy+yp(i)*c1+yp(im1)*c2
zs = sumz+zp(i)*c1+zp(im1)*c2
return
end subroutine qurv2

subroutine ceez (del1,del2,sigma,c1,c2,c3,n)
implicit none
integer, intent(in) :: n
real :: coshm1, coshm2, del, delm, delp, denom, dummy, sinhmm, &
&sinhmp
!
real, intent(in) :: del1, del2, sigma
real, intent(inout) :: c1, c2, c3
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine determines the coefficients C1, C2, and C3
! used to determine endpoint slopes. Specifically, if
! function values Y1, Y2, and Y3 are given at points X1, X2,
! and X3, respectively, the quantity C1*Y1 + C2*Y2 + C3*Y3
! is the value of the derivative at X1 of a spline under
! tension (with tension factor sigma) passing through the
! three points and having third derivative equal to zero at
! X1. Optionally, only two values, C1 and C2 are determined.
!
! On input--
!
!   DEL1 IS X2-X1 (.GT. 0.).
!
!   DEL2 IS X3-X1 (.GT. 0.). IF N .EQ. 2, THIS PARAMETER IS
!   ignored.
!
!   Sigma is the tension factor.
!
! And
!
!   N is a switch indicating the number of coefficients to
!   BE RETURNED. IF N .EQ. 2 ONLY TWO COEFFICIENTS ARE
!   returned. Otherwise all three are returned.
!
! On output--
!
!   C1, C2, and C3 contain the coefficients.
!
! None of the input parameters are altered.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULE SNHCSH.
!
!-----------------------------------------------------------
!
if (n .eq. 2) go to 2
if (sigma .ne. 0.) go to 1
del = del2-del1
!
! TENSION .EQ. 0.
!
c1 = -(del1+del2)/(del1*del2)
c2 = del2/(del1*del)
c3 = -del1/(del2*del)
return
!
! TENSION .NE. 0.
!
1 call snhcsh (dummy,coshm1,sigma*del1,1)
call snhcsh (dummy,coshm2,sigma*del2,1)
delp = sigma*(del2+del1)/2.
delm = sigma*(del2-del1)/2.
call snhcsh (sinhmp,dummy,delp,-1)
call snhcsh (sinhmm,dummy,delm,-1)
denom = coshm1*(del2-del1)-2.*del1*(sinhmp+delp)* &
&(sinhmm+delm)
c1 = 2.*(sinhmp+delp)*(sinhmm+delm)/denom
c2 = -coshm2/denom
c3 = coshm1/denom
return
!
! Two coefficients
!
2 c1 = -1./del1
c2 = -c1
return
end subroutine ceez

subroutine terms (diag,sdiag,sigma,del)
implicit none
real :: coshm, denom, sigdel, sinhm
!
real, intent(inout) :: diag, sdiag
real, intent(in) :: sigma, del
!
!                      FROM THE SPLINE UNDER TENSION PACKAGE
!                       CODED BY A. K. CLINE AND R. J. RENKA
!                            DEPARTMENT OF COMPUTER SCIENCES
!                              UNIVERSITY OF TEXAS AT AUSTIN
!
! This subroutine computes the diagonal and superdiagonal
! terms of the tridiagonal linear system associated with
! spline under tension interpolation.
!
! On input--
!
!   Sigma contains the tension factor.
!
! And
!
!   Del contains the step size.
!
! On output--
!
!               (Sigma*del*COSH(SIGMA*DEL) - SINH(SIGMA*DEL)
!   DIAG = DEL*--------------------------------------------.
!                     (SIGMA*DEL)**2 * SINH(SIGMA*DEL)
!
!                   SINH(SIGMA*DEL) - sigma*del
!   SDIAG = DEL*----------------------------------.
!                (SIGMA*DEL)**2 * SINH(SIGMA*DEL)
!
! And
!
!   Sigma and del are unaltered.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULE SNHCSH.
!
!-----------------------------------------------------------
!
if (sigma .ne. 0.) go to 1
diag = del/3.
sdiag = del/6.
return
1 sigdel = sigma*del
call snhcsh (sinhm,coshm,sigdel,0)
denom = del/((sinhm+sigdel)*sigdel*sigdel)
diag = denom*(sigdel*coshm-sinhm)
sdiag = denom*sinhm
return
end subroutine terms

integer function intrvl (x, t, m)
implicit none
integer, intent(in) :: m
integer :: i, il, ir
real :: tm
real, intent(in) :: x, t(m)
!-----------------------------------------------------------------------
!
!             Location of a value X in a sequence T
!
!                       ----------------
!
!     Input--
!
!        X is a real number.
!
!        T is an array of nondecreasing values. It is
!          ASSUMED THAT T(1) .LT. T(M).
!
!        M IS THE LENGTH OF T (M .GE. 2).
!
!     Output--
!
!        INTRVL HAS THE VALUE I WHEN  T(I) .LE. X .LT. T(I+1).
!        OTHERWISE, IF L IS THE INTEGER WHERE T(L) .LT. T(L+1)
!        AND T(L+1) = ... = T(M), THEN INTRVL HAS THE VALUE I
!        where
!                  I = 1   IF X .LT. T(1)
!                  I = L   IF X .GE. T(L)
!
!-----------------------------------------------------------------------
if (x .lt. t(2)) go to 100
tm = t(m)
i = m - 1
10 if (t(i) .lt. tm) go to 20
   i = i - 1
   go to 10
20 if (x .ge. t(i)) go to 110
il = 2
ir = i
!
!     Bisection search
!
30 i = (il + ir)/2
if (i .eq. il) go to 110
if (x - t(i)) 40,60,50
40 ir = i
go to 30
50 il = i
go to 30
!
!     CASE WHEN X = T(I) FOR SOME I
!
60 if (x .lt. t(i+1)) go to 110
i = i + 1
go to 60
!
!     Left end
!
100 intrvl = 1
return
!
!     Normal exit
!
110 intrvl = i
return
end function intrvl

subroutine bval (t, bcoef, n, k, x, jderiv, w, wk)
implicit none
integer, intent(in) :: jderiv, k, n
real, intent(inout) :: w
real, intent(in) :: x
integer :: i, imk, ipj, j, jc, jcmax, jcmin, jdrvp1, jj, km1, kmj, &
&l, nmi, npk
real :: dl, dr, fkmj
integer :: intrvl
!-----------------------------------------------------------------------
!
!     BVAL calculates the value at X of the JDERIV-TH derivative
!     of a spline F from its B-representation.
!
!******  I N P U T ******
!
!  T     AN ARRAY OF DIMENSION N + K CONTAING THE KNOTS OF THE
!        SPLINE. IT IS ASSUMED THAT T(I) .LE. T(I+1) FOR EACH I.
!  BCOEF an array of dimension N containing the B-coefficients
!        of the spline F.
!  N     LENGTH OF BCOEF (N .GE. 1).
!  K     ORDER OF THE SPLINE.
!  X     THE POINT AT WHICH TO EVALUATE.
!  JDERIV  integer giving the order of the derivative to be
!        EVALUATED. IT IS ASSUMED THAT JDERIV .GE. 0.
!
!******  O U T P U T  ******
!
!  W     THE VALUE OF THE (JDERIV)-TH DERIVATIVE OF F AT X.
!
!******  W O R K  S P A C E ******
!
!  WK    AN ARRAY OF DIMENSION 3*K OR LARGER.
!
!******  M E T H O D  ******
!
!     THE NONTRIVIAL KNOT INTERVAL (T(I),T(I+1)) CONTAINING X IS FIRST
!  OBTAINED. THEN THE  K  B-COEFFICIENTS OF F RELEVANT FOR THIS INTERVAL
!  ARE OBTAINED FROM BCOEF (OR TAKEN TO BE ZERO IF NOT EXPLICITLY AVAIL-
!  ABLE), AND DIFFERENCED JDERIV TIMES TO OBTAIN THE B-COEFFICIENTS OF
!  (D**JDERIV)F  RELEVANT FOR THE INTERVAL. SPECIFICALLY, IF J = JDERIV
!  THEN FROM X.(12) OF THE REFERENCE WE HAVE
!
!     (D**J)F  =  SUM ( BCOEF(.,J)*B(.,K-J,T) )
!
!  Where
!                   / BCOEF(.),                     ,  J .EQ. 0
!                   /
!    BCOEF(.,J)  =  / BCOEF(.,J-1) - BCOEF(.-1,J-1)
!                   / ----------------------------- ,  J .GT. 0
!                   /    (T(.+K-J) - T(.))/(K-J)
!
!     Then, we use repeatedly the fact that
!
!    SUM ( A(.)*B(.,M,T)(X) )  =  SUM ( A(.,X)*B(.,M-1,T)(X) )
!  with
!                 (X - T(.))*A(.) + (T(.+M-1) - X)*A(.-1)
!    A(.,X)  =    ---------------------------------------
!                 (X - T(.))      + (T(.+M-1) - X)
!
!  TO WRITE (D**J)F(X) EVENTUALLY AS A LINEAR COMBINATION OF B-SPLINES
!  OF ORDER 1. THE COEFFICIENT FOR B(I,1,T)(X) MUST THEN BE THE DESIRED
!  NUMBER  (D**J)F(X). (SEE X.(17)-(19) OF THE REFERENCE).
!
!-----------------------------------------------------------------------
!  REFERENCE. DE BOOR, CARL, A PRATICAL GUIDE TO SPLINES, SPRINGER-
!  VERLAG, NEW YORK, 1978.
!-----------------------------------------------------------------------
real, intent(in) :: t(*), bcoef(n)
real, intent(inout) :: wk(k,3)
!
w = 0.0
if (jderiv .ge. k) return
!
! *** FIND I WHERE 1 .LE. I .LT. N+K  AND  T(I) .LE. X .LT. T(I+1).
!     If no such I exists, then X lies outside the support of the
!     SPLINE F AND W = 0.
!
npk = n + k
if (x .lt. t(1) .or. x .gt. t(npk)) return
i = intrvl(x, t, npk)
!
!  *** IF K = 1 (AND JDERIV = 0), W = BCOEF(I).
!
km1 = k - 1
if (km1 .gt. 0) go to 10
   w = bcoef(i)
   return
!
!  *** STORE THE K B-SPLINE COEFFICIENTS RELEVANT FOR THE KNOT INTERVAL
!     (T(I),T(I+1)) IN THE FIRST COLUMN OF WK AND COMPUTE WK(J,2) =
!     X - T(I+1-J), WK(J,3) = T(I+J) - X, J=1,...,K-1 . SET ANY OF THE
!     WK(J,1) not obtainable from input to zero. Set any T.S not obtain-
!     able equal to T(1) or to T(N+K) appropriately.
!
10 jcmin = 1
imk = i - k
if (imk .ge. 0) go to 40
!
   jcmin = 1 - imk
   l = i
   do j = 1,i
      wk(j,2) = x - t(l)
      l = l - 1
   end do
   do j = i,km1
      l = k - j
      wk(l,1) = 0.0
      wk(j,2) = wk(i,2)
   end do
   go to 60
!
40 l = i
do j = 1,km1
   wk(j,2) = x - t(l)
   l = l - 1
end do
!
60 jcmax = k
nmi = n - i
if (nmi .ge. 0) go to 100
!
   jcmax = k + nmi
   do j = 1,jcmax
      ipj = i + j
      wk(j,3) = t(ipj) - x
   end do
   do j = jcmax,km1
      wk(j+1,1) = 0.0
      wk(j,3) = wk(jcmax,3)
   end do
   go to 120
!
100 do j = 1,km1
   ipj = i + j
   wk(j,3) = t(ipj) - x
end do
!
120 do jc = jcmin,jcmax
   l = imk + jc
   wk(jc,1) = bcoef(l)
end do
!
!               *** DIFFERENCE THE COEFFICIENTS  JDERIV  TIMES.
!
if (jderiv .eq. 0) go to 170
do j = 1,jderiv
   kmj = k - j
   fkmj = kmj
   l = kmj
   do 150 jj = 1,kmj
      dl = wk(l,2)
      dr = wk(jj,3)
      wk(jj,1) = ((wk(jj+1,1) - wk(jj,1))/(dl + dr))*fkmj
150 l = l - 1
end do
!
!  *** COMPUTE VALUE AT X IN (T(I),T(I+1)) OF JDERIV-TH DERIVATIVE,
!     given its relevant B-spline coeffs in WK(1,1),...,WK(K-JDERIV,1).
!
170 if (jderiv .eq. km1) go to 200
jdrvp1 = jderiv + 1
do j = jdrvp1,km1
   kmj = k - j
   l = kmj
   do 180 jj = 1,kmj
      dl = wk(l,2)
      dr = wk(jj,3)
      wk(jj,1) = (wk(jj+1,1)*dl + wk(jj,1)*dr)/(dl + dr)
180 l = l - 1
end do
!
200 w = wk(1,1)
return
end subroutine bval

subroutine bvali (t, bcoeff, n, k, x, w, wk)
implicit none
integer, intent(in) :: k, n
real, intent(out) :: w
real, intent(in) :: x
integer :: i, ipk, kp1, np1, npk
real :: sum, tlast, tnew, xval
!-----------------------------------------------------------------------
!           Integral of a piecewise polynomial from T(1) to X
!                   using its B-spline representation
!-----------------------------------------------------------------------
!     REAL T(N + K), WK(N + 3*(K + 1))
!---------------------------
real, intent(in) :: t(*), bcoeff(n)
real, intent(inout) :: wk(*)
!
w = 0.0
if (x .le. t(1)) return
npk = n + k
tlast = t(npk)
xval = amin1(x, tlast)
!
!     Define the first new knot. The remaining new knots
!         are assumed to be the same as this knot.
!
tnew = 0.1
if (tlast .lt. -0.1) tnew = 0.9*tlast
if (tlast .gt.  0.0) tnew = 1.1*tlast
!
!     Compute the first N coefficients of the antiderivative
!
sum = 0.0
do i = 1,n
   ipk = i + k
   sum = sum + bcoeff(i)*(t(ipk) - t(i))
   wk(i) = sum/k
end do
!
!     Compute the antiderivative
!
kp1 = k + 1
np1 = n + 1
call bvali0 (t, tnew, wk(1), n, kp1, xval, w, wk(np1))
return
end subroutine bvali

subroutine bvali0 (t, tnew, bcoef, n, k, x, w, wk)
implicit none
integer, intent(in) :: k, n
real, intent(in) :: tnew
real, intent(out) :: w
real, intent(in) :: x
integer :: i, imk, ipj, j, jc, jcmin, jj, km1, kmj, l, m
real :: dl, dr, tipj
integer :: intrvl
!-----------------------------------------------------------------------
!
!     BVALI0 calculates the value at X of an antiderivative
!     OF A B-SPLINE F FOR T(1) .LE. X .LE. T(N + K - 1).
!
!******  I N P U T ******
!
!  T     AN ARRAY CONTAINING THE FIRST N + K - 1 KNOTS OF THE
!        antiderivative.
!  TNEW  the remaing knots are all located at this point.
!  BCOEF an array containing the first N coefficients of the
!        antiderivative.
!  N     LENGTH OF BCOEF (N .GE. 1).
!  K     ORDER OF THE ANTIDERIVATIVE.
!  X     THE POINT AT WHICH TO EVALUATE.
!
!******  O U T P U T  ******
!
!  W     THE VALUE OF THE ANTIDERIVATIVE AT X.
!
!******  W O R K  S P A C E ******
!
!  WK    AN ARRAY OF DIMENSION 3*K OR LARGER.
!
!-----------------------------------------------------------------------
!     Remark. BVALI0 is an adaptation by A.H. Morris (NSWC) of the
!     SUBROUTINE BVAL.
!-----------------------------------------------------------------------
real, intent(in) :: t(*), bcoef(n)
real, intent(inout) :: wk(k,3)
!
w = 0.0
km1 = k - 1
m = n + km1
i = intrvl(x, t, m)
!
!  *** STORE THE K B-SPLINE COEFFICIENTS RELEVANT FOR THE KNOT INTERVAL
!     (T(I),T(I+1)) IN THE FIRST COLUMN OF WK AND COMPUTE WK(J,2) =
!     X - T(I+1-J), WK(J,3) = T(I+J) - X, J=1,...,K-1 . SET ANY OF THE
!     WK(J,1) not obtainable from input to zero. Set any T.S not obtain-
!     able equal to T(1) or TNEW appropriately.
!
jcmin = 1
imk = i - k
if (imk .ge. 0) go to 30
!
   jcmin = 1 - imk
   l = i
   do j = 1,i
      wk(j,2) = x - t(l)
      l = l - 1
   end do
   do j = i,km1
      l = k - j
      wk(l,1) = 0.0
      wk(j,2) = wk(i,2)
   end do
   go to 50
!
30 l = i
do j = 1,km1
   wk(j,2) = x - t(l)
   l = l - 1
end do
!
50 do j = 1,km1
   tipj = tnew
   ipj = i + j
   if (ipj .le. m) tipj = t(ipj)
   wk(j,3) = tipj - x
end do
!
do jc = jcmin,k
   l = min0(imk + jc, n)
   wk(jc,1) = bcoef(l)
end do
!
!  *** COMPUTE VALUE AT X IN (T(I),T(I+1)), GIVEN ITS RELEVANT
!     B-spline coeffs in WK(1,1),...,WK(K,1).
!
do j = 1,km1
   kmj = k - j
   l = kmj
   do 100 jj = 1,kmj
      dl = wk(l,2)
      dr = wk(jj,3)
      wk(jj,1) = (wk(jj+1,1)*dl + wk(jj,1)*dr)/(dl + dr)
100 l = l - 1
end do
!
w = wk(1,1)
return
end subroutine bvali0

subroutine bspp (t, a, n, k, break, c, l, wk)
implicit none
integer, intent(in) :: k
integer, intent(out) :: l
integer, intent(in) :: n
integer :: i, il, ilj, ilkj, j, jj, jp1, km1, kmj, kp1, left
real :: diff, r, s, term, x
!-----------------------------------------------------------------------
!
!              CONVERSION FROM B-SPLINE REPRESENTATION
!              TO PIECEWISE POLYNOMIAL REPRESENTATION
!
!
!     Input ...
!
!       T     KNOT SEQUENCE OF LENGTH N+K
!       A     B-SPLINE COEFFICIENT SEQUENCE OF LENGTH N
!       N     LENGTH OF A
!       K     ORDER OF THE B-SPLINES
!
!     Output ...
!
!       Break breakpoint sequence, of length L+1, containing
!             (in increasing order) the distinct points of the
!             SEQUENCE T(K),...,T(N+1).
!       C     KXL MATRIX WHERE C(I,J) = (I-1)ST RIGHT DERIVATIVE
!             of the PP at BREAK(J) divided by FACTORIAL(I-1).
!       L     NUMBER OF POLYNOMIALS WHICH FORM THE PP
!
!     Work area ...
!
!       WK    2-DIMENSIONAL ARRAY OF DIMENSION (K,K+1)
!
!-----------------------------------------------------------------------
real, intent(in) :: t(*), a(n)
real, intent(inout) :: break(*), c(k,*), wk(k,*)
!
l = 0
break(1) = t(k)
if (k .eq. 1) go to 100
km1 = k - 1
kp1 = k + 1
!
!          General K-TH order case
!
do 60 left = k,n
   if (t(left) .eq. t(left + 1)) go to 60
   l = l + 1
   break(l + 1) = t(left + 1)
   do j = 1,k
      jj = left - k + j
      wk(j,1) = a(jj)
   end do
!
   do j = 1,km1
      jp1 = j + 1
      kmj = k - j
      do i = 1,kmj
         il = i + left
         ilkj = il - kmj
         diff = t(il) - t(ilkj)
         wk(i,jp1) = (wk(i+1,j) - wk(i,j))/diff
      end do
   end do
!
   wk(1,kp1) = 1.0
   x = t(left)
   c(k,l) = wk(1,k)
   r = 1.0
   do j = 1,km1
      jp1 = j + 1
      s = 0.0
      do i = 1,j
         il = i + left
         ilj = il - j
         term = wk(i,kp1)/(t(il) - t(ilj))
         wk(i,kp1) = s + (t(il) - x)*term
         s = (x - t(ilj))*term
      end do
      wk(jp1,kp1) = s
!
      s = 0.0
      kmj = k - j
      do i = 1,jp1
         s = s + wk(i,kmj)*wk(i,kp1)
      end do
      r = (r*float(kmj))/float(j)
      c(kmj,l) = r*s
   end do
60 continue
return
!
!          Piecewise constant case
!
100 do 110 left = k,n
   if (t(left) .eq. t(left + 1)) go to 110
   l = l + 1
   break(l + 1) = t(left + 1)
   c(1,l) = a(left)
110 continue
return
end subroutine bspp

subroutine ppval (x, a, l, n, xi, yi, ni)
implicit none
integer, intent(in) :: l, n, ni
real :: a(l,n), x(n), xi(ni)
real, intent(inout) :: yi(ni)
integer :: i, il, ir, j, k, lm1, lmj
real :: dx, s, xx
!-----------------------------------------------------------------------
!
!         This routine evaluates a piecewise polynomial at the
!         abscissas in xi. It is assumed that the coefficients
!         of the polynomials which form the PP are given.
!
!       --Input--
!
!         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!               that define the PP.
!         A   - MATRIX THAT CONTAINS THE COEFFICIENTS OF THE POLY-
!               NOMIALS  WHICH FORM THE PP. IF I = 1,...,N THEN THE
!               PP has the value
!                    A(1,I) + A(2,I)*DX + ... + A(L,I)*DX**(L-1)
!               FOR X(I) .LE. XX .LT. X(I+1).  HERE DX = XX - X(I).
!         L   - ORDER OF THE PIECEWISE POLYNOMIAL.
!         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE PP.
!               N must be greater than or equal to 1.
!         Xi  - the array of abscissas (in arbitrary order) at which
!               at which the PP is to be evaluated.
!         NI  - the dimension of the arrays xi and YI. It is assumed
!               that NI is greater than or equal to 1.
!
!       --Output--
!
!         YI  - array of values of the PP at the points in xi.
!
!-----------------------------------------------------------------------
!
!     K is index on value of xi being worked on.  XX is that value.
!     I is the current index in the X array.
!
k  = 1
xx = xi(1)
lm1 = l - 1
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
il = 1
ir = n
!
!     Bisection search
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     Linear forward search
!
40 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 40
!
!     XX is greater than X(N) or less than X(1)
!
80 i = n
go to 100
90 i = 1
!
!     Evaluation
!
100 dx = xx - x(i)
s = a(l,i)
if (l .eq. 1) go to 120
do j = 1,lm1
   lmj = l - j
   s = a(lmj,i) + dx*s
end do
120 yi(k) = s
!
!     Next point
!
if (k .ge. ni) return
k = k + 1
xx = xi(k)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
if (xx - xi(k-1)) 130,120,40
130 il = 1
ir = min0(i + 1, n)
go to 10
end subroutine ppval

subroutine bspvb (t, k, jhigh, j, x, left, blist)
implicit none
integer, intent(inout) :: j
integer, intent(in) :: jhigh, k, left
real, intent(in) :: x
integer :: i, imj, l
real :: s, term, ti, timj
!-----------------------------------------------------------------------
!
!     BSPVB calculates the value of all possibly nonzero B-splines
!     AT X OF ORDER MAX(JHIGH,J + 1) WHERE T(K) .LE. X .LT. T(N+1).
!
!     Description of arguments
!
!         Input
!
!          T       - KNOT VECTOR OF LENGTH N + K.
!          K       - HIGHEST POSSIBLE ORDER OF THE B-SPLINES.
!          JHIGH   - ORDER OF B-SPLINES (1 .LE. JHIGH .LE. K).
!          J       - J .LE. 0  GIVES B-SPLINES OF ORDER JHIGH.
!                    J .GE. 1  ON A PREVIOUS CALL TO BSPVB THE
!                              B-splines of order J were com-
!                              puted and stored in BLIST. It is
!                              assumed that work has not been
!                              MODIFIED AND THAT J .LT. K.
!          X       - ARGUMENT OF THE B-SPLINES.
!          LEFT    - LARGEST INTEGER SUCH THAT
!                    T(LEFT) .LE. X .LT. T(LEFT+1)
!
!         Output
!
!          BLIST   - VECTOR OF LENGTH K FOR SPLINE VALUES.
!          J       - B-SPLINES OF ORDER J HAVE BEEN COMPUTED
!                    and stored in BLIST.
!
!-----------------------------------------------------------------------
!     WRITTEN BY CARL DE BOOR (UNIVERSITY OF WISCONSIN) AND MODIFIED
!         BY A.H. MORRIS (NSWC).
!-----------------------------------------------------------------------
real, intent(in) :: t(*)
real, intent(inout) :: blist(k)
!
if (j .gt. 0) go to 10
   j = 1
   blist(1) = 1.0
   if (j .ge. jhigh) return
!
10 s = 0.0
do l = 1,j
   i = left + l
   imj = i - j
   timj = t(imj)
   ti = t(i)
   term = blist(l)/(ti - timj)
   blist(l) = s + (ti - x)*term
   s = (x - timj)*term
end do
j = j + 1
blist(j) = s
if (j .lt. jhigh) go to 10
!
return
end subroutine bspvb

subroutine bspvd (t, k, x, left, dbiatx, idim, nderiv, a)
implicit none
integer, intent(in) :: idim, k, left, nderiv
real, intent(in) :: x
integer :: i, ideriv, il, j, jj, jlow, jp1mid, kp1, kp1mm, l, &
&ldummy, m, mhigh
real :: factor, fkp1mm, sum
!-----------------------------------------------------------------------
!
! Calculates value and deriv.S of all B-splines which do not vanish at X
!
!******  I N P U T  ******
!
!  T     THE KNOT ARRAY, OF LENGTH LEFT+K (AT LEAST)
!  K     THE ORDER OF THE B-SPLINES TO BE EVALUATED
!  X     THE POINT AT WHICH THESE VALUES ARE SOUGHT
!  left  an integer indicating the left endpoint of the interval of
!        interest. The  K  B-splines whose support contains the interval
!               (T(LEFT), T(LEFT+1))
!        are to be considered.
!  A S S U M P T I O N  - - -  it is assumed that
!               T(LEFT) .LT. T(LEFT+1)
!        division by zero will result otherwise (in  B S P V B ).
!        Also, the output is as advertised only if
!               T(LEFT) .LE. X .LE. T(LEFT+1) .
!  IDIM  the row dimension of the matrix DBIATX. If is assumed that
!        IDIM .GE. K .
!  NDERIV  an integer indicating that values of B-splines and their
!        derivatives up to but not including the  NDERIV-TH  are asked
!        for. (NDERIV is replaced internally by the integer  M H I G H
!        in (1,K) closest to it.)
!
!******  O U T P U T  ******
!
!  DBIATX  an array of order (IDIM,NDERIV). Its entry (I,M) contains
!        value of  (M-1)ST  derivative of  (LEFT-K+I)-TH  B-spline of
!        ORDER  K  FOR KNOT SEQUENCE  T , I=M,...,K, M=1,...,NDERIV.
!
!******  W O R K   A R E A  ******
!
!  A     AN ARRAY OF ORDER (K,K), TO CONTAIN B-COEFF.S OF THE DERIVA-
!        tives of a certain order of the  K  B-splines of interest.
!
!******  M E T H O D  ******
!
!  Values at  X  of all the relevant B-splines of order K,K-1,...,
!  K+1-NDERIV  are generated via BSPVB and stored temporarily in
!  DBIATX. Then the B-coeffs of the required derivatives of the B-
!  splines of interest are generated by differencing, each from the pre-
!  ceding one of lower order, and combined with the values of B-splines
!  of corresponding order in  DBIATX  to produce the desired values .
!
!-----------------------------------------------------------------------
!  WRITTEN BY CARL DE BOOR (UNIVERSITY OF WISCONSIN) AND MODIFIED
!     BY A.H. MORRIS (NSWC).
!-----------------------------------------------------------------------
real, intent(in) :: t(*)
real, intent(inout) :: dbiatx(idim,nderiv), a(k,k)
!
mhigh = max0(min0(nderiv,k),1)
!     MHIGH is usually equal to NDERIV.
kp1 = k + 1
jj = 0
call bspvb (t, k, kp1 - mhigh, jj, x, left, dbiatx)
if (mhigh .eq. 1) return
!
!     The first column of DBIATX always contains the B-spline values
!     for the current order. These are stored in column K+1-current
!     order  before  BSPVB  is called to put values for the next
!     higher order on top of it.
!
ideriv = mhigh
do m = 2,mhigh
   jp1mid = 1
   do 10 j = ideriv,k
      dbiatx(j,ideriv) = dbiatx(jp1mid,1)
10 jp1mid = jp1mid + 1
   ideriv = ideriv - 1
   call bspvb (t, k, kp1 - ideriv, jj, x, left, dbiatx)
end do
!
!     At this point, B(LEFT-K+I, K+1-J)(X) is in DBIATX(I,J) for
!     I = J,...,K AND J = 1,...,MHIGH. IN PARTICULAR, THE FIRST
!     column of DBIATX is already in final form. To obtain cor-
!     responding derivatives of B-splines in subsequent columns,
!     generate their B-repr. By differencing. Then evaluate at X.
!
jlow = 1
do 20 i = 1,k
   do 19 j = jlow,k
19 a(j,i) = 0.0
   jlow = i
20 a(i,i) = 1.0
!
!     At this point, A(.,J) contains the B-coeffs for the J-TH of the
!     K  B-splines of interest here.
!
do m = 2,mhigh
   kp1mm = kp1 - m
   fkp1mm = float(kp1mm)
   il = left
   i = k
!
!        FOR J = 1,...,K, CONSTRUCT B-COEFFS OF (M-1)ST  DERIVATIVE OF
!        B-splines from those for preceding derivative by differencing
!        AND STORE AGAIN IN  A(.,J) . THE FACT THAT  A(I,J) = 0  FOR
!        I .LT. J  IS USED.
!
   do ldummy = 1,kp1mm
      l = il + kp1mm
      factor = fkp1mm/(t(l) - t(il))
!
!           THE ASSUMPTION THAT T(LEFT).LT.T(LEFT+1) MAKES DENOMINATOR
!           in the factor nonzero.
!
      do 25 j = 1,i
25 a(i,j) = (a(i,j) - a(i-1,j))*factor
      il = il - 1
      i = i - 1
   end do
!
!        FOR I = 1,...,K, COMBINE B-COEFFS A(.,I) WITH B-SPLINE VALUES
!        stored in DBIATX(.,M) to get value of  (M-1)ST  derivative of
!        I-TH B-spline (of interest here) at X, and store in
!        DBIATX(I,M). Storage of this value over the value of A B-spline
!        of order M there is safe since the remaining B-spline derivat-
!        ives of the same order do not use this value due to the fact
!        THAT  A(J,I) = 0  FOR J .LT. I .
!
   do i = 1,k
      sum = 0.0
      jlow = max0(i,m)
      do 35 j = jlow,k
35 sum = a(j,i)*dbiatx(j,m) + sum
      dbiatx(i,m) = sum
   end do
end do
return
end subroutine bspvd

subroutine bstrp (tau, gtau, t, n, k, bcoef, q, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: k, n
integer :: i, ilp1mx, j, jj, km1, kpkm2, left, lenq, np1
real :: taui
!-----------------------------------------------------------------------
!   This routine produces the B-spline COEFF.S BCOEF of the piecewise
!   POLYNOMIAL OF ORDER K WITH KNOTS T(I) (I=1,...,N+K) WHICH HAS THE
!   VALUE GTAU(I) AT TAU(I) FOR I=1,...,N.
!
!******  I N P U T  ******
!
!  Tau.....array of length  N , containing data point abscissae.
!    A S S U M P T I O N . . .  Tau  is strictly increasing
!  GTAU.....corresponding array of length  N , containing data point
!        ordinates.
!  T.....knot sequence, of length  N+K
!  N.....number of data points and dimension of spline space  S(K,T)
!  K.....order of the piecewise polynomial
!  IFLAG.....on an initial call to the routine, IFLAG may be assigned
!        any value except 0. The routine may be recalled when only GTAU
!        IS MODIFIED. IFLAG=0 WHEN THIS IS DONE.
!
!******  O U T P U T  ******
!
!  BCOEF.....the B-coefficients of the interpolant, of length  N
!  Q.....array of size  (2*K-1)*N , containing the triangular factoriz-
!        ation of the coefficient matrix of the linear system for the B-
!        coefficients of the spline interpolant.
!  IFLAG.....AN INTEGER INDICATING SUCCESS (= 0)  OR FAILURE (= 1)
!        the linear system to be solved is (theoretically) invertible if
!        and only if
!              B(I)(TAU(I)) .NE. 0   FOR ALL I.
!        VIOLATION OF THIS CONDITION IS CERTAIN TO LEAD TO IFLAG = 1.
!
!******  M E T H O D  ******
!
!     THE I-TH EQUATION OF THE LINEAR SYSTEM  A*BCOEF = B  FOR THE B-CO-
!  EFFS OF THE INTERPOLANT ENFORCES INTERPOLATION AT  TAU(I), I=1,...,N.
!  HENCE,  B(I) = GTAU(I), ALL I, AND  A  IS A BAND MATRIX WITH  2K-1
!  bands (if it is invertible).
!     The matrix  A  is generated row by row and stored, diagonal by DI-
!  agonal, in the  R O W S  of the array  Q , with the main diagonal go-
!  ing into row  K .  See comments in the program below.
!     The banded system is then solved by a call to BANFAC (which con-
!  structs the triangular factorization for  A  and stores it in  Q),
!  followed by a call to BANSLV (which then obtains the solution BCOEF
!  by substitution).
!     BANFAC performs no pivoting since the total positivity of the
!  matrix A makes this unnecessary.
!-----------------------------------------------------------------------
real, intent(inout) :: bcoef(n)
real, intent(in) :: gtau(n)
real, intent(inout) :: q(*)
real, intent(in) :: t(*), tau(n)
!
km1 = k - 1
if (iflag .eq. 0) go to 60
np1 = n + 1
kpkm2 = 2*km1
if (n .eq. 1) go to 20
!
!        Check if TAU(I) is an increasing sequence
!
do i = 2,n
   if (tau(i) .le. tau(i-1)) go to 100
end do
!
!                Zero out all entries of Q
!
20 if (tau(n) .gt. t(np1)) go to 100
lenq = n*(k + km1)
do i = 1,lenq
   q(i) = 0.0
end do
!
!  ***   LOOP OVER I TO CONSTRUCT THE N INTERPOLATION EQUATIONS
!
left = k
do i = 1,n
   taui = tau(i)
   ilp1mx = min0(i + k,np1)
!
!        *** FIND  LEFT  IN THE CLOSED INTERVAL (I,I+K-1) SUCH THAT
!                T(LEFT) .LE. TAU(I) .LT. T(LEFT+1)
!        matrix is singular if this is not possible
!
   left = max0(left,i)
   if (taui .lt. t(left)) go to 100
30 if (taui .lt. t(left+1)) go to 40
      left = left + 1
      if (left .lt. ilp1mx) go to 30
   if (left .eq. i + k) go to 100
   left = n
!
!        *** THE I-TH EQUATION ENFORCES INTERPOLATION AT TAUI, HENCE
!        A(I,J) = B(J,K,T)(TAUI), ALL J. ONLY THE  K  ENTRIES WITH  J =
!        left-K+1,...,left actually might be nonzero. These  K  numbers
!        are returned, in  BCOEF (used for temp.Storage here), by the
!        following
!
40 jj = 0
   call bspvb (t, k, k, jj, taui, left, bcoef)
!
!        Let Q denote a two-dimensional array of dimension (2*K-1,N).
!        WE THEREFORE WANT  BCOEF(J) = B(LEFT-K+J)(TAUI) TO GO INTO
!        A(I,LEFT-K+J), I.E., Into  Q(I-(LEFT+J)+2*K,(LEFT+J)-K) since
!        A(I+J,J)  is to go into  Q(I+K,J), all I,J.  In the current
!        routine we treat Q as an equivalent one-dimensional array.
!        Thus we want BCOEF(J) to be inserted into entry
!            I - (LEFT+J) + 2*K + ((left+J) - K-1)*(2*K-1)
!                   =  I-LEFT+1 + (LEFT - K)*(2*K-1) + (2*K-2)*J
!        OF  Q .
!
   jj = i - left + 1 + (left - k)*(k + km1)
   do j = 1,k
      jj = jj + kpkm2
      q(jj) = bcoef(j)
   end do
end do
!
!     ***OBTAIN FACTORIZATION OF  A  , STORED AGAIN IN  Q.
!
call banfac (q, k + km1, n, km1, km1, iflag)
iflag = iflag - 1
if (iflag .ne. 0) return
!
!     *** SOLVE  A*BCOEF = GTAU  BY BACKSUBSTITUTION
!
60 do i = 1,n
   bcoef(i) = gtau(i)
end do
call banslv (q, k + km1, n, km1, km1, bcoef)
return
!
!     *** ERROR RETURN
!
100 iflag = 1
return
end subroutine bstrp

subroutine banfac ( w, nroww, nrow, nbandl, nbandu, iflag )
implicit none
integer, intent(out) :: iflag
integer, intent(in) :: nbandl, nbandu, nrow, nroww
integer :: i, ipk, j, jbeg, jend, jmax, k, kmax, mdj, middle, &
&midmk, mj, nrowm1
!  From  * a practical guide to splines *  by C. DE boor
!  returns in  W  the LU-factorization (without pivoting) of the banded
!  matrix  A  of order  NROW  with  (NBANDL + 1 + NBANDU) bands or diag-
!  onals in the work array  W .
!
!******  I N P U T  ******
!  W.....work array of size  (NROWW,NROW)  containing the interesting
!        part of A banded matrix  A , with the diagonals or bands of  A
!        stored in the rows of  W , while columns of  a  correspond to
!        columns of  W . This is the storage mode used in  LINPACK  and
!        results in efficient innermost loops.
!           Explicitly,  A  has  NBANDL  bands below the diagonal
!                            +     1     (MAIN) DIAGONAL
!                            +   NBANDU  BANDS ABOVE THE DIAGONAL
!        AND THUS, WITH    MIDDLE = NBANDU + 1,
!          A(I+J,J)  IS IN  W(I+MIDDLE,J)  FOR I=-NBANDU,...,NBANDL
!                                              J=1,...,NROW .
!        For example, the interesting entries of A (1,2)-banded matrix
!        OF ORDER  9  WOULD APPEAR IN THE FIRST  1+1+2 = 4  ROWS OF  W
!        as follows.
!                          13 24 35 46 57 68 79
!                       12 23 34 45 56 67 78 89
!                    11 22 33 44 55 66 77 88 99
!                    21 32 43 54 65 76 87 98
!
!        All other entries of  W  not identified in this way with an EN-
!        try of  A  are never referenced .
!  NROWW.....row dimension of the work array  W .
!        MUST BE  .GE.  NBANDL + 1 + NBANDU  .
!  NBANDL.....number of bands of  a  below the main diagonal
!  NBANDU.....number of bands of  a  above the main diagonal .
!
!******  O U T P U T  ******
!  IFLAG.....INTEGER INDICATING SUCCESS( = 1) OR FAILURE ( = 2) .
!     IF  IFLAG = 1, THEN
!  W.....contains the LU-factorization of  a  into a unit lower triangu-
!        lar matrix  L  and an upper triangular matrix  U (both banded)
!        and stored in customary fashion over the corresponding entries
!        of  A . This makes it possible to solve any particular linear
!        SYSTEM  A*X = B  FOR  X  BY A
!              CALL BANSLV ( W, NROWW, NROW, NBANDL, NBANDU, B )
!        with the solution X  contained in  B  on return .
!     IF  IFLAG = 2, THEN
!        one of  NROW-1, NBANDL,NBANDU failed to be nonnegative, or else
!        one of the potential pivots was found to be zero indicating
!        that  a  does not have an LU-factorization. This implies that
!        A  is singular in case it is totally positive .
!
!******  M E T H O D  ******
!     Gauss elimination  W I T H O U T  pivoting is used. The routine is
!  intended for use with matrices  A  which do not require row inter-
!  changes during factorization, especially for the  T O T A L L Y
!  P O S I T I V E  matrices which occur in spline calculations.
!     The routine should not be used for an arbitrary banded matrix.
!
real, intent(inout) :: w(nroww,nrow)
real :: factor, pivot
!
iflag = 1
middle = nbandu + 1
!                         W(MIDDLE,.) Contains the main diagonal of  A .
nrowm1 = nrow - 1
if (nrowm1)                       999,900,1
1 if (nbandl .gt. 0)                go to 10
!                A is upper triangular. Check that diagonal is nonzero .
do i=1,nrowm1
   if (w(middle,i) .eq. 0.)       go to 999
   end do
                                  go to 900
10 if (nbandu .gt. 0)                go to 20
!              A is lower triangular. Check that diagonal is nonzero and
!                 divide each column by its diagonal .
do 15 i = 1,nrowm1
   pivot = w(middle,i)
   if(pivot .eq. 0.)              go to 999
   jmax = min0(nbandl, nrow - i)
   jbeg = middle + 1
   jend = middle + jmax
   do 15 j = jbeg,jend
15 w(j,i) = w(j,i)/pivot
                                  go to 900
!
!        A  is not just a triangular matrix. Construct LU factorization
20 do i=1,nrowm1
!                                  W(MIDDLE,I)  is pivot for I-TH step .
   pivot = w(middle,i)
   if (pivot .eq. 0.)             go to 999
!                 JMAX  is the number of (nonzero) entries in column  I
!                     below the diagonal .
   jmax = min0(nbandl,nrow - i)
!              Divide each entry in column  I  below diagonal by pivot .
   jbeg = middle + 1
   jend = middle + jmax
   do 32 j = jbeg,jend
32 w(j,i) = w(j,i)/pivot
!                 KMAX  is the number of (nonzero) entries in row  I  to
!                     the right of the diagonal .
   kmax = min0(nbandu,nrow - i)
!                  Subtract  A(I,I+K)*(I-TH column) from (I+K)-TH column
!                  (below row  I ) .
   do 40 k = 1,kmax
      ipk = i + k
      midmk = middle - k
      factor = w(midmk,ipk)
      do 40 j = 1,jmax
         mj = middle + j
         mdj = midmk + j
40 w(mdj,ipk) = w(mdj,ipk) - w(mj,i)*factor
   end do
!                                       Check the last diagonal entry .
900 if (w(middle,nrow) .ne. 0.)       return
999 iflag = 2
                                  return
end subroutine banfac

subroutine banslv ( w, nroww, nrow, nbandl, nbandu, b )
implicit none
integer, intent(in) :: nbandl, nbandu, nrow, nroww
integer :: i, imj, ipj, j, jmax, middle, mmj, mpj, nrowm1
!  From  * a practical guide to splines *  by C. DE boor
!  companion routine to  BANFAC . It returns the solution  X  of the
!  LINEAR SYSTEM  A*X = B  IN PLACE OF  B , GIVEN THE LU-FACTORIZATION
!  for  A  in the workarray  W .
!
!******  I N P U T  ******
!  W, NROWW,NROW,NBANDL,NBANDU.....describe the LU-factorization of A
!        banded matrix  A  of roder  NROW  as constructed in  BANFAC .
!        For details, see  BANFAC .
!  B.....right side of the system to be solved .
!
!******  O U T P U T  ******
!  B.....contains the solution  X , of order  NROW .
!
!******  M E T H O D  ******
!     (WITH  A = L*U, AS STORED IN  W,) THE UNIT LOWER TRIANGULAR SYSTEM
!  L(U*X) = B  IS SOLVED FOR  Y = U*X, AND  Y  STORED IN  B . THEN THE
!  UPPER TRIANGULAR SYSTEM  U*X = Y  IS SOLVED FOR  X  . THE CALCUL-
!  ations are so arranged that the innermost loops stay within columns.
!
real, intent(in) :: w(nroww,nrow)
real, intent(inout) :: b(nrow)
middle = nbandu + 1
if (nrow .eq. 1)                  go to 49
nrowm1 = nrow - 1
if (nbandl .eq. 0)                go to 30
!                                 Forward pass
!            FOR I=1,2,...,NROW-1, SUBTRACT  RIGHT SIDE(I)*(I-TH COLUMN
!            of  L )  from right side  (below I-TH row) .
do 21 i = 1,nrowm1
   jmax = min0(nbandl, nrow-i)
   do 21 j = 1,jmax
      ipj = i + j
      mpj = middle + j
21 b(ipj) = b(ipj) - b(i)*w(mpj,i)
!                                 Backward pass
!            FOR I=NROW,NROW-1,...,1, DIVIDE RIGHT SIDE(I) BY I-TH DIAG-
!            onal entry of  U, then subtract  right SIDE(I)*(I-TH column
!            of  U)  from right side  (above I-TH row).
30 if (nbandu .gt. 0)                go to 40
!                                A  is lower triangular .
do 31 i = 1,nrow
31 b(i) = b(i)/w(1,i)
                                  return
40 i = nrow
41 b(i) = b(i)/w(middle,i)
   jmax = min0(nbandu,i-1)
   do 45 j = 1,jmax
      imj = i - j
      mmj = middle - j
45 b(imj) = b(imj) - b(i)*w(mmj,i)
   i = i - 1
   if (i .gt. 1)                  go to 41
49 b(1) = b(1)/w(middle,1)
                                  return
end subroutine banslv

subroutine bslsq (tau, gtau, wgt, ntau, t, n, k, a, wk, q, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: k, n, ntau
integer :: i, j, jj, l, left, leftmk, mm
real :: dw
!-----------------------------------------------------------------------
!
!        BSLSQ produces the B-spline coefficients of a piecewise
!              polynomial P(X) of order K which minimizes
!
!                SUM (WGT(J)*(P(TAU(J)) - GTAU(J))**2).
!
!
!     Input ...
!
!       TAU   ARRAY OF LENGTH NTAU CONTAINING DATA POINT ABSCISSAE.
!       GTAU  array of length NTAU containing data point ordinates.
!       WGT   ARRAY OF LENGTH NTAU CONTAINING THE WEIGHTS.
!       NTAU  number of data points to be fitted.
!       T     KNOT SEQUENCE OF LENGTH N + K.
!       N     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!       K     ORDER OF THE B-SPLINES.
!
!     Output ...
!
!       A     ARRAY OF LENGTH N CONTAINING THE B-SPLINE COEFFICIENTS
!             of the L2 approximation.
!
!       IERR  integer reporting the status of the results ...
!
!             0  The coefficient matrix is nonsigular. The
!                unique least squares solution was obtained.
!             1  The coefficient matrix is singular. A
!                least squares solution was obtained.
!            -1  Input errors were detected.
!
!-----------------------------------------------------------------------
real, intent(in) :: tau(ntau), gtau(ntau), wgt(ntau)
real, intent(in) :: t(*)
real, intent(inout) :: a(n), wk(n), q(k,n)
!
if (ntau .lt. max0(2,k)) go to 100
if (tau(1) .lt. t(k) .or. tau(ntau) .gt. t(n + 1)) go to 100
!
do i = 2,ntau
   if (tau(i - 1) .gt. tau(i)) go to 100
end do
!
do j = 1,n
   a(j) = 0.0
   do i = 1,k
      q(i,j) = 0.0
   end do
end do
!
left = k
do l = 1,ntau
!
!        *** FIND THE INDEX LEFT SUCH THAT
!            T(LEFT) .LE. TAU(L) .LT. T(LEFT+1)
!
30 if (left .eq. n) go to 40
      if (tau(l) .lt. t(left+1)) go to 40
      left = left + 1
      go to 30
!
40 jj = 0
   call bspvb (t, k, k, jj, tau(l), left, wk)
!
   leftmk = left - k
   do mm = 1,k
      dw = wk(mm)*wgt(l)
      j = leftmk + mm
      a(j) = dw*gtau(l) + a(j)
      i = 1
      do jj = mm,k
         q(i,j) = wk(jj)*dw + q(i,j)
         i = i + 1
      end do
   end do
end do
!
!        Solve the normal equations
!
call bchfac (q, k, n, wk, ierr)
call bchslv (q, k, n, a)
return
!
!             Error return
!
100 ierr = -1
return
end subroutine bslsq

subroutine bchfac (w, nb, n, diag, iflag)
implicit none
integer, intent(inout) :: iflag
integer, intent(in) :: n, nb
integer :: i, imax, ipj, j, jmax, k, kpi
real :: ratio, t
!-----------------------------------------------------------------------
!  From  * a practical guide to splines *  by C. DE boor
!  constructs Cholesky factorization
!                     C  =  L * D * L-TRANSPOSE
!  with L unit lower triangular and D diagonal, for given matrix C of
!  order  N , in case  C  is (symmetric) positive semidefinite
!  and banded, having NB diagonals at and below the main diagonal.
!
!******  INPUT  ******
!
!     N      THE ORDER OF THE MATRIX C.
!
!     NB     THE BANDWIDTH OF C, I.E.,
!               C(I,J) = 0 FOR ABS(I-J) .GT. NB .
!
!     W      WORK ARRAY OF SIZE NB BY N CONTAINING THE NB DIAGONALS
!            in its rows, with the main diagonal in row 1. Precisely,
!            W(I,J)  CONTAINS  C(I+J-1,J), I=1,...,NB, J=1,...,N.
!            For example, the interesting entries of a seven diagonal
!            symmetric matrix C of order 9 would be stored in W as
!
!                       11 22 33 44 55 66 77 88 99
!                       21 32 43 54 65 76 87 98
!                       31 42 53 64 75 86 97
!                       41 52 63 74 85 96
!
!            All other entries of W not identified with an entry of C
!            are never referenced.
!
!     DIAG   WORK ARRAY OF LENGTH N.
!
!******  O U T P U T  ******
!                                                         T
!     W      CONTAINS THE CHOLESKY FACTORIZATION C = L*D*L   WHERE
!            W(1,I) = 1/D(I,I) AND W(I,J) = L(I-1+J,J) (I=2,...,NB).
!
!     IFLAG  0 if C is nonsingular and 1 if C is singular.
!
!******  M E T H O D  ******
!
!   Gauss elimination, adapted to the symmetry and bandedness of  C , is
!   used .
!     Near zero pivots are handled in a special way. The diagonal ele-
!  MENT C(K,K) = W(1,K) IS SAVED INITIALLY IN  DIAG(K), ALL K. AT THE K-
!  TH elimination step, the current pivot element, viz.  W(1,K), is com-
!  pared with its original value, DIAG(K). If, as the result of prior
!  elimination steps, this element has been reduced by about a word
!  LENGTH, (I.E., IF W(1,K)+DIAG(K) .LE. DIAG(K)), THEN THE PIVOT IS DE-
!  clared to be zero, and the entire K-TH row is declared to be linearly
!  dependent on the preceding rows. This has the effect of producing
!   X(K) = 0  WHEN SOLVING  C*X = B  FOR  X, REGARDLESS OF  B. JUSTIFIC-
!  ation for this is as follows. In contemplated applications of this
!  program, the given equations are the normal equations for some least-
!  SQUARES APPROXIMATION PROBLEM, DIAG(K) = C(K,K) GIVES THE NORM-SQUARE
!  of the K-TH basis function, and, at this point,  W(1,K)  contains the
!  norm-square of the error in the least-squares approximation to the K-
!  TH basis function BY linear combinations of the first K-1 . Having
!  W(1,K)+DIAG(K) .LE. DIAG(K) SIGNIFIES THAT THE K-TH FUNCTION IS LIN-
!  early dependent to machine accuracy on the first K-1 functions, there
!  fore can safely be left out from the basis of approximating functions
!     the solution of a linear system
!                       C*X = B
!   is effected by the succession of the following  T W O  calls ...
!     CALL BCHFAC (W, NB, N, DIAG, IFLAG)   , TO GET FACTORIZATION
!     CALL BCHSLV (W, NB, N, B, X )            , TO SOLVE FOR X.
!-----------------------------------------------------------------------
real, intent(inout) :: w(nb,n), diag(n)
!
if (n .gt. 1) go to 10
   iflag = 1
   if (w(1,1) .eq. 0.0) return
   iflag = 0
   w(1,1) = 1.0/w(1,1)
   return
!
!     Store the diagonal of C in diag
!
10 do k = 1,n
   diag(k) = w(1,k)
end do
!
!     Factorization
!
iflag = 0
do 60 k = 1,n
   t = w(1,k) + diag(k)
   if (t .ne. diag(k)) go to 30
      iflag = 1
      do j = 1,nb
         w(j,k) = 0.0
      end do
      go to 60
!
30 t = 1.0/w(1,k)
   w(1,k) = t
   imax = min0(nb - 1,n - k)
   if (imax .lt. 1) go to 60
   jmax = imax
   do i = 1,imax
      ratio = t*w(i+1,k)
      kpi = k + i
      do j = 1,jmax
         ipj = i + j
         w(j,kpi) = w(j,kpi) - w(ipj,k)*ratio
      end do
      jmax = jmax - 1
      w(i+1,k) = ratio
   end do
60 continue
return
end subroutine bchfac

subroutine bchslv (w, nb, n, b)
implicit none
integer, intent(in) :: n, nb
integer :: j, jmax, jpk, k, nbm1
!-----------------------------------------------------------------------
!
!     BCHSLV SOLVES THE LINEAR SYSTEM C*X = B FOR X WHEN W CONTAINS
!     the Cholesky factorization obtained by the subroutine BCHFAC
!     for the banded symmetric positive definite matrix C.
!
!     Input ...
!
!        N   THE ORDER OF THE MATRIX C
!        NB  the bandwidth of C
!        W   THE CHOLESKY FACTORIZATION OF C
!        B   VECTOR OF LENGTH N CONTAINING THE RIGHT SIDE
!
!     Output ...
!
!        B   SOLUTION X OF THE LINEAR SYSTEM C*X = B
!
!                                       T
!     NOTE.  THE FACTORIZATION C = L*D*L  IS USED, WHERE L IS A
!     unit lower triangular matrix and D a diagonal matrix.
!
!-----------------------------------------------------------------------
real, intent(in) :: w(nb,n)
real, intent(inout) :: b(n)
!
if (n .gt. 1) go to 10
b(1) = b(1)*w(1,1)
return
!
!     FORWARD SUBSTITUTION. SOLVE L*Y = B FOR Y AND STORE Y IN B.
!
10 nbm1 = nb - 1
do 30 k = 1,n
   jmax = min0(nbm1,n - k)
   if (jmax .lt. 1) go to 30
   do j = 1,jmax
      jpk = j + k
      b(jpk) = b(jpk) - w(j + 1,k)*b(k)
   end do
30 continue
!                              T     -1
!     BACKSUBSTITUTION. SOLVE L X = D  Y  FOR X AND STORE X IN B.
!
k = n
40 b(k) = b(k)*w(1,k)
   jmax = min0(nbm1,n - k)
   if (jmax .lt. 1) go to 60
   do j = 1,jmax
      jpk = j + k
      b(k) = b(k) - w(j + 1,k)*b(jpk)
   end do
60 k = k - 1
   if (k .gt. 0) go to 40
return
end subroutine bchslv

subroutine bfit (bkpt, n, nord, xdata, ydata, ndata, &
&xconst, yconst, nderiv, nconst, &
&mode, coeff, rnorm, w, iw)
implicit none
integer, intent(inout) :: mode
integer, intent(in) :: n, nconst, ndata, nord
real, intent(inout) :: rnorm
integer :: i1, i2, i3, i7, mdg, mdw, nbkpt
!-----------------------------------------------------------------------
!
!      This subprogram fits a piece-wise polynomial curve
!      to discrete data.  The piece-wise polynomials are
!      represented as B-splines.
!      The fitting is done in a least squares sense.
!      Equality and inequality constraints can be imposed
!      on the fitted curve.
!
!  Input..
!
!      N,NORD,BKPT(*)     N IS THE NUMBER OF COEFFICIENTS TO BE COM-
!                         puted and NORD is the order of the B-spline.
!                         IT IS ASSUMED THAT N .GE. NORD. THE N + NORD
!                         knots of the spline are in the array BKPT(*).
!                         It is assumed that the knots form a nonde-
!                         creasing sequence. The problem data interval
!                         lies between the points BKPT(NORD) and
!                         BKPT(N+1). The additional end knots BKPT(I),
!                         I = 1,...,NORD-1 AND I = N+2,...,N+NORD, ARE
!                         required to compute the functions used to
!                         fit the data.
!
!                         (The order of the B-spline is one more than
!                         the degree of the piecewise polynomial. For
!                         EXAMPLE, NORD=4 WHEN WE ARE USING PIECEWISE
!                         cubics.)
!
!      NDATA,XDATA(*),
!      YDATA(*)           THE NDATA DISCRETE (X,Y) PAIRS ARE IN
!                         the arrays XDATA(*) and YDATA(*). It is
!                         assumed that XDATA(*) is an increasing
!                         SEQUENCE, XDATA(1) .GE. BKPT(NORD), AND
!                         XDATA(NDATA) .LE. BKPT(N+1).
!
!      NCONST,XCONST(*),
!      YCONST(*),NDERIV(*)
!                         the number of conditions that constrain
!                         the B-spline is NCONST. A constraint is
!                         specified by an (X,Y) pair in the arrays
!                         XCONST(*) and YCONST(*), and by the type
!                         of constraint and derivative value encoded
!                         in the array NDERIV(*). It is assumed that
!                         the values in XCONST(*) are in the closed
!                         interval (BKPT(NORD),BKPT(N+1)). The con-
!                         straints may be given in any order. The
!                         value of NDERIV(*) is determined as follows.
!                         Suppose the I-TH constraint applies to the
!                         J-TH derivative of the B-spline.  (Any
!                         NONNEGATIVE VALUE OF J .LT. NORD IS PERMITTED.
!                         IN PARTICULAR, THE VALUE J = 0 REFERS TO THE
!                         B-spline itself.)
!                         for this I-TH constraint, set
!                          XCONST(I) = X,
!                          YCONST(I) = Y, AND
!                          NDERIV(I) = ITYPE + 4*J  WHERE
!
!                          ITYPE = 0,      IF (J-TH DERIV. AT X) .LE. Y.
!                                = 1,      IF (J-TH DERIV. AT X) .GE. Y.
!                                = 2,      IF (J-TH DERIV. AT X) .EQ. Y.
!                                = 3,      IF (J-TH DERIV. AT X) .EQ.
!                                             (J-TH deriv. At Y).
!                          (A negative value for NDERIV(I) will cause
!                          this constraint to be ignored.  This
!                          feature is often useful when temporarily
!                          suppressing a constraint while still
!                          retaining the source code of the calling
!                          program.)
!
!      MODE               AN INPUT FLAG THAT DIRECTS THE LEAST
!                         squares solution method used by BFIT( ).
!
!                         MODE = 0      A NEW PROBLEM.
!
!                         MODE .NE. 0   AN OLD PROBLEM.
!
!                         By an old problem it is meant that BFIT( )
!                         was last called with the same set of knots
!                         and data points. (The constraints may be
!                         different than before.)
!
!
!      IW(1),IW(2)        THE AMOUNTS OF WORKING STORAGE ACTUALLY
!                         allocated for the working arrays W(*) and
!                         IW(*).  These quantities are compared with the
!                         actual amounts of storage needed in BFIT( ).
!                         Insufficient storage allocated for
!                         either W(*) or IW(*) is an error.
!
!                         Length of W(*) must be at least
!
!                           NB = (N + 3)*(NORD + 1) + NORD**2
!
!                         And the length of IW(*) must be at least 2.
!                         Whenever possible the code uses banded matrix
!                         processors BNDACC( ) and BNDSL( ).  These
!                         are utilized if there are no constraints and
!                         there is sufficient data to uniquely determine
!                         the B-spline coefficents.
!
!                         If the band processors cannot be used to
!                         determine the solution, then the constrained
!                         least squares code LSEI( ) is used.
!                         In this case the subprogram requires an
!                         additional block of storage in W(*).  For the
!                         discussion here define the integers
!                         NEQCON and NINCON respectively as the
!                         NUMBER OF EQUALITY (ITYPE=2,3) AND
!                         INEQUALITY (ITYPE=0,1) CONSTRAINTS
!                         imposed on the fitted curve.  Define
!
!                           L = N + 1
!
!                         And note that
!
!                           NCONST = NEQCON + NINCON.
!
!                         When the subprogram BFIT( ) uses LSEI( ) the
!                         length of the working array W(*) must be at
!                         least
!
!                           LW = NB + (L+NCONST)*L + 2*(NEQCON+L)
!                                   + (NINCON + L) + (NINCON+2)*(L+6)
!
!                         And the length of the array IW(*) must be at
!                         least
!
!                           IW1 = NINCON + 2*L .
!
!  Output..
!
!      MODE               AN OUTPUT FLAG THAT INDICATES THE STATUS
!                         of the constrained curve fit.
!
!                         =-1  EITHER NORD .LT. 1 OR NORD .GT. N.
!
!                         =-2  EITHER NDATA .LT. 1 OR NCONST .LT. 0.
!
!                         =-3  BKPT(I) .GT. BKPT(I+1) FOR SOME I.
!
!                         =-4  XDATA(*) IS NOT AN INCREASING
!                              sequence in the closed interval
!                              (BKPT(NORD), BKPT(N+1)).
!
!                         =-5  THE I-TH CONSTRAINT IS INCORRECT
!                              for the value of I stored in IW(2).
!
!                         =-6  INSUFF. STORAGE FOR W(*). IW(1) HAS
!                              been reset to the amount of storage
!                              needed by W(*).
!
!                         =-7  INSUFF. STORAGE FOR IW(*). IW(2) HAS
!                              been reset to the amount of storage
!                              needed by IW(*).
!
!                         = 0  SUCCESSFUL CONSTRAINED CURVE FIT.
!
!                         = 1  THE REQUESTED EQUALITY CONSTRAINTS
!                              are contradictory.
!
!                         = 2  THE PROBLEM CANNOT BE SOLVED. THE
!                              constraints are contradictory.
!
!      COEFF(*)
!                         IF THE OUTPUT VALUE OF MODE=0 OR 1, COEFF(*)
!                         contains the N unknowns obtained from the
!                         least squares fitting process.  These N
!                         parameters are the B-spline coefficients.
!                         FOR MODE=1, THE EQUALITY CONSTRAINTS ARE
!                         contradictory.  To make the fitting process
!                         more robust, the equality constraints are
!                         satisfied in a least squares sense.  In
!                         this case the array COEFF(*) contains
!                         B-spline coefficients for this extended
!                         concept of a solution.
!                         IF MODE .LT. 0 OR MODE = 2 ON OUTPUT, THE
!                         array COEFF(*) is undefined.
!
!      RNORM              IF THE OUTPUT VALUE OF MODE = 0 OR 1 THEN
!                         RNORM is the L2 norm of the vector
!                         (YDATA(I) - F(XDATA(I)), I = 1,NDATA).
!
!  Working arrays..
!
!      W(*),IW(*)         THESE ARRAYS ARE RESPECTIVELY TYPED
!                         real and integer.  Their required
!                         lengths are specified as input parameters
!                         in IW(1), IW(2) noted above. It is assumed
!                         that W(1),...,W(NB) have not been modified
!                         if BFIT( ) is being recalled for the same
!                         knots and data as before (I.E., If we have
!                         an old problem).
!
!
!   REFERENCE.  HANSON R.J., CONSTRAINED LEAST SQUARES CURVE FITTING
!               TO DISCRETE DATA USING B-SPLINES, A USERS GUIDE.
!               SANDIA LABS. TECH. REPT. SAND-78-1291, DEC, 1978.
!
!-----------------------------------------------------------------------
!   WRITTEN BY
!     RICHARD J. HANSON
!     SANDIA LABORATORIES
!   MODIFIED BY A.H. MORRIS (NSWC)
!-----------------------------------------------------------------------
real, intent(in) :: bkpt(*), xdata(ndata), ydata(ndata)
real, intent(in) :: xconst(*), yconst(*)
real, intent(inout) :: coeff(n), w(*)
integer, intent(in) :: nderiv(*)
integer, intent(inout) :: iw(*)
!
nbkpt = n + nord
mdg = n + 3
mdw = n + 1 + nconst
!
!                         Usage in BFIT0( ) of W(*)..
!
!      I1,...,I2-1      G(*,*)
!
!      I2,...,I3-1      BF(*,*)
!
!      I3,...,I7-1      W(*,*)
!
!      I7,...           WORK(*) FOR BSPVD( ) AND LSEI( )
!
i1 = 1
i2 = i1 + mdg*(nord + 1)
i3 = i2 + nord*nord
i7 = i3 + mdw*(n + 1)
!
call bfit0 (ndata, xdata, ydata, nord, nbkpt, bkpt, nconst, &
&xconst, yconst, nderiv, mode, coeff, rnorm, w(i2), &
&w(i1), mdg, w(i3), mdw, w(i7), iw)
return
end subroutine bfit

subroutine bfit0 (ndata, xdata, ydata, nord, nbkpt, bkpt, &
&nconst, xconst, yconst, nderiv, mode, coeff, rnorm, &
&bf, g, mdg, w, mdw, work, iwork)
implicit none
integer, intent(in) :: mdg, mdw
integer, intent(inout) :: mode
integer, intent(in) :: nbkpt, nconst, ndata, nord
real, intent(inout) :: rnorm
integer :: i, idata, ideriv, ierr, ileft, intrvl, intw1, ip, ip1, &
&ir, irow, itype, iw1, iw2, j, l, lw, m, mt, n, nb, neqcon, nincon, &
&nordm1, nordp1, np1
real :: rnorme, xmax, xmin, xval, yval
!---------------------
real, intent(in) :: bkpt(nbkpt), xdata(ndata), ydata(ndata)
real, intent(in) :: xconst(*), yconst(*)
real, intent(inout) :: coeff(*)
real, intent(inout) :: bf(nord,nord), g(mdg,*), w(mdw,*), work(*)
integer, intent(in) :: nderiv(*)
integer, intent(inout) :: iwork(*)
!
real :: prgopt(7)
logical :: band, new
!
go to 100
!
10 if (.not. band) go to 20
call bndsl (1, g, mdg, nord, ip, ir, coeff, n, rnorm, ierr)
if (ierr .eq. 0) return
!
!     Check further for sufficient storage in working arrays.
!
20 if (iw1 .lt. lw) go to 850
if (iw2 .lt. intw1) go to 860
go to 300
!
!     Solve the equations
!
30 call lsei(w, mdw, neqcon, np1, nincon, n, prgopt, coeff, rnorme, &
&rnorm, mode, work, iwork)
iwork(1) = iw1
iwork(2) = iw2
return
!-----------------------------------------------------------------------
!               Initialize-variables-and-analyze-input
!-----------------------------------------------------------------------
100 n = nbkpt - nord
if (nord .lt. 1 .or. nord .gt. n) go to 800
if (ndata .lt. 1 .or. nconst .lt. 0) go to 810
!
!     Check the break points
!
if (mode .ne. 0) go to 120
m = nbkpt - 1
do i = 1,m
   if (bkpt(i) .gt. bkpt(i+1)) go to 820
end do
!
!     Amount of storage allocated for W(*),IW(*)
!
120 iw1 = iwork(1)
iw2 = iwork(2)
nb = (n + 3)*(nord + 1) + nord*nord
lw = nb
if (iw1 .lt. nb) go to 850
!
!     Compute the amount of storage needed for LSEI
!
neqcon = 0
nincon = 0
if (nconst .eq. 0) go to 150
do 140 i = 1,nconst
   l = nderiv(i)
   if (l .lt. 0) go to 140
   itype = l - 4*(l/4)
   if (itype .gt. 1) go to 130
      nincon = nincon + 1
      go to 140
130 neqcon = neqcon + 1
140 continue
!
150 np1 = n + 1
l = np1
lw = nb + (l+nconst)*l + 2*(neqcon+l) + (nincon+l) + &
&(nincon+2)*(l+6)
intw1 = nincon + 2*l
!
!     Check the XCONST(*) array
!
xmin = bkpt(nord)
xmax = bkpt(np1)
if (nconst .eq. 0) go to 170
do i = 1,nconst
   if (xconst(i) .lt. xmin .or. xconst(i) .gt. xmax) &
&go to 840
end do
!
!     Initialize parameters
!
170 new = mode .eq. 0
band = nconst .eq. 0
mode = 0
nordm1 = nord - 1
nordp1 = nord + 1
!
!     Define the option vector for use in LSEI( )
!
!     Increase the rank determination tolerances
!     for both equality constraint equations and
!     least squares equations.
!
prgopt(1) = 4
prgopt(2) = 4
prgopt(3) = 1.e-3
!
prgopt(4) = 7
prgopt(5) = 5
prgopt(6) = 1.e-3
!
prgopt(7) = 1
!
if (.not. new) go to 260
!
!     Check the XDATA(*) array
!
if (xdata(1) .lt. xmin .or. xdata(ndata) .gt. xmax) &
&go to 830
if (ndata .eq. 1) go to 200
!
m = ndata - 1
do i = 1,m
   if (xdata(i) .ge. xdata(i+1)) go to 830
end do
!
!     Initialize parameters of banded matrix processor, BNDACC( )
!
200 mt = 0
ip = 1
ir = 1
idata = 1
ileft = nord
!
210 if (idata .gt. ndata) go to 250
xval = xdata(idata)
if (ileft .eq. n) go to 230
!
!     When interval changes, process equations in the last block.
!
ip1 = ileft + 1
if (xval .lt. bkpt(ip1)) go to 230
intrvl = ileft - nordm1
call bndacc (g, mdg, nord, ip, ir, mt, intrvl)
mt = 0
!
!     MOVE POINTER UP SO THAT XVAL .GE. BKPT(ILEFT).
!
do 220 i = ip1,n
   if (xval .lt. bkpt(i)) go to 230
220 ileft = i
!
!     Obtain B-spline function VALUE
!
230 j = 0
call bspvb (bkpt, nord, nord, j, xval, ileft, bf)
!
!     Move row into place
!
irow = ir + mt
mt = mt + 1
call scopy (nord, bf, 1, g(irow,1), mdg)
g(irow,nordp1) = ydata(idata)
!
!     When staging work area is exhausted, process rows
!
if (irow .ne. mdg - 1) go to 240
   intrvl = ileft - nordm1
   call bndacc (g, mdg, nord, ip, ir, mt, intrvl)
   mt = 0
240 idata = idata + 1
go to 210
!
!     Process  block of equations
!
250 intrvl = ileft - nordm1
call bndacc (g, mdg, nord, ip, ir, mt, intrvl)
!
!     Last call to adjust block positioning
!
g(ir,1) = 0.0
call scopy (nordp1, g(ir,1), 0, g(ir,1), mdg)
call bndacc (g, mdg, nord, ip, ir, 1, np1)
!
260 do i = 1,n
  band = band .and. g(i,1) .ne. 0.0
end do
go to 10
!-----------------------------------------------------------------------
!       Analyze constraint indicators for equality constraints
!-----------------------------------------------------------------------
300 idata = 0
neqcon = 0
!
310 idata = idata + 1
if (idata .gt. nconst) go to 400
l = nderiv(idata)
if (l .lt. 0) go to 310
ideriv = l/4
itype = l - 4*ideriv
!
if (itype .lt. 2) go to 310
neqcon = neqcon + 1
xval = xconst(idata)
ileft = nord
if (nord .eq. n) go to 330
do 320 i = nordp1,n
   if (xval .lt. bkpt(i)) go to 330
320 ileft = i
330 call bspvd (bkpt, nord, xval, ileft, bf, nord, ideriv + 1, work)
w(neqcon,1) = 0.0
call scopy (n, w(neqcon,1), 0, w(neqcon,1), mdw)
intrvl = ileft - nordm1
call scopy (nord, bf(1,ideriv+1), 1, w(neqcon,intrvl), mdw)
if (itype .ne. 2) go to 340
w(neqcon,np1) = yconst(idata)
go to 310
!
340 w(neqcon,np1) = 0.0
yval = yconst(idata)
i = idata
if (yval .lt. xmin .or. yval .gt. xmax) go to 840
ileft = nord
if (nord .eq. n) go to 360
do 350 i = nordp1,n
   if (yval .lt. bkpt(i)) go to 360
350 ileft = i
360 call bspvd (bkpt, nord, yval, ileft, bf, nord, ideriv + 1, work)
intrvl = ileft - nordm1
call saxpy (nord, -1.0, bf(1,ideriv+1), 1, w(neqcon,intrvl), mdw)
go to 310
!-----------------------------------------------------------------------
!                    Transfer-least-squares data
!-----------------------------------------------------------------------
400 do i = 1,np1
  irow = i + neqcon
  w(irow,1) = 0.0
  call scopy (n, w(irow,1), 0, w(irow,1), mdw)
  call scopy (min0(np1-i,nord), g(i,1), mdg, w(irow,i), mdw)
  w(irow,np1) = g(i,nordp1)
end do
!-----------------------------------------------------------------------
!      Analyze constraint indicators for inequality constraints
!-----------------------------------------------------------------------
idata = 0
nincon = 0
!
500 idata = idata + 1
if (idata .gt. nconst) go to 30
l = nderiv(idata)
if (l .lt. 0) go to 500
ideriv = l/4
itype = l - 4*ideriv
!
if (itype .gt. 1) go to 500
nincon = nincon + 1
xval = xconst(idata)
ileft = nord
if (nord .eq. n) go to 520
do 510 i = nordp1,n
   if (xval .lt. bkpt(i)) go to 520
510 ileft = i
520 call bspvd (bkpt, nord, xval, ileft, bf, nord, ideriv + 1, work)
irow = neqcon + np1 + nincon
w(irow,1) = 0.0
call scopy (n, w(irow,1), 0, w(irow,1), mdw)
intrvl = ileft - nordm1
call scopy (nord, bf(1,ideriv+1), 1, w(irow,intrvl), mdw)
w(irow,np1) = yconst(idata)
if (itype .ne. 0) go to 500
w(irow,np1) = -w(irow,np1)
call sscal(nord, -1.0, w(irow,intrvl), mdw)
go to 500
!-----------------------------------------------------------------------
!                         Error return
!-----------------------------------------------------------------------
!                       EITHER NORD .LT. 1 OR NORD .GT. N.
800 mode = -1
return
!                       EITHER NDATA .LT. 1 OR NCONST .LT. 0.
810 mode = -2
return
!                       The sequence of knots is not nondecreasing.
820 mode = -3
return
!                       XDATA(*) is not an increasing sequence in the
!                       closed interval (BKPT(1),BKPT(N+1)).
830 mode = -4
return
!                       The I-TH constraint is incorrect for the
!                       value of I stored in IWORK(2).
840 iwork(2) = i
mode = -5
return
!                       Insuff. Storage for W(*). IWORK(1) has been set
!                       to the amount of storage needed by W(*).
850 iwork(1) = lw
mode = -6
return
!                       Insuff. Storage for IW(*). IWORK(2) has been set
!                       to the amount of storage needed by IW(*).
860 iwork(2) = intw1
mode = -7
return
end subroutine bfit0

subroutine bndacc (g,mdg,nb,ip,ir,mt,jt)
implicit none
integer, intent(inout) :: ip, ir
integer, intent(in) :: jt, mdg, mt, nb
real, intent(inout) :: g(mdg,*)
integer :: i, ie, ig, ig1, ig2, j, jg, k, kh, l, lp1, mh, mu, nbp1
real :: rho
!
!***AUTHOR  LAWSON, C. L., (JPL)
!           HANSON, R. J., (SNLA)
!
!***PURPOSE  SOLVE THE LEAST SQUARES PROBLEM AX = B FOR BANDED
!            matrices a using sequential accumulation of rows of
!            the data matrix.  Exactly one right-handed side vector
!            is permitted.
!***DESCRIPTION
!
!     THESE SUBROUTINES SOLVE THE LEAST SQUARES PROBLEM AX = B FOR
!     banded matrices a using sequential accumulation of rows of the
!     data matrix.  Exactly one right-hand side vector is permitted.
!
!     These subroutines are intended for the type of least squares
!     systems that arise in applications such as curve or surface
!     fitting of data.  The least squares equations are accumulated and
!     processed using only part of the data.  This requires a certain
!     USER INTERACTION DURING THE SOLUTION OF AX = B.
!
!     Specifically, suppose the data matrix (A B) is row partitioned
!     into Q submatrices.  Let (E F) be the T-TH one of these
!     SUBMATRICES WHERE E = (0 C 0).  HERE THE DIMENSION OF E IS MT BY N
!     and the dimension of C is MT by NB.  The value of NB is the
!     bandwidth of A.  The dimensions of the leading block of zeros in E
!     are MT by JT-1.
!
!     The user of the subroutine BNDACC provides MT,JT,C and F for
!     T=1,...,Q.  NOT ALL OF THIS DATA MUST BE SUPPLIED AT ONCE.
!
!     Following the processing of the various blocks (E F), the matrix
!     (A B) has been transformed to the form (R D) where R is upper
!     triangular and banded with bandwidth NB.  The least squares
!     SYSTEM RX = D IS THEN EASILY SOLVED USING BACK SUBSTITUTION BY
!     executing the statement call BNDSL(1,...). The sequence of
!     values for JT must be nondecreasing.  This may require some
!     preliminary interchanges of rows and columns of the matrix A.
!
!     The primary reason for these subroutines is that the total
!     processing can take place in a working array of dimension mu by
!     NB+1.  An acceptable value for mu is
!
!                       MU = MAX(MT + N + 1),
!
!     Where N is the number of unknowns.
!
!     HERE THE MAXIMUM IS TAKEN OVER ALL VALUES OF MT FOR T=1,...,Q.
!     Notice that MT can be taken to be a small as one, showing that
!     mu can be as small as N+2.  The subprogram BNDACC processes the
!     rows more efficiently if mu is large enough so that each new
!     block (C F) has a distinct value of JT.
!
!     The four principle parts of these algorithms are obtained by the
!     following call statements
!
!     CALL BNDACC(...)  INTRODUCE NEW BLOCKS OF DATA.
!
!     CALL BNDSL(1,...)COMPUTE SOLUTION VECTOR AND LENGTH OF
!                       residual vector.
!
!     CALL BNDSL(2,...)GIVEN ANY ROW VECTOR H SOLVE YR = H FOR THE
!                       row vector Y.
!
!     CALL BNDSL(3,...)GIVEN ANY COLUMN VECTOR W SOLVE RZ = W FOR
!                       the column vector Z.
!
!     The dots in the above call statements indicate additional
!     arguments that will be specified in the following paragraphs.
!
!     The user must dimension the array appearing in the call list..
!     G(MDG,NB+1)
!
!     Description of calling sequence for BNDACC..
!
!     The entire set of parameters for BNDACC are
!
!     Input..
!
!     G(*,*)            THE WORKING ARRAY INTO WHICH THE USER WILL
!                       place the MT by NB+1 block (C F) in rows IR
!                       through IR+MT-1, columns 1 through NB+1.
!                       See descriptions of IR and MT below.
!
!     MDG               THE NUMBER OF ROWS IN THE WORKING ARRAY
!                       G(*,*).  THE VALUE OF MDG SHOULD BE .GE. MU.
!                       The value of mu is defined in the abstract
!                       of these subprograms.
!
!     NB                THE BANDWIDTH OF THE DATA MATRIX A.
!
!     IP                SET BY THE USER TO THE VALUE 1 BEFORE THE
!                       first call to BNDACC.  Its subsequent value
!                       is controlled by BNDACC to set up for the
!                       next call to BNDACC.
!
!     IR                INDEX OF THE ROW OF G(*,*) WHERE THE USER IS
!                       to place the new block of data (C F).  Set by
!                       the user to the value 1 before the first call
!                       to BNDACC.  Its subsequent value is controlled
!                       BY BNDACC. A VALUE OF IR .GT. MDG IS CONSIDERED
!                       an error.
!
!     MT,JT             SET BY THE USER TO INDICATE RESPECTIVELY THE
!                       number of new rows of data in the block and
!                       the index of the first nonzero column in that
!                       SET OF ROWS (E F) = (0 C 0 F) BEING PROCESSED.
!
!     Output..
!
!     G(*,*)            THE WORKING ARRAY WHICH WILL CONTAIN THE
!                       processed rows of that part of the data
!                       matrix which has been passed to BNDACC.
!
!     IP,IR             THE VALUES OF THESE ARGUMENTS ARE ADVANCED BY
!                       BNDACC to be ready for storing and processing
!                       a new block of data in G(*,*).
!
!
!     Remarks..
!
!     To obtain the upper triangular matrix and transformed right-hand
!     side vector D so that the super diagonals of R form the columns
!     of G(*,*), execute the following Fortran statements.
!
!     NBP1=NB+1
!
!     DO 10 J=1, NBP1
!
!  10 G(IR,J) = 0.E0
!
!     MT=1
!
!     JT=N+1
!
!     CALL BNDACC(G,MDG,NB,IP,IR,MT,JT)
!
!***REFERENCES  C. L. LAWSON AND R. J. HANSON,
!                 SOLVING LEAST SQUARE PROBLEMS,PRENCTICE-HALL, INC
!                 (1974), CHAPTER 27
!
!
!
!              Alg. Steps 1-4 are performed external to this subroutine.
!
nbp1 = nb + 1
if (mt .le. 0 .or. nb .le. 0) return
!                                             Alg. Step 5
if (jt .eq. ip) go to 70
!                                             Alg. Steps 6-7
if (jt .le. ir) go to 30
!                                             Alg. Steps 8-9
do i = 1,mt
   ig1 = jt + mt - i
   ig2 = ir + mt - i
   do j = 1,nbp1
      g(ig1,j) = g(ig2,j)
   end do
end do
!                                             Alg. Step 10
ie = jt - ir
do i = 1,ie
   ig = ir + i - 1
   do j = 1,nbp1
     g(ig,j) = 0.0
   end do
end do
!                                             Alg. Step 11
ir = jt
!                                             Alg. Step 12
30 mu = min0(nb - 1, ir - ip - 1)
if (mu .eq. 0) go to 60
!                                             Alg. Step 13
do l = 1,mu
!                                             Alg. Step 14
   k = min0(l, jt - ip)
!                                             Alg. Step 15
   lp1 = l + 1
   ig = ip + l
   do i = lp1,nb
      jg = i - k
      g(ig,jg) = g(ig,i)
   end do
!                                             Alg. Step 16
   do i = 1,k
      jg = nbp1 - i
      g(ig,jg) = 0.0
   end do
end do
!                                             Alg. Step 17
60 ip = jt
!                                             Alg. Steps 18-19
70 mh = ir + mt - ip
kh = min0(nbp1, mh)
!                                             Alg. Step 20
do i = 1,kh
   call h12 (1,i,max0(i+1,ir-ip+1),mh,g(ip,i),1,rho, &
&g(ip,i+1),1,mdg,nbp1-i)
end do
!                                             Alg. Step 21
ir = ip + kh
!                                             Alg. Step 22
if (kh .lt. nbp1) go to 100
!                                             Alg. Step 23
do i = 1,nb
   g(ir-1,i) = 0.0
end do
!                                             Alg. Step 24
100 continue
!                                             Alg. Step 25
return
end subroutine bndacc

subroutine bndsl (mode,g,mdg,nb,ip,ir,x,n,rnorm,ierr)
implicit none
integer, intent(out) :: ierr
integer, intent(in) :: ip, ir, mdg, mode, n, nb
real :: g(mdg,*)
real, intent(out) :: rnorm
real, intent(inout) :: x(n)
integer :: i, i1, i2, ie, ii, irm1, ix, j, jg, l, np1
real :: rsq, s
!
!***AUTHOR  LAWSON, C. L., (JPL)
!           HANSON, R. J., (SNLA)
!
!***PURPOSE  SOLVE THE LEAST SQUARES PROBLEM AX = B FOR BANDED
!            matrices a using sequential accumulation of rows of
!            the data matrix.  Exactly one right-handed side vector
!            is permitted.
!
!     THESE SUBROUTINES SOLVE THE LEAST SQUARES PROBLEM AX = B FOR
!     banded matrices a using sequential accumulation of rows of the
!     data matrix.  Exactly one right-hand side vector is permitted.
!
!     These subroutines are intended for the type of least squares
!     systems that arise in applications such as curve or surface
!     fitting of data.  The least squares equations are accumulated and
!     processed using only part of the data.  This requires a certain
!     USER INTERACTION DURING THE SOLUTION OF AX = B.
!
!     Specifically, suppose the data matrix (A B) is row partitioned
!     into Q submatrices.  Let (E F) be the T-TH one of these
!     SUBMATRICES WHERE E = (0 C 0).  HERE THE DIMENSION OF E IS MT BY N
!     and the dimension of C is MT by NB.  The value of NB is the
!     bandwidth of A.  The dimensions of the leading block of zeros in E
!     are MT by JT-1.
!
!     The user of the subroutine BNDACC provides MT,JT,C and F for
!     T=1,...,Q.  NOT ALL OF THIS DATA MUST BE SUPPLIED AT ONCE.
!
!     Following the processing of the various blocks (E F), the matrix
!     (A B) has been transformed to the form (R D) where R is upper
!     triangular and banded with bandwidth NB.  The least squares
!     SYSTEM RX = D IS THEN EASILY SOLVED USING BACK SUBSTITUTION BY
!     executing the statement call BNDSL(1,...). The sequence of
!     values for JT must be nondecreasing.  This may require some
!     preliminary interchanges of rows and columns of the matrix A.
!
!     The primary reason for these subroutines is that the total
!     processing can take place in a working array of dimension mu by
!     NB+1.  An acceptable value for mu is
!
!                       MU = MAX(MT + N + 1),
!
!     Where N is the number of unknowns.
!
!     HERE THE MAXIMUM IS TAKEN OVER ALL VALUES OF MT FOR T=1,...,Q.
!     Notice that MT can be taken to be a small as one, showing that
!     mu can be as small as N+2.  The subprogram BNDACC processes the
!     rows more efficiently if mu is large enough so that each new
!     block (C F) has a distinct value of JT.
!
!     The four principle parts of these algorithms are obtained by the
!     following call statements
!
!     CALL BNDACC(...)  INTRODUCE NEW BLOCKS OF DATA.
!
!     CALL BNDSL(1,...)COMPUTE SOLUTION VECTOR AND LENGTH OF
!                       residual vector.
!
!     CALL BNDSL(2,...)GIVEN ANY ROW VECTOR H SOLVE YR = H FOR THE
!                       row vector Y.
!
!     CALL BNDSL(3,...)GIVEN ANY COLUMN VECTOR W SOLVE RZ = W FOR
!                       the column vector Z.
!
!     The dots in the above call statements indicate additional
!     arguments that will be specified in the following paragraphs.
!
!     The user must dimension the array appearing in the call list..
!     G(MDG,NB+1)
!
!     Description of calling sequence for BNDSL..
!
!     The user must dimension the arrays appearing in the call list..
!
!     G(MDG,NB+1), X(N)
!
!     The entire set of parameters for BNDSL are
!
!     Input..
!
!     MODE              SET BY THE USER TO ONE OF THE VALUES 1, 2, OR
!                       3.  These values respectively indicate that
!                       THE SOLUTION OF AX = B, YR = H OR RZ = W IS
!                       required.
!
!     G(*,*),MDG,       THESE ARGUMENTS ALL HAVE THE SAME MEANING AND
!      NB,IP,IR         CONTENTS AS FOLLOWING THE LAST CALL TO BNDACC.
!
!     X(*)              WITH MODE=2 OR 3 THIS ARRAY CONTAINS,
!                       respectively, the right-side vectors H or W of
!                       THE SYSTEMS YR = H OR RZ = W.
!
!     N                 THE NUMBER OF VARIABLES IN THE SOLUTION
!                       vector.  If any of the N diagonal terms are
!                       zero the subroutine BNDSL prints an
!                       appropriate message.  This condition is
!                       considered an error.
!
!     Output..
!
!     X(*)              THIS ARRAY CONTAINS THE SOLUTION VECTORS X,
!                       Y OR Z OF THE SYSTEMS AX = B, YR = H OR
!                       RZ = W DEPENDING ON THE VALUE OF MODE=1,
!                       2 or 3.
!
!     RNORM             IF MODE=1 RNORM IS THE EUCLIDEAN LENGTH OF THE
!                       RESIDUAL VECTOR AX-B.  WHEN MODE=2 OR 3 RNORM
!                       is set to zero.
!
!     IERR              IERR = 0 IF THE SOLUTION WAS OBTAINED.
!                       IERR = 1 IF THE PROBLEM CANNOT BE SOLVED.
!
!
!***REFERENCES  C. L. LAWSON AND R. J. HANSON,
!                 SOLVING LEAST SQUARE PROBLEMS,PRENCTICE-HALL, INC
!                 (1974), CHAPTER 27
!
!
ierr = 0
rnorm = 0.0
go to (10,90,50), mode
!                                   ********************* MODE = 1
!                                   alg. Step 26
10 do j = 1,n
   x(j) = g(j, nb+1)
end do
rsq = 0.0
np1 = n + 1
irm1 = ir - 1
if (np1 .gt. irm1) go to 40
   do j = np1,irm1
      rsq = rsq + g(j, nb+1)**2
   end do
   rnorm = sqrt(rsq)
40 continue
!                                   ********************* MODE = 3
!                                   alg. Step 27
50 do ii = 1,n
   i = n + 1 - ii
!                                   Alg. Step 28
   s = 0.0
   l = max0(0, i - ip)
!                                   Alg. Step 29
   if (i .eq. n) go to 70
!                                   Alg. Step 30
      ie = min0(n + 1 - i, nb)
      do j = 2,ie
         jg = j + l
         ix = i - 1 + j
         s = s + g(i,jg)*x(ix)
      end do
!                                   Alg. Step 31
70 if (g(i,l+1) .eq. 0.0) go to 130
   x(i) = (x(i) - s)/g(i,l+1)
end do
!                                   Alg. Step 32
return
!                                   ********************* MODE = 2
90 do j = 1,n
   s = 0.0
   if (j .eq. 1) go to 110
      i1 = max0(1, j - nb + 1)
      i2 = j - 1
      do i = i1,i2
         l = j - i + 1 + max0(0, i - ip)
         s = s + x(i)*g(i,l)
      end do
110 l = max0(0, j - ip)
   if (g(j,l+1) .eq. 0.0) go to 130
   x(j) = (x(j) - s)/g(j,l+1)
end do
return
!
!            A zero diagonal term occurs
!
130 ierr = 1
return
end subroutine bndsl

subroutine spfit2 (x, wx, mx, y, wy, my, z, kz, xbreak, nx, &
&ybreak, ny, f, s, t, wk, num, ierr)
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: kz, mx, my, num, nx, ny
integer :: i, imax, j, l, ld, m, n, nu
!-----------------------------------------------------------------------
!
!            Weighted least squares bicubic spline fitting
!
!                          -----------------
!
!     The piecewise polynomials considered are tensor products of
!     B-splines, having the form
!
!                          M    N
!              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
!                         I=1  J=1   IJ  I     J
!
!     WHERE M = NX + 2 AND N = NY + 2, AND U  AND V  ARE B-SPLINE
!     BASIS FUNCTIONS OF DEGREE 3. LET      I      J
!
!                       M
!              G (X) = SUM A   U (X)
!               J      I=1  IJ  I
!
!     FOR J = 1,...,N. THEN G (X),...,G (X) ARE CUBIC SPLINES AND
!                            1         N
!                        N
!              F(X,Y) = SUM G (X) V (Y) .
!                       J=1  J     J
!
!     The arrays S and T defined in the code are the knot sequences
!     for the B-splines U (X) and V (Y).
!                        I         J
!-----------------------------------------------------------------------
!     WRITTEN BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WARFARE CENTER
!        DAHLGREN, VIRGINIA
!-----------------------------------------------------------------------
real, intent(in) :: x(mx), wx(mx), y(my), wy(my), z(kz, my)
real, intent(in) :: xbreak(nx), ybreak(ny)
real, intent(inout) :: f(*)
real, intent(inout) :: s(*), t(*), wk(num)
!---------------------
!     REAL F(4*NX*NY), S(NX + 6), T(NY + 6)
!---------------------
if (nx .lt. 2) go to 100
if (ny .lt. 2) go to 120
m = nx + 2
n = ny + 2
l = max0(m*n, m*my + 5*max0(m,n))
if (num .lt. l) go to 130
!
!     Define the knot squences
!
s(1) = xbreak(1)
s(2) = xbreak(1)
s(3) = xbreak(1)
s(4) = xbreak(1)
do i = 2,nx
   if (xbreak(i - 1) .ge. xbreak(i)) go to 100
   s(i + 3) = xbreak(i)
end do
s(nx + 4) = xbreak(nx)
s(nx + 5) = xbreak(nx)
s(nx + 6) = xbreak(nx)
!
t(1) = ybreak(1)
t(2) = ybreak(1)
t(3) = ybreak(1)
t(4) = ybreak(1)
do j = 2,ny
   if (ybreak(j - 1) .ge. ybreak(j)) go to 120
   t(j + 3) = ybreak(j)
end do
t(ny + 4) = ybreak(ny)
t(ny + 5) = ybreak(ny)
t(ny + 6) = ybreak(ny)
!
!     Obtain the B-spline coefficients of the bivariate
!     least squares fit and store them in WK.
!
call bslsq2 (x, wx, mx, y, wy, my, z, kz, s, m, 4, &
&t, n, 4, f, m, wk, num, ierr)
if (ierr .lt. 0) go to 110
ierr = 0
!
l = m*n
do i = 1,l
   wk(i) = f(i)
end do
!
!     Compute the N cubic splines G (X) and their first
!                                  J
!     derivatives at the points in XBREAK. Then store the
!     derivatives in WK. (The values of the splines will
!     be in the latter half of F.)
!
nu = nx*ny
l = 2*nu + 1
call cspp (s, wk, m, m, n, f(l), n, f(1), n)
!
imax = n*nx
do i = 1,imax
   wk(i) = f(i)
end do
!
!     Compute the values of the bispline and their partial
!     derivatives with respect to Y. The results are stored
!     in the first half of F.
!
ld = nu + 1
call cspp (t, f(l), n, n, nx, f(1), nx, f(ld), nx)
!
!     Compute the remaining partial derivatives and store
!     the results in the latter half of F.
!
ld = l + nu
call cspp (t, wk, n, n, nx, f(l), nx, f(ld), nx)
return
!
!     Error return
!
100 ierr = 1
return
110 ierr = 2
if (ierr .eq. -2) ierr = 4
return
120 ierr = 3
return
130 ierr = 5
wk(1) = l
return
end subroutine spfit2

