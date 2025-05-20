program allgatherv_1
    use mpi
    implicit none
    integer :: ierr, rank, size
    integer, allocatable :: sendbuf(:), recvbuf(:)
    integer, allocatable :: recvcounts(:), displs(:)
    integer :: sendcount, i, total
    logical :: error

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Each process sends 'rank + 1' integers
    sendcount = rank + 1
    allocate(sendbuf(sendcount))
    do i = 1, sendcount
        sendbuf(i) = rank * 100 + i  ! Unique values per process
    end do

    ! All processes allocate receive buffers
    allocate(recvcounts(size))
    allocate(displs(size))
    total = 0
    do i = 1, size
        recvcounts(i) = i  ! Process i-1 sends i elements
        displs(i) = total  ! Displacement in recvbuf
        total = total + recvcounts(i)
    end do
    allocate(recvbuf(total))
    recvbuf = 0

    ! Perform allgather
    call MPI_Allgatherv(sendbuf, sendcount, MPI_INTEGER, recvbuf, recvcounts, &
                        displs, MPI_INTEGER, MPI_COMM_WORLD, ierr)

    ! Verify results on all processes
    error = .false.
    do i = 1, size
        do sendcount = 1, i
            if (recvbuf(displs(i) + sendcount) /= (i-1)*100 + sendcount) then
                print *, "Rank ", rank, ": Error at source rank ", i-1, &
                         " index ", sendcount, ": expected ", (i-1)*100 + sendcount, &
                         ", got ", recvbuf(displs(i) + sendcount)
                error = .true.
            end if
        end do
    end do
    if (.not. error) then
        print *, "MPI_Allgatherv test passed on rank ", rank
    end if

    ! Clean up
    deallocate(sendbuf, recvbuf, recvcounts, displs)
    call MPI_Finalize(ierr)

    if (error) stop 1
end program allgatherv_1