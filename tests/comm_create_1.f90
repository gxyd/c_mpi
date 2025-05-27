program minimal_mre_range
  use mpi
  implicit none

  integer :: ierr, rank, size
  integer :: group_world, group_range, new_comm
  integer, dimension(1,3) :: range   ! 1D array to define a single range
  integer :: i

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)

  ! Get the group of MPI_COMM_WORLD
  call MPI_COMM_GROUP(MPI_COMM_WORLD, group_world, ierr)

  ! Define 1D range: start, end, stride
  range(1,1) = 0         ! start
  range(1,2) = size - 1  ! end
  range(1,3) = 1         ! stride


  ! Create a new group that includes all ranks
  call MPI_GROUP_RANGE_INCL(group_world, 1, range, group_range, ierr)

  ! Create new communicator
  call MPI_COMM_CREATE(MPI_COMM_WORLD, group_range, new_comm, ierr)

  ! Print participation
  if (new_comm /= MPI_COMM_NULL) then
    print *, 'Rank', rank, 'is in the new communicator.'
  else
    print *, 'Rank', rank, 'is NOT in the new communicator.'
  end if

  ! Free groups (no comm_free)
  call MPI_GROUP_FREE(group_range, ierr)
  call MPI_GROUP_FREE(group_world, ierr)

  call MPI_FINALIZE(ierr)
end program minimal_mre_range