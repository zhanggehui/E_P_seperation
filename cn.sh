#!/bin/bash
#SBATCH -J gmx
#SBATCH -p cn_nl
#SBATCH -N 1
#SBATCH -o ./test/1.out
#SBATCH -e ./test/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufengcnnl
#SBATCH --ntasks-per-node=28
#SBATCH --exclusive

# environment variable:
# orientation ; rundir ; runscript ; scriptsdir
hosts=`scontrol show hostname $SLURM_JOB_NODELIST` ; echo $hosts

# export I_MPI_DEBUG=20
if [ $SLURM_JOB_PARTITION == cn_nl ]; then
    source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
else
    source /appsnew/source/intel2019.sh
    source /appsnew/mdapps/gromacs2020_cpu_intelmkl2019_cnscompat/bin/GMXRC.bash
fi

if [ $SLURM_JOB_NUM_NODES -eq 1 -a $Usempirun -eq 0 ]; then
    gmxrun="gmx mdrun -ntmpi $SLURM_NTASKS"
else
    #mpistring="mpirun -n $SLURM_NTASKS -quiet --mca pml ob1 --mca btl_openib_allow_ib true"
    mpistring="mpirun -n $SLURM_NTASKS"
    gmxrun="$mpistring mdrun_mpi"
    #gmxrun="$mpistring mdrun_mpi2"
fi
source ./$rundir/$runscript
