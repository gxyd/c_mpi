#!/bin/bash

set -e

# Define ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'  # Reset color

if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 <Fortran file> <mpiexec arguments>${RESET}"
    exit 1
fi

TEST_FILE=$1
shift  # Remove the first argument (Fortran file)
MPI_ARGS="$@"  # Store the remaining arguments for mpiexec

TEST_OBJ="${TEST_FILE%.f90}.o"
EXECUTABLE="${TEST_FILE%.f90}"

CC=${CC:-gcc}
FC=${FC:-gfortran}

echo -e "${BOLD}${CYAN}Configuration results${RESET}"
echo -e "${CYAN}---------------------${RESET}"
echo -e "${YELLOW}Using C compiler: ${RESET}${GREEN}$CC${RESET}"
echo -e "${YELLOW}Using Fortran compiler: ${RESET}${GREEN}$FC${RESET}"
echo ""

echo -e "${BLUE}Compiling src/mpi_constants.c with $CC...${RESET}"
$CC -I$CONDA_PREFIX/include -c src/mpi_constants.c

echo -e "${BLUE}Compiling src/mpi_c_bindings.f90 with $FC...${RESET}"
$FC -c src/mpi_c_bindings.f90

echo -e "${BLUE}Compiling src/mpi.f90 with $FC...${RESET}"
$FC -c src/mpi.f90

echo -e "${BLUE}Compiling $TEST_FILE with $FC...${RESET}"
$FC -c "$TEST_FILE"

echo -e "${CYAN}Linking objects to create executable: ${BOLD}${EXECUTABLE}${RESET}"
$FC mpi_constants.o mpi_c_bindings.o mpi.o "$TEST_OBJ" -o "$EXECUTABLE" -L$CONDA_PREFIX/lib -lmpi -Wl,-rpath,$CONDA_PREFIX/lib

echo -e "${BOLD}${GREEN}Running:${RESET} ${YELLOW}mpiexec $MPI_ARGS ./$EXECUTABLE${RESET}"
mpiexec $MPI_ARGS ./"$EXECUTABLE"
