## How to run 'cart_sub.f90'

```clojure
⚡aditya-trivedi ❯❯ cd src
⚡aditya-trivedi ❯❯ mpicc -c mpi_wrapper.c -o mpi_wrapper.o
 ⚡aditya-trivedi ❯❯ mpif90 -c mpi_c_bindings.f90 mpi.f90                                                                                               
 ⚡aditya-trivedi ❯❯ cd ../tests/                                                                                                                       
 ⚡aditya-trivedi ❯❯ mpif90 cart_sub.f90 ../src/mpi_c_bindings.o ../src/mpi_wrapper.c ../src/mpi.o -o a && ./a                                          
 Global Rank:           0 Cartesian Coordinates:           0           0
 New communicator rank:           0 New communicator size:           1

OR via MPIRUN

 ⚡aditya-trivedi ❯❯ mpif90 cart_sub.f90 ../src/mpi_c_bindings.o ../src/mpi_wrapper.c ../src/mpi.o -o a && mpirun -np 4 ./a                             
 Global Rank:           3 Cartesian Coordinates:           1           1
 Global Rank:           0 Cartesian Coordinates:           0           0
 Global Rank:           1 Cartesian Coordinates:           0           1
 Global Rank:           2 Cartesian Coordinates:           1           0
 New communicator rank:           3 New communicator size:           2
 New communicator rank:           0 New communicator size:           2
 New communicator rank:           1 New communicator size:           2
 New communicator rank:           2 New communicator size:           2
```

