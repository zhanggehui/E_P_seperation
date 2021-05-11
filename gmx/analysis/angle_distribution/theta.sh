mkdir ./angle
cd ./angle


ion=$rundir
echo -e "a OW or a ${ion}\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f ../nvt-production.gro
echo '8' | gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o test.gro -pbc nojump -b 1000 -e 10000 -n index.ndx

dir=/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis/angle_distribution

python $dir/angle_distribution.py test.gro angle_dis.csv ${ion} z
rm -rf test.gro


cd ../
mv ./angle ../$rundir/${pressure}Mpa-${voltage}V
