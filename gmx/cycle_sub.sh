function get_i() {
    awk -v i=$1 -v bin=$2 'BEGIN{printf("%s", i/bin);}'
}

plow=$1; pmax=$2; vlow=$3; vmax=$4
plow_i=`get_i $plow 100`; pmax_i=`get_i $pmax 100`
vlow_i=`get_i $vlow 0.1`; vmax_i=`get_i $vmax 0.1`
if [ $pmax_i -gt 0 ] && [ $vmax_i -gt 0 ]; then
    pvmix=1
else
    pvmix=0
fi

scriptsdir=/home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx
orientation='y'
word='orientation='; new="orientation=${orientation}"
sed -i "/$word/c$new" $scriptsdir/nvt-cycle.sh

for ((i=plow_i; i<=pmax_i; i++)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%s", 10*i);}'`
    word='pressure='; new="pressure=${pressure}"
    sed -i "/$word/c$new" $scriptsdir/nvt-cycle.sh
    for ((j=vlow_i; j<=vmax_i; j++)); do 
        if [ $pvmix -ne 0 ]; then
            e_amplitude=`awk -v i=$j 'BEGIN{printf("%s", -0.05*i);}'`
        else
            e_amplitude=`awk -v i=$j 'BEGIN{printf("%s", 0.1*i);}'`
        fi
        word="electric-field-$orientation"
        new="electric-field-$orientation         = ${e_amplitude} 0 0 0" 
        sed -i "/$word/c$new" $scriptsdir/nvt-cycle.mdp
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh gmx $5 4 \
        /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx nvt-cycle.sh \
        ${pressure}Mpa-${e_amplitude}V-80kJ
        # spring-${pressure}Mpa-${e_amplitude}V
    done
done
