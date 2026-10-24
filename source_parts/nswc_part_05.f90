SUBROUTINE CSVDC(X,LDX,N,P,S,E,U,LDU,V,LDV,WORK,JOB,INFO)
INTEGER LDX,N,P,LDU,LDV,JOB,INFO
COMPLEX X(LDX,*),S(*),E(*),U(LDU,*),V(LDV,*),WORK(*)
!
!
!     CSVDC IS A SUBROUTINE TO REDUCE A COMPLEX NXP MATRIX X BY
!     UNITARY TRANSFORMATIONS U AND V TO DIAGONAL FORM.  THE
!     DIAGONAL ELEMENTS S(I) ARE THE SINGULAR VALUES OF X.  THE
!     COLUMNS OF U ARE THE CORRESPONDING LEFT SINGULAR VECTORS,
!     AND THE COLUMNS OF V THE RIGHT SINGULAR VECTORS.
!
!     ON ENTRY
!
!         X         COMPLEX(LDX,P), WHERE LDX.GE.N.
!                   X CONTAINS THE MATRIX WHOSE SINGULAR VALUE
!                   DECOMPOSITION IS TO BE COMPUTED.  X IS
!                   DESTROYED BY CSVDC.
!
!         LDX       INTEGER.
!                   LDX IS THE LEADING DIMENSION OF THE ARRAY X.
!
!         N         INTEGER.
!                   N IS THE NUMBER OF ROWS OF THE MATRIX X.
!
!         P         INTEGER.
!                   P IS THE NUMBER OF COLUMNS OF THE MATRIX X.
!
!         LDU       INTEGER.
!                   LDU IS THE LEADING DIMENSION OF THE ARRAY U
!                   (SEE BELOW).
!
!         LDV       INTEGER.
!                   LDV IS THE LEADING DIMENSION OF THE ARRAY V
!                   (SEE BELOW).
!
!         WORK      COMPLEX(N).
!                   WORK IS A SCRATCH ARRAY.
!
!         JOB       INTEGER.
!                   JOB CONTROLS THE COMPUTATION OF THE SINGULAR
!                   VECTORS.  IT HAS THE DECIMAL EXPANSION AB
!                   WITH THE FOLLOWING MEANING
!
!                        A.EQ.0    DO NOT COMPUTE THE LEFT SINGULAR
!                                  VECTORS.
!                        A.EQ.1    RETURN THE N LEFT SINGULAR VECTORS
!                                  IN U.
!                        A.GE.2    RETURNS THE FIRST MIN(N,P)
!                                  LEFT SINGULAR VECTORS IN U.
!                        B.EQ.0    DO NOT COMPUTE THE RIGHT SINGULAR
!                                  VECTORS.
!                        B.EQ.1    RETURN THE RIGHT SINGULAR VECTORS
!                                  IN V.
!
!     ON RETURN
!
!         S         COMPLEX(MM), WHERE MM=MIN(N+1,P).
!                   THE FIRST MIN(N,P) ENTRIES OF S CONTAIN THE
!                   SINGULAR VALUES OF X ARRANGED IN DESCENDING
!                   ORDER OF MAGNITUDE.
!
!         E         COMPLEX(P).
!                   E ORDINARILY CONTAINS ZEROS.  HOWEVER SEE THE
!                   DISCUSSION OF INFO FOR EXCEPTIONS.
!
!         U         COMPLEX(LDU,K), WHERE LDU.GE.N.  IF JOBA.EQ.1 THEN
!                                   K.EQ.N, IF JOBA.GE.2 THEN
!                                   K.EQ.MIN(N,P).
!                   U CONTAINS THE MATRIX OF LEFT SINGULAR VECTORS.
!                   U IS NOT REFERENCED IF JOBA.EQ.0.  IF N.LE.P
!                   OR IF JOBA.GT.2, THEN U MAY BE IDENTIFIED WITH X
!                   IN THE SUBROUTINE CALL.
!
!         V         COMPLEX(LDV,P), WHERE LDV.GE.P.
!                   V CONTAINS THE MATRIX OF RIGHT SINGULAR VECTORS.
!                   V IS NOT REFERENCED IF JOBB.EQ.0.  IF P.LE.N,
!                   THEN V MAY BE IDENTIFIED WHTH X IN THE
!                   SUBROUTINE CALL.
!
!         INFO      INTEGER.
!                   THE SINGULAR VALUES (AND THEIR CORRESPONDING
!                   SINGULAR VECTORS) S(INFO+1),S(INFO+2),...,S(M)
!                   ARE CORRECT (HERE M=MIN(N,P)).  THUS IF
!                   INFO.EQ.0, ALL THE SINGULAR VALUES AND THEIR
!                   VECTORS ARE CORRECT.  IN ANY EVENT, THE MATRIX
!                   B = CTRANS(U)*X*V IS THE BIDIAGONAL MATRIX
!                   WITH THE ELEMENTS OF S ON ITS DIAGONAL AND THE
!                   ELEMENTS OF E ON ITS SUPER-DIAGONAL (CTRANS(U)
!                   IS THE CONJUGATE-TRANSPOSE OF U).  THUS THE
!                   SINGULAR VALUES OF X AND B ARE THE SAME.
!
!     LINPACK. THIS VERSION DATED 03/19/79 .
!     G.W. STEWART, UNIVERSITY OF MARYLAND, ARGONNE NATIONAL LAB.
!
!     CSVDC USES THE FOLLOWING FUNCTIONS AND SUBPROGRAMS.
!
!     EXTERNAL CSROT
!     BLAS CAXPY,CDOTC,CSCAL,CSWAP,SCNRM2,SROTG
!     FORTRAN ABS,AIMAG,AMAX1,CABS,CMPLX
!     FORTRAN CONJG,MAX0,MIN0,MOD,REAL,SQRT
!
!     INTERNAL VARIABLES
!
INTEGER I,ITER,J,JOBU,K,KASE,KK,L,LL,LLS,LM1,LP1,LS,LU,M,MAXIT, &
&MM,MM1,MP1,NCT,NCTP1,NCU,NRT,NRTP1
COMPLEX CDOTC,T,R
REAL B,C,CS,EL,EMM1,F,G,SCNRM2,SCALE,SHIFT,SL,SM,SN,SMM1,T1,TEST, &
&ZTEST
LOGICAL WANTU,WANTV
!
COMPLEX CSIGN,ZDUM,ZDUM1,ZDUM2
REAL CABS1
CABS1(ZDUM) = ABS(REAL(ZDUM)) + ABS(AIMAG(ZDUM))
CSIGN(ZDUM1,ZDUM2) = CABS(ZDUM1)*(ZDUM2/CABS(ZDUM2))
!
!     SET THE MAXIMUM NUMBER OF ITERATIONS.
!
MAXIT = 30
!
!     DETERMINE WHAT IS TO BE COMPUTED.
!
WANTU = .FALSE.
WANTV = .FALSE.
JOBU = MOD(JOB,100)/10
NCU = N
IF (JOBU .GT. 1) NCU = MIN0(N,P)
IF (JOBU .NE. 0) WANTU = .TRUE.
IF (MOD(JOB,10) .NE. 0) WANTV = .TRUE.
!
!     REDUCE X TO BIDIAGONAL FORM, STORING THE DIAGONAL ELEMENTS
!     IN S AND THE SUPER-DIAGONAL ELEMENTS IN E.
!
INFO = 0
NCT = MIN0(N-1,P)
NRT = MAX0(0,MIN0(P-2,N))
LU = MAX0(NCT,NRT)
IF (LU .LT. 1) GO TO 170
do 160 L = 1, LU
   LP1 = L + 1
   IF (L .GT. NCT) GO TO 20
!
!           COMPUTE THE TRANSFORMATION FOR THE L-TH COLUMN AND
!           PLACE THE L-TH DIAGONAL IN S(L).
!
      S(L) = CMPLX(SCNRM2(N-L+1,X(L,L),1),0.0E0)
      IF (CABS1(S(L)) .EQ. 0.0E0) GO TO 10
         IF (CABS1(X(L,L)) .NE. 0.0E0) S(L) = CSIGN(S(L),X(L,L))
         CALL CSCAL(N-L+1,1.0E0/S(L),X(L,L),1)
         X(L,L) = (1.0E0,0.0E0) + X(L,L)
10 CONTINUE
      S(L) = -S(L)
20 CONTINUE
   IF (P .LT. LP1) GO TO 50
   do 40 J = LP1, P
      IF (L .GT. NCT) GO TO 30
      IF (CABS1(S(L)) .EQ. 0.0E0) GO TO 30
!
!              APPLY THE TRANSFORMATION.
!
         T = -CDOTC(N-L+1,X(L,L),1,X(L,J),1)/X(L,L)
         CALL CAXPY(N-L+1,T,X(L,L),1,X(L,J),1)
30 CONTINUE
!
!           PLACE THE L-TH ROW OF X INTO  E FOR THE
!           SUBSEQUENT CALCULATION OF THE ROW TRANSFORMATION.
!
      E(J) = CONJG(X(L,J))
40 CONTINUE
50 CONTINUE
   IF (.NOT.WANTU .OR. L .GT. NCT) GO TO 70
!
!           PLACE THE TRANSFORMATION IN U FOR SUBSEQUENT BACK
!           MULTIPLICATION.
!
      DO I = L, N
         U(I,L) = X(I,L)
      END DO
70 CONTINUE
   IF (L .GT. NRT) GO TO 150
!
!           COMPUTE THE L-TH ROW TRANSFORMATION AND PLACE THE
!           L-TH SUPER-DIAGONAL IN E(L).
!
      E(L) = CMPLX(SCNRM2(P-L,E(LP1),1),0.0E0)
      IF (CABS1(E(L)) .EQ. 0.0E0) GO TO 80
         IF (CABS1(E(LP1)) .NE. 0.0E0) E(L) = CSIGN(E(L),E(LP1))
         CALL CSCAL(P-L,1.0E0/E(L),E(LP1),1)
         E(LP1) = (1.0E0,0.0E0) + E(LP1)
80 CONTINUE
      E(L) = -CONJG(E(L))
      IF (LP1 .GT. N .OR. CABS1(E(L)) .EQ. 0.0E0) GO TO 120
!
!              APPLY THE TRANSFORMATION.
!
         DO I = LP1, N
            WORK(I) = (0.0E0,0.0E0)
         END DO
         do 100 J = LP1, P
            CALL CAXPY(N-L,E(J),X(LP1,J),1,WORK(LP1),1)
100 CONTINUE
         DO J = LP1, P
            CALL CAXPY(N-L,CONJG(-E(J)/E(LP1)),WORK(LP1),1, &
&X(LP1,J),1)
         END DO
120 CONTINUE
      IF (.NOT.WANTV) GO TO 140
!
!              PLACE THE TRANSFORMATION IN V FOR SUBSEQUENT
!              BACK MULTIPLICATION.
!
         DO I = LP1, P
            V(I,L) = E(I)
         END DO
140 CONTINUE
150 CONTINUE
160 CONTINUE
170 CONTINUE
!
!     SET UP THE FINAL BIDIAGONAL MATRIX OF ORDER M.
!
M = MIN0(P,N+1)
NCTP1 = NCT + 1
NRTP1 = NRT + 1
IF (NCT .LT. P) S(NCTP1) = X(NCTP1,NCTP1)
IF (N .LT. M) S(M) = (0.0E0,0.0E0)
IF (NRTP1 .LT. M) E(NRTP1) = X(NRTP1,M)
E(M) = (0.0E0,0.0E0)
!
!     IF REQUIRED, GENERATE U.
!
IF (.NOT.WANTU) GO TO 300
   IF (NCU .LT. NCTP1) GO TO 200
   DO J = NCTP1, NCU
      DO I = 1, N
         U(I,J) = (0.0E0,0.0E0)
      END DO
      U(J,J) = (1.0E0,0.0E0)
   END DO
200 CONTINUE
   IF (NCT .LT. 1) GO TO 290
   DO LL = 1, NCT
      L = NCT - LL + 1
      IF (CABS1(S(L)) .EQ. 0.0E0) GO TO 250
         LP1 = L + 1
         IF (NCU .LT. LP1) GO TO 220
         DO J = LP1, NCU
            T = -CDOTC(N-L+1,U(L,L),1,U(L,J),1)/U(L,L)
            CALL CAXPY(N-L+1,T,U(L,L),1,U(L,J),1)
         END DO
220 CONTINUE
         CALL CSCAL(N-L+1,(-1.0E0,0.0E0),U(L,L),1)
         U(L,L) = (1.0E0,0.0E0) + U(L,L)
         LM1 = L - 1
         IF (LM1 .LT. 1) GO TO 240
         DO I = 1, LM1
            U(I,L) = (0.0E0,0.0E0)
         END DO
240 CONTINUE
      GO TO 270
250 CONTINUE
         DO I = 1, N
            U(I,L) = (0.0E0,0.0E0)
         END DO
         U(L,L) = (1.0E0,0.0E0)
270 CONTINUE
   END DO
290 CONTINUE
300 CONTINUE
!
!     IF IT IS REQUIRED, GENERATE V.
!
IF (.NOT.WANTV) GO TO 350
   DO LL = 1, P
      L = P - LL + 1
      LP1 = L + 1
      IF (L .GT. NRT) GO TO 320
      IF (CABS1(E(L)) .EQ. 0.0E0) GO TO 320
         DO J = LP1, P
            T = -CDOTC(P-L,V(LP1,L),1,V(LP1,J),1)/V(LP1,L)
            CALL CAXPY(P-L,T,V(LP1,L),1,V(LP1,J),1)
         END DO
320 CONTINUE
      DO I = 1, P
         V(I,L) = (0.0E0,0.0E0)
      END DO
      V(L,L) = (1.0E0,0.0E0)
   END DO
350 CONTINUE
!
!     TRANSFORM S AND E SO THAT THEY ARE REAL.
!
DO I = 1, M
   IF (CABS1(S(I)) .EQ. 0.0E0) GO TO 360
      T = CMPLX(CABS(S(I)),0.0E0)
      R = S(I)/T
      S(I) = T
      IF (I .LT. M) E(I) = E(I)/R
      IF (WANTU) CALL CSCAL(N,R,U(1,I),1)
360 CONTINUE
!     ...EXIT
   IF (I .EQ. M) GO TO 390
   IF (CABS1(E(I)) .EQ. 0.0E0) GO TO 370
      T = CMPLX(CABS(E(I)),0.0E0)
      R = T/E(I)
      E(I) = T
      S(I+1) = S(I+1)*R
      IF (WANTV) CALL CSCAL(P,R,V(1,I+1),1)
370 CONTINUE
END DO
390 CONTINUE
!
!     MAIN ITERATION LOOP FOR THE SINGULAR VALUES.
!
MM = M
ITER = 0
400 CONTINUE
!
!        QUIT IF ALL THE SINGULAR VALUES HAVE BEEN FOUND.
!
!     ...EXIT
   IF (M .EQ. 0) GO TO 660
!
!        IF TOO MANY ITERATIONS HAVE BEEN PERFORMED, SET
!        FLAG AND RETURN.
!
   IF (ITER .LT. MAXIT) GO TO 410
      INFO = M
!     ......EXIT
      GO TO 660
410 CONTINUE
!
!        THIS SECTION OF THE PROGRAM INSPECTS FOR
!        NEGLIGIBLE ELEMENTS IN THE S AND E ARRAYS.  ON
!        COMPLETION THE VARIABLES KASE AND L ARE SET AS FOLLOWS.
!
!           KASE = 1     IF S(M) AND E(L-1) ARE NEGLIGIBLE AND L.LT.M
!           KASE = 2     IF S(L) IS NEGLIGIBLE AND L.LT.M
!           KASE = 3     IF E(L-1) IS NEGLIGIBLE, L.LT.M, AND
!                        S(L), ..., S(M) ARE NOT NEGLIGIBLE (QR STEP).
!           KASE = 4     IF E(M-1) IS NEGLIGIBLE (CONVERGENCE).
!
   DO LL = 1, M
      L = M - LL
!        ...EXIT
      IF (L .EQ. 0) GO TO 440
      TEST = CABS(S(L)) + CABS(S(L+1))
      ZTEST = TEST + CABS(E(L))
      IF (ZTEST .NE. TEST) GO TO 420
         E(L) = (0.0E0,0.0E0)
!        ......EXIT
         GO TO 440
420 CONTINUE
   END DO
440 CONTINUE
   IF (L .NE. M - 1) GO TO 450
      KASE = 4
   GO TO 520
450 CONTINUE
      LP1 = L + 1
      MP1 = M + 1
      DO LLS = LP1, MP1
         LS = M - LLS + LP1
!           ...EXIT
         IF (LS .EQ. L) GO TO 480
         TEST = 0.0E0
         IF (LS .NE. M) TEST = TEST + CABS(E(LS))
         IF (LS .NE. L + 1) TEST = TEST + CABS(E(LS-1))
         ZTEST = TEST + CABS(S(LS))
         IF (ZTEST .NE. TEST) GO TO 460
            S(LS) = (0.0E0,0.0E0)
!           ......EXIT
            GO TO 480
460 CONTINUE
      END DO
480 CONTINUE
      IF (LS .NE. L) GO TO 490
         KASE = 3
      GO TO 510
490 CONTINUE
      IF (LS .NE. M) GO TO 500
         KASE = 1
      GO TO 510
500 CONTINUE
         KASE = 2
         L = LS
510 CONTINUE
520 CONTINUE
   L = L + 1
!
!        PERFORM THE TASK INDICATED BY KASE.
!
   GO TO (530, 560, 580, 610), KASE
!
!        DEFLATE NEGLIGIBLE S(M).
!
530 CONTINUE
      MM1 = M - 1
      F = REAL(E(M-1))
      E(M-1) = (0.0E0,0.0E0)
      DO KK = L, MM1
         K = MM1 - KK + L
         T1 = REAL(S(K))
         CALL SROTG(T1,F,CS,SN)
         S(K) = CMPLX(T1,0.0E0)
         IF (K .EQ. L) GO TO 540
            F = -SN*REAL(E(K-1))
            E(K-1) = CS*E(K-1)
540 CONTINUE
         IF (WANTV) CALL CSROT(P,V(1,K),1,V(1,M),1,CS,SN)
      END DO
   GO TO 650
!
!        SPLIT AT NEGLIGIBLE S(L).
!
560 CONTINUE
      F = REAL(E(L-1))
      E(L-1) = (0.0E0,0.0E0)
      DO K = L, M
         T1 = REAL(S(K))
         CALL SROTG(T1,F,CS,SN)
         S(K) = CMPLX(T1,0.0E0)
         F = -SN*REAL(E(K))
         E(K) = CS*E(K)
         IF (WANTU) CALL CSROT(N,U(1,K),1,U(1,L-1),1,CS,SN)
      END DO
   GO TO 650
!
!        PERFORM ONE QR STEP.
!
580 CONTINUE
!
!           CALCULATE THE SHIFT.
!
      SCALE = AMAX1(CABS(S(M)),CABS(S(M-1)),CABS(E(M-1)), &
&CABS(S(L)),CABS(E(L)))
      SM = REAL(S(M))/SCALE
      SMM1 = REAL(S(M-1))/SCALE
      EMM1 = REAL(E(M-1))/SCALE
      SL = REAL(S(L))/SCALE
      EL = REAL(E(L))/SCALE
      B = ((SMM1 + SM)*(SMM1 - SM) + EMM1**2)/2.0E0
      C = (SM*EMM1)**2
      SHIFT = 0.0E0
      IF (B .EQ. 0.0E0 .AND. C .EQ. 0.0E0) GO TO 590
         SHIFT = SQRT(B**2+C)
         IF (B .LT. 0.0E0) SHIFT = -SHIFT
         SHIFT = C/(B + SHIFT)
590 CONTINUE
      F = (SL + SM)*(SL - SM) - SHIFT
      G = SL*EL
!
!           CHASE ZEROS.
!
      MM1 = M - 1
      DO K = L, MM1
         CALL SROTG(F,G,CS,SN)
         IF (K .NE. L) E(K-1) = CMPLX(F,0.0E0)
         F = CS*REAL(S(K)) + SN*REAL(E(K))
         E(K) = CS*E(K) - SN*S(K)
         G = SN*REAL(S(K+1))
         S(K+1) = CS*S(K+1)
         IF (WANTV) CALL CSROT(P,V(1,K),1,V(1,K+1),1,CS,SN)
         CALL SROTG(F,G,CS,SN)
         S(K) = CMPLX(F,0.0E0)
         F = CS*REAL(E(K)) + SN*REAL(S(K+1))
         S(K+1) = -SN*E(K) + CS*S(K+1)
         G = SN*REAL(E(K+1))
         E(K+1) = CS*E(K+1)
         IF (WANTU .AND. K .LT. N) &
&CALL CSROT(N,U(1,K),1,U(1,K+1),1,CS,SN)
      END DO
      E(M-1) = CMPLX(F,0.0E0)
      ITER = ITER + 1
   GO TO 650
!
!        CONVERGENCE.
!
610 CONTINUE
!
!           MAKE THE SINGULAR VALUE  POSITIVE
!
      IF (REAL(S(L)) .GE. 0.0E0) GO TO 620
         S(L) = -S(L)
         IF (WANTV) CALL CSCAL(P,(-1.0E0,0.0E0),V(1,L),1)
620 CONTINUE
!
!           ORDER THE SINGULAR VALUE.
!
630 IF (L .EQ. MM) GO TO 640
!           ...EXIT
         IF (REAL(S(L)) .GE. REAL(S(L+1))) GO TO 640
         T = S(L)
         S(L) = S(L+1)
         S(L+1) = T
         IF (WANTV .AND. L .LT. P) &
&CALL CSWAP(P,V(1,L),1,V(1,L+1),1)
         IF (WANTU .AND. L .LT. N) &
&CALL CSWAP(N,U(1,L),1,U(1,L+1),1)
         L = L + 1
      GO TO 630
640 CONTINUE
      ITER = 0
      M = M - 1
650 CONTINUE
GO TO 400
660 CONTINUE
RETURN
END SUBROUTINE CSVDC

FUNCTION DET(A,KA,N,X)
!     -------------------
!     EVALUATION OF THE DETERMINANT OF A-XI WHERE A IS AN NXN MATRIX,
!     X IS A SCALAR, AND I IS THE NXN IDENTITY MATRIX.
!     -------------------
!     KA IS THE ROW DIMENSION OF A IN THE CALLING PROGRAM. IT IS
!     ASSUMED THAT KA IS GREATER THAN OR EQUAL TO N.
!     -------------------
DIMENSION A(KA,N)
IF (N .GE. 2) GO TO 10
DET = A(1,1)-X
RETURN
!
!              REPLACE A WITH A-XI
!
10 IF (X .EQ. 0.0) GO TO 20
do 11 K = 1,N
11 A(K,K) = A(K,K)-X
!
!                INITIALIZATION
!
20 DET = 1.0
NM1 = N-1
DO K=1,NM1
KP1 = K+1
!
!       SEARCH FOR THE K-TH PIVOT ELEMENT
!
S = ABS(A(K,K))
L = K
do 30 I = KP1,N
C = ABS(A(I,K))
IF (S .GE. C) GO TO 30
S = C
L = I
30 CONTINUE
PIVOT = A(L,K)
!
!         UPDATE THE CALCULATION OF DET
!
DET = DET*PIVOT
IF (DET .EQ. 0.0) RETURN
IF (K .EQ. L) GO TO 50
DET = -DET
!
!          INTERCHANGING ROWS K AND L
!
do 40 J = K,N
C = A(K,J)
A(K,J) = A(L,J)
40 A(L,J) = C
!
!        REDUCTION OF THE NON-PIVOT ROWS
!
50 do 51 I = KP1,N
C = A(I,K)/PIVOT
do 51 J = KP1,N
51 A(I,J) = A(I,J)-C*A(K,J)
END DO
!
!         FINAL DETERMINANT CALCULATION
!
DET = DET*A(N,N)
RETURN
END FUNCTION DET

double precision function DPDET(A,KA,N,X)
!     -------------------
!     EVALUATION OF THE DETERMINANT OF A-XI WHERE A IS AN NXN MATRIX,
!     X IS A SCALAR, AND I IS THE NXN IDENTITY MATRIX.
!     -------------------
!     KA IS THE ROW DIMENSION OF A IN THE CALLING PROGRAM. IT IS
!     ASSUMED THAT KA IS GREATER THAN OR EQUAL TO N.
!     -------------------
DOUBLE PRECISION A(KA,N),X
DOUBLE PRECISION PIVOT,S,C
IF (N .GE. 2) GO TO 10
DPDET = A(1,1) - X
RETURN
!
!              REPLACE A WITH A-XI
!
10 IF (X .EQ. 0.D0) GO TO 20
do 11 K = 1,N
11 A(K,K) = A(K,K) - X
!
!                INITIALIZATION
!
20 DPDET = 1.D0
NM1 = N - 1
DO K=1,NM1
KP1 = K + 1
!
!       SEARCH FOR THE K-TH PIVOT ELEMENT
!
S = DABS(A(K,K))
L = K
do 30 I = KP1,N
C = DABS(A(I,K))
IF (S .GE. C) GO TO 30
S = C
L = I
30 CONTINUE
PIVOT = A(L,K)
!
!         UPDATE THE CALCULATION OF DET
!
DPDET = DPDET*PIVOT
IF (DPDET .EQ. 0.D0) RETURN
IF (K .EQ. L) GO TO 50
DPDET = -DPDET
!
!          INTERCHANGING ROWS K AND L
!
do 40 J = K,N
C = A(K,J)
A(K,J) = A(L,J)
40 A(L,J) = C
!
!        REDUCTION OF THE NON-PIVOT ROWS
!
50 do 51 I = KP1,N
C = A(I,K)/PIVOT
do 51 J = KP1,N
51 A(I,J) = A(I,J) - C*A(K,J)
END DO
!
!         FINAL DETERMINANT CALCULATION
!
DPDET = DPDET*A(N,N)
RETURN
END FUNCTION DPDET

COMPLEX function CDET(A,KA,N,X)
!     -------------------
!     EVALUATION OF THE DETERMINANT OF A-XI WHERE A IS AN NXN MATRIX,
!     X IS A SCALAR, AND I IS THE NXN IDENTITY MATRIX.
!     -------------------
!     KA IS THE ROW DIMENSION OF A IN THE CALLING PROGRAM. IT IS
!     ASSUMED THAT KA IS GREATER THAN OR EQUAL TO N.
!     -------------------
COMPLEX A(KA,N),X
COMPLEX PIVOT,T,ZERO
REAL S,C
DATA ZERO/(0.0,0.0)/
!
IF (N .GE. 2) GO TO 10
CDET = A(1,1)-X
RETURN
!
!              REPLACE A WITH A-XI
!
10 IF (X .EQ. ZERO) GO TO 20
do 11 K = 1,N
11 A(K,K) = A(K,K)-X
!
!                INITIALIZATION
!
20 CDET = (1.0,0.0)
NM1 = N-1
DO K=1,NM1
KP1 = K+1
!
!       SEARCH FOR THE K-TH PIVOT ELEMENT
!
S = ABS(REAL(A(K,K))) + ABS(AIMAG(A(K,K)))
L = K
do 30 I = KP1,N
C = ABS(REAL(A(I,K))) + ABS(AIMAG(A(I,K)))
IF (S .GE. C) GO TO 30
S = C
L = I
30 CONTINUE
PIVOT = A(L,K)
!
!         UPDATE THE CALCULATION OF CDET
!
CDET = CDET*PIVOT
IF (CDET .EQ. ZERO) RETURN
IF (K .EQ. L) GO TO 50
CDET = -CDET
!
!          INTERCHANGING ROWS K AND L
!
do 40 J = K,N
T = A(K,J)
A(K,J) = A(L,J)
40 A(L,J) = T
!
!        REDUCTION OF THE NON-PIVOT ROWS
!
50 do 51 I = KP1,N
T = A(I,K)/PIVOT
do 51 J = KP1,N
51 A(I,J) = A(I,J)-T*A(K,J)
END DO
!
!         FINAL DETERMINANT CALCULATION
!
CDET = CDET*A(N,N)
RETURN
END FUNCTION CDET

SUBROUTINE ABSLV (MO,M,N,A,NA,B,NB,C,NC,WK,IERR)
REAL A(NA,M), B(NB,N), C(NC,N), WK(*)
! ----------------------------------------------------------------------
!     ABSLV SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
!     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
!     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
! ----------------------------------------------------------------------
!        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
!     WE HAVE THE FOLLOWING SETUP.
!
!        A(NA,M)
!           A IS A MATRIX OF ORDER M. IT IS ASSUMED THAT
!           NA .GE. M .GE. 1.
!
!        B(NB,N)
!           B IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
!           NB .GE. N .GE. 1.
!
!        C(NC,N)
!           C IS A MATRIX HAVING M ROWS AND N COLUMNS.
!           IT IS ASSUMED THAT NC .GE. M.
!
!        WK(---)
!           WK IS AN ARRAY OF DIMENSION M**2  + N**2 + 2K
!           WHERE K = MAX(M,N). WK IS A GENERAL STORAGE
!           AREA FOR THE ROUTINE.
!
!     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
!     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
!
!        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
!        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A AND B.
!                   THE PROBLEM CANNOT BE SOLVED.
!        IERR = -1  A COULD NOT BE REDUCED TO LOWER SCHUR FORM.
!                   THE PROBLEM CANNOT BE SOLVED.
!        IERR = -2  B COULD NOT BE REDUCED TO UPPER SCHUR FORM.
!                   THE PROBLEM CANNOT BE SOLVED.
!
!     WHEN IERR = 0, A CONTAINS THE LOWER SCHUR FORM OF THE MATRIX A,
!     B CONTAINS THE UPPER SCHUR FORM OF THE MATRIX B, AND WK CONTAINS
!     THE ORTHONAL MATRICES INVOLVED IN THE SCHUR DECOMPOSITIONS OF
!     A AND B. THIS INFORMATION CAN BE REUSED TO SOLVE A NEW SET OF
!     EQUATIONS AX + XB = C WITHOUT HAVING TO REDECOMPOSE A AND B.
!     THE FOLLOWING OPTIONS ARE AVAILABLE...
!
!        MO = 1      NEW MATRICES A AND C ARE GIVEN. THE DATA FOR B
!                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
!
!        MO = 2      NEW MATRICES B AND C ARE GIVEN. THE DATA FOR A
!                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
!
!     MO .NE. 0,1,2  A NEW MATRIX C IS GIVEN. THE DATA FOR A AND B
!                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
!
!     WHEN ABSLV IS RECALLED, IT IS ASSUMED THAT M, N, AND WK HAVE
!     NOT BEEN MODIFIED.
! ----------------------------------------------------------------------
!     THIS SUBROUTINE IS A MODIFICATION BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN, VIRGINIA
!     OF THE SUBROUTINE AXPXB WRITTEN BY
!        R.H. BARTELS AND G.W.STEWART
!        UNIVERSITY OF TEXAS AT AUSTIN.
!
!     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
IU = 1
IV = M*M + 1
IW = N*N + IV
CALL ABSLV1 (MO,M,N,A,NA,WK(IU),M,B,NB,WK(IV),N, &
&C,NC,WK(IW),IERR)
RETURN
END SUBROUTINE ABSLV

SUBROUTINE ABSLV1 (MO,M,N,A,NA,U,NU,B,NB,V,NV,C,NC,WK,IERR)
! ----------------------------------------------------------------------
!     ABSLV1 SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
!     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
!     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
! ----------------------------------------------------------------------
REAL A(NA,M), B(NB,N), C(NC,N)
REAL U(NU,M), V(NV,N), TEMP, WK(*)
!
!     IF REQUIRED, REDUCE A TO LOWER REAL SCHUR FORM
!
IF (MO .NE. 0 .AND. MO .NE. 1) GO TO 35
DO I = 1,M
   DO J = I,M
      TEMP = A(I,J)
      A(I,J) = A(J,I)
      A(J,I) = TEMP
   END DO
END DO
CALL ORTHES (NA,M,1,M,A,WK)
CALL ORTRN1 (M,1,M,A,NA,U,NU,WK)
!
IF (M .EQ. 1) GO TO 20
CALL SCHUR (M,1,M,A,NA,U,NU,WK(1),WK(M+1),IERR)
IF (IERR .NE. 0) GO TO 200
!
20 DO I = 1,M
   DO J = I,M
      TEMP = A(I,J)
      A(I,J) = A(J,I)
      A(J,I) = TEMP
   END DO
END DO
!
!     IF REQUIRED, REDUCE B TO UPPER REAL SCHUR FORM
!
35 IF (MO .NE. 0 .AND. MO .NE. 2) GO TO 45
CALL ORTHES (NB,N,1,N,B,WK)
CALL ORTRN1 (N,1,N,B,NB,V,NV,WK)
!
IF (N .EQ. 1) GO TO 45
CALL SCHUR (N,1,N,B,NB,V,NV,WK(1),WK(N+1),IERR)
IF (IERR .NE. 0) GO TO 210
!
!     TRANSFORM C
!
45 DO J = 1,N
   DO I = 1,M
      WK(I) = 0.0
      DO K = 1,M
         WK(I) = WK(I) + U(K,I)*C(K,J)
      END DO
   END DO
   DO I = 1,M
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,M
   DO J = 1,N
      WK(J) = 0.0
      DO K = 1,N
         WK(J) = WK(J) + C(I,K)*V(K,J)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
!
!     SOLVE THE TRANSFORMED SYSTEM
!
CALL SHRSLV (A,B,C,M,N,NA,NB,NC,IERR)
IF (IERR .NE. 0) GO TO 220
!
!     TRANSFORM C BACK TO THE SOLUTION
!
DO J = 1,N
   DO I = 1,M
      WK(I) = 0.0
      DO K = 1,M
         WK(I) = WK(I) + U(I,K)*C(K,J)
      END DO
   END DO
   DO I = 1,M
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,M
   DO J = 1,N
      WK(J) = 0.0
      DO K = 1,N
         WK(J) = WK(J) + C(I,K)*V(J,K)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = -1
RETURN
210 IERR = -2
RETURN
220 IERR = 1
RETURN
END SUBROUTINE ABSLV1

SUBROUTINE SCHUR (N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR)
! ----------------------------------------------------------------------
!     IT IS ASSUMED THAT H IS AN UPPER HESSENBERG MATRIX. SCHUR
!     OBTAINS AN ORTHOGONAL MATRIX Q FOR WHICH TRANSPOSE(Q)*H*Q
!     IS IN SCHUR FORM. THE EIGENVALUES OF H ARE ALSO COMPUTED.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
!          SET LOW=1, IGH=N, (BALANC IS AN EISPACK SUBROUTINE).
!
!        H CONTAINS THE UPPER HESSENBERG MATRIX,
!
!        NH IS THE FIRST DIMENSION OF H,
!
!        Z CONTAINS A MATRIX OF ORDER N,
!
!        NZ IS THE FIRST DIMENSION OF Z.
!
!     ON OUTPUT-
!
!        H CONTAINS THE TRANSFORMED MATRIX IN UPPER SCHUR FORM,
!
!        Z CONTAINS THE MATRIX Z*Q WHERE Q IS THE ORTHOGONAL
!          MATRIX WHICH REDUCES H TO UPPER SCHUR FORM,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
!          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
!          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
!          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N.
!
!        IERR IS SET TO
!          0          FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 30 ITERATIONS.
!
! -----------------
!     WRITTEN BY JACK DONGARRA
!          ARGONNE NATIONAL LABORATORY
!          MAY 1961
!     MODIFIED BY A.H. MORRIS (NSWC)
! ----------------------------------------------------------------------
!     THIS SUBROUTINE IS A MODIFICATION OF THE EISPACK SUBROUTINE
!     HQR2,  WHICH IS BASED ON THE ALGOL PROCEDURE HQR BY PETERS
!     AND WILKINSON, NUM. MATH. 16 (1970), PP.181-204.
! ----------------------------------------------------------------------
INTEGER I, J, K, L, M, N, EN, LL, MM, NA, NH, NZ, IGH, ITS, LOW, &
&MP2, ENM2, IERR
REAL H(NH,N), WR(N), WI(N), Z(NZ,N)
REAL P, Q, R, S, T, W, X, Y, ZZ, NORM, S1, S2
LOGICAL NOTLAS
!     REAL SQRT, ABS
!     INTEGER MIN0
!
IERR = 0
NORM = 0.0
K = 1
!     ********** STORE ROOTS ISOLATED BY BALANC
!                AND COMPUTE MATRIX NORM **********
do 20 I = 1,N
!
  do 10 J = K,N
    NORM = NORM + ABS(H(I,J))
10 CONTINUE
!
  K = I
  IF (I .GE. LOW .AND. I .LE. IGH) GO TO 20
  WR(I) = H(I,I)
  WI(I) = 0.0
20 CONTINUE
!
EN = IGH
T = 0.0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
30 IF (EN .LT. LOW) GO TO 300
ITS = 0
NA = EN - 1
ENM2 = NA - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
40 DO LL = LOW,EN
  L = EN + LOW - LL
  IF (L .EQ. LOW) GO TO 60
  S = ABS(H(L-1,L-1)) + ABS(H(L,L))
  IF (S .EQ. 0.0) S = NORM
  S1 = S
  S2 = S1 + ABS(H(L,L-1))
  IF (S1 .EQ. S2) GO TO 60
