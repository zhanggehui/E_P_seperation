**先进行em和nvt弛豫**

```bash
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 1 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx em.sh em

cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 4 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx nvt-equ.sh nvtequ
```



**批处理提交任务**

```bash
# 多个电压或者电场
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/cycle_sub.sh 0 0 0 1.5 cn_nl

# 压强加反向电场
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/cycle_sub.sh 1500 1500 0 1.6 cn_nl

# 单独分析脚本
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 1 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/analysis pv_loop.sh NA_ay

# 不同离子的通用接口，仅能用一个节点，因为有大量的文件修改
# em nvtequ analysis nvtpull nvtspring
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/ion_loop.sh analysis cn_nl 1
```



**清理文件**

```bash
rm -rf CS/CS_*/ LI/LI_*/ K/K_*/ NA/NA_*/ tmp_data/*
rm -rf */*/angle*
```



**伞形采样**

```bash
# 牵引制作初始构型
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 4 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx nvt-pull.sh nvtpull

# 采样
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/umbrella.sh

# 检查弹簧位置动画
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/umbrella-script/springs.sh

# wham
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/; gitget; cd $OLDPWD; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
gmx cn_nl 1 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/gmx/umbrella-script wham.sh wham
```



