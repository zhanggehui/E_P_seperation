source $scriptsdir/rdf_func.sh
cd ../
for((i=0; i<$n_ions; i++)); do
    ion=${ions[$i]}
    cd ./$ion/0Mpa-0V
    xvgfile=${ion}_rdf.xvg
    get_rdf $ion $xvgfile
    mv $xvgfile ../../$rundir
    cd ../../
done
