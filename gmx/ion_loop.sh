# ions=("NA")
# ions=("LI" "NA" "K" "CS")
# ions=("LI" "NA" "K" "CS" "CA" "MG")
ions=("NA")
n_ions=${#ions[@]}

run_gmx="source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh gmx $2"
gitdir=/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts

for ((i=0; i<${n_ions}; i++)); do
    ion=${ions[$i]}
    if [ -d ./$ion ]; then
        cd ./$ion
        if [ $1 == 'em' ]; then
            $run_gmx 1 $gitdir/gmx em.sh em
        elif [ $1 == 'nvtequ' ]; then
            $run_gmx 2 $gitdir/gmx nvt-equ.sh nvtequ
        elif [ $1 == 'nvtpull' ]; then
            $run_gmx 2 $gitdir/gmx nvt-pull.sh nvtpull
        elif [ $1 == 'nvtspring' ]; then
            $run_gmx 2 $gitdir/gmx nvt-cycle.sh spring-1500Mpa-0V
        elif [ $1 == 'analysis' ]; then
            $run_gmx 1 $gitdir/gmx/analysis pv_loop.sh  ${ion}_traj
            # ${ion}_angle ${ion}_traj ${ion}_density ${ion}_rdf ${ion}_rest ${ion}_vel
        fi
        cd ../
    else
        echo "No such dictionary ($ion)!"
    fi
done
