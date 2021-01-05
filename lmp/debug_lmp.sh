#!/bin/bash
#SBATCH -J lmp
#SBATCH -p debug
#SBATCH -N 1
#SBATCH -o ./1.out
#SBATCH -e ./2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --ntasks-per-node=24
#SBATCH --exclusive

# environment variable:
# rundir ; runscript

hosts=`scontrol show hostname $SLURM_JOB_NODELIST`; echo $hosts
source /home/liufeng_pkuhpc/lustre2/zgh/zgh_lmp/lmp_use/lammps_29Oct2020.sh auto
cd ./$rundir
mpirun -np $SLURM_NTASKS lmp -e screen -log none -in $runscript
