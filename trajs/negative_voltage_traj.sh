k=0
for ((i=1;i<10;i++))
do
    cd ./0Mpa-${k}.${i}V
    trajname=0Mpa-${k}.${i}V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../$trajdir
    rm  -rf \#*
    cd ..
done

k=1
for ((i=1;i<7;i++))
do
    cd ./0Mpa-${k}.${i}V
    trajname=0Mpa-${k}.${i}V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../$trajdir
    rm  -rf \#*
    cd ..
done

cd ./0Mpa-1V
trajname=0Mpa-1V.gro
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf $trajname ../../$trajdir
rm  -rf \#*
cd ..
