mkdir ./angle
cd ./angle

echo -e "a OW | a 3948\nq" | gmx make_ndx -f ../nvt-production.gro -quiet
for ((i=0; i<10; i=i+1)); do
    
    tb=$((i*5000))
    te=$(((i+1)*5000))

    # echo -e "a OW or a ${ion}\nq" | gmx make_ndx -f ../nvt-production.gro -quiet
    # echo "OW_OR_A_${ion}" | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion_OW.gro -pbc nojump -b 1000 -e 10000 -n index.ndx -quiet
    
    echo "OW_a_3948" | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion_OW_$i.gro -pbc nojump -b ${tb} -e ${te} -n index.ndx -quiet

    dir=/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis/angle_distribution

    # python $dir/angle_distribution.py ion_OW.gro phix.csv phix.mat ${ion} phix
    # python $dir/angle_distribution.py ion_OW.gro phiy.csv phiy.mat ${ion} phiy
    python $dir/angle_distribution.py ion_OW_$i.gro theta_$i.csv out_$i.mat ${ion} theta
    
done
rm -rf \#* index.ndx ion_OW.gro
cd ../
mv ./angle ../$rundir/${pressure}Mpa-${voltage}V
