ion=$rundir
xvgfile=${pressure}Mpa-${voltage}V.xvg
cnfile=cn_${pressure}Mpa-${voltage}V.xvg
get_rdf_and_coordnum $ion $xvgfile $cnfile 10000
mv $cnfile ../$rundir/
mv $xvgfile ../$rundir/
