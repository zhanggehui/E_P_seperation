source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

dir=mix_CS_LI
if [ ! -d "./$dir" ];then
    mkdir ./$dir
    cp -r oplsaaGO.ff ./$dir
    cp ./receive/GO-mix.gro ./$dir/GO2-ion.gro
    cp ./receive/GO-mix.top ./$dir/GO2.top
    cd ./$dir
    gmx make_ndx -f GO2-ion.gro -o waterlayer.ndx  < ../md_scripts/ndx_mix.sh
    git clone https://github.com/zhanggehui/Gmx_GO_scripts.git
    mv Gmx_GO_scripts scripts
    cp ../md_scripts/.git/config ./scripts/.git/config2
    mv -f ./scripts/.git/config2 ./scripts/.git/config
    source ./scripts/auto-run.sh em.sh em
    cd ..
else
    echo 'already exist!'
fi

