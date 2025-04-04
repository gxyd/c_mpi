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

MPI_Info get_c_info_from_fortran(int info) {
    if (info == FORTRAN_MPI_INFO_NULL) {
        return MPI_INFO_NULL;
    } else {
        return MPI_Info_f2c(info);
    }
}

MPI_Op get_c_op_from_fortran(int op) {
    if (op == FORTRAN_MPI_SUM) {
        return MPI_SUM;
    } else {
        return MPI_Op_f2c(op);
    }
}

MPI_Comm get_c_comm_from_fortran(int comm_f) {
    if (comm_f == FORTRAN_MPI_COMM_WORLD) {
        return MPI_COMM_WORLD;
    } else {
        return MPI_Comm_f2c(comm_f);
    }
}

void* get_c_mpi_inplace_from_fortran(double sendbuf) {
    return MPI_IN_PLACE;
}

void mpi_waitall_wrapper(int *count, int *array_of_requests_f,
                        int *array_of_statuses_f, int *ierror) {
    MPI_Request *array_of_requests;
    MPI_Status *array_of_statuses;
    array_of_requests = (MPI_Request *)malloc((*count) * sizeof(MPI_Request));
    array_of_statuses = (MPI_Status *)malloc((*count) * sizeof(MPI_Status));
    if (array_of_requests == NULL || array_of_statuses == NULL) {
        *ierror = MPI_ERR_NO_MEM;
        return;
    }
    for (int i = 0; i < *count; i++) {
        array_of_requests[i] = MPI_Request_f2c(array_of_requests_f[i]);
    }

    *ierror = MPI_Waitall(*count, array_of_requests, array_of_statuses);
    for (int i = 0; i < *count; i++) {
        array_of_requests_f[i] = MPI_Request_c2f(array_of_requests[i]);
    }

    for (int i = 0; i < *count; i++) {
        MPI_Status_c2f(&array_of_statuses[i], &array_of_statuses_f[i * MPI_STATUS_SIZE]);
    }

    free(array_of_requests);
    free(array_of_statuses);
}
