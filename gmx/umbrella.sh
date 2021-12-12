# source /home/liufeng_pkuhpc/software/gmx_zgh.sh
source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
gmx='gmx'

mkdir ./conf
cd ./conf
echo 0 | $gmx trjconv -s ../nvt-pull.tpr -f ../nvt-pull.trr -o conf.gro -sep -n ../../waterlayer.ndx # -dt 5
cd ../


source deactivate
source /home/liufeng_pkuhpc/lustre2/anaconda3/bin/activate base

# conda activate base

python /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/umbrella-script/setupUmbrella.py \
nvt-pull_pullx.xvg 0.1 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/umbrella-script/nvt-sampling.sh > summary.data
python --version

# conda deactivate

for udir in `ls | grep umbrella`; do 
    XXX=${udir##*-}        # ./umbrella-frame-$XXX
    cd $udir
    if [ !-e  ]; then 
        cp ../conf/conf$XXX.gro ./
    fi
    source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh gmx cn_nl 4 . sampling.sh run
    cd ../
done

rm -rf ./conf
