source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

poolsimulation=1
if [ $poolsimulation -eq 1 ]; then
    dir1=pool ; runscript=em_wall.sh
else
    dir1=lay_spacing ; runscript=em.sh
fi

odir=`pwd`
ions=("CS" "LI" "NA" "K" "CA" "MG")
for((ioni=2;ioni<3;ioni++)); do
    ion=${ions[${ioni}]}
    for((layi=7;layi<=7;layi++)); do
        lay=`awk -v layi=$layi 'BEGIN{printf("%2.1f",layi*0.1);}'` 
        dir=$dir1/$ion/$lay
        if [ ! -d "./$dir" ];then
            mkdir -p ./$dir
            cp -r oplsaaGO.ff ./$dir
            if [ $poolsimulation -eq 1 ]; then
                dir2=${ion}_pool ; grofile=GO_pool_${lay}.gro ; topfile=GO_pool_${lay}.top
            else
                dir2=${ion} ; grofile=GO_${lay}.gro ; topfile=GO_${lay}.top
            fi
            cp ./receive/$dir2/$lay/$grofile ./$dir/GO2-ion.gro
            cp ./receive/$dir2/$lay/$topfile ./$dir/GO2.top
            cd ./$dir
            gmx make_ndx -f GO2-ion.gro -o waterlayer.ndx < $odir/receive/$dir2/$lay/ndx.sh
            git clone https://github.com/zhanggehui/Gmx_GO_ubuntu.git
            mv Gmx_GO_ubuntu scripts
            cp -rf $odir/md_scripts/.git/config ./scripts/.git/config
            source ./scripts/auto-run.sh $runscript em
            cd $odir
        else
            echo 'already exist!'
        fi
    done
done