END DO
!     ********** FORM SHIFT **********
60 X = H(EN,EN)
IF (L .EQ. EN) GO TO 220
Y = H(NA,NA)
W = H(EN,NA)*H(NA,EN)
IF (L .EQ.NA) GO TO 230
IF (ITS .EQ. 30) GO TO 290
IF (ITS .NE. 10 .AND. ITS .NE. 20) GO TO 80
!     ********** FORM EXCEPTIONAL SHIFT **********
T = T + X
!
DO I = LOW,EN
  H(I,I) = H(I,I) - X
END DO
!
S = ABS(H(EN,NA)) + ABS(H(NA,ENM2))
X = 0.75*S
Y = X
W = -0.4375*S*S
80 ITS = ITS + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                SUB-DIAGONAL ELEMENTS.
!                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
DO MM = L,ENM2
  M = ENM2 + L - MM
  ZZ = H(M,M)
  R = X - ZZ
  S = Y - ZZ
  P = (R*S-W)/H(M+1,M) + H(M,M+1)
  Q = H(M+1,M+1) - ZZ - R - S
  R = H(M+2,M+1)
  S = ABS(P) + ABS(Q) + ABS(R)
  P = P/S
  Q = Q/S
  R = R/S
  IF (M .EQ. L) GO TO 100
  S1 = ABS(P)*(ABS(H(M-1,M-1))+ABS(ZZ)+ABS(H(M+1,M+1)))
  S2 = S1 + ABS(H(M,M-1))*(ABS(Q) + ABS(R))
  IF (S1 .EQ. S2) GO TO 100
END DO
!
100 MP2 = M + 2
!
do 110 I = MP2,EN
  H(I,I-2) = 0.0
  IF (I .EQ. MP2) GO TO 110
  H(I,I-3) = 0.0
110 CONTINUE
!     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
!                COLUMNS M TO EN **********
do 210 K = M,NA
  NOTLAS = K.NE.NA
  IF (K .EQ. M) GO TO 120
  P = H(K,K-1)
  Q = H(K+1,K-1)
  R = 0.0
  IF (NOTLAS) R = H(K+2,K-1)
  X = ABS(P) + ABS(Q) + ABS(R)
  IF (X .EQ. 0.0) GO TO 210
  P = P/X
  Q = Q/X
  R = R/X
120 S = SQRT(P*P + Q*Q + R*R)
  IF (P .LT. 0.0) S = -S
  IF (K .EQ. M) GO TO 130
  H(K,K-1) = -S*X
  GO TO 140
130 IF (L .NE. M) H(K,K-1) = -H(K,K-1)
140 P = P + S
  X = P/S
  Y = Q/S
  ZZ = R/S
  Q = Q/P
  R = R/P
!     ********** ROW MODIFICATION **********
  DO J = K,N
    P = H(K,J) + Q*H(K+1,J)
    IF (.NOT.NOTLAS) GO TO 150
    P = P + R*H(K+2,J)
    H(K+2,J) = H(K+2,J) - P*ZZ
150 H(K+1,J) = H(K+1,J) - P*Y
    H(K,J) = H(K,J) - P*X
  END DO
!
  J = MIN0(EN,K+3)
!     ********** COLUMN MODIFICATION **********
  DO I = 1,J
    P = X*H(I,K) + Y*H(I,K+1)
    IF (.NOT.NOTLAS) GO TO 170
    P = P + ZZ*H(I,K+2)
    H(I,K+2) = H(I,K+2) - P*R
170 H(I,K+1) = H(I,K+1) - P*Q
    H(I,K) = H(I,K) - P
  END DO
!     ********** ACCUMULATE TRANSFORMATIONS **********
  DO I = LOW,IGH
    P = X*Z(I,K) + Y*Z(I,K+1)
    IF (.NOT.NOTLAS) GO TO 190
    P = P + ZZ*Z(I,K+2)
    Z(I,K+2) = Z(I,K+2) - P*R
190 Z(I,K+1) = Z(I,K+1) - P*Q
    Z(I,K) = Z(I,K) - P
  END DO
!
210 CONTINUE
!
GO TO 40
!     ********** ONE ROOT FOUND **********
220 H(EN,EN) = X + T
WR(EN) = H(EN,EN)
WI(EN) = 0.0
EN = NA
GO TO 30
!     ********** TWO ROOTS FOUND **********
230 P = (Y - X)/2.0
Q = P*P + W
ZZ = SQRT(ABS(Q))
H(EN,EN) = X + T
X = H(EN,EN)
H(NA,NA) = Y + T
IF (Q .LT. 0.0) GO TO 270
!     ********** REAL PAIR **********
IF (P .LT. 0.0) ZZ = -ZZ
ZZ = P + ZZ
WR(NA) = X + ZZ
WR(EN) = WR(NA)
IF (ZZ .NE. 0.0) WR(EN) = X - W/ZZ
WI(NA) = 0.0
WI(EN) = 0.0
X = H(EN,NA)
S = ABS(X) + ABS(ZZ)
P = X/S
Q = ZZ/S
R = SQRT(P*P + Q*Q)
P = P/R
Q = Q/R
!     ********** ROW MODIFICATION **********
DO J = NA,N
  ZZ = H(NA,J)
  H(NA,J) = Q*ZZ + P*H(EN,J)
  H(EN,J) = Q*H(EN,J) - P*ZZ
END DO
!     ********** COLUMN MODIFICATION **********
DO I = 1,EN
  ZZ = H(I,NA)
  H(I,NA) = Q*ZZ + P*H(I,EN)
  H(I,EN) = Q*H(I,EN) - P*ZZ
END DO
!     ********** ACCUMULATE TRANSFORMATIONS **********
DO I = LOW,IGH
  ZZ = Z(I,NA)
  Z(I,NA) = Q*ZZ + P*Z(I,EN)
  Z(I,EN) = Q*Z(I,EN) - P*ZZ
END DO
!
GO TO 280
!     ********** COMPLEX PAIR **********
270 WR(NA) = X + P
WR(EN) = X + P
WI(NA) = ZZ
WI(EN) = -ZZ
280 EN = ENM2
GO TO 30
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 30 ITERATIONS **********
290 IERR = EN
RETURN
300 do 320 I = 1,N
  IP1 = I + 1
  IF (ABS(WI(I)) .NE. 0.0) IP1 = IP1 + 1
  IF (IP1 .GT. N) GO TO 320
  DO J = IP1,N
    H(J,I) = 0.0
  END DO
320 CONTINUE
RETURN
END SUBROUTINE SCHUR

SUBROUTINE SHRSLV (A,B,C,M,N,NA,NB,NC,IERR)
!     ------------------------------------------------------------------
!     SHRSLV SOLVES THE MATRIX EQUATION AX + XB = C WHERE
!     A IS IN LOWER SCHUR FORM AND B IN UPPER SCHUR FORM.
!     ------------------------------------------------------------------
INTEGER M,N,NA,NB,NC,IERR
REAL A(NA,M), B(NB,N), C(NC,N)
REAL SUM, P(4), T(4,4)
INTEGER DK,DL,I,IB,J,JA,K,KM1,KK,L,LM1,LL
!
L = 1
10 LM1 = L - 1
   DL = 1
   IF (L .EQ. N) GO TO 15
   IF (B(L+1,L) .NE. 0.0) DL = 2
15 LL = L + DL - 1
   IF (L .EQ. 1) GO TO 30
!
   DO J = L,LL
      do 21 I = 1,M
      SUM = C(I,J)
         do 20 IB = 1,LM1
20 SUM = SUM - C(I,IB)*B(IB,J)
21 C(I,J) = SUM
   END DO
!
30 K = 1
40 KM1 = K - 1
      DK = 1
      IF (K .EQ. M) GO TO 45
      IF (A(K,K+1) .NE. 0.0) DK = 2
45 KK = K + DK - 1
      IF (K .EQ. 1) GO TO 60
!
      DO I = K,KK
         do 51 J = L,LL
         SUM = C(I,J)
            do 50 JA = 1,KM1
50 SUM = SUM - A(I,JA)*C(JA,J)
51 C(I,J) = SUM
      END DO
!
60 IF (DL .EQ. 2) GO TO 80
      IF (DK .EQ. 2) GO TO 70
      T(1,1) = A(K,K) + B(L,L)
      IF (T(1,1) .EQ. 0.0) GO TO 200
      C(K,L) = C(K,L)/T(1,1)
      IERR = 0
      GO TO 100
!
70 T(1,1) = A(K,K) + B(L,L)
      T(1,2) = A(K,KK)
      T(2,1) = A(KK,K)
      T(2,2) = A(KK,KK) + B(L,L)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      CALL SLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      GO TO 100
!
80 IF (DK .EQ. 2) GO TO 90
      T(1,1) = A(K,K) + B(L,L)
      T(1,2) = B(LL,L)
      T(2,1) = B(L,LL)
      T(2,2) = A(K,K) + B(LL,LL)
      P(1) = C(K,L)
      P(2) = C(K,LL)
      CALL SLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(K,LL) = P(2)
      GO TO 100
