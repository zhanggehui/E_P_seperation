source $scriptsdir/rdf_func.sh
rdfdir=rdfs_pv
if [ ! -d $rdfdir ] ; then
    mkdir $rdfdir
    for((i=0;i<$n_ions;i++)); do
        ion=${ions[$i]}
        mkdir $rdfdir/$ion
        cd ./$ion
        targetdir=$rdfdir/$ion
        for ((i=0;i<20;i++)); do
            pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`   
            cd ${pressure}Mpa-0V ; ffile=nvt-pro-traj.trr
            xvgfile=${ion}_${pressure}Mpa.xvg
            get_rdf $ffile $ion $xvgfile $targetdir
            cd ../
        done
        for ((i=0;i<17;i++)); do 
            voltage=`awk -v i=$i 'BEGIN{printf("%s",0.1*i);}'`
            cd 0Mpa-${voltage}V ; ffile=nvt-pro-traj.trr
            xvgfile=${ion}_${voltage}V.xvg
            get_rdf $ffile $ion $xvgfile $targetdir
            cd ../
        done
        cd ../
    done
else
    echo "already exits!"
fi
