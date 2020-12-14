source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

trajdir=mix_traj
if [ ! -d $trajdir ] ; then
mkdir ../$trajdir
pressure=1500

cd ./${pressure}Mpa-0V

trajname=CS${pressure}Mpa-0V.gro
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf $trajname ../../$trajdir

trajname=LI${pressure}Mpa-0V.gro
echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf $trajname ../../$trajdir
rm  -rf \#*
cd ..

k=0
for ((i=1;i<10;i++))
do
    cd ./${pressure}Mpa-${k}.${i}V
    
    trajname=CS${pressure}Mpa-${k}.${i}V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../$trajdir
    
    trajname=LI${pressure}Mpa-${k}.${i}V.gro
    echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../$trajdir
    
    rm  -rf \#*
    cd ..
done

k=1
for ((i=1;i<3;i++))
do
    cd ./${pressure}Mpa-${k}.${i}V
    
    trajname=CS${pressure}Mpa-${k}.${i}V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../$trajdir
    
    trajname=LI${pressure}Mpa-${k}.${i}V.gro
    echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../$trajdir
    
    rm  -rf \#*
    cd ..
done

cd ./${pressure}Mpa-1V

trajname=CS${pressure}Mpa-1V.gro
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf $trajname ../../$trajdir

trajname=LI${pressure}Mpa-1V.gro
echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf $trajname ../../$trajdir
rm  -rf \#*
cd ..

else
echo 'already exists!'
fi

