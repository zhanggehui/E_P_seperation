#!/bin/bash

gmx grompp -f ./$scriptsdir/nvt-equ.mdp -c GO2-afterem.gro -p GO2.top \
-o ./$rundir/nvt-equ.tpr -po ./$rundir/nvt-equ-out -n waterlayer.ndx

cd $rundir
$gmxrun -v -deffnm nvt-equ
#echo "temperature" | gmx energy -f nvt-equ.edr -o nvt-equ-tem.xvg
cd ..
