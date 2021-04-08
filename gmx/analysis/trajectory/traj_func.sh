function get_first_and_last_frame() {
    echo "$1" | gmx trjconv -f nvt-production.trr -s nvt-production.tpr \
    -o $2 -pbc nojump -b 0 -e $3 -skip $3 -n waterlayer.ndx
    rm -rf \#*
}
