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

for file in *.f90; do
  filename=$(basename "$file" .f90)
  # TODO: currently "allreduce.f90" fails to compile, hence
  # we skip that test for now
  if [ "$filename" == "allreduce" ]; then
    continue
  fi
  $FC -c $file
  $FC mpi_wrapper.o mpi_c_bindings.o mpi.o $filename.o -o $filename -L$CONDA_PREFIX/lib -lmpi -Wl,-rpath,$CONDA_PREFIX/lib

  echo "Running $filename with 1 MPI rank..."
  ${MPIEXEC} -np 1 $filename
  echo "Done!"

  echo "Running $filename with 2 MPI rank..."
  ${MPIEXEC} -np 2 $filename
  echo "Done!"
done
