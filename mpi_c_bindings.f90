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

        subroutine c_mpi_comm_size(comm, size, ierr) bind(C, name="mpi_comm_size_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: size
            integer(c_int), intent(out) :: ierr
        end subroutine c_mpi_comm_size

        subroutine c_mpi_bcast_int(buffer, count, datatype, root, comm, ierror) bind(C, name="mpi_bcast_int_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int) :: buffer
            integer(c_int), intent(in) :: count, root
            integer(c_int), intent(in) :: datatype
            integer(c_int), intent(in) :: comm
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        subroutine c_mpi_bcast_real(buffer, count, datatype, root, comm, ierror) bind(C, name="mpi_bcast_real_wrapper")
            use iso_c_binding, only : c_int, c_double
            real(c_double), dimension(*) :: buffer
            integer(c_int), intent(in) :: count, root
            integer(c_int), intent(in) :: datatype
            integer(c_int), intent(in) :: comm
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        subroutine c_mpi_allgather_int(sendbuf, sendcount, sendtype, recvbuf, &
            recvcount, recvtype, comm, ierror) bind(C, name="mpi_allgather_int_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), dimension(*), intent(in) :: sendbuf
            integer(c_int), dimension(*) :: recvbuf
            integer(c_int), intent(in) :: sendcount, recvcount
            integer(c_int), intent(in) :: sendtype, recvtype
            integer(c_int), intent(in) :: comm
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        subroutine c_mpi_allgather_real(sendbuf, sendcount, sendtype, recvbuf, &
                    recvcount, recvtype, comm, ierror) bind(C, name="mpi_allgather_real_wrapper")
            use iso_c_binding, only: c_int, c_double
            real(c_double), dimension(*), intent(in) :: sendbuf
            real(c_double), dimension(*) :: recvbuf
            integer(c_int), intent(in) :: sendcount, recvcount
            integer(c_int), intent(in) :: sendtype, recvtype
            integer(c_int), intent(in) :: comm
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        subroutine c_mpi_isend(buf, count, datatype, dest, tag, comm, request, ierror) bind(C, name="mpi_isend_wrapper")
            use iso_c_binding, only: c_int, c_double
            real(c_double), dimension(*), intent(in) :: buf
            integer(c_int), intent(in) :: count, dest, tag
            integer(c_int), intent(in) :: datatype
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: request
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

    end interface
end module mpi_c_bindings
