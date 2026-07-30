%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Add the paths of the different toolboxes
%
%  Copyright (c) 2026 Yang Yu
%  e-mail: yang.yu@whoi.edu
%
%  Updated    Jul-2026 by Yang Yu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Other software directories
%
addpath([mypath,'m_map'])
addpath([mypath,'Tool_box'])
addpath([mypath,'Tool_box/taylordiagram'])
addpath([mypath,'coastline'])
addpath([mypath,'ncl_color'])
addpath([mypath,'ncl_color/ncl_rgb'])
%
%-------------------------------------------------------
%
% Get the path to the mexcdf (it depends on the architecture)
% Comment  all these lines if you don't want to pass in these tests
!uname -m > .mysystem
fid=fopen('.mysystem');
mysystem=fscanf(fid,'%s');

if ( strcmp(mysystem(end-1:end),'86') )
 mysystem2='32';
elseif ( strcmp(mysystem(end-1:end),'64') )
 mysystem2='64';
end

fclose(fid); 
matversion=version('-release');
myversion=str2num(matversion(1:2));
!rm -f .mysystem
disp(['Arch : ',mysystem,' - Matlab version : ',matversion])


if ((myversion > 13)    )
  disp(['Use of mexnc and loaddap in ',mysystem2,' bits.'])
  addpath([mypath,'mexcdf/mexnc'])   % 32 and 64 bits version of mexnc 
%
% - If these directories are already in your matlab native path, 
% you can comment these lines
addpath([mypath,'mexcdf/netcdf_toolbox/netcdf'])
addpath([mypath,'mexcdf/netcdf_toolbox/netcdf/ncsource'])
addpath([mypath,'mexcdf/netcdf_toolbox/netcdf/nctype'])
addpath([mypath,'mexcdf/netcdf_toolbox/netcdf/ncutility'])
%
%-------------------------------------------------------
elseif (myversion <= 13)
  disp('Use of mex60 and loaddap in 32 bits.')
  addpath([mypath,'mex60'])         % Older/32 bits version of mexcdf

% - If these directories are already in your matlab native path, 
% you can comment these lines
% - In this case, if problems with subsrefs.m ans subsasign.m,
% it is because there is a conflict with another native subs.m routines in the
% symbolic native toolbox
addpath([mypath,'netcdf_matlab_60'])
addpath([mypath,'netcdf_matlab_60/ncfiles'])
addpath([mypath,'netcdf_matlab_60/nctype'])
addpath([mypath,'netcdf_matlab_60/ncutility'])

else
  disp(['Arch : ',mysystem,...
       ' you should provide the paths of your own loaddap and mexcdf directories'])
end

%-----------------------------------------------------------------
% If your Linux distribution is FEDORA 4, you can try to install
% opendap by uncommenting these lines. Otherwise you have to compile and
% install the libdap and loaddap library and executable on tour computer manually
% and add the specific path
%
%addpath([mypath,'Opendap_tools/FEDORA']) %tested on matlab6 / fedora4
%addpath([mypath,'Opendap_tools/FEDORA_X64']) % 64bits version of loaddap
