module mpi_c_bindings
    implicit none

    interface
        function c_mpi_comm_f2c(comm_f) bind(C, name="get_c_comm_from_fortran")
            use iso_c_binding, only: c_int, c_ptr
            integer(c_int), value :: comm_f
            type(c_ptr) :: c_mpi_comm_f2c  ! MPI_Comm as pointer
        end function c_mpi_comm_f2c

        function c_mpi_comm_c2f(comm_c) bind(C, name="MPI_Comm_c2f")
            use iso_c_binding, only: c_int, c_ptr
            type(c_ptr), value :: comm_c
            integer(c_int) :: c_mpi_comm_c2f
        end function

        function c_mpi_request_c2f(request) bind(C, name="MPI_Request_c2f")
            use iso_c_binding, only: c_int, c_ptr
            type(c_ptr), value :: request
            integer(c_int) :: c_mpi_request_c2f
        end function

        function c_mpi_datatype_f2c(datatype) bind(C, name="get_c_datatype_from_fortran")
            use iso_c_binding, only: c_int, c_ptr
            integer(c_int), value :: datatype
            type(c_ptr) :: c_mpi_datatype_f2c
        end function c_mpi_datatype_f2c

        function c_mpi_op_f2c(op_f) bind(C, name="get_c_op_from_fortran")
            use iso_c_binding, only: c_ptr, c_int
            integer(c_int), value :: op_f
            type(c_ptr)           :: c_mpi_op_f2c
        end function c_mpi_op_f2c

        function c_mpi_init(argc, argv) bind(C, name="MPI_Init")
            use iso_c_binding, only : c_int, c_ptr
            !> TODO: is the intent need to be explicitly specified
            !> as 'intent(inout)'? Though, currently LFortran
            !> errors with this
            integer(c_int) :: argc
            type(c_ptr) :: argv
            integer(c_int) :: c_mpi_init
        end function c_mpi_init

        function c_mpi_init_thread(argc, argv, required, provided) bind(C, name="MPI_Init_thread")
            use iso_c_binding, only: c_int, c_ptr
            integer(c_int) :: argc
            type(c_ptr) :: argv
            integer(c_int), value :: required
            integer(c_int), intent(out) :: provided
            integer(c_int) :: c_mpi_init_thread
        end function c_mpi_init_thread

        integer(c_int) function c_mpi_finalize() bind(C, name="MPI_Finalize")
            use iso_c_binding, only : c_int
        end function c_mpi_finalize

        function c_mpi_comm_size(comm, size) bind(C, name="MPI_Comm_size")
            use iso_c_binding, only: c_int, c_ptr
            type(c_ptr), value :: comm
            integer(c_int), intent(out) :: size
            integer(c_int) :: c_mpi_comm_size
        end function c_mpi_comm_size

        function c_mpi_bcast(buffer, count, datatype, root, comm) bind(C, name="MPI_Bcast")
            use iso_c_binding, only : c_ptr, c_int
            type(c_ptr), value :: buffer
            integer(c_int), value :: count
            type(c_ptr), value :: datatype
            integer(c_int), value :: root
            type(c_ptr), value :: comm
            integer(c_int) :: c_mpi_bcast
        end function c_mpi_bcast

        function c_mpi_allgather_int(sendbuf, sendcount, sendtype, recvbuf, &
            recvcount, recvtype, comm) bind(C, name="MPI_Allgather")
            use iso_c_binding, only: c_int, c_ptr
            type(c_ptr), value :: sendbuf
            type(c_ptr), dimension(*), intent(out) :: recvbuf
            integer(c_int), value :: sendcount, recvcount
            type(c_ptr), value :: sendtype, recvtype
            type(c_ptr), value :: comm
            integer(c_int) :: c_mpi_allgather_int
        end function

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

        function c_mpi_irecv(buf, count, datatype, source, tag, comm, request) bind(C, name="MPI_Irecv")
            use iso_c_binding, only: c_int, c_double, c_ptr
            real(c_double), dimension(*), intent(out) :: buf
            integer(c_int), value :: count, source, tag
            type(c_ptr), value :: datatype
            type(c_ptr), value :: comm
            type(c_ptr), intent(out) :: request
            integer(c_int) :: c_mpi_irecv
        end function

        subroutine c_mpi_allreduce_scalar(sendbuf, recvbuf, count, datatype, op, comm, ierror) &
                                                    bind(C, name="mpi_allreduce_wrapper_real")
            use iso_c_binding, only: c_int, c_double
            real(c_double), intent(in) :: sendbuf
            real(c_double), intent(out) :: recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out), optional :: ierror
        end subroutine

        subroutine c_mpi_allreduce_1d(sendbuf, recvbuf, count, datatype, op, comm, ierror) &
                                                    bind(C, name="mpi_allreduce_wrapper_real")
            use iso_c_binding, only: c_int, c_double
            real(c_double), intent(in) :: sendbuf
            real(c_double), dimension(*), intent(out) :: recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out), optional :: ierror
        end subroutine

        subroutine c_mpi_allreduce_array_real(sendbuf, recvbuf, count, datatype, op, comm, ierror) &
                                                    bind(C, name="mpi_allreduce_wrapper_real")
            use iso_c_binding, only: c_int, c_double
            real(c_double), dimension(*), intent(in)  :: sendbuf
            real(c_double), dimension(*), intent(out) :: recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out), optional :: ierror
        end subroutine c_mpi_allreduce_array_real

        subroutine c_mpi_allreduce_array_int(sendbuf, recvbuf, count, datatype, op, comm, ierror) &
                                                    bind(C, name="mpi_allreduce_wrapper_int")
            use iso_c_binding, only: c_int, c_double
            integer(c_int), dimension(*), intent(in)  :: sendbuf
            integer(c_int), dimension(*), intent(out) :: recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out), optional :: ierror
        end subroutine c_mpi_allreduce_array_int

        function c_mpi_wtime() result(time) bind(C, name="MPI_Wtime")
            use iso_c_binding, only: c_double
            real(c_double) :: time
        end function

        function c_mpi_barrier(comm) bind(C, name="MPI_Barrier")
            use iso_c_binding, only: c_ptr, c_int
            type(c_ptr), value :: comm      ! MPI_Comm as pointer
            integer(c_int) :: c_mpi_barrier
        end function c_mpi_barrier

        function c_mpi_comm_rank(comm, rank) bind(C, name="MPI_Comm_rank")
            use iso_c_binding, only: c_int, c_ptr
            type(c_ptr), value :: comm
            integer(c_int), intent(out) :: rank
            integer(c_int) :: c_mpi_comm_rank
        end function c_mpi_comm_rank

        subroutine c_mpi_comm_split_type(comm, split_type, key, info, newcomm, ierror) bind(C, name="mpi_comm_split_type_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int) :: comm
            integer(c_int), intent(in) :: split_type, key
            integer(c_int), intent(in) :: info
            integer(c_int), intent(out) :: newcomm
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        subroutine c_mpi_recv(buf, count, datatype, source, tag, comm, status, ierror) bind(C, name="mpi_recv_wrapper")
            use iso_c_binding, only: c_int, c_double
            real(c_double), dimension(*) :: buf
            integer(c_int), intent(in) :: count, source, tag
            integer(c_int), intent(in) :: datatype
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: status
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        subroutine c_mpi_waitall(count, array_of_requests, array_of_statuses, ierror) bind(C, name="mpi_waitall_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), intent(in) :: count
            integer(c_int), intent(inout) :: array_of_requests(count)
            integer(c_int) :: array_of_statuses(*)
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        subroutine c_mpi_ssend(buf, count, datatype, dest, tag, comm, ierror) bind(C, name="mpi_ssend_wrapper")
            use iso_c_binding, only: c_int, c_double
            real(c_double), dimension(*), intent(in) :: buf
            integer(c_int), intent(in) :: count, dest, tag
            integer(c_int), intent(in) :: datatype
            integer(c_int), intent(in) :: comm
            integer(c_int), optional, intent(out) :: ierror
        end subroutine

        function c_mpi_cart_create(comm_old, ndims, dims, periods, reorder, comm_cart) bind(C, name="MPI_Cart_create")
            use iso_c_binding, only: c_int, c_ptr
            type(c_ptr), value :: comm_old
            integer(c_int), value :: ndims, reorder
            integer(c_int), intent(in) :: dims(*), periods(*)
            type(c_ptr), intent(out) :: comm_cart
            integer(c_int) :: c_mpi_cart_create
        end function

        function c_mpi_cart_coords(comm, rank, maxdims, coords) bind(C, name="MPI_Cart_coords")
            use iso_c_binding,  only: c_int, c_ptr
            type(c_ptr), value :: comm
            integer(c_int), value :: rank, maxdims
            integer(c_int), intent(out) :: coords(*)
            integer(c_int) :: c_mpi_cart_coords
        end function

        subroutine c_mpi_cart_shift(comm, direction, disp, rank_source, rank_dest, ierror) bind(C, name="mpi_cart_shift_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), intent(in) :: comm, direction, disp
            integer(c_int), intent(out) :: rank_source, rank_dest, ierror
        end subroutine

        function c_mpi_dims_create(nnodes, ndims, dims) bind(C, name="MPI_Dims_create")
            use iso_c_binding, only: c_int, c_ptr
            integer(c_int), value :: nnodes, ndims
            integer(c_int), intent(inout) :: dims(*)
            integer(c_int) :: c_mpi_dims_create
        end function

        subroutine c_mpi_cart_sub(comm, remain_dims, newcomm, ierror) bind(C, name ="mpi_cart_sub_wrapper")
            use iso_c_binding, only: c_int
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(in) :: remain_dims(*)
            integer(c_int), intent(out) :: newcomm, ierror
        end subroutine

        function c_mpi_reduce(sendbuf, recvbuf, count, c_dtype, c_op, root, c_comm) &
            bind(C, name="MPI_Reduce")
            use iso_c_binding, only: c_ptr, c_int

            type(c_ptr), value :: sendbuf
            type(c_ptr), value :: recvbuf
            integer(c_int), value :: count
            type(c_ptr), value :: c_dtype
            type(c_ptr), value :: c_op 
            integer(c_int), value :: root
            type(c_ptr), value :: c_comm
           integer(c_int) :: c_mpi_reduce
        end function c_mpi_reduce

    end interface
end module mpi_c_bindings
