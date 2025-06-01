program sendrecv_1
    use mpi
    implicit none
    integer :: ierr, rank, size, next, prev
    real(8), allocatable :: sendbuf(:,:), recvbuf(:,:)
    integer :: status(MPI_STATUS_SIZE)
    logical :: error
    integer :: i, j, n1, n2

    n1 = 2
    n2 = 3

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Set up ring communication
    next = mod(rank + 1, size)  ! Send to next process
    prev = mod(rank - 1 + size, size)  ! Receive from previous process

    ! Allocate and initialize send/recv buffers
    allocate(sendbuf(n1, n2))
    allocate(recvbuf(n1, n2))
    sendbuf = rank
    recvbuf = -1.0d0

    ! Perform sendrecv
    call MPI_Sendrecv(sendbuf, n1*n2, MPI_REAL8, next, 0, &
                      recvbuf, n1*n2, MPI_REAL8, prev, 0, &
                      MPI_COMM_WORLD, status, ierr)

    ! Verify result
    error = .false.
    do i = 1, n1
        do j = 1, n2
            if (recvbuf(i,j) /= real(prev,8)) then
                print *, "Rank ", rank, ": Error at (",i,",",j,"): Expected ", prev, ", got ", recvbuf(i,j)
                error = .true.
            end if
        end do
    end do

    if (.not. error .and. rank == 0) then
        print *, "MPI_Sendrecv test passed: rank ", rank, " received correct data"
    end if

    ! Clean up
    call MPI_Finalize(ierr)

    if (error) error stop 1
end program sendrecv_1