#      0    1    2    3   4    5
ions=("CS" "LI" "NA" "K" "CA" "MG")   #下标从零开始
factor=3
nlays=10
concentration=0.1
ngrac=1600
nfung=2080
rotate_falg=0


if [ -f tmp ]; then
  rm -rf tmp
fi
sed '$d' GO.top > GOs.top
echo "GO                  $nlays" >> GOs.top
for ((ioni=2;ioni<3;ioni++)); do
    ion=${ions[${ioni}]}
    for ((layi=7;layi<=7;layi++)); do
        lay=`awk -v layi=$layi 'BEGIN{printf("%2.1f",layi*0.1);}'`
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
        ' GO2-sheet1.gro > GO_sh0.gro
        boxlengthline=`sed -n '$p' GO_sh0.gro`
        cp GOs.top GO${nlays}.top
        gmx editconf -f GO2-sheet1.gro -o GO_sh0.gro -box ${boxlengthline:0:10} \
        `echo "$factor*${boxlengthline:10:10}" | bc` ${boxlengthline:20:10}
        gmx editconf -f GO_sh0.gro -o GO_sh0.gro -noc -box ${boxlengthline:0:10} \
        `echo "$factor*${boxlengthline:10:10}" | bc` `echo "$nlays*${boxlengthline:20:10}" | bc`
        accumgro=GO_sh0.gro
        for((i=1;i<$nlays;i++)); do
            translen=`echo "$lay*$i" | bc`
            gmx editconf -f GO_sh0.gro -o GO_sh$i.gro -translate 0 0 $translen
            gmx solvate -cp $accumgro -cs GO_sh$i.gro -o GO_accum$i.gro
            rm -rf GO_sh$i.gro 
            accumgro=GO_accum$i.gro
        done
        gmx solvate -cp void_box.gro -cs spc216.gro -o sol_box.gro -p GO${nlays}.top -box ${boxlengthline:0:10} \
        `echo "0.5*($factor-1.1)*${boxlengthline:10:10}" | bc` \
        `echo "$nlays*${boxlengthline:20:10}" | bc`
        gmx editconf -f sol_box.gro -o sol_box.gro -box ${boxlengthline:0:10} \
        `echo "$factor*${boxlengthline:10:10}" | bc` \
        `echo "$nlays*${boxlengthline:20:10}" | bc` -noc
        gmx solvate -cp $accumgro -cs sol_box.gro -o GO_pool_sol.gro
        gmx grompp -f em.mdp -c GO_pool_sol.gro -p GO${nlays}.top -o addion.tpr -maxwarn 1 && rm -rf mdout.mdp && \
        echo "ion:$ion in spacing:$lay Very Good!" >> tmp
        if [ ! -f mdout.mdp ]; then
            echo '4' | gmx genion -s addion.tpr -o GO_pool_sol.gro -p GO${nlays}.top -pname $ion -nname CL -conc $concentration
            gmx solvate -cp GO_pool_sol.gro -cs spc216.gro -o GO_pool_ion.gro -p GO${nlays}.top
            targetdir=./${ion}_pool/$lay
            if [ ! -d $targetdir ]; then  
                mkdir -p $targetdir
            fi
            if [ ${rotate_falg} -ne 0 ]; then
                gmx editconf -f GO_pool_ion.gro -o GO_pool_ion.gro -noc -rotate -90 0 0 -box ${boxlengthline:0:10} \
                `echo "$nlays*${boxlengthline:20:10}" | bc` `echo "$factor*${boxlengthline:10:10}" | bc`
                gmx editconf -f GO_pool_ion.gro -o GO_pool_ion.gro -translate 0 0 `echo "$factor*${boxlengthline:10:10}" | bc`
            fi
            gmx grompp -f em.mdp -c GO_pool_ion.gro -p GO${nlays}.top -pp GO${nlays}_pp.top -o addion.tpr -maxwarn 1 && rm -rf mdout.mdp
            mv GO_pool_ion.gro $targetdir/GO_pool_$lay.gro
            mv GO${nlays}.top $targetdir/GO_pool_$lay.top
            mv GO${nlays}_pp.top $targetdir/GO_pool_${lay}_pp.top
            #最后生成ndx.sh文件,用于使用make_ndx命令
            awk -v nlays=$nlays -v ngrac=$ngrac -v nfung=$nfung \
            '
            END{
                for(i=0;i<nlays;i++)
                {
                    a1=1+nfung*i ; a2=ngrac+nfung*i ;
                    if (i<(nlays-1)) {printf("a %d-%d |",a1,a2);}
                    else {printf("a %d-%d\n",a1,a2);}
                }
                printf("name 13 gra\n");

                for(i=0;i<nlays;i++)
                {
                    a1=ngrac+1+nfung*i ; a2=nfung+nfung*i
                    if (i<nlays-1) {printf("a %d-%d |",a1,a2);}
                    else {printf("a %d-%d\n",a1,a2);}
                }
                printf("name 14 funcgrp\n");
                printf("a 1\n");
                printf("name 15 waterlayer\n");
                for(i=0;i<4;i++)
                { 
                    printf("del 9\n");
                }
                printf("q\n");
            }
            ' $targetdir/GO_pool_$lay.gro > $targetdir/ndx.sh         
        else
            echo 'Something wrong!'
            rm -rf mdout.mdp
        fi
        rm -rf \#* addion.tpr GO_sh0.gro sol_box.gro GO_accum*.gro GO_pool_sol.gro
    done
done
rm -rf GOs.top
