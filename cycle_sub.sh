scriptsdir='scripts'
subpressure=1      #1代表压强任务，0代表电压任务
pvmix=0            #1代表压强,电场共同作用，此时电场反向
pressure=0         #共同作用时记得改变一下压强

#恢复仓库的初始状态：电场为零，压强为零
#shut off pressure
word="pressure=" ; new="pressure=${pressure}    #Mpa"
sed -i "/$word/c$new" ./$scriptsdir/cycle-run.sh
#shut off electric-field-y
word='electric-field-y' ; new='electric-field-y         = 0 0 0 0'
sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.mdp

if [ $subpressure -ne 0 ]; then
    word='pressure='
    for ((i=0;i<20;i++)); do
        export i 
        pressure=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",100*i); }'`   
        new="pressure=${pressure}     #Mpa"
        sed -i "/$word/c$new" ./$scriptsdir/cycle-run.sh
        source ./$scriptsdir/auto-run.sh cycle-run.sh ${pressure}Mpa-0V
    done
else
    word="electric-field-y"
    for ((i=1;i<17;i++)); do
        export i 
        if [ $pvmix -ne 0 ]; then
            e_amplitude=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",-0.1*i); }'`
        else
            e_amplitude=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",0.1*i); }'`
        fi
        new="electric-field-y         = ${e_amplitude} 0 0 0" 
        sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.mdp
        source ./$scriptsdir/auto-run.sh cycle-run.sh 0Mpa-${e_amplitude}V
    done
fi