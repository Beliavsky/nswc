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
!     SUBROUTINE COSQF COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
!     WAVE DATA. THAT IS , COSQF COMPUTES THE COEFFICIENTS IN A COSINE
!     SERIES REPRESENTATION WITH ONLY ODD WAVE NUMBERS. THE TRANSFORM
!     IS DEFINED BELOW AT OUTPUT PARAMETER X
!
!     COSQF IS THE UNNORMALIZED INVERSE OF COSQB SINCE A CALL OF COSQF
!     FOLLOWED BY A CALL OF COSQB WILL MULTIPLY THE INPUT SEQUENCE X
!     BY 4*N.
!
!     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE COSQF MUST BE
!     INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE).
!
!
!     INPUT PARAMETERS
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15
!             IN THE PROGRAM THAT CALLS COSQF. THE WSAVE ARRAY MUST BE
!             INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE) AND A
!             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
!             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
!             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
!             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
!
!     OUTPUT PARAMETERS
!
!     X       FOR I=1,...,N
!
!                  X(I) = X(1) PLUS THE SUM FROM K=2 TO K=N OF
!
!                     2*X(K)*COS((2*I-1)*(K-1)*PI/(2*N))
!
!                  A CALL OF COSQF FOLLOWED BY A CALL OF
!                  COSQB WILL MULTIPLY THE SEQUENCE X BY 4*N.
!                  THEREFORE COSQB IS THE UNNORMALIZED INVERSE
!                  OF COSQF.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             BE DESTROYED BETWEEN CALLS OF COSQF OR COSQB.
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
!     SUBROUTINE COSQB COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
!     WAVE DATA. THAT IS , COSQB COMPUTES A SEQUENCE FROM ITS
!     REPRESENTATION IN TERMS OF A COSINE SERIES WITH ODD WAVE NUMBERS.
!     THE TRANSFORM IS DEFINED BELOW AT OUTPUT PARAMETER X.
!
!     COSQB IS THE UNNORMALIZED INVERSE OF COSQF SINCE A CALL OF COSQB
!     FOLLOWED BY A CALL OF COSQF WILL MULTIPLY THE INPUT SEQUENCE X
!     BY 4*N.
!
!     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE COSQB MUST BE
!     INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE).
!
!
!     INPUT PARAMETERS
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY THAT MUST BE DIMENSIONED AT LEAST 3*N+15
!             IN THE PROGRAM THAT CALLS COSQB. THE WSAVE ARRAY MUST BE
!             INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE) AND A
!             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
!             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
!             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
!             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
!
!     OUTPUT PARAMETERS
!
!     X       FOR I=1,...,N
!
!                  X(I)= THE SUM FROM K=1 TO K=N OF
!
!                    4*X(K)*COS((2*K-1)*(I-1)*PI/(2*N))
!
!                  A CALL OF COSQB FOLLOWED BY A CALL OF
!                  COSQF WILL MULTIPLY THE SEQUENCE X BY 4*N.
!                  THEREFORE COSQF IS THE UNNORMALIZED INVERSE
!                  OF COSQB.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             BE DESTROYED BETWEEN CALLS OF COSQB OR COSQF.
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
!     SUBROUTINE SINQF COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
!     WAVE DATA. THAT IS , SINQF COMPUTES THE COEFFICIENTS IN A SINE
!     SERIES REPRESENTATION WITH ONLY ODD WAVE NUMBERS. THE TRANSFORM
!     IS DEFINED BELOW AT OUTPUT PARAMETER X.
!
!     SINQB IS THE UNNORMALIZED INVERSE OF SINQF SINCE A CALL OF SINQF
!     FOLLOWED BY A CALL OF SINQB WILL MULTIPLY THE INPUT SEQUENCE X
!     BY 4*N.
!
!     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE SINQF MUST BE
!     INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE).
!
!
!     INPUT PARAMETERS
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
!             IN THE PROGRAM THAT CALLS SINQF. THE WSAVE ARRAY MUST BE
!             INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE) AND A
!             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
!             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
!             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
!             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
!
!     OUTPUT PARAMETERS
!
!     X       FOR I=1,...,N
!
!                  X(I) = (-1)**(I-1)*X(N)
!
!                     + THE SUM FROM K=1 TO K=N-1 OF
!
!                     2*X(K)*SIN((2*I-1)*K*PI/(2*N))
!
!                  A CALL OF SINQF FOLLOWED BY A CALL OF
!                  SINQB WILL MULTIPLY THE SEQUENCE X BY 4*N.
!                  THEREFORE SINQB IS THE UNNORMALIZED INVERSE
!                  OF SINQF.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             BE DESTROYED BETWEEN CALLS OF SINQF OR SINQB.
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
!     SUBROUTINE SINQB COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
!     WAVE DATA. THAT IS , SINQB COMPUTES A SEQUENCE FROM ITS
!     REPRESENTATION IN TERMS OF A SINE SERIES WITH ODD WAVE NUMBERS.
!     THE TRANSFORM IS DEFINED BELOW AT OUTPUT PARAMETER X.
!
!     SINQF IS THE UNNORMALIZED INVERSE OF SINQB SINCE A CALL OF SINQB
!     FOLLOWED BY A CALL OF SINQF WILL MULTIPLY THE INPUT SEQUENCE X
!     BY 4*N.
!
!     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE SINQB MUST BE
!     INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE).
!
!
!     INPUT PARAMETERS
!
!     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
!             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
!
!     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
!             IN THE PROGRAM THAT CALLS SINQB. THE WSAVE ARRAY MUST BE
!             INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE) AND A
!             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
!             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
!             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
!             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
!
!     OUTPUT PARAMETERS
!
!     X       FOR I=1,...,N
!
!                  X(I)= THE SUM FROM K=1 TO K=N OF
!
!                    4*X(K)*SIN((2K-1)*I*PI/(2*N))
!
!                  A CALL OF SINQB FOLLOWED BY A CALL OF
!                  SINQF WILL MULTIPLY THE SEQUENCE X BY 4*N.
!                  THEREFORE SINQF IS THE UNNORMALIZED INVERSE
!                  OF SINQB.
!
!     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
!             BE DESTROYED BETWEEN CALLS OF SINQB OR SINQF.
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
!     SUBROUTINE RFFTI INITIALIZES THE ARRAY WSAVE WHICH IS USED IN
!     BOTH RFFTF AND RFFTB. THE PRIME FACTORIZATION OF N TOGETHER WITH
!     A TABULATION OF THE TRIGONOMETRIC FUNCTIONS ARE COMPUTED AND
!     STORED IN WSAVE.
!
!     INPUT PARAMETER
!
!     N       THE LENGTH OF THE SEQUENCE TO BE TRANSFORMED.
!
!     OUTPUT PARAMETER
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
!             THE SAME WORK ARRAY CAN BE USED FOR BOTH RFFTF AND RFFTB
!             AS LONG AS N REMAINS UNCHANGED. DIFFERENT WSAVE ARRAYS
!             ARE REQUIRED FOR DIFFERENT VALUES OF N. THE CONTENTS OF
!             WSAVE MUST NOT BE CHANGED BETWEEN CALLS OF RFFTF OR RFFTB.
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
!     SUBROUTINE RFFTB COMPUTES THE REAL PERODIC SEQUENCE FROM ITS
!     FOURIER COEFFICIENTS (FOURIER SYNTHESIS). THE TRANSFORM IS DEFINED
!     BELOW AT OUTPUT PARAMETER R.
!
!     INPUT PARAMETERS
!
!     N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
!             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
!             N MAY CHANGE SO LONG AS DIFFERENT WORK ARRAYS ARE PROVIDED
!
!     R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE
!             TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
!             IN THE PROGRAM THAT CALLS RFFTB. THE WSAVE ARRAY MUST BE
!             INITIALIZED BY CALLING SUBROUTINE RFFTI(N,WSAVE) AND A
!             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
!             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
!             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
!             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
!             THE SAME WSAVE ARRAY CAN BE USED BY RFFTF AND RFFTB.
!
!
!     OUTPUT PARAMETERS
!
!     R       FOR N EVEN AND FOR I = 1,...,N
!
!                  R(I) = R(1)+(-1)**(I-1)*R(N)
!
!                       PLUS THE SUM FROM K=2 TO K=N/2 OF
!
!                        2.*R(2*K-2)*COS((K-1)*(I-1)*2*PI/N)
!
!                       -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*PI/N)
!
!             FOR N ODD AND FOR I = 1,...,N
!
!                  R(I) = R(1) PLUS THE SUM FROM K=2 TO K=(N+1)/2 OF
!
!                       2.*R(2*K-2)*COS((K-1)*(I-1)*2*PI/N)
!
!                      -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*PI/N)
!
!      *****  NOTE
!                  THIS TRANSFORM IS UNNORMALIZED SINCE A CALL OF RFFTF
!                  FOLLOWED BY A CALL OF RFFTB WILL MULTIPLY THE INPUT
!                  SEQUENCE BY N.
!
!     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
!             CALLS OF RFFTB OR RFFTF.
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
!     SUBROUTINE RFFTF COMPUTES THE FOURIER COEFFICIENTS OF A REAL
!     PERODIC SEQUENCE (FOURIER ANALYSIS). THE TRANSFORM IS DEFINED
!     BELOW AT OUTPUT PARAMETER R.
!
!     INPUT PARAMETERS
!
!     N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
!             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
!             N MAY CHANGE SO LONG AS DIFFERENT WORK ARRAYS ARE PROVIDED
!
!     R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE
!             TO BE TRANSFORMED
!
!     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
!             IN THE PROGRAM THAT CALLS RFFTF. THE WSAVE ARRAY MUST BE
!             INITIALIZED BY CALLING SUBROUTINE RFFTI(N,WSAVE) AND A
!             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
!             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
!             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
!             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
!             THE SAME WSAVE ARRAY CAN BE USED BY RFFTF AND RFFTB.
!
!
!     OUTPUT PARAMETERS
!
!     R       R(1) = THE SUM FROM I=1 TO I=N OF R(I)
!
!             IF N IS EVEN SET L =N/2   , IF N IS ODD SET L = (N+1)/2
!
!               THEN FOR K = 2,...,L
!
!                  R(2*K-2) = THE SUM FROM I = 1 TO I = N OF
!
!                       R(I)*COS((K-1)*(I-1)*2*PI/N)
!
!                  R(2*K-1) = THE SUM FROM I = 1 TO I = N OF
!
!                      -R(I)*SIN((K-1)*(I-1)*2*PI/N)
!
!             IF N IS EVEN
!
!                  R(N) = THE SUM FROM I = 1 TO I = N OF
!
!                       (-1)**(I-1)*R(I)
!
!      *****  NOTE
!                  THIS TRANSFORM IS UNNORMALIZED SINCE A CALL OF RFFTF
!                  FOLLOWED BY A CALL OF RFFTB WILL MULTIPLY THE INPUT
!                  SEQUENCE BY N.
!
!     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
!             CALLS OF RFFTF OR RFFTB.
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
!     RATIONAL CHEBYCHEV APPROXIMATION OF CONTINUOUS FUNCTIONS
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
!     ERROR RETURN
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
!     COMPUTE INITIAL APPROXIMATIONS OF THE CRITICAL POINTS
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
!     EVALUATE PHI AT THE CRITICAL POINTS
!
30 do 31 i = 1,np1
31 xval(i) = phi(x(i))
kount = 1
!
!     SET UP THE LINEAR EQUATIONS
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
!     REDEFINE THE EQUATIONS AND SOLVE
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
!     STORE THE RESULTS IN P AND Q
!
do 60 i = 2,mp1
lpi = l + i
60 q(i) = d(lpi)
61 do 62 i = 1,lp1
62 p(i) = d(i)
!
!     SEARCH FOR NEW CRITICAL POINTS
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
!     SEARCH FOR AN EXTRA EXTREMAL POINT BETWEEN THE ENDPOINTS
!     OF THE INTERVAL AND THE CRITICAL POINTS
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
!     CHECK FOR CONVERGENCE
!
120 if (z1 .le. eps) return
!
!     SET UP FOR THE NEXT ITERATION
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
!     ERROR RETURN
!     ------------------------------------------------------------------
!     INPUT ERROR
!
200 ierr = 1
return
!
!     MXITER ITERATIONS WERE PERFORMED - MORE ITERATIONS ARE NEEDED
!
210 ierr = 2
return
!
!     THE LINEAR EQUATIONS CANNOT BE SOLVED
!
220 if (itno .eq. 1) go to 250
ierr = 3
return
!
!     THE SEQUENCE OF CRITICAL POINTS IS NOT MONOTONICALLY INCREASING
!
230 ierr = 4
if (i .le. n) error = olderr
return
!
!     IT APPEARS THAT THE ALGORITHM HAS FAILED TO CONVERGE
!     THERE MAY BE POLES IN THE RATIONAL APPROXIMATION
!
240 ierr = 5
return
!
!     THE ROUTINE HAS COMPLETELY FAILED - THE RESULTS SHOULD BE IGNORED
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
!     COMPUTE THE APPROXIMATION ERROR AT POINT T
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
!     ERROR RETURN
!     ------------------------------------------------------------------
!     THE FUNCTION G IS ZERO AT POINT T
!
100 ierr = 1
return
!
!     THE ROUTINE HAS COMPLETELY FAILED - THE RESULTS SHOULD BE IGNORED
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
!     TABULATION OF THE INTERNAL AND EXTERNAL NAMES OF THE ARGUMENTS.
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
!     THIS ALGORITHM COMPUTES A PIECEWISE POLYNOMIAL APPROXIMATION
!  OF SPECIFIED SMOOTHNESS, ACCURACY AND DEGREE.  THE INPUT TO THE
!  COMPUTATION IS
!
!   F      - FUNCTION BEING APPROXIMATED. IT MUST PROVIDE VALUES OF
!            DERIVATIVES UP TO THE ORDER OF SMOOTHNESS SPECIFIED FOR
!            THE APPROXIMATION.  THE CALLING SEQUENCE IS F(X,FDERV) AND
!            FDERV CONTAINS THE DERIVATIVES( SEE CONSTRAINT BELOW)
!   A,B    - THE ENDPOINTS OF THE INTERVAL OF APPROXIMATION
!   ACCUR  - THE ACCURACY REQUIRED FOR THE APPROXIMATION
!   SMOOTH - THE SMOOTHNESS REQUIRED FOR THE APPROXIMATION
!              = 0  MEANS CONTINUOUS
!              = 1  MEANS CONTINUOUS SLOPE
!              = 2  MEANS CONTINUOUS SECOND DERIVATIVE, ETC.
!   DEGREE - THE DEGREE OF THE POLYNOMIAL PIECES.
!            MUST HAVE DEGREE GT 2*SMOOTH
!   CHARF  - CHARACTERISTIC LENGTH OF THE FUNCTION F(X). PIECES ARE NOT
!            LONGER THAN THIS LENGTH.
!   NORM   - NORM TO MEASURE THE APPROXIMATION ERROR
!              = 1  L1 APPROXIMATION (LEAST DEVIATIONS)
!              = 2  L2 APPROXIMATION (LEAST SQUARES)
!              = 3  TCHEBYCHEFF (MINIMAX) APPROXIMATION
!              =-P  (NEGATIVE VALUE) GENERAL LP APPROXIMATION
!   NBREAK - NUMBER OF SPECIAL BREAK POINTS IN THE APPROXIMATION.
!            ASSOCIATED INPUT VARIABLES ARE
!              XBREAK(J)  - LOCATION OF BREAK POINTS
!              DBREAK(J)  - DERIVATIVE BROKEN AT XBREAK
!              BLEFT (J)  - VALUE FROM LEFT FOR DBREAK DERIVATIVE
!              BRIGHT(J)  -   -    -   RIGHT -    -        -
!   EDIST  - SWITCH TO CHANGE FROM PROPORTIONAL ERROR DISTRIBUTION
!            TO FIXED DISTRIBUTION. THIS IS PRIMARILY OF USE IN
!            APPROXIMATION OF FUNCTIONS WITH SINGULARITIES. ONE SHOULD
!            USE NORM = 1. OR SO IN SUCH CASES
!              = 0  PROPORTIONAL DISTRIBUTION
!              = 1  APPROXIMATE FIXED ERROR DISTRIBUTION
!                   ATTEMPTS TO ACHIEVE SPECIFIED ACCURACY VALUE ACCUR
!              = 2  TRUE FIXED ERROR DISTRIBUTION
!
!  ********** OUTPUT **********
!     THE OUTPUT OF THE COMPUTATION CONSISTS OF 4 PARTS, EACH RETURNED
!     TO THE USER IN A DIFFERENT WAY. THEY ARE
!
!   XKNOTS,COEFS - ARRAYS DEFINING THE PIECEWISE POLYNOMIAL RESULT.
!            XKNOTS(K)  = KNOTS OF THE APPROXIMATION ( K = 1 TO KNOTS)
!                         THE LAST ONE IS RIGHT END POINT OF INTERVAL
!            COEFS(K,N) = COEFFICIENT OF (X - XKNOT(K))**(N-1) IN THE
!                         INTERVAL XKNOT(K) TO XKNOT(K+1)
!                           K = 1 TO KNOTS-1  AND  N = 1 TO DEGREE+1
!            THESE ARRAYS ARE PASSED AS ARGUMENTS SO AS TO USE VARIABLE
!            DIMENSIONS. THE ARRAYS ARE OF DIMENSION XKNOTS(KDIMEN) AND
!            COEFS(KMAX,NDIMEN). IT IS ASSUMED THAT KDIMEN = KMAX+1.
!               ***** NOTE ***** SEVERAL SMALL ARRAYS HERE HAVE FIXED
!                        DIMENSIONS THAT LIMIT DEGREE AND THUS NDIMEN
!                        SHOULD NOT EXCEED THIS LIMIT (CURRENTLY = 20)
!
!   RESULZ - A LABELED COMMON BLOCK CONTAINING KNOTS AND ERROR
!              KNOTS - NUMBER OF KNOTS OF THE APPROXIMATION
!              ERROR - ESTIMATED ACCURACY OF THE APPROXIMATION
!
!   IERR - STATUS INDICATOR. IERR TAKES THE VALUES
!      0   THE APPROXIMATION WAS SUCCESSFULLY CONSTRUCTED.
!     -1   INPUT ERROR REPORTED BY ADSET.
!     -2   A AND B ARE TOO CLOSE.
!     -3   CHARF IS TOO SMALL.
!     -4   EITHER ALL THE BREAK POINTS ARE NOT BETWEEN A AND B, OR
!          XBREAK(I).GE.XBREAK(I+1) FOR SOME I.
!     -5   DBREAK(I).LT.0 .OR. DBREAK(I).GT.(DEGREE-1)/2 FOR SOME I.
!      1   THE KNOT LIMIT WAS EXCEEDED.
!      2   BREAK POINT ADJUSTMENT REQUIRES THAT A SUBINTERVAL BE
!          PARTITIONED. HOWEVER, THIS CANNOT BE DONE EITHER BECAUSE
!          THE INTERVAL STACK IS FULL, OR PARTITIONING WILL PRODUCE
!          TOO SMALL AN INTERVAL.
!      3   A SUBINTERVAL MUST BE PARTITIONED BECAUSE ITS LENGTH IS
!          GREATER THAN CHARF. HOWEVER, THIS CANNOT BE DONE SINCE THE
!          INTERVAL STACK IS FULL.
!      4   A SUBINTERVAL MUST BE PARTITIONED SO THAT THE ACCURACY
!          CRITERIA CAN BE SATISFIED. HOWEVER, THIS CANNOT BE DONE
!          EITHER BECAUSE THE INTERVAL STACK IS FULL, OR PARTITIONING
!          WILL PRODUCE TOO SMALL AN INTERVAL.
!
!  ********** DIMENSION CONSTRAINTS **********
!     MAXKNT - MAX NUMBER OF KNOTS TAKEN FROM USER VIA KDIMEN
!              ARRAYS WITH THIS DIMENSION (OR RELATED VALUES)
!                   COEFS   XKNOTS
!     MAXPAR - MAX NUMBER OF PARAMETERS PER INTERVAL (CURRENTLY = 20)
!                   USER PROVIDED NDIMEN MUST HAVE NDIMEN LE MAXPAR
!                   MUST HAVE  DEGREE + 1 LE MAXPAR
!              ARRAYS WITH THIS DIMENSION (OR RELATED VALUES)
!                D       DDTEMP  FDERVL  FDERVR  FDUMB   FACTOR
!                FINTRP  FLEFT   FRIGHT  POWERS  XTEMP   XINTRP  XDD
!              ***** NOTE ***** MAXPAR ALSO AFFECTS ARGUMENT FDERV
!              OF FUNCTION F.  FDERVL, FDERVR ARE ALSO INVOLVED.
!              SHOULD DECLARE FDERV OF SIZE 10 IN F TO BE SAFE.
!     MAXAUX - MAXIMUM NUMBER OF AUXILIARY INPUT ( = 20 NOW ). ARRAYS
!                 XBREAK  DBREAK  BLEFT   BRIGHT
!     MAXSTK - MAX SIZE OF ACTIVE INTERVAL STACK
!              MIN INTERVAL LENGTH IS 2**(-MAXSTK)*(B-A). ARRAYS
!                 XLEFT   XRIGHT
!
!  **********  PORTABILITY CONSIDERATIONS  **********
!
!     ALL THE ROUTINES IN THIS PACKAGE (EXCEPT ADAPT) ARE WRITTEN IN
!     ANSI STANDARD FORTRAN. IN ADDITION, THEY MEET ALL THE REQUIREMENTS
!     OF THE BELL LABS PORTABLE FORTRAN -PFORT-.  NEVERTHELESS, THE
!     ROUTINES ARE AFFECTED BY A CHANGE IN MACHINE WORD LENGTH AND
!     CHANGING TO SINGLE PRECISION.
!
!     ***** THE GAUSS WEIGHTS AND ABSCISSAE IN ADCOMP ARE GIVEN TO
!           30 DIGITS. THE PARAMETER EPS0 IN ADSET SPECIFIES THE
!           ACCURACY OF THESE CONSTANTS. IF THE ACCURACY IS CHANGED
!           TO K DECIMAL DIGITS THEN SET EPS0 = 10**(-K).
!
!     ***** THE INTERVAL STACK SIZE MAXSTK IS DEFINED IN ADSET TO
!           BE 50. IF MAXSTK IS MODIFIED THEN SET THE DIMENSIONS OF
!           XLEFT AND XRIGHT TO THE NEW VALUE FOR MAXSTK. NOTE THAT
!           THE MINIMUM INTERVAL LENGTH IS 2**(-MAXSTK)*(B-A).
!
!  SINGLE PRECISION CONVERSION -- REQUIRES FOUR STEPS
!     1. DECLARE ALL DOUBLE PRECISION VARIABLES TO BE REAL.
!
!     2. CHANGE ALL DOUBLE PRECISION NUMBERS IN THE DATA STATEMENTS.
!        (FLOATING POINT NUMBERS APPEAR ONLY IN DATA STATEMENTS.)
!
!     3. CHANGE DABS,DMAX1,DMIN1 AT MANY PLACES.
!
!     4. CHANGE DPMPAR TO SPMPAR IN ADSET.
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
!                      KNTDIM - KDIMEN, NAME CHANGED TO PUT IN COMMON
!                      NPARDM - NDIMEN, NAME CHANGED TO PUT IN COMMON
common /resulz/ error, knots
!                      KNOTS = FINAL NO. OF KNOTS, INCLUDES B AS ONE.
!                      ERROR = ESTIMATE OF ERROR ACTUALLY ACHIEVED.
common /kontrl/ dsctol, errori, xleft, xright, break, both, &
&factor, ibreak, interp, left, maxaux, maxknt, maxpar, maxstk, &
&npar, nstack, right, discrd, buffer
!             KONTRL CONTAINS GENERALLY USEFUL VARIABLES
!                      MAXSTK - SEE COMMENTS ABOVE
!                      BUFFER - THE MACHINE DEPENDENT TOLERANCE USED
!                               BY THE ALGORITHM
!                      NSTACK - COUNTER FOR INTERVAL STACK, CONSISTS OF
!                               (XLEFT(J),XRIGHT(J))  J = 1 TO NSTACK
!                      ERRORI - ERROR ESTIMATE FOR TOP INTERVAL
!                      DSCTOL - TOLERANCE TO CHECK DISCARDING INTERVALS
!                      DISCRD - SWITCH TO SIGNAL DISCARD OF TOP INTERVAL
!                      FACTOR - ARRAY OF FACTORIALS
!                      NPAR   - NUMBER OF PAREMETERS = DEGREE + 1
!                      INTERP - NUMBER OF INTERIOR INTERPOLATION POINTS
!                               IN THE NORMAL INTERVAL
!                      IBREAK - COUNTER ON BREAK POINTS
!                      BREAK  - SWITCH FOR BREAK POINT IN TOP INTERVAL
!                               0     = NO BREAK PRESENT
!                               LEFT  = BREAK AT XLEFT(NSTACK)
!                               RIGHT = BREAK AT XRIGHT(NSTACK)
!                               BOTH  = BREAK AT BOTH ENDS
common /comdif/ ddtemp, fintrp, fleft, fright, xdd, xintrp, &
&leftx, nintrp, rightx
!             COMDIF CONTAINS VARIABLES USED ONLY BY ADCOMP AND FRIENDS.
!                      NINTRP - NUMBER OF INTERIOR INTERPOLATION POINTS
!                               FOR THE CURRENT INTERVAL
!                      XINTRP - INTERIOR INTERPOLATION POINTS
!                      FINTRP - F VALUES AT XINTRP POINTS
!                      LEFTX  - MULTIPLICITY OF INTERPOLATION AT XLEFT
!                               = NO. OF DERIVATIVES MATCHED AT XLEFT
!                      FLEFT  - VALUES OF F AND ITS DERIVATIVES AT XLEFT
!                      RIGHTX - MULTIPLICITY OF INTERPOLATION AT XRIGHT
!                      FRIGHT - VALUES OF F AND DERIVATIVES AT XRIGHT
!                      DDTEMP - THE ARRAY OF DIVIDED DIFFERENCES
!                      XDD    - THE X VALUES FOR DDTEMP WITH PROPER
!                               MULTIPLICITIES OF XLEFT AND XRIGHT
!
!------------------------ MAIN CONTROL PROGRAM -------------------------
!
!            CHECK THE INPUT AND INITIALIZE ALL THE PARAMETERS
!
call adset(xknots, coefs, kdimen, kmax, ndimen, ierr)
if (ierr.ne.0) return
!
!                  LOOP OVER PROCESSING OF INTERVALS
!
10 call adtake(ierr)
if (ierr.ne.0) return
call adcomp(f)
!
!                   CHECK FOR DISCARDING INTERVALS
!
call adchk
!
!            PUT NEW INTERVALS ON STACK OR DISCARD, UPDATE STATUS
!
call adput(xknots, coefs, kdimen, kmax, ndimen, ierr)
if (ierr.ne.0) return
!
!                    TEST FOR NORMAL TERMINATION
!
if (nstack.eq.0) return
!
!                CHECK ON THE NUMBER OF KNOTS GENERATED
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
!         PUT DATA STATEMENT ITEMS INTO COMMON VARIABLES
!
left = kleft
right = kright
both = kboth
!
! -------- SET CURRENT VALUES OF LIMITS ON DIMENSIONS ------------------
!
kntdim = kdimen
npardm = ndimen
maxknt = kntdim
maxstk = 50
maxpar = min0(20,npardm)
maxaux = 20
!
! -------- CHECK INPUT DATA --------------------------------------------
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
!         CHECK THE BREAK POINT DATA, MONOTONICITY AND DEGREE
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
! -------- INITIALIZATION OF VARIABLES ---------------------------------
!
!             ACTIVE INTERVAL STACK
!
150 nstack = 1
xleft(1) = a
xright(1) = b
!
!             TERMINATION AND ERROR VALUES
!
error = zero
dsctol = accur**dabs(norm)
if (edist.eq.0) dsctol = dsctol/(b-a)
if (norm.eq.three) dsctol = accur
!
!             MISCELLANEOUS VARIABLES AND POINTERS
!
ibreak = 1
knots = 1
interp = degree + 2 - 2*smooth
xknots(1) = a
npar = degree + 1
!
!             COMPUTE ARRAY OF NPAR FACTORIALS
!
factor(1) = one
factor(2) = one
do k=3,npar
  km1 = k-1
  factor(k) = km1*factor(k-1)
