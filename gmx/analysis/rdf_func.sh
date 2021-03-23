function get_rdf() {
echo -e "a OW\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f last.gro
gmx rdf -f $1 -n index.ndx -ref $2 -sel OW -selrpos atom -seltype atom -o $3 -b 0 -e 5000
#-bin 0.01 -rmax 1
cp $3 ../../$4
rm -rf \#*
}
