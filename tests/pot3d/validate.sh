set -ex

POT3D_HOME=$PWD
TEST="validation"
MPIEXEC=${CONDA_PREFIX}/bin/mpiexec

cp ${POT3D_HOME}/testsuite/${TEST}/input/* ${POT3D_HOME}/testsuite/${TEST}/run/
cd ${POT3D_HOME}/testsuite/${TEST}/run

for np in 1 2 4; do
  rm -rf pot3d.log pot3d.out timing.out
  echo "Running POT3D with $np MPI rank..."
  ${MPIEXEC} -np ${np} ${POT3D_HOME}/bin/pot3d 1> pot3d.log 2>pot3d.err
  echo "Done!"

  runtime=($(tail -n 5 timing.out | head -n 1))
  echo "Wall clock time:                ${runtime[6]} seconds"
  echo " "

  #Validate run:
  ${POT3D_HOME}/scripts/pot3d_validation.sh pot3d.out ${POT3D_HOME}/testsuite/${TEST}/validation/pot3d.out
  if [ $? -ne 0 ]; then
    echo "Validation failed for $np MPI rank. Exiting..."
    exit 1
  fi
  echo ""
done

echo "Done!"
