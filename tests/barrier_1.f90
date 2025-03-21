program barrier_1
    use mpi
    implicit none

    integer :: rank, size, ierr

    ! Initialize MPI
    call MPI_Init(ierr)

    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    print *, "Process ", rank, " reached before the barrier."

    ! Synchronize all processes at this point
    call MPI_Barrier(MPI_COMM_WORLD, ierr)

    print *, "Process ", rank, " passed the barrier."

    call MPI_Finalize(ierr)

end program
