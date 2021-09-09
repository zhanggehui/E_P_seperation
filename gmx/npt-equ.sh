$gmx grompp -f $scriptsdir/npt-equ.mdp -c ../em/em.gro -p ../GO_ion_pp.top -o npt-equ.tpr -n ../waterlayer.ndx  # -maxwarn 1
$gmxrun -v -deffnm npt-equ
