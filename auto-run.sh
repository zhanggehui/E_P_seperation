#!/bin/bash

NodeNum=1             # 由于后面有文件修改，故节点数只能用1
export Usempirun=1    # mdrun_mpi or mdrun
export runscript=$1
export rundir=$2
export orientation=y
export scriptsdir='scripts'

ncnnl=`sinfo | grep 'idle' | grep 'cn_nl' | awk '{print $4}'`
ncns=`sinfo | grep 'idle' | grep 'cn-short' | awk '{print $4}'`

if [ -z "$ncnnl" ] && [ -z "$ncns" ]; then #-n是否为非空串,-z是否为空串,判断必须加引号
    NodeType=cn_nl
elif [ -z "$ncnnl" ] && [ -n "$ncns" ]; then
    NodeType=cn-short
elif [ -n "$ncnnl" ] && [ -z "$ncns" ]; then
    NodeType=cn-short
else
    if [ $ncnnl -ge 10 ]; then
        NodeType=cn_nl
    elif [ $ncns -gt $ncnnl ]; then
        NodeType=cn-short
    else
        NodeType=cn_nl
    fi
fi

if [ $NodeType == 'cn_nl' ]; then
    NtasksPerNode=28
else
    NtasksPerNode=20
fi

#rm -rf $rundir
if [ ! -d $rundir ]; then
    mkdir $rundir
    ##choose proper node setting ########################################
    submissionscript='cn.sh'
    keyword="#SBATCH -p"; newline="#SBATCH -p $NodeType"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    keyword="#SBATCH -N"; newline="#SBATCH -N $NodeNum"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    keyword="#SBATCH --ntasks-per-node"; newline="#SBATCH --ntasks-per-node=$NtasksPerNode"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    if [ "$NodeType" == cn-short ]; then
        keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcns"
        sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    elif [ "$NodeType" == cn_nl ]; then
        keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcnnl"
        sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    elif [ "$NodeType" == cn-long ]; then
        keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcnl"
        sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    fi
    #####################################################################
    jobname="gmx_$2" ; keyword="#SBATCH -J" ; newline="#SBATCH -J $jobname"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript

    oname="./$rundir/1.out" ; keyword="#SBATCH -o" ; newline="#SBATCH -o $oname"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript

    ename="./$rundir/2.err" ; keyword="#SBATCH -e" ; newline="#SBATCH -e $ename"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript

    cp ./$scriptsdir/$submissionscript ./$rundir
    cp ./$scriptsdir/$runscript ./$rundir
    if [ $runscript == 'nvt-cycle.sh' ]; then
        cp ./$scriptsdir/nvt-cycle.mdp ./$rundir
    fi

    sbatch ./$scriptsdir/$submissionscript
    echo "Submiting a job to ${NodeType}, Please wait..."
    sleep 2s
else
    echo 'Already exists! Please make sure!'
fi
