function get_rdf_and_coordnum() {
    echo -e "a OW\ndel 8\ndel 8\ndel 8\nq" | $gmx make_ndx -f nvt-production.gro
    $gmx rdf -f nvt-production.trr -n index.ndx -norm rdf -ref $1 -sel OW -selrpos atom -seltype atom -o $2 -cn $3 -b 1000 -e $4 -rmax 1
    rm -rf \#* index.ndx
}
