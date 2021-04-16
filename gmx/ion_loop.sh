ions=("LI" "NA" "K" "CS")
n_ions=${#ions[@]}

for ((i=1;i<2;i++)); do
    ion=${ions[$i]}
    cd $ion
    if [ $1 == 'rdf_pv' ]; then
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
        gmx auto 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis pv_loop.sh $ion
    elif [ $1 == 'res_t' ];then
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
        gmx auto 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis pv_loop.sh $ion
    elif [ $1 == 'density' ];then
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
        gmx auto 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis pv_loop.sh $ion
    fi
    cd ../
done
