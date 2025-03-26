#!/bin/bash
set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

MPIEXEC=${CONDA_PREFIX}/bin/mpiexec

# Detect MPI implementation
# NOTE: I've noticed that using '--oversubscribe' with Open MPI takes a
# lot of time to run on local machine, than without it
MPI_VERSION=$($MPIEXEC --version 2>&1)
if echo "$MPI_VERSION" | grep -q "Open MPI"; then
  MPI_TYPE="openmpi"
  MPIEXEC_ARGS="--oversubscribe"
elif echo "$MPI_VERSION" | grep -q "MPICH"; then
  MPI_TYPE="mpich"
  MPIEXEC_ARGS=""  # MPICH usually allows oversubscription by default
else
  echo -e "${RED}Unknown MPI implementation!${NC}"
  exit 1
fi

if [[ "$(uname)" == "Linux" ]]; then
  CC=gcc
else
  CC=clang
fi

# Compile C and Fortran sources
$CC -I$CONDA_PREFIX/include -c ../src/mpi_wrapper.c
$FC -c ../src/mpi_c_bindings.f90
$FC -c ../src/mpi.f90

for file in *.f90; do
  filename=$(basename "$file" .f90)
  echo -e "${YELLOW}Compiling $filename...${NC}"
  $FC -c $file
  $FC mpi_wrapper.o mpi_c_bindings.o mpi.o $filename.o -o $filename -L$CONDA_PREFIX/lib -lmpi -Wl,-rpath,$CONDA_PREFIX/lib

  for np in 1 2 4; do
    echo -e "${YELLOW}Running $filename with $np MPI ranks...${NC}"
    if ${MPIEXEC} -np $np $MPIEXEC_ARGS ./$filename; then
      echo -e "${GREEN}Test $filename with $np MPI ranks PASSED!${NC}"
    else
      echo -e "${RED}Test $filename with $np MPI ranks FAILED!${NC}"
      exit 1
    fi
  done

done

git clean -dfx
