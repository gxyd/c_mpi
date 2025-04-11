#include <mpi.h>
#include <stdlib.h>
#include <stdio.h>

#define MPI_STATUS_SIZE 5

#define FORTRAN_MPI_COMM_WORLD -1000
#define FORTRAN_MPI_INFO_NULL -2000
#define FORTRAN_MPI_IN_PLACE -1002

#define FORTRAN_MPI_SUM -2300

#define FORTRAN_MPI_INTEGER -10002
#define FORTRAN_MPI_DOUBLE_PRECISION -10004
#define FORTRAN_MPI_REAL4 -10013
#define FORTRAN_MPI_REAL8 -10014


MPI_Datatype get_c_datatype_from_fortran(int datatype) {
    MPI_Datatype c_datatype;
    switch (datatype) {
        case FORTRAN_MPI_REAL4:
            c_datatype = MPI_FLOAT;
            break;
        case FORTRAN_MPI_REAL8:
        case FORTRAN_MPI_DOUBLE_PRECISION:
            c_datatype = MPI_DOUBLE;
            break;
        case FORTRAN_MPI_INTEGER:
            c_datatype = MPI_INT;
            break;
    }
    return c_datatype;
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
