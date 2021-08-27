oldndxfile=./step$((i-1)).ndx
mv $ndxfile $oldndxfile
awk -v boolpr=1 \
'
{
  if (boolpr==1) 
  {
    print $0;
    if(match($0,"waterlayer")){boolpr=0;}
  }
}
' $oldndxfile > $ndxfile
mv $oldndxfile $ndxdir

# 根据具体情况记得修改acc_water，all/notall
boxlengthline=`sed -n '$p' $lastgro`
awk -v boxlengthline="$boxlengthline" -v i=$i \
-v orientation=$orientation -v pressure=$pressure \
'
BEGIN{
  if(match(orientation, "x"))      
    {p1=21; pbox1=1; pbox2=11; pbox3=21;}
  else if(match(orientation, "y")) 
    {p1=29; pbox1=11; pbox2=1; pbox3=21;}
  else                            
    {p1=37; pbox1=21; pbox2=1; pbox3=11;}
  len=substr(boxlengthline, pbox1, 10); len=len+0;
  araalen1=substr(boxlengthline, pbox2, 10); araalen1=araalen1+0;
  z1=0; 
  z2=substr(boxlengthline, pbox3, 10); z2=z2+0;
  araalen2=z2-z1;
  area=araalen1*araalen2;
  count=0; acceleration=0;
  thick=2*len;
}
/OW/{
  coord=substr($0, p1, 8);   coord=coord+0;     # 运动方向（y）限制
  coord2=substr($0, 37, 8);  coord2=coord2+0;   # z方向限制
  if( coord>(len-thick) && coord<thick+5 )
  { 
    if( coord2>-1 && coord2<11 )
    {
      count++; 
      serial=substr($0,16,5);
      if(count%15!=0) {printf("%5s ",  serial);}
      else            {printf("%5s\n", serial);}
    }
  }
}
END{
  acceleration=0.602*pressure*area/(count*18);
  print acceleration > "./tmp";
  print (i, count, len, araalen1, araalen2, area, acceleration) >> "./cyclelog";
}
' $lastgro >> $ndxfile
echo '' >> $ndxfile   # 最后一行没有换行符好像会不识别

acceleration=`sed -n '1p' ./tmp`
if [ $orientation == 'x' ]; then
  accstr="accelerate               = $acceleration 0 0"
elif [ $orientation == 'y' ]; then
  accstr="accelerate               = 0 $acceleration 0"
else
  accstr="accelerate               = 0 0 $acceleration"
fi
sed -i "/accelerate/c$accstr" $mdpfile
rm -rf ./tmp
