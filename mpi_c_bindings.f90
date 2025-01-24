module mpi_c_bindings
    use iso_c_binding, only: c_int, c_float
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

        subroutine c_mpi_bcast_int(buffer, count, datatype, root, comm, ierr) bind(C, name="mpi_bcast_int_wrapper")
            use iso_c_binding, only: c_int
            use mpi_types, only: MPI_Comm
            integer(c_int), intent(inout) :: buffer
            integer(c_int), intent(in) :: count
            integer(c_int), intent(in) :: datatype
            integer(c_int), intent(in) :: root
            type(MPI_Comm), intent(in) :: comm
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_bcast_int

        subroutine c_mpi_bcast_real(buffer, count, datatype, root, comm, ierr) bind(C, name="mpi_bcast_real_wrapper")
            use iso_c_binding, only: c_int, c_float
            use mpi_types, only: MPI_Comm
            real(c_float), dimension(*), intent(inout) :: buffer
            integer(c_int), intent(in) :: count
            integer(c_int), intent(in) :: datatype
            integer(c_int), intent(in) :: root
            type(MPI_Comm), intent(in) :: comm
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_bcast_real
    end interface
end module mpi_c_bindings
