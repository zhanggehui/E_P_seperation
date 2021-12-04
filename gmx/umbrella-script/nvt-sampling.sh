cd ../
mdpdir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/umbrella-script

# 看是否需要进行短暂的平衡，当拉动足够缓慢可以不进行
# #Short equilibration
# $gmx grompp -f $mdpdir/nvt-shortequ.mdp -c ../conf/confXXX.gro -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o equXXX.tpr
# $gmxrun -v -deffnm equXXX

# #Umbrella run
# $gmx grompp -f $mdpdir/nvt-sampling.mdp -c equXXX.gro -t equXXX.cpt -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o umbrellaXXX.tpr
# $gmxrun -v -deffnm umbrellaXXX
cp ../confXXX.gro ./
$gmx grompp -f $mdpdir/nvt-sampling.mdp -c ./confXXX.gro -p ../../GO_ion_pp.top -n ../../waterlayer.ndx -o umbrellaXXX.tpr
$gmxrun -v -deffnm umbrellaXXX
