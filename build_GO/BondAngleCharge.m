clc; clearvars;
addpath(fullfile('..','分析脚本','lib'));

grofile='resizeGO.gro';
topfile='n2tGO.top';
atomnum=GetGroAtnum(grofile);
atomcell=cell(atomnum,2);
avecharge=23/1600; %cgranum=1600，确认总电荷为整数即可，但是有4片故负电荷总量很大;
count=0;
grofid = fopen(grofile , 'r');
while feof(grofid) ~=1
    line = fgetl(grofid);
    count=count+1;
    if (count>=3 && count <=atomnum+2)
        index = str2double(line(1,16:20));
        [x,y,z]=getcoordinates ( line );
        atomcell{index,2}=[x,y,z];
    end
end
fclose(grofid);

fid = fopen(topfile , 'r');
fid2 = fopen('GO.itp' , 'w');
count=0; blockname='';
while feof(fid) ~=1
    line = fgetl(fid);
    count=count+1; anno='';
    if contains(line, ';')
        semicolons=strfind(line,';');
        firstsemicolon=semicolons(1,1);
        anno=line(firstsemicolon:length(line));
        if firstsemicolon==1
            line='';
        else
            line=deblank(line(1:firstsemicolon-1));
        end
    end
    if strcmp(strtrim(line),'')
        if length(anno)>=1
            fprintf(fid2,strcat(anno,'\n'));
        else
            fprintf(fid2,'\n');
        end
        continue;
    elseif contains(line, '[')
        blockline=strtrim(line);
        blockname=strtrim(blockline(2:length(blockline)-1));
        if strcmp(blockname,'dihedrals')
            continue;
        else
            fprintf(fid2,strcat(line,'\n'));
            continue;
        end
    end
    if strcmp(blockname,'atoms')
        if contains(line,'CGRA')
            charge=str2double(line(51:56));
            charge=charge-avecharge;
            if charge>=0
                fprintf(fid2,'%s %8.6f%s\n',line(1:50),charge,line(57:length(line)));
            else
                fprintf(fid2,'%s%8.6f%s\n',line(1:50),charge,line(57:length(line)));
            end
        else
            fprintf(fid2,strcat(line,'\n'));
        end   
    elseif strcmp(blockname,'bonds')
        ai=str2double( line(1,1:6) );
        aj=str2double( line(1,7:12) );
        u=atomcell{ai,2}-atomcell{aj,2};
        bondlength=norm(u);
        bondk=400000;
        fprintf(fid2,'%5d %5d   1   %-8.3f %-8.1f\n',ai,aj,bondlength,bondk);
    elseif strcmp(blockname,'angles')
        ai=str2double( line(1,1:5) );
        aj=str2double( line(1,7:11) );
        ak=str2double( line(1,13:17) );
        u=atomcell{ai,2}-atomcell{aj,2};
        v=atomcell{ak,2}-atomcell{aj,2};
        CosTheta = dot(u,v)/(norm(u)*norm(v));
        ThetaInDegrees = acosd(CosTheta);
        anglek=400;
        fprintf(fid2,'%5d %5d %5d   1   %-8.3f %-8.3f\n',ai,aj,ak,ThetaInDegrees,anglek);
    elseif strcmp(blockname,'dihedrals')
        continue;
    else
        fprintf(fid2,[line,'\n']);
        %fprintf(fid2,[line,'   ',anno,'\n']);
    end
end

fclose(fid);
fclose(fid2);
