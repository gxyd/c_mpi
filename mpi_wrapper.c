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

void mpi_bcast_int_wrapper(void* buffer, int count, int datatype, int root, MPI_Comm comm, int *ierr) {
    *ierr = MPI_Bcast(buffer, count, MPI_INT, root, comm);
}

void mpi_bcast_real_wrapper(float* buffer, int count, int datatype, int root, MPI_Comm comm, int *ierr) {
    *ierr = MPI_Bcast(buffer, count, MPI_FLOAT, root, comm);
}
