mkdir ./rest_select
cd ./rest_select

declare -A first_shell=(["LI"]="0.274" ["NA"]="0.322" ["K"]="0.354" ["CS"]="0.394")
echo -e "\"1st shell\" resname SOL and name OW and within ${first_shell[$ion]} of group $ion\n" | \
$gmx select -s ../nvt-production.tpr -f ../nvt-production.trr -n ../waterlayer.ndx -os -oc -oi -on -om -of -olt -b 1000 -e 10000 -norm   # -nocumlt


# echo -e "atomnr 4553 or resname SOL and within 1.5 of atomnr 4553\n" | \
# $gmx select -s ../nvt-production.tpr -f ../nvt-production.trr -n ../waterlayer.ndx -os -oc -oi -on -om -of -olt -b 0 -e 0
# $gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o a.gro -b 0 -e 1000 -n index.ndx -pbc nojump

cd ../
mv ./rest_select ../$rundir/${pressure}Mpa-${voltage}V