!
90 T(1,1) = A(K,K) + B(L,L)
      T(1,2) = A(K,KK)
      T(1,3) = B(LL,L)
      T(1,4) = 0.0
      T(2,1) = A(KK,K)
      T(2,2) = A(KK,KK) + B(L,L)
      T(2,3) = 0.0
      T(2,4) = T(1,3)
      T(3,1) = B(L,LL)
      T(3,2) = 0.0
      T(3,3) = A(K,K) + B(LL,LL)
      T(3,4) = T(1,2)
      T(4,1) = 0.0
      T(4,2) = T(3,1)
      T(4,3) = T(2,1)
      T(4,4) = A(KK,KK) + B(LL,LL)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      P(3) = C(K,LL)
      P(4) = C(KK,LL)
      CALL SLV (4, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      C(K,LL) = P(3)
      C(KK,LL) = P(4)
!
100 K = K + DK
   IF (K .LE. M) GO TO 40
L = L + DL
IF (L .LE. N) GO TO 10
RETURN
!
!     ERROR RETURN
!
200 IERR = 1
RETURN
END SUBROUTINE SHRSLV

SUBROUTINE DABSLV (MO,M,N,A,NA,B,NB,C,NC,WK,IERR)
DOUBLE PRECISION A(NA,M), B(NB,N), C(NC,N), WK(*)
! ----------------------------------------------------------------------
!     DABSLV SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
!     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
!     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
! ----------------------------------------------------------------------
!        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
!     WE HAVE THE FOLLOWING SETUP.
!
!        A(NA,M)
!           A IS A MATRIX OF ORDER M. IT IS ASSUMED THAT
!           NA .GE. M .GE. 1.
!
!        B(NB,N)
!           B IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
!           NB .GE. N .GE. 1.
!
!        C(NC,N)
!           C IS A MATRIX HAVING M ROWS AND N COLUMNS.
!           IT IS ASSUMED THAT NC .GE. M.
!
!        WK(---)
!           WK IS AN ARRAY OF DIMENSION M**2  + N**2 + 2K
!           WHERE K = MAX(M,N). WK IS A GENERAL STORAGE
!           AREA FOR THE ROUTINE.
!
!     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
!     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
!
!        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
!        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A AND B.
!                   THE PROBLEM CANNOT BE SOLVED.
!        IERR = -1  A COULD NOT BE REDUCED TO LOWER SCHUR FORM.
!                   THE PROBLEM CANNOT BE SOLVED.
!        IERR = -2  B COULD NOT BE REDUCED TO UPPER SCHUR FORM.
!                   THE PROBLEM CANNOT BE SOLVED.
!
!     WHEN IERR = 0, A CONTAINS THE LOWER SCHUR FORM OF THE MATRIX A,
!     B CONTAINS THE UPPER SCHUR FORM OF THE MATRIX B, AND WK CONTAINS
!     THE ORTHONAL MATRICES INVOLVED IN THE SCHUR DECOMPOSITIONS OF
!     A AND B. THIS INFORMATION CAN BE REUSED TO SOLVE A NEW SET OF
!     EQUATIONS AX + XB = C WITHOUT HAVING TO REDECOMPOSE A AND B.
!     THE FOLLOWING OPTIONS ARE AVAILABLE...
!
!        MO = 1      NEW MATRICES A AND C ARE GIVEN. THE DATA FOR B
!                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
!
!        MO = 2      NEW MATRICES B AND C ARE GIVEN. THE DATA FOR A
!                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
!
!     MO .NE. 0,1,2  A NEW MATRIX C IS GIVEN. THE DATA FOR A AND B
!                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
!
!     WHEN DABSLV IS RECALLED, IT IS ASSUMED THAT M, N, AND WK HAVE
!     NOT BEEN MODIFIED.
! ----------------------------------------------------------------------
!     THIS SUBROUTINE IS A MODIFICATION BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN, VIRGINIA
!     OF THE SUBROUTINE AXPXB WRITTEN BY
!        R.H. BARTELS AND G.W.STEWART
!        UNIVERSITY OF TEXAS AT AUSTIN.
!
!     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
IU = 1
IV = M*M + 1
IW = N*N + IV
CALL DABSV1 (MO,M,N,A,NA,WK(IU),M,B,NB,WK(IV),N, &
&C,NC,WK(IW),IERR)
RETURN
END SUBROUTINE DABSLV

SUBROUTINE DABSV1 (MO,M,N,A,NA,U,NU,B,NB,V,NV,C,NC,WK,IERR)
! ----------------------------------------------------------------------
!     DABSV1 SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
!     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
!     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
! ----------------------------------------------------------------------
DOUBLE PRECISION A(NA,M), B(NB,N), C(NC,N)
DOUBLE PRECISION U(NU,M), V(NV,N), TEMP, WK(*)
!
!     IF REQUIRED, REDUCE A TO LOWER REAL SCHUR FORM
!
IF (MO .NE. 0 .AND. MO .NE. 1) GO TO 35
DO I = 1,M
   DO J = I,M
      TEMP = A(I,J)
      A(I,J) = A(J,I)
      A(J,I) = TEMP
   END DO
END DO
CALL DORTH (NA,M,1,M,A,WK)
CALL DRTRN1 (M,1,M,A,NA,U,NU,WK)
!
IF (M .EQ. 1) GO TO 20
CALL DSCHUR (M,1,M,A,NA,U,NU,WK(1),WK(M+1),IERR)
IF (IERR .NE. 0) GO TO 200
!
20 DO I = 1,M
   DO J = I,M
      TEMP = A(I,J)
      A(I,J) = A(J,I)
      A(J,I) = TEMP
   END DO
END DO
!
!     IF REQUIRED, REDUCE B TO UPPER REAL SCHUR FORM
!
35 IF (MO .NE. 0 .AND. MO .NE. 2) GO TO 45
CALL DORTH (NB,N,1,N,B,WK)
CALL DRTRN1 (N,1,N,B,NB,V,NV,WK)
!
IF (N .EQ. 1) GO TO 45
CALL DSCHUR (N,1,N,B,NB,V,NV,WK(1),WK(N+1),IERR)
IF (IERR .NE. 0) GO TO 210
!
!     TRANSFORM C
!
45 DO J = 1,N
   DO I = 1,M
      WK(I) = 0.D0
      DO K = 1,M
         WK(I) = WK(I) + U(K,I)*C(K,J)
      END DO
   END DO
   DO I = 1,M
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,M
   DO J = 1,N
      WK(J) = 0.D0
      DO K = 1,N
         WK(J) = WK(J) + C(I,K)*V(K,J)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
!
!     SOLVE THE TRANSFORMED SYSTEM
!
CALL DSHSLV (A,B,C,M,N,NA,NB,NC,IERR)
IF (IERR .NE. 0) GO TO 220
!
!     TRANSFORM C BACK TO THE SOLUTION
!
DO J = 1,N
   DO I = 1,M
      WK(I) = 0.D0
      DO K = 1,M
         WK(I) = WK(I) + U(I,K)*C(K,J)
      END DO
   END DO
   DO I = 1,M
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,M
   DO J = 1,N
      WK(J) = 0.D0
      DO K = 1,N
         WK(J) = WK(J) + C(I,K)*V(J,K)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = -1
RETURN
210 IERR = -2
RETURN
220 IERR = 1
RETURN
END SUBROUTINE DABSV1

SUBROUTINE DSCHUR (N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR)
! ----------------------------------------------------------------------
!     IT IS ASSUMED THAT H IS AN UPPER HESSENBERG MATRIX. DSCHUR
!     OBTAINS AN ORTHOGONAL MATRIX Q FOR WHICH  TRANSPOSE(Q)*H*Q
!     IS IN SCHUR FORM. THE EIGENVALUES OF H ARE ALSO COMPUTED.
!
!     ON INPUT-
!
!        N IS THE ORDER OF THE MATRIX,
!
!        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
!          SUBROUTINE DBAL.  IF  DBAL  HAS NOT BEEN USED, SET
!          LOW = 1, IGH = N.
!
!        H CONTAINS THE UPPER HESSENBERG MATRIX,
!
!        NH IS THE FIRST DIMENSION OF H,
!
!        Z CONTAINS A MATRIX OF ORDER N,
!
!        NZ IS THE FIRST DIMENSION OF Z.
!
!     ON OUTPUT-
!
!        H CONTAINS THE TRANSFORMED MATRIX IN UPPER SCHUR FORM,
!
!        Z CONTAINS THE MATRIX Z*Q WHERE Q IS THE ORTHOGONAL
!          MATRIX WHICH REDUCES H TO UPPER SCHUR FORM,
!
!        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
!          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
!          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
!          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
!          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
!          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
!          FOR INDICES IERR+1,...,N.
!
!        IERR IS SET TO
!          0          FOR NORMAL RETURN,
!          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
!                     DETERMINED AFTER 50 ITERATIONS.
!
! -----------------
!     WRITTEN BY JACK DONGARRA
!          ARGONNE NATIONAL LABORATORY
!          MAY 1961
!     MODIFIED BY A.H. MORRIS (NSWC)
! ----------------------------------------------------------------------
!     THIS SUBROUTINE IS A MODIFICATION OF THE EISPACK SUBROUTINE
!     HQR2,  WHICH IS BASED ON THE ALGOL PROCEDURE HQR BY PETERS
!     AND WILKINSON, NUM. MATH. 16 (1970), PP.181-204.
! ----------------------------------------------------------------------
INTEGER I, J, K, L, M, N, EN, LL, MM, NA, NH, NZ, IGH, ITS, LOW, &
&MP2, ENM2, IERR
DOUBLE PRECISION H(NH,N), WR(N), WI(N), Z(NZ,N)
DOUBLE PRECISION P, Q, R, S, T, W, X, Y, ZZ, NORM, S1, S2
LOGICAL NOTLAS
!     DOUBLE PRECISION DSQRT, DABS
!     INTEGER MIN0
!
IERR = 0
NORM = 0.D0
K = 1
!     ********** STORE ROOTS ISOLATED BY BALANC
!                AND COMPUTE MATRIX NORM **********
do 20 I = 1,N
!
  do 10 J = K,N
    NORM = NORM + DABS(H(I,J))
10 CONTINUE
!
  K = I
  IF (I .GE. LOW .AND. I .LE. IGH) GO TO 20
  WR(I) = H(I,I)
  WI(I) = 0.D0
20 CONTINUE
!
EN = IGH
T = 0.D0
!     ********** SEARCH FOR NEXT EIGENVALUES **********
30 IF (EN .LT. LOW) GO TO 300
ITS = 0
NA = EN - 1
ENM2 = NA - 1
!     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
!                FOR L=EN STEP -1 UNTIL LOW DO -- **********
40 do 50 LL = LOW,EN
  L = EN + LOW - LL
  IF (L .EQ. LOW) GO TO 60
  S = DABS(H(L-1,L-1)) + DABS(H(L,L))
  IF (S .EQ. 0.D0) S = NORM
  S1 = S
  S2 = S1 + DABS(H(L,L-1))
  IF (S1 .EQ. S2) GO TO 60
50 CONTINUE
!     ********** FORM SHIFT **********
60 X = H(EN,EN)
IF (L .EQ. EN) GO TO 220
Y = H(NA,NA)
W = H(EN,NA)*H(NA,EN)
IF (L .EQ.NA) GO TO 230
IF (ITS .EQ. 50) GO TO 290
IF (ITS .NE. 10 .AND. ITS .NE. 20 .AND. ITS .NE. 30) GO TO 80
!     ********** FORM EXCEPTIONAL SHIFT **********
T = T + X
!
DO I = LOW,EN
  H(I,I) = H(I,I) - X
END DO
!
S = DABS(H(EN,NA)) + DABS(H(NA,ENM2))
X = 0.75D0*S
Y = X
W = -0.4375D0*S*S
80 ITS = ITS + 1
!     ********** LOOK FOR TWO CONSECUTIVE SMALL
!                SUB-DIAGONAL ELEMENTS.
!                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
DO MM = L,ENM2
  M = ENM2 + L - MM
  ZZ = H(M,M)
  R = X - ZZ
  S = Y - ZZ
  P = (R*S-W)/H(M+1,M) + H(M,M+1)
  Q = H(M+1,M+1) - ZZ - R - S
  R = H(M+2,M+1)
  S = DABS(P) + DABS(Q) + DABS(R)
  P = P/S
  Q = Q/S
  R = R/S
  IF (M .EQ. L) GO TO 100
  S1 = DABS(P)*(DABS(H(M-1,M-1))+DABS(ZZ)+DABS(H(M+1,M+1)))
  S2 = S1 + DABS(H(M,M-1))*(DABS(Q) + DABS(R))
  IF (S1 .EQ. S2) GO TO 100
END DO
!
100 MP2 = M + 2
!
do 110 I = MP2,EN
  H(I,I-2) = 0.D0
  IF (I .EQ. MP2) GO TO 110
  H(I,I-3) = 0.D0
110 CONTINUE
!     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
!                COLUMNS M TO EN **********
do 210 K = M,NA
  NOTLAS = K.NE.NA
  IF (K .EQ. M) GO TO 120
  P = H(K,K-1)
  Q = H(K+1,K-1)
  R = 0.D0
  IF (NOTLAS) R = H(K+2,K-1)
  X = DABS(P) + DABS(Q) + DABS(R)
  IF (X .EQ. 0.D0) GO TO 210
  P = P/X
  Q = Q/X
  R = R/X
120 S = DSQRT(P*P + Q*Q + R*R)
  IF (P .LT. 0.D0) S = -S
  IF (K .EQ. M) GO TO 130
  H(K,K-1) = -S*X
  GO TO 140
130 IF (L .NE. M) H(K,K-1) = -H(K,K-1)
140 P = P + S
  X = P/S
  Y = Q/S
  ZZ = R/S
  Q = Q/P
  R = R/P
!     ********** ROW MODIFICATION **********
  DO J = K,N
    P = H(K,J) + Q*H(K+1,J)
    IF (.NOT.NOTLAS) GO TO 150
    P = P + R*H(K+2,J)
    H(K+2,J) = H(K+2,J) - P*ZZ
150 H(K+1,J) = H(K+1,J) - P*Y
    H(K,J) = H(K,J) - P*X
  END DO
!
  J = MIN0(EN,K+3)
!     ********** COLUMN MODIFICATION **********
  DO I = 1,J
    P = X*H(I,K) + Y*H(I,K+1)
    IF (.NOT.NOTLAS) GO TO 170
    P = P + ZZ*H(I,K+2)
    H(I,K+2) = H(I,K+2) - P*R
170 H(I,K+1) = H(I,K+1) - P*Q
    H(I,K) = H(I,K) - P
  END DO
!     ********** ACCUMULATE TRANSFORMATIONS **********
  DO I = LOW,IGH
    P = X*Z(I,K) + Y*Z(I,K+1)
    IF (.NOT.NOTLAS) GO TO 190
    P = P + ZZ*Z(I,K+2)
    Z(I,K+2) = Z(I,K+2) - P*R
190 Z(I,K+1) = Z(I,K+1) - P*Q
    Z(I,K) = Z(I,K) - P
  END DO
!
210 CONTINUE
!
GO TO 40
!     ********** ONE ROOT FOUND **********
220 H(EN,EN) = X + T
WR(EN) = H(EN,EN)
WI(EN) = 0.D0
EN = NA
GO TO 30
!     ********** TWO ROOTS FOUND **********
230 P = (Y - X)/2.D0
Q = P*P + W
ZZ = DSQRT(DABS(Q))
H(EN,EN) = X + T
X = H(EN,EN)
H(NA,NA) = Y + T
IF (Q .LT. 0.D0) GO TO 270
!     ********** REAL PAIR **********
IF (P .LT. 0.D0) ZZ = -ZZ
ZZ = P + ZZ
WR(NA) = X + ZZ
WR(EN) = WR(NA)
IF (ZZ .NE. 0.D0) WR(EN) = X - W/ZZ
WI(NA) = 0.D0
WI(EN) = 0.D0
X = H(EN,NA)
S = DABS(X) + DABS(ZZ)
P = X/S
Q = ZZ/S
R = DSQRT(P*P + Q*Q)
P = P/R
Q = Q/R
!     ********** ROW MODIFICATION **********
DO J = NA,N
  ZZ = H(NA,J)
  H(NA,J) = Q*ZZ + P*H(EN,J)
  H(EN,J) = Q*H(EN,J) - P*ZZ
END DO
!     ********** COLUMN MODIFICATION **********
DO I = 1,EN
  ZZ = H(I,NA)
  H(I,NA) = Q*ZZ + P*H(I,EN)
  H(I,EN) = Q*H(I,EN) - P*ZZ
END DO
!     ********** ACCUMULATE TRANSFORMATIONS **********
DO I = LOW,IGH
  ZZ = Z(I,NA)
  Z(I,NA) = Q*ZZ + P*Z(I,EN)
  Z(I,EN) = Q*Z(I,EN) - P*ZZ
END DO
!
GO TO 280
!     ********** COMPLEX PAIR **********
270 WR(NA) = X + P
WR(EN) = X + P
WI(NA) = ZZ
WI(EN) = -ZZ
280 EN = ENM2
GO TO 30
!     ********** SET ERROR -- NO CONVERGENCE TO AN
!                EIGENVALUE AFTER 50 ITERATIONS **********
290 IERR = EN
RETURN
300 do 320 I = 1,N
  IP1 = I + 1
  IF (DABS(WI(I)) .NE. 0.D0) IP1 = IP1 + 1
  IF (IP1 .GT. N) GO TO 320
  DO J = IP1,N
    H(J,I) = 0.D0
  END DO
320 CONTINUE
RETURN
END SUBROUTINE DSCHUR

SUBROUTINE DSHSLV (A,B,C,M,N,NA,NB,NC,IERR)
!     ------------------------------------------------------------------
!     DSHSLV SOLVES THE MATRIX EQUATION AX + XB = C WHERE
!     A IS IN LOWER SCHUR FORM AND B IN UPPER SCHUR FORM.
!     ------------------------------------------------------------------
INTEGER M,N,NA,NB,NC,IERR
DOUBLE PRECISION A(NA,M), B(NB,N), C(NC,N)
DOUBLE PRECISION SUM, P(4), T(4,4)
INTEGER DK,DL,I,IB,J,JA,K,KM1,KK,L,LM1,LL
!
L = 1
10 LM1 = L - 1
   DL = 1
   IF (L .EQ. N) GO TO 15
   IF (B(L+1,L) .NE. 0.D0) DL = 2
15 LL = L + DL - 1
   IF (L .EQ. 1) GO TO 30
!
   DO J = L,LL
      do 21 I = 1,M
      SUM = C(I,J)
         do 20 IB = 1,LM1
20 SUM = SUM - C(I,IB)*B(IB,J)
21 C(I,J) = SUM
   END DO
!
30 K = 1
40 KM1 = K - 1
      DK = 1
      IF (K .EQ. M) GO TO 45
      IF (A(K,K+1) .NE. 0.D0) DK = 2
45 KK = K + DK - 1
      IF (K .EQ. 1) GO TO 60
!
      DO I = K,KK
         do 51 J = L,LL
         SUM = C(I,J)
            do 50 JA = 1,KM1
50 SUM = SUM - A(I,JA)*C(JA,J)
51 C(I,J) = SUM
      END DO
!
60 IF (DL .EQ. 2) GO TO 80
      IF (DK .EQ. 2) GO TO 70
      T(1,1) = A(K,K) + B(L,L)
      IF (T(1,1) .EQ. 0.D0) GO TO 200
      C(K,L) = C(K,L)/T(1,1)
      IERR = 0
      GO TO 100
!
70 T(1,1) = A(K,K) + B(L,L)
      T(1,2) = A(K,KK)
      T(2,1) = A(KK,K)
      T(2,2) = A(KK,KK) + B(L,L)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      CALL DPSLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      GO TO 100
!
80 IF (DK .EQ. 2) GO TO 90
      T(1,1) = A(K,K) + B(L,L)
      T(1,2) = B(LL,L)
      T(2,1) = B(L,LL)
      T(2,2) = A(K,K) + B(LL,LL)
      P(1) = C(K,L)
      P(2) = C(K,LL)
      CALL DPSLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(K,LL) = P(2)
      GO TO 100
!
90 T(1,1) = A(K,K) + B(L,L)
      T(1,2) = A(K,KK)
      T(1,3) = B(LL,L)
      T(1,4) = 0.D0
      T(2,1) = A(KK,K)
      T(2,2) = A(KK,KK) + B(L,L)
      T(2,3) = 0.D0
      T(2,4) = T(1,3)
      T(3,1) = B(L,LL)
      T(3,2) = 0.D0
      T(3,3) = A(K,K) + B(LL,LL)
      T(3,4) = T(1,2)
      T(4,1) = 0.D0
      T(4,2) = T(3,1)
      T(4,3) = T(2,1)
      T(4,4) = A(KK,KK) + B(LL,LL)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      P(3) = C(K,LL)
      P(4) = C(KK,LL)
      CALL DPSLV (4, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      C(K,LL) = P(3)
      C(KK,LL) = P(4)
!
100 K = K + DK
   IF (K .LE. M) GO TO 40
L = L + DL
IF (L .LE. N) GO TO 10
RETURN
!
!     ERROR RETURN
!
200 IERR = 1
RETURN
END SUBROUTINE DSHSLV

SUBROUTINE TASLV (MO,N,A,NA,C,NC,WK,IERR)
REAL A(NA,N), C(NC,N), WK(*)
! ----------------------------------------------------------------------
!     TASLV SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
!     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
!     AND THE TRANSFORMED SYSTEM IS SOLVED.
! ----------------------------------------------------------------------
!        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
!     WE HAVE THE FOLLOWING SETUP.
!
!        A(NA,N)
!           A IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
!           NA .GE. N .GE. 1.
!
!        C(NC,N)
!           C IS A SYMMETRIC MATRIX OF ORDER N. IT IS
!           ASSUMED THAT NC .GE. N.
!
!        WK(---)
!           WK IS AN ARRAY OF DIMENSION N**2 + 2N THAT
!           IS A GENERAL STORAGE AREA FOR THE ROUTINE.
!
!     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
!     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
!
!        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
!        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A. THE
!                   PROBLEM CANNOT BE SOLVED.
!        IERR = -1  A COULD NOT BE REDUCEDTO UPPER SCHUR FORM.
!                   THE PROBLEM CANNOT BE SOLVED.
!
!     WHEN IERR = 0, A CONTAINS THE UPPER SCHUR FORM OF THE MATRIX
!     A AND WK CONTAINS THE ORTHOGONAL MATRIX INVOLVED IN THE SCHUR
!     DECOMPOSITION OF A. THIS INFORMATION CAN BE REUSED TO SOLVE A
!     NEW SET OF EQUATIONS TRANSPOSE(A)*X + X*A = C WITHOUT HAVING
!     TO REDECOMPOSE A. IN THIS CASE, THE INPUT ARGUMENT MO MAY BE
!     SET TO ANY NONZERO VALUE. WHEN MO .NE. 0, IT IS ASSUMED THAT
!     ONLY C HAS BEEN MODIFIED. ON OUTPUT THE SOLUTION FOR THE NEW
!     SET OF EQUATIONS IS STORED IN C.
! ----------------------------------------------------------------------
!     THIS SUBROUTINE IS A MODIFICATION BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN, VIRGINIA
!     OF THE SUBROUTINE ATXPXA WRITTEN BY
!        R.H. BARTELS AND G.W. STEWART
!        UNIVERSITY OF TEXAS AT AUSTIN.
!
!     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
IW = N*N + 1
CALL TASLV1 (MO,N,A,NA,WK(1),N,C,NC,WK(IW),IERR)
RETURN
END SUBROUTINE TASLV

SUBROUTINE TASLV1 (MO,N,A,NA,U,NU,C,NC,WK,IERR)
! ----------------------------------------------------------------------
!     TASLV1 SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
!     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
!     AND THE TRANSFORMED SYSTEM IS SOLVED.
! ----------------------------------------------------------------------
REAL A(NA,N), U(NU,N), C(NC,N), WK(*)
!
!    IF REQUIRED, REDUCE A TO UPPER REAL SCHUR FORM
!
IF (MO .NE. 0) GO TO 10
CALL ORTHES (NA,N,1,N,A,WK)
CALL ORTRN1 (N,1,N,A,NA,U,NU,WK)
CALL SCHUR (N,1,N,A,NA,U,NU,WK(1),WK(N+1),IERR)
IF (IERR .NE. 0) GO TO 200
!
!     TRANSFORM C
!
10 DO I = 1,N
   C(I,I) = C(I,I)/2.0
END DO
!
DO I = 1,N
   DO J = 1,N
      WK(J) = 0.0
      DO K = I,N
         WK(J) = WK(J) + C(I,K)*U(K,J)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
!
DO J = 1,N
   DO I = 1,N
      WK(I) = 0.0
      DO K = 1,N
         WK(I) = WK(I) + U(K,I)*C(K,J)
      END DO
   END DO
   DO I = 1,N
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,N
   DO J = I,N
      C(I,J) = C(I,J) + C(J,I)
      C(J,I) = C(I,J)
   END DO
END DO
!
!     SOLVE THE TRANSFORMED SYSTEM
!
CALL SYMSLV (A,C,N,NA,NC,IERR)
IF (IERR .NE. 0) GO TO 210
!
!     TRANSFORM C BACK TO THE SOLUTION
!
DO I = 1,N
   C(I,I) = C(I,I)/2.0
END DO
!
DO I = 1,N
   DO J = 1,N
      WK(J) = 0.0
      DO K = I,N
         WK(J) = WK(J) + C(I,K)*U(J,K)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
!
DO J = 1,N
   DO I = 1,N
      WK(I) = 0.0
      DO K = 1,N
         WK(I) = WK(I) + U(I,K)*C(K,J)
      END DO
   END DO
   DO I = 1,N
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,N
   DO J = I,N
      C(I,J) = C(I,J) + C(J,I)
      C(J,I) = C(I,J)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = -1
RETURN
210 IERR = 1
RETURN
END SUBROUTINE TASLV1

SUBROUTINE SYMSLV (A,C,N,NA,NC,IERR)
! ----------------------------------------------------------------------
!     SYMSLV SOLVES THE MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
!     WHERE A IS IN UPPER SCHUR FORM AND C IS SYMMETRIC.
! ----------------------------------------------------------------------
INTEGER N,NA,NC,IERR
REAL A(NA,N), C(NC,N), SUM, P(4), T(4,4)
INTEGER DK,DL,I,IA,J,K,KK,KM1,L,LL,LDL
!
L = 1
10 DL = 1
   IF (L .EQ. N) GO TO 20
   IF (A(L+1,L) .NE. 0.0) DL = 2
20 LL = L + DL - 1
!
   K = L
30 KM1 = K - 1
      DK = 1
      IF (K .EQ. N) GO TO 35
      IF (A(K+1,K) .NE. 0.0) DK = 2
35 KK = K + DK - 1
      IF (K .EQ. L) GO TO 45
!
      DO I = K,KK
         do 41 J = L,LL
         SUM = C(I,J)
            do 40 IA = L,KM1
40 SUM = SUM - A(IA,I)*C(IA,J)
41 C(I,J) = SUM
      END DO
!
45 IF (DL .EQ. 2) GO TO 60
      IF (DK .EQ. 2 ) GO TO 50
      T(1,1) = A(K,K) + A(L,L)
      IF (T(1,1) .EQ. 0.0) GO TO 200
      C(K,L) = C(K,L)/T(1,1)
      IERR = 0
      GO TO 90
!
50 T(1,1) = A(K,K) + A(L,L)
      T(1,2) = A(KK,K)
      T(2,1) = A(K,KK)
      T(2,2) = A(KK,KK) + A(L,L)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      CALL SLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      GO TO 90
!
60 IF (DK .EQ. 2) GO TO 70
      T(1,1) = A(K,K) + A(L,L)
      T(1,2) = A(LL,L)
      T(2,1) = A(L,LL)
      T(2,2) = A(K,K) + A(LL,LL)
      P(1) = C(K,L)
      P(2) = C(K,LL)
      CALL SLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(K,LL) = P(2)
      GO TO 90
!
70 IF (K .NE. L) GO TO 80
      T(1,1) = A(L,L)
      T(1,2) = A(LL,L)
      T(1,3) = 0.0
      T(2,1) = A(L,LL)
      T(2,2) = A(L,L) + A(LL,LL)
      T(2,3) = T(1,2)
      T(3,1) = 0.0
      T(3,2) = T(2,1)
      T(3,3) = A(LL,LL)
      P(1) = C(L,L)/2.0
      P(2) = C(LL,L)
      P(3) = C(LL,LL)/2.0
      CALL SLV (3, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(L,L) = P(1)
      C(LL,L) = P(2)
      C(L,LL) = P(2)
      C(LL,LL) = P(3)
      GO TO 90
!
80 T(1,1) = A(K,K) + A(L,L)
      T(1,2) = A(KK,K)
      T(1,3) = A(LL,L)
      T(1,4) = 0.0
      T(2,1) = A(K,KK)
      T(2,2) = A(KK,KK) + A(L,L)
      T(2,3) = 0.0
      T(2,4) = T(1,3)
      T(3,1) = A(L,LL)
      T(3,2) = 0.0
      T(3,3) = A(K,K) + A(LL,LL)
      T(3,4) = T(1,2)
      T(4,1) = 0.0
      T(4,2) = T(3,1)
      T(4,3) = T(2,1)
      T(4,4) = A(KK,KK) + A(LL,LL)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      P(3) = C(K,LL)
      P(4) = C(KK,LL)
      CALL SLV (4, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      C(K,LL) = P(3)
      C(KK,LL) = P(4)
!
90 K = K + DK
   IF (K .LE. N) GO TO 30
LDL = L + DL
IF (LDL .GT. N) RETURN
!
DO J = LDL,N
   DO I = L,LL
      C(I,J) = C(J,I)
   END DO
   do 120 I = J,N
      do 110 K = L,LL
110 C(I,J) = C(I,J) - C(I,K)*A(K,J) - A(K,I)*C(K,J)
120 C(J,I) = C(I,J)
END DO
L = LDL
GO TO 10
!
!     ERROR RETURN
!
200 IERR = 1
RETURN
END SUBROUTINE SYMSLV

SUBROUTINE DTASLV (MO,N,A,NA,C,NC,WK,IERR)
DOUBLE PRECISION A(NA,N), C(NC,N), WK(*)
! ----------------------------------------------------------------------
!     DTASLV SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
!     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
!     AND THE TRANSFORMED SYSTEM IS SOLVED.
! ----------------------------------------------------------------------
!        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
!     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
!     WE HAVE THE FOLLOWING SETUP.
!
!        A(NA,N)
!           A IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
!           NA .GE. N .GE. 1.
!
!        C(NC,N)
!           C IS A SYMMETRIC MATRIX OF ORDER N. IT IS
!           ASSUMED THAT NC .GE. N.
!
!        WK(---)
!           WK IS AN ARRAY OF DIMENSION N**2 + 2N THAT
!           IS A GENERAL STORAGE AREA FOR THE ROUTINE.
!
!     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
!     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
!
!        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
!        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A. THE
!                   PROBLEM CANNOT BE SOLVED.
!        IERR = -1  A COULD NOT BE REDUCEDTO UPPER SCHUR FORM.
!                   THE PROBLEM CANNOT BE SOLVED.
!
!     WHEN IERR = 0, A CONTAINS THE UPPER SCHUR FORM OF THE MATRIX
!     A AND WK CONTAINS THE ORTHOGONAL MATRIX INVOLVED IN THE SCHUR
!     DECOMPOSITION OF A. THIS INFORMATION CAN BE REUSED TO SOLVE A
!     NEW SET OF EQUATIONS TRANSPOSE(A)*X + X*A = C WITHOUT HAVING
!     TO REDECOMPOSE A. IN THIS CASE, THE INPUT ARGUMENT MO MAY BE
!     SET TO ANY NONZERO VALUE. WHEN MO .NE. 0, IT IS ASSUMED THAT
!     ONLY C HAS BEEN MODIFIED. ON OUTPUT THE SOLUTION FOR THE NEW
!     SET OF EQUATIONS IS STORED IN C.
! ----------------------------------------------------------------------
!     THIS SUBROUTINE IS A MODIFICATION BY
!        ALFRED H. MORRIS, JR.
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN, VIRGINIA
!     OF THE SUBROUTINE ATXPXA WRITTEN BY
!        R.H. BARTELS AND G.W. STEWART
!        UNIVERSITY OF TEXAS AT AUSTIN.
!
!     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
!        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
!        15 (1972), PP. 820-826.
! ----------------------------------------------------------------------
IW = N*N + 1
CALL DTASV1 (MO,N,A,NA,WK(1),N,C,NC,WK(IW),IERR)
RETURN
END SUBROUTINE DTASLV

SUBROUTINE DTASV1 (MO,N,A,NA,U,NU,C,NC,WK,IERR)
! ----------------------------------------------------------------------
!     DTASV1 SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
!     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
!     AND THE TRANSFORMED SYSTEM IS SOLVED.
! ----------------------------------------------------------------------
DOUBLE PRECISION A(NA,N), U(NU,N), C(NC,N), WK(*)
!
!    IF REQUIRED, REDUCE A TO UPPER REAL SCHUR FORM
!
IF (MO .NE. 0) GO TO 10
CALL DORTH (NA,N,1,N,A,WK)
CALL DRTRN1 (N,1,N,A,NA,U,NU,WK)
CALL DSCHUR (N,1,N,A,NA,U,NU,WK(1),WK(N+1),IERR)
IF (IERR .NE. 0) GO TO 200
!
!     TRANSFORM C
!
10 DO I = 1,N
   C(I,I) = C(I,I)/2.D0
END DO
!
DO I = 1,N
   DO J = 1,N
      WK(J) = 0.D0
      DO K = I,N
         WK(J) = WK(J) + C(I,K)*U(K,J)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
!
DO J = 1,N
   DO I = 1,N
      WK(I) = 0.D0
      DO K = 1,N
         WK(I) = WK(I) + U(K,I)*C(K,J)
      END DO
   END DO
   DO I = 1,N
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,N
   DO J = I,N
      C(I,J) = C(I,J) + C(J,I)
      C(J,I) = C(I,J)
   END DO
END DO
!
!     SOLVE THE TRANSFORMED SYSTEM
!
CALL DSYMSV (A,C,N,NA,NC,IERR)
IF (IERR .NE. 0) GO TO 210
!
!     TRANSFORM C BACK TO THE SOLUTION
!
DO I = 1,N
   C(I,I) = C(I,I)/2.D0
END DO
!
DO I = 1,N
   DO J = 1,N
      WK(J) = 0.D0
      DO K = I,N
         WK(J) = WK(J) + C(I,K)*U(J,K)
      END DO
   END DO
   DO J = 1,N
      C(I,J) = WK(J)
   END DO
END DO
!
DO J = 1,N
   DO I = 1,N
      WK(I) = 0.D0
      DO K = 1,N
         WK(I) = WK(I) + U(I,K)*C(K,J)
      END DO
   END DO
   DO I = 1,N
      C(I,J) = WK(I)
   END DO
END DO
!
DO I = 1,N
   DO J = I,N
      C(I,J) = C(I,J) + C(J,I)
      C(J,I) = C(I,J)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = -1
RETURN
210 IERR = 1
RETURN
END SUBROUTINE DTASV1

SUBROUTINE DSYMSV (A,C,N,NA,NC,IERR)
! ----------------------------------------------------------------------
!     DSYMSV SOLVES THE MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
!     WHERE A IS IN UPPER SCHUR FORM AND C IS SYMMETRIC.
! ----------------------------------------------------------------------
INTEGER N,NA,NC,IERR
DOUBLE PRECISION A(NA,N), C(NC,N), SUM, P(4), T(4,4)
INTEGER DK,DL,I,IA,J,K,KK,KM1,L,LL,LDL
!
L = 1
10 DL = 1
   IF (L .EQ. N) GO TO 20
   IF (A(L+1,L) .NE. 0.D0) DL = 2
20 LL = L + DL - 1
!
   K = L
30 KM1 = K - 1
      DK = 1
      IF (K .EQ. N) GO TO 35
      IF (A(K+1,K) .NE. 0.D0) DK = 2
35 KK = K + DK - 1
      IF (K .EQ. L) GO TO 45
!
      DO I = K,KK
         do 41 J = L,LL
         SUM = C(I,J)
            do 40 IA = L,KM1
40 SUM = SUM - A(IA,I)*C(IA,J)
41 C(I,J) = SUM
      END DO
!
45 IF (DL .EQ. 2) GO TO 60
      IF (DK .EQ. 2 ) GO TO 50
      T(1,1) = A(K,K) + A(L,L)
      IF (T(1,1) .EQ. 0.D0) GO TO 200
      C(K,L) = C(K,L)/T(1,1)
      IERR = 0
      GO TO 90
!
50 T(1,1) = A(K,K) + A(L,L)
      T(1,2) = A(KK,K)
      T(2,1) = A(K,KK)
      T(2,2) = A(KK,KK) + A(L,L)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      CALL DPSLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      GO TO 90
!
60 IF (DK .EQ. 2) GO TO 70
      T(1,1) = A(K,K) + A(L,L)
      T(1,2) = A(LL,L)
      T(2,1) = A(L,LL)
      T(2,2) = A(K,K) + A(LL,LL)
      P(1) = C(K,L)
      P(2) = C(K,LL)
      CALL DPSLV (2, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(K,LL) = P(2)
      GO TO 90
!
70 IF (K .NE. L) GO TO 80
      T(1,1) = A(L,L)
      T(1,2) = A(LL,L)
      T(1,3) = 0.D0
      T(2,1) = A(L,LL)
      T(2,2) = A(L,L) + A(LL,LL)
      T(2,3) = T(1,2)
      T(3,1) = 0.D0
      T(3,2) = T(2,1)
      T(3,3) = A(LL,LL)
      P(1) = C(L,L)/2.D0
      P(2) = C(LL,L)
      P(3) = C(LL,LL)/2.D0
      CALL DPSLV (3, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(L,L) = P(1)
      C(LL,L) = P(2)
      C(L,LL) = P(2)
      C(LL,LL) = P(3)
      GO TO 90
!
80 T(1,1) = A(K,K) + A(L,L)
      T(1,2) = A(KK,K)
      T(1,3) = A(LL,L)
      T(1,4) = 0.D0
      T(2,1) = A(K,KK)
      T(2,2) = A(KK,KK) + A(L,L)
      T(2,3) = 0.D0
      T(2,4) = T(1,3)
      T(3,1) = A(L,LL)
      T(3,2) = 0.D0
      T(3,3) = A(K,K) + A(LL,LL)
      T(3,4) = T(1,2)
      T(4,1) = 0.D0
      T(4,2) = T(3,1)
      T(4,3) = T(2,1)
      T(4,4) = A(KK,KK) + A(LL,LL)
      P(1) = C(K,L)
      P(2) = C(KK,L)
      P(3) = C(K,LL)
      P(4) = C(KK,LL)
      CALL DPSLV (4, 1, T, 4, P, 4, IERR)
      IF (IERR .NE. 0) GO TO 200
      C(K,L) = P(1)
      C(KK,L) = P(2)
      C(K,LL) = P(3)
      C(KK,LL) = P(4)
!
90 K = K + DK
   IF (K .LE. N) GO TO 30
LDL = L + DL
IF (LDL .GT. N) RETURN
!
DO J = LDL,N
   DO I = L,LL
      C(I,J) = C(J,I)
   END DO
   do 120 I = J,N
      do 110 K = L,LL
110 C(I,J) = C(I,J) - C(I,K)*A(K,J) - A(K,I)*C(K,J)
120 C(J,I) = C(I,J)
END DO
L = LDL
GO TO 10
!
!     ERROR RETURN
!
200 IERR = 1
RETURN
END SUBROUTINE DSYMSV

SUBROUTINE SQUINT(NM, N, A, B, C, IGUESS, S, WORK, NW, TOL, &
&MAXITS, IERR)
!
!
!     SUBROUTINE SQUINT BREAKS DOWN THE WORK ARRAY  WORK  INTO
!     SMALLER PIECES.  THE ACTUAL SOLUTION TO AX**2 + BX + C = 0 IS
!     DONE IN SUBROUTINE SQUIN2.  THIS SUBROUTINE MERELY RELIEVES
!     THE USER FROM A LONG CALLING SEQUENCE.
!
!
!     ON ENTRY,
!
!     NM     IS THE LEADING DIMENSION OF ALL THE MATRICES
!            IN THE CALLING PROGRAM.
!
!     N      IS THE ORDER OF THE MATRICES A, B AND C.
!
!     A      IS THE MATRIX COEFFICIENT OF X**2.
!
!     B      IS THE MATRIX COEFFICIENT OF X.
!
!     C      IS THE CONSTANT MATRIX.
!
!     IGUESS IS AN INTEGER. IF IGUESS.NE.0, THE USER SUPPLIES AN
!            INITIAL GUESS AT A SOLVENT.  THIS GUESS IS STORED IN
!            ARRAY S.  IF IGUESS.EQ.0, THE SUBROUTINE PROVIDES ITS
!            OWN INITIAL GUESS.
!
!     S      CONTAINS THE USERS INITIAL GUESS AT A SOLVENT, IF IGUESS
!            HAS BEEN SET TO A NONZERO QUANTITY.  OTHERWISE THE INPUT
!            CONTENTS IN S ARE IGNORED.
!
!     WORK   IS A WORK VECTOR.  IT MUST BE DIMENSIONED AT LEAST
!            (7N**2 + N), WHERE N IS THE ORDER OF A, B, C AND S.
!
!     NW     IS THE DIMENSION OF THE ARRAY WORK IN THE CALLING
!            PROGRAM.
!
!     TOL    IS A USER-SUPPLIED ACCURACY TOLERANCE.  SETTING TOL = 0.0
!            CAUSES ITERATION TO PROCEED UNTIL FULL MACHINE PRECISION
!            IS ATTAINED.  OTHERWISE, EXECUTION TERMINATES WHEN
!            NORM(AS**2+BS+C).LT.TOL.
!
!     MAXITS IS AN INTEGER.  IF MAXITS.NE.0, THE USER SPECIFIES THE
!            MOST INTERATIONS THE ALGORITHM IS TO TAKE.  IF MAXITS.
!            .LE.0, IT IS RESET TO 30.
!
!
!     ON RETURN,
!
!     A,B,C  ARE DESTROYED.
!
!     IGUESS CONTAINS THE NUMBER OF ITERATIONS PERFORMED TO
!            COMPUTE S.
!
!     S      CONTAINS THE RIGHT SOLVENT.
!
!     WORK(1) IS A COMPLEX NUMBER WITH REAL PART EQUAL TO THE NORM
!            OF AS**2+BS+C.
!
!     IERR   IS AN INTEGER ERROR RETURN.
!
!            IERR = 0 FOR A NORMAL RETURN.
!
!            IERR = 1 INDICATES FAILURE OF SQUINT TO CONVERGE TO
!                     A SOLVENT IN THE MAXIMUM NUMBER OF ITERATIONS.
!
!            IERR = 2 INDICATES FAILURE IN THE UPPER REDUCTION IN
!                     CQZIT.
!
!            IERR = 3 INDICATES FAILURE IN THE LOWER REDUCTION IN
!                     CQZIT.
!
!            IERR = 10 + N  INDICATES AN ERROR RETURN FROM TRISLV
!                     ON ITERATION N, DESIGNATING INCONSISTENCY OF
!                     THE TRIANGULAR SYSTEM.
!
!            IERR = 999 INDICATES IMPROPER DIMENSIONING.  THE
!                     CONDITIONS  NM.GE.N.GT.0   AND
!                     NW.GE.(7*N*N + N) MUST HOLD.
!
INTEGER NM, N, IGUESS, NW, MAXITS, IERR, I1, I2, I3, I4, I5, I6, &
&I7
COMPLEX WORK(NW)
COMPLEX A(NM,N), B(NM,N), C(NM,N), S(NM,N)
REAL TOL
I1 = N*N + 1
I2 = N*N + I1
I3 = N*N + I2
I4 = N*N + I3
I5 = N*N + I4
I6 = N*N + I5
I7 = N*N + I6
CALL SQUIN2(NM, N, A, B, C, IGUESS, S, WORK(1), WORK(I1), &
&WORK(I2), WORK(I3), WORK(I4), WORK(I5), WORK(I6), WORK(I7), NW, &
&TOL, MAXITS, IERR)
RETURN
END SUBROUTINE SQUINT

SUBROUTINE SQUIN2(NM, N, A, B, C, IGUESS, S, L, U, V, Z, R, XOLD, &
&EYE, TEMP, NW, TOL, MAXITS, IERR)
!
!     SUBROUTINE SQUIN2 FINDS A RIGHT SOLVENT OF THE MATRIX
!     EQUATION AX**2 + BX + C = 0.
!
!     ON ENTRY,
!
!     NM     IS THE LEADING DIMENSION OF ALL THE MATRICES IN
!            THE CALLING PROGRAM.
!
!     N      IS THE ORDER OF THE MATRICES A, B AND C.
!
!     A      IS THE MATRIX COEFFICIENT OF X**2.
!
!     B      IS THE MATRIX COEFFICIENT OF X.
!
!     C      IS THE CONSTANT MATRIX.
!
!     IGUESS IS AN INTEGER SET IN THE CALL TO SQUINT.
!
!     S      IS A MATRIX SET IN THE CALL TO SQUINT.
!
!     NW, TOL, AND MAXITS ARE INTEGER AND REAL PARAMETERS SET IN
!            THE CALL TO SQUINT.
!
!
!     THE FOLLOWING ARE INTERNAL VARIABLES ...
!
!
!     L      IS A MATRIX CONTAINING THE ITERATE X(I) FOR
!            REDUCTION TO LOWER TRIANGULAR FORM.
!
!     U      IS A MATRIX CONTAINING AX(I) + B FOR REDUCTION
!            TO UPPER TRIANGULAR FORM.
!
!     V      IS A MATRIX CONTAINING A FOR REDUCTION TO UPPER
!            TRIANGULAR FORM.
!
!     Z,R    ARE MATRICES CONTAINING THE HISTORY OF THE
!            TRANSFORMATIONS IN THE REDUCTIONS.
!
!     XOLD   IS A MATRIX HOLDING THE CURRENT ITERATE X(I).
!
!     EYE    CONTAINS AN IDENTITY MATRIX FOR THE LOWER REDUCTION
!            STEP.
!
!     TEMP   IS A WORK VECTOR.
!
!
!     ON RETURN,
!
!     A, B, C, IGUESS, S AND IERR HAVE THE SAME PROPERTIES AS
!            DESCRIBED IN THE RETURN FROM SUBROUTINE SQUINT.
!
!     L(1,1) IS A COMPLEX NUMBER WITH REAL PART EQUAL TO THE NORM
!            OF AS**2+BS+C.
!
!
INTEGER NM, N, IGUESS, NW, MAXITS, IERR
INTEGER ITS, MATS, I, J, K
COMPLEX A(NM,N), B(NM,N), C(NM,N), S(NM,N), L(NM,N), U(NM,N)
COMPLEX V(NM,N), Z(NM,N), R(NM,N), XOLD(NM,N), EYE(NM,N), TEMP(N)
REAL ANORM, ANI, BNORM, BNI, CNORM, CNI, XNORM, XNI
REAL FXNORM, FXNI, GNORM, TNORM, T, TOL
!     REAL SQRT, CABS, FLOAT
!     COMPLEX CMPLX, CONJG
K = 7*N*N + N
IF (NW.LT.K) GO TO 460
IF (NM.LT.N) GO TO 460
IF (N.LE.0) GO TO 460
IF (MAXITS.LE.0) MAXITS = 30
!     ********** INITIALIZE ARRAYS **********
do 20 I = 1,N
  do 10 J = 1,N
    L(I,J) = CMPLX(0.0,0.0)
    U(I,J) = CMPLX(0.0,0.0)
    V(I,J) = CMPLX(0.0,0.0)
    Z(I,J) = CMPLX(0.0,0.0)
    XOLD(I,J) = CMPLX(0.0,0.0)
    EYE(I,J) = CMPLX(0.0,0.0)
10 CONTINUE
  TEMP(I) = CMPLX(0.0,0.0)
20 CONTINUE
!     ********** SET INITIAL GUESS(ES) **********
ANORM = 0.0
BNORM = 0.0
CNORM = 0.0
do 40 I = 1,N
  ANI = 0.0
  BNI = 0.0
  CNI = 0.0
  do 30 J = 1,N
    ANI = ANI + CABS(A(I,J))
    BNI = BNI + CABS(B(I,J))
    CNI = CNI + CABS(C(I,J))
30 CONTINUE
  IF (ANI.GT.ANORM) ANORM = ANI
  IF (BNI.GT.BNORM) BNORM = BNI
  IF (CNI.GT.CNORM) CNORM = CNI
40 CONTINUE
GNORM = (BNORM+SQRT(BNORM**2+4.0*ANORM*CNORM))/(2.0*ANORM)
IF (IGUESS.EQ.0) GO TO 70
DO I=1,N
  DO J=1,N
    XOLD(I,J) = S(I,J)
  END DO
END DO
GO TO 100
!
70 DO I=1,N
  DO J=1,N
    XOLD(I,J) = CMPLX(0.0,0.0)
  END DO
  XOLD(I,I) = CMPLX(GNORM,0.0)
END DO
!
100 DO ITS=1,MAXITS
  IF (ITS.NE.31) GO TO 130
  DO I=1,N
    DO J=1,N
      XOLD(I,J) = CMPLX(0.0,0.0)
    END DO
    XOLD(I,I) = CMPLX(0.0,GNORM)
  END DO
!
130 IF (ITS.NE.61) GO TO 160
  DO I=1,N
    DO J=1,N
      XOLD(I,J) = C(I,J)
    END DO
  END DO
!        ********** SET UP U AND RIGHT HAND SIDE **********
160 CALL CMPROD(N, N, N, A, NM, XOLD, NM, U, NM, U)
  DO I=1,N
    DO J=1,N
      U(I,J) = U(I,J) + B(I,J)
    END DO
  END DO
  CALL CMPROD(N, N, N, U, NM, XOLD, NM, S, NM, S)
  DO I=1,N
    DO J=1,N
      S(I,J) = S(I,J) + C(I,J)
    END DO
  END DO
!        ********** CHECK FOR CONVERGENCE **********
  XNORM = 0.0
  FXNORM = 0.0
  DO I=1,N
    XNI = 0.0
    FXNI = 0.0
    DO J=1,N
      XNI = XNI + CABS(XOLD(I,J))
      FXNI = FXNI + CABS(S(I,J))
    END DO
    IF (XNI.GT.XNORM) XNORM = XNI
    IF (FXNI.GT.FXNORM) FXNORM = FXNI
  END DO
  IF (TOL.LE.0.0) GO TO 230
  IF (FXNORM.LT.TOL) GO TO 370
230 TNORM = 8.0*FLOAT(N)*ANORM*XNORM**2 + 5.0*FLOAT(N)*BNORM*XNORM &
&+ CNORM
  T = 1.0 + FXNORM/TNORM
  IF (T.EQ.1.0) GO TO 370
  IF (ITS.GE.MAXITS) GO TO 400
!        ********** UPPER TRIANGULARIZATION **********
  IF (ITS.NE.1) GO TO 240
  MATS = 1
  CALL CQZHES(NM, N, U, A, MATS, Z, S, B, C)
240 DO I=1,N
    DO J=1,N
      V(I,J) = A(I,J)
      L(I,J) = CONJG(XOLD(J,I))
      EYE(I,J) = CMPLX(0.0,0.0)
    END DO
    EYE(I,I) = CMPLX(1.0,0.0)
  END DO
  IF (ITS.EQ.1) GO TO 270
  MATS = 2
  CALL CQZHES(NM, N, U, V, MATS, Z, S, B, C)
270 CALL CQZIT(NM, N, U, V, 0.0, MATS, Z, S, IERR)
  IF (IERR.NE.0) GO TO 430
!        ********** LOWER TRIANGULARIZATION **********
  MATS = 3
  CALL CQZHES(NM, N, L, EYE, MATS, R, S, B, C)
  CALL CQZIT(NM, N, L, EYE, 0.0, MATS, R, S, IERR)
  IF (IERR.NE.0) GO TO 440
  CALL CTRANS(NM, N, L)
!        ********** UPDATE S WITH R **********
  DO I=1,N
    DO J=1,N
      TEMP(J) = S(I,J)
      S(I,J) = CMPLX(0.0,0.0)
    END DO
    DO J=1,N
      DO K=1,N
        S(I,J) = S(I,J) + TEMP(K)*R(K,J)
      END DO
    END DO
  END DO
  DO J=1,N
    DO I=1,N
      L(I,J) = L(I,J)*EYE(J,J)
    END DO
    EYE(J,J) = CMPLX(1.0,0.0)
  END DO
!        ********** BACKSOLVE THE TRANSFORMED SYSTEM **********
  CALL TRISLV(NM, N, U, V, L, S, TEMP, IERR)
  IF (IERR.NE.0) GO TO 450
!        ********** TRANSLATE BACK TO THE SOLUTION **********
  CALL CMPROD(N, N, N, Z, NM, S, NM, L, NM, L)
  CALL CTRANS(NM, N, R)
  CALL CMPROD(N, N, N, L, NM, R, NM, S, NM, S)
  DO I=1,N
    DO J=1,N
      XOLD(I,J) = XOLD(I,J) - S(I,J)
    END DO
  END DO
END DO
!     ********** CONVERGENCE **********
370 IGUESS = ITS - 1
L(1,1) = CMPLX(FXNORM,0.0)
DO I=1,N
  DO J=1,N
    S(I,J) = XOLD(I,J)
  END DO
END DO
IERR = 0
RETURN
!     ********** ERROR RETURNS **********
400 IERR = 1
L(1,1) = CMPLX(FXNORM,0.0)
DO I=1,N
  DO J=1,N
    S(I,J) = XOLD(I,J)
  END DO
END DO
RETURN
430 IERR = 2
RETURN
440 IERR = 3
RETURN
450 IERR = ITS + 10
RETURN
460 IERR = 999
RETURN
END SUBROUTINE SQUIN2

SUBROUTINE CQZHES(NM, N, A, B, MATS, Z, F, G, H)
!
!
!     SUBROUTINE CQZHES IS A MODIFICATION OF THE EISPACK SUBROUTINE
!     QZHES.  ALL OPERATIONS ARE PERFORMED IN COMPLEX ARITHMETIC,
!     AND THE LEFT TRANSFORMATIONS MAY ALSO BE APPLIED TO AUXILIARY
!     MATRICES F, G AND H.
!
!
!     ON ENTRY,
!
!     NM   IS THE LEADING DIMENSION OF THE MATRICES A AND B IN
!          THE MAIN PROGRAM.
!
!     N    IS THE ORDER OF THE MATRICES A AND B.
!
!     A    CONTAINS THE MATRIX TO BE REDUCED TO UPPER HESSENBERG
!          FORM.
!
!     B    CONTAINS THE MATRIX TO BE REDUCED TO UPPER TRAINGULAR
!          FORM.
!
!     MATS IS AN INTEGER INPUT VARIABLE.
!
!          IF MATS = 0, THE ACCUMULATION OF THE TRANSFORMATIONS
!             IS NOT DESIRED.
!
!          IF MATS = ANY OTHER NUMBER BUT 0, THE TRANSFORMATIONS
!             ARE ACCUMULATED.
!
!          IF MATS = 1, THE AUXILIARY MATRICES G AND H ARE UPDATED
!             WITH THE UNITARY MATRIX Q.
!
!          IF MATS = 2, MATRIX B IS ASSUMED UPPER TRIANGULAR.
!
!          IF MATS = 3, THE AUXILIARY MATRIX F IS NOT UPDATED
!             WITH THE UNITARY MATRIX Q.
!
!     F, G AND H ARE AUXILIARY MATRICES.
!
!
!     ON RETURN,
!
!     A    IS UPPER HESSENBERG.
!
!     B    IS UPPER TRIANGULAR.
!
!     Z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
!
!     F, G AND H ARE UPDATED, IF DESIRED.
!
!
INTEGER I, J, K, L, N, LB, L1, NM, NK1, NM1, NM2
COMPLEX A(NM,N), B(NM,N), Z(NM,N)
COMPLEX RR, T, U1, U2, V1, V2, RHO
COMPLEX F(NM,N), TF, G(NM,N), TG, H(NM,N), TH
REAL R, S
INTEGER MATS
!     REAL SQRT, CABS
!     COMPLEX CMPLX, CONJG
IF (MATS.EQ.0) GO TO 30
DO I=1,N
  DO J=1,N
    Z(I,J) = CMPLX(0.0,0.0)
  END DO
  Z(I,I) = CMPLX(1.0,0.0)
END DO
!     ********** REDUCE B TO UPPER TRIANGULAR FORM **********
30 IF (N.LE.1) GO TO 260
NM1 = N - 1
IF (MATS.EQ.2) GO TO 140
do 130 L = 1,NM1
  L1 = L + 1
  S = 0.0
  DO I=L1,N
    S = S + CABS(B(I,L))
  END DO
  IF (S.EQ.0.0) GO TO 130
  S = S + CABS(B(L,L))
  R = 0.0
  DO I=L,N
    B(I,L) = B(I,L)/CMPLX(S,0.0)
    R = R + CABS(B(I,L))**2
  END DO
  R = SQRT(R)
  RR = CMPLX(R,0.0)
  IF (CABS(B(L,L)).NE.0.0) RR = (B(L,L)/CABS(B(L,L)))*RR
  B(L,L) = B(L,L) + RR
  RHO = CONJG(RR)*B(L,L)
  DO J=L1,N
    T = CMPLX(0.0,0.0)
    DO I=L,N
      T = T + CONJG(B(I,L))*B(I,J)
    END DO
    T = -T/RHO
    DO I=L,N
      B(I,J) = B(I,J) + T*B(I,L)
    END DO
  END DO
  DO J=1,N
    T = CMPLX(0.0,0.0)
    TF = CMPLX(0.0,0.0)
    TG = CMPLX(0.0,0.0)
    TH = CMPLX(0.0,0.0)
    do 90 I = L,N
      T = T + CONJG(B(I,L))*A(I,J)
      IF (MATS.EQ.3) GO TO 90
      TF = TF + CONJG(B(I,L))*F(I,J)
      IF (MATS.NE.1) GO TO 90
      TG = TG + CONJG(B(I,L))*G(I,J)
      TH = TH + CONJG(B(I,L))*H(I,J)
90 CONTINUE
    T = -T/RHO
    TF = -TF/RHO
    TG = -TG/RHO
    TH = -TH/RHO
    do 100 I = L,N
      A(I,J) = A(I,J) + T*B(I,L)
      IF (MATS.EQ.3) GO TO 100
      F(I,J) = F(I,J) + TF*B(I,L)
      IF (MATS.NE.1) GO TO 100
      G(I,J) = G(I,J) + TG*B(I,L)
      H(I,J) = H(I,J) + TH*B(I,L)
100 CONTINUE
  END DO
  B(L,L) = -CMPLX(S,0.0)*RR
  DO I=L1,N
    B(I,L) = CMPLX(0.0,0.0)
  END DO
130 CONTINUE
!     ********** REDUCE A TO UPPER HESSENBERG FORM, WHILE
!                KEEPING B TRIANGULAR **********
140 IF (N.EQ.2) GO TO 260
NM2 = N - 2
DO K=1,NM2
  NK1 = NM1 - K
  do 240 LB = 1,NK1
    L = N - LB
    L1 = L + 1
!     ********** ZERO A(L+1,K) **********
    S = CABS(A(L,K)) + CABS(A(L1,K))
    IF (S.EQ.0.0) GO TO 240
    U1 = A(L,K)/CMPLX(S,0.0)
    U2 = A(L1,K)/CMPLX(S,0.0)
    R = SQRT(CABS(U1)**2+CABS(U2)**2)
    RR = CMPLX(R,0.0)
    IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
    V1 = -(U1+RR)/RR
    V2 = -U2/RR
    U2 = V2/V1
    DO J=K,N
      T = A(L,J) + CONJG(U2)*A(L1,J)
      A(L,J) = A(L,J) + T*V1
      A(L1,J) = A(L1,J) + T*V2
    END DO
    A(L1,K) = CMPLX(0.0,0.0)
    DO J=L,N
      T = B(L,J) + CONJG(U2)*B(L1,J)
      B(L,J) = B(L,J) + T*V1
      B(L1,J) = B(L1,J) + T*V2
    END DO
    IF (MATS.EQ.3) GO TO 180
    DO J=1,N
      TF = F(L,J) + CONJG(U2)*F(L1,J)
      F(L,J) = F(L,J) + TF*V1
      F(L1,J) = F(L1,J) + TF*V2
    END DO
180 IF (MATS.NE.1) GO TO 200
    DO J=1,N
      TG = G(L,J) + CONJG(U2) + G(L1,J)
      TH = H(L,J) + CONJG(U2) + H(L1,J)
      G(L,J) = G(L,J) + TG*V1
      H(L,J) = H(L,J) + TH*V1
      G(L1,J) = G(L1,J) + TG*V2
      H(L1,J) = H(L1,J) + TH*V2
    END DO
!     ********** ZERO B(L+1,L) **********
200 S = CABS(B(L1,L1)) + CABS(B(L1,L))
    IF (S.EQ.0.0) GO TO 240
    U1 = B(L1,L1)/CMPLX(S,0.0)
    U2 = B(L1,L)/CMPLX(S,0.0)
    R = SQRT(CABS(U1)**2+CABS(U2)**2)
    RR = CMPLX(R,0.0)
    IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
    V1 = -(U1+RR)/RR
    V2 = -U2/RR
    U2 = V2/V1
    DO I=1,L1
      T = B(I,L1) + CONJG(U2)*B(I,L)
      B(I,L1) = B(I,L1) + T*V1
      B(I,L) = B(I,L) + T*V2
    END DO
    B(L1,L) = CMPLX(0.0,0.0)
    DO I=1,N
      T = A(I,L1) + CONJG(U2)*A(I,L)
      A(I,L1) = A(I,L1) + T*V1
      A(I,L) = A(I,L) + T*V2
    END DO
    IF (MATS.EQ.0) GO TO 240
    DO I=1,N
      T = Z(I,L1) + CONJG(U2)*Z(I,L)
      Z(I,L1) = Z(I,L1) + T*V1
      Z(I,L) = Z(I,L) + T*V2
    END DO
240 CONTINUE
END DO
260 RETURN
END SUBROUTINE CQZHES

SUBROUTINE CQZIT(NM, N, A, B, EPS1, MATS, Z, F, IERR)
!
!
!     SUBROUTINE CQZIT IS A MODIFICATION OF THE EISPACK SUBROUTINE
!     QZIT.  ALL OPERATIONS ARE PERFORMED IN COMPLEX ARITHMETIC,
!     AND THE LEFT TRANSFORMATIONS MAY ALSO BE APPLIED TO AN AUXILIARY
!     MATRIX F.
!
!
!     ON ENTRY,
!
!     NM   IS THE LEADING DIMENSION OF THE MATRICES A AND B IN
!          THE MAIN PROGRAM.
!
!     N    IS THE ORDER OF THE MATRICES A AND B.
!
!     A    CONTAINS AN UPPER HESSENBERG MATRIX FROM CQZHES.
!
!     B    CONTAINS AN UPPER TRIANGULAR MATRIX FROM CQZHES.
!
!     EPS1 IS A REAL NUMBER DEFINING THE TOLERANCE USED TO DETERMINE
!          NEGLIGIBLE ELEMENTS OF A AND B IN THE COURSE OF THE ALG-
!          ORITHM.  AN ELEMENT OF EITHER MATRIX WILL BE CONSIDERED
!          NEGLIGIBLE AND RESET TO ZERO IF IT IS NOT LARGER THAN THE
!          PRODUCT OF EPS1 AND THE NORM OF THE MATRIX.  IF EPS1.LE.0,
!          RELATIVE MACHINE PRECISION WILL BE COMPUTED AND
!          USED INSTEAD.
!
!     MATS IS AN INTEGER INPUT VARIABLE.  IT IS SET PRIOR
!          TO THE CALL TO CQZHES.
!
!     F    CONTAINS AN AUXILIARY MATRIX.
!
!
!     ON RETURN,
!
!     A    IS UPPER TRIANGULAR.
!
!     B    IS UPPER TRIANGULAR.
!
!     Z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
!
!     F    CONTAINS THE AUXILIARY MATRIX, UPDATED IF DESIRED.
!
!     IERR IS AN INTEGER ERROR RETURN WHICH INDICATES FAILURE
!          OF THE QZ ALGORITHM TO REDUCE A SUBDIAGONAL ELEMENT
!          TO ZERO AFTER 50 ITERATIONS.
!
INTEGER I, J, K, L, N, EN, JJ, K1, K2, LD, LL, L1, NA, NM, ISH, &
&ITS, KM1, LM1
INTEGER ENM2, IERR, LOR1, ENORN
COMPLEX A(NM,N), B(NM,N), Z(NM,N)
COMPLEX A11, A21, A33, A34, A43, A44, B11, B22, B33, B34, B44
COMPLEX A1, A2, U1, U2, V1, V2, T, RR, SH, SS
COMPLEX F(NM,N), TF
REAL EPS1, EPSA, EPSB, ANORM, BNORM, ANI, BNI, SRELPR, R, S
INTEGER MATS
REAL SPMPAR
!     INTEGER MAX0, MIN0
!     REAL SQRT, CABS
!     COMPLEX CMPLX, CONJG, CSQRT
IERR = 0
!     ********** COMPUTE EPSA, EPSB **********
ANORM = 0.0
BNORM = 0.0
do 20 I = 1,N
  ANI = 0.0
  IF (I.NE.1) ANI = CABS(A(I,I-1))
  BNI = 0.0
  do 10 J = I,N
    ANI = ANI + CABS(A(I,J))
    BNI = BNI + CABS(B(I,J))
10 CONTINUE
  IF (ANI.GT.ANORM) ANORM = ANI
  IF (BNI.GT.BNORM) BNORM = BNI
20 CONTINUE
IF (ANORM.EQ.0.0) ANORM = 1.0
IF (BNORM.EQ.0.0) BNORM = 1.0
SRELPR = EPS1
IF (SRELPR.GT.0.0) GO TO 40
!
!     ***** WHEN EPS1 = 0 THEN SET SRELPR TO BE THE SMALLEST
!           NUMBER FOR WHICH 1 + SRELPR .GT. 1 *****
!
SRELPR = SPMPAR(1)
!
40 EPSA = SRELPR*ANORM
EPSB = SRELPR*BNORM
!     ********** REDUCE A TO TRIANGULAR FORM, WHILE
!                KEEPING B TRIANGULAR **********
LOR1 = 1
ENORN = N
EN = N
!     ********** BEGIN QZ STEP **********
50 IF (EN.LE.1) GO TO 220
IF (MATS.EQ.0) ENORN = EN
ITS = 0
NA = EN - 1
ENM2 = NA - 1
60 ISH = 1
!     ********** CHECK FOR CONVERGENCE OR REDUCIBILITY **********
DO LL=1,EN
  LM1 = EN - LL
  L = LM1 + 1
  IF (L.EQ.1) GO TO 90
  IF (CABS(A(L,LM1)).LE.EPSA) GO TO 80
END DO
80 A(L,LM1) = CMPLX(0.0,0.0)
IF (L.LT.NA) GO TO 90
!     ********** 1-BY-1 BLOCK ISOLATED **********
EN = LM1
GO TO 50
!     ********** CHECK FOR SMALL TOP OF B **********
90 LD = L
L1 = L + 1
B11 = B(L,L)
IF (CABS(B11).GT.EPSB) GO TO 120
B(L,L) = CMPLX(0.0,0.0)
S = CABS(A(L,L)) + CABS(A(L1,L))
U1 = A(L,L)/CMPLX(S,0.0)
U2 = A(L1,L)/CMPLX(S,0.0)
R = SQRT(CABS(U1)**2+CABS(U2)**2)
RR = CMPLX(R,0.0)
IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
V1 = -(U1+RR)/RR
V2 = -U2/RR
U2 = V2/V1
do 110 J = L,ENORN
  T = A(L,J) + CONJG(U2)*A(L1,J)
  A(L,J) = A(L,J) + T*V1
  A(L1,J) = A(L1,J) + T*V2
  T = B(L,J) + CONJG(U2)*B(L1,J)
  B(L,J) = B(L,J) + T*V1
  B(L1,J) = B(L1,J) + T*V2
  IF (MATS.EQ.3) GO TO 110
  DO JJ=1,N
    TF = F(L,JJ) + CONJG(U2)*F(L1,JJ)
    F(L,JJ) = F(L,JJ) + TF*V1
    F(L1,JJ) = F(L1,JJ) + TF*V2
  END DO
110 CONTINUE
IF (L.NE.1) A(L,LM1) = -A(L,LM1)
LM1 = L
L = L1
GO TO 80
120 A11 = A(L,L)/B11
A21 = A(L1,L)/B11
!     ********** ITERATION STRATEGY **********
IF (ITS.EQ.50) GO TO 210
!     ********** DETERMINE SHIFT **********
B22 = B(L1,L1)
IF (CABS(B22).LT.EPSB) B22 = CMPLX(EPSB,0.0)
B33 = B(NA,NA)
IF (CABS(B33).LT.EPSB) B33 = CMPLX(EPSB,0.0)
B44 = B(EN,EN)
IF (CABS(B44).LT.EPSB) B44 = CMPLX(EPSB,0.0)
A33 = A(NA,NA)/B33
A34 = A(NA,EN)/B44
A43 = A(EN,NA)/B33
A44 = A(EN,EN)/B44
B34 = B(NA,EN)/B44
T = CMPLX(0.5,0.0)*(A43*B34-A33-A44)
RR = T*T + A34*A43 - A33*A44
!     ********** DETERMINE SINGLE SHIFT ZEROTH COLUMN OF A **********
RR = CSQRT(RR)
SH = -T + RR
SS = -T - RR
IF (CABS(SS-A44).LT.CABS(SH-A44)) SH = SS
A1 = A11 - SH
A2 = A21
IF (L.NE.LD) A(L,LM1) = -A(L,LM1)
IF (ITS.NE.10) GO TO 130
A1 = CMPLX(1.0,0.0)
A2 = CMPLX(1.1605,0.0)
130 ITS = ITS + 1
IF (MATS.EQ.0) LOR1 = LD
!     ********** MAIN LOOP **********
do 200 K = L,NA
  K1 = K + 1
  K2 = K + 2
  KM1 = MAX0(K-1,L)
  LL = MIN0(EN,K1+ISH)
!     ********** ZERO A(K+1,K-1) **********
  IF (K.EQ.L) GO TO 140
  A1 = A(K,KM1)
  A2 = A(K1,KM1)
140 S = CABS(A1) + CABS(A2)
  IF (S.EQ.0.0) GO TO 60
  U1 = A1/CMPLX(S,0.0)
  U2 = A2/CMPLX(S,0.0)
  R = SQRT(CABS(U1)**2+CABS(U2)**2)
  RR = CMPLX(R,0.0)
  IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
  V1 = -(U1+RR)/RR
  V2 = -U2/RR
  U2 = V2/V1
  DO J=KM1,ENORN
    T = A(K,J) + CONJG(U2)*A(K1,J)
    A(K,J) = A(K,J) + T*V1
    A(K1,J) = A(K1,J) + T*V2
    T = B(K,J) + CONJG(U2)*B(K1,J)
    B(K,J) = B(K,J) + T*V1
    B(K1,J) = B(K1,J) + T*V2
  END DO
  IF (K.NE.L) A(K1,KM1) = CMPLX(0.0,0.0)
  IF (MATS.EQ.3) GO TO 170
  DO J=1,N
    TF = F(K,J) + CONJG(U2)*F(K1,J)
    F(K,J) = F(K,J) + TF*V1
    F(K1,J) = F(K1,J) + TF*V2
  END DO
!     ********** ZERO B(K+1,K) **********
170 S = CABS(B(K1,K1)) + CABS(B(K1,K))
  IF (S.EQ.0.0) GO TO 200
  U1 = B(K1,K1)/CMPLX(S,0.0)
  U2 = B(K1,K)/CMPLX(S,0.0)
  R = SQRT(CABS(U1)**2+CABS(U2)**2)
  RR = CMPLX(R,0.0)
  IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
  V1 = -(U1+RR)/RR
  V2 = -U2/RR
  U2 = V2/V1
  DO I=LOR1,LL
    T = A(I,K1) + CONJG(U2)*A(I,K)
    A(I,K1) = A(I,K1) + T*V1
    A(I,K) = A(I,K) + T*V2
    T = B(I,K1) + CONJG(U2)*B(I,K)
    B(I,K1) = B(I,K1) + T*V1
    B(I,K) = B(I,K) + T*V2
  END DO
  B(K1,K) = CMPLX(0.0,0.0)
  IF (MATS.EQ.0) GO TO 200
  DO I=1,N
    T = Z(I,K1) + CONJG(U2)*Z(I,K)
    Z(I,K1) = Z(I,K1) + T*V1
    Z(I,K) = Z(I,K) + T*V2
  END DO
200 CONTINUE
!     ********** END QZ STEP **********
GO TO 60
!     ********** SET ERROR -- NEITHER BOTTOM SUBDIAGONAL ELEMENT
!                HAS BECOME NEGLIGIBLE AFTER 50 ITERATIONS **********
210 IERR = EN
!     ********** SAVE EPSB FOR USE BY CQZVEC **********
220 IF (N.GT.1) B(N,1) = CMPLX(EPSB,0.0)
RETURN
END SUBROUTINE CQZIT

SUBROUTINE TRISLV(NM, N, U, V, L, F, TEMP, IERR)
!
!
!     SUBROUTINE TRISLV BACKSOLVES A SYSTEM OF THE FORM
!     UY + VYL = F, WHERE U AND V ARE UPPER TRIANGULAR, AND
!     L IS LOWER TRIANGULAR.
!
!
!     ON ENTRY,
!
!     NM   IS THE LEADING DIMENSION OF THE MATRICES U, V, L AND F IN
!          THE MAIN PROGRAM.
!
!     N    IS THE ORDER OF THE MATRICES U, V, L AND F.
!
!     U    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
!          COEFFICIENT OF Y IN THE FIRST TERM IN UY + VYL.
!
!     V    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
!          COEFFICIENT OF Y IN THE SECOND TERM OF UY + VYL.
!
!     L    CONTAINS A LOWER TRIANGULAR MATRIX.  IT IS THE RIGHT
!          COEFFICIENT OF Y IN THE SECOND TERM OF UY + VYL.
!
!     F    CONTAINS THE RIGHT HAND SIDE OF UY + VYL = F.
!
!     TEMP CONTAINS A WORK VECTOR OF LENGTH AT LEAST N.
!
!     ON RETURN,
!
!     F    CONTAINS THE SOLUTION Y.
!
!     IERR IS AN ERROR RETURN DESIGNATING INCONSISTENCY OF THE
!          ORIGINAL SYSTEM.
!          IERR.EQ.0 FOR A NORMAL RETURN.
!          IERR.EQ.1 IF THE TRIANGULAR SYSTEM IS INCONSISTENT.
!
!
INTEGER I, IERR, J, JP1, K, KK, KM1, M, N, NM, NM1
COMPLEX U(NM,N), V(NM,N), L(NM,N), F(NM,N)
COMPLEX TEMP(N)
COMPLEX DENOM, SUM
REAL S, T
!     REAL CABS
!     COMPLEX CMPLX
IERR = 0
NM1 = N - 1
DO KK=1,N
!        ********** BACKSUBSTITUTE FOR ROW K. **********
  K = N - KK + 1
  IF (CABS(F(K,N)).NE.0.0) GO TO 10
  F(K,N) = CMPLX(0.0,0.0)
  GO TO 30
10 DENOM = U(K,K) + V(K,K)*L(N,N)
  S = CABS(DENOM)
  T = 1.0 + S/CABS(F(K,N))
  IF (T.GT.1.0) GO TO 20
  IERR = 1
  RETURN
20 F(K,N) = F(K,N)/DENOM
  IF (N.EQ.1) RETURN
30 do 70 I = 1,NM1
    J = N - I
    JP1 = J + 1
    SUM = CMPLX(0.0,0.0)
    DO M=JP1,N
      SUM = SUM + F(K,M)*L(M,J)
    END DO
    SUM = F(K,J) - V(K,K)*SUM
    IF (CABS(SUM).NE.0.0) GO TO 50
    F(K,J) = CMPLX(0.0,0.0)
    GO TO 70
50 DENOM = U(K,K) + V(K,K)*L(J,J)
    S = CABS(DENOM)
    T = 1.0 + S/CABS(SUM)
    IF (T.GT.1.0) GO TO 60
    IERR = 1
    RETURN
60 F(K,J) = SUM/DENOM
70 CONTINUE
!        ********** FORM TEMP = YK-TRANS*L. **********
  IF (K.EQ.1) RETURN
  KM1 = K - 1
  DO I=1,N
    TEMP(I) = CMPLX(0.0,0.0)
    DO J=1,N
      TEMP(I) = TEMP(I) + F(K,J)*L(J,I)
    END DO
  END DO
!        ********** PREPARE F' WHICH IS (K-1) BY N. **********
  DO I=1,KM1
    DO J=1,N
      F(I,J) = F(I,J) - U(I,K)*F(K,J) - V(I,K)*TEMP(J)
    END DO
  END DO
END DO
RETURN
END SUBROUTINE TRISLV

SUBROUTINE MEXP (A, KA, N, Z, KZ, WK, IERR)
REAL A(KA,N),Z(KZ,N),WK(N,*),C(8)
! ----------------------------------------------------------------------
!     MEXP COMPUTES EXP(A) AND STORES IT IN Z WHERE A IS A MATRIX
!     OF ORDER N. A IS DESTROYED BY THE ROUTINE.
!
!     WK IS AN ARRAY OF DIMENSION (N,N+8). WK IS A WORK SPACE
!     FOR THE ROUTINE.
!
!     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
!        IERR = 0  EXP(A) WAS SUCCESSFULLY COMPUTED.
!        IERR = 1  THE NORM OF A IS TOO LARGE.
!        IERR = 2  THE PADE DENOMINATOR MATRIX IS
!                  SINGULAR.
!
!     WRITTEN BY ALFRED H. MORRIS
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN VIRGINIA
!     ---------------
!     COEFFICIENTS FOR (8,8) PADE TABLE ENTRY
!     ---------------
DATA C(1)/.500000000000000E+00/, C(2)/.116666666666667E+00/, &
&C(3)/.166666666666667E-01/, C(4)/.160256410256410E-02/, &
&C(5)/.106837606837607E-03/, C(6)/.485625485625486E-05/, &
&C(7)/.138750138750139E-06/, C(8)/.192708526041859E-08/
! ----------------------------------------------------------------------
IERR = 0
IF (N .GT. 1) GO TO 10
   Z(1,1) = EXP(A(1,1))
   RETURN
!
!       BALANCE A AND SELECT THE SMALLER OF THE 1-NORM
!              AND INFINITY-NORM OF THE RESULT
!
10 CALL BALANC (KA,N,A,LOW,IGH,WK(1,N+8))
ANORM = 0.0
ANORM1 = 0.0
do 12 J = 1,N
S = 0.0
S1 = 0.0
   do 11 I = 1,N
   S = S + ABS(A(J,I))
11 S1 = S1 + ABS(A(I,J))
ANORM = AMAX1(S,ANORM)
12 ANORM1 = AMAX1(S1,ANORM1)
!
ANORM = AMIN1(ANORM,ANORM1)
S = ANORM + 0.1
IF (S .EQ. ANORM) GO TO 200
!
!              SELECT THE NORMALIZATION FACTOR
!
M = 0
IF (ANORM .LE. 1.0)  GO TO 40
FACTOR = 1.0
20 M = M + 1
FACTOR = 2.0*FACTOR
IF (ANORM .GT. FACTOR) GO TO 20
!
!                NORMALIZE THE MATRIX A
!
DO J = 1,N
   do 30 I = 1,N
30 A(I,J) = A(I,J)/FACTOR
END DO
!
40 NP1 = N + 1
NP6 = N + 6
DO J = 1,N
!
!     COMPUTE THE J-TH COLUMN OF FIRST EIGHT POWERS OF A
!
   do 51 I = 1,N
   S = 0.0
      do 50 L = 1,N
50 S = S + A(I,L)*A(L,J)
51 WK(I,NP1) = S
!
   DO K = NP1,NP6
   KP1 = K + 1
      do 61 I = 1,N
      S = 0.0
         do 60 L = 1,N
60 S = S + A(I,L)*WK(L,K)
61 WK(I,KP1) = S
   END DO
!
!     COMPUTE THE J-TH COLUMN OF THE NUMERATOR AND DENOMINATOR
!                  OF THE PADE APPROXIMATION
!
   do 90 I = 1,N
   P = 0.0
   Q = 0.0
   K = 8
   L = N + 7
      do 80 LL = 1,7
      S = C(K)*WK(I,L)
      P = S + P
      Q = S - Q
      K = K - 1
80 L = L - 1
   S = C(1)*A(I,J)
   Z(I,J) = P + S
   WK(I,J) = Q - S
   IF (I .NE. J) GO TO 90
      Z(I,J) = Z(I,J) + 1.0
      WK(I,J) = WK(I,J) + 1.0
90 CONTINUE
END DO
!
!        CALCULATE EXP(A) BY SOLVING  WK * EXP(A) = Z
!
CALL SLV (N, N, WK, N, Z, KZ, IERR)
IF (IERR .NE. 0) GO TO 210
IF (M .EQ. 0)  GO TO 150
!
!          TAKE OUT THE EFFECT OF THE NORMALIZATION
!                   OPERATION ON EXP(A)
!
DO K = 1,M
   DO J = 1,N
      do 120 I = 1,N
      S = 0.0
         do 110 L = 1,N
110 S = S + Z(I,L)*Z(L,J)
120 WK(I,J) = S
   END DO
!
   DO J = 1,N
      do 130 I = 1,N
130 Z(I,J) = WK(I,J)
   END DO
END DO
!
!            TAKE OUT THE EFFECT OF THE BALANCING
!                   OPERATION ON EXP(A)
!
150 CALL BALINV (KZ,N,Z,LOW,IGH,WK(1,N+8))
RETURN
!
!                     ERROR RETURN
!
200 IERR = 1
RETURN
210 IERR = 2
RETURN
END SUBROUTINE MEXP

SUBROUTINE DMEXP (A, KA, N, Z, KZ, WK, IERR)
DOUBLE PRECISION A(KA,N),Z(KZ,N),WK(N,*)
DOUBLE PRECISION ANORM,ANORM1,C(12),FACTOR,P,Q,S,S1
! ----------------------------------------------------------------------
!     DMEXP COMPUTES EXP(A) AND STORES IT IN Z WHERE A IS A MATRIX
!     OF ORDER N. A IS DESTROYED BY THE ROUTINE.
!
!     WK IS AN ARRAY OF DIMENSION (N,N+12). WK IS A WORK SPACE
!     FOR THE ROUTINE.
!
!     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
!        IERR = 0  EXP(A) WAS SUCCESSFULLY COMPUTED.
!        IERR = 1  THE NORM OF A IS TOO LARGE.
!        IERR = 2  THE PADE DENOMINATOR MATRIX IS
!                  SINGULAR.
!
!     WRITTEN BY ALFRED H. MORRIS
!        NAVAL SURFACE WEAPONS CENTER
!        DAHLGREN VIRGINIA
!     ---------------
!     COEFFICIENTS FOR (12,12) PADE TABLE ENTRY
!     ---------------
DATA C(1) /.500000000000000000000000000000D+00/, &
&C(2) /.119565217391304347826086956522D+00/, &
&C(3) /.181159420289855072463768115942D-01/, &
&C(4) /.194099378881987577639751552795D-02/, &
&C(5) /.155279503105590062111801242236D-03/, &
&C(6) /.953470633104500381388253241800D-05/, &
&C(7) /.454033634811666848280120591333D-06/, &
&C(8) /.166924130445465753044161982108D-07/, &
&C(9) /.463678140126293758456005505855D-09/
DATA C(10)/.927356280252587516912011011710D-11/, &
&C(11)/.120435880552284093105455975547D-12/, &
&C(12)/.772024875335154442983692150941D-15/
! ----------------------------------------------------------------------
IERR = 0
IF (N .GT. 1) GO TO 10
   Z(1,1) = DEXP(A(1,1))
   RETURN
!
!       BALANCE A AND SELECT THE SMALLER OF THE 1-NORM
!              AND INFINITY-NORM OF THE RESULT
!
10 CALL DBAL (KA,N,A,LOW,IGH,WK(1,N+12))
ANORM = 0.D0
ANORM1 = 0.D0
do 12 J = 1,N
S = 0.D0
S1 = 0.D0
   do 11 I = 1,N
   S = S + DABS(A(J,I))
11 S1 = S1 + DABS(A(I,J))
ANORM = DMAX1(S,ANORM)
12 ANORM1 = DMAX1(S1,ANORM1)
!
ANORM = DMIN1(ANORM,ANORM1)
S = ANORM + 0.1D0
IF (S .EQ. ANORM) GO TO 200
!
!              SELECT THE NORMALIZATION FACTOR
!
M = 0
IF (ANORM .LE. 1.D0)  GO TO 40
FACTOR = 1.D0
20 M = M + 1
FACTOR = 2.D0*FACTOR
IF (ANORM .GT. FACTOR) GO TO 20
!
!                NORMALIZE THE MATRIX A
!
DO J = 1,N
   do 30 I = 1,N
30 A(I,J) = A(I,J)/FACTOR
END DO
!
40 NP1 = N + 1
NP10 = N + 10
DO J = 1,N
!
!     COMPUTE THE J-TH COLUMN OF THE FIRST 12 POWERS OF A
!
   do 51 I = 1,N
   S = 0.D0
      do 50 L = 1,N
50 S = S + A(I,L)*A(L,J)
51 WK(I,NP1) = S
!
   DO K = NP1,NP10
   KP1 = K + 1
      do 61 I = 1,N
      S = 0.D0
         do 60 L = 1,N
60 S = S + A(I,L)*WK(L,K)
61 WK(I,KP1) = S
   END DO
!
!     COMPUTE THE J-TH COLUMN OF THE NUMERATOR AND DENOMINATOR
!                  OF THE PADE APPROXIMATION
!
   do 90 I = 1,N
   P = 0.D0
   Q = 0.D0
   K = 12
   L = N + 11
      do 80 LL = 1,11
      S = C(K)*WK(I,L)
      P = S + P
      Q = S - Q
      K = K - 1
80 L = L - 1
   S = C(1)*A(I,J)
   Z(I,J) = P + S
   WK(I,J) = Q - S
   IF (I .NE. J) GO TO 90
      Z(I,J) = Z(I,J) + 1.D0
      WK(I,J) = WK(I,J) + 1.D0
90 CONTINUE
END DO
!
!        CALCULATE EXP(A) BY SOLVING  WK * EXP(A) = Z
!
CALL DPSLV (N, N, WK, N, Z, KZ, IERR)
IF (IERR .NE. 0) GO TO 210
IF (M .EQ. 0)  GO TO 150
!
!          TAKE OUT THE EFFECT OF THE NORMALIZATION
!                   OPERATION ON EXP(A)
!
DO K = 1,M
   DO J = 1,N
      do 120 I = 1,N
      S = 0.D0
         do 110 L = 1,N
110 S = S + Z(I,L)*Z(L,J)
120 WK(I,J) = S
   END DO
!
   DO J = 1,N
      do 130 I = 1,N
130 Z(I,J) = WK(I,J)
   END DO
END DO
!
!            TAKE OUT THE EFFECT OF THE BALANCING
!                   OPERATION ON EXP(A)
!
150 CALL DBALNV (KZ,N,Z,LOW,IGH,WK(1,N+12))
RETURN
!
!                     ERROR RETURN
!
200 IERR = 1
RETURN
210 IERR = 2
RETURN
END SUBROUTINE DMEXP

SUBROUTINE LE (ROWK,N,B,C,D,IP,IERR)
!     ******************************************************************
!     SOLUTION OF LINEAR EQUATIONS WITH REDUCED STORAGE
!     ******************************************************************
REAL B(N),C(N),D(*)
INTEGER IP(*)
EXTERNAL ROWK
DATA ZERO/0.0/
!
!     SET THE NECESSARY CONSTANTS
!
IERR = 0
NP1 = N + 1
MAX = N*N/4 + N + 3
K = 1
IFLAG = -1
!
!     GET THE FIRST COLUMN OF THE TRANSPOSED SYSTEM
!
CALL ROWK(N,1,C)
BK = B(1)
!
IF (N .GT. 1) GO TO 10
IF (C(1) .EQ. ZERO) GO TO 200
C(1) = BK/C(1)
RETURN
!
!     FIND THE PIVOT FOR COLUMN 1
!
10 M = 1
DO I = 2,N
IF (ABS(C(M)) .LT. ABS(C(I))) M = I
END DO
!
IP(1) = M
C1 = C(M)
C(M) = C(1)
C(1) = C1
IF (C(1) .EQ. ZERO) GO TO 200
!
!     FIND THE FIRST ELEMENTARY MATRIX AND STORE IT IN D
!
do 30 I = 2,N
30 D(I-1) = -C(I)/C(1)
D(N) = BK/C(1)
!
!     K LOOP - EACH K FOR A NEW COLUMN OF THE TRANSPOSED SYSTEM
!
DO K = 2,N
KP1 = K + 1
KM1 = K - 1
!
!       GET COLUMN K
!
CALL ROWK(N,K,C)
do 40 J = 1,KM1
M = IP(J)
CJ = C(J)
C(J) = C(M)
40 C(M) = CJ
BK = B(K)
!
IFLAG = -IFLAG
LCOL = NP1 - K
LCOLP1 = LCOL + 1
LASTM1 = 1
LAST = MAX - N + K
IF (K .EQ. 2) GO TO 50
!
LASTM1 = MAX - N + KM1
IF (IFLAG .LT. 0) LAST = LAST - N + K - 2
IF (IFLAG .GT. 0) LASTM1 = LASTM1 - N + K - 3
!
!     J LOOP - EFFECT OF COLUMNS 1 TO K-1 OF L-INVERSE
!
50 do 61 J = 1,KM1
CJ = C(J)
IJ = (J-1)*LCOLP1
IF (J .EQ. KM1) IJ = LASTM1 - 1
!
!     I LOOP - EFFECT OF L-INVERSE ON ROWS K TO N+1
!
do 60 I = K,N
IJ = IJ + 1
60 C(I) = C(I) + D(IJ)*CJ
61 BK = BK - D(IJ+1)*CJ
!
!       K=N CASE
!
M = K
IF (K .LT. N) GO TO 70
IF (C(K) .EQ. ZERO) GO TO 200
D(LAST) = BK/C(K)
GO TO 90
!
!     FIND THE PIVOT
!
70 DO I = KP1,N
IF (ABS(C(M)) .LT. ABS(C(I))) M = I
END DO
!
IP(K) = M
CK = C(M)
C(M) = C(K)
C(K) = CK
IF (C(K) .EQ. ZERO) GO TO 200
!
!     FIND THE K-TH ELEMENTARY MATRIX
!
IK = LAST
do 80 I = KP1,N
D(IK) = -C(I)/C(K)
80 IK = IK + 1
D(IK) = BK/C(K)
!
!     FORM THE PRODUCT OF THE ELEMENTARY MATRICES
!
90 do 110 J = 1,KM1
KJOLD = J*LCOLP1 + K - NP1
MJOLD = KJOLD + M - K
IJ = (J-1)*LCOL
IJOLD = IJ + J
IF (J .NE. KM1) GO TO 100
!
KJOLD = LASTM1
MJOLD = LASTM1 + M - K
IJOLD = LASTM1
!
100 IK = LAST - 1
DKJ = D(MJOLD)
D(MJOLD) = D(KJOLD)
do 110 I = KP1,NP1
IJ = IJ + 1
IJOLD = IJOLD + 1
IK = IK + 1
D(IJ) = D(IJOLD) + D(IK)*DKJ
110 CONTINUE
END DO
!
LAST = MAX
IF (IFLAG .LT. 0) LAST = MAX - 2
D(N) = D(LAST)
!
!     INSERT THE SOLUTION IN C
!
do 130 I = 1,N
130 C(I) = D(I)
!
NM1 = N - 1
do 140 I = 1,NM1
K = N - I
M = IP(K)
CK = C(K)
C(K) = C(M)
140 C(M) = CK
RETURN
!
!     THE SYSTEM IS SINGULAR
!
200 IERR = K
RETURN
END SUBROUTINE LE

SUBROUTINE DPLE (ROWK,N,B,C,D,IP,IERR)
!     ******************************************************************
!     SOLUTION OF LINEAR EQUATIONS WITH REDUCED STORAGE
!     ******************************************************************
DOUBLE PRECISION B(N),C(N),D(*)
INTEGER IP(*)
DOUBLE PRECISION BK,CJ,CK,C1,DKJ,ZERO
EXTERNAL ROWK
DATA ZERO/0.D0/
!
!     SET THE NECESSARY CONSTANTS
!
IERR = 0
NP1 = N + 1
MAX = N*N/4 + N + 3
K = 1
IFLAG = -1
!
!     GET THE FIRST COLUMN OF THE TRANSPOSED SYSTEM
!
CALL ROWK(N,1,C)
BK = B(1)
!
IF (N .GT. 1) GO TO 10
IF (C(1) .EQ. ZERO) GO TO 200
C(1) = BK/C(1)
RETURN
!
!     FIND THE PIVOT FOR COLUMN 1
!
10 M = 1
DO I = 2,N
IF (DABS(C(M)) .LT. DABS(C(I))) M = I
END DO
!
IP(1) = M
C1 = C(M)
C(M) = C(1)
C(1) = C1
IF (C(1) .EQ. ZERO) GO TO 200
!
!     FIND THE FIRST ELEMENTARY MATRIX AND STORE IT IN D
!
do 30 I = 2,N
30 D(I-1) = -C(I)/C(1)
D(N) = BK/C(1)
!
!     K LOOP - EACH K FOR A NEW COLUMN OF THE TRANSPOSED SYSTEM
!
DO K = 2,N
KP1 = K + 1
KM1 = K - 1
!
!       GET COLUMN K
!
CALL ROWK(N,K,C)
do 40 J = 1,KM1
M = IP(J)
CJ = C(J)
C(J) = C(M)
40 C(M) = CJ
BK = B(K)
!
IFLAG = -IFLAG
LCOL = NP1 - K
LCOLP1 = LCOL + 1
LASTM1 = 1
LAST = MAX - N + K
IF (K .EQ. 2) GO TO 50
!
LASTM1 = MAX - N + KM1
IF (IFLAG .LT. 0) LAST = LAST - N + K - 2
IF (IFLAG .GT. 0) LASTM1 = LASTM1 - N + K - 3
!
!     J LOOP - EFFECT OF COLUMNS 1 TO K-1 OF L-INVERSE
!
50 do 61 J = 1,KM1
CJ = C(J)
IJ = (J-1)*LCOLP1
IF (J .EQ. KM1) IJ = LASTM1 - 1
!
!     I LOOP - EFFECT OF L-INVERSE ON ROWS K TO N+1
!
do 60 I = K,N
IJ = IJ + 1
60 C(I) = C(I) + D(IJ)*CJ
61 BK = BK - D(IJ+1)*CJ
!
!       K=N CASE
!
M = K
IF (K .LT. N) GO TO 70
IF (C(K) .EQ. ZERO) GO TO 200
D(LAST) = BK/C(K)
GO TO 90
!
!     FIND THE PIVOT
!
70 DO I = KP1,N
IF (DABS(C(M)) .LT. DABS(C(I))) M = I
END DO
!
IP(K) = M
CK = C(M)
C(M) = C(K)
C(K) = CK
IF (C(K) .EQ. ZERO) GO TO 200
!
!     FIND THE K-TH ELEMENTARY MATRIX
!
IK = LAST
do 80 I = KP1,N
D(IK) = -C(I)/C(K)
80 IK = IK + 1
D(IK) = BK/C(K)
!
!     FORM THE PRODUCT OF THE ELEMENTARY MATRICES
!
90 do 110 J = 1,KM1
KJOLD = J*LCOLP1 + K - NP1
MJOLD = KJOLD + M - K
IJ = (J-1)*LCOL
IJOLD = IJ + J
IF (J .NE. KM1) GO TO 100
!
KJOLD = LASTM1
MJOLD = LASTM1 + M - K
IJOLD = LASTM1
!
100 IK = LAST - 1
DKJ = D(MJOLD)
D(MJOLD) = D(KJOLD)
do 110 I = KP1,NP1
IJ = IJ + 1
IJOLD = IJOLD + 1
IK = IK + 1
D(IJ) = D(IJOLD) + D(IK)*DKJ
110 CONTINUE
END DO
!
LAST = MAX
IF (IFLAG .LT. 0) LAST = MAX - 2
D(N) = D(LAST)
!
!     INSERT THE SOLUTION IN C
!
do 130 I = 1,N
130 C(I) = D(I)
!
NM1 = N - 1
do 140 I = 1,NM1
K = N - I
M = IP(K)
CK = C(K)
C(K) = C(M)
140 C(M) = CK
RETURN
!
!     THE SYSTEM IS SINGULAR
!
200 IERR = K
RETURN
END SUBROUTINE DPLE

SUBROUTINE CLE (ROWK,N,B,C,D,IP,IERR)
!     ******************************************************************
!     SOLUTION OF COMPLEX LINEAR EQUATIONS WITH REDUCED STORAGE
!     ******************************************************************
COMPLEX B(N),C(N),D(*)
INTEGER IP(*)
COMPLEX BK,CJ,CK,C1,DKJ,ZERO
EXTERNAL ROWK
DATA ZERO/(0.0,0.0)/
!
!     SET THE NECESSARY CONSTANTS
!
IERR = 0
NP1 = N + 1
MAX = N*N/4 + N + 3
K = 1
IFLAG = -1
!
!     GET THE FIRST COLUMN OF THE TRANSPOSED SYSTEM
!
CALL ROWK(N,1,C)
BK = B(1)
!
IF (N .GT. 1) GO TO 10
IF (C(1) .EQ. ZERO) GO TO 200
C(1) = BK/C(1)
RETURN
!
!     FIND THE PIVOT FOR COLUMN 1
!
10 M = 1
S = ABS(REAL(C(1))) + ABS(AIMAG(C(1)))
do 20 I = 2,N
SI = ABS(REAL(C(I))) + ABS(AIMAG(C(I)))
IF (SI .LE. S) GO TO 20
M = I
S = SI
20 CONTINUE
!
IP(1) = M
C1 = C(M)
C(M) = C(1)
C(1) = C1
IF (C(1) .EQ. ZERO) GO TO 200
!
!     FIND THE FIRST ELEMENTARY MATRIX AND STORE IT IN D
!
do 30 I = 2,N
30 D(I-1) = -C(I)/C(1)
D(N) = BK/C(1)
!
!     K LOOP - EACH K FOR A NEW COLUMN OF THE TRANSPOSED SYSTEM
!
DO K = 2,N
KP1 = K + 1
KM1 = K - 1
!
!       GET COLUMN K
!
CALL ROWK(N,K,C)
do 40 J = 1,KM1
M = IP(J)
CJ = C(J)
C(J) = C(M)
40 C(M) = CJ
BK = B(K)
!
IFLAG = -IFLAG
LCOL = NP1 - K
LCOLP1 = LCOL + 1
LASTM1 = 1
LAST = MAX - N + K
IF (K .EQ. 2) GO TO 50
!
LASTM1 = MAX - N + KM1
IF (IFLAG .LT. 0) LAST = LAST - N + K - 2
IF (IFLAG .GT. 0) LASTM1 = LASTM1 - N + K - 3
!
!     J LOOP - EFFECT OF COLUMNS 1 TO K-1 OF L-INVERSE
!
50 do 61 J = 1,KM1
CJ = C(J)
IJ = (J-1)*LCOLP1
IF (J .EQ. KM1) IJ = LASTM1 - 1
!
!     I LOOP - EFFECT OF L-INVERSE ON ROWS K TO N+1
!
do 60 I = K,N
IJ = IJ + 1
60 C(I) = C(I) + D(IJ)*CJ
61 BK = BK - D(IJ+1)*CJ
!
!       K=N CASE
!
M = K
IF (K .LT. N) GO TO 70
IF (C(K) .EQ. ZERO) GO TO 200
D(LAST) = BK/C(K)
GO TO 90
!
!     FIND THE PIVOT
!
70 S = ABS(REAL(C(K))) + ABS(AIMAG(C(K)))
do 71 I = KP1,N
SI = ABS(REAL(C(I))) + ABS(AIMAG(C(I)))
IF (SI .LE. S) GO TO 71
M = I
S = SI
71 CONTINUE
!
IP(K) = M
CK = C(M)
C(M) = C(K)
C(K) = CK
IF (C(K) .EQ. ZERO) GO TO 200
!
!     FIND THE K-TH ELEMENTARY MATRIX
!
IK = LAST
do 80 I = KP1,N
D(IK) = -C(I)/C(K)
80 IK = IK + 1
D(IK) = BK/C(K)
!
!     FORM THE PRODUCT OF THE ELEMENTARY MATRICES
!
90 do 110 J = 1,KM1
KJOLD = J*LCOLP1 + K - NP1
MJOLD = KJOLD + M - K
IJ = (J-1)*LCOL
IJOLD = IJ + J
IF (J .NE. KM1) GO TO 100
!
KJOLD = LASTM1
MJOLD = LASTM1 + M - K
IJOLD = LASTM1
!
100 IK = LAST - 1
DKJ = D(MJOLD)
D(MJOLD) = D(KJOLD)
do 110 I = KP1,NP1
IJ = IJ + 1
IJOLD = IJOLD + 1
IK = IK + 1
D(IJ) = D(IJOLD) + D(IK)*DKJ
110 CONTINUE
END DO
!
LAST = MAX
IF (IFLAG .LT. 0) LAST = MAX - 2
D(N) = D(LAST)
!
!     INSERT THE SOLUTION IN C
!
do 130 I = 1,N
130 C(I) = D(I)
!
NM1 = N - 1
do 140 I = 1,NM1
K = N - I
M = IP(K)
CK = C(K)
C(K) = C(M)
140 C(M) = CK
RETURN
!
!     THE SYSTEM IS SINGULAR
!
200 IERR = K
RETURN
END SUBROUTINE CLE

SUBROUTINE CVBR (B,KB,M,N,ML,MU,A,KA)
!-----------------------------------------------------------------------
!           CONVERSION OF REAL MATRICES FROM BANDED TO
!                         STANDARD FORM
!-----------------------------------------------------------------------
REAL A(KA,N), B(KB,*)
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
IF (ML .EQ. 0) GO TO 20
DO I = 1,ML
   JMAX = MIN0(N,I + MU)
   K = ML + 1 - I
   do 10 J = 1,JMAX
      K = K + 1
10 A(I,J) = B(I,K)
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
20 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
L = 0
DO I = IMIN,IMAX
   JMIN = I - ML
   JMAX = MIN0(N,I + MU)
   J = JMAX
   do 21 JJ = JMIN,JMAX
      K = J - L
      A(I,J) = B(I,K)
21 J = J - 1
   L = L + 1
END DO
!
!     INSERT ZEROS IN THE UPPER RIGHT CORNER
!
JMIN = MU + 2
IF (JMIN .GT. N) GO TO 40
IMAX0 = 1
DO J = JMIN,N
   do 30 I = 1,IMAX0
30 A(I,J) = 0.0
   IMAX0 = MIN0(IMAX,IMAX0 + 1)
END DO
!
!     INSERT ZEROS IN THE LOWER LEFT CORNER
!
40 IF (IMIN .EQ. IMAX) GO TO 50
JMAX = IMAX - IMIN
DO J = 1,JMAX
   IMIN = IMIN + 1
   do 41 I = IMIN,IMAX
41 A(I,J) = 0.0
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX ROWS
!
50 IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO J = 1,N
   do 51 I = IMIN,M
51 A(I,J) = 0.0
END DO
RETURN
END SUBROUTINE CVBR

SUBROUTINE CVRB (A,KA,M,N,ML,MU,B,KB)
!-----------------------------------------------------------------------
!        CONVERSION OF REAL MATRICES FROM STANDARD TO BANDED
!                    FORM WHEN ML AND MU ARE GIVEN
!-----------------------------------------------------------------------
REAL A(KA,N), B(KB,*)
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
IF (ML .EQ. 0) GO TO 30
L = ML
DO I = 1,ML
   JMAX = MIN0(N,I + MU)
   J = JMAX
   do 10 JJ = 1,JMAX
      K = J + L
      B(I,K) = A(I,J)
10 J = J - 1
   L = L - 1
END DO
!
!     INSERT ZEROS IN THE UPPER LEFT CORNER
!
IMAX = ML
DO J = 1,ML
   do 20 I = 1,IMAX
20 B(I,J) = 0.0
   IMAX = IMAX - 1
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
30 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
DO I = IMIN,IMAX
   JMIN = I - ML
   JMAX = MIN0(N,I + MU)
   K = 0
   do 31 J = JMIN,JMAX
      K = K + 1
31 B(I,K) = A(I,J)
END DO
!
!     INSERT ZEROS IN THE LOWER RIGHT CORNER
!
JMAX = ML + MU + 1
IF (K .EQ. JMAX) GO TO 50
JMIN = K + 1
IMIN = IMAX
DO J = JMIN,JMAX
   do 40 I = IMIN,IMAX
40 B(I,J) = 0.0
   IMIN = IMIN - 1
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX ROWS
!
50 IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO J = 1,JMAX
   do 51 I = IMIN,M
51 B(I,J) = 0.0
END DO
RETURN
END SUBROUTINE CVRB

SUBROUTINE CVRB1 (A,KA,M,N,ML,MU,B,KB,NB,IERR)
!-----------------------------------------------------------------------
!           CONVERSION OF REAL MATRICES FROM STANDARD
!                        TO BANDED FORM
!-----------------------------------------------------------------------
REAL A(KA,N), B(KB,NB)
!
!     COMPUTATION OF ML AND MU
!
NM1 = N - 1
IMIN = M
IF (M .EQ. 1) GO TO 20
DO L = 2,M
   J = 1
   IMAX = MIN0(M,IMIN + NM1)
   do 10 I = IMIN,IMAX
      IF (A(I,J) .NE. 0.0) GO TO 20
10 J = J + 1
   IMIN = IMIN - 1
END DO
!
20 MM1 = M - 1
JMIN = N
IF (N .EQ. 1) GO TO 30
DO L = 2,N
   I = 1
   JMAX = MIN0(N,JMIN + MM1)
   do 21 J = JMIN,JMAX
      IF (A(I,J) .NE. 0.0) GO TO 30
21 I = I + 1
   JMIN = JMIN - 1
END DO
!
30 ML = IMIN - 1
MU = JMIN - 1
KMAX = ML + MU + 1
IF (KMAX .GT. NB) GO TO 40
!
!     STORE THE MATRIX IN B
!
IERR = 0
CALL CVRB (A,KA,M,N,ML,MU,B,KB)
RETURN
!
!     ERROR RETURN
!
40 IERR = KMAX
RETURN
END SUBROUTINE CVRB1

SUBROUTINE CVBD (B,KB,M,N,ML,MU,A,KA)
!-----------------------------------------------------------------------
!        CONVERSION OF DOUBLE PRECISION MATRICES FROM BANDED
!                         TO STANDARD FORM
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,N), B(KB,*)
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
IF (ML .EQ. 0) GO TO 20
DO I = 1,ML
   JMAX = MIN0(N,I + MU)
   K = ML + 1 - I
   do 10 J = 1,JMAX
      K = K + 1
10 A(I,J) = B(I,K)
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
20 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
L = 0
DO I = IMIN,IMAX
   JMIN = I - ML
   JMAX = MIN0(N,I + MU)
   J = JMAX
   do 21 JJ = JMIN,JMAX
      K = J - L
      A(I,J) = B(I,K)
21 J = J - 1
   L = L + 1
END DO
!
!     INSERT ZEROS IN THE UPPER RIGHT CORNER
!
JMIN = MU + 2
IF (JMIN .GT. N) GO TO 40
IMAX0 = 1
DO J = JMIN,N
   do 30 I = 1,IMAX0
30 A(I,J) = 0.D0
   IMAX0 = MIN0(IMAX,IMAX0 + 1)
END DO
!
!     INSERT ZEROS IN THE LOWER LEFT CORNER
!
40 IF (IMIN .EQ. IMAX) GO TO 50
JMAX = IMAX - IMIN
DO J = 1,JMAX
   IMIN = IMIN + 1
   do 41 I = IMIN,IMAX
41 A(I,J) = 0.D0
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX ROWS
!
50 IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO J = 1,N
   do 51 I = IMIN,M
51 A(I,J) = 0.D0
END DO
RETURN
END SUBROUTINE CVBD

SUBROUTINE CVDB (A,KA,M,N,ML,MU,B,KB)
!-----------------------------------------------------------------------
!        CONVERSION OF DOUBLE PRECISION MATRICES FROM STANDARD
!               TO BANDED FORM WHEN ML AND MU ARE GIVEN
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,N), B(KB,*)
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
IF (ML .EQ. 0) GO TO 30
L = ML
DO I = 1,ML
   JMAX = MIN0(N,I + MU)
   J = JMAX
   do 10 JJ = 1,JMAX
      K = J + L
      B(I,K) = A(I,J)
10 J = J - 1
   L = L - 1
END DO
!
!     INSERT ZEROS IN THE UPPER LEFT CORNER
!
IMAX = ML
DO J = 1,ML
   do 20 I = 1,IMAX
20 B(I,J) = 0.D0
   IMAX = IMAX - 1
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
30 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
DO I = IMIN,IMAX
   JMIN = I - ML
   JMAX = MIN0(N,I + MU)
   K = 0
   do 31 J = JMIN,JMAX
      K = K + 1
31 B(I,K) = A(I,J)
END DO
!
!     INSERT ZEROS IN THE LOWER RIGHT CORNER
!
JMAX = ML + MU + 1
IF (K .EQ. JMAX) GO TO 50
JMIN = K + 1
IMIN = IMAX
DO J = JMIN,JMAX
   do 40 I = IMIN,IMAX
40 B(I,J) = 0.D0
   IMIN = IMIN - 1
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX ROWS
!
50 IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO J = 1,JMAX
   do 51 I = IMIN,M
51 B(I,J) = 0.D0
END DO
RETURN
END SUBROUTINE CVDB

SUBROUTINE CVDB1 (A,KA,M,N,ML,MU,B,KB,NB,IERR)
!-----------------------------------------------------------------------
!        CONVERSION OF DOUBLE PRECISION MATRICES FROM STANDARD
!                         TO BANDED FORM
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,N), B(KB,NB)
!
!     COMPUTATION OF ML AND MU
!
NM1 = N - 1
IMIN = M
IF (M .EQ. 1) GO TO 20
DO L = 2,M
   J = 1
   IMAX = MIN0(M,IMIN + NM1)
   do 10 I = IMIN,IMAX
      IF (A(I,J) .NE. 0.D0) GO TO 20
10 J = J + 1
   IMIN = IMIN - 1
END DO
!
20 MM1 = M - 1
JMIN = N
IF (N .EQ. 1) GO TO 30
DO L = 2,N
   I = 1
   JMAX = MIN0(N,JMIN + MM1)
   do 21 J = JMIN,JMAX
      IF (A(I,J) .NE. 0.D0) GO TO 30
21 I = I + 1
   JMIN = JMIN - 1
END DO
!
30 ML = IMIN - 1
MU = JMIN - 1
KMAX = ML + MU + 1
IF (KMAX .GT. NB) GO TO 40
!
!     STORE THE MATRIX IN B
!
IERR = 0
CALL CVDB (A,KA,M,N,ML,MU,B,KB)
RETURN
!
!     ERROR RETURN
!
40 IERR = KMAX
RETURN
END SUBROUTINE CVDB1

SUBROUTINE CVBC (B,KB,M,N,ML,MU,A,KA)
!-----------------------------------------------------------------------
!          CONVERSION OF COMPLEX MATRICES FROM BANDED TO
!                          STANDARD FORM
!-----------------------------------------------------------------------
COMPLEX A(KA,N), B(KB,*)
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
IF (ML .EQ. 0) GO TO 20
DO I = 1,ML
   JMAX = MIN0(N,I + MU)
   K = ML + 1 - I
   do 10 J = 1,JMAX
      K = K + 1
10 A(I,J) = B(I,K)
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
20 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
L = 0
DO I = IMIN,IMAX
   JMIN = I - ML
   JMAX = MIN0(N,I + MU)
   J = JMAX
   do 21 JJ = JMIN,JMAX
      K = J - L
      A(I,J) = B(I,K)
21 J = J - 1
   L = L + 1
END DO
!
!     INSERT ZEROS IN THE UPPER RIGHT CORNER
!
JMIN = MU + 2
IF (JMIN .GT. N) GO TO 40
IMAX0 = 1
DO J = JMIN,N
   do 30 I = 1,IMAX0
30 A(I,J) = (0.0,0.0)
   IMAX0 = MIN0(IMAX,IMAX0 + 1)
END DO
!
!     INSERT ZEROS IN THE LOWER LEFT CORNER
!
40 IF (IMIN .EQ. IMAX) GO TO 50
JMAX = IMAX - IMIN
DO J = 1,JMAX
   IMIN = IMIN + 1
   do 41 I = IMIN,IMAX
41 A(I,J) = (0.0,0.0)
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX ROWS
!
50 IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO J = 1,N
   do 51 I = IMIN,M
51 A(I,J) = (0.0,0.0)
END DO
RETURN
END SUBROUTINE CVBC

SUBROUTINE CVCB (A,KA,M,N,ML,MU,B,KB)
!-----------------------------------------------------------------------
!        CONVERSION OF COMPLEX MATRICES FROM STANDARD TO BANDED
!                    FORM WHEN ML AND MU ARE GIVEN
!-----------------------------------------------------------------------
COMPLEX A(KA,N), B(KB,*)
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
IF (ML .EQ. 0) GO TO 30
L = ML
DO I = 1,ML
   JMAX = MIN0(N,I + MU)
   J = JMAX
   do 10 JJ = 1,JMAX
      K = J + L
      B(I,K) = A(I,J)
10 J = J - 1
   L = L - 1
END DO
!
!     INSERT ZEROS IN THE UPPER LEFT CORNER
!
IMAX = ML
DO J = 1,ML
   do 20 I = 1,IMAX
20 B(I,J) = (0.0,0.0)
   IMAX = IMAX - 1
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
30 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
DO I = IMIN,IMAX
   JMIN = I - ML
   JMAX = MIN0(N,I + MU)
   K = 0
   do 31 J = JMIN,JMAX
      K = K + 1
31 B(I,K) = A(I,J)
END DO
!
!     INSERT ZEROS IN THE LOWER RIGHT CORNER
!
JMAX = ML + MU + 1
IF (K .EQ. JMAX) GO TO 50
JMIN = K + 1
IMIN = IMAX
DO J = JMIN,JMAX
   do 40 I = IMIN,IMAX
40 B(I,J) = (0.0,0.0)
   IMIN = IMIN - 1
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX ROWS
!
50 IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO J = 1,JMAX
   do 51 I = IMIN,M
51 B(I,J) = (0.0,0.0)
END DO
RETURN
END SUBROUTINE CVCB

SUBROUTINE CVCB1 (A,KA,M,N,ML,MU,B,KB,NB,IERR)
!-----------------------------------------------------------------------
!           CONVERSION OF COMPLEX MATRICES FROM STANDARD
!                          TO BANDED FORM
!-----------------------------------------------------------------------
COMPLEX A(KA,N), B(KB,NB)
!
!     COMPUTATION OF ML AND MU
!
NM1 = N - 1
IMIN = M
IF (M .EQ. 1) GO TO 20
DO L = 2,M
   J = 1
   IMAX = MIN0(M,IMIN + NM1)
   do 10 I = IMIN,IMAX
      IF (A(I,J) .NE. (0.0,0.0)) GO TO 20
10 J = J + 1
   IMIN = IMIN - 1
END DO
!
20 MM1 = M - 1
JMIN = N
IF (N .EQ. 1) GO TO 30
DO L = 2,N
   I = 1
   JMAX = MIN0(N,JMIN + MM1)
   do 21 J = JMIN,JMAX
      IF (A(I,J) .NE. (0.0,0.0)) GO TO 30
21 I = I + 1
   JMIN = JMIN - 1
END DO
!
30 ML = IMIN - 1
MU = JMIN - 1
KMAX = ML + MU + 1
IF (KMAX .GT. NB) GO TO 40
!
!     STORE THE MATRIX IN B
!
IERR = 0
CALL CVCB (A,KA,M,N,ML,MU,B,KB)
RETURN
!
!     ERROR RETURN
!
40 IERR = KMAX
RETURN
END SUBROUTINE CVCB1

SUBROUTINE MCVBS (A,KA,M,N,ML,MU,B,IB,JB,NUM,IERR)
!-----------------------------------------------------------------------
!                CONVERSION OF REAL MATRICES FROM BANDED
!                            TO SPARSE FORM
!-----------------------------------------------------------------------
REAL A(KA,*), B(*)
INTEGER IB(*), JB(*)
!
L = 1
KMAX = ML + MU + 1
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
J0 = ML
IF (ML .EQ. 0) GO TO 20
DO I = 1,ML
   IB(I) = L
   KMIN = 1 + J0
   do 10 K = KMIN,KMAX
      IF (A(I,K) .EQ. 0.0) GO TO 10
      IF (L .GT. NUM) GO TO 40
      B(L) = A(I,K)
      JB(L) = K - J0
      L = L + 1
10 CONTINUE
   J0 = J0 - 1
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
20 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
DO I = IMIN,IMAX
   IB(I) = L
   do 21 K = 1,KMAX
      IF (A(I,K) .EQ. 0.0) GO TO 21
      IF (L .GT. NUM) GO TO 40
      B(L) = A(I,K)
      JB(L) = K - J0
      L = L + 1
21 CONTINUE
   J0 = J0 - 1
END DO
IERR = 0
!
!     SET UP THE REMAINING M-IMAX ROWS
!
IMIN = IMAX + 1
MP1 = M + 1
DO I = IMIN,MP1
   IB(I) = L
END DO
RETURN
!
!     ERROR RETURN
!
40 IERR = I
RETURN
END SUBROUTINE MCVBS

SUBROUTINE DMCVBS (A,KA,M,N,ML,MU,B,IB,JB,NUM,IERR)
!-----------------------------------------------------------------------
!          CONVERSION OF DOUBLE PRECISION MATRICES FROM BANDED
!                            TO SPARSE FORM
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), B(*)
INTEGER IB(*), JB(*)
!
L = 1
KMAX = ML + MU + 1
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
J0 = ML
IF (ML .EQ. 0) GO TO 20
DO I = 1,ML
   IB(I) = L
   KMIN = 1 + J0
   do 10 K = KMIN,KMAX
      IF (A(I,K) .EQ. 0.D0) GO TO 10
      IF (L .GT. NUM) GO TO 40
      B(L) = A(I,K)
      JB(L) = K - J0
      L = L + 1
10 CONTINUE
   J0 = J0 - 1
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
20 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
DO I = IMIN,IMAX
   IB(I) = L
   do 21 K = 1,KMAX
      IF (A(I,K) .EQ. 0.D0) GO TO 21
      IF (L .GT. NUM) GO TO 40
      B(L) = A(I,K)
      JB(L) = K - J0
      L = L + 1
21 CONTINUE
   J0 = J0 - 1
END DO
IERR = 0
!
!     SET UP THE REMAINING M-IMAX ROWS
!
IMIN = IMAX + 1
MP1 = M + 1
DO I = IMIN,MP1
   IB(I) = L
END DO
RETURN
!
!     ERROR RETURN
!
40 IERR = I
RETURN
END SUBROUTINE DMCVBS

SUBROUTINE CMCVBS (A,KA,M,N,ML,MU,B,IB,JB,NUM,IERR)
!-----------------------------------------------------------------------
!              CONVERSION OF COMPLEX MATRICES FROM BANDED
!                            TO SPARSE FORM
!-----------------------------------------------------------------------
COMPLEX A(KA,*), B(*)
INTEGER IB(*), JB(*)
!
L = 1
KMAX = ML + MU + 1
!
!     STORE THE NONZERO DATA OF THE FIRST ML ROWS
!
J0 = ML
IF (ML .EQ. 0) GO TO 20
DO I = 1,ML
   IB(I) = L
   KMIN = 1 + J0
   do 10 K = KMIN,KMAX
      IF (A(I,K) .EQ. (0.0,0.0)) GO TO 10
      IF (L .GT. NUM) GO TO 40
      B(L) = A(I,K)
      JB(L) = K - J0
      L = L + 1
10 CONTINUE
   J0 = J0 - 1
END DO
!
!     STORE THE REMAINING NONZERO DATA
!
20 IMIN = ML + 1
IMAX = MIN0(M,ML + N)
DO I = IMIN,IMAX
   IB(I) = L
   do 21 K = 1,KMAX
      IF (A(I,K) .EQ. (0.0,0.0)) GO TO 21
      IF (L .GT. NUM) GO TO 40
      B(L) = A(I,K)
      JB(L) = K - J0
      L = L + 1
21 CONTINUE
   J0 = J0 - 1
END DO
IERR = 0
!
!     SET UP THE REMAINING M-IMAX ROWS
!
IMIN = IMAX + 1
MP1 = M + 1
DO I = IMIN,MP1
   IB(I) = L
END DO
RETURN
!
!     ERROR RETURN
!
40 IERR = I
RETURN
END SUBROUTINE CMCVBS

SUBROUTINE MCVSB (A,IA,JA,M,N,B,KB,NB,ML,MU,IERR)
!-----------------------------------------------------------------------
!                CONVERSION OF REAL MATRICES FROM SPARSE
!                            TO BANDED FORM
!-----------------------------------------------------------------------
REAL A(*), B(KB,NB)
INTEGER IA(*), JA(*)
!
!     COMPUTATION OF ML AND MU
!
ML = 0
MU = 0
do 11 I = 1,M
   LMIN = IA(I)
   LMAX = IA(I + 1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   do 10 L = LMIN,LMAX
      IF (A(L) .EQ. 0.0) GO TO 10
      K = JA(L) - I
      MU = MAX0(MU,K)
      ML = MAX0(ML,-K)
10 CONTINUE
11 CONTINUE
!
!     SET B = 0 IF B PROVIDES SUFFICIENT STORAGE
!
KMAX = ML + MU + 1
IF (KMAX .GT. NB) GO TO 40
!
IERR = 0
DO K = 1,KMAX
   do 20 I = 1,M
20 B(I,K) = 0.0
END DO
!
!     STORE THE MATRIX IN B
!
J0 = ML
do 31 I = 1,M
   LMIN = IA(I)
   LMAX = IA(I + 1) - 1
   IF (LMIN .GT. LMAX) GO TO 31
   do 30 L = LMIN,LMAX
      IF (A(L) .EQ. 0.0) GO TO 30
      K = JA(L) + J0
      B(I,K) = A(L)
30 CONTINUE
   J0 = J0 - 1
31 CONTINUE
RETURN
!
!     ERROR RETURN
!
40 IERR = KMAX
RETURN
END SUBROUTINE MCVSB

SUBROUTINE DMCVSB (A,IA,JA,M,N,B,KB,NB,ML,MU,IERR)
!-----------------------------------------------------------------------
!          CONVERSION OF DOUBLE PRECISION MATRICES FROM SPARSE
!                            TO BANDED FORM
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), B(KB,NB)
INTEGER IA(*), JA(*)
!
!     COMPUTATION OF ML AND MU
!
ML = 0
MU = 0
do 11 I = 1,M
   LMIN = IA(I)
   LMAX = IA(I + 1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   do 10 L = LMIN,LMAX
      IF (A(L) .EQ. 0.D0) GO TO 10
      K = JA(L) - I
      MU = MAX0(MU,K)
      ML = MAX0(ML,-K)
10 CONTINUE
11 CONTINUE
!
!     SET B = 0 IF B PROVIDES SUFFICIENT STORAGE
!
KMAX = ML + MU + 1
IF (KMAX .GT. NB) GO TO 40
!
IERR = 0
DO K = 1,KMAX
   do 20 I = 1,M
20 B(I,K) = 0.D0
END DO
!
!     STORE THE MATRIX IN B
!
J0 = ML
do 31 I = 1,M
   LMIN = IA(I)
   LMAX = IA(I + 1) - 1
   IF (LMIN .GT. LMAX) GO TO 31
   do 30 L = LMIN,LMAX
      IF (A(L) .EQ. 0.D0) GO TO 30
      K = JA(L) + J0
      B(I,K) = A(L)
30 CONTINUE
   J0 = J0 - 1
31 CONTINUE
RETURN
!
!     ERROR RETURN
!
40 IERR = KMAX
RETURN
END SUBROUTINE DMCVSB

SUBROUTINE CMCVSB (A,IA,JA,M,N,B,KB,NB,ML,MU,IERR)
!-----------------------------------------------------------------------
!              CONVERSION OF COMPLEX MATRICES FROM SPARSE
!                            TO BANDED FORM
!-----------------------------------------------------------------------
COMPLEX A(*), B(KB,NB)
INTEGER IA(*), JA(*)
!
!     COMPUTATION OF ML AND MU
!
ML = 0
MU = 0
do 11 I = 1,M
   LMIN = IA(I)
   LMAX = IA(I + 1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   do 10 L = LMIN,LMAX
      IF (A(L) .EQ. (0.0,0.0)) GO TO 10
      K = JA(L) - I
      MU = MAX0(MU,K)
      ML = MAX0(ML,-K)
10 CONTINUE
11 CONTINUE
!
!     SET B = 0 IF B PROVIDES SUFFICIENT STORAGE
!
KMAX = ML + MU + 1
IF (KMAX .GT. NB) GO TO 40
!
IERR = 0
DO K = 1,KMAX
   do 20 I = 1,M
20 B(I,K) = (0.0,0.0)
END DO
!
!     STORE THE MATRIX IN B
!
J0 = ML
do 31 I = 1,M
   LMIN = IA(I)
   LMAX = IA(I + 1) - 1
   IF (LMIN .GT. LMAX) GO TO 31
   do 30 L = LMIN,LMAX
      IF (A(L) .EQ. (0.0,0.0)) GO TO 30
      K = JA(L) + J0
      B(I,K) = A(L)
30 CONTINUE
   J0 = J0 - 1
31 CONTINUE
RETURN
!
!     ERROR RETURN
!
40 IERR = KMAX
RETURN
END SUBROUTINE CMCVSB

SUBROUTINE BCVRD (A, KA, M, N, ML, MU, B, KB)
!-----------------------------------------------------------------------
!        CONVERSION OF BANDED MATRICES FROM SINGLE TO DOUBLE
!                          PRECISION FORM
!-----------------------------------------------------------------------
REAL A(KA,*)
DOUBLE PRECISION B(KB,*)
!
NUM = ML + MU + 1
DO J = 1,NUM
   DO I = 1,M
      B(I,J) = A(I,J)
   END DO
END DO
RETURN
END SUBROUTINE BCVRD

SUBROUTINE BCVDR (A, KA, M, N, ML, MU, B, KB)
!-----------------------------------------------------------------------
!        CONVERSION OF BANDED MATRICES FROM DOUBLE TO SINGLE
!                          PRECISION FORM
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*)
REAL B(KB,*)
!
NUM = ML + MU + 1
DO J = 1,NUM
   DO I = 1,M
      B(I,J) = A(I,J)
   END DO
END DO
RETURN
END SUBROUTINE BCVDR

SUBROUTINE BREAL (A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR)
!-----------------------------------------------------------------------
!              REAL PART OF A BANDED COMPLEX MATRIX
!-----------------------------------------------------------------------
COMPLEX A(KA,*)
REAL B(KB,L)
!
!     COMPUTATION OF NL AND NU
!
NL = ML
IF (ML .EQ. 0) GO TO 30
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF (REAL(A(I,J)) .NE. 0.0) GO TO 30
   END DO
   NL = NL - 1
   IMIN = IMIN - 1
END DO
!
30 NU = MU
IF (MU .EQ. 0) GO TO 60
J = ML + MU + 1
DO K = 1,MU
   DO I = 1,M
      IF (REAL(A(I,J)) .NE. 0.0) GO TO 60
   END DO
   NU = NU - 1
   J = J - 1
END DO
!
!     STORE THE REAL PART OF A IN B
!
60 NUM = NL + NU + 1
IF (NUM .GT. L) GO TO 100
IERR = 0
K = ML - NL
DO J = 1,NUM
   K = K + 1
   DO I = 1,M
      B(I,J) = REAL(A(I,K))
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
100 IERR = NUM
RETURN
END SUBROUTINE BREAL

SUBROUTINE BIMAG (A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR)
!-----------------------------------------------------------------------
!            IMAGINARY PART OF A BANDED COMPLEX MATRIX
!-----------------------------------------------------------------------
COMPLEX A(KA,*)
REAL B(KB,L)
!
!     COMPUTATION OF NL AND NU
!
NL = ML
IF (ML .EQ. 0) GO TO 30
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF (AIMAG(A(I,J)) .NE. 0.0) GO TO 30
   END DO
   NL = NL - 1
   IMIN = IMIN - 1
END DO
!
30 NU = MU
IF (MU .EQ. 0) GO TO 60
J = ML + MU + 1
DO K = 1,MU
   DO I = 1,M
      IF (AIMAG(A(I,J)) .NE. 0.0) GO TO 60
   END DO
   NU = NU - 1
   J = J - 1
END DO
!
!     STORE THE IMAGINARY PART OF A IN B
!
60 NUM = NL + NU + 1
IF (NUM .GT. L) GO TO 100
IERR = 0
K = ML - NL
DO J = 1,NUM
   K = K + 1
   DO I = 1,M
      B(I,J) = AIMAG(A(I,K))
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
100 IERR = NUM
RETURN
END SUBROUTINE BIMAG

SUBROUTINE BCVRC (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
!-----------------------------------------------------------------------
!        COMPUTE A + BI FOR THE BANDED REAL MATRICES A AND B
!-----------------------------------------------------------------------
REAL A(KA,*), B(KB,*)
COMPLEX C(KC,L)
!
MCL = MAX0(ML,NL)
MCU = MAX0(MU,NU)
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
IERR = 0
K = MIN0(MU,NU) + 1
!
!     INSERT THE FIRST ABS(ML - NL) DIAGONALS
!
IF (NL .GE. ML) GO TO 30
JA = ML - NL
JB = 0
JC = JA
JMAX = NL + K
DO J = 1,JC
   DO I = 1,M
      C(I,J) = CMPLX(A(I,J),0.0)
   END DO
END DO
GO TO 60
!
30 JA = 0
JB = NL - ML
JC = JB
JMAX = ML + K
IF (JC .EQ. 0) GO TO 60
DO J = 1,JC
   DO I = 1,M
      C(I,J) = CMPLX(0.0,B(I,J))
   END DO
END DO
!
!     ADDITION OF THE COMMON DIAGONALS
!
60 DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = CMPLX(A(I,JA),B(I,JB))
   END DO
END DO
!
!     INSERTION OF THE REMAINING DIAGONALS
!
IF (NU .GE. MU) GO TO 120
JMAX = MU - NU
DO J = 1,JMAX
   JA = JA + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = CMPLX(A(I,JA),0.0)
   END DO
END DO
RETURN
!
120 JMAX = NU - MU
IF (JMAX .EQ. 0) RETURN
DO J = 1,JMAX
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = CMPLX(0.0,B(I,JB))
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = NUM
RETURN
END SUBROUTINE BCVRC

SUBROUTINE BPOSE (A, KA, M, N, ML, MU, B, KB)
!-----------------------------------------------------------------------
!                TRANSPOSITION OF REAL BANDED MATRICES
!-----------------------------------------------------------------------
REAL A(KA,*), B(KB,*)
!
L = ML + MU + 1
LP1 = L + 1
IF (MU .EQ. 0) GO TO 40
!
!     DEFINE THE FIRST MU COLUMNS OF B
!
NDIAG = MU
do 31 J = 1,MU
   DO I = 1,NDIAG
      B(I,J) = 0.0
   END DO
!
   LJ = LP1 - J
   IMAX = MIN0(M,N - NDIAG)
   DO I = 1,IMAX
      K = NDIAG + I
      B(K,J) = A(I,LJ)
   END DO
!
   IF (K .EQ. N) GO TO 31
   IMIN = K + 1
   DO I = IMIN,N
      B(I,J) = 0.0
   END DO
31 NDIAG = NDIAG - 1
!
!     DEFINE THE REMAINING COLUMNS OF B
!
40 JMIN = MU + 1
NDIAG = 0
do 61 J = JMIN,L
   LJ = LP1 - J
   IMAX = MIN0(M - NDIAG,N)
   DO I = 1,IMAX
      K = NDIAG + I
      B(I,J) = A(K,LJ)
   END DO
!
   IF (IMAX .EQ. N) GO TO 61
   IMIN = IMAX + 1
   DO I = IMIN,N
      B(I,J) = 0.0
   END DO
61 NDIAG = NDIAG + 1
RETURN
END SUBROUTINE BPOSE

SUBROUTINE DBPOSE (A, KA, M, N, ML, MU, B, KB)
!-----------------------------------------------------------------------
!          TRANSPOSITION OF DOUBLE PRECISION BANDED MATRICES
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), B(KB,*)
!
L = ML + MU + 1
LP1 = L + 1
IF (MU .EQ. 0) GO TO 40
!
!     DEFINE THE FIRST MU COLUMNS OF B
!
NDIAG = MU
do 31 J = 1,MU
   DO I = 1,NDIAG
      B(I,J) = 0.D0
   END DO
!
   LJ = LP1 - J
   IMAX = MIN0(M,N - NDIAG)
   DO I = 1,IMAX
      K = NDIAG + I
      B(K,J) = A(I,LJ)
   END DO
!
   IF (K .EQ. N) GO TO 31
   IMIN = K + 1
   DO I = IMIN,N
      B(I,J) = 0.D0
   END DO
31 NDIAG = NDIAG - 1
!
!     DEFINE THE REMAINING COLUMNS OF B
!
40 JMIN = MU + 1
NDIAG = 0
do 61 J = JMIN,L
   LJ = LP1 - J
   IMAX = MIN0(M - NDIAG,N)
   DO I = 1,IMAX
      K = NDIAG + I
      B(I,J) = A(K,LJ)
   END DO
!
   IF (IMAX .EQ. N) GO TO 61
   IMIN = IMAX + 1
   DO I = IMIN,N
      B(I,J) = 0.D0
   END DO
61 NDIAG = NDIAG + 1
RETURN
END SUBROUTINE DBPOSE

SUBROUTINE CBPOSE (A, KA, M, N, ML, MU, B, KB)
!-----------------------------------------------------------------------
!              TRANSPOSITION OF COMPLEX BANDED MATRICES
!-----------------------------------------------------------------------
COMPLEX A(KA,*), B(KB,*)
!
L = ML + MU + 1
LP1 = L + 1
IF (MU .EQ. 0) GO TO 40
!
!     DEFINE THE FIRST MU COLUMNS OF B
!
NDIAG = MU
do 31 J = 1,MU
   DO I = 1,NDIAG
      B(I,J) = (0.0,0.0)
   END DO
!
   LJ = LP1 - J
   IMAX = MIN0(M,N - NDIAG)
   DO I = 1,IMAX
      K = NDIAG + I
      B(K,J) = A(I,LJ)
   END DO
!
   IF (K .EQ. N) GO TO 31
   IMIN = K + 1
   DO I = IMIN,N
      B(I,J) = (0.0,0.0)
   END DO
31 NDIAG = NDIAG - 1
!
!     DEFINE THE REMAINING COLUMNS OF B
!
40 JMIN = MU + 1
NDIAG = 0
do 61 J = JMIN,L
   LJ = LP1 - J
   IMAX = MIN0(M - NDIAG,N)
   DO I = 1,IMAX
      K = NDIAG + I
      B(I,J) = A(K,LJ)
   END DO
!
   IF (IMAX .EQ. N) GO TO 61
   IMIN = IMAX + 1
   DO I = IMIN,N
      B(I,J) = (0.0,0.0)
   END DO
61 NDIAG = NDIAG + 1
RETURN
END SUBROUTINE CBPOSE

SUBROUTINE BADD (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
!-----------------------------------------------------------------------
!                 ADDITION OF REAL BANDED MATRICES
!-----------------------------------------------------------------------
REAL A(KA,*), B(KB,*), C(KC,L)
!
IERR = 0
IF (NL - ML) 10,30,20
!
!     INSERT THE FIRST ABS(ML - NL) DIAGONALS
!
10 MCL = ML
IF (ML .GE. L) GO TO 50
JA = ML - NL
JB = 0
JC = JA
JMAX = NL + 1
DO J = 1,JC
   do 11 I = 1,M
11 C(I,J) = A(I,J)
END DO
GO TO 50
!
20 MCL = NL
IF (NL .GE. L) GO TO 50
JA = 0
JB = NL - ML
JC = JB
JMAX = ML + 1
DO J = 1,JC
   do 21 I = 1,M
21 C(I,J) = B(I,J)
END DO
GO TO 50
!
!     COMPUTE MCL WHEN ML = NL
!
30 MCL = ML
IF (ML .EQ. 0) GO TO 40
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF ((A(I,J) + B(I,J)) .NE. 0.0) GO TO 40
   END DO
   MCL = MCL - 1
   IMIN = IMIN - 1
END DO
!
40 JA = ML - MCL
JB = JA
JC = 0
JMAX = MCL + 1
!
50 IF (NU - MU) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
!
100 MCU = MU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + NU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
!
JMAX = MU - NU
DO J = 1,JMAX
   JA = JA + 1
   JC = JC + 1
   do 120 I = 1,M
120 C(I,JC) = A(I,JA)
END DO
RETURN
!
130 MCU = NU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
!
JMAX = NU - MU
DO J = 1,JMAX
   JB = JB + 1
   JC = JC + 1
   do 150 I = 1,M
150 C(I,JC) = B(I,JB)
END DO
RETURN
!
!     COMPUTE MCU WHEN MU = NU
!
160 MCU = MU
IF (MU .EQ. 0) GO TO 170
LA = ML + MU + 1
LB = NL + NU + 1
DO J = 1,MU
   DO I = 1,M
      IF ((A(I,LA) + B(I,LB)) .NE. 0.0) GO TO 170
   END DO
   MCU = MCU - 1
   LA = LA - 1
   LB = LB - 1
END DO
!
!     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
!
170 NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MCU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = NUM
RETURN
END SUBROUTINE BADD

SUBROUTINE DBADD (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
!-----------------------------------------------------------------------
!           ADDITION OF DOUBLE PRECISION BANDED MATRICES
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), B(KB,*), C(KC,L)
!
IERR = 0
IF (NL - ML) 10,30,20
!
!     INSERT THE FIRST ABS(ML - NL) DIAGONALS
!
10 MCL = ML
IF (ML .GE. L) GO TO 50
JA = ML - NL
JB = 0
JC = JA
JMAX = NL + 1
DO J = 1,JC
   do 11 I = 1,M
11 C(I,J) = A(I,J)
END DO
GO TO 50
!
20 MCL = NL
IF (NL .GE. L) GO TO 50
JA = 0
JB = NL - ML
JC = JB
JMAX = ML + 1
DO J = 1,JC
   do 21 I = 1,M
21 C(I,J) = B(I,J)
END DO
GO TO 50
!
!     COMPUTE MCL WHEN ML = NL
!
30 MCL = ML
IF (ML .EQ. 0) GO TO 40
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF ((A(I,J) + B(I,J)) .NE. 0.D0) GO TO 40
   END DO
   MCL = MCL - 1
   IMIN = IMIN - 1
END DO
!
40 JA = ML - MCL
JB = JA
JC = 0
JMAX = MCL + 1
!
50 IF (NU - MU) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
!
100 MCU = MU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + NU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
!
JMAX = MU - NU
DO J = 1,JMAX
   JA = JA + 1
   JC = JC + 1
   do 120 I = 1,M
120 C(I,JC) = A(I,JA)
END DO
RETURN
!
130 MCU = NU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
!
JMAX = NU - MU
DO J = 1,JMAX
   JB = JB + 1
   JC = JC + 1
   do 150 I = 1,M
150 C(I,JC) = B(I,JB)
END DO
RETURN
!
!     COMPUTE MCU WHEN MU = NU
!
160 MCU = MU
IF (MU .EQ. 0) GO TO 170
LA = ML + MU + 1
LB = NL + NU + 1
DO J = 1,MU
   DO I = 1,M
      IF ((A(I,LA) + B(I,LB)) .NE. 0.D0) GO TO 170
   END DO
   MCU = MCU - 1
   LA = LA - 1
   LB = LB - 1
END DO
!
!     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
!
170 NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MCU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = NUM
RETURN
END SUBROUTINE DBADD

SUBROUTINE CBADD (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
!-----------------------------------------------------------------------
!                ADDITION OF COMPLEX BANDED MATRICES
!-----------------------------------------------------------------------
COMPLEX A(KA,*), B(KB,*), C(KC,L)
!
IERR = 0
IF (NL - ML) 10,30,20
!
!     INSERT THE FIRST ABS(ML - NL) DIAGONALS
!
10 MCL = ML
IF (ML .GE. L) GO TO 50
JA = ML - NL
JB = 0
JC = JA
JMAX = NL + 1
DO J = 1,JC
   do 11 I = 1,M
11 C(I,J) = A(I,J)
END DO
GO TO 50
!
20 MCL = NL
IF (NL .GE. L) GO TO 50
JA = 0
JB = NL - ML
JC = JB
JMAX = ML + 1
DO J = 1,JC
   do 21 I = 1,M
21 C(I,J) = B(I,J)
END DO
GO TO 50
!
!     COMPUTE MCL WHEN ML = NL
!
30 MCL = ML
IF (ML .EQ. 0) GO TO 40
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF ((A(I,J) + B(I,J)) .NE. (0.0,0.0)) GO TO 40
   END DO
   MCL = MCL - 1
   IMIN = IMIN - 1
END DO
!
40 JA = ML - MCL
JB = JA
JC = 0
JMAX = MCL + 1
!
50 IF (NU - MU) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
!
100 MCU = MU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + NU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
!
JMAX = MU - NU
DO J = 1,JMAX
   JA = JA + 1
   JC = JC + 1
   do 120 I = 1,M
120 C(I,JC) = A(I,JA)
END DO
RETURN
!
130 MCU = NU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
!
JMAX = NU - MU
DO J = 1,JMAX
   JB = JB + 1
   JC = JC + 1
   do 150 I = 1,M
150 C(I,JC) = B(I,JB)
END DO
RETURN
!
!     COMPUTE MCU WHEN MU = NU
!
160 MCU = MU
IF (MU .EQ. 0) GO TO 170
LA = ML + MU + 1
LB = NL + NU + 1
DO J = 1,MU
   DO I = 1,M
      IF ((A(I,LA) + B(I,LB)) .NE. (0.0,0.0)) GO TO 170
   END DO
   MCU = MCU - 1
   LA = LA - 1
   LB = LB - 1
END DO
!
!     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
!
170 NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MCU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) + B(I,JB)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = NUM
RETURN
END SUBROUTINE CBADD

SUBROUTINE BSUBT (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
!-----------------------------------------------------------------------
!                SUBTRACTION OF REAL BANDED MATRICES
!-----------------------------------------------------------------------
REAL A(KA,*), B(KB,*), C(KC,L)
!
IERR = 0
IF (NL - ML) 10,30,20
!
!     INSERT THE FIRST ABS(ML - NL) DIAGONALS
!
10 MCL = ML
IF (ML .GE. L) GO TO 50
JA = ML - NL
JB = 0
JC = JA
JMAX = NL + 1
DO J = 1,JC
   do 11 I = 1,M
11 C(I,J) = A(I,J)
END DO
GO TO 50
!
20 MCL = NL
IF (NL .GE. L) GO TO 50
JA = 0
JB = NL - ML
JC = JB
JMAX = ML + 1
DO J = 1,JC
   do 21 I = 1,M
21 C(I,J) = -B(I,J)
END DO
GO TO 50
!
!     COMPUTE MCL WHEN ML = NL
!
30 MCL = ML
IF (ML .EQ. 0) GO TO 40
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF ((A(I,J) - B(I,J)) .NE. 0.0) GO TO 40
   END DO
   MCL = MCL - 1
   IMIN = IMIN - 1
END DO
!
40 JA = ML - MCL
JB = JA
JC = 0
JMAX = MCL + 1
!
50 IF (NU - MU) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
!
100 MCU = MU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + NU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
!
JMAX = MU - NU
DO J = 1,JMAX
   JA = JA + 1
   JC = JC + 1
   do 120 I = 1,M
120 C(I,JC) = A(I,JA)
END DO
RETURN
!
130 MCU = NU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
!
JMAX = NU - MU
DO J = 1,JMAX
   JB = JB + 1
   JC = JC + 1
   do 150 I = 1,M
150 C(I,JC) = -B(I,JB)
END DO
RETURN
!
!     COMPUTE MCU WHEN MU = NU
!
160 MCU = MU
IF (MU .EQ. 0) GO TO 170
LA = ML + MU + 1
LB = NL + NU + 1
DO J = 1,MU
   DO I = 1,M
      IF ((A(I,LA) - B(I,LB)) .NE. 0.0) GO TO 170
   END DO
   MCU = MCU - 1
   LA = LA - 1
   LB = LB - 1
END DO
!
!     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
!
170 NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MCU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = NUM
RETURN
END SUBROUTINE BSUBT

SUBROUTINE DBSUBT (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
!-----------------------------------------------------------------------
!          SUBTRACTION OF DOUBLE PRECISION BANDED MATRICES
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), B(KB,*), C(KC,L)
!
IERR = 0
IF (NL - ML) 10,30,20
!
!     INSERT THE FIRST ABS(ML - NL) DIAGONALS
!
10 MCL = ML
IF (ML .GE. L) GO TO 50
JA = ML - NL
JB = 0
JC = JA
JMAX = NL + 1
DO J = 1,JC
   do 11 I = 1,M
11 C(I,J) = A(I,J)
END DO
GO TO 50
!
20 MCL = NL
IF (NL .GE. L) GO TO 50
JA = 0
JB = NL - ML
JC = JB
JMAX = ML + 1
DO J = 1,JC
   do 21 I = 1,M
21 C(I,J) = -B(I,J)
END DO
GO TO 50
!
!     COMPUTE MCL WHEN ML = NL
!
30 MCL = ML
IF (ML .EQ. 0) GO TO 40
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF ((A(I,J) - B(I,J)) .NE. 0.D0) GO TO 40
   END DO
   MCL = MCL - 1
   IMIN = IMIN - 1
END DO
!
40 JA = ML - MCL
JB = JA
JC = 0
JMAX = MCL + 1
!
50 IF (NU - MU) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
!
100 MCU = MU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + NU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
!
JMAX = MU - NU
DO J = 1,JMAX
   JA = JA + 1
   JC = JC + 1
   do 120 I = 1,M
120 C(I,JC) = A(I,JA)
END DO
RETURN
!
130 MCU = NU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
!
JMAX = NU - MU
DO J = 1,JMAX
   JB = JB + 1
   JC = JC + 1
   do 150 I = 1,M
150 C(I,JC) = -B(I,JB)
END DO
RETURN
!
!     COMPUTE MCU WHEN MU = NU
!
160 MCU = MU
IF (MU .EQ. 0) GO TO 170
LA = ML + MU + 1
LB = NL + NU + 1
DO J = 1,MU
   DO I = 1,M
      IF ((A(I,LA) - B(I,LB)) .NE. 0.D0) GO TO 170
   END DO
   MCU = MCU - 1
   LA = LA - 1
   LB = LB - 1
END DO
!
!     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
!
170 NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MCU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = NUM
RETURN
END SUBROUTINE DBSUBT

SUBROUTINE CBSUBT (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
!-----------------------------------------------------------------------
!             SUBTRACTION OF COMPLEX BANDED MATRICES
!-----------------------------------------------------------------------
COMPLEX A(KA,*), B(KB,*), C(KC,L)
!
IERR = 0
IF (NL - ML) 10,30,20
!
!     INSERT THE FIRST ABS(ML - NL) DIAGONALS
!
10 MCL = ML
IF (ML .GE. L) GO TO 50
JA = ML - NL
JB = 0
JC = JA
JMAX = NL + 1
DO J = 1,JC
   do 11 I = 1,M
11 C(I,J) = A(I,J)
END DO
GO TO 50
!
20 MCL = NL
IF (NL .GE. L) GO TO 50
JA = 0
JB = NL - ML
JC = JB
JMAX = ML + 1
DO J = 1,JC
   do 21 I = 1,M
21 C(I,J) = -B(I,J)
END DO
GO TO 50
!
!     COMPUTE MCL WHEN ML = NL
!
30 MCL = ML
IF (ML .EQ. 0) GO TO 40
IMIN = ML + 1
DO J = 1,ML
   DO I = IMIN,M
      IF ((A(I,J) - B(I,J)) .NE. (0.0,0.0)) GO TO 40
   END DO
   MCL = MCL - 1
   IMIN = IMIN - 1
END DO
!
40 JA = ML - MCL
JB = JA
JC = 0
JMAX = MCL + 1
!
50 IF (NU - MU) 100,160,130
!
!     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
!
100 MCU = MU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + NU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
!
JMAX = MU - NU
DO J = 1,JMAX
   JA = JA + 1
   JC = JC + 1
   do 120 I = 1,M
120 C(I,JC) = A(I,JA)
END DO
RETURN
!
130 MCU = NU
NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
!
JMAX = NU - MU
DO J = 1,JMAX
   JB = JB + 1
   JC = JC + 1
   do 150 I = 1,M
150 C(I,JC) = -B(I,JB)
END DO
RETURN
!
!     COMPUTE MCU WHEN MU = NU
!
160 MCU = MU
IF (MU .EQ. 0) GO TO 170
LA = ML + MU + 1
LB = NL + NU + 1
DO J = 1,MU
   DO I = 1,M
      IF ((A(I,LA) - B(I,LB)) .NE. (0.0,0.0)) GO TO 170
   END DO
   MCU = MCU - 1
   LA = LA - 1
   LB = LB - 1
END DO
!
!     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
!
170 NUM = MCL + MCU + 1
IF (NUM .GT. L) GO TO 200
!
JMAX = JMAX + MCU
DO J = 1,JMAX
   JA = JA + 1
   JB = JB + 1
   JC = JC + 1
   DO I = 1,M
      C(I,JC) = A(I,JA) - B(I,JB)
   END DO
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = NUM
RETURN
END SUBROUTINE CBSUBT

SUBROUTINE BPROD (M, N, L, A, KA, ML, MU, B, KB, NL, NU, &
&C, KC, NC, MCL, MCU, IERR)
!-----------------------------------------------------------------------
!                MULTIPLICATION OF REAL BANDED MATRICES
!-----------------------------------------------------------------------
REAL A(KA,*), B(KB,*), C(KC,NC)
!
IERR = 0
DO J = 1,NC
   do 10 I = 1,M
10 C(I,J) = 0.0
END DO
!
MLP1 = ML + 1
NLP1 = NL + 1
NPML = N + ML
NPNU = N + NU
MCL = MIN0(M - 1,ML + NL)
JC = 0
IF (MCL .EQ. 0) GO TO 100
!
!     FIND THE FIRST NONZERO LOWER DIAGONAL
!
MAXD = MCL
DO NDIAG = 1,MAXD
   IMJ = MAXD + 1 - NDIAG
   JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
   DO J = 1,JMAX
      I = J + IMJ
      SUM = 0.0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,1) = SUM
   END DO
!
   DO J = 1,JMAX
      I = J + IMJ
      IF (C(I,1) .NE. 0.0) GO TO 40
   END DO
   MCL = MCL - 1
END DO
GO TO 100
!
40 IF (MCL .GE. NC) GO TO 100
JC = 1
IF (MCL .EQ. 1) GO TO 100
!
!     COMPUTE THE REMAINING LOWER DIAGONALS
!
MIND = NDIAG + 1
DO NDIAG = MIND,MAXD
   JC = JC + 1
   IMJ = MAXD + 1 - NDIAG
   JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
   DO J = 1,JMAX
      I = J + IMJ
      SUM = 0.0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
END DO
!
!     FIND THE LAST NONZERO UPPER DIAGONAL
!
100 JC = JC + 1
MCU = MIN0(L - 1,MU + NU)
IF (MCU .EQ. 0) GO TO 130
!
MAXD = MCU
DO NDIAG = 1,MAXD
   JMI = MAXD + 1 - NDIAG
   IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
   DO I = 1,IMAX
      J = I + JMI
      SUM = 0.0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
!
   DO I = 1,IMAX
      IF (C(I,JC) .NE. 0.0) GO TO 130
   END DO
   MCU = MCU - 1
END DO
!
130 LAST = MCL + MCU + 1
IF (LAST .GT. NC) GO TO 200
IF (MCU .EQ. 0) GO TO 140
DO I = 1,IMAX
   C(I,LAST) = C(I,JC)
   C(I,JC) = 0.0
END DO
!
!     COMPUTE THE MAIN DIAGONAL AND THE REMAINING UPPER DIAGONALS
!
140 MAXD = MAX0(1,MCU)
DO NDIAG = 1,MAXD
   JMI = NDIAG - 1
   IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
   DO I = 1,IMAX
      J = I + JMI
      SUM = 0.0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
   JC = JC + 1
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = LAST
RETURN
END SUBROUTINE BPROD

SUBROUTINE DBPROD (M, N, L, A, KA, ML, MU, B, KB, NL, NU, &
&C, KC, NC, MCL, MCU, IERR)
!-----------------------------------------------------------------------
!          MULTIPLICATION OF DOUBLE PRECISION BANDED MATRICES
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), B(KB,*), C(KC,NC)
DOUBLE PRECISION SUM
!
IERR = 0
DO J = 1,NC
   do 10 I = 1,M
10 C(I,J) = 0.D0
END DO
!
MLP1 = ML + 1
NLP1 = NL + 1
NPML = N + ML
NPNU = N + NU
MCL = MIN0(M - 1,ML + NL)
JC = 0
IF (MCL .EQ. 0) GO TO 100
!
!     FIND THE FIRST NONZERO LOWER DIAGONAL
!
MAXD = MCL
DO NDIAG = 1,MAXD
   IMJ = MAXD + 1 - NDIAG
   JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
   DO J = 1,JMAX
      I = J + IMJ
      SUM = 0.D0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,1) = SUM
   END DO
!
   DO J = 1,JMAX
      I = J + IMJ
      IF (C(I,1) .NE. 0.D0) GO TO 40
   END DO
   MCL = MCL - 1
END DO
GO TO 100
!
40 IF (MCL .GE. NC) GO TO 100
JC = 1
IF (MCL .EQ. 1) GO TO 100
!
!     COMPUTE THE REMAINING LOWER DIAGONALS
!
MIND = NDIAG + 1
DO NDIAG = MIND,MAXD
   JC = JC + 1
   IMJ = MAXD + 1 - NDIAG
   JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
   DO J = 1,JMAX
      I = J + IMJ
      SUM = 0.D0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
END DO
!
!     FIND THE LAST NONZERO UPPER DIAGONAL
!
100 JC = JC + 1
MCU = MIN0(L - 1,MU + NU)
IF (MCU .EQ. 0) GO TO 130
!
MAXD = MCU
DO NDIAG = 1,MAXD
   JMI = MAXD + 1 - NDIAG
   IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
   DO I = 1,IMAX
      J = I + JMI
      SUM = 0.D0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
!
   DO I = 1,IMAX
      IF (C(I,JC) .NE. 0.D0) GO TO 130
   END DO
   MCU = MCU - 1
END DO
!
130 LAST = MCL + MCU + 1
IF (LAST .GT. NC) GO TO 200
IF (MCU .EQ. 0) GO TO 140
DO I = 1,IMAX
   C(I,LAST) = C(I,JC)
   C(I,JC) = 0.D0
END DO
!
!     COMPUTE THE MAIN DIAGONAL AND THE REMAINING UPPER DIAGONALS
!
140 MAXD = MAX0(1,MCU)
DO NDIAG = 1,MAXD
   JMI = NDIAG - 1
   IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
   DO I = 1,IMAX
      J = I + JMI
      SUM = 0.D0
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
   JC = JC + 1
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = LAST
RETURN
END SUBROUTINE DBPROD

SUBROUTINE CBPROD (M, N, L, A, KA, ML, MU, B, KB, NL, NU, &
&C, KC, NC, MCL, MCU, IERR)
!-----------------------------------------------------------------------
!             MULTIPLICATION OF COMPLEX BANDED MATRICES
!-----------------------------------------------------------------------
COMPLEX A(KA,*), B(KB,*), C(KC,NC)
COMPLEX SUM
!
IERR = 0
DO J = 1,NC
   do 10 I = 1,M
10 C(I,J) = (0.0,0.0)
END DO
!
MLP1 = ML + 1
NLP1 = NL + 1
NPML = N + ML
NPNU = N + NU
MCL = MIN0(M - 1,ML + NL)
JC = 0
IF (MCL .EQ. 0) GO TO 100
!
!     FIND THE FIRST NONZERO LOWER DIAGONAL
!
MAXD = MCL
DO NDIAG = 1,MAXD
   IMJ = MAXD + 1 - NDIAG
   JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
   DO J = 1,JMAX
      I = J + IMJ
      SUM = (0.0,0.0)
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,1) = SUM
   END DO
!
   DO J = 1,JMAX
      I = J + IMJ
      IF (C(I,1) .NE. (0.0,0.0)) GO TO 40
   END DO
   MCL = MCL - 1
END DO
GO TO 100
!
40 IF (MCL .GE. NC) GO TO 100
JC = 1
IF (MCL .EQ. 1) GO TO 100
!
!     COMPUTE THE REMAINING LOWER DIAGONALS
!
MIND = NDIAG + 1
DO NDIAG = MIND,MAXD
   JC = JC + 1
   IMJ = MAXD + 1 - NDIAG
   JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
   DO J = 1,JMAX
      I = J + IMJ
      SUM = (0.0,0.0)
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
END DO
!
!     FIND THE LAST NONZERO UPPER DIAGONAL
!
100 JC = JC + 1
MCU = MIN0(L - 1,MU + NU)
IF (MCU .EQ. 0) GO TO 130
!
MAXD = MCU
DO NDIAG = 1,MAXD
   JMI = MAXD + 1 - NDIAG
   IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
   DO I = 1,IMAX
      J = I + JMI
      SUM = (0.0,0.0)
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
!
   DO I = 1,IMAX
      IF (C(I,JC) .NE. (0.0,0.0)) GO TO 130
   END DO
   MCU = MCU - 1
END DO
!
130 LAST = MCL + MCU + 1
IF (LAST .GT. NC) GO TO 200
IF (MCU .EQ. 0) GO TO 140
DO I = 1,IMAX
   C(I,LAST) = C(I,JC)
   C(I,JC) = (0.0,0.0)
END DO
!
!     COMPUTE THE MAIN DIAGONAL AND THE REMAINING UPPER DIAGONALS
!
140 MAXD = MAX0(1,MCU)
DO NDIAG = 1,MAXD
   JMI = NDIAG - 1
   IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
   DO I = 1,IMAX
      J = I + JMI
      SUM = (0.0,0.0)
      KMIN = MAX0(1,I - ML,J - NU)
      KMAX = MIN0(N,I + MU,J + NL)
      KK = MLP1 - I + KMIN
      JJ = NLP1 + J - KMIN
      DO K = KMIN,KMAX
         SUM = SUM + A(I,KK)*B(K,JJ)
         KK = KK + 1
         JJ = JJ - 1
      END DO
      C(I,JC) = SUM
   END DO
   JC = JC + 1
END DO
RETURN
!
!     ERROR RETURN
!
200 IERR = LAST
RETURN
END SUBROUTINE CBPROD

SUBROUTINE BVPRD (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!         PRODUCT OF A REAL BANDED MATRIX AND A REAL VECTOR
!-----------------------------------------------------------------------
REAL A(KA,*), X(N), Y(M)
!
!     COMPUTE THE FIRST ML COMPONENTS
!
MLP1 = ML + 1
IF (ML .EQ. 0) GO TO 20
JMIN = MLP1
DO I = 1,ML
   KMAX = MIN0(N,I + MU)
   KK = JMIN
   SUM = 0.0
   DO K = 1,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
   JMIN = JMIN - 1
END DO
!
!     COMPUTE THE REMAINING NONZERO COMPONENTS
!
20 IMAX = MIN0(M,N + ML)
DO I = MLP1,IMAX
   KMIN = I - ML
   KMAX = MIN0(N,I + MU)
   KK = 1
   SUM = 0.0
   DO K = KMIN,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX COMPONENTS
!
IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO I = IMIN,M
   Y(I) = 0.0
END DO
RETURN
END SUBROUTINE BVPRD

SUBROUTINE BVPRD1 (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!        SETTING Y = A*X + Y WHERE A IS A REAL BANDED MATRIX
!                     AND X,Y ARE REAL VECTORS
!-----------------------------------------------------------------------
REAL A(KA,*), X(N), Y(M)
!
!     COMPUTE THE FIRST ML COMPONENTS
!
MLP1 = ML + 1
IF (ML .EQ. 0) GO TO 20
JMIN = MLP1
DO I = 1,ML
   KMAX = MIN0(N,I + MU)
   KK = JMIN
   SUM = Y(I)
   DO K = 1,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
   JMIN = JMIN - 1
END DO
!
!     COMPUTE THE REMAINING COMPONENTS
!
20 IMAX = MIN0(M,N + ML)
DO I = MLP1,IMAX
   KMIN = I - ML
   KMAX = MIN0(N,I + MU)
   KK = 1
   SUM = Y(I)
   DO K = KMIN,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
END DO
RETURN
END SUBROUTINE BVPRD1

SUBROUTINE DBVPD (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!           PRODUCT OF A DOUBLE PRECISION BANDED MATRIX
!                  AND A DOUBLE PRECISION VECTOR
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), X(N), Y(M)
DOUBLE PRECISION SUM
!
!     COMPUTE THE FIRST ML COMPONENTS
!
MLP1 = ML + 1
IF (ML .EQ. 0) GO TO 20
JMIN = MLP1
DO I = 1,ML
   KMAX = MIN0(N,I + MU)
   KK = JMIN
   SUM = 0.D0
   DO K = 1,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
   JMIN = JMIN - 1
END DO
!
!     COMPUTE THE REMAINING NONZERO COMPONENTS
!
20 IMAX = MIN0(M,N + ML)
DO I = MLP1,IMAX
   KMIN = I - ML
   KMAX = MIN0(N,I + MU)
   KK = 1
   SUM = 0.D0
   DO K = KMIN,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX COMPONENTS
!
IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO I = IMIN,M
   Y(I) = 0.D0
END DO
RETURN
END SUBROUTINE DBVPD

SUBROUTINE DBVPD1 (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!         SETTING Y = A*X + Y WHERE A IS A DOUBLE PRECISION
!         BANDED MATRIX AND X,Y ARE DOUBLE PRECISION VECTORS
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), X(N), Y(M)
DOUBLE PRECISION SUM
!
!     COMPUTE THE FIRST ML COMPONENTS
!
MLP1 = ML + 1
IF (ML .EQ. 0) GO TO 20
JMIN = MLP1
DO I = 1,ML
   KMAX = MIN0(N,I + MU)
   KK = JMIN
   SUM = Y(I)
   DO K = 1,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
   JMIN = JMIN - 1
END DO
!
!     COMPUTE THE REMAINING COMPONENTS
!
20 IMAX = MIN0(M,N + ML)
DO I = MLP1,IMAX
   KMIN = I - ML
   KMAX = MIN0(N,I + MU)
   KK = 1
   SUM = Y(I)
   DO K = KMIN,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
END DO
RETURN
END SUBROUTINE DBVPD1

SUBROUTINE CBVPD (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!        PRODUCT OF A COMPLEX BANDED MATRIX AND A COMPLEX VECTOR
!-----------------------------------------------------------------------
COMPLEX A(KA,*), X(N), Y(M)
COMPLEX SUM
!
!     COMPUTE THE FIRST ML COMPONENTS
!
MLP1 = ML + 1
IF (ML .EQ. 0) GO TO 20
JMIN = MLP1
DO I = 1,ML
   KMAX = MIN0(N,I + MU)
   KK = JMIN
   SUM = (0.0,0.0)
   DO K = 1,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
   JMIN = JMIN - 1
END DO
!
!     COMPUTE THE REMAINING NONZERO COMPONENTS
!
20 IMAX = MIN0(M,N + ML)
DO I = MLP1,IMAX
   KMIN = I - ML
   KMAX = MIN0(N,I + MU)
   KK = 1
   SUM = (0.0,0.0)
   DO K = KMIN,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
END DO
!
!     STORE ZEROS IN THE FINAL M-IMAX COMPONENTS
!
IF (IMAX .EQ. M) RETURN
IMIN = IMAX + 1
DO I = IMIN,M
   Y(I) = (0.0,0.0)
END DO
RETURN
END SUBROUTINE CBVPD

SUBROUTINE CBVPD1 (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!        SETTING Y = A*X + Y WHERE A IS A COMPLEX BANDED MATRIX
!                     AND X,Y ARE COMPLEX VECTORS
!-----------------------------------------------------------------------
COMPLEX A(KA,*), X(N), Y(M)
COMPLEX SUM
!
!     COMPUTE THE FIRST ML COMPONENTS
!
MLP1 = ML + 1
IF (ML .EQ. 0) GO TO 20
JMIN = MLP1
DO I = 1,ML
   KMAX = MIN0(N,I + MU)
   KK = JMIN
   SUM = Y(I)
   DO K = 1,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
   JMIN = JMIN - 1
END DO
!
!     COMPUTE THE REMAINING COMPONENTS
!
20 IMAX = MIN0(M,N + ML)
DO I = MLP1,IMAX
   KMIN = I - ML
   KMAX = MIN0(N,I + MU)
   KK = 1
   SUM = Y(I)
   DO K = KMIN,KMAX
      SUM = SUM + A(I,KK)*X(K)
      KK = KK + 1
   END DO
   Y(I) = SUM
END DO
RETURN
END SUBROUTINE CBVPD1

SUBROUTINE BTPRD (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!         PRODUCT OF A REAL VECTOR AND A REAL BANDED MATRIX
!-----------------------------------------------------------------------
REAL A(KA,*), X(M), Y(N)
!
!     COMPUTE THE FIRST MU COMPONENTS
!
IF (MU .EQ. 0) GO TO 20
DO J = 1,MU
   JJ = ML + J
   KMAX = MIN0(M,JJ)
   SUM = 0.0
   DO K = 1,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     COMPUTE THE REMAINING NONZERO COMPONENTS
!
20 NUM = ML + MU + 1
JMIN = MU + 1
JMAX = MIN0(N,M + MU)
DO J = JMIN,JMAX
   KMIN = J - MU
   KMAX = MIN0(M,J + ML)
   JJ = NUM
   SUM = 0.0
   DO K = KMIN,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     STORE ZEROS IN THE FINAL N-JMAX COMPONENTS
!
IF (JMAX .EQ. N) RETURN
JMIN = JMAX + 1
DO J = JMIN,N
   Y(J) = 0.0
END DO
RETURN
END SUBROUTINE BTPRD

SUBROUTINE BTPRD1 (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!        SETTING Y = X*A + Y WHERE A IS A REAL BANDED MATRIX
!                     AND X,Y ARE REAL VECTORS
!-----------------------------------------------------------------------
REAL A(KA,*), X(M), Y(N)
!
!     COMPUTE THE FIRST MU COMPONENTS
!
IF (MU .EQ. 0) GO TO 20
DO J = 1,MU
   JJ = ML + J
   KMAX = MIN0(M,JJ)
   SUM = Y(J)
   DO K = 1,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     COMPUTE THE REMAINING COMPONENTS
!
20 NUM = ML + MU + 1
JMIN = MU + 1
JMAX = MIN0(N,M + MU)
DO J = JMIN,JMAX
   KMIN = J - MU
   KMAX = MIN0(M,J + ML)
   JJ = NUM
   SUM = Y(J)
   DO K = KMIN,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
RETURN
END SUBROUTINE BTPRD1

SUBROUTINE DBTPD (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!              PRODUCT OF A DOUBLE PRECISION VECTOR AND
!                  A DOUBLE PRECISION BANDED MATRIX
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), X(M), Y(N)
DOUBLE PRECISION SUM
!
!     COMPUTE THE FIRST MU COMPONENTS
!
IF (MU .EQ. 0) GO TO 20
DO J = 1,MU
   JJ = ML + J
   KMAX = MIN0(M,JJ)
   SUM = 0.D0
   DO K = 1,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     COMPUTE THE REMAINING NONZERO COMPONENTS
!
20 NUM = ML + MU + 1
JMIN = MU + 1
JMAX = MIN0(N,M + MU)
DO J = JMIN,JMAX
   KMIN = J - MU
   KMAX = MIN0(M,J + ML)
   JJ = NUM
   SUM = 0.D0
   DO K = KMIN,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     STORE ZEROS IN THE FINAL N-JMAX COMPONENTS
!
IF (JMAX .EQ. N) RETURN
JMIN = JMAX + 1
DO J = JMIN,N
   Y(J) = 0.D0
END DO
RETURN
END SUBROUTINE DBTPD

SUBROUTINE DBTPD1 (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!         SETTING Y = X*A + Y WHERE A IS A DOUBLE PRECISION
!         BANDED MATRIX AND X,Y ARE DOUBLE PRECISION VECTORS
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), X(M), Y(N)
DOUBLE PRECISION SUM
!
!     COMPUTE THE FIRST MU COMPONENTS
!
IF (MU .EQ. 0) GO TO 20
DO J = 1,MU
   JJ = ML + J
   KMAX = MIN0(M,JJ)
   SUM = Y(J)
   DO K = 1,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     COMPUTE THE REMAINING COMPONENTS
!
20 NUM = ML + MU + 1
JMIN = MU + 1
JMAX = MIN0(N,M + MU)
DO J = JMIN,JMAX
   KMIN = J - MU
   KMAX = MIN0(M,J + ML)
   JJ = NUM
   SUM = Y(J)
   DO K = KMIN,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
RETURN
END SUBROUTINE DBTPD1

SUBROUTINE CBTPD (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!        PRODUCT OF A COMPLEX VECTOR AND A COMPLEX BANDED MATRIX
!-----------------------------------------------------------------------
COMPLEX A(KA,*), X(M), Y(N)
COMPLEX SUM
!
!     COMPUTE THE FIRST MU COMPONENTS
!
IF (MU .EQ. 0) GO TO 20
DO J = 1,MU
   JJ = ML + J
   KMAX = MIN0(M,JJ)
   SUM = (0.0,0.0)
   DO K = 1,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     COMPUTE THE REMAINING NONZERO COMPONENTS
!
20 NUM = ML + MU + 1
JMIN = MU + 1
JMAX = MIN0(N,M + MU)
DO J = JMIN,JMAX
   KMIN = J - MU
   KMAX = MIN0(M,J + ML)
   JJ = NUM
   SUM = (0.0,0.0)
   DO K = KMIN,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     STORE ZEROS IN THE FINAL N-JMAX COMPONENTS
!
IF (JMAX .EQ. N) RETURN
JMIN = JMAX + 1
DO J = JMIN,N
   Y(J) = (0.0,0.0)
END DO
RETURN
END SUBROUTINE CBTPD

SUBROUTINE CBTPD1 (M,N,A,KA,ML,MU,X,Y)
!-----------------------------------------------------------------------
!        SETTING Y = X*A + Y WHERE A IS A COMPLEX BANDED MATRIX
!                     AND X,Y ARE COMPLEX VECTORS
!-----------------------------------------------------------------------
COMPLEX A(KA,*), X(M), Y(N)
COMPLEX SUM
!
!     COMPUTE THE FIRST MU COMPONENTS
!
IF (MU .EQ. 0) GO TO 20
DO J = 1,MU
   JJ = ML + J
   KMAX = MIN0(M,JJ)
   SUM = Y(J)
   DO K = 1,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
!
!     COMPUTE THE REMAINING COMPONENTS
!
20 NUM = ML + MU + 1
JMIN = MU + 1
JMAX = MIN0(N,M + MU)
DO J = JMIN,JMAX
   KMIN = J - MU
   KMAX = MIN0(M,J + ML)
   JJ = NUM
   SUM = Y(J)
   DO K = KMIN,KMAX
      SUM = SUM + A(K,JJ)*X(K)
      JJ = JJ - 1
   END DO
   Y(J) = SUM
END DO
RETURN
END SUBROUTINE CBTPD1

REAL function BNRM (A, KA, M, N, ML, MU)
!-----------------------------------------------------------------------
!             COMPUTATION OF THE L-INFINITY NORM OF A
!                      REAL BANDED MATRIX A
!-----------------------------------------------------------------------
REAL A(KA,*)
!
NUM = ML + MU + 1
BNRM = 0.0
DO I = 1,M
   SUM = 0.0
   DO J = 1,NUM
      SUM = SUM + ABS(A(I,J))
   END DO
   BNRM = AMAX1(BNRM, SUM)
END DO
RETURN
END FUNCTION BNRM

REAL function B1NRM (A, KA, M, N, ML, MU)
!-----------------------------------------------------------------------
!            COMPUTATION OF THE L1 NORM OF A BANDED MATRIX A
!-----------------------------------------------------------------------
REAL A(*)
!
INCR = KA - 1
B1NRM = 0.0
!
!     GO DOWN THE FIRST COLUMN OF A
!
IMIN = ML + 1
IMAX = MIN0(M, IMIN + MU)
DO I = IMIN,IMAX
   B1NRM = AMAX1(B1NRM, SASUM(I,A(I),INCR))
END DO
I = IMAX
J = I - ML
NUM = I
IF (J .EQ. N) RETURN
IF (I .EQ. M) GO TO 30
!
IMIN = I + 1
IMAX = MIN0(M, ML + N)
DO I = IMIN,IMAX
   B1NRM = AMAX1(B1NRM, SASUM(NUM,A(I),INCR))
END DO
I = IMAX
J = I - ML
GO TO 50
!
!     PROCEED ALONG THE LAST ROW OF A
!
30 JMAX = MU + 1
IF (J .EQ. JMAX) GO TO 50
JMIN = J + 1
DO J = JMIN,JMAX
   I = I + KA
   B1NRM = AMAX1(B1NRM, SASUM(NUM,A(I),INCR))
END DO
J = JMAX
!
50 IF (J .EQ. N .OR. NUM .EQ. 1) RETURN
   I = I + KA
   J = J + 1
   NUM = NUM - 1
   B1NRM = AMAX1(B1NRM, SASUM(NUM,A(I),INCR))
   GO TO 50
END FUNCTION B1NRM

double precision function DBNRM (A, KA, M, N, ML, MU)
!-----------------------------------------------------------------------
!             COMPUTATION OF THE L-INFINITY NORM OF A
!                DOUBLE PRECISION BANDED MATRIX A
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*)
DOUBLE PRECISION SUM
!
NUM = ML + MU + 1
DBNRM = 0.D0
DO I = 1,M
   SUM = 0.D0
   DO J = 1,NUM
      SUM = SUM + DABS(A(I,J))
   END DO
   DBNRM = DMAX1(DBNRM, SUM)
END DO
RETURN
END FUNCTION DBNRM

double precision function DB1NRM (A, KA, M, N, ML, MU)
!-----------------------------------------------------------------------
!            COMPUTATION OF THE L1 NORM OF A DOUBLE PRECISION
!                            BANDED MATRIX A
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*)
DOUBLE PRECISION DASUM
!
INCR = KA - 1
DB1NRM = 0.D0
!
!     GO DOWN THE FIRST COLUMN OF A
!
IMIN = ML + 1
IMAX = MIN0(M, IMIN + MU)
DO I = IMIN,IMAX
   DB1NRM = DMAX1(DB1NRM, DASUM(I,A(I),INCR))
END DO
I = IMAX
J = I - ML
NUM = I
IF (J .EQ. N) RETURN
IF (I .EQ. M) GO TO 30
!
IMIN = I + 1
IMAX = MIN0(M, ML + N)
DO I = IMIN,IMAX
   DB1NRM = DMAX1(DB1NRM, DASUM(NUM,A(I),INCR))
END DO
I = IMAX
J = I - ML
GO TO 50
!
!     PROCEED ALONG THE LAST ROW OF A
!
30 JMAX = MU + 1
IF (J .EQ. JMAX) GO TO 50
JMIN = J + 1
DO J = JMIN,JMAX
   I = I + KA
   DB1NRM = DMAX1(DB1NRM, DASUM(NUM,A(I),INCR))
END DO
J = JMAX
!
50 IF (J .EQ. N .OR. NUM .EQ. 1) RETURN
   I = I + KA
   J = J + 1
   NUM = NUM - 1
   DB1NRM = DMAX1(DB1NRM, DASUM(NUM,A(I),INCR))
   GO TO 50
END FUNCTION DB1NRM

SUBROUTINE BSLV(M0,A,KA,N,ML,MU,B,IWK,IERR)
! ----------------------------------------------------------------------
!     BSLV EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN BANDED LINEAR SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
!     IF BSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO BSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
!               SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF AX = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO BSLV, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. BSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     BSLV AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
REAL A(KA,*),B(N)
INTEGER IWK(N)
IF (M0 .NE. 0) GO TO 10
!
!     ERROR CHECKING
!
IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
CALL SNBFA(A,KA,N,ML,MU,IWK,IERR)
IF (IERR .NE. 0) RETURN
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 CALL SNBSL(A,KA,N,ML,MU,IWK,B,0)
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE BSLV

SUBROUTINE BSLV1(M0,A,KA,N,ML,MU,B,IWK,IERR)
! ----------------------------------------------------------------------
!     BSLV1 EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN BANDED LINEAR SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
!     IF BSLV1 IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO BSLV1.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
!               SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF XA = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO BSLV1, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. BSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     BSLV1 AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
REAL A(KA,*),B(N)
INTEGER IWK(N)
IF (M0 .NE. 0) GO TO 10
!
!     ERROR CHECKING
!
IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
CALL SNBFA(A,KA,N,ML,MU,IWK,IERR)
IF (IERR .NE. 0) RETURN
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 CALL SNBSL(A,KA,N,ML,MU,IWK,B,1)
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE BSLV1

SUBROUTINE SNBFA (A, LDA, N, ML, MU, IPVT, INFO)
! ----------------------------------------------------------------------
!
!               SNBFA FACTORS A REAL BAND MATRIX BY ELIMINATION.
!
!                               --------
!     ON ENTRY
!
!        A       REAL(LDA, NC)
!                CONTAINS THE MATRIX IN BAND STORAGE. THE ROWS
!                OF THE ORIGINAL MATRIX ARE STORED IN THE ROWS
!                OF A AND THE DIAGONALS OF THE ORIGINAL MATRIX
!                ARE STORED IN COLUMNS 1 THROUGH ML+MU+1 OF A.
!                NC MUST BE .GE. 2*ML+MU+1 .
!                SEE THE COMMENTS BELOW FOR DETAILS.
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A. IT IS
!                ASSUMED THAT LDA .GE. N.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!                0 .LE. ML .LT. N .
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!                0 .LE. MU .LT. N .
!                MORE EFFICIENT IF ML .LE. MU .
!
!     ON RETURN
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                AND THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
!                L IS A PRODUCT OF PERMUTATION AND UNIT LOWER
!                TRIANGULAR MATRICES AND U IS UPPER TRIANGULAR.
!
!        IPVT    INTEGER(N)
!                AN INTEGER VECTOR OF PIVOT INDICES.
!
!        INFO    INTEGER
!                =0  NORMAL VALUE
!                =K  IF  U(K,K) .EQ. 0. THIS IS NOT AN ERROR
!                CONDITION FOR THIS SUBROUTINE, BUT IT DOES
!                INDICATE THAT SNBSL WILL DIVIDE BY ZERO IF
!                IT IS CALLED.
!
!     BAND STORAGE
!
!           IF A0 IS THE MATRIX THEN THE FOLLOWING CODE WILL STORE
!           A0 IN BAND FORM.
!
!                   ML = (BAND WIDTH BELOW THE DIAGONAL)
!                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
!                   DO 20 I = 1, N
!                      J1 = MAX0(1, I-ML)
!                      J2 = MIN0(N, I+MU)
!                      DO 10 J = J1, J2
!                         K = J - I + ML + 1
!                         A(I,K) = A0(I,J)
!                10    CONTINUE
!                20 CONTINUE
!
!           THIS USES COLUMNS 1 THROUGH  ML + MU + 1  OF A.
!           FURTHERMORE, ML ADDITIONAL COLUMNS ARE NEEDED IN
!           A (STARTING WITH COLUMN  ML+MU+2) FOR ELEMENTS
!           GENERATED DURING THE TRIANGULARIZATION. THE TOTAL
!           NUMBER OF COLUMNS NEEDED IN A IS  2*ML+MU+1 .
!
!     EXAMPLE..  IF THE ORIGINAL MATRIX IS
!
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!
!      THEN  N = 6, ML = 1, MU = 2, LDA .GE. 6  AND A SHOULD CONTAIN
!
!              11 12 13  +     , + = USED FOR PIVOTING
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!
!     WRITTEN BY E.A.VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H.MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!        MIN0,ISAMAX,SAXPY,SSCAL,SSWAP
! ----------------------------------------------------------------------
INTEGER LDA,N,ML,MU,INFO
REAL A(LDA,*)
INTEGER IPVT(N)
REAL T
!
INFO = 0
IF (ML .EQ. 0) GO TO 100
M = ML + MU + 1
!
!     SET FILL-IN COLUMNS TO ZERO
!
DO J = 1,ML
   JJ = M + J
   DO I = 1,N
      A(I,JJ) = 0.0
   END DO
END DO
!
!     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
!
ML1 = ML + 1
MB = ML + MU
N1 = N - 1
LDB = LDA - 1
do 40 K = 1,N1
  LM = MIN0(N-K,ML)
  LMK = LM + K
  LM1 = LM + 1
  LM2 = ML1 - LM
!
!     SEARCH FOR PIVOT INDEX
!
  L = -ISAMAX(LM1, A(LMK,LM2), LDB) + LM1 + K
  IPVT(K) = L
  MP = MIN0(MB,N-K)
!
!     SWAP ROWS IF NECESSARY
!
  LL = ML1 + K - L
  IF (L .NE. K) CALL SSWAP(MP + 1, A(K,ML1), LDA, A(L,LL), LDA)
!
!     SKIP COLUMN REDUCTION IF PIVOT IS ZERO
!
  IF (A(K,ML1) .NE. 0.0) GO TO 20
     INFO = K
     GO TO 40
!
!     COMPUTE MULTIPLIERS
!
20 T = -1.0/A(K,ML1)
  CALL SSCAL(LM, T, A(LMK,LM2), LDB)
!
!     ROW ELIMINATION WITH COLUMN INDEXING
!
  DO J = 1,MP
     JJ = ML1 + J
     J1 = LM2 + J
     CALL SAXPY(LM, A(K,JJ), A(LMK,LM2), LDB, A(LMK,J1), LDB)
  END DO
40 CONTINUE
!
IPVT(N) = N
IF (A(N,ML1) .EQ. 0.0) INFO = N
RETURN
!
!     CASE WHEN ML = 0
!
100 DO K = 1,N
  IPVT(K) = K
  IF (A(K,1) .EQ. 0.0) INFO = K
END DO
RETURN
END SUBROUTINE SNBFA

SUBROUTINE SNBSL (A,LDA,N,ML,MU,IPVT,B,JOB)
! ----------------------------------------------------------------------
!
!     SNBSL SOLVES THE REAL BAND SYSTEM A*X = B OR TRANS(A)*X = B
!     USING THE FACTORS COMPUTED BY SNBFA.
!
!                         ----------
!     ON ENTRY
!
!        A       REAL(LDA, NC)
!                THE OUTPUT FROM SNBFA.
!                NC MUST BE .GE. 2*ML+MU+1 .
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!        IPVT    INTEGER(N)
!                THE PIVOT VECTOR FROM SNBFA.
!
!        B       REAL(N)
!                THE RIGHT HAND SIDE VECTOR.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  A*X = B .
!                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
!                            TRANS(A)  IS THE TRANSPOSE.
!
!     ON RETURN
!
!        B       THE SOLUTION VECTOR  X .
!
!     ERROR CONDITION
!
!        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
!        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
!        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
!        SETTING OF LDA.  IT WILL NOT OCCUR IF SNBFA AND SNBSL ARE
!        CALLED CORRECTLY AND SNBFA HAS SET INFO = 0.
!
!     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!      SAXPY,SDOT
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
INTEGER LDA,N,ML,MU,JOB
REAL A(LDA,*),B(N)
INTEGER IPVT(N)
REAL SDOT,T
INTEGER K,KB,KLM,L,LB,LDB,LM,M,MLM,NM1
!
M = MU + ML + 1
IF (M .EQ. 1) GO TO 100
ML1 = ML + 1
ML2 = ML + 2
NM1 = N - 1
LDB = 1 - LDA
IF (JOB .NE. 0) GO TO 50
!
!     JOB = 0 , SOLVE  A * X = B
!       FIRST SOLVE L*Y = B
!
IF (ML .EQ. 0) GO TO 30
DO K = 1,NM1
   LM = MIN0(ML,N-K)
   L = IPVT(K)
   T = B(L)
   IF (L .EQ. K) GO TO 10
      B(L) = B(K)
      B(K) = T
10 KLM = K + LM
   MLM = ML1 - LM
   CALL SAXPY(LM, T, A(KLM,MLM), LDB, B(K+1), 1)
END DO
!
!       NOW SOLVE  U*X = Y
!
30 K = N
DO KB = 2,N
   B(K) = B(K)/A(K,ML1)
   LM = MIN0(K,M) - 1
   LB = K - LM
   T = -B(K)
   CALL SAXPY(LM, T, A(K-1,ML2), LDB, B(LB), 1)
   K = K - 1
END DO
B(1) = B(1)/A(1,ML1)
RETURN
!
!     JOB = NONZERO, SOLVE TRANS(A) * X = B
!       FIRST SOLVE  TRANS(U)*Y = B
!
50 B(1) = B(1)/A(1,ML1)
DO K = 2,N
   LM = MIN0(K,M) - 1
   LB = K - LM
   T = SDOT(LM, A(K-1,ML2), LDB, B(LB), 1)
   B(K) = (B(K) - T)/A(K,ML1)
END DO
IF (ML .EQ. 0) RETURN
!
!       NOW SOLVE TRANS(L)*X = Y
!
do 70 KB = 1,NM1
   K = N - KB
   LM = MIN0(ML,N-K)
   KLM = K + LM
   MLM = ML1 - LM
   B(K) = B(K) + SDOT(LM, A(KLM,MLM), LDB, B(K+1), 1)
   L = IPVT(K)
   IF (L .EQ. K) GO TO 70
      T = B(L)
      B(L) = B(K)
      B(K) = T
70 CONTINUE
RETURN
!
!     CASE WHEN ML = 0 AND MU = 0
!
100 do 110 K = 1,N
110 B(K) = B(K)/A(K,1)
RETURN
END SUBROUTINE SNBSL

SUBROUTINE DBSLV (M0,A,KA,N,ML,MU,B,IWK,IERR)
! ----------------------------------------------------------------------
!     DBSLV EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN BANDED LINEAR SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
!     IF DBSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO DBSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
!               SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF AX = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO DBSLV, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. DBSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     DBSLV AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), B(N)
INTEGER IWK(N)
IF (M0 .NE. 0) GO TO 10
!
!     ERROR CHECKING
!
IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
CALL DBFA(A,KA,N,ML,MU,IWK,IERR)
IF (IERR .NE. 0) RETURN
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 CALL DBSL(A,KA,N,ML,MU,IWK,B,0)
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE DBSLV

SUBROUTINE DBSLV1 (M0,A,KA,N,ML,MU,B,IWK,IERR)
! ----------------------------------------------------------------------
!     DBSLV1 EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN BANDED LINEAR SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
!     IF DBSLV1 IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO DBSLV1.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
!               SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF XA = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO DBSLV1, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. DBSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     DBSLV1 AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), B(N)
INTEGER IWK(N)
IF (M0 .NE. 0) GO TO 10
!
!     ERROR CHECKING
!
IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
CALL DBFA(A,KA,N,ML,MU,IWK,IERR)
IF (IERR .NE. 0) RETURN
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 CALL DBSL(A,KA,N,ML,MU,IWK,B,1)
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE DBSLV1

SUBROUTINE DBFA (A, LDA, N, ML, MU, IPVT, INFO)
! ----------------------------------------------------------------------
!
!               DBFA FACTORS A REAL BAND MATRIX BY ELIMINATION.
!
!                               --------
!     ON ENTRY
!
!        A       DOUBLE PRECISION(LDA, NC)
!                CONTAINS THE MATRIX IN BAND STORAGE. THE ROWS
!                OF THE ORIGINAL MATRIX ARE STORED IN THE ROWS
!                OF A AND THE DIAGONALS OF THE ORIGINAL MATRIX
!                ARE STORED IN COLUMNS 1 THROUGH ML+MU+1 OF A.
!                NC MUST BE .GE. 2*ML+MU+1 .
!                SEE THE COMMENTS BELOW FOR DETAILS.
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A. IT IS
!                ASSUMED THAT LDA .GE. N.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!                0 .LE. ML .LT. N .
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!                0 .LE. MU .LT. N .
!                MORE EFFICIENT IF ML .LE. MU .
!
!     ON RETURN
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                AND THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
!                L IS A PRODUCT OF PERMUTATION AND UNIT LOWER
!                TRIANGULAR MATRICES AND U IS UPPER TRIANGULAR.
!
!        IPVT    INTEGER(N)
!                AN INTEGER VECTOR OF PIVOT INDICES.
!
!        INFO    INTEGER
!                =0  NORMAL VALUE
!                =K  IF  U(K,K) .EQ. 0. THIS IS NOT AN ERROR
!                CONDITION FOR THIS SUBROUTINE, BUT IT DOES
!                INDICATE THAT DBSL WILL DIVIDE BY ZERO IF
!                IT IS CALLED.
!
!     BAND STORAGE
!
!           IF A0 IS THE MATRIX THEN THE FOLLOWING CODE WILL STORE
!           A0 IN BAND FORM.
!
!                   ML = (BAND WIDTH BELOW THE DIAGONAL)
!                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
!                   DO 20 I = 1, N
!                      J1 = MAX0(1, I-ML)
!                      J2 = MIN0(N, I+MU)
!                      DO 10 J = J1, J2
!                         K = J - I + ML + 1
!                         A(I,K) = A0(I,J)
!                10    CONTINUE
!                20 CONTINUE
!
!           THIS USES COLUMNS 1 THROUGH  ML + MU + 1  OF A.
!           FURTHERMORE, ML ADDITIONAL COLUMNS ARE NEEDED IN
!           A (STARTING WITH COLUMN  ML+MU+2) FOR ELEMENTS
!           GENERATED DURING THE TRIANGULARIZATION. THE TOTAL
!           NUMBER OF COLUMNS NEEDED IN A IS  2*ML+MU+1 .
!
!     EXAMPLE..  IF THE ORIGINAL MATRIX IS
!
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!
!      THEN  N = 6, ML = 1, MU = 2, LDA .GE. 6  AND A SHOULD CONTAIN
!
!              11 12 13  +     , + = USED FOR PIVOTING
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!
!     WRITTEN BY E.A.VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H.MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!        MIN0,IDAMAX,DAXPY,DSCAL,DSWAP
! ----------------------------------------------------------------------
INTEGER LDA,N,ML,MU,INFO
DOUBLE PRECISION A(LDA,*)
INTEGER IPVT(N)
DOUBLE PRECISION T
!
INFO = 0
IF (ML .EQ. 0) GO TO 100
M = ML + MU + 1
!
!     SET FILL-IN COLUMNS TO ZERO
!
DO J = 1,ML
   JJ = M + J
   DO I = 1,N
      A(I,JJ) = 0.D0
   END DO
END DO
!
!     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
!
ML1 = ML + 1
MB = ML + MU
N1 = N - 1
LDB = LDA - 1
do 40 K = 1,N1
  LM = MIN0(N-K,ML)
  LMK = LM + K
  LM1 = LM + 1
  LM2 = ML1 - LM
!
!     SEARCH FOR PIVOT INDEX
!
  L = -IDAMAX(LM1, A(LMK,LM2), LDB) + LM1 + K
  IPVT(K) = L
  MP = MIN0(MB,N-K)
!
!     SWAP ROWS IF NECESSARY
!
  LL = ML1 + K - L
  IF (L .NE. K) CALL DSWAP(MP + 1, A(K,ML1), LDA, A(L,LL), LDA)
!
!     SKIP COLUMN REDUCTION IF PIVOT IS ZERO
!
  IF (A(K,ML1) .NE. 0.D0) GO TO 20
     INFO = K
     GO TO 40
!
!     COMPUTE MULTIPLIERS
!
20 T = -1.D0/A(K,ML1)
  CALL DSCAL(LM, T, A(LMK,LM2), LDB)
!
!     ROW ELIMINATION WITH COLUMN INDEXING
!
  DO J = 1,MP
     JJ = ML1 + J
     J1 = LM2 + J
     CALL DAXPY(LM, A(K,JJ), A(LMK,LM2), LDB, A(LMK,J1), LDB)
  END DO
40 CONTINUE
!
IPVT(N) = N
IF (A(N,ML1) .EQ. 0.D0) INFO = N
RETURN
!
!     CASE WHEN ML = 0
!
100 DO K = 1,N
  IPVT(K) = K
  IF (A(K,1) .EQ. 0.D0) INFO = K
END DO
RETURN
END SUBROUTINE DBFA

SUBROUTINE DBSL (A,LDA,N,ML,MU,IPVT,B,JOB)
! ----------------------------------------------------------------------
!
!     DBSL SOLVES THE REAL BAND SYSTEM A*X = B OR TRANS(A)*X = B
!     USING THE FACTORS COMPUTED BY DBFA.
!
!                         ----------
!     ON ENTRY
!
!        A       DOUBLE PRECISION(LDA, NC)
!                THE OUTPUT FROM DBFA.
!                NC MUST BE .GE. 2*ML+MU+1 .
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!        IPVT    INTEGER(N)
!                THE PIVOT VECTOR FROM DBFA.
!
!        B       DOUBLE PRECISION(N)
!                THE RIGHT HAND SIDE VECTOR.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  A*X = B .
!                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
!                            TRANS(A)  IS THE TRANSPOSE.
!
!     ON RETURN
!
!        B       THE SOLUTION VECTOR  X .
!
!     ERROR CONDITION
!
!        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
!        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
!        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
!        SETTING OF LDA.  IT WILL NOT OCCUR IF DBFA AND DBSL ARE
!        CALLED CORRECTLY AND DBFA HAS SET INFO = 0.
!
!     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!      DAXPY,DDOT
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
INTEGER LDA,N,ML,MU,JOB
DOUBLE PRECISION A(LDA,*),B(N)
INTEGER IPVT(N)
DOUBLE PRECISION DDOT,T
INTEGER K,KB,KLM,L,LB,LDB,LM,M,MLM,NM1
!
M = MU + ML + 1
IF (M .EQ. 1) GO TO 100
ML1 = ML + 1
ML2 = ML + 2
NM1 = N - 1
LDB = 1 - LDA
IF (JOB .NE. 0) GO TO 50
!
!     JOB = 0 , SOLVE  A * X = B
!       FIRST SOLVE L*Y = B
!
IF (ML .EQ. 0) GO TO 30
DO K = 1,NM1
   LM = MIN0(ML,N-K)
   L = IPVT(K)
   T = B(L)
   IF (L .EQ. K) GO TO 10
      B(L) = B(K)
      B(K) = T
10 KLM = K + LM
   MLM = ML1 - LM
   CALL DAXPY(LM, T, A(KLM,MLM), LDB, B(K+1), 1)
END DO
!
!       NOW SOLVE  U*X = Y
!
30 K = N
DO KB = 2,N
   B(K) = B(K)/A(K,ML1)
   LM = MIN0(K,M) - 1
   LB = K - LM
   T = -B(K)
   CALL DAXPY(LM, T, A(K-1,ML2), LDB, B(LB), 1)
   K = K - 1
END DO
B(1) = B(1)/A(1,ML1)
RETURN
!
!     JOB = NONZERO, SOLVE TRANS(A) * X = B
!       FIRST SOLVE  TRANS(U)*Y = B
!
50 B(1) = B(1)/A(1,ML1)
DO K = 2,N
   LM = MIN0(K,M) - 1
   LB = K - LM
   T = DDOT(LM, A(K-1,ML2), LDB, B(LB), 1)
   B(K) = (B(K) - T)/A(K,ML1)
END DO
IF (ML .EQ. 0) RETURN
!
!       NOW SOLVE TRANS(L)*X = Y
!
do 70 KB = 1,NM1
   K = N - KB
   LM = MIN0(ML,N-K)
   KLM = K + LM
   MLM = ML1 - LM
   B(K) = B(K) + DDOT(LM, A(KLM,MLM), LDB, B(K+1), 1)
   L = IPVT(K)
   IF (L .EQ. K) GO TO 70
      T = B(L)
      B(L) = B(K)
      B(K) = T
70 CONTINUE
RETURN
!
!     CASE WHEN ML = 0 AND MU = 0
!
100 do 110 K = 1,N
110 B(K) = B(K)/A(K,1)
RETURN
END SUBROUTINE DBSL

SUBROUTINE B1CND (A, KA, N, ML, MU, COND, IWK, WK, IERR)
!-----------------------------------------------------------------------
!              COMPUTATION OF THE L1 CONDITION NUMBER
!                       OF A BANDED MATRIX A
!-----------------------------------------------------------------------
REAL A(KA,*), WK(*)
INTEGER IWK(*)
!-----------------------
!     REAL WK(2*N)
!     INTEGER IWK(2*N)
!-----------------------
COND = 0.0
IF (N .LE. 0 .OR. KA .LT. N) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
ANORM = B1NRM(A, KA, N, N, ML, MU)
IF (ANORM .EQ. 0.0) GO TO 40
!
IX = 1
IV = N + 1
ISGN = N + 1
!
KASE = 0
AINORM = 0.0
CALL SONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE, &
&ITER, J, JUMP)
CALL BSLV (0, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
!
!     CHECK IF A IS SINGULAR
!
IF (IERR .GT. 0) GO TO 40
!
!     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
!     OF THE INVERSE OF A
!
10 CALL SONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE, &
&ITER, J, JUMP)
IF (KASE .EQ. 0) GO TO 30
IF (KASE .NE. 1) GO TO 20
   CALL BSLV (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
   GO TO 10
20 CALL BSLV1 (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
GO TO 10
!
!     COMPUTE THE VALUE OF COND
!
30 COND = ANORM*AINORM
RETURN
!
!     SINGULAR CASE
!
40 IERR = 1
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE B1CND

SUBROUTINE DB1CND (A, KA, N, ML, MU, COND, IWK, WK, IERR)
!-----------------------------------------------------------------------
!            COMPUTATION OF THE L1 CONDITION NUMBER OF
!               A DOUBLE PRECISION BANDED MATRIX A
!-----------------------------------------------------------------------
DOUBLE PRECISION A(KA,*), COND, WK(*)
INTEGER IWK(*)
DOUBLE PRECISION ANORM, AINORM
DOUBLE PRECISION DB1NRM
!-----------------------
!     DOUBLE PRECISION WK(2*N)
!     INTEGER IWK(2*N)
!-----------------------
COND = 0.D0
IF (N .LE. 0 .OR. KA .LT. N) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
ANORM = DB1NRM(A, KA, N, N, ML, MU)
IF (ANORM .EQ. 0.D0) GO TO 40
!
IX = 1
IV = N + 1
ISGN = N + 1
!
KASE = 0
AINORM = 0.D0
CALL DONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE, &
&ITER, J, JUMP)
CALL DBSLV (0, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
!
!     CHECK IF A IS SINGULAR
!
IF (IERR .GT. 0) GO TO 40
!
!     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
!     OF THE INVERSE OF A
!
10 CALL DONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE, &
&ITER, J, JUMP)
IF (KASE .EQ. 0) GO TO 30
IF (KASE .NE. 1) GO TO 20
   CALL DBSLV (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
   GO TO 10
20 CALL DBSLV1 (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
GO TO 10
!
!     COMPUTE THE VALUE OF COND
!
30 COND = ANORM*AINORM
RETURN
!
!     SINGULAR CASE
!
40 IERR = 1
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE DB1CND

SUBROUTINE CBSLV(M0,A,KA,N,ML,MU,B,IWK,IERR)
! ----------------------------------------------------------------------
!     CBSLV EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN COMPLEX BANDED SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
!     IF CBSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO CBSLV.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!               A IS A COMPLEX ARRAY.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT
!               HAND SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF AX = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO CBSLV, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. CBSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     CBSLV AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
COMPLEX A(KA,*),B(N)
INTEGER IWK(N)
IF (M0 .NE. 0) GO TO 10
!
!     ERROR CHECKING
!
IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
CALL CBFA(A,KA,N,ML,MU,IWK,IERR)
IF (IERR .NE. 0) RETURN
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 CALL CBSL(A,KA,N,ML,MU,IWK,B,0)
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE CBSLV

SUBROUTINE CBSLV1(M0,A,KA,N,ML,MU,B,IWK,IERR)
! ----------------------------------------------------------------------
!     CBSLV1 EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
!     THE NXN COMPLEX BANDED SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
!     IF CBSLV1 IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
!     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
!     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
!     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
!     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
!     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO CBSLV1.
!
!
!     INPUT ARGUMENTS WHEN M0=0 ---
!
!     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
!               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
!               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
!               A IS A COMPLEX ARRAY.
!
!     N         NUMBER OF EQUATIONS AND UNKNOWNS.
!
!     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!     B         COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT
!               HAND SIDE DATA.
!
!
!     OUTPUT ARGUMENTS WHEN M0=0 ---
!
!     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
!               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!
!     B         THE SOLUTION OF THE EQUATIONS.
!
!     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
!
!     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
!               IERR=0 IF THE SOLUTION OF XA = B IS OBTAINED.
!               OTHERWISE IERR.NE.0.
!
!
!     AFTER AN INITIAL CALL TO CBSLV1, THE ROUTINE MAY BE RECALLED
!     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
!     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. CBSLV RETRIEVES THE
!     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
!     CBSLV1 AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE IERR
!     IS NOT REFERENCED.
! ----------------------------------------------------------------------
COMPLEX A(KA,*),B(N)
INTEGER IWK(N)
IF (M0 .NE. 0) GO TO 10
!
!     ERROR CHECKING
!
IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
!
!     OBTAIN AN LU DECOMPOSITION OF A
!
CALL CBFA(A,KA,N,ML,MU,IWK,IERR)
IF (IERR .NE. 0) RETURN
!
!     SOLVE THE SYSTEM OF EQUATIONS
!
10 CALL CBSL(A,KA,N,ML,MU,IWK,B,1)
RETURN
!
!     ERROR RETURN
!
100 IERR = -1
RETURN
110 IERR = -2
RETURN
120 IERR = -3
RETURN
END SUBROUTINE CBSLV1

SUBROUTINE CBFA (A, LDA, N, ML, MU, IPVT, INFO)
! ----------------------------------------------------------------------
!
!               CBFA FACTORS A COMPLEX BAND MATRIX BY ELIMINATION.
!
!                              ----------
!     ON ENTRY
!
!        A       COMPLEX(LDA, NC)
!                CONTAINS THE MATRIX IN BAND STORAGE. THE ROWS
!                OF THE ORIGINAL MATRIX ARE STORED IN THE ROWS
!                OF A AND THE DIAGONALS OF THE ORIGINAL MATRIX
!                ARE STORED IN COLUMNS 1 THROUGH ML+MU+1 OF A.
!                NC MUST BE .GE. 2*ML+MU+1 .
!                SEE THE COMMENTS BELOW FOR DETAILS.
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A. IT IS
!                ASSUMED THAT LDA .GE. N.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!                0 .LE. ML .LT. N .
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!                0 .LE. MU .LT. N .
!                MORE EFFICIENT IF ML .LE. MU .
!
!     ON RETURN
!
!        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
!                AND THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
!                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
!                L IS A PRODUCT OF PERMUTATION AND UNIT LOWER
!                TRIANGULAR MATRICES AND U IS UPPER TRIANGULAR.
!
!        IPVT    INTEGER(N)
!                AN INTEGER VECTOR OF PIVOT INDICES.
!
!        INFO    INTEGER
!                =0  NORMAL VALUE
!                =K  IF  U(K,K) .EQ. 0. THIS IS NOT AN ERROR
!                CONDITION FOR THIS SUBROUTINE, BUT IT DOES
!                INDICATE THAT CBSL WILL DIVIDE BY ZERO IF
!                IT IS CALLED.
!
!     BAND STORAGE
!
!           IF A0 IS THE MATRIX THEN THE FOLLOWING CODE WILL STORE
!           A0 IN BAND FORM.
!
!                   ML = (BAND WIDTH BELOW THE DIAGONAL)
!                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
!                   DO 20 I = 1, N
!                      J1 = MAX0(1, I-ML)
!                      J2 = MIN0(N, I+MU)
!                      DO 10 J = J1, J2
!                         K = J - I + ML + 1
!                         A(I,K) = A0(I,J)
!                10    CONTINUE
!                20 CONTINUE
!
!           THIS USES COLUMNS 1 THROUGH  ML + MU + 1  OF A.
!           FURTHERMORE, ML ADDITIONAL COLUMNS ARE NEEDED IN
!           A (STARTING WITH COLUMN  ML+MU+2) FOR ELEMENTS
!           GENERATED DURING THE TRIANGULARIZATION. THE TOTAL
!           NUMBER OF COLUMNS NEEDED IN A IS  2*ML+MU+1 .
!
!     EXAMPLE..  IF THE ORIGINAL MATRIX IS
!
!           11 12 13  0  0  0
!           21 22 23 24  0  0
!            0 32 33 34 35  0
!            0  0 43 44 45 46
!            0  0  0 54 55 56
!            0  0  0  0 65 66
!
!      THEN  N = 6, ML = 1, MU = 2, LDA .GE. 6  AND A SHOULD CONTAIN
!
!              11 12 13  +     , + = USED FOR PIVOTING
!           21 22 23 24  +
!           32 33 34 35  +
!           43 44 45 46  +
!           54 55 56  +  +
!           65 66  +  +  +
!
!     WRITTEN BY E.A.VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     MODIFIED BY A.H.MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!        MIN0,ICAMAX,CAXPY,CSCAL,CSWAP
! ----------------------------------------------------------------------
INTEGER LDA,N,ML,MU,INFO
COMPLEX A(LDA,*)
INTEGER IPVT(N)
COMPLEX T
!
INFO = 0
IF (ML .EQ. 0) GO TO 100
M = ML + MU + 1
!
!     SET FILL-IN COLUMNS TO ZERO
!
DO J = 1,ML
   JJ = M + J
   DO I = 1,N
      A(I,JJ) = (0.0,0.0)
   END DO
END DO
!
!     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
!
ML1 = ML + 1
MB = ML + MU
N1 = N - 1
LDB = LDA - 1
do 40 K = 1,N1
  LM = MIN0(N-K,ML)
  LMK = LM + K
  LM1 = LM + 1
  LM2 = ML1 - LM
!
!     SEARCH FOR PIVOT INDEX
!
  L = -ICAMAX(LM1, A(LMK,LM2), LDB) + LM1 + K
  IPVT(K) = L
  MP = MIN0(MB,N-K)
!
!     SWAP ROWS IF NECESSARY
!
  LL = ML1 + K - L
  IF (L .NE. K) CALL CSWAP(MP + 1, A(K,ML1), LDA, A(L,LL), LDA)
!
!     SKIP COLUMN REDUCTION IF PIVOT IS ZERO
!
  IF (A(K,ML1) .NE. (0.0,0.0)) GO TO 20
     INFO = K
     GO TO 40
!
!     COMPUTE MULTIPLIERS
!
20 T = (-1.0,0.0)/A(K,ML1)
  CALL CSCAL(LM, T, A(LMK,LM2), LDB)
!
!     ROW ELIMINATION WITH COLUMN INDEXING
!
  DO J = 1,MP
     JJ = ML1 + J
     J1 = LM2 + J
     CALL CAXPY(LM, A(K,JJ), A(LMK,LM2), LDB, A(LMK,J1), LDB)
  END DO
40 CONTINUE
!
IPVT(N) = N
IF (A(N,ML1) .EQ. (0.0,0.0)) INFO = N
RETURN
!
!     CASE WHEN ML = 0
!
100 DO K = 1,N
  IPVT(K) = K
  IF (A(K,1) .EQ. (0.0,0.0)) INFO = K
END DO
RETURN
END SUBROUTINE CBFA

SUBROUTINE CBSL (A,LDA,N,ML,MU,IPVT,B,JOB)
! ----------------------------------------------------------------------
!
!     CBSL SOLVES THE COMPLEX BAND SYSTEM A*X = B OR TRANS(A)*X = B
!     USING THE FACTORS COMPUTED BY CBFA.
!
!                         ----------
!     ON ENTRY
!
!        A       COMPLEX(LDA, NC)
!                THE OUTPUT FROM CBFA.
!                NC MUST BE .GE. 2*ML+MU+1 .
!
!        LDA     INTEGER
!                THE LEADING DIMENSION OF THE ARRAY A.
!
!        N       INTEGER
!                THE ORDER OF THE ORIGINAL MATRIX.
!
!        ML      INTEGER
!                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
!
!        MU      INTEGER
!                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
!
!        IPVT    INTEGER(N)
!                THE PIVOT VECTOR FROM CBFA.
!
!        B       COMPLEX(N)
!                THE RIGHT HAND SIDE VECTOR.
!
!        JOB     INTEGER
!                = 0         TO SOLVE  A*X = B .
!                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
!                            TRANS(A)  IS THE TRANSPOSE.
!
!     ON RETURN
!
!        B       THE SOLUTION VECTOR  X .
!
!     ERROR CONDITION
!
!        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
!        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
!        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
!        SETTING OF LDA.  IT WILL NOT OCCUR IF CBFA AND CBSL ARE
!        CALLED CORRECTLY AND CBFA HAS SET INFO = 0.
!
!     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
!     ADAPTED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
!
!     SUBROUTINES AND FUNCTIONS
!      CAXPY,CDOTU
!
!     FORTRAN  MIN0
! ----------------------------------------------------------------------
INTEGER LDA,N,ML,MU,JOB
COMPLEX A(LDA,*),B(N)
INTEGER IPVT(N)
COMPLEX CDOTU,T
INTEGER K,KB,KLM,L,LB,LDB,LM,M,MLM,NM1
!
M = MU + ML + 1
IF (M .EQ. 1) GO TO 100
ML1 = ML + 1
ML2 = ML + 2
NM1 = N - 1
LDB = 1 - LDA
IF (JOB .NE. 0) GO TO 50
!
!     JOB = 0 , SOLVE  A * X = B
!       FIRST SOLVE L*Y = B
!
IF (ML .EQ. 0) GO TO 30
DO K = 1,NM1
   LM = MIN0(ML,N-K)
   L = IPVT(K)
   T = B(L)
   IF (L .EQ. K) GO TO 10
      B(L) = B(K)
      B(K) = T
10 KLM = K + LM
   MLM = ML1 - LM
   CALL CAXPY(LM, T, A(KLM,MLM), LDB, B(K+1), 1)
END DO
!
!       NOW SOLVE  U*X = Y
!
30 K = N
DO KB = 2,N
   B(K) = B(K)/A(K,ML1)
   LM = MIN0(K,M) - 1
   LB = K - LM
   T = -B(K)
   CALL CAXPY(LM, T, A(K-1,ML2), LDB, B(LB), 1)
   K = K - 1
END DO
B(1) = B(1)/A(1,ML1)
RETURN
!
!     JOB = NONZERO, SOLVE TRANS(A) * X = B
!       FIRST SOLVE  TRANS(U)*Y = B
!
50 B(1) = B(1)/A(1,ML1)
DO K = 2,N
   LM = MIN0(K,M) - 1
   LB = K - LM
   T = CDOTU(LM, A(K-1,ML2), LDB, B(LB), 1)
   B(K) = (B(K) - T)/A(K,ML1)
END DO
IF (ML .EQ. 0) RETURN
!
!       NOW SOLVE TRANS(L)*X = Y
!
do 70 KB = 1, NM1
   K = N - KB
   LM = MIN0(ML,N-K)
   KLM = K + LM
   MLM = ML1 - LM
   B(K) = B(K) + CDOTU(LM, A(KLM,MLM), LDB, B(K+1), 1)
   L = IPVT(K)
   IF (L .EQ. K) GO TO 70
      T = B(L)
      B(L) = B(K)
      B(K) = T
70 CONTINUE
RETURN
!
!     CASE WHEN ML = 0 AND MU = 0
!
100 do 110 K = 1,N
110 B(K) = B(K)/A(K,1)
RETURN
END SUBROUTINE CBSL

SUBROUTINE CVRS (A, KA, M, N, B, IB, JB, NUM, IERR)
REAL A(KA,N), B(*)
INTEGER IB(*), JB(*)
!
!                 STORE THE I-TH ROW
!
IP = 1
DO I = 1,M
   IB(I) = IP
   do 10 J = 1,N
      IF (A(I,J) .EQ. 0.0) GO TO 10
      IF (IP .GT. NUM) GO TO 20
      B(IP) = A(I,J)
      JB(IP) = J
      IP = IP + 1
10 CONTINUE
END DO
!
!                 COMPLETE THE SETUP
!
IB(M + 1) = IP
IERR = 0
RETURN
!
!                   ERROR RETURN
!
20 IERR = I
RETURN
END SUBROUTINE CVRS

SUBROUTINE CVDS (A, KA, M, N, B, IB, JB, NUM, IERR)
DOUBLE PRECISION A(KA,N), B(*)
INTEGER IB(*), JB(*)
!
!                 STORE THE I-TH ROW
!
IP = 1
DO I = 1,M
   IB(I) = IP
   do 10 J = 1,N
      IF (A(I,J) .EQ. 0.D0) GO TO 10
      IF (IP .GT. NUM) GO TO 20
      B(IP) = A(I,J)
      JB(IP) = J
      IP = IP + 1
10 CONTINUE
END DO
!
!                 COMPLETE THE SETUP
!
IB(M + 1) = IP
IERR = 0
RETURN
!
!                   ERROR RETURN
!
20 IERR = I
RETURN
END SUBROUTINE CVDS

SUBROUTINE CVCS (A, KA, M, N, B, IB, JB, NUM, IERR)
COMPLEX A(KA,N), B(*), ZERO
INTEGER IB(*), JB(*)
DATA ZERO /(0.0,0.0)/
!
!                 STORE THE I-TH ROW
!
IP = 1
DO I = 1,M
   IB(I) = IP
   do 10 J = 1,N
      IF (A(I,J) .EQ. ZERO) GO TO 10
      IF (IP .GT. NUM) GO TO 20
      B(IP) = A(I,J)
      JB(IP) = J
      IP = IP + 1
10 CONTINUE
END DO
!
!                 COMPLETE THE SETUP
!
IB(M + 1) = IP
IERR = 0
RETURN
!
!                   ERROR RETURN
!
20 IERR = I
RETURN
END SUBROUTINE CVCS

SUBROUTINE CVSR (A, IA, JA, B, KB, M, N)
REAL A(*), B(KB,N)
INTEGER IA(*), JA(*)
!
do 30 I = 1,M
!
!                 CLEAR THE I-TH ROW
!
   DO J = 1,N
      B(I,J) = 0.0
   END DO
!
!                 STORE THE I-TH ROW
!
   IPMIN = IA(I)
   IPMAX = IA(I+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 30
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      B(I,J) = A(IP)
   END DO
!
30 CONTINUE
RETURN
END SUBROUTINE CVSR

SUBROUTINE CVSD (A, IA, JA, B, KB, M, N)
DOUBLE PRECISION A(*), B(KB,N)
INTEGER IA(*), JA(*)
!
do 30 I = 1,M
!
!                 CLEAR THE I-TH ROW
!
   DO J = 1,N
      B(I,J) = 0.D0
   END DO
!
!                 STORE THE I-TH ROW
!
   IPMIN = IA(I)
   IPMAX = IA(I+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 30
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      B(I,J) = A(IP)
   END DO
!
30 CONTINUE
RETURN
END SUBROUTINE CVSD

SUBROUTINE CVSC (A, IA, JA, B, KB, M, N)
COMPLEX A(*), B(KB,N)
INTEGER IA(*), JA(*)
!
do 30 I = 1,M
!
!                 CLEAR THE I-TH ROW
!
   DO J = 1,N
      B(I,J) = (0.0,0.0)
   END DO
!
!                 STORE THE I-TH ROW
!
   IPMIN = IA(I)
   IPMAX = IA(I+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 30
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      B(I,J) = A(IP)
   END DO
!
30 CONTINUE
RETURN
END SUBROUTINE CVSC

SUBROUTINE SCVRD (A, IA, JA, B, IB, JB, M)
REAL A(*)
DOUBLE PRECISION B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
L = 1
do 20 I = 1,M
   IB(I) = L
   IBEG = IA(I)
   IEND = IA(I+1) - 1
   IF (IBEG .GT. IEND) GO TO 20
   do 10 IP = IBEG,IEND
      IF (A(IP) .EQ. 0.0) GO TO 10
      B(L) = A(IP)
      JB(L) = JA(IP)
      L = L + 1
10 CONTINUE
20 CONTINUE
IB(M + 1) = L
RETURN
END SUBROUTINE SCVRD

SUBROUTINE SCVDR (A, IA, JA, B, IB, JB, M)
DOUBLE PRECISION A(*)
REAL B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
L = 1
do 20 I = 1,M
   IB(I) = L
   IBEG = IA(I)
   IEND = IA(I+1) - 1
   IF (IBEG .GT. IEND) GO TO 20
   do 10 IP = IBEG,IEND
      IF (A(IP) .EQ. 0.D0) GO TO 10
      B(L) = A(IP)
      JB(L) = JA(IP)
      L = L + 1
10 CONTINUE
20 CONTINUE
IB(M + 1) = L
RETURN
END SUBROUTINE SCVDR

SUBROUTINE CSREAL (A, IA, JA, B, IB, JB, M)
!-----------------------------------------------------------------------
!              REAL PART OF A SPARSE COMPLEX MATRIX
!-----------------------------------------------------------------------
COMPLEX A(*)
REAL B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
L = 1
do 20 I = 1,M
   IB(I) = L
   IBEG = IA(I)
   IEND = IA(I+1) - 1
   IF (IBEG .GT. IEND) GO TO 20
   do 10 IP = IBEG,IEND
      T = REAL(A(IP))
      IF (T .EQ. 0.0) GO TO 10
      B(L) = T
      JB(L) = JA(IP)
      L = L + 1
10 CONTINUE
20 CONTINUE
IB(M + 1) = L
RETURN
END SUBROUTINE CSREAL

SUBROUTINE CSIMAG (A, IA, JA, B, IB, JB, M)
!-----------------------------------------------------------------------
!            IMAGINARY PART OF A SPARSE COMPLEX MATRIX
!-----------------------------------------------------------------------
COMPLEX A(*)
REAL B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
L = 1
do 20 I = 1,M
   IB(I) = L
   IBEG = IA(I)
   IEND = IA(I+1) - 1
   IF (IBEG .GT. IEND) GO TO 20
   do 10 IP = IBEG,IEND
      T = AIMAG(A(IP))
      IF (T .EQ. 0.0) GO TO 10
      B(L) = T
      JB(L) = JA(IP)
      L = L + 1
10 CONTINUE
20 CONTINUE
IB(M + 1) = L
RETURN
END SUBROUTINE CSIMAG

SUBROUTINE SCVRC (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!       COMPUTE A + BI FOR THE SPARSE REAL MATRICES A AND B
!-----------------------------------------------------------------------
REAL A(*), B(*), WK(N)
COMPLEX C(*), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO J = 1,N
   WK(J) = 0.0
END DO
!
!                  COMPUTE THE I-TH ROW OF C
!
IP = 1
do 42 I = 1,M
   IC(I) = IP
   MINA = IA(I)
   MAXA = IA(I+1) - 1
   IF (MINA .GT. MAXA) GO TO 30
   DO L = MINA,MAXA
      J = JA(L)
      WK(J) = A(L)
   END DO
!
30 MINB = IB(I)
   MAXB = IB(I+1) - 1
   IF (MINB .GT. MAXB) GO TO 40
   do 31 L = MINB,MAXB
      IF (B(L) .EQ. 0.0) GO TO 31
      J = JB(L)
      T = CMPLX (WK(J), B(L))
      WK(J) = 0.0
      IF (IP .GT. NUM) GO TO 50
      C(IP) = T
      JC(IP) = J
      IP = IP + 1
31 CONTINUE
!
40 IF (MINA .GT. MAXA) GO TO 42
   do 41 L = MINA,MAXA
      J = JA(L)
      IF (WK(J) .EQ. 0.0) GO TO 41
      IF (IP .GT. NUM) GO TO 50
      C(IP) = CMPLX (WK(J), 0.0)
      WK(J) = 0.0
      JC(IP) = J
      IP = IP + 1
41 CONTINUE
42 CONTINUE
IC(M + 1) = IP
IERR = 0
RETURN
!
!                        ERROR RETURN
!
50 IERR = I
RETURN
END SUBROUTINE SCVRC

SUBROUTINE RSCOPY (A, IA, JA, B, IB, JB, M)
!-----------------------------------------------------------------------
!                  COPYING A SPARSE REAL MATRIX
!-----------------------------------------------------------------------
REAL A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
L = 1
do 20 I = 1,M
   IB(I) = L
   IBEG = IA(I)
   IEND = IA(I+1) - 1
   IF (IBEG .GT. IEND) GO TO 20
   do 10 IP = IBEG,IEND
      IF (A(IP) .EQ. 0.0) GO TO 10
      B(L) = A(IP)
      JB(L) = JA(IP)
      L = L + 1
10 CONTINUE
20 CONTINUE
IB(M + 1) = L
RETURN
END SUBROUTINE RSCOPY

SUBROUTINE DSCOPY (A, IA, JA, B, IB, JB, M)
!-----------------------------------------------------------------------
!              COPYING A SPARSE DOUBLE PRECISION MATRIX
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
L = 1
do 20 I = 1,M
   IB(I) = L
   IBEG = IA(I)
   IEND = IA(I+1) - 1
   IF (IBEG .GT. IEND) GO TO 20
   do 10 IP = IBEG,IEND
      IF (A(IP) .EQ. 0.D0) GO TO 10
      B(L) = A(IP)
      JB(L) = JA(IP)
      L = L + 1
10 CONTINUE
20 CONTINUE
IB(M + 1) = L
RETURN
END SUBROUTINE DSCOPY

SUBROUTINE CSCOPY (A, IA, JA, B, IB, JB, M)
!-----------------------------------------------------------------------
!                 COPYING A SPARSE COMPLEX MATRIX
!-----------------------------------------------------------------------
COMPLEX A(*), B(*), ZERO
INTEGER IA(*), JA(*), IB(*), JB(*)
DATA ZERO /(0.0,0.0)/
!
L = 1
do 20 I = 1,M
   IB(I) = L
   IBEG = IA(I)
   IEND = IA(I+1) - 1
   IF (IBEG .GT. IEND) GO TO 20
   do 10 IP = IBEG,IEND
      IF (A(IP) .EQ. ZERO) GO TO 10
      B(L) = A(IP)
      JB(L) = JA(IP)
      L = L + 1
10 CONTINUE
20 CONTINUE
IB(M + 1) = L
RETURN
END SUBROUTINE CSCOPY

SUBROUTINE SCONJ (A, IA, JA, B, IB, JB, M)
!-----------------------------------------------------------------------
!     COMPUTATION OF THE CONJUGATE OF A SPARSE COMPLEX MATRIX
!-----------------------------------------------------------------------
COMPLEX A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
MP1 = M + 1
L = IA(1) - 1
DO I = 1,MP1
   IB(I) = IA(I) - L
END DO
!
IBEG = IA(1)
IEND = IA(MP1) - 1
IF (IBEG .GT. IEND) RETURN
L = 1
DO IP = IBEG,IEND
   B(L) = CONJG(A(IP))
   JB(L) = JA(IP)
   L = L + 1
END DO
RETURN
END SUBROUTINE SCONJ

SUBROUTINE RPOSE (A, IA, JA, B, IB, JB, M, N)
!-----------------------------------------------------------------------
!                 TRANSPOSING A SPARSE REAL MATRIX
!-----------------------------------------------------------------------
REAL A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
!
IPMIN = IA(1)
IPMAX = IA(M+1) - 1
IF (IPMIN .GT. IPMAX) GO TO 40
DO J = 1,N
   IB(J) = 0
END DO
DO IP = IPMIN,IPMAX
   J = JA(IP)
   IB(J) = IB(J) + 1
END DO
!
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
NUM = IA(M+1) - IA(1) + 1
J = N
DO JJ = 1,N
   NUM = NUM - IB(J)
   IB(J+1) = NUM
   J = J - 1
END DO
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
!
do 31 I = 1,M
   IPMIN = IA(I)
   IPMAX = IA(I+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 31
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      JP = IB(J+1)
      JB(JP) = I
      B(JP) = A(IP)
      IB(J+1) = JP + 1
   END DO
31 CONTINUE
IB(1) = 1
RETURN
!
!                    TRANSPOSE A ZERO MATRIX A
!
40 NP1 = N + 1
DO J = 1,NP1
   IB(J) = 1
END DO
RETURN
END SUBROUTINE RPOSE

SUBROUTINE RPOSE1 (P, A, IA, JA, B, IB, JB, M, N)
!-----------------------------------------------------------------------
!                 TRANSPOSING A SPARSE REAL MATRIX
!                 WHERE THE ROWS ARE INTERCHANGED
!-----------------------------------------------------------------------
INTEGER P(M)
REAL A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
!
IPMIN = IA(1)
IPMAX = IA(M+1) - 1
IF (IPMIN .GT. IPMAX) GO TO 40
DO J = 1,N
   IB(J) = 0
END DO
DO IP = IPMIN,IPMAX
   J = JA(IP)
   IB(J) = IB(J) + 1
END DO
!
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
NUM = IA(M+1) - IA(1) + 1
J = N
DO JJ = 1,N
   NUM = NUM - IB(J)
   IB(J+1) = NUM
   J = J - 1
END DO
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
!
do 31 I = 1,M
   II = P(I)
   IPMIN = IA(II)
   IPMAX = IA(II+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 31
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      JP = IB(J+1)
      JB(JP) = I
      B(JP) = A(IP)
      IB(J+1) = JP + 1
   END DO
31 CONTINUE
IB(1) = 1
RETURN
!
!                    TRANSPOSE A ZERO MATRIX A
!
40 NP1 = N + 1
DO J = 1,NP1
   IB(J) = 1
END DO
RETURN
END SUBROUTINE RPOSE1

SUBROUTINE DPOSE (A, IA, JA, B, IB, JB, M, N)
!-----------------------------------------------------------------------
!           TRANSPOSING A SPARSE DOUBLE PRECISION MATRIX
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
!
IPMIN = IA(1)
IPMAX = IA(M+1) - 1
IF (IPMIN .GT. IPMAX) GO TO 40
DO J = 1,N
   IB(J) = 0
END DO
DO IP = IPMIN,IPMAX
   J = JA(IP)
   IB(J) = IB(J) + 1
END DO
!
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
NUM = IA(M+1) - IA(1) + 1
J = N
DO JJ = 1,N
   NUM = NUM - IB(J)
   IB(J+1) = NUM
   J = J - 1
END DO
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
!
do 31 I = 1,M
   IPMIN = IA(I)
   IPMAX = IA(I+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 31
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      JP = IB(J+1)
      JB(JP) = I
      B(JP) = A(IP)
      IB(J+1) = JP + 1
   END DO
31 CONTINUE
IB(1) = 1
RETURN
!
!                    TRANSPOSE A ZERO MATRIX A
!
40 NP1 = N + 1
DO J = 1,NP1
   IB(J) = 1
END DO
RETURN
END SUBROUTINE DPOSE

SUBROUTINE DPOSE1 (P, A, IA, JA, B, IB, JB, M, N)
!-----------------------------------------------------------------------
!           TRANSPOSING A SPARSE DOUBLE PRECISION MATRIX
!                 WHERE THE ROWS ARE INTERCHANGED
!-----------------------------------------------------------------------
INTEGER P(M)
DOUBLE PRECISION A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
!
IPMIN = IA(1)
IPMAX = IA(M+1) - 1
IF (IPMIN .GT. IPMAX) GO TO 40
DO J = 1,N
   IB(J) = 0
END DO
DO IP = IPMIN,IPMAX
   J = JA(IP)
   IB(J) = IB(J) + 1
END DO
!
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
NUM = IA(M+1) - IA(1) + 1
J = N
DO JJ = 1,N
   NUM = NUM - IB(J)
   IB(J+1) = NUM
   J = J - 1
END DO
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
!
do 31 I = 1,M
   II = P(I)
   IPMIN = IA(II)
   IPMAX = IA(II+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 31
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      JP = IB(J+1)
      JB(JP) = I
      B(JP) = A(IP)
      IB(J+1) = JP + 1
   END DO
31 CONTINUE
IB(1) = 1
RETURN
!
!                    TRANSPOSE A ZERO MATRIX A
!
40 NP1 = N + 1
DO J = 1,NP1
   IB(J) = 1
END DO
RETURN
END SUBROUTINE DPOSE1

SUBROUTINE CPOSE (A, IA, JA, B, IB, JB, M, N)
!-----------------------------------------------------------------------
!               TRANSPOSING A SPARSE COMPLEX MATRIX
!-----------------------------------------------------------------------
COMPLEX A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
!
IPMIN = IA(1)
IPMAX = IA(M+1) - 1
IF (IPMIN .GT. IPMAX) GO TO 40
DO J = 1,N
   IB(J) = 0
END DO
DO IP = IPMIN,IPMAX
   J = JA(IP)
   IB(J) = IB(J) + 1
END DO
!
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
NUM = IA(M+1) - IA(1) + 1
J = N
DO JJ = 1,N
   NUM = NUM - IB(J)
   IB(J+1) = NUM
   J = J - 1
END DO
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
!
do 31 I = 1,M
   IPMIN = IA(I)
   IPMAX = IA(I+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 31
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      JP = IB(J+1)
      JB(JP) = I
      B(JP) = A(IP)
      IB(J+1) = JP + 1
   END DO
31 CONTINUE
IB(1) = 1
RETURN
!
!                    TRANSPOSE A ZERO MATRIX A
!
40 NP1 = N + 1
DO J = 1,NP1
   IB(J) = 1
END DO
RETURN
END SUBROUTINE CPOSE

SUBROUTINE CPOSE1 (P, A, IA, JA, B, IB, JB, M, N)
!-----------------------------------------------------------------------
!               TRANSPOSING A SPARSE COMPLEX MATRIX
!                 WHERE THE ROWS ARE INTERCHANGED
!-----------------------------------------------------------------------
INTEGER P(M)
COMPLEX A(*), B(*)
INTEGER IA(*), JA(*), IB(*), JB(*)
!
!           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
!                 OF A AND STORE THE RESULTS IN IB
!
IPMIN = IA(1)
IPMAX = IA(M+1) - 1
IF (IPMIN .GT. IPMAX) GO TO 40
DO J = 1,N
   IB(J) = 0
END DO
DO IP = IPMIN,IPMAX
   J = JA(IP)
   IB(J) = IB(J) + 1
END DO
!
!          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
!                AND STORE THEM IN IB(2),...,IB(N+1)
!
NUM = IA(M+1) - IA(1) + 1
J = N
DO JJ = 1,N
   NUM = NUM - IB(J)
   IB(J+1) = NUM
   J = J - 1
END DO
!
!                STORE THE I-TH ROW OF A IN B AND JB
!                  AND UPDATE THE POINTERS IN IB
!
do 31 I = 1,M
   II = P(I)
   IPMIN = IA(II)
   IPMAX = IA(II+1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 31
   DO IP = IPMIN,IPMAX
      J = JA(IP)
      JP = IB(J+1)
      JB(JP) = I
      B(JP) = A(IP)
      IB(J+1) = JP + 1
   END DO
31 CONTINUE
IB(1) = 1
RETURN
!
!                    TRANSPOSE A ZERO MATRIX A
!
40 NP1 = N + 1
DO J = 1,NP1
   IB(J) = 1
END DO
RETURN
END SUBROUTINE CPOSE1

SUBROUTINE SADD (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!               ADDITION OF SPARSE REAL MATRICES
!-----------------------------------------------------------------------
REAL A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO J = 1,N
   WK(J) = 0.0
END DO
!
!                  COMPUTE THE I-TH ROW OF C
!
IP = 1
do 42 I = 1,M
   IC(I) = IP
   MINA = IA(I)
   MAXA = IA(I+1) - 1
   IF (MINA .GT. MAXA) GO TO 30
   DO L = MINA,MAXA
      J = JA(L)
      WK(J) = A(L)
   END DO
!
30 MINB = IB(I)
   MAXB = IB(I+1) - 1
   IF (MINB .GT. MAXB) GO TO 40
   do 31 L = MINB,MAXB
      J = JB(L)
      T = WK(J) + B(L)
      WK(J) = 0.0
      IF (T .EQ. 0.0) GO TO 31
      IF (IP .GT. NUM) GO TO 50
      C(IP) = T
      JC(IP) = J
      IP = IP + 1
31 CONTINUE
!
40 IF (MINA .GT. MAXA) GO TO 42
   do 41 L = MINA,MAXA
      J = JA(L)
      IF (WK(J) .EQ. 0.0) GO TO 41
      IF (IP .GT. NUM) GO TO 50
      C(IP) = WK(J)
      WK(J) = 0.0
      JC(IP) = J
      IP = IP + 1
41 CONTINUE
42 CONTINUE
IC(M + 1) = IP
IERR = 0
RETURN
!
!                        ERROR RETURN
!
50 IERR = I
RETURN
END SUBROUTINE SADD

SUBROUTINE DSADD (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!         ADDITION OF SPARSE DOUBLE PRECISION MATRICES
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO J = 1,N
   WK(J) = 0.D0
END DO
!
!                  COMPUTE THE I-TH ROW OF C
!
IP = 1
do 42 I = 1,M
   IC(I) = IP
   MINA = IA(I)
   MAXA = IA(I+1) - 1
   IF (MINA .GT. MAXA) GO TO 30
   DO L = MINA,MAXA
      J = JA(L)
      WK(J) = A(L)
   END DO
!
30 MINB = IB(I)
   MAXB = IB(I+1) - 1
   IF (MINB .GT. MAXB) GO TO 40
   do 31 L = MINB,MAXB
      J = JB(L)
      T = WK(J) + B(L)
      WK(J) = 0.D0
      IF (T .EQ. 0.D0) GO TO 31
      IF (IP .GT. NUM) GO TO 50
      C(IP) = T
      JC(IP) = J
      IP = IP + 1
31 CONTINUE
!
40 IF (MINA .GT. MAXA) GO TO 42
   do 41 L = MINA,MAXA
      J = JA(L)
      IF (WK(J) .EQ. 0.D0) GO TO 41
      IF (IP .GT. NUM) GO TO 50
      C(IP) = WK(J)
      WK(J) = 0.D0
      JC(IP) = J
      IP = IP + 1
41 CONTINUE
42 CONTINUE
IC(M + 1) = IP
IERR = 0
RETURN
!
!                        ERROR RETURN
!
50 IERR = I
RETURN
END SUBROUTINE DSADD

SUBROUTINE CSADD (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!              ADDITION OF SPARSE COMPLEX MATRICES
!-----------------------------------------------------------------------
COMPLEX A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO J = 1,N
   WK(J) = (0.0, 0.0)
END DO
!
!                  COMPUTE THE I-TH ROW OF C
!
IP = 1
do 42 I = 1,M
   IC(I) = IP
   MINA = IA(I)
   MAXA = IA(I+1) - 1
   IF (MINA .GT. MAXA) GO TO 30
   DO L = MINA,MAXA
      J = JA(L)
      WK(J) = A(L)
   END DO
!
30 MINB = IB(I)
   MAXB = IB(I+1) - 1
   IF (MINB .GT. MAXB) GO TO 40
   do 31 L = MINB,MAXB
      J = JB(L)
      T = WK(J) + B(L)
      WK(J) = (0.0, 0.0)
      IF (T .EQ. (0.0, 0.0)) GO TO 31
      IF (IP .GT. NUM) GO TO 50
      C(IP) = T
      JC(IP) = J
      IP = IP + 1
31 CONTINUE
!
40 IF (MINA .GT. MAXA) GO TO 42
   do 41 L = MINA,MAXA
      J = JA(L)
      IF (WK(J) .EQ. (0.0, 0.0)) GO TO 41
      IF (IP .GT. NUM) GO TO 50
      C(IP) = WK(J)
      WK(J) = (0.0, 0.0)
      JC(IP) = J
      IP = IP + 1
41 CONTINUE
42 CONTINUE
IC(M + 1) = IP
IERR = 0
RETURN
!
!                        ERROR RETURN
!
50 IERR = I
RETURN
END SUBROUTINE CSADD

SUBROUTINE SSUBT (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!             SUBTRACTION OF SPARSE REAL MATRICES
!-----------------------------------------------------------------------
REAL A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO J = 1,N
   WK(J) = 0.0
END DO
!
!                  COMPUTE THE I-TH ROW OF C
!
IP = 1
do 42 I = 1,M
   IC(I) = IP
   MINA = IA(I)
   MAXA = IA(I+1) - 1
   IF (MINA .GT. MAXA) GO TO 30
   DO L = MINA,MAXA
      J = JA(L)
      WK(J) = A(L)
   END DO
!
30 MINB = IB(I)
   MAXB = IB(I+1) - 1
   IF (MINB .GT. MAXB) GO TO 40
   do 31 L = MINB,MAXB
      J = JB(L)
      T = WK(J) - B(L)
      WK(J) = 0.0
      IF (T .EQ. 0.0) GO TO 31
      IF (IP .GT. NUM) GO TO 50
      C(IP) = T
      JC(IP) = J
      IP = IP + 1
31 CONTINUE
!
40 IF (MINA .GT. MAXA) GO TO 42
   do 41 L = MINA,MAXA
      J = JA(L)
      IF (WK(J) .EQ. 0.0) GO TO 41
      IF (IP .GT. NUM) GO TO 50
      C(IP) = WK(J)
      WK(J) = 0.0
      JC(IP) = J
      IP = IP + 1
41 CONTINUE
42 CONTINUE
IC(M + 1) = IP
IERR = 0
RETURN
!
!                        ERROR RETURN
!
50 IERR = I
RETURN
END SUBROUTINE SSUBT

SUBROUTINE DSSUBT (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!        SUBTRACTION OF SPARSE DOUBLE PRECISION MATRICES
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO J = 1,N
   WK(J) = 0.D0
END DO
!
!                  COMPUTE THE I-TH ROW OF C
!
IP = 1
do 42 I = 1,M
   IC(I) = IP
   MINA = IA(I)
   MAXA = IA(I+1) - 1
   IF (MINA .GT. MAXA) GO TO 30
   DO L = MINA,MAXA
      J = JA(L)
      WK(J) = A(L)
   END DO
!
30 MINB = IB(I)
   MAXB = IB(I+1) - 1
   IF (MINB .GT. MAXB) GO TO 40
   do 31 L = MINB,MAXB
      J = JB(L)
      T = WK(J) - B(L)
      WK(J) = 0.D0
      IF (T .EQ. 0.D0) GO TO 31
      IF (IP .GT. NUM) GO TO 50
      C(IP) = T
      JC(IP) = J
      IP = IP + 1
31 CONTINUE
!
40 IF (MINA .GT. MAXA) GO TO 42
   do 41 L = MINA,MAXA
      J = JA(L)
      IF (WK(J) .EQ. 0.D0) GO TO 41
      IF (IP .GT. NUM) GO TO 50
      C(IP) = WK(J)
      WK(J) = 0.D0
      JC(IP) = J
      IP = IP + 1
41 CONTINUE
42 CONTINUE
IC(M + 1) = IP
IERR = 0
RETURN
!
!                        ERROR RETURN
!
50 IERR = I
RETURN
END SUBROUTINE DSSUBT

SUBROUTINE CSSUBT (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!            SUBTRACTION OF SPARSE COMPLEX MATRICES
!-----------------------------------------------------------------------
COMPLEX A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO J = 1,N
   WK(J) = (0.0, 0.0)
END DO
!
!                  COMPUTE THE I-TH ROW OF C
!
IP = 1
do 42 I = 1,M
   IC(I) = IP
   MINA = IA(I)
   MAXA = IA(I+1) - 1
   IF (MINA .GT. MAXA) GO TO 30
   DO L = MINA,MAXA
      J = JA(L)
      WK(J) = A(L)
   END DO
!
30 MINB = IB(I)
   MAXB = IB(I+1) - 1
   IF (MINB .GT. MAXB) GO TO 40
   do 31 L = MINB,MAXB
      J = JB(L)
      T = WK(J) - B(L)
      WK(J) = (0.0, 0.0)
      IF (T .EQ. (0.0, 0.0)) GO TO 31
      IF (IP .GT. NUM) GO TO 50
      C(IP) = T
      JC(IP) = J
      IP = IP + 1
31 CONTINUE
!
40 IF (MINA .GT. MAXA) GO TO 42
   do 41 L = MINA,MAXA
      J = JA(L)
      IF (WK(J) .EQ. (0.0, 0.0)) GO TO 41
      IF (IP .GT. NUM) GO TO 50
      C(IP) = WK(J)
      WK(J) = (0.0, 0.0)
      JC(IP) = J
      IP = IP + 1
41 CONTINUE
42 CONTINUE
IC(M + 1) = IP
IERR = 0
RETURN
!
!                        ERROR RETURN
!
50 IERR = I
RETURN
END SUBROUTINE CSSUBT

SUBROUTINE SPROD (A,IA,JA,B,IB,JB,C,IC,JC,L,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!               MULTIPLICATION OF SPARSE REAL MATRICES
!-----------------------------------------------------------------------
REAL A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO K = 1,N
   WK(K) = 0.0
END DO
!
!                     COMPUTE THE I-TH ROW OF C
!
IP = 1
do 31 I = 1,L
   IC(I) = IP
   JPMIN = IA(I)
   JPMAX = IA(I+1) - 1
   IF (JPMIN .GT. JPMAX) GO TO 31
!
   do 21 JP = JPMIN,JPMAX
      T = A(JP)
      IF (T .EQ. 0.0) GO TO 21
      J = JA(JP)
      KPMIN = IB(J)
      KPMAX = IB(J+1) - 1
      IF (KPMIN .GT. KPMAX) GO TO 21
      DO KP = KPMIN,KPMAX
         K = JB(KP)
         WK(K) = WK(K) + T*B(KP)
      END DO
21 CONTINUE
!
   do 30 K = 1,N
      IF (WK(K) .EQ. 0.0) GO TO 30
      IF (IP .GT. NUM) GO TO 40
      C(IP) = WK(K)
      WK(K) = 0.0
      JC(IP) = K
      IP = IP + 1
30 CONTINUE
31 CONTINUE
IC(L + 1) = IP
IERR = 0
RETURN
!
!                           ERROR RETURN
!
40 IERR = I
RETURN
END SUBROUTINE SPROD

SUBROUTINE DSPROD (A,IA,JA,B,IB,JB,C,IC,JC,L,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!         MULTIPLICATION OF SPARSE DOUBLE PRECISION MATRICES
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO K = 1,N
   WK(K) = 0.D0
END DO
!
!                     COMPUTE THE I-TH ROW OF C
!
IP = 1
do 31 I = 1,L
   IC(I) = IP
   JPMIN = IA(I)
   JPMAX = IA(I+1) - 1
   IF (JPMIN .GT. JPMAX) GO TO 31
!
   do 21 JP = JPMIN,JPMAX
      T = A(JP)
      IF (T .EQ. 0.D0) GO TO 21
      J = JA(JP)
      KPMIN = IB(J)
      KPMAX = IB(J+1) - 1
      IF (KPMIN .GT. KPMAX) GO TO 21
      DO KP = KPMIN,KPMAX
         K = JB(KP)
         WK(K) = WK(K) + T*B(KP)
      END DO
21 CONTINUE
!
   do 30 K = 1,N
      IF (WK(K) .EQ. 0.D0) GO TO 30
      IF (IP .GT. NUM) GO TO 40
      C(IP) = WK(K)
      WK(K) = 0.D0
      JC(IP) = K
      IP = IP + 1
30 CONTINUE
31 CONTINUE
IC(L + 1) = IP
IERR = 0
RETURN
!
!                           ERROR RETURN
!
40 IERR = I
RETURN
END SUBROUTINE DSPROD

SUBROUTINE CSPROD (A,IA,JA,B,IB,JB,C,IC,JC,L,M,N,NUM,WK,IERR)
!-----------------------------------------------------------------------
!             MULTIPLICATION OF SPARSE COMPLEX MATRICES
!-----------------------------------------------------------------------
COMPLEX A(*), B(*), C(*), WK(N), T
INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
!-------------------------
DO K = 1,N
   WK(K) = (0.0, 0.0)
END DO
!
!                     COMPUTE THE I-TH ROW OF C
!
IP = 1
do 31 I = 1,L
   IC(I) = IP
   JPMIN = IA(I)
   JPMAX = IA(I+1) - 1
   IF (JPMIN .GT. JPMAX) GO TO 31
!
   do 21 JP = JPMIN,JPMAX
      T = A(JP)
      IF (T .EQ. (0.0, 0.0)) GO TO 21
      J = JA(JP)
      KPMIN = IB(J)
      KPMAX = IB(J+1) - 1
      IF (KPMIN .GT. KPMAX) GO TO 21
      DO KP = KPMIN,KPMAX
         K = JB(KP)
         WK(K) = WK(K) + T*B(KP)
      END DO
21 CONTINUE
!
   do 30 K = 1,N
      IF (WK(K) .EQ. (0.0, 0.0)) GO TO 30
      IF (IP .GT. NUM) GO TO 40
      C(IP) = WK(K)
      WK(K) = (0.0, 0.0)
      JC(IP) = K
      IP = IP + 1
30 CONTINUE
31 CONTINUE
IC(L + 1) = IP
IERR = 0
RETURN
!
!                           ERROR RETURN
!
40 IERR = I
RETURN
END SUBROUTINE CSPROD

SUBROUTINE MVPRD (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!              PRODUCT OF A SPARSE MATRIX AND A VECTOR
!-----------------------------------------------------------------------
REAL A(*), X(N), Y(M), SUM
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   SUM = 0.0
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      SUM = SUM + A(L)*X(J)
   END DO
11 Y(I) = SUM
RETURN
END SUBROUTINE MVPRD

SUBROUTINE MVPRD1 (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
!-----------------------------------------------------------------------
REAL A(*), X(N), Y(M), SUM
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   SUM = Y(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      SUM = SUM + A(L)*X(J)
   END DO
11 Y(I) = SUM
RETURN
END SUBROUTINE MVPRD1

SUBROUTINE MTPRD (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!              PRODUCT OF A VECTOR AND A SPARSE MATRIX
!-----------------------------------------------------------------------
REAL A(*), X(M), Y(N), T
INTEGER IA(*), JA(*)
!
DO J = 1,N
   Y(J) = 0.0
END DO
!
do 21 I = 1,M
   T = X(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 21
   DO L = LMIN,LMAX
      J = JA(L)
      Y(J) = Y(J) + T*A(L)
   END DO
21 CONTINUE
RETURN
END SUBROUTINE MTPRD

SUBROUTINE MTPRD1 (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
!-----------------------------------------------------------------------
REAL A(*), X(M), Y(N), T
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   T = X(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      Y(J) = Y(J) + T*A(L)
   END DO
11 CONTINUE
RETURN
END SUBROUTINE MTPRD1

SUBROUTINE DVPRD (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!              PRODUCT OF A SPARSE MATRIX AND A VECTOR
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), X(N), Y(M), SUM
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   SUM = 0.D0
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      SUM = SUM + A(L)*X(J)
   END DO
11 Y(I) = SUM
RETURN
END SUBROUTINE DVPRD

SUBROUTINE DVPRD1 (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), X(N), Y(M), SUM
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   SUM = Y(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      SUM = SUM + A(L)*X(J)
   END DO
11 Y(I) = SUM
RETURN
END SUBROUTINE DVPRD1

SUBROUTINE DTPRD (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!              PRODUCT OF A VECTOR AND A SPARSE MATRIX
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), X(M), Y(N), T
INTEGER IA(*), JA(*)
!
DO J = 1,N
   Y(J) = 0.D0
END DO
!
do 21 I = 1,M
   T = X(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 21
   DO L = LMIN,LMAX
      J = JA(L)
      Y(J) = Y(J) + T*A(L)
   END DO
21 CONTINUE
RETURN
END SUBROUTINE DTPRD

SUBROUTINE DTPRD1 (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
!-----------------------------------------------------------------------
DOUBLE PRECISION A(*), X(M), Y(N), T
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   T = X(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      Y(J) = Y(J) + T*A(L)
   END DO
11 CONTINUE
RETURN
END SUBROUTINE DTPRD1

SUBROUTINE CVPRD (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!              PRODUCT OF A SPARSE MATRIX AND A VECTOR
!-----------------------------------------------------------------------
COMPLEX A(*), X(N), Y(M), SUM
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   SUM = (0.0, 0.0)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      SUM = SUM + A(L)*X(J)
   END DO
11 Y(I) = SUM
RETURN
END SUBROUTINE CVPRD

SUBROUTINE CVPRD1 (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
!-----------------------------------------------------------------------
COMPLEX A(*), X(N), Y(M), SUM
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   SUM = Y(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      SUM = SUM + A(L)*X(J)
   END DO
11 Y(I) = SUM
RETURN
END SUBROUTINE CVPRD1

SUBROUTINE CTPRD (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!              PRODUCT OF A VECTOR AND A SPARSE MATRIX
!-----------------------------------------------------------------------
COMPLEX A(*), X(M), Y(N), T
INTEGER IA(*), JA(*)
!
DO J = 1,N
   Y(J) = (0.0, 0.0)
END DO
!
do 21 I = 1,M
   T = X(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 21
   DO L = LMIN,LMAX
      J = JA(L)
      Y(J) = Y(J) + T*A(L)
   END DO
21 CONTINUE
RETURN
END SUBROUTINE CTPRD

SUBROUTINE CTPRD1 (M, N, A, IA, JA, X, Y)
!-----------------------------------------------------------------------
!     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
!-----------------------------------------------------------------------
COMPLEX A(*), X(M), Y(N), T
INTEGER IA(*), JA(*)
!
do 11 I = 1,M
   T = X(I)
   LMIN = IA(I)
   LMAX = IA(I+1) - 1
   IF (LMIN .GT. LMAX) GO TO 11
   DO L = LMIN,LMAX
      J = JA(L)
      Y(J) = Y(J) + T*A(L)
   END DO
11 CONTINUE
RETURN
END SUBROUTINE CTPRD1

REAL function SNRM (A, IA, JA, M, N)
!-----------------------------------------------------------------------
!             COMPUTATION OF THE L-INFINITY NORM OF A
!                      REAL SPARSE MATRIX A
!-----------------------------------------------------------------------
REAL A(*)
INTEGER IA(*), JA(*)
!
SNRM = 0.0
do 20 I = 1,M
   IPMIN = IA(I)
   IPMAX = IA(I + 1) - 1
   IF (IPMIN .GT. IPMAX) GO TO 20
   SUM = 0.0
   DO IP = IPMIN,IPMAX
      SUM = SUM + ABS(A(IP))
   END DO
   SNRM = AMAX1(SNRM, SUM)
20 CONTINUE
RETURN
END FUNCTION SNRM

SUBROUTINE S1NRM (A, IA, JA, M, N, ANORM, WK)
!-----------------------------------------------------------------------
!        COMPUTATION OF THE L1 NORM OF A REAL SPARSE MATRIX A
!-----------------------------------------------------------------------
REAL A(*), WK(N)
INTEGER IA(*), JA(*)
!
ANORM = 0.0
IPMIN = IA(1)
IPMAX = IA(M + 1) - 1
IF (IPMIN .GT. IPMAX) RETURN
!
!     COMPUTE THE L1 NORM OF A
!
DO J = 1,N
   WK(J) = 0.0
END DO
!
DO IP = IPMIN,IPMAX
   J = JA(IP)
   WK(J) = WK(J) + ABS(A(IP))
END DO
!
DO J = 1,N
   ANORM = AMAX1(ANORM,WK(J))
END DO
RETURN
END SUBROUTINE S1NRM

