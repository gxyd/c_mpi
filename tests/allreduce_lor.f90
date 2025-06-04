program mre_mpi_lor_allreduce
  use mpi
  implicit none

  integer :: ierr, rank, size
  logical :: local_flag, global_flag

  call MPI_INIT(ierr)
  if (ierr /= MPI_SUCCESS) error stop "MPI_INIT failed"

  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierr)

  ! Initialize the local flag: True if this is the 0th rank, False otherwise
  local_flag = (rank == 0)

  ! Perform logical OR reduction across all processes
  call MPI_ALLREDUCE(local_flag, global_flag, 1, MPI_LOGICAL, MPI_LOR, MPI_COMM_WORLD, ierr)
  if (global_flag .neqv. .true.) error stop "MPI_ALLREDUCE failed"

  print *, 'Rank', rank, ': global_flag =', global_flag

  call MPI_FINALIZE(ierr)
  if (ierr /= MPI_SUCCESS) error stop "MPI_FINALIZE failed"

end program mre_mpi_lor_allreduce