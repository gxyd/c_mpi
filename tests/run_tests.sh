#!/bin/bash
set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

MPIEXEC=${CONDA_PREFIX}/bin/mpiexec

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
    if ${MPIEXEC} -np $np ./$filename; then
      echo -e "${GREEN}Test $filename with $np MPI ranks PASSED!${NC}"
    else
      echo -e "${RED}Test $filename with $np MPI ranks FAILED!${NC}"
      exit 1
    fi
  done

done

git clean -dfx
