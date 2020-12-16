#!/bin/bash

# environment variable: 
# orientation ; rundir ; runscript ; scriptsdir
# run in root dir

numofcycle=1     
nsteps=10000000
pressure=0         #Mpa
nvtequdir=nvtequ
dt=0.001           #ps
############################################################
echo "pressure: $pressure" > ./$rundir/waternumber
echo '' >> ./$rundir/waternumber
echo 'stepnum   count   acceleration' >> ./$rundir/waternumber

cp waterlayer.ndx $rundir
mdpdir=./$rundir/mdps ; mkdir -p $mdpdir
ndxdir=./$rundir/ndxs ; mkdir -p $ndxdir

mdpfile=./$rundir/nvt-cycle.mdp
ndxfile=./$rundir/waterlayer.ndx 
topfile=GO2.top

#修改每个循环步数,步长
reset_nsteps="nsteps                   = $nsteps"
sed -i "/nsteps/c${reset_nsteps}" $mdpfile
reset_dt="dt                       = $dt"
dtline='dt                       ='
sed -i "/$dtline/c${reset_dt}" $mdpfile
reset_nstxout="nstxout                  =$nsteps"
nstxoutline='nstxout                  ='
sed -i "/$nstxoutline/c${reset_nstxout}" $mdpfile

for ((i=1;i<=$numofcycle;i++)); do
    tprname=nvt-step-$i
    if [ $i -eq 1 ]; then
        lastgro=./$nvtequdir/nvt-equ.gro ; lastcpt=./$nvtequdir/nvt-equ.cpt
    else
        lastgro=./$rundir/nvt-step-$((i-1)).gro ; lastcpt=./$rundir/nvt-step-$((i-1)).cpt
    fi
    tinit=`awk -v i=$i -v dt=$dt -v nsteps=$nsteps 'BEGIN{printf(%g,(i-1)*dt*nsteps);}'`
    reset_tinit="tinit                    = $tinit"
    sed -i "/tinit/c${reset_tinit}" $mdpfile

    #重新给水加速度,更新mdp文件,更新ndx文件
    source ./$scriptsdir/findwatersinlayer.sh

    gmx grompp -f $mdpfile -c $lastgro -t $lastcpt -p $topfile -o ./$rundir/$tprname.tpr \
    -po $mdpdir/step$i -n $ndxfile -maxwarn 1  
    cd $rundir ; $gmxrun -v -deffnm tprname ; cd ..
done

# 进行多余文件的删除run
mv ./$rundir/nvt-step-$numofcycle.gro ./$rundir/last.gro
mv ./$rundir/nvt-step-1.tpr ./$rundir/traj.tpr
if [ $numofcycle -gt 1 ] ; then
    cd $rundir ; gmx trjcat -f *.trr -o nvt-pro-traj.trr ; cd ..
    rm -rf ./$rundir/*.edr
    rm -rf ./$rundir/*.log
    rm -rf ./$rundir/*.cpt
    rm -rf ./$rundir/nvt-step-*.trr
    rm -rf ./$rundir/nvt-step-*.gro
    rm -rf ./$rundir/nvt-step-*.tpr
else
    mv ./$rundir/nvt-step-1.trr ./$rundir/nvt-pro-traj.trr
fi