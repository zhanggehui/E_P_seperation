trajgro=${pressure}Mpa-${voltage}V.gro
get_continuous_frame SOL $trajgro 1000 10000
source $scriptsdir/velocity/get_velocity_profile.sh z vy $trajgro 6
rm -rf $trajgro
mv z-vy.xvg ../$rundir/${pressure}Mpa-${voltage}V.xvg
