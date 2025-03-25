## How to run 'tests/cart_sub.f90'

```console
> cd src
> echo ${CC}
/usr/bin/clang  # result on macOS
> ${CC} -c -I${CONDA_PREFIX}/include mpi_wrapper.c
> mpif90 -c mpi_c_bindings.f90 mpi.f90
> cd ../tests/
> mpif90 cart_sub.f90 ../src/mpi_c_bindings.o ../src/mpi_wrapper.o ../src/mpi.o -o cart_sub && ./cart_sub
 Global Rank:           0 Cartesian Coordinates:           0           0
 New communicator rank:           0 New communicator size:           1
```

OR via MPIRUN

```console
> mpif90 cart_sub.f90 ../src/mpi_c_bindings.o ../src/mpi_wrapper.c ../src/mpi.o -o a && mpirun -np 4 ./a
 Global Rank:           3 Cartesian Coordinates:           1           1
 Global Rank:           0 Cartesian Coordinates:           0           0
 Global Rank:           1 Cartesian Coordinates:           0           1
 Global Rank:           2 Cartesian Coordinates:           1           0
 New communicator rank:           3 New communicator size:           2
 New communicator rank:           0 New communicator size:           2
 New communicator rank:           1 New communicator size:           2
 New communicator rank:           2 New communicator size:           2
```

## How to run a new MPI program with custom MPI wrappers

```console
> pwd
/Users/gxyd/OpenSource/c_mpi
> ls test.f90
test.f90
> ./run_with_mpi_wrappers.sh test.f90 -np 2
Configuration results
---------------------
Using C compiler: /usr/bin/clang
Using Fortran compiler: /Users/gxyd/miniforge3/envs/pot3d_build/bin/arm64-apple-darwin20.0.0-gfortran

Compiling src/mpi_wrapper.c with /usr/bin/clang...
Compiling src/mpi_c_bindings.f90 with /Users/gxyd/miniforge3/envs/pot3d_build/bin/arm64-apple-darwin20.0.0-gfortran...
Compiling src/mpi.f90 with /Users/gxyd/miniforge3/envs/pot3d_build/bin/arm64-apple-darwin20.0.0-gfortran...
Compiling test.f90 with /Users/gxyd/miniforge3/envs/pot3d_build/bin/arm64-apple-darwin20.0.0-gfortran...
Linking objects to create executable: test
Running: mpiexec -np 2 ./test
 Hello from rank            0  of            2
 Hello from rank            1  of            2
```
