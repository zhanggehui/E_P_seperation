cd ../
cd 2.5nm
for ((i=0; i<20; i++)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%g",100*i);}'` 
    for ((j=0; j<17; j++)); do 
        voltage=`awk -v j=$j 'BEGIN{printf("%g",0.1*j);}'`
        if [ $i -eq 0 ] || [ ${j} -eq 0 ]; then
            echo "-------------------------- ${pressure}Mpa-${voltage}V --------------------------"
            cd ./${pressure}Mpa-${voltage}V
            source $scriptsdir/residence_time.sh
            cd ../
        fi
    done
done
cd ../
