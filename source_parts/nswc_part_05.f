      FUNCTION DET(A,KA,N,X)
C     -------------------
C     EVALUATION OF THE DETERMINANT OF A-XI WHERE A IS AN NXN MATRIX,
C     X IS A SCALAR, AND I IS THE NXN IDENTITY MATRIX.
C     -------------------
C     KA IS THE ROW DIMENSION OF A IN THE CALLING PROGRAM. IT IS
C     ASSUMED THAT KA IS GREATER THAN OR EQUAL TO N.
C     -------------------
      DIMENSION A(KA,N)
      IF (N .GE. 2) GO TO 10
      DET = A(1,1)-X
      RETURN
C
C              REPLACE A WITH A-XI
C
   10 IF (X .EQ. 0.0) GO TO 20
      DO 11 K=1,N
   11 A(K,K) = A(K,K)-X
C
C                INITIALIZATION
C
   20 DET = 1.0
      NM1 = N-1
      DO 52 K=1,NM1
      KP1 = K+1
C
C       SEARCH FOR THE K-TH PIVOT ELEMENT
C
      S = ABS(A(K,K))
      L = K
      DO 30 I=KP1,N
      C = ABS(A(I,K))
      IF (S .GE. C) GO TO 30
      S = C
      L = I
   30 CONTINUE
      PIVOT = A(L,K)
C
C         UPDATE THE CALCULATION OF DET
C
      DET = DET*PIVOT
      IF (DET .EQ. 0.0) RETURN
      IF (K .EQ. L) GO TO 50
      DET = -DET
C
C          INTERCHANGING ROWS K AND L
C
      DO 40 J=K,N
      C = A(K,J)
      A(K,J) = A(L,J)
   40 A(L,J) = C
C
C        REDUCTION OF THE NON-PIVOT ROWS
C
   50 DO 51 I=KP1,N
      C = A(I,K)/PIVOT
      DO 51 J=KP1,N
   51 A(I,J) = A(I,J)-C*A(K,J)
   52 CONTINUE
C
C         FINAL DETERMINANT CALCULATION
C
      DET = DET*A(N,N)
      RETURN
      END
      DOUBLE PRECISION FUNCTION DPDET(A,KA,N,X)
C     -------------------
C     EVALUATION OF THE DETERMINANT OF A-XI WHERE A IS AN NXN MATRIX,
C     X IS A SCALAR, AND I IS THE NXN IDENTITY MATRIX.
C     -------------------
C     KA IS THE ROW DIMENSION OF A IN THE CALLING PROGRAM. IT IS
C     ASSUMED THAT KA IS GREATER THAN OR EQUAL TO N.
C     -------------------
      DOUBLE PRECISION A(KA,N),X
      DOUBLE PRECISION PIVOT,S,C
      IF (N .GE. 2) GO TO 10
      DPDET = A(1,1) - X
      RETURN
C
C              REPLACE A WITH A-XI
C
   10 IF (X .EQ. 0.D0) GO TO 20
      DO 11 K=1,N
   11 A(K,K) = A(K,K) - X
C
C                INITIALIZATION
C
   20 DPDET = 1.D0
      NM1 = N - 1
      DO 52 K=1,NM1
      KP1 = K + 1
C
C       SEARCH FOR THE K-TH PIVOT ELEMENT
C
      S = DABS(A(K,K))
      L = K
      DO 30 I=KP1,N
      C = DABS(A(I,K))
      IF (S .GE. C) GO TO 30
      S = C
      L = I
   30 CONTINUE
      PIVOT = A(L,K)
C
C         UPDATE THE CALCULATION OF DET
C
      DPDET = DPDET*PIVOT
      IF (DPDET .EQ. 0.D0) RETURN
      IF (K .EQ. L) GO TO 50
      DPDET = -DPDET
C
C          INTERCHANGING ROWS K AND L
C
      DO 40 J=K,N
      C = A(K,J)
      A(K,J) = A(L,J)
   40 A(L,J) = C
C
C        REDUCTION OF THE NON-PIVOT ROWS
C
   50 DO 51 I=KP1,N
      C = A(I,K)/PIVOT
      DO 51 J=KP1,N
   51 A(I,J) = A(I,J) - C*A(K,J)
   52 CONTINUE
C
C         FINAL DETERMINANT CALCULATION
C
      DPDET = DPDET*A(N,N)
      RETURN
      END
      COMPLEX FUNCTION CDET(A,KA,N,X)
C     -------------------
C     EVALUATION OF THE DETERMINANT OF A-XI WHERE A IS AN NXN MATRIX,
C     X IS A SCALAR, AND I IS THE NXN IDENTITY MATRIX.
C     -------------------
C     KA IS THE ROW DIMENSION OF A IN THE CALLING PROGRAM. IT IS
C     ASSUMED THAT KA IS GREATER THAN OR EQUAL TO N.
C     -------------------
      COMPLEX A(KA,N),X
      COMPLEX PIVOT,T,ZERO
      REAL S,C
      DATA ZERO/(0.0,0.0)/
C
      IF (N .GE. 2) GO TO 10
      CDET = A(1,1)-X
      RETURN
C
C              REPLACE A WITH A-XI
C
   10 IF (X .EQ. ZERO) GO TO 20
      DO 11 K=1,N
   11 A(K,K) = A(K,K)-X
C
C                INITIALIZATION
C
   20 CDET = (1.0,0.0)
      NM1 = N-1
      DO 52 K=1,NM1
      KP1 = K+1
C
C       SEARCH FOR THE K-TH PIVOT ELEMENT
C
      S = ABS(REAL(A(K,K))) + ABS(AIMAG(A(K,K)))
      L = K
      DO 30 I=KP1,N
      C = ABS(REAL(A(I,K))) + ABS(AIMAG(A(I,K)))
      IF (S .GE. C) GO TO 30
      S = C
      L = I
   30 CONTINUE
      PIVOT = A(L,K)
C
C         UPDATE THE CALCULATION OF CDET
C
      CDET = CDET*PIVOT
      IF (CDET .EQ. ZERO) RETURN
      IF (K .EQ. L) GO TO 50
      CDET = -CDET
C
C          INTERCHANGING ROWS K AND L
C
      DO 40 J=K,N
      T = A(K,J)
      A(K,J) = A(L,J)
   40 A(L,J) = T
C
C        REDUCTION OF THE NON-PIVOT ROWS
C
   50 DO 51 I=KP1,N
      T = A(I,K)/PIVOT
      DO 51 J=KP1,N
   51 A(I,J) = A(I,J)-T*A(K,J)
   52 CONTINUE
C
C         FINAL DETERMINANT CALCULATION
C
      CDET = CDET*A(N,N)
      RETURN
      END
      SUBROUTINE ABSLV (MO,M,N,A,NA,B,NB,C,NC,WK,IERR)
      REAL A(NA,M), B(NB,N), C(NC,N), WK(*)
C ----------------------------------------------------------------------
C     ABSLV SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
C     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
C     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
C ----------------------------------------------------------------------
C        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
C     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
C     WE HAVE THE FOLLOWING SETUP.
C
C        A(NA,M)
C           A IS A MATRIX OF ORDER M. IT IS ASSUMED THAT
C           NA .GE. M .GE. 1.
C
C        B(NB,N)
C           B IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
C           NB .GE. N .GE. 1.
C
C        C(NC,N)
C           C IS A MATRIX HAVING M ROWS AND N COLUMNS.
C           IT IS ASSUMED THAT NC .GE. M.
C
C        WK(---)
C           WK IS AN ARRAY OF DIMENSION M**2  + N**2 + 2K
C           WHERE K = MAX(M,N). WK IS A GENERAL STORAGE
C           AREA FOR THE ROUTINE.
C
C     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
C     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
C
C        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
C        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A AND B.
C                   THE PROBLEM CANNOT BE SOLVED.
C        IERR = -1  A COULD NOT BE REDUCED TO LOWER SCHUR FORM.
C                   THE PROBLEM CANNOT BE SOLVED.
C        IERR = -2  B COULD NOT BE REDUCED TO UPPER SCHUR FORM.
C                   THE PROBLEM CANNOT BE SOLVED.
C
C     WHEN IERR = 0, A CONTAINS THE LOWER SCHUR FORM OF THE MATRIX A,
C     B CONTAINS THE UPPER SCHUR FORM OF THE MATRIX B, AND WK CONTAINS
C     THE ORTHONAL MATRICES INVOLVED IN THE SCHUR DECOMPOSITIONS OF
C     A AND B. THIS INFORMATION CAN BE REUSED TO SOLVE A NEW SET OF
C     EQUATIONS AX + XB = C WITHOUT HAVING TO REDECOMPOSE A AND B.
C     THE FOLLOWING OPTIONS ARE AVAILABLE...
C
C        MO = 1      NEW MATRICES A AND C ARE GIVEN. THE DATA FOR B
C                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
C
C        MO = 2      NEW MATRICES B AND C ARE GIVEN. THE DATA FOR A
C                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
C
C     MO .NE. 0,1,2  A NEW MATRIX C IS GIVEN. THE DATA FOR A AND B
C                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
C
C     WHEN ABSLV IS RECALLED, IT IS ASSUMED THAT M, N, AND WK HAVE
C     NOT BEEN MODIFIED.
C ----------------------------------------------------------------------
C     THIS SUBROUTINE IS A MODIFICATION BY
C        ALFRED H. MORRIS, JR.
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C     OF THE SUBROUTINE AXPXB WRITTEN BY
C        R.H. BARTELS AND G.W.STEWART
C        UNIVERSITY OF TEXAS AT AUSTIN.
C
C     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
C        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
C        15 (1972), PP. 820-826.
C ----------------------------------------------------------------------
      IU = 1
      IV = M*M + 1
      IW = N*N + IV
      CALL ABSLV1 (MO,M,N,A,NA,WK(IU),M,B,NB,WK(IV),N,
     *                C,NC,WK(IW),IERR)
      RETURN
      END
      SUBROUTINE ABSLV1 (MO,M,N,A,NA,U,NU,B,NB,V,NV,C,NC,WK,IERR)
C ----------------------------------------------------------------------
C     ABSLV1 SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
C     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
C     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
C ----------------------------------------------------------------------
      REAL A(NA,M), B(NB,N), C(NC,N)
      REAL U(NU,M), V(NV,N), TEMP, WK(*)
C
C     IF REQUIRED, REDUCE A TO LOWER REAL SCHUR FORM
C
      IF (MO .NE. 0 .AND. MO .NE. 1) GO TO 35
      DO 11 I = 1,M
         DO 10 J = I,M
            TEMP = A(I,J)
            A(I,J) = A(J,I)
            A(J,I) = TEMP
   10    CONTINUE
   11 CONTINUE
      CALL ORTHES (NA,M,1,M,A,WK)
      CALL ORTRN1 (M,1,M,A,NA,U,NU,WK)
C
      IF (M .EQ. 1) GO TO 20
      CALL SCHUR (M,1,M,A,NA,U,NU,WK(1),WK(M+1),IERR)
      IF (IERR .NE. 0) GO TO 200
C
   20 DO 31 I = 1,M
         DO 30 J = I,M
            TEMP = A(I,J)
            A(I,J) = A(J,I)
            A(J,I) = TEMP
   30    CONTINUE
   31 CONTINUE
C
C     IF REQUIRED, REDUCE B TO UPPER REAL SCHUR FORM
C
   35 IF (MO .NE. 0 .AND. MO .NE. 2) GO TO 45
      CALL ORTHES (NB,N,1,N,B,WK)
      CALL ORTRN1 (N,1,N,B,NB,V,NV,WK)
C
      IF (N .EQ. 1) GO TO 45
      CALL SCHUR (N,1,N,B,NB,V,NV,WK(1),WK(N+1),IERR)
      IF (IERR .NE. 0) GO TO 210
C
C     TRANSFORM C
C
   45 DO 61 J = 1,N
         DO 51 I = 1,M
            WK(I) = 0.0
            DO 50 K = 1,M
               WK(I) = WK(I) + U(K,I)*C(K,J)
   50       CONTINUE
   51    CONTINUE
         DO 60 I = 1,M
            C(I,J) = WK(I)
   60    CONTINUE
   61 CONTINUE
C
      DO 81 I = 1,M
         DO 71 J = 1,N
            WK(J) = 0.0
            DO 70 K = 1,N
               WK(J) = WK(J) + C(I,K)*V(K,J)
   70       CONTINUE
   71    CONTINUE
         DO 80 J = 1,N
            C(I,J) = WK(J)
   80    CONTINUE
   81 CONTINUE
C
C     SOLVE THE TRANSFORMED SYSTEM
C
      CALL SHRSLV (A,B,C,M,N,NA,NB,NC,IERR)
      IF (IERR .NE. 0) GO TO 220
C
C     TRANSFORM C BACK TO THE SOLUTION
C
      DO 101 J = 1,N
         DO 91 I = 1,M
            WK(I) = 0.0
            DO 90 K = 1,M
               WK(I) = WK(I) + U(I,K)*C(K,J)
   90       CONTINUE
   91    CONTINUE
         DO 100 I = 1,M
            C(I,J) = WK(I)
  100    CONTINUE
  101 CONTINUE
C
      DO 121 I = 1,M
         DO 111 J = 1,N
            WK(J) = 0.0
            DO 110 K = 1,N
               WK(J) = WK(J) + C(I,K)*V(J,K)
  110       CONTINUE
  111    CONTINUE
         DO 120 J = 1,N
            C(I,J) = WK(J)
  120    CONTINUE
  121 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = -1
      RETURN
  210 IERR = -2
      RETURN
  220 IERR = 1
      RETURN
      END
      SUBROUTINE SCHUR (N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR)
C ----------------------------------------------------------------------
C     IT IS ASSUMED THAT H IS AN UPPER HESSENBERG MATRIX. SCHUR
C     OBTAINS AN ORTHOGONAL MATRIX Q FOR WHICH TRANSPOSE(Q)*H*Q
C     IS IN SCHUR FORM. THE EIGENVALUES OF H ARE ALSO COMPUTED.
C
C     ON INPUT-
C
C        N IS THE ORDER OF THE MATRIX,
C
C        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
C          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
C          SET LOW=1, IGH=N, (BALANC IS AN EISPACK SUBROUTINE).
C
C        H CONTAINS THE UPPER HESSENBERG MATRIX,
C
C        NH IS THE FIRST DIMENSION OF H,
C
C        Z CONTAINS A MATRIX OF ORDER N,
C
C        NZ IS THE FIRST DIMENSION OF Z.
C
C     ON OUTPUT-
C
C        H CONTAINS THE TRANSFORMED MATRIX IN UPPER SCHUR FORM,
C
C        Z CONTAINS THE MATRIX Z*Q WHERE Q IS THE ORTHOGONAL
C          MATRIX WHICH REDUCES H TO UPPER SCHUR FORM,
C
C        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
C          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
C          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
C          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
C          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
C          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
C          FOR INDICES IERR+1,...,N.
C
C        IERR IS SET TO
C          0          FOR NORMAL RETURN,
C          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
C                     DETERMINED AFTER 30 ITERATIONS.
C
C -----------------
C     WRITTEN BY JACK DONGARRA
C          ARGONNE NATIONAL LABORATORY
C          MAY 1961
C     MODIFIED BY A.H. MORRIS (NSWC)
C ----------------------------------------------------------------------
C     THIS SUBROUTINE IS A MODIFICATION OF THE EISPACK SUBROUTINE
C     HQR2,  WHICH IS BASED ON THE ALGOL PROCEDURE HQR BY PETERS
C     AND WILKINSON, NUM. MATH. 16 (1970), PP.181-204.
C ----------------------------------------------------------------------
      INTEGER I, J, K, L, M, N, EN, LL, MM, NA, NH, NZ, IGH, ITS, LOW,
     *        MP2, ENM2, IERR
      REAL H(NH,N), WR(N), WI(N), Z(NZ,N)
      REAL P, Q, R, S, T, W, X, Y, ZZ, NORM, S1, S2
      LOGICAL NOTLAS
C     REAL SQRT, ABS
C     INTEGER MIN0
C
      IERR = 0
      NORM = 0.0
      K = 1
C     ********** STORE ROOTS ISOLATED BY BALANC
C                AND COMPUTE MATRIX NORM **********
      DO 20 I = 1,N
C
        DO 10 J = K,N
          NORM = NORM + ABS(H(I,J))
   10   CONTINUE
C
        K = I
        IF (I .GE. LOW .AND. I .LE. IGH) GO TO 20
        WR(I) = H(I,I)
        WI(I) = 0.0
   20 CONTINUE
C
      EN = IGH
      T = 0.0
C     ********** SEARCH FOR NEXT EIGENVALUES **********
   30 IF (EN .LT. LOW) GO TO 300
      ITS = 0
      NA = EN - 1
      ENM2 = NA - 1
C     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
C                FOR L=EN STEP -1 UNTIL LOW DO -- **********
   40 DO 50 LL = LOW,EN
        L = EN + LOW - LL
        IF (L .EQ. LOW) GO TO 60
        S = ABS(H(L-1,L-1)) + ABS(H(L,L))
        IF (S .EQ. 0.0) S = NORM
        S1 = S
        S2 = S1 + ABS(H(L,L-1))
        IF (S1 .EQ. S2) GO TO 60
   50 CONTINUE
C     ********** FORM SHIFT **********
   60 X = H(EN,EN)
      IF (L .EQ. EN) GO TO 220
      Y = H(NA,NA)
      W = H(EN,NA)*H(NA,EN)
      IF (L .EQ .NA) GO TO 230
      IF (ITS .EQ. 30) GO TO 290
      IF (ITS .NE. 10 .AND. ITS .NE. 20) GO TO 80
C     ********** FORM EXCEPTIONAL SHIFT **********
      T = T + X
C
      DO 70 I = LOW,EN
        H(I,I) = H(I,I) - X
   70 CONTINUE
C
      S = ABS(H(EN,NA)) + ABS(H(NA,ENM2))
      X = 0.75*S
      Y = X
      W = -0.4375*S*S
   80 ITS = ITS + 1
C     ********** LOOK FOR TWO CONSECUTIVE SMALL
C                SUB-DIAGONAL ELEMENTS.
C                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
      DO 90 MM = L,ENM2
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
   90 CONTINUE
C
  100 MP2 = M + 2
C
      DO 110 I = MP2,EN
        H(I,I-2) = 0.0
        IF (I .EQ. MP2) GO TO 110
        H(I,I-3) = 0.0
  110 CONTINUE
C     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
C                COLUMNS M TO EN **********
      DO 210 K = M,NA
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
  120   S = SQRT(P*P + Q*Q + R*R)
        IF (P .LT. 0.0) S = -S
        IF (K .EQ. M) GO TO 130
        H(K,K-1) = -S*X
        GO TO 140
  130   IF (L .NE. M) H(K,K-1) = -H(K,K-1)
  140   P = P + S
        X = P/S
        Y = Q/S
        ZZ = R/S
        Q = Q/P
        R = R/P
C     ********** ROW MODIFICATION **********
        DO 160 J = K,N
          P = H(K,J) + Q*H(K+1,J)
          IF (.NOT.NOTLAS) GO TO 150
          P = P + R*H(K+2,J)
          H(K+2,J) = H(K+2,J) - P*ZZ
  150     H(K+1,J) = H(K+1,J) - P*Y
          H(K,J) = H(K,J) - P*X
  160   CONTINUE
C
        J = MIN0(EN,K+3)
C     ********** COLUMN MODIFICATION **********
        DO 180 I = 1,J
          P = X*H(I,K) + Y*H(I,K+1)
          IF (.NOT.NOTLAS) GO TO 170
          P = P + ZZ*H(I,K+2)
          H(I,K+2) = H(I,K+2) - P*R
  170     H(I,K+1) = H(I,K+1) - P*Q
          H(I,K) = H(I,K) - P
  180   CONTINUE
C     ********** ACCUMULATE TRANSFORMATIONS **********
        DO 200 I = LOW,IGH
          P = X*Z(I,K) + Y*Z(I,K+1)
          IF (.NOT.NOTLAS) GO TO 190
          P = P + ZZ*Z(I,K+2)
          Z(I,K+2) = Z(I,K+2) - P*R
  190     Z(I,K+1) = Z(I,K+1) - P*Q
          Z(I,K) = Z(I,K) - P
  200   CONTINUE
C
  210 CONTINUE
C
      GO TO 40
C     ********** ONE ROOT FOUND **********
  220 H(EN,EN) = X + T
      WR(EN) = H(EN,EN)
      WI(EN) = 0.0
      EN = NA
      GO TO 30
C     ********** TWO ROOTS FOUND **********
  230 P = (Y - X)/2.0
      Q = P*P + W
      ZZ = SQRT(ABS(Q))
      H(EN,EN) = X + T
      X = H(EN,EN)
      H(NA,NA) = Y + T
      IF (Q .LT. 0.0) GO TO 270
C     ********** REAL PAIR **********
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
C     ********** ROW MODIFICATION **********
      DO 240 J = NA,N
        ZZ = H(NA,J)
        H(NA,J) = Q*ZZ + P*H(EN,J)
        H(EN,J) = Q*H(EN,J) - P*ZZ
  240 CONTINUE
C     ********** COLUMN MODIFICATION **********
      DO 250 I = 1,EN
        ZZ = H(I,NA)
        H(I,NA) = Q*ZZ + P*H(I,EN)
        H(I,EN) = Q*H(I,EN) - P*ZZ
  250 CONTINUE
C     ********** ACCUMULATE TRANSFORMATIONS **********
      DO 260 I = LOW,IGH
        ZZ = Z(I,NA)
        Z(I,NA) = Q*ZZ + P*Z(I,EN)
        Z(I,EN) = Q*Z(I,EN) - P*ZZ
  260 CONTINUE
C
      GO TO 280
C     ********** COMPLEX PAIR **********
  270 WR(NA) = X + P
      WR(EN) = X + P
      WI(NA) = ZZ
      WI(EN) = -ZZ
  280 EN = ENM2
      GO TO 30
C     ********** SET ERROR -- NO CONVERGENCE TO AN
C                EIGENVALUE AFTER 30 ITERATIONS **********
  290 IERR = EN
      RETURN
  300 DO 320 I = 1,N
        IP1 = I + 1
        IF (ABS(WI(I)) .NE. 0.0) IP1 = IP1 + 1
        IF (IP1 .GT. N) GO TO 320
        DO 310 J = IP1,N
          H(J,I) = 0.0
  310   CONTINUE
  320 CONTINUE
      RETURN
      END
      SUBROUTINE SHRSLV (A,B,C,M,N,NA,NB,NC,IERR)
C     ------------------------------------------------------------------
C     SHRSLV SOLVES THE MATRIX EQUATION AX + XB = C WHERE
C     A IS IN LOWER SCHUR FORM AND B IN UPPER SCHUR FORM.
C     ------------------------------------------------------------------
      INTEGER M,N,NA,NB,NC,IERR
      REAL A(NA,M), B(NB,N), C(NC,N)
      REAL SUM, P(4), T(4,4)
      INTEGER DK,DL,I,IB,J,JA,K,KM1,KK,L,LM1,LL
C
      L = 1
   10    LM1 = L - 1
         DL = 1
         IF (L .EQ. N) GO TO 15
         IF (B(L+1,L) .NE. 0.0) DL = 2
   15    LL = L + DL - 1
         IF (L .EQ. 1) GO TO 30
C
         DO 22 J = L,LL
            DO 21 I = 1,M
            SUM = C(I,J)
               DO 20 IB = 1,LM1
   20          SUM = SUM - C(I,IB)*B(IB,J)
   21       C(I,J) = SUM
   22    CONTINUE
C
   30    K = 1
   40       KM1 = K - 1
            DK = 1
            IF (K .EQ. M) GO TO 45
            IF (A(K,K+1) .NE. 0.0) DK = 2
   45       KK = K + DK - 1
            IF (K .EQ. 1) GO TO 60
C
            DO 52 I = K,KK
               DO 51 J = L,LL
               SUM = C(I,J)
                  DO 50 JA = 1,KM1
   50             SUM = SUM - A(I,JA)*C(JA,J)
   51          C(I,J) = SUM
   52       CONTINUE
C
   60       IF (DL .EQ. 2) GO TO 80
            IF (DK .EQ. 2) GO TO 70
            T(1,1) = A(K,K) + B(L,L)
            IF (T(1,1) .EQ. 0.0) GO TO 200
            C(K,L) = C(K,L)/T(1,1)
            IERR = 0
            GO TO 100
C
   70       T(1,1) = A(K,K) + B(L,L)
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
C
   80       IF (DK .EQ. 2) GO TO 90
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
C
   90       T(1,1) = A(K,K) + B(L,L)
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
C
  100    K = K + DK
         IF (K .LE. M) GO TO 40
      L = L + DL
      IF (L .LE. N) GO TO 10
      RETURN
C
C     ERROR RETURN
C
  200 IERR = 1
      RETURN
      END
      SUBROUTINE DABSLV (MO,M,N,A,NA,B,NB,C,NC,WK,IERR)
      DOUBLE PRECISION A(NA,M), B(NB,N), C(NC,N), WK(*)
C ----------------------------------------------------------------------
C     DABSLV SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
C     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
C     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
C ----------------------------------------------------------------------
C        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
C     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
C     WE HAVE THE FOLLOWING SETUP.
C
C        A(NA,M)
C           A IS A MATRIX OF ORDER M. IT IS ASSUMED THAT
C           NA .GE. M .GE. 1.
C
C        B(NB,N)
C           B IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
C           NB .GE. N .GE. 1.
C
C        C(NC,N)
C           C IS A MATRIX HAVING M ROWS AND N COLUMNS.
C           IT IS ASSUMED THAT NC .GE. M.
C
C        WK(---)
C           WK IS AN ARRAY OF DIMENSION M**2  + N**2 + 2K
C           WHERE K = MAX(M,N). WK IS A GENERAL STORAGE
C           AREA FOR THE ROUTINE.
C
C     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
C     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
C
C        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
C        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A AND B.
C                   THE PROBLEM CANNOT BE SOLVED.
C        IERR = -1  A COULD NOT BE REDUCED TO LOWER SCHUR FORM.
C                   THE PROBLEM CANNOT BE SOLVED.
C        IERR = -2  B COULD NOT BE REDUCED TO UPPER SCHUR FORM.
C                   THE PROBLEM CANNOT BE SOLVED.
C
C     WHEN IERR = 0, A CONTAINS THE LOWER SCHUR FORM OF THE MATRIX A,
C     B CONTAINS THE UPPER SCHUR FORM OF THE MATRIX B, AND WK CONTAINS
C     THE ORTHONAL MATRICES INVOLVED IN THE SCHUR DECOMPOSITIONS OF
C     A AND B. THIS INFORMATION CAN BE REUSED TO SOLVE A NEW SET OF
C     EQUATIONS AX + XB = C WITHOUT HAVING TO REDECOMPOSE A AND B.
C     THE FOLLOWING OPTIONS ARE AVAILABLE...
C
C        MO = 1      NEW MATRICES A AND C ARE GIVEN. THE DATA FOR B
C                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
C
C        MO = 2      NEW MATRICES B AND C ARE GIVEN. THE DATA FOR A
C                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
C
C     MO .NE. 0,1,2  A NEW MATRIX C IS GIVEN. THE DATA FOR A AND B
C                    IS REUSED IN SOLVING THE NEW SET OF EQUATIONS.
C
C     WHEN DABSLV IS RECALLED, IT IS ASSUMED THAT M, N, AND WK HAVE
C     NOT BEEN MODIFIED.
C ----------------------------------------------------------------------
C     THIS SUBROUTINE IS A MODIFICATION BY
C        ALFRED H. MORRIS, JR.
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C     OF THE SUBROUTINE AXPXB WRITTEN BY
C        R.H. BARTELS AND G.W.STEWART
C        UNIVERSITY OF TEXAS AT AUSTIN.
C
C     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
C        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
C        15 (1972), PP. 820-826.
C ----------------------------------------------------------------------
      IU = 1
      IV = M*M + 1
      IW = N*N + IV
      CALL DABSV1 (MO,M,N,A,NA,WK(IU),M,B,NB,WK(IV),N,
     *                C,NC,WK(IW),IERR)
      RETURN
      END
      SUBROUTINE DABSV1 (MO,M,N,A,NA,U,NU,B,NB,V,NV,C,NC,WK,IERR)
C ----------------------------------------------------------------------
C     DABSV1 SOLVES THE REAL MATRIX EQUATION AX + XB = C. A IS REDUCED
C     TO LOWER SCHUR FORM, B IS REDUCED TO UPPER SCHUR FORM, AND THE
C     TRANSFORMED SYSTEM IS SOLVED BY BACK SUBSTITUTION.
C ----------------------------------------------------------------------
      DOUBLE PRECISION A(NA,M), B(NB,N), C(NC,N)
      DOUBLE PRECISION U(NU,M), V(NV,N), TEMP, WK(*)
C
C     IF REQUIRED, REDUCE A TO LOWER REAL SCHUR FORM
C
      IF (MO .NE. 0 .AND. MO .NE. 1) GO TO 35
      DO 11 I = 1,M
         DO 10 J = I,M
            TEMP = A(I,J)
            A(I,J) = A(J,I)
            A(J,I) = TEMP
   10    CONTINUE
   11 CONTINUE
      CALL DORTH (NA,M,1,M,A,WK)
      CALL DRTRN1 (M,1,M,A,NA,U,NU,WK)
C
      IF (M .EQ. 1) GO TO 20
      CALL DSCHUR (M,1,M,A,NA,U,NU,WK(1),WK(M+1),IERR)
      IF (IERR .NE. 0) GO TO 200
C
   20 DO 31 I = 1,M
         DO 30 J = I,M
            TEMP = A(I,J)
            A(I,J) = A(J,I)
            A(J,I) = TEMP
   30    CONTINUE
   31 CONTINUE
C
C     IF REQUIRED, REDUCE B TO UPPER REAL SCHUR FORM
C
   35 IF (MO .NE. 0 .AND. MO .NE. 2) GO TO 45
      CALL DORTH (NB,N,1,N,B,WK)
      CALL DRTRN1 (N,1,N,B,NB,V,NV,WK)
C
      IF (N .EQ. 1) GO TO 45
      CALL DSCHUR (N,1,N,B,NB,V,NV,WK(1),WK(N+1),IERR)
      IF (IERR .NE. 0) GO TO 210
C
C     TRANSFORM C
C
   45 DO 61 J = 1,N
         DO 51 I = 1,M
            WK(I) = 0.D0
            DO 50 K = 1,M
               WK(I) = WK(I) + U(K,I)*C(K,J)
   50       CONTINUE
   51    CONTINUE
         DO 60 I = 1,M
            C(I,J) = WK(I)
   60    CONTINUE
   61 CONTINUE
C
      DO 81 I = 1,M
         DO 71 J = 1,N
            WK(J) = 0.D0
            DO 70 K = 1,N
               WK(J) = WK(J) + C(I,K)*V(K,J)
   70       CONTINUE
   71    CONTINUE
         DO 80 J = 1,N
            C(I,J) = WK(J)
   80    CONTINUE
   81 CONTINUE
C
C     SOLVE THE TRANSFORMED SYSTEM
C
      CALL DSHSLV (A,B,C,M,N,NA,NB,NC,IERR)
      IF (IERR .NE. 0) GO TO 220
C
C     TRANSFORM C BACK TO THE SOLUTION
C
      DO 101 J = 1,N
         DO 91 I = 1,M
            WK(I) = 0.D0
            DO 90 K = 1,M
               WK(I) = WK(I) + U(I,K)*C(K,J)
   90       CONTINUE
   91    CONTINUE
         DO 100 I = 1,M
            C(I,J) = WK(I)
  100    CONTINUE
  101 CONTINUE
C
      DO 121 I = 1,M
         DO 111 J = 1,N
            WK(J) = 0.D0
            DO 110 K = 1,N
               WK(J) = WK(J) + C(I,K)*V(J,K)
  110       CONTINUE
  111    CONTINUE
         DO 120 J = 1,N
            C(I,J) = WK(J)
  120    CONTINUE
  121 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = -1
      RETURN
  210 IERR = -2
      RETURN
  220 IERR = 1
      RETURN
      END
      SUBROUTINE DSCHUR (N, LOW, IGH, H, NH, Z, NZ, WR, WI, IERR)
C ----------------------------------------------------------------------
C     IT IS ASSUMED THAT H IS AN UPPER HESSENBERG MATRIX. DSCHUR
C     OBTAINS AN ORTHOGONAL MATRIX Q FOR WHICH  TRANSPOSE(Q)*H*Q
C     IS IN SCHUR FORM. THE EIGENVALUES OF H ARE ALSO COMPUTED.
C
C     ON INPUT-
C
C        N IS THE ORDER OF THE MATRIX,
C
C        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
C          SUBROUTINE DBAL.  IF  DBAL  HAS NOT BEEN USED, SET
C          LOW = 1, IGH = N.
C
C        H CONTAINS THE UPPER HESSENBERG MATRIX,
C
C        NH IS THE FIRST DIMENSION OF H,
C
C        Z CONTAINS A MATRIX OF ORDER N,
C
C        NZ IS THE FIRST DIMENSION OF Z.
C
C     ON OUTPUT-
C
C        H CONTAINS THE TRANSFORMED MATRIX IN UPPER SCHUR FORM,
C
C        Z CONTAINS THE MATRIX Z*Q WHERE Q IS THE ORTHOGONAL
C          MATRIX WHICH REDUCES H TO UPPER SCHUR FORM,
C
C        WR AND WI CONTAIN THE REAL AND IMAGINARY PARTS,
C          RESPECTIVELY, OF THE EIGENVALUES.  THE EIGENVALUES
C          ARE UNORDERED EXCEPT THAT COMPLEX CONJUGATE PAIRS
C          OF VALUES APPEAR CONSECUTIVELY WITH THE EIGENVALUE
C          HAVING THE POSITIVE IMAGINARY PART FIRST.  IF AN
C          ERROR EXIT IS MADE, THE EIGENVALUES SHOULD BE CORRECT
C          FOR INDICES IERR+1,...,N.
C
C        IERR IS SET TO
C          0          FOR NORMAL RETURN,
C          J          IF THE J-TH EIGENVALUE HAS NOT BEEN
C                     DETERMINED AFTER 50 ITERATIONS.
C
C -----------------
C     WRITTEN BY JACK DONGARRA
C          ARGONNE NATIONAL LABORATORY
C          MAY 1961
C     MODIFIED BY A.H. MORRIS (NSWC)
C ----------------------------------------------------------------------
C     THIS SUBROUTINE IS A MODIFICATION OF THE EISPACK SUBROUTINE
C     HQR2,  WHICH IS BASED ON THE ALGOL PROCEDURE HQR BY PETERS
C     AND WILKINSON, NUM. MATH. 16 (1970), PP.181-204.
C ----------------------------------------------------------------------
      INTEGER I, J, K, L, M, N, EN, LL, MM, NA, NH, NZ, IGH, ITS, LOW,
     *        MP2, ENM2, IERR
      DOUBLE PRECISION H(NH,N), WR(N), WI(N), Z(NZ,N)
      DOUBLE PRECISION P, Q, R, S, T, W, X, Y, ZZ, NORM, S1, S2
      LOGICAL NOTLAS
C     DOUBLE PRECISION DSQRT, DABS
C     INTEGER MIN0
C
      IERR = 0
      NORM = 0.D0
      K = 1
C     ********** STORE ROOTS ISOLATED BY BALANC
C                AND COMPUTE MATRIX NORM **********
      DO 20 I = 1,N
C
        DO 10 J = K,N
          NORM = NORM + DABS(H(I,J))
   10   CONTINUE
C
        K = I
        IF (I .GE. LOW .AND. I .LE. IGH) GO TO 20
        WR(I) = H(I,I)
        WI(I) = 0.D0
   20 CONTINUE
C
      EN = IGH
      T = 0.D0
C     ********** SEARCH FOR NEXT EIGENVALUES **********
   30 IF (EN .LT. LOW) GO TO 300
      ITS = 0
      NA = EN - 1
      ENM2 = NA - 1
C     ********** LOOK FOR SINGLE SMALL SUB-DIAGONAL ELEMENT
C                FOR L=EN STEP -1 UNTIL LOW DO -- **********
   40 DO 50 LL = LOW,EN
        L = EN + LOW - LL
        IF (L .EQ. LOW) GO TO 60
        S = DABS(H(L-1,L-1)) + DABS(H(L,L))
        IF (S .EQ. 0.D0) S = NORM
        S1 = S
        S2 = S1 + DABS(H(L,L-1))
        IF (S1 .EQ. S2) GO TO 60
   50 CONTINUE
C     ********** FORM SHIFT **********
   60 X = H(EN,EN)
      IF (L .EQ. EN) GO TO 220
      Y = H(NA,NA)
      W = H(EN,NA)*H(NA,EN)
      IF (L .EQ .NA) GO TO 230
      IF (ITS .EQ. 50) GO TO 290
      IF (ITS .NE. 10 .AND. ITS .NE. 20 .AND. ITS .NE. 30) GO TO 80
C     ********** FORM EXCEPTIONAL SHIFT **********
      T = T + X
C
      DO 70 I = LOW,EN
        H(I,I) = H(I,I) - X
   70 CONTINUE
C
      S = DABS(H(EN,NA)) + DABS(H(NA,ENM2))
      X = 0.75D0*S
      Y = X
      W = -0.4375D0*S*S
   80 ITS = ITS + 1
C     ********** LOOK FOR TWO CONSECUTIVE SMALL
C                SUB-DIAGONAL ELEMENTS.
C                FOR M=EN-2 STEP -1 UNTIL L DO -- **********
      DO 90 MM = L,ENM2
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
   90 CONTINUE
C
  100 MP2 = M + 2
C
      DO 110 I = MP2,EN
        H(I,I-2) = 0.D0
        IF (I .EQ. MP2) GO TO 110
        H(I,I-3) = 0.D0
  110 CONTINUE
C     ********** DOUBLE QR STEP INVOLVING ROWS L TO EN AND
C                COLUMNS M TO EN **********
      DO 210 K = M,NA
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
  120   S = DSQRT(P*P + Q*Q + R*R)
        IF (P .LT. 0.D0) S = -S
        IF (K .EQ. M) GO TO 130
        H(K,K-1) = -S*X
        GO TO 140
  130   IF (L .NE. M) H(K,K-1) = -H(K,K-1)
  140   P = P + S
        X = P/S
        Y = Q/S
        ZZ = R/S
        Q = Q/P
        R = R/P
C     ********** ROW MODIFICATION **********
        DO 160 J = K,N
          P = H(K,J) + Q*H(K+1,J)
          IF (.NOT.NOTLAS) GO TO 150
          P = P + R*H(K+2,J)
          H(K+2,J) = H(K+2,J) - P*ZZ
  150     H(K+1,J) = H(K+1,J) - P*Y
          H(K,J) = H(K,J) - P*X
  160   CONTINUE
C
        J = MIN0(EN,K+3)
C     ********** COLUMN MODIFICATION **********
        DO 180 I = 1,J
          P = X*H(I,K) + Y*H(I,K+1)
          IF (.NOT.NOTLAS) GO TO 170
          P = P + ZZ*H(I,K+2)
          H(I,K+2) = H(I,K+2) - P*R
  170     H(I,K+1) = H(I,K+1) - P*Q
          H(I,K) = H(I,K) - P
  180   CONTINUE
C     ********** ACCUMULATE TRANSFORMATIONS **********
        DO 200 I = LOW,IGH
          P = X*Z(I,K) + Y*Z(I,K+1)
          IF (.NOT.NOTLAS) GO TO 190
          P = P + ZZ*Z(I,K+2)
          Z(I,K+2) = Z(I,K+2) - P*R
  190     Z(I,K+1) = Z(I,K+1) - P*Q
          Z(I,K) = Z(I,K) - P
  200   CONTINUE
C
  210 CONTINUE
C
      GO TO 40
C     ********** ONE ROOT FOUND **********
  220 H(EN,EN) = X + T
      WR(EN) = H(EN,EN)
      WI(EN) = 0.D0
      EN = NA
      GO TO 30
C     ********** TWO ROOTS FOUND **********
  230 P = (Y - X)/2.D0
      Q = P*P + W
      ZZ = DSQRT(DABS(Q))
      H(EN,EN) = X + T
      X = H(EN,EN)
      H(NA,NA) = Y + T
      IF (Q .LT. 0.D0) GO TO 270
C     ********** REAL PAIR **********
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
C     ********** ROW MODIFICATION **********
      DO 240 J = NA,N
        ZZ = H(NA,J)
        H(NA,J) = Q*ZZ + P*H(EN,J)
        H(EN,J) = Q*H(EN,J) - P*ZZ
  240 CONTINUE
C     ********** COLUMN MODIFICATION **********
      DO 250 I = 1,EN
        ZZ = H(I,NA)
        H(I,NA) = Q*ZZ + P*H(I,EN)
        H(I,EN) = Q*H(I,EN) - P*ZZ
  250 CONTINUE
C     ********** ACCUMULATE TRANSFORMATIONS **********
      DO 260 I = LOW,IGH
        ZZ = Z(I,NA)
        Z(I,NA) = Q*ZZ + P*Z(I,EN)
        Z(I,EN) = Q*Z(I,EN) - P*ZZ
  260 CONTINUE
C
      GO TO 280
C     ********** COMPLEX PAIR **********
  270 WR(NA) = X + P
      WR(EN) = X + P
      WI(NA) = ZZ
      WI(EN) = -ZZ
  280 EN = ENM2
      GO TO 30
C     ********** SET ERROR -- NO CONVERGENCE TO AN
C                EIGENVALUE AFTER 50 ITERATIONS **********
  290 IERR = EN
      RETURN
  300 DO 320 I = 1,N
        IP1 = I + 1
        IF (DABS(WI(I)) .NE. 0.D0) IP1 = IP1 + 1
        IF (IP1 .GT. N) GO TO 320
        DO 310 J = IP1,N
          H(J,I) = 0.D0
  310   CONTINUE
  320 CONTINUE
      RETURN
      END
      SUBROUTINE DSHSLV (A,B,C,M,N,NA,NB,NC,IERR)
C     ------------------------------------------------------------------
C     DSHSLV SOLVES THE MATRIX EQUATION AX + XB = C WHERE
C     A IS IN LOWER SCHUR FORM AND B IN UPPER SCHUR FORM.
C     ------------------------------------------------------------------
      INTEGER M,N,NA,NB,NC,IERR
      DOUBLE PRECISION A(NA,M), B(NB,N), C(NC,N)
      DOUBLE PRECISION SUM, P(4), T(4,4)
      INTEGER DK,DL,I,IB,J,JA,K,KM1,KK,L,LM1,LL
C
      L = 1
   10    LM1 = L - 1
         DL = 1
         IF (L .EQ. N) GO TO 15
         IF (B(L+1,L) .NE. 0.D0) DL = 2
   15    LL = L + DL - 1
         IF (L .EQ. 1) GO TO 30
C
         DO 22 J = L,LL
            DO 21 I = 1,M
            SUM = C(I,J)
               DO 20 IB = 1,LM1
   20          SUM = SUM - C(I,IB)*B(IB,J)
   21       C(I,J) = SUM
   22    CONTINUE
C
   30    K = 1
   40       KM1 = K - 1
            DK = 1
            IF (K .EQ. M) GO TO 45
            IF (A(K,K+1) .NE. 0.D0) DK = 2
   45       KK = K + DK - 1
            IF (K .EQ. 1) GO TO 60
C
            DO 52 I = K,KK
               DO 51 J = L,LL
               SUM = C(I,J)
                  DO 50 JA = 1,KM1
   50             SUM = SUM - A(I,JA)*C(JA,J)
   51          C(I,J) = SUM
   52       CONTINUE
C
   60       IF (DL .EQ. 2) GO TO 80
            IF (DK .EQ. 2) GO TO 70
            T(1,1) = A(K,K) + B(L,L)
            IF (T(1,1) .EQ. 0.D0) GO TO 200
            C(K,L) = C(K,L)/T(1,1)
            IERR = 0
            GO TO 100
C
   70       T(1,1) = A(K,K) + B(L,L)
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
C
   80       IF (DK .EQ. 2) GO TO 90
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
C
   90       T(1,1) = A(K,K) + B(L,L)
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
C
  100    K = K + DK
         IF (K .LE. M) GO TO 40
      L = L + DL
      IF (L .LE. N) GO TO 10
      RETURN
C
C     ERROR RETURN
C
  200 IERR = 1
      RETURN
      END
      SUBROUTINE TASLV (MO,N,A,NA,C,NC,WK,IERR)
      REAL A(NA,N), C(NC,N), WK(*)
C ----------------------------------------------------------------------
C     TASLV SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
C     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
C     AND THE TRANSFORMED SYSTEM IS SOLVED.
C ----------------------------------------------------------------------
C        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
C     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
C     WE HAVE THE FOLLOWING SETUP.
C
C        A(NA,N)
C           A IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
C           NA .GE. N .GE. 1.
C
C        C(NC,N)
C           C IS A SYMMETRIC MATRIX OF ORDER N. IT IS
C           ASSUMED THAT NC .GE. N.
C
C        WK(---)
C           WK IS AN ARRAY OF DIMENSION N**2 + 2N THAT
C           IS A GENERAL STORAGE AREA FOR THE ROUTINE.
C
C     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
C     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
C
C        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
C        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A. THE
C                   PROBLEM CANNOT BE SOLVED.
C        IERR = -1  A COULD NOT BE REDUCEDTO UPPER SCHUR FORM.
C                   THE PROBLEM CANNOT BE SOLVED.
C
C     WHEN IERR = 0, A CONTAINS THE UPPER SCHUR FORM OF THE MATRIX
C     A AND WK CONTAINS THE ORTHOGONAL MATRIX INVOLVED IN THE SCHUR
C     DECOMPOSITION OF A. THIS INFORMATION CAN BE REUSED TO SOLVE A
C     NEW SET OF EQUATIONS TRANSPOSE(A)*X + X*A = C WITHOUT HAVING
C     TO REDECOMPOSE A. IN THIS CASE, THE INPUT ARGUMENT MO MAY BE
C     SET TO ANY NONZERO VALUE. WHEN MO .NE. 0, IT IS ASSUMED THAT
C     ONLY C HAS BEEN MODIFIED. ON OUTPUT THE SOLUTION FOR THE NEW
C     SET OF EQUATIONS IS STORED IN C.
C ----------------------------------------------------------------------
C     THIS SUBROUTINE IS A MODIFICATION BY
C        ALFRED H. MORRIS, JR.
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C     OF THE SUBROUTINE ATXPXA WRITTEN BY
C        R.H. BARTELS AND G.W. STEWART
C        UNIVERSITY OF TEXAS AT AUSTIN.
C
C     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
C        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
C        15 (1972), PP. 820-826.
C ----------------------------------------------------------------------
      IW = N*N + 1
      CALL TASLV1 (MO,N,A,NA,WK(1),N,C,NC,WK(IW),IERR)
      RETURN
      END
      SUBROUTINE TASLV1 (MO,N,A,NA,U,NU,C,NC,WK,IERR)
C ----------------------------------------------------------------------
C     TASLV1 SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
C     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
C     AND THE TRANSFORMED SYSTEM IS SOLVED.
C ----------------------------------------------------------------------
      REAL A(NA,N), U(NU,N), C(NC,N), WK(*)
C
C    IF REQUIRED, REDUCE A TO UPPER REAL SCHUR FORM
C
      IF (MO .NE. 0) GO TO 10
      CALL ORTHES (NA,N,1,N,A,WK)
      CALL ORTRN1 (N,1,N,A,NA,U,NU,WK)
      CALL SCHUR (N,1,N,A,NA,U,NU,WK(1),WK(N+1),IERR)
      IF (IERR .NE. 0) GO TO 200
C
C     TRANSFORM C
C
   10 DO 20 I = 1,N
         C(I,I) = C(I,I)/2.0
   20 CONTINUE
C
      DO 41 I = 1,N
         DO 31 J = 1,N
            WK(J) = 0.0
            DO 30 K = I,N
               WK(J) = WK(J) + C(I,K)*U(K,J)
   30       CONTINUE
   31    CONTINUE
         DO 40 J = 1,N
            C(I,J) = WK(J)
   40    CONTINUE
   41 CONTINUE
C
      DO 61 J = 1,N
         DO 51 I = 1,N
            WK(I) = 0.0
            DO 50 K = 1,N
               WK(I) = WK(I) + U(K,I)*C(K,J)
   50       CONTINUE
   51    CONTINUE
         DO 60 I = 1,N
            C(I,J) = WK(I)
   60    CONTINUE
   61 CONTINUE
C
      DO 71 I = 1,N
         DO 70 J = I,N
            C(I,J) = C(I,J) + C(J,I)
            C(J,I) = C(I,J)
   70    CONTINUE
   71 CONTINUE
C
C     SOLVE THE TRANSFORMED SYSTEM
C
      CALL SYMSLV (A,C,N,NA,NC,IERR)
      IF (IERR .NE. 0) GO TO 210
C
C     TRANSFORM C BACK TO THE SOLUTION
C
      DO 80 I = 1,N
         C(I,I) = C(I,I)/2.0
   80 CONTINUE
C
      DO 101 I = 1,N
         DO 91 J = 1,N
            WK(J) = 0.0
            DO 90 K = I,N
               WK(J) = WK(J) + C(I,K)*U(J,K)
   90       CONTINUE
   91    CONTINUE
         DO 100 J = 1,N
            C(I,J) = WK(J)
  100    CONTINUE
  101 CONTINUE
C
      DO 121 J = 1,N
         DO 111 I = 1,N
            WK(I) = 0.0
            DO 110 K = 1,N
               WK(I) = WK(I) + U(I,K)*C(K,J)
  110       CONTINUE
  111    CONTINUE
         DO 120 I = 1,N
            C(I,J) = WK(I)
  120    CONTINUE
  121 CONTINUE
C
      DO 131 I = 1,N
         DO 130 J = I,N
            C(I,J) = C(I,J) + C(J,I)
            C(J,I) = C(I,J)
  130    CONTINUE
  131 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = -1
      RETURN
  210 IERR = 1
      RETURN
      END
      SUBROUTINE SYMSLV (A,C,N,NA,NC,IERR)
C ----------------------------------------------------------------------
C     SYMSLV SOLVES THE MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
C     WHERE A IS IN UPPER SCHUR FORM AND C IS SYMMETRIC.
C ----------------------------------------------------------------------
      INTEGER N,NA,NC,IERR
      REAL A(NA,N), C(NC,N), SUM, P(4), T(4,4)
      INTEGER DK,DL,I,IA,J,K,KK,KM1,L,LL,LDL
C
      L = 1
   10    DL = 1
         IF (L .EQ. N) GO TO 20
         IF (A(L+1,L) .NE. 0.0) DL = 2
   20    LL = L + DL - 1
C
         K = L
   30       KM1 = K - 1
            DK = 1
            IF (K .EQ. N) GO TO 35
            IF (A(K+1,K) .NE. 0.0) DK = 2
   35       KK = K + DK - 1
            IF (K .EQ. L) GO TO 45
C
            DO 42 I = K,KK
               DO 41 J = L,LL
               SUM = C(I,J)
                  DO 40 IA = L,KM1
   40             SUM = SUM - A(IA,I)*C(IA,J)
   41          C(I,J) = SUM
   42       CONTINUE
C
   45       IF (DL .EQ. 2) GO TO 60
            IF (DK .EQ. 2 ) GO TO 50
            T(1,1) = A(K,K) + A(L,L)
            IF (T(1,1) .EQ. 0.0) GO TO 200
            C(K,L) = C(K,L)/T(1,1)
            IERR = 0
            GO TO 90
C
   50       T(1,1) = A(K,K) + A(L,L)
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
C
   60       IF (DK .EQ. 2) GO TO 70
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
C
   70       IF (K .NE. L) GO TO 80
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
C
   80       T(1,1) = A(K,K) + A(L,L)
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
C
   90    K = K + DK
         IF (K .LE. N) GO TO 30
      LDL = L + DL
      IF (LDL .GT. N) RETURN
C
      DO 121 J = LDL,N
         DO 100 I = L,LL
            C(I,J) = C(J,I)
  100    CONTINUE
         DO 120 I = J,N
            DO 110 K = L,LL
  110       C(I,J) = C(I,J) - C(I,K)*A(K,J) - A(K,I)*C(K,J)
  120    C(J,I) = C(I,J)
  121 CONTINUE
      L = LDL
      GO TO 10
C
C     ERROR RETURN
C
  200 IERR = 1
      RETURN
      END
      SUBROUTINE DTASLV (MO,N,A,NA,C,NC,WK,IERR)
      DOUBLE PRECISION A(NA,N), C(NC,N), WK(*)
C ----------------------------------------------------------------------
C     DTASLV SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
C     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
C     AND THE TRANSFORMED SYSTEM IS SOLVED.
C ----------------------------------------------------------------------
C        MO IS AN INPUT ARGUMENT WHICH SPECIFIES IF THE ROUTINE IS
C     BEING CALLED FOR THE FIRST TIME. ON AN INITIAL CALL MO = 0 AND
C     WE HAVE THE FOLLOWING SETUP.
C
C        A(NA,N)
C           A IS A MATRIX OF ORDER N. IT IS ASSUMED THAT
C           NA .GE. N .GE. 1.
C
C        C(NC,N)
C           C IS A SYMMETRIC MATRIX OF ORDER N. IT IS
C           ASSUMED THAT NC .GE. N.
C
C        WK(---)
C           WK IS AN ARRAY OF DIMENSION N**2 + 2N THAT
C           IS A GENERAL STORAGE AREA FOR THE ROUTINE.
C
C     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS. WHEN
C     THE ROUTINE TERMINATES, IERR HAS ONE OF THE FOLLOWING VALUES...
C
C        IERR =  0  THE SOLUTION WAS OBTAINED AND STORED IN C.
C        IERR =  1  THE EQUATIONS ARE INCONSISTENT FOR A. THE
C                   PROBLEM CANNOT BE SOLVED.
C        IERR = -1  A COULD NOT BE REDUCEDTO UPPER SCHUR FORM.
C                   THE PROBLEM CANNOT BE SOLVED.
C
C     WHEN IERR = 0, A CONTAINS THE UPPER SCHUR FORM OF THE MATRIX
C     A AND WK CONTAINS THE ORTHOGONAL MATRIX INVOLVED IN THE SCHUR
C     DECOMPOSITION OF A. THIS INFORMATION CAN BE REUSED TO SOLVE A
C     NEW SET OF EQUATIONS TRANSPOSE(A)*X + X*A = C WITHOUT HAVING
C     TO REDECOMPOSE A. IN THIS CASE, THE INPUT ARGUMENT MO MAY BE
C     SET TO ANY NONZERO VALUE. WHEN MO .NE. 0, IT IS ASSUMED THAT
C     ONLY C HAS BEEN MODIFIED. ON OUTPUT THE SOLUTION FOR THE NEW
C     SET OF EQUATIONS IS STORED IN C.
C ----------------------------------------------------------------------
C     THIS SUBROUTINE IS A MODIFICATION BY
C        ALFRED H. MORRIS, JR.
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C     OF THE SUBROUTINE ATXPXA WRITTEN BY
C        R.H. BARTELS AND G.W. STEWART
C        UNIVERSITY OF TEXAS AT AUSTIN.
C
C     REFERENCE. BARTELS, R.H. AND STEWART, G.W., ALGORITHM 432,
C        SOLUTION OF THE MATRIX EQUATION AX + XB = C, COMM. ACM
C        15 (1972), PP. 820-826.
C ----------------------------------------------------------------------
      IW = N*N + 1
      CALL DTASV1 (MO,N,A,NA,WK(1),N,C,NC,WK(IW),IERR)
      RETURN
      END
      SUBROUTINE DTASV1 (MO,N,A,NA,U,NU,C,NC,WK,IERR)
C ----------------------------------------------------------------------
C     DTASV1 SOLVES THE REAL MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
C     WHERE C IS A SYMMETRIC MATRIX. A IS REDUCED TO UPPER SCHUR FORM
C     AND THE TRANSFORMED SYSTEM IS SOLVED.
C ----------------------------------------------------------------------
      DOUBLE PRECISION A(NA,N), U(NU,N), C(NC,N), WK(*)
C
C    IF REQUIRED, REDUCE A TO UPPER REAL SCHUR FORM
C
      IF (MO .NE. 0) GO TO 10
      CALL DORTH (NA,N,1,N,A,WK)
      CALL DRTRN1 (N,1,N,A,NA,U,NU,WK)
      CALL DSCHUR (N,1,N,A,NA,U,NU,WK(1),WK(N+1),IERR)
      IF (IERR .NE. 0) GO TO 200
C
C     TRANSFORM C
C
   10 DO 20 I = 1,N
         C(I,I) = C(I,I)/2.D0
   20 CONTINUE
C
      DO 41 I = 1,N
         DO 31 J = 1,N
            WK(J) = 0.D0
            DO 30 K = I,N
               WK(J) = WK(J) + C(I,K)*U(K,J)
   30       CONTINUE
   31    CONTINUE
         DO 40 J = 1,N
            C(I,J) = WK(J)
   40    CONTINUE
   41 CONTINUE
C
      DO 61 J = 1,N
         DO 51 I = 1,N
            WK(I) = 0.D0
            DO 50 K = 1,N
               WK(I) = WK(I) + U(K,I)*C(K,J)
   50       CONTINUE
   51    CONTINUE
         DO 60 I = 1,N
            C(I,J) = WK(I)
   60    CONTINUE
   61 CONTINUE
C
      DO 71 I = 1,N
         DO 70 J = I,N
            C(I,J) = C(I,J) + C(J,I)
            C(J,I) = C(I,J)
   70    CONTINUE
   71 CONTINUE
C
C     SOLVE THE TRANSFORMED SYSTEM
C
      CALL DSYMSV (A,C,N,NA,NC,IERR)
      IF (IERR .NE. 0) GO TO 210
C
C     TRANSFORM C BACK TO THE SOLUTION
C
      DO 80 I = 1,N
         C(I,I) = C(I,I)/2.D0
   80 CONTINUE
C
      DO 101 I = 1,N
         DO 91 J = 1,N
            WK(J) = 0.D0
            DO 90 K = I,N
               WK(J) = WK(J) + C(I,K)*U(J,K)
   90       CONTINUE
   91    CONTINUE
         DO 100 J = 1,N
            C(I,J) = WK(J)
  100    CONTINUE
  101 CONTINUE
C
      DO 121 J = 1,N
         DO 111 I = 1,N
            WK(I) = 0.D0
            DO 110 K = 1,N
               WK(I) = WK(I) + U(I,K)*C(K,J)
  110       CONTINUE
  111    CONTINUE
         DO 120 I = 1,N
            C(I,J) = WK(I)
  120    CONTINUE
  121 CONTINUE
C
      DO 131 I = 1,N
         DO 130 J = I,N
            C(I,J) = C(I,J) + C(J,I)
            C(J,I) = C(I,J)
  130    CONTINUE
  131 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = -1
      RETURN
  210 IERR = 1
      RETURN
      END
      SUBROUTINE DSYMSV (A,C,N,NA,NC,IERR)
C ----------------------------------------------------------------------
C     DSYMSV SOLVES THE MATRIX EQUATION TRANSPOSE(A)*X + X*A = C
C     WHERE A IS IN UPPER SCHUR FORM AND C IS SYMMETRIC.
C ----------------------------------------------------------------------
      INTEGER N,NA,NC,IERR
      DOUBLE PRECISION A(NA,N), C(NC,N), SUM, P(4), T(4,4)
      INTEGER DK,DL,I,IA,J,K,KK,KM1,L,LL,LDL
C
      L = 1
   10    DL = 1
         IF (L .EQ. N) GO TO 20
         IF (A(L+1,L) .NE. 0.D0) DL = 2
   20    LL = L + DL - 1
C
         K = L
   30       KM1 = K - 1
            DK = 1
            IF (K .EQ. N) GO TO 35
            IF (A(K+1,K) .NE. 0.D0) DK = 2
   35       KK = K + DK - 1
            IF (K .EQ. L) GO TO 45
C
            DO 42 I = K,KK
               DO 41 J = L,LL
               SUM = C(I,J)
                  DO 40 IA = L,KM1
   40             SUM = SUM - A(IA,I)*C(IA,J)
   41          C(I,J) = SUM
   42       CONTINUE
C
   45       IF (DL .EQ. 2) GO TO 60
            IF (DK .EQ. 2 ) GO TO 50
            T(1,1) = A(K,K) + A(L,L)
            IF (T(1,1) .EQ. 0.D0) GO TO 200
            C(K,L) = C(K,L)/T(1,1)
            IERR = 0
            GO TO 90
C
   50       T(1,1) = A(K,K) + A(L,L)
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
C
   60       IF (DK .EQ. 2) GO TO 70
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
C
   70       IF (K .NE. L) GO TO 80
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
C
   80       T(1,1) = A(K,K) + A(L,L)
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
C
   90    K = K + DK
         IF (K .LE. N) GO TO 30
      LDL = L + DL
      IF (LDL .GT. N) RETURN
C
      DO 121 J = LDL,N
         DO 100 I = L,LL
            C(I,J) = C(J,I)
  100    CONTINUE
         DO 120 I = J,N
            DO 110 K = L,LL
  110       C(I,J) = C(I,J) - C(I,K)*A(K,J) - A(K,I)*C(K,J)
  120    C(J,I) = C(I,J)
  121 CONTINUE
      L = LDL
      GO TO 10
C
C     ERROR RETURN
C
  200 IERR = 1
      RETURN
      END
      SUBROUTINE SQUINT(NM, N, A, B, C, IGUESS, S, WORK, NW, TOL,
     * MAXITS, IERR)
C
C
C     SUBROUTINE SQUINT BREAKS DOWN THE WORK ARRAY  WORK  INTO
C     SMALLER PIECES.  THE ACTUAL SOLUTION TO AX**2 + BX + C = 0 IS
C     DONE IN SUBROUTINE SQUIN2.  THIS SUBROUTINE MERELY RELIEVES
C     THE USER FROM A LONG CALLING SEQUENCE.
C
C
C     ON ENTRY,
C
C     NM     IS THE LEADING DIMENSION OF ALL THE MATRICES
C            IN THE CALLING PROGRAM.
C
C     N      IS THE ORDER OF THE MATRICES A, B AND C.
C
C     A      IS THE MATRIX COEFFICIENT OF X**2.
C
C     B      IS THE MATRIX COEFFICIENT OF X.
C
C     C      IS THE CONSTANT MATRIX.
C
C     IGUESS IS AN INTEGER. IF IGUESS.NE.0, THE USER SUPPLIES AN
C            INITIAL GUESS AT A SOLVENT.  THIS GUESS IS STORED IN
C            ARRAY S.  IF IGUESS.EQ.0, THE SUBROUTINE PROVIDES ITS
C            OWN INITIAL GUESS.
C
C     S      CONTAINS THE USERS INITIAL GUESS AT A SOLVENT, IF IGUESS
C            HAS BEEN SET TO A NONZERO QUANTITY.  OTHERWISE THE INPUT
C            CONTENTS IN S ARE IGNORED.
C
C     WORK   IS A WORK VECTOR.  IT MUST BE DIMENSIONED AT LEAST
C            (7N**2 + N), WHERE N IS THE ORDER OF A, B, C AND S.
C
C     NW     IS THE DIMENSION OF THE ARRAY WORK IN THE CALLING
C            PROGRAM.
C
C     TOL    IS A USER-SUPPLIED ACCURACY TOLERANCE.  SETTING TOL = 0.0
C            CAUSES ITERATION TO PROCEED UNTIL FULL MACHINE PRECISION
C            IS ATTAINED.  OTHERWISE, EXECUTION TERMINATES WHEN
C            NORM(AS**2+BS+C).LT.TOL.
C
C     MAXITS IS AN INTEGER.  IF MAXITS.NE.0, THE USER SPECIFIES THE
C            MOST INTERATIONS THE ALGORITHM IS TO TAKE.  IF MAXITS.
C            .LE.0, IT IS RESET TO 30.
C
C
C     ON RETURN,
C
C     A,B,C  ARE DESTROYED.
C
C     IGUESS CONTAINS THE NUMBER OF ITERATIONS PERFORMED TO
C            COMPUTE S.
C
C     S      CONTAINS THE RIGHT SOLVENT.
C
C     WORK(1) IS A COMPLEX NUMBER WITH REAL PART EQUAL TO THE NORM
C            OF AS**2+BS+C.
C
C     IERR   IS AN INTEGER ERROR RETURN.
C
C            IERR = 0 FOR A NORMAL RETURN.
C
C            IERR = 1 INDICATES FAILURE OF SQUINT TO CONVERGE TO
C                     A SOLVENT IN THE MAXIMUM NUMBER OF ITERATIONS.
C
C            IERR = 2 INDICATES FAILURE IN THE UPPER REDUCTION IN
C                     CQZIT.
C
C            IERR = 3 INDICATES FAILURE IN THE LOWER REDUCTION IN
C                     CQZIT.
C
C            IERR = 10 + N  INDICATES AN ERROR RETURN FROM TRISLV
C                     ON ITERATION N, DESIGNATING INCONSISTENCY OF
C                     THE TRIANGULAR SYSTEM.
C
C            IERR = 999 INDICATES IMPROPER DIMENSIONING.  THE
C                     CONDITIONS  NM.GE.N.GT.0   AND
C                     NW.GE.(7*N*N + N) MUST HOLD.
C
      INTEGER NM, N, IGUESS, NW, MAXITS, IERR, I1, I2, I3, I4, I5, I6,
     * I7
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
      CALL SQUIN2(NM, N, A, B, C, IGUESS, S, WORK(1), WORK(I1),
     * WORK(I2), WORK(I3), WORK(I4), WORK(I5), WORK(I6), WORK(I7), NW,
     * TOL, MAXITS, IERR)
      RETURN
      END
      SUBROUTINE SQUIN2(NM, N, A, B, C, IGUESS, S, L, U, V, Z, R, XOLD,
     * EYE, TEMP, NW, TOL, MAXITS, IERR)
C
C     SUBROUTINE SQUIN2 FINDS A RIGHT SOLVENT OF THE MATRIX
C     EQUATION AX**2 + BX + C = 0.
C
C     ON ENTRY,
C
C     NM     IS THE LEADING DIMENSION OF ALL THE MATRICES IN
C            THE CALLING PROGRAM.
C
C     N      IS THE ORDER OF THE MATRICES A, B AND C.
C
C     A      IS THE MATRIX COEFFICIENT OF X**2.
C
C     B      IS THE MATRIX COEFFICIENT OF X.
C
C     C      IS THE CONSTANT MATRIX.
C
C     IGUESS IS AN INTEGER SET IN THE CALL TO SQUINT.
C
C     S      IS A MATRIX SET IN THE CALL TO SQUINT.
C
C     NW, TOL, AND MAXITS ARE INTEGER AND REAL PARAMETERS SET IN
C            THE CALL TO SQUINT.
C
C
C     THE FOLLOWING ARE INTERNAL VARIABLES ...
C
C
C     L      IS A MATRIX CONTAINING THE ITERATE X(I) FOR
C            REDUCTION TO LOWER TRIANGULAR FORM.
C
C     U      IS A MATRIX CONTAINING AX(I) + B FOR REDUCTION
C            TO UPPER TRIANGULAR FORM.
C
C     V      IS A MATRIX CONTAINING A FOR REDUCTION TO UPPER
C            TRIANGULAR FORM.
C
C     Z,R    ARE MATRICES CONTAINING THE HISTORY OF THE
C            TRANSFORMATIONS IN THE REDUCTIONS.
C
C     XOLD   IS A MATRIX HOLDING THE CURRENT ITERATE X(I).
C
C     EYE    CONTAINS AN IDENTITY MATRIX FOR THE LOWER REDUCTION
C            STEP.
C
C     TEMP   IS A WORK VECTOR.
C
C
C     ON RETURN,
C
C     A, B, C, IGUESS, S AND IERR HAVE THE SAME PROPERTIES AS
C            DESCRIBED IN THE RETURN FROM SUBROUTINE SQUINT.
C
C     L(1,1) IS A COMPLEX NUMBER WITH REAL PART EQUAL TO THE NORM
C            OF AS**2+BS+C.
C
C
      INTEGER NM, N, IGUESS, NW, MAXITS, IERR
      INTEGER ITS, MATS, I, J, K
      COMPLEX A(NM,N), B(NM,N), C(NM,N), S(NM,N), L(NM,N), U(NM,N)
      COMPLEX V(NM,N), Z(NM,N), R(NM,N), XOLD(NM,N), EYE(NM,N), TEMP(N)
      REAL ANORM, ANI, BNORM, BNI, CNORM, CNI, XNORM, XNI
      REAL FXNORM, FXNI, GNORM, TNORM, T, TOL
C     REAL SQRT, CABS, FLOAT
C     COMPLEX CMPLX, CONJG
      K = 7*N*N + N
      IF (NW.LT.K) GO TO 460
      IF (NM.LT.N) GO TO 460
      IF (N.LE.0) GO TO 460
      IF (MAXITS.LE.0) MAXITS = 30
C     ********** INITIALIZE ARRAYS **********
      DO 20 I=1,N
        DO 10 J=1,N
          L(I,J) = CMPLX(0.0,0.0)
          U(I,J) = CMPLX(0.0,0.0)
          V(I,J) = CMPLX(0.0,0.0)
          Z(I,J) = CMPLX(0.0,0.0)
          XOLD(I,J) = CMPLX(0.0,0.0)
          EYE(I,J) = CMPLX(0.0,0.0)
   10   CONTINUE
        TEMP(I) = CMPLX(0.0,0.0)
   20 CONTINUE
C     ********** SET INITIAL GUESS(ES) **********
      ANORM = 0.0
      BNORM = 0.0
      CNORM = 0.0
      DO 40 I=1,N
        ANI = 0.0
        BNI = 0.0
        CNI = 0.0
        DO 30 J=1,N
          ANI = ANI + CABS(A(I,J))
          BNI = BNI + CABS(B(I,J))
          CNI = CNI + CABS(C(I,J))
   30   CONTINUE
        IF (ANI.GT.ANORM) ANORM = ANI
        IF (BNI.GT.BNORM) BNORM = BNI
        IF (CNI.GT.CNORM) CNORM = CNI
   40 CONTINUE
      GNORM = (BNORM+SQRT(BNORM**2+4.0*ANORM*CNORM))/(2.0*ANORM)
      IF (IGUESS.EQ.0) GO TO 70
      DO 60 I=1,N
        DO 50 J=1,N
          XOLD(I,J) = S(I,J)
   50   CONTINUE
   60 CONTINUE
      GO TO 100
C
   70 DO 90 I=1,N
        DO 80 J=1,N
          XOLD(I,J) = CMPLX(0.0,0.0)
   80   CONTINUE
        XOLD(I,I) = CMPLX(GNORM,0.0)
   90 CONTINUE
C
  100 DO 360 ITS=1,MAXITS
        IF (ITS.NE.31) GO TO 130
        DO 120 I=1,N
          DO 110 J=1,N
            XOLD(I,J) = CMPLX(0.0,0.0)
  110     CONTINUE
          XOLD(I,I) = CMPLX(0.0,GNORM)
  120   CONTINUE
C
  130   IF (ITS.NE.61) GO TO 160
        DO 150 I=1,N
          DO 140 J=1,N
            XOLD(I,J) = C(I,J)
  140     CONTINUE
  150   CONTINUE
C        ********** SET UP U AND RIGHT HAND SIDE **********
  160   CALL CMPROD(N, N, N, A, NM, XOLD, NM, U, NM, U)
        DO 180 I=1,N
          DO 170 J=1,N
            U(I,J) = U(I,J) + B(I,J)
  170     CONTINUE
  180   CONTINUE
        CALL CMPROD(N, N, N, U, NM, XOLD, NM, S, NM, S)
        DO 200 I=1,N
          DO 190 J=1,N
            S(I,J) = S(I,J) + C(I,J)
  190     CONTINUE
  200   CONTINUE
C        ********** CHECK FOR CONVERGENCE **********
        XNORM = 0.0
        FXNORM = 0.0
        DO 220 I=1,N
          XNI = 0.0
          FXNI = 0.0
          DO 210 J=1,N
            XNI = XNI + CABS(XOLD(I,J))
            FXNI = FXNI + CABS(S(I,J))
  210     CONTINUE
          IF (XNI.GT.XNORM) XNORM = XNI
          IF (FXNI.GT.FXNORM) FXNORM = FXNI
  220   CONTINUE
        IF (TOL.LE.0.0) GO TO 230
        IF (FXNORM.LT.TOL) GO TO 370
  230   TNORM = 8.0*FLOAT(N)*ANORM*XNORM**2 + 5.0*FLOAT(N)*BNORM*XNORM
     *   + CNORM
        T = 1.0 + FXNORM/TNORM
        IF (T.EQ.1.0) GO TO 370
        IF (ITS.GE.MAXITS) GO TO 400
C        ********** UPPER TRIANGULARIZATION **********
        IF (ITS.NE.1) GO TO 240
        MATS = 1
        CALL CQZHES(NM, N, U, A, MATS, Z, S, B, C)
  240   DO 260 I=1,N
          DO 250 J=1,N
            V(I,J) = A(I,J)
            L(I,J) = CONJG(XOLD(J,I))
            EYE(I,J) = CMPLX(0.0,0.0)
  250     CONTINUE
          EYE(I,I) = CMPLX(1.0,0.0)
  260   CONTINUE
        IF (ITS.EQ.1) GO TO 270
        MATS = 2
        CALL CQZHES(NM, N, U, V, MATS, Z, S, B, C)
  270   CALL CQZIT(NM, N, U, V, 0.0, MATS, Z, S, IERR)
        IF (IERR.NE.0) GO TO 430
C        ********** LOWER TRIANGULARIZATION **********
        MATS = 3
        CALL CQZHES(NM, N, L, EYE, MATS, R, S, B, C)
        CALL CQZIT(NM, N, L, EYE, 0.0, MATS, R, S, IERR)
        IF (IERR.NE.0) GO TO 440
        CALL CTRANS(NM, N, L)
C        ********** UPDATE S WITH R **********
        DO 310 I=1,N
          DO 280 J=1,N
            TEMP(J) = S(I,J)
            S(I,J) = CMPLX(0.0,0.0)
  280     CONTINUE
          DO 300 J=1,N
            DO 290 K=1,N
              S(I,J) = S(I,J) + TEMP(K)*R(K,J)
  290       CONTINUE
  300     CONTINUE
  310   CONTINUE
        DO 330 J=1,N
          DO 320 I=1,N
            L(I,J) = L(I,J)*EYE(J,J)
  320     CONTINUE
          EYE(J,J) = CMPLX(1.0,0.0)
  330   CONTINUE
C        ********** BACKSOLVE THE TRANSFORMED SYSTEM **********
        CALL TRISLV(NM, N, U, V, L, S, TEMP, IERR)
        IF (IERR.NE.0) GO TO 450
C        ********** TRANSLATE BACK TO THE SOLUTION **********
        CALL CMPROD(N, N, N, Z, NM, S, NM, L, NM, L)
        CALL CTRANS(NM, N, R)
        CALL CMPROD(N, N, N, L, NM, R, NM, S, NM, S)
        DO 350 I=1,N
          DO 340 J=1,N
            XOLD(I,J) = XOLD(I,J) - S(I,J)
  340     CONTINUE
  350   CONTINUE
  360 CONTINUE
C     ********** CONVERGENCE **********
  370 IGUESS = ITS - 1
      L(1,1) = CMPLX(FXNORM,0.0)
      DO 390 I=1,N
        DO 380 J=1,N
          S(I,J) = XOLD(I,J)
  380   CONTINUE
  390 CONTINUE
      IERR = 0
      RETURN
C     ********** ERROR RETURNS **********
  400 IERR = 1
      L(1,1) = CMPLX(FXNORM,0.0)
      DO 420 I=1,N
        DO 410 J=1,N
          S(I,J) = XOLD(I,J)
  410   CONTINUE
  420 CONTINUE
      RETURN
  430 IERR = 2
      RETURN
  440 IERR = 3
      RETURN
  450 IERR = ITS + 10
      RETURN
  460 IERR = 999
      RETURN
      END
      SUBROUTINE CQZHES(NM, N, A, B, MATS, Z, F, G, H)
C
C
C     SUBROUTINE CQZHES IS A MODIFICATION OF THE EISPACK SUBROUTINE
C     QZHES.  ALL OPERATIONS ARE PERFORMED IN COMPLEX ARITHMETIC,
C     AND THE LEFT TRANSFORMATIONS MAY ALSO BE APPLIED TO AUXILIARY
C     MATRICES F, G AND H.
C
C
C     ON ENTRY,
C
C     NM   IS THE LEADING DIMENSION OF THE MATRICES A AND B IN
C          THE MAIN PROGRAM.
C
C     N    IS THE ORDER OF THE MATRICES A AND B.
C
C     A    CONTAINS THE MATRIX TO BE REDUCED TO UPPER HESSENBERG
C          FORM.
C
C     B    CONTAINS THE MATRIX TO BE REDUCED TO UPPER TRAINGULAR
C          FORM.
C
C     MATS IS AN INTEGER INPUT VARIABLE.
C
C          IF MATS = 0, THE ACCUMULATION OF THE TRANSFORMATIONS
C             IS NOT DESIRED.
C
C          IF MATS = ANY OTHER NUMBER BUT 0, THE TRANSFORMATIONS
C             ARE ACCUMULATED.
C
C          IF MATS = 1, THE AUXILIARY MATRICES G AND H ARE UPDATED
C             WITH THE UNITARY MATRIX Q.
C
C          IF MATS = 2, MATRIX B IS ASSUMED UPPER TRIANGULAR.
C
C          IF MATS = 3, THE AUXILIARY MATRIX F IS NOT UPDATED
C             WITH THE UNITARY MATRIX Q.
C
C     F, G AND H ARE AUXILIARY MATRICES.
C
C
C     ON RETURN,
C
C     A    IS UPPER HESSENBERG.
C
C     B    IS UPPER TRIANGULAR.
C
C     Z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
C
C     F, G AND H ARE UPDATED, IF DESIRED.
C
C
      INTEGER I, J, K, L, N, LB, L1, NM, NK1, NM1, NM2
      COMPLEX A(NM,N), B(NM,N), Z(NM,N)
      COMPLEX RR, T, U1, U2, V1, V2, RHO
      COMPLEX F(NM,N), TF, G(NM,N), TG, H(NM,N), TH
      REAL R, S
      INTEGER MATS
C     REAL SQRT, CABS
C     COMPLEX CMPLX, CONJG
      IF (MATS.EQ.0) GO TO 30
      DO 20 I=1,N
        DO 10 J=1,N
          Z(I,J) = CMPLX(0.0,0.0)
   10   CONTINUE
        Z(I,I) = CMPLX(1.0,0.0)
   20 CONTINUE
C     ********** REDUCE B TO UPPER TRIANGULAR FORM **********
   30 IF (N.LE.1) GO TO 260
      NM1 = N - 1
      IF (MATS.EQ.2) GO TO 140
      DO 130 L=1,NM1
        L1 = L + 1
        S = 0.0
        DO 40 I=L1,N
          S = S + CABS(B(I,L))
   40   CONTINUE
        IF (S.EQ.0.0) GO TO 130
        S = S + CABS(B(L,L))
        R = 0.0
        DO 50 I=L,N
          B(I,L) = B(I,L)/CMPLX(S,0.0)
          R = R + CABS(B(I,L))**2
   50   CONTINUE
        R = SQRT(R)
        RR = CMPLX(R,0.0)
        IF (CABS(B(L,L)).NE.0.0) RR = (B(L,L)/CABS(B(L,L)))*RR
        B(L,L) = B(L,L) + RR
        RHO = CONJG(RR)*B(L,L)
        DO 80 J=L1,N
          T = CMPLX(0.0,0.0)
          DO 60 I=L,N
            T = T + CONJG(B(I,L))*B(I,J)
   60     CONTINUE
          T = -T/RHO
          DO 70 I=L,N
            B(I,J) = B(I,J) + T*B(I,L)
   70     CONTINUE
   80   CONTINUE
        DO 110 J=1,N
          T = CMPLX(0.0,0.0)
          TF = CMPLX(0.0,0.0)
          TG = CMPLX(0.0,0.0)
          TH = CMPLX(0.0,0.0)
          DO 90 I=L,N
            T = T + CONJG(B(I,L))*A(I,J)
            IF (MATS.EQ.3) GO TO 90
            TF = TF + CONJG(B(I,L))*F(I,J)
            IF (MATS.NE.1) GO TO 90
            TG = TG + CONJG(B(I,L))*G(I,J)
            TH = TH + CONJG(B(I,L))*H(I,J)
   90     CONTINUE
          T = -T/RHO
          TF = -TF/RHO
          TG = -TG/RHO
          TH = -TH/RHO
          DO 100 I=L,N
            A(I,J) = A(I,J) + T*B(I,L)
            IF (MATS.EQ.3) GO TO 100
            F(I,J) = F(I,J) + TF*B(I,L)
            IF (MATS.NE.1) GO TO 100
            G(I,J) = G(I,J) + TG*B(I,L)
            H(I,J) = H(I,J) + TH*B(I,L)
  100     CONTINUE
  110   CONTINUE
        B(L,L) = -CMPLX(S,0.0)*RR
        DO 120 I=L1,N
          B(I,L) = CMPLX(0.0,0.0)
  120   CONTINUE
  130 CONTINUE
C     ********** REDUCE A TO UPPER HESSENBERG FORM, WHILE
C                KEEPING B TRIANGULAR **********
  140 IF (N.EQ.2) GO TO 260
      NM2 = N - 2
      DO 250 K=1,NM2
        NK1 = NM1 - K
        DO 240 LB=1,NK1
          L = N - LB
          L1 = L + 1
C     ********** ZERO A(L+1,K) **********
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
          DO 150 J=K,N
            T = A(L,J) + CONJG(U2)*A(L1,J)
            A(L,J) = A(L,J) + T*V1
            A(L1,J) = A(L1,J) + T*V2
  150     CONTINUE
          A(L1,K) = CMPLX(0.0,0.0)
          DO 160 J=L,N
            T = B(L,J) + CONJG(U2)*B(L1,J)
            B(L,J) = B(L,J) + T*V1
            B(L1,J) = B(L1,J) + T*V2
  160     CONTINUE
          IF (MATS.EQ.3) GO TO 180
          DO 170 J=1,N
            TF = F(L,J) + CONJG(U2)*F(L1,J)
            F(L,J) = F(L,J) + TF*V1
            F(L1,J) = F(L1,J) + TF*V2
  170     CONTINUE
  180     IF (MATS.NE.1) GO TO 200
          DO 190 J=1,N
            TG = G(L,J) + CONJG(U2) + G(L1,J)
            TH = H(L,J) + CONJG(U2) + H(L1,J)
            G(L,J) = G(L,J) + TG*V1
            H(L,J) = H(L,J) + TH*V1
            G(L1,J) = G(L1,J) + TG*V2
            H(L1,J) = H(L1,J) + TH*V2
  190     CONTINUE
C     ********** ZERO B(L+1,L) **********
  200     S = CABS(B(L1,L1)) + CABS(B(L1,L))
          IF (S.EQ.0.0) GO TO 240
          U1 = B(L1,L1)/CMPLX(S,0.0)
          U2 = B(L1,L)/CMPLX(S,0.0)
          R = SQRT(CABS(U1)**2+CABS(U2)**2)
          RR = CMPLX(R,0.0)
          IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
          V1 = -(U1+RR)/RR
          V2 = -U2/RR
          U2 = V2/V1
          DO 210 I=1,L1
            T = B(I,L1) + CONJG(U2)*B(I,L)
            B(I,L1) = B(I,L1) + T*V1
            B(I,L) = B(I,L) + T*V2
  210     CONTINUE
          B(L1,L) = CMPLX(0.0,0.0)
          DO 220 I=1,N
            T = A(I,L1) + CONJG(U2)*A(I,L)
            A(I,L1) = A(I,L1) + T*V1
            A(I,L) = A(I,L) + T*V2
  220     CONTINUE
          IF (MATS.EQ.0) GO TO 240
          DO 230 I=1,N
            T = Z(I,L1) + CONJG(U2)*Z(I,L)
            Z(I,L1) = Z(I,L1) + T*V1
            Z(I,L) = Z(I,L) + T*V2
  230     CONTINUE
  240   CONTINUE
  250 CONTINUE
  260 RETURN
      END
      SUBROUTINE CQZIT(NM, N, A, B, EPS1, MATS, Z, F, IERR)
C
C
C     SUBROUTINE CQZIT IS A MODIFICATION OF THE EISPACK SUBROUTINE
C     QZIT.  ALL OPERATIONS ARE PERFORMED IN COMPLEX ARITHMETIC,
C     AND THE LEFT TRANSFORMATIONS MAY ALSO BE APPLIED TO AN AUXILIARY
C     MATRIX F.
C
C
C     ON ENTRY,
C
C     NM   IS THE LEADING DIMENSION OF THE MATRICES A AND B IN
C          THE MAIN PROGRAM.
C
C     N    IS THE ORDER OF THE MATRICES A AND B.
C
C     A    CONTAINS AN UPPER HESSENBERG MATRIX FROM CQZHES.
C
C     B    CONTAINS AN UPPER TRIANGULAR MATRIX FROM CQZHES.
C
C     EPS1 IS A REAL NUMBER DEFINING THE TOLERANCE USED TO DETERMINE
C          NEGLIGIBLE ELEMENTS OF A AND B IN THE COURSE OF THE ALG-
C          ORITHM.  AN ELEMENT OF EITHER MATRIX WILL BE CONSIDERED
C          NEGLIGIBLE AND RESET TO ZERO IF IT IS NOT LARGER THAN THE
C          PRODUCT OF EPS1 AND THE NORM OF THE MATRIX.  IF EPS1.LE.0,
C          RELATIVE MACHINE PRECISION WILL BE COMPUTED AND
C          USED INSTEAD.
C
C     MATS IS AN INTEGER INPUT VARIABLE.  IT IS SET PRIOR
C          TO THE CALL TO CQZHES.
C
C     F    CONTAINS AN AUXILIARY MATRIX.
C
C
C     ON RETURN,
C
C     A    IS UPPER TRIANGULAR.
C
C     B    IS UPPER TRIANGULAR.
C
C     Z    CONTAINS THE HISTORY OF THE TRANSFORMATIONS, IF DESIRED.
C
C     F    CONTAINS THE AUXILIARY MATRIX, UPDATED IF DESIRED.
C
C     IERR IS AN INTEGER ERROR RETURN WHICH INDICATES FAILURE
C          OF THE QZ ALGORITHM TO REDUCE A SUBDIAGONAL ELEMENT
C          TO ZERO AFTER 50 ITERATIONS.
C
      INTEGER I, J, K, L, N, EN, JJ, K1, K2, LD, LL, L1, NA, NM, ISH,
     * ITS, KM1, LM1
      INTEGER ENM2, IERR, LOR1, ENORN
      COMPLEX A(NM,N), B(NM,N), Z(NM,N)
      COMPLEX A11, A21, A33, A34, A43, A44, B11, B22, B33, B34, B44
      COMPLEX A1, A2, U1, U2, V1, V2, T, RR, SH, SS
      COMPLEX F(NM,N), TF
      REAL EPS1, EPSA, EPSB, ANORM, BNORM, ANI, BNI, SRELPR, R, S
      INTEGER MATS
      REAL SPMPAR
C     INTEGER MAX0, MIN0
C     REAL SQRT, CABS
C     COMPLEX CMPLX, CONJG, CSQRT
      IERR = 0
C     ********** COMPUTE EPSA, EPSB **********
      ANORM = 0.0
      BNORM = 0.0
      DO 20 I=1,N
        ANI = 0.0
        IF (I.NE.1) ANI = CABS(A(I,I-1))
        BNI = 0.0
        DO 10 J=I,N
          ANI = ANI + CABS(A(I,J))
          BNI = BNI + CABS(B(I,J))
   10   CONTINUE
        IF (ANI.GT.ANORM) ANORM = ANI
        IF (BNI.GT.BNORM) BNORM = BNI
   20 CONTINUE
      IF (ANORM.EQ.0.0) ANORM = 1.0
      IF (BNORM.EQ.0.0) BNORM = 1.0
      SRELPR = EPS1
      IF (SRELPR.GT.0.0) GO TO 40
C
C     ***** WHEN EPS1 = 0 THEN SET SRELPR TO BE THE SMALLEST
C           NUMBER FOR WHICH 1 + SRELPR .GT. 1 *****
C
      SRELPR = SPMPAR(1)
C
   40 EPSA = SRELPR*ANORM
      EPSB = SRELPR*BNORM
C     ********** REDUCE A TO TRIANGULAR FORM, WHILE
C                KEEPING B TRIANGULAR **********
      LOR1 = 1
      ENORN = N
      EN = N
C     ********** BEGIN QZ STEP **********
   50 IF (EN.LE.1) GO TO 220
      IF (MATS.EQ.0) ENORN = EN
      ITS = 0
      NA = EN - 1
      ENM2 = NA - 1
   60 ISH = 1
C     ********** CHECK FOR CONVERGENCE OR REDUCIBILITY **********
      DO 70 LL=1,EN
        LM1 = EN - LL
        L = LM1 + 1
        IF (L.EQ.1) GO TO 90
        IF (CABS(A(L,LM1)).LE.EPSA) GO TO 80
   70 CONTINUE
   80 A(L,LM1) = CMPLX(0.0,0.0)
      IF (L.LT.NA) GO TO 90
C     ********** 1-BY-1 BLOCK ISOLATED **********
      EN = LM1
      GO TO 50
C     ********** CHECK FOR SMALL TOP OF B **********
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
      DO 110 J=L,ENORN
        T = A(L,J) + CONJG(U2)*A(L1,J)
        A(L,J) = A(L,J) + T*V1
        A(L1,J) = A(L1,J) + T*V2
        T = B(L,J) + CONJG(U2)*B(L1,J)
        B(L,J) = B(L,J) + T*V1
        B(L1,J) = B(L1,J) + T*V2
        IF (MATS.EQ.3) GO TO 110
        DO 100 JJ=1,N
          TF = F(L,JJ) + CONJG(U2)*F(L1,JJ)
          F(L,JJ) = F(L,JJ) + TF*V1
          F(L1,JJ) = F(L1,JJ) + TF*V2
  100   CONTINUE
  110 CONTINUE
      IF (L.NE.1) A(L,LM1) = -A(L,LM1)
      LM1 = L
      L = L1
      GO TO 80
  120 A11 = A(L,L)/B11
      A21 = A(L1,L)/B11
C     ********** ITERATION STRATEGY **********
      IF (ITS.EQ.50) GO TO 210
C     ********** DETERMINE SHIFT **********
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
C     ********** DETERMINE SINGLE SHIFT ZEROTH COLUMN OF A **********
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
C     ********** MAIN LOOP **********
      DO 200 K=L,NA
        K1 = K + 1
        K2 = K + 2
        KM1 = MAX0(K-1,L)
        LL = MIN0(EN,K1+ISH)
C     ********** ZERO A(K+1,K-1) **********
        IF (K.EQ.L) GO TO 140
        A1 = A(K,KM1)
        A2 = A(K1,KM1)
  140   S = CABS(A1) + CABS(A2)
        IF (S.EQ.0.0) GO TO 60
        U1 = A1/CMPLX(S,0.0)
        U2 = A2/CMPLX(S,0.0)
        R = SQRT(CABS(U1)**2+CABS(U2)**2)
        RR = CMPLX(R,0.0)
        IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
        V1 = -(U1+RR)/RR
        V2 = -U2/RR
        U2 = V2/V1
        DO 150 J=KM1,ENORN
          T = A(K,J) + CONJG(U2)*A(K1,J)
          A(K,J) = A(K,J) + T*V1
          A(K1,J) = A(K1,J) + T*V2
          T = B(K,J) + CONJG(U2)*B(K1,J)
          B(K,J) = B(K,J) + T*V1
          B(K1,J) = B(K1,J) + T*V2
  150   CONTINUE
        IF (K.NE.L) A(K1,KM1) = CMPLX(0.0,0.0)
        IF (MATS.EQ.3) GO TO 170
        DO 160 J=1,N
          TF = F(K,J) + CONJG(U2)*F(K1,J)
          F(K,J) = F(K,J) + TF*V1
          F(K1,J) = F(K1,J) + TF*V2
  160   CONTINUE
C     ********** ZERO B(K+1,K) **********
  170   S = CABS(B(K1,K1)) + CABS(B(K1,K))
        IF (S.EQ.0.0) GO TO 200
        U1 = B(K1,K1)/CMPLX(S,0.0)
        U2 = B(K1,K)/CMPLX(S,0.0)
        R = SQRT(CABS(U1)**2+CABS(U2)**2)
        RR = CMPLX(R,0.0)
        IF (CABS(U1).NE.0.0) RR = (U1/CABS(U1))*RR
        V1 = -(U1+RR)/RR
        V2 = -U2/RR
        U2 = V2/V1
        DO 180 I=LOR1,LL
          T = A(I,K1) + CONJG(U2)*A(I,K)
          A(I,K1) = A(I,K1) + T*V1
          A(I,K) = A(I,K) + T*V2
          T = B(I,K1) + CONJG(U2)*B(I,K)
          B(I,K1) = B(I,K1) + T*V1
          B(I,K) = B(I,K) + T*V2
  180   CONTINUE
        B(K1,K) = CMPLX(0.0,0.0)
        IF (MATS.EQ.0) GO TO 200
        DO 190 I=1,N
          T = Z(I,K1) + CONJG(U2)*Z(I,K)
          Z(I,K1) = Z(I,K1) + T*V1
          Z(I,K) = Z(I,K) + T*V2
  190   CONTINUE
  200 CONTINUE
C     ********** END QZ STEP **********
      GO TO 60
C     ********** SET ERROR -- NEITHER BOTTOM SUBDIAGONAL ELEMENT
C                HAS BECOME NEGLIGIBLE AFTER 50 ITERATIONS **********
  210 IERR = EN
C     ********** SAVE EPSB FOR USE BY CQZVEC **********
  220 IF (N.GT.1) B(N,1) = CMPLX(EPSB,0.0)
      RETURN
      END
      SUBROUTINE TRISLV(NM, N, U, V, L, F, TEMP, IERR)
C
C
C     SUBROUTINE TRISLV BACKSOLVES A SYSTEM OF THE FORM
C     UY + VYL = F, WHERE U AND V ARE UPPER TRIANGULAR, AND
C     L IS LOWER TRIANGULAR.
C
C
C     ON ENTRY,
C
C     NM   IS THE LEADING DIMENSION OF THE MATRICES U, V, L AND F IN
C          THE MAIN PROGRAM.
C
C     N    IS THE ORDER OF THE MATRICES U, V, L AND F.
C
C     U    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
C          COEFFICIENT OF Y IN THE FIRST TERM IN UY + VYL.
C
C     V    CONTAINS AN UPPER TRIANGULAR MATRIX.  IT IS THE LEFT
C          COEFFICIENT OF Y IN THE SECOND TERM OF UY + VYL.
C
C     L    CONTAINS A LOWER TRIANGULAR MATRIX.  IT IS THE RIGHT
C          COEFFICIENT OF Y IN THE SECOND TERM OF UY + VYL.
C
C     F    CONTAINS THE RIGHT HAND SIDE OF UY + VYL = F.
C
C     TEMP CONTAINS A WORK VECTOR OF LENGTH AT LEAST N.
C
C     ON RETURN,
C
C     F    CONTAINS THE SOLUTION Y.
C
C     IERR IS AN ERROR RETURN DESIGNATING INCONSISTENCY OF THE
C          ORIGINAL SYSTEM.
C          IERR.EQ.0 FOR A NORMAL RETURN.
C          IERR.EQ.1 IF THE TRIANGULAR SYSTEM IS INCONSISTENT.
C
C
      INTEGER I, IERR, J, JP1, K, KK, KM1, M, N, NM, NM1
      COMPLEX U(NM,N), V(NM,N), L(NM,N), F(NM,N)
      COMPLEX TEMP(N)
      COMPLEX DENOM, SUM
      REAL S, T
C     REAL CABS
C     COMPLEX CMPLX
      IERR = 0
      NM1 = N - 1
      DO 120 KK=1,N
C        ********** BACKSUBSTITUTE FOR ROW K. **********
        K = N - KK + 1
        IF (CABS(F(K,N)).NE.0.0) GO TO 10
        F(K,N) = CMPLX(0.0,0.0)
        GO TO 30
   10   DENOM = U(K,K) + V(K,K)*L(N,N)
        S = CABS(DENOM)
        T = 1.0 + S/CABS(F(K,N))
        IF (T.GT.1.0) GO TO 20
        IERR = 1
        RETURN
   20   F(K,N) = F(K,N)/DENOM
        IF (N.EQ.1) RETURN
   30   DO 70 I=1,NM1
          J = N - I
          JP1 = J + 1
          SUM = CMPLX(0.0,0.0)
          DO 40 M=JP1,N
            SUM = SUM + F(K,M)*L(M,J)
   40     CONTINUE
          SUM = F(K,J) - V(K,K)*SUM
          IF (CABS(SUM).NE.0.0) GO TO 50
          F(K,J) = CMPLX(0.0,0.0)
          GO TO 70
   50     DENOM = U(K,K) + V(K,K)*L(J,J)
          S = CABS(DENOM)
          T = 1.0 + S/CABS(SUM)
          IF (T.GT.1.0) GO TO 60
          IERR = 1
          RETURN
   60     F(K,J) = SUM/DENOM
   70   CONTINUE
C        ********** FORM TEMP = YK-TRANS*L. **********
        IF (K.EQ.1) RETURN
        KM1 = K - 1
        DO 90 I=1,N
          TEMP(I) = CMPLX(0.0,0.0)
          DO 80 J=1,N
            TEMP(I) = TEMP(I) + F(K,J)*L(J,I)
   80     CONTINUE
   90   CONTINUE
C        ********** PREPARE F' WHICH IS (K-1) BY N. **********
        DO 110 I=1,KM1
          DO 100 J=1,N
            F(I,J) = F(I,J) - U(I,K)*F(K,J) - V(I,K)*TEMP(J)
  100     CONTINUE
  110   CONTINUE
  120 CONTINUE
      RETURN
      END
      SUBROUTINE MEXP (A, KA, N, Z, KZ, WK, IERR)
      REAL A(KA,N),Z(KZ,N),WK(N,*),C(8)
C ----------------------------------------------------------------------
C     MEXP COMPUTES EXP(A) AND STORES IT IN Z WHERE A IS A MATRIX
C     OF ORDER N. A IS DESTROYED BY THE ROUTINE.
C
C     WK IS AN ARRAY OF DIMENSION (N,N+8). WK IS A WORK SPACE
C     FOR THE ROUTINE.
C
C     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
C        IERR = 0  EXP(A) WAS SUCCESSFULLY COMPUTED.
C        IERR = 1  THE NORM OF A IS TOO LARGE.
C        IERR = 2  THE PADE DENOMINATOR MATRIX IS
C                  SINGULAR.
C
C     WRITTEN BY ALFRED H. MORRIS
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN VIRGINIA
C     ---------------
C     COEFFICIENTS FOR (8,8) PADE TABLE ENTRY
C     ---------------
      DATA C(1)/.500000000000000E+00/, C(2)/.116666666666667E+00/,
     *     C(3)/.166666666666667E-01/, C(4)/.160256410256410E-02/,
     *     C(5)/.106837606837607E-03/, C(6)/.485625485625486E-05/,
     *     C(7)/.138750138750139E-06/, C(8)/.192708526041859E-08/
C ----------------------------------------------------------------------
      IERR = 0
      IF (N .GT. 1) GO TO 10
         Z(1,1) = EXP(A(1,1))
         RETURN
C
C       BALANCE A AND SELECT THE SMALLER OF THE 1-NORM
C              AND INFINITY-NORM OF THE RESULT
C
   10 CALL BALANC (KA,N,A,LOW,IGH,WK(1,N+8))
      ANORM = 0.0
      ANORM1 = 0.0
      DO 12 J = 1,N
      S = 0.0
      S1 = 0.0
         DO 11 I = 1,N
         S = S + ABS(A(J,I))
   11    S1 = S1 + ABS(A(I,J))
      ANORM = AMAX1(S,ANORM)
   12 ANORM1 = AMAX1(S1,ANORM1)
C
      ANORM = AMIN1(ANORM,ANORM1)
      S = ANORM + 0.1
      IF (S .EQ. ANORM) GO TO 200
C
C              SELECT THE NORMALIZATION FACTOR
C
      M = 0
      IF (ANORM .LE. 1.0)  GO TO 40
      FACTOR = 1.0
   20 M = M + 1
      FACTOR = 2.0*FACTOR
      IF (ANORM .GT. FACTOR) GO TO 20
C
C                NORMALIZE THE MATRIX A
C
      DO 31 J = 1,N
         DO 30 I = 1,N
   30    A(I,J) = A(I,J)/FACTOR
   31 CONTINUE
C
   40 NP1 = N + 1
      NP6 = N + 6
      DO 100 J = 1,N
C
C     COMPUTE THE J-TH COLUMN OF FIRST EIGHT POWERS OF A
C
         DO 51 I = 1,N
         S = 0.0
            DO 50 L = 1,N
   50       S = S + A(I,L)*A(L,J)
   51    WK(I,NP1) = S
C
         DO 70 K = NP1,NP6
         KP1 = K + 1
            DO 61 I = 1,N
            S = 0.0
               DO 60 L = 1,N
   60          S = S + A(I,L)*WK(L,K)
   61       WK(I,KP1) = S
   70    CONTINUE
C
C     COMPUTE THE J-TH COLUMN OF THE NUMERATOR AND DENOMINATOR
C                  OF THE PADE APPROXIMATION
C
         DO 90 I = 1,N
         P = 0.0
         Q = 0.0
         K = 8
         L = N + 7
            DO 80 LL = 1,7
            S = C(K)*WK(I,L)
            P = S + P
            Q = S - Q
            K = K - 1
   80       L = L - 1
         S = C(1)*A(I,J)
         Z(I,J) = P + S
         WK(I,J) = Q - S
         IF (I .NE. J) GO TO 90
            Z(I,J) = Z(I,J) + 1.0
            WK(I,J) = WK(I,J) + 1.0
   90    CONTINUE
  100 CONTINUE
C
C        CALCULATE EXP(A) BY SOLVING  WK * EXP(A) = Z
C
      CALL SLV (N, N, WK, N, Z, KZ, IERR)
      IF (IERR .NE. 0) GO TO 210
      IF (M .EQ. 0)  GO TO 150
C
C          TAKE OUT THE EFFECT OF THE NORMALIZATION
C                   OPERATION ON EXP(A)
C
      DO 140 K = 1,M
         DO 121 J = 1,N
            DO 120 I = 1,N
            S = 0.0
               DO 110 L = 1,N
  110          S = S + Z(I,L)*Z(L,J)
  120       WK(I,J) = S
  121    CONTINUE
C
         DO 131 J = 1,N
            DO 130 I = 1,N
  130       Z(I,J) = WK(I,J)
  131    CONTINUE
  140 CONTINUE
C
C            TAKE OUT THE EFFECT OF THE BALANCING
C                   OPERATION ON EXP(A)
C
  150 CALL BALINV (KZ,N,Z,LOW,IGH,WK(1,N+8))
      RETURN
C
C                     ERROR RETURN
C
  200 IERR = 1
      RETURN
  210 IERR = 2
      RETURN
      END
      SUBROUTINE DMEXP (A, KA, N, Z, KZ, WK, IERR)
      DOUBLE PRECISION A(KA,N),Z(KZ,N),WK(N,*)
      DOUBLE PRECISION ANORM,ANORM1,C(12),FACTOR,P,Q,S,S1
C ----------------------------------------------------------------------
C     DMEXP COMPUTES EXP(A) AND STORES IT IN Z WHERE A IS A MATRIX
C     OF ORDER N. A IS DESTROYED BY THE ROUTINE.
C
C     WK IS AN ARRAY OF DIMENSION (N,N+12). WK IS A WORK SPACE
C     FOR THE ROUTINE.
C
C     IERR IS A VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
C        IERR = 0  EXP(A) WAS SUCCESSFULLY COMPUTED.
C        IERR = 1  THE NORM OF A IS TOO LARGE.
C        IERR = 2  THE PADE DENOMINATOR MATRIX IS
C                  SINGULAR.
C
C     WRITTEN BY ALFRED H. MORRIS
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN VIRGINIA
C     ---------------
C     COEFFICIENTS FOR (12,12) PADE TABLE ENTRY
C     ---------------
      DATA C(1) /.500000000000000000000000000000D+00/,
     *     C(2) /.119565217391304347826086956522D+00/,
     *     C(3) /.181159420289855072463768115942D-01/,
     *     C(4) /.194099378881987577639751552795D-02/,
     *     C(5) /.155279503105590062111801242236D-03/,
     *     C(6) /.953470633104500381388253241800D-05/,
     *     C(7) /.454033634811666848280120591333D-06/,
     *     C(8) /.166924130445465753044161982108D-07/,
     *     C(9) /.463678140126293758456005505855D-09/
      DATA C(10)/.927356280252587516912011011710D-11/,
     *     C(11)/.120435880552284093105455975547D-12/,
     *     C(12)/.772024875335154442983692150941D-15/
C ----------------------------------------------------------------------
      IERR = 0
      IF (N .GT. 1) GO TO 10
         Z(1,1) = DEXP(A(1,1))
         RETURN
C
C       BALANCE A AND SELECT THE SMALLER OF THE 1-NORM
C              AND INFINITY-NORM OF THE RESULT
C
   10 CALL DBAL (KA,N,A,LOW,IGH,WK(1,N+12))
      ANORM = 0.D0
      ANORM1 = 0.D0
      DO 12 J = 1,N
      S = 0.D0
      S1 = 0.D0
         DO 11 I = 1,N
         S = S + DABS(A(J,I))
   11    S1 = S1 + DABS(A(I,J))
      ANORM = DMAX1(S,ANORM)
   12 ANORM1 = DMAX1(S1,ANORM1)
C
      ANORM = DMIN1(ANORM,ANORM1)
      S = ANORM + 0.1D0
      IF (S .EQ. ANORM) GO TO 200
C
C              SELECT THE NORMALIZATION FACTOR
C
      M = 0
      IF (ANORM .LE. 1.D0)  GO TO 40
      FACTOR = 1.D0
   20 M = M + 1
      FACTOR = 2.D0*FACTOR
      IF (ANORM .GT. FACTOR) GO TO 20
C
C                NORMALIZE THE MATRIX A
C
      DO 31 J = 1,N
         DO 30 I = 1,N
   30    A(I,J) = A(I,J)/FACTOR
   31 CONTINUE
C
   40 NP1 = N + 1
      NP10 = N + 10
      DO 100 J = 1,N
C
C     COMPUTE THE J-TH COLUMN OF THE FIRST 12 POWERS OF A
C
         DO 51 I = 1,N
         S = 0.D0
            DO 50 L = 1,N
   50       S = S + A(I,L)*A(L,J)
   51    WK(I,NP1) = S
C
         DO 70 K = NP1,NP10
         KP1 = K + 1
            DO 61 I = 1,N
            S = 0.D0
               DO 60 L = 1,N
   60          S = S + A(I,L)*WK(L,K)
   61       WK(I,KP1) = S
   70    CONTINUE
C
C     COMPUTE THE J-TH COLUMN OF THE NUMERATOR AND DENOMINATOR
C                  OF THE PADE APPROXIMATION
C
         DO 90 I = 1,N
         P = 0.D0
         Q = 0.D0
         K = 12
         L = N + 11
            DO 80 LL = 1,11
            S = C(K)*WK(I,L)
            P = S + P
            Q = S - Q
            K = K - 1
   80       L = L - 1
         S = C(1)*A(I,J)
         Z(I,J) = P + S
         WK(I,J) = Q - S
         IF (I .NE. J) GO TO 90
            Z(I,J) = Z(I,J) + 1.D0
            WK(I,J) = WK(I,J) + 1.D0
   90    CONTINUE
  100 CONTINUE
C
C        CALCULATE EXP(A) BY SOLVING  WK * EXP(A) = Z
C
      CALL DPSLV (N, N, WK, N, Z, KZ, IERR)
      IF (IERR .NE. 0) GO TO 210
      IF (M .EQ. 0)  GO TO 150
C
C          TAKE OUT THE EFFECT OF THE NORMALIZATION
C                   OPERATION ON EXP(A)
C
      DO 140 K = 1,M
         DO 121 J = 1,N
            DO 120 I = 1,N
            S = 0.D0
               DO 110 L = 1,N
  110          S = S + Z(I,L)*Z(L,J)
  120       WK(I,J) = S
  121    CONTINUE
C
         DO 131 J = 1,N
            DO 130 I = 1,N
  130       Z(I,J) = WK(I,J)
  131    CONTINUE
  140 CONTINUE
C
C            TAKE OUT THE EFFECT OF THE BALANCING
C                   OPERATION ON EXP(A)
C
  150 CALL DBALNV (KZ,N,Z,LOW,IGH,WK(1,N+12))
      RETURN
C
C                     ERROR RETURN
C
  200 IERR = 1
      RETURN
  210 IERR = 2
      RETURN
      END
      SUBROUTINE LE (ROWK,N,B,C,D,IP,IERR)
C     ******************************************************************
C     SOLUTION OF LINEAR EQUATIONS WITH REDUCED STORAGE
C     ******************************************************************
      REAL B(N),C(N),D(*)
      INTEGER IP(*)
      EXTERNAL ROWK
      DATA ZERO/0.0/
C
C     SET THE NECESSARY CONSTANTS
C
      IERR = 0
      NP1 = N + 1
      MAX = N*N/4 + N + 3
      K = 1
      IFLAG = -1
C
C     GET THE FIRST COLUMN OF THE TRANSPOSED SYSTEM
C
      CALL ROWK(N,1,C)
      BK = B(1)
C
      IF (N .GT. 1) GO TO 10
      IF (C(1) .EQ. ZERO) GO TO 200
      C(1) = BK/C(1)
      RETURN
C
C     FIND THE PIVOT FOR COLUMN 1
C
   10 M = 1
      DO 20 I = 2,N
      IF (ABS(C(M)) .LT. ABS(C(I))) M = I
   20 CONTINUE
C
      IP(1) = M
      C1 = C(M)
      C(M) = C(1)
      C(1) = C1
      IF (C(1) .EQ. ZERO) GO TO 200
C
C     FIND THE FIRST ELEMENTARY MATRIX AND STORE IT IN D
C
      DO 30 I = 2,N
   30 D(I-1) = -C(I)/C(1)
      D(N) = BK/C(1)
C
C     K LOOP - EACH K FOR A NEW COLUMN OF THE TRANSPOSED SYSTEM
C
      DO 120 K = 2,N
      KP1 = K + 1
      KM1 = K - 1
C
C       GET COLUMN K
C
      CALL ROWK(N,K,C)
      DO 40 J = 1,KM1
      M = IP(J)
      CJ = C(J)
      C(J) = C(M)
   40 C(M) = CJ
      BK = B(K)
C
      IFLAG = -IFLAG
      LCOL = NP1 - K
      LCOLP1 = LCOL + 1
      LASTM1 = 1
      LAST = MAX - N + K
      IF (K .EQ. 2) GO TO 50
C
      LASTM1 = MAX - N + KM1
      IF (IFLAG .LT. 0) LAST = LAST - N + K - 2
      IF (IFLAG .GT. 0) LASTM1 = LASTM1 - N + K - 3
C
C     J LOOP - EFFECT OF COLUMNS 1 TO K-1 OF L-INVERSE
C
   50 DO 61 J = 1,KM1
      CJ = C(J)
      IJ = (J-1)*LCOLP1
      IF (J .EQ. KM1) IJ = LASTM1 - 1
C
C     I LOOP - EFFECT OF L-INVERSE ON ROWS K TO N+1
C
      DO 60 I = K,N
      IJ = IJ + 1
   60 C(I) = C(I) + D(IJ)*CJ
   61 BK = BK - D(IJ+1)*CJ
C
C       K=N CASE
C
      M = K
      IF (K .LT. N) GO TO 70
      IF (C(K) .EQ. ZERO) GO TO 200
      D(LAST) = BK/C(K)
      GO TO 90
C
C     FIND THE PIVOT
C
   70 DO 71 I = KP1,N
      IF (ABS(C(M)) .LT. ABS(C(I))) M = I
   71 CONTINUE
C
      IP(K) = M
      CK = C(M)
      C(M) = C(K)
      C(K) = CK
      IF (C(K) .EQ. ZERO) GO TO 200
C
C     FIND THE K-TH ELEMENTARY MATRIX
C
      IK = LAST
      DO 80 I = KP1,N
      D(IK) = -C(I)/C(K)
   80 IK = IK + 1
      D(IK) = BK/C(K)
C
C     FORM THE PRODUCT OF THE ELEMENTARY MATRICES
C
   90 DO 110 J = 1,KM1
      KJOLD = J*LCOLP1 + K - NP1
      MJOLD = KJOLD + M - K
      IJ = (J-1)*LCOL
      IJOLD = IJ + J
      IF (J .NE. KM1) GO TO 100
C
      KJOLD = LASTM1
      MJOLD = LASTM1 + M - K
      IJOLD = LASTM1
C
  100 IK = LAST - 1
      DKJ = D(MJOLD)
      D(MJOLD) = D(KJOLD)
      DO 110 I = KP1,NP1
      IJ = IJ + 1
      IJOLD = IJOLD + 1
      IK = IK + 1
      D(IJ) = D(IJOLD) + D(IK)*DKJ
  110 CONTINUE
  120 CONTINUE
C
      LAST = MAX
      IF (IFLAG .LT. 0) LAST = MAX - 2
      D(N) = D(LAST)
C
C     INSERT THE SOLUTION IN C
C
      DO 130 I = 1,N
  130 C(I) = D(I)
C
      NM1 = N - 1
      DO 140 I = 1,NM1
      K = N - I
      M = IP(K)
      CK = C(K)
      C(K) = C(M)
  140 C(M) = CK
      RETURN
C
C     THE SYSTEM IS SINGULAR
C
  200 IERR = K
      RETURN
      END
      SUBROUTINE DPLE (ROWK,N,B,C,D,IP,IERR)
C     ******************************************************************
C     SOLUTION OF LINEAR EQUATIONS WITH REDUCED STORAGE
C     ******************************************************************
      DOUBLE PRECISION B(N),C(N),D(*)
      INTEGER IP(*)
      DOUBLE PRECISION BK,CJ,CK,C1,DKJ,ZERO
      EXTERNAL ROWK
      DATA ZERO/0.D0/
C
C     SET THE NECESSARY CONSTANTS
C
      IERR = 0
      NP1 = N + 1
      MAX = N*N/4 + N + 3
      K = 1
      IFLAG = -1
C
C     GET THE FIRST COLUMN OF THE TRANSPOSED SYSTEM
C
      CALL ROWK(N,1,C)
      BK = B(1)
C
      IF (N .GT. 1) GO TO 10
      IF (C(1) .EQ. ZERO) GO TO 200
      C(1) = BK/C(1)
      RETURN
C
C     FIND THE PIVOT FOR COLUMN 1
C
   10 M = 1
      DO 20 I = 2,N
      IF (DABS(C(M)) .LT. DABS(C(I))) M = I
   20 CONTINUE
C
      IP(1) = M
      C1 = C(M)
      C(M) = C(1)
      C(1) = C1
      IF (C(1) .EQ. ZERO) GO TO 200
C
C     FIND THE FIRST ELEMENTARY MATRIX AND STORE IT IN D
C
      DO 30 I = 2,N
   30 D(I-1) = -C(I)/C(1)
      D(N) = BK/C(1)
C
C     K LOOP - EACH K FOR A NEW COLUMN OF THE TRANSPOSED SYSTEM
C
      DO 120 K = 2,N
      KP1 = K + 1
      KM1 = K - 1
C
C       GET COLUMN K
C
      CALL ROWK(N,K,C)
      DO 40 J = 1,KM1
      M = IP(J)
      CJ = C(J)
      C(J) = C(M)
   40 C(M) = CJ
      BK = B(K)
C
      IFLAG = -IFLAG
      LCOL = NP1 - K
      LCOLP1 = LCOL + 1
      LASTM1 = 1
      LAST = MAX - N + K
      IF (K .EQ. 2) GO TO 50
C
      LASTM1 = MAX - N + KM1
      IF (IFLAG .LT. 0) LAST = LAST - N + K - 2
      IF (IFLAG .GT. 0) LASTM1 = LASTM1 - N + K - 3
C
C     J LOOP - EFFECT OF COLUMNS 1 TO K-1 OF L-INVERSE
C
   50 DO 61 J = 1,KM1
      CJ = C(J)
      IJ = (J-1)*LCOLP1
      IF (J .EQ. KM1) IJ = LASTM1 - 1
C
C     I LOOP - EFFECT OF L-INVERSE ON ROWS K TO N+1
C
      DO 60 I = K,N
      IJ = IJ + 1
   60 C(I) = C(I) + D(IJ)*CJ
   61 BK = BK - D(IJ+1)*CJ
C
C       K=N CASE
C
      M = K
      IF (K .LT. N) GO TO 70
      IF (C(K) .EQ. ZERO) GO TO 200
      D(LAST) = BK/C(K)
      GO TO 90
C
C     FIND THE PIVOT
C
   70 DO 71 I = KP1,N
      IF (DABS(C(M)) .LT. DABS(C(I))) M = I
   71 CONTINUE
C
      IP(K) = M
      CK = C(M)
      C(M) = C(K)
      C(K) = CK
      IF (C(K) .EQ. ZERO) GO TO 200
C
C     FIND THE K-TH ELEMENTARY MATRIX
C
      IK = LAST
      DO 80 I = KP1,N
      D(IK) = -C(I)/C(K)
   80 IK = IK + 1
      D(IK) = BK/C(K)
C
C     FORM THE PRODUCT OF THE ELEMENTARY MATRICES
C
   90 DO 110 J = 1,KM1
      KJOLD = J*LCOLP1 + K - NP1
      MJOLD = KJOLD + M - K
      IJ = (J-1)*LCOL
      IJOLD = IJ + J
      IF (J .NE. KM1) GO TO 100
C
      KJOLD = LASTM1
      MJOLD = LASTM1 + M - K
      IJOLD = LASTM1
C
  100 IK = LAST - 1
      DKJ = D(MJOLD)
      D(MJOLD) = D(KJOLD)
      DO 110 I = KP1,NP1
      IJ = IJ + 1
      IJOLD = IJOLD + 1
      IK = IK + 1
      D(IJ) = D(IJOLD) + D(IK)*DKJ
  110 CONTINUE
  120 CONTINUE
C
      LAST = MAX
      IF (IFLAG .LT. 0) LAST = MAX - 2
      D(N) = D(LAST)
C
C     INSERT THE SOLUTION IN C
C
      DO 130 I = 1,N
  130 C(I) = D(I)
C
      NM1 = N - 1
      DO 140 I = 1,NM1
      K = N - I
      M = IP(K)
      CK = C(K)
      C(K) = C(M)
  140 C(M) = CK
      RETURN
C
C     THE SYSTEM IS SINGULAR
C
  200 IERR = K
      RETURN
      END
      SUBROUTINE CLE (ROWK,N,B,C,D,IP,IERR)
C     ******************************************************************
C     SOLUTION OF COMPLEX LINEAR EQUATIONS WITH REDUCED STORAGE
C     ******************************************************************
      COMPLEX B(N),C(N),D(*)
      INTEGER IP(*)
      COMPLEX BK,CJ,CK,C1,DKJ,ZERO
      EXTERNAL ROWK
      DATA ZERO/(0.0,0.0)/
C
C     SET THE NECESSARY CONSTANTS
C
      IERR = 0
      NP1 = N + 1
      MAX = N*N/4 + N + 3
      K = 1
      IFLAG = -1
C
C     GET THE FIRST COLUMN OF THE TRANSPOSED SYSTEM
C
      CALL ROWK(N,1,C)
      BK = B(1)
C
      IF (N .GT. 1) GO TO 10
      IF (C(1) .EQ. ZERO) GO TO 200
      C(1) = BK/C(1)
      RETURN
C
C     FIND THE PIVOT FOR COLUMN 1
C
   10 M = 1
      S = ABS(REAL(C(1))) + ABS(AIMAG(C(1)))
      DO 20 I = 2,N
      SI = ABS(REAL(C(I))) + ABS(AIMAG(C(I)))
      IF (SI .LE. S) GO TO 20
      M = I
      S = SI
   20 CONTINUE
C
      IP(1) = M
      C1 = C(M)
      C(M) = C(1)
      C(1) = C1
      IF (C(1) .EQ. ZERO) GO TO 200
C
C     FIND THE FIRST ELEMENTARY MATRIX AND STORE IT IN D
C
      DO 30 I = 2,N
   30 D(I-1) = -C(I)/C(1)
      D(N) = BK/C(1)
C
C     K LOOP - EACH K FOR A NEW COLUMN OF THE TRANSPOSED SYSTEM
C
      DO 120 K = 2,N
      KP1 = K + 1
      KM1 = K - 1
C
C       GET COLUMN K
C
      CALL ROWK(N,K,C)
      DO 40 J = 1,KM1
      M = IP(J)
      CJ = C(J)
      C(J) = C(M)
   40 C(M) = CJ
      BK = B(K)
C
      IFLAG = -IFLAG
      LCOL = NP1 - K
      LCOLP1 = LCOL + 1
      LASTM1 = 1
      LAST = MAX - N + K
      IF (K .EQ. 2) GO TO 50
C
      LASTM1 = MAX - N + KM1
      IF (IFLAG .LT. 0) LAST = LAST - N + K - 2
      IF (IFLAG .GT. 0) LASTM1 = LASTM1 - N + K - 3
C
C     J LOOP - EFFECT OF COLUMNS 1 TO K-1 OF L-INVERSE
C
   50 DO 61 J = 1,KM1
      CJ = C(J)
      IJ = (J-1)*LCOLP1
      IF (J .EQ. KM1) IJ = LASTM1 - 1
C
C     I LOOP - EFFECT OF L-INVERSE ON ROWS K TO N+1
C
      DO 60 I = K,N
      IJ = IJ + 1
   60 C(I) = C(I) + D(IJ)*CJ
   61 BK = BK - D(IJ+1)*CJ
C
C       K=N CASE
C
      M = K
      IF (K .LT. N) GO TO 70
      IF (C(K) .EQ. ZERO) GO TO 200
      D(LAST) = BK/C(K)
      GO TO 90
C
C     FIND THE PIVOT
C
   70 S = ABS(REAL(C(K))) + ABS(AIMAG(C(K)))
      DO 71 I = KP1,N
      SI = ABS(REAL(C(I))) + ABS(AIMAG(C(I)))
      IF (SI .LE. S) GO TO 71
      M = I
      S = SI
   71 CONTINUE
C
      IP(K) = M
      CK = C(M)
      C(M) = C(K)
      C(K) = CK
      IF (C(K) .EQ. ZERO) GO TO 200
C
C     FIND THE K-TH ELEMENTARY MATRIX
C
      IK = LAST
      DO 80 I = KP1,N
      D(IK) = -C(I)/C(K)
   80 IK = IK + 1
      D(IK) = BK/C(K)
C
C     FORM THE PRODUCT OF THE ELEMENTARY MATRICES
C
   90 DO 110 J = 1,KM1
      KJOLD = J*LCOLP1 + K - NP1
      MJOLD = KJOLD + M - K
      IJ = (J-1)*LCOL
      IJOLD = IJ + J
      IF (J .NE. KM1) GO TO 100
C
      KJOLD = LASTM1
      MJOLD = LASTM1 + M - K
      IJOLD = LASTM1
C
  100 IK = LAST - 1
      DKJ = D(MJOLD)
      D(MJOLD) = D(KJOLD)
      DO 110 I = KP1,NP1
      IJ = IJ + 1
      IJOLD = IJOLD + 1
      IK = IK + 1
      D(IJ) = D(IJOLD) + D(IK)*DKJ
  110 CONTINUE
  120 CONTINUE
C
      LAST = MAX
      IF (IFLAG .LT. 0) LAST = MAX - 2
      D(N) = D(LAST)
C
C     INSERT THE SOLUTION IN C
C
      DO 130 I = 1,N
  130 C(I) = D(I)
C
      NM1 = N - 1
      DO 140 I = 1,NM1
      K = N - I
      M = IP(K)
      CK = C(K)
      C(K) = C(M)
  140 C(M) = CK
      RETURN
C
C     THE SYSTEM IS SINGULAR
C
  200 IERR = K
      RETURN
      END
      SUBROUTINE CVBR (B,KB,M,N,ML,MU,A,KA)
C-----------------------------------------------------------------------
C           CONVERSION OF REAL MATRICES FROM BANDED TO
C                         STANDARD FORM
C-----------------------------------------------------------------------
      REAL A(KA,N), B(KB,*)
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      IF (ML .EQ. 0) GO TO 20
      DO 11 I = 1,ML
         JMAX = MIN0(N,I + MU)
         K = ML + 1 - I
         DO 10 J = 1,JMAX
            K = K + 1
   10       A(I,J) = B(I,K)
   11 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   20 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      L = 0
      DO 22 I = IMIN,IMAX
         JMIN = I - ML
         JMAX = MIN0(N,I + MU)
         J = JMAX
         DO 21 JJ = JMIN,JMAX
            K = J - L
            A(I,J) = B(I,K)
   21       J = J - 1
         L = L + 1
   22 CONTINUE
C
C     INSERT ZEROS IN THE UPPER RIGHT CORNER
C
      JMIN = MU + 2
      IF (JMIN .GT. N) GO TO 40
      IMAX0 = 1
      DO 31 J = JMIN,N
         DO 30 I = 1,IMAX0
   30       A(I,J) = 0.0
         IMAX0 = MIN0(IMAX,IMAX0 + 1)
   31 CONTINUE
C
C     INSERT ZEROS IN THE LOWER LEFT CORNER
C
   40 IF (IMIN .EQ. IMAX) GO TO 50
      JMAX = IMAX - IMIN
      DO 42 J = 1,JMAX
         IMIN = IMIN + 1
         DO 41 I = IMIN,IMAX
   41       A(I,J) = 0.0
   42 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX ROWS
C
   50 IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 52 J = 1,N
         DO 51 I = IMIN,M
   51       A(I,J) = 0.0
   52 CONTINUE
      RETURN
      END
      SUBROUTINE CVRB (A,KA,M,N,ML,MU,B,KB)
C-----------------------------------------------------------------------
C        CONVERSION OF REAL MATRICES FROM STANDARD TO BANDED
C                    FORM WHEN ML AND MU ARE GIVEN
C-----------------------------------------------------------------------
      REAL A(KA,N), B(KB,*)
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      IF (ML .EQ. 0) GO TO 30
      L = ML
      DO 11 I = 1,ML
         JMAX = MIN0(N,I + MU)
         J = JMAX
         DO 10 JJ = 1,JMAX
            K = J + L
            B(I,K) = A(I,J)
   10       J = J - 1
         L = L - 1
   11 CONTINUE
C
C     INSERT ZEROS IN THE UPPER LEFT CORNER
C
      IMAX = ML
      DO 21 J = 1,ML
         DO 20 I = 1,IMAX
   20       B(I,J) = 0.0
         IMAX = IMAX - 1
   21 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   30 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      DO 32 I = IMIN,IMAX
         JMIN = I - ML
         JMAX = MIN0(N,I + MU)
         K = 0
         DO 31 J = JMIN,JMAX
            K = K + 1
   31       B(I,K) = A(I,J)
   32 CONTINUE
C
C     INSERT ZEROS IN THE LOWER RIGHT CORNER
C
      JMAX = ML + MU + 1
      IF (K .EQ. JMAX) GO TO 50
      JMIN = K + 1
      IMIN = IMAX
      DO 41 J = JMIN,JMAX
         DO 40 I = IMIN,IMAX
   40       B(I,J) = 0.0
         IMIN = IMIN - 1
   41 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX ROWS
C
   50 IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 52 J = 1,JMAX
         DO 51 I = IMIN,M
   51       B(I,J) = 0.0
   52 CONTINUE
      RETURN
      END
      SUBROUTINE CVRB1 (A,KA,M,N,ML,MU,B,KB,NB,IERR)
C-----------------------------------------------------------------------
C           CONVERSION OF REAL MATRICES FROM STANDARD
C                        TO BANDED FORM
C-----------------------------------------------------------------------
      REAL A(KA,N), B(KB,NB)
C
C     COMPUTATION OF ML AND MU
C
      NM1 = N - 1
      IMIN = M
      IF (M .EQ. 1) GO TO 20
      DO 11 L = 2,M
         J = 1
         IMAX = MIN0(M,IMIN + NM1)
         DO 10 I = IMIN,IMAX
            IF (A(I,J) .NE. 0.0) GO TO 20
   10       J = J + 1
         IMIN = IMIN - 1
   11 CONTINUE
C
   20 MM1 = M - 1
      JMIN = N
      IF (N .EQ. 1) GO TO 30
      DO 22 L = 2,N
         I = 1
         JMAX = MIN0(N,JMIN + MM1)
         DO 21 J = JMIN,JMAX
            IF (A(I,J) .NE. 0.0) GO TO 30
   21       I = I + 1
         JMIN = JMIN - 1
   22 CONTINUE
C
   30 ML = IMIN - 1
      MU = JMIN - 1
      KMAX = ML + MU + 1
      IF (KMAX .GT. NB) GO TO 40
C
C     STORE THE MATRIX IN B
C
      IERR = 0
      CALL CVRB (A,KA,M,N,ML,MU,B,KB)
      RETURN
C
C     ERROR RETURN
C
   40 IERR = KMAX
      RETURN
      END
      SUBROUTINE CVBD (B,KB,M,N,ML,MU,A,KA)
C-----------------------------------------------------------------------
C        CONVERSION OF DOUBLE PRECISION MATRICES FROM BANDED
C                         TO STANDARD FORM
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,N), B(KB,*)
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      IF (ML .EQ. 0) GO TO 20
      DO 11 I = 1,ML
         JMAX = MIN0(N,I + MU)
         K = ML + 1 - I
         DO 10 J = 1,JMAX
            K = K + 1
   10       A(I,J) = B(I,K)
   11 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   20 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      L = 0
      DO 22 I = IMIN,IMAX
         JMIN = I - ML
         JMAX = MIN0(N,I + MU)
         J = JMAX
         DO 21 JJ = JMIN,JMAX
            K = J - L
            A(I,J) = B(I,K)
   21       J = J - 1
         L = L + 1
   22 CONTINUE
C
C     INSERT ZEROS IN THE UPPER RIGHT CORNER
C
      JMIN = MU + 2
      IF (JMIN .GT. N) GO TO 40
      IMAX0 = 1
      DO 31 J = JMIN,N
         DO 30 I = 1,IMAX0
   30       A(I,J) = 0.D0
         IMAX0 = MIN0(IMAX,IMAX0 + 1)
   31 CONTINUE
C
C     INSERT ZEROS IN THE LOWER LEFT CORNER
C
   40 IF (IMIN .EQ. IMAX) GO TO 50
      JMAX = IMAX - IMIN
      DO 42 J = 1,JMAX
         IMIN = IMIN + 1
         DO 41 I = IMIN,IMAX
   41       A(I,J) = 0.D0
   42 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX ROWS
C
   50 IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 52 J = 1,N
         DO 51 I = IMIN,M
   51       A(I,J) = 0.D0
   52 CONTINUE
      RETURN
      END
      SUBROUTINE CVDB (A,KA,M,N,ML,MU,B,KB)
C-----------------------------------------------------------------------
C        CONVERSION OF DOUBLE PRECISION MATRICES FROM STANDARD
C               TO BANDED FORM WHEN ML AND MU ARE GIVEN
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,N), B(KB,*)
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      IF (ML .EQ. 0) GO TO 30
      L = ML
      DO 11 I = 1,ML
         JMAX = MIN0(N,I + MU)
         J = JMAX
         DO 10 JJ = 1,JMAX
            K = J + L
            B(I,K) = A(I,J)
   10       J = J - 1
         L = L - 1
   11 CONTINUE
C
C     INSERT ZEROS IN THE UPPER LEFT CORNER
C
      IMAX = ML
      DO 21 J = 1,ML
         DO 20 I = 1,IMAX
   20       B(I,J) = 0.D0
         IMAX = IMAX - 1
   21 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   30 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      DO 32 I = IMIN,IMAX
         JMIN = I - ML
         JMAX = MIN0(N,I + MU)
         K = 0
         DO 31 J = JMIN,JMAX
            K = K + 1
   31       B(I,K) = A(I,J)
   32 CONTINUE
C
C     INSERT ZEROS IN THE LOWER RIGHT CORNER
C
      JMAX = ML + MU + 1
      IF (K .EQ. JMAX) GO TO 50
      JMIN = K + 1
      IMIN = IMAX
      DO 41 J = JMIN,JMAX
         DO 40 I = IMIN,IMAX
   40       B(I,J) = 0.D0
         IMIN = IMIN - 1
   41 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX ROWS
C
   50 IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 52 J = 1,JMAX
         DO 51 I = IMIN,M
   51       B(I,J) = 0.D0
   52 CONTINUE
      RETURN
      END
      SUBROUTINE CVDB1 (A,KA,M,N,ML,MU,B,KB,NB,IERR)
C-----------------------------------------------------------------------
C        CONVERSION OF DOUBLE PRECISION MATRICES FROM STANDARD
C                         TO BANDED FORM
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,N), B(KB,NB)
C
C     COMPUTATION OF ML AND MU
C
      NM1 = N - 1
      IMIN = M
      IF (M .EQ. 1) GO TO 20
      DO 11 L = 2,M
         J = 1
         IMAX = MIN0(M,IMIN + NM1)
         DO 10 I = IMIN,IMAX
            IF (A(I,J) .NE. 0.D0) GO TO 20
   10       J = J + 1
         IMIN = IMIN - 1
   11 CONTINUE
C
   20 MM1 = M - 1
      JMIN = N
      IF (N .EQ. 1) GO TO 30
      DO 22 L = 2,N
         I = 1
         JMAX = MIN0(N,JMIN + MM1)
         DO 21 J = JMIN,JMAX
            IF (A(I,J) .NE. 0.D0) GO TO 30
   21       I = I + 1
         JMIN = JMIN - 1
   22 CONTINUE
C
   30 ML = IMIN - 1
      MU = JMIN - 1
      KMAX = ML + MU + 1
      IF (KMAX .GT. NB) GO TO 40
C
C     STORE THE MATRIX IN B
C
      IERR = 0
      CALL CVDB (A,KA,M,N,ML,MU,B,KB)
      RETURN
C
C     ERROR RETURN
C
   40 IERR = KMAX
      RETURN
      END
      SUBROUTINE CVBC (B,KB,M,N,ML,MU,A,KA)
C-----------------------------------------------------------------------
C          CONVERSION OF COMPLEX MATRICES FROM BANDED TO
C                          STANDARD FORM
C-----------------------------------------------------------------------
      COMPLEX A(KA,N), B(KB,*)
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      IF (ML .EQ. 0) GO TO 20
      DO 11 I = 1,ML
         JMAX = MIN0(N,I + MU)
         K = ML + 1 - I
         DO 10 J = 1,JMAX
            K = K + 1
   10       A(I,J) = B(I,K)
   11 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   20 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      L = 0
      DO 22 I = IMIN,IMAX
         JMIN = I - ML
         JMAX = MIN0(N,I + MU)
         J = JMAX
         DO 21 JJ = JMIN,JMAX
            K = J - L
            A(I,J) = B(I,K)
   21       J = J - 1
         L = L + 1
   22 CONTINUE
C
C     INSERT ZEROS IN THE UPPER RIGHT CORNER
C
      JMIN = MU + 2
      IF (JMIN .GT. N) GO TO 40
      IMAX0 = 1
      DO 31 J = JMIN,N
         DO 30 I = 1,IMAX0
   30       A(I,J) = (0.0,0.0)
         IMAX0 = MIN0(IMAX,IMAX0 + 1)
   31 CONTINUE
C
C     INSERT ZEROS IN THE LOWER LEFT CORNER
C
   40 IF (IMIN .EQ. IMAX) GO TO 50
      JMAX = IMAX - IMIN
      DO 42 J = 1,JMAX
         IMIN = IMIN + 1
         DO 41 I = IMIN,IMAX
   41       A(I,J) = (0.0,0.0)
   42 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX ROWS
C
   50 IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 52 J = 1,N
         DO 51 I = IMIN,M
   51       A(I,J) = (0.0,0.0)
   52 CONTINUE
      RETURN
      END
      SUBROUTINE CVCB (A,KA,M,N,ML,MU,B,KB)
C-----------------------------------------------------------------------
C        CONVERSION OF COMPLEX MATRICES FROM STANDARD TO BANDED
C                    FORM WHEN ML AND MU ARE GIVEN
C-----------------------------------------------------------------------
      COMPLEX A(KA,N), B(KB,*)
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      IF (ML .EQ. 0) GO TO 30
      L = ML
      DO 11 I = 1,ML
         JMAX = MIN0(N,I + MU)
         J = JMAX
         DO 10 JJ = 1,JMAX
            K = J + L
            B(I,K) = A(I,J)
   10       J = J - 1
         L = L - 1
   11 CONTINUE
C
C     INSERT ZEROS IN THE UPPER LEFT CORNER
C
      IMAX = ML
      DO 21 J = 1,ML
         DO 20 I = 1,IMAX
   20       B(I,J) = (0.0,0.0)
         IMAX = IMAX - 1
   21 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   30 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      DO 32 I = IMIN,IMAX
         JMIN = I - ML
         JMAX = MIN0(N,I + MU)
         K = 0
         DO 31 J = JMIN,JMAX
            K = K + 1
   31       B(I,K) = A(I,J)
   32 CONTINUE
C
C     INSERT ZEROS IN THE LOWER RIGHT CORNER
C
      JMAX = ML + MU + 1
      IF (K .EQ. JMAX) GO TO 50
      JMIN = K + 1
      IMIN = IMAX
      DO 41 J = JMIN,JMAX
         DO 40 I = IMIN,IMAX
   40       B(I,J) = (0.0,0.0)
         IMIN = IMIN - 1
   41 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX ROWS
C
   50 IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 52 J = 1,JMAX
         DO 51 I = IMIN,M
   51       B(I,J) = (0.0,0.0)
   52 CONTINUE
      RETURN
      END
      SUBROUTINE CVCB1 (A,KA,M,N,ML,MU,B,KB,NB,IERR)
C-----------------------------------------------------------------------
C           CONVERSION OF COMPLEX MATRICES FROM STANDARD
C                          TO BANDED FORM
C-----------------------------------------------------------------------
      COMPLEX A(KA,N), B(KB,NB)
C
C     COMPUTATION OF ML AND MU
C
      NM1 = N - 1
      IMIN = M
      IF (M .EQ. 1) GO TO 20
      DO 11 L = 2,M
         J = 1
         IMAX = MIN0(M,IMIN + NM1)
         DO 10 I = IMIN,IMAX
            IF (A(I,J) .NE. (0.0,0.0)) GO TO 20
   10       J = J + 1
         IMIN = IMIN - 1
   11 CONTINUE
C
   20 MM1 = M - 1
      JMIN = N
      IF (N .EQ. 1) GO TO 30
      DO 22 L = 2,N
         I = 1
         JMAX = MIN0(N,JMIN + MM1)
         DO 21 J = JMIN,JMAX
            IF (A(I,J) .NE. (0.0,0.0)) GO TO 30
   21       I = I + 1
         JMIN = JMIN - 1
   22 CONTINUE
C
   30 ML = IMIN - 1
      MU = JMIN - 1
      KMAX = ML + MU + 1
      IF (KMAX .GT. NB) GO TO 40
C
C     STORE THE MATRIX IN B
C
      IERR = 0
      CALL CVCB (A,KA,M,N,ML,MU,B,KB)
      RETURN
C
C     ERROR RETURN
C
   40 IERR = KMAX
      RETURN
      END
      SUBROUTINE MCVBS (A,KA,M,N,ML,MU,B,IB,JB,NUM,IERR)
C-----------------------------------------------------------------------
C                CONVERSION OF REAL MATRICES FROM BANDED
C                            TO SPARSE FORM
C-----------------------------------------------------------------------
      REAL A(KA,*), B(*)
      INTEGER IB(*), JB(*)
C
      L = 1
      KMAX = ML + MU + 1
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      J0 = ML
      IF (ML .EQ. 0) GO TO 20
      DO 11 I = 1,ML
         IB(I) = L
         KMIN = 1 + J0
         DO 10 K = KMIN,KMAX
            IF (A(I,K) .EQ. 0.0) GO TO 10
            IF (L .GT. NUM) GO TO 40
            B(L) = A(I,K)
            JB(L) = K - J0
            L = L + 1
   10    CONTINUE
         J0 = J0 - 1
   11 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   20 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      DO 22 I = IMIN,IMAX
         IB(I) = L
         DO 21 K = 1,KMAX
            IF (A(I,K) .EQ. 0.0) GO TO 21
            IF (L .GT. NUM) GO TO 40
            B(L) = A(I,K)
            JB(L) = K - J0
            L = L + 1
   21    CONTINUE
         J0 = J0 - 1
   22 CONTINUE
      IERR = 0
C
C     SET UP THE REMAINING M-IMAX ROWS
C
      IMIN = IMAX + 1
      MP1 = M + 1
      DO 30 I = IMIN,MP1
         IB(I) = L
   30 CONTINUE
      RETURN
C
C     ERROR RETURN
C
   40 IERR = I
      RETURN
      END
      SUBROUTINE DMCVBS (A,KA,M,N,ML,MU,B,IB,JB,NUM,IERR)
C-----------------------------------------------------------------------
C          CONVERSION OF DOUBLE PRECISION MATRICES FROM BANDED
C                            TO SPARSE FORM
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), B(*)
      INTEGER IB(*), JB(*)
C
      L = 1
      KMAX = ML + MU + 1
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      J0 = ML
      IF (ML .EQ. 0) GO TO 20
      DO 11 I = 1,ML
         IB(I) = L
         KMIN = 1 + J0
         DO 10 K = KMIN,KMAX
            IF (A(I,K) .EQ. 0.D0) GO TO 10
            IF (L .GT. NUM) GO TO 40
            B(L) = A(I,K)
            JB(L) = K - J0
            L = L + 1
   10    CONTINUE
         J0 = J0 - 1
   11 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   20 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      DO 22 I = IMIN,IMAX
         IB(I) = L
         DO 21 K = 1,KMAX
            IF (A(I,K) .EQ. 0.D0) GO TO 21
            IF (L .GT. NUM) GO TO 40
            B(L) = A(I,K)
            JB(L) = K - J0
            L = L + 1
   21    CONTINUE
         J0 = J0 - 1
   22 CONTINUE
      IERR = 0
C
C     SET UP THE REMAINING M-IMAX ROWS
C
      IMIN = IMAX + 1
      MP1 = M + 1
      DO 30 I = IMIN,MP1
         IB(I) = L
   30 CONTINUE
      RETURN
C
C     ERROR RETURN
C
   40 IERR = I
      RETURN
      END
      SUBROUTINE CMCVBS (A,KA,M,N,ML,MU,B,IB,JB,NUM,IERR)
C-----------------------------------------------------------------------
C              CONVERSION OF COMPLEX MATRICES FROM BANDED
C                            TO SPARSE FORM
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), B(*)
      INTEGER IB(*), JB(*)
C
      L = 1
      KMAX = ML + MU + 1
C
C     STORE THE NONZERO DATA OF THE FIRST ML ROWS
C
      J0 = ML
      IF (ML .EQ. 0) GO TO 20
      DO 11 I = 1,ML
         IB(I) = L
         KMIN = 1 + J0
         DO 10 K = KMIN,KMAX
            IF (A(I,K) .EQ. (0.0,0.0)) GO TO 10
            IF (L .GT. NUM) GO TO 40
            B(L) = A(I,K)
            JB(L) = K - J0
            L = L + 1
   10    CONTINUE
         J0 = J0 - 1
   11 CONTINUE
C
C     STORE THE REMAINING NONZERO DATA
C
   20 IMIN = ML + 1
      IMAX = MIN0(M,ML + N)
      DO 22 I = IMIN,IMAX
         IB(I) = L
         DO 21 K = 1,KMAX
            IF (A(I,K) .EQ. (0.0,0.0)) GO TO 21
            IF (L .GT. NUM) GO TO 40
            B(L) = A(I,K)
            JB(L) = K - J0
            L = L + 1
   21    CONTINUE
         J0 = J0 - 1
   22 CONTINUE
      IERR = 0
C
C     SET UP THE REMAINING M-IMAX ROWS
C
      IMIN = IMAX + 1
      MP1 = M + 1
      DO 30 I = IMIN,MP1
         IB(I) = L
   30 CONTINUE
      RETURN
C
C     ERROR RETURN
C
   40 IERR = I
      RETURN
      END
      SUBROUTINE MCVSB (A,IA,JA,M,N,B,KB,NB,ML,MU,IERR)
C-----------------------------------------------------------------------
C                CONVERSION OF REAL MATRICES FROM SPARSE
C                            TO BANDED FORM
C-----------------------------------------------------------------------
      REAL A(*), B(KB,NB)
      INTEGER IA(*), JA(*)
C
C     COMPUTATION OF ML AND MU
C
      ML = 0
      MU = 0
      DO 11 I = 1,M
         LMIN = IA(I)
         LMAX = IA(I + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            IF (A(L) .EQ. 0.0) GO TO 10
            K = JA(L) - I
            MU = MAX0(MU,K)
            ML = MAX0(ML,-K)
   10    CONTINUE
   11 CONTINUE
C
C     SET B = 0 IF B PROVIDES SUFFICIENT STORAGE
C
      KMAX = ML + MU + 1
      IF (KMAX .GT. NB) GO TO 40
C
      IERR = 0
      DO 21 K = 1,KMAX
         DO 20 I = 1,M
   20       B(I,K) = 0.0
   21 CONTINUE
C
C     STORE THE MATRIX IN B
C
      J0 = ML
      DO 31 I = 1,M
         LMIN = IA(I)
         LMAX = IA(I + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 31
         DO 30 L = LMIN,LMAX
            IF (A(L) .EQ. 0.0) GO TO 30
            K = JA(L) + J0
            B(I,K) = A(L)
   30    CONTINUE
         J0 = J0 - 1
   31 CONTINUE
      RETURN
C
C     ERROR RETURN
C
   40 IERR = KMAX
      RETURN
      END
      SUBROUTINE DMCVSB (A,IA,JA,M,N,B,KB,NB,ML,MU,IERR)
C-----------------------------------------------------------------------
C          CONVERSION OF DOUBLE PRECISION MATRICES FROM SPARSE
C                            TO BANDED FORM
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(KB,NB)
      INTEGER IA(*), JA(*)
C
C     COMPUTATION OF ML AND MU
C
      ML = 0
      MU = 0
      DO 11 I = 1,M
         LMIN = IA(I)
         LMAX = IA(I + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            IF (A(L) .EQ. 0.D0) GO TO 10
            K = JA(L) - I
            MU = MAX0(MU,K)
            ML = MAX0(ML,-K)
   10    CONTINUE
   11 CONTINUE
C
C     SET B = 0 IF B PROVIDES SUFFICIENT STORAGE
C
      KMAX = ML + MU + 1
      IF (KMAX .GT. NB) GO TO 40
C
      IERR = 0
      DO 21 K = 1,KMAX
         DO 20 I = 1,M
   20       B(I,K) = 0.D0
   21 CONTINUE
C
C     STORE THE MATRIX IN B
C
      J0 = ML
      DO 31 I = 1,M
         LMIN = IA(I)
         LMAX = IA(I + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 31
         DO 30 L = LMIN,LMAX
            IF (A(L) .EQ. 0.D0) GO TO 30
            K = JA(L) + J0
            B(I,K) = A(L)
   30    CONTINUE
         J0 = J0 - 1
   31 CONTINUE
      RETURN
C
C     ERROR RETURN
C
   40 IERR = KMAX
      RETURN
      END
      SUBROUTINE CMCVSB (A,IA,JA,M,N,B,KB,NB,ML,MU,IERR)
C-----------------------------------------------------------------------
C              CONVERSION OF COMPLEX MATRICES FROM SPARSE
C                            TO BANDED FORM
C-----------------------------------------------------------------------
      COMPLEX A(*), B(KB,NB)
      INTEGER IA(*), JA(*)
C
C     COMPUTATION OF ML AND MU
C
      ML = 0
      MU = 0
      DO 11 I = 1,M
         LMIN = IA(I)
         LMAX = IA(I + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            IF (A(L) .EQ. (0.0,0.0)) GO TO 10
            K = JA(L) - I
            MU = MAX0(MU,K)
            ML = MAX0(ML,-K)
   10    CONTINUE
   11 CONTINUE
C
C     SET B = 0 IF B PROVIDES SUFFICIENT STORAGE
C
      KMAX = ML + MU + 1
      IF (KMAX .GT. NB) GO TO 40
C
      IERR = 0
      DO 21 K = 1,KMAX
         DO 20 I = 1,M
   20       B(I,K) = (0.0,0.0)
   21 CONTINUE
C
C     STORE THE MATRIX IN B
C
      J0 = ML
      DO 31 I = 1,M
         LMIN = IA(I)
         LMAX = IA(I + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 31
         DO 30 L = LMIN,LMAX
            IF (A(L) .EQ. (0.0,0.0)) GO TO 30
            K = JA(L) + J0
            B(I,K) = A(L)
   30    CONTINUE
         J0 = J0 - 1
   31 CONTINUE
      RETURN
C
C     ERROR RETURN
C
   40 IERR = KMAX
      RETURN
      END
      SUBROUTINE BCVRD (A, KA, M, N, ML, MU, B, KB)
C-----------------------------------------------------------------------
C        CONVERSION OF BANDED MATRICES FROM SINGLE TO DOUBLE
C                          PRECISION FORM
C-----------------------------------------------------------------------
      REAL A(KA,*)
      DOUBLE PRECISION B(KB,*)
C
      NUM = ML + MU + 1
      DO 20 J = 1,NUM
         DO 10 I = 1,M
            B(I,J) = A(I,J)
   10    CONTINUE
   20 CONTINUE
      RETURN
      END
      SUBROUTINE BCVDR (A, KA, M, N, ML, MU, B, KB)
C-----------------------------------------------------------------------
C        CONVERSION OF BANDED MATRICES FROM DOUBLE TO SINGLE
C                          PRECISION FORM
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*)
      REAL B(KB,*)
C
      NUM = ML + MU + 1
      DO 20 J = 1,NUM
         DO 10 I = 1,M
            B(I,J) = A(I,J)
   10    CONTINUE
   20 CONTINUE
      RETURN
      END
      SUBROUTINE BREAL (A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR)
C-----------------------------------------------------------------------
C              REAL PART OF A BANDED COMPLEX MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(KA,*)
      REAL B(KB,L)
C
C     COMPUTATION OF NL AND NU
C
      NL = ML
      IF (ML .EQ. 0) GO TO 30
      IMIN = ML + 1
      DO 20 J = 1,ML
         DO 10 I = IMIN,M
            IF (REAL(A(I,J)) .NE. 0.0) GO TO 30
   10    CONTINUE
         NL = NL - 1
         IMIN = IMIN - 1
   20 CONTINUE
C
   30 NU = MU
      IF (MU .EQ. 0) GO TO 60
      J = ML + MU + 1
      DO 50 K = 1,MU
         DO 40 I = 1,M
            IF (REAL(A(I,J)) .NE. 0.0) GO TO 60
   40    CONTINUE
         NU = NU - 1
         J = J - 1
   50 CONTINUE
C
C     STORE THE REAL PART OF A IN B
C
   60 NUM = NL + NU + 1
      IF (NUM .GT. L) GO TO 100
      IERR = 0
      K = ML - NL
      DO 80 J = 1,NUM
         K = K + 1
         DO 70 I = 1,M
            B(I,J) = REAL(A(I,K))
   70    CONTINUE
   80 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  100 IERR = NUM
      RETURN
      END
      SUBROUTINE BIMAG (A, KA, M, N, ML, MU, B, KB, L, NL, NU, IERR)
C-----------------------------------------------------------------------
C            IMAGINARY PART OF A BANDED COMPLEX MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(KA,*)
      REAL B(KB,L)
C
C     COMPUTATION OF NL AND NU
C
      NL = ML
      IF (ML .EQ. 0) GO TO 30
      IMIN = ML + 1
      DO 20 J = 1,ML
         DO 10 I = IMIN,M
            IF (AIMAG(A(I,J)) .NE. 0.0) GO TO 30
   10    CONTINUE
         NL = NL - 1
         IMIN = IMIN - 1
   20 CONTINUE
C
   30 NU = MU
      IF (MU .EQ. 0) GO TO 60
      J = ML + MU + 1
      DO 50 K = 1,MU
         DO 40 I = 1,M
            IF (AIMAG(A(I,J)) .NE. 0.0) GO TO 60
   40    CONTINUE
         NU = NU - 1
         J = J - 1
   50 CONTINUE
C
C     STORE THE IMAGINARY PART OF A IN B
C
   60 NUM = NL + NU + 1
      IF (NUM .GT. L) GO TO 100
      IERR = 0
      K = ML - NL
      DO 80 J = 1,NUM
         K = K + 1
         DO 70 I = 1,M
            B(I,J) = AIMAG(A(I,K))
   70    CONTINUE
   80 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  100 IERR = NUM
      RETURN
      END
      SUBROUTINE BCVRC (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
C-----------------------------------------------------------------------
C        COMPUTE A + BI FOR THE BANDED REAL MATRICES A AND B
C-----------------------------------------------------------------------
      REAL A(KA,*), B(KB,*)
      COMPLEX C(KC,L)
C
      MCL = MAX0(ML,NL)
      MCU = MAX0(MU,NU)
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      IERR = 0
      K = MIN0(MU,NU) + 1
C
C     INSERT THE FIRST ABS(ML - NL) DIAGONALS
C
      IF (NL .GE. ML) GO TO 30
      JA = ML - NL
      JB = 0
      JC = JA
      JMAX = NL + K
      DO 20 J = 1,JC
         DO 10 I = 1,M
            C(I,J) = CMPLX(A(I,J),0.0)
   10    CONTINUE
   20 CONTINUE
      GO TO 60
C
   30 JA = 0
      JB = NL - ML
      JC = JB
      JMAX = ML + K
      IF (JC .EQ. 0) GO TO 60
      DO 50 J = 1,JC
         DO 40 I = 1,M
            C(I,J) = CMPLX(0.0,B(I,J))
   40    CONTINUE
   50 CONTINUE
C
C     ADDITION OF THE COMMON DIAGONALS
C
   60 DO 80 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 70 I = 1,M
            C(I,JC) = CMPLX(A(I,JA),B(I,JB))
   70    CONTINUE
   80 CONTINUE
C
C     INSERTION OF THE REMAINING DIAGONALS
C
      IF (NU .GE. MU) GO TO 120
      JMAX = MU - NU
      DO 110 J = 1,JMAX
         JA = JA + 1
         JC = JC + 1
         DO 100 I = 1,M
            C(I,JC) = CMPLX(A(I,JA),0.0)
  100    CONTINUE
  110 CONTINUE
      RETURN
C
  120 JMAX = NU - MU
      IF (JMAX .EQ. 0) RETURN
      DO 140 J = 1,JMAX
         JB = JB + 1
         JC = JC + 1
         DO 130 I = 1,M
            C(I,JC) = CMPLX(0.0,B(I,JB))
  130    CONTINUE
  140 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = NUM
      RETURN
      END
      SUBROUTINE BPOSE (A, KA, M, N, ML, MU, B, KB)
C-----------------------------------------------------------------------
C                TRANSPOSITION OF REAL BANDED MATRICES
C-----------------------------------------------------------------------
      REAL A(KA,*), B(KB,*)
C
      L = ML + MU + 1
      LP1 = L + 1
      IF (MU .EQ. 0) GO TO 40
C
C     DEFINE THE FIRST MU COLUMNS OF B
C
      NDIAG = MU
      DO 31 J = 1,MU
         DO 10 I = 1,NDIAG
            B(I,J) = 0.0
   10    CONTINUE
C
         LJ = LP1 - J
         IMAX = MIN0(M,N - NDIAG)
         DO 20 I = 1,IMAX
            K = NDIAG + I
            B(K,J) = A(I,LJ)
   20    CONTINUE
C
         IF (K .EQ. N) GO TO 31
         IMIN = K + 1
         DO 30 I = IMIN,N
            B(I,J) = 0.0
   30    CONTINUE
   31    NDIAG = NDIAG - 1
C
C     DEFINE THE REMAINING COLUMNS OF B
C
   40 JMIN = MU + 1
      NDIAG = 0
      DO 61 J = JMIN,L
         LJ = LP1 - J
         IMAX = MIN0(M - NDIAG,N)
         DO 50 I = 1,IMAX
            K = NDIAG + I
            B(I,J) = A(K,LJ)
   50    CONTINUE
C
         IF (IMAX .EQ. N) GO TO 61
         IMIN = IMAX + 1
         DO 60 I = IMIN,N
            B(I,J) = 0.0
   60    CONTINUE
   61    NDIAG = NDIAG + 1
      RETURN
      END
      SUBROUTINE DBPOSE (A, KA, M, N, ML, MU, B, KB)
C-----------------------------------------------------------------------
C          TRANSPOSITION OF DOUBLE PRECISION BANDED MATRICES
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), B(KB,*)
C
      L = ML + MU + 1
      LP1 = L + 1
      IF (MU .EQ. 0) GO TO 40
C
C     DEFINE THE FIRST MU COLUMNS OF B
C
      NDIAG = MU
      DO 31 J = 1,MU
         DO 10 I = 1,NDIAG
            B(I,J) = 0.D0
   10    CONTINUE
C
         LJ = LP1 - J
         IMAX = MIN0(M,N - NDIAG)
         DO 20 I = 1,IMAX
            K = NDIAG + I
            B(K,J) = A(I,LJ)
   20    CONTINUE
C
         IF (K .EQ. N) GO TO 31
         IMIN = K + 1
         DO 30 I = IMIN,N
            B(I,J) = 0.D0
   30    CONTINUE
   31    NDIAG = NDIAG - 1
C
C     DEFINE THE REMAINING COLUMNS OF B
C
   40 JMIN = MU + 1
      NDIAG = 0
      DO 61 J = JMIN,L
         LJ = LP1 - J
         IMAX = MIN0(M - NDIAG,N)
         DO 50 I = 1,IMAX
            K = NDIAG + I
            B(I,J) = A(K,LJ)
   50    CONTINUE
C
         IF (IMAX .EQ. N) GO TO 61
         IMIN = IMAX + 1
         DO 60 I = IMIN,N
            B(I,J) = 0.D0
   60    CONTINUE
   61    NDIAG = NDIAG + 1
      RETURN
      END
      SUBROUTINE CBPOSE (A, KA, M, N, ML, MU, B, KB)
C-----------------------------------------------------------------------
C              TRANSPOSITION OF COMPLEX BANDED MATRICES
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), B(KB,*)
C
      L = ML + MU + 1
      LP1 = L + 1
      IF (MU .EQ. 0) GO TO 40
C
C     DEFINE THE FIRST MU COLUMNS OF B
C
      NDIAG = MU
      DO 31 J = 1,MU
         DO 10 I = 1,NDIAG
            B(I,J) = (0.0,0.0)
   10    CONTINUE
C
         LJ = LP1 - J
         IMAX = MIN0(M,N - NDIAG)
         DO 20 I = 1,IMAX
            K = NDIAG + I
            B(K,J) = A(I,LJ)
   20    CONTINUE
C
         IF (K .EQ. N) GO TO 31
         IMIN = K + 1
         DO 30 I = IMIN,N
            B(I,J) = (0.0,0.0)
   30    CONTINUE
   31    NDIAG = NDIAG - 1
C
C     DEFINE THE REMAINING COLUMNS OF B
C
   40 JMIN = MU + 1
      NDIAG = 0
      DO 61 J = JMIN,L
         LJ = LP1 - J
         IMAX = MIN0(M - NDIAG,N)
         DO 50 I = 1,IMAX
            K = NDIAG + I
            B(I,J) = A(K,LJ)
   50    CONTINUE
C
         IF (IMAX .EQ. N) GO TO 61
         IMIN = IMAX + 1
         DO 60 I = IMIN,N
            B(I,J) = (0.0,0.0)
   60    CONTINUE
   61    NDIAG = NDIAG + 1
      RETURN
      END
      SUBROUTINE BADD (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
C-----------------------------------------------------------------------
C                 ADDITION OF REAL BANDED MATRICES
C-----------------------------------------------------------------------
      REAL A(KA,*), B(KB,*), C(KC,L)
C
      IERR = 0
      IF (NL - ML) 10,30,20
C
C     INSERT THE FIRST ABS(ML - NL) DIAGONALS
C
   10 MCL = ML
      IF (ML .GE. L) GO TO 50
      JA = ML - NL
      JB = 0
      JC = JA
      JMAX = NL + 1
      DO 12 J = 1,JC
         DO 11 I = 1,M
   11       C(I,J) = A(I,J)
   12 CONTINUE
      GO TO 50
C
   20 MCL = NL
      IF (NL .GE. L) GO TO 50
      JA = 0
      JB = NL - ML
      JC = JB
      JMAX = ML + 1
      DO 22 J = 1,JC
         DO 21 I = 1,M
   21       C(I,J) = B(I,J)
   22 CONTINUE
      GO TO 50
C
C     COMPUTE MCL WHEN ML = NL
C
   30 MCL = ML
      IF (ML .EQ. 0) GO TO 40
      IMIN = ML + 1
      DO 32 J = 1,ML
         DO 31 I = IMIN,M
            IF ((A(I,J) + B(I,J)) .NE. 0.0) GO TO 40
   31    CONTINUE
         MCL = MCL - 1
         IMIN = IMIN - 1
   32 CONTINUE
C
   40 JA = ML - MCL
      JB = JA
      JC = 0
      JMAX = MCL + 1
C
   50 IF (NU - MU) 100,160,130
C
C     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
C
  100 MCU = MU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + NU
      DO 111 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 110 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  110    CONTINUE
  111 CONTINUE
C
      JMAX = MU - NU
      DO 121 J = 1,JMAX
         JA = JA + 1
         JC = JC + 1
         DO 120 I = 1,M
  120       C(I,JC) = A(I,JA)
  121 CONTINUE
      RETURN
C
  130 MCU = NU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MU
      DO 141 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 140 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  140    CONTINUE
  141 CONTINUE
C
      JMAX = NU - MU
      DO 151 J = 1,JMAX
         JB = JB + 1
         JC = JC + 1
         DO 150 I = 1,M
  150       C(I,JC) = B(I,JB)
  151 CONTINUE
      RETURN
C
C     COMPUTE MCU WHEN MU = NU
C
  160 MCU = MU
      IF (MU .EQ. 0) GO TO 170
      LA = ML + MU + 1
      LB = NL + NU + 1
      DO 162 J = 1,MU
         DO 161 I = 1,M
            IF ((A(I,LA) + B(I,LB)) .NE. 0.0) GO TO 170
  161    CONTINUE
         MCU = MCU - 1
         LA = LA - 1
         LB = LB - 1
  162 CONTINUE
C
C     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
C
  170 NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MCU
      DO 181 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 180 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  180    CONTINUE
  181 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = NUM
      RETURN
      END
      SUBROUTINE DBADD (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
C-----------------------------------------------------------------------
C           ADDITION OF DOUBLE PRECISION BANDED MATRICES
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), B(KB,*), C(KC,L)
C
      IERR = 0
      IF (NL - ML) 10,30,20
C
C     INSERT THE FIRST ABS(ML - NL) DIAGONALS
C
   10 MCL = ML
      IF (ML .GE. L) GO TO 50
      JA = ML - NL
      JB = 0
      JC = JA
      JMAX = NL + 1
      DO 12 J = 1,JC
         DO 11 I = 1,M
   11       C(I,J) = A(I,J)
   12 CONTINUE
      GO TO 50
C
   20 MCL = NL
      IF (NL .GE. L) GO TO 50
      JA = 0
      JB = NL - ML
      JC = JB
      JMAX = ML + 1
      DO 22 J = 1,JC
         DO 21 I = 1,M
   21       C(I,J) = B(I,J)
   22 CONTINUE
      GO TO 50
C
C     COMPUTE MCL WHEN ML = NL
C
   30 MCL = ML
      IF (ML .EQ. 0) GO TO 40
      IMIN = ML + 1
      DO 32 J = 1,ML
         DO 31 I = IMIN,M
            IF ((A(I,J) + B(I,J)) .NE. 0.D0) GO TO 40
   31    CONTINUE
         MCL = MCL - 1
         IMIN = IMIN - 1
   32 CONTINUE
C
   40 JA = ML - MCL
      JB = JA
      JC = 0
      JMAX = MCL + 1
C
   50 IF (NU - MU) 100,160,130
C
C     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
C
  100 MCU = MU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + NU
      DO 111 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 110 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  110    CONTINUE
  111 CONTINUE
C
      JMAX = MU - NU
      DO 121 J = 1,JMAX
         JA = JA + 1
         JC = JC + 1
         DO 120 I = 1,M
  120       C(I,JC) = A(I,JA)
  121 CONTINUE
      RETURN
C
  130 MCU = NU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MU
      DO 141 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 140 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  140    CONTINUE
  141 CONTINUE
C
      JMAX = NU - MU
      DO 151 J = 1,JMAX
         JB = JB + 1
         JC = JC + 1
         DO 150 I = 1,M
  150       C(I,JC) = B(I,JB)
  151 CONTINUE
      RETURN
C
C     COMPUTE MCU WHEN MU = NU
C
  160 MCU = MU
      IF (MU .EQ. 0) GO TO 170
      LA = ML + MU + 1
      LB = NL + NU + 1
      DO 162 J = 1,MU
         DO 161 I = 1,M
            IF ((A(I,LA) + B(I,LB)) .NE. 0.D0) GO TO 170
  161    CONTINUE
         MCU = MCU - 1
         LA = LA - 1
         LB = LB - 1
  162 CONTINUE
C
C     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
C
  170 NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MCU
      DO 181 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 180 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  180    CONTINUE
  181 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = NUM
      RETURN
      END
      SUBROUTINE CBADD (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
C-----------------------------------------------------------------------
C                ADDITION OF COMPLEX BANDED MATRICES
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), B(KB,*), C(KC,L)
C
      IERR = 0
      IF (NL - ML) 10,30,20
C
C     INSERT THE FIRST ABS(ML - NL) DIAGONALS
C
   10 MCL = ML
      IF (ML .GE. L) GO TO 50
      JA = ML - NL
      JB = 0
      JC = JA
      JMAX = NL + 1
      DO 12 J = 1,JC
         DO 11 I = 1,M
   11       C(I,J) = A(I,J)
   12 CONTINUE
      GO TO 50
C
   20 MCL = NL
      IF (NL .GE. L) GO TO 50
      JA = 0
      JB = NL - ML
      JC = JB
      JMAX = ML + 1
      DO 22 J = 1,JC
         DO 21 I = 1,M
   21       C(I,J) = B(I,J)
   22 CONTINUE
      GO TO 50
C
C     COMPUTE MCL WHEN ML = NL
C
   30 MCL = ML
      IF (ML .EQ. 0) GO TO 40
      IMIN = ML + 1
      DO 32 J = 1,ML
         DO 31 I = IMIN,M
            IF ((A(I,J) + B(I,J)) .NE. (0.0,0.0)) GO TO 40
   31    CONTINUE
         MCL = MCL - 1
         IMIN = IMIN - 1
   32 CONTINUE
C
   40 JA = ML - MCL
      JB = JA
      JC = 0
      JMAX = MCL + 1
C
   50 IF (NU - MU) 100,160,130
C
C     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
C
  100 MCU = MU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + NU
      DO 111 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 110 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  110    CONTINUE
  111 CONTINUE
C
      JMAX = MU - NU
      DO 121 J = 1,JMAX
         JA = JA + 1
         JC = JC + 1
         DO 120 I = 1,M
  120       C(I,JC) = A(I,JA)
  121 CONTINUE
      RETURN
C
  130 MCU = NU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MU
      DO 141 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 140 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  140    CONTINUE
  141 CONTINUE
C
      JMAX = NU - MU
      DO 151 J = 1,JMAX
         JB = JB + 1
         JC = JC + 1
         DO 150 I = 1,M
  150       C(I,JC) = B(I,JB)
  151 CONTINUE
      RETURN
C
C     COMPUTE MCU WHEN MU = NU
C
  160 MCU = MU
      IF (MU .EQ. 0) GO TO 170
      LA = ML + MU + 1
      LB = NL + NU + 1
      DO 162 J = 1,MU
         DO 161 I = 1,M
            IF ((A(I,LA) + B(I,LB)) .NE. (0.0,0.0)) GO TO 170
  161    CONTINUE
         MCU = MCU - 1
         LA = LA - 1
         LB = LB - 1
  162 CONTINUE
C
C     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
C
  170 NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MCU
      DO 181 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 180 I = 1,M
            C(I,JC) = A(I,JA) + B(I,JB)
  180    CONTINUE
  181 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = NUM
      RETURN
      END
      SUBROUTINE BSUBT (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
C-----------------------------------------------------------------------
C                SUBTRACTION OF REAL BANDED MATRICES
C-----------------------------------------------------------------------
      REAL A(KA,*), B(KB,*), C(KC,L)
C
      IERR = 0
      IF (NL - ML) 10,30,20
C
C     INSERT THE FIRST ABS(ML - NL) DIAGONALS
C
   10 MCL = ML
      IF (ML .GE. L) GO TO 50
      JA = ML - NL
      JB = 0
      JC = JA
      JMAX = NL + 1
      DO 12 J = 1,JC
         DO 11 I = 1,M
   11       C(I,J) = A(I,J)
   12 CONTINUE
      GO TO 50
C
   20 MCL = NL
      IF (NL .GE. L) GO TO 50
      JA = 0
      JB = NL - ML
      JC = JB
      JMAX = ML + 1
      DO 22 J = 1,JC
         DO 21 I = 1,M
   21       C(I,J) = -B(I,J)
   22 CONTINUE
      GO TO 50
C
C     COMPUTE MCL WHEN ML = NL
C
   30 MCL = ML
      IF (ML .EQ. 0) GO TO 40
      IMIN = ML + 1
      DO 32 J = 1,ML
         DO 31 I = IMIN,M
            IF ((A(I,J) - B(I,J)) .NE. 0.0) GO TO 40
   31    CONTINUE
         MCL = MCL - 1
         IMIN = IMIN - 1
   32 CONTINUE
C
   40 JA = ML - MCL
      JB = JA
      JC = 0
      JMAX = MCL + 1
C
   50 IF (NU - MU) 100,160,130
C
C     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
C
  100 MCU = MU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + NU
      DO 111 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 110 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  110    CONTINUE
  111 CONTINUE
C
      JMAX = MU - NU
      DO 121 J = 1,JMAX
         JA = JA + 1
         JC = JC + 1
         DO 120 I = 1,M
  120       C(I,JC) = A(I,JA)
  121 CONTINUE
      RETURN
C
  130 MCU = NU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MU
      DO 141 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 140 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  140    CONTINUE
  141 CONTINUE
C
      JMAX = NU - MU
      DO 151 J = 1,JMAX
         JB = JB + 1
         JC = JC + 1
         DO 150 I = 1,M
  150       C(I,JC) = -B(I,JB)
  151 CONTINUE
      RETURN
C
C     COMPUTE MCU WHEN MU = NU
C
  160 MCU = MU
      IF (MU .EQ. 0) GO TO 170
      LA = ML + MU + 1
      LB = NL + NU + 1
      DO 162 J = 1,MU
         DO 161 I = 1,M
            IF ((A(I,LA) - B(I,LB)) .NE. 0.0) GO TO 170
  161    CONTINUE
         MCU = MCU - 1
         LA = LA - 1
         LB = LB - 1
  162 CONTINUE
C
C     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
C
  170 NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MCU
      DO 181 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 180 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  180    CONTINUE
  181 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = NUM
      RETURN
      END
      SUBROUTINE DBSUBT (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
C-----------------------------------------------------------------------
C          SUBTRACTION OF DOUBLE PRECISION BANDED MATRICES
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), B(KB,*), C(KC,L)
C
      IERR = 0
      IF (NL - ML) 10,30,20
C
C     INSERT THE FIRST ABS(ML - NL) DIAGONALS
C
   10 MCL = ML
      IF (ML .GE. L) GO TO 50
      JA = ML - NL
      JB = 0
      JC = JA
      JMAX = NL + 1
      DO 12 J = 1,JC
         DO 11 I = 1,M
   11       C(I,J) = A(I,J)
   12 CONTINUE
      GO TO 50
C
   20 MCL = NL
      IF (NL .GE. L) GO TO 50
      JA = 0
      JB = NL - ML
      JC = JB
      JMAX = ML + 1
      DO 22 J = 1,JC
         DO 21 I = 1,M
   21       C(I,J) = -B(I,J)
   22 CONTINUE
      GO TO 50
C
C     COMPUTE MCL WHEN ML = NL
C
   30 MCL = ML
      IF (ML .EQ. 0) GO TO 40
      IMIN = ML + 1
      DO 32 J = 1,ML
         DO 31 I = IMIN,M
            IF ((A(I,J) - B(I,J)) .NE. 0.D0) GO TO 40
   31    CONTINUE
         MCL = MCL - 1
         IMIN = IMIN - 1
   32 CONTINUE
C
   40 JA = ML - MCL
      JB = JA
      JC = 0
      JMAX = MCL + 1
C
   50 IF (NU - MU) 100,160,130
C
C     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
C
  100 MCU = MU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + NU
      DO 111 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 110 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  110    CONTINUE
  111 CONTINUE
C
      JMAX = MU - NU
      DO 121 J = 1,JMAX
         JA = JA + 1
         JC = JC + 1
         DO 120 I = 1,M
  120       C(I,JC) = A(I,JA)
  121 CONTINUE
      RETURN
C
  130 MCU = NU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MU
      DO 141 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 140 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  140    CONTINUE
  141 CONTINUE
C
      JMAX = NU - MU
      DO 151 J = 1,JMAX
         JB = JB + 1
         JC = JC + 1
         DO 150 I = 1,M
  150       C(I,JC) = -B(I,JB)
  151 CONTINUE
      RETURN
C
C     COMPUTE MCU WHEN MU = NU
C
  160 MCU = MU
      IF (MU .EQ. 0) GO TO 170
      LA = ML + MU + 1
      LB = NL + NU + 1
      DO 162 J = 1,MU
         DO 161 I = 1,M
            IF ((A(I,LA) - B(I,LB)) .NE. 0.D0) GO TO 170
  161    CONTINUE
         MCU = MCU - 1
         LA = LA - 1
         LB = LB - 1
  162 CONTINUE
C
C     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
C
  170 NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MCU
      DO 181 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 180 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  180    CONTINUE
  181 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = NUM
      RETURN
      END
      SUBROUTINE CBSUBT (M,N,A,KA,ML,MU,B,KB,NL,NU,C,KC,L,MCL,MCU,IERR)
C-----------------------------------------------------------------------
C             SUBTRACTION OF COMPLEX BANDED MATRICES
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), B(KB,*), C(KC,L)
C
      IERR = 0
      IF (NL - ML) 10,30,20
C
C     INSERT THE FIRST ABS(ML - NL) DIAGONALS
C
   10 MCL = ML
      IF (ML .GE. L) GO TO 50
      JA = ML - NL
      JB = 0
      JC = JA
      JMAX = NL + 1
      DO 12 J = 1,JC
         DO 11 I = 1,M
   11       C(I,J) = A(I,J)
   12 CONTINUE
      GO TO 50
C
   20 MCL = NL
      IF (NL .GE. L) GO TO 50
      JA = 0
      JB = NL - ML
      JC = JB
      JMAX = ML + 1
      DO 22 J = 1,JC
         DO 21 I = 1,M
   21       C(I,J) = -B(I,J)
   22 CONTINUE
      GO TO 50
C
C     COMPUTE MCL WHEN ML = NL
C
   30 MCL = ML
      IF (ML .EQ. 0) GO TO 40
      IMIN = ML + 1
      DO 32 J = 1,ML
         DO 31 I = IMIN,M
            IF ((A(I,J) - B(I,J)) .NE. (0.0,0.0)) GO TO 40
   31    CONTINUE
         MCL = MCL - 1
         IMIN = IMIN - 1
   32 CONTINUE
C
   40 JA = ML - MCL
      JB = JA
      JC = 0
      JMAX = MCL + 1
C
   50 IF (NU - MU) 100,160,130
C
C     INSERTION OF THE REMAINING DIAGONALS WHEN MU .NE. NU
C
  100 MCU = MU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + NU
      DO 111 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 110 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  110    CONTINUE
  111 CONTINUE
C
      JMAX = MU - NU
      DO 121 J = 1,JMAX
         JA = JA + 1
         JC = JC + 1
         DO 120 I = 1,M
  120       C(I,JC) = A(I,JA)
  121 CONTINUE
      RETURN
C
  130 MCU = NU
      NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MU
      DO 141 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 140 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  140    CONTINUE
  141 CONTINUE
C
      JMAX = NU - MU
      DO 151 J = 1,JMAX
         JB = JB + 1
         JC = JC + 1
         DO 150 I = 1,M
  150       C(I,JC) = -B(I,JB)
  151 CONTINUE
      RETURN
C
C     COMPUTE MCU WHEN MU = NU
C
  160 MCU = MU
      IF (MU .EQ. 0) GO TO 170
      LA = ML + MU + 1
      LB = NL + NU + 1
      DO 162 J = 1,MU
         DO 161 I = 1,M
            IF ((A(I,LA) - B(I,LB)) .NE. (0.0,0.0)) GO TO 170
  161    CONTINUE
         MCU = MCU - 1
         LA = LA - 1
         LB = LB - 1
  162 CONTINUE
C
C     ADDITION OF THE REMAINING COLUMNS WHEN MU = NU
C
  170 NUM = MCL + MCU + 1
      IF (NUM .GT. L) GO TO 200
C
      JMAX = JMAX + MCU
      DO 181 J = 1,JMAX
         JA = JA + 1
         JB = JB + 1
         JC = JC + 1
         DO 180 I = 1,M
            C(I,JC) = A(I,JA) - B(I,JB)
  180    CONTINUE
  181 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = NUM
      RETURN
      END
      SUBROUTINE BPROD (M, N, L, A, KA, ML, MU, B, KB, NL, NU,
     *                  C, KC, NC, MCL, MCU, IERR)
C-----------------------------------------------------------------------
C                MULTIPLICATION OF REAL BANDED MATRICES
C-----------------------------------------------------------------------
      REAL A(KA,*), B(KB,*), C(KC,NC)
C
      IERR = 0
      DO 11 J = 1,NC
         DO 10 I = 1,M
   10       C(I,J) = 0.0
   11 CONTINUE
C
      MLP1 = ML + 1
      NLP1 = NL + 1
      NPML = N + ML
      NPNU = N + NU
      MCL = MIN0(M - 1,ML + NL)
      JC = 0
      IF (MCL .EQ. 0) GO TO 100
C
C     FIND THE FIRST NONZERO LOWER DIAGONAL
C
      MAXD = MCL
      DO 31 NDIAG = 1,MAXD
         IMJ = MAXD + 1 - NDIAG
         JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
         DO 21 J = 1,JMAX
            I = J + IMJ
            SUM = 0.0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 20 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
   20       CONTINUE
            C(I,1) = SUM
   21    CONTINUE
C
         DO 30 J = 1,JMAX
            I = J + IMJ
            IF (C(I,1) .NE. 0.0) GO TO 40
   30    CONTINUE
         MCL = MCL - 1
   31 CONTINUE
      GO TO 100
C
   40 IF (MCL .GE. NC) GO TO 100
      JC = 1
      IF (MCL .EQ. 1) GO TO 100
C
C     COMPUTE THE REMAINING LOWER DIAGONALS
C
      MIND = NDIAG + 1
      DO 52 NDIAG = MIND,MAXD
         JC = JC + 1
         IMJ = MAXD + 1 - NDIAG
         JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
         DO 51 J = 1,JMAX
            I = J + IMJ
            SUM = 0.0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 50 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
   50       CONTINUE
            C(I,JC) = SUM
   51    CONTINUE
   52 CONTINUE
C
C     FIND THE LAST NONZERO UPPER DIAGONAL
C
  100 JC = JC + 1
      MCU = MIN0(L - 1,MU + NU)
      IF (MCU .EQ. 0) GO TO 130
C
      MAXD = MCU
      DO 121 NDIAG = 1,MAXD
         JMI = MAXD + 1 - NDIAG
         IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
         DO 111 I = 1,IMAX
            J = I + JMI
            SUM = 0.0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 110 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
  110       CONTINUE
            C(I,JC) = SUM
  111    CONTINUE
C
         DO 120 I = 1,IMAX
            IF (C(I,JC) .NE. 0.0) GO TO 130
  120    CONTINUE
         MCU = MCU - 1
  121 CONTINUE
C
  130 LAST = MCL + MCU + 1
      IF (LAST .GT. NC) GO TO 200
      IF (MCU .EQ. 0) GO TO 140
      DO 131 I = 1,IMAX
         C(I,LAST) = C(I,JC)
         C(I,JC) = 0.0
  131 CONTINUE
C
C     COMPUTE THE MAIN DIAGONAL AND THE REMAINING UPPER DIAGONALS
C
  140 MAXD = MAX0(1,MCU)
      DO 143 NDIAG = 1,MAXD
         JMI = NDIAG - 1
         IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
         DO 142 I = 1,IMAX
            J = I + JMI
            SUM = 0.0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 141 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
  141       CONTINUE
            C(I,JC) = SUM
  142    CONTINUE
         JC = JC + 1
  143 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = LAST
      RETURN
      END
      SUBROUTINE DBPROD (M, N, L, A, KA, ML, MU, B, KB, NL, NU,
     *                   C, KC, NC, MCL, MCU, IERR)
C-----------------------------------------------------------------------
C          MULTIPLICATION OF DOUBLE PRECISION BANDED MATRICES
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), B(KB,*), C(KC,NC)
      DOUBLE PRECISION SUM
C
      IERR = 0
      DO 11 J = 1,NC
         DO 10 I = 1,M
   10       C(I,J) = 0.D0
   11 CONTINUE
C
      MLP1 = ML + 1
      NLP1 = NL + 1
      NPML = N + ML
      NPNU = N + NU
      MCL = MIN0(M - 1,ML + NL)
      JC = 0
      IF (MCL .EQ. 0) GO TO 100
C
C     FIND THE FIRST NONZERO LOWER DIAGONAL
C
      MAXD = MCL
      DO 31 NDIAG = 1,MAXD
         IMJ = MAXD + 1 - NDIAG
         JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
         DO 21 J = 1,JMAX
            I = J + IMJ
            SUM = 0.D0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 20 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
   20       CONTINUE
            C(I,1) = SUM
   21    CONTINUE
C
         DO 30 J = 1,JMAX
            I = J + IMJ
            IF (C(I,1) .NE. 0.D0) GO TO 40
   30    CONTINUE
         MCL = MCL - 1
   31 CONTINUE
      GO TO 100
C
   40 IF (MCL .GE. NC) GO TO 100
      JC = 1
      IF (MCL .EQ. 1) GO TO 100
C
C     COMPUTE THE REMAINING LOWER DIAGONALS
C
      MIND = NDIAG + 1
      DO 52 NDIAG = MIND,MAXD
         JC = JC + 1
         IMJ = MAXD + 1 - NDIAG
         JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
         DO 51 J = 1,JMAX
            I = J + IMJ
            SUM = 0.D0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 50 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
   50       CONTINUE
            C(I,JC) = SUM
   51    CONTINUE
   52 CONTINUE
C
C     FIND THE LAST NONZERO UPPER DIAGONAL
C
  100 JC = JC + 1
      MCU = MIN0(L - 1,MU + NU)
      IF (MCU .EQ. 0) GO TO 130
C
      MAXD = MCU
      DO 121 NDIAG = 1,MAXD
         JMI = MAXD + 1 - NDIAG
         IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
         DO 111 I = 1,IMAX
            J = I + JMI
            SUM = 0.D0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 110 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
  110       CONTINUE
            C(I,JC) = SUM
  111    CONTINUE
C
         DO 120 I = 1,IMAX
            IF (C(I,JC) .NE. 0.D0) GO TO 130
  120    CONTINUE
         MCU = MCU - 1
  121 CONTINUE
C
  130 LAST = MCL + MCU + 1
      IF (LAST .GT. NC) GO TO 200
      IF (MCU .EQ. 0) GO TO 140
      DO 131 I = 1,IMAX
         C(I,LAST) = C(I,JC)
         C(I,JC) = 0.D0
  131 CONTINUE
C
C     COMPUTE THE MAIN DIAGONAL AND THE REMAINING UPPER DIAGONALS
C
  140 MAXD = MAX0(1,MCU)
      DO 143 NDIAG = 1,MAXD
         JMI = NDIAG - 1
         IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
         DO 142 I = 1,IMAX
            J = I + JMI
            SUM = 0.D0
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 141 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
  141       CONTINUE
            C(I,JC) = SUM
  142    CONTINUE
         JC = JC + 1
  143 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = LAST
      RETURN
      END
      SUBROUTINE CBPROD (M, N, L, A, KA, ML, MU, B, KB, NL, NU,
     *                   C, KC, NC, MCL, MCU, IERR)
C-----------------------------------------------------------------------
C             MULTIPLICATION OF COMPLEX BANDED MATRICES
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), B(KB,*), C(KC,NC)
      COMPLEX SUM
C
      IERR = 0
      DO 11 J = 1,NC
         DO 10 I = 1,M
   10       C(I,J) = (0.0,0.0)
   11 CONTINUE
C
      MLP1 = ML + 1
      NLP1 = NL + 1
      NPML = N + ML
      NPNU = N + NU
      MCL = MIN0(M - 1,ML + NL)
      JC = 0
      IF (MCL .EQ. 0) GO TO 100
C
C     FIND THE FIRST NONZERO LOWER DIAGONAL
C
      MAXD = MCL
      DO 31 NDIAG = 1,MAXD
         IMJ = MAXD + 1 - NDIAG
         JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
         DO 21 J = 1,JMAX
            I = J + IMJ
            SUM = (0.0,0.0)
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 20 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
   20       CONTINUE
            C(I,1) = SUM
   21    CONTINUE
C
         DO 30 J = 1,JMAX
            I = J + IMJ
            IF (C(I,1) .NE. (0.0,0.0)) GO TO 40
   30    CONTINUE
         MCL = MCL - 1
   31 CONTINUE
      GO TO 100
C
   40 IF (MCL .GE. NC) GO TO 100
      JC = 1
      IF (MCL .EQ. 1) GO TO 100
C
C     COMPUTE THE REMAINING LOWER DIAGONALS
C
      MIND = NDIAG + 1
      DO 52 NDIAG = MIND,MAXD
         JC = JC + 1
         IMJ = MAXD + 1 - NDIAG
         JMAX = MIN0(L,M - IMJ,NPML - IMJ,NPNU)
         DO 51 J = 1,JMAX
            I = J + IMJ
            SUM = (0.0,0.0)
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 50 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
   50       CONTINUE
            C(I,JC) = SUM
   51    CONTINUE
   52 CONTINUE
C
C     FIND THE LAST NONZERO UPPER DIAGONAL
C
  100 JC = JC + 1
      MCU = MIN0(L - 1,MU + NU)
      IF (MCU .EQ. 0) GO TO 130
C
      MAXD = MCU
      DO 121 NDIAG = 1,MAXD
         JMI = MAXD + 1 - NDIAG
         IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
         DO 111 I = 1,IMAX
            J = I + JMI
            SUM = (0.0,0.0)
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 110 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
  110       CONTINUE
            C(I,JC) = SUM
  111    CONTINUE
C
         DO 120 I = 1,IMAX
            IF (C(I,JC) .NE. (0.0,0.0)) GO TO 130
  120    CONTINUE
         MCU = MCU - 1
  121 CONTINUE
C
  130 LAST = MCL + MCU + 1
      IF (LAST .GT. NC) GO TO 200
      IF (MCU .EQ. 0) GO TO 140
      DO 131 I = 1,IMAX
         C(I,LAST) = C(I,JC)
         C(I,JC) = (0.0,0.0)
  131 CONTINUE
C
C     COMPUTE THE MAIN DIAGONAL AND THE REMAINING UPPER DIAGONALS
C
  140 MAXD = MAX0(1,MCU)
      DO 143 NDIAG = 1,MAXD
         JMI = NDIAG - 1
         IMAX = MIN0(M,L - JMI,NPML,NPNU - JMI)
         DO 142 I = 1,IMAX
            J = I + JMI
            SUM = (0.0,0.0)
            KMIN = MAX0(1,I - ML,J - NU)
            KMAX = MIN0(N,I + MU,J + NL)
            KK = MLP1 - I + KMIN
            JJ = NLP1 + J - KMIN
            DO 141 K = KMIN,KMAX
               SUM = SUM + A(I,KK)*B(K,JJ)
               KK = KK + 1
               JJ = JJ - 1
  141       CONTINUE
            C(I,JC) = SUM
  142    CONTINUE
         JC = JC + 1
  143 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = LAST
      RETURN
      END
      SUBROUTINE BVPRD (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C         PRODUCT OF A REAL BANDED MATRIX AND A REAL VECTOR
C-----------------------------------------------------------------------
      REAL A(KA,*), X(N), Y(M)
C
C     COMPUTE THE FIRST ML COMPONENTS
C
      MLP1 = ML + 1
      IF (ML .EQ. 0) GO TO 20
      JMIN = MLP1
      DO 11 I = 1,ML
         KMAX = MIN0(N,I + MU)
         KK = JMIN
         SUM = 0.0
         DO 10 K = 1,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   10    CONTINUE
         Y(I) = SUM
         JMIN = JMIN - 1
   11 CONTINUE
C
C     COMPUTE THE REMAINING NONZERO COMPONENTS
C
   20 IMAX = MIN0(M,N + ML)
      DO 22 I = MLP1,IMAX
         KMIN = I - ML
         KMAX = MIN0(N,I + MU)
         KK = 1
         SUM = 0.0
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   21    CONTINUE
         Y(I) = SUM
   22 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX COMPONENTS
C
      IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 30 I = IMIN,M
         Y(I) = 0.0
   30 CONTINUE
      RETURN
      END
      SUBROUTINE BVPRD1 (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C        SETTING Y = A*X + Y WHERE A IS A REAL BANDED MATRIX
C                     AND X,Y ARE REAL VECTORS
C-----------------------------------------------------------------------
      REAL A(KA,*), X(N), Y(M)
C
C     COMPUTE THE FIRST ML COMPONENTS
C
      MLP1 = ML + 1
      IF (ML .EQ. 0) GO TO 20
      JMIN = MLP1
      DO 11 I = 1,ML
         KMAX = MIN0(N,I + MU)
         KK = JMIN
         SUM = Y(I)
         DO 10 K = 1,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   10    CONTINUE
         Y(I) = SUM
         JMIN = JMIN - 1
   11 CONTINUE
C
C     COMPUTE THE REMAINING COMPONENTS
C
   20 IMAX = MIN0(M,N + ML)
      DO 22 I = MLP1,IMAX
         KMIN = I - ML
         KMAX = MIN0(N,I + MU)
         KK = 1
         SUM = Y(I)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   21    CONTINUE
         Y(I) = SUM
   22 CONTINUE
      RETURN
      END
      SUBROUTINE DBVPD (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C           PRODUCT OF A DOUBLE PRECISION BANDED MATRIX
C                  AND A DOUBLE PRECISION VECTOR
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), X(N), Y(M)
      DOUBLE PRECISION SUM
C
C     COMPUTE THE FIRST ML COMPONENTS
C
      MLP1 = ML + 1
      IF (ML .EQ. 0) GO TO 20
      JMIN = MLP1
      DO 11 I = 1,ML
         KMAX = MIN0(N,I + MU)
         KK = JMIN
         SUM = 0.D0
         DO 10 K = 1,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   10    CONTINUE
         Y(I) = SUM
         JMIN = JMIN - 1
   11 CONTINUE
C
C     COMPUTE THE REMAINING NONZERO COMPONENTS
C
   20 IMAX = MIN0(M,N + ML)
      DO 22 I = MLP1,IMAX
         KMIN = I - ML
         KMAX = MIN0(N,I + MU)
         KK = 1
         SUM = 0.D0
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   21    CONTINUE
         Y(I) = SUM
   22 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX COMPONENTS
C
      IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 30 I = IMIN,M
         Y(I) = 0.D0
   30 CONTINUE
      RETURN
      END
      SUBROUTINE DBVPD1 (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C         SETTING Y = A*X + Y WHERE A IS A DOUBLE PRECISION
C         BANDED MATRIX AND X,Y ARE DOUBLE PRECISION VECTORS
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), X(N), Y(M)
      DOUBLE PRECISION SUM
C
C     COMPUTE THE FIRST ML COMPONENTS
C
      MLP1 = ML + 1
      IF (ML .EQ. 0) GO TO 20
      JMIN = MLP1
      DO 11 I = 1,ML
         KMAX = MIN0(N,I + MU)
         KK = JMIN
         SUM = Y(I)
         DO 10 K = 1,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   10    CONTINUE
         Y(I) = SUM
         JMIN = JMIN - 1
   11 CONTINUE
C
C     COMPUTE THE REMAINING COMPONENTS
C
   20 IMAX = MIN0(M,N + ML)
      DO 22 I = MLP1,IMAX
         KMIN = I - ML
         KMAX = MIN0(N,I + MU)
         KK = 1
         SUM = Y(I)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   21    CONTINUE
         Y(I) = SUM
   22 CONTINUE
      RETURN
      END
      SUBROUTINE CBVPD (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C        PRODUCT OF A COMPLEX BANDED MATRIX AND A COMPLEX VECTOR
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), X(N), Y(M)
      COMPLEX SUM
C
C     COMPUTE THE FIRST ML COMPONENTS
C
      MLP1 = ML + 1
      IF (ML .EQ. 0) GO TO 20
      JMIN = MLP1
      DO 11 I = 1,ML
         KMAX = MIN0(N,I + MU)
         KK = JMIN
         SUM = (0.0,0.0)
         DO 10 K = 1,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   10    CONTINUE
         Y(I) = SUM
         JMIN = JMIN - 1
   11 CONTINUE
C
C     COMPUTE THE REMAINING NONZERO COMPONENTS
C
   20 IMAX = MIN0(M,N + ML)
      DO 22 I = MLP1,IMAX
         KMIN = I - ML
         KMAX = MIN0(N,I + MU)
         KK = 1
         SUM = (0.0,0.0)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   21    CONTINUE
         Y(I) = SUM
   22 CONTINUE
C
C     STORE ZEROS IN THE FINAL M-IMAX COMPONENTS
C
      IF (IMAX .EQ. M) RETURN
      IMIN = IMAX + 1
      DO 30 I = IMIN,M
         Y(I) = (0.0,0.0)
   30 CONTINUE
      RETURN
      END
      SUBROUTINE CBVPD1 (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C        SETTING Y = A*X + Y WHERE A IS A COMPLEX BANDED MATRIX
C                     AND X,Y ARE COMPLEX VECTORS
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), X(N), Y(M)
      COMPLEX SUM
C
C     COMPUTE THE FIRST ML COMPONENTS
C
      MLP1 = ML + 1
      IF (ML .EQ. 0) GO TO 20
      JMIN = MLP1
      DO 11 I = 1,ML
         KMAX = MIN0(N,I + MU)
         KK = JMIN
         SUM = Y(I)
         DO 10 K = 1,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   10    CONTINUE
         Y(I) = SUM
         JMIN = JMIN - 1
   11 CONTINUE
C
C     COMPUTE THE REMAINING COMPONENTS
C
   20 IMAX = MIN0(M,N + ML)
      DO 22 I = MLP1,IMAX
         KMIN = I - ML
         KMAX = MIN0(N,I + MU)
         KK = 1
         SUM = Y(I)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(I,KK)*X(K)
            KK = KK + 1
   21    CONTINUE
         Y(I) = SUM
   22 CONTINUE
      RETURN
      END
      SUBROUTINE BTPRD (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C         PRODUCT OF A REAL VECTOR AND A REAL BANDED MATRIX
C-----------------------------------------------------------------------
      REAL A(KA,*), X(M), Y(N)
C
C     COMPUTE THE FIRST MU COMPONENTS
C
      IF (MU .EQ. 0) GO TO 20
      DO 11 J = 1,MU
         JJ = ML + J
         KMAX = MIN0(M,JJ)
         SUM = 0.0
         DO 10 K = 1,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   10    CONTINUE
         Y(J) = SUM
   11 CONTINUE
C
C     COMPUTE THE REMAINING NONZERO COMPONENTS
C
   20 NUM = ML + MU + 1
      JMIN = MU + 1
      JMAX = MIN0(N,M + MU)
      DO 22 J = JMIN,JMAX
         KMIN = J - MU
         KMAX = MIN0(M,J + ML)
         JJ = NUM
         SUM = 0.0
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   21    CONTINUE
         Y(J) = SUM
   22 CONTINUE
C
C     STORE ZEROS IN THE FINAL N-JMAX COMPONENTS
C
      IF (JMAX .EQ. N) RETURN
      JMIN = JMAX + 1
      DO 30 J = JMIN,N
         Y(J) = 0.0
   30 CONTINUE
      RETURN
      END
      SUBROUTINE BTPRD1 (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C        SETTING Y = X*A + Y WHERE A IS A REAL BANDED MATRIX
C                     AND X,Y ARE REAL VECTORS
C-----------------------------------------------------------------------
      REAL A(KA,*), X(M), Y(N)
C
C     COMPUTE THE FIRST MU COMPONENTS
C
      IF (MU .EQ. 0) GO TO 20
      DO 11 J = 1,MU
         JJ = ML + J
         KMAX = MIN0(M,JJ)
         SUM = Y(J)
         DO 10 K = 1,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   10    CONTINUE
         Y(J) = SUM
   11 CONTINUE
C
C     COMPUTE THE REMAINING COMPONENTS
C
   20 NUM = ML + MU + 1
      JMIN = MU + 1
      JMAX = MIN0(N,M + MU)
      DO 22 J = JMIN,JMAX
         KMIN = J - MU
         KMAX = MIN0(M,J + ML)
         JJ = NUM
         SUM = Y(J)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   21    CONTINUE
         Y(J) = SUM
   22 CONTINUE
      RETURN
      END
      SUBROUTINE DBTPD (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C              PRODUCT OF A DOUBLE PRECISION VECTOR AND
C                  A DOUBLE PRECISION BANDED MATRIX
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), X(M), Y(N)
      DOUBLE PRECISION SUM
C
C     COMPUTE THE FIRST MU COMPONENTS
C
      IF (MU .EQ. 0) GO TO 20
      DO 11 J = 1,MU
         JJ = ML + J
         KMAX = MIN0(M,JJ)
         SUM = 0.D0
         DO 10 K = 1,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   10    CONTINUE
         Y(J) = SUM
   11 CONTINUE
C
C     COMPUTE THE REMAINING NONZERO COMPONENTS
C
   20 NUM = ML + MU + 1
      JMIN = MU + 1
      JMAX = MIN0(N,M + MU)
      DO 22 J = JMIN,JMAX
         KMIN = J - MU
         KMAX = MIN0(M,J + ML)
         JJ = NUM
         SUM = 0.D0
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   21    CONTINUE
         Y(J) = SUM
   22 CONTINUE
C
C     STORE ZEROS IN THE FINAL N-JMAX COMPONENTS
C
      IF (JMAX .EQ. N) RETURN
      JMIN = JMAX + 1
      DO 30 J = JMIN,N
         Y(J) = 0.D0
   30 CONTINUE
      RETURN
      END
      SUBROUTINE DBTPD1 (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C         SETTING Y = X*A + Y WHERE A IS A DOUBLE PRECISION
C         BANDED MATRIX AND X,Y ARE DOUBLE PRECISION VECTORS
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), X(M), Y(N)
      DOUBLE PRECISION SUM
C
C     COMPUTE THE FIRST MU COMPONENTS
C
      IF (MU .EQ. 0) GO TO 20
      DO 11 J = 1,MU
         JJ = ML + J
         KMAX = MIN0(M,JJ)
         SUM = Y(J)
         DO 10 K = 1,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   10    CONTINUE
         Y(J) = SUM
   11 CONTINUE
C
C     COMPUTE THE REMAINING COMPONENTS
C
   20 NUM = ML + MU + 1
      JMIN = MU + 1
      JMAX = MIN0(N,M + MU)
      DO 22 J = JMIN,JMAX
         KMIN = J - MU
         KMAX = MIN0(M,J + ML)
         JJ = NUM
         SUM = Y(J)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   21    CONTINUE
         Y(J) = SUM
   22 CONTINUE
      RETURN
      END
      SUBROUTINE CBTPD (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C        PRODUCT OF A COMPLEX VECTOR AND A COMPLEX BANDED MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), X(M), Y(N)
      COMPLEX SUM
C
C     COMPUTE THE FIRST MU COMPONENTS
C
      IF (MU .EQ. 0) GO TO 20
      DO 11 J = 1,MU
         JJ = ML + J
         KMAX = MIN0(M,JJ)
         SUM = (0.0,0.0)
         DO 10 K = 1,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   10    CONTINUE
         Y(J) = SUM
   11 CONTINUE
C
C     COMPUTE THE REMAINING NONZERO COMPONENTS
C
   20 NUM = ML + MU + 1
      JMIN = MU + 1
      JMAX = MIN0(N,M + MU)
      DO 22 J = JMIN,JMAX
         KMIN = J - MU
         KMAX = MIN0(M,J + ML)
         JJ = NUM
         SUM = (0.0,0.0)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   21    CONTINUE
         Y(J) = SUM
   22 CONTINUE
C
C     STORE ZEROS IN THE FINAL N-JMAX COMPONENTS
C
      IF (JMAX .EQ. N) RETURN
      JMIN = JMAX + 1
      DO 30 J = JMIN,N
         Y(J) = (0.0,0.0)
   30 CONTINUE
      RETURN
      END
      SUBROUTINE CBTPD1 (M,N,A,KA,ML,MU,X,Y)
C-----------------------------------------------------------------------
C        SETTING Y = X*A + Y WHERE A IS A COMPLEX BANDED MATRIX
C                     AND X,Y ARE COMPLEX VECTORS
C-----------------------------------------------------------------------
      COMPLEX A(KA,*), X(M), Y(N)
      COMPLEX SUM
C
C     COMPUTE THE FIRST MU COMPONENTS
C
      IF (MU .EQ. 0) GO TO 20
      DO 11 J = 1,MU
         JJ = ML + J
         KMAX = MIN0(M,JJ)
         SUM = Y(J)
         DO 10 K = 1,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   10    CONTINUE
         Y(J) = SUM
   11 CONTINUE
C
C     COMPUTE THE REMAINING COMPONENTS
C
   20 NUM = ML + MU + 1
      JMIN = MU + 1
      JMAX = MIN0(N,M + MU)
      DO 22 J = JMIN,JMAX
         KMIN = J - MU
         KMAX = MIN0(M,J + ML)
         JJ = NUM
         SUM = Y(J)
         DO 21 K = KMIN,KMAX
            SUM = SUM + A(K,JJ)*X(K)
            JJ = JJ - 1
   21    CONTINUE
         Y(J) = SUM
   22 CONTINUE
      RETURN
      END
      REAL FUNCTION BNRM (A, KA, M, N, ML, MU)
C-----------------------------------------------------------------------
C             COMPUTATION OF THE L-INFINITY NORM OF A
C                      REAL BANDED MATRIX A
C-----------------------------------------------------------------------
      REAL A(KA,*)
C
      NUM = ML + MU + 1
      BNRM = 0.0
      DO 20 I = 1,M
         SUM = 0.0
         DO 10 J = 1,NUM
            SUM = SUM + ABS(A(I,J))
   10    CONTINUE
         BNRM = AMAX1(BNRM, SUM)
   20 CONTINUE
      RETURN
      END
      REAL FUNCTION B1NRM (A, KA, M, N, ML, MU)
C-----------------------------------------------------------------------
C            COMPUTATION OF THE L1 NORM OF A BANDED MATRIX A
C-----------------------------------------------------------------------
      REAL A(*)
C
      INCR = KA - 1
      B1NRM = 0.0
C
C     GO DOWN THE FIRST COLUMN OF A
C
      IMIN = ML + 1
      IMAX = MIN0(M, IMIN + MU)
      DO 10 I = IMIN,IMAX
         B1NRM = AMAX1(B1NRM, SASUM(I,A(I),INCR))
   10 CONTINUE
      I = IMAX
      J = I - ML
      NUM = I
      IF (J .EQ. N) RETURN
      IF (I .EQ. M) GO TO 30
C
      IMIN = I + 1
      IMAX = MIN0(M, ML + N)
      DO 20 I = IMIN,IMAX
         B1NRM = AMAX1(B1NRM, SASUM(NUM,A(I),INCR))
   20 CONTINUE
      I = IMAX
      J = I - ML
      GO TO 50
C
C     PROCEED ALONG THE LAST ROW OF A
C
   30 JMAX = MU + 1
      IF (J .EQ. JMAX) GO TO 50
      JMIN = J + 1
      DO 40 J = JMIN,JMAX
         I = I + KA
         B1NRM = AMAX1(B1NRM, SASUM(NUM,A(I),INCR))
   40 CONTINUE
      J = JMAX
C
   50 IF (J .EQ. N .OR. NUM .EQ. 1) RETURN
         I = I + KA
         J = J + 1
         NUM = NUM - 1
         B1NRM = AMAX1(B1NRM, SASUM(NUM,A(I),INCR))
         GO TO 50
      END
      DOUBLE PRECISION FUNCTION DBNRM (A, KA, M, N, ML, MU)
C-----------------------------------------------------------------------
C             COMPUTATION OF THE L-INFINITY NORM OF A
C                DOUBLE PRECISION BANDED MATRIX A
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*)
      DOUBLE PRECISION SUM
C
      NUM = ML + MU + 1
      DBNRM = 0.D0
      DO 20 I = 1,M
         SUM = 0.D0
         DO 10 J = 1,NUM
            SUM = SUM + DABS(A(I,J))
   10    CONTINUE
         DBNRM = DMAX1(DBNRM, SUM)
   20 CONTINUE
      RETURN
      END
      DOUBLE PRECISION FUNCTION DB1NRM (A, KA, M, N, ML, MU)
C-----------------------------------------------------------------------
C            COMPUTATION OF THE L1 NORM OF A DOUBLE PRECISION
C                            BANDED MATRIX A
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*)
      DOUBLE PRECISION DASUM
C
      INCR = KA - 1
      DB1NRM = 0.D0
C
C     GO DOWN THE FIRST COLUMN OF A
C
      IMIN = ML + 1
      IMAX = MIN0(M, IMIN + MU)
      DO 10 I = IMIN,IMAX
         DB1NRM = DMAX1(DB1NRM, DASUM(I,A(I),INCR))
   10 CONTINUE
      I = IMAX
      J = I - ML
      NUM = I
      IF (J .EQ. N) RETURN
      IF (I .EQ. M) GO TO 30
C
      IMIN = I + 1
      IMAX = MIN0(M, ML + N)
      DO 20 I = IMIN,IMAX
         DB1NRM = DMAX1(DB1NRM, DASUM(NUM,A(I),INCR))
   20 CONTINUE
      I = IMAX
      J = I - ML
      GO TO 50
C
C     PROCEED ALONG THE LAST ROW OF A
C
   30 JMAX = MU + 1
      IF (J .EQ. JMAX) GO TO 50
      JMIN = J + 1
      DO 40 J = JMIN,JMAX
         I = I + KA
         DB1NRM = DMAX1(DB1NRM, DASUM(NUM,A(I),INCR))
   40 CONTINUE
      J = JMAX
C
   50 IF (J .EQ. N .OR. NUM .EQ. 1) RETURN
         I = I + KA
         J = J + 1
         NUM = NUM - 1
         DB1NRM = DMAX1(DB1NRM, DASUM(NUM,A(I),INCR))
         GO TO 50
      END
      SUBROUTINE BSLV(M0,A,KA,N,ML,MU,B,IWK,IERR)
C ----------------------------------------------------------------------
C     BSLV EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
C     THE NXN BANDED LINEAR SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
C     IF BSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
C     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
C     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
C     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
C     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
C     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO BSLV.
C
C
C     INPUT ARGUMENTS WHEN M0=0 ---
C
C     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
C               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
C               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
C
C     N         NUMBER OF EQUATIONS AND UNKNOWNS.
C
C     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
C               SIDE DATA.
C
C
C     OUTPUT ARGUMENTS WHEN M0=0 ---
C
C     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
C               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C
C     B         THE SOLUTION OF THE EQUATIONS.
C
C     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
C
C     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
C               IERR=0 IF THE SOLUTION OF AX = B IS OBTAINED.
C               OTHERWISE IERR.NE.0.
C
C
C     AFTER AN INITIAL CALL TO BSLV, THE ROUTINE MAY BE RECALLED
C     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
C     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. BSLV RETRIEVES THE
C     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
C     BSLV AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE IERR
C     IS NOT REFERENCED.
C ----------------------------------------------------------------------
      REAL A(KA,*),B(N)
      INTEGER IWK(N)
      IF (M0 .NE. 0) GO TO 10
C
C     ERROR CHECKING
C
      IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
C     OBTAIN AN LU DECOMPOSITION OF A
C
      CALL SNBFA(A,KA,N,ML,MU,IWK,IERR)
      IF (IERR .NE. 0) RETURN
C
C     SOLVE THE SYSTEM OF EQUATIONS
C
   10 CALL SNBSL(A,KA,N,ML,MU,IWK,B,0)
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE BSLV1(M0,A,KA,N,ML,MU,B,IWK,IERR)
C ----------------------------------------------------------------------
C     BSLV1 EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
C     THE NXN BANDED LINEAR SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
C     IF BSLV1 IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
C     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
C     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
C     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
C     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
C     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO BSLV1.
C
C
C     INPUT ARGUMENTS WHEN M0=0 ---
C
C     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
C               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
C               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
C
C     N         NUMBER OF EQUATIONS AND UNKNOWNS.
C
C     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
C               SIDE DATA.
C
C
C     OUTPUT ARGUMENTS WHEN M0=0 ---
C
C     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
C               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C
C     B         THE SOLUTION OF THE EQUATIONS.
C
C     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
C
C     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
C               IERR=0 IF THE SOLUTION OF XA = B IS OBTAINED.
C               OTHERWISE IERR.NE.0.
C
C
C     AFTER AN INITIAL CALL TO BSLV1, THE ROUTINE MAY BE RECALLED
C     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
C     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. BSLV RETRIEVES THE
C     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
C     BSLV1 AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE IERR
C     IS NOT REFERENCED.
C ----------------------------------------------------------------------
      REAL A(KA,*),B(N)
      INTEGER IWK(N)
      IF (M0 .NE. 0) GO TO 10
C
C     ERROR CHECKING
C
      IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
C     OBTAIN AN LU DECOMPOSITION OF A
C
      CALL SNBFA(A,KA,N,ML,MU,IWK,IERR)
      IF (IERR .NE. 0) RETURN
C
C     SOLVE THE SYSTEM OF EQUATIONS
C
   10 CALL SNBSL(A,KA,N,ML,MU,IWK,B,1)
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE SNBFA (A, LDA, N, ML, MU, IPVT, INFO)
C ----------------------------------------------------------------------
C
C               SNBFA FACTORS A REAL BAND MATRIX BY ELIMINATION.
C
C                               --------
C     ON ENTRY
C
C        A       REAL(LDA, NC)
C                CONTAINS THE MATRIX IN BAND STORAGE. THE ROWS
C                OF THE ORIGINAL MATRIX ARE STORED IN THE ROWS
C                OF A AND THE DIAGONALS OF THE ORIGINAL MATRIX
C                ARE STORED IN COLUMNS 1 THROUGH ML+MU+1 OF A.
C                NC MUST BE .GE. 2*ML+MU+1 .
C                SEE THE COMMENTS BELOW FOR DETAILS.
C
C        LDA     INTEGER
C                THE LEADING DIMENSION OF THE ARRAY A. IT IS
C                ASSUMED THAT LDA .GE. N.
C
C        N       INTEGER
C                THE ORDER OF THE ORIGINAL MATRIX.
C
C        ML      INTEGER
C                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C                0 .LE. ML .LT. N .
C
C        MU      INTEGER
C                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C                0 .LE. MU .LT. N .
C                MORE EFFICIENT IF ML .LE. MU .
C
C     ON RETURN
C
C        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
C                AND THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
C                L IS A PRODUCT OF PERMUTATION AND UNIT LOWER
C                TRIANGULAR MATRICES AND U IS UPPER TRIANGULAR.
C
C        IPVT    INTEGER(N)
C                AN INTEGER VECTOR OF PIVOT INDICES.
C
C        INFO    INTEGER
C                =0  NORMAL VALUE
C                =K  IF  U(K,K) .EQ. 0. THIS IS NOT AN ERROR
C                CONDITION FOR THIS SUBROUTINE, BUT IT DOES
C                INDICATE THAT SNBSL WILL DIVIDE BY ZERO IF
C                IT IS CALLED.
C
C     BAND STORAGE
C
C           IF A0 IS THE MATRIX THEN THE FOLLOWING CODE WILL STORE
C           A0 IN BAND FORM.
C
C                   ML = (BAND WIDTH BELOW THE DIAGONAL)
C                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
C                   DO 20 I = 1, N
C                      J1 = MAX0(1, I-ML)
C                      J2 = MIN0(N, I+MU)
C                      DO 10 J = J1, J2
C                         K = J - I + ML + 1
C                         A(I,K) = A0(I,J)
C                10    CONTINUE
C                20 CONTINUE
C
C           THIS USES COLUMNS 1 THROUGH  ML + MU + 1  OF A.
C           FURTHERMORE, ML ADDITIONAL COLUMNS ARE NEEDED IN
C           A (STARTING WITH COLUMN  ML+MU+2) FOR ELEMENTS
C           GENERATED DURING THE TRIANGULARIZATION. THE TOTAL
C           NUMBER OF COLUMNS NEEDED IN A IS  2*ML+MU+1 .
C
C     EXAMPLE..  IF THE ORIGINAL MATRIX IS
C
C           11 12 13  0  0  0
C           21 22 23 24  0  0
C            0 32 33 34 35  0
C            0  0 43 44 45 46
C            0  0  0 54 55 56
C            0  0  0  0 65 66
C
C      THEN  N = 6, ML = 1, MU = 2, LDA .GE. 6  AND A SHOULD CONTAIN
C
C              11 12 13  +     , + = USED FOR PIVOTING
C           21 22 23 24  +
C           32 33 34 35  +
C           43 44 45 46  +
C           54 55 56  +  +
C           65 66  +  +  +
C
C     WRITTEN BY E.A.VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
C     MODIFIED BY A.H.MORRIS, NAVAL SURFACE WEAPONS CENTER.
C
C     SUBROUTINES AND FUNCTIONS
C        MIN0,ISAMAX,SAXPY,SSCAL,SSWAP
C ----------------------------------------------------------------------
      INTEGER LDA,N,ML,MU,INFO
      REAL A(LDA,*)
      INTEGER IPVT(N)
      REAL T
C
      INFO = 0
      IF (ML .EQ. 0) GO TO 100
      M = ML + MU + 1
C
C     SET FILL-IN COLUMNS TO ZERO
C
      DO 11 J = 1,ML
         JJ = M + J
         DO 10 I = 1,N
            A(I,JJ) = 0.0
   10    CONTINUE
   11 CONTINUE
C
C     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
C
      ML1 = ML + 1
      MB = ML + MU
      N1 = N - 1
      LDB = LDA - 1
      DO 40 K = 1,N1
        LM = MIN0(N-K,ML)
        LMK = LM + K
        LM1 = LM + 1
        LM2 = ML1 - LM
C
C     SEARCH FOR PIVOT INDEX
C
        L = -ISAMAX(LM1, A(LMK,LM2), LDB) + LM1 + K
        IPVT(K) = L
        MP = MIN0(MB,N-K)
C
C     SWAP ROWS IF NECESSARY
C
        LL = ML1 + K - L
        IF (L .NE. K) CALL SSWAP(MP + 1, A(K,ML1), LDA, A(L,LL), LDA)
C
C     SKIP COLUMN REDUCTION IF PIVOT IS ZERO
C
        IF (A(K,ML1) .NE. 0.0) GO TO 20
           INFO = K
           GO TO 40
C
C     COMPUTE MULTIPLIERS
C
   20   T = -1.0/A(K,ML1)
        CALL SSCAL(LM, T, A(LMK,LM2), LDB)
C
C     ROW ELIMINATION WITH COLUMN INDEXING
C
        DO 30 J = 1,MP
           JJ = ML1 + J
           J1 = LM2 + J
           CALL SAXPY(LM, A(K,JJ), A(LMK,LM2), LDB, A(LMK,J1), LDB)
   30   CONTINUE
   40 CONTINUE
C
      IPVT(N) = N
      IF (A(N,ML1) .EQ. 0.0) INFO = N
      RETURN
C
C     CASE WHEN ML = 0
C
  100 DO 110 K = 1,N
        IPVT(K) = K
        IF (A(K,1) .EQ. 0.0) INFO = K
  110 CONTINUE
      RETURN
      END
      SUBROUTINE SNBSL (A,LDA,N,ML,MU,IPVT,B,JOB)
C ----------------------------------------------------------------------
C
C     SNBSL SOLVES THE REAL BAND SYSTEM A*X = B OR TRANS(A)*X = B
C     USING THE FACTORS COMPUTED BY SNBFA.
C
C                         ----------
C     ON ENTRY
C
C        A       REAL(LDA, NC)
C                THE OUTPUT FROM SNBFA.
C                NC MUST BE .GE. 2*ML+MU+1 .
C
C        LDA     INTEGER
C                THE LEADING DIMENSION OF THE ARRAY A.
C
C        N       INTEGER
C                THE ORDER OF THE ORIGINAL MATRIX.
C
C        ML      INTEGER
C                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C        MU      INTEGER
C                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C        IPVT    INTEGER(N)
C                THE PIVOT VECTOR FROM SNBFA.
C
C        B       REAL(N)
C                THE RIGHT HAND SIDE VECTOR.
C
C        JOB     INTEGER
C                = 0         TO SOLVE  A*X = B .
C                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
C                            TRANS(A)  IS THE TRANSPOSE.
C
C     ON RETURN
C
C        B       THE SOLUTION VECTOR  X .
C
C     ERROR CONDITION
C
C        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
C        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
C        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
C        SETTING OF LDA.  IT WILL NOT OCCUR IF SNBFA AND SNBSL ARE
C        CALLED CORRECTLY AND SNBFA HAS SET INFO = 0.
C
C     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
C     MODIFIED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
C
C     SUBROUTINES AND FUNCTIONS
C      SAXPY,SDOT
C
C     FORTRAN  MIN0
C ----------------------------------------------------------------------
      INTEGER LDA,N,ML,MU,JOB
      REAL A(LDA,*),B(N)
      INTEGER IPVT(N)
      REAL SDOT,T
      INTEGER K,KB,KLM,L,LB,LDB,LM,M,MLM,NM1
C
      M = MU + ML + 1
      IF (M .EQ. 1) GO TO 100
      ML1 = ML + 1
      ML2 = ML + 2
      NM1 = N - 1
      LDB = 1 - LDA
      IF (JOB .NE. 0) GO TO 50
C
C     JOB = 0 , SOLVE  A * X = B
C       FIRST SOLVE L*Y = B
C
      IF (ML .EQ. 0) GO TO 30
      DO 20 K = 1,NM1
         LM = MIN0(ML,N-K)
         L = IPVT(K)
         T = B(L)
         IF (L .EQ. K) GO TO 10
            B(L) = B(K)
            B(K) = T
   10    KLM = K + LM
         MLM = ML1 - LM
         CALL SAXPY(LM, T, A(KLM,MLM), LDB, B(K+1), 1)
   20 CONTINUE
C
C       NOW SOLVE  U*X = Y
C
   30 K = N
      DO 40 KB = 2,N
         B(K) = B(K)/A(K,ML1)
         LM = MIN0(K,M) - 1
         LB = K - LM
         T = -B(K)
         CALL SAXPY(LM, T, A(K-1,ML2), LDB, B(LB), 1)
         K = K - 1
   40 CONTINUE
      B(1) = B(1)/A(1,ML1)
      RETURN
C
C     JOB = NONZERO, SOLVE TRANS(A) * X = B
C       FIRST SOLVE  TRANS(U)*Y = B
C
   50 B(1) = B(1)/A(1,ML1)
      DO 60 K = 2,N
         LM = MIN0(K,M) - 1
         LB = K - LM
         T = SDOT(LM, A(K-1,ML2), LDB, B(LB), 1)
         B(K) = (B(K) - T)/A(K,ML1)
   60 CONTINUE
      IF (ML .EQ. 0) RETURN
C
C       NOW SOLVE TRANS(L)*X = Y
C
      DO 70 KB = 1,NM1
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
C
C     CASE WHEN ML = 0 AND MU = 0
C
  100 DO 110 K = 1,N
  110    B(K) = B(K)/A(K,1)
      RETURN
      END
      SUBROUTINE DBSLV (M0,A,KA,N,ML,MU,B,IWK,IERR)
C ----------------------------------------------------------------------
C     DBSLV EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
C     THE NXN BANDED LINEAR SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
C     IF DBSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
C     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
C     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
C     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
C     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
C     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO DBSLV.
C
C
C     INPUT ARGUMENTS WHEN M0=0 ---
C
C     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
C               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
C               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
C
C     N         NUMBER OF EQUATIONS AND UNKNOWNS.
C
C     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
C               SIDE DATA.
C
C
C     OUTPUT ARGUMENTS WHEN M0=0 ---
C
C     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
C               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C
C     B         THE SOLUTION OF THE EQUATIONS.
C
C     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
C
C     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
C               IERR=0 IF THE SOLUTION OF AX = B IS OBTAINED.
C               OTHERWISE IERR.NE.0.
C
C
C     AFTER AN INITIAL CALL TO DBSLV, THE ROUTINE MAY BE RECALLED
C     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
C     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. DBSLV RETRIEVES THE
C     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
C     DBSLV AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE IERR
C     IS NOT REFERENCED.
C ----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), B(N)
      INTEGER IWK(N)
      IF (M0 .NE. 0) GO TO 10
C
C     ERROR CHECKING
C
      IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
C     OBTAIN AN LU DECOMPOSITION OF A
C
      CALL DBFA(A,KA,N,ML,MU,IWK,IERR)
      IF (IERR .NE. 0) RETURN
C
C     SOLVE THE SYSTEM OF EQUATIONS
C
   10 CALL DBSL(A,KA,N,ML,MU,IWK,B,0)
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE DBSLV1 (M0,A,KA,N,ML,MU,B,IWK,IERR)
C ----------------------------------------------------------------------
C     DBSLV1 EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
C     THE NXN BANDED LINEAR SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
C     IF DBSLV1 IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
C     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
C     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
C     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
C     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
C     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO DBSLV1.
C
C
C     INPUT ARGUMENTS WHEN M0=0 ---
C
C     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
C               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
C               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
C
C     N         NUMBER OF EQUATIONS AND UNKNOWNS.
C
C     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C     B         ARRAY OF N ENTRIES CONTAINING THE RIGHT HAND
C               SIDE DATA.
C
C
C     OUTPUT ARGUMENTS WHEN M0=0 ---
C
C     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
C               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C
C     B         THE SOLUTION OF THE EQUATIONS.
C
C     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
C
C     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
C               IERR=0 IF THE SOLUTION OF XA = B IS OBTAINED.
C               OTHERWISE IERR.NE.0.
C
C
C     AFTER AN INITIAL CALL TO DBSLV1, THE ROUTINE MAY BE RECALLED
C     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
C     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. DBSLV RETRIEVES THE
C     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
C     DBSLV1 AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE IERR
C     IS NOT REFERENCED.
C ----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), B(N)
      INTEGER IWK(N)
      IF (M0 .NE. 0) GO TO 10
C
C     ERROR CHECKING
C
      IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
C     OBTAIN AN LU DECOMPOSITION OF A
C
      CALL DBFA(A,KA,N,ML,MU,IWK,IERR)
      IF (IERR .NE. 0) RETURN
C
C     SOLVE THE SYSTEM OF EQUATIONS
C
   10 CALL DBSL(A,KA,N,ML,MU,IWK,B,1)
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE DBFA (A, LDA, N, ML, MU, IPVT, INFO)
C ----------------------------------------------------------------------
C
C               DBFA FACTORS A REAL BAND MATRIX BY ELIMINATION.
C
C                               --------
C     ON ENTRY
C
C        A       DOUBLE PRECISION(LDA, NC)
C                CONTAINS THE MATRIX IN BAND STORAGE. THE ROWS
C                OF THE ORIGINAL MATRIX ARE STORED IN THE ROWS
C                OF A AND THE DIAGONALS OF THE ORIGINAL MATRIX
C                ARE STORED IN COLUMNS 1 THROUGH ML+MU+1 OF A.
C                NC MUST BE .GE. 2*ML+MU+1 .
C                SEE THE COMMENTS BELOW FOR DETAILS.
C
C        LDA     INTEGER
C                THE LEADING DIMENSION OF THE ARRAY A. IT IS
C                ASSUMED THAT LDA .GE. N.
C
C        N       INTEGER
C                THE ORDER OF THE ORIGINAL MATRIX.
C
C        ML      INTEGER
C                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C                0 .LE. ML .LT. N .
C
C        MU      INTEGER
C                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C                0 .LE. MU .LT. N .
C                MORE EFFICIENT IF ML .LE. MU .
C
C     ON RETURN
C
C        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
C                AND THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
C                L IS A PRODUCT OF PERMUTATION AND UNIT LOWER
C                TRIANGULAR MATRICES AND U IS UPPER TRIANGULAR.
C
C        IPVT    INTEGER(N)
C                AN INTEGER VECTOR OF PIVOT INDICES.
C
C        INFO    INTEGER
C                =0  NORMAL VALUE
C                =K  IF  U(K,K) .EQ. 0. THIS IS NOT AN ERROR
C                CONDITION FOR THIS SUBROUTINE, BUT IT DOES
C                INDICATE THAT DBSL WILL DIVIDE BY ZERO IF
C                IT IS CALLED.
C
C     BAND STORAGE
C
C           IF A0 IS THE MATRIX THEN THE FOLLOWING CODE WILL STORE
C           A0 IN BAND FORM.
C
C                   ML = (BAND WIDTH BELOW THE DIAGONAL)
C                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
C                   DO 20 I = 1, N
C                      J1 = MAX0(1, I-ML)
C                      J2 = MIN0(N, I+MU)
C                      DO 10 J = J1, J2
C                         K = J - I + ML + 1
C                         A(I,K) = A0(I,J)
C                10    CONTINUE
C                20 CONTINUE
C
C           THIS USES COLUMNS 1 THROUGH  ML + MU + 1  OF A.
C           FURTHERMORE, ML ADDITIONAL COLUMNS ARE NEEDED IN
C           A (STARTING WITH COLUMN  ML+MU+2) FOR ELEMENTS
C           GENERATED DURING THE TRIANGULARIZATION. THE TOTAL
C           NUMBER OF COLUMNS NEEDED IN A IS  2*ML+MU+1 .
C
C     EXAMPLE..  IF THE ORIGINAL MATRIX IS
C
C           11 12 13  0  0  0
C           21 22 23 24  0  0
C            0 32 33 34 35  0
C            0  0 43 44 45 46
C            0  0  0 54 55 56
C            0  0  0  0 65 66
C
C      THEN  N = 6, ML = 1, MU = 2, LDA .GE. 6  AND A SHOULD CONTAIN
C
C              11 12 13  +     , + = USED FOR PIVOTING
C           21 22 23 24  +
C           32 33 34 35  +
C           43 44 45 46  +
C           54 55 56  +  +
C           65 66  +  +  +
C
C     WRITTEN BY E.A.VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
C     MODIFIED BY A.H.MORRIS, NAVAL SURFACE WEAPONS CENTER.
C
C     SUBROUTINES AND FUNCTIONS
C        MIN0,IDAMAX,DAXPY,DSCAL,DSWAP
C ----------------------------------------------------------------------
      INTEGER LDA,N,ML,MU,INFO
      DOUBLE PRECISION A(LDA,*)
      INTEGER IPVT(N)
      DOUBLE PRECISION T
C
      INFO = 0
      IF (ML .EQ. 0) GO TO 100
      M = ML + MU + 1
C
C     SET FILL-IN COLUMNS TO ZERO
C
      DO 11 J = 1,ML
         JJ = M + J
         DO 10 I = 1,N
            A(I,JJ) = 0.D0
   10    CONTINUE
   11 CONTINUE
C
C     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
C
      ML1 = ML + 1
      MB = ML + MU
      N1 = N - 1
      LDB = LDA - 1
      DO 40 K = 1,N1
        LM = MIN0(N-K,ML)
        LMK = LM + K
        LM1 = LM + 1
        LM2 = ML1 - LM
C
C     SEARCH FOR PIVOT INDEX
C
        L = -IDAMAX(LM1, A(LMK,LM2), LDB) + LM1 + K
        IPVT(K) = L
        MP = MIN0(MB,N-K)
C
C     SWAP ROWS IF NECESSARY
C
        LL = ML1 + K - L
        IF (L .NE. K) CALL DSWAP(MP + 1, A(K,ML1), LDA, A(L,LL), LDA)
C
C     SKIP COLUMN REDUCTION IF PIVOT IS ZERO
C
        IF (A(K,ML1) .NE. 0.D0) GO TO 20
           INFO = K
           GO TO 40
C
C     COMPUTE MULTIPLIERS
C
   20   T = -1.D0/A(K,ML1)
        CALL DSCAL(LM, T, A(LMK,LM2), LDB)
C
C     ROW ELIMINATION WITH COLUMN INDEXING
C
        DO 30 J = 1,MP
           JJ = ML1 + J
           J1 = LM2 + J
           CALL DAXPY(LM, A(K,JJ), A(LMK,LM2), LDB, A(LMK,J1), LDB)
   30   CONTINUE
   40 CONTINUE
C
      IPVT(N) = N
      IF (A(N,ML1) .EQ. 0.D0) INFO = N
      RETURN
C
C     CASE WHEN ML = 0
C
  100 DO 110 K = 1,N
        IPVT(K) = K
        IF (A(K,1) .EQ. 0.D0) INFO = K
  110 CONTINUE
      RETURN
      END
      SUBROUTINE DBSL (A,LDA,N,ML,MU,IPVT,B,JOB)
C ----------------------------------------------------------------------
C
C     DBSL SOLVES THE REAL BAND SYSTEM A*X = B OR TRANS(A)*X = B
C     USING THE FACTORS COMPUTED BY DBFA.
C
C                         ----------
C     ON ENTRY
C
C        A       DOUBLE PRECISION(LDA, NC)
C                THE OUTPUT FROM DBFA.
C                NC MUST BE .GE. 2*ML+MU+1 .
C
C        LDA     INTEGER
C                THE LEADING DIMENSION OF THE ARRAY A.
C
C        N       INTEGER
C                THE ORDER OF THE ORIGINAL MATRIX.
C
C        ML      INTEGER
C                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C        MU      INTEGER
C                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C        IPVT    INTEGER(N)
C                THE PIVOT VECTOR FROM DBFA.
C
C        B       DOUBLE PRECISION(N)
C                THE RIGHT HAND SIDE VECTOR.
C
C        JOB     INTEGER
C                = 0         TO SOLVE  A*X = B .
C                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
C                            TRANS(A)  IS THE TRANSPOSE.
C
C     ON RETURN
C
C        B       THE SOLUTION VECTOR  X .
C
C     ERROR CONDITION
C
C        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
C        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
C        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
C        SETTING OF LDA.  IT WILL NOT OCCUR IF DBFA AND DBSL ARE
C        CALLED CORRECTLY AND DBFA HAS SET INFO = 0.
C
C     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
C     MODIFIED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
C
C     SUBROUTINES AND FUNCTIONS
C      DAXPY,DDOT
C
C     FORTRAN  MIN0
C ----------------------------------------------------------------------
      INTEGER LDA,N,ML,MU,JOB
      DOUBLE PRECISION A(LDA,*),B(N)
      INTEGER IPVT(N)
      DOUBLE PRECISION DDOT,T
      INTEGER K,KB,KLM,L,LB,LDB,LM,M,MLM,NM1
C
      M = MU + ML + 1
      IF (M .EQ. 1) GO TO 100
      ML1 = ML + 1
      ML2 = ML + 2
      NM1 = N - 1
      LDB = 1 - LDA
      IF (JOB .NE. 0) GO TO 50
C
C     JOB = 0 , SOLVE  A * X = B
C       FIRST SOLVE L*Y = B
C
      IF (ML .EQ. 0) GO TO 30
      DO 20 K = 1,NM1
         LM = MIN0(ML,N-K)
         L = IPVT(K)
         T = B(L)
         IF (L .EQ. K) GO TO 10
            B(L) = B(K)
            B(K) = T
   10    KLM = K + LM
         MLM = ML1 - LM
         CALL DAXPY(LM, T, A(KLM,MLM), LDB, B(K+1), 1)
   20 CONTINUE
C
C       NOW SOLVE  U*X = Y
C
   30 K = N
      DO 40 KB = 2,N
         B(K) = B(K)/A(K,ML1)
         LM = MIN0(K,M) - 1
         LB = K - LM
         T = -B(K)
         CALL DAXPY(LM, T, A(K-1,ML2), LDB, B(LB), 1)
         K = K - 1
   40 CONTINUE
      B(1) = B(1)/A(1,ML1)
      RETURN
C
C     JOB = NONZERO, SOLVE TRANS(A) * X = B
C       FIRST SOLVE  TRANS(U)*Y = B
C
   50 B(1) = B(1)/A(1,ML1)
      DO 60 K = 2,N
         LM = MIN0(K,M) - 1
         LB = K - LM
         T = DDOT(LM, A(K-1,ML2), LDB, B(LB), 1)
         B(K) = (B(K) - T)/A(K,ML1)
   60 CONTINUE
      IF (ML .EQ. 0) RETURN
C
C       NOW SOLVE TRANS(L)*X = Y
C
      DO 70 KB = 1,NM1
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
C
C     CASE WHEN ML = 0 AND MU = 0
C
  100 DO 110 K = 1,N
  110    B(K) = B(K)/A(K,1)
      RETURN
      END
      SUBROUTINE B1CND (A, KA, N, ML, MU, COND, IWK, WK, IERR)
C-----------------------------------------------------------------------
C              COMPUTATION OF THE L1 CONDITION NUMBER
C                       OF A BANDED MATRIX A
C-----------------------------------------------------------------------
      REAL A(KA,*), WK(*)
      INTEGER IWK(*)
C-----------------------
C     REAL WK(2*N)
C     INTEGER IWK(2*N)
C-----------------------
      COND = 0.0
      IF (N .LE. 0 .OR. KA .LT. N) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
      ANORM = B1NRM(A, KA, N, N, ML, MU)
      IF (ANORM .EQ. 0.0) GO TO 40
C
      IX = 1
      IV = N + 1
      ISGN = N + 1
C
      KASE = 0
      AINORM = 0.0
      CALL SONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE,
     *             ITER, J, JUMP)
      CALL BSLV (0, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
C
C     CHECK IF A IS SINGULAR
C
      IF (IERR .GT. 0) GO TO 40
C
C     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
C     OF THE INVERSE OF A
C
   10 CALL SONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE,
     *             ITER, J, JUMP)
      IF (KASE .EQ. 0) GO TO 30
      IF (KASE .NE. 1) GO TO 20
         CALL BSLV (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
         GO TO 10
   20 CALL BSLV1 (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
      GO TO 10
C
C     COMPUTE THE VALUE OF COND
C
   30 COND = ANORM*AINORM
      RETURN
C
C     SINGULAR CASE
C
   40 IERR = 1
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE DB1CND (A, KA, N, ML, MU, COND, IWK, WK, IERR)
C-----------------------------------------------------------------------
C            COMPUTATION OF THE L1 CONDITION NUMBER OF
C               A DOUBLE PRECISION BANDED MATRIX A
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(KA,*), COND, WK(*)
      INTEGER IWK(*)
      DOUBLE PRECISION ANORM, AINORM
      DOUBLE PRECISION DB1NRM
C-----------------------
C     DOUBLE PRECISION WK(2*N)
C     INTEGER IWK(2*N)
C-----------------------
      COND = 0.D0
      IF (N .LE. 0 .OR. KA .LT. N) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
      ANORM = DB1NRM(A, KA, N, N, ML, MU)
      IF (ANORM .EQ. 0.D0) GO TO 40
C
      IX = 1
      IV = N + 1
      ISGN = N + 1
C
      KASE = 0
      AINORM = 0.D0
      CALL DONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE,
     *             ITER, J, JUMP)
      CALL DBSLV (0, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
C
C     CHECK IF A IS SINGULAR
C
      IF (IERR .GT. 0) GO TO 40
C
C     GENERAL LOOP TO ESTIMATE THE NORM  AINORM
C     OF THE INVERSE OF A
C
   10 CALL DONEST (N, WK(IV), WK(IX), IWK(ISGN), AINORM, KASE,
     *             ITER, J, JUMP)
      IF (KASE .EQ. 0) GO TO 30
      IF (KASE .NE. 1) GO TO 20
         CALL DBSLV (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
         GO TO 10
   20 CALL DBSLV1 (1, A, KA, N, ML, MU, WK(IX), IWK(1), IERR)
      GO TO 10
C
C     COMPUTE THE VALUE OF COND
C
   30 COND = ANORM*AINORM
      RETURN
C
C     SINGULAR CASE
C
   40 IERR = 1
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE CBSLV(M0,A,KA,N,ML,MU,B,IWK,IERR)
C ----------------------------------------------------------------------
C     CBSLV EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
C     THE NXN COMPLEX BANDED SYSTEM AX = B. THE ARGUMENT M0 SPECIFIES
C     IF CBSLV IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
C     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
C     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
C     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
C     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
C     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO CBSLV.
C
C
C     INPUT ARGUMENTS WHEN M0=0 ---
C
C     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
C               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
C               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
C               A IS A COMPLEX ARRAY.
C
C     N         NUMBER OF EQUATIONS AND UNKNOWNS.
C
C     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C     B         COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT
C               HAND SIDE DATA.
C
C
C     OUTPUT ARGUMENTS WHEN M0=0 ---
C
C     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
C               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C
C     B         THE SOLUTION OF THE EQUATIONS.
C
C     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
C
C     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
C               IERR=0 IF THE SOLUTION OF AX = B IS OBTAINED.
C               OTHERWISE IERR.NE.0.
C
C
C     AFTER AN INITIAL CALL TO CBSLV, THE ROUTINE MAY BE RECALLED
C     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
C     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. CBSLV RETRIEVES THE
C     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
C     CBSLV AND SOLVES THE NEW EQUATIONS AX = B. IN THIS CASE IERR
C     IS NOT REFERENCED.
C ----------------------------------------------------------------------
      COMPLEX A(KA,*),B(N)
      INTEGER IWK(N)
      IF (M0 .NE. 0) GO TO 10
C
C     ERROR CHECKING
C
      IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
C     OBTAIN AN LU DECOMPOSITION OF A
C
      CALL CBFA(A,KA,N,ML,MU,IWK,IERR)
      IF (IERR .NE. 0) RETURN
C
C     SOLVE THE SYSTEM OF EQUATIONS
C
   10 CALL CBSL(A,KA,N,ML,MU,IWK,B,0)
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE CBSLV1(M0,A,KA,N,ML,MU,B,IWK,IERR)
C ----------------------------------------------------------------------
C     CBSLV1 EMPLOYS GAUSS ELIMINATION WITH ROW INTERCHANGES TO SOLVE
C     THE NXN COMPLEX BANDED SYSTEM XA = B. THE ARGUMENT M0 SPECIFIES
C     IF CBSLV1 IS BEING CALLED FOR THE FIRST TIME, OR IF IT IS BEING
C     RECALLED WHERE A IS THE SAME MATRIX BUT B HAS BEEN MODIFIED.
C     ON AN INITIAL CALL TO THE ROUTINE (WHEN M0=0) AN LU DECOMPO-
C     SITION OF A IS OBTAINED AND THEN THE EQUATIONS ARE SOLVED.
C     ON SUBSEQUENT CALLS (WHEN M0.NE.0) THE EQUATIONS ARE SOLVED
C     USING THE DECOMPOSITION OBTAINED ON THE INITIAL CALL TO CBSLV1.
C
C
C     INPUT ARGUMENTS WHEN M0=0 ---
C
C     A,KA      2-DIMENSIONAL ARRAY OF DIMENSION (KA,M) WHERE
C               KA.GE.N AND M.GE.2*ML+MU+1. THE FIRST ML+MU+1
C               COLUMNS CONTAIN THE MATRIX A IN BANDED FORM.
C               A IS A COMPLEX ARRAY.
C
C     N         NUMBER OF EQUATIONS AND UNKNOWNS.
C
C     ML        NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C     MU        NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C     B         COMPLEX ARRAY OF N ENTRIES CONTAINING THE RIGHT
C               HAND SIDE DATA.
C
C
C     OUTPUT ARGUMENTS WHEN M0=0 ---
C
C     A         AN UPPER TIANGULAR MATRIX IN BAND STORAGE AND
C               THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C
C     B         THE SOLUTION OF THE EQUATIONS.
C
C     IWK       ARRAY OF LENGTH N CONTAINING THE PIVOT INDICES.
C
C     IERR      INTEGER SPECIFYING THE STATUS OF THE RESULTS.
C               IERR=0 IF THE SOLUTION OF XA = B IS OBTAINED.
C               OTHERWISE IERR.NE.0.
C
C
C     AFTER AN INITIAL CALL TO CBSLV1, THE ROUTINE MAY BE RECALLED
C     WITH M0.NE.0 FOR A NEW B. WHEN M0.NE.0 IT IS ASSUMED THAT
C     A,KA,N,ML,MU,IWK HAVE NOT BEEN MODIFIED. CBSLV RETRIEVES THE
C     LU DECOMPOSITION WHICH WAS OBTAINED ON THE INITIAL CALL TO
C     CBSLV1 AND SOLVES THE NEW EQUATIONS XA = B. IN THIS CASE IERR
C     IS NOT REFERENCED.
C ----------------------------------------------------------------------
      COMPLEX A(KA,*),B(N)
      INTEGER IWK(N)
      IF (M0 .NE. 0) GO TO 10
C
C     ERROR CHECKING
C
      IF (N .LE. 0 .OR. N .GT. KA) GO TO 100
      IF (ML .LT. 0 .OR. ML .GE. N) GO TO 110
      IF (MU .LT. 0 .OR. MU .GE. N) GO TO 120
C
C     OBTAIN AN LU DECOMPOSITION OF A
C
      CALL CBFA(A,KA,N,ML,MU,IWK,IERR)
      IF (IERR .NE. 0) RETURN
C
C     SOLVE THE SYSTEM OF EQUATIONS
C
   10 CALL CBSL(A,KA,N,ML,MU,IWK,B,1)
      RETURN
C
C     ERROR RETURN
C
  100 IERR = -1
      RETURN
  110 IERR = -2
      RETURN
  120 IERR = -3
      RETURN
      END
      SUBROUTINE CBFA (A, LDA, N, ML, MU, IPVT, INFO)
C ----------------------------------------------------------------------
C
C               CBFA FACTORS A COMPLEX BAND MATRIX BY ELIMINATION.
C
C                              ----------
C     ON ENTRY
C
C        A       COMPLEX(LDA, NC)
C                CONTAINS THE MATRIX IN BAND STORAGE. THE ROWS
C                OF THE ORIGINAL MATRIX ARE STORED IN THE ROWS
C                OF A AND THE DIAGONALS OF THE ORIGINAL MATRIX
C                ARE STORED IN COLUMNS 1 THROUGH ML+MU+1 OF A.
C                NC MUST BE .GE. 2*ML+MU+1 .
C                SEE THE COMMENTS BELOW FOR DETAILS.
C
C        LDA     INTEGER
C                THE LEADING DIMENSION OF THE ARRAY A. IT IS
C                ASSUMED THAT LDA .GE. N.
C
C        N       INTEGER
C                THE ORDER OF THE ORIGINAL MATRIX.
C
C        ML      INTEGER
C                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C                0 .LE. ML .LT. N .
C
C        MU      INTEGER
C                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C                0 .LE. MU .LT. N .
C                MORE EFFICIENT IF ML .LE. MU .
C
C     ON RETURN
C
C        A       AN UPPER TRIANGULAR MATRIX IN BAND STORAGE
C                AND THE MULTIPLIERS WHICH WERE USED TO OBTAIN IT.
C                THE FACTORIZATION CAN BE WRITTEN  A = L*U  WHERE
C                L IS A PRODUCT OF PERMUTATION AND UNIT LOWER
C                TRIANGULAR MATRICES AND U IS UPPER TRIANGULAR.
C
C        IPVT    INTEGER(N)
C                AN INTEGER VECTOR OF PIVOT INDICES.
C
C        INFO    INTEGER
C                =0  NORMAL VALUE
C                =K  IF  U(K,K) .EQ. 0. THIS IS NOT AN ERROR
C                CONDITION FOR THIS SUBROUTINE, BUT IT DOES
C                INDICATE THAT CBSL WILL DIVIDE BY ZERO IF
C                IT IS CALLED.
C
C     BAND STORAGE
C
C           IF A0 IS THE MATRIX THEN THE FOLLOWING CODE WILL STORE
C           A0 IN BAND FORM.
C
C                   ML = (BAND WIDTH BELOW THE DIAGONAL)
C                   MU = (BAND WIDTH ABOVE THE DIAGONAL)
C                   DO 20 I = 1, N
C                      J1 = MAX0(1, I-ML)
C                      J2 = MIN0(N, I+MU)
C                      DO 10 J = J1, J2
C                         K = J - I + ML + 1
C                         A(I,K) = A0(I,J)
C                10    CONTINUE
C                20 CONTINUE
C
C           THIS USES COLUMNS 1 THROUGH  ML + MU + 1  OF A.
C           FURTHERMORE, ML ADDITIONAL COLUMNS ARE NEEDED IN
C           A (STARTING WITH COLUMN  ML+MU+2) FOR ELEMENTS
C           GENERATED DURING THE TRIANGULARIZATION. THE TOTAL
C           NUMBER OF COLUMNS NEEDED IN A IS  2*ML+MU+1 .
C
C     EXAMPLE..  IF THE ORIGINAL MATRIX IS
C
C           11 12 13  0  0  0
C           21 22 23 24  0  0
C            0 32 33 34 35  0
C            0  0 43 44 45 46
C            0  0  0 54 55 56
C            0  0  0  0 65 66
C
C      THEN  N = 6, ML = 1, MU = 2, LDA .GE. 6  AND A SHOULD CONTAIN
C
C              11 12 13  +     , + = USED FOR PIVOTING
C           21 22 23 24  +
C           32 33 34 35  +
C           43 44 45 46  +
C           54 55 56  +  +
C           65 66  +  +  +
C
C     WRITTEN BY E.A.VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
C     MODIFIED BY A.H.MORRIS, NAVAL SURFACE WEAPONS CENTER.
C
C     SUBROUTINES AND FUNCTIONS
C        MIN0,ICAMAX,CAXPY,CSCAL,CSWAP
C ----------------------------------------------------------------------
      INTEGER LDA,N,ML,MU,INFO
      COMPLEX A(LDA,*)
      INTEGER IPVT(N)
      COMPLEX T
C
      INFO = 0
      IF (ML .EQ. 0) GO TO 100
      M = ML + MU + 1
C
C     SET FILL-IN COLUMNS TO ZERO
C
      DO 11 J = 1,ML
         JJ = M + J
         DO 10 I = 1,N
            A(I,JJ) = (0.0,0.0)
   10    CONTINUE
   11 CONTINUE
C
C     GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
C
      ML1 = ML + 1
      MB = ML + MU
      N1 = N - 1
      LDB = LDA - 1
      DO 40 K = 1,N1
        LM = MIN0(N-K,ML)
        LMK = LM + K
        LM1 = LM + 1
        LM2 = ML1 - LM
C
C     SEARCH FOR PIVOT INDEX
C
        L = -ICAMAX(LM1, A(LMK,LM2), LDB) + LM1 + K
        IPVT(K) = L
        MP = MIN0(MB,N-K)
C
C     SWAP ROWS IF NECESSARY
C
        LL = ML1 + K - L
        IF (L .NE. K) CALL CSWAP(MP + 1, A(K,ML1), LDA, A(L,LL), LDA)
C
C     SKIP COLUMN REDUCTION IF PIVOT IS ZERO
C
        IF (A(K,ML1) .NE. (0.0,0.0)) GO TO 20
           INFO = K
           GO TO 40
C
C     COMPUTE MULTIPLIERS
C
   20   T = (-1.0,0.0)/A(K,ML1)
        CALL CSCAL(LM, T, A(LMK,LM2), LDB)
C
C     ROW ELIMINATION WITH COLUMN INDEXING
C
        DO 30 J = 1,MP
           JJ = ML1 + J
           J1 = LM2 + J
           CALL CAXPY(LM, A(K,JJ), A(LMK,LM2), LDB, A(LMK,J1), LDB)
   30   CONTINUE
   40 CONTINUE
C
      IPVT(N) = N
      IF (A(N,ML1) .EQ. (0.0,0.0)) INFO = N
      RETURN
C
C     CASE WHEN ML = 0
C
  100 DO 110 K = 1,N
        IPVT(K) = K
        IF (A(K,1) .EQ. (0.0,0.0)) INFO = K
  110 CONTINUE
      RETURN
      END
      SUBROUTINE CBSL (A,LDA,N,ML,MU,IPVT,B,JOB)
C ----------------------------------------------------------------------
C
C     CBSL SOLVES THE COMPLEX BAND SYSTEM A*X = B OR TRANS(A)*X = B
C     USING THE FACTORS COMPUTED BY CBFA.
C
C                         ----------
C     ON ENTRY
C
C        A       COMPLEX(LDA, NC)
C                THE OUTPUT FROM CBFA.
C                NC MUST BE .GE. 2*ML+MU+1 .
C
C        LDA     INTEGER
C                THE LEADING DIMENSION OF THE ARRAY A.
C
C        N       INTEGER
C                THE ORDER OF THE ORIGINAL MATRIX.
C
C        ML      INTEGER
C                NUMBER OF DIAGONALS BELOW THE MAIN DIAGONAL.
C
C        MU      INTEGER
C                NUMBER OF DIAGONALS ABOVE THE MAIN DIAGONAL.
C
C        IPVT    INTEGER(N)
C                THE PIVOT VECTOR FROM CBFA.
C
C        B       COMPLEX(N)
C                THE RIGHT HAND SIDE VECTOR.
C
C        JOB     INTEGER
C                = 0         TO SOLVE  A*X = B .
C                = NONZERO   TO SOLVE  TRANS(A)*X = B , WHERE
C                            TRANS(A)  IS THE TRANSPOSE.
C
C     ON RETURN
C
C        B       THE SOLUTION VECTOR  X .
C
C     ERROR CONDITION
C
C        A DIVISION BY ZERO WILL OCCUR IF THE INPUT FACTOR CONTAINS A
C        ZERO ON THE DIAGONAL.  TECHNICALLY THIS INDICATES SINGULARITY
C        BUT IT IS OFTEN CAUSED BY IMPROPER ARGUMENTS OR IMPROPER
C        SETTING OF LDA.  IT WILL NOT OCCUR IF CBFA AND CBSL ARE
C        CALLED CORRECTLY AND CBFA HAS SET INFO = 0.
C
C     WRITTEN BY E.A. VOORHEES, LOS ALAMOS SCIENTIFIC LABORATORY.
C     ADAPTED BY A.H. MORRIS, NAVAL SURFACE WEAPONS CENTER.
C
C     SUBROUTINES AND FUNCTIONS
C      CAXPY,CDOTU
C
C     FORTRAN  MIN0
C ----------------------------------------------------------------------
      INTEGER LDA,N,ML,MU,JOB
      COMPLEX A(LDA,*),B(N)
      INTEGER IPVT(N)
      COMPLEX CDOTU,T
      INTEGER K,KB,KLM,L,LB,LDB,LM,M,MLM,NM1
C
      M = MU + ML + 1
      IF (M .EQ. 1) GO TO 100
      ML1 = ML + 1
      ML2 = ML + 2
      NM1 = N - 1
      LDB = 1 - LDA
      IF (JOB .NE. 0) GO TO 50
C
C     JOB = 0 , SOLVE  A * X = B
C       FIRST SOLVE L*Y = B
C
      IF (ML .EQ. 0) GO TO 30
      DO 20 K = 1,NM1
         LM = MIN0(ML,N-K)
         L = IPVT(K)
         T = B(L)
         IF (L .EQ. K) GO TO 10
            B(L) = B(K)
            B(K) = T
   10    KLM = K + LM
         MLM = ML1 - LM
         CALL CAXPY(LM, T, A(KLM,MLM), LDB, B(K+1), 1)
   20 CONTINUE
C
C       NOW SOLVE  U*X = Y
C
   30 K = N
      DO 40 KB = 2,N
         B(K) = B(K)/A(K,ML1)
         LM = MIN0(K,M) - 1
         LB = K - LM
         T = -B(K)
         CALL CAXPY(LM, T, A(K-1,ML2), LDB, B(LB), 1)
         K = K - 1
   40 CONTINUE
      B(1) = B(1)/A(1,ML1)
      RETURN
C
C     JOB = NONZERO, SOLVE TRANS(A) * X = B
C       FIRST SOLVE  TRANS(U)*Y = B
C
   50 B(1) = B(1)/A(1,ML1)
      DO 60 K = 2,N
         LM = MIN0(K,M) - 1
         LB = K - LM
         T = CDOTU(LM, A(K-1,ML2), LDB, B(LB), 1)
         B(K) = (B(K) - T)/A(K,ML1)
   60 CONTINUE
      IF (ML .EQ. 0) RETURN
C
C       NOW SOLVE TRANS(L)*X = Y
C
      DO 70 KB = 1, NM1
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
C
C     CASE WHEN ML = 0 AND MU = 0
C
  100 DO 110 K = 1,N
  110    B(K) = B(K)/A(K,1)
      RETURN
      END
      SUBROUTINE CVRS (A, KA, M, N, B, IB, JB, NUM, IERR)
      REAL A(KA,N), B(*)
      INTEGER IB(*), JB(*)
C
C                 STORE THE I-TH ROW
C
      IP = 1
      DO 11 I = 1,M
         IB(I) = IP
         DO 10 J = 1,N
            IF (A(I,J) .EQ. 0.0) GO TO 10
            IF (IP .GT. NUM) GO TO 20
            B(IP) = A(I,J)
            JB(IP) = J
            IP = IP + 1
   10    CONTINUE
   11 CONTINUE
C
C                 COMPLETE THE SETUP
C
      IB(M + 1) = IP
      IERR = 0
      RETURN
C
C                   ERROR RETURN
C
   20 IERR = I
      RETURN
      END
      SUBROUTINE CVDS (A, KA, M, N, B, IB, JB, NUM, IERR)
      DOUBLE PRECISION A(KA,N), B(*)
      INTEGER IB(*), JB(*)
C
C                 STORE THE I-TH ROW
C
      IP = 1
      DO 11 I = 1,M
         IB(I) = IP
         DO 10 J = 1,N
            IF (A(I,J) .EQ. 0.D0) GO TO 10
            IF (IP .GT. NUM) GO TO 20
            B(IP) = A(I,J)
            JB(IP) = J
            IP = IP + 1
   10    CONTINUE
   11 CONTINUE
C
C                 COMPLETE THE SETUP
C
      IB(M + 1) = IP
      IERR = 0
      RETURN
C
C                   ERROR RETURN
C
   20 IERR = I
      RETURN
      END
      SUBROUTINE CVCS (A, KA, M, N, B, IB, JB, NUM, IERR)
      COMPLEX A(KA,N), B(*), ZERO
      INTEGER IB(*), JB(*)
      DATA ZERO /(0.0,0.0)/
C
C                 STORE THE I-TH ROW
C
      IP = 1
      DO 11 I = 1,M
         IB(I) = IP
         DO 10 J = 1,N
            IF (A(I,J) .EQ. ZERO) GO TO 10
            IF (IP .GT. NUM) GO TO 20
            B(IP) = A(I,J)
            JB(IP) = J
            IP = IP + 1
   10    CONTINUE
   11 CONTINUE
C
C                 COMPLETE THE SETUP
C
      IB(M + 1) = IP
      IERR = 0
      RETURN
C
C                   ERROR RETURN
C
   20 IERR = I
      RETURN
      END
      SUBROUTINE CVSR (A, IA, JA, B, KB, M, N)
      REAL A(*), B(KB,N)
      INTEGER IA(*), JA(*)
C
      DO 30 I = 1,M
C
C                 CLEAR THE I-TH ROW
C
         DO 10 J = 1,N
            B(I,J) = 0.0
   10    CONTINUE
C
C                 STORE THE I-TH ROW
C
         IPMIN = IA(I)
         IPMAX = IA(I+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 30
         DO 20 IP = IPMIN,IPMAX
            J = JA(IP)
            B(I,J) = A(IP)
   20    CONTINUE
C
   30 CONTINUE
      RETURN
      END
      SUBROUTINE CVSD (A, IA, JA, B, KB, M, N)
      DOUBLE PRECISION A(*), B(KB,N)
      INTEGER IA(*), JA(*)
C
      DO 30 I = 1,M
C
C                 CLEAR THE I-TH ROW
C
         DO 10 J = 1,N
            B(I,J) = 0.D0
   10    CONTINUE
C
C                 STORE THE I-TH ROW
C
         IPMIN = IA(I)
         IPMAX = IA(I+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 30
         DO 20 IP = IPMIN,IPMAX
            J = JA(IP)
            B(I,J) = A(IP)
   20    CONTINUE
C
   30 CONTINUE
      RETURN
      END
      SUBROUTINE CVSC (A, IA, JA, B, KB, M, N)
      COMPLEX A(*), B(KB,N)
      INTEGER IA(*), JA(*)
C
      DO 30 I = 1,M
C
C                 CLEAR THE I-TH ROW
C
         DO 10 J = 1,N
            B(I,J) = (0.0,0.0)
   10    CONTINUE
C
C                 STORE THE I-TH ROW
C
         IPMIN = IA(I)
         IPMAX = IA(I+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 30
         DO 20 IP = IPMIN,IPMAX
            J = JA(IP)
            B(I,J) = A(IP)
   20    CONTINUE
C
   30 CONTINUE
      RETURN
      END
      SUBROUTINE SCVRD (A, IA, JA, B, IB, JB, M)
      REAL A(*)
      DOUBLE PRECISION B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
      L = 1
      DO 20 I = 1,M
         IB(I) = L
         IBEG = IA(I)
         IEND = IA(I+1) - 1
         IF (IBEG .GT. IEND) GO TO 20
         DO 10 IP = IBEG,IEND
            IF (A(IP) .EQ. 0.0) GO TO 10
            B(L) = A(IP)
            JB(L) = JA(IP)
            L = L + 1
   10    CONTINUE
   20 CONTINUE
      IB(M + 1) = L
      RETURN
      END
      SUBROUTINE SCVDR (A, IA, JA, B, IB, JB, M)
      DOUBLE PRECISION A(*)
      REAL B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
      L = 1
      DO 20 I = 1,M
         IB(I) = L
         IBEG = IA(I)
         IEND = IA(I+1) - 1
         IF (IBEG .GT. IEND) GO TO 20
         DO 10 IP = IBEG,IEND
            IF (A(IP) .EQ. 0.D0) GO TO 10
            B(L) = A(IP)
            JB(L) = JA(IP)
            L = L + 1
   10    CONTINUE
   20 CONTINUE
      IB(M + 1) = L
      RETURN
      END
      SUBROUTINE CSREAL (A, IA, JA, B, IB, JB, M)
C-----------------------------------------------------------------------
C              REAL PART OF A SPARSE COMPLEX MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(*)
      REAL B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
      L = 1
      DO 20 I = 1,M
         IB(I) = L
         IBEG = IA(I)
         IEND = IA(I+1) - 1
         IF (IBEG .GT. IEND) GO TO 20
         DO 10 IP = IBEG,IEND
            T = REAL(A(IP))
            IF (T .EQ. 0.0) GO TO 10
            B(L) = T
            JB(L) = JA(IP)
            L = L + 1
   10    CONTINUE
   20 CONTINUE
      IB(M + 1) = L
      RETURN
      END
      SUBROUTINE CSIMAG (A, IA, JA, B, IB, JB, M)
C-----------------------------------------------------------------------
C            IMAGINARY PART OF A SPARSE COMPLEX MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(*)
      REAL B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
      L = 1
      DO 20 I = 1,M
         IB(I) = L
         IBEG = IA(I)
         IEND = IA(I+1) - 1
         IF (IBEG .GT. IEND) GO TO 20
         DO 10 IP = IBEG,IEND
            T = AIMAG(A(IP))
            IF (T .EQ. 0.0) GO TO 10
            B(L) = T
            JB(L) = JA(IP)
            L = L + 1
   10    CONTINUE
   20 CONTINUE
      IB(M + 1) = L
      RETURN
      END
      SUBROUTINE SCVRC (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C       COMPUTE A + BI FOR THE SPARSE REAL MATRICES A AND B
C-----------------------------------------------------------------------
      REAL A(*), B(*), WK(N)
      COMPLEX C(*), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 J = 1,N
         WK(J) = 0.0
   10 CONTINUE
C
C                  COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 42 I = 1,M
         IC(I) = IP
         MINA = IA(I)
         MAXA = IA(I+1) - 1
         IF (MINA .GT. MAXA) GO TO 30
         DO 20 L = MINA,MAXA
            J = JA(L)
            WK(J) = A(L)
   20    CONTINUE
C
   30    MINB = IB(I)
         MAXB = IB(I+1) - 1
         IF (MINB .GT. MAXB) GO TO 40
         DO 31 L = MINB,MAXB
            IF (B(L) .EQ. 0.0) GO TO 31
            J = JB(L)
            T = CMPLX (WK(J), B(L))
            WK(J) = 0.0
            IF (IP .GT. NUM) GO TO 50
            C(IP) = T
            JC(IP) = J
            IP = IP + 1
   31    CONTINUE
C
   40    IF (MINA .GT. MAXA) GO TO 42
         DO 41 L = MINA,MAXA
            J = JA(L)
            IF (WK(J) .EQ. 0.0) GO TO 41
            IF (IP .GT. NUM) GO TO 50
            C(IP) = CMPLX (WK(J), 0.0)
            WK(J) = 0.0
            JC(IP) = J
            IP = IP + 1
   41    CONTINUE
   42 CONTINUE
      IC(M + 1) = IP
      IERR = 0
      RETURN
C
C                        ERROR RETURN
C
   50 IERR = I
      RETURN
      END
      SUBROUTINE RSCOPY (A, IA, JA, B, IB, JB, M)
C-----------------------------------------------------------------------
C                  COPYING A SPARSE REAL MATRIX
C-----------------------------------------------------------------------
      REAL A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
      L = 1
      DO 20 I = 1,M
         IB(I) = L
         IBEG = IA(I)
         IEND = IA(I+1) - 1
         IF (IBEG .GT. IEND) GO TO 20
         DO 10 IP = IBEG,IEND
            IF (A(IP) .EQ. 0.0) GO TO 10
            B(L) = A(IP)
            JB(L) = JA(IP)
            L = L + 1
   10    CONTINUE
   20 CONTINUE
      IB(M + 1) = L
      RETURN
      END
      SUBROUTINE DSCOPY (A, IA, JA, B, IB, JB, M)
C-----------------------------------------------------------------------
C              COPYING A SPARSE DOUBLE PRECISION MATRIX
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
      L = 1
      DO 20 I = 1,M
         IB(I) = L
         IBEG = IA(I)
         IEND = IA(I+1) - 1
         IF (IBEG .GT. IEND) GO TO 20
         DO 10 IP = IBEG,IEND
            IF (A(IP) .EQ. 0.D0) GO TO 10
            B(L) = A(IP)
            JB(L) = JA(IP)
            L = L + 1
   10    CONTINUE
   20 CONTINUE
      IB(M + 1) = L
      RETURN
      END
      SUBROUTINE CSCOPY (A, IA, JA, B, IB, JB, M)
C-----------------------------------------------------------------------
C                 COPYING A SPARSE COMPLEX MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(*), B(*), ZERO
      INTEGER IA(*), JA(*), IB(*), JB(*)
      DATA ZERO /(0.0,0.0)/
C
      L = 1
      DO 20 I = 1,M
         IB(I) = L
         IBEG = IA(I)
         IEND = IA(I+1) - 1
         IF (IBEG .GT. IEND) GO TO 20
         DO 10 IP = IBEG,IEND
            IF (A(IP) .EQ. ZERO) GO TO 10
            B(L) = A(IP)
            JB(L) = JA(IP)
            L = L + 1
   10    CONTINUE
   20 CONTINUE
      IB(M + 1) = L
      RETURN
      END
      SUBROUTINE SCONJ (A, IA, JA, B, IB, JB, M)
C-----------------------------------------------------------------------
C     COMPUTATION OF THE CONJUGATE OF A SPARSE COMPLEX MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
      MP1 = M + 1
      L = IA(1) - 1
      DO 10 I = 1,MP1
         IB(I) = IA(I) - L
   10 CONTINUE
C
      IBEG = IA(1)
      IEND = IA(MP1) - 1
      IF (IBEG .GT. IEND) RETURN
      L = 1
      DO 20 IP = IBEG,IEND
         B(L) = CONJG(A(IP))
         JB(L) = JA(IP)
         L = L + 1
   20 CONTINUE
      RETURN
      END
      SUBROUTINE RPOSE (A, IA, JA, B, IB, JB, M, N)
C-----------------------------------------------------------------------
C                 TRANSPOSING A SPARSE REAL MATRIX
C-----------------------------------------------------------------------
      REAL A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
C           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
C                 OF A AND STORE THE RESULTS IN IB
C
      IPMIN = IA(1)
      IPMAX = IA(M+1) - 1
      IF (IPMIN .GT. IPMAX) GO TO 40
      DO 10 J = 1,N
         IB(J) = 0
   10 CONTINUE
      DO 11 IP = IPMIN,IPMAX
         J = JA(IP)
         IB(J) = IB(J) + 1
   11 CONTINUE
C
C          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
C                AND STORE THEM IN IB(2),...,IB(N+1)
C
      NUM = IA(M+1) - IA(1) + 1
      J = N
      DO 20 JJ = 1,N
         NUM = NUM - IB(J)
         IB(J+1) = NUM
         J = J - 1
   20 CONTINUE
C
C                STORE THE I-TH ROW OF A IN B AND JB
C                  AND UPDATE THE POINTERS IN IB
C
      DO 31 I = 1,M
         IPMIN = IA(I)
         IPMAX = IA(I+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 31
         DO 30 IP = IPMIN,IPMAX
            J = JA(IP)
            JP = IB(J+1)
            JB(JP) = I
            B(JP) = A(IP)
            IB(J+1) = JP + 1
   30    CONTINUE
   31 CONTINUE
      IB(1) = 1
      RETURN
C
C                    TRANSPOSE A ZERO MATRIX A
C
   40 NP1 = N + 1
      DO 41 J = 1,NP1
         IB(J) = 1
   41 CONTINUE
      RETURN
      END
      SUBROUTINE RPOSE1 (P, A, IA, JA, B, IB, JB, M, N)
C-----------------------------------------------------------------------
C                 TRANSPOSING A SPARSE REAL MATRIX
C                 WHERE THE ROWS ARE INTERCHANGED
C-----------------------------------------------------------------------
      INTEGER P(M)
      REAL A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
C           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
C                 OF A AND STORE THE RESULTS IN IB
C
      IPMIN = IA(1)
      IPMAX = IA(M+1) - 1
      IF (IPMIN .GT. IPMAX) GO TO 40
      DO 10 J = 1,N
         IB(J) = 0
   10 CONTINUE
      DO 11 IP = IPMIN,IPMAX
         J = JA(IP)
         IB(J) = IB(J) + 1
   11 CONTINUE
C
C          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
C                AND STORE THEM IN IB(2),...,IB(N+1)
C
      NUM = IA(M+1) - IA(1) + 1
      J = N
      DO 20 JJ = 1,N
         NUM = NUM - IB(J)
         IB(J+1) = NUM
         J = J - 1
   20 CONTINUE
C
C                STORE THE I-TH ROW OF A IN B AND JB
C                  AND UPDATE THE POINTERS IN IB
C
      DO 31 I = 1,M
         II = P(I)
         IPMIN = IA(II)
         IPMAX = IA(II+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 31
         DO 30 IP = IPMIN,IPMAX
            J = JA(IP)
            JP = IB(J+1)
            JB(JP) = I
            B(JP) = A(IP)
            IB(J+1) = JP + 1
   30    CONTINUE
   31 CONTINUE
      IB(1) = 1
      RETURN
C
C                    TRANSPOSE A ZERO MATRIX A
C
   40 NP1 = N + 1
      DO 41 J = 1,NP1
         IB(J) = 1
   41 CONTINUE
      RETURN
      END
      SUBROUTINE DPOSE (A, IA, JA, B, IB, JB, M, N)
C-----------------------------------------------------------------------
C           TRANSPOSING A SPARSE DOUBLE PRECISION MATRIX
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
C           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
C                 OF A AND STORE THE RESULTS IN IB
C
      IPMIN = IA(1)
      IPMAX = IA(M+1) - 1
      IF (IPMIN .GT. IPMAX) GO TO 40
      DO 10 J = 1,N
         IB(J) = 0
   10 CONTINUE
      DO 11 IP = IPMIN,IPMAX
         J = JA(IP)
         IB(J) = IB(J) + 1
   11 CONTINUE
C
C          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
C                AND STORE THEM IN IB(2),...,IB(N+1)
C
      NUM = IA(M+1) - IA(1) + 1
      J = N
      DO 20 JJ = 1,N
         NUM = NUM - IB(J)
         IB(J+1) = NUM
         J = J - 1
   20 CONTINUE
C
C                STORE THE I-TH ROW OF A IN B AND JB
C                  AND UPDATE THE POINTERS IN IB
C
      DO 31 I = 1,M
         IPMIN = IA(I)
         IPMAX = IA(I+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 31
         DO 30 IP = IPMIN,IPMAX
            J = JA(IP)
            JP = IB(J+1)
            JB(JP) = I
            B(JP) = A(IP)
            IB(J+1) = JP + 1
   30    CONTINUE
   31 CONTINUE
      IB(1) = 1
      RETURN
C
C                    TRANSPOSE A ZERO MATRIX A
C
   40 NP1 = N + 1
      DO 41 J = 1,NP1
         IB(J) = 1
   41 CONTINUE
      RETURN
      END
      SUBROUTINE DPOSE1 (P, A, IA, JA, B, IB, JB, M, N)
C-----------------------------------------------------------------------
C           TRANSPOSING A SPARSE DOUBLE PRECISION MATRIX
C                 WHERE THE ROWS ARE INTERCHANGED
C-----------------------------------------------------------------------
      INTEGER P(M)
      DOUBLE PRECISION A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
C           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
C                 OF A AND STORE THE RESULTS IN IB
C
      IPMIN = IA(1)
      IPMAX = IA(M+1) - 1
      IF (IPMIN .GT. IPMAX) GO TO 40
      DO 10 J = 1,N
         IB(J) = 0
   10 CONTINUE
      DO 11 IP = IPMIN,IPMAX
         J = JA(IP)
         IB(J) = IB(J) + 1
   11 CONTINUE
C
C          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
C                AND STORE THEM IN IB(2),...,IB(N+1)
C
      NUM = IA(M+1) - IA(1) + 1
      J = N
      DO 20 JJ = 1,N
         NUM = NUM - IB(J)
         IB(J+1) = NUM
         J = J - 1
   20 CONTINUE
C
C                STORE THE I-TH ROW OF A IN B AND JB
C                  AND UPDATE THE POINTERS IN IB
C
      DO 31 I = 1,M
         II = P(I)
         IPMIN = IA(II)
         IPMAX = IA(II+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 31
         DO 30 IP = IPMIN,IPMAX
            J = JA(IP)
            JP = IB(J+1)
            JB(JP) = I
            B(JP) = A(IP)
            IB(J+1) = JP + 1
   30    CONTINUE
   31 CONTINUE
      IB(1) = 1
      RETURN
C
C                    TRANSPOSE A ZERO MATRIX A
C
   40 NP1 = N + 1
      DO 41 J = 1,NP1
         IB(J) = 1
   41 CONTINUE
      RETURN
      END
      SUBROUTINE CPOSE (A, IA, JA, B, IB, JB, M, N)
C-----------------------------------------------------------------------
C               TRANSPOSING A SPARSE COMPLEX MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
C           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
C                 OF A AND STORE THE RESULTS IN IB
C
      IPMIN = IA(1)
      IPMAX = IA(M+1) - 1
      IF (IPMIN .GT. IPMAX) GO TO 40
      DO 10 J = 1,N
         IB(J) = 0
   10 CONTINUE
      DO 11 IP = IPMIN,IPMAX
         J = JA(IP)
         IB(J) = IB(J) + 1
   11 CONTINUE
C
C          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
C                AND STORE THEM IN IB(2),...,IB(N+1)
C
      NUM = IA(M+1) - IA(1) + 1
      J = N
      DO 20 JJ = 1,N
         NUM = NUM - IB(J)
         IB(J+1) = NUM
         J = J - 1
   20 CONTINUE
C
C                STORE THE I-TH ROW OF A IN B AND JB
C                  AND UPDATE THE POINTERS IN IB
C
      DO 31 I = 1,M
         IPMIN = IA(I)
         IPMAX = IA(I+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 31
         DO 30 IP = IPMIN,IPMAX
            J = JA(IP)
            JP = IB(J+1)
            JB(JP) = I
            B(JP) = A(IP)
            IB(J+1) = JP + 1
   30    CONTINUE
   31 CONTINUE
      IB(1) = 1
      RETURN
C
C                    TRANSPOSE A ZERO MATRIX A
C
   40 NP1 = N + 1
      DO 41 J = 1,NP1
         IB(J) = 1
   41 CONTINUE
      RETURN
      END
      SUBROUTINE CPOSE1 (P, A, IA, JA, B, IB, JB, M, N)
C-----------------------------------------------------------------------
C               TRANSPOSING A SPARSE COMPLEX MATRIX
C                 WHERE THE ROWS ARE INTERCHANGED
C-----------------------------------------------------------------------
      INTEGER P(M)
      COMPLEX A(*), B(*)
      INTEGER IA(*), JA(*), IB(*), JB(*)
C
C           COMPUTE THE NUMBER OF ELEMENTS IN EACH COLUMN
C                 OF A AND STORE THE RESULTS IN IB
C
      IPMIN = IA(1)
      IPMAX = IA(M+1) - 1
      IF (IPMIN .GT. IPMAX) GO TO 40
      DO 10 J = 1,N
         IB(J) = 0
   10 CONTINUE
      DO 11 IP = IPMIN,IPMAX
         J = JA(IP)
         IB(J) = IB(J) + 1
   11 CONTINUE
C
C          COMPUTE THE ROW POINTERS OF THE TRANSPOSE MATRIX
C                AND STORE THEM IN IB(2),...,IB(N+1)
C
      NUM = IA(M+1) - IA(1) + 1
      J = N
      DO 20 JJ = 1,N
         NUM = NUM - IB(J)
         IB(J+1) = NUM
         J = J - 1
   20 CONTINUE
C
C                STORE THE I-TH ROW OF A IN B AND JB
C                  AND UPDATE THE POINTERS IN IB
C
      DO 31 I = 1,M
         II = P(I)
         IPMIN = IA(II)
         IPMAX = IA(II+1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 31
         DO 30 IP = IPMIN,IPMAX
            J = JA(IP)
            JP = IB(J+1)
            JB(JP) = I
            B(JP) = A(IP)
            IB(J+1) = JP + 1
   30    CONTINUE
   31 CONTINUE
      IB(1) = 1
      RETURN
C
C                    TRANSPOSE A ZERO MATRIX A
C
   40 NP1 = N + 1
      DO 41 J = 1,NP1
         IB(J) = 1
   41 CONTINUE
      RETURN
      END
      SUBROUTINE SADD (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C               ADDITION OF SPARSE REAL MATRICES
C-----------------------------------------------------------------------
      REAL A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 J = 1,N
         WK(J) = 0.0
   10 CONTINUE
C
C                  COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 42 I = 1,M
         IC(I) = IP
         MINA = IA(I)
         MAXA = IA(I+1) - 1
         IF (MINA .GT. MAXA) GO TO 30
         DO 20 L = MINA,MAXA
            J = JA(L)
            WK(J) = A(L)
   20    CONTINUE
C
   30    MINB = IB(I)
         MAXB = IB(I+1) - 1
         IF (MINB .GT. MAXB) GO TO 40
         DO 31 L = MINB,MAXB
            J = JB(L)
            T = WK(J) + B(L)
            WK(J) = 0.0
            IF (T .EQ. 0.0) GO TO 31
            IF (IP .GT. NUM) GO TO 50
            C(IP) = T
            JC(IP) = J
            IP = IP + 1
   31    CONTINUE
C
   40    IF (MINA .GT. MAXA) GO TO 42
         DO 41 L = MINA,MAXA
            J = JA(L)
            IF (WK(J) .EQ. 0.0) GO TO 41
            IF (IP .GT. NUM) GO TO 50
            C(IP) = WK(J)
            WK(J) = 0.0
            JC(IP) = J
            IP = IP + 1
   41    CONTINUE
   42 CONTINUE
      IC(M + 1) = IP
      IERR = 0
      RETURN
C
C                        ERROR RETURN
C
   50 IERR = I
      RETURN
      END
      SUBROUTINE DSADD (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C         ADDITION OF SPARSE DOUBLE PRECISION MATRICES
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 J = 1,N
         WK(J) = 0.D0
   10 CONTINUE
C
C                  COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 42 I = 1,M
         IC(I) = IP
         MINA = IA(I)
         MAXA = IA(I+1) - 1
         IF (MINA .GT. MAXA) GO TO 30
         DO 20 L = MINA,MAXA
            J = JA(L)
            WK(J) = A(L)
   20    CONTINUE
C
   30    MINB = IB(I)
         MAXB = IB(I+1) - 1
         IF (MINB .GT. MAXB) GO TO 40
         DO 31 L = MINB,MAXB
            J = JB(L)
            T = WK(J) + B(L)
            WK(J) = 0.D0
            IF (T .EQ. 0.D0) GO TO 31
            IF (IP .GT. NUM) GO TO 50
            C(IP) = T
            JC(IP) = J
            IP = IP + 1
   31    CONTINUE
C
   40    IF (MINA .GT. MAXA) GO TO 42
         DO 41 L = MINA,MAXA
            J = JA(L)
            IF (WK(J) .EQ. 0.D0) GO TO 41
            IF (IP .GT. NUM) GO TO 50
            C(IP) = WK(J)
            WK(J) = 0.D0
            JC(IP) = J
            IP = IP + 1
   41    CONTINUE
   42 CONTINUE
      IC(M + 1) = IP
      IERR = 0
      RETURN
C
C                        ERROR RETURN
C
   50 IERR = I
      RETURN
      END
      SUBROUTINE CSADD (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C              ADDITION OF SPARSE COMPLEX MATRICES
C-----------------------------------------------------------------------
      COMPLEX A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 J = 1,N
         WK(J) = (0.0, 0.0)
   10 CONTINUE
C
C                  COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 42 I = 1,M
         IC(I) = IP
         MINA = IA(I)
         MAXA = IA(I+1) - 1
         IF (MINA .GT. MAXA) GO TO 30
         DO 20 L = MINA,MAXA
            J = JA(L)
            WK(J) = A(L)
   20    CONTINUE
C
   30    MINB = IB(I)
         MAXB = IB(I+1) - 1
         IF (MINB .GT. MAXB) GO TO 40
         DO 31 L = MINB,MAXB
            J = JB(L)
            T = WK(J) + B(L)
            WK(J) = (0.0, 0.0)
            IF (T .EQ. (0.0, 0.0)) GO TO 31
            IF (IP .GT. NUM) GO TO 50
            C(IP) = T
            JC(IP) = J
            IP = IP + 1
   31    CONTINUE
C
   40    IF (MINA .GT. MAXA) GO TO 42
         DO 41 L = MINA,MAXA
            J = JA(L)
            IF (WK(J) .EQ. (0.0, 0.0)) GO TO 41
            IF (IP .GT. NUM) GO TO 50
            C(IP) = WK(J)
            WK(J) = (0.0, 0.0)
            JC(IP) = J
            IP = IP + 1
   41    CONTINUE
   42 CONTINUE
      IC(M + 1) = IP
      IERR = 0
      RETURN
C
C                        ERROR RETURN
C
   50 IERR = I
      RETURN
      END
      SUBROUTINE SSUBT (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C             SUBTRACTION OF SPARSE REAL MATRICES
C-----------------------------------------------------------------------
      REAL A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 J = 1,N
         WK(J) = 0.0
   10 CONTINUE
C
C                  COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 42 I = 1,M
         IC(I) = IP
         MINA = IA(I)
         MAXA = IA(I+1) - 1
         IF (MINA .GT. MAXA) GO TO 30
         DO 20 L = MINA,MAXA
            J = JA(L)
            WK(J) = A(L)
   20    CONTINUE
C
   30    MINB = IB(I)
         MAXB = IB(I+1) - 1
         IF (MINB .GT. MAXB) GO TO 40
         DO 31 L = MINB,MAXB
            J = JB(L)
            T = WK(J) - B(L)
            WK(J) = 0.0
            IF (T .EQ. 0.0) GO TO 31
            IF (IP .GT. NUM) GO TO 50
            C(IP) = T
            JC(IP) = J
            IP = IP + 1
   31    CONTINUE
C
   40    IF (MINA .GT. MAXA) GO TO 42
         DO 41 L = MINA,MAXA
            J = JA(L)
            IF (WK(J) .EQ. 0.0) GO TO 41
            IF (IP .GT. NUM) GO TO 50
            C(IP) = WK(J)
            WK(J) = 0.0
            JC(IP) = J
            IP = IP + 1
   41    CONTINUE
   42 CONTINUE
      IC(M + 1) = IP
      IERR = 0
      RETURN
C
C                        ERROR RETURN
C
   50 IERR = I
      RETURN
      END
      SUBROUTINE DSSUBT (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C        SUBTRACTION OF SPARSE DOUBLE PRECISION MATRICES
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 J = 1,N
         WK(J) = 0.D0
   10 CONTINUE
C
C                  COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 42 I = 1,M
         IC(I) = IP
         MINA = IA(I)
         MAXA = IA(I+1) - 1
         IF (MINA .GT. MAXA) GO TO 30
         DO 20 L = MINA,MAXA
            J = JA(L)
            WK(J) = A(L)
   20    CONTINUE
C
   30    MINB = IB(I)
         MAXB = IB(I+1) - 1
         IF (MINB .GT. MAXB) GO TO 40
         DO 31 L = MINB,MAXB
            J = JB(L)
            T = WK(J) - B(L)
            WK(J) = 0.D0
            IF (T .EQ. 0.D0) GO TO 31
            IF (IP .GT. NUM) GO TO 50
            C(IP) = T
            JC(IP) = J
            IP = IP + 1
   31    CONTINUE
C
   40    IF (MINA .GT. MAXA) GO TO 42
         DO 41 L = MINA,MAXA
            J = JA(L)
            IF (WK(J) .EQ. 0.D0) GO TO 41
            IF (IP .GT. NUM) GO TO 50
            C(IP) = WK(J)
            WK(J) = 0.D0
            JC(IP) = J
            IP = IP + 1
   41    CONTINUE
   42 CONTINUE
      IC(M + 1) = IP
      IERR = 0
      RETURN
C
C                        ERROR RETURN
C
   50 IERR = I
      RETURN
      END
      SUBROUTINE CSSUBT (A,IA,JA,B,IB,JB,C,IC,JC,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C            SUBTRACTION OF SPARSE COMPLEX MATRICES
C-----------------------------------------------------------------------
      COMPLEX A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 J = 1,N
         WK(J) = (0.0, 0.0)
   10 CONTINUE
C
C                  COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 42 I = 1,M
         IC(I) = IP
         MINA = IA(I)
         MAXA = IA(I+1) - 1
         IF (MINA .GT. MAXA) GO TO 30
         DO 20 L = MINA,MAXA
            J = JA(L)
            WK(J) = A(L)
   20    CONTINUE
C
   30    MINB = IB(I)
         MAXB = IB(I+1) - 1
         IF (MINB .GT. MAXB) GO TO 40
         DO 31 L = MINB,MAXB
            J = JB(L)
            T = WK(J) - B(L)
            WK(J) = (0.0, 0.0)
            IF (T .EQ. (0.0, 0.0)) GO TO 31
            IF (IP .GT. NUM) GO TO 50
            C(IP) = T
            JC(IP) = J
            IP = IP + 1
   31    CONTINUE
C
   40    IF (MINA .GT. MAXA) GO TO 42
         DO 41 L = MINA,MAXA
            J = JA(L)
            IF (WK(J) .EQ. (0.0, 0.0)) GO TO 41
            IF (IP .GT. NUM) GO TO 50
            C(IP) = WK(J)
            WK(J) = (0.0, 0.0)
            JC(IP) = J
            IP = IP + 1
   41    CONTINUE
   42 CONTINUE
      IC(M + 1) = IP
      IERR = 0
      RETURN
C
C                        ERROR RETURN
C
   50 IERR = I
      RETURN
      END
      SUBROUTINE SPROD (A,IA,JA,B,IB,JB,C,IC,JC,L,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C               MULTIPLICATION OF SPARSE REAL MATRICES
C-----------------------------------------------------------------------
      REAL A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 K = 1,N
         WK(K) = 0.0
   10 CONTINUE
C
C                     COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 31 I = 1,L
         IC(I) = IP
         JPMIN = IA(I)
         JPMAX = IA(I+1) - 1
         IF (JPMIN .GT. JPMAX) GO TO 31
C
         DO 21 JP = JPMIN,JPMAX
            T = A(JP)
            IF (T .EQ. 0.0) GO TO 21
            J = JA(JP)
            KPMIN = IB(J)
            KPMAX = IB(J+1) - 1
            IF (KPMIN .GT. KPMAX) GO TO 21
            DO 20 KP = KPMIN,KPMAX
               K = JB(KP)
               WK(K) = WK(K) + T*B(KP)
   20       CONTINUE
   21    CONTINUE
C
         DO 30 K = 1,N
            IF (WK(K) .EQ. 0.0) GO TO 30
            IF (IP .GT. NUM) GO TO 40
            C(IP) = WK(K)
            WK(K) = 0.0
            JC(IP) = K
            IP = IP + 1
   30    CONTINUE
   31 CONTINUE
      IC(L + 1) = IP
      IERR = 0
      RETURN
C
C                           ERROR RETURN
C
   40 IERR = I
      RETURN
      END
      SUBROUTINE DSPROD (A,IA,JA,B,IB,JB,C,IC,JC,L,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C         MULTIPLICATION OF SPARSE DOUBLE PRECISION MATRICES
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 K = 1,N
         WK(K) = 0.D0
   10 CONTINUE
C
C                     COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 31 I = 1,L
         IC(I) = IP
         JPMIN = IA(I)
         JPMAX = IA(I+1) - 1
         IF (JPMIN .GT. JPMAX) GO TO 31
C
         DO 21 JP = JPMIN,JPMAX
            T = A(JP)
            IF (T .EQ. 0.D0) GO TO 21
            J = JA(JP)
            KPMIN = IB(J)
            KPMAX = IB(J+1) - 1
            IF (KPMIN .GT. KPMAX) GO TO 21
            DO 20 KP = KPMIN,KPMAX
               K = JB(KP)
               WK(K) = WK(K) + T*B(KP)
   20       CONTINUE
   21    CONTINUE
C
         DO 30 K = 1,N
            IF (WK(K) .EQ. 0.D0) GO TO 30
            IF (IP .GT. NUM) GO TO 40
            C(IP) = WK(K)
            WK(K) = 0.D0
            JC(IP) = K
            IP = IP + 1
   30    CONTINUE
   31 CONTINUE
      IC(L + 1) = IP
      IERR = 0
      RETURN
C
C                           ERROR RETURN
C
   40 IERR = I
      RETURN
      END
      SUBROUTINE CSPROD (A,IA,JA,B,IB,JB,C,IC,JC,L,M,N,NUM,WK,IERR)
C-----------------------------------------------------------------------
C             MULTIPLICATION OF SPARSE COMPLEX MATRICES
C-----------------------------------------------------------------------
      COMPLEX A(*), B(*), C(*), WK(N), T
      INTEGER IA(*), JA(*), IB(*), JB(*), IC(*), JC(*)
C-------------------------
      DO 10 K = 1,N
         WK(K) = (0.0, 0.0)
   10 CONTINUE
C
C                     COMPUTE THE I-TH ROW OF C
C
      IP = 1
      DO 31 I = 1,L
         IC(I) = IP
         JPMIN = IA(I)
         JPMAX = IA(I+1) - 1
         IF (JPMIN .GT. JPMAX) GO TO 31
C
         DO 21 JP = JPMIN,JPMAX
            T = A(JP)
            IF (T .EQ. (0.0, 0.0)) GO TO 21
            J = JA(JP)
            KPMIN = IB(J)
            KPMAX = IB(J+1) - 1
            IF (KPMIN .GT. KPMAX) GO TO 21
            DO 20 KP = KPMIN,KPMAX
               K = JB(KP)
               WK(K) = WK(K) + T*B(KP)
   20       CONTINUE
   21    CONTINUE
C
         DO 30 K = 1,N
            IF (WK(K) .EQ. (0.0, 0.0)) GO TO 30
            IF (IP .GT. NUM) GO TO 40
            C(IP) = WK(K)
            WK(K) = (0.0, 0.0)
            JC(IP) = K
            IP = IP + 1
   30    CONTINUE
   31 CONTINUE
      IC(L + 1) = IP
      IERR = 0
      RETURN
C
C                           ERROR RETURN
C
   40 IERR = I
      RETURN
      END
      SUBROUTINE MVPRD (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C              PRODUCT OF A SPARSE MATRIX AND A VECTOR
C-----------------------------------------------------------------------
      REAL A(*), X(N), Y(M), SUM
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         SUM = 0.0
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            SUM = SUM + A(L)*X(J)
   10    CONTINUE
   11 Y(I) = SUM
      RETURN
      END
      SUBROUTINE MVPRD1 (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
C-----------------------------------------------------------------------
      REAL A(*), X(N), Y(M), SUM
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         SUM = Y(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            SUM = SUM + A(L)*X(J)
   10    CONTINUE
   11 Y(I) = SUM
      RETURN
      END
      SUBROUTINE MTPRD (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C              PRODUCT OF A VECTOR AND A SPARSE MATRIX
C-----------------------------------------------------------------------
      REAL A(*), X(M), Y(N), T
      INTEGER IA(*), JA(*)
C
      DO 10 J = 1,N
         Y(J) = 0.0
   10 CONTINUE
C
      DO 21 I = 1,M
         T = X(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 21
         DO 20 L = LMIN,LMAX
            J = JA(L)
            Y(J) = Y(J) + T*A(L)
   20    CONTINUE
   21 CONTINUE
      RETURN
      END
      SUBROUTINE MTPRD1 (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
C-----------------------------------------------------------------------
      REAL A(*), X(M), Y(N), T
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         T = X(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            Y(J) = Y(J) + T*A(L)
   10    CONTINUE
   11 CONTINUE
      RETURN
      END
      SUBROUTINE DVPRD (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C              PRODUCT OF A SPARSE MATRIX AND A VECTOR
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), X(N), Y(M), SUM
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         SUM = 0.D0
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            SUM = SUM + A(L)*X(J)
   10    CONTINUE
   11 Y(I) = SUM
      RETURN
      END
      SUBROUTINE DVPRD1 (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), X(N), Y(M), SUM
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         SUM = Y(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            SUM = SUM + A(L)*X(J)
   10    CONTINUE
   11 Y(I) = SUM
      RETURN
      END
      SUBROUTINE DTPRD (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C              PRODUCT OF A VECTOR AND A SPARSE MATRIX
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), X(M), Y(N), T
      INTEGER IA(*), JA(*)
C
      DO 10 J = 1,N
         Y(J) = 0.D0
   10 CONTINUE
C
      DO 21 I = 1,M
         T = X(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 21
         DO 20 L = LMIN,LMAX
            J = JA(L)
            Y(J) = Y(J) + T*A(L)
   20    CONTINUE
   21 CONTINUE
      RETURN
      END
      SUBROUTINE DTPRD1 (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), X(M), Y(N), T
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         T = X(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            Y(J) = Y(J) + T*A(L)
   10    CONTINUE
   11 CONTINUE
      RETURN
      END
      SUBROUTINE CVPRD (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C              PRODUCT OF A SPARSE MATRIX AND A VECTOR
C-----------------------------------------------------------------------
      COMPLEX A(*), X(N), Y(M), SUM
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         SUM = (0.0, 0.0)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            SUM = SUM + A(L)*X(J)
   10    CONTINUE
   11 Y(I) = SUM
      RETURN
      END
      SUBROUTINE CVPRD1 (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C     SET Y = A*X + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
C-----------------------------------------------------------------------
      COMPLEX A(*), X(N), Y(M), SUM
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         SUM = Y(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            SUM = SUM + A(L)*X(J)
   10    CONTINUE
   11 Y(I) = SUM
      RETURN
      END
      SUBROUTINE CTPRD (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C              PRODUCT OF A VECTOR AND A SPARSE MATRIX
C-----------------------------------------------------------------------
      COMPLEX A(*), X(M), Y(N), T
      INTEGER IA(*), JA(*)
C
      DO 10 J = 1,N
         Y(J) = (0.0, 0.0)
   10 CONTINUE
C
      DO 21 I = 1,M
         T = X(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 21
         DO 20 L = LMIN,LMAX
            J = JA(L)
            Y(J) = Y(J) + T*A(L)
   20    CONTINUE
   21 CONTINUE
      RETURN
      END
      SUBROUTINE CTPRD1 (M, N, A, IA, JA, X, Y)
C-----------------------------------------------------------------------
C     SET Y = X*A + Y WHERE A IS A SPARSE MATRIX AND X,Y ARE VECTORS
C-----------------------------------------------------------------------
      COMPLEX A(*), X(M), Y(N), T
      INTEGER IA(*), JA(*)
C
      DO 11 I = 1,M
         T = X(I)
         LMIN = IA(I)
         LMAX = IA(I+1) - 1
         IF (LMIN .GT. LMAX) GO TO 11
         DO 10 L = LMIN,LMAX
            J = JA(L)
            Y(J) = Y(J) + T*A(L)
   10    CONTINUE
   11 CONTINUE
      RETURN
      END
      REAL FUNCTION SNRM (A, IA, JA, M, N)
C-----------------------------------------------------------------------
C             COMPUTATION OF THE L-INFINITY NORM OF A
C                      REAL SPARSE MATRIX A
C-----------------------------------------------------------------------
      REAL A(*)
      INTEGER IA(*), JA(*)
C
      SNRM = 0.0
      DO 20 I = 1,M
         IPMIN = IA(I)
         IPMAX = IA(I + 1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 20
         SUM = 0.0
         DO 10 IP = IPMIN,IPMAX
            SUM = SUM + ABS(A(IP))
   10    CONTINUE
         SNRM = AMAX1(SNRM, SUM)
   20 CONTINUE
      RETURN
      END
      SUBROUTINE S1NRM (A, IA, JA, M, N, ANORM, WK)
C-----------------------------------------------------------------------
C        COMPUTATION OF THE L1 NORM OF A REAL SPARSE MATRIX A
C-----------------------------------------------------------------------
      REAL A(*), WK(N)
      INTEGER IA(*), JA(*)
C
      ANORM = 0.0
      IPMIN = IA(1)
      IPMAX = IA(M + 1) - 1
      IF (IPMIN .GT. IPMAX) RETURN
C
C     COMPUTE THE L1 NORM OF A
C
      DO 10 J = 1,N
         WK(J) = 0.0
   10 CONTINUE
C
      DO 20 IP = IPMIN,IPMAX
         J = JA(IP)
         WK(J) = WK(J) + ABS(A(IP))
   20 CONTINUE
C
      DO 30 J = 1,N
         ANORM = AMAX1(ANORM,WK(J))
   30 CONTINUE
      RETURN
      END
      DOUBLE PRECISION FUNCTION DSNRM (A, IA, JA, M, N)
C-----------------------------------------------------------------------
C             COMPUTATION OF THE L-INFINITY NORM OF A
C                DOUBLE PRECISION SPARSE MATRIX A
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), SUM
      INTEGER IA(*), JA(*)
C
      DSNRM = 0.D0
      DO 20 I = 1,M
         IPMIN = IA(I)
         IPMAX = IA(I + 1) - 1
         IF (IPMIN .GT. IPMAX) GO TO 20
         SUM = 0.D0
         DO 10 IP = IPMIN,IPMAX
            SUM = SUM + DABS(A(IP))
   10    CONTINUE
         DSNRM = DMAX1(DSNRM, SUM)
   20 CONTINUE
      RETURN
      END
      SUBROUTINE DS1NRM (A, IA, JA, M, N, ANORM, WK)
C-----------------------------------------------------------------------
C               COMPUTATION OF THE L1 NORM OF A SPARSE
C                     DOUBLE PRECISION MATRIX A
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(*), ANORM, WK(N)
      INTEGER IA(*), JA(*)
C
      ANORM = 0.D0
      IPMIN = IA(1)
      IPMAX = IA(M + 1) - 1
      IF (IPMIN .GT. IPMAX) RETURN
C
C     COMPUTE THE L1 NORM OF A
C
      DO 10 J = 1,N
         WK(J) = 0.D0
   10 CONTINUE
C
      DO 20 IP = IPMIN,IPMAX
         J = JA(IP)
         WK(J) = WK(J) + DABS(A(IP))
   20 CONTINUE
C
      DO 30 J = 1,N
         ANORM = DMAX1(ANORM,WK(J))
   30 CONTINUE
      RETURN
      END
      SUBROUTINE SPORD (M, N, IA, R, IWK)
C-----------------------------------------------------------------------
C        SPORD ORDERS THE ROWS OF AN MXN SPARSE MATRIX A,IA,JA
C        BY INCREASING LENGTH. THE ROW ORDERING IS GIVEN IN R.
C-----------------------------------------------------------------------
C     IWK IS A WORK SPACE OF DIMENSION M + N + 1.
C----------------------
      INTEGER IA(*), R(M), IWK(*)
C
      NP1 = N + 1
      DO 10 I = 1,NP1
         IWK(I) = 0
   10 CONTINUE
C
      I = M
      DO 20 II = 1,M
         NUM = IA(I+1) - IA(I) + 1
         L = NP1 + I
         IWK(L) = IWK(NUM)
         IWK(NUM) = I
         I = I - 1
   20 CONTINUE
C
      NUM = 1
      K = IWK(NUM)
      DO 32 I = 1,M
   30    IF (K .NE. 0) GO TO 31
            NUM = NUM + 1
            K = IWK(NUM)
            GO TO 30
   31    R(I) = K
         L = NP1 + K
         K = IWK(L)
   32 CONTINUE
      RETURN
      END
      SUBROUTINE BLKORD (N, IA, JA, R, C, IB, NUM, IWK, IERR)
C-----------------------------------------------------------------------
C        REORDERING A SPARSE MATRIX INTO BLOCK TRIANGULAR FORM
C-----------------------------------------------------------------------
      INTEGER IA(*), JA(*), R(N), C(N), IB(N)
C     INTEGER IWK(5*N)
      INTEGER IWK(*)
C
      NP1 = N + 1
      LENGTH = IA(NP1) - IA(1)
      DO 10 I = 1,N
         IWK(I) = IA(I+1) - IA(I)
   10 CONTINUE
      CALL MC21A(N,JA,LENGTH,IA,IWK(1),R,NUM,IWK(NP1))
      IERR = N - NUM
      IF (IERR .NE. 0) RETURN
C
      DO 20 I = 1,N
         LI = R(I)
         IWK(I) = IA(LI)
         NPI = N + I
         IWK(NPI) = IA(LI+1) - IA(LI)
   20 CONTINUE
      CALL MC13D(N,JA,LENGTH,IWK(1),IWK(NP1),C,IB,NUM,IWK(2*N+1))
C
      DO 30 I = 1,N
         LI = C(I)
         IWK(I) = R(LI)
   30 CONTINUE
      DO 31 I = 1,N
         R(I) = IWK(I)
   31 CONTINUE
      RETURN
      END
      SUBROUTINE MC21A (N,ICN,LICN,IP,LENR,IPERM,NUMNZ,IW)
C-----------------------------------------------------------------------
C DESCRIPTION OF PARAMETERS.
C INPUT VARIABLES   N,ICN,LICN,IP,LENR
C OUTPUT VARIABLES  IPERM,NUMNZ
C
C N   ORDER OF MATRIX.
C ICN ARRAY CONTAINING THE COLUMN INDICES OF THE NON-ZEROS.  THOSE
C     BELONGING TO A SINGLE ROW MUST BE CONTIGUOUS BUT THE ORDERING
C     OF COLUMN INDICES WITHIN EACH ROW IS UNIMPORTANT AND WASTED
C     SPACE BETWEEN ROWS IS PERMITTED.
C LICN  LENGTH OF ARRAY ICN.
C IP  IP(I), I=1,2,...N, IS THE POSITION IN ARRAY ICN OF THE FIRST
C     COLUMN INDEX OF A NON-ZERO IN ROW I.
C LENR  LENR(I) IS THE NUMBER OF NON-ZEROS IN ROW I, I=1,2,..N.
C IPERM CONTAINS PERMUTATION TO MAKE DIAGONAL HAVE THE SMALLEST
C     NUMBER OF ZEROS ON IT.  ELEMENTS (IPERM(I),I) I=1, ... N ARE
C     NON-ZERO AT THE END OF THE ALGORITHM UNLESS MATRIX
C     IS STRUCTURALLY SINGULAR.  IN THIS CASE, (IPERM(I),I) WILL
C     BE ZERO FOR N-NUMNZ ENTRIES.
C NUMNZ NUMBER OF NON-ZEROS ON DIAGONAL OF PERMUTED MATRIX.
C IW  WORK ARRAY  ..  SEE LATER COMMENTS.
C-----------------------------------------------------------------------
      INTEGER IP(N)
      INTEGER ICN(LICN), LENR(N), IPERM(N), IW(N,4)
C
      CALL MC21B (N,ICN,LICN,IP,LENR,IPERM,NUMNZ,IW(1,1),IW(1,2),
     *            IW(1,3),IW(1,4))
      RETURN
      END
      SUBROUTINE MC21B (N,ICN,LICN,IP,LENR,IPERM,NUMNZ,PR,ARP,CV,OUT)
C-----------------------------------------------------------------------
C     DIVISION OF WORK ARRAY IS NOW DESCRIBED.
C
C PR(I) IS THE PREVIOUS ROW TO I IN THE DEPTH FIRST SEARCH.
C ARP(I) IS ONE LESS THAN THE NUMBER OF NON-ZEROS IN ROW I
C     WHICH HAVE NOT BEEN SCANNED WHEN LOOKING FOR A CHEAP ASSIGNMENT.
C CV(I) IS THE MOST RECENT ROW EXTENSION AT WHICH COLUMN I
C     WAS VISITED.
C OUT(I) IS ONE LESS THAN THE NUMBER OF NON-ZEROS IN ROW I
C     WHICH HAVE NOT BEEN SCANNED DURING ONE PASS THROUGH THE
C     MAIN LOOP.
C-----------------------------------------------------------------------
      INTEGER IP(N), ICN(LICN), LENR(N), IPERM(N), PR(N), CV(N),
     *        ARP(N), OUT(N)
C
C     INITIALIZATION OF ARRAYS
C
      DO 10 I = 1,N
         ARP(I) = LENR(I) - 1
         CV(I) = 0
         IPERM(I) = 0
   10 CONTINUE
      NUMNZ = 0
C
C     MAIN LOOP.
C     EACH PASS ROUND THIS LOOP EITHER RESULTS IN A NEW ASSIGNMENT
C     OR GIVES A ROW WITH NO ASSIGNMENT.
C
      DO 130 JORD = 1,N
      J = JORD
      PR(J) = -1
      DO 100 K = 1,JORD
C
C     LOOK FOR A CHEAP ASSIGNMENT
C
      IN1 = ARP(J)
      IF (IN1 .LT. 0) GO TO 60
      IN2 = IP(J) + LENR(J) - 1
      IN1 = IN2 - IN1
      DO 50 II = IN1,IN2
         I = ICN(II)
         IF (IPERM(I) .EQ. 0) GO TO 110
   50 CONTINUE
C
C     NO CHEAP ASSIGNMENT IN ROW
C
      ARP(J) = -1
C
C     BEGIN LOOKING FOR ASSIGNMENT CHAIN STARTING WITH ROW J
C
   60 OUT(J) = LENR(J) - 1
C
C     INNER LOOP.  EXTENDS CHAIN BY ONE OR BACKTRACKS.
C
      DO 90 KK = 1,JORD
         IN1 = OUT(J)
         IF (IN1 .LT. 0) GO TO 80
         IN2 = IP(J) + LENR(J) - 1
         IN1 = IN2 - IN1
C
C        FORWARD SCAN
C
         DO 70 II = IN1,IN2
            I = ICN(II)
            IF (CV(I) .EQ. JORD) GO TO 70
C
C           COLUMN I HAS NOT YET BEEN ACCESSED DURING THIS PASS
C
            J1 = J
            J = IPERM(I)
            CV(I) = JORD
            PR(J) = J1
            OUT(J1) = IN2 - II - 1
            GO TO 100
   70    CONTINUE
C
C        BACKTRACKING STEP
C
   80    J = PR(J)
         IF (J .EQ. -1) GO TO 130
   90 CONTINUE
C
  100 CONTINUE
C
C     NEW ASSIGNMENT IS MADE
C
  110 IPERM(I) = J
      ARP(J) = IN2 - II - 1
      NUMNZ = NUMNZ + 1
      DO 120 K = 1,JORD
         J = PR(J)
         IF (J .EQ. -1) GO TO 130
         II = IP(J) + LENR(J) - OUT(J) - 2
         I = ICN(II)
         IPERM(I) = J
  120 CONTINUE
C
  130 CONTINUE
C
C     IF MATRIX IS STRUCTURALLY SINGULAR, WE NOW COMPLETE THE
C     PERMUTATION IPERM.
C
      IF (NUMNZ .EQ. N) GO TO 500
      DO 140 I = 1,N
         ARP(I) = 0
  140 CONTINUE
      K = 0
      DO 160 I = 1,N
         IF (IPERM(I) .NE. 0) GO TO 150
            K = K + 1
            OUT(K) = I
            GO TO 160
  150    J = IPERM(I)
         ARP(J) = I
  160 CONTINUE
      K = 0
      DO 170 I = 1,N
         IF (ARP(I) .NE. 0) GO TO 170
         K = K + 1
         IOUTK = OUT(K)
         IPERM(IOUTK) = I
  170 CONTINUE
  500 RETURN
      END
      SUBROUTINE MC13D(N, ICN, LICN, IP, LENR, IOR, IB, NUM, IW)
C
C DESCRIPTION OF PARAMETERS.
C INPUT VARIABLES  .... N,ICN,LICN,IP,LENR.
C OUTPUT VARIABLES  IOR,IB,NUM.
C
C N   ORDER OF THE MATRIX.
C ICN ARRAY CONTAINING THE COLUMN INDICES OF THE NON-ZEROS.  THOSE
C     BELONGING TO A SINGLE ROW MUST BE CONTIGUOUS BUT THE ORDERING
C     OF COLUMN INDICES WITHIN EACH ROW IS UNIMPORTANT AND WASTED
C     SPACE BETWEEN ROWS IS PERMITTED.
C LICN  LENGTH OF ARRAY ICN.
C IP  IP(I), I=1,2,...N, IS THE POSITION IN ARRAY ICN OF THE FIRST
C     COLUMN INDEX OF A NON-ZERO IN ROW I.
C LENR  LENR(I) IS THE NUMBER OF NON-ZEROS IN ROW I, I=1,2,...N.
C IOR  IOR(I) GIVES THE POSITION IN THE ORIGINAL ORDERING OF THE ROW
C     OR COLUMN WHICH IS IN POSITION I IN THE PERMUTED FORM, I=1,2,..N.
C IB  IB(I) IS THE ROW NUMBER IN THE PERMUTED MATRIX OF THE BEGINNING
C     OF BLOCK I, I=1,2,...NUM.
C NUM NUMBER OF BLOCKS FOUND.
C IW  WORK ARRAY OF LENGTH 3*N.
C
      INTEGER IP(N)
      INTEGER ICN(LICN), LENR(N), IOR(N), IB(N), IW(N,3)
C
      CALL MC13E(N, ICN, LICN, IP, LENR, IOR, IB, NUM, IW(1,1),
     *  IW(1,2), IW(1,3))
      RETURN
      END
      SUBROUTINE MC13E(N, ICN, LICN, IP, LENR, ARP, IB, NUM, LOWL,
     *  NUMB, PREV)
      INTEGER STP, DUMMY
      INTEGER IP(N)
C
C ARP(I) IS ONE LESS THAN THE NUMBER OF UNSEARCHED EDGES LEAVING
C     NODE I.  AT THE END OF THE ALGORITHM IT IS SET TO A
C     PERMUTATION WHICH PUTS THE MATRIX IN BLOCK LOWER
C     TRIANGULAR FORM.
C IB(I) IS THE POSITION IN THE ORDERING OF THE START OF THE ITH
C     BLOCK.  IB(N+1-I) HOLDS THE NODE NUMBER OF THE ITH NODE
C     ON THE STACK.
C LOWL(I) IS THE SMALLEST STACK POSITION OF ANY NODE TO WHICH A PATH
C     FROM NODE I HAS BEEN FOUND.  IT IS SET TO N+1 WHEN NODE I
C     IS REMOVED FROM THE STACK.
C NUMB(I) IS THE POSITION OF NODE I IN THE STACK IF IT IS ON
C     IT, IS THE PERMUTED ORDER OF NODE I FOR THOSE NODES
C     WHOSE FINAL POSITION HAS BEEN FOUND AND IS OTHERWISE ZERO.
C PREV(I) IS THE NODE AT THE END OF THE PATH WHEN NODE I WAS
C     PLACED ON THE STACK.
C
      INTEGER ICN(LICN), LENR(N), ARP(N), IB(N), LOWL(N), NUMB(N),
     *  PREV(N)
C
C   ICNT IS THE NUMBER OF NODES WHOSE POSITIONS IN FINAL ORDERING HAVE
C     BEEN FOUND.
C
      ICNT = 0
C NUM IS THE NUMBER OF BLOCKS THAT HAVE BEEN FOUND.
      NUM = 0
      NNM1 = N + N - 1
C
C INITIALIZATION OF ARRAYS.
C
      DO 10 J=1,N
        NUMB(J) = 0
        ARP(J) = LENR(J) - 1
   10 CONTINUE
C
C
      DO 90 ISN=1,N
C LOOK FOR A STARTING NODE
        IF (NUMB(ISN).NE.0) GO TO 90
        IV = ISN
C IST IS THE NUMBER OF NODES ON THE STACK ... IT IS THE STACK POINTER.
        IST = 1
C PUT NODE IV AT BEGINNING OF STACK.
        LOWL(IV) = 1
        NUMB(IV) = 1
        IB(N) = IV
C
C THE BODY OF THIS LOOP PUTS A NEW NODE ON THE STACK OR BACKTRACKS.
C
        DO 80 DUMMY=1,NNM1
          I1 = ARP(IV)
C HAVE ALL EDGES LEAVING NODE IV BEEN SEARCHED.
          IF (I1.LT.0) GO TO 30
          I2 = IP(IV) + LENR(IV) - 1
          I1 = I2 - I1
C
C LOOK AT EDGES LEAVING NODE IV UNTIL ONE ENTERS A NEW NODE OR
C     ALL EDGES ARE EXHAUSTED.
C
          DO 20 II=I1,I2
            IW = ICN(II)
C HAS NODE IW BEEN ON STACK ALREADY.
            IF (NUMB(IW).EQ.0) GO TO 70
C UPDATE VALUE OF LOWL(IV) IF NECESSARY.
            IF (LOWL(IW).LT.LOWL(IV)) LOWL(IV) = LOWL(IW)
   20     CONTINUE
C
C THERE ARE NO MORE EDGES LEAVING NODE IV.
C
          ARP(IV) = -1
C IS NODE IV THE ROOT OF A BLOCK.
   30     IF (LOWL(IV).LT.NUMB(IV)) GO TO 60
C
C ORDER NODES IN A BLOCK.
C
          NUM = NUM + 1
          IST1 = N + 1 - IST
          LCNT = ICNT + 1
C
C PEEL BLOCK OFF THE TOP OF THE STACK STARTING AT THE TOP AND
C     WORKING DOWN TO THE ROOT OF THE BLOCK.
C
          DO 40 STP=IST1,N
            IW = IB(STP)
            LOWL(IW) = N + 1
            ICNT = ICNT + 1
            NUMB(IW) = ICNT
            IF (IW.EQ.IV) GO TO 50
   40     CONTINUE
   50     IST = N - STP
          IB(NUM) = LCNT
C ARE THERE ANY NODES LEFT ON THE STACK.
          IF (IST.NE.0) GO TO 60
C HAVE ALL THE NODES BEEN ORDERED.
          IF (ICNT.LT.N) GO TO 90
          GO TO 100
C
C BACKTRACK TO PREVIOUS NODE ON PATH.
C
   60     IW = IV
          IV = PREV(IV)
C UPDATE VALUE OF LOWL(IV) IF NECESSARY.
          IF (LOWL(IW).LT.LOWL(IV)) LOWL(IV) = LOWL(IW)
          GO TO 80
C
C PUT NEW NODE ON THE STACK.
C
   70     ARP(IV) = I2 - II - 1
          PREV(IW) = IV
          IV = IW
          IST = IST + 1
          LOWL(IV) = IST
          NUMB(IV) = IST
          K = N + 1 - IST
          IB(K) = IV
   80   CONTINUE
C
   90 CONTINUE
C
C PUT PERMUTATION IN THE REQUIRED FORM.
C
  100 DO 110 I=1,N
        II = NUMB(I)
        ARP(II) = I
  110 CONTINUE
      RETURN
      END
      SUBROUTINE SPSLV (N,A,IA,JA,B,R,C,MAX,X,ITEMP,RTEMP,IERR)
C-----------------------------------------------------------------------
C                 SOLUTION OF REAL SPARSE EQUATIONS
C-----------------------------------------------------------------------
C  SPSLV CALLS NSPIV1 WHICH USES SPARSE GAUSSIAN ELIMINATION WITH
C  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
C  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
C  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
C  PHASE SOLVES U X = Y.
C
C  INPUT ARGUMENTS---
C
C  N      INTEGER NUMBER OF EQUATIONS AND UNKNOWNS
C
C  A      REAL ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING THE
C         ACTUAL NONZEROS.  (SEE MATRIX STORAGE DESCRIPTION BELOW)
C
C  IA     INTEGER ARRAY OF N+1 ENTRIES CONTAINING ROW POINTERS TO A
C         (SEE MATRIX STORAGE DESCRIPTION BELOW)
C
C  JA     INTEGER ARRAY WITH ONE ENTRY PER NONZERO IN A, CONTAINING
C         COLUMN NUMBERS OF THE NONZEROS OF A.  (SEE MATRIX STORAGE
C         DESCRIPTION BELOW)
C
C  B      REAL ARRAY OF N ENTRIES CONTAINING RIGHT HAND SIDE DATA
C
C  R      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
C         ROWS OF A (I.E., THE ELIMINATION ORDER FOR THE EQUATIONS)
C
C  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
C         COLUMNS OF A.  C IS ALSO AN OUTPUT ARGUMENT
C
C  MAX    INTEGER NUMBER SPECIFYING MAXIMUM NUMBER OF OFF-DIAGONAL
C         NONZERO ENTRIES OF U WHICH MAY BE STORED
C
C  ITEMP  INTEGER ARRAY OF 3*N + MAX + 2 ENTRIES, FOR INTERNAL USE
C
C  RTEMP  REAL ARRAY OF N + MAX ENTRIES FOR INTERNAL USE
C
C
C  OUTPUT ARGUMENTS---
C
C  C      INTEGER ARRAY OF N ENTRIES SPECIFYING THE ORDER OF THE
C         COLUMNS OF U.  C IS ALSO AN INPUT ARGUMENT
C
C  X      REAL ARRAY OF N ENTRIES CONTAINING THE SOLUTION VECTOR
C
C  IERR   INTEGER NUMBER WHICH INDICATES ERROR CONDITIONS OR
C         THE ACTUAL NUMBER OF OFF-DIAGONAL ENTRIES IN U (FOR
C         SUCCESSFUL COMPLETION)
C
C         IERR VALUES ARE---
C
C         0 LT IERR             SUCCESSFUL COMPLETION. IERR=MAX(1,M)
C                               WHERE M IS THE NUMBER OF OFF-DIAGONAL
C                               NONZERO ENTRIES OF U.
C
C         IERR = 0              ERROR.  N IS LESS THAN OR EQUAL TO 0
C
C         -N LE IERR LT 0       ERROR.  ROW NUMBER IABS(IERR) OF A IS
C                               IS NULL
C
C         -2*N LE IERR LT -N    ERROR.  ROW NUMBER IABS(IERR+N) HAS A
C                               DUPLICATE ENTRY
C
C         -3*N LE IERR LT -2*N  ERROR.  ROW NUMBER IABS(IERR+2*N)
C                               HAS A ZERO PIVOT
C
C         -4*N LE IERR LT -3*N  ERROR.  ROW NUMBER IABS(IERR+3*N)
C                               EXCEEDS STORAGE
C
C
C  STORAGE OF SPARSE MATRICES---
C
C  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
C  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
C  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
C  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
C  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
C  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
C  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
C  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
C  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZERO
C  ELEMENTS IN A.
C------------------------
      REAL A(*), B(N), X(N), RTEMP(*)
      INTEGER IA(*), JA(*), R(N), C(N), ITEMP(*)
      INTEGER IU, JU, U, Y, P
C
      IERR = 0
      IF (N .LE. 0) RETURN
C
C  SET INDICES TO DIVIDE TEMPORARY STORAGE FOR NSPIV1
C
      Y = 1
      U = Y + N
      P = N + 1
      IU = P + N + 1
      JU = IU + N + 1
C
C  COMPUTE THE INVERSE PERMUTATION OF C
C
      DO 10 K = 1,N
         L = C(K)
         ITEMP(L) = K
   10 CONTINUE
C
C  CALL NSPIV1 TO PERFORM COMPUTATIONS
C
      CALL NSPIV1 (N,IA,JA,A,B,MAX,R,C,ITEMP(1),X,RTEMP(Y),ITEMP(P),
     *             ITEMP(IU),ITEMP(JU),RTEMP(U),IERR)
      IF (IERR .EQ. 0) IERR = 1
      RETURN
      END
      SUBROUTINE NSPIV1 (N,IA,JA,A,B,MAX,R,C,IC,X,Y,P,IU,JU,U,IERR)
C
C
C  NSPIV1 USES SPARSE GAUSSIAN ELIMINATION WITH
C  COLUMN INTERCHANGES TO SOLVE THE LINEAR SYSTEM A X = B.  THE
C  ELIMINATION PHASE PERFORMS ROW OPERATIONS ON A AND B TO OBTAIN
C  A UNIT UPPER TRIANGULAR MATRIX U AND A VECTOR Y.  THE SOLUTION
C  PHASE SOLVES U X = Y.
C
C
C  SEE SPSLV FOR DESCRIPTIONS OF ALL INPUT AND OUTPUT ARGUMENTS
C  OTHER THAN THOSE DESCRIBED BELOW
C
C  IC  INTEGER ARRAY OF N ENTRIES WHICH IS THE INVERSE OF C
C      (I.E., IC(C(I)) = I). IC IS BOTH AN INPUT AND OUTPUT
C      ARGUMENT.
C
C  INPUT ARGUMENTS (USED INTERNALLY ONLY)---
C
C  Y   REAL ARRAY OF N ENTRIES USED TO COMPUTE THE UPDATED
C      RIGHT HAND SIDE
C
C  P   INTEGER ARRAY OF N+1 ENTRIES USED FOR A LINKED LIST.
C      P(N+1) IS THE LIST HEADER, AND THE ENTRY FOLLOWING
C      P(K) IS IN P(P(K)).  THUS, P(N+1) IS THE FIRST DATA
C      ITEM, P(P(N+1)) IS THE SECOND, ETC.  A POINTER OF
C      N+1 MARKS THE END OF THE LIST
C
C  IU  INTEGER ARRAY OF N+1 ENTRIES USED FOR ROW POINTERS TO U
C      (SEE MATRIX STORAGE DESCRIPTION BELOW)
C
C  JU  INTEGER ARRAY OF MAX ENTRIES USED FOR COLUMN NUMBERS OF
C      THE NONZEROS IN THE STRICT UPPER TRIANGLE OF U.  (SEE
C      MATRIX STORAGE DESCRIPTION BELOW)
C
C  U   REAL ARRAY OF MAX ENTRIES USED FOR THE ACTUAL NONZEROS IN
C      THE STRICT UPPER TRIANGLE OF U.  (SEE MATRIX STORAGE
C      DESCRIPTION BELOW)
C
C
C  STORAGE OF SPARSE MATRICES---
C
C  THE SPARSE MATRIX A IS STORED USING THREE ARRAYS IA, JA, AND A.
C  THE ARRAY A CONTAINS THE NONZEROS OF THE MATRIX ROW-BY-ROW, NOT
C  NECESSARILY IN ORDER OF INCREASING COLUMN NUMBER.  THE ARRAY JA
C  CONTAINS THE COLUMN NUMBERS CORRESPONDING TO THE NONZEROS STORED
C  IN THE ARRAY A (I.E., IF THE NONZERO STORED IN A(K) IS IN
C  COLUMN J, THEN JA(K) = J).  THE ARRAY IA CONTAINS POINTERS TO THE
C  ROWS OF NONZEROS/COLUMN INDICES IN THE ARRAY A/JA (I.E.,
C  A(IA(I))/JA(IA(I)) IS THE FIRST ENTRY FOR ROW I IN THE ARRAY A/JA).
C  IA(N+1) IS SET SO THAT IA(N+1) - IA(1) = THE NUMBER OF NONZEROS IN
C  A.  IU, JU, AND U ARE USED IN A SIMILAR WAY TO STORE THE STRICT UPPER
C  TRIANGLE OF U, EXCEPT THAT JU ACTUALLY CONTAINS C(J) INSTEAD OF J
C
C
      REAL A(*), B(N), U(MAX), X(N), Y(N)
      REAL DK, LKI, XPV, XPVMAX, YK
      INTEGER C(N), IA(*), IC(N), IU(*), JA(*), JU(MAX), P(*), R(N)
      INTEGER CK, PK, PPK, PV, V, VI, VJ, VK
C
C  INITIALIZE WORK STORAGE AND POINTERS TO JU
C
      DO 10 J = 1,N
        X(J) = 0.0
 10   CONTINUE
      IU(1) = 1
      JUPTR = 0
C
C  PERFORM SYMBOLIC AND NUMERIC FACTORIZATION ROW BY ROW
C  VK (VI,VJ) IS THE GRAPH VERTEX FOR ROW K (I,J) OF U
C
      DO 170 K = 1,N
C
C  INITIALIZE LINKED LIST AND FREE STORAGE FOR THIS ROW
C  THE R(K)-TH ROW OF A BECOMES THE K-TH ROW OF U.
C
        P(N+1) = N+1
        VK = R(K)
C
C  SET UP ADJACENCY LIST FOR VK, ORDERED IN
C  CURRENT COLUMN ORDER OF U.  THE LOOP INDEX
C  GOES DOWNWARD TO EXPLOIT ANY COLUMNS
C  FROM A IN CORRECT RELATIVE ORDER
C
        JMIN = IA(VK)
        JMAX = IA(VK+1) - 1
        IF (JMIN .GT. JMAX)  GO TO 1002
        J = JMAX
 20       JAJ = JA(J)
          VJ = IC(JAJ)
C
C  STORE A(K,J) IN WORK VECTOR
C
          X(VJ) = A(J)
C  THIS CODE INSERTS VJ INTO ADJACENCY LIST OF VK
          PPK = N+1
 30       PK = PPK
          PPK = P(PK)
          IF (PPK - VJ)  30,1003,40
 40       P(VJ) = PPK
          P(PK) = VJ
          J = J - 1
          IF (J .GE. JMIN) GO TO 20
C
C  THE FOLLOWING CODE COMPUTES THE K-TH ROW OF U
C
        VI = N+1
        YK = B(VK)
 50     VI = P(VI)
        IF (VI .GE. K) GO TO 110
C
C  VI LT VK -- PROCESS THE L(K,I) ELEMENT AND MERGE THE
C  ADJACENCY OF VI WITH THE ORDERED ADJACENCY OF VK
C
        LKI = - X(VI)
        X(VI) = 0.0
C
C  ADJUST RIGHT HAND SIDE TO REFLECT ELIMINATION
C
        YK = YK + LKI * Y(VI)
        PPK = VI
        JMIN = IU(VI)
        JMAX = IU(VI+1) - 1
        IF (JMIN .GT. JMAX)  GO TO 50
        DO 100 J = JMIN,JMAX
          JUJ = JU(J)
          VJ = IC(JUJ)
C
C  IF VJ IS ALREADY IN THE ADJACENCY OF VK,
C  SKIP THE INSERTION
C
          IF (X(VJ) .NE. 0.0)  GO TO 90
C
C  INSERT VJ IN ADJACENCY LIST OF VK.
C  RESET PPK TO VI IF WE HAVE PASSED THE CORRECT
C  INSERTION SPOT.  (THIS HAPPENS WHEN THE ADJACENCY OF
C  VI IS NOT IN CURRENT COLUMN ORDER DUE TO PIVOTING.)
C
          IF (VJ - PPK) 60,90,70
 60       PPK = VI
 70       PK = PPK
          PPK = P(PK)
          IF (PPK - VJ)  70,90,80
 80       P(VJ) = PPK
          P(PK) = VJ
          PPK = VJ
C
C  COMPUTE L(K,J) = L(K,J) - L(K,I)*U(I,J) FOR L(K,I) NONZERO
C  COMPUTE U*(K,J) = U*(K,J) - L(K,I)*U(I,J) FOR U(K,J) NONZERO
C  (U*(K,J) = U(K,J)*D(K,K))
C
 90       X(VJ) = X(VJ) + LKI * U(J)
 100    CONTINUE
        GO TO 50
C
C  PIVOT--INTERCHANGE LARGEST ENTRY OF K-TH ROW OF U WITH
C  THE DIAGONAL ENTRY.
C
C  FIND LARGEST ENTRY, COUNTING OFF-DIAGONAL NONZEROS
C
 110    IF (VI .GT. N) GO TO 1004
        XPVMAX = ABS(X(VI))
        MAXC = VI
        NZCNT = 0
        PV = VI
 120      V = PV
          PV = P(PV)
          IF (PV .GT. N) GO TO 130
          NZCNT = NZCNT + 1
          XPV = ABS(X(PV))
          IF (XPV .LE. XPVMAX) GO TO 120
          XPVMAX = XPV
          MAXC = PV
          MAXCL = V
          GO TO 120
 130    IF (XPVMAX .EQ. 0.0) GO TO 1004
C
C  IF VI = K, THEN THERE IS AN ENTRY FOR DIAGONAL
C  WHICH MUST BE DELETED.  OTHERWISE, DELETE THE
C  ENTRY WHICH WILL BECOME THE DIAGONAL ENTRY
C
        IF (VI .EQ. K) GO TO 140
        IF (VI .EQ. MAXC) GO TO 140
        P(MAXCL) = P(MAXC)
        GO TO 150
 140    VI = P(VI)
C
C  COMPUTE D(K) = 1/L(K,K) AND PERFORM INTERCHANGE.
C
 150    DK = 1.0 / X(MAXC)
        X(MAXC) = X(K)
        I = C(K)
        C(K) = C(MAXC)
        C(MAXC) = I
        CK = C(K)
        IC(CK) = K
        IC(I) = MAXC
        X(K) = 0.0
C
C  UPDATE RIGHT HAND SIDE.
C
        Y(K) = YK * DK
C
C  COMPUTE VALUE FOR IU(K+1) AND CHECK FOR STORAGE OVERFLOW
C
        IU(K+1) = IU(K) + NZCNT
        IF (IU(K+1) .GT. MAX+1) GO TO 1005
C
C  MOVE COLUMN INDICES FROM LINKED LIST TO JU.
C  COLUMNS ARE STORED IN CURRENT ORDER WITH ORIGINAL
C  COLUMN NUMBER (C(J)) STORED FOR CURRENT COLUMN J
C
        IF (VI .GT. N)  GO TO 170
        J = VI
 160      JUPTR = JUPTR + 1
          JU(JUPTR) = C(J)
          U(JUPTR) = X(J) * DK
          X(J) = 0.0
          J = P(J)
          IF (J .LE. N) GO TO 160
 170    CONTINUE
C
C  BACKSOLVE U X = Y, AND REORDER X TO CORRESPOND WITH A
C
      K = N
      DO 200 I = 1,N
        YK = Y(K)
        JMIN = IU(K)
        JMAX = IU(K+1) - 1
        IF (JMIN .GT. JMAX)  GO TO 190
        DO 180 J = JMIN,JMAX
          JUJ = JU(J)
          JUJ = IC(JUJ)
          YK = YK - U(J) * Y(JUJ)
 180    CONTINUE
 190    Y(K) = YK
        CK = C(K)
        X(CK) = YK
        K = K - 1
 200  CONTINUE
C
C  RETURN WITH IERR = NUMBER OF OFF-DIAGONAL NONZEROS IN U
C
      IERR = IU(N+1) - IU(1)
      RETURN
C
C  ERROR RETURNS
C
C  ROW K OF A IS NULL
C
 1002 IERR = -K
      RETURN
C
C  ROW K OF A HAS A DUPLICATE ENTRY
C
 1003 IERR = -(N+K)
      RETURN
C
C  ZERO PIVOT IN ROW K
C
 1004 IERR = -(2*N+K)
      RETURN
C
C  STORAGE FOR U EXCEEDED ON ROW K
C
 1005 IERR = -(3*N+K)
      RETURN
      END
