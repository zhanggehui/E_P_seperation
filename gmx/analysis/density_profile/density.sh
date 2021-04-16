ion=$rundir
dir=${pressure}Mpa_${voltage}V
mkdir ./$dir
get_density_along_z $ion ./$dir/ion.xvg
get_density_along_z OW ./$dir/OW.xvg
get_density_along_z HW ./$dir/HW.xvg
mv ./$dir ../$rundir/$dir
