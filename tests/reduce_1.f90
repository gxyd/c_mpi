program test_reduce
    use mpi
    implicit none

    integer :: ierr, rank, comm, root
    integer :: sendval, recvval

    comm = MPI_COMM_WORLD
    root = 0

    call MPI_Init(ierr)
    call MPI_Comm_rank(comm, rank, ierr)

    ! Each rank will hold its rank ID in 'sendval'
    sendval = rank
    recvval = -999  ! dummy init

    ! We do a sum over all ranks
    call MPI_Reduce(sendval, recvval, 1, MPI_INTEGER, MPI_SUM, root, comm, ierr)

    if (rank == root) then
        print *, "Root received sum of ranks = ", recvval
    end if

    call MPI_Finalize(ierr)
end program test_reduce