module mpi
    implicit none
    integer, parameter :: MPI_THREAD_FUNNELED = 1

    type :: MPI_Comm
        integer :: MPI_VAL
    end type

    type(MPI_Comm), parameter :: MPI_COMM_WORLD = MPI_Comm(0)

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
        use mpi_types, only: MPI_Comm_c
        type(MPI_Comm), intent(in) :: comm
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierr
        integer :: local_ierr
        type(MPI_Comm_c) :: comm_c
        comm_c = MPI_Comm_c(comm%MPI_VAL)
        if (present(ierr)) then
            call c_mpi_comm_size(comm_c, size, ierr)
        else
            call c_mpi_comm_size(comm_c, size, local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Comm_size failed with error code: ", local_ierr
            end if
        end if
    end subroutine
end module mpi

program main
    use mpi
    implicit none
    integer :: ierr
    integer :: required
    integer :: provided
    integer :: tcheck
    integer :: nproc

    ! NOTE: called in pot3d.F90 as:
    call MPI_Init_thread (MPI_THREAD_FUNNELED,tcheck,ierr)
    ! call MPI_Init_thread(required, provided, ierr)
    if (ierr /= 0) error stop "MPI_Init_thread failed"

    ! NOTE: called in pot3d.F90 as:
    call MPI_Comm_size (MPI_COMM_WORLD,nproc,ierr)

    ! called in pot3d.F90 as
    ! call MPI_Finalize (ierr)
    call MPI_Finalize(ierr)
    if (ierr /= 0) error stop "MPI_Finalize failed"
end program main
