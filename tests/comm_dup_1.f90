program comm_dup_1
    use mpi
    implicit none

    integer :: communicator, new_comm
    integer :: ier, rank, size, received
    type :: context_t
        integer :: mpi_communicator
    end type context_t

    type(context_t) :: context

    call MPI_Init(ier)

    communicator = MPI_COMM_WORLD
    call MPI_Comm_rank(communicator, rank, ier)
    call MPI_Comm_size(communicator, size, ier)

    call MPI_Comm_dup(communicator, context%mpi_communicator, ier)

    if (ier /= MPI_SUCCESS) then
        print *, "Error duplicating communicator"
        error stop
        ! call MPI_Abort(communicator, 1, ier)
    end if

    new_comm = context%mpi_communicator

    print *, 'Process ', rank, ' of ', size, ' has duplicated communicator ', new_comm

    if (rank == 0) then
        ! call MPI_Send(42, 1, MPI_Integer, 1, 99, new_comm, ier)
        print *, "Process 0 sent message using duplicated communicator"
    else if (rank == 1) then
        ! call MPI_Recv(received, 1, MPI_Integer, 0, 99, new_comm, MPI_STATUS_IGNORE, ier)
        print *, 'Process 1 received: ', received, ' using duplicated communicator'
    end if

    ! call MPI_Comm_free(new_comm, ier)

    call MPI_Finalize(ier)
end program
