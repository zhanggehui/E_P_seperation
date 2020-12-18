source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

odir=`pwd`
ions=("CS" "LI" "NA" "K" "CA" "MG")
for((ioni=2;ioni<3;ioni++)); do
    ion=${ions[${ioni}]}
    for((layi=7;layi<=13;layi++)); do
        lay=`awk -v layi=$layi 'BEGIN{printf("%2.1f",layi*0.1);}'` 
        dir=lay_spacing/$ion/$lay
        if [ ! -d "./$dir" ];then
            mkdir -p ./$dir
            cp -r oplsaaGO.ff ./$dir
            cp ./receive/$ion/$lay/GO_${lay}.gro ./$dir/GO2-ion.gro
            cp ./receive/$ion/$lay/GO_${lay}.top ./$dir/GO2.top
            cd ./$dir
            gmx make_ndx -f GO2-ion.gro -o waterlayer.ndx < $odir/receive/$ion/$lay/ndx.sh
            git clone https://github.com/zhanggehui/Gmx_GO_ubuntu.git
            mv Gmx_GO_ubuntu scripts
            cp -rf $odir/md_scripts/.git/config ./scripts/.git/config
            source ./scripts/auto-run.sh em.sh em
            cd $odir
        else
            echo 'already exist!'
        fi
    done
done
