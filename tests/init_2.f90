program init_2
    use mpi, only: MPI_Init_thread, MPI_Finalize, MPI_THREAD_FUNNELED
    implicit none
    
    integer :: provided, ierr
    
    ! Initialize MPI with thread support
    call MPI_Init_thread(MPI_THREAD_FUNNELED, provided, ierr)
    
    if (ierr /= 0) then
        print *, "Error initializing MPI with threads"
        error stop
    end if
    print *, "Running MPI with thread support"

    ! Finalize MPI
    call MPI_Finalize(ierr)
end program init_2
