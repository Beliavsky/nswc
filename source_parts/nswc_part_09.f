      SUBROUTINE SCOMP2 (X,Y,YPP,N,XI,YI,NI,IERR)
C
C     ABSTRACT
C
C         SCOMP2 EVALUATES A CUBIC SPLINE AT THE ABSCISSAS IN XI.
C         IT IS ASSUMED THAT THE SECOND DERIVATIVES AT THE NODES
C         HAVE BEEN PROVIDED.
C
C     DESCRIPTION OF ARGUMENTS
C
C       --INPUT--
C
C         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
C               SPLINE.
C         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
C         YPP - ARRAY OF SECOND DERIVATIVES THAT DEFINE THE SPLINE.
C         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
C               THE ARRAYS X, Y, AND YPP MUST BE DIMENSIONED AT LEAST N.
C               N MUST BE GREATER THAN OR EQUAL TO 2.
C         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
C               AT WHICH THE SPLINE IS TO BE EVALUATED.
C         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
C               EVALUATED.  IF NI IS GREATER THAN 1 THEN XI AND YI
C               MUST BE ARRAYS OF DIMENSION NI OR LARGER.
C               IT IS ASSUMED THAT NI IS GREATER THAN OR EQUAL TO 1.
C
C       --OUTPUT--
C
C         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
C         IERR- STATUS CODE
C               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
C               1  INPUT ERROR - NI IS NOT POSITIVE.
C
      REAL X(N), Y(N), YPP(N), XI(NI), YI(NI)
C
C     CHECK INPUT
C
      IF (NI .GT. 0) GO TO 1
         IERR = 1
         RETURN
    1 IERR = 0
      NM1 = N - 1
C
C     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
C     I IS CURRENT INDEX INTO X ARRAY.
C
      K  = 1
      XX = XI(1)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(NM1)) GO TO 80
      IL = 1
      IR = NM1
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 100
      IF (XX - X(I)) 20,100,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   50 IF (XX .LT. X(I+1)) GO TO 100
      I = I + 1
      GO TO 50
C
C     XX IS GREATER THAN X(N) OR LESS THAN X(1)
C
   80 I = NM1
      GO TO 100
   90 I = 1
C
C     EVALUATION
C
  100 H  = X(I+1) - X(I)
      H2 = H*H
      XR = (X(I+1) - XX)/H
      XR2 = XR*XR
      XR3 = XR*XR2
      XL = (XX - X(I))/H
      XL2 = XL*XL
      XL3 = XL*XL2
      YI(K) = Y(I)*XR + Y(I+1)*XL
     *       - H2*(YPP(I)*(XR-XR3) + YPP(I+1)*(XL-XL3))/6.0
C
C     NEXT POINT
C
      IF (K .GE. NI) RETURN
      K = K + 1
      XX = XI(K)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(NM1)) GO TO 80
      IF (XX - XI(K-1)) 110,100,50
  110 IL = 1
      IR = MIN0(I+1,NM1)
      GO TO 10
      END
      SUBROUTINE SEVAL (X,Y,A,B,C,N,XI,YI,YPI,YPPI,NI,IERR)
C
C     ABSTRACT
C
C         SEVAL EVALUATES A CUBIC SPLINE AND ITS FIRST AND SECOND
C         DERIVATIVES AT THE ABSCISSAS IN XI.  IT IS ASSUMED THAT
C         THE COEFFICIENTS OF THE POLYNOMIALS WHICH FORM THE SPLINE
C         ARE PROVIDED.
C
C     DESCRIPTION OF ARGUMENTS
C
C       --INPUT--
C
C         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
C               THAT DEFINE THE SPLINE.
C         Y   - ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
C         A,B,C ARRAYS THAT CONTAIN THE COEFFICIENTS OF THE POLYNOMIALS
C               WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
C               HAS THE VALUE
C                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
C               FOR X(I) .LE. XX .LE. X(I+1).  HERE DX = XX-X(I).
C         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
C               THE ARRAYS X, Y, A, B, C  MUST BE DIMENSIONED AT
C               LEAST N.  N MUST BE GREATER THAN OR EQUAL TO 1.
C         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
C               AT WHICH THE SPLINE IS TO BE EVALUATED.
C         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
C               EVALUATED.  IF NI IS GREATER THAN 1, THEN XI, YI, YPI,
C               AND YPPI MUST BE ARRAYS DIMENSIONED AT LEAST NI.
C               NI MUST BE GREATER THAN OR EQUAL TO 1.
C
C       --OUTPUT--
C
C         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
C         YPI - ARRAY OF VALUES OF THE FIRST DERIVATIVE OF SPLINE AT XI.
C         YPPI- ARRAY OF VALUES OF SECOND DERIVATIVES OF SPLINE AT XI.
C         IERR- STATUS CODE
C               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
C               1  INPUT ERROR - NI IS NOT POSITIVE.
C
      REAL X(N),Y(N),A(N),B(N),C(N),XI(NI),YI(NI),YPI(NI),YPPI(NI)
C
C     CHECK INPUT
C
      IF (NI .GT. 0) GO TO 1
         IERR = 1
         RETURN
    1 IERR = 0
C
C     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
C     I IS CURRENT INDEX INTO X ARRAY.
C
      K  = 1
      XX = XI(1)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(N)) GO TO 80
      IL = 1
      IR = N
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 100
      IF (XX - X(I)) 20,100,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   50 IF (XX .LT. X(I+1)) GO TO 100
      I = I + 1
      GO TO 50
C
C     XX IS GREATER THAN X(N) OR LESS THAN X(1)
C
   80 I = N
      GO TO 100
   90 I = 1
C
C     EVALUATION
C
  100 DX = XX - X(I)
      YI(K) = Y(I) + DX*(A(I) + DX*(B(I) + DX*C(I)))
      BI = B(I) + B(I)
      CI = 3.0*C(I)
      YPI(K) = A(I) + DX*(BI + DX*CI)
      YPPI(K) = BI + DX*(CI + CI)
C
C     NEXT POINT
C
      IF (K .GE. NI) RETURN
      K = K + 1
      XX = XI(K)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(N)) GO TO 80
      IF (XX - XI(K-1)) 110,100,50
  110 IL = 1
      IR = MIN0(I+1,N)
      GO TO 10
      END
      SUBROUTINE SEVAL1 (X,Y,YP,N,XI,YI,YPI,YPPI,NI,IERR)
C
C     ABSTRACT
C
C         SEVAL1 EVALUATES A CUBIC SPLINE AND ITS FIRST AND SECOND
C         DERIVATIVES AT THE ABSCISSAS IN XI.  IT IS ASSUMED THAT
C         THE FIRST DERIVATIVES AT THE NODES HAVE BEEN PROVIDED.
C
C     DESCRIPTION OF ARGUMENTS
C
C       --INPUT--
C
C         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
C               SPLINE.
C         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
C         YP  - ARRAY OF FIRST DERIVATIVES THAT DEFINE THE SPLINE.
C         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
C               THE ARRAYS X, Y, AND YP MUST BE DIMENSIONED AT LEAST N.
C               N MUST BE GREATER THAN OR EQUAL TO 2.
C         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
C               AT WHICH THE SPLINE IS TO BE EVALUATED.
C         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
C               EVALUATED.  IF NI IS GREATER THAN 1, THEN XI, YI, YPI,
C               AND YPPI MUST BE ARRAYS DIMENSIONED AT LEAST NI.
C               NI MUST BE GREATER THAN OR EQUAL TO 1.
C
C       --OUTPUT--
C
C         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
C         YPI - ARRAY OF VALUES OF THE FIRST DERIVATIVE OF SPLINE AT XI.
C         YPPI- ARRAY OF VALUES OF SECOND DERIVATIVES OF SPLINE AT XI.
C         IERR- STATUS CODE
C               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
C               1  INPUT ERROR - NI IS NOT POSITIVE.
C
      REAL X(N),Y(N),YP(N),XI(NI),YI(NI),YPI(NI),YPPI(NI)
C
C     CHECK INPUT
C
      IF (NI .GT. 0) GO TO 1
         IERR = 1
         RETURN
    1 IERR = 0
      NM1 = N - 1
C
C     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
C     I IS CURRENT INDEX INTO X ARRAY.
C
      K  = 1
      XX = XI(1)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(NM1)) GO TO 80
      IL = 1
      IR = NM1
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 100
      IF (XX - X(I)) 20,100,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   50 IF (XX .LT. X(I+1)) GO TO 100
      I = I + 1
      GO TO 50
C
C     XX IS GREATER THAN X(N) OR LESS THAN X(1)
C
   80 I = NM1
      GO TO 100
   90 I = 1
C
C     EVALUATION
C
  100 H = X(I+1) - X(I)
      D = (Y(I+1) - Y(I))/H
      A = YP(I) + YP(I+1)
      B = (-A - YP(I) + 3.0*D)/H
      C = (A - D - D)/(H*H)
      DX = XX - X(I)
      YI(K) = Y(I) + DX*(YP(I) + DX*(B + DX*C))
      B = B + B
      C = 3.0*C
      YPI(K) = YP(I) + DX*(B + DX*C)
      YPPI(K) = B + DX*(C + C)
C
C     NEXT POINT
C
      IF (K .GE. NI) RETURN
      K = K + 1
      XX = XI(K)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(NM1)) GO TO 80
      IF (XX - XI(K-1)) 110,100,50
  110 IL = 1
      IR = MIN0(I+1,NM1)
      GO TO 10
      END
      SUBROUTINE SEVAL2 (X,Y,YPP,N,XI,YI,YPI,YPPI,NI,IERR)
C
C     ABSTRACT
C
C         SEVAL2 EVALUATES A CUBIC SPLINE AND ITS FIRST AND SECOND
C         DERIVATIVES AT THE ABSCISSAS IN XI.  IT IS ASSUMED THAT
C         THE SECOND DERIVATIVES AT THE NODES HAVE BEEN PROVIDED.
C
C     DESCRIPTION OF ARGUMENTS
C
C       --INPUT--
C
C         X   - ARRAY OF ABSCISSAS (IN INCREASING ORDER) THAT DEFINE THE
C               SPLINE.
C         Y   - ARRAY OF ORDINATES THAT DEFINE THE SPLINE.
C         YPP - ARRAY OF SECOND DERIVATIVES THAT DEFINE THE SPLINE.
C         N   - THE NUMBER OF DATA POINTS THAT DEFINE THE SPLINE.
C               THE ARRAYS X, Y, AND YPP MUST BE DIMENSIONED AT LEAST N.
C               N MUST BE GREATER THAN OR EQUAL TO 2.
C         XI  - THE ABSCISSA OR ARRAY OF ABSCISSAS (IN ARBITRARY ORDER)
C               AT WHICH THE SPLINE IS TO BE EVALUATED.
C         NI  - THE NUMBER OF ABSCISSAS AT WHICH THE SPLINE IS TO BE
C               EVALUATED.  IF NI IS GREATER THAN 1, THEN XI, YI, YPI,
C               AND YPPI MUST BE ARRAYS DIMENSIONED AT LEAST NI.
C               NI MUST BE GREATER THAN OR EQUAL TO 1.
C
C       --OUTPUT--
C
C         YI  - ARRAY OF VALUES OF THE SPLINE (ORDINATES) AT XI.
C         YPI - ARRAY OF VALUES OF THE FIRST DERIVATIVE OF SPLINE AT XI.
C         YPPI- ARRAY OF VALUES OF SECOND DERIVATIVES OF SPLINE AT XI.
C         IERR- STATUS CODE
C               0  THE SPLINE WAS EVALUATED AT EACH ABSCISSA IN XI.
C               1  INPUT ERROR - NI IS NOT POSITIVE.
C
      REAL X(N),Y(N),YPP(N),XI(NI),YI(NI),YPI(NI),YPPI(NI)
C
C     CHECK INPUT
C
      IF (NI .GT. 0) GO TO 1
         IERR = 1
         RETURN
    1 IERR = 0
      NM1 = N - 1
C
C     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
C     I IS CURRENT INDEX INTO X ARRAY.
C
      K  = 1
      XX = XI(1)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(NM1)) GO TO 80
      IL = 1
      IR = NM1
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 100
      IF (XX - X(I)) 20,100,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   50 IF (XX .LT. X(I+1)) GO TO 100
      I = I + 1
      GO TO 50
C
C     XX IS GREATER THAN X(N) OR LESS THAN X(1)
C
   80 I = NM1
      GO TO 100
   90 I = 1
C
C     EVALUATION
C
  100 H  = X(I+1) - X(I)
      H2 = H*H
      XR = (X(I+1) - XX)/H
      XR2 = XR*XR
      XR3 = XR*XR2
      XL = (XX - X(I))/H
      XL2 = XL*XL
      XL3 = XL*XL2
      YI(K) = Y(I)*XR + Y(I+1)*XL
     1       - H2*(YPP(I)*(XR-XR3) + YPP(I+1)*(XL-XL3))/6.0
      YPI(K) = (Y(I+1)-Y(I))/H
     1        + H*(YPP(I)*(1.0-3.0*XR2) - YPP(I+1)*(1.0-3.0*XL2))/6.0
      YPPI(K) = YPP(I)*XR + YPP(I+1)*XL
C
C     NEXT POINT
C
      IF (K .GE. NI) RETURN
      K = K + 1
      XX = XI(K)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(NM1)) GO TO 80
      IF (XX - XI(K-1)) 110,100,50
  110 IL = 1
      IR = MIN0(I+1,NM1)
      GO TO 10
      END
      REAL FUNCTION CSINT (X, Y, A, B, C, N, ALPHA, BETA)
C-----------------------------------------------------------------------
C
C                    INTEGRATING A CUBIC SPLINE
C
C                         --------------
C
C     X      ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
C            THAT DEFINE THE SPLINE.
C
C     Y      ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
C
C     A,B,C  ARRAYS THAT CONTAIN THE COEFFICIENTS OF THE POLYNOMIALS
C            WHICH FORM THE SPLINE. IF I = 1,...,N  THEN THE SPLINE
C            HAS THE VALUE
C                    Y(I) + A(I)*DX + B(I)*DX**2 + C(I)*DX**3
C            FOR X(I) .LE. XX .LE. X(I+1). HERE DX = XX - X(I).
C
C     N      THE NUMBER OF POLYNOMIALS THAT DEFINE THE SPLINE.
C            THE ARRAYS X, Y, A, B, C  MUST BE DIMENSIONED AT
C            LEAST N.  N MUST BE GREATER THAN OR EQUAL TO 1.
C
C     ALPHA  LOWER LIMIT OF THE INTEGRAL.
C
C     BETA   UPPER LIMIT OF THE INTEGRAL. BETA MAY BE LESS THAN
C            OR GREATER THAN ALPHA.
C
C-----------------------------------------------------------------------
      REAL X(N), Y(N), A(N), B(N), C(N)
C
      CSINT = 0.0
      H = BETA - ALPHA
      IF (H .EQ. 0.0) RETURN
      IF (H .GT. 0.0) GO TO 10
         A0 = BETA
         B0 = ALPHA
         GO TO 20
   10 A0 = ALPHA
      B0 = BETA
C
C     LOCATE THE INTERVALS CONTAINING A0 AND B0
C
   20 IF (N .EQ. 1) GO TO 50
      IF (A0 .GE. X(N)) GO TO 50
      K = INTRVL (A0, X, N)
      L = INTRVL (B0, X, N)
      IF (B0 .GE. X(N)) L = N
      IF (K .EQ. L) GO TO 51
C
C     INTEGRATE FROM A0 TO X(K + 1)
C
      KP1 = K + 1
      H = X(KP1) - X(K)
      D = A0 - X(K)
      R = H + D
      H2 = H*H
      D2 = D*D
      S = H2 + D2
      SUM = Y(K) + 0.5*A(K)*R + B(K)*(S + H*D)/3.0
     *           + 0.25*C(K)*R*S
      SUM = (X(KP1) - A0)*SUM
C
C     INTEGRATE OVER THE INTERIOR INTERVALS
C
      IF (KP1 .EQ. L) GO TO 40
      LM1 = L - 1
      DO 30 I = KP1,LM1
         H = X(I + 1) - X(I)
         S = (((0.25*C(I)*H + B(I)/3.0)*H + 0.5*A(I))*H + Y(I))*H
         SUM = SUM + S
   30 CONTINUE
C
C     INTEGRATE FROM X(L) TO B0
C
   40 H = B0 - X(L)
      S = (((0.25*C(L)*H + B(L)/3.0)*H + 0.5*A(L))*H + Y(L))*H
      CSINT = SUM + S
      IF (ALPHA .GT. BETA) CSINT = -CSINT
      RETURN
C
C     CASE WHEN A0 AND B0 ARE IN THE SAME INTERVAL
C
   50 K = N
   51 H = B0 - X(K)
      D = A0 - X(K)
      R = H + D
      H2 = H*H
      D2 = D*D
      S = H2 + D2
      SUM = Y(K) + 0.5*A(K)*R + B(K)*(S + H*D)/3.0
     *           + 0.25*C(K)*R*S
      CSINT = (BETA - ALPHA)*SUM
      RETURN
      END
      REAL FUNCTION CSINT1 (X, Y, YP, N, A, B)
C-----------------------------------------------------------------------
C
C                    INTEGRATING A CUBIC SPLINE
C
C                         --------------
C
C     X    ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
C          THAT DEFINE THE SPLINE.
C
C     Y    ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
C
C     YP   ARRAY OF THE FIRST DERIVATIVES THAT DEFINE THE SPLINE.
C
C     N    THE NUMBER OF KNOTS OF THE SPLINE. THE ARRAYS X, Y,
C          AND YP MUST HAVE DIMENSION AT LEAST N WHERE N .GE. 2.
C
C     A    LOWER LIMIT OF THE INTEGRAL.
C
C     B    UPPER LIMIT OF THE INTEGRAL. B MAY BE LESS THAN
C          OR GREATER THAN A.
C
C-----------------------------------------------------------------------
      REAL X(N), Y(N), YP(N)
C
      CSINT1 = 0.0
      H = B - A
      IF (H .EQ. 0.0) RETURN
      IF (H .GT. 0.0) GO TO 10
         A0 = B
         B0 = A
         GO TO 20
   10 A0 = A
      B0 = B
C
C     LOCATE THE INTERVALS CONTAINING A0 AND B0
C
   20 K = INTRVL (A0, X, N)
      L = INTRVL (B0, X, N)
      IF (K .EQ. L) GO TO 50
C
C     INTEGRATE FROM A0 TO X(K + 1)
C
      KP1 = K + 1
      H = X(KP1) - X(K)
      D = (Y(KP1) - Y(K))/H
      R = YP(K) + YP(KP1)
      BI = (-R - YP(K) + 3.0*D)/H
      CI = (R - D - D)/(H*H)
C
      D = A0 - X(K)
      R = H + D
      H2 = H*H
      D2 = D*D
      S = H2 + D2
      SUM = Y(K) + 0.5*YP(K)*R + BI*(S + H*D)/3.0
     *           + 0.25*CI*R*S
      SUM = (X(KP1) - A0)*SUM
C
C     INTEGRATE OVER THE INTERIOR INTERVALS
C
      IF (KP1 .EQ. L) GO TO 40
      LM1 = L - 1
      DO 30 I = KP1,LM1
         IP1 = I + 1
         H = X(IP1) - X(I)
         D = (Y(IP1) - Y(I))/H
         R = YP(I) + YP(IP1)
         BI = (-R - YP(I) + 3.0*D)/H
         CI = (R - D - D)/(H*H)
         S = (((0.25*CI*H + BI/3.0)*H + 0.5*YP(I))*H + Y(I))*H
         SUM = SUM + S
   30 CONTINUE
C
C     INTEGRATE FROM X(L) TO B0
C
   40 LP1 = L + 1
      H = X(LP1) - X(L)
      D = (Y(LP1) - Y(L))/H
      R = YP(L) + YP(LP1)
      BI = (-R - YP(L) + 3.0*D)/H
      CI = (R - D - D)/(H*H)
      H = B0 - X(L)
      S = (((0.25*CI*H + BI/3.0)*H + 0.5*YP(L))*H + Y(L))*H
      CSINT1 = SUM + S
      IF (A .GT. B) CSINT1 = -CSINT1
      RETURN
C
C     CASE WHEN A0 AND B0 ARE IN THE SAME INTERVAL
C
   50 KP1 = K + 1
      H = X(KP1) - X(K)
      D = (Y(KP1) - Y(K))/H
      R = YP(K) + YP(KP1)
      BI = (-R - YP(K) + 3.0*D)/H
      CI = (R - D - D)/(H*H)
C
      H = B0 - X(K)
      D = A0 - X(K)
      R = H + D
      H2 = H*H
      D2 = D*D
      S = H2 + D2
      SUM = Y(K) + 0.5*YP(K)*R + BI*(S + H*D)/3.0
     *           + 0.25*CI*R*S
      CSINT1 = (B - A)*SUM
      RETURN
      END
      REAL FUNCTION CSINT2 (X, Y, YPP, N, A, B)
C-----------------------------------------------------------------------
C
C                    INTEGRATING A CUBIC SPLINE
C
C                         --------------
C
C     X    ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
C          THAT DEFINE THE SPLINE.
C
C     Y    ARRAY OF THE FIRST N ORDINATES THAT DEFINE THE SPLINE.
C
C     YPP  ARRAY OF THE SECOND DERIVATIVES THAT DEFINE THE SPLINE.
C
C     N    THE NUMBER OF KNOTS OF THE SPLINE. THE ARRAYS X, Y,
C          AND YPP MUST HAVE DIMENSION AT LEAST N WHERE N .GE. 2.
C
C     A    LOWER LIMIT OF THE INTEGRAL.
C
C     B    UPPER LIMIT OF THE INTEGRAL. B MAY BE LESS THAN
C          OR GREATER THAN A.
C
C-----------------------------------------------------------------------
      REAL X(N), Y(N), YPP(N)
C
      CSINT2 = 0.0
      H = B - A
      IF (H .EQ. 0.0) RETURN
      IF (H .GT. 0.0) GO TO 10
         A0 = B
         B0 = A
         GO TO 20
   10 A0 = A
      B0 = B
C
C     LOCATE THE INTERVALS CONTAINING A0 AND B0
C
   20 K = INTRVL (A0, X, N)
      L = INTRVL (B0, X, N)
      IF (K .EQ. L) GO TO 50
C
C     INTEGRATE FROM A0 TO X(K + 1)
C
      KP1 = K + 1
      H = X(KP1) - X(K)
      D = (X(KP1) - A0)/H
      R = Y(K)*D + Y(KP1)*(2.0 - D)
      S = YPP(K)*(2.0 - D*D) + YPP(KP1)*(2.0 - D)**2
      SUM = H*D*(0.5*R - H*H*D*S/24.0)
C
C
C     INTEGRATE OVER THE INTERIOR INTERVALS
C
      IF (KP1 .EQ. L) GO TO 40
      LM1 = L - 1
      DO 30 I = KP1,LM1
         IP1 = I + 1
         H = X(IP1) - X(I)
         R = Y(I) + Y(IP1)
         S = YPP(I) + YPP(IP1)
         SUM = SUM + H*(0.5*R - H*H*S/24.0)
   30 CONTINUE
C
C     INTEGRATE FROM X(L) TO B0
C
   40 LP1 = L + 1
      H = X(LP1) - X(L)
      D = (B0 - X(L))/H
      R = Y(L)*(2.0 - D) + Y(LP1)*D
      S = YPP(L)*(2.0 - D)**2 + YPP(LP1)*(2.0 - D*D)
      CSINT2 = SUM + H*D*(0.5*R - H*H*D*S/24.0)
      IF (A .GT. B) CSINT2 = -CSINT2
      RETURN
C
C     CASE WHEN A0 AND B0 ARE IN THE SAME INTERVAL
C
   50 KP1 = K + 1
      H = X(KP1) - X(K)
      DMA = (A - X(K))/H
      DMB = (B - X(K))/H
      DPA = (X(KP1) - A)/H
      DPB = (X(KP1) - B)/H
      R = (DPA + DPB)*Y(K) + (DMA + DMB)*Y(KP1)
      S = YPP(K) * (DPA + DPB)*(DMA*(2.0 - DMA) + DMB*(2.0 - DMB)) +
     *    YPP(KP1)*(DMA + DMB)*(DPA*(2.0 - DPA) + DPB*(2.0 - DPB))
      CSINT2 = (B - A)*(0.5*R - H*H*S/24.0)
      RETURN
      END
      SUBROUTINE PDSPL (X, Y, A, B, C, N, T, IERR)
C-----------------------------------------------------------------------
C                PERIODIC CUBIC SPLINE INTERPOLATION
C-----------------------------------------------------------------------
      REAL X(N), Y(*), A(*), B(*), C(*), T(*)
C----------------------
C     REAL X(N), Y(N-1), A(N-1), B(N-1), C(N-1), T(N-2)
C----------------------
      IF (N .LT. 3) GO TO 100
      NM1 = N - 1
      NM2 = N - 2
      NM3 = N - 3
C
C     A STRICTLY DIAGONALLY DOMINANT SET OF EQUATIONS FOR THE
C     SLOPES S(I) OF THE SPLINE AT X(I) (I = 1,...,N-1) IS
C     GENERATED AND SOLVED BY GAUSS ELIMINATION. THE FIRST OF
C     THESE EQUATIONS IS OBTAINED FROM THE REQUIREMENT THAT
C     THE SPLINE BE PERIODIC. THIS EQUATION HAS THE FORM ...
C
C        A(1)*S(1) + B(1)*S(2) + C(1)*S(N-1) = T(1)
C
      B(1) = X(N) - X(NM1)
      H = X(2) - X(1)
      IF (H .LE. 0.0 .OR. B(1) .LE. 0.0) GO TO 110
      DEL = (Y(1) - Y(NM1))/B(1)
      DELI = (Y(2) - Y(1))/H
C
      C(1) = H
      A(1) = 2.0*(H + B(1))
      T(1) = 3.0*(H*DEL + B(1)*DELI)
      IF (N .EQ. 3) GO TO 20
C
C     FOR THE KNOTS X(I) (I = 2,...N-2) GENERATE THE CORRESPOND-
C     ING EQUATIONS AND CARRY OUT THE PIVOT REDUCTION OF GAUSS
C     ELIMINATION. THEN THE I-TH EQUATION HAS THE FORM ...
C
C        A(I)*S(I) + B(I)*S(I+1) + C(I)*S(N-1) = T(I)
C
      DO 10 I = 2,NM2
         B(I) = H
         H = X(I+1) - X(I)
         IF (H .LE. 0.0) GO TO 110
C
         E = H/A(I-1)
         C(I) = - E*C(I-1)
         A(I) = 2.0*(B(I) + H) - E*B(I-1)
C
         DEL0 = DELI
         DELI = (Y(I+1) - Y(I))/H
         T(I) = 3.0*(H*DEL0 + B(I)*DELI) - E*T(I-1)
   10 CONTINUE
C
   20 IERR = 0
      B(NM1) = H
C
C     SINCE IT IS REQUIRED THAT THE SPLINE BE PERIODIC, THE
C     EQUATION FOR THE KNOT X(N-1) HAS THE FORM ...
C
C        ALPHA*S(1) + B(1)*S(N-2) + DELTA*S(N-1) = R
C
C     APPLYING THE PIVOTS TO THIS EQUATION, ONE OBTAINS AFTER
C     EACH PIVOT OPERATION THE MODIFIED EQUATION ...
C
C        ALPHA*S(I+1) + B(1)*S(N-2) + DELTA*S(N-1) = R
C
C     THUS, WHEN THIS PIVOT REDUCTION IS COMPLETE, THE (N-1)-ST
C     EQUATION TO BE SOLVED HAS THE FORM ...
C
C        (ALPHA + B(1))*S(N-2) + DELTA*S(N-1) = R
C
      ALPHA = H
      DELTA = 2.0*(H + B(1))
      R = 3.0*(B(1)*DELI + H*DEL)
      IF (N .EQ. 3) GO TO 40
C
      DO 30 I = 1,NM3
         E = ALPHA/A(I)
         ALPHA = - E*B(I)
         DELTA = DELTA - E*C(I)
         R = R - E*T(I)
   30 CONTINUE
C
C     SOLVE THE LAST TWO EQUATIONS FOR S(N-1) AND S(N-2), AND
C     STORE THESE SLOPES IN A.
C
   40 E = (ALPHA + B(1))/A(NM2)
      W = B(NM2) + C(NM2)
      S = (R - E*T(NM2))/(DELTA - E*W)
      A(NM1) = S
      A(NM2) = (T(NM2) - W*S)/A(NM2)
      IF (N .EQ. 3) GO TO 60
C
C     BACK SUBSTITUTION TO OBTAIN THE REMAINING SLOPES S(I).
C     THESE SLOPES ARE STORED IN A.
C
      SI = A(NM2)
      DO 50 J = 3,NM1
         I = N - J
         SI = (T(I) - B(I)*SI - C(I)*S)/A(I)
         A(I) = SI
   50 CONTINUE
C
C     GENERATE THE CUBIC COEFFICIENTS B(I) AND C(I)
C
   60 H = B(1)
      DO 61 I = 1,NM2
         HI = B(I + 1)
         DELI = (Y(I+1) - Y(I))/HI
         W = A(I) + A(I+1) - 2.0*DELI
         B(I) = (DELI - A(I) - W)/HI
         C(I) = (W/HI)/HI
   61 CONTINUE
      W = A(1) + A(NM1) - 2.0*DEL
      B(NM1) = (DEL - A(NM1) - W)/H
      C(NM1) = (W/H)/H
      RETURN
C
C     ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      RETURN
      END
      SUBROUTINE PDFIT (X, Y, M, BREAK, L, Z, A, B, C, WK, IWK, IERR)
C-----------------------------------------------------------------------
C            LEAST SQUARES PERIODIC CUBIC SPLINE FITTING
C-----------------------------------------------------------------------
      REAL X(M), Y(M), BREAK(L)
      REAL Z(*), A(*), B(*), C(*), WK(*)
      INTEGER IWK(*)
C--------------------
C     REAL Z(L-1), A(L-1), B(L-1), C(L-1)
C     REAL WK((L + 6)*(L + 15) + 10)
C     INTEGER IWK(2*L + 6)
C--------------------
      REAL TEMP(20)
      REAL CON(3), XCON(3)
      INTEGER NDER(3)
C--------------------
      DATA NDER(1) /3/, NDER(2) /7/, NDER(3) /11/
C--------------------
      IF (M .LE. 0 .OR. L .LT. 2) GO TO 100
      N = L + 2
C
C                DEFINE THE NODES FOR THE B-SPLINES
C
      WK(1) = BREAK(1)
      WK(2) = BREAK(1)
      WK(3) = BREAK(1)
      WK(4) = BREAK(1)
      DO 10 J = 2,L
         IF (BREAK(J - 1) .GE. BREAK(J)) GO TO 110
         WK(J + 3) = BREAK(J)
   10 CONTINUE
      WK(L + 4) = BREAK(L)
      WK(L + 5) = BREAK(L)
      WK(L + 6) = BREAK(L)
C
C                DEFINE THE PERIODICITY CONSTRAINTS
C
      CON(1) = BREAK(1)
      CON(2) = BREAK(1)
      CON(3) = BREAK(1)
      XCON(1) = BREAK(L)
      XCON(2) = BREAK(L)
      XCON(3) = BREAK(L)
C
C     OBTAIN THE B-SPLINE COEFFICIENTS OF THE PERIODIC SPLINE
C
      IERR = 0
      LA = N + 5
      LW = LA + N
      IWK(1) = IWK(1) - (L + L + 8)
      CALL BFIT (WK(1), N, 4, X, Y, M, XCON, CON, NDER, 3, IERR,
     *           WK(LA), R, WK(LW), IWK)
      IWK(1) = IWK(1) + (L + L + 8)
      IF (IERR .NE. 0) GO TO 30
C
C     OBTAIN THE COEFFICIENTS OF THE SPLINE IN TAYLOR SERIES FORM
C
      CALL BSPP (WK(1), WK(LA), N, 4, BREAK, WK(LW), LM1, TEMP)
      K = LW
      DO 20 J = 1,LM1
         Z(J) = WK(K)
         A(J) = WK(K + 1)
         B(J) = WK(K + 2)
         C(J) = WK(K + 3)
         K = K + 4
   20 CONTINUE
      RETURN
C
C                THE COEFFICIENTS WERE NOT OBTAINED
C
   30 IF (IERR .EQ. -4) GO TO 120
      IF (IERR .EQ. -6) GO TO 130
      IF (IERR .EQ. -7) GO TO 140
      IERR = 1
      RETURN
C
C                           ERROR RETURN
C
  100 IERR = 2
      RETURN
  110 IERR = 3
      RETURN
  120 IERR = 4
      RETURN
  130 IERR = 5
      RETURN
  140 IERR = 6
      RETURN
      END
      SUBROUTINE PSCMP (X, Y, A, B, C, N, XI, YI, M, IERR)
C-----------------------------------------------------------------------
C              EVALUATION OF A PERIODIC CUBIC SPLINE
C-----------------------------------------------------------------------
      REAL X(N), Y(*), A(*), B(*), C(*), XI(M), YI(M)
C----------------------
C     REAL X(N), Y(N-1), A(N-1), B(N-1), C(N-1), XI(M), YI(M)
C----------------------
      IF (N .GE. 3 .AND. M .GE. 1) GO TO 1
         IERR = 1
         RETURN
    1 IERR = 0
      X1 = X(1)
      H = X(N) - X1
C
C     REDUCTION OF XI(K) TO XX WHERE X(1) .LE. XX .LT. X(N)
C
      K = 1
      T = (XI(1) - X1)/H
      J = T
      T0 = T - J
      IF (T0 .LT. 0.0) T0 = 1.0 + T0
      XX = X1 + T0*H
      IF (XX .GE. X(N)) GO TO 120
      IL = 1
      IR = N
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 90
      IF (XX - X(I)) 20,90,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   40 IF (XX .LT. X(I+1)) GO TO 90
      I = I + 1
      GO TO 40
C
C     COMPUTATION WHEN X(I) .LE. XX .LT. X(I+1)
C
   90 DX = XX - X(I)
      YI(K) = ((C(I)*DX + B(I))*DX + A(I))*DX + Y(I)
C
C     NEXT POINT
C
  100 IF (K .GE. M) RETURN
      XOLD = XX
      K = K + 1
      T = (XI(K) - X1)/H
      J = T
      T0 = T - J
      IF (T0 .LT. 0.0) T0 = 1.0 + T0
      XX = X1 + T0*H
      IF (XX .GE. X(N)) GO TO 120
      IF (XX - XOLD) 110,90,40
C
  110 IL = 1
      IR = MIN0(I+1,N)
      GO TO 10
C
C     CASE WHEN ROUNDOFF PRODUCES A VALUE FOR XX WHERE
C     XX .GE. X(N). THIS CASE MAY NEVER OCCUR.
C
  120 I = 1
      XX = X1
      YI(K) = Y(1)
      GO TO 100
      END
      SUBROUTINE PSEVL (X, Y, A, B, C, N, XI, YI, YPI, YPPI, M, IERR)
C-----------------------------------------------------------------------
C     EVALUATION AND DIFFERENTIATION OF A PERIODIC CUBIC SPLINE
C-----------------------------------------------------------------------
      REAL X(N), Y(*), A(*), B(*), C(*), XI(M), YI(M), YPI(M), YPPI(M)
C----------------------
C     REAL X(N), Y(N-1), A(N-1), B(N-1), C(N-1), XI(M), YI(M), YPI(M),
C    *     YPPI(M)
C----------------------
      IF (N .GE. 3 .AND. M .GE. 1) GO TO 1
         IERR = 1
         RETURN
    1 IERR = 0
      X1 = X(1)
      H = X(N) - X1
C
C     REDUCTION OF XI(K) TO XX WHERE X(1) .LE. XX .LT. X(N)
C
      K = 1
      T = (XI(1) - X1)/H
      J = T
      T0 = T - J
      IF (T0 .LT. 0.0) T0 = 1.0 + T0
      XX = X1 + T0*H
      IF (XX .GE. X(N)) GO TO 120
      IL = 1
      IR = N
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 90
      IF (XX - X(I)) 20,90,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   40 IF (XX .LT. X(I+1)) GO TO 90
      I = I + 1
      GO TO 40
C
C     COMPUTATION WHEN X(I) .LE. XX .LT. X(I+1)
C
   90 DX = XX - X(I)
      YI(K) = ((C(I)*DX + B(I))*DX + A(I))*DX + Y(I)
      BI2 = B(I) + B(I)
      CI3 = 3.0*C(I)
      YPI(K) = (CI3*DX + BI2)*DX + A(I)
      YPPI(K) = BI2 + (CI3 + CI3)*DX
C
C     NEXT POINT
C
  100 IF (K .GE. M) RETURN
      XOLD = XX
      K = K + 1
      T = (XI(K) - X1)/H
      J = T
      T0 = T - J
      IF (T0 .LT. 0.0) T0 = 1.0 + T0
      XX = X1 + T0*H
      IF (XX .GE. X(N)) GO TO 120
      IF (XX - XOLD) 110,90,40
C
  110 IL = 1
      IR = MIN0(I+1,N)
      GO TO 10
C
C     CASE WHEN ROUNDOFF PRODUCES A VALUE FOR XX WHERE
C     XX .GE. X(N). THIS CASE MAY NEVER OCCUR.
C
  120 I = 1
      XX = X1
      YI(K) = Y(1)
      YPI(K) = A(1)
      YPPI(K) = B(1) + B(1)
      GO TO 100
      END
      SUBROUTINE CSLOOP (M, N, X, KX, T, DX, KDX, WK, IERR)
C-----------------------------------------------------------------------
C               CLOSED CURVE CUBIC SPLINE FITTING
C                    IN N-DIMENSIONAL SPACE
C-----------------------------------------------------------------------
C     WRITTEN BY
C        ALFRED H. MORRIS
C        NAVAL SURFACE WARFARE CENTER
C        DAHLGREN, VIRGINIA
C----------------------
      REAL X(KX,N), T(M), DX(KDX,N), WK(*)
C----------------------
C     M = THE NUMBER OF N-DIMENSIONAL POINTS GIVEN IN X
C     WK IS AN ARRAY OF DIMENSION 4*(M-1)
C----------------------
      IF (MIN0(M, N) .LT. 2) GO TO 10
C
      MM1 = M - 1
      IE = 1
      IA = MM1
      IB = IA + MM1
      IC = IB + M
      CALL CSLOP1 (M, N, X, KX, T, DX, KDX, WK(IA), WK(IB),
     *                    WK(IC), WK(IE), IERR)
      RETURN
C
C     ERROR RETURN
C
   10 IERR = 1
      RETURN
      END
      SUBROUTINE CSLOP1 (M, N, X, KX, T, DX, KDX, A, B, C, E, IERR)
C-----------------------------------------------------------------------
C               CLOSED CURVE CUBIC SPLINE FITTING
C                    IN N-DIMENSIONAL SPACE
C-----------------------------------------------------------------------
      REAL X(KX,N), T(M), DX(KDX,N), A(*), B(M), C(*), E(*)
C----------------------
C     REAL A(M-1), C(M-1), E(K)  (K = MAX0(1,M-2))
C     THE E ARRAY IS NOT USED WHEN M = 2.
C----------------------
      MM1 = M - 1
      MM2 = M - 2
C
C     DEFINITION OF THE KNOTS T(I) (I = 1,...,M). ALSO T(M+1) = 1.
C     THIS LAST KNOT IS NOT STORED.
C
      T(1) = 0.0
      DO 11 I = 2,M
         IM1 = I - 1
         DO 10 J = 1,N
            DX(I,J) = X(I,J) - X(IM1,J)
   10    CONTINUE
         T(I) = T(IM1) + SNRM2(N,DX(I,1),KDX)
         R = T(I) - T(IM1)
         IF (R .EQ. 0.0) GO TO 200
   11 CONTINUE
C
      DO 20 J = 1,N
         DX(1,J) = X(1,J) - X(M,J)
   20 CONTINUE
      SUM = T(M) + SNRM2(N,DX(1,1),KDX)
      R = SUM - T(M)
      IF (R .EQ. 0.0) GO TO 210
C
      DO 30 I = 2,M
         T(I) = T(I)/SUM
   30 CONTINUE
      IERR = 0
C
C     FOR J = 1,...,N, A DIAGONALLY DOMINANT SET OF EQUATIONS
C     FOR THE SLOPES S(I,J) OF THE J-TH PERIODIC SPLINE AT T(I)
C     (I = 1,...,M) IS GENERATED AND SOLVED BY GAUSS ELIMINATION.
C     THE FIRST EQUATION IS OBTAINED FROM THE REQUIREMENT THAT
C     THE SPLINE BE PERIODIC. THIS EQUATION HAS THE FORM ...
C
C        A(1)*S(1,J) + B(1)*S(2,J) + C(1)*S(M,J) = DX(1,J)
C
      H = T(2)
      HM = 1.0 - T(M)
      C(1) = H
      B(1) = HM
      A(1) = 2.0*(H + HM)
      B(2) = H
C
      DO 40 J = 1,N
         DELM = DX(1,J)/HM
         DEL1 = DX(2,J)/H
         DX(1,J) = 3.0*(H*DELM + HM*DEL1)
         DX(2,J) = DEL1
   40 CONTINUE
      IF (M .EQ. 2) GO TO 70
C
C     FOR THE KNOTS T(I) (I = 2,...M-1), GENERATE THE CORRESPOND-
C     ING EQUATIONS AND CARRY OUT THE PIVOT REDUCTION OF GAUSS
C     ELIMINATION. THEN THE I-TH EQUATION HAS THE FORM ...
C
C        A(I)*S(I,J) + B(I)*S(I+1,J) + C(I)*S(M,J) = DX(I,J)
C
      DO 50 I = 2,MM1
         IM1 = I - 1
         B(I) = H
         H = T(I+1) - T(I)
         E(IM1) = H/A(IM1)
         C(I) = - E(IM1)*C(IM1)
         A(I) = 2.0*(B(I) + H) - E(IM1)*B(IM1)
   50 CONTINUE
      B(M) = H
C
      DO 61 J = 1,N
         DELI = DX(2,J)
         DO 60 I = 2,MM1
            H = B(I+1)
            DEL0 = DELI
            DELI = DX(I+1,J)/H
            DX(I,J) = 3.0*(H*DEL0 + B(I)*DELI) - E(I-1)*DX(I-1,J)
   60    CONTINUE
         DX(M,J) = DELI
   61 CONTINUE
C
C     SINCE IT IS REQUIRED THAT THE SPLINE BE PERIODIC, THE
C     EQUATION FOR THE KNOT T(M) HAS THE FORM ...
C
C        ALPHA*S(1,J) + HM*S(M-1,J) + ETA*S(M,J) = DX(M,J)
C
C     APPLYING THE PIVOTS TO THIS EQUATION, ONE OBTAINS AFTER
C     EACH PIVOT OPERATION THE MODIFIED EQUATION ...
C
C        ALPHA*S(I+1,J) + HM*S(M-1,J) + ETA*S(M,J) = DX(M,J)
C
C     THUS, WHEN THIS PIVOT REDUCTION IS COMPLETE, THE M-TH
C     EQUATION TO BE SOLVED HAS THE FORM ...
C
C        (ALPHA + HM)*S(M-1,J) + ETA*S(M,J) = DX(M,J)
C
   70 ALPHA = H
      ETA = 2.0*(H + HM)
      DO 71 J = 1,N
         DEL  = DX(M,J)
         DELM = (X(1,J) - X(M,J))/HM
         DX(M,J) = 3.0*(HM*DEL + H*DELM)
   71 CONTINUE
      IF (M .EQ. 2) GO TO 90
C
      DO 81 I = 1,MM2
         P = ALPHA/A(I)
         ALPHA = - P*B(I)
         ETA = ETA - P*C(I)
         DO 80 J = 1,N
            DX(M,J) = DX(M,J) - P*DX(I,J)
   80    CONTINUE
   81 CONTINUE
C
C     SOLVE THE LAST TWO EQUATIONS FOR S(M,J) AND S(M-1,J),
C     AND STORE THESE SLOPES IN DX.
C
   90 P = (ALPHA + HM)/A(MM1)
      TAU = B(MM1) + C(MM1)
      DO 91 J = 1,N
         SM = (DX(M,J) - P*DX(MM1,J))/(ETA - P*TAU)
         DX(M,J) = SM
         DX(MM1,J) = (DX(MM1,J) - TAU*SM)/A(MM1)
   91 CONTINUE
      IF (M .EQ. 2) RETURN
C
C     BACK SUBSTITUTION TO OBTAIN THE REMAINING SLOPES S(I,J).
C     THESE SLOPES ARE STORED IN DX.
C
      DO 101 J = 1,N
         SM = DX(M,J)
         SI = DX(MM1,J)
         I = MM1
         DO 100 L = 3,M
            I = I - 1
            SI = (DX(I,J) - B(I)*SI - C(I)*SM)/A(I)
            DX(I,J) = SI
  100    CONTINUE
  101 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = 2
      RETURN
  210 IERR = 3
      RETURN
      END
      SUBROUTINE LOPCMP (M, N, T, X, KX, DX, KDX, L, TI, Z, KZ)
C-----------------------------------------------------------------------
C            EVALUATION OF A CUBIC SPLINE CLOSED CURVE
C                     IN N-DIMENSIONAL SPACE
C-----------------------------------------------------------------------
      REAL T(M), X(KX,N), DX(KDX,N), TI(L), Z(KZ, N)
C
C     REDUCTION OF TI(K) TO T0 WHERE 0 .LE. T0 .LT. 1
C
      K = 1
      J = TI(1)
      T0 = TI(1) - J
      IF (T0 .LT. 0.0) T0 = 1.0 + T0
      IF (T0 .GE. T(M)) GO TO 60
      IL = 1
      IR = M
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 50
      IF (T0 - T(I)) 20,50,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   40 IF (T0 .LT. T(I+1)) GO TO 50
      I = I + 1
      GO TO 40
C
C     COMPUTATION WHEN T(I) .LE. T0 .LT. T(I+1)
C
   50 H = T(I+1) - T(I)
      DT = T0 - T(I)
      DO 51 J = 1,N
         A = DX(I,J)
         D = (X(I+1,J) - X(I,J))/H
         W = A + DX(I+1,J)
         B = (-W - A + 3.0*D)/H
         C = ((W - D - D)/H)/H
         Z(K,J) = X(I,J) + DT*(A + DT*(B + DT*C))
   51 CONTINUE
      GO TO 100
C
C     COMPUTATION WHEN T0 .GE. T(M)
C
   60 I = M
      H = 1.0 - T(M)
      DT = T0 - T(M)
      DO 61 J = 1,N
         A = DX(M,J)
         D = (X(1,J) - X(M,J))/H
         W = A + DX(1,J)
         B = (-W - A + 3.0*D)/H
         C = ((W - D - D)/H)/H
         Z(K,J) = X(M,J) + DT*(A + DT*(B + DT*C))
   61 CONTINUE
C
C     NEXT POINT
C
  100 IF (K .GE. L) RETURN
      TOLD = T0
      K = K + 1
      J = TI(K)
      T0 = TI(K) - J
      IF (T0 .LT. 0.0) T0 = 1.0 + T0
      IF (T0 .GE. T(M)) GO TO 60
      IF (T0 - TOLD) 110,50,40
C
  110 IL = 1
      IR = MIN0(I+1,M)
      GO TO 10
      END
      SUBROUTINE LOPDF (M, N, T, X, KX, DX, KDX, TI, Z, DZ, DDZ)
C-----------------------------------------------------------------------
C          EVALUATION AND DIFFERENTIATION OF A CUBIC SPLINE
C                CLOSED CURVE IN N-DIMENSIONAL SPACE
C-----------------------------------------------------------------------
      REAL T(M), X(KX,N), DX(KDX,N), Z(N), DZ(N), DDZ(N)
C
C     REDUCTION OF TI TO T0 WHERE 0 .LE. T0 .LT. 1
C
      J = TI
      T0 = TI - J
      IF (T0 .LT. 0.0) T0 = 1.0 + T0
      IF (T0 .GE. T(M)) GO TO 50
      IL = 1
      IR = M
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 40
      IF (T0 - T(I)) 20,40,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     COMPUTATION WHEN T(I) .LE. T0 .LT. T(I+1)
C
   40 H = T(I+1) - T(I)
      DT = T0 - T(I)
      DO 41 J = 1,N
         A = DX(I,J)
         D = (X(I+1,J) - X(I,J))/H
         W = A + DX(I+1,J)
         B = (-W - A + 3.0*D)/H
         C = ((W - D - D)/H)/H
         Z(J) = X(I,J) + DT*(A + DT*(B + DT*C))
         B = B + B
         C = 3.0*C
         DZ(J) = A + DT*(B + C*DT)
         DDZ(J) = B + (C + C)*DT
   41 CONTINUE
      RETURN
C
C     COMPUTATION WHEN T0 .GE. T(M)
C
   50 H = 1.0 - T(M)
      DT = T0 - T(M)
      DO 51 J = 1,N
         A = DX(M,J)
         D = (X(1,J) - X(M,J))/H
         W = A + DX(1,J)
         B = (-W - A + 3.0*D)/H
         C = ((W - D - D)/H)/H
         Z(J) = X(M,J) + DT*(A + DT*(B + DT*C))
         B = B + B
         C = 3.0*C
         DZ(J) = A + DT*(B + C*DT)
         DDZ(J) = B + (C + C)*DT
   51 CONTINUE
      RETURN
      END
      SUBROUTINE CURV1 (N,X,Y,SLP1,SLPN,ISLPSW,YP,TEMP,
     *                  SIGMA,IERR)
C
      INTEGER N,ISLPSW,IERR
      REAL X(N),Y(N),SLP1,SLPN,YP(N),TEMP(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
C COMPUTE AN INTERPOLATORY SPLINE UNDER TENSION THROUGH
C A SEQUENCE OF FUNCTIONAL VALUES. THE SLOPES AT THE TWO
C ENDS OF THE CURVE MAY BE SPECIFIED OR OMITTED.  FOR ACTUAL
C COMPUTATION OF POINTS ON THE CURVE IT IS NECESSARY TO CALL
C THE FUNCTION CURV2.
C
C ON INPUT--
C
C   N IS THE NUMBER OF VALUES TO BE INTERPOLATED (N.GE.2).
C
C   X IS AN ARRAY OF THE N INCREASING ABSCISSAE OF THE
C   FUNCTIONAL VALUES.
C
C   Y IS AN ARRAY OF THE N ORDINATES OF THE VALUES, (I. E.
C   Y(K) IS THE FUNCTIONAL VALUE CORRESPONDING TO X(K) ).
C
C   SLP1 AND SLPN CONTAIN THE DESIRED VALUES FOR THE FIRST
C   DERIVATIVE OF THE CURVE AT X(1) AND X(N), RESPECTIVELY.
C   THE USER MAY OMIT VALUES FOR EITHER OR BOTH OF THESE
C   PARAMETERS AND SIGNAL THIS WITH ISLPSW.
C
C   ISLPSW CONTAINS A SWITCH INDICATING WHICH SLOPE DATA
C   SHOULD BE USED AND WHICH SHOULD BE ESTIMATED BY THIS
C   SUBROUTINE,
C          = 0 IF SLP1 AND SLPN ARE TO BE USED,
C          = 1 IF SLP1 IS TO BE USED BUT NOT SLPN,
C          = 2 IF SLPN IS TO BE USED BUT NOT SLP1,
C          = 3 IF BOTH SLP1 AND SLPN ARE TO BE ESTIMATED
C              INTERNALLY.
C
C   YP IS AN ARRAY OF LENGTH AT LEAST N.
C
C   TEMP IS AN ARRAY OF LENGTH AT LEAST N WHICH IS USED FOR
C   SCRATCH STORAGE.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
C   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
C   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A
C   CUBIC SPLINE. IF ABS(SIGMA) IS LARGE (E.G. 50.) THE
C   RESULTING CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA
C   EQUALS ZERO A CUBIC SPLINE RESULTS.  A STANDARD VALUE
C   FOR SIGMA IS APPROXIMATELY 1. IN ABSOLUTE VALUE.
C
C ON OUTPUT--
C
C   YP CONTAINS THE VALUES OF THE SECOND DERIVATIVE OF THE
C   CURVE AT THE GIVEN NODES.
C
C   IERR CONTAINS AN ERROR FLAG,
C        = 0 FOR NORMAL RETURN,
C        = 1 IF N IS LESS THAN 2,
C        = 2 IF X-VALUES ARE NOT STRICTLY INCREASING.
C
C AND
C
C   N, X, Y, SLP1, SLPN, ISLPSW AND SIGMA ARE UNALTERED.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
C AND SNHCSH.
C
C-----------------------------------------------------------
C
      NM1 = N-1
      NP1 = N+1
      IERR = 0
      IF (N .LE. 1) GO TO 8
      IF (X(N) .LE. X(1)) GO TO 9
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/(X(N)-X(1))
C
C APPROXIMATE END SLOPES
C
      IF (ISLPSW .GE. 2) GO TO 1
      SLPP1 = SLP1
      GO TO 2
    1 DELX1 = X(2)-X(1)
      DELX2 = DELX1+DELX1
      IF (N .GT. 2) DELX2 = X(3)-X(1)
      IF (DELX1 .LE. 0. .OR. DELX2 .LE. DELX1) GO TO 9
      CALL CEEZ (DELX1,DELX2,SIGMAP,C1,C2,C3,N)
      SLPP1 = C1*Y(1)+C2*Y(2)
      IF (N .GT. 2) SLPP1 = SLPP1+C3*Y(3)
    2 IF (ISLPSW .EQ. 1 .OR. ISLPSW .EQ. 3) GO TO 3
      SLPPN = SLPN
      GO TO 4
    3 DELXN = X(N)-X(NM1)
      DELXNM = DELXN+DELXN
      IF (N .GT. 2) DELXNM = X(N)-X(N-2)
      IF (DELXN .LE. 0. .OR. DELXNM .LE. DELXN) GO TO 9
      CALL CEEZ (-DELXN,-DELXNM,SIGMAP,C1,C2,C3,N)
      SLPPN = C1*Y(N)+C2*Y(NM1)
      IF (N .GT. 2) SLPPN = SLPPN+C3*Y(N-2)
C
C SET UP RIGHT HAND SIDE AND TRIDIAGONAL SYSTEM FOR YP AND
C PERFORM FORWARD ELIMINATION
C
    4 DELX1 = X(2)-X(1)
      IF (DELX1 .LE. 0.) GO TO 9
      DX1 = (Y(2)-Y(1))/DELX1
      CALL TERMS (DIAG1,SDIAG1,SIGMAP,DELX1)
      YP(1) = (DX1-SLPP1)/DIAG1
      TEMP(1) = SDIAG1/DIAG1
      IF (N .EQ. 2) GO TO 6
      DO 5 I = 2,NM1
        DELX2 = X(I+1)-X(I)
        IF (DELX2 .LE. 0.) GO TO 9
        DX2 = (Y(I+1)-Y(I))/DELX2
        CALL TERMS (DIAG2,SDIAG2,SIGMAP,DELX2)
        DIAG = DIAG1+DIAG2-SDIAG1*TEMP(I-1)
        YP(I) = (DX2-DX1-SDIAG1*YP(I-1))/DIAG
        TEMP(I) = SDIAG2/DIAG
        DX1 = DX2
        DIAG1 = DIAG2
    5   SDIAG1 = SDIAG2
    6 DIAG = DIAG1-SDIAG1*TEMP(NM1)
      YP(N) = (SLPPN-DX1-SDIAG1*YP(NM1))/DIAG
C
C PERFORM BACK SUBSTITUTION
C
      DO 7 I = 2,N
        IBAK = NP1-I
    7   YP(IBAK) = YP(IBAK)-TEMP(IBAK)*YP(IBAK+1)
      RETURN
C
C TOO FEW POINTS
C
    8 IERR = 1
      RETURN
C
C X-VALUES NOT STRICTLY INCREASING
C
    9 IERR = 2
      RETURN
      END
      FUNCTION CURV2 (T,N,X,Y,YP,SIGMA)
C
      INTEGER N
      REAL T,X(N),Y(N),YP(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS FUNCTION INTERPOLATES A CURVE AT A GIVEN POINT
C USING A SPLINE UNDER TENSION. THE SUBROUTINE CURV1 SHOULD
C BE CALLED EARLIER TO DETERMINE CERTAIN NECESSARY
C PARAMETERS.
C
C ON INPUT--
C
C   T CONTAINS A REAL VALUE TO BE MAPPED ONTO THE INTERPO-
C   LATING CURVE.
C
C   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED TO
C   DETERMINE THE CURVE.
C
C   X AND Y ARE ARRAYS CONTAINING THE ABSCISSAE AND
C   ORDINATES, RESPECTIVELY, OF THE SPECIFIED POINTS.
C
C   YP IS AN ARRAY OF SECOND DERIVATIVE VALUES OF THE CURVE
C   AT THE NODES.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS N, X, Y, YP, AND SIGMA SHOULD BE INPUT
C UNALTERED FROM THE OUTPUT OF CURV1.
C
C ON OUTPUT--
C
C   CURV2 CONTAINS THE INTERPOLATED VALUE.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
C SNHCSH.
C
C-----------------------------------------------------------
C
C DETERMINE INTERVAL
C
      IM1 = INTRVL(T,X,N)
      I = IM1+1
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/(X(N)-X(1))
C
C SET UP AND PERFORM INTERPOLATION
C
      DEL1 = T-X(IM1)
      DEL2 = X(I)-T
      DELS = X(I)-X(IM1)
      SUM = (Y(I)*DEL1+Y(IM1)*DEL2)/DELS
      IF (SIGMAP .NE. 0.) GO TO 1
      CURV2 = SUM-DEL1*DEL2*(YP(I)*(DEL1+DELS)+YP(IM1)*
     *        (DEL2+DELS))/(6.*DELS)
      RETURN
    1 DELP1 = SIGMAP*(DEL1+DELS)/2.
      DELP2 = SIGMAP*(DEL2+DELS)/2.
      CALL SNHCSH (SINHM1,DUMMY,SIGMAP*DEL1,-1)
      CALL SNHCSH (SINHM2,DUMMY,SIGMAP*DEL2,-1)
      CALL SNHCSH (SINHMS,DUMMY,SIGMAP*DELS,-1)
      CALL SNHCSH (SINHP1,DUMMY,SIGMAP*DEL1/2.,-1)
      CALL SNHCSH (SINHP2,DUMMY,SIGMAP*DEL2/2.,-1)
      CALL SNHCSH (DUMMY,COSHP1,DELP1,1)
      CALL SNHCSH (DUMMY,COSHP2,DELP2,1)
      CURV2 = SUM+(YP(I)*(SINHM1*DEL2-DEL1*(2.*(COSHP1+1.)*
     *        SINHP2+SIGMAP*COSHP1*DEL2))+YP(IM1)*(SINHM2*
     *        DEL1-DEL2*(2.*(COSHP2+1.)*SINHP1+SIGMAP*
     *        COSHP2*DEL1)))/(SIGMAP*SIGMAP*DELS*(SINHMS+
     *        SIGMAP*DELS))
      RETURN
      END
      FUNCTION CURVD (T,N,X,Y,YP,SIGMA)
C
      INTEGER N
      REAL T,X(N),Y(N),YP(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS FUNCTION DIFFERENTIATES A CURVE AT A GIVEN POINT
C USING A SPLINE UNDER TENSION. THE SUBROUTINE CURV1 SHOULD
C BE CALLED EARLIER TO DETERMINE CERTAIN NECESSARY
C PARAMETERS.
C
C ON INPUT--
C
C   T CONTAINS A REAL VALUE AT WHICH THE DERIVATIVE IS TO BE
C   DETERMINED.
C
C   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED TO
C   DETERMINE THE CURVE.
C
C   X AND Y ARE ARRAYS CONTAINING THE ABSCISSAE AND
C   ORDINATES, RESPECTIVELY, OF THE SPECIFIED POINTS.
C
C   YP IS AN ARRAY OF SECOND DERIVATIVE VALUES OF THE CURVE
C   AT THE NODES.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS N, X, Y, YP, AND SIGMA SHOULD BE INPUT
C UNALTERED FROM THE OUTPUT OF CURV1.
C
C ON OUTPUT--
C
C   CURVD CONTAINS THE DERIVATIVE VALUE.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
C SNHCSH.
C
C-----------------------------------------------------------
C
C DETERMINE INTERVAL
C
      IM1 = INTRVL(T,X,N)
      I = IM1+1
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/(X(N)-X(1))
C
C SET UP AND PERFORM DIFFERENTIATION
C
      DEL1 = T-X(IM1)
      DEL2 = X(I)-T
      DELS = X(I)-X(IM1)
      SUM = (Y(I)-Y(IM1))/DELS
      IF (SIGMAP .NE. 0.) GO TO 1
      CURVD = SUM+(YP(I)*(2.*DEL1*DEL1-DEL2*(DEL1+DELS))-
     *             YP(IM1)*(2.*DEL2*DEL2-DEL1*(DEL2+DELS)))
     *             /(6.*DELS)
      RETURN
    1 CALL SNHCSH (DUMMY,COSHM1,SIGMAP*DEL1,1)
      CALL SNHCSH (DUMMY,COSHM2,SIGMAP*DEL2,1)
      CALL SNHCSH (SINHMS,DUMMY,SIGMAP*DELS,-1)
      CURVD = SUM+(YP(I)*(DELS*SIGMAP*COSHM1-SINHMS)-
     *        YP(IM1)*(DELS*SIGMAP*COSHM2-SINHMS))/
     *        (SIGMAP*SIGMAP*DELS*(SINHMS+SIGMAP*DELS))
      RETURN
      END
      FUNCTION CURVI (XL,XU,N,X,Y,YP,SIGMA)
C
      INTEGER N
      REAL XL,XU,X(N),Y(N),YP(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS FUNCTION INTEGRATES A CURVE SPECIFIED BY A SPLINE
C UNDER TENSION BETWEEN TWO GIVEN LIMITS. THE SUBROUTINE
C CURV1 SHOULD BE CALLED EARLIER TO DETERMINE NECESSARY
C PARAMETERS.
C
C ON INPUT--
C
C   XL AND XU CONTAIN THE LOWER AND UPPER LIMITS OF INTE-
C   GRATION, RESPECTIVELY. (XL NEED NOT BE LESS THAN OR
C   EQUAL TO XU, CURVI (XL,XU,...) .EQ. -CURVI (XU,XL,...) ).
C
C   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED TO
C   DETERMINE THE CURVE.
C
C   X AND Y ARE ARRAYS CONTAINING THE ABSCISSAE AND
C   ORDINATES, RESPECTIVELY, OF THE SPECIFIED POINTS.
C
C   YP IS AN ARRAY OF SECOND DERIVATIVE VALUES OF THE CURVE
C   AT THE NODES.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS N, X, Y, YP, AND SIGMA SHOULD BE INPUT
C UNALTERED FROM THE OUTPUT OF CURV1.
C
C ON OUTPUT--
C
C   CURVI CONTAINS THE INTEGRAL VALUE.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
C SNHCSH.
C
C-----------------------------------------------------------
C
C STATEMENT FUNCTION FOR COEFFICIENT ASSOCIATED WITH
C DERIVATIVE TERMS
C
      TERM (CMM1,CMM2,T) = (CMM1-CMM2-SIGMAP*T*SS)/(SIGMAP*
     *                     SIGMAP*SIGMAP*(SS+SIGMAP*DELS))
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/(X(N)-X(1))
C
C DETERMINE ACTUAL UPPER AND LOWER BOUNDS
C
      XXL = XL
      XXU = XU
      SSIGN = 1.
      IF (XL .LT. XU) GO TO 1
      XXL = XU
      XXU = XL
      SSIGN = -1.
      IF (XL .GT. XU) GO TO 1
C
C RETURN ZERO IF XL .EQ. XU
C
      CURVI = 0.
      RETURN
C
C SEARCH FOR PROPER INTERVALS
C
    1 ILM1 = INTRVL (XXL,X,N)
      IL = ILM1+1
      IUM1 = INTRVL (XXU,X,N)
      IU = IUM1+1
      IF (IL .EQ. IU) GO TO 8
C
C INTEGRATE FROM XXL TO X(IL)
C
      SUM = 0.
      IF (XXL .EQ. X(IL)) GO TO 3
      DEL1 = XXL-X(ILM1)
      DEL2 = X(IL)-XXL
      DELS = X(IL)-X(ILM1)
      T1 = (DEL1+DELS)*DEL2/(2.*DELS)
      T2 = DEL2*DEL2/(2.*DELS)
      SUM = T1*Y(IL)+T2*Y(ILM1)
      IF (SIGMA .EQ. 0.) GO TO 2
      CALL SNHCSH (DUMMY,C1,SIGMAP*DEL1,2)
      CALL SNHCSH (DUMMY,C2,SIGMAP*DEL2,2)
      CALL SNHCSH (SS,CS,SIGMAP*DELS,3)
      SUM = SUM+TERM(CS,C1,T1)*YP(IL)
     *         +TERM(C2,0.,T2)*YP(ILM1)
      GO TO 3
    2 SUM = SUM-T1*T1*DELS*YP(IL)/6.
     *         -T2*(DEL1*(DEL2+DELS)+DELS*DELS)*YP(ILM1)/12.
C
C INTEGRATE OVER INTERIOR INTERVALS
C
    3 IF (IU-IL .EQ. 1) GO TO 6
      ILP1 = IL+1
      DO 5 I = ILP1,IUM1
        DELS = X(I)-X(I-1)
        SUM = SUM+(Y(I)+Y(I-1))*DELS/2.
        IF (SIGMA .EQ. 0.) GO TO 4
        CALL SNHCSH (SS,CS,SIGMAP*DELS,3)
        SUM = SUM+(YP(I)+YP(I-1))*(CS-SS*SIGMAP*DELS/2.)/
     *            (SIGMAP*SIGMAP*SIGMAP*(SS+SIGMAP*DELS))
        GO TO 5
    4   SUM = SUM-(YP(I)+YP(I-1))*DELS*DELS*DELS/24.
    5   CONTINUE
C
C INTEGRATE FROM X(IU-1) TO XXU
C
    6 IF (XXU .EQ. X(IUM1)) GO TO 10
      DEL1 = XXU-X(IUM1)
      DEL2 = X(IU)-XXU
      DELS = X(IU)-X(IUM1)
      T1 = DEL1*DEL1/(2.*DELS)
      T2 = (DEL2+DELS)*DEL1/(2.*DELS)
      SUM = SUM+T1*Y(IU)+T2*Y(IUM1)
      IF (SIGMA .EQ. 0.) GO TO 7
      CALL SNHCSH (DUMMY,C1,SIGMAP*DEL1,2)
      CALL SNHCSH (DUMMY,C2,SIGMAP*DEL2,2)
      CALL SNHCSH (SS,CS,SIGMAP*DELS,3)
      SUM = SUM+TERM(C1,0.,T1)*YP(IU)
     *         +TERM(CS,C2,T2)*YP(IUM1)
      GO TO 10
    7 SUM = SUM-T1*(DEL2*(DEL1+DELS)+DELS*DELS)*YP(IU)/12.
     *         -T2*T2*DELS*YP(IUM1)/6.
      GO TO 10
C
C INTEGRATE FROM XXL TO XXU
C
    8 DELU1 = XXU-X(IUM1)
      DELU2 = X(IU)-XXU
      DELL1 = XXL-X(IUM1)
      DELL2 = X(IU)-XXL
      DELS = X(IU)-X(IUM1)
      DELI = XXU-XXL
      T1 = (DELU1+DELL1)*DELI/(2.*DELS)
      T2 = (DELU2+DELL2)*DELI/(2.*DELS)
      SUM = T1*Y(IU)+T2*Y(IUM1)
      IF (SIGMA .EQ. 0.) GO TO 9
      CALL SNHCSH (DUMMY,CU1,SIGMAP*DELU1,2)
      CALL SNHCSH (DUMMY,CU2,SIGMAP*DELU2,2)
      CALL SNHCSH (DUMMY,CL1,SIGMAP*DELL1,2)
      CALL SNHCSH (DUMMY,CL2,SIGMAP*DELL2,2)
      CALL SNHCSH (SS,DUMMY,SIGMAP*DELS,-1)
      SUM = SUM+TERM(CU1,CL1,T1)*YP(IU)
     *         +TERM(CL2,CU2,T2)*YP(IUM1)
      GO TO 10
    9 SUM = SUM-T1*(DELU2*(DELS+DELU1)+DELL2*(DELS+DELL1))*
     *             YP(IU)/12.
     *         -T2*(DELL1*(DELS+DELL2)+DELU1*(DELS+DELU2))*
     *             YP(IUM1)/12.
C
C CORRECT SIGN AND RETURN
C
   10 CURVI = SSIGN*SUM
      RETURN
      END
      SUBROUTINE KURV1 (N,X,Y,SLP1,SLPN,ISLPSW,XP,YP,TEMP,S,
     *                  SIGMA,IERR)
C
      INTEGER N,ISLPSW,IERR
      REAL X(N),Y(N),SLP1,SLPN,XP(N),YP(N),TEMP(N),S(N),
     *     SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
C COMPUTE A SPLINE UNDER TENSION FORMING A CURVE IN THE
C PLANE AND PASSING THROUGH A SEQUENCE OF PAIRS (X(1),Y(1)),
C ...,(X(N),Y(N)). FOR ACTUAL COMPUTATION OF POINTS ON THE
C CURVE IT IS NECESSARY TO CALL THE SUBROUTINE KURV2.
C
C ON INPUT--
C
C   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
C
C   X IS AN ARRAY CONTAINING THE N X-COORDINATES OF THE
C   POINTS.
C
C   Y IS AN ARRAY CONTAINING THE N Y-COORDINATES OF THE
C   POINTS. (ADJACENT X-Y PAIRS MUST BE DISTINCT, I. E.
C   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1), FOR
C   I = 1,...,N-1.)
C
C   SLP1 AND SLPN CONTAIN THE DESIRED VALUES FOR THE ANGLES
C   (IN RADIANS) OF THE SLOPE AT (X(1),Y(1)) AND (X(N),Y(N))
C   RESPECTIVELY. THE ANGLES ARE MEASURED COUNTER-CLOCK-
C   WISE FROM THE X-AXIS AND THE POSITIVE SENSE OF THE CURVE
C   IS ASSUMED TO BE THAT MOVING FROM POINT 1 TO POINT N.
C   THE USER MAY OMIT VALUES FOR EITHER OR BOTH OF THESE
C   PARAMETERS AND SIGNAL THIS WITH ISLPSW.
C
C   ISLPSW CONTAINS A SWITCH INDICATING WHICH SLOPE DATA
C   SHOULD BE USED AND WHICH SHOULD BE ESTIMATED BY THIS
C   SUBROUTINE,
C          = 0 IF SLP1 AND SLPN ARE TO BE USED,
C          = 1 IF SLP1 IS TO BE USED BUT NOT SLPN,
C          = 2 IF SLPN IS TO BE USED BUT NOT SLP1,
C          = 3 IF BOTH SLP1 AND SLPN ARE TO BE ESTIMATED
C              INTERNALLY.
C
C   XP AND YP ARE ARRAYS OF LENGTH AT LEAST N.
C
C   TEMP IS AN ARRAY OF LENGTH AT LEAST N WHICH IS USED
C   FOR SCRATCH STORAGE.
C
C   S IS AN ARRAY OF LENGTH AT LEAST N.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
C   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
C   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A CUBIC
C   SPLINE. IF ABS(SIGMA) IS LARGE (E. G. 50.) THE RESULTING
C   CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA EQUALS ZERO A
C   CUBIC SPLINE RESULTS. A STANDARD VALUE FOR SIGMA IS
C   APPROXIMATELY 1. IN ABSOLUTE VALUE.
C
C ON OUTPUT--
C
C   XP AND YP CONTAIN INFORMATION ABOUT THE CURVATURE OF THE
C   CURVE AT THE GIVEN NODES.
C
C   S CONTAINS THE POLYGONAL ARCLENGTHS OF THE CURVE.
C
C   IERR CONTAINS AN ERROR FLAG,
C        = 0 FOR NORMAL RETURN,
C        = 1 IF N IS LESS THAN 2,
C        = 2 IF ADJACENT COORDINATE PAIRS COINCIDE.
C
C AND
C
C   N, X, Y, SLP1, SLPN, ISLPSW, AND SIGMA ARE UNALTERED.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
C AND SNHCSH.
C
C-----------------------------------------------------------
C
      NM1 = N-1
      NP1 = N+1
      IERR = 0
      IF (N .LE. 1) GO TO 11
C
C DETERMINE POLYGONAL ARCLENGTHS
C
      S(1) = 0.
      DO 1 I = 2,N
        IM1 = I-1
    1   S(I) = S(IM1)+SQRT((X(I)-X(IM1))**2+
     *         (Y(I)-Y(IM1))**2)
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/S(N)
C
C APPROXIMATE END SLOPES
C
      IF (ISLPSW .GE. 2) GO TO 2
      SLPP1X = COS(SLP1)
      SLPP1Y = SIN(SLP1)
      GO TO 4
    2 DELS1 = S(2)-S(1)
      DELS2 = DELS1+DELS1
      IF (N .GT. 2) DELS2 = S(3)-S(1)
      IF (DELS1 .EQ. 0. .OR. DELS2 .EQ. 0.) GO TO 12
      CALL CEEZ (DELS1,DELS2,SIGMAP,C1,C2,C3,N)
      SX = C1*X(1)+C2*X(2)
      SY = C1*Y(1)+C2*Y(2)
      IF (N .EQ. 2) GO TO 3
      SX = SX+C3*X(3)
      SY = SY+C3*Y(3)
    3 DELT = SQRT(SX*SX+SY*SY)
      SLPP1X = SX/DELT
      SLPP1Y = SY/DELT
    4 IF (ISLPSW .EQ. 1 .OR. ISLPSW .EQ. 3) GO TO 5
      SLPPNX = COS(SLPN)
      SLPPNY = SIN(SLPN)
      GO TO 7
    5 DELSN = S(N)-S(NM1)
      DELSNM = DELSN+DELSN
      IF (N .GT. 2) DELSNM = S(N)-S(N-2)
      IF (DELSN .EQ. 0. .OR. DELSNM .EQ. 0.) GO TO 12
      CALL CEEZ (-DELSN,-DELSNM,SIGMAP,C1,C2,C3,N)
      SX = C1*X(N)+C2*X(NM1)
      SY = C1*Y(N)+C2*Y(NM1)
      IF (N .EQ. 2) GO TO 6
      SX = SX+C3*X(N-2)
      SY = SY+C3*Y(N-2)
    6 DELT = SQRT(SX*SX+SY*SY)
      SLPPNX = SX/DELT
      SLPPNY = SY/DELT
C
C SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR XP AND
C YP AND PERFORM FORWARD ELIMINATION
C
    7 DX1 = (X(2)-X(1))/S(2)
      DY1 = (Y(2)-Y(1))/S(2)
      CALL TERMS (DIAG1,SDIAG1,SIGMAP,S(2))
      XP(1) = (DX1-SLPP1X)/DIAG1
      YP(1) = (DY1-SLPP1Y)/DIAG1
      TEMP(1) = SDIAG1/DIAG1
      IF (N .EQ. 2) GO TO 9
      DO 8 I = 2,NM1
        DELS2 = S(I+1)-S(I)
        IF (DELS2 .EQ. 0.) GO TO 12
        DX2 = (X(I+1)-X(I))/DELS2
        DY2 = (Y(I+1)-Y(I))/DELS2
        CALL TERMS (DIAG2,SDIAG2,SIGMAP,DELS2)
        DIAG = DIAG1+DIAG2-SDIAG1*TEMP(I-1)
        DIAGIN = 1./DIAG
        XP(I) = (DX2-DX1-SDIAG1*XP(I-1))*DIAGIN
        YP(I) = (DY2-DY1-SDIAG1*YP(I-1))*DIAGIN
        TEMP(I) = SDIAG2*DIAGIN
        DX1 = DX2
        DY1 = DY2
        DIAG1 = DIAG2
    8   SDIAG1 = SDIAG2
    9 DIAG = DIAG1-SDIAG1*TEMP(NM1)
      XP(N) = (SLPPNX-DX1-SDIAG1*XP(NM1))/DIAG
      YP(N) = (SLPPNY-DY1-SDIAG1*YP(NM1))/DIAG
C
C PERFORM BACK SUBSTITUTION
C
      DO 10 I = 2,N
        IBAK = NP1-I
        XP(IBAK) = XP(IBAK)-TEMP(IBAK)*XP(IBAK+1)
   10   YP(IBAK) = YP(IBAK)-TEMP(IBAK)*YP(IBAK+1)
      RETURN
C
C TOO FEW POINTS
C
   11 IERR = 1
      RETURN
C
C COINCIDENT ADJACENT POINTS
C
   12 IERR = 2
      RETURN
      END
      SUBROUTINE KURV2 (T,XS,YS,N,X,Y,XP,YP,S,SIGMA)
C
      INTEGER N
      REAL T,XS,YS,X(N),Y(N),XP(N),YP(N),S(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE PERFORMS THE MAPPING OF POINTS IN THE
C INTERVAL (0.,1.) ONTO A CURVE IN THE PLANE. THE SUBROUTINE
C KURV1 SHOULD BE CALLED EARLIER TO DETERMINE CERTAIN
C NECESSARY PARAMETERS. THE RESULTING CURVE HAS A PARAMETRIC
C REPRESENTATION BOTH OF WHOSE COMPONENTS ARE SPLINES UNDER
C TENSION AND FUNCTIONS OF THE POLYGONAL ARCLENGTH
C PARAMETER.
C
C ON INPUT--
C
C   T CONTAINS A REAL VALUE TO BE MAPPED TO A POINT ON THE
C   CURVE. THE INTERVAL (0.,1.) IS MAPPED ONTO THE ENTIRE
C   CURVE, WITH 0. MAPPING TO (X(1),Y(1)) AND 1. MAPPING
C   TO (X(N),Y(N)). VALUES OUTSIDE THIS INTERVAL RESULT IN
C   EXTRAPOLATION.
C
C   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED
C   TO DETERMINE THE CURVE.
C
C   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-COORDINATES
C   OF THE SPECIFIED POINTS.
C
C   XP AND YP ARE THE ARRAYS OUTPUT FROM KURV1 CONTAINING
C   CURVATURE INFORMATION.
C
C   S IS AN ARRAY CONTAINING THE POLYGONAL ARCLENGTHS OF
C   THE CURVE.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS N, X, Y, XP, YP, S, AND SIGMA SHOULD BE
C INPUT UNALTERED FROM THE OUTPUT OF KURV1.
C
C ON OUTPUT--
C
C   XS AND YS CONTAIN THE X- AND Y-COORDINATES OF THE IMAGE
C   POINT ON THE CURVE.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
C SNHCSH.
C
C-----------------------------------------------------------
C
C DETERMINE INTERVAL
C
      TN = S(N)*T
      IM1 = INTRVL(TN,S,N)
      I = IM1+1
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/S(N)
C
C SET UP AND PERFORM INTERPOLATION
C
      DEL1 = TN-S(IM1)
      DEL2 = S(I)-TN
      DELS = S(I)-S(IM1)
      SUMX = (X(I)*DEL1+X(IM1)*DEL2)/DELS
      SUMY = (Y(I)*DEL1+Y(IM1)*DEL2)/DELS
      IF (SIGMAP .NE. 0.) GO TO 1
      D = DEL1*DEL2/(6.*DELS)
      C1 = (DEL1+DELS)*D
      C2 = (DEL2+DELS)*D
      XS = SUMX-XP(I)*C1-XP(IM1)*C2
      YS = SUMY-YP(I)*C1-YP(IM1)*C2
      RETURN
    1 DELP1 = SIGMAP*(DEL1+DELS)/2.
      DELP2 = SIGMAP*(DEL2+DELS)/2.
      CALL SNHCSH(SINHM1,DUMMY,SIGMAP*DEL1,-1)
      CALL SNHCSH(SINHM2,DUMMY,SIGMAP*DEL2,-1)
      CALL SNHCSH(SINHMS,DUMMY,SIGMAP*DELS,-1)
      CALL SNHCSH (SINHP1,DUMMY,SIGMAP*DEL1/2.,-1)
      CALL SNHCSH (SINHP2,DUMMY,SIGMAP*DEL2/2.,-1)
      CALL SNHCSH (DUMMY,COSHP1,DELP1,1)
      CALL SNHCSH (DUMMY,COSHP2,DELP2,1)
      D = SIGMAP*SIGMAP*DELS*(SINHMS+SIGMAP*DELS)
      C1 = (SINHM1*DEL2-DEL1*(2.*(COSHP1+1.)*SINHP2+SIGMAP*
     *     COSHP1*DEL2))/D
      C2 = (SINHM2*DEL1-DEL2*(2.*(COSHP2+1.)*SINHP1+SIGMAP*
     *     COSHP2*DEL1))/D
      XS = SUMX+XP(I)*C1+XP(IM1)*C2
      YS = SUMY+YP(I)*C1+YP(IM1)*C2
      RETURN
      END
      SUBROUTINE KURVP1 (N,X,Y,XP,YP,TEMP,S,SIGMA,IERR)
C
      INTEGER N,IERR
      REAL X(N),Y(N),XP(N),YP(N),TEMP(*),S(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
C COMPUTE A SPLINE UNDER TENSION FORMING A CLOSED CURVE IN
C THE PLANE AND PASSING THROUGH A SEQUENCE OF PAIRS
C (X(1),Y(1)),...,(X(N),Y(N)). FOR ACTUAL COMPUTATION OF
C POINTS ON THE CURVE IT IS NECESSARY TO CALL THE SUBROUTINE
C KURVP2.
C
C ON INPUT--
C
C   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
C
C   X IS AN ARRAY CONTAINING THE N X-COORDINATES OF THE
C   POINTS.
C
C   Y IS AN ARRAY CONTAINING THE N Y-COORDINATES OF THE
C   POINTS. (ADJACENT X-Y PAIRS MUST BE DISTINCT, I. E.
C   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1), FOR
C   I = 1,...,N-1.)
C
C   XP AND YP ARE ARRAYS OF LENGTH AT LEAST N.
C
C   TEMP IS AN ARRAY OF LENGTH AT LEAST 2*N WHICH IS USED
C   FOR SCRATCH STORAGE.
C
C   S IS AN ARRAY OF LENGTH AT LEAST N.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
C   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
C   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A CUBIC
C   SPLINE. IF ABS(SIGMA) IS LARGE (E. G. 50.) THE RESULTING
C   CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA EQUALS ZERO A
C   CUBIC SPLINE RESULTS. A STANDARD VALUE FOR SIGMA IS
C   APPROXIMATELY 1. IN ABSOLUTE VALUE.
C
C ON OUTPUT--
C
C   XP AND YP CONTAIN INFORMATION ABOUT THE CURVATURE OF THE
C   CURVE AT THE GIVEN NODES.
C
C   S CONTAINS THE POLYGONAL ARCLENGTHS OF THE CURVE.
C
C   IERR CONTAINS AN ERROR FLAG,
C        = 0 FOR NORMAL RETURN,
C        = 1 IF N IS LESS THAN 2,
C        = 2 IF ADJACENT COORDINATE PAIRS COINCIDE.
C
C AND
C
C   N, X, Y, AND SIGMA ARE UNALTERED,
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES TERMS AND
C SNHCSH.
C
C-----------------------------------------------------------
C
      NM1 = N-1
      NP1 = N+1
      IERR = 0
      IF (N .LE. 1) GO TO 7
C
C DETERMINE POLYGONAL ARCLENGTHS
C
      S(1) = SQRT((X(N)-X(1))**2+(Y(N)-Y(1))**2)
      DO 1 I = 2,N
        IM1 = I-1
    1   S(I) = S(IM1)+SQRT((X(I)-X(IM1))**2+
     *         (Y(I)-Y(IM1))**2)
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N)/S(N)
C
C SET UP RIGHT HAND SIDES OF TRIDIAGONAL (WITH CORNER
C ELEMENTS) LINEAR SYSTEM FOR XP AND YP
C
      DELS1 = S(1)
      IF (DELS1 .EQ. 0.) GO TO 8
      DX1 = (X(1)-X(N))/DELS1
      DY1 = (Y(1)-Y(N))/DELS1
      CALL TERMS(DIAG1,SDIAG1,SIGMAP,DELS1)
      DELS2 = S(2)-S(1)
      IF (DELS2 .EQ. 0.) GO TO 8
      DX2 = (X(2)-X(1))/DELS2
      DY2 = (Y(2)-Y(1))/DELS2
      CALL TERMS(DIAG2,SDIAG2,SIGMAP,DELS2)
      DIAG = DIAG1+DIAG2
      DIAGIN = 1./DIAG
      XP(1) = (DX2-DX1)*DIAGIN
      YP(1) = (DY2-DY1)*DIAGIN
      TEMP(NP1) = -SDIAG1*DIAGIN
      TEMP(1) = SDIAG2*DIAGIN
      DX1 = DX2
      DY1 = DY2
      DIAG1 = DIAG2
      SDIAG1 = SDIAG2
      IF (N .EQ. 2) GO TO 3
      DO 2 I = 2,NM1
        NPI = N+I
        DELS2 = S(I+1)-S(I)
        IF (DELS2 .EQ. 0.) GO TO 8
        DX2 = (X(I+1)-X(I))/DELS2
        DY2 = (Y(I+1)-Y(I))/DELS2
        CALL TERMS(DIAG2,SDIAG2,SIGMAP,DELS2)
        DIAG = DIAG1+DIAG2-SDIAG1*TEMP(I-1)
        DIAGIN = 1./DIAG
        XP(I) = (DX2-DX1-SDIAG1*XP(I-1))*DIAGIN
        YP(I) = (DY2-DY1-SDIAG1*YP(I-1))*DIAGIN
        TEMP(NPI) = -TEMP(NPI-1)*SDIAG1*DIAGIN
        TEMP(I) = SDIAG2*DIAGIN
        DX1 = DX2
        DY1 = DY2
        DIAG1 = DIAG2
    2   SDIAG1 = SDIAG2
    3 DELS2 = S(1)
      DX2 = (X(1)-X(N))/DELS2
      DY2 = (Y(1)-Y(N))/DELS2
      CALL TERMS(DIAG2,SDIAG2,SIGMAP,DELS2)
      XP(N) = DX2-DX1
      YP(N) = DY2-DY1
      TEMP(NM1) = TEMP(2*N-1)-TEMP(NM1)
      IF (N.EQ.2) GO TO 5
C
C PERFORM FIRST STEP OF BACK SUBSTITUTION
C
      DO 4 I = 3,N
        IBAK = NP1-I
        NPIBAK = N+IBAK
        XP(IBAK) = XP(IBAK)-TEMP(IBAK)*XP(IBAK+1)
        YP(IBAK) = YP(IBAK)-TEMP(IBAK)*YP(IBAK+1)
    4   TEMP(IBAK) = TEMP(NPIBAK)-TEMP(IBAK)*TEMP(IBAK+1)
    5 XP(N) = (XP(N)-SDIAG2*XP(1)-SDIAG1*XP(NM1))/
     *        (DIAG1+DIAG2+SDIAG2*TEMP(1)+SDIAG1*TEMP(NM1))
      YP(N) = (YP(N)-SDIAG2*YP(1)-SDIAG1*YP(NM1))/
     *        (DIAG1+DIAG2+SDIAG2*TEMP(1)+SDIAG1*TEMP(NM1))
C
C PERFORM SECOND STEP OF BACK SUBSTITUTION
C
      XPN = XP(N)
      YPN = YP(N)
      DO 6 I = 1,NM1
        XP(I) = XP(I)+TEMP(I)*XPN
    6   YP(I) = YP(I)+TEMP(I)*YPN
      RETURN
C
C TOO FEW POINTS
C
    7 IERR = 1
      RETURN
C
C COINCIDENT ADJACENT POINTS
C
    8 IERR = 2
      RETURN
      END
      SUBROUTINE KURVP2 (T,XS,YS,N,X,Y,XP,YP,S,SIGMA)
C
      INTEGER N
      REAL T,XS,YS,X(N),Y(N),XP(N),YP(N),S(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE PERFORMS THE MAPPING OF POINTS IN THE
C INTERVAL (0.,1.) ONTO A CLOSED CURVE IN THE PLANE. THE
C SUBROUTINE KURVP1 SHOULD BE CALLED EARLIER TO DETERMINE
C CERTAIN NECESSARY PARAMETERS. THE RESULTING CURVE HAS A
C PARAMETRIC REPRESENTATION BOTH OF WHOSE COMPONENTS ARE
C PERIODIC SPLINES UNDER TENSION AND FUNCTIONS OF THE POLY-
C GONAL ARCLENGTH PARAMETER.
C
C ON INPUT--
C
C   T CONTAINS A VALUE TO BE MAPPED ONTO THE CURVE. THE
C   INTERVAL (0.,1.) IS MAPPED ONTO THE ENTIRE CLOSED CURVE
C   WITH BOTH 0. AND 1. MAPPING TO (X(1),Y(1)). THE MAPPING
C   IS PERIODIC WITH PERIOD ONE THUS ANY INTERVAL OF THE
C   FORM (TT,TT+1.) MAPS ONTO THE ENTIRE CURVE.
C
C   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED
C   TO DETERMINE THE CURVE.
C
C   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-COORDINATES
C   OF THE SPECIFIED POINTS.
C
C   XP AND YP ARE THE ARRAYS OUTPUT FROM KURVP1 CONTAINING
C   CURVATURE INFORMATION.
C
C   S IS AN ARRAY CONTAINING THE POLYGONAL ARCLENGTHS OF
C   THE CURVE.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS N, X, Y, XP, YP, S AND SIGMA SHOULD
C BE INPUT UNALTERED FROM THE OUTPUT OF KURVP1.
C
C ON OUTPUT--
C
C   XS AND YS CONTAIN THE X- AND Y-COORDINATES OF THE IMAGE
C   POINT ON THE CURVE.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
C SNHCSH.
C
C-----------------------------------------------------------
C
C DETERMINE INTERVAL
C
      TN = T-FLOAT(IFIX(T))
      IF (TN .LT. 0.) TN = TN+1.
      TN = S(N)*TN+S(1)
      IM1 = N
      IF (TN .LT. S(N)) IM1 = INTRVL(TN,S,N)
      I = IM1+1
      IF (I .GT. N) I = 1
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N)/S(N)
C
C SET UP AND PERFORM INTERPOLATION
C
      SI = S(I)
      IF (IM1 .EQ. N) SI = S(N)+S(1)
      DEL1 = TN-S(IM1)
      DEL2 = SI-TN
      DELS = SI-S(IM1)
      SUMX = (X(I)*DEL1+X(IM1)*DEL2)/DELS
      SUMY = (Y(I)*DEL1+Y(IM1)*DEL2)/DELS
      IF (SIGMAP .NE. 0.) GO TO 1
      D = DEL1*DEL2/(6.*DELS)
      C1 = (DEL1+DELS)*D
      C2 = (DEL2+DELS)*D
      XS = SUMX-XP(I)*C1-XP(IM1)*C2
      YS = SUMY-YP(I)*C1-YP(IM1)*C2
      RETURN
    1 DELP1 = SIGMAP*(DEL1+DELS)/2.
      DELP2 = SIGMAP*(DEL2+DELS)/2.
      CALL SNHCSH(SINHM1,DUMMY,SIGMAP*DEL1,-1)
      CALL SNHCSH(SINHM2,DUMMY,SIGMAP*DEL2,-1)
      CALL SNHCSH(SINHMS,DUMMY,SIGMAP*DELS,-1)
      CALL SNHCSH (SINHP1,DUMMY,SIGMAP*DEL1/2.,-1)
      CALL SNHCSH (SINHP2,DUMMY,SIGMAP*DEL2/2.,-1)
      CALL SNHCSH (DUMMY,COSHP1,DELP1,1)
      CALL SNHCSH (DUMMY,COSHP2,DELP2,1)
      D = SIGMAP*SIGMAP*DELS*(SINHMS+SIGMAP*DELS)
      CI = (SINHM1*DEL2-DEL1*(2.*(COSHP1+1.)*SINHP2+SIGMAP*
     *     COSHP1*DEL2))/D
      CIM1 = (SINHM2*DEL1-DEL2*(2.*(COSHP2+1.)*SINHP1+
     *       SIGMAP*COSHP2*DEL1))/D
      XS = SUMX+CI*XP(I)+CIM1*XP(IM1)
      YS = SUMY+CI*YP(I)+CIM1*YP(IM1)
      RETURN
      END
      SUBROUTINE QURV1 (N,X,Y,Z,SLP1X,SLP1Y,SLP1Z,SLPNX,
     *                  SLPNY,SLPNZ,ISLPSW,XP,YP,ZP,TEMP,
     *                  S,SIGMA,IERR)
C
      INTEGER N,ISLPSW,IERR
      REAL X(N),Y(N),Z(N),SLP1X,SLP1Y,SLP1Z,SLPNX,SLPNY,
     *     SLPNZ,XP(N),YP(N),ZP(N),TEMP(N),S(N),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
C COMPUTE A SPLINE UNDER TENSION PASSING THROUGH A SEQUENCE
C OF TRIPLES (X(1),Y(1),Z(1)),...,(X(N),Y(N),Z(N)). THE
C SLOPES AT THE TWO ENDS OF THE CURVE MAY BE SPECIFIED OR
C OMITTED. FOR ACTUAL COMPUTATION OF POINTS ON THE CURVE
C IT IS NECESSARY TO CALL THE SUBROUTINE QURV2.
C
C ON INPUT--
C
C   N IS THE NUMBER OF POINTS TO BE INTERPOLATED (N.GE.2).
C
C   X IS AN ARRAY CONTAINING THE N X-COORDINATES OF THE
C   POINTS.
C
C   Y IS AN ARRAY CONTAINING THE N Y-COORDINATES OF THE
C   POINTS.
C
C   Z IS AN ARRAY CONTAINING THE N Z-COORDINATES OF THE
C   POINTS. (ADJACENT X-Y-Z TRIPLES MUST BE DISTINCT, I. E.
C   EITHER X(I) .NE. X(I+1) OR Y(I) .NE. Y(I+1) OR Z(I) .NE.
C   Z(I+1), FOR I = 1,...,N-1 ).
C
C   SLP1X, SLP1Y, SLP1Z AND SLPNX, SLPNY, SLPNZ CONTAIN THE
C   DESIRED VALUES OF THE COMPONENTS OF TANGENT VECTORS TO
C   THE CURVE AT (X(1),Y(1),Z(1)) AND(X(N),Y(N),Z(N)),
C   RESPECTIVELY. THE POSITIVE SENSE OF THE CURVE IS ASSUMED
C   TO BE THAT MOVING FROM POINT 1 TO POINT N. THE USER MAY
C   OMIT VALUES FOR EITHER OR BOTH OF THESE TRIPLES AND
C   SIGNAL THIS WITH ISLPSW.
C
C   ISLPSW CONTAINS A SWITCH INDICATING WHICH SLOPE DATA
C   SHOULD BE USED AND WHICH SHOULD BE ESTIMATED BY THIS
C   SUBROUTINE,
C          = 0 IF SLP1X, SLP1Y, SLP1Z AND SLPNX, SLPNY,
C              SLPNZ ARE TO BE USED,
C          = 1 IF SLP1X, SLP1Y, SLP1Z ARE TO BE USED BUT
C              NOT SLPNX, SLPNY, SLPNZ,
C          = 2 IF SLPNX, SLPNY, SLPNZ ARE TO BE USED BUT
C              NOT SLP1X, SLP1Y, SLP1Z,
C          = 3 IF BOTH END-TANGENTS ARE TO BE ESTIMATED
C              INTERNALLY.
C
C   XP, YP, AND ZP ARE ARRAYS OF LENGTH AT LEAST N.
C
C   TEMP IS AN ARRAY OF LENGTH AT LEAST N WHICH IS USED
C   FOR SCRATCH STORAGE.
C
C   S IS AN ARRAY OF LENGTH AT LEAST N.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
C   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
C   (E.G. .001) THE RESULTING CURVE IS APPROXIMATELY A CUBIC
C   SPLINE. IF ABS(SIGMA) IS LARGE (E. G. 50.) THE RESULTING
C   CURVE IS NEARLY A POLYGONAL LINE. IF SIGMA EQUALS ZERO A
C   CUBIC SPLINE RESULTS. A STANDARD VALUE FOR SIGMA IS
C   APPROXIMATELY 1. IN ABSOLUTE VALUE.
C
C ON OUTPUT--
C
C   XP, YP, AND ZP CONTAIN INFORMATION ABOUT THE CURVATURE
C   OF THE CURVE AT THE GIVEN NODES.
C
C   S CONTAINS THE POLYGONAL ARCLENGTHS OF THE CURVE.
C
C   IERR CONTAINS AN ERROR FLAG,
C        = 0 FOR NORMAL RETURN,
C        = 1 IF N IS LESS THAN 2,
C        = 2 IF ADJACENT TRIPLES COINCIDE.
C
C AND
C
C   N, X, Y, Z, SLP1X, SLP1Y, SLP1Z, SLPNX, SLPNY, SLPNZ,
C   ISLPSW, AND SIGMA ARE UNALTERED,
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
C AND SNHCSH.
C
C-----------------------------------------------------------
C
      NM1 = N-1
      NP1 = N+1
      IERR = 0
      IF (N .LE. 1) GO TO 9
C
C DETERMINE POLYGONAL ARCLENGTHS
C
      S(1) = 0.
      DO 1 I = 2,N
        IM1 = I-1
    1   S(I) = S(IM1)+SQRT((X(I)-X(IM1))**2+(Y(I)-Y(IM1))**2
     *       +(Z(I)-Z(IM1))**2)
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/S(N)
C
C APPROXIMATE END SLOPES
C
      IF (ISLPSW .GE. 2) GO TO 2
      SLPP1X = SLP1X
      SLPP1Y = SLP1Y
      SLPP1Z = SLP1Z
      GO TO 3
    2 DELS1 = S(2)-S(1)
      DELS2 = DELS1+DELS1
      IF (N .GT. 2) DELS2 = S(3)-S(1)
      IF (DELS1 .EQ. 0. .OR. DELS2 .EQ. 0.) GO TO 9
      CALL CEEZ (DELS1,DELS2,SIGMAP,C1,C2,C3,N)
      SLPP1X = C1*X(1)+C2*X(2)
      SLPP1Y = C1*Y(1)+C2*Y(2)
      SLPP1Z = C1*Z(1)+C2*Z(2)
      IF (N .EQ. 2) GO TO 3
      SLPP1X = SLPP1X+C3*X(3)
      SLPP1Y = SLPP1Y+C3*Y(3)
      SLPP1Z = SLPP1Z+C3*Z(3)
    3 DELT = SQRT(SLPP1X*SLPP1X+SLPP1Y*SLPP1Y+SLPP1Z*SLPP1Z)
      SLPP1X = SLPP1X/DELT
      SLPP1Y = SLPP1Y/DELT
      SLPP1Z = SLPP1Z/DELT
      IF (ISLPSW .EQ. 1 .OR. ISLPSW .EQ. 3) GO TO 4
      SLPPNX = SLPNX
      SLPPNY = SLPNY
      SLPPNZ = SLPNZ
      GO TO 5
    4 DELSN = S(N)-S(NM1)
      DELSNM = DELSN+DELSN
      IF (N .GT. 2) DELSNM = S(N)-S(N-2)
      IF (DELSN .EQ. 0. .OR. DELSNM .EQ. 0.) GO TO 10
      CALL CEEZ (-DELSN,-DELSNM,SIGMAP,C1,C2,C3,N)
      SLPPNX = C1*X(N)+C2*X(NM1)
      SLPPNY = C1*Y(N)+C2*Y(NM1)
      SLPPNZ = C1*Z(N)+C2*Z(NM1)
      IF (N .EQ. 2) GO TO 5
      SLPPNX = SLPPNX+C3*X(N-2)
      SLPPNY = SLPPNY+C3*Y(N-2)
      SLPPNZ = SLPPNZ+C3*Z(N-2)
    5 DELT = SQRT(SLPPNX*SLPPNX+SLPPNY*SLPPNY+SLPPNZ*SLPPNZ)
      SLPPNX = SLPPNX/DELT
      SLPPNY = SLPPNY/DELT
      SLPPNZ = SLPPNZ/DELT
C
C SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR XP, YP
C AND ZP AND PERFORM FORWARD ELIMINATION
C
      DX1 = (X(2)-X(1))/S(2)
      DY1 = (Y(2)-Y(1))/S(2)
      DZ1 = (Z(2)-Z(1))/S(2)
      CALL TERMS (DIAG1,SDIAG1,SIGMAP,S(2))
      XP(1) = (DX1-SLPP1X)/DIAG1
      YP(1) = (DY1-SLPP1Y)/DIAG1
      ZP(1) = (DZ1-SLPP1Z)/DIAG1
      TEMP(1) = SDIAG1/DIAG1
      IF (N .EQ. 2) GO TO 7
      DO 6 I = 2,NM1
        DELS2 = S(I+1)-S(I)
        IF (DELS2 .EQ. 0.) GO TO 10
        DX2 = (X(I+1)-X(I))/DELS2
        DY2 = (Y(I+1)-Y(I))/DELS2
        DZ2 = (Z(I+1)-Z(I))/DELS2
        CALL TERMS (DIAG2,SDIAG2,SIGMAP,DELS2)
        DIAG = DIAG1+DIAG2-SDIAG1*TEMP(I-1)
        DIAGIN = 1./DIAG
        XP(I) = (DX2-DX1-SDIAG1*XP(I-1))*DIAGIN
        YP(I) = (DY2-DY1-SDIAG1*YP(I-1))*DIAGIN
        ZP(I) = (DZ2-DZ1-SDIAG1*ZP(I-1))*DIAGIN
        TEMP(I) = SDIAG2*DIAGIN
        DX1 = DX2
        DY1 = DY2
        DZ1 = DZ2
        DIAG1 = DIAG2
    6   SDIAG1 = SDIAG2
    7 DIAG = DIAG1-SDIAG1*TEMP(NM1)
      XP(N) = (SLPPNX-DX1-SDIAG1*XP(NM1))/DIAG
      YP(N) = (SLPPNY-DY1-SDIAG1*YP(NM1))/DIAG
      ZP(N) = (SLPPNZ-DZ1-SDIAG1*ZP(NM1))/DIAG
C
C PERFORM BACK SUBSTITUTION
C
      DO 8 I = 2,N
        IBAK = NP1-I
        T = TEMP(IBAK)
        XP(IBAK) = XP(IBAK)-T*XP(IBAK+1)
        YP(IBAK) = YP(IBAK)-T*YP(IBAK+1)
    8   ZP(IBAK) = ZP(IBAK)-T*ZP(IBAK+1)
      RETURN
C
C TOO FEW POINTS
C
    9 IERR = 1
      RETURN
C
C COINCIDENT ADJACENT POINTS
C
   10 IERR = 2
      RETURN
      END
      SUBROUTINE QURV2 (T,XS,YS,ZS,N,X,Y,Z,XP,YP,ZP,S,SIGMA)
C
      INTEGER N
      REAL T,XS,YS,ZS,X(N),Y(N),Z(N),XP(N),YP(N),ZP(N),S(N)
      REAL SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE PERFORMS THE MAPPING OF POINTS IN THE
C INTERVAL (0.,1.) ONTO A CURVE IN SPACE.  THE SUBROUTINE
C QURV1 SHOULD BE CALLED EARLIER TO DETERMINE CERTAIN
C NECESSARY PARAMETERS. THE RESULTING CURVE HAS A PARAMETRIC
C REPRESENTATION ALL OF WHOSE COMPONENTS ARE SPLINES UNDER
C TENSION AND FUNCTIONS OF THE POLYGONAL ARCLENGTH
C PARAMETER.
C
C ON INPUT--
C
C   T CONTAINS A REAL VALUE TO BE MAPPED TO A POINT ON THE
C   CURVE. THE INTERVAL (0.,1.) IS MAPPED ONTO THE ENTIRE
C   CURVE, WITH 0. MAPPING TO (X(1),Y(1,Z(1)) AND 1. MAPPING
C   TO (X(N),Y(N),Z(N)). VALUES OUTSIDE THIS INTERVAL RESULT
C   IN EXTRAPOLATION.
C
C   N CONTAINS THE NUMBER OF POINTS WHICH WERE SPECIFIED
C   TO DETERMINE THE CURVE.
C
C   X, Y, AND Z ARE ARRAYS CONTAINING THE X-, Y- AND Z-
C   COORDINATES OF THE SPECIFIED POINTS.
C
C   XP, YP, AND ZP ARE THE ARRAYS OUTPUT FROM QURV1
C   CONTAINING CURVATURE INFORMATION.
C
C   S IS AN ARRAY CONTAINING THE POLYGONAL ARCLENGTHS OF
C   THE CURVE.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS N, X, Y, Z, XP, YP, ZP, S, AND SIGMA
C SHOULD BE INPUT UNALTERED FROM THE OUTPUT OF QURV1.
C
C ON OUTPUT--
C
C   XS, YS AND ZS CONTAIN THE X-, Y- AND Z-COORDINATES OF
C   THE IMAGE POINT ON THE CURVE.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES INTRVL AND
C SNHCSH.
C
C-----------------------------------------------------------
C
C DETERMINE INTERVAL
C
      TN = S(N)*T
      IM1 = INTRVL(TN,S,N)
      I = IM1+1
C
C DENORMALIZE TENSION FACTOR
C
      SIGMAP = ABS(SIGMA)*FLOAT(N-1)/S(N)
C
C SET UP AND PERFORM INTERPOLATION
C
      DEL1 = TN-S(IM1)
      DEL2 = S(I)-TN
      DELS = S(I)-S(IM1)
      SUMX = (X(I)*DEL1+X(IM1)*DEL2)/DELS
      SUMY = (Y(I)*DEL1+Y(IM1)*DEL2)/DELS
      SUMZ = (Z(I)*DEL1+Z(IM1)*DEL2)/DELS
      IF (SIGMAP .NE. 0.) GO TO 1
      D = DEL1*DEL2/(6.*DELS)
      C1 = (DEL1+DELS)*D
      C2 = (DEL2+DELS)*D
      XS = SUMX-XP(I)*C1-XP(IM1)*C2
      YS = SUMY-YP(I)*C1-YP(IM1)*C2
      ZS = SUMZ-ZP(I)*C1-ZP(IM1)*C2
      RETURN
    1 DELP1 = SIGMAP*(DEL1+DELS)/2.
      DELP2 = SIGMAP*(DEL2+DELS)/2.
      CALL SNHCSH(SINHM1,DUMMY,SIGMAP*DEL1,-1)
      CALL SNHCSH(SINHM2,DUMMY,SIGMAP*DEL2,-1)
      CALL SNHCSH(SINHMS,DUMMY,SIGMAP*DELS,-1)
      CALL SNHCSH (SINHP1,DUMMY,SIGMAP*DEL1/2.,-1)
      CALL SNHCSH (SINHP2,DUMMY,SIGMAP*DEL2/2.,-1)
      CALL SNHCSH (DUMMY,COSHP1,DELP1,1)
      CALL SNHCSH (DUMMY,COSHP2,DELP2,1)
      D = SIGMAP*SIGMAP*DELS*(SINHMS+SIGMAP*DELS)
      C1 = (SINHM1*DEL2-DEL1*(2.*(COSHP1+1.)*SINHP2+SIGMAP*
     *     COSHP1*DEL2))/D
      C2 = (SINHM2*DEL1-DEL2*(2.*(COSHP2+1.)*SINHP1+SIGMAP*
     *     COSHP2*DEL1))/D
      XS = SUMX+XP(I)*C1+XP(IM1)*C2
      YS = SUMY+YP(I)*C1+YP(IM1)*C2
      ZS = SUMZ+ZP(I)*C1+ZP(IM1)*C2
      RETURN
      END
      SUBROUTINE CEEZ (DEL1,DEL2,SIGMA,C1,C2,C3,N)
C
      REAL DEL1,DEL2,SIGMA,C1,C2,C3
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE DETERMINES THE COEFFICIENTS C1, C2, AND C3
C USED TO DETERMINE ENDPOINT SLOPES. SPECIFICALLY, IF
C FUNCTION VALUES Y1, Y2, AND Y3 ARE GIVEN AT POINTS X1, X2,
C AND X3, RESPECTIVELY, THE QUANTITY C1*Y1 + C2*Y2 + C3*Y3
C IS THE VALUE OF THE DERIVATIVE AT X1 OF A SPLINE UNDER
C TENSION (WITH TENSION FACTOR SIGMA) PASSING THROUGH THE
C THREE POINTS AND HAVING THIRD DERIVATIVE EQUAL TO ZERO AT
C X1. OPTIONALLY, ONLY TWO VALUES, C1 AND C2 ARE DETERMINED.
C
C ON INPUT--
C
C   DEL1 IS X2-X1 (.GT. 0.).
C
C   DEL2 IS X3-X1 (.GT. 0.). IF N .EQ. 2, THIS PARAMETER IS
C   IGNORED.
C
C   SIGMA IS THE TENSION FACTOR.
C
C AND
C
C   N IS A SWITCH INDICATING THE NUMBER OF COEFFICIENTS TO
C   BE RETURNED. IF N .EQ. 2 ONLY TWO COEFFICIENTS ARE
C   RETURNED. OTHERWISE ALL THREE ARE RETURNED.
C
C ON OUTPUT--
C
C   C1, C2, AND C3 CONTAIN THE COEFFICIENTS.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULE SNHCSH.
C
C-----------------------------------------------------------
C
      IF (N .EQ. 2) GO TO 2
      IF (SIGMA .NE. 0.) GO TO 1
      DEL = DEL2-DEL1
C
C TENSION .EQ. 0.
C
      C1 = -(DEL1+DEL2)/(DEL1*DEL2)
      C2 = DEL2/(DEL1*DEL)
      C3 = -DEL1/(DEL2*DEL)
      RETURN
C
C TENSION .NE. 0.
C
    1 CALL SNHCSH (DUMMY,COSHM1,SIGMA*DEL1,1)
      CALL SNHCSH (DUMMY,COSHM2,SIGMA*DEL2,1)
      DELP = SIGMA*(DEL2+DEL1)/2.
      DELM = SIGMA*(DEL2-DEL1)/2.
      CALL SNHCSH (SINHMP,DUMMY,DELP,-1)
      CALL SNHCSH (SINHMM,DUMMY,DELM,-1)
      DENOM = COSHM1*(DEL2-DEL1)-2.*DEL1*(SINHMP+DELP)*
     *        (SINHMM+DELM)
      C1 = 2.*(SINHMP+DELP)*(SINHMM+DELM)/DENOM
      C2 = -COSHM2/DENOM
      C3 = COSHM1/DENOM
      RETURN
C
C TWO COEFFICIENTS
C
    2 C1 = -1./DEL1
      C2 = -C1
      RETURN
      END
      SUBROUTINE TERMS (DIAG,SDIAG,SIGMA,DEL)
C
      REAL DIAG,SDIAG,SIGMA,DEL
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE COMPUTES THE DIAGONAL AND SUPERDIAGONAL
C TERMS OF THE TRIDIAGONAL LINEAR SYSTEM ASSOCIATED WITH
C SPLINE UNDER TENSION INTERPOLATION.
C
C ON INPUT--
C
C   SIGMA CONTAINS THE TENSION FACTOR.
C
C AND
C
C   DEL CONTAINS THE STEP SIZE.
C
C ON OUTPUT--
C
C               (SIGMA*DEL*COSH(SIGMA*DEL) - SINH(SIGMA*DEL)
C   DIAG = DEL*--------------------------------------------.
C                     (SIGMA*DEL)**2 * SINH(SIGMA*DEL)
C
C                   SINH(SIGMA*DEL) - SIGMA*DEL
C   SDIAG = DEL*----------------------------------.
C                (SIGMA*DEL)**2 * SINH(SIGMA*DEL)
C
C AND
C
C   SIGMA AND DEL ARE UNALTERED.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULE SNHCSH.
C
C-----------------------------------------------------------
C
      IF (SIGMA .NE. 0.) GO TO 1
      DIAG = DEL/3.
      SDIAG = DEL/6.
      RETURN
    1 SIGDEL = SIGMA*DEL
      CALL SNHCSH (SINHM,COSHM,SIGDEL,0)
      DENOM = DEL/((SINHM+SIGDEL)*SIGDEL*SIGDEL)
      DIAG = DENOM*(SIGDEL*COSHM-SINHM)
      SDIAG = DENOM*SINHM
      RETURN
      END
      INTEGER FUNCTION INTRVL (X, T, M)
      REAL X, T(M)
C-----------------------------------------------------------------------
C
C             LOCATION OF A VALUE X IN A SEQUENCE T
C
C                       ----------------
C
C     INPUT--
C
C        X IS A REAL NUMBER.
C
C        T IS AN ARRAY OF NONDECREASING VALUES. IT IS
C          ASSUMED THAT T(1) .LT. T(M).
C
C        M IS THE LENGTH OF T (M .GE. 2).
C
C     OUTPUT--
C
C        INTRVL HAS THE VALUE I WHEN  T(I) .LE. X .LT. T(I+1).
C        OTHERWISE, IF L IS THE INTEGER WHERE T(L) .LT. T(L+1)
C        AND T(L+1) = ... = T(M), THEN INTRVL HAS THE VALUE I
C        WHERE
C                  I = 1   IF X .LT. T(1)
C                  I = L   IF X .GE. T(L)
C
C-----------------------------------------------------------------------
      IF (X .LT. T(2)) GO TO 100
      TM = T(M)
      I = M - 1
   10    IF (T(I) .LT. TM) GO TO 20
         I = I - 1
         GO TO 10
   20 IF (X .GE. T(I)) GO TO 110
      IL = 2
      IR = I
C
C     BISECTION SEARCH
C
   30 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 110
      IF (X - T(I)) 40,60,50
   40 IR = I
      GO TO 30
   50 IL = I
      GO TO 30
C
C     CASE WHEN X = T(I) FOR SOME I
C
   60 IF (X .LT. T(I+1)) GO TO 110
      I = I + 1
      GO TO 60
C
C     LEFT END
C
  100 INTRVL = 1
      RETURN
C
C     NORMAL EXIT
C
  110 INTRVL = I
      RETURN
      END
      SUBROUTINE BVAL (T, BCOEF, N, K, X, JDERIV, W, WK)
C-----------------------------------------------------------------------
C
C     BVAL CALCULATES THE VALUE AT X OF THE JDERIV-TH DERIVATIVE
C     OF A SPLINE F FROM ITS B-REPRESENTATION.
C
C******  I N P U T ******
C
C  T     AN ARRAY OF DIMENSION N + K CONTAING THE KNOTS OF THE
C        SPLINE. IT IS ASSUMED THAT T(I) .LE. T(I+1) FOR EACH I.
C  BCOEF AN ARRAY OF DIMENSION N CONTAINING THE B-COEFFICIENTS
C        OF THE SPLINE F.
C  N     LENGTH OF BCOEF (N .GE. 1).
C  K     ORDER OF THE SPLINE.
C  X     THE POINT AT WHICH TO EVALUATE.
C  JDERIV  INTEGER GIVING THE ORDER OF THE DERIVATIVE TO BE
C        EVALUATED. IT IS ASSUMED THAT JDERIV .GE. 0.
C
C******  O U T P U T  ******
C
C  W     THE VALUE OF THE (JDERIV)-TH DERIVATIVE OF F AT X.
C
C******  W O R K  S P A C E ******
C
C  WK    AN ARRAY OF DIMENSION 3*K OR LARGER.
C
C******  M E T H O D  ******
C
C     THE NONTRIVIAL KNOT INTERVAL (T(I),T(I+1)) CONTAINING X IS FIRST
C  OBTAINED. THEN THE  K  B-COEFFICIENTS OF F RELEVANT FOR THIS INTERVAL
C  ARE OBTAINED FROM BCOEF (OR TAKEN TO BE ZERO IF NOT EXPLICITLY AVAIL-
C  ABLE), AND DIFFERENCED JDERIV TIMES TO OBTAIN THE B-COEFFICIENTS OF
C  (D**JDERIV)F  RELEVANT FOR THE INTERVAL. SPECIFICALLY, IF J = JDERIV
C  THEN FROM X.(12) OF THE REFERENCE WE HAVE
C
C     (D**J)F  =  SUM ( BCOEF(.,J)*B(.,K-J,T) )
C
C  WHERE
C                   / BCOEF(.),                     ,  J .EQ. 0
C                   /
C    BCOEF(.,J)  =  / BCOEF(.,J-1) - BCOEF(.-1,J-1)
C                   / ----------------------------- ,  J .GT. 0
C                   /    (T(.+K-J) - T(.))/(K-J)
C
C     THEN, WE USE REPEATEDLY THE FACT THAT
C
C    SUM ( A(.)*B(.,M,T)(X) )  =  SUM ( A(.,X)*B(.,M-1,T)(X) )
C  WITH
C                 (X - T(.))*A(.) + (T(.+M-1) - X)*A(.-1)
C    A(.,X)  =    ---------------------------------------
C                 (X - T(.))      + (T(.+M-1) - X)
C
C  TO WRITE (D**J)F(X) EVENTUALLY AS A LINEAR COMBINATION OF B-SPLINES
C  OF ORDER 1. THE COEFFICIENT FOR B(I,1,T)(X) MUST THEN BE THE DESIRED
C  NUMBER  (D**J)F(X). (SEE X.(17)-(19) OF THE REFERENCE).
C
C-----------------------------------------------------------------------
C  REFERENCE. DE BOOR, CARL, A PRATICAL GUIDE TO SPLINES, SPRINGER-
C  VERLAG, NEW YORK, 1978.
C-----------------------------------------------------------------------
      REAL T(*), BCOEF(N), WK(K,3)
C
      W = 0.0
      IF (JDERIV .GE. K) RETURN
C
C *** FIND I WHERE 1 .LE. I .LT. N+K  AND  T(I) .LE. X .LT. T(I+1).
C     IF NO SUCH I EXISTS, THEN X LIES OUTSIDE THE SUPPORT OF THE
C     SPLINE F AND W = 0.
C
      NPK = N + K
      IF (X .LT. T(1) .OR. X .GT. T(NPK)) RETURN
      I = INTRVL(X, T, NPK)
C
C  *** IF K = 1 (AND JDERIV = 0), W = BCOEF(I).
C
      KM1 = K - 1
      IF (KM1 .GT. 0) GO TO 10
         W = BCOEF(I)
         RETURN
C
C  *** STORE THE K B-SPLINE COEFFICIENTS RELEVANT FOR THE KNOT INTERVAL
C     (T(I),T(I+1)) IN THE FIRST COLUMN OF WK AND COMPUTE WK(J,2) =
C     X - T(I+1-J), WK(J,3) = T(I+J) - X, J=1,...,K-1 . SET ANY OF THE
C     WK(J,1) NOT OBTAINABLE FROM INPUT TO ZERO. SET ANY T.S NOT OBTAIN-
C     ABLE EQUAL TO T(1) OR TO T(N+K) APPROPRIATELY.
C
   10 JCMIN = 1
      IMK = I - K
      IF (IMK .GE. 0) GO TO 40
C
         JCMIN = 1 - IMK
         L = I
         DO 20 J = 1,I
            WK(J,2) = X - T(L)
            L = L - 1
   20    CONTINUE
         DO 30 J = I,KM1
            L = K - J
            WK(L,1) = 0.0
            WK(J,2) = WK(I,2)
   30    CONTINUE
         GO TO 60
C
   40 L = I
      DO 50 J = 1,KM1
         WK(J,2) = X - T(L)
         L = L - 1
   50 CONTINUE
C
   60 JCMAX = K
      NMI = N - I
      IF (NMI .GE. 0) GO TO 100
C
         JCMAX = K + NMI
         DO 70 J = 1,JCMAX
            IPJ = I + J
            WK(J,3) = T(IPJ) - X
   70    CONTINUE
         DO 80 J = JCMAX,KM1
            WK(J+1,1) = 0.0
            WK(J,3) = WK(JCMAX,3)
   80    CONTINUE
         GO TO 120
C
  100 DO 110 J = 1,KM1
         IPJ = I + J
         WK(J,3) = T(IPJ) - X
  110 CONTINUE
C
  120 DO 130 JC = JCMIN,JCMAX
         L = IMK + JC
         WK(JC,1) = BCOEF(L)
  130 CONTINUE
C
C               *** DIFFERENCE THE COEFFICIENTS  JDERIV  TIMES.
C
      IF (JDERIV .EQ. 0) GO TO 170
      DO 160 J = 1,JDERIV
         KMJ = K - J
         FKMJ = KMJ
         L = KMJ
         DO 150 JJ = 1,KMJ
            DL = WK(L,2)
            DR = WK(JJ,3)
            WK(JJ,1) = ((WK(JJ+1,1) - WK(JJ,1))/(DL + DR))*FKMJ
  150       L = L - 1
  160 CONTINUE
C
C  *** COMPUTE VALUE AT X IN (T(I),T(I+1)) OF JDERIV-TH DERIVATIVE,
C     GIVEN ITS RELEVANT B-SPLINE COEFFS IN WK(1,1),...,WK(K-JDERIV,1).
C
  170 IF (JDERIV .EQ. KM1) GO TO 200
      JDRVP1 = JDERIV + 1
      DO 190 J = JDRVP1,KM1
         KMJ = K - J
         L = KMJ
         DO 180 JJ = 1,KMJ
            DL = WK(L,2)
            DR = WK(JJ,3)
            WK(JJ,1) = (WK(JJ+1,1)*DL + WK(JJ,1)*DR)/(DL + DR)
  180       L = L - 1
  190 CONTINUE
C
  200 W = WK(1,1)
      RETURN
      END
      SUBROUTINE BVALI (T, BCOEFF, N, K, X, W, WK)
C-----------------------------------------------------------------------
C           INTEGRAL OF A PIECEWISE POLYNOMIAL FROM T(1) TO X
C                   USING ITS B-SPLINE REPRESENTATION
C-----------------------------------------------------------------------
C     REAL T(N + K), WK(N + 3*(K + 1))
C---------------------------
      REAL T(*), BCOEFF(N), WK(*)
C
      W = 0.0
      IF (X .LE. T(1)) RETURN
      NPK = N + K
      TLAST = T(NPK)
      XVAL = AMIN1(X, TLAST)
C
C     DEFINE THE FIRST NEW KNOT. THE REMAINING NEW KNOTS
C         ARE ASSUMED TO BE THE SAME AS THIS KNOT.
C
      TNEW = 0.1
      IF (TLAST .LT. -0.1) TNEW = 0.9*TLAST
      IF (TLAST .GT.  0.0) TNEW = 1.1*TLAST
C
C     COMPUTE THE FIRST N COEFFICIENTS OF THE ANTIDERIVATIVE
C
      SUM = 0.0
      DO 10 I = 1,N
         IPK = I + K
         SUM = SUM + BCOEFF(I)*(T(IPK) - T(I))
         WK(I) = SUM/K
   10 CONTINUE
C
C     COMPUTE THE ANTIDERIVATIVE
C
      KP1 = K + 1
      NP1 = N + 1
      CALL BVALI0 (T, TNEW, WK(1), N, KP1, XVAL, W, WK(NP1))
      RETURN
      END
      SUBROUTINE BVALI0 (T, TNEW, BCOEF, N, K, X, W, WK)
C-----------------------------------------------------------------------
C
C     BVALI0 CALCULATES THE VALUE AT X OF AN ANTIDERIVATIVE
C     OF A B-SPLINE F FOR T(1) .LE. X .LE. T(N + K - 1).
C
C******  I N P U T ******
C
C  T     AN ARRAY CONTAINING THE FIRST N + K - 1 KNOTS OF THE
C        ANTIDERIVATIVE.
C  TNEW  THE REMAING KNOTS ARE ALL LOCATED AT THIS POINT.
C  BCOEF AN ARRAY CONTAINING THE FIRST N COEFFICIENTS OF THE
C        ANTIDERIVATIVE.
C  N     LENGTH OF BCOEF (N .GE. 1).
C  K     ORDER OF THE ANTIDERIVATIVE.
C  X     THE POINT AT WHICH TO EVALUATE.
C
C******  O U T P U T  ******
C
C  W     THE VALUE OF THE ANTIDERIVATIVE AT X.
C
C******  W O R K  S P A C E ******
C
C  WK    AN ARRAY OF DIMENSION 3*K OR LARGER.
C
C-----------------------------------------------------------------------
C     REMARK. BVALI0 IS AN ADAPTATION BY A.H. MORRIS (NSWC) OF THE
C     SUBROUTINE BVAL.
C-----------------------------------------------------------------------
      REAL T(*), BCOEF(N), WK(K,3)
C
      W = 0.0
      KM1 = K - 1
      M = N + KM1
      I = INTRVL(X, T, M)
C
C  *** STORE THE K B-SPLINE COEFFICIENTS RELEVANT FOR THE KNOT INTERVAL
C     (T(I),T(I+1)) IN THE FIRST COLUMN OF WK AND COMPUTE WK(J,2) =
C     X - T(I+1-J), WK(J,3) = T(I+J) - X, J=1,...,K-1 . SET ANY OF THE
C     WK(J,1) NOT OBTAINABLE FROM INPUT TO ZERO. SET ANY T.S NOT OBTAIN-
C     ABLE EQUAL TO T(1) OR TNEW APPROPRIATELY.
C
      JCMIN = 1
      IMK = I - K
      IF (IMK .GE. 0) GO TO 30
C
         JCMIN = 1 - IMK
         L = I
         DO 10 J = 1,I
            WK(J,2) = X - T(L)
            L = L - 1
   10    CONTINUE
         DO 20 J = I,KM1
            L = K - J
            WK(L,1) = 0.0
            WK(J,2) = WK(I,2)
   20    CONTINUE
         GO TO 50
C
   30 L = I
      DO 40 J = 1,KM1
         WK(J,2) = X - T(L)
         L = L - 1
   40 CONTINUE
C
   50 DO 60 J = 1,KM1
         TIPJ = TNEW
         IPJ = I + J
         IF (IPJ .LE. M) TIPJ = T(IPJ)
         WK(J,3) = TIPJ - X
   60 CONTINUE
C
      DO 70 JC = JCMIN,K
         L = MIN0(IMK + JC, N)
         WK(JC,1) = BCOEF(L)
   70 CONTINUE
C
C  *** COMPUTE VALUE AT X IN (T(I),T(I+1)), GIVEN ITS RELEVANT
C     B-SPLINE COEFFS IN WK(1,1),...,WK(K,1).
C
      DO 110 J = 1,KM1
         KMJ = K - J
         L = KMJ
         DO 100 JJ = 1,KMJ
            DL = WK(L,2)
            DR = WK(JJ,3)
            WK(JJ,1) = (WK(JJ+1,1)*DL + WK(JJ,1)*DR)/(DL + DR)
  100       L = L - 1
  110 CONTINUE
C
      W = WK(1,1)
      RETURN
      END
      SUBROUTINE BSPP (T, A, N, K, BREAK, C, L, WK)
C-----------------------------------------------------------------------
C
C              CONVERSION FROM B-SPLINE REPRESENTATION
C              TO PIECEWISE POLYNOMIAL REPRESENTATION
C
C
C     INPUT ...
C
C       T     KNOT SEQUENCE OF LENGTH N+K
C       A     B-SPLINE COEFFICIENT SEQUENCE OF LENGTH N
C       N     LENGTH OF A
C       K     ORDER OF THE B-SPLINES
C
C     OUTPUT ...
C
C       BREAK BREAKPOINT SEQUENCE, OF LENGTH L+1, CONTAINING
C             (IN INCREASING ORDER) THE DISTINCT POINTS OF THE
C             SEQUENCE T(K),...,T(N+1).
C       C     KXL MATRIX WHERE C(I,J) = (I-1)ST RIGHT DERIVATIVE
C             OF THE PP AT BREAK(J) DIVIDED BY FACTORIAL(I-1).
C       L     NUMBER OF POLYNOMIALS WHICH FORM THE PP
C
C     WORK AREA ...
C
C       WK    2-DIMENSIONAL ARRAY OF DIMENSION (K,K+1)
C
C-----------------------------------------------------------------------
      REAL T(*), A(N), BREAK(*), C(K,*), WK(K,*)
C
      L = 0
      BREAK(1) = T(K)
      IF (K .EQ. 1) GO TO 100
      KM1 = K - 1
      KP1 = K + 1
C
C          GENERAL K-TH ORDER CASE
C
      DO 60 LEFT = K,N
         IF (T(LEFT) .EQ. T(LEFT + 1)) GO TO 60
         L = L + 1
         BREAK(L + 1) = T(LEFT + 1)
         DO 10 J = 1,K
            JJ = LEFT - K + J
            WK(J,1) = A(JJ)
   10    CONTINUE
C
         DO 21 J = 1,KM1
            JP1 = J + 1
            KMJ = K - J
            DO 20 I = 1,KMJ
               IL = I + LEFT
               ILKJ = IL - KMJ
               DIFF = T(IL) - T(ILKJ)
               WK(I,JP1) = (WK(I+1,J) - WK(I,J))/DIFF
   20       CONTINUE
   21    CONTINUE
C
         WK(1,KP1) = 1.0
         X = T(LEFT)
         C(K,L) = WK(1,K)
         R = 1.0
         DO 50 J = 1,KM1
            JP1 = J + 1
            S = 0.0
            DO 30 I = 1,J
               IL = I + LEFT
               ILJ = IL - J
               TERM = WK(I,KP1)/(T(IL) - T(ILJ))
               WK(I,KP1) = S + (T(IL) - X)*TERM
               S = (X - T(ILJ))*TERM
   30       CONTINUE
            WK(JP1,KP1) = S
C
            S = 0.0
            KMJ = K - J
            DO 40 I = 1,JP1
               S = S + WK(I,KMJ)*WK(I,KP1)
   40       CONTINUE
            R = (R*FLOAT(KMJ))/FLOAT(J)
            C(KMJ,L) = R*S
   50    CONTINUE
   60 CONTINUE
      RETURN
C
C          PIECEWISE CONSTANT CASE
C
  100 DO 110 LEFT = K,N
         IF (T(LEFT) .EQ. T(LEFT + 1)) GO TO 110
         L = L + 1
         BREAK(L + 1) = T(LEFT + 1)
         C(1,L) = A(LEFT)
  110 CONTINUE
      RETURN
      END
      SUBROUTINE PPVAL (X, A, L, N, XI, YI, NI)
C-----------------------------------------------------------------------
C
C         THIS ROUTINE EVALUATES A PIECEWISE POLYNOMIAL AT THE
C         ABSCISSAS IN XI. IT IS ASSUMED THAT THE COEFFICIENTS
C         OF THE POLYNOMIALS WHICH FORM THE PP ARE GIVEN.
C
C       --INPUT--
C
C         X   - ARRAY OF THE FIRST N ABSCISSAS (IN INCREASING ORDER)
C               THAT DEFINE THE PP.
C         A   - MATRIX THAT CONTAINS THE COEFFICIENTS OF THE POLY-
C               NOMIALS  WHICH FORM THE PP. IF I = 1,...,N THEN THE
C               PP HAS THE VALUE
C                    A(1,I) + A(2,I)*DX + ... + A(L,I)*DX**(L-1)
C               FOR X(I) .LE. XX .LT. X(I+1).  HERE DX = XX - X(I).
C         L   - ORDER OF THE PIECEWISE POLYNOMIAL.
C         N   - THE NUMBER OF POLYNOMIALS THAT DEFINE THE PP.
C               N MUST BE GREATER THAN OR EQUAL TO 1.
C         XI  - THE ARRAY OF ABSCISSAS (IN ARBITRARY ORDER) AT WHICH
C               AT WHICH THE PP IS TO BE EVALUATED.
C         NI  - THE DIMENSION OF THE ARRAYS XI AND YI. IT IS ASSUMED
C               THAT NI IS GREATER THAN OR EQUAL TO 1.
C
C       --OUTPUT--
C
C         YI  - ARRAY OF VALUES OF THE PP AT THE POINTS IN XI.
C
C-----------------------------------------------------------------------
      DIMENSION X(N), A(L,N), XI(NI), YI(NI)
C
C     K IS INDEX ON VALUE OF XI BEING WORKED ON.  XX IS THAT VALUE.
C     I IS THE CURRENT INDEX IN THE X ARRAY.
C
      K  = 1
      XX = XI(1)
      LM1 = L - 1
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(N)) GO TO 80
      IL = 1
      IR = N
C
C     BISECTION SEARCH
C
   10 I = (IL + IR)/2
      IF (I .EQ. IL) GO TO 100
      IF (XX - X(I)) 20,100,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     LINEAR FORWARD SEARCH
C
   40 IF (XX .LT. X(I+1)) GO TO 100
      I = I + 1
      GO TO 40
C
C     XX IS GREATER THAN X(N) OR LESS THAN X(1)
C
   80 I = N
      GO TO 100
   90 I = 1
C
C     EVALUATION
C
  100 DX = XX - X(I)
      S = A(L,I)
      IF (L .EQ. 1) GO TO 120
      DO 110 J = 1,LM1
         LMJ = L - J
         S = A(LMJ,I) + DX*S
  110 CONTINUE
  120 YI(K) = S
C
C     NEXT POINT
C
      IF (K .GE. NI) RETURN
      K = K + 1
      XX = XI(K)
      IF (XX .LT. X(1)) GO TO 90
      IF (XX .GE. X(N)) GO TO 80
      IF (XX - XI(K-1)) 130,120,40
  130 IL = 1
      IR = MIN0(I + 1, N)
      GO TO 10
      END
      SUBROUTINE BSPVB (T, K, JHIGH, J, X, LEFT, BLIST)
C-----------------------------------------------------------------------
C
C     BSPVB CALCULATES THE VALUE OF ALL POSSIBLY NONZERO B-SPLINES
C     AT X OF ORDER MAX(JHIGH,J + 1) WHERE T(K) .LE. X .LT. T(N+1).
C
C     DESCRIPTION OF ARGUMENTS
C
C         INPUT
C
C          T       - KNOT VECTOR OF LENGTH N + K.
C          K       - HIGHEST POSSIBLE ORDER OF THE B-SPLINES.
C          JHIGH   - ORDER OF B-SPLINES (1 .LE. JHIGH .LE. K).
C          J       - J .LE. 0  GIVES B-SPLINES OF ORDER JHIGH.
C                    J .GE. 1  ON A PREVIOUS CALL TO BSPVB THE
C                              B-SPLINES OF ORDER J WERE COM-
C                              PUTED AND STORED IN BLIST. IT IS
C                              ASSUMED THAT WORK HAS NOT BEEN
C                              MODIFIED AND THAT J .LT. K.
C          X       - ARGUMENT OF THE B-SPLINES.
C          LEFT    - LARGEST INTEGER SUCH THAT
C                    T(LEFT) .LE. X .LT. T(LEFT+1)
C
C         OUTPUT
C
C          BLIST   - VECTOR OF LENGTH K FOR SPLINE VALUES.
C          J       - B-SPLINES OF ORDER J HAVE BEEN COMPUTED
C                    AND STORED IN BLIST.
C
C-----------------------------------------------------------------------
C     WRITTEN BY CARL DE BOOR (UNIVERSITY OF WISCONSIN) AND MODIFIED
C         BY A.H. MORRIS (NSWC).
C-----------------------------------------------------------------------
      REAL T(*), BLIST(K)
C
      IF (J .GT. 0) GO TO 10
         J = 1
         BLIST(1) = 1.0
         IF (J .GE. JHIGH) RETURN
C
   10 S = 0.0
      DO 20 L = 1,J
         I = LEFT + L
         IMJ = I - J
         TIMJ = T(IMJ)
         TI = T(I)
         TERM = BLIST(L)/(TI - TIMJ)
         BLIST(L) = S + (TI - X)*TERM
         S = (X - TIMJ)*TERM
   20 CONTINUE
      J = J + 1
      BLIST(J) = S
      IF (J .LT. JHIGH) GO TO 10
C
      RETURN
      END
      SUBROUTINE BSPVD (T, K, X, LEFT, DBIATX, IDIM, NDERIV, A)
C-----------------------------------------------------------------------
C
C CALCULATES VALUE AND DERIV.S OF ALL B-SPLINES WHICH DO NOT VANISH AT X
C
C******  I N P U T  ******
C
C  T     THE KNOT ARRAY, OF LENGTH LEFT+K (AT LEAST)
C  K     THE ORDER OF THE B-SPLINES TO BE EVALUATED
C  X     THE POINT AT WHICH THESE VALUES ARE SOUGHT
C  LEFT  AN INTEGER INDICATING THE LEFT ENDPOINT OF THE INTERVAL OF
C        INTEREST. THE  K  B-SPLINES WHOSE SUPPORT CONTAINS THE INTERVAL
C               (T(LEFT), T(LEFT+1))
C        ARE TO BE CONSIDERED.
C  A S S U M P T I O N  - - -  IT IS ASSUMED THAT
C               T(LEFT) .LT. T(LEFT+1)
C        DIVISION BY ZERO WILL RESULT OTHERWISE (IN  B S P V B ).
C        ALSO, THE OUTPUT IS AS ADVERTISED ONLY IF
C               T(LEFT) .LE. X .LE. T(LEFT+1) .
C  IDIM  THE ROW DIMENSION OF THE MATRIX DBIATX. IF IS ASSUMED THAT
C        IDIM .GE. K .
C  NDERIV  AN INTEGER INDICATING THAT VALUES OF B-SPLINES AND THEIR
C        DERIVATIVES UP TO BUT NOT INCLUDING THE  NDERIV-TH  ARE ASKED
C        FOR. (NDERIV IS REPLACED INTERNALLY BY THE INTEGER  M H I G H
C        IN (1,K) CLOSEST TO IT.)
C
C******  O U T P U T  ******
C
C  DBIATX  AN ARRAY OF ORDER (IDIM,NDERIV). ITS ENTRY (I,M) CONTAINS
C        VALUE OF  (M-1)ST  DERIVATIVE OF  (LEFT-K+I)-TH  B-SPLINE OF
C        ORDER  K  FOR KNOT SEQUENCE  T , I=M,...,K, M=1,...,NDERIV.
C
C******  W O R K   A R E A  ******
C
C  A     AN ARRAY OF ORDER (K,K), TO CONTAIN B-COEFF.S OF THE DERIVA-
C        TIVES OF A CERTAIN ORDER OF THE  K  B-SPLINES OF INTEREST.
C
C******  M E T H O D  ******
C
C  VALUES AT  X  OF ALL THE RELEVANT B-SPLINES OF ORDER K,K-1,...,
C  K+1-NDERIV  ARE GENERATED VIA BSPVB AND STORED TEMPORARILY IN
C  DBIATX. THEN THE B-COEFFS OF THE REQUIRED DERIVATIVES OF THE B-
C  SPLINES OF INTEREST ARE GENERATED BY DIFFERENCING, EACH FROM THE PRE-
C  CEDING ONE OF LOWER ORDER, AND COMBINED WITH THE VALUES OF B-SPLINES
C  OF CORRESPONDING ORDER IN  DBIATX  TO PRODUCE THE DESIRED VALUES .
C
C-----------------------------------------------------------------------
C  WRITTEN BY CARL DE BOOR (UNIVERSITY OF WISCONSIN) AND MODIFIED
C     BY A.H. MORRIS (NSWC).
C-----------------------------------------------------------------------
      REAL T(*), DBIATX(IDIM,NDERIV), A(K,K)
C
      MHIGH = MAX0(MIN0(NDERIV,K),1)
C     MHIGH IS USUALLY EQUAL TO NDERIV.
      KP1 = K + 1
      JJ = 0
      CALL BSPVB (T, K, KP1 - MHIGH, JJ, X, LEFT, DBIATX)
      IF (MHIGH .EQ. 1) RETURN
C
C     THE FIRST COLUMN OF DBIATX ALWAYS CONTAINS THE B-SPLINE VALUES
C     FOR THE CURRENT ORDER. THESE ARE STORED IN COLUMN K+1-CURRENT
C     ORDER  BEFORE  BSPVB  IS CALLED TO PUT VALUES FOR THE NEXT
C     HIGHER ORDER ON TOP OF IT.
C
      IDERIV = MHIGH
      DO 15 M = 2,MHIGH
         JP1MID = 1
         DO 10 J = IDERIV,K
            DBIATX(J,IDERIV) = DBIATX(JP1MID,1)
   10       JP1MID = JP1MID + 1
         IDERIV = IDERIV - 1
         CALL BSPVB (T, K, KP1 - IDERIV, JJ, X, LEFT, DBIATX)
   15 CONTINUE
C
C     AT THIS POINT, B(LEFT-K+I, K+1-J)(X) IS IN DBIATX(I,J) FOR
C     I = J,...,K AND J = 1,...,MHIGH. IN PARTICULAR, THE FIRST
C     COLUMN OF DBIATX IS ALREADY IN FINAL FORM. TO OBTAIN COR-
C     RESPONDING DERIVATIVES OF B-SPLINES IN SUBSEQUENT COLUMNS,
C     GENERATE THEIR B-REPR. BY DIFFERENCING. THEN EVALUATE AT X.
C
      JLOW = 1
      DO 20 I = 1,K
         DO 19 J = JLOW,K
   19       A(J,I) = 0.0
         JLOW = I
   20    A(I,I) = 1.0
C
C     AT THIS POINT, A(.,J) CONTAINS THE B-COEFFS FOR THE J-TH OF THE
C     K  B-SPLINES OF INTEREST HERE.
C
      DO 50 M = 2,MHIGH
         KP1MM = KP1 - M
         FKP1MM = FLOAT(KP1MM)
         IL = LEFT
         I = K
C
C        FOR J = 1,...,K, CONSTRUCT B-COEFFS OF (M-1)ST  DERIVATIVE OF
C        B-SPLINES FROM THOSE FOR PRECEDING DERIVATIVE BY DIFFERENCING
C        AND STORE AGAIN IN  A(.,J) . THE FACT THAT  A(I,J) = 0  FOR
C        I .LT. J  IS USED.
C
         DO 30 LDUMMY = 1,KP1MM
            L = IL + KP1MM
            FACTOR = FKP1MM/(T(L) - T(IL))
C
C           THE ASSUMPTION THAT T(LEFT).LT.T(LEFT+1) MAKES DENOMINATOR
C           IN THE FACTOR NONZERO.
C
            DO 25 J = 1,I
   25          A(I,J) = (A(I,J) - A(I-1,J))*FACTOR
            IL = IL - 1
            I = I - 1
   30    CONTINUE
C
C        FOR I = 1,...,K, COMBINE B-COEFFS A(.,I) WITH B-SPLINE VALUES
C        STORED IN DBIATX(.,M) TO GET VALUE OF  (M-1)ST  DERIVATIVE OF
C        I-TH B-SPLINE (OF INTEREST HERE) AT X, AND STORE IN
C        DBIATX(I,M). STORAGE OF THIS VALUE OVER THE VALUE OF A B-SPLINE
C        OF ORDER M THERE IS SAFE SINCE THE REMAINING B-SPLINE DERIVAT-
C        IVES OF THE SAME ORDER DO NOT USE THIS VALUE DUE TO THE FACT
C        THAT  A(J,I) = 0  FOR J .LT. I .
C
         DO 40 I = 1,K
            SUM = 0.0
            JLOW = MAX0(I,M)
            DO 35 J=JLOW,K
   35          SUM = A(J,I)*DBIATX(J,M) + SUM
            DBIATX(I,M) = SUM
   40    CONTINUE
   50 CONTINUE
      RETURN
      END
      SUBROUTINE BSTRP (TAU, GTAU, T, N, K, BCOEF, Q, IFLAG)
C-----------------------------------------------------------------------
C   THIS ROUTINE PRODUCES THE B-SPLINE COEFF.S BCOEF OF THE PIECEWISE
C   POLYNOMIAL OF ORDER K WITH KNOTS T(I) (I=1,...,N+K) WHICH HAS THE
C   VALUE GTAU(I) AT TAU(I) FOR I=1,...,N.
C
C******  I N P U T  ******
C
C  TAU.....ARRAY OF LENGTH  N , CONTAINING DATA POINT ABSCISSAE.
C    A S S U M P T I O N . . .  TAU  IS STRICTLY INCREASING
C  GTAU.....CORRESPONDING ARRAY OF LENGTH  N , CONTAINING DATA POINT
C        ORDINATES.
C  T.....KNOT SEQUENCE, OF LENGTH  N+K
C  N.....NUMBER OF DATA POINTS AND DIMENSION OF SPLINE SPACE  S(K,T)
C  K.....ORDER OF THE PIECEWISE POLYNOMIAL
C  IFLAG.....ON AN INITIAL CALL TO THE ROUTINE, IFLAG MAY BE ASSIGNED
C        ANY VALUE EXCEPT 0. THE ROUTINE MAY BE RECALLED WHEN ONLY GTAU
C        IS MODIFIED. IFLAG=0 WHEN THIS IS DONE.
C
C******  O U T P U T  ******
C
C  BCOEF.....THE B-COEFFICIENTS OF THE INTERPOLANT, OF LENGTH  N
C  Q.....ARRAY OF SIZE  (2*K-1)*N , CONTAINING THE TRIANGULAR FACTORIZ-
C        ATION OF THE COEFFICIENT MATRIX OF THE LINEAR SYSTEM FOR THE B-
C        COEFFICIENTS OF THE SPLINE INTERPOLANT.
C  IFLAG.....AN INTEGER INDICATING SUCCESS (= 0)  OR FAILURE (= 1)
C        THE LINEAR SYSTEM TO BE SOLVED IS (THEORETICALLY) INVERTIBLE IF
C        AND ONLY IF
C              B(I)(TAU(I)) .NE. 0   FOR ALL I.
C        VIOLATION OF THIS CONDITION IS CERTAIN TO LEAD TO IFLAG = 1.
C
C******  M E T H O D  ******
C
C     THE I-TH EQUATION OF THE LINEAR SYSTEM  A*BCOEF = B  FOR THE B-CO-
C  EFFS OF THE INTERPOLANT ENFORCES INTERPOLATION AT  TAU(I), I=1,...,N.
C  HENCE,  B(I) = GTAU(I), ALL I, AND  A  IS A BAND MATRIX WITH  2K-1
C  BANDS (IF IT IS INVERTIBLE).
C     THE MATRIX  A  IS GENERATED ROW BY ROW AND STORED, DIAGONAL BY DI-
C  AGONAL, IN THE  R O W S  OF THE ARRAY  Q , WITH THE MAIN DIAGONAL GO-
C  ING INTO ROW  K .  SEE COMMENTS IN THE PROGRAM BELOW.
C     THE BANDED SYSTEM IS THEN SOLVED BY A CALL TO BANFAC (WHICH CON-
C  STRUCTS THE TRIANGULAR FACTORIZATION FOR  A  AND STORES IT IN  Q),
C  FOLLOWED BY A CALL TO BANSLV (WHICH THEN OBTAINS THE SOLUTION BCOEF
C  BY SUBSTITUTION).
C     BANFAC PERFORMS NO PIVOTING SINCE THE TOTAL POSITIVITY OF THE
C  MATRIX A MAKES THIS UNNECESSARY.
C-----------------------------------------------------------------------
      REAL BCOEF(N), GTAU(N), Q(*), T(*), TAU(N)
C
      KM1 = K - 1
      IF (IFLAG .EQ. 0) GO TO 60
      NP1 = N + 1
      KPKM2 = 2*KM1
      IF (N .EQ. 1) GO TO 20
C
C        CHECK IF TAU(I) IS AN INCREASING SEQUENCE
C
      DO 10 I = 2,N
         IF (TAU(I) .LE. TAU(I-1)) GO TO 100
   10 CONTINUE
C
C                ZERO OUT ALL ENTRIES OF Q
C
   20 IF (TAU(N) .GT. T(NP1)) GO TO 100
      LENQ = N*(K + KM1)
      DO 21 I = 1,LENQ
         Q(I) = 0.0
   21 CONTINUE
C
C  ***   LOOP OVER I TO CONSTRUCT THE N INTERPOLATION EQUATIONS
C
      LEFT = K
      DO 51 I = 1,N
         TAUI = TAU(I)
         ILP1MX = MIN0(I + K,NP1)
C
C        *** FIND  LEFT  IN THE CLOSED INTERVAL (I,I+K-1) SUCH THAT
C                T(LEFT) .LE. TAU(I) .LT. T(LEFT+1)
C        MATRIX IS SINGULAR IF THIS IS NOT POSSIBLE
C
         LEFT = MAX0(LEFT,I)
         IF (TAUI .LT. T(LEFT)) GO TO 100
   30       IF (TAUI .LT. T(LEFT+1)) GO TO 40
            LEFT = LEFT + 1
            IF (LEFT .LT. ILP1MX) GO TO 30
         IF (LEFT .EQ. I + K) GO TO 100
         LEFT = N
C
C        *** THE I-TH EQUATION ENFORCES INTERPOLATION AT TAUI, HENCE
C        A(I,J) = B(J,K,T)(TAUI), ALL J. ONLY THE  K  ENTRIES WITH  J =
C        LEFT-K+1,...,LEFT ACTUALLY MIGHT BE NONZERO. THESE  K  NUMBERS
C        ARE RETURNED, IN  BCOEF (USED FOR TEMP.STORAGE HERE), BY THE
C        FOLLOWING
C
   40    JJ = 0
         CALL BSPVB (T, K, K, JJ, TAUI, LEFT, BCOEF)
C
C        LET Q DENOTE A TWO-DIMENSIONAL ARRAY OF DIMENSION (2*K-1,N).
C        WE THEREFORE WANT  BCOEF(J) = B(LEFT-K+J)(TAUI) TO GO INTO
C        A(I,LEFT-K+J), I.E., INTO  Q(I-(LEFT+J)+2*K,(LEFT+J)-K) SINCE
C        A(I+J,J)  IS TO GO INTO  Q(I+K,J), ALL I,J.  IN THE CURRENT
C        ROUTINE WE TREAT Q AS AN EQUIVALENT ONE-DIMENSIONAL ARRAY.
C        THUS WE WANT BCOEF(J) TO BE INSERTED INTO ENTRY
C            I - (LEFT+J) + 2*K + ((LEFT+J) - K-1)*(2*K-1)
C                   =  I-LEFT+1 + (LEFT - K)*(2*K-1) + (2*K-2)*J
C        OF  Q .
C
         JJ = I - LEFT + 1 + (LEFT - K)*(K + KM1)
         DO 50 J = 1,K
            JJ = JJ + KPKM2
            Q(JJ) = BCOEF(J)
   50    CONTINUE
   51 CONTINUE
C
C     ***OBTAIN FACTORIZATION OF  A  , STORED AGAIN IN  Q.
C
      CALL BANFAC (Q, K + KM1, N, KM1, KM1, IFLAG)
      IFLAG = IFLAG - 1
      IF (IFLAG .NE. 0) RETURN
C
C     *** SOLVE  A*BCOEF = GTAU  BY BACKSUBSTITUTION
C
   60 DO 61 I = 1,N
         BCOEF(I) = GTAU(I)
   61 CONTINUE
      CALL BANSLV (Q, K + KM1, N, KM1, KM1, BCOEF)
      RETURN
C
C     *** ERROR RETURN
C
  100 IFLAG = 1
      RETURN
      END
      SUBROUTINE BANFAC ( W, NROWW, NROW, NBANDL, NBANDU, IFLAG )
C  FROM  * A PRACTICAL GUIDE TO SPLINES *  BY C. DE BOOR
C  RETURNS IN  W  THE LU-FACTORIZATION (WITHOUT PIVOTING) OF THE BANDED
C  MATRIX  A  OF ORDER  NROW  WITH  (NBANDL + 1 + NBANDU) BANDS OR DIAG-
C  ONALS IN THE WORK ARRAY  W .
C
C******  I N P U T  ******
C  W.....WORK ARRAY OF SIZE  (NROWW,NROW)  CONTAINING THE INTERESTING
C        PART OF A BANDED MATRIX  A , WITH THE DIAGONALS OR BANDS OF  A
C        STORED IN THE ROWS OF  W , WHILE COLUMNS OF  A  CORRESPOND TO
C        COLUMNS OF  W . THIS IS THE STORAGE MODE USED IN  LINPACK  AND
C        RESULTS IN EFFICIENT INNERMOST LOOPS.
C           EXPLICITLY,  A  HAS  NBANDL  BANDS BELOW THE DIAGONAL
C                            +     1     (MAIN) DIAGONAL
C                            +   NBANDU  BANDS ABOVE THE DIAGONAL
C        AND THUS, WITH    MIDDLE = NBANDU + 1,
C          A(I+J,J)  IS IN  W(I+MIDDLE,J)  FOR I=-NBANDU,...,NBANDL
C                                              J=1,...,NROW .
C        FOR EXAMPLE, THE INTERESTING ENTRIES OF A (1,2)-BANDED MATRIX
C        OF ORDER  9  WOULD APPEAR IN THE FIRST  1+1+2 = 4  ROWS OF  W
C        AS FOLLOWS.
C                          13 24 35 46 57 68 79
C                       12 23 34 45 56 67 78 89
C                    11 22 33 44 55 66 77 88 99
C                    21 32 43 54 65 76 87 98
C
C        ALL OTHER ENTRIES OF  W  NOT IDENTIFIED IN THIS WAY WITH AN EN-
C        TRY OF  A  ARE NEVER REFERENCED .
C  NROWW.....ROW DIMENSION OF THE WORK ARRAY  W .
C        MUST BE  .GE.  NBANDL + 1 + NBANDU  .
C  NBANDL.....NUMBER OF BANDS OF  A  BELOW THE MAIN DIAGONAL
C  NBANDU.....NUMBER OF BANDS OF  A  ABOVE THE MAIN DIAGONAL .
C
C******  O U T P U T  ******
C  IFLAG.....INTEGER INDICATING SUCCESS( = 1) OR FAILURE ( = 2) .
C     IF  IFLAG = 1, THEN
C  W.....CONTAINS THE LU-FACTORIZATION OF  A  INTO A UNIT LOWER TRIANGU-
C        LAR MATRIX  L  AND AN UPPER TRIANGULAR MATRIX  U (BOTH BANDED)
C        AND STORED IN CUSTOMARY FASHION OVER THE CORRESPONDING ENTRIES
C        OF  A . THIS MAKES IT POSSIBLE TO SOLVE ANY PARTICULAR LINEAR
C        SYSTEM  A*X = B  FOR  X  BY A
C              CALL BANSLV ( W, NROWW, NROW, NBANDL, NBANDU, B )
C        WITH THE SOLUTION X  CONTAINED IN  B  ON RETURN .
C     IF  IFLAG = 2, THEN
C        ONE OF  NROW-1, NBANDL,NBANDU FAILED TO BE NONNEGATIVE, OR ELSE
C        ONE OF THE POTENTIAL PIVOTS WAS FOUND TO BE ZERO INDICATING
C        THAT  A  DOES NOT HAVE AN LU-FACTORIZATION. THIS IMPLIES THAT
C        A  IS SINGULAR IN CASE IT IS TOTALLY POSITIVE .
C
C******  M E T H O D  ******
C     GAUSS ELIMINATION  W I T H O U T  PIVOTING IS USED. THE ROUTINE IS
C  INTENDED FOR USE WITH MATRICES  A  WHICH DO NOT REQUIRE ROW INTER-
C  CHANGES DURING FACTORIZATION, ESPECIALLY FOR THE  T O T A L L Y
C  P O S I T I V E  MATRICES WHICH OCCUR IN SPLINE CALCULATIONS.
C     THE ROUTINE SHOULD NOT BE USED FOR AN ARBITRARY BANDED MATRIX.
C
      REAL W(NROWW,NROW),   FACTOR,PIVOT
C
      IFLAG = 1
      MIDDLE = NBANDU + 1
C                         W(MIDDLE,.) CONTAINS THE MAIN DIAGONAL OF  A .
      NROWM1 = NROW - 1
      IF (NROWM1)                       999,900,1
    1 IF (NBANDL .GT. 0)                GO TO 10
C                A IS UPPER TRIANGULAR. CHECK THAT DIAGONAL IS NONZERO .
      DO 5 I=1,NROWM1
         IF (W(MIDDLE,I) .EQ. 0.)       GO TO 999
    5    CONTINUE
                                        GO TO 900
   10 IF (NBANDU .GT. 0)                GO TO 20
C              A IS LOWER TRIANGULAR. CHECK THAT DIAGONAL IS NONZERO AND
C                 DIVIDE EACH COLUMN BY ITS DIAGONAL .
      DO 15 I=1,NROWM1
         PIVOT = W(MIDDLE,I)
         IF(PIVOT .EQ. 0.)              GO TO 999
         JMAX = MIN0(NBANDL, NROW - I)
         JBEG = MIDDLE + 1
         JEND = MIDDLE + JMAX
         DO 15 J=JBEG,JEND
   15       W(J,I) = W(J,I)/PIVOT
                                        GO TO 900
C
C        A  IS NOT JUST A TRIANGULAR MATRIX. CONSTRUCT LU FACTORIZATION
   20 DO 50 I=1,NROWM1
C                                  W(MIDDLE,I)  IS PIVOT FOR I-TH STEP .
         PIVOT = W(MIDDLE,I)
         IF (PIVOT .EQ. 0.)             GO TO 999
C                 JMAX  IS THE NUMBER OF (NONZERO) ENTRIES IN COLUMN  I
C                     BELOW THE DIAGONAL .
         JMAX = MIN0(NBANDL,NROW - I)
C              DIVIDE EACH ENTRY IN COLUMN  I  BELOW DIAGONAL BY PIVOT .
         JBEG = MIDDLE + 1
         JEND = MIDDLE + JMAX
         DO 32 J=JBEG,JEND
   32       W(J,I) = W(J,I)/PIVOT
C                 KMAX  IS THE NUMBER OF (NONZERO) ENTRIES IN ROW  I  TO
C                     THE RIGHT OF THE DIAGONAL .
         KMAX = MIN0(NBANDU,NROW - I)
C                  SUBTRACT  A(I,I+K)*(I-TH COLUMN) FROM (I+K)-TH COLUMN
C                  (BELOW ROW  I ) .
         DO 40 K=1,KMAX
            IPK = I + K
            MIDMK = MIDDLE - K
            FACTOR = W(MIDMK,IPK)
            DO 40 J=1,JMAX
               MJ = MIDDLE + J
               MDJ = MIDMK + J
   40          W(MDJ,IPK) = W(MDJ,IPK) - W(MJ,I)*FACTOR
   50    CONTINUE
C                                       CHECK THE LAST DIAGONAL ENTRY .
  900 IF (W(MIDDLE,NROW) .NE. 0.)       RETURN
  999 IFLAG = 2
                                        RETURN
      END
      SUBROUTINE BANSLV ( W, NROWW, NROW, NBANDL, NBANDU, B )
C  FROM  * A PRACTICAL GUIDE TO SPLINES *  BY C. DE BOOR
C  COMPANION ROUTINE TO  BANFAC . IT RETURNS THE SOLUTION  X  OF THE
C  LINEAR SYSTEM  A*X = B  IN PLACE OF  B , GIVEN THE LU-FACTORIZATION
C  FOR  A  IN THE WORKARRAY  W .
C
C******  I N P U T  ******
C  W, NROWW,NROW,NBANDL,NBANDU.....DESCRIBE THE LU-FACTORIZATION OF A
C        BANDED MATRIX  A  OF RODER  NROW  AS CONSTRUCTED IN  BANFAC .
C        FOR DETAILS, SEE  BANFAC .
C  B.....RIGHT SIDE OF THE SYSTEM TO BE SOLVED .
C
C******  O U T P U T  ******
C  B.....CONTAINS THE SOLUTION  X , OF ORDER  NROW .
C
C******  M E T H O D  ******
C     (WITH  A = L*U, AS STORED IN  W,) THE UNIT LOWER TRIANGULAR SYSTEM
C  L(U*X) = B  IS SOLVED FOR  Y = U*X, AND  Y  STORED IN  B . THEN THE
C  UPPER TRIANGULAR SYSTEM  U*X = Y  IS SOLVED FOR  X  . THE CALCUL-
C  ATIONS ARE SO ARRANGED THAT THE INNERMOST LOOPS STAY WITHIN COLUMNS.
C
      REAL W(NROWW,NROW),B(NROW)
      MIDDLE = NBANDU + 1
      IF (NROW .EQ. 1)                  GO TO 49
      NROWM1 = NROW - 1
      IF (NBANDL .EQ. 0)                GO TO 30
C                                 FORWARD PASS
C            FOR I=1,2,...,NROW-1, SUBTRACT  RIGHT SIDE(I)*(I-TH COLUMN
C            OF  L )  FROM RIGHT SIDE  (BELOW I-TH ROW) .
      DO 21 I=1,NROWM1
         JMAX = MIN0(NBANDL, NROW-I)
         DO 21 J=1,JMAX
            IPJ = I + J
            MPJ = MIDDLE + J
   21       B(IPJ) = B(IPJ) - B(I)*W(MPJ,I)
C                                 BACKWARD PASS
C            FOR I=NROW,NROW-1,...,1, DIVIDE RIGHT SIDE(I) BY I-TH DIAG-
C            ONAL ENTRY OF  U, THEN SUBTRACT  RIGHT SIDE(I)*(I-TH COLUMN
C            OF  U)  FROM RIGHT SIDE  (ABOVE I-TH ROW).
   30 IF (NBANDU .GT. 0)                GO TO 40
C                                A  IS LOWER TRIANGULAR .
      DO 31 I=1,NROW
   31    B(I) = B(I)/W(1,I)
                                        RETURN
   40 I = NROW
   41    B(I) = B(I)/W(MIDDLE,I)
         JMAX = MIN0(NBANDU,I-1)
         DO 45 J=1,JMAX
            IMJ = I - J
            MMJ = MIDDLE - J
   45       B(IMJ) = B(IMJ) - B(I)*W(MMJ,I)
         I = I - 1
         IF (I .GT. 1)                  GO TO 41
   49 B(1) = B(1)/W(MIDDLE,1)
                                        RETURN
      END
      SUBROUTINE BSLSQ (TAU, GTAU, WGT, NTAU, T, N, K, A, WK, Q, IERR)
C-----------------------------------------------------------------------
C
C        BSLSQ PRODUCES THE B-SPLINE COEFFICIENTS OF A PIECEWISE
C              POLYNOMIAL P(X) OF ORDER K WHICH MINIMIZES
C
C                SUM (WGT(J)*(P(TAU(J)) - GTAU(J))**2).
C
C
C     INPUT ...
C
C       TAU   ARRAY OF LENGTH NTAU CONTAINING DATA POINT ABSCISSAE.
C       GTAU  ARRAY OF LENGTH NTAU CONTAINING DATA POINT ORDINATES.
C       WGT   ARRAY OF LENGTH NTAU CONTAINING THE WEIGHTS.
C       NTAU  NUMBER OF DATA POINTS TO BE FITTED.
C       T     KNOT SEQUENCE OF LENGTH N + K.
C       N     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
C       K     ORDER OF THE B-SPLINES.
C
C     OUTPUT ...
C
C       A     ARRAY OF LENGTH N CONTAINING THE B-SPLINE COEFFICIENTS
C             OF THE L2 APPROXIMATION.
C
C       IERR  INTEGER REPORTING THE STATUS OF THE RESULTS ...
C
C             0  THE COEFFICIENT MATRIX IS NONSIGULAR. THE
C                UNIQUE LEAST SQUARES SOLUTION WAS OBTAINED.
C             1  THE COEFFICIENT MATRIX IS SINGULAR. A
C                LEAST SQUARES SOLUTION WAS OBTAINED.
C            -1  INPUT ERRORS WERE DETECTED.
C
C-----------------------------------------------------------------------
      REAL TAU(NTAU), GTAU(NTAU), WGT(NTAU)
      REAL T(*), A(N), WK(N), Q(K,N)
C
      IF (NTAU .LT. MAX0(2,K)) GO TO 100
      IF (TAU(1) .LT. T(K) .OR. TAU(NTAU) .GT. T(N + 1)) GO TO 100
C
      DO 10 I = 2,NTAU
         IF (TAU(I - 1) .GT. TAU(I)) GO TO 100
   10 CONTINUE
C
      DO 21 J = 1,N
         A(J) = 0.0
         DO 20 I = 1,K
            Q(I,J) = 0.0
   20    CONTINUE
   21 CONTINUE
C
      LEFT = K
      DO 70 L = 1,NTAU
C
C        *** FIND THE INDEX LEFT SUCH THAT
C            T(LEFT) .LE. TAU(L) .LT. T(LEFT+1)
C
   30    IF (LEFT .EQ. N) GO TO 40
            IF (TAU(L) .LT. T(LEFT+1)) GO TO 40
            LEFT = LEFT + 1
            GO TO 30
C
   40    JJ = 0
         CALL BSPVB (T, K, K, JJ, TAU(L), LEFT, WK)
C
         LEFTMK = LEFT - K
         DO 61 MM = 1,K
            DW = WK(MM)*WGT(L)
            J = LEFTMK + MM
            A(J) = DW*GTAU(L) + A(J)
            I = 1
            DO 60 JJ = MM,K
               Q(I,J) = WK(JJ)*DW + Q(I,J)
               I = I + 1
   60       CONTINUE
   61    CONTINUE
   70 CONTINUE
C
C        SOLVE THE NORMAL EQUATIONS
C
      CALL BCHFAC (Q, K, N, WK, IERR)
      CALL BCHSLV (Q, K, N, A)
      RETURN
C
C             ERROR RETURN
C
  100 IERR = -1
      RETURN
      END
      SUBROUTINE BCHFAC (W, NB, N, DIAG, IFLAG)
C-----------------------------------------------------------------------
C  FROM  * A PRACTICAL GUIDE TO SPLINES *  BY C. DE BOOR
C  CONSTRUCTS CHOLESKY FACTORIZATION
C                     C  =  L * D * L-TRANSPOSE
C  WITH L UNIT LOWER TRIANGULAR AND D DIAGONAL, FOR GIVEN MATRIX C OF
C  ORDER  N , IN CASE  C  IS (SYMMETRIC) POSITIVE SEMIDEFINITE
C  AND BANDED, HAVING NB DIAGONALS AT AND BELOW THE MAIN DIAGONAL.
C
C******  INPUT  ******
C
C     N      THE ORDER OF THE MATRIX C.
C
C     NB     THE BANDWIDTH OF C, I.E.,
C               C(I,J) = 0 FOR ABS(I-J) .GT. NB .
C
C     W      WORK ARRAY OF SIZE NB BY N CONTAINING THE NB DIAGONALS
C            IN ITS ROWS, WITH THE MAIN DIAGONAL IN ROW 1. PRECISELY,
C            W(I,J)  CONTAINS  C(I+J-1,J), I=1,...,NB, J=1,...,N.
C            FOR EXAMPLE, THE INTERESTING ENTRIES OF A SEVEN DIAGONAL
C            SYMMETRIC MATRIX C OF ORDER 9 WOULD BE STORED IN W AS
C
C                       11 22 33 44 55 66 77 88 99
C                       21 32 43 54 65 76 87 98
C                       31 42 53 64 75 86 97
C                       41 52 63 74 85 96
C
C            ALL OTHER ENTRIES OF W NOT IDENTIFIED WITH AN ENTRY OF C
C            ARE NEVER REFERENCED.
C
C     DIAG   WORK ARRAY OF LENGTH N.
C
C******  O U T P U T  ******
C                                                         T
C     W      CONTAINS THE CHOLESKY FACTORIZATION C = L*D*L   WHERE
C            W(1,I) = 1/D(I,I) AND W(I,J) = L(I-1+J,J) (I=2,...,NB).
C
C     IFLAG  0 IF C IS NONSINGULAR AND 1 IF C IS SINGULAR.
C
C******  M E T H O D  ******
C
C   GAUSS ELIMINATION, ADAPTED TO THE SYMMETRY AND BANDEDNESS OF  C , IS
C   USED .
C     NEAR ZERO PIVOTS ARE HANDLED IN A SPECIAL WAY. THE DIAGONAL ELE-
C  MENT C(K,K) = W(1,K) IS SAVED INITIALLY IN  DIAG(K), ALL K. AT THE K-
C  TH ELIMINATION STEP, THE CURRENT PIVOT ELEMENT, VIZ.  W(1,K), IS COM-
C  PARED WITH ITS ORIGINAL VALUE, DIAG(K). IF, AS THE RESULT OF PRIOR
C  ELIMINATION STEPS, THIS ELEMENT HAS BEEN REDUCED BY ABOUT A WORD
C  LENGTH, (I.E., IF W(1,K)+DIAG(K) .LE. DIAG(K)), THEN THE PIVOT IS DE-
C  CLARED TO BE ZERO, AND THE ENTIRE K-TH ROW IS DECLARED TO BE LINEARLY
C  DEPENDENT ON THE PRECEDING ROWS. THIS HAS THE EFFECT OF PRODUCING
C   X(K) = 0  WHEN SOLVING  C*X = B  FOR  X, REGARDLESS OF  B. JUSTIFIC-
C  ATION FOR THIS IS AS FOLLOWS. IN CONTEMPLATED APPLICATIONS OF THIS
C  PROGRAM, THE GIVEN EQUATIONS ARE THE NORMAL EQUATIONS FOR SOME LEAST-
C  SQUARES APPROXIMATION PROBLEM, DIAG(K) = C(K,K) GIVES THE NORM-SQUARE
C  OF THE K-TH BASIS FUNCTION, AND, AT THIS POINT,  W(1,K)  CONTAINS THE
C  NORM-SQUARE OF THE ERROR IN THE LEAST-SQUARES APPROXIMATION TO THE K-
C  TH BASIS FUNCTION BY LINEAR COMBINATIONS OF THE FIRST K-1 . HAVING
C  W(1,K)+DIAG(K) .LE. DIAG(K) SIGNIFIES THAT THE K-TH FUNCTION IS LIN-
C  EARLY DEPENDENT TO MACHINE ACCURACY ON THE FIRST K-1 FUNCTIONS, THERE
C  FORE CAN SAFELY BE LEFT OUT FROM THE BASIS OF APPROXIMATING FUNCTIONS
C     THE SOLUTION OF A LINEAR SYSTEM
C                       C*X = B
C   IS EFFECTED BY THE SUCCESSION OF THE FOLLOWING  T W O  CALLS ...
C     CALL BCHFAC (W, NB, N, DIAG, IFLAG)   , TO GET FACTORIZATION
C     CALL BCHSLV (W, NB, N, B, X )            , TO SOLVE FOR X.
C-----------------------------------------------------------------------
      REAL W(NB,N), DIAG(N)
C
      IF (N .GT. 1) GO TO 10
         IFLAG = 1
         IF (W(1,1) .EQ. 0.0) RETURN
         IFLAG = 0
         W(1,1) = 1.0/W(1,1)
         RETURN
C
C     STORE THE DIAGONAL OF C IN DIAG
C
   10 DO 11 K = 1,N
         DIAG(K) = W(1,K)
   11 CONTINUE
C
C     FACTORIZATION
C
      IFLAG = 0
      DO 60 K = 1,N
         T = W(1,K) + DIAG(K)
         IF (T .NE. DIAG(K)) GO TO 30
            IFLAG = 1
            DO 20 J = 1,NB
               W(J,K) = 0.0
   20       CONTINUE
            GO TO 60
C
   30    T = 1.0/W(1,K)
         W(1,K) = T
         IMAX = MIN0(NB - 1,N - K)
         IF (IMAX .LT. 1) GO TO 60
         JMAX = IMAX
         DO 50 I = 1,IMAX
            RATIO = T*W(I+1,K)
            KPI = K + I
            DO 40 J = 1,JMAX
               IPJ = I + J
               W(J,KPI) = W(J,KPI) - W(IPJ,K)*RATIO
   40       CONTINUE
            JMAX = JMAX - 1
            W(I+1,K) = RATIO
   50    CONTINUE
   60 CONTINUE
      RETURN
      END
      SUBROUTINE BCHSLV (W, NB, N, B)
C-----------------------------------------------------------------------
C
C     BCHSLV SOLVES THE LINEAR SYSTEM C*X = B FOR X WHEN W CONTAINS
C     THE CHOLESKY FACTORIZATION OBTAINED BY THE SUBROUTINE BCHFAC
C     FOR THE BANDED SYMMETRIC POSITIVE DEFINITE MATRIX C.
C
C     INPUT ...
C
C        N   THE ORDER OF THE MATRIX C
C        NB  THE BANDWIDTH OF C
C        W   THE CHOLESKY FACTORIZATION OF C
C        B   VECTOR OF LENGTH N CONTAINING THE RIGHT SIDE
C
C     OUTPUT ...
C
C        B   SOLUTION X OF THE LINEAR SYSTEM C*X = B
C
C                                       T
C     NOTE.  THE FACTORIZATION C = L*D*L  IS USED, WHERE L IS A
C     UNIT LOWER TRIANGULAR MATRIX AND D A DIAGONAL MATRIX.
C
C-----------------------------------------------------------------------
      REAL W(NB,N), B(N)
C
      IF (N .GT. 1) GO TO 10
      B(1) = B(1)*W(1,1)
      RETURN
C
C     FORWARD SUBSTITUTION. SOLVE L*Y = B FOR Y AND STORE Y IN B.
C
   10 NBM1 = NB - 1
      DO 30 K = 1,N
         JMAX = MIN0(NBM1,N - K)
         IF (JMAX .LT. 1) GO TO 30
         DO 20 J = 1,JMAX
            JPK = J + K
            B(JPK) = B(JPK) - W(J + 1,K)*B(K)
   20    CONTINUE
   30 CONTINUE
C                              T     -1
C     BACKSUBSTITUTION. SOLVE L X = D  Y  FOR X AND STORE X IN B.
C
      K = N
   40    B(K) = B(K)*W(1,K)
         JMAX = MIN0(NBM1,N - K)
         IF (JMAX .LT. 1) GO TO 60
         DO 50 J = 1,JMAX
            JPK = J + K
            B(K) = B(K) - W(J + 1,K)*B(JPK)
   50    CONTINUE
   60    K = K - 1
         IF (K .GT. 0) GO TO 40
      RETURN
      END
      SUBROUTINE BFIT (BKPT, N, NORD, XDATA, YDATA, NDATA,
     *                 XCONST, YCONST, NDERIV, NCONST,
     *                 MODE, COEFF, RNORM, W, IW)
C-----------------------------------------------------------------------
C
C      THIS SUBPROGRAM FITS A PIECE-WISE POLYNOMIAL CURVE
C      TO DISCRETE DATA.  THE PIECE-WISE POLYNOMIALS ARE
C      REPRESENTED AS B-SPLINES.
C      THE FITTING IS DONE IN A LEAST SQUARES SENSE.
C      EQUALITY AND INEQUALITY CONSTRAINTS CAN BE IMPOSED
C      ON THE FITTED CURVE.
C
C  INPUT..
C
C      N,NORD,BKPT(*)     N IS THE NUMBER OF COEFFICIENTS TO BE COM-
C                         PUTED AND NORD IS THE ORDER OF THE B-SPLINE.
C                         IT IS ASSUMED THAT N .GE. NORD. THE N + NORD
C                         KNOTS OF THE SPLINE ARE IN THE ARRAY BKPT(*).
C                         IT IS ASSUMED THAT THE KNOTS FORM A NONDE-
C                         CREASING SEQUENCE. THE PROBLEM DATA INTERVAL
C                         LIES BETWEEN THE POINTS BKPT(NORD) AND
C                         BKPT(N+1). THE ADDITIONAL END KNOTS BKPT(I),
C                         I = 1,...,NORD-1 AND I = N+2,...,N+NORD, ARE
C                         REQUIRED TO COMPUTE THE FUNCTIONS USED TO
C                         FIT THE DATA.
C
C                         (THE ORDER OF THE B-SPLINE IS ONE MORE THAN
C                         THE DEGREE OF THE PIECEWISE POLYNOMIAL. FOR
C                         EXAMPLE, NORD=4 WHEN WE ARE USING PIECEWISE
C                         CUBICS.)
C
C      NDATA,XDATA(*),
C      YDATA(*)           THE NDATA DISCRETE (X,Y) PAIRS ARE IN
C                         THE ARRAYS XDATA(*) AND YDATA(*). IT IS
C                         ASSUMED THAT XDATA(*) IS AN INCREASING
C                         SEQUENCE, XDATA(1) .GE. BKPT(NORD), AND
C                         XDATA(NDATA) .LE. BKPT(N+1).
C
C      NCONST,XCONST(*),
C      YCONST(*),NDERIV(*)
C                         THE NUMBER OF CONDITIONS THAT CONSTRAIN
C                         THE B-SPLINE IS NCONST. A CONSTRAINT IS
C                         SPECIFIED BY AN (X,Y) PAIR IN THE ARRAYS
C                         XCONST(*) AND YCONST(*), AND BY THE TYPE
C                         OF CONSTRAINT AND DERIVATIVE VALUE ENCODED
C                         IN THE ARRAY NDERIV(*). IT IS ASSUMED THAT
C                         THE VALUES IN XCONST(*) ARE IN THE CLOSED
C                         INTERVAL (BKPT(NORD),BKPT(N+1)). THE CON-
C                         STRAINTS MAY BE GIVEN IN ANY ORDER. THE
C                         VALUE OF NDERIV(*) IS DETERMINED AS FOLLOWS.
C                         SUPPOSE THE I-TH CONSTRAINT APPLIES TO THE
C                         J-TH DERIVATIVE OF THE B-SPLINE.  (ANY
C                         NONNEGATIVE VALUE OF J .LT. NORD IS PERMITTED.
C                         IN PARTICULAR, THE VALUE J = 0 REFERS TO THE
C                         B-SPLINE ITSELF.)
C                         FOR THIS I-TH CONSTRAINT, SET
C                          XCONST(I) = X,
C                          YCONST(I) = Y, AND
C                          NDERIV(I) = ITYPE + 4*J  WHERE
C
C                          ITYPE = 0,      IF (J-TH DERIV. AT X) .LE. Y.
C                                = 1,      IF (J-TH DERIV. AT X) .GE. Y.
C                                = 2,      IF (J-TH DERIV. AT X) .EQ. Y.
C                                = 3,      IF (J-TH DERIV. AT X) .EQ.
C                                             (J-TH DERIV. AT Y).
C                          (A NEGATIVE VALUE FOR NDERIV(I) WILL CAUSE
C                          THIS CONSTRAINT TO BE IGNORED.  THIS
C                          FEATURE IS OFTEN USEFUL WHEN TEMPORARILY
C                          SUPPRESSING A CONSTRAINT WHILE STILL
C                          RETAINING THE SOURCE CODE OF THE CALLING
C                          PROGRAM.)
C
C      MODE               AN INPUT FLAG THAT DIRECTS THE LEAST
C                         SQUARES SOLUTION METHOD USED BY BFIT( ).
C
C                         MODE = 0      A NEW PROBLEM.
C
C                         MODE .NE. 0   AN OLD PROBLEM.
C
C                         BY AN OLD PROBLEM IT IS MEANT THAT BFIT( )
C                         WAS LAST CALLED WITH THE SAME SET OF KNOTS
C                         AND DATA POINTS. (THE CONSTRAINTS MAY BE
C                         DIFFERENT THAN BEFORE.)
C
C
C      IW(1),IW(2)        THE AMOUNTS OF WORKING STORAGE ACTUALLY
C                         ALLOCATED FOR THE WORKING ARRAYS W(*) AND
C                         IW(*).  THESE QUANTITIES ARE COMPARED WITH THE
C                         ACTUAL AMOUNTS OF STORAGE NEEDED IN BFIT( ).
C                         INSUFFICIENT STORAGE ALLOCATED FOR
C                         EITHER W(*) OR IW(*) IS AN ERROR.
C
C                         LENGTH OF W(*) MUST BE AT LEAST
C
C                           NB = (N + 3)*(NORD + 1) + NORD**2
C
C                         AND THE LENGTH OF IW(*) MUST BE AT LEAST 2.
C                         WHENEVER POSSIBLE THE CODE USES BANDED MATRIX
C                         PROCESSORS BNDACC( ) AND BNDSL( ).  THESE
C                         ARE UTILIZED IF THERE ARE NO CONSTRAINTS AND
C                         THERE IS SUFFICIENT DATA TO UNIQUELY DETERMINE
C                         THE B-SPLINE COEFFICENTS.
C
C                         IF THE BAND PROCESSORS CANNOT BE USED TO
C                         DETERMINE THE SOLUTION, THEN THE CONSTRAINED
C                         LEAST SQUARES CODE LSEI( ) IS USED.
C                         IN THIS CASE THE SUBPROGRAM REQUIRES AN
C                         ADDITIONAL BLOCK OF STORAGE IN W(*).  FOR THE
C                         DISCUSSION HERE DEFINE THE INTEGERS
C                         NEQCON AND NINCON RESPECTIVELY AS THE
C                         NUMBER OF EQUALITY (ITYPE=2,3) AND
C                         INEQUALITY (ITYPE=0,1) CONSTRAINTS
C                         IMPOSED ON THE FITTED CURVE.  DEFINE
C
C                           L = N + 1
C
C                         AND NOTE THAT
C
C                           NCONST = NEQCON + NINCON.
C
C                         WHEN THE SUBPROGRAM BFIT( ) USES LSEI( ) THE
C                         LENGTH OF THE WORKING ARRAY W(*) MUST BE AT
C                         LEAST
C
C                           LW = NB + (L+NCONST)*L + 2*(NEQCON+L)
C                                   + (NINCON + L) + (NINCON+2)*(L+6)
C
C                         AND THE LENGTH OF THE ARRAY IW(*) MUST BE AT
C                         LEAST
C
C                           IW1 = NINCON + 2*L .
C
C  OUTPUT..
C
C      MODE               AN OUTPUT FLAG THAT INDICATES THE STATUS
C                         OF THE CONSTRAINED CURVE FIT.
C
C                         =-1  EITHER NORD .LT. 1 OR NORD .GT. N.
C
C                         =-2  EITHER NDATA .LT. 1 OR NCONST .LT. 0.
C
C                         =-3  BKPT(I) .GT. BKPT(I+1) FOR SOME I.
C
C                         =-4  XDATA(*) IS NOT AN INCREASING
C                              SEQUENCE IN THE CLOSED INTERVAL
C                              (BKPT(NORD), BKPT(N+1)).
C
C                         =-5  THE I-TH CONSTRAINT IS INCORRECT
C                              FOR THE VALUE OF I STORED IN IW(2).
C
C                         =-6  INSUFF. STORAGE FOR W(*). IW(1) HAS
C                              BEEN RESET TO THE AMOUNT OF STORAGE
C                              NEEDED BY W(*).
C
C                         =-7  INSUFF. STORAGE FOR IW(*). IW(2) HAS
C                              BEEN RESET TO THE AMOUNT OF STORAGE
C                              NEEDED BY IW(*).
C
C                         = 0  SUCCESSFUL CONSTRAINED CURVE FIT.
C
C                         = 1  THE REQUESTED EQUALITY CONSTRAINTS
C                              ARE CONTRADICTORY.
C
C                         = 2  THE PROBLEM CANNOT BE SOLVED. THE
C                              CONSTRAINTS ARE CONTRADICTORY.
C
C      COEFF(*)
C                         IF THE OUTPUT VALUE OF MODE=0 OR 1, COEFF(*)
C                         CONTAINS THE N UNKNOWNS OBTAINED FROM THE
C                         LEAST SQUARES FITTING PROCESS.  THESE N
C                         PARAMETERS ARE THE B-SPLINE COEFFICIENTS.
C                         FOR MODE=1, THE EQUALITY CONSTRAINTS ARE
C                         CONTRADICTORY.  TO MAKE THE FITTING PROCESS
C                         MORE ROBUST, THE EQUALITY CONSTRAINTS ARE
C                         SATISFIED IN A LEAST SQUARES SENSE.  IN
C                         THIS CASE THE ARRAY COEFF(*) CONTAINS
C                         B-SPLINE COEFFICIENTS FOR THIS EXTENDED
C                         CONCEPT OF A SOLUTION.
C                         IF MODE .LT. 0 OR MODE = 2 ON OUTPUT, THE
C                         ARRAY COEFF(*) IS UNDEFINED.
C
C      RNORM              IF THE OUTPUT VALUE OF MODE = 0 OR 1 THEN
C                         RNORM IS THE L2 NORM OF THE VECTOR
C                         (YDATA(I) - F(XDATA(I)), I = 1,NDATA).
C
C  WORKING ARRAYS..
C
C      W(*),IW(*)         THESE ARRAYS ARE RESPECTIVELY TYPED
C                         REAL AND INTEGER.  THEIR REQUIRED
C                         LENGTHS ARE SPECIFIED AS INPUT PARAMETERS
C                         IN IW(1), IW(2) NOTED ABOVE. IT IS ASSUMED
C                         THAT W(1),...,W(NB) HAVE NOT BEEN MODIFIED
C                         IF BFIT( ) IS BEING RECALLED FOR THE SAME
C                         KNOTS AND DATA AS BEFORE (I.E., IF WE HAVE
C                         AN OLD PROBLEM).
C
C
C   REFERENCE.  HANSON R.J., CONSTRAINED LEAST SQUARES CURVE FITTING
C               TO DISCRETE DATA USING B-SPLINES, A USERS GUIDE.
C               SANDIA LABS. TECH. REPT. SAND-78-1291, DEC, 1978.
C
C-----------------------------------------------------------------------
C   WRITTEN BY
C     RICHARD J. HANSON
C     SANDIA LABORATORIES
C   MODIFIED BY A.H. MORRIS (NSWC)
C-----------------------------------------------------------------------
      REAL BKPT(*), XDATA(NDATA), YDATA(NDATA)
      REAL XCONST(*), YCONST(*), COEFF(N), W(*)
      INTEGER NDERIV(*), IW(*)
C
      NBKPT = N + NORD
      MDG = N + 3
      MDW = N + 1 + NCONST
C
C                         USAGE IN BFIT0( ) OF W(*)..
C
C      I1,...,I2-1      G(*,*)
C
C      I2,...,I3-1      BF(*,*)
C
C      I3,...,I7-1      W(*,*)
C
C      I7,...           WORK(*) FOR BSPVD( ) AND LSEI( )
C
      I1 = 1
      I2 = I1 + MDG*(NORD + 1)
      I3 = I2 + NORD*NORD
      I7 = I3 + MDW*(N + 1)
C
      CALL BFIT0 (NDATA, XDATA, YDATA, NORD, NBKPT, BKPT, NCONST,
     1         XCONST, YCONST, NDERIV, MODE, COEFF, RNORM, W(I2),
     2         W(I1), MDG, W(I3), MDW, W(I7), IW)
      RETURN
      END
      SUBROUTINE BFIT0 (NDATA, XDATA, YDATA, NORD, NBKPT, BKPT,
     1        NCONST, XCONST, YCONST, NDERIV, MODE, COEFF, RNORM,
     2        BF, G, MDG, W, MDW, WORK, IWORK)
C---------------------
      REAL BKPT(NBKPT), XDATA(NDATA), YDATA(NDATA)
      REAL XCONST(*), YCONST(*), COEFF(*)
      REAL BF(NORD,NORD), G(MDG,*), W(MDW,*), WORK(*)
      INTEGER NDERIV(*), IWORK(*)
C
      REAL PRGOPT(7)
      LOGICAL BAND, NEW
C
      GO TO 100
C
   10 IF (.NOT. BAND) GO TO 20
      CALL BNDSL (1, G, MDG, NORD, IP, IR, COEFF, N, RNORM, IERR)
      IF (IERR .EQ. 0) RETURN
C
C     CHECK FURTHER FOR SUFFICIENT STORAGE IN WORKING ARRAYS.
C
   20 IF (IW1 .LT. LW) GO TO 850
      IF (IW2 .LT. INTW1) GO TO 860
      GO TO 300
C
C     SOLVE THE EQUATIONS
C
   30 CALL LSEI(W, MDW, NEQCON, NP1, NINCON, N, PRGOPT, COEFF, RNORME,
     *          RNORM, MODE, WORK, IWORK)
      IWORK(1) = IW1
      IWORK(2) = IW2
      RETURN
C-----------------------------------------------------------------------
C               INITIALIZE-VARIABLES-AND-ANALYZE-INPUT
C-----------------------------------------------------------------------
  100 N = NBKPT - NORD
      IF (NORD .LT. 1 .OR. NORD .GT. N) GO TO 800
      IF (NDATA .LT. 1 .OR. NCONST .LT. 0) GO TO 810
C
C     CHECK THE BREAK POINTS
C
      IF (MODE .NE. 0) GO TO 120
      M = NBKPT - 1
      DO 110 I = 1,M
         IF (BKPT(I) .GT. BKPT(I+1)) GO TO 820
  110 CONTINUE
C
C     AMOUNT OF STORAGE ALLOCATED FOR W(*),IW(*)
C
  120 IW1 = IWORK(1)
      IW2 = IWORK(2)
      NB = (N + 3)*(NORD + 1) + NORD*NORD
      LW = NB
      IF (IW1 .LT. NB) GO TO 850
C
C     COMPUTE THE AMOUNT OF STORAGE NEEDED FOR LSEI
C
      NEQCON = 0
      NINCON = 0
      IF (NCONST .EQ. 0) GO TO 150
      DO 140 I = 1,NCONST
         L = NDERIV(I)
         IF (L .LT. 0) GO TO 140
         ITYPE = L - 4*(L/4)
         IF (ITYPE .GT. 1) GO TO 130
            NINCON = NINCON + 1
            GO TO 140
  130    NEQCON = NEQCON + 1
  140 CONTINUE
C
  150 NP1 = N + 1
      L = NP1
      LW = NB + (L+NCONST)*L + 2*(NEQCON+L) + (NINCON+L) +
     *          (NINCON+2)*(L+6)
      INTW1 = NINCON + 2*L
C
C     CHECK THE XCONST(*) ARRAY
C
      XMIN = BKPT(NORD)
      XMAX = BKPT(NP1)
      IF (NCONST .EQ. 0) GO TO 170
      DO 160 I = 1,NCONST
         IF (XCONST(I) .LT. XMIN .OR. XCONST(I) .GT. XMAX)
     *       GO TO 840
  160 CONTINUE
C
C     INITIALIZE PARAMETERS
C
  170 NEW = MODE .EQ. 0
      BAND = NCONST .EQ. 0
      MODE = 0
      NORDM1 = NORD - 1
      NORDP1 = NORD + 1
C
C     DEFINE THE OPTION VECTOR FOR USE IN LSEI( )
C
C     INCREASE THE RANK DETERMINATION TOLERANCES
C     FOR BOTH EQUALITY CONSTRAINT EQUATIONS AND
C     LEAST SQUARES EQUATIONS.
C
      PRGOPT(1) = 4
      PRGOPT(2) = 4
      PRGOPT(3) = 1.E-3
C
      PRGOPT(4) = 7
      PRGOPT(5) = 5
      PRGOPT(6) = 1.E-3
C
      PRGOPT(7) = 1
C
      IF (.NOT. NEW) GO TO 260
C
C     CHECK THE XDATA(*) ARRAY
C
      IF (XDATA(1) .LT. XMIN .OR. XDATA(NDATA) .GT. XMAX)
     *   GO TO 830
      IF (NDATA .EQ. 1) GO TO 200
C
      M = NDATA - 1
      DO 180 I = 1,M
         IF (XDATA(I) .GE. XDATA(I+1)) GO TO 830
  180 CONTINUE
C
C     INITIALIZE PARAMETERS OF BANDED MATRIX PROCESSOR, BNDACC( )
C
  200 MT = 0
      IP = 1
      IR = 1
      IDATA = 1
      ILEFT = NORD
C
  210 IF (IDATA .GT. NDATA) GO TO 250
      XVAL = XDATA(IDATA)
      IF (ILEFT .EQ. N) GO TO 230
C
C     WHEN INTERVAL CHANGES, PROCESS EQUATIONS IN THE LAST BLOCK.
C
      IP1 = ILEFT + 1
      IF (XVAL .LT. BKPT(IP1)) GO TO 230
      INTRVL = ILEFT - NORDM1
      CALL BNDACC (G, MDG, NORD, IP, IR, MT, INTRVL)
      MT = 0
C
C     MOVE POINTER UP SO THAT XVAL .GE. BKPT(ILEFT).
C
      DO 220 I = IP1,N
         IF (XVAL .LT. BKPT(I)) GO TO 230
  220    ILEFT = I
C
C     OBTAIN B-SPLINE FUNCTION VALUE
C
  230 J = 0
      CALL BSPVB (BKPT, NORD, NORD, J, XVAL, ILEFT, BF)
C
C     MOVE ROW INTO PLACE
C
      IROW = IR + MT
      MT = MT + 1
      CALL SCOPY (NORD, BF, 1, G(IROW,1), MDG)
      G(IROW,NORDP1) = YDATA(IDATA)
C
C     WHEN STAGING WORK AREA IS EXHAUSTED, PROCESS ROWS
C
      IF (IROW .NE. MDG - 1) GO TO 240
         INTRVL = ILEFT - NORDM1
         CALL BNDACC (G, MDG, NORD, IP, IR, MT, INTRVL)
         MT = 0
  240 IDATA = IDATA + 1
      GO TO 210
C
C     PROCESS  BLOCK OF EQUATIONS
C
  250 INTRVL = ILEFT - NORDM1
      CALL BNDACC (G, MDG, NORD, IP, IR, MT, INTRVL)
C
C     LAST CALL TO ADJUST BLOCK POSITIONING
C
      G(IR,1) = 0.0
      CALL SCOPY (NORDP1, G(IR,1), 0, G(IR,1), MDG)
      CALL BNDACC (G, MDG, NORD, IP, IR, 1, NP1)
C
  260 DO 270 I = 1,N
        BAND = BAND .AND. G(I,1) .NE. 0.0
  270 CONTINUE
      GO TO 10
C-----------------------------------------------------------------------
C       ANALYZE CONSTRAINT INDICATORS FOR EQUALITY CONSTRAINTS
C-----------------------------------------------------------------------
  300 IDATA = 0
      NEQCON = 0
C
  310 IDATA = IDATA + 1
      IF (IDATA .GT. NCONST) GO TO 400
      L = NDERIV(IDATA)
      IF (L .LT. 0) GO TO 310
      IDERIV = L/4
      ITYPE = L - 4*IDERIV
C
      IF (ITYPE .LT. 2) GO TO 310
      NEQCON = NEQCON + 1
      XVAL = XCONST(IDATA)
      ILEFT = NORD
      IF (NORD .EQ. N) GO TO 330
      DO 320 I = NORDP1,N
         IF (XVAL .LT. BKPT(I)) GO TO 330
  320    ILEFT = I
  330 CALL BSPVD (BKPT, NORD, XVAL, ILEFT, BF, NORD, IDERIV + 1, WORK)
      W(NEQCON,1) = 0.0
      CALL SCOPY (N, W(NEQCON,1), 0, W(NEQCON,1), MDW)
      INTRVL = ILEFT - NORDM1
      CALL SCOPY (NORD, BF(1,IDERIV+1), 1, W(NEQCON,INTRVL), MDW)
      IF (ITYPE .NE. 2) GO TO 340
      W(NEQCON,NP1) = YCONST(IDATA)
      GO TO 310
C
  340 W(NEQCON,NP1) = 0.0
      YVAL = YCONST(IDATA)
      I = IDATA
      IF (YVAL .LT. XMIN .OR. YVAL .GT. XMAX) GO TO 840
      ILEFT = NORD
      IF (NORD .EQ. N) GO TO 360
      DO 350 I = NORDP1,N
         IF (YVAL .LT. BKPT(I)) GO TO 360
  350    ILEFT = I
  360 CALL BSPVD (BKPT, NORD, YVAL, ILEFT, BF, NORD, IDERIV + 1, WORK)
      INTRVL = ILEFT - NORDM1
      CALL SAXPY (NORD, -1.0, BF(1,IDERIV+1), 1, W(NEQCON,INTRVL), MDW)
      GO TO 310
C-----------------------------------------------------------------------
C                    TRANSFER-LEAST-SQUARES DATA
C-----------------------------------------------------------------------
  400 DO 410 I = 1,NP1
        IROW = I + NEQCON
        W(IROW,1) = 0.0
        CALL SCOPY (N, W(IROW,1), 0, W(IROW,1), MDW)
        CALL SCOPY (MIN0(NP1-I,NORD), G(I,1), MDG, W(IROW,I), MDW)
        W(IROW,NP1) = G(I,NORDP1)
  410 CONTINUE
C-----------------------------------------------------------------------
C      ANALYZE CONSTRAINT INDICATORS FOR INEQUALITY CONSTRAINTS
C-----------------------------------------------------------------------
      IDATA = 0
      NINCON = 0
C
  500 IDATA = IDATA + 1
      IF (IDATA .GT. NCONST) GO TO 30
      L = NDERIV(IDATA)
      IF (L .LT. 0) GO TO 500
      IDERIV = L/4
      ITYPE = L - 4*IDERIV
C
      IF (ITYPE .GT. 1) GO TO 500
      NINCON = NINCON + 1
      XVAL = XCONST(IDATA)
      ILEFT = NORD
      IF (NORD .EQ. N) GO TO 520
      DO 510 I = NORDP1,N
         IF (XVAL .LT. BKPT(I)) GO TO 520
  510    ILEFT = I
  520 CALL BSPVD (BKPT, NORD, XVAL, ILEFT, BF, NORD, IDERIV + 1, WORK)
      IROW = NEQCON + NP1 + NINCON
      W(IROW,1) = 0.0
      CALL SCOPY (N, W(IROW,1), 0, W(IROW,1), MDW)
      INTRVL = ILEFT - NORDM1
      CALL SCOPY (NORD, BF(1,IDERIV+1), 1, W(IROW,INTRVL), MDW)
      W(IROW,NP1) = YCONST(IDATA)
      IF (ITYPE .NE. 0) GO TO 500
      W(IROW,NP1) = -W(IROW,NP1)
      CALL SSCAL(NORD, -1.0, W(IROW,INTRVL), MDW)
      GO TO 500
C-----------------------------------------------------------------------
C                         ERROR RETURN
C-----------------------------------------------------------------------
C                       EITHER NORD .LT. 1 OR NORD .GT. N.
  800 MODE = -1
      RETURN
C                       EITHER NDATA .LT. 1 OR NCONST .LT. 0.
  810 MODE = -2
      RETURN
C                       THE SEQUENCE OF KNOTS IS NOT NONDECREASING.
  820 MODE = -3
      RETURN
C                       XDATA(*) IS NOT AN INCREASING SEQUENCE IN THE
C                       CLOSED INTERVAL (BKPT(1),BKPT(N+1)).
  830 MODE = -4
      RETURN
C                       THE I-TH CONSTRAINT IS INCORRECT FOR THE
C                       VALUE OF I STORED IN IWORK(2).
  840 IWORK(2) = I
      MODE = -5
      RETURN
C                       INSUFF. STORAGE FOR W(*). IWORK(1) HAS BEEN SET
C                       TO THE AMOUNT OF STORAGE NEEDED BY W(*).
  850 IWORK(1) = LW
      MODE = -6
      RETURN
C                       INSUFF. STORAGE FOR IW(*). IWORK(2) HAS BEEN SET
C                       TO THE AMOUNT OF STORAGE NEEDED BY IW(*).
  860 IWORK(2) = INTW1
      MODE = -7
      RETURN
      END
      SUBROUTINE BNDACC (G,MDG,NB,IP,IR,MT,JT)
C
C***AUTHOR  LAWSON, C. L., (JPL)
C           HANSON, R. J., (SNLA)
C
C***PURPOSE  SOLVE THE LEAST SQUARES PROBLEM AX = B FOR BANDED
C            MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF
C            THE DATA MATRIX.  EXACTLY ONE RIGHT-HANDED SIDE VECTOR
C            IS PERMITTED.
C***DESCRIPTION
C
C     THESE SUBROUTINES SOLVE THE LEAST SQUARES PROBLEM AX = B FOR
C     BANDED MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF THE
C     DATA MATRIX.  EXACTLY ONE RIGHT-HAND SIDE VECTOR IS PERMITTED.
C
C     THESE SUBROUTINES ARE INTENDED FOR THE TYPE OF LEAST SQUARES
C     SYSTEMS THAT ARISE IN APPLICATIONS SUCH AS CURVE OR SURFACE
C     FITTING OF DATA.  THE LEAST SQUARES EQUATIONS ARE ACCUMULATED AND
C     PROCESSED USING ONLY PART OF THE DATA.  THIS REQUIRES A CERTAIN
C     USER INTERACTION DURING THE SOLUTION OF AX = B.
C
C     SPECIFICALLY, SUPPOSE THE DATA MATRIX (A B) IS ROW PARTITIONED
C     INTO Q SUBMATRICES.  LET (E F) BE THE T-TH ONE OF THESE
C     SUBMATRICES WHERE E = (0 C 0).  HERE THE DIMENSION OF E IS MT BY N
C     AND THE DIMENSION OF C IS MT BY NB.  THE VALUE OF NB IS THE
C     BANDWIDTH OF A.  THE DIMENSIONS OF THE LEADING BLOCK OF ZEROS IN E
C     ARE MT BY JT-1.
C
C     THE USER OF THE SUBROUTINE BNDACC PROVIDES MT,JT,C AND F FOR
C     T=1,...,Q.  NOT ALL OF THIS DATA MUST BE SUPPLIED AT ONCE.
C
C     FOLLOWING THE PROCESSING OF THE VARIOUS BLOCKS (E F), THE MATRIX
C     (A B) HAS BEEN TRANSFORMED TO THE FORM (R D) WHERE R IS UPPER
C     TRIANGULAR AND BANDED WITH BANDWIDTH NB.  THE LEAST SQUARES
C     SYSTEM RX = D IS THEN EASILY SOLVED USING BACK SUBSTITUTION BY
C     EXECUTING THE STATEMENT CALL BNDSL(1,...). THE SEQUENCE OF
C     VALUES FOR JT MUST BE NONDECREASING.  THIS MAY REQUIRE SOME
C     PRELIMINARY INTERCHANGES OF ROWS AND COLUMNS OF THE MATRIX A.
C
C     THE PRIMARY REASON FOR THESE SUBROUTINES IS THAT THE TOTAL
C     PROCESSING CAN TAKE PLACE IN A WORKING ARRAY OF DIMENSION MU BY
C     NB+1.  AN ACCEPTABLE VALUE FOR MU IS
C
C                       MU = MAX(MT + N + 1),
C
C     WHERE N IS THE NUMBER OF UNKNOWNS.
C
C     HERE THE MAXIMUM IS TAKEN OVER ALL VALUES OF MT FOR T=1,...,Q.
C     NOTICE THAT MT CAN BE TAKEN TO BE A SMALL AS ONE, SHOWING THAT
C     MU CAN BE AS SMALL AS N+2.  THE SUBPROGRAM BNDACC PROCESSES THE
C     ROWS MORE EFFICIENTLY IF MU IS LARGE ENOUGH SO THAT EACH NEW
C     BLOCK (C F) HAS A DISTINCT VALUE OF JT.
C
C     THE FOUR PRINCIPLE PARTS OF THESE ALGORITHMS ARE OBTAINED BY THE
C     FOLLOWING CALL STATEMENTS
C
C     CALL BNDACC(...)  INTRODUCE NEW BLOCKS OF DATA.
C
C     CALL BNDSL(1,...)COMPUTE SOLUTION VECTOR AND LENGTH OF
C                       RESIDUAL VECTOR.
C
C     CALL BNDSL(2,...)GIVEN ANY ROW VECTOR H SOLVE YR = H FOR THE
C                       ROW VECTOR Y.
C
C     CALL BNDSL(3,...)GIVEN ANY COLUMN VECTOR W SOLVE RZ = W FOR
C                       THE COLUMN VECTOR Z.
C
C     THE DOTS IN THE ABOVE CALL STATEMENTS INDICATE ADDITIONAL
C     ARGUMENTS THAT WILL BE SPECIFIED IN THE FOLLOWING PARAGRAPHS.
C
C     THE USER MUST DIMENSION THE ARRAY APPEARING IN THE CALL LIST..
C     G(MDG,NB+1)
C
C     DESCRIPTION OF CALLING SEQUENCE FOR BNDACC..
C
C     THE ENTIRE SET OF PARAMETERS FOR BNDACC ARE
C
C     INPUT..
C
C     G(*,*)            THE WORKING ARRAY INTO WHICH THE USER WILL
C                       PLACE THE MT BY NB+1 BLOCK (C F) IN ROWS IR
C                       THROUGH IR+MT-1, COLUMNS 1 THROUGH NB+1.
C                       SEE DESCRIPTIONS OF IR AND MT BELOW.
C
C     MDG               THE NUMBER OF ROWS IN THE WORKING ARRAY
C                       G(*,*).  THE VALUE OF MDG SHOULD BE .GE. MU.
C                       THE VALUE OF MU IS DEFINED IN THE ABSTRACT
C                       OF THESE SUBPROGRAMS.
C
C     NB                THE BANDWIDTH OF THE DATA MATRIX A.
C
C     IP                SET BY THE USER TO THE VALUE 1 BEFORE THE
C                       FIRST CALL TO BNDACC.  ITS SUBSEQUENT VALUE
C                       IS CONTROLLED BY BNDACC TO SET UP FOR THE
C                       NEXT CALL TO BNDACC.
C
C     IR                INDEX OF THE ROW OF G(*,*) WHERE THE USER IS
C                       TO PLACE THE NEW BLOCK OF DATA (C F).  SET BY
C                       THE USER TO THE VALUE 1 BEFORE THE FIRST CALL
C                       TO BNDACC.  ITS SUBSEQUENT VALUE IS CONTROLLED
C                       BY BNDACC. A VALUE OF IR .GT. MDG IS CONSIDERED
C                       AN ERROR.
C
C     MT,JT             SET BY THE USER TO INDICATE RESPECTIVELY THE
C                       NUMBER OF NEW ROWS OF DATA IN THE BLOCK AND
C                       THE INDEX OF THE FIRST NONZERO COLUMN IN THAT
C                       SET OF ROWS (E F) = (0 C 0 F) BEING PROCESSED.
C
C     OUTPUT..
C
C     G(*,*)            THE WORKING ARRAY WHICH WILL CONTAIN THE
C                       PROCESSED ROWS OF THAT PART OF THE DATA
C                       MATRIX WHICH HAS BEEN PASSED TO BNDACC.
C
C     IP,IR             THE VALUES OF THESE ARGUMENTS ARE ADVANCED BY
C                       BNDACC TO BE READY FOR STORING AND PROCESSING
C                       A NEW BLOCK OF DATA IN G(*,*).
C
C
C     REMARKS..
C
C     TO OBTAIN THE UPPER TRIANGULAR MATRIX AND TRANSFORMED RIGHT-HAND
C     SIDE VECTOR D SO THAT THE SUPER DIAGONALS OF R FORM THE COLUMNS
C     OF G(*,*), EXECUTE THE FOLLOWING FORTRAN STATEMENTS.
C
C     NBP1=NB+1
C
C     DO 10 J=1, NBP1
C
C  10 G(IR,J) = 0.E0
C
C     MT=1
C
C     JT=N+1
C
C     CALL BNDACC(G,MDG,NB,IP,IR,MT,JT)
C
C***REFERENCES  C. L. LAWSON AND R. J. HANSON,
C                 SOLVING LEAST SQUARE PROBLEMS,PRENCTICE-HALL, INC
C                 (1974), CHAPTER 27
C
      DIMENSION G(MDG,*)
C
C
C              ALG. STEPS 1-4 ARE PERFORMED EXTERNAL TO THIS SUBROUTINE.
C
      NBP1 = NB + 1
      IF (MT .LE. 0 .OR. NB .LE. 0) RETURN
C                                             ALG. STEP 5
      IF (JT .EQ. IP) GO TO 70
C                                             ALG. STEPS 6-7
      IF (JT .LE. IR) GO TO 30
C                                             ALG. STEPS 8-9
      DO 11 I = 1,MT
         IG1 = JT + MT - I
         IG2 = IR + MT - I
         DO 10 J = 1,NBP1
            G(IG1,J) = G(IG2,J)
   10    CONTINUE
   11 CONTINUE
C                                             ALG. STEP 10
      IE = JT - IR
      DO 21 I = 1,IE
         IG = IR + I - 1
         DO 20 J = 1,NBP1
           G(IG,J) = 0.0
   20    CONTINUE
   21 CONTINUE
C                                             ALG. STEP 11
      IR = JT
C                                             ALG. STEP 12
   30 MU = MIN0(NB - 1, IR - IP - 1)
      IF (MU .EQ. 0) GO TO 60
C                                             ALG. STEP 13
      DO 50 L = 1,MU
C                                             ALG. STEP 14
         K = MIN0(L, JT - IP)
C                                             ALG. STEP 15
         LP1 = L + 1
         IG = IP + L
         DO 40 I = LP1,NB
            JG = I - K
            G(IG,JG) = G(IG,I)
   40    CONTINUE
C                                             ALG. STEP 16
         DO 45 I = 1,K
            JG = NBP1 - I
            G(IG,JG) = 0.0
   45    CONTINUE
   50 CONTINUE
C                                             ALG. STEP 17
   60 IP = JT
C                                             ALG. STEPS 18-19
   70 MH = IR + MT - IP
      KH = MIN0(NBP1, MH)
C                                             ALG. STEP 20
      DO 80 I = 1,KH
         CALL H12 (1,I,MAX0(I+1,IR-IP+1),MH,G(IP,I),1,RHO,
     1             G(IP,I+1),1,MDG,NBP1-I)
   80 CONTINUE
C                                             ALG. STEP 21
      IR = IP + KH
C                                             ALG. STEP 22
      IF (KH .LT. NBP1) GO TO 100
C                                             ALG. STEP 23
      DO 90 I = 1,NB
         G(IR-1,I) = 0.0
   90 CONTINUE
C                                             ALG. STEP 24
  100 CONTINUE
C                                             ALG. STEP 25
      RETURN
      END
      SUBROUTINE BNDSL (MODE,G,MDG,NB,IP,IR,X,N,RNORM,IERR)
C
C***AUTHOR  LAWSON, C. L., (JPL)
C           HANSON, R. J., (SNLA)
C
C***PURPOSE  SOLVE THE LEAST SQUARES PROBLEM AX = B FOR BANDED
C            MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF
C            THE DATA MATRIX.  EXACTLY ONE RIGHT-HANDED SIDE VECTOR
C            IS PERMITTED.
C
C     THESE SUBROUTINES SOLVE THE LEAST SQUARES PROBLEM AX = B FOR
C     BANDED MATRICES A USING SEQUENTIAL ACCUMULATION OF ROWS OF THE
C     DATA MATRIX.  EXACTLY ONE RIGHT-HAND SIDE VECTOR IS PERMITTED.
C
C     THESE SUBROUTINES ARE INTENDED FOR THE TYPE OF LEAST SQUARES
C     SYSTEMS THAT ARISE IN APPLICATIONS SUCH AS CURVE OR SURFACE
C     FITTING OF DATA.  THE LEAST SQUARES EQUATIONS ARE ACCUMULATED AND
C     PROCESSED USING ONLY PART OF THE DATA.  THIS REQUIRES A CERTAIN
C     USER INTERACTION DURING THE SOLUTION OF AX = B.
C
C     SPECIFICALLY, SUPPOSE THE DATA MATRIX (A B) IS ROW PARTITIONED
C     INTO Q SUBMATRICES.  LET (E F) BE THE T-TH ONE OF THESE
C     SUBMATRICES WHERE E = (0 C 0).  HERE THE DIMENSION OF E IS MT BY N
C     AND THE DIMENSION OF C IS MT BY NB.  THE VALUE OF NB IS THE
C     BANDWIDTH OF A.  THE DIMENSIONS OF THE LEADING BLOCK OF ZEROS IN E
C     ARE MT BY JT-1.
C
C     THE USER OF THE SUBROUTINE BNDACC PROVIDES MT,JT,C AND F FOR
C     T=1,...,Q.  NOT ALL OF THIS DATA MUST BE SUPPLIED AT ONCE.
C
C     FOLLOWING THE PROCESSING OF THE VARIOUS BLOCKS (E F), THE MATRIX
C     (A B) HAS BEEN TRANSFORMED TO THE FORM (R D) WHERE R IS UPPER
C     TRIANGULAR AND BANDED WITH BANDWIDTH NB.  THE LEAST SQUARES
C     SYSTEM RX = D IS THEN EASILY SOLVED USING BACK SUBSTITUTION BY
C     EXECUTING THE STATEMENT CALL BNDSL(1,...). THE SEQUENCE OF
C     VALUES FOR JT MUST BE NONDECREASING.  THIS MAY REQUIRE SOME
C     PRELIMINARY INTERCHANGES OF ROWS AND COLUMNS OF THE MATRIX A.
C
C     THE PRIMARY REASON FOR THESE SUBROUTINES IS THAT THE TOTAL
C     PROCESSING CAN TAKE PLACE IN A WORKING ARRAY OF DIMENSION MU BY
C     NB+1.  AN ACCEPTABLE VALUE FOR MU IS
C
C                       MU = MAX(MT + N + 1),
C
C     WHERE N IS THE NUMBER OF UNKNOWNS.
C
C     HERE THE MAXIMUM IS TAKEN OVER ALL VALUES OF MT FOR T=1,...,Q.
C     NOTICE THAT MT CAN BE TAKEN TO BE A SMALL AS ONE, SHOWING THAT
C     MU CAN BE AS SMALL AS N+2.  THE SUBPROGRAM BNDACC PROCESSES THE
C     ROWS MORE EFFICIENTLY IF MU IS LARGE ENOUGH SO THAT EACH NEW
C     BLOCK (C F) HAS A DISTINCT VALUE OF JT.
C
C     THE FOUR PRINCIPLE PARTS OF THESE ALGORITHMS ARE OBTAINED BY THE
C     FOLLOWING CALL STATEMENTS
C
C     CALL BNDACC(...)  INTRODUCE NEW BLOCKS OF DATA.
C
C     CALL BNDSL(1,...)COMPUTE SOLUTION VECTOR AND LENGTH OF
C                       RESIDUAL VECTOR.
C
C     CALL BNDSL(2,...)GIVEN ANY ROW VECTOR H SOLVE YR = H FOR THE
C                       ROW VECTOR Y.
C
C     CALL BNDSL(3,...)GIVEN ANY COLUMN VECTOR W SOLVE RZ = W FOR
C                       THE COLUMN VECTOR Z.
C
C     THE DOTS IN THE ABOVE CALL STATEMENTS INDICATE ADDITIONAL
C     ARGUMENTS THAT WILL BE SPECIFIED IN THE FOLLOWING PARAGRAPHS.
C
C     THE USER MUST DIMENSION THE ARRAY APPEARING IN THE CALL LIST..
C     G(MDG,NB+1)
C
C     DESCRIPTION OF CALLING SEQUENCE FOR BNDSL..
C
C     THE USER MUST DIMENSION THE ARRAYS APPEARING IN THE CALL LIST..
C
C     G(MDG,NB+1), X(N)
C
C     THE ENTIRE SET OF PARAMETERS FOR BNDSL ARE
C
C     INPUT..
C
C     MODE              SET BY THE USER TO ONE OF THE VALUES 1, 2, OR
C                       3.  THESE VALUES RESPECTIVELY INDICATE THAT
C                       THE SOLUTION OF AX = B, YR = H OR RZ = W IS
C                       REQUIRED.
C
C     G(*,*),MDG,       THESE ARGUMENTS ALL HAVE THE SAME MEANING AND
C      NB,IP,IR         CONTENTS AS FOLLOWING THE LAST CALL TO BNDACC.
C
C     X(*)              WITH MODE=2 OR 3 THIS ARRAY CONTAINS,
C                       RESPECTIVELY, THE RIGHT-SIDE VECTORS H OR W OF
C                       THE SYSTEMS YR = H OR RZ = W.
C
C     N                 THE NUMBER OF VARIABLES IN THE SOLUTION
C                       VECTOR.  IF ANY OF THE N DIAGONAL TERMS ARE
C                       ZERO THE SUBROUTINE BNDSL PRINTS AN
C                       APPROPRIATE MESSAGE.  THIS CONDITION IS
C                       CONSIDERED AN ERROR.
C
C     OUTPUT..
C
C     X(*)              THIS ARRAY CONTAINS THE SOLUTION VECTORS X,
C                       Y OR Z OF THE SYSTEMS AX = B, YR = H OR
C                       RZ = W DEPENDING ON THE VALUE OF MODE=1,
C                       2 OR 3.
C
C     RNORM             IF MODE=1 RNORM IS THE EUCLIDEAN LENGTH OF THE
C                       RESIDUAL VECTOR AX-B.  WHEN MODE=2 OR 3 RNORM
C                       IS SET TO ZERO.
C
C     IERR              IERR = 0 IF THE SOLUTION WAS OBTAINED.
C                       IERR = 1 IF THE PROBLEM CANNOT BE SOLVED.
C
C
C***REFERENCES  C. L. LAWSON AND R. J. HANSON,
C                 SOLVING LEAST SQUARE PROBLEMS,PRENCTICE-HALL, INC
C                 (1974), CHAPTER 27
C
      DIMENSION G(MDG,*),X(N)
C
      IERR = 0
      RNORM = 0.0
      GO TO (10,90,50), MODE
C                                   ********************* MODE = 1
C                                   ALG. STEP 26
   10 DO 20 J = 1,N
         X(J) = G(J, NB+1)
   20 CONTINUE
      RSQ = 0.0
      NP1 = N + 1
      IRM1 = IR - 1
      IF (NP1 .GT. IRM1) GO TO 40
         DO 30 J = NP1,IRM1
            RSQ = RSQ + G(J, NB+1)**2
   30    CONTINUE
         RNORM = SQRT(RSQ)
   40 CONTINUE
C                                   ********************* MODE = 3
C                                   ALG. STEP 27
   50 DO 80 II = 1,N
         I = N + 1 - II
C                                   ALG. STEP 28
         S = 0.0
         L = MAX0(0, I - IP)
C                                   ALG. STEP 29
         IF (I .EQ. N) GO TO 70
C                                   ALG. STEP 30
            IE = MIN0(N + 1 - I, NB)
            DO 60 J = 2,IE
               JG = J + L
               IX = I - 1 + J
               S = S + G(I,JG)*X(IX)
   60       CONTINUE
C                                   ALG. STEP 31
   70    IF (G(I,L+1) .EQ. 0.0) GO TO 130
         X(I) = (X(I) - S)/G(I,L+1)
   80 CONTINUE
C                                   ALG. STEP 32
      RETURN
C                                   ********************* MODE = 2
   90 DO 120 J = 1,N
         S = 0.0
         IF (J .EQ. 1) GO TO 110
            I1 = MAX0(1, J - NB + 1)
            I2 = J - 1
            DO 100 I = I1,I2
               L = J - I + 1 + MAX0(0, I - IP)
               S = S + X(I)*G(I,L)
  100       CONTINUE
  110    L = MAX0(0, J - IP)
         IF (G(J,L+1) .EQ. 0.0) GO TO 130
         X(J) = (X(J) - S)/G(J,L+1)
  120 CONTINUE
      RETURN
C
C            A ZERO DIAGONAL TERM OCCURS
C
  130 IERR = 1
      RETURN
      END
      SUBROUTINE SPFIT2 (X, WX, MX, Y, WY, MY, Z, KZ, XBREAK, NX,
     *                   YBREAK, NY, F, S, T, WK, NUM, IERR)
C-----------------------------------------------------------------------
C
C            WEIGHTED LEAST SQUARES BICUBIC SPLINE FITTING
C
C                          -----------------
C
C     THE PIECEWISE POLYNOMIALS CONSIDERED ARE TENSOR PRODUCTS OF
C     B-SPLINES, HAVING THE FORM
C
C                          M    N
C              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
C                         I=1  J=1   IJ  I     J
C
C     WHERE M = NX + 2 AND N = NY + 2, AND U  AND V  ARE B-SPLINE
C     BASIS FUNCTIONS OF DEGREE 3. LET      I      J
C
C                       M
C              G (X) = SUM A   U (X)
C               J      I=1  IJ  I
C
C     FOR J = 1,...,N. THEN G (X),...,G (X) ARE CUBIC SPLINES AND
C                            1         N
C                        N
C              F(X,Y) = SUM G (X) V (Y) .
C                       J=1  J     J
C
C     THE ARRAYS S AND T DEFINED IN THE CODE ARE THE KNOT SEQUENCES
C     FOR THE B-SPLINES U (X) AND V (Y).
C                        I         J
C-----------------------------------------------------------------------
C     WRITTEN BY
C        ALFRED H. MORRIS, JR.
C        NAVAL SURFACE WARFARE CENTER
C        DAHLGREN, VIRGINIA
C-----------------------------------------------------------------------
      REAL X(MX), WX(MX), Y(MY), WY(MY), Z(KZ, MY)
      REAL XBREAK(NX), YBREAK(NY), F(*)
      REAL S(*), T(*), WK(NUM)
C---------------------
C     REAL F(4*NX*NY), S(NX + 6), T(NY + 6)
C---------------------
      IF (NX .LT. 2) GO TO 100
      IF (NY .LT. 2) GO TO 120
      M = NX + 2
      N = NY + 2
      L = MAX0(M*N, M*MY + 5*MAX0(M,N))
      IF (NUM .LT. L) GO TO 130
C
C     DEFINE THE KNOT SQUENCES
C
      S(1) = XBREAK(1)
      S(2) = XBREAK(1)
      S(3) = XBREAK(1)
      S(4) = XBREAK(1)
      DO 10 I = 2,NX
         IF (XBREAK(I - 1) .GE. XBREAK(I)) GO TO 100
         S(I + 3) = XBREAK(I)
   10 CONTINUE
      S(NX + 4) = XBREAK(NX)
      S(NX + 5) = XBREAK(NX)
      S(NX + 6) = XBREAK(NX)
C
      T(1) = YBREAK(1)
      T(2) = YBREAK(1)
      T(3) = YBREAK(1)
      T(4) = YBREAK(1)
      DO 20 J = 2,NY
         IF (YBREAK(J - 1) .GE. YBREAK(J)) GO TO 120
         T(J + 3) = YBREAK(J)
   20 CONTINUE
      T(NY + 4) = YBREAK(NY)
      T(NY + 5) = YBREAK(NY)
      T(NY + 6) = YBREAK(NY)
C
C     OBTAIN THE B-SPLINE COEFFICIENTS OF THE BIVARIATE
C     LEAST SQUARES FIT AND STORE THEM IN WK.
C
      CALL BSLSQ2 (X, WX, MX, Y, WY, MY, Z, KZ, S, M, 4,
     *             T, N, 4, F, M, WK, NUM, IERR)
      IF (IERR .LT. 0) GO TO 110
      IERR = 0
C
      L = M*N
      DO 30 I = 1,L
         WK(I) = F(I)
   30 CONTINUE
C
C     COMPUTE THE N CUBIC SPLINES G (X) AND THEIR FIRST
C                                  J
C     DERIVATIVES AT THE POINTS IN XBREAK. THEN STORE THE
C     DERIVATIVES IN WK. (THE VALUES OF THE SPLINES WILL
C     BE IN THE LATTER HALF OF F.)
C
      NU = NX*NY
      L = 2*NU + 1
      CALL CSPP (S, WK, M, M, N, F(L), N, F(1), N)
C
      IMAX = N*NX
      DO 40 I = 1,IMAX
         WK(I) = F(I)
   40 CONTINUE
C
C     COMPUTE THE VALUES OF THE BISPLINE AND THEIR PARTIAL
C     DERIVATIVES WITH RESPECT TO Y. THE RESULTS ARE STORED
C     IN THE FIRST HALF OF F.
C
      LD = NU + 1
      CALL CSPP (T, F(L), N, N, NX, F(1), NX, F(LD), NX)
C
C     COMPUTE THE REMAINING PARTIAL DERIVATIVES AND STORE
C     THE RESULTS IN THE LATTER HALF OF F.
C
      LD = L + NU
      CALL CSPP (T, WK, N, N, NX, F(L), NX, F(LD), NX)
      RETURN
C
C     ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      IF (IERR .EQ. -2) IERR = 4
      RETURN
  120 IERR = 3
      RETURN
  130 IERR = 5
      WK(1) = L
      RETURN
      END
      SUBROUTINE CSPP (T, A, KA, M, N, Z, KZ, DZ, KDZ)
C-----------------------------------------------------------------------
C
C            COMPUTATION OF N CUBIC SPLINES AND THEIR FIRST
C            DERIVATIVES AT THE KNOTS T(4),...,T(M+1). THE
C            CUBIC SPLINES ARE REPRESENTED IN B-SPLINE FORM.
C
C                          ---------------
C
C     INPUT ...
C
C       T     KNOT SEQUENCE OF LENGTH M+4.
C       A     M X N MATRIX. EACH COLUMN OF A IS A SEQUENCE
C             OF M B-SPLINE COEFFICIENTS FOR A CUBIC SPLINE.
C       KA    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
C             PROGRAM FOR A. IT IS ASSUMED THAT KA .GE. M.
C       M     DIMENSION OF THE B-SPLINE SPACE.
C       N     NUMBER OF CUBIC SPLINES CONSIDERED.
C       KZ    THE NUMBER OF ROWS SPECIFIED IN THE CALLING
C             PROGRAM FOR Z. IT IS ASSUMED THAT KZ .GE. N.
C       KDZ   THE NUMBER OF ROWS SPECIFIED IN THE CALLING
C             PROGRAM FOR DZ. IT IS ASSUMED THAT KZ .GE. N.
C
C     OUTPUT ...
C
C       Z     N X (M-2) MATRIX WHERE Z(J,I) = VALUE OF J-TH CUBIC
C             SPLINE AT THE POINT T(I+3) FOR I = 1,...,M-2.
C
C       DZ    N X (M-2) MATRIX WHERE DZ(J,I) = FIRST DERIVATIVE OF
C             THE J-TH CUBIC SPLINE EVALUATED AT THE POINT T(I+3).
C
C-----------------------------------------------------------------------
      REAL T(*), A(KA,N), Z(KZ,*), DZ(KDZ,*)
      REAL C(4), WK(4,5)
C
      K = 4
      MP1 = M + 1
      DO 70 MU = 1,N
C
C        OBTAING THE VALUES FOR THE MU-TH CUBIC SPLINE
C
         L = 0
         DO 60 LEFT = K,M
            L = L + 1
C
C           COMPUTE THE COEFFICIENTS FOR THE L-TH
C           POLYNOMIAL FORMING THE CUBIC SPLINE. THE
C           COEFFICIENTS ARE STORED IN C. THIS CODE
C           IS FROM THE SUBROUTINE BSPP.
C
            DO 10 J = 1,K
               JJ = LEFT - K + J
               WK(J,1) = A(JJ,MU)
   10       CONTINUE
C
            DO 21 J = 1,3
               JP1 = J + 1
               KMJ = K - J
               DO 20 I = 1,KMJ
                  IL = I + LEFT
                  ILKJ = IL - KMJ
                  DIFF = T(IL) - T(ILKJ)
                  WK(I,JP1) = (WK(I+1,J) - WK(I,J))/DIFF
   20          CONTINUE
   21       CONTINUE
C
            WK(1,5) = 1.0
            X = T(LEFT)
            C(4) = WK(1,4)
            R = 1.0
            DO 50 J = 1,3
               JP1 = J + 1
               S = 0.0
               DO 30 I = 1,J
                  IL = I + LEFT
                  ILJ = IL - J
                  TERM = WK(I,5)/(T(IL) - T(ILJ))
                  WK(I,5) = S + (T(IL) - X)*TERM
                  S = (X - T(ILJ))*TERM
   30          CONTINUE
               WK(JP1,5) = S
C
               S = 0.0
               KMJ = K - J
               DO 40 I = 1,JP1
                  S = S + WK(I,KMJ)*WK(I,5)
   40          CONTINUE
               R = (R*FLOAT(KMJ))/FLOAT(J)
               C(KMJ) = R*S
   50       CONTINUE
C
C           STORE THE VALUE OF THE SPLINE AND ITS
C           FIRST DERIVATIVE AT THE KNOT T(LEFT)
C
            Z(MU,L) = C(1)
            DZ(MU,L) = C(2)
   60    CONTINUE
C
C        COMPUTE THE SPLINE AND ITS FIRST DERIVATIVE
C                    AT THE KNOT T(M+1)
C
         L = L + 1
         DEL = T(MP1) - T(M)
         Z(MU,L) = ((C(4)*DEL + C(3))*DEL + C(2))*DEL + C(1)
         DZ(MU,L) = (3.0*C(4)*DEL + 2.0*C(3))*DEL + C(2)
   70 CONTINUE
      RETURN
      END
      SUBROUTINE CSURF (IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N,
     *                  F, KF, F1, KF1, F2, KF2, F12, KF12)
C-----------------------------------------------------------------------
C
C             EVALUATION OR DIFFERENTIATION OF A BICUBIC
C                        SPLINE OVER A GRID
C
C-----------------------------------------------------------------------
      REAL X(MX), Y(MY), Z(KZ,MY)
      REAL S(M), T(N), F(KF,N), F1(KF1,N), F2(KF2,N), F12(KF12,N)
C
      IF (IDER .GT. 3 .OR. JDER .GT. 3) GO TO 400
      MM1 = M - 1
      NM1 = N - 1
C
      IOLD = 0
      JOLD = 0
      DO 360 L = 1,MY
         YY = Y(L)
         IF (YY .LT. T(2)) GO TO 10
         IF (YY .GE. T(NM1)) GO TO 20
         IF (L .EQ. 1) GO TO 30
         IF (YY - Y(L-1)) 30,50,40
C
   10    J = 1
         GO TO 50
   20    J = NM1
         GO TO 50
   30    J = INTRVL (YY, T, N)
         GO TO 50
C
C        LINEAR FORWARD SEARCH
C
   40    IF (YY .LT. T(J + 1)) GO TO 50
         J = J + 1
         GO TO 40
C
   50    JP1 = J + 1
         DT = T(JP1) - T(J)
C
         DO 350 K = 1,MX
            XX = X(K)
            IF (XX .LT. S(2)) GO TO 100
            IF (XX .GE. S(MM1)) GO TO 110
            IF (K .EQ. 1) GO TO 120
            IF (XX - X(K-1)) 120,130,140
C
  100       I = 1
            IF (I .EQ. IOLD .AND. J .EQ. JOLD) GO TO 210
            GO TO 200
  110       I = MM1
            IF (I .EQ. IOLD .AND. J .EQ. JOLD) GO TO 210
            GO TO 200
  120       I = INTRVL (XX, S, M)
            IF (I .EQ. IOLD .AND. J .EQ. JOLD) GO TO 210
            GO TO 200
  130       Z(K,L) = Z(K-1,L)
            GO TO 350
C
C           LINEAR FORWARD SEARCH
C
  140       IF (XX .LT. S(I + 1)) GO TO 210
  150          I = I + 1
               IF (XX .GE. S(I + 1)) GO TO 150
C
C           COMPUTATION OF THE JDER-TH DERIVATIVE OF
C           F(S(I),Y), D1F(S(I),Y), F(S(I+1),Y), AND
C           D1F(S(I+1),Y) AT THE POINT YY.
C
  200          IOLD = I
               IP1 = I + 1
               DS = S(IP1) - S(I)
C
               D = (F(I,JP1) - F(I,J))/DT
               A = F2(I,J) + F2(I,JP1)
               B = (-A - F2(I,J) + 3.0*D)/DT
               C = (A - D - D)/(DT*DT)
C
               D = (F(IP1,JP1) - F(IP1,J))/DT
               A = F2(IP1,J) + F2(IP1,JP1)
               B1 = (-A - F2(IP1,J) + 3.0*D)/DT
               C1 = (A - D - D)/(DT*DT)
C
               D = (F1(I,JP1) - F1(I,J))/DT
               A = F12(I,J) + F12(I,JP1)
               B2 = (-A - F12(I,J) + 3.0*D)/DT
               C2 = (A - D - D)/(DT*DT)
C
               D = (F1(IP1,JP1) - F1(IP1,J))/DT
               A = F12(IP1,J) + F12(IP1,JP1)
               B3 = (-A - F12(IP1,J) + 3.0*D)/DT
               C3 = (A - D - D)/(DT*DT)
C
  210       DY = YY - T(J)
            IF (JDER .EQ. 0) GO TO 220
            IF (JDER - 2) 230,240,250
C
  220       FI = ((C*DY + B)*DY + F2(I,J))*DY + F(I,J)
            FIP1 = ((C1*DY + B1)*DY + F2(IP1,J))*DY + F(IP1,J)
            DFI = ((C2*DY + B2)*DY + F12(I,J))*DY + F1(I,J)
            DFIP1 = ((C3*DY + B3)*DY + F12(IP1,J))*DY + F1(IP1,J)
            GO TO 300
C
  230       FI = (3.0*C*DY + 2.0*B)*DY + F2(I,J)
            FIP1 = (3.0*C1*DY + 2.0*B1)*DY + F2(IP1,J)
            DFI = (3.0*C2*DY + 2.0*B2)*DY + F12(I,J)
            DFIP1 = (3.0*C3*DY + 2.0*B3)*DY + F12(IP1,J)
            GO TO 300
C
  240       FI = 6.0*C*DY + 2.0*B
            FIP1 = 6.0*C1*DY + 2.0*B1
            DFI = 6.0*C2*DY + 2.0*B2
            DFIP1 = 6.0*C3*DY + 2.0*B3
            GO TO 300
C
  250       FI = 6.0*C
            FIP1 = 6.0*C1
            DFI = 6.0*C2
            DFIP1 = 6.0*C3
C
C           COMPUTATION OF THE IDER-TH DERIVATIVE
C           AT THE POINT XX.
C
  300       D = (FIP1 - FI)/DS
            A = DFI + DFIP1
            BX = (-A - DFI + 3.0*D)/DS
            CX = (A - D - D)/(DS*DS)
C
            DX = XX - S(I)
            IF (IDER .EQ. 0) GO TO 310
            IF (IDER - 2) 320,330,340
C
  310       Z(K,L) = ((CX*DX + BX)*DX + DFI)*DX + FI
            GO TO 350
  320       Z(K,L) = (3.0*CX*DX + 2.0*BX)*DX + DFI
            GO TO 350
  330       Z(K,L) = 6.0*CX*DX + 2.0*BX
            GO TO 350
  340       Z(K,L) = 6.0*CX
C
  350    CONTINUE
         JOLD = J
  360 CONTINUE
      RETURN
C
C     CASE WHEN THE RESULTS ARE ZERO.
C
  400 DO 420 L = 1,MY
         DO 410 K = 1,MX
            Z(K,L) = 0.0
  410    CONTINUE
  420 CONTINUE
      RETURN
      END
      SUBROUTINE CSURF1 (IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F)
C-----------------------------------------------------------------------
C
C             EVALUATION OR DIFFERENTIATION OF A BICUBIC
C                        SPLINE OVER A GRID
C
C-----------------------------------------------------------------------
      REAL X(MX), Y(MY), Z(KZ,MY)
      REAL S(M), T(N), F(M,N,4)
C
      CALL CSURF (IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, M,
     *            F(1,1,3), M, F(1,1,2), M, F(1,1,4), M)
      RETURN
      END
      SUBROUTINE CSRF (IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N,
     *                 F, KF, F1, KF1, F2, KF2, F12, KF12)
C-----------------------------------------------------------------------
C
C             EVALUATION OR DIFFERENTIATION OF A BICUBIC
C                        SPLINE OVER A GRID
C
C-----------------------------------------------------------------------
      REAL X(MX), Y(MY), Z(KZ,MY)
      REAL S(M), T(N), F(KF,N), F1(KF1,N), F2(KF2,N), F12(KF12,N)
C
      IF (IDER .GT. 3 .OR. JDER .GT. 3) GO TO 400
      MM1 = M - 1
      NM1 = N - 1
C
      IOLD = 0
      JOLD = 0
      DO 360 L = 1,MY
         YY = Y(L)
         IF (YY .LT. T(2)) GO TO 10
         IF (YY .GE. T(NM1)) GO TO 20
         IF (L .EQ. 1) GO TO 30
         IF (YY - Y(L-1)) 30,50,40
C
   10    J = 1
         GO TO 50
   20    J = NM1
         GO TO 50
   30    J = INTRVL (YY, T, N)
         GO TO 50
C
C        LINEAR FORWARD SEARCH
C
   40    IF (YY .LT. T(J + 1)) GO TO 50
         J = J + 1
         GO TO 40
C
   50    JP1 = J + 1
         DT = T(JP1) - T(J)
C
         DO 350 K = 1,MX
            XX = X(K)
            IF (XX .LT. S(2)) GO TO 100
            IF (XX .GE. S(MM1)) GO TO 110
            IF (K .EQ. 1) GO TO 120
            IF (XX - X(K-1)) 120,130,140
C
  100       I = 1
            IF (I .EQ. IOLD .AND. J .EQ. JOLD) GO TO 210
            GO TO 200
  110       I = MM1
            IF (I .EQ. IOLD .AND. J .EQ. JOLD) GO TO 210
            GO TO 200
  120       I = INTRVL (XX, S, M)
            IF (I .EQ. IOLD .AND. J .EQ. JOLD) GO TO 210
            GO TO 200
  130       Z(K,L) = Z(K-1,L)
            GO TO 350
C
C           LINEAR FORWARD SEARCH
C
  140       IF (XX .LT. S(I + 1)) GO TO 210
  150          I = I + 1
               IF (XX .GE. S(I + 1)) GO TO 150
C
C           COMPUTATION OF THE JDER-TH DERIVATIVE OF
C           F(S(I),Y), D1F(S(I),Y), F(S(I+1),Y), AND
C           D1F(S(I+1),Y) AT THE POINT YY.
C
  200          IOLD = I
               IP1 = I + 1
               DS = S(IP1) - S(I)
C
               D = (F(I,JP1) - F(I,J))/DT
               A = D - DT*(2.0*F2(I,J) + F2(I,JP1))/6.0
               C = (F2(I,JP1) - F2(I,J))/(6.0*DT)
C
               D = (F(IP1,JP1) - F(IP1,J))/DT
               A1 = D - DT*(2.0*F2(IP1,J) + F2(IP1,JP1))/6.0
               C1 = (F2(IP1,JP1) - F2(IP1,J))/(6.0*DT)
C
               D = (F1(I,JP1) - F1(I,J))/DT
               A2 = D - DT*(2.0*F12(I,J) + F12(I,JP1))/6.0
               C2 = (F12(I,JP1) - F12(I,J))/(6.0*DT)
C
               D = (F1(IP1,JP1) - F1(IP1,J))/DT
               A3 = D - DT*(2.0*F12(IP1,J) + F12(IP1,JP1))/6.0
               C3 = (F12(IP1,JP1) - F12(IP1,J))/(6.0*DT)
C
  210       DY = YY - T(J)
            IF (JDER .EQ. 0) GO TO 220
            IF (JDER - 2) 230,240,250
C
  220       FI = ((C*DY + 0.5*F2(I,J))*DY + A)*DY + F(I,J)
            FIP1 = ((C1*DY + 0.5*F2(IP1,J))*DY + A1)*DY + F(IP1,J)
            DFI = ((C2*DY + 0.5*F12(I,J))*DY + A2)*DY + F1(I,J)
            DFIP1 = ((C3*DY + 0.5*F12(IP1,J))*DY + A3)*DY + F1(IP1,J)
            GO TO 300
C
  230       FI = (3.0*C*DY + F2(I,J))*DY + A
            FIP1 = (3.0*C1*DY + F2(IP1,J))*DY + A1
            DFI = (3.0*C2*DY + F12(I,J))*DY + A2
            DFIP1 = (3.0*C3*DY + F12(IP1,J))*DY + A3
            GO TO 300
C
  240       FI = 6.0*C*DY + F2(I,J)
            FIP1 = 6.0*C1*DY + F2(IP1,J)
            DFI = 6.0*C2*DY + F12(I,J)
            DFIP1 = 6.0*C3*DY + F12(IP1,J)
            GO TO 300
C
  250       FI = 6.0*C
            FIP1 = 6.0*C1
            DFI = 6.0*C2
            DFIP1 = 6.0*C3
C
C           COMPUTATION OF THE IDER-TH DERIVATIVE
C           AT THE POINT XX.
C
  300       D = (FIP1 - FI)/DS
            AX = D - DS*(2.0*DFI + DFIP1)/6.0
            CX = (DFIP1 - DFI)/(6.0*DS)
C
            DX = XX - S(I)
            IF (IDER .EQ. 0) GO TO 310
            IF (IDER - 2) 320,330,340
C
  310       Z(K,L) = ((CX*DX + 0.5*DFI)*DX + AX)*DX + FI
            GO TO 350
  320       Z(K,L) = (3.0*CX*DX + DFI)*DX + AX
            GO TO 350
  330       Z(K,L) = 6.0*CX*DX + DFI
            GO TO 350
  340       Z(K,L) = 6.0*CX
C
  350    CONTINUE
         JOLD = J
  360 CONTINUE
      RETURN
C
C     CASE WHEN THE RESULTS ARE ZERO.
C
  400 DO 420 L = 1,MY
         DO 410 K = 1,MX
            Z(K,L) = 0.0
  410    CONTINUE
  420 CONTINUE
      RETURN
      END
      SUBROUTINE CSRF2 (IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N,
     *                  F, KF, DDF)
C-----------------------------------------------------------------------
C
C             EVALUATION OR DIFFERENTIATION OF A BICUBIC
C                        SPLINE OVER A GRID
C
C-----------------------------------------------------------------------
      REAL X(MX), Y(MY), Z(KZ,MY)
      REAL S(M), T(N), F(KF,N), DDF(M,N,3)
C
      CALL CSRF (IDER, JDER, X, MX, Y, MY, Z, KZ, S, M, T, N, F, KF,
     *           DDF(1,1,2), M, DDF, M, DDF(1,1,3), M)
      RETURN
      END
      SUBROUTINE SURF (M,N,X,Y,Z,IZ,OPT,ZP,TEMP,SIGMA,IERR)
C
      INTEGER M,N,IZ,IERR
      REAL X(M),Y(N),Z(IZ,N),OPT(*),ZP(M,N,*),TEMP(*),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C                               MODIFIED BY ALFRED H. MORRIS
C                               NAVAL SURFACE WEAPONS CENTER
C                                          DAHLGREN VIRGINIA
C
C THIS SUBROUTINE DETERMINES THE PARAMETERS NECESSARY TO
C COMPUTE AN INTERPOLATORY SURFACE PASSING THROUGH A RECT-
C ANGULAR GRID OF FUNCTIONAL VALUES. THE SURFACE DETERMINED
C CAN BE REPRESENTED AS THE TENSOR PRODUCT OF SPLINES UNDER
C TENSION. THE X- AND Y-PARTIAL DERIVATIVES AROUND THE
C BOUNDARY AND THE X-Y-PARTIAL DERIVATIVES AT THE FOUR
C CORNERS MAY BE SPECIFIED OR OMITTED. FOR ACTUAL MAPPING
C OF POINTS ONTO THE SURFACE IT IS NECESSARY TO CALL THE
C FUNCTION SURF2.
C
C ON INPUT--
C
C   M IS THE NUMBER OF GRID LINES IN THE X-DIRECTION, I. E.
C   LINES PARALLEL TO THE Y-AXIS (M .GE. 2).
C
C   N IS THE NUMBER OF GRID LINES IN THE Y-DIRECTION, I. E.
C   LINES PARALLEL TO THE X-AXIS (N .GE. 2).
C
C   X IS AN ARRAY OF THE M X-COORDINATES OF THE GRID LINES
C   IN THE X-DIRECTION. THESE SHOULD BE STRICTLY INCREASING.
C
C   Y IS AN ARRAY OF THE N Y-COORDINATES OF THE GRID LINES
C   IN THE Y-DIRECTION. THESE SHOULD BE STRICTLY INCREASING.
C
C   Z IS AN ARRAY OF THE M * N FUNCTIONAL VALUES AT THE GRID
C   POINTS, I. E. Z(I,J) CONTAINS THE FUNCTIONAL VALUE AT
C   (X(I),Y(J)) FOR I = 1,...,M AND J = 1,...,N.
C
C   IZ IS THE ROW DIMENSION OF THE MATRIX Z USED IN THE
C   CALLING PROGRAM (IZ .GE. M).
C
C   OPT IS AN OPTION VECTOR. IF NO BOUNDARY CONDITIONS ARE
C   TO BE IMPOSED ON THE SURFACE THEN LET OPT BE OF LENGTH 1
C   AND SET OPT(1)=0. OTHERWISE, SEE THE DESCRIPTION OF SURF
C   IN THE NSWC LIBRARY MANUAL.
C
C   ZP IS AN ARRAY OF AT LEAST 3*M*N LOCATIONS.
C
C   TEMP IS AN ARRAY OF AT LEAST N+N+M LOCATIONS WHICH IS
C   USED FOR SCRATCH STORAGE.
C
C   SIGMA CONTAINS THE TENSION FACTOR. THIS VALUE INDICATES
C   THE CURVINESS DESIRED. IF ABS(SIGMA) IS NEARLY ZERO
C   (E. G. .001) THE RESULTING SURFACE IS APPROXIMATELY THE
C   TENSOR PRODUCT OF CUBIC SPLINES. IF ABS(SIGMA) IS LARGE
C   (E. G. 50.) THE RESULTING SURFACE IS APPROXIMATELY
C   BI-LINEAR. IF SIGMA EQUALS ZERO TENSOR PRODUCTS OF
C   CUBIC SPLINES RESULT. A STANDARD VALUE FOR SIGMA IS
C   APPROXIMATELY 1. IN ABSOLUTE VALUE.
C
C ON OUTPUT--
C
C   ZP CONTAINS THE VALUES OF THE XX-, YY-, AND XXYY-PARTIAL
C   DERIVATIVES OF THE SURFACE AT THE GIVEN NODES.
C
C   IERR CONTAINS AN ERROR FLAG,
C        = 0 FOR NORMAL RETURN,
C        = 1 IF N IS LESS THAN 2 OR M IS LESS THAN 2,
C        = 2 IF THE X-VALUES OR Y-VALUES ARE NOT STRICTLY
C            INCREASING,
C        = 3 THE OPTION VECTOR HAS AN ERROR.
C
C THIS SUBROUTINE REFERENCES PACKAGE MODULES CEEZ, TERMS,
C AND SNHCSH.
C
C-----------------------------------------------------------
C
      INTEGER IND(8),LOC(8),NUM(8)
      DATA NUM(5)/1/, NUM(6)/1/, NUM(7)/1/, NUM(8)/1/
C
      MM1 = M-1
      MP1 = M+1
      NM1 = N-1
      NP1 = N+1
      NPM = N+M
      IERR = 0
      IF (N .LE. 1 .OR. M .LE. 1) GO TO 46
      IF (Y(N) .LE. Y(1)) GO TO 47
C
C PROCESS THE OPTION VECTOR
C
      NUM(1) = N
      NUM(2) = N
      NUM(3) = M
      NUM(4) = M
      IND(1) = 0
      IND(2) = 0
      IND(3) = 0
      IND(4) = 0
      IND(5) = 0
      IND(6) = 0
      IND(7) = 0
      IND(8) = 0
C
      L = 1
  100 KEY = OPT(L)
      IF (KEY) 48,110,101
  101 IF (KEY .GT. 8) GO TO 48
      IND(KEY) = 1
      L = L+1
      LOC(KEY) = L
      L = L + NUM(KEY)
      GO TO 100
C
C DENORMALIZE TENSION FACTOR IN Y-DIRECTION
C
  110 SIGMAY = ABS(SIGMA)*FLOAT(N-1)/(Y(N)-Y(1))
C
C OBTAIN Y-PARTIAL DERIVATIVES ALONG Y = Y(1)
C
      IF (IND(3) .EQ. 0) GO TO 2
      L = LOC(3)
      DO 1 I = 1,M
        ZP(I,1,1) = OPT(L)
    1   L = L+1
      GO TO 5
    2 DELY1 = Y(2)-Y(1)
      DELY2 = DELY1+DELY1
      IF (N .GT. 2) DELY2 = Y(3)-Y(1)
      IF (DELY1 .LE. 0. .OR. DELY2 .LE. DELY1) GO TO 47
      CALL CEEZ (DELY1,DELY2,SIGMAY,C1,C2,C3,N)
      DO 3 I = 1,M
    3   ZP(I,1,1) = C1*Z(I,1)+C2*Z(I,2)
      IF (N .EQ. 2) GO TO 5
      DO 4 I = 1,M
    4   ZP(I,1,1) = ZP(I,1,1)+C3*Z(I,3)
C
C OBTAIN Y-PARTIAL DERIVATIVES ALONG Y = Y(N)
C
    5 IF (IND(4) .EQ. 0) GO TO 7
      L = LOC(4)
      DO 6 I = 1,M
        NPI = N+I
        TEMP(NPI) = OPT(L)
    6   L = L+1
      GO TO 10
    7 DELYN = Y(N)-Y(NM1)
      DELYNM = DELYN+DELYN
      IF (N .GT. 2) DELYNM = Y(N)-Y(N-2)
      IF (DELYN .LE. 0. .OR. DELYNM .LE. DELYN) GO TO 47
      CALL CEEZ (-DELYN,-DELYNM,SIGMAY,C1,C2,C3,N)
      DO 8 I = 1,M
        NPI = N+I
    8   TEMP(NPI) = C1*Z(I,N)+C2*Z(I,NM1)
      IF (N .EQ. 2) GO TO 10
      DO 9 I = 1,M
        NPI = N+I
    9   TEMP(NPI) = TEMP(NPI)+C3*Z(I,N-2)
   10 IF (X(M) .LE. X(1)) GO TO 47
C
C DENORMALIZE TENSION FACTOR IN X-DIRECTION
C
      SIGMAX = ABS(SIGMA)*FLOAT(M-1)/(X(M)-X(1))
C
C OBTAIN X-PARTIAL DERIVATIVES ALONG X = X(1)
C
      IF (IND(1) .EQ. 0) GO TO 12
      L = LOC(1)
      DO 11 J = 1,N
        ZP(1,J,2) = OPT(L)
   11   L = L+1
      IF (IND(5)+IND(7) .EQ. 2) GO TO 15
   12 DELX1 = X(2)-X(1)
      DELX2 = DELX1+DELX1
      IF (M .GT. 2) DELX2 = X(3)-X(1)
      IF (DELX1 .LE. 0. .OR. DELX2 .LE. DELX1) GO TO 47
      CALL CEEZ (DELX1,DELX2,SIGMAX,C1,C2,C3,M)
      IF (IND(1) .EQ. 1) GO TO 15
      DO 13 J = 1,N
   13   ZP(1,J,2) = C1*Z(1,J)+C2*Z(2,J)
      IF (M .EQ. 2) GO TO 15
      DO 14 J = 1,N
   14   ZP(1,J,2) = ZP(1,J,2)+C3*Z(3,J)
C
C OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(1),Y(1))
C
   15 IF (IND(5) .EQ. 0) GO TO 16
      L = LOC(5)
      ZP(1,1,3) = OPT(L)
      GO TO 17
   16 ZP(1,1,3) = C1*ZP(1,1,1)+C2*ZP(2,1,1)
      IF (M .GT. 2) ZP(1,1,3) = ZP(1,1,3)+C3*ZP(3,1,1)
C
C OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(1),Y(N))
C
   17 IF (IND(7) .EQ. 0) GO TO 18
      L = LOC(7)
      ZXY1NS = OPT(L)
      GO TO 19
   18 ZXY1NS = C1*TEMP(N+1)+C2*TEMP(N+2)
      IF (M .GT. 2) ZXY1NS = ZXY1NS+C3*TEMP(N+3)
C
C OBTAIN X-PARTIAL DERIVATIVE ALONG X = X(M)
C
   19 IF (IND(2) .EQ. 0) GO TO 21
      L = LOC(2)
      DO 20 J = 1,N
        NPMPJ = NPM+J
        TEMP(NPMPJ) = OPT(L)
   20   L = L+1
   21 IF (IND(6)+IND(8) .EQ. 2) GO TO 24
      DELXM = X(M)-X(MM1)
      DELXMM = DELXM+DELXM
      IF (M .GT. 2) DELXMM = X(M)-X(M-2)
      IF (DELXM .LE. 0. .OR. DELXMM .LE. DELXM) GO TO 47
      CALL CEEZ (-DELXM,-DELXMM,SIGMAX,C1,C2,C3,M)
      IF (IND(2) .EQ. 1) GO TO 24
      DO 22 J = 1,N
        NPMPJ = NPM+J
   22   TEMP(NPMPJ) = C1*Z(M,J)+C2*Z(MM1,J)
      IF (M .EQ. 2) GO TO 24
      DO 23 J = 1,N
        NPMPJ = NPM+J
   23   TEMP(NPMPJ) = TEMP(NPMPJ)+C3*Z(M-2,J)
C
C OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(M),Y(1))
C
   24 IF (IND(6) .EQ. 0) GO TO 25
      L = LOC(6)
      ZP(M,1,3) = OPT(L)
      GO TO 26
   25 ZP(M,1,3) = C1*ZP(M,1,1)+C2*ZP(MM1,1,1)
      IF (M .GT. 2) ZP(M,1,3) = ZP(M,1,3)+C3*ZP(M-2,1,1)
C
C OBTAIN X-Y-PARTIAL DERIVATIVE AT (X(M),Y(N))
C
   26 IF (IND(8) .EQ. 0) GO TO 27
      L = LOC(8)
      ZXYMNS = OPT(L)
      GO TO 28
   27 ZXYMNS = C1*TEMP(NPM)+C2*TEMP(NPM-1)
      IF (M .GT. 2) ZXYMNS = ZXYMNS+C3*TEMP(NPM-2)
C
C SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR Y-GRID
C PERFORM FORWARD ELIMINATION
C
   28 DEL1 = Y(2)-Y(1)
      IF (DEL1 .LE. 0.) GO TO 47
      DELI = 1./DEL1
      DO 29 I = 1,M
   29   ZP(I,2,1) = DELI*(Z(I,2)-Z(I,1))
      ZP(1,2,3) = DELI*(ZP(1,2,2)-ZP(1,1,2))
      ZP(M,2,3) = DELI*(TEMP(NPM+2)-TEMP(NPM+1))
      CALL TERMS (DIAG1,SDIAG1,SIGMAY,DEL1)
      DIAGI = 1./DIAG1
      DO 30 I = 1,M
   30   ZP(I,1,1) = DIAGI*(ZP(I,2,1)-ZP(I,1,1))
      ZP(1,1,3) = DIAGI*(ZP(1,2,3)-ZP(1,1,3))
      ZP(M,1,3) = DIAGI*(ZP(M,2,3)-ZP(M,1,3))
      TEMP(1) = DIAGI*SDIAG1
      IF (N .EQ. 2) GO TO 34
      DO 33 J = 2,NM1
        JM1 = J-1
        JP1 = J+1
        NPMPJ = NPM+J
        DEL2 = Y(JP1)-Y(J)
        IF (DEL2 .LE. 0.) GO TO 47
        DELI = 1./DEL2
        DO 31 I = 1,M
   31     ZP(I,JP1,1) = DELI*(Z(I,JP1)-Z(I,J))
        ZP(1,JP1,3) = DELI*(ZP(1,JP1,2)-ZP(1,J,2))
        ZP(M,JP1,3) = DELI*(TEMP(NPMPJ+1)-TEMP(NPMPJ))
        CALL TERMS (DIAG2,SDIAG2,SIGMAY,DEL2)
        DIAGIN = 1./(DIAG1+DIAG2-SDIAG1*TEMP(JM1))
        DO 32 I = 1,M
   32     ZP(I,J,1) = DIAGIN*(ZP(I,JP1,1)-ZP(I,J,1)-
     *                        SDIAG1*ZP(I,JM1,1))
        ZP(1,J,3) = DIAGIN*(ZP(1,JP1,3)-ZP(1,J,3)-
     *                      SDIAG1*ZP(1,JM1,3))
        ZP(M,J,3) = DIAGIN*(ZP(M,JP1,3)-ZP(M,J,3)-
     *                      SDIAG1*ZP(M,JM1,3))
        TEMP(J) = DIAGIN*SDIAG2
        DIAG1 = DIAG2
   33   SDIAG1 = SDIAG2
   34 DIAGIN = 1./(DIAG1-SDIAG1*TEMP(NM1))
      DO 35 I = 1,M
        NPI = N+I
   35   ZP(I,N,1) = DIAGIN*(TEMP(NPI)-ZP(I,N,1)-
     *                      SDIAG1*ZP(I,NM1,1))
      ZP(1,N,3) = DIAGIN*(ZXY1NS-ZP(1,N,3)-
     *                    SDIAG1*ZP(1,NM1,3))
      TEMP(N) = DIAGIN*(ZXYMNS-ZP(M,N,3)-
     *                  SDIAG1*ZP(M,NM1,3))
C
C PERFORM BACK SUBSTITUTION
C
      DO 37 J = 2,N
        JBAK = NP1-J
        JBAKP1 = JBAK+1
        T = TEMP(JBAK)
        DO 36 I = 1,M
   36     ZP(I,JBAK,1) = ZP(I,JBAK,1)-T*ZP(I,JBAKP1,1)
        ZP(1,JBAK,3) = ZP(1,JBAK,3)-T*ZP(1,JBAKP1,3)
   37   TEMP(JBAK) = ZP(M,JBAK,3)-T*TEMP(JBAKP1)
C
C SET UP RIGHT HAND SIDES AND TRIDIAGONAL SYSTEM FOR X-GRID
C PERFORM FORWARD ELIMINATION
C
      DEL1 = X(2)-X(1)
      IF (DEL1 .LE. 0.) GO TO 47
      DELI = 1./DEL1
      DO 38 J = 1,N
        ZP(2,J,2) = DELI*(Z(2,J)-Z(1,J))
   38   ZP(2,J,3) = DELI*(ZP(2,J,1)-ZP(1,J,1))
      CALL TERMS (DIAG1,SDIAG1,SIGMAX,DEL1)
      DIAGI = 1./DIAG1
      DO 39 J = 1,N
        ZP(1,J,2) = DIAGI*(ZP(2,J,2)-ZP(1,J,2))
   39   ZP(1,J,3) = DIAGI*(ZP(2,J,3)-ZP(1,J,3))
      TEMP(N+1) = DIAGI*SDIAG1
      IF (M  .EQ. 2) GO TO 43
      DO 42 I = 2,MM1
        IM1 = I-1
        IP1 = I+1
        NPI = N+I
        DEL2 = X(IP1)-X(I)
        IF (DEL2 .LE. 0.) GO TO 47
        DELI = 1./DEL2
        DO 40 J = 1,N
          ZP(IP1,J,2) = DELI*(Z(IP1,J)-Z(I,J))
   40     ZP(IP1,J,3) = DELI*(ZP(IP1,J,1)-ZP(I,J,1))
        CALL TERMS (DIAG2,SDIAG2,SIGMAX,DEL2)
        DIAGIN = 1./(DIAG1+DIAG2-SDIAG1*TEMP(NPI-1))
        DO 41 J = 1,N
          ZP(I,J,2) = DIAGIN*(ZP(IP1,J,2)-ZP(I,J,2)-
     *                        SDIAG1*ZP(IM1,J,2))
   41     ZP(I,J,3) = DIAGIN*(ZP(IP1,J,3)-ZP(I,J,3)-
     *                        SDIAG1*ZP(IM1,J,3))
        TEMP(NPI) = DIAGIN*SDIAG2
        DIAG1 = DIAG2
   42   SDIAG1 = SDIAG2
   43 DIAGIN = 1./(DIAG1-SDIAG1*TEMP(NPM-1))
      DO 44 J = 1,N
        NPMPJ = NPM+J
        ZP(M,J,2) = DIAGIN*(TEMP(NPMPJ)-ZP(M,J,2)-
     *                      SDIAG1*ZP(MM1,J,2))
   44   ZP(M,J,3) = DIAGIN*(TEMP(J)-ZP(M,J,3)-
     *                      SDIAG1*ZP(MM1,J,3))
C
C PERFORM BACK SUBSTITUTION
C
      DO 45 I = 2,M
        IBAK = MP1-I
        IBAKP1 = IBAK+1
        NPIBAK = N+IBAK
        T = TEMP(NPIBAK)
        DO 45 J = 1,N
          ZP(IBAK,J,2) = ZP(IBAK,J,2)-T*ZP(IBAKP1,J,2)
   45     ZP(IBAK,J,3) = ZP(IBAK,J,3)-T*ZP(IBAKP1,J,3)
      RETURN
C
C TOO FEW POINTS
C
   46 IERR = 1
      RETURN
C
C POINTS NOT STRICTLY INCREASING
C
   47 IERR = 2
      RETURN
C
C THE OPTION VECTOR HAS AN ERROR
C
   48 IERR = 3
      RETURN
      END
      FUNCTION SURF2 (XX,YY,M,N,X,Y,Z,IZ,ZP,SIGMA)
C
      INTEGER M,N,IZ
      REAL XX,YY,X(M),Y(N),Z(IZ,N),ZP(M,N,*),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                       CODED BY A. K. CLINE AND R. J. RENKA
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS FUNCTION INTERPOLATES A SURFACE AT A GIVEN COORDINATE
C PAIR USING A BI-SPLINE UNDER TENSION. THE SUBROUTINE SURF1
C SHOULD BE CALLED EARLIER TO DETERMINE CERTAIN NECESSARY
C PARAMETERS.
C
C ON INPUT--
C
C   XX AND YY CONTAIN THE X- AND Y-COORDINATES OF THE POINT
C   TO BE MAPPED ONTO THE INTERPOLATING SURFACE.
C
C   M AND N CONTAIN THE NUMBER OF GRID LINES IN THE X- AND
C   Y-DIRECTIONS, RESPECTIVELY, OF THE RECTANGULAR GRID
C   WHICH SPECIFIED THE SURFACE.
C
C   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-GRID VALUES,
C   RESPECTIVELY, EACH IN INCREASING ORDER.
C
C   Z IS A MATRIX CONTAINING THE M * N FUNCTIONAL VALUES
C   CORRESPONDING TO THE GRID VALUES (I. E. Z(I,J) IS THE
C   SURFACE VALUE AT THE POINT (X(I),Y(J)) FOR I = 1,...,M
C   AND J = 1,...,N).
C
C   IZ CONTAINS THE ROW DIMENSION OF THE ARRAY Z AS DECLARED
C   IN THE CALLING PROGRAM.
C
C   ZP IS AN ARRAY OF 3*M*N LOCATIONS STORED WITH THE
C   VARIOUS SURFACE DERIVATIVE INFORMATION DETERMINED BY
C   SURF1.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS M, N, X, Y, Z, IZ, ZP, AND SIGMA SHOULD BE
C INPUT UNALTERED FROM THE OUTPUT OF SURF1.
C
C ON OUTPUT--
C
C   SURF2 CONTAINS THE INTERPOLATED SURFACE VALUE.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS FUNCTION REFERENCES PACKAGE MODULES INTRVL AND
C SNHCSH.
C
C-----------------------------------------------------------
C
C INLINE ONE DIMENSIONAL CUBIC SPLINE INTERPOLATION
C
      HERMZ (F1,F2,FP1,FP2) = (F2*DEL1+F1*DEL2)/DELS-DEL1*
     *                        DEL2*(FP2*(DEL1+DELS)+
     *                              FP1*(DEL2+DELS))/
     *                        (6.*DELS)
C
C INLINE ONE DIMENSIONAL SPLINE UNDER TENSION INTERPOLATION
C
      HERMNZ (F1,F2,FP1,FP2,SIGMAP) = (F2*DEL1+F1*DEL2)/DELS
     *          +(FP2*(SINHM1*DEL2-DEL1*(2.*(COSHP1+1.)*
     *                           SINHP2+SIGMAP*COSHP1*DEL2))
     *           +FP1*(SINHM2*DEL1-DEL2*(2.*(COSHP2+1.)*
     *                           SINHP1+SIGMAP*COSHP2*DEL1))
     *          )/(SIGMAP*SIGMAP*DELS*(SINHMS+SIGMAP*DELS))
C
C DENORMALIZE TENSION FACTOR IN X AND Y DIRECTION
C
      SIGMAX = ABS(SIGMA)*FLOAT(M-1)/(X(M)-X(1))
      SIGMAY = ABS(SIGMA)*FLOAT(N-1)/(Y(N)-Y(1))
C
C DETERMINE Y INTERVAL
C
      JM1 = INTRVL (YY,Y,N)
      J = JM1+1
C
C DETERMINE X INTERVAL
C
      IM1 = INTRVL (XX,X,M)
      I = IM1+1
      DEL1 = YY-Y(JM1)
      DEL2 = Y(J)-YY
      DELS = Y(J)-Y(JM1)
      IF (SIGMAY .NE. 0.) GO TO 1
C
C PERFORM FOUR INTERPOLATIONS IN Y-DIRECTION
C
      ZIM1 = HERMZ(Z(I-1,J-1),Z(I-1,J),ZP(I-1,J-1,1),
     *                                  ZP(I-1,J,1))
      ZI = HERMZ(Z(I,J-1),Z(I,J),ZP(I,J-1,1),ZP(I,J,1))
      ZXXIM1 = HERMZ(ZP(I-1,J-1,2),ZP(I-1,J,2),
     *                ZP(I-1,J-1,3),ZP(I-1,J,3))
      ZXXI = HERMZ(ZP(I,J-1,2),ZP(I,J,2),
     *              ZP(I,J-1,3),ZP(I,J,3))
      GO TO 2
    1 DELP1 = (DEL1+DELS)/2.
      DELP2 = (DEL2+DELS)/2.
      CALL SNHCSH (SINHM1,DUMMY,SIGMAY*DEL1,-1)
      CALL SNHCSH (SINHM2,DUMMY,SIGMAY*DEL2,-1)
      CALL SNHCSH (SINHMS,DUMMY,SIGMAY*DELS,-1)
      CALL SNHCSH (SINHP1,DUMMY,SIGMAY*DEL1/2.,-1)
      CALL SNHCSH (SINHP2,DUMMY,SIGMAY*DEL2/2.,-1)
      CALL SNHCSH (DUMMY,COSHP1,SIGMAY*DELP1,1)
      CALL SNHCSH (DUMMY,COSHP2,SIGMAY*DELP2,1)
      ZIM1 = HERMNZ(Z(I-1,J-1),Z(I-1,J),ZP(I-1,J-1,1),
     *               ZP(I-1,J,1),SIGMAY)
      ZI = HERMNZ(Z(I,J-1),Z(I,J),ZP(I,J-1,1),ZP(I,J,1),
     *             SIGMAY)
      ZXXIM1 = HERMNZ(ZP(I-1,J-1,2),ZP(I-1,J,2),
     *                 ZP(I-1,J-1,3),ZP(I-1,J,3),SIGMAY)
      ZXXI = HERMNZ(ZP(I,J-1,2),ZP(I,J,2),
     *               ZP(I,J-1,3),ZP(I,J,3),SIGMAY)
C
C PERFORM FINAL INTERPOLATION IN X-DIRECTION
C
    2 DEL1 = XX-X(IM1)
      DEL2 = X(I)-XX
      DELS = X(I)-X(IM1)
      IF (SIGMAX .NE. 0.) GO TO 3
      SURF2 = HERMZ(ZIM1,ZI,ZXXIM1,ZXXI)
      RETURN
    3 DELP1 = (DEL1+DELS)/2.
      DELP2 = (DEL2+DELS)/2.
      CALL SNHCSH (SINHM1,DUMMY,SIGMAX*DEL1,-1)
      CALL SNHCSH (SINHM2,DUMMY,SIGMAX*DEL2,-1)
      CALL SNHCSH (SINHMS,DUMMY,SIGMAX*DELS,-1)
      CALL SNHCSH (SINHP1,DUMMY,SIGMAX*DEL1/2.,-1)
      CALL SNHCSH (SINHP2,DUMMY,SIGMAX*DEL2/2.,-1)
      CALL SNHCSH (DUMMY,COSHP1,SIGMAX*DELP1,1)
      CALL SNHCSH (DUMMY,COSHP2,SIGMAX*DELP2,1)
      SURF2 = HERMNZ(ZIM1,ZI,ZXXIM1,ZXXI,SIGMAX)
      RETURN
      END
      SUBROUTINE NSURF2 (DXMIN,DXMAX,MD,DYMIN,DYMAX,ND,DZ,
     *                   IDZ,M,N,X,Y,Z,IZ,ZP,WORK,SIGMA)
C
      INTEGER MD,ND,IDZ,M,N,IZ
      REAL DXMIN,DXMAX,DYMIN,DYMAX,DZ(IDZ,ND),X(M),Y(N),
     *     Z(IZ,N),ZP(M,N,*),WORK(4,MD),SIGMA
C
C                      FROM THE SPLINE UNDER TENSION PACKAGE
C                                 CODED BY ALAN KAYLOR CLINE
C                            DEPARTMENT OF COMPUTER SCIENCES
C                              UNIVERSITY OF TEXAS AT AUSTIN
C
C THIS SUBROUTINE MAPS VALUES ONTO A SURFACE AT EVERY POINT
C OF A GRID EQUALLY SPACED IN BOTH X AND Y COORDINATES. THE
C SURFACE INTERPOLATION IS PERFORMED USING A BI-SPLINE
C UNDER TENSION. THE SUBROUTINE SURF1 OR NSURF1 SHOULD BE
C CALLED EARLIER TO DETERMINE CERTAIN NECESSARY PARAMETERS.
C
C ON INPUT--
C
C   DXMIN AND DXMAX CONTAIN THE LOWER AND UPPER LIMITS,
C   RESPECTIVELY, OF THE X-COORDINATES OF THE SECOND GRID.
C
C   MD CONTAINS THE NUMBER OF GRID LINES IN THE X DIRECTION
C   OF THE SECOND GRID (MD .GE. 1).
C
C   DYMIN AND DYMAX CONTAIN THE LOWER AND UPPER LIMITS,
C   RESPECTIVELY, OF THE Y-COORDINATES OF THE SECOND GRID.
C
C   ND CONTAINS THE NUMBER OF GRID LINES IN THE Y DIRECTION
C   OF THE SECOND GRID (ND .GE. 1).
C
C   IDZ CONTAINS THE ROW DIMENSION OF THE ARRAY DZ AS
C   DECLARED IN THE CALLING PROGRAM.
C
C   M AND N CONTAIN THE NUMBER OF GRID LINES IN THE X- AND
C   Y-DIRECTIONS, RESPECTIVELY, OF THE RECTANGULAR GRID
C   WHICH SPECIFIED THE SURFACE.
C
C   X AND Y ARE ARRAYS CONTAINING THE X- AND Y-GRID VALUES,
C   RESPECTIVELY, EACH IN INCREASING ORDER.
C
C   Z IS A MATRIX CONTAINING THE M * N FUNCTIONAL VALUES
C   CORRESPONDING TO THE GRID VALUES (I. E. Z(I,J) IS THE
C   SURFACE VALUE AT THE POINT (X(I),Y(J)) FOR I = 1,...,M
C   AND J = 1,...,N).
C
C   IZ CONTAINS THE ROW DIMENSION OF THE ARRAY Z AS DECLARED
C   IN THE CALLING PROGRAM.
C
C   ZP IS AN ARRAY OF 3*M*N LOCATIONS STORED WITH THE
C   VARIOUS SURFACE DERIVATIVE INFORMATION DETERMINED BY
C   SURF1.
C
C   WORK IS AN ARRAY OF 4*MD LOCATIONS TO BE USED INTERNALLY
C   FOR WORKSPACE.
C
C AND
C
C   SIGMA CONTAINS THE TENSION FACTOR (ITS SIGN IS IGNORED).
C
C THE PARAMETERS M, N, X, Y, Z, IZ, ZP, AND SIGMA SHOULD BE
C INPUT UNALTERED FROM THE OUTPUT OF SURF1 OR NSURF1.
C
C ON OUTPUT--
C
C   DZ CONTAINS THE MD BY ND ARRAY OF SURFACE VALUES
C   INTERPOLATED AT THE POINTS OF THE SECOND GRID.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED.
C
C THIS FUNCTION REFERENCES PACKAGE MODULE SNHCSH.
C
C-----------------------------------------------------------
C
C DENORMALIZE TENSION FACTOR IN X AND Y DIRECTION
C
      SIGMAX = ABS(SIGMA)*FLOAT(M-1)/(X(M)-X(1))
      SIGMAY = ABS(SIGMA)*FLOAT(N-1)/(Y(N)-Y(1))
C
C FIND INTERVALS OF SECOND X GRID WITH RESPECT TO ORIGINAL X
C GRID
C
      DELTDX = 0.
      IF (MD .GE. 2) DELTDX = (DXMAX-DXMIN)/FLOAT(MD-1)
      LASTI = 1
      DO 3 II = 1,MD
        XII = DXMIN+FLOAT(II-1)*DELTDX
        I = LASTI
    1   I = I+1
        IF (XII .GT. X(I) .AND. I .LT. M) GO TO 1
        IM1 = I-1
        LASTI = IM1
        DEL1 = XII-X(IM1)
        DEL2 = X(I)-XII
        DELS = X(I)-X(IM1)
        WORK(1,II) = DEL2/DELS
        WORK(2,II) = DEL1/DELS
        IF (SIGMAX .NE. 0.) GO TO 2
        TEMP = -DEL1*DEL2/(6.*DELS)
        WORK(3,II) = TEMP*(DEL2+DELS)
        WORK(4,II) = TEMP*(DEL1+DELS)
        GO TO 3
    2   DELP1 = (DEL1+DELS)/2.
        DELP2 = (DEL2+DELS)/2.
        CALL SNHCSH (SINHM1,DUMMY,SIGMAX*DEL1,-1)
        CALL SNHCSH (SINHM2,DUMMY,SIGMAX*DEL2,-1)
        CALL SNHCSH (SINHMS,DUMMY,SIGMAX*DELS,-1)
        CALL SNHCSH (SINHP1,DUMMY,SIGMAX*DEL1/2.,-1)
        CALL SNHCSH (SINHP2,DUMMY,SIGMAX*DEL2/2.,-1)
        CALL SNHCSH (DUMMY,COSHP1,SIGMAX*DELP1,1)
        CALL SNHCSH (DUMMY,COSHP2,SIGMAX*DELP2,1)
        TEMP = SIGMAX*SIGMAX*DELS*(SINHMS+SIGMAX*DELS)
        WORK(3,II) = (SINHM2*DEL1-DEL2*(2.*(COSHP2+1.)*
     *                SINHP1+SIGMAX*COSHP2*DEL1))/TEMP
        WORK(4,II) = (SINHM1*DEL2-DEL1*(2.*(COSHP1+1.)*
     *                SINHP2+SIGMAX*COSHP1*DEL2))/TEMP
    3   CONTINUE
C
C FIND INTERVALS OF SECOND Y GRID WITH RESPECT TO ORIGINAL Y
C GRID AND PERFORM INTRPOLATION
C
      DELTDY = 0.
      IF (ND .GE. 2) DELTDY = (DYMAX-DYMIN)/FLOAT(ND-1)
      LASTJ = 1
      DO 8 JJ=1,ND
        YJJ = DYMIN+FLOAT(JJ-1)*DELTDY
        J = LASTJ
    4   J = J+1
        IF (YJJ .GT. Y(J) .AND. J .LT. N) GO TO 4
        JM1 = J-1
        LASTJ = JM1
        DEL1 = YJJ-Y(JM1)
        DEL2 = Y(J)-YJJ
        DELS = Y(J)-Y(JM1)
        C1 = DEL2/DELS
        C2 = DEL1/DELS
        IF (SIGMAY .NE. 0.) GO TO 5
        TEMP = -DEL1*DEL2/(6.*DELS)
        C3 = TEMP*(DEL2+DELS)
        C4 = TEMP*(DEL1+DELS)
        GO TO 6
    5   DELP1 = (DEL1+DELS)/2.
        DELP2 = (DEL2+DELS)/2.
        CALL SNHCSH (SINHM1,DUMMY,SIGMAY*DEL1,-1)
        CALL SNHCSH (SINHM2,DUMMY,SIGMAY*DEL2,-1)
        CALL SNHCSH (SINHMS,DUMMY,SIGMAY*DELS,-1)
        CALL SNHCSH (SINHP1,DUMMY,SIGMAY*DEL1/2.,-1)
        CALL SNHCSH (SINHP2,DUMMY,SIGMAY*DEL2/2.,-1)
        CALL SNHCSH (DUMMY,COSHP1,SIGMAY*DELP1,1)
        CALL SNHCSH (DUMMY,COSHP2,SIGMAY*DELP2,1)
        TEMP = SIGMAY*SIGMAY*DELS*(SINHMS+SIGMAY*DELS)
        C3 = (SINHM2*DEL1-DEL2*(2.*(COSHP2+1.)*
     *        SINHP1+SIGMAY*COSHP2*DEL1))/TEMP
        C4 = (SINHM1*DEL2-DEL1*(2.*(COSHP1+1.)*
     *        SINHP2+SIGMAY*COSHP1*DEL2))/TEMP
    6   LASTI = 0
        DO 8 II=1,MD
          XII = DXMIN+FLOAT(II-1)*DELTDX
          I = MAX0 (1, LASTI)
    7     I = I+1
          IF (XII .GT. X(I) .AND. I .LT. M) GO TO 7
          IM1 = I-1
          IF (IM1 .EQ. LASTI) GO TO 8
          LASTI = IM1
          ZIM1 = C1*Z(IM1,JM1)+C2*Z(IM1,J)
     *           +C3*ZP(IM1,JM1,1)+C4*ZP(IM1,J,1)
          ZI = C1*Z(I,JM1)+C2*Z(I,J)
     *         +C3*ZP(I,JM1,1)+C4*ZP(I,J,1)
          ZXXIM1 = C1*ZP(IM1,JM1,2)+C2*ZP(IM1,J,2)
     *             +C3*ZP(IM1,JM1,3)+C4*ZP(IM1,J,3)
          ZXXI = C1*ZP(I,JM1,2)+C2*ZP(I,J,2)
     *           +C3*ZP(I,JM1,3)+C4*ZP(I,J,3)
    8     DZ(II,JJ) = WORK(1,II)*ZIM1+WORK(2,II)*ZI
     *                +WORK(3,II)*ZXXIM1+WORK(4,II)*ZXXI
      RETURN
      END
      SUBROUTINE BSTRP2 (X, Y, Z, KZ, TX, NX, KX, TY, NY, KY,
     *                   A, KA, WK, L, IFLAG)
C-----------------------------------------------------------------------
C
C         PIECEWISE POLYNOMIAL INTERPOLATION IN TWO VARIABLES
C
C                          -----------------
C
C     THE PIECEWISE POLYNOMIALS CONSIDERED ARE TENSOR PRODUCTS OF
C     B-SPLINES, HAVING THE FORM
C
C                          NX   NY
C              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
C                         I=1  J=1   IJ  I     J
C
C     WHERE U  AND V  ARE ONE-DIMENSIONAL B-SPLINE BASIS FUNCTIONS.
C            I      J
C
C-----------------------------------------------------------------------
C     REAL TX(NX + KX), TY(NY + KY)
C     REAL WK(L)  WHERE L = NX*NY + MAX(2*KX*NX, 2*KY*NY)
C-------------------------
      REAL X(NX), Y(NY), Z(KZ,NY)
      REAL TX(*), TY(*), A(KA,NY), WK(L)
C
      M = NX*NY + 2*MAX0(KX*NX, KY*NY)
      IF (L .LT. M) GO TO 120
C
C     COMPUTE THE COEFFICIENTS
C
      IW = NX*NY + 1
      CALL BSTRP1 (X, Z, KZ, NX, NY, TX, KX, WK, NY, WK(IW), IFLAG)
      IF (IFLAG .NE. 0) GO TO 100
      CALL BSTRP1 (Y, WK, NY, NY, NX, TY, KY, A, KA, WK(IW), IFLAG)
      IF (IFLAG .NE. 0) GO TO 110
      RETURN
C
C     ERROR RETURN
C
  100 IFLAG = 1
      RETURN
  110 IFLAG = 2
      RETURN
  120 IFLAG = 3
      RETURN
      END
      SUBROUTINE BSTRP1 (X, Z, KZ, M, N, T, K, A, KA, WORK, IFLAG)
C-------------------------------------------------------------------
C     BSTRP1 COMPUTES B-SPLINE INTERPOLATION COEFFICIENTS FOR
C     N SETS OF DATA STORED IN THE COLUMNS OF THE ARRAY Z. THE
C     COEFFICIENTS ARE STORED IN THE ROWS OF A.
C
C     IT IS ASSUMED THAT KZ .GE. M AND KA .GE. N.
C-------------------------------------------------------------------
C     REAL T(M + K), WORK(2*K*M)
C-----------------------
      REAL X(M), Z(KZ,N), T(*), A(KA,M), WORK(*)
C
C     FIRST DATA SET
C
      IFLAG = 1
      MP1 = M + 1
      CALL BSTRP (X, Z, T, M, K, WORK(1), WORK(MP1), IFLAG)
      IF (IFLAG .NE. 0) RETURN
C
      DO 10 I = 1,M
         A(1,I) = WORK(I)
   10 CONTINUE
      IF (N .EQ. 1) RETURN
C
C     REMAINING DATA SETS
C
      DO 30 J = 2,N
         CALL BSTRP (X, Z(1,J), T, M, K, WORK(1), WORK(MP1), IFLAG)
         DO 20 I = 1,M
            A(J,I) = WORK(I)
   20    CONTINUE
   30 CONTINUE
      RETURN
      END
      SUBROUTINE BSLSQ2 (X, WX, MX, Y, WY, MY, Z, KZ, TX, NX, KX,
     *                   TY, NY, KY, A, KA, WK, L, IFLAG)
C-----------------------------------------------------------------------
C
C             WEIGHTED LEAST SQUARES FITTING OF PIECEWISE
C                    POLYNOMIALS IN TWO VARIABLES
C
C                          ----------------
C
C     THE PIECEWISE POLYNOMIALS CONSIDERED ARE TENSOR PRODUCTS OF
C     B-SPLINES, HAVING THE FORM
C
C                          NX   NY
C              F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
C                         I=1  J=1   IJ  I     J
C
C     WHERE U  AND V  ARE ONE-DIMENSIONAL B-SPLINE BASIS FUNCTIONS.
C            I      J
C
C-----------------------------------------------------------------------
C     REAL TX(NX + KX), TY(NY + KY)
C     REAL WK(L)  WHERE L = NX*MY + MAX((KX+1)*NX,(KY+1)*NY)
C-------------------------
      REAL X(MX), WX(MX), Y(MY), WY(MY), Z(KZ,MY)
      REAL TX(*), TY(*), A(KA,NY), WK(L)
C
      M = NX*MY + MAX0((KX + 1)*NX,(KY + 1)*NY)
      IF (L .LT. M) GO TO 120
C
C     COMPUTE THE COEFFICIENTS
C
      IW = NX*MY + 1
      IQ = IW + NX
      CALL BSLSQ1 (X, WX, MX, Z, KZ, MY, TX, NX, KX,
     *             WK, MY, WK(IW), WK(IQ), IERR)
      IF (IERR .LT. 0) GO TO 100
C
      IQ = IW + NY
      CALL BSLSQ1 (Y, WY, MY, WK, MY, NX, TY, NY, KY,
     *             A, KA, WK(IW), WK(IQ), IFLAG)
      IF (IFLAG .LT. 0) GO TO 110
      IFLAG = MAX0(IERR,IFLAG)
      RETURN
C
C     ERROR RETURN
C
  100 IFLAG = -1
      RETURN
  110 IFLAG = -2
      RETURN
  120 IFLAG = -3
      WK(1) = M
      RETURN
      END
      SUBROUTINE BSLSQ1 (TAU, WGT, NTAU, Z, KZ, M, T, N, K,
     *                   A, KA, WK, Q, IERR)
C-----------------------------------------------------------------------
C
C     BSLSQ1 PRODUCES THE B-SPLINE COEFFICIENTS A(J,1),...,A(J,N)
C     OF THE PIECEWISE POLYNOMIAL P(X) OF ORDER K WITH KNOTS T(I)
C     (I = 1,...,N+K) WHICH MINIMIZES
C
C              SUM (WGT(L)*(P(TAU(L)) - Z(L,J))**2)
C                 L
C
C     FOR J = 1,...,M.
C
C     INPUT ...
C
C       TAU   ARRAY OF LENGTH NTAU CONTAINING DATA POINT ABSCISSAE.
C       WGT   ARRAY OF LENGTH NTAU CONTAINING THE WEIGHTS.
C       NTAU  NUMBER OF DATA POINTS TO BE FITTED (NTAU .GE. N).
C       Z     MATRIX CONTAINING M SETS OF ORDINATES TO BE FITTED.
C             EACH SET OF NTAU ORDINATES IS A COLUMN OF Z.
C       KZ    NUMBER OF ROWS OF Z IN THE CALLING PROGRAM.
C             IT IS ASSUMED THAT KZ .GE. NTAU.
C       M     NUMBER OF SETS OF ORDINATES TO BE FITTED.
C       T     KNOT SEQUENCE OF LENGTH N+K.
C       N     DIMENSION OF THE PIECEWISE POLYNOMIAL SPACE.
C       K     ORDER OF THE B-SPLINES.
C       KA    NUMBER OF ROWS OF A IN THE CALLING PROGRAM.
C             IT IS ASSUMED THAT KA .GE. M.
C
C     OUTPUT ...
C
C       A     MATRIX CONTAINING THE M SETS OF B-SPLINE COEFFICIENTS
C             OF THE L2 APPROXIMATIONS. EACH SET OF N COEFFICIENTS
C             IS A ROW OF A.
C
C       IERR  INTEGER REPORTING THE STATUS OF THE RESULTS ...
C
C             0  THE COEFFICIENT MATRIX IS NONSIGULAR. THE
C                UNIQUE LEAST SQUARES SOLUTION WAS OBTAINED.
C             1  THE COEFFICIENT MATRIX IS SINGULAR. A
C                LEAST SQUARES SOLUTION WAS OBTAINED.
C            -1  INPUT ERRORS WERE DETECTED.
C
C-----------------------------------------------------------------------
      REAL TAU(NTAU), WGT(NTAU), Z(KZ,M)
      REAL T(*), A(KA,N), WK(N), Q(K,N)
C
      IF (NTAU .LT. MAX0(2,K)) GO TO 100
      IF (TAU(1) .LT. T(K) .OR. TAU(NTAU) .GT. T(N + 1)) GO TO 100
C
      DO 10 I = 2,NTAU
         IF (TAU(I - 1) .GT. TAU(I)) GO TO 100
   10 CONTINUE
C
      DO 21 J = 1,N
         DO 20 I = 1,M
            A(I,J) = 0.0
   20    CONTINUE
   21 CONTINUE
C
      DO 31 J = 1,N
         DO 30 I = 1,K
            Q(I,J) = 0.0
   30    CONTINUE
   31 CONTINUE
C
      LEFT = K
      DO 90 L = 1,NTAU
C
C        *** FIND THE INDEX LEFT SUCH THAT
C            T(LEFT) .LE. TAU(L) .LT. T(LEFT+1)
C
   40    IF (LEFT .EQ. N) GO TO 50
            IF (TAU(L) .LT. T(LEFT+1)) GO TO 50
            LEFT = LEFT + 1
            GO TO 40
C
   50    JJ = 0
         CALL BSPVB (T, K, K, JJ, TAU(L), LEFT, WK)
C
         LEFTMK = LEFT - K
         DO 80 MM = 1,K
            DW = WK(MM)*WGT(L)
            J = LEFTMK + MM
            DO 60 I = 1,M
               A(I,J) = DW*Z(L,I) + A(I,J)
   60       CONTINUE
            I = 1
            DO 70 JJ = MM,K
               Q(I,J) = WK(JJ)*DW + Q(I,J)
               I = I + 1
   70       CONTINUE
   80    CONTINUE
   90 CONTINUE
C
C        SOLVE THE NORMAL EQUATIONS
C
      CALL BCHFAC (Q, K, N, WK, IERR)
      CALL BCHSV1 (Q, K, N, A, KA, M)
      RETURN
C
C             ERROR RETURN
C
  100 IERR = -1
      RETURN
      END
      SUBROUTINE BCHSV1 (W, NB, N, B, KB, M)
C-----------------------------------------------------------------------
C
C     BCHSV1 SOLVES M LINEAR SYSTEMS C*X = B  (I = 1,...,M), WHERE
C                                       I   I
C     EACH B  IS A VECTOR STORED IN THE I-TH ROW OF A MATRIX B.
C           I
C                       ------------------
C
C     INPUT ...
C
C        N   THE ORDER OF THE MATRIX C
C        NB  THE BANDWIDTH OF C
C        W   THE CHOLESKY FACTORIZATION OF THE BANDED SYMMETRIC
C            POSITIVE DEFINITE MATRIX C OBTAINED BY THE ROUTINE
C            BCHFAC.
C        B   MATRIX WHOSE ROWS ARE THE VECTORS TO BE SOLVED FOR
C            IN THE M LINEAR SYSTEMS OF EQUATIONS.
C        KB  THE NUMBER OF ROWS OF B SPECIFIED IN THE CALLING
C            PROGRAM. IT IS ASSUMED THAT KB .GE. M.
C        M   NUMBER OF LINEAR SYSTEMS TO BE SOLVED.
C
C     OUTPUT ...
C
C        B   MATRIX WHOSE ROWS ARE THE SOLUTIONS X  OF THE M
C            LINEAR SYSTEMS OF EQUATIONS.         I
C
C                                       T
C     NOTE.  THE FACTORIZATION C = L*D*L  IS USED, WHERE L IS A
C     UNIT LOWER TRIANGULAR MATRIX AND D A DIAGONAL MATRIX.
C
C-----------------------------------------------------------------------
      REAL W(NB,N), B(KB,N)
C
      IF (N .GT. 1) GO TO 20
      DO 10 I = 1,M
         B(I,1) = B(I,1)*W(1,1)
   10 CONTINUE
      RETURN
C
C     FORWARD SUBSTITUTION. SOLVE L*Y = B FOR Y AND STORE Y IN B.
C
   20 NBM1 = NB - 1
      DO 40 K = 1,N
         JMAX = MIN0(NBM1,N - K)
         IF (JMAX .LT. 1) GO TO 40
         DO 31 J = 1,JMAX
            JPK = J + K
            T = W(J + 1,K)
            DO 30 I = 1,M
               B(I,JPK) = B(I,JPK) - T*B(I,K)
   30       CONTINUE
   31    CONTINUE
   40 CONTINUE
C                              T     -1
C     BACKSUBSTITUTION. SOLVE L X = D  Y  FOR X AND STORE X IN B.
C
      K = N
   50    T = W(1,K)
         DO 60 I = 1,M
            B(I,K) = T*B(I,K)
   60    CONTINUE
         JMAX = MIN0(NBM1,N - K)
         IF (JMAX .LT. 1) GO TO 80
         DO 71 J = 1,JMAX
            JPK = J + K
            T = W(J + 1,K)
            DO 70 I = 1,M
               B(I,K) = B(I,K) - T*B(I,JPK)
   70       CONTINUE
   71    CONTINUE
   80    K = K - 1
         IF (K .GT. 0) GO TO 50
      RETURN
      END
      SUBROUTINE BVAL2 (A, KA, TX, NX, KX, TY, NY, KY, X0, Y0,
     *                  IDX, IDY, F, WK)
C-----------------------------------------------------------------------
C
C                EVALUATION AND PARTIAL DIFFERENTIATION
C                      OF A PIECEWISE POLYNOMIAL
C
C                            NX   NY
C                F(X,Y)  =  SUM  SUM  A   U (X) V (Y)
C                           I=1  J=1   IJ  I     J
C
C     WHERE U  AND V  ARE ONE-DIMENSIONAL B-SPLINE BASIS FUNCTIONS.
C            I      J
C-----------------------------------------------------------------------
C     REAL TX(NX + KX), TY(NY + KY), WK(KY + 3*MAX(KX,KY))
C-----------------------------
      REAL A(KA,NY), TX(*), TY(*), WK(*)
C
      F = 0.0
      M = NX + KX
      IF (X0 .LT. TX(1) .OR. X0 .GT. TX(M)) RETURN
      M = NY + KY
      IF (Y0 .LT. TY(1) .OR. Y0 .GT. TY(M)) RETURN
C
      IW = KY + 1
      J = INTRVL(Y0, TY, M)
      IF (J .GT. KY) GO TO 20
C
C     CASE WHEN  J .LE. KY
C
      DO 10 L = 1,J
         CALL BVAL (TX, A(1,L), NX, KX, X0, IDX, WK(L), WK(IW))
   10 CONTINUE
      CALL BVAL (TY, WK(1), J, KY, Y0, IDY, F, WK(IW))
      RETURN
C
C     CASE WHEN  J .GT. KY
C
   20 L = J - KY
      DO 30 I = 1,KY
         L = L + 1
         CALL BVAL (TX, A(1,L), NX, KX, X0, IDX, WK(I), WK(IW))
   30 CONTINUE
      L = J - KY + 1
      CALL BVAL (TY(L), WK(1), KY, KY, Y0, IDY, F, WK(IW))
      RETURN
      END
      SUBROUTINE TRMESH (N,X,Y, IADJ,IEND,IER)
      INTEGER N, IADJ(*), IEND(N), IER
      REAL    X(N), Y(N)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS ROUTINE CREATES A THIESSEN TRIANGULATION OF N
C ARBITRARILY SPACED POINTS IN THE PLANE REFERRED TO AS
C NODES.  THE TRIANGULATION IS OPTIMAL IN THE SENSE THAT IT
C IS AS NEARLY EQUIANGULAR AS POSSIBLE.  TRMESH IS PART OF
C AN INTERPOLATION PACKAGE WHICH ALSO PROVIDES SUBROUTINES
C TO REORDER THE NODES, ADD A NEW NODE, DELETE AN ARC, PLOT
C THE MESH, AND PRINT THE DATA STRUCTURE.
C   UNLESS THE NODES ARE ALREADY ORDERED IN SOME REASONABLE
C FASHION, THEY SHOULD BE REORDERED BY SUBROUTINE REORDR FOR
C INCREASED EFFICIENCY BEFORE CALLING TRMESH.
C
C INPUT PARAMETERS -     N - NUMBER OF NODES IN THE MESH.
C                            N .GE. 3.
C
C                      X,Y - N-VECTORS OF COORDINATES.
C                            (X(I),Y(I)) DEFINES NODE I.
C
C                     IADJ - VECTOR OF LENGTH .GE. 6*N-9.
C
C                     IEND - VECTOR OF LENGTH .GE. N.
C
C N, X, AND Y ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETERS - IADJ - ADJACENCY LISTS OF NEIGHBORS IN
C                            COUNTERCLOCKWISE ORDER.  THE
C                            LIST FOR NODE I+1 FOLLOWS THAT
C                            FOR NODE I WHERE X AND Y DEFINE
C                            THE ORDER.  THE VALUE 0 DENOTES
C                            THE BOUNDARY (OR A PSEUDO-NODE
C                            AT INFINITY) AND IS ALWAYS THE
C                            LAST NEIGHBOR OF A BOUNDARY
C                            NODE.  IADJ IS UNCHANGED IF IER
C                            .NE. 0.
C
C                     IEND - POINTERS TO THE ENDS OF
C                            ADJACENCY LISTS (SETS OF
C                            NEIGHBORS) IN IADJ.  THE
C                            NEIGHBORS OF NODE 1 BEGIN IN
C                            IADJ(1).  FOR K .GT. 1, THE
C                            NEIGHBORS OF NODE K BEGIN IN
C                            IADJ(IEND(K-1)+1) AND K HAS
C                            IEND(K) - IEND(K-1) NEIGHBORS
C                            INCLUDING (POSSIBLY) THE
C                            BOUNDARY.  IADJ(IEND(K)) .EQ. 0
C                            IFF NODE K IS ON THE BOUNDARY.
C                            IEND IS UNCHANGED IF IER = 1.
C                            IF IER = 2 IEND CONTAINS THE
C                            INDICES OF A SEQUENCE OF N
C                            NODES ORDERED FROM LEFT TO
C                            RIGHT WHERE LEFT AND RIGHT ARE
C                            DEFINED BY ASSUMING NODE 1 IS
C                            TO THE LEFT OF NODE 2.
C
C                      IER - ERROR INDICATOR
C                            IER = 0 IF NO ERRORS WERE
C                                    ENCOUNTERED.
C                            IER = 1 IF N .LT. 3.
C                            IER = 2 IF N .GE. 3 AND ALL
C                                    NODES ARE COLLINEAR.
C
C MODULES REFERENCED BY TRMESH - SHIFTD, ADNODE, TRFIND,
C                                INTADD, BDYADD, SWPTST,
C                                SWAPD, TINDX
C
C***********************************************************
C
      INTEGER NN, K, KM1, NL, NR, IND, INDX, N0, ITEMP,
     .        IERR, KM1D2, KMI, I, KMIN
      REAL    XL, YL, XR, YR, DXR, DYR, XK, YK, DXK, DYK,
     .        CPROD, SPROD
C
C LOCAL PARAMETERS -
C
C NN =          LOCAL COPY OF N
C K =           NODE (INDEX) TO BE INSERTED INTO IEND
C KM1 =         K-1 - (VARIABLE) LENGTH OF IEND
C NL,NR =       IEND(1), IEND(KM1) -- LEFTMOST AND RIGHTMOST
C                 NODES IN IEND AS VIEWED FROM THE RIGHT OF
C                 1-2 WHEN IEND CONTAINS THE INITIAL ORDERED
C                 SET OF NODAL INDICES
C XL,YL,XR,YR = X AND Y COORDINATES OF NL AND NR
C DXR,DYR =     XR-XL, YR-YL
C XK,YK =       X AND Y COORDINATES OF NODE K
C DXK,DYK =     XK-XL, YK-YL
C CPROD =       VECTOR CROSS PRODUCT OF NL-NR AND NL-K --
C                 USED TO DETERMINE THE POSITION OF NODE K
C                 WITH RESPECT TO THE LINE DEFINED BY THE
C                 NODES IN IEND
C SPROD =       SCALAR PRODUCT USED TO DETERMINE THE
C                 INTERVAL CONTAINING NODE K WHEN K IS ON
C                 THE LINE DEFINED BY THE NODES IN IEND
C IND,INDX =    INDICES FOR IEND AND IADJ, RESPECTIVELY
C N0,ITEMP =    TEMPORARY NODES (INDICES)
C IERR =        DUMMY PARAMETER FOR CALL TO ADNODE
C KM1D2,KMI,I = KM1/2, K-I, DO-LOOP INDEX -- USED IN IEND
C                 REORDERING LOOP
C KMIN =        FIRST NODE INDEX SENT TO ADNODE
C
      NN = N
      IER = 1
      IF (NN .LT. 3) RETURN
      IER = 0
C
C INITIALIZE IEND, NL, NR, AND K
C
      IEND(1) = 1
      IEND(2) = 2
      XL = X(1)
      YL = Y(1)
      XR = X(2)
      YR = Y(2)
      K = 2
C
C BEGIN LOOP ON NODES 3,4,...
C
    1 DXR = XR-XL
      DYR = YR-YL
C
C NEXT LOOP BEGINS HERE IF NL AND NR ARE UNCHANGED
C
    2 IF (K .EQ. NN) GO TO 13
      KM1 = K
      K = KM1 + 1
      XK = X(K)
      YK = Y(K)
      DXK = XK-XL
      DYK = YK-YL
      CPROD = DXR*DYK - DXK*DYR
      IF (CPROD .GT. 0.) GO TO 6
      IF (CPROD .LT. 0.) GO TO 8
C
C NODE K LIES ON THE LINE CONTAINING NODES 1,2,...,K-1.
C   SET SPROD TO (NL-NR,NL-K).
C
      SPROD = DXR*DXK + DYR*DYK
      IF (SPROD .GT. 0.) GO TO 3
C
C NODE K IS TO THE LEFT OF NL.  INSERT K AS THE FIRST
C   (LEFTMOST) NODE IN IEND AND SET NL TO K.
C
      CALL SHIFTD(1,KM1,1, IEND )
      IEND(1) = K
      XL = XK
      YL = YK
      GO TO 1
C
C NODE K IS TO THE RIGHT OF NL.  FIND THE LEFTMOST NODE
C   N0 WHICH LIES TO THE RIGHT OF K.
C   SET SPROD TO (N0-NL,N0-K).
C
    3 DO 4 IND = 2,KM1
        N0 = IEND(IND)
        SPROD = (XL-X(N0))*(XK-X(N0)) +
     .          (YL-Y(N0))*(YK-Y(N0))
        IF (SPROD .GE. 0.) GO TO 5
    4   CONTINUE
C
C NODE K IS TO THE RIGHT OF NR.  INSERT K AS THE LAST
C   (RIGHTMOST) NODE IN IEND AND SET NR TO K.
C
      IEND(K) = K
      XR = XK
      YR = YK
      GO TO 1
C
C NODE K LIES BETWEEN IEND(IND-1) AND IEND(IND).  INSERT K
C   IN IEND.
C
    5 CALL SHIFTD(IND,KM1,1, IEND )
      IEND(IND) = K
      GO TO 2
C
C NODE K IS TO THE LEFT OF NL-NR.  REORDER IEND SO THAT NL
C   IS THE LEFTMOST NODE AS VIEWED FROM K.
C
    6 KM1D2 = KM1/2
      DO 7 I = 1,KM1D2
        KMI = K-I
        ITEMP = IEND(I)
        IEND(I) = IEND(KMI)
        IEND(KMI) = ITEMP
    7   CONTINUE
C
C NODE K IS TO THE RIGHT OF NL-NR.  CREATE A TRIANGULATION
C   CONSISTING OF NODES 1,2,...,K.
C
    8 NL = IEND(1)
      NR = IEND(KM1)
C
C CREATE THE ADJACENCY LISTS FOR THE FIRST K-1 NODES.
C   INSERT NEIGHBORS IN REVERSE ORDER.  EACH NODE HAS FOUR
C   NEIGHBORS EXCEPT NL AND NR WHICH HAVE THREE.
C
      DO 9 IND = 1,KM1
        N0 = IEND(IND)
        INDX = 4*N0
        IF (N0 .GE. NL) INDX = INDX-1
        IF (N0 .GE. NR) INDX = INDX-1
        IADJ(INDX) = 0
        INDX = INDX-1
        IF (IND .LT. KM1) IADJ(INDX) = IEND(IND+1)
        IF (IND .LT. KM1) INDX = INDX-1
        IADJ(INDX) = K
        IF (IND .EQ. 1) GO TO 9
        IADJ(INDX-1) = IEND(IND-1)
    9   CONTINUE
C
C CREATE THE ADJACENCY LIST FOR NODE K
C
      INDX = 5*KM1 - 1
      IADJ(INDX) = 0
      DO 10 IND = 1,KM1
        INDX = INDX-1
        IADJ(INDX) = IEND(IND)
   10   CONTINUE
C
C REPLACE IEND ELEMENTS WITH POINTERS TO IADJ
C
      INDX = 0
      DO 11 IND = 1,KM1
        INDX = INDX + 4
        IF (IND .EQ. NL  .OR.  IND .EQ. NR) INDX = INDX-1
        IEND(IND) = INDX
   11   CONTINUE
      INDX = INDX + K
      IEND(K) = INDX
C
C ADD THE REMAINING NODES TO THE TRIANGULATION
C
      IF (K .EQ. NN) RETURN
      KMIN = K+1
      DO 12 K = KMIN,NN
        CALL ADNODE(K,X,Y, IADJ,IEND, IERR)
   12   CONTINUE
      RETURN
C
C ALL NODES ARE COLLINEAR
C
   13 IER = 2
      RETURN
      END
      SUBROUTINE ADNODE (KK,X,Y, IADJ,IEND, IER)
      INTEGER KK, IADJ(*), IEND(KK), IER
      REAL    X(KK), Y(KK)
      LOGICAL SWPTST
      INTEGER TINDX
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS ROUTINE ADDS NODE KK TO A TRIANGULATION OF A SET
C OF POINTS IN THE PLANE PRODUCING A NEW TRIANGULATION.  A
C SEQUENCE OF EDGE SWAPS IS THEN APPLIED TO THE MESH,
C RESULTING IN AN OPTIMAL TRIANGULATION.  ADNODE IS PART
C OF AN INTERPOLATION PACKAGE WHICH ALSO PROVIDES ROUTINES
C TO INITIALIZE THE DATA STRUCTURE, PLOT THE MESH, AND
C DELETE ARCS.
C
C INPUT PARAMETERS -   KK - INDEX OF THE NODE TO BE ADDED
C                           TO THE MESH.  KK .GE. 4.
C
C                     X,Y - VECTORS OF COORDINATES OF THE
C                           NODES IN THE MESH.  (X(I),Y(I))
C                           DEFINES NODE I FOR I = 1,..,KK.
C
C                    IADJ - SET OF ADJACENCY LISTS OF NODES
C                           1,..,KK-1.
C
C                    IEND - POINTERS TO THE ENDS OF
C                           ADJACENCY LISTS IN IADJ FOR
C                           EACH NODE IN THE MESH.
C
C IADJ AND IEND MAY BE CREATED BY TRMESH.
C
C KK, X, AND Y ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ADDITION
C                                 OF NODE KK AS THE LAST
C                                 ENTRY.
C
C                           IER - ERROR INDICATOR
C                                 IER = 0 IF NO ERRORS
C                                         WERE ENCOUNTERED.
C                                 IER = 1 IF ALL NODES
C                                         (INCLUDING KK) ARE
C                                         COLLINEAR.
C
C MODULES REFERENCED BY ADNODE - TRFIND, INTADD, BDYADD,
C                                SHIFTD, TINDX, SWPTST,
C                                SWAPD
C
C***********************************************************
C
      INTEGER K, KM1, I1, I2, I3, INDKF, INDKL, NABOR1,
     .        IO1, IO2, IN1, INDK1, IND2F, IND21
      REAL    XK, YK
C
C LOCAL PARAMETERS -
C
C K =        LOCAL COPY OF KK
C KM1 =      K - 1
C I1,I2,I3 = VERTICES OF A TRIANGLE CONTAINING K
C INDKF =    IADJ INDEX OF THE FIRST NEIGHBOR OF K
C INDKL =    IADJ INDEX OF THE LAST NEIGHBOR OF K
C NABOR1 =   FIRST NEIGHBOR OF K BEFORE ANY SWAPS OCCUR
C IO1,IO2 =  ADJACENT NEIGHBORS OF K DEFINING AN ARC TO
C              BE TESTED FOR A SWAP
C IN1 =      VERTEX OPPOSITE K -- FIRST NEIGHBOR OF IO2
C              WHICH PRECEDES IO1.  IN1,IO1,IO2 ARE IN
C              COUNTERCLOCKWISE ORDER.
C INDK1 =    INDEX OF IO1 IN THE ADJACENCY LIST FOR K
C IND2F =    INDEX OF THE FIRST NEIGHBOR OF IO2
C IND21 =    INDEX OF IO1 IN THE ADJACENCY LIST FOR IO2
C XK,YK =    X(K), Y(K)
C
      IER = 0
      K = KK
C
C INITIALIZATION
C
      KM1 = K - 1
      XK = X(K)
      YK = Y(K)
C
C ADD NODE K TO THE MESH
C
      CALL TRFIND(KM1,XK,YK,X,Y,IADJ,IEND, I1,I2,I3)
      IF (I1 .EQ. 0) GO TO 5
      IF (I3 .EQ. 0) CALL BDYADD(K,I1,I2, IADJ,IEND )
      IF (I3 .NE. 0) CALL INTADD(K,I1,I2,I3, IADJ,IEND )
C
C INITIALIZE VARIABLES FOR OPTIMIZATION OF THE MESH
C
      INDKF = IEND(KM1) + 1
      INDKL = IEND(K)
      NABOR1 = IADJ(INDKF)
      IO2 = NABOR1
      INDK1 = INDKF + 1
      IO1 = IADJ(INDK1)
C
C BEGIN LOOP -- FIND THE VERTEX OPPOSITE K
C
    1 IND2F = 1
      IF (IO2 .NE. 1) IND2F = IEND(IO2-1) + 1
      IND21 = TINDX(IO2,IO1,IADJ,IEND)
      IF (IND2F .EQ. IND21) GO TO 2
      IN1 = IADJ(IND21-1)
      GO TO 3
C
C IN1 IS THE LAST NEIGHBOR OF IO2
C
    2 IND21 = IEND(IO2)
      IN1 = IADJ(IND21)
      IF (IN1 .EQ. 0) GO TO 4
C
C SWAP TEST -- IF A SWAP OCCURS, TWO NEW ARCS ARE OPPOSITE K
C              AND MUST BE TESTED.  INDK1 AND INDKF MUST BE
C              DECREMENTED.
C
    3 IF ( .NOT. SWPTST(IN1,K,IO1,IO2,X,Y) ) GO TO 4
      CALL SWAPD (IN1,K,IO1,IO2, IADJ,IEND)
      IO1 = IN1
      INDK1 = INDK1 - 1
      INDKF = INDKF - 1
      GO TO 1
C
C NO SWAP OCCURRED.  RESET IO2 AND IO1, AND TEST FOR
C   TERMINATION.
C
    4 IF (IO1 .EQ. NABOR1) RETURN
      IO2 = IO1
      INDK1 = INDK1 + 1
      IF (INDK1 .GT. INDKL) INDK1 = INDKF
      IO1 = IADJ(INDK1)
      IF (IO1 .NE. 0) GO TO 1
      RETURN
C
C ALL NODES ARE COLLINEAR
C
    5 IER = 1
      RETURN
      END
      SUBROUTINE BDYADD (KK,I1,I2, IADJ,IEND )
      INTEGER KK, I1, I2, IADJ(*), IEND(KK)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS ROUTINE ADDS A BOUNDARY NODE TO A TRIANGULATION
C OF A SET OF KK-1 POINTS IN THE PLANE.  IADJ AND IEND ARE
C UPDATED WITH THE INSERTION OF NODE KK.
C
C INPUT PARAMETERS -   KK - INDEX OF AN EXTERIOR NODE TO BE
C                           ADDED.  KK .GE. 4.
C
C                      I1 - FIRST (RIGHTMOST AS VIEWED FROM
C                           KK) BOUNDARY NODE IN THE MESH
C                           WHICH IS VISIBLE FROM KK - THE
C                           LINE SEGMENT KK-I1 INTERSECTS
C                           NO ARCS.
C
C                      I2 - LAST (LEFTMOST) BOUNDARY NODE
C                           WHICH IS VISIBLE FROM KK.
C
C                    IADJ - SET OF ADJACENCY LISTS OF NODES
C                           IN THE MESH.
C
C                    IEND - POINTERS TO THE ENDS OF
C                           ADJACENCY LISTS IN IADJ FOR
C                           EACH NODE IN THE MESH.
C
C   IADJ AND IEND MAY BE CREATED BY TRMESH AND MUST CONTAIN
C THE VERTICES I1 AND I2.  I1 AND I2 MAY BE DETERMINED BY
C TRFIND.
C
C KK, I1, AND I2 ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ADDITION
C                                 OF NODE KK AS THE LAST
C                                 ENTRY.  NODE KK WILL BE
C                                 CONNECTED TO I1, I2, AND
C                                 ALL BOUNDARY NODES BETWEEN
C                                 THEM.  NO OPTIMIZATION OF
C                                 THE MESH IS PERFORMED.
C
C MODULE REFERENCED BY BDYADD - SHIFTD
C
C INTRINSIC FUNCTIONS CALLED BY BDYADD - MIN0, MAX0
C
C***********************************************************
C
      INTEGER K, KM1, NRIGHT, NLEFT, NF, NL, N1, N2, I,
     .        IMIN, IMAX, KEND, NEXT, INDX
C
C LOCAL PARAMETERS -
C
C K =            LOCAL COPY OF KK
C KM1 =          K - 1
C NRIGHT,NLEFT = LOCAL COPIES OF I1, I2
C NF,NL =        INDICES OF IADJ BOUNDING THE PORTION OF THE
C                  ARRAY TO BE SHIFTED
C N1 =           IADJ INDEX OF THE FIRST NEIGHBOR OF NLEFT
C N2 =           IADJ INDEX OF THE LAST NEIGHBOR OF NRIGHT
C I =            DO-LOOP INDEX
C IMIN,IMAX =    BOUNDS ON DO-LOOP INDEX -- FIRST AND LAST
C                  ELEMENTS OF IEND TO BE INCREMENTED
C KEND =         POINTER TO THE LAST NEIGHBOR OF K IN IADJ
C NEXT =         NEXT BOUNDARY NODE TO BE CONNECTED TO KK
C INDX =         INDEX FOR IADJ
C
      K = KK
      KM1 = K - 1
      NRIGHT = I1
      NLEFT = I2
C
C INITIALIZE VARIABLES
C
      NL = IEND(KM1)
      N1 = 1
      IF (NLEFT .NE. 1) N1 = IEND(NLEFT-1) + 1
      N2 = IEND(NRIGHT)
      NF = MAX0(N1,N2)
C
C INSERT K AS A NEIGHBOR OF MAX(NRIGHT,NLEFT)
C
      CALL SHIFTD(NF,NL,2, IADJ )
      IADJ(NF+1) = K
      IMIN = MAX0(NRIGHT,NLEFT)
      DO 1 I = IMIN,KM1
        IEND(I) = IEND(I) + 2
    1   CONTINUE
C
C INITIALIZE KEND AND INSERT K AS A NEIGHBOR OF
C   MIN(NRIGHT,NLEFT)
C
      KEND = NL + 3
      NL = NF - 1
      NF = MIN0(N1,N2)
      CALL SHIFTD(NF,NL,1, IADJ )
      IADJ(NF) = K
      IMAX = IMIN - 1
      IMIN = MIN0(NRIGHT,NLEFT)
      DO 2 I = IMIN,IMAX
        IEND(I) = IEND(I) + 1
    2   CONTINUE
C
C INSERT NRIGHT AS THE FIRST NEIGHBOR OF K
C
      IADJ(KEND) = NRIGHT
C
C INITIALIZE INDX FOR LOOP ON BOUNDARY NODES BETWEEN NRIGHT
C   AND NLEFT
C
      INDX = IEND(NRIGHT) - 2
    3 NEXT = IADJ(INDX)
      IF (NEXT .EQ. NLEFT) GO TO 4
C
C CONNECT NEXT AND K
C
      KEND = KEND + 1
      IADJ(KEND) = NEXT
      INDX = IEND(NEXT)
      IADJ(INDX) = K
      INDX = INDX - 1
      GO TO 3
C
C INSERT NLEFT AND 0 AS THE LAST NEIGHBORS OF K
C
    4 IADJ(KEND+1) = NLEFT
      KEND = KEND + 2
      IADJ(KEND) = 0
      IEND(K) = KEND
      RETURN
      END
      SUBROUTINE INTADD (KK,I1,I2,I3, IADJ,IEND )
      INTEGER KK, I1, I2, I3, IADJ(*), IEND(KK)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS ROUTINE ADDS AN INTERIOR NODE TO A TRIANGULATION
C OF A SET OF KK-1 POINTS IN THE PLANE.  IADJ AND IEND ARE
C UPDATED WITH THE INSERTION OF NODE KK IN THE TRIANGLE
C WHOSE VERTICES ARE I1, I2, AND I3.
C
C INPUT PARAMETERS -        KK - INDEX OF NODE TO BE
C                                INSERTED.  KK .GE. 4.
C
C                     I1,I2,I3 - INDICES OF THE VERTICES OF
C                                A TRIANGLE CONTAINING NODE
C                                KK -- IN COUNTERCLOCKWISE
C                                ORDER.
C
C                         IADJ - SET OF ADJACENCY LISTS
C                                OF NODES IN THE MESH.
C
C                         IEND - POINTERS TO THE ENDS OF
C                                ADJACENCY LISTS IN IADJ FOR
C                                EACH NODE IN THE MESH.
C
C   IADJ AND IEND MAY BE CREATED BY TRMESH AND MUST CONTAIN
C THE VERTICES I1, I2, AND I3.  I1,I2,I3 MAY BE DETERMINED
C BY TRFIND.
C
C KK, I1, I2, AND I3 ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ADDITION
C                                 OF NODE KK AS THE LAST
C                                 ENTRY.  NODE KK WILL BE
C                                 CONNECTED TO NODES I1, I2,
C                                 AND I3.  NO OPTIMIZATION
C                                 OF THE MESH IS PERFORMED.
C
C MODULE REFERENCED BY INTADD - SHIFTD
C
C INTRINSIC FUNCTION CALLED BY INTADD - MOD
C
C***********************************************************
C
      INTEGER K, KM1, N(3), NFT(3), IP1, IP2, IP3, INDX, NF,
     .        NL, N1, N2, IMIN, IMAX, I, ITEMP
C
C LOCAL PARAMETERS -
C
C K =           LOCAL COPY OF KK
C KM1 =         K - 1
C N =           VECTOR CONTAINING I1, I2, I3
C NFT =         POINTERS TO THE TOPS OF THE 3 SETS OF IADJ
C                 ELEMENTS TO BE SHIFTED DOWNWARD
C IP1,IP2,IP3 = PERMUTATION INDICES FOR N AND NFT
C INDX =        INDEX FOR IADJ AND N
C NF,NL =       INDICES OF FIRST AND LAST ENTRIES IN IADJ
C                 TO BE SHIFTED DOWN
C N1,N2 =       FIRST 2 VERTICES OF A NEW TRIANGLE --
C                 (N1,N2,KK)
C IMIN,IMAX =   BOUNDS ON DO-LOOP INDEX -- FIRST AND LAST
C                 ELEMENTS OF IEND TO BE INCREMENTED
C I =           DO-LOOP INDEX
C ITEMP =       TEMPORARY STORAGE LOCATION
C
      K = KK
C
C INITIALIZATION
C
      N(1) = I1
      N(2) = I2
      N(3) = I3
C
C SET UP NFT
C
      DO 2 I = 1,3
        N1 = N(I)
        INDX = MOD(I,3) + 1
        N2 = N(INDX)
        INDX = IEND(N1) + 1
C
C FIND THE INDEX OF N2 AS A NEIGHBOR OF N1
C
    1   INDX = INDX - 1
        IF (IADJ(INDX) .NE. N2) GO TO 1
        NFT(I) = INDX + 1
    2   CONTINUE
C
C ORDER THE VERTICES BY DECREASING MAGNITUDE.
C   N(IP(I+1)) PRECEDES N(IP(I)) IN IEND FOR
C   I = 1,2.
C
      IP1 = 1
      IP2 = 2
      IP3 = 3
      IF ( N(2) .LE. N(1) ) GO TO 3
      IP1 = 2
      IP2 = 1
    3 IF ( N(3) .LE. N(IP1) ) GO TO 4
      IP3 = IP1
      IP1 = 3
    4 IF ( N(IP3) .LE. N(IP2) )  GO TO 5
      ITEMP = IP2
      IP2 = IP3
      IP3 = ITEMP
C
C ADD NODE K TO THE ADJACENCY LISTS OF EACH VERTEX AND
C   UPDATE IEND.  FOR EACH VERTEX, A SET OF IADJ ELEMENTS
C   IS SHIFTED DOWNWARD AND K IS INSERTED.  SHIFTING STARTS
C   AT THE END OF THE ARRAY.
C
    5 KM1 = K - 1
      NL = IEND(KM1)
      NF = NFT(IP1)
      IF (NF .LE. NL) CALL SHIFTD(NF,NL,3, IADJ )
      IADJ(NF+2) = K
      IMIN = N(IP1)
      IMAX = KM1
      DO 6 I = IMIN,IMAX
        IEND(I) = IEND(I) + 3
    6   CONTINUE
C
      NL = NF - 1
      NF = NFT(IP2)
      CALL SHIFTD(NF,NL,2, IADJ )
      IADJ(NF+1) = K
      IMAX = IMIN - 1
      IMIN = N(IP2)
      DO 7 I = IMIN,IMAX
        IEND(I) = IEND(I) + 2
    7   CONTINUE
C
      NL = NF - 1
      NF = NFT(IP3)
      CALL SHIFTD(NF,NL,1, IADJ )
      IADJ(NF) = K
      IMAX = IMIN - 1
      IMIN = N(IP3)
      DO 8 I = IMIN,IMAX
        IEND(I) = IEND(I) + 1
    8   CONTINUE
C
C ADD NODE K TO IEND AND ITS NEIGHBORS TO IADJ
C
      INDX = IEND(KM1)
      IEND(K) = INDX + 3
      DO 9 I = 1,3
        INDX = INDX + 1
        IADJ(INDX) = N(I)
    9   CONTINUE
      RETURN
      END
      SUBROUTINE SHIFTD (NFRST,NLAST,KK, IARR )
      INTEGER NFRST, NLAST, KK, IARR(*)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS ROUTINE SHIFTS A SET OF CONTIGUOUS ELEMENTS OF AN
C INTEGER ARRAY KK POSITIONS DOWNWARD (UPWARD IF KK .LT. 0).
C THE LOOPS ARE UNROLLED IN ORDER TO INCREASE EFFICIENCY.
C
C INPUT PARAMETERS - NFRST,NLAST - BOUNDS ON THE PORTION OF
C                                  IARR TO BE SHIFTED.  ALL
C                                  ELEMENTS BETWEEN AND
C                                  INCLUDING THE BOUNDS ARE
C                                  SHIFTED UNLESS NFRST .GT.
C                                  NLAST, IN WHICH CASE NO
C                                  SHIFT OCCURS.
C
C                             KK - NUMBER OF POSITIONS EACH
C                                  ELEMENT IS TO BE SHIFTED.
C                                  IF KK .LT. 0 SHIFT UP.
C                                  IF KK .GT. 0 SHIFT DOWN.
C
C                           IARR - INTEGER ARRAY OF LENGTH
C                                  .GE. NLAST + MAX(KK,0).
C
C NFRST, NLAST, AND KK ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETER -        IARR - SHIFTED ARRAY.
C
C MODULES REFERENCED BY SHIFTD - NONE
C
C***********************************************************
C
      INTEGER INC, K, NF, NL, NLP1, NS, NSL, I, IBAK, INDX,
     .        IMAX
      DATA    INC/5/
C
C LOCAL PARAMETERS -
C
C INC =  DO-LOOP INCREMENT (UNROLLING FACTOR) -- IF INC IS
C          CHANGED, STATEMENTS MUST BE ADDED TO OR DELETED
C          FROM THE DO-LOOPS
C K =    LOCAL COPY OF KK
C NF =   LOCAL COPY OF NFRST
C NL =   LOCAL COPY OF NLAST
C NLP1 = NL + 1
C NS =   NUMBER OF SHIFTS
C NSL =  NUMBER OF SHIFTS DONE IN UNROLLED DO-LOOP (MULTIPLE
C          OF INC)
C I =    DO-LOOP INDEX AND INDEX FOR IARR
C IBAK = INDEX FOR DOWNWARD SHIFT OF IARR
C INDX = INDEX FOR IARR
C IMAX = BOUND ON DO-LOOP INDEX
C
      K = KK
      NF = NFRST
      NL = NLAST
      IF (NF .GT. NL  .OR.  K .EQ. 0) RETURN
      NLP1 = NL + 1
      NS = NLP1 - NF
      NSL = INC*(NS/INC)
      IF ( K .LT. 0) GO TO 4
C
C SHIFT DOWNWARD STARTING FROM THE BOTTOM
C
      IF (NSL .LE. 0) GO TO 2
      DO 1 I = 1,NSL,INC
        IBAK = NLP1 - I
        INDX = IBAK + K
        IARR(INDX) = IARR(IBAK)
        IARR(INDX-1) = IARR(IBAK-1)
        IARR(INDX-2) = IARR(IBAK-2)
        IARR(INDX-3) = IARR(IBAK-3)
        IARR(INDX-4) = IARR(IBAK-4)
    1   CONTINUE
C
C PERFORM THE REMAINING NS-NSL SHIFTS ONE AT A TIME
C
    2 IBAK = NLP1 - NSL
    3 IF (IBAK .LE. NF) RETURN
      IBAK = IBAK - 1
      INDX = IBAK + K
      IARR(INDX) = IARR(IBAK)
      GO TO 3
C
C SHIFT UPWARD STARTING FROM THE TOP
C
    4 IF (NSL .LE. 0) GO TO 6
      IMAX = NLP1 - INC
      DO 5 I = NF,IMAX,INC
        INDX = I + K
        IARR(INDX) = IARR(I)
        IARR(INDX+1) = IARR(I+1)
        IARR(INDX+2) = IARR(I+2)
        IARR(INDX+3) = IARR(I+3)
        IARR(INDX+4) = IARR(I+4)
    5   CONTINUE
C
C PERFORM THE REMAINING NS-NSL SHIFTS ONE AT A TIME
C
    6 I = NSL + NF
    7 IF (I .GT. NL) RETURN
      INDX = I + K
      IARR(INDX) = IARR(I)
      I = I + 1
      GO TO 7
      END
      SUBROUTINE SWAPD (NIN1,NIN2,NOUT1,NOUT2, IADJ,IEND)
      INTEGER NIN1, NIN2, NOUT1, NOUT2, IADJ(*), IEND(*)
      INTEGER TINDX
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS SUBROUTINE SWAPS THE DIAGONALS IN A CONVEX QUADRI-
C LATERAL.
C
C INPUT PARAMETERS -  NIN1,NIN2,NOUT1,NOUT2 - NODAL INDICES
C                            OF A PAIR OF ADJACENT TRIANGLES
C                            WHICH FORM A CONVEX QUADRILAT-
C                            ERAL.  NOUT1 AND NOUT2 ARE CON-
C                            NECTED BY AN ARC WHICH IS TO BE
C                            REPLACED BY THE ARC NIN1-NIN2.
C                            (NIN1,NOUT1,NOUT2) MUST BE TRI-
C                            ANGLE VERTICES IN COUNTERCLOCK-
C                            WISE ORDER.
C
C THE ABOVE PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
C
C                IADJ,IEND - TRIANGULATION DATA STRUCTURE
C                            (SEE SUBROUTINE TRMESH).
C
C OUTPUT PARAMETERS - IADJ,IEND - UPDATED WITH THE ARC
C                                 REPLACEMENT.
C
C MODULES REFERENCED BY SWAPD - TINDX, SHIFTD
C
C***********************************************************
C
      INTEGER IN(2), IO(2), IP1, IP2, J, K, NF, NL, I,
     .        IMIN, IMAX
C
C LOCAL PARAMETERS -
C
C IN =        NIN1 AND NIN2 ORDERED BY INCREASING MAGNITUDE
C               (THE NEIGHBORS OF IN(1) PRECEDE THOSE OF
C               IN(2) IN IADJ)
C IO =        NOUT1 AND NOUT2 IN INCREASING ORDER
C IP1,IP2 =   PERMUTATION OF (1,2) SUCH THAT IO(IP1)
C               PRECEDES IO(IP2) AS A NEIGHBOR OF IN(1)
C J,K =       PERMUTATION OF (1,2) USED AS INDICES OF IN
C               AND IO
C NF,NL =     IADJ INDICES BOUNDARY A PORTION OF THE ARRAY
C               TO BE SHIFTED
C I =         IEND INDEX
C IMIN,IMAX = BOUNDS ON THE PORTION OF IEND TO BE INCRE-
C               MENTED OR DECREMENTED
C
      IN(1) = NIN1
      IN(2) = NIN2
      IO(1) = NOUT1
      IO(2) = NOUT2
      IP1 = 1
C
C ORDER THE INDICES SO THAT IN(1) .LT. IN(2) AND IO(1) .LT.
C   IO(2), AND CHOOSE IP1 AND IP2 SUCH THAT (IN(1),IO(IP1),
C   IO(IP2)) FORMS A TRIANGLE.
C
      IF (IN(1) .LT. IN(2)) GO TO 1
      IN(1) = IN(2)
      IN(2) = NIN1
      IP1 = 2
    1 IF (IO(1) .LT. IO(2)) GO TO 2
      IO(1) = IO(2)
      IO(2) = NOUT1
      IP1 = 3 - IP1
    2 IP2 = 3 - IP1
      IF (IO(2) .LT. IN(1)) GO TO 8
      IF (IN(2) .LT. IO(1)) GO TO 12
C
C IN(1) AND IO(1) PRECEDE IN(2) AND IO(2).  FOR (J,K) =
C   (1,2) AND (2,1), DELETE IO(K) AS A NEIGHBOR OF IO(J)
C   BY SHIFTING A PORTION OF IADJ EITHER UP OR DOWN AND
C   AND INSERT IN(K) AS A NEIGHBOR OF IN(J).
C
      DO 7 J = 1,2
        K = 3 - J
        IF (IN(J) .GT. IO(J)) GO TO 4
C
C   THE NEIGHBORS OF IN(J) PRECEDE THOSE OF IO(J) -- SHIFT
C     DOWN BY 1
C
        NF = 1 + TINDX(IN(J),IO(IP1),IADJ,IEND)
        NL = -1 + TINDX(IO(J),IO(K),IADJ,IEND)
        IF (NF .LE. NL) CALL SHIFTD(NF,NL,1, IADJ )
        IADJ(NF) = IN(K)
        IMIN = IN(J)
        IMAX = IO(J)-1
        DO 3 I = IMIN,IMAX
    3     IEND(I) = IEND(I) + 1
        GO TO 6
C
C   THE NEIGHBORS OF IO(J) PRECEDE THOSE OF IN(J) -- SHIFT
C     UP BY 1
C
    4   NF = 1 + TINDX(IO(J),IO(K),IADJ,IEND)
        NL = -1 + TINDX(IN(J),IO(IP2),IADJ,IEND)
        IF (NF .LE. NL) CALL SHIFTD(NF,NL,-1, IADJ )
        IADJ(NL) = IN(K)
        IMIN = IO(J)
        IMAX = IN(J) - 1
        DO 5 I = IMIN,IMAX
    5     IEND(I) = IEND(I) - 1
C
C   REVERSE (IP1,IP2) FOR (J,K) = (2,1)
C
    6   IP1 = IP2
        IP2 = 3 - IP1
    7   CONTINUE
      RETURN
C
C THE VERTICES ARE ORDERED (IO(1),IO(2),IN(1),IN(2)).
C   DELETE IO(2) BY SHIFTING UP BY 1
C
    8 NF = 1 + TINDX(IO(1),IO(2),IADJ,IEND)
      NL = -1 + TINDX(IO(2),IO(1),IADJ,IEND)
      IF (NF .LE. NL) CALL SHIFTD(NF,NL,-1, IADJ )
      IMIN = IO(1)
      IMAX = IO(2)-1
      DO 9 I = IMIN,IMAX
    9   IEND(I) = IEND(I) - 1
C
C   DELETE IO(1) BY SHIFTING UP BY 2 AND INSERT IN(2)
C
      NF = NL + 2
      NL = -1 + TINDX(IN(1),IO(IP2),IADJ,IEND)
      IF (NF .LE. NL) CALL SHIFTD(NF,NL,-2, IADJ )
      IADJ(NL-1) = IN(2)
      IMIN = IO(2)
      IMAX = IN(1)-1
      DO 10 I = IMIN,IMAX
   10   IEND(I) = IEND(I) - 2
C
C   SHIFT UP BY 1 AND INSERT IN(1)
C
      NF = NL + 1
      NL = -1 + TINDX(IN(2),IO(IP1),IADJ,IEND)
      CALL SHIFTD(NF,NL,-1, IADJ )
      IADJ(NL) = IN(1)
      IMIN = IN(1)
      IMAX = IN(2)-1
      DO 11 I = IMIN,IMAX
   11   IEND(I) = IEND(I) - 1
      RETURN
C
C THE VERTICES ARE ORDERED (IN(1),IN(2),IO(1),IO(2)).
C   DELETE IO(1) BY SHIFTING DOWN BY 1
C
   12 NF = 1 + TINDX(IO(1),IO(2),IADJ,IEND)
      NL = -1 + TINDX(IO(2),IO(1),IADJ,IEND)
      IF (NF .LE. NL) CALL SHIFTD(NF,NL,1, IADJ )
      IMIN = IO(1)
      IMAX = IO(2) - 1
      DO 13 I = IMIN,IMAX
   13   IEND(I) = IEND(I) + 1
C
C   DELETE IO(2) BY SHIFTING DOWN BY 2 AND INSERT IN(1)
C
      NL = NF - 2
      NF = 1 + TINDX(IN(2),IO(IP2),IADJ,IEND)
      IF (NF .LE. NL) CALL SHIFTD(NF,NL,2, IADJ )
      IADJ(NF+1) = IN(1)
      IMIN = IN(2)
      IMAX = IO(1) - 1
      DO 14 I = IMIN,IMAX
   14   IEND(I) = IEND(I) + 2
C
C   SHIFT DOWN BY 1 AND INSERT IN(2)
C
      NL = NF - 1
      NF = 1 + TINDX(IN(1),IO(IP1),IADJ,IEND)
      CALL SHIFTD(NF,NL,1, IADJ )
      IADJ(NF) = IN(2)
      IMIN = IN(1)
      IMAX = IN(2) - 1
      DO 15 I = IMIN,IMAX
   15   IEND(I) = IEND(I) + 1
      RETURN
      END
      LOGICAL FUNCTION SWPTST (IN1,IN2,IO1,IO2,X,Y)
      INTEGER IN1, IN2, IO1, IO2
      REAL    X(*), Y(*)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS FUNCTION DECIDES WHETHER OR NOT TO REPLACE A
C DIAGONAL ARC IN A QUADRILATERAL WITH THE OTHER DIAGONAL.
C THE DETERMINATION IS BASED ON THE SIZES OF THE ANGLES
C CONTAINED IN THE 2 TRIANGLES DEFINED BY THE DIAGONAL.
C THE DIAGONAL IS CHOSEN TO MAXIMIZE THE SMALLEST OF THE
C SIX ANGLES OVER THE TWO PAIRS OF TRIANGLES.
C
C INPUT PARAMETERS -  IN1,IN2,IO1,IO2 - NODE INDICES OF THE
C                              FOUR POINTS DEFINING THE
C                              QUADRILATERAL.  IO1 AND IO2
C                              ARE CURRENTLY CONNECTED BY A
C                              DIAGONAL ARC.  THIS ARC
C                              SHOULD BE REPLACED BY AN ARC
C                              CONNECTING IN1, IN2 IF THE
C                              DECISION IS MADE TO SWAP.
C                              IN1,IO1,IO2 MUST BE IN
C                              COUNTERCLOCKWISE ORDER.
C
C                        X,Y - VECTORS OF NODAL COORDINATES.
C                              (X(I),Y(I)) ARE THE COORD-
C                              INATES OF NODE I FOR I = IN1,
C                              IN2, IO1, OR IO2.
C
C NONE OF THE INPUT PARAMETERS ARE ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETER -  SWPTST - .TRUE. IFF THE ARC CONNECTING
C                              IO1 AND IO2 IS TO BE REPLACED
C
C MODULES REFERENCED BY SWPTST - NONE
C
C***********************************************************
C
      REAL DX11, DX12, DX22, DX21, DY11, DY12, DY22, DY21,
     .     SIN1, SIN2, COS1, COS2, SIN12
C
C LOCAL PARAMETERS -
C
C DX11,DY11 = X,Y COORDINATES OF THE VECTOR IN1-IO1
C DX12,DY12 = X,Y COORDINATES OF THE VECTOR IN1-IO2
C DX22,DY22 = X,Y COORDINATES OF THE VECTOR IN2-IO2
C DX21,DY21 = X,Y COORDINATES OF THE VECTOR IN2-IO1
C SIN1 =      CROSS PRODUCT OF THE VECTORS IN1-IO1 AND
C               IN1-IO2 -- PROPORTIONAL TO SIN(T1) WHERE T1
C               IS THE ANGLE AT IN1 FORMED BY THE VECTORS
C COS1 =      INNER PRODUCT OF THE VECTORS IN1-IO1 AND
C               IN1-IO2 -- PROPORTIONAL TO COS(T1)
C SIN2 =      CROSS PRODUCT OF THE VECTORS IN2-IO2 AND
C               IN2-IO1 -- PROPORTIONAL TO SIN(T2) WHERE T2
C               IS THE ANGLE AT IN2 FORMED BY THE VECTORS
C COS2 =      INNER PRODUCT OF THE VECTORS IN2-IO2 AND
C               IN2-IO1 -- PROPORTIONAL TO COS(T2)
C SIN12 =     SIN1*COS2 + COS1*SIN2 -- PROPORTIONAL TO
C               SIN(T1+T2)
C
      SWPTST = .FALSE.
C
C COMPUTE THE VECTORS CONTAINING THE ANGLES T1, T2
C
      DX11 = X(IO1) - X(IN1)
      DX12 = X(IO2) - X(IN1)
      DX22 = X(IO2) - X(IN2)
      DX21 = X(IO1) - X(IN2)
C
      DY11 = Y(IO1) - Y(IN1)
      DY12 = Y(IO2) - Y(IN1)
      DY22 = Y(IO2) - Y(IN2)
      DY21 = Y(IO1) - Y(IN2)
C
C COMPUTE INNER PRODUCTS
C
      COS1 = DX11*DX12 + DY11*DY12
      COS2 = DX22*DX21 + DY22*DY21
C
C THE DIAGONALS SHOULD BE SWAPPED IFF (T1+T2) .GT. 180
C   DEGREES.  THE FOLLOWING TWO TESTS INSURE NUMERICAL
C   STABILITY.
C
      IF (COS1 .GE. 0.  .AND.  COS2 .GE. 0.) RETURN
      IF (COS1 .LT. 0.  .AND.  COS2 .LT. 0.) GO TO 1
C
C COMPUTE VECTOR CROSS PRODUCTS
C
      SIN1 = DX11*DY12 - DX12*DY11
      SIN2 = DX22*DY21 - DX21*DY22
      SIN12 = SIN1*COS2 + COS1*SIN2
      IF (SIN12 .GE. 0.) RETURN
    1 SWPTST = .TRUE.
      RETURN
      END
      INTEGER FUNCTION TINDX (NVERTX,NABOR,IADJ,IEND)
      INTEGER NVERTX, NABOR, IADJ(*), IEND(*)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS FUNCTION RETURNS THE INDEX OF NABOR IN THE
C ADJACENCY LIST FOR NVERTX.
C
C INPUT PARAMETERS - NVERTX - NODE WHOSE ADJACENCY LIST IS
C                             TO BE SEARCHED.
C
C                     NABOR - NODE WHOSE INDEX IS TO BE
C                             RETURNED.  NABOR MUST BE
C                             CONNECTED TO NVERTX.
C
C                      IADJ - SET OF ADJACENCY LISTS.
C
C                      IEND - POINTERS TO THE ENDS OF
C                             ADJACENCY LISTS IN IADJ.
C
C INPUT PARAMETERS ARE NOT ALTERED BY THIS FUNCTION.
C
C OUTPUT PARAMETER -  TINDX - IADJ(TINDX) = NABOR.
C
C MODULES REFERENCED BY TINDX - NONE
C
C***********************************************************
C
      INTEGER NB, INDX
C
C LOCAL PARAMETERS -
C
C NB =   LOCAL COPY OF NABOR
C INDX = INDEX FOR IADJ
C
      NB = NABOR
C
C INITIALIZATION
C
      INDX = IEND(NVERTX) + 1
C
C SEARCH THE LIST OF NVERTX NEIGHBORS FOR NB
C
    1 INDX = INDX - 1
      IF (IADJ(INDX) .NE. NB) GO TO 1
C
      TINDX = INDX
      RETURN
      END
      SUBROUTINE TRFIND (NST,PX,PY,X,Y,IADJ,IEND, I1,I2,I3)
      INTEGER NST, IADJ(*), IEND(*), I1, I2, I3
      REAL    PX, PY, X(*), Y(*)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS ROUTINE LOCATES A POINT P IN A THIESSEN TRIANGU-
C LATION, RETURNING THE VERTEX INDICES OF A TRIANGLE WHICH
C CONTAINS P.  TRFIND IS PART OF AN INTERPOLATION PACKAGE
C WHICH PROVIDES SUBROUTINES FOR CREATING THE MESH.
C
C INPUT PARAMETERS -    NST - INDEX OF NODE AT WHICH TRFIND
C                             BEGINS SEARCH.  SEARCH TIME
C                             DEPENDS ON THE PROXIMITY OF
C                             NST TO P.
C
C                     PX,PY - X AND Y-COORDINATES OF THE
C                             POINT TO BE LOCATED.
C
C                       X,Y - VECTORS OF COORDINATES OF
C                             NODES IN THE MESH.  (X(I),Y(I))
C                             DEFINES NODE I FOR I = 1,...,N
C                             WHERE N .GE. 3.
C
C                      IADJ - SET OF ADJACENCY LISTS OF
C                             NODES IN THE MESH.
C
C                      IEND - POINTERS TO THE ENDS OF
C                             ADJACENCY LISTS IN IADJ FOR
C                             EACH NODE IN THE MESH.
C
C IADJ AND IEND MAY BE CREATED BY TRMESH.
C
C INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETERS - I1,I2,I3 - VERTEX INDICES IN COUNTER-
C                                CLOCKWISE ORDER - VERTICES
C                                OF A TRIANGLE CONTAINING P
C                                IF P IS AN INTERIOR NODE.
C                                IF P IS OUTSIDE OF THE
C                                BOUNDARY OF THE MESH, I1
C                                AND I2 ARE THE FIRST (RIGHT
C                                -MOST) AND LAST (LEFTMOST)
C                                NODES WHICH ARE VISIBLE
C                                FROM P, AND I3 = 0.  IF P
C                                AND ALL OF THE NODES LIE ON
C                                A SINGLE LINE THEN I1 = I2
C                                = I3 = 0.
C
C MODULES REFERENCED BY TRFIND - NONE
C
C INTRINSIC FUNCTION CALLED BY TRFIND - MAX0
C
C***********************************************************
C
      INTEGER N0, N1, N2, N3, N4, INDX, IND, NF,
     .        NL, NEXT
      REAL    XP, YP
      LOGICAL LEFT
C
C LOCAL PARAMETERS -
C
C XP,YP =     LOCAL VARIABLES CONTAINING PX AND PY
C N0,N1,N2 =  NODES IN COUNTERCLOCKWISE ORDER DEFINING A
C               CONE (WITH VERTEX N0) CONTAINING P
C N3,N4 =     NODES OPPOSITE N1-N2 AND N2-N1, RESPECTIVELY
C INDX,IND =  INDICES FOR IADJ
C NF,NL =     FIRST AND LAST NEIGHBORS OF N0 IN IADJ, OR
C               FIRST (RIGHTMOST) AND LAST (LEFTMOST) NODES
C               VISIBLE FROM P WHEN P IS OUTSIDE THE
C               BOUNDARY
C NEXT =      CANDIDATE FOR I1 OR I2 WHEN P IS OUTSIDE OF
C               THE BOUNDARY
C LEFT =      STATEMENT FUNCTION WHICH COMPUTES THE SIGN OF
C               A CROSS PRODUCT (Z-COMPONENT).  LEFT(X1,...,
C               Y0) = .TRUE. IFF (X0,Y0) IS ON OR TO THE
C               LEFT OF THE VECTOR FROM (X1,Y1) TO (X2,Y2).
C
      LEFT(X1,Y1,X2,Y2,X0,Y0) = (X2-X1)*(Y0-Y1) .GE.
     .                          (X0-X1)*(Y2-Y1)
      XP = PX
      YP = PY
C
C INITIALIZE VARIABLES AND FIND A CONE CONTAINING P
C
      N0 = MAX0(NST,1)
    1 INDX = IEND(N0)
      NL = IADJ(INDX)
      INDX = 1
      IF (N0 .NE. 1) INDX = IEND(N0-1) + 1
      NF = IADJ(INDX)
      N1 = NF
      IF (NL .NE. 0) GO TO 3
C
C N0 IS A BOUNDARY NODE.  SET NL TO THE LAST NONZERO
C   NEIGHBOR OF N0.
C
      IND = IEND(N0) - 1
      NL = IADJ(IND)
      IF ( LEFT(X(N0),Y(N0),X(NF),Y(NF),XP,YP) ) GO TO 2
C
C P IS OUTSIDE THE BOUNDARY
C
      NL = N0
      GO TO 16
    2 IF ( LEFT(X(NL),Y(NL),X(N0),Y(N0),XP,YP) ) GO TO 4
C
C P IS OUTSIDE THE BOUNDARY AND N0 IS THE RIGHTMOST
C   VISIBLE BOUNDARY NODE
C
      I1 = N0
      GO TO 18
C
C N0 IS AN INTERIOR NODE.  FIND N1.
C
    3 IF ( LEFT(X(N0),Y(N0),X(N1),Y(N1),XP,YP) ) GO TO 4
      INDX = INDX + 1
      N1 = IADJ(INDX)
      IF (N1 .EQ. NL) GO TO 7
      GO TO 3
C
C P IS TO THE LEFT OF ARC N0-N1.  INITIALIZE N2 TO THE NEXT
C   NEIGHBOR OF N0.
C
    4 INDX = INDX + 1
      N2 = IADJ(INDX)
      IF ( .NOT. LEFT(X(N0),Y(N0),X(N2),Y(N2),XP,YP) )
     .   GO TO 8
      N1 = N2
      IF (N1 .NE. NL) GO TO 4
      IF ( .NOT. LEFT(X(N0),Y(N0),X(NF),Y(NF),XP,YP) )
     .   GO TO 7
      IF (XP .EQ. X(N0) .AND. YP .EQ. Y(N0)) GO TO 6
C
C P IS LEFT OF OR ON ARCS N0-NB FOR ALL NEIGHBORS NB
C   OF N0.
C ALL POINTS ARE COLLINEAR IFF P IS LEFT OF NB-N0 FOR
C   ALL NEIGHBORS NB OF N0.  SEARCH THE NEIGHBORS OF N0
C   IN REVERSE ORDER.  NOTE -- N1 = NL AND INDX POINTS TO
C   NL.
C
    5 IF ( .NOT. LEFT(X(N1),Y(N1),X(N0),Y(N0),XP,YP) )
     .   GO TO 6
      IF (N1 .EQ. NF) GO TO 20
      INDX = INDX - 1
      N1 = IADJ(INDX)
      GO TO 5
C
C P IS TO THE RIGHT OF N1-N0, OR P=N0.  SET N0 TO N1 AND
C   START OVER.
C
    6 N0 = N1
      GO TO 1
C
C P IS BETWEEN ARCS N0-N1 AND N0-NF
C
    7 N2 = NF
C
C P IS CONTAINED IN A CONE DEFINED BY LINE SEGMENTS N0-N1
C   AND N0-N2 WHERE N1 IS ADJACENT TO N2
C
    8 N3 = N0
    9 IF ( LEFT(X(N1),Y(N1),X(N2),Y(N2),XP,YP) ) GO TO 13
C
C SET N4 TO THE FIRST NEIGHBOR OF N2 FOLLOWING N1
C
      INDX = IEND(N2)
      IF (IADJ(INDX) .NE. N1) GO TO 10
C
C N1 IS THE LAST NEIGHBOR OF N2.
C SET N4 TO THE FIRST NEIGHBOR.
C
      INDX = 1
      IF (N2 .NE. 1) INDX = IEND(N2-1) + 1
      N4 = IADJ(INDX)
      GO TO 11
C
C N1 IS NOT THE LAST NEIGHBOR OF N2
C
   10 INDX = INDX-1
      IF (IADJ(INDX) .NE. N1) GO TO 10
      N4 = IADJ(INDX+1)
      IF (N4 .NE. 0) GO TO 11
C
C P IS OUTSIDE THE BOUNDARY
C
      NF = N2
      NL = N1
      GO TO 16
C
C DEFINE A NEW ARC N1-N2 WHICH INTERSECTS THE LINE
C   SEGMENT N0-P
C
   11 IF ( LEFT(X(N0),Y(N0),X(N4),Y(N4),XP,YP) ) GO TO 12
      N3 = N2
      N2 = N4
      GO TO 9
   12 N3 = N1
      N1 = N4
      GO TO 9
C
C P IS IN THE TRIANGLE (N1,N2,N3) AND NOT ON N2-N3.  IF
C   N3-N1 OR N1-N2 IS A BOUNDARY ARC CONTAINING P, TREAT P
C   AS EXTERIOR.
C
   13 INDX = IEND(N1)
      IF (IADJ(INDX) .NE. 0) GO TO 15
C
C N1 IS A BOUNDARY NODE.  N3-N1 IS A BOUNDARY ARC IFF N3
C   IS THE LAST NONZERO NEIGHBOR OF N1.
C
      IF (N3 .NE. IADJ(INDX-1)) GO TO 14
C
C N3-N1 IS A BOUNDARY ARC
C
      IF ( .NOT. LEFT(X(N1),Y(N1),X(N3),Y(N3),XP,YP) )
     .   GO TO 14
C
C P LIES ON N1-N3
C
      I1 = N1
      I2 = N3
      I3 = 0
      RETURN
C
C N3-N1 IS NOT A BOUNDARY ARC CONTAINING P.  N1-N2 IS A
C   BOUNDARY ARC IFF N2 IS THE FIRST NEIGHBOR OF N1.
C
   14 INDX = 1
      IF (N1 .NE. 1) INDX = IEND(N1-1) + 1
      IF (N2 .NE. IADJ(INDX)) GO TO 15
C
C N1-N2 IS A BOUNDARY ARC
C
      IF ( .NOT. LEFT(X(N2),Y(N2),X(N1),Y(N1),XP,YP) )
     .   GO TO 15
C
C P LIES ON N1-N2
C
      I1 = N2
      I2 = N1
      I3 = 0
      RETURN
C
C P DOES NOT LIE ON A BOUNDARY ARC.
C
   15 I1 = N1
      I2 = N2
      I3 = N3
      RETURN
C
C NF AND NL ARE ADJACENT BOUNDARY NODES WHICH ARE VISIBLE
C   FROM P.  FIND THE FIRST VISIBLE BOUNDARY NODE.
C SET NEXT TO THE FIRST NEIGHBOR OF NF.
C
   16 INDX = 1
      IF (NF .NE. 1) INDX = IEND(NF-1) + 1
      NEXT = IADJ(INDX)
      IF ( LEFT(X(NF),Y(NF),X(NEXT),Y(NEXT),XP,YP) )
     .   GO TO 17
      NF = NEXT
      GO TO 16
C
C NF IS THE FIRST (RIGHTMOST) VISIBLE BOUNDARY NODE
C
   17 I1 = NF
C
C FIND THE LAST VISIBLE BOUNDARY NODE.  NL IS THE FIRST
C   CANDIDATE FOR I2.
C SET NEXT TO THE LAST NEIGHBOR OF NL.
C
   18 INDX = IEND(NL) - 1
      NEXT = IADJ(INDX)
      IF ( LEFT(X(NEXT),Y(NEXT),X(NL),Y(NL),XP,YP) )
     .   GO TO 19
      NL = NEXT
      GO TO 18
C
C NL IS THE LAST (LEFTMOST) VISIBLE BOUNDARY NODE
C
   19 I2 = NL
      I3 = 0
      RETURN
C
C ALL POINTS ARE COLLINEAR
C
   20 I1 = 0
      I2 = 0
      I3 = 0
      RETURN
      END
      SUBROUTINE GRADG (N, X, Y, Z, IADJ, IEND, ZXZY, IERR)
C-----------------------------------------------------------------------
C                      DERIVATIVE ESTIMATION
C-----------------------------------------------------------------------
      REAL X(N), Y(N), Z(N), ZXZY(2,N)
      INTEGER IADJ(*), IEND(N)
C
      IF (N .LT. 3) GO TO 20
C
      EPS = 0.0
      MITER = 5
      DO 10 J = 1,N
         ZXZY(1,J) = 0.0
         ZXZY(2,J) = 0.0
   10 CONTINUE
      CALL GRADG1 (N, X, Y, Z, IADJ, IEND, EPS, MITER, ZXZY, IERR)
      IERR = 0
      RETURN
C
C     ERROR RETURN
C
   20 IERR = 1
      RETURN
      END
      SUBROUTINE GRADG1 (N,X,Y,Z,IADJ,IEND,EPS, NIT,
     .                   ZXZY, IER)
      INTEGER N, IADJ(*), IEND(N), NIT, IER
      REAL    X(N), Y(N), Z(N), EPS, ZXZY(2,N)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   GIVEN A TRIANGULATION OF N NODES IN THE PLANE WITH
C ASSOCIATED DATA VALUES, THIS ROUTINE USES A GLOBAL METHOD
C TO COMPUTE ESTIMATED GRADIENTS AT THE NODES.  THE METHOD
C CONSISTS OF MINIMIZING A QUADRATIC FUNCTIONAL Q(G) OVER
C THE N-VECTOR G OF GRADIENTS WHERE Q APPROXIMATES THE LIN-
C EARIZED CURVATURE OF AN INTERPOLANT F OVER THE TRIANGULA-
C TION.  THE RESTRICTION OF F TO AN ARC OF THE TRIANGULATION
C IS TAKEN TO BE THE HERMITE CUBIC INTERPOLANT OF THE DATA
C VALUES AND TANGENTIAL GRADIENT COMPONENTS AT THE END-
C POINTS OF THE ARC, AND Q IS THE SUM OF THE LINEARIZED
C CURVATURES OF F ALONG THE ARCS -- THE INTEGRALS OVER THE
C ARCS OF D2F(T)**2 WHERE D2F(T) IS THE SECOND DERIVATIVE
C OF F WITH RESPECT TO DISTANCE T ALONG THE ARC.  THIS MIN-
C IMIZATION PROBLEM CORRESPONDS TO AN ORDER 2N SYMMETRIC
C POSITIVE-DEFINITE SPARSE LINEAR SYSTEM WHICH IS SOLVED FOR
C THE X AND Y PARTIAL DERIVATIVES BY THE BLOCK GAUSS-SEIDEL
C METHOD WITH 2 BY 2 BLOCKS.
C   AN ALTERNATIVE METHOD, SUBROUTINE GRADL, COMPUTES A
C LOCAL APPROXIMATION TO THE PARTIALS AT A SINGLE NODE AND
C MAY BE MORE ACCURATE, DEPENDING ON THE DATA VALUES AND
C DISTRIBUTION OF NODES (NEITHER METHOD EMERGED AS SUPERIOR
C IN TESTS FOR ACCURACY).  HOWEVER, IN TESTS RUN ON AN IBM
C 370, GRADG1 WAS FOUND TO BE ABOUT 3.6 TIMES AS FAST FOR
C NIT = 4.
C
C INPUT PARAMETERS - N - NUMBER OF NODES.  N .GE. 3.
C
C                  X,Y - CARTESIAN COORDINATES OF THE NODES.
C
C                    Z - DATA VALUES AT THE NODES.  Z(I) IS
C                        ASSOCIATED WITH (X(I),Y(I)).
C
C            IADJ,IEND - DATA STRUCTURE DEFINING THE TRIAN-
C                        GULATION.  SEE SUBROUTINE TRMESH.
C
C                  EPS - NONNEGATIVE CONVERGENCE CRITERION.
C                        THE METHOD IS TERMINATED WHEN THE
C                        MAXIMUM CHANGE IN A GRADIENT COMPO-
C                        NENT BETWEEN ITERATIONS IS AT MOST
C                        EPS.  EPS = 1.E-2 IS SUFFICIENT FOR
C                        EFFECTIVE CONVERGENCE.
C
C THE ABOVE PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
C
C                  NIT - MAXIMUM NUMBER OF GAUSS-SEIDEL
C                        ITERATIONS TO BE APPLIED.  THIS
C                        MAXIMUM WILL LIKELY BE ACHIEVED IF
C                        EPS IS SMALLER THAN THE MACHINE
C                        PRECISION.  OPTIMAL EFFICIENCY WAS
C                        ACHIEVED IN TESTING WITH EPS = 0
C                        AND NIT = 3 OR 4.
C
C                 ZXZY - 2 BY N ARRAY WHOSE COLUMNS CONTAIN
C                        INITIAL ESTIMATES OF THE PARTIAL
C                        DERIVATIVES (ZERO VECTORS ARE
C                        SUFFICIENT).
C
C OUTPUT PARAMETERS - NIT - NUMBER OF GAUSS-SEIDEL ITERA-
C                           TIONS EMPLOYED.
C
C                    ZXZY - ESTIMATED X AND Y PARTIAL DERIV-
C                           ATIVES AT THE NODES WITH X PAR-
C                           TIALS IN THE FIRST ROW.  ZXZY IS
C                           NOT CHANGED IF IER = 2.
C
C                     IER - ERROR INDICATOR
C                           IER = 0 IF THE CONVERGENCE CRI-
C                                   TERION WAS ACHIEVED.
C                           IER = 1 IF CONVERGENCE WAS NOT
C                                   ACHIEVED WITHIN NIT
C                                   ITERATIONS.
C                           IER = 2 IF N OR EPS IS OUT OF
C                                   RANGE OR NIT .LT. 0 ON
C                                   INPUT.
C
C MODULES REFERENCED BY GRADG1 - NONE
C
C INTRINSIC FUNCTIONS CALLED BY GRADG1 - SQRT, AMAX1, ABS
C
C***********************************************************
C
      INTEGER NN, MAXIT, ITER, K, INDF, INDL, INDX, NB
      REAL    TOL, DGMAX, XK, YK, ZK, ZXK, ZYK, A11, A12,
     .        A22, R1, R2, DELX, DELY, DELXS, DELYS, DSQ,
     .        DCUB, T, DZX, DZY
C
C LOCAL PARAMETERS -
C
C NN =          LOCAL COPY OF N
C MAXIT =       INPUT VALUE OF NIT
C ITER =        NUMBER OF ITERATIONS USED
C K =           DO-LOOP AND NODE INDEX
C INDF,INDL =   IADJ INDICES OF THE FIRST AND LAST NEIGHBORS
C                 OF K
C INDX =        IADJ INDEX IN THE RANGE INDF,...,INDL
C NB =          NEIGHBOR OF K
C TOL =         LOCAL COPY OF EPS
C DGMAX =       MAXIMUM CHANGE IN A GRADIENT COMPONENT BE-
C                 TWEEN ITERATIONS
C XK,YK,ZK =    X(K), Y(K), Z(K)
C ZXK,ZYK =     INITIAL VALUES OF ZXZY(1,K) AND ZXZY(2,K)
C A11,A12,A22 = MATRIX COMPONENTS OF THE 2 BY 2 BLOCK A*DG
C                 = R WHERE A IS SYMMETRIC, DG = (DZX,DZY)
C                 IS THE CHANGE IN THE GRADIENT AT K, AND R
C                 IS THE RESIDUAL
C R1,R2 =       COMPONENTS OF THE RESIDUAL -- DERIVATIVES OF
C                 Q WITH RESPECT TO THE COMPONENTS OF THE
C                 GRADIENT AT NODE K
C DELX,DELY =   COMPONENTS OF THE ARC NB-K
C DELXS,DELYS = DELX**2, DELY**2
C DSQ =         SQUARE OF THE DISTANCE D BETWEEN K AND NB
C DCUB =        D**3
C T =           FACTOR OF R1 AND R2
C DZX,DZY =     SOLUTION OF THE 2 BY 2 SYSTEM -- CHANGE IN
C                 DERIVATIVES AT K FROM THE PREVIOUS ITERATE
C
      NN = N
      TOL = EPS
      MAXIT = NIT
C
C ERROR CHECKS AND INITIALIZATION
C
      IF (NN .LT. 3  .OR.  TOL .LT. 0.  .OR.  MAXIT .LT. 0)
     .   GO TO 5
      ITER = 0
C
C TOP OF ITERATION LOOP
C
    1 IF (ITER .EQ. MAXIT) GO TO 4
      DGMAX = 0.
      INDL = 0
      DO 3 K = 1,NN
        XK = X(K)
        YK = Y(K)
        ZK = Z(K)
        ZXK = ZXZY(1,K)
        ZYK = ZXZY(2,K)
C
C   INITIALIZE COMPONENTS OF THE 2 BY 2 SYSTEM
C
        A11 = 0.
        A12 = 0.
        A22 = 0.
        R1 = 0.
        R2 = 0.
C
C   LOOP ON NEIGHBORS NB OF K
C
        INDF = INDL + 1
        INDL = IEND(K)
        DO 2 INDX = INDF,INDL
          NB = IADJ(INDX)
          IF (NB .EQ. 0) GO TO 2
C
C   COMPUTE THE COMPONENTS OF ARC NB-K
C
          DELX = X(NB) - XK
          DELY = Y(NB) - YK
          DELXS = DELX*DELX
          DELYS = DELY*DELY
          DSQ = DELXS + DELYS
          DCUB = DSQ*SQRT(DSQ)
C
C   UPDATE THE SYSTEM COMPONENTS FOR NODE NB
C
          A11 = A11 + DELXS/DCUB
          A12 = A12 + DELX*DELY/DCUB
          A22 = A22 + DELYS/DCUB
          T = ( 1.5*(Z(NB)-ZK) - ((ZXZY(1,NB)/2.+ZXK)*DELX +
     .          (ZXZY(2,NB)/2.+ZYK)*DELY) )/DCUB
          R1 = R1 + T*DELX
          R2 = R2 + T*DELY
    2     CONTINUE
C
C   SOLVE THE 2 BY 2 SYSTEM AND UPDATE DGMAX
C
        DZY = (A11*R2 - A12*R1)/(A11*A22 - A12*A12)
        DZX = (R1 - A12*DZY)/A11
        DGMAX = AMAX1(DGMAX,ABS(DZX),ABS(DZY))
C
C   UPDATE THE PARTIALS AT NODE K
C
        ZXZY(1,K) = ZXK + DZX
    3   ZXZY(2,K) = ZYK + DZY
C
C   INCREMENT ITER AND TEST FOR CONVERGENCE
C
      ITER = ITER + 1
      IF (DGMAX .GT. TOL) GO TO 1
C
C METHOD CONVERGED
C
      NIT = ITER
      IER = 0
      RETURN
C
C METHOD FAILED TO CONVERGE WITHIN NIT ITERATIONS
C
    4 IER = 1
      RETURN
C
C PARAMETER OUT OF RANGE
C
    5 NIT = 0
      IER = 2
      RETURN
      END
      SUBROUTINE GRADL (N, X, Y, Z, IADJ, IEND, ZXZY, IERR)
C-----------------------------------------------------------------------
C                      DERIVATIVE ESTIMATION
C-----------------------------------------------------------------------
      REAL X(N), Y(N), Z(N), ZXZY(2,N)
      INTEGER IADJ(*), IEND(N)
C
      IF (N .LT. 3) GO TO 20
C
      DO 10 J = 1,N
         CALL GRADL1 (N, J, X, Y, Z, IADJ, IEND, ZXZY(1,J),
     *               ZXZY(2,J), IERR)
         IF (IERR .LT. 0) GO TO 30
   10 CONTINUE
      IERR = 0
      RETURN
C
C     ERROR RETURN
C
   20 IERR = 1
      RETURN
C
   30 IERR = 2
      RETURN
      END
      SUBROUTINE GRADL1 (N,K,X,Y,Z,IADJ,IEND, DX,DY,IER)
      INTEGER N, K, IADJ(*), IEND(N), IER
      REAL    X(N), Y(N), Z(N), DX, DY
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   GIVEN A THIESSEN TRIANGULATION OF N POINTS IN THE PLANE
C WITH ASSOCIATED DATA VALUES Z, THIS SUBROUTINE ESTIMATES
C X AND Y PARTIAL DERIVATIVES AT NODE K.  THE DERIVATIVES
C ARE TAKEN TO BE THE PARTIALS AT K OF A QUADRATIC FUNCTION
C WHICH INTERPOLATES Z(K) AND FITS THE DATA VALUES AT A SET
C OF NEARBY NODES IN A WEIGHTED LEAST SQUARES SENSE. A MAR-
C QUARDT STABILIZATION FACTOR IS USED IF NECESSARY TO ENSURE
C A WELL-CONDITIONED SYSTEM AND A LINEAR FITTING FUNCTION IS
C USED IF N .LT. 6.  THUS, A UNIQUE SOLUTION EXISTS UNLESS
C THE NODES ARE COLLINEAR.
C   AN ALTERNATIVE ROUTINE, GRADG, EMPLOYS A GLOBAL METHOD
C TO COMPUTE THE PARTIAL DERIVATIVES AT ALL OF THE NODES AT
C ONCE.  THAT METHOD IS MORE EFFICIENT (WHEN ALL PARTIALS
C ARE NEEDED) AND MAY BE MORE ACCURATE, DEPENDING ON THE
C DATA.
C
C INPUT PARAMETERS - N - NUMBER OF NODES IN THE TRIANGULA-
C                        TION.  N .GE. 3.
C
C                    K - NODE AT WHICH DERIVATIVES ARE
C                        SOUGHT.  1 .LE. K .LE. N.
C
C                  X,Y - N-VECTORS CONTAINING THE CARTESIAN
C                        COORDINATES OF THE NODES.
C
C                    Z - N-VECTOR CONTAINING THE DATA VALUES
C                        ASSOCIATED WITH THE NODES.
C
C                 IADJ - SET OF ADJACENCY LISTS.
C
C                 IEND - POINTERS TO THE ENDS OF ADJACENCY
C                        LISTS FOR EACH NODE.
C
C IADJ AND IEND MAY BE CREATED BY SUBROUTINE TRMESH.
C
C INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETERS - DX,DY - ESTIMATED PARTIAL DERIVATIVES
C                             AT NODE K UNLESS IER .LT. 0.
C
C                       IER - ERROR INDICATOR
C                             IER .GT. 0 IF NO ERRORS WERE
C                                      ENCOUNTERED.  IER
C                                      CONTAINS THE NUMBER
C                                      OF NODES (INCLUDING
C                                      K) USED IN THE FIT.
C                                      IER = 3, 4, OR 5 IM-
C                                      PLIES A LINEAR FIT.
C                             IER = -1 IF N OR K IS OUT OF
C                                      RANGE.
C                             IER = -2 IF ALL NODES ARE
C                                      COLLINEAR.
C
C MODULES REFERENCED BY GRADL1 - GETNP, SETRM, SROTG, SROT
C
C INTRINSIC FUNCTIONS CALLED BY GRADL1 - MIN0, FLOAT, SQRT,
C                                       AMIN1, ABS
C
C***********************************************************
C
      INTEGER NN, KK, LMN, LMX, LMIN, LMAX, LM1, LNP,
     .        NPTS(30), IERR, NP, I, J, IM1, JP1, IP1, L
      REAL    SUM, DS, R, RS, RTOL, AVSQ, AV, XK, YK, ZK,
     .        A(6,6), C, S, DMIN, DTOL, SF
      DATA    LMN/10/
      DATA    LMX/30/, RTOL/1.E-5/, DTOL/.01/, SF/1./
C
C LOCAL PARAMETERS -
C
C NN,KK =     LOCAL COPIES OF N AND K
C LMN,LMX =   MINIMUM AND MAXIMUM VALUES OF LNP FOR N
C               SUFFICIENTLY LARGE.  IN MOST CASES LMN-1
C               NODES ARE USED IN THE FIT.  4 .LE. LMN .LE.
C               LMX.
C LMIN,LMAX = MIN(LMN,N), MIN(LMX,N)
C LM1 =       LMIN-1 OR LNP-1
C LNP =       LENGTH OF NPTS
C NPTS =      ARRAY CONTAINING THE INDICES OF A SEQUENCE OF
C               NODES ORDERED BY DISTANCE FROM K.  NPTS(1)=K
C               AND THE FIRST LNP-1 ELEMENTS OF NPTS ARE
C               USED IN THE LEAST SQUARES FIT.  UNLESS LNP
C               EXCEEDS LMAX, NPTS(LNP) DETERMINES R.
C IERR =      ERROR FLAG FOR CALLS TO GETNP (NOT CHECKED)
C NP =        ELEMENT OF NPTS TO BE ADDED TO THE SYSTEM
C I,J =       DO-LOOP INDICES
C IM1,JP1 =   I-1, J+1
C IP1 =       I+1
C L =         NUMBER OF COLUMNS OF A**T TO WHICH A ROTATION
C               IS APPLIED
C SUM =       SUM OF SQUARED EUCLIDEAN DISTANCES BETWEEN
C               NODE K AND THE NODES USED IN THE LEAST
C               SQUARES FIT
C DS =        SQUARED DISTANCE BETWEEN NODE K AND AN ELE-
C               MENT OF NPTS
C R =         DISTANCE BETWEEN NODE K AND NPTS(LNP) OR SOME
C               POINT FURTHER FROM K THAN NPTS(LMAX) IF
C               NPTS(LMAX) IS USED IN THE FIT.  R IS A
C               RADIUS OF INFLUENCE WHICH ENTERS INTO THE
C               WEIGHTS (SEE SUBROUTINE SETRM).
C RS =        R*R
C RTOL =      TOLERANCE FOR DETERMINING R.  IF THE RELATIVE
C               CHANGE IN DS BETWEEN TWO ELEMENTS OF NPTS IS
C               NOT GREATER THAN RTOL THEY ARE TREATED AS
C               BEING THE SAME DISTANCE FROM NODE K
C AVSQ =      AV*AV
C AV =        ROOT-MEAN-SQUARE DISTANCE BETWEEN K AND THE
C               NODES (OTHER THAN K) IN THE LEAST SQUARES
C               FIT.  THE FIRST 3 COLUMNS OF THE SYSTEM ARE
C               SCALED BY 1/AVSQ, THE NEXT 2 BY 1/AV.
C XK,YK,ZK =  COORDINATES AND DATA VALUE ASSOCIATED WITH K
C A =         TRANSPOSE OF THE AUGMENTED REGRESSION MATRIX
C C,S =       COMPONENTS OF THE PLANE ROTATION DETERMINED
C               BY SUBROUTINE SROTG
C DMIN =      MINIMUM OF THE MAGNITUDES OF THE DIAGONAL
C               ELEMENTS OF THE REGRESSION MATRIX AFTER
C               ZEROS ARE INTRODUCED BELOW THE DIAGONAL
C DTOL =      TOLERANCE FOR DETECTING AN ILL-CONDITIONED
C               SYSTEM.  THE SYSTEM IS ACCEPTED WHEN DMIN
C               .GE. DTOL
C SF =        MARQUARDT STABILIZATION FACTOR USED TO DAMP
C               OUT THE FIRST 3 SOLUTION COMPONENTS (SECOND
C               PARTIALS OF THE QUADRATIC) WHEN THE SYSTEM
C               IS ILL-CONDITIONED.  AS SF INCREASES, THE
C               FITTING FUNCTION APPROACHES A LINEAR
C
      NN = N
      KK = K
C
C CHECK FOR ERRORS AND INITIALIZE LMIN, LMAX
C
      IF (NN .LT. 3  .OR.  KK .LT. 1  .OR.  KK .GT. NN)
     .   GO TO 16
      LMIN = MIN0(LMN,NN)
      LMAX = MIN0(LMX,NN)
C
C COMPUTE NPTS, LNP, AVSQ, AV, AND R.
C   SET NPTS TO THE CLOSEST LMIN-1 NODES TO K.
C
      SUM = 0.
      NPTS(1) = KK
      LM1 = LMIN - 1
      DO 1 LNP = 2,LM1
        CALL GETNP (X,Y,IADJ,IEND,LNP, NPTS, DS,IERR)
    1   SUM = SUM + DS
C
C ADD ADDITIONAL NODES TO NPTS UNTIL THE RELATIVE INCREASE
C   IN DS IS AT LEAST RTOL.
C
      DO 2 LNP = LMIN,LMAX
        CALL GETNP (X,Y,IADJ,IEND,LNP, NPTS, RS,IERR)
        IF ((RS-DS)/DS .LE. RTOL) GO TO 2
        IF (LNP .GT. 6) GO TO 3
    2   SUM = SUM + RS
C
C USE ALL LMAX NODES IN THE LEAST SQUARES FIT.  RS IS
C   ARBITRARILY INCREASED BY 10 PER CENT.
C
      RS = 1.1*RS
      LNP = LMAX + 1
C
C THERE ARE LNP-2 EQUATIONS CORRESPONDING TO NODES NPTS(2),
C   ...,NPTS(LNP-1).
C
    3 AVSQ = SUM/FLOAT(LNP-2)
      AV = SQRT(AVSQ)
      R = SQRT(RS)
      XK = X(KK)
      YK = Y(KK)
      ZK = Z(KK)
      IF (LNP .LT. 7) GO TO 12
C
C SET UP THE FIRST 5 EQUATIONS OF THE AUGMENTED REGRESSION
C   MATRIX (TRANSPOSED) AS THE COLUMNS OF A, AND ZERO OUT
C   THE LOWER TRIANGLE (UPPER TRIANGLE OF A) WITH GIVENS
C   ROTATIONS
C
      DO 5 I = 1,5
        NP = NPTS(I+1)
        CALL SETRM (XK,YK,ZK,X(NP),Y(NP),Z(NP),AV,AVSQ,
     .              R, A(1,I))
        IF (I .EQ. 1) GO TO 5
        IM1 = I - 1
        DO 4 J = 1,IM1
          JP1 = J + 1
          L = 6 - J
          CALL SROTG (A(J,J),A(J,I),C,S)
    4     CALL SROT (L,A(JP1,J),1,A(JP1,I),1,C,S)
    5   CONTINUE
C
C ADD THE ADDITIONAL EQUATIONS TO THE SYSTEM USING
C   THE LAST COLUMN OF A -- I .LE. LNP.
C
      I = 7
    6   IF (I .EQ. LNP) GO TO 8
        NP = NPTS(I)
        CALL SETRM (XK,YK,ZK,X(NP),Y(NP),Z(NP),AV,AVSQ,
     .              R, A(1,6))
        DO 7 J = 1,5
          JP1 = J + 1
          L = 6 - J
          CALL SROTG (A(J,J),A(J,6),C,S)
    7     CALL SROT (L,A(JP1,J),1,A(JP1,6),1,C,S)
        I = I + 1
        GO TO 6
C
C TEST THE SYSTEM FOR ILL-CONDITIONING
C
    8 DMIN = AMIN1( ABS(A(1,1)),ABS(A(2,2)),ABS(A(3,3)),
     .              ABS(A(4,4)),ABS(A(5,5)) )
      IF (DMIN .GE. DTOL) GO TO 15
      IF (LNP .GT. LMAX) GO TO 9
C
C ADD ANOTHER NODE TO THE SYSTEM AND INCREASE R --
C   I .EQ. LNP
C
      LNP = LNP + 1
      IF (LNP .LE. LMAX) CALL GETNP (X,Y,IADJ,IEND,LNP,
     .                               NPTS, RS,IERR)
      R = SQRT(1.1*RS)
      GO TO 6
C
C STABILIZE THE SYSTEM BY DAMPING SECOND PARTIALS --ADD
C   MULTIPLES OF THE FIRST THREE UNIT VECTORS TO THE FIRST
C   THREE EQUATIONS.
C
    9 DO 11 I = 1,3
        A(I,6) = SF
        IP1 = I + 1
        DO 10 J = IP1,6
   10     A(J,6) = 0.
        DO 11 J = I,5
          JP1 = J + 1
          L = 6 - J
          CALL SROTG (A(J,J),A(J,6),C,S)
   11     CALL SROT (L,A(JP1,J),1,A(JP1,6),1,C,S)
      GO TO 14
C
C 4 .LE. LNP .LE. 6 (2, 3, OR 4 EQUATIONS) -- FIT A PLANE TO
C   THE DATA USING THE LAST 3 COLUMNS OF A.
C
   12 NP = NPTS(2)
      CALL SETRM (XK,YK,ZK,X(NP),Y(NP),Z(NP),AV,AVSQ,
     .            R, A(1,4))
      NP = NPTS(3)
      CALL SETRM (XK,YK,ZK,X(NP),Y(NP),Z(NP),AV,AVSQ,
     .            R, A(1,5))
      CALL SROTG (A(4,4),A(4,5),C,S)
      CALL SROT (2,A(5,4),1,A(5,5),1,C,S)
      IF (LNP .EQ. 4) GO TO 14
C
      LM1 = LNP - 1
      DO 13 I = 4,LM1
        NP = NPTS(I)
        CALL SETRM (XK,YK,ZK,X(NP),Y(NP),Z(NP),AV,AVSQ,
     .              R, A(1,6))
        CALL SROTG (A(4,4),A(4,6),C,S)
        CALL SROT (2,A(5,4),1,A(5,6),1,C,S)
        CALL SROTG (A(5,5),A(5,6),C,S)
   13   CALL SROT (1,A(6,5),1,A(6,6),1,C,S)
C
C TEST THE LINEAR FIT FOR ILL-CONDITIONING
C
   14 DMIN = AMIN1( ABS(A(4,4)),ABS(A(5,5)) )
      IF (DMIN .LT. DTOL) GO TO 17
C
C SOLVE THE 2 BY 2 TRIANGULAR SYSTEM FOR THE DERIVATIVES
C
   15 DY = A(6,5)/A(5,5)
      DX = (A(6,4) - A(5,4)*DY)/A(4,4)/AV
      DY = DY/AV
      IER = LNP - 1
      RETURN
C
C N OR K IS OUT OF RANGE
C
   16 IER = -1
      RETURN
C
C NO UNIQUE SOLUTION DUE TO COLLINEAR NODES
C
   17 IER = -2
      RETURN
      END
      SUBROUTINE SETRM (XK,YK,ZK,XI,YI,ZI,S1,S2,R, ROW)
      REAL XK, YK, ZK, XI, YI, ZI, S1, S2, R, ROW(6)
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   THIS ROUTINE SETS UP THE I-TH ROW OF AN AUGMENTED RE-
C GRESSION MATRIX FOR A WEIGHTED LEAST-SQUARES FIT OF A
C QUADRATIC FUNCTION Q(X,Y) TO A SET OF DATA VALUES Z WHERE
C Q(XK,YK) = ZK.  THE FIRST 3 COLUMNS (QUADRATIC TERMS) ARE
C SCALED BY 1/S2 AND THE FOURTH AND FIFTH COLUMNS (LINEAR
C TERMS) ARE SCALED BY 1/S1.  THE WEIGHT IS (R-D)/(R*D) IF
C R .GT. D AND 0 IF R .LE. D, WHERE D IS THE DISTANCE
C BETWEEN NODES I AND K.
C
C INPUT PARAMETERS - XK,YK,ZK - COORDINATES AND DATA VALUE
C                               AT NODE K -- INTERPOLATED
C                               BY Q.
C
C                    XI,YI,ZI - COORDINATES AND DATA VALUE
C                               AT NODE I.
C
C                       S1,S2 - INVERSE SCALE FACTORS.
C
C                           R - RADIUS OF INFLUENCE ABOUT
C                               NODE K DEFINING THE WEIGHT.
C
C                         ROW - VECTOR OF LENGTH 6.
C
C INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETER - ROW - VECTOR CONTAINING A ROW OF THE
C                          AUGMENTED REGRESSION MATRIX.
C
C MODULES REFERENCED BY SETRM - NONE
C
C INTRINSIC FUNCTION CALLED BY SETRM - SQRT
C
C***********************************************************
C
      INTEGER I
      REAL    DX, DY, DXSQ, DYSQ, D, W, W1, W2
C
C LOCAL PARAMETERS -
C
C I =    DO-LOOP INDEX
C DX =   XI - XK
C DY =   YI - YK
C DXSQ = DX*DX
C DYSQ = DY*DY
C D =    DISTANCE BETWEEN NODES K AND I
C W =    WEIGHT ASSOCIATED WITH THE ROW
C W1 =   W/S1
C W2 =   W/S2
C
      DX = XI - XK
      DY = YI - YK
      DXSQ = DX*DX
      DYSQ = DY*DY
      D = SQRT(DXSQ + DYSQ)
      IF (D .LE. 0.  .OR.  D .GE. R) GO TO 1
      W = (R-D)/R/D
      W1 = W/S1
      W2 = W/S2
      ROW(1) = DXSQ*W2
      ROW(2) = DX*DY*W2
      ROW(3) = DYSQ*W2
      ROW(4) = DX*W1
      ROW(5) = DY*W1
      ROW(6) = (ZI - ZK)*W
      RETURN
C
C NODES K AND I COINCIDE OR NODE I IS OUTSIDE OF THE RADIUS
C   OF INFLUENCE.  SET ROW TO THE ZERO VECTOR.
C
    1 DO 2 I = 1,6
    2   ROW(I) = 0.
      RETURN
      END
      SUBROUTINE GETNP (X,Y,IADJ,IEND,L, NPTS, DS,IER)
      INTEGER IADJ(*), IEND(*), L, NPTS(L), IER
      REAL    X(*), Y(*), DS
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   GIVEN A THIESSEN TRIANGULATION OF N NODES AND AN ARRAY
C NPTS CONTAINING THE INDICES OF L-1 NODES ORDERED BY
C EUCLIDEAN DISTANCE FROM NPTS(1), THIS SUBROUTINE SETS
C NPTS(L) TO THE INDEX OF THE NEXT NODE IN THE SEQUENCE --
C THE NODE, OTHER THAN NPTS(1),...,NPTS(L-1), WHICH IS
C CLOSEST TO NPTS(1).  THUS, THE ORDERED SEQUENCE OF K
C CLOSEST NODES TO N1 (INCLUDING N1) MAY BE DETERMINED BY
C K-1 CALLS TO GETNP WITH NPTS(1) = N1 AND L = 2,3,...,K
C FOR K .GE. 2.
C   THE ALGORITHM USES THE FACT THAT, IN A THIESSEN TRIAN-
C GULATION, THE K-TH CLOSEST NODE TO A GIVEN NODE N1 IS A
C NEIGHBOR OF ONE OF THE K-1 CLOSEST NODES TO N1.
C
C INPUT PARAMETERS - X,Y - VECTORS OF LENGTH N CONTAINING
C                          THE CARTESIAN COORDINATES OF THE
C                          NODES.
C
C                   IADJ - SET OF ADJACENCY LISTS OF NODES
C                          IN THE TRIANGULATION.
C
C                   IEND - POINTERS TO THE ENDS OF ADJACENCY
C                          LISTS FOR EACH NODE IN THE TRI-
C                          ANGULATION.
C
C                      L - NUMBER OF NODES IN THE SEQUENCE
C                          ON OUTPUT.  2 .LE. L .LE. N.
C
C                   NPTS - ARRAY OF LENGTH .GE. L CONTAIN-
C                          ING THE INDICES OF THE L-1 CLOS-
C                          EST NODES TO NPTS(1) IN THE FIRST
C                          L-1 LOCATIONS.
C
C IADJ AND IEND MAY BE CREATED BY SUBROUTINE TRMESH.
C
C INPUT PARAMETERS OTHER THAN NPTS ARE NOT ALTERED BY THIS
C   ROUTINE.
C
C OUTPUT PARAMETERS - NPTS - UPDATED WITH THE INDEX OF THE
C                            L-TH CLOSEST NODE TO NPTS(1) IN
C                            POSITION L UNLESS IER = 1.
C
C                       DS - SQUARED EUCLIDEAN DISTANCE BE-
C                            TWEEN NPTS(1) AND NPTS(L)
C                            UNLESS IER = 1.
C
C                      IER - ERROR INDICATOR
C                            IER = 0 IF NO ERRORS WERE EN-
C                                    COUNTERED.
C                            IER = 1 IF L IS OUT OF RANGE.
C
C MODULES REFERENCED BY GETNP - NONE
C
C INTRINSIC FUNCTION CALLED BY GETNP - IABS
C
C***********************************************************
C
      INTEGER LM1, N1, I, NI, NP, INDF, INDL, INDX, NB
      REAL    X1, Y1, DNP, DNB
C
C LOCAL PARAMETERS -
C
C LM1 =     L - 1
C N1 =      NPTS(1)
C I =       NPTS INDEX AND DO-LOOP INDEX
C NI =      NPTS(I)
C NP =      CANDIDATE FOR NPTS(L)
C INDF =    IADJ INDEX OF THE FIRST NEIGHBOR OF NI
C INDL =    IADJ INDEX OF THE LAST NEIGHBOR OF NI
C INDX =    IADJ INDEX IN THE RANGE INDF,...,INDL
C NB =      NEIGHBOR OF NI AND CANDIDATE FOR NP
C X1,Y1 =   COORDINATES OF N1
C DNP,DNB = SQUARED DISTANCES FROM N1 TO NP AND NB,
C             RESPECTIVELY
C
      LM1 = L - 1
      IF (LM1 .LT. 1) GO TO 4
      IER = 0
      N1 = NPTS(1)
      X1 = X(N1)
      Y1 = Y(N1)
C
C MARK THE ELEMENTS OF NPTS
C
      DO 1 I = 1,LM1
        NI = NPTS(I)
        IEND(NI) = -IEND(NI)
    1   CONTINUE
C
C CANDIDATES FOR NP = NPTS(L) ARE THE UNMARKED NEIGHBORS
C   OF NODES IN NPTS.  NP=0 IS A FLAG TO SET NP TO THE
C   FIRST CANDIDATE ENCOUNTERED.
C
      NP = 0
      DNP = 0.
C
C LOOP ON NODES NI IN NPTS
C
      DO 2 I = 1,LM1
        NI = NPTS(I)
        INDF = 1
        IF (NI .GT. 1) INDF = IABS(IEND(NI-1)) + 1
        INDL = -IEND(NI)
C
C LOOP ON NEIGHBORS NB OF NI
C
        DO 2 INDX = INDF,INDL
          NB = IADJ(INDX)
          IF (NB .EQ. 0  .OR.  IEND(NB) .LT. 0) GO TO 2
C
C NB IS AN UNMARKED NEIGHBOR OF NI.  REPLACE NP IF NB IS
C   CLOSER TO N1 OR IS THE FIRST CANDIDATE ENCOUNTERED.
C
          DNB = (X(NB)-X1)**2 + (Y(NB)-Y1)**2
          IF (NP .NE. 0  .AND.  DNB .GE. DNP) GO TO 2
          NP = NB
          DNP = DNB
    2     CONTINUE
      NPTS(L) = NP
      DS = DNP
C
C UNMARK THE ELEMENTS OF NPTS
C
      DO 3 I = 1,LM1
        NI = NPTS(I)
        IEND(NI) = -IEND(NI)
    3   CONTINUE
      RETURN
C
C L IS OUT OF RANGE
C
    4 IER = 1
      RETURN
      END
      SUBROUTINE SFVAL (N, X, Y, Z, M, XI, YI, ZI, IADJ, IEND,
     *                  ZXZY, IERR)
C-----------------------------------------------------------------------
C                    EVALUATION OF THE SURFACE
C-----------------------------------------------------------------------
      REAL X(N), Y(N), Z(N), XI(M), YI(M), ZI(M), ZXZY(2,N)
      INTEGER IADJ(*), IEND(N)
C
      IF (N .LT. 3 .OR. M .LT. 1) GO TO 20
C
      IST = 1
      DO 10 J = 1,M
         CALL INTRC1 (N, XI(J), YI(J), X, Y, Z, IADJ, IEND,
     *                1, ZXZY, IST, ZI(J), IERR)
         IF (IERR .LT. 0) GO TO 30
   10 CONTINUE
      IERR = 0
      RETURN
C
C     ERROR RETURN
C
   20 IERR = 1
      RETURN
   30 IERR = 2
      RETURN
      END
      SUBROUTINE SFVAL2 (N, X, Y, Z, L, M, NROWS, XI, YI, ZI,
     *                   IADJ, IEND, ZXZY, IERR)
C-----------------------------------------------------------------------
C                EVALUATION OF THE SURFACE OVER A GRID
C-----------------------------------------------------------------------
      REAL X(N), Y(N), Z(N), ZXZY(2,N)
      REAL XI(L), YI(M), ZI(NROWS,M)
      INTEGER IADJ(*), IEND(N)
C
      IF (N .LT. 3 .OR. L .LT. 1 .OR. M .LT. 1 .OR. NROWS .LT. L)
     *   GO TO 30
C
      IST = 1
      DO 20 J = 1,M
         DO 10 I = 1,L
            CALL INTRC1 (N, XI(I), YI(J), X, Y, Z, IADJ, IEND,
     *                   1, ZXZY, IST, ZI(I,J), IERR)
            IF (IERR .LT. 0) GO TO 40
   10    CONTINUE
   20 CONTINUE
      IERR = 0
      RETURN
C
C     ERROR RETURN
C
   30 IERR = 1
      RETURN
   40 IERR = 2
      RETURN
      END
      SUBROUTINE INTRC1 (N,PX,PY,X,Y,Z,IADJ,IEND,IFLAG,
     .                   ZXZY, IST, PZ,IER)
      INTEGER N, IADJ(*), IEND(N), IFLAG, IST, IER
      REAL    PX, PY, X(N), Y(N), Z(N), ZXZY(2,N), PZ
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   GIVEN A TRIANGULATION OF A SET OF POINTS IN THE PLANE,
C THIS ROUTINE DETERMINES A PIECEWISE CUBIC FUNCTION F(X,Y)
C WHICH INTERPOLATES A SET OF DATA VALUES AND PARTIAL
C DERIVATIVES AT THE VERTICES.  F HAS CONTINUOUS FIRST
C DERIVATIVES OVER THE MESH AND EXTENDS BEYOND THE MESH
C BOUNDARY ALLOWING EXTRAPOLATION.  INTERPOLATION IS EXACT
C FOR QUADRATIC DATA.  THE VALUE OF F AT (PX,PY) IS
C RETURNED.  INTRC1 IS PART OF AN INTERPOLATION PACKAGE
C WHICH PROVIDES ROUTINES TO GENERATE, UPDATE AND PLOT THE
C MESH.
C
C INPUT PARAMETERS -     N - NUMBER OF NODES IN THE MESH.
C                            N .GE. 3.
C
C                    PX,PY - COORDINATES OF A POINT AT WHICH
C                            F IS TO BE EVALUATED.
C
C                      X,Y - VECTORS OF COORDINATES OF THE
C                            NODES IN THE MESH.
C
C                        Z - VECTOR OF DATA VALUES AT THE
C                            NODES.
C
C                     IADJ - SET OF ADJACENCY LISTS OF NODES
C                            IN THE MESH.
C
C                     IEND - POINTERS TO THE ENDS OF
C                            ADJACENCY LISTS IN IADJ FOR
C                            EACH NODE IN THE MESH.
C
C                    IFLAG - OPTION INDICATOR
C                            IFLAG = 0 IF INTRC1 IS TO
C                                      PROVIDE DERIVATIVE
C                                      ESTIMATES (FROM
C                                      GRADL1).
C                            IFLAG = 1 IF DERIVATIVES ARE
C                                      USER PROVIDED.
C
C                     ZXZY - 2 BY N ARRAY WHOSE COLUMNS
C                            CONTAIN ESTIMATED PARTIAL DER-
C                            IVATIVES AT THE NODES (X PAR-
C                            TIALS IN THE FIRST ROW) IF
C                            IFLAG = 1, NOT USED IF IFLAG
C                            = 0.
C
C                      IST - INDEX OF THE STARTING NODE IN
C                            THE SEARCH FOR A TRIANGLE CON-
C                            TAINING (PX,PY).  1 .LE. IST
C                            .LE. N.  THE OUTPUT VALUE OF
C                            IST FROM A PREVIOUS CALL MAY
C                            BE A GOOD CHOICE.
C
C IADJ AND IEND MAY BE CREATED BY TRMESH AND DERIVATIVE
C   ESTIMATES MAY BE COMPUTED BY GRADL1 OR GRADG.
C
C INPUT PARAMETERS OTHER THAN IST ARE NOT ALTERED BY THIS
C   ROUTINE.
C
C OUTPUT PARAMETERS - IST - INDEX OF ONE OF THE VERTICES OF
C                           THE TRIANGLE CONTAINING (PX,PY)
C                           UNLESS IER .LT. 0.
C
C                      PZ - VALUE OF F AT (PX,PY), OR 0 IF
C                           IER .LT. 0.
C
C                     IER - ERROR INDICATOR
C                           IER = 0 IF NO ERRORS WERE
C                                   ENCOUNTERED.
C                           IER = 1 IF NO ERRORS WERE EN-
C                                   COUNTERED AND EXTRAPOLA-
C                                   TION WAS PERFORMED.
C                           IER = -1 IF N, IFLAG, OR IST IS
C                                    OUT OF RANGE.
C                           IER = -2 IF THE NODES ARE COL-
C                                    LINEAR.
C
C MODULES REFERENCED BY INTRC1 - TRFIND, TVAL,
C             (AND OPTIONALLY)   GRADL1, GETNP, SETRM,
C                                SROTG, SROT
C
C***********************************************************
C
      INTEGER NN, I1, I2, I3, IERR, N1, N2, INDX
      REAL    XP, YP, ZX1, ZY1, ZX2, ZY2, ZX3, ZY3, X1, Y1,
     .        X2, Y2, X3, Y3, Z1, Z2, Z3, DUM, DP, U, V, XQ,
     .        YQ, R1, R2, A1, A2, B1, B2, C1, C2, F1, F2
C
C LOCAL PARAMETERS -
C
C NN =                      LOCAL COPY OF N
C I1,I2,I3 =                VERTICES DETERMINED BY TRFIND
C IERR =                    ERROR FLAG FOR CALLS TO GRADL1
C                             AND TVAL
C N1,N2 =                   ENDPOINTS OF THE CLOSEST BOUND-
C                             ARY EDGE TO P WHEN P IS OUT-
C                             SIDE OF THE MESH BOUNDARY
C INDX =                    IADJ INDEX OF N1 AS A NEIGHBOR
C                             OF N2
C XP,YP =                   LOCAL COPIES OF THE COORDINATES
C                             OF P=(PX,PY)
C ZX1,ZY1,ZX2,ZY2,ZX3,ZY3 = X AND Y DERIVATIVES AT THE
C                             VERTICES OF A TRIANGLE T WHICH
C                             CONTAINS P OR AT N1 AND N2
C X1,Y1,X2,Y2,X3,Y3 =       X,Y COORDINATES OF THE VERTICES
C                             OF T OR OF N1 AND N2
C Z1,Z2,Z3 =                DATA VALUES AT THE VERTICES OF T
C DUM =                     DUMMY VARIABLE FOR CALL TO TVAL
C DP =                      INNER PRODUCT OF N1-N2 AND P-N2
C U,V =                     X,Y COORDINATES OF THE VECTOR
C                             N2-N1
C XQ,YQ =                   X,Y COORDINATES OF THE CLOSEST
C                             BOUNDARY POINT TO P WHEN P IS
C                             OUTSIDE OF THE MESH BOUNDARY
C R1,R2 =                   BARYCENTRIC COORDINATES OF Q
C                             WITH RESPECT TO THE LINE SEG-
C                             MENT N2-N1 CONTAINING Q
C A1,A2,B1,B2,C1,C2 =       CARDINAL FUNCTIONS FOR EVALUAT-
C                             ING THE INTERPOLATORY SURFACE
C                             AT Q
C F1,F2 =                   CUBIC FACTORS USED TO COMPUTE
C                             THE CARDINAL FUNCTIONS
C
      NN = N
      PZ = 0.
      IF (NN .LT. 3  .OR.  IFLAG .LT. 0  .OR.  IFLAG .GT. 1
     .   .OR.  IST .LT. 1  .OR.  IST .GT. NN) GO TO 11
      XP = PX
      YP = PY
C
C FIND A TRIANGLE CONTAINING P IF P IS WITHIN THE MESH
C   BOUNDARY
C
      CALL TRFIND(IST,XP,YP,X,Y,IADJ,IEND, I1,I2,I3)
      IF (I1 .EQ. 0) GO TO 12
      IST = I1
      IF (I3 .EQ. 0) GO TO 3
      IF (IFLAG .NE. 1) GO TO 1
C
C DERIVATIVES ARE USER PROVIDED
C
      ZX1 = ZXZY(1,I1)
      ZX2 = ZXZY(1,I2)
      ZX3 = ZXZY(1,I3)
      ZY1 = ZXZY(2,I1)
      ZY2 = ZXZY(2,I2)
      ZY3 = ZXZY(2,I3)
      GO TO 2
C
C COMPUTE DERIVATIVE ESTIMATES AT THE VERTICES
C
    1 CALL GRADL1(NN,I1,X,Y,Z,IADJ,IEND, ZX1,ZY1,IERR)
      CALL GRADL1(NN,I2,X,Y,Z,IADJ,IEND, ZX2,ZY2,IERR)
      CALL GRADL1(NN,I3,X,Y,Z,IADJ,IEND, ZX3,ZY3,IERR)
C
C SET LOCAL PARAMETERS FOR CALL TO TVAL
C
    2 X1 = X(I1)
      Y1 = Y(I1)
      X2 = X(I2)
      Y2 = Y(I2)
      X3 = X(I3)
      Y3 = Y(I3)
      Z1 = Z(I1)
      Z2 = Z(I2)
      Z3 = Z(I3)
      CALL TVAL(XP,YP,X1,X2,X3,Y1,Y2,Y3,Z1,Z2,Z3,ZX1,ZX2,
     .          ZX3,ZY1,ZY2,ZY3,0, PZ,DUM,DUM,IERR)
      IF (IERR .NE. 0) GO TO 12
      IER = 0
      RETURN
C
C P IS OUTSIDE OF THE MESH BOUNDARY.  EXTRAPOLATE TO P BY
C   PASSING A LINEAR FUNCTION OF ONE VARIABLE THROUGH THE
C   VALUE AND DIRECTIONAL DERIVATIVE (IN THE DIRECTION
C   P-Q) OF THE INTERPOLATORY SURFACE (TVAL) AT Q WHERE
C   Q IS THE CLOSEST BOUNDARY POINT TO P.
C
C DETERMINE Q BY TRAVERSING THE BOUNDARY STARTING FROM
C   THE RIGHTMOST VISIBLE NODE I1.
C
    3 N2 = I1
C
C SET N1 TO THE LAST NONZERO NEIGHBOR OF N2 AND COMPUTE DP
C
    4 INDX = IEND(N2) - 1
      N1 = IADJ(INDX)
      X1 = X(N1)
      Y1 = Y(N1)
      X2 = X(N2)
      Y2 = Y(N2)
      DP = (X1-X2)*(XP-X2) + (Y1-Y2)*(YP-Y2)
      IF (DP .LE. 0.) GO TO 5
      IF ((XP-X1)*(X2-X1) + (YP-Y1)*(Y2-Y1) .GT. 0.) GO TO 8
      N2 = N1
      GO TO 4
C
C N2 IS THE CLOSEST BOUNDARY POINT TO P.  COMPUTE PARTIAL
C   DERIVATIVES AT N2.
C
    5 IF (IFLAG .NE. 1) GO TO 6
      ZX2 = ZXZY(1,N2)
      ZY2 = ZXZY(2,N2)
      GO TO 7
    6 CALL GRADL1(NN,N2,X,Y,Z,IADJ,IEND, ZX2,ZY2,IERR)
C
C COMPUTE EXTRAPOLATED VALUE AT P
C
    7 PZ = Z(N2) + ZX2*(XP-X2) + ZY2*(YP-Y2)
      IER = 1
      RETURN
C
C THE CLOSEST BOUNDARY POINT Q LIES ON N2-N1.  COMPUTE
C   PARTIALS AT N1 AND N2.
C
    8 IF (IFLAG .NE. 1) GO TO 9
      ZX1 = ZXZY(1,N1)
      ZY1 = ZXZY(2,N1)
      ZX2 = ZXZY(1,N2)
      ZY2 = ZXZY(2,N2)
      GO TO 10
    9 CALL GRADL1(NN,N1,X,Y,Z,IADJ,IEND, ZX1,ZY1,IERR)
      CALL GRADL1(NN,N2,X,Y,Z,IADJ,IEND, ZX2,ZY2,IERR)
C
C COMPUTE Q, ITS BARYCENTRIC COORDINATES, AND THE CARDINAL
C   FUNCTIONS FOR EXTRAPOLATION
C
   10 U = X2-X1
      V = Y2-Y1
      R1 = DP/(U**2 + V**2)
      R2 = 1. - R1
      XQ = R1*X1 + R2*X2
      YQ = R1*Y1 + R2*Y2
      F1 = R1*R1*R2
      F2 = R1*R2*R2
      A1 = R1 + (F1-F2)
      A2 = R2 - (F1-F2)
      B1 = U*F1
      B2 = -U*F2
      C1 = V*F1
      C2 = -V*F2
C
C COMPUTE THE VALUE OF THE INTERPOLATORY SURFACE (TVAL)
C   AT Q
C
      PZ = A1*Z(N1) + A2*Z(N2) + B1*ZX1 + B2*ZX2 +
     .     C1*ZY1 + C2*ZY2
C
C COMPUTE THE EXTRAPOLATED VALUE AT P
C
      PZ = PZ + (R1*ZX1 + R2*ZX2)*(XP-XQ) +
     .          (R1*ZY1 + R2*ZY2)*(YP-YQ)
      IER = 1
      RETURN
C
C N, IFLAG, OR IST OUT OF RANGE
C
   11 IER = -1
      RETURN
C
C NODES ARE COLLINEAR
C
   12 IER = -2
      RETURN
      END
      SUBROUTINE TVAL (X,Y,X1,X2,X3,Y1,Y2,Y3,Z1,Z2,Z3,ZX1,
     .                 ZX2,ZX3,ZY1,ZY2,ZY3,IFLAG, W,WX,WY,
     .                 IER)
      INTEGER IFLAG, IER
      REAL    X, Y, X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3,
     .        ZX1, ZX2, ZX3, ZY1, ZY2, ZY3, W, WX, WY
C
C***********************************************************
C
C                                               ROBERT RENKA
C                                       OAK RIDGE NATL. LAB.
C                                             (615) 576-5139
C
C   GIVEN FUNCTION VALUES AND FIRST PARTIAL DERIVATIVES AT
C THE THREE VERTICES OF A TRIANGLE, THIS ROUTINE DETERMINES
C A FUNCTION W WHICH AGREES WITH THE GIVEN DATA, RETURNING
C THE VALUE AND (OPTIONALLY) FIRST PARTIAL DERIVATIVES OF W
C AT A POINT (X,Y) IN THE TRIANGLE.  THE INTERPOLATION
C METHOD IS EXACT FOR QUADRATIC POLYNOMIAL DATA.  THE
C TRIANGLE IS PARTITIONED INTO THREE SUBTRIANGLES WITH
C EQUAL AREAS.  W IS CUBIC IN EACH SUBTRIANGLE AND ALONG
C THE EDGES, BUT HAS ONLY ONE CONTINUOUS DERIVATIVE ACROSS
C EDGES.  THE NORMAL DERIVATIVE OF W VARIES LINEARLY ALONG
C EACH OUTER EDGE.  THE VALUES AND PARTIAL DERIVATIVES OF W
C ALONG A TRIANGLE EDGE DEPEND ONLY ON THE DATA VALUES AT
C THE ENDPOINTS OF THE EDGE.  THUS THE METHOD YIELDS C-1
C CONTINUITY WHEN USED TO INTERPOLATE OVER A TRIANGULAR
C GRID.  THIS ALGORITHM IS DUE TO C. L. LAWSON.
C
C INPUT PARAMETERS -   X,Y - COORDINATES OF A POINT AT WHICH
C                            W IS TO BE EVALUATED.
C
C        X1,X2,X3,Y1,Y2,Y3 - COORDINATES OF THE VERTICES OF
C                            A TRIANGLE CONTAINING (X,Y).
C
C                 Z1,Z2,Z3 - FUNCTION VALUES AT THE VERTICES
C                            TO BE INTERPOLATED.
C
C              ZX1,ZX2,ZX3 - X-DERIVATIVE VALUES AT THE
C                            VERTICES.
C
C              ZY1,ZY2,ZY3 - Y-DERIVATIVE VALUES AT THE
C                            VERTICES.
C
C                    IFLAG - OPTION INDICATOR
C                            IFLAG = 0 IF ONLY W IS TO BE
C                                      COMPUTED.
C                            IFLAG = 1 IF W, WX, AND WY ARE
C                                      TO BE RETURNED.
C
C INPUT PARAMETERS ARE NOT ALTERED BY THIS ROUTINE.
C
C OUTPUT PARAMETERS -   W - ESTIMATED VALUE OF THE INTERP-
C                           OLATORY FUNCTION AT (X,Y) IF
C                           IER = 0.  OTHERWISE W = 0.
C
C                   WX,WY - PARTIAL DERIVATIVES OF W AT
C                           (X,Y) IF IER = 0 AND IFLAG = 1,
C                           UNCHANGED IF IFLAG .NE. 1, ZERO
C                           IF IER .NE. 0 AND IFLAG = 1.
C
C                     IER - ERROR INDICATOR
C                           IER = 0 IF NO ERRORS WERE
C                                   ENCOUNTERED.
C                           IER = 1 IF THE VERTICES OF THE
C                                   TRIANGLE ARE COLLINEAR.
C
C MODULES REFERENCED BY TVAL - NONE
C
C INTRINSIC FUNCTION CALLED BY TVAL - AMIN1
C
C***********************************************************
C
      INTEGER I, IP1, IP2, IP3
      REAL    U(3), V(3), SL(3), AREA, XP, YP, R(3), RX(3),
     .        RY(3), PHI(3), PHIX(3), PHIY(3), RMIN, C1, C2,
     .        RO(3), ROX(3), ROY(3), F(3), G(3), GX(3),
     .        GY(3), P(3), PX(3), PY(3), Q(3), QX(3), QY(3),
     .        A(3), AX(3), AY(3), B(3), BX(3), BY(3), C(3),
     .        CX(3), CY(3)
C
C LOCAL PARAMETERS -
C
C I =               DO-LOOP INDEX
C IP1,IP2,IP3 =     PERMUTED INDICES FOR COMPUTING RO, ROX,
C                     AND ROY
C U(K) =            X-COMPONENT OF THE VECTOR REPRESENTING
C                     THE SIDE OPPOSITE VERTEX K
C V(K) =            Y-COMPONENT OF THE VECTOR REPRESENTING
C                     THE SIDE OPPOSITE VERTEX K
C SL(K) =           SQUARE OF THE LENGTH OF THE SIDE
C                     OPPOSITE VERTEX K
C AREA =            TWICE THE AREA OF THE TRIANGLE
C XP,YP =           X-X1, Y-Y1
C R(K) =            K-TH BARYCENTRIC COORDINATE
C RX(K),RY(K) =     X,Y PARTIAL DERIVATIVES OF R(K)
C PHI(K)            R(K-1)*R(K+1) -- QUADRATIC
C PHIX(K),PHIY(K) = X,Y PARTIALS OF PHI(K)
C RMIN =            MIN(R1,R2,R3)
C C1,C2 =           FACTORS FOR COMPUTING RO
C RO(K) =           FACTORS FOR COMPUTING G -- CUBIC
C                     CORRECTION TERMS
C ROX(K),ROY(K) =   X,Y PARTIALS OF RO(K)
C F(K) =            FACTORS FOR COMPUTING G, GX, AND GY --
C                     CONSTANT
C G(K) =            FACTORS FOR COMPUTING THE CARDINAL
C                     FUNCTIONS -- CUBIC
C GX(K),GY(K) =     X,Y PARTIALS OF G(K)
C P(K) =            G(K) + PHI(K)
C PX(K),PY(K) =     X,Y PARTIALS OF P(K)
C Q(K) =            G(K) - PHI(K)
C QX(K),QY(K) =     X,Y PARTIALS OF Q(K)
C A(K) =            CARDINAL FUNCTION WHOSE COEFFICIENT IS
C                     Z(K)
C AX(K),AY(K) =     X,Y PARTIALS OF A(K) -- CARDINAL
C                     FUNCTIONS FOR WX AND WY
C B(K) =            TWICE THE CARDINAL FUNCTION WHOSE
C                     COEFFICIENT IS ZX(K)
C BX(K),BY(K) =     X,Y PARTIALS OF B(K)
C C(K) =            TWICE THE CARDINAL FUNCTION WHOSE
C                     COEFFICIENT IS ZY(K)
C CX(K),CY(K) =     X,Y PARTIALS OF C(K)
C
      U(1) = X3 - X2
      U(2) = X1 - X3
      U(3) = X2 - X1
C
      V(1) = Y3 - Y2
      V(2) = Y1 - Y3
      V(3) = Y2 - Y1
C
      DO 1 I = 1,3
        SL(I) = U(I)*U(I) + V(I)*V(I)
    1   CONTINUE
C
C AREA = 3-1 X 3-2
C
      AREA = U(1)*V(2) - U(2)*V(1)
      IF (AREA .EQ. 0.) GO TO 9
C
C R(1) = (2-3 X 2-(X,Y))/AREA, R(2) = (1-(X,Y) X 1-3)/AREA,
C   R(3) = (1-2 X 1-(X,Y))/AREA
C
      R(1) = (U(1)*(Y-Y2) - V(1)*(X-X2))/AREA
      XP = X - X1
      YP = Y - Y1
      R(2) = (U(2)*YP - V(2)*XP)/AREA
      R(3) = (U(3)*YP - V(3)*XP)/AREA
      IER = 0
C
      PHI(1) = R(2)*R(3)
      PHI(2) = R(3)*R(1)
      PHI(3) = R(1)*R(2)
C
      RMIN = AMIN1(R(1),R(2),R(3))
      IF (RMIN .NE. R(1)) GO TO 3
      IP1 = 1
      IP2 = 2
      IP3 = 3
      GO TO 5
    3 IF (RMIN .NE. R(2)) GO TO 4
      IP1 = 2
      IP2 = 3
      IP3 = 1
      GO TO 5
    4 IP1 = 3
      IP2 = 1
      IP3 = 2
C
    5 C1 = RMIN*RMIN/2.
      C2 = RMIN/3.
      RO(IP1) = (PHI(IP1) + 5.*C1/3.)*R(IP1) - C1
      RO(IP2) = C1*(R(IP3) - C2)
      RO(IP3) = C1*(R(IP2) - C2)
C
      F(1) = 3.*(SL(2)-SL(3))/SL(1)
      F(2) = 3.*(SL(3)-SL(1))/SL(2)
      F(3) = 3.*(SL(1)-SL(2))/SL(3)
C
      G(1) = (R(2)-R(3))*PHI(1) + F(1)*RO(1) - RO(2) + RO(3)
      G(2) = (R(3)-R(1))*PHI(2) + F(2)*RO(2) - RO(3) + RO(1)
      G(3) = (R(1)-R(2))*PHI(3) + F(3)*RO(3) - RO(1) + RO(2)
C
      DO 6 I = 1,3
        P(I) = G(I) + PHI(I)
        Q(I) = G(I) - PHI(I)
    6   CONTINUE
C
      A(1) = R(1) + G(3) - G(2)
      A(2) = R(2) + G(1) - G(3)
      A(3) = R(3) + G(2) - G(1)
C
      B(1) = U(3)*P(3) + U(2)*Q(2)
      B(2) = U(1)*P(1) + U(3)*Q(3)
      B(3) = U(2)*P(2) + U(1)*Q(1)
C
      C(1) = V(3)*P(3) + V(2)*Q(2)
      C(2) = V(1)*P(1) + V(3)*Q(3)
      C(3) = V(2)*P(2) + V(1)*Q(1)
C
C W IS A LINEAR COMBINATION OF THE CARDINAL FUNCTIONS
C
      W = A(1)*Z1 + A(2)*Z2 + A(3)*Z3 + (B(1)*ZX1 + B(2)*ZX2
     .    + B(3)*ZX3 + C(1)*ZY1 + C(2)*ZY2 + C(3)*ZY3)/2.
      IF (IFLAG .NE. 1) RETURN
C
C COMPUTE WX AND WY
C
      DO 7 I = 1,3
        RX(I) = -V(I)/AREA
        RY(I) = U(I)/AREA
    7   CONTINUE
      PHIX(1) = R(2)*RX(3) + RX(2)*R(3)
      PHIY(1) = R(2)*RY(3) + RY(2)*R(3)
      PHIX(2) = R(3)*RX(1) + RX(3)*R(1)
      PHIY(2) = R(3)*RY(1) + RY(3)*R(1)
      PHIX(3) = R(1)*RX(2) + RX(1)*R(2)
      PHIY(3) = R(1)*RY(2) + RY(1)*R(2)
C
      ROX(IP1) = RX(IP1)*(PHI(IP1) + 5.*C1) +
     .           R(IP1)*(PHIX(IP1) - RX(IP1))
      ROY(IP1) = RY(IP1)*(PHI(IP1) + 5.*C1) +
     .           R(IP1)*(PHIY(IP1) - RY(IP1))
      ROX(IP2) = RX(IP1)*(PHI(IP2) - C1) + C1*RX(IP3)
      ROY(IP2) = RY(IP1)*(PHI(IP2) - C1) + C1*RY(IP3)
      ROX(IP3) = RX(IP1)*(PHI(IP3) - C1) + C1*RX(IP2)
      ROY(IP3) = RY(IP1)*(PHI(IP3) - C1) + C1*RY(IP2)
C
      GX(1) = (RX(2) - RX(3))*PHI(1) + (R(2) - R(3))*PHIX(1)
     .        + F(1)*ROX(1) - ROX(2) + ROX(3)
      GY(1) = (RY(2) - RY(3))*PHI(1) + (R(2) - R(3))*PHIY(1)
     .        + F(1)*ROY(1) - ROY(2) + ROY(3)
      GX(2) = (RX(3) - RX(1))*PHI(2) + (R(3) - R(1))*PHIX(2)
     .        + F(2)*ROX(2) - ROX(3) + ROX(1)
      GY(2) = (RY(3) - RY(1))*PHI(2) + (R(3) - R(1))*PHIY(2)
     .        + F(2)*ROY(2) - ROY(3) + ROY(1)
      GX(3) = (RX(1) - RX(2))*PHI(3) + (R(1) - R(2))*PHIX(3)
     .        + F(3)*ROX(3) - ROX(1) + ROX(2)
      GY(3) = (RY(1) - RY(2))*PHI(3) + (R(1) - R(2))*PHIY(3)
     .        + F(3)*ROY(3) - ROY(1) + ROY(2)
C
      DO 8 I = 1,3
        PX(I) = GX(I) + PHIX(I)
        PY(I) = GY(I) + PHIY(I)
        QX(I) = GX(I) - PHIX(I)
        QY(I) = GY(I) - PHIY(I)
    8   CONTINUE
C
      AX(1) = RX(1) + GX(3) - GX(2)
      AY(1) = RY(1) + GY(3) - GY(2)
      AX(2) = RX(2) + GX(1) - GX(3)
      AY(2) = RY(2) + GY(1) - GY(3)
      AX(3) = RX(3) + GX(2) - GX(1)
      AY(3) = RY(3) + GY(2) - GY(1)
C
      BX(1) = U(3)*PX(3) + U(2)*QX(2)
      BY(1) = U(3)*PY(3) + U(2)*QY(2)
      BX(2) = U(1)*PX(1) + U(3)*QX(3)
      BY(2) = U(1)*PY(1) + U(3)*QY(3)
      BX(3) = U(2)*PX(2) + U(1)*QX(1)
      BY(3) = U(2)*PY(2) + U(1)*QY(1)
C
      CX(1) = V(3)*PX(3) + V(2)*QX(2)
      CY(1) = V(3)*PY(3) + V(2)*QY(2)
      CX(2) = V(1)*PX(1) + V(3)*QX(3)
      CY(2) = V(1)*PY(1) + V(3)*QY(3)
      CX(3) = V(2)*PX(2) + V(1)*QX(1)
      CY(3) = V(2)*PY(2) + V(1)*QY(1)
C
C WX AND WY ARE LINEAR COMBINATIONS OF THE CARDINAL
C   FUNCTIONS
C
      WX = AX(1)*Z1 + AX(2)*Z2 + AX(3)*Z3 + (BX(1)*ZX1 +
     .     BX(2)*ZX2 + BX(3)*ZX3 + CX(1)*ZY1 + CX(2)*ZY2 +
     .     CX(3)*ZY3)/2.
      WY = AY(1)*Z1 + AY(2)*Z2 + AY(3)*Z3 + (BY(1)*ZX1 +
     .     BY(2)*ZX2 + BY(3)*ZX3 + CY(1)*ZY1 + CY(2)*ZY2 +
     .     CY(3)*ZY3)/2.
      RETURN
C
C VERTICES ARE COLLINEAR
C
    9 IER = 1
      W = 0.
      IF (IFLAG .NE. 1) RETURN
      WX = 0.
      WY = 0.
      RETURN
      END
      SUBROUTINE MFIT(DIMEN,FITDEG,NFPOLS,NFPTS,
     +                FITCDS,NCROWS,FITVLS,WTS,
     +                RESIDS,ERROR,FITIWK,FITDWK,
     +                FIWKLN,FDWKLN,IREQD,DREQD)
C
      INTEGER NFPOLS,FITDEG,NFPTS,DIMEN,FIWKLN,FDWKLN
      INTEGER ERROR,IREQD,DREQD,INDSTT,P,DIMP1,NCROWS
      INTEGER NEWSTT,MAXSTT,ALFSTT,PSISTT,CSTT,SSQSTT,PSIWID,ALFL
      INTEGER FITIWK(FIWKLN)
      REAL    FITDWK(FDWKLN),FITCDS(NCROWS,DIMEN)
      REAL    FITVLS(NFPTS),RESIDS(NFPTS)
      REAL    WTS(NFPTS)
      REAL    SCALE
C
C     ***************
C     PURPOSE
C     -------
C
C     THIS SUBROUTINE CONSTRUCTS A LEAST-SQUARES  MULTINOMIAL  FIT  TO
C     GIVEN DATA USING A BASIS OF ORTHOGONAL MULTINOMIALS.
C
C     THE DATA FOR THE FIT IS GIVEN IN THE ARRAYS FITCDS, FITVLS, AND
C     WTS. FITCDS IS A MATRIX, EACH ROW OF WHICH CONTAINS AN OBSERVA-
C     TION POINT. FITVLS IS A SINGLY-INDEXED ARRAY, EACH ELEMENT OF
C     WHICH CONTAINS A FUNCTION VALUE CORRESPONDING TO AN OBSERVATION
C     POINT. WTS IS A SINGLY-INDEXED ARRAY, EACH ELEMENT OF WHICH IS
C     A NONNEGATIVE WEIGHT FOR THE CORRESPONDING OBSERVATION.
C
C     THE FIT WHICH IS PRODUCED IS A MULTINOMIAL EXPRESSED IN THE FORM
C
C      C  PSI  (X ,...,X     ) +...+ C       PSI       (X ,...,X     )
C       1    1   1      DIMEN         NFPOLS    NFPOLS   1      DIMEN
C
C     WHERE THE VALUE OF  NFPOLS  WILL BE AS GIVEN (IF  FITDEG .LT. 0)
C     OR  AS  COMPUTED  BY  MFIT  TO GIVE A FULL-DEGREE FIT (IN CASE
C     FITDEG  IS SPECIFIED .GE. 0).  THE ELEMENTS
C
C         PSI  (X ,...,X     )
C            K   1      DIMEN
C
C     FORM A BASIS FOR THE MULTINOMIALS WHICH IS ORTHOGONAL WITH
C     RESPECT TO THE WEIGHTS AND OBSERVATION POINTS.
C
C     THE EXTENT OF THE FIT CAN BE SPECIFIED IN ONE OF TWO WAYS.
C         IF THE PARAMETER FITDEG IS SET .GE. 0, THEN A COMPLETE BASIS
C         FOR THE MULTINOMIALS OF DEGREE =  FITDEG  WILL BE USED.  (AN
C         ERROR WILL BE  FLAGGED  IF  THIS  WILL  REQUIRE  MORE  BASIS
C         MULTINOMIALS  THAN  THE  NUMBER  OF  DATA  POINTS WHICH WERE
C         GIVEN.)
C         IF THE PARAMETER  FITDEG  IS .LT.  0, THEN  NFPOLS  WILL  BE
C         TAKEN AS THE COUNT OF THE NUMBER OF BASIS MULTINOMIALS TO BE
C         USED FOR A PARTIAL-DEGREE FIT.  (AN ERROR WILL BE FLAGGED IF
C         NFPOLS  .LT. 0.)
C
C     VARIABLES
C     ---------
C
C      DIMEN  -- (INTEGER) -- (PASSED)
C         THE NUMBER OF VARIABLES.
C      FITDEG  - (INTEGER) -- (PASSED/RETURNED)
C         IGNORED IF .LT. 0.
C         IF FITDEG .GE. 0 THEN  FITDEG  IS  CHECKED  AGAINST  NFPTS .
C         THE VALUE OF  FITDEG  WILL BE REDUCED IF THERE IS A BASIS OF
C         MULTINOMIALS, ALL OF  DEGREE  .LE. FITDEG ,  OF  CARDINALITY
C         NFPTS .  SEE  ERROR  BELOW.
C      NFPOLS  - (INTEGER) -- (PASSED/RETURNED)
C         IGNORED IF  FITDEG  .GE. 0.
C         IF  FITDEG .LT. 0 THEN THE VALUE OF NFPOLS WILL BE TAKEN  AS
C         THE SIZE OF THE BASIS OF MULTINOMIALS TO BE USED IN THE FIT.
C         NFPOLS  MUST SATISFY  NFPOLS  .LT. NFPTS  AND NFPOLS .GE. 1
C         SEE  ERROR  BELOW.
C      NFPTS  --- (INTEGER) -- (PASSED)
C         THE NUMBER OF DATA POINTS TO BE USED IN THE FIT.
C         NFPTS  MUST BE .GE. 1.  SEE  ERROR  BELOW.
C      FITCDS  -- (REAL 2-SUBSCRIPT ARRAY) -- (PASSED)
C         FITCDS (P,K) IS THE VALUE OF THE K-TH VARIABLE AT THE  P-TH
C         DATA POINT.
C      NCROWS  -- (INTEGER) -- (PASSED)
C         THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
C         PROGRAM.
C      FITVLS  -- (REAL 1-SUBSCRIPT ARRAY) -- (PASSED)
C         FITVLS (P) IS THE OBSERVED FUNCTION VALUE OF THE P-TH  DATA
C         POINT.
C      WTS  ----- (REAL 1-SUBSCRIPT ARRAY) -- (PASSED)
C         WTS (P) IS THE WEIGHT ATTACHED TO THE P-TH DATA POINT.
C      RESIDS  -- (REAL 1-SUBSCRIPT ARRAY) -- (RETURNED)
C         RESIDS (P) IS THE DIFFERENCE BETWEEN THE FITTED FUNCTION AT
C         POINT P AND  FITVLS (P).
C      ERROR  -- (INTEGER) -- (RETURNED)
C       0 THE DESIRED LEAST SQUARE MULTINOMIAL FIT WAS OBTAINED.
C      -1 ONLY THE FIRST NFPOLS BASIS POLYNOMIALS WERE OBTAINED.
C         FITDEG IS THE DEGREE OF THE FIT.
C       1 IF  FITDEG  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
C         OF SMALLER DEGREE OR IF FITDEG .LT. 0 AND NFPOLS .GT. NFPTS.
C       2 IF  FITDEG  .LT. 0 AND  NFPOLS  .LE. 0.
C       3 IF  NFPTS  .LT. 1 AND/OR  DIMEN  .LT. 1.
C       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
C         THE VALUE RETURNED IN  IREQD , AND SET  DWKLEN  TO THE VALUE
C         RETURNED IN  DREQD  TO RESOLVE THIS PROBLEM.)
C      FITIWK  -- (INTEGER, 1-SUBSCRIPT ARRAY) -- (RETURNED)
C         AN INTEGER WORK ARRAY OF LENGTH  FIWKLN .  UPON RETURN  FROM
C         MFIT, FITIWK CONTAINS DIMENSION AND ARRAY LENGTH INFORMATION.
C      FITDWK  -- (REAL 1-SUBSCRIPT ARRAY) -- (RETURNED)
C         A REAL ARRAY OF LENGTH  FDWKLN  CONTAINING THE COEFFICIENTS
C         NEEDED FOR COMPUTING THE MULTINOMIAL FIT AT A POINT.
C      FIWKLN  -- (INTEGER) -- (PASSED)
C         THE LENGTH OF THE ARRAY  FITIWK .
C      FDWKLN  -- (INTEGER) -- (PASSED)
C         THE LENGTH OF THE ARRAY  FITDWK .
C      IREQD  -- (INTEGER) -- (RETURNED)
C         THE LENGTH WHICH THE ARRAY  FITIWK  REALLY NEEDS TO BE.
C      DREQD  -- (INTEGER) -- (RETURNED)
C         THE LENGTH WHICH THE ARRAY  FITDWK  REALLY NEEDS TO BE.
C
C
C     NOTE. THE 20 LOOP DEPENDS ON THE SCALING SCHEME BEING USED. THE
C     RESIDUAL SCALING MUST BE CONSISTENT WITH THAT DEFINED BY SCALPM
C     AND SCALDN.
C
C     MFIT  CALLS  ALLOT  AND  GNRTP.
C     ****************
C
      DIMP1 = DIMEN + 1
C
C     ***************
C
      CALL ALLOT(FITDEG,NFPOLS,NFPTS,DIMEN,FITIWK,FIWKLN,IREQD,DREQD,
     +           ERROR)
      IF ( ERROR .GE. 2 ) RETURN
C
      IF ( FDWKLN .GE. DREQD ) GO TO 10
         ERROR = 4
         RETURN
   10 CONTINUE
C
      PSIWID = FITIWK(3)
      ALFL = FITIWK(4)
      INDSTT = 1
      NEWSTT = 4 * NFPOLS + INDSTT
      MAXSTT = 1
      ALFSTT = MAXSTT + DIMP1
      CSTT = ALFSTT + ALFL
      SSQSTT = CSTT + NFPOLS
      PSISTT = SSQSTT + NFPOLS
C
C     ***************
C
         CALL GNRTP(FITDEG,FITDWK(ALFSTT),
     +              FITDWK(PSISTT),FITIWK(INDSTT),
     +              FITIWK(NEWSTT),FITDWK(SSQSTT),FITCDS,
     +              NCROWS,NFPOLS,DIMEN,NFPTS,FITVLS,RESIDS,
     +              FITDWK(CSTT),PSIWID,WTS,ALFL,DIMP1,
     +              FITDWK(MAXSTT),ERROR)
C
C     ***************
C     STORE THE NUMBER OF BASIS POLYNOMIALS ACTUALLY COMPUTED
C     BY THE MODIFIED ROUTINE INCDG CALLED BY GNRTP.
C     ***************
C
      FITIWK(1) = NFPOLS
C
C     ***************
C     UNSCALE THE RESIDUALS FOR THE BENEFIT OF THE USER.
C     ***************
C
      SCALE = FITDWK(DIMEN + 1)
      DO 20 P = 1,NFPTS
        RESIDS(P) = RESIDS(P) * SCALE
   20 CONTINUE
      RETURN
      END
      SUBROUTINE ALLOT(DEGREE,NPOLYS,NPTS,DIMEN,IWORK,IWKLEN,
     +                 IREQD,DREQD,ERROR)
C
      INTEGER IREQD,DREQD,ALFL,ERROR,NPOLYS,DEGREE,DIMEN,NPTS
      INTEGER NEWSTT,PSIWID,KMXBAS,STARTJ,KJP1D2,INDEX,IWKLEN
      INTEGER NPLYT4
      INTEGER IWORK(IWKLEN)
C
C     ***************
C     PURPOSE
C     -------
C
C      ALLOT  CHECKS FOR SUFFICIENCY THE DECLARED  DIMENSIONS  OF  THE
C     WORK  ARRAYS  USED BY THE SUBROUTINE  MFIT .  VARIOUS SIZES OF
C     SUB-ARRAYS ARE COMPUTED AND REPORTED.
C
C     THIS ROUTINE IS CALLED BY  MFIT .  IT IS NOT  CALLED  DIRECTLY
C     BY THE USER.
C
C     THIS ROUTINE CALLS   BASIZ   AND   MTABLE   FOR  THE  SUBSTANTIVE
C     COMPUTATIONS.
C
C     VARIABLES
C     ---------
C
C      DEGREE  - (PASSED/RETURNED)
C         IGNORED IF .LT. 0.
C         IF  DEGREE  .GE. 0 THEN  DEGREE IS CHECKED  AGAINST   NPTS .
C         THE VALUE OF  DEGREE  WILL BE REDUCED IF THERE IS A BASIS OF
C         MULTINOMIALS, ALL OF  DEGREE .LE.  DEGREE ,  OF  CARDINALITY
C          NPTS
C      NPOLYS  - (PASSED/RETURNED)
C         IGNORED IF  DEGREE  .GE. 0.
C         IF DEGREE .LT. 0 THEN THE VALUE OF NPOLYS WILL BE TAKEN  AS
C         THE SIZE OF THE BASIS OF MULTINOMIALS TO BE USED IN THE FIT.
C         NPOLYS  MUST SATISFY NPOLYS .LT.  NPTS  AND  NPOLYS  .GE. 1
C      NPTS  --- (PASSED)
C         THE NUMBER OF DATA POINTS TO BE USED IN THE FIT.
C          NPTS  MUST BE .GE. 1.
C      DIMEN  -- (PASSED)
C         THE NUMBER OF VARIABLES.
C      IWORK  -- (RETURNED)
C         AN INTEGER WORK ARRAY OF LENGTH AT LEAST
C            IF  DEGREE  .GE. 0 THEN
C               4*BINOMIAL( DIMEN + DEGREE , DIMEN )
C                  +( DIMEN )*( DEGREE )
C            ELSE
C               4*BINOMIAL( DIMEN +D,D)+( DIMEN )*D
C         WHERE D IS THE MINIMUM CARDINALITY  OF  A  BASIS  OF  DEGREE
C          DEGREE  SUCH THAT
C            BINOMIAL( DIMEN +ABS( DEGREE ), DIMEN ) .GE.  NPOLYS
C      IWKLEN  - (PASSED)
C         THE LENGTH OF  IWORK
C      IREQD  -- (RETURNED)
C         THE SIZE OF THE INTEGER WORK ARRAY REQUIRED BY  MFIT   FOR
C         THE FIT SPECIFIED BY THE 4 INPUT PARAMETERS.
C      DREQD  -- (RETURNED)
C         THE SIZE OF THE DOUBLE  PRECISION  WORK  ARRAY  REQUIRED  BY
C          MFIT  FOR THE FIT SPECIFIED BY THE 4 INPUT PARAMETERS.
C      ERROR  -- (RETURNED)
C       0 IF  NPOLYS ,  DIMEN ,   DEGREE ,   NPTS   AND   IWKLEN   ARE
C         VALID AND CONSISTENT WITH EACH OTHER.
C       1 IF  DEGREE  .GE. 0 BUT THERE IS AN INTERPOLATING MULTINOMIAL
C         OF SMALLER DEGREE OR IF  DEGREE .LT. 0 AND  NPOLYS .GT. NPTS
C       2 IF  DEGREE  .LT. 0 AND  NPOLYS  .LE. 0
C       3 IF  NPTS  .LT. 1 AND/OR  DIMEN  .LT. 1
C       4 IF  IWKLEN  IS TOO SMALL (SET  IWKLEN  TO THE VALUE RETURNED
C         IN  IREQD  TO RESOLVE THIS PROBLEM)
C
C     NOTE THAT  DEGREE ,  NPOLYS ,  PSIWID  AND  ALFL   ARE  RETURNED
C     IN  IWORK (1-4), RESPECTIVELY.
C
C     DATE LAST MODIFIED
C     ---- ---- --------
C     DECEMBER 10, 1984
C     ****************
C
C     ***************
C     BASIZ  COMPUTES THE SIZE OF THE BASIS (AND AUXILIARY SIZES)
C     BASED PRIMARILY UPON THE DEGREE, NUMBER OF  FITTING POINTS,
C     AND THE DIMENSION.
C     ***************
C
      CALL BASIZ(DEGREE,NPTS,DIMEN,NPOLYS,ERROR)
      IF ( ERROR .GE. 2 ) RETURN
      IREQD = 4 * NPOLYS + DEGREE * DIMEN
      IF ( IWKLEN .GE. IREQD ) GO TO 5
         ERROR = 4
         RETURN
 5    NEWSTT = 4 * NPOLYS + 1
C
C     ***************
C     SET UP USEFUL INDEXING ARRAYS
C          IWORK(1) ,..., IWORK(NEWSTT-1)
C     AND
C          IWORK(NEWSTT ,..., IWORK(NEWSTT+DIMEN*DEGREE)
C     ***************
C
      CALL MTABLE(DEGREE,DIMEN,NPOLYS,IWORK,IWORK(NEWSTT),ALFL)
      IWORK(1) = DEGREE
      IWORK(2) = NPOLYS
C
C     ***************
C     FORCE  ALFL  TO BE AT LEAST 1 SO THAT DIMENSION STATEMENTS
C     USING  ALFL  DO NOT BOMB.
C     ***************
C
      IF ( ALFL .GT. 1 ) ALFL = ALFL - 1
      IWORK(4) = ALFL
C
C     ***************
C     THE FOLLOWING IS A SECTION OF CODE FOR SETTING UP THE
C     STORAGE  MANAGEMENT OF THE  PSI  ARRAY.  THERE  IS  A
C     COMPLICATED DOVETAILING FORMULA USED TO PACK INFORMATION
C     INTO  PSI  WITHOUT LEAVING GAPS.
C
C     ARRAY          LENGTH
C     -----          ------
C      MAXABS         DIMEN  + 1
C      ALPHA          ALFL
C      C              NPOLYS
C      SUMSQS         NPOLYS
C
C     THE NUMBER OF COLUMNS IN  PSI ,  PSIWID , IS DETERMINED BY
C     PSIWID  =  NPOLYS  + 1 - (THE SMALLEST M SUCH THAT ALPHA(J,M)
C                                   IS NONZERO AND J .GE. NPOLYS)
C     THIS INSURES THAT IF THE USER EXTENDS THE BASIS, ALL THE  PSI
C     REQUIRED WILL CERTAINLY BE STORED
C
C     IF DEGREE( NPOLYS ) .LE. 2 THEN                      (CASE 1)
C       PSIWID  =  NPOLYS
C     ELSE
C       IF K =  DIMEN  THEN                                (CASE 2)
C         PSIWID  =  NPOLYS
C                    -  NEWKJ( 1 , DEGREE(NPOLYS)-1 )  + 1
C       ELSE
C            PSIWID  =  NPOLYS
C                      + 1
C                      - (
C                         THE SMALLER OF
C                           NEWKJ(K+1,DEGREE(NPOLYS)-2)    (CASE 3)
C                         AND
C                           INDEXS(3,NPOLYS)               (CASE 4)
C                        )
C
      IF ( DEGREE .GT. 2 ) GO TO 10
C
C     ***************
C     CASE 1
C     ***************
C
         PSIWID = NPOLYS
      GO TO 40
 10      NPLYT4 = 4 * NPOLYS
C
C     ***************
C     KMXBAS  IS K
C                 NPOLYS
C     ***************
C
         KMXBAS = IWORK(NPLYT4 - 2)
C
         IF ( KMXBAS .NE. DIMEN ) GO TO 20
C
C     ***************
C     CASE 2
C     ***************
C
            PSIWID = NPOLYS - IWORK(4 * NPOLYS - 1)
         GO TO 40
C
C     ***************
C     INDEX =  NEWKJ( K      + 1 , DEGREE(NPOLYS-2) )
C                      NPOLYS
C     ***************
C
 20         INDEX = NPLYT4 + (DEGREE - 3) * DIMEN + KMXBAS + 1
            KJP1D2 = IWORK(INDEX)
C
C     ***************
C     STARTJ  =  INDEXS(3,NPOLYS)
C     ***************
C
            STARTJ = IWORK(NPLYT4 - 1)
            IF ( STARTJ .GT. KJP1D2 ) GO TO 30
C
C     ***************
C     CASE 4
C     ***************
C
               PSIWID = NPOLYS - STARTJ + 1
            GO TO 40
C
C     ***************
C     CASE 3
C     ***************
C
 30            PSIWID = NPOLYS - KJP1D2 + 1
 40   IWORK(3) = PSIWID
      DREQD = 2 * NPOLYS + DIMEN + 1 + NPTS * PSIWID + ALFL
      RETURN
      END
      SUBROUTINE BASIZ(DEGREE,NPTS,DIMEN,NPOLYS,ERROR)
C
      INTEGER TOP,BOT,DEGREE,NPTS,DIMEN,NPOLYS,ERROR,I,ROWLEN
C
C     ***************
C     PURPOSE
C     -------
C
C     IF  DEGREE  .GE. 0 THEN
C       FIND THE SIZE OF A BASIS REQUIRED EITHER TO
C       1) APPROXIMATE THE DATA WITH A POLYNOMIAL OF DEGREE
C          GIVEN BY THE PARAMETER  DEGREE
C       OR TO
C       2) SPAN THE SPACE OF POLYNOMIALS OF DEGREE .LE. THE
C          SMALLEST DEGREE OF POLYNOMIAL WHICH INTERPOLATES THE
C          DATA.
C       IN CASE 1  ERROR  = 0.
C       IN CASE 2  ERROR  = 1.
C     ELSE
C       IF  NPOLYS  .GE. 1 THEN
C          IF NPOLYS .GT. NPTS THEN
C             SET  NPOLYS  =  NPTS , FIND THE SMALLEST DEGREE OF A
C             POLYNOMIAL  WHICH  INTERPOLATES  THE  DATA,  AND SET
C              ERROR  = 1.
C          ELSE
C             FIND THE LARGEST DEGREE  DEGREE  OF A POLYNOMIAL  IN
C             A  BASIS OF  NPOLYS  POLYNOMIALS GENERATED ACCORDING
C             TO OUR ORDERING AND SET  ERROR  = 0.
C       ELSE
C           ERROR  = 2
C
C     THIS SUBROUTINE IS CALLED BY  ALLOT .  IT IS NOT  CALLED  BY
C     THE USER DIRECTLY.
C
C     DATE LAST MODIFIED
C     ---- ---- --------
C     OCTOBER 16, 1984
C     ****************
C
      ERROR = 0
      IF ( NPTS .GE. 1 .AND. DIMEN .GE. 1 ) GO TO 10
         ERROR = 3
         RETURN
C
 10   CONTINUE
      IF ( DEGREE .LT. 0 ) GO TO 30
C
        ROWLEN = 1
        NPOLYS = 1
        TOP = DIMEN - 1
        BOT = 0
        IF ( DEGREE .LT. 1 )  GO TO 30
          DO 20 I=1,DEGREE
            TOP = TOP + 1
            BOT = BOT + 1
            ROWLEN = (ROWLEN*TOP)/BOT
            NPOLYS = NPOLYS + ROWLEN
   20     CONTINUE
C
   30 CONTINUE
      IF ( NPOLYS .GE. 1 ) GO TO 40
            ERROR = 2
            RETURN
   40 CONTINUE
      IF ( NPOLYS .LT. NPTS ) GO TO 50
            NPOLYS = NPTS
            ERROR = 1
   50 CONTINUE
      ROWLEN = 1
      I = 1
      DEGREE = 0
      TOP = DIMEN - 1
      BOT = 0
   60 CONTINUE
      IF ( I .GE. NPOLYS )  GO TO 70
          TOP = TOP + 1
          BOT = BOT + 1
          ROWLEN = (ROWLEN*TOP)/BOT
          I = I + ROWLEN
          DEGREE = DEGREE + 1
          IF ( I .LT. NPOLYS )  GO TO 60
   70 CONTINUE
      RETURN
      END
      SUBROUTINE MTABLE(DEGREE,DIMEN,NPOLYS,INDEXS,NEWKJ,ALFLP1)
C
      INTEGER J,KJ,CURDEG,JPRIME,NWITHK,I,CURM1,RALEN,DIMM1,DIMM2
      INTEGER NPOLYS,DIMEN,DEGREE,ALFLP1,DIMP1
      INTEGER INDEXS(4,NPOLYS),NEWKJ(DIMEN,DEGREE)
C
C     ***************
C     PURPOSE
C     -------
C
C     TABULATE  JP  AND  KJ  FOR EACH  J
C
C     VARIABLES
C     ---------
C
C      ALFLP1  -- (INTEGER) -- (PASSED)
C         THE LENGTH REQUIRED FOR ARRAY  ALPHA , PLUS ONE
C      DEGREE  -- (INTEGER) -- (PASSED)
C         THE DEGREE OF THE POLYNOMIAL TO BE FITTED
C      DIMEN  -- (INTEGER) -- (PASSED)
C         NUMBER OF INDEPENDENT VARIABLES
C      INDEXS  -- (INTEGER, 2-SUBSCRIPT ARRAY) -- (RETURNED)
C          INDEXS (1, J )   IS    JP ,    INDEXS (2, J )   IS     KJ ,
C          INDEXS (3, J )  IS THE FIRST NONZERO RECURRENCE COEFFICIENT
C         IN  ALPHA  AND  INDEXS (4, J ) IS ITS LOCATION IN  ALPHA .
C      NEWKJ  -- (INTEGER, 2-SUBSCRIPT ARRAY) -- (RETURNED)
C          NEWKJ ( K , D ) IS THE FIRST MONOMIAL OF DEGREE  D   HAVING
C          KJ = K .
C      NPOLYS  -- (INTEGER) -- (PASSED)
C         NUMBER  OF  MONOMIALS  OF  DEGREE  .LE.  ORDER  IN   DIMEN
C         INDEPENDENT VARIABLES.
C
C     THIS SUBPROGRAM CAN BE CODED (EXCLUDING THE PART FOR CALCULATING
C      INDEXS (3, J )  AND   INDEXS (4, J )) MENTALLY MORE EFFICIENTLY
C     BUT COMPUTATIONALLY LESS EFFICIENTLY AS
C
C         J = 2
C         DO 5 KJ = 1,DIMEN
C           NEWKJ(KJ,1) = KJ + 1
C           INDEXS(1,J) = 1
C           INDEXS(2,J) = KJ
C           J = J + 1
C      5  CONTINUE
C         DO 10 CURDEG = 2,DEGREE
C           DO 10 KJ = 1,DIMEN
C             JPRIME = NEWKJ(KJ,CURDEG - 1)
C             NEWKJ(KJ,CURDEG) = J
C             NWITHK = COMB(DIMEN + CURDEG - KJ - 1,CURDEG - 1)
C             DO 10 I = 1,NWITHK
C               INDEXS(1,J) = JPRIME
C               INDEXS(2,J) = KJ
C               JPRIME = JPRIME + 1
C               J = J + 1
C     10  CONTINUE
C
C     WHERE COMB(N,KJ) IS N-FACTORIAL / ((N-KJ)-FACTORIAL * KJ-FACTORIAL
C     HERE WE MAKE USE OF THE RECURRENCE RELATIONS
C
C       COMB(DIMEN+CURDEG-2,CURDEG-1)
C
C            (DIMEN+CURDEG-2)*COMB(DIMEN+CURDEG-3,CURDEG-2)
C          = ----------------------------------------------
C                              (CURDEG-1)
C
C     AND
C
C       COMB(DIMEN+CURDEG-KJ-1,CURDEG-1)
C
C            (DIMEN-KJ+1)*COMB(DIMEN+CURDEG-KJ,CURDEG-1)
C          = -------------------------------------------
C                         (DIMEN+CURDEG-KJ)
C
C
C     DATE LAST MODIFIED
C     ---- ---- --------
C     OCTOBER 16, 1984
C     ****************
C
      ALFLP1 = 1
C
C     ***************
C     SET  INDEXS (4,1) TO 1 SO THAT  ALFL - INDEXS (4,1)+1 IS THE
C     NUMBER OF COLUMNS REQUIRED FOR  PSI  FOR  NPOLYS =1  ( ALFL
C     IS DEFINED IN THE MAINLINE TO BE  ALFLP1 -1 IF ALFLP1 .GT. 1
C     AND  ALFLP1  OTHERWISE.
C     ***************
C
      INDEXS(4,1) = 1
C
      IF ( NPOLYS .EQ. 1 ) RETURN
      J = 2
      DO 10 KJ = 1,DIMEN
         NEWKJ(KJ,1) = KJ + 1
         INDEXS(1,J) = 1
         INDEXS(2,J) = KJ
         INDEXS(3,J) = 1
         INDEXS(4,J) = ALFLP1
         ALFLP1 = ALFLP1 + J - 1
         IF ( J .EQ. NPOLYS ) RETURN
10       J = J + 1
      IF ( DEGREE .EQ. 1 ) RETURN
      RALEN = 1
      DIMM1 = DIMEN - 1
      DIMM2 = DIMEN - 2
      DIMP1 = DIMEN + 1
      DO 70 CURDEG = 2,DEGREE
         CURM1 = CURDEG - 1
         RALEN = (RALEN * (DIMM2 + CURDEG)) / CURM1
         NWITHK = RALEN
         KJ = 1
20       JPRIME = NEWKJ(KJ,CURM1)
         NEWKJ(KJ,CURDEG) = J
         IF ( KJ .EQ. DIMEN ) GO TO 60
            DO 50 I = 1,NWITHK
               INDEXS(1,J) = JPRIME
               INDEXS(2,J) = KJ
C
C     ***************
C     CALCULATE  INDEXS (3, J ),  INDEXS (4, J )
C     ***************
C
               IF ( KJ .LT. INDEXS(2,JPRIME) ) GO TO 30
                  INDEXS(3,J) = INDEXS(1,JPRIME)
                  GO TO 40
 30            INDEXS(3,J) = NEWKJ(1,CURDEG - 1)
 40            INDEXS(4,J) = ALFLP1
               ALFLP1 = ALFLP1 + J - INDEXS(3,J)
               IF ( J .EQ. NPOLYS ) RETURN
C
               JPRIME = JPRIME + 1
 50            J = J + 1
            KJ = KJ + 1
            NWITHK = (NWITHK * (DIMP1 - KJ)) / (DIMEN + CURDEG - KJ)
            GO TO 20
 60      INDEXS(1,J) = JPRIME
         INDEXS(2,J) = DIMEN
         INDEXS(3,J) = INDEXS(1,JPRIME)
         INDEXS(4,J) = ALFLP1
         ALFLP1 = ALFLP1 + J - INDEXS(3,J)
         IF ( J .EQ. NPOLYS ) RETURN
 70      J = J + 1
      RETURN
      END
      SUBROUTINE GNRTP(DEGREE,ALPHA,PSI,INDEXS,
     +                 NEWKJ,SUMSQS,COORD,NCROWS,NPOLYS,
     +                 DIMEN,NPTS,F,Z,C,PSIWID,WEIGHT,
     +                 ALFL,DIMP1,MAXABS,ERROR)
C
      INTEGER DEGREE,DIMEN,NPOLYS,NPTS,K,PSIWID,ALFL,P,STTDEG,ONPLYS
      INTEGER ERROR,DIMP1
      INTEGER INDEXS(4,NPOLYS),NEWKJ(DIMEN,DEGREE)
      REAL    PSI(NPTS,PSIWID),ALPHA(ALFL),F(NPTS)
      REAL    COORD(NCROWS,DIMEN),MAXABS(DIMP1),WEIGHT(NPTS)
      REAL    Z(NPTS),SUMSQS(NPOLYS),C(NPOLYS)
      REAL    RUNTOT,RNTOT1
C
C     ***************
C     PURPOSE
C     -------
C
C     THE MULTINOMIAL FIT IS GENERATED INCREMENTALLY, A BASIS  ELEMENT
C     AT A TIME.  THIS SUBROUTINE STARTS THE PROCESS OFF BY SETTING UP
C     THE FIRST BASIS ELEMENT, SCALING THE  DATA,  FINDING  THE  FIRST
C     COEFFICIENT,  AND  INITIALIZING  THE  WORK ARRAY Z.  GNRTP  THEN
C     CALLS  INCDG  IF MORE THAN ONE BASIS ELEMENT IS REQUIRED.
C
C     THIS SUBROUTINE IS CALLED BY  MFIT .  IT IS NOT CALLED BY  THE
C     USER.
C
C     THIS SUBROUTINE CALLS  SCALPM ,  SCALDN , AND  INCDG .
C
C
C     MODIFIED BY A.H. MORRIS (NSWC)
C     ****************
C
C     ***************
C     SET UP THE SCALING.
C     ***************
C
      DO 10 K = 1,DIMEN
         CALL SCALPM(COORD(1,K),NPTS,MAXABS(K))
 10      CALL SCALDN(COORD(1,K),NPTS,MAXABS(K))
      CALL SCALPM(F,NPTS,MAXABS(DIMP1))
      CALL SCALDN(F,NPTS,MAXABS(DIMP1))
C
C     ***************
C      SUMSQS (1) = (1,1)
C     C  = (F,1) / (1,1)
C      1
C     ***************
C
      RUNTOT = 0.0
      RNTOT1 = 0.0
      DO 20 P = 1,NPTS
         PSI(P,1) = 1.0
         RNTOT1 = RNTOT1 + WEIGHT(P)
 20      RUNTOT = RUNTOT + F(P) * WEIGHT(P)
      SUMSQS(1) = RNTOT1
      C(1) = RUNTOT / RNTOT1
C
C     ***************
C     Z = F - C
C              1
C     ***************
C
      DO 30 P = 1,NPTS
 30      Z(P) = F(P) - C(1)
C
      IF ( NPOLYS .EQ. 1 ) RETURN
      STTDEG = 1
      ONPLYS = 1
C
      CALL INCDG(DEGREE,ALPHA,PSI,INDEXS,NEWKJ,SUMSQS,
     +           COORD,NCROWS,NPOLYS,DIMEN,NPTS,F,Z,C,PSIWID,
     +           WEIGHT,ALFL,ONPLYS,STTDEG,ERROR)
      RETURN
      END
      SUBROUTINE INCDG(DEGREE,ALPHA,PSI,INDEXS,NEWKJ,
     +                 SUMSQS,COORD,NCROWS,NPOLYS,
     +                 DIMEN,NPTS,F,Z,C,PSIWID,WEIGHT,
     +                 ALFL,ONPLYS,STTDEG,ERROR)
C
      INTEGER JPRIME,P,J,CURDEG,KJ,KJP,L,JPM1,JM1
      INTEGER M,START,JINDEX,JPINDX,Q,J3,J1,J1MJ2,ERROR
      INTEGER J0MJ1,J1M1,STARTA,ONPLYS,ONPP1,STTDEG,INDEX1,INDEX2
      INTEGER DEGREE,NPOLYS,NPTS,DIMEN,PSIWID,ALFL
      INTEGER INDEXS(4,NPOLYS),NEWKJ(DIMEN,DEGREE)
      REAL    ALPHA(ALFL),COORD(NCROWS,DIMEN),PSI(NPTS,PSIWID)
      REAL    SUMSQS(NPOLYS),C(NPOLYS),F(NPTS),WEIGHT(NPTS)
      REAL    Z(NPTS)
      REAL    ARC,RUNTOT,RNTOT1,RNTOT2
C
C     ***************
C     PURPOSE
C     -------
C
C     THE MULTINOMIAL FIT IS GENERATED INCREMENTALLY, A BASIS  ELEMENT
C     AT A TIME.  THIS SUBROUTINE CONTINUES THE PROCESS STARTED OFF BY
C      GNRTP .
C
C     THIS SUBROUTINE IS CALLED BY  GNRTP  AND NOT BY THE USER.
C
C
C     MODIFIED BY A.H. MORRIS (NSWC)
C
C     ****************
C
      IF ( ONPLYS .GE. 1 .AND. STTDEG .GE. 1 ) GO TO 10
         ERROR = 6
      RETURN
 10      IF ( INDEXS(2,ONPLYS) .EQ. DIMEN ) GO TO 20
            CURDEG = STTDEG
         GO TO 30
 20         CURDEG = STTDEG + 1
 30   ONPP1 = ONPLYS + 1
      DO 170 J = ONPP1,NPOLYS
         JPRIME = INDEXS(1,J)
         JINDEX = J - ((J - 1) / PSIWID) * PSIWID
         JPINDX = JPRIME - ((JPRIME - 1) / PSIWID) * PSIWID
         KJ = INDEXS(2,J)
         START = INDEXS(3,J)
         M = START
         STARTA = INDEXS(4,J) - START
         IF ( CURDEG .EQ. 1 ) GO TO 100
         KJP = INDEXS(2,JPRIME)
         J1 = NEWKJ(KJ,CURDEG - 1)
C
C     ***************
C     CALCULATE THOSE  ALPHA ( J , M ) THAT CAN BE CALCULATED FROM
C     PREVIOUSLY CALCULATED ALPHAS.
C     ***************
C
         IF ( KJ .LT. KJP ) GO TO 50
C
C     ***************
C     FIRST CALCULATE THOSE BETWEEN  JPP  AND THE END OF 2 ROWS BACK.
C     CALCULATE  ALPHA ( J , JPP )
C     ***************
C
         INDEX1 = INDEXS(4,J)
         ALPHA(INDEX1) = SUMSQS(JPRIME) / SUMSQS(START)
C
         M = START + 1
         J3 = NEWKJ(1,CURDEG - 1) - 1
         IF ( M .GT. J3 ) GO TO 50
C
C     ***************
C     CURDEG .GT. 2 IF CONTROL HAS PASSED THE BRANCHES IN THE 3-RD
C     PREVIOUS AND 8-TH PREVIOUS STATEMENTS.
C     ***************
C
            J1MJ2 = J1 - NEWKJ(KJ,CURDEG - 2)
C
            DO 40 L = M,J3
               Q = J1MJ2 + L
               INDEX1 = STARTA + L
               INDEX2 = INDEXS(4,Q) - INDEXS(3,Q) + JPRIME
 40            ALPHA(INDEX1) = ALPHA(INDEX2) * SUMSQS(JPRIME) /
     +         SUMSQS(L)
C
C     ***************
C     CALCULATE  ALPHA ( J , M ) FOR  M  BETWEEN THE 2
C     RANGES CALCULATED BEFORE USING
C
C        ALPHA ( J , L ) = (X  *  PSI  ,PSI )  / (PSI ,PSI )
C                             K      JP    L         L    L
C                              J
C     ***************
C
         M = J3 + 1
 50      IF ( JPRIME .EQ. J1 ) GO TO 100
            IF ( KJ .EQ. 1 ) GO TO 80
            J1M1 = J1 - 1
            DO 70 L = M,J1M1
               RUNTOT = 0.0
               DO 60 P = 1,NPTS
                  INDEX1 = L - ((L - 1) / PSIWID) * PSIWID
 60               RUNTOT = RUNTOT + COORD(P,KJ) * PSI(P,JPINDX) *
     +            PSI(P,INDEX1) * WEIGHT(P)
               INDEX1 = STARTA + L
 70            ALPHA(INDEX1) = RUNTOT / SUMSQS(L)
C
C     ***************
C     CALCULATE  ALPHA ( J , M ) FOR  M  BETWEEN
C      NEWKJ ( KJ , CURDEG  - 1)  AND
C      JP  - 1.
C     ***************
C
 80         J0MJ1 = NEWKJ(KJ,CURDEG) - J1
            JPM1 = JPRIME - 1
            DO 90 L = J1,JPM1
               Q = J0MJ1 + L
               INDEX1 = STARTA + L
               INDEX2 = INDEXS(4,Q) - INDEXS(3,Q) + JPRIME
 90            ALPHA(INDEX1) = ALPHA(INDEX2) * SUMSQS(JPRIME) /
     +         SUMSQS(L)
            M = JPRIME
C
C     ***************
C     CALCULATE THE REMAINING  ALPHA ( J , M ) FROM
C
C      ALPHA ( J , L ) = (X   * PSI  ,PSI ) / (PSI ,PSI )
C                          K       JP    L        L    L
C                           J
C     ***************
C
 100     JM1 = J - 1
         DO 120 L = M,JM1
            RUNTOT = 0.0
            DO 110 P = 1,NPTS
               INDEX1 = L - ((L - 1) / PSIWID) * PSIWID
 110           RUNTOT = RUNTOT + COORD(P,KJ) * PSI(P,JPINDX) *
     +         PSI(P,INDEX1) * WEIGHT(P)
            INDEX1 = STARTA + L
 120        ALPHA(INDEX1) = RUNTOT / SUMSQS(L)
C
C     ***************
C     NOW CALCULATE THE  PSI (P,J),  SUMSQS (J) AND  C (J) USING
C
C                          J-1
C     PSI  = X  * PSI   -  SUM   ALPHA(J,L) * PSI
C        J    K      JP    L=JPP                 L
C
C     SUMSQS  = (PSI ,PSI )
C           J       J    J
C
C     C  = (Z,PSI )
C      J         J
C     ***************
C
 130      JM1 = J - 1
          ARC = 0.0
          RNTOT1 = 0.0
          RNTOT2 = 0.0
          DO 150 P = 1,NPTS
              RUNTOT = COORD(P,KJ) * PSI(P,JPINDX)
              DO 140 L = START,JM1
                 INDEX1 = STARTA + L
                 INDEX2 = L - ((L - 1) / PSIWID) * PSIWID
 140             RUNTOT = RUNTOT - ALPHA(INDEX1) * PSI(P,INDEX2)
              PSI(P,JINDEX) = RUNTOT
              ARC = ARC + PSI(P,INDEX2) * PSI(P,JINDEX) *
     +                          WEIGHT(P)
              RNTOT1 = RNTOT1 + PSI(P,JINDEX) * PSI(P,JINDEX) *
     +                          WEIGHT(P)
 150          RNTOT2 = RNTOT2 + Z(P) * PSI(P,JINDEX) * WEIGHT(P)
          IF (ARC * ARC .GE. SUMSQS(JM1) * RNTOT1 * 1.E-03)
     +        GO TO 200
          SUMSQS(J) = RNTOT1
          C(J) = RNTOT2 / RNTOT1
C
C     ***************
C     CALCULATE THE NEW  Z ( P ) AND THE NEW  SSRES  USING
C
C     Z = Z - C  * PSI
C              J      J
C     ***************
C
          DO 160 P = 1,NPTS
 160          Z(P) = Z(P) - C(J) * PSI(P,JINDEX)
          STTDEG = CURDEG
 170      IF ( KJ .EQ. DIMEN ) CURDEG = CURDEG + 1
      RETURN
C
C     ***************
C     THE J-TH BASIS MULTINOMIAL CANNOT BE COMPUTED ACCURATELY.
C     ONLY J - 1 BASIS MULTINOMIALS ARE GENERATED.
C     ***************
C
 200  ERROR = -1
      DEGREE = STTDEG
      NPOLYS = JM1
      RETURN
      END
      SUBROUTINE SCALPM(COORD,NPTS,MAXABS)
C
      INTEGER NPTS,P
      REAL    MAXABS,A
      REAL    COORD(NPTS)
C
C     ***************
C     PURPOSE
C     -------
C
C     FIND SCALING PARAMETER(S) FOR THE PROBLEM. IF THE SCALING SCHEME
C     IS CHANGED, ALL FOUR OF THE FOLLOWING WOULD HAVE TO BE CHANGED
C
C     1)  SCALPM  - FIND THE SCALING PARAMETERS
C     2)  SCALDN  - SCALE THE PROBLEM DATA
C     3)  THE SCALING OF THE RESIDUALS IN  MFIT
C     4)  THE SCALING PERFORMED IN  MEVAL1
C
C     THIS SUBROUTINE IS CALLED BY  GNRTP .  IT IS NOT CALLED  BY  THE
C     USER.
C
C     THE SCALING WHICH  IT  DEFINES  MUST  BE  COORDINATED  WITH  THE
C     SCALING  OF RESIDUALS WHICH IS CARRIED OUT TOWARD THE END OF THE
C     SUBROUTINE  MFIT.  THE SCALING MUST ALSO BE COORDINATED WITH THE
C     SCALING PERFORMED IN THE 10 LOOP  AND  AT STATEMENTS 40 AND 50
C     (WITH THE SCALE FACTOR MAXABS(DIMP1)) IN  MEVAL1.
C
C     ****************
C
      MAXABS = 0.0
      DO 10 P = 1,NPTS
         A = ABS(COORD(P))
   10    IF ( A .GT. MAXABS ) MAXABS = A
      RETURN
      END
      SUBROUTINE SCALDN(COORD,NPTS,MAXABS)
C
      INTEGER NPTS,P
      REAL    MAXABS
      REAL    COORD(NPTS)
C
C     ***************
C     PURPOSE
C     -------
C
C     CARRY OUT THE DATA-SCALING WHICH IS DEFINED  BY  THE  SUBROUTINE
C     SCALPM .
C
C     THIS SUBROUTINE IS CALLED BY  GNRTP .  IT IS NOT CALLED  BY  THE
C     USER.
C
C     THE SCALING WHICH THIS ROUTINE CARRIES OUT  MUST  BE  CONSISTENT
C     WITH THE SCALING IN THE SUBROUTINES MFIT AND MEVAL1.
C
C     ****************
C
      IF ( MAXABS .EQ. 0.0E+00 ) RETURN
         DO 10 P = 1,NPTS
   10       COORD(P) = COORD(P) / MAXABS
         RETURN
      END
      SUBROUTINE MEVAL(DIMEN,EVLDEG,NEPOLS,NEPTS,EVLCDS,NEROWS,EVLVLS,
     +                 ERROR,FITIWK,FITDWK,FIWKLN,FDWKLN,TEMP)
C
      INTEGER FIWKLN,FDWKLN,NEPOLS,NEPTS,DIMEN,ERROR,MAXSTT,ALFSTT,CSTT
      INTEGER GBASIZ,ALFL,DIMP1,EVLDEG,TOP,BOT,CURDEG,PSISTT
      INTEGER FITIWK(FIWKLN)
      REAL    FITDWK(FDWKLN),EVLCDS(NEROWS,DIMEN)
      REAL    EVLVLS(NEPTS),TEMP(DIMEN)
C
C     ***************
C     PURPOSE
C     -------
C
C     THIS SUBROUTINE  EVALUATES  THE  LEAST-SQUARES  MULTINOMIAL  FIT
C     WHICH HAS BEEN PREVIOUSLY PRODUCED BY  MFIT .  EITHER THE FULL
C     MULTINOMIAL AS PRODUCED MAY BE EVALUATED,  OR  ONLY  AN  INITIAL
C     SEGMENT THEREOF.  AS IN THE CASE WITH  MFIT , IT IS POSSIBLE
C     (1) TO SPECIFY MULTINOMIALS OF A FULL GIVEN DEGREE, OR
C     (2) TO SPECIFY  THE  NUMBER  OF  ORTHOGONAL  BASIS  ELEMENTS  TO
C         ACHIEVE A PARTIAL-DEGREE FIT.
C
C     IN CASE (1), THE  DESIRED  DEGREE  IS  GIVEN  AS  THE  VALUE  OF
C     EVLDEG   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
C     VALUE USED FOR  FITDEG  IN  MFIT ), AND THE PARAMETER  NEPOLS
C     WILL  BE  SET  BY  MEVAL  TO SPECIFY THE NUMBER OF BASIS ELEMENTS
C     REQUIRED. IF  EVLDEG  .LT.  FITDEG   IS  GIVEN,  THEN  ONLY  THE
C     INITIAL  PORTION OF THE FITTING MULTINOMIAL (OF DEGREE  EVLDEG )
C     WILL BE EVALUATED.
C
C     IN CASE (2),  EVLDEG  IS TO BE SET NEGATIVE, IN WHICH  CASE  THE
C     VALUE  OF   NEPOLS  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
C     THE VALUE USED FOR   NFPOLS   IN   MFIT )  WILL  BE  TAKEN  AS
C     DEFINING  THE  INITIAL  PORTION OF THE FITTING MULTINOMIAL TO BE
C     EVALUATED.
C
C     IF  NEPOLS  =  NFPOLS  (WITH  EVLDEG  .LT.  0),  OR   EVLDEG   =
C     FITDEG  (WITH   EVLDEG   .GT.  0),  THEN  THE  FULL  MULTINOMIAL
C     GENERATED BY  MFIT  WILL BE EVALUATED.
C
C     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
C     (COLLECTION  OF  VARIABLE  VALUES)  GIVEN AS A ROW OF THE MATRIX
C      EVLCDS .  THE  VALUES  PRODUCED  FROM  THE  FULL,  OR  PARTIAL,
C     MULTINOMIAL WILL BE PLACED IN THE ARRAY  EVLVLS .
C
C     VARIABLES
C     ---------
C
C      DIMEN  -- (INTEGER) -- (PASSED)
C         THE NUMBER OF VARIABLES.
C      EVLDEG  -- (INTEGER) -- (PASSED)
C         IF  EVLDEG  .LT. 0, THEN THIS PARAMETER WILL BE IGNORED.
C         IF  EVLDEG  .GE. 0, THEN THE VALUE OF  EVLDEG  MUST  SATISFY
C         EVLDEG  .LE. (THE  DEGREE  OF THE APPROXIMATING MULTINOMIAL
C         GENERATED IN  MFIT ).  IN THIS CASE  EVLDEG  WILL  SPECIFY
C         THE DEGREE OF THE INITIAL PORTION OF THE FITTING MULTINOMIAL
C         TO BE EVALUATED.
C      NEPOLS  -- (INTEGER) -- (PASSED/RETURNED)
C         IF  EVLDEG  .GE. 0, THEN THIS PARAMETER WILL BE IGNORED.
C         IF EVLDEG .LT. 0, THEN THE PARTIAL MULTINOMIAL INVOLVING THE
C         FIRST   NEPOLS  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
C         AT THE POINTS GIVEN BY  EVLCDS .  THE RESULTING VALUES  WILL
C         BE STORED IN  EVLVLS .
C         THE VALUE OF NEPOLS MUST BE .GE. 1 AND .LE. (THE SIZE OF THE
C         BASIS  GENERATED  IN   MFIT ),  WHICH  WAS RETURNED AS THE
C         VALUE OF  NFPOLS .
C         NEPOLS  WILL BE CHANGED IF EVLDEG .GT. 0 TO GIVE THE SIZE OF
C         BASIS REQUIRED FOR THE MULTINOMIAL OF DEGREE  EVLDEG .
C      NEPTS  -- (INTEGER) -- (PASSED)
C         THE NUMBER OF EVALUATION POINTS.
C      EVLCDS  -- (REAL 2-SUBSCRIPT ARRAY) -- (PASSED)
C         EVLCDS (P,K) IS THE VALUE OF THE K-TH VARIABLE AT THE  P-TH
C         EVALUATION POINT.
C      NEROWS  -- (INTEGER) -- (PASSED)
C         THE ROW DIMENSION DECLARED FOR EVLCDS IN THE CALLING PROGRAM.
C      EVLVLS  -- (INTEGER) -- (RETURNED)
C         EVLVLS (P) IS THE VALUE OF THE EVALUATED MULTINOMIAL AT THE
C         P-TH EVALUATION POINT.
C      ERROR  -- (INTEGER) -- (RETURNED)
C          0 .........  IF NO ERRORS
C         -1 .........  IF  NEPOLS  .GT.  NFPOLS  OR  NEPOLS  .LT. 1
C         -2 .........  IF  NEPTS  .LT. 1 OR  DIMEN  .LT. 1
C      FITIWK  -- (INTEGER, 1-SUBSCRIPT ARRAY) -- (PASSED)
C         THE INTEGER WORK ARRAY OF LENGTH  FIWKLN  THAT WAS  USED  IN
C          MFIT .
C      FITDWK  -- (REAL 2-SUBSCRIPT ARRAY) -- (PASSED)
C         THE REAL WORK ARRAY OF LENGTH  FDWKLN  THAT WAS
C         USED IN  MFIT .
C      FIWKLN  -- (INTEGER) -- (PASSED)
C         THE LENGTH OF  FITIWK .
C      FDWKLN  -- (INTEGER) -- (PASSED)
C         THE LENGTH OF  FITDWK .
C      TEMP    -- (REAL 1-SUBSCRIPT ARRAY)
C         A WORK ARRAY OF LENGTH  DIMEN  (OR LONGER).
C
C     THE SUBROUTINE  MEVAL1  IS CALLED TO DO THE ACTUAL EVALUATION.
C
C     MODIFIED BY A.H. MORRIS (NSWC)
C
C     ****************
C
C
C     ***************
C     SET UP INDEX POINTERS TO THE BEGINNING OF EACH ROW OF
C     THE MTABLE -- THIS SETS THE BEGINNING POINT FOR EACH
C     FULL MULTINOMIAL DEGREE.
C     ***************
C
      IF (NEPTS .LT. 1 .OR. DIMEN .LT. 1) GO TO 110
      IF (EVLDEG) 40,10,20
C
   10 NEPOLS = 1
      GO TO 50
C
   20 TOP = 1
      BOT = 1
      DO 30 CURDEG = 1,EVLDEG
         TOP = TOP * (DIMEN + CURDEG)
   30    BOT = BOT * CURDEG
      NEPOLS = TOP / BOT
C
   40 GBASIZ = FITIWK(1)
      IF (NEPOLS .GT. GBASIZ .OR. NEPOLS .LT. 1) GO TO 100
C
   50 ERROR = 0
      DIMP1 = DIMEN + 1
      ALFL = FITIWK(4)
      MAXSTT = 1
      ALFSTT = DIMP1 + MAXSTT
      CSTT = ALFSTT + ALFL
      PSISTT = CSTT + FITIWK(2)
C
C     ***************
C     THE ACTUAL EVALUATION IS DONE INSIDE  MEVAL1.
C     ***************
C
      CALL MEVAL1 (EVLCDS,NEROWS,FITDWK(CSTT),NEPTS,DIMEN,NEPOLS,
     +             FITDWK(ALFSTT),FITIWK,FITDWK(PSISTT),
     +             EVLVLS,ALFL,FITDWK(MAXSTT),TEMP,DIMP1)
      RETURN
C
C     ***************
C     ERROR RETURN
C     ***************
C
  100 ERROR = -1
      RETURN
  110 ERROR = -2
      RETURN
      END
