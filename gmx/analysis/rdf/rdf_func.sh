function get_rdf_and_coordnum() {
    # echo -e "a OW\ndel 8\ndel 8\ndel 8\nq" | $gmx make_ndx -f nvt-production.gro
    echo -e "name OW and z {1 to 2}\ngroup 3 and z {1 to 2}" | $gmx select -f nvt-production.trr -s nvt-production.tpr -b 0 -e 0 -on
    $gmx rdf -f nvt-production.trr -n index.ndx -norm rdf -ref 1 -sel 0 -selrpos atom -seltype atom -o $2 -cn $3 -b 1000 -e $4 -rmax 1
    rm -rf \#* index.ndx
}
