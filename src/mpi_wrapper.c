#include <mpi.h>

MPI_Op get_c_MPI_SUM() {
    return MPI_SUM;
}

void* get_c_MPI_IN_PLACE() {
    return MPI_IN_PLACE;
}

MPI_Status* c_MPI_STATUSES_IGNORE = MPI_STATUSES_IGNORE;

MPI_Info c_MPI_INFO_NULL = MPI_INFO_NULL;

MPI_Comm c_MPI_COMM_WORLD = MPI_COMM_WORLD;

MPI_Datatype c_MPI_DOUBLE = MPI_DOUBLE;

MPI_Datatype c_MPI_FLOAT = MPI_FLOAT;

MPI_Datatype c_MPI_INT = MPI_INT;
