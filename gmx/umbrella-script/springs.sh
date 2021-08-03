# 检查采样轨迹
source ~/software/gmx_zgh.sh
mkdir springs
for udir in `ls | grep umbrella`; do 
  cd $udir
  fnum=${udir##*-}
  echo 14 | gmx trjconv -s ./umbrella$fnum.tpr -f ./umbrella$fnum.trr -o ../springs/${fnum}conf${fnum}.gro -n ../../waterlayer.ndx
  cd ../.
done
