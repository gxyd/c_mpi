program allgather_int_1
    use mpi
    implicit none

    integer, parameter :: N = 2
    integer :: rank, size, i, j, ierr
    integer :: sendbuf(N)
    integer, dimension(:, :), allocatable :: recvbuf
    integer :: expected_value

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    allocate(recvbuf(N, size))

    do i = 1, N
        sendbuf(i) = rank * 10 + i
    end do

    call MPI_Allgather(sendbuf, N, MPI_INTEGER, recvbuf, N, MPI_INTEGER, MPI_COMM_WORLD, ierr)

    ! test the contents of recvbuf on all processes
    do j = 1, size
        do i = 1, N
            expected_value = (j - 1) * 10 + i
            if (recvbuf(i, j) /= expected_value) then
                print *, "Error on rank", rank, ": recvbuf(", i, ",", j, ") = ", &
                         recvbuf(i, j), " but expected ", expected_value
                error stop "MPI_Allgather test failed"
            end if
        end do
    end do

    if (rank == 0) then
        print *, "Final gathered array:"
        do i = 1, size
            print *, "Process", i - 1, ":", recvbuf(:, i)
        end do
    end if

    deallocate(recvbuf)
    call MPI_Finalize(ierr)

end program allgather_int_1
