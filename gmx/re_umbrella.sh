for udir in `du -sh * | grep umbrella | grep 6.5M | awk '{printf("%s ", $2)}'`; do 
    if [ -d $udir ]; then 
        cd $udir
        if [ -e mdout.mdp ]; then
            rm -rf mdout.mdp run umbrella*.tpr
        fi
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh gmx cn_nl 4 . sampling.sh run
        cd ../
    fi
done
