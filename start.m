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
disp(['Add the paths of the different toolboxes'])
if ~exist('Run_dir','var')
    Run_dir = fileparts(mfilename('fullpath'));
end
mypath   = [Run_dir,'/'];%[pwd,'/'];
OS_Linux = 0;
%
% Other software directories
%
if OS_Linux
    start_linux
else
    start_windows
end
