## lmp
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



```bash
# 周期性体系脚本
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-periodic first.in nvtequ

cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-periodic production.in nvtpro
```

```bash
# 研究共存离子
cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-coexist first.in nvtequ

cd /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/ ; gitget ; cd $OLDPWD ; \
source /home/liufeng_pkuhpc/lustre2/zgh/sub_job/auto_run.sh \
lmp cn_nl 8 /home/liufeng_pkuhpc/lustre3/zgh/gmx/gmx_GO/md_scripts/lmp-coexist production.in nvtpro
```
