mkdir ./angle
cd ./angle

# echo -e "a OW or a ${ion}\nq" | gmx make_ndx -f ../nvt-production.gro -quiet
echo -e "a OW | a 3948\nq" | gmx make_ndx -f ../nvt-production.gro -quiet

dir=/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis/angle_distribution
for ((a=0; a<10; a=a+1)); do
    tb=$((a*5000))
    te=$(((a+1)*5000))

    # echo "OW_OR_A_${ion}" | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion_OW.gro -pbc nojump -b 1000 -e 10000 -n index.ndx -quiet
    echo "OW_a_3948" | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion_OW_$a.gro -pbc nojump -b ${tb} -e ${te} -n index.ndx -quiet

    # python $dir/angle_distribution.py ion_OW.gro phix.csv phix.mat ${ion} phix
    # python $dir/angle_distribution.py ion_OW.gro phiy.csv phiy.mat ${ion} phiy
    python $dir/angle_distribution.py ion_OW_$a.gro theta_$a.csv out_$a.mat ${ion} theta
done

python $dir/merge_mat.py out_*.mat
python $dir/merge_csv.py theta_*.csv

rm -rf \#* index.ndx ion_OW_*.gro # theta_*.csv out_*.mat
cd ../
mv ./angle ../$rundir/${pressure}Mpa-${voltage}V
