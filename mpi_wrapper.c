#include <mpi.h>

void mpi_init_wrapper(int *ierr) {
    int argc = 0;
    char **argv = NULL;
    *ierr = MPI_Init(&argc, &argv);
}

void mpi_init_thread_wrapper(int *required, int *provided, int *ierr) {
    int argc = 0;
    char **argv = NULL;
    *ierr = MPI_Init_thread(&argc, &argv, *required, provided);
}

void mpi_finalize_wrapper(int *ierr) {
    *ierr = MPI_Finalize();
}

void mpi_comm_size_wrapper(int *comm_f, int *size, int *ierr) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierr = MPI_Comm_size(comm, size);
}

void mpi_bcast_int_wrapper(int *buffer, int *count, int *datatype_f, int *root, int *comm_f, int *ierror) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    MPI_Datatype datatype;
    switch (*datatype_f) {
        case 0:
            datatype = MPI_INT;
            break;
        case 1:
            datatype = MPI_FLOAT;
            break;
        case 2:
            datatype = MPI_DOUBLE;
            break;
        default:
            *ierror = -1;
            return;
    }
    *ierror = MPI_Bcast(buffer, *count, datatype, *root, comm);
}

void mpi_bcast_real_wrapper(double *buffer, int *count, int *datatype_f, int *root, int *comm_f, int *ierror) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    MPI_Datatype datatype;
    switch (*datatype_f) {
        case 0:
            datatype = MPI_FLOAT;
            break;
        case 1:
            datatype = MPI_DOUBLE;
            break;
        default:
            *ierror = -1;
            return;
    }
    *ierror = MPI_Bcast(buffer, *count, datatype, *root, comm);
}
