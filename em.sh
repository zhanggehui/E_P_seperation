#!/bin/bash

for ((i=0;i<2;i++))
do
    gmx grompp -f ./scripts/em.mdp  -c GO2-ion.gro -p GO2.top \
    -o ./$rundir/em.tpr -po ./$rundir/em-out -n waterlayer.ndx -maxwarn 1

    cd $rundir
    $gmxrun -v -deffnm em
    #echo "potential" | gmx energy -f em.edr -o em-potential.xvg
    cp -rf em.gro ../GO2-afterem.gro
    cp -rf ../GO2-afterem.gro ../GO2-ion.gro
    cd ..
done

