gmx grompp -f $scriptsdir/nvt-equ.mdp -c GO_ion_afterem.gro -p GO_ion_pp.top \
-o ./$rundir/nvt-equ.tpr -n waterlayer.ndx #-maxwarn 1

cd $rundir
$gmxrun -v -deffnm nvt-equ
#echo "temperature" | gmx energy -f nvt-equ.edr -o nvt-equ-tem.xvg  #能量输出被关闭，该命令无意义
cd ..
