subroutine uop( cin, cout, count)
    use mpi
    integer cin(*), cout(*)
    integer count
    integer i

    do i=1, count
        cout(i) = cin(i) + cout(i)
    enddo
end subroutine
  
program main
    use mpi
    external uop
    integer ierr, errs
    real(8)  :: vin(65000),vout(65000)
    integer :: i, count, size
    integer :: comm

    errs = 0

    call mpi_init(ierr)

    comm = MPI_COMM_WORLD
    call mpi_comm_size( comm, size, ierr )
    count = 1
    do while (count .lt. 65000)
        do i=1, count
            vin(i) = i
            vout(i) = -1
        enddo
        call mpi_allreduce( vin, vout, count, MPI_REAL8, MPI_SUM, comm, ierr )
    !         Check that all results are correct
        do i=1, count
            if (vout(i) .ne. i * size) then
                errs = errs + 1
                if (errs .lt. 10) print *, "vout(",i,") = ", vout(i)
            endif
        enddo
        count = count + count
    enddo

    print *, "Allreduce test completed with ", errs, " errors."


    call mpi_finalize(errs)
end
