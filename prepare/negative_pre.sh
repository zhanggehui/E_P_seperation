source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

negative=n5
dir=negative_$negative
if [ ! -d "./$dir" ];then
    mkdir ./$dir
    cp -r oplsaaGO.ff ./$dir
    cp ./receive/GO_${negative}.gro ./$dir/GO2-ion.gro
    cp ./receive/GO_${negative}.top ./$dir/GO2.top
    cd ./$dir
    gmx make_ndx -f GO2-ion.gro -o waterlayer.ndx  < ../md_scripts/ndx_${negative}.sh
    git clone https://github.com/zhanggehui/Gmx_GO_scripts.git
    mv Gmx_GO_scripts scripts
    cp ../md_scripts/.git/config ./scripts/.git/config2
    mv -f ./scripts/.git/config2 ./scripts/.git/config
    source ./scripts/auto-run.sh em.sh em
    cd ..
else
   echo 'already exist!'
fi

