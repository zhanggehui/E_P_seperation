function get_traj() {
    echo "$1" | gmx trjconv -f nvt-production.trr -s nvt-production.tpr \
    -o $2 -pbc nojump -b 0 -e 10000 -skip 1000000 -n waterlayer.ndx
    rm -rf \#*
}
