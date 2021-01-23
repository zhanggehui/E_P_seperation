md_code=$1
export runscript=$3
export rundir=$4
if [ ${md_code} == 'lmp' ]; then
    NodeNum=2
    scriptsdir='/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/lmp'
else
    NodeNum=1             # 由于后面有文件修改，故节点数只能用1
    export Usempirun=1    # mdrun_mpi or mdrun
    export orientation=y
    export scriptsdir='/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx'
fi

if [ $2 == 'auto' ]; then
    ncnnl=`sinfo | grep 'idle' | grep 'cn_nl' | awk '{print $4}'`
    ncns=`sinfo | grep 'idle' | grep 'cn-short' | awk '{print $4}'`
    if [ -z "$ncnnl" ] && [ -z "$ncns" ]; then #-n是否为非空串,-z是否为空串,判断必须加引号
        NodeType=cn_nl
    elif [ -z "$ncnnl" ] && [ -n "$ncns" ]; then
        NodeType=cn-short
    elif [ -n "$ncnnl" ] && [ -z "$ncns" ]; then
        NodeType=cn_nl
    else
        if [ $ncnnl -ge 10 ]; then
            NodeType=cn_nl
        elif [ $ncns -gt $ncnnl ]; then
            NodeType=cn-short
        else
            NodeType=cn_nl
        fi
    fi
elif [ $2 == 'cn-short' ]; then
    NodeType=cn-short
elif [ $2 == 'cn_nl' ]; then
    NodeType=cn_nl
elif [ $2 == 'debug' ]; then
    NodeType='debug'
else
    NodeType=Unknown
    echo "Unknown NodeType!"
fi



#rm -rf $rundir
if [ ! -d $rundir ]; then
    mkdir $rundir
    ##choose proper node setting ########################################
    if [ $NodeType == 'Unknown' ]; then
        echo "Do nothing!"
    else
        if [ $NodeType == 'debug' ]; then
            submissionscript="$scriptsdir/debug_${md_code}.sh"
        else 
            if [ $NodeType == 'cn_nl' ]; then
                NtasksPerNode=28
            elif [ $NodeType == 'cn-short' ]; then
                NtasksPerNode=20
            fi
            submissionscript="$scriptsdir/cn_${md_code}.sh"
            keyword="#SBATCH -p"; newline="#SBATCH -p $NodeType"
            sed -i "/$keyword/c$newline" $submissionscript
            keyword="#SBATCH -N"; newline="#SBATCH -N $NodeNum"
            sed -i "/$keyword/c$newline" $submissionscript
            keyword="#SBATCH --ntasks-per-node"; newline="#SBATCH --ntasks-per-node=$NtasksPerNode"
            sed -i "/$keyword/c$newline" $submissionscript
            if [ "$NodeType" == cn-short ]; then
                keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcns"
                sed -i "/$keyword/c$newline" $submissionscript
            elif [ "$NodeType" == cn_nl ]; then
                keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcnnl"
                sed -i "/$keyword/c$newline" $submissionscript
            elif [ "$NodeType" == cn-long ]; then
                keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcnl"
                sed -i "/$keyword/c$newline" $submissionscript
            fi
        fi
        jobname="${md_code}_$4" ; keyword="#SBATCH -J" ; newline="#SBATCH -J $jobname"
        sed -i "/$keyword/c$newline" $submissionscript
        oname="./$rundir/1.out" ; keyword="#SBATCH -o" ; newline="#SBATCH -o $oname"
        sed -i "/$keyword/c$newline" $submissionscript
        ename="./$rundir/2.err" ; keyword="#SBATCH -e" ; newline="#SBATCH -e $ename"
        sed -i "/$keyword/c$newline" $submissionscript

        cp $submissionscript ./$rundir
        cp $scriptsdir/$runscript ./$rundir
        if [ $runscript == 'nvt-cycle.sh' ]; then
            cp $scriptsdir/nvt-cycle.mdp ./$rundir
        fi
        
        sbatch $submissionscript
        echo "Submiting a job to ${NodeType}, Please wait..."
        sleep 2s
    fi
else
    echo 'Already exists! Please make sure!'
fi
