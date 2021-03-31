# 不同条件下的轨迹
ionname=''
charge=26
trajdir=charge_${charge}_traj
# negative=n5
# trajdir=negative_${negative}_traj
# spacing=2
# trajdir=lay_${spacing}_traj
# rm -rf ../charge_${charge}_traj

# 不同离子的轨迹
# ionname=MG
# trajdir=${ionname}_traj

if [ ! -d $trajdir ] ; then
    mkdir ../$trajdir
    for ((i=0;i<20;i++)); do
        pressure=`awk -v i=$i 'BEGIN{printf("%s",100*i);}'`   
        cd ./${pressure}Mpa-0V
        trajname=${ionname}${pressure}Mpa-0V.gro
        get_traj $trajname $trajdir
        cd ..
    done

    for ((i=1;i<17;i++)); do 
        voltage=`awk -v i=$i 'BEGIN{printf("%s",0.1*i);}'`
        cd ./0Mpa-${voltage}V
        trajname=${ionname}0Mpa-${voltage}V.gro
        get_traj $trajname $trajdir
        cd ..
    done
else
    echo 'already exists!'
fi
