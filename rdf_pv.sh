source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
ions=("CS" "LI" "NA" "K" "CA" "MG")
num=${#ions[@]}
rdfdir=rdfs_pv
if [ ! -d $rdfdir ] ; then
mkdir $rdfdir

for((i=0;i<$num;i++)) ; do
ion=${ions[$i]}
mkdir $rdfdir/$ion

cd ./$ion

#0Mpa-0V
cd 0Mpa-0V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_0Mpa.xvg
gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000
#-bin 0.01 -rmax 1
cp $xvgfile ../../$rdfdir/$ion
rm -rf \#*
cd ../

#Mpa
for ((k=1;k<20;k++)) ; do
cd ${k}00Mpa-0V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_${k}00Mpa.xvg
gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000
#-bin 0.01
cp $xvgfile ../../$rdfdir/$ion
rm -rf \#*
cd ../
done

#V
cd 0Mpa-0V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_0V.xvg ; ffile=nvt-pro-traj.trr
gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000
#-bin 0.01
cp $xvgfile ../../$rdfdir/$ion
rm -rf \#*
cd ../

cd 0Mpa-1V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_1V.xvg ; ffile=nvt-pro-traj.trr
gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000
#-bin 0.01
cp $xvgfile ../../$rdfdir/$ion
rm -rf \#*
cd ../

j=0
for ((k=1;k<10;k++)) ; do
cd 0Mpa-$j.${k}V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_$j.${k}V.xvg
gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000
#-bin 0.01
cp $xvgfile ../../$rdfdir/$ion
rm -rf \#*
cd ../
done

j=1
for ((k=1;k<7;k++)) ; do
cd 0Mpa-$j.${k}V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_$j.${k}V.xvg
gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000
#-bin 0.01
cp $xvgfile ../../$rdfdir/$ion
rm -rf \#*
cd ../
done

cd ../
done

else
echo "already exits!"
fi
