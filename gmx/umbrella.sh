source ~/software/gmx_zgh.sh

mkdir conf
cd conf
echo 0 | gmx trjconv -s ../nvt-pull.tpr -f ../nvt-pull.trr -o conf.gro -sep -n ../../waterlayer.ndx
cd ../

conda activate base
python /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/umbrella-script/setupUmbrella.py \
nvt-pull_pullx.xvg 0.1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/umbrella-script/nvt-sampling.sh > summary.data
conda deactivate

for udir in `ls | grep umbrella`; do 
    cd $udir
    source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
    gmx cn_nl 2 . sampling.sh run
    cd ../
done
