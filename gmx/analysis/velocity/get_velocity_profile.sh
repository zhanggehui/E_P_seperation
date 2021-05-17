awk -v ori_p=$1 -v ori_v=$2 ' 
BEGIN {
	mo=16; mh=1; M=mo+2*mh       # 定义原子质量
	Ntot=10000000                # 定义要计算的帧数
	Zmin=-1; Zmax=5; dZ=0.01     # 定义计算区间, 分格间距
	Nfrm=0; N=int((Zmax-Zmin)/dZ)
	for(i=0; i<=N; i++) { Z[i]=Zmin+i*dZ; V[i]=0; Nwat[i]=0 }

    if(match(ori_p,"x")) {p=21;}
    else if(match(ori_p,"y")) {p=29;}
    else {p=37;}
    if(match(ori_v,"vx")) {pv=45;}
    else if(match(ori_v,"vy")) {pv=53;}
    else {pv=61;}
	print "# ori_p: "p" ; ori_v: "pv 
}

NF==1 { Nfrm++ }
NF>6 && $0~/OW/ {
	         z  = mo*substr($0,p,8); v  = mo*substr($0,pv,8) # O的坐标, 速度
	getline; z += mh*substr($0,p,8); v += mh*substr($0,pv,8) # H1的
	getline; z += mh*substr($0,p,8); v += mh*substr($0,pv,8) # H2的

	z /= M; v /= M    # 质心坐标和速度
	i=int((z-Zmin)/dZ)
	Nwat[i]++; V[i] += v
	if(Nfrm>Ntot) exit
}

END {
	print "# Z: ["Zmin":"Zmax":"dZ"]    Frames: " Nfrm
	for(i=0; i<=N; i++) if(Nwat[i]>0) printf"%f     %f     %d\n", Z[i], V[i]/Nwat[i], Nwat[i]
}
' $3 > $1-$2.xvg
