      SUBROUTINE U11LS (A,MDA,M,N,UB,DB,MODE,NP,KRANK,KSURE,H,W,EB,
     *                  IC,IR)
C
C       THIS ROUTINE PERFORMS A QR FACTORIZATION OF A
C       USING HOUSEHOLDER TRANSFORMATIONS. ROW AND
C       COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
C       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
C       DEFICIENCY.
C
      DIMENSION A(MDA,N),UB(N),DB(N),H(N),W(N),EB(N)
      INTEGER IC(N),IR(M)
C
C        INITIALIZATION
C
      J = 0
      KRANK = N
      DO 10 I = 1,N
         IC(I) = I
   10 CONTINUE
      DO 20 I = 1,M
         IR(I) = I
   20 CONTINUE
C
C        DETERMINE REL AND ABS ERROR VECTORS
C
C
C        CALCULATE COL LENGTH
C
      DO 30 I = 1,N
         H(I) = SNRM2(M,A(1,I),1)
         W(I) = H(I)
   30 CONTINUE
C
C         INITIALIZE ERROR BOUNDS
C
      DO 40 I = 1,N
         EB(I) = AMAX1(DB(I),UB(I)*H(I))
         UB(I) = EB(I)
         DB(I) = 0.0
   40 CONTINUE
C
C          DISCARD SELF DEPENDENT COLUMNS
C
      I = 1
   50 IF (EB(I) .GE. H(I)) GO TO 60
      IF (I .EQ. KRANK) GO TO 70
      I = I + 1
      GO TO 50
C
C          MATRIX REDUCTION
C
   60 KK = KRANK
      KRANK = KRANK - 1
      IF (MODE .EQ. 0) RETURN
      IF (I .LE. NP) GO TO 400
      IF (I .GT. KRANK) GO TO 70
      CALL SSWAP (1,EB(I),1,EB(KK),1)
      CALL SSWAP (1,UB(I),1,UB(KK),1)
      CALL SSWAP (1,W(I),1,W(KK),1)
      CALL SSWAP (1,H(I),1,H(KK),1)
      CALL ISWAP (1,IC(I),1,IC(KK),1)
      CALL SSWAP (M,A(1,I),1,A(1,KK),1)
      GO TO 50
C
C           TEST FOR ZERO RANK
C
   70 IF (KRANK .GT. 0) GO TO 100
      KRANK = 0
      KSURE = 0
      RETURN
C
C        M A I N    L O O P
C
  100 J = J + 1
      JP1 = J + 1
      JM1 = J - 1
      KZ = KRANK
      IF (J .LE. NP) KZ = J
C
C        EACH COL HAS MM=M-J+1 COMPONENTS
C
      MM = M - J + 1
C
C         UB DETERMINES COLUMN PIVOT
C
  110 IMIN = J
      IF (H(J) .EQ. 0.0) GO TO 170
      RMIN = UB(J)/H(J)
      DO 120 I = J,KZ
         IF (UB(I) .GE. H(I)*RMIN) GO TO 120
         RMIN = UB(I)/H(I)
         IMIN = I
  120 CONTINUE
C
C     TEST FOR RANK DEFICIENCY
C
      IF (RMIN .LT. 1.0) GO TO 200
      TT = (EB(IMIN) + ABS(DB(IMIN)))/H(IMIN)
      IF (TT .GE. 1.0) GO TO 170
C
C     COMPUTE EXACT UB
C
      DO 125 I = 1,JM1
         W(I) = A(I,IMIN)
  125 CONTINUE
C
      L = JM1
  130 W(L) = W(L)/A(L,L)
      IF (L .EQ. 1) GO TO 150
      LM1 = L - 1
      DO 140 I = L,JM1
         W(LM1) = W(LM1) - A(LM1,I)*W(I)
  140 CONTINUE
      L = LM1
      GO TO 130
C
  150 TT = EB(IMIN)
      DO 160 I = 1,JM1
         TT = TT + ABS(W(I))*EB(I)
  160 CONTINUE
      UB(IMIN) = TT
      IF (UB(IMIN)/H(IMIN) .GE. 1.0) GO TO 170
      GO TO 200
C
C        MATRIX REDUCTION
C
  170 KK = KRANK
      KRANK = KRANK - 1
      KZ = KRANK
      IF (MODE .EQ. 0) RETURN
      IF (J .LE. NP) GO TO 410
      IF (IMIN .GT. KRANK) GO TO 180
         CALL ISWAP (1,IC(IMIN),1,IC(KK),1)
         CALL SSWAP (M,A(1,IMIN),1,A(1,KK),1)
         CALL SSWAP (1,EB(IMIN),1,EB(KK),1)
         CALL SSWAP (1,UB(IMIN),1,UB(KK),1)
         CALL SSWAP (1,DB(IMIN),1,DB(KK),1)
         CALL SSWAP (1,W(IMIN),1,W(KK),1)
         CALL SSWAP (1,H(IMIN),1,H(KK),1)
  180 IF (J .GT. KRANK) GO TO 300
      GO TO 110
C
C        COLUMN PIVOT
C
  200 IF (IMIN .EQ. J) GO TO 210
      CALL SSWAP (1,H(J),1,H(IMIN),1)
      CALL SSWAP (M,A(1,J),1,A(1,IMIN),1)
      CALL SSWAP (1,EB(J),1,EB(IMIN),1)
      CALL SSWAP (1,UB(J),1,UB(IMIN),1)
      CALL SSWAP (1,DB(J),1,DB(IMIN),1)
      CALL SSWAP (1,W(J),1,W(IMIN),1)
      CALL ISWAP (1,IC(J),1,IC(IMIN),1)
C
C        ROW PIVOT
C
  210 JMAX = ISAMAX(MM,A(J,J),1)
      JMAX = JMAX + J - 1
      IF (JMAX .EQ. J) GO TO 220
      CALL SSWAP (N,A(J,1),MDA,A(JMAX,1),MDA)
      CALL ISWAP (1,IR(J),1,IR(JMAX),1)
C
C     APPLY HOUSEHOLDER TRANSFORMATION
C
  220 TN = SNRM2(MM,A(J,J),1)
      IF (TN .EQ. 0.0) GO TO 170
      IF (A(J,J) .NE. 0.0) TN = SIGN(TN,A(J,J))
      CALL SSCAL (MM,1.0/TN,A(J,J),1)
      A(J,J) = A(J,J) + 1.0
      IF (J .EQ. N) GO TO 250
      DO 240 I = JP1,N
         BB = -SDOT(MM,A(J,J),1,A(J,I),1)/A(J,J)
         CALL SAXPY (MM,BB,A(J,J),1,A(J,I),1)
         IF (I .LE. NP) GO TO 240
         IF (H(I) .EQ. 0.0) GO TO 240
         TT = 1.0 - (A(J,I)/H(I))**2
         TT = AMAX1(TT,0.0)
         T = TT
         TT = 1.0 + 0.05*TT*(H(I)/W(I))**2
         IF (TT .EQ. 1.0) GO TO 230
            H(I) = H(I)*SQRT(T)
            GO TO 240
  230    H(I) = SNRM2(M-J,A(J+1,I),1)
         W(I) = H(I)
  240 CONTINUE
C
  250 H(J) = A(J,J)
      A(J,J) = -TN
C
C          UPDATE UB, DB
C
      UB(J) = UB(J)/ABS(A(J,J))
      DB(J) = (SIGN(EB(J),DB(J)) + DB(J))/A(J,J)
      IF (J .EQ. KRANK) GO TO 300
      DO 260 I = JP1,KRANK
         UB(I) = UB(I) + ABS(A(J,I))*UB(J)
         DB(I) = DB(I) - A(J,I)*DB(J)
  260 CONTINUE
      GO TO 100
C
C        E N D    M A I N    L O O P
C
  300 CONTINUE
C
C        COMPUTE KSURE
C
      KM1 = KRANK - 1
      DO 315 I = 1,KM1
         IS = 0
         KMI = KRANK - I
         DO 310 II = 1,KMI
            IF (UB(II) .LE. UB(II + 1)) GO TO 310
            IS = 1
            TEMP = UB(II)
            UB(II) = UB(II + 1)
            UB(II + 1) = TEMP
  310    CONTINUE
         IF (IS .EQ. 0) GO TO 320
  315 CONTINUE
C
  320 KSURE = 0
      SUM = 0.0
      DO 325 I = 1,KRANK
         R2 = UB(I)*UB(I)
         IF (R2 + SUM .GE. 1.0) GO TO 330
         SUM = SUM + R2
         KSURE = KSURE + 1
  325 CONTINUE
C
C     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
C     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
C
  330 IF (KRANK .EQ. N .OR. MODE .LT. 2) RETURN
      NMK = N - KRANK
      KP1 = KRANK + 1
      I = KRANK
  340    TN = SNRM2(NMK,A(I,KP1),MDA)/A(I,I)
         TN = A(I,I)*SQRT(1.0 + TN*TN)
         CALL SSCAL (NMK,1.0/TN,A(I,KP1),MDA)
         W(I) = A(I,I)/TN + 1.0
         A(I,I) = -TN
         IF (I .EQ. 1) GO TO 350
         IM1 = I - 1
         DO 345 II = 1,IM1
            TT = -SDOT(NMK,A(II,KP1),MDA,A(I,KP1),MDA)/W(I)
            TT = TT - A(II,I)
            CALL SAXPY (NMK,TT,A(I,KP1),MDA,A(II,KP1),MDA)
            A(II,I) = A(II,I) + TT*W(I)
  345    CONTINUE
         I = I - 1
         GO TO 340
C
  350 CONTINUE
      RETURN
C
C     FIRST NP COLUMNS ARE LINEARLY DEPENDENT
C
  400 KRANK = I - 1
      RETURN
  410 KRANK = J - 1
      RETURN
      END
      SUBROUTINE U12LS (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,H,W,IC,IR)
C
C        GIVEN THE HOUSEHOLDER QR FACTORIZATION OF A, THIS
C        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
C        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
C        ACCORDING TO THE SELECTED MODE.
C
C       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
C
      DIMENSION A(MDA,N),B(MDB,NB),RNORM(NB),H(N),W(N)
      INTEGER IC(N),IR(M)
C
      K = KRANK
      KP1 = K + 1
      IF (K .GT. 0) GO TO 30
C
C        RANK=0
C
      DO 10 JB = 1,NB
         RNORM(JB) = SNRM2(M,B(1,JB),1)
   10 CONTINUE
      DO 21 JB = 1,NB
         DO 20 I = 1,N
            B(I,JB) = 0.0
   20    CONTINUE
   21 CONTINUE
      RETURN
C
   30 I = 0
C
C     REORDER B TO REFLECT ROW INTERCHANGES
C
   40    I = I + 1
         IF (I .EQ. M) GO TO 100
         J = IR(I)
         IF (J .EQ. I) GO TO 40
         IF (J .LT. 0) GO TO 40
C
         IR(I) = -IR(I)
         DO 50 JB = 1,NB
            RNORM(JB) = B(I,JB)
   50    CONTINUE
C
         IJ = I
   60       DO 70 JB = 1,NB
               B(IJ,JB) = B(J,JB)
   70       CONTINUE
            IJ = J
            J = IR(IJ)
            IR(IJ) = -IR(IJ)
         IF (J .NE. I) GO TO 60
C
         DO 80 JB = 1,NB
            B(IJ,JB) = RNORM(JB)
   80    CONTINUE
         GO TO 40
C
  100 DO 110 I = 1,M
         IR(I) = IABS(IR(I))
  110 CONTINUE
C
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
C
      DO 130 J = 1,K
         TT = A(J,J)
         A(J,J) = H(J)
         DO 120 I = 1,NB
            BB = -SDOT (M-J+1,A(J,J),1,B(J,I),1)/H(J)
            CALL SAXPY (M-J+1,BB,A(J,J),1,B(J,I),1)
  120    CONTINUE
         A(J,J) = TT
  130 CONTINUE
C
C        FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
C
      DO 140 JB = 1,NB
         RNORM(JB) = SNRM2(M-K,B(KP1,JB),1)
  140 CONTINUE
C
C     BACK SOLVE UPPER TRIANGULAR R
C
      I = K
  150 DO 160 JB = 1,NB
         B(I,JB) = B(I,JB)/A(I,I)
  160 CONTINUE
      IF (I .EQ. 1) GO TO 200
      IM1 = I - 1
      DO 170 JB = 1,NB
         CALL SAXPY (IM1,-B(I,JB),A(1,I),1,B(1,JB),1)
  170 CONTINUE
      I = IM1
      GO TO 150
C
C     RANK LT N
C
C      TRUNCATED SOLUTION
C
  200 IF (K .EQ. N) GO TO 230
      DO 211 JB = 1,NB
         DO 210 I = KP1,N
            B(I,JB) = 0.0
  210    CONTINUE
  211 CONTINUE
      IF (MODE .EQ. 1) GO TO 230
C
C      MINIMAL LENGTH SOLUTION
C
      NMK = N - K
      DO 221 JB = 1,NB
         DO 220 I = 1,K
            TT = -SDOT(NMK,A(I,KP1),MDA,B(KP1,JB),1)/W(I)
            TT = TT - B(I,JB)
            CALL SAXPY (NMK,TT,A(I,KP1),MDA,B(KP1,JB),1)
            B(I,JB) = B(I,JB) + TT*W(I)
  220    CONTINUE
  221 CONTINUE
C
C     REORDER B TO REFLECT COLUMN INTERCHANGES
C
  230 I = 0
C
  240    I = I + 1
         IF (I .EQ. N) GO TO 260
         J = IC(I)
         IF (J .EQ. I) GO TO 240
         IF (J .LT. 0) GO TO 240
C
         IC(I) = -IC(I)
  250       CALL SSWAP (NB,B(J,1),MDB,B(I,1),MDB)
            IJ = IC(J)
            IC(J) = -IC(J)
            J = IJ
         IF (J .NE. I) GO TO 250
         GO TO 240
C
  260 DO 270 I = 1,N
         IC(I) = IABS(IC(I))
  270 CONTINUE
      RETURN
      END
      SUBROUTINE U11US (A,MDA,M,N,UB,DB,MODE,NP,KRANK,KSURE,H,W,EB,
     *                  IR,IC)
C
C       THIS ROUTINE PERFORMS AN LQ FACTORIZATION OF THE
C       MATRIX A USING HOUSEHOLDER TRANSFORMATIONS. ROW
C       AND COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
C       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
C       DEFICIENCY.
C
      DIMENSION A(MDA,N),UB(M),DB(M),H(M),W(M),EB(M)
      INTEGER IC(N),IR(M)
C
C        INITIALIZATION
C
      J = 0
      KRANK = M
      DO 10 I = 1,N
         IC(I) = I
   10 CONTINUE
      DO 20 I = 1,M
         IR(I) = I
   20 CONTINUE
C
C        DETERMINE REL AND ABS ERROR VECTORS
C
C
C        CALCULATE ROW LENGTH
C
      DO 30 I = 1,M
         H(I) = SNRM2(N,A(I,1),MDA)
         W(I) = H(I)
   30 CONTINUE
C
C         INITIALIZE ERROR BOUNDS
C
      DO 40 I = 1,M
         EB(I) = AMAX1(DB(I),UB(I)*H(I))
         UB(I) = EB(I)
         DB(I) = 0.0
   40 CONTINUE
C
C          DISCARD SELF DEPENDENT ROWS
C
      I = 1
   50 IF (EB(I) .GE. H(I)) GO TO 60
      IF (I .EQ. KRANK) GO TO 70
      I = I + 1
      GO TO 50
C
C          MATRIX REDUCTION
C
   60 KK = KRANK
      KRANK = KRANK - 1
      IF (MODE .EQ. 0) RETURN
      IF (I .LE. NP) GO TO 400
      IF (I .GT. KRANK) GO TO 70
      CALL SSWAP (1,EB(I),1,EB(KK),1)
      CALL SSWAP (1,UB(I),1,UB(KK),1)
      CALL SSWAP (1,W(I),1,W(KK),1)
      CALL SSWAP (1,H(I),1,H(KK),1)
      CALL ISWAP (1,IR(I),1,IR(KK),1)
      CALL SSWAP (N,A(I,1),MDA,A(KK,1),MDA)
      GO TO 50
C
C           TEST FOR ZERO RANK
C
   70 IF (KRANK .GT. 0) GO TO 100
      KRANK = 0
      KSURE = 0
      RETURN
C
C        M A I N    L O O P
C
  100 J = J + 1
      JP1 = J + 1
      JM1 = J - 1
      KZ = KRANK
      IF (J .LE. NP) KZ = J
C
C        EACH ROW HAS NN=N-J+1 COMPONENTS
C
      NN = N - J + 1
C
C         UB DETERMINES ROW PIVOT
C
  110 IMIN = J
      IF (H(J) .EQ. 0.0) GO TO 170
      RMIN = UB(J)/H(J)
      DO 120 I = J,KZ
         IF (UB(I) .GE. H(I)*RMIN) GO TO 120
         RMIN = UB(I)/H(I)
         IMIN = I
  120 CONTINUE
C
C     TEST FOR RANK DEFICIENCY
C
      IF (RMIN .LT. 1.0) GO TO 200
      TT = (EB(IMIN) + ABS(DB(IMIN)))/H(IMIN)
      IF (TT .GE. 1.0) GO TO 170
C
C     COMPUTE EXACT UB
C
      DO 125 I = 1,JM1
         W(I) = A(IMIN,I)
  125 CONTINUE
C
      L = JM1
  130 W(L) = W(L)/A(L,L)
      IF (L .EQ. 1) GO TO 150
      LM1 = L - 1
      DO 140 I = L,JM1
         W(LM1) = W(LM1) - A(I,LM1)*W(I)
  140 CONTINUE
      L = LM1
      GO TO 130
C
  150 TT = EB(IMIN)
      DO 160 I = 1,JM1
         TT = TT + ABS(W(I))*EB(I)
  160 CONTINUE
      UB(IMIN) = TT
      IF (UB(IMIN)/H(IMIN) .GE. 1.0) GO TO 170
      GO TO 200
C
C        MATRIX REDUCTION
C
  170 KK = KRANK
      KRANK = KRANK - 1
      KZ = KRANK
      IF (MODE .EQ. 0) RETURN
      IF (J .LE. NP) GO TO 410
      IF (IMIN .GT. KRANK) GO TO 180
         CALL ISWAP (1,IR(IMIN),1,IR(KK),1)
         CALL SSWAP (N,A(IMIN,1),MDA,A(KK,1),MDA)
         CALL SSWAP (1,EB(IMIN),1,EB(KK),1)
         CALL SSWAP (1,UB(IMIN),1,UB(KK),1)
         CALL SSWAP (1,DB(IMIN),1,DB(KK),1)
         CALL SSWAP (1,W(IMIN),1,W(KK),1)
         CALL SSWAP (1,H(IMIN),1,H(KK),1)
  180 IF (J .GT. KRANK) GO TO 300
      GO TO 110
C
C        ROW PIVOT
C
  200 IF (IMIN .EQ. J) GO TO 210
      CALL SSWAP (1,H(J),1,H(IMIN),1)
      CALL SSWAP (N,A(J,1),MDA,A(IMIN,1),MDA)
      CALL SSWAP (1,EB(J),1,EB(IMIN),1)
      CALL SSWAP (1,UB(J),1,UB(IMIN),1)
      CALL SSWAP (1,DB(J),1,DB(IMIN),1)
      CALL SSWAP (1,W(J),1,W(IMIN),1)
      CALL ISWAP (1,IR(J),1,IR(IMIN),1)
C
C        COLUMN PIVOT
C
  210 JMAX = ISAMAX(NN,A(J,J),MDA)
      JMAX = JMAX + J - 1
      IF (JMAX .EQ. J) GO TO 220
      CALL SSWAP (M,A(1,J),1,A(1,JMAX),1)
      CALL ISWAP (1,IC(J),1,IC(JMAX),1)
C
C     APPLY HOUSEHOLDER TRANSFORMATION
C
  220 TN = SNRM2(NN,A(J,J),MDA)
      IF (TN .EQ. 0.0) GO TO 170
      IF (A(J,J) .NE. 0.0) TN = SIGN(TN,A(J,J))
      CALL SSCAL (NN,1.0/TN,A(J,J),MDA)
      A(J,J) = A(J,J) + 1.0
      IF (J .EQ. M) GO TO 250
      DO 240 I = JP1,M
         BB = -SDOT(NN,A(J,J),MDA,A(I,J),MDA)/A(J,J)
         CALL SAXPY (NN,BB,A(J,J),MDA,A(I,J),MDA)
         IF (I .LE. NP) GO TO 240
         IF (H(I) .EQ. 0.0) GO TO 240
         TT = 1.0 - (A(I,J)/H(I))**2
         TT = AMAX1(TT,0.0)
         T = TT
         TT = 1.0 + 0.05*TT*(H(I)/W(I))**2
         IF (TT .EQ. 1.0) GO TO 230
            H(I) = H(I)*SQRT(T)
            GO TO 240
  230    H(I) = SNRM2(N-J,A(I,J+1),MDA)
         W(I) = H(I)
  240 CONTINUE
C
  250 H(J) = A(J,J)
      A(J,J) = -TN
C
C          UPDATE UB, DB
C
      UB(J) = UB(J)/ABS(A(J,J))
      DB(J) = (SIGN(EB(J),DB(J))+DB(J))/A(J,J)
      IF (J .EQ. KRANK) GO TO 300
      DO 260 I = JP1,KRANK
         UB(I) = UB(I) + ABS(A(I,J))*UB(J)
         DB(I) = DB(I) - A(I,J)*DB(J)
  260 CONTINUE
      GO TO 100
C
C        E N D    M A I N    L O O P
C
  300 CONTINUE
C
C        COMPUTE KSURE
C
      KM1 = KRANK - 1
      DO 315 I = 1,KM1
         IS = 0
         KMI = KRANK - I
         DO 310 II = 1,KMI
            IF (UB(II) .LE. UB(II + 1)) GO TO 310
            IS = 1
            TEMP = UB(II)
            UB(II) = UB(II + 1)
            UB(II + 1) = TEMP
  310    CONTINUE
         IF (IS .EQ. 0) GO TO 320
  315 CONTINUE
C
  320 KSURE = 0
      SUM = 0.0
      DO 325 I = 1,KRANK
         R2 = UB(I)*UB(I)
         IF (R2 + SUM .GE. 1.0) GO TO 330
         SUM = SUM + R2
         KSURE = KSURE + 1
  325 CONTINUE
C
C     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
C     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
C
  330 IF (KRANK .EQ. M .OR. MODE .LT. 2) RETURN
      MMK = M - KRANK
      KP1 = KRANK + 1
      I = KRANK
  340    TN = SNRM2(MMK,A(KP1,I),1)/A(I,I)
         TN = A(I,I)*SQRT(1.0 + TN*TN)
         CALL SSCAL (MMK,1.0/TN,A(KP1,I),1)
         W(I) = A(I,I)/TN + 1.0
         A(I,I) = -TN
         IF (I .EQ. 1) GO TO 350
         IM1 = I - 1
         DO 345 II = 1,IM1
            TT = -SDOT(MMK,A(KP1,II),1,A(KP1,I),1)/W(I)
            TT = TT - A(I,II)
            CALL SAXPY (MMK,TT,A(KP1,I),1,A(KP1,II),1)
            A(I,II) = A(I,II) + TT*W(I)
  345    CONTINUE
         I = I - 1
         GO TO 340
C
  350 CONTINUE
      RETURN
C
C     FIRST NP ROWS ARE LINEARLY DEPENDENT
C
  400 KRANK = I - 1
      RETURN
  410 KRANK = J - 1
      RETURN
      END
      SUBROUTINE U12US (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,H,W,IR,IC)
C
C        GIVEN THE HOUSEHOLDER LQ FACTORIZATION OF A, THIS
C        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
C        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
C        ACCORDING TO THE SELECTED MODE.
C
C       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
C
      DIMENSION A(MDA,N),B(MDB,NB),RNORM(NB),H(M),W(M)
      INTEGER IC(N),IR(M)
C
      K = KRANK
      KP1 = K + 1
      IF (K .GT. 0) GO TO 30
C
C        RANK=0
C
      DO 10 JB = 1,NB
         RNORM(JB) = SNRM2(M,B(1,JB),1)
   10 CONTINUE
      DO 21 JB = 1,NB
         DO 20 I = 1,N
            B(I,JB) = 0.0
   20    CONTINUE
   21 CONTINUE
      RETURN
C
   30 I = 0
C
C     REORDER B TO REFLECT ROW INTERCHANGES
C
   40    I = I + 1
         IF (I .EQ. M) GO TO 100
         J = IR(I)
         IF (J .EQ. I) GO TO 40
         IF (J .LT. 0) GO TO 40
C
         IR(I) = -IR(I)
         DO 50 JB = 1,NB
            RNORM(JB) = B(I,JB)
   50    CONTINUE
C
         IJ = I
   60       DO 70 JB = 1,NB
               B(IJ,JB) = B(J,JB)
   70       CONTINUE
            IJ = J
            J = IR(IJ)
            IR(IJ) = -IR(IJ)
         IF (J .NE. I) GO TO 60
C
         DO 80 JB = 1,NB
            B(IJ,JB) = RNORM(JB)
   80    CONTINUE
         GO TO 40
C
  100 DO 110 I = 1,M
         IR(I) = IABS(IR(I))
  110 CONTINUE
C
C     IF A IS OF REDUCED RANK AND MODE=2,
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
C
      IF (MODE .LT. 2 .OR. K .EQ. M) GO TO 140
      MMK = M - K
      DO 130 JB = 1,NB
         DO 120 J = 1,K
            I = KP1 - J
            TT = -SDOT(MMK,A(KP1,I),1,B(KP1,JB),1)/W(I)
            TT = TT - B(I,JB)
            CALL SAXPY (MMK,TT,A(KP1,I),1,B(KP1,JB),1)
            B(I,JB) = B(I,JB) + TT*W(I)
  120    CONTINUE
  130 CONTINUE
C
C     FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
C
  140 DO 150 JB = 1,NB
         RNORM(JB) = SNRM2(M-K,B(KP1,JB),1)
  150 CONTINUE
C
C     BACK SOLVE LOWER TRIANGULAR L
C
      DO 170 JB = 1,NB
         DO 160 I = 1,K
            B(I,JB) = B(I,JB)/A(I,I)
            IF (I .EQ. K) GO TO 170
            IP1 = I + 1
            CALL SAXPY(K-I,-B(I,JB),A(IP1,I),1,B(IP1,JB),1)
  160    CONTINUE
  170 CONTINUE
C
C      TRUNCATED SOLUTION
C
      IF (K .EQ. N) GO TO 210
      DO 201 JB = 1,NB
         DO 200 I = KP1,N
            B(I,JB) = 0.0
  200    CONTINUE
  201 CONTINUE
C
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
C
  210 DO 230 I = 1,K
         J = KP1 - I
         TT = A(J,J)
         A(J,J) = H(J)
         DO 220 JB = 1,NB
            BB = -SDOT(N-J+1,A(J,J),MDA,B(J,JB),1)/H(J)
            CALL SAXPY(N-J+1,BB,A(J,J),MDA,B(J,JB),1)
  220    CONTINUE
         A(J,J) = TT
  230 CONTINUE
C
C     REORDER B TO REFLECT COLUMN INTERCHANGES
C
      I = 0
C
  240    I = I + 1
         IF (I .EQ. N) GO TO 260
         J = IC(I)
         IF (J .EQ. I) GO TO 240
         IF (J .LT. 0) GO TO 240
C
         IC(I) = -IC(I)
  250       CALL SSWAP (NB,B(J,1),MDB,B(I,1),MDB)
            IJ = IC(J)
            IC(J) = -IC(J)
            J = IJ
         IF (J .NE. I) GO TO 250
         GO TO 240
C
  260 DO 270 I = 1,N
         IC(I) = IABS(IC(I))
  270 CONTINUE
      RETURN
      END
      SUBROUTINE DLSQR (IND, A, MDA, M, N, B, MDB, NB, RE, AE, KRANK,
     *                  KSURE, RNORM, WORK, LW, IWORK, LIW, IERR)
C-----------------------------------------------------------------------
C
C              LEAST SQUARES SOLUTION OF LINEAR EQUATIONS
C
C                            --------------
C
C     DLSQR SOLVES BOTH UNDERDETERMINED AND OVERDETERMINED LINEAR
C     SYSTEMS AX = B, WHERE A IS AN M BY N MATRIX AND B IS AN M BY
C     NB MATRIX OF RIGHT HAND SIDES. IF M .GE. N, THE LEAST SQUARES
C     SOLUTION IS COMPUTED BY DECOMPOSING THE MATRIX A INTO THE
C     PRODUCT OF AN ORTHOGONAL MATRIX Q AND UPPER TRIANGULAR MATRIX
C     R (QR FACTORIZATION). IF M .LT. N, THE MINIMAL LENGTH SOLUTION
C     IS COMPUTED BY FACTORING THE MATRIX A INTO THE PRODUCT OF A
C     LOWER TRIANGULAR MATRIX L AND ORTHOGONAL MATRIX Q (LQ FACTOR-
C     IZATION). IF THE MATRIX A IS DETERMINED TO BE RANK DEFICIENT,
C     THEN THE MINIMAL LENGTH LEAST SQUARES SOLUTION IS COMPUTED.
C
C     USER INPUT BOUNDS ON THE UNCERTAINTY OF THE ELEMENTS OF A ARE
C     USED TO DETECT NUMERICAL RANK DEFICIENCY. THE ALGORITHM USES
C     A ROW AND COLUMN PIVOT STRATEGY TO MINIMIZE THE GROWTH OF
C     UNCERTAINTY AND ROUND-OFF ERRORS.
C
C   ******************************************************************
C   *                                                                *
C   *         WARNING - ALL INPUT ARRAYS ARE CHANGED ON EXIT.        *
C   *                                                                *
C   ******************************************************************
C
C     INPUT..
C
C     IND           INTEGER WHICH INDICATES IF THE ROUTINE IS BEING
C                   CALLED FOR THE FIRST TIME.
C                      IND = 0      ORIGINAL CALL
C                      IND .NE. 0   SUBSEQUENT CALLS
C                   ON SUBSEQUENT CALLS A NEW SET B OF EQUATIONS CAN
C                   BE SOLVED (USING THE SAME COEFFICIENT MATRIX A).
C                   IT IS ASSUMED THAT A, MDA, M, N, KRANK, IWORK,
C                   LIW, AND THE FIRST 2*MIN(M,N) LOCATIONS OF WORK
C                   HAVE NOT BEEN MODIFIED BY THE USER. RE, AE, AND
C                   KSURE ARE NOT USED.
C
C     A(,)          LINEAR COEFFICIENT MATRIX OF AX=B, WITH MDA THE
C      MDA,M,N      ACTUAL FIRST DIMENSION OF A IN THE CALLING PROGRAM.
C                   M IS THE ROW DIMENSION (NO. OF EQUATIONS OF THE
C                   PROBLEM) AND N THE COL DIMENSION (NO. OF UNKNOWNS).
C                   MUST HAVE MDA .GE. M.
C
C     B(,)          RIGHT HAND SIDE(S), WITH MDB THE ACTUAL FIRST
C      MDB,NB       DIMENSION OF B IN THE CALLING PROGRAM. NB IS THE
C                   NUMBER OF M BY 1 RIGHT HAND SIDES. MUST HAVE
C                   MDB .GE. MAX(M,N). IF NB .LE. 0 THEN B AND MDB
C                   ARE IGNORED.
C
C     RE            RE IS THE MAXIMUM RELATIVE UNCERTAINTY OF THE
C                   ELEMENTS OF THE MATRIX A (0 .LE. RE .LT. 1).
C
C     AE            AE IS THE MAXIMUM ABSOLUTE UNCERTAINTY OF THE
C                   ELEMENTS OF THE MATRIX A (AE .GE. 0).
C
C     WORK()        A REAL WORK ARRAY DIMENSIONED 5*MIN(M,N).
C
C     LW            ACTUAL DIMENSION OF WORK
C
C     IWORK()       INTEGER WORK ARRAY DIMENSIONED AT LEAST N+M.
C
C     LIW           ACTUAL DIMENSION OF IWORK.
C
C     OUTPUT..
C
C     A(,)          CONTAINS THE TRIANGULAR PART OF THE REDUCED MATRIX
C                   AND THE TRANSFORMATION INFORMATION.IND TOGETHER WITH
C                   THE FIRST 2*MIN(M,N) ELEMENTS OF WORK (SEE BELOW)
C                   COMPLETELY SPECIFY THE FACTORIZATION OF A.
C
C     B(,)          CONTAINS THE N BY NB SOLUTION MATRIX FOR X.
C
C     KRANK,KSURE   THE NUMERICAL RANK OF A,  BASED UPON THE RELATIVE
C                   AND ABSOLUTE BOUNDS ON UNCERTAINTY, IS BOUNDED
C                   ABOVE BY KRANK AND BELOW BY KSURE. THE ALGORITHM
C                   RETURNS A SOLUTION BASED ON KRANK. KSURE PROVIDES
C                   AN INDICATION OF THE PRECISION OF THE RANK.
C
C     RNORM()       CONTAINS THE EUCLIDEAN LENGTH OF THE NB RESIDUAL
C                   VECTORS  B(I) - AX(I), I=1,...,NB.
C
C     WORK()        THE FIRST 2*MIN(M,N) LOCATIONS OF WORK CONTAIN
C                   THE VALUES NECESSARY TO REPRODUCE THE HOUSEHOLDER
C                   FACTORIZATION OF A.
C
C     IWORK()       AN ARRAY OF LENGTH M + N CONTAINING THE ORDERS IN
C                   WHICH THE ROWS AND COLUMNS WERE USED. IF M .GE. N
C                   THEN THE FIRST N LOCATIONS CONTAIN THE ORDER OF
C                   THE COLUMNS AND THE NEXT M LOCATIONS THE ORDER OF
C                   THE ROWS. IF M .LT. N THEN THE ORDER OF THE ROWS
C                   PRECEDES THE ORDER OF THE COLUMNS.
C
C     IERR          FLAG TO INDICATE THE STATUS OF THE RESULTS
C                     0     - SATISFACTORY COMPLETION
C                   .GT. 0  - INPUT ERROR
C
C----------------
C     THE SUBROUTINES DU11LS, DU12LS, DU11US, AND DU12US WERE WRITTEN BY
C     T. MANTEUFFEL (LANL) IN 1981. THE DRIVER ROUTINE DLSQR WAS WRITTEN
C     BY A.H. MORRIS (NSWC) IN 1991.
C----------------
C     REFERENCE.  MANTEUFFEL, T., *AN INTERVAL ANALYSIS APPROACH TO RANK
C                 DETERMINATION IN LINEAR LEAST SQUARES PROBLEMS*,
C                 SANDIA LABORATORIES REPORT SAND80-0655, JUNE, 1980.
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(MDA,N), B(MDB,*), RE, AE, RNORM(*), WORK(LW)
      INTEGER IWORK(LIW)
      DOUBLE PRECISION EPS, RERR
      DOUBLE PRECISION DPMPAR
C----------------
C     NP            IF M .GE. N THEN THE FIRST NP COLUMNS OF A
C                   ARE NEVER INTERCHANGED.
C                   IF M .LT. N THEN THE FIRST NP ROWS OF A ARE
C                   NEVER INTERCHANGED. NP IS NOT REFERENCED ON
C                   A CONTINUATION CALL TO THE ROUTINE.
C
C     MODE          THE INTEGER MODE INDICATES HOW THE ROUTINE
C                   IS TO REACT IF RANK DEFICIENCY IS DETECTED.
C                   IF MODE = 0 RETURN IMMEDIATELY, NO SOLUTION
C                             1 COMPUTE TRUNCATED SOLUTION
C                             2 COMPUTE MINIMAL LENGTH SOLUTION
C                   MODE MUST NOT BE MODIFIED ON A CONTINUATION
C                   CALL TO THE ROUTINE. IF MODE LT. 2, ONLY THE
C                   FIRST N LOCATIONS OF WORK ARE USED.
C----------------
      NP = 0
      MODE = 2
C
C     CHECK THE INPUT
C
      IF (NB .LE. 0 .AND. IND .NE. 0) GO TO 200
      IF (M .LT. 1 .OR. N .LT. 1) GO TO 210
      IF (MDA .LT. M) GO TO 220
      IF (LIW .LT. M + N) GO TO 240
C
      M0 = MIN0(M,N)
      N0 = MAX0(M,N)
C     NUM = 0
C
      IF (NB .LE. 0) GO TO 10
      IF (MDB .LT. N0) GO TO 230
      IF (IND .NE. 0) GO TO 100
C
   10 IF (LW .LT. 5*M0) GO TO 250
      IF (RE .LT. 0.D0 .OR. AE .LT. 0.D0) GO TO 260
C
C     DEFINE THE RELATIVE AND ABSOLUTE TOLERANCE LISTS
C
      M1 = 1
      M2 = M1 + M0
      M3 = M2 + M0
      M4 = M3 + M0
      M5 = M4 + M0
C
      EPS = 10.D0*DPMPAR(1)
      RERR = DMAX1(EPS,RE)
C
      IMAX = M5 - 1
      DO 20 I = M4,IMAX
         WORK(I) = RERR
   20 CONTINUE
      IMAX = IMAX + M0
      DO 30 I = M5,IMAX
         WORK(I) = AE
   30 CONTINUE
C
C     FACTOR THE MATRIX A
C
C     NUM = NP
      IF (M .LT. N) GO TO 40
C
         CALL DU11LS (A,MDA,M,N,WORK(M4),WORK(M5),MODE,NP,KRANK,KSURE,
     *                WORK(M1),WORK(M2),WORK(M3),IWORK(M1),IWORK(M2))
         GO TO 100
C
   40 CALL DU11US (A,MDA,M,N,WORK(M4),WORK(M5),MODE,NP,KRANK,KSURE,
     *             WORK(M1),WORK(M2),WORK(M3),IWORK(M1),IWORK(M2))
C
C     SOLUTION PHASE
C
  100 IERR = 0
      INFO = 0
      IF (KRANK .EQ. M0) GO TO 110
      IF (KRANK .EQ. 0) GO TO 110
C     IF (KRANK .LT. NUM) GO TO 280
C     IF (MODE .EQ. 0) RETURN
      INFO = MODE
C
  110 IF (NB .LE. 0) RETURN
C
      M1 = 1
      M2 = 1 + M0
      IF (INFO .EQ. 2) GO TO 130
C
C     ONLY MIN(M,N) ELEMENTS OF WORK ARE NEEDED
C
      IF (LW .LT. M0) GO TO 250
      IF (M .LT. N) GO TO 120
C
         CALL DU12LS (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,
     *                WORK(M1),WORK(M1),IWORK(M1),IWORK(M2))
         RETURN
C
  120 CALL DU12US (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,
     *             WORK(M1),WORK(M1),IWORK(M1),IWORK(M2))
      RETURN
C
C     HERE 2*MIN(M,N) ELEMENTS OF WORK ARE NEEDED
C
  130 IF (LW .LT. 2*M0) GO TO 250
      IF (M .LT. N) GO TO 140
C
         CALL DU12LS (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,
     *                WORK(M1),WORK(M2),IWORK(M1),IWORK(M2))
         RETURN
C
 140  CALL DU12US (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,
     *             WORK(M1),WORK(M2),IWORK(M1),IWORK(M2))
      RETURN
C
C     ERROR RETURN
C
C                             NB .LE. 0  ON A CONTINUATION CALL
  200 IERR = 7
      RETURN
C                             M .LT. 1 OR N .LT. 1
  210 IERR = 1
      RETURN
C                             MDA .LT. M
  220 IERR = 2
      RETURN
C                             MDB .LT. MAX(M,N)
  230 IERR = 3
      RETURN
C                             LIW .LT. M + N
  240 IERR = 4
      RETURN
C                             LW TOO SMALL
  250 IERR = 5
      RETURN
C                             RE OR AE IS NEGATIVE
  260 IERR = 6
      RETURN
C                             0 .LT. KRANK .LT. NP
C 280 IERR = 8
C     RETURN
      END
      SUBROUTINE DU11LS (A,MDA,M,N,UB,DB,MODE,NP,KRANK,KSURE,H,W,EB,
     *                   IC,IR)
C
C       THIS ROUTINE PERFORMS A QR FACTORIZATION OF A
C       USING HOUSEHOLDER TRANSFORMATIONS. ROW AND
C       COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
C       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
C       DEFICIENCY.
C
      DOUBLE PRECISION A(MDA,N), UB(N), DB(N), H(N), W(N), EB(N)
      INTEGER IC(N), IR(M)
      DOUBLE PRECISION BB, RMIN, R2, SUM, T, TEMP, TN, TT
      DOUBLE PRECISION DDOT, DNRM2
C
C        INITIALIZATION
C
      J = 0
      KRANK = N
      DO 10 I = 1,N
         IC(I) = I
   10 CONTINUE
      DO 20 I = 1,M
         IR(I) = I
   20 CONTINUE
C
C        DETERMINE REL AND ABS ERROR VECTORS
C
C
C        CALCULATE COL LENGTH
C
      DO 30 I = 1,N
         H(I) = DNRM2(M,A(1,I),1)
         W(I) = H(I)
   30 CONTINUE
C
C         INITIALIZE ERROR BOUNDS
C
      DO 40 I = 1,N
         EB(I) = DMAX1(DB(I),UB(I)*H(I))
         UB(I) = EB(I)
         DB(I) = 0.D0
   40 CONTINUE
C
C          DISCARD SELF DEPENDENT COLUMNS
C
      I = 1
   50 IF (EB(I) .GE. H(I)) GO TO 60
      IF (I .EQ. KRANK) GO TO 70
      I = I + 1
      GO TO 50
C
C          MATRIX REDUCTION
C
   60 KK = KRANK
      KRANK = KRANK - 1
      IF (MODE .EQ. 0) RETURN
      IF (I .LE. NP) GO TO 400
      IF (I .GT. KRANK) GO TO 70
      CALL DSWAP (1,EB(I),1,EB(KK),1)
      CALL DSWAP (1,UB(I),1,UB(KK),1)
      CALL DSWAP (1,W(I),1,W(KK),1)
      CALL DSWAP (1,H(I),1,H(KK),1)
      CALL ISWAP (1,IC(I),1,IC(KK),1)
      CALL DSWAP (M,A(1,I),1,A(1,KK),1)
      GO TO 50
C
C           TEST FOR ZERO RANK
C
   70 IF (KRANK .GT. 0) GO TO 100
      KRANK = 0
      KSURE = 0
      RETURN
C
C        M A I N    L O O P
C
  100 J = J + 1
      JP1 = J + 1
      JM1 = J - 1
      KZ = KRANK
      IF (J .LE. NP) KZ = J
C
C        EACH COL HAS MM=M-J+1 COMPONENTS
C
      MM = M - J + 1
C
C         UB DETERMINES COLUMN PIVOT
C
  110 IMIN = J
      IF (H(J) .EQ. 0.D0) GO TO 170
      RMIN = UB(J)/H(J)
      DO 120 I = J,KZ
         IF (UB(I) .GE. H(I)*RMIN) GO TO 120
         RMIN = UB(I)/H(I)
         IMIN = I
  120 CONTINUE
C
C     TEST FOR RANK DEFICIENCY
C
      IF (RMIN .LT. 1.D0) GO TO 200
      TT = (EB(IMIN) + DABS(DB(IMIN)))/H(IMIN)
      IF (TT .GE. 1.D0) GO TO 170
C
C     COMPUTE EXACT UB
C
      DO 125 I = 1,JM1
         W(I) = A(I,IMIN)
  125 CONTINUE
C
      L = JM1
  130 W(L) = W(L)/A(L,L)
      IF (L .EQ. 1) GO TO 150
      LM1 = L - 1
      DO 140 I = L,JM1
         W(LM1) = W(LM1) - A(LM1,I)*W(I)
  140 CONTINUE
      L = LM1
      GO TO 130
C
  150 TT = EB(IMIN)
      DO 160 I = 1,JM1
         TT = TT + DABS(W(I))*EB(I)
  160 CONTINUE
      UB(IMIN) = TT
      IF (UB(IMIN)/H(IMIN) .GE. 1.D0) GO TO 170
      GO TO 200
C
C        MATRIX REDUCTION
C
  170 KK = KRANK
      KRANK = KRANK - 1
      KZ = KRANK
      IF (MODE .EQ. 0) RETURN
      IF (J .LE. NP) GO TO 410
      IF (IMIN .GT. KRANK) GO TO 180
         CALL ISWAP (1,IC(IMIN),1,IC(KK),1)
         CALL DSWAP (M,A(1,IMIN),1,A(1,KK),1)
         CALL DSWAP (1,EB(IMIN),1,EB(KK),1)
         CALL DSWAP (1,UB(IMIN),1,UB(KK),1)
         CALL DSWAP (1,DB(IMIN),1,DB(KK),1)
         CALL DSWAP (1,W(IMIN),1,W(KK),1)
         CALL DSWAP (1,H(IMIN),1,H(KK),1)
  180 IF (J .GT. KRANK) GO TO 300
      GO TO 110
C
C        COLUMN PIVOT
C
  200 IF (IMIN .EQ. J) GO TO 210
      CALL DSWAP (1,H(J),1,H(IMIN),1)
      CALL DSWAP (M,A(1,J),1,A(1,IMIN),1)
      CALL DSWAP (1,EB(J),1,EB(IMIN),1)
      CALL DSWAP (1,UB(J),1,UB(IMIN),1)
      CALL DSWAP (1,DB(J),1,DB(IMIN),1)
      CALL DSWAP (1,W(J),1,W(IMIN),1)
      CALL ISWAP (1,IC(J),1,IC(IMIN),1)
C
C        ROW PIVOT
C
  210 JMAX = IDAMAX(MM,A(J,J),1)
      JMAX = JMAX + J - 1
      IF (JMAX .EQ. J) GO TO 220
      CALL DSWAP (N,A(J,1),MDA,A(JMAX,1),MDA)
      CALL ISWAP (1,IR(J),1,IR(JMAX),1)
C
C     APPLY HOUSEHOLDER TRANSFORMATION
C
  220 TN = DNRM2(MM,A(J,J),1)
      IF (TN .EQ. 0.D0) GO TO 170
      IF (A(J,J) .NE. 0.D0) TN = DSIGN(TN,A(J,J))
      CALL DSCAL (MM,1.D0/TN,A(J,J),1)
      A(J,J) = A(J,J) + 1.D0
      IF (J .EQ. N) GO TO 250
      DO 240 I = JP1,N
         BB = -DDOT(MM,A(J,J),1,A(J,I),1)/A(J,J)
         CALL DAXPY (MM,BB,A(J,J),1,A(J,I),1)
         IF (I .LE. NP) GO TO 240
         IF (H(I) .EQ. 0.D0) GO TO 240
         TT = 1.D0 - (A(J,I)/H(I))**2
         TT = DMAX1(TT,0.D0)
         T = TT
         TT = 1.D0 + 0.05D0*TT*(H(I)/W(I))**2
         IF (TT .EQ. 1.D0) GO TO 230
            H(I) = H(I)*DSQRT(T)
            GO TO 240
  230    H(I) = DNRM2(M-J,A(J+1,I),1)
         W(I) = H(I)
  240 CONTINUE
C
  250 H(J) = A(J,J)
      A(J,J) = -TN
C
C          UPDATE UB, DB
C
      UB(J) = UB(J)/DABS(A(J,J))
      DB(J) = (DSIGN(EB(J),DB(J)) + DB(J))/A(J,J)
      IF (J .EQ. KRANK) GO TO 300
      DO 260 I = JP1,KRANK
         UB(I) = UB(I) + DABS(A(J,I))*UB(J)
         DB(I) = DB(I) - A(J,I)*DB(J)
  260 CONTINUE
      GO TO 100
C
C        E N D    M A I N    L O O P
C
  300 CONTINUE
C
C        COMPUTE KSURE
C
      KM1 = KRANK - 1
      DO 315 I = 1,KM1
         IS = 0
         KMI = KRANK - I
         DO 310 II = 1,KMI
            IF (UB(II) .LE. UB(II + 1)) GO TO 310
            IS = 1
            TEMP = UB(II)
            UB(II) = UB(II + 1)
            UB(II + 1) = TEMP
  310    CONTINUE
         IF (IS .EQ. 0) GO TO 320
  315 CONTINUE
C
  320 KSURE = 0
      SUM = 0.D0
      DO 325 I = 1,KRANK
         R2 = UB(I)*UB(I)
         IF (R2 + SUM .GE. 1.D0) GO TO 330
         SUM = SUM + R2
         KSURE = KSURE + 1
  325 CONTINUE
C
C     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
C     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
C
  330 IF (KRANK .EQ. N .OR. MODE .LT. 2) RETURN
      NMK = N - KRANK
      KP1 = KRANK + 1
      I = KRANK
  340    TN = DNRM2(NMK,A(I,KP1),MDA)/A(I,I)
         TN = A(I,I)*DSQRT(1.D0 + TN*TN)
         CALL DSCAL (NMK,1.D0/TN,A(I,KP1),MDA)
         W(I) = A(I,I)/TN + 1.D0
         A(I,I) = -TN
         IF (I .EQ. 1) GO TO 350
         IM1 = I - 1
         DO 345 II = 1,IM1
            TT = -DDOT(NMK,A(II,KP1),MDA,A(I,KP1),MDA)/W(I)
            TT = TT - A(II,I)
            CALL DAXPY (NMK,TT,A(I,KP1),MDA,A(II,KP1),MDA)
            A(II,I) = A(II,I) + TT*W(I)
  345    CONTINUE
         I = I - 1
         GO TO 340
C
  350 CONTINUE
      RETURN
C
C     FIRST NP COLUMNS ARE LINEARLY DEPENDENT
C
  400 KRANK = I - 1
      RETURN
  410 KRANK = J - 1
      RETURN
      END
      SUBROUTINE DU12LS (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,H,W,IC,IR)
C
C        GIVEN THE HOUSEHOLDER QR FACTORIZATION OF A, THIS
C        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
C        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
C        ACCORDING TO THE SELECTED MODE.
C
C       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
C
      DOUBLE PRECISION A(MDA,N), B(MDB,NB), RNORM(NB), H(N), W(N)
      INTEGER IC(N), IR(M)
      DOUBLE PRECISION BB, TT
      DOUBLE PRECISION DDOT, DNRM2
C
      K = KRANK
      KP1 = K + 1
      IF (K .GT. 0) GO TO 30
C
C        RANK=0
C
      DO 10 JB = 1,NB
         RNORM(JB) = DNRM2(M,B(1,JB),1)
   10 CONTINUE
      DO 21 JB = 1,NB
         DO 20 I = 1,N
            B(I,JB) = 0.D0
   20    CONTINUE
   21 CONTINUE
      RETURN
C
   30 I = 0
C
C     REORDER B TO REFLECT ROW INTERCHANGES
C
   40    I = I + 1
         IF (I .EQ. M) GO TO 100
         J = IR(I)
         IF (J .EQ. I) GO TO 40
         IF (J .LT. 0) GO TO 40
C
         IR(I) = -IR(I)
         DO 50 JB = 1,NB
            RNORM(JB) = B(I,JB)
   50    CONTINUE
C
         IJ = I
   60       DO 70 JB = 1,NB
               B(IJ,JB) = B(J,JB)
   70       CONTINUE
            IJ = J
            J = IR(IJ)
            IR(IJ) = -IR(IJ)
         IF (J .NE. I) GO TO 60
C
         DO 80 JB = 1,NB
            B(IJ,JB) = RNORM(JB)
   80    CONTINUE
         GO TO 40
C
  100 DO 110 I = 1,M
         IR(I) = IABS(IR(I))
  110 CONTINUE
C
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
C
      DO 130 J = 1,K
         TT = A(J,J)
         A(J,J) = H(J)
         DO 120 I = 1,NB
            BB = -DDOT (M-J+1,A(J,J),1,B(J,I),1)/H(J)
            CALL DAXPY (M-J+1,BB,A(J,J),1,B(J,I),1)
  120    CONTINUE
         A(J,J) = TT
  130 CONTINUE
C
C        FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
C
      DO 140 JB = 1,NB
         RNORM(JB) = DNRM2(M-K,B(KP1,JB),1)
  140 CONTINUE
C
C     BACK SOLVE UPPER TRIANGULAR R
C
      I = K
  150 DO 160 JB = 1,NB
         B(I,JB) = B(I,JB)/A(I,I)
  160 CONTINUE
      IF (I .EQ. 1) GO TO 200
      IM1 = I - 1
      DO 170 JB = 1,NB
         CALL DAXPY (IM1,-B(I,JB),A(1,I),1,B(1,JB),1)
  170 CONTINUE
      I = IM1
      GO TO 150
C
C     RANK LT N
C
C      TRUNCATED SOLUTION
C
  200 IF (K .EQ. N) GO TO 230
      DO 211 JB = 1,NB
         DO 210 I = KP1,N
            B(I,JB) = 0.D0
  210    CONTINUE
  211 CONTINUE
      IF (MODE .EQ. 1) GO TO 230
C
C      MINIMAL LENGTH SOLUTION
C
      NMK = N - K
      DO 221 JB = 1,NB
         DO 220 I = 1,K
            TT = -DDOT(NMK,A(I,KP1),MDA,B(KP1,JB),1)/W(I)
            TT = TT - B(I,JB)
            CALL DAXPY (NMK,TT,A(I,KP1),MDA,B(KP1,JB),1)
            B(I,JB) = B(I,JB) + TT*W(I)
  220    CONTINUE
  221 CONTINUE
C
C     REORDER B TO REFLECT COLUMN INTERCHANGES
C
  230 I = 0
C
  240    I = I + 1
         IF (I .EQ. N) GO TO 260
         J = IC(I)
         IF (J .EQ. I) GO TO 240
         IF (J .LT. 0) GO TO 240
C
         IC(I) = -IC(I)
  250       CALL DSWAP (NB,B(J,1),MDB,B(I,1),MDB)
            IJ = IC(J)
            IC(J) = -IC(J)
            J = IJ
         IF (J .NE. I) GO TO 250
         GO TO 240
C
  260 DO 270 I = 1,N
         IC(I) = IABS(IC(I))
  270 CONTINUE
      RETURN
      END
      SUBROUTINE DU11US (A,MDA,M,N,UB,DB,MODE,NP,KRANK,KSURE,H,W,EB,
     *                   IR,IC)
C
C       THIS ROUTINE PERFORMS AN LQ FACTORIZATION OF THE
C       MATRIX A USING HOUSEHOLDER TRANSFORMATIONS. ROW
C       AND COLUMN PIVOTS ARE CHOSEN TO REDUCE THE GROWTH
C       OF ROUND-OFF AND TO HELP DETECT POSSIBLE RANK
C       DEFICIENCY.
C
      DOUBLE PRECISION A(MDA,N), UB(M), DB(M), H(M), W(M), EB(M)
      INTEGER IC(N), IR(M)
      DOUBLE PRECISION BB, RMIN, R2, SUM, T, TEMP, TN, TT
      DOUBLE PRECISION DDOT, DNRM2
C
C        INITIALIZATION
C
      J = 0
      KRANK = M
      DO 10 I = 1,N
         IC(I) = I
   10 CONTINUE
      DO 20 I = 1,M
         IR(I) = I
   20 CONTINUE
C
C        DETERMINE REL AND ABS ERROR VECTORS
C
C
C        CALCULATE ROW LENGTH
C
      DO 30 I = 1,M
         H(I) = DNRM2(N,A(I,1),MDA)
         W(I) = H(I)
   30 CONTINUE
C
C         INITIALIZE ERROR BOUNDS
C
      DO 40 I = 1,M
         EB(I) = DMAX1(DB(I),UB(I)*H(I))
         UB(I) = EB(I)
         DB(I) = 0.D0
   40 CONTINUE
C
C          DISCARD SELF DEPENDENT ROWS
C
      I = 1
   50 IF (EB(I) .GE. H(I)) GO TO 60
      IF (I .EQ. KRANK) GO TO 70
      I = I + 1
      GO TO 50
C
C          MATRIX REDUCTION
C
   60 KK = KRANK
      KRANK = KRANK - 1
      IF (MODE .EQ. 0) RETURN
      IF (I .LE. NP) GO TO 400
      IF (I .GT. KRANK) GO TO 70
      CALL DSWAP (1,EB(I),1,EB(KK),1)
      CALL DSWAP (1,UB(I),1,UB(KK),1)
      CALL DSWAP (1,W(I),1,W(KK),1)
      CALL DSWAP (1,H(I),1,H(KK),1)
      CALL ISWAP (1,IR(I),1,IR(KK),1)
      CALL DSWAP (N,A(I,1),MDA,A(KK,1),MDA)
      GO TO 50
C
C           TEST FOR ZERO RANK
C
   70 IF (KRANK .GT. 0) GO TO 100
      KRANK = 0
      KSURE = 0
      RETURN
C
C        M A I N    L O O P
C
  100 J = J + 1
      JP1 = J + 1
      JM1 = J - 1
      KZ = KRANK
      IF (J .LE. NP) KZ = J
C
C        EACH ROW HAS NN=N-J+1 COMPONENTS
C
      NN = N - J + 1
C
C         UB DETERMINES ROW PIVOT
C
  110 IMIN = J
      IF (H(J) .EQ. 0.D0) GO TO 170
      RMIN = UB(J)/H(J)
      DO 120 I = J,KZ
         IF (UB(I) .GE. H(I)*RMIN) GO TO 120
         RMIN = UB(I)/H(I)
         IMIN = I
  120 CONTINUE
C
C     TEST FOR RANK DEFICIENCY
C
      IF (RMIN .LT. 1.D0) GO TO 200
      TT = (EB(IMIN) + DABS(DB(IMIN)))/H(IMIN)
      IF (TT .GE. 1.D0) GO TO 170
C
C     COMPUTE EXACT UB
C
      DO 125 I = 1,JM1
         W(I) = A(IMIN,I)
  125 CONTINUE
C
      L = JM1
  130 W(L) = W(L)/A(L,L)
      IF (L .EQ. 1) GO TO 150
      LM1 = L - 1
      DO 140 I = L,JM1
         W(LM1) = W(LM1) - A(I,LM1)*W(I)
  140 CONTINUE
      L = LM1
      GO TO 130
C
  150 TT = EB(IMIN)
      DO 160 I = 1,JM1
         TT = TT + DABS(W(I))*EB(I)
  160 CONTINUE
      UB(IMIN) = TT
      IF (UB(IMIN)/H(IMIN) .GE. 1.D0) GO TO 170
      GO TO 200
C
C        MATRIX REDUCTION
C
  170 KK = KRANK
      KRANK = KRANK - 1
      KZ = KRANK
      IF (MODE .EQ. 0) RETURN
      IF (J .LE. NP) GO TO 410
      IF (IMIN .GT. KRANK) GO TO 180
         CALL ISWAP (1,IR(IMIN),1,IR(KK),1)
         CALL DSWAP (N,A(IMIN,1),MDA,A(KK,1),MDA)
         CALL DSWAP (1,EB(IMIN),1,EB(KK),1)
         CALL DSWAP (1,UB(IMIN),1,UB(KK),1)
         CALL DSWAP (1,DB(IMIN),1,DB(KK),1)
         CALL DSWAP (1,W(IMIN),1,W(KK),1)
         CALL DSWAP (1,H(IMIN),1,H(KK),1)
  180 IF (J .GT. KRANK) GO TO 300
      GO TO 110
C
C        ROW PIVOT
C
  200 IF (IMIN .EQ. J) GO TO 210
      CALL DSWAP (1,H(J),1,H(IMIN),1)
      CALL DSWAP (N,A(J,1),MDA,A(IMIN,1),MDA)
      CALL DSWAP (1,EB(J),1,EB(IMIN),1)
      CALL DSWAP (1,UB(J),1,UB(IMIN),1)
      CALL DSWAP (1,DB(J),1,DB(IMIN),1)
      CALL DSWAP (1,W(J),1,W(IMIN),1)
      CALL ISWAP (1,IR(J),1,IR(IMIN),1)
C
C        COLUMN PIVOT
C
  210 JMAX = IDAMAX(NN,A(J,J),MDA)
      JMAX = JMAX + J - 1
      IF (JMAX .EQ. J) GO TO 220
      CALL DSWAP (M,A(1,J),1,A(1,JMAX),1)
      CALL ISWAP (1,IC(J),1,IC(JMAX),1)
C
C     APPLY HOUSEHOLDER TRANSFORMATION
C
  220 TN = DNRM2(NN,A(J,J),MDA)
      IF (TN .EQ. 0.D0) GO TO 170
      IF (A(J,J) .NE. 0.D0) TN = DSIGN(TN,A(J,J))
      CALL DSCAL (NN,1.D0/TN,A(J,J),MDA)
      A(J,J) = A(J,J) + 1.D0
      IF (J .EQ. M) GO TO 250
      DO 240 I = JP1,M
         BB = -DDOT(NN,A(J,J),MDA,A(I,J),MDA)/A(J,J)
         CALL DAXPY (NN,BB,A(J,J),MDA,A(I,J),MDA)
         IF (I .LE. NP) GO TO 240
         IF (H(I) .EQ. 0.D0) GO TO 240
         TT = 1.0 - (A(I,J)/H(I))**2
         TT = DMAX1(TT,0.D0)
         T = TT
         TT = 1.D0 + 0.05D0*TT*(H(I)/W(I))**2
         IF (TT .EQ. 1.D0) GO TO 230
            H(I) = H(I)*DSQRT(T)
            GO TO 240
  230    H(I) = DNRM2(N-J,A(I,J+1),MDA)
         W(I) = H(I)
  240 CONTINUE
C
  250 H(J) = A(J,J)
      A(J,J) = -TN
C
C          UPDATE UB, DB
C
      UB(J) = UB(J)/DABS(A(J,J))
      DB(J) = (DSIGN(EB(J),DB(J)) + DB(J))/A(J,J)
      IF (J .EQ. KRANK) GO TO 300
      DO 260 I = JP1,KRANK
         UB(I) = UB(I) + DABS(A(I,J))*UB(J)
         DB(I) = DB(I) - A(I,J)*DB(J)
  260 CONTINUE
      GO TO 100
C
C        E N D    M A I N    L O O P
C
  300 CONTINUE
C
C        COMPUTE KSURE
C
      KM1 = KRANK - 1
      DO 315 I = 1,KM1
         IS = 0
         KMI = KRANK - I
         DO 310 II = 1,KMI
            IF (UB(II) .LE. UB(II + 1)) GO TO 310
            IS = 1
            TEMP = UB(II)
            UB(II) = UB(II + 1)
            UB(II + 1) = TEMP
  310    CONTINUE
         IF (IS .EQ. 0) GO TO 320
  315 CONTINUE
C
  320 KSURE = 0
      SUM = 0.D0
      DO 325 I = 1,KRANK
         R2 = UB(I)*UB(I)
         IF (R2 + SUM .GE. 1.D0) GO TO 330
         SUM = SUM + R2
         KSURE = KSURE + 1
  325 CONTINUE
C
C     IF SYSTEM IS OF REDUCED RANK AND MODE = 2
C     COMPLETE THE DECOMPOSITION FOR SHORTEST LEAST SQUARES SOLUTION
C
  330 IF (KRANK .EQ. M .OR. MODE .LT. 2) RETURN
      MMK = M - KRANK
      KP1 = KRANK + 1
      I = KRANK
  340    TN = DNRM2(MMK,A(KP1,I),1)/A(I,I)
         TN = A(I,I)*DSQRT(1.D0 + TN*TN)
         CALL DSCAL (MMK,1.D0/TN,A(KP1,I),1)
         W(I) = A(I,I)/TN + 1.D0
         A(I,I) = -TN
         IF (I .EQ. 1) GO TO 350
         IM1 = I - 1
         DO 345 II = 1,IM1
            TT = -DDOT(MMK,A(KP1,II),1,A(KP1,I),1)/W(I)
            TT = TT - A(I,II)
            CALL DAXPY (MMK,TT,A(KP1,I),1,A(KP1,II),1)
            A(I,II) = A(I,II) + TT*W(I)
  345    CONTINUE
         I = I - 1
         GO TO 340
C
  350 CONTINUE
      RETURN
C
C     FIRST NP ROWS ARE LINEARLY DEPENDENT
C
  400 KRANK = I - 1
      RETURN
  410 KRANK = J - 1
      RETURN
      END
      SUBROUTINE DU12US (A,MDA,M,N,B,MDB,NB,MODE,KRANK,RNORM,H,W,IR,IC)
C
C        GIVEN THE HOUSEHOLDER LQ FACTORIZATION OF A, THIS
C        SUBROUTINE SOLVES THE SYSTEM AX=B. IF THE SYSTEM
C        IS OF REDUCED RANK, THIS ROUTINE RETURNS A SOLUTION
C        ACCORDING TO THE SELECTED MODE.
C
C       NOTE - IF MODE.NE.2, W IS NEVER ACCESSED.
C
      DOUBLE PRECISION A(MDA,N), B(MDB,NB), RNORM(NB), H(M), W(M)
      INTEGER IC(N), IR(M)
      DOUBLE PRECISION BB, TT
      DOUBLE PRECISION DDOT, DNRM2
C
      K = KRANK
      KP1 = K + 1
      IF (K .GT. 0) GO TO 30
C
C        RANK=0
C
      DO 10 JB = 1,NB
         RNORM(JB) = DNRM2(M,B(1,JB),1)
   10 CONTINUE
      DO 21 JB = 1,NB
         DO 20 I = 1,N
            B(I,JB) = 0.D0
   20    CONTINUE
   21 CONTINUE
      RETURN
C
   30 I = 0
C
C     REORDER B TO REFLECT ROW INTERCHANGES
C
   40    I = I + 1
         IF (I .EQ. M) GO TO 100
         J = IR(I)
         IF (J .EQ. I) GO TO 40
         IF (J .LT. 0) GO TO 40
C
         IR(I) = -IR(I)
         DO 50 JB = 1,NB
            RNORM(JB) = B(I,JB)
   50    CONTINUE
C
         IJ = I
   60       DO 70 JB = 1,NB
               B(IJ,JB) = B(J,JB)
   70       CONTINUE
            IJ = J
            J = IR(IJ)
            IR(IJ) = -IR(IJ)
         IF (J .NE. I) GO TO 60
C
         DO 80 JB = 1,NB
            B(IJ,JB) = RNORM(JB)
   80    CONTINUE
         GO TO 40
C
  100 DO 110 I = 1,M
         IR(I) = IABS(IR(I))
  110 CONTINUE
C
C     IF A IS OF REDUCED RANK AND MODE=2,
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
C
      IF (MODE .LT. 2 .OR. K .EQ. M) GO TO 140
      MMK = M - K
      DO 130 JB = 1,NB
         DO 120 J = 1,K
            I = KP1 - J
            TT = -DDOT(MMK,A(KP1,I),1,B(KP1,JB),1)/W(I)
            TT = TT - B(I,JB)
            CALL DAXPY (MMK,TT,A(KP1,I),1,B(KP1,JB),1)
            B(I,JB) = B(I,JB) + TT*W(I)
  120    CONTINUE
  130 CONTINUE
C
C     FIND NORMS OF RESIDUAL VECTOR(S)..(BEFORE OVERWRITE B)
C
  140 DO 150 JB = 1,NB
         RNORM(JB) = DNRM2(M-K,B(KP1,JB),1)
  150 CONTINUE
C
C     BACK SOLVE LOWER TRIANGULAR L
C
      DO 170 JB = 1,NB
         DO 160 I = 1,K
            B(I,JB) = B(I,JB)/A(I,I)
            IF (I .EQ. K) GO TO 170
            IP1 = I + 1
            CALL DAXPY(K-I,-B(I,JB),A(IP1,I),1,B(IP1,JB),1)
  160    CONTINUE
  170 CONTINUE
C
C      TRUNCATED SOLUTION
C
      IF (K .EQ. N) GO TO 210
      DO 201 JB = 1,NB
         DO 200 I = KP1,N
            B(I,JB) = 0.D0
  200    CONTINUE
  201 CONTINUE
C
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO B
C
  210 DO 230 I = 1,K
         J = KP1 - I
         TT = A(J,J)
         A(J,J) = H(J)
         DO 220 JB = 1,NB
            BB = -DDOT(N-J+1,A(J,J),MDA,B(J,JB),1)/H(J)
            CALL DAXPY(N-J+1,BB,A(J,J),MDA,B(J,JB),1)
  220    CONTINUE
         A(J,J) = TT
  230 CONTINUE
C
C     REORDER B TO REFLECT COLUMN INTERCHANGES
C
      I = 0
C
  240    I = I + 1
         IF (I .EQ. N) GO TO 260
         J = IC(I)
         IF (J .EQ. I) GO TO 240
         IF (J .LT. 0) GO TO 240
C
         IC(I) = -IC(I)
  250       CALL DSWAP (NB,B(J,1),MDB,B(I,1),MDB)
            IJ = IC(J)
            IC(J) = -IC(J)
            J = IJ
         IF (J .NE. I) GO TO 250
         GO TO 240
C
  260 DO 270 I = 1,N
         IC(I) = IABS(IC(I))
  270 CONTINUE
      RETURN
      END
      SUBROUTINE HFTI (A,MDA,M,N,B,MDB,NB,TAU,K,RNORM,H,G,IP)
C-----------------------------------------------------------------------
C     DIMENSION A(MDA,N),(B(MDB,NB) OR B(M)),RNORM(NB),H(N),G(N),IP(N)
C
C     WRITTEN BY C.L. LAWSON AND R.J. HANSON.
C     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
C     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
C
C     ABSTRACT
C
C     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
C     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
C     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
C     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
C     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
C     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
C     PROBLEMS.
C
C     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
C     SQUARES PROBLEM
C
C                       AX = B,
C
C     WHERE X IS THE N BY NB SOLUTION MATRIX.
C
C     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
C     PSEUDO-INVERSE OF A.
C
C     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
C     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
C     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
C     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
C
C                       ABS(R(I,I)).GE.ABS(R(I+1,I+1)),
C
C                       I = 1,...,L-1, WHERE
C
C                       L = MIN(M,N).
C
C     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS
C     OF R THAT EXCEED TAU IN MAGNITUDE. THEN THE SOLUTION OF MINIMUM
C     EUCLIDEAN LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
C
C     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
C     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
C     MAGNITUDES.
C
C     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
C     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
C     EPS*(NORM OF A).
C
C     THE ENTIRE SET OF PARAMETERS FOR HFTI ARE
C
C     INPUT..
C
C     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
C                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
C                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
C                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
C                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
C                       IS NO RESTRICTION ON THE RANK OF A.  THE
C                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
C
C     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
C                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
C                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
C                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
C                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
C                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
C                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
C                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
C                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
C                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
C                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
C                       VALUE SUCH AS MDB = M.
C
C                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
C                       IS CONSIDERED AN ERROR.
C
C     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
C                       FOR PSEUDORANK DETERMINATION.
C
C     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY HFTI.
C
C     OUTPUT..
C
C     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
C                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C
C     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
C                       NB SOLUTION MATRIX X.
C
C     K                 SET BY THE SUBROUTINE TO INDICATE THE
C                       PSEUDORANK OF A.
C
C     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
C                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
C                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
C                       B(*,*) FOR J = 1,...,NB.
C
C     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
C                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
C                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
C                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
C
C     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
C                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
C                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C-----------------------------------------------------------------------
      DIMENSION A(MDA,N),B(MDB,*),RNORM(*),H(N),G(N)
      INTEGER IP(N)
      DOUBLE PRECISION SM
C---------------------
      DATA FACTOR /1.E-3/
C
      K = 0
      LDIAG = MIN0(M,N)
      IF (LDIAG .LE. 0) GO TO 270
          DO 80 J = 1,LDIAG
          IF (J .EQ. 1) GO TO 20
C
C     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
          LMAX = J
              DO 10 L = J,N
              H(L) = H(L) - A(J-1,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   10         CONTINUE
          Z = HMAX + FACTOR*H(LMAX)
          IF (Z .GT. HMAX) GO TO 50
C
C     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
   20     LMAX=J
              DO 40 L = J,N
              H(L) = 0.0
                  DO 30 I = J,M
   30             H(L) = H(L) + A(I,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   40         CONTINUE
          HMAX = H(LMAX)
C    ..
C     LMAX HAS BEEN DETERMINED
C
C     DO COLUMN INTERCHANGES IF NEEDED.
C    ..
   50     IP(J) = LMAX
          IF (IP(J) .EQ. J) GO TO 70
              DO 60 I = 1,M
              TMP = A(I,J)
              A(I,J) = A(I,LMAX)
   60         A(I,LMAX) = TMP
          H(LMAX) = H(J)
C
C     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
C    ..
   70     CALL H12 (1,J,J+1,M,A(1,J),1,H(J),A(1,J+1),1,MDA,N-J)
   80     CALL H12 (2,J,J+1,M,A(1,J),1,H(J),B,1,MDB,NB)
C
C     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
C    ..
          DO 90 J = 1,LDIAG
          IF (ABS(A(J,J)) .LE. TAU) GO TO 100
   90     CONTINUE
      K = LDIAG
      GO TO 110
  100 K = J - 1
  110 KP1 = K + 1
C
C     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
C
      IF (NB .LE. 0) GO TO 140
          DO 130 JB = 1,NB
          TMP = 0.0
          IF (KP1 .GT. M) GO TO 130
              DO 120 I = KP1,M
  120         TMP = TMP + B(I,JB)**2
  130     RNORM(JB) = SQRT(TMP)
  140 CONTINUE
C                                           SPECIAL FOR PSEUDORANK = 0
      IF (K .GT. 0) GO TO 160
      IF (NB .LE. 0) GO TO 270
          DO 151 JB = 1,NB
              DO 150 I = 1,N
  150         B(I,JB) = 0.0
  151     CONTINUE
      GO TO 270
C
C     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
C     DECOMPOSITION OF FIRST K ROWS.
C    ..
  160 IF (K .EQ. N) GO TO 180
          DO 170 II = 1,K
          I = KP1 - II
  170     CALL H12 (1,I,KP1,N,A(I,1),MDA,G(I),A,MDA,1,I-1)
  180 CONTINUE
C
C
      IF (NB .LE. 0) GO TO 270
          DO 260 JB = 1,NB
C
C     SOLVE THE K BY K TRIANGULAR SYSTEM.
C    ..
              DO 210 L = 1,K
              SM = 0.D0
              I = KP1 - L
              IF (I .EQ. K) GO TO 200
              IP1 = I + 1
                  DO 190 J = IP1,K
  190             SM = SM + DBLE(A(I,J))*DBLE(B(J,JB))
  200         SM1 = DBLE(B(I,JB)) - SM
  210         B(I,JB) = SM1/A(I,I)
C
C     COMPLETE COMPUTATION OF SOLUTION VECTOR.
C    ..
          IF (K .EQ. N) GO TO 240
              DO 220 J = KP1,N
  220         B(J,JB) = 0.0
              DO 230 I = 1,K
  230         CALL H12 (2,I,KP1,N,A(I,1),MDA,G(I),B(1,JB),1,MDB,1)
C
C      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
C      COLUMN INTERCHANGES.
C    ..
  240         DO 250 JJ = 1,LDIAG
              J = LDIAG + 1 - JJ
              IF (IP(J) .EQ. J) GO TO 250
              L = IP(J)
              TMP = B(L,JB)
              B(L,JB) = B(J,JB)
              B(J,JB) = TMP
  250         CONTINUE
  260     CONTINUE
C    ..
C     THE SOLUTION VECTORS, X, ARE NOW
C     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
C
  270 RETURN
      END
      SUBROUTINE HFTI2(A,MDA,M,N,B,MDB,NB,D,TAU,K,RNORM,H,G,IP,IERR)
C-----------------------------------------------------------------------
C     DIMENSION A(MDA,N),(B(MDB,NB) OR B(M))
C     DIMENSION D(L) WHERE L = MIN(M,N)
C     DIMENSION RNORM(NB),H(N),G(N),IP(N)
C
C     WRITTEN BY C.L. LAWSON AND R.J. HANSON. MODIFIED BY A.H. MORRIS.
C     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
C     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
C
C     ABSTRACT
C
C     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
C     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
C     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
C     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
C     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
C     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
C     PROBLEMS.
C
C     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
C     SQUARES PROBLEM
C
C                       AX = B,
C
C     WHERE X IS THE N BY NB SOLUTION MATRIX.
C
C     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
C     PSEUDO-INVERSE OF A.
C
C     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
C     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
C     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
C     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
C
C                       ABS(R(I,I)).GE.ABS(R(I+1,I+1)),
C
C                       I = 1,...,L-1, WHERE
C
C                       L = MIN(M,N).
C
C     THE ARRAY D WILL CONTAIN THE DIAGONAL ELEMENTS R(1,1),...,R(L,L).
C     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS THAT
C     EXCEED TAU IN MAGNITUDE.  THEN THE SOLUTION OF MINIMUM EUCLIDEAN
C     LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
C
C     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
C     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
C     MAGNITUDES.
C
C     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
C     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
C     EPS*(NORM OF A).
C
C     THE ENTIRE SET OF PARAMETERS FOR HFTI2 ARE
C
C     INPUT..
C
C     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
C                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
C                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
C                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
C                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
C                       IS NO RESTRICTION ON THE RANK OF A.  THE
C                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
C
C     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
C                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
C                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
C                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
C                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
C                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
C                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
C                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
C                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
C                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
C                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
C                       VALUE SUCH AS MDB = M.
C
C                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
C                       IS CONSIDERED AN ERROR.
C
C     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
C                       FOR PSEUDORANK DETERMINATION.
C
C     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY HFTI2.
C
C     OUTPUT..
C
C     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
C                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C
C     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
C                       NB SOLUTION MATRIX X.
C
C     D(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
C                       TRIANGULAR MATRIX R
C
C     K                 SET BY THE SUBROUTINE TO INDICATE THE
C                       PSEUDORANK OF A.
C
C     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
C                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
C                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
C                       B(*,*) FOR J = 1,...,NB.
C
C     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
C                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
C                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
C                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
C
C     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
C                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
C                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C
C     IERR              ERROR INDICATOR. IF NO INPUT ERRORS ARE
C                       DETECTED THEN IERR IS SET TO 0. OTHERWISE
C                          IERR = 1  IF MDA.LT.M
C                          IERR = 2  IF NB.GT.1 AND MDB.LT.MAX(M,N)
C                       THESE ERRORS ARE FATAL.
C-----------------------------------------------------------------------
      DIMENSION A(MDA,N),B(MDB,*),D(*),RNORM(*),H(N),G(N)
      INTEGER IP(N)
      DOUBLE PRECISION SM
C---------------------
      DATA FACTOR /1.E-3/
C
      K = 0
      LDIAG = MIN0(M,N)
      IF (LDIAG .LE. 0) GO TO 270
      IF (M .GT. MDA) GO TO 300
      IF (NB .GT. 1 .AND. MAX0(M,N) .GT. MDB) GO TO 310
C
          DO 80 J = 1,LDIAG
          IF (J .EQ. 1) GO TO 20
C
C     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
          LMAX = J
              DO 10 L = J,N
              H(L) = H(L) - A(J-1,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   10         CONTINUE
          Z = HMAX + FACTOR*H(LMAX)
          IF (Z .GT. HMAX) GO TO 50
C
C     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
   20     LMAX = J
              DO 40 L = J,N
              H(L) = 0.0
                  DO 30 I = J,M
   30             H(L) = H(L) + A(I,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   40         CONTINUE
          HMAX = H(LMAX)
C    ..
C     LMAX HAS BEEN DETERMINED
C
C     DO COLUMN INTERCHANGES IF NEEDED.
C    ..
   50     IP(J) = LMAX
          IF (IP(J) .EQ. J) GO TO 70
              DO 60 I = 1,M
              TMP = A(I,J)
              A(I,J) = A(I,LMAX)
   60         A(I,LMAX) = TMP
          H(LMAX) = H(J)
C
C     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
C    ..
   70     CALL H12 (1,J,J+1,M,A(1,J),1,H(J),A(1,J+1),1,MDA,N-J)
   80     CALL H12 (2,J,J+1,M,A(1,J),1,H(J),B,1,MDB,NB)
C
C     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
C     ALSO STORE THE DIAGONAL ELEMENTS IN THE ARRAY D.
C    ..
          DO 90 J = 1,LDIAG
          IF (ABS(A(J,J)) .LE. TAU) GO TO 100
   90     D(J) = A(J,J)
          K = LDIAG
          KP1 = K + 1
          GO TO 110
C
  100     K = J - 1
          KP1 = J
          DO 105 J = KP1,LDIAG
  105     D(J) = A(J,J)
C
C     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
C
  110 IF (NB .LE. 0) GO TO 140
          DO 130 JB = 1,NB
          TMP = 0.0
          IF (KP1 .GT. M) GO TO 130
              DO 120 I = KP1,M
  120         TMP = TMP + B(I,JB)**2
  130     RNORM(JB) = SQRT(TMP)
  140 CONTINUE
C                                           SPECIAL FOR PSEUDORANK = 0
      IF (K .GT. 0) GO TO 160
      IF (NB .LE. 0) GO TO 270
          DO 151 JB = 1,NB
              DO 150 I = 1,N
  150         B(I,JB) = 0.0
  151     CONTINUE
      GO TO 270
C
C     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
C     DECOMPOSITION OF FIRST K ROWS.
C    ..
  160 IF (K .EQ. N) GO TO 180
          DO 170 II = 1,K
          I = KP1 - II
  170     CALL H12 (1,I,KP1,N,A(I,1),MDA,G(I),A,MDA,1,I-1)
  180 CONTINUE
C
C
      IF (NB .LE. 0) GO TO 270
          DO 260 JB = 1,NB
C
C     SOLVE THE K BY K TRIANGULAR SYSTEM.
C    ..
              DO 210 L = 1,K
              SM = 0.D0
              I = KP1 - L
              IF (I .EQ. K) GO TO 200
              IP1 = I + 1
                  DO 190 J = IP1,K
  190             SM = SM + DBLE(A(I,J))*DBLE(B(J,JB))
  200         SM1 = DBLE(B(I,JB)) - SM
  210         B(I,JB)=SM1/A(I,I)
C
C     COMPLETE COMPUTATION OF SOLUTION VECTOR.
C    ..
          IF (K .EQ. N) GO TO 240
              DO 220 J = KP1,N
  220         B(J,JB) = 0.0
              DO 230 I = 1,K
  230         CALL H12 (2,I,KP1,N,A(I,1),MDA,G(I),B(1,JB),1,MDB,1)
C
C      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
C      COLUMN INTERCHANGES.
C    ..
  240         DO 250 JJ = 1,LDIAG
              J = LDIAG + 1 - JJ
              IF (IP(J) .EQ. J) GO TO 250
              L = IP(J)
              TMP = B(L,JB)
              B(L,JB) = B(J,JB)
              B(J,JB) = TMP
  250         CONTINUE
  260     CONTINUE
C    ..
C     THE SOLUTION VECTORS, X, ARE NOW
C     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
C
  270 IERR = 0
      RETURN
C
C     ERROR RETURN
C
  300 IERR = 1
      RETURN
  310 IERR = 2
      RETURN
      END
      SUBROUTINE H12 (MODE,LPIVOT,L1,M,U,IUE,UP,C,ICE,ICV,NCV)
C-----------------------------------------------------------------------
C     WRITTEN BY C.L. LAWSON AND R.J. HANSON.  MODIFIED BY A.H. MORRIS.
C     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
C
C     CONSTRUCTION AND/OR APPLICATION OF A SINGLE
C     HOUSEHOLDER TRANSFORMATION..     Q = I + U*(U**T)/B
C
C     MODE    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
C     LPIVOT IS THE INDEX OF THE PIVOT ELEMENT.
C     L1,M   IF L1 .LE. M   THE TRANSFORMATION WILL BE CONSTRUCTED TO
C            ZERO ELEMENTS INDEXED FROM L1 THROUGH M.   IF L1 GT. M
C            THE SUBROUTINE DOES AN IDENTITY TRANSFORMATION.
C     U(),IUE,UP    ON ENTRY TO H1 U() CONTAINS THE PIVOT VECTOR.
C                   IUE IS THE STORAGE INCREMENT BETWEEN ELEMENTS.
C                                       ON EXIT FROM H1 U() AND UP
C                   CONTAIN QUANTITIES DEFINING THE VECTOR U OF THE
C                   HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 U()
C                   AND UP SHOULD CONTAIN QUANTITIES PREVIOUSLY COMPUTED
C                   BY H1.  THESE WILL NOT BE MODIFIED BY H2.
C     C()    ON ENTRY TO H1 OR H2 C() CONTAINS A MATRIX WHICH WILL BE
C            REGARDED AS A SET OF VECTORS TO WHICH THE HOUSEHOLDER
C            TRANSFORMATION IS TO BE APPLIED.  ON EXIT C() CONTAINS THE
C            SET OF TRANSFORMED VECTORS.
C     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN C().
C     ICV    STORAGE INCREMENT BETWEEN VECTORS IN C().
C     NCV    NUMBER OF VECTORS IN C() TO BE TRANSFORMED. IF NCV .LE. 0
C            NO OPERATIONS WILL BE DONE ON C().
C-----------------------------------------------------------------------
      DIMENSION U(IUE,M), C(*)
      DOUBLE PRECISION SM,B
C
      IF (0 .GE. LPIVOT .OR. LPIVOT .GE. L1 .OR. L1 .GT. M) RETURN
      CL = ABS(U(1,LPIVOT))
      IF (MODE .EQ. 2) GO TO 60
C
C                            ****** CONSTRUCT THE TRANSFORMATION. ******
C
          DO 10 J = L1,M
   10     CL = AMAX1(ABS(U(1,J)),CL)
      IF (CL .LE. 0.0) GO TO 130
      D = U(1,LPIVOT)/CL
      SM = D*D
          DO 20 J = L1,M
          D = U(1,J)/CL
   20     SM = SM + DBLE(D*D)
C
      SM1 = SM
      CL = CL*SQRT(SM1)
      IF (U(1,LPIVOT) .GT. 0.0) CL = -CL
      UP = U(1,LPIVOT) - CL
      U(1,LPIVOT) = CL
      GO TO 70
C
C            ****** APPLY THE TRANSFORMATION  I+U*(U**T)/B  TO C. ******
C
   60 IF (CL) 130,130,70
   70 IF (NCV .LE. 0) RETURN
      B = DBLE(UP)*DBLE(U(1,LPIVOT))
C
C                       B  MUST BE NONPOSITIVE HERE.  IF B = 0., RETURN.
C
      IF (B .GE. 0.D0) GO TO 130
      B = 1.D0/B
      I2 = 1 - ICV + ICE*(LPIVOT - 1)
      INCR = ICE*(L1 - LPIVOT)
          DO 120 J = 1,NCV
          I2 = I2 + ICV
          I3 = I2 + INCR
          I4 = I3
          SM = DBLE(C(I2))*DBLE(UP)
              DO 90 I = L1,M
              SM = SM + DBLE(C(I3))*DBLE(U(1,I))
   90         I3 = I3 + ICE
          IF (SM .EQ. 0.D0) GO TO 120
          SM = SM*B
          C(I2) = C(I2) + SM*DBLE(UP)
              DO 110 I = L1,M
              C(I4) = C(I4) + SM*DBLE(U(1,I))
  110         I4 = I4 + ICE
  120     CONTINUE
  130 RETURN
      END
      SUBROUTINE DHFTI (A,MDA,M,N,B,MDB,NB,TAU,K,RNORM,H,G,IP)
C-----------------------------------------------------------------------
C     DOUBLE PRECISION A(MDA,N),(B(MDB,NB) OR B(M))
C     DOUBLE PRECISION TAU,RNORM(NB),H(N),G(N)
C     INTEGER IP(N)
C
C     WRITTEN BY C.L. LAWSON AND R.J. HANSON.
C     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
C     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
C
C     ABSTRACT
C
C     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
C     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
C     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
C     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
C     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
C     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
C     PROBLEMS.
C
C     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
C     SQUARES PROBLEM
C
C                       AX = B,
C
C     WHERE X IS THE N BY NB SOLUTION MATRIX.
C
C     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
C     PSEUDO-INVERSE OF A.
C
C     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
C     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
C     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
C     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
C
C                       DABS(R(I,I)).GE.DABS(R(I+1,I+1)),
C
C                       I = 1,...,L-1, WHERE
C
C                       L = MIN(M,N).
C
C     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS
C     OF R THAT EXCEED TAU IN MAGNITUDE. THEN THE SOLUTION OF MINIMUM
C     EUCLIDEAN LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
C
C     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
C     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
C     MAGNITUDES.
C
C     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
C     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
C     EPS*(NORM OF A).
C
C     THE ENTIRE SET OF PARAMETERS FOR DHFTI ARE
C
C     INPUT..
C
C     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
C                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
C                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
C                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
C                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
C                       IS NO RESTRICTION ON THE RANK OF A.  THE
C                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
C
C     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
C                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
C                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
C                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
C                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
C                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
C                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
C                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
C                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
C                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
C                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
C                       VALUE SUCH AS MDB = M.
C
C                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
C                       IS CONSIDERED AN ERROR.
C
C     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
C                       FOR PSEUDORANK DETERMINATION.
C
C     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY DHFTI.
C
C     OUTPUT..
C
C     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
C                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C
C     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
C                       NB SOLUTION MATRIX X.
C
C     K                 SET BY THE SUBROUTINE TO INDICATE THE
C                       PSEUDORANK OF A.
C
C     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
C                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
C                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
C                       B(*,*) FOR J = 1,...,NB.
C
C     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
C                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
C                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
C                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
C
C     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
C                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
C                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(MDA,N),B(MDB,*),TAU,RNORM(*),H(N),G(N)
      INTEGER IP(N)
      DOUBLE PRECISION FACTOR,HMAX,SM,SM1,TMP,Z
C---------------------
      DATA FACTOR /1.D-3/
C
      K = 0
      LDIAG = MIN0(M,N)
      IF (LDIAG .LE. 0) GO TO 270
          DO 80 J = 1,LDIAG
          IF (J .EQ. 1) GO TO 20
C
C     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
          LMAX = J
              DO 10 L = J,N
              H(L) = H(L) - A(J-1,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   10         CONTINUE
          Z = HMAX + FACTOR*H(LMAX)
          IF (Z .GT. HMAX) GO TO 50
C
C     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
   20     LMAX=J
              DO 40 L = J,N
              H(L) = 0.D0
                  DO 30 I = J,M
   30             H(L) = H(L) + A(I,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   40         CONTINUE
          HMAX = H(LMAX)
C    ..
C     LMAX HAS BEEN DETERMINED
C
C     DO COLUMN INTERCHANGES IF NEEDED.
C    ..
   50     IP(J) = LMAX
          IF (IP(J) .EQ. J) GO TO 70
              DO 60 I = 1,M
              TMP = A(I,J)
              A(I,J) = A(I,LMAX)
   60         A(I,LMAX) = TMP
          H(LMAX) = H(J)
C
C     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
C    ..
   70     CALL DH12 (1,J,J+1,M,A(1,J),1,H(J),A(1,J+1),1,MDA,N-J)
   80     CALL DH12 (2,J,J+1,M,A(1,J),1,H(J),B,1,MDB,NB)
C
C     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
C    ..
          DO 90 J = 1,LDIAG
          IF (DABS(A(J,J)) .LE. TAU) GO TO 100
   90     CONTINUE
      K = LDIAG
      GO TO 110
  100 K = J - 1
  110 KP1 = K + 1
C
C     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
C
      IF (NB .LE. 0) GO TO 140
          DO 130 JB = 1,NB
          TMP = 0.D0
          IF (KP1 .GT. M) GO TO 130
              DO 120 I = KP1,M
  120         TMP = TMP + B(I,JB)**2
  130     RNORM(JB) = DSQRT(TMP)
  140 CONTINUE
C                                           SPECIAL FOR PSEUDORANK = 0
      IF (K .GT. 0) GO TO 160
      IF (NB .LE. 0) GO TO 270
          DO 151 JB = 1,NB
              DO 150 I = 1,N
  150         B(I,JB) = 0.D0
  151     CONTINUE
      GO TO 270
C
C     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
C     DECOMPOSITION OF FIRST K ROWS.
C    ..
  160 IF (K .EQ. N) GO TO 180
          DO 170 II = 1,K
          I = KP1 - II
  170     CALL DH12 (1,I,KP1,N,A(I,1),MDA,G(I),A,MDA,1,I-1)
  180 CONTINUE
C
C
      IF (NB .LE. 0) GO TO 270
          DO 260 JB = 1,NB
C
C     SOLVE THE K BY K TRIANGULAR SYSTEM.
C    ..
              DO 210 L = 1,K
              SM = 0.D0
              I = KP1 - L
              IF (I .EQ. K) GO TO 200
              IP1 = I + 1
                  DO 190 J = IP1,K
  190             SM = SM + A(I,J)*B(J,JB)
  200         SM1 = B(I,JB) - SM
  210         B(I,JB) = SM1/A(I,I)
C
C     COMPLETE COMPUTATION OF SOLUTION VECTOR.
C    ..
          IF (K .EQ. N) GO TO 240
              DO 220 J = KP1,N
  220         B(J,JB) = 0.D0
              DO 230 I = 1,K
  230         CALL DH12 (2,I,KP1,N,A(I,1),MDA,G(I),B(1,JB),1,MDB,1)
C
C      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
C      COLUMN INTERCHANGES.
C    ..
  240         DO 250 JJ = 1,LDIAG
              J = LDIAG + 1 - JJ
              IF (IP(J) .EQ. J) GO TO 250
              L = IP(J)
              TMP = B(L,JB)
              B(L,JB) = B(J,JB)
              B(J,JB) = TMP
  250         CONTINUE
  260     CONTINUE
C    ..
C     THE SOLUTION VECTORS, X, ARE NOW
C     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
C
  270 RETURN
      END
      SUBROUTINE DHFTI2(A,MDA,M,N,B,MDB,NB,D,TAU,K,RNORM,H,G,IP,IERR)
C-----------------------------------------------------------------------
C     DOUBLE PRECISION A(MDA,N),(B(MDB,NB) OR B(M))
C     DOUBLE PRECISION D(L) WHERE L = MIN(M,N)
C     DOUBLE PRECISION TAU,RNORM(NB),H(N),G(N)
C     INTEGER IP(N)
C
C     WRITTEN BY C.L. LAWSON AND R.J. HANSON. MODIFIED BY A.H. MORRIS.
C     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
C     FOR ALGORITHMIC DETAILS SEE ALGORITHM HFTI IN CHAPTER 14.
C
C     ABSTRACT
C
C     THIS SUBROUTINE SOLVES A LINEAR LEAST SQUARES PROBLEM OR A SET OF
C     LINEAR LEAST SQUARES PROBLEMS HAVING THE SAME MATRIX BUT DIFFERENT
C     RIGHT-SIDE VECTORS.  THE PROBLEM DATA CONSISTS OF AN M BY N MATRIX
C     A, AN M BY NB MATRIX B, AND AN ABSOLUTE TOLERANCE PARAMETER TAU
C     WHOSE USAGE IS DESCRIBED BELOW.  THE NB COLUMN VECTORS OF B
C     REPRESENT RIGHT-SIDE VECTORS FOR NB DISTINCT LINEAR LEAST SQUARES
C     PROBLEMS.
C
C     THIS SET OF PROBLEMS CAN ALSO BE WRITTEN AS THE MATRIX LEAST
C     SQUARES PROBLEM
C
C                       AX = B,
C
C     WHERE X IS THE N BY NB SOLUTION MATRIX.
C
C     NOTE THAT IF B IS THE M BY M IDENTITY MATRIX, THEN X WILL BE THE
C     PSEUDO-INVERSE OF A.
C
C     THIS SUBROUTINE FIRST TRANSFORMS THE AUGMENTED MATRIX (A B) TO A
C     MATRIX (R C) USING PREMULTIPLYING HOUSEHOLDER TRANSFORMATIONS WITH
C     COLUMN INTERCHANGES.  ALL SUBDIAGONAL ELEMENTS IN THE MATRIX R ARE
C     ZERO AND ITS DIAGONAL ELEMENTS SATISFY
C
C                       DABS(R(I,I)).GE.DABS(R(I+1,I+1)),
C
C                       I = 1,...,L-1, WHERE
C
C                       L = MIN(M,N).
C
C     THE ARRAY D WILL CONTAIN THE DIAGONAL ELEMENTS R(1,1),...,R(L,L).
C     THE SUBROUTINE SETS K TO BE THE NUMBER OF DIAGONAL ELEMENTS THAT
C     EXCEED TAU IN MAGNITUDE.  THEN THE SOLUTION OF MINIMUM EUCLIDEAN
C     LENGTH IS COMPUTED USING THE FIRST K ROWS OF (R C).
C
C     TO BE SPECIFIC WE SUGGEST THAT THE USER CONSIDER AN EASILY
C     COMPUTABLE MATRIX NORM, SUCH AS, THE MAXIMUM OF ALL COLUMN SUMS OF
C     MAGNITUDES.
C
C     NOW IF THE RELATIVE UNCERTAINTY OF B IS EPS, (NORM OF UNCERTAINTY/
C     NORM OF B), IT IS SUGGESTED THAT TAU BE SET APPROXIMATELY EQUAL TO
C     EPS*(NORM OF A).
C
C     THE ENTIRE SET OF PARAMETERS FOR DHFTI2 ARE
C
C     INPUT..
C
C     A(*,*),MDA,M,N    THE ARRAY A(*,*) INITIALLY CONTAINS THE M BY N
C                       MATRIX A OF THE LEAST SQUARES PROBLEM AX = B.
C                       THE FIRST DIMENSIONING PARAMETER OF THE ARRAY
C                       A(*,*) IS MDA, WHICH MUST SATISFY MDA.GE.M
C                       EITHER M.GE.N OR M.LT.N IS PERMITTED.  THERE
C                       IS NO RESTRICTION ON THE RANK OF A.  THE
C                       CONDITION MDA.LT.M IS CONSIDERED AN ERROR.
C
C     B(*),MDB,NB       IF NB = 0 THE SUBROUTINE WILL PERFORM THE
C                       ORTHOGONAL DECOMPOSITION BUT WILL MAKE NO
C                       REFERENCES TO THE ARRAY B(*).  IF NB.GT.0
C                       THE ARRAY B(*) MUST INITIALLY CONTAIN THE M BY
C                       NB MATRIX B OF THE LEAST SQUARES PROBLEM AX =
C                       B.  IF NB.GE.2 THE ARRAY B(*) MUST BE DOUBLY
C                       SUBSCRIPTED WITH FIRST DIMENSIONING PARAMETER
C                       MDB.GE.MAX(M,N).  IF NB = 1 THE ARRAY B(*) MAY
C                       BE EITHER DOUBLY OR SINGLY SUBSCRIPTED.  IN
C                       THE LATTER CASE THE VALUE OF MDB IS ARBITRARY
C                       BUT IT SHOULD BE SET TO SOME VALID INTEGER
C                       VALUE SUCH AS MDB = M.
C
C                       THE CONDITION OF NB.GT.1.AND.MDB.LT. MAX(M,N)
C                       IS CONSIDERED AN ERROR.
C
C     TAU               ABSOLUTE TOLERANCE PARAMETER PROVIDED BY USER
C                       FOR PSEUDORANK DETERMINATION.
C
C     H(*),G(*),IP(*)   ARRAYS OF WORKING SPACE USED BY DHFTI2.
C
C     OUTPUT..
C
C     A(*,*)            THE CONTENTS OF THE ARRAY A(*,*) WILL BE
C                       MODIFIED BY THE SUBROUTINE.  THESE CONTENTS
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C
C     B(*)              ON RETURN THE ARRAY B(*) WILL CONTAIN THE N BY
C                       NB SOLUTION MATRIX X.
C
C     D(*)              THE ARRAY OF DIAGONAL ELEMENTS OF THE
C                       TRIANGULAR MATRIX R
C
C     K                 SET BY THE SUBROUTINE TO INDICATE THE
C                       PSEUDORANK OF A.
C
C     RNORM(*)          ON RETURN, RNORM(J) WILL CONTAIN THE EUCLIDEAN
C                       NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
C                       DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY
C                       B(*,*) FOR J = 1,...,NB.
C
C     H(*),G(*)         ON RETURN THESE ARRAYS RESPECTIVELY CONTAIN
C                       ELEMENTS OF THE PRE- AND POST-MULTIPLYING
C                       HOUSEHOLDER TRANSFORMATIONS USED TO COMPUTE
C                       THE MINIMUM EUCLIDEAN LENGTH SOLUTION.
C
C     IP(*)             ARRAY IN WHICH THE SUBROUTINE RECORDS INDICES
C                       DESCRIBING THE PERMUTATION OF COLUMN VECTORS.
C                       THE CONTENTS OF ARRAYS H(*),G(*) AND IP(*)
C                       ARE NOT GENERALLY REQUIRED BY THE USER.
C
C     IERR              ERROR INDICATOR. IF NO INPUT ERRORS ARE
C                       DETECTED THEN IERR IS SET TO 0. OTHERWISE
C                          IERR = 1  IF MDA.LT.M
C                          IERR = 2  IF NB.GT.1 AND MDB.LT.MAX(M,N)
C                       THESE ERRORS ARE FATAL.
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(MDA,N),B(MDB,*),D(*),TAU,RNORM(*),H(N),G(N)
      INTEGER IP(N)
      DOUBLE PRECISION FACTOR,HMAX,SM,SM1,TMP,Z
C---------------------
      DATA FACTOR /1.D-3/
C
      K = 0
      LDIAG = MIN0(M,N)
      IF (LDIAG .LE. 0) GO TO 270
      IF (M .GT. MDA) GO TO 300
      IF (NB .GT. 1 .AND. MAX0(M,N) .GT. MDB) GO TO 310
C
          DO 80 J = 1,LDIAG
          IF (J .EQ. 1) GO TO 20
C
C     UPDATE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
          LMAX = J
              DO 10 L = J,N
              H(L) = H(L) - A(J-1,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   10         CONTINUE
          Z = HMAX + FACTOR*H(LMAX)
          IF (Z .GT. HMAX) GO TO 50
C
C     COMPUTE SQUARED COLUMN LENGTHS AND FIND LMAX
C    ..
   20     LMAX = J
              DO 40 L = J,N
              H(L) = 0.D0
                  DO 30 I = J,M
   30             H(L) = H(L) + A(I,L)**2
              IF (H(L) .GT. H(LMAX)) LMAX = L
   40         CONTINUE
          HMAX = H(LMAX)
C    ..
C     LMAX HAS BEEN DETERMINED
C
C     DO COLUMN INTERCHANGES IF NEEDED.
C    ..
   50     IP(J) = LMAX
          IF (IP(J) .EQ. J) GO TO 70
              DO 60 I = 1,M
              TMP = A(I,J)
              A(I,J) = A(I,LMAX)
   60         A(I,LMAX) = TMP
          H(LMAX) = H(J)
C
C     COMPUTE THE J-TH TRANSFORMATION AND APPLY IT TO A AND B.
C    ..
   70     CALL DH12 (1,J,J+1,M,A(1,J),1,H(J),A(1,J+1),1,MDA,N-J)
   80     CALL DH12 (2,J,J+1,M,A(1,J),1,H(J),B,1,MDB,NB)
C
C     DETERMINE THE PSEUDORANK, K, USING THE TOLERANCE, TAU.
C     ALSO STORE THE DIAGONAL ELEMENTS IN THE ARRAY D.
C    ..
          DO 90 J = 1,LDIAG
          IF (DABS(A(J,J)) .LE. TAU) GO TO 100
   90     D(J) = A(J,J)
          K = LDIAG
          KP1 = K + 1
          GO TO 110
C
  100     K = J - 1
          KP1 = J
          DO 105 J = KP1,LDIAG
  105     D(J) = A(J,J)
C
C     COMPUTE THE NORMS OF THE RESIDUAL VECTORS.
C
  110 IF (NB .LE. 0) GO TO 140
          DO 130 JB = 1,NB
          TMP = 0.D0
          IF (KP1 .GT. M) GO TO 130
              DO 120 I = KP1,M
  120         TMP = TMP + B(I,JB)**2
  130     RNORM(JB) = DSQRT(TMP)
  140 CONTINUE
C                                           SPECIAL FOR PSEUDORANK = 0
      IF (K .GT. 0) GO TO 160
      IF (NB .LE. 0) GO TO 270
          DO 151 JB = 1,NB
              DO 150 I = 1,N
  150         B(I,JB) = 0.D0
  151     CONTINUE
      GO TO 270
C
C     IF THE PSEUDORANK IS LESS THAN N COMPUTE HOUSEHOLDER
C     DECOMPOSITION OF FIRST K ROWS.
C    ..
  160 IF (K .EQ. N) GO TO 180
          DO 170 II = 1,K
          I = KP1 - II
  170     CALL DH12 (1,I,KP1,N,A(I,1),MDA,G(I),A,MDA,1,I-1)
  180 CONTINUE
C
C
      IF (NB .LE. 0) GO TO 270
          DO 260 JB = 1,NB
C
C     SOLVE THE K BY K TRIANGULAR SYSTEM.
C    ..
              DO 210 L = 1,K
              SM = 0.D0
              I = KP1 - L
              IF (I .EQ. K) GO TO 200
              IP1 = I + 1
                  DO 190 J = IP1,K
  190             SM = SM + A(I,J)*B(J,JB)
  200         SM1 = B(I,JB) - SM
  210         B(I,JB)=SM1/A(I,I)
C
C     COMPLETE COMPUTATION OF SOLUTION VECTOR.
C    ..
          IF (K .EQ. N) GO TO 240
              DO 220 J = KP1,N
  220         B(J,JB) = 0.D0
              DO 230 I = 1,K
  230         CALL DH12 (2,I,KP1,N,A(I,1),MDA,G(I),B(1,JB),1,MDB,1)
C
C      RE-ORDER THE SOLUTION VECTOR TO COMPENSATE FOR THE
C      COLUMN INTERCHANGES.
C    ..
  240         DO 250 JJ = 1,LDIAG
              J = LDIAG + 1 - JJ
              IF (IP(J) .EQ. J) GO TO 250
              L = IP(J)
              TMP = B(L,JB)
              B(L,JB) = B(J,JB)
              B(J,JB) = TMP
  250         CONTINUE
  260     CONTINUE
C    ..
C     THE SOLUTION VECTORS, X, ARE NOW
C     IN THE FIRST  N  ROWS OF THE ARRAY B(,).
C
  270 IERR = 0
      RETURN
C
C     ERROR RETURN
C
  300 IERR = 1
      RETURN
  310 IERR = 2
      RETURN
      END
      SUBROUTINE DH12 (MODE,LPIVOT,L1,M,U,IUE,UP,C,ICE,ICV,NCV)
C-----------------------------------------------------------------------
C     WRITTEN BY C.L. LAWSON AND R.J. HANSON.  MODIFIED BY A.H. MORRIS.
C     FROM THE BOOK SOLVING LEAST SQUARES PROBLEMS, PRENTICE-HALL, 1974.
C
C     CONSTRUCTION AND/OR APPLICATION OF A SINGLE
C     HOUSEHOLDER TRANSFORMATION..     Q = I + U*(U**T)/B
C
C     MODE    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
C     LPIVOT IS THE INDEX OF THE PIVOT ELEMENT.
C     L1,M   IF L1 .LE. M   THE TRANSFORMATION WILL BE CONSTRUCTED TO
C            ZERO ELEMENTS INDEXED FROM L1 THROUGH M.   IF L1 GT. M
C            THE SUBROUTINE DOES AN IDENTITY TRANSFORMATION.
C     U(),IUE,UP    ON ENTRY TO H1 U() CONTAINS THE PIVOT VECTOR.
C                   IUE IS THE STORAGE INCREMENT BETWEEN ELEMENTS.
C                                       ON EXIT FROM H1 U() AND UP
C                   CONTAIN QUANTITIES DEFINING THE VECTOR U OF THE
C                   HOUSEHOLDER TRANSFORMATION.   ON ENTRY TO H2 U()
C                   AND UP SHOULD CONTAIN QUANTITIES PREVIOUSLY COMPUTED
C                   BY H1.  THESE WILL NOT BE MODIFIED BY H2.
C     C()    ON ENTRY TO H1 OR H2 C() CONTAINS A MATRIX WHICH WILL BE
C            REGARDED AS A SET OF VECTORS TO WHICH THE HOUSEHOLDER
C            TRANSFORMATION IS TO BE APPLIED.  ON EXIT C() CONTAINS THE
C            SET OF TRANSFORMED VECTORS.
C     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN C().
C     ICV    STORAGE INCREMENT BETWEEN VECTORS IN C().
C     NCV    NUMBER OF VECTORS IN C() TO BE TRANSFORMED. IF NCV .LE. 0
C            NO OPERATIONS WILL BE DONE ON C().
C-----------------------------------------------------------------------
      DOUBLE PRECISION U(IUE,M),UP,C(*)
      DOUBLE PRECISION B,CL,D,SM
C
      IF (0 .GE. LPIVOT .OR. LPIVOT .GE. L1 .OR. L1 .GT. M) RETURN
      CL = DABS(U(1,LPIVOT))
      IF (MODE .EQ. 2) GO TO 60
C
C                            ****** CONSTRUCT THE TRANSFORMATION. ******
C
          DO 10 J = L1,M
   10     CL = DMAX1(DABS(U(1,J)),CL)
      IF (CL .LE. 0.D0) GO TO 130
      D = U(1,LPIVOT)/CL
      SM = D*D
          DO 20 J = L1,M
          D = U(1,J)/CL
   20     SM = SM + D*D
C
      CL = CL*DSQRT(SM)
      IF (U(1,LPIVOT) .GT. 0.D0) CL = -CL
      UP = U(1,LPIVOT) - CL
      U(1,LPIVOT) = CL
      GO TO 70
C
C            ****** APPLY THE TRANSFORMATION  I+U*(U**T)/B  TO C. ******
C
   60 IF (CL) 130,130,70
   70 IF (NCV .LE. 0) RETURN
      B = UP*U(1,LPIVOT)
C
C                       B  MUST BE NONPOSITIVE HERE.  IF B = 0., RETURN.
C
      IF (B .GE. 0.D0) GO TO 130
      B = 1.D0/B
      I2 = 1 - ICV + ICE*(LPIVOT - 1)
      INCR = ICE*(L1 - LPIVOT)
          DO 120 J = 1,NCV
          I2 = I2 + ICV
          I3 = I2 + INCR
          I4 = I3
          SM = C(I2)*UP
              DO 90 I = L1,M
              SM = SM + C(I3)*U(1,I)
   90         I3 = I3 + ICE
          IF (SM .EQ. 0.D0) GO TO 120
          SM = SM*B
          C(I2) = C(I2) + SM*UP
              DO 110 I = L1,M
              C(I4) = C(I4) + SM*U(1,I)
  110         I4 = I4 + ICE
  120     CONTINUE
  130 RETURN
      END
      SUBROUTINE LSEI(W, MDW, ME, MA, MG, N, PRGOPT, X, RNORME, RNORML,
     * MODE, WS, IP)
C
C     DIMENSION W(MDW,N+1),PRGOPT(*),X(N),
C     WS(2*(ME+N)+K+(MG+2)*(N+7)),IP(MG+2*N+2)
C     ABOVE, K=MAX(MA+MG,N).
C
C     WRITTEN BY R. J. HANSON AND K. H. HASKELL.  FOR FURTHER MATH.
C     AND ALGORITHMIC DETAILS SEE SANDIA LABORATORIES TECH. REPTS.
C     SAND77-0552, (1978), AND SAND78-1290, (1979), AND MATH.
C     PROGRAMMING (21), 1981, PP. 98-118. MODIFIED BY A.H. MORRIS.
C
C     ABSTRACT
C
C     THIS SUBPROGRAM SOLVES A LINEARLY CONSTRAINED LEAST SQUARES
C     PROBLEM WITH BOTH EQUALITY AND INEQUALITY CONSTRAINTS, AND, IF THE
C     USER REQUESTS, OBTAINS A COVARIANCE MATRIX OF THE SOLUTION
C     PARAMETERS.
C
C     SUPPOSE THERE ARE GIVEN MATRICES E, A AND G OF RESPECTIVE
C     DIMENSIONS ME BY N, MA BY N AND MG BY N, AND VECTORS F, B AND H OF
C     RESPECTIVE LENGTHS ME, MA AND MG.  THIS SUBROUTINE SOLVES THE
C     LINEARLY CONSTRAINED LEAST SQUARES PROBLEM
C
C                   EX = F, (E ME BY N) (EQUATIONS TO BE EXACTLY
C                                       SATISFIED)
C                   AX = B, (A MA BY N) (EQUATIONS TO BE
C                                       APPROXIMATELY SATISFIED,
C                                       LEAST SQUARES SENSE)
C                   GX.GE.H,(G MG BY N) (INEQUALITY CONSTRAINTS)
C
C     THE INEQUALITIES GX.GE.H MEAN THAT EVERY COMPONENT OF THE PRODUCT
C     GX MUST BE .GE. THE CORRESPONDING COMPONENT OF H.
C
C     IN CASE THE EQUALITY CONSTRAINTS CANNOT BE SATISFIED, A
C     GENERALIZED INVERSE SOLUTION RESIDUAL VECTOR LENGTH IS OBTAINED
C     FOR F-EX. THIS IS THE MINIMAL LENGTH POSSIBLE FOR F-EX.
C
C
C     ANY VALUES ME.GE.0, MA.GE.0, OR MG.GE.0 ARE PERMITTED.  THE
C     RANK OF THE MATRIX E IS ESTIMATED DURING THE COMPUTATION. WE CALL
C     THIS VALUE KRANKE. IT IS AN OUTPUT PARAMETER IN IP(1) DEFINED
C     BELOW. USING A GENERALIZED INVERSE SOLUTION OF EX=F, A REDUCED
C     LEAST SQUARES PROBLEM WITH INEQUALITY CONSTRAINTS IS OBTAINED.
C     THE TOLERANCES USED IN THESE TESTS FOR DETERMINING THE RANK
C     OF E AND THE RANK OF THE REDUCED LEAST SQUARES PROBLEM ARE
C     GIVEN IN SANDIA TECH. REPT. SAND78-1290. THEY CAN BE
C     MODIFIED BY THE USER IF NEW VALUES ARE PROVIDED IN
C     THE OPTION LIST OF THE ARRAY PRGOPT(*).
C
C     THE USER MUST DIMENSION ALL ARRAYS APPEARING IN THE CALL LIST..
C     W(MDW,N+1),PRGOPT(*),X(N),WS(2*(ME+N)+K+(MG+2)*(N+7)),IP(MG+2*N+2)
C     WHERE K=MAX(MA+MG,N).  THIS ALLOWS FOR A SOLUTION OF A RANGE OF
C     PROBLEMS IN THE GIVEN WORKING SPACE.  THE DIMENSION OF WS(*)
C     GIVEN IS A NECESSARY OVERESTIMATE.  ONCE A PARTICULAR PROBLEM
C     HAS BEEN RUN, THE OUTPUT PARAMETER IP(3) GIVES THE ACTUAL
C     DIMENSION REQUIRED FOR THAT PROBLEM.
C
C     THE PARAMETERS FOR LSEI( ) ARE
C
C     INPUT..
C
C     W(*,*),MDW,   THE ARRAY W(*,*) IS DOUBLY SUBSCRIPTED WITH
C     ME,MA,MG,N    FIRST DIMENSIONING PARAMETER EQUAL TO MDW.
C                   FOR THIS DISCUSSION LET US CALL M = ME+MA+MG.  THEN
C                   MDW MUST SATISFY MDW.GE.M.  THE CONDITION
C                   MDW.LT.M IS AN ERROR.
C
C                   THE ARRAY W(*,*) CONTAINS THE MATRICES AND VECTORS
C
C                                  (E  F)
C                                  (A  B)
C                                  (G  H)
C
C                   IN ROWS AND COLUMNS 1,...,M AND 1,...,N+1
C                   RESPECTIVELY.
C
C                   THE INTEGERS ME, MA, AND MG ARE THE
C                   RESPECTIVE MATRIX ROW DIMENSIONS
C                   OF E, A AND G. EACH MATRIX HAS N COLUMNS.
C
C     PRGOPT(*)    THIS REAL-VALUED ARRAY IS THE OPTION VECTOR.
C                  IF THE USER IS SATISFIED WITH THE NOMINAL
C                  SUBPROGRAM FEATURES SET
C
C                  PRGOPT(1)=1 (OR PRGOPT(1)=1.0)
C
C                  OTHERWISE PRGOPT(*) IS A LINKED LIST CONSISTING OF
C                  GROUPS OF DATA OF THE FOLLOWING FORM
C
C                  LINK
C                  KEY
C                  DATA SET
C
C                  THE PARAMETERS LINK AND KEY ARE EACH ONE WORD.
C                  THE DATA SET CAN BE COMPRISED OF SEVERAL WORDS.
C                  THE NUMBER OF ITEMS DEPENDS ON THE VALUE OF KEY.
C                  THE VALUE OF LINK POINTS TO THE FIRST
C                  ENTRY OF THE NEXT GROUP OF DATA WITHIN
C                  PRGOPT(*).  THE EXCEPTION IS WHEN THERE ARE
C                  NO MORE OPTIONS TO CHANGE.  IN THAT
C                  CASE LINK=1 AND THE VALUES KEY AND DATA SET
C                  ARE NOT REFERENCED. THE GENERAL LAYOUT OF
C                  PRGOPT(*) IS AS FOLLOWS.
C
C               ...PRGOPT(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
C               .  PRGOPT(2)=KEY1 (KEY TO THE OPTION CHANGE)
C               .  PRGOPT(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
C               .       .
C               .       .
C               .       .
C               ...PRGOPT(LINK1)=LINK2 (LINK TO THE FIRST ENTRY OF
C               .                       NEXT GROUP)
C               .  PRGOPT(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
C               .  PRGOPT(LINK1+2)=DATA VALUE
C               ...     .
C               .       .
C               .       .
C               ...PRGOPT(LINK)=1 (NO MORE OPTIONS TO CHANGE)
C
C                  VALUES OF LINK THAT ARE NONPOSITIVE ARE ERRORS.
C                  A VALUE OF LINK.GT.NLINK=100000 IS ALSO AN ERROR.
C                  THIS HELPS PREVENT USING INVALID BUT POSITIVE
C                  VALUES OF LINK THAT WILL PROBABLY EXTEND
C                  BEYOND THE PROGRAM LIMITS OF PRGOPT(*).
C                  UNRECOGNIZED VALUES OF KEY ARE IGNORED.  THE
C                  ORDER OF THE OPTIONS IS ARBITRARY AND ANY NUMBER
C                  OF OPTIONS CAN BE CHANGED WITH THE FOLLOWING
C                  RESTRICTION.  TO PREVENT CYCLING IN THE
C                  PROCESSING OF THE OPTION ARRAY A COUNT OF THE
C                  NUMBER OF OPTIONS CHANGED IS MAINTAINED.
C                  WHENEVER THIS COUNT EXCEEDS NOPT=1000 THE
C                  ROUTINE TERMINATES.
C
C                  OPTIONS..
C
C                  KEY=1
C                         COMPUTE IN W(*,*) THE N BY N
C                  COVARIANCE MATRIX OF THE SOLUTION VARIABLES
C                  AS AN OUTPUT PARAMTER.  NOMINALLY THE
C                  COVARIANCE MATRIX WILL NOT BE COMPUTED.
C                  (THIS REQUIRES NO USER INPUT.)
C                  THE DATA SET FOR THIS OPTION IS A SINGLE VALUE.
C                  IT MUST BE NONZERO WHEN THE COVARIANCE MATRIX
C                  IS DESIRED.  IF IT IS ZERO, THE COVARIANCE
C                  MATRIX IS NOT COMPUTED.  WHEN THE COVARIANCE MATRIX
C                  IS COMPUTED, THE FIRST DIMENSIONING PARAMETER
C                  OF THE ARRAY W(*,*) MUST SATISFY MDW.GE.MAX0(M,N).
C
C                  KEY=2
C                         SCALE THE NONZERO COLUMNS OF THE
C                         ENTIRE DATA MATRIX.
C                  (E)
C                  (A)
C                  (G)
C
C                  TO HAVE LENGTH ONE.  THE DATA SET FOR THIS
C                  OPTION IS A SINGLE VALUE.  IT MUST BE
C                  NONZERO IF UNIT LENGTH COLUMN SCALING
C                  IS DESIRED.
C
C                  KEY=3
C                         SCALE COLUMNS OF THE ENTIRE DATA MATRIX
C                  (E)
C                  (A)
C                  (G)
C
C                  WITH A USER-PROVIDED DIAGONAL MATRIX.
C                  THE DATA SET FOR THIS OPTION CONSISTS
C                  OF THE N DIAGONAL SCALING FACTORS, ONE FOR
C                  EACH MATRIX COLUMN.
C
C                  KEY=4
C                         CHANGE THE RANK DETERMINATION TOLERANCE FOR
C                  THE EQUALITY CONSTRAINT EQUATIONS FROM
C                  THE NOMINAL VALUE OF SQRT(SRELPR).  THIS QUANTITY
C                  CAN BE NO SMALLER THAN SRELPR, THE ARITHMETIC-
C                  STORAGE PRECISION.  THE QUANTITY SRELPR IS THE
C                  LARGEST POSITIVE NUMBER SUCH THAT T=1.+SRELPR
C                  SATISFIES T.EQ.1.  THE QUANTITY USED
C                  HERE IS INTERNALLY RESTRICTED TO BE AT
C                  LEAST SRELPR.  THE DATA SET FOR THIS OPTION
C                  IS THE NEW TOLERANCE.
C
C                  KEY=5
C                         CHANGE THE RANK DETERMINATION TOLERANCE FOR
C                  THE REDUCED LEAST SQUARES EQUATIONS FROM
C                  THE NOMINAL VALUE OF SQRT(SRELPR).  THIS QUANTITY
C                  CAN BE NO SMALLER THAN SRELPR, THE ARITHMETIC-
C                  STORAGE PRECISION.  THE QUANTITY USED
C                  HERE IS INTERNALLY RESTRICTED TO BE AT
C                  LEAST SRELPR.  THE DATA SET FOR THIS OPTION
C                  IS THE NEW TOLERANCE.
C
C                  FOR EXAMPLE, SUPPOSE WE WANT TO CHANGE
C                  THE TOLERANCE FOR THE REDUCED LEAST SQUARES
C                  PROBLEM, COMPUTE THE COVARIANCE MATRIX OF
C                  THE SOLUTION PARAMETERS, AND PROVIDE
C                  COLUMN SCALING FOR THE DATA MATRIX.  FOR
C                  THESE OPTIONS THE DIMENSION OF PRGOPT(*)
C                  MUST BE AT LEAST N+9.  THE FORTRAN STATEMENTS
C                  DEFINING THESE OPTIONS WOULD BE AS FOLLOWS.
C
C                  PRGOPT(1)=4 (LINK TO ENTRY 4 IN PRGOPT(*))
C                  PRGOPT(2)=1 (COVARIANCE MATRIX KEY)
C                  PRGOPT(3)=1 (COVARIANCE MATRIX WANTED)
C
C                  PRGOPT(4)=7 (LINK TO ENTRY 7 IN PRGOPT(*))
C                  PRGOPT(5)=5 (LEAST SQUARES EQUAS. TOLERANCE KEY)
C                  PRGOPT(6)=... (NEW VALUE OF THE TOLERANCE)
C
C                  PRGOPT(7)=N+9 (LINK TO ENTRY N+9 IN PRGOPT(*))
C                  PRGOPT(8)=3 (USER-PROVIDED COLUMN SCALING KEY)
C
C                  CALL SCOPY(N,D,1,PRGOPT(9),1)  (COPY THE N
C                    SCALING FACTORS FROM THE USER ARRAY D(*)
C                    TO PRGOPT(9)-PRGOPT(N+8))
C
C                  PRGOPT(N+9)=1 (NO MORE OPTIONS TO CHANGE)
C
C                  THE CONTENTS OF PRGOPT(*) ARE NOT MODIFIED
C                  BY THE SUBPROGRAM.
C                  THE KEY 8 AND 9 OPTIONS FOR WNNLS( ) CAN ALSO
C                  BE INCLUDED IN THIS ARRAY.  THEIR FUNCTIONS
C                  ARE DOCUMENTED IN THE USAGE INSTRUCTIONS FOR
C                  SUBPROGRAM WNNLS( ).
C
C     OUTPUT..
C
C     X(*),RNORME,  THE ARRAY X(*) CONTAINS THE SOLUTION PARAMETERS
C     RNORML        IF THE INTEGER OUTPUT FLAG MODE = 0 OR 1.
C                   THE DEFINITION OF MODE IS GIVEN DIRECTLY BELOW.
C                   WHEN MODE = 0 OR 1, RNORME AND RNORML
C                   RESPECTIVELY CONTAIN THE RESIDUAL VECTOR
C                   EUCLIDEAN LENGTHS OF F - EX AND B - AX.  WHEN
C                   MODE=1 THE EQUALITY CONSTRAINT EQUATIONS EX=F
C                   ARE CONTRADICTORY, SO RNORME.NE.0. THE RESIDUAL
C                   VECTOR F-EX HAS MINIMAL EUCLIDEAN LENGTH. FOR
C                   MODE.GE.2, NONE OF THESE PARAMETERS ARE
C                   DEFINED.
C
C     MODE          INTEGER FLAG THAT INDICATES THE SUBPROGRAM
C                   STATUS AFTER COMPLETION.  IF MODE.GE.2, NO
C                   SOLUTION HAS BEEN COMPUTED.
C
C                   MODE =
C
C                   0  BOTH EQUALITY AND INEQUALITY CONSTRAINTS
C                      ARE COMPATIBLE AND HAVE BEEN SATISFIED.
C
C                   1  EQUALITY CONSTRAINTS ARE CONTRADICTORY.
C                      A GENERALIZED INVERSE SOLUTION OF EX=F WAS USED
C                      TO MINIMIZE THE RESIDUAL VECTOR LENGTH F-EX.
C                      IN THIS SENSE, THE SOLUTION IS STILL MEANINGFUL.
C
C                   2  NO SOLUTION COULD BE OBTAINED. THE CONSTRAINTS
C                      ARE CONTRADICTORY.
C
C                   4  USAGE ERROR OCCURRED.  THE VALUE
C                      OF MDW IS .LT. ME+MA+MG, MDW IS
C                      .LT. N AND A COVARIANCE MATRIX IS
C                      REQUESTED, OR THE OPTION VECTOR
C                      PRGOPT(*) IS NOT PROPERLY DEFINED.
C
C     W(*,*)        THE ARRAY W(*,*) CONTAINS THE N BY N SYMMETRIC
C                   COVARIANCE MATRIX OF THE SOLUTION PARAMETERS,
C                   PROVIDED THIS WAS REQUESTED ON INPUT WITH
C                   THE OPTION VECTOR PRGOPT(*) AND THE OUTPUT
C                   FLAG IS RETURNED WITH MODE = 0 OR 1.
C
C     IP(*)         THE INTEGER WORKING ARRAY HAS THREE ENTRIES
C                   THAT PROVIDE RANK AND WORKING ARRAY LENGTH
C                   INFORMATION AFTER COMPLETION.
C
C                      IP(1) = RANK OF EQUALITY CONSTRAINT
C                              MATRIX.  DEFINE THIS QUANTITY
C                              AS KRANKE.
C
C                      IP(2) = RANK OF REDUCED LEAST SQUARES
C                              PROBLEM.
C
C                      IP(3) = THE AMOUNT OF STORAGE IN THE
C                              WORKING ARRAY WS(*) THAT WAS
C                              ACTUALLY USED BY THE SUBPROGRAM.
C                              THE FORMULA GIVEN ABOVE FOR THE LENGTH
C                              OF WS(*) IS A NECESSARY OVERESTIMATE.
C     USER DESIGNATED
C     WORKING ARRAYS..
C
C     WS(*),IP(*)              THESE ARE RESPECTIVELY TYPE REAL
C                              AND TYPE INTEGER WORKING ARRAYS.
C                              THEIR REQUIRED MINIMAL LENGTHS ARE
C                              GIVEN ABOVE.
C
C
C     SUBROUTINES CALLED
C
C     LSI           PART OF THIS PACKAGE.  SOLVES A
C                   CONSTRAINED LEAST SQUARES PROBLEM WITH
C                   INEQUALITY CONSTRAINTS.
C
C     SDOT,SSCAL,   SUBROUTINES FROM THE BLAS PACKAGE.
C     SAXPY,SASUM,  SEE TRANS. MATH SOFTWARE (5), P. 308.
C     SCOPY,SNRM2,
C     SSWAP,ISAMAX
C
C     H12           SUBROUTINE TO CONSTRUCT AND APPLY A
C                   HOUSEHOLDER TRANSFORMATION.
C
C     SPMPAR        FUNCTION TO COMPUTE THE RELATIVE MACHINE
C                   PRECISION.
C
C     REVISED OCT. 1, 1989.
C
      REAL W(MDW,*), PRGOPT(*), X(*), WS(*)
      INTEGER IP(*)
      LOGICAL COV
      DATA ZERO /0.E0/, ONE /1.E0/, HALF /0.5E0/
C
C     COMPUTE MACHINE PRECISION
C
      SRELPR = SPMPAR(1)
C
C     COMPUTE NUMBER OF POSSIBLE RIGHT MULTIPLYING HOUSEHOLDER
C     TRANSFORMATIONS.
C
      M = ME + MA + MG
      MODE = 0
      IF (N .LE. 0 .OR. ME + MA .LE. 0) RETURN
      IF (.NOT.(MDW.LT.M)) GO TO 80
      MODE = 4
      RETURN
   80 NP1 = N + 1
      KRANKE = MIN0(ME,N)
      N1 = 2*KRANKE + 1
      N2 = N1 + N
C
C     PROCESS-OPTION-VECTOR
C
      GO TO 480
   90 IF (.NOT.(COV .AND. MDW.LT.N)) GO TO 100
      MODE = 4
      RETURN
  100 L = KRANKE
C
C     COMPUTE NORM OF EQUALITY CONSTRAINT MATRIX AND RT SIDE.
C
      ENORM = ZERO
      DO 110 J = 1,N
        ENORM = AMAX1(ENORM,SASUM(ME,W(1,J),1))
  110 CONTINUE
      FNORM = SASUM(ME,W(1,NP1),1)
      IF (.NOT.(L.GT.0)) GO TO 200
      SNMAX = ZERO
      RNMAX = ZERO
      DO 180 I = 1,L
C
C     COMPUTE MAXIMUM RATIO OF VECTOR LENGTHS. PARTITION
C     IS AT COL. I.
        DO 150 K = I,ME
           SN = SDOT(N-I+1,W(K,I),MDW,W(K,I),MDW)
           RN = SDOT(I-1,W(K,1),MDW,W(K,1),MDW)
           IF (.NOT.(RN.EQ.ZERO .AND. SN.GT.SNMAX)) GO TO 120
           SNMAX = SN
           IMAX = K
           GO TO 150
  120      IF (.NOT.(K.EQ.I .OR. (SN*RNMAX.GT.RN*SNMAX))) GO TO 150
           SNMAX = SN
           RNMAX = RN
           IMAX = K
  150   CONTINUE
C
C     INTERCHANGE ROWS IF NECESSARY.
        IF (I.NE.IMAX) CALL SSWAP(NP1, W(I,1), MDW, W(IMAX,1), MDW)
        IF (.NOT.(SNMAX.GT.TAU**2*RNMAX)) GO TO 160
C
C     ELIMINATE ELEMS I+1,...,N IN ROW I.
        CALL H12(1, I, I+1, N, W(I,1), MDW, WS(I), W(I+1,1), MDW, 1,
     *   M-I)
        GO TO 180
  160   KRANKE = I - 1
        GO TO 200
  180 CONTINUE
C
C     SAVE DIAG. TERMS OF LOWER TRAP. MATRIX.
C
  200 CALL SCOPY(KRANKE, W, MDW+1, WS(KRANKE+1), 1)
C
C     USE HOUSEHOLDER TRANS FROM LEFT TO ACHIEVE KRANKE BY KRANKE UPPER
C     TRIANGULAR FORM.
C
      IF (.NOT.(KRANKE.GT.0 .AND. KRANKE.LT.ME)) GO TO 220
      DO 210 KK = 1,KRANKE
        K = KRANKE + 1 - KK
C
C     APPLY TRANFORMATION TO MATRIX COLS. 1,...,K-1.
        CALL H12(1, K, KRANKE+1, ME, W(1,K), 1, UP, W, 1, MDW, K-1)
C
C     APPLY TO RT SIDE VECTOR.
        CALL H12(2, K, KRANKE+1, ME, W(1,K), 1, UP, W(1,NP1), 1, 1, 1)
  210 CONTINUE
  220 IF (.NOT.(KRANKE.GT.0)) GO TO 240
C
C     SOLVE FOR VARIABLES 1,...,KRANKE IN NEW COORDINATES.
      CALL SCOPY(KRANKE, W(1,NP1), 1, X, 1)
      DO 230 I=1,KRANKE
        X(I) = (X(I)-SDOT(I-1,W(I,1),MDW,X,1))/W(I,I)
  230 CONTINUE
C
C     COMPUTE RESIDUALS FOR REDUCED PROBLEM.
C
  240 MEP1 = ME + 1
      RNORML = ZERO
      IF (.NOT.(ME.LT.M)) GO TO 270
      DO 260 I = MEP1,M
        W(I,NP1) = W(I,NP1) - SDOT(KRANKE,W(I,1),MDW,X,1)
        SN = SDOT(KRANKE,W(I,1),MDW,W(I,1),MDW)
        RN = SDOT(N-KRANKE,W(I,KRANKE+1),MDW,W(I,KRANKE+1),MDW)
        IF (.NOT.(RN.LE.TAU**2*SN .AND. KRANKE.LT.N)) GO TO 260
        W(I,KRANKE+1) = ZERO
        CALL SCOPY(N-KRANKE, W(I,KRANKE+1), 0, W(I,KRANKE+1), MDW)
  260 CONTINUE
C
C     COMPUTE EQUAL. CONSTRAINT EQUAS. RESIDUAL LENGTH.
  270 RNORME = SNRM2(ME-KRANKE,W(KRANKE+1,NP1),1)
C
C     MOVE REDUCED PROBLEM DATA UPWARD IF KRANKE.LT.ME.
C
      IF (.NOT.(KRANKE.LT.ME)) GO TO 290
      DO 280 J=1,NP1
        CALL SCOPY(M-ME, W(ME+1,J), 1, W(KRANKE+1,J), 1)
  280 CONTINUE
C
C     COMPUTE SOLN OF REDUCED PROBLEM.
C
  290 CALL LSI(W(KRANKE+1,KRANKE+1), MDW, MA, MG, N-KRANKE, PRGOPT,
     * X(KRANKE+1), RNORML, MODE, WS(N2), IP(2))
      IF (MODE .GT. 1) GO TO 470
      IF (.NOT.(ME.GT.0)) GO TO 330
C
C     TEST FOR CONSISTENCY OF EQUALITY CONSTRAINTS.
C
      MDEQC = 0
      XNRME = SASUM(KRANKE,W(1,NP1),1)
      IF (RNORME.GT.TAU*(ENORM*XNRME+FNORM)) MDEQC = 1
      MODE = MODE + MDEQC
C
C     CHECK IF SOLN TO EQUAL. CONSTRAINTS SATISFIES INEQUAL.
C     CONSTRAINTS WHEN THERE ARE NO DEGREES OF FREEDOM LEFT.
C
      IF (.NOT.(KRANKE.EQ.N .AND. MG.GT.0)) GO TO 330
      XNORM = SASUM(N,X,1)
      MAPKE1 = MA + KRANKE + 1
      MEND = MA + KRANKE + MG
      DO 310 I=MAPKE1,MEND
        SIZE = SASUM(N,W(I,1),MDW)*XNORM + ABS(W(I,NP1))
        IF (.NOT.(W(I,NP1).GT.TAU*SIZE)) GO TO 310
        MODE = 2
        GO TO 470
  310 CONTINUE
  330 IF (.NOT.(KRANKE.GT.0)) GO TO 420
C
C     REPLACE DIAG. TERMS OF LOWER TRAP. MATRIX.
      CALL SCOPY(KRANKE, WS(KRANKE+1), 1, W, MDW+1)
C
C     REAPPLY TRANS TO PUT SOLN IN ORIGINAL COORDINATES.
C
      DO 340 II = 1,KRANKE
        I = KRANKE + 1 - II
        CALL H12(2, I, I+1, N, W(I,1), MDW, WS(I), X, 1, 1, 1)
  340 CONTINUE
C
C     COMPUTE COV MATRIX OF EQUAL. CONSTRAINED PROBLEM.
C
      IF (.NOT.(COV)) GO TO 450
      DO 400 JJ=1,KRANKE
        J = KRANKE + 1 - JJ
        IF (.NOT.(J.LT.N)) GO TO 400
        RB = WS(J)*W(J,J)
        IF (RB.NE.ZERO) RB = ONE/RB
        JP1 = J + 1
        DO 350 I=JP1,N
          W(I,J) = SDOT(N-J,W(I,JP1),MDW,W(J,JP1),MDW)*RB
  350   CONTINUE
        GAM = SDOT(N-J,W(JP1,J),1,W(J,JP1),MDW)*RB
        GAM = HALF*GAM
        CALL SAXPY(N-J, GAM, W(J,JP1), MDW, W(JP1,J), 1)
        DO 370 I=JP1,N
          DO 360 K=I,N
            W(I,K) = W(I,K) + W(J,I)*W(K,J) + W(I,J)*W(J,K)
            W(K,I) = W(I,K)
  360     CONTINUE
  370   CONTINUE
        UJ = WS(J)
        VJ = GAM*UJ
        W(J,J) = UJ*VJ + UJ*VJ
        DO 380 I=JP1,N
          W(J,I) = UJ*W(I,J) + VJ*W(J,I)
  380   CONTINUE
        CALL SCOPY(N-J, W(J,JP1), MDW, W(JP1,J), 1)
  400 CONTINUE
C
C     APPLY THE SCALING TO THE COVARIANCE MATRIX.
C
  420 IF (.NOT.(COV)) GO TO 450
      DO 430 I = 1,N
        L = N1 + I
        CALL SSCAL(N, WS(L-1), W(I,1), MDW)
        CALL SSCAL(N, WS(L-1), W(1,I), 1)
  430 CONTINUE
C
C     RESCALE SOLN. VECTOR.
C
  450 IF (MODE .GT. 1) GO TO 470
      DO 460 J = 1,N
        L = N1 + J
        X(J) = X(J)*WS(L-1)
  460 CONTINUE
  470 IP(1) = KRANKE
      IP(3) = IP(3) + 2*KRANKE + N
      RETURN
  480 CONTINUE
C     TO PROCESS-OPTION-VECTOR
C
C     THE NOMINAL TOLERANCE USED IN THE CODE
C     FOR THE EQUALITY CONSTRAINT EQUATIONS.
      TAU = SQRT(SRELPR)
C
C     THE NOMINAL COLUMN SCALING USED IN THE CODE IS
C     THE IDENTITY SCALING.
      WS(N1) = ONE
      CALL SCOPY(N, WS(N1), 0, WS(N1), 1)
C
C     NO COVARIANCE MATRIX IS NOMINALLY COMPUTED.
      COV = .FALSE.
C
C     DEFINE BOUND FOR NUMBER OF OPTIONS TO CHANGE.
      NOPT = 1000
      NTIMES = 0
C
C     DEFINE BOUND FOR POSITIVE VALUES OF LINK.
      NLINK = 100000
      LAST = 1
      LINK = PRGOPT(1)
      IF (.NOT.(LINK.LE.0 .OR. LINK.GT.NLINK)) GO TO 490
      MODE = 4
      RETURN
  490 IF (.NOT.(LINK.GT.1)) GO TO 540
      NTIMES = NTIMES + 1
      IF (.NOT.(NTIMES.GT.NOPT)) GO TO 500
      MODE = 4
      RETURN
  500 KEY = PRGOPT(LAST+1)
      IF (KEY.EQ.1) COV = PRGOPT(LAST+2).NE.ZERO
      IF (.NOT.(KEY.EQ.2 .AND. PRGOPT(LAST+2).NE.ZERO)) GO TO 520
      DO 510 J=1,N
        T = SNRM2(M,W(1,J),1)
        IF (T.NE.ZERO) T = ONE/T
        L = N1 + J
        WS(L-1) = T
  510 CONTINUE
  520 IF (KEY.EQ.3) CALL SCOPY(N, PRGOPT(LAST+2), 1, WS(N1), 1)
      IF (KEY.EQ.4) TAU = AMAX1(SRELPR,PRGOPT(LAST+2))
      NEXT = PRGOPT(LINK)
      IF (.NOT.(NEXT.LE.0 .OR. NEXT.GT.NLINK)) GO TO 530
      MODE = 4
      RETURN
  530 LAST = LINK
      LINK = NEXT
      GO TO 490
  540 DO 550 J=1,N
        L = N1 + J
        CALL SSCAL(M, WS(L-1), W(1,J), 1)
  550 CONTINUE
      GO TO 90
      END
      SUBROUTINE LSI(W, MDW, MA, MG, N, PRGOPT, X, RNORM, MODE, WS, IP)
C
C     THIS IS A COMPANION SUBPROGRAM TO LSEI( ).
C     THE DOCUMENTATION FOR LSEI( ) HAS MORE COMPLETE
C     USAGE INSTRUCTIONS.
C     WRITTEN BY R. J. HANSON, SLA.
C
C     SOLVE..
C              AX = B,  A  MA BY N  (LEAST SQUARES EQUATIONS)
C     SUBJECT TO..
C
C              GX.GE.H, G  MG BY N  (INEQUALITY CONSTRAINTS)
C
C     INPUT..
C
C      W(*,*) CONTAINS  (A B) IN ROWS 1,...,MA+MG, COLS 1,...,N+1.
C                       (G H)
C
C     MDW,MA,MG,N
C              CONTAIN (RESP) VAR. DIMENSION OF W(*,*),
C              AND MATRIX DIMENSIONS.
C
C     PRGOPT(*),
C              PROGRAM OPTION VECTOR.
C
C     OUTPUT..
C
C      X(*),RNORM
C
C              SOLUTION VECTOR(UNLESS MODE=2), LENGTH OF AX-B.
C
C      MODE
C              =0   INEQUALITY CONSTRAINTS ARE COMPATIBLE.
C              =2   INEQUALITY CONSTRAINTS CONTRADICTORY.
C
C      WS(*),
C              WORKING STORAGE OF DIMENSION K+N+(MG+2)*(N+7),
C              WHERE K=MAX(MA+MG,N).
C      IP(MG+2*N+1)
C              INTEGER WORKING STORAGE
C
C     SUBROUTINES CALLED
C
C     LPDP          THIS SUBPROGRAM MINIMIZES A SUM OF SQUARES
C                   OF UNKNOWNS SUBJECT TO LINEAR INEQUALITY
C                   CONSTRAINTS.  PART OF THIS PACKAGE.
C
C     SDOT,SSCAL    SUBROUTINES FROM THE BLAS PACKAGE.
C     SAXPY,SASUM,  SEE TRANS. MATH SOFTWARE (5), P. 308.
C     SCOPY,SSWAP
C
C     HFTI          SOLVES AN UNCONSTRAINED LINEAR LEAST SQUARES
C                   PROBLEM.
C
C     H12           SUBROUTINE TO CONSTRUCT AND APPLY A HOUSEHOLDER
C                   TRANSFORMATION.
C
C     SPMPAR        FUNCTION TO COMPUTE THE RELATIVE MACHINE
C                   PRECISION.
C
      REAL W(MDW,*), PRGOPT(*), X(*), WS(*), RNRM(1), OPT(7)
      INTEGER IP(*)
      LOGICAL COV
C
      DATA ZERO /0.E0/, ONE /1.E0/, HALF /0.5E0/
C
      SRELPR = SPMPAR(1)
      MODE = 0
      RNORM = ZERO
      M = MA + MG
      NP1 = N + 1
      KRANK = 0
      IF (N.LE.0 .OR. M.LE.0) GO TO 70
C
C     PROCESS-OPTION-VECTOR
C
      GO TO 500
C
C     COMPUTE MATRIX NORM OF LEAST SQUARES EQUAS.
C
   40 ANORM = ZERO
      DO 50 J = 1,N
        ANORM = AMAX1(ANORM,SASUM(MA,W(1,J),1))
   50 CONTINUE
C
C     SET TOL FOR HFTI( ) RANK TEST.
      TAU = TOL*ANORM
C
C     COMPUTE HOUSEHOLDER ORTHOGONAL DECOMP OF MATRIX.
C
      IF (N.GT.0) WS(1) = ZERO
      CALL SCOPY(N, WS, 0, WS, 1)
      CALL SCOPY(MA, W(1,NP1), 1, WS, 1)
      K = MAX0(M,N)
      MINMAN = MIN0(MA,N)
      N1 = K + 1
      N2 = N1 + N
      CALL HFTI(W, MDW, MA, N, WS, 1, 1, TAU, KRANK, RNRM, WS(N2),
     * WS(N1), IP)
      RNORM = RNRM(1)
      FAC = ONE
      GAM = MA - KRANK
      IF (KRANK .LT. MA) FAC = RNORM**2/GAM
      GO TO 80
C
C     REDUCE-TO-LPDP-AND-SOLVE
C
   70 IP(1) = KRANK
      IP(2) = N + MAX0(M,N) + (MG+2)*(N+7)
      RETURN
C
C     TO REDUCE-TO-LPDP-AND-SOLVE
C
   80 MAP1 = MA + 1
C
C     COMPUTE INEQ. RT-HAND SIDE FOR LPDP.
C
      IF (.NOT.(MA.LT.M)) GO TO 260
      IF (.NOT.(MINMAN.GT.0)) GO TO 160
      DO 90 I = MAP1,M
        W(I,NP1) = W(I,NP1) - SDOT(N,W(I,1),MDW,WS,1)
   90 CONTINUE
      DO 100 I = 1,MINMAN
        J = IP(I)
C
C     APPLY PERMUTATIONS TO COLS OF INEQ. CONSTRAINT MATRIX.
        CALL SSWAP(MG, W(MAP1,I), 1, W(MAP1,J), 1)
  100 CONTINUE
C
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO CONSTRAINT MATRIX.
C
      IF (.NOT.(0.LT.KRANK .AND. KRANK.LT.N)) GO TO 120
      DO 110 II = 1,KRANK
        I = KRANK + 1 - II
        L = N1 + I
        CALL H12(2, I, KRANK+1, N, W(I,1), MDW, WS(L-1), W(MAP1,1),
     *   MDW, 1, MG)
  110 CONTINUE
C
C     COMPUTE PERMUTED INEQ. CONSTR. MATRIX TIMES R-INVERSE.
C
  120 DO 150 I=MAP1,M
        IF (.NOT.(0.LT.KRANK)) GO TO 150
        DO 130 J=1,KRANK
          W(I,J) = (W(I,J)-SDOT(J-1,W(1,J),1,W(I,1),MDW))/W(J,J)
  130   CONTINUE
  150 CONTINUE
C
C     SOLVE THE REDUCED PROBLEM WITH LPDP ALGORITHM,
C     THE LEAST PROJECTED DISTANCE PROBLEM.
C
  160 CALL LPDP(W(MAP1,1), MDW, MG, KRANK, N-KRANK, OPT, X, XNORM,
     * MDLPDP, WS(N2), IP(N+1))
      IF (MDLPDP .NE. 1) GO TO 240
      IF (.NOT.(KRANK.GT.0)) GO TO 180
C
C     COMPUTE SOLN IN ORIGINAL COORDINATES.
C
      DO 170 II = 1,KRANK
        I = KRANK + 1 - II
        X(I) = (X(I)-SDOT(II-1,W(I,I+1),MDW,X(I+1),1))/W(I,I)
  170 CONTINUE
C
C     APPLY HOUSEHOLDER TRANS. TO SOLN VECTOR.
C
  180 IF (.NOT.(0.LT.KRANK .AND. KRANK.LT.N)) GO TO 200
      DO 190 I = 1,KRANK
        L = N1 + I
        CALL H12(2, I, KRANK+1, N, W(I,1), MDW, WS(L-1), X, 1, 1, 1)
  190 CONTINUE
  200 IF (.NOT.(MINMAN.GT.0)) GO TO 270
C
C     REPERMUTE VARIABLES TO THEIR INPUT ORDER.
      DO 210 II=1,MINMAN
        I = MINMAN + 1 - II
        J = IP(I)
        CALL SSWAP(1, X(I), 1, X(J), 1)
  210 CONTINUE
C
C     VARIABLES ARE NOW IN ORIG. COORDINATES.
C     ADD SOLN OF UNSCONSTRAINED PROB.
      DO 220 I = 1,N
        X(I) = X(I) + WS(I)
  220 CONTINUE
C
C     COMPUTE THE RESIDUAL VECTOR NORM.
      RNORM = SQRT(RNORM**2+XNORM**2)
      GO TO 270
  240 MODE = 2
      GO TO 270
  260 CALL SCOPY(N, WS, 1, X, 1)
  270 IF (.NOT.(COV .AND. KRANK.GT.0)) GO TO 70
C
C     COMPUTE COVARIANCE MATRIX BASED ON THE ORTHOGONAL DECOMP.
C     FROM HFTI( ).
C
      KRM1 = KRANK - 1
      KRP1 = KRANK + 1
C
C     COPY DIAG. TERMS TO WORKING ARRAY.
      CALL SCOPY(KRANK, W, MDW+1, WS(N2), 1)
C
C     RECIPROCATE DIAG. TERMS.
      DO 280 J = 1,KRANK
        W(J,J) = ONE/W(J,J)
  280 CONTINUE
      IF (.NOT.(KRANK.GT.1)) GO TO 310
C
C     INVERT THE UPPER TRIANGULAR QR FACTOR ON ITSELF.
      DO 300 I=1,KRM1
        IP1 = I + 1
        DO 290 J=IP1,KRANK
          W(I,J) = -SDOT(J-I,W(I,I),MDW,W(I,J),1)*W(J,J)
  290   CONTINUE
  300 CONTINUE
C
C     COMPUTE THE INVERTED FACTOR TIMES ITS TRANSPOSE.
  310 DO 330 I=1,KRANK
        DO 320 J=I,KRANK
          W(I,J) = SDOT(KRANK+1-J,W(I,J),MDW,W(J,J),MDW)
  320   CONTINUE
  330 CONTINUE
      IF (.NOT.(KRANK.LT.N)) GO TO 450
C
C     ZERO OUT LOWER TRAPEZOIDAL PART.
C     COPY UPPER TRI. TO LOWER TRI. PART.
      DO 340 J=1,KRANK
        CALL SCOPY(J, W(1,J), 1, W(J,1), MDW)
  340 CONTINUE
      DO 350 I=KRP1,N
        W(I,1) = ZERO
        CALL SCOPY(I, W(I,1), 0, W(I,1), MDW)
  350 CONTINUE
C
C     APPLY RIGHT SIDE TRANSFORMATIONS TO LOWER TRI.
      N3 = N2 + KRP1
      DO 430 I=1,KRANK
        L = N1 + I
        K = N2 + I
        RB = WS(L-1)*WS(K-1)
        IF (.NOT.(RB.LT.ZERO)) GO TO 420
C
C     IF RB.GE.ZERO, TRANSFORMATION CAN BE REGARDED AS ZERO.
        RB = ONE/RB
C
C     STORE UNSCALED RANK-ONE HOUSEHOLDER UPDATE IN WORK ARRAY.
        WS(N3) = ZERO
        CALL SCOPY(N, WS(N3), 0, WS(N3), 1)
        L = N1 + I
        K = N3 + I
        WS(K-1) = WS(L-1)
        DO 360 J=KRP1,N
          K = N3 + J
          WS(K-1) = W(I,J)
  360   CONTINUE
        DO 370 J=1,N
          L = N3 + I
          K = N3 + J
          WS(J) = SDOT(J-I,W(J,I),MDW,WS(L-1),1) + SDOT(N-J+1,W(J,J),1,
     *     WS(K-1),1)
          WS(J) = WS(J)*RB
  370   CONTINUE
        L = N3 + I
        GAM = SDOT(N-I+1,WS(L-1),1,WS(I),1)*RB
        GAM = GAM*HALF
        CALL SAXPY(N-I+1, GAM, WS(L-1), 1, WS(I), 1)
        DO 410 J=I,N
          IF (.NOT.(I.GT.1)) GO TO 390
          IM1 = I - 1
          K = N3 + J
          DO 380 L=1,IM1
            W(J,L) = W(J,L) + WS(K-1)*WS(L)
  380     CONTINUE
  390     K = N3 + J
          DO 400 L=I,J
            IL = N3 + L
            W(J,L) = W(J,L) + WS(J)*WS(IL-1) + WS(L)*WS(K-1)
  400     CONTINUE
  410   CONTINUE
  420   CONTINUE
  430 CONTINUE
C
C     COPY LOWER TRI. TO UPPER TRI. TO SYMMETRIZE THE COVARIANCE MATRIX.
C
      DO 440 I = 1,N
        CALL SCOPY(I, W(I,1), MDW, W(1,I), 1)
  440 CONTINUE
C
C     REPERMUTE ROWS AND COLS.
C
  450 DO 470 II = 1,MINMAN
        I = MINMAN + 1 - II
        K = IP(I)
        IF (.NOT.(I.NE.K)) GO TO 470
        CALL SSWAP(1, W(I,I), 1, W(K,K), 1)
        CALL SSWAP(I-1, W(1,I), 1, W(1,K), 1)
        CALL SSWAP(K-I-1, W(I,I+1), MDW, W(I+1,K), 1)
        CALL SSWAP(N-K, W(I,K+1), MDW, W(K,K+1), MDW)
  470 CONTINUE
C
C     PUT IN NORMALIZED RESIDUAL SUM OF SQUARES SCALE FACTOR
C     AND SYMMETRIZE THE RESULTING COVARIANCE MARIX.
C
      DO 480 J = 1,N
        CALL SSCAL(J, FAC, W(1,J), 1)
        CALL SCOPY(J, W(1,J), 1, W(J,1), MDW)
  480 CONTINUE
      GO TO 70
C
C     TO PROCESS-OPTION-VECTOR
C
C     THE NOMINAL TOLERANCE USED IN THE CODE,
  500 TOL = SQRT(SRELPR)
      COV = .FALSE.
      LAST = 1
      LINK = PRGOPT(1)
      KEY8 = 0
      KEY9 = 0
  510    IF (.NOT.(LINK.GT.1)) GO TO 540
         KEY = PRGOPT(LAST+1)
         IF (KEY .EQ. 1) COV = PRGOPT(LAST+2).NE.ZERO
         IF (KEY .EQ. 5) TOL = AMAX1(SRELPR,PRGOPT(LAST+2))
         IF (KEY .NE. 8) GO TO 520
            KEY8 = 1
            EPS = PRGOPT(LAST+2)
            GO TO 530
  520    IF (KEY .NE. 9) GO TO 530
            KEY9 = 1
            BLOWUP = PRGOPT(LAST+2)
  530    NEXT = PRGOPT(LINK)
         LAST = LINK
         LINK = NEXT
         GO TO 510
C
C     PREPARE THE OPTION VECTOR FOR WNNLS
C
  540 J = 1
      IF (KEY8 .EQ. 0) GO TO 550
         OPT(1) = 4.0
         OPT(2) = 8.0
         OPT(3) = EPS
         J = 4
  550 IF (KEY9 .EQ. 0) GO TO 560
         OPT(J) = J + 3
         OPT(J+1) = 9.0
         OPT(J+2) = BLOWUP
         J = J + 3
  560 OPT(J) = 1.0
      GO TO 40
      END
      SUBROUTINE LPDP(A, MDA, M, N1, N2, PRGOPT, X, WNORM, MODE, WS, IS)
C
C     DIMENSION A(MDA,N+1),PRGOPT(*),X(N),WS((M+2)*(N+7)),IS(M+N+1),
C     WHERE N=N1+N2.  THIS IS A SLIGHT OVERESTIMATE FOR WS(*).
C
C     WRITTEN BY R. J. HANSON AND K. H. HASKELL, SANDIA LABS
C
C     DETERMINE AN N1-VECTOR W, AND
C               AN N2-VECTOR Z
C     WHICH MINIMIZES THE EUCLIDEAN LENGTH OF W
C     SUBJECT TO G*W+H*Z .GE. Y.
C     THIS IS THE LEAST PROJECTED DISTANCE PROBLEM, LPDP.
C     THE MATRICES G AND H ARE OF RESPECTIVE
C     DIMENSIONS M BY N1 AND M BY N2.
C
C     CALLED BY SUBPROGRAM LSI( ).
C
C     THE MATRIX
C                (G H Y)
C
C     OCCUPIES ROWS 1,...,M AND COLS 1,...,N1+N2+1 OF A(*,*).
C
C     THE SOLUTION (W) IS RETURNED IN X(*).
C                  (Z)
C
C     THE VALUE OF MODE INDICATES THE STATUS OF
C     THE COMPUTATION AFTER RETURNING TO THE USER.
C
C          MODE=1  THE SOLUTION WAS SUCCESSFULLY OBTAINED.
C
C          MODE=2  THE INEQUALITIES ARE INCONSISTENT.
C
C     SUBROUTINES CALLED
C
C     WNNLS         SOLVES A NONNEGATIVELY CONSTRAINED LINEAR LEAST
C                   SQUARES PROBLEM WITH LINEAR EQUALITY CONSTRAINTS.
C                   PART OF THIS PACKAGE.
C
C     SDOT,SCOPY    SUBROUTINES FROM THE BLAS PACKAGE.
C     SSCAL,SNRM2   SEE TRANS. MATH SOFTWARE (5), P. 308.
C
      DIMENSION A(MDA,*), PRGOPT(*), X(*), WS(*), IS(*)
      DATA ZERO, ONE /0.E0,1.E0/, FAC /0.1E0/
C
      N = N1 + N2
      MODE = 1
      IF (.NOT.(M.LE.0)) GO TO 20
      IF (.NOT.(N.GT.0)) GO TO 10
      X(1) = ZERO
      CALL SCOPY(N, X, 0, X, 1)
   10 WNORM = ZERO
      RETURN
   20 NP1 = N + 1
C
C     SCALE NONZERO ROWS OF INEQUALITY MATRIX TO HAVE LENGTH ONE.
C
      DO 40 I = 1,M
         SC = SNRM2(N,A(I,1),MDA)
         IF (SC .EQ. ZERO) GO TO 40
         SC = ONE/SC
         CALL SSCAL(NP1, SC, A(I,1), MDA)
   40 CONTINUE
C
C     SCALE RT.-SIDE VECTOR TO HAVE LENGTH ONE (OR ZERO).
      YNORM = SNRM2(M,A(1,NP1),1)
      IF (YNORM .EQ. ZERO) GO TO 50
      SC = ONE/YNORM
      CALL SSCAL(M, SC, A(1,NP1), 1)
C
C     SCALE COLS OF MATRIX H.
   50 J = N1 + 1
   60 IF (J .GT. N) GO TO 70
      SC = SNRM2(M,A(1,J),1)
      IF (SC .NE. ZERO) SC = ONE/SC
      CALL SSCAL(M, SC, A(1,J), 1)
      X(J) = SC
      J = J + 1
      GO TO 60
   70 IF (.NOT.(N1.GT.0)) GO TO 130
C
C     COPY TRANSPOSE OF (H G Y) TO WORK ARRAY WS(*).
      IW = 0
      DO 80 I=1,M
C
C     MOVE COL OF TRANSPOSE OF H INTO WORK ARRAY.
         CALL SCOPY(N2, A(I,N1+1), MDA, WS(IW+1), 1)
         IW = IW + N2
C
C     MOVE COL OF TRANSPOSE OF G INTO WORK ARRAY.
         CALL SCOPY(N1, A(I,1), MDA, WS(IW+1), 1)
         IW = IW + N1
C
C     MOVE COMPONENT OF VECTOR Y INTO WORK ARRAY.
         WS(IW+1) = A(I,NP1)
         IW = IW + 1
   80 CONTINUE
      WS(IW+1) = ZERO
      CALL SCOPY(N, WS(IW+1), 0, WS(IW+1), 1)
      IW = IW + N
      WS(IW+1) = ONE
      IW = IW + 1
C
C     SOLVE EU=F SUBJECT TO (TRANSPOSE OF H)U=0, U.GE.0.  THE
C     MATRIX E = TRANSPOSE OF (G Y), AND THE (N+1)-VECTOR
C     F = TRANSPOSE OF (0,...,0,1).
      IX = IW + 1
      IW = IW + M
      CALL WNNLS(WS, NP1, N2, NP1-N2, M, 0, PRGOPT, WS(IX), RNORM,
     * MODEW, IS, WS(IW+1))
C
C     COMPUTE THE COMPONENTS OF THE SOLN DENOTED ABOVE BY W.
      SC = ONE - SDOT(M,A(1,NP1),1,WS(IX),1)
      IF (.NOT.(ONE+FAC*ABS(SC).NE.ONE .AND. RNORM.GT.ZERO)) GO TO 110
      SC = ONE/SC
      DO 90 J=1,N1
         X(J) = SC*SDOT(M,A(1,J),1,WS(IX),1)
   90 CONTINUE
C
C     COMPUTE THE VECTOR Q=Y-GW.  OVERWRITE Y WITH THIS VECTOR.
      DO 100 I=1,M
         A(I,NP1) = A(I,NP1) - SDOT(N1,A(I,1),MDA,X,1)
  100 CONTINUE
      GO TO 130
  110 MODE = 2
      RETURN
  130 IF (.NOT.(N2.GT.0)) GO TO 180
C
C     COPY TRANSPOSE OF (H Q) TO WORK ARRAY WS(*).
      IW = 0
      DO 140 I=1,M
         CALL SCOPY(N2, A(I,N1+1), MDA, WS(IW+1), 1)
         IW = IW + N2
         WS(IW+1) = A(I,NP1)
         IW = IW + 1
  140 CONTINUE
      WS(IW+1) = ZERO
      CALL SCOPY(N2, WS(IW+1), 0, WS(IW+1), 1)
      IW = IW + N2
      WS(IW+1) = ONE
      IW = IW + 1
      IX = IW + 1
      IW = IW + M
C
C     SOLVE RV=S SUBJECT TO V.GE.0.  THE MATRIX R =(TRANSPOSE
C     OF (H Q)), WHERE Q=Y-GW.  THE (N2+1)-VECTOR S =(TRANSPOSE
C     OF (0,...,0,1)).
C
      CALL WNNLS(WS, N2+1, 0, N2+1, M, 0, PRGOPT, WS(IX), RNORM, MODEW,
     * IS, WS(IW+1))
C
C     COMPUTE THE COMPONENTS OF THE SOLN DENOTED ABOVE BY Z.
C
      SC = ONE - SDOT(M,A(1,NP1),1,WS(IX),1)
      IF (.NOT.(ONE+FAC*ABS(SC).NE.ONE .AND. RNORM.GT.ZERO)) GO TO 160
      SC = ONE/SC
      DO 150 J=1,N2
         L = N1 + J
         X(L) = SC*SDOT(M,A(1,L),1,WS(IX),1)*X(L)
  150 CONTINUE
      GO TO 180
  160 MODE = 2
      RETURN
C
C     ACCOUNT FOR SCALING OF RT.-SIDE VECTOR IN SOLUTION.
  180 CALL SSCAL(N, YNORM, X, 1)
      WNORM = SNRM2(N1,X,1)
      RETURN
      END
      SUBROUTINE WNNLS(W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE,
     * IWORK, WORK)
C
C     DIMENSION W(MDW,N+1),PRGOPT(*),X(N),IWORK(M+N),WORK(M+5*N)
C
C     ABSTRACT
C
C     THIS SUBPROGRAM SOLVES A LINEARLY CONSTRAINED LEAST SQUARES
C     PROBLEM.  SUPPOSE THERE ARE GIVEN MATRICES E AND A OF
C     RESPECTIVE DIMENSIONS ME BY N AND MA BY N, AND VECTORS F
C     AND B OF RESPECTIVE LENGTHS ME AND MA.  THIS SUBROUTINE
C     SOLVES THE PROBLEM
C
C               EX = F, (EQUATIONS TO BE EXACTLY SATISFIED)
C
C               AX = B, (EQUATIONS TO BE APPROXIMATELY SATISFIED,
C                        IN THE LEAST SQUARES SENSE)
C
C               SUBJECT TO COMPONENTS L+1,...,N NONNEGATIVE
C
C     ANY VALUES ME.GE.0, MA.GE.0 AND 0.LE. L .LE.N ARE PERMITTED.
C
C     THE PROBLEM IS REPOSED AS PROBLEM WNNLS
C
C               (WT*E)X = (WT*F)
C               (   A)    (   B), (LEAST SQUARES)
C               SUBJECT TO COMPONENTS L+1,...,N NONNEGATIVE.
C
C     THE SUBPROGRAM CHOOSES THE HEAVY WEIGHT (OR PENALTY PARAMETER) WT.
C
C     THE PARAMETERS FOR WNNLS ARE
C
C     INPUT..
C
C     W(*,*),MDW,  THE ARRAY W(*,*) IS DOUBLE SUBSCRIPTED WITH FIRST
C     ME,MA,N,L    DIMENSIONING PARAMETER EQUAL TO MDW.  FOR THIS
C                  DISCUSSION LET US CALL M = ME + MA.  THEN MDW
C                  MUST SATISFY MDW.GE.M.  THE CONDITION MDW.LT.M
C                  IS AN ERROR.
C
C                  THE ARRAY W(*,*) CONTAINS THE MATRICES AND VECTORS
C
C                       (E  F)
C                       (A  B)
C
C                  IN ROWS AND COLUMNS 1,...,M AND 1,...,N+1
C                  RESPECTIVELY.  COLUMNS 1,...,L CORRESPOND TO
C                  UNCONSTRAINED VARIABLES X(1),...,X(L).  THE
C                  REMAINING VARIABLES ARE CONSTRAINED TO BE
C                  NONNEGATIVE.  THE CONDITION L.LT.0 .OR. L.GT.N IS
C                  AN ERROR.
C
C     PRGOPT(*)    THIS ARRAY IS THE OPTION VECTOR.
C                  IF THE USER IS SATISFIED WITH THE NOMINAL
C                  SUBPROGRAM FEATURES SET
C
C                  PRGOPT(1)=1 (OR PRGOPT(1)=1.0)
C
C                  OTHERWISE PRGOPT(*) IS A LINKED LIST CONSISTING OF
C                  GROUPS OF DATA OF THE FOLLOWING FORM
C
C                  LINK
C                  KEY
C                  DATA SET
C
C                  THE PARAMETERS LINK AND KEY ARE EACH ONE WORD.
C                  THE DATA SET CAN BE COMPRISED OF SEVERAL WORDS.
C                  THE NUMBER OF ITEMS DEPENDS ON THE VALUE OF KEY.
C                  THE VALUE OF LINK POINTS TO THE FIRST
C                  ENTRY OF THE NEXT GROUP OF DATA WITHIN
C                  PRGOPT(*).  THE EXCEPTION IS WHEN THERE ARE
C                  NO MORE OPTIONS TO CHANGE.  IN THAT
C                  CASE LINK=1 AND THE VALUES KEY AND DATA SET
C                  ARE NOT REFERENCED. THE GENERAL LAYOUT OF
C                  PRGOPT(*) IS AS FOLLOWS.
C
C               ...PRGOPT(1)=LINK1 (LINK TO FIRST ENTRY OF NEXT GROUP)
C               .  PRGOPT(2)=KEY1 (KEY TO THE OPTION CHANGE)
C               .  PRGOPT(3)=DATA VALUE (DATA VALUE FOR THIS CHANGE)
C               .       .
C               .       .
C               .       .
C               ...PRGOPT(LINK1)=LINK2 (LINK TO THE FIRST ENTRY OF
C               .                       NEXT GROUP)
C               .  PRGOPT(LINK1+1)=KEY2 (KEY TO THE OPTION CHANGE)
C               .  PRGOPT(LINK1+2)=DATA VALUE
C               ...     .
C               .       .
C               .       .
C               ...PRGOPT(LINK)=1 (NO MORE OPTIONS TO CHANGE)
C
C                  VALUES OF LINK THAT ARE NONPOSITIVE ARE ERRORS.
C                  A VALUE OF LINK.GT.NLINK=100000 IS ALSO AN ERROR.
C                  THIS HELPS PREVENT USING INVALID BUT POSITIVE
C                  VALUES OF LINK THAT WILL PROBABLY EXTEND
C                  BEYOND THE PROGRAM LIMITS OF PRGOPT(*).
C                  UNRECOGNIZED VALUES OF KEY ARE IGNORED.  THE
C                  ORDER OF THE OPTIONS IS ARBITRARY AND ANY NUMBER
C                  OF OPTIONS CAN BE CHANGED WITH THE FOLLOWING
C                  RESTRICTION.  TO PREVENT CYCLING IN THE
C                  PROCESSING OF THE OPTION ARRAY A COUNT OF THE
C                  NUMBER OF OPTIONS CHANGED IS MAINTAINED.
C                  WHENEVER THIS COUNT EXCEEDS NOPT=1000 THE
C                  ROUTINE TERMINATES.
C
C                  OPTIONS..
C
C                  KEY=6
C                         SCALE THE NONZERO COLUMNS OF THE
C                  ENTIRE DATA MATRIX
C                  (E)
C                  (A)
C                  TO HAVE LENGTH ONE.  THE DATA SET FOR
C                  THIS OPTION IS A SINGLE VALUE.  IT MUST
C                  BE NONZERO IF UNIT LENGTH COLUMN SCALING IS
C                  DESIRED.
C
C                  KEY=7
C                         SCALE COLUMNS OF THE ENTIRE DATA MATRIX
C                  (E)
C                  (A)
C                  WITH A USER-PROVIDED DIAGONAL MATRIX.
C                  THE DATA SET FOR THIS OPTION CONSISTS
C                  OF THE N DIAGONAL SCALING FACTORS, ONE FOR
C                  EACH MATRIX COLUMN.
C
C                  KEY=8
C                         CHANGE THE RANK DETERMINATION TOLERANCE FROM
C                  THE NOMINAL VALUE OF SQRT(EPS).  THIS QUANTITY CAN
C                  BE NO SMALLER THAN EPS, THE ARITHMETIC-
C                  STORAGE PRECISION.  THE QUANTITY USED
C                  HERE IS INTERNALLY RESTRICTED TO BE AT
C                  LEAST EPS.  THE DATA SET FOR THIS OPTION
C                  IS THE NEW TOLERANCE.
C
C                  KEY=9
C                         CHANGE THE BLOW-UP PARAMETER FROM THE
C                  NOMINAL VALUE OF SQRT(EPS).  THE RECIPROCAL OF
C                  THIS PARAMETER IS USED IN REJECTING SOLUTION
C                  COMPONENTS AS TOO LARGE WHEN A VARIABLE IS
C                  FIRST BROUGHT INTO THE ACTIVE SET.  TOO LARGE
C                  MEANS THAT THE PROPOSED COMPONENT TIMES THE
C                  RECIPROCAL OF THE PARAMETERIS NOT LESS THAN
C                  THE RATIO OF THE NORMS OF THE RIGHT-SIDE
C                  VECTOR AND THE DATA MATRIX.
C                  THIS PARAMETER CAN BE NO SMALLER THAN EPS,
C                  THE ARITHMETIC-STORAGE PRECISION.
C
C                  FOR EXAMPLE, SUPPOSE WE WANT TO PROVIDE
C                  A DIAGONAL MATRIX TO SCALE THE PROBLEM
C                  MATRIX AND CHANGE THE TOLERANCE USED FOR
C                  DETERMINING LINEAR DEPENDENCE OF DROPPED COL
C                  VECTORS.  FOR THESE OPTIONS THE DIMENSIONS OF
C                  PRGOPT(*) MUST BE AT LEAST N+6.  THE FORTRAN
C                  STATEMENTS DEFINING THESE OPTIONS WOULD
C                  BE AS FOLLOWS.
C
C                  PRGOPT(1)=N+3 (LINK TO ENTRY N+3 IN PRGOPT(*))
C                  PRGOPT(2)=7 (USER-PROVIDED SCALING KEY)
C
C                  CALL SCOPY(N,D,1,PRGOPT(3),1) (COPY THE N
C                  SCALING FACTORS FROM A USER ARRAY CALLED D(*)
C                  INTO PRGOPT(3)-PRGOPT(N+2))
C
C                  PRGOPT(N+3)=N+6 (LINK TO ENTRY N+6 OF PRGOPT(*))
C                  PRGOPT(N+4)=8 (LINEAR DEPENDENCE TOLERANCE KEY)
C                  PRGOPT(N+5)=... (NEW VALUE OF THE TOLERANCE)
C
C                  PRGOPT(N+6)=1 (NO MORE OPTIONS TO CHANGE)
C
C     OUTPUT..
C
C     X(*)         AN ARRAY DIMENSIONED AT LEAST N, WHICH WILL
C                  CONTAIN THE N COMPONENTS OF THE SOLUTION VECTOR
C                  ON OUTPUT.
C
C     RNORM        THE RESIDUAL NORM OF THE SOLUTION.  THE VALUE OF
C                  RNORM CONTAINS THE RESIDUAL VECTOR LENGTH OF THE
C                  EQUALITY CONSTRAINTS AND LEAST SQUARES EQUATIONS.
C
C     MODE         THE VALUE OF MODE INDICATES THE SUCCESS OR FAILURE
C                  OF THE SUBPROGRAM.
C
C                  MODE = 0  SUBPROGRAM COMPLETED SUCCESSFULLY.
C
C                       = 1  MAX. NUMBER OF ITERATIONS (EQUAL TO
C                            3*(N-L)) EXCEEDED. NEARLY ALL PROBLEMS
C                            SHOULD COMPLETE IN FEWER THAN THIS
C                            NUMBER OF ITERATIONS. AN APPROXIMATE
C                            SOLUTION AND ITS CORRESPONDING RESIDUAL
C                            VECTOR LENGTH ARE IN X(*) AND RNORM.
C
C                       = 2  USAGE ERROR OCCURRED.  EITHER
C                            MDW .LT. ME + MA, L .LT. 0, L .GT. N,
C                            OR THE OPTION VECTOR PRGOPT(*) IS
C                            NOT PROPERLY DEFINED.
C
C     USER-DESIGNATED
C     WORKING ARRAYS..
C
C     WORK(*)      A WORKING ARRAY OF LENGTH AT LEAST
C                  M + 5*N.
C
C     IWORK(*)     AN INTEGER-VALUED WORKING ARRAY OF LENGTH AT LEAST
C                  M+N.
C
C     WRITTEN BY KAREN H. HASKELL, SANDIA LABORATORIES,
C     AND R.J. HANSON, SANDIA LABORATORIES.
C     REVISED OCT. 1, 1989.
C
C
C     SUBROUTINES CALLED BY WNNLS( )
C
C     WNLSM         COMPANION SUBROUTINE TO WNNLS( ), WHERE
C                   MOST OF THE COMPUTATION TAKES PLACE.
C
C
C     REFERENCES
C
C     1. SOLVING LEAST SQUARES PROBLEMS, BY C.L. LAWSON
C        AND R.J. HANSON.  PRENTICE-HALL, INC. (1974).
C
C     2. BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE, BY
C        C.L. LAWSON, R.J. HANSON, D.R. KINCAID, AND F.T. KROGH.
C        TOMS, V. 5, NO. 3, P. 308.  ALSO AVAILABLE AS
C        SANDIA TECHNICAL REPORT NO. SAND77-0898.
C
C     3. AN ALGORITHM FOR LINEAR LEAST SQUARES WITH EQUALITY
C        AND NONNEGATIVITY CONSTRAINTS, BY K.H. HASKELL AND
C        R.J. HANSON.  AVAILABLE AS SANDIA TECHNICAL REPORT NO.
C        SAND77-0552, AND MATH. PROGRAMMING, VOL. 21, (1981), P. 98-118.
C
      REAL W(MDW,*), PRGOPT(*), X(N), WORK(*)
      INTEGER IWORK(*)
C
      MODE = 0
      IF (MA+ME .LE. 0 .OR. N .LE. 0) RETURN
      IF (.NOT.(MDW.LT.ME+MA)) GO TO 10
      MODE = 2
      RETURN
   10 IF (0.LE.L .AND. L.LE.N) GO TO 20
      MODE = 2
      RETURN
C
C     THE PURPOSE OF THIS SUBROUTINE IS TO BREAK UP THE ARRAYS
C     WORK(*) AND IWORK(*) INTO SEPARATE WORK ARRAYS
C     REQUIRED BY THE MAIN SUBROUTINE WNLSM( ).
C
   20 L1 = N + 1
      L2 = L1 + N
      L3 = L2 + ME + MA
      L4 = L3 + N
      L5 = L4 + N
C
      CALL WNLSM(W, MDW, ME, MA, N, L, PRGOPT, X, RNORM, MODE, IWORK,
     * IWORK(L1), WORK(1), WORK(L1), WORK(L2), WORK(L3), WORK(L4),
     * WORK(L5))
      RETURN
      END
      SUBROUTINE WNLSM(W, MDW, MME, MA, N, L, PRGOPT, X, RNORM, MODE,
     * IPIVOT, ITYPE, WD, H, SCALE, Z, TEMP, D)
C
C     THIS IS A COMPANION SUBPROGRAM TO WNNLS( ).
C     THE DOCUMENTATION FOR WNNLS( ) HAS MORE COMPLETE
C     USAGE INSTRUCTIONS.
C
C     WRITTEN BY KAREN H. HASKELL, SANDIA LABORATORIES,
C     WITH THE HELP OF R.J. HANSON, SANDIA LABORATORIES.
C
C     IN ADDITION TO THE PARAMETERS DISCUSSED IN THE PROLOGUE TO
C     SUBROUTINE WNNLS, THE FOLLOWING WORK ARRAYS ARE USED IN
C     SUBROUTINE WNLSM  (THEY ARE PASSED THROUGH THE CALLING
C     SEQUENCE FROM WNNLS FOR PURPOSES OF VARIABLE DIMENSIONING).
C     THEIR CONTENTS WILL IN GENERAL BE OF NO INTEREST TO THE USER.
C
C         IPIVOT(*)
C            AN ARRAY OF LENGTH N.  UPON COMPLETION IT CONTAINS THE
C         PIVOTING INFORMATION FOR THE COLS OF W(*,*).
C
C         ITYPE(*)
C            AN ARRAY OF LENGTH M WHICH IS USED TO KEEP TRACK
C         OF THE CLASSIFICATION OF THE EQUATIONS.  ITYPE(I)=0
C         DENOTES EQUATION I AS AN EQUALITY CONSTRAINT.
C         ITYPE(I)=1 DENOTES EQUATION I AS A LEAST SQUARES
C         EQUATION.
C
C         WD(*)
C            AN ARRAY OF LENGTH N.  UPON COMPLETION IT CONTAINS THE
C         DUAL SOLUTION VECTOR.
C
C         H(*)
C            AN ARRAY OF LENGTH N.  UPON COMPLETION IT CONTAINS THE
C         PIVOT SCALARS OF THE HOUSEHOLDER TRANSFORMATIONS PERFORMED
C         IN THE CASE KRANK.LT.L.
C
C         SCALE(*)
C            AN ARRAY OF LENGTH M WHICH IS USED BY THE SUBROUTINE
C         TO STORE THE DIAGONAL MATRIX OF WEIGHTS.
C         THESE ARE USED TO APPLY THE MODIFIED GIVENS
C         TRANSFORMATIONS.
C
C         Z(*),TEMP(*)
C            WORKING ARRAYS OF LENGTH N.
C
C         D(*)
C            AN ARRAY OF LENGTH N THAT CONTAINS THE
C         COLUMN SCALING FOR THE MATRIX (E).
C                                       (A)
C
C
      REAL W(MDW,*), X(*), WD(*), H(*), SCALE(*), DOPE(4)
      REAL Z(*), TEMP(*), PRGOPT(*), D(*), SPARAM(5)
      INTEGER IPIVOT(*), ITYPE(*), IDOPE(8)
      LOGICAL HITCON, FEASBL, DONE, POS
      DATA ZERO /0.E0/, ONE /1.E0/, TWO /2.E0/
C
C     INITIALIZE-VARIABLES
C
      GO TO 180
C
C     PERFORM INITIAL TRIANGULARIZATION IN THE SUBMATRIX
C     CORRESPONDING TO THE UNCONSTRAINED VARIABLES USING
C     THE PROCEDURE INITIALLY-TRIANGULARIZE.
C
   10 GO TO 280
C
C     PERFORM WNNLS ALGORITHM USING THE FOLLOWING STEPS.
C
C     UNTIL(DONE)
C
C        COMPUTE-SEARCH-DIRECTION-AND-FEASIBLE-POINT
C
C        WHEN (HITCON) ADD-CONSTRAINTS
C
C        ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
C
C        FIN
C
C     COMPUTE-FINAL-SOLUTION
C
   20 IF (DONE) GO TO 80
      GO TO 300
C
C     COMPUTE-SEARCH-DIRECTION-AND-FEASIBLE-POINT
C
   30 IF (.NOT.(HITCON)) GO TO 50
      GO TO 370
C
C     WHEN (HITCON) ADD-CONSTRAINTS
C
   50 GO TO 640
C
C     ELSE PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
C
   80 GO TO 1000
C
C     COMPUTE-FINAL-SOLUTION
C
  100 CONTINUE
C
C     TO PROCESS-OPTION-VECTOR
      FAC = 1.E-4
C
C     THE NOMINAL TOLERANCE USED IN THE CODE,
      TAU = SQRT(SRELPR)
C
C     THE NOMINAL BLOW-UP FACTOR USED IN THE CODE.
      BLOWUP = TAU
C
C     THE NOMINAL COLUMN SCALING USED IN THE CODE IS
C     THE IDENTITY SCALING.
      D(1) = ONE
      CALL SCOPY(N, D, 0, D, 1)
C
C     DEFINE BOUND FOR NUMBER OF OPTIONS TO CHANGE.
      NOPT = 1000
C
C     DEFINE BOUND FOR POSITIVE VALUE OF LINK.
      NLINK = 100000
      NTIMES = 0
      LAST = 1
      LINK = PRGOPT(1)
      IF (.NOT.(LINK.LE.0 .OR. LINK.GT.NLINK)) GO TO 110
      MODE = 2
      RETURN
  110 IF (.NOT.(LINK.GT.1)) GO TO 160
      NTIMES = NTIMES + 1
      IF (.NOT.(NTIMES.GT.NOPT)) GO TO 120
      MODE = 2
      RETURN
  120 KEY = PRGOPT(LAST+1)
      IF (.NOT.(KEY.EQ.6 .AND. PRGOPT(LAST+2).NE.ZERO)) GO TO 140
      DO 130 J=1,N
        T = SNRM2(M,W(1,J),1)
        IF (T.NE.ZERO) T = ONE/T
        D(J) = T
  130 CONTINUE
  140 IF (KEY.EQ.7) CALL SCOPY(N, PRGOPT(LAST+2), 1, D, 1)
      IF (KEY.EQ.8) TAU = AMAX1(SRELPR,PRGOPT(LAST+2))
      IF (KEY.EQ.9) BLOWUP = AMAX1(SRELPR,PRGOPT(LAST+2))
      NEXT = PRGOPT(LINK)
      IF (.NOT.(NEXT.LE.0 .OR. NEXT.GT.NLINK)) GO TO 150
      MODE = 2
      RETURN
  150 LAST = LINK
      LINK = NEXT
      GO TO 110
  160 DO 170 J=1,N
        CALL SSCAL(M, D(J), W(1,J), 1)
  170 CONTINUE
      GO TO 220
C
C     TO INITIALIZE-VARIABLES
C
C     SRELPR IS THE PRECISION FOR THE MACHINE BEING USED.
C
  180 SRELPR = SPMPAR(1)
C
      M = MA + MME
      ME = MME
      MEP1 = ME + 1
      GO TO 100
C
C     PROCESS-OPTION-VECTOR
  220 DONE = .FALSE.
      ITER = 0
      ITMAX = 3*(N-L)
      MODE = 0
      LP1 = L + 1
      NSOLN = L
      NSP1 = NSOLN + 1
      NP1 = N + 1
      NM1 = N - 1
      L1 = MIN0(M,L)
C
C     COMPUTE SCALE FACTOR TO APPLY TO EQUAL. CONSTRAINT EQUAS.
      DO 230 J=1,N
        WD(J) = SASUM(M,W(1,J),1)
  230 CONTINUE
      IMAX = ISAMAX(N,WD,1)
      EANORM = WD(IMAX)
      BNORM = SASUM(M,W(1,NP1),1)
      ALAMDA = EANORM/(SRELPR*FAC)
C
C     DEFINE SCALING DIAG MATRIX FOR MOD GIVENS USAGE AND
C     CLASSIFY EQUATION TYPES.
      ALSQ = ALAMDA**2
      DO 260 I=1,M
C
C     WHEN EQU I IS HEAVILY WEIGHTED ITYPE(I)=0, ELSE ITYPE(I)=1.
        IF (.NOT.(I.LE.ME)) GO TO 240
        T = ALSQ
        ITEMP = 0
        GO TO 250
  240   T = ONE
        ITEMP = 1
  250   SCALE(I) = T
        ITYPE(I) = ITEMP
  260 CONTINUE
C
C     SET THE SOLN VECTOR X(*) TO ZERO AND THE COL INTERCHANGE
C     MATRIX TO THE IDENTITY.
      X(1) = ZERO
      CALL SCOPY(N, X, 0, X, 1)
      DO 270 I=1,N
        IPIVOT(I) = I
  270 CONTINUE
      GO TO 10
  280 CONTINUE
C
C     TO INITIALLY-TRIANGULARIZE
C
C     SET FIRST L COMPS. OF DUAL VECTOR TO ZERO BECAUSE
C     THESE CORRESPOND TO THE UNCONSTRAINED VARIABLES.
      IF (.NOT.(L.GT.0)) GO TO 290
      WD(1) = ZERO
      CALL SCOPY(L, WD, 0, WD, 1)
C
C     THE ARRAYS IDOPE(*) AND DOPE(*) ARE USED TO PASS
C     INFORMATION TO WNLIT().  THIS WAS DONE TO AVOID
C     A LONG CALLING SEQUENCE OR THE USE OF COMMON.
  290 IDOPE(1) = ME
      IDOPE(2) = MEP1
      IDOPE(3) = 0
      IDOPE(4) = 1
      IDOPE(5) = NSOLN
      IDOPE(6) = 0
      IDOPE(7) = 1
      IDOPE(8) = L1
C
      DOPE(1) = ALSQ
      DOPE(2) = EANORM
      DOPE(3) = FAC
      DOPE(4) = TAU
      CALL WNLIT(W, MDW, M, N, L, IPIVOT, ITYPE, H, SCALE, RNORM,
     * IDOPE, DOPE, DONE)
      ME = IDOPE(1)
      MEP1 = IDOPE(2)
      KRANK = IDOPE(3)
      KRP1 = IDOPE(4)
      NSOLN = IDOPE(5)
      NIV = IDOPE(6)
      NIV1 = IDOPE(7)
      L1 = IDOPE(8)
      GO TO 20
  300 CONTINUE
C
C     TO COMPUTE-SEARCH-DIRECTION-AND-FEASIBLE-POINT
C
C     SOLVE THE TRIANGULAR SYSTEM OF CURRENTLY NON-ACTIVE
C     VARIABLES AND STORE THE SOLUTION IN Z(*).
C
C     SOLVE-SYSTEM
      ASSIGN 310 TO IGO958
      GO TO 1110
C
C     INCREMENT ITERATION COUNTER AND CHECK AGAINST MAX. NUMBER
C     OF ITERATIONS.
  310 ITER = ITER + 1
      IF (.NOT.(ITER.GT.ITMAX)) GO TO 320
      MODE = 1
      DONE = .TRUE.
C
C     CHECK TO SEE IF ANY CONSTRAINTS HAVE BECOME ACTIVE.
C     IF SO, CALCULATE AN INTERPOLATION FACTOR SO THAT ALL
C     ACTIVE CONSTRAINTS ARE REMOVED FROM THE BASIS.
  320 ALPHA = TWO
      HITCON = .FALSE.
      IF (.NOT.(L.LT.NSOLN)) GO TO 360
      DO 350 J=LP1,NSOLN
        ZZ = Z(J)
        IF (.NOT.(ZZ.LE.ZERO)) GO TO 350
        T = X(J)/(X(J)-ZZ)
        IF (.NOT.(T.LT.ALPHA)) GO TO 330
        ALPHA = T
        JCON = J
  330   HITCON = .TRUE.
  350 CONTINUE
  360 GO TO 30
  370 CONTINUE
C
C     TO ADD-CONSTRAINTS
C
C     USE COMPUTED ALPHA TO INTERPOLATE BETWEEN LAST
C     FEASIBLE SOLUTION X(*) AND CURRENT UNCONSTRAINED
C     (AND INFEASIBLE) SOLUTION Z(*).
      IF (.NOT.(LP1.LE.NSOLN)) GO TO 390
      DO 380 J=LP1,NSOLN
        X(J) = X(J) + ALPHA*(Z(J)-X(J))
  380 CONTINUE
  390 FEASBL = .FALSE.
      GO TO 410
  400 IF (FEASBL) GO TO 20
C
C     REMOVE COL JCON AND SHIFT COLS JCON+1 THROUGH N TO THE
C     LEFT. SWAP COL JCON INTO THE N-TH POSITION.  THIS ACHIEVES
C     UPPER HESSENBERG FORM FOR THE NONACTIVE CONSTRAINTS AND
C     LEAVES AN UPPER HESSENBERG MATRIX TO RETRIANGULARIZE.
  410 DO 420 I=1,M
        T = W(I,JCON)
        CALL SCOPY(N-JCON, W(I,JCON+1), MDW, W(I,JCON), MDW)
        W(I,N) = T
  420 CONTINUE
C
C     UPDATE PERMUTED INDEX VECTOR TO REFLECT THIS SHIFT AND SWAP.
      ITEMP = IPIVOT(JCON)
      IF (.NOT.(JCON.LT.N)) GO TO 440
      DO 430 I=JCON,NM1
        IPIVOT(I) = IPIVOT(I+1)
  430 CONTINUE
  440 IPIVOT(N) = ITEMP
C
C     SIMILARLY REPERMUTE X(*) VECTOR.
      CALL SCOPY(N-JCON, X(JCON+1), 1, X(JCON), 1)
      X(N) = ZERO
      NSP1 = NSOLN
      NSOLN = NSOLN - 1
      NIV1 = NIV
      NIV = NIV - 1
C
C     RETRIANGULARIZE UPPER HESSENBERG MATRIX AFTER ADDING CONSTRAINTS.
      J = JCON
      I = KRANK + JCON - L
  450 IF (.NOT.(J.LE.NSOLN)) GO TO 570
      IF (.NOT.(ITYPE(I).EQ.0 .AND. ITYPE(I+1).EQ.0)) GO TO 470
      ASSIGN 460 TO IGO938
      GO TO 620
C
C     (ITYPE(I).EQ.0 .AND. ITYPE(I+1).EQ.0) ZERO-IP1-TO-I-IN-COL-J
  460 GO TO 560
  470 IF (.NOT.(ITYPE(I).EQ.1 .AND. ITYPE(I+1).EQ.1)) GO TO 490
      ASSIGN 480 TO IGO938
      GO TO 620
C
C     (ITYPE(I).EQ.1 .AND. ITYPE(I+1).EQ.1) ZERO-IP1-TO-I-IN-COL-J
  480 GO TO 560
  490 IF (.NOT.(ITYPE(I).EQ.1 .AND. ITYPE(I+1).EQ.0)) GO TO 510
      CALL SSWAP(NP1, W(I,1), MDW, W(I+1,1), MDW)
      CALL SSWAP(1, SCALE(I), 1, SCALE(I+1), 1)
      ITEMP = ITYPE(I+1)
      ITYPE(I+1) = ITYPE(I)
      ITYPE(I) = ITEMP
C
C     SWAPPED ROW WAS FORMERLY A PIVOT ELT., SO IT WILL
C     BE LARGE ENOUGH TO PERFORM ELIM.
      ASSIGN 500 TO IGO938
      GO TO 620
C
C     ZERO-IP1-TO-I-IN-COL-J
  500 GO TO 560
  510 IF (.NOT.(ITYPE(I).EQ.0 .AND. ITYPE(I+1).EQ.1)) GO TO 550
      T = SCALE(I)*W(I,J)**2/ALSQ
      IF (.NOT.(T.GT.TAU**2*EANORM**2)) GO TO 530
      ASSIGN 520 TO IGO938
      GO TO 620
  520 GO TO 540
  530 CALL SSWAP(NP1, W(I,1), MDW, W(I+1,1), MDW)
      CALL SSWAP(1, SCALE(I), 1, SCALE(I+1), 1)
      ITEMP = ITYPE(I+1)
      ITYPE(I+1) = ITYPE(I)
      ITYPE(I) = ITEMP
      W(I+1,J) = ZERO
  540 CONTINUE
  550 CONTINUE
  560 I = I + 1
      J = J + 1
      GO TO 450
C
C     SEE IF THE REMAINING COEFFS IN THE SOLN SET ARE FEASIBLE.  THEY
C     SHOULD BE BECAUSE OF THE WAY ALPHA WAS DETERMINED.  IF ANY ARE
C     INFEASIBLE IT IS DUE TO ROUNDOFF ERROR.  ANY THAT ARE NON-
C     POSITIVE WILL BE SET TO ZERO AND REMOVED FROM THE SOLN SET.
  570 IF (.NOT.(LP1.LE.NSOLN)) GO TO 590
      DO 580 JCON=LP1,NSOLN
        IF (X(JCON).LE.ZERO) GO TO 600
  580 CONTINUE
  590 FEASBL = .TRUE.
  600 CONTINUE
      GO TO 400
  620 CONTINUE
C
C     TO ZERO-IP1-TO-I-IN-COL-J
      IF (.NOT.(W(I+1,J).NE.ZERO)) GO TO 630
      CALL SROTMG(SCALE(I), SCALE(I+1), W(I,J), W(I+1,J), SPARAM)
      W(I+1,J) = ZERO
      CALL SROTM(NP1-J, W(I,J+1), MDW, W(I+1,J+1), MDW, SPARAM)
  630 GO TO 1290
C
C     TO PERFORM-MULTIPLIER-TEST-AND-DROP-A-CONSTRAINT
C
  640 CALL SCOPY(NSOLN, Z, 1, X, 1)
      IF (.NOT.(NSOLN.LT.N)) GO TO 650
      X(NSP1) = ZERO
      CALL SCOPY(N-NSOLN, X(NSP1), 0, X(NSP1), 1)
  650 I = NIV1
  660 IF (.NOT.(I.LE.ME)) GO TO 690
C
C     RECLASSIFY LEAST SQUARES EQATIONS AS EQUALITIES AS
C     NECESSARY.
      IF (.NOT.(ITYPE(I).EQ.0)) GO TO 670
      I = I + 1
      GO TO 680
  670 CALL SSWAP(NP1, W(I,1), MDW, W(ME,1), MDW)
      CALL SSWAP(1, SCALE(I), 1, SCALE(ME), 1)
      ITEMP = ITYPE(I)
      ITYPE(I) = ITYPE(ME)
      ITYPE(ME) = ITEMP
      MEP1 = ME
      ME = ME - 1
  680 GO TO 660
C
C     FORM INNER PRODUCT VECTOR WD(*) OF DUAL COEFFS.
  690 IF (.NOT.(NSP1.LE.N)) GO TO 730
      DO 720 J=NSP1,N
        SM = ZERO
        IF (.NOT.(NSOLN.LT.M)) GO TO 710
        DO 700 I=NSP1,M
          SM = SM + SCALE(I)*W(I,J)*W(I,NP1)
  700   CONTINUE
  710   WD(J) = SM
  720 CONTINUE
  730 GO TO 750
  740 IF (POS .OR. DONE) GO TO 970
C
C     FIND J SUCH THAT WD(J)=WMAX IS MAXIMUM.  THIS DETERMINES
C     THAT THE INCOMING COL J WILL REDUCE THE RESIDUAL VECTOR
C     AND BE POSITIVE.
  750 WMAX = ZERO
      IWMAX = NSP1
      IF (.NOT.(NSP1.LE.N)) GO TO 780
      DO 770 J=NSP1,N
        IF (.NOT.(WD(J).GT.WMAX)) GO TO 760
        WMAX = WD(J)
        IWMAX = J
  760   CONTINUE
  770 CONTINUE
  780 IF (.NOT.(WMAX.LE.ZERO)) GO TO 790
      DONE = .TRUE.
      GO TO 960
C
C     SET DUAL COEFF TO ZERO FOR INCOMING COL.
  790 WD(IWMAX) = ZERO
C
C     WMAX .GT. ZERO, SO OKAY TO MOVE COL IWMAX TO SOLN SET.
C     PERFORM TRANSFORMATION TO RETRIANGULARIZE, AND TEST
C     FOR NEAR LINEAR DEPENDENCE.
C     SWAP COL IWMAX INTO NSOLN-TH POSITION TO MAINTAIN UPPER
C     HESSENBERG FORM OF ADJACENT COLS, AND ADD NEW COL TO
C     TRIANGULAR DECOMPOSITION.
      NSOLN = NSP1
      NSP1 = NSOLN + 1
      NIV = NIV1
      NIV1 = NIV + 1
      IF (.NOT.(NSOLN.NE.IWMAX)) GO TO 800
      CALL SSWAP(M, W(1,NSOLN), 1, W(1,IWMAX), 1)
      WD(IWMAX) = WD(NSOLN)
      WD(NSOLN) = ZERO
      ITEMP = IPIVOT(NSOLN)
      IPIVOT(NSOLN) = IPIVOT(IWMAX)
      IPIVOT(IWMAX) = ITEMP
C
C     REDUCE COL NSOLN SO THAT THE MATRIX OF NONACTIVE
C     CONSTRAINTS VARIABLES IS TRIANGULAR.
  800 J = M
  810 IF (.NOT.(J.GT.NIV)) GO TO 870
      JM1 = J - 1
      JP = JM1
C
C     WHEN OPERATING NEAR THE ME LINE, TEST TO SEE IF THE PIVOT ELT.
C     IS NEAR ZERO.  IF SO, USE THE LARGEST ELT. ABOVE IT AS THE PIVOT.
C     THIS IS TO MAINTAIN THE SHARP INTERFACE BETWEEN WEIGHTED AND
C     NON-WEIGHTED ROWS IN ALL CASES.
      IF (.NOT.(J.EQ.MEP1)) GO TO 850
      IMAX = ME
      AMAX = SCALE(ME)*W(ME,NSOLN)**2
  820 IF (.NOT.(JP.GE.NIV)) GO TO 840
      T = SCALE(JP)*W(JP,NSOLN)**2
      IF (.NOT.(T.GT.AMAX)) GO TO 830
      IMAX = JP
      AMAX = T
  830 JP = JP - 1
      GO TO 820
  840 JP = IMAX
  850 IF (.NOT.(W(J,NSOLN).NE.ZERO)) GO TO 860
      CALL SROTMG(SCALE(JP), SCALE(J), W(JP,NSOLN), W(J,NSOLN), SPARAM)
      W(J,NSOLN) = ZERO
      CALL SROTM(NP1-NSOLN, W(JP,NSP1), MDW, W(J,NSP1), MDW, SPARAM)
  860 J = JM1
      GO TO 810
C
C     SOLVE FOR Z(NSOLN)=PROPOSED NEW VALUE FOR X(NSOLN).
C     TEST IF THIS IS NONPOSITIVE OR TOO LARGE.
C     IF THIS WAS TRUE OR IF THE PIVOT TERM WAS ZERO REJECT
C     THE COL AS DEPENDENT.
  870 IF (.NOT.(W(NIV,NSOLN).NE.ZERO)) GO TO 890
      ISOL = NIV
      ASSIGN 880 TO IGO897
      GO TO 980
C
C     TEST-PROPOSED-NEW-COMPONENT
  880 GO TO 940
  890 IF (.NOT.(NIV.LE.ME .AND. W(MEP1,NSOLN).NE.ZERO)) GO TO 920
C
C     TRY TO ADD ROW MEP1 AS AN ADDITIONAL EQUALITY CONSTRAINT.
C     CHECK SIZE OF PROPOSED NEW SOLN COMPONENT.
C     REJECT IT IF IT IS TOO LARGE.
      ISOL = MEP1
      ASSIGN 900 TO IGO897
      GO TO 980
C
C     TEST-PROPOSED-NEW-COMPONENT
  900 IF (.NOT.(POS)) GO TO 910
C
C     SWAP ROWS MEP1 AND NIV, AND SCALE FACTORS FOR THESE ROWS.
      CALL SSWAP(NP1, W(MEP1,1), MDW, W(NIV,1), MDW)
      CALL SSWAP(1, SCALE(MEP1), 1, SCALE(NIV), 1)
      ITEMP = ITYPE(MEP1)
      ITYPE(MEP1) = ITYPE(NIV)
      ITYPE(NIV) = ITEMP
      ME = MEP1
      MEP1 = ME + 1
  910 GO TO 930
  920 POS = .FALSE.
  930 CONTINUE
  940 IF (POS) GO TO 950
      NSP1 = NSOLN
      NSOLN = NSOLN - 1
      NIV1 = NIV
      NIV = NIV - 1
  950 CONTINUE
  960 GO TO 740
  970 GO TO 20
  980 CONTINUE
C
C     TO TEST-PROPOSED-NEW-COMPONENT
      Z2 = W(ISOL,NP1)/W(ISOL,NSOLN)
      Z(NSOLN) = Z2
      POS = Z2.GT.ZERO
      IF (.NOT.(Z2*EANORM.GE.BNORM .AND. POS)) GO TO 990
      POS = .NOT.(BLOWUP*Z2*EANORM.GE.BNORM)
  990 GO TO 1280
 1000 CONTINUE
C     TO COMPUTE-FINAL-SOLUTION
C
C     SOLVE SYSTEM, STORE RESULTS IN X(*).
C
      ASSIGN 1010 TO IGO958
      GO TO 1110
C     SOLVE-SYSTEM
 1010 CALL SCOPY(NSOLN, Z, 1, X, 1)
C
C     APPLY HOUSEHOLDER TRANSFORMATIONS TO X(*) IF KRANK.LT.L
      IF (.NOT.(0.LT.KRANK .AND. KRANK.LT.L)) GO TO 1030
      DO 1020 I=1,KRANK
        CALL H12(2, I, KRP1, L, W(I,1), MDW, H(I), X, 1, 1, 1)
 1020 CONTINUE
C
C     FILL IN TRAILING ZEROES FOR CONSTRAINED VARIABLES NOT IN SOLN.
 1030 IF (.NOT.(NSOLN.LT.N)) GO TO 1040
      X(NSP1) = ZERO
      CALL SCOPY(N-NSOLN, X(NSP1), 0, X(NSP1), 1)
C
C     REPERMUTE SOLN VECTOR TO NATURAL ORDER.
 1040 DO 1070 I=1,N
        J = I
 1050   IF (IPIVOT(J).EQ.I) GO TO 1060
        J = J + 1
        GO TO 1050
 1060   IPIVOT(J) = IPIVOT(I)
        IPIVOT(I) = J
        CALL SSWAP(1, X(J), 1, X(I), 1)
 1070 CONTINUE
C
C     RESCALE THE SOLN USING THE COL SCALING.
      DO 1080 J=1,N
        X(J) = X(J)*D(J)
 1080 CONTINUE
      IF (.NOT.(NIV.LT.M)) GO TO 1100
      DO 1090 I=NIV1,M
        T = W(I,NP1)
        IF (I.LE.ME) T = T/ALAMDA
        T = (SCALE(I)*T)*T
        RNORM = RNORM + T
 1090 CONTINUE
 1100 RNORM = SQRT(RNORM)
      RETURN
C
C     TO SOLVE-SYSTEM
C
 1110 CONTINUE
      IF (.NOT.(DONE)) GO TO 1120
      ISOL = 1
      GO TO 1130
 1120 ISOL = LP1
 1130 IF (.NOT.(NSOLN.GE.ISOL)) GO TO 1270
C
C     COPY RT. HAND SIDE INTO TEMP VECTOR TO USE OVERWRITING METHOD.
      CALL SCOPY(NIV, W(1,NP1), 1, TEMP, 1)
      DO 1180 JJ=ISOL,NSOLN
        J = NSOLN - JJ + ISOL
        IF (.NOT.(J.GT.KRANK)) GO TO 1140
        I = NIV - JJ + ISOL
        GO TO 1150
 1140   I = J
 1150   IF (.NOT.(J.GT.KRANK .AND. J.LE.L)) GO TO 1160
        Z(J) = ZERO
        GO TO 1170
 1160   Z(J) = TEMP(I)/W(I,J)
        CALL SAXPY(I-1, -Z(J), W(1,J), 1, TEMP, 1)
 1170   CONTINUE
 1180 CONTINUE
C
 1270 GO TO IGO958, (310, 1010)
 1280 GO TO IGO897, (880, 900)
 1290 GO TO IGO938, (460, 480, 500, 520)
      END
      SUBROUTINE WNLIT(W, MDW, M, N, L, IPIVOT, ITYPE, H, SCALE, RNORM,
     * IDOPE, DOPE, DONE)
C
C     THIS IS A COMPANION SUBPROGRAM TO WNNLS( ).
C     THE DOCUMENTATION FOR WNNLS( ) HAS MORE COMPLETE
C     USAGE INSTRUCTIONS.
C
C     NOTE  THE M BY (N+1) MATRIX W( , ) CONTAINS THE RT. HAND SIDE
C           B AS THE (N+1)ST COL.
C
C
C     TRIANGULARIZE L1 BY L1 SUBSYSTEM, WHERE L1=MIN(M,L), WITH
C     COL INTERCHANGES.
C     REVISED OCT. 1, 1989
C
      REAL W(MDW,*), H(*), SCALE(*), DOPE(*), SPARAM(5)
      INTEGER ITYPE(*), IPIVOT(*), IDOPE(*)
      INTEGER ISAMAX
      LOGICAL INDEP, DONE, RECALC
      DATA TENM3 /1.E-3/, ZERO /0.E0/, ONE /1.E0/
C
      ME = IDOPE(1)
      MEP1 = IDOPE(2)
      KRANK = IDOPE(3)
      KRP1 = IDOPE(4)
      NSOLN = IDOPE(5)
      NIV = IDOPE(6)
      NIV1 = IDOPE(7)
      L1 = IDOPE(8)
C
      ALSQ = DOPE(1)
      EANORM = DOPE(2)
      FAC = DOPE(3)
      TAU = DOPE(4)
      NP1 = N + 1
      LB = MIN0(M-1,L)
      RECALC = .TRUE.
      RNORM = ZERO
      KRANK = 0
C     WE SET FACTOR=1.E0 SO THAT THE HEAVY WEIGHT ALAMDA WILL BE
C     INCLUDED IN THE TEST FOR COL INDEPENDENCE.
      FACTOR = 1.E0
      I = 1
      IP1 = 2
      LEND = L
   10 IF (.NOT.(I.LE.LB)) GO TO 150
      IF (.NOT.(I.LE.ME)) GO TO 130
C
C     SET IR TO POINT TO THE I-TH ROW.
      IR = I
      MEND = M
      ASSIGN 20 TO IGO996
      GO TO 460
C
C     UPDATE-COL-SS-AND-FIND-PIVOT-COL
   20 ASSIGN 30 TO IGO993
      GO TO 560
C
C     PERFORM-COL-INTERCHANGE
C
C     SET IC TO POINT TO I-TH COL.
   30 IC = I
      ASSIGN 40 TO IGO990
      GO TO 520
C
C     TEST-INDEP-OF-INCOMING-COL
   40 IF (.NOT.(INDEP)) GO TO 110
C
C     ELIMINATE I-TH COL BELOW DIAG. USING MOD. GIVENS TRANSFORMATIONS
C     APPLIED TO (A B).
      J = M
      DO 100 JJ=IP1,M
        JM1 = J - 1
        JP = JM1
        IF (.NOT.(JJ.EQ.M)) GO TO 70
        IF (.NOT.(I.LT.MEP1)) GO TO 80
        J = MEP1
        JP = I
        T = SCALE(JP)*W(JP,I)**2*TAU**2
        IF (.NOT.(T.GT.SCALE(J)*W(J,I)**2)) GO TO 130
        GO TO 80
   70   IF (.NOT.(J.EQ.MEP1)) GO TO 80
        J = JM1
        JM1 = J - 1
        JP = JM1
   80   IF (.NOT.(W(J,I).NE.ZERO)) GO TO 90
        CALL SROTMG(SCALE(JP), SCALE(J), W(JP,I), W(J,I), SPARAM)
        W(J,I) = ZERO
        CALL SROTM(NP1-I, W(JP,IP1), MDW, W(J,IP1), MDW, SPARAM)
   90   J = JM1
  100 CONTINUE
      GO TO 140
  110 CONTINUE
      IF (.NOT.(LEND.GT.I)) GO TO 130
C
C     COL I IS DEPENDENT. SWAP WITH COL LEND.
      MAX = LEND
C
C     PERFORM-COL-INTERCHANGE
      ASSIGN 120 TO IGO993
      GO TO 560
  120 CONTINUE
      LEND = LEND - 1
C
C     FIND COL IN REMAINING SET WITH LARGEST SS.
      MAX = ISAMAX(LEND-I+1,H(I),1) + I - 1
      HBAR = H(MAX)
      GO TO 30
  130 CONTINUE
      KRANK = I - 1
      GO TO 160
  140 I = IP1
      IP1 = IP1 + 1
      GO TO 10
  150 KRANK = L1
  160 CONTINUE
      KRP1 = KRANK + 1
      IF (.NOT.(KRANK.LT.ME)) GO TO 290
      FACTOR = ALSQ
      DO 170 I=KRP1,ME
        IF (L.GT.0) W(I,1) = ZERO
        CALL SCOPY(L, W(I,1), 0, W(I,1), MDW)
  170 CONTINUE
C
C     DETERMINE THE RANK OF THE REMAINING EQUALITY CONSTRAINT
C     EQUATIONS BY ELIMINATING WITHIN THE BLOCK OF CONSTRAINED
C     VARIABLES.  REMOVE ANY REDUNDANT CONSTRAINTS.
C
      IR = KRP1
      IF (.NOT.(L.LT.N)) GO TO 245
      LP1 = L + 1
      RECALC = .TRUE.
      LB = MIN0(L+ME-KRANK,N)
      I = LP1
      IP1 = I + 1
  180 IF (.NOT.(I.LE.LB)) GO TO 280
      IR = KRANK + I - L
      LEND = N
      MEND = ME
      ASSIGN 190 TO IGO996
      GO TO 460
C
C     UPDATE-COL-SS-AND-FIND-PIVOT-COL
  190 ASSIGN 200 TO IGO993
      GO TO 560
C
C     PERFORM-COL-INTERCHANGE
C
C     ELIMINATE ELEMENTS IN THE I-TH COL.
  200 J = ME
  210 IF (.NOT.(J.GT.IR)) GO TO 230
      JM1 = J - 1
      IF (.NOT.(W(J,I).NE.ZERO)) GO TO 220
      CALL SROTMG(SCALE(JM1), SCALE(J), W(JM1,I), W(J,I), SPARAM)
      W(J,I) = ZERO
      CALL SROTM(NP1-I, W(JM1,IP1), MDW, W(J,IP1), MDW, SPARAM)
  220 J = JM1
      GO TO 210
C
C     SET IC=I=COL BEING ELIMINATED
  230 IC = I
      ASSIGN 240 TO IGO990
      GO TO 520
C
C     TEST-INDEP-OF-INCOMING-COL
  240 IF (INDEP) GO TO 270
C
C     REMOVE ANY REDUNDANT OR DEPENDENT EQUALITY CONSTRAINTS.
  245 CONTINUE
      JJ = IR
  250 IF (.NOT.(IR.LE.ME)) GO TO 260
      W(IR,1) = ZERO
      CALL SCOPY(N, W(IR,1), 0, W(IR,1), MDW)
      RNORM = RNORM + (SCALE(IR)*W(IR,NP1)/ALSQ)*W(IR,NP1)
      W(IR,NP1) = ZERO
      SCALE(IR) = ONE
C     RECLASSIFY THE ZEROED ROW AS A LEAST SQUARES EQUATION.
      ITYPE(IR) = 1
      IR = IR + 1
      GO TO 250
C
C     REDUCE ME TO REFLECT ANY DISCOVERED DEPENDENT EQUALITY
C     CONSTRAINTS.
  260 CONTINUE
      ME = JJ - 1
      MEP1 = ME + 1
      GO TO 300
  270 I = IP1
      IP1 = IP1 + 1
      GO TO 180
  280 CONTINUE
  290 CONTINUE
  300 CONTINUE
      IF (.NOT.(KRANK.LT.L1)) GO TO 420
C
C     TRY TO DETERMINE THE VARIABLES KRANK+1 THROUGH L1 FROM THE
C     LEAST SQUARES EQUATIONS.  CONTINUE THE TRIANGULARIZATION WITH
C     PIVOT ELEMENT W(MEP1,I).
C
      RECALC = .TRUE.
C
C     SET FACTOR=ALSQ TO REMOVE EFFECT OF HEAVY WEIGHT FROM
C     TEST FOR COL INDEPENDENCE.
      FACTOR = ALSQ
      KK = KRP1
      I = KK
      IP1 = I + 1
  310 IF (.NOT.(I.LE.L1)) GO TO 410
C
C     SET IR TO POINT TO THE MEP1-ST ROW.
      IR = MEP1
      LEND = L
      MEND = M
      ASSIGN 320 TO IGO996
      GO TO 460
C
C     UPDATE-COL-SS-AND-FIND-PIVOT-COL
  320 ASSIGN 330 TO IGO993
      GO TO 560
C
C     PERFORM-COL-INTERCHANGE
C
C     ELIMINATE I-TH COL BELOW THE IR-TH ELEMENT.
  330 IRP1 = IR + 1
      IF (.NOT.(IRP1.LE.M)) GO TO 355
      J = M
      DO 350 JJ=IRP1,M
        JM1 = J - 1
        IF (.NOT.(W(J,I).NE.ZERO)) GO TO 340
        CALL SROTMG(SCALE(JM1), SCALE(J), W(JM1,I), W(J,I), SPARAM)
        W(J,I) = ZERO
        CALL SROTM(NP1-I, W(JM1,IP1), MDW, W(J,IP1), MDW, SPARAM)
  340   J = JM1
  350 CONTINUE
  355 CONTINUE
C
C     TEST IF NEW PIVOT ELEMENT IS NEAR ZERO. IF SO, THE COL IS
C     DEPENDENT.
      T = SCALE(IR)*W(IR,I)**2
      INDEP = T.GT.TAU**2*EANORM**2
      IF (.NOT.INDEP) GO TO 380
C
C     COL TEST PASSED. NOW MUST PASS ROW NORM TEST TO BE CLASSIFIED
C     AS INDEPENDENT.
      RN = ZERO
      DO 370 I1=IR,M
        DO 360 J1=IP1,N
          RN = AMAX1(RN,SCALE(I1)*W(I1,J1)**2)
  360   CONTINUE
  370 CONTINUE
      INDEP = T.GT.TAU**2*RN
C
C     IF INDEPENDENT, SWAP THE IR-TH AND KRP1-ST ROWS TO MAINTAIN THE
C     TRIANGULAR FORM.  UPDATE THE RANK INDICATOR KRANK AND THE
C     EQUALITY CONSTRAINT POINTER ME.
  380 IF (.NOT.(INDEP)) GO TO 390
      CALL SSWAP(NP1, W(KRP1,1), MDW, W(IR,1), MDW)
      CALL SSWAP(1, SCALE(KRP1), 1, SCALE(IR), 1)
C     RECLASSIFY THE LEAST SQ. EQUATION AS AN EQUALITY CONSTRAINT AND
C     RESCALE IT.
      ITYPE(IR) = 0
      T = SQRT(SCALE(KRP1))
      CALL SSCAL(NP1, T, W(KRP1,1), MDW)
      SCALE(KRP1) = ALSQ
      ME = MEP1
      MEP1 = ME + 1
      KRANK = KRP1
      KRP1 = KRANK + 1
      GO TO 400
  390 GO TO 430
  400 I = IP1
      IP1 = IP1 + 1
      GO TO 310
  410 CONTINUE
  420 CONTINUE
  430 CONTINUE
C
C     IF PSEUDORANK IS LESS THAN L, APPLY HOUSEHOLDER TRANS.
C     FROM RIGHT.
      IF (.NOT.(KRANK.LT.L)) GO TO 450
      DO 440 I=1,KRANK
        J = KRP1 - I
        CALL H12(1, J, KRP1, L, W(J,1), MDW, H(J), W, MDW, 1, J-1)
  440 CONTINUE
  450 NIV = KRANK + NSOLN - L
      NIV1 = NIV + 1
      IF (L.EQ.N) DONE = .TRUE.
C
C  END OF INITIAL TRIANGULARIZATION.
      IDOPE(1) = ME
      IDOPE(2) = MEP1
      IDOPE(3) = KRANK
      IDOPE(4) = KRP1
      IDOPE(5) = NSOLN
      IDOPE(6) = NIV
      IDOPE(7) = NIV1
      IDOPE(8) = L1
      RETURN
  460 CONTINUE
C
C     TO UPDATE-COL-SS-AND-FIND-PIVOT-COL
C
C     THE COL SS VECTOR WILL BE UPDATED AT EACH STEP. WHEN
C     NUMERICALLY NECESSARY, THESE VALUES WILL BE RECOMPUTED.
C
      IF (.NOT.(IR.NE.1 .AND. (.NOT.RECALC))) GO TO 480
C     UPDATE COL SS =SUM OF SQUARES.
      DO 470 J=I,LEND
        H(J) = H(J) - SCALE(IR-1)*W(IR-1,J)**2
  470 CONTINUE
C
C     TEST FOR NUMERICAL ACCURACY.
      MAX = ISAMAX(LEND-I+1,H(I),1) + I - 1
      RECALC = HBAR + TENM3*H(MAX).EQ.HBAR
C
C     IF REQUIRED, RECALCULATE COL SS, USING ROWS IR THROUGH MEND.
  480 IF (.NOT.(RECALC)) GO TO 510
      DO 500 J=I,LEND
        H(J) = ZERO
        DO 490 K=IR,MEND
          H(J) = H(J) + SCALE(K)*W(K,J)**2
  490   CONTINUE
  500 CONTINUE
C
C     FIND COL WITH LARGEST SS.
      MAX = ISAMAX(LEND-I+1,H(I),1) + I - 1
      HBAR = H(MAX)
  510 GO TO 600
  520 CONTINUE
C
C     TO TEST-INDEP-OF-INCOMING-COL
C
C     TEST THE COL IC TO DETERMINE IF IT IS LINEARLY INDEPENDENT
C     OF THE COLS ALREADY IN THE BASIS.  IN THE INIT TRI
C     STEP, WE USUALLY WANT THE HEAVY WEIGHT ALAMDA TO
C     BE INCLUDED IN THE TEST FOR INDEPENDENCE.  IN THIS CASE THE
C     VALUE OF FACTOR WILL HAVE BEEN SET TO 1.E0 BEFORE THIS
C     PROCEDURE IS INVOKED.  IN THE POTENTIALLY RANK DEFICIENT
C     PROBLEM, THE VALUE OF FACTOR WILL HAVE BEEN
C     SET TO ALSQ=ALAMDA**2 TO REMOVE THE EFFECT OF THE HEAVY WEIGHT
C     FROM THE TEST FOR INDEPENDENCE.
C
C     WRITE NEW COL AS PARTITIONED VECTOR
C             (A1)  NUMBER OF COMPONENTS IN SOLN SO FAR = NIV
C             (A2)  M-NIV COMPONENTS
C     AND COMPUTE  SN = INVERSE WEIGHTED LENGTH OF A1
C                  RN = INVERSE WEIGHTED LENGTH OF A2
C     CALL THE COL INDEPENDENT WHEN RN .GT. TAU*SN
      SN = ZERO
      RN = ZERO
      DO 550 J=1,MEND
        T = SCALE(J)
        IF (J.LE.ME) T = T/FACTOR
        T = T*W(J,IC)**2
        IF (.NOT.(J.LT.IR)) GO TO 530
        SN = SN + T
        GO TO 540
  530   RN = RN + T
  540   CONTINUE
  550 CONTINUE
      INDEP = RN.GT.TAU**2*SN
      GO TO 590
  560 CONTINUE
C
C     TO PERFORM-COL-INTERCHANGE
C
      IF (.NOT.(MAX.NE.I)) GO TO 570
C     EXCHANGE ELEMENTS OF PERMUTED INDEX VECTOR AND PERFORM COL
C     INTERCHANGES.
      ITEMP = IPIVOT(I)
      IPIVOT(I) = IPIVOT(MAX)
      IPIVOT(MAX) = ITEMP
      CALL SSWAP(M, W(1,MAX), 1, W(1,I), 1)
      T = H(MAX)
      H(MAX) = H(I)
      H(I) = T
  570 GO TO IGO993, (30, 200, 330, 120)
  590 GO TO IGO990, (40, 240)
  600 GO TO IGO996, (20, 190, 320)
      END
      SUBROUTINE L2SLV(M, N, M1, L, A, MM, B, MB, W, TOL, N1, IPIVOT,
     *                 X, NN, RES, MR, QR, MMPNN, C, IFAULT)
C ** PURPOSE **
C SUBROUTINE L2SLV COMPUTES LEAST SQUARES SOLUTIONS TO OVERDETERMINED
C AND UNDERDETERMINED SYSTEMS OF LINEAR EQUATIONS.  THE METHOD USED IS
C A MODIFIED GRAM-SCHMIDT ORTHOGONAL DECOMPOSITION WITH ITERATIVE
C REFINEMENT OF THE SOLUTION.  THE SOLUTION MAY BE SUBJECT TO LINEAR
C EQUALITY CONSTRAINTS.  OUTPUT INCLUDES THE LEAST SQUARES
C COEFFICIENTS, RESIDUALS, UNSCALED COVARIANCE MATRIX, AND INFORMATION
C ON THE BEHAVIOR OF THE ITERATIVE REFINEMENT PROCEDURE.
C MATRIX A IS THE GIVEN MATRIX OF A SYSTEM OF M LINEAR EQUATIONS IN N
C UNKNOWNS, AND MATRIX W IS A GIVEN DIAGONAL MATRIX OF WEIGHTS WITH ALL
C DIAGONAL ELEMENTS NONNEGATIVE.  LET H = W*A.
C IN THE EVENT THAT N1 (THE COMPUTED RANK OF MATRIX H) IS LESS THAN N
C (THE NUMBER OF UNKNOWN COEFFICIENTS), A UNIQUE SOLUTION VECTOR HAVING
C N ELEMENTS CAN BE OBTAINED BY IMPOSING THE CONDITION THAT THE
C SOLUTION BE OF MINIMAL EUCLIDEAN NORM.  SUCH A SOLUTION IS SOUGHT IN
C THE CASE OF UNDERDETERMINED OR RANK-DEFICIENT PROBLEMS.
C
C ** INPUT VARIABLES **
C M      TOTAL NUMBER OF EQUATIONS.
C N      NUMBER OF UNKNOWN COEFFICIENTS.
C M1     NUMBER OF LINEAR CONSTRAINTS (0.LE.M1.LE.M AND M1.LE.N).
C L      NUMBER OF RIGHT-HAND SIDES (VECTORS OF OBSERVATIONS).
C A      TWO-DIMENSIONAL ARRAY OF SIZE (MM,N).  ON ENTRY, THE ARRAY A
C        CONTAINS THE GIVEN MATRIX OF A SYSTEM OF M LINEAR EQUATIONS
C        IN N UNKNOWNS, WHERE THE FIRST M1 EQUATIONS ARE TO BE
C        SATISFIED EXACTLY.  A IS LEFT INTACT ON EXIT.
C B      TWO-DIMENSIONAL ARRAY OF SIZE (MB,L).  ON ENTRY, B CONTAINS
C        THE L GIVEN RIGHT-HAND SIDES (VECTORS OF OBSERVATIONS).  B IS
C        LEFT INTACT ON EXIT.
C W      VECTOR OF SIZE M.  ON ENTRY, W CONTAINS THE DIAGONAL ELEMENTS
C        OF A GIVEN DIAGONAL MATRIX OF WEIGHTS, ALL NONNEGATIVE.
C        (THE FIRST M1 ELEMENTS OF W ARE SET EQUAL TO 1.0 BY THE
C        PROGRAM WHEN M1 IS GREATER THAN ZERO.)
C TOL    PARAMETER USED IN DETERMINING THE RANK OF MATRIX H.
C        NOTE --
C        (1) IF TOL EQUALS ZERO, THE TOLERANCE USED IN SUBROUTINE
C            DECOM2 WILL BE BASED ON MACHINE PRECISION.
C        (2) IF TOL IS GREATER THAN ZERO, THIS VALUE OF TOL WILL BE
C            USED IN SETTING AN ABSOLUTE TOLERANCE FOR COMPARISON WITH
C            DIAGONAL ELEMENTS OF THE TRIANGULAR MATRIX OBTAINED IN
C            SUBROUTINE DECOM2.  THE VALUE OF TOL CAN BE BASED ON
C            KNOWLEDGE CONCERNING THE ACCURACY OF THE DATA.
C MM     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
C        THE ARRAY A.  MM MUST SATISFY MM.GE.M.
C MB     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
C        THE ARRAY B.  MB MUST SATISFY MB.GE.M.
C MR     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
C        THE ARRAY RES.  MR MUST SATISFY MR.GE.M.
C NN     DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
C        THE ARRAY X.  NN MUST SATISFY NN.GE.N.
C MMPNN  DIMENSIONING PARAMETER SPECIFYING MAXIMUM NUMBER OF ROWS IN
C        THE ARRAY QR.  MMPNN MUST SATISFY MMPNN.GE.M+N.
C
C ** OUTPUT VARIABLES AND INTERNAL VARIABLES **
C N1     COMPUTED RANK OF MATRIX H, WHERE H = W*A.
C IPIVOT VECTOR OF SIZE N.  ON EXIT, THIS ARRAY RECORDS THE ORDER
C        IN WHICH THE COLUMNS OF H WERE SELECTED BY THE PIVOTING
C        SCHEME IN THE COURSE OF THE ORTHOGONAL DECOMPOSITION.
C        WHENEVER N1.LT.N, THE FIRST N1 ELEMENTS OF IPIVOT INDICATE
C        WHICH COLUMNS OF H WERE FOUND TO BE LINEARLY INDEPENDENT.
C X      TWO-DIMENSIONAL ARRAY OF SIZE (NN,L).  ON EXIT, X CONTAINS
C        THE SOLUTION VECTORS.
C RES    TWO-DIMENSIONAL ARRAY OF SIZE (MR,L).  ON EXIT, RES CONTAINS
C        THE RESIDUAL VECTORS.
C QR     TWO-DIMENSIONAL ARRAY OF SIZE (MMPNN,N).  ON EXIT, IF N1 = N
C        THEN QR CONTAINS THE UNSCALED COVARIANCE MATRIX. (QR IS USED
C        INTERNALLY TO STORE THE RESULTS FROM THE SUBROUTINE DECOM2.
C        THE RESULTS FROM DECOM2 ARE DESTROYED WHEN THE COVARIANCE
C        MATRIX IS COMPUTED.)
C C      VECTOR HAVING AT LEAST 6*(M+N)+2*L ELEMENTS USED (1) FOR
C        INTERNAL WORK SPACE AND (2) FOR RETURNING INFORMATION ON THE
C        BEHAVIOR OF THE ITERATIVE REFINEMENT PROCEDURE.
C        (A) NUMIT IS THE NUMBER OF ITERATIONS CARRIED OUT DURING THE
C            ITERATIVE REFINEMENT IN ATTEMPTING TO OBTAIN A SOLUTION
C            FOR THE K-TH RIGHT-HAND SIDE.
C            ON EXIT, C(K) = +NUMIT IF THE SOLUTION CONVERGED, AND
C                     C(K) = -NUMIT IF THE SOLUTION FAILED TO CONVERGE.
C        (B) DIGITX GIVES AN ESTIMATE OF THE NUMBER OF CORRECT DIGITS
C            IN THE INITIAL SOLUTION OF THE COEFFICIENTS FOR THE K-TH
C            RIGHT-HAND SIDE.  ON EXIT, C(K+L) = DIGITX.
C IFAULT FAULT INDICATOR WHICH IS ZERO IF NO ERRORS WERE ENCOUNTERED
C        AND POSITIVE IF ERRORS WERE DETECTED OR IF EVIDENCE OF SEVERE
C        ILL-CONDITIONING WAS FOUND.  IF IFAULT IS SET TO 1, 2, 3, 4,
C        5, 6 OR 7, EXECUTION IS TERMINATED.  EXECUTION CONTINUES WHEN
C        IFAULT IS SET EQUAL TO 8, 9 OR 10 PROVIDED THAT A SOLUTION
C        WAS OBTAINED FOR AT LEAST ONE RIGHT-HAND SIDE.  THE VALUE OF
C        IFAULT IS USED TO INDICATE THE FOLLOWING --
C        0 = NO ERRORS ENCOUNTERED.
C        1 = BAD INPUT PARAMETER (M, N OR L).
C        2 = BAD INPUT PARAMETER (M1).
C        3 = BAD DIMENSION.  EITHER M.GT.MM, M.GT.MB, M.GT.MR,
C            N.GT.NN, OR M+N.GT.MMPNN.
C        4 = AT LEAST ONE WEIGHT IS NEGATIVE.
C        5 = EITHER MATRIX H OR MATRIX OF CONSTRAINTS EQUALS ZERO.
C        6 = CONSTRAINTS ARE LINEARLY DEPENDENT.
C        7 = ALL SOLUTIONS FAILED TO CONVERGE.
C        8 = SOLUTION FAILED TO CONVERGE FOR AT LEAST ONE RIGHT-HAND
C            SIDE.
C        9 = LARGE NUMBER OF ITERATIONS REQUIRED FOR CONVERGENCE.
C       10 = ESTIMATED NUMBER OF DIGITS IN INITIAL SOLUTION OF
C            COEFFICIENTS IS SMALL.
C       11 = DIAGONAL ELEMENT OF COVARIANCE MATRIX WAS COMPUTED TO BE
C            NEGATIVE OWING TO ROUNDING ERROR. NO SEVERE CONDITIONING
C            PROBLEMS WERE DETECTED.
C       12 = DIAGONAL ELEMENT OF COVARIANCE MATRIX WAS COMPUTED TO BE
C            NEGATIVE OWING TO ROUNDING ERROR. THE PROBLEM APPEARS TO
C            BE EXTREMELY ILL-CONDITIONED.
C
C ** SUBROUTINES REQUIRED **
C SUBROUTINE DECOM2
C        USES MODIFIED GRAM-SCHMIDT ALGORITHM WITH PIVOTING TO
C        OBTAIN AN ORTHOGONAL DECOMPOSITION OF THE INPUT MATRIX.
C SUBROUTINE SOLVE2
C        COMPUTES COEFFICIENTS AND RESIDUALS.  ITERATIVE REFINEMENT IS
C        USED TO IMPROVE THE ACCURACY OF THE INITIAL SOLUTION.
C SUBROUTINE SOLVE3
C        CALLED ONLY BY SUBROUTINE SOLVE2.
C SUBROUTINE COVAR
C        COMPUTES UNSCALED COVARIANCE MATRIX OF THE COEFFICIENTS.
C
C ** STORAGE REQUIREMENTS **
C THE STORAGE REQUIRED FOR THE DIMENSIONED ARRAYS IN L2SLV IS
C   M*(2*N + 2*L + 7) + N*(N + L + 7) + 2*L
C LOCATIONS.  ALL ARRAYS REQUIRED IN SUBROUTINES CALLED BY L2SLV ARE
C DECLARED HEREIN AND ARE TRANSMITTED ONLY THROUGH PARAMETER LISTS OF
C CALL-SEQUENCES.
C
C ** PRECISION OF ARITHMETIC CALCULATIONS **
C SINGLE PRECISION ARITHMETIC IS USED FOR ALL CALCULATIONS EXCEPT THE
C DOUBLE PRECISION ACCUMULATION OF INNER PRODUCTS.  (THE VARIABLE SUM
C IS DECLARED TO BE DOUBLE PRECISION IN SUBROUTINES DECOM2, SOLVE2,
C SOLVE3 AND COVAR.)  IT IS ESSENTIAL FOR THE SUCCESS OF THE ITERATIVE
C REFINEMENT PROCEDURE THAT INNER PRODUCTS BE ACCUMULATED IN DOUBLE
C PRECISION.
C
C ** CONVERSION OF THE PROGRAM TO DOUBLE PRECISION **
C *********************************************************************
C * ON COMPUTERS HAVING SHORT WORD LENGTH (AS THE IBM 360/370) IT MAY *
C * BE DESIRABLE TO PERFORM ALL CALCULATIONS IN DOUBLE PRECISION.  IN *
C * THIS CASE, THE ITERATIVE REFINEMENT PRESENTLY INCLUDED IN SOLVE2  *
C * SHOULD BE OMITTED.                                                *
C * TO CONVERT THE PROGRAM TO DOUBLE PRECISION, THE FOLLOWING         *
C * APPROACH IS SUGGESTED.                                            *
C *                                                                   *
C * 1. VARIABLES PRESENTLY DECLARED TO BE REAL SHOULD BE DECLARED     *
C *    DOUBLE PRECISION.  THOSE TYPED INTEGER, DOUBLE PRECISION AND   *
C *    LOGICAL SHOULD NOT BE CHANGED.                                 *
C * 2. THE USE OF FAIL, NUMIT AND DIGITX SHOULD BE OMITTED.           *
C * 3. DESCRIPTION OF VARIABLE C (AT L2B 690-790) SHOULD READ --      *
C *    C  VECTOR HAVING AT LEAST 6*(M+N) ELEMENTS USED ONLY FOR       *
C *       INTERNAL WORK SPACE.                                        *
C * 4. THE VALUE OF ETA (AT L2B 1960) SHOULD BE SET SO THAT IT IS THE *
C *    SMALLEST POSITIVE DOUBLE PRECISION NUMBER SUCH THAT 1.0 + ETA  *
C *    IS GREATER THAN 1.0 IN DOUBLE PRECISION ARITHMETIC.            *
C *    FOR IBM COMPUTER TYPE, ETA = 16.**(-13)                        *
C *    FOR UNIVAC COMPUTER TYPE, ETA = 2.**(-59)                      *
C * 5. THE FOLLOWING FORTRAN FUNCTIONS SHOULD BE CHANGED --           *
C *      SINGLE PRECISION NAME     DOUBLE PRECISION NAME              *
C *             DBLE(X)                X                              *
C *             FLOAT(N)               DBLE(FLOAT(N))                 *
C *             SQRT(X)                DSQRT(X)                       *
C *    DBLE(X) IS USED IN SUBROUTINES DECOM2, SOLVE2, SOLVE3 AND      *
C *       COVAR.                                                      *
C *    FLOAT(N) IS USED IN SUBROUTINE DECOM2.                         *
C *    SQRT(X) IS USED IN SUBROUTINE L2SLV.                           *
C * 6. REPLACE STATEMENT L2B 2500 BY A STATEMENT READING              *
C *          K3 = 1                                                   *
C * 7. FURTHER DETAILS ARE GIVEN IN SUBROUTINE SOLVE2 IN CONNECTION   *
C *    WITH THE OMISSION OF ITERATIVE REFINEMENT.                     *
C * 8. IN SUBROUTINE L2SLV, STATEMENTS L2B 950-1000, 1820-1830, 2020, *
C *    2350-2360, 2480-2490, 3070, 3280-3570 AND 3590-3620 SHOULD BE  *
C *    OMITTED.                                                       *
C *    STATEMENT NUMBERS GIVEN HERE REFER TO THOSE IN THE RIGHT-HAND  *
C *    MARGIN.  CERTAIN COMMENTS IN SUBROUTINE L2SLV DO NOT APPLY TO  *
C *    THE DOUBLE PRECISION VERSION.                                  *
C *                                                                   *
C *********************************************************************
C
      INTEGER IPIVOT(N)
      REAL A(MM,N), B(MB,L), C(*), ETA, QR(MMPNN,N),
     * RES(MR,L), TOL, W(M), X(NN,L)
      REAL DIGITX
      LOGICAL FAIL
      LOGICAL SING
C
C SET VALUE OF ETA, A MACHINE-DEPENDENT PARAMETER.
C ETA, THE RELATIVE MACHINE PRECISION, IS THE SMALLEST POSITIVE REAL
C NUMBER SUCH THAT 1.0 + ETA IS GREATER THAN 1.0 IN FLOATING-POINT
C ARITHMETIC.
C
      ETA = SPMPAR(1)
C
C DEFAULT VALUE FOR TOL IS ZERO.
C
      IF (TOL.LT.0.0) TOL = 0.0
      IFAULT = 0
      KSUM = 0
C
C PERFORM INITIAL CHECKING OF INPUT PARAMETERS, DIMENSIONS AND
C WEIGHTS FOR POSSIBLE ERRORS.
C
      IF (M.GT.0 .AND. N.GT.0 .AND. L.GT.0) GO TO 10
      IFAULT = 1
      RETURN
   10 IF (M1.LE.M .AND. M1.LE.N .AND. M1.GE.0) GO TO 20
      IFAULT = 2
      RETURN
   20 IF (M.LE.MM .AND. M.LE.MB .AND. M.LE.MR .AND. N.LE.NN
     *            .AND. M+N.LE.MMPNN) GO TO 30
      IFAULT = 3
      RETURN
   30 DO 40 I=1,M
        IF (M1.GT.0 .AND. I.LE.M1) W(I) = 1.0
        IF (W(I).GE.0.0) GO TO 40
        IFAULT = 4
        RETURN
   40 CONTINUE
C
C SET PARAMETERS WHICH ALLOCATE VECTOR C TO CONTAIN CERTAIN FINAL
C RESULTS AND ALSO TO BE USED AS WORK SPACE.
C
C K1 IS STARTING POINT FOR NUMIT AND FAIL, OF LENGTH L.
C K2 IS STARTING POINT FOR DIGITX, OF LENGTH L.
C K3 IS STARTING POINT FOR D, OF LENGTH N.
C K4 IS STARTING POINT FOR K-TH COLUMN OF B, OF LENGTH M.
C K5 IS STARTING POINT FOR K-TH COLUMN OF X, OF LENGTH N.
C K6 IS STARTING POINT FOR K-TH COLUMN OF RES, OF LENGTH M.
C K7 IS STARTING POINT FOR WORK SPACE OF LENGTH M.
C K8 IS STARTING POINT FOR WORK SPACE OF LENGTH M.
C K9 IS STARTING POINT FOR WORK SPACE OF LENGTH N.
C K10 IS STARTING POINT FOR WORK SPACE OF LENGTH N.
C K11 IS STARTING POINT FOR WORK SPACE OF LENGTH M + N.
C K12 IS STARTING POINT FOR WORK SPACE OF LENGTH M + N.
C
      K1 = 1
      K2 = K1 + L
      K3 = K2 + L
      K4 = K3 + N
      K5 = K4 + M
      K6 = K5 + N
      K7 = K6 + M
      K8 = K7 + M
      K9 = K8 + M
      K10 = K9 + N
      K11 = K10 + N
      K12 = K11 + M + N
      K = K12 + M + N - 1
C
C MULTIPLY EACH ROW OF MATRIX A (M BY N) BY ITS APPROPRIATE WEIGHT AND
C STORE THE RESULT IN THE FIRST M ROWS OF ARRAY QR.  SET ARRAY C AND
C THE LAST N ROWS OF ARRAY QR EQUAL TO ZERO.
C
      DO 60 I=1,K
        C(I) = 0.0
   60 CONTINUE
      MP1 = M + 1
      MPN = M + N
      DO 90 J=1,N
        DO 70 I=1,M
          QR(I,J) = A(I,J)*W(I)
   70   CONTINUE
        DO 80 I=MP1,MPN
          QR(I,J) = 0.0
   80   CONTINUE
   90 CONTINUE
C
C OBTAIN AN ORTHOGONAL DECOMPOSITION OF THE MATRIX STORED IN THE FIRST
C M ROWS OF ARRAY QR AND COMPUTE ITS RANK.
C
      CALL DECOM2(M, N, M1, ETA, TOL, QR, C(K3), N1, IPIVOT, SING,
     * MMPNN)
C
      IF (.NOT.SING) GO TO 110
      IF (N1.GT.0) GO TO 100
      IFAULT = 5
      RETURN
  100 IFAULT = 6
      RETURN
C
C SEEK A SOLUTION (COEFFICIENTS AND RESIDUALS) FOR EACH OF THE L LEAST
C SQUARES PROBLEMS WHOSE RIGHT-HAND SIDES ARE GIVEN IN THE ARRAY B.
C
  110 ITER = -ALOG10(ETA)
      DO 200 K=1,L
C K-TH RIGHT-HAND SIDE.
        K0 = K4 - 1
        DO 120 I=1,M
          K0 = K0 + 1
          C(K0) = B(I,K)
  120   CONTINUE
C
        CALL SOLVE2(M, N, M1, A, C(K4), W, N1, IPIVOT, QR, C(K3),
     *   ETA, FAIL, NUMIT, DIGITX,
     *   C(K5), C(K6), C(K7), C(K8), C(K9), C(K10), C(K11), C(K12),
     *   MM, MMPNN)
C
        K0 = K5 - 1
        DO 130 J=1,N
          K0 = K0 + 1
          X(J,K) = C(K0)
  130   CONTINUE
        IF (M1.EQ.0) GO TO 150
        DO 140 I=1,M1
          RES(I,K) = 0.0
  140   CONTINUE
  150   M1P1 = M1 + 1
        IF (M1P1.GT.M) GO TO 170
        K0 = K6 + M1 - 1
        DO 160 I=M1P1,M
          K0 = K0 + 1
          RES(I,K) = C(K0)
  160   CONTINUE
  170   CONTINUE
C
C FOR RIGHT-HAND SIDES WHERE CONVERGENCE OF A SOLUTION IS REPORTED,
C A CHECK IS MADE FOR EVIDENCE OF SEVERE ILL-CONDITIONING.  SUCH
C EVIDENCE IS FURNISHED BY LARGE VALUES OF NUMIT (NUMBER OF ITERATIONS
C BEFORE CONVERGENCE WAS OBTAINED) AND SMALL VALUES OF DIGITX
C (ESTIMATE OF THE NUMBER OF CORRECT DIGITS IN THE INITIAL SOLUTION
C OF THE COEFFICIENTS).  IF NUMIT EXCEEDS -ALOG10(ETA) THEN IFAULT
C IS SET TO 9.  IF DIGITX IS LESS THAN 0.5 (HALF A DECIMAL DIGIT)
C THEN IFAULT IS SET TO 10.
C
        C(K) = FLOAT(NUMIT)
        IF (FAIL) C(K) = -C(K)
        K0 = K2 + K - 1
        C(K0) = DIGITX
        IF (.NOT.FAIL) GO TO 180
C KSUM IS A TALLY OF SOLUTIONS WHICH FAILED TO CONVERGE.
        KSUM = KSUM + 1
        IFAULT = 8
        GO TO 200
  180   IF (NUMIT.LE.ITER) GO TO 190
        IFAULT = 9
  190   IF (DIGITX.GE.0.5) GO TO 200
        IFAULT = 10
  200 CONTINUE
      IF (KSUM.LT.L) GO TO 210
      IFAULT = 7
      RETURN
  210 IF (N1.LT.N) RETURN
      DO 230 I=1,N
        MPI = M + I
        DO 220 J=1,N
          QR(I,J) = QR(MPI,J)
  220   CONTINUE
        QR(I,I) = 0.0
  230 CONTINUE
C
C COMPUTE THE UNSCALED COVARIANCE MATRIX OF THE COEFFICIENTS.
C
      CALL COVAR(N, M1, N1, IPIVOT, QR, C(K3), C(K9), MMPNN)
      IF (N.EQ.1) GO TO 260
      DO 250 J=2,N
      JM1 = J - 1
        DO 240 I=1,JM1
  240   QR(I,J) = QR(J,I)
  250 CONTINUE
C
C IN CERTAIN PROBLEMS, SOME DIAGONAL TERMS OF THE UNSCALED COVARIANCE
C MATRIX ARE EQUAL TO ZERO OR TO SMALL POSITIVE NUMBERS.  BECAUSE OF
C ROUNDING ERRORS, COMPUTED VALUES FOR THESE TERMS MAY BE SMALL
C NEGATIVE NUMBERS.  IFAULT IS SET TO 11 IF THIS OCCURS.
C
  260 DO 270 J=1,N
        IF (QR(J,J).LT.0.0) GO TO 280
  270 CONTINUE
      RETURN
  280 IF (IFAULT.NE.0) GO TO 290
      IFAULT = 11
      RETURN
  290 IFAULT = 12
      RETURN
      END
C     SUBROUTINE DECOM2(...)
C SUBROUTINE DECOM2 USES A MODIFIED GRAM-SCHMIDT ALGORITHM WITH
C PIVOTING TO OBTAIN AN ORTHOGONAL DECOMPOSITION OF THE INPUT MATRIX
C GIVEN IN QR.
C THE INPUT PARAMETER TOL (EQUAL EITHER TO ZERO OR TO A POSITIVE
C NUMBER) IS USED IN DETERMINING THE RANK OF MATRIX QR.
C NOTE --
C     (1) IF TOL EQUALS ZERO, THE TOLERANCE USED AT STATEMENT DC2 1180
C         WILL BE BASED ON MACHINE PRECISION.
C         UNDER THIS APPROACH, THE TOLERANCE (TOL2) IS SET EQUAL TO
C         (FLOAT(N)*ETA)**2*D(M1+1) AT STATEMENT DC2 1170.
C         IF DESIRED, THE USER CAN OBTAIN A MORE CONSERVATIVE
C         TOLERANCE BY REPLACING N IN THIS STATEMENT BY A LARGER
C         QUANTITY.
C     (2) IF TOL IS GREATER THAN ZERO, TOL2 (WHICH IS SET EQUAL TO
C         TOL) WILL BE USED AT STATEMENT DC2 1180 AS AN ABSOLUTE
C         TOLERANCE FOR COMPARISON WITH DIAGONAL ELEMENTS OF THE
C         TRIANGULAR MATRIX OBTAINED IN THE DECOMPOSITION.  UNDER THIS
C         APPROACH, THE VALUE OF TOL CAN BE BASED ON KNOWLEDGE
C         CONCERNING THE ACCURACY OF THE DATA.
C ON EXIT, THE ARRAYS QR, D AND IPIVOT CONTAIN THE RESULTS OF THE
C DECOMPOSITION WHICH ARE NEEDED FOR OBTAINING AN INITIAL SOLUTION
C AND FOR ITERATIVE REFINEMENT.
C ON EXIT, N1 IS THE COMPUTED RANK OF THE INPUT MATRIX QR.
C ON EXIT, SING IS SET EQUAL TO .TRUE. WHENEVER
C     (1) N1 = 0 (I.E., INPUT MATRIX QR EQUALS ZERO OR MATRIX OF
C         CONSTRAINTS EQUALS ZERO), OR
C     (2) N1 IS LESS THAN M1 (I.E., THE M1 BY N MATRIX OF LINEAR
C         CONSTRAINTS IS SINGULAR).
C OTHERWISE, ON EXIT FROM DECOM2, SING = .FALSE.
C ON EXIT, THE VECTOR IPIVOT RECORDS THE ORDER IN WHICH THE COLUMNS
C OF QR WERE SELECTED BY THE PIVOTING SCHEME IN THE COURSE OF THE
C ORTHOGONAL DECOMPOSITION.
      SUBROUTINE DECOM2(M, N, M1, ETA, TOL, QR, D, N1, IPIVOT, SING,
     * MMPNN)
      INTEGER IPIVOT(N)
      REAL C, D(*), DM, DS, ETA, QR(MMPNN,N), RSJ, TOL, TOL2
      DOUBLE PRECISION SUM
      LOGICAL FINIS, FSUM, SING
      N1 = 0
      SING = .TRUE.
      FSUM = .TRUE.
      MV = 1
      MH = M1
      MS = M
      MP1 = M + 1
      FINIS = .FALSE.
      IF (TOL.GT.0.0) TOL2 = TOL
      DO 10 J=1,N
        D(J) = 0.0
        IPIVOT(J) = J
   10 CONTINUE
C STEP NUMBER NS OF THE DECOMPOSITION.
      DO 350 NS=1,N
        K = M + NS
        IF (NS.EQ.M1+1) GO TO 20
        GO TO 30
   20   IF (M1.EQ.M) GO TO 200
        MV = M1 + 1
        MH = M
        FSUM = .TRUE.
   30   IF (.NOT.FINIS) GO TO 40
        GO TO 150
C PIVOT SEARCH.
   40   DS = 0.0
        NP = NS
        DO 90 J=NS,N
          IF (FSUM) GO TO 50
          GO TO 70
   50     SUM = 0.0
          DO 60 L=MV,MH
            SUM = SUM + DBLE(QR(L,J))*DBLE(QR(L,J))
   60     CONTINUE
          D(J) = SUM
   70     IF (DS.LT.D(J)) GO TO 80
          GO TO 90
   80     DS = D(J)
          NP = J
   90   CONTINUE
        IF (FSUM) DM = DS
        IF (DS.LT.ETA*DM) GO TO 100
        FSUM = .FALSE.
        GO TO 110
  100   FSUM = .TRUE.
  110   IF (FSUM) GO TO 40
        IF (NP.NE.NS) GO TO 120
        GO TO 140
C COLUMN INTERCHANGE.
  120   IK = IPIVOT(NP)
        IPIVOT(NP) = IPIVOT(NS)
        IPIVOT(NS) = IK
        D(NP) = D(NS)
        KM1 = K - 1
        DO 130 L=1,KM1
          C = QR(L,NP)
          QR(L,NP) = QR(L,NS)
          QR(L,NS) = C
  130   CONTINUE
C END COLUMN INTERCHANGE.
C END PIVOT SEARCH.
C RETURN HERE IF N1 = 0.  EITHER INPUT MATRIX QR EQUALS ZERO OR
C MATRIX OF CONSTRAINTS EQUALS ZERO.
  140   IF (NS.EQ.1 .AND. DS.EQ.0.0) RETURN
        GO TO 160
  150   MS = K - 1
        MH = K - 1
  160   IF (FINIS) GO TO 170
        C = 0.0
        GO TO 180
  170   C = 1.0
  180   SUM = DBLE(C)
        DO 190 L=MV,MH
          SUM = SUM + DBLE(QR(L,NS))*DBLE(QR(L,NS))
  190   CONTINUE
        D(NS) = SUM
        DS = D(NS)
        IF (TOL.EQ.0.0) TOL2 = (FLOAT(N)*ETA)**2*D(M1+1)
        IF (.NOT.FINIS .AND. NS.GT.M1 .AND. DS.LE.TOL2) GO TO 200
        GO TO 290
  200   FINIS = .TRUE.
        MV = M + 1
        DO 280 NP=NS,N
          IF (1.GT.M1) GO TO 250
          DO 210 L=1,M1
            QR(L,NP) = 0.0
  210     CONTINUE
          DO 240 J=1,M1
            SUM = 0.0
            DO 220 L=1,M
              SUM = SUM + DBLE(QR(L,J))*DBLE(QR(L,NP))
  220       CONTINUE
            C = SUM
            C = C/D(J)
            DO 230 L=1,M1
              QR(L,NP) = QR(L,NP) - C*QR(L,J)
  230       CONTINUE
  240     CONTINUE
  250     MPN1 = M + N1
          DO 270 JJ=MP1,MPN1
            J = (M + 1) + (M + N1) - JJ
            SUM = 0.0
            DO 260 L=J,MPN1
              LMM = L - M
              SUM = SUM + DBLE(QR(J,LMM))*DBLE(QR(L,NP))
  260       CONTINUE
            QR(J,NP) = -SUM
  270     CONTINUE
  280   CONTINUE
        GO TO 150
C RETURN HERE IF MATRIX OF CONSTRAINTS IS FOUND TO BE SINGULAR.
  290   IF (DS.EQ.0.0) RETURN
        QR(K,NS) = -1.0
        NSP1 = NS + 1
        IF (NSP1.GT.N) GO TO 340
C BEGIN ORTHOGONALIZATION.
        DO 330 J=NSP1,N
          SUM = 0.0
          DO 300 L=MV,MH
            SUM = SUM + DBLE(QR(L,J))*DBLE(QR(L,NS))
  300     CONTINUE
          RSJ = SUM
          RSJ = RSJ/DS
          QR(K,J) = RSJ
          DO 310 L=1,MS
            QR(L,J) = QR(L,J) - RSJ*QR(L,NS)
  310     CONTINUE
          IF (.NOT.FINIS) GO TO 320
          GO TO 330
  320     D(J) = D(J) - DS*RSJ*RSJ
  330   CONTINUE
C END ORTHOGONALIZATION.
  340   IF (.NOT.FINIS) N1 = N1 + 1
  350 CONTINUE
C END STEP NUMBER NS.
      SING = .FALSE.
C NORMAL RETURN.
      RETURN
      END
C     SUBROUTINE SOLVE2(...)
C SUBROUTINE SOLVE2 USES THE ORTHOGONAL DECOMPOSITION STORED IN QR, D
C AND IPIVOT TO COMPUTE THE SOLUTION (COEFFICIENTS AND RESIDUALS)
C TO THE LEAST SQUARES PROBLEM WHOSE RIGHT-HAND SIDE IS GIVEN IN B.
C IN THE EVENT THAT N1 (THE COMPUTED RANK OF MATRIX H) IS LESS THAN N
C (THE NUMBER OF UNKNOWN COEFFICIENTS), A UNIQUE SOLUTION VECTOR HAVING
C N ELEMENTS CAN BE OBTAINED BY IMPOSING THE CONDITION THAT THE
C SOLUTION BE OF MINIMAL EUCLIDEAN NORM.  SUCH A SOLUTION IS SOUGHT IN
C THE CASE OF UNDERDETERMINED OR RANK-DEFICIENT PROBLEMS.
C IN NORMAL EXITS, THE SOLUTION IS CONTAINED IN THE VECTOR X
C (COEFFICIENTS) AND THE VECTOR RES (RESIDUALS).
C ITERATIVE REFINEMENT IS USED TO IMPROVE THE ACCURACY OF THE INITIAL
C SOLUTION.
C ON EXIT, FAIL IS SET EQUAL TO .TRUE. IF THE SOLUTION FAILS TO
C IMPROVE SUFFICIENTLY.  OTHERWISE, FAIL = .FALSE.  INFORMATION ON THE
C BEHAVIOR OF THE ITERATIVE REFINEMENT PROCEDURE IS GIVEN BY NUMIT AND
C DIGITX.  NUMIT IS THE NUMBER OF ITERATIONS CARRIED OUT IN ATTEMPTING
C TO OBTAIN A SOLUTION.  DIGITX IS AN ESTIMATE OF THE NUMBER OF
C CORRECT DIGITS IN THE INITIAL SOLUTION OF THE COEFFICIENTS.
C THIS SUBROUTINE CALLS SUBROUTINE SOLVE3.
C
C ********* CONVERSION OF THIS SUBROUTINE TO DOUBLE PRECISION *********
C * IF THE PROGRAM IS CONVERTED SO THAT ALL CALCULATIONS ARE DONE IN  *
C * DOUBLE PRECISION ARITHMETIC, THE ITERATIVE REFINEMENT PRESENTLY   *
C * INCLUDED IN SOLVE2 SHOULD BE OMITTED, SINCE THE SUCCESS OF THIS   *
C * PROCEDURE DEPENDS ON COMPUTING INNER PRODUCTS IN GREATER          *
C * PRECISION THAN OTHER CALCULATIONS.                                *
C * SEE COMMENTS IN SUBROUTINE L2SLV REGARDING CONVERSION TO DOUBLE   *
C * PRECISION.  IN ADDITION, THE FOLLOWING COMMENTS INDICATE HOW TO   *
C * OMIT THE ITERATIVE REFINEMENT FROM THIS SUBROUTINE.  STATEMENT    *
C * NUMBERS GIVEN HERE REFER TO THOSE IN THE RIGHT-HAND MARGIN.       *
C *                                                                   *
C * 1. IN STATEMENT SV2 470 CHANGE REAL TO DOUBLE PRECISION.          *
C * 2. REPLACE STATEMENT SV2 880 BY A STATEMENT READING               *
C *       30 DO 50 I=1,M                                              *
C * 3. REPLACE STATEMENTS SV2 1310-1400 BY A STATEMENT READING        *
C *          RETURN                                                   *
C * 4. OMIT STATEMENTS SV2 120-190, 440, 490-500, 520-550, 650,       *
C *    750-850, 1650-1830 AND 1850-1910.                              *
C *                                                                   *
C *********************************************************************
C
      SUBROUTINE SOLVE2(M, N, M1, A, B, W, N1, IPIVOT, QR, D,
     * ETA, FAIL, NUMIT, DIGITX,
     * X, RES, WRES, Y1, Y2, Y, F, G, MM, MMPNN)
      INTEGER IPIVOT(N)
      REAL A(MM,N), B(*), C, D(*), F(*), G(*),
     * QR(MMPNN,N), RES(*), W(M), WRES(*), X(*), Y(*), Y1(*), Y2(*)
      REAL DIGITX, DXNORM, ETA, ETA2, RDR1, RDR2, RDX1, RDX2, RNR,
     * RNX, XNORM
      DOUBLE PRECISION SUM
      LOGICAL FAIL
      NUMIT = 0
      KZ = 0
      ETA2 = ETA*ETA
      MP1 = M + 1
      MPN = M + N
      N1P1 = N1 + 1
      DO 10 I=1,M
        F(I) = B(I)*W(I)
        G(I) = 0.0
        WRES(I) = 0.0
        RES(I) = 0.0
        Y1(I) = 0.0
        IF (W(I).EQ.0.0) KZ = KZ + 1
   10 CONTINUE
      DO 20 NS=1,N
        J = M + NS
        F(J) = 0.0
        G(J) = 0.0
        X(NS) = 0.0
        Y2(NS) = 0.0
   20 CONTINUE
      K = 0
      RDX2 = 0.0
      RDR2 = 0.0
C BEGIN K-TH ITERATION STEP.
   30 IF (K.LT.2) GO TO 40
      IF (((64.*RDX2.LT.RDX1) .AND. (RDX2.GT.ETA2*RNX)) .OR.
     * ((64.*RDR2.LT.RDR1) .AND. (RDR2.GT.ETA2*RNR))) GO TO 40
      GO TO 270
   40 RDX1 = RDX2
      RDR1 = RDR2
      RDX2 = 0.0
      RDR2 = 0.0
      IF (K.EQ.0) GO TO 160
C NEW RESIDUALS.
      DO 50 I=1,M
        WRES(I) = WRES(I) + F(I)*W(I)
        IF (W(I).EQ.0.0) GO TO 50
        RES(I) = RES(I) + F(I)/W(I)
        Y1(I) = Y1(I) + G(I)
   50 CONTINUE
      DO 100 NS=1,N
        J = M + NS
        NP = IPIVOT(NS)
        X(NP) = X(NP) + F(J)
        Y2(NP) = Y2(NP) + G(J)
        SUM = -DBLE(X(NP))
        DO 60 L=1,M
          SUM = SUM + DBLE(A(L,NP))*DBLE(Y1(L))
   60   CONTINUE
        G(J) = -SUM
        IF (NS.GT.N1) GO TO 70
        GO TO 80
   70   F(J) = 0.0
        GO TO 100
   80   SUM = 0.0
        DO 90 L=1,M
          SUM = SUM + DBLE(A(L,NP))*DBLE(WRES(L))
   90   CONTINUE
        F(J) = -SUM
  100 CONTINUE
      DO 130 I=1,M
        SUM = 0.0
        IF (I.GT.M1) SUM = DBLE(RES(I))
        DO 110 L=1,N
          SUM = SUM + DBLE(A(I,L))*DBLE(X(L))
  110   CONTINUE
        SUM = SUM - DBLE(B(I))
        F(I) = -SUM
        F(I) = F(I)*W(I)
        IF (W(I).EQ.0.0) RES(I) = DBLE(RES(I)) - SUM
        SUM = 0.0
        IF (I.GT.M1) SUM = DBLE(Y1(I))
        DO 120 L=1,N
          SUM = SUM + DBLE(A(I,L))*DBLE(Y2(L))
  120   CONTINUE
        G(I) = -SUM
  130 CONTINUE
      IF (N1P1.GT.N) GO TO 160
      DO 150 I=N1P1,N
        NS = N + N1P1 - I
        J = M + NS
        SUM = 0.0
        DO 140 L=1,J
          SUM = SUM + DBLE(QR(L,NS))*DBLE(G(L))
  140   CONTINUE
        G(J) = SUM
  150 CONTINUE
C END NEW RESIDUALS.
C
  160 CALL SOLVE3(F, M1, M, N1, QR, D, Y, MMPNN)
C
      IF (N1P1.GT.N) GO TO 200
      DO 190 NS=N1P1,N
        J = M + NS
        SUM = DBLE(G(J))
        DO 170 L=MP1,J
          SUM = SUM + DBLE(QR(L,NS))*DBLE(F(L))
  170   CONTINUE
        C = SUM
        C = C/D(NS)
        DO 180 I=1,J
          F(I) = F(I) - C*QR(I,NS)
  180   CONTINUE
  190 CONTINUE
  200 DO 210 J=MP1,MPN
        G(J) = 0.0
        IF (J.LE.M+N1) G(J) = G(J) + F(J)
  210 CONTINUE
C
      CALL SOLVE3(G, M1, M, N1, QR, D, Y, MMPNN)
C
      DO 220 I=1,M
        RDR2 = RDR2 + F(I)*F(I)
  220 CONTINUE
      DO 230 I=MP1,MPN
        RDX2 = RDX2 + F(I)*F(I)
  230 CONTINUE
      IF (K.NE.0) GO TO 240
      RNR = RDR2
      RNX = RDX2
  240 IF (K.NE.1) GO TO 260
      XNORM = SQRT(RNX)
      DXNORM = SQRT(RDX2)
      IF (XNORM.NE.0.0) GO TO 250
      DIGITX = -ALOG10(ETA)
      GO TO 260
  250 DIGITX = -ALOG10(AMAX1(DXNORM/XNORM,ETA))
C END K-TH ITERATION STEP.
  260 NUMIT = K
      K = K + 1
      GO TO 30
  270 IF ((M1+KZ.EQ.M) .AND. (RDX2.GT.4.*ETA2*RNX)) GO TO 280
      IF ((RDR2.GT.4.*ETA2*RNR) .AND.
     * (RDX2.GT.4.*ETA2*RNX)) GO TO 280
      FAIL = .FALSE.
      RETURN
  280 FAIL = .TRUE.
      RETURN
      END
      SUBROUTINE SOLVE3(F, M1, M, N1, QR, D, Y, MMPNN)
C SUBROUTINE SOLVE3 IS CALLED ONLY BY SUBROUTINE SOLVE2.
C THIS SUBROUTINE CALCULATES NEW VALUES OF F.
      REAL C, D(*), F(*), QR(MMPNN,N1), Y(*)
      DOUBLE PRECISION SUM
      MV = 1
      MH = M1
      DO 100 NS=1,N1
        J = M + NS
        IF (NS.EQ.M1+1) GO TO 10
        GO TO 20
   10   MV = M1 + 1
        MH = M
   20   NSM1 = NS - 1
        SUM = -DBLE(F(J))
        IF (NS.EQ.1) GO TO 40
        DO 30 L=1,NSM1
          MPL = M + L
          SUM = SUM + DBLE(QR(MPL,NS))*DBLE(Y(L))
   30   CONTINUE
   40   Y(NS) = -SUM
        IF (NS.GT.M1) GO TO 50
        GO TO 60
   50   C = -Y(NS)
        GO TO 70
   60   C = 0.0
   70   SUM = DBLE(C)
        DO 80 L=MV,MH
          SUM = SUM + DBLE(QR(L,NS))*DBLE(F(L))
   80   CONTINUE
        C = SUM
        C = C/D(NS)
        F(J) = C
        DO 90 L=MV,M
          F(L) = F(L) - C*QR(L,NS)
   90   CONTINUE
  100 CONTINUE
      IF (1.GT.M1) GO TO 150
      DO 110 L=1,M1
        F(L) = 0.0
  110 CONTINUE
      DO 140 NS=1,M1
        SUM = -DBLE(Y(NS))
        DO 120 L=1,M
          SUM = SUM + DBLE(QR(L,NS))*DBLE(F(L))
  120   CONTINUE
        C = SUM
        C = C/D(NS)
        DO 130 L=1,M1
          F(L) = F(L) - C*QR(L,NS)
  130   CONTINUE
  140 CONTINUE
  150 DO 170 NS=1,N1
        J = M + N1 + 1 - NS
        MPN1 = M + N1
        SUM = 0.0
        DO 160 L=J,MPN1
          LMM = L - M
          SUM = SUM + DBLE(QR(J,LMM))*DBLE(F(L))
  160   CONTINUE
        F(J) = -SUM
  170 CONTINUE
      RETURN
      END
      SUBROUTINE COVAR(N, M1, N1, IPIVOT, C, D, Z, NN)
C SUBROUTINE COVAR USES RESULTS FROM THE ORTHOGONAL DECOMPOSITION
C STORED IN C, D AND IPIVOT TO COMPUTE THE UNSCALED COVARIANCE MATRIX
C OF THE LEAST SQUARES COEFFICIENTS.
C ON ENTRY, THE FIRST N ROWS AND THE FIRST N COLUMNS OF C CONTAIN THE
C UPPER TRIANGULAR MATRIX OBTAINED FROM THE DECOMPOSITION.  THIS INPUT
C MATRIX IS DESTROYED IN SUBSEQUENT CALCULATIONS.
C ON EXIT, THE LOWER TRIANGULAR PORTION OF THE SYMMETRIC UNSCALED
C COVARIANCE MATRIX IS CONTAINED IN
C     C(1,1)
C     C(2,1) C(2,2)
C     . . .
C     C(N,1) C(N,2) ... C(N,N)
C IF N1 IS LESS THAN N, ONE OR MORE COLUMNS OF THE MATRIX
C H = (SQRT(W))*A WERE REJECTED AS BEING LINEARLY DEPENDENT.  WHENEVER
C THE K-TH COLUMN OF H WAS SO REJECTED, C(I,J) IS SET EQUAL TO ZERO,
C FOR I = K OR J = K, I.GE.J.
      INTEGER IPIVOT(N)
      REAL C(NN,N), D(*), Z(*)
      DOUBLE PRECISION SUM
      L = N1
      IF (L.GT.M1) C(L,L) = 1.0/D(L)
      IF (L.EQ.1) GO TO 60
   10 J = L - 1
      IF (J.GT.M1) C(J,J) = 1.0/D(J)
      DO 20 K=L,N1
        Z(K) = C(J,K)
   20 CONTINUE
      I = N1
      DO 40 KA=J,N1
        SUM = 0.0
        IF (I.EQ.J) SUM = DBLE(C(I,J))
        DO 30 K=L,N1
          SUM = SUM - DBLE(Z(K))*DBLE(C(K,I))
   30   CONTINUE
        C(I,J) = SUM
        I = I - 1
   40 CONTINUE
      DO 50 K=L,N1
        C(J,K) = C(K,J)
   50 CONTINUE
      L = L - 1
      IF (L.GT.1) GO TO 10
   60 IF (N1.EQ.N) GO TO 90
      N1P1 = N1 + 1
      DO 80 I=1,N
        DO 70 J=N1P1,N
          C(I,J) = 0.0
   70   CONTINUE
   80 CONTINUE
C PERMUTE THE COLUMNS AND ROWS OF MATRIX C TO ACCOUNT FOR PIVOTING.
   90 DO 120 I=1,N
        DO 100 J=1,N
          K = IPIVOT(J)
          Z(K) = C(I,J)
  100   CONTINUE
        DO 110 J=1,N
          C(I,J) = Z(J)
  110   CONTINUE
  120 CONTINUE
      DO 150 I=1,N
        DO 130 J=1,N
          K = IPIVOT(J)
          Z(K) = C(J,I)
  130   CONTINUE
        DO 140 J=I,N
          C(J,I) = Z(J)
  140   CONTINUE
  150 CONTINUE
      RETURN
      END
      SUBROUTINE SPLSQ(M,N,A,IA,JA,DAMP,U,X,ATOL,BTOL,CONLIM,ITNLIM,
     *                     ISTOP,ITN,ACOND,RNORM,XNORM,W)
C
      INTEGER M,N,ITNLIM,ISTOP
      INTEGER IA(*),JA(*)
      REAL    A(*),DAMP,U(M),X(N),ATOL,BTOL,CONLIM,
     *        ACOND,RNORM,XNORM,W(*)
C     ------------------------------------------------------------------
C
C     SPLSQ FINDS A SOLUTION X TO THE FOLLOWING PROBLEMS ...
C
C     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*X = B
C
C     2. LINEAR LEAST SQUARES  --    SOLVE  A*X = B
C                                    IN THE LEAST-SQUARES SENSE
C
C     3. DAMPED LEAST SQUARES  --    SOLVE  (   A    )*X = ( B )
C                                           ( DAMP*I )     ( 0 )
C                                    IN THE LEAST-SQUARES SENSE
C
C     WHERE A IS A MATRIX WITH M ROWS AND N COLUMNS, B AN M-VECTOR,
C     AND DAMP A SCALAR. (ALL QUANTITIES ARE REAL.) THE MATRIX A IS
C     A SPARSE MATRIX STORED ROWWISE IN THE ARRAYS A,IA,JA.
C
C     THE RHS VECTOR B IS INPUT VIA U, AND IS SUBSEQUENTLY OVERWRITTEN.
C
C
C     NOTE. SPLSQ USES AN ITERATIVE METHOD TO APPROXIMATE THE SOLUTION.
C     THE NUMBER OF ITERATIONS REQUIRED TO REACH A CERTAIN ACCURACY
C     DEPENDS STRONGLY ON THE SCALING OF THE PROBLEM. POOR SCALING OF
C     THE ROWS OR COLUMNS OF A SHOULD THEREFORE BE AVOIDED WHENEVER
C     POSSIBLE.
C
C     FOR EXAMPLE, IN PROBLEM 1 THE SOLUTION IS UNALTERED BY
C     ROW-SCALING.  IF A ROW OF A IS VERY SMALL OR LARGE COMPARED TO
C     THE OTHER ROWS OF A, THE CORRESPONDING ROW OF (A  B) SHOULD BE
C     SCALED UP OR DOWN.
C
C     IN PROBLEMS 1 AND 2, THE SOLUTION X IS EASILY RECOVERED
C     FOLLOWING COLUMN SCALING. IN THE ABSENCE OF BETTER INFORMATION,
C     THE NONZERO COLUMNS OF A SHOULD BE SCALED SO THAT THEY ALL HAVE
C     THE SAME EUCLIDEAN NORM (E.G.  1.0).
C
C     IN PROBLEM 3, THERE IS NO FREEDOM TO RE-SCALE IF DAMP IS
C     NONZERO. HOWEVER, THE VALUE OF DAMP SHOULD BE ASSIGNED ONLY
C     AFTER ATTENTION HAS BEEN PAID TO THE SCALING OF A.
C
C     THE PARAMETER DAMP IS INTENDED TO HELP REGULARIZE
C     ILL-CONDITIONED SYSTEMS, BY PREVENTING THE TRUE SOLUTION FROM
C     BEING VERY LARGE. ANOTHER AID TO REGULARIZATION IS PROVIDED BY
C     THE PARAMETER ACOND, WHICH MAY BE USED TO TERMINATE ITERATIONS
C     BEFORE THE COMPUTED SOLUTION BECOMES VERY LARGE.
C
C
C     NOTATION
C     --------
C
C     THE FOLLOWING QUANTITIES ARE USED IN DISCUSSING THE SUBROUTINE
C     PARAMETERS...
C
C     ABAR   =  (   A    ),          BBAR  =  ( B )
C               ( DAMP*I )                    ( 0 )
C
C     R      =  B  -  A*X,           RBAR  =  BBAR  -  ABAR*X
C
C     RNORM  =  SQRT( NORM(R)**2  +  DAMP**2 * NORM(X)**2 )
C            =  NORM( RBAR )
C
C     RELPR  =  THE SMALLEST FLOATING POINT NUMBER FOR WHICH
C               1 + RELPR .GT. 1.
C
C     SPLSQ  MINIMIZES THE FUNCTION RNORM WITH RESPECT TO X.
C
C
C     PARAMETERS
C     ----------
C
C     M       INPUT      THE NUMBER OF ROWS IN A.
C
C     N       INPUT      THE NUMBER OF COLUMNS IN A.
C
C     A,IA,JA INPUT      THE MATRIX A STORED ROWWISE IN SPARSE FORM.
C
C     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
C                        (DAMP  SHOULD BE 0.0 FOR PROBLEMS 1 AND 2.)
C                        IF THE SYSTEM  A*X = B  IS INCOMPATIBLE, VALUES
C                        OF DAMP IN THE RANGE 0 TO SQRT(RELPR)*NORM(A)
C                        WILL PROBABLY HAVE A NEGLIGIBLE EFFECT.
C                        LARGER VALUES OF DAMP WILL TEND TO DECREASE
C                        THE NORM OF X AND TO REDUCE THE NUMBER OF
C                        ITERATIONS REQUIRED BY SPLSQ.
C
C                        THE WORK PER ITERATION AND THE STORAGE NEEDED
C                        BY SPLSQ ARE THE SAME FOR ALL VALUES OF DAMP.
C
C     U(M)    INPUT      THE RHS VECTOR B. BE AWARE THAT U IS
C                        OVER-WRITTEN BY SPLSQ.
C
C     X(N)    OUTPUT     RETURNS THE COMPUTED SOLUTION X.
C
C     ATOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
C                        DEFINING THE MATRIX A. FOR EXAMPLE,
C                        IF A IS ACCURATE TO ABOUT 6 DIGITS, SET
C                        ATOL = 1.0E-6 .
C
C     BTOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
C                        DEFINING THE RHS VECTOR B. FOR EXAMPLE,
C                        IF B IS ACCURATE TO ABOUT 6 DIGITS, SET
C                        BTOL = 1.0E-6 .
C
C     CONLIM  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
C                        CONDITION NUMBER OF THE MATRIX ABAR.
C                        ITERATIONS WILL BE TERMINATED IF A COMPUTED
C                        ESTIMATE OF COND(ABAR) EXCEEDS CONLIM.
C                        THIS IS INTENDED TO PREVENT CERTAIN SMALL OR
C                        ZERO SINGULAR VALUES OF A OR ABAR FROM
C                        COMING INTO EFFECT AND CAUSING UNWANTED GROWTH
C                        IN THE COMPUTED SOLUTION.
C
C                        CONLIM AND DAMP MAY BE USED SEPARATELY OR
C                        TOGETHER TO REGULARIZE ILL-CONDITIONED SYSTEMS.
C
C                        NORMALLY, CONLIM SHOULD BE IN THE RANGE
C                        1000  TO  1/RELPR.
C                        SUGGESTED VALUE --
C                        CONLIM = 1/(100*RELPR)  FOR COMPATIBLE SYSTEMS,
C                        CONLIM = 1/(10*SQRT(RELPR))  FOR LEAST SQUARES.
C
C             NOTE. IF THE USER IS NOT CONCERNED ABOUT THE PARAMETERS
C             ATOL, BTOL, AND CONLIM, ANY OR ALL OF THEM MAY BE SET
C             TO ZERO. THE EFFECT WILL BE THE SAME AS THE VALUES
C             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
C
C     ITNLIM  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
C                        SUGGESTED VALUE --
C                        ITNLIM = N/2     FOR WELL CONDITIONED SYSTEMS,
C                        ITNLIM = 4*N     OTHERWISE.
C
C     ISTOP   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
C
C                0       X = 0  IS THE EXACT SOLUTION.
C                        NO ITERATIONS WERE PERFORMED.
C
C                1       THE EQUATIONS  A*X = B  ARE PROBABLY
C                        COMPATIBLE. NORM(A*X - B) IS SUFFICIENTLY
C                        SMALL, GIVEN THE VALUES OF ATOL AND BTOL.
C
C                2       THE SYSTEM  A*X = B  IS PROBABLY NOT
C                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
C                        BEEN OBTAINED WHICH IS SUFFICIENTLY ACCURATE,
C                        GIVEN THE VALUE OF ATOL.
C
C                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
C                        CONLIM. THE SYSTEM  A*X = B  APPEARS TO BE
C                        ILL-CONDITIONED.
C
C                4       THE EQUATIONS  A*X = B  ARE PROBABLY
C                        COMPATIBLE. NORM(A*X - B) IS AS SMALL AS
C                        SEEMS REASONABLE ON THIS MACHINE.
C
C                5       THE SYSTEM  A*X = B  IS PROBABLY NOT
C                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
C                        BEEN OBTAINED WHICH IS AS ACCURATE AS SEEMS
C                        REASONABLE ON THIS MACHINE.
C
C                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
C                        NOT MUCH POINT IN DOING FURTHER ITERATIONS,
C                        GIVEN THE PRECISION OF THIS MACHINE.
C
C                7       THE ITERATION LIMIT ITNLIM WAS REACHED.
C
C
C     ITN     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
C
C     ACOND   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
C                        NUMBER OF ABAR.
C
C     RNORM   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
C                        THE FUNCTION BEING MINIMIZED (SEE NOTATION
C                        ABOVE). THIS WILL BE SMALL IF  A*X = B  HAS
C                        A SOLUTION.
C
C     XNORM   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
C                        SOLUTION VECTOR X.
C
C     W(2*N)             WORKSPACE
C
C     ANORM   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
C                        THIS IS THE SQUARE ROOT OF THE SUM OF SQUARES
C                        OF THE ELEMENTS OF ABAR.
C                        IF DAMP IS SMALL AND IF THE COLUMNS OF A
C                        HAVE ALL BEEN SCALED TO HAVE LENGTH  1.0,
C                        ANORM SHOULD INCREASE TO ROUGHLY SQRT(N).
C
C     ARNORM  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
C                        NORM( ABAR(TRANSPOSE)*RBAR ), THE NORM OF
C                        THE RESIDUAL FOR THE USUAL NORMAL EQUATIONS.
C                        THIS SHOULD BE SMALL IN ALL CASES. (ARNORM
C                        WILL OFTEN BE SMALLER THAN THE TRUE VALUE
C                        COMPUTED FROM THE OUTPUT VECTOR X.)
C
C
C     SUBROUTINES AND FUNCTIONS USED
C     ------------------------------
C
C                NORMLZ,MVPRD1,MTPRD1
C     BLAS       SCOPY,SNRM2,SSCAL  (SEE LAWSON ET AL. BELOW)
C                (SNRM2 IS USED ONLY IN NORMLZ)
C     FORTRAN    ABS,SQRT
C
C
C     REFERENCES
C     ----------
C
C     PAIGE, C.C. AND SAUNDERS, M.A.  LSQR, AN ALGORITHM FOR SPARSE
C        LINEAR EQUATIONS AND SPARSE LEAST SQUARES.
C        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 8, 1 (MARCH 1982).
C
C     LAWSON, C.L., HANSON, R.J., KINCAID, D.R. AND KROGH, F.T.
C        BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE.
C        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 5, 3 (SEPT 1979),
C        308-323 AND 324-325.
C
C     ------------------------------------------------------------------
C
C     LOCAL VARIABLES
C
      INTEGER    I,ITN,NCONV,NSTOP
      REAL       ALFA,ANORM,ARNORM,BBNORM,BETA,BNORM,
     1           CS,CS1,CS2,CTOL,DAMPSQ,DDNORM,DELTA,
     2           GAMMA,GAMBAR,ONE,PHI,PHIBAR,PSI,
     3           RES1,RES2,RHO,RHOBAR,RHBAR1,RHBAR2,RHS,RTOL,
     4           SN,SN1,SN2,T,TAU,TEST1,TEST2,TEST3,
     5           THETA,T1,T2,T3,XXNORM,Z,ZBAR,ZERO
C
C
C     INITIALIZE.
C
      ZERO   = 0.0
      ONE    = 1.0
      CTOL   = ZERO
      IF (CONLIM .GT. ZERO) CTOL = ONE/CONLIM
      DAMPSQ = DAMP**2
      ANORM  = ZERO
      ACOND  = ZERO
      BBNORM = ZERO
      DDNORM = ZERO
      RES2   = ZERO
      XNORM  = ZERO
      XXNORM = ZERO
      CS2    = -ONE
      SN2    = ZERO
      Z      = ZERO
      ITN    = 0
      ISTOP  = 0
      NSTOP  = 0
C
      DO 10 I = 1, N
         W(I) = ZERO
         X(I) = ZERO
   10 CONTINUE
C
C     SET UP THE FIRST VECTORS FOR THE BIDIAGONALIZATION.
C     THESE SATISFY   BETA*U = B,   ALFA*W = A(TRANSPOSE)*U.
C
      CALL NORMLZ(M,U,BETA)
      CALL MTPRD1(M,N,A,IA,JA,U,W)
      CALL NORMLZ(N,W,ALFA)
      CALL SCOPY (N,W,1,W(N+1),1)
C
      RHOBAR = ALFA
      PHIBAR = BETA
      BNORM  = BETA
      RNORM  = BETA
      ARNORM = ALFA*BETA
      IF (ARNORM .LE. ZERO) GO TO 800
C
C     ------------------------------------------------------------------
C     MAIN ITERATION LOOP.
C     ------------------------------------------------------------------
  100 ITN = ITN + 1
C
C     PERFORM THE NEXT STEP OF THE BIDIAGONALIZATION TO OBTAIN THE
C     NEXT  BETA, U, ALFA, W.  THESE SATISFY THE RELATIONS
C                BETA*U  =  A*W  -  ALFA*U,
C                ALFA*W  =  A(TRANSPOSE)*U  -  BETA*W.
C
      CALL SSCAL (M,(-ALFA),U,1)
      CALL MVPRD1(M,N,A,IA,JA,W,U)
      CALL NORMLZ(M,U,BETA)
      BBNORM = BBNORM + ALFA**2 + BETA**2 + DAMPSQ
      CALL SSCAL (N,(-BETA),W,1)
      CALL MTPRD1(M,N,A,IA,JA,U,W)
      CALL NORMLZ(N,W,ALFA)
C
C
C     USE A PLANE ROTATION TO ELIMINATE THE DAMPING PARAMETER.
C     THIS ALTERS THE DIAGONAL (RHOBAR) OF THE LOWER-BIDIAGONAL MATRIX.
C
      RHBAR2 = RHOBAR**2 + DAMPSQ
      RHBAR1 = SQRT(RHBAR2)
      CS1    = RHOBAR/RHBAR1
      SN1    = DAMP/RHBAR1
      PSI    = SN1*PHIBAR
      PHIBAR = CS1*PHIBAR
C
C
C     USE A PLANE ROTATION TO ELIMINATE THE SUBDIAGONAL ELEMENT (BETA)
C     OF THE LOWER-BIDIAGONAL MATRIX, GIVING AN UPPER-BIDIAGONAL MATRIX.
C
      RHO    = SQRT(RHBAR2 + BETA**2)
      CS     = RHBAR1/RHO
      SN     = BETA/RHO
      THETA  =  SN*ALFA
      RHOBAR = -CS*ALFA
      PHI    =  CS*PHIBAR
      PHIBAR =  SN*PHIBAR
      TAU    =  SN*PHI
C
C
C     UPDATE X AND W(N+1),...,W(2*N)
C
      T1 =    PHI/RHO
      T2 = -THETA/RHO
      T3 =    ONE/RHO
C
      DO 200 I = 1, N
         NPI   = N + I
         T     = W(NPI)
         X(I)  = T1*T + X(I)
         W(NPI)= T2*T + W(I)
         T     =(T3*T)**2
         DDNORM= T + DDNORM
  200 CONTINUE
C
C
C     USE A PLANE ROTATION ON THE RIGHT TO ELIMINATE THE
C     SUPER-DIAGONAL ELEMENT (THETA) OF THE UPPER-BIDIAGONAL MATRIX.
C     THEN USE THE RESULT TO ESTIMATE NORM(X).
C
      DELTA  =  SN2*RHO
      GAMBAR = -CS2*RHO
      RHS    = PHI - DELTA*Z
      ZBAR   = RHS/GAMBAR
      XNORM  = SQRT(XXNORM + ZBAR**2)
      GAMMA  = SQRT(GAMBAR**2 + THETA**2)
      CS2    = GAMBAR/GAMMA
      SN2    = THETA/GAMMA
      Z      = RHS/GAMMA
      XXNORM = XXNORM + Z**2
C
C
C     TEST FOR CONVERGENCE.
C     FIRST, ESTIMATE THE NORM AND CONDITION OF THE MATRIX ABAR,
C     AND THE NORMS OF RBAR AND ABAR(TRANSPOSE)*RBAR.
C
      ANORM  = SQRT(BBNORM)
      ACOND  = ANORM*SQRT(DDNORM)
      RES1   = PHIBAR**2
      RES2   = RES2 + PSI**2
      RNORM  = SQRT(RES1 + RES2)
      ARNORM = ALFA*ABS(TAU)
C
C     NOW USE THESE NORMS TO ESTIMATE CERTAIN OTHER QUANTITIES,
C     SOME OF WHICH WILL BE SMALL NEAR A SOLUTION.
C
      TEST1  = RNORM/BNORM
      TEST2  = ARNORM/(ANORM*RNORM)
      TEST3  = ONE/ACOND
      T1     = TEST1/(ONE + ANORM*XNORM/BNORM)
      RTOL   = BTOL +  ATOL*ANORM*XNORM/BNORM
C
C     THE FOLLOWING TESTS GUARD AGAINST EXTREMELY SMALL VALUES OF
C     ATOL, BTOL, OR CTOL.  (THE USER MAY HAVE SET ANY OR ALL OF
C     THE PARAMETERS ATOL, BTOL, CONLIM TO ZERO.)
C     THE EFFECT IS EQUIVALENT TO THE NORMAL TESTS USING
C     ATOL = RELPR,  BTOL = RELPR,  CONLIM = 1/RELPR.
C
      T3 = ONE + TEST3
      T2 = ONE + TEST2
      T1 = ONE + T1
      IF (ITN .GE. ITNLIM) ISTOP = 7
      IF (T3  .LE. ONE   ) ISTOP = 6
      IF (T2  .LE. ONE   ) ISTOP = 5
      IF (T1  .LE. ONE   ) ISTOP = 4
C
C     ALLOW FOR TOLERANCES SET BY THE USER.
C
      IF (TEST3 .LE. CTOL) ISTOP = 3
      IF (TEST2 .LE. ATOL) ISTOP = 2
      IF (TEST1 .LE. RTOL) ISTOP = 1
C
C     STOP IF APPROPRIATE.
C     THE CONVERGENCE CRITERIA ARE REQUIRED TO BE MET ON  NCONV
C     CONSECUTIVE ITERATIONS, WHERE  NCONV  IS SET BELOW.
C     SUGGESTED VALUE --   NCONV = 1, 2  OR  3.
C
      IF (ISTOP .EQ. 0) NSTOP = 0
      IF (ISTOP .EQ. 0) GO TO 100
      NCONV = 1
      NSTOP = NSTOP + 1
      IF (NSTOP .LT. NCONV  .AND.  ITN .LT. ITNLIM) ISTOP = 0
      IF (ISTOP .EQ. 0) GO TO 100
C     ------------------------------------------------------------------
C     END OF ITERATION LOOP.
C     ------------------------------------------------------------------
C
  800 RETURN
      END
      SUBROUTINE NORMLZ(N,X,BETA)
      INTEGER N
      REAL X(N),BETA
C
C     NORMLZ COMPUTES THE EUCLIDEAN NORM OF X AND RETURNS THE
C     VALUE IN BETA. IF X IS NONZERO, THEN X IS RESCALED SO
C     THAT NORM(X) = 1.
C
C     FUNCTIONS AND SUBROUTINES
C
C     BLAS       SNRM2,SSCAL
C
      REAL       ONE,SNRM2,ZERO
C
      DATA ZERO/0.0/, ONE/1.0/
C
C
      BETA = SNRM2(N,X,1)
      IF (BETA .GT. ZERO) CALL SSCAL(N,(ONE/BETA),X,1)
      RETURN
      END
      SUBROUTINE STLSQ(M,N,TA,ITA,JTA,DAMP,U,X,ATOL,BTOL,CONLIM,
     *                 ITNLIM,ISTOP,ITN,ACOND,RNORM,XNORM,W)
C
      INTEGER M,N,ITNLIM,ISTOP
      INTEGER ITA(*),JTA(*)
      REAL    TA(*),DAMP,U(M),X(N),ATOL,BTOL,CONLIM,
     *        ACOND,RNORM,XNORM,W(*)
C     ------------------------------------------------------------------
C
C     STLSQ FINDS A SOLUTION X TO THE FOLLOWING PROBLEMS ...
C
C     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*X = B
C
C     2. LINEAR LEAST SQUARES  --    SOLVE  A*X = B
C                                    IN THE LEAST-SQUARES SENSE
C
C     3. DAMPED LEAST SQUARES  --    SOLVE  (   A    )*X = ( B )
C                                           ( DAMP*I )     ( 0 )
C                                    IN THE LEAST-SQUARES SENSE
C
C     WHERE A IS A MATRIX WITH M ROWS AND N COLUMNS, B AN M-VECTOR,
C     AND DAMP A SCALAR. (ALL QUANTITIES ARE REAL.) THE MATRIX A IS
C     A SPARSE MATRIX WHOSE TRANSPOSE IS STORED ROWWISE IN THE ARRAYS
C     TA,ITA,JTA.
C
C     THE RHS VECTOR B IS INPUT VIA U, AND IS SUBSEQUENTLY OVERWRITTEN.
C
C
C     NOTE. STLSQ USES AN ITERATIVE METHOD TO APPROXIMATE THE SOLUTION.
C     THE NUMBER OF ITERATIONS REQUIRED TO REACH A CERTAIN ACCURACY
C     DEPENDS STRONGLY ON THE SCALING OF THE PROBLEM. POOR SCALING OF
C     THE ROWS OR COLUMNS OF A SHOULD THEREFORE BE AVOIDED WHENEVER
C     POSSIBLE.
C
C     FOR EXAMPLE, IN PROBLEM 1 THE SOLUTION IS UNALTERED BY
C     ROW-SCALING.  IF A ROW OF A IS VERY SMALL OR LARGE COMPARED TO
C     THE OTHER ROWS OF A, THE CORRESPONDING ROW OF (A  B) SHOULD BE
C     SCALED UP OR DOWN.
C
C     IN PROBLEMS 1 AND 2, THE SOLUTION X IS EASILY RECOVERED
C     FOLLOWING COLUMN SCALING. IN THE ABSENCE OF BETTER INFORMATION,
C     THE NONZERO COLUMNS OF A SHOULD BE SCALED SO THAT THEY ALL HAVE
C     THE SAME EUCLIDEAN NORM (E.G.  1.0).
C
C     IN PROBLEM 3, THERE IS NO FREEDOM TO RE-SCALE IF DAMP IS
C     NONZERO. HOWEVER, THE VALUE OF DAMP SHOULD BE ASSIGNED ONLY
C     AFTER ATTENTION HAS BEEN PAID TO THE SCALING OF A.
C
C     THE PARAMETER DAMP IS INTENDED TO HELP REGULARIZE
C     ILL-CONDITIONED SYSTEMS, BY PREVENTING THE TRUE SOLUTION FROM
C     BEING VERY LARGE. ANOTHER AID TO REGULARIZATION IS PROVIDED BY
C     THE PARAMETER ACOND, WHICH MAY BE USED TO TERMINATE ITERATIONS
C     BEFORE THE COMPUTED SOLUTION BECOMES VERY LARGE.
C
C
C     NOTATION
C     --------
C
C     THE FOLLOWING QUANTITIES ARE USED IN DISCUSSING THE SUBROUTINE
C     PARAMETERS...
C
C     ABAR   =  (   A    ),          BBAR  =  ( B )
C               ( DAMP*I )                    ( 0 )
C
C     R      =  B  -  A*X,           RBAR  =  BBAR  -  ABAR*X
C
C     RNORM  =  SQRT( NORM(R)**2  +  DAMP**2 * NORM(X)**2 )
C            =  NORM( RBAR )
C
C     RELPR  =  THE SMALLEST FLOATING POINT NUMBER FOR WHICH
C               1 + RELPR .GT. 1.
C
C     STLSQ  MINIMIZES THE FUNCTION RNORM WITH RESPECT TO X.
C
C
C     PARAMETERS
C     ----------
C
C     M       INPUT      THE NUMBER OF ROWS IN A.
C
C     N       INPUT      THE NUMBER OF COLUMNS IN A.
C
C     TA,ITA  INPUT      THE TRANSPOSE OF THE MATRIX A IS STORED
C      JTA               ROWWISE IN SPARSE FORM.
C
C     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
C                        (DAMP  SHOULD BE 0.0 FOR PROBLEMS 1 AND 2.)
C                        IF THE SYSTEM  A*X = B  IS INCOMPATIBLE, VALUES
C                        OF DAMP IN THE RANGE 0 TO SQRT(RELPR)*NORM(A)
C                        WILL PROBABLY HAVE A NEGLIGIBLE EFFECT.
C                        LARGER VALUES OF DAMP WILL TEND TO DECREASE
C                        THE NORM OF X AND TO REDUCE THE NUMBER OF
C                        ITERATIONS REQUIRED BY STLSQ.
C
C                        THE WORK PER ITERATION AND THE STORAGE NEEDED
C                        BY STLSQ ARE THE SAME FOR ALL VALUES OF DAMP.
C
C     U(M)    INPUT      THE RHS VECTOR B. BE AWARE THAT U IS
C                        OVER-WRITTEN BY STLSQ.
C
C     X(N)    OUTPUT     RETURNS THE COMPUTED SOLUTION X.
C
C     ATOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
C                        DEFINING THE MATRIX A. FOR EXAMPLE,
C                        IF A IS ACCURATE TO ABOUT 6 DIGITS, SET
C                        ATOL = 1.0E-6 .
C
C     BTOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
C                        DEFINING THE RHS VECTOR B. FOR EXAMPLE,
C                        IF B IS ACCURATE TO ABOUT 6 DIGITS, SET
C                        BTOL = 1.0E-6 .
C
C     CONLIM  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
C                        CONDITION NUMBER OF THE MATRIX ABAR.
C                        ITERATIONS WILL BE TERMINATED IF A COMPUTED
C                        ESTIMATE OF COND(ABAR) EXCEEDS CONLIM.
C                        THIS IS INTENDED TO PREVENT CERTAIN SMALL OR
C                        ZERO SINGULAR VALUES OF A OR ABAR FROM
C                        COMING INTO EFFECT AND CAUSING UNWANTED GROWTH
C                        IN THE COMPUTED SOLUTION.
C
C                        CONLIM AND DAMP MAY BE USED SEPARATELY OR
C                        TOGETHER TO REGULARIZE ILL-CONDITIONED SYSTEMS.
C
C                        NORMALLY, CONLIM SHOULD BE IN THE RANGE
C                        1000  TO  1/RELPR.
C                        SUGGESTED VALUE --
C                        CONLIM = 1/(100*RELPR)  FOR COMPATIBLE SYSTEMS,
C                        CONLIM = 1/(10*SQRT(RELPR))  FOR LEAST SQUARES.
C
C             NOTE. IF THE USER IS NOT CONCERNED ABOUT THE PARAMETERS
C             ATOL, BTOL, AND CONLIM, ANY OR ALL OF THEM MAY BE SET
C             TO ZERO. THE EFFECT WILL BE THE SAME AS THE VALUES
C             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
C
C     ITNLIM  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
C                        SUGGESTED VALUE --
C                        ITNLIM = N/2     FOR WELL CONDITIONED SYSTEMS,
C                        ITNLIM = 4*N     OTHERWISE.
C
C     ISTOP   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
C
C                0       X = 0  IS THE EXACT SOLUTION.
C                        NO ITERATIONS WERE PERFORMED.
C
C                1       THE EQUATIONS  A*X = B  ARE PROBABLY
C                        COMPATIBLE. NORM(A*X - B) IS SUFFICIENTLY
C                        SMALL, GIVEN THE VALUES OF ATOL AND BTOL.
C
C                2       THE SYSTEM  A*X = B  IS PROBABLY NOT
C                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
C                        BEEN OBTAINED WHICH IS SUFFICIENTLY ACCURATE,
C                        GIVEN THE VALUE OF ATOL.
C
C                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
C                        CONLIM. THE SYSTEM  A*X = B  APPEARS TO BE
C                        ILL-CONDITIONED.
C
C                4       THE EQUATIONS  A*X = B  ARE PROBABLY
C                        COMPATIBLE. NORM(A*X - B) IS AS SMALL AS
C                        SEEMS REASONABLE ON THIS MACHINE.
C
C                5       THE SYSTEM  A*X = B  IS PROBABLY NOT
C                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
C                        BEEN OBTAINED WHICH IS AS ACCURATE AS SEEMS
C                        REASONABLE ON THIS MACHINE.
C
C                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
C                        NOT MUCH POINT IN DOING FURTHER ITERATIONS,
C                        GIVEN THE PRECISION OF THIS MACHINE.
C
C                7       THE ITERATION LIMIT ITNLIM WAS REACHED.
C
C
C     ITN     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
C
C     ACOND   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
C                        NUMBER OF ABAR.
C
C     RNORM   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
C                        THE FUNCTION BEING MINIMIZED (SEE NOTATION
C                        ABOVE). THIS WILL BE SMALL IF  A*X = B  HAS
C                        A SOLUTION.
C
C     XNORM   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
C                        SOLUTION VECTOR X.
C
C     W(2*N)             WORKSPACE
C
C     ANORM   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
C                        THIS IS THE SQUARE ROOT OF THE SUM OF SQUARES
C                        OF THE ELEMENTS OF ABAR.
C                        IF DAMP IS SMALL AND IF THE COLUMNS OF A
C                        HAVE ALL BEEN SCALED TO HAVE LENGTH  1.0,
C                        ANORM SHOULD INCREASE TO ROUGHLY SQRT(N).
C
C     ARNORM  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
C                        NORM( ABAR(TRANSPOSE)*RBAR ), THE NORM OF
C                        THE RESIDUAL FOR THE USUAL NORMAL EQUATIONS.
C                        THIS SHOULD BE SMALL IN ALL CASES. (ARNORM
C                        WILL OFTEN BE SMALLER THAN THE TRUE VALUE
C                        COMPUTED FROM THE OUTPUT VECTOR X.)
C
C
C     SUBROUTINES AND FUNCTIONS USED
C     ------------------------------
C
C                NORMLZ,MVPRD1,MTPRD1
C     BLAS       SCOPY,SNRM2,SSCAL  (SEE LAWSON ET AL. BELOW)
C                (SNRM2 IS USED ONLY IN NORMLZ)
C     FORTRAN    ABS,SQRT
C
C
C     REFERENCES
C     ----------
C
C     PAIGE, C.C. AND SAUNDERS, M.A.  LSQR, AN ALGORITHM FOR SPARSE
C        LINEAR EQUATIONS AND SPARSE LEAST SQUARES.
C        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 8, 1 (MARCH 1982).
C
C     LAWSON, C.L., HANSON, R.J., KINCAID, D.R. AND KROGH, F.T.
C        BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE.
C        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 5, 3 (SEPT 1979),
C        308-323 AND 324-325.
C
C     ------------------------------------------------------------------
C
C     LOCAL VARIABLES
C
      INTEGER    I,ITN,NCONV,NSTOP
      REAL       ALFA,ANORM,ARNORM,BBNORM,BETA,BNORM,
     1           CS,CS1,CS2,CTOL,DAMPSQ,DDNORM,DELTA,
     2           GAMMA,GAMBAR,ONE,PHI,PHIBAR,PSI,
     3           RES1,RES2,RHO,RHOBAR,RHBAR1,RHBAR2,RHS,RTOL,
     4           SN,SN1,SN2,T,TAU,TEST1,TEST2,TEST3,
     5           THETA,T1,T2,T3,XXNORM,Z,ZBAR,ZERO
C
C
C     INITIALIZE.
C
      ZERO   = 0.0
      ONE    = 1.0
      CTOL   = ZERO
      IF (CONLIM .GT. ZERO) CTOL = ONE/CONLIM
      DAMPSQ = DAMP**2
      ANORM  = ZERO
      ACOND  = ZERO
      BBNORM = ZERO
      DDNORM = ZERO
      RES2   = ZERO
      XNORM  = ZERO
      XXNORM = ZERO
      CS2    = -ONE
      SN2    = ZERO
      Z      = ZERO
      ITN    = 0
      ISTOP  = 0
      NSTOP  = 0
C
      DO 10 I = 1, N
         W(I) = ZERO
         X(I) = ZERO
   10 CONTINUE
C
C     SET UP THE FIRST VECTORS FOR THE BIDIAGONALIZATION.
C     THESE SATISFY   BETA*U = B,   ALFA*W = A(TRANSPOSE)*U.
C
      CALL NORMLZ(M,U,BETA)
      CALL MVPRD1(N,M,TA,ITA,JTA,U,W)
      CALL NORMLZ(N,W,ALFA)
      CALL SCOPY (N,W,1,W(N+1),1)
C
      RHOBAR = ALFA
      PHIBAR = BETA
      BNORM  = BETA
      RNORM  = BETA
      ARNORM = ALFA*BETA
      IF (ARNORM .LE. ZERO) GO TO 800
C
C     ------------------------------------------------------------------
C     MAIN ITERATION LOOP.
C     ------------------------------------------------------------------
  100 ITN = ITN + 1
C
C     PERFORM THE NEXT STEP OF THE BIDIAGONALIZATION TO OBTAIN THE
C     NEXT  BETA, U, ALFA, W.  THESE SATISFY THE RELATIONS
C                BETA*U  =  A*W  -  ALFA*U,
C                ALFA*W  =  A(TRANSPOSE)*U  -  BETA*W.
C
      CALL SSCAL (M,(-ALFA),U,1)
      CALL MTPRD1(N,M,TA,ITA,JTA,W,U)
      CALL NORMLZ(M,U,BETA)
      BBNORM = BBNORM + ALFA**2 + BETA**2 + DAMPSQ
      CALL SSCAL (N,(-BETA),W,1)
      CALL MVPRD1(N,M,TA,ITA,JTA,U,W)
      CALL NORMLZ(N,W,ALFA)
C
C
C     USE A PLANE ROTATION TO ELIMINATE THE DAMPING PARAMETER.
C     THIS ALTERS THE DIAGONAL (RHOBAR) OF THE LOWER-BIDIAGONAL MATRIX.
C
      RHBAR2 = RHOBAR**2 + DAMPSQ
      RHBAR1 = SQRT(RHBAR2)
      CS1    = RHOBAR/RHBAR1
      SN1    = DAMP/RHBAR1
      PSI    = SN1*PHIBAR
      PHIBAR = CS1*PHIBAR
C
C
C     USE A PLANE ROTATION TO ELIMINATE THE SUBDIAGONAL ELEMENT (BETA)
C     OF THE LOWER-BIDIAGONAL MATRIX, GIVING AN UPPER-BIDIAGONAL MATRIX.
C
      RHO    = SQRT(RHBAR2 + BETA**2)
      CS     = RHBAR1/RHO
      SN     = BETA/RHO
      THETA  =  SN*ALFA
      RHOBAR = -CS*ALFA
      PHI    =  CS*PHIBAR
      PHIBAR =  SN*PHIBAR
      TAU    =  SN*PHI
C
C
C     UPDATE X AND W(N+1),...,W(2*N)
C
      T1 =    PHI/RHO
      T2 = -THETA/RHO
      T3 =    ONE/RHO
C
      DO 200 I = 1, N
         NPI   = N + I
         T     = W(NPI)
         X(I)  = T1*T + X(I)
         W(NPI)= T2*T + W(I)
         T     =(T3*T)**2
         DDNORM= T + DDNORM
  200 CONTINUE
C
C
C     USE A PLANE ROTATION ON THE RIGHT TO ELIMINATE THE
C     SUPER-DIAGONAL ELEMENT (THETA) OF THE UPPER-BIDIAGONAL MATRIX.
C     THEN USE THE RESULT TO ESTIMATE NORM(X).
C
      DELTA  =  SN2*RHO
      GAMBAR = -CS2*RHO
      RHS    = PHI - DELTA*Z
      ZBAR   = RHS/GAMBAR
      XNORM  = SQRT(XXNORM + ZBAR**2)
      GAMMA  = SQRT(GAMBAR**2 + THETA**2)
      CS2    = GAMBAR/GAMMA
      SN2    = THETA/GAMMA
      Z      = RHS/GAMMA
      XXNORM = XXNORM + Z**2
C
C
C     TEST FOR CONVERGENCE.
C     FIRST, ESTIMATE THE NORM AND CONDITION OF THE MATRIX ABAR,
C     AND THE NORMS OF RBAR AND ABAR(TRANSPOSE)*RBAR.
C
      ANORM  = SQRT(BBNORM)
      ACOND  = ANORM*SQRT(DDNORM)
      RES1   = PHIBAR**2
      RES2   = RES2 + PSI**2
      RNORM  = SQRT(RES1 + RES2)
      ARNORM = ALFA*ABS(TAU)
C
C     NOW USE THESE NORMS TO ESTIMATE CERTAIN OTHER QUANTITIES,
C     SOME OF WHICH WILL BE SMALL NEAR A SOLUTION.
C
      TEST1  = RNORM/BNORM
      TEST2  = ARNORM/(ANORM*RNORM)
      TEST3  = ONE/ACOND
      T1     = TEST1/(ONE + ANORM*XNORM/BNORM)
      RTOL   = BTOL +  ATOL*ANORM*XNORM/BNORM
C
C     THE FOLLOWING TESTS GUARD AGAINST EXTREMELY SMALL VALUES OF
C     ATOL, BTOL, OR CTOL.  (THE USER MAY HAVE SET ANY OR ALL OF
C     THE PARAMETERS ATOL, BTOL, CONLIM TO ZERO.)
C     THE EFFECT IS EQUIVALENT TO THE NORMAL TESTS USING
C     ATOL = RELPR,  BTOL = RELPR,  CONLIM = 1/RELPR.
C
      T3 = ONE + TEST3
      T2 = ONE + TEST2
      T1 = ONE + T1
      IF (ITN .GE. ITNLIM) ISTOP = 7
      IF (T3  .LE. ONE   ) ISTOP = 6
      IF (T2  .LE. ONE   ) ISTOP = 5
      IF (T1  .LE. ONE   ) ISTOP = 4
C
C     ALLOW FOR TOLERANCES SET BY THE USER.
C
      IF (TEST3 .LE. CTOL) ISTOP = 3
      IF (TEST2 .LE. ATOL) ISTOP = 2
      IF (TEST1 .LE. RTOL) ISTOP = 1
C
C     STOP IF APPROPRIATE.
C     THE CONVERGENCE CRITERIA ARE REQUIRED TO BE MET ON  NCONV
C     CONSECUTIVE ITERATIONS, WHERE  NCONV  IS SET BELOW.
C     SUGGESTED VALUE --   NCONV = 1, 2  OR  3.
C
      IF (ISTOP .EQ. 0) NSTOP = 0
      IF (ISTOP .EQ. 0) GO TO 100
      NCONV = 1
      NSTOP = NSTOP + 1
      IF (NSTOP .LT. NCONV  .AND.  ITN .LT. ITNLIM) ISTOP = 0
      IF (ISTOP .EQ. 0) GO TO 100
C     ------------------------------------------------------------------
C     END OF ITERATION LOOP.
C     ------------------------------------------------------------------
C
  800 RETURN
      END
      SUBROUTINE BLSQ(M,N,A,KA,ML,MU,DAMP,U,X,ATOL,BTOL,CONLIM,ITNLIM,
     *                     ISTOP,ITN,ACOND,RNORM,XNORM,W)
C
      INTEGER M,N,KA,ML,MU,ITNLIM,ISTOP
      REAL    A(KA,N),DAMP,U(M),X(N),ATOL,BTOL,CONLIM,
     *        ACOND,RNORM,XNORM,W(*)
C     ------------------------------------------------------------------
C
C     BLSQ FINDS A SOLUTION X TO THE FOLLOWING PROBLEMS ...
C
C     1. UNSYMMETRIC EQUATIONS --    SOLVE  A*X = B
C
C     2. LINEAR LEAST SQUARES  --    SOLVE  A*X = B
C                                    IN THE LEAST-SQUARES SENSE
C
C     3. DAMPED LEAST SQUARES  --    SOLVE  (   A    )*X = ( B )
C                                           ( DAMP*I )     ( 0 )
C                                    IN THE LEAST-SQUARES SENSE
C
C     WHERE A IS A MATRIX WITH M ROWS AND N COLUMNS, B AN M-VECTOR,
C     AND DAMP A SCALAR. (ALL QUANTITIES ARE REAL.) THE MATRIX A IS
C     A BANDED MATRIX STORED IN BAND FORM.
C
C     THE RHS VECTOR B IS INPUT VIA U, AND IS SUBSEQUENTLY OVERWRITTEN.
C
C
C     NOTE. BLSQ USES AN ITERATIVE METHOD TO APPROXIMATE THE SOLUTION.
C     THE NUMBER OF ITERATIONS REQUIRED TO REACH A CERTAIN ACCURACY
C     DEPENDS STRONGLY ON THE SCALING OF THE PROBLEM. POOR SCALING OF
C     THE ROWS OR COLUMNS OF A SHOULD THEREFORE BE AVOIDED WHENEVER
C     POSSIBLE.
C
C     FOR EXAMPLE, IN PROBLEM 1 THE SOLUTION IS UNALTERED BY
C     ROW-SCALING.  IF A ROW OF A IS VERY SMALL OR LARGE COMPARED TO
C     THE OTHER ROWS OF A, THE CORRESPONDING ROW OF (A  B) SHOULD BE
C     SCALED UP OR DOWN.
C
C     IN PROBLEMS 1 AND 2, THE SOLUTION X IS EASILY RECOVERED
C     FOLLOWING COLUMN SCALING. IN THE ABSENCE OF BETTER INFORMATION,
C     THE NONZERO COLUMNS OF A SHOULD BE SCALED SO THAT THEY ALL HAVE
C     THE SAME EUCLIDEAN NORM (E.G.  1.0).
C
C     IN PROBLEM 3, THERE IS NO FREEDOM TO RE-SCALE IF DAMP IS
C     NONZERO. HOWEVER, THE VALUE OF DAMP SHOULD BE ASSIGNED ONLY
C     AFTER ATTENTION HAS BEEN PAID TO THE SCALING OF A.
C
C     THE PARAMETER DAMP IS INTENDED TO HELP REGULARIZE
C     ILL-CONDITIONED SYSTEMS, BY PREVENTING THE TRUE SOLUTION FROM
C     BEING VERY LARGE. ANOTHER AID TO REGULARIZATION IS PROVIDED BY
C     THE PARAMETER ACOND, WHICH MAY BE USED TO TERMINATE ITERATIONS
C     BEFORE THE COMPUTED SOLUTION BECOMES VERY LARGE.
C
C
C     NOTATION
C     --------
C
C     THE FOLLOWING QUANTITIES ARE USED IN DISCUSSING THE SUBROUTINE
C     PARAMETERS...
C
C     ABAR   =  (   A    ),          BBAR  =  ( B )
C               ( DAMP*I )                    ( 0 )
C
C     R      =  B  -  A*X,           RBAR  =  BBAR  -  ABAR*X
C
C     RNORM  =  SQRT( NORM(R)**2  +  DAMP**2 * NORM(X)**2 )
C            =  NORM( RBAR )
C
C     RELPR  =  THE SMALLEST FLOATING POINT NUMBER FOR WHICH
C               1 + RELPR .GT. 1.
C
C     BLSQ   MINIMIZES THE FUNCTION RNORM WITH RESPECT TO X.
C
C
C     PARAMETERS
C     ----------
C
C     M       INPUT      THE NUMBER OF ROWS IN A.
C
C     N       INPUT      THE NUMBER OF COLUMNS IN A.
C
C     A       INPUT      THE MATRIX A STORED IN BAND FORM.
C
C     KA      INPUT      THE NUMBER OF ROWS IN THE DIMENSION STATEMENT
C                        FOR A IN THE CALLING PROGRAM.
C
C     ML      INPUT      THE LOWER BAND WIDTH OF A.
C
C     MU      INPUT      THE UPPER BAND WIDTH OF A.
C
C     DAMP    INPUT      THE DAMPING PARAMETER FOR PROBLEM 3 ABOVE.
C                        (DAMP  SHOULD BE 0.0 FOR PROBLEMS 1 AND 2.)
C                        IF THE SYSTEM  A*X = B  IS INCOMPATIBLE, VALUES
C                        OF DAMP IN THE RANGE 0 TO SQRT(RELPR)*NORM(A)
C                        WILL PROBABLY HAVE A NEGLIGIBLE EFFECT.
C                        LARGER VALUES OF DAMP WILL TEND TO DECREASE
C                        THE NORM OF X AND TO REDUCE THE NUMBER OF
C                        ITERATIONS REQUIRED BY BLSQ.
C
C                        THE WORK PER ITERATION AND THE STORAGE NEEDED
C                        BY BLSQ ARE THE SAME FOR ALL VALUES OF DAMP.
C
C     U(M)    INPUT      THE RHS VECTOR B. BE AWARE THAT U IS
C                        OVER-WRITTEN BY BLSQ.
C
C     X(N)    OUTPUT     RETURNS THE COMPUTED SOLUTION X.
C
C     ATOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
C                        DEFINING THE MATRIX A. FOR EXAMPLE,
C                        IF A IS ACCURATE TO ABOUT 6 DIGITS, SET
C                        ATOL = 1.0E-6 .
C
C     BTOL    INPUT      AN ESTIMATE OF THE RELATIVE ERROR IN THE DATA
C                        DEFINING THE RHS VECTOR B. FOR EXAMPLE,
C                        IF B IS ACCURATE TO ABOUT 6 DIGITS, SET
C                        BTOL = 1.0E-6 .
C
C     CONLIM  INPUT      AN UPPER LIMIT ON COND(ABAR), THE APPARENT
C                        CONDITION NUMBER OF THE MATRIX ABAR.
C                        ITERATIONS WILL BE TERMINATED IF A COMPUTED
C                        ESTIMATE OF COND(ABAR) EXCEEDS CONLIM.
C                        THIS IS INTENDED TO PREVENT CERTAIN SMALL OR
C                        ZERO SINGULAR VALUES OF A OR ABAR FROM
C                        COMING INTO EFFECT AND CAUSING UNWANTED GROWTH
C                        IN THE COMPUTED SOLUTION.
C
C                        CONLIM AND DAMP MAY BE USED SEPARATELY OR
C                        TOGETHER TO REGULARIZE ILL-CONDITIONED SYSTEMS.
C
C                        NORMALLY, CONLIM SHOULD BE IN THE RANGE
C                        1000  TO  1/RELPR.
C                        SUGGESTED VALUE --
C                        CONLIM = 1/(100*RELPR)  FOR COMPATIBLE SYSTEMS,
C                        CONLIM = 1/(10*SQRT(RELPR))  FOR LEAST SQUARES.
C
C             NOTE. IF THE USER IS NOT CONCERNED ABOUT THE PARAMETERS
C             ATOL, BTOL, AND CONLIM, ANY OR ALL OF THEM MAY BE SET
C             TO ZERO. THE EFFECT WILL BE THE SAME AS THE VALUES
C             RELPR, RELPR, AND  1/RELPR  RESPECTIVELY.
C
C     ITNLIM  INPUT      AN UPPER LIMIT ON THE NUMBER OF ITERATIONS.
C                        SUGGESTED VALUE --
C                        ITNLIM = N/2     FOR WELL CONDITIONED SYSTEMS,
C                        ITNLIM = 4*N     OTHERWISE.
C
C     ISTOP   OUTPUT     AN INTEGER GIVING THE REASON FOR TERMINATION...
C
C                0       X = 0  IS THE EXACT SOLUTION.
C                        NO ITERATIONS WERE PERFORMED.
C
C                1       THE EQUATIONS  A*X = B  ARE PROBABLY
C                        COMPATIBLE. NORM(A*X - B) IS SUFFICIENTLY
C                        SMALL, GIVEN THE VALUES OF ATOL AND BTOL.
C
C                2       THE SYSTEM  A*X = B  IS PROBABLY NOT
C                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
C                        BEEN OBTAINED WHICH IS SUFFICIENTLY ACCURATE,
C                        GIVEN THE VALUE OF ATOL.
C
C                3       AN ESTIMATE OF COND(ABAR) HAS EXCEEDED
C                        CONLIM. THE SYSTEM  A*X = B  APPEARS TO BE
C                        ILL-CONDITIONED.
C
C                4       THE EQUATIONS  A*X = B  ARE PROBABLY
C                        COMPATIBLE. NORM(A*X - B) IS AS SMALL AS
C                        SEEMS REASONABLE ON THIS MACHINE.
C
C                5       THE SYSTEM  A*X = B  IS PROBABLY NOT
C                        COMPATIBLE. A LEAST-SQUARES SOLUTION HAS
C                        BEEN OBTAINED WHICH IS AS ACCURATE AS SEEMS
C                        REASONABLE ON THIS MACHINE.
C
C                6       COND(ABAR) SEEMS TO BE SO LARGE THAT THERE IS
C                        NOT MUCH POINT IN DOING FURTHER ITERATIONS,
C                        GIVEN THE PRECISION OF THIS MACHINE.
C
C                7       THE ITERATION LIMIT ITNLIM WAS REACHED.
C
C
C     ITN     OUTPUT     THE NUMBER OF ITERATIONS THAT WERE PERFORMED.
C
C     ACOND   OUTPUT     AN ESTIMATE OF COND(ABAR), THE CONDITION
C                        NUMBER OF ABAR.
C
C     RNORM   OUTPUT     AN ESTIMATE OF THE FINAL VALUE OF NORM(RBAR),
C                        THE FUNCTION BEING MINIMIZED (SEE NOTATION
C                        ABOVE). THIS WILL BE SMALL IF  A*X = B  HAS
C                        A SOLUTION.
C
C     XNORM   OUTPUT     AN ESTIMATE OF THE NORM OF THE FINAL
C                        SOLUTION VECTOR X.
C
C     W(2*N)             WORKSPACE
C
C     ANORM   LOCAL      AN ESTIMATE OF THE FROBENIUS NORM OF ABAR.
C                        THIS IS THE SQUARE ROOT OF THE SUM OF SQUARES
C                        OF THE ELEMENTS OF ABAR.
C                        IF DAMP IS SMALL AND IF THE COLUMNS OF A
C                        HAVE ALL BEEN SCALED TO HAVE LENGTH  1.0,
C                        ANORM SHOULD INCREASE TO ROUGHLY SQRT(N).
C
C     ARNORM  LOCAL      AN ESTIMATE OF THE FINAL VALUE OF
C                        NORM( ABAR(TRANSPOSE)*RBAR ), THE NORM OF
C                        THE RESIDUAL FOR THE USUAL NORMAL EQUATIONS.
C                        THIS SHOULD BE SMALL IN ALL CASES. (ARNORM
C                        WILL OFTEN BE SMALLER THAN THE TRUE VALUE
C                        COMPUTED FROM THE OUTPUT VECTOR X.)
C
C
C     SUBROUTINES AND FUNCTIONS USED
C     ------------------------------
C
C                NORMLZ,BVPRD1,BTPRD1
C     BLAS       SCOPY,SNRM2,SSCAL  (SEE LAWSON ET AL. BELOW)
C                (SNRM2 IS USED ONLY IN NORMLZ)
C     FORTRAN    ABS,SQRT
C
C
C     REFERENCES
C     ----------
C
C     PAIGE, C.C. AND SAUNDERS, M.A.  LSQR, AN ALGORITHM FOR SPARSE
C        LINEAR EQUATIONS AND SPARSE LEAST SQUARES.
C        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 8, 1 (MARCH 1982).
C
C     LAWSON, C.L., HANSON, R.J., KINCAID, D.R. AND KROGH, F.T.
C        BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE.
C        ACM TRANSACTIONS ON MATHEMATICAL SOFTWARE 5, 3 (SEPT 1979),
C        308-323 AND 324-325.
C
C     ------------------------------------------------------------------
C
C     LOCAL VARIABLES
C
      INTEGER    I,ITN,NCONV,NSTOP
      REAL       ALFA,ANORM,ARNORM,BBNORM,BETA,BNORM,
     1           CS,CS1,CS2,CTOL,DAMPSQ,DDNORM,DELTA,
     2           GAMMA,GAMBAR,ONE,PHI,PHIBAR,PSI,
     3           RES1,RES2,RHO,RHOBAR,RHBAR1,RHBAR2,RHS,RTOL,
     4           SN,SN1,SN2,T,TAU,TEST1,TEST2,TEST3,
     5           THETA,T1,T2,T3,XXNORM,Z,ZBAR,ZERO
C
C
C     INITIALIZE.
C
      ZERO   = 0.0
      ONE    = 1.0
      CTOL   = ZERO
      IF (CONLIM .GT. ZERO) CTOL = ONE/CONLIM
      DAMPSQ = DAMP**2
      ANORM  = ZERO
      ACOND  = ZERO
      BBNORM = ZERO
      DDNORM = ZERO
      RES2   = ZERO
      XNORM  = ZERO
      XXNORM = ZERO
      CS2    = -ONE
      SN2    = ZERO
      Z      = ZERO
      ITN    = 0
      ISTOP  = 0
      NSTOP  = 0
C
      DO 10 I = 1, N
         W(I) = ZERO
         X(I) = ZERO
   10 CONTINUE
C
C     SET UP THE FIRST VECTORS FOR THE BIDIAGONALIZATION.
C     THESE SATISFY   BETA*U = B,   ALFA*W = A(TRANSPOSE)*U.
C
      CALL NORMLZ(M,U,BETA)
      CALL BTPRD1(M,N,A,KA,ML,MU,U,W)
      CALL NORMLZ(N,W,ALFA)
      CALL SCOPY (N,W,1,W(N+1),1)
C
      RHOBAR = ALFA
      PHIBAR = BETA
      BNORM  = BETA
      RNORM  = BETA
      ARNORM = ALFA*BETA
      IF (ARNORM .LE. ZERO) GO TO 800
C
C     ------------------------------------------------------------------
C     MAIN ITERATION LOOP.
C     ------------------------------------------------------------------
  100 ITN = ITN + 1
C
C     PERFORM THE NEXT STEP OF THE BIDIAGONALIZATION TO OBTAIN THE
C     NEXT  BETA, U, ALFA, W.  THESE SATISFY THE RELATIONS
C                BETA*U  =  A*W  -  ALFA*U,
C                ALFA*W  =  A(TRANSPOSE)*U  -  BETA*W.
C
      CALL SSCAL (M,(-ALFA),U,1)
      CALL BVPRD1(M,N,A,KA,ML,MU,W,U)
      CALL NORMLZ(M,U,BETA)
      BBNORM = BBNORM + ALFA**2 + BETA**2 + DAMPSQ
      CALL SSCAL (N,(-BETA),W,1)
      CALL BTPRD1(M,N,A,KA,ML,MU,U,W)
      CALL NORMLZ(N,W,ALFA)
C
C
C     USE A PLANE ROTATION TO ELIMINATE THE DAMPING PARAMETER.
C     THIS ALTERS THE DIAGONAL (RHOBAR) OF THE LOWER-BIDIAGONAL MATRIX.
C
      RHBAR2 = RHOBAR**2 + DAMPSQ
      RHBAR1 = SQRT(RHBAR2)
      CS1    = RHOBAR/RHBAR1
      SN1    = DAMP/RHBAR1
      PSI    = SN1*PHIBAR
      PHIBAR = CS1*PHIBAR
C
C
C     USE A PLANE ROTATION TO ELIMINATE THE SUBDIAGONAL ELEMENT (BETA)
C     OF THE LOWER-BIDIAGONAL MATRIX, GIVING AN UPPER-BIDIAGONAL MATRIX.
C
      RHO    = SQRT(RHBAR2 + BETA**2)
      CS     = RHBAR1/RHO
      SN     = BETA/RHO
      THETA  =  SN*ALFA
      RHOBAR = -CS*ALFA
      PHI    =  CS*PHIBAR
      PHIBAR =  SN*PHIBAR
      TAU    =  SN*PHI
C
C
C     UPDATE X AND W(N+1),...,W(2*N)
C
      T1 =    PHI/RHO
      T2 = -THETA/RHO
      T3 =    ONE/RHO
C
      DO 200 I = 1, N
         NPI   = N + I
         T     = W(NPI)
         X(I)  = T1*T + X(I)
         W(NPI)= T2*T + W(I)
         T     =(T3*T)**2
         DDNORM= T + DDNORM
  200 CONTINUE
C
C
C     USE A PLANE ROTATION ON THE RIGHT TO ELIMINATE THE
C     SUPER-DIAGONAL ELEMENT (THETA) OF THE UPPER-BIDIAGONAL MATRIX.
C     THEN USE THE RESULT TO ESTIMATE NORM(X).
C
      DELTA  =  SN2*RHO
      GAMBAR = -CS2*RHO
      RHS    = PHI - DELTA*Z
      ZBAR   = RHS/GAMBAR
      XNORM  = SQRT(XXNORM + ZBAR**2)
      GAMMA  = SQRT(GAMBAR**2 + THETA**2)
      CS2    = GAMBAR/GAMMA
      SN2    = THETA/GAMMA
      Z      = RHS/GAMMA
      XXNORM = XXNORM + Z**2
C
C
C     TEST FOR CONVERGENCE.
C     FIRST, ESTIMATE THE NORM AND CONDITION OF THE MATRIX ABAR,
C     AND THE NORMS OF RBAR AND ABAR(TRANSPOSE)*RBAR.
C
      ANORM  = SQRT(BBNORM)
      ACOND  = ANORM*SQRT(DDNORM)
      RES1   = PHIBAR**2
      RES2   = RES2 + PSI**2
      RNORM  = SQRT(RES1 + RES2)
      ARNORM = ALFA*ABS(TAU)
C
C     NOW USE THESE NORMS TO ESTIMATE CERTAIN OTHER QUANTITIES,
C     SOME OF WHICH WILL BE SMALL NEAR A SOLUTION.
C
      TEST1  = RNORM/BNORM
      TEST2  = ARNORM/(ANORM*RNORM)
      TEST3  = ONE/ACOND
      T1     = TEST1/(ONE + ANORM*XNORM/BNORM)
      RTOL   = BTOL +  ATOL*ANORM*XNORM/BNORM
C
C     THE FOLLOWING TESTS GUARD AGAINST EXTREMELY SMALL VALUES OF
C     ATOL, BTOL, OR CTOL.  (THE USER MAY HAVE SET ANY OR ALL OF
C     THE PARAMETERS ATOL, BTOL, CONLIM TO ZERO.)
C     THE EFFECT IS EQUIVALENT TO THE NORMAL TESTS USING
C     ATOL = RELPR,  BTOL = RELPR,  CONLIM = 1/RELPR.
C
      T3 = ONE + TEST3
      T2 = ONE + TEST2
      T1 = ONE + T1
      IF (ITN .GE. ITNLIM) ISTOP = 7
      IF (T3  .LE. ONE   ) ISTOP = 6
      IF (T2  .LE. ONE   ) ISTOP = 5
      IF (T1  .LE. ONE   ) ISTOP = 4
C
C     ALLOW FOR TOLERANCES SET BY THE USER.
C
      IF (TEST3 .LE. CTOL) ISTOP = 3
      IF (TEST2 .LE. ATOL) ISTOP = 2
      IF (TEST1 .LE. RTOL) ISTOP = 1
C
C     STOP IF APPROPRIATE.
C     THE CONVERGENCE CRITERIA ARE REQUIRED TO BE MET ON  NCONV
C     CONSECUTIVE ITERATIONS, WHERE  NCONV  IS SET BELOW.
C     SUGGESTED VALUE --   NCONV = 1, 2  OR  3.
C
      IF (ISTOP .EQ. 0) NSTOP = 0
      IF (ISTOP .EQ. 0) GO TO 100
      NCONV = 1
      NSTOP = NSTOP + 1
      IF (NSTOP .LT. NCONV  .AND.  ITN .LT. ITNLIM) ISTOP = 0
      IF (ISTOP .EQ. 0) GO TO 100
C     ------------------------------------------------------------------
C     END OF ITERATION LOOP.
C     ------------------------------------------------------------------
C
  800 RETURN
      END
      SUBROUTINE FMIN(F, A0, B0, X, W, AERR, RERR, ERROR, IND)
C     ******************************************************************
C     GOLDEN SECTION MINIMIZATION OF A FUNCTION F(T)
C     ******************************************************************
      REAL F, A0, B0, X, W, AERR, RERR, ERROR
      REAL EPS, EPS0, ATOL, FTOL, RTOL, TOL
      REAL A, B, C1, C2, E, FU, FV, U, V
      REAL SPMPAR
      EXTERNAL F
C     -------------------
C     C1 = 1 - C2
C     C2 = 0.5*(-1 + SQRT(5))
C     -------------------
      DATA EPS0/5.E-3/
      DATA C1/.3819660112501052/
      DATA C2/.6180339887498948/
C     -------------------
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
                   EPS = SPMPAR(1)
C     -------------------
      A = A0
      B = B0
      IND = 0
      ATOL = AMAX1(AERR,1.E-20)
      FTOL = AMAX1(2.0*EPS,RERR)
      RTOL = AMAX1(7.0*EPS,RERR)
C
      E = B - A
      U = A + C1*E
      V = A + C2*E
      FU = F(U)
      FV = F(V)
C
C        LOCATION OF THE REGION OF A LOCAL MINIMUM
C
   10 IF (E .LE. EPS0*(1.0 + ABS(A))) GO TO 40
      IF (FU - FV) 20,11,30
   11 IF (FU .GT. F(B)) GO TO 30
C
   20 B = V
      E = B - A
      V = U
      U = A + C1*E
      FV = FU
      FU = F(U)
      GO TO 10
C
   30 A = U
      E = B - A
      U = V
      V = A + C2*E
      FU = FV
      FV = F(V)
      GO TO 10
C
   40 IF (A .GT. 0.0 .OR. B .LT. 0.0) GO TO 41
         W = F(0.0)
         IF (W .LE. AMIN1(FU,FV)) GO TO 100
   41 IF (A .NE. A0) GO TO 42
         IF (A .EQ. 0.0) GO TO 201
         W = F(A)
         IF (W .LE. AMIN1(FU,FV)) GO TO 130
         GO TO 201
   42 IF (B .NE. B0) GO TO 201
         IF (B .EQ. 0.0) GO TO 201
         W = F(B)
         IF (W .LE. AMIN1(FU,FV)) GO TO 150
         GO TO 201
C
C              CHECK IF 0 IS A LOCAL MINIMUM
C
  100 IF (B .LE. ATOL) GO TO 110
      X = 0.01*B
      IF (W .GT. F(X)) GO TO 180
      B = X
      GO TO 100
C
  110 IF (ABS(A) .LE. ATOL) GO TO 120
      X = 0.01*A
      IF (W .GT. F(X)) GO TO 180
      A = X
      GO TO 110
C
  120 X = 0.0
      ERROR = AMAX1(ABS(A),B)
      RETURN
C
C             CHECK IF A0 IS A LOCAL MINIMUM
C
  130 TOL = AMAX1(RTOL*ABS(A),ATOL)
  131 X = A + 0.01*E
      IF (W .GT. F(X)) GO TO 180
      B = X
      E = B - A
      IF (E .GT. TOL) GO TO 131
C
      X = A
      ERROR = E
      RETURN
C
C             CHECK IF B0 IS A LOCAL MINIMUM
C
  150 TOL = AMAX1(RTOL*ABS(B),ATOL)
  151 X = B - 0.01*E
      IF (W .GT. F(X)) GO TO 180
      A = X
      E = B - A
      IF (E .GT. TOL) GO TO 151
C
      X = B
      ERROR = E
      RETURN
C
  180 E = B - A
      U = A + C1*E
      V = A + C2*E
      FU = F(U)
      FV = F(V)
C
C             REFINEMENT OF THE LOCAL MINIMUM
C
  200 IND = 0
  201 IF (FU .GT. FV) GO TO 210
C
      B = V
      E = B - A
      V = U
      U = A + C1*E
      FV = FU
      FU = F(U)
      GO TO 220
C
  210 A = U
      E = B - A
      U = V
      V = A + C2*E
      FU = FV
      FV = F(V)
C
C        CHECKING THE ACCURACY OF THE LOCAL MINIMUM
C
  220 IF (E .LE. AMAX1(RTOL*ABS(A),ATOL)) GO TO 240
      IF (ABS(FV - FU) .GT. FTOL*AMAX1(ABS(FU),ABS(FV))) GO TO 200
      IF (IND .EQ. 1) GO TO 241
      IND = 1
      GO TO 201
C
C                    REPORT THE RESULTS
C
  240 IND = 0
  241 IF (FU - FV) 242,243,244
  242 X = U
      W = FU
      ERROR = C1*E
      RETURN
  243 X = V
      W = FV
      ERROR = E
      RETURN
  244 X = V
      W = FV
      ERROR = C1*E
      RETURN
      END
      SUBROUTINE OPTF (FCN,N,RERR,ITER,XPLS,FPLS,IERR,WRK)
C-----------------------------------------------------------------------
C                 INTERFACE TO MINIMIZATION PACKAGE
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       FCN        NAME OF ROUTINE TO EVALUATE MINIMIZATION FUNCTION.
C                  MUST BE DECLARED EXTERNAL IN CALLING ROUTINE.
C       N          DIMENSION OF PROBLEM
C       RERR       RELATIVE ACCURACY OF SUBROUTINE FCN.
C
C     INPUT/OUTPUT ...
C
C       ITER       ON INPUT ITER IS THE MAXIMUM NUMBER OF ITERATIONS
C                  THAT ARE PERMITTED. ON OUTPUT ITER IS THE NUMBER
C                  OF ITERATIONS THAT WERE ACTUALLY PERFORMED.
C       XPLS(N)    LOCAL MINIMUM
C
C     OUTPUT ...
C
C       FPLS       FUNCTION VALUE AT LOCAL MINIMUM XPLS
C       IERR       TERMINATION CODE
C
C     WORKSPACE ...
C
C       WRK(N,N+8)
C
C-----------------------------------------------------------------------
      REAL XPLS(N), WRK(N,*)
      EXTERNAL FCN
C
C     EQUIVALENCE WRK(N,1) = X(N)
C                 WRK(N,2) = TYPSIZ(N)
C                 WRK(N,3) = GPLS(N)
C                 WRK(N,4) = G(N)
C                 WRK(N,5) = P(N)
C                 WRK(N,6) = WRK0(N)
C                 WRK(N,7) = WRK1(N)
C                 WRK(N,8) = WRK2(N)
C                 WRK(N,9) = A(N,N)
C
C
C     SET TOLERANCES
C
      EPS = AMAX1(SPMPAR(1),ABS(RERR))
      GRADTL = EPS**0.4
      STEPMX = 0.0
      STEPTL = EPS
      IF (EPS .LE. 1.E-10) STEPTL = 10.0*EPS
      IF (EPS .LT. 1.E-13) STEPTL = 1.E2*EPS
C
C     INITIALIZATION
C
      MO = 0
      ITNLIM = ITER
      ITER = 0
      DO 10 I = 1,N
         WRK(I,1) = XPLS(I)
         WRK(I,2) = 1.0
   10 CONTINUE
      FSCALE = 1.0
C
C     OPTIMIZE FCN
C
   20 CALL OPTDRV(MO,N,N,WRK(1,1),FCN,WRK(1,2),FSCALE,RERR,
     *     ITNLIM,ITNCNT,GRADTL,STEPMX,STEPTL,XPLS,FPLS,WRK(1,3),
     *     IERR,WRK(1,9),WRK(1,4),WRK(1,5),WRK(1,6),WRK(1,7),
     *     WRK(1,8))
      ITER = ITER + ITNCNT
      IF (IERR .NE. -10) RETURN
      ITNLIM = ITNLIM - ITNCNT
      GO TO 20
      END
      SUBROUTINE OPTDRV (MO,NR,N,X,FCN,TYPSIZ,FSCALE,RERR,
     *        ITNLIM,ITNCNT,GRADTL,STEPMX,STEPTL,XPLS,FPLS,GPLS,
     *        IERR,A,G,P,WRK0,WRK1,WRK2)
C-----------------------------------------------------------------------
C             DRIVER FOR NON-LINEAR OPTIMIZATION PROBLEM
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       NR         ROW DIMENSION OF MATRIX
C       N          DIMENSION OF PROBLEM
C       FCN        SUBROUTINE.  FCN EVALUATES THE FUNCTION TO BE
C                  OPTIMIZED. FCN MUST BE DECLARED EXTERNAL IN THE
C                  CALLING PROGRAM. THE ROUTINE HAS THE FORMAT
C                         CALL FCN (N, X, FVAL)
C                  WHERE X IS A POINT AND FVAL IS THE VALUE OF THE
C                  FUNCTION AT THE POINT.
C       RERR       RELATIVE ACCURACY OF SUBROUTINE FCN. IT IS
C                  ASSUMED THAT RERR IS NONNEGATIVE. IF RERR = 0
C                  THEN FCN IS ACCURATE TO MACHINE PRECISION.
C       ITNLIM     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
C       GRADTL     TOLERANCE AT WHICH THE GRADIENT IS CONSIDERED
C                  CLOSE ENOUGH TO ZERO TO TERMINATE ALGORITHM.
C                  (USED ONLY IN THE SUBROUTINE OPSTP.)
C       STEPTL     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
C                  CONSIDERED CLOSE ENOUGH TO TERMINATE ALGORITHM
C
C     INPUT/OUTPUT ...
C
C       MO         NUMBER OF RESCALINGS OF THE VARIABLES.
C       X(N)       ESTIMATE OF A LOCAL MINIMUM OF FCN
C       TYPSIZ(N)  TYPICAL SIZE FOR EACH COMPONENT OF X
C       FSCALE     ESTIMATE OF SCALE OF MINIMUM VALUE OF FCN.
C                  (USED ONLY IN THE SUBROUTINE OPSTP.)
C       STEPMX     MAXIMUM ALLOWABLE STEP SIZE
C
C     OUTPUT ...
C
C       ITNCNT     NUMBER OF ITERATIONS COMPLETED
C       XPLS(N)    ESTIMATE OF A LOCAL MINIMUM OF FCN
C       FPLS       FUNCTION VALUE AT XPLS
C       GPLS(N)    GRADIENT AT XPLS
C       IERR       TERMINATION CODE
C
C     WORK SPACES ...
C
C       A(N,N)     CHOLESKY DECOMPOSITION OF HESSIAN
C       G(N)       GRADIENT AT THE CURRENT ITERATE
C       P(N)       STEP
C       WRK0(N)    WORKSPACE
C       WRK1(N)    WORKSPACE
C       WRK2(N)    WORKSPACE
C
C-----------------------------------------------------------------------
C     INTERNAL PARAMETERS ...
C
C       RNF        NOISE IN THE SUBROUTINE FCN
C       F          FUNCTION VALUE  FCN(X)
C       FSTACK(NS) STACK OF PREVIOUS FUNCTION VALUES
C       NS         LENGTH OF THE ARRAY FSTACK
C       SPTR       POINTER TO AN ELEMENT IN FSTACK
C-----------------------------------------------------------------------
      DIMENSION X(N),XPLS(N),G(N),GPLS(N),P(N)
      DIMENSION TYPSIZ(N),A(NR,N)
      DIMENSION WRK0(N),WRK1(N),WRK2(N)
      DIMENSION FSTACK(30)
      INTEGER SPTR
      LOGICAL MXTAKE,NOUPDT
      EXTERNAL FCN
C
C     INITIALIZATION
C     --------------
      NS = 30
      STMX = STEPMX
      STEPMX = 0.0
      CALL OPCHK1 (N,X,TYPSIZ,FSCALE,GRADTL,ITNLIM,RERR,STEPMX,IERR)
      IF (IERR .LT. 0) RETURN
      IF (MO .NE. 0) STEPMX = AMAX1(STMX,STEPMX)
C
      RNF = 2.0*AMAX1(RERR,SPMPAR(1))
      SQRNF = SQRT(RNF)
C
      ITNCNT = 0
      IAGFLG = 0
      IRETCD = -1
      ICSCMX = 0
C
C     EVALUATE FCN(X)
C
      CALL FCN(N,X,F)
C
C     EVALUATE FINITE DIFFERENCE GRADIENT
C
      CALL FSTOFD (N, X, FCN, F, G, TYPSIZ, SQRNF)
C
      CALL OPSTP (N,X,F,G,WRK1,ITNCNT,ICSCMX,IERR,GRADTL,STEPTL,
     *            TYPSIZ,FSCALE,ITNLIM,IRETCD,MXTAKE,FSTACK,NS,SPTR)
      IF (IERR .EQ. 0) GO TO 10
      IF (MO .NE. 0) GO TO 210
C
C        APPLY THE FIXED STEP COORDINATE DESCENT PROCEDURE
C        FOR ONE STEP AND CHECK IF THE GRADIENT IS NONZERO
C
         CALL FXDEC (FCN, N, X, F, 10.0)
C
         STEPMX = 0.0
         CALL OPCHK1 (N,X,TYPSIZ,FSCALE,GRADTL,ITNLIM,RERR,STEPMX,IERR)
         CALL FSTOFD (N, X, FCN, F, G, TYPSIZ, SQRNF)
         CALL OPSTP (N,X,F,G,WRK1,ITNCNT,ICSCMX,IERR,GRADTL,STEPTL,
     *               TYPSIZ,FSCALE,ITNLIM,IRETCD,MXTAKE,FSTACK,NS,SPTR)
         IF (IERR .NE. 0) GO TO 210
C
C     THE HESSIAN WILL BE OBTAINED BY SECANT UPDATES.
C     SET A TO THE INITIAL HESSIAN.
C
   10 NM1 = N - 1
      DO 21 J = 1,NM1
         A(J,J) = 1.0/TYPSIZ(J)
         JP1 = J + 1
         DO 20 I = JP1,N
            A(I,J) = 0.0
   20    CONTINUE
   21 CONTINUE
      A(N,N) = 1.0/TYPSIZ(N)
      GO TO 101
C
C
C     ITERATION
C     ---------
  100 IF (MO .GT. 1) GO TO 101
      IF (MOD(ITNCNT,10) .NE. 0) GO TO 101
      IF (ITNCNT + 10 .GE. ITNLIM) GO TO 101
         CALL SCALEX (MO, X, TYPSIZ, N, IERR)
         IF (IERR .EQ. 0) GO TO 101
         MO = MO + 1
         RETURN
  101 ITNCNT = ITNCNT + 1
C
C     SOLVE  A*P = -G  FOR NEWTON STEP
C
  105 DO 110 I = 1,N
        WRK1(I) = -G(I)
  110 CONTINUE
      CALL LLTSLV(NR,N,A,P,WRK1)
C
C     TAKE A STEP, ARRIVING AT THE POINT XPLS
C
      CALL LNSRCH(N,X,F,G,P,XPLS,FPLS,FCN,MXTAKE,IRETCD,
     *            STEPMX,STEPTL,TYPSIZ)
C
C     IF A SATISFACTORY STEP COULD NOT BE FOUND AND FORWARD DIFFERENCE
C     GRADIENT WAS USED, RETRY USING A CENTRAL DIFFERENCE GRADIENT.
C
      IF (IRETCD .NE. 1 .OR. IAGFLG .NE. 0) GO TO 120
C
C        SET IAGFLG FOR CENTRAL DIFFERENCES
C
         IAGFLG = -1
         CBRNF = RNF**(1.0/3.0)
         CALL FSTOCD (N, X, FCN, TYPSIZ, CBRNF, G)
         GO TO 105
C
C     CALCULATE GRADIENT AT XPLS
C
  120 IF (IAGFLG .EQ. 0) GO TO 130
         CALL FSTOCD (N, XPLS, FCN, TYPSIZ, CBRNF, GPLS)
         GO TO 140
  130 CALL FSTOFD (N, XPLS, FCN, FPLS, GPLS, TYPSIZ, SQRNF)
C
C     CHECK WHETHER THE STOPPING CRITERIA SATISFIED
C
  140 CALL OPSTP (N,XPLS,FPLS,GPLS,X,ITNCNT,ICSCMX,IERR,GRADTL,STEPTL,
     *            TYPSIZ,FSCALE,ITNLIM,IRETCD,MXTAKE,FSTACK,NS,SPTR)
      IF (IERR .NE. 0) GO TO 200
C
C     EVALUATE HESSIAN AT XPLS
C
      CALL SECFAC(NR,N,X,G,A,XPLS,GPLS,ITNCNT,SQRNF,
     *               NOUPDT,WRK0,WRK1,WRK2)
C
C     UPDATE F, X, AND G
C
      F = FPLS
      DO 160 I = 1,N
        X(I) = XPLS(I)
        G(I) = GPLS(I)
  160 CONTINUE
      GO TO 100
C
C     TERMINATION
C     -----------
C     RESET XPLS,FPLS,GPLS  IF PREVIOUS ITERATE SOLUTION
C
  200 IF (IERR .NE. 3) RETURN
C
  210 FPLS = F
      DO 220 I = 1,N
         XPLS(I) = X(I)
         GPLS(I) = G(I)
  220 CONTINUE
      RETURN
      END
      SUBROUTINE OPCHK1 (N,X,TYPSIZ,FSCALE,GRADTL,ITNLIM,RERR,
     *                       STEPMX,IERR)
C-----------------------------------------------------------------------
C                  CHECK INPUT FOR REASONABLENESS
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       N          DIMENSION OF PROBLEM
C       X(N)       ESTIMATE OF MINIMUM OF FCN
C       GRADTL     TOLERANCE AT WHICH GRADIENT CONSIDERED CLOSE
C                  ENOUGH TO ZERO TO TERMINATE ALGORITHM
C       ITNLIM     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
C       RERR       RELATIVE ACCURACY OF SUBROUTINE FCN
C
C     INPUT/OUTPUT ...
C
C       TYPSIZ(N)  SCALING VECTOR FOR X
C       FSCALE     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION FCN
C       STEPMX     MAXIMUM STEP SIZE
C
C     OUTPUT ...
C
C       IERR       ERROR INDICATOR
C
C-----------------------------------------------------------------------
      REAL X(N), TYPSIZ(N)
C
C     CHECK THAT PARAMETERS ONLY TAKE ON ACCEPTABLE VALUES.
C     IF NOT, SET THEM TO DEFAULT VALUES.
C
      IERR = 0
C
C     CHECK DIMENSION OF PROBLEM
C
      IF (N .LE. 0) GO TO 805
      IF (N .EQ. 1) GO TO 810
C
C     COMPUTE SCALE MATRIX
C
      DO 10 I = 1,N
        TYPSIZ(I) = ABS(TYPSIZ(I))
        IF (TYPSIZ(I) .EQ. 0.0) TYPSIZ(I) = 1.0
   10 CONTINUE
C
C     CHECK MAXIMUM STEP SIZE
C
      IF (STEPMX .GT. 0.0) GO TO 20
      STPSIZ = 0.0
      DO 15 I = 1, N
         STPSIZ = STPSIZ + (X(I)/TYPSIZ(I))**2
   15 CONTINUE
      STPSIZ = SQRT(STPSIZ)
      STEPMX = AMAX1(1.0E3*STPSIZ, 1.0E3)
   20 CONTINUE
C
C     CHECK FUNCTION SCALE
C
      FSCALE = ABS(FSCALE)
      IF (FSCALE .EQ. 0.0) FSCALE = 1.0
C
C     CHECK GRADIENT TOLERANCE
C
      IF (GRADTL .LT. 0.0) GO TO 815
C
C     CHECK ITERATION LIMIT
C
      IF (ITNLIM .LE. 0) GO TO 820
C
C     CHECK THE ACCURACY OF FCN
C
      IF (RERR .LT. 0.0 .OR. RERR .GT. 1.E-4) GO TO 825
      RETURN
C
C     ERROR EXITS
C
  805 IERR = -1
      GO TO 895
  810 IERR = -2
      GO TO 895
  815 IERR = -3
      GO TO 895
  820 IERR = -4
      GO TO 895
  825 IERR = -5
  895 RETURN
      END
      SUBROUTINE OPSTP(N,XPLS,FPLS,GPLS,X,ITNCNT,ICSCMX,IERR,
     *           GRADTL,STEPTL,TYPSIZ,FSCALE,ITNLIM,IRETCD,MXTAKE,
     *           FSTACK,NS,SPTR)
C-----------------------------------------------------------------------
C            UNCONSTRAINED MINIMIZATION STOPPING CRITERIA
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       N          DIMENSION OF PROBLEM
C       XPLS(N)    NEW ITERATE X(K)
C       FPLS       FUNCTION VALUE AT NEW ITERATE, F(XPLS)
C       GPLS(N)    GRADIENT AT NEW ITERATE, G(XPLS), OR APPROXIMATE
C       X(N)       OLD ITERATE X(K-1)
C       ITNCNT     CURRENT ITERATION K
C       ICSCMX     NUMBER CONSECUTIVE STEPS .GE. STEPMX
C       GRADTL     TOLERANCE AT WHICH RELATIVE GRADIENT CONSIDERED CLOSE
C                  ENOUGH TO ZERO TO TERMINATE ALGORITHM
C       STEPTL     RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
C                  CONSIDERED CLOSE ENOUGH TO TERMINATE ALGORITHM
C       TYPSIZ(N)  SCALING VECTOR FOR X
C       ITNLIM     MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
C       IRETCD     CODE WHICH WAS SET WHEN THE POINT XPLS WAS OBTAINED
C       MXTAKE     BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
C       NS         LENGTH OF THE ARRAY FSTACK
C
C     INPUT/OUTPUT ...
C
C       FSCALE     ESTIMATE OF SCALE OF OBJECTIVE FUNCTION
C       FSTACK(NS) STACK OF PREVIOUS FUNCTION VALUES
C       SPTR       POINTER TO AN ELEMENT IN FSTACK
C
C     OUTPUT ...
C
C       ICSCMX     NUMBER CONSECUTIVE STEPS .GE. STEPMX
C                  (RETAIN VALUE BETWEEN SUCCESSIVE CALLS)
C       IERR       TERMINATION CODE
C
C-----------------------------------------------------------------------
      REAL XPLS(N), GPLS(N), X(N), TYPSIZ(N), FSTACK(NS)
      INTEGER SPTR
      LOGICAL MXTAKE
C
      IERR = 0
C
C     LAST GLOBAL STEP FAILED TO LOCATE A POINT LOWER THAN X
C
      IF (IRETCD .NE. 1) GO TO 10
         IERR = 3
         RETURN
   10 CONTINUE
C
C     FIND DIRECTION IN WHICH RELATIVE GRADIENT MAXIMUM.
C     CHECK WHETHER WITHIN TOLERANCE.
C
      D = AMAX1(ABS(FPLS),FSCALE)
      RGX = 0.0
      DO 20 I = 1,N
         GRD = ABS(GPLS(I))*AMAX1(ABS(XPLS(I)),TYPSIZ(I))
         RGX = AMAX1(RGX, GRD)
   20 CONTINUE
      JERR = 1
      IF (RGX .GT. GRADTL*D) GO TO 30
         IF (ABS(FPLS) .LE. 1.E-9) GO TO 100
         IF (ABS(FPLS) .GT. 0.5*FSCALE) GO TO 100
         FSCALE = ABS(FPLS)
   30 IF (ITNCNT .EQ. 0) RETURN
C
C     FIND DIRECTION IN WHICH RELATIVE STEPSIZE MAXIMUM
C     CHECK WHETHER WITHIN TOLERANCE.
C
      RSX = 0.0
      DO 40 I = 1,N
         RELSTP = ABS(XPLS(I) - X(I))/AMAX1(ABS(XPLS(I)),TYPSIZ(I))
         RSX = AMAX1(RSX,RELSTP)
   40 CONTINUE
      JERR = 2
      IF (RSX .LE. STEPTL) GO TO 100
C
C     CHECK IF FPLS IS SUFFICIENTLY LESS THAN THE NS-TH
C     PREVIOUS VALUE OF FCN.
C
      IF (ITNCNT .GT. NS) GO TO 50
         SPTR = ITNCNT
         FSTACK(SPTR) = FPLS
         GO TO 60
   50 SPTR = SPTR + 1
      IF (SPTR .GT. NS) SPTR = 1
      JERR = 3
      IF (FPLS .GE. (FSTACK(SPTR) - 1.E-3*ABS(FSTACK(SPTR))))
     *        GO TO 100
      FSTACK(SPTR) = FPLS
C
C     CHECK ITERATION LIMIT
C
   60 JERR = 4
      IF (ITNCNT .GE. ITNLIM) GO TO 100
C
C     CHECK NUMBER OF CONSECUTIVE STEPS OF SIZE STEPMX
C
      IF (MXTAKE) GO TO 70
         ICSCMX = 0
         RETURN
   70 ICSCMX = ICSCMX + 1
      IF (ICSCMX .GE. 20) IERR = 5
      RETURN
C
C     TERMINATE
C
  100 IERR = JERR
      RETURN
      END
      SUBROUTINE FXDEC (FCN, N, X, FX, R)
C-----------------------------------------------------------------------
C     FIXED STEP COORDINATE DESCENT PROCEDURE / ONE ITERATION
C-----------------------------------------------------------------------
      REAL X(N)
      EXTERNAL FCN
C
      DO 20 I = 1,N
         H = R * AMAX1(ABS(X(I)), 1.0)
         XI = X(I)
         XPLUS = XI + H
         X(I) = XPLUS
         CALL FCN (N, X, FPLUS)
         XMINUS = XI - 1.1*H
         X(I) = XMINUS
         CALL FCN (N, X, FMINUS)
         X(I) = XI
C
         IF (FX .LE. FPLUS) GO TO 10
            FX = FPLUS
            X(I) = XPLUS
   10    IF (FX .LE. FMINUS) GO TO 20
            FX = FMINUS
            X(I) = XMINUS
   20 CONTINUE
      RETURN
      END
      SUBROUTINE SCALEX (MO, X, TYPSIZ, N, IERR)
      REAL X(N), TYPSIZ(N)
C-----------------------------------------------------------------------
C     RESCALE THE VARIABLES
C-----------------------------------------------------------------------
      XMIN = 1.E-5*SPMPAR(3)
      DO 10 I = 1,N
         T = AMAX1(ABS(X(I)), 1.E-20)
         XMIN = AMIN1(T, XMIN)
   10 CONTINUE
C
      C = 1.E3
      IF (MO .NE. 0) C = 1.E2
      BIG = C*XMIN
      DO 20 I = 1,N
         IF (ABS(X(I)) .GE. BIG) GO TO 30
   20 CONTINUE
      IERR = 0
      RETURN
C
   30 DO 31 I = 1,N
         T = ABS(X(I))/C
         TYPSIZ(I) = AMAX1(T, XMIN)
   31 CONTINUE
      IERR = -10
      RETURN
      END
      SUBROUTINE LLTSLV (NR,N,A,X,B)
C-----------------------------------------------------------------------
C        SOLUTION OF AX = B WHERE A HAS THE FORM L(L-TRANSPOSE)
C           BUT ONLY THE LOWER TRIANGULAR PART L IS STORED.
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       NR       ROW DIMENSION OF MATRIX
C       N        ORDER OF THE MATRIX
C       A(N,N)   MATRIX OF FORM L(L-TRANSPOSE). A IS NOT
C                MODIFIED BY THE ROUTINE.
C       B(N)     RIGHT-HAND SIDE VECTOR
C
C     OUTPUT ...
C
C       X(N)     SOLUTION VECTOR
C
C-----------------------------------------------------------------------
C     NOTE.  B AND X MAY SHARE THE SAME STORAGE AREA.
C-----------------------------------------------------------------------
      REAL A(NR,N), X(N), B(N)
C
C                  FORWARD SOLVE, RESULT IN X
C
      X(1) = B(1)/A(1,1)
      IF (N .EQ. 1) GO TO 30
      DO 20 I = 2,N
         SUM = 0.0
         IM1 = I - 1
         DO 10 J = 1,IM1
            SUM = SUM + A(I,J)*X(J)
   10    CONTINUE
         X(I) = (B(I) - SUM)/A(I,I)
   20 CONTINUE
C
C                   BACK SOLVE, RESULT IN X
C
   30 X(N) = X(N)/A(N,N)
      IF (N .EQ. 1) RETURN
      I = N
      DO 50 II = 2,N
         IP1 = I
         I = I - 1
         SUM = 0.0
         DO 40 J = IP1,N
            SUM = SUM + A(J,I)*X(J)
   40    CONTINUE
         X(I) = (X(I) - SUM)/A(I,I)
   50 CONTINUE
      RETURN
      END
      SUBROUTINE FSTOFD (N, X, FCN, FX, G, TYPSIZ, R)
C-----------------------------------------------------------------------
C     FIND FORWARD DIFFERENCE APPROXIMATION G TO THE FIRST DERIVATIVE
C     (GRADIENT) OF THE FUNCTION DEFINED BY FCN AT THE POINT X.
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       N          DIMENSION OF PROBLEM
C       X(N)       POINT AT WHICH THE GRADIENT IS TO BE APPROXIMATED
C       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
C       FX         VALUE OF FCN AT THE POINT X
C       TYPSIZ(N)  SCALING VECTOR FOR X
C       R          STEPSIZE FACTOR
C
C     OUTPUT ...
C
C       G(N)       FINITE DIFFERENCE APPROXIMATION TO THE GRADIENT
C
C-----------------------------------------------------------------------
      DIMENSION X(N), G(N), TYPSIZ(N)
      EXTERNAL FCN
C
      DO 10 J = 1,N
        STEPSZ = R * AMAX1(ABS(X(J)),TYPSIZ(J))
        XTMPJ = X(J)
        X(J) = XTMPJ + STEPSZ
        CALL FCN (N, X, FPLUS)
        X(J) = XTMPJ
        G(J) = (FPLUS - FX)/STEPSZ
   10 CONTINUE
      RETURN
      END
      SUBROUTINE FSTOCD (N, X, FCN, TYPSIZ, R, G)
C-----------------------------------------------------------------------
C     FIND CENTRAL DIFFERENCE APPROXIMATION G TO THE FIRST DERIVATIVE
C     (GRADIENT) OF THE FUNCTION DEFINED BY FCN AT THE POINT X.
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       N          DIMENSION OF PROBLEM
C       X(N)       POINT AT WHICH GRADIENT IS TO BE APPROXIMATED
C       FCN        NAME OF SUBROUTINE TO EVALUATE FUNCTION
C       TYPSIZ(N)  SCALING VECTOR FOR X
C       R          STEPSIZE FACTOR
C
C     OUTPUT ...
C
C       G(N)       CENTRAL DIFFERENCE APPROXIMATION TO GRADIENT
C
C-----------------------------------------------------------------------
      REAL X(N), TYPSIZ(N), G(N)
      EXTERNAL FCN
C
C     FIND I-TH  STEPSIZE, EVALUATE TWO NEIGHBORS IN DIRECTION OF
C     I-TH UNIT VECTOR, AND EVALUATE I-TH  COMPONENT OF GRADIENT.
C
      DO 10 I = 1, N
         STEPI = R * AMAX1(ABS(X(I)),TYPSIZ(I))
         XTEMPI = X(I)
         X(I) = XTEMPI + STEPI
         CALL FCN (N, X, FPLUS)
         X(I) = XTEMPI - STEPI
         CALL FCN (N, X, FMINUS)
         X(I) = XTEMPI
         G(I) = (FPLUS - FMINUS)/(2.0*STEPI)
   10 CONTINUE
      RETURN
      END
      SUBROUTINE LNSRCH(N,X,F,G,P,XPLS,FPLS,FCN,MXTAKE,IRETCD,
     *                  STEPMX,STEPTL,TYPSIZ)
C-----------------------------------------------------------------------
C             FIND A NEXT NEWTON ITERATE BY LINE SEARCH
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       N         DIMENSION OF PROBLEM
C       X(N)      OLD ITERATE X(K-1)
C       F         FUNCTION VALUE AT OLD ITERATE, F(X)
C       G(N)      GRADIENT AT OLD ITERATE, G(X)
C       P(N)      NON-ZERO NEWTON STEP
C       FCN       NAME OF SUBROUTINE TO EVALUATE FUNCTION
C       STEPMX    MAXIMUM ALLOWABLE STEP SIZE
C       STEPTL    RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
C                 CONSIDERED CLOSE ENOUGH TO TERMINATE ALGORITHM
C       TYPSIZ(N) SCALING VECTOR FOR X
C
C     OUTPUT ...
C
C       XPLS(N)   NEW ITERATE X(K)
C       FPLS      FUNCTION VALUE AT NEW ITERATE, F(XPLS)
C       IRETCD    RETURN CODE
C       MXTAKE    BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
C
C-----------------------------------------------------------------------
C     INTERNAL VARIABLES ...
C
C       SLN      NEWTON LENGTH
C       RLN      RELATIVE LENGTH OF NEWTON STEP
C-----------------------------------------------------------------------
      REAL X(N), G(N), P(N), XPLS(N), TYPSIZ(N)
      REAL LAMBDA
      LOGICAL MXTAKE
      EXTERNAL FCN
C
      MXTAKE = .FALSE.
      IRETCD = 2
      TMP = 0.0
      DO 10 I = 1,N
         TMP = TMP + (P(I)/TYPSIZ(I))**2
   10 CONTINUE
      SLN = SQRT(TMP)
C
      IF (SLN .LE. STEPMX) GO TO 30
C
C     NEWTON STEP LONGER THAN MAXIMUM ALLOWED
C
         SCL = STEPMX/SLN
         DO 20 I = 1,N
            P(I) = SCL*P(I)
   20    CONTINUE
         SLN = STEPMX
C
   30 SLP = SDOT(N,G,1,P,1)
      RLN = 0.0
      DO 40 I = 1,N
         RLN = AMAX1(RLN,ABS(P(I))/AMAX1(ABS(X(I)),TYPSIZ(I)))
   40 CONTINUE
      RMNLMB = STEPTL/RLN
      LAMBDA = 1.0
C
C     LOOP.  CHECK IF THE NEW ITERATE IS SATISFACTORY.
C
  100 DO 110 I = 1,N
        XPLS(I) = X(I) + LAMBDA*P(I)
  110 CONTINUE
      CALL FCN(N,XPLS,FPLS)
      IF (FPLS .LE. F + SLP*1.E-4*LAMBDA) GO TO 200
C
C     SOLUTION NOT (YET) FOUND
C
        IF (LAMBDA .LT. RMNLMB) GO TO 210
C
C     CALCULATE NEW LAMBDA
C
        IF (LAMBDA .NE. 1.0) GO TO 120
C
C     FIRST BACKTRACK. QUADRATIC FIT
C
            TLMBDA = AMIN1(-SLP/(2.0*(FPLS - F - SLP)), 0.9)
            GO TO 170
C
C     ALL SUBSEQUENT BACKTRACKS. CUBIC FIT
C
  120       T1 = (FPLS - F - LAMBDA*SLP)/(LAMBDA*LAMBDA)
            T2 = (PFPLS - F - PLMBDA*SLP)/(PLMBDA*PLMBDA)
            T3 = 1.0/(LAMBDA - PLMBDA)
            A = T3*(T1 - T2)
            B = T3*(T2*LAMBDA - T1*PLMBDA)
            W = 10.0*ABS(T1*T3)
            IF ((ABS(A) + W) .NE. W) GO TO 130
C
C     THE CUBIC FIT DEGENERATES TO A QUADRATIC FIT
C
               TLMBDA = -SLP/(2.0*B)
               GO TO 160
C
C     THE CUBIC IS NONDEGENERATE
C
  130       DISC = B*B - 3.0*A*SLP
            IF (DISC .LE. B*B) GO TO 140
C
C     ONLY ONE POSITIVE CRITICAL POINT, MUST BE MINIMUM
C
               TLMBDA = (-B + SIGN(1.0,A)*SQRT(DISC))/(3.0*A)
               GO TO 160
C
C     BOTH CRITICAL POINTS POSITIVE, FIRST IS MINIMUM
C
  140          IF (DISC .GT. 0.0) GO TO 150
                  TLMBDA = -B/(3.0*A)
                  GO TO 160
  150          TLMBDA = (-B - SIGN(1.0,A)*SQRT(DISC))/(3.0*A)
C
  160       IF (TLMBDA .GT. 0.5*LAMBDA) TLMBDA = 0.5*LAMBDA
C
C
  170     PLMBDA = LAMBDA
          PFPLS = FPLS
          IF (TLMBDA .GE. LAMBDA*0.1) GO TO 180
            LAMBDA = LAMBDA*0.1
            GO TO 100
  180     LAMBDA = TLMBDA
          GO TO 100
C
C     A SUITABLE VALUE FOR XPLS HAS BEEN OBTAINED
C
  200 IRETCD = 0
      IF (LAMBDA .EQ. 1.0 .AND. SLN .GT. 0.99*STEPMX) MXTAKE =.TRUE.
      RETURN
C
C     NO SATISFACTORY XPLS FOUND SUFFICIENTLY DISTINCT FROM X
C
  210 IRETCD = 1
      RETURN
      END
      SUBROUTINE SECFAC (NR,N,X,G,A,XPLS,GPLS,ITNCNT,TOL,
     *                      NOUPDT,S,Y,W)
C-----------------------------------------------------------------------
C           UPDATE HESSIAN BY THE BFGS FACTORED METHOD
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       NR        ROW DIMENSION OF MATRIX
C       N         ORDER OF THE MATRIX
C       X(N)      OLD ITERATE X(K-1)
C       G(N)      GRADIENT AT THE OLD ITERATE
C       XPLS(N)   NEW ITERATE X(K)
C       GPLS(N)   GRADIENT AT THE NEW ITERATE
C       ITNCNT    ITERATION COUNT
C       TOL       RELATIVE TOLERANCE TO BE USED FOR NOISE
C
C     INPUT/OUTPUT ...
C
C       A(N,N)    ON ENTRY, CHOLESKY DECOMPOSITION OF HESSIAN IN
C                    THE LOWER PART AND DIAGONAL.
C                 ON EXIT,  UPDATED CHOLESKY DECOMPOSITION OF HESSIAN
C                    IN THE LOWER TRIANGULAR PART AND DIAGONAL.
C       NOUPDT    BOOLEAN. NO UPDATE YET.
C
C     WORK SPACES ...  S(N), Y(N), W(N)
C
C-----------------------------------------------------------------------
      REAL X(N), XPLS(N), G(N), GPLS(N)
      REAL A(NR,N)
      REAL S(N), Y(N), W(N)
      LOGICAL NOUPDT
C
      IF (ITNCNT .EQ. 1) NOUPDT = .TRUE.
      DO 10 I = 1,N
         S(I) = XPLS(I) - X(I)
         Y(I) = GPLS(I) - G(I)
   10 CONTINUE
      DEN1 = SDOT(N,S,1,Y,1)
      SNORM2 = SNRM2(N,S,1)
      YNRM2 = SNRM2(N,Y,1)
      IF (DEN1 .LT. TOL*SNORM2*YNRM2) RETURN
C
C     SET S = TRANSPOSE(L)*S
C
      DO 21 I = 1,N
         SUM = 0.0
         DO 20 J = I,N
            SUM = SUM + A(J,I)*S(J)
   20    CONTINUE
         S(I) = SUM
   21 CONTINUE
      DEN2 = SDOT(N,S,1,S,1)
C
C     SET ALP = SQRT(DEN1/DEN2)
C
      ALP = SQRT(DEN1/DEN2)
      IF (.NOT.NOUPDT) GO TO 40
C
C        ON THE INITIAL UPDATE SET L = ALP*L. THEN S MUST BE
C        RESET TO ALP*S. AFTER THIS IS DONE THEN DEN2 = DEN1
C        AND ALP HAS THE VALUE 1.
C
         DO 31 J = 1,N
            S(J) = ALP*S(J)
            DO 30 I = J,N
               A(I,J) = ALP*A(I,J)
   30       CONTINUE
   31    CONTINUE
         NOUPDT = .FALSE.
         ALP = 1.0
C
C     SET W = L*S
C
   40 DO 51 I = 1,N
         SUM = 0.0
         DO 50 J = 1,I
            SUM = SUM + A(I,J)*S(J)
   50    CONTINUE
         W(I) = SUM
   51 CONTINUE
C
C     IF ABS(Y(I) - W(I)) IS LESS THAN THE ESTIMATED NOISE IN Y(I)
C     FOR EACH I, THEN THE UPDATE IS SKIPPED.
C
      DO 60 I = 1,N
      IF (ABS(Y(I) - W(I)) .GE. TOL*AMAX1(ABS(G(I)),ABS(GPLS(I))))
     *         GO TO 70
   60 CONTINUE
      RETURN
C
C     W = Y - ALP*L*S
C
   70 DO 71 I = 1,N
         W(I) = Y(I) - ALP*W(I)
   71 CONTINUE
C
C     S = S/SQRT(DEN1*DEN2)
C
      ALP = ALP/DEN1
      DO 80 I = 1,N
         S(I) = ALP*S(I)
   80 CONTINUE
C
C     COPY L INTO UPPER TRIANGULAR PART.  ZERO L.
C
      DO 100 I = 2,N
         IM1 = I - 1
         DO 90 J = 1,IM1
            A(J,I) = A(I,J)
            A(I,J) = 0.0
   90    CONTINUE
  100 CONTINUE
C
C     FIND Q AND R SUCH THAT  Q*R = (L+) + S*(W+)
C
      CALL QRUPDT (NR, N, A, S, W)
C
C     UPPER TRIANGULAR PART AND DIAGONAL OF A NOW CONTAIN UPDATED
C     CHOLESKY DECOMPOSITION OF HESSIAN.  COPY BACK TO LOWER
C     TRIANGULAR PART.
C
      DO 120 I = 2,N
         IM1 = I - 1
         DO 110 J = 1,IM1
            A(I,J) = A(J,I)
  110    CONTINUE
  120 CONTINUE
      RETURN
      END
      SUBROUTINE QRUPDT (NR,N,A,U,V)
C-----------------------------------------------------------------------
C     FIND AN ORTHOGONAL MATRIX (Q*) AND AN UPPER TRIANGULAR
C          MATRIX (R*) SUCH THAT (Q*)(R*) = R + U(V+)
C-----------------------------------------------------------------------
C
C     PARAMETERS ...
C
C       NR      ROW DIMENSION OF THE MATRIX
C       N       ORDER OF THE MATRIX
C       A(N,N)  ON INPUT,  CONTAINS R
C               ON OUTPUT, CONTAINS (R*)
C       U(N)    VECTOR
C       V(N)    VECTOR
C
C-----------------------------------------------------------------------
      REAL A(NR,N), U(N), V(N)
C
C                DETERMINE LAST NON-ZERO IN U
C
      K = N
   10 IF (U(K) .NE. 0.0 .OR. K .EQ. 1) GO TO 20
         K = K - 1
         GO TO 10
C
C               K-1 JACOBI ROTATIONS TRANSFORM
C             R + U(V+)  TO  (R*) + (U(1)*E1)(V+)
C                 WHICH IS UPPER HESSENBERG
C
   20 KM1 = K - 1
      IF (K .LE. 1) GO TO 40
      DO 30 II = 1,KM1
         I = K - II
         CALL JROT (NR,N,A,I,U(I),-U(I+1),R)
         U(I) = R
   30 CONTINUE
C
C SET R = R + (U(1)*E1)(V+)
C
   40 DO 50 J = 1,N
         A(1,J) = A(1,J) + U(1)*V(J)
   50 CONTINUE
      IF (K .LE. 1) RETURN
C
C       K-1 JACOBI ROTATIONS TRANSFORM UPPER HESSENBERG R
C                   TO UPPER TRIANGULAR R*
C
      DO 60 I = 1,KM1
         CALL JROT (NR,N,A,I,A(I,I),-A(I+1,I),R)
   60 CONTINUE
      RETURN
      END
      SUBROUTINE JROT (NR,N,H,I,A,B,R)
C-----------------------------------------------------------------------
C         PRE-MULTIPLICATION OF AN UPPER HESSENBERG MATRIX H
C               BY THE JACOBIAN ROTATION J(I,I+1,A,B)
C-----------------------------------------------------------------------
C
C     INPUT ...
C
C       NR      ROW DIMENSION OF THE MATRIX
C       N       ORDER OF THE MATRIX
C       H(N,N)  UPPER HESSENBER MATRIX
C       I       INDEX OF ROW
C       A,B     SCALARS
C
C     OUTPUT ...
C
C       H(N,N)  THE MODIFIED HESSENBERG MATRIX
C       R       R = SQRT(A*A + B*B)
C
C-----------------------------------------------------------------------
      REAL H(NR,N)
C
C                COMPUTE C = A/R  AND S = B/R
C
      IF (ABS(A) .LE. ABS(B)) GO TO 10
         T = B/A
         Z = SQRT(1.0 + T*T)
         C = SIGN(1.0/Z, A)
         S = T*C
         R = Z*ABS(A)
         GO TO 20
   10 IF (A .EQ. 0.0) GO TO 40
      T = A/B
      Z = SQRT(1.0 + T*T)
      S = SIGN(1.0/Z, B)
      C = T*S
      R = Z*ABS(B)
C
C            APPLY THE ROTATION WHEN A IS NONZERO
C
   20 DO 30 J = I,N
         T = H(I,J)
         Z = H(I+1,J)
         H(I,J) = C*T - S*Z
         H(I+1,J) = S*T + C*Z
   30 CONTINUE
      RETURN
C
C                     CASE WHEN A = 0
C
   40 S = SIGN(1.0, B)
      R = ABS(B)
      DO 50 J = I,N
         T = H(I,J)
         H(I,J) = - S*H(I+1,J)
         H(I+1,J) = S*T
   50 CONTINUE
      RETURN
      END
      SUBROUTINE LMDIFF (FCN,M,N,X,FVEC,EPSFCN,TOL,INFO,IWA,WA,LWA)
      INTEGER M,N,INFO,LWA
      INTEGER IWA(N)
      REAL EPSFCN,TOL
      REAL X(N),FVEC(M),WA(LWA)
      EXTERNAL FCN
C     **********
C
C     SUBROUTINE LMDIFF
C
C     THE PURPOSE OF LMDIFF IS TO MINIMIZE THE SUM OF THE SQUARES OF
C     M NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION OF THE
C     LEVENBERG-MARQUARDT ALGORITHM. THIS IS DONE BY USING THE MORE
C     GENERAL LEAST-SQUARES SOLVER LMDIF. THE USER MUST PROVIDE A
C     SUBROUTINE WHICH CALCULATES THE FUNCTIONS. THE JACOBIAN IS
C     THEN CALCULATED BY A FORWARD-DIFFERENCE APPROXIMATION.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE LMDIFF(FCN,M,N,X,FVEC,EPSFCN,TOL,INFO,IWA,WA,LWA)
C
C     WHERE
C
C       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
C         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
C         IN AN EXTERNAL STATEMENT IN THE USER CALLING
C         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
C
C         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
C         INTEGER M,N,IFLAG
C         REAL X(N),FVEC(M)
C         ----------
C         CALCULATE THE FUNCTIONS AT X AND
C         RETURN THIS VECTOR IN FVEC.
C         ----------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF LMDIFF.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF VARIABLES. N MUST NOT EXCEED M.
C
C       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
C         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
C         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
C
C       FVEC IS AN OUTPUT ARRAY OF LENGTH M WHICH CONTAINS
C         THE FUNCTIONS EVALUATED AT THE OUTPUT X.
C
C       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
C         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
C         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
C         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
C         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
C         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
C         PRECISION.
C
C       TOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION OCCURS
C         WHEN THE ALGORITHM ESTIMATES EITHER THAT THE RELATIVE
C         ERROR IN THE SUM OF SQUARES IS AT MOST TOL OR THAT
C         THE RELATIVE ERROR BETWEEN X AND THE SOLUTION IS AT
C         MOST TOL.
C
C       INFO IS AN INTEGER OUTPUT VARIABLE. IF THE USER HAS
C         TERMINATED EXECUTION, INFO IS SET TO THE (NEGATIVE)
C         VALUE OF IFLAG. SEE DESCRIPTION OF FCN. OTHERWISE,
C         INFO IS SET AS FOLLOWS.
C
C         INFO = 0  IMPROPER INPUT PARAMETERS.
C
C         INFO = 1  ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
C                   IN THE SUM OF SQUARES IS AT MOST TOL.
C
C         INFO = 2  ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
C                   BETWEEN X AND THE SOLUTION IS AT MOST TOL.
C
C         INFO = 3  CONDITIONS FOR INFO = 1 AND INFO = 2 BOTH HOLD.
C
C         INFO = 4  FVEC IS ORTHOGONAL TO THE COLUMNS OF THE
C                   JACOBIAN TO MACHINE PRECISION.
C
C         INFO = 5  NUMBER OF CALLS TO FCN HAS REACHED OR
C                   EXCEEDED 200*(N+1).
C
C         INFO = 6  TOL IS TOO SMALL. NO FURTHER REDUCTION IN
C                   THE SUM OF SQUARES IS POSSIBLE.
C
C         INFO = 7  TOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
C                   THE APPROXIMATE SOLUTION X IS POSSIBLE.
C
C       IWA IS AN INTEGER WORK ARRAY OF LENGTH N.
C
C       WA IS A WORK ARRAY OF LENGTH LWA.
C
C       LWA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
C         M*N+5*N+M.
C
C     SUBPROGRAMS CALLED
C
C       USER-SUPPLIED ...... FCN
C
C       MINPACK-SUPPLIED ... LMDIF
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER MAXFEV,MODE,MP5N,NFEV,NPRINT
      REAL FACTOR,FTOL,GTOL,XTOL
      DATA FACTOR /1.0E2/
      INFO = 0
C
C     CHECK THE INPUT PARAMETERS FOR ERRORS.
C
      IF (N .LE. 0 .OR. M .LT. N .OR. EPSFCN .LT. 0.0
     *    .OR. TOL .LT. 0.0 .OR. LWA .LT. M*N + 5*N + M) GO TO 10
C
C     CALL LMDIF.
C
      MAXFEV = 200*(N + 1)
      FTOL = TOL
      XTOL = TOL
      GTOL = 0.0
      MODE = 1
      NPRINT = 0
      MP5N = M + 5*N
      CALL LMDIF(FCN,M,N,X,FVEC,FTOL,XTOL,GTOL,MAXFEV,EPSFCN,WA(1),
     *           MODE,FACTOR,NPRINT,INFO,NFEV,WA(MP5N+1),M,IWA,
     *           WA(N+1),WA(2*N+1),WA(3*N+1),WA(4*N+1),WA(5*N+1))
      IF (INFO .EQ. 8) INFO = 4
   10 CONTINUE
      RETURN
      END
      SUBROUTINE LMDIF(FCN,M,N,X,FVEC,FTOL,XTOL,GTOL,MAXFEV,EPSFCN,
     *                 DIAG,MODE,FACTOR,NPRINT,INFO,NFEV,FJAC,LDFJAC,
     *                 IPVT,QTF,WA1,WA2,WA3,WA4)
      INTEGER M,N,MAXFEV,MODE,NPRINT,INFO,NFEV,LDFJAC
      INTEGER IPVT(N)
      REAL FTOL,XTOL,GTOL,EPSFCN,FACTOR
      REAL X(N),FVEC(M),DIAG(N),FJAC(LDFJAC,N),QTF(N),WA1(N),WA2(N),
     *     WA3(N),WA4(M)
      EXTERNAL FCN
C     **********
C
C     SUBROUTINE LMDIF
C
C     THE PURPOSE OF LMDIF IS TO MINIMIZE THE SUM OF THE SQUARES OF
C     M NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION OF
C     THE LEVENBERG-MARQUARDT ALGORITHM. THE USER MUST PROVIDE A
C     SUBROUTINE WHICH CALCULATES THE FUNCTIONS. THE JACOBIAN IS
C     THEN CALCULATED BY A FORWARD-DIFFERENCE APPROXIMATION.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE LMDIF(FCN,M,N,X,FVEC,FTOL,XTOL,GTOL,MAXFEV,EPSFCN,
C                        DIAG,MODE,FACTOR,NPRINT,INFO,NFEV,FJAC,
C                        LDFJAC,IPVT,QTF,WA1,WA2,WA3,WA4)
C
C     WHERE
C
C       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
C         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
C         IN AN EXTERNAL STATEMENT IN THE USER CALLING
C         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
C
C         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
C         INTEGER M,N,IFLAG
C         REAL X(N),FVEC(M)
C         ----------
C         CALCULATE THE FUNCTIONS AT X AND
C         RETURN THIS VECTOR IN FVEC.
C         ----------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF LMDIF.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF VARIABLES. N MUST NOT EXCEED M.
C
C       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
C         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
C         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
C
C       FVEC IS AN OUTPUT ARRAY OF LENGTH M WHICH CONTAINS
C         THE FUNCTIONS EVALUATED AT THE OUTPUT X.
C
C       FTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
C         OCCURS WHEN BOTH THE ACTUAL AND PREDICTED RELATIVE
C         REDUCTIONS IN THE SUM OF SQUARES ARE AT MOST FTOL.
C         THEREFORE, FTOL MEASURES THE RELATIVE ERROR DESIRED
C         IN THE SUM OF SQUARES.
C
C       XTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE RELATIVE ERROR BETWEEN TWO CONSECUTIVE
C         ITERATES IS AT MOST XTOL. THEREFORE, XTOL MEASURES THE
C         RELATIVE ERROR DESIRED IN THE APPROXIMATE SOLUTION.
C
C       GTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE COSINE OF THE ANGLE BETWEEN FVEC AND
C         ANY COLUMN OF THE JACOBIAN IS AT MOST GTOL IN ABSOLUTE
C         VALUE. THEREFORE, GTOL MEASURES THE ORTHOGONALITY
C         DESIRED BETWEEN THE FUNCTION VECTOR AND THE COLUMNS
C         OF THE JACOBIAN.
C
C       MAXFEV IS A POSITIVE INTEGER INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE NUMBER OF CALLS TO FCN IS AT LEAST
C         MAXFEV BY THE END OF AN ITERATION.
C
C       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
C         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
C         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
C         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
C         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
C         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
C         PRECISION.
C
C       DIAG IS AN ARRAY OF LENGTH N. IF MODE = 1 (SEE
C         BELOW), DIAG IS INTERNALLY SET. IF MODE = 2, DIAG
C         MUST CONTAIN POSITIVE ENTRIES THAT SERVE AS
C         MULTIPLICATIVE SCALE FACTORS FOR THE VARIABLES.
C
C       MODE IS AN INTEGER INPUT VARIABLE. IF MODE = 1, THE
C         VARIABLES WILL BE SCALED INTERNALLY. IF MODE = 2,
C         THE SCALING IS SPECIFIED BY THE INPUT DIAG. OTHER
C         VALUES OF MODE ARE EQUIVALENT TO MODE = 1.
C
C       FACTOR IS A POSITIVE INPUT VARIABLE USED IN DETERMINING THE
C         INITIAL STEP BOUND. THIS BOUND IS SET TO THE PRODUCT OF
C         FACTOR AND THE EUCLIDEAN NORM OF DIAG*X IF NONZERO, OR ELSE
C         TO FACTOR ITSELF. IN MOST CASES FACTOR SHOULD LIE IN THE
C         INTERVAL (.1,100.). 100. IS A GENERALLY RECOMMENDED VALUE.
C
C       NPRINT IS AN INTEGER INPUT VARIABLE THAT ENABLES CONTROLLED
C         PRINTING OF ITERATES IF IT IS POSITIVE. IN THIS CASE,
C         FCN IS CALLED WITH IFLAG = 0 AT THE BEGINNING OF THE FIRST
C         ITERATION AND EVERY NPRINT ITERATIONS THEREAFTER AND
C         IMMEDIATELY PRIOR TO RETURN, WITH X AND FVEC AVAILABLE
C         FOR PRINTING. IF NPRINT IS NOT POSITIVE, NO SPECIAL CALLS
C         OF FCN WITH IFLAG = 0 ARE MADE.
C
C       INFO IS AN INTEGER OUTPUT VARIABLE. IF THE USER HAS
C         TERMINATED EXECUTION, INFO IS SET TO THE (NEGATIVE)
C         VALUE OF IFLAG. SEE DESCRIPTION OF FCN. OTHERWISE,
C         INFO IS SET AS FOLLOWS.
C
C         INFO = 0  IMPROPER INPUT PARAMETERS.
C
C         INFO = 1  BOTH ACTUAL AND PREDICTED RELATIVE REDUCTIONS
C                   IN THE SUM OF SQUARES ARE AT MOST FTOL.
C
C         INFO = 2  RELATIVE ERROR BETWEEN TWO CONSECUTIVE ITERATES
C                   IS AT MOST XTOL.
C
C         INFO = 3  CONDITIONS FOR INFO = 1 AND INFO = 2 BOTH HOLD.
C
C         INFO = 4  THE COSINE OF THE ANGLE BETWEEN FVEC AND ANY
C                   COLUMN OF THE JACOBIAN IS AT MOST GTOL IN
C                   ABSOLUTE VALUE.
C
C         INFO = 5  NUMBER OF CALLS TO FCN HAS REACHED OR
C                   EXCEEDED MAXFEV.
C
C         INFO = 6  FTOL IS TOO SMALL. NO FURTHER REDUCTION IN
C                   THE SUM OF SQUARES IS POSSIBLE.
C
C         INFO = 7  XTOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
C                   THE APPROXIMATE SOLUTION X IS POSSIBLE.
C
C         INFO = 8  GTOL IS TOO SMALL. FVEC IS ORTHOGONAL TO THE
C                   COLUMNS OF THE JACOBIAN TO MACHINE PRECISION.
C
C       NFEV IS AN INTEGER OUTPUT VARIABLE SET TO THE NUMBER OF
C         CALLS TO FCN.
C
C       FJAC IS AN OUTPUT M BY N ARRAY. THE UPPER N BY N SUBMATRIX
C         OF FJAC CONTAINS AN UPPER TRIANGULAR MATRIX R WITH
C         DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE SUCH THAT
C
C                T     T           T
C               P *(JAC *JAC)*P = R *R,
C
C         WHERE P IS A PERMUTATION MATRIX AND JAC IS THE FINAL
C         CALCULATED JACOBIAN. COLUMN J OF P IS COLUMN IPVT(J)
C         (SEE BELOW) OF THE IDENTITY MATRIX. THE LOWER TRAPEZOIDAL
C         PART OF FJAC CONTAINS INFORMATION GENERATED DURING
C         THE COMPUTATION OF R.
C
C       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
C
C       IPVT IS AN INTEGER OUTPUT ARRAY OF LENGTH N. IPVT
C         DEFINES A PERMUTATION MATRIX P SUCH THAT JAC*P = Q*R,
C         WHERE JAC IS THE FINAL CALCULATED JACOBIAN, Q IS
C         ORTHOGONAL (NOT STORED), AND R IS UPPER TRIANGULAR
C         WITH DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE.
C         COLUMN J OF P IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C
C       QTF IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS
C         THE FIRST N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*FVEC.
C
C       WA1, WA2, AND WA3 ARE WORK ARRAYS OF LENGTH N.
C
C       WA4 IS A WORK ARRAY OF LENGTH M.
C
C     SUBPROGRAMS CALLED
C
C       USER-SUPPLIED ...... FCN
C
C       MINPACK-SUPPLIED ... SPMPAR,ENORM,FDJAC2,LMPAR,QRFAC
C
C       FORTRAN-SUPPLIED ... ABS,AMAX1,AMIN1,SQRT,MOD
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,IFLAG,ITER,J,L
      REAL ACTRED,DELTA,DIRDER,EPS,FNORM,FNORM1,GNORM,PAR,
     *     PNORM,PRERED,P1,P5,P25,P75,P0001,RATIO,SUM,TEMP,TEMP1,
     *     TEMP2,XNORM
      REAL SPMPAR,ENORM
      DATA P1,P5,P25,P75,P0001
     *     /1.0E-1,5.0E-1,2.5E-1,7.5E-1,1.0E-4/
C
C     EPS IS THE MACHINE PRECISION.
C
      EPS = SPMPAR(1)
C
      INFO = 0
      IFLAG = 0
      NFEV = 0
C
C     CHECK THE INPUT PARAMETERS FOR ERRORS.
C
      IF (N .LE. 0 .OR. M .LT. N .OR. LDFJAC .LT. M
     *    .OR. FTOL .LT. 0.0 .OR. XTOL .LT. 0.0 .OR. GTOL .LT. 0.0
     *    .OR. MAXFEV .LE. 0 .OR. FACTOR .LE. 0.0) GO TO 300
      IF (MODE .NE. 2) GO TO 20
      DO 10 J = 1, N
         IF (DIAG(J) .LE. 0.0) GO TO 300
   10    CONTINUE
   20 CONTINUE
C
C     EVALUATE THE FUNCTION AT THE STARTING POINT
C     AND CALCULATE ITS NORM.
C
      IFLAG = 1
      CALL FCN(M,N,X,FVEC,IFLAG)
      NFEV = 1
      IF (IFLAG .LT. 0) GO TO 300
      FNORM = ENORM(M,FVEC)
C
C     INITIALIZE LEVENBERG-MARQUARDT PARAMETER AND ITERATION COUNTER.
C
      PAR = 0.0
      ITER = 1
C
C     BEGINNING OF THE OUTER LOOP.
C
   30 CONTINUE
C
C        CALCULATE THE JACOBIAN MATRIX.
C
         IFLAG = 2
         CALL FDJAC2(FCN,M,N,X,FVEC,FJAC,LDFJAC,IFLAG,EPSFCN,WA4)
         NFEV = NFEV + N
         IF (IFLAG .LT. 0) GO TO 300
C
C        IF REQUESTED, CALL FCN TO ENABLE PRINTING OF ITERATES.
C
         IF (NPRINT .LE. 0) GO TO 40
         IFLAG = 0
         IF (MOD(ITER-1,NPRINT) .EQ. 0) CALL FCN(M,N,X,FVEC,IFLAG)
         IF (IFLAG .LT. 0) GO TO 300
   40    CONTINUE
C
C        COMPUTE THE QR FACTORIZATION OF THE JACOBIAN.
C
         CALL QRFAC(M,N,FJAC,LDFJAC,.TRUE.,IPVT,N,WA1,WA2,WA3)
C
C        ON THE FIRST ITERATION AND IF MODE IS 1, SCALE ACCORDING
C        TO THE NORMS OF THE COLUMNS OF THE INITIAL JACOBIAN.
C
         IF (ITER .NE. 1) GO TO 80
         IF (MODE .EQ. 2) GO TO 60
         DO 50 J = 1, N
            DIAG(J) = WA2(J)
            IF (WA2(J) .EQ. 0.0) DIAG(J) = 1.0
   50       CONTINUE
   60    CONTINUE
C
C        ON THE FIRST ITERATION, CALCULATE THE NORM OF THE SCALED X
C        AND INITIALIZE THE STEP BOUND DELTA.
C
         DO 70 J = 1, N
            WA3(J) = DIAG(J)*X(J)
   70       CONTINUE
         XNORM = ENORM(N,WA3)
         DELTA = FACTOR*XNORM
         IF (DELTA .EQ. 0.0) DELTA = FACTOR
   80    CONTINUE
C
C        FORM (Q TRANSPOSE)*FVEC AND STORE THE FIRST N COMPONENTS IN
C        QTF.
C
         DO 90 I = 1, M
            WA4(I) = FVEC(I)
   90       CONTINUE
         DO 130 J = 1, N
            IF (FJAC(J,J) .EQ. 0.0) GO TO 120
            SUM = 0.0
            DO 100 I = J, M
               SUM = SUM + FJAC(I,J)*WA4(I)
  100          CONTINUE
            TEMP = -SUM/FJAC(J,J)
            DO 110 I = J, M
               WA4(I) = WA4(I) + FJAC(I,J)*TEMP
  110          CONTINUE
  120       CONTINUE
            FJAC(J,J) = WA1(J)
            QTF(J) = WA4(J)
  130       CONTINUE
C
C        COMPUTE THE NORM OF THE SCALED GRADIENT.
C
         GNORM = 0.0
         IF (FNORM .EQ. 0.0) GO TO 170
         DO 160 J = 1, N
            L = IPVT(J)
            IF (WA2(L) .EQ. 0.0) GO TO 150
            SUM = 0.0
            DO 140 I = 1, J
               SUM = SUM + FJAC(I,J)*(QTF(I)/FNORM)
  140          CONTINUE
            GNORM = AMAX1(GNORM,ABS(SUM/WA2(L)))
  150       CONTINUE
  160       CONTINUE
  170    CONTINUE
C
C        TEST FOR CONVERGENCE OF THE GRADIENT NORM.
C
         IF (GNORM .LE. GTOL) INFO = 4
         IF (INFO .NE. 0) GO TO 300
C
C        RESCALE IF NECESSARY.
C
         IF (MODE .EQ. 2) GO TO 190
         DO 180 J = 1, N
            DIAG(J) = AMAX1(DIAG(J),WA2(J))
  180       CONTINUE
  190    CONTINUE
C
C        BEGINNING OF THE INNER LOOP.
C
  200    CONTINUE
C
C           DETERMINE THE LEVENBERG-MARQUARDT PARAMETER.
C
            CALL LMPAR(N,FJAC,LDFJAC,IPVT,DIAG,QTF,DELTA,PAR,WA1,WA2,
     *                 WA3,WA4)
C
C           STORE THE DIRECTION P AND X + P. CALCULATE THE NORM OF P.
C
            DO 210 J = 1, N
               WA1(J) = -WA1(J)
               WA2(J) = X(J) + WA1(J)
               WA3(J) = DIAG(J)*WA1(J)
  210          CONTINUE
            PNORM = ENORM(N,WA3)
C
C           ON THE FIRST ITERATION, ADJUST THE INITIAL STEP BOUND.
C
            IF (ITER .EQ. 1) DELTA = AMIN1(DELTA,PNORM)
C
C           EVALUATE THE FUNCTION AT X + P AND CALCULATE ITS NORM.
C
            IFLAG = 1
            CALL FCN(M,N,WA2,WA4,IFLAG)
            NFEV = NFEV + 1
            IF (IFLAG .LT. 0) GO TO 300
            FNORM1 = ENORM(M,WA4)
C
C           COMPUTE THE SCALED ACTUAL REDUCTION.
C
            ACTRED = -1.0
            IF (P1*FNORM1 .LT. FNORM) ACTRED = 1.0 - (FNORM1/FNORM)**2
C
C           COMPUTE THE SCALED PREDICTED REDUCTION AND
C           THE SCALED DIRECTIONAL DERIVATIVE.
C
            DO 230 J = 1, N
               WA3(J) = 0.0
               L = IPVT(J)
               TEMP = WA1(L)
               DO 220 I = 1, J
                  WA3(I) = WA3(I) + FJAC(I,J)*TEMP
  220             CONTINUE
  230          CONTINUE
            TEMP1 = ENORM(N,WA3)/FNORM
            TEMP2 = (SQRT(PAR)*PNORM)/FNORM
            PRERED = TEMP1**2 + TEMP2**2/P5
            DIRDER = -(TEMP1**2 + TEMP2**2)
C
C           COMPUTE THE RATIO OF THE ACTUAL TO THE PREDICTED
C           REDUCTION.
C
            RATIO = 0.0
            IF (PRERED .NE. 0.0) RATIO = ACTRED/PRERED
C
C           UPDATE THE STEP BOUND.
C
            IF (RATIO .GT. P25) GO TO 240
               IF (ACTRED .GE. 0.0) TEMP = P5
               IF (ACTRED .LT. 0.0)
     *            TEMP = P5*DIRDER/(DIRDER + P5*ACTRED)
               IF (P1*FNORM1 .GE. FNORM .OR. TEMP .LT. P1) TEMP = P1
               DELTA = TEMP*AMIN1(DELTA,PNORM/P1)
               PAR = PAR/TEMP
               GO TO 260
  240       CONTINUE
               IF (PAR .NE. 0.0 .AND. RATIO .LT. P75) GO TO 250
               DELTA = PNORM/P5
               PAR = P5*PAR
  250          CONTINUE
  260       CONTINUE
C
C           TEST FOR SUCCESSFUL ITERATION.
C
            IF (RATIO .LT. P0001) GO TO 290
C
C           SUCCESSFUL ITERATION. UPDATE X, FVEC, AND THEIR NORMS.
C
            DO 270 J = 1, N
               X(J) = WA2(J)
               WA2(J) = DIAG(J)*X(J)
  270          CONTINUE
            DO 280 I = 1, M
               FVEC(I) = WA4(I)
  280          CONTINUE
            XNORM = ENORM(N,WA2)
            FNORM = FNORM1
            ITER = ITER + 1
  290       CONTINUE
C
C           TESTS FOR CONVERGENCE.
C
            IF (ABS(ACTRED) .LE. FTOL .AND. PRERED .LE. FTOL
     *          .AND. P5*RATIO .LE. 1.0) INFO = 1
            IF (DELTA .LE. XTOL*XNORM) INFO = 2
            IF (ABS(ACTRED) .LE. FTOL .AND. PRERED .LE. FTOL
     *          .AND. P5*RATIO .LE. 1.0 .AND. INFO .EQ. 2) INFO = 3
            IF (INFO .NE. 0) GO TO 300
C
C           TESTS FOR TERMINATION AND STRINGENT TOLERANCES.
C
            IF (NFEV .GE. MAXFEV) INFO = 5
            IF (ABS(ACTRED) .LE. EPS .AND. PRERED .LE. EPS
     *          .AND. P5*RATIO .LE. 1.0) INFO = 6
            IF (DELTA .LE. EPS*XNORM) INFO = 7
            IF (GNORM .LE. EPS) INFO = 8
            IF (INFO .NE. 0) GO TO 300
C
C           END OF THE INNER LOOP. REPEAT IF ITERATION UNSUCCESSFUL.
C
            IF (RATIO .LT. P0001) GO TO 200
C
C        END OF THE OUTER LOOP.
C
         GO TO 30
  300 CONTINUE
C
C     TERMINATION, EITHER NORMAL OR USER IMPOSED.
C
      IF (IFLAG .LT. 0) INFO = IFLAG
      IFLAG = 0
      IF (NPRINT .GT. 0) CALL FCN(M,N,X,FVEC,IFLAG)
      RETURN
      END
      REAL FUNCTION ENORM(N,X)
      INTEGER N
      REAL X(N)
C     **********
C
C     FUNCTION ENORM
C
C     GIVEN AN N-VECTOR X, THIS FUNCTION CALCULATES THE
C     EUCLIDEAN NORM OF X.
C
C     THE EUCLIDEAN NORM IS COMPUTED BY ACCUMULATING THE SUM OF
C     SQUARES IN THREE DIFFERENT SUMS. THE SUMS OF SQUARES FOR THE
C     SMALL AND LARGE COMPONENTS ARE SCALED SO THAT NO OVERFLOWS
C     OCCUR. NON-DESTRUCTIVE UNDERFLOWS ARE PERMITTED. UNDERFLOWS
C     AND OVERFLOWS DO NOT OCCUR IN THE COMPUTATION OF THE UNSCALED
C     SUM OF SQUARES FOR THE INTERMEDIATE COMPONENTS.
C     THE DEFINITIONS OF SMALL, INTERMEDIATE AND LARGE COMPONENTS
C     DEPEND ON TWO CONSTANTS, RDWARF AND RGIANT. THE MAIN
C     RESTRICTIONS ON THESE CONSTANTS ARE THAT RDWARF**2 NOT
C     UNDERFLOW AND RGIANT**2 NOT OVERFLOW. THE CONSTANTS
C     GIVEN HERE ARE SUITABLE FOR EVERY KNOWN COMPUTER.
C
C     THE FUNCTION STATEMENT IS
C
C       REAL FUNCTION ENORM(N,X)
C
C     WHERE
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE.
C
C       X IS AN INPUT ARRAY OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       FORTRAN-SUPPLIED ... ABS,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I
      REAL AGIANT,FLOATN,RDWARF,RGIANT,S1,S2,S3,XABS,X1MAX,X3MAX
      DATA RDWARF,RGIANT /3.834E-20,1.304E19/
C
      S1 = 0.0
      S2 = 0.0
      S3 = 0.0
      X1MAX = 0.0
      X3MAX = 0.0
      FLOATN = N
      AGIANT = RGIANT/FLOATN
      DO 90 I = 1, N
         XABS = ABS(X(I))
         IF (XABS .GT. RDWARF .AND. XABS .LT. AGIANT) GO TO 70
            IF (XABS .LE. RDWARF) GO TO 30
C
C              SUM FOR LARGE COMPONENTS.
C
               IF (XABS .LE. X1MAX) GO TO 10
                  S1 = 1.0 + S1*(X1MAX/XABS)**2
                  X1MAX = XABS
                  GO TO 20
   10          CONTINUE
                  S1 = S1 + (XABS/X1MAX)**2
   20          CONTINUE
               GO TO 60
   30       CONTINUE
C
C              SUM FOR SMALL COMPONENTS.
C
               IF (XABS .LE. X3MAX) GO TO 40
                  S3 = 1.0 + S3*(X3MAX/XABS)**2
                  X3MAX = XABS
                  GO TO 50
   40          CONTINUE
                  IF (XABS .NE. 0.0) S3 = S3 + (XABS/X3MAX)**2
   50          CONTINUE
   60       CONTINUE
            GO TO 80
   70    CONTINUE
C
C           SUM FOR INTERMEDIATE COMPONENTS.
C
            S2 = S2 + XABS**2
   80    CONTINUE
   90    CONTINUE
C
C     CALCULATION OF NORM.
C
      IF (S1 .EQ. 0.0) GO TO 100
         ENORM = X1MAX*SQRT(S1 + (S2/X1MAX)/X1MAX)
         GO TO 130
  100 CONTINUE
         IF (S2 .EQ. 0.0) GO TO 110
            IF (S2 .GE. X3MAX)
     *         ENORM = SQRT(S2*(1.0 + (X3MAX/S2)*(X3MAX*S3)))
            IF (S2 .LT. X3MAX)
     *         ENORM = SQRT(X3MAX*((S2/X3MAX) + (X3MAX*S3)))
            GO TO 120
  110    CONTINUE
            ENORM = X3MAX*SQRT(S3)
  120    CONTINUE
  130 CONTINUE
      RETURN
      END
      SUBROUTINE DOGLEG(N,R,LR,DIAG,QTB,DELTA,X,WA1,WA2)
      INTEGER N,LR
      REAL DELTA
      REAL R(LR),DIAG(N),QTB(N),X(N),WA1(N),WA2(N)
C     **********
C
C     SUBROUTINE DOGLEG
C
C     GIVEN AN M BY N MATRIX A, AN N BY N NONSINGULAR DIAGONAL
C     MATRIX D, AN M-VECTOR B, AND A POSITIVE NUMBER DELTA, THE
C     PROBLEM IS TO DETERMINE THE CONVEX COMBINATION X OF THE
C     GAUSS-NEWTON AND SCALED GRADIENT DIRECTIONS THAT MINIMIZES
C     (A*X - B) IN THE LEAST SQUARES SENSE, SUBJECT TO THE
C     RESTRICTION THAT THE EUCLIDEAN NORM OF D*X BE AT MOST DELTA.
C
C     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
C     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
C     QR FACTORIZATION OF A. THAT IS, IF A = Q*R, WHERE Q HAS
C     ORTHOGONAL COLUMNS AND R IS AN UPPER TRIANGULAR MATRIX,
C     THEN DOGLEG EXPECTS THE FULL UPPER TRIANGLE OF R AND
C     THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE DOGLEG(N,R,LR,DIAG,QTB,DELTA,X,WA1,WA2)
C
C     WHERE
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
C
C       R IS AN INPUT ARRAY OF LENGTH LR WHICH MUST CONTAIN THE UPPER
C         TRIANGULAR MATRIX R STORED BY ROWS.
C
C       LR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
C         (N*(N+1))/2.
C
C       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
C         DIAGONAL ELEMENTS OF THE MATRIX D.
C
C       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
C         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
C
C       DELTA IS A POSITIVE INPUT VARIABLE WHICH SPECIFIES AN UPPER
C         BOUND ON THE EUCLIDEAN NORM OF D*X.
C
C       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE DESIRED
C         CONVEX COMBINATION OF THE GAUSS-NEWTON DIRECTION AND THE
C         SCALED GRADIENT DIRECTION.
C
C       WA1 AND WA2 ARE WORK ARRAYS OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       MINPACK-SUPPLIED ... SPMPAR,ENORM
C
C       FORTRAN-SUPPLIED ... ABS,AMAX1,AMIN1,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,JJ,JP1,K,L
      REAL ALPHA,BNORM,EPSMCH,GNORM,QNORM,SGNORM,SUM,TEMP
      REAL SPMPAR,ENORM
C
C     EPSMCH IS THE MACHINE PRECISION.
C
      EPSMCH = SPMPAR(1)
C
C     FIRST, CALCULATE THE GAUSS-NEWTON DIRECTION.
C
      JJ = (N*(N + 1))/2 + 1
      DO 50 K = 1, N
         J = N - K + 1
         JP1 = J + 1
         JJ = JJ - K
         L = JJ + 1
         SUM = 0.0
         IF (N .LT. JP1) GO TO 20
         DO 10 I = JP1, N
            SUM = SUM + R(L)*X(I)
            L = L + 1
   10       CONTINUE
   20    CONTINUE
         TEMP = R(JJ)
         IF (TEMP .NE. 0.0) GO TO 40
         L = J
         DO 30 I = 1, J
            TEMP = AMAX1(TEMP,ABS(R(L)))
            L = L + N - I
   30       CONTINUE
         TEMP = EPSMCH*TEMP
         IF (TEMP .EQ. 0.0) TEMP = EPSMCH
   40    CONTINUE
         X(J) = (QTB(J) - SUM)/TEMP
   50    CONTINUE
C
C     TEST WHETHER THE GAUSS-NEWTON DIRECTION IS ACCEPTABLE.
C
      DO 60 J = 1, N
         WA1(J) = 0.0
         WA2(J) = DIAG(J)*X(J)
   60    CONTINUE
      QNORM = ENORM(N,WA2)
      IF (QNORM .LE. DELTA) GO TO 140
C
C     THE GAUSS-NEWTON DIRECTION IS NOT ACCEPTABLE.
C     NEXT, CALCULATE THE SCALED GRADIENT DIRECTION.
C
      L = 1
      DO 80 J = 1, N
         TEMP = QTB(J)
         DO 70 I = J, N
            WA1(I) = WA1(I) + R(L)*TEMP
            L = L + 1
   70       CONTINUE
         WA1(J) = WA1(J)/DIAG(J)
   80    CONTINUE
C
C     CALCULATE THE NORM OF THE SCALED GRADIENT AND TEST FOR
C     THE SPECIAL CASE IN WHICH THE SCALED GRADIENT IS ZERO.
C
      GNORM = ENORM(N,WA1)
      SGNORM = 0.0
      ALPHA = DELTA/QNORM
      IF (GNORM .EQ. 0.0) GO TO 120
C
C     CALCULATE THE POINT ALONG THE SCALED GRADIENT
C     AT WHICH THE QUADRATIC IS MINIMIZED.
C
      DO 90 J = 1, N
         WA1(J) = (WA1(J)/GNORM)/DIAG(J)
   90    CONTINUE
      L = 1
      DO 110 J = 1, N
         SUM = 0.0
         DO 100 I = J, N
            SUM = SUM + R(L)*WA1(I)
            L = L + 1
  100       CONTINUE
         WA2(J) = SUM
  110    CONTINUE
      TEMP = ENORM(N,WA2)
      SGNORM = (GNORM/TEMP)/TEMP
C
C     TEST WHETHER THE SCALED GRADIENT DIRECTION IS ACCEPTABLE.
C
      ALPHA = 0.0
      IF (SGNORM .GE. DELTA) GO TO 120
C
C     THE SCALED GRADIENT DIRECTION IS NOT ACCEPTABLE.
C     FINALLY, CALCULATE THE POINT ALONG THE DOGLEG
C     AT WHICH THE QUADRATIC IS MINIMIZED.
C
      BNORM = ENORM(N,QTB)
      TEMP = (BNORM/GNORM)*(BNORM/QNORM)*(SGNORM/DELTA)
      TEMP = TEMP - (DELTA/QNORM)*(SGNORM/DELTA)**2
     *       + SQRT((TEMP-(DELTA/QNORM))**2
     *              +(1.0-(DELTA/QNORM)**2)*(1.0-(SGNORM/DELTA)**2))
      ALPHA = ((DELTA/QNORM)*(1.0 - (SGNORM/DELTA)**2))/TEMP
  120 CONTINUE
C
C     FORM APPROPRIATE CONVEX COMBINATION OF THE GAUSS-NEWTON
C     DIRECTION AND THE SCALED GRADIENT DIRECTION.
C
      TEMP = (1.0 - ALPHA)*AMIN1(SGNORM,DELTA)
      DO 130 J = 1, N
         X(J) = TEMP*WA1(J) + ALPHA*X(J)
  130    CONTINUE
  140 CONTINUE
      RETURN
      END
      SUBROUTINE FDJAC1(FCN,N,X,FVEC,FJAC,LDFJAC,IFLAG,ML,MU,EPSFCN,
     *                  WA1,WA2)
      INTEGER N,LDFJAC,IFLAG,ML,MU
      REAL EPSFCN
      REAL X(N),FVEC(N),FJAC(LDFJAC,N),WA1(N),WA2(N)
      EXTERNAL FCN
C     **********
C
C     SUBROUTINE FDJAC1
C
C     THIS SUBROUTINE COMPUTES A FORWARD-DIFFERENCE APPROXIMATION
C     TO THE N BY N JACOBIAN MATRIX ASSOCIATED WITH A SPECIFIED
C     PROBLEM OF N FUNCTIONS IN N VARIABLES. IF THE JACOBIAN HAS
C     A BANDED FORM, THEN FUNCTION EVALUATIONS ARE SAVED BY ONLY
C     APPROXIMATING THE NONZERO TERMS.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE FDJAC1(FCN,N,X,FVEC,FJAC,LDFJAC,IFLAG,ML,MU,EPSFCN,
C                         WA1,WA2)
C
C     WHERE
C
C       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
C         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
C         IN AN EXTERNAL STATEMENT IN THE USER CALLING
C         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
C
C         SUBROUTINE FCN(N,X,FVEC,IFLAG)
C         INTEGER N,IFLAG
C         REAL X(N),FVEC(N)
C         ----------
C         CALCULATE THE FUNCTIONS AT X AND
C         RETURN THIS VECTOR IN FVEC.
C         ----------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF FDJAC1.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS AND VARIABLES.
C
C       X IS AN INPUT ARRAY OF LENGTH N.
C
C       FVEC IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
C         FUNCTIONS EVALUATED AT X.
C
C       FJAC IS AN OUTPUT N BY N ARRAY WHICH CONTAINS THE
C         APPROXIMATION TO THE JACOBIAN MATRIX EVALUATED AT X.
C
C       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
C
C       IFLAG IS AN INTEGER VARIABLE WHICH CAN BE USED TO TERMINATE
C         THE EXECUTION OF FDJAC1. SEE DESCRIPTION OF FCN.
C
C       ML IS A NONNEGATIVE INTEGER INPUT VARIABLE WHICH SPECIFIES
C         THE NUMBER OF SUBDIAGONALS WITHIN THE BAND OF THE
C         JACOBIAN MATRIX. IF THE JACOBIAN IS NOT BANDED, SET
C         ML TO AT LEAST N - 1.
C
C       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
C         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
C         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
C         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
C         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
C         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
C         PRECISION.
C
C       MU IS A NONNEGATIVE INTEGER INPUT VARIABLE WHICH SPECIFIES
C         THE NUMBER OF SUPERDIAGONALS WITHIN THE BAND OF THE
C         JACOBIAN MATRIX. IF THE JACOBIAN IS NOT BANDED, SET
C         MU TO AT LEAST N - 1.
C
C       WA1 AND WA2 ARE WORK ARRAYS OF LENGTH N. IF ML + MU + 1 IS AT
C         LEAST N, THEN THE JACOBIAN IS CONSIDERED DENSE, AND WA2 IS
C         NOT REFERENCED.
C
C     SUBPROGRAMS CALLED
C
C       MINPACK-SUPPLIED ... SPMPAR
C
C       FORTRAN-SUPPLIED ... ABS,AMAX1,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,K,MSUM
      REAL EPS,EPSMCH,H,TEMP,ZERO
      REAL SPMPAR
      DATA ZERO /0.0E0/
C
C     EPSMCH IS THE MACHINE PRECISION.
C
      EPSMCH = SPMPAR(1)
C
      EPS = SQRT(AMAX1(EPSFCN,EPSMCH))
      MSUM = ML + MU + 1
      IF (MSUM .LT. N) GO TO 40
C
C        COMPUTATION OF DENSE APPROXIMATE JACOBIAN.
C
         DO 20 J = 1, N
            TEMP = X(J)
            H = EPS*ABS(TEMP)
            IF (H .EQ. ZERO) H = EPS
            X(J) = TEMP + H
            CALL FCN(N,X,WA1,IFLAG)
            IF (IFLAG .LT. 0) GO TO 30
            X(J) = TEMP
            DO 10 I = 1, N
               FJAC(I,J) = (WA1(I) - FVEC(I))/H
   10          CONTINUE
   20       CONTINUE
   30    CONTINUE
         GO TO 110
   40 CONTINUE
C
C        COMPUTATION OF BANDED APPROXIMATE JACOBIAN.
C
         DO 90 K = 1, MSUM
            DO 60 J = K, N, MSUM
               WA2(J) = X(J)
               H = EPS*ABS(WA2(J))
               IF (H .EQ. ZERO) H = EPS
               X(J) = WA2(J) + H
   60          CONTINUE
            CALL FCN(N,X,WA1,IFLAG)
            IF (IFLAG .LT. 0) GO TO 100
            DO 80 J = K, N, MSUM
               X(J) = WA2(J)
               H = EPS*ABS(WA2(J))
               IF (H .EQ. ZERO) H = EPS
               DO 70 I = 1, N
                  FJAC(I,J) = ZERO
                  IF (I .GE. J - MU .AND. I .LE. J + ML)
     *               FJAC(I,J) = (WA1(I) - FVEC(I))/H
   70             CONTINUE
   80          CONTINUE
   90       CONTINUE
  100    CONTINUE
  110 CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE FDJAC1.
C
      END
      SUBROUTINE FDJAC2(FCN,M,N,X,FVEC,FJAC,LDFJAC,IFLAG,EPSFCN,WA)
      INTEGER M,N,LDFJAC,IFLAG
      REAL EPSFCN
      REAL X(N),FVEC(M),FJAC(LDFJAC,N),WA(M)
      EXTERNAL FCN
C     **********
C
C     SUBROUTINE FDJAC2
C
C     THIS SUBROUTINE COMPUTES A FORWARD-DIFFERENCE APPROXIMATION
C     TO THE M BY N JACOBIAN MATRIX ASSOCIATED WITH A SPECIFIED
C     PROBLEM OF M FUNCTIONS IN N VARIABLES.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE FDJAC2(FCN,M,N,X,FVEC,FJAC,LDFJAC,IFLAG,EPSFCN,WA)
C
C     WHERE
C
C       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
C         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
C         IN AN EXTERNAL STATEMENT IN THE USER CALLING
C         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
C
C         SUBROUTINE FCN(M,N,X,FVEC,IFLAG)
C         INTEGER M,N,IFLAG
C         REAL X(N),FVEC(M)
C         ----------
C         CALCULATE THE FUNCTIONS AT X AND
C         RETURN THIS VECTOR IN FVEC.
C         ----------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF FDJAC2.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF VARIABLES. N MUST NOT EXCEED M.
C
C       X IS AN INPUT ARRAY OF LENGTH N.
C
C       FVEC IS AN INPUT ARRAY OF LENGTH M WHICH MUST CONTAIN THE
C         FUNCTIONS EVALUATED AT X.
C
C       FJAC IS AN OUTPUT M BY N ARRAY WHICH CONTAINS THE
C         APPROXIMATION TO THE JACOBIAN MATRIX EVALUATED AT X.
C
C       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
C
C       IFLAG IS AN INTEGER VARIABLE WHICH CAN BE USED TO TERMINATE
C         THE EXECUTION OF FDJAC2. SEE DESCRIPTION OF FCN.
C
C       EPSFCN IS AN INPUT VARIABLE USED IN DETERMINING A SUITABLE
C         STEP LENGTH FOR THE FORWARD-DIFFERENCE APPROXIMATION. THIS
C         APPROXIMATION ASSUMES THAT THE RELATIVE ERRORS IN THE
C         FUNCTIONS ARE OF THE ORDER OF EPSFCN. IF EPSFCN IS LESS
C         THAN THE MACHINE PRECISION, IT IS ASSUMED THAT THE RELATIVE
C         ERRORS IN THE FUNCTIONS ARE OF THE ORDER OF THE MACHINE
C         PRECISION.
C
C       WA IS A WORK ARRAY OF LENGTH M.
C
C     SUBPROGRAMS CALLED
C
C       USER-SUPPLIED ...... FCN
C
C       MINPACK-SUPPLIED ... SPMPAR
C
C       FORTRAN-SUPPLIED ... ABS,AMAX1,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J
      REAL EPS,EPSMCH,H,TEMP,ZERO
      REAL SPMPAR
      DATA ZERO /0.0E0/
C
C     EPSMCH IS THE MACHINE PRECISION.
C
      EPSMCH = SPMPAR(1)
C
      EPS = SQRT(AMAX1(EPSFCN,EPSMCH))
      DO 20 J = 1, N
         TEMP = X(J)
         H = EPS*ABS(TEMP)
         IF (H .EQ. ZERO) H = EPS
         X(J) = TEMP + H
         CALL FCN(M,N,X,WA,IFLAG)
         IF (IFLAG .LT. 0) GO TO 30
         X(J) = TEMP
         DO 10 I = 1, M
            FJAC(I,J) = (WA(I) - FVEC(I))/H
   10       CONTINUE
   20    CONTINUE
   30 CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE FDJAC2.
C
      END
      SUBROUTINE LMPAR(N,R,LDR,IPVT,DIAG,QTB,DELTA,PAR,X,SDIAG,WA1,
     *                 WA2)
      INTEGER N,LDR
      INTEGER IPVT(N)
      REAL DELTA,PAR
      REAL R(LDR,N),DIAG(N),QTB(N),X(N),SDIAG(N),WA1(N),WA2(N)
C     **********
C
C     SUBROUTINE LMPAR
C
C     GIVEN AN M BY N MATRIX A, AN N BY N NONSINGULAR DIAGONAL
C     MATRIX D, AN M-VECTOR B, AND A POSITIVE NUMBER DELTA,
C     THE PROBLEM IS TO DETERMINE A VALUE FOR THE PARAMETER
C     PAR SUCH THAT IF X SOLVES THE SYSTEM
C
C           A*X = B ,     SQRT(PAR)*D*X = 0 ,
C
C     IN THE LEAST SQUARES SENSE, AND DXNORM IS THE EUCLIDEAN
C     NORM OF D*X, THEN EITHER PAR IS ZERO AND
C
C           (DXNORM-DELTA) .LE. 0.1*DELTA ,
C
C     OR PAR IS POSITIVE AND
C
C           ABS(DXNORM-DELTA) .LE. 0.1*DELTA .
C
C     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
C     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
C     QR FACTORIZATION, WITH COLUMN PIVOTING, OF A. THAT IS, IF
C     A*P = Q*R, WHERE P IS A PERMUTATION MATRIX, Q HAS ORTHOGONAL
C     COLUMNS, AND R IS AN UPPER TRIANGULAR MATRIX WITH DIAGONAL
C     ELEMENTS OF NONINCREASING MAGNITUDE, THEN LMPAR EXPECTS
C     THE FULL UPPER TRIANGLE OF R, THE PERMUTATION MATRIX P,
C     AND THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B. ON OUTPUT
C     LMPAR ALSO PROVIDES AN UPPER TRIANGULAR MATRIX S SUCH THAT
C
C            T   T                   T
C           P *(A *A + PAR*D*D)*P = S *S .
C
C     S IS EMPLOYED WITHIN LMPAR AND MAY BE OF SEPARATE INTEREST.
C
C     ONLY A FEW ITERATIONS ARE GENERALLY NEEDED FOR CONVERGENCE
C     OF THE ALGORITHM. IF, HOWEVER, THE LIMIT OF 10 ITERATIONS
C     IS REACHED, THEN THE OUTPUT PAR WILL CONTAIN THE BEST
C     VALUE OBTAINED SO FAR.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE LMPAR(N,R,LDR,IPVT,DIAG,QTB,DELTA,PAR,X,SDIAG,
C                        WA1,WA2)
C
C     WHERE
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
C
C       R IS AN N BY N ARRAY. ON INPUT THE FULL UPPER TRIANGLE
C         MUST CONTAIN THE FULL UPPER TRIANGLE OF THE MATRIX R.
C         ON OUTPUT THE FULL UPPER TRIANGLE IS UNALTERED, AND THE
C         STRICT LOWER TRIANGLE CONTAINS THE STRICT UPPER TRIANGLE
C         (TRANSPOSED) OF THE UPPER TRIANGULAR MATRIX S.
C
C       LDR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY R.
C
C       IPVT IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH DEFINES THE
C         PERMUTATION MATRIX P SUCH THAT A*P = Q*R. COLUMN J OF P
C         IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C
C       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
C         DIAGONAL ELEMENTS OF THE MATRIX D.
C
C       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
C         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
C
C       DELTA IS A POSITIVE INPUT VARIABLE WHICH SPECIFIES AN UPPER
C         BOUND ON THE EUCLIDEAN NORM OF D*X.
C
C       PAR IS A NONNEGATIVE VARIABLE. ON INPUT PAR CONTAINS AN
C         INITIAL ESTIMATE OF THE LEVENBERG-MARQUARDT PARAMETER.
C         ON OUTPUT PAR CONTAINS THE FINAL ESTIMATE.
C
C       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE LEAST
C         SQUARES SOLUTION OF THE SYSTEM A*X = B, SQRT(PAR)*D*X = 0,
C         FOR THE OUTPUT PAR.
C
C       SDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         DIAGONAL ELEMENTS OF THE UPPER TRIANGULAR MATRIX S.
C
C       WA1 AND WA2 ARE WORK ARRAYS OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       MINPACK-SUPPLIED ... SPMPAR,ENORM,QRSOLV
C
C       FORTRAN-SUPPLIED ... ABS,AMAX1,AMIN1,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,ITER,J,JM1,JP1,K,L,NSING
      REAL DXNORM,DWARF,FP,GNORM,PARC,PARL,PARU,P1,P001,SUM,TEMP,ZERO
      REAL SPMPAR,ENORM
      DATA P1,P001,ZERO /1.0E-1,1.0E-3,0.0E0/
C
C     DWARF IS THE SMALLEST POSITIVE MAGNITUDE.
C
      DWARF = SPMPAR(2)
C
C     COMPUTE AND STORE IN X THE GAUSS-NEWTON DIRECTION. IF THE
C     JACOBIAN IS RANK-DEFICIENT, OBTAIN A LEAST SQUARES SOLUTION.
C
      NSING = N
      DO 10 J = 1, N
         WA1(J) = QTB(J)
         IF (R(J,J) .EQ. ZERO .AND. NSING .EQ. N) NSING = J - 1
         IF (NSING .LT. N) WA1(J) = ZERO
   10    CONTINUE
      IF (NSING .LT. 1) GO TO 50
      DO 40 K = 1, NSING
         J = NSING - K + 1
         WA1(J) = WA1(J)/R(J,J)
         TEMP = WA1(J)
         JM1 = J - 1
         IF (JM1 .LT. 1) GO TO 30
         DO 20 I = 1, JM1
            WA1(I) = WA1(I) - R(I,J)*TEMP
   20       CONTINUE
   30    CONTINUE
   40    CONTINUE
   50 CONTINUE
      DO 60 J = 1, N
         L = IPVT(J)
         X(L) = WA1(J)
   60    CONTINUE
C
C     INITIALIZE THE ITERATION COUNTER.
C     EVALUATE THE FUNCTION AT THE ORIGIN, AND TEST
C     FOR ACCEPTANCE OF THE GAUSS-NEWTON DIRECTION.
C
      ITER = 0
      DO 70 J = 1, N
         WA2(J) = DIAG(J)*X(J)
   70    CONTINUE
      DXNORM = ENORM(N,WA2)
      FP = DXNORM - DELTA
      IF (FP .LE. P1*DELTA) GO TO 220
C
C     IF THE JACOBIAN IS NOT RANK DEFICIENT, THE NEWTON
C     STEP PROVIDES A LOWER BOUND, PARL, FOR THE ZERO OF
C     THE FUNCTION. OTHERWISE SET THIS BOUND TO ZERO.
C
      PARL = ZERO
      IF (NSING .LT. N) GO TO 120
      DO 80 J = 1, N
         L = IPVT(J)
         WA1(J) = DIAG(L)*(WA2(L)/DXNORM)
   80    CONTINUE
      DO 110 J = 1, N
         SUM = ZERO
         JM1 = J - 1
         IF (JM1 .LT. 1) GO TO 100
         DO 90 I = 1, JM1
            SUM = SUM + R(I,J)*WA1(I)
   90       CONTINUE
  100    CONTINUE
         WA1(J) = (WA1(J) - SUM)/R(J,J)
  110    CONTINUE
      TEMP = ENORM(N,WA1)
      PARL = ((FP/DELTA)/TEMP)/TEMP
  120 CONTINUE
C
C     CALCULATE AN UPPER BOUND, PARU, FOR THE ZERO OF THE FUNCTION.
C
      DO 140 J = 1, N
         SUM = ZERO
         DO 130 I = 1, J
            SUM = SUM + R(I,J)*QTB(I)
  130       CONTINUE
         L = IPVT(J)
         WA1(J) = SUM/DIAG(L)
  140    CONTINUE
      GNORM = ENORM(N,WA1)
      PARU = GNORM/DELTA
      IF (PARU .EQ. ZERO) PARU = DWARF/AMIN1(DELTA,P1)
C
C     IF THE INPUT PAR LIES OUTSIDE OF THE INTERVAL (PARL,PARU),
C     SET PAR TO THE CLOSER ENDPOINT.
C
      PAR = AMAX1(PAR,PARL)
      PAR = AMIN1(PAR,PARU)
      IF (PAR .EQ. ZERO) PAR = GNORM/DXNORM
C
C     BEGINNING OF AN ITERATION.
C
  150 CONTINUE
         ITER = ITER + 1
C
C        EVALUATE THE FUNCTION AT THE CURRENT VALUE OF PAR.
C
         IF (PAR .EQ. ZERO) PAR = AMAX1(DWARF,P001*PARU)
         TEMP = SQRT(PAR)
         DO 160 J = 1, N
            WA1(J) = TEMP*DIAG(J)
  160       CONTINUE
         CALL QRSOLV(N,R,LDR,IPVT,WA1,QTB,X,SDIAG,WA2)
         DO 170 J = 1, N
            WA2(J) = DIAG(J)*X(J)
  170       CONTINUE
         DXNORM = ENORM(N,WA2)
         TEMP = FP
         FP = DXNORM - DELTA
C
C        IF THE FUNCTION IS SMALL ENOUGH, ACCEPT THE CURRENT VALUE
C        OF PAR. ALSO TEST FOR THE EXCEPTIONAL CASES WHERE PARL
C        IS ZERO OR THE NUMBER OF ITERATIONS HAS REACHED 10.
C
         IF (ABS(FP) .LE. P1*DELTA
     *       .OR. PARL .EQ. ZERO .AND. FP .LE. TEMP
     *            .AND. TEMP .LT. ZERO .OR. ITER .EQ. 10) GO TO 220
C
C        COMPUTE THE NEWTON CORRECTION.
C
         DO 180 J = 1, N
            L = IPVT(J)
            WA1(J) = DIAG(L)*(WA2(L)/DXNORM)
  180       CONTINUE
         DO 210 J = 1, N
            WA1(J) = WA1(J)/SDIAG(J)
            TEMP = WA1(J)
            JP1 = J + 1
            IF (N .LT. JP1) GO TO 200
            DO 190 I = JP1, N
               WA1(I) = WA1(I) - R(I,J)*TEMP
  190          CONTINUE
  200       CONTINUE
  210       CONTINUE
         TEMP = ENORM(N,WA1)
         PARC = ((FP/DELTA)/TEMP)/TEMP
C
C        DEPENDING ON THE SIGN OF THE FUNCTION, UPDATE PARL OR PARU.
C
         IF (FP .GT. ZERO) PARL = AMAX1(PARL,PAR)
         IF (FP .LT. ZERO) PARU = AMIN1(PARU,PAR)
C
C        COMPUTE AN IMPROVED ESTIMATE FOR PAR.
C
         PAR = AMAX1(PARL,PAR+PARC)
C
C        END OF AN ITERATION.
C
         GO TO 150
  220 CONTINUE
C
C     TERMINATION.
C
      IF (ITER .EQ. 0) PAR = ZERO
      RETURN
C
C     LAST CARD OF SUBROUTINE LMPAR.
C
      END
      SUBROUTINE QFORM(M,N,Q,LDQ,WA)
      INTEGER M,N,LDQ
      REAL Q(LDQ,M),WA(M)
C     **********
C
C     SUBROUTINE QFORM
C
C     THIS SUBROUTINE PROCEEDS FROM THE COMPUTED QR FACTORIZATION OF
C     AN M BY N MATRIX A TO ACCUMULATE THE M BY M ORTHOGONAL MATRIX
C     Q FROM ITS FACTORED FORM.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE QFORM(M,N,Q,LDQ,WA)
C
C     WHERE
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF ROWS OF A AND THE ORDER OF Q.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF COLUMNS OF A.
C
C       Q IS AN M BY M ARRAY. ON INPUT THE FULL LOWER TRAPEZOID IN
C         THE FIRST MIN(M,N) COLUMNS OF Q CONTAINS THE FACTORED FORM.
C         ON OUTPUT Q HAS BEEN ACCUMULATED INTO A SQUARE MATRIX.
C
C       LDQ IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY Q.
C
C       WA IS A WORK ARRAY OF LENGTH M.
C
C     SUBPROGRAMS CALLED
C
C       FORTRAN-SUPPLIED ... MIN0
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,JM1,K,L,MINMN,NP1
      REAL ONE,SUM,TEMP,ZERO
      DATA ONE,ZERO /1.0E0,0.0E0/
C
C     ZERO OUT UPPER TRIANGLE OF Q IN THE FIRST MIN(M,N) COLUMNS.
C
      MINMN = MIN0(M,N)
      IF (MINMN .LT. 2) GO TO 30
      DO 20 J = 2, MINMN
         JM1 = J - 1
         DO 10 I = 1, JM1
            Q(I,J) = ZERO
   10       CONTINUE
   20    CONTINUE
   30 CONTINUE
C
C     INITIALIZE REMAINING COLUMNS TO THOSE OF THE IDENTITY MATRIX.
C
      NP1 = N + 1
      IF (M .LT. NP1) GO TO 60
      DO 50 J = NP1, M
         DO 40 I = 1, M
            Q(I,J) = ZERO
   40       CONTINUE
         Q(J,J) = ONE
   50    CONTINUE
   60 CONTINUE
C
C     ACCUMULATE Q FROM ITS FACTORED FORM.
C
      DO 120 L = 1, MINMN
         K = MINMN - L + 1
         DO 70 I = K, M
            WA(I) = Q(I,K)
            Q(I,K) = ZERO
   70       CONTINUE
         Q(K,K) = ONE
         IF (WA(K) .EQ. ZERO) GO TO 110
         DO 100 J = K, M
            SUM = ZERO
            DO 80 I = K, M
               SUM = SUM + Q(I,J)*WA(I)
   80          CONTINUE
            TEMP = SUM/WA(K)
            DO 90 I = K, M
               Q(I,J) = Q(I,J) - TEMP*WA(I)
   90          CONTINUE
  100       CONTINUE
  110    CONTINUE
  120    CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE QFORM.
C
      END
      SUBROUTINE QRFAC(M,N,A,LDA,PIVOT,IPVT,LIPVT,RDIAG,ACNORM,WA)
      INTEGER M,N,LDA,LIPVT
      INTEGER IPVT(LIPVT)
      LOGICAL PIVOT
      REAL A(LDA,N),RDIAG(N),ACNORM(N),WA(N)
C     **********
C
C     SUBROUTINE QRFAC
C
C     THIS SUBROUTINE USES HOUSEHOLDER TRANSFORMATIONS WITH COLUMN
C     PIVOTING (OPTIONAL) TO COMPUTE A QR FACTORIZATION OF THE
C     M BY N MATRIX A. THAT IS, QRFAC DETERMINES AN ORTHOGONAL
C     MATRIX Q, A PERMUTATION MATRIX P, AND AN UPPER TRAPEZOIDAL
C     MATRIX R WITH DIAGONAL ELEMENTS OF NONINCREASING MAGNITUDE,
C     SUCH THAT A*P = Q*R. THE HOUSEHOLDER TRANSFORMATION FOR
C     COLUMN K, K = 1,2,...,MIN(M,N), IS OF THE FORM
C
C                           T
C           I - (1/U(K))*U*U
C
C     WHERE U HAS ZEROS IN THE FIRST K-1 POSITIONS. THE FORM OF
C     THIS TRANSFORMATION AND THE METHOD OF PIVOTING FIRST
C     APPEARED IN THE CORRESPONDING LINPACK SUBROUTINE.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE QRFAC(M,N,A,LDA,PIVOT,IPVT,LIPVT,RDIAG,ACNORM,WA)
C
C     WHERE
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF ROWS OF A.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF COLUMNS OF A.
C
C       A IS AN M BY N ARRAY. ON INPUT A CONTAINS THE MATRIX FOR
C         WHICH THE QR FACTORIZATION IS TO BE COMPUTED. ON OUTPUT
C         THE STRICT UPPER TRAPEZOIDAL PART OF A CONTAINS THE STRICT
C         UPPER TRAPEZOIDAL PART OF R, AND THE LOWER TRAPEZOIDAL
C         PART OF A CONTAINS A FACTORED FORM OF Q (THE NON-TRIVIAL
C         ELEMENTS OF THE U VECTORS DESCRIBED ABOVE).
C
C       LDA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY A.
C
C       PIVOT IS A LOGICAL INPUT VARIABLE. IF PIVOT IS SET TRUE,
C         THEN COLUMN PIVOTING IS ENFORCED. IF PIVOT IS SET FALSE,
C         THEN NO COLUMN PIVOTING IS DONE.
C
C       IPVT IS AN INTEGER OUTPUT ARRAY OF LENGTH LIPVT. IPVT
C         DEFINES THE PERMUTATION MATRIX P SUCH THAT A*P = Q*R.
C         COLUMN J OF P IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C         IF PIVOT IS FALSE, IPVT IS NOT REFERENCED.
C
C       LIPVT IS A POSITIVE INTEGER INPUT VARIABLE. IF PIVOT IS FALSE,
C         THEN LIPVT MAY BE AS SMALL AS 1. IF PIVOT IS TRUE, THEN
C         LIPVT MUST BE AT LEAST N.
C
C       RDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         DIAGONAL ELEMENTS OF R.
C
C       ACNORM IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         NORMS OF THE CORRESPONDING COLUMNS OF THE INPUT MATRIX A.
C         IF THIS INFORMATION IS NOT NEEDED, THEN ACNORM CAN COINCIDE
C         WITH RDIAG.
C
C       WA IS A WORK ARRAY OF LENGTH N. IF PIVOT IS FALSE, THEN WA
C         CAN COINCIDE WITH RDIAG.
C
C     SUBPROGRAMS CALLED
C
C       MINPACK-SUPPLIED ... SPMPAR,ENORM
C
C       FORTRAN-SUPPLIED ... AMAX1,SQRT,MIN0
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,JP1,K,KMAX,MINMN
      REAL AJNORM,EPSMCH,ONE,P05,SUM,TEMP,ZERO
      REAL SPMPAR,ENORM
      DATA ONE,P05,ZERO /1.0E0,5.0E-2,0.0E0/
C
C     EPSMCH IS THE MACHINE PRECISION.
C
      EPSMCH = SPMPAR(1)
C
C     COMPUTE THE INITIAL COLUMN NORMS AND INITIALIZE SEVERAL ARRAYS.
C
      DO 10 J = 1, N
         ACNORM(J) = ENORM(M,A(1,J))
         RDIAG(J) = ACNORM(J)
         WA(J) = RDIAG(J)
         IF (PIVOT) IPVT(J) = J
   10    CONTINUE
C
C     REDUCE A TO R WITH HOUSEHOLDER TRANSFORMATIONS.
C
      MINMN = MIN0(M,N)
      DO 110 J = 1, MINMN
         IF (.NOT.PIVOT) GO TO 40
C
C        BRING THE COLUMN OF LARGEST NORM INTO THE PIVOT POSITION.
C
         KMAX = J
         DO 20 K = J, N
            IF (RDIAG(K) .GT. RDIAG(KMAX)) KMAX = K
   20       CONTINUE
         IF (KMAX .EQ. J) GO TO 40
         DO 30 I = 1, M
            TEMP = A(I,J)
            A(I,J) = A(I,KMAX)
            A(I,KMAX) = TEMP
   30       CONTINUE
         RDIAG(KMAX) = RDIAG(J)
         WA(KMAX) = WA(J)
         K = IPVT(J)
         IPVT(J) = IPVT(KMAX)
         IPVT(KMAX) = K
   40    CONTINUE
C
C        COMPUTE THE HOUSEHOLDER TRANSFORMATION TO REDUCE THE
C        J-TH COLUMN OF A TO A MULTIPLE OF THE J-TH UNIT VECTOR.
C
         AJNORM = ENORM(M-J+1,A(J,J))
         IF (AJNORM .EQ. ZERO) GO TO 100
         IF (A(J,J) .LT. ZERO) AJNORM = -AJNORM
         DO 50 I = J, M
            A(I,J) = A(I,J)/AJNORM
   50       CONTINUE
         A(J,J) = A(J,J) + ONE
C
C        APPLY THE TRANSFORMATION TO THE REMAINING COLUMNS
C        AND UPDATE THE NORMS.
C
         JP1 = J + 1
         IF (N .LT. JP1) GO TO 100
         DO 90 K = JP1, N
            SUM = ZERO
            DO 60 I = J, M
               SUM = SUM + A(I,J)*A(I,K)
   60          CONTINUE
            TEMP = SUM/A(J,J)
            DO 70 I = J, M
               A(I,K) = A(I,K) - TEMP*A(I,J)
   70          CONTINUE
            IF (.NOT.PIVOT .OR. RDIAG(K) .EQ. ZERO) GO TO 80
            TEMP = A(J,K)/RDIAG(K)
            RDIAG(K) = RDIAG(K)*SQRT(AMAX1(ZERO,ONE-TEMP**2))
            IF (P05*(RDIAG(K)/WA(K))**2 .GT. EPSMCH) GO TO 80
            RDIAG(K) = ENORM(M-J,A(JP1,K))
            WA(K) = RDIAG(K)
   80       CONTINUE
   90       CONTINUE
  100    CONTINUE
         RDIAG(J) = -AJNORM
  110    CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE QRFAC.
C
      END
      SUBROUTINE QRSOLV(N,R,LDR,IPVT,DIAG,QTB,X,SDIAG,WA)
      INTEGER N,LDR
      INTEGER IPVT(N)
      REAL R(LDR,N),DIAG(N),QTB(N),X(N),SDIAG(N),WA(N)
C     **********
C
C     SUBROUTINE QRSOLV
C
C     GIVEN AN M BY N MATRIX A, AN N BY N DIAGONAL MATRIX D,
C     AND AN M-VECTOR B, THE PROBLEM IS TO DETERMINE AN X WHICH
C     SOLVES THE SYSTEM
C
C           A*X = B ,     D*X = 0 ,
C
C     IN THE LEAST SQUARES SENSE.
C
C     THIS SUBROUTINE COMPLETES THE SOLUTION OF THE PROBLEM
C     IF IT IS PROVIDED WITH THE NECESSARY INFORMATION FROM THE
C     QR FACTORIZATION, WITH COLUMN PIVOTING, OF A. THAT IS, IF
C     A*P = Q*R, WHERE P IS A PERMUTATION MATRIX, Q HAS ORTHOGONAL
C     COLUMNS, AND R IS AN UPPER TRIANGULAR MATRIX WITH DIAGONAL
C     ELEMENTS OF NONINCREASING MAGNITUDE, THEN QRSOLV EXPECTS
C     THE FULL UPPER TRIANGLE OF R, THE PERMUTATION MATRIX P,
C     AND THE FIRST N COMPONENTS OF (Q TRANSPOSE)*B. THE SYSTEM
C     A*X = B, D*X = 0, IS THEN EQUIVALENT TO
C
C                  T       T
C           R*Z = Q *B ,  P *D*P*Z = 0 ,
C
C     WHERE X = P*Z. IF THIS SYSTEM DOES NOT HAVE FULL RANK,
C     THEN A LEAST SQUARES SOLUTION IS OBTAINED. ON OUTPUT QRSOLV
C     ALSO PROVIDES AN UPPER TRIANGULAR MATRIX S SUCH THAT
C
C            T   T               T
C           P *(A *A + D*D)*P = S *S .
C
C     S IS COMPUTED WITHIN QRSOLV AND MAY BE OF SEPARATE INTEREST.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE QRSOLV(N,R,LDR,IPVT,DIAG,QTB,X,SDIAG,WA)
C
C     WHERE
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE ORDER OF R.
C
C       R IS AN N BY N ARRAY. ON INPUT THE FULL UPPER TRIANGLE
C         MUST CONTAIN THE FULL UPPER TRIANGLE OF THE MATRIX R.
C         ON OUTPUT THE FULL UPPER TRIANGLE IS UNALTERED, AND THE
C         STRICT LOWER TRIANGLE CONTAINS THE STRICT UPPER TRIANGLE
C         (TRANSPOSED) OF THE UPPER TRIANGULAR MATRIX S.
C
C       LDR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY R.
C
C       IPVT IS AN INTEGER INPUT ARRAY OF LENGTH N WHICH DEFINES THE
C         PERMUTATION MATRIX P SUCH THAT A*P = Q*R. COLUMN J OF P
C         IS COLUMN IPVT(J) OF THE IDENTITY MATRIX.
C
C       DIAG IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE
C         DIAGONAL ELEMENTS OF THE MATRIX D.
C
C       QTB IS AN INPUT ARRAY OF LENGTH N WHICH MUST CONTAIN THE FIRST
C         N ELEMENTS OF THE VECTOR (Q TRANSPOSE)*B.
C
C       X IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE LEAST
C         SQUARES SOLUTION OF THE SYSTEM A*X = B, D*X = 0.
C
C       SDIAG IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS THE
C         DIAGONAL ELEMENTS OF THE UPPER TRIANGULAR MATRIX S.
C
C       WA IS A WORK ARRAY OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       FORTRAN-SUPPLIED ... ABS,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,JP1,K,KP1,L,NSING
      REAL COS,COTAN,P5,P25,QTBPJ,SIN,SUM,TAN,TEMP,ZERO
      DATA P5,P25,ZERO /5.0E-1,2.5E-1,0.0E0/
C
C     COPY R AND (Q TRANSPOSE)*B TO PRESERVE INPUT AND INITIALIZE S.
C     IN PARTICULAR, SAVE THE DIAGONAL ELEMENTS OF R IN X.
C
      DO 20 J = 1, N
         DO 10 I = J, N
            R(I,J) = R(J,I)
   10       CONTINUE
         X(J) = R(J,J)
         WA(J) = QTB(J)
   20    CONTINUE
C
C     ELIMINATE THE DIAGONAL MATRIX D USING A GIVENS ROTATION.
C
      DO 100 J = 1, N
C
C        PREPARE THE ROW OF D TO BE ELIMINATED, LOCATING THE
C        DIAGONAL ELEMENT USING P FROM THE QR FACTORIZATION.
C
         L = IPVT(J)
         IF (DIAG(L) .EQ. ZERO) GO TO 90
         DO 30 K = J, N
            SDIAG(K) = ZERO
   30       CONTINUE
         SDIAG(J) = DIAG(L)
C
C        THE TRANSFORMATIONS TO ELIMINATE THE ROW OF D
C        MODIFY ONLY A SINGLE ELEMENT OF (Q TRANSPOSE)*B
C        BEYOND THE FIRST N, WHICH IS INITIALLY ZERO.
C
         QTBPJ = ZERO
         DO 80 K = J, N
C
C           DETERMINE A GIVENS ROTATION WHICH ELIMINATES THE
C           APPROPRIATE ELEMENT IN THE CURRENT ROW OF D.
C
            IF (SDIAG(K) .EQ. ZERO) GO TO 70
            IF (ABS(R(K,K)) .GE. ABS(SDIAG(K))) GO TO 40
               COTAN = R(K,K)/SDIAG(K)
               SIN = P5/SQRT(P25+P25*COTAN**2)
               COS = SIN*COTAN
               GO TO 50
   40       CONTINUE
               TAN = SDIAG(K)/R(K,K)
               COS = P5/SQRT(P25+P25*TAN**2)
               SIN = COS*TAN
   50       CONTINUE
C
C           COMPUTE THE MODIFIED DIAGONAL ELEMENT OF R AND
C           THE MODIFIED ELEMENT OF ((Q TRANSPOSE)*B,0).
C
            R(K,K) = COS*R(K,K) + SIN*SDIAG(K)
            TEMP = COS*WA(K) + SIN*QTBPJ
            QTBPJ = -SIN*WA(K) + COS*QTBPJ
            WA(K) = TEMP
C
C           ACCUMULATE THE TRANFORMATION IN THE ROW OF S.
C
            KP1 = K + 1
            IF (N .LT. KP1) GO TO 70
            DO 60 I = KP1, N
               TEMP = COS*R(I,K) + SIN*SDIAG(I)
               SDIAG(I) = -SIN*R(I,K) + COS*SDIAG(I)
               R(I,K) = TEMP
   60          CONTINUE
   70       CONTINUE
   80       CONTINUE
   90    CONTINUE
C
C        STORE THE DIAGONAL ELEMENT OF S AND RESTORE
C        THE CORRESPONDING DIAGONAL ELEMENT OF R.
C
         SDIAG(J) = R(J,J)
         R(J,J) = X(J)
  100    CONTINUE
C
C     SOLVE THE TRIANGULAR SYSTEM FOR Z. IF THE SYSTEM IS
C     SINGULAR, THEN OBTAIN A LEAST SQUARES SOLUTION.
C
      NSING = N
      DO 110 J = 1, N
         IF (SDIAG(J) .EQ. ZERO .AND. NSING .EQ. N) NSING = J - 1
         IF (NSING .LT. N) WA(J) = ZERO
  110    CONTINUE
      IF (NSING .LT. 1) GO TO 150
      DO 140 K = 1, NSING
         J = NSING - K + 1
         SUM = ZERO
         JP1 = J + 1
         IF (NSING .LT. JP1) GO TO 130
         DO 120 I = JP1, NSING
            SUM = SUM + R(I,J)*WA(I)
  120       CONTINUE
  130    CONTINUE
         WA(J) = (WA(J) - SUM)/SDIAG(J)
  140    CONTINUE
  150 CONTINUE
C
C     PERMUTE THE COMPONENTS OF Z BACK TO COMPONENTS OF X.
C
      DO 160 J = 1, N
         L = IPVT(J)
         X(L) = WA(J)
  160    CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE QRSOLV.
C
      END
