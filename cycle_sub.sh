runscript=$1
scriptsdir='scripts'
orientation='y'
subpressure=0      #1代表压强任务，0代表电压任务
pvmix=0            #1代表压强,电场共同作用，此时电场反向
pressure=0         #共同作用:确定压强,变化电场，  记得改变一下压强

odir=`pwd`
ions=("CS" "LI" "NA" "K" "CA" "MG")
for((ioni=2;ioni<3;ioni++)); do
    ion=${ions[${ioni}]}
    for((layi=7;layi<=13;layi++)); do
        lay=`awk -v layi=$layi 'BEGIN{printf("%2.1f",layi*0.1);}'`
        cd ./lay_spacing/$ion/$lay
        #恢复仓库的初始状态：电场为零，压强为零
        #shut off pressure
        word="pressure=" ; new="pressure=${pressure}          #Mpa"
        sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.sh
        #shut off electric-field-y
        word="electric-field-$orientation" ; new="electric-field-$orientation         = 0 0 0 0"
        sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.mdp
        if [ $runscript == 'nvt-equ.sh' ]; then
            source ./$scriptsdir/auto-run.sh nvt-equ.sh nvtequ
        else
            if [ $subpressure -ne 0 ]; then
                word='pressure='
                for ((i=10;i<11;i++)); do
                    export i 
                    pressure=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",100*i); }'`   
                    new="pressure=${pressure}     #Mpa"
                    sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.sh
                    source ./$scriptsdir/auto-run.sh nvt-cycle.sh ${pressure}Mpa-0V
                done
            else
                word="electric-field-$orientation"
                for ((i=10;i<11;i++)); do
                    export i 
                    if [ $pvmix -ne 0 ]; then
                        e_amplitude=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",-0.1*i); }'`
                    else
                        e_amplitude=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",0.1*i); }'`
                    fi
                    new="electric-field-$orientation         = ${e_amplitude} 0 0 0" 
                    sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.mdp
                    source ./$scriptsdir/auto-run.sh nvt-cycle.sh 0Mpa-${e_amplitude}V
                done
            fi
        fi
        cd $odir
    done
done
