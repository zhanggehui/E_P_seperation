mkdir ./$rundir
cd ./$rundir
dir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/analysis/py_analyze
outgro=/home/liufeng_pkuhpc/lustre3/zgh/tmp_out/${ion}/ion_OW.gro

echo -e "a OW or a ${ion}\nq" | $gmx make_ndx -f ../nvt-production.gro -quiet
echo "OW_OR_A_${ion}" | $gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o $outgro -pbc nojump -b 1000 -e 10000 -n index.ndx -quiet

# python $dir/shell_surf.py -ingro $outgro -seltype OW -reftype ${ion}

rm -rf \#* index.ndx # $outgro
cd ../
mv ./$rundir ../$rundir/${pressure}Mpa-${voltage}V
