#include <mpi.h>

MPI_Datatype get_c_MPI_DOUBLE() {
    return MPI_DOUBLE;
}

MPI_Datatype get_c_MPI_FLOAT() {
    return MPI_FLOAT;
}

MPI_Datatype get_c_MPI_INT() {
    return MPI_INT;
}

MPI_Op get_c_MPI_SUM() {
    return MPI_SUM;
}

MPI_Comm get_c_MPI_COMM_WORLD() {
    return MPI_COMM_WORLD;
}

void* get_c_MPI_IN_PLACE() {
    return MPI_IN_PLACE;
}

MPI_Status* c_MPI_STATUSES_IGNORE = MPI_STATUSES_IGNORE;

MPI_Info c_MPI_INFO_NULL = MPI_INFO_NULL;
