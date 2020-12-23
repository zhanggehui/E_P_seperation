#!/bin/bash
#SBATCH -J gmx_analyse
#SBATCH -p cn_nl
#SBATCH -N 1
#SBATCH -o ./1.out
#SBATCH -e ./2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufengcnnl

hosts=`scontrol show hostname $SLURM_JOB_NODELIST` ; echo $hosts

analyse_scripts=do_density.sh

source ./md_scripts/${analyse_scripts}
