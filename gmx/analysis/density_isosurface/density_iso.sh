mkdir ./cube

cd ./cube

echo -e "a OW\na 8980\ndel 8\ndel 8\nq" | $gmx make_ndx -f ../nvt-production.gro
echo -e "10\n0\n" | $gmx trjconv -s ../nvt-production.tpr -f ../nvt-production.trr -n index.ndx -o md_cnt.xtc -center -pbc mol
echo -e "9\n10\n" | $gmx spatial -s ../nvt-production.tpr -f md_cnt.xtc -n index.ndx -nab 80 -b 1000 -e 60000

rm -rf index.ndx

cd ../
mv ./cube ../$rundir/${pressure}Mpa-${voltage}V
