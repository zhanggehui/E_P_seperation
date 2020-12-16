#!/bin/bash

# environment variable: 
# orientation ; rundir ; runscript ; scriptsdir
# run in root dir

numofcycle=10     
nsteps=1000       #fs >1000 at least
pressure=0        #Mpa
nvtequdir=nvtequ

############################################################
echo "pressure: $pressure" > ./$rundir/waternumber
echo '' >> ./$rundir/waternumber
echo 'stepnum   count   acceleration' >> ./$rundir/waternumber

cp waterlayer.ndx $rundir
mdpdir=./$rundir/mdps ; mkdir -p $mdpdir
ndxdir=./$rundir/ndxs ; mkdir -p $ndxdir

mdpfile=./$rundir/nvt-cycle.mdp
ndxfile=./$rundir/waterlayer.ndx
grofile=./$nvtequdir/nvt-equ.gro
tprname='nvt-cycle'
topfile=GO2.top

#修改每个循环步数
reset_nsteps="nsteps                   = $nsteps"
sed -i "/nsteps/c${reset_nsteps}" $mdpfile

for ((i=1;i<=$numofcycle;i++)); do
    if [ $i -eq 1 ] ; then
         lastcpt=./$nvtequdir/nvt-equ.cpt
    else
         lastcpt=./$rundir/nvt-cycle.cpt
    fi

    #有cpt(检查点文件)的情况下不需要使用gro,但仍必须提供
    gmx grompp -f $mdpfile -t $lastcpt -c $grofile -p $topfile \
    -o ./$rundir/nvt-cycle.tpr -po $mdpdir/step$i -n $ndxfile -maxwarn 1 -cpt -1
    
    cd $rundir
    $gmxrun -v -deffnm $tprname -s nvt-cycle -cpi $lastcpt -append
    cd ..
done
