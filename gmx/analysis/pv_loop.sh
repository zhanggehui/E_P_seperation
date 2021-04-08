source $scriptsdir/trajectory/traj_func.sh
source $scriptsdir/rdf/rdf_func.sh

ions=("CS" "LI" "NA" "K")
n_ions=${#ions[@]}

cd ../
for ((i=0;i<20;i++)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`
    for ((j=0;j<16;j++)); do 
        voltage=`awk -v j=$j 'BEGIN{printf("%s",0.1*j);}'`
        if [ $i -eq 0 ] || [ $j -eq 0 ]; then
            echo "-------------------------- ${pressure}Mpa-${voltage}V --------------------------"
            cd ./${pressure}Mpa-${voltage}V
                #source $scriptsdir/rdf/rdf.sh
                #source $scriptsdir/residence_time/residence_time.sh
                source $scriptsdir/trajectory/traj.sh
            cd ..
        fi
    done
done
