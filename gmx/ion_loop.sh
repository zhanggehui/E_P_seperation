ions=("LI")
#ions=("LI" "NA" "K" "CS")
n_ions=${#ions[@]}

run_gmx="source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh gmx $2"

for ((i=0; i<${n_ions}; i++)); do
    ion=${ions[$i]}
    if [ -d ./$ion ]; then
        cd ./$ion
        if [ $1 == 'em' ]; then
            $run_gmx 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx em.sh em
        elif [ $1 == 'nvtequ' ]; then
            $run_gmx 4 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx nvt-equ.sh nvtequ
        elif [ $1 == 'analysis' ]; then
            $run_gmx 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis pv_loop.sh $ion
        fi
        cd ../
    else
        "No such dictionary!"
    fi
done
