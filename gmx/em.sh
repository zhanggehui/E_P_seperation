gmx grompp -f $scriptsdir/em.mdp -c ../GO_ion.gro -p ../GO_ion_pp.top -o em.tpr -n ../waterlayer.ndx # -maxwarn 1
$gmxrun -v -deffnm em
