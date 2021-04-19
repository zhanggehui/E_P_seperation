# rundir刚好可以与要提取的离子同名
ion=$rundir
trajgro=${pressure}Mpa-${voltage}V.gro
get_first_and_last_frame $ion $trajgro 10000
mv $trajgro ../$rundir/
