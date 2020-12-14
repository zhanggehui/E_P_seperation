source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
ions=("CS" "LI" "NA" "K" "CA" "MG")
num=${#ions[@]}
rdfdir=rdfs_0Mpa_0V
if [ ! -d $rdfdir ] ; then
mkdir $rdfdir

for((i=0;i<$num;i++)) ; do
ion=${ions[$i]}
cd ./$ion/0Mpa-0V ; ffile=nvt-pro-traj.trr
xvgfile=${ion}_rdf.xvg
gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000 -bin 0.01
#-bin 0.01 -rmax 1
cp $xvgfile ../../$rdfdir
rm -rf \#*
cd ../../
done

else
echo "already exits!"
fi
