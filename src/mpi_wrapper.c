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

void mpi_isend_wrapper(const double *buf, int *count, int *datatype_f,
                        int *dest, int *tag, int *comm_f, int *request_f,
                        int *ierror) {
    MPI_Comm comm = get_c_comm_from_fortran(*comm_f);
    MPI_Datatype datatype = get_c_datatype_from_fortran(*datatype_f);

    MPI_Request request;
    *ierror = MPI_Isend(buf, *count, datatype, *dest, *tag, comm, &request);
    *request_f = MPI_Request_c2f(request);
}

void mpi_allreduce_wrapper_real(const double *sendbuf, double *recvbuf, int *count,
                            int *datatype_f, int *op_f, int *comm_f, int *ierror) {
    MPI_Comm comm = get_c_comm_from_fortran(*comm_f);
    MPI_Datatype datatype = get_c_datatype_from_fortran(*datatype_f);

    // I'm a little doubtful: as how would it identify that this part
    // is supposed to be for MPI_SUM?
    MPI_Op op = MPI_Op_f2c(*op_f);
    /*
    hard-code values here:
    1. We've hard-coded op as "MPI_SUM" for now, as in POT3D codebase, it's always
       used as MPI_SUM
    2. the first argument (i.e. sendbuf) as "MPI_IN_PLACE" for now as it's always
       used as such in POT3D codebase
    */
   if (*sendbuf == FORTRAN_MPI_IN_PLACE) {
        *ierror = MPI_Allreduce(MPI_IN_PLACE , recvbuf, *count, datatype, MPI_SUM, comm);
   } else {
        *ierror = MPI_Allreduce(sendbuf , recvbuf, *count, datatype, MPI_SUM, comm);
   }
}

void mpi_allreduce_wrapper_int(const int *sendbuf, int *recvbuf, int *count,
                            int *datatype_f, int *op_f, int *comm_f, int *ierror) {
    MPI_Comm comm = get_c_comm_from_fortran(*comm_f);
    MPI_Datatype datatype;
    datatype = MPI_INT;

    MPI_Op op = MPI_Op_f2c(*op_f);

    if (*sendbuf == FORTRAN_MPI_IN_PLACE) {
        *ierror = MPI_Allreduce(MPI_IN_PLACE , recvbuf, *count, datatype, MPI_SUM, comm);
    } else {
        *ierror = MPI_Allreduce(sendbuf , recvbuf, *count, datatype, MPI_SUM, comm);
    }
}

void mpi_recv_wrapper(double *buf, int *count, int *datatype_f, int *source,
                    int *tag, int *comm_f, int *status_f, int *ierror) {
    MPI_Datatype datatype = get_c_datatype_from_fortran(*datatype_f);

    MPI_Comm comm = get_c_comm_from_fortran(*comm_f);
    MPI_Status status;
    *ierror = MPI_Recv(buf, *count, datatype, *source, *tag, comm, &status);
    if (*ierror == MPI_SUCCESS) {
        MPI_Status_c2f(&status, status_f);
    }
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

void mpi_cart_shift_wrapper(int * comm_f, int * dir, int * disp, int * rank_source, int * rank_dest, int * ierror)
{
    MPI_Comm comm = get_c_comm_from_fortran(*comm_f);
    *ierror = MPI_Cart_shift(comm, *dir, *disp, rank_source, rank_dest);
}
