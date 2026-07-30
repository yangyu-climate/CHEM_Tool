Data_dir = ['/home7/yyu12/Clark/application/WRF_CHEM/WRF/Noah_WIR'];
Chem_dir = ['/home7/yyu12/Clark/Data/CHEM_EMIS'];
Save_dir = [pwd,'/Result'];

IF_Merge = 1; % if merge golbal emission data
GLBE_dir = ['../ANTHRO_EMIS'];
IFSmooth = 1;
SmoothN  = 5;

domainN  = 3; % total domain number
subDomN  = 0; % if >0; run individual domain
WRF_dx   = [36000, 12000, 4000];
WRF_dy   = [36000, 12000, 4000];

emissions_zdim = 5;

Time_beg = [2020 6  1 0 0 0];
Time_end = [2020 9 30 0 0 0];
Time_frq = 1; % hour

Chem_grd = [pwd,'/CHEM_grid.nc']; % emission grid
X_gridR  = 4000; % m; emission data X resolution
Y_gridR  = 4000; % m; emission data Y resolution

% unit conversion; gas phase chemistry; % moles/s to mol km^-2 hr^-1
C_unitCV = 1/(X_gridR/1000*Y_gridR/1000)*(60*60);
% unit conversion; particulate matter;  % g/s to ug/m3 m/s
P_unitCV = 1/(X_gridR*Y_gridR)*10^6;

% gas phase group
%-------------------------------------------------------------------
CHEM_Iname = {'CO';'NO';'NO2';'SO2';'NH3';'SULF';...
              'ETOH';'MEK';'BENZENE'};
CHEM_Oname = {'E_CO';'E_NO';'E_NO2';'E_SO2';'E_NH3';'E_sulf';...
              'E_C2H5OH';'E_MEK';'E_BENZENE'};

CHEM_InameG = {};
CHEM_OnameG = {};
CHEM_factor = {};

CHEM_OnameF = {'E_BIGALK';...
               'E_BIGENE';...
               'E_C2H4';...
               'E_C2H6';...
               'E_CH2O';...
               'E_CH3CHO';...
               'E_TOLUENE';...
               'E_C3H6';...
               'E_C3H8';...
               'E_C2H2';...
	       'E_CH3COCH3';...
	       'E_CH3OH';...
	       'E_XYLENE'};

% particle matter group
%-------------------------------------------------------------------
PM_Iname = {'PEC';'POC';'PMC'};
PM_Oname = {'E_BC';'E_OC';'E_PM_10'};

PM_InameG = {{'PFE';'PMN';'PMOTHER'}};
PM_OnameG = {'E_PM_25'};
PM_factor = {[1,1,1]};

PM_OnameF = {};


