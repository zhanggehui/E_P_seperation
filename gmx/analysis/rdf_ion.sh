source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

ions=("CS" "LI" "NA" "K" "CA" "MG")
num=${#ions[@]}
rdfdir=rdfs_0Mpa_0V
targetdir=$rdfdir
if [ ! -d $rdfdir ] ; then
    mkdir $rdfdir
    for((i=0;i<$num;i++)) ; do
        ion=${ions[$i]}
        cd ./$ion/0Mpa-0V ; ffile=nvt-pro-traj.trr
        xvgfile=${ion}_rdf.xvg
        get_rdf $ffile $ion $xvgfile $targetdir
        rm -rf \#*
        cd ../../
    done
else
    echo "already exits!"
fi
