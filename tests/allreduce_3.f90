program allreduce_3
    use mpi
    implicit none
    
    integer :: ierr
    integer :: rank
    integer :: nprocs
    integer, parameter :: array_size = 4
    integer :: local_array(array_size)
    integer :: global_sum(array_size)
    integer :: expected_sum(array_size)
    integer :: i

    call MPI_INIT(ierr)

    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nprocs, ierr)

    do i = 1, array_size
        local_array(i) = (rank + 1) * i
    end do
    
    print *, 'Rank ', rank, ' has local array = ', local_array

    call MPI_Allreduce(local_array, global_sum, array_size, MPI_INTEGER, &
                      MPI_SUM, MPI_COMM_WORLD, ierr)
    
    print *, 'Rank ', rank, ' sees global sum = ', global_sum

    do i = 1, array_size
        expected_sum(i) = i * nprocs * (nprocs + 1) / 2
    end do

    do i = 1, array_size
        if (global_sum(i) /= expected_sum(i)) then
            print *, 'Error on Rank ', rank, ' at position ', i, &
                    ': global_sum = ', global_sum(i), &
                    ' does not match expected_sum = ', expected_sum(i)
            error stop
        end if
    end do

    call MPI_FINALIZE(ierr)
end program allreduce_3
