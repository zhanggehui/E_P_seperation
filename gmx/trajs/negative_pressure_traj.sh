source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

negative=n5
trajdir=negative_${negative}_traj
#rm -rf ../lay${negative}_traj
if [ ! -d $trajdir ] ; then
mkdir ../$trajdir

cd ./0Mpa-0V
trajname=0Mpa-0V.gro
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf  $trajname ../../$trajdir
rm  -rf \#*
cd ..

for ((i=1;i<20;i++))
do
    cd ./${i}00Mpa-0V
    trajname=${i}00Mpa-0V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../$trajdir
    rm  -rf \#*
    cd ..
done

source ./scripts/negative_voltage_traj.sh

else
echo 'already exists!'
fi

