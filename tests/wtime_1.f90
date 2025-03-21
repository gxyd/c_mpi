program wtime_1
    use, intrinsic:: iso_fortran_env, only: dp=>real64
    use mpi
    implicit none
    integer :: id, Nproc, ierr
    real(dp) :: wtime

    !>  Initialize MPI.
    call MPI_Init(ierr)

    !>  Get the number of processes.
    call MPI_Comm_size(MPI_COMM_WORLD, Nproc, ierr)

    !>  Get the individual process ID.
    call MPI_Comm_rank(MPI_COMM_WORLD, id, ierr)

    !>  Print a message.
    if (id == 0) then
        wtime = MPI_Wtime()
        print *, 'number of processes: ', Nproc
    end if

    if (id == 0) then
        wtime = MPI_Wtime() - wtime
        print *, 'Elapsed wall clock time = ', wtime, ' seconds.'
    end if

    !>  Shut down MPI.
    call MPI_Finalize(ierr)

end program
