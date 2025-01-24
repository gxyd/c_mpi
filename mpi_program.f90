module mpi
    implicit none

    interface MPI_Init
        module procedure MPI_Init_proc
    end interface MPI_Init

    interface MPI_Init_thread
        module procedure MPI_Init_thread_proc
    end interface MPI_Init_thread

    interface MPI_Finalize
        module procedure MPI_Finalize_proc
    end interface MPI_Finalize

    interface MPI_Bcast
        module procedure MPI_Bcast_int
        module procedure MPI_Bcast_real
    end interface

    contains

    subroutine MPI_Init_proc(ierr)
        use mpi_c_bindings, only: c_mpi_init
        use iso_c_binding, only : c_int
        integer(c_int), optional, intent(out) :: ierr
        integer(c_int) :: local_ierr
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
        integer(c_int), intent(in) :: required
        integer(c_int), intent(in) :: provided
        integer(c_int), optional, intent(out) :: ierr
        integer(c_int) :: local_ierr
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
        integer(c_int), optional, intent(out) :: ierr
        integer(c_int) :: local_ierr
        if (present(ierr)) then
            call c_mpi_finalize(ierr)
        else
            call c_mpi_finalize(local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Finalize failed with error code: ", local_ierr
            end if
        end if
    end subroutine

    subroutine MPI_Bcast_int(buffer, count, datatype, root, comm, ierr)
        use iso_c_binding, only: c_int
        use mpi_c_bindings, only: c_mpi_bcast_int
        use mpi_types, only: MPI_Comm
        integer(c_int), intent(inout) :: buffer
        integer(c_int), intent(in) :: count
        integer(c_int), intent(in) :: datatype
        integer(c_int), intent(in) :: root
        type(MPI_Comm), intent(in) :: comm
        integer(c_int), optional, intent(out) :: ierr
        integer(c_int) :: local_ierr
        if (present(ierr)) then
            call c_mpi_bcast_int(buffer, count, datatype, root, comm, ierr)
        else
            call c_mpi_bcast_int(buffer, count, datatype, root, comm, local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Bcast failed with error code: ", local_ierr
            end if
        end if
    end subroutine

    subroutine MPI_Bcast_real(buffer, count, datatype, root, comm, ierr)
        use iso_c_binding, only: c_int, c_float
        use mpi_c_bindings, only: c_mpi_bcast_real
        use mpi_types, only: MPI_Comm
        real(c_float), dimension(:, :), intent(inout) :: buffer
        integer(c_int), intent(in) :: count
        integer(c_int), intent(in) :: datatype
        integer(c_int), intent(in) :: root
        type(MPI_Comm), intent(in) :: comm
        integer(c_int), optional, intent(out) :: ierr
        integer(c_int) :: local_ierr
        if (present(ierr)) then
            call c_mpi_bcast_real(buffer, count, datatype, root, comm, ierr)
        else
            call c_mpi_bcast_real(buffer, count, datatype, root, comm, local_ierr)
            if (local_ierr /= 0) then
                print *, "MPI_Bcast failed with error code: ", local_ierr
            end if
        end if
    end subroutine
end module mpi

program main
    use mpi
    use mpi_types
    use iso_c_binding, only: c_int, c_float
    implicit none
    integer :: ierr
    integer :: required
    integer :: provided
    call MPI_Init_thread(required, provided, ierr)
    print *, "ierr: ", ierr
    call MPI_Finalize(ierr)
    print *, "ierr: ", ierr
end program main
