source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
#source /appsnew/mdapps/gromacs2019.3_cpu_intelmkl2019_cnscompat/bin/GMXRC2.bash
ionname=MG

#rm -rf ../${ionname}_traj
if [ ! -d ${ionname}_traj ] ; then
mkdir ../${ionname}_traj

cd ./0Mpa-0V
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o ${ionname}0Mpa-0V.gro \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf  ${ionname}0Mpa-0V.gro ../../${ionname}_traj
rm  -rf \#*
cd ..

for ((i=1;i<20;i++))
do
    cd ./${i}00Mpa-0V
    trajname=${ionname}${i}00Mpa-0V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../${ionname}_traj
    rm  -rf \#*
    cd ..
done

source ./scripts/voltage_traj.sh

else
echo 'already exists!'
fi

