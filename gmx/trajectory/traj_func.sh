function get_traj() {
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $1 \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $1 ../../$2
    rm  -rf \#*
}
