function get_rdf() {
    echo -e "a OW\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f last.gro
    gmx rdf -f $1 -n index.ndx -ref $2 -sel OW -selrpos atom -seltype atom -o $3 -b 0 -e 5000 -rmax 1
    rm -rf \#*
}

ions=("CS" "LI" "NA" "K" "CA" "MG")
n_ions=${#ions[@]}
