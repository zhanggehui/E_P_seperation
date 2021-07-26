gmx grompp -f $scriptsdir/nvt-equ.mdp -c ../em/em.gro -p ../GO_ion_pp.top -o nvt-equ.tpr -n ../waterlayer.ndx #-maxwarn 1
$gmxrun -v -deffnm nvt-equ
