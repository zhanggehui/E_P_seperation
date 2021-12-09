mkdir ./msd

cd ./msd

echo -e "a 8980\nq" | $gmx make_ndx -f ../nvt-production.gro
echo "a_8980" | $gmx msd -f ../nvt-production.trr -s ../nvt-production.tpr -lateral z -n index.ndx -b 10000 -e 20000 #-mol 
rm -rf index.ndx

cd ../
mv ./msd ../$rundir/${pressure}Mpa-${voltage}V
