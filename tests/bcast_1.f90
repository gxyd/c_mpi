program bcast_1
    use mpi
    implicit none

    integer, parameter :: n = 100
    integer :: rank, size, i, ierr
    integer :: d

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    d = 1
    call MPI_Bcast(d, n, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
    call MPI_Finalize(ierr)
    if (ierr /= 0) error stop
end program bcast_1
