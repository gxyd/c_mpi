set -ex

if [[ "$(uname)" == "Linux" ]]; then
  CC=${CONDA_PREFIX}/bin/gcc
else
  CC=${CONDA_PREFIX}/bin/clang
fi

FC=${CONDA_PREFIX}/bin/gfortran
FFLAGS="-O3 -march=native"

cd src
${CC} -I$CONDA_PREFIX/include -c ../../../src/mpi_wrapper.c
${FC} $FFLAGS -c ../../../src/mpi_c_bindings.f90
${FC} $FFLAGS -c ../../../src/mpi.f90
${FC} $FFLAGS -c psi_io.f90
${FC} $FFLAGS -c  -cpp pot3d.F90
${FC} $FFLAGS -lmpi mpi_wrapper.o mpi_c_bindings.o mpi.o psi_io.o pot3d.o -o pot3d
cp pot3d ../bin/
