program test_waitall  
    use mpi  
    implicit none  

    integer :: ierr, rank, size, tag  
    integer, parameter :: num_reqs = 2  
    integer, dimension(num_reqs) :: reqs  
    ! For statuses, we need an array of size num_reqs * MPI_STATUS_SIZE.  
    integer, dimension(num_reqs*MPI_STATUS_SIZE) :: statuses  
    real(8), dimension(3,3) :: buf1, buf2  
    integer :: i  

    tag  = 100  

    call MPI_Init(ierr)  
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)  
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)  

    if (size < 2) then  
        print *, "This test requires at least 2 MPI processes."  
        ! call MPI_Finalize(ierr) ! Remove stop and finalize  
        ! stop 1  
    else  
        if (rank == 0) then  
            ! Rank 0 sends two messages using MPI_Ssend.  
            buf1 = reshape([(i, i=1, 9)], shape=(/3,3/)) 
            buf2 = reshape([(i, i=1, 9)], shape=(/3,3/)) 
            call MPI_Ssend(buf1, 10, MPI_REAL8, 1, tag, MPI_COMM_WORLD, ierr)  
            call MPI_Ssend(buf2, 10, MPI_REAL8, 1, tag, MPI_COMM_WORLD, ierr)  
            print *, "Rank 0 sent two messages."  
        else if (rank == 1) then  
            ! Rank 1 posts two nonblocking receives.  
            call MPI_Irecv(buf1, 10, MPI_REAL8, 0, tag, MPI_COMM_WORLD, reqs(1), ierr) 
            call MPI_Irecv(buf2, 10, MPI_REAL8, 0, tag, MPI_COMM_WORLD, reqs(2), ierr)

            ! Wait on both requests.  
            call MPI_Waitall(num_reqs, reqs, statuses, ierr)  

            print *, "Rank 1 received buf1 =", buf1  
            print *, "Rank 1 received buf2 =", buf2  
        end if  
    end if  

    call MPI_Finalize(ierr)  

end program test_waitall