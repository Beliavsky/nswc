      SUBROUTINE CBI(IND,Z,BI,BIP,IERR)
C------------------------------------------------------------
C     CALCULATES THE AIRY FUNCTION BI AND ITS DERIVATIVE BIP
C     FOR COMPLEX ARGUMENT Z.
C------------------------------------------------------------
      COMPLEX Z,AI,BI,AIP,BIP
      IERR = 0
      A = REAL(Z)
      B = AIMAG(Z)
      R = CPABS(A,B)
      IF(R .GT. 1.0) GO TO 10
C
C     MACLAURIN EXPANSION
C
         CALL AIRM(IND,Z,AI,AIP,BI,BIP)
         RETURN
   10 IF(R .GT. 9.6) GO TO 20
C
C     INTERMEDIATE RANGE CALCULATION
C
         CALL BII(IND,Z,BI,BIP,IERR)
         RETURN
C
C     ASYMPTOTIC EXPANSION
C
   20 CALL BIA(IND,Z,BI,BIP,IERR)
      RETURN
      END
      SUBROUTINE BII(IND, Z, BI, BIP, IERR)
C------------------------------------------------------------
C     CALCULATES THE AIRY FUNCTION BI AND ITS DERIVATIVE BIP
C     FOR COMPLEX ARGUMENT Z IN THE INTERMEDIATE RANGE 1 .LE.
C     CABS(Z) .LE. 10.0.
C------------------------------------------------------------
      COMPLEX Z, BI, BIP, Z1, Z2, ZM, W1, W2, W1M, W2M, E, E1
C
C     C1 = 1/SQRT(3)
C     SQT3 = SQRT(3)
C
      DATA C1/5.77350269189626E-01/
      DATA SQT3/1.73205080756888E+00/
C
      IERR = 0
      X = REAL(Z)
      Y = AIMAG(Z)
      R = CPABS(X, Y)
      Z1 = CSQRT(Z)
      Z2 = Z1*Z/1.5
      E = CEXP(-Z2)
      E1 = 1.0/E
      IF(REAL(Z) .LT. 0.0) GO TO 10
C
C               ----  REAL(Z) .GE. 0  ----
C
      IF (R .LT. 8.9) GO TO 5
      A = 0.156*R - 0.913
      IF (ABS(Y) .LT. A*X .OR. ABS(Y) .GT. 0.58*X) GO TO 40
    5    CALL IA(Z2, W1, W2, W1M, W2M)
         BI = C1*Z1*(W1 + W1M)
         BIP = C1*Z*(W2 + W2M)
         IF (IND .EQ. 0) RETURN
         GO TO 20
C
C               ----  REAL(Z) .LT. 0  ----
C
   10 IF (R .LT. 8.1) GO TO 15
      IF (ABS(Y) .LT. 3.89*ABS(X)) GO TO 40
   15    ZM = -Z
         Z1 = CSQRT(ZM)
         Z2 = Z1*ZM/1.5
         CALL JA(Z2, W1, W2, W1M, W2M)
         BI = C1*Z1*(W1M -W1)
         BIP = C1*ZM*(W2M + W2)
         IF (IND .EQ. 0) RETURN
   20    IF (X .GE. C1*ABS(Y)) GO TO 30
            BI = BI*E1
            BIP = BIP*E1
            RETURN
   30    BI = BI*E
         BIP = BIP*E
         RETURN
   40 CALL BIA(IND, Z, BI, BIP, IERR)
      RETURN
      END
      SUBROUTINE BIA(IND,Z,BI,BIP,IERR)
C---------------------------------------------------------------
C     CALCULATES THE AIRY FUNCTION BI AND ITS DERIVATIVE BIP FOR
C     COMPLEX ARGUMENT Z BY MEANS OF ASYMPTOTIC EXPANSIONS.
C---------------------------------------------------------------
      COMPLEX Z,BI,BIP,Z1,Z2,Z2R,ZZ,W,W2,S1,S2,S3,S4,E,ZETA,SI,CN,
     *        CF1,CF2,EX3C,EX6,EX6C,CLN2,ALPHA,BETA,J,CZ
      DIMENSION C(30), D(30)
C------------------------
      DATA C(1)  /.100000000000000E+01/, C(2)  /.694444444444444E-01/,
     *     C(3)  /.371334876543210E-01/, C(4)  /.379930591278006E-01/,
     *     C(5)  /.576491904126697E-01/, C(6)  /.116099064025515E+00/,
     *     C(7)  /.291591399230751E+00/, C(8)  /.877666969510017E+00/,
     *     C(9)  /.307945303017317E+01/, C(10) /.123415733323452E+02/,
     *     C(11) /.556227853659171E+02/, C(12) /.278465080777603E+03/,
     *     C(13) /.153316943201280E+04/, C(14) /.920720659972641E+04/,
     *     C(15) /.598925135658791E+05/, C(16) /.419524875116551E+06/,
     *     C(17) /.314825741786683E+07/, C(18) /.251989198716024E+08/,
     *     C(19) /.214288036963680E+09/, C(20) /.192937554918249E+10/
      DATA C(21) /.183357669378906E+11/, C(22) /.183418303528833E+12/,
     *     C(23) /.192647115897045E+13/, C(24) /.211969993886476E+14/,
     *     C(25) /.243826826879716E+15/, C(26) /.292659921929793E+16/,
     *     C(27) /.365903070126431E+17/, C(28) /.475768102036307E+18/,
     *     C(29) /.642404935790194E+19/, C(30) /.899520742705838E+20/
C------------------------
      DATA D(1)  / .100000000000000E+01/, D(2)  /-.972222222222222E-01/,
     *     D(3)  /-.438850308641975E-01/, D(4)  /-.424628307898948E-01/,
     *     D(5)  /-.626621634920323E-01/, D(6)  /-.124105896027275E+00/,
     *     D(7)  /-.308253764901079E+00/, D(8)  /-.920479992412945E+00/,
     *     D(9)  /-.321049358464862E+01/, D(10) /-.128072930807356E+02/,
     *     D(11) /-.575083035139143E+02/, D(12) /-.287033237109221E+03/,
     *     D(13) /-.157635730333710E+04/, D(14) /-.944635482309593E+04/,
     *     D(15) /-.613357066638521E+05/, D(16) /-.428952400400069E+06/,
     *     D(17) /-.321453652140086E+07/, D(18) /-.256979083839113E+08/,
     *     D(19) /-.218293420832160E+09/, D(20) /-.196352378899103E+10/
      DATA D(21) /-.186439310881072E+11/, D(22) /-.186352996385294E+12/,
     *     D(23) /-.195588293238984E+13/, D(24) /-.215064446351972E+14/,
     *     D(25) /-.247236992290621E+15/, D(26) /-.296588243029521E+16/,
     *     D(27) /-.370624400063547E+17/, D(28) /-.481678264794522E+18/,
     *     D(29) /-.650098408075106E+19/, D(30) /-.909919826436541E+20/
C-------------------------
C     SQT3 = SQRT(3)
C     EX3C = EXP(-I*PI/3)
C     EX6 = EXP(I*PI/6)
C     EX6C = EXP(-I*PI/6)
C     CLN2 = 0.5*I*LN(2)
C     C1 = PI**(-1/2)
C     C2 = (2*PI)**(-1/2)
C     C3 = 2**(-1/2)
C--------------------------
      DATA SQT3/1.73205080756888/
      DATA EX3C/(5.E-01, -8.66025403784439E-01)/
      DATA EX6/(8.66025403784439E-01, 5.E-01)/
      DATA EX6C/(8.66025403784439E-01, -5.E-01)/
      DATA CLN2/(0.0, 3.46573590279973E-01)/
      DATA C1/5.64189583547756E-01/
      DATA C2/3.98942280401433E-01/
      DATA C3/7.07106781186548E-01/
C--------------------------
C
C     EPS AND XM ARE MACHINE DEPENDENT CONSTANTS. EPS IS THE
C     SMALLEST NUMBER SUCH THAT 1.0 + EPS .GT. 1.0, XPOS IS THE
C     LARGEST POSITIVE NUMBER FOR WHICH EXP(XM) CAN BE COMPUTED,
C     AND XNEG IS THE NEGATIVE NUMBER OF LARGEST MAGNITUDE FOR
C     WHICH EXP(X) DOES NOT UNDERFLOW.
C
                      EPS = SPMPAR(1)
                      XPOS = EXPARG(0)
                      XNEG = EXPARG(1)
C
C------------------------
      IERR = 0
      X = REAL(Z)
      Y = AIMAG(Z)
      IF (X .LT. ABS(Y)*SQT3) GO TO 30
C
C          -----  ABS(ARG(Z)) .LE. PI/6  ----
C
      Z1 = CSQRT(Z)
      Z2 = CSQRT(Z1)
      Z2R = 1.0/Z2
      CALL CREC(X, Y, U, V)
      W = 1.5*CMPLX(U, V)/Z1
      U = ABS(REAL(W))
      V = ABS(AIMAG(W))
      T = AMAX1(U, V)
      IF (IND .NE. 0) GO TO 10
         IF (T .EQ. 0.0) GO TO 90
            U1 = U/T
            V1 = V/T
            R = U*U1 + V*V1
            IF (U1 .GE. R*XPOS .OR. V1 .GE. 0.1*R/EPS) GO TO 90
               ZETA = Z1*Z/1.5
               E = CEXP(ZETA)
C
   10 M = 20
      T = AMAX1(X, ABS(Y))
      IF (T .GT. 30.0) M = 8
      S1 = CMPLX(C(M), 0.0)
      S2 = CMPLX(D(M), 0.0)
      I = M
      DO 20 K = 2,M
         I = I - 1
         S1 = C(I) + W*S1
         S2 = D(I) + W*S2
   20 CONTINUE
C
      BI = C1*Z2R*S1
      BIP = C1*Z2*S2
      IF (IND .NE. 0) RETURN
         BI = E*BI
         BIP = E*BIP
         RETURN
   30 IF (X .LT. 0.0) GO TO 50
C
C          ----  PI/6 .LT. ABS(ARG(Z)) .LE. PI/2  ----
C
      CZ = Z
      IF (Y .LT. 0.0) CZ = CONJG(CZ)
      ZZ = CZ*EX3C
      Z1 = CSQRT(ZZ)
      Z2 = CSQRT(Z1)
      Z2R = 1.0/Z2
      CF1 = C1*Z2R*EX6
      CF2 = C1*Z2*EX6C
      CALL CREC(REAL(ZZ), AIMAG(ZZ), U, V)
      W = 1.5*CMPLX(U, V)/Z1
      U = ABS(REAL(W))
      V = ABS(AIMAG(W))
      T = AMAX1(U, V)
C
      IF (T .EQ. 0.0) GO TO 90
         U1 = U/T
         V1 = V/T
         R = U*U1 + V*V1
         IF (IND .NE. 0) GO TO 40
            IF (V1 .GE. R*XPOS .OR. U1 .GE. 0.1*R/EPS) GO TO 90
               ZETA = Z1*ZZ/1.5
               CN = CCOS(ZETA - CLN2)
               SI = CSIN(ZETA - CLN2)
               GO TO 70
C
C        E = EXP(-2*I*(ZETA - CLN2)) IF ABS(ARG(ZZ)) .LE. PI/3
C        E = EXP( 2*I*(ZETA - CLN2)) IF ABS(ARG(ZZ)) .GT. PI/3
C
   40    E = (0.0, 0.0)
         J = (0.0, -1.0)
         S = 1.0
         CE = 1.0
         CF = 0.5
         IF (AIMAG(ZZ) .LE. 0.0) GO TO 44
            S = -1.0
            CE = 0.5
            CF = 2.0
   44    IF (V1 .GE. 0.5*R*ABS(XNEG)) GO TO 45
         IF (U1 .GE. 0.05*R/EPS) GO TO 90
         ZETA = Z1*ZZ/1.5
         E = CF*CEXP(2.0*S*J*ZETA)
   45    CN = CE*C3*(1 + E)
         SI = CE*S*C3*(1 - E)*J
         GO TO 70
C
C                  ----  REAL(Z) .LT. 0  ----
C
   50 ZZ = -Z
      IF (Y .LT. 0.0) ZZ = CONJG(ZZ)
      Z1 = CSQRT(ZZ)
      Z2 = CSQRT(Z1)
      Z2R = 1.0/Z2
      CF1 = C2*Z2R
      CF2 = C2*Z2
      CALL CREC(REAL(ZZ), AIMAG(ZZ), U, V)
      W = 1.5*CMPLX(U, V)/Z1
      U = ABS(REAL(W))
      V = ABS(AIMAG(W))
      T = AMAX1(U, V)
C
      IF (T .EQ. 0.0) GO TO 90
         U1 = U/T
         V1 = V/T
         R = U*U1 + V*V1
         IF (IND .NE. 0) GO TO 60
            IF (V1 .GE. R*XPOS .OR. U1 .GE. 0.1*R/EPS) GO TO 90
               ZETA = Z1*ZZ/1.5
               CN = CCOS(ZETA)
               SI = CSIN(ZETA)
               GO TO 70
   60    E = (0.0, 0.0)
         J = (0.0, -1.0)
         IF (V1 .GE. 0.5*R*ABS(XNEG)) GO TO 65
         IF (U1 .GE. 0.05*R/EPS) GO TO 90
         ZETA = Z1*ZZ/1.5
         E = CEXP(2.0*J*ZETA)
   65    CN = 0.5*(1.0 + E)
         SI = 0.5*(1.0 - E)*J
C
   70 W2 = W*W
      M = 15
      T = AMAX1(ABS(X), ABS(Y))
      IF (T .GT. 30.0) M = 5
         M2 = M + M
         I = M2 - 1
         S1 = CMPLX(C(I), 0.0)
         S2 = CMPLX(C(M2), 0.0)
         S3 = CMPLX(D(I), 0.0)
         S4 = CMPLX(D(M2), 0.0)
         DO 80 K = 2,M
            I = I - 1
            S2 = C(I) - S2*W2
            S4 = D(I) - S4*W2
            I = I - 1
            S1 = C(I) - S1*W2
            S3 = D(I) - S3*W2
   80    CONTINUE
         S2 = W*S2
         S4 = W*S4
         IF (X .GE. 0.0) GO TO 81
            ALPHA = S1 + S2
            BETA = S2 - S1
            GO TO 82
   81    ALPHA = S1 - S2
         BETA = S1 + S2
   82    BI = CF1*(ALPHA*CN + BETA*SI)
         IF (X .GE. 0.0) GO TO 83
            ALPHA = S3 - S4
            BETA = S3 + S4
            GO TO 84
   83    ALPHA = S3 + S4
         BETA = S4 - S3
   84    BIP = CF2*(ALPHA*CN + BETA*SI)
         IF (Y .GE. 0.0) RETURN
         BI = CONJG(BI)
         BIP = CONJG(BIP)
         RETURN
C
C            RETURN WITH ZERO VALUES IF SCALING IS NEEDED.
C
   90 BI = (0.0, 0.0)
      BIP = (0.0, 0.0)
      IERR = 1
      RETURN
      END
      SUBROUTINE IA(Z, I1, I2, I1M, I2M)
C-------------------------------------------------------------
C     CALCULATES THE MODIFIED BESSEL FUNCTION OF THE FIRST
C     KIND FOR ORDERS 1/3, 2/3, -1/3, AND -2/3 AND FOR COMPLEX
C     ARGUMENT Z, WHERE -PI .LT. ARG(Z) .LE. PI.  I1 AND I2
C     ARE REPLACED BY THE FUNCTIONS OF ORDERS 1/3 AND 2/3,
C     RESPECTIVELY, AND I1M AND I2M BY THE FUNCTIONS OF ORDERS
C     -1/3 AND -2/3, RESPECTIVELY.
C-------------------------------------------------------------
      COMPLEX Z,I1,I2,I1M,I2M,CZ,EX13,EX13C,EX23,EX23C
C
C     EX13 = EXP(I*PI/3)
C     EX13C = EXP(-I*PI/3)
C     EX23 = EXP(2*I*PI/3)
C     EX23C = EXP(-2*I*PI/3)
C
      DATA EX13/(5.0E-01, 8.66025403784439E-01)/
      DATA EX13C/(5.0E-01, -8.66025403784439E-01)/
      DATA EX23/(-5.0E-01, 8.66025403784439E-01)/
      DATA EX23C/(-5.0E-01, -8.66025403784439E-01)/
      IF(REAL(Z) .GE. 0.0) GO TO 20
         CZ = -Z
C
C     CALCULATION OF I1, I2, I1M, AND I2M WHEN REAL(CZ) .GT. 0.
C
         CALL IMC(CZ, I1, I2, I1M, I2M)
C
C     FINAL ASSEMBLY
C
         IF(AIMAG(Z) .LT. 0.0) GO TO 10
            I1 = EX13*I1
            I2 = EX23*I2
            I1M = EX13C*I1M
            I2M = EX23C*I2M
            RETURN
   10    I1 = EX13C*I1
         I2 = EX23C*I2
         I1M = EX13*I1M
         I2M = EX23*I2M
         RETURN
   20    CALL IMC(Z, I1, I2, I1M, I2M)
         RETURN
         END
      SUBROUTINE IMC(Z, I1, I2, I1M, I2M)
C----------------------------------------------------------------
C     CALCULATES THE MODIFIED BESSEL FUNCTION OF THE FIRST
C     KIND FOR ORDERS 1/3, 2/3, -1/3, AND -2/3 AND FOR COMPLEX
C     ARGUMENT Z. THE MACLAURIN EXPANSION AND BACKWARD RECURRENCE
C     ARE USED. I1 AND I2 ARE REPLACED BY THE FUNCTIONS OF ORDERS
C     1/3 AND 2/3, RESPECTIVELY, AND I1M AND I2M BY THE FUNCTIONS
C     OF ORDERS -1/3 AND -2/3, RESPECTIVELY.  FOR GREATEST
C     ACCURACY, Z SHOULD LIE IN THE REGION REAL(Z) .GE. 0.
C----------------------------------------------------------------
      COMPLEX Z,IA1,IA2,IA3,IB1,IB2,IB3,I1,I2,I1M,I2M,SZ,ZH,E,
     *        CF1,CF2,CF3,CF4
      REAL M
C
C     GM1 = GAMMA(4.0/3.0)
C     GM2 = GAMMA(5.0/3.0)
C
      DATA C1/.333333333333333E+00/
      DATA C2/.666666666666667E+00/
      DATA GM1/.892979511569248E+00/
      DATA GM2/.902745292950932E+00/
      ZH = 0.5*Z
      SZ = ZH*ZH
      A = REAL(ZH)
      B = AIMAG(ZH)
      AN = AINT(A*A + B*B)
      CN1 = C1 + AN
      CN2 = C2 + AN
C
C     CALCULATION OF INITIAL VALUES FOR BACKWARD RECURRENCE BY
C     USE OF THE MACLAURIN EXPANSION.
C
      CALL BIM(Z, CN1, IA1)
      CALL BIM(Z, CN1 + 1.0, IA2)
      CALL BIM(Z, CN2, IB1)
      CALL BIM(Z, CN2 + 1.0, IB2)
C
C     BACKWARD RECURRENCE
C
      N = AN
      M = AN
      N1 = N + 1
      DO 10 I = 1, N1
         IA3 = IA2
         IA2 = IA1
         IB3 = IB2
         IB2 = IB1
         CFA = (M + C1)*(M + C1 + 1.0)
         CFB = (M + C2)*(M + C2 + 1.0)
         M = M - 1.0
         IA1 = IA2 + (SZ/CFA)*IA3
   10    IB1 = IB2 + (SZ/CFB)*IB3
      E = CEXP(C1*CLOG(ZH))
      CF1 = E/GM1
      CF2 = E*E/GM2
      CF3 = C2*CF2/ZH
      CF4 = C1*CF1/ZH
      I1 = CF1*IA2
      I2 = CF2*IB2
      I1M = CF3*IB1
      I2M = CF4*IA1
      RETURN
      END
      SUBROUTINE BIM(Z,CN,W)
C-------------------------------------------------------------
C     CALCULATES THE MODIFIED BESSEL FUNCTION OF THE FIRST KIND
C     FOR REAL ORDER CN .GT. -1 AND COMPLEX ARGUMENT Z BY MEANS
C     OF THE MACLAURIN EXPANSION.  W IS REPLACED BY THE
C     CALCULATED VALUE.
C-------------------------------------------------------------
      REAL M
      COMPLEX Z, W, SZ, T
C------------------
      ANORM(Z) = AMAX1(ABS(REAL(Z)),ABS(AIMAG(Z)))
C-------------------------------------------------------------
C     EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE SMALLEST
C     NUMBER SUCH THAT 1 + EPS .GT. 1.
C
      EPS = SPMPAR(1)
C
C-------------------------------------------------------------
      SZ = 0.25*Z*Z
C
C     INITIALIZATION OF MACLAURIN EXPANSION
C
      M = 1.0
      T = SZ/(CN + 1.0)
      W = T
C
C     SUMMATION OF MACLAURIN EXPANSION
C
   10    M = M + 1.0
         D = M*(CN + M)
         T = T*(SZ/D)
         W = W + T
         IF(ANORM(T) .GT. EPS*ANORM(W)) GO TO 10
C
      W = W + 1.0
      RETURN
      END
      SUBROUTINE JA(Z, I1, I2, I1M, I2M)
C------------------------------------------------------------
C     CALCULATES THE BESSEL FUNCTION OF THE FIRST KIND FOR
C     ORDERS 1/3, 2/3, -1/3, AND -2/3 AND FOR COMPLEX ARGUMENT
C     Z, WHERE -PI .LT. ARG(Z) .LE. PI.  I1 AND I2 ARE REPLACED
C     BY THE FUNCTIONS OF ORDERS 1/3 AND 2/3, RESPECTIVELY, AND
C     I1M AND I2M BY FUNCTIONS OF ORDERS -1/3 AND -2/3,
C     RESPECTIVELY.
C--------------------------------------------------------------
      COMPLEX Z,I1,I2,I1M,I2M,CZ,EX13,EX13C,EX23,EX23C
C
C     EX13 = EXP(I*PI/3)
C     EX13C = EXP(-I*PI/3)
C     EX23 = EXP(2*I*PI/3)
C     EX23C = EXP(-2*I*PI/3)
C
      DATA EX13/(5.0E-01, 8.66025403784439E-01)/
      DATA EX13C/(5.0E-01, -8.66025403784439E-01)/
      DATA EX23/(-5.0E-01, 8.66025403784439E-01)/
      DATA EX23C/(-5.0E-01, -8.66025403784439E-01)/
      IF(REAL(Z) .GE. 0.0) GO TO 20
         CZ = -Z
C
C     CALCULATION OF I1, I2, I1M, AND I2M WHEN REAL(CZ) .GT. 0.0
C
         CALL JMC(CZ, I1, I2, I1M, I2M)
C
C     FINAL ASSEMBLY
C
         IF(AIMAG(Z) .LT. 0.0) GO TO 10
            I1 = EX13*I1
            I2 = EX23*I2
            I1M = EX13C*I1M
            I2M = EX23C*I2M
            RETURN
   10    I1 = EX13C*I1
         I2 = EX23C*I2
         I1M = EX13*I1M
         I2M = EX23*I2M
         RETURN
   20    CALL JMC(Z, I1, I2, I1M, I2M)
         RETURN
         END
      SUBROUTINE JMC(Z, I1, I2, I1M, I2M)
C----------------------------------------------------------------
C     CALCULATES THE BESSEL FUNCTION OF THE FIRST
C     KIND FOR ORDERS 1/3, 2/3, -1/3, AND -2/3 AND FOR COMPLEX
C     ARGUMENT Z. THE MACLAURIN EXPANSION AND BACKWARD RECURRENCE
C     ARE USED. I1 AND I2 ARE REPLACED BY THE FUNCTIONS OF ORDERS
C     1/3 AND 2/3, RESPECTIVELY, AND I1M AND I2M BY THE FUNCTIONS
C     OF ORDERS -1/3 AND -2/3, RESPECTIVELY.  FOR GREATEST
C     ACCURACY, Z SHOULD LIE IN THE REGION REAL(Z) .GE. 0.
C----------------------------------------------------------------
      COMPLEX Z,IA1,IA2,IA3,IB1,IB2,IB3,I1,I2,I1M,I2M,SZ,ZH,E,
     *        CF1,CF2,CF3,CF4
      REAL M
C
C     GM1 = GAMMA(4.0/3.0)
C     GM2 = GAMMA(5.0/3.0)
C
      DATA C1/.333333333333333E+00/
      DATA C2/.666666666666667E+00/
      DATA GM1/.892979511569248E+00/
      DATA GM2/.902745292950932E+00/
      ZH = 0.5*Z
      SZ = ZH*ZH
      A = REAL(ZH)
      B = AIMAG(ZH)
      AN = AINT(A*A + B*B)
      CN1 = C1 + AN
      CN2 = C2 + AN
C
C     CALCULATION OF INITIAL VALUES FOR BACKWARD RECURRENCE BY
C     USE OF THE MACLAURIN EXPANSION.
C
      CALL BJM(Z, CN1, IA1)
      CALL BJM(Z, CN1 + 1.0, IA2)
      CALL BJM(Z, CN2, IB1)
      CALL BJM(Z, CN2 + 1.0, IB2)
C
C     BACKWARD RECURRENCE
C
      N = AN
      N1 = N + 1
      M = AN
      DO 10 I = 1, N1
         IA3 = IA2
         IA2 = IA1
         IB3 = IB2
         IB2 = IB1
         CFA = (M + C1)*(M + C1 + 1.0)
         CFB = (M + C2)*(M + C2 + 1.0)
         M = M - 1.0
         IA1 = IA2 - (SZ/CFA)*IA3
   10    IB1 = IB2 - (SZ/CFB)*IB3
      E = CEXP(C1*CLOG(ZH))
      CF1 = E/GM1
      CF2 = E*E/GM2
      CF3 = C2*CF2/ZH
      CF4 = C1*CF1/ZH
      I1 = CF1*IA2
      I2 = CF2*IB2
      I1M = CF3*IB1
      I2M = CF4*IA1
      RETURN
      END
      SUBROUTINE BJM(Z,CN,W)
C-------------------------------------------------------------
C     CALCULATES THE BESSEL FUNCTION OF THE FIRST KIND
C     FOR REAL ORDER CN .GT. -1 AND COMPLEX ARGUMENT Z BY MEANS
C     OF THE MACLAURIN EXPANSION.  W IS REPLACED BY THE
C     CALCULATED VALUE.
C-------------------------------------------------------------
      REAL M
      COMPLEX Z, W, SZ, T
C------------------
      ANORM(Z) = AMAX1(ABS(REAL(Z)),ABS(AIMAG(Z)))
C-------------------------------------------------------------
C     EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE SMALLEST
C     NUMBER SUCH THAT 1 + EPS .GT. 1.
C
      EPS = SPMPAR(1)
C
C-------------------------------------------------------------
      SZ = -0.25*Z*Z
C
C     INITIALIZATION OF MACLAURIN EXPANSION
C
      M = 1.0
      T = SZ/(CN + 1.0)
      W = T
C
C     SUMMATION OF MACLAURIN EXPANSION
C
   10    M = M + 1.0
         D = M*(CN + M)
         T = T*(SZ/D)
         W = W + T
         IF(ANORM(T) .GT. EPS*ANORM(W)) GO TO 10
C
      W = W + 1.0
      RETURN
      END
      SUBROUTINE KA(IND, Z, K1, K2)
C------------------------------------------------------------
C     CALCULATES THE MODIFIED BESSEL FUNCTION OF THE SECOND
C     KIND FOR ORDERS 1/3 AND 2/3 AND FOR COMPLEX ARGUMENT Z,
C     WHERE -PI .LT. ARG(Z) .LE PI.  K1 IS REPLACED BY THE
C     FUNCTION OF ORDER 1/3, AND K2 BY THE FUNCTION OF ORDER
C     2/3.
C------------------------------------------------------------
      COMPLEX Z,K1,K2,I1,I2,I1M,I2M,CZ,EX13C,EX23C,J,E
C
C     EX13C = EXP(-PI*I/3)
C     EX23C = EXP(-2*PI*I/3)
C
      DATA PI/3.14159265358979E+00/
      DATA EX13C/(5.0E-01, -8.66025403784439E-01)/
      DATA EX23C/(-5.0E-01, -8.66025403784439E-01)/
      DATA J/(0.0, 1.0)/
      A = REAL(Z)
      B = AIMAG(Z)
      IF (ABS(B) .LT. -0.5*A) GO TO 10
C
C            ----  ABS(B) .GE. -0.5*A  ----
C
         CALL KML(IND, Z, K1, K2)
         RETURN
C
C            ----  ABS(B) .LT. -0.5*A  ----
C
   10    CZ = -Z
         IF(AIMAG(Z) .LT. 0.0) CZ = CONJG(CZ)
         IND1 = 0
         CALL KML(IND1, CZ, K1, K2)
         CALL IMC(CZ, I1, I2, I1M, I2M)
         K1 = EX13C*K1 - J*PI*I1
         K2 = EX23C*K2 - J*PI*I2
         IF (IND .EQ. 0) GO TO 20
         E = CEXP(Z)
         K1 = K1*E
         K2 = K2*E
   20    IF(AIMAG(Z) .GE. 0.0) RETURN
            K1 = CONJG(K1)
            K2 = CONJG(K2)
            RETURN
      END
      SUBROUTINE KML(IND, Z, K1, K2)
C------------------------------------------------------------
C     CALCULATES THE MODIFIED BESSEL FUNCTION OF THE SECOND
C     KIND FOR ORDERS 1/3 AND 2/3 AND FOR COMPLEX ARGUMENT Z
C     BY USE OF THE MILLER ALGORITHM.  K1 IS REPLACED BY THE
C     FUNCTION OF ORDER 1/3, AND K2 BY THE FUNCTION OF ORDER
C     2/3.  FOR GREATEST ACCURACY, Z SHOULD LIE IN THE REGION
C     REAL(Z) .GE. 0.
C------------------------------------------------------------
      COMPLEX Z, K1, K2, BI, U1, U2, U3, S, E
C
C     C1 = SQRT(PI/2)
C
      DATA C1/1.25331413731550E+00/
      EPS = SPMPAR(1)
      X1 = REAL(Z)
      X2 = AIMAG(Z)
C
C     CALCULATION OF M FOR USE IN MILLER ALGORITHM.
C
      CALL CAPO(X1, X2, R, TH)
      A = 3.0/(1.0 + R)
      B = 14.7/(28.0 + R)
      C = 2.0/(C1*EPS*(2.0*R)**(0.25))
      M = (0.485/R)*(ALOG(C) + R*COS(A*TH)/(1.0 + 0.008*R))**2/
     1    (2.0*COS(B*TH))**2 + 1.5
C
C     BACKWARD RECURRENCE IN MILLER ALGORITHM.
C
      S = 0.0
      U2 = 0.0
      U1 = EPS
      L = M
      DO 10 I = 1, M
         AL = L
         U3 = U2
         U2 = U1
         AI = ((AL - 0.5)**2 - 1.0/9.0)/(AL*(AL + 1.0))
         BI = 2.0*(AL + Z)/(AL + 1.0)
         U1 = (BI*U2 - U3)/AI
         S = S + U1
   10    L = L - 1
C
C     FINAL ASSEMBLY
C
      K1 = C1*U1/(S*CSQRT(Z))
      K2 = K1*(Z  + 1.0/6.0 - U2/U1)/Z
      IF (IND .NE. 0) RETURN
         E = CEXP(-Z)
         K1 = K1*E
         K2 = K2*E
         RETURN
      END
      REAL FUNCTION AI(X)
C-----------------------------------------------------------------------
C     EVALUATION OF THE AIRY FUNCTION AI(X)
C-----------------------------------------------------------------------
C     X0 = 2**(2/3)
C     C = EXP(2/3)
C-----------------------
      DATA X0/1.58740105196820/
      DATA C /1.94773404105468/
C-----------------------
      DATA AN0/ .355028053887818E+00/, AN1/-.187394912983414E+00/,
     *     AN2/-.383735973881972E-01/, AN3/ .491952571236878E-01/,
     *     AN4/-.967017625191329E-02/, AN5/-.205648610308316E-02/,
     *     AN6/ .114176040526844E-02/, AN7/-.117114823456866E-03/,
     *     AN8/-.270165470074755E-04/, AN9/ .789002965889206E-05/
      DATA AD0/ .100000000000000E+01/, AD1/ .201179850513612E+00/,
     *     AD2/ .385762517106249E-01/, AD3/ .230887443780120E-04/
C-----------------------
      DATA BN0/ .355028053887817E+00/, BN1/-.997169317338190E-01/,
     *     BN2/-.602216060213075E-01/, BN3/ .297705337630730E-01/,
     *     BN4/-.152969932286570E-02/, BN5/-.147868368189372E-02/,
     *     BN6/ .350518617006107E-03/, BN7/-.257766924610873E-04/
      DATA BD0/.100000000000000E+01/, BD1/.448140563306831E+00/,
     *     BD2/.157074537566686E+00/, BD3/.316964519364865E-01/,
     *     BD4/.485922740843953E-02/, BD5/.423326964456309E-03/
C-----------------------
      DATA PN0/.282094378896566E+00/, PN1/.807868561687271E-01/,
     *     PN2/.630644564152247E-02/, PN3/.147116711467936E-03/,
     *     PN4/.750490748341483E-06/
      DATA PD0/.100000000000000E+01/, PD1/.292890323271551E+00/,
     *     PD2/.239376862143358E-01/, PD3/.612353984250624E-03/,
     *     PD4/.384461189764830E-05/, PD5/.123247804102182E-08/
C-----------------------
      DATA QN0/.282094791017188E+00/, QN1/.149585822742689E+00/,
     *     QN2/.241876418864958E-01/, QN3/.138190913282142E-02/,
     *     QN4/.241862862465003E-04/, QN5/.709733720554615E-07/
      DATA QD0/.100000000000000E+01/, QD1/.536778341756648E+00/,
     *     QD2/.889112579703465E-01/, QD3/.533368703697049E-02/,
     *     QD4/.103812739863315E-03/, QD5/.408838544650398E-06/
C-----------------------
      DATA RN0/.282094791773878E+00/, RN1/.203731967781874E+00/,
     *     RN2/.436660479870037E-01/, RN3/.306595563073142E-02/,
     *     RN4/.517398800281618E-04/
      DATA RD0/.100000000000000E+01/, RD1/.728721438361672E+00/,
     *     RD2/.159210021472267E+00/, RD3/.116985268534248E-01/,
     *     RD4/.225973894323078E-03/, RD5/.232707159780478E-06/
C-----------------------------------------------------------------------
      IF (X .GE. -1.0) GO TO 10
      CALL AIMP (-X, R, PHI)
      AI = R*SIN(PHI)
      RETURN
C
   10 IF (X .GE. 0.0) GO TO 20
      AI = (((((((((AN9*X + AN8)*X + AN7)*X + AN6)*X + AN5)*X
     *           + AN4)*X + AN3)*X + AN2)*X + AN1)*X + AN0) /
     *           (((AD3*X + AD2)*X + AD1)*X + AD0)
      RETURN
C
   20 IF (X .GE. 1.0) GO TO 30
      AI = (((((((BN7*X + BN6)*X + BN5)*X + BN4)*X + BN3)*X + BN2)*X
     *                  + BN1)*X + BN0) /
     *     (((((BD5*X + BD4)*X + BD3)*X + BD2)*X + BD1)*X + BD0)
      RETURN
C
   30 RTX = SQRT(X)
      IF (X .GT. X0) GO TO 40
      T = 16.0/(X*RTX)
      W = ((((PN4*T + PN3)*T + PN2)*T + PN1)*T + PN0) /
     *    (((((PD5*T + PD4)*T + PD3)*T + PD2)*T + PD1)*T + PD0)
      AI = (W/SQRT(RTX)) * EXP(-2.0*X*RTX/3.0)
      RETURN
C
   40 IF (X .GT. 4.0D0) GO TO 50
      T = 16.0/(X*RTX)
      W = (((((QN5*T + QN4)*T + QN3)*T + QN2)*T + QN1)*T + QN0) /
     *    (((((QD5*T + QD4)*T + QD3)*T + QD2)*T + QD1)*T + QD0)
      AI = (W/SQRT(RTX)) * EXP(-2.0*X*RTX/3.0)
      RETURN
C
   50 IF (X*RTX .GT. 1.5*EXPARG(0)) GO TO 60
      T = 16.0/(X*RTX)
      W = ((((RN4*T + RN3)*T + RN2)*T + RN1)*T + RN0) /
     *    (((((RD5*T + RD4)*T + RD3)*T + RD2)*T + RD1)*T + RD0)
      N = RTX
      N2 = N*N
      T = (X - N2)/(RTX + N)
      AI = ((W/SQRT(RTX)) / C**(N2*N)) * EXP(-2.0*T*(N*RTX + T*T/3.0))
      RETURN
C
   60 AI = 0.0
      RETURN
      END
      REAL FUNCTION AIE(X)
C-----------------------------------------------------------------------
C
C                   SCALED AIRY FUNCTION AI(X)
C
C
C             AIE(X) = EXP(ZETA)*AI(X)  WHEN X .GE. 0
C             AIE(X) = AI(X)            WHEN X .LT. 0
C
C             ZETA = (2/3) * X**(3/2)
C
C-----------------------------------------------------------------------
C     X0 = 2**(2/3)
C-----------------------
      DATA X0/.158740105196820E+01/
C-----------------------
      DATA AN0/ .355028053887818E+00/, AN1/-.187394912983414E+00/,
     *     AN2/-.383735973881972E-01/, AN3/ .491952571236878E-01/,
     *     AN4/-.967017625191329E-02/, AN5/-.205648610308316E-02/,
     *     AN6/ .114176040526844E-02/, AN7/-.117114823456866E-03/,
     *     AN8/-.270165470074755E-04/, AN9/ .789002965889206E-05/
      DATA AD0/ .100000000000000E+01/, AD1/ .201179850513612E+00/,
     *     AD2/ .385762517106249E-01/, AD3/ .230887443780120E-04/
C-----------------------
      DATA BN0/ .355028053887817E+00/, BN1/-.997169317338190E-01/,
     *     BN2/-.602216060213075E-01/, BN3/ .297705337630730E-01/,
     *     BN4/-.152969932286570E-02/, BN5/-.147868368189372E-02/,
     *     BN6/ .350518617006107E-03/, BN7/-.257766924610873E-04/
      DATA BD0/.100000000000000E+01/, BD1/.448140563306831E+00/,
     *     BD2/.157074537566686E+00/, BD3/.316964519364865E-01/,
     *     BD4/.485922740843953E-02/, BD5/.423326964456309E-03/
C-----------------------
      DATA PN0/.282094378896566E+00/, PN1/.807868561687271E-01/,
     *     PN2/.630644564152247E-02/, PN3/.147116711467936E-03/,
     *     PN4/.750490748341483E-06/
      DATA PD0/.100000000000000E+01/, PD1/.292890323271551E+00/,
     *     PD2/.239376862143358E-01/, PD3/.612353984250624E-03/,
     *     PD4/.384461189764830E-05/, PD5/.123247804102182E-08/
C-----------------------
      DATA QN0/.282094791017188E+00/, QN1/.149585822742689E+00/,
     *     QN2/.241876418864958E-01/, QN3/.138190913282142E-02/,
     *     QN4/.241862862465003E-04/, QN5/.709733720554615E-07/
      DATA QD0/.100000000000000E+01/, QD1/.536778341756648E+00/,
     *     QD2/.889112579703465E-01/, QD3/.533368703697049E-02/,
     *     QD4/.103812739863315E-03/, QD5/.408838544650398E-06/
C-----------------------
      DATA RN0/.282094791773878E+00/, RN1/.203731967781874E+00/,
     *     RN2/.436660479870037E-01/, RN3/.306595563073142E-02/,
     *     RN4/.517398800281618E-04/
      DATA RD0/.100000000000000E+01/, RD1/.728721438361672E+00/,
     *     RD2/.159210021472267E+00/, RD3/.116985268534248E-01/,
     *     RD4/.225973894323078E-03/, RD5/.232707159780478E-06/
C-----------------------------------------------------------------------
      IF (X .GE. -1.0) GO TO 10
      CALL AIMP (-X, R, PHI)
      AIE = R*SIN(PHI)
      RETURN
C
   10 IF (X .GE. 0.0) GO TO 20
      AIE = (((((((((AN9*X + AN8)*X + AN7)*X + AN6)*X + AN5)*X
     *            + AN4)*X + AN3)*X + AN2)*X + AN1)*X + AN0) /
     *            (((AD3*X + AD2)*X + AD1)*X + AD0)
      RETURN
C
   20 IF (X .GE. 1.0) GO TO 30
      AIE = (((((((BN7*X + BN6)*X + BN5)*X + BN4)*X + BN3)*X + BN2)*X
     *                   + BN1)*X + BN0) /
     *      (((((BD5*X + BD4)*X + BD3)*X + BD2)*X + BD1)*X + BD0)
      IF (X .GT. 1.E-20) AIE = AIE * EXP(2.0*X*SQRT(X)/3.0)
      RETURN
C
   30 RTX = SQRT(X)
      IF (X .GT. X0) GO TO 40
      T = 16.0/(X*RTX)
      W = ((((PN4*T + PN3)*T + PN2)*T + PN1)*T + PN0) /
     *    (((((PD5*T + PD4)*T + PD3)*T + PD2)*T + PD1)*T + PD0)
      AIE = W/SQRT(RTX)
      RETURN
C
   40 IF (X .GT. 4.0D0) GO TO 50
      T = 16.0/(X*RTX)
      W = (((((QN5*T + QN4)*T + QN3)*T + QN2)*T + QN1)*T + QN0) /
     *    (((((QD5*T + QD4)*T + QD3)*T + QD2)*T + QD1)*T + QD0)
      AIE = W/SQRT(RTX)
      RETURN
C
   50 IF (X .GT. 1.E20) GO TO 60
      T = 16.0/(X*RTX)
      W = ((((RN4*T + RN3)*T + RN2)*T + RN1)*T + RN0) /
     *    (((((RD5*T + RD4)*T + RD3)*T + RD2)*T + RD1)*T + RD0)
      AIE = W/SQRT(RTX)
      RETURN
C
   60 AIE = RN0/SQRT(RTX)
      RETURN
      END
      REAL FUNCTION BI(X)
C-----------------------------------------------------------------------
C
C             EVALUATION OF THE AIRY FUNCTION BI(X)
C
C
C     NOTE... IF X IS A POSITIVE NUMBER WHERE BI(X) IS TOO LARGE
C     TO BE COMPUTED, THEN BI(X) IS SET TO 0.
C
C-----------------------------------------------------------------------
C     X0 = 16**(2/3)
C     C = EXP(2/3)
C-----------------------
      DATA X0/6.3496042078728/
      DATA C /1.94773404105468/
C-----------------------
      DATA AN0/ .614926627446001E+00/, AN1/ .462726943978834E+00/,
     *     AN2/ .867811386408974E-02/, AN3/ .974670609357959E-01/,
     *     AN4/ .370856545413908E-01/, AN5/ .569193415071716E-03/,
     *     AN6/ .269172131237236E-02/, AN7/ .746473849872868E-03/,
     *     AN8/ .105638036899269E-04/, AN9/ .242726195973978E-04/,
     *     AN10/.557260250681542E-05/
      DATA AD0/ .100000000000000E+01/, AD1/ .234801779278695E-01/,
     *     AD2/-.300487317759152E-02/, AD3/-.597414466459612E-02/
C-----------------------
      DATA BN0/ .614926627446001E+00/, BN1/ .548653374523520E+00/,
     *     BN2/ .582684047163842E-01/, BN3/ .871954925712688E-01/,
     *     BN4/ .508547058449004E-01/, BN5/ .361412623711710E-02/,
     *     BN6/ .177269722794511E-02/, BN7/ .117774184027185E-02/,
     *     BN8/ .627004834186143E-04/, BN9/ .774782269814080E-06/,
     *     BN10/.118116474369315E-04/
      DATA BD0/ .100000000000000E+01/, BD1/ .163214622184402E+00/,
     *     BD2/-.242285981710408E-01/, BD3/-.720554280297616E-02/
C-----------------------
      DATA PN0/.619911943572678E+00/, PN1/.100411558489626E+01/,
     *     PN2/.563659963795768E+00/, PN3/.274925508033015E+00/,
     *     PN4/.115641822943246E+00/, PN5/.120048517441127E-01/,
     *     PN6/.501838091254330E-02/
      DATA PD0/.100000000000000E+01/, PD1/.159751878026937E+01/,
     *     PD2/.104664867034140E+01/, PD3/.512560333664022E+00/,
     *     PD4/.159144727666995E+00/, PD5/.394456748956258E-01/,
     *     PD6/.529926873250079E-02/, PD7/.288921845412576E-03/
C-----------------------
      DATA QN0/.595123543430856E+00/, QN1/.652692120245803E+00/,
     *     QN2/.436851872835894E+00/, QN3/.201626141057807E+00/,
     *     QN4/.649535170626944E-01/, QN5/.171798867787816E-01/,
     *     QN6/.287998748038892E-02/, QN7/.359634362348937E-03/
      DATA QD0/.100000000000000E+01/, QD1/.114259871204893E+01/,
     *     QD2/.766390439057101E+00/, QD3/.348287281255683E+00/,
     *     QD4/.117049276946157E+00/, QD5/.294545450289541E-01/,
     *     QD6/.523951773968125E-02/, QD7/.622692248774973E-03/,
     *     QD8/.674811395957744E-06/
C-----------------------
      DATA RN0 / .568067636505865E+00/, RN1 / .462183136291541E-01/,
     *     RN2 / .268519638203645E+00/, RN3 / .199427104235673E-02/,
     *     RN4 / .135599161332010E-03/, RN5 / .229937707171804E-04/,
     *     RN6 / .697888081361175E-05/, RN7 / .153277172934286E-05/,
     *     RN8 /-.149322381877245E-05/, RN9 /-.113533571972859E-05/,
     *     RN10/ .740721412702102E-06/, RN11/-.120160431596119E-06/
      DATA RD0 / .100000000000000E+01/, RD1 / .741293424676788E-01/,
     *     RD2 / .471695968238457E+00/
C-----------------------
      DATA SN0 /.564189583547757E+00/, SN1 / .112605519585866E+00/,
     *     SN2 /.893329124921909E-03/, SN3 / .532139134120350E-04/,
     *     SN4 /.592725458717738E-05/, SN5 / .921448923850546E-06/,
     *     SN6 /.404558310611815E-06/, SN7 /-.660517686759109E-06/,
     *     SN8 /.174667472383815E-05/, SN9 /-.287037710548882E-05/,
     *     SN10/.322304072982791E-05/, SN11/-.231569499551950E-05/,
     *     SN12/.963478964685941E-06/, SN13/-.173784488565533E-06/
      DATA SD0 /.100000000000000E+01/, SD1 / .193077670156841E+00/
C-----------------------------------------------------------------------
      IF (X .GE. -1.0) GO TO 10
      CALL AIMP (-X, R, PHI)
      BI = R*COS(PHI)
      RETURN
C
   10 IF (X .GE. 0.0) GO TO 20
      BI = ((((((((((AN10*X + AN9)*X + AN8)*X + AN7)*X
     *             + AN6)*X + AN5)*X + AN4)*X + AN3)*X
     *             + AN2)*X + AN1)*X + AN0) /
     *             (((AD3*X + AD2)*X + AD1)*X + AD0)
      RETURN
C
   20 IF (X .GT. 1.0) GO TO 30
      BI = ((((((((((BN10*X + BN9)*X + BN8)*X + BN7)*X
     *             + BN6)*X + BN5)*X + BN4)*X + BN3)*X
     *             + BN2)*X + BN1)*X + BN0) /
     *             (((BD3*X + BD2)*X + BD1)*X + BD0)
      RETURN
C
   30 RTX = SQRT(X)
      IF (X .GT. 2.0) GO TO 40
      T = X - 1.0
      W = ((((((PN6*T + PN5)*T + PN4)*T + PN3)*T + PN2)*T
     *                + PN1)*T + PN0) /
     *    (((((((PD7*T + PD6)*T + PD5)*T + PD4)*T + PD3)*T
     *                 + PD2)*T + PD1)*T + PD0)
      BI = (W/SQRT(RTX)) * EXP(2.0*X*RTX/3.0)
      RETURN
C
   40 IF (X .GT. 4.0) GO TO 50
      T = X - 2.0
      W = (((((((QN7*T + QN6)*T + QN5)*T + QN4)*T + QN3)*T
     *                 + QN2)*T + QN1)*T + QN0) /
     *    ((((((((QD8*T + QD7)*T + QD6)*T + QD5)*T + QD4)*T
     *                  + QD3)*T + QD2)*T + QD1)*T + QD0)
      BI = (W/SQRT(RTX)) * EXP(2.0*X*RTX/3.0)
      RETURN
C
   50 IF (X .GT. X0) GO TO 60
      T = 16.0/(X*RTX) - 1.0
      W = (((((((((((RN11*T + RN10)*T + RN9)*T + RN8)*T
     *     + RN7)*T + RN6)*T + RN5)*T + RN4)*T + RN3)*T
     *     + RN2)*T + RN1)*T + RN0) /
     *      ((RD2*T + RD1)*T + RD0)
      BI = (W/SQRT(RTX)) * EXP(2.0*X*RTX/3.0)
      RETURN
C
   60 IF (X*RTX .GT. 1.5*EXPARG(0)) GO TO 70
      T = 16.0/(X*RTX)
      W = (((((((((((((SN13*T + SN12)*T + SN11)*T + SN10)*T
     *         + SN9)*T + SN8)*T + SN7)*T + SN6)*T + SN5)*T
     *         + SN4)*T + SN3)*T + SN2)*T + SN1)*T + SN0) /
     *           (SD1*T + SD0)
      N = RTX
      N2 = N*N
      T = (X - N2)/(RTX + N)
      BI = (W/SQRT(RTX)) * C**(N2*N) * EXP(2.0*T*(N*RTX + T*T/3.0))
      RETURN
C
   70 BI = 0.0
      RETURN
      END
      REAL FUNCTION BIE(X)
C-----------------------------------------------------------------------
C
C                    SCALED AIRY FUNCTION BI(X)
C
C
C             BIE(X) = EXP(-ZETA)*BI(X)  WHEN X .GE. 0
C             BIE(X) = BI(X)             WHEN X .LT. 0
C
C             ZETA = (2/3) * X**(3/2)
C
C-----------------------------------------------------------------------
C     X0 = 16**(2/3)
C-----------------------
      DATA X0/6.3496042078728/
C-----------------------
      DATA AN0/ .614926627446001E+00/, AN1/ .462726943978834E+00/,
     *     AN2/ .867811386408974E-02/, AN3/ .974670609357959E-01/,
     *     AN4/ .370856545413908E-01/, AN5/ .569193415071716E-03/,
     *     AN6/ .269172131237236E-02/, AN7/ .746473849872868E-03/,
     *     AN8/ .105638036899269E-04/, AN9/ .242726195973978E-04/,
     *     AN10/.557260250681542E-05/
      DATA AD0/ .100000000000000E+01/, AD1/ .234801779278695E-01/,
     *     AD2/-.300487317759152E-02/, AD3/-.597414466459612E-02/
C-----------------------
      DATA BN0/ .614926627446001E+00/, BN1/ .548653374523520E+00/,
     *     BN2/ .582684047163842E-01/, BN3/ .871954925712688E-01/,
     *     BN4/ .508547058449004E-01/, BN5/ .361412623711710E-02/,
     *     BN6/ .177269722794511E-02/, BN7/ .117774184027185E-02/,
     *     BN8/ .627004834186143E-04/, BN9/ .774782269814080E-06/,
     *     BN10/.118116474369315E-04/
      DATA BD0/ .100000000000000E+01/, BD1/ .163214622184402E+00/,
     *     BD2/-.242285981710408E-01/, BD3/-.720554280297616E-02/
C-----------------------
      DATA PN0/.619911943572678E+00/, PN1/.100411558489626E+01/,
     *     PN2/.563659963795768E+00/, PN3/.274925508033015E+00/,
     *     PN4/.115641822943246E+00/, PN5/.120048517441127E-01/,
     *     PN6/.501838091254330E-02/
      DATA PD0/.100000000000000E+01/, PD1/.159751878026937E+01/,
     *     PD2/.104664867034140E+01/, PD3/.512560333664022E+00/,
     *     PD4/.159144727666995E+00/, PD5/.394456748956258E-01/,
     *     PD6/.529926873250079E-02/, PD7/.288921845412576E-03/
C-----------------------
      DATA QN0/.595123543430856E+00/, QN1/.652692120245803E+00/,
     *     QN2/.436851872835894E+00/, QN3/.201626141057807E+00/,
     *     QN4/.649535170626944E-01/, QN5/.171798867787816E-01/,
     *     QN6/.287998748038892E-02/, QN7/.359634362348937E-03/
      DATA QD0/.100000000000000E+01/, QD1/.114259871204893E+01/,
     *     QD2/.766390439057101E+00/, QD3/.348287281255683E+00/,
     *     QD4/.117049276946157E+00/, QD5/.294545450289541E-01/,
     *     QD6/.523951773968125E-02/, QD7/.622692248774973E-03/,
     *     QD8/.674811395957744E-06/
C-----------------------
      DATA RN0 / .568067636505865E+00/, RN1 / .462183136291541E-01/,
     *     RN2 / .268519638203645E+00/, RN3 / .199427104235673E-02/,
     *     RN4 / .135599161332010E-03/, RN5 / .229937707171804E-04/,
     *     RN6 / .697888081361175E-05/, RN7 / .153277172934286E-05/,
     *     RN8 /-.149322381877245E-05/, RN9 /-.113533571972859E-05/,
     *     RN10/ .740721412702102E-06/, RN11/-.120160431596119E-06/
      DATA RD0 / .100000000000000E+01/, RD1 / .741293424676788E-01/,
     *     RD2 / .471695968238457E+00/
C-----------------------
      DATA SN0 /.564189583547757E+00/, SN1 / .112605519585866E+00/,
     *     SN2 /.893329124921909E-03/, SN3 / .532139134120350E-04/,
     *     SN4 /.592725458717738E-05/, SN5 / .921448923850546E-06/,
     *     SN6 /.404558310611815E-06/, SN7 /-.660517686759109E-06/,
     *     SN8 /.174667472383815E-05/, SN9 /-.287037710548882E-05/,
     *     SN10/.322304072982791E-05/, SN11/-.231569499551950E-05/,
     *     SN12/.963478964685941E-06/, SN13/-.173784488565533E-06/
      DATA SD0 /.100000000000000E+01/, SD1 / .193077670156841E+00/
C-----------------------------------------------------------------------
      IF (X .GE. -1.0) GO TO 10
      CALL AIMP (-X, R, PHI)
      BIE = R*COS(PHI)
      RETURN
C
   10 IF (X .GE. 0.0) GO TO 20
      BIE = ((((((((((AN10*X + AN9)*X + AN8)*X + AN7)*X
     *              + AN6)*X + AN5)*X + AN4)*X + AN3)*X
     *              + AN2)*X + AN1)*X + AN0) /
     *              (((AD3*X + AD2)*X + AD1)*X + AD0)
      RETURN
C
   20 IF (X .GT. 1.0) GO TO 30
      BIE = ((((((((((BN10*X + BN9)*X + BN8)*X + BN7)*X
     *              + BN6)*X + BN5)*X + BN4)*X + BN3)*X
     *              + BN2)*X + BN1)*X + BN0) /
     *              (((BD3*X + BD2)*X + BD1)*X + BD0)
      IF (X .GT. 1.E-20) BIE = BIE * EXP(-2.0*X*SQRT(X)/3.0)
      RETURN
C
   30 RTX = SQRT(X)
      IF (X .GT. 2.0) GO TO 40
      T = X - 1.0
      W = ((((((PN6*T + PN5)*T + PN4)*T + PN3)*T + PN2)*T
     *                + PN1)*T + PN0) /
     *    (((((((PD7*T + PD6)*T + PD5)*T + PD4)*T + PD3)*T
     *                 + PD2)*T + PD1)*T + PD0)
      BIE = W/SQRT(RTX)
      RETURN
C
   40 IF (X .GT. 4.0) GO TO 50
      T = X - 2.0
      W = (((((((QN7*T + QN6)*T + QN5)*T + QN4)*T + QN3)*T
     *                 + QN2)*T + QN1)*T + QN0) /
     *    ((((((((QD8*T + QD7)*T + QD6)*T + QD5)*T + QD4)*T
     *                  + QD3)*T + QD2)*T + QD1)*T + QD0)
      BIE = W/SQRT(RTX)
      RETURN
C
   50 IF (X .GT. X0) GO TO 60
      T = 16.0/(X*RTX) - 1.0
      W = (((((((((((RN11*T + RN10)*T + RN9)*T + RN8)*T
     *     + RN7)*T + RN6)*T + RN5)*T + RN4)*T + RN3)*T
     *     + RN2)*T + RN1)*T + RN0) /
     *      ((RD2*T + RD1)*T + RD0)
      BIE = W/SQRT(RTX)
      RETURN
C
   60 IF (X .GT. 1.E20) GO TO 70
      T = 16.0/(X*RTX)
      W = (((((((((((((SN13*T + SN12)*T + SN11)*T + SN10)*T
     *         + SN9)*T + SN8)*T + SN7)*T + SN6)*T + SN5)*T
     *         + SN4)*T + SN3)*T + SN2)*T + SN1)*T + SN0) /
     *           (SD1*T + SD0)
      BIE = W/SQRT(RTX)
      RETURN
C
   70 BIE = SN0/SQRT(RTX)
      RETURN
      END
      SUBROUTINE AIMP (X, R, PHI)
C-----------------------------------------------------------------------
C     COMPUTATION OF THE AIRY MODULUS AND PHASE FOR X .GE. 1
C-----------------------------------------------------------------------
      DATA PI4 /.785398163397448/
C-----------------------
      DATA AN0/.297640916735064E+00/, AN1/.772796814419809E+00/,
     *     AN2/.764990563560236E+00/, AN3/.375694096095838E+00/,
     *     AN4/.978661044870204E-01/, AN5/.110446639522696E-01/,
     *     AN6/.145271249611697E-05/
      DATA AD0/.100000000000000E+01/, AD1/.247380029946443E+01/,
     *     AD2/.240125897828762E+01/, AD3/.118267264172257E+01/,
     *     AD4/.306942883081787E+00/, AD5/.347670057203535E-01/
C-----------------------
      DATA BN0/.593601051670149E+00/, BN1/.223281495955754E+01/,
     *     BN2/.317718143418600E+01/, BN3/.229890914530923E+01/,
     *     BN4/.933580623665765E+00/, BN5/.209164380960390E+00/,
     *     BN6/.207910965366403E-01/
      DATA BD0/.100000000000000E+01/, BD1/.345985556561483E+01/,
     *     BD2/.479629661187354E+01/, BD3/.345429311552596E+01/,
     *     BD4/.140017214942186E+01/, BD5/.313770549939860E+00/,
     *     BD6/.311852186700025E-01/
C-----------------------
      DATA CN0/.313541841678871E+00/, CN1/.470104287134296E+00/,
     *     CN2/.291795874641314E+00/, CN3/.962250689852768E-01/,
     *     CN4/.171024484244850E-01/, CN5/.134933201907052E-02/
      DATA CD0/.100000000000000E+01/, CD1/.148070947673639E+01/,
     *     CD2/.917484386216329E+00/, CD3/.302281922152536E+00/,
     *     CD4/.537309296828367E-01/, CD5/.423890576557513E-02/,
     *     CD6/.525954318463502E-08/
C-----------------------
      DATA DN0/.654836896032068E+00/, DN1/.117099614856528E+01/,
     *     DN2/.831899010444840E+00/, DN3/.301060337976575E+00/,
     *     DN4/.564712748150658E-01/, DN5/.444134415666317E-02/
      DATA DD0/.100000000000000E+01/, DD1/.176306543768126E+01/,
     *     DD2/.124897609613487E+01/, DD3/.451576491257036E+00/,
     *     DD4/.847085955634988E-01/, DD5/.666188176245820E-02/,
     *     DD6/.537600060708764E-08/
C-----------------------
      DATA PN0/.318309886183791E+00/, PN1/.100996327221962E+01/,
     *     PN2/.902315148591491E+00/, PN3/.259820640977615E+00/,
     *     PN4/.203717769716282E-01/, PN5/.216893438784765E-03/
      DATA PD0/.100000000000000E+01/, PD1/.317533460265059E+01/,
     *     PD2/.284232123705698E+01/, PD3/.822777439238360E+00/,
     *     PD4/.656865942543526E-01/, PD5/.775376048996392E-03/
C-----------------------
      DATA QN0/.666666666666667E+00/, QN1/.141905542385598E+01/,
     *     QN2/.772778148352443E+00/, QN3/.115170415082442E+00/,
     *     QN4/.326457319318373E-02/
      DATA QD0/.100000000000000E+01/, QD1/.213102454203392E+01/,
     *     QD2/.116432601041188E+01/, QD3/.175509465791633E+00/,
     *     QD4/.528319849831061E-02/, QD5/.867802002275824E-05/
C-----------------------------------------------------------------------
      IF (X .GT. 2.0) GO TO 10
      Z = X - 1.0
      R =   ((((((AN6*Z + AN5)*Z + AN4)*Z + AN3)*Z + AN2)*Z
     *                  + AN1)*Z + AN0) /
     *      (((((AD5*Z + AD4)*Z + AD3)*Z + AD2)*Z + AD1)*Z + AD0)
      PHI = ((((((BN6*Z + BN5)*Z + BN4)*Z + BN3)*Z + BN2)*Z
     *                  + BN1)*Z + BN0) /
     *      ((((((BD6*Z + BD5)*Z + BD4)*Z + BD3)*Z + BD2)*Z
     *                  + BD1)*Z + BD0)
      GO TO 40
C
   10 IF (X .GE. 4.0) GO TO 20
      Z = X - 2.0
      R =   (((((CN5*Z + CN4)*Z + CN3)*Z + CN2)*Z + CN1)*Z + CN0) /
     *      ((((((CD6*Z + CD5)*Z + CD4)*Z + CD3)*Z + CD2)*Z
     *                  + CD1)*Z + CD0)
      PHI = (((((DN5*Z + DN4)*Z + DN3)*Z + DN2)*Z + DN1)*Z + DN0) /
     *      ((((((DD6*Z + DD5)*Z + DD4)*Z + DD3)*Z + DD2)*Z
     *                  + DD1)*Z + DD0)
      GO TO 40
C
   20 IF (X .GT. 1.E10) GO TO 30
      Z = 64.0/X**3
      R =   (((((PN5*Z + PN4)*Z + PN3)*Z + PN2)*Z + PN1)*Z + PN0) /
     *      (((((PD5*Z + PD4)*Z + PD3)*Z + PD2)*Z + PD1)*Z + PD0)
      PHI = ((((QN4*Z + QN3)*Z + QN2)*Z + QN1)*Z + QN0) /
     *      (((((QD5*Z + QD4)*Z + QD3)*Z + QD2)*Z + QD1)*Z + QD0)
      GO TO 40
C
   30 R = PN0
      PHI = QN0
C
 40   RTX = SQRT(X)
      R = SQRT(R/RTX)
      PHI = PI4 + X*RTX*PHI
      RETURN
      END
      COMPLEX FUNCTION CK(K,L)
C     ------------------------------------------------------------------
C     THIS FUNCTION CALCULATES THE COMPLETE ELLIPTIC INTEGRAL F(K)
C     FOR COMPLEX VALUES OF THE MODULUS K. IT IS ASSUMED THAT L.NE.0
C     AND THAT K**2 + L**2 = 1.
C     ------------------------------------------------------------------
      COMPLEX K,L,AK,AL,AK1,AL1,AL2,CKK,CKP,F1,F2,F3,FXK,AKTEMP,CK1,J
      COMPLEX CFLECT,KM,Z
      REAL LN4,X1(12),X2(12),W1(12),W2(12),FL(12),FA(12),FB(12)
      LOGICAL BRANCH
C     --------------------------------------------------------------
      DATA X1(1)/ 6.5487222790801E-03/, X1(2)/ 3.8946809560450E-02/,
     1     X1(3)/ 9.8150263106007E-02/, X1(4)/ 1.8113858159063E-01/,
     2     X1(5)/ 2.8322006766737E-01/, X1(6)/ 3.9843443516344E-01/,
     3     X1(7)/ 5.1995262679235E-01/, X1(8)/ 6.4051091671611E-01/,
     4     X1(9)/ 7.5286501205183E-01/, X1(10)/8.5024002416230E-01/,
     5     X1(11)/9.2674968322391E-01/, X1(12)/9.7775612969000E-01/
C     --------------------------------------------------------------
      DATA W1(1)/ 9.3192691443932E-02/, W1(2)/ 1.4975182757632E-01/,
     1     W1(3)/ 1.6655745436459E-01/, W1(4)/ 1.5963355943699E-01/,
     2     W1(5)/ 1.3842483186484E-01/, W1(6)/ 1.1001657063572E-01/,
     3     W1(7)/ 7.9961821770829E-02/, W1(8)/ 5.2406954824642E-02/,
     4     W1(9)/ 3.0071088873761E-02/, W1(10)/1.4249245587998E-02/,
     5     W1(11)/4.8999245823217E-03/, W1(12)/8.3402903805690E-04/
C     --------------------------------------------------------------
      DATA FL(1)/ 1.5708005371203E+00/, FL(2)/ 1.5709452753591E+00/,
     1     FL(3)/ 1.5717433742881E+00/, FL(4)/ 1.5740325056162E+00/,
     2     FL(5)/ 1.5787613653341E+00/, FL(6)/ 1.5867393901613E+00/,
     3     FL(7)/ 1.5983969635617E+00/, FL(8)/ 1.6135762587884E+00/,
     4     FL(9)/ 1.6313677113831E+00/, FL(10)/1.6500349733510E+00/,
     5     FL(11)/1.6671202200919E+00/, FL(12)/1.6798403417359E+00/
C     --------------------------------------------------------------
      DATA X2(1)/-9.8156063424672E-01/, X2(2)/-9.0411725637048E-01/,
     1     X2(3)/-7.6990267419431E-01/, X2(4)/-5.8731795428662E-01/,
     2     X2(5)/-3.6783149899818E-01/, X2(6)/-1.2523340851147E-01/,
     3     X2(7)/ 1.2523340851147E-01/, X2(8)/ 3.6783149899818E-01/,
     4     X2(9)/ 5.8731795428662E-01/, X2(10)/7.6990267419431E-01/,
     5     X2(11)/9.0411725637048E-01/, X2(12)/9.8156063424672E-01/
C     --------------------------------------------------------------
      DATA W2(1)/ 4.7175336386512E-02/, W2(2)/ 1.0693932599532E-01/,
     1     W2(3)/ 1.6007832854335E-01/, W2(4)/ 2.0316742672307E-01/,
     2     W2(5)/ 2.3349253653836E-01/, W2(6)/ 2.4914704581340E-01/,
     3     W2(7)/ 2.4914704581340E-01/, W2(8)/ 2.3349253653836E-01/,
     4     W2(9)/ 2.0316742672307E-01/, W2(10)/1.6007832854335E-01/,
     5     W2(11)/1.0693932599532E-01/, W2(12)/4.7175336386512E-02/
C     --------------------------------------------------------------
      DATA FA(1)/ 2.0794472764428E+00/, FA(2)/ 2.0795966441739E+00/,
     1     FA(3)/ 2.0803359313463E+00/, FA(4)/ 2.0823286205438E+00/,
     2     FA(5)/ 2.0862633195105E+00/, FA(6)/ 2.0926508621232E+00/,
     3     FA(7)/ 2.1016440761258E+00/, FA(8)/ 2.1128974786197E+00/,
     4     FA(9)/ 2.1254857173540E+00/, FA(10)/2.1379218133017E+00/,
     5     FA(11)/2.1483404506064E+00/, FA(12)/2.1548934173960E+00/
C     --------------------------------------------------------------
      DATA FB(1)/ 1.5744273529551E+00/, FB(2)/ 1.5899097325063E+00/,
     1     FB(3)/ 1.6176685384410E+00/, FB(4)/ 1.6574605448620E+00/,
     2     FB(5)/ 1.7087245795822E+00/, FB(6)/ 1.7703459462057E+00/,
     3     FB(7)/ 1.8403280188791E+00/, FB(8)/ 1.9154060277115E+00/,
     4     FB(9)/ 1.9907093877047E+00/, FB(10)/2.0596975322636E+00/,
     5     FB(11)/2.1146977530430E+00/, FB(12)/2.1482986855683E+00/
C     --------------------------------------------------------------
      DATA J/(0.0, 1.0)/
      DATA LN4 /1.3862943611199/
      DATA C1  /.20264236728467/, C2/.15915494309189/
C     ---------------------------------------------------
C
C     EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
C     SMALLEST NUMBER SUCH THAT 1. + EPS .GT. 1.
C
      EPS = SPMPAR(1)
C
C     ---------------------------------------------------
      IF (L .EQ. (0.0, 0.0)) GO TO 200
      IND = 0
      BRANCH = .TRUE.
      TOL = 8.0*AMAX1(EPS, 1.E-14)
C
      AK1 = CFLECT(K)
      AL1 = CFLECT(L)
      AK = AK1
      AL = AL1
C
      X = REAL(AK)
      Y = AIMAG(AK)
      U = REAL(AL)
      V = AIMAG(AL)
      IF (AMAX1(X,ABS(Y)) .GE. 1.0/EPS) GO TO 90
      IF (AMAX1(U,ABS(V)) .GE. 1.1/EPS) GO TO 200
C
C     CHECK THAT K**2 + L**2 = 1
C
      IF (X .LT. U) GO TO 1
         T = U/X
         IF (ABS(X*X/(V*V + 1.0/(1.0 + T*T)) - 1.0) .GT. TOL) GO TO 200
         IF (ABS(Y + T*V) .GT. TOL*AMAX1(1.0, ABS(V))) GO TO 200
         GO TO 10
    1 T = X/U
      IF (ABS(U*U/(Y*Y + 1.0/(1.0 + T*T)) - 1.0) .GT. TOL) GO TO 200
      IF (ABS(V + T*Y) .GT. TOL*AMAX1(1.0, ABS(Y))) GO TO 200
C
C     USES  LOGARITHMIC SERIES WHEN CABS(AL)
C     IS LESS THAN OR EQUAL TO 0.55
C
   10 IF (U .GT. 1.42 .OR. ABS(V) .GT. 1.42) GO TO 50
   11 IF (CABS(AL) .GT. 0.55) GO TO 20
      CALL KL(AL,CKK,CKP)
      IF (BRANCH) GO TO 22
      CK1 = CKK
      CK = CKP
      AL = AK
      GO TO 80
C
C     USES MACLAURIN EXPANSION WHEN THE ABSOLUTE VALUE OF
C     THE MODULUS AK IS LESS THAN OR EQUAL TO 0.55
C
   20 R = CABS(AK)
      IF (R .GT. 0.55) GO TO 30
      IF (BRANCH) GO TO 21
      CALL KL(AK,CKP,CK1)
      CK = CKP
      AL = AK
      GO TO 80
   21 CKK = KM(AK*AK)
   22 CK = CKK
      GO TO 70
C
C     NUMERICAL QUADRATURE APPROXIMATION
C
   30 IF (IND .EQ. 0 .AND. R .GT. 1.0) GO TO 50
   31 AL2 = AL*AL
C
      F1 = (0.0, 0.0)
      DO 40 I = 1,12
         XX = X1(I)/2.
         FXK = AK*XX
   40    F1 = F1 + W1(I)*FL(I)/(AL2 + FXK*FXK)
      F2 = (0.0, 0.0)
      DO 41 I = 1,12
         XX = .25*(1.+ X2(I))
         FXK = AK*XX
   41    F2 = F2 + W2(I)*FA(I)/(AL2 + FXK*FXK)
      F3 = (0.0, 0.0)
      DO 42 I = 1,12
         XX = .25*(3.- X2(I))
         FXK = AK*XX
   42    F3 = F3 + W2(I)*FB(I)/(AL2 + FXK*FXK)
C
      CK = AL*(C1*F1 + C2*(F2 + F3))
C
C     END OF NUMERICAL QUADRATURE APPROXIMATION
C
      IF (BRANCH) GO TO 70
      CK1 = CK
      BRANCH = .TRUE.
C
C     INTERCHANGE AK AND AL
C
      AKTEMP = AK
      AK = AL
      AL = AKTEMP
      GO TO 31
C
C     USES INVERSE MODULUS TRANSFORMATION WHEN CABS(AK) IS GREATER
C     THAN 1 AND REAL(AK**2) IS GREATER THAN 0.5.
C
   50 IF (X*X .LE. Y*Y + 0.5) GO TO 60
      IND = 1
      BRANCH = .FALSE.
      AK = 1.0/AK1
      AL = CFLECT(J*AL1/AK1)
      GO TO 11
C
C     USES COMPLEMENTARY INVERSE MODULUS TRANSFORMATION WHEN CABS(AK)
C     IS GREATER THAN 1 AND REAL(AK**2) IS LESS THAN OR EQUAL TO 0.5
C
   60 IND = 2
      AK = CFLECT(J*AK1/AL1)
      AL = 1.0/AL1
      GO TO 11
C
C     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
C
   70 IF (IND .EQ. 0) RETURN
      IF (IND .EQ. 1) GO TO 80
C
C     COMPLEMENTARY INVERSE MODULUS TRANSFORMATION
C
      CK = AL*CK
      RETURN
C
C     INVERSE MODULUS TRANSFORMATION
C
   80 IF (AIMAG(AK1) .GE. 0.0) GO TO 81
         CK = AL*(CK1 - J*CK)
         RETURN
   81 CK = AL*(CK1 + J*CK)
      RETURN
C
C     CALCULATION OF F(K) FOR LARGE K AND L
C
   90 IF (X .LE. ABS(Y)) GO TO 100
      IF (ABS(ABS(V/X) - 1.0) .GT. TOL) GO TO 200
      IF (ABS(U/X + Y/V) .GT. TOL) GO TO 200
      T = Y/X
      PHI = ATAN2(X,ABS(Y))
      R = (LN4 + 0.5*ALNREL(T*T)) + ALOG(X)
      IF (Y .LT. 0.0) R = -R
      CK = (CMPLX(PHI,R)/CMPLX(1.0,T))/X
      RETURN
C
  100 IF (ABS(ABS(U/Y) - 1.0) .GT. TOL) GO TO 200
      IF (ABS(X/U + V/Y) .GT. TOL) GO TO 200
      T = V/U
      Z = CMPLX((LN4 + 0.5*ALNREL(T*T)) + ALOG(U), ATAN2(V,U))
      CK = (Z/CMPLX(1.0,T))/U
      RETURN
C
C     ERROR RETURN
C
  200 CK = (0.0, 0.0)
      RETURN
      END
      COMPLEX FUNCTION CFLECT(Z)
C---------------------------------------------------------
C     REFLECTS Z WITH RESPECT TO THE ORIGIN IF REAL(Z)
C     .LT. 0.0 OR IF Z IS ON THE NEGATIVE IMAGINARY AXIS.
C---------------------------------------------------------
      COMPLEX Z
C     ----------
      IF (REAL(Z)) 10,20,30
   10 CFLECT = -Z
      RETURN
   20 CFLECT = CMPLX(0.0, ABS(AIMAG(Z)))
      RETURN
   30 CFLECT = Z
      RETURN
      END
      COMPLEX FUNCTION KM(K2)
      COMPLEX K2
C---------------------------------------------------------------------
C     KM COMPUTES THE COMPLETE ELLIPTIC INTEGRAL F(K) FOR A GIVEN
C     VALUE OF K2 = K**2 BY USE OF THE MACLAURIN EXPANSION.
C---------------------------------------------------------------------
      COMPLEX AN,S1
      DATA HPI /1.5707963267949/
C ---------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
                      EPS = SPMPAR(1)
C
C ---------------
C
      TOL = AMAX1(EPS,1.E-14)
      S1 = (1.0, 0.0)
      AN = (1.0, 0.0)
      DO 10 I = 1,50
         RI = I
         C = ((RI - 0.5)/RI)**2
         AN = C*(AN*K2)
         S1 = S1 + AN
         IF (ABS(REAL(AN)) + ABS(AIMAG(AN)) .LT. TOL) GO TO 20
   10 CONTINUE
C
   20 KM = HPI*S1
      RETURN
      END
      SUBROUTINE KL (L, FK, FL)
      COMPLEX L, FK, FL
C ----------------------------------------------------------------------
C     KL COMPUTES THE COMPLETE ELLIPTIC INTEGRALS F(K) AND F(L) FOR
C     A GIVEN VALUE OF L, WHERE CABS(L) .LT. 1 AND K**2 + L**2 = 1.
C     IT IS ASSUMED THAT -PI .LE. ARG(L**2) .LT. PI FOR THE RESULTING
C     VALUE FOR F(K) TO BE MEANINGFUL.
C ----------------------------------------------------------------------
      COMPLEX AN,L2,S1,S2,W
      REAL LN4
C     --------------
      DATA HPI /1.5707963267949/
      DATA LN4 /1.3862943611199/
C ---------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
                      EPS = SPMPAR(1)
C
C ---------------
C
C            THE LOGARITHMIC EXPANSION IS USED FOR F(K)
C              AND THE MACLAURIN EXPANSION FOR F(L)
C
      TOL = AMAX1(EPS,1.E-14)
      L2 = L*L
      S1 = (0.0, 0.0)
      S2 = (0.0, 0.0)
      AN = (1.0, 0.0)
      BN = 0.0
      DO 10 I = 1,50
         RI = I
         C = ((RI - 0.5)/RI)**2
         AN = C*(AN*L2)
         BN = BN + 1.0/(RI*(2.0*RI - 1.0))
         S1 = S1 + AN
         S2 = S2 + AN*BN
         IF (ABS(REAL(AN)) + ABS(AIMAG(AN)) .LT. TOL) GO TO 20
   10 CONTINUE
   20 S1 = S1 + (1.0, 0.0)
C
C                   SET W = 0.5*CLOG(16.0/L2)
C
      X = REAL(L)
      Y = AIMAG(L)
      IF (X .NE. 0.0) GO TO 30
         W = CMPLX(LN4 - ALOG(ABS(Y)), HPI)
         GO TO 50
C
   30 IF (ABS(X) .GT. ABS(Y)) GO TO 31
         U = (LN4 - 0.5*ALNREL((X/Y)**2)) - ALOG(ABS(Y))
         GO TO 40
   31 U = (LN4 - 0.5*ALNREL((Y/X)**2)) - ALOG(ABS(X))
C
   40 IF (X .GT. 0.0) GO TO 41
         W = CMPLX(U, -ATAN2(-Y,-X))
         GO TO 50
   41 W = CMPLX(U, -ATAN2(Y,X))
C
C                        FINAL ASSEMBLY
C
   50 FK = W*S1 - S2
      FL = HPI*S1
      RETURN
      END
      SUBROUTINE CKE(K,L,CK,CE,IERR)
C     ------------------------------------------------------------------
C     THIS FUNCTION CALCULATES THE COMPLETE ELLIPTIC INTEGRALS F(K)
C     AND E(K) FOR COMPLEX VALUES OF THE MODULUS K. IT IS ASSUMED
C     THAT L.NE.0 AND THAT K**2 + L**2 = 1.
C     ------------------------------------------------------------------
      COMPLEX K,L,AK,AL,AK1,AL1,CKK,CKP,F1,F2,F3,AKTEMP,CK1,J
      COMPLEX CE,CK,CEE,CEP,CE1,E1,E2,E3,AT,FX,FXK,ATN
      COMPLEX CFLECT,K1,L1,AK2,AL2,Z,G,G1,GG,GP
      REAL LN4,X1(12),X2(12),W1(12),W2(12),FL(12),FA(12),FB(12)
      LOGICAL BRANCH
C     --------------------------------------------------------------
      DATA X1(1)/ 6.5487222790801E-03/, X1(2)/ 3.8946809560450E-02/,
     1     X1(3)/ 9.8150263106007E-02/, X1(4)/ 1.8113858159063E-01/,
     2     X1(5)/ 2.8322006766737E-01/, X1(6)/ 3.9843443516344E-01/,
     3     X1(7)/ 5.1995262679235E-01/, X1(8)/ 6.4051091671611E-01/,
     4     X1(9)/ 7.5286501205183E-01/, X1(10)/8.5024002416230E-01/,
     5     X1(11)/9.2674968322391E-01/, X1(12)/9.7775612969000E-01/
C     --------------------------------------------------------------
      DATA W1(1)/ 9.3192691443932E-02/, W1(2)/ 1.4975182757632E-01/,
     1     W1(3)/ 1.6655745436459E-01/, W1(4)/ 1.5963355943699E-01/,
     2     W1(5)/ 1.3842483186484E-01/, W1(6)/ 1.1001657063572E-01/,
     3     W1(7)/ 7.9961821770829E-02/, W1(8)/ 5.2406954824642E-02/,
     4     W1(9)/ 3.0071088873761E-02/, W1(10)/1.4249245587998E-02/,
     5     W1(11)/4.8999245823217E-03/, W1(12)/8.3402903805690E-04/
C     --------------------------------------------------------------
      DATA FL(1)/ 1.5708005371203E+00/, FL(2)/ 1.5709452753591E+00/,
     1     FL(3)/ 1.5717433742881E+00/, FL(4)/ 1.5740325056162E+00/,
     2     FL(5)/ 1.5787613653341E+00/, FL(6)/ 1.5867393901613E+00/,
     3     FL(7)/ 1.5983969635617E+00/, FL(8)/ 1.6135762587884E+00/,
     4     FL(9)/ 1.6313677113831E+00/, FL(10)/1.6500349733510E+00/,
     5     FL(11)/1.6671202200919E+00/, FL(12)/1.6798403417359E+00/
C     --------------------------------------------------------------
      DATA X2(1)/-9.8156063424672E-01/, X2(2)/-9.0411725637048E-01/,
     1     X2(3)/-7.6990267419431E-01/, X2(4)/-5.8731795428662E-01/,
     2     X2(5)/-3.6783149899818E-01/, X2(6)/-1.2523340851147E-01/,
     3     X2(7)/ 1.2523340851147E-01/, X2(8)/ 3.6783149899818E-01/,
     4     X2(9)/ 5.8731795428662E-01/, X2(10)/7.6990267419431E-01/,
     5     X2(11)/9.0411725637048E-01/, X2(12)/9.8156063424672E-01/
C     --------------------------------------------------------------
      DATA W2(1)/ 4.7175336386512E-02/, W2(2)/ 1.0693932599532E-01/,
     1     W2(3)/ 1.6007832854335E-01/, W2(4)/ 2.0316742672307E-01/,
     2     W2(5)/ 2.3349253653836E-01/, W2(6)/ 2.4914704581340E-01/,
     3     W2(7)/ 2.4914704581340E-01/, W2(8)/ 2.3349253653836E-01/,
     4     W2(9)/ 2.0316742672307E-01/, W2(10)/1.6007832854335E-01/,
     5     W2(11)/1.0693932599532E-01/, W2(12)/4.7175336386512E-02/
C     --------------------------------------------------------------
      DATA FA(1)/ 2.0794472764428E+00/, FA(2)/ 2.0795966441739E+00/,
     1     FA(3)/ 2.0803359313463E+00/, FA(4)/ 2.0823286205438E+00/,
     2     FA(5)/ 2.0862633195105E+00/, FA(6)/ 2.0926508621232E+00/,
     3     FA(7)/ 2.1016440761258E+00/, FA(8)/ 2.1128974786197E+00/,
     4     FA(9)/ 2.1254857173540E+00/, FA(10)/2.1379218133017E+00/,
     5     FA(11)/2.1483404506064E+00/, FA(12)/2.1548934173960E+00/
C     --------------------------------------------------------------
      DATA FB(1)/ 1.5744273529551E+00/, FB(2)/ 1.5899097325063E+00/,
     1     FB(3)/ 1.6176685384410E+00/, FB(4)/ 1.6574605448620E+00/,
     2     FB(5)/ 1.7087245795822E+00/, FB(6)/ 1.7703459462057E+00/,
     3     FB(7)/ 1.8403280188791E+00/, FB(8)/ 1.9154060277115E+00/,
     4     FB(9)/ 1.9907093877047E+00/, FB(10)/2.0596975322636E+00/,
     5     FB(11)/2.1146977530430E+00/, FB(12)/2.1482986855683E+00/
C     --------------------------------------------------------------
      DATA J/(0.0, 1.0)/
      DATA LN4 /1.3862943611199/
      DATA C1  /.20264236728467/, C2/.15915494309189/
C     ---------------------------------------------------
C
C     EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
C     SMALLEST NUMBER SUCH THAT 1. + EPS .GT. 1.
C
      EPS = SPMPAR(1)
C
C     ---------------------------------------------------
      IF (L .EQ. (0.0, 0.0)) GO TO 200
      IND = 0
      BRANCH = .TRUE.
      TOL = 8.0*AMAX1(EPS, 1.E-14)
C
      AK1 = CFLECT(K)
      AL1 = CFLECT(L)
      AK = AK1
      AL = AL1
      IERR = 0
C
      X = REAL(AK)
      Y = AIMAG(AK)
      U = REAL(AL)
      V = AIMAG(AL)
      IF (AMAX1(X,ABS(Y)) .GE. 1.0/EPS) GO TO 90
      IF (AMAX1(U,ABS(V)) .GE. 1.1/EPS) GO TO 210
C
C     CHECK THAT K**2 + L**2 = 1
C
      IF (X .LT. U) GO TO 1
         T = U/X
         IF (ABS(X*X/(V*V + 1.0/(1.0 + T*T)) - 1.0) .GT. TOL) GO TO 210
         IF (ABS(Y + T*V) .GT. TOL*AMAX1(1.0, ABS(V))) GO TO 210
         GO TO 10
    1 T = X/U
      IF (ABS(U*U/(Y*Y + 1.0/(1.0 + T*T)) - 1.0) .GT. TOL) GO TO 210
      IF (ABS(V + T*Y) .GT. TOL*AMAX1(1.0, ABS(Y))) GO TO 210
C
C     USES  LOGARITHMIC SERIES WHEN CABS(AL)
C     IS LESS THAN OR EQUAL TO 0.55
C
   10 IF (U .GT. 1.42 .OR. ABS(V) .GT. 1.42) GO TO 50
   11 IF (CABS(AL) .GT. 0.55) GO TO 20
      CALL EKL(AL,CKK,CKP,CEE,CEP,GG,GP)
      IF (BRANCH) GO TO 22
      CK1 = CKK
      CK = CKP
      CE1 = CEE
      CE = CEP
      G1 = GG
      G = GP
      AK2 = AL*AL
      AL = AK
      AL2 = AL*AL
      GO TO 81
C
C     USES MACLAURIN EXPANSION WHEN THE ABSOLUTE VALUE OF
C     THE MODULUS AK IS LESS THAN OR EQUAL TO 0.55
C
   20 R = CABS(AK)
      IF (R .GT. 0.55) GO TO 30
      IF (BRANCH) GO TO 21
      CALL EKL(AK,CKP,CK1,CEP,CE1,GP,G1)
      CK = CKP
      CE = CEP
      G = GP
      AK2 = AL*AL
      AL = AK
      AL2 = AL*AL
      GO TO 81
   21 CALL EKM(AK*AK,CKK,CEE)
   22 CK = CKK
      CE = CEE
      GO TO 70
C
C     NUMERICAL QUADRATURE APPROXIMATION
C
   30 IF (IND .EQ. 0 .AND. R .GT. 1.0) GO TO 50
   31 AL2 = AL*AL
      AK2 = AK*AK
C
      F1 = (0.0, 0.0)
      E1 = (0.0, 0.0)
      DO 40 I = 1,12
         XX = X1(I)/2.
         FX = AK*XX/AL
         FXK = AK*XX
         AT = ATN(FX)
         E1 = E1 + W1(I)*FL(I)*(1.0 + AT)
   40    F1 = F1 + W1(I)*FL(I)/(AL2 + FXK*FXK)
      F2 = (0.0, 0.0)
      E2 = (0.0, 0.0)
      DO 41 I = 1,12
         XX = .25*(1.+ X2(I))
         FX = AK*XX/AL
         FXK = AK*XX
         AT = ATN(FX)
         E2 = E2 + W2(I)*FA(I)*(1.0 + AT)
   41    F2 = F2 + W2(I)*FA(I)/(AL2 + FXK*FXK)
      F3 = (0.0, 0.0)
      E3 = (0.0, 0.0)
      DO 42 I = 1,12
         XX = .25*(3.- X2(I))
         FX = AK*XX/AL
         FXK = AK*XX
         AT = ATN(FX)
         E3 = E3 + W2(I)*FB(I)*(1.0 + AT)
   42    F3 = F3 + W2(I)*FB(I)/(AL2 + FXK*FXK)
C
      CK = AL*(C1*F1 + C2*(F2 + F3))
      CE = AL*(C1*E1 + C2*(E2 + E3))
C
C     END OF NUMERICAL QUADRATURE APPROXIMATION
C
      IF (BRANCH) GO TO 70
      CK1 = CK
      CE1 = CE
      BRANCH = .TRUE.
C
C     INTERCHANGE AK AND AL
C
      AKTEMP = AK
      AK = AL
      AL = AKTEMP
      GO TO 31
C
C     USES INVERSE MODULUS TRANSFORMATION WHEN CABS(AK) IS GREATER
C     THAN 1 AND REAL(AK**2) IS GREATER THAN 0.5.
C
   50 IF (X*X .LE. Y*Y + 0.5) GO TO 60
      IND = 1
      BRANCH = .FALSE.
      AK = 1.0/AK1
      AL = CFLECT(J*AL1/AK1)
      GO TO 11
C
C     USES COMPLEMENTARY INVERSE MODULUS TRANSFORMATION WHEN CABS(AK)
C     IS GREATER THAN 1 AND REAL(AK**2) IS LESS THAN OR EQUAL TO 0.5
C
   60 IND = 2
      AK = CFLECT(J*AK1/AL1)
      AL = 1.0/AL1
      GO TO 11
C
C     RETURN IF NO TRANSFORMATIONS HAVE BEEN PERFORMED
C
   70 IF (IND .EQ. 0) RETURN
      IF (IND .EQ. 1) GO TO 80
C
C     COMPLEMENTARY INVERSE MODULUS TRANSFORMATION
C
      CK = AL*CK
      CE = CE/AL
      RETURN
C
C     INVERSE MODULUS TRANSFORMATION
C
   80 G = CE - AL2*CK
      G1 = CE1 - AK2*CK1
   81 IF (AIMAG(AK2) .GE. 0.0) GO TO 82
         CE = (G1 + J*G)/AL
         CK = AL*(CK1 - J*CK)
         RETURN
   82 CE = (G1 - J*G)/AL
      CK = AL*(CK1 + J*CK)
      RETURN
C
C     CALCULATION OF F(K) AND E(K) FOR LARGE K AND L
C
   90 IF (X .LE. ABS(Y)) GO TO 100
      IF (ABS(ABS(V/X) - 1.0) .GT. TOL) GO TO 210
      IF (ABS(U/X + Y/V) .GT. TOL) GO TO 210
      T = Y/X
      K1 = CMPLX(1.0,T)
      PHI = ATAN2(X,ABS(Y))
      R = (LN4 + 0.5*ALNREL(T*T)) + ALOG(X)
      C = 0.5*R + 0.25
      Z = CMPLX(Y,-X)
      IF (Y .GE. 0.0) GO TO 91
         R = -R
         C = -C
         Z = -Z
   91 CK = (CMPLX(PHI,R)/K1)/X
      CE = Z + (CMPLX(0.5*PHI,C)/K1)/X
      RETURN
C
  100 IF (ABS(ABS(U/Y) - 1.0) .GT. TOL) GO TO 210
      IF (ABS(X/U + V/Y) .GT. TOL) GO TO 210
      T = V/U
      L1 = CMPLX(1.0,T)
      R = (LN4 + 0.5*ALNREL(T*T)) + ALOG(U)
      PHI = ATAN2(V,U)
      CK = (CMPLX(R, PHI)/L1)/U
      CE = AL + (CMPLX(0.5*R - 0.25, 0.5*PHI)/L1)/U
      RETURN
C
C     ERROR RETURN
C
  200 IERR = 1
      RETURN
  210 IERR = 2
      RETURN
      END
      COMPLEX FUNCTION ATN(Z)
C---------------------------------------------------
C     CALCULATES COMPLEX FUNCTION ATN(Z) = Z*ATAN(Z)
C     USING DOUBLE PRECISION.
C---------------------------------------------------
      COMPLEX Z
      DOUBLE PRECISION DX, DY
      X = REAL(Z)
      Y = AIMAG(Z)
      DX = X
      DY = Y
      T = 1.D0 - DX*DX - DY*DY
      DA = -0.5*ATAN2(-2.0*X, T)
      D = (1.0 - DY)**2 + DX*DX
      DB = 0.25*ALNREL(4.0*Y/D)
      ATN1 = DA*X - DB*Y
      ATN2 = DA*Y + DB*X
      ATN = CMPLX(ATN1, ATN2)
      RETURN
      END
      SUBROUTINE EKM (K2, FK, EK)
      COMPLEX K2,FK,EK
C ----------------------------------------------------------------------
C     EKM COMPUTES THE COMPLETE ELLIPTIC INTEGRALS F(K) AND E(K) FOR
C     A GIVEN VALUE OF K2 = K**2 BY USE OF THE MACLAURIN EXPANSIONS.
C ----------------------------------------------------------------------
      COMPLEX AN,CN,S1,S2
      DATA HPI /1.5707963267949/
C ---------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
                      EPS = SPMPAR(1)
C
C ---------------
C
      TOL = AMAX1(EPS,1.E-14)
      S1 = (1.0, 0.0)
      S2 = (1.0, 0.0)
      AN = (1.0, 0.0)
      DO 10 I = 1,50
         RI = I
         C = ((RI - 0.5)/RI)**2
         AN = C*(AN*K2)
         CN = AN/(2.0*RI - 1.0)
         S1 = S1 + AN
         S2 = S2 - CN
         IF (ABS(REAL(AN)) + ABS(AIMAG(AN)) .LT. TOL) GO TO 20
   10 CONTINUE
C
   20 FK = HPI*S1
      EK = HPI*S2
      RETURN
      END
      SUBROUTINE EKL (L,FK,FL,EK,EL,GK,GL)
      COMPLEX L,L2,FK,FL,EK,EL,GK,GL
C ----------------------------------------------------------------------
C     EKL COMPUTES THE COMPLETE ELLIPTIC INTEGRALS F(K), F(L), E(K),
C     E(L) FOR A GIVEN VALUE OF L2, WHERE L2 = L**2 AND K**2 + L**2 = 1.
C     IT IS ASSUMED THAT -PI .LT. ARG(L2) .LE. PI FOR THE RESULTING
C     VALUE FOR F(K) TO BE MEANINGFUL.  THE COMBINATIONS OF FUNCTIONS
C     G(K) = E(K) - L**2*F(K) AND G(L) = E(L) - K**2*F(L) ARE ALSO
C     CALCULATED.
C ----------------------------------------------------------------------
      COMPLEX AN,CN,EN,S1,S2,S3,S4,S5,S6,S7,W
      REAL LN4
C     ------------------
      DATA HPI /1.5707963267949/
      DATA LN4 /1.3862943611199/
C ---------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
                      EPS = SPMPAR(1)
C
C ---------------
C
C            THE LOGARITHMIC EXPANSIONS ARE USED FOR F(K) AND E(K)
C            AND THE MACLAURIN EXPANSIONS FOR F(L) AND E(L)
C
      TOL = AMAX1(EPS,1.E-14)
      L2 = L*L
      S1 = (0.0, 0.0)
      S2 = (0.0, 0.0)
      S3 = (0.0, 0.0)
      S4 = (0.0, 0.0)
      S5 = (0.0, 0.0)
      S6 = (0.0, 0.0)
      S7 = (0.0, 0.0)
      AN = (1.0, 0.0)
      BN = 0.0
      DO 10 I = 1,300
         RI = I
         C = ((RI - 0.5)/RI)**2
         AN = C*(AN*L2)
         BN = BN + 1.0/(RI*(2.0*RI - 1.0))
         CN = AN/(2.0*RI - 1.0)
         DN = BN*RI/(RI - 0.5)
         EN = CN/(2.0*RI - 1.0)
         FN = RI/(RI - 0.5)
         GN = 0.5/(RI + 1.0)
         S1 = S1 + AN
         S2 = S2 + AN*BN
         S3 = S3 - CN
         S4 = S4 + AN*DN
         S5 = S5 + EN
         S6 = S6 + AN*FN
         S7 = S7 + AN*GN
         IF (ABS(REAL(AN)) + ABS(AIMAG(AN)) .LT. TOL) GO TO 20
   10 CONTINUE
   20 S1 = S1 + (1.0, 0.0)
      S3 = S3 + (1.0, 0.0)
      S5 = S5 + (1.0, 0.0)
      S7 = S7 + (0.5, 0.0)
C
C              SET W = 0.5*CLOG(16.0/L2)
C
      X = REAL(L)
      Y = AIMAG(L)
      IF (X .NE. 0.0) GO TO 30
         W = CMPLX(LN4 - ALOG(ABS(Y)), HPI)
         GO TO 50
C
   30 IF (ABS(X) .GT. ABS(Y)) GO TO 31
         U = (LN4 - 0.5*ALNREL((X/Y)**2)) - ALOG(ABS(Y))
         GO TO 40
   31 U = (LN4 - 0.5*ALNREL((Y/X)**2)) - ALOG(ABS(X))
C
   40 IF (X .GT. 0.0) GO TO 41
         W = CMPLX(U, -ATAN2(-Y,-X))
         GO TO 50
   41 W = CMPLX(U, -ATAN2(Y,X))
C
C              FINAL ASSEMBLY
C
   50 FK = W*S1 - S2
      FL = HPI*S1
      EK = W*S6 - S4 + S5
      EL = HPI*S3
      GK = -W*S7*L2 -S4 + S5 + S2*L2
      GL = HPI*S7*L2
      RETURN
      END
      SUBROUTINE ELLPI (PHI, CPHI, K, L, F, E, IERR)
C-----------------------------------------------------------------------
C
C          REAL ELLIPTIC INTEGRALS OF THE FIRST AND SECOND KINDS
C
C                        -----------------
C
C     PHI = ARGUMENT                    (0.0 .LE. PHI  .LE. PI/2)
C     CPHI = PI/2 - PHI                 (0.0 .LE. CPHI .LE. PI/2)
C     K = MODULUS                       (ABS(K) .LE. 1.0)
C     L = COMODULUS = SQRT (1 - K*K)    (ABS(L) .LE. 1.0)
C     F = ELLIPTIC INTEGRAL OF FIRST KIND = F(PHI, K)
C     E = ELLIPTIC INTEGRAL OF SECOND KIND = E(PHI, K)
C     IERR = ERROR INDICATOR (IERR = 0  IF NO ERRORS)
C-----------------------------------------------------------------------
      REAL K, L, K2, L2, LN4
C------------------------
C     LN4 = LN(4)
C     TH1 = TANH(1)
C------------------------
      DATA LN4/1.3862943611199/
      DATA TH1/.76159415595576/
C------------------------
      IF (PHI .LT. 0.0 .OR. CPHI .LT. 0.0) GO TO 100
      IF (ABS(K) .GT. 1.0 .OR. ABS(L) .GT. 1.0) GO TO 110
      IERR = 0
      IF (PHI .NE. 0.0) GO TO 10
         F = 0.0
         E = 0.0
         RETURN
C
   10 IF (PHI .LT. 0.79) GO TO 11
         SN = COS(CPHI)
         CN = SIN(CPHI)
         GO TO 20
   11 SN = SIN(PHI)
      CN = COS(PHI)
C
   20 K2 = K*K
      L2 = L*L
      SS = SN*SN
      PX = ABS(K*SN)
      QX = ABS(K*CN)
      IF (PX .GE. TH1) GO TO 50
C
C     SERIES EXPANSION FOR ABS(K*SIN(PHI)) .LE. TANH(1)
C
      PN = 1.0
      QN = 2.0
      AN = PHI
      HN = 1.0
      S1 = 0.0
      S2 = 0.0
      TR = PHI*SS
      TS = SN*CN
C
   30 AN = (PN*AN - TS)/QN
      R  = K2*HN/QN
      S2 = S2 + R*AN
      HN = PN*R
      S0 = S1
      S1 = S1 + HN*AN
      IF (ABS(TR) .LT. ABS(AN)) GO TO 40
      IF (ABS(S1) .LE. ABS(S0)) GO TO 40
      PN = QN + 1.0
      QN = PN + 1.0
      TR = SS*TR
      TS = SS*TS
      GO TO 30
C
   40 F = PHI + S1
      E = PHI - S2
      RETURN
C
C     SERIES EXPANSION FOR ABS(K*SIN(PHI)) .GT. TANH(1)
C
   50 R = CPABS(L,QX)
      IF (R .EQ. 0.0) GO TO 120
      R2 = R*R
      SI = 1.0
      SJ = 1.0
      SK = 0.0
      RM = 0.0
      RN = 0.0
      S1 = 0.0
      S2 = 0.0
      S3 = 0.0
      S4 = 0.0
      TD = QX*R
      DN = 2.0
      GO TO 70
C
   60 SI = RI
      SJ = RJ
      SK = RK
      DN = DN + 2.0
      TD = R2*TD
   70 PN = (DN - 1.0)/DN
      QN = (DN + 1.0)/(DN + 2.0)
      RI = PN*SI
      RJ = PN*PN*L2*SJ
      RK = SK + 2.0/(DN*(DN - 1.0))
      R0 = TD/DN
      RM = QN*QN*L2*(RM - R0*RI)
      RN = PN*QN*L2*(RN - R0*SI)
      D1 = RJ
      D2 = QN*RJ
      D3 = RM - RJ*RK
      D4 = RN - PN*L2*SJ*RK + L2*SJ/(DN*DN)
      R0 = S3
      S1 = S1 + D1
      S2 = S2 + D2
      S3 = S3 + D3
      S4 = S4 + D4
      IF (S3 .LT. R0) GO TO 60
C
      W = 1.0 + PX
      P = LN4 - ALOG(R + QX)
      T1 = (1.0 + S1)*P + QX/R*ALNREL(-0.5*R2/W)
      T2 = (0.5 + S2)*L2*P + (1.0 - QX*R/W)
      F = T1 + S3
      E = T2 + S4
      RETURN
C
C     ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      RETURN
  120 IERR = 3
      RETURN
      END
      SUBROUTINE DELLPI (PHI, CPHI, K, L, F, E, IERR)
C-----------------------------------------------------------------------
C
C                  DOUBLE PRECISION COMPUTATION OF THE
C          REAL ELLIPTIC INTEGRALS OF THE FIRST AND SECOND KINDS
C
C                        -----------------
C
C     PHI = ARGUMENT                    (0.0 .LE. PHI  .LE. PI/2)
C     CPHI = PI/2 - PHI                 (0.0 .LE. CPHI .LE. PI/2)
C     K = MODULUS                       (DABS(K) .LE. 1.0)
C     L = COMODULUS = SQRT (1 - K*K)    (DABS(L) .LE. 1.0)
C     F = ELLIPTIC INTEGRAL OF FIRST KIND = F(PHI, K)
C     E = ELLIPTIC INTEGRAL OF SECOND KIND = E(PHI, K)
C     IERR = ERROR INDICATOR (IERR = 0  IF NO ERRORS)
C-----------------------------------------------------------------------
      DOUBLE PRECISION PHI, CPHI, K, L, F, E
      DOUBLE PRECISION AN, CN, DN, D1, D2, D3, D4, HN, K2, L2, LN4,
     *                 P, PN, PX, QN, QX, R, RI, RJ, RK, RM, RN, R0,
     *                 R2, SI, SJ, SK, SN, SS, S0, S1, S2, S3, S4,
     *                 TD, TH1, TR, TS, T1, T2, W
      DOUBLE PRECISION DLNREL, DCPABS
C------------------------
C     LN4 = LN(4)
C     TH1 = TANH(1)
C------------------------
      DATA LN4 /.1386294361119890618834464242916353136151D+01/
      DATA TH1 /.7615941559557648881194582826047935904128D+00/
C------------------------
      IF (PHI .LT. 0.D0 .OR. CPHI .LT. 0.D0) GO TO 100
      IF (DABS(K) .GT. 1.D0 .OR. DABS(L) .GT. 1.D0) GO TO 110
      IERR = 0
      IF (PHI .NE. 0.D0) GO TO 10
         F = 0.D0
         E = 0.D0
         RETURN
C
   10 IF (PHI .LT. 0.79D0) GO TO 11
         SN = DCOS(CPHI)
         CN = DSIN(CPHI)
         GO TO 20
   11 SN = DSIN(PHI)
      CN = DCOS(PHI)
C
   20 K2 = K*K
      L2 = L*L
      SS = SN*SN
      PX = DABS(K*SN)
      QX = DABS(K*CN)
      IF (PX .GE. TH1) GO TO 50
C
C     SERIES EXPANSION FOR ABS(K*SIN(PHI)) .LE. TANH(1)
C
      PN = 1.D0
      QN = 2.D0
      AN = PHI
      HN = 1.D0
      S1 = 0.D0
      S2 = 0.D0
      TR = PHI*SS
      TS = SN*CN
C
   30 AN = (PN*AN - TS)/QN
      R  = K2*HN/QN
      S2 = S2 + R*AN
      HN = PN*R
      S0 = S1
      S1 = S1 + HN*AN
      IF (DABS(TR) .LT. DABS(AN)) GO TO 40
      IF (DABS(S1) .LE. DABS(S0)) GO TO 40
      PN = QN + 1.D0
      QN = PN + 1.D0
      TR = SS*TR
      TS = SS*TS
      GO TO 30
C
   40 F = PHI + S1
      E = PHI - S2
      RETURN
C
C     SERIES EXPANSION FOR ABS(K*SIN(PHI)) .GT. TANH(1)
C
   50 R = DCPABS(L,QX)
      IF (R .EQ. 0.D0) GO TO 120
      R2 = R*R
      SI = 1.D0
      SJ = 1.D0
      SK = 0.D0
      RM = 0.D0
      RN = 0.D0
      S1 = 0.D0
      S2 = 0.D0
      S3 = 0.D0
      S4 = 0.D0
      TD = QX*R
      DN = 2.D0
      GO TO 70
C
   60 SI = RI
      SJ = RJ
      SK = RK
      DN = DN + 2.D0
      TD = R2*TD
   70 PN = (DN - 1.D0)/DN
      QN = (DN + 1.D0)/(DN + 2.D0)
      RI = PN*SI
      RJ = PN*PN*L2*SJ
      RK = SK + 2.D0/(DN*(DN - 1.D0))
      R0 = TD/DN
      RM = QN*QN*L2*(RM - R0*RI)
      RN = PN*QN*L2*(RN - R0*SI)
      D1 = RJ
      D2 = QN*RJ
      D3 = RM - RJ*RK
      D4 = RN - PN*L2*SJ*RK + L2*SJ/(DN*DN)
      R0 = S3
      S1 = S1 + D1
      S2 = S2 + D2
      S3 = S3 + D3
      S4 = S4 + D4
      IF (S3 .LT. R0) GO TO 60
C
      W = 1.D0 + PX
      P = LN4 - DLOG(R + QX)
      T1 = (1.D0 + S1)*P + QX/R*DLNREL(-0.5D0*R2/W)
      T2 = (0.5D0 + S2)*L2*P + (1.D0 - QX*R/W)
      F = T1 + S3
      E = T2 + S4
      RETURN
C
C     ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      RETURN
  120 IERR = 3
      RETURN
      END
      SUBROUTINE EPI (PHI, CPHI, K2, L2, N, M, P, IERR)
C-----------------------------------------------------------------------
C             REAL ELLIPTIC INTEGRAL OF THE THIRD KIND
C-----------------------------------------------------------------------
      REAL PHI, CPHI, K2, L2, N, M, P
      REAL A, B, C, EPS, PIHALF, R, RF, S, S2, TOL
      REAL SPMPAR
C---------------------
      DATA PIHALF /1.5707963267948966192/
C-----------------------------------------------------------------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1.0 + EPS .GT. 1.0.
C
                      EPS = SPMPAR(1)
C
C-----------------------------------------------------------------------
      TOL = 4.0 * EPS
      IF (AMIN1(PHI,CPHI) .LT. 0.0) GO TO 100
      IF (ABS((PHI + CPHI) - PIHALF) .GT. TOL * PIHALF) GO TO 100
      IF (ABS(N) .GT. 1.0) GO TO 110
      IF (K2 .LT. 0.0 .OR. L2 .LT. 0.0) GO TO 120
      IF (ABS((K2 + L2) - 1.0) .GT. TOL) GO TO 120
C
      IF (PHI .LT. 0.79) GO TO 10
          S = COS(CPHI)
          C = SIN(CPHI)
          GO TO 11
   10 S = SIN(PHI)
      C = COS(PHI)
   11 A = C*C
      B = L2 + K2*A
      S2 = S*S
C
      IF (N .GT. 0.0) GO TO 20
          R = 1.0 - N*S2
          GO TO 30
   20 IF (M .LT. 0.0 .OR. M .GT. 1.0) GO TO 110
      IF (ABS((M + N) - 1.0) .GT. TOL) GO TO 110
      R = M + N*A
C
   30 CALL RJVAL (A, B, 1.0, R, P, IERR)
      IF (IERR .NE. 0) GO TO 130
      P = P * (S * S2) * N/3.0
      CALL RFVAL (A, B, 1.0, RF, IERR)
      P = P + S * RF
      RETURN
C
C     ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      RETURN
  120 IERR = 3
      RETURN
  130 IERR = 4
      RETURN
      END
      SUBROUTINE DEPI (PHI, CPHI, K2, L2, N, M, P, IERR)
C-----------------------------------------------------------------------
C               DOUBLE PRECISION COMPUTATION OF THE
C             REAL ELLIPTIC INTEGRAL OF THE THIRD KIND
C-----------------------------------------------------------------------
      DOUBLE PRECISION PHI, CPHI, K2, L2, N, M, P
      DOUBLE PRECISION A, B, C, EPS, PIHALF, R, RF, S, S2, TOL
      DOUBLE PRECISION DPMPAR
C---------------------
      DATA PIHALF /1.570796326794896619231321691639751442099D0/
C-----------------------------------------------------------------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1.D0 + EPS .GT. 1.D0.
C
                      EPS = DPMPAR(1)
C
C-----------------------------------------------------------------------
      TOL = 4.D0 * EPS
      IF (DMIN1(PHI,CPHI) .LT. 0.D0) GO TO 100
      IF (DABS((PHI + CPHI) - PIHALF) .GT. TOL * PIHALF) GO TO 100
      IF (DABS(N) .GT. 1.D0) GO TO 110
      IF (K2 .LT. 0.D0 .OR. L2 .LT. 0.D0) GO TO 120
      IF (DABS((K2 + L2) - 1.D0) .GT. TOL) GO TO 120
C
      IF (PHI .LT. 0.79D0) GO TO 10
          S = DCOS(CPHI)
          C = DSIN(CPHI)
          GO TO 11
   10 S = DSIN(PHI)
      C = DCOS(PHI)
   11 A = C*C
      B = L2 + K2*A
      S2 = S*S
C
      IF (N .GT. 0.D0) GO TO 20
          R = 1.D0 - N*S2
          GO TO 30
   20 IF (M .LT. 0.D0 .OR. M .GT. 1.D0) GO TO 110
      IF (DABS((M + N) - 1.D0) .GT. TOL) GO TO 110
      R = M + N*A
C
   30 CALL DRJVAL (A, B, 1.D0, R, P, IERR)
      IF (IERR .NE. 0) GO TO 130
      P = P * (S * S2) * N/3.D0
      CALL DRFVAL (A, B, 1.D0, RF, IERR)
      P = P + S * RF
      RETURN
C
C     ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      RETURN
  120 IERR = 3
      RETURN
  130 IERR = 4
      RETURN
      END
      SUBROUTINE RFVAL (X, Y, Z, RF, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INCOMPLETE ELLIPTIC INTEGRAL
C          OF THE FIRST KIND
C
C          RF(X,Y,Z) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                                -1/2     -1/2     -1/2
C                      (1/2)(T+X)    (T+Y)    (T+Z)    DT,
C
C          WHERE X, Y, AND Z ARE NONNEGATIVE AND AT MOST ONE OF THEM
C          IS ZERO.  IF ONE OF THEM IS ZERO, THE INTEGRAL IS COMPLETE.
C          THE DUPLICATION THEOREM IS ITERATED UNTIL THE VARIABLES ARE
C          NEARLY EQUAL, AND THE FUNCTION IS THEN EXPANDED IN TAYLOR
C          SERIES TO FIFTH ORDER.  REFERENCE. B. C. CARLSON, COMPUTING
C          ELLIPTIC INTEGRALS BY DUPLICATION, NUMER. MATH. 33 (1979),
C          1-16.  CODED BY B. C. CARLSON AND ELAINE M. NOTIS, AMES
C          LABORATORY-DOE, IOWA STATE UNIVERSITY, AMES, IOWA 50011.
C          MARCH 1, 1980. MODIFIED BY A.H. MORRIS (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      REAL RF,C1,C2,C3,E2,E3,EPSLON,ERRTOL,LAMDA
      REAL LOLIM,MU,S,UPLIM,X,XN,XNDEV,XNROOT
      REAL Y,YN,YNDEV,YNROOT,Z,ZN,ZNDEV,ZNROOT
      REAL SPMPAR
C-----------------------------------------------------------------------
C
C          INPUT ...
C
C          X, Y, AND Z ARE THE VARIABLES IN THE INTEGRAL RF(X,Y,Z).
C
C          OUTPUT ...
C
C          RF IS THE VALUE OF THE INCOMPLETE ELLIPTIC INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X, Y, OR Z IS NEGATIVE.
C               IERR = 2  X+Y, X+Z, OR Y+Z IS TOO SMALL.
C               IERR = 3  X, Y, OR Z IS TOO LARGE.
C
C-----------------------------------------------------------------------
C
C          MACHINE DEPENDENT PARAMETERS ...
C
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN THE MACHINE MINIMUM MULTIPLIED BY 5.
C          UPLIM IS NOT GREATER THAN THE MACHINE MAXIMUM DIVIDED BY 5.
C
                      LOLIM = 5.0 * SPMPAR(2)
                      UPLIM = 0.2 * SPMPAR(3)
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
C          ERRTOL ** 6 / (4 * (1 - ERRTOL)).
C
               ERRTOL = (3.6 * SPMPAR(1))**(1.0/6.0)
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (AMIN1(X,Y,Z) .LT. 0.0) GO TO 100
      IF (AMIN1(X+Y,X+Z,Y+Z) .LT. LOLIM) GO TO 110
      IF (AMAX1(X,Y,Z) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
      ZN = Z
C
   10 MU = (XN + YN + ZN) / 3.0
      XNDEV = 2.0 - (MU + XN) / MU
      YNDEV = 2.0 - (MU + YN) / MU
      ZNDEV = 2.0 - (MU + ZN) / MU
      EPSLON = AMAX1(ABS(XNDEV),ABS(YNDEV),ABS(ZNDEV))
      IF (EPSLON .LT. ERRTOL) GO TO 20
      XNROOT = SQRT(XN)
      YNROOT = SQRT(YN)
      ZNROOT = SQRT(ZN)
      LAMDA = XNROOT * (YNROOT + ZNROOT) + YNROOT * ZNROOT
      XN = (XN + LAMDA) * 0.25
      YN = (YN + LAMDA) * 0.25
      ZN = (ZN + LAMDA) * 0.25
      GO TO 10
C
   20 C1 = 1.0 / 24.0
      C2 = 3.0 / 44.0
      C3 = 1.0 / 14.0
      E2 = XNDEV * YNDEV - ZNDEV * ZNDEV
      E3 = XNDEV * YNDEV * ZNDEV
      S = 1.0 + (C1 * E2 - 0.1 - C2 * E3) * E2 + C3 * E3
      RF = S / SQRT(MU)
      RETURN
C
C                      ERROR RETURN
C
  100 RF = 0.0
      IERR = 1
      RETURN
  110 RF = 0.0
      IERR = 2
      RETURN
  120 RF = 0.0
      IERR = 3
      RETURN
      END
      SUBROUTINE DRFVAL (X, Y, Z, RF, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INCOMPLETE ELLIPTIC INTEGRAL
C          OF THE FIRST KIND
C
C          RF(X,Y,Z) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                                -1/2     -1/2     -1/2
C                      (1/2)(T+X)    (T+Y)    (T+Z)    DT,
C
C          WHERE X, Y, AND Z ARE NONNEGATIVE AND AT MOST ONE OF THEM
C          IS ZERO.  IF ONE OF THEM IS ZERO, THE INTEGRAL IS COMPLETE.
C          THE DUPLICATION THEOREM IS ITERATED UNTIL THE VARIABLES ARE
C          NEARLY EQUAL, AND THE FUNCTION IS THEN EXPANDED IN TAYLOR
C          SERIES TO FIFTH ORDER.  REFERENCE. B. C. CARLSON, COMPUTING
C          ELLIPTIC INTEGRALS BY DUPLICATION, NUMER. MATH. 33 (1979),
C          1-16.  CODED BY B. C. CARLSON AND ELAINE M. NOTIS, AMES
C          LABORATORY-DOE, IOWA STATE UNIVERSITY, AMES, IOWA 50011.
C          MARCH 1, 1980. MODIFIED BY A.H. MORRIS (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      DOUBLE PRECISION RF,C1,C2,C3,E2,E3,EPSLON,ERRTOL,LAMDA
      DOUBLE PRECISION LOLIM,MU,S,UPLIM,X,XN,XNDEV,XNROOT
      DOUBLE PRECISION Y,YN,YNDEV,YNROOT,Z,ZN,ZNDEV,ZNROOT
      DOUBLE PRECISION DPMPAR
C-----------------------------------------------------------------------
C
C          INPUT ...
C
C          X, Y, AND Z ARE THE VARIABLES IN THE INTEGRAL RF(X,Y,Z).
C
C          OUTPUT ...
C
C          RF IS THE VALUE OF THE INCOMPLETE ELLIPTIC INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X, Y, OR Z IS NEGATIVE.
C               IERR = 2  X+Y, X+Z, OR Y+Z IS TOO SMALL.
C               IERR = 3  X, Y, OR Z IS TOO LARGE.
C
C-----------------------------------------------------------------------
C
C          MACHINE DEPENDENT PARAMETERS ...
C
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN THE MACHINE MINIMUM MULTIPLIED BY 5.
C          UPLIM IS NOT GREATER THAN THE MACHINE MAXIMUM DIVIDED BY 5.
C
                      LOLIM = 5.0D0 * DPMPAR(2)
                      UPLIM = 0.2D0 * DPMPAR(3)
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
C          ERRTOL ** 6 / (4 * (1 - ERRTOL)).
C
             ERRTOL = (3.6 * SNGL(DPMPAR(1)))**(1.0/6.0)
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (DMIN1(X,Y,Z) .LT. 0.D0) GO TO 100
      IF (DMIN1(X+Y,X+Z,Y+Z) .LT. LOLIM) GO TO 110
      IF (DMAX1(X,Y,Z) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
      ZN = Z
C
   10 MU = (XN + YN + ZN) / 3.D0
      XNDEV = 2.D0 - (MU + XN) / MU
      YNDEV = 2.D0 - (MU + YN) / MU
      ZNDEV = 2.D0 - (MU + ZN) / MU
      EPSLON = DMAX1(DABS(XNDEV),DABS(YNDEV),DABS(ZNDEV))
      IF (EPSLON .LT. ERRTOL) GO TO 20
      XNROOT = DSQRT(XN)
      YNROOT = DSQRT(YN)
      ZNROOT = DSQRT(ZN)
      LAMDA = XNROOT * (YNROOT + ZNROOT) + YNROOT * ZNROOT
      XN = (XN + LAMDA) * 0.25D0
      YN = (YN + LAMDA) * 0.25D0
      ZN = (ZN + LAMDA) * 0.25D0
      GO TO 10
C
   20 C1 = 1.D0 / 24.D0
      C2 = 3.D0 / 44.D0
      C3 = 1.D0 / 14.D0
      E2 = XNDEV * YNDEV - ZNDEV * ZNDEV
      E3 = XNDEV * YNDEV * ZNDEV
      S = 1.D0 + (C1 * E2 - 0.1D0 - C2 * E3) * E2 + C3 * E3
      RF = S / DSQRT(MU)
      RETURN
C
C                      ERROR RETURN
C
  100 RF = 0.D0
      IERR = 1
      RETURN
  110 RF = 0.D0
      IERR = 2
      RETURN
  120 RF = 0.D0
      IERR = 3
      RETURN
      END
      SUBROUTINE RDVAL (X, Y, Z, RD, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INCOMPLETE ELLIPTIC INTEGRAL
C          OF THE SECOND KIND
C
C          RD(X,Y,Z) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                                -1/2     -1/2     -3/2
C                      (3/2)(T+X)    (T+Y)    (T+Z)    DT,
C
C          WHERE X AND Y ARE NONNEGATIVE, X + Y IS POSITIVE, AND Z IS
C          POSITIVE.  IF X OR Y IS ZERO, THE INTEGRAL IS COMPLETE.
C          THE DUPLICATION THEOREM IS ITERATED UNTIL THE VARIABLES ARE
C          NEARLY EQUAL, AND THE FUNCTION IS THEN EXPANDED IN TAYLOR
C          SERIES TO FIFTH ORDER.  REFERENCE. B. C. CARLSON, COMPUTING
C          ELLIPTIC INTEGRALS BY DUPLICATION, NUMER. MATH. 33 (1979),
C          1-16.  CODED BY B. C. CARLSON AND ELAINE M. NOTIS, AMES
C          LABORATORY-DOE, IOWA STATE UNIVERSITY, AMES, IOWA 50011.
C          MARCH 1, 1980. MODIFIED BY A.H. MORRIS (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      REAL RD,C1,C2,C3,C4,EA,EB,EC,ED,EF,EPSLON,ERRTOL,LAMDA
      REAL LOLIM,MU,POWER4,SIGMA,S1,S2,UPLIM,X,XN,XNDEV
      REAL XNROOT,Y,YN,YNDEV,YNROOT,Z,ZN,ZNDEV,ZNROOT
      REAL SPMPAR
C-----------------------------------------------------------------------
C
C          INPUT ...
C
C          X, Y, AND Z ARE THE VARIABLES IN THE INTEGRAL RD(X,Y,Z).
C
C          OUTPUT ...
C
C          RD IS THE VALUE OF THE INCOMPLETE ELLIPTIC INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X, Y, OR Z IS NEGATIVE.
C               IERR = 2  X+Y OR Z IS TOO SMALL.
C               IERR = 3  X, Y, OR Z IS TOO LARGE.
C
C-----------------------------------------------------------------------
C
C          MACHINE DEPENDENT PARAMETERS ...
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
C          3 * ERRTOL ** 6 / (1 - ERRTOL) ** 3/2.
C
              ERRTOL = (.28 * SPMPAR(1)) ** (1.0/6.0)
C
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN 2 / (MACHINE MAXIMUM) ** (2/3).
C          UPLIM IS NOT GREATER THAN (0.1 * ERRTOL / MACHINE
C          MINIMUM) ** (2/3).
C
              MU = -2.0/3.0
              LOLIM = 2.0001 * SPMPAR(3) ** MU
              UPLIM = (10.0 * SPMPAR(2) / ERRTOL) ** MU
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (AMIN1(X,Y,Z) .LT. 0.0) GO TO 100
      IF (AMIN1(X+Y,Z) .LT. LOLIM) GO TO 110
      IF (AMAX1(X,Y,Z) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
      ZN = Z
      SIGMA = 0.0
      POWER4 = 1.0
C
   10 MU = (XN + YN + 3.0 * ZN) * 0.2
      XNDEV = (MU - XN) / MU
      YNDEV = (MU - YN) / MU
      ZNDEV = (MU - ZN) / MU
      EPSLON = AMAX1(ABS(XNDEV),ABS(YNDEV),ABS(ZNDEV))
      IF (EPSLON .LT. ERRTOL) GO TO 20
      XNROOT = SQRT(XN)
      YNROOT = SQRT(YN)
      ZNROOT = SQRT(ZN)
      LAMDA = XNROOT * (YNROOT + ZNROOT) + YNROOT * ZNROOT
      SIGMA = SIGMA + POWER4 / (ZNROOT * (ZN + LAMDA))
      POWER4 = POWER4 * 0.25
      XN = (XN + LAMDA) * 0.25
      YN = (YN + LAMDA) * 0.25
      ZN = (ZN + LAMDA) * 0.25
      GO TO 10
C
   20 C1 = 3.0 / 14.0
      C2 = 1.0 / 6.0
      C3 = 9.0 / 22.0
      C4 = 3.0 / 26.0
      EA = XNDEV * YNDEV
      EB = ZNDEV * ZNDEV
      EC = EA - EB
      ED = EA - 6.0 * EB
      EF = ED + EC + EC
      S1 = ED * (- C1 + 0.25 * C3 * ED - 1.5 * C4 * ZNDEV * EF)
      S2 = ZNDEV * (C2 * EF + ZNDEV * (- C3 * EC + ZNDEV * C4 * EA))
      RD = 3.0 * SIGMA + POWER4 * (1.0 + S1 + S2) / (MU * SQRT(MU))
      RETURN
C
C                        ERROR RETURN
C
  100 RD = 0.0
      IERR = 1
      RETURN
  110 RD = 0.0
      IERR = 2
      RETURN
  120 RD = 0.0
      IERR = 3
      RETURN
      END
      SUBROUTINE DRDVAL (X, Y, Z, RD, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INCOMPLETE ELLIPTIC INTEGRAL
C          OF THE SECOND KIND
C
C          RD(X,Y,Z) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                                -1/2     -1/2     -3/2
C                      (3/2)(T+X)    (T+Y)    (T+Z)    DT,
C
C          WHERE X AND Y ARE NONNEGATIVE, X + Y IS POSITIVE, AND Z IS
C          POSITIVE.  IF X OR Y IS ZERO, THE INTEGRAL IS COMPLETE.
C          THE DUPLICATION THEOREM IS ITERATED UNTIL THE VARIABLES ARE
C          NEARLY EQUAL, AND THE FUNCTION IS THEN EXPANDED IN TAYLOR
C          SERIES TO FIFTH ORDER.  REFERENCE. B. C. CARLSON, COMPUTING
C          ELLIPTIC INTEGRALS BY DUPLICATION, NUMER. MATH. 33 (1979),
C          1-16.  CODED BY B. C. CARLSON AND ELAINE M. NOTIS, AMES
C          LABORATORY-DOE, IOWA STATE UNIVERSITY, AMES, IOWA 50011.
C          MARCH 1, 1980. MODIFIED BY A.H. MORRIS (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      DOUBLE PRECISION RD,C1,C2,C3,C4,EA,EB,EC,ED,EF,EPSLON,ERRTOL,LAMDA
      DOUBLE PRECISION LOLIM,MU,POWER4,SIGMA,S1,S2,UPLIM,X,XN,XNDEV
      DOUBLE PRECISION XNROOT,Y,YN,YNDEV,YNROOT,Z,ZN,ZNDEV,ZNROOT
      DOUBLE PRECISION DPMPAR
C-----------------------------------------------------------------------
C
C          INPUT ...
C
C          X, Y, AND Z ARE THE VARIABLES IN THE INTEGRAL RD(X,Y,Z).
C
C          OUTPUT ...
C
C          RD IS THE VALUE OF THE INCOMPLETE ELLIPTIC INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X, Y, OR Z IS NEGATIVE.
C               IERR = 2  X+Y OR Z IS TOO SMALL.
C               IERR = 3  X, Y, OR Z IS TOO LARGE.
C
C-----------------------------------------------------------------------
C
C          MACHINE DEPENDENT PARAMETERS ...
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
C          3 * ERRTOL ** 6 / (1 - ERRTOL) ** 3/2.
C
              ERRTOL = (.28 * SNGL(DPMPAR(1)))**(1.0/6.0)
C
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN 2 / (MACHINE MAXIMUM) ** (2/3).
C          UPLIM IS NOT GREATER THAN (0.1 * ERRTOL / MACHINE
C          MINIMUM) ** (2/3).
C
              MU = -2.D0/3.D0
              LOLIM = 2.00000000001D0 * DPMPAR(3) ** MU
              UPLIM = (10.D0 * DPMPAR(2) / ERRTOL) ** MU
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (DMIN1(X,Y,Z) .LT. 0.D0) GO TO 100
      IF (DMIN1(X+Y,Z) .LT. LOLIM) GO TO 110
      IF (DMAX1(X,Y,Z) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
      ZN = Z
      SIGMA = 0.D0
      POWER4 = 1.D0
C
   10 MU = (XN + YN + 3.D0 * ZN) * 0.2D0
      XNDEV = (MU - XN) / MU
      YNDEV = (MU - YN) / MU
      ZNDEV = (MU - ZN) / MU
      EPSLON = DMAX1(DABS(XNDEV),DABS(YNDEV),DABS(ZNDEV))
      IF (EPSLON .LT. ERRTOL) GO TO 20
      XNROOT = DSQRT(XN)
      YNROOT = DSQRT(YN)
      ZNROOT = DSQRT(ZN)
      LAMDA = XNROOT * (YNROOT + ZNROOT) + YNROOT * ZNROOT
      SIGMA = SIGMA + POWER4 / (ZNROOT * (ZN + LAMDA))
      POWER4 = POWER4 * 0.25D0
      XN = (XN + LAMDA) * 0.25D0
      YN = (YN + LAMDA) * 0.25D0
      ZN = (ZN + LAMDA) * 0.25D0
      GO TO 10
C
   20 C1 = 3.D0 / 14.D0
      C2 = 1.D0 / 6.D0
      C3 = 9.D0 / 22.D0
      C4 = 3.D0 / 26.D0
      EA = XNDEV * YNDEV
      EB = ZNDEV * ZNDEV
      EC = EA - EB
      ED = EA - 6.D0 * EB
      EF = ED + EC + EC
      S1 = ED * (- C1 + 0.25D0 * C3 * ED - 1.5D0 * C4 * ZNDEV * EF)
      S2 = ZNDEV * (C2 * EF + ZNDEV * (- C3 * EC + ZNDEV * C4 * EA))
      RD = 3.D0 * SIGMA + POWER4 * (1.D0 + S1 + S2) / (MU * DSQRT(MU))
      RETURN
C
C                        ERROR RETURN
C
  100 RD = 0.D0
      IERR = 1
      RETURN
  110 RD = 0.D0
      IERR = 2
      RETURN
  120 RD = 0.D0
      IERR = 3
      RETURN
      END
      SUBROUTINE RJVAL (X, Y, Z, P, RJ, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INCOMPLETE ELLIPTIC INTEGRAL
C          OF THE THIRD KIND
C
C          RJ(X,Y,Z,P) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                                  -1/2     -1/2     -1/2     -1
C                        (3/2)(T+X)    (T+Y)    (T+Z)    (T+P)  DT,
C
C          WHERE X, Y, AND Z ARE NONNEGATIVE, AT MOST ONE OF THEM IS
C          ZERO, AND P IS POSITIVE.  IF X OR Y OR Z IS ZERO, THE
C          INTEGRAL IS COMPLETE.  THE DUPLICATION THEOREM IS ITERATED
C          UNTIL THE VARIABLES ARE NEARLY EQUAL, AND THE FUNCTION IS
C          THEN EXPANDED IN TAYLOR SERIES TO FIFTH ORDER.  REFERENCE.
C          B. C. CARLSON, COMPUTING ELLIPTIC INTEGRALS BY DUPLICATION,
C          NUMER. MATH. 33 (1979), 1-16.  CODED BY B. C. CARLSON AND
C          ELAINE M. NOTIS, AMES LABORATORY-DOE, IOWA STATE UNIVERSITY,
C          AMES, IOWA 50011.  MARCH 1, 1980. MODIFIED BY A.H. MORRIS
C          (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      REAL RJ,RC,ALFA,BETA,C1,C2,C3,C4,EA,EB,EC,E2,E3
      REAL EPSLON,ERRTOL,ETOLRC,LAMDA,LOLIM,MU,P,PN,PNDEV
      REAL POWER4,SIGMA,S1,S2,S3,UPLIM,X,XN,XNDEV
      REAL XNROOT,Y,YN,YNDEV,YNROOT,Z,ZN,ZNDEV,ZNROOT
      REAL SPMPAR
C-----------------------------------------------------------------------
C
C          INPUT ...
C
C          X, Y, Z, AND P ARE THE VARIABLES IN THE INTEGRAL RJ(X,Y,Z,P).
C
C          OUTPUT ...
C
C          RJ IS THE VALUE OF THE INCOMPLETE ELLIPTIC INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X, Y, Z, OR P IS NEGATIVE.
C               IERR = 2  X+Y, X+Z, Y+Z, OR P IS TOO SMALL.
C               IERR = 3  X, Y, Z, OR P IS TOO LARGE.
C
C-----------------------------------------------------------------------
C
C          MACHINE DEPENDENT PARAMETERS ...
C
C          RC IS A FUNCTION COMPUTED BY THE SUBROUTINE RCVAL1.
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN THE CUBE ROOT OF THE VALUE
C          OF LOLIM USED IN THE CODE FOR RC, AND
C          UPLIM IS NOT GREATER THAN 0.3 TIMES THE CUBE ROOT OF
C          THE VALUE OF UPLIM USED IN THE CODE FOR RC.
C
               MU = 1.0/3.0
               LOLIM = 1.0001 * (5.0 * SPMPAR(2))**MU
               UPLIM = .29999 * (0.2 * SPMPAR(3))**MU
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE. THE
C          RELATIVE ERROR DUE TO TRUNCATION OF THE SERIES FOR RJ
C          IS LESS THAN 3 * ERRTOL ** 6 / (1 - ERRTOL) ** 3/2.
C          AN ERROR TOLERANCE (ETOLRC) WILL BE PASSED TO THE CODE FOR
C          RC TO MAKE THE TRUNCATION ERROR FOR RC LESS THAN FOR RJ.
C
               ERRTOL = (.28 * SPMPAR(1))**(1.0/6.0)
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (AMIN1(X,Y,Z,P) .LT. 0.0) GO TO 100
      IF (AMIN1(X+Y,X+Z,Y+Z,P) .LT. LOLIM) GO TO 110
      IF (AMAX1(X,Y,Z,P) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
      ZN = Z
      PN = P
      SIGMA = 0.0
      POWER4 = 1.0
      ETOLRC = 0.5 * ERRTOL
C
   10 MU = (XN + YN + ZN + PN + PN) * 0.2
      XNDEV = (MU - XN) / MU
      YNDEV = (MU - YN) / MU
      ZNDEV = (MU - ZN) / MU
      PNDEV = (MU - PN) / MU
      EPSLON = AMAX1(ABS(XNDEV),ABS(YNDEV),ABS(ZNDEV),ABS(PNDEV))
      IF (EPSLON .LT. ERRTOL) GO TO 20
      XNROOT = SQRT(XN)
      YNROOT = SQRT(YN)
      ZNROOT = SQRT(ZN)
      LAMDA = XNROOT * (YNROOT + ZNROOT) + YNROOT * ZNROOT
      ALFA = PN * (XNROOT + YNROOT + ZNROOT) + XNROOT * YNROOT * ZNROOT
      ALFA = ALFA * ALFA
      BETA = PN * (PN + LAMDA) * (PN + LAMDA)
      CALL RCVAL1 (ALFA, BETA, ETOLRC, RC, IERR)
      IF (IERR .NE. 0) RETURN
      SIGMA = SIGMA + POWER4 * RC
      POWER4 = POWER4 * 0.25
      XN = (XN + LAMDA) * 0.25
      YN = (YN + LAMDA) * 0.25
      ZN = (ZN + LAMDA) * 0.25
      PN = (PN + LAMDA) * 0.25
      GO TO 10
C
   20 C1 = 3.0 / 14.0
      C2 = 1.0 / 3.0
      C3 = 3.0 / 22.0
      C4 = 3.0 / 26.0
      EA = XNDEV * (YNDEV + ZNDEV) + YNDEV * ZNDEV
      EB = XNDEV * YNDEV * ZNDEV
      EC = PNDEV * PNDEV
      E2 = EA - 3.0 * EC
      E3 = EB + 2.0 * PNDEV * (EA - EC)
      S1 = 1.0 + E2 * (-C1 + 0.75 * C3 * E2 - 1.5 * C4 * E3)
      S2 = EB * (0.5 * C2 + PNDEV * (- C3 - C3 + PNDEV * C4))
      S3 = PNDEV * EA * (C2 - PNDEV * C3) - C2 * PNDEV * EC
      RJ = 3.0 * SIGMA + POWER4 * (S1 + S2 + S3) / (MU * SQRT(MU))
      RETURN
C
C                        ERROR RETURN
C
  100 RJ = 0.0
      IERR = 1
      RETURN
  110 RJ = 0.0
      IERR = 2
      RETURN
  120 RJ = 0.0
      IERR = 3
      RETURN
      END
      SUBROUTINE DRJVAL (X, Y, Z, P, RJ, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INCOMPLETE ELLIPTIC INTEGRAL
C          OF THE THIRD KIND
C
C          RJ(X,Y,Z,P) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                                  -1/2     -1/2     -1/2     -1
C                        (3/2)(T+X)    (T+Y)    (T+Z)    (T+P)  DT,
C
C          WHERE X, Y, AND Z ARE NONNEGATIVE, AT MOST ONE OF THEM IS
C          ZERO, AND P IS POSITIVE.  IF X OR Y OR Z IS ZERO, THE
C          INTEGRAL IS COMPLETE.  THE DUPLICATION THEOREM IS ITERATED
C          UNTIL THE VARIABLES ARE NEARLY EQUAL, AND THE FUNCTION IS
C          THEN EXPANDED IN TAYLOR SERIES TO FIFTH ORDER.  REFERENCE.
C          B. C. CARLSON, COMPUTING ELLIPTIC INTEGRALS BY DUPLICATION,
C          NUMER. MATH. 33 (1979), 1-16.  CODED BY B. C. CARLSON AND
C          ELAINE M. NOTIS, AMES LABORATORY-DOE, IOWA STATE UNIVERSITY,
C          AMES, IOWA 50011.  MARCH 1, 1980. MODIFIED BY A.H. MORRIS
C          (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      DOUBLE PRECISION RJ,RC,ALFA,BETA,C1,C2,C3,C4,EA,EB,EC,E2,E3
      DOUBLE PRECISION EPSLON,ERRTOL,ETOLRC,LAMDA,LOLIM,MU,P,PN,PNDEV
      DOUBLE PRECISION POWER4,SIGMA,S1,S2,S3,UPLIM,X,XN,XNDEV
      DOUBLE PRECISION XNROOT,Y,YN,YNDEV,YNROOT,Z,ZN,ZNDEV,ZNROOT
      DOUBLE PRECISION DPMPAR
C-----------------------------------------------------------------------
C
C          INPUT ...
C
C          X, Y, Z, AND P ARE THE VARIABLES IN THE INTEGRAL RJ(X,Y,Z,P).
C
C          OUTPUT ...
C
C          RJ IS THE VALUE OF THE INCOMPLETE ELLIPTIC INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X, Y, Z, OR P IS NEGATIVE.
C               IERR = 2  X+Y, X+Z, Y+Z, OR P IS TOO SMALL.
C               IERR = 3  X, Y, Z, OR P IS TOO LARGE.
C
C-----------------------------------------------------------------------
C
C          MACHINE DEPENDENT PARAMETERS ...
C
C          RC IS A FUNCTION COMPUTED BY THE SUBROUTINE DRCVL1.
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN THE CUBE ROOT OF THE VALUE
C          OF LOLIM USED IN THE CODE FOR RC, AND
C          UPLIM IS NOT GREATER THAN 0.3 TIMES THE CUBE ROOT OF
C          THE VALUE OF UPLIM USED IN THE CODE FOR RC.
C
               MU = 1.D0/3.D0
               LOLIM = 1.00000000001D0 * (5.0D0 * DPMPAR(2))**MU
               UPLIM = .299999999999D0 * (0.2D0 * DPMPAR(3))**MU
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION OF THE SERIES FOR RJ
C          IS LESS THAN 3 * ERRTOL ** 6 / (1 - ERRTOL) ** 3/2.
C          AN ERROR TOLERANCE (ETOLRC) WILL BE PASSED TO THE CODE FOR
C          RC TO MAKE THE TRUNCATION ERROR FOR RC LESS THAN FOR RJ.
C
             ERRTOL = (.28 * SNGL(DPMPAR(1)))**(1.0/6.0)
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (DMIN1(X,Y,Z,P) .LT. 0.D0) GO TO 100
      IF (DMIN1(X+Y,X+Z,Y+Z,P) .LT. LOLIM) GO TO 110
      IF (DMAX1(X,Y,Z,P) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
      ZN = Z
      PN = P
      SIGMA = 0.D0
      POWER4 = 1.D0
      ETOLRC = 0.5D0 * ERRTOL
C
   10 MU = (XN + YN + ZN + PN + PN) * 0.2D0
      XNDEV = (MU - XN) / MU
      YNDEV = (MU - YN) / MU
      ZNDEV = (MU - ZN) / MU
      PNDEV = (MU - PN) / MU
      EPSLON = DMAX1(DABS(XNDEV),DABS(YNDEV),DABS(ZNDEV),DABS(PNDEV))
      IF (EPSLON .LT. ERRTOL) GO TO 20
      XNROOT = DSQRT(XN)
      YNROOT = DSQRT(YN)
      ZNROOT = DSQRT(ZN)
      LAMDA = XNROOT * (YNROOT + ZNROOT) + YNROOT * ZNROOT
      ALFA = PN * (XNROOT + YNROOT + ZNROOT) + XNROOT * YNROOT * ZNROOT
      ALFA = ALFA * ALFA
      BETA = PN * (PN + LAMDA) * (PN + LAMDA)
      CALL DRCVL1 (ALFA, BETA, ETOLRC, RC, IERR)
      IF (IERR .NE. 0) RETURN
      SIGMA = SIGMA + POWER4 * RC
      POWER4 = POWER4 * 0.25D0
      XN = (XN + LAMDA) * 0.25D0
      YN = (YN + LAMDA) * 0.25D0
      ZN = (ZN + LAMDA) * 0.25D0
      PN = (PN + LAMDA) * 0.25D0
      GO TO 10
C
   20 C1 = 3.D0 / 14.D0
      C2 = 1.D0 / 3.D0
      C3 = 3.D0 / 22.D0
      C4 = 3.D0 / 26.D0
      EA = XNDEV * (YNDEV + ZNDEV) + YNDEV * ZNDEV
      EB = XNDEV * YNDEV * ZNDEV
      EC = PNDEV * PNDEV
      E2 = EA - 3.D0 * EC
      E3 = EB + 2.D0 * PNDEV * (EA - EC)
      S1 = 1.D0 + E2 * (- C1 + 0.75D0 * C3 * E2 - 1.5D0 * C4 * E3)
      S2 = EB * (0.5D0 * C2 + PNDEV * (- C3 - C3 + PNDEV * C4))
      S3 = PNDEV * EA * (C2 - PNDEV * C3) - C2 * PNDEV * EC
      RJ = 3.D0 * SIGMA + POWER4 * (S1 + S2 + S3) / (MU * DSQRT(MU))
      RETURN
C
C                        ERROR RETURN
C
  100 RJ = 0.D0
      IERR = 1
      RETURN
  110 RJ = 0.D0
      IERR = 2
      RETURN
  120 RJ = 0.D0
      IERR = 3
      RETURN
      END
      SUBROUTINE RCVAL1 (X, Y, ERRTOL, RC, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INTEGRAL
C
C          RC(X,Y) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                              -1/2     -1
C                    (1/2)(T+X)    (T+Y)  DT,
C
C          WHERE X IS NONNEGATIVE AND Y IS POSITIVE.  THE DUPLICATION
C          THEOREM IS ITERATED UNTIL THE VARIABLES ARE NEARLY EQUAL,
C          AND THE FUNCTION IS THEN EXPANDED IN TAYLOR SERIES TO FIFTH
C          ORDER.  LOGARITHMIC, INVERSE CIRCULAR, AND INVERSE HYPER-
C          BOLIC FUNCTIONS CAN BE EXPRESSED IN TERMS OF RC.  REFERENCE.
C          B. C. CARLSON, COMPUTING ELLIPTIC INTEGRALS BY DUPLICATION,
C          NUMER. MATH. 33 (1979), 1-16.  CODED BY B. C. CARLSON AND
C          ELAINE M. NOTIS, AMES LABORATORY-DOE, IOWA STATE UNIVERSITY,
C          AMES, IOWA 50011.  MARCH 1, 1980. MODIFIED BY A.H. MORRIS
C          (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      REAL RC,C1,C2,ERRTOL,LAMDA,LOLIM
      REAL MU,S,SN,UPLIM,X,XN,Y,YN
      REAL SPMPAR
C-----------------------------------------------------------------------
C
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN THE MACHINE MINIMUM MULTIPLIED BY 5.
C          UPLIM IS NOT GREATER THAN THE MACHINE MAXIMUM DIVIDED BY 5.
C
                      LOLIM = 5.0 * SPMPAR(2)
                      UPLIM = 0.2 * SPMPAR(3)
C
C          INPUT ...
C
C          X AND Y ARE THE VARIABLES IN THE INTEGRAL RC(X,Y).
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
C          16 * ERRTOL ** 6 / (1 - 2 * ERRTOL).
C
C          SAMPLE CHOICES   ERRTOL   RELATIVE TRUNCATION
C                                    ERROR LESS THAN
C                           1.E-3    2.E-17
C                           3.E-3    2.E-14
C                           1.E-2    2.E-11
C                           3.E-2    2.E-8
C                           1.E-1    2.E-5
C
C          OUTPUT ...
C
C          RC IS THE VALUE OF THE INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X OR Y IS NEGATIVE, OR Y = 0.
C               IERR = 2  X+Y IS TOO SMALL.
C               IERR = 3  X OR Y IS TOO LARGE.
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (X .LT. 0.0 .OR. Y .LE. 0.0) GO TO 100
      IF ((X + Y) .LT. LOLIM) GO TO 110
      IF (AMAX1(X,Y) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
C
   10 MU = (XN + YN + YN) / 3.0
      SN = (YN + MU) / MU - 2.0
      IF (ABS(SN) .LT. ERRTOL) GO TO 20
      LAMDA = 2.0 * SQRT(XN) * SQRT(YN) + YN
      XN = (XN + LAMDA) * 0.25
      YN = (YN + LAMDA) * 0.25
      GO TO 10
C
   20 C1 = 1.0 / 7.0
      C2 = 9.0 / 22.0
      S = SN * SN * (0.3 + SN * (C1 + SN * (0.375 + SN * C2)))
      RC = (1.0 + S) / SQRT(MU)
      RETURN
C
C                      ERROR RETURN
C
  100 RC = 0.0
      IERR = 1
      RETURN
  110 RC = 0.0
      IERR = 2
      RETURN
  120 RC = 0.0
      IERR = 3
      RETURN
      END
      SUBROUTINE DRCVL1 (X, Y, ERRTOL, RC, IERR)
C-----------------------------------------------------------------------
C
C          THIS SUBROUTINE COMPUTES THE INTEGRAL
C
C          RC(X,Y) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                              -1/2     -1
C                    (1/2)(T+X)    (T+Y)  DT,
C
C          WHERE X IS NONNEGATIVE AND Y IS POSITIVE.  THE DUPLICATION
C          THEOREM IS ITERATED UNTIL THE VARIABLES ARE NEARLY EQUAL,
C          AND THE FUNCTION IS THEN EXPANDED IN TAYLOR SERIES TO FIFTH
C          ORDER.  LOGARITHMIC, INVERSE CIRCULAR, AND INVERSE HYPER-
C          BOLIC FUNCTIONS CAN BE EXPRESSED IN TERMS OF RC.  REFERENCE.
C          B. C. CARLSON, COMPUTING ELLIPTIC INTEGRALS BY DUPLICATION,
C          NUMER. MATH. 33 (1979), 1-16.  CODED BY B. C. CARLSON AND
C          ELAINE M. NOTIS, AMES LABORATORY-DOE, IOWA STATE UNIVERSITY,
C          AMES, IOWA 50011.  MARCH 1, 1980. MODIFIED BY A.H. MORRIS
C          (NSWC).
C
C-----------------------------------------------------------------------
      INTEGER IERR
      DOUBLE PRECISION RC,C1,C2,ERRTOL,LAMDA,LOLIM
      DOUBLE PRECISION MU,S,SN,UPLIM,X,XN,Y,YN
      DOUBLE PRECISION DPMPAR
C-----------------------------------------------------------------------
C
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN THE MACHINE MINIMUM MULTIPLIED BY 5.
C          UPLIM IS NOT GREATER THAN THE MACHINE MAXIMUM DIVIDED BY 5.
C
                      LOLIM = 5.0D0 * DPMPAR(2)
                      UPLIM = 0.2D0 * DPMPAR(3)
C
C          INPUT ...
C
C          X AND Y ARE THE VARIABLES IN THE INTEGRAL RC(X,Y).
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
C          16 * ERRTOL ** 6 / (1 - 2 * ERRTOL).
C
C          OUTPUT ...
C
C          RC IS THE VALUE OF THE INTEGRAL.
C
C          IERR IS THE RETURN ERROR CODE.
C               IERR = 0  FOR NORMAL COMPLETION OF THE SUBROUTINE.
C               IERR = 1  X OR Y IS NEGATIVE, OR Y = 0.
C               IERR = 2  X+Y IS TOO SMALL.
C               IERR = 3  X OR Y IS TOO LARGE.
C
C-----------------------------------------------------------------------
C          WARNING. CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C-----------------------------------------------------------------------
C
      IF (X .LT. 0.D0  .OR.  Y .LE. 0.D0) GO TO 100
      IF ((X + Y) .LT. LOLIM) GO TO 110
      IF (DMAX1(X,Y) .GT. UPLIM) GO TO 120
C
      IERR = 0
      XN = X
      YN = Y
C
   10 MU = (XN + YN + YN) / 3.D0
      SN = (YN + MU) / MU - 2.D0
      IF (DABS(SN) .LT. ERRTOL) GO TO 20
      LAMDA = 2.D0 * DSQRT(XN) * DSQRT(YN) + YN
      XN = (XN + LAMDA) * 0.25D0
      YN = (YN + LAMDA) * 0.25D0
      GO TO 10
C
   20 C1 = 1.D0 / 7.D0
      C2 = 9.D0 / 22.D0
      S = SN * SN * (0.3D0 + SN * (C1 + SN * (0.375D0 + SN * C2)))
      RC = (1.D0 + S) / DSQRT(MU)
      RETURN
C
C                      ERROR RETURN
C
  100 RC = 0.D0
      IERR = 1
      RETURN
  110 RC = 0.D0
      IERR = 2
      RETURN
  120 RC = 0.D0
      IERR = 3
      RETURN
      END
      SUBROUTINE ELLPF(U,K,L,S,C,D,IERR)
C     -------------------------------------------------------------
C     ELLPF CALCULATES THE ELLIPTIC FUNCTIONS SN(U,K), CN(U,K), AND
C     DN(U,K) FOR REAL U AND REAL MODULUS K.  IT IS ASSUMED THAT
C     ABS(K) .LE. 1. AND K**2 + L**2 = 1.
C     -------------------------------------------------------------
      REAL K, L
      DATA PIHALF /1.5707963267949/
C     ----------------
C     ****** MAX AND EPS ARE MACHINE DEPENDENT CONSTANTS.
C            MAX IS THE LARGEST POSITIVE INTEGER THAT MAY
C            BE USED, AND EPS IS THE SMALLEST REAL NUMBER
C            FOR WHICH 1 + EPS .GT. 1.
C
                    MAX = IPMPAR(3)
                    EPS = SPMPAR(1)
C
C     ----------------
C     CALCULATION FOR L = 0.0
C
      IF (L .NE. 0.0) GO TO 10
      S = TANH(U)
      E = EXP(-ABS(U))
      C = 2.0*E/(1.0 + E*E)
      D = C
      IERR = 0
      RETURN
C
C     CHECK THAT K**2 + L**2 = 1
C
   10 TOL = 2.0*EPS
      Z = DBLE(K*K) + (DBLE(L*L) - 1.D0)
      IF (ABS(Z) .GT. TOL) GO TO 100
C
      F = PIHALF
      IF (K .NE. 0.0) CALL ELLPI(PIHALF,0.0,K,L,F,E,IERR)
      F2 = 2.0*F
C
C                   ARGUMENT REDUCTION
C
      U1 = ABS(U)
      R = U1/F2
      IF (R .GE. AMIN1(FLOAT(MAX),1.0/EPS)) GO TO 110
      N = INT(R)
      U1 = U1 - FLOAT(N)*F2
      SG = 1.0
      IF (MOD(N,2) .NE. 0) SG = -1.0
C
      IF (U1 .LE. 0.0) GO TO 30
      IF (U1 .LE. F) GO TO 20
      U1 = U1 - F2
      SG = -SG
      IF (U1 .GE. 0.0) GO TO 30
C
C     CALCULATION OF ELLIPTIC FUNCTIONS FOR 0.0 .LE. U2 .LE. F(K)
C
   20 U2 = ABS(U1)
      CALL SCD (U2,ABS(K),ABS(L),F,S,C,D)
      IERR = 0
      IF (U1 .LT. 0.0) S = -S
C
C     FINAL ASSEMBLY
C
      S = SG*S
      C = SG*C
      IF (U .LT. 0.0) S = -S
      RETURN
C
C             U IS AN INTEGER MULTIPLE OF F2
C
   30 S = 0.0
      C = SG
      D = 1.0
      IERR = 0
      RETURN
C
C                      ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      RETURN
      END
      SUBROUTINE SCD(U,K,L,F,S,C,D)
C     --------------------------------------------------------
C     SCD COMPUTES THE ELLIPTIC FUNCTIONS SN(U,K), CN(U,K),
C     AND DN(U,K) FOR REAL U AND REAL MODULUS K SUCH THAT
C     0.0 .LE. U .LE. F AND 0.0 .LE. K .LT. 1.0, WHERE
C     F = F(K) IS THE COMPLETE ELLIPTIC INTEGRAL OF THE
C     FIRST KIND, AND F1 = F(L) IS THE COMPLEMENTARY INTEGRAL.
C     IT IS ASSUMED THAT K**2 + L**2 = 1.
C     --------------------------------------------------------
      REAL K, L
      DATA PIHALF /1.5707963267949/
C     ------------------------
      IF (K .EQ. 0.0) GO TO 40
      V = F - U
C
C     USES MACLAURIN EXPANSION WHEN U OR V .LE. 0.01
C
      IF (U .GT. 0.01) GO TO 10
         CALL SCDM (U,K,S,C,D)
         RETURN
   10 IF (V .GT. 0.01) GO TO 20
      CALL SCDM (V,K,S1,C1,D1)
      S = C1/D1
      C = L*S1/D1
      D = L/D1
      RETURN
C
C     USES FOURIER EXPANSION WHEN K .LE. L
C
   20 CALL ELLPI(PIHALF,0.0,L,K,F1,E1,IERR)
C
      IF (K .GT. L) GO TO 30
      CALL SCDF (U,K,L,F,F1,S,C,D)
      RETURN
C
C     USES IMAGINARY TRANSFORMATION OF JACOBI AND FOURIER
C     EXPANSION WHEN K .GT. L
C
   30 CALL SCDJ (U,K,L,F,F1,S,C,D)
      RETURN
C
C     COMPUTATION FOR K = 0.0
C
   40 S = SIN(U)
      C = COS(U)
      D = 1.0
      RETURN
      END
      SUBROUTINE SCDM(U,K,S,C,D)
C     -------------------------------------------------
C     CALCULATES SN(U,K), CN(U,K), AND DN(U,K) FOR
C     0.0 .LE. U .LE. 0.01 AND FOR 0.0 .LE. K .LE. 1.0
C     BY USE OF THE MACLAURIN EXPANSION FOR SN(U,K)
C     -------------------------------------------------
      REAL K, K2
C
      K2 = K*K
      U2 = U*U
      C1 = -(1.0 + K2)/6.0
      C2 = (1.0 + K2*(14.0 + K2))/120.0
      C3 = -(1.0 + K2*(135.0 + K2*(135.0 + K2)))/5040.0
      C4 = (1.0 + K2*(1228.0 + K2*(5478.0 + K2*(1228.0 + K2))))/
     *     362880.0
      S = U*(1.0 + U2*(C1 + U2*(C2 + U2*(C3 + C4*U2))))
      C = SQRT(1.0 - S*S)
      D = SQRT(1.0 - (K*S)**2)
      RETURN
      END
      SUBROUTINE SCDF(U,K,L,F,F1,S,C,D)
C     -------------------------------------------------------------
C     SCDF COMPUTES SN(U,K), CN(U,K), AND DN(U,K) FOR REAL U AND
C     K BY USE OF THE FOURIER EXPANSION FOR SN(U,K).  IT IS
C     ASSUMED THAT 0.0 .LE. K .LT. 1.0 AND 0.0 .LE. U .LE. F,
C     WHERE F = F(K) IS THE COMPLETE ELLIPTIC INTEGRAL OF THE
C     FIRST KIND AND F1 = F(L) IS THE COMPLEMENTARY INTEGRAL, WITH
C     L .NE. 0. AND K**2 + L**2 = 1.
C     -------------------------------------------------------------
      REAL I, K, L
      DATA PIHALF /1.5707963267949/
C     -------------------------------------------------
C     EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
C     SMALLEST NUMBER SUCH THAT 1. + EPS .GT. 1.
C
      EPS = SPMPAR(1)
C
C     -------------------------------------------------
      TOL = EPS/10.0
      V = F - U
      QH = EXP(-PIHALF*F1/F)
      Q1 = QH*QH
      Q2 = Q1*Q1
      COEF = 4.*PIHALF*QH/(K*F)
      QN = 1.0
      QD = Q1
      W = AMIN1(U,V)
      X = PIHALF*W/F
C
C     CALCULATION OF SERIES FOR W = AMIN1(U,V)
C
      I = 1.0
      SUM = 0.0
   10 AI = QN/(1.0 - QD)
      A = AI*SIN(I*X)
      SUM = SUM + A
      IF (ABS(AI) .LT. TOL*ABS(SUM)) GO TO 20
      QN = QN*Q1
      QD = QD*Q2
      I = I + 2.0
      GO TO 10
C
C     ASSEMBLY FOR U .LE. V
C
   20 S = COEF*SUM
      C = SQRT(1.0 - S*S)
      D = SQRT(1.0 - (K*S)**2)
      IF (U .EQ. W) RETURN
C
C     ASSEMBLY FOR U .GT. V
C
      TEMP = S
      S = C/D
      C = L*TEMP/D
      D = L/D
      RETURN
      END
      SUBROUTINE SCDJ(U,K,L,F,F1,S,C,D)
C     ----------------------------------------------------------------
C     SCDJ COMPUTES SN(U,K), CN(U,K), AND DN(U,K) FOR REAL U AND
C     K USING THE IMAGINARY TRANSFORMATION OF JACOBI AND A
C     FOURIER EXPANSION.  IT IS ASSUMED THAT 0.0 .LE. K .LT. 1.0
C     AND 0.0 .LE. U .LE. F, WHERE F = F(K) IS THE COMPLETE ELLIPTIC
C     INTEGRAL OF THE FIRST KIND AND F1 = F(L) IS THE COMPLEMENTARY
C     INTEGRAL, AND THAT L .NE. 0. AND K**2 + L**2 = 1.
C     ----------------------------------------------------------------
      REAL K, L, N
      DATA PIHALF /1.5707963267949/
      DATA PI /3.1415926535898/
C     ------------------------------------------------
C     EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
C     SMALLEST NUMBER SUCH THAT 1. + EPS .GT. 1.
C
      EPS = SPMPAR(1)
C
C     ------------------------------------------------
      TOL = EPS/10.0
      V = F - U
      Q1 = -EXP(-PI*F/F1)
      Q2 = Q1*Q1
C
      W = AMIN1(U,V)
      E1 = PI*AMAX1(U,V)/F1
      E2 = PI*(F + W)/F1
      E1 = EXP(-E1)
      E2 = EXP(-E2)
C
      COEF = PIHALF/(K*F1)
      X = PIHALF*W/F1
      X2 = 2.0*X
C
C     CALCULATION OF SERIES FOR W = AMIN1(U,V)
C
      N = 1.0
      Q1N = Q1
      Q2N = Q2
      E1N = E1
      E2N = E2
      SUM = 0.0
C
   20 XN = N*X2
      IF (XN .GT. 1.0) GO TO 30
         CALL SNHCSH(SH,CH,XN,-1)
         SH = SH + XN
         A = 2.0*Q1N*ABS(Q1N)*SH/(1.0 + Q2N)
         GO TO 40
   30 A = Q1N*(E1N - E2N)/(1.0 + Q2N)
   40 SUM = SUM + A
      IF (ABS(A) .LT. TOL*ABS(SUM)) GO TO 50
      Q1N = Q1N*Q1
      Q2N = Q2N*Q2
      E1N = E1N*E1
      E2N = E2N*E2
      N = N + 1.0
      GO TO 20
C
C     ASSEMBLY FOR U .LE. V
C
   50 S = COEF*(TANH(X) + 2.0*SUM)
      C = SQRT(1.0 - S*S)
      D = SQRT(1.0 - (K*S)**2)
      IF (U .EQ. W) RETURN
C
C     ASSEMBLY FOR U .GT. V
C
      TEMP = S
      S = C/D
      C = L*TEMP/D
      D = L/D
      RETURN
      END
      SUBROUTINE ELPFC1 (U,K,L,S,C,D,IERR)
C     -------------------------------------------------------------
C     ELPFC1 CALCULATES THE ELLIPTIC FUNCTIONS SN(U,K), CN(U,K),
C     DN(U,K) FOR COMPLEX U AND REAL MODULUS K.  IT IS ASSUMED THAT
C     ABS(K) .LE. 1. AND K**2 + L**2 = 1.
C     -------------------------------------------------------------
      COMPLEX U, S, C, D
      REAL K, L, K2
C
      U1 = REAL(U)
      U2 = AIMAG(U)
      K2 = K*K
      IF (U1 .EQ. 0.0) GO TO 10
      IF (U2 .NE. 0.0) GO TO 20
C
C     CALCULATION FOR U2 = 0.
C
      CALL ELLPF (U1,K,L,S1,C1,D1,IERR)
      IF (IERR .NE. 0) RETURN
      S2 = 0.0
      C2 = 0.0
      D2 = 0.0
      GO TO 40
C
C     CALCULATION FOR U1 = 0.
C
   10 CALL ELLPF (U2,L,K,S2,C2,D2,IERR)
      IF  (IERR .NE. 0) RETURN
      IF (C2 .EQ. 0.0) GO TO 50
      S1 = 0.0
      S2 = S2/C2
      D1 = D2/C2
      D2 = 0.0
      C1 = 1.0/C2
      C2 = 0.0
      GO TO 40
C
C     CALCULATION FOR U1 AND U2 .NE. 0.
C
   20 CALL ELLPF (U1,K,L,SK,CK,DK,IERR)
      IF (IERR .NE. 0) RETURN
      CALL ELLPF (U2,L,K,SL,CL,DL,IERR)
      IF (IERR .NE. 0) RETURN
      COEF = ABS(K)*SL
      T1 = CL
      T2 = COEF*SK
      TD1 = COEF*T1
      TD2 = COEF*T2
      IF (ABS(T2) .LE. ABS(T1)) GO TO 30
      IF (T2 .EQ. 0.0) GO TO 50
      IF (TD2 .EQ. 0.0) GO TO 50
      T = T1/T2
      R = 1.0/(1.0 + T*T)
      S1 = DL*R/TD2
      S2 = CK*DK*SL*T*R/T2
      C1 = CK*T*R/T2
      C2 = -DK*SL*DL*R/TD2
      D1 = DK*DL*T*R/T2
      D2 = -K2*CK*SL*R/TD2
      GO TO 40
   30 IF (T1 .EQ. 0.0) GO TO 50
      IF (TD1 .EQ. 0.0) GO TO 50
      T = T2/T1
      R = 1.0/(1.0 + T*T)
      S1 = DL*T*R/TD1
      S2 = CK*DK*SL*R/T1
      C1 = CK*R/T1
      C2 = -DK*SL*DL*T*R/TD1
      D1 = DK*DL*R/T1
      D2 = -K2*CK*SL*T*R/TD1
C
C     FINAL ASSEMBLY
C
   40 S = CMPLX (S1, S2)
      C = CMPLX (C1, C2)
      D = CMPLX (D1, D2)
      RETURN
C
C     ERROR RETURN
C
   50 IERR = 3
      RETURN
      END
      SUBROUTINE PEQ(Z, W, IERR)
C
C     WEIERSTRASS P-FUNCTION IN THE EQUIANHARMONIC CASE
C     FOR COMPLEX ARGUMENT WITH UNIT PERIOD PARALLELOGRAM
C
      COMPLEX Z, Z1, Z4, Z6, W
      REAL ZR, ZI
      INTEGER IERR, M, N
C
C     REDUCTION TO FUNDAMENTAL PARALLELOGRAM
C
      ZI = 1.1547005383792515E0*AIMAG(Z) + 0.5E0
      M = INT(ZI)
      IF (ZI.LT.0E0) M = M - 1
      ZR = REAL(Z) - 0.5E0*FLOAT(M) + 0.5E0
      N = INT(ZR)
      IF (ZR.LT.0E0) N = N - 1
      Z1 = Z - FLOAT(N) - (0.5E0,0.86602540378443865E0)*FLOAT(M)
C
C     IF Z1=0 THEN Z COINCIDES WITH A LATTICE POINT.
C     THE LATTICE POINTS ARE POLES FOR P.
C
      W = Z1*Z1
      ZR = ABS(REAL(W)) + ABS(AIMAG(W))
      IF (ZR.NE.0E0) GO TO 10
      IERR = 1
      RETURN
C
C     EVALUATION OF P(Z1)
C
   10 IERR = 0
      Z4 = W*W
      Z6 = Z4*W
      W = 1E0/W + 6E0*Z4*(5E0+Z6)/(1E0-Z6)**2 + Z4*
     * (((((-2.6427662E-10*Z6+1.610954818E-8)*Z6+7.38610752879E-6)*
     * Z6+4.3991444671178E-4)*Z6+7.477288220490697E-2)*
     * Z6-6.8484153287299201E-1)/(((((6.2252191E-10*Z6+2.553314573E-7)*
     * Z6-2.619832920421E-5)*Z6-5.6444801847646E-4)*
     * Z6+4.565553484820106E-2)*Z6+1E0)
      RETURN
      END
      SUBROUTINE PEQ1(Z, W, IERR)
C
C     FIRST DERIVATIVE OF WEIERSTRASS P-FUNCTION IN THE
C     EQUIANHARMONIC CASE FOR COMPLEX ARGUMENT
C     WITH UNIT PERIOD PARALLELOGRAM
C
      COMPLEX Z, Z1, Z3, Z6, W
      REAL ZR, ZI
      INTEGER IERR, M, N
C
C     REDUCTION TO FUNDAMENTAL PARALLELOGRAM
C
      ZI = 1.1547005383792515E0*AIMAG(Z) + 0.5E0
      M = INT(ZI)
      IF (ZI.LT.0E0) M = M - 1
      ZR = REAL(Z) - 0.5E0*FLOAT(M) + 0.5E0
      N = INT(ZR)
      IF (ZR.LT.0E0) N = N - 1
      Z1 = Z - FLOAT(N) - (0.5E0,0.86602540378443865E0)*FLOAT(M)
C
C     IF Z1=0 THEN Z COINCIDES WITH A LATTICE POINT.
C     THE LATTICE POINTS ARE POLES FOR DP.
C
      Z3 = Z1*Z1*Z1
      Z6 = Z3*Z3
      W = Z3*(1E0-Z6)**3
      ZR = ABS(REAL(W)) + ABS(AIMAG(W))
      IF (ZR.NE.0E0) GO TO 10
      IERR = 1
      RETURN
C
C     EVALUATION OF DP(Z1)
C
   10 IERR = 0
      W = (((14E0*Z6+294E0)*Z6+126E0)*Z6-2E0)/W +
     * Z3*((((((-2.95539175E-9*Z6-2.6764693031E-7)*Z6+2.402192743346E-5)
     * *Z6+1.9656661451391E-4)*Z6+1.760135529461036E-2)*
     * Z6+8.1026243498822636E-1)*Z6-2.73936613149196804E0)/
     * ((((((4.6397763E-10*Z6+5.413482233E-8)*Z6-1.56293298374E-6)*
     * Z6-1.0393701076352E-4)*Z6+9.5553182532237E-4)*
     * Z6+9.131106969640212E-2)*Z6+1E0)
      RETURN
      END
      SUBROUTINE PLEM(Z, W, IERR)
C
C     WEIERSTRASS P-FUNCTION IN THE LEMNISCATIC CASE
C     FOR COMPLEX ARGUMENT WITH UNIT PERIOD PARALLELOGRAM
C
      COMPLEX Z, Z1, Z4, Z6, W
      REAL ZR, ZI
      INTEGER IERR, M, N
C
C     REDUCTION TO FUNDAMENTAL PARALLELOGRAM
C
      ZR = REAL(Z) + 0.5E0
      ZI = AIMAG(Z) + 0.5E0
      M = INT(ZR)
      N = INT(ZI)
      IF (ZR.LT.0E0) M = M - 1
      IF (ZI.LT.0E0) N = N - 1
      Z1 = Z - FLOAT(M) - (0E0,1E0)*FLOAT(N)
C
C     IF Z1=0 THEN Z COINCIDES WITH A LATTICE POINT.
C     THE LATTICE POINTS ARE POLES FOR P.
C
      W = Z1*Z1
      ZR = ABS(REAL(W)) + ABS(AIMAG(W))
      IF (ZR.NE.0E0) GO TO 10
      IERR = 1
      RETURN
C
C     EVALUATION OF P(Z1)
C
   10 IERR = 0
      Z4 = W*W
      Z6 = Z4*W
      W = 1E0/W + 4E0*W*(3E0+Z4)/(1E0-Z4)**2 +
     * W*((((((((-7.233108E-11*Z4+1.714197273E-8)*Z4-2.5369036492E-7)*
     * Z4-7.98710206868E-6)*Z4+6.4850606909737E-4)*Z4+7.39624629362938E-
     * 3)*Z4+2.012382768497244E-2)*Z4+7.1177297543136598E-1)*
     * Z4-2.54636399353830738E0)/((((((((5.1161516E-10*Z4+6.61289408E-9)
     * *Z4+4.4618987048E-7)*Z4-8.42694918892E-6)*Z4+4.42886829095E-6)*
     * Z4-4.22629935217101E-3)*Z4+2.577496871700433E-2)*
     * Z4+4.2359940482277074E-1)*Z4+1E0)
      RETURN
      END
      SUBROUTINE PLEM1(Z, W, IERR)
C
C     FIRST DERIVATIVE OF WEIERSTRASS P-FUNCTION IN THE
C     LEMNISCATIC CASE FOR COMPLEX ARGUMENT
C     WITH UNIT PERIOD PARALLELOGRAM
C
      COMPLEX Z, Z1, Z3, Z4, W
      REAL ZR, ZI
      INTEGER IERR, M, N
C
C     REDUCTION TO FUNDAMENTAL PARALLELOGRAM
C
      ZR = REAL(Z) + 0.5E0
      ZI = AIMAG(Z) + 0.5E0
      M = INT(ZR)
      N = INT(ZI)
      IF (ZR.LT.0E0) M = M - 1
      IF (ZI.LT.0E0) N = N - 1
      Z1 = Z - FLOAT(M) - (0E0,1E0)*FLOAT(N)
C
C     IF Z1=0 THEN Z COINCIDES WITH A LATTICE POINT.
C     THE LATTICE POINTS ARE POLES FOR DP.
C
      Z3 = Z1*Z1*Z1
      Z4 = Z3*Z1
      W = (Z1*(1E0-Z4))**3
      ZR = ABS(REAL(W)) + ABS(AIMAG(W))
      IF (ZR.NE.0E0) GO TO 10
      IERR = 1
      RETURN
C
C     EVALUATION OF DP(Z1)
C
   10 IERR = 0
      W = (((1E1*Z4+9E1)*Z4+3E1)*Z4-2E0)/W +
     * Z1*((((((((((-3.9046302E-9*Z4-1.001487137E-8)*Z4+5.9573043092E-7)
     * *Z4-2.482518130524E-5)*Z4+1.4557266595395E-4)*
     * Z4+4.56633655643206E-3)*Z4+6.224782572111135E-2)*
     * Z4+1.038527937794269E-2)*Z4+1.19804620802637942E0)*
     * Z4+6.42791439683811718E0)*Z4-5.09272798707661477E0)/
     * ((((((((((4.726888E-11*Z4-3.0667983E-9)*Z4+1.0087596089E-7)*
     * Z4-8.060683451E-8)*Z4+1.184299251664E-5)*Z4-2.3096723361547E-4)*
     * Z4-2.90730903142055E-3)*Z4+1.338392411135511E-2)*
     * Z4+2.3098639320021426E-1)*Z4+8.4719880964554148E-1)*Z4+1E0)
      RETURN
      END
      SUBROUTINE VALR2(X,Y,N0,P,IOP,A,IND,KO)
C     -------------------
      DIMENSION X(*),Y(*),G(2),H(2)
      DIMENSION E(5),E2(10),E3(15)
      DIMENSION APH1(3),APH2(3),APH4(3)
      DIMENSION RSQ(3),A3D8(3),CST(3)
      REAL KOM,L
C     -------------------
      DATA PI/3.1415926535898/
      DATA TWOPI/6.28318530717958/
      DATA ALNPI/1.14472988584940/
      DATA RTPI/1.77245385090552/
      DATA RTPII/.56418958354776/
C     -------------------
      DATA E(1)/.885777518572895E+00/,  E(2)/-.981151952778050E+00/,
     1     E(3)/.759305502082485E+00/,  E(4)/-.353644980686977E+00/,
     2     E(5)/.695232092435207E-01/
      DATA E2(1) /.886226470016632E+00/,  E2(2) /-.999950714561036E+00/,
     1     E2(3) /.885348820003892E+00/,  E2(4) /-.660611239043357E+00/,
     2     E2(5) /.421821197160099E+00/,  E2(6) /-.222898055667208E+00/,
     3     E2(7) /.905057384150449E-01/,  E2(8) /-.254906111884287E-01/,
     4     E2(9) /.430895168984138E-02/,  E2(10)/-.323377239693247E-03/
      DATA E3(1) /.886226924931465E+00/,  E3(2) /-.999999899776252E+00/,
     1     E3(3) /.886223733186722E+00/,  E3(4) /-.666626670510907E+00/,
     2     E3(5) /.442851899328569E+00/,  E3(6) /-.265638206366025E+00/,
     3     E3(7) /.145060043403014E+00/,  E3(8) /-.714909837799889E-01/,
     4     E3(9) /.309199295521210E-01/,  E3(10)/-.112323532148441E-01/,
     5     E3(11)/.324944543171185E-02/,  E3(12)/-.704260243309096E-03/,
     6     E3(13)/.105787574480633E-03/,  E3(14)/-.971864864160461E-05/,
     7     E3(15)/.408335517232165E-06/
      DATA APH1(1)/2.02E-7/, APH1(2)/2.08E-13/, APH1(3)/2.71E-19/
      DATA APH2(1)/1.22E-2/, APH2(2)/1.23E-4/, APH2(3)/1.34E-6/
      DATA APH4(1)/.6962E-1/, APH4(2)/.6990E-2/, APH4(3)/.7311E-3/
      DATA RSQ(1)/6.0516/, RSQ(2)/12.60605/, RSQ(3)/19.201924/
      DATA A3D8(1)/0.28125E-4/, A3D8(2)/0.285E-7/, A3D8(3)/0.32625E-10/
      DATA CST(1)/.5625E-4/, CST(2)/.57E-7/, CST(3)/.6512E-10/
C     -------------------
C     TAU IS A MACHINE DEPENDENT TOLERANCE. IT IS ASSUMED THAT A
C     7 OR MORE DIGIT FLOATING POINT ARITHMETIC IS BEING USED.
C     -------------------
      TAU=2.0*SPMPAR(1)
      IF (TAU.LT.3.E-11) TAU=AMAX1(5.0*TAU,1.E-14)
C     -------------------
      N=N0
      IF (N.EQ.2.OR.N.LT.1) GO TO 4021
      TAUSQ=TAU*TAU
C
      P=0.0
      IND=0
      A=0.0
      KOM=0.0
      K=1
      IF (N.NE.1) GO TO 10
C
      W=X(2)-X(1)
      Z=Y(2)-Y(1)
      U=X(3)-X(1)
      V=Y(3)-Y(1)
      XK=0.0
      PSI1=V*W-U*Z
      IF (PSI1.GE.0.0) GO TO 21
C
      P=-1.0
      T1=W
      W=U
      U=T1
      T1=V
      V=Z
      Z=T1
      GO TO 21
C
   10 KO=0
      X(N+1)=X(1)
      Y(N+1)=Y(1)
      U=X(2)-X(1)
      V=Y(2)-Y(1)
      XK=X(1)
      YK=Y(1)
C
   20 W=X(1)-X(N)
      Z=Y(1)-Y(N)
   21 D1SQ=W*W+Z*Z
      IF (D1SQ.GT.TAUSQ) GO TO 30
      IF (N.EQ.1) GO TO 4011
      N=N-1
      IF (N.EQ.2) RETURN
      GO TO 20
C
   30 D2SQ=U*U+V*V
      IF (D2SQ.GT.TAUSQ) GO TO 40
      IF (N.EQ.1) GO TO 4011
   31 K=K+1
      U=X(K+1)-XK
      V=Y(K+1)-YK
      D2SQ=U*U+V*V
      IF (D2SQ.LE.TAUSQ) GO TO 31
      IF (K.EQ.N-1) RETURN
C
   40 A=XK*(Y(K+1)-Y(N))
      BGD1=SQRT(D1SQ+D1SQ)
      BGD2=SQRT(D2SQ+D2SQ)
C
C             PROCESSING VERTEX (XK,YK)
C
   50 PSI1=V*W-U*Z
      CEE=U*W+V*Z
      AJ0=ATAN2(PSI1,CEE)
      KOM=KOM+AJ0
      L=0.0
      B=.5*(X(K)*X(K)+Y(K)*Y(K))
      IF (B.GT.APH1(IOP)) GO TO 60
      P1=AJ0/TWOPI
      GO TO 3621
C
   60 G(1)=(W*X(K)+Z*Y(K))/BGD1
      G(2)=(U*X(K)+V*Y(K))/BGD2
      H(1)=(-Y(K)*W+X(K)*Z)/BGD1
      H(2)=(-Y(K)*U+X(K)*V)/BGD2
      IF (ABS(PSI1).GT.BGD1*BGD2*A3D8(IOP)) GO TO 80
      IF (CEE.LT.0.0) GO TO 70
      IF (ABS(AJ0).GT.TAU.AND.G(1).LT.0.0) GO TO 80
      P1=0.0
      GO TO 3621
C
   70 IF (ABS(PSI1).LE.(.5*TAU*BGD1*BGD2)) IND=2
      IF (PSI1.LT.0.0) GO TO 71
      P1=.5*ERFC1(0,H(2))
      GO TO 3621
   71 P1=-.5*ERFC1(0,H(1))
      GO TO 3621
C
   80 IF (B.GT.APH2(IOP)) GO TO 90
      C=RTPI*(H(2)-H(1))-(G(2)*H(2)-G(1)*H(1))
      P1=(AJ0-C)/TWOPI
      GO TO 3621
C
C                 COMPUTATION OF L
C
   90 IF (G(1).LT.0.0) GO TO 100
      IF (G(2).GE.0.0) GO TO 130
      G(2)=-G(2)
      H(2)=-H(2)
      IF (ABS(H(2)).LE.APH4(IOP)) GO TO 91
      L=.5*ERFC1(0,-H(2))
      GO TO 120
   91 L=.5+RTPII*H(2)
      GO TO 120
C
  100 G(1)=-G(1)
      H(1)=-H(1)
      IF (G(2).LT.0.0) GO TO 110
      IF (ABS(H(1)).LE.APH4(IOP)) GO TO 101
      L=.5*ERFC1(0,H(1))
      GO TO 120
  101 L=.5-RTPII*H(1)
      GO TO 120
C
  110 G(2)=-G(2)
      H(2)=-H(2)
      IF (ABS(H(1)).LE.APH4(IOP)) GO TO 112
      IF (ABS(H(2)).LE.APH4(IOP)) GO TO 111
      L=.5*(ERFC1(0,H(1))-ERFC1(0,H(2)))
      GO TO 130
  111 L=RTPII*H(2)-.5*ERF(H(1))
      GO TO 130
  112 IF (ABS(H(2)).LE.APH4(IOP)) GO TO 113
      L=.5*ERF(H(2))-RTPII*H(1)
      GO TO 130
  113 L=RTPII*(H(2)-H(1))
      GO TO 130
C
  120 PSI1=-PSI1
      IF (PSI1.LE.0.0) GO TO 121
      L=L-1.0
      AJ0=AJ0+PI
      GO TO 130
  121 AJ0=AJ0-PI
C
C                 SERIES EVALUATION
C
  130 IF (B.GE.RSQ(IOP)) GO TO 171
      CAPE=AJ0
      CAPH=.5*AJ0
      M=1
      F=0.0
      AJ1=H(2)-H(1)
      CIRCM=AJ1
      IF (IOP-2) 140,150,160
C
  140 SUM=E(M)*AJ1
  141 M=M+1
      H(1)=H(1)*G(1)
      H(2)=H(2)*G(2)
      T=H(2)-H(1)
      F=F+B
      CAPV=(F*CAPE+T)/M
      SUM=SUM+E(M)*CAPV
      IF (M.GE.5) GO TO 170
      CAPE=CIRCM
      CIRCM=CAPV
      GO TO 141
C
  150 SUM=E2(M)*AJ1
  151 M=M+1
      H(1)=H(1)*G(1)
      H(2)=H(2)*G(2)
      T=H(2)-H(1)
      F=F+B
      CAPV=(F*CAPE+T)/M
      SUM=SUM+E2(M)*CAPV
      IF (M.GE.10) GO TO 170
      CAPE=CIRCM
      CIRCM=CAPV
      GO TO 151
C
  160 SUM=E3(M)*AJ1
  161 M=M+1
      H(1)=H(1)*G(1)
      H(2)=H(2)*G(2)
      T=H(2)-H(1)
      F=F+B
      CAPV=(F*CAPE+T)/M
      SUM=SUM+E3(M)*CAPV
      IF (M.GE.15) GO TO 170
      CAPE=CIRCM
      CIRCM=CAPV
      GO TO 161
C
  170 P1=L+EXP(-(B+ALNPI))*(CAPH-SUM)
      GO TO 3621
  171 P1=L
C
C               STANDARD TERMINATION
C
 3621 IF (K.NE.N) GO TO 3651
      IF (N.NE.1) GO TO 3631
      P=ABS(P+ABS(P1))
      RETURN
C
 3631 P=P-P1
      KOM=KOM/TWOPI
      A=.5*A
      IF (KOM.LT.0.0) GO TO 3641
      KO=INT(KOM+.125)
      GO TO 3645
 3641 KO=INT(KOM-.125)
 3645 P=P+FLOAT(KO)
      RETURN
C
C              SET UP THE NEXT VERTEX
C
 3651 W=U
      Z=V
      BGD1=BGD2
      XK=X(K+1)
      YK=Y(K+1)
      YKM1=Y(K)
 3661 K=K+1
      U=X(K+1)-XK
      V=Y(K+1)-YK
      D2SQ=U*U+V*V
      IF (D2SQ.LE.TAUSQ) GO TO 3661
      BGD2=SQRT(D2SQ+D2SQ)
      P=P-P1
      A=A+XK*(Y(K+1)-YKM1)
      GO TO 50
C
C                  ERROR RETURN
C
 4011 IND=1
      P=5.0
      RETURN
 4021 IND=3
      RETURN
      END
      SUBROUTINE CIRCV (R, D, J, P, IERR)
C-----------------------------------------------------------------------
C       IF J .NE. 0, OUTPUT IS P = CIRCULAR COVERAGE FUNCTION. P GIVES
C       THE PROBABILITY OF A SHOT FALLING, UNDER A NORMAL DISTRIBUTION
C       WITH MEAN (0,0) AND EQUAL STANDARD DEVIATIONS, S, IN A CIRCLE
C       OF RADIUS R0, OFFSET A DISTANCE D0 FROM (0,0).
C       INPUT IS R = R0/S, D = D0/S.
C
C       IF J = 0, OUTPUT IS P = GENERALIZED CIRCULAR ERROR FUNCTION.
C       P GIVES THE PROBABILITY OF A SHOT FALLING ,UNDER A NORMAL
C       BIVARIATE DISTRIBUTION WITH MEAN (0,0) AND STANDARD DEVIATIONS
C       SMIN AND S, IN A CIRCLE OF RADIUS R0 CENTERED AT (0,0).
C       INPUT FOR J = 0, R = R0/S, D = SMIN/S .LE. 1.
C       IF SMIN = 0, S .NE. 0, P = ERF(R/(SQR(2)).
C
C       IF IERR .NE. 0, SOME PORTION OF THE INPUT IS UNACCEPTABLE.
C       IF R .LT. 0., THEN CIRCV SETS IERR = 1.
C       IF D .LT. 0, OR J = 0 AND D .GT. 1., THEN CIRCV SETS IERR = 2.
C
C       REFERENCES
C       MATH OF COMP APRIL 1961,PP169,173 AND OCT.1961, PP 375, 382.
C       NWL REPORT N0.1768, JAN. 1962. NSWC REPORT N0.83-13, NOV. 1982.
C       IEEE TRANS. INFO. TH. APRIL 1965, P. 312.
C-----------------------------------------------------------------------
C       NEGATIVE R AND D ARE NOT PERMITTED.
C--------------------------------------------
      REAL M, M0
C-----------------------
C     C1 = 1/SQRT(2)
C     C2 = 1/SQRT(PI)
C     C3 = 2*PI
C-----------------------
      DATA E  /2.71828182845905/
      DATA C1 /.707106781186548/
      DATA C2 /.564189583547756/
      DATA C3 /6.28318530717959/
C-----------------------
        P = 0.0
        IF (R .LT. 0.0) GOTO 115
        IF (D .LT. 0.0) GOTO 120
        IERR = 0
        IF (R .EQ. 0.0) RETURN
C
        EPS0 = SPMPAR(1)
        Z = - ALOG(EPS0)
        IF (J .NE. 0) GOTO 40
C------------------------------------------------------------------
C   FOR J = 0, ERROR IN D IF D .LT. 0 OR D .GT. 1
C------------------------------------------------------------------
C                J = 0
C--------------------------------------------------
        IF (D .GT. 1.0) GOTO 120
        IF (D .EQ. 1.0) GOTO 45
        IF (D .NE. 0.0) GOTO 5
C---------------------------------------
C          J = 0,     D = 0
C---------------------------------------
        P = ERF(R*C1)
        RETURN
C-------------------------------------------------
C   J = 0,  (R*R .GT. -2*LOG(EPS0))  P = 1
C-------------------------------------------------
    5   IF (R*R .LT. 2.0*Z) GOTO 10
        P = 1.0
        RETURN
C---------------------------------------------
   10   X = R
        D2 = D*D
        Y1 = R/D
        T = 0.5*Y1
        ZM = (0.5 - D2) + 0.5
        T2 = T*T
        T = T2*ZM
C
        EPS = 10.0*EPS0
        IF (T .GT. 14.0) GO TO 25
C-------------------------------------------------
C    J = 0,   T .LE. 14
C-------------------------------------------------
        ZP = 1.0 + D2
        ZR = ZM/ZP
        ZRS = ZR*ZR
        BK2 = T2*ZP
        C0 = 2.0*D/ZP
        S0 = EXP(-BK2)
        T0 = 0.5 + (0.5 - S0)
        IF (BK2 .LE. 0.15) T0 = -REXP(-BK2)
        T0 = C0*T0
        S0 = C0*S0
C
        P = T0
        AN = 0.0
   20      AN = AN + 2.0
           F = (AN - 1.0)/AN
           W = T/AN
           X = S0*W
           T0 = F*ZRS*T0 - (W + ZR)*X
           S0 = W*X
           P = P + T0
           IF (T0 .GT. EPS*P) GO TO 20
        RETURN
C------------------------------------------------
C   J = 0,    T .GT. 14
C------------------------------------------------
   25   T = 0.25/T
        CONST = D2/ZM
        DELTA = SQRT(ZM)
        X = 2.0*(C1*C2)/(R*DELTA)
        EXPT = EXP(-0.5*R*R)
        CALL ERFC0 (1, C1*R, EXPT, M)
        M = M/DELTA
C
        P = 1.0
        SUM = M
        AN = 0.0
        IF (EXPT*M .LT. 5.E-3) GO TO 30
C
C          SET  P = 1 - EXP(-R*R/2)*M
C
           P = (ERF(C1*R) - D2/(1.0 + DELTA))/DELTA
           SUM = 0.0
C
C          COMPUTE THE ASYMPTOTIC EXPANSION
C
   30      AN = AN + 2.0
           ANM1 = AN - 1.0
           F = ANM1/AN
           M0 = M
           M = CONST*F*(X - M)
           IF (M .GE. M0 .OR. M .LT. 0.0) GO TO 35
           X = ANM1*F*T*X
           SUM = SUM + M
           IF (M .GT. EPS*SUM) GO TO 30
   35   P = P - EXPT*SUM
        GO TO 110
C------------------------------------
C              J .NE. 0
C------------------------------------
   40   A1 = R - D
        T = R*D
        IF (D .NE. 0.0) GO TO 50
C----------------------------------------------
C     J = 0 AND D = 1, OR J .NE. 0 AND D = 0
C----------------------------------------------
   45   P = -REXP(-0.5*R*R)
        RETURN
C----------------------------------------
   50   A = 0.5*(A1*A1)
        IF (A1 .LE. 5.0) GO TO 55
        IF (A .LE. Z) GO TO 60
            P = 1.0
            RETURN
   55   IF (A1 .LT. -5.0 .AND. A .GT. -EXPARG(1)) RETURN
C----------------------------------------
   60   EPS = 1.5E2*EPS0
        IF (R .GE. 1.7 .AND. T .GT. 16.0) GO TO 75
C------------------------------------------------------------------
C      J .NE. 0,    R .LT. 1.7  OR  R*D .LE. 16
C------------------------------------------------------------------
        TR = 0.5*(R*R)
        TD = 0.5*(D*D)
C
C       FIND THE NUMBER N OF TERMS TO BE USED IN THE SERIES
C
        Z = 0.5*T
        N = Z*E + 1.0
        TN = ((E*Z/N)**(N + N))/(C3*N)
   65       N = N + 1
            W = Z/N
            TN = TN*(W*W)
            IF (TN .GT. EPS) GO TO 65
C
C       COMPUTE THE SERIES
C
        M = N
        CALL GRATIO (M + 1.0, TR, S, W, 0)
        W = RCOMP(M,TR)/M
        P = S
        DO 70 I = 1,N
            S = S + W
            W = (M/TR)*W
            P = S + (TD/M)*P
   70       M = M - 1.0
        P = EXP(-TD)*P
        GO TO 110
C------------------------------------------------------------------
C      J .NE. 0,    R .GE. 1.7  AND  R*D .GT. 16
C------------------------------------------------------------------
   75   Z = C1*ABS(A1)
        W = EXP(-A)
        CALL ERFC0 (1, Z, W, S1)
C
        A = 0.5*Z/T
        T = 0.25/T
        M = C2 - Z*S1
        IF (Z .GE. 4.0) M = ERFCR(Z)
        M = 0.5*A*M
        X = 0.5*C2*T
        S1 = S1 + M
        S2 = C2 + X
C
        AN = 2.0
   80       AN = AN + 2.0
            ANM1 = AN - 1.0
            F = ANM1/AN
            M0 = M
            M = F*A*(X - Z*M)
            X = F*(ANM1*T)*X
            S2 = S2 + X
            IF (M .LE. 0.0 .OR. M .GE. M0) GO TO 90
            S1 = S1 + M
            IF (M .GT. EPS*S1) GO TO 80
C
   90       AN = AN + 2.0
            ANM1 = AN - 1.0
            X0 = X
            X = (ANM1/AN)*(ANM1*T)*X
            IF (X .GE. X0) GO TO 100
            S2 = S2 + X
            IF (X .GT. EPS*S2) GO TO 90
C
  100   S1 = 0.5*(R + D)*S1
        S2 = C1*S2
        W = W/SQRT(R*D)
        P = 0.5*W*ABS(S1 - S2)
        IF (A1 .GT. 0.0) P = ABS(1.0 - 0.5*W*(S1 + S2))
C
C       TERMINATION
C
  110   IF (P .GT. 1.0) P = 1.0
        RETURN
  115   IERR = 1
        P = -1.0
        RETURN
  120   IERR = 2
        P = -1.0
        RETURN
        END
      SUBROUTINE ERFC0 (IND, X, E, Y)
C-----------------------------------------------------------------------
C         EVALUATION OF THE COMPLEMENTARY ERROR FUNCTION
C
C               Y = ERFC(X)            IF IND = 0
C               Y = EXP(X*X)*ERFC(X)   OTHERWISE
C
C     E IS AN INPUT/OUTPUT VARIABLE. IF E .GE. 0 THEN IT IS ASSUMED
C     THAT E = EXP(-X*X). IN THIS CASE E IS NOT MODIFIED. IF E IS
C     NEGATIVE THEN E IS SET TO EXP(-X*X) WHEN THIS VALUE IS NEEDED.
C
C-----------------------------------------------------------------------
      REAL A(4),B(4),P(8),Q(8),R(5),S(5)
      DOUBLE PRECISION W
C-------------------------
      DATA C/.564189583547756/
C-------------------------
      DATA A(1)/-1.65581836870402E-4/, A(2)/3.25324098357738E-2/,
     *     A(3)/1.02201136918406E-1/,  A(4)/1.12837916709552E00/
      DATA B(1)/4.64988945913179E-3/,  B(2)/7.01333417158511E-2/,
     *     B(3)/4.23906732683201E-1/,  B(4)/1.00000000000000E00/
      DATA P(1)/-1.36864857382717E-7/, P(2)/5.64195517478974E-1/,
     *     P(3)/7.21175825088309E00/,  P(4)/4.31622272220567E01/,
     *     P(5)/1.52989285046940E02/,  P(6)/3.39320816734344E02/,
     *     P(7)/4.51918953711873E02/,  P(8)/3.00459261020162E02/
      DATA Q(1)/1.00000000000000E00/,  Q(2)/1.27827273196294E01/,
     *     Q(3)/7.70001529352295E01/,  Q(4)/2.77585444743988E02/,
     *     Q(5)/6.38980264465631E02/,  Q(6)/9.31354094850610E02/,
     *     Q(7)/7.90950925327898E02/,  Q(8)/3.00459260956983E02/
      DATA R(1)/2.10144126479064E00/,  R(2)/2.62370141675169E01/,
     *     R(3)/2.13688200555087E01/,  R(4)/4.65807828718470E00/,
     *     R(5)/2.82094791773523E-1/
      DATA S(1)/9.41537750555460E01/,  S(2)/1.87114811799590E02/,
     *     S(3)/9.90191814623914E01/,  S(4)/1.80124575948747E01/,
     *     S(5)/1.00000000000000E00/
C-------------------------
C
C                     ABS(X) .LT. 0.47
C
      AX = ABS(X)
      IF (AX .GE. 0.47) GO TO 10
      T = X*X
      TOP = ((A(1)*T + A(2))*T + A(3))*T + A(4)
      BOT = ((B(1)*T + B(2))*T + B(3))*T + B(4)
      Y = 0.5 + (0.5 - X*TOP/BOT)
      IF (IND .EQ. 0) RETURN
C
      IF (E .LT. 0.0) E = EXP(-T)
      Y = Y/E
      RETURN
C
C                  0.47 .LE. ABS(X) .LE. 4
C
   10 IF (AX .GT. 4.0) GO TO 30
      TOP = ((((((P(1)*AX + P(2))*AX + P(3))*AX + P(4))*AX + P(5))*AX
     *                    + P(6))*AX + P(7))*AX + P(8)
      BOT = ((((((Q(1)*AX + Q(2))*AX + Q(3))*AX + Q(4))*AX + Q(5))*AX
     *                    + Q(6))*AX + Q(7))*AX + Q(8)
      Y = TOP/BOT
C
   20 IF (IND .EQ. 0) GO TO 21
         IF (X .GE. 0.0) RETURN
         IF (E .LT. 0.0) E = EXP(-X*X)
         Y = 2.0/E - Y
         RETURN
   21 W = DBLE(X)*DBLE(X)
      T = W
      EPS = W - DBLE(T)
      IF (E .LT. 0.0) E = EXP(-T)
      Y = ((0.5 + (0.5 - EPS)) * E) * Y
      IF (X .LT. 0.0) Y = 2.0 - Y
      RETURN
C
C                      ABS(X) .GT. 4
C
   30 IF (X .LE. -5.5) GO TO 40
      IF (IND .EQ. 0 .AND. X .GT. 50.0) GO TO 50
      T = (1.0/X)**2
      TOP = (((R(1)*T + R(2))*T + R(3))*T + R(4))*T + R(5)
      BOT = (((S(1)*T + S(2))*T + S(3))*T + S(4))*T + S(5)
      Y = (C - T*TOP/BOT) / AX
      GO TO 20
C
C             LIMIT VALUE FOR LARGE NEGATIVE X
C
   40 Y = 2.0
      IF (IND .EQ. 0) RETURN
      IF (E .LT. 0.0) E = EXP(-X*X)
      Y = 2.0/E
      RETURN
C
C             LIMIT VALUE FOR LARGE POSITIVE X
C                       WHEN IND = 0
C
   50 Y = 0.0
      RETURN
      END
      REAL FUNCTION ERFCR (X)
C-----------------------------------------------------------------------
C     COMPUTATION OF  1/SQRT(PI) - X*EXP(X*X)*ERFC(X)  FOR X .GE. 4
C-----------------------------------------------------------------------
      REAL R(5), S(4)
C------------------------
      DATA R(1)/2.10144126479064E+00/,  R(2)/2.62370141675169E+01/,
     *     R(3)/2.13688200555087E+01/,  R(4)/4.65807828718470E+00/,
     *     R(5)/2.82094791773523E-01/
      DATA S(1)/9.41537750555460E+01/,  S(2)/1.87114811799590E+02/,
     *     S(3)/9.90191814623914E+01/,  S(4)/1.80124575948747E+01/
C------------------------
      T = (1.0/X)**2
      TOP = (((R(1)*T + R(2))*T + R(3))*T + R(4))*T + R(5)
      BOT = (((S(1)*T + S(2))*T + S(3))*T + S(4))*T + 1.0
      ERFCR = T*TOP/BOT
      RETURN
      END
      SUBROUTINE PKILL (R0, SX, SY, H, K, P)
C-----------------------------------------------------------------------
C
C           COMPUTATION OF THE ELLIPTICAL COVERAGE FUNCTION
C
C                         ---------------
C
C     THE RESULT P IS ACCURATE TO AT LEAST 6 SIGNIFICANT DIGITS IF
C     P .GE. 1.E-20 AND MAX(H/S,K/S,SX/S,SY/S) .LE. 10/SQRT(SPMPAR(1))
C     FOR S = MIN(SX,SY).
C
C-----------------------------------------------------------------------
      REAL K, K8, V(16), W(16)
C-----------------------------------------------------------------------
C   V(*), W(*)-- GAUSSIAN ABSCISSAS AND WEIGHTS OF ORDER 32, ON (-1,1).
C-----------------------------------------------------------------------
      DATA V(1)  /.4830766568773832E-01/, V(2)  /.1444719615827965E+00/,
     *     V(3)  /.2392873622521371E+00/, V(4)  /.3318686022821276E+00/,
     *     V(5)  /.4213512761306353E+00/, V(6)  /.5068999089322294E+00/,
     *     V(7)  /.5877157572407623E+00/, V(8)  /.6630442669302152E+00/,
     *     V(9)  /.7321821187402897E+00/, V(10) /.7944837959679424E+00/,
     *     V(11) /.8493676137325700E+00/, V(12) /.8963211557660521E+00/,
     *     V(13) /.9349060759377397E+00/, V(14) /.9647622555875064E+00/,
     *     V(15) /.9856115115452683E+00/, V(16) /.9972638618494816E+00/
      DATA W(1)  /.9654008851472780E-01/, W(2)  /.9563872007927486E-01/,
     *     W(3)  /.9384439908080457E-01/, W(4)  /.9117387869576388E-01/,
     *     W(5)  /.8765209300440381E-01/, W(6)  /.8331192422694676E-01/,
     *     W(7)  /.7819389578707031E-01/, W(8)  /.7234579410884851E-01/,
     *     W(9)  /.6582222277636185E-01/, W(10) /.5868409347853555E-01/,
     *     W(11) /.5099805926237618E-01/, W(12) /.4283589802222668E-01/,
     *     W(13) /.3427386291302143E-01/, W(14) /.2539206530926206E-01/,
     *     W(15) /.1627439473090567E-01/, W(16) /.7018610009470097E-02/
C----------------------------------------
C     C = (2**.25)*GAMMA(3/4)/PI
C     RPI = 1/SQRT(PI)
C     RT2 = SQRT(2)
C----------------------------------------
      DATA A3  /20.0/
      DATA C   /.4638648042895004/
      DATA RPI /.5641895835477563/
      DATA RT2 /1.414213562373095/
C
      P = 0.0
      IF (SX .GT. 0.0 .AND. SY .GT. 0.0) GO TO 5
         P = -1.E10
         RETURN
    5 J = 0
      EPS = SPMPAR(1)
      SQEPS = SQRT(EPS)
      A = 6.5
C----------------------------------------
C     TEST NO.1 (REPORT 83-13).
C----------------------------------------
      Z3 = AMIN1(SQRT(SQRT(SPMPAR(2))),1.E-30)*SX*SY
      IF (R0*R0 .LE. Z3) RETURN
C
      H2 = H*H + K*K
      H8 = ABS(H)
      K8 = ABS(K)
      DM = AMAX1(SX,SY)
C-----------------------------------------
C     TEST NO.2 (REPORT 83-13).
C-----------------------------------------
      IF ((R0 - H8 + A3*SX) .LE. 0.0) RETURN
      IF ((R0 - K8 + A3*SY) .LE. 0.0) RETURN
C-----------------------------------------
C     TEST NO.3 (REPORT 83-13).
C-----------------------------------------
      C8 = - EPSLN(0)
C-----------EXP(-10.3026) = 3.35E(-5)---------
      A4 = AMAX1(C8 - 1.74249E1, 10.3026)
      A4 = SQRT(A4 + A4)
      H3 = (R0 - H)*(R0 + H)
      H5 = (R0 - K)*(R0 + K)
      S0 = A4*DM
      T = R0 - S0
      IF (T .LT. 0.0) GO TO 25
      IF (T*T .LT. H2) GO TO 25
      IF (R0 .LT. 1/SQEPS) GO TO 20
      T = H3 -2.0*R0*S0 + S0*S0 - K*K
      IF (ABS(H3) .LE. ABS(H5)) GO TO 10
      T = H5 - 2.0*R0*S0 + S0*S0 - H*H
   10 IF (T .LT. 0.0) GO TO 25
   20 P = 1.0
      RETURN
C-----------------------------------------
C     TEST NO.4 (REPORT 83-13).
C-----------------------------------------
   25 S0 = SQRT(H2)
      G2 = 0.0
      IF (S0 .LE. R0) GO TO 30
      D = ((S0 - R0)/DM)**2
      IF (R0*R0*EXP(-0.5*D) .LE. Z3) RETURN
C-----------------------------------------
C     SX - SY .LT. EPS
C-----------------------------------------
   30 IF (ABS(SX - SY) .GT. 20.0*DM*EPS) GO TO 33
      H8 = S0
      K8 = 0.0
      IF ((R0 - H8 + A3*DM) .LE. 0.0) RETURN
      IF (R0 .LT. DM/SQEPS) GO TO 33
      J = 1
      G2 = (K*K - H3)/((R0 + H8)*DM)
      IF (ABS(H3) .LE. ABS(H5)) GO TO 33
      G2 = (H*H - H5)/((R0 + H8)*DM)
C--------------------------
C     SMALL R
C--------------------------
   33 T1 = R0/SX
      T2 = R0/SY
      T3 = T1*T2
      T1 = T1*T1
      T2 = T2*T2
      Z1 = (H/SX)**2
      Z2 = (K/SY)**2
      T = T1*(Z1 - 1.0) + T2*(Z2 - 1.0)
      IF (ABS(T) .GT. 1.E-3) GO TO 35
      T9 = (T*T - 4.0*(T1*T1*(Z1 - 0.5) + T2*T2*(Z2 - 0.5)))/192.0
      IF (ABS(T9) .GT. AMAX1(10.0*EPS,1.E-10)) GO TO 35
      P = 0.5*T3*(1.0 + 0.125*T)*EXP(-0.5*(Z1 + Z2))
      RETURN
C-----------------------------------------------
C     NORMALIZE AMAX1(SX,SY) = 1.
C-----------------------------------------------
   35 R = R0/DM
      S1 = SX/DM
      S2 = SY/DM
      H8 = H8/DM
      K8 = K8/DM
      H2 = H2/(DM*DM)
C---------------------------------
C     S1 = 1 .GE. S2
C---------------------------------
      IF (S1 .GE. S2) GO TO 40
      H1 = S1
      S1 = S2
      S2 = H1
      H1 = H8
      H8 = K8
      K8 = H1
C-----------------------------------------------
C     LIMITING RESULTS FOR AMIN1(S1,S2) = 0
C-----------------------------------------------
   40 SEPS1 = AMIN1(6.71*SQEPS,1.E-5)
C-----------------------------------------------
C            R = K,  S2 SMALL
C-----------------------------------------------
      IF (K8 .NE. R) GO TO 45
      YY = .166484*(R*(H8*H8 + 1.0) + 1.0/R)*S2
      IF (ABS(YY) .GT. SEPS1) GO TO 85
      H1 = H8/RT2
      P = C*EXP(-H1*H1)*SQRT(K8*S2)
      RETURN
C-----------------------------------------------
C            R .GT. K,  S2 SMALL
C-----------------------------------------------
   45 IF (R .LT. K8) GO TO 85
      IF (K8 .NE. 0.0) GO TO 75
      H1 = S2*S2/(4.0*RT2*R)
      G2 = G2/RT2
      IF (J .EQ. 0) G2 = ABS(H8 - R)/RT2
      IF (ABS(G2) .LT. 4.0) GO TO 55
         IF (H1*ABS(G2) .GT. SEPS1) GO TO 85
         P = 0.5*AERF(H8/RT2,R/RT2)
         RETURN
   55 IF (J .NE. 0) GO TO 60
         P = 0.5*AERF(H8/RT2,R/RT2)
         GO TO 70
   60 IF (H8 + R .LT. RT2) GO TO 65
         P = 0.5*(ERFC(G2) - ERFC((H8 + R)/RT2))
         GO TO 70
   65 P = 0.5*(ERF((H8 + R)/RT2) - ERF(G2))
   70 IF (H1*EXP(-G2*G2) .GT. P*SEPS1) GO TO 85
      RETURN
C
   75 Z = (R - K8)*(R + K8)
      G2 = SQRT(Z)
      H1 = ABS(H8 - G2)
      J = 0
      IF (H1 .GT. 5.0) GO TO 80
         J = 1
         Z8 = AERF(H8/RT2,G2/RT2)
         IF (Z8 .EQ. 0.0) GO TO 85
         H1 = EXP(-0.5*(H8 - G2)**2)/Z8
   80 H1 = 1.0/(8.0*RT2*Z)*(K8*K8*ABS(H8 - G2) + R*R/G2)*S2*S2*H1
      IF (ABS(H1) .GT. SEPS1) GO TO 85
      U = 0.5
      IF (J .EQ. 0) Z8 = AERF(H8/RT2,G2/RT2)
      S2 = RT2*S2
      IF (K8 - R .GT. -13.0*S2) U = 0.25*AERF(K8/S2,R/S2)
      P = U*Z8
      RETURN
C----------------------------
C     FIND THE VALUE OF A
C----------------------------
   85 S0 = S1*S1
      S9 = S2*S2
      G3 = H8*H8
      G2 = K8*K8
      Z8 = S0 + S9
      Z = S0*S0 + S9*S9
      H3 = G3*S0 + G2*S9
      T1 = 2.0*(Z + 2*H3)
      YY = R*R*(H2 + Z8)/T1
      T1 = (H2 + Z8)*(H2 + Z8)/T1
      CALL GRATIO (T1,YY,Z,Z8,0)
      Z2 = R/(RT2*S2)
      R8 = R/(RT2*S1)
      H2 = H8/(RT2*S1)
      H3 = K8/(RT2*S2)
      S0 = 0.0
      S9 = 0.0
      IF (Z .LT. 1.E-13 .AND. S2 .GT. 5.E-10) GO TO 90
      IF (H2 .GT. 50.0 .OR. H3 .GT. 50.0) S0 = 1.5
   90 U = AERF(H3,Z2)
      YY = 0.25*U*AERF(H2,R8)
      IF (YY .GT. 0.1) S9 = 0.5
      IF (YY .GE. 5.E-15) GO TO 95
         Z = YY
         GO TO 100
   95 Z = AMIN1(YY,Z)
C
  100 IF (Z .GE. 0.5) GO TO 105
      A = A + .5
      IF (Z .GE. 5.E-4) GO TO 105
      A = A + .5 + S0
      IF (Z .GE. 1.E-6) GO TO 105
      A = A + .5 + S9
      IF (Z .GE. 5.E-9) GO TO 105
      A = A + .5
      IF (Z .GE. 5.E-10) GO TO 105
      A = A + .25
      IF (Z .GE. 5.E-11) GO TO 105
      A = A + .25
      IF (Z .GE. 5.E-12) GO TO 105
      A = A + .25
      IF (Z .GE. 5.E-13) GO TO 105
      A = A + .5 + .5*S9
      IF (Z .GT. 5.E-15) GO TO 105
      A = A + .5
      IF (Z .GT. 1.E-18) GO TO 105
      A = A + .25
      IF (Z .GT. 1.E-20) GO TO 105
      A = A + .25
      IF (Z .GT. 1.E-25) GO TO 105
      A = A + 1.
      IF (Z .GT. 1.E-30) GO TO 105
      A = A + 2.
C
  105 IF (S2 .GE. 5.E-2 .OR. H3 .LE. Z2) GO TO 107
      T9 = R8*U*EXP(-H2*H2)
      IF (T9 .LT. 5.E-2 * Z) A = A + 0.5
C---------------------------------------
C     START INTEGRATION PROCEDURE
C---------------------------------------
  107 S0 = S1
      S9 = S2
      Z8 = S2
      G2 = K8
      G3 = H8
      Z9 = S1
      J8 = 0
C-------------------------------------------------
C     DETERMINE INTERVAL OF INTEGRATION, (A,RT2).
C           E3 = (RT2-A)/2, D1 = (RT2+A)/2.
C-------------------------------------------------
  110 Z = G2 + A*Z8
      H3 = G2 - A*Z8
      H5 = 0.0
      T3 = -1.0
      A1 = (G3 - A*Z9)/R
      IF (ABS(A1 - 0.5) .GE. 0.5) GO TO 115
      A2 = AMAX1(((1.0 - G3/R) + A*Z9/R)*(1.0 + A1), 0.0)
      SA = SQRT(A2)
      IF (SA .LT. H3/R) GO TO 115
      T3 = A1/SQRT(1.0 + SA)
C----------------------------------------
C            T9 = 1.0 - D1
C----------------------------------------
  115 IF (H3 .GT. 0.0) GO TO 135
C----------------------------------------
C            H3 .LE. 0.0
C----------------------------------------
      IF (T3 .LT. 0.0) GO TO 120
         D2 = 0.5*(1.0 + T3)
         E4 = 0.25*SA/D2
         T5 = E4
  120 IF (Z .LT. R) GO TO 125
         E3 = 0.5
         D1 = E3
         T9 = D1
         GO TO 130
  125 D1 = 0.5*(1.0 + SQRT(1.0 - Z/R))
      E3 = 0.25*Z/(R*D1)
      T9 = E3
  130 IF (T3 .LE. D1 - E3)  GO TO 165
      GO TO 160
C----------------------------------------
C            H3 .GT. 0.0
C----------------------------------------
  135 H5 = 1.0
      Q = H3/R
      IF (Q .LE. 1.0) GO TO 140
         E3 = 0.5
         D1 = E3
         T9 = D1
         GO TO 165
  140 IF (T3 .LT. 0.0) GO TO 145
         E4 = AMAX1((1.0 - G2/R) + A*Z8/R, 0.0)
         E4 = SQRT(E4)
         D2 = 0.5*(E4 + T3)
         T5 = 0.5*(Q/(1.0 + E4) + SA/(1.0 + T3))
         E4 = 0.25*(SA - Q)/D2
  145 E3 = AMAX1((1.0 - G2/R) + A*Z8/R, 0.0)
      IF (Z .LT. R) GO TO 150
         E3 = 0.5*SQRT(E3)
         D1 = E3
         T9 = 0.25*(3.0 + H3/R)/(1.0 + E3)
         GO TO 155
  150 T9 = SQRT(E3)
      T2 = SQRT(1.0 - Z/R)
      D1 = 0.5*(T9 + T2)
      E3 = A*Z8/(R*2.0*D1)
      T9 = 0.5*((H3/R)/(1.0 + T9) + (Z/R)/(1.0 + T2))
  155 IF (T3 .LE. D1 - E3) GO TO 165
  160 E3 = E4
      D1 = D2
      T9 = T5
  165 IF (J8 .NE. 0) GO TO 170
      J8 = 1
      F = E3
      T = D1
      T1 = T9
      H6 = H5
      Z8 = S1
      G2 = H8
      G3 = K8
      Z9 = S2
      GO TO 110
C-----------------------------------------------------------------------
C     DETERMINE IN WHICH ORDER THE X AMD Y INTEGRATIONS ARE CARRIED OUT.
C-----------------------------------------------------------------------
  170 IF (S2 .GT. 2.E-2 .AND. H8 + K8 .LT. 2.E2) GO TO 172
      IF (ABS(E3 - F) .GT. 0.4*F) GO TO 172
      IF (D1 - T) 200,180,195
  172 IF (E3 .LT. 2.E4*EPS) GO TO 195
      IF (F .LT. 2.E4*EPS) GO TO 200
      IF (AMAX1(H8/S1,K8/S2) .LT. 2.0) GO TO 175
      IF (S2 .LT. 1.E-5) GO TO 175
      IF (S2 .GE. 5.E-4) GO TO 180
      IF (S1 .NE. S2) GO TO 195
  175 IF (AMIN1(E3,F) .LT. 2.5E-2*SQEPS) GOTO 185
  180 IF (E3 - F) 200,190,195
  185 IF (E3 - F) 195,190,200
  190 IF (S0 .GE. S9) GO TO 200
  195 E3 = F
      D1 = T
      T9 = T1
      S9 = S1
      S0 = S2
      Z8 = H8
      H8 = K8
      K8 = Z8
      H5 = H6
  200 Z2 = R/(RT2*S9)
      R8 = R/(RT2*S0)
      H2 = H8/(RT2*S0)
      H3 = K8/(RT2*S9)
      N1 = 16
      IZ = 0
      IZ3 = 0
      IY = 0
      P = 0.0
      T = H2 - R8 + R8*(D1 - E3*V(16))**2
      IF (T .GT. 0.0 .AND. T*T .GT. -EXPARG(1)) RETURN
C
      Q1 = RPI*E3*R8
      G3 = 0.0
      NT = 2*N1 + 1
      Z = (.5 + D1) +.5
      DO 260 II = 1, NT
         I = II - (N1 + 1)
         IF (I .EQ. 0) GO TO 260
         J = IABS(I)
         Q = E3*ISIGN(1,I)*V(J)
         T = Q + D1
         H6 = Z + Q
         Q = T9 - Q
         F = H6*Q
         T1 = R8*F
         T2 = (H2 - T1)*(H2 - T1)
         IF (H2 - R8 .GE. 0. .OR. T .LT. EPS) T2 =
     *       ((H2 - R8) + R8*T*T)**2
         T4 = EXP(-T2)
         IF (H2 .NE. 0.0) GO TO 210
            T4 = T4 + T4
            GO TO 215
  210    IF (H5 .NE. 0.0) GO TO 215
            T2 = 4.0*H2*T1
            IF (T2 .GT. C8) GO TO 215
            T4 = T4*(1.0 + EXP(-T2))
  215    IF (IZ .NE. 0) GO TO 255
         G2 = SQRT(1.0 + F)
         Z1 = Z2*T*G2
         X1 = H3 - Z1
         IF (X1 .GT. -A) GO TO 225
            IZ = 1
            X5 = 2.0
            GO TO 255
  225    IF (ABS(X1) .GT. 1.E-2*Z1) GO TO 230
            IY = 1
            X1 = ((K8 - R) + R*F*F/(1.0 + T*G2))/(RT2*S9)
  230    IF (IZ3 .NE. 0) GO TO 250
         SA = H3 + Z1
         IF (SA .GT. A3) GO TO 245
         IF (IY .EQ. 0) GO TO 240
         IF (X1 .GT. RT2) GO TO 235
            X5 = ERF(SA) - ERF(X1)
            GO TO 255
  235    X5 = ERFC(X1) - ERFC(SA)
         GO TO 255
  240    X5 = AERF(H3,Z1)
         GO TO 255
  245    IZ3 = 1
  250    X5 = ERFC(X1)
  255    G3 = G3 + X5*T4*T*W(J)
  260 CONTINUE
      P = Q1*G3
      IF (P .GT. YY) P = YY
      IF (P .GT. (1.0 - AMIN1(1.E6*EPS,1.E-5))) P = 1.0
      IF (P .LT. 0.0) P = 0.0
      RETURN
      END
      SUBROUTINE PLCOPY (A,KA,M,B,KB,N)
C     ------------------------------------------------------------------
C     COPYING REAL POLYNOMIALS
C     ------------------------------------------------------------------
      REAL A(*), B(*)
C
      LA = 1
      LB = 1
      JMAX = MIN0(M, N)
      DO 10 J = 1,JMAX
         B(LB) = A(LA)
         LA = LA + KA
         LB = LB + KB
   10 CONTINUE
      IF (JMAX .EQ. N) RETURN
C
      MP1 = M + 1
      DO 20 J = MP1,N
         B(LB) = 0.0
         LB = LB + KB
   20 CONTINUE
      RETURN
      END
      SUBROUTINE DPCOPY (A,KA,M,B,KB,N)
C     ------------------------------------------------------------------
C     COPYING DOUBLE PRECISION POLYNOMIALS
C     ------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*)
C
      LA = 1
      LB = 1
      JMAX = MIN0(M, N)
      DO 10 J = 1,JMAX
         B(LB) = A(LA)
         LA = LA + KA
         LB = LB + KB
   10 CONTINUE
      IF (JMAX .EQ. N) RETURN
C
      MP1 = M + 1
      DO 20 J = MP1,N
         B(LB) = 0.D0
         LB = LB + KB
   20 CONTINUE
      RETURN
      END
      SUBROUTINE PADD (A,KA,L,B,KB,M,C,KC,N)
C     ------------------------------------------------------------------
C     ADDITION OF REAL POLYNOMIALS
C     ------------------------------------------------------------------
      REAL A(*), B(*), C(*)
C
      LA = 1
      LB = 1
      LC = 1
      DO 10 I = 1,N
         C(LC) = 0.0
         IF (I .LE. L) C(LC) = A(LA)
         IF (I .LE. M) C(LC) = C(LC) + B(LB)
         LA = LA + KA
         LB = LB + KB
         LC = LC + KC
   10 CONTINUE
      RETURN
      END
      SUBROUTINE DPADD (A,KA,L,B,KB,M,C,KC,N)
C     ------------------------------------------------------------------
C     ADDITION OF DOUBLE PRECISION POLYNOMIALS
C     ------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), C(*)
C
      LA = 1
      LB = 1
      LC = 1
      DO 10 I = 1,N
         C(LC) = 0.D0
         IF (I .LE. L) C(LC) = A(LA)
         IF (I .LE. M) C(LC) = C(LC) + B(LB)
         LA = LA + KA
         LB = LB + KB
         LC = LC + KC
   10 CONTINUE
      RETURN
      END
      SUBROUTINE PSUBT (A,KA,L,B,KB,M,C,KC,N)
C     ------------------------------------------------------------------
C     SUBTRACTION OF REAL POLYNOMIALS
C     ------------------------------------------------------------------
      REAL A(*), B(*), C(*)
C
      LA = 1
      LB = 1
      LC = 1
      DO 10 I = 1,N
         C(LC) = 0.0
         IF (I .LE. L) C(LC) = A(LA)
         IF (I .LE. M) C(LC) = C(LC) - B(LB)
         LA = LA + KA
         LB = LB + KB
         LC = LC + KC
   10 CONTINUE
      RETURN
      END
      SUBROUTINE DPSUBT (A,KA,L,B,KB,M,C,KC,N)
C     ------------------------------------------------------------------
C     SUBTRACTION OF DOUBLE PRECISION POLYNOMIALS
C     ------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), C(*)
C
      LA = 1
      LB = 1
      LC = 1
      DO 10 I = 1,N
         C(LC) = 0.D0
         IF (I .LE. L) C(LC) = A(LA)
         IF (I .LE. M) C(LC) = C(LC) - B(LB)
         LA = LA + KA
         LB = LB + KB
         LC = LC + KC
   10 CONTINUE
      RETURN
      END
      SUBROUTINE PMULT (A,KA,L,B,KB,M,C,KC,N)
C     ------------------------------------------------------------------
C     MULTIPLICATION OF REAL POLYNOMIALS
C     ------------------------------------------------------------------
      REAL A(*), B(*), C(*)
      DOUBLE PRECISION DSUM
C
      LC = 1
      JMAX = MIN0(L + M - 1, N)
      DO 40 J = 1,JMAX
         IF (J .LE. L) GO TO 10
            IMIN = 1 + (J - L)
            LA = 1 + (L - 1)*KA
            LB = 1 + (IMIN - 1)*KB
            GO TO 20
   10    IMIN = 1
         LA = 1 + (J - 1)*KA
         LB = 1
C
   20    IMAX = MIN0(J, M)
         DSUM = 0.D0
         DO 30 I = IMIN,IMAX
            DSUM = DSUM + DBLE(A(LA))*DBLE(B(LB))
            LA = LA - KA
            LB = LB + KB
   30    CONTINUE
         C(LC) = DSUM
   40 LC = LC + KC
      IF (JMAX .EQ. N) RETURN
C
      JMIN = JMAX + 1
      DO 60 J = JMIN,N
         C(LC) = 0.0
   60 LC = LC + KC
      RETURN
      END
      SUBROUTINE DPMULT (A,KA,L,B,KB,M,C,KC,N)
C     ------------------------------------------------------------------
C     MULTIPLICATION OF DOUBLE PRECISION POLYNOMIALS
C     ------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), C(*)
      DOUBLE PRECISION SUM
C
      LC = 1
      JMAX = MIN0(L + M - 1, N)
      DO 40 J = 1,JMAX
         IF (J .LE. L) GO TO 10
            IMIN = 1 + (J - L)
            LA = 1 + (L - 1)*KA
            LB = 1 + (IMIN - 1)*KB
            GO TO 20
   10    IMIN = 1
         LA = 1 + (J - 1)*KA
         LB = 1
C
   20    IMAX = MIN0(J, M)
         SUM = 0.D0
         DO 30 I = IMIN,IMAX
            SUM = SUM + A(LA)*B(LB)
            LA = LA - KA
            LB = LB + KB
   30    CONTINUE
         C(LC) = SUM
   40 LC = LC + KC
      IF (JMAX .EQ. N) RETURN
C
      JMIN = JMAX + 1
      DO 60 J = JMIN,N
         C(LC) = 0.D0
   60 LC = LC + KC
      RETURN
      END
      SUBROUTINE PDIV (A,KA,L,B,KB,M,C,KC,N,IERR)
C     ------------------------------------------------------------------
C     DIVISION OF REAL POLYNOMIALS
C     ------------------------------------------------------------------
      REAL A(*), B(*), C(*)
      DOUBLE PRECISION DSUM
C
      B0 = B(1)
      IF (B0 .EQ. 0.0) GO TO 100
      IERR = 0
      C(1) = A(1)/B0
      IF (N .EQ. 1) RETURN
C
C               CASE WHEN M = 1
C
      IF (M .GT. 1) GO TO 20
      LA = 1
      LC = 1
      DO 10 J = 2,N
         LA = LA + KA
         LC = LC + KC
         C(LC) = 0.0
         IF (J .LE. L) C(LC) = A(LA)/B0
   10 CONTINUE
      RETURN
C
C              CASE WHEN M .GT. 1
C
   20 LA = 1
      LC = 1
      DO 40 J = 2,N
         LA = LA + KA
         LC = LC + KC
         IB = 1
         IC = LC
         DSUM = 0.D0
         IF (J .LE. L) DSUM = A(LA)
         IMAX = MIN0(J, M)
         DO 30 I = 2,IMAX
            IB = IB + KB
            IC = IC - KC
            DSUM = DSUM - DBLE(B(IB))*DBLE(C(IC))
   30    CONTINUE
         C(LC) = SNGL(DSUM)/B0
   40 CONTINUE
      RETURN
C
C                ERROR RETURN
C
  100 IERR = 1
      RETURN
      END
      SUBROUTINE DPDIV (A,KA,L,B,KB,M,C,KC,N,IERR)
C     ------------------------------------------------------------------
C     DIVISION OF DOUBLE PRECISION POLYNOMIALS
C     ------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), C(*)
      DOUBLE PRECISION B0, SUM
C
      B0 = B(1)
      IF (B0 .EQ. 0.D0) GO TO 100
      IERR = 0
      C(1) = A(1)/B0
      IF (N .EQ. 1) RETURN
C
C               CASE WHEN M = 1
C
      IF (M .GT. 1) GO TO 20
      LA = 1
      LC = 1
      DO 10 J = 2,N
         LA = LA + KA
         LC = LC + KC
         C(LC) = 0.D0
         IF (J .LE. L) C(LC) = A(LA)/B0
   10 CONTINUE
      RETURN
C
C              CASE WHEN M .GT. 1
C
   20 LA = 1
      LC = 1
      DO 40 J = 2,N
         LA = LA + KA
         LC = LC + KC
         IB = 1
         IC = LC
         SUM = 0.D0
         IF (J .LE. L) SUM = A(LA)
         IMAX = MIN0(J, M)
         DO 30 I = 2,IMAX
            IB = IB + KB
            IC = IC - KC
            SUM = SUM - B(IB)*C(IC)
   30    CONTINUE
         C(LC) = SUM/B0
   40 CONTINUE
      RETURN
C
C                ERROR RETURN
C
  100 IERR = 1
      RETURN
      END
      SUBROUTINE PLPWR(R,A,KA,M,B,KB,N,IERR)
C     ------------------------------------------------------------------
C     SET B = A**R WHERE A IS A REAL POLYNOMIAL
C     ------------------------------------------------------------------
      REAL A(*), B(*)
      REAL JM1
      DOUBLE PRECISION COEFF, DSUM, RP1
C
      A0 = A(1)
      IF (A0 .LE. 0.0) GO TO 100
      IERR = 0
      B(1) = A0**R
      IF (N .EQ. 1) RETURN
C
C            CASE WHEN M = 1 OR R = 0
C
      IF (M .GT. 1 .AND. R .NE. 0.0) GO TO 20
      LB = 1
      DO 10 J = 2,N
         LB = LB + KB
         B(LB) = 0.0
   10 CONTINUE
      RETURN
C
C                  GENERAL CASE
C
   20 RP1 = DBLE(R) + 1.D0
      LB = 1
      DO 40 J = 2,N
         LB = LB + KB
         JM1 = J - 1
         IA = 1
         IB = LB
         COEFF = -JM1
         DSUM = 0.D0
         IMAX = MIN0(J, M)
         DO 30 I = 2,IMAX
            IA = IA + KA
            IB = IB - KB
            COEFF = COEFF + RP1
            DSUM = DSUM + COEFF*DBLE(A(IA))*DBLE(B(IB))
   30    CONTINUE
         B(LB) = SNGL(DSUM)/(JM1*A0)
   40 CONTINUE
      RETURN
C
C                ERROR RETURN
C
  100 IERR = 1
      RETURN
      END
      SUBROUTINE DPLPWR(R,A,KA,M,B,KB,N,IERR)
C     ------------------------------------------------------------------
C     SET B = A**R WHERE A IS A DOUBLE PRECISION POLYNOMIAL
C     ------------------------------------------------------------------
      DOUBLE PRECISION A(*), B(*), R
      DOUBLE PRECISION A0, COEFF, JM1, RP1, SUM
C
      A0 = A(1)
      IF (A0 .LE. 0.D0) GO TO 100
      IERR = 0
      B(1) = A0**R
      IF (N .EQ. 1) RETURN
C
C            CASE WHEN M = 1 OR R = 0
C
      IF (M .GT. 1 .AND. R .NE. 0.D0) GO TO 20
      LB = 1
      DO 10 J = 2,N
         LB = LB + KB
         B(LB) = 0.D0
   10 CONTINUE
      RETURN
C
C                  GENERAL CASE
C
   20 RP1 = R + 1.D0
      LB = 1
      DO 40 J = 2,N
         LB = LB + KB
         JM1 = J - 1
         IA = 1
         IB = LB
         COEFF = -JM1
         SUM = 0.D0
         IMAX = MIN0(J, M)
         DO 30 I = 2,IMAX
            IA = IA + KA
            IB = IB - KB
            COEFF = COEFF + RP1
            SUM = SUM + COEFF*A(IA)*B(IB)
   30    CONTINUE
         B(LB) = SUM/(JM1*A0)
   40 CONTINUE
      RETURN
C
C                ERROR RETURN
C
  100 IERR = 1
      RETURN
      END
      SUBROUTINE PINV (A, D, N, Q)
C-----------------------------------------------------------------------
C          COMPUTATION OF THE INVERSE OF THE POWER SERIES
C                  SUM (A(I)*X**I, I = 1,2,...)
C-----------------------------------------------------------------------
      REAL A(N), D(N), Q(*)
C----------------------------
C     NUM = (N*(N + 1))/2
C     REAL Q(NUM)
C----------------------------
C
C                 COMPUTE THE COEFFICIENT MATRIX Q
C
      Q(1) = 1.0
      K = 2
      DO 10 I = 2,N
         Q(K) = 0.0
   10 K = K + I
C
      JJ = 1
      DO 22 J = 2,N
         L0 = JJ
         JJ = (J*(J + 1))/2
         K = JJ
         DO 21 I = J,N
            SUM = 0.0
            M = I - J + 2
            LL = L0
            DO 20 L = J,I
               SUM = SUM + A(M)*Q(LL)
               M = M - 1
               LL = LL + (L - 1)
   20       CONTINUE
            Q(K) = SUM
            K = K + I
   21    CONTINUE
   22 CONTINUE
C
C              COMPUTE THE COEFFICIENTS OF THE INVERSE
C
      K = 1
      DO 31 J = 1,N
         U = 1.0/(J*A(1)**J)
         SUM = 0.0
         DO 30 L = 1,J
            SUM = SUM + U*Q(K)
            S = L + J - 1
            T = L
            U = -(S*U)/(T*A(1))
            K = K + 1
   30    CONTINUE
         D(J) = SUM
   31 CONTINUE
      RETURN
      END
      SUBROUTINE DPINV (A, D, N, Q)
C-----------------------------------------------------------------------
C          COMPUTATION OF THE INVERSE OF THE POWER SERIES
C                  SUM (A(I)*X**I, I = 1,2,...)
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(N), D(N), Q(*)
      DOUBLE PRECISION S, SUM, T, U
C----------------------------
C     NUM = (N*(N + 1))/2
C     REAL Q(NUM)
C----------------------------
C
C                 COMPUTE THE COEFFICIENT MATRIX Q
C
      Q(1) = 1.D0
      K = 2
      DO 10 I = 2,N
         Q(K) = 0.D0
   10 K = K + I
C
      JJ = 1
      DO 22 J = 2,N
         L0 = JJ
         JJ = (J*(J + 1))/2
         K = JJ
         DO 21 I = J,N
            SUM = 0.D0
            M = I - J + 2
            LL = L0
            DO 20 L = J,I
               SUM = SUM + A(M)*Q(LL)
               M = M - 1
               LL = LL + (L - 1)
   20       CONTINUE
            Q(K) = SUM
            K = K + I
   21    CONTINUE
   22 CONTINUE
C
C              COMPUTE THE COEFFICIENTS OF THE INVERSE
C
      K = 1
      DO 31 J = 1,N
         U = 1.D0/(J*A(1)**J)
         SUM = 0.D0
         DO 30 L = 1,J
            SUM = SUM + U*Q(K)
            S = L + J - 1
            T = L
            U = -(S*U)/(T*A(1))
            K = K + 1
   30    CONTINUE
         D(J) = SUM
   31 CONTINUE
      RETURN
      END
      SUBROUTINE MPLNMV (MO, AU, NC, AC, FV)
C     ******************************************************************
C     FORTRAN SUBROUTINE FOR MULTIPLEX POLYNOMIAL EVALUATION
C     ******************************************************************
C     MO = MODE OF OPERATION
C     AU = ARGUMENT U
C     NC = NUMBER OF COEFFICIENTS
C     AC = ARRAY OF COEFFICIENTS
C     FV = FUNCTION V
C
C     MO = -1 FOR INTEGRAL
C     MO =  0 FOR FUNCTION
C     MO = +1 FOR FIRST DERIVATIVE
C     MO = +2 FOR SECOND DERIVATIVE
C
      DIMENSION AC(*)
  001 FV=0.0
      L=NC
      IF(MO.LT.0)GO TO 002
      IF(MO.EQ.0)GO TO 004
      IF(MO.EQ.1)GO TO 006
      IF(MO.GE.2)GO TO 008
  002 QL=NC
      DO 003 K=1,NC
      FV=AC(L)/QL+AU*FV
      L=L-1
      QL=QL-1.0
  003 CONTINUE
      FV=AU*FV
      RETURN
  004 DO 005 K=1,NC
      FV=AC(L)+AU*FV
      L=L-1
  005 CONTINUE
      RETURN
  006 IF(NC.LE.1)RETURN
      QL=NC
      DO 007 K=2,NC
      QL=QL-1.0
      FV=QL*AC(L)+AU*FV
      L=L-1
  007 CONTINUE
      RETURN
  008 IF(NC.LE.2)RETURN
      QL=NC
      DO 009 K=3,NC
      QL=QL-1.0
      FV=QL*(QL-1.0)*AC(L)+AU*FV
      L=L-1
  009 CONTINUE
      RETURN
      END
      REAL FUNCTION CSEVL (X, A, N)
C-----------------------------------------------------------------------
C          EVALUATE THE N TERM CHEBYSHEV SERIES A AT X.
C          ONLY HALF OF THE FIRST COEFFICIENT IS USED.
C-----------------------------------------------------------------------
      REAL A(N)
C
      IF (N .GT. 1) GO TO 10
         CSEVL = 0.5 * A(1)
         RETURN
C
   10 X2 = X + X
      S0 = A(N)
      S1 = 0.0
      DO 20 I = 2,N
         S2 = S1
         S1 = S0
         K = N - I + 1
         S0 = X2*S1 - S2 + A(K)
   20 CONTINUE
      CSEVL = 0.5 * (S0 - S2)
      RETURN
      END
      DOUBLE PRECISION FUNCTION DCSEVL (X, A, N)
C-----------------------------------------------------------------------
C          EVALUATE THE N TERM CHEBYSHEV SERIES A AT X.
C          ONLY HALF OF THE FIRST COEFFICIENT IS USED.
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(N),X,X2,S0,S1,S2
C
      IF (N .GT. 1) GO TO 10
         DCSEVL = 0.5D0 * A(1)
         RETURN
C
   10 X2 = X + X
      S0 = A(N)
      S1 = 0.D0
      DO 20 I = 2,N
         S2 = S1
         S1 = S0
         K = N - I + 1
         S0 = X2*S1 - S2 + A(K)
   20 CONTINUE
      DCSEVL = 0.5D0 * (S0 - S2)
      RETURN
      END
      SUBROUTINE LGRNGN (AU, NA, AN)
C     ******************************************************************
C     FORTRAN SUBROUTINE FOR LAGRANGIAN NORMALIZATION FACTORS
C     ******************************************************************
C     AU = COORDINATE ARGUMENTS  (N-ARRAY)
C     NA = NUMBER OF ARGUMENTS   (N)
C     AN = NORMALIZATION FACTORS (N-ARRAY)
C
      DIMENSION AU(*), AN(*)
  001 DO 003 K=1,NA
      TM=1.0
      DO 002 M=1,NA
      IF(M.EQ.K)GO TO 002
      DM=AU(K)-AU(M)
      TM=DM*TM
  002 CONTINUE
      AN(K)=TM
  003 CONTINUE
      RETURN
      END
      SUBROUTINE LGRNGV (MO, NA, QU, AU, AN, FF, DF, SF)
C     ******************************************************************
C     FORTRAN SUBROUTINE FOR LAGRANGIAN FUNCTION EVALUATION
C     ******************************************************************
C     MO = MODE OF OPERATION
C     NA = NUMBER OF STATIONS
C     QU = ARGUMENT OF FUNCTIONS
C     AU = STATION COORDINATES                    (N-ARRAY)
C     AN = NORMALIZATION FACTORS                  (N-ARRAY)
C     FF = LAGRANGIAN FUNCTIONS                   (N-ARRAY)
C     DF = FIRST DERIVATIVES                      (N-ARRAY)
C     SF = SECOND DERIVATIVES                     (N-ARRAY)
C
C     CALL LGRNGV (0, NA, QU, AU, AN, FF)         FOR FUNCTIONS
C     CALL LGRNGV (1, NA, QU, AU, AN, FF, DF)     FOR FIRST DERIVATIVES
C     CALL LGRNGV (2, NA, QU, AU, AN, FF, DF, SF) FOR SECOND DERIVATIVES
C
      DIMENSION AU(*), AN(*), FF(*), DF(*), SF(*)
      LOGICAL LN
  001 LN=.TRUE.
      TM=1.0
      DO 003 K=1,NA
      IF(QU.NE.AU(K))GO TO 002
      LN=.FALSE.
      GO TO 003
  002 DM=QU-AU(K)
      TM=DM*TM
  003 CONTINUE
      DO 007 K=1,NA
      IF(LN)GO TO 005
      IF(QU.NE.AU(K))GO TO 005
      FF(K)=TM
      GO TO 006
  005 DM=QU-AU(K)
      FF(K)=TM/DM
  006 FF(K)=FF(K)/AN(K)
  007 CONTINUE
      IF(MO.LE.0)GO TO 050
      SM=0.0
      DO 013 K=1,NA
      DF(K)=SM
      IF(LN)GO TO 012
      IF(QU.EQ.AU(K))GO TO 013
  012 DM=QU-AU(K)
      SM=SM+1.0/DM
  013 CONTINUE
      RM=SM
      IF(MO.EQ.1)GO TO 040
      SM=0.0
      DO 023 K=1,NA
      SF(K)=SM
      IF(LN)GO TO 022
      IF(QU.EQ.AU(K))GO TO 023
  022 DM=QU-AU(K)
      SM=SM+2.0*DF(K)/DM
  023 CONTINUE
      SM=0.0
      TM=0.0
      L=NA
      IF(LN)GO TO 034
      DO 033 K=1,NA
      SF(L)=TM+SF(L)+2.0*SM*DF(L)
      IF(QU.EQ.AU(L))GO TO 032
      SF(L)=2.0*(SM+DF(L))
      DM=QU-AU(L)
      TM=TM+2.0*SM/DM
      SM=SM+1.0/DM
  032 L=L-1
  033 CONTINUE
      GO TO 036
  034 DO 035 K=1,NA
      SF(L)=TM+SF(L)+2.0*SM*DF(L)
      DM=QU-AU(L)
      TM=TM+2.0*SM/DM
      SM=SM+1.0/DM
      L=L-1
  035 CONTINUE
  036 DO 037 K=1,NA
      SF(K)=FF(K)*SF(K)
  037 CONTINUE
  040 IF (LN) GO TO 043
      DO 042 K=1,NA
      IF (QU.NE.AU(K)) GO TO 041
      DF(K)=RM
      FF(K)=1.0
      GO TO 042
  041 DF(K)=FF(K)
      FF(K)=0.0
  042 CONTINUE
      RETURN
  043 SM=0.0
      L=NA
      DO 044 K=1,NA
      DF(L)=FF(L)*(SM+DF(L))
      SM=SM+1.0/(QU-AU(L))
      L=L-1
  044 CONTINUE
      RETURN
  050 IF(LN)GO TO 053
      DO 052 K=1,NA
      FF(K)=0.0
      IF(QU.NE.AU(K))GO TO 052
      FF(K)=1.0
  052 CONTINUE
  053 RETURN
      END
      SUBROUTINE LGRNGX (AU, NA, AC)
C     ******************************************************************
C     FORTRAN SUBROUTINE FOR LAGRANGIAN POLYNOMIAL EXPANSION
C     ******************************************************************
C     AU = COORDINATE ARGUMENTS    (N-ARRAY)
C     NA = NUMBER OF ARGUMENTS     (N)
C     AC = POLYNOMIAL COEFFICIENTS (NX(N+1) ARRAY)
C
      DIMENSION AU(*), AC(*)
  001 DO 003 I=1,NA
      K=(I-1)*NA
      L=K+I
      AC(L)=1.0
      SM=0.0
      DO 002 J=1,I
      K=K+1
      L=K+NA
      AC(L)=SM-AU(I)*AC(K)
      SM=AC(K)
  002 CONTINUE
  003 CONTINUE
      DO 005 I=1,NA
      K=NA+NA*NA
      L=I*NA
      AC(L)=1.0
      DO 004 J=2,NA
      SM=AU(I)*AC(L)
      L=L-1
      AC(L)=SM+AC(K)
      K=K-1
  004 CONTINUE
  005 CONTINUE
      DO 008 I=1,NA
      TM=1.0
      DO 006 J=1,NA
      IF(J.EQ.I)GO TO 006
      TD=AU(I)-AU(J)
      TM=TM*TD
  006 CONTINUE
      K=(I-1)*NA
      DO 007 J=1,NA
      K=K+1
      AC(K)=AC(K)/TM
  007 CONTINUE
  008 CONTINUE
      RETURN
      END
      SUBROUTINE ORTHOS (AU, MA, AA, NA, AR)
C     ******************************************************************
C     FORTRAN SUBROUTINE FOR ORTHONORMAL POLYNOMIAL SYNTHESIS
C     ******************************************************************
C     AU = COORDINATE ARGUMENTS    (N ARRAY)
C     MA = NUMBER OF COLUMNS       (M)
C     AA = MATRIX OF POLYNOMIALS   (NXM ARRAY)
C     NA = NUMBER OF ROWS          (N)
C     AR = RECURRENCE COEFFICIENTS (2*M-2 ARRAY)
C
      DIMENSION AU(*), AA(*), AR(*)
  001 SN=NA
      RN=SQRT(SN)
      DO 002 I=1,NA
      AA(I)=1.0/RN
  002 CONTINUE
      IF(MA.EQ.1)RETURN
  003 SM=0.0
      DO 004 I=1,NA
      SM=SM+AU(I)
  004 CONTINUE
      AR(2)=SM/SN
      SM=0.0
      L=NA
      DO 005 I=1,NA
      L=L+1
      AA(L)=AU(I)-AR(2)
      SM=SM+AA(L)*AA(L)
  005 CONTINUE
      RM=SQRT(SM)
      L=NA
      DO 006 I=1,NA
      L=L+1
      AA(L)=AA(L)/RM
  006 CONTINUE
      SM=0.0
      L=NA
      DO 007 I=1,NA
      L=L+1
      SM=SM+AU(I)*AA(L)
  007 CONTINUE
      AR(1)=SM/RN
      IF(MA.EQ.2)RETURN
  008 DO 013 M=3,MA
      SM=0.0
      K=(M-2)*NA
      DO 009 I=1,NA
      K=K+1
      SM=SM+AU(I)*AA(K)*AA(K)
  009 CONTINUE
      AR(2*M-2)=SM
      SM=0.0
      J=(M-3)*NA
      DO 010 I=1,NA
      J=J+1
      K=J+NA
      L=K+NA
      AA(L)=AU(I)*AA(K)-AR(2*M-2)*AA(K)-AR(2*M-5)*AA(J)
      SM=SM+AA(L)*AA(L)
  010 CONTINUE
      RM=SQRT(SM)
      L=(M-1)*NA
      DO 011 I=1,NA
      L=L+1
      AA(L)=AA(L)/RM
  011 CONTINUE
      SM=0.0
      K=(M-2)*NA
      DO 012 I=1,NA
      K=K+1
      L=K+NA
      SM=SM+AU(I)*AA(K)*AA(L)
  012 CONTINUE
      AR(2*M-3)=SM
  013 CONTINUE
      RETURN
      END
      SUBROUTINE ORTHOV (MO, NA, AU, AR, NF, FF, DF, SF)
C     ******************************************************************
C     FORTRAN SUBROUTINE FOR ORTHONORMAL POLYNOMIAL EVALUATION
C     ******************************************************************
C     MO = MODE OF OPERATION
C     NA = NUMBER OF COORDINATES
C     AU = ARGUMENT OF FUNCTIONS
C     AR = RECURRENCE COEFFICIENTS                (2*M-2 ARRAY)
C     NF = NUMBER OF FUNCTIONS                    (M)
C     FF = ORTHONORMAL FUNCTIONS                  (M-ARRAY)
C     DF = FIRST DERIVATIVES                      (M-ARRAY)
C     SF = SECOND DERIVATIVES                     (M-ARRAY)
C
C     CALL ORTHOV (0, NA, AU, AR, NF, FF)         FOR FUNCTIONS
C     CALL ORTHOV (1, NA, AU, AR, NF, FF, DF)     FOR FIRST DERIVATIVES
C     CALL ORTHOV (2, NA, AU, AR, NF, FF, DF, SF) FOR SECOND DERIVATIVES
C
      DIMENSION AR(*), FF(*), DF(*), SF(*)
  001 SN=NA
      RN=SQRT(SN)
      FF(1)=1.0/RN
      IF(NF.LE.1)GO TO 003
      FF(2)=(AU-AR(2))*FF(1)/AR(1)
      IF(NF.EQ.2)GO TO 003
      L=2
      DO 002 K=3,NF
      L=L+2
      FF(K)=((AU-AR(L))*FF(K-1)-AR(L-3)*FF(K-2))/AR(L-1)
  002 CONTINUE
  003 IF(MO.LE.0)RETURN
      DF(1)=0.0
      IF(NF.LE.1)GO TO 005
      DF(2)=FF(1)/AR(1)
      IF(NF.EQ.2)GO TO 005
      L=2
      DO 004 K=3,NF
      L=L+2
      DF(K)=(FF(K-1)+(AU-AR(L))*DF(K-1)-AR(L-3)*DF(K-2))/AR(L-1)
  004 CONTINUE
  005 IF(MO.EQ.1)RETURN
      SF(1)=0.0
      IF(NF.LE.1)GO TO 007
      SF(2)=0.0
      IF(NF.EQ.2)GO TO 007
      L=2
      DO 006 K=3,NF
      L=L+2
      SF(K)=(2.0*DF(K-1)+(AU-AR(L))*SF(K-1)-AR(L-3)*SF(K-2))/AR(L-1)
  006 CONTINUE
  007 RETURN
      END
      SUBROUTINE ORTHOX (NA, AR, NC, AC)
C     ******************************************************************
C     FORTRAN SUBROUTINE FOR ORTHONORMAL POLYNOMIAL EXPANSION
C     ******************************************************************
C     NA = NUMBER OF ARGUMENTS     (N)
C     AR = RECURRENCE COEFFICIENTS (2*M-2 ARRAY)
C     NC = NUMBER OF COEFFICIENTS  (M)
C     AC = POLYNOMIAL COEFFICIENTS (M*M ARRAY)
C
      DIMENSION AR(*), AC(*)
  001 DO 002 N=1,NC
      AC(N)=0.0
  002 CONTINUE
      SN=NA
      RN=SQRT(SN)
      AC(1)=1.0/RN
      IF(NC.EQ.1)RETURN
  003 TM=0.0
      L=NC
      DO 004 N=1,NC
      L=L+1
      AC(L)=(TM-AR(2)*AC(N))/AR(1)
      TM=AC(N)
  004 CONTINUE
      IF(NC.EQ.2)RETURN
  005 DO 007 M=3,NC
      TM=0.0
      J=(M-3)*NC
      DO 006 N=1,NC
      J=J+1
      K=J+NC
      L=K+NC
      AC(L)=(TM-AR(2*M-2)*AC(K)-AR(2*M-5)*AC(J))/AR(2*M-3)
      TM=AC(K)
  006 CONTINUE
  007 CONTINUE
      RETURN
      END
      REAL FUNCTION ZEROIN (F, AX, BX, AERR, RERR)
C-----------------------------------------------------------------------
C
C         FINDING A ZERO OF THE FUNCTION F(X) IN THE INTERVAL (AX,BX)
C
C                       ------------------------
C
C  INPUT...
C
C  F      FUNCTION SUBPROGRAM WHICH EVALUATES F(X) FOR ANY X IN THE
C         CLOSED INTERVAL (AX,BX). IT IS ASSUMED THAT F IS CONTINUOUS,
C         AND THAT F(AX) AND F(BX) HAVE DIFFERENT SIGNS.
C  AX     LEFT ENDPOINT OF THE INTERVAL
C  BX     RIGHT ENDPOINT OF THE INTERVAL
C  AERR   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
C  RERR   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
C
C  OUTPUT...
C
C         ABCISSA APPROXIMATING A ZERO OF F IN THE INTERVAL (AX,BX)
C
C-----------------------------------------------------------------------
C  ZEROIN IS A SLIGHTLY MODIFIED TRANSLATION OF THE ALGOL PROCEDURE
C  ZERO GIVEN BY RICHARD BRENT IN ALGORITHMS FOR MINIMIZATION WITHOUT
C  DERIVATIVES, PRENTICE-HALL, INC. (1973).
C-----------------------------------------------------------------------
      REAL F, AX, BX, AERR, RERR
      EXTERNAL F
      REAL A,B,C,D,E,EPS,FA,FB,FC,TOL,XM,P,Q,R,S,ATOL,RTOL
      REAL SPMPAR
C
C  COMPUTE EPS, THE RELATIVE MACHINE PRECISION
C
      EPS = SPMPAR(1)
C
C INITIALIZATION
C
      A = AX
      B = BX
      FA = F(A)
      FB = F(B)
      ATOL = 0.5*AERR
      RTOL = AMAX1(0.5*RERR,2.0*EPS)
C
C BEGIN STEP
C
   10 C = A
      FC = FA
      D = B - A
      E = D
   20 IF (ABS(FC) .GE. ABS(FB)) GO TO 40
      A = B
      B = C
      C = A
      FA = FB
      FB = FC
      FC = FA
C
C CONVERGENCE TEST
C
   40 TOL = RTOL*AMAX1(ABS(B),ABS(C)) + ATOL
      XM = 0.5*(C - B)
      IF (ABS(XM) .LE. TOL) GO TO 90
      IF (FB .EQ. 0.0) GO TO 90
C
C IS BISECTION NECESSARY
C
      IF (ABS(E) .LT. TOL) GO TO 70
      IF (ABS(FA) .LE. ABS(FB)) GO TO 70
C
C IS QUADRATIC INTERPOLATION POSSIBLE
C
      IF (A .NE. C) GO TO 50
C
C LINEAR INTERPOLATION
C
      S = FB/FC
      P = (C - B)*S
      Q = 1.0 - S
      GO TO 60
C
C INVERSE QUADRATIC INTERPOLATION
C
   50 Q = FA/FC
      R = FB/FC
      S = FB/FA
      P = S*((C - B)*Q*(Q - R) - (B - A)*(R - 1.0))
      Q = (Q - 1.0)*(R - 1.0)*(S - 1.0)
C
C ADJUST SIGNS
C
   60 IF (P .GT. 0.0) Q = -Q
      P = ABS(P)
C
C IS INTERPOLATION ACCEPTABLE
C
      IF (2.0*P .GE. (3.0*XM*Q - ABS(TOL*Q))) GO TO 70
      IF (P .GE. ABS(0.5*E*Q)) GO TO 70
      E = D
      D = P/Q
      GO TO 80
C
C BISECTION
C
   70 D = XM
      E = D
C
C COMPLETE STEP
C
   80 A = B
      FA = FB
      IF (ABS(D) .GT. TOL) B = B + D
      IF (ABS(D) .LE. TOL) B = B + SIGN(TOL,XM)
      FB = F(B)
      IF ((FB*(FC/ABS(FC))) .GT. 0.0) GO TO 10
      GO TO 20
C
C DONE
C
   90 ZEROIN = B
      RETURN
      END
      DOUBLE PRECISION FUNCTION DZERO (F, AX, BX, AERR, RERR)
C-----------------------------------------------------------------------
C
C         FINDING A ZERO OF THE FUNCTION F(X) IN THE INTERVAL (AX,BX)
C
C                       ------------------------
C
C  INPUT...
C
C  F      FUNCTION SUBPROGRAM WHICH EVALUATES F(X) FOR ANY X IN THE
C         CLOSED INTERVAL (AX,BX). IT IS ASSUMED THAT F IS CONTINUOUS,
C         AND THAT F(AX) AND F(BX) HAVE DIFFERENT SIGNS.
C  AX     LEFT ENDPOINT OF THE INTERVAL
C  BX     RIGHT ENDPOINT OF THE INTERVAL
C  AERR   THE ABSOLUTE ERROR TOLERANCE TO BE SATISFIED
C  RERR   THE RELATIVE ERROR TOLERANCE TO BE SATISFIED
C
C  OUTPUT...
C
C         ABCISSA APPROXIMATING A ZERO OF F IN THE INTERVAL (AX,BX)
C
C-----------------------------------------------------------------------
C  DZERO IS A SLIGHTLY MODIFIED TRANSLATION OF THE ALGOL PROCEDURE
C  ZERO GIVEN BY RICHARD BRENT IN ALGORITHMS FOR MINIMIZATION WITHOUT
C  DERIVATIVES, PRENTICE-HALL, INC. (1973).
C-----------------------------------------------------------------------
      DOUBLE PRECISION F, AX, BX, AERR, RERR
      EXTERNAL F
      DOUBLE PRECISION A,B,C,D,E,EPS,FA,FB,FC,TOL,XM,P,Q,R,S,ATOL,RTOL
      DOUBLE PRECISION DPMPAR
C
C  COMPUTE EPS, THE RELATIVE MACHINE PRECISION
C
      EPS = DPMPAR(1)
C
C INITIALIZATION
C
      A = AX
      B = BX
      FA = F(A)
      FB = F(B)
      ATOL = 0.5D0*AERR
      RTOL = DMAX1(0.5D0*RERR,2.D0*EPS)
C
C BEGIN STEP
C
   10 C = A
      FC = FA
      D = B - A
      E = D
   20 IF (DABS(FC) .GE. DABS(FB)) GO TO 40
      A = B
      B = C
      C = A
      FA = FB
      FB = FC
      FC = FA
C
C CONVERGENCE TEST
C
   40 TOL = RTOL*DMAX1(DABS(B),DABS(C)) + ATOL
      XM = 0.5D0*(C - B)
      IF (DABS(XM) .LE. TOL) GO TO 90
      IF (FB .EQ. 0.D0) GO TO 90
C
C IS BISECTION NECESSARY
C
      IF (DABS(E) .LT. TOL) GO TO 70
      IF (DABS(FA) .LE. DABS(FB)) GO TO 70
C
C IS QUADRATIC INTERPOLATION POSSIBLE
C
      IF (A .NE. C) GO TO 50
C
C LINEAR INTERPOLATION
C
      S = FB/FC
      P = (C - B)*S
      Q = 1.D0 - S
      GO TO 60
C
C INVERSE QUADRATIC INTERPOLATION
C
   50 Q = FA/FC
      R = FB/FC
      S = FB/FA
      P = S*((C - B)*Q*(Q - R) - (B - A)*(R - 1.D0))
      Q = (Q - 1.D0)*(R - 1.D0)*(S - 1.D0)
C
C ADJUST SIGNS
C
   60 IF (P .GT. 0.D0) Q = -Q
      P = DABS(P)
C
C IS INTERPOLATION ACCEPTABLE
C
      IF (2.D0*P .GE. (3.D0*XM*Q - DABS(TOL*Q))) GO TO 70
      IF (P .GE. DABS(0.5D0*E*Q)) GO TO 70
      E = D
      D = P/Q
      GO TO 80
C
C BISECTION
C
   70 D = XM
      E = D
C
C COMPLETE STEP
C
   80 A = B
      FA = FB
      IF (DABS(D) .GT. TOL) B = B + D
      IF (DABS(D) .LE. TOL) B = B + DSIGN(TOL,XM)
      FB = F(B)
      IF ((FB*(FC/DABS(FC))) .GT. 0.D0) GO TO 10
      GO TO 20
C
C DONE
C
   90 DZERO = B
      RETURN
      END
      SUBROUTINE HBRD(FCN,N,X,FVEC,EPSFCN,TOL,INFO,WA,LWA)
      INTEGER N,INFO,LWA
      REAL EPSFCN,TOL
      REAL X(N),FVEC(N),WA(LWA)
      EXTERNAL FCN
C     **********
C
C     SUBROUTINE HBRD
C
C       THE PURPOSE OF HBRD IS TO FIND A ZERO OF A SYSTEM OF
C     N NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION
C     OF THE POWELL HYBRID METHOD. THIS IS DONE BY USING THE
C     MORE GENERAL NONLINEAR EQUATION SOLVER HYBRD. THE USER
C     MUST PROVIDE A SUBROUTINE WHICH CALCULATES THE FUNCTIONS.
C     THE JACOBIAN IS THEN CALCULATED BY A FORWARD-DIFFERENCE
C     APPROXIMATION.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE HBRD(FCN,N,X,FVEC,EPSFCN,TOL,INFO,WA,LWA)
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
C         ---------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE THE EXECUTION OF HBRD.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS AND VARIABLES.
C
C       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
C         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
C         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
C
C       FVEC IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS
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
C         WHEN THE ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
C         BETWEEN X AND THE SOLUTION IS AT MOST TOL.
C
C       INFO IS AN INTEGER OUTPUT VARIABLE. IF THE USER HAS
C         TERMINATED EXECUTION, INFO IS SET TO THE (NEGATIVE)
C         VALUE OF IFLAG. SEE DESCRIPTION OF FCN. OTHERWISE,
C         INFO IS SET AS FOLLOWS.
C
C         INFO = 0   IMPROPER INPUT PARAMETERS.
C
C         INFO = 1   ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
C                    BETWEEN X AND THE SOLUTION IS AT MOST TOL.
C
C         INFO = 2   NUMBER OF CALLS TO FCN HAS REACHED OR EXCEEDED
C                    200*(N+1).
C
C         INFO = 3   TOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
C                    THE APPROXIMATE SOLUTION X IS POSSIBLE.
C
C         INFO = 4   ITERATION IS NOT MAKING GOOD PROGRESS.
C
C       WA IS A WORK ARRAY OF LENGTH LWA.
C
C       LWA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
C         (N*(3*N+13))/2.
C
C     SUBPROGRAMS CALLED
C
C       USER-SUPPLIED ...... FCN
C
C       MINPACK-SUPPLIED ... HYBRD
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER INDEX,J,LR,MAXFEV,ML,MODE,MU,NFEV,NPRINT
      REAL FACTOR,ONE,XTOL,ZERO
      DATA FACTOR,ONE,ZERO /1.0E2,1.0E0,0.0E0/
      INFO = 0
C
C     CHECK THE INPUT PARAMETERS FOR ERRORS.
C
      IF (N .LE. 0 .OR. EPSFCN .LT. ZERO .OR. TOL .LT. ZERO .OR.
     *   LWA .LT. (N*(3*N + 13))/2) GO TO 20
C
C     CALL HYBRD.
C
      MAXFEV = 200*(N + 1)
      XTOL = TOL
      ML = N - 1
      MU = N - 1
      MODE = 2
      DO 10 J = 1, N
         WA(J) = ONE
   10    CONTINUE
      NPRINT = 0
      LR = (N*(N + 1))/2
      INDEX = 6*N + LR
      CALL HYBRD(FCN,N,X,FVEC,XTOL,MAXFEV,ML,MU,EPSFCN,WA(1),MODE,
     *           FACTOR,NPRINT,INFO,NFEV,WA(INDEX+1),N,WA(6*N+1),LR,
     *           WA(N+1),WA(2*N+1),WA(3*N+1),WA(4*N+1),WA(5*N+1))
      IF (INFO .EQ. 5) INFO = 4
   20 CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE HBRD.
C
      END
      SUBROUTINE HYBRD(FCN,N,X,FVEC,XTOL,MAXFEV,ML,MU,EPSFCN,DIAG,
     *                 MODE,FACTOR,NPRINT,INFO,NFEV,FJAC,LDFJAC,R,LR,
     *                 QTF,WA1,WA2,WA3,WA4)
      INTEGER N,MAXFEV,ML,MU,MODE,NPRINT,INFO,NFEV,LDFJAC,LR
      REAL XTOL,EPSFCN,FACTOR
      REAL X(N),FVEC(N),DIAG(N),FJAC(LDFJAC,N),R(LR),QTF(N),WA1(N),
     *     WA2(N),WA3(N),WA4(N)
      EXTERNAL FCN
C     **********
C
C     SUBROUTINE HYBRD
C
C     THE PURPOSE OF HYBRD IS TO FIND A ZERO OF A SYSTEM OF
C     N NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION
C     OF THE POWELL HYBRID METHOD. THE USER MUST PROVIDE A
C     SUBROUTINE WHICH CALCULATES THE FUNCTIONS. THE JACOBIAN IS
C     THEN CALCULATED BY A FORWARD-DIFFERENCE APPROXIMATION.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE HYBRD(FCN,N,X,FVEC,XTOL,MAXFEV,ML,MU,EPSFCN,
C                        DIAG,MODE,FACTOR,NPRINT,INFO,NFEV,FJAC,
C                        LDFJAC,R,LR,QTF,WA1,WA2,WA3,WA4)
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
C         ---------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF HYBRD.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS AND VARIABLES.
C
C       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
C         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
C         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
C
C       FVEC IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS
C         THE FUNCTIONS EVALUATED AT THE OUTPUT X.
C
C       XTOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE RELATIVE ERROR BETWEEN TWO CONSECUTIVE
C         ITERATES IS AT MOST XTOL.
C
C       MAXFEV IS A POSITIVE INTEGER INPUT VARIABLE. TERMINATION
C         OCCURS WHEN THE NUMBER OF CALLS TO FCN IS AT LEAST MAXFEV
C         BY THE END OF AN ITERATION.
C
C       ML IS A NONNEGATIVE INTEGER INPUT VARIABLE WHICH SPECIFIES
C         THE NUMBER OF SUBDIAGONALS WITHIN THE BAND OF THE
C         JACOBIAN MATRIX. IF THE JACOBIAN IS NOT BANDED, SET
C         ML TO AT LEAST N - 1.
C
C       MU IS A NONNEGATIVE INTEGER INPUT VARIABLE WHICH SPECIFIES
C         THE NUMBER OF SUPERDIAGONALS WITHIN THE BAND OF THE
C         JACOBIAN MATRIX. IF THE JACOBIAN IS NOT BANDED, SET
C         MU TO AT LEAST N - 1.
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
C         INFO = 0   IMPROPER INPUT PARAMETERS.
C
C         INFO = 1   RELATIVE ERROR BETWEEN TWO CONSECUTIVE ITERATES
C                    IS AT MOST XTOL.
C
C         INFO = 2   NUMBER OF CALLS TO FCN HAS REACHED OR EXCEEDED
C                    MAXFEV.
C
C         INFO = 3   XTOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
C                    THE APPROXIMATE SOLUTION X IS POSSIBLE.
C
C         INFO = 4   ITERATION IS NOT MAKING GOOD PROGRESS, AS
C                    MEASURED BY THE IMPROVEMENT FROM THE LAST
C                    FIVE JACOBIAN EVALUATIONS.
C
C         INFO = 5   ITERATION IS NOT MAKING GOOD PROGRESS, AS
C                    MEASURED BY THE IMPROVEMENT FROM THE LAST
C                    TEN ITERATIONS.
C
C       NFEV IS AN INTEGER OUTPUT VARIABLE SET TO THE NUMBER OF
C         CALLS TO FCN.
C
C       FJAC IS AN OUTPUT N BY N ARRAY WHICH CONTAINS THE
C         ORTHOGONAL MATRIX Q PRODUCED BY THE QR FACTORIZATION
C         OF THE FINAL APPROXIMATE JACOBIAN.
C
C       LDFJAC IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN N
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY FJAC.
C
C       R IS AN OUTPUT ARRAY OF LENGTH LR WHICH CONTAINS THE
C         UPPER TRIANGULAR MATRIX PRODUCED BY THE QR FACTORIZATION
C         OF THE FINAL APPROXIMATE JACOBIAN, STORED ROWWISE.
C
C       LR IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
C         (N*(N+1))/2.
C
C       QTF IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS
C         THE VECTOR (Q TRANSPOSE)*FVEC.
C
C       WA1, WA2, WA3, AND WA4 ARE WORK ARRAYS OF LENGTH N.
C
C     SUBPROGRAMS CALLED
C
C       USER-SUPPLIED ...... FCN
C
C       MINPACK-SUPPLIED ... DOGLEG,SPMPAR,ENORM,FDJAC1,
C                            QFORM,QRFAC,R1MPYQ,R1UPDT
C
C       FORTRAN-SUPPLIED ... ABS,AMAX1,AMIN1,MIN0,MOD
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,IFLAG,ITER,J,JM1,L,MSUM,NCFAIL,NCSUC,NSLOW1,NSLOW2
      INTEGER IWA(1)
      LOGICAL JEVAL,SING
      REAL ACTRED,DELTA,EPSMCH,FNORM,FNORM1,ONE,PNORM,PRERED,P1,P5,
     *     P001,P0001,RATIO,SUM,TEMP,XNORM,ZERO
      REAL SPMPAR,ENORM
      DATA ONE,P1,P5,P001,P0001,ZERO
     *     /1.0E0,1.0E-1,5.0E-1,1.0E-3,1.0E-4,0.0E0/
C
C     EPSMCH IS THE MACHINE PRECISION.
C
      EPSMCH = SPMPAR(1)
C
      INFO = 0
      IFLAG = 0
      NFEV = 0
C
C     CHECK THE INPUT PARAMETERS FOR ERRORS.
C
      IF (N .LE. 0 .OR. XTOL .LT. ZERO .OR. MAXFEV .LE. 0
     *    .OR. ML .LT. 0 .OR. MU .LT. 0 .OR. FACTOR .LE. ZERO
     *    .OR. LDFJAC .LT. N .OR. LR .LT. (N*(N + 1))/2) GO TO 300
      IF (MODE .NE. 2) GO TO 20
      DO 10 J = 1, N
         IF (DIAG(J) .LE. ZERO) GO TO 300
   10    CONTINUE
   20 CONTINUE
C
C     EVALUATE THE FUNCTION AT THE STARTING POINT
C     AND CALCULATE ITS NORM.
C
      IFLAG = 1
      CALL FCN(N,X,FVEC,IFLAG)
      NFEV = 1
      IF (IFLAG .LT. 0) GO TO 300
      FNORM = ENORM(N,FVEC)
C
C     DETERMINE THE NUMBER OF CALLS TO FCN NEEDED TO COMPUTE
C     THE JACOBIAN MATRIX.
C
      MSUM = MIN0(ML+MU+1,N)
C
C     INITIALIZE ITERATION COUNTER AND MONITORS.
C
      ITER = 1
      NCSUC = 0
      NCFAIL = 0
      NSLOW1 = 0
      NSLOW2 = 0
C
C     BEGINNING OF THE OUTER LOOP.
C
   30 CONTINUE
         JEVAL = .TRUE.
C
C        CALCULATE THE JACOBIAN MATRIX.
C
         IFLAG = 2
         CALL FDJAC1(FCN,N,X,FVEC,FJAC,LDFJAC,IFLAG,ML,MU,EPSFCN,WA1,
     *               WA2)
         NFEV = NFEV + MSUM
         IF (IFLAG .LT. 0) GO TO 300
C
C        COMPUTE THE QR FACTORIZATION OF THE JACOBIAN.
C
         CALL QRFAC(N,N,FJAC,LDFJAC,.FALSE.,IWA,1,WA1,WA2,WA3)
C
C        ON THE FIRST ITERATION AND IF MODE IS 1, SCALE ACCORDING
C        TO THE NORMS OF THE COLUMNS OF THE INITIAL JACOBIAN.
C
         IF (ITER .NE. 1) GO TO 70
         IF (MODE .EQ. 2) GO TO 50
         DO 40 J = 1, N
            DIAG(J) = WA2(J)
            IF (WA2(J) .EQ. ZERO) DIAG(J) = ONE
   40       CONTINUE
   50    CONTINUE
C
C        ON THE FIRST ITERATION, CALCULATE THE NORM OF THE SCALED X
C        AND INITIALIZE THE STEP BOUND DELTA.
C
         DO 60 J = 1, N
            WA3(J) = DIAG(J)*X(J)
   60       CONTINUE
         XNORM = ENORM(N,WA3)
         DELTA = FACTOR*XNORM
         IF (DELTA .EQ. ZERO) DELTA = FACTOR
   70    CONTINUE
C
C        FORM (Q TRANSPOSE)*FVEC AND STORE IN QTF.
C
         DO 80 I = 1, N
            QTF(I) = FVEC(I)
   80       CONTINUE
         DO 120 J = 1, N
            IF (FJAC(J,J) .EQ. ZERO) GO TO 110
            SUM = ZERO
            DO 90 I = J, N
               SUM = SUM + FJAC(I,J)*QTF(I)
   90          CONTINUE
            TEMP = -SUM/FJAC(J,J)
            DO 100 I = J, N
               QTF(I) = QTF(I) + FJAC(I,J)*TEMP
  100          CONTINUE
  110       CONTINUE
  120       CONTINUE
C
C        COPY THE TRIANGULAR FACTOR OF THE QR FACTORIZATION INTO R.
C
         SING = .FALSE.
         DO 150 J = 1, N
            L = J
            JM1 = J - 1
            IF (JM1 .LT. 1) GO TO 140
            DO 130 I = 1, JM1
               R(L) = FJAC(I,J)
               L = L + N - I
  130          CONTINUE
  140       CONTINUE
            R(L) = WA1(J)
            IF (WA1(J) .EQ. ZERO) SING = .TRUE.
  150       CONTINUE
C
C        ACCUMULATE THE ORTHOGONAL FACTOR IN FJAC.
C
         CALL QFORM(N,N,FJAC,LDFJAC,WA1)
C
C        RESCALE IF NECESSARY.
C
         IF (MODE .EQ. 2) GO TO 170
         DO 160 J = 1, N
            DIAG(J) = AMAX1(DIAG(J),WA2(J))
  160       CONTINUE
  170    CONTINUE
C
C        BEGINNING OF THE INNER LOOP.
C
  180    CONTINUE
C
C           IF REQUESTED, CALL FCN TO ENABLE PRINTING OF ITERATES.
C
            IF (NPRINT .LE. 0) GO TO 190
            IFLAG = 0
            IF (MOD(ITER-1,NPRINT) .EQ. 0) CALL FCN(N,X,FVEC,IFLAG)
            IF (IFLAG .LT. 0) GO TO 300
  190       CONTINUE
C
C           DETERMINE THE DIRECTION P.
C
            CALL DOGLEG(N,R,LR,DIAG,QTF,DELTA,WA1,WA2,WA3)
C
C           STORE THE DIRECTION P AND X + P. CALCULATE THE NORM OF P.
C
            DO 200 J = 1, N
               WA1(J) = -WA1(J)
               WA2(J) = X(J) + WA1(J)
               WA3(J) = DIAG(J)*WA1(J)
  200          CONTINUE
            PNORM = ENORM(N,WA3)
C
C           ON THE FIRST ITERATION, ADJUST THE INITIAL STEP BOUND.
C
            IF (ITER .EQ. 1) DELTA = AMIN1(DELTA,PNORM)
C
C           EVALUATE THE FUNCTION AT X + P AND CALCULATE ITS NORM.
C
            IFLAG = 1
            CALL FCN(N,WA2,WA4,IFLAG)
            NFEV = NFEV + 1
            IF (IFLAG .LT. 0) GO TO 300
            FNORM1 = ENORM(N,WA4)
C
C           COMPUTE THE SCALED ACTUAL REDUCTION.
C
            ACTRED = -ONE
            IF (FNORM1 .LT. FNORM) ACTRED = ONE - (FNORM1/FNORM)**2
C
C           COMPUTE THE SCALED PREDICTED REDUCTION.
C
            L = 1
            DO 220 I = 1, N
               SUM = ZERO
               DO 210 J = I, N
                  SUM = SUM + R(L)*WA1(J)
                  L = L + 1
  210             CONTINUE
               WA3(I) = QTF(I) + SUM
  220          CONTINUE
            TEMP = ENORM(N,WA3)
            PRERED = ZERO
            IF (TEMP .LT. FNORM) PRERED = ONE - (TEMP/FNORM)**2
C
C           COMPUTE THE RATIO OF THE ACTUAL TO THE PREDICTED
C           REDUCTION.
C
            RATIO = ZERO
            IF (PRERED .GT. ZERO) RATIO = ACTRED/PRERED
C
C           UPDATE THE STEP BOUND.
C
            IF (RATIO .GE. P1) GO TO 230
               NCSUC = 0
               NCFAIL = NCFAIL + 1
               DELTA = P5*DELTA
               GO TO 240
  230       CONTINUE
               NCFAIL = 0
               NCSUC = NCSUC + 1
               IF (RATIO .GE. P5 .OR. NCSUC .GT. 1)
     *            DELTA = AMAX1(DELTA,PNORM/P5)
               IF (ABS(RATIO-ONE) .LE. P1) DELTA = PNORM/P5
  240       CONTINUE
C
C           TEST FOR SUCCESSFUL ITERATION.
C
            IF (RATIO .LT. P0001) GO TO 260
C
C           SUCCESSFUL ITERATION. UPDATE X, FVEC, AND THEIR NORMS.
C
            DO 250 J = 1, N
               X(J) = WA2(J)
               WA2(J) = DIAG(J)*X(J)
               FVEC(J) = WA4(J)
  250          CONTINUE
            XNORM = ENORM(N,WA2)
            FNORM = FNORM1
            ITER = ITER + 1
  260       CONTINUE
C
C           DETERMINE THE PROGRESS OF THE ITERATION.
C
            NSLOW1 = NSLOW1 + 1
            IF (ACTRED .GE. P001) NSLOW1 = 0
            IF (JEVAL) NSLOW2 = NSLOW2 + 1
            IF (ACTRED .GE. P1) NSLOW2 = 0
C
C           TEST FOR CONVERGENCE.
C
            IF (DELTA .LE. XTOL*XNORM .OR. FNORM .EQ. ZERO) INFO = 1
            IF (INFO .NE. 0) GO TO 300
C
C           TESTS FOR TERMINATION AND STRINGENT TOLERANCES.
C
            IF (NFEV .GE. MAXFEV) INFO = 2
            IF (P1*AMAX1(P1*DELTA,PNORM) .LE. EPSMCH*XNORM) INFO = 3
            IF (NSLOW2 .EQ. 5) INFO = 4
            IF (NSLOW1 .EQ. 10) INFO = 5
            IF (INFO .NE. 0) GO TO 300
C
C           CRITERION FOR RECALCULATING JACOBIAN APPROXIMATION
C           BY FORWARD DIFFERENCES.
C
            IF (NCFAIL .EQ. 2) GO TO 290
C
C           CALCULATE THE RANK ONE MODIFICATION TO THE JACOBIAN
C           AND UPDATE QTF IF NECESSARY.
C
            DO 280 J = 1, N
               SUM = ZERO
               DO 270 I = 1, N
                  SUM = SUM + FJAC(I,J)*WA4(I)
  270             CONTINUE
               WA2(J) = (SUM - WA3(J))/PNORM
               WA1(J) = DIAG(J)*((DIAG(J)*WA1(J))/PNORM)
               IF (RATIO .GE. P0001) QTF(J) = SUM
  280          CONTINUE
C
C           COMPUTE THE QR FACTORIZATION OF THE UPDATED JACOBIAN.
C
            CALL R1UPDT(N,N,R,LR,WA1,WA2,WA3,SING)
            CALL R1MPYQ(N,N,FJAC,LDFJAC,WA2,WA3)
            CALL R1MPYQ(1,N,QTF,1,WA2,WA3)
C
C           END OF THE INNER LOOP.
C
            JEVAL = .FALSE.
            GO TO 180
  290    CONTINUE
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
      IF (NPRINT .GT. 0) CALL FCN(N,X,FVEC,IFLAG)
      RETURN
C
C     LAST CARD OF SUBROUTINE HYBRD.
C
      END
      SUBROUTINE QDCRT (A, Z)
C-----------------------------------------------------------------------
C
C        QDCRT COMPUTES THE ROOTS OF THE REAL POLYNOMIAL
C              A(1) + A(2)*Z + A(3)*Z**2
C     AND STORES THE RESULTS IN Z. IT IS ASSUMED THAT A(3)
C     IS NONZERO.
C
C-----------------------------------------------------------------------
      REAL A(3)
      COMPLEX Z(2)
C-----------------------------------------------------------------------
C
C     ***** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C           SMALLEST NUMBER SUCH THAT 1.0 + EPS .GT. 1.0.
C
               EPS = SPMPAR(1)
C
C-------------------
      IF (A(1) .EQ. 0.0) GO TO 40
      D = A(2)*A(2) - 4.0*A(1)*A(3)
      IF (ABS(D) .LE. 2.0*EPS*A(2)*A(2)) GO TO 20
      R = SQRT(ABS(D))
      IF (D .LT. 0.0) GO TO 30
C
C                 DISTINCT REAL ROOTS
C
      IF (A(2) .NE. 0.0) GO TO 10
         X = ABS(0.5*R/A(3))
         Z(1) = CMPLX(X, 0.0)
         Z(2) = CMPLX(-X, 0.0)
         RETURN
   10 W = -(A(2) + SIGN(R,A(2)))
      Z(1) = CMPLX(2.0*A(1)/W, 0.0)
      Z(2) = CMPLX(0.5*W/A(3), 0.0)
      RETURN
C
C                  EQUAL REAL ROOTS
C
   20 Z(1) = CMPLX(-0.5*A(2)/A(3), 0.0)
      Z(2) = Z(1)
      RETURN
C
C                   COMPLEX ROOTS
C
   30 X = -0.5*A(2)/A(3)
      Y = ABS(0.5*R/A(3))
      Z(1) = CMPLX(X, Y)
      Z(2) = CMPLX(X,-Y)
      RETURN
C
C                 CASE WHEN A(1) = 0
C
   40 Z(1) = (0.0, 0.0)
      Z(2) = CMPLX(-A(2)/A(3), 0.0)
      RETURN
      END
      SUBROUTINE DQDCRT (A, ZR, ZI)
C-----------------------------------------------------------------------
C
C        DQDCRT COMPUTES THE ROOTS OF THE REAL POLYNOMIAL
C                A(1) + A(2)*Z + A(3)*Z**2
C     AND STORES THE RESULTS IN ZR AND ZI. IT IS ASSUMED THAT
C     A(3) IS NONZERO.
C
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(3), ZR(3), ZI(3)
      DOUBLE PRECISION D, EPS, R, W
      DOUBLE PRECISION DPMPAR
C-----------------------------------------------------------------------
C
C     ***** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C           SMALLEST NUMBER SUCH THAT 1.D0 + EPS .GT. 1.D0.
C
               EPS = DPMPAR(1)
C
C-------------------
      IF (A(1) .EQ. 0.D0) GO TO 40
      D = A(2)*A(2) - 4.D0*A(1)*A(3)
      IF (DABS(D) .LE. 2.D0*EPS*A(2)*A(2)) GO TO 20
      R = DSQRT(DABS(D))
      IF (D .LT. 0.D0) GO TO 30
C
C                 DISTINCT REAL ROOTS
C
      ZI(1) = 0.D0
      ZI(2) = 0.D0
      IF (A(2) .NE. 0.D0) GO TO 10
         ZR(1) = DABS(0.5D0*R/A(3))
         ZR(2) = -ZR(1)
         RETURN
   10 W = -(A(2) + DSIGN(R,A(2)))
      ZR(1) = 2.D0*A(1)/W
      ZR(2) = 0.5D0*W/A(3)
      RETURN
C
C                  EQUAL REAL ROOTS
C
   20 ZR(1) = -0.5D0*A(2)/A(3)
      ZR(2) = ZR(1)
      ZI(1) = 0.D0
      ZI(2) = 0.D0
      RETURN
C
C                   COMPLEX ROOTS
C
   30 ZR(1) = -0.5D0*A(2)/A(3)
      ZR(2) = ZR(1)
      ZI(1) = DABS(0.5D0*R/A(3))
      ZI(2) = -ZI(1)
      RETURN
C
C                 CASE WHEN A(1) = 0
C
   40 ZR(1) = 0.D0
      ZR(2) = -A(2)/A(3)
      ZI(1) = 0.D0
      ZI(2) = 0.D0
      RETURN
      END
      SUBROUTINE CBCRT (A, Z)
C-----------------------------------------------------------------------
C
C        CBCRT COMPUTES THE ROOTS OF THE REAL POLYNOMIAL
C              A(1) + A(2)*Z + A(3)*Z**2 + A(4)*Z**3
C     AND STORES THE RESULTS IN Z. IT IS ASSUMED THAT A(4)
C     IS NONZERO.
C
C-----------------------------------------------------------------------
C     WRITTEN BY ALFRED H. MORRIS
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C-----------------------------------------------------------------------
      REAL A(4), AQ(3)
      COMPLEX Z(3)
C-------------------
      DATA RT3/1.7320508075689/
C-----------------------------------------------------------------------
C
C     ***** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C           SMALLEST NUMBER SUCH THAT 1.0 + EPS .GT. 1.0.
C
               EPS = SPMPAR(1)
C
C-------------------
      IF (A(1) .EQ. 0.0) GO TO 100
      P = A(3)/(3.0*A(4))
      Q = A(2)/A(4)
      R = A(1)/A(4)
      TOL = 4.0*EPS
C
      C = 0.0
      T = A(2) - P*A(3)
      IF (ABS(T) .GT. TOL*ABS(A(2))) C = T/A(4)
C
      T = 2.0*P*P - Q
      IF (ABS(T) .LE. TOL*ABS(Q)) T = 0.0
      D = R + P*T
      IF (ABS(D) .LE. TOL*ABS(R)) GO TO 110
C
C           SET  SQ = (A(4)/S)**2 * (C**3/27 + D**2/4)
C
      S = AMAX1(ABS(A(1)),ABS(A(2)),ABS(A(3)))
      P1 = A(3)/(3.0*S)
      Q1 = A(2)/S
      R1 = A(1)/S
C
      T1 = Q - 2.25*P*P
      IF (ABS(T1) .LE. TOL*ABS(Q)) T1 = 0.0
      W = 0.25*R1*R1
      W1 = 0.5*P1*R1*T
      W2 = Q1*Q1*T1/27.0
      IF (W1 .LT. 0.0) GO TO 10
         W = W + W1
         SQ = W + W2
         GO TO 12
   10 IF (W2 .LT. 0.0) GO TO 11
         W = W + W2
         SQ = W + W1
         GO TO 12
   11 SQ = W + (W1 + W2)
   12 IF (ABS(SQ) .LE. TOL*W) SQ = 0.0
      RQ = ABS(S/A(4))*SQRT(ABS(SQ))
      IF (SQ .GE. 0.0) GO TO 40
C
C                   ALL ROOTS ARE REAL
C
      ARG = ATAN2(RQ, -0.5*D)
      CF = COS(ARG/3.0)
      SF = SIN(ARG/3.0)
      RT = SQRT(-C/3.0)
      Y1 = 2.0*RT*CF
      Y2 = -RT*(CF + RT3*SF)
      Y3 = -(D/Y1)/Y2
C
      X1 = Y1 - P
      X2 = Y2 - P
      X3 = Y3 - P
      IF (ABS(X1) .LE. ABS(X2)) GO TO 20
         T = X1
         X1 = X2
         X2 = T
   20 IF (ABS(X2) .LE. ABS(X3)) GO TO 30
         T = X2
         X2 = X3
         X3 = T
      IF (ABS(X1) .LE. ABS(X2)) GO TO 30
         T = X1
         X1 = X2
         X2 = T
C
   30 W = X3
      IF (ABS(X2) .LT. 0.1*ABS(X3)) GO TO 70
      IF (ABS(X1) .LT. 0.1*ABS(X2)) X1 = - (R/X3)/X2
      Z(1) = CMPLX(X1, 0.0)
      Z(2) = CMPLX(X2, 0.0)
      Z(3) = CMPLX(X3, 0.0)
      RETURN
C
C                  REAL AND COMPLEX ROOTS
C
   40 RA = CBRT(-0.5*D - SIGN(RQ,D))
      RB = -C/(3.0*RA)
      T = RA + RB
      W = -P
      X = -P
      IF (ABS(T) .LE. TOL*ABS(RA)) GO TO 41
         W = T - P
         X = -0.5*T - P
         IF (ABS(X) .LE. TOL*ABS(P)) X = 0.0
   41 T = ABS(RA - RB)
      Y = 0.5*RT3*T
C
      IF (T .LE. TOL*ABS(RA)) GO TO 60
      IF (ABS(X) .LT. ABS(Y)) GO TO 50
         S = ABS(X)
         T = Y/X
         GO TO 51
   50 S = ABS(Y)
      T = X/Y
   51 IF (S .LT. 0.1*ABS(W)) GO TO 70
      W1 = W/S
      SUM = 1.0 + T*T
      IF (W1*W1 .LT. 0.01*SUM) W = - ((R/SUM)/S)/S
      Z(1) = CMPLX(W,0.0)
      Z(2) = CMPLX(X, Y)
      Z(3) = CMPLX(X,-Y)
      RETURN
C
C               AT LEAST TWO ROOTS ARE EQUAL
C
   60 IF (ABS(X) .LT. ABS(W)) GO TO 61
         IF (ABS(W) .LT. 0.1*ABS(X)) W = - (R/X)/X
         Z(1) = CMPLX(W, 0.0)
         Z(2) = CMPLX(X, 0.0)
         Z(3) = Z(2)
         RETURN
   61 IF (ABS(X) .LT. 0.1*ABS(W)) GO TO 70
      Z(1) = CMPLX(X, 0.0)
      Z(2) = Z(1)
      Z(3) = CMPLX(W, 0.0)
      RETURN
C
C     HERE W IS MUCH LARGER IN MAGNITUDE THAN THE OTHER ROOTS.
C     AS A RESULT, THE OTHER ROOTS MAY BE EXCEEDINGLY INACCURATE
C     BECAUSE OF ROUNDOFF ERROR. TO DEAL WITH THIS, A QUADRATIC
C     IS FORMED WHOSE ROOTS ARE THE SAME AS THE SMALLER ROOTS OF
C     THE CUBIC. THIS QUADRATIC IS THEN SOLVED.
C
C     THIS CODE WAS WRITTEN BY WILLIAM L. DAVIS (NSWC).
C
   70    AQ(1) = A(1)
         AQ(2) = A(2) + A(1)/W
         AQ(3) = -A(4)*W
         CALL QDCRT(AQ, Z)
         Z(3) = CMPLX(W, 0.0)
C
      IF (AIMAG(Z(1)) .EQ. 0.0) RETURN
      Z(3) = Z(2)
      Z(2) = Z(1)
      Z(1) = CMPLX(W, 0.0)
      RETURN
C-----------------------------------------------------------------------
C
C                  CASE WHEN A(1) = 0
C
  100 Z(1) = (0.0, 0.0)
      CALL QDCRT(A(2), Z(2))
      RETURN
C
C                   CASE WHEN D = 0
C
  110 Z(1) = CMPLX(-P, 0.0)
      W = SQRT(ABS(C))
      IF (C .LT. 0.0) GO TO 120
         Z(2) = CMPLX(-P, W)
         Z(3) = CMPLX(-P,-W)
         RETURN
C
  120 IF (P .NE. 0.0) GO TO 130
         Z(2) = CMPLX(W, 0.0)
         Z(3) = CMPLX(-W, 0.0)
         RETURN
C
  130 X = -(P + SIGN(W,P))
      Z(3) = CMPLX(X, 0.0)
      T = 3.0*A(1)/(A(3)*X)
      IF (ABS(P) .GT. ABS(T)) GO TO 131
         Z(2) = CMPLX(T, 0.0)
         RETURN
  131 Z(2) = Z(1)
      Z(1) = CMPLX(T, 0.0)
      RETURN
      END
      SUBROUTINE DCBCRT (A, ZR, ZI)
C-----------------------------------------------------------------------
C
C        DCBCRT COMPUTES THE ROOTS OF THE REAL POLYNOMIAL
C              A(1) + A(2)*Z + A(3)*Z**2 + A(4)*Z**3
C     AND STORES THE RESULTS IN ZR AND ZI. IT IS ASSUMED THAT
C     A(4) IS NONZERO.
C
C-----------------------------------------------------------------------
C     WRITTEN BY ALFRED H. MORRIS
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(4), ZR(3), ZI(3)
      DOUBLE PRECISION AQ(3), ARG, C, CF, D, EPS, P, P1, Q, Q1,
     *                 R, RA, RB, RQ, RT, RT3, R1, S, SF, SQ, SUM,
     *                 T, TOL, T1, W, W1, W2, X, X1, X2, X3, Y,
     *                 Y1, Y2, Y3
      DOUBLE PRECISION DPMPAR, DCBRT
C-------------------
      DATA RT3 /1.732050807568877293527446341505872366943D0/
C-----------------------------------------------------------------------
C
C     ***** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C           SMALLEST NUMBER SUCH THAT 1.D0 + EPS .GT. 1.D0.
C
               EPS = DPMPAR(1)
C
C-------------------
      IF (A(1) .EQ. 0.D0) GO TO 100
      P = A(3)/(3.D0*A(4))
      Q = A(2)/A(4)
      R = A(1)/A(4)
      TOL = 4.D0*EPS
C
      C = 0.D0
      T = A(2) - P*A(3)
      IF (DABS(T) .GT. TOL*DABS(A(2))) C = T/A(4)
C
      T = 2.D0*P*P - Q
      IF (DABS(T) .LE. TOL*DABS(Q)) T = 0.D0
      D = R + P*T
      IF (DABS(D) .LE. TOL*DABS(R)) GO TO 110
C
C           SET  SQ = (A(4)/S)**2 * (C**3/27 + D**2/4)
C
      S = DMAX1(DABS(A(1)),DABS(A(2)),DABS(A(3)))
      P1 = A(3)/(3.D0*S)
      Q1 = A(2)/S
      R1 = A(1)/S
C
      T1 = Q - 2.25D0*P*P
      IF (DABS(T1) .LE. TOL*DABS(Q)) T1 = 0.D0
      W = 0.25D0*R1*R1
      W1 = 0.5D0*P1*R1*T
      W2 = Q1*Q1*T1/27.D0
      IF (W1 .LT. 0.D0) GO TO 10
         W = W + W1
         SQ = W + W2
         GO TO 12
   10 IF (W2 .LT. 0.D0) GO TO 11
         W = W + W2
         SQ = W + W1
         GO TO 12
   11 SQ = W + (W1 + W2)
   12 IF (DABS(SQ) .LE. TOL*W) SQ = 0.D0
      RQ = DABS(S/A(4))*DSQRT(DABS(SQ))
      IF (SQ .GE. 0.D0) GO TO 40
C
C                   ALL ROOTS ARE REAL
C
      ARG = DATAN2(RQ, -0.5D0*D)
      CF = DCOS(ARG/3.D0)
      SF = DSIN(ARG/3.D0)
      RT = DSQRT(-C/3.D0)
      Y1 = 2.D0*RT*CF
      Y2 = -RT*(CF + RT3*SF)
      Y3 = -(D/Y1)/Y2
C
      X1 = Y1 - P
      X2 = Y2 - P
      X3 = Y3 - P
      IF (DABS(X1) .LE. DABS(X2)) GO TO 20
         T = X1
         X1 = X2
         X2 = T
   20 IF (DABS(X2) .LE. DABS(X3)) GO TO 30
         T = X2
         X2 = X3
         X3 = T
      IF (DABS(X1) .LE. DABS(X2)) GO TO 30
         T = X1
         X1 = X2
         X2 = T
C
   30 W = X3
      IF (DABS(X2) .LT. 0.1D0*DABS(X3)) GO TO 70
      IF (DABS(X1) .LT. 0.1D0*DABS(X2)) X1 = - (R/X3)/X2
      ZR(1) = X1
      ZR(2) = X2
      ZR(3) = X3
      ZI(1) = 0.D0
      ZI(2) = 0.D0
      ZI(3) = 0.D0
      RETURN
C
C                  REAL AND COMPLEX ROOTS
C
   40 RA = DCBRT(-0.5D0*D - DSIGN(RQ,D))
      RB = -C/(3.D0*RA)
      T = RA + RB
      W = -P
      X = -P
      IF (DABS(T) .LE. TOL*DABS(RA)) GO TO 41
         W = T - P
         X = -0.5D0*T - P
         IF (DABS(X) .LE. TOL*DABS(P)) X = 0.D0
   41 T = DABS(RA - RB)
      Y = 0.5D0*RT3*T
C
      IF (T .LE. TOL*DABS(RA)) GO TO 60
      IF (DABS(X) .LT. DABS(Y)) GO TO 50
         S = DABS(X)
         T = Y/X
         GO TO 51
   50 S = DABS(Y)
      T = X/Y
   51 IF (S .LT. 0.1D0*DABS(W)) GO TO 70
      W1 = W/S
      SUM = 1.D0 + T*T
      IF (W1*W1 .LT. 1.D-2*SUM) W = - ((R/SUM)/S)/S
      ZR(1) = W
      ZR(2) = X
      ZR(3) = X
      ZI(1) = 0.D0
      ZI(2) = Y
      ZI(3) = -Y
      RETURN
C
C               AT LEAST TWO ROOTS ARE EQUAL
C
   60 ZI(1) = 0.D0
      ZI(2) = 0.D0
      ZI(3) = 0.D0
      IF (DABS(X) .LT. DABS(W)) GO TO 61
         IF (DABS(W) .LT. 0.1D0*DABS(X)) W = - (R/X)/X
         ZR(1) = W
         ZR(2) = X
         ZR(3) = X
         RETURN
   61 IF (DABS(X) .LT. 0.1D0*DABS(W)) GO TO 70
      ZR(1) = X
      ZR(2) = X
      ZR(3) = W
      RETURN
C
C     HERE W IS MUCH LARGER IN MAGNITUDE THAN THE OTHER ROOTS.
C     AS A RESULT, THE OTHER ROOTS MAY BE EXCEEDINGLY INACCURATE
C     BECAUSE OF ROUNDOFF ERROR. TO DEAL WITH THIS, A QUADRATIC
C     IS FORMED WHOSE ROOTS ARE THE SAME AS THE SMALLER ROOTS OF
C     THE CUBIC. THIS QUADRATIC IS THEN SOLVED.
C
C     THIS CODE WAS WRITTEN BY WILLIAM L. DAVIS (NSWC).
C
   70    AQ(1) = A(1)
         AQ(2) = A(2) + A(1)/W
         AQ(3) = -A(4)*W
         CALL DQDCRT (AQ, ZR, ZI)
         ZR(3) = W
         ZI(3) = 0.D0
C
      IF (ZI(1) .EQ. 0.D0) RETURN
      ZR(3) = ZR(2)
      ZI(3) = ZI(2)
      ZR(2) = ZR(1)
      ZI(2) = ZI(1)
      ZR(1) = W
      ZI(1) = 0.D0
      RETURN
C-----------------------------------------------------------------------
C
C                  CASE WHEN A(1) = 0
C
  100 ZR(1) = 0.D0
      ZI(1) = 0.D0
      CALL DQDCRT(A(2), ZR(2), ZI(2))
      RETURN
C
C                   CASE WHEN D = 0
C
  110 ZR(1) = -P
      ZI(1) = 0.D0
      W = DSQRT(DABS(C))
      IF (C .LT. 0.D0) GO TO 120
         ZR(2) = -P
         ZR(3) = ZR(2)
         ZI(2) =  W
         ZI(3) = -W
         RETURN
C
  120 IF (P .NE. 0.D0) GO TO 130
         ZR(2) =  W
         ZR(3) = -W
         ZI(2) = 0.D0
         ZI(3) = 0.D0
         RETURN
C
  130 X = -(P + DSIGN(W,P))
      ZR(3) =  X
      ZI(2) = 0.D0
      ZI(3) = 0.D0
      T = 3.D0*A(1)/(A(3)*X)
      IF (DABS(P) .GT. DABS(T)) GO TO 131
         ZR(2) = T
         RETURN
  131 ZR(2) = ZR(1)
      ZR(1) = T
      RETURN
      END
      SUBROUTINE QTCRT (A, Z)
C-----------------------------------------------------------------------
C
C         QTCRT COMPUTES THE ROOTS OF THE REAL POLYNOMIAL
C               A(1) + A(2)*Z + ... + A(5)*Z**4
C         AND STORES THE RESULTS IN Z. IT IS ASSUMED THAT A(5)
C         IS NONZERO.
C
C-----------------------------------------------------------------------
C     WRITTEN BY ALFRED H. MORRIS
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C-----------------------------------------------------------------------
      REAL A(5), TEMP(4)
      COMPLEX Z(4), W
C
      IF (A(1) .EQ. 0.0) GO TO 100
      B = A(4)/(4.0*A(5))
      C = A(3)/A(5)
      D = A(2)/A(5)
      E = A(1)/A(5)
      B2 = B*B
C
      P = 0.5*(C - 6.0*B2)
      Q = D - 2.0*B*(C - 4.0*B2)
      R = B2*(C - 3.0*B2) - B*D + E
C
C          SOLVE THE RESOLVENT CUBIC EQUATION. THE CUBIC HAS
C          AT LEAST ONE NONNEGATIVE REAL ROOT. IF W1, W2, W3
C          ARE THE ROOTS OF THE CUBIC THEN THE ROOTS OF THE
C          ORIGINIAL EQUATION ARE
C
C             Z = -B + CSQRT(W1) + CSQRT(W2) + CSQRT(W3)
C
C          WHERE THE SIGNS OF THE SQUARE ROOTS ARE CHOSEN SO
C          THAT CSQRT(W1) * CSQRT(W2) * CSQRT(W3) = -Q/8.
C
      TEMP(1) = -Q*Q/64.0
      TEMP(2) = 0.25*(P*P - R)
      TEMP(3) =  P
      TEMP(4) = 1.0
      CALL CBCRT(TEMP,Z)
      IF (AIMAG(Z(2)) .NE. 0.0) GO TO 60
C
C               THE RESOLVENT CUBIC HAS ONLY REAL ROOTS
C                REORDER THE ROOTS IN INCREASING ORDER
C
      X1 = REAL(Z(1))
      X2 = REAL(Z(2))
      X3 = REAL(Z(3))
      IF (X1 .LE. X2) GO TO 10
         T = X1
         X1 = X2
         X2 = T
   10 IF (X2 .LE. X3) GO TO 20
         T = X2
         X2 = X3
         X3 = T
      IF (X1 .LE. X2) GO TO 20
         T = X1
         X1 = X2
         X2 = T
C
   20 U = 0.0
      IF (X3 .GT. 0.0) U = SQRT(X3)
      IF (X2 .LE. 0.0) GO TO 41
      IF (X1 .GE. 0.0) GO TO 30
      IF (ABS(X1) .GT. X2) GO TO 40
      X1 = 0.0
C
   30 X1 = SQRT(X1)
      X2 = SQRT(X2)
      IF (Q .GT. 0.0) X1 = -X1
      TEMP(1) = (( X1 + X2) + U) - B
      TEMP(2) = ((-X1 - X2) + U) - B
      TEMP(3) = (( X1 - X2) - U) - B
      TEMP(4) = ((-X1 + X2) - U) - B
      CALL AORD (TEMP,4)
      IF (ABS(TEMP(1)) .GE. 0.1*ABS(TEMP(4))) GO TO 31
         T = TEMP(2)*TEMP(3)*TEMP(4)
         IF (T .NE. 0.0) TEMP(1) = E/T
   31 Z(1) = CMPLX(TEMP(1), 0.0)
      Z(2) = CMPLX(TEMP(2), 0.0)
      Z(3) = CMPLX(TEMP(3), 0.0)
      Z(4) = CMPLX(TEMP(4), 0.0)
      RETURN
C
   40 V1 = SQRT(ABS(X1))
      V2 = 0.0
      GO TO 50
   41 V1 = SQRT(ABS(X1))
      V2 = SQRT(ABS(X2))
      IF (Q .LT. 0.0) U = -U
C
   50 X = -U - B
      Y = V1 - V2
      Z(1) = CMPLX(X, Y)
      Z(2) = CMPLX(X,-Y)
      X =  U - B
      Y = V1 + V2
      Z(3) = CMPLX(X, Y)
      Z(4) = CMPLX(X,-Y)
      RETURN
C
C                THE RESOLVENT CUBIC HAS COMPLEX ROOTS
C
   60 T = REAL(Z(1))
      X = 0.0
      IF (T) 61,70,62
   61 H = ABS(REAL(Z(2))) + ABS(AIMAG(Z(2)))
      IF (ABS(T) .LE. H) GO TO 70
      GO TO 80
   62 X = SQRT(T)
      IF (Q .GT. 0.0) X = -X
C
   70 W = CSQRT(Z(2))
      U = 2.0*REAL(W)
      V = 2.0*ABS(AIMAG(W))
      T =  X - B
      X1 = T + U
      X2 = T - U
      IF (ABS(X1) .LE. ABS(X2)) GO TO 71
         T = X1
         X1 = X2
         X2 = T
   71 U = -X - B
      H = U*U + V*V
      IF (X1*X1 .LT. 0.01*AMIN1(X2*X2,H)) X1 = E/(X2*H)
      Z(1) = CMPLX(X1, 0.0)
      Z(2) = CMPLX(X2, 0.0)
      Z(3) = CMPLX(U, V)
      Z(4) = CMPLX(U,-V)
      RETURN
C
   80 V = SQRT(ABS(T))
      Z(1) = CMPLX(-B, V)
      Z(2) = CMPLX(-B,-V)
      Z(3) = Z(1)
      Z(4) = Z(2)
      RETURN
C
C                         CASE WHEN A(1) = 0
C
  100 Z(1) = (0.0, 0.0)
      CALL CBCRT(A(2), Z(2))
      RETURN
      END
      SUBROUTINE DQTCRT (A, ZR, ZI)
C-----------------------------------------------------------------------
C
C         DQTCRT COMPUTES THE ROOTS OF THE REAL POLYNOMIAL
C               A(1) + A(2)*Z + ... + A(5)*Z**4
C         AND STORES THE RESULTS IN ZR AND ZI. IT IS ASSUMED
C         THAT A(5) IS NONZERO.
C
C-----------------------------------------------------------------------
C     WRITTEN BY ALFRED H. MORRIS
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(5), ZR(4), ZI(4)
      DOUBLE PRECISION B, B2, C, D, E, H, P, Q, R, T, TEMP(4),
     *                 U, V, V1, V2, W(2), X, X1, X2, X3
C
      IF (A(1) .EQ. 0.D0) GO TO 100
      B = A(4)/(4.D0*A(5))
      C = A(3)/A(5)
      D = A(2)/A(5)
      E = A(1)/A(5)
      B2 = B*B
C
      P = 0.5D0*(C - 6.D0*B2)
      Q = D - 2.D0*B*(C - 4.D0*B2)
      R = B2*(C - 3.D0*B2) - B*D + E
C
C          SOLVE THE RESOLVENT CUBIC EQUATION. THE CUBIC HAS
C          AT LEAST ONE NONNEGATIVE REAL ROOT. IF W1, W2, W3
C          ARE THE ROOTS OF THE CUBIC THEN THE ROOTS OF THE
C          ORIGINIAL EQUATION ARE
C
C             Z = -B + CSQRT(W1) + CSQRT(W2) + CSQRT(W3)
C
C          WHERE THE SIGNS OF THE SQUARE ROOTS ARE CHOSEN SO
C          THAT CSQRT(W1) * CSQRT(W2) * CSQRT(W3) = -Q/8.
C
      TEMP(1) = -Q*Q/64.D0
      TEMP(2) = 0.25D0*(P*P - R)
      TEMP(3) =  P
      TEMP(4) = 1.D0
      CALL DCBCRT (TEMP, ZR, ZI)
      IF (ZI(2) .NE. 0.D0) GO TO 60
C
C               THE RESOLVENT CUBIC HAS ONLY REAL ROOTS
C                REORDER THE ROOTS IN INCREASING ORDER
C
      X1 = ZR(1)
      X2 = ZR(2)
      X3 = ZR(3)
      IF (X1 .LE. X2) GO TO 10
         T = X1
         X1 = X2
         X2 = T
   10 IF (X2 .LE. X3) GO TO 20
         T = X2
         X2 = X3
         X3 = T
      IF (X1 .LE. X2) GO TO 20
         T = X1
         X1 = X2
         X2 = T
C
   20 U = 0.D0
      IF (X3 .GT. 0.D0) U = DSQRT(X3)
      IF (X2 .LE. 0.D0) GO TO 41
      IF (X1 .GE. 0.D0) GO TO 30
      IF (DABS(X1) .GT. X2) GO TO 40
      X1 = 0.D0
C
   30 X1 = DSQRT(X1)
      X2 = DSQRT(X2)
      IF (Q .GT. 0.D0) X1 = -X1
      ZR(1) = (( X1 + X2) + U) - B
      ZR(2) = ((-X1 - X2) + U) - B
      ZR(3) = (( X1 - X2) - U) - B
      ZR(4) = ((-X1 + X2) - U) - B
      CALL DAORD (ZR, 4)
      IF (DABS(ZR(1)) .GE. 0.1D0*DABS(ZR(4))) GO TO 31
         T = ZR(2)*ZR(3)*ZR(4)
         IF (T .NE. 0.D0) ZR(1) = E/T
   31 ZI(1) = 0.D0
      ZI(2) = 0.D0
      ZI(3) = 0.D0
      ZI(4) = 0.D0
      RETURN
C
   40 V1 = DSQRT(DABS(X1))
      V2 = 0.D0
      GO TO 50
   41 V1 = DSQRT(DABS(X1))
      V2 = DSQRT(DABS(X2))
      IF (Q .LT. 0.D0) U = -U
C
   50 ZR(1) = -U - B
      ZI(1) = V1 - V2
      ZR(2) =  ZR(1)
      ZI(2) = -ZI(1)
      ZR(3) =  U - B
      ZI(3) = V1 + V2
      ZR(4) =  ZR(3)
      ZI(4) = -ZI(3)
      RETURN
C
C                THE RESOLVENT CUBIC HAS COMPLEX ROOTS
C
   60 T = ZR(1)
      X = 0.D0
      IF (T) 61,70,62
   61 H = DABS(ZR(2)) + DABS(ZI(2))
      IF (DABS(T) .LE. H) GO TO 70
      GO TO 80
   62 X = DSQRT(T)
      IF (Q .GT. 0.D0) X = -X
C
   70 W(1) = ZR(2)
      W(2) = ZI(2)
      CALL DCSQRT (W, W)
      U = 2.D0*W(1)
      V = 2.D0*DABS(W(2))
      T =  X - B
      X1 = T + U
      X2 = T - U
      IF (DABS(X1) .LE. DABS(X2)) GO TO 71
         T = X1
         X1 = X2
         X2 = T
   71 U = -X - B
      H = U*U + V*V
      IF (X1*X1 .LT. 1.D-2*DMIN1(X2*X2,H)) X1 = E/(X2*H)
      ZR(1) = X1
      ZR(2) = X2
      ZI(1) = 0.D0
      ZI(2) = 0.D0
      ZR(3) =  U
      ZR(4) =  U
      ZI(3) =  V
      ZI(4) = -V
      RETURN
C
   80 V = DSQRT(DABS(T))
      ZR(1) = -B
      ZR(2) = -B
      ZR(3) = -B
      ZR(4) = -B
      ZI(1) =  V
      ZI(2) = -V
      ZI(3) =  V
      ZI(4) = -V
      RETURN
C
C                         CASE WHEN A(1) = 0
C
  100 ZR(1) = 0.D0
      ZI(1) = 0.D0
      CALL DCBCRT(A(2), ZR(2), ZI(2))
      RETURN
      END
      SUBROUTINE DRPOLY (OP, IDEG, ZEROR, ZEROI, NUM, WK, DWK)
C
C     THIS SUBROUTINE FINDS THE ZEROS OF A REAL POLYNOMIAL.
C
C     OP          - DOUBLE PRECISION ARRAY OF LENGTH IDEG + 1.
C                   ON INPUT THIS ARRAY CONTAINS THE COEFFICIENTS
C                   IN ORDER OF DECREASING POWERS.
C
C     IDEG        - INTEGER DEGREE OF THE POLYNOMIAL.
C
C     ZEROR,ZEROI - DOUBLE PRECISION ARRAYS IF LENGTH IDEG.
C                   ON OUTPUT THESE ARRAYS CONTAIN THE REAL AND
C                   IMAGINARY PARTS OF THE ZEROS.
C
C     NUM         - VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
C                   IF NUM = -1 THEN THE LEADING COEFFICIENT OF THE
C                   POLYNOMIAL IS 0 OR IDEG .LT. 1. OTHERWISE, NUM
C                   IS THE NUMBER OF ZEROS THAT WERE OBTAINED. IF
C                   NUM .GE. 1 THEN THE REAL AND IMAGINARY PARTS OF
C                   THE ZEROS ARE STORED IN ZEROR(J) AND ZEROI(J)
C                   FOR J = 1,...,NUM.
C
C     WK          - REAL ARRAY OF LENGTH IDEG + 1. THE ARRAY IS
C                   A WORK SPACE FOR THE ROUTINE.
C
C     DWK         - DOUBLE PRECISION ARRAY OF LENGTH 6*(IDEG + 1).
C                   THE ARRAY IS A WORK SPACE FOR THE ROUTINE.
C
C     THE SUBROUTINE USES SINGLE PRECISION CALCULATIONS FOR SCALING,
C     BOUNDS, AND ERROR CALCULATIONS. ALL OTHER CALCULATIONS ARE DONE
C     IN DOUBLE PRECISION.
C
      INTEGER IDEG, NUM
      DOUBLE PRECISION OP(*), ZEROR(IDEG), ZEROI(IDEG), DWK(*)
      REAL WK(*)
C
      INTEGER P, QP, K, QK, SVK, TMP
C
      IF (IDEG .LT. 1) GO TO 10
C
C     PARTITION THE WORKSPACE DWK AND OBTAIN THE ZEROS
C
      IDP1 = IDEG + 1
C
      P  = 1
      QP = P  + IDP1
      K  = QP + IDP1
      QK = K  + IDP1
      SVK = QK  + IDP1
      TMP = SVK + IDP1
C
      CALL DRPLY1 (OP,IDEG,IDP1,ZEROR,ZEROI,DWK(P),DWK(QP),DWK(K),
     *             DWK(QK),DWK(SVK),DWK(TMP),WK,NUM)
      RETURN
C
C     ERROR RETURN
C
   10 NUM = -1
      RETURN
      END
      SUBROUTINE DRPLY1 (OP,IDEG,IDP1,ZEROR,ZEROI,P,QP,K,QK,SVK,
     *                   TEMP,PT,NUM)
C-------------------------
      DOUBLE PRECISION OP(IDP1), ZEROR(IDEG), ZEROI(IDEG),
     *                 P(IDP1), QP(IDP1), K(IDP1), QK(IDP1),
     *                 SVK(IDP1), TEMP(IDP1)
      REAL PT(IDP1)
C
      DOUBLE PRECISION  AA, BB, CC, FACTOR, T
      REAL LO, MAX, MIN, XX, YY, COSR, SINR, X, XXX, SC,
     *     BND, XM, FF, DF, DX, BASE, SMALNO, INFIN
      INTEGER CNT
      LOGICAL ZEROK
C
      REAL SPMPAR
      INTEGER IPMPAR
      DOUBLE PRECISION DPMPAR
C-------------------------
      REAL ETA, ARE, MRE
      DOUBLE PRECISION SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI
      COMMON /GLOBAL/  SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI, ETA, ARE, MRE
C-------------------------
C     THE FOLLOWING STATEMENTS SET THE MACHINE CONSTANTS USED
C     IN THE CODE. THE MEANING OF THE CONSTANTS ARE ...
C
C     ETA     THE SMALLEST POSITIVE NUMBER SUCH THAT
C             1.D0 + ETA IS GREATER THAN 1.D0
C     SMALNO  THE SMALLEST POSITIVE FLOATING POINT NUMBER.
C             IF THE EXPONENT RANGE DIFFERS IN SINGLE AND
C             DOUBLE PRECISION THEN SMALNO AND INFIN
C             SHOULD INDICATE THE SMALLER RANGE.
C     INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
C     BASE    THE BASE OF THE FLOATING POINT ARITHMETICS
C             BEING USED.
C
                       ETA = DPMPAR(1)
                       SMALNO = SPMPAR(2)
                       INFIN = SPMPAR(3)
                       BASE = IPMPAR(4)
C-------------------------
C
C     ARE AND MRE REFER TO THE UNIT ERROR IN + AND *
C     RESPECTIVELY. THEY ARE ASSUMED TO BE THE SAME AS ETA.
C
      ARE = ETA
      MRE = ETA
      LO = SMALNO/ETA
C
C     INITIALIZATION OF CONSTANTS FOR SHIFT ROTATION
C
      XX = .70710678
      YY = -XX
      COSR = -.069756474
      SINR = .99756405
      N = IDEG
      NN = IDP1
      NUM = 0
C
C     ALGORITHM FAILS IF THE LEADING COEFFICIENT IS ZERO.
C
      IF (OP(1) .NE. 0.D0) GO TO 10
         NUM = -1
         RETURN
C
C     REMOVE THE ZEROS AT THE ORIGIN IF ANY
C
   10 IF (OP(NN) .NE. 0.0D0) GO TO 20
         NUM = NUM + 1
         ZEROR(NUM) = 0.D0
         ZEROI(NUM) = 0.D0
         NN = NN - 1
         N = N - 1
         GO TO 10
C
C     MAKE A COPY OF THE COEFFICIENTS
C
   20 DO 30 I = 1,NN
         P(I) = OP(I)
   30 CONTINUE
C
C     START THE ALGORITHM FOR OBTAINING A ZERO
C
   40 IF (N .GT. 2) GO TO 60
      IF (N .LT. 1) RETURN
C
C     CALCULATE THE FINAL ZERO OR PAIR OF ZEROS
C
      NUM = IDEG
      IF (N .EQ. 2) GO TO 50
         ZEROR(IDEG) = -P(2)/P(1)
         ZEROI(IDEG) = 0.0D0
         RETURN
   50 CALL QUADPL(P(1), P(2), P(3), ZEROR(IDEG - 1), ZEROI(IDEG - 1),
     *                  ZEROR(IDEG), ZEROI(IDEG))
      RETURN
C
C     FIND LARGEST AND SMALLEST MODULI OF COEFFICIENTS.
C
   60 MAX = 0.0
      MIN = INFIN
      DO 70 I = 1,NN
         X = ABS(SNGL(P(I)))
         IF (X .GT. MAX) MAX = X
         IF (X .NE. 0.0 .AND. X .LT. MIN) MIN = X
   70 CONTINUE
C
C     SCALE IF THERE ARE LARGE OR VERY SMALL COEFFICIENTS.
C     COMPUTES A SCALE FACTOR TO MULTIPLY THE
C     COEFFICIENTS OF THE POLYNOMIAL. THE SCALING IS DONE
C     TO AVOID OVERFLOW AND TO AVOID UNDETECTED UNDERFLOW
C     INTERFERING WITH THE CONVERGENCE CRITERION.
C     THE FACTOR IS A POWER OF THE BASE.
C
      SC = LO/MIN
      IF (SC .GT. 1.0) GO TO 80
      IF (MAX .LT. 10.0) GO TO 110
      IF (SC .EQ. 0.0) SC = SMALNO
      GO TO 90
   80 IF (INFIN/SC .LT. MAX) GO TO 110
   90 L = ALOG(SC)/ALOG(BASE) + 0.5
      FACTOR = DBLE(BASE)**L
      IF (FACTOR .EQ. 1.D0) GO TO 110
      DO 100 I = 1,NN
         P(I) = FACTOR*P(I)
  100 CONTINUE
C
C     COMPUTE LOWER BOUND ON MODULI OF ZEROS.
C
  110 DO 120 I=1,NN
         PT(I) = ABS(SNGL(P(I)))
  120 CONTINUE
      PT(NN) = -PT(NN)
C
C     COMPUTE UPPER ESTIMATE OF BOUND
C
      X = EXP((ALOG(-PT(NN)) - ALOG(PT(1)))/FLOAT(N))
      IF (PT(N) .EQ. 0.0) GO TO 130
C
C     IF THE NEWTON STEP AT THE ORIGIN IS BETTER THEN USE IT.
C
      XM = -PT(NN)/PT(N)
      IF (XM .LT. X) X = XM
C
C     CHOP THE INTERVAL (0,X) UNTIL FF .LE. 0.
C
  130 XM = X*.1
      FF = PT(1)
      DO 140 I = 2,NN
         FF = FF*XM + PT(I)
  140 CONTINUE
      IF (FF .LE. 0.0) GO TO 150
      X = XM
      GO TO 130
  150 DX = X
C
C     DO NEWTON ITERATION UNTIL X CONVERGES TO TWO DECIMAL PLACES.
C
  160 IF (ABS(DX/X) .LE. 0.005) GO TO 180
      FF = PT(1)
      DF = FF
      DO 170 I = 2,N
         FF = FF*X + PT(I)
         DF = DF*X + FF
  170 CONTINUE
      FF = FF*X + PT(NN)
      DX = FF/DF
      X = X - DX
      GO TO 160
  180 BND = X
C
C     COMPUTE THE DERIVATIVE AS THE INTIAL K POLYNOMIAL
C     AND DO 5 STEPS WITH NO SHIFT.
C
      NM1 = N - 1
      DO 190 I = 2,N
         K(I) = FLOAT(NN - I)*P(I)/FLOAT(N)
  190 CONTINUE
      K(1) = P(1)
      AA = P(NN)
      BB = P(N)
      ZEROK = K(N) .EQ. 0.D0
      DO 230 JJ = 1,5
         CC = K(N)
         IF (ZEROK) GO TO 210
C
C     USE SCALED FORM OF RECURRENCE IF VALUE OF K AT 0 IS NONZERO.
C
         T = -AA/CC
         DO 200 I = 1,NM1
            J = NN - I
            K(J) = T*K(J - 1) + P(J)
  200    CONTINUE
         K(1) = P(1)
         ZEROK = DABS(K(N)) .LE. DABS(BB)*ETA*10.
         GO TO 230
C
C     USE UNSCALED FORM OF RECURRENCE
C
  210    DO 220 I = 1,NM1
            J = NN - I
            K(J) = K(J - 1)
  220    CONTINUE
         K(1) = 0.D0
         ZEROK = K(N).EQ.0.D0
  230 CONTINUE
C
C     SAVE K FOR RESTARTS WITH NEW SHIFTS
C
      DO 240 I = 1,N
         TEMP(I) = K(I)
  240 CONTINUE
C
C     LOOP TO SELECT THE QUADRATIC  CORRESPONDING TO EACH
C     NEW SHIFT
C
      DO 260 CNT = 1,20
C
C     QUADRATIC CORRESPONDS TO A DOUBLE SHIFT TO A
C     NON-REAL POINT AND ITS COMPLEX CONJUGATE. THE POINT
C     HAS MODULUS BND AND AMPLITUDE ROTATED BY 94 DEGREES
C     FROM THE PREVIOUS SHIFT.
C
         XXX = COSR*XX - SINR*YY
         YY = SINR*XX + COSR*YY
         XX = XXX
         SR = BND*XX
         SI = BND*YY
         U = -2.0D0*SR
         V = BND
C
C     SECOND STAGE CALCULATION, FIXED QUADRATIC. THE SECOND STAGE
C     JUMPS DIRECTLY TO ONE OF THE THIRD STAGE ITERATIONS.
C
         CALL FXSHFR(20*CNT, NZ, NN, P, QP, K, QK, SVK)
         IF (NZ .NE. 0) GO TO 300
C
C     IF THE ITERATION IS UNSUCCESSFUL ANOTHER QUADRATIC
C     IS CHOSEN AFTER RESTORING K.
C
         DO 250 I = 1,N
            K(I) = TEMP(I)
  250    CONTINUE
  260 CONTINUE
C
C     CONVERGENCE WAS NOT ACHIEVED AFTER 20 SHIFTS.
C
      RETURN
C
C     STORE THE ZEROS OBTAINED AND DEFLATE THE POLYNOMIAL.
C
  300 NUM = NUM + 1
      ZEROR(NUM) = SZR
      ZEROI(NUM) = SZI
      NN = NN - NZ
      N = NN - 1
      DO 310 I = 1,NN
         P(I) = QP(I)
  310 CONTINUE
      IF (NZ .EQ. 1) GO TO 40
      NUM = NUM + 1
      ZEROR(NUM) = LZR
      ZEROI(NUM) = LZI
      GO TO 40
      END
      SUBROUTINE FXSHFR(L2, NZ, NN, P, QP, K, QK, SVK)
C
C     COMPUTES UP TO  L2  FIXED SHIFT K-POLYNOMIALS,
C     TESTING FOR CONVERGENCE IN THE LINEAR OR QUADRATIC
C     CASE. INITIATES ONE OF THE VARIABLE SHIFT
C     ITERATIONS AND RETURNS WITH THE NUMBER OF ZEROS
C     FOUND.
C
C     L2 - LIMIT OF FIXED SHIFT STEPS
C     NZ - NUMBER OF ZEROS FOUND
C
      DOUBLE PRECISION P(NN), QP(NN), K(NN), QK(NN), SVK(NN)
      DOUBLE PRECISION SVU, SVV, UI, VI, S
      REAL BETAS, BETAV, OSS, OVV, SS, VV, TS, TV, OTS, OTV,
     *     TVV, TSS
      INTEGER L2, NZ, TYPE, I, J, IFLAG
      LOGICAL VPASS, SPASS, VTRY, STRY
C
      REAL ETA, ARE, MRE
      DOUBLE PRECISION SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI
      COMMON /GLOBAL/  SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI, ETA, ARE, MRE
C
      N = NN - 1
      NZ = 0
      BETAV = .25
      BETAS = .25
      OSS = SR
      OVV = V
C
C     EVALUATE POLYNOMIAL BY SYNTHETIC DIVISION
C
      CALL QUADSD(NN, U, V, P, QP, A, B)
      CALL CALCSC(TYPE, N, K, QK)
      DO 80 J = 1,L2
C
C     CALCULATE NEXT K POLYNOMIAL AND ESTIMATE V
C
         CALL NEXTK(TYPE, N, QP, K, QK)
         CALL CALCSC(TYPE, N, K, QK)
         CALL NEWEST(TYPE, UI, VI, NN, P, K)
         VV = VI
C
C     ESTIMATE S
C
         SS = 0.0
         IF (K(N) .NE. 0.D0) SS = -P(NN)/K(N)
         TV = 1.0
         TS = 1.0
         IF (J .EQ. 1 .OR. TYPE .EQ. 3) GO TO 70
C
C     COMPUTE RELATIVE MEASURES OF CONVERGENCE OF S AND V
C     SEQUENCES
C
         IF (VV .NE. 0.0) TV = ABS((VV - OVV)/VV)
         IF (SS .NE. 0.0) TS = ABS((SS - OSS)/SS)
C
C     IF DECREASING, MULTIPLY TWO MOST RECENT
C     CONVERGENCE MEASURES
C
         TVV = 1.0
         IF (TV .LT. OTV) TVV = TV*OTV
         TSS = 1.0
         IF (TS .LT. OTS) TSS = TS*OTS
C
C     COMPARE WITH CONVERGENCE CRITERIA
C
         VPASS = TVV.LT.BETAV
         SPASS = TSS.LT.BETAS
         IF (.NOT.(SPASS .OR. VPASS)) GO TO 70
C
C     AT LEAST ONE SEQUENCE HAS PASSED THE CONVERGENCE
C     TEST. STORE VARIABLES BEFORE ITERATING
C
         SVU = U
         SVV = V
         DO 10 I = 1,N
            SVK(I) = K(I)
   10    CONTINUE
         S = SS
C
C     CHOOSE ITERATION ACCORDING TO THE FASTEST
C     CONVERGING SEQUENCE
C
         VTRY = .FALSE.
         STRY = .FALSE.
         IF (SPASS .AND. ((.NOT.VPASS) .OR.
     *                      TSS .LT. TVV)) GO TO 40
   20    CALL QUADIT(UI, VI, NZ, NN, P, QP, K, QK)
         IF (NZ .GT. 0) RETURN
C
C     QUADRATIC ITERATION HAS FAILED. FLAG THAT IT HAS
C     BEEN TRIED AND DECREASE THE CONVERGENCE CRITERION.
C
         VTRY = .TRUE.
         BETAV = BETAV*0.25
C
C     TRY LINEAR ITERATION IF IT HAS NOT BEEN TRIED AND
C     THE S SEQUENCE IS CONVERGING
C
         IF (STRY .OR. (.NOT.SPASS)) GO TO 50
         DO 30 I = 1,N
            K(I) = SVK(I)
   30    CONTINUE
   40    CALL REALIT(S, NZ, IFLAG, NN, P, QP, K, QK)
         IF (NZ .GT. 0) RETURN
C
C     LINEAR ITERATION HAS FAILED. FLAG THAT IT HAS BEEN
C     TRIED AND DECREASE THE CONVERGENCE CRITERION
C
         STRY = .TRUE.
         BETAS = BETAS*0.25
         IF (IFLAG .EQ. 0) GO TO 50
C
C     IF LINEAR ITERATION SIGNALS AN ALMOST DOUBLE REAL
C     ZERO ATTEMPT QUADRATIC INTERATION
C
         UI = -(S + S)
         VI = S*S
         GO TO 20
C
C     RESTORE VARIABLES
C
   50    U = SVU
         V = SVV
         DO 60 I=1,N
            K(I) = SVK(I)
   60    CONTINUE
C
C     TRY QUADRATIC ITERATION IF IT HAS NOT BEEN TRIED
C     AND THE V SEQUENCE IS CONVERGING
C
         IF (VPASS .AND. (.NOT.VTRY)) GO TO 20
C
C     RECOMPUTE QP AND SCALAR VALUES TO CONTINUE THE
C     SECOND STAGE
C
         CALL QUADSD(NN, U, V, P, QP, A, B)
         CALL CALCSC(TYPE, N, K, QK)
   70    OVV = VV
         OSS = SS
         OTV = TV
         OTS = TS
   80 CONTINUE
      RETURN
      END
      SUBROUTINE QUADIT(UU, VV, NZ, NN, P, QP, K, QK)
C
C     VARIABLE-SHIFT K-POLYNOMIAL ITERATION FOR A
C     QUADRATIC FACTOR CONVERGES ONLY IF THE ZEROS ARE
C     EQUIMODULAR OR NEARLY SO.
C
C     UU,VV - COEFFICIENTS OF STARTING QUADRATIC
C     NZ - NUMBER OF ZERO FOUND
C
      DOUBLE PRECISION UU, VV, P(NN), QP(NN), K(NN), QK(NN)
      DOUBLE PRECISION UI, VI
      REAL MP, OMP, EE, RELSTP, T, ZM
      INTEGER NZ, TYPE, I, J
      LOGICAL TRIED
C
      REAL ETA, ARE, MRE
      DOUBLE PRECISION SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI
      COMMON /GLOBAL/  SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI, ETA, ARE, MRE
C
      N = NN - 1
      NZ = 0
      TRIED = .FALSE.
      U = UU
      V = VV
      J = 0
C MAIN LOOP
   10 CALL QUADPL(1.D0, U, V, SZR, SZI, LZR, LZI)
C
C     RETURN IF ROOTS OF THE QUADRATIC ARE REAL AND NOT CLOSE
C     TO MULTIPLE OR NEARLY EQUAL AND OF OPPOSITE SIGN
C
      IF (DABS(DABS(SZR) - DABS(LZR)) .GT. 1.D-2*DABS(LZR))
     *            RETURN
C
C     EVALUATE POLYNOMIAL BY QUADRATIC SYNTHETIC DIVISION
C
      CALL QUADSD(NN, U, V, P, QP, A, B)
      MP = DABS(A - SZR*B) + DABS(SZI*B)
C
C     COMPUTE A RIGOROUS BOUND ON THE ROUNDING ERROR IN
C     EVALUTING P
C
      ZM = SQRT(ABS(SNGL(V)))
      EE = 2.0*ABS(SNGL(QP(1)))
      T = -SZR*B
      DO 20 I = 2,N
         EE = EE*ZM + ABS(SNGL(QP(I)))
   20 CONTINUE
      EE = EE*ZM + ABS(SNGL(A) + T)
      EE = (5.0*MRE + 4.0*ARE)*EE - (5.0*MRE + 2.0*ARE)*
     *     (ABS(SNGL(A) + T) + ABS(SNGL(B))*ZM) +
     *     2.0*ARE*ABS(T)
C
C     ITERATION HAS CONVERGED SUFFICIENTLY IF THE
C     POLYNOMIAL VALUE IS LESS THAN 20 TIMES THIS BOUND
C
      IF (MP .GT. 20.0*EE) GO TO 30
      NZ = 2
      RETURN
   30 J = J + 1
C
C     STOP ITERATION AFTER 20 STEPS
C
      IF (J .GT. 20) RETURN
      IF (J .LT. 2) GO TO 50
      IF (RELSTP .GT. 0.01 .OR. MP .LT. OMP .OR. TRIED) GO TO 50
C
C     A CLUSTER APPEARS TO BE STALLING THE CONVERGENCE.
C     FIVE FIXED SHIFT STEPS ARE TAKEN WITH A U,V CLOSE
C     TO THE CLUSTER
C
      IF (RELSTP .LT. ETA) RELSTP = ETA
      RELSTP = SQRT(RELSTP)
      U = U - U*RELSTP
      V = V + V*RELSTP
      CALL QUADSD(NN, U, V, P, QP, A, B)
      DO 40 I = 1,5
         CALL CALCSC(TYPE, N, K, QK)
         CALL NEXTK(TYPE, N, QP, K, QK)
   40 CONTINUE
      TRIED = .TRUE.
      J = 0
   50 OMP = MP
C
C     CALCULATE NEXT K POLYNOMIAL AND NEW U AND V
C
      CALL CALCSC(TYPE, N, K, QK)
      CALL NEXTK(TYPE, N, QP, K, QK)
      CALL CALCSC(TYPE, N, K, QK)
      CALL NEWEST(TYPE, UI, VI, NN, P, K)
C
C     IF VI IS ZERO THE ITERATION IS NOT CONVERGING
C
      IF (VI .EQ. 0.D0) RETURN
      RELSTP = DABS((VI - V)/VI)
      U = UI
      V = VI
      GO TO 10
      END
      SUBROUTINE REALIT(SSS, NZ, IFLAG, NN, P, QP, K, QK)
C
C     VARIABLE-SHIFT H POLYNOMIAL ITERATION FOR A REAL ZERO.
C
C     SSS   - STARTING ITERATE
C     NZ    - NUMBER OF ZERO FOUND
C     IFLAG - FLAG TO INDICATE A PAIR OF ZEROS NEAR THE REAL
C             AXIS.
C
      DOUBLE PRECISION SSS, P(NN), QP(NN), K(NN), QK(NN)
      DOUBLE PRECISION PV, KV, T, S
      REAL MS, MP, OMP, EE
C
      REAL ETA, ARE, MRE
      DOUBLE PRECISION SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI
      COMMON /GLOBAL/  SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI, ETA, ARE, MRE
C
      N = NN - 1
      NZ = 0
      S = SSS
      IFLAG = 0
      J = 0
C
C     EVALUATE P AT S
C
   10 PV = P(1)
      QP(1) = PV
      DO 20 I = 2,NN
         PV = PV*S + P(I)
         QP(I) = PV
   20 CONTINUE
      MP = DABS(PV)
C
C     COMPUTE A RIGOROUS BOUND ON THE ERROR IN EVALUATING P
C
      MS = DABS(S)
      EE = (MRE/(ARE+MRE))*ABS(SNGL(QP(1)))
      DO 30 I = 2,NN
         EE = EE*MS + ABS(SNGL(QP(I)))
   30 CONTINUE
C
C     ITERATION HAS CONVERGED SUFFICIENTLY IF THE
C     POLYNOMIAL VALUE IS LESS THAN 20 TIMES THIS BOUND
C
      IF (MP .GT. 20.0*((ARE + MRE)*EE - MRE*MP)) GO TO 40
      NZ = 1
      SZR = S
      SZI = 0.D0
      RETURN
   40 J = J + 1
C
C     STOP ITERATION AFTER 10 STEPS
C
      IF (J .GT. 10) RETURN
      IF (J .LT. 2) GO TO 50
      IF (DABS(T) .GT. 1.D-3*DABS(S-T) .OR. MP .LE. OMP)
     *      GO TO 50
C
C     A CLUSTER OF ZEROS NEAR THE REAL AXIS HAS BEEN
C     ENCOUNTERED RETURN WITH IFLAG SET TO INITIATE A
C     QUADRATIC ITERATION
C
      IFLAG = 1
      SSS = S
      RETURN
C
C     RETURN IF THE POLYNOMIAL VALUE HAS INCREASED
C     SIGNIFICANTLY
C
   50 OMP = MP
C
C     COMPUTE T, THE NEXT POLYNOMIAL, AND THE NEW ITERATE
C
      KV = K(1)
      QK(1) = KV
      DO 60 I = 2,N
         KV = KV*S + K(I)
         QK(I) = KV
   60 CONTINUE
      IF (DABS(KV) .LE. DABS(K(N))*10.*ETA) GO TO 80
C
C     USE THE SCALED FORM OF THE RECURRENCE IF THE VALUE
C     OF K AT S IS NONZERO
C
      T = -PV/KV
      K(1) = QP(1)
      DO 70 I = 2,N
         K(I) = T*QK(I-1) + QP(I)
   70 CONTINUE
      GO TO 100
C
C     USE UNSCALED FORM
C
   80 K(1) = 0.0D0
      DO 90 I = 2,N
         K(I) = QK(I-1)
   90 CONTINUE
  100 KV = K(1)
      DO 110 I = 2,N
         KV = KV*S + K(I)
  110 CONTINUE
      T = 0.D0
      IF (DABS(KV) .GT. DABS(K(N))*10.*ETA) T = -PV/KV
      S = S + T
      GO TO 10
      END
      SUBROUTINE CALCSC(TYPE, N, K, QK)
C
C     THIS ROUTINE CALCULATES SCALAR QUANTITIES USED TO
C     COMPUTE THE NEXT K POLYNOMIAL AND NEW ESTIMATES OF
C     THE QUADRATIC COEFFICIENTS.
C
C     TYPE - INTEGER VARIABLE SET HERE INDICATING HOW THE
C            CALCULATIONS ARE NORMALIZED TO AVOID OVERFLOW
C
      INTEGER TYPE
      DOUBLE PRECISION K(N), QK(N)
      DOUBLE PRECISION TOL
C
      REAL ETA, ARE, MRE
      DOUBLE PRECISION SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI
      COMMON /GLOBAL/  SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI, ETA, ARE, MRE
C
C     SYNTHETIC DIVISION OF K BY THE QUADRATIC 1,U,V
C
      CALL QUADSD(N, U, V, K, QK, C, D)
      TOL = 100.0*ETA
      IF (DABS(C) .GT. TOL*DABS(K(N))) GO TO 10
      IF (DABS(D) .GT. TOL*DABS(K(N - 1))) GO TO 10
      TYPE = 3
C
C     TYPE=3 INDICATES THE QUADRATIC IS ALMOST A FACTOR OF K
C
      RETURN
   10 IF (DABS(D) .LT. DABS(C)) GO TO 20
      TYPE = 2
C
C     TYPE=2 INDICATES THAT ALL FORMULAS ARE DIVIDED BY D
C
      E = A/D
      F = C/D
      G = U*B
      H = V*B
      A3 = (A + G)*E + H*(B/D)
      A1 = B*F - A
      A7 = (F + U)*A + H
      RETURN
   20 TYPE = 1
C
C     TYPE=1 INDICATES THAT ALL FORMULAS ARE DIVIDED BY C
C
      E = A/C
      F = D/C
      G = U*E
      H = V*B
      A3 = A*E + (H/C + G)*B
      A1 = B - A*(D/C)
      A7 = A + G*D + H*F
      RETURN
      END
      SUBROUTINE NEXTK(TYPE, N, QP, K, QK)
C
C     COMPUTES THE NEXT K POLYNOMIALS USING THE SCALARS
C     COMPUTED IN CALCSC.
C
      INTEGER TYPE
      DOUBLE PRECISION QP(N), K(N), QK(N)
      DOUBLE PRECISION TEMP
      REAL ETA, ARE, MRE
      DOUBLE PRECISION SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI
      COMMON /GLOBAL/  SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI, ETA, ARE, MRE
C
      IF (TYPE .EQ. 3) GO TO 40
      TEMP = A
      IF (TYPE .EQ. 1) TEMP = B
      IF (DABS(A1) .GT. DABS(TEMP)*ETA*10.) GO TO 20
C
C     IF A1 IS NEARLY ZERO THEN USE A SPECIAL FORM OF THE
C     RECURRENCE
C
      K(1) = 0.D0
      K(2) = -A7*QP(1)
      DO 10 I = 3,N
         K(I) = A3*QK(I-2) - A7*QP(I-1)
   10 CONTINUE
      RETURN
C
C     USE SCALED FORM OF THE RECURRENCE
C
   20 A7 = A7/A1
      A3 = A3/A1
      K(1) = QP(1)
      K(2) = QP(2) - A7*QP(1)
      DO 30 I = 3,N
         K(I) = A3*QK(I-2) - A7*QP(I-1) + QP(I)
   30 CONTINUE
      RETURN
C
C     USE UNSCALED FORM OF THE RECURRENCE IF TYPE IS 3
C
   40 K(1) = 0.D0
      K(2) = 0.D0
      DO 50 I = 3,N
         K(I) = QK(I - 2)
   50 CONTINUE
      RETURN
      END
      SUBROUTINE NEWEST (TYPE, UU, VV, NN, P, K)
C
C     COMPUTE NEW ESTIMATES OF THE QUADRATIC COEFFICIENTS
C     USING THE SCALARS COMPUTED IN CALCSC.
C
      INTEGER TYPE
      DOUBLE PRECISION UU, VV, P(NN), K(NN)
      DOUBLE PRECISION A4, A5, B1, B2, C1, C2, C3, C4, TEMP
C
      REAL ETA, ARE, MRE
      DOUBLE PRECISION SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI
      COMMON /GLOBAL/  SR, SI, U, V, A, B, C, D, A1, A2, A3, A6, A7,
     *                 E, F, G, H, SZR, SZI, LZR, LZI, ETA, ARE, MRE
C
C     USE FORMULAS APPROPRIATE TO SETTING OF TYPE.
C
      N = NN - 1
      IF (TYPE .EQ. 3) GO TO 30
      IF (TYPE .EQ. 2) GO TO 10
         A4 = A + U*B + H*F
         A5 = C + (U + V*F)*D
         GO TO 20
   10 A4 = (A + G)*F + H
      A5 = (F + U)*C + V*D
C
C     EVALUATE NEW QUADRATIC COEFFICIENTS.
C
   20 B1 = -K(N)/P(NN)
      B2 = -(K(N - 1) + B1*P(N))/P(NN)
      C1 = V*B2*A1
      C2 = B1*A7
      C3 = B1*B1*A3
      C4 = C1 - C2 - C3
      TEMP = A5 + B1*A4 - C4
      IF (TEMP .EQ. 0.D0) GO TO 30
      UU = U - (U*(C3 + C2) + V*(B1*A1 + B2*A7))/TEMP
      VV = V*(1.D0 + C4/TEMP)
      RETURN
C
C     IF TYPE=3 THE QUADRATIC IS ZEROED
C
   30 UU = 0.D0
      VV = 0.D0
      RETURN
      END
      SUBROUTINE QUADSD (NN, U, V, P, Q, A, B)
C
C     DIVIDES P BY THE QUADRATIC  1,U,V  PLACING THE
C     QUOTIENT IN Q AND THE REMAINDER IN A,B.
C
      DOUBLE PRECISION P(NN), Q(NN), U, V, A, B, C
C
      B = P(1)
      Q(1) = B
      A = P(2) - U*B
      Q(2) = A
      DO 10 I = 3,NN
         C = P(I) - U*A - V*B
         Q(I) = C
         B = A
         A = C
   10 CONTINUE
      RETURN
      END
      SUBROUTINE QUADPL(A, B1, C, SR, SI, LR, LI)
C
C     CALCULATE THE ZEROS OF THE QUADRATIC A*Z**2+B1*Z+C.
C     THE QUADRATIC FORMULA, MODIFIED TO AVOID OVERFLOW,
C     IS USED TO FIND THE LARGER ZERO IF THE ZEROS ARE
C     REAL, AND BOTH ZEROS IF THE ZEROS ARE COMPLEX.
C     THE SMALLER REAL ZERO IS FOUND DIRECTLY FROM THE
C     PRODUCT OF THE ZEROS C/A.
C
      DOUBLE PRECISION A, B1, C, SR, SI, LR, LI, B, D, E
C
      IF (A .NE. 0.D0) GO TO 20
         SR = 0.D0
         IF (B1 .NE. 0.D0) SR = -C/B1
         LR = 0.D0
   10    SI = 0.D0
         LI = 0.D0
         RETURN
C
   20 IF (C .NE. 0.D0) GO TO 30
         SR = 0.D0
         LR = -B1/A
         GO TO 10
C
C     COMPUTE DISCRIMINANT AVOIDING OVERFLOW
C
   30 B = B1/2.D0
      IF (DABS(B) .LT. DABS(C)) GO TO 40
         E = 1.D0 - (A/B)*(C/B)
         D = DSQRT(DABS(E))*DABS(B)
         GO TO 50
   40 E = A
      IF (C .LT. 0.D0) E = -A
      E = B*(B/DABS(C)) - E
      D = DSQRT(DABS(E))*DSQRT(DABS(C))
   50 IF (E .LT. 0.D0) GO TO 60
C
C     REAL ZEROS
C
      IF (B .GE. 0.D0) D = -D
      LR = (-B + D)/A
      SR = 0.D0
      IF (LR .NE. 0.D0) SR = (C/LR)/A
      GO TO 10
C
C     COMPLEX CONJUGATE ZEROS
C
   60 SR = -B/A
      LR = SR
      SI = DABS(D/A)
      LI = -SI
      RETURN
      END
      SUBROUTINE DCPOLY (OPR,OPI,IDEG,ZEROR,ZEROI,NUM,WK)
C
C     THIS SUBROUTINE FINDS THE ZEROS OF A COMPLEX POLYNOMIAL.
C
C     OPR,OPI     - DOUBLE PRECISION ARRAYS OF LENGTH IDEG + 1.
C                   ON INPUT THESE ARRAYS CONTAIN THE REAL AND IMAGINARY
C                   PARTS OF THE COEFFICIENTS IN ORDER OF DECREASING
C                   POWERS.
C
C     IDEG        - INTEGER DEGREE OF THE POLYNOMIAL.
C
C     ZEROR,ZEROI - DOUBLE PRECISION ARRAYS OF LENGTH IDEG.
C                   ON OUTPUT THESE ARRAYS CONTAIN THE REAL AND
C                   IMAGINARY PARTS OF THE ZEROS.
C
C     NUM         - VARIABLE THAT REPORTS THE STATUS OF THE RESULTS.
C                   IF NUM = -1 THEN THE LEADING COEFFICIENT OF THE
C                   POLYNOMIAL IS 0 OR IDEG .LT. 1. OTHERWISE, NUM
C                   IS THE NUMBER OF ZEROS THAT WERE OBTAINED. IF
C                   NUM .GE. 1 THEN THE REAL AND IMAGINARY PARTS OF
C                   THE ZEROS ARE STORED IN ZEROR(J) AND ZEROI(J)
C                   FOR J = 1,...,NUM.
C
C     WK          - DOUBLE PRECISION ARRAY OF LENGTH 10*(IDEG + 1).
C                   THE ARRAY IS A WORK SPACE FOR THE ROUTINE.
C
C     THE CODE HAS BEEN WRITTEN TO REDUCE THE CHANCE OF OVERFLOW
C     OCCURRING. IF IT DOES OCCUR, THERE IS STILL A POSSIBILITY THAT
C     THE ZEROFINDER WILL WORK PROVIDED THE OVERFLOWED QUANTITY IS
C     REPLACED BY A LARGE NUMBER.
C
      INTEGER IDEG
      DOUBLE PRECISION OPR(*),OPI(*),ZEROR(IDEG),ZEROI(IDEG),WK(*)
C
      INTEGER PR,PI,QPR,QPI,HR,HI,QHR,QHI,SHR,SHI
C
      IF (IDEG .LT. 1) GO TO 10
C
C     PARTITION THE WORKSPACE AND OBTAIN THE ZEROS
C
      IDP1 = IDEG + 1
C
      PR  = 1
      PI  = PR +  IDP1
      QPR = PI +  IDP1
      QPI = QPR + IDP1
      HR  = QPI + IDP1
      HI  = HR  + IDP1
      QHR = HI  + IDP1
      QHI = QHR + IDP1
      SHR = QHI + IDP1
      SHI = SHR + IDP1
C
      CALL DCPLY1 (OPR,OPI,IDEG,IDP1,ZEROR,ZEROI,WK(PR),WK(PI),
     *             WK(QPR),WK(QPI),WK(HR),WK(HI),WK(QHR),WK(QHI),
     *             WK(SHR),WK(SHI),NUM)
      RETURN
C
C     ERROR RETURN
C
   10 NUM = -1
      RETURN
      END
      SUBROUTINE DCPLY1 (OPR,OPI,IDEG,IDP1,ZEROR,ZEROI,PR,PI,QPR,QPI,
     *                   HR,HI,QHR,QHI,SHR,SHI,NUM)
C-------------------------
      DOUBLE PRECISION OPR(IDP1),OPI(IDP1),ZEROR(IDEG),ZEROI(IDEG),
     *                 PR(IDP1),PI(IDP1),QPR(IDP1),QPI(IDP1),
     *                 HR(IDP1),HI(IDP1),QHR(IDP1),QHI(IDP1),
     *                 SHR(IDP1),SHI(IDP1)
      DOUBLE PRECISION SR,SI,TR,TI,PVR,PVI,ARE,MRE,ETA,INFIN
      DOUBLE PRECISION XX,YY,COSR,SINR,SMALNO,BASE,XXX,ZR,ZI,BND,
     *                 DCPABS,DPMPAR,SCALCP
      LOGICAL CONV
      INTEGER CNT1,CNT2
C-------------------------
C     THE FOLLOWING STATEMENTS SET THE MACHINE CONSTANTS USED
C     IN THE CODE. THE MEANING OF THE CONSTANTS ARE ...
C
C     ETA     THE SMALLEST POSITIVE NUMBER SUCH THAT
C             1.D0 + ETA IS GREATER THAN 1.D0
C     SMALNO  THE SMALLEST POSITIVE FLOATING POINT NUMBER.
C     INFIN   THE LARGEST POSITIVE FLOATING POINT NUMBER.
C     BASE    THE BASE OF THE FLOATING POINT ARITHMETIC
C             BEING USED.
C
                       ETA = DPMPAR(1)
                       SMALNO = DPMPAR(2)
                       INFIN = DPMPAR(3)
                       BASE = IPMPAR(4)
C-------------------------
C
C     INITIALIZATION
C
         ARE = ETA
         MRE = 2.D0*DSQRT(2.D0)*ETA
         XX = .70710678
         YY = -XX
         COSR = -.069756474
         SINR = .99756405
         NUM = 0
         NN = IDP1
C
C     THE ALGORITHM FAILS IF THE LEADING COEFFICIENT IS ZERO
C
         IF (OPR(1) .NE. 0.D0 .OR. OPI(1) .NE. 0.D0) GO TO 10
            NUM = -1
            RETURN
C
C     REMOVE THE ZEROS AT THE ORIGIN IF ANY.
C
   10    IF (OPR(NN) .NE. 0.D0 .OR. OPI(NN) .NE. 0.D0) GO TO 20
            NUM = NUM + 1
            ZEROR(NUM) = 0.D0
            ZEROI(NUM) = 0.D0
            NN = NN - 1
            GO TO 10
C
C     MAKE A COPY OF THE COEFFICIENTS.
C
   20    IF (NN .LT. 2) RETURN
         DO 30 I = 1,NN
            PR(I) = OPR(I)
            PI(I) = OPI(I)
            SHR(I) = DCPABS(PR(I),PI(I))
   30    CONTINUE
C
C     SCALE THE POLYNOMIAL.
C
         BND = SCALCP (NN,SHR,ETA,INFIN,SMALNO,BASE)
         IF (BND .EQ. 1.D0) GO TO 40
         DO 35 I = 1,NN
            PR(I) = BND*PR(I)
            PI(I) = BND*PI(I)
   35    CONTINUE
C
C     START THE ALGORITHM FOR OBTAINING A ZERO.
C
   40    IF (NN .GT. 2) GO TO 50
C
            NUM = IDEG
            CALL CDIVID(-PR(2),-PI(2),PR(1),PI(1),ZEROR(IDEG),
     *                   ZEROI(IDEG))
            RETURN
C
C     CALCULATE BND, A LOWER BOUND ON THE MODULUS OF THE ZEROS.
C
   50    DO 60 I = 1,NN
            SHR(I) = DCPABS(PR(I),PI(I))
   60    CONTINUE
         CALL CAUCHY(NN,BND,SHR,SHI)
C
C     OUTER LOOP TO CONTROL TWO MAJOR PASSES WITH DIFFERENT
C     SEQUENCES OF SHIFTS.
C
         DO 80 CNT1 = 1,2
C
C     FIRST STAGE CALCULATION. NO SHIFT.
C
            CALL NOSHFT(5,NN,TR,TI,ETA,PR,PI,HR,HI)
C
C     INNER LOOP TO SELECT A SHIFT.
C
            DO 70 CNT2 = 1,9
C
C     THE SHIFT IS CHOSEN WITH MODULUS BND AND AMPLITUDE ROTATED
C     BY 94 DEGREES FROM THE PREVIOUS SHIFT.
C
               XXX = COSR*XX - SINR*YY
               YY = SINR*XX + COSR*YY
               XX = XXX
               SR = BND*XX
               SI = BND*YY
C
C     SECOND STAGE CALCULATION, FIXED SHIFT. THE SECOND STAGE JUMPS
C     DIRECTLY TO THE THIRD STAGE ITERATION.
C
               CALL FXSHFT(10*CNT2,ZR,ZI,CONV,NN,PR,PI,HR,HI,QPR,QPI,
     *                     QHR,QHI,SHR,SHI,SR,SI,TR,TI,PVR,PVI,
     *                     ARE,MRE,ETA,INFIN)
               IF (CONV) GO TO 100
C
C     IF THE ITERATION IS UNSUCCESSFUL ANOTHER SHIFT IS CHOSEN.
C
   70       CONTINUE
C
C     IF 9 SHIFTS FAIL, THE OUTER LOOP IS REPEATED WITH ANOTHER
C     SEQUENCE OF SHIFTS.
C
   80    CONTINUE
         RETURN
C
C     A ZERO HAS BEEN OBTAINED. STORE THE ZERO AND DEFLATE
C     THE POLYNOMIAL.
C
  100    NUM = NUM + 1
         ZEROR(NUM) = ZR
         ZEROI(NUM) = ZI
         NN = NN - 1
         DO 110 I = 1,NN
            PR(I) = QPR(I)
            PI(I) = QPI(I)
  110    CONTINUE
         GO TO 40
         END
      DOUBLE PRECISION FUNCTION SCALCP(NN,PT,ETA,INFIN,SMALNO,BASE)
C
C     RETURNS A SCALE FACTOR TO MULTIPLY THE COEFFICIENTS OF THE
C     POLYNOMIAL. THE SCALING IS DONE TO AVOID OVERFLOW AND TO AVOID
C     UNDETECTED UNDERFLOW INTERFERING WITH THE CONVERGENCE CRITERION.
C     THE FACTOR IS A POWER OF THE BASE.
C
C     PT - MODULUS OF THE COEFFICIENTS OF P
C     ETA,INFIN,SMALNO,BASE - CONSTANTS DESCRIBING THE
C            FLOATING POINT ARITHMETIC.
C
      DOUBLE PRECISION PT(NN),ETA,INFIN,SMALNO,BASE,HI,LO,
     *                 MAX,MIN,X,SC
C
C     FIND THE LARGEST AND SMALLEST MODULI OF COEFFICIENTS.
C
      HI = DSQRT(INFIN)
      LO = SMALNO/ETA
      MAX = 0.D0
      MIN = INFIN
      DO 10 I = 1,NN
         X = PT(I)
         IF (X .GT. MAX) MAX = X
         IF (X .NE. 0.D0 .AND. X .LT. MIN) MIN = X
   10 CONTINUE
C
C     SCALE ONLY IF THERE ARE VERY LARGE OR VERY SMALL COEFFICIENTS.
C
      SCALCP = 1.D0
      SC = LO/MIN
      IF (SC .GT. 1.D0) GO TO 20
      IF (MAX .LE. HI) RETURN
      SC = 1.D0/(DSQRT(MAX)*DSQRT(MIN))
      GO TO 30
   20 IF (INFIN/SC .LT. MAX) RETURN
   30 L = DLOG(SC)/DLOG(BASE) + 0.5D0
      SCALCP = BASE**L
      RETURN
      END
      SUBROUTINE CAUCHY(NN,BND,PT,Q)
C
C     CAUCHY COMPUTES A LOWER BOUND BND ON THE MODULI OF THE ZEROS
C     OF A POLYNOMIAL. PT IS THE MODULUS OF THE COEFFICIENTS.
C
      DOUBLE PRECISION Q(NN),PT(NN),X,XM,F,DX,DF,BND
C
      PT(NN) = -PT(NN)
C
C     COMPUTE UPPER ESTIMATE OF BOUND.
C
      N = NN - 1
      X = DEXP((DLOG(-PT(NN)) - DLOG(PT(1)))/DBLE(FLOAT(N)))
      IF (PT(N) .EQ. 0.D0) GO TO 20
C
C     IF THE NEWTON STEP AT THE ORIGIN IS BETTER THEN USE IT.
C
         XM = -PT(NN)/PT(N)
         IF (XM .LT. X) X = XM
C
C     CHOP THE INTERVAL (0,X) UNTIL F .LE. 0.
C
   20 XM = 0.1D0*X
      F = PT(1)
      DO 30 I = 2,NN
         F = F*XM + PT(I)
   30 CONTINUE
      IF (F .LE. 0.D0) GO TO 40
         X = XM
         GO TO 20
   40 DX = X
C
C     DO NEWTON ITERATION UNTIL X CONVERGES TO TWO DECIMAL PLACES.
C
   50 IF (DABS(DX/X) .LE. 0.005D0) GO TO 70
         Q(1) = PT(1)
         DO 60 I = 2,NN
            Q(I) = Q(I - 1)*X + PT(I)
   60    CONTINUE
         F = Q(NN)
         DF = Q(1)
         DO 65 I = 2,N
            DF = DF*X + Q(I)
   65    CONTINUE
         DX = F/DF
         X = X - DX
         GO TO 50
C
   70 BND = X
      RETURN
      END
      SUBROUTINE NOSHFT(L1,NN,TR,TI,ETA,PR,PI,HR,HI)
C
C     COMPUTES THE DERIVATIVE POLYNOMIAL AS THE INITIAL H
C     POLYNOMIAL AND COMPUTES L1 NO-SHIFT H POLYNOMIALS.
C
      DOUBLE PRECISION TR,TI,ETA,PR(NN),PI(NN),HR(NN),HI(NN)
      DOUBLE PRECISION DN,T1,T2,XNI,DCPABS
C
      N = NN - 1
      NM1 = N - 1
      DN = N
      DO 10 I = 1,N
         XNI = NN - I
         HR(I) = XNI*PR(I)/DN
         HI(I) = XNI*PI(I)/DN
   10 CONTINUE
C
      DO 50 JJ = 1,L1
         IF (DCPABS(HR(N),HI(N)) .LE. 10.D0*ETA*DCPABS(PR(N),PI(N)))
     *      GO TO 30
         CALL CDIVID(-PR(NN),-PI(NN),HR(N),HI(N),TR,TI)
         DO 20 I = 1,NM1
            J = NN - I
            T1 = HR(J - 1)
            T2 = HI(J - 1)
            HR(J) = TR*T1 - TI*T2 + PR(J)
            HI(J) = TR*T2 + TI*T1 + PI(J)
   20    CONTINUE
         HR(1) = PR(1)
         HI(1) = PI(1)
         GO TO 50
C
C     IF THE CONSTANT TERM IS ESSENTIALLY ZERO, SHIFT H COEFFICIENTS.
C
   30    DO 40 I = 1,NM1
            J = NN - I
            HR(J) = HR(J - 1)
            HI(J) = HI(J - 1)
   40    CONTINUE
         HR(1) = 0.D0
         HI(1) = 0.D0
   50 CONTINUE
      RETURN
      END
      SUBROUTINE FXSHFT(L2,ZR,ZI,CONV,NN,PR,PI,HR,HI,QPR,QPI,
     *                  QHR,QHI,SHR,SHI,SR,SI,TR,TI,PVR,PVI,
     *                  ARE,MRE,ETA,INFIN)
C
C     COMPUTES L2 FIXED-SHIFT H POLYNOMIALS AND TESTS FOR CONVERGENCE.
C     INITIATES A VARIABLE-SHIFT ITERATION AND RETURNS WITH THE
C     APPROXIMATE ZERO IF SUCCESSFUL.
C
C     L2 - LIMIT OF FIXED-SHIFT STEPS
C     ZR,ZI - APPROXIMATE ZERO IF CONV IS .TRUE.
C     CONV - LOGICAL VARIABLE INDICATING CONVERGENCE OF STAGE 3
C            ITERATION
C
      DOUBLE PRECISION SR,SI,TR,TI,PVR,PVI,ARE,MRE,ETA,INFIN,
     *             PR(NN),PI(NN),QPR(NN),QPI(NN),HR(NN),HI(NN),
     *             QHR(NN),QHI(NN),SHR(NN),SHI(NN)
      DOUBLE PRECISION ZR,ZI,OTR,OTI,SVSR,SVSI,DCPABS
      LOGICAL CONV,TEST,PASD,BOOL
C
         N = NN - 1
C
C     EVALUATE P AT S
C
         CALL POLYEV(NN,SR,SI,PR,PI,QPR,QPI,PVR,PVI)
         TEST = .TRUE.
         PASD = .FALSE.
C
C     CALCULATE T = -P(S)/H(S)
C
         CALL CALCT(BOOL,N,SR,SI,TR,TI,PVR,PVI,ARE,HR,HI,QHR,QHI)
C
C     MAIN LOOP FOR ONE SECOND STAGE STEP.
C
         DO 50 J = 1,L2
            OTR = TR
            OTI = TI
C
C     COMPUTE NEXT H POLYNOMIAL AND NEW T.
C
            CALL NEXTH(BOOL,N,TR,TI,HR,HI,QPR,QPI,QHR,QHI)
            CALL CALCT(BOOL,N,SR,SI,TR,TI,PVR,PVI,ARE,HR,HI,QHR,QHI)
            ZR = SR + TR
            ZI = SI + TI
C
C     TEST FOR CONVERGENCE UNLESS STAGE 3 HAS FAILED ONCE OR THIS
C     IS THE LAST H POLYNOMIAL.
C
            IF (BOOL .OR. (.NOT. TEST) .OR. J .EQ. L2) GO TO 50
            IF (DCPABS(TR - OTR,TI - OTI) .GE. 0.5D0*DCPABS(ZR,ZI))
     *         GO TO 40
            IF (.NOT. PASD) GO TO 30
C
C     THE WEAK CONVERGENCE TEST HAS BEEN PASSED TWICE. START THE
C     THIRD SHIFT ITERATION AFTER SAVING THE CURRENT H POLYNOMIAL
C     AND SHIFT.
C
               DO 10 I = 1,N
                  SHR(I) = HR(I)
                  SHI(I) = HI(I)
   10          CONTINUE
               SVSR = SR
               SVSI = SI
               CALL VRSHFT(10,ZR,ZI,CONV,NN,PR,PI,HR,HI,QPR,QPI,QHR,
     *                     QHI,SR,SI,TR,TI,PVR,PVI,ARE,MRE,ETA,INFIN)
               IF (CONV) RETURN
C
C     THE ITERATION FAILED TO CONVERGE. TURN OFF TESTING AND RESTORE
C     H,S,PV AND T.
C
               TEST = .FALSE.
               DO 20 I = 1,N
                  HR(I) = SHR(I)
                  HI(I) = SHI(I)
   20          CONTINUE
               SR = SVSR
               SI = SVSI
               CALL POLYEV(NN,SR,SI,PR,PI,QPR,QPI,PVR,PVI)
               CALL CALCT(BOOL,N,SR,SI,TR,TI,PVR,PVI,ARE,HR,HI,QHR,QHI)
               GO TO 50
C
   30       PASD = .TRUE.
            GO TO 50
C
   40       PASD = .FALSE.
   50    CONTINUE
C
C     ATTEMPT AN ITERATION WITH FINAL H POLYNOMIAL FROM SECOND STAGE.
C
      CALL VRSHFT(10,ZR,ZI,CONV,NN,PR,PI,HR,HI,QPR,QPI,QHR,QHI,
     *                  SR,SI,TR,TI,PVR,PVI,ARE,MRE,ETA,INFIN)
      RETURN
      END
      SUBROUTINE VRSHFT(L3,ZR,ZI,CONV,NN,PR,PI,HR,HI,QPR,QPI,QHR,QHI,
     *                  SR,SI,TR,TI,PVR,PVI,ARE,MRE,ETA,INFIN)
C
C     CARRIES OUT THE THIRD STAGE ITERATION.
C
C     L3 - LIMIT OF STEPS IN STAGE 3.
C     ZR,ZI - ON ENTRY CONTAIN THE INITIAL ITERATE. IF THE
C             ITERATION CONVERGES ZR,ZI CONTAIN THE FINAL
C             ITERATE ON EXIT.
C     CONV  - THE VALUE IS .TRUE. IF THE ITERATION CONVERGES.
C
      DOUBLE PRECISION SR,SI,TR,TI,PVR,PVI,ARE,MRE,ETA,INFIN,
     *             PR(NN),PI(NN),QPR(NN),QPI(NN),HR(NN),HI(NN),
     *             QHR(NN),QHI(NN)
      DOUBLE PRECISION ZR,ZI,MP,MS,OMP,RELSTP,R1,R2,TP,ERREV,DCPABS
      LOGICAL CONV,B,BOOL
C
      CONV = .FALSE.
      B = .FALSE.
      SR = ZR
      SI = ZI
      N = NN - 1
C
C     MAIN LOOP FOR STAGE 3.
C
      DO 60 I = 1,L3
C
C     EVALUATE P AT S AND TEST FOR CONVERGENCE.
C
         CALL POLYEV(NN,SR,SI,PR,PI,QPR,QPI,PVR,PVI)
         MP = DCPABS(PVR,PVI)
         MS = DCPABS(SR,SI)
         IF (MP .GT. 20.D0*ERREV(NN,QPR,QPI,MS,MP,ARE,MRE))
     *      GO TO 10
C
C     POLYNOMIAL VALUE IS SMALLER THAN A BOUND ON THE ERROR
C     IN EVALUATING P. TERMINATE THE ITERATION.
C
            CONV = .TRUE.
            ZR = SR
            ZI = SI
            RETURN
C
   10    IF (I .EQ. 1) GO TO 40
         IF (B .OR. MP .LT. OMP .OR. RELSTP .GE. 0.05D0)
     *      GO TO 30
C
C     ITERATION HAS STALLED. PROBABLY A CLUSTER OF ZEROS. DO 5 FIXED
C     SHIFT STEPS INTO THE CLUSTER TO FORCE ONE ZERO TO DOMINATE.
C
         TP = RELSTP
         B = .TRUE.
         IF (RELSTP .LT. ETA) TP = ETA
         R1 = DSQRT(TP)
         R2 = SR*(1.D0 + R1) - SI*R1
         SI = SR*R1 + SI*(1.D0 + R1)
         SR = R2
         CALL POLYEV(NN,SR,SI,PR,PI,QPR,QPI,PVR,PVI)
         DO 20 J = 1,5
            CALL CALCT(BOOL,N,SR,SI,TR,TI,PVR,PVI,ARE,HR,HI,QHR,QHI)
            CALL NEXTH(BOOL,N,TR,TI,HR,HI,QPR,QPI,QHR,QHI)
   20    CONTINUE
         OMP = INFIN
         GO TO 50
C
C     EXIT IF THE POLYNOMIAL VALUE INCREASES SIGNIFICANTLY.
C
   30    IF (0.1D0*MP .GT. OMP) RETURN
C
C     CALCULATE THE NEXT ITERATE.
C
   40    OMP = MP
C
   50    CALL CALCT(BOOL,N,SR,SI,TR,TI,PVR,PVI,ARE,HR,HI,QHR,QHI)
         CALL NEXTH(BOOL,N,TR,TI,HR,HI,QPR,QPI,QHR,QHI)
         CALL CALCT(BOOL,N,SR,SI,TR,TI,PVR,PVI,ARE,HR,HI,QHR,QHI)
         IF (BOOL) GO TO 60
         RELSTP = DCPABS(TR,TI)/DCPABS(SR,SI)
         SR = SR + TR
         SI = SI + TI
   60 CONTINUE
      RETURN
      END
      SUBROUTINE CALCT(BOOL,N,SR,SI,TR,TI,PVR,PVI,ARE,HR,HI,QHR,QHI)
C
C     THIS SUBROUTINE COMPUTES T = -P(S)/H(S)
C
C     BOOL - LOGICAL VARIABLE, WHICH IS SET TO .TRUE. IF H(S) IS
C            ESSENTIALLY ZERO.
C
      LOGICAL BOOL
      DOUBLE PRECISION SR,SI,TR,TI,PVR,PVI,ARE,HR(N),HI(N),
     *                 QHR(N),QHI(N)
      DOUBLE PRECISION HVR,HVI,DCPABS
C
C     EVALUATE H(S)
C
      CALL POLYEV (N,SR,SI,HR,HI,QHR,QHI,HVR,HVI)
      BOOL = DCPABS(HVR,HVI) .LE. 10.D0*ARE*DCPABS(HR(N),HI(N))
      IF (BOOL) GO TO 10
         CALL CDIVID(-PVR,-PVI,HVR,HVI,TR,TI)
         RETURN
   10 TR = 0.D0
      TI = 0.D0
      RETURN
      END
      SUBROUTINE NEXTH(BOOL,N,TR,TI,HR,HI,QPR,QPI,QHR,QHI)
C
C     CALCULATES THE NEXT SHIFTED H POLYNOMIAL.
C
C     BOOL - LOGICAL VARIABLE. IF .TRUE. H(S) IS ESSENTIALLY ZERO.
C
      LOGICAL BOOL
      DOUBLE PRECISION TR,TI,HR(N),HI(N),QPR(N),QPI(N),QHR(N),QHI(N)
      DOUBLE PRECISION T1,T2
C
      IF (BOOL) GO TO 20
         DO 10 J = 2,N
            T1 = QHR(J - 1)
            T2 = QHI(J - 1)
            HR(J) = TR*T1 - TI*T2 + QPR(J)
            HI(J) = TR*T2 + TI*T1 + QPI(J)
   10    CONTINUE
         HR(1) = QPR(1)
         HI(1) = QPI(1)
         RETURN
C
C     IF H(S) IS ZERO THEN REPLACE H WITH QH.
C
   20 DO 30 J = 2,N
         HR(J) = QHR(J - 1)
         HI(J) = QHI(J - 1)
   30 CONTINUE
      HR(1) = 0.D0
      HI(1) = 0.D0
      RETURN
      END
      SUBROUTINE POLYEV(N,SR,SI,PR,PI,QR,QI,PVR,PVI)
C
C     EVALUATES A POLYNOMIAL P AT S BY THE HORNER RECURRENCE ALGO.,
C     PLACING THE PARTIAL SUMS IN Q AND THE COMPUTED VALUE IN PV.
C
      DOUBLE PRECISION PR(N),PI(N),QR(N),QI(N),SR,SI,PVR,PVI,T
C
      QR(1) = PR(1)
      QI(1) = PI(1)
      PVR = QR(1)
      PVI = QI(1)
      DO 10 I = 2,N
         T = PVR*SR - PVI*SI + PR(I)
         PVI = PVR*SI + PVI*SR + PI(I)
         PVR = T
         QR(I) = PVR
         QI(I) = PVI
   10 CONTINUE
      RETURN
      END
      DOUBLE PRECISION FUNCTION ERREV(NN,QR,QI,MS,MP,ARE,MRE)
C
C     BOUNDS THE ERROR IN EVALUATING THE POLYNOMIAL BY THE HORNER
C     RECURRENCE ALGORITHM.
C
C     QR,QI   - THE PARTIAL SUMS
C     MS      - MODULUS OF THE POINT
C     MP      - MODULUS OF THE POLYNOMIAL VALUE
C     ARE,MRE - ERROR BOUNDS ON COMPLEX ADDITION AND MULTIPLICATION
C
      DOUBLE PRECISION QR(NN),QI(NN),MS,MP,ARE,MRE,E,DCPABS
C
      E = DCPABS(QR(1),QI(1))*MRE/(ARE + MRE)
      DO 10 I = 1,NN
         E = E*MS + DCPABS(QR(I),QI(I))
   10 CONTINUE
      ERREV = E*(ARE + MRE) - MP*MRE
      RETURN
      END
      SUBROUTINE RBND (N, C, W, ABSERR, RELERR, KLUST, KER)
C-----------------------------------------------------------------------
C
C     ABSTRACT
C
C         THIS ROUTINE COMPUTES ERROR BOUNDS AND CLUSTER COUNTS
C         FOR APPROXIMATE ZEROS OF A POLYNOMIAL WITH REAL COEFFICIENTS.
C         THE ZEROS MAY HAVE BEEN COMPUTED BY ANY APPROPRIATE ROUTINE.
C         THE METHOD USED IS BASED ON THE FACT THAT THE VALUE OF A
C         POLYNOMIAL AT ANY POINT IS EQUAL TO THE LEADING COEFFICIENT
C         TIMES THE PRODUCT OF THE DISTANCES FROM THAT POINT TO EACH
C         OF THE ZEROS.  GIVEN THE VALUE OF THE POLYNOMIAL AT AN
C         APPROXIMATE ZERO, RBND COMPUTES FOR EACH APPROXIMATE ZERO
C         THE RADIUS OF A CIRCLE ABOUT THAT APPROXIMATE ZERO WHICH
C         CONTAINS A TRUE ZERO OF THE POLYNOMIAL.  USING THE KNOWN
C         DISTRIBUTION OF APPROXIMATE ZEROS, AN ITERATIVE PROCEDURE
C         IS USED TO SHRINK THE RADII OF THE CIRCLES.
C
C     DESCRIPTION OF ARGUMENTS
C
C         INPUT---
C
C         N      - DEGREE OF THE POLYNOMIAL (NUMBER OF ZEROS).
C         C      - REAL ARRAY OF N+1 COEFFICIENTS OF THE POLYNOMIAL
C                  C(1) + C(2)*Z + ... + C(N+1)*Z**N
C         W      - COMPLEX ARRAY OF N APPROXIMATE ZEROS.
C
C         OUTPUT--
C
C         ABSERR - REAL ARRAY OF N ABSOLUTE ERROR BOUNDS.  ABSERR(I) IS
C                  THE ABSOLUTE ERROR BOUND IN THE ZERO (WR(I),WI(I)).
C         RELERR - REAL ARRAY OF N RELATIVE ERROR BOUNDS.  RELERR(I) IS
C                  THE RELATIVE ERROR BOUND IN THE ZERO (WR(I),WI(I)).
C         KLUST  - INTEGER ARRAY OF CLUSTER COUNTS FOR ZEROS.  THE TRUE
C                  ZERO CORRESPONDING TO I-TH APPROXIMATE ZERO LIES IN
C                  A CIRCLE OF RADIUS ABSERR(I). KLUST(I) IS THE NUMBER
C                  OF CIRCLES INCLUDING THE I-TH CIRCLE WHICH OVERLAP
C                  THE I-TH CIRCLE.  THE CLUSTER COUNT OFTEN INDICATES
C                  THE MULTIPLICITY OF A ZERO.
C         KER    - AN ERROR FLAG
C                --NORMAL CODE
C                  0  MEANS THE BOUNDS AND COUNTS WERE COMPUTED.
C                --ABNORMAL CODES
C                  1  N (DEGREE) MUST BE .GE. 1
C                  2  LEADING COEFFICIENT IS ZERO
C
C-------------------
C     WRITTEN BY CARL B. BAILEY AND MODIFIED BY WILLIAM R. GAVIN
C        SANDIA LABORATORIES
C        ALBUQUERQUE, NEW MEXICO
C        JANUARY 1976
C     MODIFIED BY A.H. MORRIS (NSWC)
C-----------------------------------------------------------------------
      COMPLEX W(N), Z
      INTEGER KLUST(N)
      REAL C(*), ABSERR(N), RELERR(N)
      DOUBLE PRECISION XR, XI, VR, VI, VT
      LOGICAL SHRUNK
C-----------------------------------------------------------------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
                      EPS = SPMPAR(1)
C
C-----------------------------------------------------------------------
      IF (N .LT. 1) GO TO 200
      NP1 = N + 1
      POWER = 1.0/FLOAT(N)
      P = ABS(C(NP1))
      IF (P .EQ. 0.0) GO TO 210
      RAT = 4.0*EPS*ABS(C(1))/P
C
      DO 20 L = 1,N
         XR = REAL(W(L))
         XI = AIMAG(W(L))
         VR = C(NP1)
         VI = 0.0D0
         DO 10 J = 1,N
            M = NP1 - J
            VT = XR*VR - XI*VI + DBLE(C(M))
            VI = XR*VI + XI*VR
            VR = VT
   10    CONTINUE
         B = AMAX1(RAT,CPABS(SNGL(VR),SNGL(VI))/P)
C
C        SAVE PRODUCT OF DISTANCES TEMPORARILY
C
         RELERR(L) = B
         ABSERR(L) = B ** POWER
   20 CONTINUE
C
   30 SHRUNK = .FALSE.
      DO 50 J = 1,N
         IF (ABSERR(J) .EQ. 0.0) GO TO 50
         P = 1.0
         M = N
         DO 40 K = 1,N
            IF (K .EQ. J) GO TO 40
            Z = W(J) - W(K)
            DIST = CPABS(REAL(Z),AIMAG(Z))
            CERT = DIST - ABSERR(K)
            IF (CERT .LT. ABSERR(J)) GO TO 40
               P = P*CERT
               M = M - 1
   40    CONTINUE
         OLDERR = ABSERR(J)
         ABSERR(J) = RELERR(J)/P
         IF (M .GT. 1) ABSERR(J) = ABSERR(J)**(1.0/FLOAT(M))
         IF (ABSERR(J) .LT. OLDERR*0.99) SHRUNK = .TRUE.
   50 CONTINUE
      IF (SHRUNK) GO TO 30
C
      DO 80 J = 1,N
         KLUST(J) = 1
         WRAD = ABSERR(J)
         WNRM = CPABS(REAL(W(J)),AIMAG(W(J)))
         IF (WRAD .NE. 0.0) GO TO 60
            R = 0.0
            GO TO 80
   60    IF (WNRM .NE. 0.0) GO TO 70
            R = -1.0
            GO TO 80
   70    R = WRAD/WNRM
   80    RELERR(J) = R
C
      NM1 = N - 1
      DO 100 J = 1,NM1
         JP1 = J + 1
         DO 90 K = JP1,N
            Z = W(J) - W(K)
            DIST = CPABS(REAL(Z),AIMAG(Z))
            IF (DIST .GT. (ABSERR(J) + ABSERR(K))) GO TO 90
               KLUST(J) = KLUST(J) + 1
               KLUST(K) = KLUST(K) + 1
   90    CONTINUE
  100 CONTINUE
      KER = 0
      RETURN
C
C             ERROR RETURN
C
  200 KER = 1
      RETURN
  210 KER = 2
      RETURN
      END
      SUBROUTINE CBND (N, C, W, ABSERR, RELERR, KLUST, KER)
C-----------------------------------------------------------------------
C
C     ABSTRACT
C
C         THIS ROUTINE COMPUTES ERROR BOUNDS AND CLUSTER COUNTS FOR
C         APPROXIMATE ZEROS OF A POLYNOMIAL WITH COMPLEX COEFFICIENTS.
C         THE ZEROS MAY HAVE BEEN COMPUTED BY ANY APPROPRIATE ROUTINE.
C         THE METHOD USED IS BASED ON THE FACT THAT THE VALUE OF A
C         POLYNOMIAL AT ANY POINT IS EQUAL TO THE LEADING COEFFICIENT
C         TIMES THE PRODUCT OF THE DISTANCES FROM THAT POINT TO EACH
C         OF THE ZEROS.  GIVEN THE VALUE OF THE POLYNOMIAL AT AN
C         APPROXIMATE ZERO, CBND COMPUTES FOR EACH APPROXIMATE ZERO
C         THE RADIUS OF A CIRCLE ABOUT THAT APPROXIMATE ZERO WHICH
C         CONTAINS A TRUE ZERO OF THE POLYNOMIAL.  USING THE KNOWN
C         DISTRIBUTION OF APPROXIMATE ZEROS, AN ITERATIVE PROCEDURE
C         IS USED TO SHRINK THE RADII OF THE CIRCLES.
C
C     DESCRIPTION OF ARGUMENTS
C
C         INPUT---
C
C         N      - DEGREE OF THE POLYNOMIAL (NUMBER OF ZEROS).
C         C      - COMPLEX ARRAY OF N+1 COEFFICIENTS OF THE POLYNOMIAL
C                  C(1) + C(2)*Z + ... + C(N+1)*Z**N
C         W      - COMPLEX ARRAY OF N APPROXIMATE ZEROS.
C
C         OUTPUT--
C
C         ABSERR - REAL ARRAY OF ABSOLUTE ERROR BOUNDS.  ABSERR(I) IS
C                  THE ABSOLUTE ERROR BOUND IN THE ZERO (WR(I),WI(I)).
C         RELERR - REAL ARRAY OF RELATIVE ERROR BOUNDS.  RELERR(I) IS
C                  THE RELATIVE ERROR BOUND IN THE ZERO (WR(I),WI(I)).
C         KLUST  - INTEGER ARRAY OF CLUSTER COUNTS FOR ZEROS.  THE TRUE
C                  ZERO CORRESPONDING TO I-TH APPROXIMATE ZERO LIES IN
C                  A CIRCLE OF RADIUS ABSERR(I).  KLUST(I) IS THE NUMBER
C                  OF CIRCLES INCLUDING THE I-TH CIRCLE WHICH OVERLAP
C                  THE I-TH CIRCLE.  THE CLUSTER COUNT OFTEN INDICATES
C                  THE MULTIPLICITY OF A ZERO.
C         KER    - AN ERROR CODE
C                --NORMAL CODES
C                  0  MEANS THE BOUNDS AND COUNTS WERE COMPUTED.
C                --ABNORMAL CODES
C                  1  N (DEGREE) MUST BE .GE. 1
C                  2  LEADING COEFFICIENT IS ZERO
C
C-------------------
C     WRITTEN BY CARL B. BAILEY AND MODIFIED BY WILLIAM R. GAVIN
C        SANDIA LABORATORIES
C        ALBUQUERQUE, NEW MEXICO
C        JANUARY 1976
C     MODIFIED BY A.H. MORRIS (NSWC)
C-----------------------------------------------------------------------
      COMPLEX C(*), W(N), Z
      INTEGER KLUST(N)
      REAL ABSERR(N), RELERR(N)
      DOUBLE PRECISION XR, XI, VR, VI, VT
      LOGICAL SHRUNK
C-----------------------------------------------------------------------
C
C     ****** EPS IS A MACHINE DEPENDENT CONSTANT. EPS IS THE
C            SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
                      EPS = SPMPAR(1)
C
C-----------------------------------------------------------------------
      IF (N .LT. 1) GO TO 200
      NP1 = N + 1
      POWER = 1.0/FLOAT(N)
      P = CPABS(REAL(C(NP1)),AIMAG(C(NP1)))
      IF (P .EQ. 0.0) GO TO 210
      RAT = 4.0*EPS*CPABS(REAL(C(1)),AIMAG(C(1)))/P
C
      DO 20 L = 1,N
         XR = REAL(W(L))
         XI = AIMAG(W(L))
         VR = REAL(C(NP1))
         VI = AIMAG(C(NP1))
         DO 10 J = 1,N
            M = NP1 - J
            VT = XR*VR - XI*VI + DBLE(REAL(C(M)))
            VI = XR*VI + XI*VR + DBLE(AIMAG(C(M)))
            VR = VT
   10    CONTINUE
         B = AMAX1(RAT,CPABS(SNGL(VR),SNGL(VI))/P)
C
C        SAVE PRODUCT OF DISTANCES TEMPORARILY
C
         RELERR(L) = B
         ABSERR(L) = B ** POWER
   20 CONTINUE
C
   30 SHRUNK = .FALSE.
      DO 50 J = 1,N
         IF (ABSERR(J) .EQ. 0.0) GO TO 50
         P = 1.0
         M = N
         DO 40 K = 1,N
            IF (K .EQ. J) GO TO 40
            Z = W(J) - W(K)
            DIST = CPABS(REAL(Z),AIMAG(Z))
            CERT = DIST - ABSERR(K)
            IF (CERT .LT. ABSERR(J)) GO TO 40
               P = P*CERT
               M = M - 1
   40    CONTINUE
         OLDERR = ABSERR(J)
         ABSERR(J) = RELERR(J)/P
         IF (M .GT. 1) ABSERR(J) = ABSERR(J)**(1.0/FLOAT(M))
         IF (ABSERR(J) .LT. OLDERR*0.99) SHRUNK = .TRUE.
   50 CONTINUE
      IF (SHRUNK) GO TO 30
C
      DO 80 J = 1,N
         KLUST(J) = 1
         WRAD = ABSERR(J)
         WNRM = CPABS(REAL(W(J)),AIMAG(W(J)))
         IF (WRAD .NE. 0.0) GO TO 60
            R = 0.0
            GO TO 80
   60    IF (WNRM .NE. 0.0) GO TO 70
            R = -1.0
            GO TO 80
   70    R = WRAD/WNRM
   80    RELERR(J) = R
C
      NM1 = N - 1
      DO 100 J = 1,NM1
         JP1 = J + 1
         DO 90 K = JP1,N
            Z = W(J) - W(K)
            DIST = CPABS(REAL(Z),AIMAG(Z))
            IF (DIST .GT. (ABSERR(J) + ABSERR(K))) GO TO 90
               KLUST(J) = KLUST(J) + 1
               KLUST(K) = KLUST(K) + 1
   90    CONTINUE
  100 CONTINUE
      KER = 0
      RETURN
C
C             ERROR RETURN
C
  200 KER = 1
      RETURN
  210 KER = 2
      RETURN
      END
      SUBROUTINE  SCOPY(N,SX,INCX,SY,INCY)
C
C     COPIES A VECTOR, X, TO A VECTOR, Y.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO 1.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      REAL SX(*),SY(*)
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        SY(IY) = SX(IX)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C        CODE FOR BOTH INCREMENTS EQUAL TO 1
C
C
C        CLEAN-UP LOOP
C
   20 M = MOD(N,7)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        SY(I) = SX(I)
   30 CONTINUE
      IF( N .LT. 7 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,7
        SY(I) = SX(I)
        SY(I + 1) = SX(I + 1)
        SY(I + 2) = SX(I + 2)
        SY(I + 3) = SX(I + 3)
        SY(I + 4) = SX(I + 4)
        SY(I + 5) = SX(I + 5)
        SY(I + 6) = SX(I + 6)
   50 CONTINUE
      RETURN
      END
      SUBROUTINE  DCOPY(N,DX,INCX,DY,INCY)
C
C     COPIES A VECTOR, X, TO A VECTOR, Y.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      DOUBLE PRECISION DX(*),DY(*)
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DY(IY) = DX(IX)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C        CODE FOR BOTH INCREMENTS EQUAL TO 1
C
C
C        CLEAN-UP LOOP
C
   20 M = MOD(N,7)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        DY(I) = DX(I)
   30 CONTINUE
      IF( N .LT. 7 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,7
        DY(I) = DX(I)
        DY(I + 1) = DX(I + 1)
        DY(I + 2) = DX(I + 2)
        DY(I + 3) = DX(I + 3)
        DY(I + 4) = DX(I + 4)
        DY(I + 5) = DX(I + 5)
        DY(I + 6) = DX(I + 6)
   50 CONTINUE
      RETURN
      END
      SUBROUTINE  CCOPY(N,CX,INCX,CY,INCY)
C
C     COPIES A VECTOR, X, TO A VECTOR, Y.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      COMPLEX CX(*),CY(*)
      INTEGER I,INCX,INCY,IX,IY,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        CY(IY) = CX(IX)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C        CODE FOR BOTH INCREMENTS EQUAL TO 1
C
   20 DO 30 I = 1,N
        CY(I) = CX(I)
   30 CONTINUE
      RETURN
      END
      SUBROUTINE ISWAP (N,IX,INCX,IY,INCY)
C
C                EXTENDED B L A S  SUBPROGRAM
C
C    DESCRIPTION OF PARAMETERS
C
C     --INPUT--
C        N  NUMBER OF ELEMENTS IN INPUT VECTOR(S)
C       IX  INTEGER VECTOR WITH N ELEMENTS
C     INCX  STORAGE SPACING BETWEEN ELEMENTS OF IX
C       IY  INTEGER VECTOR WITH N ELEMENTS
C     INCY  STORAGE SPACING BETWEEN ELEMENTS OF IY
C
C     --OUTPUT--
C       IX  INPUT VECTOR IY (UNCHANGED IF N .LE. 0)
C       IY  INPUT VECTOR IX (UNCHANGED IF N .LE. 0)
C
C     INTERCHANGE INTEGER IX AND INTEGER IY.
C     FOR I = 0 TO N-1, INTERCHANGE  IX(LX+I*INCX) AND IY(LY+I*INCY),
C     WHERE LX = 1 IF INCX .GE. 0, ELSE LX = (-INCX)*N, AND LY IS
C     DEFINED IN A SIMILAR WAY USING INCY.
C
C***AUTHOR  VANDEVENDER, W. (SNLA), 1985
C
      INTEGER IX(*),IY(*),ITEMP1,ITEMP2,ITEMP3
C
      IF (N .LE. 0) RETURN
      IF (INCX .NE. INCY) GO TO 5
      IF (INCX-1) 5,20,60
    5 CONTINUE
C
C       CODE FOR UNEQUAL OR NONPOSITIVE INCREMENTS.
C
      IIX = 1
      IIY = 1
      IF (INCX .LT. 0) IIX = (1-N)*INCX + 1
      IF (INCY .LT. 0) IIY = (1-N)*INCY + 1
      DO 10 I = 1,N
         ITEMP1 = IX(IIX)
         IX(IIX) = IY(IIY)
         IY(IIY) = ITEMP1
         IIX = IIX + INCX
         IIY = IIY + INCY
   10 CONTINUE
      RETURN
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
C
C
C       CLEAN-UP LOOP SO REMAINING VECTOR LENGTH IS A MULTIPLE OF 3.
C
   20 M = MOD(N,3)
      IF (M .EQ. 0) GO TO 40
      DO 30 I = 1,M
         ITEMP1 = IX(I)
         IX(I) = IY(I)
         IY(I) = ITEMP1
   30 CONTINUE
      IF (N .LT. 3) RETURN
C
   40 MP1 = M + 1
      DO 50 I = MP1,N,3
         ITEMP1 = IX(I)
         ITEMP2 = IX(I+1)
         ITEMP3 = IX(I+2)
         IX(I) = IY(I)
         IX(I+1) = IY(I+1)
         IX(I+2) = IY(I+2)
         IY(I) = ITEMP1
         IY(I+1) = ITEMP2
         IY(I+2) = ITEMP3
   50 CONTINUE
      RETURN
C
C     CODE FOR EQUAL, POSITIVE, NONUNIT INCREMENTS.
C
   60 NS = N*INCX
      DO 70 I = 1,NS,INCX
         ITEMP1 = IX(I)
         IX(I) = IY(I)
         IY(I) = ITEMP1
   70 CONTINUE
      RETURN
      END
      SUBROUTINE  SSWAP (N,SX,INCX,SY,INCY)
C
C     INTERCHANGES TWO VECTORS.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO 1.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      REAL SX(*),SY(*),STEMP
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        STEMP = SX(IX)
        SX(IX) = SY(IY)
        SY(IY) = STEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
C
C
C       CLEAN-UP LOOP
C
   20 M = MOD(N,3)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        STEMP = SX(I)
        SX(I) = SY(I)
        SY(I) = STEMP
   30 CONTINUE
      IF( N .LT. 3 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,3
        STEMP = SX(I)
        SX(I) = SY(I)
        SY(I) = STEMP
        STEMP = SX(I + 1)
        SX(I + 1) = SY(I + 1)
        SY(I + 1) = STEMP
        STEMP = SX(I + 2)
        SX(I + 2) = SY(I + 2)
        SY(I + 2) = STEMP
   50 CONTINUE
      RETURN
      END
      SUBROUTINE  DSWAP (N,DX,INCX,DY,INCY)
C
C     INTERCHANGES TWO VECTORS.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      DOUBLE PRECISION DX(*),DY(*),DTEMP
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DTEMP = DX(IX)
        DX(IX) = DY(IY)
        DY(IY) = DTEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
C
C
C       CLEAN-UP LOOP
C
   20 M = MOD(N,3)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        DTEMP = DX(I)
        DX(I) = DY(I)
        DY(I) = DTEMP
   30 CONTINUE
      IF( N .LT. 3 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,3
        DTEMP = DX(I)
        DX(I) = DY(I)
        DY(I) = DTEMP
        DTEMP = DX(I + 1)
        DX(I + 1) = DY(I + 1)
        DY(I + 1) = DTEMP
        DTEMP = DX(I + 2)
        DX(I + 2) = DY(I + 2)
        DY(I + 2) = DTEMP
   50 CONTINUE
      RETURN
      END
      SUBROUTINE  CSWAP (N,CX,INCX,CY,INCY)
C
C     INTERCHANGES TWO VECTORS.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      COMPLEX CX(*),CY(*),CTEMP
      INTEGER I,INCX,INCY,IX,IY,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        CTEMP = CX(IX)
        CX(IX) = CY(IY)
        CY(IY) = CTEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
   20 DO 30 I = 1,N
        CTEMP = CX(I)
        CX(I) = CY(I)
        CY(I) = CTEMP
   30 CONTINUE
      RETURN
      END
      SUBROUTINE  SROT (N,SX,INCX,SY,INCY,C,S)
C
C     APPLIES A PLANE ROTATION.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      REAL SX(*),SY(*),STEMP,C,S
      INTEGER I,INCX,INCY,IX,IY,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        STEMP = C*SX(IX) + S*SY(IY)
        SY(IY) = C*SY(IY) - S*SX(IX)
        SX(IX) = STEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
C
   20 DO 30 I = 1,N
        STEMP = C*SX(I) + S*SY(I)
        SY(I) = C*SY(I) - S*SX(I)
        SX(I) = STEMP
   30 CONTINUE
      RETURN
      END
      SUBROUTINE  DROT (N,DX,INCX,DY,INCY,C,S)
C
C     APPLIES A PLANE ROTATION.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      DOUBLE PRECISION DX(*),DY(*),DTEMP,C,S
      INTEGER I,INCX,INCY,IX,IY,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DTEMP = C*DX(IX) + S*DY(IY)
        DY(IY) = C*DY(IY) - S*DX(IX)
        DX(IX) = DTEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
C
   20 DO 30 I = 1,N
        DTEMP = C*DX(I) + S*DY(I)
        DY(I) = C*DY(I) - S*DX(I)
        DX(I) = DTEMP
   30 CONTINUE
      RETURN
      END
      SUBROUTINE  CSROT (N,CX,INCX,CY,INCY,C,S)
C
C     APPLIES A PLANE ROTATION, WHERE THE COS AND SIN (C AND S) ARE REAL
C     AND THE VECTORS CX AND CY ARE COMPLEX.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      COMPLEX CX(*),CY(*),CTEMP
      REAL C,S
      INTEGER I,INCX,INCY,IX,IY,N
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        CTEMP = C*CX(IX) + S*CY(IY)
        CY(IY) = C*CY(IY) - S*CX(IX)
        CX(IX) = CTEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
C
   20 DO 30 I = 1,N
        CTEMP = C*CX(I) + S*CY(I)
        CY(I) = C*CY(I) - S*CX(I)
        CX(I) = CTEMP
   30 CONTINUE
      RETURN
      END
      SUBROUTINE SROTMG (SD1,SD2,SX1,SY1,SPARAM)
C
C     CONSTRUCT THE MODIFIED GIVENS TRANSFORMATION MATRIX H WHICH ZEROS
C     THE SECOND COMPONENT OF THE 2-VECTOR  (SQRT(SD1)*SX1,SQRT(SD2)*
C     SY1)**T.
C     WITH SPARAM(1)=SFLAG, H HAS ONE OF THE FOLLOWING FORMS..
C
C     SFLAG=-1.E0     SFLAG=0.E0        SFLAG=1.E0     SFLAG=-2.E0
C
C       (SH11  SH12)    (1.E0  SH12)    (SH11  1.E0)    (1.E0  0.E0)
C     H=(          )    (          )    (          )    (          )
C       (SH21  SH22),   (SH21  1.E0),   (-1.E0 SH22),   (0.E0  1.E0).
C
C     LOCATIONS 2-4 OF SPARAM CONTAIN SH11,SH21,SH12, AND SH22
C     RESPECTIVELY. (VALUES OF 1.E0, -1.E0, OR 0.E0 IMPLIED BY THE
C     VALUE OF SPARAM(1) ARE NOT STORED IN SPARAM.)
C
C     IT IS ASSUMED THAT GAMSQ = GAM*GAM AND RGAMSQ = ONE/(GAM*GAM).
C     THE VALUES OF GAMSQ AND RGAMSQ SET IN THE DATA STATEMENT MAY BE
C     INEXACT.  THIS IS OK AS THEY ARE ONLY USED FOR TESTING THE SIZE
C     OF SD1 AND SD2.  ALL ACTUAL SCALING OF DATA IS DONE USING GAM.
C
      DIMENSION SPARAM(5)
C
      DATA ZERO,ONE,TWO /0.E0,1.E0,2.E0/
      DATA GAM,GAMSQ,RGAMSQ/4096.E0,1.67772E7,5.96046E-8/
C
      IF (SD1 .LT. ZERO) GO TO 60
      SP2 = SD2*SY1
      IF (SP2 .NE. ZERO) GO TO 20
          SFLAG = -TWO
          GO TO 260
C
C     REGULAR-CASE..
C
   20 SP1 = SD1*SX1
      SQ1 = SP1*SX1
      SQ2 = SP2*SY1
C
      IF (ABS(SQ1) .LE. ABS(SQ2)) GO TO 40
          SH21 = -SY1/SX1
          SH12 = SP2/SP1
C
          SU = ONE - SH12*SH21
          IF (SU .LE. ZERO) GO TO 60
C
               SFLAG = ZERO
               SH11 = ONE
               SH22 = ONE
               SD1 = SD1/SU
               SD2 = SD2/SU
               SX1 = SX1*SU
C         GO SCALE-CHECK..
               GO TO 100
C
   40 CONTINUE
          IF (SD2 .LT. ZERO) GO TO 60
               SFLAG = ONE
               SH11 = SP1/SP2
               SH21 = -ONE
               SH12 = ONE
               SH22 = SX1/SY1
C
               SU = ONE + SH11*SH22
               STEMP = SD2/SU
               SD2 = SD1/SU
               SD1 = STEMP
               SX1 = SY1*SU
C         GO SCALE-CHECK
               GO TO 100
C
C     PROCEDURE..ZERO-H-D-AND-SX1..
C
   60 CONTINUE
          SFLAG = -ONE
          SH11 = ZERO
          SH12 = ZERO
          SH21 = ZERO
          SH22 = ZERO
C
          SD1 = ZERO
          SD2 = ZERO
          SX1 = ZERO
          GO TO 250
C
C     PROCEDURE..SCALE-CHECK
C
  100 CONTINUE
  110     CONTINUE
          IF (SD1 .GT. RGAMSQ) GO TO 130
               IF (SD1 .EQ. ZERO) GO TO 160
               SFLAG = -ONE
               SD1 = SD1*(GAM*GAM)
               SX1 = SX1/GAM
               SH11 = SH11/GAM
               SH12 = SH12/GAM
          GO TO 110
C
  130 CONTINUE
  140     CONTINUE
          IF (SD1 .LT. GAMSQ) GO TO 160
               SFLAG = -ONE
               SD1 = SD1/(GAM*GAM)
               SX1 = SX1*GAM
               SH11 = SH11*GAM
               SH12 = SH12*GAM
          GO TO 140
C
  160 CONTINUE
  170     CONTINUE
          IF (ABS(SD2) .GT. RGAMSQ) GO TO 190
               IF (SD2 .EQ. ZERO) GO TO 220
               SFLAG = -ONE
               SD2 = SD2*(GAM*GAM)
               SH21 = SH21/GAM
               SH22 = SH22/GAM
          GO TO 170
C
  190 CONTINUE
  200     CONTINUE
          IF (ABS(SD2) .LT. GAMSQ) GO TO 220
               SFLAG = -ONE
               SD2 = SD2/(GAM*GAM)
               SH21 = SH21*GAM
               SH22 = SH22*GAM
          GO TO 200
C
  220 CONTINUE
          IF(SFLAG)250,230,240
  230     CONTINUE
               SPARAM(3)=SH21
               SPARAM(4)=SH12
               GO TO 260
  240     CONTINUE
               SPARAM(2)=SH11
               SPARAM(5)=SH22
               GO TO 260
  250     CONTINUE
               SPARAM(2)=SH11
               SPARAM(3)=SH21
               SPARAM(4)=SH12
               SPARAM(5)=SH22
  260 CONTINUE
          SPARAM(1)=SFLAG
          RETURN
      END
      SUBROUTINE SROTM (N,SX,INCX,SY,INCY,SPARAM)
C
C     APPLY THE MODIFIED GIVENS TRANSFORMATION, H, TO THE 2 BY N MATRIX
C
C     (SX**T), WHERE **T INDICATES TRANSPOSE. THE ELEMENTS OF SX ARE IN
C     (SY**T)
C
C     SX(LX+I*INCX), I = 0 TO N-1, WHERE LX = 1 IF INCX .GE. 0, ELSE
C     LX = (-INCX)*N, AND SIMILARLY FOR SY USING USING LY AND INCY.
C
C     WITH SPARAM(1)=SFLAG, H HAS ONE OF THE FOLLOWING FORMS..
C
C     SFLAG=-1.E0     SFLAG=0.E0        SFLAG=1.E0     SFLAG=-2.E0
C
C       (SH11  SH12)    (1.E0  SH12)    (SH11  1.E0)    (1.E0  0.E0)
C     H=(          )    (          )    (          )    (          )
C       (SH21  SH22),   (SH21  1.E0),   (-1.E0 SH22),   (0.E0  1.E0).
C
      DIMENSION SX(*), SY(*), SPARAM(5)
C
      DATA ZERO,TWO/0.E0,2.E0/
C
      SFLAG=SPARAM(1)
      IF(N .LE. 0 .OR.(SFLAG+TWO.EQ.ZERO)) GO TO 140
          IF(.NOT.(INCX.EQ.INCY.AND. INCX .GT.0)) GO TO 70
C
               NSTEPS=N*INCX
               IF(SFLAG) 50,10,30
   10          CONTINUE
               SH21=SPARAM(3)
               SH12=SPARAM(4)
                    DO 20 I=1,NSTEPS,INCX
                    W=SX(I)
                    Z=SY(I)
                    SX(I)=W+Z*SH12
                    SY(I)=W*SH21+Z
   20               CONTINUE
               GO TO 140
   30          CONTINUE
               SH11=SPARAM(2)
               SH22=SPARAM(5)
                    DO 40 I=1,NSTEPS,INCX
                    W=SX(I)
                    Z=SY(I)
                    SX(I)=W*SH11+Z
                    SY(I)=-W+SH22*Z
   40               CONTINUE
               GO TO 140
   50          CONTINUE
               SH11=SPARAM(2)
               SH21=SPARAM(3)
               SH12=SPARAM(4)
               SH22=SPARAM(5)
                    DO 60 I=1,NSTEPS,INCX
                    W=SX(I)
                    Z=SY(I)
                    SX(I)=W*SH11+Z*SH12
                    SY(I)=W*SH21+Z*SH22
   60               CONTINUE
               GO TO 140
   70     CONTINUE
          KX=1
          KY=1
          IF(INCX .LT. 0) KX=1+(1-N)*INCX
          IF(INCY .LT. 0) KY=1+(1-N)*INCY
C
          IF(SFLAG)120,80,100
   80     CONTINUE
          SH21=SPARAM(3)
          SH12=SPARAM(4)
               DO 90 I=1,N
               W=SX(KX)
               Z=SY(KY)
               SX(KX)=W+Z*SH12
               SY(KY)=W*SH21+Z
               KX=KX+INCX
               KY=KY+INCY
   90          CONTINUE
          GO TO 140
  100     CONTINUE
          SH11=SPARAM(2)
          SH22=SPARAM(5)
               DO 110 I=1,N
               W=SX(KX)
               Z=SY(KY)
               SX(KX)=W*SH11+Z
               SY(KY)=-W+SH22*Z
               KX=KX+INCX
               KY=KY+INCY
  110          CONTINUE
          GO TO 140
  120     CONTINUE
          SH11=SPARAM(2)
          SH21=SPARAM(3)
          SH12=SPARAM(4)
          SH22=SPARAM(5)
               DO 130 I=1,N
               W=SX(KX)
               Z=SY(KY)
               SX(KX)=W*SH11+Z*SH12
               SY(KY)=W*SH21+Z*SH22
               KX=KX+INCX
               KY=KY+INCY
  130          CONTINUE
  140     CONTINUE
          RETURN
          END
      SUBROUTINE DROTMG (DD1,DD2,DX1,DY1,DPARAM)
C
C     CONSTRUCT THE MODIFIED GIVENS TRANSFORMATION MATRIX H WHICH ZEROS
C     THE SECOND COMPONENT OF THE 2-VECTOR  (DSQRT(DD1)*DX1,DSQRT(DD2)*
C     DY1)**T.
C     WITH DPARAM(1)=DFLAG, H HAS ONE OF THE FOLLOWING FORMS..
C
C     DFLAG=-1.D0     DFLAG=0.D0        DFLAG=1.D0     DFLAG=-2.D0
C
C       (DH11  DH12)    (1.D0  DH12)    (DH11  1.D0)    (1.D0  0.D0)
C     H=(          )    (          )    (          )    (          )
C       (DH21  DH22),   (DH21  1.D0),   (-1.D0 DH22),   (0.D0  1.D0).
C
C     LOCATIONS 2-4 OF DPARAM CONTAIN DH11,DH21,DH12, AND DH22
C     RESPECTIVELY. (VALUES OF 1.D0, -1.D0, OR 0.D0 IMPLIED BY THE
C     VALUE OF DPARAM(1) ARE NOT STORED IN DPARAM.)
C
C     IT IS ASSUMED THAT GAMSQ = GAM*GAM AND RGAMSQ = ONE/(GAM*GAM).
C     THE VALUES OF GAMSQ AND RGAMSQ SET IN THE DATA STATEMENT MAY BE
C     INEXACT.  THIS IS OK AS THEY ARE ONLY USED FOR TESTING THE SIZE
C     OF DD1 AND DD2.  ALL ACTUAL SCALING OF DATA IS DONE USING GAM.
C
      DOUBLE PRECISION GAM,ONE,RGAMSQ,DD2,DH11,DH21,DPARAM,DP2,
     1 DQ2,DU,DY1,ZERO,GAMSQ,DD1,DFLAG,DH12,DH22,DP1,DQ1,
     2 DTEMP,DX1,TWO
      DIMENSION DPARAM(5)
C
      DATA ZERO,ONE,TWO /0.D0,1.D0,2.D0/
      DATA GAM,GAMSQ,RGAMSQ/4096.D0,16777216.D0,5.9604645D-8/
C
      IF (DD1 .LT. ZERO) GO TO 60
      DP2 = DD2*DY1
      IF (DP2 .NE. ZERO) GO TO 20
          DFLAG = -TWO
          GO TO 260
C
C     REGULAR-CASE..
C
   20 DP1 = DD1*DX1
      DQ1 = DP1*DX1
      DQ2 = DP2*DY1
C
      IF (DABS(DQ1) .LE. DABS(DQ2)) GO TO 40
          DH21 = -DY1/DX1
          DH12 = DP2/DP1
C
          DU = ONE - DH12*DH21
          IF (DU .LE. ZERO) GO TO 60
C
               DFLAG = ZERO
               DH11 = ONE
               DH22 = ONE
               DD1 = DD1/DU
               DD2 = DD2/DU
               DX1 = DX1*DU
C         GO SCALE-CHECK..
               GO TO 100
C
   40 CONTINUE
          IF (DD2 .LT. ZERO) GO TO 60
               DFLAG = ONE
               DH11 = DP1/DP2
               DH21 = -ONE
               DH12 = ONE
               DH22 = DX1/DY1
C
               DU = ONE + DH11*DH22
               DTEMP = DD2/DU
               DD2 = DD1/DU
               DD1 = DTEMP
               DX1 = DY1*DU
C         GO SCALE-CHECK
               GO TO 100
C
C     PROCEDURE..ZERO-H-D-AND-DX1..
C
   60 CONTINUE
          DFLAG = -ONE
          DH11 = ZERO
          DH12 = ZERO
          DH21 = ZERO
          DH22 = ZERO
C
          DD1 = ZERO
          DD2 = ZERO
          DX1 = ZERO
          GO TO 250
C
C     PROCEDURE..SCALE-CHECK
C
  100 CONTINUE
  110     CONTINUE
          IF (DD1 .GT. RGAMSQ) GO TO 130
               IF (DD1 .EQ. ZERO) GO TO 160
               DFLAG = -ONE
               DD1 = DD1*(GAM*GAM)
               DX1 = DX1/GAM
               DH11 = DH11/GAM
               DH12 = DH12/GAM
          GO TO 110
C
  130 CONTINUE
  140     CONTINUE
          IF (DD1 .LT. GAMSQ) GO TO 160
               DFLAG = -ONE
               DD1 = DD1/(GAM*GAM)
               DX1 = DX1*GAM
               DH11 = DH11*GAM
               DH12 = DH12*GAM
          GO TO 140
C
  160 CONTINUE
  170     CONTINUE
          IF (DABS(DD2) .GT. RGAMSQ) GO TO 190
               IF (DD2 .EQ. ZERO) GO TO 220
               DFLAG = -ONE
               DD2 = DD2*(GAM*GAM)
               DH21 = DH21/GAM
               DH22 = DH22/GAM
          GO TO 170
C
  190 CONTINUE
  200     CONTINUE
          IF (DABS(DD2) .LT. GAMSQ) GO TO 220
               DFLAG = -ONE
               DD2 = DD2/(GAM*GAM)
               DH21 = DH21*GAM
               DH22 = DH22*GAM
          GO TO 200
C
  220 CONTINUE
          IF(DFLAG)250,230,240
  230     CONTINUE
               DPARAM(3)=DH21
               DPARAM(4)=DH12
               GO TO 260
  240     CONTINUE
               DPARAM(2)=DH11
               DPARAM(5)=DH22
               GO TO 260
  250     CONTINUE
               DPARAM(2)=DH11
               DPARAM(3)=DH21
               DPARAM(4)=DH12
               DPARAM(5)=DH22
  260 CONTINUE
          DPARAM(1)=DFLAG
          RETURN
      END
      SUBROUTINE DROTM (N,DX,INCX,DY,INCY,DPARAM)
C
C     APPLY THE MODIFIED GIVENS TRANSFORMATION, H, TO THE 2 BY N MATRIX
C
C     (DX**T), WHERE **T INDICATES TRANSPOSE. THE ELEMENTS OF DX ARE IN
C     (DY**T)
C
C     DX(LX+I*INCX), I = 0 TO N-1, WHERE LX = 1 IF INCX .GE. 0, ELSE
C     LX = (-INCX)*N, AND SIMILARLY FOR SY USING LY AND INCY.
C
C     WITH DPARAM(1)=DFLAG, H HAS ONE OF THE FOLLOWING FORMS..
C
C     DFLAG=-1.D0     DFLAG=0.D0        DFLAG=1.D0     DFLAG=-2.D0
C
C       (DH11  DH12)    (1.D0  DH12)    (DH11  1.D0)    (1.D0  0.D0)
C     H=(          )    (          )    (          )    (          )
C       (DH21  DH22),   (DH21  1.D0),   (-1.D0 DH22),   (0.D0  1.D0).
C
      DOUBLE PRECISION DFLAG,DH12,DH22,DX,TWO,Z,DH11,DH21,
     *                 DPARAM,DY,W,ZERO
      DIMENSION DX(*), DY(*), DPARAM(5)
C
      DATA ZERO,TWO/0.D0,2.D0/
C
      DFLAG=DPARAM(1)
      IF(N .LE. 0 .OR.(DFLAG+TWO.EQ.ZERO)) GO TO 140
          IF(.NOT.(INCX.EQ.INCY.AND. INCX .GT.0)) GO TO 70
C
               NSTEPS=N*INCX
               IF(DFLAG) 50,10,30
   10          CONTINUE
               DH21=DPARAM(3)
               DH12=DPARAM(4)
                    DO 20 I=1,NSTEPS,INCX
                    W=DX(I)
                    Z=DY(I)
                    DX(I)=W+Z*DH12
                    DY(I)=W*DH21+Z
   20               CONTINUE
               GO TO 140
   30          CONTINUE
               DH11=DPARAM(2)
               DH22=DPARAM(5)
                    DO 40 I=1,NSTEPS,INCX
                    W=DX(I)
                    Z=DY(I)
                    DX(I)=W*DH11+Z
                    DY(I)=-W+DH22*Z
   40               CONTINUE
               GO TO 140
   50          CONTINUE
               DH11=DPARAM(2)
               DH21=DPARAM(3)
               DH12=DPARAM(4)
               DH22=DPARAM(5)
                    DO 60 I=1,NSTEPS,INCX
                    W=DX(I)
                    Z=DY(I)
                    DX(I)=W*DH11+Z*DH12
                    DY(I)=W*DH21+Z*DH22
   60               CONTINUE
               GO TO 140
   70     CONTINUE
          KX=1
          KY=1
          IF(INCX .LT. 0) KX=1+(1-N)*INCX
          IF(INCY .LT. 0) KY=1+(1-N)*INCY
C
          IF(DFLAG)120,80,100
   80     CONTINUE
          DH21=DPARAM(3)
          DH12=DPARAM(4)
               DO 90 I=1,N
               W=DX(KX)
               Z=DY(KY)
               DX(KX)=W+Z*DH12
               DY(KY)=W*DH21+Z
               KX=KX+INCX
               KY=KY+INCY
   90          CONTINUE
          GO TO 140
  100     CONTINUE
          DH11=DPARAM(2)
          DH22=DPARAM(5)
               DO 110 I=1,N
               W=DX(KX)
               Z=DY(KY)
               DX(KX)=W*DH11+Z
               DY(KY)=-W+DH22*Z
               KX=KX+INCX
               KY=KY+INCY
  110          CONTINUE
          GO TO 140
  120     CONTINUE
          DH11=DPARAM(2)
          DH21=DPARAM(3)
          DH12=DPARAM(4)
          DH22=DPARAM(5)
               DO 130 I=1,N
               W=DX(KX)
               Z=DY(KY)
               DX(KX)=W*DH11+Z*DH12
               DY(KY)=W*DH21+Z*DH22
               KX=KX+INCX
               KY=KY+INCY
  130          CONTINUE
  140     CONTINUE
          RETURN
          END
      REAL FUNCTION SDOT(N,SX,INCX,SY,INCY)
C
C     FORMS THE DOT PRODUCT OF TWO VECTORS.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      REAL SX(*),SY(*),STEMP
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N
C
      STEMP = 0.0E0
      SDOT = 0.0E0
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        STEMP = STEMP + SX(IX)*SY(IY)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      SDOT = STEMP
      RETURN
C
C        CODE FOR BOTH INCREMENTS EQUAL TO 1
C
C
C        CLEAN-UP LOOP
C
   20 M = MOD(N,5)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        STEMP = STEMP + SX(I)*SY(I)
   30 CONTINUE
      IF( N .LT. 5 ) GO TO 60
   40 MP1 = M + 1
      DO 50 I = MP1,N,5
        STEMP = STEMP + SX(I)*SY(I) + SX(I + 1)*SY(I + 1) +
     *   SX(I + 2)*SY(I + 2) + SX(I + 3)*SY(I + 3) + SX(I + 4)*SY(I + 4)
   50 CONTINUE
   60 SDOT = STEMP
      RETURN
      END
      DOUBLE PRECISION FUNCTION DDOT(N,DX,INCX,DY,INCY)
C
C     FORMS THE DOT PRODUCT OF TWO VECTORS.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      DOUBLE PRECISION DX(*),DY(*),DTEMP
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N
C
      DDOT = 0.0D0
      DTEMP = 0.0D0
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DTEMP = DTEMP + DX(IX)*DY(IY)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      DDOT = DTEMP
      RETURN
C
C        CODE FOR BOTH INCREMENTS EQUAL TO 1
C
C
C        CLEAN-UP LOOP
C
   20 M = MOD(N,5)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        DTEMP = DTEMP + DX(I)*DY(I)
   30 CONTINUE
      IF( N .LT. 5 ) GO TO 60
   40 MP1 = M + 1
      DO 50 I = MP1,N,5
        DTEMP = DTEMP + DX(I)*DY(I) + DX(I + 1)*DY(I + 1) +
     *   DX(I + 2)*DY(I + 2) + DX(I + 3)*DY(I + 3) + DX(I + 4)*DY(I + 4)
   50 CONTINUE
   60 DDOT = DTEMP
      RETURN
      END
      COMPLEX FUNCTION CDOTC(N,CX,INCX,CY,INCY)
C
C     FORMS THE DOT PRODUCT OF TWO VECTORS, CONJUGATING THE FIRST
C     VECTOR.
C     JACK DONGARRA, LINPACK,  3/11/78.
C
      COMPLEX CX(*),CY(*),CTEMP
      INTEGER I,INCX,INCY,IX,IY,N
C
      CTEMP = (0.0,0.0)
      CDOTC = (0.0,0.0)
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        CTEMP = CTEMP + CONJG(CX(IX))*CY(IY)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      CDOTC = CTEMP
      RETURN
C
C        CODE FOR BOTH INCREMENTS EQUAL TO 1
C
   20 DO 30 I = 1,N
        CTEMP = CTEMP + CONJG(CX(I))*CY(I)
   30 CONTINUE
      CDOTC = CTEMP
      RETURN
      END
      COMPLEX FUNCTION CDOTU(N,CX,INCX,CY,INCY)
C
C     FORMS THE DOT PRODUCT OF TWO VECTORS.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      COMPLEX CX(*),CY(*),CTEMP
      INTEGER I,INCX,INCY,IX,IY,N
C
      CTEMP = (0.0,0.0)
      CDOTU = (0.0,0.0)
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        CTEMP = CTEMP + CX(IX)*CY(IY)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      CDOTU = CTEMP
      RETURN
C
C        CODE FOR BOTH INCREMENTS EQUAL TO 1
C
   20 DO 30 I = 1,N
        CTEMP = CTEMP + CX(I)*CY(I)
   30 CONTINUE
      CDOTU = CTEMP
      RETURN
      END
      SUBROUTINE  SSCAL(N,SA,SX,INCX)
C
C     SCALES A VECTOR BY A CONSTANT.
C     USES UNROLLED LOOPS FOR INCREMENT EQUAL TO 1.
C     JACK DONGARRA, LINPACK, 3/11/78.
C
      REAL SA,SX(*)
      INTEGER I,INCX,M,MP1,N,NINCX
C
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1)GO TO 20
C
C        CODE FOR INCREMENT NOT EQUAL TO 1
C
      NINCX = N*INCX
      DO 10 I = 1,NINCX,INCX
        SX(I) = SA*SX(I)
   10 CONTINUE
      RETURN
C
C        CODE FOR INCREMENT EQUAL TO 1
C
C
C        CLEAN-UP LOOP
C
   20 M = MOD(N,5)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        SX(I) = SA*SX(I)
   30 CONTINUE
      IF( N .LT. 5 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,5
        SX(I) = SA*SX(I)
        SX(I + 1) = SA*SX(I + 1)
        SX(I + 2) = SA*SX(I + 2)
        SX(I + 3) = SA*SX(I + 3)
        SX(I + 4) = SA*SX(I + 4)
   50 CONTINUE
      RETURN
      END
