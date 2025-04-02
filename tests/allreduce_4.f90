program allreduce_4
    use mpi
    implicit none

    integer :: ierr, rank, nprocs
    real(8), dimension(:), allocatable :: sendbuf, recvbuf
    integer :: n = 10
    integer :: i
    real(8) :: expected_value, tolerance
    logical :: error_detected

    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

    allocate(sendbuf(n))
    allocate(recvbuf(n))

    do i = 1, n
        sendbuf(i) = real(rank * i, 8)
    end do

    recvbuf = sendbuf

    ! perform allreduce operation with MPI_IN_PLACE
    call MPI_ALLREDUCE(MPI_IN_PLACE, recvbuf, n, MPI_REAL8, MPI_SUM, &
                      MPI_COMM_WORLD, ierr)

    tolerance = 1.0e-10_8
    error_detected = .false.

    do i = 1, n
        expected_value = real(nprocs * (nprocs - 1) * i, 8) / 2.0_8

        if (abs(recvbuf(i) - expected_value) > tolerance) then
            error_detected = .true.
            print '(A,I0,A,I2,A,F12.2,A,F12.2)', &
                  'Rank ', rank, ' Error at index ', i, &
                  ': got ', recvbuf(i), ', expected ', expected_value
        end if
    end do

    call MPI_BARRIER(MPI_COMM_WORLD, ierr)

    if (error_detected) then
        error stop 'MPI_ALLREDUCE produced incorrect results'
    end if

    if (rank == 0) then
        print *, 'Results after MPI_ALLREDUCE with MPI_SUM:'
        do i = 1, n
            print '(A,I2,A,F12.2)', 'Element ', i, ': ', recvbuf(i)
        end do
        print *, 'All values verified successfully'
    end if

    deallocate(sendbuf)
    deallocate(recvbuf)
    call MPI_FINALIZE(ierr)

end program allreduce_4
