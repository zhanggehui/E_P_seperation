if [ ! -d select ]; then
    mkdir ./select
    cd ./select
    echo -e "\"1st shell\" resname SOL and name OW and within 0.24 of group NA\n" | \
    gmx select -s ../traj.tpr -f ../nvt-pro-traj.trr -n ../waterlayer.ndx -os -oc -oi -on -om -of -olt -b 0 -e 5000
    rm -rf \#*
    cd ../
fi
mv ./select ../../$rundir/${pressure}Mpa_${voltage}V
