trajgro=${pressure}Mpa-${voltage}V.gro
get_continuous_frame SOL $trajgro 1000 60000
source $scriptsdir/velocity/get_velocity_profile.sh z vy $trajgro 4
rm -rf $trajgro
mv z-vy.xvg ../$rundir/${pressure}Mpa-${voltage}V.xvg
