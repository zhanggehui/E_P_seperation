trajgro=${pressure}Mpa-${voltage}V.gro
get_continuous_frame $trajgro 0 10000 0
mv $trajgro ../$rundir/
