xvgfile=${pressure}Mpa-${voltage}V.xvg
get_rdf_and_coordnum $ion $xvgfile 10000
mv cn.xvg ../$rundir
mv $xvgfile ../$rundir
