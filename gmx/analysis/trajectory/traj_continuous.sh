#rundir刚好可以与要提取的离子同名
ion=$rundir
trajgro=${pressure}Mpa-${voltage}V.gro
get_continuous_frame SOL $trajgro 5000 10000
mv $trajgro ../$rundir/
