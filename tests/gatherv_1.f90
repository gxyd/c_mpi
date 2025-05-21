program gatherv_1
    use mpi
    implicit none
    integer :: ierr, rank, size, root
    integer, allocatable :: sendbuf(:), recvbuf(:)
    integer, allocatable :: recvcounts(:), displs(:)
    integer :: sendcount, i, total
    logical :: error

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Root process
    root = 0

    ! Each process sends 'rank + 1' integers
    sendcount = rank + 1
    allocate(sendbuf(sendcount))
    do i = 1, sendcount
        sendbuf(i) = rank * 100 + i  ! Unique values per process
    end do

    ! Allocate receive buffers on root
    if (rank == root) then
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
    else
        allocate(recvcounts(1), displs(1), recvbuf(1))  ! Dummy allocations for non-root
    end if

    ! Perform gather
    call MPI_Gatherv(sendbuf, sendcount, MPI_INTEGER, recvbuf, recvcounts, &
                     displs, MPI_INTEGER, root, MPI_COMM_WORLD, ierr)

    ! Verify results on root
    error = .false.
    if (rank == root) then
        do i = 1, size
            do sendcount = 1, i
                if (recvbuf(displs(i) + sendcount) /= (i-1)*100 + sendcount) then
                    print *, "Error at rank ", i-1, " index ", sendcount, &
                             ": expected ", (i-1)*100 + sendcount, &
                             ", got ", recvbuf(displs(i) + sendcount)
                    error = .true.
                    error stop
                end if
            end do
        end do
        if (.not. error) then
            print *, "MPI_Gatherv test passed on root"
        end if
    end if

    ! Clean up
    deallocate(sendbuf, recvbuf, recvcounts, displs)
    call MPI_Finalize(ierr)

    if (error) stop 1
end program gatherv_1