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
    fileG = [GLBE_dir,'/wrfchemi_d',DN_num];
    glbN  = {};
    if IF_Merge && exist(fileG,'file')
        info  = ncinfo(fileG);
        glbN  = {info.Variables.Name};
    elseif IF_Merge
        warning(['Global emission file not found: ',fileG])
    end
    if exist(fileI,'file')&&exist(fileO,'file')
        lon = double(ncread(fileI,'XLONG'));
        lat = double(ncread(fileI,'XLAT'));
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
            if ~isempty(fileA)
                if length(fileA)>1
                    error(['Multiple surface emission files matched for ',D_name])
                end
                disp(['Surface Emission'])
                fileN = [Chem_dir,'/' ,fileA.name];
                X     = double(ncread(Chem_grd,'XLONG_C'));
                Y     = double(ncread(Chem_grd,'XLAT_C'));
                %----------------------------------------------------------
                % gas phase
                %----------------------------------------------------------
                if ~isempty(CHEM_Oname)
                  for NN=1:length(CHEM_Oname)
                    varI = cell2mat(CHEM_Iname(NN));
                    varO = cell2mat(CHEM_Oname(NN));
                    disp(varO)
                    R_IO = C_unitCV;
                    var  = double(ncread(fileN,varI));
                    var  = squeeze(var(:,:,RCnum))*R_IO;
                    if IFSmooth==1
                    [xxx,yyy,var] = degrade_field_input(X,Y,var,...
                                                  mean([X_gridR;Y_gridR]),...
                                                  mean([WRF_dx(DN);WRF_dy(DN)]),'m');
                    else
                    xxx = X;
                    yyy = Y;
		    end
                    var  = griddata(xxx,yyy,var,lon,lat);
                    locN = find(isnan(var)|var==0);
                    if ismember(varO,glbN)
                    glbV = double(ncread(fileG,varO));
                    glbV = squeeze(glbV(:,:,RCnum));
                    var(locN)=glbV(locN);
                    else
                    glbV = 0*ones(size(var));
                    var(locN)=glbV(locN);
                    end
                    if IFSmooth==1 && ~isempty(locN)
                    maskI = ones(size(var));
                    maskI(locN) = 0;
                    for SMN=1:SmoothN
                    maskI = running_mean_2D(maskI,3);
                    maskO = 1-maskI;
                    end
                    var = var.*maskI + glbV.*maskO;
                    end
                    nc = netcdf(fileO,'write');
                    nc{varO}(num,1,:,:) = var';
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
                    for Gnum=1:length(G_IO)
                      varI = cell2mat(G_IO(Gnum));
                      varG = double(ncread(fileN,varI));
                      if Gnum>1
                      var = squeeze(varG(:,:,RCnum))*R_IO*F_IO(Gnum) + var;
                      else
                      var = squeeze(varG(:,:,RCnum))*R_IO*F_IO(Gnum);
                      end
                    end
                    clear varG
                    if IFSmooth==1
                    [xxx,yyy,var] = degrade_field_input(X,Y,var,...
                                                  mean([X_gridR;Y_gridR]),...
                                                  mean([WRF_dx(DN);WRF_dy(DN)]),'m');
                    else
                    xxx = X;
                    yyy = Y;
		    end
                    var  = griddata(xxx,yyy,var,lon,lat);
                    locN = find(isnan(var)|var==0);
                    if ismember(varO,glbN)
                    glbV = double(ncread(fileG,varO));
                    glbV = squeeze(glbV(:,:,RCnum));
                    var(locN)=glbV(locN);
                    else
                    glbV = 0*ones(size(var));
                    var(locN)=glbV(locN);
                    end
                    if IFSmooth==1 && ~isempty(locN)
                    maskI = ones(size(var));
                    maskI(locN) = 0;
                    for SMN=1:SmoothN
                    maskI = running_mean_2D(maskI,3);
                    maskO = 1-maskI;
                    end
                    var = var.*maskI + glbV.*maskO;
                    end
                    nc = netcdf(fileO,'write');
                    nc{varO}(num,1,:,:) = var';
                    close(nc)
                  end
                end
		if ~isempty(CHEM_OnameF)
                  for NN=1:length(CHEM_OnameF)
                    varO = cell2mat(CHEM_OnameF(NN));
                    disp(varO)
                    if ismember(varO,glbN)
                    glbV = double(ncread(fileG,varO));
                    glbV = squeeze(glbV(:,:,RCnum));
                    var  = glbV;
                    else
                    var  = 0*ones(size(lon.*lat));
                    end
                    nc = netcdf(fileO,'write');
                    nc{varO}(num,1,:,:) = var';
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
                    var  = double(ncread(fileN,varI));
                    var  = squeeze(var(:,:,RCnum))*R_IO;
                    if IFSmooth==1
                    [xxx,yyy,var] = degrade_field_input(X,Y,var,...
                                                  mean([X_gridR;Y_gridR]),...
                                                  mean([WRF_dx(DN);WRF_dy(DN)]),'m');
                    else
                    xxx = X;
                    yyy = Y;
		    end
                    var  = griddata(xxx,yyy,var,lon,lat);
                    locN = find(isnan(var)|var==0);
                    if ismember(varO,glbN)
                    glbV = double(ncread(fileG,varO));
                    glbV = squeeze(glbV(:,:,RCnum));
                    var(locN)=glbV(locN);
                    else
                    glbV = 0*ones(size(var));
                    var(locN)=glbV(locN);
                    end
                    if IFSmooth==1 && ~isempty(locN)
                    maskI = ones(size(var));
                    maskI(locN) = 0;
                    for SMN=1:SmoothN
                    maskI = running_mean_2D(maskI,3);
                    maskO = 1-maskI;
                    end
                    var = var.*maskI + glbV.*maskO;
                    end
                    nc = netcdf(fileO,'write');
                    nc{varO}(num,1,:,:) = var';
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
                    for Gnum=1:length(G_IO)
                      varI = cell2mat(G_IO(Gnum));
                      varG = double(ncread(fileN,varI));
                      if Gnum>1
                      var = squeeze(varG(:,:,RCnum))*R_IO*F_IO(Gnum) + var;
                      else
                      var = squeeze(varG(:,:,RCnum))*R_IO*F_IO(Gnum);
                      end
                    end
                    clear varG
                    if IFSmooth==1
                    [xxx,yyy,var] = degrade_field_input(X,Y,var,...
                                                  mean([X_gridR;Y_gridR]),...
                                                  mean([WRF_dx(DN);WRF_dy(DN)]),'m');
                    else
                    xxx = X;
                    yyy = Y;
		    end
                    var  = griddata(xxx,yyy,var,lon,lat);
                    locN = find(isnan(var)|var==0);
                    if ismember(varO,glbN)
                    glbV = double(ncread(fileG,varO));
                    glbV = squeeze(glbV(:,:,RCnum));
                    var(locN)=glbV(locN);
                    else
                    glbV = 0*ones(size(var));
                    var(locN)=glbV(locN);
                    end
                    if IFSmooth==1 && ~isempty(locN)
                    maskI = ones(size(var));
                    maskI(locN) = 0;
                    for SMN=1:SmoothN
                    maskI = running_mean_2D(maskI,3);
                    maskO = 1-maskI;
                    end
                    var = var.*maskI + glbV.*maskO;
                    end
                    nc = netcdf(fileO,'write');
                    nc{varO}(num,1,:,:) = var';
                    close(nc)
                  end
                end
		if ~isempty(PM_OnameF)
                  for NN=1:length(PM_OnameF)
                    varO = cell2mat(PM_OnameF(NN));
                    disp(varO)
                    if ismember(varO,glbN)
                    glbV = double(ncread(fileG,varO));
                    glbV = squeeze(glbV(:,:,RCnum));
                    var  = glbV;
                    else
                    var  = 0*ones(size(lon.*lat));
                    end
                    nc = netcdf(fileO,'write');
                    nc{varO}(num,1,:,:) = var';
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
