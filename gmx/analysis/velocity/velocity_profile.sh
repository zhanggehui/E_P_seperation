mkdir ${pressure}Mpa-${voltage}V
cd ./${pressure}Mpa-${voltage}V

echo -e "a OW\nq" | $gmx make_ndx -f ../nvt-production.gro
echo "OW" | $gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o OW.gro -b 1000 -e 60000 -n index.ndx
source $scriptsdir/velocity/get_velocity_profile.sh z vy OW.gro 4 OW
rm -rf index.gro OW.gro
mv z-vy.xvg OW.xvg


echo "$ion" | $gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion.gro -b 1000 -e 60000 -n ../waterlayer.ndx
source $scriptsdir/velocity/get_velocity_profile.sh z vy ion.gro 4 $ion 
rm -rf ion.gro
mv z-vy.xvg ion.xvg

cd ../
mv ${pressure}Mpa-${voltage}V ../$rundir/
