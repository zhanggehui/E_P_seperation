function get_density_along_z() {
    echo -e "a OW\nr SOL & ! a OW\nname 12 HW\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f nvt-production.gro
    echo "$1" | gmx density -f nvt-production.trr -n index.ndx -s nvt-production.tpr -dens number -d Z -o $2 -b 0 -e 10000 -sl 100
    rm -rf \#* index.ndx
}

function get_density_along_z() {
    echo -e "a OW\nr SOL & ! a OW\nname 12 HW\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f nvt-production.gro
    echo "$1" | gmx density -f nvt-production.trr -n index.ndx -s nvt-production.tpr -dens number -d Z -o $2 -b 0 -e 10000 -sl 100
    rm -rf \#* index.ndx
}
