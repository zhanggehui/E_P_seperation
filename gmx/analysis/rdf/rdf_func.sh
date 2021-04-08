function get_rdf() {
    #rm -rf *.xvg index.ndx
    echo -e "a OW\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f last.gro
    gmx rdf -f nvt-pro-traj.trr -n index.ndx -norm number_density -ref $1 -sel OW -selrpos atom -seltype atom -o $2 -b 0 -e 5000 -rmax 1
    rm -rf \#* index.ndx
}
