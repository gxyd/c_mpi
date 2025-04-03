program waitall_1
    use mpi
    implicit none

    integer, parameter :: lbuf = 100
    integer, parameter :: ntype_real = MPI_DOUBLE_PRECISION
    real(8), dimension(lbuf,2) :: sbuf21, sbuf22
    real(8), dimension(lbuf,2) :: rbuf21, rbuf22
    integer, dimension(4) :: reqs
    integer :: ierr, myrank, nprocs, iproc_tp, iproc_tm
    integer :: comm_all, tag
    real(8) :: expected_rbuf21, expected_rbuf22
    real(8), parameter :: tol = 1.0e-10

    call MPI_Init(ierr)
    comm_all = MPI_COMM_WORLD
    call MPI_Comm_rank(comm_all, myrank, ierr)
    call MPI_Comm_size(comm_all, nprocs, ierr)

    tag = 1

    iproc_tp = mod(myrank + 1, nprocs)
    iproc_tm = mod(myrank - 1 + nprocs, nprocs)

    sbuf21 = myrank + 0.1
    sbuf22 = myrank + 0.2

    call MPI_Isend(sbuf21, lbuf*2, ntype_real, iproc_tp, tag, &
                   comm_all, reqs(1), ierr)

    call MPI_Isend(sbuf22, lbuf*2, ntype_real, iproc_tm, tag, &
                   comm_all, reqs(2), ierr)

    call MPI_Irecv(rbuf21, lbuf*2, ntype_real, iproc_tm, tag, &
                   comm_all, reqs(3), ierr)

    call MPI_Irecv(rbuf22, lbuf*2, ntype_real, iproc_tp, tag, &
                   comm_all, reqs(4), ierr)

    call MPI_Waitall(4, reqs, MPI_STATUSES_IGNORE, ierr)

    expected_rbuf21 = real(iproc_tm) + 0.1
    expected_rbuf22 = real(iproc_tp) + 0.2

    if (any(abs(rbuf21 - expected_rbuf21) > tol)) then
        write(*,*) 'Rank', myrank, ': rbuf21 validation failed'
        write(*,*) 'Expected:', expected_rbuf21
        write(*,*) 'Received:', rbuf21(1,1)
        error stop 'MPI communication error in rbuf21'
    end if

    if (any(abs(rbuf22 - expected_rbuf22) > tol)) then
        write(*,*) 'Rank', myrank, ': rbuf22 validation failed'
        write(*,*) 'Expected:', expected_rbuf22
        write(*,*) 'Received:', rbuf22(1,1)
        error stop 'MPI communication error in rbuf22'
    end if

    if (myrank == 0) then
      write(*,*) 'Process', myrank, 'received data:'
      write(*,*) 'rbuf21(1,1) =', rbuf21(1,1), ' (Expected:', expected_rbuf21, ')'
      write(*,*) 'rbuf22(1,1) =', rbuf22(1,1), ' (Expected:', expected_rbuf22, ')'
    end if

    call MPI_Finalize(ierr)

end program waitall_1
