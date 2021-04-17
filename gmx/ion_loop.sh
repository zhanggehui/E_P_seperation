ions=("LI" "NA" "K" "CS")
n_ions=${#ions[@]}

for ((i=0;i<1;i++)); do
    ion=${ions[$i]}
    cd $ion
    if [ $1 == 'em' ]; then
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
        gmx auto 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx em.sh em
    elif [ $1 == 'nvtequ' ]; then
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
        gmx auto 2 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx nvt-equ.sh nvtequ
    elif [ $1 == 'analysis' ]; then
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
        gmx auto 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis pv_loop.sh $ion
    fi
    cd ../
done
