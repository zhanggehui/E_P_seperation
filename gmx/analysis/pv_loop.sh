cd ../
cd lay_2.5
for ((i=0;i<20;i++)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'` 
    for ((i=1;i<17;i++)); do 
        voltage=`awk -v i=$i 'BEGIN{printf("%s",0.1*i);}'`
        if [ ${pressure} -eq 0 ] || [ ${voltage} -eq 0 ]; then
            source $scriptsdir/.sh
        fi
    done
done
cd ../
