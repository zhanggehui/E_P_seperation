
cd ./1900Mpa-0V
ion=$rundir
xvgfile=${ion}.xvg
#3 ion; 5 water
echo q | gmx make_ndx -f nvt-production.gro
echo "$ion" | gmx density -f nvt-production.trr -n index.ndx -s nvt-production.tpr -dens number -d Z -o $xvgfile -b 0 -e 10000 -sl 50
cp $xvgfile ../$rundir
rm -rf \#* index.ndx
cd ../
