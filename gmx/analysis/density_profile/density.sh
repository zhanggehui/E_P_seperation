source $scriptsdir/density_func.sh

cd ../
cd ./0Mpa-1.5V

get_density_along_z OW density.xvg

ion=$rundir
#get_density_along_z $ion density.xvg

mv density.xvg ../$rundir
cd ../
