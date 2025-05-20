program reduce_max_1
    use mpi
    implicit none
    integer :: ierr, rank, size, root
    integer :: sendbuf, recvbuf
    logical :: error

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Root process
    root = 0

    ! Each process sends its rank + 100 as input
    sendbuf = rank + 100

    ! Perform reduction with MPI_MAX
    call MPI_Reduce(sendbuf, recvbuf, 1, MPI_INTEGER, MPI_MAX, root, MPI_COMM_WORLD, ierr)

    ! Verify result on root
    error = .false.
    if (rank == root) then
        if (recvbuf /= size - 1 + 100) then
            print *, "Error: Expected max ", size - 1 + 100, ", got ", recvbuf
            error = .true.
        else
            print *, "MPI_Reduce with MPI_MAX test passed: max = ", recvbuf
        end if
    end if

    ! Clean up
    call MPI_Finalize(ierr)

    if (error) stop 1
end program reduce_max_1