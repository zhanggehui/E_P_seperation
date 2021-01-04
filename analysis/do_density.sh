source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
ions=("CS" "LI" "NA" "K" "CA" "MG")
num=${#ions[@]}
densitydir=density_1900Mpa_0V
if [ ! -d $densitydir ] ; then
mkdir $densitydir

for((i=0;i<$num;i++)) ; do
ion=${ions[$i]}
cd ./$ion/1900Mpa-0V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_density.xvg
echo q | gmx make_ndx -f last.gro
echo 3 | gmx density -f $ffile -n index.ndx -s traj.tpr -dens number -d Z -o $xvgfile -b 0 -e 5000 -sl 50
#3 ion; 5 water
cp $xvgfile ../../$densitydir
rm -rf \#*
cd ../../
done

else
echo "already exits!"
fi
