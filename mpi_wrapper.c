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

void mpi_comm_size_wrapper(MPI_Comm *comm, int *size, int *ierr) {
    *ierr = MPI_Comm_size(*comm, size);
}
