! Adapted from test_sparse_structure_workers_legacy.f90 in the amiller-nswc test suite.
! Standalone legacy-interface driver: link one NSWC source version at a time.
program test_sparse_structure_workers
   implicit none
   interface
      subroutine mc21a(n,icn,licn,ip,lenr,iperm,numnz,iw)
         integer, intent(in) :: n,licn
         integer, intent(in) :: icn(licn),ip(n),lenr(n)
         integer, intent(out) :: iperm(n),numnz
         integer, intent(inout) :: iw(n,4)
      end subroutine mc21a
      subroutine mc21b(n,icn,licn,ip,lenr,iperm,numnz,pr,arp,cv,out)
         integer, intent(in) :: n,licn
         integer, intent(in) :: icn(licn),ip(n),lenr(n)
         integer, intent(out) :: iperm(n),numnz
         integer, intent(inout) :: pr(n),arp(n),cv(n),out(n)
      end subroutine mc21b
      subroutine mc13d(n,icn,licn,ip,lenr,ior,ib,num,iw)
         integer, intent(in) :: n,licn
         integer, intent(in) :: icn(licn),ip(n),lenr(n)
         integer, intent(out) :: ior(n),ib(n),num
         integer, intent(inout) :: iw(n,3)
      end subroutine mc13d
      subroutine mc13e(n,icn,licn,ip,lenr,arp,ib,num,lowl,numb,prev)
         integer, intent(in) :: n,licn
         integer, intent(in) :: icn(licn),ip(n),lenr(n)
         integer, intent(out) :: arp(n),ib(n),num
         integer, intent(inout) :: lowl(n),numb(n),prev(n)
      end subroutine mc13e
      subroutine spord(m,n,ia,r,iwk)
         integer :: m,n,ia(*),r(m),iwk(*)
      end subroutine spord
      subroutine blkord(n,ia,ja,r,c,ib,num,iwk,ierr)
         integer :: n,ia(*),ja(*),r(n),c(n),ib(n),num,iwk(*),ierr
      end subroutine blkord
   end interface
   integer, parameter :: n=4, licn=7
   integer :: icn(licn),ip(n),lenr(n),p(n),numnz,iw21(n,4)
   integer :: pr(n),arp(n),cv(n),out(n)
   integer :: gicn(6),gip(n),glen(n),ior(n),ib(n),num,iw13(n,3)
   integer :: lowl(n),numb(n),prev(n)
   integer :: csr(n+1),rows(n),cols(n),blocks(n),iwk(5*n),ierr,i

   icn=[1,2, 1, 2,3, 3,4]
   ip=[1,3,4,6]
   lenr=[2,1,2,2]
   iw21=0
   call mc21a(n,icn,licn,ip,lenr,p,numnz,iw21)
   if (numnz/=n) error stop 1
   pr=0; arp=0; cv=0; out=0
   call mc21b(n,icn,licn,ip,lenr,p,numnz,pr,arp,cv,out)
   if (numnz/=n) error stop 1

   gicn=[2,1,3,4,3,0]
   gip=[1,2,4,5]
   glen=[1,2,1,1]
   iw13=0
   call mc13d(n,gicn,6,gip,glen,ior,ib,num,iw13)
   if (num/=2 .or. ib(1)/=1 .or. ib(2)/=3) error stop 1
   lowl=0; numb=0; prev=0
   call mc13e(n,gicn,6,gip,glen,ior,ib,num,lowl,numb,prev)
   if (num/=2) error stop 1
   csr=[1,3,4,6,8]
   call spord(n,n,csr,rows,iwk)
   if (any(rows/=[2,1,3,4])) error stop 'SPORD row lengths'
   call blkord(n,csr,icn,rows,cols,blocks,num,iwk,ierr)
   if (ierr/=0 .or. num<1 .or. num>n) error stop 'BLKORD status'
   if (blocks(1)/=1) error stop 'BLKORD first block'
   if (any(rows<1) .or. any(rows>n)) error stop 'BLKORD row bounds'
   if (any(cols<1) .or. any(cols>n)) error stop 'BLKORD column bounds'
   do i=1,n
      if (count(rows==i)/=1 .or. count(cols==i)/=1) error stop 'BLKORD permutations'
      if (.not.any(icn(csr(rows(i)):csr(rows(i)+1)-1)==cols(i))) error stop 'BLKORD diagonal'
   end do
   print '(a,4i6)', 'Block row ordering: ',rows
   print '(a,4i6)', 'Block column ordering: ',cols
   print *, 'test_sparse_structure_workers: PASS'
end program test_sparse_structure_workers
