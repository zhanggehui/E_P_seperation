#!/bin/bash

oldndxfile="./$rundir/step$((i-1)).ndx"
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

boxlengthline=`sed -n '$p' $lastgro`
awk -v boxlengthline="$boxlengthline" -v rundir=$rundir \
-v orientation=$orientation -v pressure=$pressure -v i=$i \
'
BEGIN{
  if(match(orientation,"x"))      {p1=21;pbox1=1;pbox2=11;pbox3=21;}
  else if(match(orientation,"y")) {p1=29;pbox1=11;pbox2=1;pbox3=21;}
  else                            {p1=37;pbox1=21;pbox2=1;pbox3=11;}
  len=substr(boxlengthline,pbox1,10); len=len+0;
  araalen1=substr(boxlengthline,pbox2,10); araalen1=araalen1+0;
  araalen2=substr(boxlengthline,pbox3,10); araalen2=araalen2+0;
  area=araalen1*araalen2;
  coord=0; count=0; acceleration=0;
  thick=2*len;
}
/OW/{
  coord=substr($0,p1,8); coord=coord+0;
  if( coord<thick || coord>(len-thick) )
  { 
    count++; serial=substr($0,16,5);
    if(count%15!=0) {printf("%5s ",serial);}
    else            {printf("%5s\n",serial);}
  }
}
END{
  acceleration=0.602*pressure*area/(count*18);
  print acceleration > rundir"""/tmp" ;
  print (i, count, len, araalen1, araalen2, area, acceleration) >> rundir"""/cyclelog" ;
}
' $lastgro >> $ndxfile
echo '' >> $ndxfile #最后一行没有换行符会不读

acceleration=`sed -n '1p' ./$rundir/tmp`
if [ $orientation == 'x' ]; then
  accstr="accelerate               = $acceleration 0 0"
elif [ $orientation == 'y' ]; then
  accstr="accelerate               = 0 $acceleration 0"
else
  accstr="accelerate               = 0 0 $acceleration"
fi
sed -i "/accelerate/c$accstr" $mdpfile
rm -rf ./$rundir/tmp
