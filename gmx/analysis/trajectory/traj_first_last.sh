trajgro=${pressure}Mpa-${voltage}V.gro
get_first_and_last_frame $ion $trajgro 10000
gmx trajectory -f nvt-production.trr -s nvt-production.tpr -b 0 -e 10000 -dt 10000
mv $trajgro ../$rundir/
