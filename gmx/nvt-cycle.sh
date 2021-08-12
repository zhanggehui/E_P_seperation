orientation=y
ncycles=1    
nsteps=10000000
nvtequdir=../nvtequ
pressure=0           # Mpa
dt=0.0001             # ps
acc_water=all

# --------------------------------------------------------------------- #
echo "pressure: $pressure" > cyclelog
echo 'stepnum   count   len   lenv1   lenv2   area   acceleration' >> cyclelog

cp ../waterlayer.ndx ./waterlayer.ndx
mdpdir=./mdps ; mkdir -p $mdpdir
ndxdir=./ndxs ; mkdir -p $ndxdir

mdpfile=./nvt-cycle.mdp   # ./nvt-spring.mdp
ndxfile=./waterlayer.ndx
topfile=../GO_ion_pp.top

if [ $pressure -gt 0 ]; then
    key='acc-grps'  ; new='acc-grps                 = waterlayer'
    sed -i "/$key/c$new" $mdpfile
    key='accelerate'; new='accelerate               = 0 0 0'
    sed -i "/$key/c$new" $mdpfile
fi

# 修改每个循环的总步数（模拟时长）
break_flag=0
if [ $pressure -eq 0 ] || [ $acc_water == 'all' ]; then
    nsteps=`awk -v ncycles=$ncycles -v nsteps=$nsteps 'BEGIN{printf("%s", nsteps*ncycles);}'`
    break_flag=1
fi
reset_nsteps="nsteps                   = $nsteps"
sed -i "/nsteps/c${reset_nsteps}" $mdpfile

tprname=nvt-production
for ((i=1; i<=$ncycles; i++)); do
    if [ $i -eq 1 ]; then
        lastgro=$nvtequdir/nvt-equ.gro ; lastcpt=$nvtequdir/nvt-equ.cpt
    else
        lastgro=./nvt-production.gro ; lastcpt=./nvt-production.cpt
    fi

    tinit=`awk -v i=$i -v dt=$dt -v nsteps=$nsteps 'BEGIN{printf("%g", (i-1)*dt*nsteps);}'`
    reset_tinit="tinit                    = $tinit"
    sed -i "/tinit/c${reset_tinit}" $mdpfile

    # 重新给水加速度,更新mdp文件，更新ndx文件
    if [ $pressure -gt 0 ]; then
        source $scriptsdir/pressure_on_water.sh
    fi
    echo "######################################### This is the ${i}th grompp  #########################################" >> ./2.err

    # -c必须提供，但只有当cpt文件中没有信息会使用-c的gro文件，即使top没有改变也要提供-p的top文件
    gmx grompp -f $mdpfile -c $lastgro -t $lastcpt -p $topfile -o $tprname.tpr -po $mdpdir/step$i -n $ndxfile # -maxwarn 1 

    echo "########################################## This is the ${i}th run ##########################################" >> ./2.err
    if [ $i -eq 1 ]; then
        $gmxrun -v -deffnm $tprname
        if [ $break_flag -eq 1 ]; then
            break
        fi
    else
        # 分开输出到不同文件，以part.XXXX结尾，补0方法awk 'BEGIN{printf("%04d\n",100)}'
        # $gmxrun -v -deffnm $tprname -cpi $lastcpt -cpt 120 -noappend
        
        # 连续输出到一个文件
        $gmxrun -v -deffnm nvt-production -cpi nvt-production.cpt -cpt 120
    fi  
done

# 删除多余的输出文件
rm -rf \#*
# 拼接轨迹，由于可以连续输出，不再需要
# gmx trjcat -f *.trr -o nvt-pro-traj.trr

# 维护之前的文件名接口
# mv ./nvt-production.gro ./last.gro
# mv ./nvt-production.tpr ./traj.tpr
# mv ./nvt-production.trr ./nvt-pro-traj.trr