end do
return
!
! -------- ERROR RETURN ------------------------------------------------
!
200 ierr = -1
return
!
!         A AND B ARE TOO CLOSE
!
210 ierr = -2
return
!
!         CHARF IS TOO SMALL
!
220 ierr = -3
return
!
!         BREAK POINTS ARE NOT MONOTONIC
!
230 ierr = -4
return
!
!         BAD VALUE IN DERIVATIVE BREAKS
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
!     IT ALSO DOES MOST OF THE WORK OF LOCATING AND HANDLING
!     BREAK POINTS
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
!         CHECK FOR BREAK POINT
break = 0
if (nbreak.eq.0 .or. ibreak.gt.nbreak) go to 20
if (xbreak(ibreak).gt.xright(nstack)) go to 20
!
!               SET CONTROL VARIABLE BREAK, CHECK FOR LOCATION
if (xbreak(ibreak).gt.xleft(nstack)) go to 10
break = left
if (ibreak.eq.nbreak) go to 20
!             CHECK FOR SECOND BREAK POINT IN THIS INTERVAL
if (xbreak(ibreak+1).ge.xright(nstack)) go to 20
!                 NEXT BREAK IS INSIDE INTERVAL, SPLIT TOP INTERVAL
break = both
!                  CHECK EXCEEDING STACK LIMIT. IF SO, STOP
if (nstack.eq.maxstk) go to 30
!                     DONT SPLIT VERY SMALL INTERVALS, STOP INSTEAD
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
!                 CHECK TO SEE IF BREAK IS ALREADY AT RIGHT END POINT
if (xbreak(ibreak).ge.xright(nstack)) go to 20
!                 THE BREAK IS INSIDE INTERVAL, SPLIT TOP INTERVAL
!                  CHECK EXCEEDING STACK LIMIT. IF SO, STOP
if (nstack.eq.maxstk) go to 30
!                     DONT SPLIT VERY SMALL INTERVALS, STOP INSTEAD
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
!        A BREAK POINT IS IN THE INTERIOR OF THE TOP SUBINTERVAL OF
!        THE STACK.  THE SUBINTERVAL CANNOT BE PARTITIONED EITHER
!        BECAUSE THE STACK IS FULL, OR BECAUSE PARTITIONING LEADS TO
!        TOO SMALL AN INTERVAL.
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
!     THE CURRENT INTERVAL. IT ALSO ESTIMATES THE ERROR
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
!     THIRTY DIGIT VALUES FOR THE GAUSS INTEGRATION CONSTANTS
!                    .861136311594052575223946488893D0
!                    .339981043584856264802665759103D0
!                    .347854845137453857373063949222D0
!                    .652145154862546142626936050778D0
!
!     ***** THE ABSISSAE AND WEIGHTS ARE GIVEN BELOW TO 30 DIGITS.
!           THE PARAMETER EPS0 IN ADSET SPECIFIES THE ACCURACY OF
!           THESE CONSTANTS. IF THE ACCURACY IS CHANGED TO K DECIMAL
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
!             COMPUTE INTERPOLATION INFORMATION
nintrp = degree - 2*smooth - 1
!
!          INCREASE NUMBER OF INTERPOLATION POINTS IF BREAK POINTS ARE
!          SPECIFIED WITH FEWER DERIVATIVES THAN SMOOTH
if (break.eq.left .or. break.eq.right) nintrp = nintrp + smooth - &
&dbreak(ibreak)
if (break.eq.both) nintrp = nintrp + 2*smooth - dbreak(ibreak) - &
&dbreak(ibreak+1)
if (nintrp.eq.0) go to 20
!
!             GENERATE EQUAL SPACED INTERPOLATION POINTS
aj = nintrp+1
dx = (xright(nstack)-xleft(nstack))/aj
do 10 j = 1,nintrp
  aj = j
  xintrp(j) = xleft(nstack) + aj*dx
10 continue
!
!             GET LEFT AND RIGHT F-VALUES, PUT F-VALUE IN FIRST ELEMENT
!             OF ARRAYS FLEFT AND FRIGHT.  GET DERIVATIVES BACK AS
!             OTHER ELEMENTS VIA THE SUBARRAYS FDERVL AND FDERVR.
20 fleft(1) = f(xleft(nstack),fdervl)
fright(1) = f(xright(nstack),fdervr)
leftx = smooth + 1
rightx = leftx
!            GET F-VALUES AT OTHER INTERPOLATION POINTS, IF ANY
if (nintrp.eq.0) go to 40
do j=1,nintrp
  fintrp(j) = f(xintrp(j),fdumb)
end do
!
!          CHECK FOR BREAK POINTS, MODIFY VALUES IF NECESSARY
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
!           COMPUTE DIVIDED DIFFERENCES, NEWTON FORM OF POLYNOMIAL
call newton(leftx, rightx, nintrp)
!
!         COMPUTE NORM OF ERROR OF THIS APPROMIMATION USING FOUR PTS
!         ADD 50 PERCENT FUDGE FACTOR
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
!     ABSOLUTE VALUE OF THE DIFFERENCE OF TWO FUNCTIONS( F AND FIT )
!                   ABS( F(X) - FIT(X) )**NORM
!     THE INTEGRATION USES THE POINTS AND WEIGHTS GIVEN AND SCALED
!     FROM (-1,1) TO (AAA,BBB)
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
!         TEST FOR TCHEBYCHEFF (MINIMAX) NORM WHICH USES SPECIAL CODE
if (norm.eq.three) go to 20
!
!         HAVE GENERAL LP NORM OR LEAST SQUARES OR LEAST DEVIATIONS
p = dabs(norm)
!              INITIALIZE THE QUADRATURE RULE
errint = dabs(f(pj,fdumb)-fit(pj))**p*weight(1)
!              LOOP THROUGH REMAINING POINTS
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
!         TCHEBYCHEFF NORM
20 continue
!             FIND MAX ERROR ON POINTS
!               INITIALIZE
errint = dabs(f(pj,fdumb)-fit(pj))
!              LOOP THROUGH THE REMAINING POINTS
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
!         LAYOUT OF THE DDTEMP DIVIDED DIFFERENCE ARRAY
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
!                 MAIN CALCULATION OF DIVIDED DIFFERENCES
!         DEFINE A FEW SHORT CONSTANTS
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
!            CHECK IF THERE ARE ANY INTERPOLATION POINTS TO ADD TO XDD
if (ni.eq.0) go to 40
do k=1,ni
  nddx = nddx + 1
  xdd(nddx) = xintrp(k)
end do
!
!           FILL BORDER OF FIRST TRIANGLE - SIZE NL.
40 continue
!         TOP BORDER
do 50 idif = 1,nl
  ddtemp(idif,1) = fleft(idif)/factor(idif)
50 continue
if (nl1.eq.0) go to 70
!                   BOTTOM BORDER
do idif=1,nl1
  ipt = nl2 - idif
  ddtemp(idif,ipt) = ddtemp(idif,1)
end do
!
!          FILL BORDER OF SECOND TRIANGLE - SIZE NR
70 continue
!         TOP BORDER
do idif=1,nr
  ddtemp(idif,nl2) = fright(idif)/factor(idif)
end do
if (nrl.eq.nl2) go to 100
!                   BOTTOM BORDER
do idif=1,nr1
  ipt = nrl + 1 - idif
  ddtemp(idif,ipt) = ddtemp(idif,nl2)
end do
!
!           FILL PARALLOGRAM BETWEEN THE TWO TRIANGLES JUST FILLED
!          FILL ENTRIES PARALLEL TO BOTTOM OF FIRST TRIANGLE
100 continue
!
!         LOOP STEPPING ALONG TOP SIDE OF SECOND TRIANGLE
do j=2,nr2
  idif = j
!             LOOP STEPPING PARALLEL TO BOTTOM SIDE OF FIRST TRIANGLE
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
!         FILL IN BOTTOM DIAGONALS FOR INTERPOLATION POINTS, IF ANY
if (ni.eq.0) go to 150
!         LOOP THROUGH THE INTERPOLATATION POINTS
do j=1,ni
  idif = 2
  nrlj = nrl + j
  ddtemp(1,nrlj) = fintrp(j)
!         LOOP THROUGH THE DIFFERENCES (IDIF INDEX)
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
!     BY THE DIVIDED DIFFERENCES DDTEMP ON THE POINT SET XDD.
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
!     TESTS ABOUT DISCARDING INVOLVING EDIST AND CHARF.
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
!         COMPUTE DTEST FOR THE LOCAL ERROR CRITERION
!
if (norm.eq.three) go to 30
if (edist-1) 10,20,30
10 dtest = dx*dsctol
go to 40
!         FOR THE APPROXIMATE FIXED ERROR DISTRIBUTION TYPE WE ESTIMATE
!         THE FINAL NUMBER OF KNOTS BY( LIMITING IT A LITTLE )
!             (NSTACK+KNOTS+2)((B-A)/(XRIGHT-A))
20 aknots = nstack+knots+2
dtest = dsctol/(aknots*dmin1((b-a)/(xright(nstack)-a),five))
go to 40
30 dtest = dsctol
!
!             CHECK FOR DISCARD OF INTERVAL
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
!     WHEN AN INTERVAL IS DISCARDED A NEW KNOT IS FOUND. THEN THIS
!     PROGRAM UPDATES THE ERROR ESTIMATE, THE XKNOT ARRAY, TRANSFORMS
!     THE POLYNOMIAL TO THE POWER FORM AND PUT THE COEFFICIENTS INTO
!     THE ARRAY COEFS.  IT ALSO CHECKS FOR PASSING BREAK POINTS
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
!            CHECK FOR DISCARDING THE INTERVAL
if (discrd) go to 30
!
!         SUBDIVIDE INTERVAL AND PLACE ON STACK
if (nstack.lt.maxstk) go to 10
!             FATAL ERROR, EXCEEDED ACTIVE STACK SIZE
ierr = 4
dx = xright(nstack)-xleft(nstack)
if (dx.gt.charf) ierr = 3
return
!
10 dx = (xright(nstack)-xleft(nstack))*half
!              CHECK FOR SMALL INTERVALS
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
!            DISCARD INTERVAL, UPDATE GLOBAL ERROR, XKNOTS AND COEFS
30 p = dabs(norm)
if (norm.eq.three) error = dmax1(error,errori)
if (norm.ne.three) error = (error**p+errori)**(one/p)
!
!              CHECK FOR PASSING BREAK POINTS
if (break.eq.left .or. break.eq.both) ibreak = ibreak + 1
!
!             TRANSFORM REPRESENTATION OF POLYNOMIAL FROM DIVIDED
!             DIFFERENCES TO POWERS OF X WITH ORIGIN AT XKNOTS (KNOTS)
call adtran(ddtemp, powers)
!
!             PUT COEFS INTO THE MAIN ARRAY
do k=1,npar
  coefs(knots,k) = powers(k)
end do
!            PUT THE NEW KNOTS IN XKNOTS
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
!     DIFFERENCE TO POWER FORM.  THERE ARE COALESCED POINTS ON EACH
!     END OF THE INTERVAL (XL,XR) = (XLEFT(NSTACK),XRIGHT(NSTACK)).
!     THE NUMBER COALESCED AT EACH END IS LEFTX AND RIGHTX.
!     AND THERE ARE NINTRP OTHER PTS XINTRP(K)  INBETWEEN THEM.
!     SEE SUBROUTINE NEWTON FOR MORE DETAILS
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
!         SET SOME SHORT LOCAL VARIABLE NAMES
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
!         STRATEGY IS TO FIRST CONVERT THE PART FROM THE INTERP. PTS.
!         TO POLY IN (X-XR).  THIS POLY THEN HAS ORIGIN SHIFTED TO XL.
!
!     THE CONVERSION OF THE INTERP PART IS DONE EXPLICITLY FOR DEGREE
!     TWO OR LESS AND DONE BY SYNTHETIC DIVISION FOR HIGHER DEGREES
!
!   D1 + D2(X-X1) +D3(X**2-(X1+X2)X +X1*X2)
!
!     THE RESULTING COEFFICIENTS ARE PUT IN THE ARRAY POWERS
!
if (ni.eq.0) go to 100
!
!             BUILD UP THE POLYNOMIAL FOR THE INTERPOLATION POINTS
!
!         USE SPECIAL FORMULAS FOR NI LESS THAN 3
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
!         INITIALIZE THE POWERS AND XTEMP ARRAYS
do k=1,ni
  xtemp(k) = xintrp(k)
  nrlk = nrl + k
  powers(k) = d(nrlk,1)
end do
!
!         DO THE REPEATED SYNTHETIC DIVISION TO REPLACE THE XTEMP
!         = XINTRP POINTS OF THE NEWTON EXPANSION BY THE XR POINTS
do 70 k = 1,ni1
!              POWERS(NI) IS FIXED AND SET ABOVE
  do 50 ii = 1,ni1
    i = ni - ii
    powers(i) = powers(i) + (xr-xtemp(i))*powers(i+1)
50 continue
!              SHIFT THE NEWTON EXPANSION PTS. UP, PUT IN ONE MORE XR
  do ii=1,ni1
    i = ni - ii
    xtemp(i+1) = xtemp(i)
  end do
  xtemp(1) = xr
70 continue
80 continue
!             SHIFT THE COEFFICIENTS TO THE TOP OF THE POWERS ARRAY
do k=1,ni
  l = ni + 1 - k
  ltop = l + nrl
  powers(ltop) = powers(l)
end do
!
!             HAVE THE INTERPOLATION PT. COEFS. IN THE ARRAY POWERS
100 continue
!             PUT THE REMAINING DIVIDED DIFFS INTO THE POWERS ARRAY
do j=1,nrl
  powers(j) = d(j,1)
end do
!
!         TRANSFORM THE ORIGIN OF THE POLYNOMIAL FROM XR TO XL
!         WE USE REPEATED SYNTHETIC DIVISION
if (nri.eq.1) go to 140
shift = xr - xl
khi = nri1
!             LOOP THROUGH THE COEFFICIENTS
do j=2,nri
!                   SYNTHETIC DIVISION LOOP
  do k=1,khi
    koef = nrli - k
    powers(koef) = powers(koef) - shift*powers(koef+1)
  end do
  khi = khi - 1
end do
140 continue
!     THE COEFFICIENTS ARE NOW OF THE POWER FORM WITH ORIGIN XL
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
!  EVALUATION OF COMPLEX POWER SERIES COEFFICIENTS OR DERIVATIVES.
!
!  *** INPUT PARAMETERS ***
!    F   COMPLEX FUNCTION, OF WHICH THE COEFFICIENTS OR DERIVATIVES
!        ARE SOUGHT. THIS FUNCTION MUST BE DECLARED EXTERNAL IN THE
!        CALLING PROGRAM.
!    Z   COMPLEX POINT AROUND WHICH F IS TO BE EXPANDED OR AT WHICH
!        DERIVATIVES ARE TO BE EVALUATED.
!    N   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
!        N MUST BE GE 1 AND LE 51.
!    IC  SELECTS BETWEEN POWER SERIES COEFFICIENTS AND DERIVATIVES.
!        IC .EQ. 0   ROUTINE RETURNS POWER SERIES COEFFICIENTS IN RS.
!        IC .NE. 0   ROUTINE RETURNS DERIVATIVES IN RS.
!    TOL ESTIMATED RELATIVE ACCURACY OF F. IT IS ASSUMED THAT TOL
!        IS NONNEGATIVE. IF TOL = 0 THEN F IS ASSUMED TO BE CORRECT
!        TO MACHINE ACCURACY.
!
!  *** INPUT AND OUTPUT PARAMETER ***
!    R   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
!        RADIUS IS LEFT IN R. THE PROVIDED GUESS MAY BE IN ERROR WITH AT
!        MOST A FACTOR OF 3.E4 .
!
!  *** OUTPUT PARAMETERS ***
!    RS  COMPLEX ARRAY RS(N) CONTAINING THE N FIRST
!        COEFFICIENTS (CORRESPONDING TO THE POWERS 0 TO N-1) OR DERIVA-
!        TIVES (ORDERS 0 TO N-1).
!    ERR REAL ARRAY ERR(N) CONTAINING ABSOLUTE ERROR ESTIMATES FOR THE
!        NUMBERS IN RS.
!
complex :: f, a(64), v
complex, intent(inout) :: rs(n)
complex :: rt(51,3), fv(6), u, w, t, z, rv(3), rq, s, xk, mult, co
!
!  LIST OF THE VARIABLES INITIALIZED IN THE DATA STATEMENT BELOW.
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
!  STATEMENT FUNCTION FOR MULTIPLICATION OF A COMPLEX NUMBER
!  BY A REAL NUMBER.
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
!  INITIALIZATION.
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
!  START EXECUTION.
!
if (n .gt. 51 .or. n .lt. 1) go to 260
l2 = 1
lf = 0
np = 0
m = 0
nr = -1
!
!  FIND IF A FFT OVER 8, 16, 32, OR 64 POINTS SHOULD BE USED.
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
!  FUNCTION VALUES OF F ARE STORED READY PERMUTATED FOR THE FFT.
!
do 40 i = is,32,is
  iq = ip(i)
  v = v*fv(km)
  a(iq) = f(z + v)
40 a(iq - 1) = f(z - v)
ln = 2
jn = 1
!
!  THE LOOP  DO 70 ... CONSTITUTES THE FFT.
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
!  TEST ON HOW FAST THE COEFFICIENTS OBTAINED DECREASE.
!
do 80 i = 1,ix
  ct = cabs(a(i))/b
  if (ct .lt. cx) go to 80
  cx = ct
  inr = i
80 b = b*c(kl)
if (m .le. 1) go to 100
!
!  ESTIMATE OF THE ROUNDING ERROR LEVEL FOR THE LAST RADIUS.
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
!  TEST IF THE SERIES IS A TAYLOR OR A LAURENT SERIES.
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
!  DETERMINATION OF THE NEXT RADIUS TO BE USED.
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
!  THE RESULTS FOR THE LAST THREE RADII ARE STORED.
!
do 200 i = 1,n
200 rt(i,m) = a(i)
if (m .eq. 1) go to 220
!
!  EXTRAPOLATION.
!
do 210 i = 1,n
  xk = rt(i,m-1) - rt(i,m)
210 rt(i,m-1) = rt(i,m) - mult(fc(m-1),xk)
if (m .eq. 3) go to 230
!
!  CALCULATION OF THE EXTRAPOLATION CONSTANTS.
!
220 fc(m) = 1.5 + sign(.5,fact-1.)
if (m .eq. 2) fc(m) = fc(m) + ra
if (fact .gt. 1.0) fc(m) = -fc(m)
go to 30
230 fc(3) = fc(1)*fc(2)/(fc(1) + fc(2) + 1.0)
!
!  FINAL EXTRAPOLATION AND ERROR ESTIMATE.
!
do 240 i = 1,n
  xk = rt(i,1) - rt(i,2)
  err(i) = err(i) + ep6*cabs(xk)
