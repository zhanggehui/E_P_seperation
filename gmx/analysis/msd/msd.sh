mkdir ./msd

cd ./msd

echo -e "a 8980\nq" | $gmx make_ndx -f ../nvt-production.gro
echo "a_8980" | $gmx msd -f ../nvt-production.trr -s ../nvt-production.tpr -lateral z -mol -n index.ndx
rm -rf index.ndx

cd ../
mv ./msd ../$rundir/${pressure}Mpa-${voltage}V
