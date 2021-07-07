#检查采样轨迹
source ~/gmx_zgh.sh
mkdir springs
for udir in `ls | grep umbrella`; do 
  cd $udir
  fnum=${udir##*-}
  echo 15 | gmx trjconv -s ./umbrella$fnum.tpr -f ./umbrella$fnum.trr -o ../springs/conf$fnum.gro -n ../../waterlayer.ndx
  cd ../.
done
