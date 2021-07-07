#检查采样轨迹

for udir in `ls | grep umbrella`; do 

  cd $udir

  echo 15 | gmx trjconv -s ./umbrella379.tpr -f ./umbrella379.trr -o conf379.gro -n ../../waterlayer.ndx

  cd ../

done

