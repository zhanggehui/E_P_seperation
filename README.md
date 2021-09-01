## GO建模
- 使用在线建模网站 生成newGO.gro, 拉大石墨烯的距离然后再缩小回去, 可以帮助识别键的类型

- 非周期性模型:
  选择 长20 宽20 键长3A 取消周期性 
  -O- -OH 随机上下 内部覆盖率10%
  -COOH 边缘覆盖率4%

- 周期性模型:
  选择 长20 宽20 键长3A 周期性
  -O- -OH 随机上下 内部覆盖率10%

  注意减号的问题！！！！中文减号不识别
  注意网页生成的gro文件的最后一行盒子尺寸的格式问题

  生成拓扑文件, 使用PME计算长程库仑力, 电荷组不用管
  
  ```bash
  gmx editconf -f renameGO.gro -o GO-cubic.gro -bt cubic -d 0.2
  gmx x2top -f renameGO.gro -o n2tGO.top -ff oplsaaGO -name MOL -nopbc
  ```
  
- 改为-name GO会显示在moleculetype处的name位置, 二面参数的问题不清楚但不用管

- 对于网页直接生成的gro文件由于有负的坐标值，会因为pbc的问题而发生变化，因为对于直接生成的gro文件需要使用-nopbc，但我们实际上使用通过editconf修改盒子大小的gro文件，故有无-nopbc均可，但需要有-noparam，否则会打印键长到top文件中





## gmx
1. gmx流程中有文件读写，故使用时不要超过一个节点，除非更改为MPIIO

2. 模拟运行时，有的文件会共同使用，但是里面内容分的参数一样，所以每一个模拟都需要拷贝一个副本，采用的方法是：先修改，再复制副本

3. 停止维护老版本的命令格式，全部使用新版本

   

- 注意：

  一种离子与两种离子在make_ndx命令时初始出现的组分类不同！故在使用make_ndx.sh时要记得修改

  对于有文件修改的模拟，节点数只能用1



- 先进行em和nvt弛豫

```bash
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx em.sh em

cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 2 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx nvt-equ.sh nvtequ
```

- 批处理提交任务
```bash
# 多个电压或者电场
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/cycle_sub.sh 0 0 0 1.5 cn_nl

# 压强加反向电场
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/cycle_sub.sh 1500 1500 0 1.6 auto

# 单独分析脚本
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/analysis pv_loop.sh CS_traj

# 不同离子的通用接口，仅能用一个节点，因为有大量的文件修改
# em nvtequ analysis nvtpull nvtspring
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/ion_loop.sh analysis auto
```

- 分析离子位移随时间变化，单独使用

```bash
echo "NA" | gmx trjconv -f nvt-production.trr -s nvt-production.tpr -o noskip-1nm-20e-NA-1600Mpa-0V.gro -pbc nojump -b 0 -e 10000 -n waterlayer.ndx
```

- 清理文件

```bash
rm -rf CS/CS_*/ LI/LI_*/ K/K_*/ NA/NA_*/ tmp_data/*
rm -rf */*/angle*
```
- **伞形采样**

```bash
# 牵引制作初始构型
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx auto 2 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx nvt-pull.sh nvtpull

# 采样
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/umbrella.sh

# 检查弹簧位置动画
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/umbrella-script/springs.sh

# wham
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx auto 1 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/gmx/umbrella-script wham.sh wham
```



## 系统状态输出

```bash
echo "potential" | gmx energy -f em.edr -o em-potential.xvg
echo "temperature" | gmx energy -f nvt-equ.edr -o nvt-equ-tem.xvg  # 能量输出被关闭，仅最后一步的能量被记录在文件中
```




## lmp
```bash
# 构建初始体系
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp auto 10 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/lmp build.in build_1.175_400

# 非平衡模拟
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp auto 10 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/lmp NEMD.in NEMD_1.175_400
```



```bash
# 周期性体系脚本
cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/lmp-periodic first.in nvtequ

cd /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/GO_MD/md_scripts/lmp-periodic production.in nvtpro
```

