! Analytic checks, also run against the archived fixed-form source.
program test_callback_roots
  implicit none
  interface
    FUNCTION ZEROIN(F,AX,BX,AERR,RERR)
      IMPLICIT NONE
      REAL :: F
      EXTERNAL F
      REAL, INTENT(IN) :: AX
      REAL, INTENT(IN) :: BX
      REAL, INTENT(IN) :: AERR
      REAL, INTENT(IN) :: RERR
      REAL :: ZEROIN
    END FUNCTION ZEROIN
    FUNCTION DZERO(F,AX,BX,AERR,RERR)
      IMPLICIT NONE
      DOUBLE PRECISION :: F
      EXTERNAL F
      DOUBLE PRECISION, INTENT(IN) :: AX
      DOUBLE PRECISION, INTENT(IN) :: BX
      DOUBLE PRECISION, INTENT(IN) :: AERR
      DOUBLE PRECISION, INTENT(IN) :: RERR
      DOUBLE PRECISION :: DZERO
    END FUNCTION DZERO
    SUBROUTINE FMIN(F,A0,B0,X,W,AERR,RERR,ERROR,IND)
      IMPLICIT NONE
      REAL :: F
      EXTERNAL F
      REAL, INTENT(IN) :: A0
      REAL, INTENT(IN) :: B0
      REAL, INTENT(INOUT) :: X
      REAL, INTENT(INOUT) :: W
      REAL, INTENT(IN) :: AERR
      REAL, INTENT(IN) :: RERR
      REAL, INTENT(INOUT) :: ERROR
      INTEGER, INTENT(OUT) :: IND
    END SUBROUTINE FMIN
  end interface

  real :: x,w,error
  double precision :: xd
  integer :: ind

  x=zeroin(cubic,1.,2.,1e-6,1e-6)
  if (abs(cubic(x))>1e-5) error stop 'single root residual'
  xd=dzero(double_cubic,1d0,2d0,1d-13,1d-13)
  if (abs(double_cubic(xd))>1d-12) error stop 'double root residual'
  x=zeroin(endpoint,0.,2.,1e-6,1e-6)
  if (abs(x)>1e-6) error stop 'endpoint root'
  call fmin(parabola,-1.,4.,x,w,1e-5,1e-6,error,ind)
  if (abs(x-1.25)>2e-3 .or. abs(w)>1e-5) error stop 'scalar minimum'
  if (error<0. .or. ind<0 .or. ind>1) error stop 'minimum status'
  print '(a,3es24.15)', 'Root diagnostics: ',xd,dble(x),dble(w)
  print '(a)', 'test_callback_roots: PASS'
contains

  real function cubic(x)
    real,intent(in)::x
    cubic=x*x*x-x-2.
  end function
  double precision function double_cubic(x)
    double precision,intent(in)::x
    double_cubic=x*x*x-x-2d0
  end function
  real function endpoint(x)
    real,intent(in)::x
    endpoint=x
  end function
  real function parabola(x)
    real,intent(in)::x
    parabola=(x-1.25)**2
  end function
end program test_callback_roots
