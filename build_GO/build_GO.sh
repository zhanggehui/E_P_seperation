#!/bin/bash

# 对网页生成的newGO.gro重新命名
# 该文件的最后一行box的格式不对, 需要作出修改
grofile=newGO.gro

awk \
'
{
  if (NR==1)
  {
    print $0 ;
  }
  else if (NR==2)
  {
    natoms=substr($0,1,5); natoms=natoms+0;
    printf("%5d\n",natoms);
  }
  else if (NR==(natoms+3))
  {
    xpos=$1; xpos=xpos+0;
    ypos=$2; ypos=ypos+0;
    zpos=$3; zpos=zpos+0;
    printf("%10.5f%10.5f%10.5f\n",xpos,ypos,zpos);
  }
  else
  {
    zpos=substr($0,37,8); zpos=zpos+0;
    zpos_abs=sqrt(zpos*zpos);
    # graphene C
    if (zpos_abs==0)      { newname="CGRA"; }
    # carboxy  C O1 O2 H
    else if (zpos_abs==0.156) { newname="CCAR";}
    else if (zpos_abs==0.223) { newname="OCAR1";}
    else if (zpos_abs==0.207) { newname="OCAR2";}
    else if (zpos_abs==0.304) { newname="HCAR";}
    # hydroxyl H O
    else if (zpos_abs==0.176) { newname="HHYD";}
    else if (zpos_abs==0.146) { newname="OHYD";}
    # epoxy
    else if (zpos_abs==0.120) { newname="OEPO";}

    leftline=substr($0,1,10);
    rightline=substr($0,16,length($0)-15);
    printf("%s%5s%s\n",leftline,newname,rightline);
  }
}
' $grofile > renameGO.gro

source rename.sh
gmx editconf -f renameGO.gro -o GO-cubic.gro -bt cubic -d 0.2
gmx x2top -f GO-cubic.gro -o n2tGO.top -ff ../oplsaaGO -name GO -nopbc

rm -rf GO-cubic.gro renameGO.gro \#*

conda activate base
python resize.py
# python rebonded.py 
conda deactivate
