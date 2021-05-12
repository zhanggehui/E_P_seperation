trajgro=${pressure}Mpa-${voltage}V.gro
get_continuous_frame SOL $trajgro 5000 10000
mv $trajgro ../$rundir/