240 rs(i) = rt(i,2) - mult(fc(3),xk)
!
!  MULTIPLY POWER SERIES COEFFICIENTS AND ERROR ESTIMATE BY FACTORIALS
!  IF DERIVATIVES WANTED.
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
!  ERROR RETURN.
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
!  EVALUATION OF COMPLEX POWER SERIES COEFFICIENTS OR DERIVATIVES.
!
!  *** INPUT PARAMETERS ***
!    FUN SUBROUTINE WHICH COMPUTES THE COMPLEX FUNCTION F FOR WHICH
!        THE COEFFICIENTS OR DERIVATIVES ARE SOUGHT. WE WRITE
!                   CALL FUN(U1,U2,W1,W2)
!        WHEN W = F(U) IS TO BE COMPUTED FOR THE COMPLEX ARGUMENT U.
!        HERE U1 AND U2 ARE THE REAL AND IMAGINARY PARTS OF U, AND W1
!        AND W2 ARE THE REAL AND IMAGINARY PARTS OF W.  U1,U2,W1,W2
!        HAVE DOUBLE PRECISION VALUES. THE SUBROUTINE FUN MUST BE
!        DECLARED IN THE CALLING PROGRAM TO BE OF TYPE EXTERNAL.
!    X   REAL PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
!        EXPANDED OR AT WHICH ITS DERIVATIVES ARE TO BE COMPUTED.
!    Y   IMAGINARY PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
!        EXPANDED OR AT WHICH ITS DERIVATIVES ARE TO BE COMPUTED.
!    N   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
!        N MUST BE GE 1 AND LE 51.
!    IC  SELECTS BETWEEN POWER SERIES COEFFICIENTS AND DERIVATIVES.
!        IC .EQ. 0   ROUTINE RETURNS POWER SERIES COEFFICIENTS IN
!                    RS1 AND RS2.
!        IC .NE. 0   ROUTINE RETURNS DERIVATIVES IN RS1 AND RS2.
!    TOL ESTIMATED RELATIVE ACCURACY OF FUN. IT IS ASSUMED THAT TOL
!        IS NONNEGATIVE. IF TOL = 0 THEN FUN IS ASSUMED TO BE CORRECT
!        TO MACHINE ACCURACY.
!
!  *** INPUT AND OUTPUT PARAMETER ***
!    R   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
!        RADIUS IS LEFT IN R. THE PROVIDED GUESS MAY BE IN ERROR WITH AT
!        MOST A FACTOR OF 3.E4 .
!
!  *** OUTPUT PARAMETERS ***
!    RS1 ARRAY RS1(N) CONTAINING THE REAL PARTS OF THE FIRST N COMPLEX
!        COEFFICIENTS (CORRESPONDING TO THE POWERS 0 TO N-1) OR DERIVA-
!        TIVES (ORDERS 0 TO N-1).
!    RS2 ARRAY RS2(N) CONTAINING THE IMAGINARY PARTS OF THE FIRST N
!        COEFFICIENTS (CORRESPONDING TO THE POWERS 0 TO N-1) OR DERIVA-
!        TIVES (ORDERS 0 TO N-1).
!    ERR REAL ARRAY ERR(N) CONTAINING ABSOLUTE ERROR ESTIMATES FOR THE
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
!  LIST OF THE VARIABLES INITIALIZED IN THE DATA STATEMENT BELOW.
!   IW   2**( 0 , 1 , 2 , 3 , 4 , 5 , 6 ) .
!   IP   PERMUTATION CONSTANTS FOR THE FFT.
!   RV1  REAL PARTS OF THE CONSTANTS FOR THE LAURENT SERIES TEST.
!   RV2  IMAGINARY PARTS OF THE CONSTANTS FOR THE LAURENT SERIES TEST.
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
!  INITIALIZATION.
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
!  START EXECUTION.
!
if (n .gt. 51 .or. n .lt. 1) go to 260
l2 = 1
lf = 0
np = 0
m = 0
nr = -1
!
!  FIND IF A FFT OVER 8, 16, 32, OR 64 POINTS SHOULD BE USED.
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
!  FUNCTION VALUES OF F ARE STORED READY PERMUTATED FOR THE FFT.
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
!  THE LOOP  DO 70 ... CONSTITUTES THE FFT.
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
!  TEST ON HOW FAST THE COEFFICIENTS OBTAINED DECREASE.
!
do 80 i = 1,ix
   ct = dcpabs(a1(i),a2(i))/b
   if (ct .lt. cx) go to 80
   cx = ct
   inr = i
80 b = b*c(kl)
if (m .le. 1) go to 100
!
!  ESTIMATE OF THE ROUNDING ERROR LEVEL FOR THE LAST RADIUS.
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
!  TEST IF THE SERIES IS A TAYLOR OR A LAURENT SERIES.
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
!  DETERMINATION OF THE NEXT RADIUS TO BE USED.
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
!  THE RESULTS FOR THE LAST THREE RADII ARE STORED.
!
do 200 i = 1,n
   rt1(i,m) = a1(i)
200 rt2(i,m) = a2(i)
if (m .eq. 1) go to 220
!
!  EXTRAPOLATION.
!
mm1 = m - 1
do 210 i = 1,n
   u = rt1(i,mm1) - rt1(i,m)
   v = rt2(i,mm1) - rt2(i,m)
   rt1(i,mm1) = rt1(i,m) - fc(mm1)*u
210 rt2(i,mm1) = rt2(i,m) - fc(mm1)*v
if (m .eq. 3) go to 230
!
!  CALCULATION OF THE EXTRAPOLATION CONSTANTS.
!
220 fc(m) = 1.5d0 + dsign(0.5d0,fact-1.d0)
if (m .eq. 2) fc(m) = fc(m) + ra
if (fact .gt. 1.d0) fc(m) = -fc(m)
go to 30
230 fc(3) = fc(1)*fc(2)/(fc(1) + fc(2) + 1.d0)
!
!  FINAL EXTRAPOLATION AND ERROR ESTIMATE.
!
do 240 i = 1,n
   u = rt1(i,1) - rt1(i,2)
   v = rt2(i,1) - rt2(i,2)
   err(i) = err(i) + ep6*dcpabs(u,v)
   rs1(i) = rt1(i,2) - fc(3)*u
240 rs2(i) = rt2(i,2) - fc(3)*v
!
!  MULTIPLY POWER SERIES COEFFICIENTS AND ERROR ESTIMATE BY FACTORIALS
!  IF DERIVATIVES WANTED.
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
!  ERROR RETURN.
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
!     BISECTION SEARCH
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
!     EVALUATION
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
!     LAGRANGE INTERPOLATION
!     ******************************************************************
!
!     CHECK INPUT
!
if (m.lt.2) go to 130
if (m.gt.n) go to 131
if (ni.lt.1) go to 132
ierr = 0
!
!     INITIALIZATION
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
!     BISECTION SEARCH
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
!     LINEAR FORWARD SEARCH
!
40 if (xx-x(i+1)) 50,41,42
41 i = i+1
yi(k) = y(i)
go to 110
42 i = i+1
go to 40
!
!     POINT XX LIES IN THE OPEN SUBINTERVAL (X(I),X(I+1)).
!     FIND THE M CLOSEST POINTS X(IL),...,X(IR) TO XX.
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
!     COMPUTE THE COEFFICIENTS T(1),...,T(M) OF THE BACKWARD
!     NEWTON FORM OF THE INTERPOLATING POLYNOMIAL.
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
!     EVALUATION OF THE INTERPOLATING POLYNOMIAL
!
100 yi(k) = t(1)
do 101 j = 2,m
l = ilm1+j
101 yi(k) = t(j)+yi(k)*(xx-x(l))
!
!     NEXT POINT
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
!     ERROR RETURN
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
!     HERMITE INTERPOLATION
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
!     UNWEIGHTED LEAST SQUARES POLYNOMIAL FIT
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
!                      INITIALIZATION
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
!           COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE 0
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
!          GENERATE LAMBDA(M)*PHI(M) AND EVALUATE IT AT Z
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
!                COMPUTE ALPHA(M) AND LAMBDA(M)
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
!              GENERATE PHI(M) AND EVALUATE IT AT Z
!
do 70 k = 1,mp1
70 phi(la,k)=phi(la,k)/lambda
do 71 k = 1,np
71 phix(la,k)=phix(la,k)/lambda
!
!        COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE M OR LESS
!                     AND EVALUATE IT AT Z
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
!                        COMPUTE RNORM
!
dsum=0.d0
do 95 k = 1,np
95 dsum=dsum+dble((y(k)-phix(4,k))**2)
rnorm=sqrt(sngl(dsum))
!
!        CONVERT THE CLOSEST POLYNOMIAL FROM A POLYNOMIAL
!                  IN Z TO A POLYNOMIAL IN X
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
!     WEIGHTED LEAST SQUARES POLYNOMIAL FIT
!     ******************************************************************
real, intent(in) :: x(np), y(np), w(np)
real, intent(inout) :: a(*), phi(2,*), phix(4,np)
real :: lambda
double precision :: dalpha, dsum
!     ---------------------
!
!                      ERROR CHECKING
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
!                      INITIALIZATION
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
!           COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE 0
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
!          GENERATE LAMBDA(M)*PHI(M) AND EVALUATE IT AT Z
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
!                COMPUTE ALPHA(M) AND LAMBDA(M)
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
!              GENERATE PHI(M) AND EVALUATE IT AT Z
!
do 70 k = 1,mp1
70 phi(la,k)=phi(la,k)/lambda
do 71 k = 1,np
71 phix(la,k)=phix(la,k)/lambda
!
!        COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE M OR LESS
!                     AND EVALUATE IT AT Z
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
!                        COMPUTE RNORM
!
dsum=0.d0
do 95 k = 1,np
95 dsum=dsum+dble(w(k)*(y(k)-phix(4,k))**2)
rnorm=sqrt(sngl(dsum))
!
!        CONVERT THE CLOSEST POLYNOMIAL FROM A POLYNOMIAL
!                  IN Z TO A POLYNOMIAL IN X
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
!                        ERROR RETURN
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
!                   CUBIC SPLINE INTERPOLATION
!-----------------------------------------------------------------------
real, intent(in) :: x(n), y(n)
real, intent(inout) :: a(n), b(n), c(n)
!
if (n .lt. 3) go to 200

!     A TRIDIAGONAL LINEAR SYSTEM FOR THE UNKNOWN SLOPES S(I) OF
!     F AT X(I), I=1,...,N, IS GENERATED AND THEN SOLVED BY GAUSS
!     ELIMINATION, WITH S(I) ENDING UP IN A(I) FOR ALL I. A, B, C
!     ARE USED INITIALLY FOR WORK SPACES.
!
do m = 2,n
   b(m) = x(m) - x(m-1)
   if (b(m) .le. 0.0) go to 210
   c(m) = (y(m) - y(m-1))/b(m)
end do
ierr = 0
!
!     CONSTRUCT THE FIRST EQUATION FROM THE BOUNDARY CONDITION, OF
!     THE FORM
!
!             C(1)*S(1) + B(1)*S(2) = A(1)
!
if (ibeg - 1) 20,30,40
!
!     NO CONDITION AT LEFT END.
!
20 c(1) = b(3)
b(1) = x(3) - x(1)
a(1) = ((b(2) + 2.0*b(1))*b(3)*c(2) + b(2)*b(2)*c(3))/b(1)
go to 50
!
!     SLOPE PRESCRIBED AT LEFT END.
!
30 c(1) = 1.0
b(1) = 0.0
a(1) = alpha
go to 50
!
!     SECOND DERIVATIVE PRESCRIBED AT LEFT END.
!
40 c(1) = 2.0
b(1) = 1.0
a(1) = 3.0*c(2) - 0.5*alpha*b(2)
!
!     FOR THE INTERIOR KNOTS, GENERATE THE CORRESPONDING EQUATIONS AND
!     CARRY OUT THE FORWARD PASS OF GAUSS ELIMINATION, AFTER WHICH THE
!     M-TH EQUATION READS  C(M)*S(M) + B(M)*S(M+1) = A(M).
!
50 nm1 = n - 1
do m = 2,nm1
   t = -b(m+1)/c(m-1)
   a(m) = t*a(m-1) + 3.0*(b(m)*c(m+1) + b(m+1)*c(m))
   c(m) = t*b(m-1) + 2.0*(b(m) + b(m+1))
end do
!
!     IF THE SLOPE AT THE RIGHT END IS GIVEN, THEN SET A(N) TO THE
!     SLOPE AND GO TO BACK SUBSTITUTION. OTHERWISE, CONSTRUCT THE
!     LAST EQUATION FROM THE SECOND BOUNDARY CONDITION, OF THE FORM
!
!                R*S(N-1) + C(N)*S(N) = A(N)
!
if (iend - 1) 60,80,90
60 if (n .eq. 3 .and. ibeg .eq. 0) go to 70
!
!     NO CONDITION AT THE RIGHT END. EITHER  N .GE. 4  OR
!     THERE IS A CONDITION AT THE LEFT END.
!
r = x(n) - x(n-2)
del  = (y(nm1) - y(n-2))/b(nm1)
a(n) = ((b(n) + 2.0*r)*b(nm1)*c(n) + b(n)*b(n)*del)/r
c(n) = b(nm1)
go to 100
!
!     NO CONDITIONS AT THE END POINTS AND N = 3. IN THIS CASE,
!     THE SECOND BOUNDARY CONDITION DOES NOT PROVIDE US WITH A
!     NEW EQUATION. FOR CONVENIENCE, WE USE THE FOLLOWING...
!
70 a(n) = 2.0*c(n)
c(n) = 1.0
r = 1.0
go to 100
!
!     SLOPE PRESCRIBED AT RIGHT END.
!
80 a(n) = beta
go to 110
!
!     SECOND DERIVATIVE PRESCRIBED AT RIGHT END.
!
90 a(n) = 3.0*c(n) + 0.5*beta*b(n)
c(n) = 2.0
r = 1.0
!
!     COMPLETE FORWARD PASS OF GAUSS ELIMINATION.
!
100 t = -r/c(nm1)
a(n) = (t*a(nm1) + a(n))/(t*b(nm1) + c(n))
!
!     CARRY OUT BACK SUBSTITUTION.
!
110 do i = 1,nm1
   j = n - i
   a(j) = (a(j) - b(j)*a(j+1))/c(j)
end do
!
!     GENERATE THE CUBIC COEFFICIENTS B(I) AND C(I).
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
!     ERROR RETURN
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
!     ABSTRACT
!         SPLIFT FITS AN INTERPOLATING CUBIC SPLINE TO THE N DATA POINTS
!         GIVEN IN X AND Y AND RETURNS THE FIRST AND SECOND DERIVATIVES
!         IN YP AND YPP.
!
!     DESCRIPTION OF ARGUMENTS
!
!       --INPUT--
!
!         X    - ARRAY OF ABSCISSAS OF DATA (IN INCREASING ORDER)
!         Y    - ARRAY OF ORDINATES OF DATA
!         N    - THE NUMBER OF DATA POINTS.  THE ARRAYS X, Y, YP, AND
!                YPP MUST BE DIMENSIONED AT LEAST N.  (N .GE. 4)
!         ISX  - MUST BE ZERO ON THE INITIAL CALL TO SPLIFT.
!                IF A SPLINE IS TO BE FITTED TO A SECOND SET OF DATA
!                THAT HAS THE SAME SET OF ABSCISSAS AS A PREVIOUS SET,
!                AND IF THE CONTENTS OF W HAVE NOT BEEN CHANGED SINCE
!                THAT PREVIOUS FIT WAS COMPUTED, THEN ISX MAY BE
!                SET TO ONE FOR FASTER EXECUTION.
!         A1,B1,AN,BN - SPECIFY THE END CONDITIONS FOR THE SPLINE WHICH
!                ARE EXPRESSED AS CONSTRAINTS ON THE SECOND DERIVATIVE
!                OF THE SPLINE AT THE END POINTS (SEE YPP).
!                THE END CONDITION CONSTRAINTS ARE
!                        YPP(1) = A1*YPP(2) + B1
!                AND
!                        YPP(N) = AN*YPP(N-1) + BN
!                WHERE
!                        ABS(A1).LT. 1.0  AND  ABS(AN).LT. 1.0.
!
!                THE SMOOTHEST SPLINE (I.E., LEAST INTEGRAL OF SQUARE
!                OF SECOND DERIVATIVE) IS OBTAINED BY A1=B1=AN=BN=0.
!                IN THIS CASE THERE IS AN INFLECTION AT X(1) AND X(N).
!                IF THE DATA IS TO BE EXTRAPOLATED (SAY, BY USING SPLINT
!                TO EVALUATE THE SPLINE OUTSIDE THE RANGE X(1) TO X(N)),
!                THEN TAKING A1=AN=0.5 AND B1=BN=0 MAY YIELD BETTER
!                RESULTS.  IN THIS CASE THERE IS AN INFLECTION
!                AT X(1) - (X(2)-X(1)) AND AT X(N) + (X(N)-X(N-1)).
!                IN THE MORE GENERAL CASE OF A1=AN=A  AND B1=BN=0,
!                THERE IS AN INFLECTION AT X(1) - (X(2)-X(1))*A/(1.0-A)
!                AND AT X(N) + (X(N)-X(N-1))*A/(1.0-A).
!
!                A SPLINE THAT HAS A GIVEN FIRST DERIVATIVE YP1 AT X(1)
!                AND YPN AT Y(N) MAY BE DEFINED BY USING THE
!                FOLLOWING CONDITIONS.
!
!                A1=-0.5
!
!                B1= 3.0*((Y(2)-Y(1))/(X(2)-X(1))-YP1)/(X(2)-X(1))
!
!                AN=-0.5
!
!                BN=-3.0*((Y(N)-Y(N-1))/(X(N)-X(N-1))-YPN)/(X(N)-X(N-1))
!
!       --OUTPUT--
!
!         YP   - ARRAY OF FIRST DERIVATIVES OF SPLINE (AT THE X(I))
!         YPP  - ARRAY OF SECOND DERIVATIVES OF SPLINE (AT THE X(I))
!         IERR - A STATUS CODE
!              --NORMAL CODE
!                 0 MEANS THAT THE REQUESTED SPLINE WAS COMPUTED.
!              --ABNORMAL CODES
!                 1 MEANS THAT ABS(A1) OR ABS(AN) WAS .GE. 1.
!                 2 MEANS THAT N, THE NUMBER OF POINTS, WAS .LT. 4.
!                 3 MEANS THE ABSCISSAS WERE NOT STRICTLY INCREASING.
!
!       --WORK--
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
!     DEFINE THE TRIDIAGONAL MATRIX
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
!     LU DECOMPOSITION
!
do 30 i = 2,n
   w(i-1,3) = w(i-1,3)/w(i-1,1)
   w(i,1)   = w(i,1) - w(i,2)*w(i-1,3)
30 continue
!
!     DEFINE *CONSTANT* VECTOR
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
!     FORWARD SUBSTITUTION
!
ypp(1) = ypp(1)/w(1,1)
do 60 i = 2,n
   ypp(i) = (ypp(i) - w(i,2)*ypp(i-1))/w(i,1)
60 continue
!
!     BACKWARD SUBSTITUTION
!
do 70 j = 1,nm1
   i = n - j
   ypp(i) = ypp(i) - w(i,3)*ypp(i+1)
