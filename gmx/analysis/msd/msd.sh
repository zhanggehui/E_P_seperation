echo -e "a 8980\nq" | $gmx make_ndx -f ../nvt-production.gro
echo "a_8980" | $gmx msd -f nvt-production.trr -s nvt-production.tpr -lateral z -mol
rm -rf index.ndx
