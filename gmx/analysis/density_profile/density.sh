source $scriptsdir/density_func.sh
ion=$rundir
get_density_along_z $ion ion.xvg
get_density_along_z OW OW.xvg
get_density_along_z OH OH.xvg
mv *.xvg ../$rundir
