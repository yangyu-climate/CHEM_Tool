function plot_2D_vector_C(LON,LAT,DATA_1,DATA_2,DATA_3,color_lim,var_name,coastfile,unit,lon_lim,lat_lim)

dl = 1/4;

ll = min(min(LON)):dl:max(max(LON));
la = min(min(LAT)):dl:max(max(LAT));
[lon_w,lat_w] = meshgrid(ll,la);
DATA_1         = interp2(LON,LAT,DATA_1,lon_w,lat_w);
DATA_2         = interp2(LON,LAT,DATA_2,lon_w,lat_w);

% vector parameters
dquiver_l           = 1;
dquiver_wid         = 1;
dquiver_color       = 'b'; %[.1 .1 .9];
do_unit_quiver      = 0;

u_quiver   = DATA_1;
v_quiver   = DATA_2;
lon_quiver = lon_w;
lat_quiver = lat_w;


%coast color
coast_r = 0.9;
coast_g = 0.9;
coast_b = 0.9;

%figure parameters
plot_loc_x          = 100;
plot_loc_y          = 100;
view_l              = 700;
view_h              = 700;
word_size           =  20;

hFig = figure;
set(hFig, 'Position', [plot_loc_x plot_loc_y view_l view_h]);  
domaxis=[min(lon_lim) max(lon_lim) min(lat_lim) max(lat_lim)];

 m_proj( 'miller',...
        'lon',[domaxis(1) domaxis(2)],...
        'lat',[domaxis(3) domaxis(4)]);
    
mask_quiver = ones(size(DATA_1));

m_pcolor(LON,LAT,DATA_3)      
% m_contour(LON,LAT,DATA_3,'fill','on')      
shading flat
if ~isempty(color_lim)
    caxis([min(color_lim),max(color_lim)])
end
colorbar('fontsize',word_size);

hold on

hold on
if do_unit_quiver
    u_quiver_plot = u_quiver./sqrt( (u_quiver).^2 + (v_quiver).^2 );
    v_quiver_plot = v_quiver./sqrt( (u_quiver).^2 + (v_quiver).^2 ); 
    u_quiver_plot( abs( u_quiver_plot ) > 1 ) = NaN;
    v_quiver_plot( abs( v_quiver_plot ) > 1 ) = NaN;    
    hq = m_quiver(lon_quiver,lat_quiver,dquiver_wid*mask_quiver.*u_quiver_plot,dquiver_wid*mask_quiver.*v_quiver_plot,dquiver_l); 
    set(hq,'color',dquiver_color);
else
    u_quiver_plot = u_quiver;
    v_quiver_plot = v_quiver;
    
    L = size(lon_quiver,1)*size(lon_quiver,2);
    x = reshape(lon_quiver,L,1);
    y = reshape(lat_quiver,L,1);
    u = reshape(u_quiver_plot,L,1);
    v = reshape(v_quiver_plot,L,1);
    
    x = x(find(~isnan(v)));
    y = y(find(~isnan(v)));
    u = u(find(~isnan(v)));
    v = v(find(~isnan(v)));
    
    S_factor  =  60;
    shaftwidth = 1;
    headlength = 5;
    
    lon_mark = 124.2;
    lat_mark = 30.5;
    u_mark   = 20;
    v_mark   = 0;
    
    x(end+1) = lon_mark;
    y(end+1) = lat_mark;
    u(end+1) = u_mark;
    v(end+1) = v_mark;
    
    hpv3        = m_vec(S_factor,x,y,u,v,dquiver_color,'shaftwidth',shaftwidth, 'headlength',headlength);
    [hpv5,htv5] = m_vec(S_factor,lon_mark,lat_mark,1,0,dquiver_color,'shaftwidth',0          , 'headlength',0          ,'key',[num2str(sqrt(u_mark^2+v_mark^2)),' cm s^{-1}']);
    set(htv5,'FontSize',10);
end

if ~isempty(coastfile)           
	m_usercoast(coastfile,'patch',[coast_r coast_g coast_b]);    
else
    m_coast('patch',[coast_r coast_g coast_b],'edgecolor','none');
end

colormap(jet)

if ~isempty(unit)      
    title_name   = [var_name,' (',unit,')'];
else
    title_name   = var_name;
end
picture_name = [var_name,'.jpg'];
                
m_grid('box','fancy',...
	'xtick',[min(lon_lim):2:max(lon_lim)],'ytick',[min(lat_lim):max(lat_lim)],...
	'tickdir','in','fontsize',word_size);

hold off

pic_dir = pwd;

picture=[pic_dir,'/',picture_name];
set(gcf,'color','white','paperpositionmode','auto');
saveas(gcf,picture);
% close(figure);                
                   