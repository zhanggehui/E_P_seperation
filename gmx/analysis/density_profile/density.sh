dir=${pressure}Mpa-${voltage}V
mkdir ./$dir
echo -e "a OW\nr SOL & ! a OW\nname 12 HW\ndel 8\ndel 8\ndel 8\nq" | gmx make_ndx -f nvt-production.gro
n_bins=400
get_density_along_z $ion ./$dir/ion.xvg ${n_bins}
get_density_along_z OW ./$dir/OW.xvg ${n_bins}
get_density_along_z HW ./$dir/HW.xvg ${n_bins}
rm -rf \#* index.ndx
mv ./$dir ../$rundir/$dir
