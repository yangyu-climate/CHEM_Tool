function plot_2D(LON,LAT,DATA,var_name,coastfile,unit,con_line,pic_dir)

lon_lim = [117 132];
lat_lim = [ 24 41.3];


%coast color
coast_r = 0.9;
coast_g = 0.9;
coast_b = 0.9;

%figure parameters
plot_loc_x          = 100;
plot_loc_y          = 100;
xtick               =   7;
ytick               =  12;
view_l              = 700;
view_h              = 700;
word_size           =  12;

%make mask data

LON_NW =LON;
LAT_NW =LAT;
var = DATA;
mask = ones(size(DATA));

% hFig = figure(1);
hFig = figure;
set(hFig, 'Position', [plot_loc_x plot_loc_y view_l view_h]);  
domaxis=[min(min(LON_NW)) max(max(LON_NW)) min(min(LAT_NW)) max(max(LAT_NW))];
% domaxis=[117 132 24 41.3];

 m_proj( 'miller',...
        'lon',[domaxis(1) domaxis(2)],...
        'lat',[domaxis(3) domaxis(4)]);
                    
m_pcolor(LON_NW,LAT_NW,mask.*var)   
% m_contourf(LON_NW,LAT_NW,mask.*var,con_line)   
shading flat
if ~isempty(con_line)
    caxis([min(con_line),max(con_line)])
end
colorbar
hold on

% L_C    = find(cyc<0);
% L_AC   = find(cyc>0);
% 
% lon_C  = lon_p(L_C);
% lat_C  = lat_p(L_C);
% L_E_C  = L_E(L_C);
% 
% lon_AC = lon_p(L_AC);
% lat_AC = lat_p(L_AC);
% L_E_AC = L_E(L_AC);
% 
% for i = 1:length(L_C)
%     m_plot(lon_C(i) , lat_C(i) ,'.','Color','b');
%     m_range_ring(lon_C(i),lat_C(i),L_E_C(i),'color','b');
% end
% for i = 1:length(L_AC)
%     m_plot(lon_AC(i) , lat_AC(i) ,'.','Color','r');
%     m_range_ring(lon_AC(i),lat_AC(i),L_E_AC(i),'color','r');
% end
% 
% hold off

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
                
% title([title_name])%,'fontsize',word_size);
% hold off
m_grid('box','fancy',...
	'xtick',[min(lon_lim):6:max(lon_lim)],'ytick',[min(lat_lim):4:max(lat_lim)],...
	'tickdir','in','fontsize',word_size);
if isempty(pic_dir)
    pic_dir = pwd;
end

picture=[pic_dir,'/',picture_name];
set(gcf,'color','white','paperpositionmode','auto');
saveas(gcf,picture);
% close(figure);                
                   