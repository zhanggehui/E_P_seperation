source ~/gmx_zgh.sh

mkdir conf
cd conf
echo 0 | gmx trjconv -s ../nvt-pull.tpr -f ../nvt-pull.trr -o conf.gro -sep -n ../../waterlayer.ndx
cd ../

conda activate base
python /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/umbrella-script/setupUmbrella.py \
nvt-pull_pullx.xvg 0.1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/umbrella-script/nvt-sampling.sh > summary.data