70 continue
!
!     COMPUTE FIRST DERIVATIVES
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
!            WEIGHTED LEAST SQUARES CUBIC SPLINE FITTING
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
!                DEFINE THE KNOTS FOR THE B-SPLINES
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
!     OBTAIN THE B-SPLINE COEFFICIENTS OF THE LEAST SQUARES FIT
!
la = n + 5
lw = la + n
lq = lw + n
call bslsq (x, y, wgt, m, wk(1), n, 4, wk(la), &
&wk(lw), wk(lq), ierr)
if (ierr .lt. 0) go to 120
ierr = 0
!
!     OBTAIN THE COEFFICIENTS OF THE FIT IN TAYLOR SERIES FORM
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
!                       ERROR RETURN
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
!                LEAST SQUARES CUBIC SPLINE FITTING WITH
!                  EQUALITY AND INEQUALITY CONSTRAINTS
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
!     XCON, CON, NDER ARE ARRAYS OF DIMENSION MAX(1,NC).
!     Z, A, B, C ARE ARRAYS OF DIMENSION L - 1.
!     WK AND IWK ARE ARRAYS OF DIMENSION IWK(1) AND IWK(2)
!        RESPECTIVELY. IT IS REQUIRED THAT IWK(2) .GE. 2
!        AND IWK(1) .GE. 7(L + 7) FOR ALL NC. IF NC .GE. 1
!        THEN MORE STORAGE WILL BE NEEDED.
!---------------------
if (l .lt. 2) go to 100
n = l + 2
!
!                DEFINE THE KNOTS FOR THE B-SPLINES
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
!     OBTAIN THE B-SPLINE COEFFICIENTS OF THE LEAST SQUARES FIT
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
!     OBTAIN THE COEFFICIENTS OF THE FIT IN TAYLOR SERIES FORM
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
!                       ERROR RETURN
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
!     ABSTRACT
!
!         SCOMP EVALUATES A CUBIC SPLINE AT THE ABSCISSAS IN XI.
!         IT IS ASSUMED THAT THE COEFFICIENTS OF THE POLYNOMIALS
!         WHICH FORM THE SPLINE ARE PROVIDED.
!
!     DESCRIPTION OF ARGUMENTS
!
!       --INPUT--
!
!         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!               THAT DEFINE THE SPLINE.
!         Y   - ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!         A,B,C ARRAYS THAT CONTAIN THE COEFFICIENTS OF THE POLYNOMIALS
!               WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
!               HAS THE VALUE
!                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
!               FOR X(I) .LE. XX .LE. X(I+1).  HERE DX = XX-X(I).
!         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
!               THE ARRAYS X, Y, A, B, C  MUST BE DIMENSIONED AT
!               LEAST N.  N MUST BE GREATER THAN OR EQUAL TO 1.
!         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
!               AT WHICH THE SPLINE IS TO BE EVALUATED.
!         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
!               EVALUATED.  IF NI IS GREATER THAN 1 THEN XI AND YI
!               MUST BE ARRAYS OF DIMENSION NI OR LARGER.
!               IT IS ASSUMED THAT NI IS GREATER THAN OR EQUAL TO 1.
!
!       --OUTPUT--
!
!         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
!         IERR- STATUS CODE
!               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
!               1  INPUT ERROR - NI IS NOT POSITIVE.
!
real, intent(in) :: x(n), y(n), a(n), b(n), c(n), xi(ni)
real, intent(inout) :: yi(ni)
!
!     CHECK INPUT
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
!
!     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
!     I IS CURRENT INDEX INTO X ARRAY.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
il = 1
ir = n
!
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX IS GREATER THAN X(N) OR LESS THAN X(1)
!
80 i = n
go to 100
90 i = 1
!
!     EVALUATION
!
100 dx = xx - x(i)
yi(k) = y(i) + dx*(a(i) + dx*(b(i) + dx*c(i)))
!
!     NEXT POINT
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
!     ABSTRACT
!
!         SCOMP1 EVALUATES A CUBIC SPLINE AT THE ABSCISSAS IN XI.
!         IT IS ASSUMED THAT THE FIRST DERIVATIVES AT THE NODES
!         HAVE BEEN PROVIDED.
!
!     DESCRIPTION OF ARGUMENTS
!
!       --INPUT--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               SPLINE.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YP  - ARRAY OF FIRST DERIVATIVES THAT DEFINE THE SPLINE.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               THE ARRAYS X, Y, AND YP MUST BE DIMENSIONED AT LEAST N.
!               N MUST BE GREATER THAN OR EQUAL TO 2.
!         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
!               AT WHICH THE SPLINE IS TO BE EVALUATED.
!         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
!               EVALUATED.  IF NI IS GREATER THAN 1 THEN XI AND YI
!               MUST BE ARRAYS OF DIMENSION NI OR LARGER.
!               IT IS ASSUMED THAT NI IS GREATER THAN OR EQUAL TO 1.
!
!       --OUTPUT--
!
!         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
!         IERR- STATUS CODE
!               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
!               1  INPUT ERROR - NI IS NOT POSITIVE.
!
real, intent(in) :: x(n), y(n), yp(n), xi(ni)
real, intent(inout) :: yi(ni)
!
!     CHECK INPUT
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
!     I IS CURRENT INDEX INTO X ARRAY.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX IS GREATER THAN X(N) OR LESS THAN X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     EVALUATION
!
100 h = x(i+1) - x(i)
d = (y(i+1) - y(i))/h
a = yp(i) + yp(i+1)
b = (-a - yp(i) + 3.0*d)/h
c = (a - d - d)/(h*h)
dx = xx - x(i)
yi(k) = y(i) + dx*(yp(i) + dx*(b + dx*c))
!
!     NEXT POINT
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
!     ABSTRACT
!
!         SCOMP2 EVALUATES A CUBIC SPLINE AT THE ABSCISSAS IN XI.
!         IT IS ASSUMED THAT THE SECOND DERIVATIVES AT THE NODES
!         HAVE BEEN PROVIDED.
!
!     DESCRIPTION OF ARGUMENTS
!
!       --INPUT--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               SPLINE.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YPP - ARRAY OF SECOND DERIVATIVES THAT DEFINE THE SPLINE.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               THE ARRAYS X, Y, AND YPP MUST BE DIMENSIONED AT LEAST N.
!               N MUST BE GREATER THAN OR EQUAL TO 2.
!         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
!               AT WHICH THE SPLINE IS TO BE EVALUATED.
!         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
!               EVALUATED.  IF NI IS GREATER THAN 1 THEN XI AND YI
!               MUST BE ARRAYS OF DIMENSION NI OR LARGER.
!               IT IS ASSUMED THAT NI IS GREATER THAN OR EQUAL TO 1.
!
!       --OUTPUT--
!
!         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
!         IERR- STATUS CODE
!               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
!               1  INPUT ERROR - NI IS NOT POSITIVE.
!
real, intent(in) :: x(n), y(n), ypp(n), xi(ni)
real, intent(inout) :: yi(ni)
!
!     CHECK INPUT
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
!     I IS CURRENT INDEX INTO X ARRAY.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX IS GREATER THAN X(N) OR LESS THAN X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     EVALUATION
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
!     NEXT POINT
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
!     ABSTRACT
!
!         SEVAL EVALUATES A CUBIC SPLINE AND ITS FIRST AND SECOND
!         DERIVATIVES AT THE ABSCISSAS IN XI.  IT IS ASSUMED THAT
!         THE COEFFICIENTS OF THE POLYNOMIALS WHICH FORM THE SPLINE
!         ARE PROVIDED.
!
!     DESCRIPTION OF ARGUMENTS
!
!       --INPUT--
!
!         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!               THAT DEFINE THE SPLINE.
!         Y   - ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!         A,B,C ARRAYS THAT CONTAIN THE COEFFICIENTS OF THE POLYNOMIALS
!               WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
!               HAS THE VALUE
!                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
!               FOR X(I) .LE. XX .LE. X(I+1).  HERE DX = XX-X(I).
!         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
!               THE ARRAYS X, Y, A, B, C  MUST BE DIMENSIONED AT
!               LEAST N.  N MUST BE GREATER THAN OR EQUAL TO 1.
!         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
!               AT WHICH THE SPLINE IS TO BE EVALUATED.
!         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
!               EVALUATED.  IF NI IS GREATER THAN 1, THEN XI, YI, YPI,
!               AND YPPI MUST BE ARRAYS DIMENSIONED AT LEAST NI.
!               NI MUST BE GREATER THAN OR EQUAL TO 1.
!
!       --OUTPUT--
!
!         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
!         YPI - ARRAY OF VALUES OF THE FIRST DERIVATIVE OF SPLINE AT XI.
!         YPPI- ARRAY OF VALUES OF SECOND DERIVATIVES OF SPLINE AT XI.
!         IERR- STATUS CODE
!               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
!               1  INPUT ERROR - NI IS NOT POSITIVE.
!
real, intent(in) :: x(n), y(n), a(n), b(n), c(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
!
!     CHECK INPUT
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
!
!     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
!     I IS CURRENT INDEX INTO X ARRAY.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
il = 1
ir = n
!
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX IS GREATER THAN X(N) OR LESS THAN X(1)
!
80 i = n
go to 100
90 i = 1
!
!     EVALUATION
!
100 dx = xx - x(i)
yi(k) = y(i) + dx*(a(i) + dx*(b(i) + dx*c(i)))
bi = b(i) + b(i)
ci = 3.0*c(i)
ypi(k) = a(i) + dx*(bi + dx*ci)
yppi(k) = bi + dx*(ci + ci)
!
!     NEXT POINT
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
!     ABSTRACT
!
!         SEVAL1 EVALUATES A CUBIC SPLINE AND ITS FIRST AND SECOND
!         DERIVATIVES AT THE ABSCISSAS IN XI.  IT IS ASSUMED THAT
!         THE FIRST DERIVATIVES AT THE NODES HAVE BEEN PROVIDED.
!
!     DESCRIPTION OF ARGUMENTS
!
!       --INPUT--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               SPLINE.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YP  - ARRAY OF FIRST DERIVATIVES THAT DEFINE THE SPLINE.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               THE ARRAYS X, Y, AND YP MUST BE DIMENSIONED AT LEAST N.
!               N MUST BE GREATER THAN OR EQUAL TO 2.
!         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
!               AT WHICH THE SPLINE IS TO BE EVALUATED.
!         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
!               EVALUATED.  IF NI IS GREATER THAN 1, THEN XI, YI, YPI,
!               AND YPPI MUST BE ARRAYS DIMENSIONED AT LEAST NI.
!               NI MUST BE GREATER THAN OR EQUAL TO 1.
!
!       --OUTPUT--
!
!         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
!         YPI - ARRAY OF VALUES OF THE FIRST DERIVATIVE OF SPLINE AT XI.
!         YPPI- ARRAY OF VALUES OF SECOND DERIVATIVES OF SPLINE AT XI.
!         IERR- STATUS CODE
!               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
!               1  INPUT ERROR - NI IS NOT POSITIVE.
!
real, intent(in) :: x(n), y(n), yp(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
!
!     CHECK INPUT
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
!     I IS CURRENT INDEX INTO X ARRAY.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX IS GREATER THAN X(N) OR LESS THAN X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     EVALUATION
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
!     NEXT POINT
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
!     ABSTRACT
!
!         SEVAL2 EVALUATES A CUBIC SPLINE AND ITS FIRST AND SECOND
!         DERIVATIVES AT THE ABSCISSAS IN XI.  IT IS ASSUMED THAT
!         THE SECOND DERIVATIVES AT THE NODES HAVE BEEN PROVIDED.
!
!     DESCRIPTION OF ARGUMENTS
!
!       --INPUT--
!
!         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
!               SPLINE.
!         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
!         YPP - ARRAY OF SECOND DERIVATIVES THAT DEFINE THE SPLINE.
!         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
!               THE ARRAYS X, Y, AND YPP MUST BE DIMENSIONED AT LEAST N.
!               N MUST BE GREATER THAN OR EQUAL TO 2.
!         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
!               AT WHICH THE SPLINE IS TO BE EVALUATED.
!         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
!               EVALUATED.  IF NI IS GREATER THAN 1, THEN XI, YI, YPI,
!               AND YPPI MUST BE ARRAYS DIMENSIONED AT LEAST NI.
!               NI MUST BE GREATER THAN OR EQUAL TO 1.
!
!       --OUTPUT--
!
!         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
!         YPI - ARRAY OF VALUES OF THE FIRST DERIVATIVE OF SPLINE AT XI.
!         YPPI- ARRAY OF VALUES OF SECOND DERIVATIVES OF SPLINE AT XI.
!         IERR- STATUS CODE
!               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
!               1  INPUT ERROR - NI IS NOT POSITIVE.
!
real, intent(in) :: x(n), y(n), ypp(n), xi(ni)
real, intent(inout) :: yi(ni), ypi(ni), yppi(ni)
!
!     CHECK INPUT
!
if (ni .gt. 0) go to 1
   ierr = 1
   return
1 ierr = 0
nm1 = n - 1
!
!     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
!     I IS CURRENT INDEX INTO X ARRAY.
!
k  = 1
xx = xi(1)
if (xx .lt. x(1)) go to 90
if (xx .ge. x(nm1)) go to 80
il = 1
ir = nm1
!
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
!
50 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 50
!
!     XX IS GREATER THAN X(N) OR LESS THAN X(1)
!
80 i = nm1
go to 100
90 i = 1
!
!     EVALUATION
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
!     NEXT POINT
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
!                    INTEGRATING A CUBIC SPLINE
!
!                         --------------
!
!     X      ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!            THAT DEFINE THE SPLINE.
!
!     Y      ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!
!     A,B,C  ARRAYS THAT CONTAIN THE COEFFICIENTS OF THE POLYNOMIALS
!            WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
!            HAS THE VALUE
!                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
!            FOR X(I) .LE. XX .LE. X(I+1). HERE DX = XX - X(I).
!
!     N      THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
!            THE ARRAYS X, Y, A, B, C  MUST BE DIMENSIONED AT
!            LEAST N.  N MUST BE GREATER THAN OR EQUAL TO 1.
!
!     ALPHA  LOWER LIMIT OF THE INTEGRAL.
!
!     BETA   UPPER LIMIT OF THE INTEGRAL. BETA MAY BE LESS THAN
!            OR GREATER THAN ALPHA.
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
!     LOCATE THE INTERVALS CONTAINING A0 AND B0
!
20 if (n .eq. 1) go to 50
if (a0 .ge. x(n)) go to 50
k = intrvl (a0, x, n)
l = intrvl (b0, x, n)
if (b0 .ge. x(n)) l = n
if (k .eq. l) go to 51
!
!     INTEGRATE FROM A0 TO X(K + 1)
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
!     INTEGRATE OVER THE INTERIOR INTERVALS
!
if (kp1 .eq. l) go to 40
lm1 = l - 1
do i = kp1,lm1
   h = x(i + 1) - x(i)
   s = (((0.25*c(i)*h + b(i)/3.0)*h + 0.5*a(i))*h + y(i))*h
   sum = sum + s
end do
!
!     INTEGRATE FROM X(L) TO B0
!
40 h = b0 - x(l)
s = (((0.25*c(l)*h + b(l)/3.0)*h + 0.5*a(l))*h + y(l))*h
csint = sum + s
if (alpha .gt. beta) csint = -csint
return
!
!     CASE WHEN A0 AND B0 ARE IN THE SAME INTERVAL
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
!                    INTEGRATING A CUBIC SPLINE
!
!                         --------------
!
!     X    ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!          THAT DEFINE THE SPLINE.
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
!          OR GREATER THAN A.
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
!     LOCATE THE INTERVALS CONTAINING A0 AND B0
!
20 k = intrvl (a0, x, n)
l = intrvl (b0, x, n)
if (k .eq. l) go to 50
!
!     INTEGRATE FROM A0 TO X(K + 1)
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
!     INTEGRATE OVER THE INTERIOR INTERVALS
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
!     INTEGRATE FROM X(L) TO B0
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
!     CASE WHEN A0 AND B0 ARE IN THE SAME INTERVAL
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
!                    INTEGRATING A CUBIC SPLINE
!
!                         --------------
!
!     X    ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!          THAT DEFINE THE SPLINE.
!
!     Y    ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
!
!     YPP  ARRAY OF THE SECOND DERIVATIVES THAT DEFINE THE SPLINE.
!
!     N    THE NUMBER OF KNOTS OF THE SPLINE. THE ARRAYS X, Y,
!          AND YPP MUST HAVE DIMENSION AT LEAST N WHERE N .GE. 2.
!
!     A    LOWER LIMIT OF THE INTEGRAL.
!
!     B    UPPER LIMIT OF THE INTEGRAL. B MAY BE LESS THAN
!          OR GREATER THAN A.
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
!     LOCATE THE INTERVALS CONTAINING A0 AND B0
!
20 k = intrvl (a0, x, n)
l = intrvl (b0, x, n)
if (k .eq. l) go to 50
!
!     INTEGRATE FROM A0 TO X(K + 1)
!
kp1 = k + 1
h = x(kp1) - x(k)
d = (x(kp1) - a0)/h
r = y(k)*d + y(kp1)*(2.0 - d)
s = ypp(k)*(2.0 - d*d) + ypp(kp1)*(2.0 - d)**2
sum = h*d*(0.5*r - h*h*d*s/24.0)
!
!
!     INTEGRATE OVER THE INTERIOR INTERVALS
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
!     INTEGRATE FROM X(L) TO B0
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
!     CASE WHEN A0 AND B0 ARE IN THE SAME INTERVAL
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
!                PERIODIC CUBIC SPLINE INTERPOLATION
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
!     A STRICTLY DIAGONALLY DOMINANT SET OF EQUATIONS FOR THE
!     SLOPES S(I) OF THE SPLINE AT X(I) (I = 1,...,N-1) IS
!     GENERATED AND SOLVED BY GAUSS ELIMINATION. THE FIRST OF
!     THESE EQUATIONS IS OBTAINED FROM THE REQUIREMENT THAT
!     THE SPLINE BE PERIODIC. THIS EQUATION HAS THE FORM ...
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
!     ING EQUATIONS AND CARRY OUT THE PIVOT REDUCTION OF GAUSS
!     ELIMINATION. THEN THE I-TH EQUATION HAS THE FORM ...
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
!     SINCE IT IS REQUIRED THAT THE SPLINE BE PERIODIC, THE
!     EQUATION FOR THE KNOT X(N-1) HAS THE FORM ...
!
!        ALPHA*S(1) + B(1)*S(N-2) + DELTA*S(N-1) = R
!
!     APPLYING THE PIVOTS TO THIS EQUATION, ONE OBTAINS AFTER
!     EACH PIVOT OPERATION THE MODIFIED EQUATION ...
!
!        ALPHA*S(I+1) + B(1)*S(N-2) + DELTA*S(N-1) = R
!
!     THUS, WHEN THIS PIVOT REDUCTION IS COMPLETE, THE (N-1)-ST
!     EQUATION TO BE SOLVED HAS THE FORM ...
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
!     SOLVE THE LAST TWO EQUATIONS FOR S(N-1) AND S(N-2), AND
!     STORE THESE SLOPES IN A.
!
40 e = (alpha + b(1))/a(nm2)
w = b(nm2) + c(nm2)
s = (r - e*t(nm2))/(delta - e*w)
a(nm1) = s
a(nm2) = (t(nm2) - w*s)/a(nm2)
if (n .eq. 3) go to 60
!
!     BACK SUBSTITUTION TO OBTAIN THE REMAINING SLOPES S(I).
!     THESE SLOPES ARE STORED IN A.
!
si = a(nm2)
do j = 3,nm1
   i = n - j
   si = (t(i) - b(i)*si - c(i)*s)/a(i)
   a(i) = si
end do
!
!     GENERATE THE CUBIC COEFFICIENTS B(I) AND C(I)
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
!     ERROR RETURN
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
!            LEAST SQUARES PERIODIC CUBIC SPLINE FITTING
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
!                DEFINE THE NODES FOR THE B-SPLINES
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
!                DEFINE THE PERIODICITY CONSTRAINTS
!
con(1) = break(1)
con(2) = break(1)
con(3) = break(1)
xcon(1) = break(l)
xcon(2) = break(l)
xcon(3) = break(l)
!
!     OBTAIN THE B-SPLINE COEFFICIENTS OF THE PERIODIC SPLINE
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
!     OBTAIN THE COEFFICIENTS OF THE SPLINE IN TAYLOR SERIES FORM
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
!                THE COEFFICIENTS WERE NOT OBTAINED
!
30 if (ierr .eq. -4) go to 120
if (ierr .eq. -6) go to 130
if (ierr .eq. -7) go to 140
ierr = 1
return
!
!                           ERROR RETURN
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
!              EVALUATION OF A PERIODIC CUBIC SPLINE
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
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 90
if (xx - x(i)) 20,90,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
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
!     NEXT POINT
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
!     CASE WHEN ROUNDOFF PRODUCES A VALUE FOR XX WHERE
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
!     EVALUATION AND DIFFERENTIATION OF A PERIODIC CUBIC SPLINE
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
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 90
if (xx - x(i)) 20,90,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
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
!     NEXT POINT
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
!     CASE WHEN ROUNDOFF PRODUCES A VALUE FOR XX WHERE
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
!               CLOSED CURVE CUBIC SPLINE FITTING
!                    IN N-DIMENSIONAL SPACE
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
!     WK IS AN ARRAY OF DIMENSION 4*(M-1)
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
!     ERROR RETURN
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
!               CLOSED CURVE CUBIC SPLINE FITTING
!                    IN N-DIMENSIONAL SPACE
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
!     THIS LAST KNOT IS NOT STORED.
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
!     FOR THE SLOPES S(I,J) OF THE J-TH PERIODIC SPLINE AT T(I)
!     (I = 1,...,M) IS GENERATED AND SOLVED BY GAUSS ELIMINATION.
!     THE FIRST EQUATION IS OBTAINED FROM THE REQUIREMENT THAT
!     THE SPLINE BE PERIODIC. THIS EQUATION HAS THE FORM ...
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
!     ING EQUATIONS AND CARRY OUT THE PIVOT REDUCTION OF GAUSS
!     ELIMINATION. THEN THE I-TH EQUATION HAS THE FORM ...
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
!     SINCE IT IS REQUIRED THAT THE SPLINE BE PERIODIC, THE
!     EQUATION FOR THE KNOT T(M) HAS THE FORM ...
!
!        ALPHA*S(1,J) + HM*S(M-1,J) + ETA*S(M,J) = DX(M,J)
!
!     APPLYING THE PIVOTS TO THIS EQUATION, ONE OBTAINS AFTER
!     EACH PIVOT OPERATION THE MODIFIED EQUATION ...
!
!        ALPHA*S(I+1,J) + HM*S(M-1,J) + ETA*S(M,J) = DX(M,J)
!
!     THUS, WHEN THIS PIVOT REDUCTION IS COMPLETE, THE M-TH
!     EQUATION TO BE SOLVED HAS THE FORM ...
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
!     SOLVE THE LAST TWO EQUATIONS FOR S(M,J) AND S(M-1,J),
!     AND STORE THESE SLOPES IN DX.
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
!     BACK SUBSTITUTION TO OBTAIN THE REMAINING SLOPES S(I,J).
!     THESE SLOPES ARE STORED IN DX.
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
!     ERROR RETURN
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
!            EVALUATION OF A CUBIC SPLINE CLOSED CURVE
!                     IN N-DIMENSIONAL SPACE
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
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 50
if (t0 - t(i)) 20,50,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
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
!     NEXT POINT
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
!          EVALUATION AND DIFFERENTIATION OF A CUBIC SPLINE
!                CLOSED CURVE IN N-DIMENSIONAL SPACE
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
!     BISECTION SEARCH
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
! THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
! COMPUTE AN INTERPOLATORY SPLINE UNDER TENSION THROUGH
! A SEQUENCE OF FUNCTIONAL VALUES. THE SLOPES AT THE TWO
! ENDS OF THE CURVE MAY BE SPECIFIED OR OMITTED.  FOR ACTUAL
! COMPUTATION OF POINTS ON THE CURVE IT IS NECESSARY TO CALL
! THE FUNCTION CURV2.
!
! ON INPUT--
!
!   N IS THE NUMBER OF VALUES TO BE INTERPOLATED (N.GE.2).
!
!   X IS AN ARRAY OF THE N INCREASING ABSCISSAE OF THE
!   FUNCTIONAL VALUES.
!
!   Y IS AN ARRAY OF THE N ORDINATES OF THE VALUES, (I. E.
!   Y(K) IS THE FUNCTIONAL VALUE CORRESPONDING TO X(K) ).
!
!   SLP1 AND SLPN CONTAIN THE DESIRED VALUES FOR THE FIRST
!   DERIVATIVE OF THE CURVE AT X(1) AND X(N), RESPECTIVELY.
!   THE USER MAY OMIT VALUES FOR EITHER OR BOTH OF THESE
!   PARAMETERS AND SIGNAL THIS WITH ISLPSW.
!
!   ISLPSW CONTAINS A SWITCH INDICATING WHICH SLOPE DATA
!   SHOULD BE USED AND WHICH SHOULD BE ESTIMATED BY THIS
!   SUBROUTINE,
!          = 0 IF SLP1 AND SLPN ARE TO BE USED,
!          = 1 IF SLP1 IS TO BE USED BUT NOT SLPN,
!          = 2 IF SLPN IS TO BE USED BUT NOT SLP1,
!          = 3 IF BOTH SLP1 AND SLPN ARE TO BE ESTIMATED
!              INTERNALLY.
!
!   YP IS AN ARRAY OF LENGTH AT LEAST N.
!
!   TEMP IS AN ARRAY OF LENGTH AT LEAST N WHICH IS USED FOR
!   SCRATCH STORAGE.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
!   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
!   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A
!   CUBIC SPLINE. IF ABS(SIGMA) IS LARGE (E.G. 50.) THE
!   RESULTING CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA
!   EQUALS ZERO A CUBIC SPLINE RESULTS.  A STANDARD VALUE
!   FOR SIGMA IS APPROXIMATELY 1. IN ABSOLUTE VALUE.
!
! ON OUTPUT--
!
!   YP CONTAINS THE VALUES OF THE SECOND DERIVATIVE OF THE
!   CURVE AT THE GIVEN NODES.
!
!   IERR CONTAINS AN ERROR FLAG,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF X-VALUES ARE NOT STRICTLY INCREASING.
!
! AND
!
!   N, X, Y, SLP1, SLPN, ISLPSW AND SIGMA ARE UNALTERED.
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
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! APPROXIMATE END SLOPES
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
! SET UP RIGHT HAND SIDE AND TRIDIAGONAL SYSTEM FOR YP AND
! PERFORM FORWARD ELIMINATION
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
! PERFORM BACK SUBSTITUTION
!
do 7 i = 2,n
  ibak = np1-i
7 yp(ibak) = yp(ibak)-temp(ibak)*yp(ibak+1)
return
!
! TOO FEW POINTS
!
8 ierr = 1
return
!
! X-VALUES NOT STRICTLY INCREASING
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
! THIS FUNCTION INTERPOLATES A CURVE AT A GIVEN POINT
! USING A SPLINE UNDER TENSION. THE SUBROUTINE CURV1 SHOULD
! BE CALLED EARLIER TO DETERMINE CERTAIN NECESSARY
! PARAMETERS.
!
! ON INPUT--
!
!   T CONTAINS A REAL VALUE TO BE MAPPED ONTO THE INTERPO-
!   LATING CURVE.
!
!   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED TO
!   DETERMINE THE CURVE.
!
!   X AND Y ARE ARRAYS CONTAINING THE ABSCISSAE AND
!   ORDINATES, RESPECTIVELY, OF THE SPECIFIED POINTS.
!
!   YP IS AN ARRAY OF SECOND DERIVATIVE VALUES OF THE CURVE
!   AT THE NODES.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS N, X, Y, YP, AND SIGMA SHOULD BE INPUT
! UNALTERED FROM THE OUTPUT OF CURV1.
!
! ON OUTPUT--
!
!   CURV2 CONTAINS THE INTERPOLATED VALUE.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! DETERMINE INTERVAL
!
im1 = intrvl(t,x,n)
i = im1+1
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! SET UP AND PERFORM INTERPOLATION
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
! THIS FUNCTION DIFFERENTIATES A CURVE AT A GIVEN POINT
! USING A SPLINE UNDER TENSION. THE SUBROUTINE CURV1 SHOULD
! BE CALLED EARLIER TO DETERMINE CERTAIN NECESSARY
! PARAMETERS.
!
! ON INPUT--
!
!   T CONTAINS A REAL VALUE AT WHICH THE DERIVATIVE IS TO BE
!   DETERMINED.
!
!   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED TO
!   DETERMINE THE CURVE.
!
!   X AND Y ARE ARRAYS CONTAINING THE ABSCISSAE AND
!   ORDINATES, RESPECTIVELY, OF THE SPECIFIED POINTS.
!
!   YP IS AN ARRAY OF SECOND DERIVATIVE VALUES OF THE CURVE
!   AT THE NODES.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS N, X, Y, YP, AND SIGMA SHOULD BE INPUT
! UNALTERED FROM THE OUTPUT OF CURV1.
!
! ON OUTPUT--
!
!   CURVD CONTAINS THE DERIVATIVE VALUE.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! DETERMINE INTERVAL
!
im1 = intrvl(t,x,n)
i = im1+1
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! SET UP AND PERFORM DIFFERENTIATION
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
! THIS FUNCTION INTEGRATES A CURVE SPECIFIED BY A SPLINE
! UNDER TENSION BETWEEN TWO GIVEN LIMITS. THE SUBROUTINE
! CURV1 SHOULD BE CALLED EARLIER TO DETERMINE NECESSARY
! PARAMETERS.
!
! ON INPUT--
!
!   XL AND XU CONTAIN THE LOWER AND UPPER LIMITS OF INTE-
!   GRATION, RESPECTIVELY. (XL NEED NOT BE LESS THAN OR
!   EQUAL TO XU, CURVI (XL,XU,...) .EQ. -CURVI (XU,XL,...) ).
!
!   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED TO
!   DETERMINE THE CURVE.
!
!   X AND Y ARE ARRAYS CONTAINING THE ABSCISSAE AND
!   ORDINATES, RESPECTIVELY, OF THE SPECIFIED POINTS.
!
!   YP IS AN ARRAY OF SECOND DERIVATIVE VALUES OF THE CURVE
!   AT THE NODES.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS N, X, Y, YP, AND SIGMA SHOULD BE INPUT
! UNALTERED FROM THE OUTPUT OF CURV1.
!
! ON OUTPUT--
!
!   CURVI CONTAINS THE INTEGRAL VALUE.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! STATEMENT FUNCTION FOR COEFFICIENT ASSOCIATED WITH
! DERIVATIVE TERMS
!
term (cmm1,cmm2,t) = (cmm1-cmm2-sigmap*t*ss)/(sigmap* &
&sigmap*sigmap*(ss+sigmap*dels))
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/(x(n)-x(1))
!
! DETERMINE ACTUAL UPPER AND LOWER BOUNDS
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
! SEARCH FOR PROPER INTERVALS
!
1 ilm1 = intrvl (xxl,x,n)
il = ilm1+1
ium1 = intrvl (xxu,x,n)
iu = ium1+1
if (il .eq. iu) go to 8
!
! INTEGRATE FROM XXL TO X(IL)
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
! INTEGRATE OVER INTERIOR INTERVALS
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
! INTEGRATE FROM X(IU-1) TO XXU
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
! INTEGRATE FROM XXL TO XXU
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
! CORRECT SIGN AND RETURN
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
! THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
! COMPUTE A SPLINE UNDER TENSION FORMING A CURVE IN THE
! PLANE AND PASSING THROUGH A SEQUENCE OF PAIRS (X(1),Y(1)),
! ...,(X(N),Y(N)). FOR ACTUAL COMPUTATION OF POINTS ON THE
! CURVE IT IS NECESSARY TO CALL THE SUBROUTINE KURV2.
!
! ON INPUT--
!
!   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
!
!   X IS AN ARRAY CONTAINING THE N X-COORDINATES OF THE
!   POINTS.
!
!   Y IS AN ARRAY CONTAINING THE N Y-COORDINATES OF THE
!   POINTS. (ADJACENT X-Y PAIRS MUST BE DISTINCT, I. E.
!   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1), FOR
!   I = 1,...,N-1.)
!
!   SLP1 AND SLPN CONTAIN THE DESIRED VALUES FOR THE ANGLES
!   (IN RADIANS) OF THE SLOPE AT (X(1),Y(1)) AND (X(N),Y(N))
!   RESPECTIVELY. THE ANGLES ARE MEASURED COUNTER-CLOCK-
!   WISE FROM THE X-AXIS AND THE POSITIVE SENSE OF THE CURVE
!   IS ASSUMED TO BE THAT MOVING FROM POINT 1 TO POINT N.
!   THE USER MAY OMIT VALUES FOR EITHER OR BOTH OF THESE
!   PARAMETERS AND SIGNAL THIS WITH ISLPSW.
!
!   ISLPSW CONTAINS A SWITCH INDICATING WHICH SLOPE DATA
!   SHOULD BE USED AND WHICH SHOULD BE ESTIMATED BY THIS
!   SUBROUTINE,
!          = 0 IF SLP1 AND SLPN ARE TO BE USED,
!          = 1 IF SLP1 IS TO BE USED BUT NOT SLPN,
!          = 2 IF SLPN IS TO BE USED BUT NOT SLP1,
!          = 3 IF BOTH SLP1 AND SLPN ARE TO BE ESTIMATED
!              INTERNALLY.
!
!   XP AND YP ARE ARRAYS OF LENGTH AT LEAST N.
!
!   TEMP IS AN ARRAY OF LENGTH AT LEAST N WHICH IS USED
!   FOR SCRATCH STORAGE.
!
!   S IS AN ARRAY OF LENGTH AT LEAST N.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
!   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
!   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A CUBIC
!   SPLINE. IF ABS(SIGMA) IS LARGE (E. G. 50.) THE RESULTING
!   CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA EQUALS ZERO A
!   CUBIC SPLINE RESULTS. A STANDARD VALUE FOR SIGMA IS
!   APPROXIMATELY 1. IN ABSOLUTE VALUE.
!
! ON OUTPUT--
!
!   XP AND YP CONTAIN INFORMATION ABOUT THE CURVATURE OF THE
!   CURVE AT THE GIVEN NODES.
!
!   S CONTAINS THE POLYGONAL ARCLENGTHS OF THE CURVE.
!
!   IERR CONTAINS AN ERROR FLAG,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF ADJACENT COORDINATE PAIRS COINCIDE.
!
! AND
!
!   N, X, Y, SLP1, SLPN, ISLPSW, AND SIGMA ARE UNALTERED.
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
! DETERMINE POLYGONAL ARCLENGTHS
!
s(1) = 0.
do 1 i = 2,n
  im1 = i-1
1 s(i) = s(im1)+sqrt((x(i)-x(im1))**2+ &
&(y(i)-y(im1))**2)
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! APPROXIMATE END SLOPES
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
! SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR XP AND
! YP AND PERFORM FORWARD ELIMINATION
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
! PERFORM BACK SUBSTITUTION
!
do 10 i = 2,n
  ibak = np1-i
  xp(ibak) = xp(ibak)-temp(ibak)*xp(ibak+1)
10 yp(ibak) = yp(ibak)-temp(ibak)*yp(ibak+1)
return
!
! TOO FEW POINTS
!
11 ierr = 1
return
!
! COINCIDENT ADJACENT POINTS
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
! THIS SUBROUTINE PERFORMS THE MAPPING OF POINTS IN THE
! INTERVAL (0.,1.) ONTO A CURVE IN THE PLANE. THE SUBROUTINE
! KURV1 SHOULD BE CALLED EARLIER TO DETERMINE CERTAIN
! NECESSARY PARAMETERS. THE RESULTING CURVE HAS A PARAMETRIC
! REPRESENTATION BOTH OF WHOSE COMPONENTS ARE SPLINES UNDER
! TENSION AND FUNCTIONS OF THE POLYGONAL ARCLENGTH
! PARAMETER.
!
! ON INPUT--
!
!   T CONTAINS A REAL VALUE TO BE MAPPED TO A POINT ON THE
!   CURVE. THE INTERVAL (0.,1.) IS MAPPED ONTO THE ENTIRE
!   CURVE, WITH 0. MAPPING TO (X(1),Y(1)) AND 1. MAPPING
!   TO (X(N),Y(N)). VALUES OUTSIDE THIS INTERVAL RESULT IN
!   EXTRAPOLATION.
!
!   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED
!   TO DETERMINE THE CURVE.
!
!   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-COORDINATES
!   OF THE SPECIFIED POINTS.
!
!   XP AND YP ARE THE ARRAYS OUTPUT FROM KURV1 CONTAINING
!   CURVATURE INFORMATION.
!
!   S IS AN ARRAY CONTAINING THE POLYGONAL ARCLENGTHS OF
!   THE CURVE.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS N, X, Y, XP, YP, S, AND SIGMA SHOULD BE
! INPUT UNALTERED FROM THE OUTPUT OF KURV1.
!
! ON OUTPUT--
!
!   XS AND YS CONTAIN THE X- AND Y-COORDINATES OF THE IMAGE
!   POINT ON THE CURVE.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! DETERMINE INTERVAL
!
tn = s(n)*t
im1 = intrvl(tn,s,n)
i = im1+1
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! SET UP AND PERFORM INTERPOLATION
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
! THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
! COMPUTE A SPLINE UNDER TENSION FORMING A CLOSED CURVE IN
! THE PLANE AND PASSING THROUGH A SEQUENCE OF PAIRS
! (X(1),Y(1)),...,(X(N),Y(N)). FOR ACTUAL COMPUTATION OF
! POINTS ON THE CURVE IT IS NECESSARY TO CALL THE SUBROUTINE
! KURVP2.
!
! ON INPUT--
!
!   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
!
!   X IS AN ARRAY CONTAINING THE N X-COORDINATES OF THE
!   POINTS.
!
!   Y IS AN ARRAY CONTAINING THE N Y-COORDINATES OF THE
!   POINTS. (ADJACENT X-Y PAIRS MUST BE DISTINCT, I. E.
!   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1), FOR
!   I = 1,...,N-1.)
!
!   XP AND YP ARE ARRAYS OF LENGTH AT LEAST N.
!
!   TEMP IS AN ARRAY OF LENGTH AT LEAST 2*N WHICH IS USED
!   FOR SCRATCH STORAGE.
!
!   S IS AN ARRAY OF LENGTH AT LEAST N.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
!   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
!   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A CUBIC
!   SPLINE. IF ABS(SIGMA) IS LARGE (E. G. 50.) THE RESULTING
!   CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA EQUALS ZERO A
!   CUBIC SPLINE RESULTS. A STANDARD VALUE FOR SIGMA IS
!   APPROXIMATELY 1. IN ABSOLUTE VALUE.
!
! ON OUTPUT--
!
!   XP AND YP CONTAIN INFORMATION ABOUT THE CURVATURE OF THE
!   CURVE AT THE GIVEN NODES.
!
!   S CONTAINS THE POLYGONAL ARCLENGTHS OF THE CURVE.
!
!   IERR CONTAINS AN ERROR FLAG,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF ADJACENT COORDINATE PAIRS COINCIDE.
!
! AND
!
!   N, X, Y, AND SIGMA ARE UNALTERED,
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
! DETERMINE POLYGONAL ARCLENGTHS
!
s(1) = sqrt((x(n)-x(1))**2+(y(n)-y(1))**2)
do 1 i = 2,n
  im1 = i-1
