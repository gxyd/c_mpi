!> program obtained using: https://grok.com/share/bGVnYWN5_9c35b809-fc05-4856-82d2-be4ded09d890
!> with query: Write a simple MPI code in Fortran to compute "pi" using Monte Carlo in parallel
program compute_pi
    use mpi
    implicit none

    integer, parameter :: N_per_process = 100000  ! Number of points per process
    integer :: rank, num_procs, ierr             ! MPI variables: rank, number of processes, error code
    integer :: local_M = 0                       ! Local count of points inside quarter circle
    integer :: global_M                          ! Global count of points inside quarter circle
    integer :: total_N                           ! Total number of points across all processes
    real(8) :: x, y                              ! Coordinates of random points
    real(8) :: pi_approx                         ! Approximated value of pi
    integer :: i                                 ! Loop variable
    integer :: seed_size                         ! Size of the random seed array
    integer, allocatable :: seed(:)              ! Seed array for random number generator

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, num_procs, ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

    ! Set up unique random seed for each process
    call random_seed(size=seed_size)
    allocate(seed(seed_size))
    do i = 1, seed_size
        seed(i) = 12345 + rank + i  ! Unique seed based on rank
    end do
    call random_seed(put=seed)

    ! Generate random points and count those inside the quarter circle
    do i = 1, N_per_process
        call random_number(x)
        call random_number(y)
        if (x**2 + y**2 <= 1.0d0) then
            local_M = local_M + 1
        end if
    end do

    ! Sum local counts into global count on root process (rank 0)
    call MPI_Reduce(local_M, global_M, 1, MPI_INTEGER, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    ! Compute and display the result on the root process
    if (rank == 0) then
        total_N = N_per_process * num_procs
        pi_approx = 4.0d0 * dble(global_M) / dble(total_N)
        print *, 'Number of processes:', num_procs
        print *, 'Total number of points:', total_N
        print *, 'Approximation of pi:', pi_approx
    end if

    ! Finalize MPI
    call MPI_Finalize(ierr)

    ! Clean up (optional, as Fortran deallocates automatically at program end)
    if (allocated(seed)) deallocate(seed)

end program compute_pi
