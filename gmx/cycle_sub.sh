function get_i() {
    awk -v i=$1 -v bin=$2 'BEGIN{printf("%g",i/bin);}'
}

plow=$1 ; pmax=$2 ; vlow=$3 ; vmax=$4

plow_i=`get_i $plow 100`
pmax_i=`get_i $pmax 100`
vlow_i=`get_i $vlow 0.1`
vmax_i=`get_i $vmax 0.1`

scriptsdir=/home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx
orientation='y'

if [ $pmax -gt 0 ] && [ $vmax -gt 0 ]; then
    pvmix=1
else
    pvmix=0
fi 

for ((i=plow_i; i<=pmax_i; i++)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`
    word='pressure='
    new="pressure=${pressure}     #Mpa"
    sed -i "/$word/c$new" $scriptsdir/nvt-cycle.sh
    for ((j=vlow_i; j<=vmax_i; j++)); do 
        if [ $pvmix -ne 0 ]; then
            e_amplitude=`awk -v i=$j 'BEGIN{printf("%s",-0.1*i);}'`
        else
            e_amplitude=`awk -v i=$j 'BEGIN{printf("%s",0.1*i);}'`
        fi
        word="electric-field-$orientation"
        new="electric-field-$orientation         = ${e_amplitude} 0 0 0" 
        sed -i "/$word/c$new" $scriptsdir/nvt-cycle.mdp
        # rm -rf ${pressure}Mpa-${e_amplitude}V
        source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
        gmx $5 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx nvt-cycle.sh spring-${pressure}Mpa-${e_amplitude}V
    done
done
