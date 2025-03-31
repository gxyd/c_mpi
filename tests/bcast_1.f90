program test_bcast
    use mpi 
    implicit none

    integer :: ierror, rank, size, comm, root, n, i, d
    comm = MPI_COMM_WORLD
    d = 0
    ! Initialize MPI
    call MPI_Init(ierror)

    ! Get our rank and the total number of processes
    call MPI_Comm_rank(comm, rank, ierror)
    call MPI_Comm_size(comm, size, ierror)

    root = 0
    if (rank == root) then
        d = 1
    end if

    ! Broadcast the integer from root=0 to all processes
    call MPI_Bcast(d, 1, MPI_INTEGER, root, comm, ierror)
    if (ierror /= MPI_SUCCESS) then
        print *, "Error in MPI_Bcast:", ierror
    end if

    ! Print result on each rank
    print *, "Rank=", rank, " received integer=", d

    ! Finalize MPI
    call MPI_Finalize(ierror)
end program test_bcast