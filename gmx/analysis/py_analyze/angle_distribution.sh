mkdir ./$rundir
cd ./$rundir
dir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/analysis/py_analyze

echo -e "a OW or a ${ion}\nq" | $gmx make_ndx -f ../nvt-production.gro -quiet
echo "OW_OR_A_${ion}" | $gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion_OW.gro -pbc nojump -b 1000 -e 10000 -n index.ndx -quiet

# echo -e "a OW | a 3948\nq" | gmx make_ndx -f ../nvt-production.gro -quiet
# echo "OW_a_3948" | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion_OW.gro -pbc nojump -b ${tb} -e ${te} -n index.ndx -quiet

pyrun="python $dir/angle_distribution.py -ingro ion_OW.gro -seltype OW -reftype NA -angletype"
$pyrun phix
$pyrun phiy
$pyrun theta

rm -rf \#* index.ndx ion_OW.gro
cd ../
mv ./$rundir ../$rundir/${pressure}Mpa-${voltage}V
