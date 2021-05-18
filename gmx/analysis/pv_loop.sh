source $scriptsdir/density_profile/density_func.sh
source $scriptsdir/trajectory/traj_func.sh
source $scriptsdir/rdf/rdf_func.sh

cd ../

#正确启动python环境，由于使用了intel编译器的环境，破坏了原有的python环境
source deactivate
source /home/liufeng_pkuhpc/anaconda3/bin/activate base
python --version

ion=${rundir%_*}

for ((i=0; i<20; i=i+1)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`
    for ((j=0; j<16; j=j+1)); do 
        voltage=`awk -v j=$j 'BEGIN{printf("%s",0.1*j);}'`
        if [ $i -eq 0 ] || [ $j -eq 0 ]; then
            if [ -d ${pressure}Mpa-${voltage}V ]; then
                echo "-------------------------- ${pressure}Mpa-${voltage}V --------------------------"
                cd ./${pressure}Mpa-${voltage}V
                    #统计离子位移
                    #source $scriptsdir/trajectory/traj_first_last.sh
                    #source $scriptsdir/trajectory/traj_continuous.sh

                    #统计径向分布函数
                    #source $scriptsdir/rdf/rdf.sh
                    
                    #水合层滞留时间
                    #source $scriptsdir/residence_time/residence_time.sh
                    
                    #速度分布
                    #source $scriptsdir/velocity/velocity_profile.sh

                    #密度分布
                    source $scriptsdir/density_profile/density.sh
                    
                    #水合层角度分布
                    #source $scriptsdir/angle_distribution/theta.sh
                cd ..
            fi
        fi
    done
done

mv ./$rundir ../tmp_data/$rundir
