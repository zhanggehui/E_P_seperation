#!/bin/bash

# environment variable: orientation ; rundir ; runscript ; scriptsdir
# run in root dir
ttotal=5000000       #fs bash只能做整数运算
tstep=5000000        #fs >1000 at least
pressure=0        #Mpa
export pressure
nvtequdir=nvtequ
############################################################
#first initialization
#source command executed in current shell so pay attentation to environment variable
echo "pressure: $pressure" > ./$rundir/waternumber ; echo '' >> ./$rundir/waternumber
echo 'stepnum   count   acceleration' >> ./$rundir/waternumber
numofcycle=$(($ttotal/$tstep))

#run cycle
#chmod +x ./$scriptsdir/findwatersinlayer.sh
cp waterlayer.ndx $rundir
mdpdir=./$rundir/${rundir}mdps ; mkdir $mdpdir
ndxdir=./$rundir/${rundir}ndxs ; mkdir $ndxdir

if [ -f ./$nvtequdir/nvt-equ.gro ] ; then
    mv ./$nvtequdir/nvt-equ.gro ./$nvtequdir/nvt-step-0.gro
fi
if [ -f ./$nvtequdir/nvt-equ.cpt ] ; then
    mv ./$nvtequdir/nvt-equ.cpt ./$nvtequdir/nvt-step-0.cpt
fi
mdpfile=./$rundir/nvt-cycle.mdp ; topfile=GO2.top ; ndxfile=./$rundir/waterlayer.ndx
#posregro=./$nvtequdir/nvt-step-0.gro

for((i=1;i<=$numofcycle;i++)) ; do
    echo $i >> ./$rundir/recordcycle ; export i
    tprname=nvt-step-$i.tpr
    if [ $i -eq 1 ] ; then
        lastgro=./$nvtequdir/nvt-step-$((i-1)).gro ; lastcpt=./$nvtequdir/nvt-step-$((i-1)).cpt
    else
        lastgro=./$rundir/nvt-step-$((i-1)).gro ; lastcpt=./$rundir/nvt-step-$((i-1)).cpt
    fi
    tinit=$(( (i-1)*(tstep/1000) )) ; resettinit="tinit                    = $tinit"
    sed -i "/tinit/c$resettinit" $mdpfile

    source ./$scriptsdir/findwatersinlayer.sh

    gmx grompp -f $mdpfile -c $lastgro -t $lastcpt -p $topfile -o ./$rundir/$tprname \
    -po $mdpdir/step$i -n $ndxfile
    # -r $posregro   -maxwarn 1
    cd $rundir ; $gmxrun -v -deffnm ${tprname%.*} ; cd ..
done

#####after run#########################################
rm -rf ./$rundir/tmp
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
