# trajgro=${pressure}Mpa-${voltage}V.gro
# get_continuous_frame $ion $trajgro 0 60000
# mv $trajgro ../$rundir/

mkdir con_trajs
cd ./con_trajs

echo -e "a 4553\na 9115\na 13677\n\nq" | $gmx make_ndx -f ../nvt-production.gro
get_continuous_frame a_4553 a_4553.gro 0 10000
get_continuous_frame a_9115 a_9115.gro 0 10000
get_continuous_frame a_13677 a_13677.gro 0 10000
rm -rf index.ndx

cd ../
mv ./con_trajs ../$rundir/
