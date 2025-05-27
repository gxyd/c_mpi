program comm_group_1
    use mpi
    implicit none
    integer :: ierr, rank, size, group, group_size
    logical :: error

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Get the group of MPI_COMM_WORLD
    call MPI_Comm_group(MPI_COMM_WORLD, group, ierr)

    ! Check group size
    call MPI_Group_size(group, group_size, ierr)

    ! Verify result
    error = .false.
    if (group_size /= size) then
        print *, "Rank ", rank, ": Error: Expected group size ", size, ", got ", group_size
        error = .true.
    else if (rank == 0) then
        print *, "MPI_Comm_group test passed: group size = ", group_size
    end if

    ! Free the group
    call MPI_Group_free(group, ierr)

    ! Clean up
    call MPI_Finalize(ierr)

    if (error) stop 1
end program comm_group_1