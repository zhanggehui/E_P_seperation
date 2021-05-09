# mkdir ./gangle
# cd ./gangle

ion=$rundir
ion=CS
first_shell=(0.38)

dir=/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis/angle
source $dir/make_index_txt.sh ../nvt-production.gro
indexes=($(awk '{print $0}' index.txt))
n_idxs=${#indexes[@]}
for ((time=0; time<=10; time++)); do
    for ((i=0; i<${n_idxs}; i++)); do
        index=${indexes[$i]}
        echo -e "resname SOL and name OW and within ${first_shell[0]} of atomnr ${index}\n" | \
        gmx select -quiet -f ../nvt-production.trr -s ../nvt-production.tpr \
        -on ${index}.ndx -b ${time} -e ${time}
    done
    python $dir/read_ion_index.py *.ndx
    gmx gangle -quiet -f ../nvt-production.trr -s ../nvt-production.tpr -n ./vector.ndx \
    -oall av-${time}.xvg -b ${time} -e ${time} \
    -g1 vector -group1 'group vector' \
    -g2 z #-oav av-${time}.xvg -oh av-${time}.xvg
    #rm -rf *.ndx

    n_t=$((time % 1000))
    if [ $n_t -eq 0 ] && [ $time -gt 0 ]; then
        python $dir/angle_hist.py av-*.xvg && rm -rf av-*.xvg
    fi
done

if [ $n_t -ne 0 ] || [ $time -lt 1000 ]; then
    python $dir/angle_hist.py av-*.xvg && rm -rf av-*.xvg  
fi

# cd ../
# mv ./gangle ../$rundir/${pressure}Mpa-${voltage}V
