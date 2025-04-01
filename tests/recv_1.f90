program test_recv_1  
    use mpi  
    implicit none  

    integer :: ierr, rank, size, comm, tag  
    real(8), dimension(5) :: buf  
    integer, dimension(MPI_STATUS_SIZE) :: status  

    comm = MPI_COMM_WORLD  
    tag  = 100  

    call MPI_Init(ierr)  
    call MPI_Comm_rank(comm, rank, ierr)  
    call MPI_Comm_size(comm, size, ierr)  

    if (size < 2) then  
        print *, "This test works best with at least 2 MPI processes."  
    else  
        if (rank == 0) then  
            ! Rank 0: Prepare data and send synchronously.  
            buf = (/ 1.0d0, 2.0d0, 3.0d0, 4.0d0, 5.0d0 /)  
            call MPI_Ssend(buf, 5, MPI_REAL8, 1, tag, comm, ierr)  
            print *, "Rank 0 sent data."  
        else if (rank == 1) then  
            ! Rank 1: Receive the data.  
            buf = 0.0d0  ! initialize to zeros  
            call MPI_Recv(buf, 5, MPI_REAL8, 0, tag, comm, status, ierr)  
            print *, "Rank 1 received data: ", buf  
        end if  
    end if  

    call MPI_Finalize(ierr)  

end program test_recv_1