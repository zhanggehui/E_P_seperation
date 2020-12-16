#!/bin/bash

# environment variable: orientation ; rundir ; runscript ; scriptsdir
# run in root dir
numofcycle=10     
nsteps=1000    #fs >1000 at least
pressure=0        #Mpa
export pressure
nvtequdir=nvtequ
############################################################
echo "pressure: $pressure" > ./$rundir/waternumber
echo '' >> ./$rundir/waternumber
echo 'stepnum   count   acceleration' >> ./$rundir/waternumber

#run cycle
cp waterlayer.ndx $rundir
mdpdir=./$rundir/${rundir}mdps ; mkdir $mdpdir
ndxdir=./$rundir/${rundir}ndxs ; mkdir $ndxdir

#有cpt(检查点文件)的情况下不需要使用gro
if [ -f ./$nvtequdir/nvt-equ.cpt ] ; then
    mv ./$nvtequdir/nvt-equ.cpt ./$nvtequdir/nvt-step-0.cpt
fi
mdpfile=./$rundir/nvt-cycle.mdp ; topfile=GO2.top ; ndxfile=./$rundir/waterlayer.ndx
lastcpt=./$nvtequdir/nvt-step-0.cpt

#修改每个循环步数
reset_nsteps="nsteps                   = $nsteps"
sed -i "/nsteps/c${reset_nsteps}" $mdpfile

for((i=1;i<=$numofcycle;i++)); do
    #用于记录目前的步数
    echo $i >> ./$rundir/recordcycle ; export i
    tprname=nvt-step-$i.tpr
    #if [ $i -eq 1 ] ; then
    #    lastcpt=./$nvtequdir/nvt-step-$((i-1)).cpt
    #else
    #    lastcpt=./$rundir/nvt-step-$((i-1)).cpt
    #fi
    #tinit=$(( (i-1)*(tstep/1000) )) ; resettinit="tinit                    = $tinit"
    #sed -i "/tinit/c$resettinit" $mdpfile

    #source ./$scriptsdir/findwatersinlayer.sh

    gmx grompp -f $mdpfile -t $lastcpt -p $topfile -o ./$rundir/$tprname \
    -po $mdpdir/step$i -n $ndxfile -maxwarn 1
    cd $rundir
    $gmxrun -v -deffnm ${tprname%.*} -cpi $lastcpt
    cd ..
done

#####after run#########################################
# rm -rf ./$rundir/tmp
# mv ./$rundir/nvt-step-$numofcycle.gro ./$rundir/last.gro
# mv ./$rundir/nvt-step-1.tpr ./$rundir/traj.tpr
# if [ $numofcycle -gt 1 ] ; then
#     cd $rundir ; gmx trjcat -f *.trr -o nvt-pro-traj.trr ; cd ..
#     rm -rf ./$rundir/*.edr
#     rm -rf ./$rundir/*.log
#     rm -rf ./$rundir/*.cpt
#     rm -rf ./$rundir/nvt-step-*.trr
#     rm -rf ./$rundir/nvt-step-*.gro
#     rm -rf ./$rundir/nvt-step-*.tpr
# else
#     mv ./$rundir/nvt-step-1.trr ./$rundir/nvt-pro-traj.trr
# fi
