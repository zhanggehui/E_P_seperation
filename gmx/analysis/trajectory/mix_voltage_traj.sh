trajdir=mix_traj
if [ ! -d $trajdir ] ; then
    mkdir ../$trajdir
    pressure=1500
    cd ./${pressure}Mpa-0V
    for ((i=0;i<17;i++)); do 
        voltage=`awk -v i=$i 'BEGIN{printf("%s",0.1*i);}'`
        cd ./${pressure}Mpa-${voltage}V
        trajname=CS${pressure}Mpa-${voltage}V.gro
        get_traj $trajname $trajdir
        
        trajname=LI${pressure}Mpa-${voltage}V.gro
        get_traj $trajname $trajdir
        cd ..
    done
else
    echo 'already exists!'
fi
