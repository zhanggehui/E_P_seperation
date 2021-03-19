#ionname=CS

if [ ! -d ${ionname}_traj ]
then
mkdir ../${ionname}_traj
fi

k=0
for ((i=1;i<10;i++))
do
    cd ./0Mpa-${k}.${i}V
    trajname=${ionname}0Mpa-${k}.${i}V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    rm  -rf \#*
    cp -rf  $trajname ../../${ionname}_traj
    cd ..
done

k=1
for ((i=1;i<7;i++))
do
    cd ./0Mpa-${k}.${i}V
    trajname=${ionname}0Mpa-${k}.${i}V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    rm  -rf \#*
    cp -rf  $trajname ../../${ionname}_traj
    cd ..
done

cd ./0Mpa-1V
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o ${ionname}0Mpa-1V.gro \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
rm  -rf \#*
cp -rf  ${ionname}0Mpa-1V.gro ../../${ionname}_traj
cd ..
