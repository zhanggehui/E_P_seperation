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
        for ((i=0;i<20;i++)); do
            pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`   
            cd ${pressure}Mpa-0V ; ffile=nvt-pro-traj.trr
            xvgfile=${ion}_${pressure}Mpa.xvg
            gmx make_ndx -f last.gro < ../../md_scripts/rdf_ndx.sh
            gmx rdf -f $ffile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile -b 0 -e 5000
            #-bin 0.01
            cp $xvgfile ../../$rdfdir/$ion
            rm -rf \#*
            cd ../
        done
        for ((i=0;i<17;i++)); do 
            voltage=`awk -v i=$i 'BEGIN{printf("%s",0.1*i);}'`
            cd 0Mpa-${voltage}V ; ffile=nvt-pro-traj.trr
            xvgfile=${ion}_${voltage}V.xvg
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
