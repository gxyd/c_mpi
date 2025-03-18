set -ex

MPIEXEC=${CONDA_PREFIX}/bin/mpiexec

if [[ "$(uname)" == "Linux" ]]; then
  CC=gcc
else
  CC=clang
fi

$CC -I$CONDA_PREFIX/include -c ../src/mpi_wrapper.c
$FC -c ../src/mpi_c_bindings.f90
$FC -c ../src/mpi.f90
$FC -c -cpp cart_sub.f90
$FC mpi_wrapper.o mpi_c_bindings.o mpi.o cart_sub.o -o cart_sub -L$CONDA_PREFIX/lib -lmpi -Wl,-rpath,$CONDA_PREFIX/lib

echo "Running cart_sub with 1 MPI rank..."
${MPIEXEC} -np 1 cart_sub
echo "Done!"

echo "Running cart_sub with 2 MPI rank..."
${MPIEXEC} -np 2 cart_sub
echo "Done!"
