mkdir ./angle
cd ./angle


ion=$rundir
echo -e "a OW or a ${ion}\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f ../nvt-production.gro -quiet
echo '8' | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o ion_OW.gro -pbc nojump -b 1000 -e 10000 -n index.ndx -quiet

dir=/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis/angle_distribution

python $dir/angle_distribution.py ion_OW.gro phix.csv ${ion} phix
python $dir/angle_distribution.py ion_OW.gro phiy.csv ${ion} phiy
python $dir/angle_distribution.py ion_OW.gro theta.csv ${ion} theta
rm -rf ion_OW.gro


cd ../
mv ./angle ../$rundir/${pressure}Mpa-${voltage}V