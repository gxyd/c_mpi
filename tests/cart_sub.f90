program main
    use mpi
    implicit none

    ! MPI variables
    integer :: rank, size, ierr, tcheck
    integer :: comm_cart, comm_new
    integer :: dims(2), coords(2)
    logical :: periods(2), reorder, remain_dims(2)
    integer :: errs

    ! Initialize errors counter
    errs = 0

    ! Initialize dimensions to 0 (MPI_Dims_create will set them optimally)
    dims(1:2) = 0
    
    ! Periodicity settings: 
    ! - First dimension has a cyclic (wrapped-around) topology
    ! - Second dimension is non-periodic (no wrap-around)
    periods(1) = .TRUE.
    periods(2) = .FALSE.
    
    ! Allow MPI to reorder ranks for better performance
    reorder = .TRUE.

    ! Sub-communicator dimensions: 
    ! - First dimension is kept
    ! - Second dimension is removed
    remain_dims(1) = .TRUE.
    remain_dims(2) = .FALSE.

    ! Initialize MPI with thread support
    call MPI_Init_thread(MPI_THREAD_FUNNELED, tcheck, ierr)
    if (ierr /= MPI_SUCCESS) then
        print *, "Error initializing MPI"
        stop
    end if

    ! Get rank and size in the global communicator
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Automatically determine a balanced 2D grid
    call MPI_Dims_create(size, 2, dims, ierr)
    if (ierr /= MPI_SUCCESS) then
        print *, "Error creating dimensions"
        stop
    end if

    ! Create a Cartesian communicator
    call MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, reorder, comm_cart, ierr)
    if (ierr /= MPI_SUCCESS) then
        print *, "Error creating Cartesian communicator"
        stop
    end if

    ! Get new rank in the Cartesian communicator
    call MPI_Comm_rank(comm_cart, rank, ierr)

    ! Get the Cartesian coordinates of the current rank
    call MPI_Cart_coords(comm_cart, rank, 2, coords, ierr)

    ! Print rank details
    print *, "Global Rank:", rank, "Cartesian Coordinates:", coords

    ! Create a new sub-communicator by removing the second dimension
    call MPI_Cart_sub(comm_cart, remain_dims, comm_new, ierr)
    if (ierr /= MPI_SUCCESS) then
        print *, "Error creating sub-communicator"
        stop
    end if

    ! Get the size of the new communicator
    call MPI_Comm_size(comm_new, size, ierr)
    
    ! Print the new communicator details
    print *, "New communicator rank:", rank, "New communicator size:", size

    ! Finalize MPI
    call MPI_Finalize(errs)
    if (errs /= MPI_SUCCESS) then
        print *, "Error finalizing MPI"
        stop
    end if

end program main