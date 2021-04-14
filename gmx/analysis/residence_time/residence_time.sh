mkdir ./select
cd ./select
echo -e "\"1st shell\" resname SOL and name OW and within 0.32 of group NA\n" | \
gmx select -s ../nvt-production.tpr -f ../nvt-production.trr -n ../waterlayer.ndx -os -oc -oi -on -om -of -olt -b 0 -e 10000
cd ../
mv ./select ../$rundir/${pressure}Mpa_${voltage}V
