function get_density_along_z() {
    echo "$1" | gmx density -f nvt-production.trr -n $indexfile -s nvt-production.tpr -dens number -d Z -o $2 -b 1000 -e 10000 -sl 400
}
