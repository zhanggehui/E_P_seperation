gmx grompp -f $scriptsdir/nvt-equ.mdp -c ../em/em.gro -p ../GO_ion_pp.top -o nvt-equ.tpr -n ../waterlayer.ndx -maxwarn 1
$gmxrun -v -deffnm nvt-equ
#echo "temperature" | gmx energy -f nvt-equ.edr -o nvt-equ-tem.xvg  #能量输出被关闭，仅最后一步的能量被记录在文件中
