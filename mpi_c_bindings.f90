module mpi_c_bindings
    use iso_c_binding, only: c_int, c_float

    ! type, bind(C) :: MPI_Comm
    !     integer(c_int) :: MPI_VAL
    ! end type
    implicit none

    interface
        subroutine c_mpi_init(ierr) bind(C, name="mpi_init_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_init

        subroutine c_mpi_init_thread(required, provided, ierr) bind(C, name="mpi_init_thread_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), intent(in) :: required
            integer(c_int), intent(in) :: provided
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_init_thread

        subroutine c_mpi_finalize(ierr) bind(C, name="mpi_finalize_wrapper")
            use iso_c_binding, only : c_int
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_finalize

        subroutine c_mpi_comm_size(comm, size, ierr) bind(C, name="mpi_comm_size_wrapper")
            use iso_c_binding, only: c_int
            use mpi_types, only: MPI_Comm_c
            type(MPI_Comm_c), intent(in) :: comm
            integer(c_int), intent(out) :: size
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_comm_size
    end interface
end module mpi_c_bindings
