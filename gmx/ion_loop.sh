ions=("LI" "NA" "K" "CS")
n_ions=${#ions[@]}

for ((i=0;i<$n_ions;i++)); do
    ion=${ions[$i]}
    cd $ion
    if [ $1 == 'rdf_pv' ]; then
        cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
        gmx auto 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis pv_loop.sh $ion
    fi
    cd ../
done
