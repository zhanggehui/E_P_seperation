mkdir ./rest_select
cd ./rest_select

# declare -A first_shell=(["LI"]="0.278" ["NA"]="0.32" ["K"]="0.354" ["CS"]="0.396")
# echo -e "\"1st shell\" resname SOL and name OW and within ${first_shell[$ion]} of group $ion\n" | \
# 
-b 0 -e 10000 -select "\"in_shell\" resname SOL and name OW and within 1.0 of atomnr 4553" | \
$gmx select -s ../nvt-production.tpr -f ../nvt-production.trr -n ../waterlayer.ndx -os -oc -oi -on -om -of -olt -b 0 -e 0

$gmx trjconv -f nvt-production.trr -s nvt-production.tpr -o a.gro -b 0 -e 1000 -n index.ndx -dt $4 -pbc nojump

# $gmx trajectory -s ../nvt-production.tpr -f ../nvt-production.trr -n ../waterlayer.ndx \
# -b 0 -e 10000 -select "\"in_shell\" resname SOL and name OW and within 1.0 of atomnr 4553" 


cd ../
mv ./rest_select ../$rundir/${pressure}Mpa-${voltage}V
