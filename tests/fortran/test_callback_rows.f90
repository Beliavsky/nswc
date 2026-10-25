! Analytic checks, also run against the archived fixed-form source.
program test_callback_rows
  implicit none
  interface
    SUBROUTINE LE(ROWK,N,B,C,D,IP,IERR)
      IMPLICIT NONE
      INTEGER :: N
      EXTERNAL ROWK
      REAL, INTENT(IN) :: B(N)
      REAL, INTENT(INOUT) :: C(N)
      REAL, INTENT(INOUT) :: D(*)
      INTEGER, INTENT(INOUT) :: IP(*)
      INTEGER, INTENT(OUT) :: IERR
    END SUBROUTINE LE
    SUBROUTINE DPLE(ROWK,N,B,C,D,IP,IERR)
      IMPLICIT NONE
      INTEGER :: N
      EXTERNAL ROWK
      DOUBLE PRECISION, INTENT(IN) :: B(N)
      DOUBLE PRECISION, INTENT(INOUT) :: C(N)
      DOUBLE PRECISION, INTENT(INOUT) :: D(*)
      INTEGER, INTENT(INOUT) :: IP(*)
      INTEGER, INTENT(OUT) :: IERR
    END SUBROUTINE DPLE
    SUBROUTINE CLE(ROWK,N,B,C,D,IP,IERR)
      IMPLICIT NONE
      INTEGER :: N
      EXTERNAL ROWK
      COMPLEX, INTENT(IN) :: B(N)
      COMPLEX, INTENT(INOUT) :: C(N)
      COMPLEX, INTENT(INOUT) :: D(*)
      INTEGER, INTENT(INOUT) :: IP(*)
      INTEGER, INTENT(OUT) :: IERR
    END SUBROUTINE CLE
  end interface

  real :: b(3),x(3),work(20)
  double precision :: db(3),dx(3),dw(20)
  complex :: cb(3),cx(3),cw(20)
  integer :: ip(3),info

  ! Nonsymmetric matrix; the first pivot is zero, requiring interchange.
  b=[7.,8.,10.]; work=0.; x=0.; ip=0
  call le(row,3,b,x,work,ip,info)
  if (info/=0 .or. maxval(abs(x-[1.,2.,3.]))>1e-5) error stop 'row solve'
  db=dble(b); dw=0.; dx=0.; ip=0
  call dple(double_row,3,db,dx,dw,ip,info)
  if (info/=0 .or. maxval(abs(dx-[1d0,2d0,3d0]))>1d-12) error stop 'double row solve'
  cb=cmplx(b,b); cw=0.; cx=0.; ip=0
  call cle(complex_row,3,cb,cx,cw,ip,info)
  if (info/=0 .or. maxval(abs(cx-cmplx([1.,2.,3.],[1.,2.,3.])))>1e-5) error stop 'complex row solve'
  work=0.; ip=0
  call le(singular_row,3,b,x,work,ip,info)
  if (info<=0) error stop 'singular row status'
  print '(a,3es24.15)', 'Row diagnostics: ',dx
  print '(a)', 'test_callback_rows: PASS'
contains

  subroutine row(n,k,c)
    integer,intent(in)::n,k
    real,intent(out)::c(n)
    real,parameter::a(3,3)=reshape([0.,2.,1., 2.,3.,0., 1.,0.,3.],[3,3])
    c=a(k,:)
  end subroutine
  subroutine double_row(n,k,c)
    integer,intent(in)::n,k
    double precision,intent(out)::c(n)
    real::v(n)
    call row(n,k,v)
    c=dble(v)
  end subroutine
  subroutine complex_row(n,k,c)
    integer,intent(in)::n,k
    complex,intent(out)::c(n)
    real::v(n)
    call row(n,k,v)
    c=cmplx(v,0.)
  end subroutine
  subroutine singular_row(n,k,c)
    integer,intent(in)::n,k
    real,intent(out)::c(n)
    c=0.
  end subroutine
end program test_callback_rows
