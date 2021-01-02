#!/bin/bash
#SBATCH -J lmp_
#SBATCH -p cn-short
#SBATCH -N 2
#SBATCH --qos=liufengcns
#SBATCH --ntasks-per-node=20
#SBATCH -o 1.out
#SBATCH -e 2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --exclusive

hosts=`scontrol show hostname $SLURM_JOB_NODELIST`; echo $hosts

source /home/liufeng_pkuhpc/lustre2/zgh/zgh_lmp/lmp_use/lammps_29Oct2020.sh auto
#source /home/liufeng_pkuhpc/lustre2/zgh/zgh_lmp/lmp_use/lmp_modify.sh   #cns version

mpirun -np $SLURM_NTASKS lmp -e screen -log none -in ../$1