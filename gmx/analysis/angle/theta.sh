mkdir ./gangle
cd ./gangle

ion=$rundir
get_first_and_last_frame $ion ion.gro 0

indexes=('4091' '4092')
n_idxs=${#indexes[@]}
for ((time=0; time<=10000; time=time+1000)); then
    for ((i=0; i<${n_idxs}; i++)); do
        index=${indexes[$i]}
        echo -e "resname SOL and name OW and within 0.32 of atomnr ${ioni}\n" | \
        gmx select -f ../nvt-production.trr -s ../nvt-production.tpr -on ${index}.ndx -b ${time} -e ${time}        
    done
        python read_ion_index.py *.ndx
        gmx gangle -f ../nvt-production.trr -s ../nvt-production.tpr -n ./vector.ndx \
        -oav av-${time}.xvg -oall av-${time}.xvg -oh av-${time}.xvg -b ${time} -e ${time} \
        -g1 vector -group1 group vector \
        -g2 z
    done
then

cd ../
mv ./gangle ../$rundir/${pressure}Mpa-${voltage}V


echo -e "resname SOL and name OW and within 0.32 of atomnr 4092\n" | \
gmx select -f ../nvt-production.trr -s ../nvt-production.tpr -on 4092.ndx -b 1000 -e 1000
