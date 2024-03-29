# ions=("LI" "NA" "K" "CS" "CA" "MG")
ions=("LI" "NA" "K" "CS")
# ions=("LI")
# ions=("LI" "CS")
# ions=("30e_fix" "30e_flexible" "40e_fix" "40e_flexible")
n_ions=${#ions[@]}

run_gmx="source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh gmx $2 $3"
gitdir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts

for ((i=0; i<${n_ions}; i++)); do
    ion=${ions[$i]}
    if [ -d ./$ion ]; then
        cd ./$ion
        ion=${ion%%_*}
        if [ $1 == 'em' ]; then
            $run_gmx $gitdir/gmx em.sh em
        elif [ $1 == 'nvtequ' ]; then
            $run_gmx $gitdir/gmx nvt-equ.sh nvtequ
        elif [ $1 == 'nvtpull' ]; then
            $run_gmx $gitdir/gmx nvt-pull.sh nvtpull
        elif [ $1 == 'analysis' ]; then
            $run_gmx $gitdir/gmx/analysis pv_loop.sh ${ions[$i]}_ay
            # ${ion}_angle ${ion}_traj ${ion}_density ${ion}_rdf ${ion}_rest ${ion}_vel
        fi
        cd ../
    else
        echo "No such directory ($ion)!"
    fi
done
