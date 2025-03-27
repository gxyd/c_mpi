#!/bin/bash
set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

MPIEXEC=${CONDA_PREFIX}/bin/mpiexec

# detect MPI implementation
MPI_VERSION=$($MPIEXEC --version 2>&1)
if echo "$MPI_VERSION" | grep -q "Open MPI"; then
  MPI_TYPE="openmpi"
elif echo "$MPI_VERSION" | grep -q "MPICH"; then
  MPI_TYPE="mpich"
else
  # we don't yet support other MPI implementations
  # like intel MPI etc.0
  echo -e "${RED}Unknown MPI implementation!${NC}"
  exit 1
fi

if [[ "$(uname)" == "Linux" ]]; then
  CC=gcc
else
  CC=clang
fi

# compile C and Fortran sources
$CC -I$CONDA_PREFIX/include -c ../src/mpi_wrapper.c
$FC -c ../src/mpi_c_bindings.f90
$FC -c ../src/mpi.f90

start_time=$(date +%s)
for file in *.f90; do
  filename=$(basename "$file" .f90)
  echo -e "${YELLOW}Compiling $filename...${NC}"
  $FC -c $file
  $FC mpi_wrapper.o mpi_c_bindings.o mpi.o $filename.o -o $filename -L$CONDA_PREFIX/lib -lmpi -Wl,-rpath,$CONDA_PREFIX/lib

  for np in 1 2 4; do
    # set MPIEXEC_ARGS based on MPI type and number of ranks
    # `--oversubscribe` isn't needed with Open MPI when running
    # with 1 or 2 ranks
    if [[ "$MPI_TYPE" == "openmpi" && $np -gt 2 ]]; then
      MPIEXEC_ARGS="--oversubscribe"
    else
      MPIEXEC_ARGS=""
    fi

    echo -e "${YELLOW}Running $filename with $np MPI ranks...${NC}"
    if ${MPIEXEC} -np $np $MPIEXEC_ARGS ./$filename; then
      echo -e "${GREEN}Test $filename with $np MPI ranks PASSED!${NC}"
    else
      echo -e "${RED}Test $filename with $np MPI ranks FAILED!${NC}"
      exit 1
    fi
  done

done

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo ""
echo -e "${YELLOW}... Running standalone tests took ${elapsed_time} seconds ...${NC}"
echo ""
