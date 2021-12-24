trajgro=${pressure}Mpa-${voltage}V.gro
echo -e "a OW\nq" | $gmx make_ndx -f nvt-production.gro
# get_continuous_frame OW $trajgro 1000 10000
get_continuous_frame $ion $trajgro 1000 10000

source $scriptsdir/velocity/get_velocity_profile_OW.sh z vy $trajgro 4 $ion 

rm -rf index.gro $trajgro
mv z-vy.xvg ../$rundir/${pressure}Mpa-${voltage}V.xvg
