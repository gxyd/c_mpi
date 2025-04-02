program allreduce_2
    use mpi
    implicit none
    
    integer :: ierr
    integer :: rank
    integer :: nprocs
    real(8) :: local_val
    real(8) :: global_sum
    real(8) :: expected_sum
    real(8), parameter :: tol = 1.0e-12

    call MPI_INIT(ierr)

    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

    local_val = rank + 1
    print *, 'Rank ', rank, ' has local value = ', local_val

    ! this tests MPI_Allreduce where the first argument is of type 'REAL8'
    call MPI_Allreduce(local_val, global_sum, 1, MPI_REAL8, MPI_SUM, MPI_COMM_WORLD, ierr)
    print *, 'Rank ', rank, ' sees global sum = ', global_sum
    ! calculate expected sum: n * (n + 1) / 2, where n = nprocs
    expected_sum = real(nprocs, 8) * real(nprocs + 1, 8) / 2.0_8

    if (abs(global_sum - expected_sum) > tol) then
        print *, 'Error on Rank ', rank, ': global_sum = ', global_sum, &
                 ' does not match expected_sum = ', expected_sum
        error stop
    end if

    call MPI_FINALIZE(ierr)
end program allreduce_2
