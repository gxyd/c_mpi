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

void mpi_allgather_int_wrapper(const int *sendbuf, int *sendcount, int *sendtype_f,
                               int *recvbuf, int *recvcount, int *recvtype_f, 
                               int *comm_f, int *ierror) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);

    MPI_Datatype sendtype, recvtype;
    switch (*sendtype_f) {
        case 0:
            sendtype = MPI_INT;
            break;
        default:
            *ierror = -1;
            return;
    }

    switch (*recvtype_f) {
        case 0:
            recvtype = MPI_INT;
            break;
        default:
            *ierror = -1;
            return;
    }

    *ierror = MPI_Allgather(sendbuf, *sendcount, sendtype,
                            recvbuf, *recvcount, recvtype, comm);
}

void mpi_allgather_real_wrapper(const double *sendbuf, int *sendcount, int *sendtype_f,
                               double *recvbuf, int *recvcount, int *recvtype_f, 
                               int *comm_f, int *ierror) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);

    MPI_Datatype sendtype, recvtype;
    switch (*sendtype_f) {
        case 0:
            sendtype = MPI_FLOAT;
            break;
        case 1:
            sendtype = MPI_DOUBLE;
            break;
        default:
            *ierror = -1;
            return;
    }

    switch (*recvtype_f) {
        case 0:
            recvtype = MPI_FLOAT;
            break;
        case 1:
            recvtype = MPI_DOUBLE;
            break;
        default:
            *ierror = -1;
            return;
    }

    *ierror = MPI_Allgather(sendbuf, *sendcount, sendtype,
                            recvbuf, *recvcount, recvtype, comm);
}

void mpi_isend_wrapper(const double *buf, int *count, int *datatype_f,
                        int *dest, int *tag, int *comm_f, int *request_f,
                        int *ierror) {
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
            *request_f = -1;
            return;
    }

    MPI_Request request = MPI_Request_f2c(*request_f);
    *ierror = MPI_Isend(buf, *count, datatype, *dest, *tag, comm, &request);
}

void mpi_irecv_wrapper(double *buf, int *count, int *datatype_f,
                        int *source, int *tag, int *comm_f, int *request_f,
                        int *ierror) {
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
            *request_f = -1;
            return;
    }

    MPI_Request request = MPI_Request_f2c(*request_f);
    *ierror = MPI_Irecv(buf, *count, datatype, *source, *tag, comm, &request);
}

void mpi_allreduce_wrapper(const double *sendbuf, double *recvbuf, int *count,
                            int *datatype_f, int *op_f, int *comm_f, int *ierror) {
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

    // I'm a little doubtful: as how would it identify that this part
    // is supposed to be for MPI_SUM?
    MPI_Op op = MPI_Op_f2c(*op_f);
    // I've hard-coded as "MPI_SUM" for now, as in POT3D codebase, it's always
    // used as MPI_SUM
    *ierror = MPI_Allreduce(sendbuf, recvbuf, *count, datatype, MPI_SUM, comm);
}

double mpi_wtime_wrapper() {
    return MPI_Wtime();
}

void mpi_barrier_wrapper(int *comm_f, int *ierror) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Barrier(comm);
}

void mpi_comm_rank_wrapper(int *comm_f, int *rank, int *ierror) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Comm_rank(comm, rank);
}

void mpi_comm_split_type_wrapper(int *comm_f, int *split_type, int *key,
                                int *info_f, int *newcomm_f, int *ierror) {
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    MPI_Info info = MPI_Info_f2c(*info_f);
    MPI_Comm newcomm = MPI_Comm_f2c(*newcomm_f);
    *ierror = MPI_Comm_split_type( comm, *split_type, *key , info, &newcomm);
}
