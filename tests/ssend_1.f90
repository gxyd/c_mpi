program ssend_example
    use mpi
    implicit none
    
    integer, parameter :: ARRAY_SIZE = 10
    integer :: rank, size, ierr, i
    real(8) :: buffer(10)
    integer :: tag = 100
    integer, dimension(MPI_STATUS_SIZE) :: status
    
    ! allocate(buffer(10))
    ! Initialize MPI environment
    call MPI_Init(ierr)
    
    ! Get rank (process ID) and size (total number of processes)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)
    
    if (size < 2) then
        if (rank == 0) then
            print *, "This example requires at least 2 MPI processes"
        end if
        call MPI_Finalize(ierr)
        stop
    end if
    
    ! Process 0 sends data to process 1
    if (rank == 0) then
        ! Initialize the buffer with some values
        do i = 1, 10
            buffer(i) = i * 10
        end do
        
        print *, "Process 0: Sending data using MPI_Ssend..."
        
        ! Using MPI_Ssend (synchronous send)
        ! This will block until process 1 starts receiving
        call MPI_Ssend(buffer, 10, MPI_REAL8, 1, tag, MPI_COMM_WORLD, ierr)
        
        print *, "Process 0: Send completed successfully"
        
    ! Process 1 receives data from process 0
    else if (rank == 1) then
        
        print *, "Process 1: Receiving data..."
        
        ! Clear the buffer
        buffer = 0
        
        ! Receive the message
        call MPI_Recv(buffer, 10, MPI_REAL8, 0, tag, MPI_COMM_WORLD, status, ierr)
        
        print *, "Process 1: Received data:"
        ! write(*, '(10I5)') buffer
        print *, buffer
    end if
    
    ! Finalize MPI environment
    call MPI_Finalize(ierr)
end program ssend_example