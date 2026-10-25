! Analytic checks, also run against the archived fixed-form source.
program test_callback_pde
  implicit none
  interface
    SUBROUTINE SEPDE(COFX,COFY,G,EDGE,BVAL,IORD,A,B,MP1,C,D,NP1,&
      &U,KU,W,NW,IERR)
      IMPLICIT NONE
      INTEGER, INTENT(INOUT) :: NW
      INTEGER :: KU
      INTEGER, INTENT(IN) :: NP1
      EXTERNAL COFX
      EXTERNAL COFY
      REAL :: G
      EXTERNAL G
      INTEGER, INTENT(IN) :: EDGE(4)
      REAL :: BVAL
      EXTERNAL BVAL
      INTEGER :: IORD
      REAL :: A
      REAL :: B
      INTEGER :: MP1
      REAL :: C
      REAL :: D
      REAL, INTENT(INOUT) :: U(KU,NP1)
      REAL, INTENT(INOUT) :: W(NW)
      INTEGER, INTENT(INOUT) :: IERR
    END SUBROUTINE SEPDE
  end interface

  integer,parameter::ng=9
  real :: u(ng,ng),work(10000),err,x,y
  integer :: edge(4),order,nw,info,i,j

  ! Manufactured Dirichlet problem: Laplacian(u)=4, u=x**2+y**2.
  edge=0
  do order=2,4,2
    u=0.; work=0.; nw=size(work); info=0
    call sepde(coefficient,coefficient,forcing,edge,boundary,order,0.,1.,ng, &
               0.,1.,ng,u,ng,work,nw,info)
    if (info/=0) error stop 'separable PDE status'
    err=0.
    do j=1,ng
      y=real(j-1)/real(ng-1)
      do i=1,ng
        x=real(i-1)/real(ng-1)
        err=max(err,abs(u(i,j)-x*x-y*y))
      end do
    end do
    if (err>2e-5) error stop 'separable PDE solution'
    if (nw<=0 .or. nw>size(work)) error stop 'PDE workspace report'
    print '(a,i2,es24.15)', 'PDE error: ',order,err
  end do
  print '(a)', 'test_callback_pde: PASS'
contains

  subroutine coefficient(x,a,b,c)
    real,intent(in)::x
    real,intent(out)::a,b,c
    a=1.; b=0.; c=0.
  end subroutine
  real function forcing(x,y)
    real,intent(in)::x,y
    forcing=4.
  end function
  real function boundary(edge,x,y)
    integer,intent(in)::edge
    real,intent(in)::x,y
    boundary=x*x+y*y
  end function
end program test_callback_pde
