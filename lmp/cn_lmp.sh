#!/bin/bash
#SBATCH -J lmp
#SBATCH -p cn_nl
#SBATCH -N 1
#SBATCH -o ./test/1.out
#SBATCH -e ./test/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufengcnnl
#SBATCH --ntasks-per-node=28
#SBATCH --exclusive

hosts=`scontrol show hostname $SLURM_JOB_NODELIST`; echo $hosts
export OMP_NUM_THREADS=1
source /home/liufeng_pkuhpc/lustre2/zgh/zgh_lmp/lmp_use/lammps_29Oct2020.sh auto
cd ./$rundir
mpirun -np $SLURM_NTASKS lmp -e screen -log none -in ${runscript##*/}
