program main
    use mpi
    implicit none
    integer :: ierr
    integer :: required
    integer :: provided
    integer :: tcheck
    integer :: ierr0
    integer :: nproc1
    integer :: rank = 0
    integer, parameter :: nt_g = 2
    integer, parameter :: np_g = 3
    real(8), dimension(:,:), allocatable :: br0_g
    integer, parameter :: lbuf=4
    integer, dimension(lbuf) :: sbuf
    integer, parameter :: nproc = 2
    integer, dimension(lbuf,0:nproc-1) :: rbuf
    integer :: ntype_real = MPI_REAL8
    integer :: comm_all, newcomm_all, newcomm_after_sub
    integer, parameter :: nr = 2
    integer, parameter :: nt = 3
    integer, parameter :: np = 2
    real(8), dimension(nr,nt,np) :: a
    integer, parameter :: n1 = 2
    real(8), dimension(n1) :: a0
    integer :: tag=0
    real(8), dimension(:), allocatable :: rbuf4
    integer, parameter :: lbuf4 = 4
    integer :: irank4 = 2
    
    integer, parameter :: maxdim = 2
    integer :: coords(maxdim)
    integer :: tag4 = 0

    integer, parameter :: lbuf2=10
    real(8), dimension(lbuf2) :: sbuf2
    real(8), dimension(lbuf2,0:nproc-1) :: tbuf
    integer, parameter :: lbuf3 = 10
    integer :: comm_phi
    integer :: iproc_pp
    integer :: reqs(4)
    integer, parameter :: nstack=10
    real(8), dimension(nstack) :: tstart=0.
    integer :: istack=1
    integer :: iprocw
    integer :: comm_shared
    real(8), dimension(:), allocatable :: sbuf5
    integer, parameter :: lsbuf5 = 24
    real(8), dimension(2,3,4) :: a5

    integer :: iproc05 = 10
    integer, parameter :: ndims = 2
    integer :: dims(ndims) = 1
    logical :: periods(ndims), remain_dims(ndims) = .false.
    integer :: direction, displ, source, dest

    allocate (br0_g(nt_g,np_g))
    allocate (rbuf4(lbuf4))


    allocate (sbuf5(lsbuf5))
    sbuf5=reshape(a5(1:2,1:3,1:4),(/lsbuf5/))

    ! NOTE: called in pot3d.F90 as:
    call MPI_Init_thread (MPI_THREAD_FUNNELED,tcheck,ierr)
    ! call MPI_Init_thread(required, provided, ierr)
    if (ierr /= 0) error stop "MPI_Init_thread failed"

    ierr = -1
    ! NOTE: called in pot3d.F90 as:
    call MPI_Comm_size (MPI_COMM_WORLD,nproc1,ierr)
    if (ierr /= 0) error stop
    print *, "Number of processes:", nproc1

    ierr = -1
    call MPI_Bcast (ierr0,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Bcast(br0_g,nt_g*np_g,ntype_real,0,comm_all,ierr)
    if (ierr /= 0) error stop


    ierr = -1
    call MPI_Allgather (sbuf,lbuf,MPI_INTEGER, &
        rbuf,lbuf,MPI_INTEGER,comm_all,ierr)
    
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Allgather (sbuf2,lbuf2,ntype_real, &
        tbuf,lbuf2,ntype_real,comm_all,ierr)

    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Isend (a(:,:,np-1),lbuf3,ntype_real,iproc_pp,tag, &
        comm_all,reqs(1),ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Irecv (a(:,:, 1),lbuf3,ntype_real,iproc_pp,tag,   &
        comm_all,reqs(3),ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Allreduce (MPI_IN_PLACE,a0,n1,ntype_real, &
        MPI_SUM,comm_phi,ierr)
    if (ierr /= 0) error stop

    tstart(istack)=MPI_Wtime()

    ierr = -1
    call MPI_Barrier(MPI_COMM_WORLD,ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Barrier (comm_all,ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Comm_rank (MPI_COMM_WORLD,iprocw,ierr)
    if (ierr /= 0) error stop
    print *, iprocw

    ierr = -1
    call MPI_Comm_split_type (MPI_COMM_WORLD,MPI_COMM_TYPE_SHARED,0, &
        MPI_INFO_NULL,comm_shared,ierr)
    if (ierr /= 0) error stop

    ! I'm not sure of the exact conditions to test "MPI_Recv",
    ! currently it fails on program execution
    ! ierr = -1
    ! call MPI_Recv (rbuf4,lbuf4,ntype_real,irank4,tag4, &
    !                comm_all,MPI_STATUS_IGNORE,ierr)
    ! if (ierr /= 0) error stop

    ! maybe this required a very specific "rank" for the arguments
    ! ierr = -1
    ! call MPI_Ssend (sbuf5,lsbuf5,ntype_real,iproc05,tag,comm_all,ierr)
    ! if (ierr /= 0) error stop

    ! ierr = -1
    ! I've no idea for why the below works, I don't understand
    ! things here, cause I've no idea for why declaring
    ! MPI_STATUSES_IGNORE as an integer allocatable makes it work here
    ! call MPI_Waitall (4,reqs,MPI_STATUSES_IGNORE,ierr)
    ! if (ierr /= 0) error stop

    ierr = -1
    call MPI_Dims_create (nproc1, ndims, dims, ierr)
    if (ierr /= 0) error stop
    print *, "Computed dimensions:", dims
    ! Here Ideally we would need MPI_Dims_create(size,2,dims) as dims() value can't be zero it have to be initialized
    ierr = -1
    ! Just experimental
    ! periods(1) = .TRUE.
    call MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, .FALSE., newcomm_all, ierr)
    if (ierr /= 0) error stop
    print *, "Cartesian communicator created"

    ierr = -1
    call MPI_Comm_rank (newcomm_all,iprocw,ierr)
    if (ierr /= 0) error stop
    print *, "Cartesian rank:", iprocw

    ierr = -1
    call MPI_Cart_coords(newcomm_all, iprocw, 2, coords, ierr)
    if (ierr /= 0) error stop
    print *, "Coordinates:", coords

    ierr = -1
    call MPI_Cart_shift(newcomm_all, direction, displ, source, dest, ierr)
    if (ierr /= 0) error stop
    print *, "Shift results - Source:", source, "Dest:", dest

    ierr = -1
    call MPI_Cart_sub(newcomm_all, remain_dims, newcomm_after_sub, ierr)
    if (ierr /= 0) error stop

    print *, "Initial Communicator created:", newcomm_all
    print *, "Subcommunicator created:", newcomm_after_sub

    ! called in pot3d.F90 as
    ierr = -1
    call MPI_Finalize(ierr)
    if (ierr /= 0) error stop "MPI_Finalize failed"

end program main
