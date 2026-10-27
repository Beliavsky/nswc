pure subroutine getnp(x,y,iadj,iend,l, npts, ds,ier)
!! <!-- nswc-ford:begin GETNP -->
!! Reference for `getnp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    Given a thiessen triangulation of N nodes and an array
!!  npts containing the indices of l-1 nodes ordered by
!!  Euclidean distance from npts(1), this subroutine sets
!!  npts(l) to the index of the next node in the sequence --
!!  the node, other than npts(1),...,npts(l-1), which is
!!  closest to npts(1).  Thus, the ordered sequence of K
!!  closest nodes to n1 (including n1) may be determined by
!!  K-1 calls to getnp with npts(1) = n1 and l = 2,3,...,K
!!  FOR K .GE. 2.
!!    The algorithm uses the fact that, in a thiessen trian-
!!  gulation, the K-TH closest node to a given node n1 is A
!!  neighbor of one of the K-1 closest nodes to n1.
!!  Input parameters - x,y - Vectors of length N containing
!!                           the cartesian coordinates of the
!!                           nodes.
!!                    iadj - Set of adjacency lists of nodes
!!                           in the triangulation.
!!                    iend - Pointers to the ends of adjacency
!!                           lists for each node in the TRI-
!!                           angulation.
!!                       l - Number of nodes in the sequence
!!                           on output.  2 .LE. l .LE. N.
!!                    npts - Array of length .GE. l contain-
!!                           ing the indices of the l-1 clos-
!!                           est nodes to npts(1) in the first
!!                           l-1 LOCATIONS.
!!  iadj and iend may be created by subroutine trmesh.
!!  Input parameters other than npts are not altered by this
!!    routine.
!!  Output parameters - npts - Updated with the index of the
!!                             l-TH closest node to npts(1) in
!!                             position l unless ier = 1.
!!                        ds - Squared Euclidean distance be-
!!                             tween npts(1) and npts(l)
!!                             unless ier = 1.
!!                       ier - Error indicator
!!                             ier = 0 If no errors were EN-
!!                                     countered.
!!                             ier = 1 If l is out of range.
!!  Modules referenced by getnp - None
!!  intrinsic function called by getnp - IABS
!!
!!  Local parameters -
!!  lm1 =     l - 1
!!  n1 =      npts(1)
!!  i =       npts index and do-loop index
!!  ni =      npts(i)
!!  np =      Candidate for npts(l)
!!  indf =    iadj index of the first neighbor of ni
!!  indl =    iadj index of the last neighbor of ni
!!  indx =    iadj index in the range indf,...,indl
!!  nb =      Neighbor of ni and candidate for np
!!  x1,y1 =   Coordinates of n1
!!  dnp,dnb = Squared distances from n1 to np and nb,
!!              respectively
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(*)
integer, intent(in) :: l
integer, intent(inout) :: npts(l), ier
real, intent(in) :: x(*), y(*)
real, intent(inout) :: ds
!     beginning of local variable declarations
integer :: lm1, n1, i, ni, np, indf, indl, indx, nb
real :: x1, y1, dnp, dnb
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given a thiessen triangulation of N nodes and an array
! npts containing the indices of l-1 nodes ordered by
! Euclidean distance from npts(1), this subroutine sets
! npts(l) to the index of the next node in the sequence --
! the node, other than npts(1),...,npts(l-1), which is
! closest to npts(1).  Thus, the ordered sequence of K
! closest nodes to n1 (including n1) may be determined by
! K-1 calls to getnp with npts(1) = n1 and l = 2,3,...,K
! FOR K .GE. 2.
!   The algorithm uses the fact that, in a thiessen trian-
! gulation, the K-TH closest node to a given node n1 is A
! neighbor of one of the K-1 closest nodes to n1.
! Input parameters - x,y - Vectors of length N containing
!                          the cartesian coordinates of the
!                          nodes.
!                   iadj - Set of adjacency lists of nodes
!                          in the triangulation.
!                   iend - Pointers to the ends of adjacency
!                          lists for each node in the TRI-
!                          angulation.
!                      l - Number of nodes in the sequence
!                          on output.  2 .LE. l .LE. N.
!                   npts - Array of length .GE. l contain-
!                          ing the indices of the l-1 clos-
!                          est nodes to npts(1) in the first
!                          l-1 LOCATIONS.
! iadj and iend may be created by subroutine trmesh.
! Input parameters other than npts are not altered by this
!   routine.
! Output parameters - npts - Updated with the index of the
!                            l-TH closest node to npts(1) in
!                            position l unless ier = 1.
!                       ds - Squared Euclidean distance be-
!                            tween npts(1) and npts(l)
!                            unless ier = 1.
!                      ier - Error indicator
!                            ier = 0 If no errors were EN-
!                                    countered.
!                            ier = 1 If l is out of range.
! Modules referenced by getnp - None
! intrinsic function called by getnp - IABS
!***********************************************************
! Local parameters -
! lm1 =     l - 1
! n1 =      npts(1)
! i =       npts index and do-loop index
! ni =      npts(i)
! np =      Candidate for npts(l)
! indf =    iadj index of the first neighbor of ni
! indl =    iadj index of the last neighbor of ni
! indx =    iadj index in the range indf,...,indl
! nb =      Neighbor of ni and candidate for np
! x1,y1 =   Coordinates of n1
! dnp,dnb = Squared distances from n1 to np and nb,
!             respectively
lm1 = l - 1
if (lm1 < 1) go to 4
ier = 0
n1 = npts(1)
x1 = x(n1)
y1 = y(n1)
! Mark the elements of npts
do i = 1,lm1
   ni = npts(i)
   iend(ni) = -iend(ni)
end do
! Candidates for np = npts(l) are the unmarked neighbors
!   of nodes in npts.  np=0 Is a flag to set np to the
!   first candidate encountered.
np = 0
dnp = 0.
! Loop on nodes ni in npts
do i = 1,lm1
   ni = npts(i)
   indf = 1
   if (ni > 1) indf = abs(iend(ni - 1)) + 1
   indl = -iend(ni)
! Loop on neighbors nb of ni
   do indx = indf,indl
      nb = iadj(indx)
      if (nb == 0  .or.  iend(nb) < 0) go to 2
! nb is an unmarked neighbor of ni.  Replace np if nb is
!   closer to n1 or is the first candidate encountered.
      dnb = (x(nb) - x1)**2 + (y(nb) - y1)**2
      if (np /= 0  .and.  dnb >= dnp) go to 2
      np = nb
      dnp = dnb
2     continue
   end do
end do
npts(l) = np
ds = dnp
! Unmark the elements of npts
do i = 1,lm1
   ni = npts(i)
   iend(ni) = -iend(ni)
end do
return
! l is out of range
4 ier = 1
end subroutine getnp

subroutine sfval(n, x, y, z, m, xi, yi, zi, iadj, iend, &
   & zxzy, ierr)
!! <!-- nswc-ford:begin SFVAL -->
!! Reference for `sfval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                     Evaluation of the surface
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: m, n
real :: x(n), y(n)
real, intent(in) :: z(n), xi(m), yi(m)
real, intent(inout) :: zi(m)
real, intent(in) :: zxzy(2,n)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
!     beginning of local variable declarations
integer :: ist, j
!-----------------------------------------------------------------------
!                    Evaluation of the surface
!-----------------------------------------------------------------------
if (n < 3 .or. m < 1) go to 20
ist = 1
do j = 1,m
   call intrc1(n, xi(j), yi(j), x, y, z, iadj, iend, &
      & 1, zxzy, ist, zi(j), ierr)
   if (ierr < 0) go to 30
end do
ierr = 0
return
!     Error return
20 ierr = 1
return
30 ierr = 2
end subroutine sfval

subroutine sfval2(n, x, y, z, l, m, nrows, xi, yi, zi, &
   & iadj, iend, zxzy, ierr)
!! <!-- nswc-ford:begin SFVAL2 -->
!! Reference for `sfval2`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Evaluation of the surface over a grid
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ierr
integer, intent(in) :: l, m, n, nrows
real :: x(n), y(n)
real, intent(in) :: z(n), zxzy(2,n)
real, intent(in) :: xi(l), yi(m)
real, intent(inout) :: zi(nrows,m)
integer, intent(in) :: iadj(*)
integer, intent(inout) :: iend(n)
!     beginning of local variable declarations
integer :: i, ist, j
!-----------------------------------------------------------------------
!                Evaluation of the surface over a grid
!-----------------------------------------------------------------------
if (n < 3 .or. l < 1 .or. m < 1 .or. nrows < l) &
   & go to 30
ist = 1
do j = 1,m
   do i = 1,l
      call intrc1(n, xi(i), yi(j), x, y, z, iadj, iend, &
         & 1, zxzy, ist, zi(i,j), ierr)
      if (ierr < 0) go to 40
   end do
end do
ierr = 0
return
!     Error return
30 ierr = 1
return
40 ierr = 2
end subroutine sfval2

subroutine intrc1(n,px,py,x,y,z,iadj,iend,iflag, &
   & zxzy, ist, pz,ier)
!! <!-- nswc-ford:begin INTRC1 -->
!! Reference for `intrc1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    Given a triangulation of a set of points in the plane,
!!  this routine determines a piecewise cubic function F(x,y)
!!  which interpolates a set of data values and partial
!!  derivatives at the vertices.  F has continuous first
!!  derivatives over the mesh and extends beyond the mesh
!!  boundary allowing extrapolation.  Interpolation is exact
!!  for quadratic data.  The value of F at (px,py) is
!!  returned.  intrc1 is part of an interpolation package
!!  which provides routines to generate, update and plot the
!!  mesh.
!!  INPUT PARAMETERS -     n - NUMBER OF NODES IN THE MESH.
!!                             n .GE. 3.
!!                     px,py - Coordinates of a point at which
!!                             F is to be evaluated.
!!                       x,y - Vectors of coordinates of the
!!                             nodes in the mesh.
!!                         z - Vector of data values at the
!!                             nodes.
!!                      iadj - Set of adjacency lists of nodes
!!                             in the mesh.
!!                      iend - Pointers to the ends of
!!                             adjacency lists in iadj for
!!                             each node in the mesh.
!!                     iflag - Option indicator
!!                             iflag = 0 If intrc1 is to
!!                                       provide derivative
!!                                       estimates (from
!!                                       gradl1).
!!                             iflag = 1 If derivatives are
!!                                       user provided.
!!                      zxzy - 2 By n array whose columns
!!                             contain estimated partial der-
!!                             ivatives at the nodes (x par-
!!                             tials in the first row) if
!!                             iflag = 1, not used if iflag
!!                             = 0.
!!                       ist - Index of the starting node in
!!                             the search for a triangle con-
!!                             TAINING (px,py).  1 .LE. ist
!!                             .LE. n.  the output value of
!!                             ist from a previous call may
!!                             be a good choice.
!!  iadj and iend may be created by trmesh and derivative
!!    estimates may be computed by gradl1 or gradg.
!!  Input parameters other than ist are not altered by this
!!    routine.
!!  Output parameters - ist - Index of one of the vertices of
!!                            the triangle containing (px,py)
!!                            unless ier .LT. 0.
!!                       pz - Value of F at (px,py), or 0 if
!!                            ier .LT. 0.
!!                      ier - Error indicator
!!                            ier = 0 If no errors were
!!                                    encountered.
!!                            ier = 1 If no errors were EN-
!!                                    countered and extrapola-
!!                                    tion was performed.
!!                            ier = -1 IF n, iflag, OR ist IS
!!                                     out of range.
!!                            ier = -2 If the nodes are col-
!!                                     linear.
!!  Modules referenced by intrc1 - trfind, tval,
!!              (AND OPTIONALLY)   gradl1, getnp, setrm,
!!                                 srotg, srot
!!
!!  Local parameters -
!!  nn =                      Local copy of n
!!  i1,i2,i3 =                Vertices determined by trfind
!!  ierr =                    Error flag for calls to gradl1
!!                              AND tval
!!  n1,n2 =                   Endpoints of the closest bound-
!!                              ary edge to P when P is out-
!!                              side of the mesh boundary
!!  indx =                    iadj INDEX OF n1 AS A NEIGHBOR
!!                              OF n2
!!  xp,yp =                   Local copies of the coordinates
!!                              OF P=(px,py)
!!  zx1,zy1,zx2,zy2,zx3,zy3 = x and y derivatives at the
!!                              vertices of a triangle T which
!!                              contains P or at n1 and n2
!!  x1,y1,x2,y2,x3,Y3 =       x,y coordinates of the vertices
!!                              of T or of n1 and n2
!!  Z1,Z2,Z3 =                Data values at the vertices of T
!!  DUM =                     Dummy variable for call to tval
!!  DP =                      Inner product of n1-n2 and P-n2
!!  U,V =                     x,y coordinates of the vector
!!                              n2-n1
!!  XQ,YQ =                   x,y coordinates of the closest
!!                              boundary point to P when P is
!!                              outside of the mesh boundary
!!  R1,R2 =                   Barycentric coordinates of Q
!!                              with respect to the line SEG-
!!                              MENT n2-n1 CONTAINING Q
!!  A1,A2,B1,B2,C1,C2 =       Cardinal functions for EVALUAT-
!!                              ing the interpolatory surface
!!                              AT Q
!!  F1,F2 =                   Cubic factors used to compute
!!                              the cardinal functions
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: n, iadj(*)
integer, intent(inout) :: iend(n)
integer, intent(in) :: iflag
integer, intent(inout) :: ist, ier
real, intent(in) :: px, py
real :: x(n), y(n)
real, intent(in) :: z(n), zxzy(2,n)
real, intent(out) :: pz
!     beginning of local variable declarations
integer :: nn, i1, i2, i3, ierr, n1, n2, indx
real :: xp, yp, zx1, zy1, zx2, zy2, zx3, zy3, x1, y1, x2, y2, x3, &
   & y3, z1, z2, z3, dum, dp, u, v, xq, yq, r1, r2, a1, a2, b1, b2, c1, &
   & c2, f1, f2
interface
   pure elemental subroutine tval(x,y,x1,x2,x3,y1,y2,y3,z1,z2, &
      & z3,zx1,zx2,zx3,zy1,zy2,zy3,iflag,w,wx,wy,ier)
      implicit none
      real, intent(in) :: x
      real, intent(in) :: y
      real, intent(in) :: x1
      real, intent(in) :: x2
      real, intent(in) :: x3
      real, intent(in) :: y1
      real, intent(in) :: y2
      real, intent(in) :: y3
      real, intent(in) :: z1
      real, intent(in) :: z2
      real, intent(in) :: z3
      real, intent(in) :: zx1
      real, intent(in) :: zx2
      real, intent(in) :: zx3
      real, intent(in) :: zy1
      real, intent(in) :: zy2
      real, intent(in) :: zy3
      integer, intent(in) :: iflag
      real, intent(inout) :: w
      real, intent(inout) :: wx
      real, intent(inout) :: wy
      integer, intent(inout) :: ier
   end subroutine tval
end interface
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given a triangulation of a set of points in the plane,
! this routine determines a piecewise cubic function F(x,y)
! which interpolates a set of data values and partial
! derivatives at the vertices.  F has continuous first
! derivatives over the mesh and extends beyond the mesh
! boundary allowing extrapolation.  Interpolation is exact
! for quadratic data.  The value of F at (px,py) is
! returned.  intrc1 is part of an interpolation package
! which provides routines to generate, update and plot the
! mesh.
! INPUT PARAMETERS -     n - NUMBER OF NODES IN THE MESH.
!                            n .GE. 3.
!                    px,py - Coordinates of a point at which
!                            F is to be evaluated.
!                      x,y - Vectors of coordinates of the
!                            nodes in the mesh.
!                        z - Vector of data values at the
!                            nodes.
!                     iadj - Set of adjacency lists of nodes
!                            in the mesh.
!                     iend - Pointers to the ends of
!                            adjacency lists in iadj for
!                            each node in the mesh.
!                    iflag - Option indicator
!                            iflag = 0 If intrc1 is to
!                                      provide derivative
!                                      estimates (from
!                                      gradl1).
!                            iflag = 1 If derivatives are
!                                      user provided.
!                     zxzy - 2 By n array whose columns
!                            contain estimated partial der-
!                            ivatives at the nodes (x par-
!                            tials in the first row) if
!                            iflag = 1, not used if iflag
!                            = 0.
!                      ist - Index of the starting node in
!                            the search for a triangle con-
!                            TAINING (px,py).  1 .LE. ist
!                            .LE. n.  the output value of
!                            ist from a previous call may
!                            be a good choice.
! iadj and iend may be created by trmesh and derivative
!   estimates may be computed by gradl1 or gradg.
! Input parameters other than ist are not altered by this
!   routine.
! Output parameters - ist - Index of one of the vertices of
!                           the triangle containing (px,py)
!                           unless ier .LT. 0.
!                      pz - Value of F at (px,py), or 0 if
!                           ier .LT. 0.
!                     ier - Error indicator
!                           ier = 0 If no errors were
!                                   encountered.
!                           ier = 1 If no errors were EN-
!                                   countered and extrapola-
!                                   tion was performed.
!                           ier = -1 IF n, iflag, OR ist IS
!                                    out of range.
!                           ier = -2 If the nodes are col-
!                                    linear.
! Modules referenced by intrc1 - trfind, tval,
!             (AND OPTIONALLY)   gradl1, getnp, setrm,
!                                srotg, srot
!***********************************************************
! Local parameters -
! nn =                      Local copy of n
! i1,i2,i3 =                Vertices determined by trfind
! ierr =                    Error flag for calls to gradl1
!                             AND tval
! n1,n2 =                   Endpoints of the closest bound-
!                             ary edge to P when P is out-
!                             side of the mesh boundary
! indx =                    iadj INDEX OF n1 AS A NEIGHBOR
!                             OF n2
! xp,yp =                   Local copies of the coordinates
!                             OF P=(px,py)
! zx1,zy1,zx2,zy2,zx3,zy3 = x and y derivatives at the
!                             vertices of a triangle T which
!                             contains P or at n1 and n2
! x1,y1,x2,y2,x3,Y3 =       x,y coordinates of the vertices
!                             of T or of n1 and n2
! Z1,Z2,Z3 =                Data values at the vertices of T
! DUM =                     Dummy variable for call to tval
! DP =                      Inner product of n1-n2 and P-n2
! U,V =                     x,y coordinates of the vector
!                             n2-n1
! XQ,YQ =                   x,y coordinates of the closest
!                             boundary point to P when P is
!                             outside of the mesh boundary
! R1,R2 =                   Barycentric coordinates of Q
!                             with respect to the line SEG-
!                             MENT n2-n1 CONTAINING Q
! A1,A2,B1,B2,C1,C2 =       Cardinal functions for EVALUAT-
!                             ing the interpolatory surface
!                             AT Q
! F1,F2 =                   Cubic factors used to compute
!                             the cardinal functions
nn = n
pz = 0.
if (nn < 3  .or.  iflag < 0  .or.  iflag > 1 &
   & .or.  ist < 1  .or.  ist > nn) go to 11
xp = px
yp = py
! Find a triangle containing P if P is within the mesh
!   boundary
call trfind(ist,xp,yp,x,y,iadj,iend, i1,i2,i3)
if (i1 == 0) go to 12
ist = i1
if (i3 == 0) go to 3
if (iflag /= 1) go to 1
! Derivatives are user provided
zx1 = zxzy(1,i1)
zx2 = zxzy(1,i2)
zx3 = zxzy(1,i3)
zy1 = zxzy(2,i1)
zy2 = zxzy(2,i2)
zy3 = zxzy(2,i3)
go to 2
! Compute derivative estimates at the vertices
1 call gradl1(nn,i1,x,y,z,iadj,iend, zx1,zy1,ierr)
call gradl1(nn,i2,x,y,z,iadj,iend, zx2,zy2,ierr)
call gradl1(nn,i3,x,y,z,iadj,iend, zx3,zy3,ierr)
! Set local parameters for call to tval
2 x1 = x(i1)
y1 = y(i1)
x2 = x(i2)
y2 = y(i2)
x3 = x(i3)
y3 = y(i3)
z1 = z(i1)
z2 = z(i2)
z3 = z(i3)
call tval(xp,yp,x1,x2,x3,y1,y2,y3,z1,z2,z3,zx1,zx2, &
   & zx3,zy1,zy2,zy3,0, pz,dum,dum,ierr)
if (ierr /= 0) go to 12
ier = 0
return
! P is outside of the mesh boundary.  Extrapolate to P by
!   passing a linear function of one variable THROUGH the
!   value and directional derivative (in the direction
!   P-Q) of the interpolatory surface (tval) at Q where
!   Q is the closest boundary point to P.
! Determine Q by traversing the boundary starting from
!   the rightmost visible node i1.
3 n2 = i1
! Set n1 to the last nonzero neighbor of n2 and compute DP
4 indx = iend(n2) - 1
n1 = iadj(indx)
x1 = x(n1)
y1 = y(n1)
x2 = x(n2)
y2 = y(n2)
dp = (x1 - x2)*(xp - x2) + (y1 - y2)*(yp - y2)
if (dp <= 0.) go to 5
if ((xp - x1)*(x2 - x1) + (yp - y1)*(y2 - y1) > 0.) go to 8
n2 = n1
go to 4
! n2 is the closest boundary point to P.  compute partial
!   derivatives at n2.
5 if (iflag /= 1) go to 6
zx2 = zxzy(1,n2)
zy2 = zxzy(2,n2)
go to 7
6 call gradl1(nn,n2,x,y,z,iadj,iend, zx2,zy2,ierr)
! Compute extrapolated value at P
7 pz = z(n2) + zx2*(xp - x2) + zy2*(yp - y2)
ier = 1
return
! The closest boundary point Q lies on n2-n1.  Compute
!   partials at n1 and n2.
8 if (iflag /= 1) go to 9
zx1 = zxzy(1,n1)
zy1 = zxzy(2,n1)
zx2 = zxzy(1,n2)
zy2 = zxzy(2,n2)
go to 10
9 call gradl1(nn,n1,x,y,z,iadj,iend, zx1,zy1,ierr)
call gradl1(nn,n2,x,y,z,iadj,iend, zx2,zy2,ierr)
! Compute Q, its barycentric coordinates, and the cardinal
!   functions for extrapolation
10 u = x2 - x1
v = y2 - y1
r1 = dp/(u**2 + v**2)
r2 = 1. - r1
xq = r1*x1 + r2*x2
yq = r1*y1 + r2*y2
f1 = r1*r1*r2
f2 = r1*r2*r2
a1 = r1 + (f1 - f2)
a2 = r2 - (f1 - f2)
b1 = u*f1
b2 = -u*f2
c1 = v*f1
c2 = -v*f2
! Compute the value of the interpolatory surface (tval)
!   AT Q
pz = a1*z(n1) + a2*z(n2) + b1*zx1 + b2*zx2 + &
   & c1*zy1 + c2*zy2
! Compute the extrapolated value at P
pz = pz + (r1*zx1 + r2*zx2)*(xp - xq) + &
   & (r1*zy1 + r2*zy2)*(yp - yq)
ier = 1
return
! n, iflag, or ist out of range
11 ier = -1
return
! Nodes are collinear
12 ier = -2
end subroutine intrc1

pure elemental subroutine tval(x,y,x1,x2,x3,y1,y2,y3,z1,z2,z3,zx1, &
   & zx2,zx3,zy1,zy2,zy3,iflag, w,wx,wy, &
   & ier)
!! <!-- nswc-ford:begin TVAL -->
!! Reference for `tval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                                                Robert Renka
!!                                        Oak Ridge Natl. Lab.
!!                                              (615) 576-5139
!!    Given function values and first partial derivatives at
!!  the three vertices of a triangle, this routine determines
!!  a function w which agrees with the given data, returning
!!  the value and (optionally) first partial derivatives of w
!!  at a point (x,y) in the triangle.  The interpolation
!!  method is exact for quadratic polynomial data.  The
!!  triangle is partitioned into three subtriangles with
!!  equal areas.  w is cubic in each subtriangle and along
!!  the edges, but has only one continuous derivative across
!!  edges.  The normal derivative of w varies linearly along
!!  each outer edge.  The values and partial derivatives of w
!!  along a triangle edge depend only on the data values at
!!  the endpoints of the edge.  Thus the method yields C-1
!!  continuity when used to interpolate over a triangular
!!  grid.  This algorithm is due to C. L. Lawson.
!!  INPUT PARAMETERS -   x,y - COORDINATES OF A POINT AT WHICH
!!                             w is to be evaluated.
!!         x1,x2,x3,y1,y2,y3 - Coordinates of the vertices of
!!                             a triangle containing (x,y).
!!                  z1,z2,z3 - Function values at the vertices
!!                             to be interpolated.
!!               zx1,ZX2,ZX3 - x-derivative values at the
!!                             vertices.
!!               ZY1,ZY2,ZY3 - y-derivative values at the
!!                             vertices.
!!                     iflag - Option indicator
!!                             iflag = 0 If only w is to be
!!                                       computed.
!!                             iflag = 1 IF w, wx, AND wy ARE
!!                                       to be returned.
!!  Input parameters are not altered by this routine.
!!  OUTPUT PARAMETERS -   w - ESTIMATED VALUE OF THE INTERP-
!!                            olatory function at (x,y) if
!!                            ier = 0.  OTHERWISE w = 0.
!!                    wx,wy - Partial derivatives of w at
!!                            (x,y) if ier = 0 And iflag = 1,
!!                            unchanged if iflag .NE. 1, zero
!!                            if ier .NE. 0 and iflag = 1.
!!                      ier - Error indicator
!!                            ier = 0 If no errors were
!!                                    encountered.
!!                            ier = 1 If the vertices of the
!!                                    triangle are collinear.
!!  Modules referenced by tval - None
!!  intrinsic function called by tval - AMIN1
!!
!!  Local parameters -
!!  i =               Do-loop index
!!  ip1,ip2,ip3 =     Permuted indices for computing RO, ROX,
!!                      and roy
!!  u(K) =            x-component of the vector representing
!!                      the side opposite vertex K
!!  v(K) =            y-component of the vector representing
!!                      the side opposite vertex K
!!  sl(K) =           Square of the length of the side
!!                      opposite vertex K
!!  area =            Twice the area of the triangle
!!  xp,yp =           x-x1, y-y1
!!  r(K) =            K-TH BARYCENTRIC COORDINATE
!!  rx(K),ry(K) =     x,y partial derivatives of r(K)
!!  PHI(K)            r(K-1)*r(K+1) -- QUADRATIC
!!  PHIX(K),PHIY(K) = x,y PARTIALS OF PHI(K)
!!  rmin =            min(r1,r2,r3)
!!  C1,C2 =           Factors for computing RO
!!  RO(K) =           Factors for computing G -- cubic
!!                      correction terms
!!  ROX(K),ROY(K) =   x,y PARTIALS OF RO(K)
!!  F(K) =            Factors for computing G, GX, and GY --
!!                      constant
!!  G(K) =            Factors for computing the cardinal
!!                      functions -- cubic
!!  GX(K),GY(K) =     x,y PARTIALS OF G(K)
!!  p(k) =            g(k) + phi(k)
!!  PX(K),PY(K) =     x,y PARTIALS OF P(K)
!!  q(k) =            g(k) - phi(k)
!!  QX(K),QY(K) =     x,y PARTIALS OF Q(K)
!!  A(K) =            Cardinal function whose coefficient is
!!                      Z(K)
!!  AX(K),AY(K) =     x,y PARTIALS OF A(K) -- CARDINAL
!!                      functions for wx and wy
!!  B(K) =            Twice the cardinal function whose
!!                      coefficient is ZX(K)
!!  BX(K),BY(K) =     x,y PARTIALS OF B(K)
!!  C(K) =            Twice the cardinal function whose
!!                      coefficient is ZY(K)
!!  CX(K),CY(K) =     x,y PARTIALS OF C(K)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: iflag
integer, intent(inout) :: ier
real, intent(in) :: x, y, x1, x2, x3, y1, y2, y3, z1, z2, z3, zx1, &
   & zx2, zx3, zy1, zy2, zy3
real, intent(inout) :: w, wx, wy
!     beginning of local variable declarations
integer :: i, ip1, ip2, ip3
real :: u(3), v(3), sl(3), area, xp, yp, r(3), rx(3), ry(3), &
   & phi(3), phix(3), phiy(3), rmin, c1, c2, ro(3), rox(3), roy(3), &
   & f(3), g(3), gx(3), gy(3), p(3), px(3), py(3), q(3), qx(3), qy(3), &
   & a(3), ax(3), ay(3), b(3), bx(3), by(3), c(3), cx(3), cy(3)
!***********************************************************
!                                               Robert Renka
!                                       Oak Ridge Natl. Lab.
!                                             (615) 576-5139
!   Given function values and first partial derivatives at
! the three vertices of a triangle, this routine determines
! a function w which agrees with the given data, returning
! the value and (optionally) first partial derivatives of w
! at a point (x,y) in the triangle.  The interpolation
! method is exact for quadratic polynomial data.  The
! triangle is partitioned into three subtriangles with
! equal areas.  w is cubic in each subtriangle and along
! the edges, but has only one continuous derivative across
! edges.  The normal derivative of w varies linearly along
! each outer edge.  The values and partial derivatives of w
! along a triangle edge depend only on the data values at
! the endpoints of the edge.  Thus the method yields C-1
! continuity when used to interpolate over a triangular
! grid.  This algorithm is due to C. L. Lawson.
! INPUT PARAMETERS -   x,y - COORDINATES OF A POINT AT WHICH
!                            w is to be evaluated.
!        x1,x2,x3,y1,y2,y3 - Coordinates of the vertices of
!                            a triangle containing (x,y).
!                 z1,z2,z3 - Function values at the vertices
!                            to be interpolated.
!              zx1,ZX2,ZX3 - x-derivative values at the
!                            vertices.
!              ZY1,ZY2,ZY3 - y-derivative values at the
!                            vertices.
!                    iflag - Option indicator
!                            iflag = 0 If only w is to be
!                                      computed.
!                            iflag = 1 IF w, wx, AND wy ARE
!                                      to be returned.
! Input parameters are not altered by this routine.
! OUTPUT PARAMETERS -   w - ESTIMATED VALUE OF THE INTERP-
!                           olatory function at (x,y) if
!                           ier = 0.  OTHERWISE w = 0.
!                   wx,wy - Partial derivatives of w at
!                           (x,y) if ier = 0 And iflag = 1,
!                           unchanged if iflag .NE. 1, zero
!                           if ier .NE. 0 and iflag = 1.
!                     ier - Error indicator
!                           ier = 0 If no errors were
!                                   encountered.
!                           ier = 1 If the vertices of the
!                                   triangle are collinear.
! Modules referenced by tval - None
! intrinsic function called by tval - AMIN1
!***********************************************************
! Local parameters -
! i =               Do-loop index
! ip1,ip2,ip3 =     Permuted indices for computing RO, ROX,
!                     and roy
! u(K) =            x-component of the vector representing
!                     the side opposite vertex K
! v(K) =            y-component of the vector representing
!                     the side opposite vertex K
! sl(K) =           Square of the length of the side
!                     opposite vertex K
! area =            Twice the area of the triangle
! xp,yp =           x-x1, y-y1
! r(K) =            K-TH BARYCENTRIC COORDINATE
! rx(K),ry(K) =     x,y partial derivatives of r(K)
! PHI(K)            r(K-1)*r(K+1) -- QUADRATIC
! PHIX(K),PHIY(K) = x,y PARTIALS OF PHI(K)
! rmin =            min(r1,r2,r3)
! C1,C2 =           Factors for computing RO
! RO(K) =           Factors for computing G -- cubic
!                     correction terms
! ROX(K),ROY(K) =   x,y PARTIALS OF RO(K)
! F(K) =            Factors for computing G, GX, and GY --
!                     constant
! G(K) =            Factors for computing the cardinal
!                     functions -- cubic
! GX(K),GY(K) =     x,y PARTIALS OF G(K)
! p(k) =            g(k) + phi(k)
! PX(K),PY(K) =     x,y PARTIALS OF P(K)
! q(k) =            g(k) - phi(k)
! QX(K),QY(K) =     x,y PARTIALS OF Q(K)
! A(K) =            Cardinal function whose coefficient is
!                     Z(K)
! AX(K),AY(K) =     x,y PARTIALS OF A(K) -- CARDINAL
!                     functions for wx and wy
! B(K) =            Twice the cardinal function whose
!                     coefficient is ZX(K)
! BX(K),BY(K) =     x,y PARTIALS OF B(K)
! C(K) =            Twice the cardinal function whose
!                     coefficient is ZY(K)
! CX(K),CY(K) =     x,y PARTIALS OF C(K)
u(1) = x3 - x2
u(2) = x1 - x3
u(3) = x2 - x1
v(1) = y3 - y2
v(2) = y1 - y3
v(3) = y2 - y1
do i = 1,3
   sl(i) = u(i)*u(i) + v(i)*v(i)
end do
! area = 3-1 x 3-2
area = u(1)*v(2) - u(2)*v(1)
if (area == 0.) go to 9
! r(1) = (2-3 x 2-(x,y))/area, r(2) = (1-(x,y) x 1-3)/area,
!   r(3) = (1-2 x 1-(x,y))/area
r(1) = (u(1)*(y - y2) - v(1)*(x - x2))/area
xp = x - x1
yp = y - y1
r(2) = (u(2)*yp - v(2)*xp)/area
r(3) = (u(3)*yp - v(3)*xp)/area
ier = 0
phi(1) = r(2)*r(3)
phi(2) = r(3)*r(1)
phi(3) = r(1)*r(2)
rmin = min(r(1),r(2),r(3))
if (rmin /= r(1)) go to 3
ip1 = 1
ip2 = 2
ip3 = 3
go to 5
3 if (rmin /= r(2)) go to 4
ip1 = 2
ip2 = 3
ip3 = 1
go to 5
4 ip1 = 3
ip2 = 1
ip3 = 2
5 c1 = rmin*rmin/2.
c2 = rmin/3.
ro(ip1) = (phi(ip1) + 5.*c1/3.)*r(ip1) - c1
ro(ip2) = c1*(r(ip3) - c2)
ro(ip3) = c1*(r(ip2) - c2)
f(1) = 3.*(sl(2) - sl(3))/sl(1)
f(2) = 3.*(sl(3) - sl(1))/sl(2)
f(3) = 3.*(sl(1) - sl(2))/sl(3)
g(1) = (r(2) - r(3))*phi(1) + f(1)*ro(1) - ro(2) + ro(3)
g(2) = (r(3) - r(1))*phi(2) + f(2)*ro(2) - ro(3) + ro(1)
g(3) = (r(1) - r(2))*phi(3) + f(3)*ro(3) - ro(1) + ro(2)
do i = 1,3
   p(i) = g(i) + phi(i)
   q(i) = g(i) - phi(i)
end do
a(1) = r(1) + g(3) - g(2)
a(2) = r(2) + g(1) - g(3)
a(3) = r(3) + g(2) - g(1)
b(1) = u(3)*p(3) + u(2)*q(2)
b(2) = u(1)*p(1) + u(3)*q(3)
b(3) = u(2)*p(2) + u(1)*q(1)
c(1) = v(3)*p(3) + v(2)*q(2)
c(2) = v(1)*p(1) + v(3)*q(3)
c(3) = v(2)*p(2) + v(1)*q(1)
! w is a linear combination of the cardinal functions
w = a(1)*z1 + a(2)*z2 + a(3)*z3 + (b(1)*zx1 + b(2)*zx2 &
   & + b(3)*zx3 + c(1)*zy1 + c(2)*zy2 + c(3)*zy3)/2.
if (iflag /= 1) return
! Compute wx and wy
do i = 1,3
   rx(i) = -v(i)/area
   ry(i) = u(i)/area
end do
phix(1) = r(2)*rx(3) + rx(2)*r(3)
phiy(1) = r(2)*ry(3) + ry(2)*r(3)
phix(2) = r(3)*rx(1) + rx(3)*r(1)
phiy(2) = r(3)*ry(1) + ry(3)*r(1)
phix(3) = r(1)*rx(2) + rx(1)*r(2)
phiy(3) = r(1)*ry(2) + ry(1)*r(2)
rox(ip1) = rx(ip1)*(phi(ip1) + 5.*c1) + &
   & r(ip1)*(phix(ip1) - rx(ip1))
roy(ip1) = ry(ip1)*(phi(ip1) + 5.*c1) + &
   & r(ip1)*(phiy(ip1) - ry(ip1))
rox(ip2) = rx(ip1)*(phi(ip2) - c1) + c1*rx(ip3)
roy(ip2) = ry(ip1)*(phi(ip2) - c1) + c1*ry(ip3)
rox(ip3) = rx(ip1)*(phi(ip3) - c1) + c1*rx(ip2)
roy(ip3) = ry(ip1)*(phi(ip3) - c1) + c1*ry(ip2)
gx(1) = (rx(2) - rx(3))*phi(1) + (r(2) - r(3))*phix(1) &
   & + f(1)*rox(1) - rox(2) + rox(3)
gy(1) = (ry(2) - ry(3))*phi(1) + (r(2) - r(3))*phiy(1) &
   & + f(1)*roy(1) - roy(2) + roy(3)
gx(2) = (rx(3) - rx(1))*phi(2) + (r(3) - r(1))*phix(2) &
   & + f(2)*rox(2) - rox(3) + rox(1)
gy(2) = (ry(3) - ry(1))*phi(2) + (r(3) - r(1))*phiy(2) &
   & + f(2)*roy(2) - roy(3) + roy(1)
gx(3) = (rx(1) - rx(2))*phi(3) + (r(1) - r(2))*phix(3) &
   & + f(3)*rox(3) - rox(1) + rox(2)
gy(3) = (ry(1) - ry(2))*phi(3) + (r(1) - r(2))*phiy(3) &
   & + f(3)*roy(3) - roy(1) + roy(2)
do i = 1,3
   px(i) = gx(i) + phix(i)
   py(i) = gy(i) + phiy(i)
   qx(i) = gx(i) - phix(i)
   qy(i) = gy(i) - phiy(i)
end do
ax(1) = rx(1) + gx(3) - gx(2)
ay(1) = ry(1) + gy(3) - gy(2)
ax(2) = rx(2) + gx(1) - gx(3)
ay(2) = ry(2) + gy(1) - gy(3)
ax(3) = rx(3) + gx(2) - gx(1)
ay(3) = ry(3) + gy(2) - gy(1)
bx(1) = u(3)*px(3) + u(2)*qx(2)
by(1) = u(3)*py(3) + u(2)*qy(2)
bx(2) = u(1)*px(1) + u(3)*qx(3)
by(2) = u(1)*py(1) + u(3)*qy(3)
bx(3) = u(2)*px(2) + u(1)*qx(1)
by(3) = u(2)*py(2) + u(1)*qy(1)
cx(1) = v(3)*px(3) + v(2)*qx(2)
cy(1) = v(3)*py(3) + v(2)*qy(2)
cx(2) = v(1)*px(1) + v(3)*qx(3)
cy(2) = v(1)*py(1) + v(3)*qy(3)
cx(3) = v(2)*px(2) + v(1)*qx(1)
cy(3) = v(2)*py(2) + v(1)*qy(1)
! wx and wy are linear combinations of the cardinal
!   functions
wx = ax(1)*z1 + ax(2)*z2 + ax(3)*z3 + (bx(1)*zx1 + &
   & bx(2)*zx2 + bx(3)*zx3 + cx(1)*zy1 + cx(2)*zy2 + &
   & cx(3)*zy3)/2.
wy = ay(1)*z1 + ay(2)*z2 + ay(3)*z3 + (by(1)*zx1 + &
   & by(2)*zx2 + by(3)*zx3 + cy(1)*zy1 + cy(2)*zy2 + &
   & cy(3)*zy3)/2.
return
! Vertices are collinear
9 ier = 1
w = 0.
if (iflag /= 1) return
wx = 0.
wy = 0.
end subroutine tval

subroutine mfit(dimen,fitdeg,nfpols,nfpts, &
   & fitcds,ncrows,fitvls,wts, &
   & resids,error,fitiwk,fitdwk, &
   & fiwkln,fdwkln,ireqd,dreqd)
!! <!-- nswc-ford:begin MFIT -->
!! Reference for `mfit`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      This subroutine constructs a least-squares  multinomial  fit  to
!!      given data using a basis of orthogonal multinomials.
!!      The data for the fit is given in the arrays fitcds, fitvls, and
!!      wts. fitcds is a matrix, each row of which contains an observa-
!!      tion point. fitvls is a singly-indexed array, each element of
!!      which contains a function VALUE corresponding to an observation
!!      point. wts is a singly-indexed array, each element of which is
!!      a nonnegative weight for the corresponding observation.
!!      The fit which is produced is a multinomial expressed in the form
!!       C  psi  (X ,...,X     ) +...+ C       psi       (X ,...,X     )
!!        1    1   1      dimen         nfpols    nfpols   1      dimen
!!      where the value of  nfpols  will be as given (if  fitdeg .LT. 0)
!!      or  as  computed  by  mfit  to give a full-degree fit (in case
!!      fitdeg  is specified .GE. 0).  The elements
!!          psi  (X ,...,X     )
!!             K   1      dimen
!!      form a basis for the multinomials which is orthogonal with
!!      respect to the weights and observation points.
!!      The extent of the fit can be specified in one of two ways.
!!          If the parameter fitdeg is set .GE. 0, then a complete basis
!!          for the multinomials of degree =  fitdeg  will be used.  (An
!!          error will be  flagged  if  this  will  require  more  basis
!!          multinomials  than  the  number  of  data  points which were
!!          given.)
!!          if the parameter  fitdeg  is .LT.  0, then  nfpols  will  be
!!          taken as the count of the number of basis multinomials to be
!!          used for a partial-degree fit.  (An error will be flagged if
!!          nfpols  .LT. 0.)
!!      variables
!!
!!       dimen  -- (INTEGER) -- (passed)
!!          the number of variables.
!!       fitdeg  - (INTEGER) -- (PASSED/RETURNED)
!!          ignored if .LT. 0.
!!          If fitdeg .GE. 0 then  fitdeg  is  checked  against  nfpts .
!!          The value of  fitdeg  will be reduced if there is a basis of
!!          multinomials, all of  degree  .LE. fitdeg ,  of  cardinality
!!          nfpts .  See  error  below.
!!       nfpols  - (INTEGER) -- (PASSED/RETURNED)
!!          ignored if  fitdeg  .GE. 0.
!!          If  fitdeg .LT. 0 then the value of nfpols will be taken  as
!!          the size of the basis of multinomials to be used in the fit.
!!          nfpols  MUST SATISFY  nfpols  .LT. nfpts  AND nfpols .GE. 1
!!          see  error  below.
!!       nfpts  --- (INTEGER) -- (passed)
!!          the number of data points to be used in the fit.
!!          nfpts  must be .GE. 1.  See  error  below.
!!       fitcds  -- (real 2-subscript array) -- (passed)
!!          fitcds (p,K) is the value of the K-TH variable at the  p-TH
!!          data point.
!!       ncrows  -- (INTEGER) -- (passed)
!!          THE ROW DIMENSION  DECLARED  FOR   fitcds   IN  THE  CALLING
!!          program.
!!       fitvls  -- (real 1-subscript array) -- (passed)
!!          fitvls (p) is the observed function VALUE of the p-TH  data
!!          point.
!!       wts  ----- (real 1-subscript array) -- (passed)
!!          wts (p) is the weight attached to the p-TH data point.
!!       resids  -- (real 1-subscript array) -- (returned)
!!          resids (p) is the difference between the fitted function at
!!          point p and  fitvls (p).
!!       error  -- (INTEGER) -- (returned)
!!        0 the desired least square multinomial fit was obtained.
!!       -1 Only the first nfpols basis polynomials were obtained.
!!          fitdeg is the degree of the fit.
!!        1 If  fitdeg  .GE. 0 but there is an interpolating multinomial
!!          of smaller degree or if fitdeg .LT. 0 and nfpols .GT. nfpts.
!!        2 IF  fitdeg  .LT. 0 AND  nfpols  .LE. 0.
!!        3 IF  nfpts  .LT. 1 AND/OR  dimen  .LT. 1.
!!        4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!!          the value returned in  ireqd , and set  DWKLEN  to the value
!!          returned in  dreqd  to resolve this problem.)
!!       fitiwk  -- (integer, 1-subscript array) -- (returned)
!!          an integer work array of length  fiwkln .  Upon return  from
!!          mfit, fitiwk contains dimension and array LENGTH information.
!!       fitdwk  -- (real 1-subscript array) -- (returned)
!!          a real array of length  fdwkln  containing the coefficients
!!          needed for computing the multinomial fit at a point.
!!       fiwkln  -- (INTEGER) -- (passed)
!!          the length of the array  fitiwk .
!!       fdwkln  -- (INTEGER) -- (passed)
!!          the length of the array  fitdwk .
!!       ireqd  -- (INTEGER) -- (returned)
!!          the length which the array  fitiwk  really needs to be.
!!       dreqd  -- (INTEGER) -- (returned)
!!          the length which the array  fitdwk  really needs to be.
!!      Note. The 20 loop depends on the scaling scheme being used. The
!!      residual scaling must be consistent with that defined by scalpm
!!      AND scaldn.
!!      mfit  calls  allot  and  gnrtp.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: nfpols, fitdeg
integer, intent(in) :: nfpts, dimen, fiwkln, fdwkln
integer, intent(inout) :: error, ireqd, dreqd
integer, intent(in) :: ncrows
integer, intent(inout) :: fitiwk(fiwkln)
real, intent(inout) :: fitdwk(fdwkln), fitcds(ncrows,dimen)
real, intent(inout) :: fitvls(nfpts), resids(nfpts)
real, intent(in) :: wts(nfpts)
!     beginning of local variable declarations
integer :: indstt, p, dimp1, newstt, maxstt, alfstt, psistt, cstt, ssqstt, psiwid, alfl
real :: scale
!     ***************
!     Purpose
!     -------
!     This subroutine constructs a least-squares  multinomial  fit  to
!     given data using a basis of orthogonal multinomials.
!     The data for the fit is given in the arrays fitcds, fitvls, and
!     wts. fitcds is a matrix, each row of which contains an observa-
!     tion point. fitvls is a singly-indexed array, each element of
!     which contains a function VALUE corresponding to an observation
!     point. wts is a singly-indexed array, each element of which is
!     a nonnegative weight for the corresponding observation.
!     The fit which is produced is a multinomial expressed in the form
!      C  psi  (X ,...,X     ) +...+ C       psi       (X ,...,X     )
!       1    1   1      dimen         nfpols    nfpols   1      dimen
!     where the value of  nfpols  will be as given (if  fitdeg .LT. 0)
!     or  as  computed  by  mfit  to give a full-degree fit (in case
!     fitdeg  is specified .GE. 0).  The elements
!         psi  (X ,...,X     )
!            K   1      dimen
!     form a basis for the multinomials which is orthogonal with
!     respect to the weights and observation points.
!     The extent of the fit can be specified in one of two ways.
!         If the parameter fitdeg is set .GE. 0, then a complete basis
!         for the multinomials of degree =  fitdeg  will be used.  (An
!         error will be  flagged  if  this  will  require  more  basis
!         multinomials  than  the  number  of  data  points which were
!         given.)
!         if the parameter  fitdeg  is .LT.  0, then  nfpols  will  be
!         taken as the count of the number of basis multinomials to be
!         used for a partial-degree fit.  (An error will be flagged if
!         nfpols  .LT. 0.)
!     variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      fitdeg  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if .LT. 0.
!         If fitdeg .GE. 0 then  fitdeg  is  checked  against  nfpts .
!         The value of  fitdeg  will be reduced if there is a basis of
!         multinomials, all of  degree  .LE. fitdeg ,  of  cardinality
!         nfpts .  See  error  below.
!      nfpols  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if  fitdeg  .GE. 0.
!         If  fitdeg .LT. 0 then the value of nfpols will be taken  as
!         the size of the basis of multinomials to be used in the fit.
!         nfpols  MUST SATISFY  nfpols  .LT. nfpts  AND nfpols .GE. 1
!         see  error  below.
!      nfpts  --- (INTEGER) -- (passed)
!         the number of data points to be used in the fit.
!         nfpts  must be .GE. 1.  See  error  below.
!      fitcds  -- (real 2-subscript array) -- (passed)
!         fitcds (p,K) is the value of the K-TH variable at the  p-TH
!         data point.
!      ncrows  -- (INTEGER) -- (passed)
!         THE ROW DIMENSION  DECLARED  FOR   fitcds   IN  THE  CALLING
!         program.
!      fitvls  -- (real 1-subscript array) -- (passed)
!         fitvls (p) is the observed function VALUE of the p-TH  data
!         point.
!      wts  ----- (real 1-subscript array) -- (passed)
!         wts (p) is the weight attached to the p-TH data point.
!      resids  -- (real 1-subscript array) -- (returned)
!         resids (p) is the difference between the fitted function at
!         point p and  fitvls (p).
!      error  -- (INTEGER) -- (returned)
!       0 the desired least square multinomial fit was obtained.
!      -1 Only the first nfpols basis polynomials were obtained.
!         fitdeg is the degree of the fit.
!       1 If  fitdeg  .GE. 0 but there is an interpolating multinomial
!         of smaller degree or if fitdeg .LT. 0 and nfpols .GT. nfpts.
!       2 IF  fitdeg  .LT. 0 AND  nfpols  .LE. 0.
!       3 IF  nfpts  .LT. 1 AND/OR  dimen  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         the value returned in  ireqd , and set  DWKLEN  to the value
!         returned in  dreqd  to resolve this problem.)
!      fitiwk  -- (integer, 1-subscript array) -- (returned)
!         an integer work array of length  fiwkln .  Upon return  from
!         mfit, fitiwk contains dimension and array LENGTH information.
!      fitdwk  -- (real 1-subscript array) -- (returned)
!         a real array of length  fdwkln  containing the coefficients
!         needed for computing the multinomial fit at a point.
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitdwk .
!      ireqd  -- (INTEGER) -- (returned)
!         the length which the array  fitiwk  really needs to be.
!      dreqd  -- (INTEGER) -- (returned)
!         the length which the array  fitdwk  really needs to be.
!     Note. The 20 loop depends on the scaling scheme being used. The
!     residual scaling must be consistent with that defined by scalpm
!     AND scaldn.
!     mfit  calls  allot  and  gnrtp.
!     ****************
dimp1 = dimen + 1
!     ***************
call allot(fitdeg,nfpols,nfpts,dimen,fitiwk,fiwkln,ireqd,dreqd, &
   & error)
if (error >= 2) return
if (fdwkln >= dreqd) go to 10
error = 4
return
10 continue
psiwid = fitiwk(3)
alfl = fitiwk(4)
indstt = 1
newstt = 4 * nfpols + indstt
maxstt = 1
alfstt = maxstt + dimp1
cstt = alfstt + alfl
ssqstt = cstt + nfpols
psistt = ssqstt + nfpols
!     ***************
call gnrtp(fitdeg,fitdwk(alfstt), &
   & fitdwk(psistt),fitiwk(indstt), &
   & fitiwk(newstt),fitdwk(ssqstt),fitcds, &
   & ncrows,nfpols,dimen,nfpts,fitvls,resids, &
   & fitdwk(cstt),psiwid,wts,alfl,dimp1, &
   & fitdwk(maxstt),error)
!     ***************
!     Store the number of basis polynomials actually computed
!     by the modified routine incdg called by gnrtp.
!     ***************
fitiwk(1) = nfpols
!     ***************
!     Unscale the residuals for the benefit of the user.
!     ***************
scale = fitdwk(dimen + 1)
do p = 1,nfpts
   resids(p) = resids(p) * scale
end do
end subroutine mfit

pure subroutine allot(degree,npolys,npts,dimen,iwork,iwklen, &
   & ireqd,dreqd,error)
!! <!-- nswc-ford:begin ALLOT -->
!! Reference for `allot`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!       Allot  checks for sufficiency the declared  dimensions  of  the
!!      work  arrays  used by the subroutine  mfit .  Various sizes of
!!      sub-arrays are computed and reported.
!!      This routine is called by  mfit .  It is not  called  directly
!!      by the user.
!!      THIS ROUTINE CALLS   basiz   AND   mtable   FOR  THE  SUBSTANTIVE
!!      computations.
!!      Variables
!!
!!       degree  - (PASSED/RETURNED)
!!          ignored if .LT. 0.
!!          If  degree  .GE. 0 then  degree is checked  against   npts .
!!          The value of  degree  will be reduced if there is a basis of
!!          multinomials, all of  degree .LE.  degree ,  of  cardinality
!!           npts
!!       npolys  - (PASSED/RETURNED)
!!          ignored if  degree  .GE. 0.
!!          If degree .LT. 0 then the value of npolys will be taken  as
!!          the size of the basis of multinomials to be used in the fit.
!!          npolys  MUST SATISFY npolys .LT.  npts  AND  npolys  .GE. 1
!!       npts  --- (passed)
!!          the number of data points to be used in the fit.
!!           npts  MUST BE .GE. 1.
!!       dimen  -- (passed)
!!          the number of variables.
!!       iwork  -- (returned)
!!          an integer work array of length at least
!!             if  degree  .GE. 0 then
!!                4*binomial( dimen + degree , dimen )
!!                   +( dimen )*( DEGREE )
!!             ELSE
!!                4*binomial( dimen +D,D)+( dimen )*D
!!          where D is the minimum cardinality  of  a  basis  of  degree
!!           degree  such that
!!             BINOMIAL( dimen +abs( degree ), dimen ) .GE.  npolys
!!       iwklen  - (passed)
!!          the length of  iwork
!!       ireqd  -- (returned)
!!          THE SIZE OF THE INTEGER WORK ARRAY REQUIRED BY  mfit   FOR
!!          the fit specified by the 4 input parameters.
!!       dreqd  -- (returned)
!!          the size of the double  precision  work  array  required  by
!!           mfit  for the fit specified by the 4 input parameters.
!!       error  -- (returned)
!!        0 IF  npolys ,  dimen ,   DEGREE ,   npts   AND   iwklen   ARE
!!          valid and consistent with each other.
!!        1 If  degree  .GE. 0 but there is an interpolating multinomial
!!          of smaller degree or if  degree .LT. 0 and  npolys .GT. npts
!!        2 if  degree  .LT. 0 and  npolys  .LE. 0
!!        3 IF  npts  .LT. 1 AND/OR  dimen  .LT. 1
!!        4 if  iwklen  is too small (set  iwklen  to the value returned
!!          in  ireqd  to resolve this problem)
!!      NOTE THAT  DEGREE ,  npolys ,  psiwid  AND  alfl   ARE  RETURNED
!!      in  iwork (1-4), respectively.
!!      Date last modified
!!
!!      December 10, 1984
!!
!!      basiz  computes the size of the basis (and auxiliary sizes)
!!      based primarily upon the degree, number of  fitting points,
!!      and the dimension.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ireqd, dreqd
integer, intent(inout) :: error, npolys, degree
integer, intent(in) :: dimen, npts
integer, intent(in) :: iwklen
integer, intent(inout) :: iwork(iwklen)
!     beginning of local variable declarations
integer :: alfl, newstt, psiwid, kmxbas, startj, kjp1d2, index, nplyt4
interface
   pure elemental subroutine basiz(degree,npts,dimen,npolys, &
      & error)
      implicit none
      integer, intent(inout) :: degree
      integer, intent(in) :: npts
      integer, intent(in) :: dimen
      integer, intent(inout) :: npolys
      integer, intent(out) :: error
   end subroutine basiz
   pure subroutine mtable(degree,dimen,npolys,indexs,newkj, &
      & alflp1)
      implicit none
      integer, intent(in) :: npolys
      integer, intent(in) :: dimen
      integer, intent(in) :: degree
      integer, intent(inout) :: indexs(4,npolys)
      integer, intent(inout) :: newkj(dimen,degree)
      integer, intent(out) :: alflp1
   end subroutine mtable
end interface
!     ***************
!     Purpose
!     -------
!      Allot  checks for sufficiency the declared  dimensions  of  the
!     work  arrays  used by the subroutine  mfit .  Various sizes of
!     sub-arrays are computed and reported.
!     This routine is called by  mfit .  It is not  called  directly
!     by the user.
!     THIS ROUTINE CALLS   basiz   AND   mtable   FOR  THE  SUBSTANTIVE
!     computations.
!     Variables
!     ---------
!      degree  - (PASSED/RETURNED)
!         ignored if .LT. 0.
!         If  degree  .GE. 0 then  degree is checked  against   npts .
!         The value of  degree  will be reduced if there is a basis of
!         multinomials, all of  degree .LE.  degree ,  of  cardinality
!          npts
!      npolys  - (PASSED/RETURNED)
!         ignored if  degree  .GE. 0.
!         If degree .LT. 0 then the value of npolys will be taken  as
!         the size of the basis of multinomials to be used in the fit.
!         npolys  MUST SATISFY npolys .LT.  npts  AND  npolys  .GE. 1
!      npts  --- (passed)
!         the number of data points to be used in the fit.
!          npts  MUST BE .GE. 1.
!      dimen  -- (passed)
!         the number of variables.
!      iwork  -- (returned)
!         an integer work array of length at least
!            if  degree  .GE. 0 then
!               4*binomial( dimen + degree , dimen )
!                  +( dimen )*( DEGREE )
!            ELSE
!               4*binomial( dimen +D,D)+( dimen )*D
!         where D is the minimum cardinality  of  a  basis  of  degree
!          degree  such that
!            BINOMIAL( dimen +abs( degree ), dimen ) .GE.  npolys
!      iwklen  - (passed)
!         the length of  iwork
!      ireqd  -- (returned)
!         THE SIZE OF THE INTEGER WORK ARRAY REQUIRED BY  mfit   FOR
!         the fit specified by the 4 input parameters.
!      dreqd  -- (returned)
!         the size of the double  precision  work  array  required  by
!          mfit  for the fit specified by the 4 input parameters.
!      error  -- (returned)
!       0 IF  npolys ,  dimen ,   DEGREE ,   npts   AND   iwklen   ARE
!         valid and consistent with each other.
!       1 If  degree  .GE. 0 but there is an interpolating multinomial
!         of smaller degree or if  degree .LT. 0 and  npolys .GT. npts
!       2 if  degree  .LT. 0 and  npolys  .LE. 0
!       3 IF  npts  .LT. 1 AND/OR  dimen  .LT. 1
!       4 if  iwklen  is too small (set  iwklen  to the value returned
!         in  ireqd  to resolve this problem)
!     NOTE THAT  DEGREE ,  npolys ,  psiwid  AND  alfl   ARE  RETURNED
!     in  iwork (1-4), respectively.
!     Date last modified
!     ---- ---- --------
!     December 10, 1984
!     ****************
!     ***************
!     basiz  computes the size of the basis (and auxiliary sizes)
!     based primarily upon the degree, number of  fitting points,
!     and the dimension.
!     ***************
call basiz(degree,npts,dimen,npolys,error)
if (error >= 2) return
ireqd = 4 * npolys + degree * dimen
if (iwklen >= ireqd) go to 5
error = 4
return
5 newstt = 4 * npolys + 1
!     ***************
!     Set up useful indexing arrays
!          iwork(1) ,..., iwork(newstt-1)
!     and
!          iwork(newstt ,..., iwork(newstt+dimen*degree)
!     ***************
call mtable(degree,dimen,npolys,iwork,iwork(newstt),alfl)
iwork(1) = degree
iwork(2) = npolys
!     ***************
!     Force  alfl  to be at least 1 so that dimension statements
!     using  alfl  do not bomb.
!     ***************
if (alfl > 1) alfl = alfl - 1
iwork(4) = alfl
!     ***************
!     The following is a section of code for setting up the
!     storage  management of the  psi  array.  There  is  A
!     complicated dovetailing formula used to pack information
!     into  psi  without leaving gaps.
!     ARRAY          LENGTH
!     -----          ------
!      MAXABS         dimen  + 1
!      ALPHA          alfl
!      C              npolys
!      SUMSQS         npolys
!     the number of columns in  psi ,  psiwid , is determined by
!     psiwid  =  npolys  + 1 - (the smallest M such that alpha(J,M)
!                                   is nonzero and J .GE. npolys)
!     this insures that if the user extends the basis, all the  psi
!     required will certainly be stored
!     IF degree( npolys ) .LE. 2 THEN                      (CASE 1)
!       psiwid  =  npolys
!     ELSE
!       IF K =  dimen  THEN                                (CASE 2)
!         psiwid  =  npolys
!                    -  NEWKJ( 1 , degree(npolys)-1 )  + 1
!       ELSE
!            psiwid  =  npolys
!                      + 1
!                      - (
!                         The smaller of
!                           NEWKJ(K+1,degree(npolys)-2)    (CASE 3)
!                         and
!                           INDEXS(3,npolys)               (CASE 4)
!                        )
if (degree > 2) go to 10
!     ***************
!     Case 1
!     ***************
psiwid = npolys
go to 40
10 nplyt4 = 4 * npolys
!     ***************
!     kmxbas  IS K
!                 npolys
!     ***************
kmxbas = iwork(nplyt4 - 2)
if (kmxbas /= dimen) go to 20
!     ***************
!     Case 2
!     ***************
psiwid = npolys - iwork(4 * npolys - 1)
go to 40
!     ***************
!     index =  newkj( k      + 1 , degree(npolys-2) )
!                      npolys
!     ***************
20 index = nplyt4 + (degree - 3) * dimen + kmxbas + 1
kjp1d2 = iwork(index)
!     ***************
!     startj  =  indexs(3,npolys)
!     ***************
startj = iwork(nplyt4 - 1)
if (startj > kjp1d2) go to 30
!     ***************
!     Case 4
!     ***************
psiwid = npolys - startj + 1
go to 40
!     ***************
!     Case 3
!     ***************
30 psiwid = npolys - kjp1d2 + 1
40 iwork(3) = psiwid
dreqd = 2 * npolys + dimen + 1 + npts * psiwid + alfl
end subroutine allot

pure elemental subroutine basiz(degree,npts,dimen,npolys,error)
!! <!-- nswc-ford:begin BASIZ -->
!! Reference for `basiz`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      If  degree  .GE. 0 then
!!        find the size of a basis required either to
!!        1) approximate the data with a polynomial of degree
!!           given by the parameter  degree
!!        or to
!!        2) span the space of polynomials of degree .LE. the
!!           smallest degree of polynomial which interpolates the
!!           data.
!!        In case 1  error  = 0.
!!        In case 2  error  = 1.
!!      ELSE
!!        IF  npolys  .GE. 1 THEN
!!           IF npolys .GT. npts THEN
!!              set  npolys  =  npts , find the smallest degree of A
!!              polynomial  which  interpolates  the  data,  and set
!!               error  = 1.
!!           ELSE
!!              find the largest degree  degree  of a polynomial  in
!!              a  basis of  npolys  polynomials generated according
!!              to our ordering and set  error  = 0.
!!        ELSE
!!            error  = 2
!!      this subroutine is called by  allot .  It is not  called  by
!!      the user directly.
!!      Date last modified
!!
!!      October 16, 1984
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: degree
integer, intent(in) :: npts, dimen
integer, intent(inout) :: npolys
integer, intent(out) :: error
!     beginning of local variable declarations
integer :: top, bot, i, rowlen
!     ***************
!     Purpose
!     -------
!     If  degree  .GE. 0 then
!       find the size of a basis required either to
!       1) approximate the data with a polynomial of degree
!          given by the parameter  degree
!       or to
!       2) span the space of polynomials of degree .LE. the
!          smallest degree of polynomial which interpolates the
!          data.
!       In case 1  error  = 0.
!       In case 2  error  = 1.
!     ELSE
!       IF  npolys  .GE. 1 THEN
!          IF npolys .GT. npts THEN
!             set  npolys  =  npts , find the smallest degree of A
!             polynomial  which  interpolates  the  data,  and set
!              error  = 1.
!          ELSE
!             find the largest degree  degree  of a polynomial  in
!             a  basis of  npolys  polynomials generated according
!             to our ordering and set  error  = 0.
!       ELSE
!           error  = 2
!     this subroutine is called by  allot .  It is not  called  by
!     the user directly.
!     Date last modified
!     ---- ---- --------
!     October 16, 1984
!     ****************
error = 0
if (npts >= 1 .and. dimen >= 1) go to 10
error = 3
return
10 continue
if (degree < 0) go to 30
rowlen = 1
npolys = 1
top = dimen - 1
bot = 0
if (degree < 1) go to 30
do i = 1,degree
   top = top + 1
   bot = bot + 1
   rowlen = (rowlen*top)/bot
   npolys = npolys + rowlen
end do
30 continue
if (npolys >= 1) go to 40
error = 2
return
40 continue
if (npolys < npts) go to 50
npolys = npts
error = 1
50 continue
rowlen = 1
i = 1
degree = 0
top = dimen - 1
bot = 0
60 continue
if (i >= npolys) go to 70
top = top + 1
bot = bot + 1
rowlen = (rowlen*top)/bot
i = i + rowlen
degree = degree + 1
if (i < npolys) go to 60
70 continue
end subroutine basiz

pure subroutine mtable(degree,dimen,npolys,indexs,newkj,alflp1)
!! <!-- nswc-ford:begin MTABLE -->
!! Reference for `mtable`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      Tabulate  JP  and  kj  for each  j
!!      variables
!!
!!       alflp1  -- (INTEGER) -- (passed)
!!          the length required for array  ALPHA , plus one
!!       degree  -- (INTEGER) -- (passed)
!!          the degree of the polynomial to be fitted
!!       dimen  -- (INTEGER) -- (passed)
!!          number of independent variables
!!       indexs  -- (integer, 2-subscript array) -- (returned)
!!           indexs (1, j )   IS    JP ,    indexs (2, j )   IS     kj ,
!!           indexs (3, j )  is the first nonzero recurrence coefficient
!!          in  alpha  and  indexs (4, j ) is its location in  alpha .
!!       newkj  -- (integer, 2-subscript array) -- (returned)
!!           newkj ( K , D ) IS THE FIRST MONOMIAL OF DEGREE  D   HAVING
!!           kj = k .
!!       npolys  -- (INTEGER) -- (passed)
!!          number  of  monomials  of  degree  .LE.  order  in   dimen
!!          independent variables.
!!      This subprogram can be coded (excluding the part for calculating
!!       indexs (3, j )  AND   indexs (4, j )) MENTALLY MORE EFFICIENTLY
!!      but computationally less efficiently as
!!          j = 2
!!          do 5 kj = 1,dimen
!!            newkj(kj,1) = kj + 1
!!            indexs(1,j) = 1
!!            indexs(2,j) = kj
!!            j = j + 1
!!       5  continue
!!          do 10 curdeg = 2,degree
!!            do 10 kj = 1,dimen
!!              jprime = newkj(kj,curdeg - 1)
!!              newkj(kj,curdeg) = j
!!              nwithk = comb(dimen + curdeg - kj - 1,curdeg - 1)
!!              do 10 i = 1,nwithk
!!                indexs(1,j) = jprime
!!                indexs(2,j) = kj
!!                jprime = jprime + 1
!!                j = j + 1
!!      10  continue
!!      where comb(N,kj) is N-factorial / ((N-kj)-factorial * kj-factorial
!!      here we make use of the recurrence relations
!!        COMB(dimen+curdeg-2,curdeg-1)
!!             (dimen+curdeg-2)*COMB(dimen+curdeg-3,curdeg-2)
!!
!!                               (curdeg-1)
!!      and
!!        COMB(dimen+curdeg-kj-1,curdeg-1)
!!             (dimen-kj+1)*COMB(dimen+curdeg-kj,curdeg-1)
!!
!!                          (dimen+curdeg-kj)
!!      date last modified
!!
!!      October 16, 1984
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: npolys, dimen, degree
integer, intent(out) :: alflp1
integer, intent(inout) :: indexs(4,npolys), newkj(dimen,degree)
!     beginning of local variable declarations
integer :: j, kj, curdeg, jprime, nwithk, i, curm1, ralen, dimm1, dimm2, dimp1
!     ***************
!     Purpose
!     -------
!     Tabulate  JP  and  kj  for each  j
!     variables
!     ---------
!      alflp1  -- (INTEGER) -- (passed)
!         the length required for array  ALPHA , plus one
!      degree  -- (INTEGER) -- (passed)
!         the degree of the polynomial to be fitted
!      dimen  -- (INTEGER) -- (passed)
!         number of independent variables
!      indexs  -- (integer, 2-subscript array) -- (returned)
!          indexs (1, j )   IS    JP ,    indexs (2, j )   IS     kj ,
!          indexs (3, j )  is the first nonzero recurrence coefficient
!         in  alpha  and  indexs (4, j ) is its location in  alpha .
!      newkj  -- (integer, 2-subscript array) -- (returned)
!          newkj ( K , D ) IS THE FIRST MONOMIAL OF DEGREE  D   HAVING
!          kj = k .
!      npolys  -- (INTEGER) -- (passed)
!         number  of  monomials  of  degree  .LE.  order  in   dimen
!         independent variables.
!     This subprogram can be coded (excluding the part for calculating
!      indexs (3, j )  AND   indexs (4, j )) MENTALLY MORE EFFICIENTLY
!     but computationally less efficiently as
!         j = 2
!         do 5 kj = 1,dimen
!           newkj(kj,1) = kj + 1
!           indexs(1,j) = 1
!           indexs(2,j) = kj
!           j = j + 1
!      5  continue
!         do 10 curdeg = 2,degree
!           do 10 kj = 1,dimen
!             jprime = newkj(kj,curdeg - 1)
!             newkj(kj,curdeg) = j
!             nwithk = comb(dimen + curdeg - kj - 1,curdeg - 1)
!             do 10 i = 1,nwithk
!               indexs(1,j) = jprime
!               indexs(2,j) = kj
!               jprime = jprime + 1
!               j = j + 1
!     10  continue
!     where comb(N,kj) is N-factorial / ((N-kj)-factorial * kj-factorial
!     here we make use of the recurrence relations
!       COMB(dimen+curdeg-2,curdeg-1)
!            (dimen+curdeg-2)*COMB(dimen+curdeg-3,curdeg-2)
!          = ----------------------------------------------
!                              (curdeg-1)
!     and
!       COMB(dimen+curdeg-kj-1,curdeg-1)
!            (dimen-kj+1)*COMB(dimen+curdeg-kj,curdeg-1)
!          = -------------------------------------------
!                         (dimen+curdeg-kj)
!     date last modified
!     ---- ---- --------
!     October 16, 1984
!     ****************
alflp1 = 1
!     ***************
!     Set  indexs (4,1) to 1 so that  ALFL - indexs (4,1)+1 is the
!     number of columns required for  psi  for  npolys =1  ( ALFL
!     is defined in the mainline to be  alflp1 -1 If alflp1 .GT. 1
!     and  alflp1  otherwise.
!     ***************
indexs(4,1) = 1
if (npolys == 1) return
j = 2
do kj = 1,dimen
   newkj(kj,1) = kj + 1
   indexs(1,j) = 1
   indexs(2,j) = kj
   indexs(3,j) = 1
   indexs(4,j) = alflp1
   alflp1 = alflp1 + j - 1
   if (j == npolys) return
   j = j + 1
end do
if (degree == 1) return
ralen = 1
dimm1 = dimen - 1
dimm2 = dimen - 2
dimp1 = dimen + 1
do curdeg = 2,degree
   curm1 = curdeg - 1
   ralen = (ralen * (dimm2 + curdeg)) / curm1
   nwithk = ralen
   kj = 1
20 jprime = newkj(kj,curm1)
   newkj(kj,curdeg) = j
   if (kj == dimen) go to 60
   do i = 1,nwithk
      indexs(1,j) = jprime
      indexs(2,j) = kj
!     ***************
!     CALCULATE  indexs (3, j ),  indexs (4, j )
!     ***************
      if (kj < indexs(2,jprime)) go to 30
      indexs(3,j) = indexs(1,jprime)
      go to 40
30    indexs(3,j) = newkj(1,curdeg - 1)
40    indexs(4,j) = alflp1
      alflp1 = alflp1 + j - indexs(3,j)
      if (j == npolys) return
      jprime = jprime + 1
      j = j + 1
   end do
   kj = kj + 1
   nwithk = (nwithk * (dimp1 - kj)) / (dimen + curdeg - kj)
   go to 20
60 indexs(1,j) = jprime
   indexs(2,j) = dimen
   indexs(3,j) = indexs(1,jprime)
   indexs(4,j) = alflp1
   alflp1 = alflp1 + j - indexs(3,j)
   if (j == npolys) return
   j = j + 1
end do
end subroutine mtable

subroutine gnrtp(degree,alpha,psi,indexs, &
   & newkj,sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,dimp1,maxabs,error)
!! <!-- nswc-ford:begin GNRTP -->
!! Reference for `gnrtp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      The multinomial fit is generated incrementally, a basis  element
!!      at a time.  This subroutine starts the process off by setting up
!!      the first basis element, scaling the  data,  finding  the  first
!!      coefficient,  and  initializing  the  work array z.  gnrtp  then
!!      calls  incdg  if more than one basis element is required.
!!      This subroutine is called by  mfit .  It is not called by  the
!!      user.
!!      This subroutine calls  scalpm ,  scaldn , and  incdg .
!!      Modified by A.H. Morris (NSWC)
!!
!!      Set up the scaling.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: degree
integer, intent(in) :: dimen
integer, intent(inout) :: npolys
integer, intent(in) :: npts
integer, intent(in) :: psiwid, alfl
integer, intent(inout) :: error
integer :: dimp1
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
real, intent(inout) :: psi(npts,psiwid), alpha(alfl), f(npts)
real, intent(inout) :: coord(ncrows,dimen), maxabs(dimp1)
real, intent(in) :: weight(npts)
real, intent(inout) :: z(npts), sumsqs(npolys), c(npolys)
!     beginning of local variable declarations
integer :: k, p, sttdeg, onplys
real :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine starts the process off by setting up
!     the first basis element, scaling the  data,  finding  the  first
!     coefficient,  and  initializing  the  work array z.  gnrtp  then
!     calls  incdg  if more than one basis element is required.
!     This subroutine is called by  mfit .  It is not called by  the
!     user.
!     This subroutine calls  scalpm ,  scaldn , and  incdg .
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up the scaling.
!     ***************
do k = 1,dimen
   call scalpm(coord(1,k),npts,maxabs(k))
   call scaldn(coord(1,k),npts,maxabs(k))
end do
call scalpm(f,npts,maxabs(dimp1))
call scaldn(f,npts,maxabs(dimp1))
!     ***************
!      sumsqs (1) = (1,1)
!     c  = (f,1) / (1,1)
!      1
!     ***************
runtot = 0.0
rntot1 = 0.0
do p = 1,npts
   psi(p,1) = 1.0
   rntot1 = rntot1 + weight(p)
   runtot = runtot + f(p) * weight(p)
end do
sumsqs(1) = rntot1
c(1) = runtot / rntot1
!     ***************
!     z = f - c
!              1
!     ***************
do p = 1,npts
   z(p) = f(p) - c(1)
end do
if (npolys == 1) return
sttdeg = 1
onplys = 1
call incdg(degree,alpha,psi,indexs,newkj,sumsqs, &
   & coord,ncrows,npolys,dimen,npts,f,z,c,psiwid, &
   & weight,alfl,onplys,sttdeg,error)
end subroutine gnrtp

pure subroutine incdg(degree,alpha,psi,indexs,newkj, &
   & sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,onplys,sttdeg,error)
!! <!-- nswc-ford:begin INCDG -->
!! Reference for `incdg`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      The multinomial fit is generated incrementally, a basis  element
!!      at a time.  This subroutine continues the process started off by
!!       gnrtp .
!!      This subroutine is called by  gnrtp  and not by the user.
!!      Modified by A.H. Morris (NSWC)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: error
integer, intent(in) :: onplys
integer, intent(inout) :: sttdeg
integer, intent(inout) :: degree, npolys
integer, intent(in) :: npts, dimen, psiwid, alfl
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
real, intent(inout) :: alpha(alfl)
real, intent(in) :: coord(ncrows,dimen)
real, intent(inout) :: psi(npts,psiwid)
real, intent(inout) :: sumsqs(npolys), c(npolys)
real, intent(in) :: f(npts), weight(npts)
real, intent(inout) :: z(npts)
!     beginning of local variable declarations
integer :: jprime, p, j, curdeg, kj, kjp, l, jpm1, jm1, m, start, jindex, jpindx, q, j3, j1, j1mj2, j0mj1, j1m1, starta, onpp1, &
   & index1, index2
real :: arc, runtot, rntot1, rntot2
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine continues the process started off by
!      gnrtp .
!     This subroutine is called by  gnrtp  and not by the user.
!     Modified by A.H. Morris (NSWC)
!     ****************
if (onplys >= 1 .and. sttdeg >= 1) go to 10
error = 6
return
10 if (indexs(2,onplys) == dimen) go to 20
curdeg = sttdeg
go to 30
20 curdeg = sttdeg + 1
30 onpp1 = onplys + 1
do j = onpp1,npolys
   jprime = indexs(1,j)
   jindex = j - ((j - 1) / psiwid) * psiwid
   jpindx = jprime - ((jprime - 1) / psiwid) * psiwid
   kj = indexs(2,j)
   start = indexs(3,j)
   m = start
   starta = indexs(4,j) - start
   if (curdeg == 1) go to 100
   kjp = indexs(2,jprime)
   j1 = newkj(kj,curdeg - 1)
!     ***************
!     Calculate those  alpha ( j , m ) that can be calculated from
!     previously calculated alphas.
!     ***************
   if (kj < kjp) go to 50
!     ***************
!     First calculate those between  JPP  and the end of 2 rows back.
!     Calculate  alpha ( j , JPP )
!     ***************
   index1 = indexs(4,j)
   alpha(index1) = sumsqs(jprime) / sumsqs(start)
   m = start + 1
   j3 = newkj(1,curdeg - 1) - 1
   if (m > j3) go to 50
!     ***************
!     curdeg .GT. 2 if control has passed the branches in the 3-RD
!     previous and 8-TH previous statements.
!     ***************
   j1mj2 = j1 - newkj(kj,curdeg - 2)
   do l = m,j3
      q = j1mj2 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between the 2
!     ranges calculated before using
!        alpha ( j , l ) = (X  *  psi  ,psi )  / (psi ,psi )
!                             K      JP    l         l    l
!                              j
!     ***************
   m = j3 + 1
50 if (jprime == j1) go to 100
   if (kj == 1) go to 80
   j1m1 = j1 - 1
   do l = m,j1m1
      runtot = 0.0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between
!      newkj ( kj , curdeg  - 1)  AND
!      JP  - 1.
!     ***************
80 j0mj1 = newkj(kj,curdeg) - j1
   jpm1 = jprime - 1
   do l = j1,jpm1
      q = j0mj1 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
   m = jprime
!     ***************
!     Calculate the remaining  alpha ( j , m ) from
!      alpha ( j , l ) = (X   * psi  ,psi ) / (psi ,psi )
!                          K       JP    l        l    l
!                           j
!     ***************
100 jm1 = j - 1
   do l = m,jm1
      runtot = 0.0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Now calculate the  psi (p,j),  sumsqs (j) and  c (j) using
!                          j-1
!     psi  = X  * psi   -  SUM   alpha(j,l) * psi
!        j    K      JP    l=JPP                 l
!     sumsqs  = (psi ,psi )
!           j       j    j
!     c  = (z,psi )
!      j         j
!     ***************
   jm1 = j - 1
   arc = 0.0
   rntot1 = 0.0
   rntot2 = 0.0
   do p = 1,npts
      runtot = coord(p,kj) * psi(p,jpindx)
      do l = start,jm1
         index1 = starta + l
         index2 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot - alpha(index1) * psi(p,index2)
      end do
      psi(p,jindex) = runtot
      arc = arc + psi(p,index2) * psi(p,jindex) * &
         & weight(p)
      rntot1 = rntot1 + psi(p,jindex) * psi(p,jindex) * &
         & weight(p)
      rntot2 = rntot2 + z(p) * psi(p,jindex) * weight(p)
   end do
   if (arc * arc >= sumsqs(jm1) * rntot1 * 1.e-03) &
      & go to 200
   sumsqs(j) = rntot1
   c(j) = rntot2 / rntot1
!     ***************
!     Calculate the new  z ( p ) and the new  SSRES  using
!     z = z - c  * psi
!              j      j
!     ***************
   do p = 1,npts
      z(p) = z(p) - c(j) * psi(p,jindex)
   end do
   sttdeg = curdeg
   if (kj == dimen) curdeg = curdeg + 1
end do
return
!     ***************
!     The j-TH basis multinomial cannot be computed accurately.
!     Only j - 1 Basis multinomials are generated.
!     ***************
200 error = -1
degree = sttdeg
npolys = jm1
end subroutine incdg

pure subroutine scalpm(coord,npts,maxabs)
!! <!-- nswc-ford:begin SCALPM -->
!! Reference for `scalpm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      Find scaling parameter(S) for the problem. If the scaling scheme
!!      is changed, all four of the following would have to be changed
!!      1)  scalpm  - Find the scaling parameters
!!      2)  scaldn  - Scale the problem data
!!      3)  the scaling of the residuals in  mfit
!!      4)  the scaling performed in  meval1
!!      this subroutine is called by  gnrtp .  It is not called  by  the
!!      user.
!!      The scaling which  it  defines  must  be  coordinated  with  the
!!      scaling  of residuals which is carried out toward the end of the
!!      subroutine  mfit.  The scaling must also be coordinated with the
!!      scaling performed in the 10 loop  and  at statements 40 and 50
!!      (with the scale factor maxabs(DIMP1)) in  meval1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: npts
real, intent(out) :: maxabs
real, intent(in) :: coord(npts)
!     beginning of local variable declarations
integer :: p
real :: a
!     ***************
!     Purpose
!     -------
!     Find scaling parameter(S) for the problem. If the scaling scheme
!     is changed, all four of the following would have to be changed
!     1)  scalpm  - Find the scaling parameters
!     2)  scaldn  - Scale the problem data
!     3)  the scaling of the residuals in  mfit
!     4)  the scaling performed in  meval1
!     this subroutine is called by  gnrtp .  It is not called  by  the
!     user.
!     The scaling which  it  defines  must  be  coordinated  with  the
!     scaling  of residuals which is carried out toward the end of the
!     subroutine  mfit.  The scaling must also be coordinated with the
!     scaling performed in the 10 loop  and  at statements 40 and 50
!     (with the scale factor maxabs(DIMP1)) in  meval1.
!     ****************
maxabs = 0.0
do p = 1,npts
   a = abs(coord(p))
   if (a > maxabs) maxabs = a
end do
end subroutine scalpm

pure subroutine scaldn(coord,npts,maxabs)
!! <!-- nswc-ford:begin SCALDN -->
!! Reference for `scaldn`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      Carry out the data-scaling which is defined  by  the  subroutine
!!      scalpm .
!!      This subroutine is called by  gnrtp .  It is not called  by  the
!!      user.
!!      The scaling which this routine carries out  must  be  consistent
!!      with the scaling in the subroutines mfit and meval1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: npts
real, intent(in) :: maxabs
real, intent(inout) :: coord(npts)
!     beginning of local variable declarations
integer :: p
!     ***************
!     Purpose
!     -------
!     Carry out the data-scaling which is defined  by  the  subroutine
!     scalpm .
!     This subroutine is called by  gnrtp .  It is not called  by  the
!     user.
!     The scaling which this routine carries out  must  be  consistent
!     with the scaling in the subroutines mfit and meval1.
!     ****************
if (maxabs == 0.0e+00) return
do p = 1,npts
   coord(p) = coord(p) / maxabs
end do
end subroutine scaldn

pure subroutine meval(dimen,evldeg,nepols,nepts,evlcds,nerows,evlvls, &
   & error,fitiwk,fitdwk,fiwkln,fdwkln,temp)
!! <!-- nswc-ford:begin MEVAL -->
!! Reference for `meval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      This subroutine  evaluates  the  least-squares  multinomial  fit
!!      which has been previously produced by  mfit .  Either the full
!!      multinomial as produced may be evaluated,  or  only  an  initial
!!      segment thereof.  As in the case with  mfit , it is possible
!!      (1) to specify multinomials of a full given degree, or
!!      (2) to specify  the  number  of  orthogonal  basis  elements  to
!!          achieve a partial-degree fit.
!!      In case (1), the  desired  degree  is  given  as  the  value  of
!!      evldeg   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!!      value used for  FITDEG  in  mfit ), and the parameter  nepols
!!      will  be  set  by  meval  to specify the number of basis elements
!!      required. If  evldeg  .LT.  FITDEG   is  given,  then  only  the
!!      initial  portion of the fitting multinomial (of degree  evldeg )
!!      will be evaluated.
!!      In case (2),  evldeg  is to be set negative, in which  case  the
!!      VALUE  OF   nepols  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!!      THE VALUE USED FOR   NFPOLS   IN   mfit )  WILL  BE  TAKEN  AS
!!      defining  the  initial  portion of the fitting multinomial to be
!!      evaluated.
!!      IF  nepols  =  NFPOLS  (WITH  evldeg  .LT.  0),  OR   evldeg   =
!!      FITDEG  (with   evldeg   .GT.  0),  then  the  full  multinomial
!!      generated by  mfit  will be evaluated.
!!      THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!!      (collection  of  variable  values)  given as a row of the matrix
!!       evlcds .  The  values  produced  from  the  full,  or  partial,
!!      multinomial will be placed in the array  evlvls .
!!      Variables
!!
!!       dimen  -- (INTEGER) -- (passed)
!!          the number of variables.
!!       evldeg  -- (INTEGER) -- (passed)
!!          if  evldeg  .LT. 0, then this parameter will be ignored.
!!          If  evldeg  .GE. 0, then the value of  evldeg  must  satisfy
!!          evldeg  .LE. (the  degree  of the approximating multinomial
!!          generated in  mfit ).  In this case  evldeg  will  specify
!!          the degree of the initial portion of the fitting multinomial
!!          to be evaluated.
!!       nepols  -- (INTEGER) -- (PASSED/RETURNED)
!!          if  evldeg  .GE. 0, then this parameter will be ignored.
!!          If evldeg .LT. 0, then the partial multinomial involving the
!!          FIRST   nepols  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!!          at the points given by  evlcds .  The resulting values  will
!!          be stored in  evlvls .
!!          The value of nepols must be .GE. 1 and .LE. (the size of the
!!          BASIS  GENERATED  IN   mfit ),  WHICH  WAS RETURNED AS THE
!!          value of  NFPOLS .
!!          nepols  will be changed if evldeg .GT. 0 to give the size of
!!          basis required for the multinomial of degree  evldeg .
!!       nepts  -- (INTEGER) -- (passed)
!!          the number of evaluation points.
!!       evlcds  -- (real 2-subscript array) -- (passed)
!!          evlcds (P,K) is the value of the K-TH variable at the  P-TH
!!          evaluation point.
!!       nerows  -- (INTEGER) -- (passed)
!!          the row dimension declared for evlcds in the calling program.
!!       evlvls  -- (INTEGER) -- (returned)
!!          evlvls (P) is the value of the evaluated multinomial at the
!!          P-TH evaluation point.
!!       error  -- (INTEGER) -- (returned)
!!           0 .........  if no errors
!!          -1 .........  IF  nepols  .GT.  NFPOLS  OR  nepols  .LT. 1
!!          -2 .........  IF  nepts  .LT. 1 OR  dimen  .LT. 1
!!       fitiwk  -- (integer, 1-subscript array) -- (passed)
!!          the integer work array of length  fiwkln  that was  used  in
!!           mfit .
!!       fitdwk  -- (real 2-subscript array) -- (passed)
!!          the real work array of length  fdwkln  that was
!!          used in  mfit .
!!       fiwkln  -- (INTEGER) -- (passed)
!!          the length of  fitiwk .
!!       fdwkln  -- (INTEGER) -- (passed)
!!          the length of  fitdwk .
!!       temp    -- (REAL 1-SUBSCRIPT ARRAY)
!!          a work array of length  dimen  (or longer).
!!      The subroutine  meval1  is called to do the actual evaluation.
!!      Modified by A.H. Morris (NSWC)
!!
!!      Set up index pointers to the beginning of each row of
!!      the mtable -- this sets the beginning point for each
!!      full multinomial degree.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nerows
integer, intent(in) :: fiwkln, fdwkln
integer, intent(inout) :: nepols
integer, intent(in) :: nepts, dimen
integer, intent(inout) :: error
integer, intent(in) :: evldeg
integer, intent(in) :: fitiwk(fiwkln)
real, intent(inout) :: fitdwk(fdwkln)
real, intent(in) :: evlcds(nerows,dimen)
real, intent(inout) :: evlvls(nepts), temp(dimen)
!     beginning of local variable declarations
integer :: maxstt, alfstt, cstt, gbasiz, alfl, dimp1, top, bot, curdeg, psistt
interface
   pure subroutine meval1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
      & indexs,psi,f,alfl,maxabs,x,dimp1)
      implicit none
      integer, intent(in) :: dimp1
      integer, intent(in) :: alfl
      integer, intent(in) :: npolys
      integer, intent(in) :: dimen
      integer, intent(in) :: nepts
      integer, intent(in) :: ncrows
      real, intent(in) :: coord(ncrows,dimen)
      real, intent(in) :: c(npolys)
      real, intent(in) :: alpha(alfl)
      integer, intent(in) :: indexs(4,npolys)
      real, intent(inout) :: psi(npolys)
      real, intent(inout) :: f(nepts)
      real, intent(in) :: maxabs(dimp1)
      real, intent(inout) :: x(dimen)
   end subroutine meval1
end interface
!     ***************
!     Purpose
!     -------
!     This subroutine  evaluates  the  least-squares  multinomial  fit
!     which has been previously produced by  mfit .  Either the full
!     multinomial as produced may be evaluated,  or  only  an  initial
!     segment thereof.  As in the case with  mfit , it is possible
!     (1) to specify multinomials of a full given degree, or
!     (2) to specify  the  number  of  orthogonal  basis  elements  to
!         achieve a partial-degree fit.
!     In case (1), the  desired  degree  is  given  as  the  value  of
!     evldeg   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     value used for  FITDEG  in  mfit ), and the parameter  nepols
!     will  be  set  by  meval  to specify the number of basis elements
!     required. If  evldeg  .LT.  FITDEG   is  given,  then  only  the
!     initial  portion of the fitting multinomial (of degree  evldeg )
!     will be evaluated.
!     In case (2),  evldeg  is to be set negative, in which  case  the
!     VALUE  OF   nepols  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   mfit )  WILL  BE  TAKEN  AS
!     defining  the  initial  portion of the fitting multinomial to be
!     evaluated.
!     IF  nepols  =  NFPOLS  (WITH  evldeg  .LT.  0),  OR   evldeg   =
!     FITDEG  (with   evldeg   .GT.  0),  then  the  full  multinomial
!     generated by  mfit  will be evaluated.
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (collection  of  variable  values)  given as a row of the matrix
!      evlcds .  The  values  produced  from  the  full,  or  partial,
!     multinomial will be placed in the array  evlvls .
!     Variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      evldeg  -- (INTEGER) -- (passed)
!         if  evldeg  .LT. 0, then this parameter will be ignored.
!         If  evldeg  .GE. 0, then the value of  evldeg  must  satisfy
!         evldeg  .LE. (the  degree  of the approximating multinomial
!         generated in  mfit ).  In this case  evldeg  will  specify
!         the degree of the initial portion of the fitting multinomial
!         to be evaluated.
!      nepols  -- (INTEGER) -- (PASSED/RETURNED)
!         if  evldeg  .GE. 0, then this parameter will be ignored.
!         If evldeg .LT. 0, then the partial multinomial involving the
!         FIRST   nepols  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         at the points given by  evlcds .  The resulting values  will
!         be stored in  evlvls .
!         The value of nepols must be .GE. 1 and .LE. (the size of the
!         BASIS  GENERATED  IN   mfit ),  WHICH  WAS RETURNED AS THE
!         value of  NFPOLS .
!         nepols  will be changed if evldeg .GT. 0 to give the size of
!         basis required for the multinomial of degree  evldeg .
!      nepts  -- (INTEGER) -- (passed)
!         the number of evaluation points.
!      evlcds  -- (real 2-subscript array) -- (passed)
!         evlcds (P,K) is the value of the K-TH variable at the  P-TH
!         evaluation point.
!      nerows  -- (INTEGER) -- (passed)
!         the row dimension declared for evlcds in the calling program.
!      evlvls  -- (INTEGER) -- (returned)
!         evlvls (P) is the value of the evaluated multinomial at the
!         P-TH evaluation point.
!      error  -- (INTEGER) -- (returned)
!          0 .........  if no errors
!         -1 .........  IF  nepols  .GT.  NFPOLS  OR  nepols  .LT. 1
!         -2 .........  IF  nepts  .LT. 1 OR  dimen  .LT. 1
!      fitiwk  -- (integer, 1-subscript array) -- (passed)
!         the integer work array of length  fiwkln  that was  used  in
!          mfit .
!      fitdwk  -- (real 2-subscript array) -- (passed)
!         the real work array of length  fdwkln  that was
!         used in  mfit .
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of  fitdwk .
!      temp    -- (REAL 1-SUBSCRIPT ARRAY)
!         a work array of length  dimen  (or longer).
!     The subroutine  meval1  is called to do the actual evaluation.
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up index pointers to the beginning of each row of
!     the mtable -- this sets the beginning point for each
!     full multinomial degree.
!     ***************
if (nepts < 1 .or. dimen < 1) go to 110
if (evldeg < 0) go to 40
if (evldeg == 0) go to 10
go to 20
10 nepols = 1
go to 50
20 top = 1
bot = 1
do curdeg = 1,evldeg
   top = top * (dimen + curdeg)
   bot = bot * curdeg
end do
nepols = top / bot
40 gbasiz = fitiwk(1)
if (nepols > gbasiz .or. nepols < 1) go to 100
50 error = 0
dimp1 = dimen + 1
alfl = fitiwk(4)
maxstt = 1
alfstt = dimp1 + maxstt
cstt = alfstt + alfl
psistt = cstt + fitiwk(2)
!     ***************
!     The actual evaluation is done inside  meval1.
!     ***************
call meval1(evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
   & fitdwk(alfstt),fitiwk,fitdwk(psistt), &
   & evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!     ***************
!     Error return
!     ***************
100 error = -1
return
110 error = -2
end subroutine meval

pure subroutine meval1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
   & indexs,psi,f,alfl,maxabs,x,dimp1)
!! <!-- nswc-ford:begin MEVAL1 -->
!! Reference for `meval1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      This subroutine performs the main work of evaluating the
!!      fitting multinomial (or the initial portion of it  which
!!      is requested by the setting of  NEPOLS ,  EVLDEG  in the
!!      CALL TO SUBROUTINE  meval .
!!      This subroutine is called by  meval .  It is  not  called
!!      directly by the user.
!!      The body of this subroutine FOLLOWS the explanation
!!      given in
!!           least squares fitting using
!!           orthogonal multinomials
!!      by
!!           Bartels and Jezioranski
!!      in
!!           ACM transactions on mathematical software
!!      modified by A.H. Morris (NSWC)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ncrows
integer, intent(in) :: dimen, nepts, npolys, alfl, dimp1
integer, intent(in) :: indexs(4,npolys)
real, intent(in) :: alpha(alfl), coord(ncrows,dimen)
real, intent(inout) :: psi(npolys)
real, intent(in) :: c(npolys)
real, intent(inout) :: f(nepts)
real, intent(in) :: maxabs(dimp1)
real, intent(inout) :: x(dimen)
!     beginning of local variable declarations
integer :: jm1, jprime, m, p, k, i, j, index
real :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     This subroutine performs the main work of evaluating the
!     fitting multinomial (or the initial portion of it  which
!     is requested by the setting of  NEPOLS ,  EVLDEG  in the
!     CALL TO SUBROUTINE  meval .
!     This subroutine is called by  meval .  It is  not  called
!     directly by the user.
!     The body of this subroutine FOLLOWS the explanation
!     given in
!          least squares fitting using
!          orthogonal multinomials
!     by
!          Bartels and Jezioranski
!     in
!          ACM transactions on mathematical software
!     modified by A.H. Morris (NSWC)
!     ****************
if (npolys == 1) go to 50
psi(1) = 1.0
do p = 1,nepts
!     ***************
!     Scale the coordinates of the p-TH point
!     ***************
   do k = 1,dimen
      x(k) = coord(p,k)
      if (maxabs(k) /= 0.0) x(k) = x(k) / maxabs(k)
   end do
!     ***************
!     Use the  basis function coefficients  c  and recurrence
!     coefficients  alpha  to evaluate the fitted multinomial
!     at the p-TH point.
!     ***************
   rntot1 = c(1)
   do j = 2,npolys
      k = indexs(2,j)
      jprime = indexs(1,j)
      runtot = x(k) * psi(jprime)
      i = indexs(3,j)
      jm1 = j - 1
      do m = i,jm1
         index = indexs(4,j) + m - i
         runtot = runtot - psi(m) * alpha(index)
      end do
      psi(j) = runtot
      rntot1 = rntot1 + c(j) * psi(j)
   end do
   f(p) = rntot1 * maxabs(dimp1)
end do
return
!     ***************
!     Compute the degree 0 polynomial
!     ***************
50 runtot = c(1) * maxabs(dimp1)
do p = 1,nepts
   f(p) = runtot
end do
end subroutine meval1

subroutine dmfit(dimen,fitdeg,nfpols,nfpts, &
   & fitcds,ncrows,fitvls,wts, &
   & resids,error,fitiwk,fitdwk, &
   & fiwkln,fdwkln,ireqd,dreqd)
!! <!-- nswc-ford:begin DMFIT -->
!! Reference for `dmfit`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      This subroutine constructs a least-squares  multinomial  fit  to
!!      given data using a basis of orthogonal multinomials. The computa-
!!      tion is performed in double precision.
!!      The data for the fit is given in the arrays FITCDS, fitvls, and
!!      wts. FITCDS is a matrix, each row of which contains an observa-
!!      tion point. fitvls is a singly-indexed array, each element of
!!      which contains a function VALUE corresponding to an observation
!!      point. wts is a singly-indexed array, each element of which is
!!      a nonnegative weight for the corresponding observation.
!!      The fit which is produced is a multinomial expressed in the form
!!       C  psi  (X ,...,X     ) +...+ C       psi       (X ,...,X     )
!!        1    1   1      dimen         nfpols    nfpols   1      dimen
!!      where the value of  nfpols  will be as given (if  fitdeg .LT. 0)
!!      or  as  computed  by  dmfit  to give a full-degree fit (in case
!!      fitdeg  is specified .GE. 0).  The elements
!!          psi  (X ,...,X     )
!!             K   1      dimen
!!      form a basis for the multinomials which is orthogonal with
!!      respect to the weights and observation points.
!!      The extent of the fit can be specified in one of two ways.
!!          If the parameter fitdeg is set .GE. 0, then a complete basis
!!          for the multinomials of degree =  fitdeg  will be used.  (An
!!          error will be  flagged  if  this  will  require  more  basis
!!          multinomials  than  the  number  of  data  points which were
!!          given.)
!!          if the parameter  fitdeg  is .LT.  0, then  nfpols  will  be
!!          taken as the count of the number of basis multinomials to be
!!          used for a partial-degree fit.  (An error will be flagged if
!!          nfpols  .LT. 0.)
!!      variables
!!
!!       dimen  -- (INTEGER) -- (passed)
!!          the number of variables.
!!       fitdeg  - (INTEGER) -- (PASSED/RETURNED)
!!          ignored if .LT. 0.
!!          If fitdeg .GE. 0 then  fitdeg  is  checked  against  nfpts .
!!          The value of  fitdeg  will be reduced if there is a basis of
!!          multinomials, all of  degree  .LE. fitdeg ,  of  cardinality
!!          nfpts .  See  error  below.
!!       nfpols  - (INTEGER) -- (PASSED/RETURNED)
!!          ignored if  fitdeg  .GE. 0.
!!          If  fitdeg .LT. 0 then the value of nfpols will be taken  as
!!          the size of the basis of multinomials to be used in the fit.
!!          nfpols  MUST SATISFY  nfpols  .LT. nfpts  AND nfpols .GE. 1
!!          see  error  below.
!!       nfpts  --- (INTEGER) -- (passed)
!!          the number of data points to be used in the fit.
!!          nfpts  must be .GE. 1.  See  error  below.
!!       FITCDS  -- (double precision 2-subscript array) -- (passed)
!!          FITCDS (p,K) is the value of the K-TH variable at the  p-TH
!!          data point.
!!       ncrows  -- (INTEGER) -- (passed)
!!          THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
!!          program.
!!       fitvls  -- (double precision 1-subscript array) -- (passed)
!!          fitvls (p) is the observed function VALUE of the p-TH  data
!!          point.
!!       wts  ----- (double precision 1-subscript array) -- (passed)
!!          wts (p) is the weight attached to the p-TH data point.
!!       resids  -- (double precision 1-subscript array) -- (returned)
!!          resids (p) is the difference between the fitted function at
!!          point p and  fitvls (p).
!!       error  -- (INTEGER) -- (returned)
!!        0 the desired least square multinomial fit was obtained.
!!       -1 Only the first nfpols basis polynomials were obtained.
!!          fitdeg is the degree of the fit.
!!        1 If  fitdeg  .GE. 0 but there is an interpolating multinomial
!!          of smaller degree or if fitdeg .LT. 0 and nfpols .GT. nfpts.
!!        2 IF  fitdeg  .LT. 0 AND  nfpols  .LE. 0.
!!        3 IF  nfpts  .LT. 1 AND/OR  dimen  .LT. 1.
!!        4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!!          the value returned in  ireqd , and set  DWKLEN  to the value
!!          returned in  dreqd  to resolve this problem.)
!!       fitiwk  -- (integer, 1-subscript array) -- (returned)
!!          an integer work array of length  fiwkln .  Upon return  from
!!          dmfit, fitiwk contains dimension and array LENGTH information.
!!       fitdwk  -- (double precision 1-subscript array) -- (returned)
!!          an array of length  fdwkln  containing the coefficients
!!          needed for computing the multinomial fit at a point.
!!       fiwkln  -- (INTEGER) -- (passed)
!!          the length of the array  fitiwk .
!!       fdwkln  -- (INTEGER) -- (passed)
!!          the length of the array  fitdwk .
!!       ireqd  -- (INTEGER) -- (returned)
!!          the length which the array  fitiwk  really needs to be.
!!       dreqd  -- (INTEGER) -- (returned)
!!          the length which the array  fitdwk  really needs to be.
!!      Note. The 20 loop depends on the scaling scheme being used. The
!!      residual scaling must be consistent with that defined by dscalp
!!      AND dscald.
!!      dmfit  calls  allot  and  dgnrtp.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: nfpols, fitdeg
integer, intent(in) :: nfpts, dimen, fiwkln, fdwkln
integer, intent(inout) :: error, ireqd, dreqd
integer, intent(in) :: ncrows
integer, intent(inout) :: fitiwk(fiwkln)
double precision, intent(inout) :: fitdwk(fdwkln), &
   & fitcds(ncrows,dimen)
double precision, intent(inout) :: fitvls(nfpts), resids(nfpts)
double precision, intent(in) :: wts(nfpts)
!     beginning of local variable declarations
integer :: indstt, p, dimp1, newstt, maxstt, alfstt, psistt, cstt, ssqstt, psiwid, alfl
double precision :: scale
!     ***************
!     Purpose
!     -------
!     This subroutine constructs a least-squares  multinomial  fit  to
!     given data using a basis of orthogonal multinomials. The computa-
!     tion is performed in double precision.
!     The data for the fit is given in the arrays FITCDS, fitvls, and
!     wts. FITCDS is a matrix, each row of which contains an observa-
!     tion point. fitvls is a singly-indexed array, each element of
!     which contains a function VALUE corresponding to an observation
!     point. wts is a singly-indexed array, each element of which is
!     a nonnegative weight for the corresponding observation.
!     The fit which is produced is a multinomial expressed in the form
!      C  psi  (X ,...,X     ) +...+ C       psi       (X ,...,X     )
!       1    1   1      dimen         nfpols    nfpols   1      dimen
!     where the value of  nfpols  will be as given (if  fitdeg .LT. 0)
!     or  as  computed  by  dmfit  to give a full-degree fit (in case
!     fitdeg  is specified .GE. 0).  The elements
!         psi  (X ,...,X     )
!            K   1      dimen
!     form a basis for the multinomials which is orthogonal with
!     respect to the weights and observation points.
!     The extent of the fit can be specified in one of two ways.
!         If the parameter fitdeg is set .GE. 0, then a complete basis
!         for the multinomials of degree =  fitdeg  will be used.  (An
!         error will be  flagged  if  this  will  require  more  basis
!         multinomials  than  the  number  of  data  points which were
!         given.)
!         if the parameter  fitdeg  is .LT.  0, then  nfpols  will  be
!         taken as the count of the number of basis multinomials to be
!         used for a partial-degree fit.  (An error will be flagged if
!         nfpols  .LT. 0.)
!     variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      fitdeg  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if .LT. 0.
!         If fitdeg .GE. 0 then  fitdeg  is  checked  against  nfpts .
!         The value of  fitdeg  will be reduced if there is a basis of
!         multinomials, all of  degree  .LE. fitdeg ,  of  cardinality
!         nfpts .  See  error  below.
!      nfpols  - (INTEGER) -- (PASSED/RETURNED)
!         ignored if  fitdeg  .GE. 0.
!         If  fitdeg .LT. 0 then the value of nfpols will be taken  as
!         the size of the basis of multinomials to be used in the fit.
!         nfpols  MUST SATISFY  nfpols  .LT. nfpts  AND nfpols .GE. 1
!         see  error  below.
!      nfpts  --- (INTEGER) -- (passed)
!         the number of data points to be used in the fit.
!         nfpts  must be .GE. 1.  See  error  below.
!      FITCDS  -- (double precision 2-subscript array) -- (passed)
!         FITCDS (p,K) is the value of the K-TH variable at the  p-TH
!         data point.
!      ncrows  -- (INTEGER) -- (passed)
!         THE ROW DIMENSION  DECLARED  FOR   FITCDS   IN  THE  CALLING
!         program.
!      fitvls  -- (double precision 1-subscript array) -- (passed)
!         fitvls (p) is the observed function VALUE of the p-TH  data
!         point.
!      wts  ----- (double precision 1-subscript array) -- (passed)
!         wts (p) is the weight attached to the p-TH data point.
!      resids  -- (double precision 1-subscript array) -- (returned)
!         resids (p) is the difference between the fitted function at
!         point p and  fitvls (p).
!      error  -- (INTEGER) -- (returned)
!       0 the desired least square multinomial fit was obtained.
!      -1 Only the first nfpols basis polynomials were obtained.
!         fitdeg is the degree of the fit.
!       1 If  fitdeg  .GE. 0 but there is an interpolating multinomial
!         of smaller degree or if fitdeg .LT. 0 and nfpols .GT. nfpts.
!       2 IF  fitdeg  .LT. 0 AND  nfpols  .LE. 0.
!       3 IF  nfpts  .LT. 1 AND/OR  dimen  .LT. 1.
!       4 IF  IWKLEN  AND/OR  DWKLEN  IS TOO SMALL.  (SET  IWKLEN   TO
!         the value returned in  ireqd , and set  DWKLEN  to the value
!         returned in  dreqd  to resolve this problem.)
!      fitiwk  -- (integer, 1-subscript array) -- (returned)
!         an integer work array of length  fiwkln .  Upon return  from
!         dmfit, fitiwk contains dimension and array LENGTH information.
!      fitdwk  -- (double precision 1-subscript array) -- (returned)
!         an array of length  fdwkln  containing the coefficients
!         needed for computing the multinomial fit at a point.
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of the array  fitdwk .
!      ireqd  -- (INTEGER) -- (returned)
!         the length which the array  fitiwk  really needs to be.
!      dreqd  -- (INTEGER) -- (returned)
!         the length which the array  fitdwk  really needs to be.
!     Note. The 20 loop depends on the scaling scheme being used. The
!     residual scaling must be consistent with that defined by dscalp
!     AND dscald.
!     dmfit  calls  allot  and  dgnrtp.
!     ****************
dimp1 = dimen + 1
!     ***************
call allot(fitdeg,nfpols,nfpts,dimen,fitiwk,fiwkln,ireqd,dreqd, &
   & error)
if (error >= 2) return
if (fdwkln >= dreqd) go to 10
error = 4
return
10 continue
psiwid = fitiwk(3)
alfl = fitiwk(4)
indstt = 1
newstt = 4 * nfpols + indstt
maxstt = 1
alfstt = maxstt + dimp1
cstt = alfstt + alfl
ssqstt = cstt + nfpols
psistt = ssqstt + nfpols
!     ***************
call dgnrtp(fitdeg,fitdwk(alfstt), &
   & fitdwk(psistt),fitiwk(indstt), &
   & fitiwk(newstt),fitdwk(ssqstt),fitcds, &
   & ncrows,nfpols,dimen,nfpts,fitvls,resids, &
   & fitdwk(cstt),psiwid,wts,alfl,dimp1, &
   & fitdwk(maxstt),error)
!     ***************
!     Store the number of basis polynomials actually computed
!     by the modified routine dincdg called by dgnrtp.
!     ***************
fitiwk(1) = nfpols
!     ***************
!     Unscale the residuals for the benefit of the user.
!     ***************
scale = fitdwk(dimen + 1)
do p = 1,nfpts
   resids(p) = resids(p) * scale
end do
end subroutine dmfit

subroutine dgnrtp(degree,alpha,psi,indexs, &
   & newkj,sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,dimp1,maxabs,error)
!! <!-- nswc-ford:begin DGNRTP -->
!! Reference for `dgnrtp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      The multinomial fit is generated incrementally, a basis  element
!!      at a time.  This subroutine starts the process off by setting up
!!      the first basis element, scaling the  data,  finding  the  first
!!      coefficient,  and  initializing  the  work array z.  dgnrtp then
!!      calls  dincdg  if more than one basis element is required.
!!      This subroutine is called by  dmfit .  It is not called by  the
!!      user.
!!      This subroutine calls  dscalp ,  dscald , and  dincdg .
!!      Modified by A.H. Morris (NSWC)
!!
!!      Set up the scaling.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: degree
integer, intent(in) :: dimen
integer, intent(inout) :: npolys
integer, intent(in) :: npts
integer, intent(in) :: psiwid, alfl
integer, intent(inout) :: error
integer :: dimp1
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
double precision, intent(inout) :: psi(npts,psiwid), alpha(alfl), &
   & f(npts)
double precision, intent(inout) :: coord(ncrows,dimen), &
   & maxabs(dimp1)
double precision, intent(in) :: weight(npts)
double precision, intent(inout) :: z(npts), sumsqs(npolys), &
   & c(npolys)
!     beginning of local variable declarations
integer :: k, p, sttdeg, onplys
double precision :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine starts the process off by setting up
!     the first basis element, scaling the  data,  finding  the  first
!     coefficient,  and  initializing  the  work array z.  dgnrtp then
!     calls  dincdg  if more than one basis element is required.
!     This subroutine is called by  dmfit .  It is not called by  the
!     user.
!     This subroutine calls  dscalp ,  dscald , and  dincdg .
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up the scaling.
!     ***************
do k = 1,dimen
   call dscalp(coord(1,k),npts,maxabs(k))
   call dscald(coord(1,k),npts,maxabs(k))
end do
call dscalp(f,npts,maxabs(dimp1))
call dscald(f,npts,maxabs(dimp1))
!     ***************
!      sumsqs (1) = (1,1)
!     c  = (f,1) / (1,1)
!      1
!     ***************
runtot = 0.d0
rntot1 = 0.d0
do p = 1,npts
   psi(p,1) = 1.d0
   rntot1 = rntot1 + weight(p)
   runtot = runtot + f(p) * weight(p)
end do
sumsqs(1) = rntot1
c(1) = runtot / rntot1
!     ***************
!     z = f - c
!              1
!     ***************
do p = 1,npts
   z(p) = f(p) - c(1)
end do
if (npolys == 1) return
sttdeg = 1
onplys = 1
call dincdg(degree,alpha,psi,indexs,newkj,sumsqs, &
   & coord,ncrows,npolys,dimen,npts,f,z,c,psiwid, &
   & weight,alfl,onplys,sttdeg,error)
end subroutine dgnrtp

pure subroutine dincdg(degree,alpha,psi,indexs,newkj, &
   & sumsqs,coord,ncrows,npolys, &
   & dimen,npts,f,z,c,psiwid,weight, &
   & alfl,onplys,sttdeg,error)
!! <!-- nswc-ford:begin DINCDG -->
!! Reference for `dincdg`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      The multinomial fit is generated incrementally, a basis  element
!!      at a time.  This subroutine continues the process started off by
!!       dgnrtp .
!!      This subroutine is called by  dgnrtp  and not by the user.
!!      Modified by A.H. Morris (NSWC)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ncrows
integer, intent(inout) :: error
integer, intent(in) :: onplys
integer, intent(inout) :: sttdeg
integer, intent(inout) :: degree, npolys
integer, intent(in) :: npts, dimen, psiwid, alfl
integer, intent(in) :: indexs(4,npolys), newkj(dimen,degree)
double precision, intent(inout) :: alpha(alfl)
double precision, intent(in) :: coord(ncrows,dimen)
double precision, intent(inout) :: psi(npts,psiwid)
double precision, intent(inout) :: sumsqs(npolys), c(npolys)
double precision, intent(in) :: f(npts), weight(npts)
double precision, intent(inout) :: z(npts)
!     beginning of local variable declarations
integer :: jprime, p, j, curdeg, kj, kjp, l, jpm1, jm1, m, start, jindex, jpindx, q, j3, j1, j1mj2, j0mj1, j1m1, starta, onpp1, &
   & index1, index2
double precision :: arc, runtot, rntot1, rntot2
!     ***************
!     Purpose
!     -------
!     The multinomial fit is generated incrementally, a basis  element
!     at a time.  This subroutine continues the process started off by
!      dgnrtp .
!     This subroutine is called by  dgnrtp  and not by the user.
!     Modified by A.H. Morris (NSWC)
!     ****************
if (onplys >= 1 .and. sttdeg >= 1) go to 10
error = 6
return
10 if (indexs(2,onplys) == dimen) go to 20
curdeg = sttdeg
go to 30
20 curdeg = sttdeg + 1
30 onpp1 = onplys + 1
do j = onpp1,npolys
   jprime = indexs(1,j)
   jindex = j - ((j - 1) / psiwid) * psiwid
   jpindx = jprime - ((jprime - 1) / psiwid) * psiwid
   kj = indexs(2,j)
   start = indexs(3,j)
   m = start
   starta = indexs(4,j) - start
   if (curdeg == 1) go to 100
   kjp = indexs(2,jprime)
   j1 = newkj(kj,curdeg - 1)
!     ***************
!     Calculate those  alpha ( j , m ) that can be calculated from
!     previously calculated alphas.
!     ***************
   if (kj < kjp) go to 50
!     ***************
!     First calculate those between  JPP  and the end of 2 rows back.
!     Calculate  alpha ( j , JPP )
!     ***************
   index1 = indexs(4,j)
   alpha(index1) = sumsqs(jprime) / sumsqs(start)
   m = start + 1
   j3 = newkj(1,curdeg - 1) - 1
   if (m > j3) go to 50
!     ***************
!     curdeg .GT. 2 if control has passed the branches in the 3-RD
!     previous and 8-TH previous statements.
!     ***************
   j1mj2 = j1 - newkj(kj,curdeg - 2)
   do l = m,j3
      q = j1mj2 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between the 2
!     ranges calculated before using
!        alpha ( j , l ) = (X  *  psi  ,psi )  / (psi ,psi )
!                             K      JP    l         l    l
!                              j
!     ***************
   m = j3 + 1
50 if (jprime == j1) go to 100
   if (kj == 1) go to 80
   j1m1 = j1 - 1
   do l = m,j1m1
      runtot = 0.d0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Calculate  alpha ( j , m ) for  m  between
!      newkj ( kj , curdeg  - 1)  AND
!      JP  - 1.
!     ***************
80 j0mj1 = newkj(kj,curdeg) - j1
   jpm1 = jprime - 1
   do l = j1,jpm1
      q = j0mj1 + l
      index1 = starta + l
      index2 = indexs(4,q) - indexs(3,q) + jprime
      alpha(index1) = alpha(index2) * sumsqs(jprime) / &
         & sumsqs(l)
   end do
   m = jprime
!     ***************
!     Calculate the remaining  alpha ( j , m ) from
!      alpha ( j , l ) = (X   * psi  ,psi ) / (psi ,psi )
!                          K       JP    l        l    l
!                           j
!     ***************
100 jm1 = j - 1
   do l = m,jm1
      runtot = 0.d0
      do p = 1,npts
         index1 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot + coord(p,kj) * psi(p,jpindx) * &
            & psi(p,index1) * weight(p)
      end do
      index1 = starta + l
      alpha(index1) = runtot / sumsqs(l)
   end do
!     ***************
!     Now calculate the  psi (p,j),  sumsqs (j) and  c (j) using
!                          j-1
!     psi  = X  * psi   -  SUM   alpha(j,l) * psi
!        j    K      JP    l=JPP                 l
!     sumsqs  = (psi ,psi )
!           j       j    j
!     c  = (z,psi )
!      j         j
!     ***************
   jm1 = j - 1
   arc = 0.d0
   rntot1 = 0.d0
   rntot2 = 0.d0
   do p = 1,npts
      runtot = coord(p,kj) * psi(p,jpindx)
      do l = start,jm1
         index1 = starta + l
         index2 = l - ((l - 1) / psiwid) * psiwid
         runtot = runtot - alpha(index1) * psi(p,index2)
      end do
      psi(p,jindex) = runtot
      arc = arc + psi(p,index2) * psi(p,jindex) * &
         & weight(p)
      rntot1 = rntot1 + psi(p,jindex) * psi(p,jindex) * &
         & weight(p)
      rntot2 = rntot2 + z(p) * psi(p,jindex) * weight(p)
   end do
   if (arc * arc >= sumsqs(jm1) * rntot1 * 1.d-06) &
      & go to 200
   sumsqs(j) = rntot1
   c(j) = rntot2 / rntot1
!     ***************
!     Calculate the new  z ( p ) and the new  SSRES  using
!     z = z - c  * psi
!              j      j
!     ***************
   do p = 1,npts
      z(p) = z(p) - c(j) * psi(p,jindex)
   end do
   sttdeg = curdeg
   if (kj == dimen) curdeg = curdeg + 1
end do
return
!     ***************
!     The j-TH basis multinomial cannot be computed accurately.
!     Only j - 1 Basis multinomials are generated.
!     ***************
200 error = -1
degree = sttdeg
npolys = jm1
end subroutine dincdg

pure subroutine dscalp(coord,npts,maxabs)
!! <!-- nswc-ford:begin DSCALP -->
!! Reference for `dscalp`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      Find scaling parameter(S) for the problem. If the scaling scheme
!!      is changed, all four of the following would have to be changed
!!      1)  dscalp  - Find the scaling parameters
!!      2)  dscald  - Scale the problem data
!!      3)  the scaling of the residuals in  dmfit
!!      4)  the scaling performed in  dmevl1
!!      this subroutine is called by  dgnrtp .  It is not called  by  the
!!      user.
!!      The scaling which  it  defines  must  be  coordinated  with  the
!!      scaling  of residuals which is carried out toward the end of the
!!      subroutine  dmfit.  The scaling must also be coordinated with the
!!      scaling performed in the 10 loop  and  at statements 40 and 50
!!      (with the scale factor maxabs(DIMP1)) in  dmevl1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: npts
double precision, intent(out) :: maxabs
double precision, intent(in) :: coord(npts)
!     beginning of local variable declarations
integer :: p
double precision :: a
!     ***************
!     Purpose
!     -------
!     Find scaling parameter(S) for the problem. If the scaling scheme
!     is changed, all four of the following would have to be changed
!     1)  dscalp  - Find the scaling parameters
!     2)  dscald  - Scale the problem data
!     3)  the scaling of the residuals in  dmfit
!     4)  the scaling performed in  dmevl1
!     this subroutine is called by  dgnrtp .  It is not called  by  the
!     user.
!     The scaling which  it  defines  must  be  coordinated  with  the
!     scaling  of residuals which is carried out toward the end of the
!     subroutine  dmfit.  The scaling must also be coordinated with the
!     scaling performed in the 10 loop  and  at statements 40 and 50
!     (with the scale factor maxabs(DIMP1)) in  dmevl1.
!     ****************
maxabs = 0.d0
do p = 1,npts
   a = abs(coord(p))
   if (a > maxabs) maxabs = a
end do
end subroutine dscalp

pure subroutine dscald(coord,npts,maxabs)
!! <!-- nswc-ford:begin DSCALD -->
!! Reference for `dscald`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      Carry out the data-scaling which is defined  by  the subroutine
!!      dscalp .
!!      This subroutine is called by  dgnrtp .  It is not called by the
!!      user.
!!      The scaling which this routine carries out must  be  consistent
!!      with the scaling in the subroutines dmfit and dmevl1.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: npts
double precision, intent(in) :: maxabs
double precision, intent(inout) :: coord(npts)
!     beginning of local variable declarations
integer :: p
!     ***************
!     Purpose
!     -------
!     Carry out the data-scaling which is defined  by  the subroutine
!     dscalp .
!     This subroutine is called by  dgnrtp .  It is not called by the
!     user.
!     The scaling which this routine carries out must  be  consistent
!     with the scaling in the subroutines dmfit and dmevl1.
!     ****************
if (maxabs == 0.0d+00) return
do p = 1,npts
   coord(p) = coord(p) / maxabs
end do
end subroutine dscald

pure subroutine dmeval(dimen,evldeg,nepols,nepts,evlcds,nerows,evlvls, &
   & error,fitiwk,fitdwk,fiwkln,fdwkln,temp)
!! <!-- nswc-ford:begin DMEVAL -->
!! Reference for `dmeval`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      This subroutine  evaluates  the  least-squares  multinomial  fit
!!      which has been previously produced by  dmfit .  The computation
!!      is performed in double precision. Either the full
!!      multinomial as produced may be evaluated,  or  only  an  initial
!!      segment thereof.  As in the case with  dmfit , it is possible
!!      (1) to specify multinomials of a full given degree, or
!!      (2) to specify  the  number  of  orthogonal  basis  elements  to
!!          achieve a partial-degree fit.
!!      In case (1), the  desired  degree  is  given  as  the  value  of
!!      evldeg   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!!      value used for  FITDEG  in  dmfit ), and the parameter  nepols
!!      will be set  by  dmeval  to specify the number of basis elements
!!      required. If  evldeg  .LT.  FITDEG   is  given,  then  only  the
!!      initial  portion of the fitting multinomial (of degree  evldeg )
!!      will be evaluated.
!!      In case (2),  evldeg  is to be set negative, in which  case  the
!!      VALUE  OF   nepols  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!!      THE VALUE USED FOR   NFPOLS   IN   dmfit )  WILL  BE  TAKEN  AS
!!      defining  the  initial  portion of the fitting multinomial to be
!!      evaluated.
!!      IF  nepols  =  NFPOLS  (WITH  evldeg  .LT.  0),  OR   evldeg   =
!!      FITDEG  (with   evldeg   .GT.  0),  then  the  full  multinomial
!!      generated by  dmfit  will be evaluated.
!!      THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!!      (collection  of  variable  values)  given as a row of the matrix
!!       evlcds .  The  values  produced  from  the  full,  or  partial,
!!      multinomial will be placed in the array  evlvls .
!!      Variables
!!
!!       dimen  -- (INTEGER) -- (passed)
!!          the number of variables.
!!       evldeg  -- (INTEGER) -- (passed)
!!          if  evldeg  .LT. 0, then this parameter will be ignored.
!!          If  evldeg  .GE. 0, then the value of  evldeg  must  satisfy
!!          evldeg  .LE. (the  degree  of the approximating multinomial
!!          generated in  dmfit ).  In this case  evldeg  will  specify
!!          the degree of the initial portion of the fitting multinomial
!!          to be evaluated.
!!       nepols  -- (INTEGER) -- (PASSED/RETURNED)
!!          if  evldeg  .GE. 0, then this parameter will be ignored.
!!          If evldeg .LT. 0, then the partial multinomial involving the
!!          FIRST   nepols  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!!          at the points given by  evlcds .  The resulting values  will
!!          be stored in  evlvls .
!!          The value of nepols must be .GE. 1 and .LE. (the size of the
!!          BASIS  GENERATED  IN   dmfit ),  WHICH  WAS RETURNED AS THE
!!          value of  NFPOLS .
!!          nepols  will be changed if evldeg .GT. 0 to give the size of
!!          basis required for the multinomial of degree  evldeg .
!!       nepts  -- (INTEGER) -- (passed)
!!          the number of evaluation points.
!!       evlcds  -- (double precision 2-subscript array) -- (passed)
!!          evlcds (P,K) is the value of the K-TH variable at the  P-TH
!!          evaluation point.
!!       nerows  -- (INTEGER) -- (passed)
!!          the row dimension declared for evlcds in the calling program.
!!       evlvls  -- (INTEGER) -- (returned)
!!          evlvls (P) is the value of the evaluated multinomial at the
!!          P-TH evaluation point.
!!       error  -- (INTEGER) -- (returned)
!!           0 .........  if no errors
!!          -1 .........  IF  nepols  .GT.  NFPOLS  OR  nepols  .LT. 1
!!          -2 .........  IF  nepts  .LT. 1 OR  dimen  .LT. 1
!!       fitiwk  -- (integer, 1-subscript array) -- (passed)
!!          the integer work array of length  fiwkln  that was  used  in
!!           dmfit .
!!       fitdwk  -- (double precision 2-subscript array) -- (passed)
!!          the real work array of length  fdwkln  that was
!!          used in  dmfit .
!!       fiwkln  -- (INTEGER) -- (passed)
!!          the length of  fitiwk .
!!       fdwkln  -- (INTEGER) -- (passed)
!!          the length of  fitdwk .
!!       temp    -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY)
!!          a work array of length  dimen  (or longer).
!!      The subroutine  dmevl1  is called to do the actual evaluation.
!!      Modified by A.H. Morris (NSWC)
!!
!!      Set up index pointers to the beginning of each row of
!!      the mtable -- this sets the beginning point for each
!!      full multinomial degree.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: nerows
integer, intent(in) :: fiwkln, fdwkln
integer, intent(inout) :: nepols
integer, intent(in) :: nepts, dimen
integer, intent(inout) :: error
integer, intent(in) :: evldeg
integer, intent(in) :: fitiwk(fiwkln)
double precision, intent(inout) :: fitdwk(fdwkln)
double precision, intent(in) :: evlcds(nerows,dimen)
double precision, intent(inout) :: evlvls(nepts), temp(dimen)
!     beginning of local variable declarations
integer :: maxstt, alfstt, cstt, gbasiz, alfl, dimp1, top, bot, curdeg, psistt
interface
   pure subroutine dmevl1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
      & indexs,psi,f,alfl,maxabs,x,dimp1)
      implicit none
      integer, intent(in) :: dimp1
      integer, intent(in) :: alfl
      integer, intent(in) :: npolys
      integer, intent(in) :: dimen
      integer, intent(in) :: nepts
      integer, intent(in) :: ncrows
      double precision, intent(in) :: coord(ncrows,dimen)
      double precision, intent(in) :: c(npolys)
      double precision, intent(in) :: alpha(alfl)
      integer, intent(in) :: indexs(4,npolys)
      double precision, intent(inout) :: psi(npolys)
      double precision, intent(inout) :: f(nepts)
      double precision, intent(in) :: maxabs(dimp1)
      double precision, intent(inout) :: x(dimen)
   end subroutine dmevl1
end interface
!     ***************
!     Purpose
!     -------
!     This subroutine  evaluates  the  least-squares  multinomial  fit
!     which has been previously produced by  dmfit .  The computation
!     is performed in double precision. Either the full
!     multinomial as produced may be evaluated,  or  only  an  initial
!     segment thereof.  As in the case with  dmfit , it is possible
!     (1) to specify multinomials of a full given degree, or
!     (2) to specify  the  number  of  orthogonal  basis  elements  to
!         achieve a partial-degree fit.
!     In case (1), the  desired  degree  is  given  as  the  value  of
!     evldeg   (WHICH  MUST  BE  NONNEGATIVE AND NOT GREATER THAN THE
!     value used for  FITDEG  in  dmfit ), and the parameter  nepols
!     will be set  by  dmeval  to specify the number of basis elements
!     required. If  evldeg  .LT.  FITDEG   is  given,  then  only  the
!     initial  portion of the fitting multinomial (of degree  evldeg )
!     will be evaluated.
!     In case (2),  evldeg  is to be set negative, in which  case  the
!     VALUE  OF   nepols  (WHICH MUST BE POSITIVE AND NOT GREATER THAN
!     THE VALUE USED FOR   NFPOLS   IN   dmfit )  WILL  BE  TAKEN  AS
!     defining  the  initial  portion of the fitting multinomial to be
!     evaluated.
!     IF  nepols  =  NFPOLS  (WITH  evldeg  .LT.  0),  OR   evldeg   =
!     FITDEG  (with   evldeg   .GT.  0),  then  the  full  multinomial
!     generated by  dmfit  will be evaluated.
!     THE  EVALUATION  WILL  TAKE  PLACE  FOR  EACH  OF   THE   POINTS
!     (collection  of  variable  values)  given as a row of the matrix
!      evlcds .  The  values  produced  from  the  full,  or  partial,
!     multinomial will be placed in the array  evlvls .
!     Variables
!     ---------
!      dimen  -- (INTEGER) -- (passed)
!         the number of variables.
!      evldeg  -- (INTEGER) -- (passed)
!         if  evldeg  .LT. 0, then this parameter will be ignored.
!         If  evldeg  .GE. 0, then the value of  evldeg  must  satisfy
!         evldeg  .LE. (the  degree  of the approximating multinomial
!         generated in  dmfit ).  In this case  evldeg  will  specify
!         the degree of the initial portion of the fitting multinomial
!         to be evaluated.
!      nepols  -- (INTEGER) -- (PASSED/RETURNED)
!         if  evldeg  .GE. 0, then this parameter will be ignored.
!         If evldeg .LT. 0, then the partial multinomial involving the
!         FIRST   nepols  ORTHOGONAL BASIS FUNCTIONS WILL BE EVALUATED
!         at the points given by  evlcds .  The resulting values  will
!         be stored in  evlvls .
!         The value of nepols must be .GE. 1 and .LE. (the size of the
!         BASIS  GENERATED  IN   dmfit ),  WHICH  WAS RETURNED AS THE
!         value of  NFPOLS .
!         nepols  will be changed if evldeg .GT. 0 to give the size of
!         basis required for the multinomial of degree  evldeg .
!      nepts  -- (INTEGER) -- (passed)
!         the number of evaluation points.
!      evlcds  -- (double precision 2-subscript array) -- (passed)
!         evlcds (P,K) is the value of the K-TH variable at the  P-TH
!         evaluation point.
!      nerows  -- (INTEGER) -- (passed)
!         the row dimension declared for evlcds in the calling program.
!      evlvls  -- (INTEGER) -- (returned)
!         evlvls (P) is the value of the evaluated multinomial at the
!         P-TH evaluation point.
!      error  -- (INTEGER) -- (returned)
!          0 .........  if no errors
!         -1 .........  IF  nepols  .GT.  NFPOLS  OR  nepols  .LT. 1
!         -2 .........  IF  nepts  .LT. 1 OR  dimen  .LT. 1
!      fitiwk  -- (integer, 1-subscript array) -- (passed)
!         the integer work array of length  fiwkln  that was  used  in
!          dmfit .
!      fitdwk  -- (double precision 2-subscript array) -- (passed)
!         the real work array of length  fdwkln  that was
!         used in  dmfit .
!      fiwkln  -- (INTEGER) -- (passed)
!         the length of  fitiwk .
!      fdwkln  -- (INTEGER) -- (passed)
!         the length of  fitdwk .
!      temp    -- (DOUBLE PRECISION 1-SUBSCRIPT ARRAY)
!         a work array of length  dimen  (or longer).
!     The subroutine  dmevl1  is called to do the actual evaluation.
!     Modified by A.H. Morris (NSWC)
!     ****************
!     ***************
!     Set up index pointers to the beginning of each row of
!     the mtable -- this sets the beginning point for each
!     full multinomial degree.
!     ***************
if (nepts < 1 .or. dimen < 1) go to 110
if (evldeg < 0) go to 40
if (evldeg == 0) go to 10
go to 20
10 nepols = 1
go to 50
20 top = 1
bot = 1
do curdeg = 1,evldeg
   top = top * (dimen + curdeg)
   bot = bot * curdeg
end do
nepols = top / bot
40 gbasiz = fitiwk(1)
if (nepols > gbasiz .or. nepols < 1) go to 100
50 error = 0
dimp1 = dimen + 1
alfl = fitiwk(4)
maxstt = 1
alfstt = dimp1 + maxstt
cstt = alfstt + alfl
psistt = cstt + fitiwk(2)
!     ***************
!     The actual evaluation is done inside  dmevl1.
!     ***************
call dmevl1(evlcds,nerows,fitdwk(cstt),nepts,dimen,nepols, &
   & fitdwk(alfstt),fitiwk,fitdwk(psistt), &
   & evlvls,alfl,fitdwk(maxstt),temp,dimp1)
return
!     ***************
!     Error return
!     ***************
100 error = -1
return
110 error = -2
end subroutine dmeval

pure subroutine dmevl1(coord,ncrows,c,nepts,dimen,npolys,alpha, &
   & indexs,psi,f,alfl,maxabs,x,dimp1)
!! <!-- nswc-ford:begin DMEVL1 -->
!! Reference for `dmevl1`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!      Purpose
!!
!!      This subroutine performs the main work of evaluating the
!!      fitting multinomial (or the initial portion of it  which
!!      is requested by the setting of  NEPOLS ,  EVLDEG  in the
!!      CALL TO SUBROUTINE  dmeval .
!!      This subroutine is called by  dmeval .  It is  not  called
!!      directly by the user.
!!      The body of this subroutine FOLLOWS the explanation
!!      given in
!!           least squares fitting using
!!           orthogonal multinomials
!!      by
!!           Bartels and Jezioranski
!!      in
!!           ACM transactions on mathematical software
!!      modified by A.H. Morris (NSWC)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: ncrows
integer, intent(in) :: dimen, nepts, npolys, alfl, dimp1
integer, intent(in) :: indexs(4,npolys)
double precision, intent(in) :: alpha(alfl), coord(ncrows,dimen)
double precision, intent(inout) :: psi(npolys)
double precision, intent(in) :: c(npolys)
double precision, intent(inout) :: f(nepts)
double precision, intent(in) :: maxabs(dimp1)
double precision, intent(inout) :: x(dimen)
!     beginning of local variable declarations
integer :: jm1, jprime, m, p, k, i, j, index
double precision :: runtot, rntot1
!     ***************
!     Purpose
!     -------
!     This subroutine performs the main work of evaluating the
!     fitting multinomial (or the initial portion of it  which
!     is requested by the setting of  NEPOLS ,  EVLDEG  in the
!     CALL TO SUBROUTINE  dmeval .
!     This subroutine is called by  dmeval .  It is  not  called
!     directly by the user.
!     The body of this subroutine FOLLOWS the explanation
!     given in
!          least squares fitting using
!          orthogonal multinomials
!     by
!          Bartels and Jezioranski
!     in
!          ACM transactions on mathematical software
!     modified by A.H. Morris (NSWC)
!     ****************
if (npolys == 1) go to 50
psi(1) = 1.d0
do p = 1,nepts
!     ***************
!     Scale the coordinates of the p-TH point
!     ***************
   do k = 1,dimen
      x(k) = coord(p,k)
      if (maxabs(k) /= 0.d0) x(k) = x(k) / maxabs(k)
   end do
!     ***************
!     Use the  basis function coefficients  c  and recurrence
!     coefficients  alpha  to evaluate the fitted multinomial
!     at the p-TH point.
!     ***************
   rntot1 = c(1)
   do j = 2,npolys
      k = indexs(2,j)
      jprime = indexs(1,j)
      runtot = x(k) * psi(jprime)
      i = indexs(3,j)
      jm1 = j - 1
      do m = i,jm1
         index = indexs(4,j) + m - i
         runtot = runtot - psi(m) * alpha(index)
      end do
      psi(j) = runtot
      rntot1 = rntot1 + c(j) * psi(j)
   end do
   f(p) = rntot1 * maxabs(dimp1)
end do
return
!     ***************
!     Compute the degree 0 polynomial
!     ***************
50 runtot = c(1) * maxabs(dimp1)
do p = 1,nepts
   f(p) = runtot
end do
end subroutine dmevl1

real function qsuba(f, a, b, epsil, mcount, relerr, ind)
!! <!-- nswc-ford:begin QSUBA -->
!! Reference for `qsuba`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                 Integration over a finite interval
!!
!!      qsuba computes the integral of f(X) from A to b where the
!!      relative error does not exceed epsil.
!!      mcount is the maximum number of points at which f(X) may be
!!      evaluated.
!!      relerr is a variable. When qsuba terminates, if the value
!!      of the integral is nonzero then relerr is a crude estimate
!!      of the relative error of the value. Otherwise, if qsuba = 0
!!      then relerr is an estimate of the absolute error.
!!      Ind is a variable. When qsuba terminates, ind has one of the
!!      following values ...
!!      ind=0   qsuba is satisfied that the integral has been
!!              computed to the desired accuracy.
!!      ind=1   The integral has been computed, but qsuba is
!!              not certain of the accuracy of the result.
!!      ind=2   The integrand has been evaluated at mcount
!!              points. If more evaluations are needed then
!!              qsuba TERMINATES.
!!      ind=3   qsuba cannot compute the integral to the desired
!!              accuracy. Ind is set to 3 whenever the stack of
!!              intervals becomes full (it currently can hold 50
!!              intervals). A result is obtained by continuing
!!              the integration ignoring convergence failures
!!              which cannot be accommodated on the stack.
!!      The reliability of the algorithm decreases for large values
!!      of epsil. It is recommended that epsil be less than 0.001.
!!
!!      ****** eps is a machine dependent constant. Eps is the
!!             smallest number such that 1.0 + eps .GT. 1.0.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: ind
integer, intent(in) :: mcount
real, intent(in) :: a, b, epsil
real, intent(inout) :: relerr
real :: f
external f
!     beginning of local variable declarations
integer :: icheck, is, k, nf, npts
real :: eps, err, result(8), stack(100), sub1, sub2, sub3, sum, &
   & tol, x
integer, parameter :: ismax = 100
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!-----------------------------------------------------------------------
!                Integration over a finite interval
!                          ----------
!     qsuba computes the integral of f(X) from A to b where the
!     relative error does not exceed epsil.
!     mcount is the maximum number of points at which f(X) may be
!     evaluated.
!     relerr is a variable. When qsuba terminates, if the value
!     of the integral is nonzero then relerr is a crude estimate
!     of the relative error of the value. Otherwise, if qsuba = 0
!     then relerr is an estimate of the absolute error.
!     Ind is a variable. When qsuba terminates, ind has one of the
!     following values ...
!     ind=0   qsuba is satisfied that the integral has been
!             computed to the desired accuracy.
!     ind=1   The integral has been computed, but qsuba is
!             not certain of the accuracy of the result.
!     ind=2   The integrand has been evaluated at mcount
!             points. If more evaluations are needed then
!             qsuba TERMINATES.
!     ind=3   qsuba cannot compute the integral to the desired
!             accuracy. Ind is set to 3 whenever the stack of
!             intervals becomes full (it currently can hold 50
!             intervals). A result is obtained by continuing
!             the integration ignoring convergence failures
!             which cannot be accommodated on the stack.
!     The reliability of the algorithm decreases for large values
!     of epsil. It is recommended that epsil be less than 0.001.
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     ****** eps is a machine dependent constant. Eps is the
!            smallest number such that 1.0 + eps .GT. 1.0.
eps = spmpar(1)
!-----------------------------------------------------------------------
qsuba = 0.0
relerr = 0.0
ind = 0
if (a == b) return
!     Apply quad to the entire interval
sub1 = min(a,b)
sub3 = max(a,b)
tol = max(epsil, 10.0*eps)
call quad(sub1, sub3, result, k, tol, npts, icheck, f)
if (icheck == 0) go to 100
is = 1
!     Subdivide the interval (sub1,sub3) into the subintervals
!     (sub1,sub2) and (sub2,sub3). Call quad for (sub1,sub2).
10 if (npts >= mcount) go to 110
sub2 = 0.5*(sub1 + sub3)
call quad(sub1, sub2, result, k, tol, nf, icheck, f)
npts = npts + nf
err = abs(result(k) - result(k - 1))
sum = qsuba + result(k)
if (icheck == 0 .or. err <= abs(tol*sum)) go to 30
!        Stack the subinterval (sub1,sub2) for further
!        examination if there is sufficient storage.
if (is >= ismax) go to 20
stack(is) = sub1
is = is + 1
stack(is) = sub2
is = is + 1
go to 40
20 ind = 3
!     Update qsuba and check if any significant digits are lost
30 x = qsuba
qsuba = sum
relerr = relerr + err
if (ind /= 0 .or. x*result(k) >= 0.0) go to 40
x = 0.1*min(abs(x),abs(result(k)))
if (abs(qsuba) <= x) ind = 1
!     CALL QUAD FOR THE INTERVAL (sub2,sub3)
40 if (npts >= mcount) go to 110
call quad(sub2, sub3, result, k, tol, nf, icheck, f)
npts = npts + nf
err = abs(result(k) - result(k - 1))
sum = qsuba + result(k)
if (icheck == 0 .or. err <= abs(tol*sum)) go to 50
!        Subdivide the interval (sub2,sub3)
sub1 = sub2
go to 10
!     Update qsuba and check if any significant digits are lost
50 x = qsuba
qsuba = sum
relerr = relerr + err
if (ind /= 0 .or. x*result(k) >= 0.0) go to 60
x = 0.1*min(abs(x),abs(result(k)))
if (abs(qsuba) <= x) ind = 1
!     Subdivide the interval last stacked
60 if (is == 1) go to 120
is = is - 1
sub3 = stack(is)
is = is - 1
sub1 = stack(is)
go to 10
!     Termination when subdivision is not needed
100 qsuba = result(k)
if (a > b) qsuba = -qsuba
relerr = abs(result(k) - result(k - 1))
if (qsuba /= 0.0) relerr = relerr/abs(qsuba)
return
!     Subdivision result
110 ind = 2
120 if (a > b) qsuba = -qsuba
if (qsuba /= 0.0) relerr = relerr/abs(qsuba)
end function qsuba

subroutine quad(a, b, result, k, epsil, npts, icheck, f)
!! <!-- nswc-ford:begin QUAD -->
!! Reference for `quad`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  This subroutine attempts to calculate the integral of f(x)
!!  over the interval *a* to *b* with relative error not
!!  EXCEEDING *epsil*.
!!  The result is obtained using a sequence of 1,3,7,15,31,63,
!!  127, and 255 point interlacing formulae(no integrand
!!  evaluations are wasted) of respective degree 1,5,11,23,
!!  47,95,191 and 383. The formulae are based on the optimal
!!  extension of the 3-point Gauss formula.  Details of
!!  the formulae are given in *the optimum addition of points
!!  to quadrature formulae* by T.N.L. patterson,maths.COMP.
!!  Vol 22,847-856,1968.
!!                      *** INPUT ***
!!  A       LOWER LIMIT OF INTEGRATION.
!!  b       UPPER LIMIT OF INTEGRATION.
!!  epsil   RELATIVE ACCURACY REQUIRED. WHEN THE RELATIVE
!!          difference of two successive formulae does not
!!          exceed *epsil* the last formula computed is taken
!!          as the result.
!!  f       f(x) IS THE INTEGRAND.
!!                      *** OUTPUT ***
!!  result  this array,which should be declared to have at
!!          least 8 elements, holds the results obtained by
!!          the 1,3,7, etc., point formulae. The number of
!!          formulae computed depents on *epsil*.
!!  k       result(k) HOLDS THE VALUE OF THE INTEGRAL TO THE
!!          specified relative accuracy.
!!  npts    NUMBER INTEGRAND EVALUATIONS.
!!  icheck  on exit normally icheck=0. However if convergence
!!          to the accuracy requested is not achieved icheck=1
!!          on exit.
!!  Abscissae and weights of quadrature rules are stacked in
!!  array *p* in the order in which they are needed.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: icheck
integer, intent(inout) :: k, npts
real, intent(in) :: a, b, epsil
real, intent(inout) :: result(*)
real :: f
external f
!     beginning of local variable declarations
integer :: i, inew, iold, j
real :: acum, diff, funct(127), fzero, sum, x
real, parameter :: p(381) = [0.77459666924148337704e00, 0.55555555555555555556e00, 0.88888888888888888889e00, &
   & 0.26848808986833344073e00, 0.96049126870802028342e00, 0.10465622602646726519e00, 0.43424374934680255800e00, &
   & 0.40139741477596222291e00, 0.45091653865847414235e00, 0.13441525524378422036e00, 0.51603282997079739697e-01, &
   & 0.20062852937698902103e00, 0.99383196321275502221e00, 0.17001719629940260339e-01, 0.88845923287225699889e00, &
   & 0.92927195315124537686e-01, 0.62110294673722640294e00, 0.17151190913639138079e00, 0.22338668642896688163e00, &
   & 0.21915685840158749640e00, 0.22551049979820668739e00, 0.67207754295990703540e-01, 0.25807598096176653565e-01, &
   & 0.10031427861179557877e00, 0.84345657393211062463e-02, 0.46462893261757986541e-01, 0.85755920049990351154e-01, &
   & 0.10957842105592463824e00, 0.99909812496766759766e00, 0.25447807915618744154e-02, 0.98153114955374010687e00, &
   & 0.16446049854387810934e-01, 0.92965485742974005667e00, 0.35957103307129322097e-01, 0.83672593816886873550e00, &
   & 0.56979509494123357412e-01, 0.70249620649152707861e00, 0.76879620499003531043e-01, 0.53131974364437562397e00, &
   & 0.93627109981264473617e-01, 0.33113539325797683309e00, 0.10566989358023480974e00, 0.11248894313318662575e00, &
   & 0.11195687302095345688e00, 0.11275525672076869161e00, 0.33603877148207730542e-01, 0.12903800100351265626e-01, &
   & 0.50157139305899537414e-01, 0.42176304415588548391e-02, 0.23231446639910269443e-01, 0.42877960025007734493e-01, &
   & 0.54789210527962865032e-01, 0.12651565562300680114e-02, 0.82230079572359296693e-02, 0.17978551568128270333e-01, &
   & 0.28489754745833548613e-01, 0.38439810249455532039e-01, 0.46813554990628012403e-01, 0.52834946790116519862e-01, &
   & 0.55978436510476319408e-01, 0.99987288812035761194e00, 0.36322148184553065969e-03, 0.99720625937222195908e00, &
   & 0.25790497946856882724e-02, 0.98868475754742947994e00, 0.61155068221172463397e-02, 0.97218287474858179658e00, &
   & 0.10498246909621321898e-01, 0.94634285837340290515e00, 0.15406750466559497802e-01, 0.91037115695700429250e00, &
   & 0.20594233915912711149e-01, 0.86390793819369047715e00, 0.25869679327214746911e-01, 0.80694053195021761186e00, &
   & 0.31073551111687964880e-01, 0.73975604435269475868e00, 0.36064432780782572640e-01, 0.66290966002478059546e00, &
   & 0.40715510116944318934e-01, 0.57719571005204581484e00, 0.44914531653632197414e-01, 0.48361802694584102756e00, &
   & 0.48564330406673198716e-01, 0.38335932419873034692e00, 0.51583253952048458777e-01, 0.27774982202182431507e00, &
   & 0.53905499335266063927e-01, 0.16823525155220746498e00, 0.55481404356559363988e-01, 0.56344313046592789972e-01, &
   & 0.56277699831254301273e-01, 0.56377628360384717388e-01, 0.16801938574103865271e-01, 0.64519000501757369228e-02, &
   & 0.25078569652949768707e-01, 0.21088152457266328793e-02, 0.11615723319955134727e-01, 0.21438980012503867246e-01, &
   & 0.27394605263981432516e-01, 0.63260731936263354422e-03, 0.41115039786546930472e-02, 0.89892757840641357233e-02, &
   & 0.14244877372916774306e-01, 0.19219905124727766019e-01, 0.23406777495314006201e-01, 0.26417473395058259931e-01, &
   & 0.27989218255238159704e-01, 0.18073956444538835782e-03, 0.12895240826104173921e-02, 0.30577534101755311361e-02, &
   & 0.52491234548088591251e-02, 0.77033752332797418482e-02, 0.10297116957956355524e-01, 0.12934839663607373455e-01, &
   & 0.15536775555843982440e-01, 0.18032216390391286320e-01, 0.20357755058472159467e-01, 0.22457265826816098707e-01, &
   & 0.24282165203336599358e-01, 0.25791626976024229388e-01, 0.26952749667633031963e-01, 0.27740702178279681994e-01, &
   & 0.28138849915627150636e-01, 0.99998243035489159858e00, 0.50536095207862517625e-04, 0.99959879967191068325e00, &
   & 0.37774664632698466027e-03, 0.99831663531840739253e00, 0.93836984854238150079e-03, 0.99572410469840718851e00, &
   & 0.16811428654214699063e-02, 0.99149572117810613240e00, 0.25687649437940203731e-02, 0.98537149959852037111e00, &
   & 0.35728927835172996494e-02, 0.97714151463970571416e00, 0.46710503721143217474e-02, 0.96663785155841656709e00, &
   & 0.58434498758356395076e-02, 0.95373000642576113641e00, 0.70724899954335554680e-02, 0.93832039777959288365e00, &
   & 0.83428387539681577056e-02, 0.92034002547001242073e00, 0.96411777297025366953e-02, 0.89974489977694003664e00, &
   & 0.10955733387837901648e-01, 0.87651341448470526974e00, 0.12275830560082770087e-01, 0.85064449476835027976e00, &
   & 0.13591571009765546790e-01, 0.82215625436498040737e00, 0.14893641664815182035e-01, 0.79108493379984836143e00, &
   & 0.16173218729577719942e-01, 0.75748396638051363793e00, 0.17421930159464173747e-01, 0.72142308537009891548e00, &
   & 0.18631848256138790186e-01, 0.68298743109107922809e00, 0.19795495048097499488e-01, 0.64227664250975951377e00, &
   & 0.20905851445812023852e-01, 0.59940393024224289297e00, 0.21956366305317824939e-01, 0.55449513263193254887e00, &
   & 0.22940964229387748761e-01, 0.50768775753371660215e00, 0.23854052106038540080e-01, 0.45913001198983233287e00, &
   & 0.24690524744487676909e-01, 0.40897982122988867241e00, 0.25445769965464765813e-01, 0.35740383783153215238e00, &
   & 0.26115673376706097680e-01, 0.30457644155671404334e00, 0.26696622927450359906e-01, 0.25067873030348317661e00, &
   & 0.27185513229624791819e-01, 0.19589750271110015392e00, 0.27579749566481873035e-01, 0.14042423315256017459e00, &
   & 0.27877251476613701609e-01, 0.84454040083710883710e-01, 0.28076455793817246607e-01, 0.28184648949745694339e-01, &
   & 0.28176319033016602131e-01, 0.28188814180192358694e-01, 0.84009692870519326354e-02, 0.32259500250878684614e-02, &
   & 0.12539284826474884353e-01, 0.10544076228633167722e-02, 0.58078616599775673635e-02, 0.10719490006251933623e-01, &
   & 0.13697302631990716258e-01, 0.31630366082226447689e-03, 0.20557519893273465236e-02, 0.44946378920320678616e-02, &
   & 0.71224386864583871532e-02, 0.96099525623638830097e-02, 0.11703388747657003101e-01, 0.13208736697529129966e-01, &
   & 0.13994609127619079852e-01, 0.90372734658751149261e-04, 0.64476204130572477933e-03, 0.15288767050877655684e-02, &
   & 0.26245617274044295626e-02, 0.38516876166398709241e-02, 0.51485584789781777618e-02, 0.64674198318036867274e-02, &
   & 0.77683877779219912200e-02, 0.90161081951956431600e-02, 0.10178877529236079733e-01, 0.11228632913408049354e-01, &
   & 0.12141082601668299679e-01, 0.12895813488012114694e-01, 0.13476374833816515982e-01, 0.13870351089139840997e-01, &
   & 0.14069424957813575318e-01, 0.25157870384280661489e-04, 0.18887326450650491366e-03, 0.46918492424785040975e-03, &
   & 0.84057143271072246365e-03, 0.12843824718970101768e-02, 0.17864463917586498247e-02, 0.23355251860571608737e-02, &
   & 0.29217249379178197538e-02, 0.35362449977167777340e-02, 0.41714193769840788528e-02, 0.48205888648512683476e-02, &
   & 0.54778666939189508240e-02, 0.61379152800413850435e-02, 0.67957855048827733948e-02, 0.74468208324075910174e-02, &
   & 0.80866093647888599710e-02, 0.87109650797320868736e-02, 0.93159241280693950932e-02, 0.98977475240487497440e-02, &
   & 0.10452925722906011926e-01, 0.10978183152658912470e-01, 0.11470482114693874380e-01, 0.11927026053019270040e-01, &
   & 0.12345262372243838455e-01, 0.12722884982732382906e-01, 0.13057836688353048840e-01, 0.13348311463725179953e-01, &
   & 0.13592756614812395910e-01, 0.13789874783240936517e-01, 0.13938625738306850804e-01, 0.14038227896908623303e-01, &
   & 0.14088159516508301065e-01, 0.99999759637974846462e00, 0.69379364324108267170e-05, 0.99994399620705437576e00, &
   & 0.53275293669780613125e-04, 0.99976049092443204733e00, 0.13575491094922871973e-03, 0.99938033802502358193e00, &
   & 0.24921240048299729402e-03, 0.99874561446809511470e00, 0.38974528447328229322e-03, 0.99780535449595727456e00, &
   & 0.55429531493037471492e-03, 0.99651414591489027385e00, 0.74028280424450333046e-03, 0.99483150280062100052e00, &
   & 0.94536151685852538246e-03, 0.99272134428278861533e00, 0.11674841174299594077e-02, 0.99015137040077015918e00, &
   & 0.14049079956551446427e-02, 0.98709252795403406719e00, 0.16561127281544526052e-02, 0.98351865757863272876e00, &
   & 0.19197129710138724125e-02, 0.97940628167086268381e00, 0.21944069253638388388e-02, 0.97473445975240266776e00, &
   & 0.24789582266575679307e-02, 0.96948465950245923177e00, 0.27721957645934509940e-02, 0.96364062156981213252e00, &
   & 0.30730184347025783234e-02, 0.95718821610986096274e00, 0.33803979910869203823e-02, 0.95011529752129487656e00, &
   & 0.36933779170256508183e-02, 0.94241156519108305981e00, 0.40110687240750233989e-02, 0.93406843615772578800e00, &
   & 0.43326409680929828545e-02, 0.92507893290707565236e00, 0.46573172997568547773e-02, 0.91543758715576504064e00, &
   & 0.49843645647655386012e-02, 0.90514035881326159519e00, 0.53130866051870565663e-02, 0.89418456833555902286e00, &
   & 0.56428181013844441585e-02, 0.88256884024734190684e00, 0.59729195655081658049e-02, 0.87029305554811390585e00, &
   & 0.63027734490857587172e-02, 0.85735831088623215653e00, 0.66317812429018878941e-02, 0.84376688267270860104e00, &
   & 0.69593614093904229394e-02, 0.82952219463740140018e00, 0.72849479805538070639e-02, 0.81462878765513741344e00, &
   & 0.76079896657190565832e-02, 0.79909229096084140180e00, 0.79279493342948491103e-02, 0.78291939411828301639e00, &
   & 0.82443037630328680306e-02, 0.76611781930376009072e00, 0.85565435613076896192e-02, 0.74869629361693660282e00, &
   & 0.88641732094824942641e-02, 0.73066452124218126133e00, 0.91667111635607884067e-02, 0.71203315536225203459e00, &
   & 0.94636899938300652943e-02, 0.69281376977911470289e00, 0.97546565363174114611e-02, 0.67301883023041847920e00, &
   & 0.10039172044056840798e-01, 0.65266166541001749610e00, 0.10316812330947621682e-01, 0.63175643771119423041e00, &
   & 0.10587167904885197931e-01, 0.61031811371518640016e00, 0.10849844089337314099e-01, 0.58836243444766254143e00, &
   & 0.11104461134006926537e-01, 0.56590588542365442262e00, 0.11350654315980596602e-01, 0.54296566649831149049e00, &
   & 0.11588074033043952568e-01, 0.51955966153745702199e00, 0.11816385890830235763e-01, 0.49570640791876146017e00, &
   & 0.12035270785279562630e-01, 0.47142506587165887693e00, 0.12244424981611985899e-01, 0.44673538766202847374e00, &
   & 0.12443560190714035263e-01, 0.42165768662616330006e00, 0.12632403643542078765e-01, 0.39621280605761593918e00, &
   & 0.12810698163877361967e-01, 0.37042208795007823014e00, 0.12978202239537399286e-01, 0.34430734159943802278e00, &
   & 0.13134690091960152836e-01, 0.31789081206847668318e00, 0.13279951743930530650e-01, 0.29119514851824668196e00, &
   & 0.13413793085110098513e-01, 0.26424337241092676194e00, 0.13536035934956213614e-01, 0.23705884558982972721e00, &
   & 0.13646518102571291428e-01, 0.20966523824318119477e00, 0.13745093443001896632e-01, 0.18208649675925219825e00, &
   & 0.13831631909506428676e-01, 0.15434681148137810869e00, 0.13906019601325461264e-01, 0.12647058437230196685e00, &
   & 0.13968158806516938516e-01, 0.98482396598119202090e-01, 0.14017968039456608810e-01, 0.70406976042855179063e-01, &
   & 0.14055382072649964277e-01, 0.42269164765363603212e-01, 0.14080351962553661325e-01, 0.14093886410782462614e-01, &
   & 0.14092845069160408355e-01, 0.14094407090096179347e-01]
!     --------------------
! This subroutine attempts to calculate the integral of f(x)
! over the interval *a* to *b* with relative error not
! EXCEEDING *epsil*.
! The result is obtained using a sequence of 1,3,7,15,31,63,
! 127, and 255 point interlacing formulae(no integrand
! evaluations are wasted) of respective degree 1,5,11,23,
! 47,95,191 and 383. The formulae are based on the optimal
! extension of the 3-point Gauss formula.  Details of
! the formulae are given in *the optimum addition of points
! to quadrature formulae* by T.N.L. patterson,maths.COMP.
! Vol 22,847-856,1968.
!                     *** INPUT ***
! A       LOWER LIMIT OF INTEGRATION.
! b       UPPER LIMIT OF INTEGRATION.
! epsil   RELATIVE ACCURACY REQUIRED. WHEN THE RELATIVE
!         difference of two successive formulae does not
!         exceed *epsil* the last formula computed is taken
!         as the result.
! f       f(x) IS THE INTEGRAND.
!                     *** OUTPUT ***
! result  this array,which should be declared to have at
!         least 8 elements, holds the results obtained by
!         the 1,3,7, etc., point formulae. The number of
!         formulae computed depents on *epsil*.
! k       result(k) HOLDS THE VALUE OF THE INTEGRAL TO THE
!         specified relative accuracy.
! npts    NUMBER INTEGRAND EVALUATIONS.
! icheck  on exit normally icheck=0. However if convergence
!         to the accuracy requested is not achieved icheck=1
!         on exit.
! Abscissae and weights of quadrature rules are stacked in
! array *p* in the order in which they are needed.
!     --------------------
icheck = 0
! Check for trivial case.
if (a == b) go to 70
! Scale factors.
sum = (b + a)/2.0
diff = (b - a)/2.0
! 1-Point Gauss
fzero = f(sum)
result(1) = 2.0*fzero*diff
i = 0
iold = 0
inew = 1
k = 2
acum = 0.0
go to 30
10 if (k == 8) go to 50
k = k + 1
acum = 0.0
! Contribution from function values already computed.
do j = 1,iold
   i = i + 1
   acum = acum + p(i)*funct(j)
end do
! Contribution from new function values.
30 iold = iold + inew
do j = inew,iold
   i = i + 1
   x = p(i)*diff
   funct(j) = f(sum + x) + f(sum - x)
   i = i + 1
   acum = acum + p(i)*funct(j)
end do
inew = iold + 1
i = i + 1
result(k) = (acum + p(i)*fzero)*diff
! Check for convergence.
if ((abs(result(k) - result(k - 1)) - epsil * abs( &
   & result(k))) <= 0) go to 60
go to 10
! Convergence not achieved.
50 icheck = 1
! Normal termination.
60 npts = inew + iold
return
! Trivial case
70 k = 2
result(1) = 0.0
result(2) = 0.0
npts = 0
end subroutine quad

subroutine qags(f, a, b, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
!! <!-- nswc-ford:begin QAGS -->
!! Reference for `qags`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Computation of a definite integral
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            definite integral   I = Integral of  f  over (a,b),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - REAL
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X T E R N A L in the driver program.
!!             a      - REAL
!!                      lower limit of integration
!!             b      - REAL
!!                      upper limit of integration
!!             epsabs - REAL
!!                      absolute accuracy requested
!!             epsrel - REAL
!!                      relative accuracy requested
!!          on return
!!             result - Real
!!                      approximation to the integral
!!             abserr - REAL
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                      ier.GT.0 abnormal termination of the routine
!!                              the estimates for integral and error are
!!                              less reliable. It is assumed that the
!!                              requested accuracy has not been achieved.
!!                      ier = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more sub-
!!                              divisions by increasing the value of
!!                              limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of A
!!                              local difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the sub-
!!                              ranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is DETEC-
!!                              ted, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour
!!                              occurs at some  points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              It is presumed that the requested
!!                              tolerance cannot be achieved, and that the
!!                              returned result is the best which can be
!!                              obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted
!!                              that divergence can occur with any other
!!                              value of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative, limit .LT. 1,
!!                              OR lenw .LT. 4 * limit.
!!                              Result, abserr, neval, last are
!!                              set to zero.
!!          Dimensioning parameters
!!             limit - Integer
!!                     dimensioning parameter for iwork
!!                     limit determines the maximum number
!!                     of subintervals in the partition of the given
!!                     INTEGRATION INTERVAL (a,b), limit.GE.1.
!!                     If limit.LT.1, the routine will end with
!!                     ier = 6.
!!             lenw  - INTEGER
!!                     dimensioning parameter for work
!!                     lenw must be at least limit*4.
!!                     If lenw.LT.limit*4, the routine will end
!!                     with ier = 6.
!!             last  - Integer
!!                     on return, last equals the number of
!!                     subintervals produced in the subdivision
!!                     process, which determines the number of
!!                     significant elements actually in the work
!!                     arrays.
!!          Work arrays
!!             iwork - INTEGER
!!                     vector of dimension at least limit, the first K
!!                     elements of which contain pointers
!!                     to the error estimates over the subintervals
!!                     such that work(limit*3+iwork(1)),... ,
!!                     work(limit*3+iwork(K)) form a decreasing
!!                     sequence, with K = last if last.LE.(limit/2+2), and
!!                     K = limit+1-last otherwise
!!             work  - Real
!!                     vector of dimension at least lenw
!!                     on return
!!                     work(1), ..., work(last) contain the left
!!                      END POINTS OF THE SUBINTERVALS IN THE
!!                      partition of (a,b),
!!                     work(limit+1), ..., work(limit+last) contain
!!                      the right end points,
!!                     work(limit*2+1), ..., work(limit*2+last)
!!                      contain the integral approximations over
!!                      the subintervals,
!!                     work(limit*3+1), ..., work(limit*3+last)
!!                      contain the error estimates.
!!          Subroutines or functions needed
!!               - qagse
!!               - qk21f
!!               - qpsrt
!!               - qelg
!!               - f (user-provided function)
!!               - spmpar
!!
!!          Check validity of limit and lenw.
!! ```
!! <!-- nswc-ford:end -->
implicit none
real :: f
integer, intent(out) :: ier, last
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
real, intent(in) :: a
real, intent(out) :: abserr
real, intent(in) :: b, epsabs, epsrel
real, intent(out) :: result
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
!     beginning of local variable declarations
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!                 Computation of a definite integral
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (a,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of
!                    significant elements actually in the work
!                    arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!         Subroutines or functions needed
!              - qagse
!              - qk21f
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - spmpar
!-----------------------------------------------------------------------
!         Check validity of limit and lenw.
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit < 1 .or. lenw < limit*4) return
!         Prepare call for qagse.
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
call qagse(f,a,b,epsabs,epsrel,limit,result,abserr,neval, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last)
end subroutine qags

subroutine qagse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
!! <!-- nswc-ford:begin QAGSE -->
!! Reference for `qagse`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                  Computation of a definite integral
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            definite integral   I = Integral of  f  over (a,b),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - REAL
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X t E R N A L in the driver program.
!!             a      - REAL
!!                      lower limit of integration
!!             b      - REAL
!!                      upper limit of integration
!!             epsabs - REAL
!!                      absolute accuracy requested
!!             epsrel - REAL
!!                      relative accuracy requested
!!             limit  - Integer
!!                      gives an upperbound on the number of
!!                      subintervals in the partition of (a,b)
!!          on return
!!             result - Real
!!                      approximation to the integral
!!             abserr - REAL
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                      ier.GT.0 abnormal termination of the routine
!!                              the estimates for integral and error are
!!                              less reliable. It is assumed that the
!!                              requested accuracy has not been achieved.
!!                          = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more sub-
!!                              divisions by increasing the value of
!!                              limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of A
!!                              local difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the sub-
!!                              ranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is DETEC-
!!                              ted, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour
!!                              occurs at some  points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              It is presumed that the requested
!!                              tolerance cannot be achieved, and that the
!!                              returned result is the best which can be
!!                              obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted
!!                              that divergence can occur with any other
!!                              value of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative.
!!                              Result, abserr, neval, last, rlist(1),
!!                              iord(1) and elist(1) are set to zero.
!!                              alist(1) and blist(1) are set to A and b
!!                              respectively.
!!             alist  - REAL
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the left
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the given integration range (a,b)
!!             blist  - REAL
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the right
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the given integration range (a,b)
!!             rlist  - REAL
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the integral
!!                      approximations on the subintervals
!!             elist  - REAL
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the moduli
!!                      of the absolute error estimates on the
!!                      SUBINERVALS
!!             iord   - INTEGER
!!                      vector of dimension at least limit, the first k
!!                      elements of which are pointers to the error
!!                      estimates over the subintervals, such
!!                      THAT elist(iord(1)), ..., elist(iord(k))
!!                      form a decreasing sequence, with k = last
!!                      if last.LE.(limit/2+2), and k = limit+1-last
!!                      otherwise
!!             last   - INTEGER
!!                      number of subintervals actually produced in the
!!                      subdivision process
!!          subroutines or functions needed
!!               - qk21f
!!               - qpsrt
!!               - qelg
!!               - f (user-provided function)
!!               - spmpar
!!
!!             The dimension of rlist2 is determined by the value of
!!             LIMEXP in subroutine qelg (rlist2 should be of dimension
!!             (LIMEXP+2) at least).
!!             List of major variables
!!
!!            alist     - List of left end points of all subintervals
!!                        considered up to now
!!            blist     - List of right end points of all subintervals
!!                        considered up to now
!!            rlist(I)  - Approximation to the integral over
!!                        (alist(I),blist(I))
!!            rlist2    - Array of dimension at least LIMEXP+2
!!                        containing the part of the epsilon table
!!                        which is still needed for further computations
!!            elist(I)  - Error estimate applying to rlist(I)
!!            maxerr    - Pointer to the interval with largest error
!!                        estimate
!!            errmax    - elist(maxerr)
!!            erlast    - Error on the interval currently subdivided
!!                        (before that subdivision has taken place)
!!            area      - Sum of the integrals over the subintervals
!!            ERRSUM    - Sum of the errors over the subintervals
!!            errbnd    - Requested accuracy max(epsabs,epsrel*
!!                        abs(result))
!!            *****1    - Variable for the left interval
!!            *****2    - Variable for the right interval
!!            last      - Index for subdivision
!!            nres      - Number of calls to the extrapolation routine
!!            numrl2    - Number of elements currently in rlist2. If an
!!                        appropriate approximation to the compounded
!!                        integral has been obtained it is put in
!!                        rlist2(numrl2) after numrl2 has been increased
!!                        by one.
!!            small     - Length of the smallest interval considered
!!                        up to now, multiplied by 1.5
!!            erlarg    - Sum of the errors over the intervals larger
!!                        than the smallest interval considered up to now
!!            extrap    - Logical variable denoting that the routine
!!                        is attempting to perform extrapolation
!!                        I.E. before subdividing the smallest interval
!!                        we try to decrease the value of erlarg.
!!            noext     - Logical variable denoting that extrapolation
!!                        is no longer allowed (true value)
!!             machine dependent constants
!!
!!            epmach is the largest relative spacing.
!!            uflow is the smallest positive magnitude.
!!            OFLOW is the largest positive magnitude.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!                 Computation of a definite integral
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upperbound on the number of
!                     subintervals in the partition of (a,b)
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!                         = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             iord(1) and elist(1) are set to zero.
!                             alist(1) and blist(1) are set to A and b
!                             respectively.
!            alist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!            blist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!            rlist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     SUBINERVALS
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the error
!                     estimates over the subintervals, such
!                     THAT elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!         subroutines or functions needed
!              - qk21f
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - spmpar
!-----------------------------------------------------------------------
real, intent(in) :: a
real, intent(out) :: abserr
real, intent(inout) :: alist
real, intent(in) :: b
real, intent(inout) :: blist
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!     beginning of local variable declarations
real :: abseps, area, area1, area12, area2, a1, a2, b1, b2, correc, defabs, defab1, defab2, dres, epmach, erlarg, erlast, errbnd, &
   & errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), small, t, uflow
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2
logical :: extrap, noext
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine qelg (rlist2 should be of dimension
!            (LIMEXP+2) at least).
!            List of major variables
!            -----------------------
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least LIMEXP+2
!                       containing the part of the epsilon table
!                       which is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left interval
!           *****2    - Variable for the right interval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered
!                       up to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation
!                       I.E. before subdividing the smallest interval
!                       we try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (true value)
!            machine dependent constants
!            ---------------------------
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!            Check epsabs and epsrel
!            -----------------------
neval = 0
last = 0
result = 0.0
abserr = 0.0
alist(1) = a
blist(1) = b
rlist(1) = 0.0
elist(1) = 0.0
ier = 6
if (epsabs < 0.0 .or. epsrel < 0.0) go to 999
ier = 0
rerr = max(epsrel, 50.0*epmach, 0.5e-14)
!           First approximation to the integral
!           -----------------------------------
ierro = 0
call qk21f(f, a, b, result, abserr, defabs, resabs, &
   & epmach, uflow, id)
if (id /= 0) go to 999
neval = 21
!           Test on accuracy.
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr <= 100.0*epmach*defabs .and. abserr > &
   & errbnd) ier = 2
if (limit == 1) ier = 1
if (ier /= 0) go to 999
!           Initialization
!           --------------
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.0
nrmax = 1
nres = 0
numrl2 = 2
ktmin = 0
extrap = .false.
noext = .false.
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres >= (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with the nrmax-TH largest
!           error estimate.
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qk21f(f, a1, b1, area1, error1, resabs, defab1, &
      & epmach, uflow, ier)
   if (ier /= 0) exit
   call qk21f(f, a2, b2, area2, error2, resabs, defab2, &
      & epmach, uflow, ier)
   neval = neval + 42
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1e-04*abs(area12) &
      & .or. erro12 < 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually
!           set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of
!           subintervals equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
   alist(last) = a2
   blist(maxerr) = b1
   blist(last) = b2
   elist(maxerr) = error1
   elist(last) = error2
   go to 30
20 alist(maxerr) = a2
   alist(last) = a1
   blist(last) = b1
   rlist(maxerr) = area2
   rlist(last) = area1
   elist(maxerr) = error2
   elist(last) = error1
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum <= errbnd) go to 115
! ***Jump out of do-loop
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro == 3 .or. erlarg <= ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (erlarg) and perform
!           extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg(numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1e-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
! ***Jump out of do-loop
   if (abserr <= ertest) exit
!           Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
   maxerr = iord(1)
   errmax = elist(maxerr)
   nrmax = 1
   extrap = .false.
   small = small*0.5
   erlarg = errsum
   go to 90
80 small = abs(b - a)*0.375
   erlarg = errsum
   ertest = errbnd
   rlist2(2) = area
90 continue
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.0 .and. area /= 0.0) go to 105
if (abserr > errsum) go to 115
if (area == 0.0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence.
110 if (ksgn == -1 .and. max(abs(result),abs(area)) <= &
   & defabs*0.1e-01) go to 130
if (0.1e-01 > (result/area) .or. (result/area) > 0.1e+03 &
   & .or. errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier > 2) ier = ier - 1
999 return
end subroutine qagse

subroutine qk21f(f, a, b, result, abserr, resabs, resasc, &
   & epmach, uflow, isig)
!! <!-- nswc-ford:begin QK21F -->
!! Reference for `qk21f`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        PURPOSE
!!               to compute I = Integral of f over (a,b), with error
!!                              estimate
!!                          j = Integral of abs(f) over (a,b)
!!  2.        PARAMETERS
!!             on entry
!!               f      - REAL
!!                        function subprogram defining the integrand
!!                        function f(x). the actual name for f needs
!!                        to be declared E X T E R N A L in the
!!                        calling program.
!!               a      - REAL
!!                        lower limit of integration
!!               b      - REAL
!!                        upper limit of integration
!!               epmach - REAL
!!                        the relative precision of the floating
!!                        arithmetic being used.
!!               uflow  - REAL
!!                        the smallest positive magnitude.
!!             On return
!!               result - Real
!!                        approximation to the integral I
!!                        result is computed by applying the 21-point
!!                        Kronrod rule (RESK) obtained by optimal
!!                        addition of abscissae to the 10-point Gauss
!!                        RULE (resg).
!!               abserr - REAL
!!                        estimate of the modulus of the absolute error,
!!                        which should not exceed abs(I-result)
!!               resabs - REAL
!!                        approximation to the integral j
!!               resasc - REAL
!!                        approximation to the integral of abs(f-I/(b-a))
!!                        OVER (a,b)
!!               isig   - INTEGER
!!                        isig=0  The integral was approximated.
!!                        isig=5  The interval (a,b) is too short.
!!                                The integral cannot be computed.
!!  3.        SUBROUTINES OR FUNCTIONS NEEDED
!!                  - f (user-provided function)
!!
!!            The abscissae and weights are given for the interval (-1,1).
!!            Because of symmetry only the positive abscissae and their
!!            corresponding weights are given.
!!            xgk    - Abscissae of the 21-point Kronrod rule
!!                     xgk(2), xgk(4), ...  abscissae of the 10-point
!!                     Gauss rule
!!                     xgk(1), xgk(3), ...  abscissae which are optimally
!!                     added to the 10-point Gauss rule
!!            wgk    - Weights of the 21-point Kronrod rule
!!            wg     - Weights of the 10-point Gauss rule
!!            List of major variables
!!
!!            centr  - Mid point of the interval
!!            hlgth  - Half-length of the interval
!!            absc   - ABSCISSA
!!            FVAL*  - Function VALUE
!!            resg   - result of the 10-point Gauss formula
!!            RESK   - result of the 21-point Kronrod formula
!!            RESKH  - Approximation to the mean value of f over (a,b),
!!                     I.E. TO I/(b-a)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: isig
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
real :: f
external f
!     beginning of local variable declarations
integer :: j, jtw, jtwm1
real :: absc, centr, dhlgth, fc, fsum, fval1, fval2, hlgth, resg, resk, reskh, tol, fv1(10), fv2(10)
real, parameter :: xgk(11) = [0.9956571630258081e+00, 0.9739065285171717e+00, 0.9301574913557082e+00, &
   & 0.8650633666889845e+00, 0.7808177265864169e+00, 0.6794095682990244e+00, 0.5627571346686047e+00, 0.4333953941292472e+00, &
   & 0.2943928627014602e+00, 0.1488743389816312e+00, 0.0000000000000000e+00]
real, parameter :: wgk(11) = [0.1169463886737187e-01, 0.3255816230796473e-01, 0.5475589657435200e-01, &
   & 0.7503967481091995e-01, 0.9312545458369761e-01, 0.1093871588022976e+00, 0.1234919762620659e+00, 0.1347092173114733e+00, &
   & 0.1427759385770601e+00, 0.1477391049013385e+00, 0.1494455540029169e+00]
real, parameter :: wg(5) = [0.6667134430868814e-01, 0.1494513491505806e+00, 0.2190863625159820e+00, 0.2692667193099964e+00 &
   & , 0.2955242247147529e+00]
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              to compute I = Integral of f over (a,b), with error
!                             estimate
!                         j = Integral of abs(f) over (a,b)
! 2.        PARAMETERS
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!              a      - REAL
!                       lower limit of integration
!              b      - REAL
!                       upper limit of integration
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!              uflow  - REAL
!                       the smallest positive magnitude.
!            On return
!              result - Real
!                       approximation to the integral I
!                       result is computed by applying the 21-point
!                       Kronrod rule (RESK) obtained by optimal
!                       addition of abscissae to the 10-point Gauss
!                       RULE (resg).
!              abserr - REAL
!                       estimate of the modulus of the absolute error,
!                       which should not exceed abs(I-result)
!              resabs - REAL
!                       approximation to the integral j
!              resasc - REAL
!                       approximation to the integral of abs(f-I/(b-a))
!                       OVER (a,b)
!              isig   - INTEGER
!                       isig=0  The integral was approximated.
!                       isig=5  The interval (a,b) is too short.
!                               The integral cannot be computed.
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!-----------------------------------------------------------------------
!           The abscissae and weights are given for the interval (-1,1).
!           Because of symmetry only the positive abscissae and their
!           corresponding weights are given.
!           xgk    - Abscissae of the 21-point Kronrod rule
!                    xgk(2), xgk(4), ...  abscissae of the 10-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 10-point Gauss rule
!           wgk    - Weights of the 21-point Kronrod rule
!           wg     - Weights of the 10-point Gauss rule
!           List of major variables
!           -----------------------
!           centr  - Mid point of the interval
!           hlgth  - Half-length of the interval
!           absc   - ABSCISSA
!           FVAL*  - Function VALUE
!           resg   - result of the 10-point Gauss formula
!           RESK   - result of the 21-point Kronrod formula
!           RESKH  - Approximation to the mean value of f over (a,b),
!                    I.E. TO I/(b-a)
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
dhlgth = abs(hlgth)
!             Check if the interval (a,b) is too short
isig = 5
absc = abs(centr) + dhlgth*0.14
if (absc == abs(centr)) return
!           Compute the 21-point Kronrod approximation to
!           the integral, and estimate the absolute error.
isig = 0
resg = 0.0
fc = f(centr)
resk = wgk(11)*fc
resabs = abs(resk)
do j = 1,5
   jtw = 2*j
   absc = hlgth*xgk(jtw)
   fval1 = f(centr - absc)
   fval2 = f(centr + absc)
   fv1(jtw) = fval1
   fv2(jtw) = fval2
   fsum = fval1 + fval2
   resg = resg + wg(j)*fsum
   resk = resk + wgk(jtw)*fsum
   resabs = resabs + wgk(jtw)*(abs(fval1) + abs(fval2))
end do
do j = 1,5
   jtwm1 = 2*j - 1
   absc = hlgth*xgk(jtwm1)
   fval1 = f(centr - absc)
   fval2 = f(centr + absc)
   fv1(jtwm1) = fval1
   fv2(jtwm1) = fval2
   fsum = fval1 + fval2
   resk = resk + wgk(jtwm1)*fsum
   resabs = resabs + wgk(jtwm1)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5
resasc = wgk(11)*abs(fc - reskh)
do j = 1,10
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) + abs(fv2(j) - reskh))
end do
result = resk*hlgth
resabs = resabs*dhlgth
resasc = resasc*dhlgth
abserr = abs((resk - resg)*hlgth)
if (resasc /= 0.0 .and. abserr /= 0.0) &
   & abserr = resasc*min(1.0, &
   & (0.2e+03*abserr/resasc)**1.5)
tol = epmach*0.5e+02
if (resabs > uflow/tol) abserr = max(abserr,tol*resabs)
end subroutine qk21f

subroutine qagi(f, bound, inf, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
!! <!-- nswc-ford:begin QAGI -->
!! Reference for `qagi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                    Integration over infinite intervals
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            integral    I = Integral of  f  over (bound,+INFINITY)
!!                     or I = Integral of  f  over (-INFINITY,bound)
!!                     or I = Integral of  f  over (-INFINITY,+INFINITY),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - REAL
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X T E R N A L in the driver program.
!!             bound  - Real
!!                      finite bound of integration range
!!                      (has no meaning if interval is doubly-infinite)
!!             inf    - INTEGER
!!                      indicating the kind of integration range
!!                      involved
!!                      inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!!                      inf = -1            to  (-infinity,bound),
!!                      inf = 2             to (-infinity,+infinity).
!!             epsabs - REAL
!!                      absolute accuracy requested
!!             epsrel - REAL
!!                      relative accuracy requested
!!          on return
!!             result - Real
!!                      approximation to the integral
!!             abserr - REAL
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                    - ier.GT.0 abnormal termination of the routine. The
!!                              estimates for result and error are less
!!                              reliable. It is assumed that the requested
!!                              accuracy has not been achieved.
!!                      ier = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more
!!                              subdivisions by increasing the value
!!                              of limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of a local
!!                              difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the
!!                              subranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is
!!                              detected, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour occurs
!!                              at some points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              Roundoff error is detected in the
!!                              extrapolation table.
!!                              It is assumed that the requested tolerance
!!                              cannot be achieved, and that the returned
!!                              result is the best which can be obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted that
!!                              divergence can occur with any other value
!!                              of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative, limit .LT. 1,
!!                              OR lenw .LT. 4 * limit.
!!                              Result, abserr, neval, last are
!!                              set to zero.
!!          Dimensioning parameters
!!             limit - Integer
!!                     dimensioning parameter for iwork
!!                     limit determines the maximum number
!!                     of subintervals in the partition of the given
!!                     INTEGRATION INTERVAL (A,B), limit.GE.1.
!!                     If limit.LT.1, the routine will end with
!!                     ier = 6.
!!             lenw  - INTEGER
!!                     dimensioning parameter for work
!!                     lenw must be at least limit*4.
!!                     If lenw.LT.limit*4, the routine will end
!!                     with ier = 6.
!!             last  - Integer
!!                     on return, last equals the number of
!!                     subintervals produced in the subdivision
!!                     process, which determines the number of significant
!!                     elements actually in the work arrays.
!!          Work arrays
!!             iwork - INTEGER
!!                     vector of dimension at least limit, the first
!!                     K elements of which contain pointers
!!                     to the error estimates over the subintervals,
!!                     such that work(limit*3+iwork(1)),... ,
!!                     work(limit*3+iwork(K)) form a decreasing
!!                     sequence, with K = last if last.LE.(limit/2+2), and
!!                     K = limit+1-last otherwise
!!             work  - Real
!!                     vector of dimension at least lenw
!!                     on return
!!                     work(1), ..., work(last) contain the left
!!                      END POINTS OF THE SUBINTERVALS IN THE
!!                      partition of (A,B),
!!                     work(limit+1), ..., work(limit+last) contain
!!                      the right end points,
!!                     work(limit*2+1), ..., work(limit*2+last)
!!                      contain the integral approximations over
!!                      the subintervals,
!!                     work(limit*3+1), ..., work(limit*3+last)
!!                      contain the error estimates.
!!         Subroutines or functions needed
!!               - qagie
!!               - qk15i
!!               - qpsrt
!!               - qelg
!!               - f (user provided function)
!!               - spmpar
!!
!!          Check validity of limit and lenw.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(out) :: last
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
real, intent(out) :: abserr
real, intent(in) :: bound, epsabs, epsrel
real, intent(out) :: result
real :: f
real, intent(inout) :: work(lenw)
integer, intent(inout) :: iwork(limit)
external f
!     beginning of local variable declarations
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!                   Integration over infinite intervals
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            bound  - Real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of significant
!                    elements actually in the work arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first
!                    K elements of which contain pointers
!                    to the error estimates over the subintervals,
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!        Subroutines or functions needed
!              - qagie
!              - qk15i
!              - qpsrt
!              - qelg
!              - f (user provided function)
!              - spmpar
!-----------------------------------------------------------------------
!         Check validity of limit and lenw.
ier = 6
neval = 0
last = 0
result = 0.0
abserr = 0.0
if (limit < 1 .or. lenw < limit*4) return
!         Prepare call for qagie.
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
call qagie(f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
end subroutine qagi

subroutine qagie(f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
!! <!-- nswc-ford:begin QAGIE -->
!! Reference for `qagie`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                    Integration over infinite intervals
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            integral    I = Integral of  f  over (bound,+INFINITY)
!!                     or I = Integral of  f  over (-INFINITY,bound)
!!                     or I = Integral of  f  over (-INFINITY,+INFINITY),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - REAL
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X t E R N A L in the driver program.
!!             bound  - Real
!!                      finite bound of integration range
!!                      (has no meaning if interval is doubly-infinite)
!!             inf    - INTEGER
!!                      indicating the kind of integration range
!!                      involved
!!                      inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!!                      inf = -1            to  (-infinity,bound),
!!                      inf = 2             to (-infinity,+infinity).
!!             epsabs - REAL
!!                      absolute accuracy requested
!!             epsrel - REAL
!!                      relative accuracy requested
!!             limit  - Integer
!!                      gives an upper bound on the number of
!!                      subintervals in the partition of (A,B),
!!                      limit.GE.1
!!          on return
!!             result - Real
!!                      approximation to the integral
!!             abserr - REAL
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                    - ier.GT.0 abnormal termination of the routine. The
!!                              estimates for result and error are less
!!                              reliable. It is assumed that the requested
!!                              accuracy has not been achieved.
!!                      ier = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more
!!                              subdivisions by increasing the value
!!                              of limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of a local
!!                              difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the
!!                              subranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is
!!                              detected, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour occurs
!!                              at some points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              Roundoff error is detected in the
!!                              extrapolation table.
!!                              It is assumed that the requested tolerance
!!                              cannot be achieved, and that the returned
!!                              result is the best which can be obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted that
!!                              divergence can occur with any other value
!!                              of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative.
!!                              Result, abserr, neval, last, rlist(1),
!!                              elist(1) and iord(1) are set to zero.
!!                              alist(1) and blist(1) are set to 0
!!                              and 1 respectively.
!!             alist  - REAL
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the left
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the transformed integration range (0,1).
!!             blist  - REAL
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the right
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the transformed integration range (0,1).
!!             rlist  - REAL
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the integral
!!                      approximations on the subintervals
!!             elist  - REAL
!!                      vector of dimension at least limit,  the first
!!                       last  elements of which are the moduli
!!                      of the absolute error estimates on the
!!                      subintervals
!!             iord   - INTEGER
!!                      vector of dimension limit, the first k
!!                      elements of which are pointers to the
!!                      error estimates over the subintervals,
!!                      such that elist(iord(1)), ..., elist(iord(k))
!!                      form a decreasing sequence, with k = last
!!                      if last.LE.(limit/2+2), and k = limit+1-last
!!                      otherwise
!!             last   - INTEGER
!!                      number of subintervals actually produced
!!                      in the subdivision process
!!         subroutines or functions needed
!!               - qk15i
!!               - qpsrt
!!               - qelg
!!               - f (user-provided function)
!!               - spmpar
!!
!!             The dimension of rlist2 is determined by the value of
!!             LIMEXP in subroutine qelg.
!!             List of major variables
!!
!!            alist     - List of left end points of all subintervals
!!                        considered up to now
!!            blist     - List of right end points of all subintervals
!!                        considered up to now
!!            rlist(I)  - Approximation to the integral over
!!                        (alist(I),blist(I))
!!            rlist2    - Array of dimension at least (LIMEXP+2),
!!                        containing the part of the epsilon table
!!                        wich is still needed for further computations
!!            elist(I)  - Error estimate applying to rlist(I)
!!            maxerr    - Pointer to the interval with largest error
!!                        estimate
!!            errmax    - elist(maxerr)
!!            erlast    - Error on the interval currently subdivided
!!                        (before that subdivision has taken place)
!!            area      - Sum of the integrals over the subintervals
!!            ERRSUM    - Sum of the errors over the subintervals
!!            errbnd    - Requested accuracy max(epsabs,epsrel*
!!                        abs(result))
!!            *****1    - Variable for the left subinterval
!!            *****2    - Variable for the right subinterval
!!            last      - Index for subdivision
!!            nres      - Number of calls to the extrapolation routine
!!            numrl2    - Number of elements currently in rlist2. If an
!!                        appropriate approximation to the compounded
!!                        integral has been obtained, it is put in
!!                        rlist2(numrl2) after numrl2 has been increased
!!                        by one.
!!            small     - Length of the smallest interval considered up
!!                        to now, multiplied by 1.5
!!            erlarg    - Sum of the errors over the intervals larger
!!                        than the smallest interval considered up to now
!!            extrap    - Logical variable denoting that the routine
!!                        is attempting to perform extrapolation. I.E.
!!                        Before subdividing the smallest interval we
!!                        try to decrease the value of erlarg.
!!            noext     - Logical variable denoting that extrapolation
!!                        is no longer allowed (TRUE-VALUE)
!!             machine dependent constants
!!
!!            epmach is the largest relative spacing.
!!            uflow is the smallest positive magnitude.
!!            OFLOW is the largest positive magnitude.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!                   Integration over infinite intervals
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            bound  - Real
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     limit.GE.1
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             elist(1) and iord(1) are set to zero.
!                             alist(1) and blist(1) are set to 0
!                             and 1 respectively.
!            alist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!            blist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!            rlist  - REAL
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - REAL
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!            iord   - INTEGER
!                     vector of dimension limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!        subroutines or functions needed
!              - qk15i
!              - qpsrt
!              - qelg
!              - f (user-provided function)
!              - spmpar
!-----------------------------------------------------------------------
real, intent(out) :: abserr
real, intent(inout) :: alist
real, intent(inout) :: blist
real, intent(in) :: bound
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!     beginning of local variable declarations
real :: abseps, area, area1, area12, area2, a1, a2, boun, b1, b2, correc, defabs, defab1, defab2, dres, epmach, erlarg, erlast, &
   & errbnd, errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), small, t, uflow
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2
logical :: extrap, noext
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine qelg.
!            List of major variables
!            -----------------------
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left subinterval
!           *****2    - Variable for the right subinterval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered up
!                       to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (TRUE-VALUE)
!            machine dependent constants
!            ---------------------------
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!           Check epsabs and epsrel
!           -----------------------
neval = 0
last = 0
result = 0.0
abserr = 0.0
alist(1) = 0.0
blist(1) = 1.0
rlist(1) = 0.0
elist(1) = 0.0
iord(1) = 0
ier = 6
if (epsabs < 0.0 .or. epsrel < 0.0) go to 999
ier = 0
rerr = max(epsrel, 50.0*epmach, 0.5e-14)
!           First approximation to the integral
!           -----------------------------------
!           Determine the interval to be mapped onto (0,1).
!           If inf = 2 The integral is computed as I = I1+I2, where
!           I1 = Integral of f over (-INFINITY,0),
!           I2 = Integral of f over (0,+INFINITY).
boun = bound
if (inf == 2) boun = 0.0
call qk15i(f, boun, inf, 0.0, 1.0, result, abserr, &
   & defabs, resabs, epmach, uflow)
!           Test on accuracy
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
if (abserr <= 100.0*epmach*defabs .and. abserr > errbnd) &
   & ier = 2
if (limit == 1) ier = 1
if (ier /= 0 .or. (abserr <= errbnd .and. abserr /= resabs) &
   & .or. abserr == 0.0) go to 130
!           Initialization
!           --------------
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.0
nrmax = 1
nres = 0
ktmin = 0
numrl2 = 2
extrap = .false.
noext = .false.
ierro = 0
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres >= (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with nrmax-TH largest
!           error estimate.
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qk15i(f, boun, inf, a1, b1, area1, error1, &
      & resabs, defab1, epmach, uflow)
   call qk15i(f, boun, inf, a2, b2, area2, error2, &
      & resabs, defab2, epmach, uflow)
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1e-04*abs(area12) &
      & .or. erro12 < 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually
!           set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of
!           subintervals equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at some points of the integration range.

   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 0.1e+04*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
   alist(last) = a2
   blist(maxerr) = b1
   blist(last) = b2
   elist(maxerr) = error1
   elist(last) = error2
   go to 30
20 alist(maxerr) = a2
   alist(last) = a1
   blist(last) = b1
   rlist(maxerr) = area2
   rlist(last) = area1
   elist(maxerr) = error2
   elist(last) = error1
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
   if (errsum <= errbnd) go to 115
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro == 3 .or. erlarg <= ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (erlarg) and perform
!           extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg(numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1e-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
   if (abserr <= ertest) exit
!            Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
   maxerr = iord(1)
   errmax = elist(maxerr)
   nrmax = 1
   extrap = .false.
   small = small*0.5
   erlarg = errsum
   go to 90
80 small = 0.375
   erlarg = errsum
   ertest = errbnd
   rlist2(2) = area
90 continue
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.0 .and. area /= 0.0) go to 105
if (abserr > errsum) go to 115
if (area == 0.0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence
110 if (ksgn == -1 .and. max(abs(result),abs(area)) <= &
   & defabs*0.1e-01) go to 130
if (0.1e-01 > (result/area) .or. (result/area) > 0.1e+03 &
   & .or. errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf == 2) neval = 2*neval
if (ier > 2) ier = ier - 1
999 return
end subroutine qagie

subroutine qk15i(f, boun, inf, a, b, result, abserr, resabs, &
   & resasc, epmach, uflow)
!! <!-- nswc-ford:begin QK15I -->
!! Reference for `qk15i`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        PURPOSE
!!               the original (infinite) integration range is mapped
!!               onto the interval (0,1) and (a,b) is a part of (0,1).
!!               It is the purpose to compute
!!               I = Integral of transformed integrand over (a,b),
!!               j = Integral of abs(transformed integrand) over (a,b).
!!  2.        PARAMETERS
!!             on entry
!!               f      - REAL
!!                        function subprogram defining the integrand
!!                        function f(x). the actual name for f needs
!!                        to be declared E X T E R N A L in the
!!                        calling program.
!!               boun   - REAL
!!                        finite bound of original integration
!!                        RANGE (SET TO ZERO IF inf = +2)
!!               inf    - INTEGER
!!                        if inf = -1, the original interval is
!!                                    (-INFINITY,BOUND),
!!                        if inf = +1, the original interval is
!!                                    (BOUND,+INFINITY),
!!                        if inf = +2, the original interval is
!!                                    (-INFINITY,+INFINITY) and
!!                        the integral is computed as the sum of two
!!                        integrals, one over (-INFINITY,0)
!!                        and one over (0,+INFINITY).
!!               a      - REAL
!!                        lower limit for integration over subrange
!!                        of (0,1)
!!               b      - REAL
!!                        upper limit for integration over subrange
!!                        of (0,1)
!!               epmach - REAL
!!                        the relative precision of the floating
!!                        arithmetic being used.
!!               uflow  - REAL
!!                        the smallest positive magnitude.
!!             On return
!!               result - Real
!!                        approximation to the integral I
!!                        result is computed by applying the 15-point
!!                        Kronrod rule(RESK) obtained by optimal
!!                        addition of abscissae to the 7-point Gauss
!!                        RULE(RESG).
!!               abserr - REAL
!!                        estimate of the modulus of the absolute error,
!!                        which should equal or exceed abs(I-result)
!!               resabs - REAL
!!                        approximation to the integral j
!!               resasc - REAL
!!                        approximation to the integral of
!!                        abs((transformed integrand)-I/(b-a))
!!                        OVER (a,b)
!!  3.        SUBROUTINES OR FUNCTIONS NEEDED
!!                  - f (user-provided function)
!!
!!            The abscissae and weights are supplied for the interval
!!            (-1,1).  Because of symmetry only the positive abscissae and
!!            their corresponding weights are given.
!!            xgk    - Abscissae of the 15-point Kronrod rule
!!                     xgk(2), xgk(4), ... abscissae of the 7-point
!!                     Gauss rule
!!                     xgk(1), xgk(3), ...  abscissae which are optimally
!!                     added to the 7-point Gauss rule
!!            wgk    - Weights of the 15-point Kronrod rule
!!            wg     - Weights of the 7-point Gauss rule, corresponding
!!                     to the abscissae xgk(2), xgk(4), ...
!!                     wg(1), wg(3), ... are set to zero.
!!            List of major variables
!!
!!            centr  - Mid point of the interval
!!            HLGTH  - Half-length of the interval
!!            absc*  - ABSCISSA
!!            TABSC* - Transformed abscissa
!!            FVAL*  - Function VALUE
!!            RESG   - result of the 7-point Gauss formula
!!            RESK   - result of the 15-point Kronrod formula
!!            RESKH  - Approximation to the mean value of the transformed
!!                     integrand over (a,b), I.E. to I/(b-a)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: inf
real, intent(in) :: a
real, intent(inout) :: abserr
real, intent(in) :: b, boun, epmach
real, intent(inout) :: resabs, resasc, result
real, intent(in) :: uflow
real :: f
external f
!     beginning of local variable declarations
integer :: j
real :: absc, absc1, absc2, centr, dinf, fc, fsum, fval1, fval2, hlgth, resg, resk, reskh, tabsc1, tabsc2, tol, fv1(7), fv2(7)
real, parameter :: xgk(8) = [0.9914553711208126e+00, 0.9491079123427585e+00, 0.8648644233597691e+00, &
   & 0.7415311855993944e+00, 0.5860872354676911e+00, 0.4058451513773972e+00, 0.2077849550078985e+00, 0.0000000000000000e+00]
real, parameter :: wgk(8) = [0.2293532201052922e-01, 0.6309209262997855e-01, 0.1047900103222502e+00, &
   & 0.1406532597155259e+00, 0.1690047266392679e+00, 0.1903505780647854e+00, 0.2044329400752989e+00, 0.2094821410847278e+00]
real, parameter :: wg(8) = [0.0000000000000000e+00, 0.1294849661688697e+00, 0.0000000000000000e+00, 0.2797053914892767e+00 &
   & , 0.0000000000000000e+00, 0.3818300505051189e+00, 0.0000000000000000e+00, 0.4179591836734694e+00]
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (a,b) is a part of (0,1).
!              It is the purpose to compute
!              I = Integral of transformed integrand over (a,b),
!              j = Integral of abs(transformed integrand) over (a,b).
! 2.        PARAMETERS
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!              boun   - REAL
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF inf = +2)
!              inf    - INTEGER
!                       if inf = -1, the original interval is
!                                   (-INFINITY,BOUND),
!                       if inf = +1, the original interval is
!                                   (BOUND,+INFINITY),
!                       if inf = +2, the original interval is
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!              a      - REAL
!                       lower limit for integration over subrange
!                       of (0,1)
!              b      - REAL
!                       upper limit for integration over subrange
!                       of (0,1)
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!              uflow  - REAL
!                       the smallest positive magnitude.
!            On return
!              result - Real
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod rule(RESK) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(RESG).
!              abserr - REAL
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed abs(I-result)
!              resabs - REAL
!                       approximation to the integral j
!              resasc - REAL
!                       approximation to the integral of
!                       abs((transformed integrand)-I/(b-a))
!                       OVER (a,b)
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!-----------------------------------------------------------------------
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!           xgk    - Abscissae of the 15-point Kronrod rule
!                    xgk(2), xgk(4), ... abscissae of the 7-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!           wgk    - Weights of the 15-point Kronrod rule
!           wg     - Weights of the 7-point Gauss rule, corresponding
!                    to the abscissae xgk(2), xgk(4), ...
!                    wg(1), wg(3), ... are set to zero.
!           List of major variables
!           -----------------------
!           centr  - Mid point of the interval
!           HLGTH  - Half-length of the interval
!           absc*  - ABSCISSA
!           TABSC* - Transformed abscissa
!           FVAL*  - Function VALUE
!           RESG   - result of the 7-point Gauss formula
!           RESK   - result of the 15-point Kronrod formula
!           RESKH  - Approximation to the mean value of the transformed
!                    integrand over (a,b), I.E. to I/(b-a)
dinf = min(1,inf)
centr = 0.5*(a + b)
hlgth = 0.5*(b - a)
tabsc1 = boun + dinf*(1.0 - centr)/centr
fval1 = f(tabsc1)
if (inf == 2) fval1 = fval1 + f(-tabsc1)
fc = (fval1/centr)/centr
!           Compute the 15-point Kronrod approximation to
!           the integral, and estimate the error.
resg = wg(8)*fc
resk = wgk(8)*fc
resabs = abs(resk)
do j = 1,7
   absc = hlgth*xgk(j)
   absc1 = centr - absc
   absc2 = centr + absc
   tabsc1 = boun + dinf*(1.0 - absc1)/absc1
   tabsc2 = boun + dinf*(1.0 - absc2)/absc2
   fval1 = f(tabsc1)
   fval2 = f(tabsc2)
   if (inf == 2) fval1 = fval1 + f(-tabsc1)
   if (inf == 2) fval2 = fval2 + f(-tabsc2)
   fval1 = (fval1/absc1)/absc1
   fval2 = (fval2/absc2)/absc2
   fv1(j) = fval1
   fv2(j) = fval2
   fsum = fval1 + fval2
   resg = resg + wg(j)*fsum
   resk = resk + wgk(j)*fsum
   resabs = resabs + wgk(j)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5
resasc = wgk(8)*abs(fc - reskh)
do j = 1,7
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) + &
      & abs(fv2(j) - reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = abs((resk - resg)*hlgth)
if (resasc /= 0.0 .and. abserr /= 0.0) abserr = resasc* &
   & min(1.0, (0.2e+03*abserr/resasc)**1.5)
tol = 50.0*epmach
if (resabs > uflow/tol) abserr = max(abserr, tol*resabs)
end subroutine qk15i

subroutine qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!! <!-- nswc-ford:begin QPSRT -->
!! Reference for `qpsrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        qpsrt
!!            ordering routine
!!               standard Fortran subroutine
!!               real version
!!  2.        PURPOSE
!!               this routine maintains the descending ordering
!!               in the list of the local error estimates resulting from
!!               the interval subdivision process. At each call two error
!!               estimates are inserted using the sequential search
!!               method, top-down for the largest error estimate
!!               and bottom-up for the smallest error estimate.
!!  3.        CALLING SEQUENCE
!!               call qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!!            parameters (meaning at output)
!!               limit  - Integer
!!                        maximum number of error estimates the list
!!                        can contain
!!               last   - INTEGER
!!                        number of error estimates currently
!!                        in the list
!!               maxerr - Integer
!!                        maxerr points to the nrmax-TH largest error
!!                        estimate currently in the list
!!               ermax  - Real
!!                        nrmax-TH largest error estimate
!!                        ermax = elist(maxerr)
!!               elist  - Real
!!                        vector of dimension last containing
!!                        the error estimates
!!               iord   - INTEGER
!!                        vector of dimension last, the first k
!!                        elements of which contain pointers
!!                        to the error estimates, such that
!!                        elist(iord(1)),... , elist(iord(k))
!!                        form a decreasing sequence, with
!!                        k = last if last.LE.(limit/2+2), and
!!                        k = limit+1-last otherwise
!!               nrmax  - Integer
!!                        maxerr = iord(nrmax)
!!  4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!!
!!            Check whether the list contains more than
!!            two error estimates.
!! ***First executable statement  qpsrt
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     ..................................................................
! 1.        qpsrt
!           ordering routine
!              standard Fortran subroutine
!              real version
! 2.        PURPOSE
!              this routine maintains the descending ordering
!              in the list of the local error estimates resulting from
!              the interval subdivision process. At each call two error
!              estimates are inserted using the sequential search
!              method, top-down for the largest error estimate
!              and bottom-up for the smallest error estimate.
! 3.        CALLING SEQUENCE
!              call qpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!           parameters (meaning at output)
!              limit  - Integer
!                       maximum number of error estimates the list
!                       can contain
!              last   - INTEGER
!                       number of error estimates currently
!                       in the list
!              maxerr - Integer
!                       maxerr points to the nrmax-TH largest error
!                       estimate currently in the list
!              ermax  - Real
!                       nrmax-TH largest error estimate
!                       ermax = elist(maxerr)
!              elist  - Real
!                       vector of dimension last containing
!                       the error estimates
!              iord   - INTEGER
!                       vector of dimension last, the first k
!                       elements of which contain pointers
!                       to the error estimates, such that
!                       elist(iord(1)),... , elist(iord(k))
!                       form a decreasing sequence, with
!                       k = last if last.LE.(limit/2+2), and
!                       k = limit+1-last otherwise
!              nrmax  - Integer
!                       maxerr = iord(nrmax)
! 4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!     ..................................................................
real :: elist
real, intent(inout) :: ermax
integer, intent(inout) :: iord
integer, intent(in) :: last, limit
integer, intent(inout) :: maxerr, nrmax
dimension elist(last), iord(last)
!     beginning of local variable declarations
real :: errmax, errmin
integer :: i, ibeg, ido, isucc, j, jbnd, jupbn, k
!           Check whether the list contains more than
!           two error estimates.
!***First executable statement  qpsrt
if (last > 2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!           This part of the routine is only executed
!           if, due to a difficult integrand, subdivision
!           increased the error estimate. In the normal case
!           the insert procedure should start after the
!           nrmax-TH largest error estimate.
10 errmax = elist(maxerr)
if (nrmax == 1) go to 30
ido = nrmax - 1
do i = 1,ido
   isucc = iord(nrmax - 1)
! ***Jump out of do-loop
   if (errmax <= elist(isucc)) exit
   iord(nrmax) = isucc
   nrmax = nrmax - 1
end do
!           Compute the number of elements in the list to
!           be maintained in descending order. This number
!           depends on the number of subdivisions still
!           allowed.
30 jupbn = last
if (last > (limit/2 + 2)) jupbn = limit + 3 - last
errmin = elist(last)
!           Insert errmax by traversing the list top-down,
!           starting comparison from the element elist(iord(nrmax+1)).
jbnd = jupbn - 1
ibeg = nrmax + 1
if (ibeg > jbnd) go to 50
do i = ibeg,jbnd
   isucc = iord(i)
! ***Jump out of do-loop
   if (errmax >= elist(isucc)) go to 60
   iord(i - 1) = isucc
end do
50 iord(jbnd) = maxerr
iord(jupbn) = last
go to 90
!           Insert errmin by traversing the list bottom-up.
60 iord(i - 1) = maxerr
k = jbnd
do j = i,jbnd
   isucc = iord(k)
! ***Jump out of do-loop
   if (errmin < elist(isucc)) go to 80
   iord(k + 1) = isucc
   k = k - 1
end do
iord(i) = last
go to 90
80 iord(k + 1) = last
!           Set maxerr and ermax.
90 maxerr = iord(nrmax)
ermax = elist(maxerr)
end subroutine qpsrt

pure subroutine qelg(n, epstab, result, abserr, res3la, nres, &
   & epmach, oflow)
!! <!-- nswc-ford:begin QELG -->
!! Reference for `qelg`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        PURPOSE
!!               the routine determines the limit of a given sequence of
!!               approximations, by means of the epsilon algorithm
!!               of P. wynn.
!!               An estimate of the absolute error is also given.
!!               The condensed epsilon table is computed. Only those
!!               elements needed for the computation of the next diagonal
!!               are preserved.
!!  2.        PARAMETERS
!!               n      - INTEGER
!!                        epstab(n) contains the new element in the
!!                        first column of the epsilon table.
!!               epstab - REAL
!!                        vector of dimension 52 containing the
!!                        elements of the two lower diagonals of
!!                        the triangular epsilon table
!!                        the elements are numbered starting at the
!!                        right-hand corner of the triangle.
!!               result - Real
!!                        resulting approximation to the integral
!!               abserr - REAL
!!                        estimate of the absolute error computed from
!!                        result and the 3 previous results
!!               res3la - REAL
!!                        vector of dimension 3 containing the last 3
!!                        results
!!               nres   - INTEGER
!!                        number of calls to the routine
!!                        (should be zero at first call)
!!               epmach - REAL
!!                        the relative precision of the floating
!!                        arithmetic being used.
!!               oflow  - REAL
!!                        the largest positive magnitude.
!!  3.        NO SUBROUTINES OR FUNCTIONS USED
!!
!!            List of major variables
!!
!!            e0     - The 4 elements on which the
!!            e1       COMPUTATION OF A NEW ELEMENT IN
!!            e2       THE EPSILON TABLE IS BASED
!!            e3                 e0
!!                         e3    e1    NEW
!!                               e2
!!            newelm - Number of elements to be computed in the new
!!                     diagonal
!!            ERROR  - ERROR = abs(e1-e0)+abs(e2-e1)+abs(NEW-e2)
!!            result - The element in the new diagonal with least value
!!                     of error
!!            limexp is the maximum number of elements the epsilon
!!            table can contain. If this number is reached, the upper
!!            diagonal of the epsilon table is deleted.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(inout) :: n, nres
real, intent(out) :: abserr
real, intent(in) :: epmach, oflow
real, intent(out) :: result
real, intent(inout) :: epstab(52), res3la(3)
!     beginning of local variable declarations
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp, newelm, num
real :: delta1, delta2, delta3, e0, e1, e1abs, e2, e3, epsinf, &
   & err1, err2, err3, error, res, ss, tol1, tol2, tol3
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
! 2.        PARAMETERS
!              n      - INTEGER
!                       epstab(n) contains the new element in the
!                       first column of the epsilon table.
!              epstab - REAL
!                       vector of dimension 52 containing the
!                       elements of the two lower diagonals of
!                       the triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!              result - Real
!                       resulting approximation to the integral
!              abserr - REAL
!                       estimate of the absolute error computed from
!                       result and the 3 previous results
!              res3la - REAL
!                       vector of dimension 3 containing the last 3
!                       results
!              nres   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!              epmach - REAL
!                       the relative precision of the floating
!                       arithmetic being used.
!              oflow  - REAL
!                       the largest positive magnitude.
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!-----------------------------------------------------------------------
!---------------------
!           List of major variables
!           -----------------------
!           e0     - The 4 elements on which the
!           e1       COMPUTATION OF A NEW ELEMENT IN
!           e2       THE EPSILON TABLE IS BASED
!           e3                 e0
!                        e3    e1    NEW
!                              e2
!           newelm - Number of elements to be computed in the new
!                    diagonal
!           ERROR  - ERROR = abs(e1-e0)+abs(e2-e1)+abs(NEW-e2)
!           result - The element in the new diagonal with least value
!                    of error
!           limexp is the maximum number of elements the epsilon
!           table can contain. If this number is reached, the upper
!           diagonal of the epsilon table is deleted.
nres = nres + 1
abserr = oflow
result = epstab(n)
if (n < 3) go to 100
limexp = 50
epstab(n + 2) = epstab(n)
newelm = (n - 1)/2
epstab(n) = oflow
num = n
k1 = n
do i = 1,newelm
   k2 = k1 - 1
   k3 = k1 - 2
   res = epstab(k1 + 2)
   e0 = epstab(k3)
   e1 = epstab(k2)
   e2 = res
   e1abs = abs(e1)
   delta2 = e2 - e1
   err2 = abs(delta2)
   tol2 = max(abs(e2),e1abs)*epmach
   delta3 = e1 - e0
   err3 = abs(delta3)
   tol3 = max(e1abs,abs(e0))*epmach
   if (err2 > tol2 .or. err3 > tol3) go to 10
!           If e0, e1 and e2 are equal to within machine
!           accuracy, convergence is assumed.
!           result = e2
!           abserr = abs(e1-e0) + abs(e2-e1)
   result = res
   abserr = err2 + err3
! ***Jump out of do-loop
   go to 100
10 e3 = epstab(k1)
   epstab(k1) = e1
   delta1 = e1 - e3
   err1 = abs(delta1)
   tol1 = max(e1abs,abs(e3))*epmach
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of n
   if (err1 <= tol1 .or. err2 <= tol2 .or. err3 <= tol3) go to 20
   ss = 1.0/delta1 + 1.0/delta2 - 1.0/delta3
   epsinf = abs(ss*e1)
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF n.
   if (epsinf > 0.1e-03) go to 30
20 n = i + i - 1
! ***Jump out of do-loop
   exit
!           Compute a new element and eventually adjust
!           the value of result.
30 res = e1 + 1.0/ss
   epstab(k1) = res
   k1 = k1 - 2
   error = err2 + abs(res - e2) + err3
   if (error > abserr) go to 40
   abserr = error
   result = res
40 continue
end do
!           Shift the table.
if (n == limexp) n = 2*(limexp/2) - 1
ib = 1
if ((num/2)*2 == num) ib = 2
ie = newelm + 1
do i = 1,ie
   ib2 = ib + 2
   epstab(ib) = epstab(ib2)
   ib = ib2
end do
if (num == n) go to 80
indx = num - n + 1
do i = 1,n
   epstab(i) = epstab(indx)
   indx = indx + 1
end do
80 if (nres >= 4) go to 90
res3la(nres) = result
abserr = oflow
go to 100
!           Compute error estimate
90 abserr = abs(result - res3la(3)) + abs(result - res3la(2)) + &
   & abs(result - res3la(1))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = max(abserr,5.0*epmach*abs(result))
end subroutine qelg

subroutine qxgs(f,a,b,epsabs,epsrel,result,abserr,ier, &
   & limit,leniw,lenw,last,iwork,work)
!! <!-- nswc-ford:begin QXGS -->
!! Reference for `qxgs`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             The routine calculates an approximation result to a given
!!             definite integral  I = Integral of f over (a,b),
!!             hopefully satisfying following claim for accuracy
!!             abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - REAL
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X T E R N A L in the driver program.
!!             a      - REAL
!!                      lower limit of integration
!!             b      - REAL
!!                      upper limit of integration
!!             epsabs - REAL
!!                      absolute accuracy requested
!!             epsrel - REAL
!!                      relative accuracy requested
!!          on return
!!             result - Real
!!                      approximation to the integral
!!             abserr - REAL
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                      ier.GT.0 abnormal termination of the routine
!!                              the estimates for integral and error are
!!                              less reliable. It is assumed that the
!!                              requested accuracy has not been achieved.
!!             Error messages
!!                      ier = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more sub-
!!                              divisions by increasing the value of limit
!!                              (and taking the according dimension
!!                              adjustments into account. However, if
!!                              this yields no improvement it is advised
!!                              to analyze the integrand in order to
!!                              determine the integration difficulties. If
!!                              the position of a local difficulty can be
!!                              determined (E.G. singularity,
!!                              discontinuity within the interval) one
!!                              will probably gain from splitting up the
!!                              interval at this point and calling the
!!                              integrator on the subranges. If possible,
!!                              an appropriate special-purpose integrator
!!                              should be used, which is designed for
!!                              handling the type of difficulty involved.
!!                          = 2 The occurrence of roundoff error is DETEC-
!!                              ted, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour
!!                              occurs at some points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              Roundoff error is detected in the
!!                              extrapolation table. It is presumed that
!!                              the requested tolerance cannot be
!!                              achieved, and that the returned result is
!!                              the best which can be obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted that
!!                              divergence can occur with any other value
!!                              of ier.
!!                          = 6 The input is invalid because epsabs or
!!                              epsrel IS NEGATIVE, limit .LT. 1,
!!                              lenw .LT. 46*limit, OR
!!                              leniw .LT. 3*limit.
!!                              Result, abserr, last are set to
!!                              zero. Except when limit or lenw or leniw
!!                              is invalid, iwork(1), work(limit*2+1) and
!!                              work(limit*3+1) are set to zero, work(1)
!!                              is set to A, and work(limit+1) to b.
!!          Dimensioning parameters
!!             limit - Integer
!!                     limit determines the maximum number of subintervals
!!                     in the partition of the given integration interval
!!                     (A,b), limit.GE.1.
!!                     If limit.LT.1, the routine will end with ier = 6.
!!             lenw  - INTEGER
!!                     dimensioning parameter for work
!!                     lenw must be at least limit*46.
!!                     If lenw.LT.limit*46, the routine will end
!!                     with ier = 6.
!!             leniw - INTEGER
!!                     dimensioning parameter for iwork
!!                     leniw must be at least limit*3.
!!                     If lenw.LT.limit*3, the routine will end
!!                     with ier = 6.
!!             last  - Integer
!!                     on return, last equals the number of subintervals
!!                     produced in the subdivision process, which deter-
!!                     mines the number of significant elements actually
!!                     in the work arrays.
!!          Work arrays
!!             iwork - INTEGER
!!                     vector of dimension at least 3*limit, the first K
!!                     elements of which contain pointers
!!                     to the error estimates over the subintervals
!!                     such that work(limit*3+iwork(1)),... ,
!!                     work(limit*3+iwork(K)) form a decreasing
!!                     sequence, with K = last if last.LE.(limit/2+2),
!!                     and K = limit+1-last otherwise.
!!             work  - Real
!!                     vector of dimension at least lenw
!!                     on return
!!                     work(1), ..., work(last) contain the left
!!                      END-POINTS OF THE SUBINTERVALS IN THE
!!                      partition of (a,b),
!!                     work(limit+1), ..., work(limit+last) contain
!!                      the right end-points,
!!                     work(limit*2+1), ..., work(limit*2+last) contain
!!                      the integral approximations over the subintervals,
!!                     work(limit*3+1), ..., work(limit*3+last)
!!                      contain the error estimates.
!!                     work(limit*4+1), ... is the area reserved to store
!!                      functional values.
!!          Check validity of limit,leniw and lenw.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!            The routine calculates an approximation result to a given
!            definite integral  I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - REAL
!                     absolute accuracy requested
!            epsrel - REAL
!                     relative accuracy requested
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - REAL
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account. However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table. It is presumed that
!                             the requested tolerance cannot be
!                             achieved, and that the returned result is
!                             the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel IS NEGATIVE, limit .LT. 1,
!                             lenw .LT. 46*limit, OR
!                             leniw .LT. 3*limit.
!                             Result, abserr, last are set to
!                             zero. Except when limit or lenw or leniw
!                             is invalid, iwork(1), work(limit*2+1) and
!                             work(limit*3+1) are set to zero, work(1)
!                             is set to A, and work(limit+1) to b.
!         Dimensioning parameters
!            limit - Integer
!                    limit determines the maximum number of subintervals
!                    in the partition of the given integration interval
!                    (A,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*46.
!                    If lenw.LT.limit*46, the routine will end
!                    with ier = 6.
!            leniw - INTEGER
!                    dimensioning parameter for iwork
!                    leniw must be at least limit*3.
!                    If lenw.LT.limit*3, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of subintervals
!                    produced in the subdivision process, which deter-
!                    mines the number of significant elements actually
!                    in the work arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least 3*limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2),
!                    and K = limit+1-last otherwise.
!            work  - Real
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END-POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end-points,
!                    work(limit*2+1), ..., work(limit*2+last) contain
!                     the integral approximations over the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!                    work(limit*4+1), ... is the area reserved to store
!                     functional values.
real :: a
real, intent(out) :: abserr
real :: b
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(out) :: last
integer, intent(in) :: leniw, lenw, limit
external f
dimension iwork(leniw), work(lenw)
!     beginning of local variable declarations
integer :: l1, l2, l3, l4, l5
!         Check validity of limit,leniw and lenw.
ier = 6
last = 0
result = 0.0
abserr = 0.0
if (limit < 1 .or. leniw < limit*3 .or. lenw < limit*46) &
   & return
!         Prepare call for qxgse.
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
l4 = limit + l3
l5 = 21*limit + l4
call qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last, &
   & work(l4),work(l5),iwork(l1),iwork(l2))
end subroutine qxgs

subroutine qxgse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & ier,alist,blist,rlist,elist,iord,last,valp,valn,lp,ln)
!! <!-- nswc-ford:begin QXGSE -->
!! Reference for `qxgse`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             The routine calculates an approximation result to A
!!             definite integral I = Integral of f over (a,b),
!!             hopefully satisfying following claim for accuracy
!!             abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - REAL
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X t E R N A L in the driver program.
!!             a      - REAL
!!                      lower limit of integration
!!             b      - REAL
!!                      upper limit of integration
!!             epsabs - Real
!!                      absolute accuracy requested
!!             epsrel - Real
!!                      relative accuracy requested
!!             limit  - Integer
!!                      gives an upperbound on the number of subintervals
!!                      in the partition of (a,b)
!!          on return
!!             result - Real
!!                      approximation to the integral
!!             abserr - Real
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                      ier.GT.0 abnormal termination of the routine
!!                              the estimates for integral and error are
!!                              less reliable. It is assumed that the
!!                              requested accuracy has not been achieved.
!!             Error messages
!!                          = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more sub-
!!                              divisions by increasing the value of limit
!!                              (and taking the according dimension
!!                              adjustments into account). However, if
!!                              this yields no improvement it is advised
!!                              to analyze the integrand in order to
!!                              determine the integration difficulties. If
!!                              the position of a local difficulty can be
!!                              determined (E.G. singularity,
!!                              discontinuity within the interval) one
!!                              will probably gain from splitting up the
!!                              interval at this point and calling the
!!                              integrator on the subranges. If possible,
!!                              an appropriate special-purpose integrator
!!                              should be used, which is designed for
!!                              handling the type of difficulty involved.
!!                          = 2 The occurrence of roundoff error is DETEC-
!!                              ted, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour
!!                              occurs at some points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              Roundoff error is detected in the
!!                              extrapolation table.
!!                              It is presumed that the requested
!!                              tolerance cannot be achieved, and that the
!!                              returned result is the best which can be
!!                              obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted that
!!                              divergence can occur with any other value
!!                              of ier.
!!                          = 6 The input is invalid because epsabs or
!!                              epsrel is negative. Result, abserr,
!!                              last, rlist(1), iord(1), and elist(1)
!!                              are set to zero. alist(1) and blist(1)
!!                              are set to A and b respectively.
!!             alist  - Real
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the left end points
!!                      of the subintervals in the partition of the
!!                      given integration range (a,b)
!!             blist  - Real
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the right end points
!!                      of the subintervals in the partition of the given
!!                      integration range (a,b)
!!             rlist  - Real
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the integral
!!                      approximations on the subintervals
!!             elist  - Real
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the moduli of the
!!                      absolute error estimates on the subintervals
!!             iord   - INTEGER
!!                      vector of dimension at least limit, the first k
!!                      elements of which are pointers to the
!!                      error estimates over the subintervals,
!!                      such that elist(iord(1)), ..., elist(iord(k))
!!                      form a decreasing sequence, with k = last
!!                      if last.LE.(limit/2+2), and k = limit+1-last
!!                      otherwise
!!             last   - INTEGER
!!                      number of subintervals actually produced in the
!!                      subdivision process
!!             valp   - REAL
!!             valn     ARRAYS OF DIMENSION AT LEAST (21,limit) USED TO
!!                      save the functional values
!!             lp     - INTEGER
!!             ln       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!!                      store the actual number of functional values
!!                      saved in the corresponding column
!!                      of valp,valn
!! ***routines called  f,spmpar,qelg,qxlqm,qpsrt,qxrrd,qxcpy
!!             Machine dependent constants
!!
!!           epmach is the largest relative spacing.
!!           uflow is the smallest positive magnitude.
!!           OFLOW is the largest positive magnitude.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!            The routine calculates an approximation result to A
!            definite integral I = Integral of f over (a,b),
!            hopefully satisfying following claim for accuracy
!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - REAL
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            a      - REAL
!                     lower limit of integration
!            b      - REAL
!                     upper limit of integration
!            epsabs - Real
!                     absolute accuracy requested
!            epsrel - Real
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upperbound on the number of subintervals
!                     in the partition of (a,b)
!         on return
!            result - Real
!                     approximation to the integral
!            abserr - Real
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!            Error messages
!                         = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of limit
!                             (and taking the according dimension
!                             adjustments into account). However, if
!                             this yields no improvement it is advised
!                             to analyze the integrand in order to
!                             determine the integration difficulties. If
!                             the position of a local difficulty can be
!                             determined (E.G. singularity,
!                             discontinuity within the interval) one
!                             will probably gain from splitting up the
!                             interval at this point and calling the
!                             integrator on the subranges. If possible,
!                             an appropriate special-purpose integrator
!                             should be used, which is designed for
!                             handling the type of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs or
!                             epsrel is negative. Result, abserr,
!                             last, rlist(1), iord(1), and elist(1)
!                             are set to zero. alist(1) and blist(1)
!                             are set to A and b respectively.
!            alist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left end points
!                     of the subintervals in the partition of the
!                     given integration range (a,b)
!            blist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right end points
!                     of the subintervals in the partition of the given
!                     integration range (a,b)
!            rlist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - Real
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli of the
!                     absolute error estimates on the subintervals
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!            valp   - REAL
!            valn     ARRAYS OF DIMENSION AT LEAST (21,limit) USED TO
!                     save the functional values
!            lp     - INTEGER
!            ln       VECTORS OF DIMENSION AT LEAST LIMIT, USED TO
!                     store the actual number of functional values
!                     saved in the corresponding column
!                     of valp,valn
!***routines called  f,spmpar,qelg,qxlqm,qpsrt,qxrrd,qxcpy
real :: a
real, intent(out) :: abserr
real, intent(inout) :: alist
real :: b
real, intent(inout) :: blist
real, intent(inout) :: elist
real, intent(in) :: epsabs, epsrel
real :: f
real, intent(out) :: result
real, intent(inout) :: rlist
real, intent(inout) :: valp, valn
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(inout) :: lp(limit), ln(limit)
external f
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit), valp(21,limit), valn(21,limit)
!     beginning of local variable declarations
real :: abseps, area, area1, area12, area2, a1, a2, b1, b2, correc, defabs, defab1, defab2, dres, epmach, erlarg, erlast, errbnd, &
   & errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), small, t, uflow, vp1(21), &
   & vp2(21), vn1(21), vn2(21)
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2, lp1, lp2, ln1, ln2
logical :: extrap, noext
interface
   pure elemental function spmpar(i)
      implicit none
      integer, intent(in) :: i
      real :: spmpar
   end function spmpar
end interface
!            Machine dependent constants
!            ---------------------------
!          epmach is the largest relative spacing.
!          uflow is the smallest positive magnitude.
!          OFLOW is the largest positive magnitude.
epmach = spmpar(1)
uflow = spmpar(2)
oflow = spmpar(3)
!            Test on validity of parameters
!            ------------------------------
last = 0
result = 0.0
abserr = 0.0
alist(1) = a
blist(1) = b
rlist(1) = 0.0
elist(1) = 0.0
ier = 6
if (epsabs < 0.0 .or. epsrel < 0.0) go to 999
ier = 0
rerr = max(epsrel, 50.0*epmach)
!           First approximation to the integral
!           -----------------------------------
ierro = 0
lp(1) = 1
ln(1) = 1
valp(1,1) = f((a + b)*0.5)
valn(1,1) = valp(1,1)
call qxlqm(f,a,b,result,abserr,defabs,resabs, &
   & valp(1,1),valn(1,1),lp(1),ln(1),2, &
   & epmach,uflow,oflow)
!           Test on accuracy.
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr <= 100.0*epmach*defabs .and. abserr > &
   & errbnd) ier = 2
if (limit == 1) ier = 1
if (ier /= 0 .or. (abserr <= errbnd.and.abserr /= resabs) .or. &
   & abserr == 0.0) go to 999
!           Initialization
!           --------------
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
nrmax = 1
nres = 0
numrl2 = 2
ktmin = 0
extrap = .false.
noext = .false.
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres >= (1.0 - 50.0*epmach)*defabs) ksgn = 1
t = 1.0 + 100.0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with the nrmax-TH largest error
!           estimate.
   a1 = alist(maxerr)
   b1 = 0.5*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call qxrrd(f,valn(1,maxerr),ln(maxerr),b1,a1,vn1,vp1,ln1,lp1)
   call qxlqm(f,a1,b1,area1,error1,resabs,defab1,vp1,vn1,lp1,ln1, &
      & 2,epmach,uflow,oflow)
   call qxrrd(f,valp(1,maxerr),lp(maxerr),a2,b2,vp2,vn2,lp2,ln2)
   call qxlqm(f,a2,b2,area2,error2,resabs,defab2,vp2,vn2,lp2,ln2, &
      & 2,epmach,uflow,oflow)
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1e-04*abs(area12) &
      & .or. erro12 < 0.99*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of subintervals
!           equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 1.e+03*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
   alist(last) = a2
   blist(maxerr) = b1
   blist(last) = b2
   elist(maxerr) = error1
   elist(last) = error2
   call qxcpy(valp(1,maxerr),vp1,lp1)
   lp(maxerr) = lp1
   call qxcpy(valn(1,maxerr),vn1,ln1)
   ln(maxerr) = ln1
   call qxcpy(valp(1,last),vp2,lp2)
   lp(last) = lp2
   call qxcpy(valn(1,last),vn2,ln2)
   ln(last) = ln2
   go to 30
20 alist(maxerr) = a2
   alist(last) = a1
   blist(last) = b1
   rlist(maxerr) = area2
   rlist(last) = area1
   elist(maxerr) = error2
   elist(last) = error1
   call qxcpy(valp(1,maxerr),vp2,lp2)
   lp(maxerr) = lp2
   call qxcpy(valn(1,maxerr),vn2,ln2)
   ln(maxerr) = ln2
   call qxcpy(valp(1,last),vp1,lp1)
   lp(last) = lp1
   call qxcpy(valn(1,last),vn1,ln1)
   ln(last) = ln1
!           CALL SUBROUTINE qpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the subinterval
!           with nrmax-TH largest error estimate (to be bisected next).
30 call qpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum <= errbnd) go to 115
! ***Jump out of do-loop
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
!           The bound 0.3*ERTEST has been introduced to perform A
!           more cautious extrapolation than in the original dqagse
!           routine
40 if (ierro == 3 .or. erlarg <= 0.3*ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors over the
!           larger intervals (erlarg) and perform extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call qelg(numrl2,rlist2,reseps,abseps,res3la,nres, &
      & epmach,oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1e-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
! ***Jump out of do-loop
   if (abserr <= ertest) exit
!           Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
   maxerr = iord(1)
   errmax = elist(maxerr)
   nrmax = 1
   extrap = .false.
   small = small*0.5
   erlarg = errsum
   go to 90
80 small = abs(b - a)*0.375
   erlarg = errsum
   ertest = errbnd
   rlist2(2) = area
90 continue
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.0 .and. area /= 0.0) go to 105
if (abserr > errsum) go to 115
if (area == 0.0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence.
110 if (ksgn == (-1).and.max(abs(result),abs(area)) <= &
   & defabs*0.1e-01) go to 130
if (0.1e-01 > (result/area).or.(result/area) > 0.1e+03 &
   & .or.errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier > 2) ier = ier - 1
999 return
end subroutine qxgse

pure subroutine qxcpy(a, b, l)
!! <!-- nswc-ford:begin QXCPY -->
!! Reference for `qxcpy`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!   TO COPY THE REAL VECTOR b OF LENGTH l   i N T O
!!           the real vector a of length l
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: l
real, intent(inout) :: a(l)
real, intent(in) :: b(l)
!     beginning of local variable declarations
integer :: i
!  TO COPY THE REAL VECTOR b OF LENGTH l   i N T O
!          the real vector a of length l
do i = 1,l
   a(i) = b(i)
end do
end subroutine qxcpy

subroutine qxlqm(f,a,b,result,abserr,resabs,resasc,vr,vs,lr,ls, &
   & key,epmach,uflow,oflow)
!! <!-- nswc-ford:begin QXLQM -->
!! Reference for `qxlqm`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             To compute I = Integral of f over (a,b), with error
!!                            estimate
!!                        J = Integral of abs(f) over (a,b)
!!            parameters
!!             on entry
!!               f      - REAL
!!                        function subprogram defining the integrand
!!                        function f(x). the actual name for f needs to be
!!                        declared E X t E R N A L in the driver program.
!!               a      - REAL
!!                        lower limit of integration
!!               b      - REAL
!!                        upper limit of integration
!!               vr     - REAL
!!                        vector of length lr containing the
!!                        saved  functional values of positive abscissas
!!               vs     - REAL
!!                        vector of length ls containing the
!!                        saved  functional values of negative abscissas
!!               lr     - INTEGER
!!               ls       NUMBER OF ELEMENTS IN
!!                        vr,vs respectively
!!             key    - INTEGER
!!                      key for choice of local integration rule
!!                      rms formulas are used with
!!                       13 - 19               Points if key.LT.1,
!!                       13 - 19 - (27)        points if key = 1,
!!                       13 - 19 - (27) - (41) points if key = 2,
!!                            19 -  27  - (41) points if key = 3,
!!                                  27  -  41  Points if key.GT.3.
!!                          (Rules) used if the function APPEARS
!!                          enough regular
!!               epmach - Real
!!                        the relative precision of the floating
!!                        arithmetic being used.
!!               uflow  - Real
!!                        the smallest positive magnitude.
!!               oflow  - Real
!!                        the largest positive magnitude.
!!             On return
!!               result - Real
!!                        approximation to the integral I
!!               abserr - Real
!!                        estimate of the modulus of the absolute error,
!!                        which should not exceed abs(I-result)
!!               resabs - Real
!!                        approximation to the integral J
!!               resasc - Real
!!                        approximation to the integral of abs(f-I/(b-a))
!!                        over (a,b)
!!               vr     - REAL
!!                        vector of length lr containing the
!!                        saved  functional values of positive abscissas
!!               vs     - REAL
!!                        vector of length ls containing the
!!                        saved  functional values of negative abscissas
!!               lr     - INTEGER
!!               ls       NUMBER OF ELEMENTS IN
!!                        vr,vs respectively
!! ***routines called  qxrul
!! ```
!! <!-- nswc-ford:end -->
implicit none
!            To compute I = Integral of f over (a,b), with error
!                           estimate
!                       J = Integral of abs(f) over (a,b)
!           parameters
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X t E R N A L in the driver program.
!              a      - REAL
!                       lower limit of integration
!              b      - REAL
!                       upper limit of integration
!              vr     - REAL
!                       vector of length lr containing the
!                       saved  functional values of positive abscissas
!              vs     - REAL
!                       vector of length ls containing the
!                       saved  functional values of negative abscissas
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTS IN
!                       vr,vs respectively
!            key    - INTEGER
!                     key for choice of local integration rule
!                     rms formulas are used with
!                      13 - 19               Points if key.LT.1,
!                      13 - 19 - (27)        points if key = 1,
!                      13 - 19 - (27) - (41) points if key = 2,
!                           19 -  27  - (41) points if key = 3,
!                                 27  -  41  Points if key.GT.3.
!                         (Rules) used if the function APPEARS
!                         enough regular
!              epmach - Real
!                       the relative precision of the floating
!                       arithmetic being used.
!              uflow  - Real
!                       the smallest positive magnitude.
!              oflow  - Real
!                       the largest positive magnitude.
!            On return
!              result - Real
!                       approximation to the integral I
!              abserr - Real
!                       estimate of the modulus of the absolute error,
!                       which should not exceed abs(I-result)
!              resabs - Real
!                       approximation to the integral J
!              resasc - Real
!                       approximation to the integral of abs(f-I/(b-a))
!                       over (a,b)
!              vr     - REAL
!                       vector of length lr containing the
!                       saved  functional values of positive abscissas
!              vs     - REAL
!                       vector of length ls containing the
!                       saved  functional values of negative abscissas
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTS IN
!                       vr,vs respectively
!***routines called  qxrul
real :: f
real, intent(in) :: a, b
real, intent(inout) :: result, abserr, resabs, resasc
real, intent(in) :: epmach, oflow, uflow
real, intent(inout) :: vr(21), vs(21)
integer, intent(in) :: key
integer, intent(inout) :: lr, ls
external f
!     beginning of local variable declarations
real :: t, resg, resk, errold
integer :: k, k0, k1, k2, key1
key1 = max(key ,  0)
key1 = min(key1,  4)
k0 = max(key1 - 2,0)
k1 = k0 + 1
k2 = min(key1 + 1,3)
call qxrul(f,a,b,resg,resabs,resasc,k0,k1,vr,vs,lr,ls)
errold = oflow
t = 10.0*epmach
do k = k1,k2
   call qxrul(f,a,b,resk,resabs,resasc,k,k1,vr,vs,lr,ls)
   result = resk
   abserr = abs(resk - resg)
   if (resasc /= 0.0 .and. abserr /= 0.0) &
      & abserr = resasc*min(1.0,(200.0*abserr/resasc)**1.5)
   if (resabs > uflow/t) abserr = max(t*resabs,abserr)
   resg = resk
   if (abserr > errold * 0.16) exit
   if (abserr < 1000.0 * epmach * resabs) exit
   errold = abserr
end do
end subroutine qxlqm

subroutine qxrul(f,xl,xu,y,ya,ym,ke,k1,fv1,fv2,l1,l2)
!! <!-- nswc-ford:begin QXRUL -->
!! Reference for `qxrul`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             To compute i = Integral of f over (A,B), with error
!!                            estimate
!!             and conditionally compute
!!                        j = Integral of abs(f) over (A,B)
!!                        by using an  rms rule
!!            parameters
!!             on entry
!!               f      - REAL
!!                        function subprogram defining the integrand
!!                        function f(x). the actual name for f needs to be
!!                        declared E X T E R N A L in the driver program.
!!               xl     - REAL
!!                        lower limit of integration
!!               xu     - REAL
!!                        upper limit of integration
!!               ke     - INTEGER
!!                      key for choice of local integration rule
!!                      an rms rule is used with
!!                          13      points if ke  = 2,
!!                          19      points if ke  = 3,
!!                          27      points if ke  = 4,
!!                          42      points if ke  = 5
!!               k1     INTEGER
!!                      value of key for which the additional estimates
!!                      ya, ym are to be computed
!!               fv1    - REAL
!!                        vector containing l1
!!                        saved  functional values of positive abscissas
!!               fv2    - REAL
!!                        vector containing l2
!!                        saved  functional values of negative abscissas
!!               l1     - INTEGER
!!               l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!!             on return
!!               y      - REAL
!!                        approximation to the integral i
!!                        result is computed by applying the
!!                        requested rms rule
!!               ya     - REAL
!!                        if key = k1  approximation to the integral j
!!                        ELSE UNCHANGED
!!               ym     - REAL
!!                        if key = k1  approximation to the integral of
!!                                       abs(f-i/(xu-xl)   OVER (xl,xu)
!!                        ELSE UNCHANGED
!!               fv1    - REAL
!!                        vector containing l1
!!                        saved  functional values of positive abscissas
!!               fv2    - REAL
!!                        vector containing l2
!!                        saved  functional values of negative abscissas
!!               l1     - INTEGER
!!               l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!!
!!    Number of nodes 13
!!    Number of nodes 19
!!    Number of nodes 27
!!    Number of nodes 41
!! ```
!! <!-- nswc-ford:end -->
implicit none
real :: f
real, intent(in) :: xl, xu
real, intent(out) :: y
real, intent(inout) :: ya, ym
real, intent(inout) :: fv1(21), fv2(21)
integer, intent(in) :: ke, k1
integer, intent(inout) :: l1, l2
external f
!     beginning of local variable declarations
integer :: i, is, k, ks, j
real :: ldl, y2, xx(41), aa, bb, c
integer, parameter :: istart(4) = [0, 7, 17, 31]
integer, parameter :: len(4) = [7, 10, 14, 21]
real, parameter :: ww(52) = [1.303262173284849021810473057638590518409112513421e-1, &
   & 2.390632866847646220320329836544615917290026806242e-1, 2.630626354774670227333506083741355715758124943143e-1, &
   & 2.186819313830574175167853094864355208948886875898e-1, 2.757897646642836865859601197607471574336674206700e-2, &
   & 1.055750100538458443365034879086669791305550493830e-1, 1.571194260595182254168429283636656908546309467968e-2, &
   & 1.298751627936015783241173611320651866834051160074e-1, 2.249996826462523640447834514709508786970828213187e-1, &
   & 1.680415725925575286319046726692683040162290325505e-1, 1.415567675701225879892811622832845252125600939627e-1, &
   & 1.006482260551160175038684459742336605269707889822e-1, 2.510604860724282479058338820428989444699235030871e-2, &
   & 9.402964360009747110031098328922608224934320397592e-3, 5.542699233295875168406783695143646338274805359780e-2, &
   & 9.986735247403367525720377847755415293097913496236e-2, 4.507523056810492466415880450799432587809828791196e-2, &
   & 6.300942249647773931746170540321811473310938661469e-2, 1.261383225537664703012999637242003647020326905948e-1, &
   & 1.273864433581028272878709981850307363453523117880e-1, 8.576500414311820514214087864326799153427368592787e-2, &
   & 7.102884842310253397447305465997026228407227220665e-2, 5.026383572857942403759829860675892897279675661654e-2, &
   & 4.683670010609093810432609684738393586390722052124e-3, 1.235837891364555000245004813294817451524633100256e-1, &
   & 1.148933497158144016800199601785309838604146040215e-1, 1.252575774226122633391477702593585307254527198070e-2, &
   & 1.239572396231834242194189674243818619042280816640e-1, 2.501306413750310579525950767549691151739047969345e-2, &
   & 4.915957918146130094258849161350510503556792927578e-2, 2.259167374956474713302030584548274729936249753832e-2, &
   & 6.362762978782724559269342300509058175967124446839e-2, 9.950065827346794643193261975720606296171462239514e-2, &
   & 7.048220002718565366098742295389607994441704889441e-2, 6.512297339398335645872697307762912795346716454337e-2, &
   & 3.998229150313659724790527138690215186863915308702e-2, 3.456512257080287509832054272964315588028252136044e-2, &
   & 2.212167975884114432760321569298651047876071264944e-3, 8.140326425945938045967829319725797511040878579808e-2, &
   & 6.583213447600552906273539578430361199084485578379e-2, 2.592913726450792546064232192976262988065252032902e-2, &
   & 1.187141856692283347609436153545356484256869129472e-1, 5.999947605385971985589674757013565610751028128731e-2, &
   & 5.500937980198041736910257988346101839062581489820e-2, 5.264422421764655969760271538981443718440340270116e-3, &
   & 1.533126874056586959338368742803997744815413565014e-2, 3.527159369750123100455704702965541866345781113903e-2, &
   & 5.000556431653955124212795201196389006184693561679e-2, 5.744164831179720106340717579281831675999717767532e-2, &
   & 1.598823797283813438301248206397233634639162043386e-2, 2.635660410220884993472478832884065450876913559421e-2, &
   & 1.196003937945541091670106760660561117114584656319e-2]
!            To compute i = Integral of f over (A,B), with error
!                           estimate
!            and conditionally compute
!                       j = Integral of abs(f) over (A,B)
!                       by using an  rms rule
!           parameters
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X T E R N A L in the driver program.
!              xl     - REAL
!                       lower limit of integration
!              xu     - REAL
!                       upper limit of integration
!              ke     - INTEGER
!                     key for choice of local integration rule
!                     an rms rule is used with
!                         13      points if ke  = 2,
!                         19      points if ke  = 3,
!                         27      points if ke  = 4,
!                         42      points if ke  = 5
!              k1     INTEGER
!                     value of key for which the additional estimates
!                     ya, ym are to be computed
!              fv1    - REAL
!                       vector containing l1
!                       saved  functional values of positive abscissas
!              fv2    - REAL
!                       vector containing l2
!                       saved  functional values of negative abscissas
!              l1     - INTEGER
!              l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!            on return
!              y      - REAL
!                       approximation to the integral i
!                       result is computed by applying the
!                       requested rms rule
!              ya     - REAL
!                       if key = k1  approximation to the integral j
!                       ELSE UNCHANGED
!              ym     - REAL
!                       if key = k1  approximation to the integral of
!                                      abs(f-i/(xu-xl)   OVER (xl,xu)
!                       ELSE UNCHANGED
!              fv1    - REAL
!                       vector containing l1
!                       saved  functional values of positive abscissas
!              fv2    - REAL
!                       vector containing l2
!                       saved  functional values of negative abscissas
!              l1     - INTEGER
!              l2       NUMBER OF ELEMENTS IN fv1,fv2  RESPECTIVELY
!------------------------
!------------------------
!------------------------
data xx(1)/.0                       /
data xx(2)/.25000000000000000000e+00/
data xx(3)/.50000000000000000000e+00/
data xx(4)/.75000000000000000000e+00/
data xx(5)/.87500000000000000000e+00/
data xx(6)/.93750000000000000000e+00/
data xx(7)/.10000000000000000000e+01/
data xx(8)/.37500000000000000000e+00/
data xx(9)/.62500000000000000000e+00/
data xx(10)/.96875000000000000000e+00/
data xx(11)/.12500000000000000000e+00/
data xx(12)/.68750000000000000000e+00/
data xx(13)/.81250000000000000000e+00/
data xx(14)/.98437500000000000000e+00/
data xx(15)/.18750000000000000000e+00/
data xx(16)/.31250000000000000000e+00/
data xx(17)/.43750000000000000000e+00/
data xx(18)/.56250000000000000000e+00/
data xx(19)/.84375000000000000000e+00/
data xx(20)/.90625000000000000000e+00/
data xx(21)/.99218750000000000000e+00/
!   Number of nodes 13
!   Number of nodes 19
!   Number of nodes 27
!   Number of nodes 41
!------------------------
k = ke + 1
is = istart(k)
ks = len(k)
ldl = xu - xl
bb = ldl*0.5
aa = xl + bb
y = 0.0
do i = 1,ks
   c = bb*xx(i)
   if (i > l1) fv1(i) = f(aa + c)
   if (i > l2) fv2(i) = f(aa - c)
   j = is + i
   y = y + (fv1(i) + fv2(i))*ww(j)
end do
y2 = y
y = y*bb
if (l1 < ks) l1 = ks
if (l2 < ks) l2 = ks
if (ke /= k1) return
ya = 0.0
do i = 1,ks
   j = is + i
   ya = ya + (abs(fv1(i)) + abs(fv2(i)))*ww(j)
end do
ya = ya*abs(bb)
y2 = y2*0.5
ym = 0.0
do i = 1,ks
   j = is + i
   ym = ym + (abs(fv1(i) - y2) + abs(fv2(i) - y2))*ww(j)
end do
ym = ym*abs(bb)
end subroutine qxrul

subroutine qxrrd(f,z,lz,xl,xu,r,s,lr,ls)
!! <!-- nswc-ford:begin QXRRD -->
!! Reference for `qxrrd`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!             To reorder the computed functional values before
!!             the bisection of an interval
!!            parameters
!!             on entry
!!               f      - REAL
!!                        function subprogram defining the integrand
!!                        function f(x). the actual name for f needs to be
!!                        declared E X T E r N A L in the driver program.
!!               xl     - REAL
!!                        lower limit of interval
!!               xu     - REAL
!!                        upper limit of interval
!!               z      - REAL
!!                        vector containing lz
!!                        saved  functional values
!!               lz     - INTEGER
!!                        number of elements in lz
!!             on return
!!               r      - REAL
!!               s        VECTORS CONTAINING lr, ls
!!                        saved  functional values for the new intervals
!!               lr     - INTEGER
!!               ls       NUMBER OF ELEMENTES IN r,s RESPECTIVELY
!! ***routines called  f
!! ```
!! <!-- nswc-ford:end -->
implicit none
!            To reorder the computed functional values before
!            the bisection of an interval
!           parameters
!            on entry
!              f      - REAL
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs to be
!                       declared E X T E r N A L in the driver program.
!              xl     - REAL
!                       lower limit of interval
!              xu     - REAL
!                       upper limit of interval
!              z      - REAL
!                       vector containing lz
!                       saved  functional values
!              lz     - INTEGER
!                       number of elements in lz
!            on return
!              r      - REAL
!              s        VECTORS CONTAINING lr, ls
!                       saved  functional values for the new intervals
!              lr     - INTEGER
!              ls       NUMBER OF ELEMENTES IN r,s RESPECTIVELY
!***routines called  f
real :: f
real, intent(inout) :: r(21), s(21)
real :: z(21)
real, intent(in) :: xu, xl
integer, intent(inout) :: lr, ls
integer, intent(in) :: lz
!     beginning of local variable declarations
real :: dlen, centr
dlen = (xu - xl)*0.5
centr = xl + dlen
r(1) = z(3)
r(2) = z(9)
r(3) = z(4)
r(4) = z(5)
r(5) = z(6)
r(6) = z(10)
r(7) = z(7)
s(1) = z(3)
s(2) = z(8)
s(3) = z(2)
s(7) = z(1)
if (lz > 11) go to 10
r(8) = f(centr + dlen*0.375)
r(9) = f(centr + dlen*0.625)
r(10) = f(centr + dlen*0.96875)
lr = 10
if (lz /= 11) s(4) = f(centr - dlen*0.75)
if (lz == 11) s(4) = z(11)
s(5) = f(centr - dlen*0.875)
s(6) = f(centr - dlen*0.9375)
s(8) = f(centr - dlen*0.375)
s(9) = f(centr - dlen*0.625)
s(10) = f(centr - dlen*0.96875)
ls = 10
return
10 r(8) = z(12)
r(9) = z(13)
r(10) = z(14)
lr = 10
s(4) = z(11)
s(5) = f(centr - dlen*0.875)
s(6) = f(centr - dlen*0.9375)
if (lz > 14) go to 20
s(8) = f(centr - dlen*0.375)
s(9) = f(centr - dlen*0.625)
s(10) = f(centr - dlen*0.96875)
ls = 10
return
20 r(11) = z(18)
r(12) = z(19)
r(13) = z(20)
r(14) = z(21)
lr = 14
s(8) = z(16)
s(9) = z(15)
s(10) = f(centr - dlen*0.96875)
s(11) = z(17)
ls = 11
end subroutine qxrrd

subroutine dqags(f, a, b, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
!! <!-- nswc-ford:begin DQAGS -->
!! Reference for `dqags`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!            Double precision computation of a definite integral
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            definite integral   I = Integral of  f  over (a,b),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - Double precision
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X T E R N A L in the driver program.
!!             a      - Double precision
!!                      lower limit of integration
!!             b      - Double precision
!!                      upper limit of integration
!!             epsabs - Double precision
!!                      absolute accuracy requested
!!             epsrel - Double precision
!!                      relative accuracy requested
!!          on return
!!             result - Double precision
!!                      approximation to the integral
!!             abserr - Double precision
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                      ier.GT.0 abnormal termination of the routine
!!                              the estimates for integral and error are
!!                              less reliable. It is assumed that the
!!                              requested accuracy has not been achieved.
!!                      ier = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more sub-
!!                              divisions by increasing the value of
!!                              limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of A
!!                              local difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the sub-
!!                              ranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is DETEC-
!!                              ted, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour
!!                              occurs at some  points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              It is presumed that the requested
!!                              tolerance cannot be achieved, and that the
!!                              returned result is the best which can be
!!                              obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted
!!                              that divergence can occur with any other
!!                              value of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative, limit .LT. 1,
!!                              OR lenw .LT. 4 * limit.
!!                              Result, abserr, neval, last are
!!                              set to zero.
!!          Dimensioning parameters
!!             limit - Integer
!!                     dimensioning parameter for iwork
!!                     limit determines the maximum number
!!                     of subintervals in the partition of the given
!!                     INTEGRATION INTERVAL (a,b), limit.GE.1.
!!                     If limit.LT.1, the routine will end with
!!                     ier = 6.
!!             lenw  - INTEGER
!!                     dimensioning parameter for work
!!                     lenw must be at least limit*4.
!!                     If lenw.LT.limit*4, the routine will end
!!                     with ier = 6.
!!             last  - Integer
!!                     on return, last equals the number of
!!                     subintervals produced in the subdivision
!!                     process, which determines the number of
!!                     significant elements actually in the work
!!                     arrays.
!!          Work arrays
!!             iwork - INTEGER
!!                     vector of dimension at least limit, the first K
!!                     elements of which contain pointers
!!                     to the error estimates over the subintervals
!!                     such that work(limit*3+iwork(1)),... ,
!!                     work(limit*3+iwork(K)) form a decreasing
!!                     sequence, with K = last if last.LE.(limit/2+2), and
!!                     K = limit+1-last otherwise
!!             work  - Double precision
!!                     vector of dimension at least lenw
!!                     on return
!!                     work(1), ..., work(last) contain the left
!!                      END POINTS OF THE SUBINTERVALS IN THE
!!                      partition of (a,b),
!!                     work(limit+1), ..., work(limit+last) contain
!!                      the right end points,
!!                     work(limit*2+1), ..., work(limit*2+last)
!!                      contain the integral approximations over
!!                      the subintervals,
!!                     work(limit*3+1), ..., work(limit*3+last)
!!                      contain the error estimates.
!!          Subroutines or functions needed
!!               - dqagse
!!               - dqk21
!!               - dqpsrt
!!               - dqelg
!!               - f (user-provided function)
!!               - dpmpar
!!
!!          Check validity of limit and lenw.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(out) :: last
double precision, intent(in) :: a
double precision, intent(out) :: abserr
double precision, intent(in) :: b, epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
external f
dimension iwork(limit), work(lenw)
!     beginning of local variable declarations
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!           Double precision computation of a definite integral
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            a      - Double precision
!                     lower limit of integration
!            b      - Double precision
!                     upper limit of integration
!            epsabs - Double precision
!                     absolute accuracy requested
!            epsrel - Double precision
!                     relative accuracy requested
!         on return
!            result - Double precision
!                     approximation to the integral
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (a,b), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of
!                    significant elements actually in the work
!                    arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first K
!                    elements of which contain pointers
!                    to the error estimates over the subintervals
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!            work  - Double precision
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (a,b),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!         Subroutines or functions needed
!              - dqagse
!              - dqk21
!              - dqpsrt
!              - dqelg
!              - f (user-provided function)
!              - dpmpar
!-----------------------------------------------------------------------
!         Check validity of limit and lenw.
ier = 6
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
if (limit < 1 .or. lenw < limit*4) return
!         Prepare call for dqagse.
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
call dqagse(f,a,b,epsabs,epsrel,limit,result,abserr,neval, &
   & ier,work(1),work(l1),work(l2),work(l3),iwork,last)
end subroutine dqags

subroutine dqagse(f,a,b,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
!! <!-- nswc-ford:begin DQAGSE -->
!! Reference for `dqagse`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!            Double precision computation of a definite integral
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            definite integral   I = Integral of  f  over (a,b),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - Double precision
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X t E R N A L in the driver program.
!!             a      - Double precision
!!                      lower limit of integration
!!             b      - Double precision
!!                      upper limit of integration
!!             epsabs - Double precision
!!                      absolute accuracy requested
!!             epsrel - Double precision
!!                      relative accuracy requested
!!             limit  - Integer
!!                      gives an upperbound on the number of
!!                      subintervals in the partition of (a,b)
!!          on return
!!             result - Double precision
!!                      approximation to the integral
!!             abserr - Double precision
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                      ier.GT.0 abnormal termination of the routine
!!                              the estimates for integral and error are
!!                              less reliable. It is assumed that the
!!                              requested accuracy has not been achieved.
!!                          = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more sub-
!!                              divisions by increasing the value of
!!                              limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of A
!!                              local difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the sub-
!!                              ranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is DETEC-
!!                              ted, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour
!!                              occurs at some  points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              It is presumed that the requested
!!                              tolerance cannot be achieved, and that the
!!                              returned result is the best which can be
!!                              obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted
!!                              that divergence can occur with any other
!!                              value of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative.
!!                              Result, abserr, neval, last, rlist(1),
!!                              iord(1) and elist(1) are set to zero.
!!                              alist(1) and blist(1) are set to A and b
!!                              respectively.
!!             alist  - Double precision
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the left
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the given integration range (a,b)
!!             blist  - Double precision
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the right
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the given integration range (a,b)
!!             rlist  - Double precision
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the integral
!!                      approximations on the subintervals
!!             elist  - Double precision
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the moduli
!!                      of the absolute error estimates on the
!!                      SUBINERVALS
!!             iord   - INTEGER
!!                      vector of dimension at least limit, the first k
!!                      elements of which are pointers to the error
!!                      estimates over the subintervals, such
!!                      THAT elist(iord(1)), ..., elist(iord(k))
!!                      form a decreasing sequence, with k = last
!!                      if last.LE.(limit/2+2), and k = limit+1-last
!!                      otherwise
!!             last   - INTEGER
!!                      number of subintervals actually produced in the
!!                      subdivision process
!!          subroutines or functions needed
!!               - dqk21
!!               - dqpsrt
!!               - dqelg
!!               - f (user-provided function)
!!               - dpmpar
!!
!!             The dimension of rlist2 is determined by the value of
!!             LIMEXP in subroutine dqelg (rlist2 should be of dimension
!!             (LIMEXP+2) at least).
!!             List of major variables
!!
!!            alist     - List of left end points of all subintervals
!!                        considered up to now
!!            blist     - List of right end points of all subintervals
!!                        considered up to now
!!            rlist(I)  - Approximation to the integral over
!!                        (alist(I),blist(I))
!!            rlist2    - Array of dimension at least LIMEXP+2
!!                        containing the part of the epsilon table
!!                        which is still needed for further computations
!!            elist(I)  - Error estimate applying to rlist(I)
!!            maxerr    - Pointer to the interval with largest error
!!                        estimate
!!            errmax    - elist(maxerr)
!!            erlast    - Error on the interval currently subdivided
!!                        (before that subdivision has taken place)
!!            area      - Sum of the integrals over the subintervals
!!            ERRSUM    - Sum of the errors over the subintervals
!!            errbnd    - Requested accuracy max(epsabs,epsrel*
!!                        abs(result))
!!            *****1    - Variable for the left interval
!!            *****2    - Variable for the right interval
!!            last      - Index for subdivision
!!            nres      - Number of calls to the extrapolation routine
!!            numrl2    - Number of elements currently in rlist2. If an
!!                        appropriate approximation to the compounded
!!                        integral has been obtained it is put in
!!                        rlist2(numrl2) after numrl2 has been increased
!!                        by one.
!!            small     - Length of the smallest interval considered
!!                        up to now, multiplied by 1.5
!!            erlarg    - Sum of the errors over the intervals larger
!!                        than the smallest interval considered up to now
!!            extrap    - Logical variable denoting that the routine
!!                        is attempting to perform extrapolation
!!                        I.E. before subdividing the smallest interval
!!                        we try to decrease the value of erlarg.
!!            noext     - Logical variable denoting that extrapolation
!!                        is no longer allowed (true value)
!!             machine dependent constants
!!
!!            epmach is the largest relative spacing.
!!            uflow is the smallest positive magnitude.
!!            OFLOW is the largest positive magnitude.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!           Double precision computation of a definite integral
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           definite integral   I = Integral of  f  over (a,b),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            a      - Double precision
!                     lower limit of integration
!            b      - Double precision
!                     upper limit of integration
!            epsabs - Double precision
!                     absolute accuracy requested
!            epsrel - Double precision
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upperbound on the number of
!                     subintervals in the partition of (a,b)
!         on return
!            result - Double precision
!                     approximation to the integral
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                     ier.GT.0 abnormal termination of the routine
!                             the estimates for integral and error are
!                             less reliable. It is assumed that the
!                             requested accuracy has not been achieved.
!                         = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more sub-
!                             divisions by increasing the value of
!                             limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of A
!                             local difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the sub-
!                             ranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is DETEC-
!                             ted, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour
!                             occurs at some  points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             It is presumed that the requested
!                             tolerance cannot be achieved, and that the
!                             returned result is the best which can be
!                             obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted
!                             that divergence can occur with any other
!                             value of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             iord(1) and elist(1) are set to zero.
!                             alist(1) and blist(1) are set to A and b
!                             respectively.
!            alist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!            blist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the given integration range (a,b)
!            rlist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     SUBINERVALS
!            iord   - INTEGER
!                     vector of dimension at least limit, the first k
!                     elements of which are pointers to the error
!                     estimates over the subintervals, such
!                     THAT elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced in the
!                     subdivision process
!         subroutines or functions needed
!              - dqk21
!              - dqpsrt
!              - dqelg
!              - f (user-provided function)
!              - dpmpar
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision, intent(in) :: b
double precision, intent(inout) :: blist
double precision, intent(inout) :: elist
double precision, intent(in) :: epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!     beginning of local variable declarations
double precision :: abseps, area, area1, area12, area2, a1, a2, b1, b2, correc, defabs, defab1, defab2, dres, epmach, erlarg, &
   & erlast, errbnd, errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), small, t, &
   & uflow
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2
logical :: extrap, noext
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine dqelg (rlist2 should be of dimension
!            (LIMEXP+2) at least).
!            List of major variables
!            -----------------------
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least LIMEXP+2
!                       containing the part of the epsilon table
!                       which is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left interval
!           *****2    - Variable for the right interval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered
!                       up to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation
!                       I.E. before subdividing the smallest interval
!                       we try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (true value)
!            machine dependent constants
!            ---------------------------
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!            Check epsabs and epsrel
!            -----------------------
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
alist(1) = a
blist(1) = b
rlist(1) = 0.d0
elist(1) = 0.d0
ier = 6
if (epsabs < 0.d0 .or. epsrel < 0.d0) go to 999
ier = 0
rerr = max(epsrel, 50.d0*epmach, 0.5d-28)
!           First approximation to the integral
!           -----------------------------------
ierro = 0
call dqk21(f, a, b, result, abserr, defabs, resabs, &
   & epmach, uflow, id)
if (id /= 0) go to 999
neval = 21
!           Test on accuracy.
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
if (abserr <= 100.d0*epmach*defabs .and. abserr > &
   & errbnd) ier = 2
if (limit == 1) ier = 1
if (ier /= 0) go to 999
!           Initialization
!           --------------
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.d0
nrmax = 1
nres = 0
numrl2 = 2
ktmin = 0
extrap = .false.
noext = .false.
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres >= (1.d0 - 50.d0*epmach)*defabs) ksgn = 1
t = 1.d0 + 100.d0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with the nrmax-TH largest
!           error estimate.
   a1 = alist(maxerr)
   b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call dqk21(f, a1, b1, area1, error1, resabs, defab1, &
      & epmach, uflow, ier)
   if (ier /= 0) exit
   call dqk21(f, a2, b2, area2, error2, resabs, defab2, &
      & epmach, uflow, ier)
   neval = neval + 42
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1d-04*abs(area12) &
      & .or. erro12 < 0.99d0*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually
!           set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of
!           subintervals equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at a point of the integration range.
   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 0.1d+04*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
   alist(last) = a2
   blist(maxerr) = b1
   blist(last) = b2
   elist(maxerr) = error1
   elist(last) = error2
   go to 30
20 alist(maxerr) = a2
   alist(last) = a1
   blist(last) = b1
   rlist(maxerr) = area2
   rlist(last) = area1
   elist(maxerr) = error2
   elist(last) = error1
!           CALL SUBROUTINE dqpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
30 call dqpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
! ***Jump out of do-loop
   if (errsum <= errbnd) go to 115
! ***Jump out of do-loop
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro == 3 .or. erlarg <= ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (erlarg) and perform
!           extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
! ***Jump out of do-loop
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call dqelg(numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1d-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
! ***Jump out of do-loop
   if (abserr <= ertest) exit
!           Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
   maxerr = iord(1)
   errmax = elist(maxerr)
   nrmax = 1
   extrap = .false.
   small = small*0.5d0
   erlarg = errsum
   go to 90
80 small = abs(b - a)*0.375d0
   erlarg = errsum
   ertest = errbnd
   rlist2(2) = area
90 continue
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.d0 .and. area /= 0.d0) go to 105
if (abserr > errsum) go to 115
if (area == 0.d0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence.
110 if (ksgn == -1 .and. max(abs(result),abs(area)) <= &
   & defabs*0.1d-01) go to 130
if (0.1d-01 > (result/area) .or. (result/area) > 0.1d+03 &
   & .or. errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 if (ier > 2) ier = ier - 1
999 return
end subroutine dqagse

subroutine dqk21(f, a, b, result, abserr, resabs, resasc, &
   & epmach, uflow, isig)
!! <!-- nswc-ford:begin DQK21 -->
!! Reference for `dqk21`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        PURPOSE
!!               to compute I = Integral of f over (a,b), with error
!!                              estimate
!!                          j = Integral of dabs(f) over (a,b)
!!  2.        PARAMETERS
!!             on entry
!!               f      - Double precision
!!                        function subprogram defining the integrand
!!                        function f(x). the actual name for f needs
!!                        to be declared E X T E R N A L in the
!!                        calling program.
!!               a      - Double precision
!!                        lower limit of integration
!!               b      - Double precision
!!                        upper limit of integration
!!               epmach - Double precision
!!                        the relative precision of the floating
!!                        arithmetic being used.
!!               uflow  - Double precision
!!                        the smallest positive magnitude.
!!             On return
!!               result - Double precision
!!                        approximation to the integral I
!!                        result is computed by applying the 21-point
!!                        Kronrod rule (resk) obtained by optimal
!!                        addition of abscissae to the 10-point Gauss
!!                        RULE (resg).
!!               abserr - Double precision
!!                        estimate of the modulus of the absolute error,
!!                        which should not exceed abs(I-result)
!!               resabs - Double precision
!!                        approximation to the integral j
!!               resasc - Double precision
!!                        approximation to the integral of abs(f-I/(b-a))
!!                        OVER (a,b)
!!               isig   - INTEGER
!!                        isig=0  The integral was approximated.
!!                        isig=5  The interval (a,b) is too short.
!!                                The integral cannot be computed.
!!  3.        SUBROUTINES OR FUNCTIONS NEEDED
!!                  - f (user-provided function)
!!
!!            The abscissae and weights are given for the interval (-1,1).
!!            Because of symmetry only the positive abscissae and their
!!            corresponding weights are given.
!!            xgk    - Abscissae of the 21-point Kronrod rule
!!                     xgk(2), xgk(4), ...  abscissae of the 10-point
!!                     Gauss rule
!!                     xgk(1), xgk(3), ...  abscissae which are optimally
!!                     added to the 10-point Gauss rule
!!            wgk    - Weights of the 21-point Kronrod rule
!!            wg     - Weights of the 10-point Gauss rule
!!            List of major variables
!!
!!            centr  - Mid point of the interval
!!            HLGTH  - Half-length of the interval
!!            absc   - ABSCISSA
!!            FVAL*  - Function VALUE
!!            resg   - result of the 10-point Gauss formula
!!            resk   - result of the 21-point Kronrod formula
!!            reskh  - Approximation to the mean value of f over (a,b),
!!                     I.E. TO I/(b-a)
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              to compute I = Integral of f over (a,b), with error
!                             estimate
!                         j = Integral of dabs(f) over (a,b)
! 2.        PARAMETERS
!            on entry
!              f      - Double precision
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!              a      - Double precision
!                       lower limit of integration
!              b      - Double precision
!                       upper limit of integration
!              epmach - Double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!              uflow  - Double precision
!                       the smallest positive magnitude.
!            On return
!              result - Double precision
!                       approximation to the integral I
!                       result is computed by applying the 21-point
!                       Kronrod rule (resk) obtained by optimal
!                       addition of abscissae to the 10-point Gauss
!                       RULE (resg).
!              abserr - Double precision
!                       estimate of the modulus of the absolute error,
!                       which should not exceed abs(I-result)
!              resabs - Double precision
!                       approximation to the integral j
!              resasc - Double precision
!                       approximation to the integral of abs(f-I/(b-a))
!                       OVER (a,b)
!              isig   - INTEGER
!                       isig=0  The integral was approximated.
!                       isig=5  The interval (a,b) is too short.
!                               The integral cannot be computed.
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!-----------------------------------------------------------------------
double precision, intent(in) :: a
double precision, intent(inout) :: abserr
double precision, intent(in) :: b
double precision, intent(in) :: epmach
double precision :: f
double precision, intent(inout) :: resabs
double precision, intent(inout) :: result
double precision, intent(in) :: uflow
double precision, intent(inout) :: resasc
integer, intent(out) :: isig
external f
!     beginning of local variable declarations
double precision :: absc, centr, dhlgth, fc, fsum, fval1, fval2, fv1(10), fv2(10), hlgth, resg, resk, reskh, tol
integer :: j, jtw, jtwm1
double precision, parameter :: xgk(11) = [0.995657163025808080735527280689d+00, &
   & 0.973906528517171720077964012084d+00, 0.930157491355708226001207180060d+00, 0.865063366688984510732096688423d+00, &
   & 0.780817726586416897063717578345d+00, 0.679409568299024406234327365115d+00, 0.562757134668604683339000099273d+00, &
   & 0.433395394129247190799265943166d+00, 0.294392862701460198131126603104d+00, 0.148874338981631210884826001130d+00, &
   & 0.000000000000000000000000000000d+00]
double precision, parameter :: wgk(11) = [0.116946388673718742780643960622d-01, &
   & 0.325581623079647274788189724594d-01, 0.547558965743519960313813002446d-01, 0.750396748109199527670431409162d-01, &
   & 0.931254545836976055350654650834d-01, 0.109387158802297641899210590326d+00, 0.123491976262065851077958109831d+00, &
   & 0.134709217311473325928054001772d+00, 0.142775938577060080797094273139d+00, 0.147739104901338491374841515972d+00, &
   & 0.149445554002916905664936468390d+00]
double precision, parameter :: wg(5) = [0.666713443086881375935688098933d-01, &
   & 0.149451349150580593145776339658d+00, 0.219086362515982043995534934228d+00, 0.269266719309996355091226921569d+00, &
   & 0.295524224714752870173892994651d+00]
!           The abscissae and weights are given for the interval (-1,1).
!           Because of symmetry only the positive abscissae and their
!           corresponding weights are given.
!           xgk    - Abscissae of the 21-point Kronrod rule
!                    xgk(2), xgk(4), ...  abscissae of the 10-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 10-point Gauss rule
!           wgk    - Weights of the 21-point Kronrod rule
!           wg     - Weights of the 10-point Gauss rule
!           List of major variables
!           -----------------------
!           centr  - Mid point of the interval
!           HLGTH  - Half-length of the interval
!           absc   - ABSCISSA
!           FVAL*  - Function VALUE
!           resg   - result of the 10-point Gauss formula
!           resk   - result of the 21-point Kronrod formula
!           reskh  - Approximation to the mean value of f over (a,b),
!                    I.E. TO I/(b-a)
centr = 0.5d0*(a + b)
hlgth = 0.5d0*(b - a)
dhlgth = abs(hlgth)
!             Check if the interval (a,b) is too short
isig = 5
absc = abs(centr) + dhlgth*0.14d0
if (absc == abs(centr)) return
!           Compute the 21-point Kronrod approximation to
!           the integral, and estimate the absolute error.
isig = 0
resg = 0.d0
fc = f(centr)
resk = wgk(11)*fc
resabs = abs(resk)
do j = 1,5
   jtw = 2*j
   absc = hlgth*xgk(jtw)
   fval1 = f(centr - absc)
   fval2 = f(centr + absc)
   fv1(jtw) = fval1
   fv2(jtw) = fval2
   fsum = fval1 + fval2
   resg = resg + wg(j)*fsum
   resk = resk + wgk(jtw)*fsum
   resabs = resabs + wgk(jtw)*(abs(fval1) + abs(fval2))
end do
do j = 1,5
   jtwm1 = 2*j - 1
   absc = hlgth*xgk(jtwm1)
   fval1 = f(centr - absc)
   fval2 = f(centr + absc)
   fv1(jtwm1) = fval1
   fv2(jtwm1) = fval2
   fsum = fval1 + fval2
   resk = resk + wgk(jtwm1)*fsum
   resabs = resabs + wgk(jtwm1)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5d0
resasc = wgk(11)*abs(fc - reskh)
do j = 1,10
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) &
      & + abs(fv2(j) - reskh))
end do
result = resk*hlgth
resabs = resabs*dhlgth
resasc = resasc*dhlgth
abserr = abs((resk - resg)*hlgth)
if (resasc /= 0.d0 .and. abserr /= 0.d0) &
   & abserr = resasc*min(1.d0, &
   & (0.2d+03*abserr/resasc)**1.5d0)
tol = epmach*0.5d+02
if (resabs > uflow/tol) abserr = max(abserr,tol*resabs)
end subroutine dqk21

subroutine dqagi(f, bound, inf, epsabs, epsrel, result, abserr, &
   & neval, ier, limit, lenw, last, iwork, work)
!! <!-- nswc-ford:begin DQAGI -->
!! Reference for `dqagi`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!          Double precision integration over infinite intervals
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            integral    I = Integral of  f  over (bound,+INFINITY)
!!                     or I = Integral of  f  over (-INFINITY,bound)
!!                     or I = Integral of  f  over (-INFINITY,+INFINITY),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - Double precision
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X T E R N A L in the driver program.
!!             bound  - Double precision
!!                      finite bound of integration range
!!                      (has no meaning if interval is doubly-infinite)
!!             inf    - INTEGER
!!                      indicating the kind of integration range
!!                      involved
!!                      inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!!                      inf = -1            to  (-infinity,bound),
!!                      inf = 2             to (-infinity,+infinity).
!!             epsabs - Double precision
!!                      absolute accuracy requested
!!             epsrel - Double precision
!!                      relative accuracy requested
!!          on return
!!             result - Double precision
!!                      approximation to the integral
!!             abserr - Double precision
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                    - ier.GT.0 abnormal termination of the routine. The
!!                              estimates for result and error are less
!!                              reliable. It is assumed that the requested
!!                              accuracy has not been achieved.
!!                      ier = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more
!!                              subdivisions by increasing the value
!!                              of limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of a local
!!                              difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the
!!                              subranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is
!!                              detected, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour occurs
!!                              at some points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              Roundoff error is detected in the
!!                              extrapolation table.
!!                              It is assumed that the requested tolerance
!!                              cannot be achieved, and that the returned
!!                              result is the best which can be obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted that
!!                              divergence can occur with any other value
!!                              of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative, limit .LT. 1,
!!                              OR lenw .LT. 4 * limit.
!!                              Result, abserr, neval, last are
!!                              set to zero.
!!          Dimensioning parameters
!!             limit - Integer
!!                     dimensioning parameter for iwork
!!                     limit determines the maximum number
!!                     of subintervals in the partition of the given
!!                     INTEGRATION INTERVAL (A,B), limit.GE.1.
!!                     If limit.LT.1, the routine will end with
!!                     ier = 6.
!!             lenw  - INTEGER
!!                     dimensioning parameter for work
!!                     lenw must be at least limit*4.
!!                     If lenw.LT.limit*4, the routine will end
!!                     with ier = 6.
!!             last  - Integer
!!                     on return, last equals the number of
!!                     subintervals produced in the subdivision
!!                     process, which determines the number of significant
!!                     elements actually in the work arrays.
!!          Work arrays
!!             iwork - INTEGER
!!                     vector of dimension at least limit, the first
!!                     K elements of which contain pointers
!!                     to the error estimates over the subintervals,
!!                     such that work(limit*3+iwork(1)),... ,
!!                     work(limit*3+iwork(K)) form a decreasing
!!                     sequence, with K = last if last.LE.(limit/2+2), and
!!                     K = limit+1-last otherwise
!!             work  - Double precision
!!                     vector of dimension at least lenw
!!                     on return
!!                     work(1), ..., work(last) contain the left
!!                      END POINTS OF THE SUBINTERVALS IN THE
!!                      partition of (A,B),
!!                     work(limit+1), ..., work(limit+last) contain
!!                      the right end points,
!!                     work(limit*2+1), ..., work(limit*2+last)
!!                      contain the integral approximations over
!!                      the subintervals,
!!                     work(limit*3+1), ..., work(limit*3+last)
!!                      contain the error estimates.
!!         Subroutines or functions needed
!!               - dqagie
!!               - dqk15i
!!               - dqpsrt
!!               - dqelg
!!               - f (user provided function)
!!               - dpmpar
!!
!!          Check validity of limit and lenw.
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: inf
integer, intent(out) :: last
double precision, intent(out) :: abserr
double precision, intent(in) :: bound, epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: work
integer, intent(out) :: ier
integer, intent(inout) :: iwork
integer, intent(in) :: lenw, limit
integer, intent(out) :: neval
external f
dimension iwork(limit), work(lenw)
!     beginning of local variable declarations
integer :: l1, l2, l3
!-----------------------------------------------------------------------
!         Double precision integration over infinite intervals
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X T E R N A L in the driver program.
!            bound  - Double precision
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!            epsabs - Double precision
!                     absolute accuracy requested
!            epsrel - Double precision
!                     relative accuracy requested
!         on return
!            result - Double precision
!                     approximation to the integral
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative, limit .LT. 1,
!                             OR lenw .LT. 4 * limit.
!                             Result, abserr, neval, last are
!                             set to zero.
!         Dimensioning parameters
!            limit - Integer
!                    dimensioning parameter for iwork
!                    limit determines the maximum number
!                    of subintervals in the partition of the given
!                    INTEGRATION INTERVAL (A,B), limit.GE.1.
!                    If limit.LT.1, the routine will end with
!                    ier = 6.
!            lenw  - INTEGER
!                    dimensioning parameter for work
!                    lenw must be at least limit*4.
!                    If lenw.LT.limit*4, the routine will end
!                    with ier = 6.
!            last  - Integer
!                    on return, last equals the number of
!                    subintervals produced in the subdivision
!                    process, which determines the number of significant
!                    elements actually in the work arrays.
!         Work arrays
!            iwork - INTEGER
!                    vector of dimension at least limit, the first
!                    K elements of which contain pointers
!                    to the error estimates over the subintervals,
!                    such that work(limit*3+iwork(1)),... ,
!                    work(limit*3+iwork(K)) form a decreasing
!                    sequence, with K = last if last.LE.(limit/2+2), and
!                    K = limit+1-last otherwise
!            work  - Double precision
!                    vector of dimension at least lenw
!                    on return
!                    work(1), ..., work(last) contain the left
!                     END POINTS OF THE SUBINTERVALS IN THE
!                     partition of (A,B),
!                    work(limit+1), ..., work(limit+last) contain
!                     the right end points,
!                    work(limit*2+1), ..., work(limit*2+last)
!                     contain the integral approximations over
!                     the subintervals,
!                    work(limit*3+1), ..., work(limit*3+last)
!                     contain the error estimates.
!        Subroutines or functions needed
!              - dqagie
!              - dqk15i
!              - dqpsrt
!              - dqelg
!              - f (user provided function)
!              - dpmpar
!-----------------------------------------------------------------------
!         Check validity of limit and lenw.
ier = 6
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
if (limit < 1 .or. lenw < limit*4) return
!         Prepare call for dqagie
l1 = limit + 1
l2 = limit + l1
l3 = limit + l2
call dqagie(f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,work(1),work(l1),work(l2),work(l3),iwork,last)
end subroutine dqagi

subroutine dqagie(f,bound,inf,epsabs,epsrel,limit,result,abserr, &
   & neval,ier,alist,blist,rlist,elist,iord,last)
!! <!-- nswc-ford:begin DQAGIE -->
!! Reference for `dqagie`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!                    Integration over infinite intervals
!!
!!         Purpose
!!            the routine calculates an approximation  result  to a given
!!            integral    I = Integral of  f  over (bound,+INFINITY)
!!                     or I = Integral of  f  over (-INFINITY,bound)
!!                     or I = Integral of  f  over (-INFINITY,+INFINITY),
!!            hopefully satisfying following claim for accuracy
!!            abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!!         Parameters
!!          on entry
!!             f      - Double precision
!!                      function subprogram defining the integrand
!!                      function f(x). the actual name for f needs to be
!!                      declared E X t E R N A L in the driver program.
!!             bound  - Double precision
!!                      finite bound of integration range
!!                      (has no meaning if interval is doubly-infinite)
!!             inf    - INTEGER
!!                      indicating the kind of integration range
!!                      involved
!!                      inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!!                      inf = -1            to  (-infinity,bound),
!!                      inf = 2             to (-infinity,+infinity).
!!             epsabs - Double precision
!!                      absolute accuracy requested
!!             epsrel - Double precision
!!                      relative accuracy requested
!!             limit  - Integer
!!                      gives an upper bound on the number of
!!                      subintervals in the partition of (A,B),
!!                      limit.GE.1
!!          on return
!!             result - Double precision
!!                      approximation to the integral
!!             abserr - Double precision
!!                      estimate of the modulus of the absolute error,
!!                      which should equal or exceed abs(I-result)
!!             neval  - INTEGER
!!                      number of integrand evaluations
!!             ier    - INTEGER
!!                      ier = 0 Normal and reliable termination of the
!!                              routine. It is assumed that the requested
!!                              accuracy has been achieved.
!!                    - ier.GT.0 abnormal termination of the routine. The
!!                              estimates for result and error are less
!!                              reliable. It is assumed that the requested
!!                              accuracy has not been achieved.
!!                      ier = 1 Maximum number of subdivisions allowed
!!                              has been achieved. One can allow more
!!                              subdivisions by increasing the value
!!                              of limit (and taking the according
!!                              dimension adjustments into account).
!!                              However, if this yields no improvement
!!                              it is advised to analyze the integrand
!!                              in order to determine the integration
!!                              difficulties. If the position of a local
!!                              difficulty can be determined (E.G.
!!                              Singularity, discontinuity within the
!!                              interval) one will probably gain from
!!                              splitting up the interval at this point
!!                              and calling the integrator on the
!!                              subranges. If possible, an appropriate
!!                              special-purpose integrator should be used,
!!                              which is designed for handling the type
!!                              of difficulty involved.
!!                          = 2 The occurrence of roundoff error is
!!                              detected, which prevents the requested
!!                              tolerance from being achieved.
!!                              The error may be under-estimated.
!!                          = 3 Extremely bad integrand behaviour occurs
!!                              at some points of the integration
!!                              interval.
!!                          = 4 The algorithm does not converge.
!!                              Roundoff error is detected in the
!!                              extrapolation table.
!!                              It is assumed that the requested tolerance
!!                              cannot be achieved, and that the returned
!!                              result is the best which can be obtained.
!!                          = 5 The integral is probably divergent, or
!!                              slowly convergent. It must be noted that
!!                              divergence can occur with any other value
!!                              of ier.
!!                          = 6 The input is invalid because epsabs
!!                              or epsrel is negative.
!!                              Result, abserr, neval, last, rlist(1),
!!                              elist(1) and iord(1) are set to zero.
!!                              alist(1) and blist(1) are set to 0
!!                              and 1 respectively.
!!             alist  - Double precision
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the left
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the transformed integration range (0,1).
!!             blist  - Double precision
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the right
!!                      END POINTS OF THE SUBINTERVALS IN THE PARTITION
!!                      of the transformed integration range (0,1).
!!             rlist  - Double precision
!!                      vector of dimension at least limit, the first
!!                       last  elements of which are the integral
!!                      approximations on the subintervals
!!             elist  - Double precision
!!                      vector of dimension at least limit,  the first
!!                       last  elements of which are the moduli
!!                      of the absolute error estimates on the
!!                      subintervals
!!             iord   - INTEGER
!!                      vector of dimension limit, the first k
!!                      elements of which are pointers to the
!!                      error estimates over the subintervals,
!!                      such that elist(iord(1)), ..., elist(iord(k))
!!                      form a decreasing sequence, with k = last
!!                      if last.LE.(limit/2+2), and k = limit+1-last
!!                      otherwise
!!             last   - INTEGER
!!                      number of subintervals actually produced
!!                      in the subdivision process
!!         subroutines or functions needed
!!               - dqk15i
!!               - dqpsrt
!!               - dqelg
!!               - f (user-provided function)
!!               - dpmpar
!!
!!             The dimension of rlist2 is determined by the value of
!!             LIMEXP in subroutine dqelg.
!!             List of major variables
!!
!!            alist     - List of left end points of all subintervals
!!                        considered up to now
!!            blist     - List of right end points of all subintervals
!!                        considered up to now
!!            rlist(I)  - Approximation to the integral over
!!                        (alist(I),blist(I))
!!            rlist2    - Array of dimension at least (LIMEXP+2),
!!                        containing the part of the epsilon table
!!                        wich is still needed for further computations
!!            elist(I)  - Error estimate applying to rlist(I)
!!            maxerr    - Pointer to the interval with largest error
!!                        estimate
!!            errmax    - elist(maxerr)
!!            erlast    - Error on the interval currently subdivided
!!                        (before that subdivision has taken place)
!!            area      - Sum of the integrals over the subintervals
!!            ERRSUM    - Sum of the errors over the subintervals
!!            errbnd    - Requested accuracy max(epsabs,epsrel*
!!                        abs(result))
!!            *****1    - Variable for the left subinterval
!!            *****2    - Variable for the right subinterval
!!            last      - Index for subdivision
!!            nres      - Number of calls to the extrapolation routine
!!            numrl2    - Number of elements currently in rlist2. If an
!!                        appropriate approximation to the compounded
!!                        integral has been obtained, it is put in
!!                        rlist2(numrl2) after numrl2 has been increased
!!                        by one.
!!            small     - Length of the smallest interval considered up
!!                        to now, multiplied by 1.5
!!            erlarg    - Sum of the errors over the intervals larger
!!                        than the smallest interval considered up to now
!!            extrap    - Logical variable denoting that the routine
!!                        is attempting to perform extrapolation. I.E.
!!                        Before subdividing the smallest interval we
!!                        try to decrease the value of erlarg.
!!            noext     - Logical variable denoting that extrapolation
!!                        is no longer allowed (TRUE-VALUE)
!!             machine dependent constants
!!
!!            epmach is the largest relative spacing.
!!            uflow is the smallest positive magnitude.
!!            OFLOW is the largest positive magnitude.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
!                   Integration over infinite intervals
!-----------------------------------------------------------------------
!        Purpose
!           the routine calculates an approximation  result  to a given
!           integral    I = Integral of  f  over (bound,+INFINITY)
!                    or I = Integral of  f  over (-INFINITY,bound)
!                    or I = Integral of  f  over (-INFINITY,+INFINITY),
!           hopefully satisfying following claim for accuracy
!           abs(I-result).LE.max(epsabs,epsrel*abs(I)).
!        Parameters
!         on entry
!            f      - Double precision
!                     function subprogram defining the integrand
!                     function f(x). the actual name for f needs to be
!                     declared E X t E R N A L in the driver program.
!            bound  - Double precision
!                     finite bound of integration range
!                     (has no meaning if interval is doubly-infinite)
!            inf    - INTEGER
!                     indicating the kind of integration range
!                     involved
!                     inf = 1 CORRESPONDS TO  (bound,+INFINITY),
!                     inf = -1            to  (-infinity,bound),
!                     inf = 2             to (-infinity,+infinity).
!            epsabs - Double precision
!                     absolute accuracy requested
!            epsrel - Double precision
!                     relative accuracy requested
!            limit  - Integer
!                     gives an upper bound on the number of
!                     subintervals in the partition of (A,B),
!                     limit.GE.1
!         on return
!            result - Double precision
!                     approximation to the integral
!            abserr - Double precision
!                     estimate of the modulus of the absolute error,
!                     which should equal or exceed abs(I-result)
!            neval  - INTEGER
!                     number of integrand evaluations
!            ier    - INTEGER
!                     ier = 0 Normal and reliable termination of the
!                             routine. It is assumed that the requested
!                             accuracy has been achieved.
!                   - ier.GT.0 abnormal termination of the routine. The
!                             estimates for result and error are less
!                             reliable. It is assumed that the requested
!                             accuracy has not been achieved.
!                     ier = 1 Maximum number of subdivisions allowed
!                             has been achieved. One can allow more
!                             subdivisions by increasing the value
!                             of limit (and taking the according
!                             dimension adjustments into account).
!                             However, if this yields no improvement
!                             it is advised to analyze the integrand
!                             in order to determine the integration
!                             difficulties. If the position of a local
!                             difficulty can be determined (E.G.
!                             Singularity, discontinuity within the
!                             interval) one will probably gain from
!                             splitting up the interval at this point
!                             and calling the integrator on the
!                             subranges. If possible, an appropriate
!                             special-purpose integrator should be used,
!                             which is designed for handling the type
!                             of difficulty involved.
!                         = 2 The occurrence of roundoff error is
!                             detected, which prevents the requested
!                             tolerance from being achieved.
!                             The error may be under-estimated.
!                         = 3 Extremely bad integrand behaviour occurs
!                             at some points of the integration
!                             interval.
!                         = 4 The algorithm does not converge.
!                             Roundoff error is detected in the
!                             extrapolation table.
!                             It is assumed that the requested tolerance
!                             cannot be achieved, and that the returned
!                             result is the best which can be obtained.
!                         = 5 The integral is probably divergent, or
!                             slowly convergent. It must be noted that
!                             divergence can occur with any other value
!                             of ier.
!                         = 6 The input is invalid because epsabs
!                             or epsrel is negative.
!                             Result, abserr, neval, last, rlist(1),
!                             elist(1) and iord(1) are set to zero.
!                             alist(1) and blist(1) are set to 0
!                             and 1 respectively.
!            alist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the left
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!            blist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the right
!                     END POINTS OF THE SUBINTERVALS IN THE PARTITION
!                     of the transformed integration range (0,1).
!            rlist  - Double precision
!                     vector of dimension at least limit, the first
!                      last  elements of which are the integral
!                     approximations on the subintervals
!            elist  - Double precision
!                     vector of dimension at least limit,  the first
!                      last  elements of which are the moduli
!                     of the absolute error estimates on the
!                     subintervals
!            iord   - INTEGER
!                     vector of dimension limit, the first k
!                     elements of which are pointers to the
!                     error estimates over the subintervals,
!                     such that elist(iord(1)), ..., elist(iord(k))
!                     form a decreasing sequence, with k = last
!                     if last.LE.(limit/2+2), and k = limit+1-last
!                     otherwise
!            last   - INTEGER
!                     number of subintervals actually produced
!                     in the subdivision process
!        subroutines or functions needed
!              - dqk15i
!              - dqpsrt
!              - dqelg
!              - f (user-provided function)
!              - dpmpar
!-----------------------------------------------------------------------
double precision, intent(out) :: abserr
double precision, intent(inout) :: alist
double precision, intent(inout) :: blist
double precision, intent(in) :: bound
double precision, intent(inout) :: elist
double precision, intent(in) :: epsabs, epsrel
double precision :: f
double precision, intent(out) :: result
double precision, intent(inout) :: rlist
integer, intent(out) :: ier
integer, intent(in) :: inf
integer, intent(inout) :: iord
integer, intent(out) :: last
integer, intent(in) :: limit
integer, intent(out) :: neval
external f
dimension alist(limit), blist(limit), elist(limit), iord(limit), &
   & rlist(limit)
!     beginning of local variable declarations
double precision :: abseps, area, area1, area12, area2, a1, a2, boun, b1, b2, correc, defabs, defab1, defab2, dres, epmach, &
   & erlarg, erlast, errbnd, errmax, error1, error2, erro12, errsum, ertest, oflow, rerr, resabs, reseps, res3la(3), rlist2(52), &
   & small, t, uflow
integer :: id, ierro, iroff1, iroff2, iroff3, jupbnd, k, ksgn, ktmin, maxerr, nres, nrmax, numrl2
logical :: extrap, noext
interface
   pure elemental function dpmpar(i)
      implicit none
      integer, intent(in) :: i
      double precision :: dpmpar
   end function dpmpar
end interface
!            The dimension of rlist2 is determined by the value of
!            LIMEXP in subroutine dqelg.
!            List of major variables
!            -----------------------
!           alist     - List of left end points of all subintervals
!                       considered up to now
!           blist     - List of right end points of all subintervals
!                       considered up to now
!           rlist(I)  - Approximation to the integral over
!                       (alist(I),blist(I))
!           rlist2    - Array of dimension at least (LIMEXP+2),
!                       containing the part of the epsilon table
!                       wich is still needed for further computations
!           elist(I)  - Error estimate applying to rlist(I)
!           maxerr    - Pointer to the interval with largest error
!                       estimate
!           errmax    - elist(maxerr)
!           erlast    - Error on the interval currently subdivided
!                       (before that subdivision has taken place)
!           area      - Sum of the integrals over the subintervals
!           ERRSUM    - Sum of the errors over the subintervals
!           errbnd    - Requested accuracy max(epsabs,epsrel*
!                       abs(result))
!           *****1    - Variable for the left subinterval
!           *****2    - Variable for the right subinterval
!           last      - Index for subdivision
!           nres      - Number of calls to the extrapolation routine
!           numrl2    - Number of elements currently in rlist2. If an
!                       appropriate approximation to the compounded
!                       integral has been obtained, it is put in
!                       rlist2(numrl2) after numrl2 has been increased
!                       by one.
!           small     - Length of the smallest interval considered up
!                       to now, multiplied by 1.5
!           erlarg    - Sum of the errors over the intervals larger
!                       than the smallest interval considered up to now
!           extrap    - Logical variable denoting that the routine
!                       is attempting to perform extrapolation. I.E.
!                       Before subdividing the smallest interval we
!                       try to decrease the value of erlarg.
!           noext     - Logical variable denoting that extrapolation
!                       is no longer allowed (TRUE-VALUE)
!            machine dependent constants
!            ---------------------------
!           epmach is the largest relative spacing.
!           uflow is the smallest positive magnitude.
!           OFLOW is the largest positive magnitude.
epmach = dpmpar(1)
uflow = dpmpar(2)
oflow = dpmpar(3)
!           Check epsabs and epsrel
!           -----------------------
neval = 0
last = 0
result = 0.d0
abserr = 0.d0
alist(1) = 0.d0
blist(1) = 1.d0
rlist(1) = 0.d0
elist(1) = 0.d0
iord(1) = 0
ier = 6
if (epsabs < 0.d0 .or. epsrel < 0.d0) go to 999
ier = 0
rerr = max(epsrel, 50.d0*epmach, 0.5d-28)
!           First approximation to the integral
!           -----------------------------------
!           Determine the interval to be mapped onto (0,1).
!           If inf = 2 The integral is computed as I = I1+I2, where
!           I1 = Integral of f over (-INFINITY,0),
!           I2 = Integral of f over (0,+INFINITY).
boun = bound
if (inf == 2) boun = 0.d0
call dqk15i(f, boun, inf, 0.d0, 1.d0, result, abserr, &
   & defabs, resabs, epmach, uflow)
!           Test on accuracy
last = 1
rlist(1) = result
elist(1) = abserr
iord(1) = 1
dres = abs(result)
errbnd = max(epsabs,rerr*dres)
if (abserr <= 100.d0*epmach*defabs .and. abserr > errbnd) &
   & ier = 2
if (limit == 1) ier = 1
if (ier /= 0 .or. (abserr <= errbnd .and. abserr /= resabs) &
   & .or. abserr == 0.d0) go to 130
!           Initialization
!           --------------
rlist2(1) = result
errmax = abserr
maxerr = 1
area = result
errsum = abserr
abserr = oflow
correc = 0.d0
nrmax = 1
nres = 0
ktmin = 0
numrl2 = 2
extrap = .false.
noext = .false.
ierro = 0
iroff1 = 0
iroff2 = 0
iroff3 = 0
ksgn = -1
if (dres >= (1.d0 - 50.d0*epmach)*defabs) ksgn = 1
t = 1.d0 + 100.d0*epmach
!           Main do-loop
!           ------------
do last = 2,limit
!           Bisect the subinterval with nrmax-TH largest
!           error estimate.
   a1 = alist(maxerr)
   b1 = 0.5d0*(alist(maxerr) + blist(maxerr))
   a2 = b1
   b2 = blist(maxerr)
   erlast = errmax
   call dqk15i(f, boun, inf, a1, b1, area1, error1, &
      & resabs, defab1, epmach, uflow)
   call dqk15i(f, boun, inf, a2, b2, area2, error2, &
      & resabs, defab2, epmach, uflow)
!           Improve previous approximations to integral
!           and error and test for accuracy.
   area12 = area1 + area2
   erro12 = error1 + error2
   errsum = errsum + erro12 - errmax
   area = area + area12 - rlist(maxerr)
   if (defab1 == error1 .or. defab2 == error2) go to 15
   if (abs(rlist(maxerr) - area12) > 0.1d-04*abs(area12) &
      & .or. erro12 < 0.99d0*errmax) go to 10
   if (extrap) iroff2 = iroff2 + 1
   if (.not.extrap) iroff1 = iroff1 + 1
10 if (last > 10 .and. erro12 > errmax) iroff3 = iroff3 + 1
15 rlist(maxerr) = area1
   rlist(last) = area2
   errbnd = max(epsabs,rerr*abs(area))
!           Test for roundoff error and eventually
!           set error flag.
   if (iroff1 + iroff2 >= 10 .or. iroff3 >= 20) ier = 2
   if (iroff2 >= 5) ierro = 3
!           Set error flag in the case that the number of
!           subintervals equals limit.
   if (last == limit) ier = 1
!           Set error flag in the case of bad integrand behaviour
!           at some points of the integration range.

   if (max(abs(a1),abs(b2)) <= &
      & t*(abs(a2) + 0.1d+04*uflow)) ier = 4
!           Append the newly-created intervals to the list.
   if (error2 > error1) go to 20
   alist(last) = a2
   blist(maxerr) = b1
   blist(last) = b2
   elist(maxerr) = error1
   elist(last) = error2
   go to 30
20 alist(maxerr) = a2
   alist(last) = a1
   blist(last) = b1
   rlist(maxerr) = area2
   rlist(last) = area1
   elist(maxerr) = error2
   elist(last) = error1
!           CALL SUBROUTINE dqpsrt TO MAINTAIN THE DESCENDING ORDERING
!           in the list of error estimates and select the
!           subinterval with nrmax-TH largest error estimate (to be
!           bisected next).
30 call dqpsrt(limit,last,maxerr,errmax,elist,iord,nrmax)
   if (errsum <= errbnd) go to 115
   if (ier /= 0) exit
   if (last == 2) go to 80
   if (noext) go to 90
   erlarg = erlarg - erlast
   if (abs(b1 - a1) > small) erlarg = erlarg + erro12
   if (extrap) go to 40
!           Test whether the interval to be bisected next is the
!           smallest interval.
   if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
   extrap = .true.
   nrmax = 2
40 if (ierro == 3 .or. erlarg <= ertest) go to 60
!           The smallest interval has the largest error.
!           Before bisecting decrease the sum of the errors
!           over the larger intervals (erlarg) and perform
!           extrapolation.
   id = nrmax
   jupbnd = last
   if (last > (2 + limit/2)) jupbnd = limit + 3 - last
   do k = id,jupbnd
      maxerr = iord(nrmax)
      errmax = elist(maxerr)
      if (abs(blist(maxerr) - alist(maxerr)) > small) go to 90
      nrmax = nrmax + 1
   end do
!           Perform extrapolation.
60 numrl2 = numrl2 + 1
   rlist2(numrl2) = area
   call dqelg(numrl2, rlist2, reseps, abseps, res3la, nres, &
      & epmach, oflow)
   ktmin = ktmin + 1
   if (ktmin > 5 .and. abserr < 0.1d-02*errsum) ier = 5
   if (abseps >= abserr) go to 70
   ktmin = 0
   abserr = abseps
   result = reseps
   correc = erlarg
   ertest = max(epsabs,rerr*abs(reseps))
   if (abserr <= ertest) exit
!            Prepare bisection of the smallest interval.
70 if (numrl2 == 1) noext = .true.
   if (ier == 5) exit
   maxerr = iord(1)
   errmax = elist(maxerr)
   nrmax = 1
   extrap = .false.
   small = small*0.5d0
   erlarg = errsum
   go to 90
80 small = 0.375d0
   erlarg = errsum
   ertest = errbnd
   rlist2(2) = area
90 continue
end do
!           Set final result and error estimate.
!           ------------------------------------
if (abserr == oflow) go to 115
if (ier + ierro == 0) go to 110
if (ierro == 3) abserr = abserr + correc
if (ier == 0) ier = 3
if (result /= 0.d0 .and. area /= 0.d0) go to 105
if (abserr > errsum) go to 115
if (area == 0.d0) go to 130
go to 110
105 if (abserr/abs(result) > errsum/abs(area)) go to 115
!           Test on divergence
110 if (ksgn == -1 .and. max(abs(result),abs(area)) <= &
   & defabs*0.1d-01) go to 130
if (0.1d-01 > (result/area) .or. (result/area) > 0.1d+03 &
   & .or. errsum > abs(area)) ier = 6
go to 130
!           Compute global integral sum.
115 result = 0.d0
do k = 1,last
   result = result + rlist(k)
end do
abserr = errsum
130 neval = 30*last - 15
if (inf == 2) neval = 2*neval
if (ier > 2) ier = ier - 1
999 return
end subroutine dqagie

subroutine dqk15i(f, boun, inf, a, b, result, abserr, resabs, &
   & resasc, epmach, uflow)
!! <!-- nswc-ford:begin DQK15I -->
!! Reference for `dqk15i`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        PURPOSE
!!               the original (infinite) integration range is mapped
!!               onto the interval (0,1) and (a,b) is a part of (0,1).
!!               It is the purpose to compute
!!               I = Integral of transformed integrand over (a,b),
!!               j = Integral of abs(transformed integrand) over (a,b).
!!  2.        PARAMETERS
!!             on entry
!!               f      - Double precision
!!                        function subprogram defining the integrand
!!                        function f(x). the actual name for f needs
!!                        to be declared E X T E R N A L in the
!!                        calling program.
!!               boun   - Double precision
!!                        finite bound of original integration
!!                        RANGE (SET TO ZERO IF inf = +2)
!!               inf    - INTEGER
!!                        if inf = -1, the original interval is
!!                                    (-INFINITY,BOUND),
!!                        if inf = +1, the original interval is
!!                                    (BOUND,+INFINITY),
!!                        if inf = +2, the original interval is
!!                                    (-INFINITY,+INFINITY) and
!!                        the integral is computed as the sum of two
!!                        integrals, one over (-INFINITY,0)
!!                        and one over (0,+INFINITY).
!!               a      - Double precision
!!                        lower limit for integration over subrange
!!                        of (0,1)
!!               b      - Double precision
!!                        upper limit for integration over subrange
!!                        of (0,1)
!!               epmach - Double precision
!!                        the relative precision of the floating
!!                        arithmetic being used.
!!               uflow  - Double precision
!!                        the smallest positive magnitude.
!!             On return
!!               result - Double precision
!!                        approximation to the integral I
!!                        result is computed by applying the 15-point
!!                        Kronrod rule(resk) obtained by optimal
!!                        addition of abscissae to the 7-point Gauss
!!                        RULE(resg).
!!               abserr - Double precision
!!                        estimate of the modulus of the absolute error,
!!                        which should equal or exceed abs(I-result)
!!               resabs - Double precision
!!                        approximation to the integral j
!!               resasc - Double precision
!!                        approximation to the integral of
!!                        abs((transformed integrand)-I/(b-a))
!!                        OVER (a,b)
!!  3.        SUBROUTINES OR FUNCTIONS NEEDED
!!                  - f (user-provided function)
!!
!!            The abscissae and weights are supplied for the interval
!!            (-1,1).  Because of symmetry only the positive abscissae and
!!            their corresponding weights are given.
!!            xgk    - Abscissae of the 15-point Kronrod rule
!!                     xgk(2), xgk(4), ... abscissae of the 7-point
!!                     Gauss rule
!!                     xgk(1), xgk(3), ...  abscissae which are optimally
!!                     added to the 7-point Gauss rule
!!            wgk    - Weights of the 15-point Kronrod rule
!!            wg     - Weights of the 7-point Gauss rule, corresponding
!!                     to the abscissae xgk(2), xgk(4), ...
!!                     wg(1), wg(3), ... are set to zero.
!!            List of major variables
!!
!!            centr  - Mid point of the interval
!!            hlgth  - Half-length of the interval
!!            absc*  - ABSCISSA
!!            TABSC* - Transformed abscissa
!!            FVAL*  - Function VALUE
!!            resg   - result of the 7-point Gauss formula
!!            resk   - result of the 15-point Kronrod formula
!!            reskh  - Approximation to the mean value of the transformed
!!                     integrand over (a,b), I.E. to I/(b-a)
!! ```
!! <!-- nswc-ford:end -->
implicit none
integer, intent(in) :: inf
double precision, intent(in) :: a
double precision, intent(inout) :: abserr
double precision, intent(in) :: b, boun
double precision, intent(in) :: epmach
double precision :: f
double precision, intent(inout) :: resabs, resasc
double precision, intent(inout) :: result
double precision, intent(in) :: uflow
external f
!     beginning of local variable declarations
integer :: j
double precision :: absc, absc1, absc2, centr, dinf, fc, fsum, fval1, fval2, hlgth, resg, resk, reskh, tabsc1, tabsc2, tol, &
   & fv1(7), fv2(7)
double precision, parameter :: xgk(8) = [0.991455371120812639206854697526d+00, &
   & 0.949107912342758524526189684048d+00, 0.864864423359769072789712788641d+00, 0.741531185599394439863864773281d+00, &
   & 0.586087235467691130294144838259d+00, 0.405845151377397166906606412077d+00, 0.207784955007898467600689403773d+00, &
   & 0.000000000000000000000000000000d+00]
double precision, parameter :: wgk(8) = [0.229353220105292249637320080590d-01, &
   & 0.630920926299785532907006631892d-01, 0.104790010322250183839876322542d+00, 0.140653259715525918745189590510d+00, &
   & 0.169004726639267902826583426599d+00, 0.190350578064785409913256402421d+00, 0.204432940075298892414161999235d+00, &
   & 0.209482141084727828012999174892d+00]
double precision, parameter :: wg(8) = [0.0d+00, 0.129484966168869693270611432679d+00, 0.0d+00, &
   & 0.279705391489276667901467771424d+00, 0.0d+00, 0.381830050505118944950369775489d+00, 0.0d+00, &
   & 0.417959183673469387755102040816d+00]
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              the original (infinite) integration range is mapped
!              onto the interval (0,1) and (a,b) is a part of (0,1).
!              It is the purpose to compute
!              I = Integral of transformed integrand over (a,b),
!              j = Integral of abs(transformed integrand) over (a,b).
! 2.        PARAMETERS
!            on entry
!              f      - Double precision
!                       function subprogram defining the integrand
!                       function f(x). the actual name for f needs
!                       to be declared E X T E R N A L in the
!                       calling program.
!              boun   - Double precision
!                       finite bound of original integration
!                       RANGE (SET TO ZERO IF inf = +2)
!              inf    - INTEGER
!                       if inf = -1, the original interval is
!                                   (-INFINITY,BOUND),
!                       if inf = +1, the original interval is
!                                   (BOUND,+INFINITY),
!                       if inf = +2, the original interval is
!                                   (-INFINITY,+INFINITY) and
!                       the integral is computed as the sum of two
!                       integrals, one over (-INFINITY,0)
!                       and one over (0,+INFINITY).
!              a      - Double precision
!                       lower limit for integration over subrange
!                       of (0,1)
!              b      - Double precision
!                       upper limit for integration over subrange
!                       of (0,1)
!              epmach - Double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!              uflow  - Double precision
!                       the smallest positive magnitude.
!            On return
!              result - Double precision
!                       approximation to the integral I
!                       result is computed by applying the 15-point
!                       Kronrod rule(resk) obtained by optimal
!                       addition of abscissae to the 7-point Gauss
!                       RULE(resg).
!              abserr - Double precision
!                       estimate of the modulus of the absolute error,
!                       which should equal or exceed abs(I-result)
!              resabs - Double precision
!                       approximation to the integral j
!              resasc - Double precision
!                       approximation to the integral of
!                       abs((transformed integrand)-I/(b-a))
!                       OVER (a,b)
! 3.        SUBROUTINES OR FUNCTIONS NEEDED
!                 - f (user-provided function)
!-----------------------------------------------------------------------
!           The abscissae and weights are supplied for the interval
!           (-1,1).  Because of symmetry only the positive abscissae and
!           their corresponding weights are given.
!           xgk    - Abscissae of the 15-point Kronrod rule
!                    xgk(2), xgk(4), ... abscissae of the 7-point
!                    Gauss rule
!                    xgk(1), xgk(3), ...  abscissae which are optimally
!                    added to the 7-point Gauss rule
!           wgk    - Weights of the 15-point Kronrod rule
!           wg     - Weights of the 7-point Gauss rule, corresponding
!                    to the abscissae xgk(2), xgk(4), ...
!                    wg(1), wg(3), ... are set to zero.
!           List of major variables
!           -----------------------
!           centr  - Mid point of the interval
!           hlgth  - Half-length of the interval
!           absc*  - ABSCISSA
!           TABSC* - Transformed abscissa
!           FVAL*  - Function VALUE
!           resg   - result of the 7-point Gauss formula
!           resk   - result of the 15-point Kronrod formula
!           reskh  - Approximation to the mean value of the transformed
!                    integrand over (a,b), I.E. to I/(b-a)
dinf = min(1,inf)
centr = 0.5d0*(a + b)
hlgth = 0.5d0*(b - a)
tabsc1 = boun + dinf*(1.d0 - centr)/centr
fval1 = f(tabsc1)
if (inf == 2) fval1 = fval1 + f(-tabsc1)
fc = (fval1/centr)/centr
!           Compute the 15-point Kronrod approximation to
!           the integral, and estimate the error.
resg = wg(8)*fc
resk = wgk(8)*fc
resabs = abs(resk)
do j = 1,7
   absc = hlgth*xgk(j)
   absc1 = centr - absc
   absc2 = centr + absc
   tabsc1 = boun + dinf*(1.d0 - absc1)/absc1
   tabsc2 = boun + dinf*(1.d0 - absc2)/absc2
   fval1 = f(tabsc1)
   fval2 = f(tabsc2)
   if (inf == 2) fval1 = fval1 + f(-tabsc1)
   if (inf == 2) fval2 = fval2 + f(-tabsc2)
   fval1 = (fval1/absc1)/absc1
   fval2 = (fval2/absc2)/absc2
   fv1(j) = fval1
   fv2(j) = fval2
   fsum = fval1 + fval2
   resg = resg + wg(j)*fsum
   resk = resk + wgk(j)*fsum
   resabs = resabs + wgk(j)*(abs(fval1) + abs(fval2))
end do
reskh = resk*0.5d0
resasc = wgk(8)*abs(fc - reskh)
do j = 1,7
   resasc = resasc + wgk(j)*(abs(fv1(j) - reskh) + &
      & abs(fv2(j) - reskh))
end do
result = resk*hlgth
resasc = resasc*hlgth
resabs = resabs*hlgth
abserr = abs((resk - resg)*hlgth)
if (resasc /= 0.d0 .and. abserr /= 0.d0) abserr = resasc* &
   & min(1.d0, (0.2d+03*abserr/resasc)**1.5d0)
tol = 50.d0*epmach
if (resabs > uflow/tol) abserr = max(abserr, tol*resabs)
end subroutine dqk15i

subroutine dqpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!! <!-- nswc-ford:begin DQPSRT -->
!! Reference for `dqpsrt`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        dqpsrt
!!            ordering routine
!!               standard Fortran subroutine
!!               double precision version
!!  2.        PURPOSE
!!               this routine maintains the descending ordering
!!               in the list of the local error estimates resulting from
!!               the interval subdivision process. At each call two error
!!               estimates are inserted using the sequential search
!!               method, top-down for the largest error estimate
!!               and bottom-up for the smallest error estimate.
!!  3.        CALLING SEQUENCE
!!               call dqpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!!            parameters (meaning at output)
!!               limit  - Integer
!!                        maximum number of error estimates the list
!!                        can contain
!!               last   - INTEGER
!!                        number of error estimates currently
!!                        in the list
!!               maxerr - Integer
!!                        maxerr points to the nrmax-TH largest error
!!                        estimate currently in the list
!!               ermax  - Double precision
!!                        nrmax-TH largest error estimate
!!                        ermax = elist(maxerr)
!!               elist  - Double precision
!!                        vector of dimension last containing
!!                        the error estimates
!!               iord   - INTEGER
!!                        vector of dimension last, the first k
!!                        elements of which contain pointers
!!                        to the error estimates, such that
!!                        elist(iord(1)),... , elist(iord(k))
!!                        form a decreasing sequence, with
!!                        k = last if last.LE.(limit/2+2), and
!!                        k = limit+1-last otherwise
!!               nrmax  - Integer
!!                        maxerr = iord(nrmax)
!!  4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!!
!!            Check whether the list contains more than
!!            two error estimates.
!! ***First executable statement dqpsrt
!! ```
!! <!-- nswc-ford:end -->
implicit none
!     ..................................................................
! 1.        dqpsrt
!           ordering routine
!              standard Fortran subroutine
!              double precision version
! 2.        PURPOSE
!              this routine maintains the descending ordering
!              in the list of the local error estimates resulting from
!              the interval subdivision process. At each call two error
!              estimates are inserted using the sequential search
!              method, top-down for the largest error estimate
!              and bottom-up for the smallest error estimate.
! 3.        CALLING SEQUENCE
!              call dqpsrt(limit,last,maxerr,ermax,elist,iord,nrmax)
!           parameters (meaning at output)
!              limit  - Integer
!                       maximum number of error estimates the list
!                       can contain
!              last   - INTEGER
!                       number of error estimates currently
!                       in the list
!              maxerr - Integer
!                       maxerr points to the nrmax-TH largest error
!                       estimate currently in the list
!              ermax  - Double precision
!                       nrmax-TH largest error estimate
!                       ermax = elist(maxerr)
!              elist  - Double precision
!                       vector of dimension last containing
!                       the error estimates
!              iord   - INTEGER
!                       vector of dimension last, the first k
!                       elements of which contain pointers
!                       to the error estimates, such that
!                       elist(iord(1)),... , elist(iord(k))
!                       form a decreasing sequence, with
!                       k = last if last.LE.(limit/2+2), and
!                       k = limit+1-last otherwise
!              nrmax  - Integer
!                       maxerr = iord(nrmax)
! 4.        NO SUBROUTINES OR FUNCTIONS NEEDED
!     ..................................................................
double precision :: elist
double precision, intent(inout) :: ermax
integer, intent(inout) :: iord
integer, intent(in) :: last, limit
integer, intent(inout) :: maxerr, nrmax
dimension elist(last), iord(last)
!     beginning of local variable declarations
double precision :: errmax, errmin
integer :: i, ibeg, ido, isucc, j, jbnd, jupbn, k
!           Check whether the list contains more than
!           two error estimates.
!***First executable statement dqpsrt
if (last > 2) go to 10
iord(1) = 1
iord(2) = 2
go to 90
!           This part of the routine is only executed
!           if, due to a difficult integrand, subdivision
!           increased the error estimate. In the normal case
!           the insert procedure should start after the
!           nrmax-TH largest error estimate.
10 errmax = elist(maxerr)
if (nrmax == 1) go to 30
ido = nrmax - 1
do i = 1,ido
   isucc = iord(nrmax - 1)
! ***Jump out of do-loop
   if (errmax <= elist(isucc)) exit
   iord(nrmax) = isucc
   nrmax = nrmax - 1
end do
!           Compute the number of elements in the list to
!           be maintained in descending order. This number
!           depends on the number of subdivisions still
!           allowed.
30 jupbn = last
if (last > (limit/2 + 2)) jupbn = limit + 3 - last
errmin = elist(last)
!           Insert errmax by traversing the list top-down,
!           starting comparison from the element elist(iord(nrmax+1)).
jbnd = jupbn - 1
ibeg = nrmax + 1
if (ibeg > jbnd) go to 50
do i = ibeg,jbnd
   isucc = iord(i)
! ***Jump out of do-loop
   if (errmax >= elist(isucc)) go to 60
   iord(i - 1) = isucc
end do
50 iord(jbnd) = maxerr
iord(jupbn) = last
go to 90
!           Insert errmin by traversing the list bottom-up.
60 iord(i - 1) = maxerr
k = jbnd
do j = i,jbnd
   isucc = iord(k)
! ***Jump out of do-loop
   if (errmin < elist(isucc)) go to 80
   iord(k + 1) = isucc
   k = k - 1
end do
iord(i) = last
go to 90
80 iord(k + 1) = last
!           Set maxerr and ermax.
90 maxerr = iord(nrmax)
ermax = elist(maxerr)
end subroutine dqpsrt

pure subroutine dqelg(n, epstab, result, abserr, res3la, nres, &
   & epmach, oflow)
!! <!-- nswc-ford:begin DQELG -->
!! Reference for `dqelg`.
!!
!! ### Original procedure notes
!!
!! Imported from the introductory source comments. These legacy notes
!! have not been individually reconciled with later source changes.
!!
!! ```text
!!  1.        PURPOSE
!!               the routine determines the limit of a given sequence of
!!               approximations, by means of the epsilon algorithm
!!               of P. wynn.
!!               An estimate of the absolute error is also given.
!!               The condensed epsilon table is computed. Only those
!!               elements needed for the computation of the next diagonal
!!               are preserved.
!!  2.        PARAMETERS
!!               n      - INTEGER
!!                        epstab(n) contains the new element in the
!!                        first column of the epsilon table.
!!               epstab - Double precision
!!                        vector of dimension 52 containing the
!!                        elements of the two lower diagonals of
!!                        the triangular epsilon table
!!                        the elements are numbered starting at the
!!                        right-hand corner of the triangle.
!!               result - Double precision
!!                        resulting approximation to the integral
!!               abserr - Double precision
!!                        estimate of the absolute error computed from
!!                        result and the 3 previous results
!!               res3la - Double precision
!!                        vector of dimension 3 containing the last 3
!!                        results
!!               nres   - INTEGER
!!                        number of calls to the routine
!!                        (should be zero at first call)
!!               epmach - Double precision
!!                        the relative precision of the floating
!!                        arithmetic being used.
!!               oflow  - Double precision
!!                        the largest positive magnitude.
!!  3.        NO SUBROUTINES OR FUNCTIONS USED
!!
!!            List of major variables
!!
!!            e0     - The 4 elements on which the
!!            e1       COMPUTATION OF A NEW ELEMENT IN
!!            e2       THE EPSILON TABLE IS BASED
!!            e3                 e0
!!                         e3    e1    NEW
!!                               e2
!!            newelm - Number of elements to be computed in the new
!!                     diagonal
!!            error  - error = abs(e1-e0) + abs(e2-e1) + abs(NEW-e2)
!!            result - The element in the new diagonal with least value
!!                     of error
!!            limexp is the maximum number of elements the epsilon
!!            table can contain. If this number is reached, the upper
!!            diagonal of the epsilon table is deleted.
!! ```
!! <!-- nswc-ford:end -->
implicit none
!-----------------------------------------------------------------------
! 1.        PURPOSE
!              the routine determines the limit of a given sequence of
!              approximations, by means of the epsilon algorithm
!              of P. wynn.
!              An estimate of the absolute error is also given.
!              The condensed epsilon table is computed. Only those
!              elements needed for the computation of the next diagonal
!              are preserved.
! 2.        PARAMETERS
!              n      - INTEGER
!                       epstab(n) contains the new element in the
!                       first column of the epsilon table.
!              epstab - Double precision
!                       vector of dimension 52 containing the
!                       elements of the two lower diagonals of
!                       the triangular epsilon table
!                       the elements are numbered starting at the
!                       right-hand corner of the triangle.
!              result - Double precision
!                       resulting approximation to the integral
!              abserr - Double precision
!                       estimate of the absolute error computed from
!                       result and the 3 previous results
!              res3la - Double precision
!                       vector of dimension 3 containing the last 3
!                       results
!              nres   - INTEGER
!                       number of calls to the routine
!                       (should be zero at first call)
!              epmach - Double precision
!                       the relative precision of the floating
!                       arithmetic being used.
!              oflow  - Double precision
!                       the largest positive magnitude.
! 3.        NO SUBROUTINES OR FUNCTIONS USED
!-----------------------------------------------------------------------
double precision, intent(out) :: abserr
double precision, intent(in) :: epmach
double precision, intent(inout) :: epstab(52)
double precision, intent(in) :: oflow
double precision, intent(out) :: result
double precision, intent(inout) :: res3la(3)
integer, intent(inout) :: n
integer, intent(inout) :: nres
!     beginning of local variable declarations
double precision :: delta1, delta2, delta3, epsinf, error, err1, err2, err3, e0, e1, e1abs, e2, e3, res, ss, tol1, tol2, tol3
integer :: i, ib, ib2, ie, indx, k1, k2, k3, limexp, newelm, num
!---------------------
!           List of major variables
!           -----------------------
!           e0     - The 4 elements on which the
!           e1       COMPUTATION OF A NEW ELEMENT IN
!           e2       THE EPSILON TABLE IS BASED
!           e3                 e0
!                        e3    e1    NEW
!                              e2
!           newelm - Number of elements to be computed in the new
!                    diagonal
!           error  - error = abs(e1-e0) + abs(e2-e1) + abs(NEW-e2)
!           result - The element in the new diagonal with least value
!                    of error
!           limexp is the maximum number of elements the epsilon
!           table can contain. If this number is reached, the upper
!           diagonal of the epsilon table is deleted.
nres = nres + 1
abserr = oflow
result = epstab(n)
if (n < 3) go to 100
limexp = 50
epstab(n + 2) = epstab(n)
newelm = (n - 1)/2
epstab(n) = oflow
num = n
k1 = n
do i = 1,newelm
   k2 = k1 - 1
   k3 = k1 - 2
   res = epstab(k1 + 2)
   e0 = epstab(k3)
   e1 = epstab(k2)
   e2 = res
   e1abs = abs(e1)
   delta2 = e2 - e1
   err2 = abs(delta2)
   tol2 = max(abs(e2),e1abs)*epmach
   delta3 = e1 - e0
   err3 = abs(delta3)
   tol3 = max(e1abs,abs(e0))*epmach
   if (err2 > tol2 .or. err3 > tol3) go to 10
!           If e0, e1 and e2 are equal to within machine
!           accuracy, convergence is assumed.
!           result = e2
!           abserr = abs(e1-e0) + abs(e2-e1)
   result = res
   abserr = err2 + err3
! ***Jump out of do-loop
   go to 100
10 e3 = epstab(k1)
   epstab(k1) = e1
   delta1 = e1 - e3
   err1 = abs(delta1)
   tol1 = max(e1abs,abs(e3))*epmach
!           If two elements are very close to each other, omit
!           a part of the table by adjusting the value of n
   if (err1 <= tol1 .or. err2 <= tol2 .or. err3 <= tol3) go to 20
   ss = 1.d0/delta1 + 1.d0/delta2 - 1.d0/delta3
   epsinf = abs(ss*e1)
!           Test to detect irregular behaviour in the table, and
!           eventually omit a part of the table adjusting the value
!           OF n.
   if (epsinf > 0.1d-03) go to 30
20 n = i + i - 1
! ***Jump out of do-loop
   exit
!           Compute a new element and eventually adjust
!           the value of result.
30 res = e1 + 1.d0/ss
   epstab(k1) = res
   k1 = k1 - 2
   error = err2 + abs(res - e2) + err3
   if (error > abserr) go to 40
   abserr = error
   result = res
40 continue
end do
!           Shift the table.
if (n == limexp) n = 2*(limexp/2) - 1
ib = 1
if ((num/2)*2 == num) ib = 2
ie = newelm + 1
do i = 1,ie
   ib2 = ib + 2
   epstab(ib) = epstab(ib2)
   ib = ib2
end do
if (num == n) go to 80
indx = num - n + 1
do i = 1,n
   epstab(i) = epstab(indx)
   indx = indx + 1
end do
80 if (nres >= 4) go to 90
res3la(nres) = result
abserr = oflow
go to 100
!           Compute error estimate
90 abserr = abs(result - res3la(3)) + abs(result - res3la(2)) + &
   & abs(result - res3la(1))
res3la(1) = res3la(2)
res3la(2) = res3la(3)
res3la(3) = result
100 abserr = max(abserr,5.d0*epmach*abs(result))
end subroutine dqelg