1 s(i) = s(im1)+sqrt((x(i)-x(im1))**2+ &
&(y(i)-y(im1))**2)
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n)/s(n)
!
! SET UP RIGHT HAND SIDES OF TRIDIAGONAL (WITH CORNER
! ELEMENTS) LINEAR SYSTEM FOR XP AND YP
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
! PERFORM FIRST STEP OF BACK SUBSTITUTION
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
! PERFORM SECOND STEP OF BACK SUBSTITUTION
!
xpn = xp(n)
ypn = yp(n)
do 6 i = 1,nm1
  xp(i) = xp(i)+temp(i)*xpn
6 yp(i) = yp(i)+temp(i)*ypn
return
!
! TOO FEW POINTS
!
7 ierr = 1
return
!
! COINCIDENT ADJACENT POINTS
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
! THIS SUBROUTINE PERFORMS THE MAPPING OF POINTS IN THE
! INTERVAL (0.,1.) ONTO A CLOSED CURVE IN THE PLANE. THE
! SUBROUTINE KURVP1 SHOULD BE CALLED EARLIER TO DETERMINE
! CERTAIN NECESSARY PARAMETERS. THE RESULTING CURVE HAS A
! PARAMETRIC REPRESENTATION BOTH OF WHOSE COMPONENTS ARE
! PERIODIC SPLINES UNDER TENSION AND FUNCTIONS OF THE POLY-
! GONAL ARCLENGTH PARAMETER.
!
! ON INPUT--
!
!   T CONTAINS A VALUE TO BE MAPPED ONTO THE CURVE. THE
!   INTERVAL (0.,1.) IS MAPPED ONTO THE ENTIRE CLOSED CURVE
!   WITH BOTH 0. AND 1. MAPPING TO (X(1),Y(1)). THE MAPPING
!   IS PERIODIC WITH PERIOD ONE THUS ANY INTERVAL OF THE
!   FORM (TT,TT+1.) MAPS ONTO THE ENTIRE CURVE.
!
!   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED
!   TO DETERMINE THE CURVE.
!
!   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-COORDINATES
!   OF THE SPECIFIED POINTS.
!
!   XP AND YP ARE THE ARRAYS OUTPUT FROM KURVP1 CONTAINING
!   CURVATURE INFORMATION.
!
!   S IS AN ARRAY CONTAINING THE POLYGONAL ARCLENGTHS OF
!   THE CURVE.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS N, X, Y, XP, YP, S AND SIGMA SHOULD
! BE INPUT UNALTERED FROM THE OUTPUT OF KURVP1.
!
! ON OUTPUT--
!
!   XS AND YS CONTAIN THE X- AND Y-COORDINATES OF THE IMAGE
!   POINT ON THE CURVE.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! DETERMINE INTERVAL
!
tn = t-float(ifix(t))
if (tn .lt. 0.) tn = tn+1.
tn = s(n)*tn+s(1)
im1 = n
if (tn .lt. s(n)) im1 = intrvl(tn,s,n)
i = im1+1
if (i .gt. n) i = 1
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n)/s(n)
!
! SET UP AND PERFORM INTERPOLATION
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
! THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
! COMPUTE A SPLINE UNDER TENSION PASSING THROUGH A SEQUENCE
! OF TRIPLES (X(1),Y(1),Z(1)),...,(X(N),Y(N),Z(N)). THE
! SLOPES AT THE TWO ENDS OF THE CURVE MAY BE SPECIFIED OR
! OMITTED. FOR ACTUAL COMPUTATION OF POINTS ON THE CURVE
! IT IS NECESSARY TO CALL THE SUBROUTINE QURV2.
!
! ON INPUT--
!
!   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
!
!   X IS AN ARRAY CONTAINING THE N X-COORDINATES OF THE
!   POINTS.
!
!   Y IS AN ARRAY CONTAINING THE N Y-COORDINATES OF THE
!   POINTS.
!
!   Z IS AN ARRAY CONTAINING THE N Z-COORDINATES OF THE
!   POINTS. (ADJACENT X-Y-Z TRIPLES MUST BE DISTINCT, I. E.
!   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1) OR Z(I) .NE.
!   Z(I+1), FOR I = 1,...,N-1 ).
!
!   SLP1X, SLP1Y, SLP1Z AND SLPNX, SLPNY, SLPNZ CONTAIN THE
!   DESIRED VALUES OF THE COMPONENTS OF TANGENT VECTORS TO
!   THE CURVE AT (X(1),Y(1),Z(1)) AND(X(N),Y(N),Z(N)),
!   RESPECTIVELY. THE POSITIVE SENSE OF THE CURVE IS ASSUMED
!   TO BE THAT MOVING FROM POINT 1 TO POINT N. THE USER MAY
!   OMIT VALUES FOR EITHER OR BOTH OF THESE TRIPLES AND
!   SIGNAL THIS WITH ISLPSW.
!
!   ISLPSW CONTAINS A SWITCH INDICATING WHICH SLOPE DATA
!   SHOULD BE USED AND WHICH SHOULD BE ESTIMATED BY THIS
!   SUBROUTINE,
!          = 0 IF SLP1X, SLP1Y, SLP1Z AND SLPNX, SLPNY,
!              SLPNZ ARE TO BE USED,
!          = 1 IF SLP1X, SLP1Y, SLP1Z ARE TO BE USED BUT
!              NOT SLPNX, SLPNY, SLPNZ,
!          = 2 IF SLPNX, SLPNY, SLPNZ ARE TO BE USED BUT
!              NOT SLP1X, SLP1Y, SLP1Z,
!          = 3 IF BOTH END-TANGENTS ARE TO BE ESTIMATED
!              INTERNALLY.
!
!   XP, YP, AND ZP ARE ARRAYS OF LENGTH AT LEAST N.
!
!   TEMP IS AN ARRAY OF LENGTH AT LEAST N WHICH IS USED
!   FOR SCRATCH STORAGE.
!
!   S IS AN ARRAY OF LENGTH AT LEAST N.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
!   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
!   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A CUBIC
!   SPLINE. IF ABS(SIGMA) IS LARGE (E. G. 50.) THE RESULTING
!   CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA EQUALS ZERO A
!   CUBIC SPLINE RESULTS. A STANDARD VALUE FOR SIGMA IS
!   APPROXIMATELY 1. IN ABSOLUTE VALUE.
!
! ON OUTPUT--
!
!   XP, YP, AND ZP CONTAIN INFORMATION ABOUT THE CURVATURE
!   OF THE CURVE AT THE GIVEN NODES.
!
!   S CONTAINS THE POLYGONAL ARCLENGTHS OF THE CURVE.
!
!   IERR CONTAINS AN ERROR FLAG,
!        = 0 FOR NORMAL RETURN,
!        = 1 IF N IS LESS THAN 2,
!        = 2 IF ADJACENT TRIPLES COINCIDE.
!
! AND
!
!   N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ,
!   ISLPSW, AND SIGMA ARE UNALTERED,
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
! DETERMINE POLYGONAL ARCLENGTHS
!
s(1) = 0.
do 1 i = 2,n
  im1 = i-1
1 s(i) = s(im1)+sqrt((x(i)-x(im1))**2+(y(i)-y(im1))**2 &
&+(z(i)-z(im1))**2)
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! APPROXIMATE END SLOPES
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
! SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR XP, YP
! AND ZP AND PERFORM FORWARD ELIMINATION
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
! PERFORM BACK SUBSTITUTION
!
do 8 i = 2,n
  ibak = np1-i
  t = temp(ibak)
  xp(ibak) = xp(ibak)-t*xp(ibak+1)
  yp(ibak) = yp(ibak)-t*yp(ibak+1)
