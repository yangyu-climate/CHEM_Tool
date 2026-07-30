function [x,y,data]=degrade_field_input(x,y,data,reso_in,resolution,unit)

R=6367442.76;
deg2rad=pi/180;
dy=reso_in;
dx=reso_in;

if nargin < 5
    error('degrade_field_input requires x, y, data, reso_in, and resolution')
elseif nargin < 6
    dx_res = R*deg2rad*resolution;
else
    if strcmp(unit,'km')
        dx_res = resolution*1000;
    elseif strcmp(unit,'hm')
        dx_res = resolution*100;
    elseif strcmp(unit,'m')
        dx_res = resolution;
    else
        error('error unit input')
    end
end

DX = dx;
DY = dy;
dx_data = mean([DX ;DY]);
clear DX DY
if nargin >= 6 && strcmp(unit,'km')
    disp(['Data resolution: ',num2str(dx_data/1000,3),' km'])%
elseif nargin >= 6 && strcmp(unit,'hm')
    disp(['Data resolution: ',num2str(dx_data/100,3),' hm'])%
elseif nargin >= 6 && strcmp(unit,'m')
    disp(['Data resolution: ',num2str(dx_data,3),' m'])%
end

%
% Degrade data resolution
%
n=0;
while dx_res>(dx_data)
  n=n+1;
%  
  X(1,:,:) = x(2:end  ,1:end-1);
  X(2,:,:) = x(2:end  ,2:end  );
  X(3,:,:) = x(1:end-1,1:end-1);
  X(4,:,:) = x(1:end-1,2:end  );
  x=squeeze(nanmean(X));
  clear X
  x=x(1:2:end,1:2:end);

  Y(1,:,:) = y(2:end  ,1:end-1);
  Y(2,:,:) = y(2:end  ,2:end  );
  Y(3,:,:) = y(1:end-1,1:end-1);
  Y(4,:,:) = y(1:end-1,2:end  );
  y=squeeze(nanmean(Y));
  clear Y
  y=y(1:2:end,1:2:end);

  DATA(1,:,:) = data(2:end  ,1:end-1);
  DATA(2,:,:) = data(2:end  ,2:end  );
  DATA(3,:,:) = data(1:end-1,1:end-1);
  DATA(4,:,:) = data(1:end-1,2:end  );
  data=squeeze(nanmean(DATA));
  clear DATA
  data=data(1:2:end,1:2:end);
%  
  dx = dx*2;
  dy = dy*2;
  DX = dx;
  DY = dy;
  dx_data = mean([DX ;DY]);
  clear DX DY
end

    disp(['Data resolution halved ',num2str(n),' times'])
if nargin >= 6 && strcmp(unit,'km')
    disp(['New Data resolution : ',num2str(dx_data/1000,3),' km'])
elseif nargin >= 6 && strcmp(unit,'hm')
    disp(['New Data resolution : ',num2str(dx_data/100,3),' hm'])
elseif nargin >= 6 && strcmp(unit,'m')
    disp(['New Data resolution : ',num2str(dx_data,3),' m'])
end



