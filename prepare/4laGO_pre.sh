source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
ions=("CS" "LI" "NA" "K" "CA" "MG")
ion=${ions[5]}
if [ ! -d "./$ion" ];then
    mkdir ./$ion
    cp -r oplsaaGO.ff ./$ion
    cp ./receive/GO2-${ion}.gro ./$ion/GO2-ion.gro
    cp ./receive/GO2-${ion}.top ./$ion/GO2.top
    cd ./$ion
    #gmx make_ndx -f GO2-ion.gro -o waterlayer.ndx  < ../md_scripts/final4la_ndxcommands.sh
    gmx make_ndx -f GO2-ion.gro -o waterlayer.ndx  < ../md_scripts/2_final4la_ndxcommands.sh
    git clone https://github.com/zhanggehui/Gmx_GO_scripts.git
    mv Gmx_GO_scripts scripts
    cp ../md_scripts/.git/config ./scripts/.git/config2
    mv -f ./scripts/.git/config2 ./scripts/.git/config
    source ./scripts/auto-run.sh em.sh em
    cd ..
else
   echo 'already exist!'
fi

