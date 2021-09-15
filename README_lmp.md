### 层状加压强
```bash
# 构建初始体系
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp auto 10 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp build.in build_1.175_400

# 非平衡模拟
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp auto 10 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp NEMD.in NEMD_1.175_400
```


### 周期性体系脚本
```bash
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-periodic first.in nvtequ

cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-periodic production.in nvtpro
```


### 研究共存离子
```bash
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-coexist first.in nvtequ

cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-coexist production.in nvtpro

cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-coexist/analysis/trajectory/traj_first_last.sh "LI FE"
```
