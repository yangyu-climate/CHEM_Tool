function z = zlevs(h,zeta,theta_s,theta_b,hc,N,type,vtransform)

Vtransform = vtransform;
if Vtransform == 1
    Vstretching = 1;
else
    Vstretching = 4;
end

if type=='r'
    igrid = 1;
elseif type=='w'
    igrid = 5;
end

report = 0;


z = set_depth(Vtransform, Vstretching, theta_s, theta_b, hc, N,igrid, h, zeta, report);
z = squeeze(z);