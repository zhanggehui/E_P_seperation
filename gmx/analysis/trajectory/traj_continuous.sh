# rundir刚好可以与要提取的离子同名
ion=$rundir
trajgro=${pressure}Mpa-${voltage}V.gro
get_continuous_frame SOL $trajgro 5000 10000
source $scriptsdir/velocity/velocity_profile.sh z vy $trajgro
rm -rf $trajgro
mv z-vy.xvg ../$rundir/${pressure}Mpa-${voltage}V.xvg
