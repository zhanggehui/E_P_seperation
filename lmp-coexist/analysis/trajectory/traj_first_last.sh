sdir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-coexist

if [ ! -e 'topol.tpr' ]; then 
    $gmx grompp -f $sdir/em.mdp -c ../GO_ion.gro -p ../GO_ion_pp.top
    rm -rf mdout.mdp
fi

echo "name $1" | $gmx select -f ../GO_ion.gro -s topol.tpr -b 0 -e 0 -on
$gmx trjconv -f production.xtc -s topol.tpr -o traj.gro -pbc nojump -b 0 -skip 10000 -n index.ndx

rm -rf \#*
if [ -e index.ndx ]; then
    rm -rf index.ndx
fi
