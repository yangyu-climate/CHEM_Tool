function [x,y,data]=degrade_field(x,y,data,resolution,unit)

R=6367442.76;
deg2rad=pi/180;
dg=mean(x(2:end)-x(1:end-1));
dphi=y(2:end)-y(1:end-1);
dy=abs(R*deg2rad*dphi);
dx=abs(R*deg2rad*dg*cos(deg2rad*y));

if nargin < 4
    error('degrade_field requires x, y, data, and resolution')
elseif nargin < 5
    dx_res = R*deg2rad*resolution;
else
    if strcmp(unit,'km')
        dx_res = resolution*1000;
    else
        error('error unit input')
    end
end

DX(:,1) = dx;
DY(:,1) = dy;
dx_data = mean([DX ;DY]);
clear DX DY
disp(['Data resolution: ',num2str(dx_data/1000,3),' km'])%

%
% Degrade data resolution
%
n=0;
while dx_res>(dx_data)
  n=n+1;
%  
  x=0.5*(x(2:end)+x(1:end-1));
  x=x(1:2:end);
  y=0.5*(y(2:end)+y(1:end-1));
  y=y(1:2:end);
%
  DATA(1,:,:) = data(2:end  ,1:end-1);
  DATA(2,:,:) = data(2:end  ,2:end  );
  DATA(3,:,:) = data(1:end-1,1:end-1);
  DATA(4,:,:) = data(1:end-1,2:end  );

  data=squeeze(nanmean(DATA));
  clear DATA
  
  data=data(1:2:end,1:2:end);
%  
  dg=mean(x(2:end)-x(1:end-1));
  dphi=y(2:end)-y(1:end-1);
  dy=abs(R*deg2rad*dphi);
  dx=abs(R*deg2rad*dg*cos(deg2rad*y));
  DX(:,1) = dx;
  DY(:,1) = dy;
  dx_data = mean([DX ;DY]);
  clear DX DY
end
disp(['Data resolution halved ',num2str(n),' times'])
disp(['New Data resolution : ',num2str(dx_data/1000,3),' km'])





