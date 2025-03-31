program test_bcast
    use mpi 
    implicit none

    integer :: ierror, rank, size, comm, root, n, i
    real(8), allocatable :: arr(:,:)
    comm = MPI_COMM_WORLD

    ! Initialize MPI
    call MPI_Init(ierror)

    ! Get our rank and the total number of processes
    call MPI_Comm_rank(comm, rank, ierror)
    call MPI_Comm_size(comm, size, ierror)

    ! Decide how large an array to broadcast
    n = 5
    allocate(arr(n,n))

    ! Only the root (rank=0) initializes the data
    root = 0
    if (rank == root) then
        arr = reshape([(i, i=1,n*n)], shape=[n, n])  ! Initialize as a 2D array
    else
        arr = -999  ! fill with dummy values to see if Bcast overwrites them
    end if

    ! Broadcast the array from root=0 to all processes
    call MPI_Bcast(arr, n, MPI_REAL8, root, comm, ierror)
    if (ierror /= MPI_SUCCESS) then
        print *, "Error in MPI_Bcast:", ierror
    end if

    ! Print result on each rank
    print *, "Rank=", rank, " received arr=", arr

    ! Finalize MPI
    call MPI_Finalize(ierror)
end program test_bcast