if [ $SLURM_JOB_PARTITION == 'cn_nl' ]; then
    OMP_NUM_THREADS=28
else
    OMP_NUM_THREADS=20
fi

gmx wham -it ../tpr-files2.dat -if ../pullf-files2.dat -o -hist -unit kCal
