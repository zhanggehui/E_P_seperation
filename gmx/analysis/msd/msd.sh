mkdir ./msd
cd ./msd

# echo -e "a 9115\nq" | $gmx make_ndx -f ../nvt-production.gro
# echo "a_9115" | $gmx msd -f ../nvt-production.trr -s ../nvt-production.tpr -lateral z -n index.ndx -b 10000 -e 20000
echo "3" | $gmx msd -f ../nvt-production.trr -s ../nvt-production.tpr -lateral z -b 10000 -e 30000 -mol 

rm -rf index.ndx
cd ../
mv ./msd/msd.xvg ../$rundir/$ion.xvg
rm -rf ./msd
