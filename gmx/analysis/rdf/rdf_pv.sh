source $scriptsdir/rdf_func.sh
cd ../
for((k=0; k<$n_ions; k++)); do
    ion=${ions[$k]}
    targetdir=$rundir/$ion
    mkdir -p $targetdir
    cd ./$ion
    for ((i=0; i<20; i++)); do
        pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`   
        cd ${pressure}Mpa-0V
        xvgfile=${pressure}Mpa.xvg
        get_rdf $ion $xvgfile
        mv $xvgfile ../../$targetdir
        cd ../
    done
    for ((i=0;i<17;i++)); do 
        voltage=`awk -v i=$i 'BEGIN{printf("%s",0.1*i);}'`
        cd 0Mpa-${voltage}V
        xvgfile=${voltage}V.xvg
        get_rdf $ion $xvgfile
        mv $xvgfile ../../$targetdir
        cd ../
    done
    cd ../
done
