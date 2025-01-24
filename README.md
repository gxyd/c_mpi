## How to run 'mpi_program.f90'

```console
> mpicc -c mpi_wrapper.c -o mpi_wrapper.o
> mpif90 -c mpi_types.f90
> mpif90 -c mpi_c_bindings.f90
> mpif90 mpi_program.f90 mpi_types.o mpi_c_bindings.o mpi_wrapper.o -o mpi_program
> ./mpi_program
[Gauravs-MacBook-Air:00000] *** An error occurred in MPI_Comm_size
[Gauravs-MacBook-Air:00000] *** reported by process [632750080,0]
[Gauravs-MacBook-Air:00000] *** on communicator MPI_COMM_WORLD
[Gauravs-MacBook-Air:00000] *** MPI_ERR_COMM: invalid communicator
[Gauravs-MacBook-Air:00000] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[Gauravs-MacBook-Air:00000] ***    and MPI will try to terminate your MPI job as well)

```

