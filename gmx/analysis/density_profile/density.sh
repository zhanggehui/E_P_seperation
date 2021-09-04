dir=${pressure}Mpa-${voltage}V
mkdir ./$dir

echo -e "a OW\nr SOL & ! a OW\nname 12 HW\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f nvt-production.gro
indexfile=index.ndx
get_density_along_z OW ./$dir/OW.xvg
get_density_along_z HW ./$dir/HW.xvg

indexfile=waterlayer.ndx
get_density_along_z $ion ./$dir/ion.xvg
get_density_along_z funcgrp ./$dir/funcgrp.xvg

rm -rf \#* index.ndx
mv ./$dir ../$rundir/$dir
