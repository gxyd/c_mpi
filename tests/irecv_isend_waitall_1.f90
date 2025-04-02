program irecv_isend_waitall_1
    use mpi
    implicit none
    
    integer, parameter :: N = 4
    real(8) :: array2d(N,N)
    integer :: rank, nprocs, ierr
    integer :: requests(2)
    integer :: i
    ! Added variables for verification
    real(8) :: expected_array(N,N)
    real(8) :: received_array(N,N)

    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

    if (nprocs < 2) then
      if (rank == 0) print *, 'This program requires at least 2 processes'
      call MPI_FINALIZE(ierr)
      stop
    endif

    if (rank == 0) then
      array2d = reshape([(real(i,8), i=1,N*N)], [N,N])
      print *, 'Rank 0 preparing to send array:'
      print *, array2d
      call MPI_ISEND(array2d, N*N, MPI_DOUBLE_PRECISION, 1, 99, &
                    MPI_COMM_WORLD, requests(1), ierr)
      ! Store expected array for later verification
      expected_array = array2d
    endif

    if (rank == 1) then
      call MPI_IRECV(array2d, N*N, MPI_DOUBLE_PRECISION, 0, 99, &
                    MPI_COMM_WORLD, requests(1), ierr)

      print *, 'Rank 1 doing some work before checking receive...'
    endif

    if (rank == 0 .or. rank == 1) then
      call MPI_WAITALL(1, requests, MPI_STATUSES_IGNORE, ierr)
    endif

    if (rank == 1) then
      print *, 'Rank 1 received array:'
      print *, array2d
      ! Store received array for verification
      received_array = array2d
    endif

    call MPI_BCAST(received_array, N*N, MPI_DOUBLE_PRECISION, 1, MPI_COMM_WORLD, ierr)
    ! Ensure rank 0 has the expected array broadcast to all ranks
    if (rank /= 0) expected_array = reshape([(real(i,8), i=1,N*N)], [N,N])

    if (any(expected_array /= received_array)) then
      print *, 'Rank ', rank, ': Verification failed - arrays do not match'
      error stop 'MPI communication verification failed'
    endif

    call MPI_FINALIZE(ierr)
end program
