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

if ~exist(Save_dir,'dir')
mkdir(Save_dir)
end

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
    if exist(fileI,'file')
        if exist(fileO,'file')
            delete(fileO)
        end
        creat_wrfchem_emission(fileI,fileO,...
	                       T_beg,T_end,Time_frq,emissions_zdim,...
                               CHEM_Oname,PM_Oname,...
			       CHEM_OnameG,PM_OnameG,...
			       CHEM_OnameF,PM_OnameF)
    else
        error('NO WRFINPUT FILE')
    end
end
