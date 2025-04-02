program isend_1
    use mpi
    implicit none

    integer, parameter :: NROWS = 100
    integer, parameter :: NCOLS = 50
    real(8) :: send_buf(NROWS, NCOLS)
    integer :: rank, size, ierr
    integer :: dest, tag
    integer :: request

    call MPI_INIT(ierr)

    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)

    if (size < 2) then
        if (rank == 0) then
            print *, 'This program requires at least 2 processes'
        end if
        call MPI_FINALIZE(ierr)
        stop
    end if

    send_buf = real(rank, 8) + 0.1d0

    dest = mod(rank + 1, size)
    tag = 0

    if (rank == 0) then
        print *, 'Starting non-blocking send example without wait'
    end if

    call MPI_ISEND(send_buf, NROWS*NCOLS, MPI_REAL8, dest, &
                  tag, MPI_COMM_WORLD, request, ierr)

    print *, 'Rank ', rank, ' continuing work while sending to ', dest

    call sleep(1)

    print *, 'Rank ', rank, ' finished work, send may still be in progress'

    call MPI_FINALIZE(ierr)

end program isend_1
