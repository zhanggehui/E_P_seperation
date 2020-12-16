#!/bin/bash

# environment variable:
# orientation ; rundir ; runscript ; scriptsdir

gmx grompp -f ./$scriptsdir/em.mdp -c GO2-ion.gro -p GO2.top \
-o ./$rundir/em.tpr -po ./$rundir/em-out -n waterlayer.ndx -maxwarn 1

cd $rundir ; $gmxrun -v -deffnm em
# echo "potential" | gmx energy -f em.edr -o em-potential.xvg
cp -rf em.gro ../GO2-afterem.gro
# cp -rf ../GO2-afterem.gro ../GO2-ion.gro   #暂时不用覆盖,这样两个文件不同
cd ..
