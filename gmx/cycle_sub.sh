runscript=$1
scriptsdir='scripts'
orientation='y'
subpressure=1            #1代表压强任务, 0代表电压任务
pvmix=0 ; pressure=0     #1代表压强,电场共同作用(确定压强,变化电场,会覆盖subpressure,使subpressure为0),此时电场反向,记得改变一下压强; pvmix0时pressure会变为0
odir=`pwd`
ions=("CS" "LI" "NA" "K" "CA" "MG")

if [ $pvmix -ne 0 ]; then
    subpressure=0
    if [ $pressure -eq 0 ] && [ $runscript == 'nvt-cycle.sh' ]; then
        echo 'Please confirm the pressure value!'
    fi
else
    pressure=0
fi
for((ioni=2;ioni<3;ioni++)); do
    ion=${ions[${ioni}]}
    for((layi=7;layi<=13;layi++)); do
        lay=`awk -v layi=$layi 'BEGIN{printf("%2.1f",layi*0.1);}'`
        cd ./lay_spacing/$ion/$lay
        #首先更新该文件夹的仓库
        cd ./$scriptsdir && gitget && cd ..
        if [ $runscript == 'nvt-equ.sh' ]; then
            source ./$scriptsdir/auto-run.sh nvt-equ.sh nvtequ
        else
            #建立初始状态：在压强电压耦合输运时,压强可以不为零,用于模拟压强电场耦合
            #pressure
            word="pressure=" ; new="pressure=${pressure}          #Mpa"
            sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.sh
            #electric-field always zero
            word="electric-field-$orientation" ; new="electric-field-$orientation         = 0 0 0 0"
            sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.mdp
            if [ $subpressure -ne 0 ]; then
                word='pressure='
                for ((i=10;i<11;i++)); do
                    pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`   
                    new="pressure=${pressure}     #Mpa"
                    sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.sh
                    #rm -rf ${pressure}Mpa-0V
                    source ./$scriptsdir/auto-run.sh nvt-cycle.sh ${pressure}Mpa-0V
                done
            else
                word="electric-field-$orientation"
                for ((i=10;i<11;i++)); do 
                    if [ $pvmix -ne 0 ]; then
                        e_amplitude=`awk -v i=$i 'BEGIN{printf("%s",-0.1*i);}'`
                    else
                        e_amplitude=`awk -v i=$i 'BEGIN{printf("%s",0.1*i);}'`
                    fi
                    new="electric-field-$orientation         = ${e_amplitude} 0 0 0" 
                    sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.mdp
                    #rm -rf ${pressure}Mpa-${e_amplitude}V
                    source ./$scriptsdir/auto-run.sh nvt-cycle.sh ${pressure}Mpa-${e_amplitude}V
                done
            fi
        fi
        cd $odir
    done
done
