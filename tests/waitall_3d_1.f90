!> TODO: this program needs if (...) error stop conditions in it
program waitall_3d_1
    use mpi
    implicit none

    integer :: ierr, rank, nprocs
    integer :: num_requests, i
    integer, parameter :: dim1 = 3, dim2 = 4, dim3 = 2
    real(8) :: send_buffer_3d(dim1, dim2, dim3)
    real(8) :: recv_buffer_3d(dim1, dim2, dim3)
    integer, allocatable :: requests(:)

    ! Initialize MPI
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

    ! Must have at least 2 processes
    if (nprocs < 2) then
        if (rank == 0) then
            print *, "This program requires at least 2 processes"
        endif
        call MPI_FINALIZE(ierr)
        stop
    endif

    ! Allocate request array
    num_requests = 2
    allocate(requests(num_requests))
    ! requests = MPI_REQUEST_NULL

    ! Initialize send buffer (3D array) on rank 0
    if (rank == 0) then
        send_buffer_3d = reshape([(real(rank * 10 + i, 8), i=1,dim1*dim2*dim3)], &
                                [dim1, dim2, dim3])
    endif

    ! Clear receive buffer (3D array)
    recv_buffer_3d = 0.0_8

    ! Non-blocking send and receive
    if (rank == 0) then
        ! Send the full 3D array to rank 1
        call MPI_ISEND(send_buffer_3d, dim1*dim2*dim3, MPI_DOUBLE_PRECISION, 1, 0, &
                      MPI_COMM_WORLD, requests(1), ierr)
    else if (rank == 1) then
        ! Receive into a 3D array from rank 0
        call MPI_IRECV(recv_buffer_3d, dim1*dim2*dim3, MPI_DOUBLE_PRECISION, 0, 0, &
                      MPI_COMM_WORLD, requests(2), ierr)
    endif

    ! Wait for all communications to complete
    if (rank == 0 .or. rank == 1) then
        call MPI_WAITALL(num_requests, requests, MPI_STATUSES_IGNORE, ierr)
    endif

    ! Print results
    if (rank == 1) then
        print '(A,I2)', "Process ", rank
        do i = 1, dim3
            print '(A,I1)', "Received 3D array, slice ", i
            print '(4F8.1)', recv_buffer_3d(:,:,i)
        enddo
    endif

    ! Clean up
    deallocate(requests)
    call MPI_FINALIZE(ierr)

end program waitall_3d_1
