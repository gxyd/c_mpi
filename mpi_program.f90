module mpi
    implicit none
    integer, parameter :: MPI_THREAD_FUNNELED = 1
    ! not sure if this is correct really
    integer, parameter :: MPI_INTEGER = 0
    integer, parameter :: MPI_REAL4 = 0
    integer, parameter :: MPI_REAL8 = 1
    integer, parameter :: MPI_COMM_TYPE_SHARED = 1

    integer, parameter :: MPI_COMM_WORLD = 0
    real(8), parameter :: MPI_IN_PLACE = 1
    integer, parameter :: MPI_SUM = 1
    integer, parameter :: MPI_INFO_NULL = 0

    ! not used in pot3d.F90
    interface MPI_Init
        module procedure MPI_Init_proc
    end interface MPI_Init

    interface MPI_Init_thread
        module procedure MPI_Init_thread_proc
    end interface MPI_Init_thread

    interface MPI_Finalize
        module procedure MPI_Finalize_proc
    end interface MPI_Finalize

    interface MPI_Comm_size
        module procedure MPI_Comm_size_proc
    end interface MPI_Comm_size

    interface MPI_Bcast
        module procedure MPI_Bcast_int
        module procedure MPI_Bcast_real
    end interface MPI_Bcast

    interface MPI_Allgather
        module procedure MPI_Allgather_int
        module procedure MPI_Allgather_real
    end interface MPI_Allgather

    interface MPI_Isend
        module procedure MPI_Isend_2d
        module procedure MPI_Isend_3d
    end interface

    interface MPI_IRecv
        module procedure MPI_IRecv_proc
    end interface

    interface MPI_Allreduce
        module procedure MPI_Allreduce_scalar
        module procedure MPI_Allreduce_1d
    end interface

    interface MPI_Wtime
        module procedure MPI_Wtime_proc
    end interface

    interface MPI_Barrier
        module procedure MPI_Barrier_proc
    end interface

    interface MPI_Comm_rank
        module procedure MPI_Comm_rank_proc
    end interface

    interface MPI_Comm_split_type
        module procedure MPI_Comm_split_type_proc
    end interface

    contains

    subroutine MPI_Init_proc(ierr)
        use mpi_c_bindings, only: c_mpi_init
        use iso_c_binding, only : c_int
        integer, optional, intent(out) :: ierr
        integer :: local_ierr
        if (present(ierr)) then
            call c_mpi_init(ierr)
        else
            call c_mpi_init(local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Init failed with error code: ", local_ierr
            end if
        end if
    end subroutine

    subroutine MPI_Init_thread_proc(required, provided, ierr)
        use mpi_c_bindings, only : c_mpi_init_thread
        use iso_c_binding, only: c_int
        integer, intent(in) :: required
        integer, intent(in) :: provided
        integer, optional, intent(out) :: ierr
        integer :: local_ierr
        if (present(ierr)) then
            call c_mpi_init_thread(required, provided, ierr)
        else
            call c_mpi_init_thread(required, provided, local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Init_thread failed with error code: ", local_ierr
            end if
        end if
    end subroutine

    subroutine MPI_Finalize_proc(ierr)
        use mpi_c_bindings, only: c_mpi_finalize
        use iso_c_binding, only: c_int
        integer, optional, intent(out) :: ierr
        integer :: local_ierr
        if (present(ierr)) then
            call c_mpi_finalize(ierr)
        else
            call c_mpi_finalize(local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Finalize failed with error code: ", local_ierr
            end if
        end if
    end subroutine

    subroutine MPI_Comm_size_proc(comm, size, ierr)
        use mpi_c_bindings, only: c_mpi_comm_size
        integer, intent(in) :: comm
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierr
        integer :: local_ierr
        if (present(ierr)) then
            call c_mpi_comm_size(comm, size, ierr)
        else
            call c_mpi_comm_size(comm, size, local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Comm_size failed with error code: ", local_ierr
            end if
        end if
    end subroutine

    subroutine MPI_Bcast_int(buffer, count, datatype, root, comm, ierror)
        use mpi_c_bindings, only: c_mpi_bcast_int
        integer :: buffer
        integer, intent(in) :: count, root
        integer, intent(in) :: datatype
        integer, intent(in) :: comm
        integer, optional, intent(out) :: ierror
        call c_mpi_bcast_int(buffer, count, datatype, root, comm, ierror)
    end subroutine

    subroutine MPI_Bcast_real(buffer, count, datatype, root, comm, ierror)
        use mpi_c_bindings, only: c_mpi_bcast_real
        real(8), dimension(:, :) :: buffer
        integer, intent(in) :: count, root
        integer, intent(in) :: datatype
        integer, intent(in) :: comm
        integer, optional, intent(out) :: ierror
        call c_mpi_bcast_real(buffer, count, datatype, root, comm, ierror)
    end subroutine

    subroutine MPI_Allgather_int(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, ierror)
        use mpi_c_bindings, only: c_mpi_allgather_int
        integer, dimension(:), intent(in) :: sendbuf
        integer, dimension(:, :) :: recvbuf
        integer, intent(in) :: sendcount, recvcount
        integer, intent(in) :: sendtype, recvtype
        integer, intent(in) :: comm
        integer, optional, intent(out) :: ierror
        call c_mpi_allgather_int(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, ierror)
    end subroutine

    subroutine MPI_Allgather_real(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, ierror)
        use mpi_c_bindings, only: c_mpi_allgather_real
        real(8), dimension(:), intent(in) :: sendbuf
        real(8), dimension(:, :) :: recvbuf
        integer, intent(in) :: sendcount, recvcount
        integer, intent(in) :: sendtype, recvtype
        integer, intent(in) :: comm
        integer, optional, intent(out) :: ierror
        call c_mpi_allgather_real(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, ierror)
    end subroutine

    subroutine MPI_Isend_2d(buf, count, datatype, dest, tag, comm, request, ierror)
        use mpi_c_bindings, only: c_mpi_isend
        real(8), dimension(:, :), intent(in) :: buf
        integer, intent(in) :: count, dest, tag
        integer, intent(in) :: datatype
        integer, intent(in) :: comm
        integer, intent(out) :: request
        integer, optional, intent(out) :: ierror
        call c_mpi_isend(buf, count, datatype, dest, tag, comm, request, ierror)
    end subroutine

    subroutine MPI_Isend_3d(buf, count, datatype, dest, tag, comm, request, ierror)
        use mpi_c_bindings, only: c_mpi_isend
        real(8), dimension(:, :, :), intent(in) :: buf
        integer, intent(in) :: count, dest, tag
        integer, intent(in) :: datatype
        integer, intent(in) :: comm
        integer, intent(out) :: request
        integer, optional, intent(out) :: ierror
        call c_mpi_isend(buf, count, datatype, dest, tag, comm, request, ierror)
    end subroutine

    subroutine MPI_Irecv_proc(buf, count, datatype, source, tag, comm, request, ierror)
        use mpi_c_bindings, only: c_mpi_irecv
        real(8), dimension(:,:) :: buf
        integer, intent(in) :: count, source, tag
        integer, intent(in) :: datatype
        integer, intent(in) :: comm
        integer, intent(out) :: request
        integer, optional, intent(out) :: ierror
        call c_mpi_irecv(buf, count, datatype, source, tag, comm, request, ierror)
    end subroutine

    subroutine MPI_Allreduce_scalar(sendbuf, recvbuf, count, datatype, op, comm, ierror)
        use mpi_c_bindings, only: c_mpi_allreduce_scalar
        real(8), intent(in) :: sendbuf
        real(8), intent(in) :: recvbuf
        integer :: count, datatype, op, comm, ierror
        call c_mpi_allreduce_scalar(sendbuf, recvbuf, count, datatype, op, comm, ierror)
    end subroutine

    subroutine MPI_Allreduce_1d(sendbuf, recvbuf, count, datatype, op, comm, ierror)
        use mpi_c_bindings, only: c_mpi_allreduce_1d
        real(8), intent(in) :: sendbuf
        real(8), dimension(:), intent(in) :: recvbuf
        integer :: count, datatype, op, comm, ierror
        call c_mpi_allreduce_1d(sendbuf, recvbuf, count, datatype, op, comm, ierror)
    end subroutine

    function MPI_Wtime_proc() result(time)
        use mpi_c_bindings, only: c_mpi_wtime
        real(8) :: time
        time = c_mpi_wtime()
    end function

    subroutine MPI_Barrier_proc(comm, ierror)
        use mpi_c_bindings, only: c_mpi_barrier
        integer :: comm, ierror
        call c_mpi_barrier(comm, ierror)
    end subroutine

    subroutine MPI_Comm_rank_proc(comm, rank, ierror)
        use mpi_c_bindings, only: c_mpi_comm_rank
        integer, intent(in) :: comm
        integer, intent(out) :: rank
        integer, optional, intent(out) :: ierror
        call c_mpi_comm_rank(comm, rank, ierror)
    end subroutine

    subroutine MPI_Comm_split_type_proc(comm, split_type, key, info, newcomm, ierror)
        use mpi_c_bindings, only: c_mpi_comm_split_type
        integer :: comm
        integer, intent(in) :: split_type, key
        integer, intent(in) :: info
        integer, intent(out) :: newcomm
        integer, optional, intent(out) :: ierror
        call c_mpi_comm_split_type(comm, split_type, key, info, newcomm, ierror)
    end subroutine
end module mpi

program main
    use mpi
    implicit none
    integer :: ierr
    integer :: required
    integer :: provided
    integer :: tcheck
    integer :: ierr0
    integer :: nproc1
    integer, parameter :: nt_g = 2
    integer, parameter :: np_g = 3
    real(8), dimension(:,:), allocatable :: br0_g
    integer, parameter :: lbuf=4
    integer, dimension(lbuf) :: sbuf
    integer, parameter :: nproc = 2
    integer, dimension(lbuf,0:nproc-1) :: rbuf
    integer :: ntype_real = MPI_REAL8
    integer :: comm_all
    integer, parameter :: nr = 2
    integer, parameter :: nt = 3
    integer, parameter :: np = 2
    real(8), dimension(nr,nt,np) :: a
    integer, parameter :: n1 = 2
    real(8), dimension(n1) :: a0
    integer :: tag=0

    integer, parameter :: lbuf2=10
    real(8), dimension(lbuf2) :: sbuf2
    real(8), dimension(lbuf2,0:nproc-1) :: tbuf
    integer, parameter :: lbuf3 = 10
    integer :: comm_phi
    integer :: iproc_pp
    integer :: reqs(4)
    integer, parameter :: nstack=10
    real(8), dimension(nstack) :: tstart=0.
    integer :: istack=1
    integer :: iprocw
    integer :: comm_shared
    allocate (br0_g(nt_g,np_g))

    ! NOTE: called in pot3d.F90 as:
    call MPI_Init_thread (MPI_THREAD_FUNNELED,tcheck,ierr)
    ! call MPI_Init_thread(required, provided, ierr)
    if (ierr /= 0) error stop "MPI_Init_thread failed"

    ierr = -1
    ! NOTE: called in pot3d.F90 as:
    call MPI_Comm_size (MPI_COMM_WORLD,nproc1,ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Bcast (ierr0,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Bcast(br0_g,nt_g*np_g,ntype_real,0,comm_all,ierr)
    if (ierr /= 0) error stop


    ierr = -1
    call MPI_Allgather (sbuf,lbuf,MPI_INTEGER, &
        rbuf,lbuf,MPI_INTEGER,comm_all,ierr)
    
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Allgather (sbuf2,lbuf2,ntype_real, &
        tbuf,lbuf2,ntype_real,comm_all,ierr)

    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Isend (a(:,:,np-1),lbuf3,ntype_real,iproc_pp,tag, &
        comm_all,reqs(1),ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Irecv (a(:,:, 1),lbuf3,ntype_real,iproc_pp,tag,   &
        comm_all,reqs(3),ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Allreduce (MPI_IN_PLACE,a0,n1,ntype_real, &
        MPI_SUM,comm_phi,ierr)
    if (ierr /= 0) error stop

    tstart(istack)=MPI_Wtime()

    ierr = -1
    call MPI_Barrier(MPI_COMM_WORLD,ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Barrier (comm_all,ierr)
    if (ierr /= 0) error stop

    ierr = -1
    call MPI_Comm_rank (MPI_COMM_WORLD,iprocw,ierr)
    if (ierr /= 0) error stop
    print *, iprocw

    ierr = -1
    call MPI_Comm_split_type (MPI_COMM_WORLD,MPI_COMM_TYPE_SHARED,0, &
        MPI_INFO_NULL,comm_shared,ierr)
    if (ierr /= 0) error stop

    ! called in pot3d.F90 as
    ! call MPI_Finalize (ierr)
    ierr = -1
    call MPI_Finalize(ierr)
    if (ierr /= 0) error stop "MPI_Finalize failed"
end program main
