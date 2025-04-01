program cart_shift_1
    use mpi
    implicit none

    integer :: ierr, rank, size
    integer :: dims(2), comm_cart
    logical :: periods(2)
    integer :: rank_source, rank_dest
    integer :: coords(2)

    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)

    dims(1) = 2          ! rows
    dims(2) = size/2     ! columns
    periods(1) = .false. ! non-periodic in x
    periods(2) = .false. ! non-periodic in y

    call MPI_CART_CREATE(MPI_COMM_WORLD, 2, dims, periods, .true., comm_cart, ierr)

    print *, "rank: ", rank
    if (comm_cart == MPI_COMM_NULL) then
        if (rank == 0) then
            print *, 'Error creating Cartesian communicator'
        endif
        call MPI_FINALIZE(ierr)
        stop
    else
        print *, "Error occured"
        error stop
    end if

end program cart_shift_1
