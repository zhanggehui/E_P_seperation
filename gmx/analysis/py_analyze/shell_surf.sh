mkdir ./$rundir
cd ./$rundir
dir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/analysis/py_analyze

out=/home/liufeng_pkuhpc/lustre3/ion_OW.gro
echo -e "a OW or a ${ion}\nq" | $gmx make_ndx -f ../nvt-production.gro -quiet
echo "OW_OR_A_${ion}" | $gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o $out -pbc nojump -b 1000 -e 10000 -n index.ndx -quiet

python $dir/shell_surf.py -ingro $out -seltype OW -reftype ${ion}

rm -rf \#* index.ndx $out
cd ../
mv ./$rundir ../$rundir/${pressure}Mpa-${voltage}V
