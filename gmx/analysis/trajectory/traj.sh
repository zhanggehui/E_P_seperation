source $scriptsdir/traj_func.sh

# rundir刚好可以与要提取的离子同名
cd ../
for ((i=0;i<20;i++)); do
    pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`
    for ((j=0;j<16;i++)); do 
        voltage=`awk -v j=$j 'BEGIN{printf("%s",0.1*j);}'`
        if [ $i -eq 0 ] || [ $j -eq 0 ]; then
            cd ./${pressure}Mpa-${voltage}V
            trajname=${pressure}Mpa-${voltage}V.gro
            get_traj $rundir $trajname
            mv $trajname ../$rundir
            cd ..
        fi
    done
done
