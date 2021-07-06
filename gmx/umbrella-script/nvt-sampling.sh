# Short equilibration
gmx grompp -f $scriptsdir/umbrella-script/nvt-shortequ.mdp -c ../conf/confXXX.gro -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o equXXX.tpr
gmx mdrun -deffnm equXXX

# Umbrella run
gmx grompp -f $scriptsdir/umbrella-script/nvt-sampling.mdp -c equXXX.gro -t nptXXX.cpt -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o umbrellaXXX.tpr
gmx mdrun -deffnm umbrellaXXX
