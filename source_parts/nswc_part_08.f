      SUBROUTINE R1MPYQ(M,N,A,LDA,V,W)
      INTEGER M,N,LDA
      REAL A(LDA,N),V(N),W(N)
C     **********
C
C     SUBROUTINE R1MPYQ
C
C     GIVEN AN M BY N MATRIX A, THIS SUBROUTINE COMPUTES A*Q WHERE
C     Q IS THE PRODUCT OF 2*(N - 1) TRANSFORMATIONS
C
C           GV(N-1)*...*GV(1)*GW(1)*...*GW(N-1)
C
C     AND GV(I), GW(I) ARE GIVENS ROTATIONS IN THE (I,N) PLANE WHICH
C     ELIMINATE ELEMENTS IN THE I-TH AND N-TH PLANES, RESPECTIVELY.
C     Q ITSELF IS NOT GIVEN, RATHER THE INFORMATION TO RECOVER THE
C     GV, GW ROTATIONS IS SUPPLIED.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE R1MPYQ(M,N,A,LDA,V,W)
C
C     WHERE
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF ROWS OF A.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF COLUMNS OF A.
C
C       A IS AN M BY N ARRAY. ON INPUT A MUST CONTAIN THE MATRIX
C         TO BE POSTMULTIPLIED BY THE ORTHOGONAL MATRIX Q
C         DESCRIBED ABOVE. ON OUTPUT A*Q HAS REPLACED A.
C
C       LDA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY A.
C
C       V IS AN INPUT ARRAY OF LENGTH N. V(I) MUST CONTAIN THE
C         INFORMATION NECESSARY TO RECOVER THE GIVENS ROTATION GV(I)
C         DESCRIBED ABOVE.
C
C       W IS AN INPUT ARRAY OF LENGTH N. W(I) MUST CONTAIN THE
C         INFORMATION NECESSARY TO RECOVER THE GIVENS ROTATION GW(I)
C         DESCRIBED ABOVE.
C
C     SUBROUTINES CALLED
C
C       FORTRAN-SUPPLIED ... ABS,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C
C     **********
      INTEGER I,J,NMJ,NM1
      REAL COS,ONE,SIN,TEMP
      DATA ONE /1.0E0/
C
C     APPLY THE FIRST SET OF GIVENS ROTATIONS TO A.
C
      NM1 = N - 1
      IF (NM1 .LT. 1) GO TO 50
      DO 20 NMJ = 1, NM1
         J = N - NMJ
         IF (ABS(V(J)) .GT. ONE) COS = ONE/V(J)
         IF (ABS(V(J)) .GT. ONE) SIN = SQRT(ONE-COS**2)
         IF (ABS(V(J)) .LE. ONE) SIN = V(J)
         IF (ABS(V(J)) .LE. ONE) COS = SQRT(ONE-SIN**2)
         DO 10 I = 1, M
            TEMP = COS*A(I,J) - SIN*A(I,N)
            A(I,N) = SIN*A(I,J) + COS*A(I,N)
            A(I,J) = TEMP
   10       CONTINUE
   20    CONTINUE
C
C     APPLY THE SECOND SET OF GIVENS ROTATIONS TO A.
C
      DO 40 J = 1, NM1
         IF (ABS(W(J)) .GT. ONE) COS = ONE/W(J)
         IF (ABS(W(J)) .GT. ONE) SIN = SQRT(ONE-COS**2)
         IF (ABS(W(J)) .LE. ONE) SIN = W(J)
         IF (ABS(W(J)) .LE. ONE) COS = SQRT(ONE-SIN**2)
         DO 30 I = 1, M
            TEMP = COS*A(I,J) + SIN*A(I,N)
            A(I,N) = -SIN*A(I,J) + COS*A(I,N)
            A(I,J) = TEMP
   30       CONTINUE
   40    CONTINUE
   50 CONTINUE
      RETURN
C
C     LAST CARD OF SUBROUTINE R1MPYQ.
C
      END
      SUBROUTINE R1UPDT(M,N,S,LS,U,V,W,SING)
      INTEGER M,N,LS
      LOGICAL SING
      REAL S(LS),U(M),V(N),W(M)
C     **********
C
C     SUBROUTINE R1UPDT
C
C     GIVEN AN M BY N LOWER TRAPEZOIDAL MATRIX S, AN M-VECTOR U,
C     AND AN N-VECTOR V, THE PROBLEM IS TO DETERMINE AN
C     ORTHOGONAL MATRIX Q SUCH THAT
C
C                   T
C           (S + U*V )*Q
C
C     IS AGAIN LOWER TRAPEZOIDAL.
C
C     THIS SUBROUTINE DETERMINES Q AS THE PRODUCT OF 2*(N - 1)
C     TRANSFORMATIONS
C
C           GV(N-1)*...*GV(1)*GW(1)*...*GW(N-1)
C
C     WHERE GV(I), GW(I) ARE GIVENS ROTATIONS IN THE (I,N) PLANE
C     WHICH ELIMINATE ELEMENTS IN THE I-TH AND N-TH PLANES,
C     RESPECTIVELY. Q ITSELF IS NOT ACCUMULATED, RATHER THE
C     INFORMATION TO RECOVER THE GV, GW ROTATIONS IS RETURNED.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE R1UPDT(M,N,S,LS,U,V,W,SING)
C
C     WHERE
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF ROWS OF S.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF COLUMNS OF S. N MUST NOT EXCEED M.
C
C       S IS AN ARRAY OF LENGTH LS. ON INPUT S MUST CONTAIN THE LOWER
C         TRAPEZOIDAL MATRIX S STORED BY COLUMNS. ON OUTPUT S CONTAINS
C         THE LOWER TRAPEZOIDAL MATRIX PRODUCED AS DESCRIBED ABOVE.
C
C       LS IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
C         (N*(2*M-N+1))/2.
C
C       U IS AN INPUT ARRAY OF LENGTH M WHICH MUST CONTAIN THE
C         VECTOR U.
C
C       V IS AN ARRAY OF LENGTH N. ON INPUT V MUST CONTAIN THE VECTOR
C         V. ON OUTPUT V(I) CONTAINS THE INFORMATION NECESSARY TO
C         RECOVER THE GIVENS ROTATION GV(I) DESCRIBED ABOVE.
C
C       W IS AN OUTPUT ARRAY OF LENGTH M. W(I) CONTAINS INFORMATION
C         NECESSARY TO RECOVER THE GIVENS ROTATION GW(I) DESCRIBED
C         ABOVE.
C
C       SING IS A LOGICAL OUTPUT VARIABLE. SING IS SET TRUE IF ANY
C         OF THE DIAGONAL ELEMENTS OF THE OUTPUT S ARE ZERO. OTHERWISE
C         SING IS SET FALSE.
C
C     SUBPROGRAMS CALLED
C
C       MINPACK-SUPPLIED ... SPMPAR
C
C       FORTRAN-SUPPLIED ... ABS,SQRT
C
C     ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980.
C     BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE,
C     JOHN L. NAZARETH
C
C     **********
      INTEGER I,J,JJ,L,NMJ,NM1
      REAL COS,COTAN,GIANT,ONE,P5,P25,SIN,TAN,TAU,TEMP,ZERO
      REAL SPMPAR
      DATA ONE,P5,P25,ZERO /1.0E0,5.0E-1,2.5E-1,0.0E0/
C
C     GIANT IS THE LARGEST MAGNITUDE.
C
      GIANT = SPMPAR(3)
C
C     INITIALIZE THE DIAGONAL ELEMENT POINTER.
C
      JJ = (N*(2*M - N + 1))/2 - (M - N)
C
C     MOVE THE NONTRIVIAL PART OF THE LAST COLUMN OF S INTO W.
C
      L = JJ
      DO 10 I = N, M
         W(I) = S(L)
         L = L + 1
   10    CONTINUE
C
C     ROTATE THE VECTOR V INTO A MULTIPLE OF THE N-TH UNIT VECTOR
C     IN SUCH A WAY THAT A SPIKE IS INTRODUCED INTO W.
C
      NM1 = N - 1
      IF (NM1 .LT. 1) GO TO 70
      DO 60 NMJ = 1, NM1
         J = N - NMJ
         JJ = JJ - (M - J + 1)
         W(J) = ZERO
         IF (V(J) .EQ. ZERO) GO TO 50
C
C        DETERMINE A GIVENS ROTATION WHICH ELIMINATES THE
C        J-TH ELEMENT OF V.
C
         IF (ABS(V(N)) .GE. ABS(V(J))) GO TO 20
            COTAN = V(N)/V(J)
            SIN = P5/SQRT(P25+P25*COTAN**2)
            COS = SIN*COTAN
            TAU = ONE
            IF (ABS(COS)*GIANT .GT. ONE) TAU = ONE/COS
            GO TO 30
   20    CONTINUE
            TAN = V(J)/V(N)
            COS = P5/SQRT(P25+P25*TAN**2)
            SIN = COS*TAN
            TAU = SIN
   30    CONTINUE
C
C        APPLY THE TRANSFORMATION TO V AND STORE THE INFORMATION
C        NECESSARY TO RECOVER THE GIVENS ROTATION.
C
         V(N) = SIN*V(J) + COS*V(N)
         V(J) = TAU
C
C        APPLY THE TRANSFORMATION TO S AND EXTEND THE SPIKE IN W.
C
         L = JJ
         DO 40 I = J, M
            TEMP = COS*S(L) - SIN*W(I)
            W(I) = SIN*S(L) + COS*W(I)
            S(L) = TEMP
            L = L + 1
   40       CONTINUE
   50    CONTINUE
   60    CONTINUE
   70 CONTINUE
C
C     ADD THE SPIKE FROM THE RANK 1 UPDATE TO W.
C
      DO 80 I = 1, M
         W(I) = W(I) + V(N)*U(I)
   80    CONTINUE
C
C     ELIMINATE THE SPIKE.
C
      SING = .FALSE.
      IF (NM1 .LT. 1) GO TO 140
      DO 130 J = 1, NM1
         IF (W(J) .EQ. ZERO) GO TO 120
C
C        DETERMINE A GIVENS ROTATION WHICH ELIMINATES THE
C        J-TH ELEMENT OF THE SPIKE.
C
         IF (ABS(S(JJ)) .GE. ABS(W(J))) GO TO 90
            COTAN = S(JJ)/W(J)
            SIN = P5/SQRT(P25+P25*COTAN**2)
            COS = SIN*COTAN
            TAU = ONE
            IF (ABS(COS)*GIANT .GT. ONE) TAU = ONE/COS
            GO TO 100
   90    CONTINUE
            TAN = W(J)/S(JJ)
            COS = P5/SQRT(P25+P25*TAN**2)
            SIN = COS*TAN
            TAU = SIN
  100    CONTINUE
C
C        APPLY THE TRANSFORMATION TO S AND REDUCE THE SPIKE IN W.
C
         L = JJ
         DO 110 I = J, M
            TEMP = COS*S(L) + SIN*W(I)
            W(I) = -SIN*S(L) + COS*W(I)
            S(L) = TEMP
            L = L + 1
  110       CONTINUE
C
C        STORE THE INFORMATION NECESSARY TO RECOVER THE
C        GIVENS ROTATION.
C
         W(J) = TAU
  120    CONTINUE
C
C        TEST FOR ZERO DIAGONAL ELEMENTS IN THE OUTPUT S.
C
         IF (S(JJ) .EQ. ZERO) SING = .TRUE.
         JJ = JJ + (M - J + 1)
  130    CONTINUE
  140 CONTINUE
C
C     MOVE W BACK INTO THE LAST COLUMN OF THE OUTPUT S.
C
      L = JJ
      DO 150 I = N, M
         S(L) = W(I)
         L = L + 1
  150    CONTINUE
      IF (S(JJ) .EQ. ZERO) SING = .TRUE.
      RETURN
C
C     LAST CARD OF SUBROUTINE R1UPDT.
C
      END
      SUBROUTINE SMPLX (A,B0,C,KA,M,N0,IND,IBASIS,X,Z,ITER,MXITER,
     *                       NUMLE,NUMGE,BI,WK,IWK)
C-----------------------------------------------------------------------
C     SIMPLEX PROCEDURE FOR SOLVING LINEAR PROGRAMMING PROBLEMS
C-----------------------------------------------------------------------
C     WRITTEN BY ALFRED H. MORRIS JR.
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C------------------------
C     INITIAL VERSION  DEC  1977
C     LAST UPDATE      OCT  1990
C------------------------
      DIMENSION A(KA,N0),B0(M),C(N0)
      DIMENSION IBASIS(M),BI(M,M)
      DIMENSION X(*),WK(*),IWK(*)
C------------------------
C     DIMENSION X(N0+NUMLE+NUMGE)
C     DIMENSION WK(2*M),IWK(2*M+N0)
C------------------------
C
C     ********** EPS0 IS A MACHINE DEPENDENT PARAMETER. ASSIGN EPS0
C                THE VALUE U WHERE U IS THE SMALLEST POSITIVE FLOATING
C                POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0.
C
                          EPS0 = SPMPAR(1)
C
C------------------------
      RERRMN = 10.0*EPS0
      RERRMX = 1.E-4
      IF (EPS0 .LT. 1.E-13) RERRMX = 1.E-5
C
      IP = M + N0 + 1
      CALL SMPLX1(A,B0,C,KA,M,N0,IND,IBASIS,X,Z,ITER,MXITER,
     1            EPS0,RERRMN,RERRMX,RERR,NUMLE,NUMGE,BI,
     2            WK(1),WK(M+1),IWK(1),IWK(IP))
      RETURN
      END
      SUBROUTINE SMPLX1 (A,B0,C,KA,M,N0,IND,IBASIS,R,Z,ITER,MXITER,
     *     EPS0,RERRMN,RERRMX,RERR,NUMLE,NUMGE,BI,XB,Y,BASIS,INDEX)
C----------------------
C     NSTEP = 1   ELIMINATE THE NEGATIVE VARIABLES
C     NSTEP = 2   PHASE 1 OF THE SIMPLEX ALGORITHM
C     NSTEP = 3   PHASE 2 OF THE SIMPLEX ALGORITHM
C----------------------
C     MXITER = THE MAXIMUM NUMBER OF ITERATIONS PERMITTED
C     ITER = THE NUMBER OF THE CURRENT ITERATION
C     ICOUNT = THE NUMBER OF ITERATIONS SINCE THE LAST INVERSION
C----------------------
C     NUMLE = THE NUMBER OF .LE. CONSTRAINTS
C     NUMGE = THE NUMBER OF .GE. CONSTRAINTS
C----------------------
C     THE ROUTINE ASSUMES THAT THE .LE. CONSTRAINTS PRECEDE THE .GE.
C     CONSTRAINTS AND THAT THE .EQ. CONSTRAINTS COME LAST. THERE ARE
C     M CONSTRAINTS. X(N0+I) IS THE SLACK, SURPLUS, OR ARTIFICIAL
C     VARIABLE FOR THE I-TH CONSTRAINT (I=1,...,M).
C----------------------
C     N0 = THE NUMBER OF ORGINAL VARIABLES
C     NS = THE NUMBER OF ORGINAL AND SLACK VARIABLES
C     N  = THE NUMBER OF ORGINAL, SLACK, AND SURPLUS VARIABLES
C     NUM = THE TOTAL NUMBER OF VARIABLES
C----------------------
C     RERRMN = THE SMALLEST RELATIVE ERROR TOLERANCE USED
C     RERRMX = THE LARGEST RELATIVE ERROR TOLERACE USED
C     RERR   = THE ESTIMATED CURRENT RELATIVE ERROR
C----------------------
C     ASSUME THAT
C         B0 = (B0(1),...,B0(M))
C         C  = (C(1),...,C(N0))
C         Z  = C(1)*X(1)+...+C(N0)*X(N0)
C     THE PROBLEM IS TO MAXIMIZE Z SUBJECT TO
C         AX(LE,EQ,GE)B0
C         X.GE.0
C----------------------
C     ON INPUT IND CAN HAVE THE VALUES
C         IND = 0   NO BEGINNING BASIS IS PROVIDED BY THE USER
C         IND = 1   THE ARRAY IBASIS HAS BEEN SET BY THE USER
C     ON OUTPUT IND IS ASSIGNED ONE OF THE VALUES
C         IND = 0   Z WAS SUCCESSFULLY MAXIMIZED
C         IND = 1   THE PROBLEM HAS NO FEASIBLE SOLUTION
C         IND = 2   MXITER ITERATIONS WERE PERFORMED
C         IND = 3   SUFFICIENT ACCURACY CANNOT BE MAINTAINED
C         IND = 4   THE PROBLEM HAS AN UNBOUNDED SOLUTION
C         IND = 5   THERE IS AN INPUT ERROR
C         IND = 6   Z WAS POSSIBLY MAXIMIZED
C----------------------
C     BASIS IS AN INTEGER ARRAY OF DIMENSION N0+M. FOR J.LE.N
C         BASIS(J) = 1  IF X(J) IS A BASIC VARIABLE
C         BASIS(J) = 0  IF X(J) IS NOT A BASIC VARIABLE
C     IF THE BASIC VARIABLES ARE X(I1),...,X(IM) THEN
C         IBASIS = (I1,...,IM)
C     ALSO XB(1),...,XB(M) ARE THE CORRESPONDING VALUES OF THE
C     BASIC VARIABLES.
C----------------------
C     BI IS AN MXM ARRAY CONTAINING THE INVERSE OF THE BASIS MATRIX.
C----------------------
C     R IS AN ARRAY OF DIMENSION N. ON OUTPUT R CONTAINS THE CURRENT
C     VALUE OF X. DURING COMPUTATION R NORMALLY CONTAINS THE REDUCED
C     COSTS USED FOR THE SELECTION OF THE VARIABLE TO BE MADE BASIC.
C----------------------
      REAL A(KA,N0), B0(M), C(N0)
      REAL BI(M,M), XB(M), Y(M), R(*)
      INTEGER IBASIS(M), BASIS(*)
      INTEGER BFLAG, INDEX(M)
      DOUBLE PRECISION DSUM, DSUMP, DSUMN, DT
C----------------------
C
C     ****** XMAX IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
C            LARGEST POSITIVE FLOATING POINT NUMBER.
C
                 XMAX = SPMPAR(3)
C
C----------------------
      ITER = 0
      ICOUNT = 0
      MCHECK = MIN0(5,1 + M/15)
      Z = 0.0
C
C                CHECK FOR INPUT ERRORS
C
      MS = NUMLE + NUMGE
      IF (M .LT. 2 .OR. N0 .LT. 2 .OR. MS .GT. M .OR. KA .LT. M)
     *   GO TO 12
      DO 10 I = 1,M
         IF (B0(I) .LT. 0.0) GO TO 12
   10    XB(I) = 0.0
      RTOL = XMAX
      DO 11 I = 1,N0
         IF (C(I) .NE. 0.0) RTOL = AMIN1(ABS(C(I)),RTOL)
   11 CONTINUE
      RTOL = RERRMX*RTOL
      GO TO 20
C
   12 IND = 5
      RETURN
C
C     FORMATION OF THE IBASIS AND BASIS ARRAYS. (IF IND = 1
C     THEN THE IBASIS ARRAY IS DEFINED BY THE USER.)
C
   20 NS = N0 + NUMLE
      N = NS + NUMGE
      IF (IND .EQ. 0) GO TO 30
      NUM = N
      DO 21 I = 1,M
         IF (IBASIS(I) .GT. N) NUM = NUM + 1
   21 CONTINUE
      GO TO 32
   22 IF (IND .EQ. 0) GO TO 590
      IND = 0
C
   30 NUM = N0 + M
      DO 31 I = 1,M
   31    IBASIS(I) = N0 + I
   32 BFLAG = 0
      DO 33 I = 1,N
   33    BASIS(I) = 0
      DO 34 I = 1,M
         KI = IBASIS(I)
   34    BASIS(KI) = 1
      IF (IND .EQ. 1) GO TO 100
C
C          CALCULATION OF XB AND BI WHEN IND = 0
C
      RERR = RERRMN
      DO 41 J = 1,M
         XB(J) = B0(J)
         DO 40 I = 1,M
   40       BI(I,J) = 0.0
         BI(J,J) = 1.0
   41 CONTINUE
      IF (NUMGE .EQ. 0) GO TO 630
      JMIN = NUMLE + 1
      DO 42 J = JMIN,MS
         XB(J) = -XB(J)
         BI(J,J) = -1.0
   42 CONTINUE
      GO TO 601
C
C                  REORDER THE BASIS
C
  100 IBEG = 1
      IEND = M
      DO 102 I = 1,M
         IF (IBASIS(I) .LE. N0) GO TO 101
            INDEX(IBEG) = IBASIS(I)
            IBEG = IBEG + 1
            GO TO 102
  101    INDEX(IEND) = IBASIS(I)
         IEND = IEND - 1
  102 CONTINUE
      IF (IEND .EQ. M) GO TO 22
      DO 103 I = 1,M
  103    IBASIS(I) = INDEX(I)
C
C            REINVERSION OF THE BASIS MATRIX
C
      DO 132 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .LE. N0) GO TO 110
         IF (KJ .LE. NS) GO TO 120
         IF (KJ .LE. N) GO TO 130
         GO TO 120
C
  110    DO 111 I = 1,M
  111       BI(I,J) = A(I,KJ)
         GO TO 132
C
  120    L = KJ - N0
         DO 121 I = 1,M
  121       BI(I,J) = 0.0
         BI(L,J) = 1.0
         GO TO 132
C
  130    L = KJ - N0
         DO 131 I = 1,M
  131       BI(I,J) = 0.0
         BI(L,J) = -1.0
  132 CONTINUE
C
      ICOUNT = 0
      CALL CROUT1 (BI, M, M, IEND, INDEX, Y, JCOL, IERR)
      IF (IERR .NE. 0) GO TO 580
C
C         CHECK THE ACCURACY OF BI AND RESET RERR
C
      BNORM = 0.0
      DO 142 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .LE. N0) GO TO 140
            SUM = 1.0
            GO TO 142
  140    SUM = 0.0
         DO 141 I = 1,M
  141       SUM = SUM + ABS(A(I,KJ))
  142    BNORM = AMAX1(BNORM,SUM)
C
      BINORM = 0.0
      DO 151 J = 1,M
         SUM = 0.0
         DO 150 I = 1,M
  150       SUM = SUM + ABS(BI(I,J))
         BINORM = AMAX1(BINORM,SUM)
  151 CONTINUE
      RERR = AMAX1(RERRMN,EPS0*BNORM*BINORM)
      IF (RERR .GT. 1.E-2) GO TO 580
      BFLAG = 0
C
C                 RECALCULATION OF XB
C
  180 DO 183 I = 1,M
         DSUMP = 0.D0
         DSUMN = 0.D0
         DO 182 L = 1,M
            DT = BI(I,L)*B0(L)
            IF (DT .GT. 0.D0) GO TO 181
               DSUMN = DSUMN + DT
               GO TO 182
  181       DSUMP = DSUMP + DT
  182    CONTINUE
         XB(I) = DSUMP + DSUMN
         S = DSUMP
         T = DSUMN
         TOL = RERRMX*AMAX1(S,-T)
         IF (ABS(XB(I)) .LT. TOL) XB(I) = 0.0
  183 CONTINUE
      GO TO 601
C
C     FIND THE NEXT VECTOR A(--,JP) TO BE INSERTED INTO
C                       THE BASIS
C
  200 JP = 0
      RMIN = 0.0
      IF (NSTEP .EQ. 3) RMIN = -RTOL
      DO 201 J = 1,N0
         IF (BASIS(J) .NE. 0) GO TO 201
         IF (R(J) .GE. RMIN) GO TO 201
         JP = J
         RMIN = R(J)
  201 CONTINUE
      IF (N0 .EQ. N) GO TO 203
      JMIN = N0 + 1
      RMIN = RMIN*1.1
      DO 202 J = JMIN,N
         IF (BASIS(J) .NE. 0) GO TO 202
         IF (R(J) .GE. RMIN) GO TO 202
         JP = J
         RMIN = R(J)
  202 CONTINUE
  203 IF (JP .NE. 0) GO TO 300
      IF (NSTEP - 2) 800,230,250
C
C     INSERT THE VALUES OF THE ORGINAL, SLACK, AND SURPLUS
C             VARIABLES INTO R. THEN TERMINATE.
C
  220 DO 221 J = 1,N
  221    R(J) = 0.0
      DO 222 I = 1,M
         KI = IBASIS(I)
         IF (KI .LE. N) R(KI) = XB(I)
  222 CONTINUE
      RETURN
C
C             COMPLETION OF THE NSTEP = 2 CASE
C
  230 DO 231 I = 1,M
         IF (IBASIS(I) .LE. N) GO TO 231
         IF (XB(I) .GT. 0.0) GO TO 800
  231 CONTINUE
      GO TO 680
C
  240 IF (ICOUNT .GE. 5) GO TO 100
      IND = 1
      GO TO 220
C
C             COMPLETION OF THE NSTEP = 3 CASE
C
  250 IF (RERR .GT. 1.E-2) GO TO 251
         IND = 0
         GO TO 800
  251 IF (ICOUNT .GE. 5) GO TO 100
      IND = 6
      GO TO 800
C
C     IF MXITER ITERATIONS HAVE NOT BEEN PERFORMED THEN
C     BEGIN THE NEXT ITERATION. COMPUTE THE JP-TH COLUMN
C               OF BI*A AND STORE IT IN Y.
C
  300 IF (ITER .LT. MXITER) GO TO 301
         IND = 2
         GO TO 220
  301 ITER = ITER + 1
      ICOUNT = ICOUNT + 1
      IF (JP .GT. NS) GO TO 330
      IF (JP .GT. N0) GO TO 320
C
      NROW = 0
      AMAX = 0.0
      DO 305 I = 1,M
         IF (A(I,JP) .EQ. 0.0) GO TO 305
         NROW = NROW + 1
         INDEX(NROW) = I
         AMAX = AMAX1(ABS(A(I,JP)),AMAX)
  305 CONTINUE
      IF (NROW .NE. 0) GO TO 310
      IND = 4
      GO TO 220
C
  310 RERR1 = RERRMX*AMAX
      DO 313 I = 1,M
         DSUM = 0.D0
         DO 311 LL = 1,NROW
            L = INDEX(LL)
            DSUM = DSUM + DBLE(BI(I,L)*A(L,JP))
  311    CONTINUE
         Y(I) = DSUM
         IF (ABS(Y(I)) .GE. 5.E-3) GO TO 313
         BMAX = 0.0
         DO 312 L = 1,M
            BMAX = AMAX1(ABS(BI(I,L)),BMAX)
  312    CONTINUE
         TOL = RERR1*BMAX
         IF (ABS(Y(I)) .LT. TOL) Y(I) = 0.0
  313 CONTINUE
      GO TO 350
C
  320 L = JP - N0
      DO 321 I = 1,M
         Y(I) = BI(I,L)
  321 CONTINUE
      GO TO 350
C
  330 L = JP - N0
      DO 331 I = 1,M
         Y(I) = -BI(I,L)
  331 CONTINUE
C
  350 DO 351 I = 1,M
         IF (Y(I) .NE. 0.0) GO TO 360
  351 CONTINUE
      R(JP) = 0.0
      ITER = ITER - 1
      ICOUNT = ICOUNT - 1
      GO TO 200
C
  360 IF (NSTEP - 2) 400,430,440
C
C     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
C               FOR THE NSTEP = 1 CASE
C
  400 NPOS = 0
      IP = 0
      EPS = 0.0
      EPSI = XMAX
      DO 403 I = 1,M
         IF (XB(I) .LT. 0.0 .OR. Y(I) .LE. 0.0) GO TO 403
         RATIO = XB(I)/Y(I)
         IF (RATIO - EPSI) 401,402,403
  401    EPSI = RATIO
         NPOS = 1
         INDEX(1) = I
         GO TO 403
  402    NPOS = NPOS + 1
         INDEX(NPOS) = I
  403 CONTINUE
      IF (NPOS .EQ. 0) GO TO 420
      IF (EPSI .EQ. 0.0) GO TO 460
C
      DO 410 I = 1,M
         IF (XB(I) .GE. 0.0 .OR. Y(I) .GE. 0.0) GO TO 410
         RATIO = XB(I)/Y(I)
         IF (RATIO .GT. EPSI) GO TO 410
         IF (RATIO .LT. EPS) GO TO 410
         EPS = RATIO
         IP = I
  410 CONTINUE
      IF (IP .NE. 0) GO TO 500
      GO TO 460
C
  420 DO 421 I = 1,M
         IF (XB(I) .GE. 0.0 .OR. Y(I) .GE. 0.0) GO TO 421
         RATIO = XB(I)/Y(I)
         IF (RATIO .LT. EPS) GO TO 421
         EPS = RATIO
         IP = I
  421 CONTINUE
      GO TO 500
C
C     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
C               FOR THE NSTEP = 2 CASE
C
  430 NPOS = 0
      EPSI = XMAX
      DO 433 I = 1,M
         IF (Y(I) .LE. 0.0) GO TO 433
         RATIO = XB(I)/Y(I)
         IF (RATIO - EPSI) 431,432,433
  431    EPSI = RATIO
         NPOS = 1
         INDEX(1) = I
         GO TO 433
  432    NPOS = NPOS + 1
         INDEX(NPOS) = I
  433 CONTINUE
      GO TO 450
C
C     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
C               FOR THE NSTEP = 3 CASE
C
  440 NPOS = 0
      EPSI = XMAX
      DO 445 I = 1,M
         IF (Y(I)) 441,445,442
  441    IF (IBASIS(I) .LE. N) GO TO 445
         IP = I
         GO TO 500
  442    RATIO = XB(I)/Y(I)
         IF (RATIO - EPSI) 443,444,445
  443       EPSI = RATIO
            NPOS = 1
            INDEX(1) = I
            GO TO 445
  444       NPOS = NPOS + 1
            INDEX(NPOS) = I
  445 CONTINUE
C
  450 IF (NPOS .NE. 0) GO TO 460
      IF (ICOUNT .GE. 5) GO TO 100
      IND = 4
      GO TO 220
C
C              TIE BREAKING PROCEDURE
C
  460 IP = INDEX(1)
      IF (NPOS .EQ. 1) GO TO 500
      IP = 0
      BMIN = XMAX
      CMIN = XMAX
      DO 464 II = 1,NPOS
         I = INDEX(II)
         L = IBASIS(I)
         IF (L .GT. N0) GO TO 461
            IF (C(L) .LE. 0.0) CMIN = AMIN1(0.0,CMIN)
            IF (C(L) .GT. CMIN) GO TO 464
            IMIN = I
            CMIN = C(L)
            GO TO 464
  461    IF (L .LE. N) GO TO 462
            IP = I
            GO TO 500
  462    LROW = L - N0
         S = B0(LROW)
         IF (LROW .GT. NUMLE) GO TO 463
            IF (S .GT. BMIN) GO TO 464
            IP = I
            BMIN = S
            GO TO 464
  463    S = -S
         BMIN = AMIN1(0.0,BMIN)
         IF (S .GT. BMIN) GO TO 464
         IP = I
         BMIN = S
  464 CONTINUE
      IF (CMIN .LE. 0.0 .OR. IP .EQ. 0) IP = IMIN
C
C               TRANSFORMATION OF XB
C
  500 IF (XB(IP) .EQ. 0.0) GO TO 510
      CONST = XB(IP)/Y(IP)
      DO 501 I = 1,M
         S = XB(I)
         XB(I) = XB(I) - CONST*Y(I)
         IF (XB(I) .GE. 0.0) GO TO 501
         IF (S .GE. 0.0 .OR. XB(I) .GE. RERRMX*S) XB(I) = 0.0
  501 CONTINUE
      XB(IP) = CONST
C
C               TRANSFORMATION OF BI
C
  510 DO 512 J = 1,M
         IF (BI(IP,J) .EQ. 0.0) GO TO 512
         CONST = BI(IP,J)/Y(IP)
         DO 511 I = 1,M
  511       BI(I,J) = BI(I,J) - CONST*Y(I)
         BI(IP,J) = CONST
  512 CONTINUE
C
C             UPDATING IBASIS AND BASIS
C
      IOUT = IBASIS(IP)
      IBASIS(IP) = JP
      BASIS(IOUT) = 0
      BASIS(JP) = 1
      IF (IOUT .GT. N) NUM = NUM - 1
C
C        CHECK THE ACCURACY OF BI AND RESET RERR
C
      IF (RERR .GT. 1.E-2) GO TO 530
      K = 0
      DO 521 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .GT. N0) GO TO 521
         SUM = 0.0
         DO 520 L = 1,M
            IF (A(L,KJ) .NE. 0.0) SUM = SUM + BI(J,L)*A(L,KJ)
  520    CONTINUE
         RERR = AMAX1(RERR,ABS(1.0 - SUM))
         K = K + 1
         IF (K .GE. MCHECK) GO TO 522
  521 CONTINUE
  522 IF (RERR .LE. 1.E-2) GO TO 600
C
C        THE ACCURACY CRITERIA ARE NOT SATISFIED
C
  530 IF (ICOUNT .LT. 5) GO TO 600
      BFLAG = 1
      GO TO 100
C
  580 IF (ITER .EQ. 0) GO TO 12
      IF (BFLAG .EQ. 0) GO TO 590
      BFLAG = 0
      DO 581 IP = 1,M
         IF (JP .EQ. IBASIS(IP)) GO TO 582
  581 CONTINUE
  582 IBASIS(IP) = IOUT
      BASIS(JP) = 0
      BASIS(IOUT) = 1
      IF (IOUT .GT. N) NUM = NUM + 1
      GO TO 100
C
  590 IND = 3
      GO TO 220
C
C       SET UP THE R ARRAY FOR THE NSTEP = 1 CASE
C
  600 IF (NSTEP - 2) 601,630,700
  601 DO 602 J = 1,M
         IF (XB(J) .LT. 0.0) GO TO 610
  602 CONTINUE
      GO TO 630
C
  610 NSTEP = 1
      M0 = 0
      DO 611 L = 1,M
         IF (XB(L) .GE. 0.0) GO TO 611
         M0 = M0 + 1
         INDEX(M0) = L
  611 CONTINUE
C
      DO 623 J = 1,M
         DSUMP = 0.D0
         DSUMN = 0.D0
         DO 622 LL = 1,M0
            L = INDEX(LL)
            IF (BI(L,J)) 620,622,621
  620       DSUMN = DSUMN + DBLE(BI(L,J))
            GO TO 622
  621       DSUMP = DSUMP + DBLE(BI(L,J))
  622    CONTINUE
         Y(J) = DSUMP + DSUMN
         S = DSUMP
         T = DSUMN
         TOL = RERRMX*AMAX1(S,-T)
         IF (ABS(Y(J)) .LT. TOL) Y(J) = 0.0
  623 CONTINUE
      GO TO 650
C
C       SET UP THE R ARRAY FOR THE NSTEP = 2 CASE
C
  630 IF (N .EQ. NUM) GO TO 680
      NSTEP = 2
      M0 = 0
      DO 631 L = 1,M
         IF (IBASIS(L) .LE. N) GO TO 631
         M0 = M0 + 1
         INDEX(M0) = L
  631 CONTINUE
C
      DO 643 J = 1,M
         DSUMP = 0.D0
         DSUMN = 0.D0
         DO 642 LL = 1,M0
            L = INDEX(LL)
            IF (BI(L,J)) 640,642,641
  640       DSUMN = DSUMN + DBLE(BI(L,J))
            GO TO 642
  641       DSUMP = DSUMP + DBLE(BI(L,J))
  642    CONTINUE
         Y(J) = -(DSUMP + DSUMN)
         S = DSUMP
         T = DSUMN
         TOL = RERRMX*AMAX1(S,-T)
         IF (ABS(Y(J)) .LT. TOL) Y(J) = 0.0
  643 CONTINUE
C
  650 DO 652 J = 1,N0
         SUM = 0.0
         IF (BASIS(J) .NE. 0) GO TO 652
         DO 651 L = 1,M
            IF (A(L,J) .NE. 0.0) SUM = SUM + Y(L)*A(L,J)
  651    CONTINUE
  652    R(J) = SUM
C
  660 IF (N0 .EQ. NS) GO TO 670
      JMIN = N0 + 1
      DO 661 J = JMIN,NS
         R(J) = 0.0
         IF (BASIS(J) .NE. 0) GO TO 661
         JJ = J - N0
         R(J) = Y(JJ)
  661 CONTINUE
C
  670 IF (NS .EQ. N) GO TO 200
      JMIN = NS + 1
      DO 671 J = JMIN,N
         R(J) = 0.0
         IF (BASIS(J) .NE. 0) GO TO 671
         JJ = J - N0
         R(J) = -Y(JJ)
  671 CONTINUE
      GO TO 200
C
C      SET UP A NEW R ARRAY FOR THE NSTEP = 3 CASE
C
  680 NSTEP = 3
      DO 682 J = 1,M
         DSUM = 0.D0
         DO 681 L = 1,M
            IL = IBASIS(L)
            IF (IL .LE. N0) DSUM = DSUM + DBLE(C(IL)*BI(L,J))
  681    CONTINUE
  682    Y(J) = DSUM
C
      DO 691 J = 1,N0
         R(J) = 0.0
         IF (BASIS(J) .NE. 0) GO TO 691
         DSUM = -C(J)
         DO 690 L = 1,M
            IF (A(L,J) .NE. 0.0) DSUM = DSUM + DBLE(Y(L)*A(L,J))
  690    CONTINUE
         R(J) = DSUM
         IF (R(J) .GE. 0.0) GO TO 691
         TOL = RERRMX*ABS(C(J))
         IF (ABS(R(J)) .LT. TOL) R(J) = 0.0
  691 CONTINUE
      GO TO 660
C
C       UPDATE THE R ARRAY FOR THE NSTEP = 3 CASE
C
  700 CONST = R(JP)
      DO 703 J = 1,N0
         IF (BASIS(J) .EQ. 0) GO TO 701
            R(J) = 0.0
            GO TO 703
  701    SUM = 0.0
         DO 702 L = 1,M
            IF (A(L,J) .NE. 0.0) SUM = SUM + BI(IP,L)*A(L,J)
  702    CONTINUE
         R(J) = R(J) - CONST*SUM
         IF (R(J) .GE. 0.0) GO TO 703
         TOL = RERRMX*ABS(C(J))
         IF (ABS(R(J)) .LT. TOL) R(J) = 0.0
  703 CONTINUE
C
  710 IF (N0 .EQ. NS) GO TO 720
      JMIN = N0 + 1
      DO 712 J = JMIN,NS
         IF (BASIS(J) .EQ. 0) GO TO 711
            R(J) = 0.0
            GO TO 712
  711    JJ = J - N0
         R(J) = R(J) - CONST*BI(IP,JJ)
  712 CONTINUE
C
  720 IF (NS .EQ. N) GO TO 200
      JMIN = NS + 1
      DO 722 J = JMIN,N
         IF (BASIS(J) .EQ. 0) GO TO 721
            R(J) = 0.0
            GO TO 722
  721    JJ = J - N0
         R(J) = R(J) + CONST*BI(IP,JJ)
  722 CONTINUE
      GO TO 200
C-----------------------------------------------------------------------
C               REFINE XB AND STORE THE RESULT IN Y
C-----------------------------------------------------------------------
  800 DO 801 I = 1,M
         Y(I) = 0.0
  801 CONTINUE
C
      M0 = 0
      DO 831 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .LE. N0) GO TO 810
         IF (KJ .LE. NS) GO TO 820
         IF (KJ .LE. N) GO TO 830
         GO TO 820
C
  810    M0 = M0 + 1
         INDEX(M0) = J
         GO TO 831
C
  820    L = KJ - N0
         Y(L) = XB(J)
         GO TO 831
C
  830    L = KJ - N0
         Y(L) = -XB(J)
  831 CONTINUE
C
      IF (M0 .NE. 0) GO TO 841
         DO 840 I = 1,M
  840       R(I) = B0(I) - Y(I)
         GO TO 850
  841 DO 843 I = 1,M
         DSUM = Y(I)
         DO 842 JJ = 1,M0
            J = INDEX(JJ)
            KJ = IBASIS(J)
            DSUM = DSUM + DBLE(A(I,KJ)*XB(J))
  842    CONTINUE
         R(I) = B0(I) - DSUM
  843 CONTINUE
C
  850 RERR1 = AMIN1(RERRMX,RERR)
      DO 856 I = 1,M
         Y(I) = 0.0
         IF (XB(I)) 851,856,852
  851    SGN = -1.0
         DSUMP = 0.D0
         DSUMN = XB(I)
         GO TO 853
  852    SGN = 1.0
         DSUMP = XB(I)
         DSUMN = 0.D0
  853    DO 855 L = 1,M
            DT = BI(I,L)*R(L)
            IF (DT .GT. 0.D0) GO TO 854
               DSUMN = DSUMN + DT
               GO TO 855
  854       DSUMP = DSUMP + DT
  855    CONTINUE
         W = DSUMP + DSUMN
         IF (W .EQ. 0.0) GO TO 856
         IF (SGN .NE. SIGN(1.0,W)) GO TO 856
         S = DSUMP
         T = DSUMN
         TOL = RERR1*AMAX1(S,-T)
         IF (ABS(W) .GT. TOL) Y(I) = W
  856 CONTINUE
      IF (NSTEP - 2) 860,870,880
C
C         CHECK THE REFINEMENT (NSTEP = 1)
C
  860 DO 861 I = 1,M
         IF (Y(I) .GE. 0.0) GO TO 861
         IF (Y(I) .LT. -RERRMX) GO TO 240
         Y(I) = 0.0
  861    XB(I) = Y(I)
      GO TO 630
C
C         CHECK THE REFINEMENT (NSTEP = 2)
C
  870 DO 871 I = 1,M
         IF (IBASIS(I) .LE. N) GO TO 871
         IF (Y(I) .GT. RERRMX) GO TO 240
         Y(I) = 0.0
  871    XB(I) = Y(I)
      GO TO 680
C
C              COMPUTE Z  (NSTEP = 3)
C
  880 DSUM = 0.D0
      DO 881 I = 1,M
         KI = IBASIS(I)
         IF (KI .GT. N0) GO TO 881
         DSUM = DSUM + DBLE(C(KI)*Y(I))
  881    XB(I) = Y(I)
      Z = DSUM
      GO TO 220
      END
      SUBROUTINE SSPLX (TA,ITA,JTA,B0,C,M,N0,IND,IBASIS,X,Z,ITER,MXITER,
     *                       NUMLE,NUMGE,BI,WK,IWK)
C-----------------------------------------------------------------------
C     SIMPLEX PROCEDURE FOR SOLVING LINEAR PROGRAMMING PROBLEMS
C-----------------------------------------------------------------------
C     WRITTEN BY ALFRED H. MORRIS JR.
C        NAVAL SURFACE WEAPONS CENTER
C        DAHLGREN, VIRGINIA
C------------------------
C     INITIAL VERSION  DEC  1977
C     LAST UPDATE      OCT  1990
C------------------------
      DIMENSION TA(*),ITA(*),JTA(*)
      DIMENSION B0(M),C(N0)
      DIMENSION IBASIS(M),BI(M,M)
      DIMENSION X(*),WK(*),IWK(*)
C------------------------
C     DIMENSION X(N0+NUMLE+NUMGE)
C     DIMENSION WK(2*M),IWK(2*M+N0)
C------------------------
C
C     ********** EPS0 IS A MACHINE DEPENDENT PARAMETER. ASSIGN EPS0
C                THE VALUE U WHERE U IS THE SMALLEST POSITIVE FLOATING
C                POINT NUMBER SUCH THAT 1.0 + U .GT. 1.0.
C
                          EPS0 = SPMPAR(1)
C
C------------------------
      RERRMN = 10.0*EPS0
      RERRMX = 1.E-4
      IF (EPS0 .LT. 1.E-13) RERRMX = 1.E-5
C
      IP = M + N0 + 1
      CALL SSPLX1(TA,ITA,JTA,B0,C,M,N0,IND,IBASIS,X,Z,ITER,MXITER,
     1            EPS0,RERRMN,RERRMX,RERR,NUMLE,NUMGE,BI,
     2            WK(1),WK(M+1),IWK(1),IWK(IP))
      RETURN
      END
      SUBROUTINE SSPLX1 (TA,ITA,JTA,B0,C,M,N0,IND,IBASIS,R,Z,
     1       ITER,MXITER,EPS0,RERRMN,RERRMX,RERR,NUMLE,NUMGE,
     2       BI,XB,Y,BASIS,INDEX)
C----------------------
C     NSTEP = 1   ELIMINATE THE NEGATIVE VARIABLES
C     NSTEP = 2   PHASE 1 OF THE SIMPLEX ALGORITHM
C     NSTEP = 3   PHASE 2 OF THE SIMPLEX ALGORITHM
C----------------------
C     MXITER = THE MAXIMUM NUMBER OF ITERATIONS PERMITTED
C     ITER = THE NUMBER OF THE CURRENT ITERATION
C     ICOUNT = THE NUMBER OF ITERATIONS SINCE THE LAST INVERSION
C----------------------
C     NUMLE = THE NUMBER OF .LE. CONSTRAINTS
C     NUMGE = THE NUMBER OF .GE. CONSTRAINTS
C----------------------
C     THE ROUTINE ASSUMES THAT THE .LE. CONSTRAINTS PRECEDE THE .GE.
C     CONSTRAINTS AND THAT THE .EQ. CONSTRAINTS COME LAST. THERE ARE
C     M CONSTRAINTS. X(N0+I) IS THE SLACK, SURPLUS, OR ARTIFICIAL
C     VARIABLE FOR THE I-TH CONSTRAINT (I=1,...,M).
C----------------------
C     N0 = THE NUMBER OF ORGINAL VARIABLES
C     NS = THE NUMBER OF ORGINAL AND SLACK VARIABLES
C     N  = THE NUMBER OF ORGINAL, SLACK, AND SURPLUS VARIABLES
C     NUM = THE TOTAL NUMBER OF VARIABLES
C----------------------
C     RERRMN = THE SMALLEST RELATIVE ERROR TOLERANCE USED
C     RERRMX = THE LARGEST RELATIVE ERROR TOLERANCE USED
C     RERR   = THE ESTIMATED CURRENT RELATIVE ERROR
C----------------------
C     LET A DENOTE AN MXN0 MATRIX. THE TRANSPOSE OF A IS STORED IN
C     SPARSE FORM IN TA,ITA,JTA. ASSUME THAT
C         B0 = (B0(1),...,B0(M))
C         C  = (C(1),...,C(N0))
C         Z  = C(1)*X(1)+...+C(N0)*X(N0)
C     THE PROBLEM IS TO MAXIMIZE Z SUBJECT TO
C         AX(LE,EQ,GE)B0
C         X.GE.0
C----------------------
C     ON INPUT IND CAN HAVE THE VALUES
C         IND = 0   NO BEGINNING BASIS IS PROVIDED BY THE USER
C         IND = 1   THE ARRAY IBASIS HAS BEEN SET BY THE USER
C     ON OUTPUT IND IS ASSIGNED ONE OF THE VALUES
C         IND = 0   Z WAS SUCCESSFULLY MAXIMIZED
C         IND = 1   THE PROBLEM HAS NO FEASIBLE SOLUTION
C         IND = 2   MXITER ITERATIONS WERE PERFORMED
C         IND = 3   SUFFICIENT ACCURACY CANNOT BE MAINTAINED
C         IND = 4   THE PROBLEM HAS AN UNBOUNDED SOLUTION
C         IND = 5   THERE IS AN INPUT ERROR
C         IND = 6   Z WAS POSSIBLY MAXIMIZED
C----------------------
C     BASIS IS AN INTEGER ARRAY OF DIMENSION N0+M. FOR J.LE.N
C         BASIS(J) = 1  IF X(J) IS A BASIC VARIABLE
C         BASIS(J) = 0  IF X(J) IS NOT A BASIC VARIABLE
C     IF THE BASIC VARIABLES ARE X(I1),...,X(IM) THEN
C         IBASIS = (I1,...,IM)
C     ALSO XB(1),...,XB(M) ARE THE CORRESPONDING VALUES OF THE
C     BASIC VARIABLES.
C----------------------
C     BI IS AN MXM ARRAY CONTAINING THE INVERSE OF THE BASIS MATRIX.
C----------------------
C     R IS AN ARRAY OF DIMENSION N. ON OUTPUT R CONTAINS THE CURRENT
C     VALUE OF X. DURING COMPUTATION R NORMALLY CONTAINS THE REDUCED
C     COSTS USED FOR THE SELECTION OF THE VARIABLE TO BE MADE BASIC.
C----------------------
      REAL TA(*), B0(M), C(N0)
      REAL BI(M,M), XB(M), Y(M), R(*)
      INTEGER ITA(*), JTA(*)
      INTEGER IBASIS(M), BASIS(*)
      INTEGER BFLAG, INDEX(M)
      DOUBLE PRECISION DSUM, DSUMP, DSUMN, DT
C----------------------
C
C     ****** XMAX IS A MACHINE DEPENDENT CONSTANT. XMAX IS THE
C            LARGEST POSITIVE FLOATING POINT NUMBER.
C
                 XMAX = SPMPAR(3)
C
C----------------------
      ITER = 0
      ICOUNT = 0
      MCHECK = MIN0(5,1 + M/15)
      Z = 0.0
C
C                CHECK FOR INPUT ERRORS
C
      MS = NUMLE + NUMGE
      IF (M .LT. 2 .OR. N0 .LT. 2 .OR. MS .GT. M) GO TO 12
      DO 10 I = 1,M
         IF (B0(I) .LT. 0.0) GO TO 12
   10    XB(I) = 0.0
      RTOL = XMAX
      DO 11 I = 1,N0
         IF (C(I) .NE. 0.0) RTOL = AMIN1(ABS(C(I)),RTOL)
   11 CONTINUE
      RTOL = RERRMX*RTOL
      GO TO 20
C
   12 IND = 5
      RETURN
C
C     FORMATION OF THE IBASIS AND BASIS ARRAYS. (IF IND = 1
C     THEN THE IBASIS ARRAY IS DEFINED BY THE USER.)
C
   20 NS = N0 + NUMLE
      N = NS + NUMGE
      IF (IND .EQ. 0) GO TO 30
      NUM = N
      DO 21 I = 1,M
         IF (IBASIS(I) .GT. N) NUM = NUM + 1
   21 CONTINUE
      GO TO 32
   22 IF (IND .EQ. 0) GO TO 590
      IND = 0
C
   30 NUM = N0 + M
      DO 31 I = 1,M
   31    IBASIS(I) = N0 + I
   32 BFLAG = 0
      DO 33 I = 1,N
   33    BASIS(I) = 0
      DO 34 I = 1,M
         KI = IBASIS(I)
   34    BASIS(KI) = 1
      IF (IND .EQ. 1) GO TO 100
C
C          CALCULATION OF XB AND BI WHEN IND = 0
C
      RERR = RERRMN
      DO 41 J = 1,M
         XB(J) = B0(J)
         DO 40 I = 1,M
   40       BI(I,J) = 0.0
         BI(J,J) = 1.0
   41 CONTINUE
      IF (NUMGE .EQ. 0) GO TO 630
      JMIN = NUMLE + 1
      DO 42 J = JMIN,MS
         XB(J) = -XB(J)
         BI(J,J) = -1.0
   42 CONTINUE
      GO TO 601
C
C                  REORDER THE BASIS
C
  100 IBEG = 1
      IEND = M
      DO 102 I = 1,M
         IF (IBASIS(I) .LE. N0) GO TO 101
            INDEX(IBEG) = IBASIS(I)
            IBEG = IBEG + 1
            GO TO 102
  101    INDEX(IEND) = IBASIS(I)
         IEND = IEND - 1
  102 CONTINUE
      IF (IEND .EQ. M) GO TO 22
      DO 103 I = 1,M
  103    IBASIS(I) = INDEX(I)
C
C            REINVERSION OF THE BASIS MATRIX
C
      DO 132 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .LE. N0) GO TO 110
         IF (KJ .LE. NS) GO TO 120
         IF (KJ .LE. N) GO TO 130
         GO TO 120
C
  110    DO 111 I = 1,M
  111       BI(I,J) = 0.0
         LMIN = ITA(KJ)
         LMAX = ITA(KJ + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 132
         DO 112 LL = LMIN,LMAX
            L = JTA(LL)
  112       BI(L,J) = TA(LL)
         GO TO 132
C
  120    L = KJ - N0
         DO 121 I = 1,M
  121       BI(I,J) = 0.0
         BI(L,J) = 1.0
         GO TO 132
C
  130    L = KJ - N0
         DO 131 I = 1,M
  131       BI(I,J) = 0.0
         BI(L,J) = -1.0
  132 CONTINUE
C
      ICOUNT = 0
      CALL CROUT1 (BI, M, M, IEND, INDEX, Y, JCOL, IERR)
      IF (IERR .NE. 0) GO TO 580
C
C         CHECK THE ACCURACY OF BI AND RESET RERR
C
      BNORM = 0.0
      DO 142 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .LE. N0) GO TO 140
            SUM = 1.0
            GO TO 142
  140    SUM = 0.0
         LMIN = ITA(KJ)
         LMAX = ITA(KJ + 1) - 1
         DO 141 LL = LMIN,LMAX
  141       SUM = SUM + ABS(TA(LL))
  142    BNORM = AMAX1(BNORM,SUM)
C
      BINORM = 0.0
      DO 151 J = 1,M
         SUM = 0.0
         DO 150 I = 1,M
  150       SUM = SUM + ABS(BI(I,J))
         BINORM = AMAX1(BINORM,SUM)
  151 CONTINUE
      RERR = AMAX1(RERRMN,EPS0*BNORM*BINORM)
      IF (RERR .GT. 1.E-2) GO TO 580
      BFLAG = 0
C
C                 RECALCULATION OF XB
C
  180 DO 183 I = 1,M
         DSUMP = 0.D0
         DSUMN = 0.D0
         DO 182 L = 1,M
            DT = BI(I,L)*B0(L)
            IF (DT .GT. 0.D0) GO TO 181
               DSUMN = DSUMN + DT
               GO TO 182
  181       DSUMP = DSUMP + DT
  182    CONTINUE
         XB(I) = DSUMP + DSUMN
         S = DSUMP
         T = DSUMN
         TOL = RERRMX*AMAX1(S,-T)
         IF (ABS(XB(I)) .LT. TOL) XB(I) = 0.0
  183 CONTINUE
      GO TO 601
C
C     FIND THE NEXT VECTOR A(--,JP) TO BE INSERTED INTO
C                       THE BASIS
C
  200 JP = 0
      RMIN = 0.0
      IF (NSTEP .EQ. 3) RMIN = -RTOL
      DO 201 J = 1,N0
         IF (BASIS(J) .NE. 0) GO TO 201
         IF (R(J) .GE. RMIN) GO TO 201
         JP = J
         RMIN = R(J)
  201 CONTINUE
      IF (N0 .EQ. N) GO TO 203
      JMIN = N0 + 1
      RMIN = RMIN*1.1
      DO 202 J = JMIN,N
         IF (BASIS(J) .NE. 0) GO TO 202
         IF (R(J) .GE. RMIN) GO TO 202
         JP = J
         RMIN = R(J)
  202 CONTINUE
  203 IF (JP .NE. 0) GO TO 300
      IF (NSTEP - 2) 800,230,250
C
C     INSERT THE VALUES OF THE ORGINAL, SLACK, AND SURPLUS
C             VARIABLES INTO R. THEN TERMINATE.
C
  220 DO 221 J = 1,N
  221    R(J) = 0.0
      DO 222 I = 1,M
         KI = IBASIS(I)
         IF (KI .LE. N) R(KI) = XB(I)
  222 CONTINUE
      RETURN
C
C             COMPLETION OF THE NSTEP = 2 CASE
C
  230 DO 231 I = 1,M
         IF (IBASIS(I) .LE. N) GO TO 231
         IF (XB(I) .GT. 0.0) GO TO 800
  231 CONTINUE
      GO TO 680
C
  240 IF (ICOUNT .GE. 5) GO TO 100
      IND = 1
      GO TO 220
C
C             COMPLETION OF THE NSTEP = 3 CASE
C
  250 IF (RERR .GT. 1.E-2) GO TO 251
         IND = 0
         GO TO 800
  251 IF (ICOUNT .GE. 5) GO TO 100
      IND = 6
      GO TO 800
C
C     IF MXITER ITERATIONS HAVE NOT BEEN PERFORMED THEN
C     BEGIN THE NEXT ITERATION. COMPUTE THE JP-TH COLUMN
C               OF BI*A AND STORE IT IN Y.
C
  300 IF (ITER .LT. MXITER) GO TO 301
         IND = 2
         GO TO 220
  301 ITER = ITER + 1
      ICOUNT = ICOUNT + 1
      IF (JP .GT. NS) GO TO 330
      IF (JP .GT. N0) GO TO 320
C
      LMIN = ITA(JP)
      LMAX = ITA(JP + 1) - 1
      IF (LMIN .LE. LMAX) GO TO 305
         IND = 4
         GO TO 220
  305 AMAX = 0.0
      DO 306 LL = LMIN,LMAX
         AMAX = AMAX1(ABS(TA(LL)),AMAX)
  306 CONTINUE
C
  310 RERR1 = RERRMX*AMAX
      DO 313 I = 1,M
         DSUM = 0.D0
         DO 311 LL = LMIN,LMAX
            L = JTA(LL)
            DSUM = DSUM + DBLE(BI(I,L)*TA(LL))
  311    CONTINUE
         Y(I) = DSUM
         IF (ABS(Y(I)) .GE. 5.E-3) GO TO 313
         BMAX = 0.0
         DO 312 L = 1,M
            BMAX = AMAX1(ABS(BI(I,L)),BMAX)
  312    CONTINUE
         TOL = RERR1*BMAX
         IF (ABS(Y(I)) .LT. TOL) Y(I) = 0.0
  313 CONTINUE
      GO TO 350
C
  320 L = JP - N0
      DO 321 I = 1,M
         Y(I) = BI(I,L)
  321 CONTINUE
      GO TO 350
C
  330 L = JP - N0
      DO 331 I = 1,M
         Y(I) = -BI(I,L)
  331 CONTINUE
C
  350 DO 351 I = 1,M
         IF (Y(I) .NE. 0.0) GO TO 360
  351 CONTINUE
      R(JP) = 0.0
      ITER = ITER - 1
      ICOUNT = ICOUNT - 1
      GO TO 200
C
  360 IF (NSTEP - 2) 400,430,440
C
C     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
C               FOR THE NSTEP = 1 CASE
C
  400 NPOS = 0
      IP = 0
      EPS = 0.0
      EPSI = XMAX
      DO 403 I = 1,M
         IF (XB(I) .LT. 0.0 .OR. Y(I) .LE. 0.0) GO TO 403
         RATIO = XB(I)/Y(I)
         IF (RATIO - EPSI) 401,402,403
  401    EPSI = RATIO
         NPOS = 1
         INDEX(1) = I
         GO TO 403
  402    NPOS = NPOS + 1
         INDEX(NPOS) = I
  403 CONTINUE
      IF (NPOS .EQ. 0) GO TO 420
      IF (EPSI .EQ. 0.0) GO TO 460
C
      DO 410 I = 1,M
         IF (XB(I) .GE. 0.0 .OR. Y(I) .GE. 0.0) GO TO 410
         RATIO = XB(I)/Y(I)
         IF (RATIO .GT. EPSI) GO TO 410
         IF (RATIO .LT. EPS) GO TO 410
         EPS = RATIO
         IP = I
  410 CONTINUE
      IF (IP .NE. 0) GO TO 500
      GO TO 460
C
  420 DO 421 I = 1,M
         IF (XB(I) .GE. 0.0 .OR. Y(I) .GE. 0.0) GO TO 421
         RATIO = XB(I)/Y(I)
         IF (RATIO .LT. EPS) GO TO 421
         EPS = RATIO
         IP = I
  421 CONTINUE
      GO TO 500
C
C     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
C               FOR THE NSTEP = 2 CASE
C
  430 NPOS = 0
      EPSI = XMAX
      DO 433 I = 1,M
         IF (Y(I) .LE. 0.0) GO TO 433
         RATIO = XB(I)/Y(I)
         IF (RATIO - EPSI) 431,432,433
  431    EPSI = RATIO
         NPOS = 1
         INDEX(1) = I
         GO TO 433
  432    NPOS = NPOS + 1
         INDEX(NPOS) = I
  433 CONTINUE
      GO TO 450
C
C     FINDING THE VARIABLE XB(IP) TO BE MADE NONBASIC
C               FOR THE NSTEP = 3 CASE
C
  440 NPOS = 0
      EPSI = XMAX
      DO 445 I = 1,M
         IF (Y(I)) 441,445,442
  441    IF (IBASIS(I) .LE. N) GO TO 445
         IP = I
         GO TO 500
  442    RATIO = XB(I)/Y(I)
         IF (RATIO - EPSI) 443,444,445
  443       EPSI = RATIO
            NPOS = 1
            INDEX(1) = I
            GO TO 445
  444       NPOS = NPOS + 1
            INDEX(NPOS) = I
  445 CONTINUE
C
  450 IF (NPOS .NE. 0) GO TO 460
      IF (ICOUNT .GE. 5) GO TO 100
      IND = 4
      GO TO 220
C
C              TIE BREAKING PROCEDURE
C
  460 IP = INDEX(1)
      IF (NPOS .EQ. 1) GO TO 500
      IP = 0
      BMIN = XMAX
      CMIN = XMAX
      DO 464 II = 1,NPOS
         I = INDEX(II)
         L = IBASIS(I)
         IF (L .GT. N0) GO TO 461
            IF (C(L) .LE. 0.0) CMIN = AMIN1(0.0,CMIN)
            IF (C(L) .GT. CMIN) GO TO 464
            IMIN = I
            CMIN = C(L)
            GO TO 464
  461    IF (L .LE. N) GO TO 462
            IP = I
            GO TO 500
  462    LROW = L - N0
         S = B0(LROW)
         IF (LROW .GT. NUMLE) GO TO 463
            IF (S .GT. BMIN) GO TO 464
            IP = I
            BMIN = S
            GO TO 464
  463    S = -S
         BMIN = AMIN1(0.0,BMIN)
         IF (S .GT. BMIN) GO TO 464
         IP = I
         BMIN = S
  464 CONTINUE
      IF (CMIN .LE. 0.0 .OR. IP .EQ. 0) IP = IMIN
C
C               TRANSFORMATION OF XB
C
  500 IF (XB(IP) .EQ. 0.0) GO TO 510
      CONST = XB(IP)/Y(IP)
      DO 501 I = 1,M
         S = XB(I)
         XB(I) = XB(I) - CONST*Y(I)
         IF (XB(I) .GE. 0.0) GO TO 501
         IF (S .GE. 0.0 .OR. XB(I) .GE. RERRMX*S) XB(I) = 0.0
  501 CONTINUE
      XB(IP) = CONST
C
C               TRANSFORMATION OF BI
C
  510 DO 512 J = 1,M
         IF (BI(IP,J) .EQ. 0.0) GO TO 512
         CONST = BI(IP,J)/Y(IP)
         DO 511 I = 1,M
  511       BI(I,J) = BI(I,J) - CONST*Y(I)
         BI(IP,J) = CONST
  512 CONTINUE
C
C             UPDATING IBASIS AND BASIS
C
      IOUT = IBASIS(IP)
      IBASIS(IP) = JP
      BASIS(IOUT) = 0
      BASIS(JP) = 1
      IF (IOUT .GT. N) NUM = NUM - 1
C
C        CHECK THE ACCURACY OF BI AND RESET RERR
C
      IF (RERR .GT. 1.E-2) GO TO 530
      K = 0
      DO 521 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .GT. N0) GO TO 521
         SUM = 0.0
         LMIN = ITA(KJ)
         LMAX = ITA(KJ + 1) - 1
         DO 520 LL = LMIN,LMAX
            L = JTA(LL)
            SUM = SUM + BI(J,L)*TA(LL)
  520    CONTINUE
         RERR = AMAX1(RERR,ABS(1.0-SUM))
         K = K + 1
         IF (K .GE. MCHECK) GO TO 522
  521 CONTINUE
  522 IF (RERR .LE. 1.E-2) GO TO 600
C
C        THE ACCURACY CRITERIA ARE NOT SATISFIED
C
  530 IF (ICOUNT .LT. 5) GO TO 600
      BFLAG = 1
      GO TO 100
C
  580 IF (ITER .EQ. 0) GO TO 12
      IF (BFLAG .EQ. 0) GO TO 590
      BFLAG = 0
      DO 581 IP = 1,M
         IF (JP .EQ. IBASIS(IP)) GO TO 582
  581 CONTINUE
  582 IBASIS(IP) = IOUT
      BASIS(JP) = 0
      BASIS(IOUT) = 1
      IF (IOUT .GT. N) NUM = NUM + 1
      GO TO 100
C
  590 IND = 3
      GO TO 220
C
C       SET UP THE R ARRAY FOR THE NSTEP = 1 CASE
C
  600 IF (NSTEP - 2) 601,630,700
  601 DO 602 J = 1,M
         IF (XB(J) .LT. 0.0) GO TO 610
  602 CONTINUE
      GO TO 630
C
  610 NSTEP = 1
      M0 = 0
      DO 611 L = 1,M
         IF (XB(L) .GE. 0.0) GO TO 611
         M0 = M0 + 1
         INDEX(M0) = L
  611 CONTINUE
C
      DO 623 J = 1,M
         DSUMP = 0.D0
         DSUMN = 0.D0
         DO 622 LL = 1,M0
            L = INDEX(LL)
            IF (BI(L,J)) 620,622,621
  620       DSUMN = DSUMN + DBLE(BI(L,J))
            GO TO 622
  621       DSUMP = DSUMP + DBLE(BI(L,J))
  622    CONTINUE
         Y(J) = DSUMP + DSUMN
         S = DSUMP
         T = DSUMN
         TOL = RERRMX*AMAX1(S,-T)
         IF (ABS(Y(J)) .LT. TOL) Y(J) = 0.0
  623 CONTINUE
      GO TO 650
C
C       SET UP THE R ARRAY FOR THE NSTEP = 2 CASE
C
  630 IF (N .EQ. NUM) GO TO 680
      NSTEP = 2
      M0 = 0
      DO 631 L = 1,M
         IF (IBASIS(L) .LE. N) GO TO 631
         M0 = M0 + 1
         INDEX(M0) = L
  631 CONTINUE
C
      DO 643 J = 1,M
         DSUMP = 0.D0
         DSUMN = 0.D0
         DO 642 LL = 1,M0
            L = INDEX(LL)
            IF (BI(L,J)) 640,642,641
  640       DSUMN = DSUMN + DBLE(BI(L,J))
            GO TO 642
  641       DSUMP = DSUMP + DBLE(BI(L,J))
  642    CONTINUE
         Y(J) = -(DSUMP + DSUMN)
         S = DSUMP
         T = DSUMN
         TOL = RERRMX*AMAX1(S,-T)
         IF (ABS(Y(J)) .LT. TOL) Y(J) = 0.0
  643 CONTINUE
C
  650 DO 652 J = 1,N0
         SUM = 0.0
         IF (BASIS(J) .NE. 0) GO TO 652
         LMIN = ITA(J)
         LMAX = ITA(J + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 652
         DO 651 LL = LMIN,LMAX
            L = JTA(LL)
            SUM = SUM + Y(L)*TA(LL)
  651    CONTINUE
  652    R(J)=SUM
C
  660 IF (N0 .EQ. NS) GO TO 670
      JMIN = N0 + 1
      DO 661 J = JMIN,NS
         R(J) = 0.0
         IF (BASIS(J) .NE. 0) GO TO 661
         JJ = J - N0
         R(J) = Y(JJ)
  661 CONTINUE
C
  670 IF (NS .EQ. N) GO TO 200
      JMIN = NS + 1
      DO 671 J = JMIN,N
         R(J) = 0.0
         IF (BASIS(J) .NE. 0) GO TO 671
         JJ = J - N0
         R(J) = -Y(JJ)
  671 CONTINUE
      GO TO 200
C
C      SET UP A NEW R ARRAY FOR THE NSTEP = 3 CASE
C
  680 NSTEP = 3
      DO 682 J = 1,M
         DSUM = 0.D0
         DO 681 L = 1,M
            IL = IBASIS(L)
            IF (IL .LE. N0) DSUM = DSUM + DBLE(C(IL)*BI(L,J))
  681    CONTINUE
  682    Y(J) = DSUM
C
      DO 691 J = 1,N0
         R(J) = 0.0
         IF (BASIS(J) .NE. 0) GO TO 691
         DSUM = -C(J)
         LMIN = ITA(J)
         LMAX = ITA(J + 1) - 1
         R(J) = -C(J)
         IF (LMIN .GT. LMAX) GO TO 691
         DO 690 LL = LMIN,LMAX
            L = JTA(LL)
            DSUM = DSUM + DBLE(Y(L)*TA(LL))
  690    CONTINUE
         R(J) = DSUM
         IF (R(J) .GE. 0.0) GO TO 691
         TOL = RERRMX*ABS(C(J))
         IF (ABS(R(J)) .LT. TOL) R(J) = 0.0
  691 CONTINUE
      GO TO 660
C
C       UPDATE THE R ARRAY FOR THE NSTEP = 3 CASE
C
  700 CONST = R(JP)
      DO 703 J = 1,N0
         IF (BASIS(J) .EQ. 0) GO TO 701
            R(J) = 0.0
            GO TO 703
  701    SUM = 0.0
         LMIN = ITA(J)
         LMAX = ITA(J + 1) - 1
         IF (LMIN .GT. LMAX) GO TO 703
         DO 702 LL = LMIN,LMAX
            L = JTA(LL)
            SUM = SUM + BI(IP,L)*TA(LL)
  702    CONTINUE
         R(J) = R(J) - CONST*SUM
         IF (R(J) .GE. 0.0) GO TO 703
         TOL = RERRMX*ABS(C(J))
         IF (ABS(R(J)) .LT. TOL) R(J) = 0.0
  703 CONTINUE
C
  710 IF (N0 .EQ. NS) GO TO 720
      JMIN = N0 + 1
      DO 712 J = JMIN,NS
         IF (BASIS(J) .EQ. 0) GO TO 711
            R(J) = 0.0
            GO TO 712
  711    JJ = J - N0
         R(J) = R(J) - CONST*BI(IP,JJ)
  712 CONTINUE
C
  720 IF (NS .EQ. N) GO TO 200
      JMIN = NS + 1
      DO 722 J = JMIN,N
         IF (BASIS(J) .EQ. 0) GO TO 721
            R(J) = 0.0
            GO TO 722
  721    JJ = J - N0
         R(J) = R(J) + CONST*BI(IP,JJ)
  722 CONTINUE
      GO TO 200
C-----------------------------------------------------------------------
C               REFINE XB AND STORE THE RESULT IN Y
C-----------------------------------------------------------------------
  800 DO 801 I = 1,M
         R(I) = 0.0
         Y(I) = 0.0
  801 CONTINUE
C
      DO 831 J = 1,M
         KJ = IBASIS(J)
         IF (KJ .LE. N0) GO TO 810
         IF (KJ .LE. NS) GO TO 820
         IF (KJ .LE. N) GO TO 830
         GO TO 820
C
  810    LMIN = ITA(KJ)
         LMAX = ITA(KJ + 1) - 1
         DO 811 LL = LMIN,LMAX
            L = JTA(LL)
            DT = DBLE(R(L)) + DBLE(Y(L))
            DT = DT + DBLE(TA(LL)*XB(J))
            R(L) = DT
            Y(L) = DT - DBLE(R(L))
  811    CONTINUE
         GO TO 831
C
  820    L = KJ - N0
         DT = DBLE(R(L)) + DBLE(Y(L))
         DT = DT + DBLE(XB(J))
         R(L) = DT
         Y(L) = DT - DBLE(R(L))
         GO TO 831
C
  830    L = KJ - N0
         DT = DBLE(R(L)) + DBLE(Y(L))
         DT = DT - DBLE(XB(J))
         R(L) = DT
         Y(L) = DT - DBLE(R(L))
  831 CONTINUE
C
      DO 840 I = 1,M
         DT = DBLE(R(I)) + DBLE(Y(I))
         R(I) = DBLE(B0(I)) - DT
  840 CONTINUE
C
  850 RERR1 = AMIN1(RERRMX,RERR)
      DO 856 I = 1,M
         Y(I) = 0.0
         IF (XB(I)) 851,856,852
  851    SGN = -1.0
         DSUMP = 0.D0
         DSUMN = XB(I)
         GO TO 853
  852    SGN = 1.0
         DSUMP = XB(I)
         DSUMN = 0.D0
  853    DO 855 L = 1,M
            DT = BI(I,L)*R(L)
            IF (DT .GT. 0.D0) GO TO 854
               DSUMN = DSUMN + DT
               GO TO 855
  854       DSUMP = DSUMP + DT
  855    CONTINUE
         W = DSUMP + DSUMN
         IF (W .EQ. 0.0) GO TO 856
         IF (SGN .NE. SIGN(1.0,W)) GO TO 856
         S = DSUMP
         T = DSUMN
         TOL = RERR1*AMAX1(S,-T)
         IF (ABS(W) .GT. TOL) Y(I) = W
  856 CONTINUE
      IF (NSTEP - 2) 860,870,880
C
C         CHECK THE REFINEMENT (NSTEP = 1)
C
  860 DO 861 I = 1,M
         IF (Y(I) .GE. 0.0) GO TO 861
         IF (Y(I) .LT. -RERRMX) GO TO 240
         Y(I) = 0.0
  861    XB(I) = Y(I)
      GO TO 630
C
C         CHECK THE REFINEMENT (NSTEP = 2)
C
  870 DO 871 I = 1,M
         IF (IBASIS(I) .LE. N) GO TO 871
         IF (Y(I) .GT. RERRMX) GO TO 240
         Y(I) = 0.0
  871    XB(I) = Y(I)
      GO TO 680
C
C              COMPUTE Z  (NSTEP = 3)
C
  880 DSUM = 0.D0
      DO 881 I = 1,M
         KI = IBASIS(I)
         IF (KI .GT. N0) GO TO 881
         DSUM = DSUM + DBLE(C(KI)*Y(I))
  881    XB(I) = Y(I)
      Z = DSUM
      GO TO 220
      END
      SUBROUTINE CROUT1(A,KA,N,IEND,INDEX,TEMP,JP,IERR)
C     ******************************************************************
C     CROUT PROCEDURE FOR INVERTING MATRICES
C     ******************************************************************
C     A IS A MATRIX OF ORDER N WHERE N IS GREATER THAN OR EQUAL TO 1.
C     THE INVERSE OF A IS COMPUTED AND STORED IN A.
C
C     KA = LENGTH OF THE COLUMNS OF THE ARRAY A
C     JP = THE NUMBER OF THE COLUMN THAT CONTAINS THE SMALLEST PIVOT
C
C     IEND MAY BE 0,1,...,N-1.  IT IS ASSUMED THAT EACH OF THE FIRST
C     IEND COLUMNS OF THE MATRIX A CONTAINS ONLY ONE NONZERO ELEMENT
C     AND THAT THE NONZERO ELEMENT IS 1 OR -1.
C
C     INDEX IS AN ARRAY OF DIMENSION N-1 OR LARGER THAT IS USED BY THE
C     ROUTINE FOR KEEPING TRACK OF THE ROW INTERCHANGES THAT ARE MADE.
C
C     TEMP IS A TEMPORARY STORAGE ARRAY.
C
C     IERR REPORTS THE STATUS OF THE RESULTS. IF A IS NONSINGULAR THEN
C     THE INVERSE OF A IS COMPUTED AND IERR=0. OTHERWISE IF A IS FOUND
C     TO BE SINGULAR THEN IERR=1 AND THE ROUTINE TERMINATES.
C     --------------------
      DIMENSION A(*),INDEX(*),TEMP(N)
      DOUBLE PRECISION DSUM
      MAX = KA*N
      MCOL = IEND*KA
      IF (IEND .EQ. 0) GO TO 100
C
C           PROCESS THE FIRST IEND COLUMNS OF A
C
      KCOL = 0
      DO 32 K = 1,IEND
      KK = KCOL + K
      NK = KCOL + N
      DO 10 LK = KK,NK
      IF (A(LK)) 20,10,30
   10 CONTINUE
      JP = K
      GO TO 300
C
   20 L = LK - KCOL
      LJ0 = MCOL + L
      DO 21 LJ = LJ0,MAX,KA
   21 A(LJ) = -A(LJ)
C
   30 L = LK - KCOL
      INDEX(K) = L
      IF (K .EQ. L) GO TO 32
      LJ = LK
      DO 31 KJ = KK,MAX,KA
      C = A(KJ)
      A(KJ) = A(LJ)
      A(LJ) = C
   31 LJ = LJ + KA
   32 KCOL = KCOL + KA
C
C           PROCESS THE REMAINING COLUMNS OF A
C
  100 NM1 = N - 1
      JP = 1
      IERR = 0
      PMIN = 0.0
      IBEG = IEND + 1
      IF (IBEG .EQ. N) GO TO 190
C
      K = IBEG
      KM1 = IEND
      KP1 = K + 1
      KCOL = MCOL
      KK = KCOL + K
      DO 172 KCOUNT = IBEG,NM1
C
C     SEARCH FOR THE K-TH PIVOT ELEMENT (K=IBEG,...,N-1)
C
      L = K
      S = ABS(A(KK))
      DO 110 I = KP1,N
      IK = KCOL + I
      C = ABS(A(IK))
      IF (S .GE. C) GO TO 110
      L = I
      S = C
  110 CONTINUE
C
      IF (K.GT.IBEG .AND. S.GE.PMIN) GO TO 120
      JP = K
      PMIN = S
      IF (S .EQ. 0.0) GO TO 300
C
C              INTERCHANGING ROWS K AND L
C
  120 INDEX(K) = L
      IF (K .EQ. L) GO TO 130
      KJ0 = MCOL + K
      LJ  = MCOL + L
      DO 121 KJ = KJ0,MAX,KA
      C = A(KJ)
      A(KJ) = A(LJ)
      A(LJ) = C
  121 LJ = LJ + KA
C
C       COMPUTE THE K-TH ROW OF U (K=IBEG,...,N-1)
C
  130 C = A(KK)
      IF (K .GT. IBEG) GO TO 140
      KJ0 = KK + KA
      DO 131 KJ = KJ0,MAX,KA
  131 A(KJ) = A(KJ)/C
      GO TO 160
C
  140 KL = MCOL + K
      DO 141 L = IBEG,KM1
      TEMP(L) = A(KL)
  141 KL = KL + KA
C
      KJ0 = KK + KA
      DO 151 KJ = KJ0,MAX,KA
      JCOL = KJ - K
      DSUM = -A(KJ)
        DO 150 L = IBEG,KM1
        LJ = JCOL + L
  150   DSUM = DSUM + DBLE(TEMP(L))*DBLE(A(LJ))
  151 A(KJ) = SNGL(-DSUM)/C
C
C      COMPUTE THE K-TH COLUMN OF L (K=IBEG+1,...,N)
C
  160 KM1 = K
      K = KP1
      KP1 = K + 1
      KCOL = KCOL + KA
      KK = KCOL + K
      DO 161 L = IBEG,KM1
      LK = KCOL + L
  161 TEMP(L) = A(LK)
C
      DO 171 I = K,N
      IL = MCOL + I
      DSUM = 0.D0
        DO 170 L = IBEG,KM1
        DSUM = DSUM + DBLE(A(IL))*DBLE(TEMP(L))
  170   IL = IL + KA
  171 A(IL) = DBLE(A(IL)) - DSUM
  172 CONTINUE
C
C           CHECK THE N-TH PIVOT ELEMENT
C
  190 NCOL = MAX - KA
      NN = NCOL + N
      C = ABS(A(NN))
      IF (C .GT. PMIN) GO TO 200
      JP = N
      IF (C .EQ. 0.0) GO TO 300
C
C          REPLACE L WITH THE INVERSE OF L
C
  200 IF (IBEG .EQ. N) GO TO 213
      JJ = MCOL + IBEG
      I = KA + 1
      DO 212 J = IBEG,NM1
      A(JJ) = 1.0/A(JJ)
      TEMP(J) = A(JJ)
      KJ = JJ
        DO 211 KM1 = J,NM1
        K = KM1 + 1
        KJ = KJ + 1
        DSUM = 0.D0
        KL = KJ
          DO 210 L = J,KM1
          DSUM = DSUM + DBLE(A(KL)*TEMP(L))
  210     KL = KL + KA
        A(KJ) = SNGL(-DSUM)/A(KL)
  211   TEMP(K) = A(KJ)
  212 JJ = JJ + I
  213 A(NN) = 1.0/A(NN)
      IF (N .EQ. 1) RETURN
C
C       SOLVE UX = Y WHERE Y IS THE INVERSE OF L
C
      DO 242 NMK = 1,NM1
      K = N - NMK
      LMIN = MAX0(IBEG,K+1)
      KL = (LMIN-1)*KA + K
        DO 230 L = LMIN,N
        TEMP(L) = A(KL)
        A(KL) = 0.0
  230   KL = KL + KA
C
      KJ0 = MCOL + K
        DO 241 KJ = KJ0,MAX,KA
        DSUM = -A(KJ)
        LJ = (KJ - K) + LMIN
          DO 240 L = LMIN,N
          DSUM = DSUM + DBLE(TEMP(L)*A(LJ))
  240     LJ = LJ + 1
  241   A(KJ) = -DSUM
  242 CONTINUE
C
C                 COLUMN INTERCHANGES
C
      JCOL = NCOL - KA
      DO 251 NMJ = 1,NM1
      J = N - NMJ
      K = INDEX(J)
      IF (J .EQ. K) GO TO 251
      IJ = JCOL
      IK = (K-1)*KA
        DO 250 I = 1,N
        IJ = IJ + 1
        IK = IK + 1
        C = A(IJ)
        A(IJ) = A(IK)
  250   A(IK) = C
  251 JCOL = JCOL - KA
      RETURN
C
C                    ERROR RETURN
C
  300 IERR = 1
      RETURN
      END
      SUBROUTINE ASSGN (N,A,C,T,IWK,IERR)
C     -------------------
C     SOLUTION OF THE ASSIGNMENT PROBLEM
C     -------------------
      INTEGER A(N,*), C(N), T, IWK(*)
C
      I1 = N + 1
      I2 = I1 + N
      I3 = I2 + N
      I4 = I3 + N + 1
      I5 = I4 + N
      I6 = I5 + N
      CALL ASSGN1(N,A,C,T,IWK(1),IWK(I1),IWK(I2),IWK(I3),IWK(1),
     *            IWK(I3),IWK(I4),IWK(I5),IWK(I6),IERR)
      RETURN
      END
      SUBROUTINE ASSGN1(N,A,C,T,CH,LC,LR,LZ,NZ,RH,SLC,SLR,
     *                  U,IERR)
      INTEGER A(N,*), C(N), CH(N), LC(N), LR(N), LZ(N),
     *        NZ(N), RH(*), SLC(N), SLR(N), U(*)
      INTEGER H, Q, R, S, T
C
C THIS SUBROUTINE SOLVES THE SQUARE ASSIGNMENT PROBLEM
C THE MEANING OF THE INPUT PARAMETERS IS
C N = NUMBER OF ROWS AND COLUMNS OF THE COST MATRIX
C A(I,J) = ELEMENT IN ROW I AND COLUMN J OF THE COST MATRIX
C ( AT THE END OF COMPUTATION THE ELEMENTS OF A ARE CHANGED)
C THE MEANING OF THE OUTPUT PARAMETERS IS
C C(J) = ROW ASSIGNED TO COLUMN J (J=1,N)
C T = COST OF THE OPTIMAL ASSIGNMENT
C ALL PARAMETERS ARE INTEGER
C THE MEANING OF THE LOCAL VARIABLES IS
C A(I,J) = ELEMENT OF THE COST MATRIX IF A(I,J) IS POSITIVE,
C          COLUMN OF THE UNASSIGNED ZERO FOLLOWING IN ROW I
C          (I=1,N) THE UNASSIGNED ZERO OF COLUMN J (J=1,N)
C          IF A(I,J) IS NOT POSITIVE
C A(I,N+1) = COLUMN OF THE FIRST UNASSIGNED ZERO OF ROW I
C            (I=1,N)
C CH(I) = COLUMN OF THE NEXT UNEXPLORED AND UNASSIGNED ZERO
C         OF ROW I (I=1,N)
C LC(J) = LABEL OF COLUMN J (J=1,N)
C LR(I) = LABEL OF ROW I (I=1,N)
C LZ(I) = COLUMN OF THE LAST UNASSIGNED ZERO OF ROW I(I=1,N)
C NZ(I) = COLUMN OF THE NEXT UNASSIGNED ZERO OF ROW I(I=1,N)
C RH(I) = UNEXPLORED ROW FOLLOWING THE UNEXPLORED ROW I
C         (I=1,N)
C RH(N+1) = FIRST UNEXPLORED ROW
C SLC(K) = K-TH ELEMENT CONTAINED IN THE SET OF THE LABELLED
C          COLUMNS
C SLR(K) = K-TH ELEMENT CONTAINED IN THE SET OF THE LABELLED
C          ROWS
C U(I) = UNASSIGNED ROW FOLLOWING THE UNASSIGNED ROW I
C        (I=1,N)
C U(N+1) = FIRST UNASSIGNED ROW
C IERR = 0 IF THE ROUTINE TERMINATES SUCCESSFULLY. OTHERWISE
C          IERR = 1
C
C THE VECTORS C,CH,LC,LR,LZ,NZ,SLC,SLR MUST BE DIMENSIONED
C AT LEAST AT (N), THE VECTORS RH,U AT  LEAST AT (N+1),
C AND THE MATRIX A AT LEAST AT (N,N+1). TO SAVE STORAGE
C LZ AND RH MAY USE THE SAME STORAGE AREA, AND NZ AND CH
C MAY USE THE SAME STORAGE AREA.
C
C INITIALIZATION
      MAXNUM = IPMPAR(3)
      IERR = 0
      NP1 = N+1
      DO 10 J=1,N
        C(J) = 0
        LZ(J) = 0
        NZ(J) = 0
        U(J) = 0
   10 CONTINUE
      U(NP1) = 0
      T = 0
C REDUCTION OF THE INITIAL COST MATRIX
      DO 40 J=1,N
        S = A(1,J)
        DO 15 L=2,N
          IF ( A(L,J) .LT. S ) S = A(L,J)
   15   CONTINUE
        IF (S) 20,40,30
   20   MM = MAXNUM + S
        IF (T .LT. -MM) GO TO 400
        T = T + S
        DO 25 I = 1,N
          IF (A(I,J) .GT. MM) GO TO 400
          A(I,J) = A(I,J) - S
   25   CONTINUE
        GO TO 40
   30   MM = MAXNUM - S
        IF (T .GT. MM) GO TO 400
        T = T + S
        DO 35 I = 1,N
          A(I,J) = A(I,J) - S
   35   CONTINUE
   40 CONTINUE
      DO 70 I=1,N
        Q = A(I,1)
        DO 50 L=2,N
          IF ( A(I,L) .LT. Q ) Q = A(I,L)
   50   CONTINUE
        MM = MAXNUM - Q
        IF (T .GT. MM) GO TO 400
        T = T + Q
        L = NP1
        DO 60 J=1,N
          A(I,J) = A(I,J)-Q
          IF ( A(I,J) .NE. 0 ) GO TO 60
          A(I,L) = -J
          L = J
   60   CONTINUE
   70 CONTINUE
C CHOICE OF THE INITIAL SOLUTION
      K = NP1
      DO 140 I=1,N
        LJ = NP1
        J = -A(I,NP1)
   80   IF ( C(J) .EQ. 0 ) GO TO 130
        LJ = J
        J = -A(I,J)
        IF ( J .NE. 0 ) GO TO 80
        LJ = NP1
        J = -A(I,NP1)
   90   R = C(J)
        LM = LZ(R)
        M = NZ(R)
  100   IF ( M .EQ. 0 ) GO TO 110
        IF ( C(M) .EQ. 0 ) GO TO 120
        LM = M
        M = -A(R,M)
        GO TO 100
  110   LJ = J
        J = -A(I,J)
        IF ( J .NE. 0 ) GO TO 90
        U(K) = I
        K = I
        GO TO 140
  120   NZ(R) = -A(R,M)
        LZ(R) = J
        A(R,LM) = -J
        A(R,J) = A(R,M)
        A(R,M) = 0
        C(M) = R
  130   C(J) = I
        A(I,LJ) = A(I,J)
        NZ(I) = -A(I,J)
        LZ(I) = LJ
        A(I,J) = 0
  140 CONTINUE
C RESEARCH OF A NEW ASSIGNMENT
  150 IF ( U(NP1) .EQ. 0 ) RETURN
      DO 160 I=1,N
        CH(I) = 0
        LC(I) = 0
        LR(I) = 0
        RH(I) = 0
  160 CONTINUE
      RH(NP1) = -1
      KSLC = 0
      KSLR = 1
      R = U(NP1)
      LR(R) = -1
      SLR(1) = R
      IF ( A(R,NP1) .EQ. 0 ) GO TO 220
  170 L = -A(R,NP1)
      IF ( A(R,L) .EQ. 0 ) GO TO 180
      IF ( RH(R) .NE. 0 ) GO TO 180
      RH(R) = RH(NP1)
      CH(R) = -A(R,L)
      RH(NP1) = R
  180 IF ( LC(L) .EQ. 0 ) GO TO 200
      IF ( RH(R) .EQ. 0 ) GO TO 210
  190 L = CH(R)
      CH(R) = -A(R,L)
      IF ( A(R,L) .NE. 0 ) GO TO 180
      RH(NP1) = RH(R)
      RH(R) = 0
      GO TO 180
  200 LC(L) = R
      IF ( C(L) .EQ. 0 ) GO TO 360
      KSLC = KSLC+1
      SLC(KSLC) = L
      R = C(L)
      LR(R) = L
      KSLR = KSLR+1
      SLR(KSLR) = R
      IF ( A(R,NP1) .NE. 0 ) GO TO 170
  210 CONTINUE
      IF ( RH(NP1) .GT. 0 ) GO TO 350
C REDUCTION OF THE CURRENT COST MATRIX
  220 H = MAXNUM
      DO 240 J=1,N
        IF ( LC(J) .NE. 0 ) GO TO 240
        DO 230 K=1,KSLR
          I = SLR(K)
          IF ( A(I,J) .LT. H ) H = A(I,J)
  230   CONTINUE
  240 CONTINUE
      MM = MAXNUM - H
      IF (MM .EQ. 0 .OR. T .GT. MM) GO TO 400
      T = T + H
      DO 290 J=1,N
        IF ( LC(J) .NE. 0 ) GO TO 290
        DO 280 K=1,KSLR
          I = SLR(K)
          A(I,J) = A(I,J)-H
          IF ( A(I,J) .NE. 0 ) GO TO 280
          IF ( RH(I) .NE. 0 ) GO TO 250
          RH(I) = RH(NP1)
          CH(I) = J
          RH(NP1) = I
  250     L = NP1
  260     NL = -A(I,L)
          IF ( NL .EQ. 0 ) GO TO 270
          L = NL
          GO TO 260
  270     A(I,L) = -J
  280   CONTINUE
  290 CONTINUE
      IF ( KSLC .EQ. 0 ) GO TO 350
      DO 340 I=1,N
        IF ( LR(I) .NE. 0 ) GO TO 340
        DO 330 K=1,KSLC
          J = SLC(K)
          IF ( A(I,J) .GT. 0 ) GO TO 320
          L = NP1
  300     NL = - A(I,L)
          IF ( NL .EQ. J ) GO TO 310
          L = NL
          GO TO 300
  310     A(I,L) = A(I,J)
          A(I,J) = H
          GO TO 330
  320     MM = MAXNUM - H
          IF (A(I,J) .GT. MM) GO TO 400
          A(I,J) = A(I,J) + H
  330   CONTINUE
  340 CONTINUE
  350 R = RH(NP1)
      GO TO 190
C ASSIGNMENT OF A NEW ROW
  360 C(L) = R
      M = NP1
  370 NM = -A(R,M)
      IF ( NM .EQ. L ) GO TO 380
      M = NM
      GO TO 370
  380 A(R,M) = A(R,L)
      A(R,L) = 0
      IF ( LR(R) .LT. 0 ) GO TO 390
      L = LR(R)
      A(R,L) = A(R,NP1)
      A(R,NP1) = -L
      R = LC(L)
      GO TO 360
  390 U(NP1) = U(R)
      U(R) = 0
      GO TO 150
C ERROR RETURN - INTEGER OVERFLOW OCCURS
  400 IERR = 1
      RETURN
      END
      SUBROUTINE MKP (N,M,P,W,K,BCK,XSTAR,VSTAR,WK,IWK,NUM)
C
C SUBROUTINE TO SOLVE A 0-1 MULTIPLE KNAPSACK PROBLEM OF N
C ITEMS (WITH  N .GE. 2) AND  M  KNAPSACKS (WITH  M .GE. 1 ,
C I.E. ALSO SUITABLE FOR A 0-1 SINGLE KNAPSACK PROBLEM).
C THE PROBLEM TO BE SOLVED IS
C
C MAXIMIZE  VSTAR = P(1)*(X(1,1) + ... + X(M,1)) + ...
C                   ... + P(N)*(X(1,N) + ... + X(M,N))
C SUBJECT TO
C W(1)*X(I,1) + ... + W(N)*X(I,N) .LE. K(I)   FOR  I=1,...,M
C X(1,J) + ... + X(M,J) .LE. 1   FOR  J=1,...,N
C X(I,J) = 0 OR 1   FOR  I=1,...,M ,  J=1,...,N ,
C
C WHERE ALL P(J), W(J), AND K(I) ARE POSITIVE INTEGERS.
C BEFORE MKP IS CALLED, ARRAY K MUST BE SORTED SO THAT
C K(1) .LE. K(2) .LE. ... .LE. K(M) .
C
C MEANING OF THE INPUT PARAMETERS ...
C
C N    = NUMBER OF ITEMS.
C M    = NUMBER OF KNAPSACKS.
C P(J) = PROFIT OF ITEM  J  (J=1,...,N) .
C W(J) = WEIGHT OF ITEM  J  (J=1,...,N) .
C K(I) = CAPACITY OF KNAPSACK  I  (I=1,...,M) .
C BCK  = -1  IF EXACT SOLUTION IS REQUIRED.
C      = MAXIMUM NUMBER OF BACKTRACKINGS TO BE PERFORMED, IF
C        HEURISTIC SOLUTION IS REQUIRED.
C WK   = REAL WORK SPACE OF DIMENSION N.
C IWK  = WORK SPACE OF DIMENSION .GE. 5*M + 14*N + 4*M*N + 3
C NUM  = DIMENSION OF IWK
C
C MEANING OF THE OUTPUT PARAMETERS ...
C
C XSTAR(J) = 0  IF ITEM  J  IS NOT IN THE OPTIMAL SOLUTION
C               (I.E. IF  X(I,J) = 0  FOR ALL  I ).
C          = KNAPSACK WHERE ITEM  J  IS INSERTED, OTHERWISE
C            (I.E. IF  X(XSTAR(J),J) = 1 ).
C VSTAR    = VALUE OF THE OPTIMAL SOLUTION IF  VSTAR .GT. 0.
C          = ERROR CONDITION (INFEASIBILITY OR TRIVIALITY)
C            IN THE INPUT DATA IF  VSTAR .LT. 0 .
C            = -1  IF  N .LT. 2  OR  M .LT. 1 .
C            = -2  IF SOME  P(J) ,  W(J)  OR  K(I) ARE NOT
C                  POSITIVE.
C            = -3  IF A KNAPSACK CANNOT CONTAIN ANY ITEM.
C            = -4  IF AN ITEM CANNOT FIT INTO ANY KNAPSACK.
C            = -5  IF KNAPSACK  M  CONTAINS ALL THE ITEMS.
C            = -7  IF ARRAY  K IS NOT CORRECTLY SORTED.
C            = -8  IF NUM .LT. 5*M + 14*N + 4*M*N + 3.
C
C            (IN ALL THE ABOVE CASES ARRAY  XSTAR IS NOT
C            DEFINED).
C
C ALL THE PARAMETERS EXCEPT WK ARE OF INTEGER TYPE. WHEN MKP
C TERMINATES, ALL THE INPUT PARAMETERS ARE UNCHANGED EXCEPT
C BCK, WHICH GIVES THE NUMBER OF BACKTRACKINGS PERFORMED.
C
      INTEGER P(N),W(N),K(M),XSTAR(N),BCK,VSTAR,IWK(NUM)
      REAL WK(N)
      INTEGER BB, BL, X, XL
      INTEGER B, UBB
      INTEGER F, PBL, Q, V
      INTEGER BS, PS, WS, XS
C
C                    CHECK THE INPUT DATA
C
      IF (M .LT. 1 .OR. N .LT. 2) GO TO 100
      MN = M*N
      IF (NUM .LT. 5*M + 14*N + 4*MN + 3) GO TO 160
C
      IF (P(1) .LE. 0 .OR. W(1) .LE. 0) GO TO 110
      AP = P(1)
      AW = W(1)
      WK(1) = -AP/AW
      MAXW = W(1)
      MINW = W(1)
      ISUMW = W(1)
      DO 10 J = 2,N
         IF (P(J) .LE. 0 .OR. W(J) .LE. 0) GO TO 110
         AP = P(J)
         AW = W(J)
         WK(J) = -AP/AW
         IF (W(J) .GT. MAXW) MAXW = W(J)
         IF (W(J) .LT. MINW) MINW = W(J)
         ISUMW = ISUMW + W(J)
   10 CONTINUE
C
      IF (K(1) .LE. 0) GO TO 110
      IF (M .EQ. 1) GO TO 30
      DO 20 I = 2,M
         IF (K(I) .LE. 0) GO TO 110
         IF (K(I) .LT. K(I-1)) GO TO 150
   20 CONTINUE
C
   30 IF (MINW .GT. K(1)) GO TO 120
      IF (MAXW .GT. K(M)) GO TO 130
      IF (ISUMW .LE. K(M)) GO TO 140
      VSTAR = 0
C
C             REORDER THE ARRAYS P AND W SO THAT
C                P(J)/W(J) .GE. P(J+1)/W(J+1)
C
      N5 = 5*N
      DO 40 J = 1,N
         JJ = N5 + J
         IWK(JJ) = J
   40 CONTINUE
      CALL RISORT (WK, IWK(N5 + 1), N)
C
      DO 50 J = 1,N
         IWK(J) = P(J)
         JN = J + N
         IWK(JN) = W(J)
   50 CONTINUE
C
      DO 60 J = 1,N
         JJ = N5 + J
         L = IWK(JJ)
         P(J) = IWK(L)
         NPL = N + L
         W(J) = IWK(NPL)
   60 CONTINUE
C
C                PARTITION THE WORK SPACE IWK
C
      LX =  JJ + 1
      LXI = LX + N
      BS = LXI + N
      XS =  BS + N
      UBB = XS + N
C
      NP1 = N + 1
      B = UBB + N
      PS = B  + NP1
      WS = PS + NP1
C
      F = WS + NP1
      PBL = F + M
      Q = PBL + M
      V = Q + M
C
      BB = V + M
      X = BB + MN
      XL = X + MN
C
      BL = XL + MN
C
C                     SOLVE THE PROBLEM
C
      CALL MKP1 (N, M, P, W, K, BCK, XSTAR, VSTAR, NP1, N5,
     1           IWK(BB), IWK(BL), IWK(X), IWK(XL),
     2           IWK(B), IWK(UBB), IWK(LX), IWK(LXI),
     3           IWK(F), IWK(PBL), IWK(Q), IWK(V),
     4           IWK(BS), IWK(PS), IWK(WS), IWK(XS), IWK(1))
C
C           RESTORE THE INITIAL ORDERING TO P AND W,
C                AND REORDER XSTAR ACCORDINGLY
C
      DO 70 J = 1,N
         IWK(J) = P(J)
         JN = J + N
         IWK(JN) = W(J)
         JNN = JN + N
         IWK(JNN) = XSTAR(J)
   70 CONTINUE
C
      DO 80 J = 1,N
         JJ = N5 + J
         L = IWK(JJ)
         P(L) = IWK(J)
         JN = J + N
         W(L) = IWK(JN)
         JNN = JN + N
         XSTAR(L) = IWK(JNN)
   80 CONTINUE
      RETURN
C
C                        ERROR RETURN
C
  100 VSTAR = -1
      RETURN
  110 VSTAR = -2
      RETURN
  120 VSTAR = -3
      RETURN
  130 VSTAR = -4
      RETURN
  140 VSTAR = -5
      RETURN
  150 VSTAR = -7
      RETURN
  160 VSTAR = -8
      RETURN
      END
      SUBROUTINE MKP1 (N, M, P, W, K, BCK, XSTAR, VSTAR, NP1, N5,
     1                 BB, BL, X, XL, B, UBB, LX, LXI,
     2                 F, PBL, Q, V, BS, PS, WS, XS, IWK)
C
C MEANING OF THE MAIN INTERNAL VARIABLES AND ARRAYS ...
C
C I       = KNAPSACK CURRENTLY CONSIDERED.
C LB      = LOWER BOUND ON THE OPTIMAL SOLUTION.
C UB      = UPPER BOUND ON THE OPTIMAL SOLUTION.
C VB      = VALUE OF THE CURRENT SOLUTION.
C X(I,J)  = 1  IF ITEM  J  IS INSERTED IN KNAPSACK  I  IN
C              THE CURRENT SOLUTION.
C         = 0  OTHERWISE.
C F(I)    = POINTER TO THE LAST ITEM INSERTED IN KNAPSACK  I
C           ( = -1  IF KNAPSACK  I  IS EMPTY).
C BB(I,J) = POINTER TO THE ITEM INSERTED IN KNAPSACK  I
C           JUST BEFORE ITEM  J ( = -1  IF  J  IS THE FIRST
C           ITEM INSERTED IN KNAPSACK  I ).
C Q(I)    = CURRENT AVAILABLE CAPACITY OF KNAPSACK  I .
C B(J)    = 1  IF ITEM  J  IS NOT INSERTED IN ANY KNAPSACK.
C         = 0  IF ITEM  J  IS INSERTED IN A KNAPSACK.
C PBL(I)  = NUMBER OF THE ITEMS WHICH CAN BE INSERTED IN
C           KNAPSACK  I .
C BL(I,S) = POINTER TO THE  S-TH  ITEM WHICH CAN BE INSERTED
C           IN KNAPSACK  I .
C XL(I,J) = 1  IF ITEM  J  WAS INSERTED IN KNAPSACK  I  IN
C              THE LAST EXECUTION OF SUBROUTINE PI1.
C         = 0  OTHERWISE.
C IWK       WORK SPACE FOR THE SUBROUTINE SKNP.
C
      INTEGER P(N), W(N), K(M), XSTAR(N), BCK, VSTAR
      INTEGER BB(M,N), BL(M,NP1), X(M,N), XL(M,N)
      INTEGER B(NP1), UBB(N), LX(N), LXI(N)
      INTEGER F(M), PBL(M), Q(M), V(M)
      INTEGER BS(N), PS(NP1), WS(NP1), XS(N), IWK(N5)
      INTEGER S, U, UB, VB
C
      IF (M .EQ. 1) GO TO 250
C
C STEP 1 (INITIALIZATION)
C
      JBCK = BCK
      BCK = 0
      KUB = 0
      N1 = N + 1
      B(N1) = 1
      M1 = M - 1
      DO 40 J=1,N
        B(J) = 1
        DO 30 I=1,M
          X(I,J) = 0
          BB(I,J) = 0
   30   CONTINUE
   40 CONTINUE
      DO 50 I=1,M1
        Q(I) = K(I)
        F(I) = -1
   50 CONTINUE
      Q(M) = K(M)
      VSTAR = 0
      VB = 0
      I = 1
      CALL SIGMA1 (N,M,P,W,K,1,B,KUB,UB,NP1,N5,LX,LR,
     *             BS,PS,WS,XS,IWK)
      DO 60 J=1,N
        LXI(J) = LX(J)
   60 CONTINUE
      LRI = LR
      LUBI = UB
      IFLAG = 0
C
C STEP 2 (HEURISTIC)
C
   70 KUB = VSTAR - VB
      CALL PI1 (N,M,P,W,Q,I,B,BB,KUB,BL,LB,PBL,V,XL,
     *          NP1,N5,BS,PS,WS,XS,IWK)
      IF ( LB + VB .LE. VSTAR ) GO TO 140
      VSTAR = LB + VB
      DO 90 J=1,N
        XSTAR(J) = 0
        DO 80 S=1,I
          IF ( X(S,J) .EQ. 0 ) GO TO 80
          XSTAR(J) = S
          GO TO 90
   80   CONTINUE
   90 CONTINUE
      IP = PBL(I)
      IF ( IP .EQ. 0 ) GO TO 110
      DO 100 J=1,IP
        JJ = BL(I,J)
        IF ( XL(I,J) .EQ. 1 ) XSTAR(JJ) = I
  100 CONTINUE
  110 I1 = I + 1
      DO 130 II=I1,M
        IP = PBL(II)
        IF ( IP .EQ. 0 ) GO TO 130
        DO 120 J=1,IP
          JJ = BL(II,J)
          IF ( XL(II,J) .EQ. 1 ) XSTAR(JJ) = II
  120   CONTINUE
  130 CONTINUE
      IF ( UB .EQ. LB ) GO TO 200
C
C STEP 3 (UPDATING)
C
  140 IF ( V(I) .EQ. 0 ) GO TO 180
      IUV = UB + VB
      U = PBL(I)
      IBV = 0
      DO 170 S=1,U
        IF ( XL(I,S) .EQ. 0 ) GO TO 170
        J = BL(I,S)
        X(I,J) = 1
        Q(I) = Q(I) - W(J)
        VB = VB + P(J)
        B(J) = 0
        BB(I,J) = F(I)
        UBB(J) = IUV
        IF ( IFLAG .EQ. 1 ) GO TO 150
        LUB = IUV
        LJ = J
        LI = I
  150   F(I) = J
        IBV = IBV + P(J)
        IF ( IBV .EQ. V(I) ) GO TO 180
        CALL PARC (I,I,UB,IFLAG,VB,LUB,LJ,LI,F,BB,Q,B,N,M,NP1,
     *             LX,LXI,LR,LRI,LUBI)
        IF ( IFLAG .EQ. 1 ) GO TO 160
        KUB = VSTAR - VB
        CALL SIGMA1 (N,M,P,W,Q,I,B,KUB,UB,NP1,N5,LX,LR,
     *               BS,PS,WS,XS,IWK)
        LJ = N1
  160   IUV = UB + VB
        IF ( IUV .LE. VSTAR ) GO TO 200
  170 CONTINUE
  180 IF ( I .EQ. M - 1 ) GO TO 200
      IP1 = I + 1
      CALL PARC (IP1,I,UB,IFLAG,VB,LUB,LJ,LI,F,BB,Q,B,N,M,NP1,
     *           LX,LXI,LR,LRI,LUBI)
      IF ( IFLAG .EQ. 1 ) GO TO 190
      KUB = VSTAR - VB
      CALL SIGMA1 (N,M,P,W,Q,IP1,B,KUB,UB,NP1,N5,LX,LR,
     *             BS,PS,WS,XS,IWK)
      LJ = N1
  190 IF ( UB + VB .LE. VSTAR ) GO TO 200
      I = I + 1
      GO TO 140
C
C STEP 4 (BACKTRACKING)
C
  200 IF ( I .GT. 0 ) GO TO 210
      BCK = BCK - 1
      RETURN
  210 IF ( BCK .EQ. JBCK ) RETURN
      BCK = BCK + 1
      IF ( F(I) .NE. (-1) ) GO TO 230
      DO 220 J=1,N
        BB(I,J) = 0
  220 CONTINUE
      I = I - 1
      GO TO 200
  230 J = F(I)
      X(I,J) = 0
      B(J) = 1
      VB = VB - P(J)
      Q(I) = Q(I) + W(J)
      DO 240 S=1,N
        IF ( BB(I,S) .EQ. J ) BB(I,S) = 0
  240 CONTINUE
      F(I) = BB(I,J)
      IF ( UBB(J) .LE. VSTAR ) GO TO 200
      UB = UBB(J) - VB
      IFLAG = 1
      GO TO 70
C
C PARTICULAR CASE (0-1 SINGLE KNAPSACK PROBLEM)
C
  250 K1 = K(1)
      DO 260 J=1,N
        PS(J) = P(J)
        WS(J) = W(J)
  260 CONTINUE
      CALL SKNP (N,K1,0,VSTAR,N,NP1,N5,PS,WS,XS,IWK)
      DO 270 J=1,N
        XSTAR(J) = XS(J)
  270 CONTINUE
      BCK = 0
      RETURN
      END
      SUBROUTINE SIGMA1 (N,M,P,W,Q,I,B,KUB,UB,NP1,N5,LX,LR,
     *                   BS,PS,WS,XS,IWK)
C
C SUBROUTINE TO COMPUTE AN UPPER BOUND  UB  ON THE BEST
C FINAL SOLUTION WHICH CAN BE OBTAINED FROM THE CURRENT
C SOLUTION.
C
      INTEGER P(N),W(N),Q(M),B(NP1),UB,IWK(N5)
      INTEGER LX(N),BS(N),PS(NP1),WS(NP1),XS(N)
      INTEGER QS,SB
C
      NS = 0
      QS = 0
      DO 10 J=I,M
        QS = QS + Q(J)
   10 CONTINUE
      SB = 0
      DO 20 J=1,N
        LX(J) = 0
        IF ( B(J) .EQ. 0 ) GO TO 20
        NS = NS + 1
        BS(NS) = J
        PS(NS) = P(J)
        WS(NS) = W(J)
        SB = SB + W(J)
   20 CONTINUE
      IF ( SB .GT. QS ) GO TO 40
      LR = QS - SB
      UB = 0
      IF ( NS .EQ. 0 ) RETURN
      DO 30 J=1,NS
        UB = UB + PS(J)
        XS(J) = 1
   30 CONTINUE
      GO TO 50
   40 CALL SKNP (NS,QS,KUB,UB,N,NP1,N5,PS,WS,XS,IWK)
      LR = QS
   50 DO 60 J=1,NS
        JJ = BS(J)
        LX(JJ) = XS(J)
   60 CONTINUE
      RETURN
      END
      SUBROUTINE PI1 (N,M,P,W,Q,I,B,BB,KUB,BL,LB,PBL,V,XL,
     *                NP1,N5,BS,PS,WS,XS,IWK)
C
C SUBROUTINE TO COMPUTE A FEASIBLE SOLUTION TO THE CURRENT
C PROBLEM. THE SOLUTION IS STORED IN ARRAY  XL , THE
C CORRESPONDING VALUE IN  LB .
C
      INTEGER BB(M,N),BL(M,NP1),XL(M,N),IWK(N5)
      INTEGER P(N),W(N),Q(M),B(NP1),PBL(M),V(M)
      INTEGER BS(N),PS(NP1),WS(NP1),XS(N)
      INTEGER PB,QS,SB,U
C
C STEP 1
C
      U = 0
      DO 10 J=1,N
        IF ( B(J) .EQ. 0 ) GO TO 10
        U = U + 1
        BS(U) = J
   10 CONTINUE
      DO 20 J=I,M
        PBL(J) = 0
        V(J) = 0
   20 CONTINUE
      LB = 0
      IKUB = KUB
      IF ( U .EQ. 0 ) RETURN
      NS = 0
      SB = 0
      DO 30 J=1,U
        JJ = BS(J)
        IF ( BB(I,JJ) .NE. 0 ) GO TO 30
        IF ( W(JJ) .GT. Q(I) ) GO TO 30
        NS = NS + 1
        SB = SB + W(JJ)
        BL(I,NS) = JJ
        PS(NS) = P(JJ)
        WS(NS) = W(JJ)
   30 CONTINUE
      II = I
C
C STEP 2
C
   40 PBL(II) = NS
      IF ( SB .GT. Q(II) ) GO TO 60
      PB = 0
      IF ( NS .EQ. 0 ) GO TO 80
      DO 50 J=1,NS
        PB = PB + PS(J)
        XL(II,J) = 1
   50 CONTINUE
      GO TO 80
   60 QS = Q(II)
      KUB = 0
      IF ( II .EQ. M ) KUB = IKUB
      CALL SKNP (NS,QS,KUB,PB,N,NP1,N5,PS,WS,XS,IWK)
      DO 70 J=1,NS
        XL(II,J) = XS(J)
   70 CONTINUE
   80 LB = LB + PB
      IKUB = IKUB - PB
      V(II) = PB
      BL(II,NS+1) = N + 1
C
C STEP 3
C
      IF ( II .EQ. M ) RETURN
      JB = 1
      JBS = 0
      DO 100 J=1,U
        IF ( BS(J) .LT. BL(II,JB) ) GO TO 90
        JB = JB + 1
        IF ( XL(II,JB-1) .EQ. 1 ) GO TO 100
   90   JBS = JBS + 1
        BS(JBS) = BS(J)
  100 CONTINUE
      U = JBS
      IF ( U .EQ. 0 ) RETURN
      NS = 0
      SB = 0
      II = II + 1
      DO 110 J=1,U
        JJ = BS(J)
        IF( W(JJ) .GT. Q(II) ) GO TO 110
        NS = NS + 1
        SB = SB + W(JJ)
        BL(II,NS) = JJ
        PS(NS) = P(JJ)
        WS(NS) =  W(JJ)
  110 CONTINUE
      GO TO 40
      END
      SUBROUTINE PARC (I,II,UB,IFLAG,VB,LUB,LJ,LI,F,BB,Q,B,N,M,NP1,
     *                 LX,LXI,LR,LRI,LUBI)
C
C SUBROUTINE FOR PARAMETRIC COMPUTATION OF THE UPPER BOUNDS.
C
      INTEGER F(M),BB(M,N),Q(M),B(NP1),UB,VB,R,S
      INTEGER LX(N),LXI(N)
C
      IFLAG = 0
      IF ( B(LJ) .NE. 0 ) GO TO 60
      I1 = I - 1
      IF ( I1 .LT. LI ) GO TO 20
      IQ = 0
      DO 10 R=LI,I1
        IQ = IQ + Q(R)
   10 CONTINUE
      IF ( IQ .GT. LR ) RETURN
   20 R = II
      S = F(R)
   30 IF ( S .NE. (-1) ) GO TO 40
      R = R - 1
      S = F(R)
      GO TO 30
   40 IF ( LX(S) .EQ. 0 ) RETURN
      IF ( S .EQ. LJ ) GO TO 50
      S = BB(R,S)
      GO TO 30
   50 UB = LUB - VB
      IFLAG = 1
      RETURN
   60 I1 = I - 1
      IF ( I1 .LT. 1 ) GO TO 80
      IQ = 0
      DO 70 R=1,I1
        IQ = IQ + Q(R)
   70 CONTINUE
      IF ( IQ .GT. LRI ) RETURN
   80 DO 90 J=1,N
        IF ( B(J) .EQ. 1 ) GO TO 90
        IF ( LXI(J) .EQ. 0 ) RETURN
   90 CONTINUE
      UB = LUBI - VB
      IFLAG = 1
      RETURN
      END
      SUBROUTINE SKNP (NS,QS,KUB,VS,N,NP1,N5,PS,WS,XS,IWK)
C
C SUBROUTINE TO SOLVE THE 0-1 SINGLE KNAPSACK PROBLEM
C
C MAXIMIZE    VS = PS(1)*XS(1) + ... + PS(NS)*XS(NS)
C SUBJECT TO       WS(1)*XS(1) + ... + WS(NS)*XS(NS) .LE. QS
C                  XS(J) = 0 OR 1   FOR  J=1,...,NS
C                  VS .GT. KUB
C
C THIS SUBROUTINE IS A MODIFIED VERSION OF SUBROUTINE KP01
C WHICH APPEARED IN  COMPUTING 21, 81-86(1978).
C
      INTEGER QS, VS
      INTEGER PS(NP1), WS(NP1), XS(N), IWK(N5)
C
      I1 = 1
      I2 = I1 + N
      I3 = I2 + N
      I4 = I3 + N
      I5 = I4 + N
      CALL SKNP1 (NS,QS,KUB,VS,N,NP1,PS,WS,XS,IWK(I1),IWK(I2),
     *            IWK(I3),IWK(I4),IWK(I5))
      RETURN
      END
      SUBROUTINE SKNP1 (NS,QS,KUB,VS,N,NP1,PS,WS,XS,D,MIN,
     *                  PBAR,WBAR,ZBAR)
C
C SUBROUTINE TO SOLVE THE 0-1 SINGLE KNAPSACK PROBLEM
C
C MAXIMIZE    VS = PS(1)*XS(1) + ... + PS(NS)*XS(NS)
C SUBJECT TO       WS(1)*XS(1) + ... + WS(NS)*XS(NS) .LE. QS
C                  XS(J) = 0 OR 1   FOR  J=1,...,NS
C                  VS .GT. KUB
C
C THIS SUBROUTINE IS A MODIFIED VERSION OF SUBROUTINE KP01
C WHICH APPEARED IN  COMPUTING 21, 81-86(1978).
C
      INTEGER QS,VS,DIFF,PR,R,T
      INTEGER PS(NP1),WS(NP1),XS(N)
      INTEGER D(N),MIN(N),PBAR(N),WBAR(N),ZBAR(N)
C
      VS = KUB
      IP = 0
      MS = QS
      DO 10 L=1,NS
        LL = L
        IF ( WS(L) .GT. MS ) GO TO 20
        IP = IP + PS(L)
        MS = MS - WS(L)
   10 CONTINUE
   20 LL = LL - 1
      IF ( MS .EQ. 0 ) GO TO 50
      PS(NS+1) = 0
      WS(NS+1) = QS + 1
      LIM = IP + (MS*PS(LL+2))/WS(LL+2)
      A = IP + PS(LL+1)
      B = (WS(LL+1) - MS)*PS(LL)
      C = WS(LL)
      LIM1 = A - B/C
      IF ( LIM1 .GT. LIM ) LIM = LIM1
      IF ( LIM .LE. VS ) RETURN
      MINK = QS + 1
      MIN(NS) = MINK
      DO 30 J=2,NS
        KK = NS + 2 - J
        IF ( WS(KK) .LT. MINK ) MINK = WS(KK)
        MIN(KK-1) = MINK
   30 CONTINUE
      DO 40 J=1,NS
        D(J) = 0
   40 CONTINUE
      PR = 0
      LOLD = NS
      II = 1
      GO TO 170
   50 IF ( VS .GE. IP ) RETURN
      VS = IP
      DO 60 J=1,LL
        XS(J) = 1
   60 CONTINUE
      NN = LL + 1
      DO 70 J=NN,NS
        XS(J) = 0
   70 CONTINUE
      QS = 0
      RETURN
   80 IF ( WS(II) .LE. QS ) GO TO 90
      II1 = II + 1
      IF ( VS .GE. (QS*PS(II1))/WS(II1) + PR ) GO TO 280
      II = II1
      GO TO 80
   90 IP = PBAR(II)
      MS = QS - WBAR(II)
      IN = ZBAR(II)
      LL = NS
      IF ( IN .GT. NS) GO TO 110
      DO 100 L=IN,NS
        LL = L
        IF ( WS(L) .GT. MS ) GO TO 160
        IP = IP + PS(L)
        MS = MS - WS(L)
  100 CONTINUE
  110 IF ( VS .GE. IP + PR ) GO TO 280
      VS = IP + PR
      MFIRST = MS
      NN = II - 1
      DO 120 J=1,NN
        XS(J) = D(J)
  120 CONTINUE
      DO 130 J=II,LL
        XS(J) = 1
  130 CONTINUE
      IF ( LL .EQ. NS ) GO TO 150
      NN = LL + 1
      DO 140 J=NN,NS
        XS(J) = 0
  140 CONTINUE
  150 IF ( VS .NE. LIM ) GO TO 280
      QS = MFIRST
      RETURN
  160 L = LL
      LL = LL - 1
      IF ( MS .EQ. 0 ) GO TO 110
      IF ( VS .GE. PR + IP + (MS*PS(L))/WS(L) ) GO TO 280
  170 WBAR(II) = QS - MS
      PBAR(II) = IP
      ZBAR(II) = LL + 1
      D(II) = 1
      NN = LL - 1
      IF ( NN .LT. II ) GO TO 190
      DO 180 J=II,NN
        WBAR(J+1) = WBAR(J) - WS(J)
        PBAR(J+1) = PBAR(J) - PS(J)
        ZBAR(J+1) = LL + 1
        D(J+1) = 1
  180 CONTINUE
  190 J1 = LL + 1
      DO 200 J=J1,LOLD
        WBAR(J) = 0
        PBAR(J) = 0
        ZBAR(J) = J
  200 CONTINUE
      LOLD = LL
      QS = MS
      PR = PR + IP
      IF ( LL - (NS - 2) ) 240, 220, 210
  210 II = NS
      GO TO 250
  220 IF ( QS .LT. WS(NS) ) GO TO 230
      QS = QS - WS(NS)
      PR = PR + PS(NS)
      D(NS) = 1
  230 II = NS - 1
      GO TO 250
  240 II = LL + 2
      IF ( QS .GE. MIN(II-1) ) GO TO 80
  250 IF ( VS .GE. PR ) GO TO 270
      VS = PR
      DO 260 J=1,NS
        XS(J) = D(J)
  260 CONTINUE
      MFIRST = QS
      IF ( VS .EQ. LIM ) RETURN
  270 IF ( D(NS) .EQ. 0 ) GO TO 280
      D(NS) = 0
      QS = QS + WS(NS)
      PR = PR - PS(NS)
  280 NN = II - 1
      IF ( NN .EQ. 0 ) GO TO 300
      DO 290 J=1,NN
        KK = II - J
        IF ( D(KK) .EQ. 1 ) GO TO 310
  290 CONTINUE
  300 QS = MFIRST
      RETURN
  310 R = QS
      QS = QS + WS(KK)
      PR = PR - PS(KK)
      D(KK) = 0
      IF ( R .LT. MIN(KK) ) GO TO 320
      II = KK + 1
      GO TO 80
  320 NN = KK + 1
      II = KK
  330 IF ( VS .GE. PR + (QS*PS(NN))/WS(NN) ) GO TO 280
      DIFF = WS(NN) - WS(KK)
      IF ( DIFF ) 390, 340, 350
  340 NN = NN + 1
      GO TO 330
  350 IF ( DIFF .GT. R ) GO TO 340
      IF ( VS .GE. PR + PS(NN) ) GO TO 340
      VS = PR + PS(NN)
      DO 360 J=1,KK
        XS(J) = D(J)
  360 CONTINUE
      JJ = KK + 1
      DO 370 J=JJ,NS
        XS(J) = 0
  370 CONTINUE
      XS(NN) = 1
      MFIRST = QS - WS(NN)
      IF ( VS .NE. LIM ) GO TO 380
      QS = MFIRST
      RETURN
  380 R = R - DIFF
      KK = NN
      NN = NN + 1
      GO TO 330
  390 T = R - DIFF
      IF ( T .LT. MIN(NN) ) GO TO 340
      N1 = NN + 1
      IF ( VS .GE. PR + PS(NN) + (T*PS(N1))/WS(N1) ) GO TO 280
      QS = QS - WS(NN)
      PR = PR + PS(NN)
      D(NN) = 1
      II = NN + 1
      WBAR(NN) = WS(NN)
      PBAR(NN) = PS(NN)
      ZBAR(NN) = II
      DO 400 J=N1,LOLD
        WBAR(J) = 0
        PBAR(J) = 0
        ZBAR(J) = J
  400 CONTINUE
      LOLD = NN
      GO TO 80
      END
      SUBROUTINE LAINV (MO,FUN,T,AERR,RERR,Y,C,ERROR,NUM,IERR)
C-----------------------------------------------------------------------
C
C             COMPUTATION OF THE INVERSE LAPLACE TRANSFORM
C              OF A FUNCTION WHICH IS NOT TOO OSCILLATORY
C
C                          ------------------
C
C     MO IS AN INPUT INTEGER WHICH SPECIFIES THE SEARCH PROCEDURE
C     FOR DETERMINATION OF C.  A TWO-PASS PROCEDURE IS USED WHEN
C     MO = 0 , AND A ONE-PASS PROCEDURE IS USED WHEN MO IS NOT ZERO.
C     WHEN ALL SINGULARITIES OF F(Z) ARE EXPECTED TO BE REAL, MO = 0
C     IS PREFERABLE.
C
C     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
C     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
C     FUN HAS THE ARGUMENTS X, Y, A, AND B.
C
C     T IS A POSITIVE VALUE OF THE INDEPENDENT VARIABLE FOR WHICH
C     THE INVERSE LAPLACE TRANSFORM IS TO BE CALCULATED.
C
C     C IS THE ABSCISSA OF CONVERGENCE.  IT MAY BE EITHER GIVEN
C     OR CALCULATED BY LAINV.
C
C     Y IS THE CALCULATED VALUE OF THE INVERSE LAPLACE TRANSFORM.
C
C     AERR IS THE ABSOLUTE ACCURACY REQUESTED.
C     RERR IS THE RELATIVE ACCURACY REQUESTED.  THE SUBROUTINE
C     ATTEMPTS TO SATISFY THE LESS STRINGENT OF THE TWO REQUIREMENTS.
C     IT IS ASSUMED THAT AERR AND RERR ARE .GE. 0.  IF ONE WANTS
C     ACCURACY TO K SIGNIFICANT FIGURES, THEN RERR SHOULD BE
C     SET = 10.0**(-K).
C
C     ERROR IS THE ESTIMATED ABSOLUTE ERROR OF Y.
C
C     NUM IS THE NUMBER OF EVALUATIONS OF FUN IN LAINV.
C
C     IERR MAY BE EITHER AN INPUT INTEGER OR AN OUTPUT INTEGER.  WHEN
C     IERR IS EQUAL TO ANY NEGATIVE INTEGER AT THE BEGINNING OF LAINV,
C     THE ABSCISSA OF CONVERGENCE IS CALCULATED AND THE VALUE OBTAINED
C     IS ASSIGNED TO THE ARGUMENT C.  OTHERWISE, C MUST BE INPUT BY
C     THE USER.  AFTER COMPLETION OF LAINV, IERR HAS ONE OF THE
C     FOLLOWING VALUES...
C
C        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
C
C        IERR = 1   THE CALCULATED VALUE OF Y MAY NOT BE ACCURATE
C                   DUE TO POSSIBLE INACCURACY IN THE CALCULATION
C                   OF C.  THIS VALUE OF IERR MAY OCCUR ONLY WHEN
C                   IERR IS INITIALLY NEGATIVE.
C
C        IERR = 2   THE CALCULATION OF Y DID NOT CONVERGE, WHILE
C                   THE GIVEN OR CALCULATED VALUE OF C MAY BE
C                   CONSIDERED ACCURATE.
C
C        IERR = 3   THE CALCULATION OF Y DID NOT CONVERGE, AND THE
C                   CALCULATED VALUE OF C MAY BE INACCURATE.  THIS
C                   VALUE OF IERR MAY OCCUR ONLY WHEN IERR IS
C                   INITIALLY NEGATIVE.
C
C        IERR = 4   THE VALUE OF T IS LESS THAN OR EQUAL TO 0.
C                   THE SPECIAL VALUES Y = 0.0 AND ERROR = 1.0
C                   ARE ASSIGNED.
C
C        IERR = 5   C WAS NOT FOUND IN THE INTERVAL (-1.0E4,1.0E4).
C                   THE SPECIAL VALUES C = 0.0, Y = 0.0, AND
C                   ERROR = 1.0 ARE ASSIGNED.
C                   THIS VALUE OF IERR MAY OCCUR ONLY WHEN
C                   IERR IS INITIALLY NEGATIVE.
C
C        IERR = 6   T IS TOO LARGE FOR THE INVERSE TRANSFORM TO BE
C                   COMPUTED. THE VALUES Y = 0.0 AND ERROR = 1.0
C                   ARE ASSIGNED.
C
C-----------------------------------------------------------------------
      EXTERNAL FUN
C
      NUM = 0
      IERC = -1
      IF (IERR .GE. 0) GO TO 10
C
C     CALCULATION OF THE ABSCISSA OF CONVERGENCE.
C
      IF (MO .EQ. 0) GO TO 5
         CALL ABCON1 (FUN,C,NUM,IERC)
         GO TO 10
    5 CALL ABCON (FUN,C,NUM,IERC)
   10 IF (IERC .EQ. 2) GO TO 100
C
C     CHECK IF T IS TOO LARGE
C
      A = C + 2.0/T
      IF (A*T .GT. EXPARG(0)) GO TO 110
C
C     CALCULATION OF THE INVERSE LAPLACE TRANSFORM.
C
      CALL LAINV1 (FUN,T,C,RERR,AERR,Y,ERROR,NUM1,IER)
      NUM = NUM + NUM1
C
C     REPORT THE STATUS OF THE RESULTS.
C
      IF (IERC .GE. 0) GO TO 20
      IF (IER  .EQ. 0) GO TO 30
      IF (IER  .EQ. 1) GO TO 50
   20 IF (IER  .EQ. 2) GO TO 80
      IF (IER  .EQ. 1) GO TO 60
      IF (IERC .EQ. 1) GO TO 40
C
   30 IERR = 0
      RETURN
   40 IERR = 1
      RETURN
   50 IERR = 2
      RETURN
   60 IF (IERC .EQ. 1) GO TO 70
         IERR = 2
         RETURN
   70 IERR = 3
      RETURN
   80 IERR = 4
      RETURN
C
  100 Y = 0.0
      ERROR = 1.0
      IERR = 5
      RETURN
  110 Y = 0.0
      ERROR = 1.0
      IERR = 6
      RETURN
      END
      SUBROUTINE ABCON (FUN, C, NUM, IERR)
C-----------------------------------------------------------------------
C
C             COMPUTATION OF THE ABSCISSA OF CONVERGENCE
C             OF A FUNCTION WHICH IS NOT TOO OSCILLATORY
C
C                         -----------------
C
C     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
C     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
C     FUN HAS THE ARGUMENTS X, Y, A, AND B.
C
C     C IS THE CALCULATED VALUE OF THE ABSCISSA OF CONVERGENCE.
C
C     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
C     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
C
C     IERR IS AN OUTPUT INTEGER REPORTING THE STATUS OF THE
C     CALCULATION OF C.  IERR IS ASSIGNED VALUES AS FOLLOWS...
C
C        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
C
C        IERR = 1   THE REQUESTED ACCURACY MAY NOT HAVE BEEN
C                   OBTAINED.  MORE SUBINTERVALS MAY BE REQUIRED
C                   IN THE NUMERICAL QUADRATURES IN SUBROUTINES
C                   ACOND AND XCOND.
C
C        IERR = 2   C COULD NOT BE CALCULATED WITH SUFFICIENT
C                   ACCURACY, OR AN INTERVAL CONTAINING C COULD
C                   NOT BE FOUND. THE SPECIAL VALUE C = 0.0 IS
C                   ASSIGNED.
C
C-----------------------------------------------------------------------
      LOGICAL FIND
      EXTERNAL FUN, ACOND, XCOND
C
      ETA = 0.01
      XMIN = -1.00358E4
C
C     CALCULATION OF THE LOCATION OF THE SINGULARITY ON THE REAL
C     AXIS WHICH IS FARTHEST TO THE RIGHT. SET THIS VALUE TO X0.
C
      CALL SRCH(FUN, XCOND, XMIN, ETA, X0, NUM, IERR)
      C = X0
      IF (IERR .EQ. 2) GO TO 20
      IF (IERR .EQ. 3) GO TO 10
C
C     CHECK IF X0 IS ON THE RIGHT OR LEFT OF THE ABSCISSA OF
C     CONVERGENCE. IF IT IS ON THE RIGHT THEN WE ARE DONE.
C
      CALL ACOND(FUN, X0, FIND, NUM1, IERR)
      NUM = NUM + NUM1
      IF (FIND) GO TO 20
C
C     SEARCH TO THE RIGHT OF X0 TO FIND THE ABSCISSA OF
C     CONVERGENCE.
C
   10 CALL SRCH(FUN, ACOND, X0, ETA, C, NUM1, IERR)
      NUM = NUM + NUM1
      IF (IERR .EQ. 3) C = 0.0
C
C     TERMINATION
C
   20 IERR = MIN0(IERR,2)
      RETURN
      END
      SUBROUTINE SRCH (FUN,COND,XL,ETA,X,NUM,IERR)
C-----------------------------------------------------------------------
C     SRCH COMPUTES AN UPPER BOUND FOR THE SMALLEST NUMBER X SUCH
C     THAT A GIVEN CONDITION IS SATISFIED. IT IS ASSUMED THAT THE
C     CONDITION IS SATISFIED FOR SUFFICIENTLY LARGE X.
C-----------------------------------------------------------------------
C     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
C     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
C     FUN HAS THE ARGUMENTS X, Y, A, AND B.
C
C     COND IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
C     FOR COND NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
C     COND HAS THE ARGUMENTS FUN, X, CND, AND IER, WHERE CND IS
C     A LOGICAL VARIABLE.
C
C     XL IS THE SMALLEST VALUE OF X FOR WHICH A SEARCH IS MADE.  IT
C     SHOULD LIE IN THE RANGE - 1.0E4 .LE. XL .LT. 1.0E4.  IT IS
C     ASSUMED THAT THE LOGICAL VARIABLE CND CALCULATED BY COND IS
C     .FALSE. WHEN X = XL.
C
C     ETA IS THE RELATIVE TOLERANCE TO WHICH THE RESULT IS TO BE
C     DETERMINED. IT IS A POSITIVE REAL NUMBER. WHEN THIS SUBROUTINE
C     IS USED TO CALCULATE C FOR USE IN THE PIESSENS CODE LAINV1
C     (ALGORITHM 619), IT IS USUALLY SUFFICIENT TO TAKE ETA = 0.01.
C
C     X IS THE CALCULATED RESULT.  IT IS LARGER THAN THE EXACT
C     RESULT BY AN AMOUNT LESS THAN ETA*X.
C
C     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
C     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
C
C     IERR IS AN OUTPUT INTEGER REPORTING THE STATUS OF THE
C     CALCULATION OF X.  IERR IS ASSIGNED VALUES AS FOLLOWS...
C
C          IERR = 0     THE CALCULATION WAS FULLY SUCCESSFUL.
C
C          IERR = 1     X MAY BE IN ERROR DUE TO THE CALCULATION
C                       OF COND.
C
C          IERR = 2     CND IS .FALSE. WHEN X = 1.0E4.  X IS SET = 0.0.
C
C          IERR = 3     CND IS .TRUE. FOR  X .GE. XL.  X IS SET TO XL.
C
      LOGICAL CND
      EXTERNAL FUN, COND
      IERR = 0
C
C     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
C     X1 .GE. 0.01269
C
      X1 = AMAX1(.01269, XL)
      CALL COND(FUN,X1,CND,NUM,IER)
      IF (CND) GO TO 20
C
         X2 = 10.1269
         DO 10 I = 1,4
            IF (X2 .LE. X1) GO TO 10
            CALL COND(FUN,X2,CND,NUM1,IER)
            NUM = NUM + NUM1
            IF (CND) GO TO 200
            X1 = X2
   10       X2 = 10.0*X2
         GO TO 300
C
   20 IF (X1 .EQ. XL) GO TO 400
C
C     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
C     X2 .LE. 0.01269
C
         X2 = X1
         X1 = -.100358
         DO 30 I = 1,6
            X1 = AMAX1(X1, XL)
            CALL COND(FUN,X1,CND,NUM1,IER)
            NUM = NUM + NUM1
            IF(.NOT. CND) GO TO 200
            X2 = X1
            IF (X1 .EQ. XL) GO TO 400
   30    X1 = 10.0*X1
C
C     SEARCH FOR X IN THE INTERVAL (X1, X2) BY BISECTION
C
  200       DX = X2 - X1
            XBAR = X1 + DX/2.0
            CALL COND(FUN,XBAR,CND,NUM1,IERR)
            NUM = NUM + NUM1
            XM = AMAX1(ABS(X1), ABS(X2))
            TOL = ETA
            IF (XM .GT. 1.0) TOL = ETA*XM
            IF (DX .LE. TOL) GO TO 250
               IF(CND) GO TO 225
                  X1 = XBAR
                  GO TO 200
  225          X2 = XBAR
               GO TO 200
C
C     FINAL ASSEMBLY
C
  250       IF(CND) GO TO 275
               X = X2
               RETURN
  275       X = XBAR
            RETURN
C
C     ERROR RETURN WHEN X COULD NOT BE FOUND IN THE INTERVAL
C     (-1.0E4, 1.OE4).
C
  300 X = 0.0
      IERR = 2
      RETURN
  400 X = XL
      IERR = 3
      RETURN
      END
      SUBROUTINE ABCON1 (FUN, C, NUM, IERR)
C-----------------------------------------------------------------------
C
C             COMPUTATION OF THE ABSCISSA OF CONVERGENCE
C             OF A FUNCTION WHICH IS NOT TOO OSCILLATORY
C
C                         -----------------
C
C     FUN IS A REAL SUBROUTINE DEFINED BY THE USER. THE ACTUAL NAME
C     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
C     FUN HAS THE ARGUMENTS X, Y, A, AND B.
C
C     C IS THE CALCULATED VALUE OF THE ABSCISSA OF CONVERGENCE.
C
C     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
C     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
C
C     IERR IS AN OUTPUT INTEGER REPORTING THE STATUS OF THE
C     CALCULATION OF C.  IERR IS ASSIGNED VALUES AS FOLLOWS...
C
C        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
C
C        IERR = 1   THE REQUESTED ACCURACY MAY NOT HAVE BEEN
C                   OBTAINED.  MORE SUBINTERVALS MAY BE REQUIRED
C                   IN THE NUMERICAL QUADRATURES IN SUBROUTINES
C                   ACOND AND XCOND.
C
C        IERR = 2   C COULD NOT BE CALCULATED WITH SUFFICIENT
C                   ACCURACY, OR AN INTERVAL CONTAINING C COULD
C                   NOT BE FOUND. THE SPECIAL VALUE C = 0.0 IS
C                   ASSIGNED.
C
C-----------------------------------------------------------------------
      LOGICAL CMPLEX, IEND, RIGHT
      EXTERNAL FUN, ACOND, XCOND
C
      ETA = 0.01
      CMPLEX = .FALSE.
C
      X1 = .01269
      CALL XCOND (FUN,X1,RIGHT,NUM,IERR)
      IF (.NOT. RIGHT) GO TO 10
      CALL ACOND (FUN,X1,RIGHT,NUM1,IERR)
      NUM = NUM + NUM1
      IF (RIGHT) GO TO 30
      CMPLEX = .TRUE.
C
C     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
C     X1 .GE. 0.01269
C
   10    X2 = 10.1269
         DO 22 I = 1,4
            IF (CMPLEX) GO TO 20
               CALL XCOND (FUN,X2,RIGHT,NUM1,IERR)
               NUM = NUM + NUM1
               IF (.NOT. RIGHT) GO TO 21
   20       CALL ACOND (FUN,X2,RIGHT,NUM1,IERR)
            NUM = NUM + NUM1
            IF (RIGHT) GO TO 50
            CMPLEX = .TRUE.
   21       X1 = X2
            X2 = 10.0*X2
   22    CONTINUE
         GO TO 100
C
C     SEARCH FOR AN INTERVAL (X1, X2) CONTAINING X WHERE
C     X2 .LE. 0.01269
C
   30    X2 = X1
         X1 = -.100358
         DO 40 I = 1,6
            CALL XCOND (FUN,X1,RIGHT,NUM1,IERR)
            NUM = NUM + NUM1
            IF (.NOT. RIGHT) GO TO 50
            CALL ACOND (FUN,X1,RIGHT,NUM1,IERR)
            NUM = NUM + NUM1
            IF (.NOT. RIGHT) GO TO 45
            X2 = X1
            X1 = 10.0*X1
   40    CONTINUE
         GO TO 100
C
   45    CMPLEX = .TRUE.
C
C     SEARCH FOR X IN THE INTERVAL (X1, X2) BY BISECTION
C
   50       DX = X2 - X1
            XBAR = X1 + DX/2.0
            XM = AMAX1(ABS(X1), ABS(X2))
            TOL = ETA
            IF (XM .GT. 1.0) TOL = ETA*XM
            IEND =  DX .LE. TOL
C
            IF (CMPLEX) GO TO 60
            CALL XCOND (FUN,XBAR,RIGHT,NUM1,IERR)
            NUM = NUM + NUM1
            IF (RIGHT) GO TO 60
               IF (IEND) GO TO 80
               X1 = XBAR
               GO TO 50
C
   60       CALL ACOND (FUN,XBAR,RIGHT,NUM1,IERR)
            NUM = NUM + NUM1
            IF (RIGHT) GO TO 70
               IF (IEND) GO TO 80
               X1 = XBAR
               CMPLEX = .TRUE.
               GO TO 50
   70       X2 = XBAR
            IF (.NOT. IEND) GO TO 50
C
C     STANDARD TERMINATION
C
   80    C = X2
         RETURN
C
C     ERROR RETURN WHEN X CANNOT BE FOUND IN (-1.E4, 1.E4)
C
  100 C = 0.0
      IERR = 2
      RETURN
      END
      SUBROUTINE ACOND (FUN, X, COND, NUM, IERR)
C-----------------------------------------------------------------------
C
C        THIS SUBROUTINE TESTS WHETHER OR NOT A GIVEN VALUE OF X
C        LIES TO THE RIGHT OF THE ABSCISSA OF CONVERGENCE OF THE
C        COMPLEX FUNCTION DEFINED BY FUN WHEN NO SINGULARITIES LIE
C        ON THE REAL AXIS.
C
C                      ----------------
C
C     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
C     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
C     FUN HAS THE ARGUMENTS X, Y, A, AND B.
C
C     X IS A REAL NUMBER. THE LOGICAL VARIABLE COND = .TRUE. IF
C     X .GT. C, WHERE C IS THE ABSCISSA OF CONVERGENCE, AND .FALSE.
C     IF X .LT. C.
C
C     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
C     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
C
C     IERR IS AN OUTPUT INTEGER INDICATING THE STATUS OF THE
C     CALCULATION. IT IS ASSIGNED VALUES AS FOLLOWS...
C
C        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
C
C        IERR = 1   THE CALCULATION OF COND MAY NOT BE
C                   ACCURATE FOR ALL VALUES OF X.
C
C-----------------------------------------------------------------------
      DIMENSION IWK(100), WK(400)
      LOGICAL COND
      EXTERNAL FUN, ACONDF, ACONDG
C--------------------------
      DATA L /100/, M /400/
      DATA AERR /1.E-30/, RERR /1.E-4/, TOL /1.E-4/
C--------------------------
      C = X
C
C     CALCULATION OF THE INTEGRAL OF ACONDF FROM X TO INFINITY.
C
      CALL QAGI1 (ACONDF,FUN,Y,C,X,1,AERR,RERR,Z1,ERROR1,NUM1,IER1,
     *            L,M,N,IWK,WK)
C
C     CALCULATION OF THE INTEGRAL OF ACONDG FROM 0 TO INFINITY.
C
      A = 0.0
      CALL QAGI1 (ACONDG,FUN,Y,C,A,1,AERR,RERR,Z2,ERROR2,NUM2,IER2,
     *            L,M,N,IWK,WK)
      NUM = NUM1 + NUM2
      IER = MAX0(IER1, IER2)
C
C     DETERMINATION OF COND.
C
      COND = .FALSE.
      IF (ABS(Z1 - Z2) .LE. TOL*AMAX1(ABS(Z1),ABS(Z2))) COND = .TRUE.
C
C     SET IERR AND RETURN
C
      IERR = 0
      IF (IER .GT. 4) IERR = 1
      RETURN
      END
      FUNCTION ACONDF (X, Y, C, FUN)
C-----------------------------------------------------------------------
C        ACONDF IS THE FUNCTION INTEGRATED ALONG THE X-AXIS IN
C        ACOND. Y IS A DUMMY VARIABLE.
C-----------------------------------------------------------------------
      EXTERNAL FUN
C
      CALL FUN (X, 0.0, A, B)
      T = 1.0/((X - C) + 1.0)
      ACONDF = A*T*T
      RETURN
      END
      FUNCTION ACONDG (X, Y, C, FUN)
C-----------------------------------------------------------------------
C        ACONDG IS THE FUNCTION INTEGRATED ALONG THE LINE X = C
C        IN ACOND. Y IS A DUMMY VARIABLE.
C-----------------------------------------------------------------------
      EXTERNAL FUN
C
      CALL FUN (C, X, A, B)
      CALL CREC (1.0, X, S, T)
      U = S*S - T*T
      V = 2.0*S*T
      ACONDG = -(A*V + B*U)
      RETURN
      END
      SUBROUTINE XCOND (FUN, X, COND, NUM, IERR)
C-----------------------------------------------------------------------
C
C        THIS SUBROUTINE TESTS WHETHER OR NOT A GIVEN VALUE OF X
C        LIES TO THE RIGHT OF ALL SINGULARITIES OF THE COMPLEX
C        FUNCTION DEFINED BY FUN WHICH LIE ON THE REAL AXIS.
C
C                         ------------
C
C     FUN IS A REAL SUBROUTINE DEFINED BY THE USER.  THE ACTUAL NAME
C     FOR FUN NEEDS TO BE DECLARED EXTERNAL IN THE DRIVER PROGRAM.
C     FUN HAS THE ARGUMENTS X, Y, A, AND B.
C
C     X IS A REAL NUMBER.  THE LOGICAL VARIABLE COND = .TRUE IF
C     X .GT. C, WHERE C IS THE ABSCISSA OF THE SINGULARITY ON THE
C     REAL AXIS WHICH LIES FARTHEST TO THE RIGHT, AND .FALSE. IF
C     X .LT. C.
C
C     NUM IS A VARIABLE. ON OUTPUT IT HAS FOR ITS VALUE THE NUMBER
C     OF EVALUATIONS OF FUN THAT WERE PERFORMED.
C
C     IERR IS AN OUTPUT INTEGER INDICATING THE STATUS OF THE
C     CALCULATION.  IT IS ASSIGNED VALUES AS FOLLOWS...
C
C        IERR = 0   THE CALCULATION WAS SUCCESSFUL.
C
C        IERR = 1   THE CALCULATION OF COND MAY NOT BE
C                   ACCURATE FOR ALL VALUES OF X.
C
C-----------------------------------------------------------------------
      DIMENSION IWK(100), WK(400)
      LOGICAL COND
      EXTERNAL FUN, XCONDX, XCONDY
C--------------------------
      DATA L /100/, M /400/
      DATA AERR /1.E-30/, RERR /1.E-4/, TOL /1.E-4/
      DATA EPSR /1.E-2/
C--------------------------
      C = 1.0 - X
      Y = EPSR
      COND = .FALSE.
C
C     NUMERICAL INTEGRATION OF THE IMAGINARY PART OF THE INTEGRAND
C     ALONG THE LINE Y = EPSR.
C
      CALL QAGI1 (XCONDY,FUN,Y,C,X,1,AERR,RERR,Z,ERROR,NUM,IERR,
     *            L,M,N,IWK,WK)
      IF (IERR .NE. 0) GO TO 100
C
C     DETERMINATION OF COND.
C
      Y1 = 0.5*Y
      T = (XCONDX(X,Y,C,FUN) + 4.0*XCONDX(X,Y1,C,FUN) +
     *           XCONDX(X,0.0,C,FUN))*EPSR/6.0
      NUM = NUM + 3
      IF (T*Z .GT. 0.0) RETURN
      IF (ABS(T + Z) .GT. TOL*AMAX1(ABS(T), ABS(Z))) RETURN
         COND = .TRUE.
         RETURN
C
C     ERROR RETURN
C
  100 IERR = 1
      RETURN
      END
      FUNCTION XCONDX (X,Y,C,FUN)
C
C     REAL PART OF THE INTEGRAND IN XCOND
C
      EXTERNAL FUN
C
      CALL FUN (X, Y, A, B)
      CALL CREC (X + C, Y, S, T)
      U = S*S - T*T
      V = 2.0*S*T
      XCONDX = A*U - B*V
      RETURN
      END
      FUNCTION XCONDY (X,Y,C,FUN)
C
C     IMAGINARY PART OF INTEGRAND IN XCOND
C
      EXTERNAL FUN
C
      CALL FUN (X, Y, A, B)
      CALL CREC (X + C, Y, S, T)
      U = S*S - T*T
      V = 2.0*S*T
      XCONDY = A*V + B*U
      RETURN
      END
       SUBROUTINE LAINV1(FUN,T,C,EPSRE,EPSAB,RESULT,ESTERR,NUM,
     *   IER)
C
C ......................................................................
C
C   1. LAINV1
C        INVERSION OF LAPLACE TRANSFORM USING THE DURBIN FORMULA
C        IN COMBINATION WITH THE EPSILON ALGORITHM
C
C   2. PURPOSE
C        THE ROUTINE CALCULATES AN APPROXIMATION RESULT TO THE
C        INVERSE LAPLACE TRANSFORM F(T) OF FUN, FOR THE VALUE
C        OF THE INDEPENDENT VARIABLE EQUAL TO T, HOPEFULLY
C        SATISFYING THE FOLLOWING CLAIM FOR ACCURACY ....
C        ABS(F(T)-RESULT).LE.MAX(EPSAB,EPSRE*ABS(F(T)))
C
C   3. CALLING SEQUENCE
C        CALL LAINV1(FUN,T,C,EPSRE,EPSAB,RESULT,ESTERR,NUM,IER)
C
C      INPUT PARAMETERS
C        FUN    - REAL
C                 SUBROUTINE DEFINING THE LAPLACE TRANSFORM AS
C                 A COMPLEX FUNCTION.  THE CALLING SEQUENCE OF
C                 FUN IS CALL FUN(A,B,C,D) WHERE
C                 A - REAL
C                     REAL PART OF THE INDEPENDENT VARIABLE
C                     OF THE LAPLACE TRANSFORM (INPUT)
C                 B - REAL
C                     IMAGINARY PART OF THE INDEPENDENT
C                     VARIABLE OF THE LAPLACE TRANSFORM (INPUT)
C                 C - REAL
C                     REAL PART OF THE VALUE OF THE LAPLACE
C                     TRANSFORM (OUTPUT)
C                 D - REAL
C                     IMAGINARY PART OF THE VALUE OF THE
C                     LAPLACE TRANSFORM (OUTPUT)
C                 THE ACTUAL NAME FOR FUN NEEDS TO BE DECLARED
C                 EXTERNAL IN THE DRIVER PROGRAM.
C
C        T      - REAL
C                 VALUE OF THE INDEPENDENT VARIABLE FOR WHICH THE
C                 INVERSE LAPLACE TRANSFORM HAS TO BE COMPUTED.
C                 T SHOULD BE GREATER THAN ZERO.
C
C        C      - REAL
C                 ABSCISSA OF CONVERGENCE OF THE LAPLACE TRANSFORM
C
C        EPSRE  - REAL
C                 RELATIVE ACCURACY REQUESTED.  IT IS ASSUMED THAT
C                 EPSRE .GE. 0.  IF ONE WANTS ACCURACY TO K SIGNIFICANT
C                 FIGURES, THEN RERR SHOULD BE SET = 10.0**(-K).
C
C        EPSAB  - REAL
C                 ABSOLUTE ACCURACY REQUESTED.  IT IS ASSUMED THAT
C                 EPSAB .GE. 0.  THE ROUTINE TRIES TO SATISFY THE
C                 LEAST STRINGENT OF BOTH ACCURACY REQUIREMENTS.
C
C      OUTPUT PARAMETERS
C        RESULT - REAL
C                 INVERSE LAPLACE TRANSFORM
C
C        ESTERR - REAL
C                 ESTIMATE OF THE ABSOLUTE ERROR ABS(F(T)-RESULT)
C
C        NUM    - INTEGER
C                 NUMBER OF EVALUATIONS OF FUN
C
C        IER    - INTEGER
C                 PARAMETER GIVING INFORMATION ON THE TERMINATION
C                 OF THE ALGORITHM
C                 IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
C                         ROUTINE
C                 IER = 1 THE COMPUTATIONS ARE TERMINATED BECAUSE
C                         THE BOUND ON THE NUMBER OF EVALUATIONS
C                         OF FUN HAS BEEN ACHIEVED.  THIS BOUND
C                         IS EQUAL TO 8*MAX+5 WHERE  MAX  IS A
C                         NUMBER INITIALIZED IN A DATA
C                         STATEMENT.  ONE CAN ALLOW MORE FUNCTION
C                         EVALUATIONS BY INCREASING THE VALUE OF
C                         MAX IN THE DATA-STATEMENT.
C                 IER = 2 THE VALUE OF T IS LESS THAN OR EQUAL
C                         TO ZERO.
C
C   4. SUBROUTINES OR FUNCTIONS NEEDED
C                FUN - USER PROVIDED SUBROUTINE
C                CQEXT - EPSILON ALGORITHM
C                SPMPAR - THIS FUNCTION IS CALLED BY
C                          CQEXT, AND PROVIDES MACHINE CONSTANTS
C                ATAN, EXP, AMAX1, SIN, ABS,
C                DBLE, CMPLX, REAL - FORTRAN FUNCTIONS
C
C ......................................................................
C
      COMPLEX REX,CRES,RES3LA
      INTEGER I,IER,K,KC,KK,KS,M,NEX,NRES,NUM
      DIMENSION SI(32),RES3LA(3),REX(52)
C
C   THE ARRAY SI CONTAINS VALUES OF THE SINE AND COSINE FUNCTIONS
C   REQUIRED IN THE DURBIN FORMULA. SI(8) AND SI(16) ARE GIVEN IN
C   THE FOLLOWING DATA STATEMENT. THE OTHER VALUES ARE COMPUTED.
C
      DATA SI(8),SI(16)/ 1.0E+00,0.0E+00/
C
C   MAX IS A BOUND ON THE NUMBER OF TERMS USED IN THE DURBIN
C   FORMULA.
C
      DATA MAX/500/
C ....................................................
C
C   EPS IS A MACHINE DEPENDENT CONSTANT.  EPS IS THE
C   SMALLEST NUMBER SUCH THAT 1 + EPS .GT. 1.
C
      EPS = SPMPAR(1)
C ....................................................
C
C   CALCULATION OF THE RELATIVE TOLERANCE USED.
C
      TOL = 10.0*EPS
      EPSR1 = AMAX1(TOL,EPSRE)
C
C   TEST ON VALIDITY OF THE INPUT PARAMETER T
C
      IER = 2
      RESULT = 0.0E+00
      ESTERR = 1.0E+00
      NUM = 0
      IF (T.LE.0.0E+00) GO TO 999
C
C   PID16 IS EQUAL TO PI/16
C
      PID16 = ATAN(1.0E+00)/4.0E+00
C
C   COMPUTATION OF THE ELEMENTS OF THE ARRAY SI
C
      AK = 1.0E+00
      DO 10 K=1,7
        SI(K) = SIN(AK*PID16)
        AK = AK+1.0E+00
        KK = 16-K
        SI(KK) = SI(K)
10    CONTINUE
      IER = 0
      NRES = 0
      DO 20 K=17,32
        SI(K) = -SI(K-16)
20    CONTINUE
C
C   INITIALIZATION OF THE SUMMATION OF THE DURBIN FORMULA.
C
      ARG = PID16/T
      ARE = C+2.0E+00/T
      AIM = 0.0E+00
      BB = EXP(ARE*T)/(1.6E+01*T)
      CALL FUN (ARE,AIM,FRE,FIM)
      NUM = 5
      R = 5.0E-01*FRE
      S = 0.0
      NEX = 0
      KC = 8
      KS = 0
C
C   MAIN LOOP FOR THE SUMMATION
C
      DO 40 I=1,MAX
        M = 8
        IF (I.EQ.1) M = 12
        DO 30 K=1,M
          AIM = AIM+ARG
          KC = KC+1
          KS = KS+1
          IF (KC.GT.32) KC = 1
          IF (KS.GT.32) KS = 1
          CALL FUN(ARE,AIM,FRE,FIM)
      A = FRE*SI(KC)
      B = -FIM*SI(KS)
      R = DBLE(R) + DBLE(A) + DBLE(B)
      E = FRE*SI(KS)
      F = FIM*SI(KC)
      S = DBLE(S) + DBLE(E) + DBLE(F)
30      CONTINUE
        NUM = NUM+8
        NEX = NEX+1
        REX(NEX) = CMPLX(R, S)
C
C   EXTRAPOLATION USING THE EPSILON ALGORITHM
C
        IF(NEX.GE.3) CALL CQEXT(NEX,REX,CRES,ESTERR,RES3LA,NRES)
        IF(NRES.LT.4) GO TO 40
C
C   COMPUTATION OF INTERMEDIATE RESULT AND ESTIMATE OF THE
C   ABSOLUTE ERROR
C
        RESULT = REAL(CRES)
        RESULT = RESULT * BB
        ESTERR = ESTERR * BB
        IF (ESTERR.LT.AMAX1(EPSAB,EPSR1*ABS(RESULT)).AND.ABS(R*BB-
     *   RESULT).LT.5.0E-01*ABS(RESULT)) GO TO 999
40    CONTINUE
C
C   SET ERROR FLAG IN THE CASE THAT THE NUMBER OF TERMS IN THE
C   SUMMATION IS EQUAL TO MAX
C
      IER = 1
999   RETURN
      END
      SUBROUTINE CQEXT(N,EPSTAB,RESULT,ABSERR,RES3LA,NRES)
C
C 1.        CQEXT
C           EPSILON ALGORITHM
C              STANDARD FORTRAN SUBROUTINE
C              COMPLEX VERSION
C
C 2.        PURPOSE
C              THE ROUTINE DETERMINES THE LIMIT OF A GIVEN SEQUENCE OF
C              APPROXIMATIONS, BY MEANS OF THE EPSILON ALGORITHM
C              OF P. WYNN.
C              AN ESTIMATE OF THE ABSOLUTE ERROR IS ALSO GIVEN.
C              THE CONDENSED EPSILON TABLE IS COMPUTED. ONLY THOSE
C              ELEMENTS NEEDED FOR THE COMPUTATION OF THE NEXT DIAGONAL
C              ARE PRESERVED.
C
C 3.        CALLING SEQUENCE
C              CALL CQEXT(N,EPSTAB,RESULT,ABSERR,RES3LA,NRES)
C
C           PARAMETERS
C              N      - INTEGER
C                       EPSTAB(N) CONTAINS THE NEW ELEMENT IN THE
C                       FIRST COLUMN OF THE EPSILON TABLE.
C
C              EPSTAB - COMPLEX
C                       VECTOR OF DIMENSION 52 CONTAINING THE ELEMENTS
C                       OF THE TWO LOWER DIAGONALS OF THE
C                       TRIANGULAR EPSILON TABLE
C                       THE ELEMENTS ARE NUMBERED STARTING AT THE
C                       RIGHT-HAND CORNER OF THE TRIANGLE.
C
C              RESULT - COMPLEX
C                       RESULTING APPROXIMATION TO THE INTEGRAL
C
C              ABSERR - REAL
C                       ESTIMATE OF THE ABSOLUTE ERROR OF THE REAL
C                       PART OF RESULT COMPUTED FROM RESULT AND
C                       THE 3 PREVIOUS RESULTS
C
C              RES3LA - COMPLEX
C                       VECTOR OF DIMENSION 3 CONTAINING THE LAST 3
C                       RESULTS
C
C              NRES   - INTEGER
C                       NUMBER OF CALLS TO THE ROUTINE
C                       (SHOULD BE ZERO AT FIRST CALL)
C
C 4.        SUBROUTINES OR FUNCTIONS NEEDED
C                     - SPMPAR, CDIVID
C                     - FORTRAN ABS, AMAX1, CABS, CMPLX,
C                       REAL, AIMAG, SNGL
C
C     ..................................................................
C
      COMPLEX DELTA1,DELTA2,DELTA3,
     *  EPSTAB,E0,E1,E2,E3,
     *  RES,RESULT,RES3LA,SS
      DOUBLE PRECISION R,S,U1,U2,U3,V1,V2,V3,SS1,SS2,W1,W2
      INTEGER I,IB,IB2,IE,INDX,K1,K2,K3,LIMEXP,N,NEWELM,NRES,NUM
      DIMENSION EPSTAB(52),RES3LA(3)
C
C           LIST OF MAJOR VARIABLES
C           -----------------------
C
C           E0     - THE 4 ELEMENTS ON WHICH THE
C           E1       COMPUTATION OF A NEW ELEMENT IN
C           E2       THE EPSILON TABLE IS BASED
C           E3                 E0
C                        E3    E1    NEW
C                              E2
C           NEWELM - NUMBER OF ELEMENTS TO BE COMPUTED IN THE NEW
C                    DIAGONAL
C           ERROR  - ERROR = ABS(E1-E0)+ABS(E2-E1)+ABS(NEW-E2)
C           RESULT - THE ELEMENT IN THE NEW DIAGONAL WITH LEAST VALUE
C                    OF ERROR
C
C           MACHINE DEPENDENT CONSTANTS
C           ---------------------------
C
C           EPMACH IS THE LARGEST RELATIVE SPACING.
C           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
C           LIMEXP IS THE MAXIMUM NUMBER OF ELEMENTS THE EPSILON
C           TABLE CAN CONTAIN. IF THIS NUMBER IS REACHED, THE UPPER
C           DIAGONAL OF THE EPSILON TABLE IS DELETED.
C
C***FIRST EXECUTABLE STATEMENT
      OFLOW = SPMPAR(3)
      EPMACH = SPMPAR(1)
      NRES = NRES+1
      ABSERR = OFLOW
      RESULT = EPSTAB(N)
      IF(N.LT.3) GO TO 100
      LIMEXP = 50
      EPSTAB(N+2) = EPSTAB(N)
      NEWELM = (N-1)/2
      EPSTAB(N) = CMPLX(OFLOW,0.0)
      NUM = N
      K1 = N
      DO 40 I = 1,NEWELM
        K2 = K1-1
        K3 = K1-2
        RES = EPSTAB(K1+2)
        E0 = EPSTAB(K3)
        E1 = EPSTAB(K2)
        E2 = RES
        E1ABS = CABS(E1)
        A1 = REAL(E0)
        A2 = AIMAG(E0)
        B1 = REAL(E1)
        B2 = AIMAG(E1)
        C1 = REAL(E2)
        C2 = AIMAG(E2)
        ERR2 = ABS(C1 - B1)
        ERR3 = ABS(B1 - A1)
        IF(ABS(A1-B1) .GT. EPMACH*AMAX1(ABS(A1),ABS(B1)) .OR.
     *     ABS(A2-B2) .GT. EPMACH*AMAX1(ABS(A2),ABS(B2))) GO TO 10
        IF(ABS(B1-C1) .GT. EPMACH*AMAX1(ABS(B1),ABS(C1)) .OR.
     *     ABS(B2-C2) .GT. EPMACH*AMAX1(ABS(B2),ABS(C2))) GO TO 10
C
C           IF E0, E1 AND E2 ARE EQUAL TO WITHIN MACHINE
C           ACCURACY, CONVERGENCE IS ASSUMED.
C           RESULT = E2
C           ABSERR = CABS(E1-E0)+CABS(E2-E1)
C
        RESULT = RES
        ABSERR = ERR2+ERR3
C***JUMP OUT OF DO-LOOP
        GO TO 100
   10   E3 = EPSTAB(K1)
        EPSTAB(K1) = E1
        D1 = REAL(E3)
        D2 = AIMAG(E3)
        ERR1 = ABS(B1 - D1)
C
C           IF TWO ELEMENTS ARE VERY CLOSE TO EACH OTHER, OMIT
C           A PART OF THE TABLE BY ADJUSTING THE VALUE OF N
C
        DELTA1 = E1 - E3
        DELTA2 = E2 - E1
        DELTA3 = E1 - E0
        IF(CABS(DELTA1) .LE. EPMACH*AMAX1(E1ABS,CABS(E3))) GO TO 20
        IF(CABS(DELTA2) .LE. EPMACH*AMAX1(E1ABS,CABS(E2))) GO TO 20
        IF(CABS(DELTA3) .LE. EPMACH*AMAX1(CABS(E0),E1ABS)) GO TO 20
        R = REAL(DELTA1)
        S = AIMAG(DELTA1)
        CALL CDIVID(1.D0,0.D0,R,S,U1,V1)
        R = REAL(DELTA2)
        S = AIMAG(DELTA2)
        CALL CDIVID(1.D0,0.D0,R,S,U2,V2)
        R = REAL(DELTA3)
        S = AIMAG(DELTA3)
        CALL CDIVID(1.D0,0.D0,R,S,U3,V3)
        SS1 = U1 + U2 - U3
        SS2 = V1 + V2 - V3
        SS = CMPLX(SNGL(SS1), SNGL(SS2))
        EPSINF = CABS(SS*E1)
C
C           TEST TO DETECT IRREGULAR BEHAVIOUR IN THE TABLE, AND
C           EVENTUALLY OMIT A PART OF THE TABLE ADJUSTING THE VALUE
C           OF N.
C
        IF(EPSINF.GT.1.0E-04) GO TO 30
   20   N = I+I-1
C***JUMP OUT OF DO-LOOP
        GO TO 50
C
C           COMPUTE A NEW ELEMENT AND EVENTUALLY ADJUST
C           THE VALUE OF RESULT.
C
   30   CALL CDIVID(1.D0,0.D0,SS1,SS2,W1,W2)
        RES1 = REAL(E1) + SNGL(W1)
        RES2 = AIMAG(E1) + SNGL(W2)
        RES = CMPLX(RES1,RES2)
        EPSTAB(K1) = RES
        K1 = K1-2
        ERROR = ERR2+ABS(C1-REAL(RES))+ERR3
        IF(ERROR.GT.ABSERR) GO TO 40
        ABSERR = ERROR
        RESULT = RES
   40 CONTINUE
C
C           SHIFT THE TABLE.
C
   50 IF(N.EQ.LIMEXP) N = 2*(LIMEXP/2)-1
      IB = 1
      IF((NUM/2)*2.EQ.NUM) IB = 2
      IE = NEWELM+1
      DO 60 I=1,IE
        IB2 = IB+2
        EPSTAB(IB) = EPSTAB(IB2)
        IB = IB2
   60 CONTINUE
      IF(NUM.EQ.N) GO TO 80
      INDX = NUM-N+1
      DO 70 I = 1,N
        EPSTAB(I)= EPSTAB(INDX)
        INDX = INDX+1
   70 CONTINUE
   80 IF(NRES.GE.4) GO TO 90
      RES3LA(NRES) = RESULT
      ABSERR = OFLOW
      GO TO 100
C
C           COMPUTE ERROR ESTIMATE
C
   90 ABSERR = ABS(REAL(RESULT-RES3LA(3)))+ABS(REAL(RESULT-RES3LA(2)))
     *  +ABS(REAL(RESULT-RES3LA(1)))
      RES3LA(1) = RES3LA(2)
      RES3LA(2) = RES3LA(3)
      RES3LA(3) = RESULT
  100 ABSERR = AMAX1(ABSERR,5.0E+00*EPMACH*ABS(REAL(RESULT)))
      RETURN
      END
      SUBROUTINE QAGI1(F,PHI,Y,C,BOUND,INF,EPSABS,EPSREL,RESULT,ABSERR,
     *                 NEVAL,IER,LIMIT,LENW,LAST,IWORK,WORK)
C-----------------------------------------------------------------------
C
C                   INTEGRATION OVER INFINITE INTERVALS
C
C-----------------------------------------------------------------------
C
C        PURPOSE
C           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
C           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
C                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
C                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
C           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
C           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)). F HAS THE
C           ARGUMENTS X AND PHI WHERE PHI IS A FUNCTION.
C
C        PARAMETERS
C         ON ENTRY
C            F      - REAL
C                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
C                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
C                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
C                     F HAS THE ARGUMENTS X AND PHI.
C
C            PHI    - REAL
C                     FUNCTION SUBPROGRAM HAVING A SINGLE REAL ARGUMENT.
C                     THE ACTUAL NAME FOR PHI MUST BE DECLARED EXTERNAL
C                     IN THE DRIVER PROGRAM.
C
C            BOUND  - REAL
C                     FINITE BOUND OF INTEGRATION RANGE
C                     (HAS NO MEANING IF INTERVAL IS DOUBLY-INFINITE)
C
C            Y      - REAL
C                     PARAMETER FOR USE IN XCOND.  ORDINATE OF
C                     HORIZONTAL LINE ALONG WHICH INTEGRATION
C                     IS PERFORMED.
C
C            C       - REAL
C                      PARAMETER FOR USE IN ACOND AND XCOND.
C
C            INF    - INTEGER
C                     INDICATING THE KIND OF INTEGRATION RANGE
C                     INVOLVED
C                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
C                     INF = -1            TO  (-INFINITY,BOUND),
C                     INF = 2             TO (-INFINITY,+INFINITY).
C
C            EPSABS - REAL
C                     ABSOLUTE ACCURACY REQUESTED
C
C            EPSREL - REAL
C                     RELATIVE ACCURACY REQUESTED
C
C         ON RETURN
C            RESULT - REAL
C                     APPROXIMATION TO THE INTEGRAL
C
C            ABSERR - REAL
C                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
C                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
C
C            NEVAL  - INTEGER
C                     NUMBER OF INTEGRAND EVALUATIONS
C
C            IER    - INTEGER
C                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
C                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
C                             ACCURACY HAS BEEN ACHIEVED.
C                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
C                             ESTIMATES FOR RESULT AND ERROR ARE LESS
C                             RELIABLE. IT IS ASSUMED THAT THE REQUESTED
C                             ACCURACY HAS NOT BEEN ACHIEVED.
C
C                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
C                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE
C                             SUBDIVISIONS BY INCREASING THE VALUE
C                             OF LIMIT (AND TAKING THE ACCORDING
C                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
C                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
C                             IT IS ADVISED TO ANALYZE THE INTEGRAND
C                             IN ORDER TO DETERMINE THE INTEGRATION
C                             DIFFICULTIES. IF THE POSITION OF A LOCAL
C                             DIFFICULTY CAN BE DETERMINED (E.G.
C                             SINGULARITY, DISCONTINUITY WITHIN THE
C                             INTERVAL) ONE WILL PROBABLY GAIN FROM
C                             SPLITTING UP THE INTERVAL AT THIS POINT
C                             AND CALLING THE INTEGRATOR ON THE
C                             SUBRANGES. IF POSSIBLE, AN APPROPRIATE
C                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
C                             WHICH IS DESIGNED FOR HANDLING THE TYPE
C                             OF DIFFICULTY INVOLVED.
C                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
C                             DETECTED, WHICH PREVENTS THE REQUESTED
C                             TOLERANCE FROM BEING ACHIEVED.
C                             THE ERROR MAY BE UNDER-ESTIMATED.
C                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
C                             AT SOME POINTS OF THE INTEGRATION
C                             INTERVAL.
C                         = 4 THE ALGORITHM DOES NOT CONVERGE.
C                             ROUNDOFF ERROR IS DETECTED IN THE
C                             EXTRAPOLATION TABLE.
C                             IT IS ASSUMED THAT THE REQUESTED TOLERANCE
C                             CANNOT BE ACHIEVED, AND THAT THE RETURNED
C                             RESULT IS THE BEST WHICH CAN BE OBTAINED.
C                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
C                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
C                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
C                             OF IER.
C                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
C                             OR EPSREL IS NEGATIVE, LIMIT .LT. 1,
C                             OR LENW .LT. 4 * LIMIT.
C                             RESULT, ABSERR, NEVAL, LAST ARE
C                             SET TO ZERO.
C
C         DIMENSIONING PARAMETERS
C            LIMIT - INTEGER
C                    DIMENSIONING PARAMETER FOR IWORK
C                    LIMIT DETERMINES THE MAXIMUM NUMBER
C                    OF SUBINTERVALS IN THE PARTITION OF THE GIVEN
C                    INTEGRATION INTERVAL (A,B), LIMIT.GE.1.
C                    IF LIMIT.LT.1, THE ROUTINE WILL END WITH
C                    IER = 6.
C
C            LENW  - INTEGER
C                    DIMENSIONING PARAMETER FOR WORK
C                    LENW MUST BE AT LEAST LIMIT*4.
C                    IF LENW.LT.LIMIT*4, THE ROUTINE WILL END
C                    WITH IER = 6.
C
C            LAST  - INTEGER
C                    ON RETURN, LAST EQUALS THE NUMBER OF
C                    SUBINTERVALS PRODUCED IN THE SUBDIVISION
C                    PROCESS, WHICH DETERMINES THE NUMBER OF SIGNIFICANT
C                    ELEMENTS ACTUALLY IN THE WORK ARRAYS.
C
C         WORK ARRAYS
C            IWORK - INTEGER
C                    VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
C                    K ELEMENTS OF WHICH CONTAIN POINTERS
C                    TO THE ERROR ESTIMATES OVER THE SUBINTERVALS,
C                    SUCH THAT WORK(LIMIT*3+IWORK(1)),... ,
C                    WORK(LIMIT*3+IWORK(K)) FORM A DECREASING
C                    SEQUENCE, WITH K = LAST IF LAST.LE.(LIMIT/2+2), AND
C                    K = LIMIT+1-LAST OTHERWISE
C
C            WORK  - REAL
C                    VECTOR OF DIMENSION AT LEAST LENW
C                    ON RETURN
C                    WORK(1), ..., WORK(LAST) CONTAIN THE LEFT
C                     END POINTS OF THE SUBINTERVALS IN THE
C                     PARTITION OF (A,B),
C                    WORK(LIMIT+1), ..., WORK(LIMIT+LAST) CONTAIN
C                     THE RIGHT END POINTS,
C                    WORK(LIMIT*2+1), ..., WORK(LIMIT*2+LAST)
C                     CONTAIN THE INTEGRAL APPROXIMATIONS OVER
C                     THE SUBINTERVALS,
C                    WORK(LIMIT*3+1), ..., WORK(LIMIT*3+LAST)
C                     CONTAIN THE ERROR ESTIMATES.
C
C        SUBROUTINES OR FUNCTIONS NEEDED
C              - QAGIE1
C              - QK15I1
C              - QPSRT
C              - QELG
C              - F (USER PROVIDED FUNCTION)
C              - PHI (USER PROVIDED FUNCTION)
C              - SPMPAR
C
C-----------------------------------------------------------------------
      REAL WORK(LENW)
      INTEGER IWORK(LIMIT)
      EXTERNAL F, PHI
C
C         CHECK VALIDITY OF LIMIT AND LENW.
C
      IER = 6
      NEVAL = 0
      LAST = 0
      RESULT = 0.0
      ABSERR = 0.0
      IF (LIMIT .LT. 1 .OR. LENW .LT. LIMIT*4) RETURN
C
C         PREPARE CALL FOR QAGIE1.
C
      L1 = LIMIT + 1
      L2 = LIMIT + L1
      L3 = LIMIT + L2
C
      CALL QAGIE1(F,PHI,Y,C,BOUND,INF,EPSABS,EPSREL,LIMIT,RESULT,ABSERR,
     *          NEVAL,IER,WORK(1),WORK(L1),WORK(L2),WORK(L3),IWORK,LAST)
      RETURN
      END
      SUBROUTINE QAGIE1(F,PHI,Y,C,BOUND,INF,EPSABS,EPSREL,LIMIT,RESULT,
     *              ABSERR,NEVAL,IER,ALIST,BLIST,RLIST,ELIST,IORD,LAST)
C-----------------------------------------------------------------------
C
C                   INTEGRATION OVER INFINITE INTERVALS
C
C-----------------------------------------------------------------------
C
C        PURPOSE
C           THE ROUTINE CALCULATES AN APPROXIMATION  RESULT  TO A GIVEN
C           INTEGRAL    I = INTEGRAL OF  F  OVER (BOUND,+INFINITY)
C                    OR I = INTEGRAL OF  F  OVER (-INFINITY,BOUND)
C                    OR I = INTEGRAL OF  F  OVER (-INFINITY,+INFINITY),
C           HOPEFULLY SATISFYING FOLLOWING CLAIM FOR ACCURACY
C           ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
C
C        PARAMETERS
C         ON ENTRY
C            F      - REAL
C                     FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
C                     FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS TO BE
C                     DECLARED E X T E R N A L IN THE DRIVER PROGRAM.
C                     F HAS THE ARGUMENTS X AND PHI.
C
C            PHI    - REAL
C                     FUNCTION SUBPROGRAM HAVING A SINGLE REAL ARGUMENT.
C                     THE ACTUAL NAME FOR PHI MUST BE DECLARED EXTERNAL
C                     IN THE DRIVER PROGRAM.
C
C            BOUND  - REAL
C                     FINITE BOUND OF INTEGRATION RANGE
C                     (HAS NO MEANING IF INTERVAL IS DOUBLY-INFINITE)
C
C            Y      - REAL
C                     PARAMETER FOR USE IN XCOND.  ORDINATE OF
C                     HORIZONTAL LINE ALONG WHICH INTEGRATION
C                     IS PERFORMED.
C
C            C      - REAL
C                     PARAMETER FOR USE IN ACOND AND XCOND.
C
C            INF    - INTEGER
C                     INDICATING THE KIND OF INTEGRATION RANGE
C                     INVOLVED
C                     INF = 1 CORRESPONDS TO  (BOUND,+INFINITY),
C                     INF = -1            TO  (-INFINITY,BOUND),
C                     INF = 2             TO (-INFINITY,+INFINITY).
C
C            EPSABS - REAL
C                     ABSOLUTE ACCURACY REQUESTED
C
C            EPSREL - REAL
C                     RELATIVE ACCURACY REQUESTED
C
C            LIMIT  - INTEGER
C                     GIVES AN UPPER BOUND ON THE NUMBER OF
C                     SUBINTERVALS IN THE PARTITION OF (A,B),
C                     LIMIT.GE.1
C
C         ON RETURN
C            RESULT - REAL
C                     APPROXIMATION TO THE INTEGRAL
C
C            ABSERR - REAL
C                     ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
C                     WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
C
C            NEVAL  - INTEGER
C                     NUMBER OF INTEGRAND EVALUATIONS
C
C            IER    - INTEGER
C                     IER = 0 NORMAL AND RELIABLE TERMINATION OF THE
C                             ROUTINE. IT IS ASSUMED THAT THE REQUESTED
C                             ACCURACY HAS BEEN ACHIEVED.
C                   - IER.GT.0 ABNORMAL TERMINATION OF THE ROUTINE. THE
C                             ESTIMATES FOR RESULT AND ERROR ARE LESS
C                             RELIABLE. IT IS ASSUMED THAT THE REQUESTED
C                             ACCURACY HAS NOT BEEN ACHIEVED.
C
C                     IER = 1 MAXIMUM NUMBER OF SUBDIVISIONS ALLOWED
C                             HAS BEEN ACHIEVED. ONE CAN ALLOW MORE
C                             SUBDIVISIONS BY INCREASING THE VALUE
C                             OF LIMIT (AND TAKING THE ACCORDING
C                             DIMENSION ADJUSTMENTS INTO ACCOUNT).
C                             HOWEVER, IF THIS YIELDS NO IMPROVEMENT
C                             IT IS ADVISED TO ANALYZE THE INTEGRAND
C                             IN ORDER TO DETERMINE THE INTEGRATION
C                             DIFFICULTIES. IF THE POSITION OF A LOCAL
C                             DIFFICULTY CAN BE DETERMINED (E.G.
C                             SINGULARITY, DISCONTINUITY WITHIN THE
C                             INTERVAL) ONE WILL PROBABLY GAIN FROM
C                             SPLITTING UP THE INTERVAL AT THIS POINT
C                             AND CALLING THE INTEGRATOR ON THE
C                             SUBRANGES. IF POSSIBLE, AN APPROPRIATE
C                             SPECIAL-PURPOSE INTEGRATOR SHOULD BE USED,
C                             WHICH IS DESIGNED FOR HANDLING THE TYPE
C                             OF DIFFICULTY INVOLVED.
C                         = 2 THE OCCURRENCE OF ROUNDOFF ERROR IS
C                             DETECTED, WHICH PREVENTS THE REQUESTED
C                             TOLERANCE FROM BEING ACHIEVED.
C                             THE ERROR MAY BE UNDER-ESTIMATED.
C                         = 3 EXTREMELY BAD INTEGRAND BEHAVIOUR OCCURS
C                             AT SOME POINTS OF THE INTEGRATION
C                             INTERVAL.
C                         = 4 THE ALGORITHM DOES NOT CONVERGE.
C                             ROUNDOFF ERROR IS DETECTED IN THE
C                             EXTRAPOLATION TABLE.
C                             IT IS ASSUMED THAT THE REQUESTED TOLERANCE
C                             CANNOT BE ACHIEVED, AND THAT THE RETURNED
C                             RESULT IS THE BEST WHICH CAN BE OBTAINED.
C                         = 5 THE INTEGRAL IS PROBABLY DIVERGENT, OR
C                             SLOWLY CONVERGENT. IT MUST BE NOTED THAT
C                             DIVERGENCE CAN OCCUR WITH ANY OTHER VALUE
C                             OF IER.
C                         = 6 THE INPUT IS INVALID BECAUSE EPSABS
C                             OR EPSREL IS NEGATIVE.
C                             RESULT, ABSERR, NEVAL, LAST, RLIST(1),
C                             ELIST(1) AND IORD(1) ARE SET TO ZERO.
C                             ALIST(1) AND BLIST(1) ARE SET TO 0
C                             AND 1 RESPECTIVELY.
C
C            ALIST  - REAL
C                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
C                      LAST  ELEMENTS OF WHICH ARE THE LEFT
C                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
C                     OF THE TRANSFORMED INTEGRATION RANGE (0,1).
C
C            BLIST  - REAL
C                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
C                      LAST  ELEMENTS OF WHICH ARE THE RIGHT
C                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
C                     OF THE TRANSFORMED INTEGRATION RANGE (0,1).
C
C            RLIST  - REAL
C                     VECTOR OF DIMENSION AT LEAST LIMIT, THE FIRST
C                      LAST  ELEMENTS OF WHICH ARE THE INTEGRAL
C                     APPROXIMATIONS ON THE SUBINTERVALS
C
C            ELIST  - REAL
C                     VECTOR OF DIMENSION AT LEAST LIMIT,  THE FIRST
C                      LAST  ELEMENTS OF WHICH ARE THE MODULI
C                     OF THE ABSOLUTE ERROR ESTIMATES ON THE
C                     SUBINTERVALS
C
C            IORD   - INTEGER
C                     VECTOR OF DIMENSION LIMIT, THE FIRST K
C                     ELEMENTS OF WHICH ARE POINTERS TO THE
C                     ERROR ESTIMATES OVER THE SUBINTERVALS,
C                     SUCH THAT ELIST(IORD(1)), ..., ELIST(IORD(K))
C                     FORM A DECREASING SEQUENCE, WITH K = LAST
C                     IF LAST.LE.(LIMIT/2+2), AND K = LIMIT+1-LAST
C                     OTHERWISE
C
C            LAST   - INTEGER
C                     NUMBER OF SUBINTERVALS ACTUALLY PRODUCED
C                     IN THE SUBDIVISION PROCESS
C
C        SUBROUTINES OR FUNCTIONS NEEDED
C              - QK15I1
C              - QPSRT
C              - QELG
C              - F (USER-PROVIDED FUNCTION)
C              - PHI (USER-PROVIDED FUNCTION)
C              - SPMPAR
C
C-----------------------------------------------------------------------
      LOGICAL EXTRAP,NOEXT
C
      DIMENSION ALIST(LIMIT),BLIST(LIMIT),ELIST(LIMIT),IORD(LIMIT),
     *  RES3LA(3),RLIST(LIMIT),RLIST2(52)
C
      EXTERNAL F, PHI
C
C            THE DIMENSION OF RLIST2 IS DETERMINED BY THE VALUE OF
C            LIMEXP IN SUBROUTINE QELG.
C
C
C            LIST OF MAJOR VARIABLES
C            -----------------------
C
C           ALIST     - LIST OF LEFT END POINTS OF ALL SUBINTERVALS
C                       CONSIDERED UP TO NOW
C           BLIST     - LIST OF RIGHT END POINTS OF ALL SUBINTERVALS
C                       CONSIDERED UP TO NOW
C           RLIST(I)  - APPROXIMATION TO THE INTEGRAL OVER
C                       (ALIST(I),BLIST(I))
C           RLIST2    - ARRAY OF DIMENSION AT LEAST (LIMEXP+2),
C                       CONTAINING THE PART OF THE EPSILON TABLE
C                       WICH IS STILL NEEDED FOR FURTHER COMPUTATIONS
C           ELIST(I)  - ERROR ESTIMATE APPLYING TO RLIST(I)
C           MAXERR    - POINTER TO THE INTERVAL WITH LARGEST ERROR
C                       ESTIMATE
C           ERRMAX    - ELIST(MAXERR)
C           ERLAST    - ERROR ON THE INTERVAL CURRENTLY SUBDIVIDED
C                       (BEFORE THAT SUBDIVISION HAS TAKEN PLACE)
C           AREA      - SUM OF THE INTEGRALS OVER THE SUBINTERVALS
C           ERRSUM    - SUM OF THE ERRORS OVER THE SUBINTERVALS
C           ERRBND    - REQUESTED ACCURACY MAX(EPSABS,EPSREL*
C                       ABS(RESULT))
C           *****1    - VARIABLE FOR THE LEFT SUBINTERVAL
C           *****2    - VARIABLE FOR THE RIGHT SUBINTERVAL
C           LAST      - INDEX FOR SUBDIVISION
C           NRES      - NUMBER OF CALLS TO THE EXTRAPOLATION ROUTINE
C           NUMRL2    - NUMBER OF ELEMENTS CURRENTLY IN RLIST2. IF AN
C                       APPROPRIATE APPROXIMATION TO THE COMPOUNDED
C                       INTEGRAL HAS BEEN OBTAINED, IT IS PUT IN
C                       RLIST2(NUMRL2) AFTER NUMRL2 HAS BEEN INCREASED
C                       BY ONE.
C           SMALL     - LENGTH OF THE SMALLEST INTERVAL CONSIDERED UP
C                       TO NOW, MULTIPLIED BY 1.5
C           ERLARG    - SUM OF THE ERRORS OVER THE INTERVALS LARGER
C                       THAN THE SMALLEST INTERVAL CONSIDERED UP TO NOW
C           EXTRAP    - LOGICAL VARIABLE DENOTING THAT THE ROUTINE
C                       IS ATTEMPTING TO PERFORM EXTRAPOLATION. I.E.
C                       BEFORE SUBDIVIDING THE SMALLEST INTERVAL WE
C                       TRY TO DECREASE THE VALUE OF ERLARG.
C           NOEXT     - LOGICAL VARIABLE DENOTING THAT EXTRAPOLATION
C                       IS NO LONGER ALLOWED (TRUE-VALUE)
C
C            MACHINE DEPENDENT CONSTANTS
C            ---------------------------
C
C           EPMACH IS THE LARGEST RELATIVE SPACING.
C           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
C           OFLOW IS THE LARGEST POSITIVE MAGNITUDE.
C
      EPMACH = SPMPAR(1)
      UFLOW = SPMPAR(2)
      OFLOW = SPMPAR(3)
C
C           TEST ON VALIDITY OF PARAMETERS
C           -----------------------------
C
      NEVAL = 0
      LAST = 0
      RESULT = 0.0
      ABSERR = 0.0
      ALIST(1) = 0.0
      BLIST(1) = 1.0
      RLIST(1) = 0.0
      ELIST(1) = 0.0
      IORD(1) = 0
      IER = 6
      IF (EPSABS .LT. 0.0 .OR. EPSREL .LT. 0.0) GO TO 999
      IER = 0
      RERR = AMAX1(EPSREL, 50.0*EPMACH, 0.5E-14)
C
C           FIRST APPROXIMATION TO THE INTEGRAL
C           -----------------------------------
C
C           DETERMINE THE INTERVAL TO BE MAPPED ONTO (0,1).
C           IF INF = 2 THE INTEGRAL IS COMPUTED AS I = I1+I2, WHERE
C           I1 = INTEGRAL OF F OVER (-INFINITY,0),
C           I2 = INTEGRAL OF F OVER (0,+INFINITY).
C
      BOUN = BOUND
      IF (INF .EQ. 2) BOUN = 0.0
      CALL QK15I1 (F, PHI, Y, C, BOUN, INF, 0.0, 1.0, RESULT, ABSERR,
     *             DEFABS, RESABS, EPMACH, UFLOW)
C
C           TEST ON ACCURACY
C
      LAST = 1
      RLIST(1) = RESULT
      ELIST(1) = ABSERR
      IORD(1) = 1
      DRES = ABS(RESULT)
      ERRBND = AMAX1(EPSABS,RERR*DRES)
      IF (ABSERR .LE. 100.0*EPMACH*DEFABS .AND. ABSERR .GT. ERRBND)
     *          IER = 2
      IF (LIMIT .EQ. 1) IER = 1
      IF (IER .NE. 0 .OR. (ABSERR .LE. ERRBND .AND. ABSERR .NE. RESABS)
     *    .OR. ABSERR .EQ. 0.0) GO TO 130
C
C           INITIALIZATION
C           --------------
C
      RLIST2(1) = RESULT
      ERRMAX = ABSERR
      MAXERR = 1
      AREA = RESULT
      ERRSUM = ABSERR
      ABSERR = OFLOW
      CORREC = 0.0
      NRMAX = 1
      NRES = 0
      KTMIN = 0
      NUMRL2 = 2
      EXTRAP = .FALSE.
      NOEXT = .FALSE.
      IERRO = 0
      IROFF1 = 0
      IROFF2 = 0
      IROFF3 = 0
      KSGN = -1
      IF (DRES .GE. (1.0 - 50.0*EPMACH)*DEFABS) KSGN = 1
      T = 1.0 + 100.0*EPMACH
C
C           MAIN DO-LOOP
C           ------------
C
      DO 90 LAST = 2,LIMIT
C
C           BISECT THE SUBINTERVAL WITH NRMAX-TH LARGEST
C           ERROR ESTIMATE.
C
        A1 = ALIST(MAXERR)
        B1 = 0.5*(ALIST(MAXERR) + BLIST(MAXERR))
        A2 = B1
        B2 = BLIST(MAXERR)
        ERLAST = ERRMAX
        CALL QK15I1 (F, PHI, Y, C, BOUN, INF, A1, B1, AREA1, ERROR1,
     *               RESABS, DEFAB1, EPMACH, UFLOW)
        CALL QK15I1 (F, PHI, Y, C, BOUN, INF, A2, B2, AREA2, ERROR2,
     *               RESABS, DEFAB2, EPMACH, UFLOW)
C
C           IMPROVE PREVIOUS APPROXIMATIONS TO INTEGRAL
C           AND ERROR AND TEST FOR ACCURACY.
C
        AREA12 = AREA1 + AREA2
        ERRO12 = ERROR1 + ERROR2
        ERRSUM = ERRSUM + ERRO12 - ERRMAX
        AREA = AREA + AREA12 - RLIST(MAXERR)
        IF (DEFAB1 .EQ. ERROR1 .OR. DEFAB2 .EQ. ERROR2) GO TO 15
        IF (ABS(RLIST(MAXERR) - AREA12) .GT. 0.1E-04*ABS(AREA12)
     *      .OR. ERRO12 .LT. 0.99*ERRMAX) GO TO 10
        IF (EXTRAP) IROFF2 = IROFF2 + 1
        IF (.NOT.EXTRAP) IROFF1 = IROFF1 + 1
   10   IF (LAST .GT. 10 .AND. ERRO12 .GT. ERRMAX) IROFF3 = IROFF3 + 1
   15   RLIST(MAXERR) = AREA1
        RLIST(LAST) = AREA2
        ERRBND = AMAX1(EPSABS,RERR*ABS(AREA))
C
C           TEST FOR ROUNDOFF ERROR AND EVENTUALLY
C           SET ERROR FLAG.
C
        IF (IROFF1 + IROFF2 .GE. 10 .OR. IROFF3 .GE. 20) IER = 2
        IF (IROFF2 .GE. 5) IERRO = 3
C
C           SET ERROR FLAG IN THE CASE THAT THE NUMBER OF
C           SUBINTERVALS EQUALS LIMIT.
C
        IF (LAST .EQ. LIMIT) IER = 1
C
C           SET ERROR FLAG IN THE CASE OF BAD INTEGRAND BEHAVIOUR
C           AT SOME POINTS OF THE INTEGRATION RANGE.
C
        IF (AMAX1(ABS(A1),ABS(B2)) .LE.
     *      T*(ABS(A2) + 0.1E+04*UFLOW)) IER = 4
C
C           APPEND THE NEWLY-CREATED INTERVALS TO THE LIST.
C
        IF (ERROR2 .GT. ERROR1) GO TO 20
        ALIST(LAST) = A2
        BLIST(MAXERR) = B1
        BLIST(LAST) = B2
        ELIST(MAXERR) = ERROR1
        ELIST(LAST) = ERROR2
        GO TO 30
   20   ALIST(MAXERR) = A2
        ALIST(LAST) = A1
        BLIST(LAST) = B1
        RLIST(MAXERR) = AREA2
        RLIST(LAST) = AREA1
        ELIST(MAXERR) = ERROR2
        ELIST(LAST) = ERROR1
C
C           CALL SUBROUTINE QPSRT TO MAINTAIN THE DESCENDING ORDERING
C           IN THE LIST OF ERROR ESTIMATES AND SELECT THE
C           SUBINTERVAL WITH NRMAX-TH LARGEST ERROR ESTIMATE (TO BE
C           BISECTED NEXT).
C
   30   CALL QPSRT (LIMIT,LAST,MAXERR,ERRMAX,ELIST,IORD,NRMAX)
        IF(ERRSUM.LE.ERRBND) GO TO 115
        IF(IER.NE.0) GO TO 100
        IF(LAST.EQ.2) GO TO 80
        IF(NOEXT) GO TO 90
        ERLARG = ERLARG-ERLAST
        IF(ABS(B1-A1).GT.SMALL) ERLARG = ERLARG+ERRO12
        IF(EXTRAP) GO TO 40
C
C           TEST WHETHER THE INTERVAL TO BE BISECTED NEXT IS THE
C           SMALLEST INTERVAL.
C
        IF(ABS(BLIST(MAXERR)-ALIST(MAXERR)).GT.SMALL) GO TO 90
        EXTRAP = .TRUE.
        NRMAX = 2
   40   IF(IERRO.EQ.3.OR.ERLARG.LE.ERTEST) GO TO 60
C
C           THE SMALLEST INTERVAL HAS THE LARGEST ERROR.
C           BEFORE BISECTING DECREASE THE SUM OF THE ERRORS
C           OVER THE LARGER INTERVALS (ERLARG) AND PERFORM
C           EXTRAPOLATION.
C
        ID = NRMAX
        JUPBND = LAST
        IF(LAST.GT.(2+LIMIT/2)) JUPBND = LIMIT+3-LAST
        DO 50 K = ID,JUPBND
          MAXERR = IORD(NRMAX)
          ERRMAX = ELIST(MAXERR)
          IF(ABS(BLIST(MAXERR)-ALIST(MAXERR)).GT.SMALL) GO TO 90
          NRMAX = NRMAX+1
   50   CONTINUE
C
C           PERFORM EXTRAPOLATION.
C
   60   NUMRL2 = NUMRL2+1
        RLIST2(NUMRL2) = AREA
        CALL QELG (NUMRL2, RLIST2, RESEPS, ABSEPS, RES3LA, NRES,
     *             EPMACH, OFLOW)
        KTMIN = KTMIN+1
        IF(KTMIN.GT.5.AND.ABSERR.LT.0.1E-02*ERRSUM) IER = 5
        IF(ABSEPS.GE.ABSERR) GO TO 70
        KTMIN = 0
        ABSERR = ABSEPS
        RESULT = RESEPS
        CORREC = ERLARG
        ERTEST = AMAX1(EPSABS,RERR*ABS(RESEPS))
        IF(ABSERR.LE.ERTEST) GO TO 100
C
C            PREPARE BISECTION OF THE SMALLEST INTERVAL.
C
   70   IF(NUMRL2.EQ.1) NOEXT = .TRUE.
        IF(IER.EQ.5) GO TO 100
        MAXERR = IORD(1)
        ERRMAX = ELIST(MAXERR)
        NRMAX = 1
        EXTRAP = .FALSE.
        SMALL = SMALL*0.5E+00
        ERLARG = ERRSUM
        GO TO 90
   80   SMALL = 0.375E+00
        ERLARG = ERRSUM
        ERTEST = ERRBND
        RLIST2(2) = AREA
   90 CONTINUE
C
C           SET FINAL RESULT AND ERROR ESTIMATE.
C           ------------------------------------
C
  100 IF (ABSERR .EQ. OFLOW) GO TO 115
      IF (IER + IERRO .EQ. 0) GO TO 110
      IF (IERRO .EQ. 3) ABSERR = ABSERR + CORREC
      IF (IER .EQ. 0) IER = 3
      IF (RESULT .NE. 0.0 .AND. AREA .NE. 0.0) GO TO 105
      IF (ABSERR .GT. ERRSUM) GO TO 115
      IF (AREA .EQ. 0.0) GO TO 130
      GO TO 110
  105 IF (ABSERR/ABS(RESULT) .GT. ERRSUM/ABS(AREA)) GO TO 115
C
C           TEST ON DIVERGENCE
C
  110 IF (KSGN .EQ. -1 .AND. AMAX1(ABS(RESULT),ABS(AREA)) .LE.
     *    DEFABS*0.1E-01) GO TO 130
      IF (0.1E-01 .GT. (RESULT/AREA) .OR. (RESULT/AREA) .GT. 0.1E+03
     *    .OR. ERRSUM .GT. ABS(AREA)) IER = 6
      GO TO 130
C
C           COMPUTE GLOBAL INTEGRAL SUM.
C
  115 RESULT = 0.0
      DO 120 K = 1,LAST
        RESULT = RESULT + RLIST(K)
  120 CONTINUE
      ABSERR = ERRSUM
  130 NEVAL = 30*LAST - 15
      IF (INF .EQ. 2) NEVAL = 2*NEVAL
      IF (IER .GT. 2) IER = IER - 1
  999 RETURN
      END
      SUBROUTINE QK15I1 (F, PHI, Y, C, BOUN, INF, A, B, RESULT, ABSERR,
     *                   RESABS, RESASC, EPMACH, UFLOW)
C-----------------------------------------------------------------------
C
C 1.        PURPOSE
C              THE ORIGINAL (INFINITE) INTEGRATION RANGE IS MAPPED
C              ONTO THE INTERVAL (0,1) AND (A,B) IS A PART OF (0,1).
C              IT IS THE PURPOSE TO COMPUTE
C              I = INTEGRAL OF TRANSFORMED INTEGRAND OVER (A,B),
C              J = INTEGRAL OF ABS(TRANSFORMED INTEGRAND) OVER (A,B).
C
C 2.        PARAMETERS
C            ON ENTRY
C              F      - REAL
C                       FUNCTION SUBPROGRAM DEFINING THE INTEGRAND
C                       FUNCTION F(X). THE ACTUAL NAME FOR F NEEDS
C                       TO BE DECLARED E X T E R N A L IN THE
C                       CALLING PROGRAM. F HAS THE ARGUMENTS X AND
C                       PHI.
C
C              PHI    - REAL
C                       FUNCTION SUBPROGRAM HAVING A SINGLE REAL
C                       ARGUMENT. THE ACTUAL NAME FOR PHI MUST BE
C                       DECHARED EXTERNAL IN THE DRIVER PROGRAM.
C
C              BOUN   - REAL
C                       FINITE BOUND OF ORIGINAL INTEGRATION
C                       RANGE (SET TO ZERO IF INF = +2)
C
C              INF    - INTEGER
C                       IF INF = -1, THE ORIGINAL INTERVAL IS
C                                   (-INFINITY,BOUND),
C                       IF INF = +1, THE ORIGINAL INTERVAL IS
C                                   (BOUND,+INFINITY),
C                       IF INF = +2, THE ORIGINAL INTERVAL IS
C                                   (-INFINITY,+INFINITY) AND
C                       THE INTEGRAL IS COMPUTED AS THE SUM OF TWO
C                       INTEGRALS, ONE OVER (-INFINITY,0)
C                       AND ONE OVER (0,+INFINITY).
C
C              A      - REAL
C                       LOWER LIMIT FOR INTEGRATION OVER SUBRANGE
C                       OF (0,1)
C
C              B      - REAL
C                       UPPER LIMIT FOR INTEGRATION OVER SUBRANGE
C                       OF (0,1)
C
C              EPMACH - REAL
C                       THE RELATIVE PRECISION OF THE FLOATING
C                       ARITHMETIC BEING USED.
C
C              UFLOW  - REAL
C                       THE SMALLEST POSITIVE MAGNITUDE.
C
C            ON RETURN
C              RESULT - REAL
C                       APPROXIMATION TO THE INTEGRAL I
C                       RESULT IS COMPUTED BY APPLYING THE 15-POINT
C                       KRONROD RULE(RESK) OBTAINED BY OPTIMAL
C                       ADDITION OF ABSCISSAE TO THE 7-POINT GAUSS
C                       RULE(RESG).
C
C              ABSERR - REAL
C                       ESTIMATE OF THE MODULUS OF THE ABSOLUTE ERROR,
C                       WHICH SHOULD EQUAL OR EXCEED ABS(I-RESULT)
C
C              RESABS - REAL
C                       APPROXIMATION TO THE INTEGRAL J
C
C              RESASC - REAL
C                       APPROXIMATION TO THE INTEGRAL OF
C                       ABS((TRANSFORMED INTEGRAND)-I/(B-A))
C                       OVER (A,B)
C
C 3.        SUBROUTINES OR FUNCTIONS NEEDED
C                 - F (USER-PROVIDED FUNCTION)
C                 - PHI (USER-PROVIDED FUNCTION)
C
C-----------------------------------------------------------------------
      REAL FV1(7), FV2(7), XGK(8), WGK(8), WG(8)
C
      EXTERNAL F, PHI
C
C           THE ABSCISSAE AND WEIGHTS ARE SUPPLIED FOR THE INTERVAL
C           (-1,1).  BECAUSE OF SYMMETRY ONLY THE POSITIVE ABSCISSAE AND
C           THEIR CORRESPONDING WEIGHTS ARE GIVEN.
C
C           XGK    - ABSCISSAE OF THE 15-POINT KRONROD RULE
C                    XGK(2), XGK(4), ... ABSCISSAE OF THE 7-POINT
C                    GAUSS RULE
C                    XGK(1), XGK(3), ...  ABSCISSAE WHICH ARE OPTIMALLY
C                    ADDED TO THE 7-POINT GAUSS RULE
C
C           WGK    - WEIGHTS OF THE 15-POINT KRONROD RULE
C
C           WG     - WEIGHTS OF THE 7-POINT GAUSS RULE, CORRESPONDING
C                    TO THE ABSCISSAE XGK(2), XGK(4), ...
C                    WG(1), WG(3), ... ARE SET TO ZERO.
C
      DATA XGK(1),XGK(2),XGK(3),XGK(4),XGK(5),XGK(6),XGK(7),
     *  XGK(8)/
     *     0.9914553711208126E+00,     0.9491079123427585E+00,
     *     0.8648644233597691E+00,     0.7415311855993944E+00,
     *     0.5860872354676911E+00,     0.4058451513773972E+00,
     *     0.2077849550078985E+00,     0.0000000000000000E+00/
C
      DATA WGK(1),WGK(2),WGK(3),WGK(4),WGK(5),WGK(6),WGK(7),
     *  WGK(8)/
     *     0.2293532201052922E-01,     0.6309209262997855E-01,
     *     0.1047900103222502E+00,     0.1406532597155259E+00,
     *     0.1690047266392679E+00,     0.1903505780647854E+00,
     *     0.2044329400752989E+00,     0.2094821410847278E+00/
C
      DATA WG(1),WG(2),WG(3),WG(4),WG(5),WG(6),WG(7),WG(8)/
     *     0.0000000000000000E+00,     0.1294849661688697E+00,
     *     0.0000000000000000E+00,     0.2797053914892767E+00,
     *     0.0000000000000000E+00,     0.3818300505051189E+00,
     *     0.0000000000000000E+00,     0.4179591836734694E+00/
C
C
C           LIST OF MAJOR VARIABLES
C           -----------------------
C
C           CENTR  - MID POINT OF THE INTERVAL
C           HLGTH  - HALF-LENGTH OF THE INTERVAL
C           ABSC*  - ABSCISSA
C           TABSC* - TRANSFORMED ABSCISSA
C           FVAL*  - FUNCTION VALUE
C           RESG   - RESULT OF THE 7-POINT GAUSS FORMULA
C           RESK   - RESULT OF THE 15-POINT KRONROD FORMULA
C           RESKH  - APPROXIMATION TO THE MEAN VALUE OF THE TRANSFORMED
C                    INTEGRAND OVER (A,B), I.E. TO I/(B-A)
C
C
      DINF = MIN0(1,INF)
C
      CENTR = 0.5*(A + B)
      HLGTH = 0.5*(B - A)
      TABSC1 = BOUN + DINF*(1.0 - CENTR)/CENTR
      FVAL1 = F(TABSC1,Y,C,PHI)
      IF (INF .EQ. 2) FVAL1 = FVAL1 + F(-TABSC1,Y,C,PHI)
      FC = (FVAL1/CENTR)/CENTR
C
C           COMPUTE THE 15-POINT KRONROD APPROXIMATION TO
C           THE INTEGRAL, AND ESTIMATE THE ERROR.
C
      RESG = WG(8)*FC
      RESK = WGK(8)*FC
      RESABS = ABS(RESK)
      DO 10 J = 1,7
        ABSC = HLGTH*XGK(J)
        ABSC1 = CENTR - ABSC
        ABSC2 = CENTR + ABSC
        TABSC1 = BOUN + DINF*(1.0 - ABSC1)/ABSC1
        TABSC2 = BOUN + DINF*(1.0 - ABSC2)/ABSC2
        FVAL1 = F(TABSC1,Y,C,PHI)
        FVAL2 = F(TABSC2,Y,C,PHI)
        IF (INF .EQ. 2) FVAL1 = FVAL1 + F(-TABSC1,Y,C,PHI)
        IF (INF .EQ. 2) FVAL2 = FVAL2 + F(-TABSC2,Y,C,PHI)
        FVAL1 = (FVAL1/ABSC1)/ABSC1
        FVAL2 = (FVAL2/ABSC2)/ABSC2
        FV1(J) = FVAL1
        FV2(J) = FVAL2
        FSUM = FVAL1 + FVAL2
        RESG = RESG + WG(J)*FSUM
        RESK = RESK + WGK(J)*FSUM
        RESABS = RESABS + WGK(J)*(ABS(FVAL1) + ABS(FVAL2))
   10 CONTINUE
      RESKH = RESK*0.5
      RESASC = WGK(8)*ABS(FC - RESKH)
      DO 20 J = 1,7
        RESASC = RESASC + WGK(J)*(ABS(FV1(J)-RESKH) +
     *                            ABS(FV2(J)-RESKH))
   20 CONTINUE
      RESULT = RESK*HLGTH
      RESASC = RESASC*HLGTH
      RESABS = RESABS*HLGTH
      ABSERR = ABS((RESK - RESG)*HLGTH)
      IF (RESASC .NE. 0.0 .AND. ABSERR .NE. 0.0) ABSERR = RESASC*
     *    AMIN1(1.0, (0.2E+03*ABSERR/RESASC)**1.5)
      TOL = 50.0*EPMACH
      IF (RESABS .GT. UFLOW/TOL) ABSERR = AMAX1(ABSERR, TOL*RESABS)
      RETURN
      END
      SUBROUTINE FFT (C,N,ISN,IERR)
      REAL C(*)
C-----------------------------------------------------------------------
C     THE COMPLEX ARRAY C OF DIMENSION N IS INTERPRETED BY THE CODE
C     AS A REAL ARRAY OF DIMENSION 2*N. IF THIS ASSOCIATION IS NOT
C     PERMITTED BY THE FORTRAN BEING USED, THEN THE USER MAY USE THE
C     SUBROUTINE FFT1.
C-----------------------------------------------------------------------
      IF (IABS(ISN) .NE. 1) GO TO 10
      CALL SFFT (C(1),C(2),N,N,N,ISN+ISN,IERR)
      RETURN
   10 IERR = 4
      RETURN
      END
      SUBROUTINE FFT1 (A,B,N,ISN,IERR)
      REAL A(N), B(N)
C     ------------
      IF (IABS(ISN) .NE. 1) GO TO 10
      CALL SFFT (A,B,N,N,N,ISN,IERR)
      RETURN
   10 IERR = 4
      RETURN
      END
      SUBROUTINE MFFT (C,N,NDIM,ISN,IERR)
      REAL C(*)
      INTEGER N(NDIM)
C-----------------------------------------------------------------------
C     LET NTOT DENOTE THE PRODUCT OF N(1),...,N(NDIM). THE COMPLEX
C     ARRAY C OF DIMENSION NTOT IS INTERPRETED BY THE ROUTINE AS
C     A REAL ARRAY OF DIMENSION 2*NTOT. IF THIS ASSOCIATION IS NOT
C     PERMITTED BY THE FORTRAN BEING USED, THEN THE USER MAY USE
C     THE SUBROUTINE MFFT1.
C-----------------------------------------------------------------------
      IF (IABS(ISN) .NE. 1) GO TO 40
      IF (NDIM .LE. 0) GO TO 50
      NTOT = 1
      DO 10 I = 1,NDIM
         NTOT = N(I)*NTOT
   10 CONTINUE
      IF (NTOT .LT. 1) GO TO 30
C
      ISIGN = ISN + ISN
      NSPAN = 1
      DO 20 I = 1,NDIM
         NSPAN = N(I)*NSPAN
         CALL SFFT (C(1),C(2),NTOT,N(I),NSPAN,ISIGN,IERR)
         IF (IERR .NE. 0) RETURN
   20 CONTINUE
      RETURN
C
   30 IERR = 1
      RETURN
   40 IERR = 4
      RETURN
   50 IERR = 5
      RETURN
      END
      SUBROUTINE MFFT1 (A,B,N,NDIM,ISN,IERR)
      REAL A(*), B(*)
      INTEGER N(NDIM)
C     ------------
      IF (IABS(ISN) .NE. 1) GO TO 40
      IF (NDIM .LE. 0) GO TO 50
      NTOT = 1
      DO 10 I = 1,NDIM
         NTOT = N(I)*NTOT
   10 CONTINUE
      IF (NTOT .LT. 1) GO TO 30
C
      NSPAN = 1
      DO 20 I = 1,NDIM
         NSPAN = N(I)*NSPAN
         CALL SFFT (A,B,NTOT,N(I),NSPAN,ISN,IERR)
         IF (IERR .NE. 0) RETURN
   20 CONTINUE
      RETURN
C
   30 IERR = 1
      RETURN
   40 IERR = 4
      RETURN
   50 IERR = 5
      RETURN
      END
      SUBROUTINE SFFT(A,B,NTOT,N,NSPAN,ISN,IERR)
C  MULTIVARIATE COMPLEX FOURIER TRANSFORM, COMPUTED IN PLACE
C    USING MIXED-RADIX FAST FOURIER TRANSFORM ALGORITHM.
C  BY R. C. SINGLETON, STANFORD RESEARCH INSTITUTE, OCT. 1968
C    MODIFIED BY A. H. MORRIS, NSWC/DL, DAHLGREN VA
C  ARRAYS A AND B ORIGINALLY HOLD THE REAL AND IMAGINARY
C    COMPONENTS OF THE DATA, AND RETURN THE REAL AND
C    IMAGINARY COMPONENTS OF THE RESULTING FOURIER COEFFICIENTS.
C  MULTIVARIATE DATA IS INDEXED ACCORDING TO THE FORTRAN
C    ARRAY ELEMENT SUCCESSOR FUNCTION, WITHOUT LIMIT
C    ON THE NUMBER OF IMPLIED MULTIPLE SUBSCRIPTS.
C    THE SUBROUTINE IS CALLED ONCE FOR EACH VARIATE.
C    THE CALLS FOR A MULTIVARIATE TRANSFORM MAY BE IN ANY ORDER.
C  NTOT IS THE TOTAL NUMBER OF COMPLEX DATA VALUES.
C  N IS THE DIMENSION OF THE CURRENT VARIABLE.
C  NSPAN/N IS THE SPACING OF CONSECUTIVE DATA VALUES
C    WHILE INDEXING THE CURRENT VARIABLE.
C  THE SIGN OF ISN DETERMINES THE SIGN OF THE COMPLEX
C    EXPONENTIAL, AND THE MAGNITUDE OF ISN IS NORMALLY ONE.
C  A TRI-VARIATE TRANSFORM WITH A(N1,N2,N3), B(N1,N2,N3)
C    IS COMPUTED BY
C      CALL SFFT(A,B,N1*N2*N3,N1,N1,1,IERR)
C      CALL SFFT(A,B,N1*N2*N3,N2,N1*N2,1,IERR)
C      CALL SFFT(A,B,N1*N2*N3,N3,N1*N2*N3,1,IERR)
C  FOR A SINGLE-VARIATE TRANSFORM,
C    NTOT = N = NSPAN = (NUMBER OF COMPLEX DATA VALUES), E.G.
C      CALL SFFT(A,B,N,N,N,1,IERR)
C  THE DATA MAY ALTERNATIVELY BE STORED IN A SINGLE COMPLEX
C    ARRAY A, THEN THE MAGNITUDE OF ISN CHANGED TO TWO TO
C    GIVE THE CORRECT INDEXING INCREMENT AND A(2) USED TO
C    PASS THE INITIAL ADDRESS FOR THE SEQUENCE OF IMAGINARY
C    VALUES, E.G.
C      CALL SFFT(A,A(2),NTOT,N,NSPAN,2,IERR)
C  ARRAYS NFAC(MAXN),NP(MAXP),AT(MAXF),CK(MAXF),BT(MAXF),SK(MAXF)
C    ARE USED FOR TEMPORARY STORAGE.
C    MAXN MUST BE .GE. THE NUMBER OF FACTORS OF N
C    MAXF MUST BE .GE. THE MAXIMUM PRIME FACTOR OF N.
C    MAXP MUST BE .GT. THE NUMBER OF PRIME FACTORS OF N.
C    IN ADDITION, MAXN IS ASSUMED TO BE ODD.
C    IF THE SQUARE-FREE PORTION K OF N HAS TWO OR MORE PRIME
C    FACTORS, THEN MAXP MUST BE .GE. K-1.
C  IERR IS A VARIABLE. IERR IS SET TO 0 IF NO INPUT ERRORS ARE
C    DETECTED. OTHERWISE, IERR IS ASSIGNED ONE OF THE VALUES
C      IERR=1    N IS LESS THAN 1
C      IERR=2    N HAS MORE THAN MAXN FACTORS
C      IERR=3    N HAS A PRIME FACTOR GREATER THAN
C                MAXF OR THE SQUARE-FREE PORTION OF
C                N IS GREATER THAN MAXP+1
      DIMENSION A(*),B(*)
C  ARRAY STORAGE IN NFAC FOR A MAXIMUM OF 15 FACTORS OF N.
C  IF N HAS MORE THAN ONE SQUARE-FREE FACTOR, THE PRODUCT OF THE
C    SQUARE-FREE FACTORS MUST BE .LE. 210
      DIMENSION NFAC(15),NP(209)
C  ARRAY STORAGE FOR MAXIMUM PRIME FACTOR OF 23
      DIMENSION AT(23),CK(23),BT(23),SK(23)
      EQUIVALENCE (I,II)
C  THE FOLLOWING CONSTANTS SHOULD AGREE WITH THE ARRAY DIMENSIONS.
      MAXN=15
      MAXF=23
      MAXP=209
C  SET THE FOLLOWING CONSTANTS
C     RAD=2.0*PI
C     S72=SIN(RAD/5.0)
C     C72=COS(RAD/5.0)
C     S120=SQRT(0.75)
      RAD=6.2831853071796
      S72=.951056516295154
      C72=.309016994374947
      S120=.86602540378444
C
      IERR=0
      IF(N-1) 1000,960,5
    5 INC=ISN
      IF(ISN .GE. 0) GO TO 10
      S72=-S72
      S120=-S120
      RAD=-RAD
      INC=-INC
   10 NT=INC*NTOT
      KS=INC*NSPAN
      KSPAN=KS
      NN=NT-INC
      JC=KS/N
      RADF=RAD*FLOAT(JC)*0.5
      I=0
      JF=0
C  DETERMINE THE FACTORS OF N
      M=0
      K=N
      MAX=MAXN/2
      GO TO 20
   15 IF(M .EQ. MAX) GO TO 1001
      M=M+1
      NFAC(M)=4
      K=L
   20 L=K/16
      IF(K .EQ. L*16) GO TO 15
      J=3
      JJ=9
      GO TO 30
   25 IF(M .EQ. MAX) GO TO 1001
      M=M+1
      NFAC(M)=J
      K=K/JJ
   30 IF(MOD(K,JJ) .EQ. 0) GO TO 25
      J=J+2
      JJ=J**2
      IF(J .LE. MAXF .AND. JJ .LE. K) GO TO 30
      IF(K .GT. 4) GO TO 40
      KT=M
      NFAC(M+1)=K
      IF(K .NE. 1) M=M+1
      GO TO 80
   40 L=K/4
      IF(K .NE. L*4) GO TO 50
      IF(M .EQ. MAX) GO TO 1001
      M=M+1
      NFAC(M)=2
      K=L
      KT=M
      IF(K .EQ. 1) GO TO 85
   50 KT=M
      IF(K-1 .GT. MAXP) GO TO 1002
      NUM=MAXN-KT-KT
      J=2
   60 IF(MOD(K,J) .NE. 0) GO TO 70
      M=M+1
      NFAC(M)=J
      NUM=NUM-1
      K=K/J
      IF(K .EQ. 1) GO TO 80
      IF(NUM .LE. 0) GO TO 1001
   70 L=(J+1)/2
      J=L+L+1
      IF(J .LE. MAXF) GO TO 60
      GO TO 1002
   80 IF(KT .EQ. 0) GO TO 100
   85 J=KT
   90 M=M+1
      NFAC(M)=NFAC(J)
      J=J-1
      IF(J .NE. 0) GO TO 90
C  COMPUTE FOURIER TRANSFORM
  100 SD=RADF/FLOAT(KSPAN)
      CD=2.0*SIN(SD)**2
      SD=SIN(SD+SD)
      KK=1
      I=I+1
      IF(NFAC(I) .NE. 2) GO TO 400
C  TRANSFORM FOR FACTOR OF 2 (INCLUDING ROTATION FACTOR)
      KSPAN=KSPAN/2
      K1=KSPAN+2
  210 K2=KK+KSPAN
      AK=A(K2)
      BK=B(K2)
      A(K2)=A(KK)-AK
      B(K2)=B(KK)-BK
      A(KK)=A(KK)+AK
      B(KK)=B(KK)+BK
      KK=K2+KSPAN
      IF(KK .LE. NN) GO TO 210
      KK=KK-NN
      IF(KK .LE. JC) GO TO 210
      IF(KK .GT. KSPAN) GO TO 800
  220 C1=1.0-CD
      S1=SD
  230 K2=KK+KSPAN
      AK=A(KK)-A(K2)
      BK=B(KK)-B(K2)
      A(KK)=A(KK)+A(K2)
      B(KK)=B(KK)+B(K2)
      A(K2)=C1*AK-S1*BK
      B(K2)=S1*AK+C1*BK
      KK=K2+KSPAN
      IF(KK .LT. NT) GO TO 230
      K2=KK-NT
      C1=-C1
      KK=K1-K2
      IF(KK .GT. K2) GO TO 230
      U=SD*S1+CD*C1
      V=SD*C1-CD*S1
      AK=C1-U
      S1=S1+V
C  THE FOLLOWING THREE STATEMENTS COMPENSATE FOR TRUNCATION ERROR.
C    IF ROUNDED ARITHMETIC IS USED THEN ONE MAY SUBSTITUTE
C     C1=AK
      C1=1.5-0.5*(AK*AK+S1*S1)
      S1=C1*S1
      C1=C1*AK
      KK=KK+JC
      IF(KK .LT. K2) GO TO 230
      K1=K1+INC+INC
      KK=(K1-KSPAN)/2+JC
      IF(KK .LE. JC+JC) GO TO 220
      GO TO 100
C  TRANSFORM FOR FACTOR OF 3 (OPTIONAL CODE)
  320 K1=KK+KSPAN
      K2=K1+KSPAN
      AK=A(KK)
      BK=B(KK)
      AJ=A(K1)+A(K2)
      BJ=B(K1)+B(K2)
      A(KK)=AK+AJ
      B(KK)=BK+BJ
      AK=-0.5*AJ+AK
      BK=-0.5*BJ+BK
      AJ=(A(K1)-A(K2))*S120
      BJ=(B(K1)-B(K2))*S120
      A(K1)=AK-BJ
      B(K1)=BK+AJ
      A(K2)=AK+BJ
      B(K2)=BK-AJ
      KK=K2+KSPAN
      IF(KK .LT. NN) GO TO 320
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 320
      GO TO 700
C  TRANSFORM FOR FACTOR OF 4
  400 IF(NFAC(I) .NE. 4) GO TO 600
      KSPNN=KSPAN
      KSPAN=KSPAN/4
  410 C1=1.0
      S1=0.0
  420 K1=KK+KSPAN
      K2=K1+KSPAN
      K3=K2+KSPAN
      AKP=A(KK)+A(K2)
      AKM=A(KK)-A(K2)
      AJP=A(K1)+A(K3)
      AJM=A(K1)-A(K3)
      A(KK)=AKP+AJP
      AJP=AKP-AJP
      BKP=B(KK)+B(K2)
      BKM=B(KK)-B(K2)
      BJP=B(K1)+B(K3)
      BJM=B(K1)-B(K3)
      B(KK)=BKP+BJP
      BJP=BKP-BJP
      IF(ISN .LT. 0) GO TO 450
      AKP=AKM-BJM
      AKM=AKM+BJM
      BKP=BKM+AJM
      BKM=BKM-AJM
      IF(S1 .EQ. 0.0) GO TO 460
  430 A(K1)=AKP*C1-BKP*S1
      B(K1)=AKP*S1+BKP*C1
      A(K2)=AJP*C2-BJP*S2
      B(K2)=AJP*S2+BJP*C2
      A(K3)=AKM*C3-BKM*S3
      B(K3)=AKM*S3+BKM*C3
      KK=K3+KSPAN
      IF(KK .LE. NT) GO TO 420
  440 U=SD*S1+CD*C1
      V=SD*C1-CD*S1
      C2=C1-U
      S1=S1+V
C  THE FOLLOWING THREE STATEMENTS COMPENSATE FOR TRUNCATION ERROR.
C    IF ROUNDED ARITHMETIC IS USED THEN ONE MAY SUBSTITUTE
C     C1=C2
      C1=1.5-0.5*(C2*C2+S1*S1)
      S1=C1*S1
      C1=C1*C2
      C2=C1*C1-S1*S1
      S2=2.0*C1*S1
      C3=C2*C1-S2*S1
      S3=C2*S1+S2*C1
      KK=KK-NT+JC
      IF(KK .LE. KSPAN) GO TO 420
      KK=KK-KSPAN+INC
      IF(KK .LE. JC) GO TO 410
      IF(KSPAN .EQ. JC) GO TO 800
      GO TO 100
  450 AKP=AKM+BJM
      AKM=AKM-BJM
      BKP=BKM-AJM
      BKM=BKM+AJM
      IF(S1 .NE. 0.0) GO TO 430
  460 A(K1)=AKP
      B(K1)=BKP
      A(K2)=AJP
      B(K2)=BJP
      A(K3)=AKM
      B(K3)=BKM
      KK=K3+KSPAN
      IF(KK .LE. NT) GO TO 420
      GO TO 440
C  TRANSFORM FOR FACTOR OF 5 (OPTIONAL CODE)
  510 C2=C72**2-S72**2
      S2=2.0*C72*S72
  520 K1=KK+KSPAN
      K2=K1+KSPAN
      K3=K2+KSPAN
      K4=K3+KSPAN
      AKP=A(K1)+A(K4)
      AKM=A(K1)-A(K4)
      BKP=B(K1)+B(K4)
      BKM=B(K1)-B(K4)
      AJP=A(K2)+A(K3)
      AJM=A(K2)-A(K3)
      BJP=B(K2)+B(K3)
      BJM=B(K2)-B(K3)
      AA=A(KK)
      BB=B(KK)
      A(KK)=AA+AKP+AJP
      B(KK)=BB+BKP+BJP
      AK=AKP*C72+AJP*C2+AA
      BK=BKP*C72+BJP*C2+BB
      AJ=AKM*S72+AJM*S2
      BJ=BKM*S72+BJM*S2
      A(K1)=AK-BJ
      A(K4)=AK+BJ
      B(K1)=BK+AJ
      B(K4)=BK-AJ
      AK=AKP*C2+AJP*C72+AA
      BK=BKP*C2+BJP*C72+BB
      AJ=AKM*S2-AJM*S72
      BJ=BKM*S2-BJM*S72
      A(K2)=AK-BJ
      A(K3)=AK+BJ
      B(K2)=BK+AJ
      B(K3)=BK-AJ
      KK=K4+KSPAN
      IF(KK .LT. NN) GO TO 520
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 520
      GO TO 700
C  TRANSFORM FOR ODD FACTORS
  600 K=NFAC(I)
      KSPNN=KSPAN
      KSPAN=KSPAN/K
      IF(K .EQ. 3) GO TO 320
      IF(K .EQ. 5) GO TO 510
      IF(K .EQ. JF) GO TO 640
      JF=K
      S1=RAD/FLOAT(K)
      C1=COS(S1)
      S1=SIN(S1)
      CK(JF)=1.0
      SK(JF)=0.0
      J=1
  630 CK(J)=CK(K)*C1+SK(K)*S1
      SK(J)=CK(K)*S1-SK(K)*C1
      K=K-1
      CK(K)=CK(J)
      SK(K)=-SK(J)
      J=J+1
      IF(J .LT. K) GO TO 630
  640 K1=KK
      K2=KK+KSPNN
      AA=A(KK)
      BB=B(KK)
      AK=AA
      BK=BB
      J=1
      K1=K1+KSPAN
  650 K2=K2-KSPAN
      J=J+1
      AT(J)=A(K1)+A(K2)
      AK=AT(J)+AK
      BT(J)=B(K1)+B(K2)
      BK=BT(J)+BK
      J=J+1
      AT(J)=A(K1)-A(K2)
      BT(J)=B(K1)-B(K2)
      K1=K1+KSPAN
      IF(K1 .LT. K2) GO TO 650
      A(KK)=AK
      B(KK)=BK
      K1=KK
      K2=KK+KSPNN
      J=1
  660 K1=K1+KSPAN
      K2=K2-KSPAN
      JJ=J
      AK=AA
      BK=BB
      AJ=0.0
      BJ=0.0
      K=1
  670 K=K+1
      AK=AT(K)*CK(JJ)+AK
      BK=BT(K)*CK(JJ)+BK
      K=K+1
      AJ=AT(K)*SK(JJ)+AJ
      BJ=BT(K)*SK(JJ)+BJ
      JJ=JJ+J
      IF(JJ .GT. JF) JJ=JJ-JF
      IF(K .LT. JF) GO TO 670
      K=JF-J
      A(K1)=AK-BJ
      B(K1)=BK+AJ
      A(K2)=AK+BJ
      B(K2)=BK-AJ
      J=J+1
      IF(J .LT. K) GO TO 660
      KK=KK+KSPNN
      IF(KK .LE. NN) GO TO 640
      KK=KK-NN
      IF(KK .LE. KSPAN) GO TO 640
C  MULTIPLY BY ROTATION FACTOR (EXCEPT FOR FACTORS OF 2 AND 4)
  700 IF(I .EQ. M) GO TO 800
      KK=JC+1
  710 C2=1.0-CD
      S1=SD
  720 C1=C2
      S2=S1
      KK=KK+KSPAN
  730 AK=A(KK)
      A(KK)=C2*AK-S2*B(KK)
      B(KK)=S2*AK+C2*B(KK)
      KK=KK+KSPNN
      IF(KK .LE. NT) GO TO 730
      AK=S1*S2
      S2=S1*C2+C1*S2
      C2=C1*C2-AK
      KK=KK-NT+KSPAN
      IF(KK .LE. KSPNN) GO TO 730
      U=SD*S1+CD*C1
      V=SD*C1-CD*S1
      C2=C1-U
      S1=S1+V
C  THE FOLLOWING THREE STATEMENTS COMPENSATE FOR TRUNCATION
C    ERROR.  IF ROUNDED ARITHMETIC IS USED THEN THEY MAY
C    BE DELETED.
      C1=1.5-0.5*(C2*C2+S1*S1)
      S1=C1*S1
      C2=C1*C2
      KK=KK-KSPNN+JC
      IF(KK .LE. KSPAN) GO TO 720
      KK=KK-KSPAN+JC+INC
      IF(KK .LE. JC+JC) GO TO 710
      GO TO 100
C  PERMUTE THE RESULTS TO NORMAL ORDER---DONE IN TWO STAGES
C  PERMUTATION FOR SQUARE FACTORS OF N
  800 NP(1)=KS
      IF(KT .EQ. 0) GO TO 890
      K=KT+KT+1
      IF(M .LT. K) K=K-1
      J=1
      NP(K+1)=JC
  810 NP(J+1)=NP(J)/NFAC(J)
      NP(K)=NP(K+1)*NFAC(J)
      J=J+1
      K=K-1
      IF(J .LT. K) GO TO 810
      K3=NP(K+1)
      KSPAN=NP(2)
      KK=JC+1
      K2=KSPAN+1
      J=1
      IF(N .NE. NTOT) GO TO 850
C  PERMUTATION FOR SINGLE-VARIATE TRANSFORM (OPTIONAL CODE)
  820 AK=A(KK)
      A(KK)=A(K2)
      A(K2)=AK
      BK=B(KK)
      B(KK)=B(K2)
      B(K2)=BK
      KK=KK+INC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 820
  830 K2=K2-NP(J)
      J=J+1
      K2=NP(J+1)+K2
      IF(K2 .GT. NP(J)) GO TO 830
      J=1
  840 IF(KK .LT. K2) GO TO 820
      KK=KK+INC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 840
      IF(KK .LT. KS) GO TO 830
      JC=K3
      GO TO 890
C  PERMUTATION FOR MULTIVARIATE TRANSFORM
  850 K=KK+JC
  860 AK=A(KK)
      A(KK)=A(K2)
      A(K2)=AK
      BK=B(KK)
      B(KK)=B(K2)
      B(K2)=BK
      KK=KK+INC
      K2=K2+INC
      IF(KK .LT. K) GO TO 860
      KK=KK+KS-JC
      K2=K2+KS-JC
      IF(KK .LT. NT) GO TO 850
      K2=K2-NT+KSPAN
      KK=KK-NT+JC
      IF(K2 .LT. KS) GO TO 850
  870 K2=K2-NP(J)
      J=J+1
      K2=NP(J+1)+K2
      IF(K2 .GT. NP(J)) GO TO 870
      J=1
  880 IF(KK .LT. K2) GO TO 850
      KK=KK+JC
      K2=KSPAN+K2
      IF(K2 .LT. KS) GO TO 880
      IF(KK .LT. KS) GO TO 870
      JC=K3
  890 IF(2*KT+1 .GE. M) RETURN
      KSPNN=NP(KT+1)
C  PERMUTATION FOR SQUARE-FREE FACTORS OF N
      J=M-KT
      NFAC(J+1)=1
  900 NFAC(J)=NFAC(J)*NFAC(J+1)
      J=J-1
      IF(J .NE. KT) GO TO 900
      KT=KT+1
      NN=NFAC(KT)-1
      JJ=0
      J=0
      GO TO 906
  902 JJ=JJ-K2
      K2=KK
      K=K+1
      KK=NFAC(K)
  904 JJ=KK+JJ
      IF(JJ .GE. K2) GO TO 902
      NP(J)=JJ
  906 K2=NFAC(KT)
      K=KT+1
      KK=NFAC(K)
      J=J+1
      IF(J .LE. NN) GO TO 904
C  DETERMINE THE PERMUTATION CYCLES OF LENGTH GREATER THAN 1
      J=0
      GO TO 914
  910 K=KK
      KK=NP(K)
      NP(K)=-KK
      IF(KK .NE. J) GO TO 910
      K3=KK
  914 J=J+1
      KK=NP(J)
      IF(KK .LT. 0) GO TO 914
      IF(KK .NE. J) GO TO 910
      NP(J)=-J
      IF(J .NE. NN) GO TO 914
      MAXF=INC*MAXF
C  REORDER A AND B, FOLLOWING THE PERMUTATION CYCLES
      GO TO 950
  924 J=J-1
      IF(NP(J) .LT. 0) GO TO 924
      JJ=JC
  926 KSPAN=JJ
      IF(JJ .GT. MAXF) KSPAN=MAXF
      JJ=JJ-KSPAN
      K=NP(J)
      KK=JC*K+II+JJ
      K1=KK+KSPAN
      K2=0
  928 K2=K2+1
      AT(K2)=A(K1)
      BT(K2)=B(K1)
      K1=K1-INC
      IF(K1 .NE. KK) GO TO 928
  932 K1=KK+KSPAN
      K2=K1-JC*(K+NP(K))
      K=-NP(K)
  936 A(K1)=A(K2)
      B(K1)=B(K2)
      K1=K1-INC
      K2=K2-INC
      IF(K1 .NE. KK) GO TO 936
      KK=K2
      IF(K .NE. J) GO TO 932
      K1=KK+KSPAN
      K2=0
  940 K2=K2+1
      A(K1)=AT(K2)
      B(K1)=BT(K2)
      K1=K1-INC
      IF(K1 .NE. KK) GO TO 940
      IF(JJ .NE. 0) GO TO 926
      IF(J .NE. 1) GO TO 924
  950 J=K3+1
      NT=NT-KSPNN
      II=NT-INC+1
      IF(NT .GE. 0) GO TO 924
  960 RETURN
C  ERROR FINISH - THERE IS AN INPUT ERROR
 1000 IERR=1
      RETURN
 1001 IERR=2
      RETURN
 1002 IERR=3
      RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE COSQI(N,WSAVE)
C
C     ******************************************************************
C
C     SUBROUTINE COSQI INITIALIZES THE ARRAY WSAVE WHICH IS USED IN
C     BOTH COSQF AND COSQB. THE PRIME FACTORIZATION OF N TOGETHER WITH
C     A TABULATION OF THE TRIGONOMETRIC FUNCTIONS ARE COMPUTED AND
C     STORED IN WSAVE.
C
C     INPUT PARAMETER
C
C     N       THE LENGTH OF THE ARRAY TO BE TRANSFORMED.  THE METHOD
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
C
C     OUTPUT PARAMETER
C
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
C             THE SAME WORK ARRAY CAN BE USED FOR BOTH COSQF AND COSQB
C             AS LONG AS N REMAINS UNCHANGED. DIFFERENT WSAVE ARRAYS
C             ARE REQUIRED FOR DIFFERENT VALUES OF N. THE CONTENTS OF
C             WSAVE MUST NOT BE CHANGED BETWEEN CALLS OF COSQF OR COSQB.
C
      SUBROUTINE COSQI (N,WSAVE)
      DIMENSION       WSAVE(*)
      DATA PIH /1.57079632679491/
      DT = PIH/FLOAT(N)
      FK = 0.
      DO 101 K=1,N
         FK = FK+1.
         WSAVE(K) = COS(FK*DT)
  101 CONTINUE
      CALL RFFTI (N,WSAVE(N+1))
      RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE COSQF(N,X,WSAVE)
C
C     ******************************************************************
C
C     SUBROUTINE COSQF COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
C     WAVE DATA. THAT IS , COSQF COMPUTES THE COEFFICIENTS IN A COSINE
C     SERIES REPRESENTATION WITH ONLY ODD WAVE NUMBERS. THE TRANSFORM
C     IS DEFINED BELOW AT OUTPUT PARAMETER X
C
C     COSQF IS THE UNNORMALIZED INVERSE OF COSQB SINCE A CALL OF COSQF
C     FOLLOWED BY A CALL OF COSQB WILL MULTIPLY THE INPUT SEQUENCE X
C     BY 4*N.
C
C     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE COSQF MUST BE
C     INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE).
C
C
C     INPUT PARAMETERS
C
C     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
C
C     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
C
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15
C             IN THE PROGRAM THAT CALLS COSQF. THE WSAVE ARRAY MUST BE
C             INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE) AND A
C             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
C             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
C             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
C             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
C
C     OUTPUT PARAMETERS
C
C     X       FOR I=1,...,N
C
C                  X(I) = X(1) PLUS THE SUM FROM K=2 TO K=N OF
C
C                     2*X(K)*COS((2*I-1)*(K-1)*PI/(2*N))
C
C                  A CALL OF COSQF FOLLOWED BY A CALL OF
C                  COSQB WILL MULTIPLY THE SEQUENCE X BY 4*N.
C                  THEREFORE COSQB IS THE UNNORMALIZED INVERSE
C                  OF COSQF.
C
C     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
C             BE DESTROYED BETWEEN CALLS OF COSQF OR COSQB.
C
      SUBROUTINE COSQF (N,X,WSAVE)
      DIMENSION X(*), WSAVE(*)
      DATA SQRT2 /1.4142135623731/
      IF (N-2) 102,101,103
  101 TSQX = SQRT2*X(2)
      X(2) = X(1)-TSQX
      X(1) = X(1)+TSQX
  102 RETURN
  103 CALL COSQF1 (N,X,WSAVE,WSAVE(N+1))
      RETURN
      END
      SUBROUTINE COSQF1 (N,X,W,XH)
      DIMENSION       X(*)       ,W(*)       ,XH(*)
      NS2 = (N+1)/2
      NP2 = N+2
      DO 101 K=2,NS2
         KC = NP2-K
         XH(K) = X(K)+X(KC)
         XH(KC) = X(K)-X(KC)
  101 CONTINUE
      MODN = MOD(N,2)
      IF (MODN .EQ. 0) XH(NS2+1) = X(NS2+1)+X(NS2+1)
      DO 102 K=2,NS2
         KC = NP2-K
         X(K) = W(K-1)*XH(KC)+W(KC-1)*XH(K)
         X(KC) = W(K-1)*XH(K)-W(KC-1)*XH(KC)
  102 CONTINUE
      IF (MODN .EQ. 0) X(NS2+1) = W(NS2)*XH(NS2+1)
      CALL RFFTF (N,X,XH)
      DO 103 I=3,N,2
         XIM1 = X(I-1)-X(I)
         X(I) = X(I-1)+X(I)
         X(I-1) = XIM1
  103 CONTINUE
      RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE COSQB(N,X,WSAVE)
C
C     ******************************************************************
C
C     SUBROUTINE COSQB COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
C     WAVE DATA. THAT IS , COSQB COMPUTES A SEQUENCE FROM ITS
C     REPRESENTATION IN TERMS OF A COSINE SERIES WITH ODD WAVE NUMBERS.
C     THE TRANSFORM IS DEFINED BELOW AT OUTPUT PARAMETER X.
C
C     COSQB IS THE UNNORMALIZED INVERSE OF COSQF SINCE A CALL OF COSQB
C     FOLLOWED BY A CALL OF COSQF WILL MULTIPLY THE INPUT SEQUENCE X
C     BY 4*N.
C
C     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE COSQB MUST BE
C     INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE).
C
C
C     INPUT PARAMETERS
C
C     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
C
C     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
C
C     WSAVE   A WORK ARRAY THAT MUST BE DIMENSIONED AT LEAST 3*N+15
C             IN THE PROGRAM THAT CALLS COSQB. THE WSAVE ARRAY MUST BE
C             INITIALIZED BY CALLING SUBROUTINE COSQI(N,WSAVE) AND A
C             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
C             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
C             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
C             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
C
C     OUTPUT PARAMETERS
C
C     X       FOR I=1,...,N
C
C                  X(I)= THE SUM FROM K=1 TO K=N OF
C
C                    4*X(K)*COS((2*K-1)*(I-1)*PI/(2*N))
C
C                  A CALL OF COSQB FOLLOWED BY A CALL OF
C                  COSQF WILL MULTIPLY THE SEQUENCE X BY 4*N.
C                  THEREFORE COSQF IS THE UNNORMALIZED INVERSE
C                  OF COSQB.
C
C     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
C             BE DESTROYED BETWEEN CALLS OF COSQB OR COSQF.
C
      SUBROUTINE COSQB (N,X,WSAVE)
      DIMENSION X(*), WSAVE(*)
      DATA TSQRT2 /2.82842712474619/
      IF (N-2) 101,102,103
  101 X(1) = 4.*X(1)
      RETURN
  102 X1 = 4.*(X(1)+X(2))
      X(2) = TSQRT2*(X(1)-X(2))
      X(1) = X1
      RETURN
  103 CALL COSQB1 (N,X,WSAVE,WSAVE(N+1))
      RETURN
      END
      SUBROUTINE COSQB1 (N,X,W,XH)
      DIMENSION       X(*)       ,W(*)       ,XH(*)
      NS2 = (N+1)/2
      NP2 = N+2
      DO 101 I=3,N,2
         XIM1 = X(I-1)+X(I)
         X(I) = X(I)-X(I-1)
         X(I-1) = XIM1
  101 CONTINUE
      X(1) = X(1)+X(1)
      MODN = MOD(N,2)
      IF (MODN .EQ. 0) X(N) = X(N)+X(N)
      CALL RFFTB (N,X,XH)
      DO 102 K=2,NS2
         KC = NP2-K
         XH(K) = W(K-1)*X(KC)+W(KC-1)*X(K)
         XH(KC) = W(K-1)*X(K)-W(KC-1)*X(KC)
  102 CONTINUE
      IF (MODN .EQ. 0) X(NS2+1) = W(NS2)*(X(NS2+1)+X(NS2+1))
      DO 103 K=2,NS2
         KC = NP2-K
         X(K) = XH(K)+XH(KC)
         X(KC) = XH(K)-XH(KC)
  103 CONTINUE
      X(1) = X(1)+X(1)
      RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE SINQF(N,X,WSAVE)
C
C     ******************************************************************
C
C     SUBROUTINE SINQF COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
C     WAVE DATA. THAT IS , SINQF COMPUTES THE COEFFICIENTS IN A SINE
C     SERIES REPRESENTATION WITH ONLY ODD WAVE NUMBERS. THE TRANSFORM
C     IS DEFINED BELOW AT OUTPUT PARAMETER X.
C
C     SINQB IS THE UNNORMALIZED INVERSE OF SINQF SINCE A CALL OF SINQF
C     FOLLOWED BY A CALL OF SINQB WILL MULTIPLY THE INPUT SEQUENCE X
C     BY 4*N.
C
C     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE SINQF MUST BE
C     INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE).
C
C
C     INPUT PARAMETERS
C
C     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
C
C     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
C
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
C             IN THE PROGRAM THAT CALLS SINQF. THE WSAVE ARRAY MUST BE
C             INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE) AND A
C             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
C             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
C             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
C             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
C
C     OUTPUT PARAMETERS
C
C     X       FOR I=1,...,N
C
C                  X(I) = (-1)**(I-1)*X(N)
C
C                     + THE SUM FROM K=1 TO K=N-1 OF
C
C                     2*X(K)*SIN((2*I-1)*K*PI/(2*N))
C
C                  A CALL OF SINQF FOLLOWED BY A CALL OF
C                  SINQB WILL MULTIPLY THE SEQUENCE X BY 4*N.
C                  THEREFORE SINQB IS THE UNNORMALIZED INVERSE
C                  OF SINQF.
C
C     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
C             BE DESTROYED BETWEEN CALLS OF SINQF OR SINQB.
C
      SUBROUTINE SINQF (N,X,WSAVE)
      DIMENSION       X(*)       ,WSAVE(*)
      IF (N .EQ. 1) RETURN
      NS2 = N/2
      DO 101 K=1,NS2
         KC = N-K
         XHOLD = X(K)
         X(K) = X(KC+1)
         X(KC+1) = XHOLD
  101 CONTINUE
      CALL COSQF (N,X,WSAVE)
      DO 102 K=2,N,2
         X(K) = -X(K)
  102 CONTINUE
      RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE SINQB(N,X,WSAVE)
C
C     ******************************************************************
C
C     SUBROUTINE SINQB COMPUTES THE FAST FOURIER TRANSFORM OF QUARTER
C     WAVE DATA. THAT IS , SINQB COMPUTES A SEQUENCE FROM ITS
C     REPRESENTATION IN TERMS OF A SINE SERIES WITH ODD WAVE NUMBERS.
C     THE TRANSFORM IS DEFINED BELOW AT OUTPUT PARAMETER X.
C
C     SINQF IS THE UNNORMALIZED INVERSE OF SINQB SINCE A CALL OF SINQB
C     FOLLOWED BY A CALL OF SINQF WILL MULTIPLY THE INPUT SEQUENCE X
C     BY 4*N.
C
C     THE ARRAY WSAVE WHICH IS USED BY SUBROUTINE SINQB MUST BE
C     INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE).
C
C
C     INPUT PARAMETERS
C
C     N       THE LENGTH OF THE ARRAY X TO BE TRANSFORMED.  THE METHOD
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
C
C     X       AN ARRAY WHICH CONTAINS THE SEQUENCE TO BE TRANSFORMED
C
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15.
C             IN THE PROGRAM THAT CALLS SINQB. THE WSAVE ARRAY MUST BE
C             INITIALIZED BY CALLING SUBROUTINE SINQI(N,WSAVE) AND A
C             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
C             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
C             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
C             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
C
C     OUTPUT PARAMETERS
C
C     X       FOR I=1,...,N
C
C                  X(I)= THE SUM FROM K=1 TO K=N OF
C
C                    4*X(K)*SIN((2K-1)*I*PI/(2*N))
C
C                  A CALL OF SINQB FOLLOWED BY A CALL OF
C                  SINQF WILL MULTIPLY THE SEQUENCE X BY 4*N.
C                  THEREFORE SINQF IS THE UNNORMALIZED INVERSE
C                  OF SINQB.
C
C     WSAVE   CONTAINS INITIALIZATION CALCULATIONS WHICH MUST NOT
C             BE DESTROYED BETWEEN CALLS OF SINQB OR SINQF.
C
      SUBROUTINE SINQB (N,X,WSAVE)
      DIMENSION       X(*)       ,WSAVE(*)
      IF (N .GT. 1) GO TO 101
      X(1) = 4.*X(1)
      RETURN
  101 NS2 = N/2
      DO 102 K=2,N,2
         X(K) = -X(K)
  102 CONTINUE
      CALL COSQB (N,X,WSAVE)
      DO 103 K=1,NS2
         KC = N-K
         XHOLD = X(K)
         X(K) = X(KC+1)
         X(KC+1) = XHOLD
  103 CONTINUE
      RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE RFFTI(N,WSAVE)
C
C       ****************************************************************
C
C     SUBROUTINE RFFTI INITIALIZES THE ARRAY WSAVE WHICH IS USED IN
C     BOTH RFFTF AND RFFTB. THE PRIME FACTORIZATION OF N TOGETHER WITH
C     A TABULATION OF THE TRIGONOMETRIC FUNCTIONS ARE COMPUTED AND
C     STORED IN WSAVE.
C
C     INPUT PARAMETER
C
C     N       THE LENGTH OF THE SEQUENCE TO BE TRANSFORMED.
C
C     OUTPUT PARAMETER
C
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
C             THE SAME WORK ARRAY CAN BE USED FOR BOTH RFFTF AND RFFTB
C             AS LONG AS N REMAINS UNCHANGED. DIFFERENT WSAVE ARRAYS
C             ARE REQUIRED FOR DIFFERENT VALUES OF N. THE CONTENTS OF
C             WSAVE MUST NOT BE CHANGED BETWEEN CALLS OF RFFTF OR RFFTB.
C
      SUBROUTINE RFFTI (N,WSAVE)
      DIMENSION       WSAVE(*)
      IF (N .EQ. 1) RETURN
      CALL RFFTI1 (N,WSAVE(N+1),WSAVE(2*N+1))
      RETURN
      END
      SUBROUTINE RFFTI1 (N,WA,IFAC)
      REAL WA(*), IFAC(*)
      INTEGER NTRYH(4)
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/4,2,3,5/
      NL = N
      NF = 0
      J = 0
  101 J = J+1
      IF (J-4) 102,102,103
  102 NTRY = NTRYH(J)
      GO TO 104
  103 NTRY = NTRY+2
  104 NQ = NL/NTRY
      NR = NL-NTRY*NQ
      IF (NR) 101,105,101
  105 NF = NF+1
      IFAC(NF+2) = NTRY
      NL = NQ
      IF (NTRY .NE. 2) GO TO 107
      IF (NF .EQ. 1) GO TO 107
      DO 106 I=2,NF
         IB = NF-I+2
         IFAC(IB+2) = IFAC(IB+1)
  106 CONTINUE
      IFAC(3) = 2
  107 IF (NL .NE. 1) GO TO 104
      IFAC(1) = N
      IFAC(2) = NF
      TPI = 6.28318530717959
      ARGH = TPI/FLOAT(N)
      IS = 0
      NFM1 = NF-1
      L1 = 1
      IF (NFM1 .EQ. 0) RETURN
      DO 110 K1=1,NFM1
         IP = IFAC(K1+2)
         LD = 0
         L2 = L1*IP
         IDO = N/L2
         IPM = IP-1
         DO 109 J=1,IPM
            LD = LD+L1
            I = IS
            ARGLD = FLOAT(LD)*ARGH
            FI = 0.
            DO 108 II=3,IDO,2
               I = I+2
               FI = FI+1.
               ARG = FI*ARGLD
               WA(I-1) = COS(ARG)
               WA(I) = SIN(ARG)
  108       CONTINUE
            IS = IS+IDO
  109    CONTINUE
         L1 = L2
  110 CONTINUE
      RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE RFFTB(N,R,WSAVE)
C
C     ******************************************************************
C
C     SUBROUTINE RFFTB COMPUTES THE REAL PERODIC SEQUENCE FROM ITS
C     FOURIER COEFFICIENTS (FOURIER SYNTHESIS). THE TRANSFORM IS DEFINED
C     BELOW AT OUTPUT PARAMETER R.
C
C     INPUT PARAMETERS
C
C     N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
C             N MAY CHANGE SO LONG AS DIFFERENT WORK ARRAYS ARE PROVIDED
C
C     R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE
C             TO BE TRANSFORMED
C
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
C             IN THE PROGRAM THAT CALLS RFFTB. THE WSAVE ARRAY MUST BE
C             INITIALIZED BY CALLING SUBROUTINE RFFTI(N,WSAVE) AND A
C             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
C             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
C             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
C             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
C             THE SAME WSAVE ARRAY CAN BE USED BY RFFTF AND RFFTB.
C
C
C     OUTPUT PARAMETERS
C
C     R       FOR N EVEN AND FOR I = 1,...,N
C
C                  R(I) = R(1)+(-1)**(I-1)*R(N)
C
C                       PLUS THE SUM FROM K=2 TO K=N/2 OF
C
C                        2.*R(2*K-2)*COS((K-1)*(I-1)*2*PI/N)
C
C                       -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*PI/N)
C
C             FOR N ODD AND FOR I = 1,...,N
C
C                  R(I) = R(1) PLUS THE SUM FROM K=2 TO K=(N+1)/2 OF
C
C                       2.*R(2*K-2)*COS((K-1)*(I-1)*2*PI/N)
C
C                      -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*PI/N)
C
C      *****  NOTE
C                  THIS TRANSFORM IS UNNORMALIZED SINCE A CALL OF RFFTF
C                  FOLLOWED BY A CALL OF RFFTB WILL MULTIPLY THE INPUT
C                  SEQUENCE BY N.
C
C     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
C             CALLS OF RFFTB OR RFFTF.
C
C
      SUBROUTINE RFFTB (N,R,WSAVE)
      DIMENSION       R(*)       ,WSAVE(*)
      IF (N .EQ. 1) RETURN
      CALL RFFTB1 (N,R,WSAVE,WSAVE(N+1),WSAVE(2*N+1))
      RETURN
      END
      SUBROUTINE RFFTB1 (N,C,CH,WA,IFAC)
      REAL C(*), CH(*), WA(*), IFAC(*)
      NF = IFAC(2)
      NA = 0
      L1 = 1
      IW = 1
      DO 116 K1=1,NF
         IP = IFAC(K1+2)
         L2 = IP*L1
         IDO = N/L2
         IDL1 = IDO*L1
         IF (IP .NE. 4) GO TO 103
         IX2 = IW+IDO
         IX3 = IX2+IDO
         IF (NA .NE. 0) GO TO 101
         CALL RADB4 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3))
         GO TO 102
  101    CALL RADB4 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3))
  102    NA = 1-NA
         GO TO 115
  103    IF (IP .NE. 2) GO TO 106
         IF (NA .NE. 0) GO TO 104
         CALL RADB2 (IDO,L1,C,CH,WA(IW))
         GO TO 105
  104    CALL RADB2 (IDO,L1,CH,C,WA(IW))
  105    NA = 1-NA
         GO TO 115
  106    IF (IP .NE. 3) GO TO 109
         IX2 = IW+IDO
         IF (NA .NE. 0) GO TO 107
         CALL RADB3 (IDO,L1,C,CH,WA(IW),WA(IX2))
         GO TO 108
  107    CALL RADB3 (IDO,L1,CH,C,WA(IW),WA(IX2))
  108    NA = 1-NA
         GO TO 115
  109    IF (IP .NE. 5) GO TO 112
         IX2 = IW+IDO
         IX3 = IX2+IDO
         IX4 = IX3+IDO
         IF (NA .NE. 0) GO TO 110
         CALL RADB5 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))
         GO TO 111
  110    CALL RADB5 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))
  111    NA = 1-NA
         GO TO 115
  112    IF (NA .NE. 0) GO TO 113
         CALL RADBG (IDO,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))
         GO TO 114
  113    CALL RADBG (IDO,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))
  114    IF (IDO .EQ. 1) NA = 1-NA
  115    L1 = L2
         IW = IW+(IP-1)*IDO
  116 CONTINUE
      IF (NA .EQ. 0) RETURN
      DO 117 I=1,N
         C(I) = CH(I)
  117 CONTINUE
      RETURN
      END
      SUBROUTINE RADB2 (IDO,L1,CC,CH,WA1)
      DIMENSION       CC(IDO,2,L1)           ,CH(IDO,L1,*)           ,
     1                WA1(*)
      DO 101 K=1,L1
         CH(1,K,1) = CC(1,1,K)+CC(IDO,2,K)
         CH(1,K,2) = CC(1,1,K)-CC(IDO,2,K)
  101 CONTINUE
      IF (IDO-2) 107,105,102
  102 IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 108
      DO 104 K=1,L1
         DO 103 I=3,IDO,2
            IC = IDP2-I
            CH(I-1,K,1) = CC(I-1,1,K)+CC(IC-1,2,K)
            TR2 = CC(I-1,1,K)-CC(IC-1,2,K)
            CH(I,K,1) = CC(I,1,K)-CC(IC,2,K)
            TI2 = CC(I,1,K)+CC(IC,2,K)
            CH(I-1,K,2) = WA1(I-2)*TR2-WA1(I-1)*TI2
            CH(I,K,2) = WA1(I-2)*TI2+WA1(I-1)*TR2
  103    CONTINUE
  104 CONTINUE
      GO TO 111
  108 DO 110 I=3,IDO,2
         IC = IDP2-I
         DO 109 K=1,L1
            CH(I-1,K,1) = CC(I-1,1,K)+CC(IC-1,2,K)
            TR2 = CC(I-1,1,K)-CC(IC-1,2,K)
            CH(I,K,1) = CC(I,1,K)-CC(IC,2,K)
            TI2 = CC(I,1,K)+CC(IC,2,K)
            CH(I-1,K,2) = WA1(I-2)*TR2-WA1(I-1)*TI2
            CH(I,K,2) = WA1(I-2)*TI2+WA1(I-1)*TR2
  109    CONTINUE
  110 CONTINUE
  111 IF (MOD(IDO,2) .EQ. 1) RETURN
  105 DO 106 K=1,L1
         CH(IDO,K,1) = CC(IDO,1,K)+CC(IDO,1,K)
         CH(IDO,K,2) = -(CC(1,2,K)+CC(1,2,K))
  106 CONTINUE
  107 RETURN
      END
      SUBROUTINE RADB3 (IDO,L1,CC,CH,WA1,WA2)
      DIMENSION       CC(IDO,3,L1)           ,CH(IDO,L1,*)           ,
     1                WA1(*)     ,WA2(*)
      DATA TAUR,TAUI /-.5,.866025403784439/
      DO 101 K=1,L1
         TR2 = CC(IDO,2,K)+CC(IDO,2,K)
         CR2 = CC(1,1,K)+TAUR*TR2
         CH(1,K,1) = CC(1,1,K)+TR2
         CI3 = TAUI*(CC(1,3,K)+CC(1,3,K))
         CH(1,K,2) = CR2-CI3
         CH(1,K,3) = CR2+CI3
  101 CONTINUE
      IF (IDO .EQ. 1) RETURN
      IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 104
      DO 103 K=1,L1
         DO 102 I=3,IDO,2
            IC = IDP2-I
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)
            CR2 = CC(I-1,1,K)+TAUR*TR2
            CH(I-1,K,1) = CC(I-1,1,K)+TR2
            TI2 = CC(I,3,K)-CC(IC,2,K)
            CI2 = CC(I,1,K)+TAUR*TI2
            CH(I,K,1) = CC(I,1,K)+TI2
            CR3 = TAUI*(CC(I-1,3,K)-CC(IC-1,2,K))
            CI3 = TAUI*(CC(I,3,K)+CC(IC,2,K))
            DR2 = CR2-CI3
            DR3 = CR2+CI3
            DI2 = CI2+CR3
            DI3 = CI2-CR3
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3
  102    CONTINUE
  103 CONTINUE
      RETURN
  104 DO 106 I=3,IDO,2
         IC = IDP2-I
         DO 105 K=1,L1
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)
            CR2 = CC(I-1,1,K)+TAUR*TR2
            CH(I-1,K,1) = CC(I-1,1,K)+TR2
            TI2 = CC(I,3,K)-CC(IC,2,K)
            CI2 = CC(I,1,K)+TAUR*TI2
            CH(I,K,1) = CC(I,1,K)+TI2
            CR3 = TAUI*(CC(I-1,3,K)-CC(IC-1,2,K))
            CI3 = TAUI*(CC(I,3,K)+CC(IC,2,K))
            DR2 = CR2-CI3
            DR3 = CR2+CI3
            DI2 = CI2+CR3
            DI3 = CI2-CR3
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3
  105    CONTINUE
  106 CONTINUE
      RETURN
      END
      SUBROUTINE RADB4 (IDO,L1,CC,CH,WA1,WA2,WA3)
      DIMENSION       CC(IDO,4,L1)           ,CH(IDO,L1,*)           ,
     1                WA1(*)     ,WA2(*)     ,WA3(*)
      DATA SQRT2 /1.414213562373095/
      DO 101 K=1,L1
         TR1 = CC(1,1,K)-CC(IDO,4,K)
         TR2 = CC(1,1,K)+CC(IDO,4,K)
         TR3 = CC(IDO,2,K)+CC(IDO,2,K)
         TR4 = CC(1,3,K)+CC(1,3,K)
         CH(1,K,1) = TR2+TR3
         CH(1,K,2) = TR1-TR4
         CH(1,K,3) = TR2-TR3
         CH(1,K,4) = TR1+TR4
  101 CONTINUE
      IF (IDO-2) 107,105,102
  102 IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 108
      DO 104 K=1,L1
         DO 103 I=3,IDO,2
            IC = IDP2-I
            TI1 = CC(I,1,K)+CC(IC,4,K)
            TI2 = CC(I,1,K)-CC(IC,4,K)
            TI3 = CC(I,3,K)-CC(IC,2,K)
            TR4 = CC(I,3,K)+CC(IC,2,K)
            TR1 = CC(I-1,1,K)-CC(IC-1,4,K)
            TR2 = CC(I-1,1,K)+CC(IC-1,4,K)
            TI4 = CC(I-1,3,K)-CC(IC-1,2,K)
            TR3 = CC(I-1,3,K)+CC(IC-1,2,K)
            CH(I-1,K,1) = TR2+TR3
            CR3 = TR2-TR3
            CH(I,K,1) = TI2+TI3
            CI3 = TI2-TI3
            CR2 = TR1-TR4
            CR4 = TR1+TR4
            CI2 = TI1+TI4
            CI4 = TI1-TI4
            CH(I-1,K,2) = WA1(I-2)*CR2-WA1(I-1)*CI2
            CH(I,K,2) = WA1(I-2)*CI2+WA1(I-1)*CR2
            CH(I-1,K,3) = WA2(I-2)*CR3-WA2(I-1)*CI3
            CH(I,K,3) = WA2(I-2)*CI3+WA2(I-1)*CR3
            CH(I-1,K,4) = WA3(I-2)*CR4-WA3(I-1)*CI4
            CH(I,K,4) = WA3(I-2)*CI4+WA3(I-1)*CR4
  103    CONTINUE
  104 CONTINUE
      GO TO 111
  108 DO 110 I=3,IDO,2
         IC = IDP2-I
         DO 109 K=1,L1
            TI1 = CC(I,1,K)+CC(IC,4,K)
            TI2 = CC(I,1,K)-CC(IC,4,K)
            TI3 = CC(I,3,K)-CC(IC,2,K)
            TR4 = CC(I,3,K)+CC(IC,2,K)
            TR1 = CC(I-1,1,K)-CC(IC-1,4,K)
            TR2 = CC(I-1,1,K)+CC(IC-1,4,K)
            TI4 = CC(I-1,3,K)-CC(IC-1,2,K)
            TR3 = CC(I-1,3,K)+CC(IC-1,2,K)
            CH(I-1,K,1) = TR2+TR3
            CR3 = TR2-TR3
            CH(I,K,1) = TI2+TI3
            CI3 = TI2-TI3
            CR2 = TR1-TR4
            CR4 = TR1+TR4
            CI2 = TI1+TI4
            CI4 = TI1-TI4
            CH(I-1,K,2) = WA1(I-2)*CR2-WA1(I-1)*CI2
            CH(I,K,2) = WA1(I-2)*CI2+WA1(I-1)*CR2
            CH(I-1,K,3) = WA2(I-2)*CR3-WA2(I-1)*CI3
            CH(I,K,3) = WA2(I-2)*CI3+WA2(I-1)*CR3
            CH(I-1,K,4) = WA3(I-2)*CR4-WA3(I-1)*CI4
            CH(I,K,4) = WA3(I-2)*CI4+WA3(I-1)*CR4
  109    CONTINUE
  110 CONTINUE
  111 IF (MOD(IDO,2) .EQ. 1) RETURN
  105 DO 106 K=1,L1
         TI1 = CC(1,2,K)+CC(1,4,K)
         TI2 = CC(1,4,K)-CC(1,2,K)
         TR1 = CC(IDO,1,K)-CC(IDO,3,K)
         TR2 = CC(IDO,1,K)+CC(IDO,3,K)
         CH(IDO,K,1) = TR2+TR2
         CH(IDO,K,2) = SQRT2*(TR1-TI1)
         CH(IDO,K,3) = TI2+TI2
         CH(IDO,K,4) = -SQRT2*(TR1+TI1)
  106 CONTINUE
  107 RETURN
      END
      SUBROUTINE RADB5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)
      DIMENSION       CC(IDO,5,L1)           ,CH(IDO,L1,*)           ,
     1                WA1(*)     ,WA2(*)     ,WA3(*)     ,WA4(*)
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,
     1-.809016994374947,.587785252292473/
      DO 101 K=1,L1
         TI5 = CC(1,3,K)+CC(1,3,K)
         TI4 = CC(1,5,K)+CC(1,5,K)
         TR2 = CC(IDO,2,K)+CC(IDO,2,K)
         TR3 = CC(IDO,4,K)+CC(IDO,4,K)
         CH(1,K,1) = CC(1,1,K)+TR2+TR3
         CR2 = CC(1,1,K)+TR11*TR2+TR12*TR3
         CR3 = CC(1,1,K)+TR12*TR2+TR11*TR3
         CI5 = TI11*TI5+TI12*TI4
         CI4 = TI12*TI5-TI11*TI4
         CH(1,K,2) = CR2-CI5
         CH(1,K,3) = CR3-CI4
         CH(1,K,4) = CR3+CI4
         CH(1,K,5) = CR2+CI5
  101 CONTINUE
      IF (IDO .EQ. 1) RETURN
      IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 104
      DO 103 K=1,L1
         DO 102 I=3,IDO,2
            IC = IDP2-I
            TI5 = CC(I,3,K)+CC(IC,2,K)
            TI2 = CC(I,3,K)-CC(IC,2,K)
            TI4 = CC(I,5,K)+CC(IC,4,K)
            TI3 = CC(I,5,K)-CC(IC,4,K)
            TR5 = CC(I-1,3,K)-CC(IC-1,2,K)
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)
            TR4 = CC(I-1,5,K)-CC(IC-1,4,K)
            TR3 = CC(I-1,5,K)+CC(IC-1,4,K)
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3
            CH(I,K,1) = CC(I,1,K)+TI2+TI3
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3
            CR5 = TI11*TR5+TI12*TR4
            CI5 = TI11*TI5+TI12*TI4
            CR4 = TI12*TR5-TI11*TR4
            CI4 = TI12*TI5-TI11*TI4
            DR3 = CR3-CI4
            DR4 = CR3+CI4
            DI3 = CI3+CR4
            DI4 = CI3-CR4
            DR5 = CR2+CI5
            DR2 = CR2-CI5
            DI5 = CI2-CR5
            DI2 = CI2+CR5
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3
            CH(I-1,K,4) = WA3(I-2)*DR4-WA3(I-1)*DI4
            CH(I,K,4) = WA3(I-2)*DI4+WA3(I-1)*DR4
            CH(I-1,K,5) = WA4(I-2)*DR5-WA4(I-1)*DI5
            CH(I,K,5) = WA4(I-2)*DI5+WA4(I-1)*DR5
  102    CONTINUE
  103 CONTINUE
      RETURN
  104 DO 106 I=3,IDO,2
         IC = IDP2-I
         DO 105 K=1,L1
            TI5 = CC(I,3,K)+CC(IC,2,K)
            TI2 = CC(I,3,K)-CC(IC,2,K)
            TI4 = CC(I,5,K)+CC(IC,4,K)
            TI3 = CC(I,5,K)-CC(IC,4,K)
            TR5 = CC(I-1,3,K)-CC(IC-1,2,K)
            TR2 = CC(I-1,3,K)+CC(IC-1,2,K)
            TR4 = CC(I-1,5,K)-CC(IC-1,4,K)
            TR3 = CC(I-1,5,K)+CC(IC-1,4,K)
            CH(I-1,K,1) = CC(I-1,1,K)+TR2+TR3
            CH(I,K,1) = CC(I,1,K)+TI2+TI3
            CR2 = CC(I-1,1,K)+TR11*TR2+TR12*TR3
            CI2 = CC(I,1,K)+TR11*TI2+TR12*TI3
            CR3 = CC(I-1,1,K)+TR12*TR2+TR11*TR3
            CI3 = CC(I,1,K)+TR12*TI2+TR11*TI3
            CR5 = TI11*TR5+TI12*TR4
            CI5 = TI11*TI5+TI12*TI4
            CR4 = TI12*TR5-TI11*TR4
            CI4 = TI12*TI5-TI11*TI4
            DR3 = CR3-CI4
            DR4 = CR3+CI4
            DI3 = CI3+CR4
            DI4 = CI3-CR4
            DR5 = CR2+CI5
            DR2 = CR2-CI5
            DI5 = CI2-CR5
            DI2 = CI2+CR5
            CH(I-1,K,2) = WA1(I-2)*DR2-WA1(I-1)*DI2
            CH(I,K,2) = WA1(I-2)*DI2+WA1(I-1)*DR2
            CH(I-1,K,3) = WA2(I-2)*DR3-WA2(I-1)*DI3
            CH(I,K,3) = WA2(I-2)*DI3+WA2(I-1)*DR3
            CH(I-1,K,4) = WA3(I-2)*DR4-WA3(I-1)*DI4
            CH(I,K,4) = WA3(I-2)*DI4+WA3(I-1)*DR4
            CH(I-1,K,5) = WA4(I-2)*DR5-WA4(I-1)*DI5
            CH(I,K,5) = WA4(I-2)*DI5+WA4(I-1)*DR5
  105    CONTINUE
  106 CONTINUE
      RETURN
      END
      SUBROUTINE RADBG (IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,
     1                C1(IDO,L1,IP)          ,C2(IDL1,IP),
     2                CH2(IDL1,IP)           ,WA(*)
      DATA TPI/6.28318530717959/
      ARG = TPI/FLOAT(IP)
      DCP = COS(ARG)
      DSP = SIN(ARG)
      IDP2 = IDO+2
      NBD = (IDO-1)/2
      IPP2 = IP+2
      IPPH = (IP+1)/2
      IF (IDO .LT. L1) GO TO 103
      DO 102 K=1,L1
         DO 101 I=1,IDO
            CH(I,K,1) = CC(I,1,K)
  101    CONTINUE
  102 CONTINUE
      GO TO 106
  103 DO 105 I=1,IDO
         DO 104 K=1,L1
            CH(I,K,1) = CC(I,1,K)
  104    CONTINUE
  105 CONTINUE
  106 DO 108 J=2,IPPH
         JC = IPP2-J
         J2 = J+J
         DO 107 K=1,L1
            CH(1,K,J) = CC(IDO,J2-2,K)+CC(IDO,J2-2,K)
            CH(1,K,JC) = CC(1,J2-1,K)+CC(1,J2-1,K)
  107    CONTINUE
  108 CONTINUE
      IF (IDO .EQ. 1) GO TO 116
      IF (NBD .LT. L1) GO TO 112
      DO 111 J=2,IPPH
         JC = IPP2-J
         DO 110 K=1,L1
            DO 109 I=3,IDO,2
               IC = IDP2-I
               CH(I-1,K,J) = CC(I-1,2*J-1,K)+CC(IC-1,2*J-2,K)
               CH(I-1,K,JC) = CC(I-1,2*J-1,K)-CC(IC-1,2*J-2,K)
               CH(I,K,J) = CC(I,2*J-1,K)-CC(IC,2*J-2,K)
               CH(I,K,JC) = CC(I,2*J-1,K)+CC(IC,2*J-2,K)
  109       CONTINUE
  110    CONTINUE
  111 CONTINUE
      GO TO 116
  112 DO 115 J=2,IPPH
         JC = IPP2-J
         DO 114 I=3,IDO,2
            IC = IDP2-I
            DO 113 K=1,L1
               CH(I-1,K,J) = CC(I-1,2*J-1,K)+CC(IC-1,2*J-2,K)
               CH(I-1,K,JC) = CC(I-1,2*J-1,K)-CC(IC-1,2*J-2,K)
               CH(I,K,J) = CC(I,2*J-1,K)-CC(IC,2*J-2,K)
               CH(I,K,JC) = CC(I,2*J-1,K)+CC(IC,2*J-2,K)
  113       CONTINUE
  114    CONTINUE
  115 CONTINUE
  116 AR1 = 1.
      AI1 = 0.
      DO 120 L=2,IPPH
         LC = IPP2-L
         AR1H = DCP*AR1-DSP*AI1
         AI1 = DCP*AI1+DSP*AR1
         AR1 = AR1H
         DO 117 IK=1,IDL1
            C2(IK,L) = CH2(IK,1)+AR1*CH2(IK,2)
            C2(IK,LC) = AI1*CH2(IK,IP)
  117    CONTINUE
         DC2 = AR1
         DS2 = AI1
         AR2 = AR1
         AI2 = AI1
         DO 119 J=3,IPPH
            JC = IPP2-J
            AR2H = DC2*AR2-DS2*AI2
            AI2 = DC2*AI2+DS2*AR2
            AR2 = AR2H
            DO 118 IK=1,IDL1
               C2(IK,L) = C2(IK,L)+AR2*CH2(IK,J)
               C2(IK,LC) = C2(IK,LC)+AI2*CH2(IK,JC)
  118       CONTINUE
  119    CONTINUE
  120 CONTINUE
      DO 122 J=2,IPPH
         DO 121 IK=1,IDL1
            CH2(IK,1) = CH2(IK,1)+CH2(IK,J)
  121    CONTINUE
  122 CONTINUE
      DO 124 J=2,IPPH
         JC = IPP2-J
         DO 123 K=1,L1
            CH(1,K,J) = C1(1,K,J)-C1(1,K,JC)
            CH(1,K,JC) = C1(1,K,J)+C1(1,K,JC)
  123    CONTINUE
  124 CONTINUE
      IF (IDO .EQ. 1) GO TO 132
      IF (NBD .LT. L1) GO TO 128
      DO 127 J=2,IPPH
         JC = IPP2-J
         DO 126 K=1,L1
            DO 125 I=3,IDO,2
               CH(I-1,K,J) = C1(I-1,K,J)-C1(I,K,JC)
               CH(I-1,K,JC) = C1(I-1,K,J)+C1(I,K,JC)
               CH(I,K,J) = C1(I,K,J)+C1(I-1,K,JC)
               CH(I,K,JC) = C1(I,K,J)-C1(I-1,K,JC)
  125       CONTINUE
  126    CONTINUE
  127 CONTINUE
      GO TO 132
  128 DO 131 J=2,IPPH
         JC = IPP2-J
         DO 130 I=3,IDO,2
            DO 129 K=1,L1
               CH(I-1,K,J) = C1(I-1,K,J)-C1(I,K,JC)
               CH(I-1,K,JC) = C1(I-1,K,J)+C1(I,K,JC)
               CH(I,K,J) = C1(I,K,J)+C1(I-1,K,JC)
               CH(I,K,JC) = C1(I,K,J)-C1(I-1,K,JC)
  129       CONTINUE
  130    CONTINUE
  131 CONTINUE
  132 CONTINUE
      IF (IDO .EQ. 1) RETURN
      DO 133 IK=1,IDL1
         C2(IK,1) = CH2(IK,1)
  133 CONTINUE
      DO 135 J=2,IP
         DO 134 K=1,L1
            C1(1,K,J) = CH(1,K,J)
  134    CONTINUE
  135 CONTINUE
      IF (NBD .GT. L1) GO TO 139
      IS = -IDO
      DO 138 J=2,IP
         IS = IS+IDO
         IDIJ = IS
         DO 137 I=3,IDO,2
            IDIJ = IDIJ+2
            DO 136 K=1,L1
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)
  136       CONTINUE
  137    CONTINUE
  138 CONTINUE
      GO TO 143
  139 IS = -IDO
      DO 142 J=2,IP
         IS = IS+IDO
         DO 141 K=1,L1
            IDIJ = IS
            DO 140 I=3,IDO,2
               IDIJ = IDIJ+2
               C1(I-1,K,J) = WA(IDIJ-1)*CH(I-1,K,J)-WA(IDIJ)*CH(I,K,J)
               C1(I,K,J) = WA(IDIJ-1)*CH(I,K,J)+WA(IDIJ)*CH(I-1,K,J)
  140       CONTINUE
  141    CONTINUE
  142 CONTINUE
  143 RETURN
      END
C     ******************************************************************
C
C     SUBROUTINE RFFTF(N,R,WSAVE)
C
C     ******************************************************************
C
C     SUBROUTINE RFFTF COMPUTES THE FOURIER COEFFICIENTS OF A REAL
C     PERODIC SEQUENCE (FOURIER ANALYSIS). THE TRANSFORM IS DEFINED
C     BELOW AT OUTPUT PARAMETER R.
C
C     INPUT PARAMETERS
C
C     N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD
C             IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.
C             N MAY CHANGE SO LONG AS DIFFERENT WORK ARRAYS ARE PROVIDED
C
C     R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE
C             TO BE TRANSFORMED
C
C     WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15.
C             IN THE PROGRAM THAT CALLS RFFTF. THE WSAVE ARRAY MUST BE
C             INITIALIZED BY CALLING SUBROUTINE RFFTI(N,WSAVE) AND A
C             DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT
C             VALUE OF N. THIS INITIALIZATION DOES NOT HAVE TO BE
C             REPEATED SO LONG AS N REMAINS UNCHANGED THUS SUBSEQUENT
C             TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.
C             THE SAME WSAVE ARRAY CAN BE USED BY RFFTF AND RFFTB.
C
C
C     OUTPUT PARAMETERS
C
C     R       R(1) = THE SUM FROM I=1 TO I=N OF R(I)
C
C             IF N IS EVEN SET L =N/2   , IF N IS ODD SET L = (N+1)/2
C
C               THEN FOR K = 2,...,L
C
C                  R(2*K-2) = THE SUM FROM I = 1 TO I = N OF
C
C                       R(I)*COS((K-1)*(I-1)*2*PI/N)
C
C                  R(2*K-1) = THE SUM FROM I = 1 TO I = N OF
C
C                      -R(I)*SIN((K-1)*(I-1)*2*PI/N)
C
C             IF N IS EVEN
C
C                  R(N) = THE SUM FROM I = 1 TO I = N OF
C
C                       (-1)**(I-1)*R(I)
C
C      *****  NOTE
C                  THIS TRANSFORM IS UNNORMALIZED SINCE A CALL OF RFFTF
C                  FOLLOWED BY A CALL OF RFFTB WILL MULTIPLY THE INPUT
C                  SEQUENCE BY N.
C
C     WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN
C             CALLS OF RFFTF OR RFFTB.
C
C
      SUBROUTINE RFFTF (N,R,WSAVE)
      DIMENSION       R(*)       ,WSAVE(*)
      IF (N .EQ. 1) RETURN
      CALL RFFTF1 (N,R,WSAVE,WSAVE(N+1),WSAVE(2*N+1))
      RETURN
      END
      SUBROUTINE RFFTF1 (N,C,CH,WA,IFAC)
      REAL C(*), CH(*), WA(*), IFAC(*)
      NF = IFAC(2)
      NA = 1
      L2 = N
      IW = N
      DO 111 K1=1,NF
         KH = NF-K1
         IP = IFAC(KH+3)
         L1 = L2/IP
         IDO = N/L2
         IDL1 = IDO*L1
         IW = IW-(IP-1)*IDO
         NA = 1-NA
         IF (IP .NE. 4) GO TO 102
         IX2 = IW+IDO
         IX3 = IX2+IDO
         IF (NA .NE. 0) GO TO 101
         CALL RADF4 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3))
         GO TO 110
  101    CALL RADF4 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3))
         GO TO 110
  102    IF (IP .NE. 2) GO TO 104
         IF (NA .NE. 0) GO TO 103
         CALL RADF2 (IDO,L1,C,CH,WA(IW))
         GO TO 110
  103    CALL RADF2 (IDO,L1,CH,C,WA(IW))
         GO TO 110
  104    IF (IP .NE. 3) GO TO 106
         IX2 = IW+IDO
         IF (NA .NE. 0) GO TO 105
         CALL RADF3 (IDO,L1,C,CH,WA(IW),WA(IX2))
         GO TO 110
  105    CALL RADF3 (IDO,L1,CH,C,WA(IW),WA(IX2))
         GO TO 110
  106    IF (IP .NE. 5) GO TO 108
         IX2 = IW+IDO
         IX3 = IX2+IDO
         IX4 = IX3+IDO
         IF (NA .NE. 0) GO TO 107
         CALL RADF5 (IDO,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))
         GO TO 110
  107    CALL RADF5 (IDO,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))
         GO TO 110
  108    IF (IDO .EQ. 1) NA = 1-NA
         IF (NA .NE. 0) GO TO 109
         CALL RADFG (IDO,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))
         NA = 1
         GO TO 110
  109    CALL RADFG (IDO,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))
         NA = 0
  110    L2 = L1
  111 CONTINUE
      IF (NA .EQ. 1) RETURN
      DO 112 I=1,N
         C(I) = CH(I)
  112 CONTINUE
      RETURN
      END
      SUBROUTINE RADF2 (IDO,L1,CC,CH,WA1)
      DIMENSION       CH(IDO,2,L1)           ,CC(IDO,L1,*)           ,
     1                WA1(*)
      DO 101 K=1,L1
         CH(1,1,K) = CC(1,K,1)+CC(1,K,2)
         CH(IDO,2,K) = CC(1,K,1)-CC(1,K,2)
  101 CONTINUE
      IF (IDO-2) 107,105,102
  102 IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 108
      DO 104 K=1,L1
         DO 103 I=3,IDO,2
            IC = IDP2-I
            TR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            TI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            CH(I,1,K) = CC(I,K,1)+TI2
            CH(IC,2,K) = TI2-CC(I,K,1)
            CH(I-1,1,K) = CC(I-1,K,1)+TR2
            CH(IC-1,2,K) = CC(I-1,K,1)-TR2
  103    CONTINUE
  104 CONTINUE
      GO TO 111
  108 DO 110 I=3,IDO,2
         IC = IDP2-I
         DO 109 K=1,L1
            TR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            TI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            CH(I,1,K) = CC(I,K,1)+TI2
            CH(IC,2,K) = TI2-CC(I,K,1)
            CH(I-1,1,K) = CC(I-1,K,1)+TR2
            CH(IC-1,2,K) = CC(I-1,K,1)-TR2
  109    CONTINUE
  110 CONTINUE
  111 IF (MOD(IDO,2) .EQ. 1) RETURN
  105 DO 106 K=1,L1
         CH(1,2,K) = -CC(IDO,K,2)
         CH(IDO,1,K) = CC(IDO,K,1)
  106 CONTINUE
  107 RETURN
      END
      SUBROUTINE RADF3 (IDO,L1,CC,CH,WA1,WA2)
      DIMENSION       CH(IDO,3,L1)           ,CC(IDO,L1,*)           ,
     1                WA1(*)     ,WA2(*)
      DATA TAUR,TAUI /-.5,.866025403784439/
      DO 101 K=1,L1
         CR2 = CC(1,K,2)+CC(1,K,3)
         CH(1,1,K) = CC(1,K,1)+CR2
         CH(1,3,K) = TAUI*(CC(1,K,3)-CC(1,K,2))
         CH(IDO,2,K) = CC(1,K,1)+TAUR*CR2
  101 CONTINUE
      IF (IDO .EQ. 1) RETURN
      IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 104
      DO 103 K=1,L1
         DO 102 I=3,IDO,2
            IC = IDP2-I
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)
            CR2 = DR2+DR3
            CI2 = DI2+DI3
            CH(I-1,1,K) = CC(I-1,K,1)+CR2
            CH(I,1,K) = CC(I,K,1)+CI2
            TR2 = CC(I-1,K,1)+TAUR*CR2
            TI2 = CC(I,K,1)+TAUR*CI2
            TR3 = TAUI*(DI2-DI3)
            TI3 = TAUI*(DR3-DR2)
            CH(I-1,3,K) = TR2+TR3
            CH(IC-1,2,K) = TR2-TR3
            CH(I,3,K) = TI2+TI3
            CH(IC,2,K) = TI3-TI2
  102    CONTINUE
  103 CONTINUE
      RETURN
  104 DO 106 I=3,IDO,2
         IC = IDP2-I
         DO 105 K=1,L1
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)
            CR2 = DR2+DR3
            CI2 = DI2+DI3
            CH(I-1,1,K) = CC(I-1,K,1)+CR2
            CH(I,1,K) = CC(I,K,1)+CI2
            TR2 = CC(I-1,K,1)+TAUR*CR2
            TI2 = CC(I,K,1)+TAUR*CI2
            TR3 = TAUI*(DI2-DI3)
            TI3 = TAUI*(DR3-DR2)
            CH(I-1,3,K) = TR2+TR3
            CH(IC-1,2,K) = TR2-TR3
            CH(I,3,K) = TI2+TI3
            CH(IC,2,K) = TI3-TI2
  105    CONTINUE
  106 CONTINUE
      RETURN
      END
      SUBROUTINE RADF4 (IDO,L1,CC,CH,WA1,WA2,WA3)
      DIMENSION       CC(IDO,L1,*)           ,CH(IDO,4,L1)           ,
     1                WA1(*)     ,WA2(*)     ,WA3(*)
      DATA HSQT2 /.7071067811865475/
      DO 101 K=1,L1
         TR1 = CC(1,K,2)+CC(1,K,4)
         TR2 = CC(1,K,1)+CC(1,K,3)
         CH(1,1,K) = TR1+TR2
         CH(IDO,4,K) = TR2-TR1
         CH(IDO,2,K) = CC(1,K,1)-CC(1,K,3)
         CH(1,3,K) = CC(1,K,4)-CC(1,K,2)
  101 CONTINUE
      IF (IDO-2) 107,105,102
  102 IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 111
      DO 104 K=1,L1
         DO 103 I=3,IDO,2
            IC = IDP2-I
            CR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            CI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            CR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)
            CI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)
            CR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)
            CI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)
            TR1 = CR2+CR4
            TR4 = CR4-CR2
            TI1 = CI2+CI4
            TI4 = CI2-CI4
            TI2 = CC(I,K,1)+CI3
            TI3 = CC(I,K,1)-CI3
            TR2 = CC(I-1,K,1)+CR3
            TR3 = CC(I-1,K,1)-CR3
            CH(I-1,1,K) = TR1+TR2
            CH(IC-1,4,K) = TR2-TR1
            CH(I,1,K) = TI1+TI2
            CH(IC,4,K) = TI1-TI2
            CH(I-1,3,K) = TI4+TR3
            CH(IC-1,2,K) = TR3-TI4
            CH(I,3,K) = TR4+TI3
            CH(IC,2,K) = TR4-TI3
  103    CONTINUE
  104 CONTINUE
      GO TO 110
  111 DO 109 I=3,IDO,2
         IC = IDP2-I
         DO 108 K=1,L1
            CR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            CI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            CR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)
            CI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)
            CR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)
            CI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)
            TR1 = CR2+CR4
            TR4 = CR4-CR2
            TI1 = CI2+CI4
            TI4 = CI2-CI4
            TI2 = CC(I,K,1)+CI3
            TI3 = CC(I,K,1)-CI3
            TR2 = CC(I-1,K,1)+CR3
            TR3 = CC(I-1,K,1)-CR3
            CH(I-1,1,K) = TR1+TR2
            CH(IC-1,4,K) = TR2-TR1
            CH(I,1,K) = TI1+TI2
            CH(IC,4,K) = TI1-TI2
            CH(I-1,3,K) = TI4+TR3
            CH(IC-1,2,K) = TR3-TI4
            CH(I,3,K) = TR4+TI3
            CH(IC,2,K) = TR4-TI3
  108    CONTINUE
  109 CONTINUE
  110 IF (MOD(IDO,2) .EQ. 1) RETURN
  105 DO 106 K=1,L1
         TI1 = -HSQT2*(CC(IDO,K,2)+CC(IDO,K,4))
         TR1 = HSQT2*(CC(IDO,K,2)-CC(IDO,K,4))
         CH(IDO,1,K) = TR1+CC(IDO,K,1)
         CH(IDO,3,K) = CC(IDO,K,1)-TR1
         CH(1,2,K) = TI1-CC(IDO,K,3)
         CH(1,4,K) = TI1+CC(IDO,K,3)
  106 CONTINUE
  107 RETURN
      END
      SUBROUTINE RADF5 (IDO,L1,CC,CH,WA1,WA2,WA3,WA4)
      DIMENSION       CC(IDO,L1,*)           ,CH(IDO,5,L1)           ,
     1                WA1(*)     ,WA2(*)     ,WA3(*)     ,WA4(*)
      DATA TR11,TI11,TR12,TI12 /.309016994374947,.951056516295154,
     1-.809016994374947,.587785252292473/
      DO 101 K=1,L1
         CR2 = CC(1,K,5)+CC(1,K,2)
         CI5 = CC(1,K,5)-CC(1,K,2)
         CR3 = CC(1,K,4)+CC(1,K,3)
         CI4 = CC(1,K,4)-CC(1,K,3)
         CH(1,1,K) = CC(1,K,1)+CR2+CR3
         CH(IDO,2,K) = CC(1,K,1)+TR11*CR2+TR12*CR3
         CH(1,3,K) = TI11*CI5+TI12*CI4
         CH(IDO,4,K) = CC(1,K,1)+TR12*CR2+TR11*CR3
         CH(1,5,K) = TI12*CI5-TI11*CI4
  101 CONTINUE
      IF (IDO .EQ. 1) RETURN
      IDP2 = IDO+2
      IF((IDO-1)/2.LT.L1) GO TO 104
      DO 103 K=1,L1
         DO 102 I=3,IDO,2
            IC = IDP2-I
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)
            DR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)
            DI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)
            DR5 = WA4(I-2)*CC(I-1,K,5)+WA4(I-1)*CC(I,K,5)
            DI5 = WA4(I-2)*CC(I,K,5)-WA4(I-1)*CC(I-1,K,5)
            CR2 = DR2+DR5
            CI5 = DR5-DR2
            CR5 = DI2-DI5
            CI2 = DI2+DI5
            CR3 = DR3+DR4
            CI4 = DR4-DR3
            CR4 = DI3-DI4
            CI3 = DI3+DI4
            CH(I-1,1,K) = CC(I-1,K,1)+CR2+CR3
            CH(I,1,K) = CC(I,K,1)+CI2+CI3
            TR2 = CC(I-1,K,1)+TR11*CR2+TR12*CR3
            TI2 = CC(I,K,1)+TR11*CI2+TR12*CI3
            TR3 = CC(I-1,K,1)+TR12*CR2+TR11*CR3
            TI3 = CC(I,K,1)+TR12*CI2+TR11*CI3
            TR5 = TI11*CR5+TI12*CR4
            TI5 = TI11*CI5+TI12*CI4
            TR4 = TI12*CR5-TI11*CR4
            TI4 = TI12*CI5-TI11*CI4
            CH(I-1,3,K) = TR2+TR5
            CH(IC-1,2,K) = TR2-TR5
            CH(I,3,K) = TI2+TI5
            CH(IC,2,K) = TI5-TI2
            CH(I-1,5,K) = TR3+TR4
            CH(IC-1,4,K) = TR3-TR4
            CH(I,5,K) = TI3+TI4
            CH(IC,4,K) = TI4-TI3
  102    CONTINUE
  103 CONTINUE
      RETURN
  104 DO 106 I=3,IDO,2
         IC = IDP2-I
         DO 105 K=1,L1
            DR2 = WA1(I-2)*CC(I-1,K,2)+WA1(I-1)*CC(I,K,2)
            DI2 = WA1(I-2)*CC(I,K,2)-WA1(I-1)*CC(I-1,K,2)
            DR3 = WA2(I-2)*CC(I-1,K,3)+WA2(I-1)*CC(I,K,3)
            DI3 = WA2(I-2)*CC(I,K,3)-WA2(I-1)*CC(I-1,K,3)
            DR4 = WA3(I-2)*CC(I-1,K,4)+WA3(I-1)*CC(I,K,4)
            DI4 = WA3(I-2)*CC(I,K,4)-WA3(I-1)*CC(I-1,K,4)
            DR5 = WA4(I-2)*CC(I-1,K,5)+WA4(I-1)*CC(I,K,5)
            DI5 = WA4(I-2)*CC(I,K,5)-WA4(I-1)*CC(I-1,K,5)
            CR2 = DR2+DR5
            CI5 = DR5-DR2
            CR5 = DI2-DI5
            CI2 = DI2+DI5
            CR3 = DR3+DR4
            CI4 = DR4-DR3
            CR4 = DI3-DI4
            CI3 = DI3+DI4
            CH(I-1,1,K) = CC(I-1,K,1)+CR2+CR3
            CH(I,1,K) = CC(I,K,1)+CI2+CI3
            TR2 = CC(I-1,K,1)+TR11*CR2+TR12*CR3
            TI2 = CC(I,K,1)+TR11*CI2+TR12*CI3
            TR3 = CC(I-1,K,1)+TR12*CR2+TR11*CR3
            TI3 = CC(I,K,1)+TR12*CI2+TR11*CI3
            TR5 = TI11*CR5+TI12*CR4
            TI5 = TI11*CI5+TI12*CI4
            TR4 = TI12*CR5-TI11*CR4
            TI4 = TI12*CI5-TI11*CI4
            CH(I-1,3,K) = TR2+TR5
            CH(IC-1,2,K) = TR2-TR5
            CH(I,3,K) = TI2+TI5
            CH(IC,2,K) = TI5-TI2
            CH(I-1,5,K) = TR3+TR4
            CH(IC-1,4,K) = TR3-TR4
            CH(I,5,K) = TI3+TI4
            CH(IC,4,K) = TI4-TI3
  105    CONTINUE
  106 CONTINUE
      RETURN
      END
      SUBROUTINE RADFG (IDO,IP,L1,IDL1,CC,C1,C2,CH,CH2,WA)
      DIMENSION       CH(IDO,L1,IP)          ,CC(IDO,IP,L1)          ,
     1                C1(IDO,L1,IP)          ,C2(IDL1,IP),
     2                CH2(IDL1,IP)           ,WA(*)
      DATA TPI/6.28318530717959/
      ARG = TPI/FLOAT(IP)
      DCP = COS(ARG)
      DSP = SIN(ARG)
      IPPH = (IP+1)/2
      IPP2 = IP+2
      IDP2 = IDO+2
      NBD = (IDO-1)/2
      IF (IDO .EQ. 1) GO TO 119
      DO 101 IK=1,IDL1
         CH2(IK,1) = C2(IK,1)
  101 CONTINUE
      DO 103 J=2,IP
         DO 102 K=1,L1
            CH(1,K,J) = C1(1,K,J)
  102    CONTINUE
  103 CONTINUE
      IF (NBD .GT. L1) GO TO 107
      IS = -IDO
      DO 106 J=2,IP
         IS = IS+IDO
         IDIJ = IS
         DO 105 I=3,IDO,2
            IDIJ = IDIJ+2
            DO 104 K=1,L1
               CH(I-1,K,J) = WA(IDIJ-1)*C1(I-1,K,J)+WA(IDIJ)*C1(I,K,J)
               CH(I,K,J) = WA(IDIJ-1)*C1(I,K,J)-WA(IDIJ)*C1(I-1,K,J)
  104       CONTINUE
  105    CONTINUE
  106 CONTINUE
      GO TO 111
  107 IS = -IDO
      DO 110 J=2,IP
         IS = IS+IDO
         DO 109 K=1,L1
            IDIJ = IS
            DO 108 I=3,IDO,2
               IDIJ = IDIJ+2
               CH(I-1,K,J) = WA(IDIJ-1)*C1(I-1,K,J)+WA(IDIJ)*C1(I,K,J)
               CH(I,K,J) = WA(IDIJ-1)*C1(I,K,J)-WA(IDIJ)*C1(I-1,K,J)
  108       CONTINUE
  109    CONTINUE
  110 CONTINUE
  111 IF (NBD .LT. L1) GO TO 115
      DO 114 J=2,IPPH
         JC = IPP2-J
         DO 113 K=1,L1
            DO 112 I=3,IDO,2
               C1(I-1,K,J) = CH(I-1,K,J)+CH(I-1,K,JC)
               C1(I-1,K,JC) = CH(I,K,J)-CH(I,K,JC)
               C1(I,K,J) = CH(I,K,J)+CH(I,K,JC)
               C1(I,K,JC) = CH(I-1,K,JC)-CH(I-1,K,J)
  112       CONTINUE
  113    CONTINUE
  114 CONTINUE
      GO TO 121
  115 DO 118 J=2,IPPH
         JC = IPP2-J
         DO 117 I=3,IDO,2
            DO 116 K=1,L1
               C1(I-1,K,J) = CH(I-1,K,J)+CH(I-1,K,JC)
               C1(I-1,K,JC) = CH(I,K,J)-CH(I,K,JC)
               C1(I,K,J) = CH(I,K,J)+CH(I,K,JC)
               C1(I,K,JC) = CH(I-1,K,JC)-CH(I-1,K,J)
  116       CONTINUE
  117    CONTINUE
  118 CONTINUE
      GO TO 121
  119 DO 120 IK=1,IDL1
         C2(IK,1) = CH2(IK,1)
  120 CONTINUE
  121 DO 123 J=2,IPPH
         JC = IPP2-J
         DO 122 K=1,L1
            C1(1,K,J) = CH(1,K,J)+CH(1,K,JC)
            C1(1,K,JC) = CH(1,K,JC)-CH(1,K,J)
  122    CONTINUE
  123 CONTINUE
C
      AR1 = 1.
      AI1 = 0.
      DO 127 L=2,IPPH
         LC = IPP2-L
         AR1H = DCP*AR1-DSP*AI1
         AI1 = DCP*AI1+DSP*AR1
         AR1 = AR1H
         DO 124 IK=1,IDL1
            CH2(IK,L) = C2(IK,1)+AR1*C2(IK,2)
            CH2(IK,LC) = AI1*C2(IK,IP)
  124    CONTINUE
         DC2 = AR1
         DS2 = AI1
         AR2 = AR1
         AI2 = AI1
         DO 126 J=3,IPPH
            JC = IPP2-J
            AR2H = DC2*AR2-DS2*AI2
            AI2 = DC2*AI2+DS2*AR2
            AR2 = AR2H
            DO 125 IK=1,IDL1
               CH2(IK,L) = CH2(IK,L)+AR2*C2(IK,J)
               CH2(IK,LC) = CH2(IK,LC)+AI2*C2(IK,JC)
  125       CONTINUE
  126    CONTINUE
  127 CONTINUE
      DO 129 J=2,IPPH
         DO 128 IK=1,IDL1
            CH2(IK,1) = CH2(IK,1)+C2(IK,J)
  128    CONTINUE
  129 CONTINUE
C
      IF (IDO .LT. L1) GO TO 132
      DO 131 K=1,L1
         DO 130 I=1,IDO
            CC(I,1,K) = CH(I,K,1)
  130    CONTINUE
  131 CONTINUE
      GO TO 135
  132 DO 134 I=1,IDO
         DO 133 K=1,L1
            CC(I,1,K) = CH(I,K,1)
  133    CONTINUE
  134 CONTINUE
  135 DO 137 J=2,IPPH
         JC = IPP2-J
         J2 = J+J
         DO 136 K=1,L1
            CC(IDO,J2-2,K) = CH(1,K,J)
            CC(1,J2-1,K) = CH(1,K,JC)
  136    CONTINUE
  137 CONTINUE
      IF (IDO .EQ. 1) RETURN
      IF (NBD .LT. L1) GO TO 141
      DO 140 J=2,IPPH
         JC = IPP2-J
         J2 = J+J
         DO 139 K=1,L1
            DO 138 I=3,IDO,2
               IC = IDP2-I
               CC(I-1,J2-1,K) = CH(I-1,K,J)+CH(I-1,K,JC)
               CC(IC-1,J2-2,K) = CH(I-1,K,J)-CH(I-1,K,JC)
               CC(I,J2-1,K) = CH(I,K,J)+CH(I,K,JC)
               CC(IC,J2-2,K) = CH(I,K,JC)-CH(I,K,J)
  138       CONTINUE
  139    CONTINUE
  140 CONTINUE
      RETURN
  141 DO 144 J=2,IPPH
         JC = IPP2-J
         J2 = J+J
         DO 143 I=3,IDO,2
            IC = IDP2-I
            DO 142 K=1,L1
               CC(I-1,J2-1,K) = CH(I-1,K,J)+CH(I-1,K,JC)
               CC(IC-1,J2-2,K) = CH(I-1,K,J)-CH(I-1,K,JC)
               CC(I,J2-1,K) = CH(I,K,J)+CH(I,K,JC)
               CC(IC,J2-2,K) = CH(I,K,JC)-CH(I,K,J)
  142       CONTINUE
  143    CONTINUE
  144 CONTINUE
      RETURN
      END
      SUBROUTINE CHEBY (A, B, F, G, PHI, EPS, ITNO, MXITER, L, M,
     X                    P, Q, ERROR, IERR, W)
C     ******************************************************************
C     RATIONAL CHEBYCHEV APPROXIMATION OF CONTINUOUS FUNCTIONS
C     ******************************************************************
      DOUBLE PRECISION A, B, F, G, PHI, EPS, ERROR
      DOUBLE PRECISION P(*), Q(*), W(*)
      EXTERNAL F, G, PHI
C     -------------------
      IF (L .LT. 0 .OR. M .LT. 0) GO TO 10
      LP1 = L + 1
      MP1 = M + 1
      LPM = L + M
      N = LPM + 1
      NP1 = N + 1
C     -------------------
      I1 = NP1 + 1
      I2 = I1 + NP1
      I3 = I2 + NP1*NP1
      I4 = I3 + NP1
      I5 = I4 + NP1
      CALL CHEBY1 (A, B, F, G, PHI, EPS, ITNO, MXITER, L, M, P, Q,
     1              ERROR, IERR, LP1, MP1, LPM, N, NP1, W(1),
     2              W(I1), W(I2), W(I3), W(I4), W(I5))
      RETURN
C     ------------------------------------------------------------------
C     ERROR RETURN
C     ------------------------------------------------------------------
   10 IERR = 1
      RETURN
      END
      SUBROUTINE CHEBY1 (A, B, F, G, PHI, EPS, ITNO, MXITER, L, M,
     1                   P, Q, ERROR, IERR, LP1, MP1, LPM, N, NP1,
     2                   X, XVAL, C, D, ERR, H)
C     ------------------------------------------------------------------
      DOUBLE PRECISION A, B, F, G, PHI, EPS, ERROR
      DOUBLE PRECISION P(LP1), Q(MP1), X(NP1), XVAL(NP1), C(NP1,NP1),
     1          D(NP1), ERR(NP1), H(NP1)
      DOUBLE PRECISION B1, C0, DEL, DN, DNP1, EPS0, HALF, H1,
     1          OLDERR, ONE, PI, SIGN, SUM, TAU, TEMPL, TEN, TEST,
     2          U, XI, XLB, XM1, Y, Y2, Y3, Z, ZERO, ZZ, Z1, Z2, Z3
      EXTERNAL F, G, PHI
C     -------------------
      DATA PI/3.14159265358979323846264338328D0/
      DATA ZERO/0.D0/, HALF/.5D0/, ONE/1.D0/, TEN/10.D0/
      DATA EPS0/1.D-2/, TAU/.015D0/, C0/.0625D0/
C     -------------------
      ERROR = ZERO
      IF (EPS .LE. ZERO .OR. EPS .GE. EPS0) GO TO 200
      IERR = 0
C
      ITNO = 1
      XLB = ZERO
      DN = N
      DNP1 = NP1
C
      DO 10 I = 1,LP1
   10 P(I) = ZERO
      DO 11 I = 1,MP1
   11 Q(I) = ZERO
      Q(1) = ONE
C
C     COMPUTE INITIAL APPROXIMATIONS OF THE CRITICAL POINTS
C
      X(1) = A
      X(NP1) = B
      K = N/2
      IF (K .LE. 0) GO TO 30
      B1 = HALF*(B - A)
      XM1 = HALF*(A + B)
      DO 20 I = 1,K
      XI = I
      Z = -B1*DCOS(PI*(XI/DN))
      X(I+1) = Z + XM1
      II = NP1 - I
   20 X(II) = XM1 - Z
C
C     EVALUATE PHI AT THE CRITICAL POINTS
C
   30 DO 31 I = 1,NP1
   31 XVAL(I) = PHI(X(I))
      KOUNT = 1
C
C     SET UP THE LINEAR EQUATIONS
C
   40 K = L + 2
      SIGN = ONE
      DO 45 I = 1,NP1
      SIGN = -SIGN
      C(I,1) = ONE
      IF (L .LE. 0) GO TO 42
      DO 41 J = 2,LP1
   41 C(I,J) = C(I,J-1)*XVAL(I)
   42 D(I) = F(X(I))
      IF (M .LE. 0) GO TO 44
      TEMPL = SIGN*XLB*G(X(I)) - D(I)
      C(I,K) = XVAL(I)*TEMPL
      IF (K .GT. LPM) GO TO 44
      DO 43 J = K,LPM
   43 C(I,J+1) = C(I,J)*XVAL(I)
   44 C(I,NP1) = SIGN*G(X(I))
   45 CONTINUE
C
C     SOLVE THE EQUATIONS CX = D AND STORE THE RESULTS IN D
C
      CALL DPSLV (NP1, 1, C, NP1, D, NP1, IERR)
      IF (IERR .NE. 0) GO TO 220
      IF (KOUNT .GT. 1) GO TO 50
C
C     REDEFINE THE EQUATIONS AND SOLVE
C
      XLB = (D(NP1) + XLB*DN)/DNP1
      IF (M .LE. 0) GO TO 61
      KOUNT = 2
      GO TO 40
C
   50 TEST = DABS(XLB - D(NP1))
      XLB = (D(NP1) + XLB*DN)/DNP1
      KOUNT = KOUNT + 1
      IF (KOUNT .LE. 4 .AND. TEST .GT. EPS0*DABS(XLB)) GO TO 40
C
C     STORE THE RESULTS IN P AND Q
C
      DO 60 I = 2,MP1
      LPI = L + I
   60 Q(I) = D(LPI)
   61 DO 62 I = 1,LP1
   62 P(I) = D(I)
C
C     SEARCH FOR NEW CRITICAL POINTS
C
      OLDERR = ERROR
      ERROR = ZERO
      Z1 = ZERO
      U = ONE
      IF (XLB .LT. ZERO) U = -U
C
      IF (N .GT. 1) GO TO 70
      H(1) = TAU*(X(2) - X(1))
      H(2) = -H(1)
      GO TO 72
   70 DO 71 I = 2,N
   71 H(I) = TAU*(X(I+1) - X(I-1))
      H(1) = HALF*H(2)
      H(NP1) = -HALF*H(N)
   72 CONTINUE
C
      DO 92 I = 1,NP1
      Y2 = X(I)
      H1 = H(I)
      Y3 = Y2 + H1
      CALL CERR(Y2, F(Y2), G(Y2), PHI(Y2), DEL, IERR, L, LP1, M, NP1, D)
      IF (IERR .NE. 0) RETURN
      Z2 = U*DEL
      CALL CERR(Y3, F(Y3), G(Y3), PHI(Y3), DEL, IERR, L, LP1, M, NP1, D)
      IF (IERR .NE. 0) RETURN
      Z3 = U*DEL
      IF (Z2 .LT. Z3) GO TO 80
      H1 = -H1
      Z = Z3
      Z3 = Z2
      Z2 = Z
      Y = Y3
      Y3 = Y2
      Y2 = Y
C
   80 Y = Y3 + H1
      IF (Y .GE. A) GO TO 81
      Y = A
      GO TO 90
   81 IF (Y .LE. B) GO TO 82
      Y = B
      GO TO 90
   82 CALL CERR(Y, F(Y), G(Y), PHI(Y), DEL, IERR, L, LP1, M, NP1, D)
      IF (IERR .NE. 0) RETURN
      Z = U*DEL
      IF (Z .LE. Z3) GO TO 83
      Y2 = Y3
      Y3 = Y
      Z2 = Z3
      Z3 = Z
      GO TO 80
   83 Y = (Z - Z3) + (Z2 - Z3)
      IF (Y .NE. ZERO) GO TO 84
      Y = Y3
      GO TO 90
   84 Y = HALF*(Y2 + Y3) + H1*(Z2 - Z3)/Y
C
   90 X(I) = Y
      CALL CERR(Y, F(Y), G(Y), PHI(Y), DEL, IERR, L, LP1, M, NP1, D)
      IF (IERR .NE. 0) RETURN
      ERR(I) = DEL
      U = -U
      IF (I .EQ. 1) GO TO 91
      IF (X(I) .LE. X(I-1)) GO TO 230
   91 Z = DABS(ERR(I))
      ERROR = DMAX1(ERROR, Z)
      IF (Z .GE. TEN) GO TO 240
      Y = DABS(XLB)
      ZZ = ONE
      IF (Y .NE. ZERO) ZZ = DABS(Z - Y)/Y
      IF (Z1 .LT. ZZ) Z1 = ZZ
   92 CONTINUE
C
C     SEARCH FOR AN EXTRA EXTREMAL POINT BETWEEN THE ENDPOINTS
C     OF THE INTERVAL AND THE CRITICAL POINTS
C
      IF (X(1) .LE. A) GO TO 110
      H1 = C0*(X(1) - A)
      U = ONE
      IF (XLB .GE. ZERO) U = -U
      Z3 = ZERO
      Y = A
      DO 100 I = 1,16
      CALL CERR(Y, F(Y), G(Y), PHI(Y), DEL, IERR, L, LP1, M, NP1, D)
      IF (IERR .NE. 0) RETURN
      Z = U*DEL
      IF (Z .LE. Z3) GO TO 100
      Z3 = Z
      Z2 = Y
  100 Y = Y + H1
      ERROR = DMAX1(ERROR, Z3)
      Z = DABS(XLB)
      IF (Z3 .LE. Z) GO TO 110
      I = NP1
      DO 101 II = 2,NP1
      ERR(I) = ERR(I-1)
      X(I) = X(I-1)
  101 I = I - 1
      X(1) = Z2
      ERR(1) = U*Z3
      GO TO 113
C
  110 IF (X(NP1) .GE. B) GO TO 120
      H1 = C0*(B - X(NP1))
      U = ONE
      IF (ERR(NP1) .GE. ZERO) U = -U
      Z3 = ZERO
      Y = B
      DO 111 I = 1,16
      CALL CERR(Y, F(Y), G(Y), PHI(Y), DEL, IERR, L, LP1, M, NP1, D)
      IF (IERR .NE. 0) RETURN
      Z = U*DEL
      IF (Z .LE. Z3) GO TO 111
      Z3 = Z
      Z2 = Y
  111 Y = Y - H1
      ERROR = DMAX1(ERROR, Z3)
      Z = DABS(XLB)
      IF (Z3 .LE. Z) GO TO 120
      DO 112 I = 1,N
      ERR(I) = ERR(I+1)
  112 X(I) = X(I+1)
      X(NP1) = Z2
      ERR(NP1) = U*Z3
  113 XLB = -XLB
      ZZ = ONE
      IF (Z .NE. ZERO) ZZ = DABS(Z3 - Z)/Z
      IF (Z1 .LT. ZZ) Z1 = ZZ
C
C     CHECK FOR CONVERGENCE
C
  120 IF (Z1 .LE. EPS) RETURN
C
C     SET UP FOR THE NEXT ITERATION
C
      IF (ITNO .GE. MXITER) GO TO 210
      SUM = ZERO
      SIGN = ONE
      DO 130 I = 1,NP1
      SUM = SUM + SIGN*ERR(I)
  130 SIGN = -SIGN
      XLB = SUM/DNP1
      ITNO = ITNO + 1
      GO TO 30
C     ------------------------------------------------------------------
C     ERROR RETURN
C     ------------------------------------------------------------------
C     INPUT ERROR
C
  200 IERR = 1
      RETURN
C
C     MXITER ITERATIONS WERE PERFORMED - MORE ITERATIONS ARE NEEDED
C
  210 IERR = 2
      RETURN
C
C     THE LINEAR EQUATIONS CANNOT BE SOLVED
C
  220 IF (ITNO .EQ. 1) GO TO 250
      IERR = 3
      RETURN
C
C     THE SEQUENCE OF CRITICAL POINTS IS NOT MONOTONICALLY INCREASING
C
  230 IERR = 4
      IF (I .LE. N) ERROR = OLDERR
      RETURN
C
C     IT APPEARS THAT THE ALGORITHM HAS FAILED TO CONVERGE
C     THERE MAY BE POLES IN THE RATIONAL APPROXIMATION
C
  240 IERR = 5
      RETURN
C
C     THE ROUTINE HAS COMPLETELY FAILED - THE RESULTS SHOULD BE IGNORED
C
  250 IERR = 6
      RETURN
      END
      SUBROUTINE CERR (T, FT, GT, PHIT, DEL, IERR, L, LP1, M, NP1, D)
C     ------------------------------------------------------------------
C     COMPUTE THE APPROXIMATION ERROR AT POINT T
C     ------------------------------------------------------------------
      DOUBLE PRECISION T, FT, GT, PHIT, DEL, D(NP1)
      DOUBLE PRECISION P, Q, R, ZERO, ONE
      DATA ZERO/0.D0/, ONE/1.D0/
C     -------------------
      P = D(LP1)
      IF (L .LE. 0) GO TO 20
      DO 10 I = 1,L
      II = LP1 - I
   10 P = P*PHIT + D(II)
C
   20 Q = ZERO
      IF (M .LE. 0) GO TO 22
      DO 21 I = 1,M
      II = NP1 - I
   21 Q = (Q + D(II))*PHIT
   22 Q = Q + ONE
C
      IF (Q .EQ. ZERO) GO TO 110
      IF (GT .EQ. ZERO) GO TO 100
      R = P/Q
      DEL = (R - FT)/GT
      RETURN
C     ------------------------------------------------------------------
C     ERROR RETURN
C     ------------------------------------------------------------------
C     THE FUNCTION G IS ZERO AT POINT T
C
  100 IERR = 1
      RETURN
C
C     THE ROUTINE HAS COMPLETELY FAILED - THE RESULTS SHOULD BE IGNORED
C
  110 IERR = 6
      RETURN
      END
      SUBROUTINE ADAPT (F, XLFT, XRGT, EPSLN, NPIECE, ERREST, XKNOTS,
     * COEFS, IERR, KMAX, NDEG, NSMTH, ANORM, DX, MO, KBREAK, BRAKPT,
     * KDIFF, VALLFT, VALRGT)
C
C        ===============================================================
C
C     TABULATION OF THE INTERNAL AND EXTERNAL NAMES OF THE ARGUMENTS.
C
C
C    INTERNAL   EXTERNAL
C     F          F
C     A          XLFT
C     B          XRGT
C     ACCUR      EPSLN
C     KNOTS      NPIECE
C     ERROR      ERREST
C     XKNOTS     XKNOTS
C     COEFS      COEFS
C     IERR       IERR
C     KMAX       KMAX
C     DEGREE     NDEG
C     SMOOTH     NSMTH
C     NORM       ANORM
C     CHARF      DX
C     EDIST      MO
C     NBREAK     KBREAK
C     XBREAK     BRAKPT
C     DBREAK     KDIFF
C     BLEFT      VALLFT
C     BRIGHT     VALRGT
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION XKNOTS(*), COEFS(KMAX,*)
      DOUBLE PRECISION ANORM, BRAKPT, DX, EPSLN, ERREST, VALLFT,
     * VALRGT, XLFT, XRGT
      DIMENSION BRAKPT(KBREAK), KDIFF(KBREAK), VALLFT(KBREAK),
     * VALRGT(KBREAK)
      DOUBLE PRECISION F
      EXTERNAL F
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
C
   10 A = XLFT
      B = XRGT
      ACCUR = EPSLN
      DEGREE = NDEG
      SMOOTH = NSMTH
      NORM = ANORM
      CHARF = DX
      EDIST = MO
      NBREAK = KBREAK
      IF (NBREAK.LE.0 .OR. NBREAK.GE.21) GO TO 30
      DO 20 K=1,NBREAK
        XBREAK(K) = BRAKPT(K)
        DBREAK(K) = KDIFF(K)
        BLEFT(K) = VALLFT(K)
        BRIGHT(K) = VALRGT(K)
   20 CONTINUE
   30 CONTINUE
C
      KDIMEN = KMAX+1
      NDIMEN = NDEG+1
      CALL ADAPT1(F, XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR)
      NPIECE = KNOTS
      ERREST = ERROR
      RETURN
      END
      SUBROUTINE ADAPT1(F, XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR)
C
C     THIS ALGORITHM COMPUTES A PIECEWISE POLYNOMIAL APPROXIMATION
C  OF SPECIFIED SMOOTHNESS, ACCURACY AND DEGREE.  THE INPUT TO THE
C  COMPUTATION IS
C
C   F      - FUNCTION BEING APPROXIMATED. IT MUST PROVIDE VALUES OF
C            DERIVATIVES UP TO THE ORDER OF SMOOTHNESS SPECIFIED FOR
C            THE APPROXIMATION.  THE CALLING SEQUENCE IS F(X,FDERV) AND
C            FDERV CONTAINS THE DERIVATIVES( SEE CONSTRAINT BELOW)
C   A,B    - THE ENDPOINTS OF THE INTERVAL OF APPROXIMATION
C   ACCUR  - THE ACCURACY REQUIRED FOR THE APPROXIMATION
C   SMOOTH - THE SMOOTHNESS REQUIRED FOR THE APPROXIMATION
C              = 0  MEANS CONTINUOUS
C              = 1  MEANS CONTINUOUS SLOPE
C              = 2  MEANS CONTINUOUS SECOND DERIVATIVE, ETC.
C   DEGREE - THE DEGREE OF THE POLYNOMIAL PIECES.
C            MUST HAVE DEGREE GT 2*SMOOTH
C   CHARF  - CHARACTERISTIC LENGTH OF THE FUNCTION F(X). PIECES ARE NOT
C            LONGER THAN THIS LENGTH.
C   NORM   - NORM TO MEASURE THE APPROXIMATION ERROR
C              = 1  L1 APPROXIMATION (LEAST DEVIATIONS)
C              = 2  L2 APPROXIMATION (LEAST SQUARES)
C              = 3  TCHEBYCHEFF (MINIMAX) APPROXIMATION
C              =-P  (NEGATIVE VALUE) GENERAL LP APPROXIMATION
C   NBREAK - NUMBER OF SPECIAL BREAK POINTS IN THE APPROXIMATION.
C            ASSOCIATED INPUT VARIABLES ARE
C              XBREAK(J)  - LOCATION OF BREAK POINTS
C              DBREAK(J)  - DERIVATIVE BROKEN AT XBREAK
C              BLEFT (J)  - VALUE FROM LEFT FOR DBREAK DERIVATIVE
C              BRIGHT(J)  -   -    -   RIGHT -    -        -
C   EDIST  - SWITCH TO CHANGE FROM PROPORTIONAL ERROR DISTRIBUTION
C            TO FIXED DISTRIBUTION. THIS IS PRIMARILY OF USE IN
C            APPROXIMATION OF FUNCTIONS WITH SINGULARITIES. ONE SHOULD
C            USE NORM = 1. OR SO IN SUCH CASES
C              = 0  PROPORTIONAL DISTRIBUTION
C              = 1  APPROXIMATE FIXED ERROR DISTRIBUTION
C                   ATTEMPTS TO ACHIEVE SPECIFIED ACCURACY VALUE ACCUR
C              = 2  TRUE FIXED ERROR DISTRIBUTION
C
C  ********** OUTPUT **********
C     THE OUTPUT OF THE COMPUTATION CONSISTS OF 4 PARTS, EACH RETURNED
C     TO THE USER IN A DIFFERENT WAY. THEY ARE
C
C   XKNOTS,COEFS - ARRAYS DEFINING THE PIECEWISE POLYNOMIAL RESULT.
C            XKNOTS(K)  = KNOTS OF THE APPROXIMATION ( K = 1 TO KNOTS)
C                         THE LAST ONE IS RIGHT END POINT OF INTERVAL
C            COEFS(K,N) = COEFFICIENT OF (X - XKNOT(K))**(N-1) IN THE
C                         INTERVAL XKNOT(K) TO XKNOT(K+1)
C                           K = 1 TO KNOTS-1  AND  N = 1 TO DEGREE+1
C            THESE ARRAYS ARE PASSED AS ARGUMENTS SO AS TO USE VARIABLE
C            DIMENSIONS. THE ARRAYS ARE OF DIMENSION XKNOTS(KDIMEN) AND
C            COEFS(KMAX,NDIMEN). IT IS ASSUMED THAT KDIMEN = KMAX+1.
C               ***** NOTE ***** SEVERAL SMALL ARRAYS HERE HAVE FIXED
C                        DIMENSIONS THAT LIMIT DEGREE AND THUS NDIMEN
C                        SHOULD NOT EXCEED THIS LIMIT (CURRENTLY = 20)
C
C   RESULZ - A LABELED COMMON BLOCK CONTAINING KNOTS AND ERROR
C              KNOTS - NUMBER OF KNOTS OF THE APPROXIMATION
C              ERROR - ESTIMATED ACCURACY OF THE APPROXIMATION
C
C   IERR - STATUS INDICATOR. IERR TAKES THE VALUES
C      0   THE APPROXIMATION WAS SUCCESSFULLY CONSTRUCTED.
C     -1   INPUT ERROR REPORTED BY ADSET.
C     -2   A AND B ARE TOO CLOSE.
C     -3   CHARF IS TOO SMALL.
C     -4   EITHER ALL THE BREAK POINTS ARE NOT BETWEEN A AND B, OR
C          XBREAK(I).GE.XBREAK(I+1) FOR SOME I.
C     -5   DBREAK(I).LT.0 .OR. DBREAK(I).GT.(DEGREE-1)/2 FOR SOME I.
C      1   THE KNOT LIMIT WAS EXCEEDED.
C      2   BREAK POINT ADJUSTMENT REQUIRES THAT A SUBINTERVAL BE
C          PARTITIONED. HOWEVER, THIS CANNOT BE DONE EITHER BECAUSE
C          THE INTERVAL STACK IS FULL, OR PARTITIONING WILL PRODUCE
C          TOO SMALL AN INTERVAL.
C      3   A SUBINTERVAL MUST BE PARTITIONED BECAUSE ITS LENGTH IS
C          GREATER THAN CHARF. HOWEVER, THIS CANNOT BE DONE SINCE THE
C          INTERVAL STACK IS FULL.
C      4   A SUBINTERVAL MUST BE PARTITIONED SO THAT THE ACCURACY
C          CRITERIA CAN BE SATISFIED. HOWEVER, THIS CANNOT BE DONE
C          EITHER BECAUSE THE INTERVAL STACK IS FULL, OR PARTITIONING
C          WILL PRODUCE TOO SMALL AN INTERVAL.
C
C  ********** DIMENSION CONSTRAINTS **********
C     MAXKNT - MAX NUMBER OF KNOTS TAKEN FROM USER VIA KDIMEN
C              ARRAYS WITH THIS DIMENSION (OR RELATED VALUES)
C                   COEFS   XKNOTS
C     MAXPAR - MAX NUMBER OF PARAMETERS PER INTERVAL (CURRENTLY = 20)
C                   USER PROVIDED NDIMEN MUST HAVE NDIMEN LE MAXPAR
C                   MUST HAVE  DEGREE + 1 LE MAXPAR
C              ARRAYS WITH THIS DIMENSION (OR RELATED VALUES)
C                D       DDTEMP  FDERVL  FDERVR  FDUMB   FACTOR
C                FINTRP  FLEFT   FRIGHT  POWERS  XTEMP   XINTRP  XDD
C              ***** NOTE ***** MAXPAR ALSO AFFECTS ARGUMENT FDERV
C              OF FUNCTION F.  FDERVL, FDERVR ARE ALSO INVOLVED.
C              SHOULD DECLARE FDERV OF SIZE 10 IN F TO BE SAFE.
C     MAXAUX - MAXIMUM NUMBER OF AUXILIARY INPUT ( = 20 NOW ). ARRAYS
C                 XBREAK  DBREAK  BLEFT   BRIGHT
C     MAXSTK - MAX SIZE OF ACTIVE INTERVAL STACK
C              MIN INTERVAL LENGTH IS 2**(-MAXSTK)*(B-A). ARRAYS
C                 XLEFT   XRIGHT
C
C  **********  PORTABILITY CONSIDERATIONS  **********
C
C     ALL THE ROUTINES IN THIS PACKAGE (EXCEPT ADAPT) ARE WRITTEN IN
C     ANSI STANDARD FORTRAN. IN ADDITION, THEY MEET ALL THE REQUIREMENTS
C     OF THE BELL LABS PORTABLE FORTRAN -PFORT-.  NEVERTHELESS, THE
C     ROUTINES ARE AFFECTED BY A CHANGE IN MACHINE WORD LENGTH AND
C     CHANGING TO SINGLE PRECISION.
C
C     ***** THE GAUSS WEIGHTS AND ABSCISSAE IN ADCOMP ARE GIVEN TO
C           30 DIGITS. THE PARAMETER EPS0 IN ADSET SPECIFIES THE
C           ACCURACY OF THESE CONSTANTS. IF THE ACCURACY IS CHANGED
C           TO K DECIMAL DIGITS THEN SET EPS0 = 10**(-K).
C
C     ***** THE INTERVAL STACK SIZE MAXSTK IS DEFINED IN ADSET TO
C           BE 50. IF MAXSTK IS MODIFIED THEN SET THE DIMENSIONS OF
C           XLEFT AND XRIGHT TO THE NEW VALUE FOR MAXSTK. NOTE THAT
C           THE MINIMUM INTERVAL LENGTH IS 2**(-MAXSTK)*(B-A).
C
C  SINGLE PRECISION CONVERSION -- REQUIRES FOUR STEPS
C     1. DECLARE ALL DOUBLE PRECISION VARIABLES TO BE REAL.
C
C     2. CHANGE ALL DOUBLE PRECISION NUMBERS IN THE DATA STATEMENTS.
C        (FLOATING POINT NUMBERS APPEAR ONLY IN DATA STATEMENTS.)
C
C     3. CHANGE DABS,DMAX1,DMIN1 AT MANY PLACES.
C
C     4. CHANGE DPMPAR TO SPMPAR IN ADSET.
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION XKNOTS(KDIMEN), COEFS(KMAX,NDIMEN)
      DOUBLE PRECISION F
      EXTERNAL F
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
C                      KNTDIM - KDIMEN, NAME CHANGED TO PUT IN COMMON
C                      NPARDM - NDIMEN, NAME CHANGED TO PUT IN COMMON
      COMMON /RESULZ/ ERROR, KNOTS
C                      KNOTS = FINAL NO. OF KNOTS, INCLUDES B AS ONE.
C                      ERROR = ESTIMATE OF ERROR ACTUALLY ACHIEVED.
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
C             KONTRL CONTAINS GENERALLY USEFUL VARIABLES
C                      MAXSTK - SEE COMMENTS ABOVE
C                      BUFFER - THE MACHINE DEPENDENT TOLERANCE USED
C                               BY THE ALGORITHM
C                      NSTACK - COUNTER FOR INTERVAL STACK, CONSISTS OF
C                               (XLEFT(J),XRIGHT(J))  J = 1 TO NSTACK
C                      ERRORI - ERROR ESTIMATE FOR TOP INTERVAL
C                      DSCTOL - TOLERANCE TO CHECK DISCARDING INTERVALS
C                      DISCRD - SWITCH TO SIGNAL DISCARD OF TOP INTERVAL
C                      FACTOR - ARRAY OF FACTORIALS
C                      NPAR   - NUMBER OF PAREMETERS = DEGREE + 1
C                      INTERP - NUMBER OF INTERIOR INTERPOLATION POINTS
C                               IN THE NORMAL INTERVAL
C                      IBREAK - COUNTER ON BREAK POINTS
C                      BREAK  - SWITCH FOR BREAK POINT IN TOP INTERVAL
C                               0     = NO BREAK PRESENT
C                               LEFT  = BREAK AT XLEFT(NSTACK)
C                               RIGHT = BREAK AT XRIGHT(NSTACK)
C                               BOTH  = BREAK AT BOTH ENDS
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C             COMDIF CONTAINS VARIABLES USED ONLY BY ADCOMP AND FRIENDS.
C                      NINTRP - NUMBER OF INTERIOR INTERPOLATION POINTS
C                               FOR THE CURRENT INTERVAL
C                      XINTRP - INTERIOR INTERPOLATION POINTS
C                      FINTRP - F VALUES AT XINTRP POINTS
C                      LEFTX  - MULTIPLICITY OF INTERPOLATION AT XLEFT
C                               = NO. OF DERIVATIVES MATCHED AT XLEFT
C                      FLEFT  - VALUES OF F AND ITS DERIVATIVES AT XLEFT
C                      RIGHTX - MULTIPLICITY OF INTERPOLATION AT XRIGHT
C                      FRIGHT - VALUES OF F AND DERIVATIVES AT XRIGHT
C                      DDTEMP - THE ARRAY OF DIVIDED DIFFERENCES
C                      XDD    - THE X VALUES FOR DDTEMP WITH PROPER
C                               MULTIPLICITIES OF XLEFT AND XRIGHT
C
C------------------------ MAIN CONTROL PROGRAM -------------------------
C
C            CHECK THE INPUT AND INITIALIZE ALL THE PARAMETERS
C
      CALL ADSET(XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR)
      IF (IERR.NE.0) RETURN
C
C                  LOOP OVER PROCESSING OF INTERVALS
C
   10 CALL ADTAKE(IERR)
      IF (IERR.NE.0) RETURN
      CALL ADCOMP(F)
C
C                   CHECK FOR DISCARDING INTERVALS
C
      CALL ADCHK
C
C            PUT NEW INTERVALS ON STACK OR DISCARD, UPDATE STATUS
C
      CALL ADPUT(XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR)
      IF (IERR.NE.0) RETURN
C
C                    TEST FOR NORMAL TERMINATION
C
      IF (NSTACK.EQ.0) RETURN
C
C                CHECK ON THE NUMBER OF KNOTS GENERATED
C
      IF (KNOTS.LT.MAXKNT) GO TO 10
      IERR = 1
      RETURN
      END
      SUBROUTINE ADSET(XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR)
C
C        ===============================================================
C
C **  THIS PROGRAM CHECKS THE INPUT DATA AND INITIALIZES THE COMPUTATION
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION XKNOTS(KDIMEN), COEFS(KMAX,NDIMEN)
      DOUBLE PRECISION AKMAX, EPS, EPS0, KM1, RATIO, ZERO, ONE, TWO,
     * THREE, C100
      DOUBLE PRECISION DPMPAR
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
      DATA EPS0/1.D-30/
      DATA ZERO,ONE,TWO,THREE,C100/0.D0,1.D0,2.D0,3.D0,100.D0/
      DATA KLEFT, KRIGHT, KBOTH /1, 2, 3/
C
      EPS = DPMPAR(1)
      BUFFER = C100*DMAX1(EPS,EPS0)
C
C         PUT DATA STATEMENT ITEMS INTO COMMON VARIABLES
C
      LEFT = KLEFT
      RIGHT = KRIGHT
      BOTH = KBOTH
C
C -------- SET CURRENT VALUES OF LIMITS ON DIMENSIONS ------------------
C
      KNTDIM = KDIMEN
      NPARDM = NDIMEN
      MAXKNT = KNTDIM
      MAXSTK = 50
      MAXPAR = MIN0(20,NPARDM)
      MAXAUX = 20
C
C -------- CHECK INPUT DATA --------------------------------------------
C
      IERR = 0
      IF (A.GE.B .OR. ACCUR.LE.ZERO) GO TO 200
      IF (DEGREE.GE.MAXPAR .OR. 2*SMOOTH.GE.DEGREE) GO TO 200
      AKMAX = KMAX
      RATIO = (B-A)/(DABS(A)+DABS(B))
      IF (RATIO.LE.TWO*BUFFER*AKMAX) GO TO 210
      IF (CHARF.LT.(B-A)/AKMAX) GO TO 220
      IF (NORM.GE.ZERO .AND. (NORM-ONE)*(NORM-TWO)*(NORM-THREE).NE.ZERO)
     *         GO TO 200
      IF (EDIST*(EDIST-1)*(EDIST-2).NE.0) GO TO 200
      IF (NBREAK.LT.0 .OR. NBREAK.GT.MAXAUX) GO TO 200
      IF (NBREAK.EQ.0) GO TO 150
C
C         CHECK THE BREAK POINT DATA, MONOTONICITY AND DEGREE
C
      J = 1
      IF (XBREAK(1).LT.A .OR. XBREAK(NBREAK).GT.B) GO TO 230
      IF (NBREAK.EQ.1) GO TO 110
      DO 100 J=2,NBREAK
        IF (XBREAK(J-1).GE.XBREAK(J)) GO TO 230
  100 CONTINUE
  110 LIMSM = (DEGREE-1)/2
      DO 120 J=1,NBREAK
        IF (DBREAK(J).LT.0 .OR. DBREAK(J).GT.LIMSM) GO TO 240
  120 CONTINUE
C
C -------- INITIALIZATION OF VARIABLES ---------------------------------
C
C             ACTIVE INTERVAL STACK
C
  150 NSTACK = 1
      XLEFT(1) = A
      XRIGHT(1) = B
C
C             TERMINATION AND ERROR VALUES
C
      ERROR = ZERO
      DSCTOL = ACCUR**DABS(NORM)
      IF (EDIST.EQ.0) DSCTOL = DSCTOL/(B-A)
      IF (NORM.EQ.THREE) DSCTOL = ACCUR
C
C             MISCELLANEOUS VARIABLES AND POINTERS
C
      IBREAK = 1
      KNOTS = 1
      INTERP = DEGREE + 2 - 2*SMOOTH
      XKNOTS(1) = A
      NPAR = DEGREE + 1
C
C             COMPUTE ARRAY OF NPAR FACTORIALS
C
      FACTOR(1) = ONE
      FACTOR(2) = ONE
      DO 170 K=3,NPAR
        KM1 = K-1
        FACTOR(K) = KM1*FACTOR(K-1)
  170 CONTINUE
      RETURN
C
C -------- ERROR RETURN ------------------------------------------------
C
  200 IERR = -1
      RETURN
C
C         A AND B ARE TOO CLOSE
C
  210 IERR = -2
      RETURN
C
C         CHARF IS TOO SMALL
C
  220 IERR = -3
      RETURN
C
C         BREAK POINTS ARE NOT MONOTONIC
C
  230 IERR = -4
      RETURN
C
C         BAD VALUE IN DERIVATIVE BREAKS
C
  240 IERR = -5
      RETURN
      END
      SUBROUTINE ADTAKE(IERR)
C
C        ===============================================================
C
C **  THIS PROGRAM TAKES AN ACTIVE INTERVAL OFF THE TOP OF THE STACK
C     IT ALSO DOES MOST OF THE WORK OF LOCATING AND HANDLING
C     BREAK POINTS
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION DX, RATIO
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
C         CHECK FOR BREAK POINT
      BREAK = 0
      IF (NBREAK.EQ.0 .OR. IBREAK.GT.NBREAK) GO TO 20
      IF (XBREAK(IBREAK).GT.XRIGHT(NSTACK)) GO TO 20
C
C               SET CONTROL VARIABLE BREAK, CHECK FOR LOCATION
      IF (XBREAK(IBREAK).GT.XLEFT(NSTACK)) GO TO 10
      BREAK = LEFT
      IF (IBREAK.EQ.NBREAK) GO TO 20
C             CHECK FOR SECOND BREAK POINT IN THIS INTERVAL
      IF (XBREAK(IBREAK+1).GE.XRIGHT(NSTACK)) GO TO 20
C                 NEXT BREAK IS INSIDE INTERVAL, SPLIT TOP INTERVAL
      BREAK = BOTH
C                  CHECK EXCEEDING STACK LIMIT. IF SO, STOP
      IF (NSTACK.EQ.MAXSTK) GO TO 30
C                     DONT SPLIT VERY SMALL INTERVALS, STOP INSTEAD
      DX = XBREAK(IBREAK+1) - XLEFT(NSTACK)
      RATIO = DX/(DABS(A)+DABS(B))
      IF (RATIO.LE.BUFFER) GO TO 30
      NSTACK = NSTACK + 1
      XLEFT(NSTACK) = XLEFT(NSTACK-1)
      XRIGHT(NSTACK) = XBREAK(IBREAK+1)
      XLEFT(NSTACK-1) = XRIGHT(NSTACK)
      GO TO 20
C
   10 BREAK = RIGHT
C                 CHECK TO SEE IF BREAK IS ALREADY AT RIGHT END POINT
      IF (XBREAK(IBREAK).GE.XRIGHT(NSTACK)) GO TO 20
C                 THE BREAK IS INSIDE INTERVAL, SPLIT TOP INTERVAL
C                  CHECK EXCEEDING STACK LIMIT. IF SO, STOP
      IF (NSTACK.EQ.MAXSTK) GO TO 30
C                     DONT SPLIT VERY SMALL INTERVALS, STOP INSTEAD
      DX = XBREAK(IBREAK) - XLEFT(NSTACK)
      RATIO = DX/(DABS(A)+DABS(B))
      IF (RATIO.LE.BUFFER) GO TO 30
      NSTACK = NSTACK + 1
      XLEFT(NSTACK) = XLEFT(NSTACK-1)
      XRIGHT(NSTACK) = XBREAK(IBREAK)
      XLEFT(NSTACK-1) = XRIGHT(NSTACK)
   20 CONTINUE
      RETURN
C
C        A BREAK POINT IS IN THE INTERIOR OF THE TOP SUBINTERVAL OF
C        THE STACK.  THE SUBINTERVAL CANNOT BE PARTITIONED EITHER
C        BECAUSE THE STACK IS FULL, OR BECAUSE PARTITIONING LEADS TO
C        TOO SMALL AN INTERVAL.
C
   30 IERR = 2
      RETURN
      END
      SUBROUTINE ADCOMP(F)
C
C        ===============================================================
C
C **  THIS PROGRAM COMPUTES THE PIECEWISE POLYNOMIAL APPROXIMATION ON
C     THE CURRENT INTERVAL. IT ALSO ESTIMATES THE ERROR
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION ABSC, AJ, DX, FDERVL, FDERVR, FDUMB, R, WGTS
      DIMENSION ABSC(4), WGTS(4), FDERVL(9), FDERVR(9), FDUMB(9)
      DOUBLE PRECISION ERRINT, F, POLYDD
      EXTERNAL F, POLYDD
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
      EQUIVALENCE (FLEFT(2),FDERVL(1)), (FRIGHT(2),FDERVR(1))
      DATA R/1.5D0/
C
C     THIRTY DIGIT VALUES FOR THE GAUSS INTEGRATION CONSTANTS
C                    .861136311594052575223946488893D0
C                    .339981043584856264802665759103D0
C                    .347854845137453857373063949222D0
C                    .652145154862546142626936050778D0
C
C     ***** THE ABSISSAE AND WEIGHTS ARE GIVEN BELOW TO 30 DIGITS.
C           THE PARAMETER EPS0 IN ADSET SPECIFIES THE ACCURACY OF
C           THESE CONSTANTS. IF THE ACCURACY IS CHANGED TO K DECIMAL
C           DIGITS THEN SET EPS0 = 10**(-K).
C
      DATA ABSC(1) /-.861136311594052575223946488893D0 /
      DATA ABSC(2) /-.339981043584856264802665759103D0 /
      DATA ABSC(3) / .339981043584856264802665759103D0 /
      DATA ABSC(4) / .861136311594052575223946488893D0 /
      DATA WGTS(1) / .347854845137453857373063949222D0 /
      DATA WGTS(2) / .652145154862546142626936050778D0 /
      DATA WGTS(3) / .652145154862546142626936050778D0 /
      DATA WGTS(4) / .347854845137453857373063949222D0 /
C
C             COMPUTE INTERPOLATION INFORMATION
      NINTRP = DEGREE - 2*SMOOTH - 1
C
C          INCREASE NUMBER OF INTERPOLATION POINTS IF BREAK POINTS ARE
C          SPECIFIED WITH FEWER DERIVATIVES THAN SMOOTH
      IF (BREAK.EQ.LEFT .OR. BREAK.EQ.RIGHT) NINTRP = NINTRP + SMOOTH -
     * DBREAK(IBREAK)
      IF (BREAK.EQ.BOTH) NINTRP = NINTRP + 2*SMOOTH - DBREAK(IBREAK) -
     * DBREAK(IBREAK+1)
      IF (NINTRP.EQ.0) GO TO 20
C
C             GENERATE EQUAL SPACED INTERPOLATION POINTS
      AJ = NINTRP+1
      DX = (XRIGHT(NSTACK)-XLEFT(NSTACK))/AJ
      DO 10 J=1,NINTRP
        AJ = J
        XINTRP(J) = XLEFT(NSTACK) + AJ*DX
   10 CONTINUE
C
C             GET LEFT AND RIGHT F-VALUES, PUT F-VALUE IN FIRST ELEMENT
C             OF ARRAYS FLEFT AND FRIGHT.  GET DERIVATIVES BACK AS
C             OTHER ELEMENTS VIA THE SUBARRAYS FDERVL AND FDERVR.
   20 FLEFT(1) = F(XLEFT(NSTACK),FDERVL)
      FRIGHT(1) = F(XRIGHT(NSTACK),FDERVR)
      LEFTX = SMOOTH + 1
      RIGHTX = LEFTX
C            GET F-VALUES AT OTHER INTERPOLATION POINTS, IF ANY
      IF (NINTRP.EQ.0) GO TO 40
      DO 30 J=1,NINTRP
        FINTRP(J) = F(XINTRP(J),FDUMB)
   30 CONTINUE
C
C          CHECK FOR BREAK POINTS, MODIFY VALUES IF NECESSARY
   40 CONTINUE
      IF (BREAK.NE.LEFT) GO TO 50
      LEFTX = DBREAK(IBREAK) + 1
      FLEFT(LEFTX) = BRIGHT(IBREAK)
   50 IF (BREAK.NE.RIGHT) GO TO 60
      RIGHTX = DBREAK(IBREAK) + 1
      FRIGHT(RIGHTX) = BLEFT(IBREAK)
   60 IF (BREAK.NE.BOTH) GO TO 70
      LEFTX = DBREAK(IBREAK) + 1
      RIGHTX = DBREAK(IBREAK+1) + 1
      FLEFT(LEFTX) = BRIGHT(IBREAK)
      FRIGHT(RIGHTX) = BLEFT(IBREAK+1)
   70 CONTINUE
C
C           COMPUTE DIVIDED DIFFERENCES, NEWTON FORM OF POLYNOMIAL
      CALL NEWTON(LEFTX, RIGHTX, NINTRP)
C
C         COMPUTE NORM OF ERROR OF THIS APPROMIMATION USING FOUR PTS
C         ADD 50 PERCENT FUDGE FACTOR
      ERRORI = ERRINT(F,POLYDD,XLEFT(NSTACK),XRIGHT(NSTACK),ABSC,WGTS)
      ERRORI = R*ERRORI
      RETURN
      END
      DOUBLE PRECISION FUNCTION ERRINT(F, FIT, AAA, BBB, POINTS, WEIGHT)
C
C        ===============================================================
C
C **  THIS FUNCTION DOES A FOUR POINT INTEGRATION RULE FOR THE
C     ABSOLUTE VALUE OF THE DIFFERENCE OF TWO FUNCTIONS( F AND FIT )
C                   ABS( F(X) - FIT(X) )**NORM
C     THE INTEGRATION USES THE POINTS AND WEIGHTS GIVEN AND SCALED
C     FROM (-1,1) TO (AAA,BBB)
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION AAA, ABMID, BA, BBB, FDUMB, FIT, P, PJ, POINTS,
     * WEIGHT, ER, F1, F2, TWO, THREE
      DIMENSION FDUMB(9), POINTS(*), WEIGHT(*)
      DOUBLE PRECISION F
      EXTERNAL F, FIT
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
      DATA TWO,THREE/2.0D0,3.0D0/
C
C         COMPUTE MIDPOINT = ABMID AND HALF LENGTH = BA OF INTERVAL
      ABMID = (AAA+BBB)/TWO
      BA = (BBB-AAA)/TWO
      PJ = ABMID + BA*POINTS(1)
C
C         TEST FOR TCHEBYCHEFF (MINIMAX) NORM WHICH USES SPECIAL CODE
      IF (NORM.EQ.THREE) GO TO 20
C
C         HAVE GENERAL LP NORM OR LEAST SQUARES OR LEAST DEVIATIONS
      P = DABS(NORM)
C              INITIALIZE THE QUADRATURE RULE
      ERRINT = DABS(F(PJ,FDUMB)-FIT(PJ))**P*WEIGHT(1)
C              LOOP THROUGH REMAINING POINTS
      DO 10 J=2,4
        PJ = ABMID + BA*POINTS(J)
        F1 = F(PJ,FDUMB)
        F2 = FIT(PJ)
        ER = DABS(F1-F2)**P
        ERRINT = ERRINT + DABS(F(PJ,FDUMB)-FIT(PJ))**P*WEIGHT(J)
   10 CONTINUE
      ERRINT = ERRINT*BA
      GO TO 40
C
C         TCHEBYCHEFF NORM
   20 CONTINUE
C             FIND MAX ERROR ON POINTS
C               INITIALIZE
      ERRINT = DABS(F(PJ,FDUMB)-FIT(PJ))
C              LOOP THROUGH THE REMAINING POINTS
      DO 30 J=2,4
        PJ = ABMID + BA*POINTS(J)
        ERRINT = DMAX1(ERRINT,DABS(F(PJ,FDUMB)-FIT(PJ)))
   30 CONTINUE
   40 CONTINUE
      RETURN
      END
      SUBROUTINE NEWTON(NL, NR, NI)
C
C        ===============================================================
C
C **  THIS PROGRAM COMPUTES THE DIVIDED DIFFERENCES ARRAY AS FOLLOWS
C         NL COALESCED POINTS ON LEFT   - DERIV VALUES IN FLEFT
C         NR COALESCED POINTS ON RIGHT  -   -      -    - FRIGHT
C         NI DISTINCT  POINTS INBETWEEN - FNCTN    -    - FINTRP
C
C     THE POINTS ARE ORDERED XL = XLEFT (NSTACK)
C                            XR = XRIGHT(NSTACK)
C                            XINTRP ARRAY
C
C         LAYOUT OF THE DDTEMP DIVIDED DIFFERENCE ARRAY
C
C     NL=6    LLLLLL****II
C     NR=4    LLLLL****II     L = FIRST TRIANGLE
C     NI=2    LLLL****II
C             LLL****II       R = SECOND TRIANGLE
C             LL****II
C             L****II         * = FILL BETWEEN TRIANGLES
C             RRRRII
C             RRRII           I = COMPLETION FOR INTERPOLATION POINTS
C             RRII
C             RII       IDIF = HORIZONTAL COORD. = DIFFERENCE ORDER
C             II        IPT  = VERTICAL COORD. ASSOCIATED WITH POINTS
C             I
C
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION DIFFF, DIFFX
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
C                 MAIN CALCULATION OF DIVIDED DIFFERENCES
C         DEFINE A FEW SHORT CONSTANTS
      NL1 = NL - 1
      NL2 = NL + 1
      NR1 = NR - 1
      NR2 = NR + 1
      NRL = NR + NL
C
C         PUT X-VALUES IN A SINGLE ARRAY WITH NDDX = NL+NR+NI POINTS
      DO 10 NDDX=1,NL
        XDD(NDDX) = XLEFT(NSTACK)
   10 CONTINUE
      NDDX = NL
      DO 20 K=1,NR
        NDDX = NDDX + 1
        XDD(NDDX) = XRIGHT(NSTACK)
   20 CONTINUE
C            CHECK IF THERE ARE ANY INTERPOLATION POINTS TO ADD TO XDD
      IF (NI.EQ.0) GO TO 40
      DO 30 K=1,NI
        NDDX = NDDX + 1
        XDD(NDDX) = XINTRP(K)
   30 CONTINUE
C
C           FILL BORDER OF FIRST TRIANGLE - SIZE NL.
   40 CONTINUE
C         TOP BORDER
      DO 50 IDIF=1,NL
        DDTEMP(IDIF,1) = FLEFT(IDIF)/FACTOR(IDIF)
   50 CONTINUE
      IF (NL1.EQ.0) GO TO 70
C                   BOTTOM BORDER
      DO 60 IDIF=1,NL1
        IPT = NL2 - IDIF
        DDTEMP(IDIF,IPT) = DDTEMP(IDIF,1)
   60 CONTINUE
C
C          FILL BORDER OF SECOND TRIANGLE - SIZE NR
   70 CONTINUE
C         TOP BORDER
      DO 80 IDIF=1,NR
        DDTEMP(IDIF,NL2) = FRIGHT(IDIF)/FACTOR(IDIF)
   80 CONTINUE
      IF (NRL.EQ.NL2) GO TO 100
C                   BOTTOM BORDER
      DO 90 IDIF=1,NR1
        IPT = NRL + 1 - IDIF
        DDTEMP(IDIF,IPT) = DDTEMP(IDIF,NL2)
   90 CONTINUE
C
C           FILL PARALLOGRAM BETWEEN THE TWO TRIANGLES JUST FILLED
C          FILL ENTRIES PARALLEL TO BOTTOM OF FIRST TRIANGLE
  100 CONTINUE
C
C         LOOP STEPPING ALONG TOP SIDE OF SECOND TRIANGLE
      DO 120 J=2,NR2
        IDIF = J
C             LOOP STEPPING PARALLEL TO BOTTOM SIDE OF FIRST TRIANGLE
        DO 110 K=2,NL2
          IPT = NL + 2 - K
          DIFFF = DDTEMP(IDIF-1,IPT+1) - DDTEMP(IDIF-1,IPT)
          IPT2 = IPT - 1 + IDIF
          DIFFX = XDD(IPT2) - XDD(IPT)
          DDTEMP(IDIF,IPT) = DIFFF/DIFFX
          IDIF = IDIF + 1
  110   CONTINUE
  120 CONTINUE
C
C         FILL IN BOTTOM DIAGONALS FOR INTERPOLATION POINTS, IF ANY
      IF (NI.EQ.0) GO TO 150
C         LOOP THROUGH THE INTERPOLATATION POINTS
      DO 140 J=1,NI
        IDIF = 2
        NRLJ = NRL + J
        DDTEMP(1,NRLJ) = FINTRP(J)
C         LOOP THROUGH THE DIFFERENCES (IDIF INDEX)
        NRLJ1 = NRLJ - 1
        DO 130 K=1,NRLJ1
          IPT = NRLJ - K
          DIFFF = DDTEMP(IDIF-1,IPT+1) - DDTEMP(IDIF-1,IPT)
          DIFFX = XDD(NRLJ) - XDD(IPT)
          DDTEMP(IDIF,IPT) = DIFFF/DIFFX
          IDIF = IDIF + 1
  130   CONTINUE
  140 CONTINUE
  150 CONTINUE
      RETURN
      END
      DOUBLE PRECISION FUNCTION POLYDD(X)
C
C        ===============================================================
C
C **  THIS FUNCTION EVALUATES THE CURRENT POLYNOMIAL PIECE REPRESENTED
C     BY THE DIVIDED DIFFERENCES DDTEMP ON THE POINT SET XDD.
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION X
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
      POLYDD = DDTEMP(DEGREE+1,1)
      DO 10 K=1,DEGREE
        J = DEGREE + 1 - K
        POLYDD = DDTEMP(J,1) + (X-XDD(J))*POLYDD
   10 CONTINUE
      RETURN
      END
      SUBROUTINE ADCHK
C
C        ===============================================================
C
C **  THIS PROGRAM CHECKS FOR DISCARDING INTERVAL, APPLIES VARIOUS
C     TESTS ABOUT DISCARDING INVOLVING EDIST AND CHARF.
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION AKNOTS, DTEST, DX, THREE, FIVE
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
      DATA THREE,FIVE/3.0D0,5.0D0/
C
      DISCRD = .FALSE.
      DX = XRIGHT(NSTACK) - XLEFT(NSTACK)
      IF (DX.GT.CHARF) RETURN
C
C         COMPUTE DTEST FOR THE LOCAL ERROR CRITERION
C
      IF (NORM.EQ.THREE) GO TO 30
      IF (EDIST-1) 10,20,30
   10 DTEST = DX*DSCTOL
      GO TO 40
C         FOR THE APPROXIMATE FIXED ERROR DISTRIBUTION TYPE WE ESTIMATE
C         THE FINAL NUMBER OF KNOTS BY( LIMITING IT A LITTLE )
C             (NSTACK+KNOTS+2)((B-A)/(XRIGHT-A))
   20 AKNOTS = NSTACK+KNOTS+2
      DTEST = DSCTOL/(AKNOTS*DMIN1((B-A)/(XRIGHT(NSTACK)-A),FIVE))
      GO TO 40
   30 DTEST = DSCTOL
C
C             CHECK FOR DISCARD OF INTERVAL
C
   40 IF (ERRORI.LE.DTEST) DISCRD = .TRUE.
      RETURN
      END
      SUBROUTINE ADPUT(XKNOTS, COEFS, KDIMEN, KMAX, NDIMEN, IERR)
C
C        ===============================================================
C **  THIS PROGRAM PUTS INTERVALS ON THE STACK OR DISCARDS THEM.
C     WHEN AN INTERVAL IS DISCARDED A NEW KNOT IS FOUND. THEN THIS
C     PROGRAM UPDATES THE ERROR ESTIMATE, THE XKNOT ARRAY, TRANSFORMS
C     THE POLYNOMIAL TO THE POWER FORM AND PUT THE COEFFICIENTS INTO
C     THE ARRAY COEFS.  IT ALSO CHECKS FOR PASSING BREAK POINTS
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION XKNOTS(KDIMEN), COEFS(KMAX,NDIMEN)
      DOUBLE PRECISION DX, HALF, ONE, POWERS, P, RATIO, THREE
      DIMENSION POWERS(20)
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
      DATA HALF,ONE,THREE/.5D0,1.D0,3.D0/
C
C            CHECK FOR DISCARDING THE INTERVAL
      IF (DISCRD) GO TO 30
C
C         SUBDIVIDE INTERVAL AND PLACE ON STACK
      IF (NSTACK.LT.MAXSTK) GO TO 10
C             FATAL ERROR, EXCEEDED ACTIVE STACK SIZE
      IERR = 4
      DX = XRIGHT(NSTACK)-XLEFT(NSTACK)
      IF (DX.GT.CHARF) IERR = 3
      RETURN
C
   10 DX = (XRIGHT(NSTACK)-XLEFT(NSTACK))*HALF
C              CHECK FOR SMALL INTERVALS
      RATIO = DX/(DABS(A)+DABS(B))
      IF (RATIO.GT.BUFFER) GO TO 20
      IERR = 4
      RETURN
C
   20 NSTACK = NSTACK + 1
      XLEFT(NSTACK) = XLEFT(NSTACK-1)
      XLEFT(NSTACK-1) = XRIGHT(NSTACK-1) - DX
      XRIGHT(NSTACK) = XLEFT(NSTACK-1)
      RETURN
C
C            DISCARD INTERVAL, UPDATE GLOBAL ERROR, XKNOTS AND COEFS
   30 P = DABS(NORM)
      IF (NORM.EQ.THREE) ERROR = DMAX1(ERROR,ERRORI)
      IF (NORM.NE.THREE) ERROR = (ERROR**P+ERRORI)**(ONE/P)
C
C              CHECK FOR PASSING BREAK POINTS
      IF (BREAK.EQ.LEFT .OR. BREAK.EQ.BOTH) IBREAK = IBREAK + 1
C
C             TRANSFORM REPRESENTATION OF POLYNOMIAL FROM DIVIDED
C             DIFFERENCES TO POWERS OF X WITH ORIGIN AT XKNOTS (KNOTS)
      CALL ADTRAN(DDTEMP, POWERS)
C
C             PUT COEFS INTO THE MAIN ARRAY
      DO 40 K=1,NPAR
        COEFS(KNOTS,K) = POWERS(K)
   40 CONTINUE
C            PUT THE NEW KNOTS IN XKNOTS
      KNOTS = KNOTS + 1
      XKNOTS(KNOTS) = XRIGHT(NSTACK)
      NSTACK = NSTACK - 1
      RETURN
      END
      SUBROUTINE ADTRAN(D, POWERS)
C
C        ===============================================================
C
C **  THIS PROGRAM CONVERTS POLYNOMIAL REPRESENTATION FROM DIVIDED
C     DIFFERENCE TO POWER FORM.  THERE ARE COALESCED POINTS ON EACH
C     END OF THE INTERVAL (XL,XR) = (XLEFT(NSTACK),XRIGHT(NSTACK)).
C     THE NUMBER COALESCED AT EACH END IS LEFTX AND RIGHTX.
C     AND THERE ARE NINTRP OTHER PTS XINTRP(K)  INBETWEEN THEM.
C     SEE SUBROUTINE NEWTON FOR MORE DETAILS
C
      DOUBLE PRECISION A, ACCUR, B, BLEFT, BRIGHT, CHARF, DDTEMP,
     * DSCTOL, ERROR, ERRORI, FACTOR, FINTRP, FLEFT, FRIGHT, NORM,
     * XBREAK, XDD, XINTRP, XLEFT, XRIGHT, BUFFER
      DIMENSION XBREAK(20), DBREAK(20), BLEFT(20), BRIGHT(20)
      DIMENSION XLEFT(50), XRIGHT(50)
      DIMENSION DDTEMP(20,20), FACTOR(20), FINTRP(18), FLEFT(10),
     * FRIGHT(10), XDD(20), XINTRP(18)
      INTEGER BOTH, BREAK, DBREAK, DEGREE, EDIST, RIGHT, RIGHTX, SMOOTH
      LOGICAL DISCRD
      DOUBLE PRECISION D, POWERS, SHIFT, XL, XR, XTEMP
      DIMENSION D(20,*), POWERS(*), XTEMP(20)
C
      COMMON /INPUTZ/ A, B, ACCUR, NORM, CHARF, XBREAK, BLEFT, BRIGHT,
     * DBREAK, DEGREE, SMOOTH, LEVEL, EDIST, NBREAK, KNTDIM, NPARDM
      COMMON /RESULZ/ ERROR, KNOTS
      COMMON /KONTRL/ DSCTOL, ERRORI, XLEFT, XRIGHT, BREAK, BOTH,
     * FACTOR, IBREAK, INTERP, LEFT, MAXAUX, MAXKNT, MAXPAR, MAXSTK,
     * NPAR, NSTACK, RIGHT, DISCRD, BUFFER
      COMMON /COMDIF/ DDTEMP, FINTRP, FLEFT, FRIGHT, XDD, XINTRP,
     * LEFTX, NINTRP, RIGHTX
C
C         SET SOME SHORT LOCAL VARIABLE NAMES
C
      XL = XLEFT(NSTACK)
      XR = XRIGHT(NSTACK)
      NL = LEFTX
      NR = RIGHTX
      NI = NINTRP
      NRL = NR + NL
      NRI = NR + NI
      NRI1 = NRI - 1
      NRLI = NRL + NI
C
C         STARTING REPRESENTATION IS (ASSUMING XL = 0 )
C
C    D(1) +D(2)X +D(3)X**2 + --- +D(NL)X**(NL-1)
C   +(X**NL)*( D(NL+1)(+D(NL+2)(X-XR)**2 + --- +D(NL+NR)*(X-XR)**(NR-1)
C        *((X-XR)**NR)*(D(NL+NR+1) + D(NL+NR+2)*(X-XINTRP(1))
C                      +D(NL+NR+3)*(X-XINTRP(1))(X-XINTRP(2)) + ---))
C
C         STRATEGY IS TO FIRST CONVERT THE PART FROM THE INTERP. PTS.
C         TO POLY IN (X-XR).  THIS POLY THEN HAS ORIGIN SHIFTED TO XL.
C
C     THE CONVERSION OF THE INTERP PART IS DONE EXPLICITLY FOR DEGREE
C     TWO OR LESS AND DONE BY SYNTHETIC DIVISION FOR HIGHER DEGREES
C
C   D1 + D2(X-X1) +D3(X**2-(X1+X2)X +X1*X2)
C
C     THE RESULTING COEFFICIENTS ARE PUT IN THE ARRAY POWERS
C
      IF (NI.EQ.0) GO TO 100
C
C             BUILD UP THE POLYNOMIAL FOR THE INTERPOLATION POINTS
C
C         USE SPECIAL FORMULAS FOR NI LESS THAN 3
      IF (NI.EQ.1) GO TO 10
      IF (NI.EQ.2) GO TO 20
      GO TO 30
   10 POWERS(1) = D(NRL+1,1)
      GO TO 80
   20 POWERS(1) = D(NRL+1,1) + (XR-XINTRP(1))*D(NRL+2,1)
      POWERS(2) = D(NRL+2,1)
      GO TO 80
C
C         CONVERSION BY REPEATED SYNTHETIC DIVISION
   30 NI1 = NI - 1
C         INITIALIZE THE POWERS AND XTEMP ARRAYS
      DO 40 K=1,NI
        XTEMP(K) = XINTRP(K)
        NRLK = NRL + K
        POWERS(K) = D(NRLK,1)
   40 CONTINUE
C
C         DO THE REPEATED SYNTHETIC DIVISION TO REPLACE THE XTEMP
C         = XINTRP POINTS OF THE NEWTON EXPANSION BY THE XR POINTS
      DO 70 K=1,NI1
C              POWERS(NI) IS FIXED AND SET ABOVE
        DO 50 II=1,NI1
          I = NI - II
          POWERS(I) = POWERS(I) + (XR-XTEMP(I))*POWERS(I+1)
   50   CONTINUE
C              SHIFT THE NEWTON EXPANSION PTS. UP, PUT IN ONE MORE XR
        DO 60 II=1,NI1
          I = NI - II
          XTEMP(I+1) = XTEMP(I)
   60   CONTINUE
        XTEMP(1) = XR
   70 CONTINUE
   80 CONTINUE
C             SHIFT THE COEFFICIENTS TO THE TOP OF THE POWERS ARRAY
      DO 90 K=1,NI
        L = NI + 1 - K
        LTOP = L + NRL
        POWERS(LTOP) = POWERS(L)
   90 CONTINUE
C
C             HAVE THE INTERPOLATION PT. COEFS. IN THE ARRAY POWERS
  100 CONTINUE
C             PUT THE REMAINING DIVIDED DIFFS INTO THE POWERS ARRAY
      DO 110 J=1,NRL
        POWERS(J) = D(J,1)
  110 CONTINUE
C
C         TRANSFORM THE ORIGIN OF THE POLYNOMIAL FROM XR TO XL
C         WE USE REPEATED SYNTHETIC DIVISION
      IF (NRI.EQ.1) GO TO 140
      SHIFT = XR - XL
      KHI = NRI1
C             LOOP THROUGH THE COEFFICIENTS
      DO 130 J=2,NRI
C                   SYNTHETIC DIVISION LOOP
        DO 120 K=1,KHI
          KOEF = NRLI - K
          POWERS(KOEF) = POWERS(KOEF) - SHIFT*POWERS(KOEF+1)
  120   CONTINUE
        KHI = KHI - 1
  130 CONTINUE
  140 CONTINUE
C     THE COEFFICIENTS ARE NOW OF THE POWER FORM WITH ORIGIN XL
      RETURN
      END
      SUBROUTINE CPSC (F, Z, N, IC, TOL, R, RS, ERR)
C
C  EVALUATION OF COMPLEX POWER SERIES COEFFICIENTS OR DERIVATIVES.
C
C  *** INPUT PARAMETERS ***
C    F   COMPLEX FUNCTION, OF WHICH THE COEFFICIENTS OR DERIVATIVES
C        ARE SOUGHT. THIS FUNCTION MUST BE DECLARED EXTERNAL IN THE
C        CALLING PROGRAM.
C    Z   COMPLEX POINT AROUND WHICH F IS TO BE EXPANDED OR AT WHICH
C        DERIVATIVES ARE TO BE EVALUATED.
C    N   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
C        N MUST BE GE 1 AND LE 51.
C    IC  SELECTS BETWEEN POWER SERIES COEFFICIENTS AND DERIVATIVES.
C        IC .EQ. 0   ROUTINE RETURNS POWER SERIES COEFFICIENTS IN RS.
C        IC .NE. 0   ROUTINE RETURNS DERIVATIVES IN RS.
C    TOL ESTIMATED RELATIVE ACCURACY OF F. IT IS ASSUMED THAT TOL
C        IS NONNEGATIVE. IF TOL = 0 THEN F IS ASSUMED TO BE CORRECT
C        TO MACHINE ACCURACY.
C
C  *** INPUT AND OUTPUT PARAMETER ***
C    R   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
C        RADIUS IS LEFT IN R. THE PROVIDED GUESS MAY BE IN ERROR WITH AT
C        MOST A FACTOR OF 3.E4 .
C
C  *** OUTPUT PARAMETERS ***
C    RS  COMPLEX ARRAY RS(N) CONTAINING THE N FIRST
C        COEFFICIENTS (CORRESPONDING TO THE POWERS 0 TO N-1) OR DERIVA-
C        TIVES (ORDERS 0 TO N-1).
C    ERR REAL ARRAY ERR(N) CONTAINING ABSOLUTE ERROR ESTIMATES FOR THE
C        NUMBERS IN RS.
C
      DIMENSION IP(32),A(64),RS(N),ERR(N),RT(51,3),FV(6),
     *  IW(7),SC(4),RV(3),C(4),FC(3)
      COMPLEX F,A,V,RS,RT,FV,U,W,T,Z,RV,RQ,S,XK,MULT,CO
C
C  LIST OF THE VARIABLES INITIALIZED IN THE DATA STATEMENT BELOW.
C   IW   2**( 0 , 1 , 2 , 3 , 4 , 5 , 6 ) .
C   IP   PERMUTATION CONSTANTS FOR THE FFT.
C   RV   CONSTANTS FOR THE LAURENT SERIES TEST.
C
      DATA IW(1),IW(2),IW(3),IW(4),IW(5),IW(6),IW(7)/1,2,4,8,16,32,64/
      DATA IP( 1),IP( 2),IP( 3),IP( 4),IP( 5),IP( 6),IP( 7),IP( 8),
     *     IP( 9),IP(10),IP(11),IP(12),IP(13),IP(14),IP(15),IP(16),
     *     IP(17),IP(18),IP(19),IP(20),IP(21),IP(22),IP(23),IP(24),
     *     IP(25),IP(26),IP(27),IP(28),IP(29),IP(30),IP(31),IP(32)/
     *     64,32,48,16,56,24,40,8,60,28,44,12,52,20,36,4,62,30,46,14,
     *     54,22,38,6,58,26,42,10,50,18,34,2/
      DATA RV(1)/(-.4,.3)/, RV(2)/(.7,.2)/, RV(3)/(.02,-.06)/
C
C  STATEMENT FUNCTION FOR MULTIPLICATION OF A COMPLEX NUMBER
C  BY A REAL NUMBER.
C
      MULT(RE,CO) = CMPLX(RE*REAL(CO),RE*AIMAG(CO))
C
C  -------------------
C
C  ****** EPS0 IS A MACHINE DEPENDENT CONSTANT. EPS0 IS THE
C         SMALLEST NUMBER SUCH THAT 1 + EPS0 .GT. 1.
C
                    EPS0 = SPMPAR(1)
C
C  -------------------
C
C  INITIALIZATION.
C
      EPS = AMAX1(EPS0,TOL)
      SC(1) = .125
      C(1) = EPS**(1./28.)
      EP6 = C(1)**6
      PI = 4.0*ATAN(1.0)
      FV(1) = (-1.,0.)
      FV(2) = (0.,-1.)
      R1 = SQRT(0.5)
      RA = 1.0/R1
      FV(3) = CMPLX(R1,-R1)
      DO 10 I = 2,4
        SC(I) = .5*SC(I-1)
        C(I) = SQRT(C(I-1))
        ANG = PI*SC(I-1)
   10   FV(I+2) = CMPLX(COS(ANG),-SIN(ANG))
C
C  START EXECUTION.
C
      IF (N .GT. 51 .OR. N .LT. 1) GO TO 260
      L2 = 1
      LF = 0
      NP = 0
      M = 0
      NR = -1
C
C  FIND IF A FFT OVER 8, 16, 32, OR 64 POINTS SHOULD BE USED.
C
      KL = 1
      IF (N .GT. 6) KL = 2
      IF (N .GT. 12) KL = 3
      IF (N .GT. 25) KL = 4
      KM = KL + 2
      KN = 7 - KM
      IX = IW(KM + 1)
      IS = IW(KN)
   30 V = CMPLX(R,0.0)
C
C  FUNCTION VALUES OF F ARE STORED READY PERMUTATED FOR THE FFT.
C
      DO 40 I = IS,32,IS
        IQ = IP(I)
        V = V*FV(KM)
        A(IQ) = F(Z + V)
   40   A(IQ - 1) = F(Z - V)
      LN = 2
      JN = 1
C
C  THE LOOP  DO 70 ... CONSTITUTES THE FFT.
C
      DO 70 L = 1,KM
        U = (1.,0.)
        W = FV(L)
        DO 60 J = 1,JN
          DO 50 I = J,IX,LN
            IT = I + JN
            T = A(IT)*U
            A(IT) = A(I) - T
   50       A(I) = A(I) + T
   60     U = U*W
        LN = LN + LN
   70   JN = JN + JN
      CX = 0.0
      B = 1.0
C
C  TEST ON HOW FAST THE COEFFICIENTS OBTAINED DECREASE.
C
      DO 80 I = 1,IX
        CT = CABS(A(I))/B
        IF (CT .LT. CX) GO TO 80
        CX = CT
        INR = I
   80   B = B*C(KL)
      IF (M .LE. 1) GO TO 100
C
C  ESTIMATE OF THE ROUNDING ERROR LEVEL FOR THE LAST RADIUS.
C
      ERR(1) = CX*EPS
      DO 90 I = 2,N
   90   ERR(I) = ERR(I-1)/R
  100 SF = SC(KL)
      DO 110 I = 1,IX
        A(I) = MULT(SF,A(I))
  110   SF = SF/R
      L1 = L2
      L2 = 1
      IF (INR .GT. IW(KM)) GO TO 150
      IF (LF .EQ. 1) GO TO 140
C
C  TEST IF THE SERIES IS A TAYLOR OR A LAURENT SERIES.
C
      SR = 0.0
      SP = 0.0
      DO 130 J = 1,3
        RQ = MULT(R,RV(J))
        S = A(IX)
        DO 120 I = 2,IX
          IA = IX + 1 - I
  120     S = S*RQ + A(IA)
        CP = CABS(S)
        IF (CP .GT. SP) SP = CP
        CM = CABS(S - F(Z + RQ))
  130   IF (CM .GT. SR) SR = CM
      IF (SR .GT. 1.E-3*SP) GO TO 150
      LF = 1
  140 L2 = -1
C
C  DETERMINATION OF THE NEXT RADIUS TO BE USED.
C
  150 IF (NR .GE. 0) GO TO 160
        FACT = 2.0
        IF (L2 .EQ. 1) FACT = 0.5
        L1 = L2
        NR = 0
  160 IF (L1 .NE. L2) GO TO 180
        IF (NR .GT. 0) GO TO 170
          NP = NP + 1
          IF (NP-15) 190,190,260
  170   FACT = 1.0/FACT
  180 FACT = 1.0/SQRT(FACT)
      NR = NR + 1
  190 R = R*FACT
      M = NR - KL - 1
      IF (M .LE. 0) GO TO 30
C
C  THE RESULTS FOR THE LAST THREE RADII ARE STORED.
C
      DO 200 I = 1,N
  200   RT(I,M) = A(I)
      IF (M .EQ. 1) GO TO 220
C
C  EXTRAPOLATION.
C
      DO 210 I = 1,N
        XK = RT(I,M-1) - RT(I,M)
  210   RT(I,M-1) = RT(I,M) - MULT(FC(M-1),XK)
      IF (M .EQ. 3) GO TO 230
C
C  CALCULATION OF THE EXTRAPOLATION CONSTANTS.
C
  220 FC(M) = 1.5 + SIGN(.5,FACT-1.)
      IF (M .EQ. 2) FC(M) = FC(M) + RA
      IF (FACT .GT. 1.0) FC(M) = -FC(M)
      GO TO 30
  230 FC(3) = FC(1)*FC(2)/(FC(1) + FC(2) + 1.0)
C
C  FINAL EXTRAPOLATION AND ERROR ESTIMATE.
C
      DO 240 I = 1,N
        XK = RT(I,1) - RT(I,2)
        ERR(I) = ERR(I) + EP6*CABS(XK)
  240   RS(I) = RT(I,2) - MULT(FC(3),XK)
C
C  MULTIPLY POWER SERIES COEFFICIENTS AND ERROR ESTIMATE BY FACTORIALS
C  IF DERIVATIVES WANTED.
C
      IF (IC .EQ. 0) RETURN
      FAC = 0.0
      FACT = 1.0
      DO 250 I = 1,N
        RS(I) = MULT(FACT,RS(I))
        ERR(I) = FACT*ERR(I)
        FAC = FAC + 1.0
  250   FACT = FACT*FAC
      RETURN
C
C  ERROR RETURN.
C
  260 DO 270 I = 1,N
        RS(I) = (0.,0.)
  270   ERR(I) = 1.E10
      RETURN
      END
      SUBROUTINE DCPSC (FUN, X, Y, N, IC, TOL, R, RS1, RS2, ERR)
      DOUBLE PRECISION X, Y, TOL, R, RS1(N), RS2(N), ERR(N)
C
C  EVALUATION OF COMPLEX POWER SERIES COEFFICIENTS OR DERIVATIVES.
C
C  *** INPUT PARAMETERS ***
C    FUN SUBROUTINE WHICH COMPUTES THE COMPLEX FUNCTION F FOR WHICH
C        THE COEFFICIENTS OR DERIVATIVES ARE SOUGHT. WE WRITE
C                   CALL FUN(U1,U2,W1,W2)
C        WHEN W = F(U) IS TO BE COMPUTED FOR THE COMPLEX ARGUMENT U.
C        HERE U1 AND U2 ARE THE REAL AND IMAGINARY PARTS OF U, AND W1
C        AND W2 ARE THE REAL AND IMAGINARY PARTS OF W.  U1,U2,W1,W2
C        HAVE DOUBLE PRECISION VALUES. THE SUBROUTINE FUN MUST BE
C        DECLARED IN THE CALLING PROGRAM TO BE OF TYPE EXTERNAL.
C    X   REAL PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
C        EXPANDED OR AT WHICH ITS DERIVATIVES ARE TO BE COMPUTED.
C    Y   IMAGINARY PART OF THE COMPLEX POINT AROUND WHICH F IS TO BE
C        EXPANDED OR AT WHICH ITS DERIVATIVES ARE TO BE COMPUTED.
C    N   INTEGER, NUMBER OF COEFFICIENTS OR DERIVATIVES WANTED.
C        N MUST BE GE 1 AND LE 51.
C    IC  SELECTS BETWEEN POWER SERIES COEFFICIENTS AND DERIVATIVES.
C        IC .EQ. 0   ROUTINE RETURNS POWER SERIES COEFFICIENTS IN
C                    RS1 AND RS2.
C        IC .NE. 0   ROUTINE RETURNS DERIVATIVES IN RS1 AND RS2.
C    TOL ESTIMATED RELATIVE ACCURACY OF FUN. IT IS ASSUMED THAT TOL
C        IS NONNEGATIVE. IF TOL = 0 THEN FUN IS ASSUMED TO BE CORRECT
C        TO MACHINE ACCURACY.
C
C  *** INPUT AND OUTPUT PARAMETER ***
C    R   INITIAL RADIUS USED IN SEARCH FOR OPTIMAL RADIUS. THE RESULTING
C        RADIUS IS LEFT IN R. THE PROVIDED GUESS MAY BE IN ERROR WITH AT
C        MOST A FACTOR OF 3.E4 .
C
C  *** OUTPUT PARAMETERS ***
C    RS1 ARRAY RS1(N) CONTAINING THE REAL PARTS OF THE FIRST N COMPLEX
C        COEFFICIENTS (CORRESPONDING TO THE POWERS 0 TO N-1) OR DERIVA-
C        TIVES (ORDERS 0 TO N-1).
C    RS2 ARRAY RS2(N) CONTAINING THE IMAGINARY PARTS OF THE FIRST N
C        COEFFICIENTS (CORRESPONDING TO THE POWERS 0 TO N-1) OR DERIVA-
C        TIVES (ORDERS 0 TO N-1).
C    ERR REAL ARRAY ERR(N) CONTAINING ABSOLUTE ERROR ESTIMATES FOR THE
C        COMPLEX NUMBERS WHOSE REAL AND IMAGINARY PARTS ARE IN RS1,RS2.
C
      INTEGER IP(32), IW(7)
      DOUBLE PRECISION ANG,B,CM,CP,CT,CX,EPS,EPS0,EP6,FAC,FACT,PI,
     *                 RA,R1,S,SF,SP,SR,T,U,V,W
      DOUBLE PRECISION C(4),FC(3),SC(4)
      DOUBLE PRECISION A1(64),A2(64),FV1(6),FV2(6),RT1(51,3),RT2(51,3),
     *                 RV1(3),RV2(3)
      DOUBLE PRECISION DCPABS, DPMPAR
C
C  LIST OF THE VARIABLES INITIALIZED IN THE DATA STATEMENT BELOW.
C   IW   2**( 0 , 1 , 2 , 3 , 4 , 5 , 6 ) .
C   IP   PERMUTATION CONSTANTS FOR THE FFT.
C   RV1  REAL PARTS OF THE CONSTANTS FOR THE LAURENT SERIES TEST.
C   RV2  IMAGINARY PARTS OF THE CONSTANTS FOR THE LAURENT SERIES TEST.
C
      DATA IW(1),IW(2),IW(3),IW(4),IW(5),IW(6),IW(7)/1,2,4,8,16,32,64/
      DATA IP( 1),IP( 2),IP( 3),IP( 4),IP( 5),IP( 6),IP( 7),IP( 8),
     *     IP( 9),IP(10),IP(11),IP(12),IP(13),IP(14),IP(15),IP(16),
     *     IP(17),IP(18),IP(19),IP(20),IP(21),IP(22),IP(23),IP(24),
     *     IP(25),IP(26),IP(27),IP(28),IP(29),IP(30),IP(31),IP(32)/
     *     64,32,48,16,56,24,40,8,60,28,44,12,52,20,36,4,62,30,46,14,
     *     54,22,38,6,58,26,42,10,50,18,34,2/
      DATA RV1(1)/-.4D0/, RV2(1)/.3D0/,
     *     RV1(2)/ .7D0/, RV2(2)/.2D0/,
     *     RV1(3)/.02D0/, RV2(3)/-.06D0/
C
C  -------------------
C
C  ****** EPS0 IS A MACHINE DEPENDENT CONSTANT. EPS0 IS THE
C         SMALLEST NUMBER SUCH THAT 1 + EPS0 .GT. 1.
C
                    EPS0 = DPMPAR(1)
C
C  -------------------
C
C  INITIALIZATION.
C
      EPS = DMAX1(EPS0,TOL)
      SC(1) = .125D0
      C(1) = EPS**(1.D0/28.D0)
      EP6 = C(1)**6
      PI = 4.D0*DATAN(1.D0)
      FV1(1) = -1.D0
      FV2(1) =  0.D0
      FV1(2) =  0.D0
      FV2(2) = -1.D0
      R1 = DSQRT(0.5D0)
      RA = 1.D0/R1
      FV1(3) =  R1
      FV2(3) = -R1
      DO 10 I = 2,4
         SC(I) = 0.5D0*SC(I-1)
         C(I) = DSQRT(C(I-1))
         ANG = PI*SC(I-1)
         FV1(I + 2) =  DCOS(ANG)
   10    FV2(I + 2) = -DSIN(ANG)
C
C  START EXECUTION.
C
      IF (N .GT. 51 .OR. N .LT. 1) GO TO 260
      L2 = 1
      LF = 0
      NP = 0
      M = 0
      NR = -1
C
C  FIND IF A FFT OVER 8, 16, 32, OR 64 POINTS SHOULD BE USED.
C
      KL = 1
      IF (N .GT. 6) KL = 2
      IF (N .GT. 12) KL = 3
      IF (N .GT. 25) KL = 4
      KM = KL + 2
      KN = 7 - KM
      IX = IW(KM + 1)
      IS = IW(KN)
   30 U = R
      V = 0.D0
C
C  FUNCTION VALUES OF F ARE STORED READY PERMUTATED FOR THE FFT.
C
      DO 40 I = IS,32,IS
         IQ = IP(I)
         T = U*FV1(KM) - V*FV2(KM)
         V = U*FV2(KM) + V*FV1(KM)
         U = T
         CALL FUN(X + U, Y + V, A1(IQ), A2(IQ))
         CALL FUN(X - U, Y - V, A1(IQ-1), A2(IQ-1))
   40 CONTINUE
      LN = 2
      JN = 1
C
C  THE LOOP  DO 70 ... CONSTITUTES THE FFT.
C
      DO 70 L = 1,KM
         U = 1.0
         V = 0.0
         DO 60 J = 1,JN
            DO 50 I = J,IX,LN
               IT = I + JN
               S = U*A1(IT) - V*A2(IT)
               T = U*A2(IT) + V*A1(IT)
               A1(IT) = A1(I) - S
               A2(IT) = A2(I) - T
               A1(I) = A1(I) + S
   50          A2(I) = A2(I) + T
            T = U*FV1(L) - V*FV2(L)
            V = U*FV2(L) + V*FV1(L)
   60       U = T
         LN = LN + LN
   70    JN = JN + JN
      CX = 0.D0
      B = 1.D0
C
C  TEST ON HOW FAST THE COEFFICIENTS OBTAINED DECREASE.
C
      DO 80 I = 1,IX
         CT = DCPABS(A1(I),A2(I))/B
         IF (CT .LT. CX) GO TO 80
         CX = CT
         INR = I
   80    B = B*C(KL)
      IF (M .LE. 1) GO TO 100
C
C  ESTIMATE OF THE ROUNDING ERROR LEVEL FOR THE LAST RADIUS.
C
      ERR(1) = CX*EPS
      DO 90 I = 2,N
   90    ERR(I) = ERR(I-1)/R
C
  100 SF = SC(KL)
      DO 110 I = 1,IX
         A1(I) = SF*A1(I)
         A2(I) = SF*A2(I)
  110    SF = SF/R
      L1 = L2
      L2 = 1
      IF (INR .GT. IW(KM)) GO TO 150
      IF (LF .EQ. 1) GO TO 140
C
C  TEST IF THE SERIES IS A TAYLOR OR A LAURENT SERIES.
C
      SR = 0.D0
      SP = 0.D0
      DO 130 J = 1,3
         S = A1(IX)
         T = A2(IX)
         U = R*RV1(J)
         V = R*RV2(J)
         DO 120 I = 2,IX
            IA = IX + 1 - I
            W = (S*U - T*V) + A1(IA)
            T = (S*V + T*U) + A2(IA)
  120       S = W
         CP = DCPABS(S,T)
         IF (CP .GT. SP) SP = CP
         CALL FUN(X + U, Y + V, U, V)
         CM = DCPABS(S - U, T - V)
  130    IF (CM .GT. SR) SR = CM
      IF (SR .GT. 1.D-3*SP) GO TO 150
      LF = 1
  140 L2 = -1
C
C  DETERMINATION OF THE NEXT RADIUS TO BE USED.
C
  150 IF (NR .GE. 0) GO TO 160
         FACT = 2.D0
         IF (L2 .EQ. 1) FACT = 0.5D0
         L1 = L2
         NR = 0
  160 IF (L1 .NE. L2) GO TO 180
         IF (NR .GT. 0) GO TO 170
            NP = NP + 1
            IF (NP-15) 190,190,260
  170    FACT = 1.D0/FACT
  180 FACT = 1.D0/DSQRT(FACT)
      NR = NR + 1
  190 R = R*FACT
      M = NR - KL - 1
      IF (M .LE. 0) GO TO 30
C
C  THE RESULTS FOR THE LAST THREE RADII ARE STORED.
C
      DO 200 I = 1,N
         RT1(I,M) = A1(I)
  200    RT2(I,M) = A2(I)
      IF (M .EQ. 1) GO TO 220
C
C  EXTRAPOLATION.
C
      MM1 = M - 1
      DO 210 I = 1,N
         U = RT1(I,MM1) - RT1(I,M)
         V = RT2(I,MM1) - RT2(I,M)
         RT1(I,MM1) = RT1(I,M) - FC(MM1)*U
  210    RT2(I,MM1) = RT2(I,M) - FC(MM1)*V
      IF (M .EQ. 3) GO TO 230
C
C  CALCULATION OF THE EXTRAPOLATION CONSTANTS.
C
  220 FC(M) = 1.5D0 + DSIGN(0.5D0,FACT-1.D0)
      IF (M .EQ. 2) FC(M) = FC(M) + RA
      IF (FACT .GT. 1.D0) FC(M) = -FC(M)
      GO TO 30
  230 FC(3) = FC(1)*FC(2)/(FC(1) + FC(2) + 1.D0)
C
C  FINAL EXTRAPOLATION AND ERROR ESTIMATE.
C
      DO 240 I = 1,N
         U = RT1(I,1) - RT1(I,2)
         V = RT2(I,1) - RT2(I,2)
         ERR(I) = ERR(I) + EP6*DCPABS(U,V)
         RS1(I) = RT1(I,2) - FC(3)*U
  240    RS2(I) = RT2(I,2) - FC(3)*V
C
C  MULTIPLY POWER SERIES COEFFICIENTS AND ERROR ESTIMATE BY FACTORIALS
C  IF DERIVATIVES WANTED.
C
      IF (IC .EQ. 0) RETURN
      FAC = 0.D0
      FACT = 1.D0
      DO 250 I = 1,N
         RS1(I) = FACT*RS1(I)
         RS2(I) = FACT*RS2(I)
         ERR(I) = FACT*ERR(I)
         FAC = FAC + 1.D0
  250    FACT = FACT*FAC
      RETURN
C
C  ERROR RETURN.
C
  260 DO 270 I = 1,N
         RS1(I) = 0.D0
         RS2(I) = 0.D0
  270    ERR(I) = 1.D10
      RETURN
      END
      FUNCTION TRP(A,N,X,Y)
      DIMENSION X(N),Y(N)
C
      NM1 = N-1
      IF (A.LT.X(2)) GO TO 50
      IF (A.GE.X(NM1)) GO TO 40
      IL = 2
      IR = NM1
C
C     BISECTION SEARCH
C
   10 I = (IL+IR)/2
      IF (I.EQ.IL) GO TO 60
      IF (A-X(I)) 20,60,30
   20 IR = I
      GO TO 10
   30 IL = I
      GO TO 10
C
C     A.LT.X(2) .OR. A.GE.X(N-1)
C
   40 I = NM1
      GO TO 60
   50 I = 1
C
C     EVALUATION
C
   60 R = (A-X(I))/(X(I+1)-X(I))
      TRP = Y(I)+R*(Y(I+1)-Y(I))
      RETURN
      END
      SUBROUTINE LTRP (M,X,Y,N,XI,YI,NI,T,IERR)
C     ******************************************************************
C     LAGRANGE INTERPOLATION
C     ******************************************************************
      DIMENSION X(N),Y(N),XI(NI),YI(NI),T(M)
C
C     CHECK INPUT
C
      IF (M.LT.2) GO TO 130
      IF (M.GT.N) GO TO 131
      IF (NI.LT.1) GO TO 132
      IERR = 0
C
C     INITIALIZATION
C
      MM1 = M-1
      K  = 1
      XX = XI(1)
      ILOLD = 0
C
C     FIND THE SUBINTERVAL WHICH CONTAINS XX. I = 1 IF XX.LT.X(2)
C     AND I = N IF XX.GE.X(N). OTHERWISE X(I).LE.XX.LT.X(I+1).
C
      IF (XX-X(1)) 10,11,20
   10 I = 1
      IL = 1
      IR = M
      GO TO 80
   11 I = 1
      YI(K) = Y(1)
      GO TO 110
C
   20 IF (X(N)-XX) 21,22,23
   21 I = N
      IL = N-M+1
      IR = N
      GO TO 80
   22 I = N
      YI(K) = Y(N)
      GO TO 110
   23 IL = 1
      IR = N
C
C     BISECTION SEARCH
C
   30 I = (IL+IR)/2
      IF (I.EQ.IL) GO TO 50
      IF (XX-X(I)) 31,32,33
   31 IR = I
      GO TO 30
   32 YI(K) = Y(I)
      GO TO 110
   33 IL = I
      GO TO 30
C
C     LINEAR FORWARD SEARCH
C
   40 IF (XX-X(I+1)) 50,41,42
   41 I = I+1
      YI(K) = Y(I)
      GO TO 110
   42 I = I+1
      GO TO 40
C
C     POINT XX LIES IN THE OPEN SUBINTERVAL (X(I),X(I+1)).
C     FIND THE M CLOSEST POINTS X(IL),...,X(IR) TO XX.
C
   50 IF (I.GT.M) GO TO 51
      IL = 1
      NUM = I
      GO TO 60
   51 IL = I-M+1
      NUM = M
C
   60 IPM = I+M
      IF (IPM.LE.N) GO TO 61
      IR = N
      NUM = NUM+N-I
      GO TO 70
   61 IR = IPM
      NUM = NUM+M
C
   70 NUM = NUM-M
      IF (NUM.EQ.0) GO TO 80
      DL = XX-X(IL)
      DR = X(IR)-XX
      DO 72 L=1,NUM
      IF (DL.LE.DR) GO TO 71
      IL = IL+1
      DL = XX-X(IL)
      GO TO 72
   71 IR = IR-1
      DR = X(IR)-XX
   72 CONTINUE
C
C     COMPUTE THE COEFFICIENTS T(1),...,T(M) OF THE BACKWARD
C     NEWTON FORM OF THE INTERPOLATING POLYNOMIAL.
C
   80 IF (IL.EQ.ILOLD) GO TO 100
      ILOLD = IL
      ILM1 = IL-1
      DO 81 J=1,M
      L = ILM1+J
   81 T(J) = Y(L)
C
      DO 91 ISTEP=1,MM1
      JMAX = M-ISTEP
      DO 90 J=1,JMAX
      II = ILM1+J
      L = II+ISTEP
   90 T(J) = (T(J)-T(J+1))/(X(II)-X(L))
   91 CONTINUE
C
C     EVALUATION OF THE INTERPOLATING POLYNOMIAL
C
  100 YI(K) = T(1)
      DO 101 J=2,M
      L = ILM1+J
  101 YI(K) = T(J)+YI(K)*(XX-X(L))
C
C     NEXT POINT
C
  110 IF (K.GE.NI) RETURN
      K = K+1
      XX = XI(K)
      IF (XX-X(1)) 10,11,111
  111 IF (X(N)-XX) 21,22,120
C
  120 IF (XX-XI(K-1)) 121,122,40
  121 IL = 1
      IR = MIN0(I+1,N)
      GO TO 30
  122 YI(K) = YI(K-1)
      GO TO 110
C
C     ERROR RETURN
C
  130 IERR = 1
      RETURN
  131 IERR = 2
      RETURN
  132 IERR = 3
      RETURN
      END
      SUBROUTINE HTRP (N,X,Y,A,T,IERR)
C     ******************************************************************
C     HERMITE INTERPOLATION
C     ******************************************************************
      DIMENSION X(N),Y(N),A(N),T(N)
      IF (N.LE.0) GO TO 30
      IERR = 0
      A(1) = Y(1)
      IF (N.EQ.1) RETURN
      F = 1.0
      R = 0.0
      IEND = 0
      IBEG = 1
C
      DO 22 K=2,N
      IF (X(K)-X(K-1)) 10,20,10
C
   10 F = 1.0
      R = 0.0
      IEND = K-1
      IBEG = K
      T(1) = Y(K)
      DO 11 I=1,IEND
      DIFF = X(I)-X(K)
      IF (DIFF) 11,31,11
   11 T(I+1) = (A(I)-T(I))/DIFF
      GO TO 22
C
   20 R = R+1.0
      F = F*R
      T(1) = Y(K)/F
      IF (IEND.EQ.0) GO TO 22
      DO 21 I=1,IEND
   21 T(I+1) = (T(I+1)-T(I))/(X(I)-X(K))
   22 A(K) = T(IBEG)
      RETURN
C
   30 IERR = 1
      RETURN
   31 IERR = 2
      T(1) = I
      T(2) = K
      RETURN
      END
      SUBROUTINE PCOEFF(ALPHA,N,X,A,C,T)
      REAL X(*),A(N),C(N)
      DOUBLE PRECISION XX,R,T(N)
      IF (N.GT.1) GO TO 10
      C(1) = A(1)
      RETURN
C
   10 XX = ALPHA
      NM1 = N-1
      DO 11 I=1,N
   11 T(I) = A(I)
C
      DO 21 I=1,NM1
      J = N-I
      R = XX-DBLE(X(J))
      DO 20 K=J,NM1
   20 T(K) = T(K)+R*T(K+1)
   21 CONTINUE
C
      DO 30 I=1,N
   30 C(I) = T(I)
      RETURN
      END
      SUBROUTINE PFIT(ND,NP,X,Y,A,RNORM,PHI,PHIX,IERR)
C     ******************************************************************
C     UNWEIGHTED LEAST SQUARES POLYNOMIAL FIT
C     ******************************************************************
      REAL X(NP),Y(NP),A(*),PHI(2,*),PHIX(4,NP)
      REAL LAMBDA
      DOUBLE PRECISION DALPHA,DSUM
C     ---------------------
      IERR=0
      IF (1.LE.ND.AND.ND.LT.NP) GO TO 10
      IERR=1
      RETURN
C
C                      INITIALIZATION
C
   10 ND1=ND+1
      DO 11 K=1,ND1
      A(K)=0.0
      PHI(1,K)=0.0
   11 PHI(2,K)=0.0
C
C                SET Z=A+B*X WHERE ABS(Z).LE.1
C
      XMIN=X(1)
      XMAX=X(1)
      DO 21 K=2,NP
      IF (X(K).GE.XMIN) GO TO 20
      XMIN=X(K)
      GO TO 21
   20 IF (X(K).GT.XMAX) XMAX=X(K)
   21 CONTINUE
      ZB=2.0/(XMAX-XMIN)
      ZA=-XMIN*ZB-1.0
      DO 22 K=1,NP
   22 PHIX(3,K)=ZA+ZB*X(K)
C
C           COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE 0
C
      LAMBDA=NP
      PHI(1,1)=1.0/SQRT(LAMBDA)
      DALPHA=0.D0
      DSUM=0.D0
      DO 30 K=1,NP
      PHIX(1,K)=PHI(1,1)
      DALPHA=DALPHA+DBLE(PHIX(3,K))
   30 DSUM=DSUM+DBLE(Y(K))
      ALPHA=SNGL(DALPHA)/LAMBDA
      A(1)=SNGL(DSUM)/LAMBDA
      DO 31 K=1,NP
   31 PHIX(4,K)=A(1)
C
      LA=2
      LB=1
      DO 90 M=1,ND
      MP1=M+1
C
C          GENERATE LAMBDA(M)*PHI(M) AND EVALUATE IT AT Z
C
      IF (M.NE.1) GO TO 50
      PHI(2,1)=-ALPHA*PHI(1,1)
      PHI(2,2)=PHI(1,1)
      DO 40 K=1,NP
   40 PHIX(2,K)=(PHIX(3,K)-ALPHA)*PHI(1,1)
      GO TO 60
C
   50 C=0.0
      DO 51 K=1,M
      PHI(LA,K)=DBLE(C)-DBLE(ALPHA*PHI(LB,K))-DBLE(LAMBDA*PHI(LA,K))
   51 C=PHI(LB,K)
      PHI(LA,MP1)=C
      DO 52 K=1,NP
   52 PHIX(LA,K)=(PHIX(3,K)-ALPHA)*PHIX(LB,K)-LAMBDA*PHIX(LA,K)
C
C                COMPUTE ALPHA(M) AND LAMBDA(M)
C
   60 DALPHA=0.D0
      DSUM=0.D0
      DO 61 K=1,NP
      C=PHIX(LA,K)*PHIX(LA,K)
      DALPHA=DALPHA+DBLE(C*PHIX(3,K))
   61 DSUM=DSUM+DBLE(C)
      LAMBDA=DSUM
      ALPHA=SNGL(DALPHA)/LAMBDA
      LAMBDA=SQRT(LAMBDA)
C
C              GENERATE PHI(M) AND EVALUATE IT AT Z
C
      DO 70 K=1,MP1
   70 PHI(LA,K)=PHI(LA,K)/LAMBDA
      DO 71 K=1,NP
   71 PHIX(LA,K)=PHIX(LA,K)/LAMBDA
C
C        COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE M OR LESS
C                     AND EVALUATE IT AT Z
C
      DSUM=0.D0
      DO 80 K=1,NP
   80 DSUM=DSUM+DBLE((Y(K)-PHIX(4,K))*PHIX(LA,K))
      C=DSUM
      DO 81 K=1,MP1
   81 A(K)=A(K)+C*PHI(LA,K)
      DO 82 K=1,NP
   82 PHIX(4,K)=PHIX(4,K)+C*PHIX(LA,K)
C
      LS=LA
      LA=LB
   90 LB=LS
C
C                        COMPUTE RNORM
C
      DSUM=0.D0
      DO 95 K=1,NP
   95 DSUM=DSUM+DBLE((Y(K)-PHIX(4,K))**2)
      RNORM=SQRT(SNGL(DSUM))
C
C        CONVERT THE CLOSEST POLYNOMIAL FROM A POLYNOMIAL
C                  IN Z TO A POLYNOMIAL IN X
C
      A(1)=A(1)+ZA*A(2)
      A(2)=ZB*A(2)
      IF (ND.EQ.1) RETURN
      PHI(1,1)=ZA
      PHI(1,2)=ZB
      DO 102 M=2,ND
      MP1=M+1
      C=0.0
      DO 100 K=1,M
      TEMP=PHI(1,K)*ZB
      PHI(1,K)=PHI(1,K)*ZA+C
  100 C=TEMP
      PHI(1,MP1)=C
      DO 101 K=1,M
  101 A(K)=A(K)+A(MP1)*PHI(1,K)
  102 A(MP1)=A(MP1)*PHI(1,MP1)
      RETURN
      END
      SUBROUTINE WPFIT(ND,NP,X,Y,W,A,RNORM,PHI,PHIX,IERR)
C     ******************************************************************
C     WEIGHTED LEAST SQUARES POLYNOMIAL FIT
C     ******************************************************************
      REAL X(NP),Y(NP),W(NP),A(*),PHI(2,*),PHIX(4,NP)
      REAL LAMBDA
      DOUBLE PRECISION DALPHA,DSUM
C     ---------------------
C
C                      ERROR CHECKING
C
      IF (ND.LT.1.OR.NP.LT.2) GO TO 200
      NW=0
      DSUM=0.D0
      DO 13 K=1,NP
      IF (W(K)) 202,13,10
   10 NW=NW+1
      DSUM=DSUM+DBLE(W(K))
      IF (NW.GT.1) GO TO 11
      XMIN=X(K)
      XMAX=X(K)
      GO TO 13
   11 IF (X(K).GE.XMIN) GO TO 12
      XMIN=X(K)
      GO TO 13
   12 IF (X(K).GT.XMAX) XMAX=X(K)
   13 CONTINUE
      IF (ND.GE.NW) GO TO 200
C
C                      INITIALIZATION
C
      IERR=0
      ND1=ND+1
      DO 20 K=1,ND1
      A(K)=0.0
      PHI(1,K)=0.0
   20 PHI(2,K)=0.0
C
C                SET Z=A+B*X WHERE ABS(Z).LE.1
C
      ZB=2.0/(XMAX-XMIN)
      ZA=-XMIN*ZB-1.0
      DO 25 K=1,NP
   25 PHIX(3,K)=ZA+ZB*X(K)
C
C           COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE 0
C
      LAMBDA=DSUM
      PHI(1,1)=1.0/SQRT(LAMBDA)
      DALPHA=0.D0
      DSUM=0.D0
      DO 30 K=1,NP
      PHIX(1,K)=PHI(1,1)
      DALPHA=DALPHA+DBLE(W(K)*PHIX(3,K))
   30 DSUM=DSUM+DBLE(W(K)*Y(K))
      ALPHA=SNGL(DALPHA)/LAMBDA
      A(1)=SNGL(DSUM)/LAMBDA
      DO 31 K=1,NP
   31 PHIX(4,K)=A(1)
C
      LA=2
      LB=1
      DO 90 M=1,ND
      MP1=M+1
C
C          GENERATE LAMBDA(M)*PHI(M) AND EVALUATE IT AT Z
C
      IF (M.NE.1) GO TO 50
      PHI(2,1)=-ALPHA*PHI(1,1)
      PHI(2,2)=PHI(1,1)
      DO 40 K=1,NP
   40 PHIX(2,K)=(PHIX(3,K)-ALPHA)*PHI(1,1)
      GO TO 60
C
   50 C=0.0
      DO 51 K=1,M
      PHI(LA,K)=DBLE(C)-DBLE(ALPHA*PHI(LB,K))-DBLE(LAMBDA*PHI(LA,K))
   51 C=PHI(LB,K)
      PHI(LA,MP1)=C
      DO 52 K=1,NP
   52 PHIX(LA,K)=(PHIX(3,K)-ALPHA)*PHIX(LB,K)-LAMBDA*PHIX(LA,K)
C
C                COMPUTE ALPHA(M) AND LAMBDA(M)
C
   60 DALPHA=0.D0
      DSUM=0.D0
      DO 61 K=1,NP
      C=W(K)*PHIX(LA,K)*PHIX(LA,K)
      DALPHA=DALPHA+DBLE(C*PHIX(3,K))
   61 DSUM=DSUM+DBLE(C)
      LAMBDA=DSUM
      ALPHA=SNGL(DALPHA)/LAMBDA
      LAMBDA=SQRT(LAMBDA)
C
C              GENERATE PHI(M) AND EVALUATE IT AT Z
C
      DO 70 K=1,MP1
   70 PHI(LA,K)=PHI(LA,K)/LAMBDA
      DO 71 K=1,NP
   71 PHIX(LA,K)=PHIX(LA,K)/LAMBDA
C
C        COMPUTE THE CLOSEST POLYNOMIAL OF DEGREE M OR LESS
C                     AND EVALUATE IT AT Z
C
      DSUM=0.D0
      DO 80 K=1,NP
   80 DSUM=DSUM+DBLE(W(K)*(Y(K)-PHIX(4,K))*PHIX(LA,K))
      C=DSUM
      DO 81 K=1,MP1
   81 A(K)=A(K)+C*PHI(LA,K)
      DO 82 K=1,NP
   82 PHIX(4,K)=PHIX(4,K)+C*PHIX(LA,K)
C
      LS=LA
      LA=LB
   90 LB=LS
C
C                        COMPUTE RNORM
C
      DSUM=0.D0
      DO 95 K=1,NP
   95 DSUM=DSUM+DBLE(W(K)*(Y(K)-PHIX(4,K))**2)
      RNORM=SQRT(SNGL(DSUM))
C
C        CONVERT THE CLOSEST POLYNOMIAL FROM A POLYNOMIAL
C                  IN Z TO A POLYNOMIAL IN X
C
      A(1)=A(1)+ZA*A(2)
      A(2)=ZB*A(2)
      IF (ND.EQ.1) RETURN
      PHI(1,1)=ZA
      PHI(1,2)=ZB
      DO 102 M=2,ND
      MP1=M+1
      C=0.0
      DO 100 K=1,M
      TEMP=PHI(1,K)*ZB
      PHI(1,K)=PHI(1,K)*ZA+C
  100 C=TEMP
      PHI(1,MP1)=C
      DO 101 K=1,M
  101 A(K)=A(K)+A(MP1)*PHI(1,K)
  102 A(MP1)=A(MP1)*PHI(1,MP1)
      RETURN
C
C                        ERROR RETURN
C
  200 IERR=1
      RETURN
  202 IERR=3
      RETURN
      END
      SUBROUTINE CBSPL (X, Y, A, B, C, N, IBEG, IEND, ALPHA, BETA, IERR)
C-----------------------------------------------------------------------
C                   CUBIC SPLINE INTERPOLATION
C-----------------------------------------------------------------------
      REAL X(N), Y(N), A(N), B(N), C(N)
C
      IF (N .LT. 3) GO TO 200
 
C     A TRIDIAGONAL LINEAR SYSTEM FOR THE UNKNOWN SLOPES S(I) OF
C     F AT X(I), I=1,...,N, IS GENERATED AND THEN SOLVED BY GAUSS
C     ELIMINATION, WITH S(I) ENDING UP IN A(I) FOR ALL I. A, B, C
C     ARE USED INITIALLY FOR WORK SPACES.
C
      DO 10 M = 2,N
         B(M) = X(M) - X(M-1)
         IF (B(M) .LE. 0.0) GO TO 210
         C(M) = (Y(M) - Y(M-1))/B(M)
   10 CONTINUE
      IERR = 0
C
C     CONSTRUCT THE FIRST EQUATION FROM THE BOUNDARY CONDITION, OF
C     THE FORM
C
C             C(1)*S(1) + B(1)*S(2) = A(1)
C
      IF (IBEG - 1) 20,30,40
C
C     NO CONDITION AT LEFT END.
C
   20 C(1) = B(3)
      B(1) = X(3) - X(1)
      A(1) = ((B(2) + 2.0*B(1))*B(3)*C(2) + B(2)*B(2)*C(3))/B(1)
      GO TO 50
C
C     SLOPE PRESCRIBED AT LEFT END.
C
   30 C(1) = 1.0
      B(1) = 0.0
      A(1) = ALPHA
      GO TO 50
C
C     SECOND DERIVATIVE PRESCRIBED AT LEFT END.
C
   40 C(1) = 2.0
      B(1) = 1.0
      A(1) = 3.0*C(2) - 0.5*ALPHA*B(2)
C
C     FOR THE INTERIOR KNOTS, GENERATE THE CORRESPONDING EQUATIONS AND
C     CARRY OUT THE FORWARD PASS OF GAUSS ELIMINATION, AFTER WHICH THE
C     M-TH EQUATION READS  C(M)*S(M) + B(M)*S(M+1) = A(M).
C
   50 NM1 = N - 1
      DO 51 M = 2,NM1
         T = -B(M+1)/C(M-1)
         A(M) = T*A(M-1) + 3.0*(B(M)*C(M+1) + B(M+1)*C(M))
         C(M) = T*B(M-1) + 2.0*(B(M) + B(M+1))
   51 CONTINUE
C
C     IF THE SLOPE AT THE RIGHT END IS GIVEN, THEN SET A(N) TO THE
C     SLOPE AND GO TO BACK SUBSTITUTION. OTHERWISE, CONSTRUCT THE
C     LAST EQUATION FROM THE SECOND BOUNDARY CONDITION, OF THE FORM
C
C                R*S(N-1) + C(N)*S(N) = A(N)
C
      IF (IEND - 1) 60,80,90
   60 IF (N .EQ. 3 .AND. IBEG .EQ. 0) GO TO 70
C
C     NO CONDITION AT THE RIGHT END. EITHER  N .GE. 4  OR
C     THERE IS A CONDITION AT THE LEFT END.
C
      R = X(N) - X(N-2)
      DEL  = (Y(NM1) - Y(N-2))/B(NM1)
      A(N) = ((B(N) + 2.0*R)*B(NM1)*C(N) + B(N)*B(N)*DEL)/R
      C(N) = B(NM1)
      GO TO 100
C
C     NO CONDITIONS AT THE END POINTS AND N = 3. IN THIS CASE,
C     THE SECOND BOUNDARY CONDITION DOES NOT PROVIDE US WITH A
C     NEW EQUATION. FOR CONVENIENCE, WE USE THE FOLLOWING...
C
   70 A(N) = 2.0*C(N)
      C(N) = 1.0
      R = 1.0
      GO TO 100
C
C     SLOPE PRESCRIBED AT RIGHT END.
C
   80 A(N) = BETA
      GO TO 110
C
C     SECOND DERIVATIVE PRESCRIBED AT RIGHT END.
C
   90 A(N) = 3.0*C(N) + 0.5*BETA*B(N)
      C(N) = 2.0
      R = 1.0
C
C     COMPLETE FORWARD PASS OF GAUSS ELIMINATION.
C
  100 T = -R/C(NM1)
      A(N) = (T*A(NM1) + A(N))/(T*B(NM1) + C(N))
C
C     CARRY OUT BACK SUBSTITUTION.
C
  110 DO 120 I = 1,NM1
         J = N - I
         A(J) = (A(J) - B(J)*A(J+1))/C(J)
  120 CONTINUE
C
C     GENERATE THE CUBIC COEFFICIENTS B(I) AND C(I).
C
      DO 130 I = 1,NM1
         H = B(I+1)
         DEL = (Y(I+1) - Y(I))/H
         T = A(I) + A(I+1) - 2.0*DEL
         B(I) = (DEL - A(I) - T)/H
         C(I) = (T/H)/H
  130 CONTINUE
      RETURN
C
C     ERROR RETURN
C
  200 IERR = 1
      RETURN
  210 IERR = 2
      RETURN
      END
      SUBROUTINE SPLIFT (X,Y,YP,YPP,N,W,IERR,ISX,A1,B1,AN,BN)
C
C     WRITTEN BY RONDALL E. JONES
C        SANDIA LABORATORIES
C        ALBUQUERQUE, NEW MEXICO  87115
C        JANUARY 1976
C
C     ABSTRACT
C         SPLIFT FITS AN INTERPOLATING CUBIC SPLINE TO THE N DATA POINTS
C         GIVEN IN X AND Y AND RETURNS THE FIRST AND SECOND DERIVATIVES
C         IN YP AND YPP.
C
C     DESCRIPTION OF ARGUMENTS
C
C       --INPUT--
C
C         X    - ARRAY OF ABSCISSAS OF DATA (IN INCREASING ORDER)
C         Y    - ARRAY OF ORDINATES OF DATA
C         N    - THE NUMBER OF DATA POINTS.  THE ARRAYS X, Y, YP, AND
C                YPP MUST BE DIMENSIONED AT LEAST N.  (N .GE. 4)
C         ISX  - MUST BE ZERO ON THE INITIAL CALL TO SPLIFT.
C                IF A SPLINE IS TO BE FITTED TO A SECOND SET OF DATA
C                THAT HAS THE SAME SET OF ABSCISSAS AS A PREVIOUS SET,
C                AND IF THE CONTENTS OF W HAVE NOT BEEN CHANGED SINCE
C                THAT PREVIOUS FIT WAS COMPUTED, THEN ISX MAY BE
C                SET TO ONE FOR FASTER EXECUTION.
C         A1,B1,AN,BN - SPECIFY THE END CONDITIONS FOR THE SPLINE WHICH
C                ARE EXPRESSED AS CONSTRAINTS ON THE SECOND DERIVATIVE
C                OF THE SPLINE AT THE END POINTS (SEE YPP).
C                THE END CONDITION CONSTRAINTS ARE
C                        YPP(1) = A1*YPP(2) + B1
C                AND
C                        YPP(N) = AN*YPP(N-1) + BN
C                WHERE
C                        ABS(A1).LT. 1.0  AND  ABS(AN).LT. 1.0.
C
C                THE SMOOTHEST SPLINE (I.E., LEAST INTEGRAL OF SQUARE
C                OF SECOND DERIVATIVE) IS OBTAINED BY A1=B1=AN=BN=0.
C                IN THIS CASE THERE IS AN INFLECTION AT X(1) AND X(N).
C                IF THE DATA IS TO BE EXTRAPOLATED (SAY, BY USING SPLINT
C                TO EVALUATE THE SPLINE OUTSIDE THE RANGE X(1) TO X(N)),
C                THEN TAKING A1=AN=0.5 AND B1=BN=0 MAY YIELD BETTER
C                RESULTS.  IN THIS CASE THERE IS AN INFLECTION
C                AT X(1) - (X(2)-X(1)) AND AT X(N) + (X(N)-X(N-1)).
C                IN THE MORE GENERAL CASE OF A1=AN=A  AND B1=BN=0,
C                THERE IS AN INFLECTION AT X(1) - (X(2)-X(1))*A/(1.0-A)
C                AND AT X(N) + (X(N)-X(N-1))*A/(1.0-A).
C
C                A SPLINE THAT HAS A GIVEN FIRST DERIVATIVE YP1 AT X(1)
C                AND YPN AT Y(N) MAY BE DEFINED BY USING THE
C                FOLLOWING CONDITIONS.
C
C                A1=-0.5
C
C                B1= 3.0*((Y(2)-Y(1))/(X(2)-X(1))-YP1)/(X(2)-X(1))
C
C                AN=-0.5
C
C                BN=-3.0*((Y(N)-Y(N-1))/(X(N)-X(N-1))-YPN)/(X(N)-X(N-1))
C
C       --OUTPUT--
C
C         YP   - ARRAY OF FIRST DERIVATIVES OF SPLINE (AT THE X(I))
C         YPP  - ARRAY OF SECOND DERIVATIVES OF SPLINE (AT THE X(I))
C         IERR - A STATUS CODE
C              --NORMAL CODE
C                 0 MEANS THAT THE REQUESTED SPLINE WAS COMPUTED.
C              --ABNORMAL CODES
C                 1 MEANS THAT ABS(A1) OR ABS(AN) WAS .GE. 1.
C                 2 MEANS THAT N, THE NUMBER OF POINTS, WAS .LT. 4.
C                 3 MEANS THE ABSCISSAS WERE NOT STRICTLY INCREASING.
C
C       --WORK--
C
C         W    - ARRAY OF WORKING STORAGE DIMENSIONED AT LEAST 3N.
C
      REAL X(N), Y(N), YP(N), YPP(N), W(N,3)
C
      IF (ABS(A1) .GE. 1.0 .OR. ABS(AN) .GE. 1.0) GO TO 100
      IF (N .LT. 4) GO TO 200
      NM1 = N - 1
      NM2 = N - 2
      IF (ISX .GT. 0) GO TO 40
      DO 10 I = 2,N
         IF (X(I) .LE. X(I-1)) GO TO 300
   10 CONTINUE
C
C     DEFINE THE TRIDIAGONAL MATRIX
C
      W(1,3) = X(2) - X(1)
      DO 20 I = 2,NM1
         W(I,2) = W(I-1,3)
         W(I,3) = X(I+1) - X(I)
         W(I,1) = 2.0*(W(I,2) + W(I,3))
   20 CONTINUE
      W(1,1) = 4.0
      W(1,3) =-4.0*A1
      W(N,1) = 4.0
      W(N,2) =-4.0*AN
C
C     LU DECOMPOSITION
C
      DO 30 I = 2,N
         W(I-1,3) = W(I-1,3)/W(I-1,1)
         W(I,1)   = W(I,1) - W(I,2)*W(I-1,3)
   30 CONTINUE
C
C     DEFINE *CONSTANT* VECTOR
C
   40 YPP(1) = 4.0*B1
      DOLD = (Y(2) - Y(1))/W(2,2)
      DO 50 I = 2,NM2
         DNEW   = (Y(I+1) - Y(I))/W(I+1,2)
         YPP(I) = 6.0*(DNEW - DOLD)
         YP(I)  = DOLD
         DOLD   = DNEW
   50 CONTINUE
      DNEW = (Y(N) - Y(NM1))/(X(N) - X(NM1))
      YPP(NM1) = 6.0*(DNEW - DOLD)
      YPP(N) = 4.0*BN
      YP(NM1)= DOLD
      YP(N)  = DNEW
C
C     FORWARD SUBSTITUTION
C
      YPP(1) = YPP(1)/W(1,1)
      DO 60 I = 2,N
         YPP(I) = (YPP(I) - W(I,2)*YPP(I-1))/W(I,1)
   60 CONTINUE
C
C     BACKWARD SUBSTITUTION
C
      DO 70 J = 1,NM1
         I = N - J
         YPP(I) = YPP(I) - W(I,3)*YPP(I+1)
   70 CONTINUE
C
C     COMPUTE FIRST DERIVATIVES
C
      H = X(2) - X(1)
      YP(1) = (Y(2) - Y(1))/H - H*(2.0*YPP(1) + YPP(2))/6.0
      DO 80 I = 2,NM1
         YP(I) = YP(I) + W(I,2)*(YPP(I-1) + 2.0*YPP(I))/6.0
   80 CONTINUE
      YP(N) = YP(N) + (X(N) - X(NM1))*(YPP(NM1) + 2.0*YPP(N))/6.0
      IERR = 0
      RETURN
C
  100 IERR = 1
      RETURN
  200 IERR = 2
      RETURN
  300 IERR = 3
      RETURN
      END
      SUBROUTINE SPFIT (X, Y, WGT, M, BREAK, L, Z, A, B, C, WK, IERR)
C-----------------------------------------------------------------------
C            WEIGHTED LEAST SQUARES CUBIC SPLINE FITTING
C-----------------------------------------------------------------------
      REAL X(M), Y(M), WGT(M), BREAK(L)
      REAL Z(*), A(*), B(*), C(*), WK(*)
      REAL TEMP(20)
C---------------------
C     REAL Z(L-1), A(L-1), B(L-1), C(L-1), WK(7*L + 18)
C---------------------
      IF (L .LT. 2) GO TO 100
      N = L + 2
C
C                DEFINE THE KNOTS FOR THE B-SPLINES
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
C     OBTAIN THE B-SPLINE COEFFICIENTS OF THE LEAST SQUARES FIT
C
      LA = N + 5
      LW = LA + N
      LQ = LW + N
      CALL BSLSQ (X, Y, WGT, M, WK(1), N, 4, WK(LA),
     *            WK(LW), WK(LQ), IERR)
      IF (IERR .LT. 0) GO TO 120
      IERR = 0
C
C     OBTAIN THE COEFFICIENTS OF THE FIT IN TAYLOR SERIES FORM
C
      CALL BSPP (WK(1), WK(LA), N, 4, BREAK,
     *             WK(LQ), LM1, TEMP)
      K = LQ
      DO 20 J = 1,LM1
         Z(J) = WK(K)
         A(J) = WK(K + 1)
         B(J) = WK(K + 2)
         C(J) = WK(K + 3)
         K = K + 4
   20 CONTINUE
      RETURN
C
C                       ERROR RETURN
C
  100 IERR = 1
      RETURN
  110 IERR = 2
      RETURN
  120 IERR = 3
      RETURN
      END
      SUBROUTINE CSPFIT (X, Y, M, BREAK, L, XCON, CON, NDER, NC,
     *                   Z, A, B, C, WK, IWK, IERR)
C-----------------------------------------------------------------------
C                LEAST SQUARES CUBIC SPLINE FITTING WITH
C                  EQUALITY AND INEQUALITY CONSTRAINTS
C-----------------------------------------------------------------------
      REAL X(M), Y(M), BREAK(L)
      REAL XCON(*), CON(*)
      REAL Z(*), A(*), B(*), C(*), WK(*)
      INTEGER NDER(*), IWK(*)
C
      REAL TEMP(20)
C---------------------
C     XCON, CON, NDER ARE ARRAYS OF DIMENSION MAX(1,NC).
C     Z, A, B, C ARE ARRAYS OF DIMENSION L - 1.
C     WK AND IWK ARE ARRAYS OF DIMENSION IWK(1) AND IWK(2)
C        RESPECTIVELY. IT IS REQUIRED THAT IWK(2) .GE. 2
C        AND IWK(1) .GE. 7(L + 7) FOR ALL NC. IF NC .GE. 1
C        THEN MORE STORAGE WILL BE NEEDED.
C---------------------
      IF (L .LT. 2) GO TO 100
      N = L + 2
C
C                DEFINE THE KNOTS FOR THE B-SPLINES
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
C     OBTAIN THE B-SPLINE COEFFICIENTS OF THE LEAST SQUARES FIT
C
      K = 7*N + 35
      IF (IWK(1) .LT. K) GO TO 120
      LA = N + 5
      LW = LA + N
      IERR = 0
C
      K = LW - 1
      IWK(1) = IWK(1) - K
      CALL BFIT (WK(1), N, 4, X, Y, M, XCON, CON, NDER, NC, IERR,
     *           WK(LA), R, WK(LW), IWK)
      IWK(1) = IWK(1) + K
      IF (IERR .LT. 0 .OR. IERR .EQ. 2) RETURN
C
C     OBTAIN THE COEFFICIENTS OF THE FIT IN TAYLOR SERIES FORM
C
      CALL BSPP (WK(1), WK(LA), N, 4, BREAK,
     *             WK(LW), LM1, TEMP)
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
C                       ERROR RETURN
C
  100 IERR = -1
      RETURN
C
  110 IERR = -3
      RETURN
C
  120 IERR = -6
      IWK(1) = K
      RETURN
      END
      SUBROUTINE SCOMP (X,Y,A,B,C,N,XI,YI,NI,IERR)
C
C     ABSTRACT
C
C         SCOMP EVALUATES A CUBIC SPLINE AT THE ABSCISSAS IN XI.
C         IT IS ASSUMED THAT THE COEFFICIENTS OF THE POLYNOMIALS
C         WHICH FORM THE SPLINE ARE PROVIDED.
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
      REAL X(N), Y(N), A(N), B(N), C(N), XI(NI), YI(NI)
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
      SUBROUTINE SCOMP1 (X,Y,YP,N,XI,YI,NI,IERR)
C
C     ABSTRACT
C
C         SCOMP1 EVALUATES A CUBIC SPLINE AT THE ABSCISSAS IN XI.
C         IT IS ASSUMED THAT THE FIRST DERIVATIVES AT THE NODES
C         HAVE BEEN PROVIDED.
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
      REAL X(N), Y(N), YP(N), XI(NI), YI(NI)
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
