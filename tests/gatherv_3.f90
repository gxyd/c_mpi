program gatherv_3
  use mpi
  implicit none

  integer :: rank, nprocs, ierr
  integer :: local_data(3)
  integer, allocatable :: gathered_data(:)
  integer, allocatable :: counts(:), displacements(:)

  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

  local_data = (/ rank*3+1, rank*3+2, rank*3+3 /)

  allocate(counts(nprocs))
  allocate(displacements(nprocs))

  call gatherIntegers(local_data, gathered_data, counts, displacements, rank, nprocs, MPI_COMM_WORLD)

  deallocate(counts, displacements)
  if (rank == 0) deallocate(gathered_data)

  call MPI_FINALIZE(ierr)

contains

  subroutine gatherIntegers(local_data, gathered_data, counts, displacements, rank, nprocs, comm)
    integer, intent(in) :: local_data(:)
    integer, allocatable, intent(out) :: gathered_data(:)
    integer, intent(out) :: counts(:)
    integer, intent(out) :: displacements(:)
    integer, intent(in) :: rank, nprocs, comm

    integer :: i, total_elements, ierr
    integer :: local_size

    local_size = size(local_data)
    counts = local_size

    displacements(1) = 0
    do i = 2, nprocs
       displacements(i) = displacements(i-1) + counts(i-1)
    end do

    total_elements = local_size * nprocs

    if (rank == 0) then
       allocate(gathered_data(total_elements))
    else
       allocate(gathered_data(1))
    end if

    call MPI_GatherV(local_data, local_size, MPI_INTEGER, &
                     gathered_data, counts, displacements, MPI_INTEGER, &
                     0, comm, ierr)

  end subroutine gatherIntegers

end program gatherv_3