8 zp(ibak) = zp(ibak)-t*zp(ibak+1)
return
!
! TOO FEW POINTS
!
9 ierr = 1
return
!
! COINCIDENT ADJACENT POINTS
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
! THIS SUBROUTINE PERFORMS THE MAPPING OF POINTS IN THE
! INTERVAL (0.,1.) ONTO A CURVE IN SPACE.  THE SUBROUTINE
! QURV1 SHOULD BE CALLED EARLIER TO DETERMINE CERTAIN
! NECESSARY PARAMETERS. THE RESULTING CURVE HAS A PARAMETRIC
! REPRESENTATION ALL OF WHOSE COMPONENTS ARE SPLINES UNDER
! TENSION AND FUNCTIONS OF THE POLYGONAL ARCLENGTH
! PARAMETER.
!
! ON INPUT--
!
!   T CONTAINS A REAL VALUE TO BE MAPPED TO A POINT ON THE
!   CURVE. THE INTERVAL (0.,1.) IS MAPPED ONTO THE ENTIRE
!   CURVE, WITH 0. MAPPING TO (X(1),Y(1,Z(1)) AND 1. MAPPING
!   TO (X(N),Y(N),Z(N)). VALUES OUTSIDE THIS INTERVAL RESULT
!   IN EXTRAPOLATION.
!
!   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED
!   TO DETERMINE THE CURVE.
!
!   X, Y, AND Z ARE ARRAYS CONTAINING THE X-, Y- AND Z-
!   COORDINATES OF THE SPECIFIED POINTS.
!
!   XP, YP, AND ZP ARE THE ARRAYS OUTPUT FROM QURV1
!   CONTAINING CURVATURE INFORMATION.
!
!   S IS AN ARRAY CONTAINING THE POLYGONAL ARCLENGTHS OF
!   THE CURVE.
!
! AND
!
!   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
!
! THE PARAMETERS N, X, Y, Z, XP, YP, ZP, S, AND SIGMA
! SHOULD BE INPUT UNALTERED FROM THE OUTPUT OF QURV1.
!
! ON OUTPUT--
!
!   XS, YS AND ZS CONTAIN THE X-, Y- AND Z-COORDINATES OF
!   THE IMAGE POINT ON THE CURVE.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
!
! THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
! SNHCSH.
!
!-----------------------------------------------------------
!
! DETERMINE INTERVAL
!
tn = s(n)*t
im1 = intrvl(tn,s,n)
i = im1+1
!
! DENORMALIZE TENSION FACTOR
!
sigmap = abs(sigma)*float(n-1)/s(n)
!
! SET UP AND PERFORM INTERPOLATION
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
! THIS SUBROUTINE DETERMINES THE COEFFICIENTS C1, C2, AND C3
! USED TO DETERMINE ENDPOINT SLOPES. SPECIFICALLY, IF
! FUNCTION VALUES Y1, Y2, AND Y3 ARE GIVEN AT POINTS X1, X2,
! AND X3, RESPECTIVELY, THE QUANTITY C1*Y1 + C2*Y2 + C3*Y3
! IS THE VALUE OF THE DERIVATIVE AT X1 OF A SPLINE UNDER
! TENSION (WITH TENSION FACTOR SIGMA) PASSING THROUGH THE
! THREE POINTS AND HAVING THIRD DERIVATIVE EQUAL TO ZERO AT
! X1. OPTIONALLY, ONLY TWO VALUES, C1 AND C2 ARE DETERMINED.
!
! ON INPUT--
!
!   DEL1 IS X2-X1 (.GT. 0.).
!
!   DEL2 IS X3-X1 (.GT. 0.). IF N .EQ. 2, THIS PARAMETER IS
!   IGNORED.
!
!   SIGMA IS THE TENSION FACTOR.
!
! AND
!
!   N IS A SWITCH INDICATING THE NUMBER OF COEFFICIENTS TO
!   BE RETURNED. IF N .EQ. 2 ONLY TWO COEFFICIENTS ARE
!   RETURNED. OTHERWISE ALL THREE ARE RETURNED.
!
! ON OUTPUT--
!
!   C1, C2, AND C3 CONTAIN THE COEFFICIENTS.
!
! NONE OF THE INPUT PARAMETERS ARE ALTERED.
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
! TWO COEFFICIENTS
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
! THIS SUBROUTINE COMPUTES THE DIAGONAL AND SUPERDIAGONAL
! TERMS OF THE TRIDIAGONAL LINEAR SYSTEM ASSOCIATED WITH
! SPLINE UNDER TENSION INTERPOLATION.
!
! ON INPUT--
!
!   SIGMA CONTAINS THE TENSION FACTOR.
!
! AND
!
!   DEL CONTAINS THE STEP SIZE.
!
! ON OUTPUT--
!
!               (SIGMA*DEL*COSH(SIGMA*DEL) - SINH(SIGMA*DEL)
!   DIAG = DEL*--------------------------------------------.
!                     (SIGMA*DEL)**2 * SINH(SIGMA*DEL)
!
!                   SINH(SIGMA*DEL) - SIGMA*DEL
!   SDIAG = DEL*----------------------------------.
!                (SIGMA*DEL)**2 * SINH(SIGMA*DEL)
!
! AND
!
!   SIGMA AND DEL ARE UNALTERED.
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
!             LOCATION OF A VALUE X IN A SEQUENCE T
!
!                       ----------------
!
!     INPUT--
!
!        X IS A REAL NUMBER.
!
!        T IS AN ARRAY OF NONDECREASING VALUES. IT IS
!          ASSUMED THAT T(1) .LT. T(M).
!
!        M IS THE LENGTH OF T (M .GE. 2).
!
!     OUTPUT--
!
!        INTRVL HAS THE VALUE I WHEN  T(I) .LE. X .LT. T(I+1).
!        OTHERWISE, IF L IS THE INTEGER WHERE T(L) .LT. T(L+1)
!        AND T(L+1) = ... = T(M), THEN INTRVL HAS THE VALUE I
!        WHERE
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
!     BISECTION SEARCH
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
!     LEFT END
!
100 intrvl = 1
return
!
!     NORMAL EXIT
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
!     BVAL CALCULATES THE VALUE AT X OF THE JDERIV-TH DERIVATIVE
!     OF A SPLINE F FROM ITS B-REPRESENTATION.
!
!******  I N P U T ******
!
!  T     AN ARRAY OF DIMENSION N + K CONTAING THE KNOTS OF THE
!        SPLINE. IT IS ASSUMED THAT T(I) .LE. T(I+1) FOR EACH I.
!  BCOEF AN ARRAY OF DIMENSION N CONTAINING THE B-COEFFICIENTS
!        OF THE SPLINE F.
!  N     LENGTH OF BCOEF (N .GE. 1).
!  K     ORDER OF THE SPLINE.
!  X     THE POINT AT WHICH TO EVALUATE.
!  JDERIV  INTEGER GIVING THE ORDER OF THE DERIVATIVE TO BE
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
!  WHERE
!                   / BCOEF(.),                     ,  J .EQ. 0
!                   /
!    BCOEF(.,J)  =  / BCOEF(.,J-1) - BCOEF(.-1,J-1)
!                   / ----------------------------- ,  J .GT. 0
!                   /    (T(.+K-J) - T(.))/(K-J)
!
!     THEN, WE USE REPEATEDLY THE FACT THAT
!
!    SUM ( A(.)*B(.,M,T)(X) )  =  SUM ( A(.,X)*B(.,M-1,T)(X) )
!  WITH
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
!     IF NO SUCH I EXISTS, THEN X LIES OUTSIDE THE SUPPORT OF THE
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
!     WK(J,1) NOT OBTAINABLE FROM INPUT TO ZERO. SET ANY T.S NOT OBTAIN-
!     ABLE EQUAL TO T(1) OR TO T(N+K) APPROPRIATELY.
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
!     GIVEN ITS RELEVANT B-SPLINE COEFFS IN WK(1,1),...,WK(K-JDERIV,1).
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
!           INTEGRAL OF A PIECEWISE POLYNOMIAL FROM T(1) TO X
!                   USING ITS B-SPLINE REPRESENTATION
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
!     DEFINE THE FIRST NEW KNOT. THE REMAINING NEW KNOTS
!         ARE ASSUMED TO BE THE SAME AS THIS KNOT.
!
tnew = 0.1
if (tlast .lt. -0.1) tnew = 0.9*tlast
if (tlast .gt.  0.0) tnew = 1.1*tlast
!
!     COMPUTE THE FIRST N COEFFICIENTS OF THE ANTIDERIVATIVE
!
sum = 0.0
do i = 1,n
   ipk = i + k
   sum = sum + bcoeff(i)*(t(ipk) - t(i))
   wk(i) = sum/k
end do
!
!     COMPUTE THE ANTIDERIVATIVE
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
!     BVALI0 CALCULATES THE VALUE AT X OF AN ANTIDERIVATIVE
!     OF A B-SPLINE F FOR T(1) .LE. X .LE. T(N + K - 1).
!
!******  I N P U T ******
!
!  T     AN ARRAY CONTAINING THE FIRST N + K - 1 KNOTS OF THE
!        ANTIDERIVATIVE.
!  TNEW  THE REMAING KNOTS ARE ALL LOCATED AT THIS POINT.
!  BCOEF AN ARRAY CONTAINING THE FIRST N COEFFICIENTS OF THE
!        ANTIDERIVATIVE.
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
!     REMARK. BVALI0 IS AN ADAPTATION BY A.H. MORRIS (NSWC) OF THE
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
!     WK(J,1) NOT OBTAINABLE FROM INPUT TO ZERO. SET ANY T.S NOT OBTAIN-
!     ABLE EQUAL TO T(1) OR TNEW APPROPRIATELY.
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
!     B-SPLINE COEFFS IN WK(1,1),...,WK(K,1).
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
!     INPUT ...
!
!       T     KNOT SEQUENCE OF LENGTH N+K
!       A     B-SPLINE COEFFICIENT SEQUENCE OF LENGTH N
!       N     LENGTH OF A
!       K     ORDER OF THE B-SPLINES
!
!     OUTPUT ...
!
!       BREAK BREAKPOINT SEQUENCE, OF LENGTH L+1, CONTAINING
!             (IN INCREASING ORDER) THE DISTINCT POINTS OF THE
!             SEQUENCE T(K),...,T(N+1).
!       C     KXL MATRIX WHERE C(I,J) = (I-1)ST RIGHT DERIVATIVE
!             OF THE PP AT BREAK(J) DIVIDED BY FACTORIAL(I-1).
!       L     NUMBER OF POLYNOMIALS WHICH FORM THE PP
!
!     WORK AREA ...
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
!          GENERAL K-TH ORDER CASE
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
!          PIECEWISE CONSTANT CASE
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
!         THIS ROUTINE EVALUATES A PIECEWISE POLYNOMIAL AT THE
!         ABSCISSAS IN XI. IT IS ASSUMED THAT THE COEFFICIENTS
!         OF THE POLYNOMIALS WHICH FORM THE PP ARE GIVEN.
!
!       --INPUT--
!
!         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
!               THAT DEFINE THE PP.
!         A   - MATRIX THAT CONTAINS THE COEFFICIENTS OF THE POLY-
!               NOMIALS  WHICH FORM THE PP. IF I = 1,...,N THEN THE
!               PP HAS THE VALUE
!                    A(1,I) + A(2,I)*DX + ... + A(L,I)*DX**(L-1)
!               FOR X(I) .LE. XX .LT. X(I+1).  HERE DX = XX - X(I).
!         L   - ORDER OF THE PIECEWISE POLYNOMIAL.
!         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE PP.
!               N MUST BE GREATER THAN OR EQUAL TO 1.
!         XI  - THE ARRAY OF ABSCISSAS (IN ARBITRARY ORDER) AT WHICH
!               AT WHICH THE PP IS TO BE EVALUATED.
!         NI  - THE DIMENSION OF THE ARRAYS XI AND YI. IT IS ASSUMED
!               THAT NI IS GREATER THAN OR EQUAL TO 1.
!
!       --OUTPUT--
!
!         YI  - ARRAY OF VALUES OF THE PP AT THE POINTS IN XI.
!
!-----------------------------------------------------------------------
!
!     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
!     I IS THE CURRENT INDEX IN THE X ARRAY.
!
k  = 1
xx = xi(1)
lm1 = l - 1
if (xx .lt. x(1)) go to 90
if (xx .ge. x(n)) go to 80
il = 1
ir = n
!
!     BISECTION SEARCH
!
10 i = (il + ir)/2
if (i .eq. il) go to 100
if (xx - x(i)) 20,100,30
20 ir = i
go to 10
30 il = i
go to 10
!
!     LINEAR FORWARD SEARCH
!
40 if (xx .lt. x(i+1)) go to 100
i = i + 1
go to 40
!
!     XX IS GREATER THAN X(N) OR LESS THAN X(1)
!
80 i = n
go to 100
90 i = 1
!
!     EVALUATION
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
!     NEXT POINT
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
!     BSPVB CALCULATES THE VALUE OF ALL POSSIBLY NONZERO B-SPLINES
!     AT X OF ORDER MAX(JHIGH,J + 1) WHERE T(K) .LE. X .LT. T(N+1).
!
!     DESCRIPTION OF ARGUMENTS
!
!         INPUT
!
!          T       - KNOT VECTOR OF LENGTH N + K.
!          K       - HIGHEST POSSIBLE ORDER OF THE B-SPLINES.
!          JHIGH   - ORDER OF B-SPLINES (1 .LE. JHIGH .LE. K).
!          J       - J .LE. 0  GIVES B-SPLINES OF ORDER JHIGH.
!                    J .GE. 1  ON A PREVIOUS CALL TO BSPVB THE
!                              B-SPLINES OF ORDER J WERE COM-
!                              PUTED AND STORED IN BLIST. IT IS
!                              ASSUMED THAT WORK HAS NOT BEEN
!                              MODIFIED AND THAT J .LT. K.
!          X       - ARGUMENT OF THE B-SPLINES.
!          LEFT    - LARGEST INTEGER SUCH THAT
!                    T(LEFT) .LE. X .LT. T(LEFT+1)
!
!         OUTPUT
!
!          BLIST   - VECTOR OF LENGTH K FOR SPLINE VALUES.
!          J       - B-SPLINES OF ORDER J HAVE BEEN COMPUTED
!                    AND STORED IN BLIST.
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
! CALCULATES VALUE AND DERIV.S OF ALL B-SPLINES WHICH DO NOT VANISH AT X
!
!******  I N P U T  ******
!
!  T     THE KNOT ARRAY, OF LENGTH LEFT+K (AT LEAST)
!  K     THE ORDER OF THE B-SPLINES TO BE EVALUATED
!  X     THE POINT AT WHICH THESE VALUES ARE SOUGHT
!  LEFT  AN INTEGER INDICATING THE LEFT ENDPOINT OF THE INTERVAL OF
!        INTEREST. THE  K  B-SPLINES WHOSE SUPPORT CONTAINS THE INTERVAL
!               (T(LEFT), T(LEFT+1))
!        ARE TO BE CONSIDERED.
!  A S S U M P T I O N  - - -  IT IS ASSUMED THAT
!               T(LEFT) .LT. T(LEFT+1)
!        DIVISION BY ZERO WILL RESULT OTHERWISE (IN  B S P V B ).
!        ALSO, THE OUTPUT IS AS ADVERTISED ONLY IF
!               T(LEFT) .LE. X .LE. T(LEFT+1) .
!  IDIM  THE ROW DIMENSION OF THE MATRIX DBIATX. IF IS ASSUMED THAT
!        IDIM .GE. K .
!  NDERIV  AN INTEGER INDICATING THAT VALUES OF B-SPLINES AND THEIR
!        DERIVATIVES UP TO BUT NOT INCLUDING THE  NDERIV-TH  ARE ASKED
!        FOR. (NDERIV IS REPLACED INTERNALLY BY THE INTEGER  M H I G H
!        IN (1,K) CLOSEST TO IT.)
!
!******  O U T P U T  ******
!
!  DBIATX  AN ARRAY OF ORDER (IDIM,NDERIV). ITS ENTRY (I,M) CONTAINS
!        VALUE OF  (M-1)ST  DERIVATIVE OF  (LEFT-K+I)-TH  B-SPLINE OF
!        ORDER  K  FOR KNOT SEQUENCE  T , I=M,...,K, M=1,...,NDERIV.
!
!******  W O R K   A R E A  ******
!
!  A     AN ARRAY OF ORDER (K,K), TO CONTAIN B-COEFF.S OF THE DERIVA-
!        TIVES OF A CERTAIN ORDER OF THE  K  B-SPLINES OF INTEREST.
!
!******  M E T H O D  ******
!
!  VALUES AT  X  OF ALL THE RELEVANT B-SPLINES OF ORDER K,K-1,...,
!  K+1-NDERIV  ARE GENERATED VIA BSPVB AND STORED TEMPORARILY IN
!  DBIATX. THEN THE B-COEFFS OF THE REQUIRED DERIVATIVES OF THE B-
!  SPLINES OF INTEREST ARE GENERATED BY DIFFERENCING, EACH FROM THE PRE-
!  CEDING ONE OF LOWER ORDER, AND COMBINED WITH THE VALUES OF B-SPLINES
!  OF CORRESPONDING ORDER IN  DBIATX  TO PRODUCE THE DESIRED VALUES .
!
!-----------------------------------------------------------------------
!  WRITTEN BY CARL DE BOOR (UNIVERSITY OF WISCONSIN) AND MODIFIED
!     BY A.H. MORRIS (NSWC).
!-----------------------------------------------------------------------
real, intent(in) :: t(*)
real, intent(inout) :: dbiatx(idim,nderiv), a(k,k)
!
mhigh = max0(min0(nderiv,k),1)
!     MHIGH IS USUALLY EQUAL TO NDERIV.
kp1 = k + 1
jj = 0
call bspvb (t, k, kp1 - mhigh, jj, x, left, dbiatx)
if (mhigh .eq. 1) return
!
!     THE FIRST COLUMN OF DBIATX ALWAYS CONTAINS THE B-SPLINE VALUES
!     FOR THE CURRENT ORDER. THESE ARE STORED IN COLUMN K+1-CURRENT
!     ORDER  BEFORE  BSPVB  IS CALLED TO PUT VALUES FOR THE NEXT
!     HIGHER ORDER ON TOP OF IT.
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
!     AT THIS POINT, B(LEFT-K+I, K+1-J)(X) IS IN DBIATX(I,J) FOR
!     I = J,...,K AND J = 1,...,MHIGH. IN PARTICULAR, THE FIRST
!     COLUMN OF DBIATX IS ALREADY IN FINAL FORM. TO OBTAIN COR-
!     RESPONDING DERIVATIVES OF B-SPLINES IN SUBSEQUENT COLUMNS,
!     GENERATE THEIR B-REPR. BY DIFFERENCING. THEN EVALUATE AT X.
!
jlow = 1
do 20 i = 1,k
   do 19 j = jlow,k
19 a(j,i) = 0.0
   jlow = i
20 a(i,i) = 1.0
!
!     AT THIS POINT, A(.,J) CONTAINS THE B-COEFFS FOR THE J-TH OF THE
!     K  B-SPLINES OF INTEREST HERE.
!
do m = 2,mhigh
   kp1mm = kp1 - m
   fkp1mm = float(kp1mm)
   il = left
   i = k
!
!        FOR J = 1,...,K, CONSTRUCT B-COEFFS OF (M-1)ST  DERIVATIVE OF
!        B-SPLINES FROM THOSE FOR PRECEDING DERIVATIVE BY DIFFERENCING
!        AND STORE AGAIN IN  A(.,J) . THE FACT THAT  A(I,J) = 0  FOR
!        I .LT. J  IS USED.
!
   do ldummy = 1,kp1mm
      l = il + kp1mm
      factor = fkp1mm/(t(l) - t(il))
!
!           THE ASSUMPTION THAT T(LEFT).LT.T(LEFT+1) MAKES DENOMINATOR
!           IN THE FACTOR NONZERO.
!
      do 25 j = 1,i
25 a(i,j) = (a(i,j) - a(i-1,j))*factor
      il = il - 1
      i = i - 1
   end do
!
!        FOR I = 1,...,K, COMBINE B-COEFFS A(.,I) WITH B-SPLINE VALUES
!        STORED IN DBIATX(.,M) TO GET VALUE OF  (M-1)ST  DERIVATIVE OF
!        I-TH B-SPLINE (OF INTEREST HERE) AT X, AND STORE IN
!        DBIATX(I,M). STORAGE OF THIS VALUE OVER THE VALUE OF A B-SPLINE
!        OF ORDER M THERE IS SAFE SINCE THE REMAINING B-SPLINE DERIVAT-
!        IVES OF THE SAME ORDER DO NOT USE THIS VALUE DUE TO THE FACT
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
!   THIS ROUTINE PRODUCES THE B-SPLINE COEFF.S BCOEF OF THE PIECEWISE
!   POLYNOMIAL OF ORDER K WITH KNOTS T(I) (I=1,...,N+K) WHICH HAS THE
!   VALUE GTAU(I) AT TAU(I) FOR I=1,...,N.
!
!******  I N P U T  ******
!
!  TAU.....ARRAY OF LENGTH  N , CONTAINING DATA POINT ABSCISSAE.
!    A S S U M P T I O N . . .  TAU  IS STRICTLY INCREASING
!  GTAU.....CORRESPONDING ARRAY OF LENGTH  N , CONTAINING DATA POINT
!        ORDINATES.
!  T.....KNOT SEQUENCE, OF LENGTH  N+K
!  N.....NUMBER OF DATA POINTS AND DIMENSION OF SPLINE SPACE  S(K,T)
!  K.....ORDER OF THE PIECEWISE POLYNOMIAL
!  IFLAG.....ON AN INITIAL CALL TO THE ROUTINE, IFLAG MAY BE ASSIGNED
!        ANY VALUE EXCEPT 0. THE ROUTINE MAY BE RECALLED WHEN ONLY GTAU
!        IS MODIFIED. IFLAG=0 WHEN THIS IS DONE.
!
!******  O U T P U T  ******
!
!  BCOEF.....THE B-COEFFICIENTS OF THE INTERPOLANT, OF LENGTH  N
!  Q.....ARRAY OF SIZE  (2*K-1)*N , CONTAINING THE TRIANGULAR FACTORIZ-
!        ATION OF THE COEFFICIENT MATRIX OF THE LINEAR SYSTEM FOR THE B-
!        COEFFICIENTS OF THE SPLINE INTERPOLANT.
!  IFLAG.....AN INTEGER INDICATING SUCCESS (= 0)  OR FAILURE (= 1)
!        THE LINEAR SYSTEM TO BE SOLVED IS (THEORETICALLY) INVERTIBLE IF
!        AND ONLY IF
!              B(I)(TAU(I)) .NE. 0   FOR ALL I.
!        VIOLATION OF THIS CONDITION IS CERTAIN TO LEAD TO IFLAG = 1.
!
!******  M E T H O D  ******
!
!     THE I-TH EQUATION OF THE LINEAR SYSTEM  A*BCOEF = B  FOR THE B-CO-
!  EFFS OF THE INTERPOLANT ENFORCES INTERPOLATION AT  TAU(I), I=1,...,N.
!  HENCE,  B(I) = GTAU(I), ALL I, AND  A  IS A BAND MATRIX WITH  2K-1
!  BANDS (IF IT IS INVERTIBLE).
!     THE MATRIX  A  IS GENERATED ROW BY ROW AND STORED, DIAGONAL BY DI-
!  AGONAL, IN THE  R O W S  OF THE ARRAY  Q , WITH THE MAIN DIAGONAL GO-
!  ING INTO ROW  K .  SEE COMMENTS IN THE PROGRAM BELOW.
!     THE BANDED SYSTEM IS THEN SOLVED BY A CALL TO BANFAC (WHICH CON-
!  STRUCTS THE TRIANGULAR FACTORIZATION FOR  A  AND STORES IT IN  Q),
!  FOLLOWED BY A CALL TO BANSLV (WHICH THEN OBTAINS THE SOLUTION BCOEF
!  BY SUBSTITUTION).
!     BANFAC PERFORMS NO PIVOTING SINCE THE TOTAL POSITIVITY OF THE
!  MATRIX A MAKES THIS UNNECESSARY.
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
!        CHECK IF TAU(I) IS AN INCREASING SEQUENCE
!
do i = 2,n
   if (tau(i) .le. tau(i-1)) go to 100
end do
!
!                ZERO OUT ALL ENTRIES OF Q
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
!        MATRIX IS SINGULAR IF THIS IS NOT POSSIBLE
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
!        LEFT-K+1,...,LEFT ACTUALLY MIGHT BE NONZERO. THESE  K  NUMBERS
!        ARE RETURNED, IN  BCOEF (USED FOR TEMP.STORAGE HERE), BY THE
!        FOLLOWING
!
40 jj = 0
   call bspvb (t, k, k, jj, taui, left, bcoef)
!
!        LET Q DENOTE A TWO-DIMENSIONAL ARRAY OF DIMENSION (2*K-1,N).
!        WE THEREFORE WANT  BCOEF(J) = B(LEFT-K+J)(TAUI) TO GO INTO
!        A(I,LEFT-K+J), I.E., INTO  Q(I-(LEFT+J)+2*K,(LEFT+J)-K) SINCE
!        A(I+J,J)  IS TO GO INTO  Q(I+K,J), ALL I,J.  IN THE CURRENT
!        ROUTINE WE TREAT Q AS AN EQUIVALENT ONE-DIMENSIONAL ARRAY.
!        THUS WE WANT BCOEF(J) TO BE INSERTED INTO ENTRY
!            I - (LEFT+J) + 2*K + ((LEFT+J) - K-1)*(2*K-1)
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
!  FROM  * A PRACTICAL GUIDE TO SPLINES *  BY C. DE BOOR
!  RETURNS IN  W  THE LU-FACTORIZATION (WITHOUT PIVOTING) OF THE BANDED
!  MATRIX  A  OF ORDER  NROW  WITH  (NBANDL + 1 + NBANDU) BANDS OR DIAG-
!  ONALS IN THE WORK ARRAY  W .
!
!******  I N P U T  ******
!  W.....WORK ARRAY OF SIZE  (NROWW,NROW)  CONTAINING THE INTERESTING
!        PART OF A BANDED MATRIX  A , WITH THE DIAGONALS OR BANDS OF  A
!        STORED IN THE ROWS OF  W , WHILE COLUMNS OF  A  CORRESPOND TO
!        COLUMNS OF  W . THIS IS THE STORAGE MODE USED IN  LINPACK  AND
!        RESULTS IN EFFICIENT INNERMOST LOOPS.
!           EXPLICITLY,  A  HAS  NBANDL  BANDS BELOW THE DIAGONAL
!                            +     1     (MAIN) DIAGONAL
!                            +   NBANDU  BANDS ABOVE THE DIAGONAL
!        AND THUS, WITH    MIDDLE = NBANDU + 1,
!          A(I+J,J)  IS IN  W(I+MIDDLE,J)  FOR I=-NBANDU,...,NBANDL
!                                              J=1,...,NROW .
!        FOR EXAMPLE, THE INTERESTING ENTRIES OF A (1,2)-BANDED MATRIX
!        OF ORDER  9  WOULD APPEAR IN THE FIRST  1+1+2 = 4  ROWS OF  W
!        AS FOLLOWS.
!                          13 24 35 46 57 68 79
!                       12 23 34 45 56 67 78 89
!                    11 22 33 44 55 66 77 88 99
!                    21 32 43 54 65 76 87 98
!
!        ALL OTHER ENTRIES OF  W  NOT IDENTIFIED IN THIS WAY WITH AN EN-
!        TRY OF  A  ARE NEVER REFERENCED .
!  NROWW.....ROW DIMENSION OF THE WORK ARRAY  W .
!        MUST BE  .GE.  NBANDL + 1 + NBANDU  .
!  NBANDL.....NUMBER OF BANDS OF  A  BELOW THE MAIN DIAGONAL
!  NBANDU.....NUMBER OF BANDS OF  A  ABOVE THE MAIN DIAGONAL .
!
!******  O U T P U T  ******
!  IFLAG.....INTEGER INDICATING SUCCESS( = 1) OR FAILURE ( = 2) .
!     IF  IFLAG = 1, THEN
!  W.....CONTAINS THE LU-FACTORIZATION OF  A  INTO A UNIT LOWER TRIANGU-
!        LAR MATRIX  L  AND AN UPPER TRIANGULAR MATRIX  U (BOTH BANDED)
!        AND STORED IN CUSTOMARY FASHION OVER THE CORRESPONDING ENTRIES
!        OF  A . THIS MAKES IT POSSIBLE TO SOLVE ANY PARTICULAR LINEAR
!        SYSTEM  A*X = B  FOR  X  BY A
!              CALL BANSLV ( W, NROWW, NROW, NBANDL, NBANDU, B )
!        WITH THE SOLUTION X  CONTAINED IN  B  ON RETURN .
!     IF  IFLAG = 2, THEN
!        ONE OF  NROW-1, NBANDL,NBANDU FAILED TO BE NONNEGATIVE, OR ELSE
!        ONE OF THE POTENTIAL PIVOTS WAS FOUND TO BE ZERO INDICATING
!        THAT  A  DOES NOT HAVE AN LU-FACTORIZATION. THIS IMPLIES THAT
!        A  IS SINGULAR IN CASE IT IS TOTALLY POSITIVE .
!
!******  M E T H O D  ******
!     GAUSS ELIMINATION  W I T H O U T  PIVOTING IS USED. THE ROUTINE IS
!  INTENDED FOR USE WITH MATRICES  A  WHICH DO NOT REQUIRE ROW INTER-
!  CHANGES DURING FACTORIZATION, ESPECIALLY FOR THE  T O T A L L Y
!  P O S I T I V E  MATRICES WHICH OCCUR IN SPLINE CALCULATIONS.
!     THE ROUTINE SHOULD NOT BE USED FOR AN ARBITRARY BANDED MATRIX.
!
real, intent(inout) :: w(nroww,nrow)
real :: factor, pivot
!
iflag = 1
middle = nbandu + 1
!                         W(MIDDLE,.) CONTAINS THE MAIN DIAGONAL OF  A .
nrowm1 = nrow - 1
if (nrowm1)                       999,900,1
1 if (nbandl .gt. 0)                go to 10
!                A IS UPPER TRIANGULAR. CHECK THAT DIAGONAL IS NONZERO .
do i=1,nrowm1
   if (w(middle,i) .eq. 0.)       go to 999
   end do
                                  go to 900
10 if (nbandu .gt. 0)                go to 20
!              A IS LOWER TRIANGULAR. CHECK THAT DIAGONAL IS NONZERO AND
!                 DIVIDE EACH COLUMN BY ITS DIAGONAL .
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
!        A  IS NOT JUST A TRIANGULAR MATRIX. CONSTRUCT LU FACTORIZATION
20 do i=1,nrowm1
!                                  W(MIDDLE,I)  IS PIVOT FOR I-TH STEP .
   pivot = w(middle,i)
   if (pivot .eq. 0.)             go to 999
!                 JMAX  IS THE NUMBER OF (NONZERO) ENTRIES IN COLUMN  I
!                     BELOW THE DIAGONAL .
   jmax = min0(nbandl,nrow - i)
!              DIVIDE EACH ENTRY IN COLUMN  I  BELOW DIAGONAL BY PIVOT .
   jbeg = middle + 1
   jend = middle + jmax
   do 32 j = jbeg,jend
32 w(j,i) = w(j,i)/pivot
!                 KMAX  IS THE NUMBER OF (NONZERO) ENTRIES IN ROW  I  TO
!                     THE RIGHT OF THE DIAGONAL .
   kmax = min0(nbandu,nrow - i)
!                  SUBTRACT  A(I,I+K)*(I-TH COLUMN) FROM (I+K)-TH COLUMN
!                  (BELOW ROW  I ) .
   do 40 k = 1,kmax
      ipk = i + k
      midmk = middle - k
      factor = w(midmk,ipk)
      do 40 j = 1,jmax
         mj = middle + j
         mdj = midmk + j
40 w(mdj,ipk) = w(mdj,ipk) - w(mj,i)*factor
   end do
!                                       CHECK THE LAST DIAGONAL ENTRY .
900 if (w(middle,nrow) .ne. 0.)       return
999 iflag = 2
                                  return
end subroutine banfac

subroutine banslv ( w, nroww, nrow, nbandl, nbandu, b )
implicit none
integer, intent(in) :: nbandl, nbandu, nrow, nroww
integer :: i, imj, ipj, j, jmax, middle, mmj, mpj, nrowm1
!  FROM  * A PRACTICAL GUIDE TO SPLINES *  BY C. DE BOOR
!  COMPANION ROUTINE TO  BANFAC . IT RETURNS THE SOLUTION  X  OF THE
!  LINEAR SYSTEM  A*X = B  IN PLACE OF  B , GIVEN THE LU-FACTORIZATION
!  FOR  A  IN THE WORKARRAY  W .
!
!******  I N P U T  ******
!  W, NROWW,NROW,NBANDL,NBANDU.....DESCRIBE THE LU-FACTORIZATION OF A
!        BANDED MATRIX  A  OF RODER  NROW  AS CONSTRUCTED IN  BANFAC .
!        FOR DETAILS, SEE  BANFAC .
!  B.....RIGHT SIDE OF THE SYSTEM TO BE SOLVED .
!
!******  O U T P U T  ******
!  B.....CONTAINS THE SOLUTION  X , OF ORDER  NROW .
!
!******  M E T H O D  ******
!     (WITH  A = L*U, AS STORED IN  W,) THE UNIT LOWER TRIANGULAR SYSTEM
!  L(U*X) = B  IS SOLVED FOR  Y = U*X, AND  Y  STORED IN  B . THEN THE
!  UPPER TRIANGULAR SYSTEM  U*X = Y  IS SOLVED FOR  X  . THE CALCUL-
!  ATIONS ARE SO ARRANGED THAT THE INNERMOST LOOPS STAY WITHIN COLUMNS.
!
real, intent(in) :: w(nroww,nrow)
real, intent(inout) :: b(nrow)
middle = nbandu + 1
if (nrow .eq. 1)                  go to 49
nrowm1 = nrow - 1
if (nbandl .eq. 0)                go to 30
!                                 FORWARD PASS
!            FOR I=1,2,...,NROW-1, SUBTRACT  RIGHT SIDE(I)*(I-TH COLUMN
!            OF  L )  FROM RIGHT SIDE  (BELOW I-TH ROW) .
do 21 i = 1,nrowm1
   jmax = min0(nbandl, nrow-i)
   do 21 j = 1,jmax
      ipj = i + j
      mpj = middle + j
21 b(ipj) = b(ipj) - b(i)*w(mpj,i)
!                                 BACKWARD PASS
!            FOR I=NROW,NROW-1,...,1, DIVIDE RIGHT SIDE(I) BY I-TH DIAG-
!            ONAL ENTRY OF  U, THEN SUBTRACT  RIGHT SIDE(I)*(I-TH COLUMN
!            OF  U)  FROM RIGHT SIDE  (ABOVE I-TH ROW).
30 if (nbandu .gt. 0)                go to 40
!                                A  IS LOWER TRIANGULAR .
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
!        BSLSQ PRODUCES THE B-SPLINE COEFFICIENTS OF A PIECEWISE
!              POLYNOMIAL P(X) OF ORDER K WHICH MINIMIZES
!
!                SUM (WGT(J)*(P(TAU(J)) - GTAU(J))**2).
!
!
!     INPUT ...
!
!       TAU   ARRAY OF LENGTH NTAU CONTAINING DATA POINT ABSCISSAE.
!       GTAU  ARRAY OF LENGTH NTAU CONTAINING DATA POINT ORDINATES.
!       WGT   ARRAY OF LENGTH NTAU CONTAINING THE WEIGHTS.
!       NTAU  NUMBER OF DATA POINTS TO BE FITTED.
!       T     KNOT SEQUENCE OF LENGTH N + K.
!       N     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
!       K     ORDER OF THE B-SPLINES.
!
!     OUTPUT ...
!
!       A     ARRAY OF LENGTH N CONTAINING THE B-SPLINE COEFFICIENTS
!             OF THE L2 APPROXIMATION.
!
!       IERR  INTEGER REPORTING THE STATUS OF THE RESULTS ...
!
!             0  THE COEFFICIENT MATRIX IS NONSIGULAR. THE
!                UNIQUE LEAST SQUARES SOLUTION WAS OBTAINED.
!             1  THE COEFFICIENT MATRIX IS SINGULAR. A
!                LEAST SQUARES SOLUTION WAS OBTAINED.
!            -1  INPUT ERRORS WERE DETECTED.
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
!        SOLVE THE NORMAL EQUATIONS
!
call bchfac (q, k, n, wk, ierr)
call bchslv (q, k, n, a)
return
!
!             ERROR RETURN
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
!  FROM  * A PRACTICAL GUIDE TO SPLINES *  BY C. DE BOOR
!  CONSTRUCTS CHOLESKY FACTORIZATION
!                     C  =  L * D * L-TRANSPOSE
!  WITH L UNIT LOWER TRIANGULAR AND D DIAGONAL, FOR GIVEN MATRIX C OF
!  ORDER  N , IN CASE  C  IS (SYMMETRIC) POSITIVE SEMIDEFINITE
!  AND BANDED, HAVING NB DIAGONALS AT AND BELOW THE MAIN DIAGONAL.
!
!******  INPUT  ******
!
!     N      THE ORDER OF THE MATRIX C.
!
!     NB     THE BANDWIDTH OF C, I.E.,
!               C(I,J) = 0 FOR ABS(I-J) .GT. NB .
!
!     W      WORK ARRAY OF SIZE NB BY N CONTAINING THE NB DIAGONALS
!            IN ITS ROWS, WITH THE MAIN DIAGONAL IN ROW 1. PRECISELY,
!            W(I,J)  CONTAINS  C(I+J-1,J), I=1,...,NB, J=1,...,N.
!            FOR EXAMPLE, THE INTERESTING ENTRIES OF A SEVEN DIAGONAL
!            SYMMETRIC MATRIX C OF ORDER 9 WOULD BE STORED IN W AS
!
!                       11 22 33 44 55 66 77 88 99
!                       21 32 43 54 65 76 87 98
!                       31 42 53 64 75 86 97
!                       41 52 63 74 85 96
!
!            ALL OTHER ENTRIES OF W NOT IDENTIFIED WITH AN ENTRY OF C
!            ARE NEVER REFERENCED.
!
!     DIAG   WORK ARRAY OF LENGTH N.
!
!******  O U T P U T  ******
!                                                         T
!     W      CONTAINS THE CHOLESKY FACTORIZATION C = L*D*L   WHERE
!            W(1,I) = 1/D(I,I) AND W(I,J) = L(I-1+J,J) (I=2,...,NB).
!
!     IFLAG  0 IF C IS NONSINGULAR AND 1 IF C IS SINGULAR.
!
!******  M E T H O D  ******
!
!   GAUSS ELIMINATION, ADAPTED TO THE SYMMETRY AND BANDEDNESS OF  C , IS
!   USED .
!     NEAR ZERO PIVOTS ARE HANDLED IN A SPECIAL WAY. THE DIAGONAL ELE-
!  MENT C(K,K) = W(1,K) IS SAVED INITIALLY IN  DIAG(K), ALL K. AT THE K-
!  TH ELIMINATION STEP, THE CURRENT PIVOT ELEMENT, VIZ.  W(1,K), IS COM-
!  PARED WITH ITS ORIGINAL VALUE, DIAG(K). IF, AS THE RESULT OF PRIOR
!  ELIMINATION STEPS, THIS ELEMENT HAS BEEN REDUCED BY ABOUT A WORD
!  LENGTH, (I.E., IF W(1,K)+DIAG(K) .LE. DIAG(K)), THEN THE PIVOT IS DE-
!  CLARED TO BE ZERO, AND THE ENTIRE K-TH ROW IS DECLARED TO BE LINEARLY
!  DEPENDENT ON THE PRECEDING ROWS. THIS HAS THE EFFECT OF PRODUCING
!   X(K) = 0  WHEN SOLVING  C*X = B  FOR  X, REGARDLESS OF  B. JUSTIFIC-
!  ATION FOR THIS IS AS FOLLOWS. IN CONTEMPLATED APPLICATIONS OF THIS
!  PROGRAM, THE GIVEN EQUATIONS ARE THE NORMAL EQUATIONS FOR SOME LEAST-
!  SQUARES APPROXIMATION PROBLEM, DIAG(K) = C(K,K) GIVES THE NORM-SQUARE
!  OF THE K-TH BASIS FUNCTION, AND, AT THIS POINT,  W(1,K)  CONTAINS THE
!  NORM-SQUARE OF THE ERROR IN THE LEAST-SQUARES APPROXIMATION TO THE K-
!  TH BASIS FUNCTION BY LINEAR COMBINATIONS OF THE FIRST K-1 . HAVING
!  W(1,K)+DIAG(K) .LE. DIAG(K) SIGNIFIES THAT THE K-TH FUNCTION IS LIN-
!  EARLY DEPENDENT TO MACHINE ACCURACY ON THE FIRST K-1 FUNCTIONS, THERE
!  FORE CAN SAFELY BE LEFT OUT FROM THE BASIS OF APPROXIMATING FUNCTIONS
!     THE SOLUTION OF A LINEAR SYSTEM
!                       C*X = B
!   IS EFFECTED BY THE SUCCESSION OF THE FOLLOWING  T W O  CALLS ...
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
!     STORE THE DIAGONAL OF C IN DIAG
!
10 do k = 1,n
   diag(k) = w(1,k)
end do
!
!     FACTORIZATION
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
!     THE CHOLESKY FACTORIZATION OBTAINED BY THE SUBROUTINE BCHFAC
!     FOR THE BANDED SYMMETRIC POSITIVE DEFINITE MATRIX C.
!
!     INPUT ...
!
!        N   THE ORDER OF THE MATRIX C
!        NB  THE BANDWIDTH OF C
!        W   THE CHOLESKY FACTORIZATION OF C
!        B   VECTOR OF LENGTH N CONTAINING THE RIGHT SIDE
!
!     OUTPUT ...
!
!        B   SOLUTION X OF THE LINEAR SYSTEM C*X = B
!
!                                       T
!     NOTE.  THE FACTORIZATION C = L*D*L  IS USED, WHERE L IS A
!     UNIT LOWER TRIANGULAR MATRIX AND D A DIAGONAL MATRIX.
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
!      THIS SUBPROGRAM FITS A PIECE-WISE POLYNOMIAL CURVE
!      TO DISCRETE DATA.  THE PIECE-WISE POLYNOMIALS ARE
!      REPRESENTED AS B-SPLINES.
!      THE FITTING IS DONE IN A LEAST SQUARES SENSE.
!      EQUALITY AND INEQUALITY CONSTRAINTS CAN BE IMPOSED
!      ON THE FITTED CURVE.
!
!  INPUT..
!
!      N,NORD,BKPT(*)     N IS THE NUMBER OF COEFFICIENTS TO BE COM-
!                         PUTED AND NORD IS THE ORDER OF THE B-SPLINE.
!                         IT IS ASSUMED THAT N .GE. NORD. THE N + NORD
!                         KNOTS OF THE SPLINE ARE IN THE ARRAY BKPT(*).
!                         IT IS ASSUMED THAT THE KNOTS FORM A NONDE-
!                         CREASING SEQUENCE. THE PROBLEM DATA INTERVAL
!                         LIES BETWEEN THE POINTS BKPT(NORD) AND
!                         BKPT(N+1). THE ADDITIONAL END KNOTS BKPT(I),
!                         I = 1,...,NORD-1 AND I = N+2,...,N+NORD, ARE
!                         REQUIRED TO COMPUTE THE FUNCTIONS USED TO
!                         FIT THE DATA.
!
!                         (THE ORDER OF THE B-SPLINE IS ONE MORE THAN
!                         THE DEGREE OF THE PIECEWISE POLYNOMIAL. FOR
!                         EXAMPLE, NORD=4 WHEN WE ARE USING PIECEWISE
!                         CUBICS.)
!
!      NDATA,XDATA(*),
!      YDATA(*)           THE NDATA DISCRETE (X,Y) PAIRS ARE IN
!                         THE ARRAYS XDATA(*) AND YDATA(*). IT IS
!                         ASSUMED THAT XDATA(*) IS AN INCREASING
!                         SEQUENCE, XDATA(1) .GE. BKPT(NORD), AND
!                         XDATA(NDATA) .LE. BKPT(N+1).
!
!      NCONST,XCONST(*),
!      YCONST(*),NDERIV(*)
!                         THE NUMBER OF CONDITIONS THAT CONSTRAIN
!                         THE B-SPLINE IS NCONST. A CONSTRAINT IS
!                         SPECIFIED BY AN (X,Y) PAIR IN THE ARRAYS
!                         XCONST(*) AND YCONST(*), AND BY THE TYPE
!                         OF CONSTRAINT AND DERIVATIVE VALUE ENCODED
!                         IN THE ARRAY NDERIV(*). IT IS ASSUMED THAT
!                         THE VALUES IN XCONST(*) ARE IN THE CLOSED
!                         INTERVAL (BKPT(NORD),BKPT(N+1)). THE CON-
!                         STRAINTS MAY BE GIVEN IN ANY ORDER. THE
!                         VALUE OF NDERIV(*) IS DETERMINED AS FOLLOWS.
!                         SUPPOSE THE I-TH CONSTRAINT APPLIES TO THE
!                         J-TH DERIVATIVE OF THE B-SPLINE.  (ANY
!                         NONNEGATIVE VALUE OF J .LT. NORD IS PERMITTED.
!                         IN PARTICULAR, THE VALUE J = 0 REFERS TO THE
!                         B-SPLINE ITSELF.)
!                         FOR THIS I-TH CONSTRAINT, SET
!                          XCONST(I) = X,
!                          YCONST(I) = Y, AND
!                          NDERIV(I) = ITYPE + 4*J  WHERE
!
!                          ITYPE = 0,      IF (J-TH DERIV. AT X) .LE. Y.
!                                = 1,      IF (J-TH DERIV. AT X) .GE. Y.
!                                = 2,      IF (J-TH DERIV. AT X) .EQ. Y.
!                                = 3,      IF (J-TH DERIV. AT X) .EQ.
!                                             (J-TH DERIV. AT Y).
!                          (A NEGATIVE VALUE FOR NDERIV(I) WILL CAUSE
!                          THIS CONSTRAINT TO BE IGNORED.  THIS
!                          FEATURE IS OFTEN USEFUL WHEN TEMPORARILY
!                          SUPPRESSING A CONSTRAINT WHILE STILL
!                          RETAINING THE SOURCE CODE OF THE CALLING
!                          PROGRAM.)
!
!      MODE               AN INPUT FLAG THAT DIRECTS THE LEAST
!                         SQUARES SOLUTION METHOD USED BY BFIT( ).
!
!                         MODE = 0      A NEW PROBLEM.
!
!                         MODE .NE. 0   AN OLD PROBLEM.
!
!                         BY AN OLD PROBLEM IT IS MEANT THAT BFIT( )
!                         WAS LAST CALLED WITH THE SAME SET OF KNOTS
!                         AND DATA POINTS. (THE CONSTRAINTS MAY BE
!                         DIFFERENT THAN BEFORE.)
!
!
!      IW(1),IW(2)        THE AMOUNTS OF WORKING STORAGE ACTUALLY
!                         ALLOCATED FOR THE WORKING ARRAYS W(*) AND
!                         IW(*).  THESE QUANTITIES ARE COMPARED WITH THE
!                         ACTUAL AMOUNTS OF STORAGE NEEDED IN BFIT( ).
!                         INSUFFICIENT STORAGE ALLOCATED FOR
!                         EITHER W(*) OR IW(*) IS AN ERROR.
!
!                         LENGTH OF W(*) MUST BE AT LEAST
!
!                           NB = (N + 3)*(NORD + 1) + NORD**2
!
!                         AND THE LENGTH OF IW(*) MUST BE AT LEAST 2.
!                         WHENEVER POSSIBLE THE CODE USES BANDED MATRIX
!                         PROCESSORS BNDACC( ) AND BNDSL( ).  THESE
!                         ARE UTILIZED IF THERE ARE NO CONSTRAINTS AND
!                         THERE IS SUFFICIENT DATA TO UNIQUELY DETERMINE
!                         THE B-SPLINE COEFFICENTS.
!
!                         IF THE BAND PROCESSORS CANNOT BE USED TO
!                         DETERMINE THE SOLUTION, THEN THE CONSTRAINED
!                         LEAST SQUARES CODE LSEI( ) IS USED.
!                         IN THIS CASE THE SUBPROGRAM REQUIRES AN
!                         ADDITIONAL BLOCK OF STORAGE IN W(*).  FOR THE
!                         DISCUSSION HERE DEFINE THE INTEGERS
!                         NEQCON AND NINCON RESPECTIVELY AS THE
!                         NUMBER OF EQUALITY (ITYPE=2,3) AND
!                         INEQUALITY (ITYPE=0,1) CONSTRAINTS
!                         IMPOSED ON THE FITTED CURVE.  DEFINE
!
!                           L = N + 1
!
!                         AND NOTE THAT
!
!                           NCONST = NEQCON + NINCON.
!
!                         WHEN THE SUBPROGRAM BFIT( ) USES LSEI( ) THE
!                         LENGTH OF THE WORKING ARRAY W(*) MUST BE AT
!                         LEAST
!
!                           LW = NB + (L+NCONST)*L + 2*(NEQCON+L)
!                                   + (NINCON + L) + (NINCON+2)*(L+6)
!
!                         AND THE LENGTH OF THE ARRAY IW(*) MUST BE AT
!                         LEAST
!
!                           IW1 = NINCON + 2*L .
!
!  OUTPUT..
!
!      MODE               AN OUTPUT FLAG THAT INDICATES THE STATUS
!                         OF THE CONSTRAINED CURVE FIT.
!
!                         =-1  EITHER NORD .LT. 1 OR NORD .GT. N.
!
!                         =-2  EITHER NDATA .LT. 1 OR NCONST .LT. 0.
!
!                         =-3  BKPT(I) .GT. BKPT(I+1) FOR SOME I.
!
!                         =-4  XDATA(*) IS NOT AN INCREASING
!                              SEQUENCE IN THE CLOSED INTERVAL
!                              (BKPT(NORD), BKPT(N+1)).
!
!                         =-5  THE I-TH CONSTRAINT IS INCORRECT
!                              FOR THE VALUE OF I STORED IN IW(2).
!
!                         =-6  INSUFF. STORAGE FOR W(*). IW(1) HAS
!                              BEEN RESET TO THE AMOUNT OF STORAGE
!                              NEEDED BY W(*).
!
!                         =-7  INSUFF. STORAGE FOR IW(*). IW(2) HAS
!                              BEEN RESET TO THE AMOUNT OF STORAGE
!                              NEEDED BY IW(*).
!
!                         = 0  SUCCESSFUL CONSTRAINED CURVE FIT.
!
!                         = 1  THE REQUESTED EQUALITY CONSTRAINTS
!                              ARE CONTRADICTORY.
!
!                         = 2  THE PROBLEM CANNOT BE SOLVED. THE
!                              CONSTRAINTS ARE CONTRADICTORY.
!
!      COEFF(*)
!                         IF THE OUTPUT VALUE OF MODE=0 OR 1, COEFF(*)
!                         CONTAINS THE N UNKNOWNS OBTAINED FROM THE
!                         LEAST SQUARES FITTING PROCESS.  THESE N
!                         PARAMETERS ARE THE B-SPLINE COEFFICIENTS.
!                         FOR MODE=1, THE EQUALITY CONSTRAINTS ARE
!                         CONTRADICTORY.  TO MAKE THE FITTING PROCESS
!                         MORE ROBUST, THE EQUALITY CONSTRAINTS ARE
!                         SATISFIED IN A LEAST SQUARES SENSE.  IN
!                         THIS CASE THE ARRAY COEFF(*) CONTAINS
!                         B-SPLINE COEFFICIENTS FOR THIS EXTENDED
!                         CONCEPT OF A SOLUTION.
!                         IF MODE .LT. 0 OR MODE = 2 ON OUTPUT, THE
!                         ARRAY COEFF(*) IS UNDEFINED.
!
!      RNORM              IF THE OUTPUT VALUE OF MODE = 0 OR 1 THEN
!                         RNORM IS THE L2 NORM OF THE VECTOR
!                         (YDATA(I) - F(XDATA(I)), I = 1,NDATA).
!
!  WORKING ARRAYS..
!
!      W(*),IW(*)         THESE ARRAYS ARE RESPECTIVELY TYPED
!                         REAL AND INTEGER.  THEIR REQUIRED
!                         LENGTHS ARE SPECIFIED AS INPUT PARAMETERS
!                         IN IW(1), IW(2) NOTED ABOVE. IT IS ASSUMED
!                         THAT W(1),...,W(NB) HAVE NOT BEEN MODIFIED
!                         IF BFIT( ) IS BEING RECALLED FOR THE SAME
!                         KNOTS AND DATA AS BEFORE (I.E., IF WE HAVE
!                         AN OLD PROBLEM).
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
!                         USAGE IN BFIT0( ) OF W(*)..
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
!     CHECK FURTHER FOR SUFFICIENT STORAGE IN WORKING ARRAYS.
!
20 if (iw1 .lt. lw) go to 850
if (iw2 .lt. intw1) go to 860
go to 300
!
!     SOLVE THE EQUATIONS
!
30 call lsei(w, mdw, neqcon, np1, nincon, n, prgopt, coeff, rnorme, &
&rnorm, mode, work, iwork)
iwork(1) = iw1
iwork(2) = iw2
return
!-----------------------------------------------------------------------
!               INITIALIZE-VARIABLES-AND-ANALYZE-INPUT
!-----------------------------------------------------------------------
100 n = nbkpt - nord
if (nord .lt. 1 .or. nord .gt. n) go to 800
if (ndata .lt. 1 .or. nconst .lt. 0) go to 810
!
!     CHECK THE BREAK POINTS
!
if (mode .ne. 0) go to 120
m = nbkpt - 1
do i = 1,m
   if (bkpt(i) .gt. bkpt(i+1)) go to 820
end do
!
!     AMOUNT OF STORAGE ALLOCATED FOR W(*),IW(*)
!
120 iw1 = iwork(1)
iw2 = iwork(2)
nb = (n + 3)*(nord + 1) + nord*nord
lw = nb
if (iw1 .lt. nb) go to 850
!
!     COMPUTE THE AMOUNT OF STORAGE NEEDED FOR LSEI
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
!     CHECK THE XCONST(*) ARRAY
!
xmin = bkpt(nord)
xmax = bkpt(np1)
if (nconst .eq. 0) go to 170
do i = 1,nconst
   if (xconst(i) .lt. xmin .or. xconst(i) .gt. xmax) &
&go to 840
end do
!
!     INITIALIZE PARAMETERS
!
170 new = mode .eq. 0
band = nconst .eq. 0
mode = 0
nordm1 = nord - 1
nordp1 = nord + 1
!
!     DEFINE THE OPTION VECTOR FOR USE IN LSEI( )
!
!     INCREASE THE RANK DETERMINATION TOLERANCES
!     FOR BOTH EQUALITY CONSTRAINT EQUATIONS AND
!     LEAST SQUARES EQUATIONS.
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
!     CHECK THE XDATA(*) ARRAY
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
!     INITIALIZE PARAMETERS OF BANDED MATRIX PROCESSOR, BNDACC( )
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
!     WHEN INTERVAL CHANGES, PROCESS EQUATIONS IN THE LAST BLOCK.
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
!     OBTAIN B-SPLINE FUNCTION VALUE
!
230 j = 0
call bspvb (bkpt, nord, nord, j, xval, ileft, bf)
!
!     MOVE ROW INTO PLACE
!
irow = ir + mt
mt = mt + 1
call scopy (nord, bf, 1, g(irow,1), mdg)
g(irow,nordp1) = ydata(idata)
!
!     WHEN STAGING WORK AREA IS EXHAUSTED, PROCESS ROWS
!
if (irow .ne. mdg - 1) go to 240
   intrvl = ileft - nordm1
   call bndacc (g, mdg, nord, ip, ir, mt, intrvl)
   mt = 0
240 idata = idata + 1
go to 210
!
!     PROCESS  BLOCK OF EQUATIONS
!
250 intrvl = ileft - nordm1
call bndacc (g, mdg, nord, ip, ir, mt, intrvl)
!
!     LAST CALL TO ADJUST BLOCK POSITIONING
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
!       ANALYZE CONSTRAINT INDICATORS FOR EQUALITY CONSTRAINTS
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
!                    TRANSFER-LEAST-SQUARES DATA
!-----------------------------------------------------------------------
400 do i = 1,np1
  irow = i + neqcon
  w(irow,1) = 0.0
  call scopy (n, w(irow,1), 0, w(irow,1), mdw)
  call scopy (min0(np1-i,nord), g(i,1), mdg, w(irow,i), mdw)
  w(irow,np1) = g(i,nordp1)
end do
!-----------------------------------------------------------------------
!      ANALYZE CONSTRAINT INDICATORS FOR INEQUALITY CONSTRAINTS
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
!                         ERROR RETURN
!-----------------------------------------------------------------------
!                       EITHER NORD .LT. 1 OR NORD .GT. N.
800 mode = -1
return
!                       EITHER NDATA .LT. 1 OR NCONST .LT. 0.
810 mode = -2
return
!                       THE SEQUENCE OF KNOTS IS NOT NONDECREASING.
820 mode = -3
return
!                       XDATA(*) IS NOT AN INCREASING SEQUENCE IN THE
!                       CLOSED INTERVAL (BKPT(1),BKPT(N+1)).
830 mode = -4
return
!                       THE I-TH CONSTRAINT IS INCORRECT FOR THE
!                       VALUE OF I STORED IN IWORK(2).
840 iwork(2) = i
mode = -5
return
!                       INSUFF. STORAGE FOR W(*). IWORK(1) HAS BEEN SET
!                       TO THE AMOUNT OF STORAGE NEEDED BY W(*).
850 iwork(1) = lw
mode = -6
return
!                       INSUFF. STORAGE FOR IW(*). IWORK(2) HAS BEEN SET
!                       TO THE AMOUNT OF STORAGE NEEDED BY IW(*).
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
!            MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF
!            THE DATA MATRIX.  EXACTLY ONE RIGHT-HANDED SIDE VECTOR
!            IS PERMITTED.
!***DESCRIPTION
!
!     THESE SUBROUTINES SOLVE THE LEAST SQUARES PROBLEM AX = B FOR
!     BANDED MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF THE
!     DATA MATRIX.  EXACTLY ONE RIGHT-HAND SIDE VECTOR IS PERMITTED.
!
!     THESE SUBROUTINES ARE INTENDED FOR THE TYPE OF LEAST SQUARES
!     SYSTEMS THAT ARISE IN APPLICATIONS SUCH AS CURVE OR SURFACE
!     FITTING OF DATA.  THE LEAST SQUARES EQUATIONS ARE ACCUMULATED AND
!     PROCESSED USING ONLY PART OF THE DATA.  THIS REQUIRES A CERTAIN
!     USER INTERACTION DURING THE SOLUTION OF AX = B.
!
!     SPECIFICALLY, SUPPOSE THE DATA MATRIX (A B) IS ROW PARTITIONED
!     INTO Q SUBMATRICES.  LET (E F) BE THE T-TH ONE OF THESE
!     SUBMATRICES WHERE E = (0 C 0).  HERE THE DIMENSION OF E IS MT BY N
!     AND THE DIMENSION OF C IS MT BY NB.  THE VALUE OF NB IS THE
!     BANDWIDTH OF A.  THE DIMENSIONS OF THE LEADING BLOCK OF ZEROS IN E
!     ARE MT BY JT-1.
!
!     THE USER OF THE SUBROUTINE BNDACC PROVIDES MT,JT,C AND F FOR
!     T=1,...,Q.  NOT ALL OF THIS DATA MUST BE SUPPLIED AT ONCE.
!
!     FOLLOWING THE PROCESSING OF THE VARIOUS BLOCKS (E F), THE MATRIX
!     (A B) HAS BEEN TRANSFORMED TO THE FORM (R D) WHERE R IS UPPER
!     TRIANGULAR AND BANDED WITH BANDWIDTH NB.  THE LEAST SQUARES
!     SYSTEM RX = D IS THEN EASILY SOLVED USING BACK SUBSTITUTION BY
!     EXECUTING THE STATEMENT CALL BNDSL(1,...). THE SEQUENCE OF
!     VALUES FOR JT MUST BE NONDECREASING.  THIS MAY REQUIRE SOME
!     PRELIMINARY INTERCHANGES OF ROWS AND COLUMNS OF THE MATRIX A.
!
!     THE PRIMARY REASON FOR THESE SUBROUTINES IS THAT THE TOTAL
!     PROCESSING CAN TAKE PLACE IN A WORKING ARRAY OF DIMENSION MU BY
!     NB+1.  AN ACCEPTABLE VALUE FOR MU IS
!
!                       MU = MAX(MT + N + 1),
!
!     WHERE N IS THE NUMBER OF UNKNOWNS.
!
!     HERE THE MAXIMUM IS TAKEN OVER ALL VALUES OF MT FOR T=1,...,Q.
!     NOTICE THAT MT CAN BE TAKEN TO BE A SMALL AS ONE, SHOWING THAT
!     MU CAN BE AS SMALL AS N+2.  THE SUBPROGRAM BNDACC PROCESSES THE
!     ROWS MORE EFFICIENTLY IF MU IS LARGE ENOUGH SO THAT EACH NEW
!     BLOCK (C F) HAS A DISTINCT VALUE OF JT.
!
!     THE FOUR PRINCIPLE PARTS OF THESE ALGORITHMS ARE OBTAINED BY THE
!     FOLLOWING CALL STATEMENTS
!
!     CALL BNDACC(...)  INTRODUCE NEW BLOCKS OF DATA.
!
!     CALL BNDSL(1,...)COMPUTE SOLUTION VECTOR AND LENGTH OF
!                       RESIDUAL VECTOR.
!
!     CALL BNDSL(2,...)GIVEN ANY ROW VECTOR H SOLVE YR = H FOR THE
!                       ROW VECTOR Y.
!
!     CALL BNDSL(3,...)GIVEN ANY COLUMN VECTOR W SOLVE RZ = W FOR
!                       THE COLUMN VECTOR Z.
!
!     THE DOTS IN THE ABOVE CALL STATEMENTS INDICATE ADDITIONAL
!     ARGUMENTS THAT WILL BE SPECIFIED IN THE FOLLOWING PARAGRAPHS.
!
!     THE USER MUST DIMENSION THE ARRAY APPEARING IN THE CALL LIST..
!     G(MDG,NB+1)
!
!     DESCRIPTION OF CALLING SEQUENCE FOR BNDACC..
!
!     THE ENTIRE SET OF PARAMETERS FOR BNDACC ARE
!
!     INPUT..
!
!     G(*,*)            THE WORKING ARRAY INTO WHICH THE USER WILL
!                       PLACE THE MT BY NB+1 BLOCK (C F) IN ROWS IR
!                       THROUGH IR+MT-1, COLUMNS 1 THROUGH NB+1.
!                       SEE DESCRIPTIONS OF IR AND MT BELOW.
!
!     MDG               THE NUMBER OF ROWS IN THE WORKING ARRAY
!                       G(*,*).  THE VALUE OF MDG SHOULD BE .GE. MU.
!                       THE VALUE OF MU IS DEFINED IN THE ABSTRACT
!                       OF THESE SUBPROGRAMS.
!
!     NB                THE BANDWIDTH OF THE DATA MATRIX A.
!
!     IP                SET BY THE USER TO THE VALUE 1 BEFORE THE
!                       FIRST CALL TO BNDACC.  ITS SUBSEQUENT VALUE
!                       IS CONTROLLED BY BNDACC TO SET UP FOR THE
!                       NEXT CALL TO BNDACC.
!
!     IR                INDEX OF THE ROW OF G(*,*) WHERE THE USER IS
!                       TO PLACE THE NEW BLOCK OF DATA (C F).  SET BY
!                       THE USER TO THE VALUE 1 BEFORE THE FIRST CALL
!                       TO BNDACC.  ITS SUBSEQUENT VALUE IS CONTROLLED
!                       BY BNDACC. A VALUE OF IR .GT. MDG IS CONSIDERED
!                       AN ERROR.
!
!     MT,JT             SET BY THE USER TO INDICATE RESPECTIVELY THE
!                       NUMBER OF NEW ROWS OF DATA IN THE BLOCK AND
!                       THE INDEX OF THE FIRST NONZERO COLUMN IN THAT
!                       SET OF ROWS (E F) = (0 C 0 F) BEING PROCESSED.
!
!     OUTPUT..
!
!     G(*,*)            THE WORKING ARRAY WHICH WILL CONTAIN THE
!                       PROCESSED ROWS OF THAT PART OF THE DATA
!                       MATRIX WHICH HAS BEEN PASSED TO BNDACC.
!
!     IP,IR             THE VALUES OF THESE ARGUMENTS ARE ADVANCED BY
!                       BNDACC TO BE READY FOR STORING AND PROCESSING
!                       A NEW BLOCK OF DATA IN G(*,*).
!
!
!     REMARKS..
!
!     TO OBTAIN THE UPPER TRIANGULAR MATRIX AND TRANSFORMED RIGHT-HAND
!     SIDE VECTOR D SO THAT THE SUPER DIAGONALS OF R FORM THE COLUMNS
!     OF G(*,*), EXECUTE THE FOLLOWING FORTRAN STATEMENTS.
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
!              ALG. STEPS 1-4 ARE PERFORMED EXTERNAL TO THIS SUBROUTINE.
!
nbp1 = nb + 1
if (mt .le. 0 .or. nb .le. 0) return
!                                             ALG. STEP 5
if (jt .eq. ip) go to 70
!                                             ALG. STEPS 6-7
if (jt .le. ir) go to 30
!                                             ALG. STEPS 8-9
do i = 1,mt
   ig1 = jt + mt - i
   ig2 = ir + mt - i
   do j = 1,nbp1
      g(ig1,j) = g(ig2,j)
   end do
end do
!                                             ALG. STEP 10
ie = jt - ir
do i = 1,ie
   ig = ir + i - 1
   do j = 1,nbp1
     g(ig,j) = 0.0
   end do
end do
!                                             ALG. STEP 11
ir = jt
!                                             ALG. STEP 12
30 mu = min0(nb - 1, ir - ip - 1)
if (mu .eq. 0) go to 60
!                                             ALG. STEP 13
do l = 1,mu
!                                             ALG. STEP 14
   k = min0(l, jt - ip)
!                                             ALG. STEP 15
   lp1 = l + 1
   ig = ip + l
   do i = lp1,nb
      jg = i - k
      g(ig,jg) = g(ig,i)
   end do
!                                             ALG. STEP 16
   do i = 1,k
      jg = nbp1 - i
      g(ig,jg) = 0.0
   end do
end do
!                                             ALG. STEP 17
60 ip = jt
!                                             ALG. STEPS 18-19
70 mh = ir + mt - ip
kh = min0(nbp1, mh)
!                                             ALG. STEP 20
do i = 1,kh
   call h12 (1,i,max0(i+1,ir-ip+1),mh,g(ip,i),1,rho, &
&g(ip,i+1),1,mdg,nbp1-i)
end do
!                                             ALG. STEP 21
ir = ip + kh
!                                             ALG. STEP 22
if (kh .lt. nbp1) go to 100
!                                             ALG. STEP 23
do i = 1,nb
   g(ir-1,i) = 0.0
end do
!                                             ALG. STEP 24
100 continue
!                                             ALG. STEP 25
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
!            MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF
!            THE DATA MATRIX.  EXACTLY ONE RIGHT-HANDED SIDE VECTOR
!            IS PERMITTED.
!
!     THESE SUBROUTINES SOLVE THE LEAST SQUARES PROBLEM AX = B FOR
!     BANDED MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF THE
!     DATA MATRIX.  EXACTLY ONE RIGHT-HAND SIDE VECTOR IS PERMITTED.
!
!     THESE SUBROUTINES ARE INTENDED FOR THE TYPE OF LEAST SQUARES
!     SYSTEMS THAT ARISE IN APPLICATIONS SUCH AS CURVE OR SURFACE
!     FITTING OF DATA.  THE LEAST SQUARES EQUATIONS ARE ACCUMULATED AND
!     PROCESSED USING ONLY PART OF THE DATA.  THIS REQUIRES A CERTAIN
!     USER INTERACTION DURING THE SOLUTION OF AX = B.
!
!     SPECIFICALLY, SUPPOSE THE DATA MATRIX (A B) IS ROW PARTITIONED
!     INTO Q SUBMATRICES.  LET (E F) BE THE T-TH ONE OF THESE
!     SUBMATRICES WHERE E = (0 C 0).  HERE THE DIMENSION OF E IS MT BY N
!     AND THE DIMENSION OF C IS MT BY NB.  THE VALUE OF NB IS THE
!     BANDWIDTH OF A.  THE DIMENSIONS OF THE LEADING BLOCK OF ZEROS IN E
!     ARE MT BY JT-1.
!
!     THE USER OF THE SUBROUTINE BNDACC PROVIDES MT,JT,C AND F FOR
!     T=1,...,Q.  NOT ALL OF THIS DATA MUST BE SUPPLIED AT ONCE.
!
!     FOLLOWING THE PROCESSING OF THE VARIOUS BLOCKS (E F), THE MATRIX
!     (A B) HAS BEEN TRANSFORMED TO THE FORM (R D) WHERE R IS UPPER
!     TRIANGULAR AND BANDED WITH BANDWIDTH NB.  THE LEAST SQUARES
!     SYSTEM RX = D IS THEN EASILY SOLVED USING BACK SUBSTITUTION BY
!     EXECUTING THE STATEMENT CALL BNDSL(1,...). THE SEQUENCE OF
!     VALUES FOR JT MUST BE NONDECREASING.  THIS MAY REQUIRE SOME
!     PRELIMINARY INTERCHANGES OF ROWS AND COLUMNS OF THE MATRIX A.
!
!     THE PRIMARY REASON FOR THESE SUBROUTINES IS THAT THE TOTAL
!     PROCESSING CAN TAKE PLACE IN A WORKING ARRAY OF DIMENSION MU BY
!     NB+1.  AN ACCEPTABLE VALUE FOR MU IS
!
!                       MU = MAX(MT + N + 1),
!
!     WHERE N IS THE NUMBER OF UNKNOWNS.
!
!     HERE THE MAXIMUM IS TAKEN OVER ALL VALUES OF MT FOR T=1,...,Q.
!     NOTICE THAT MT CAN BE TAKEN TO BE A SMALL AS ONE, SHOWING THAT
!     MU CAN BE AS SMALL AS N+2.  THE SUBPROGRAM BNDACC PROCESSES THE
!     ROWS MORE EFFICIENTLY IF MU IS LARGE ENOUGH SO THAT EACH NEW
!     BLOCK (C F) HAS A DISTINCT VALUE OF JT.
!
!     THE FOUR PRINCIPLE PARTS OF THESE ALGORITHMS ARE OBTAINED BY THE
!     FOLLOWING CALL STATEMENTS
!
!     CALL BNDACC(...)  INTRODUCE NEW BLOCKS OF DATA.
!
!     CALL BNDSL(1,...)COMPUTE SOLUTION VECTOR AND LENGTH OF
!                       RESIDUAL VECTOR.
!
!     CALL BNDSL(2,...)GIVEN ANY ROW VECTOR H SOLVE YR = H FOR THE
!                       ROW VECTOR Y.
!
!     CALL BNDSL(3,...)GIVEN ANY COLUMN VECTOR W SOLVE RZ = W FOR
!                       THE COLUMN VECTOR Z.
!
!     THE DOTS IN THE ABOVE CALL STATEMENTS INDICATE ADDITIONAL
!     ARGUMENTS THAT WILL BE SPECIFIED IN THE FOLLOWING PARAGRAPHS.
!
!     THE USER MUST DIMENSION THE ARRAY APPEARING IN THE CALL LIST..
!     G(MDG,NB+1)
!
!     DESCRIPTION OF CALLING SEQUENCE FOR BNDSL..
!
!     THE USER MUST DIMENSION THE ARRAYS APPEARING IN THE CALL LIST..
!
!     G(MDG,NB+1), X(N)
!
!     THE ENTIRE SET OF PARAMETERS FOR BNDSL ARE
!
!     INPUT..
!
!     MODE              SET BY THE USER TO ONE OF THE VALUES 1, 2, OR
!                       3.  THESE VALUES RESPECTIVELY INDICATE THAT
!                       THE SOLUTION OF AX = B, YR = H OR RZ = W IS
!                       REQUIRED.
!
!     G(*,*),MDG,       THESE ARGUMENTS ALL HAVE THE SAME MEANING AND
!      NB,IP,IR         CONTENTS AS FOLLOWING THE LAST CALL TO BNDACC.
!
!     X(*)              WITH MODE=2 OR 3 THIS ARRAY CONTAINS,
!                       RESPECTIVELY, THE RIGHT-SIDE VECTORS H OR W OF
!                       THE SYSTEMS YR = H OR RZ = W.
!
!     N                 THE NUMBER OF VARIABLES IN THE SOLUTION
!                       VECTOR.  IF ANY OF THE N DIAGONAL TERMS ARE
!                       ZERO THE SUBROUTINE BNDSL PRINTS AN
!                       APPROPRIATE MESSAGE.  THIS CONDITION IS
!                       CONSIDERED AN ERROR.
!
!     OUTPUT..
!
!     X(*)              THIS ARRAY CONTAINS THE SOLUTION VECTORS X,
!                       Y OR Z OF THE SYSTEMS AX = B, YR = H OR
!                       RZ = W DEPENDING ON THE VALUE OF MODE=1,
!                       2 OR 3.
!
!     RNORM             IF MODE=1 RNORM IS THE EUCLIDEAN LENGTH OF THE
!                       RESIDUAL VECTOR AX-B.  WHEN MODE=2 OR 3 RNORM
!                       IS SET TO ZERO.
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
!                                   ALG. STEP 26
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
!                                   ALG. STEP 27
50 do ii = 1,n
   i = n + 1 - ii
!                                   ALG. STEP 28
   s = 0.0
   l = max0(0, i - ip)
!                                   ALG. STEP 29
   if (i .eq. n) go to 70
!                                   ALG. STEP 30
      ie = min0(n + 1 - i, nb)
      do j = 2,ie
         jg = j + l
         ix = i - 1 + j
         s = s + g(i,jg)*x(ix)
      end do
!                                   ALG. STEP 31
70 if (g(i,l+1) .eq. 0.0) go to 130
   x(i) = (x(i) - s)/g(i,l+1)
end do
!                                   ALG. STEP 32
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
!            A ZERO DIAGONAL TERM OCCURS
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
!            WEIGHTED LEAST SQUARES BICUBIC SPLINE FITTING
!
!                          -----------------
!
!     THE PIECEWISE POLYNOMIALS CONSIDERED ARE TENSOR PRODUCTS OF
!     B-SPLINES, HAVING THE FORM
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
!     THE ARRAYS S AND T DEFINED IN THE CODE ARE THE KNOT SEQUENCES
!     FOR THE B-SPLINES U (X) AND V (Y).
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
!     DEFINE THE KNOT SQUENCES
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
!     OBTAIN THE B-SPLINE COEFFICIENTS OF THE BIVARIATE
!     LEAST SQUARES FIT AND STORE THEM IN WK.
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
!     COMPUTE THE N CUBIC SPLINES G (X) AND THEIR FIRST
!                                  J
!     DERIVATIVES AT THE POINTS IN XBREAK. THEN STORE THE
!     DERIVATIVES IN WK. (THE VALUES OF THE SPLINES WILL
!     BE IN THE LATTER HALF OF F.)
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
!     COMPUTE THE VALUES OF THE BISPLINE AND THEIR PARTIAL
!     DERIVATIVES WITH RESPECT TO Y. THE RESULTS ARE STORED
!     IN THE FIRST HALF OF F.
!
ld = nu + 1
call cspp (t, f(l), n, n, nx, f(1), nx, f(ld), nx)
!
!     COMPUTE THE REMAINING PARTIAL DERIVATIVES AND STORE
!     THE RESULTS IN THE LATTER HALF OF F.
!
ld = l + nu
call cspp (t, wk, n, n, nx, f(l), nx, f(ld), nx)
return
!
!     ERROR RETURN
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

