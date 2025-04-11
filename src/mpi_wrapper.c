#include <mpi.h>

#define FORTRAN_MPI_SUM -2300

MPI_Datatype get_c_MPI_FLOAT() {
    return MPI_FLOAT;
}

MPI_Datatype get_c_MPI_DOUBLE() {
    return MPI_DOUBLE;
}

MPI_Datatype get_c_MPI_INT() {
    return MPI_INT;
}

MPI_Info get_c_MPI_INFO_NULL() {
    return MPI_INFO_NULL;
}

MPI_Op get_c_op_from_fortran(int op) {
    if (op == FORTRAN_MPI_SUM) {
        return MPI_SUM;
    } else {
        return MPI_Op_f2c(op);
    }
}

MPI_Comm get_c_MPI_COMM_WORLD() {
    return MPI_COMM_WORLD;
}

void* get_c_MPI_IN_PLACE() {
    return MPI_IN_PLACE;
}

MPI_Status* get_c_MPI_STATUSES_IGNORE() {
    return MPI_STATUSES_IGNORE;
}
