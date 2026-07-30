function creat_wrfchem_emission(fileI,fileO,T_beg,T_end,Time_frq,zdim,VAR_NAME,PM_NAME,VAR_NAMEG,PM_NAMEG,VAR_NAMEF,PM_NAMEF)

DtoH  = 24;
T=T_beg:Time_frq/DtoH:T_end;

DateStrLen = length(ncread(fileI,'Times'));
xdim = size(ncread(fileI,'HGT'),1);
ydim = size(ncread(fileI,'HGT'),2);


% 创建 NetCDF 文件
fileName = fileO;

% 创建排放变量
nccreate(fileName, 'Times',   'Dimensions', {'DateStrLen',DateStrLen,'Time',length(T)}, 'Datatype', 'char');

% 初始化数据并写入文件
for i=1:length(T)
    TIME=T(i);
    [year_num,month_num,day_num,...
     hour_num,minu_num,seco_num] = date2str(TIME);
    T_name  = [year_num,'-',month_num,'-',day_num,'_',...
               hour_num,':',minu_num,':',seco_num];
    ncwrite(fileName, 'Times', T_name',[1,i]);

end

disp(['Empty emission file created: ', fileName]);

NCinfo = ncinfo(fileI);
ATT=NCinfo.Attributes;
for NN=1:length(ATT)
    ATTname =ATT(NN).Name;
    ATTvalue=ATT(NN).Value;
    ncwriteatt(fileName, '/',ATTname,ATTvalue)
end

% 添加属性到 'E_' 变量
if ~isempty(VAR_NAME)
for NN=1:length(VAR_NAME)
Vname = cell2mat(VAR_NAME(NN));
nccreate(  fileName, Vname, 'Dimensions', {'west_east',xdim,'south_north',ydim,'emissions_zdim',zdim,'Time',length(T)},'Datatype','single')
ncwrite(   fileName, Vname, zeros(xdim,ydim,zdim,length(T)) ); 
ncwriteatt(fileName, Vname, 'FieldType', 104);
ncwriteatt(fileName, Vname, 'MemoryOrder','XYZ');
ncwriteatt(fileName, Vname, 'description', 'EMISSIONS');
ncwriteatt(fileName, Vname, 'units', 'mol km^-2 hr^-1');
ncwriteatt(fileName, Vname, 'stagger','');
ncwriteatt(fileName, Vname, 'coordinates','XLONG XLAT');
end
end

if ~isempty(PM_NAME)
for NN=1:length(PM_NAME)
Vname = cell2mat(PM_NAME(NN));
nccreate(  fileName, Vname, 'Dimensions', {'west_east',xdim,'south_north',ydim,'emissions_zdim',zdim,'Time',length(T)},'Datatype','single')
ncwrite(   fileName, Vname, zeros(xdim,ydim,zdim,length(T)) );
ncwriteatt(fileName, Vname, 'FieldType', 104);
ncwriteatt(fileName, Vname, 'MemoryOrder','XYZ');
ncwriteatt(fileName, Vname, 'description', 'EMISSIONS');
ncwriteatt(fileName, Vname, 'units', 'ug/m3 m/s');
ncwriteatt(fileName, Vname, 'stagger','');
ncwriteatt(fileName, Vname, 'coordinates','XLONG XLAT');
end
end

if ~isempty(VAR_NAMEG)
for NN=1:length(VAR_NAMEG)
Vname = cell2mat(VAR_NAMEG(NN));
nccreate(  fileName, Vname, 'Dimensions', {'west_east',xdim,'south_north',ydim,'emissions_zdim',zdim,'Time',length(T)},'Datatype','single')
ncwrite(   fileName, Vname, zeros(xdim,ydim,zdim,length(T)) ); 
ncwriteatt(fileName, Vname, 'FieldType', 104);
ncwriteatt(fileName, Vname, 'MemoryOrder','XYZ');
ncwriteatt(fileName, Vname, 'description', 'EMISSIONS');
ncwriteatt(fileName, Vname, 'units', 'mol km^-2 hr^-1');
ncwriteatt(fileName, Vname, 'stagger','');
ncwriteatt(fileName, Vname, 'coordinates','XLONG XLAT');
end
end

if ~isempty(PM_NAMEG)
for NN=1:length(PM_NAMEG)
Vname = cell2mat(PM_NAMEG(NN));
nccreate(  fileName, Vname, 'Dimensions', {'west_east',xdim,'south_north',ydim,'emissions_zdim',zdim,'Time',length(T)},'Datatype','single')
ncwrite(   fileName, Vname, zeros(xdim,ydim,zdim,length(T)) );
ncwriteatt(fileName, Vname, 'FieldType', 104);
ncwriteatt(fileName, Vname, 'MemoryOrder','XYZ');
ncwriteatt(fileName, Vname, 'description', 'EMISSIONS');
ncwriteatt(fileName, Vname, 'units', 'ug/m3 m/s');
ncwriteatt(fileName, Vname, 'stagger','');
ncwriteatt(fileName, Vname, 'coordinates','XLONG XLAT');
end
end

if ~isempty(VAR_NAMEF)
for NN=1:length(VAR_NAMEF)
Vname = cell2mat(VAR_NAMEF(NN));
nccreate(  fileName, Vname, 'Dimensions', {'west_east',xdim,'south_north',ydim,'emissions_zdim',zdim,'Time',length(T)},'Datatype','single')
ncwrite(   fileName, Vname, zeros(xdim,ydim,zdim,length(T)) );
ncwriteatt(fileName, Vname, 'FieldType', 104);
ncwriteatt(fileName, Vname, 'MemoryOrder','XYZ');
ncwriteatt(fileName, Vname, 'description', 'EMISSIONS');
ncwriteatt(fileName, Vname, 'units', 'mol km^-2 hr^-1');
ncwriteatt(fileName, Vname, 'stagger','');
ncwriteatt(fileName, Vname, 'coordinates','XLONG XLAT');
end
end

if ~isempty(PM_NAMEF)
for NN=1:length(PM_NAMEF)
Vname = cell2mat(PM_NAMEF(NN));
nccreate(  fileName, Vname, 'Dimensions', {'west_east',xdim,'south_north',ydim,'emissions_zdim',zdim,'Time',length(T)},'Datatype','single')
ncwrite(   fileName, Vname, zeros(xdim,ydim,zdim,length(T)) );
ncwriteatt(fileName, Vname, 'FieldType', 104);
ncwriteatt(fileName, Vname, 'MemoryOrder','XYZ');
ncwriteatt(fileName, Vname, 'description', 'EMISSIONS');
ncwriteatt(fileName, Vname, 'units', 'ug/m3 m/s');
ncwriteatt(fileName, Vname, 'stagger','');
ncwriteatt(fileName, Vname, 'coordinates','XLONG XLAT');
end
end

