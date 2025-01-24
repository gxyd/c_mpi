module mpi_types
    use iso_c_binding, only: c_int
    implicit none
    type, bind(C) :: MPI_Comm_c
        integer(kind=c_int) :: MPI_VAL
    end type MPI_Comm_c
end module
