#!/bin/bash

# environment variable:
# orientation ; rundir ; runscript ; scriptsdir

gmx grompp -f ./$scriptsdir/nvt-equ.mdp -c GO2-afterem.gro -p GO2.top \
-o ./$rundir/nvt-equ.tpr -po ./$rundir/nvt-equ-out -n waterlayer.ndx -maxwarn 1

cd $rundir ; $gmxrun -v -deffnm nvt-equ -cpt -1
#echo "temperature" | gmx energy -f nvt-equ.edr -o nvt-equ-tem.xvg  #能量输出被关闭
cd ..
