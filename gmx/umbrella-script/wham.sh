if [ $SLURM_JOB_PARTITION == 'cn_nl' ]; then
    OMP_NUM_THREADS=28
else
    OMP_NUM_THREADS=20
fi

$gmx wham -it ../tpr-files.dat -if ../pullf-files.dat -o -hist -unit kCal  # -is ../coordsel.dat
# 该文件（coordsel.dat），行数对应分析的位置数，列数与反应坐标数目对应，1代表参与分析
