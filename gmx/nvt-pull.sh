$gmx grompp -f $scriptsdir/nvt-pull.mdp -c ../nvtequ/nvt-equ.gro -p ../GO_ion_pp.top -o nvt-pull.tpr -n ../waterlayer.ndx #-maxwarn 1
$gmxrun -v -deffnm nvt-pull
