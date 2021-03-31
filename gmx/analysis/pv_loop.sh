# 不同条件下的轨迹
ionname=''
#charge=26
#trajdir=charge_${charge}_traj
# negative=n5
# trajdir=negative_${negative}_traj
# spacing=2
# trajdir=lay_${spacing}_traj
# rm -rf ../charge_${charge}_traj

# 不同离子的轨迹
# ionname=MG
# trajdir=${ionname}_traj

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
