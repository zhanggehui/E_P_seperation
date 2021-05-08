# mkdir ./gangle
# cd ./gangle

# ion=$rundir
# get_first_and_last_frame $ion ion.gro 0

indexes=('4091' '4092' '4093' '4094')
n_idxs=${#indexes[@]}
for ((time=0; time<=0; time++)); do
    for ((i=0; i<${n_idxs}; i++)); do
        index=${indexes[$i]}
        echo -e "resname SOL and name OW and within 0.38 of atomnr ${index}\n" | \
        gmx select -f ../nvt-production.trr -s ../nvt-production.tpr -on ${index}.ndx -b ${time} -e ${time}        
    done
    python /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis/angle/read_ion_index.py *.ndx
    # rm -rf *.ndx
    # gmx gangle -f ../nvt-production.trr -s ../nvt-production.tpr -n ./vector.ndx \
    # -oav av-${time}.xvg -oall av-${time}.xvg -oh av-${time}.xvg -b ${time} -e ${time} \
    # -g1 vector -group1 group vector \
    # -g2 z
done

# cd ../
# mv ./gangle ../$rundir/${pressure}Mpa-${voltage}V
