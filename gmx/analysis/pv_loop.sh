source $scriptsdir/trajectory/traj_func.sh
source $scriptsdir/rdf/rdf_func.sh
source $scriptsdir/density_profile/density_func.sh

cd ../
for ((i=0;i<20;i++)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`
    for ((j=0;j<16;j++)); do 
        voltage=`awk -v j=$j 'BEGIN{printf("%s",0.1*j);}'`
        if [ $i -eq 0 ] || [ $j -eq 0 ]; then
            if [ -d ${pressure}Mpa-${voltage}V ]; then
                echo "-------------------------- ${pressure}Mpa-${voltage}V --------------------------"
                cd ./${pressure}Mpa-${voltage}V
                    #source $scriptsdir/rdf/rdf.sh
                    #source $scriptsdir/residence_time/residence_time.sh
                    #source $scriptsdir/trajectory/traj_continuous.sh
                    #source $scriptsdir/density_profile/density.sh
                cd ..
            fi
        fi
    done
done

mv ./$rundir ../tmp_data/$rundir
