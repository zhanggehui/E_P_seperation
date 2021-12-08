trajgro=${pressure}Mpa-${voltage}V.gro
get_continuous_frame $ion $trajgro 0 60000
mv $trajgro ../$rundir/
