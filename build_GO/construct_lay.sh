#此文件用于制作不同层间距的样品

#      0    1    2    3    4   5
ions=("CS" "LI" "NA" "K" "CA" "MG")   #下标从零开始

gracharge=26    #石墨烯表面电荷数
ioncharge=1     #离子的电荷
addnions=5      #添加的离子数
nlays=10        #模拟的周期数
ngrac=1600      #石墨烯最后一个C原子的原子序数
nfung=2080      #氧化基团最后一个原子的原子序数

if [ -f tmp ]; then
  rm -rf tmp
fi
#可以通过改变循环条件控制所需创建的情形
for ((ioni=2;ioni<3;ioni++)); do
  ion=${ions[${ioni}]}
  for ((layi=7;layi<=13;layi++)); do
    lay=`awk -v layi=$layi 'BEGIN{printf("%2.1f",layi*0.1);}'`   #层间距

    #初始样品为GO2-sheet1.gro,将其最后一行改为所需层间距,并且生成GO_sheet.gro
    lastline=`awk 'END{print NR}' GO2-sheet1.gro`
    awk -v lastline=$lastline -v lay=$lay \
    '
    { 
      if (NR < lastline)
      {print $0;}
      else
      {
        leftline=substr($0,1,20);
        printf("%s%10.5f\n",leftline,lay);
      }
    }
    ' GO2-sheet1.gro > GO_sheet.gro

    #复制一个新的top文件用于之后做修改
    cp GO.top GO_sheet.top
    gmx solvate -cp GO_sheet.gro -cs spc216.gro -o GO_sheet_sol.gro -p GO_sheet.top

    #添加完水分子后需要扩大层间距，否则在加入离子时会由于cut-off与尺寸的冲突而失败
    lastline=`awk 'END{print NR}' GO_sheet_sol.gro`
    awk -v lastline=$lastline -v lay=$lay -v nlays=$nlays \
    '
    BEGIN{ lay=lay*nlays; }
    { 
      if (NR < lastline)
      {print $0;}
      else
      {
        leftline=substr($0,1,20);
        printf("%s%10.5f\n",leftline,lay);
      }
    }
    ' GO_sheet_sol.gro > large_GO_sheet_sol.gro

    #对扩大的gro文件进行添加离子
    gmx grompp -f em.mdp -c large_GO_sheet_sol.gro -p GO_sheet.top -o addion.tpr -maxwarn 1
    echo '4' | gmx genion -s addion.tpr -o large_GO_sheet_sol.gro -p GO_sheet.top -rmin 0.2 \
    -pname $ion -nname CL -np $addnions -nn 0  && rm -rf mdout.mdp  #不要加中和,浓度会覆盖添加np,nn的个数

    #mdout.mdp 只有在成功加入离子时才会删除,以便用来检查添加过程中可能出现的问题
    rm -rf GO_sheet.gro GO_sheet_sol.gro addion.tpr 

    if [ ! -f mdout.mdp ]; then
      #删除gro文件里面的CL离子，并且使得电中性(可能没有CL离子,也可能阳离子数目不足中和,最后的结果为按照添加个数或者最多中和个数的阳离子)
      awk -v gracharge=$gracharge -v ioncharge=$ioncharge -v ion=$ion \
      '
      BEGIN{count=0;}
      { 
        if (match($0,ion))
        {
          count=count+1;
          if (count <= gracharge/ioncharge)
          {print $0;}
        }
        else if (match($0,"CL")) {;}
        else { print $0;}
      }
      ' large_GO_sheet_sol.gro > large_GO_sheet_sol_noCL.gro

      #重写gro文件里面的原子数目
      natoms=`awk 'END{print NR;}' large_GO_sheet_sol_noCL.gro`
      natoms=$(($natoms-3))
      awk -v natoms=$natoms \
      '
      {  
        if (NR ==2){printf("%5d\n",natoms);}
        else       {print $0;}
      }
      ' large_GO_sheet_sol_noCL.gro > GO_sh_$lay.gro

      #重写top文件里的原子数目
      nions=`awk -v count=0 -v ion=$ion '{if(match($0,ion)){count=count+1;}} END{print count;}' GO_sh_$lay.gro`
      awk -v nions=$nions -v nlays=$nlays -v ion=$ion \
      '
      { 
        if (match($0,ion))       {printf("%s              %d\n",ion,nions);}
        else if (match($0,"CL")) {;}
        else if (match($0,"SOL")){print $0; SOLline=$0;}
        else                     {print $0;}
      }
      END{
        for (i=1;i<nlays;i++)
        {
          printf("GO                  1\n");
          print SOLline;
          printf("%s              %d\n",ion,nions);
        }
      }
      ' GO_sheet.top > GO_$lay.top

      rm -rf large_GO_sheet_sol_noCL.gro GO_sheet.top large_GO_sheet_sol.gro

      #将gro文件移动后叠加在一起
      accumgro=GO_sh_$lay.gro
      for ((i=1;i<$nlays;i++)); do
        translen=`echo "$lay*$i" | bc`
        gmx editconf -f GO_sh_$lay.gro -o GO_sh$i.gro -translate 0 0 $translen
        gmx solvate -cp $accumgro -cs GO_sh$i.gro -o GO_accum$i.gro
        rm -rf GO_sh$i.gro
        accumgro=GO_accum$i.gro
      done

      targetdir=./$ion/$lay
      if [ ! -d $targetdir ]; then  
        mkdir -p $targetdir
      fi
      mv $accumgro $targetdir/GO_$lay.gro
      mv GO_$lay.top $targetdir/GO_$lay.top
      mv GO_sh_$lay.gro $targetdir/GO_sh_$lay.gro
      rm -rf \#* GO_accum*.gro

      #最后生成ndx.sh文件,用于使用make_ndx命令
      awk -v nlays=$nlays -v ngrac=$ngrac -v nfung=$nfung \
      '
      {
        if(NR==2)
        {
          totalnum=substr($0,1,5); totalnum=totalnum+0;
          numperlayer=totalnum/nlays;
        }
      }
      END{
        for(i=0;i<nlays;i++)
        {
          a1=1+numperlayer*i ; a2=ngrac+numperlayer*i ;
          if (i<(nlays-1)) {printf("a %d-%d |",a1,a2);}
          else {printf("a %d-%d\n",a1,a2);}
        }
        printf("name 11 gra\n");

        for(i=0;i<nlays;i++)
        {
          a1=ngrac+1+numperlayer*i ; a2=nfung+numperlayer*i
          if (i<nlays-1) {printf("a %d-%d |",a1,a2);}
          else {printf("a %d-%d\n",a1,a2);}
        }
        printf("name 12 funcgrp\n");
      }
      ' $targetdir/GO_$lay.gro > $targetdir/ndx.sh

#这行不要缩进,影响echo输出格式
echo 'a 1
name 13 waterlayer
del 8
del 8
del 8
q' >> $targetdir/ndx.sh

      #最后做一个检查，以防在叠加石墨烯时被挤掉一部分
      natoms_1=`awk '{if (NR ==2 ){print $0}}' $targetdir/GO_$lay.gro`
      natoms_2=`awk '{if (NR ==2 ){print $0}}' $targetdir/GO_sh_$lay.gro`
      if [ ${natoms_1} -eq  $((${natoms_2}*$nlays)) ]; then 
        echo "ion:$ion in spacing:$lay Very Good!" >> tmp
      else
        echo "ion:$ion in spacing:$lay Something Wrong!" >> tmp
      fi
    else
      rm -rf \#* mdout.mdp large_GO_sheet_sol.gro GO_sheet.top
    fi
  done
done
