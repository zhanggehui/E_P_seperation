#在rundir中运行
orientation=y
ncycles=1    
nsteps=5000000
nvtequdir=../nvtequ
pressure=0           #Mpa
dt=0.001             #ps
############################################################
echo "pressure: $pressure" > cyclelog
echo 'stepnum   count   len   lenv1   lenv2   area   acceleration' >> cyclelog

cp ../waterlayer.ndx ./
mdpdir=./mdps ; mkdir -p $mdpdir
ndxdir=./ndxs ; mkdir -p $ndxdir

mdpfile=./nvt-cycle.mdp
ndxfile=./waterlayer.ndx 
topfile=../GO_ion_pp.top

#修改每个循环的总步数（模拟时长）
reset_nsteps="nsteps                   = $nsteps"
sed -i "/nsteps/c${reset_nsteps}" $mdpfile

if [ $pressure -gt 0 ]; then
    key='acc-grps'  ; new='acc-grps                 = waterlayer'
    sed -i "/$key/c$new" $mdpfile
    key='accelerate'; new='accelerate               = 0 0 0'
    sed -i "/$key/c$new" $mdpfile
fi

for ((i=1;i<=$ncycles;i++)); do
    tprname=nvt-step-$i
    if [ $i -eq 1 ]; then
        lastgro=$nvtequdir/nvt-equ.gro ; lastcpt=$nvtequdir/nvt-equ.cpt
    else
        lastgro=./nvt-step-$((i-1)).gro ; lastcpt=./nvt-step-$((i-1)).cpt
    fi
    tinit=`awk -v i=$i -v dt=$dt -v nsteps=$nsteps 'BEGIN{printf("%g",(i-1)*dt*nsteps);}'`
    reset_tinit="tinit                    = $tinit"
    sed -i "/tinit/c${reset_tinit}" $mdpfile

    #重新给水加速度,更新mdp文件,更新ndx文件
    if [ $pressure -gt 0 ]; then
        source $scriptsdir/pressure_on_water.sh
    fi
    echo "######################################### This is the ${i}th grompp  #########################################" >> ./2.err

    #-c必须提供，但只有当cpt文件中没有信息会使用-c的gro文件，即使top没有改变也要提供-p的top文件
    gmx grompp -f $mdpfile -c $lastgro -t $lastcpt -p $topfile -o $tprname.tpr -po $mdpdir/step$i -n $ndxfile #-maxwarn 1 

    echo "########################################## This is the ${i}th run ##########################################" >> ./2.err
    $gmxrun -v -deffnm $tprname -cpi $lastcpt -cpt 120 -noappend
done

#删除多余的输出文件
mv ./nvt-step-$ncycles.gro ./last.gro
mv ./nvt-step-$ncycles.cpt ./last.cpt
mv ./nvt-step-$ncycles.tpr ./traj.tpr
rm -rf ./*.edr
rm -rf ./*.log
if [ $ncycles -gt 1 ]; then
    rm -rf ./nvt-step-*.gro
    rm -rf ./nvt-step-*.cpt
    rm -rf ./nvt-step-*.tpr
    gmx trjcat -f *.trr -o nvt-pro-traj.trr
    rm -rf ./nvt-step-*.trr
else
    mv ./nvt-step-1.trr ./nvt-pro-traj.trr
fi
