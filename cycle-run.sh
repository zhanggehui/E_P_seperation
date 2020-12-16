#!/bin/bash

# environment variable: 
# orientation ; rundir ; runscript ; scriptsdir
# run in root dir

numofcycle=10     
nsteps=1000    #fs >1000 at least
pressure=0        #Mpa
nvtequdir=nvtequ
############################################################
echo "pressure: $pressure" > ./$rundir/waternumber
echo '' >> ./$rundir/waternumber
echo 'stepnum   count   acceleration' >> ./$rundir/waternumber

#run cycle
cp waterlayer.ndx $rundir
mdpdir=./$rundir/${rundir}mdps ; mkdir -p $mdpdir
ndxdir=./$rundir/${rundir}ndxs ; mkdir -p $ndxdir

#有cpt(检查点文件)的情况下不需要使用gro,但仍必须提供
if [ -a ./$nvtequdir/nvt-equ.cpt ] ; then
    mv ./$nvtequdir/nvt-equ.cpt ./$nvtequdir/nvt-step-0.cpt
fi
mdpfile=./$rundir/nvt-cycle.mdp
topfile=GO2.top
ndxfile=./$rundir/waterlayer.ndx
grofile=./$nvtequdir/nvt-equ.gro
tprname=nvt-cycle.tpr

#修改每个循环步数
reset_nsteps="nsteps                   = $nsteps"
sed -i "/nsteps/c${reset_nsteps}" $mdpfile

for((i=1;i<=$numofcycle;i++)); do
    #用于记录目前的步数
    echo $i >> ./$rundir/recordcycle ; export i
    if [ $i -eq 1 ] ; then
         lastcpt=./$nvtequdir/nvt-step-0.cpt
    else
         lastcpt=./$rundir/nvt-cycle.cpt
    fi
    #tinit=$(( (i-1)*(tstep/1000) )) ; resettinit="tinit                    = $tinit"
    #sed -i "/tinit/c$resettinit" $mdpfile
    #source ./$scriptsdir/findwatersinlayer.sh

    gmx grompp -f $mdpfile -t $lastcpt -c $grofile -p $topfile \
    -o ./$rundir/nvt-cycle.tpr -po $mdpdir/step$i -n $ndxfile -maxwarn 1
    
    cd $rundir
    $gmxrun -v -deffnm 'nvt-cycle' -s nvt-cycle -cpi $lastcpt -append
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
