cd ../
mdpdir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/umbrella-script

# #Short equilibration
# gmx grompp -f $mdpdir/nvt-shortequ.mdp -c ../conf/confXXX.gro -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o equXXX.tpr
# $gmxrun -v -deffnm equXXX

# #Umbrella run
# gmx grompp -f $mdpdir/nvt-sampling.mdp -c equXXX.gro -t equXXX.cpt -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o umbrellaXXX.tpr
# $gmxrun -v -deffnm umbrellaXXX

$gmx grompp -f $mdpdir/nvt-sampling.mdp -c ../conf/confXXX.gro -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o umbrellaXXX.tpr
$gmxrun -v -deffnm umbrellaXXX
