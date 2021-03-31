source $scriptsdir/rdf_func.sh
cd ../
for((i=0; i<$n_ions; i++)); do
    ion=${ions[$i]}
    cd ./$ion/0Mpa-0V
    ffile=nvt-pro-traj.trr
    xvgfile=${ion}_rdf.xvg
    get_rdf $ffile $ion $xvgfile
    mv $xvgfile ../../$rundir
    cd ../../
done
