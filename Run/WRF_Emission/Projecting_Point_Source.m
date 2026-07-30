clear
clc
close all

Run_dir = ['../../'];
addpath(Run_dir)
start
warning off
%--------------------------------------------------------------------------

CHEM_parameter

T_beg = datenum(Time_beg);
T_end = datenum(Time_end);
T_frq = Time_frq/24;
T=T_beg:T_frq:T_end;

if subDomN>0
domainMIN = subDomN;
domainMAX = subDomN;
else
domainMIN = 1;
domainMAX = domainN;
end

for DN=domainMIN:domainMAX
    if DN<10
        DN_num=['0',num2str(DN)];
    else
        DN_num=num2str(DN);
    end
    fileI = [Data_dir,'/wrfinput_d',DN_num];
    fileO = [Save_dir,'/emis_d',DN_num,'.nc'];
    if exist(fileI,'file')&&exist(fileO,'file')
        lon = double(ncread(fileI,'XLONG'));
        lat = double(ncread(fileI,'XLAT'));
        lonU= double(ncread(fileI,'XLONG_U'));
        latU= double(ncread(fileI,'XLAT_U'));
        lonV= double(ncread(fileI,'XLONG_V'));
        latV= double(ncread(fileI,'XLAT_V'));
        Z   =(double(ncread(fileI,'PH'))+double(ncread(fileI,'PHB')))/9.8;
        Z0  = squeeze(Z(:,:,1));
        for k=1:emissions_zdim
            X1(:,:,k) = lonU(1:size(lon,1),:);
            X2(:,:,k) = lonU(2:size(lon,1)+1,:);
            Y1(:,:,k) = latV(:,1:size(lat,2));
            Y2(:,:,k) = latV(:,2:size(lat,2)+1);
            Z1(:,:,k) = Z(:,:,k)  -Z0;
            Z2(:,:,k) = Z(:,:,k+1)-Z0;
        end
        clear lonU latU lonV latV Z Z0 
        for num = 1:length(T)
            TIME = T(num);
            [year,month,day,hour,minu,seco] = date2num(TIME);
            RCnum = hour+1;
            if month==1
                MM='jan';
            elseif month==2
                MM='feb';
            elseif month==3
                MM='mar';
            elseif month==4
                MM='apr';
            elseif month==5
                MM='may';
            elseif month==6
                MM='jun';
            elseif month==7
                MM='jul';
            elseif month==8
                MM='aug';
            elseif month==9
                MM='sep';
            elseif month==10
                MM='oct';
            elseif month==11
                MM='nov';
            elseif month==12
                MM='dec';
            end
            [year_num,month_num,day_num,...
             hour_num,minu_num,seco_num] = date2str(TIME);
            T_name = [year_num,'-',month_num,'-',day_num,'_',...
                      hour_num,':',minu_num,':',seco_num];
            D_name = [year_num(3:4),MM,day_num];
            fileA  = dir([Chem_dir,'/area*' ,D_name,'*.nc7']);
            fileP  = dir([Chem_dir,'/point*',D_name,'*.nc7']);
            fileZ  = dir([Chem_dir,'/stack*',D_name,'*.nc7']);
            disp([' '])
            disp(['Date: ',T_name])
            if ~isempty(fileP) || ~isempty(fileZ)
                if isempty(fileP) || isempty(fileZ)
                    error(['Point and stack emission files must both exist for ',D_name])
                elseif length(fileP)>1 || length(fileZ)>1
                    error(['Multiple point or stack emission files matched for ',D_name])
                end
                disp(['Point Emission'])
                fileP = [Chem_dir,'/' ,fileP.name];
                fileZ = [Chem_dir,'/' ,fileZ.name];
                X  = double(ncread(fileZ,'LONGITUDE'));
                Y  = double(ncread(fileZ,'LATITUDE'));
                Z  = double(ncread(fileZ,'STKHT'));
                LOC=[];
                for Vnum=1:length(Z)
                  loc = find(X(Vnum)>X1&X(Vnum)<X2...
                            &Y(Vnum)>Y1&Y(Vnum)<Y2...
                            &Z(Vnum)>Z1&Z(Vnum)<Z2);
                  if ~isempty(loc)
                    LOC(Vnum)=loc(1);
                  else
                    LOC(Vnum)=NaN;
                  end
                end
                %----------------------------------------------------------
                % gas phase
                %----------------------------------------------------------
                if ~isempty(CHEM_Oname)
                  for NN=1:length(CHEM_Oname)
                    varI = cell2mat(CHEM_Iname(NN));
                    varO = cell2mat(CHEM_Oname(NN));
                    disp(varO)
                    R_IO = C_unitCV;
                    var  = ncread(fileO,varO);
                    var  = squeeze(var(:,:,:,num));
                    V    = double(ncread(fileP,varI));
                    V    = squeeze(V(:,:,:,RCnum)).*R_IO;
                    loc  = find(~isnan(V)&~isnan(LOC));
                    var(LOC(loc))=var(LOC(loc))+V(loc);
                    nc = netcdf(fileO,'write');
                    for k=1:emissions_zdim
                    nc{varO}(num,k,:,:) = squeeze(var(:,:,k))';
                    end
                    close(nc)
                  end
                end
                if ~isempty(CHEM_OnameG)
                  for NN=1:length(CHEM_OnameG)
                    varO = cell2mat(CHEM_OnameG(NN));
                    disp(varO)
                    R_IO = C_unitCV;
                    G_IO = CHEM_InameG{NN};
                    F_IO = CHEM_factor{NN};
                    var  = ncread(fileO,varO);
                    var  = squeeze(var(:,:,:,num));
                    for Gnum=1:length(G_IO)
                      varI = cell2mat(G_IO(Gnum));
                      varG = double(ncread(fileP,varI));
                      varG(isnan(varG))=0;
                      if Gnum>1
                      V = squeeze(varG(:,:,:,RCnum)).*R_IO*F_IO(Gnum) + V;
                      else
                      V = squeeze(varG(:,:,:,RCnum)).*R_IO*F_IO(Gnum);
                      end
                    end
                    clear varG
                    loc  = find(~isnan(V)&~isnan(LOC));
                    var(LOC(loc))=var(LOC(loc))+V(loc);
                    nc = netcdf(fileO,'write');
                    for k=1:emissions_zdim
                    nc{varO}(num,k,:,:) = squeeze(var(:,:,k))';
                    end
                    close(nc)
                  end
                end
                %----------------------------------------------------------
                % partical phase
                %----------------------------------------------------------
                if ~isempty(PM_Oname)
                  for NN=1:length(PM_Oname)
                    varI = cell2mat(PM_Iname(NN));
                    varO = cell2mat(PM_Oname(NN));
                    disp(varO)
                    R_IO = P_unitCV;
                    var  = ncread(fileO,varO);
                    var  = squeeze(var(:,:,:,num));
                    V    = double(ncread(fileP,varI));
                    V    = squeeze(V(:,:,:,RCnum)).*R_IO;
                    loc  = find(~isnan(V)&~isnan(LOC));
                    var(LOC(loc))=var(LOC(loc))+V(loc);
                    nc = netcdf(fileO,'write');
                    for k=1:emissions_zdim
                    nc{varO}(num,k,:,:) = squeeze(var(:,:,k))';
                    end
                    close(nc)
                  end
                end
                if ~isempty(PM_OnameG)
                  for NN=1:length(PM_OnameG)
                    varO = cell2mat(PM_OnameG(NN));
                    disp(varO)
                    R_IO = P_unitCV;
                    G_IO = PM_InameG{NN};
                    F_IO = PM_factor{NN};
                    var  = ncread(fileO,varO);
                    var  = squeeze(var(:,:,:,num));
                    for Gnum=1:length(G_IO)
                      varI = cell2mat(G_IO(Gnum));
                      varG = double(ncread(fileP,varI));
                      varG(isnan(varG))=0;
                      if Gnum>1
                      V = squeeze(varG(:,:,:,RCnum)).*R_IO*F_IO(Gnum) + V;
                      else
                      V = squeeze(varG(:,:,:,RCnum)).*R_IO*F_IO(Gnum);
                      end
                    end
                    clear varG
                    loc  = find(~isnan(V)&~isnan(LOC));
                    var(LOC(loc))=var(LOC(loc))+V(loc);
                    nc = netcdf(fileO,'write');
                    for k=1:emissions_zdim
                    nc{varO}(num,k,:,:) = squeeze(var(:,:,k))';
                    end
                    close(nc)
                  end
                end
                %----------------------------------------------------------
            end
        end
    else
        error('NO WRFINPUT FILE or EMISSION FILE')
    end
end
