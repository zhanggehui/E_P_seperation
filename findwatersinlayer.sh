#!/bin/bash
oldndxfile="./$rundir/step$i.ndx"  
mv $ndxfile $oldndxfile
awk -v boolpr=1 \
'
{
  if (boolpr==1) 
  {
    print $0;
    if(match($0,/waterlayer/) {boolpr=0;}
  }
}
' $oldndxfile > $ndxfile
mv $oldndxfile $ndxdir

boxlengthline=`sed -n '$p' $lastgro`
awk -v boxlengthline=$boxlengthline -v rundir=$rundir -v orientation=$orientation 
-v pressure=$pressure \ 
'
BEGIN{
      if(orientation==1) {p1=21;pbox1=1;pbox2=11;pbox3=21;}
      else if(orientation==2) {p1=29;pbox1=11;pbox2=1;pbox3=21;}
      else {p1=37;pbox1=21;pbox2=1;pbox3=11;}
      len=substr(boxlengthline,pbox1,10); len=len+0;
      araalen1=substr(boxlengthline,pbox2,10); araalen1=araalen1+0;
      araalen2=substr(boxlengthline,pbox3,10); araalen2=araalen2+0;
      area=araalen1*araalen2;
      coord=0; count=0; vcoord=0; vcount=0; pv=37; acceleration=0;
      thick=100;
      }
/OW/{
      coord=substr($0,p1,8); coord=coord+0;
      if( coord<thick || coord>(len-thick) )
        { count++; serial=substr($0,16,5);
          vcoord=substr($0,pv,8); vcoord=vcoord+0;
          if( vcoord>-100 && vcoord<100)
            { vcount++;
              if(vcount%15!=0) {printf("%5s ", serial) ;}
              else {printf("%5s\n", serial) ;}
            }
        }
      }
END{ acceleration=0.602*pressure*area/(vcount*18);
    print acceleration > rundir"""/tmp" ;
    print (ENVIRON["i"], count, acceleration) >> rundir"""/waternumber" ;
    }
' $lastgro >> $ndxfile
    
echo '' >> $ndxfile
acceleration=$(sed -n '1p' ./$rundir/tmp)
str1=accelerate
if [ $orientation -eq 1 ] ; then
str2="accelerate               = $acceleration 0 0"
elif [ $orientation -eq 2 ] ; then
str2="accelerate               = 0 $acceleration 0"
else
str2="accelerate               = 0 0 $acceleration"
fi
sed -i "/$str1/c$str2" $mdpfile

