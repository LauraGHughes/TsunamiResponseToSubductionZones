% Script to generate all the figures in the paper

%%-----------------------------------------------------------------------%%
% Figure One: Tectonic Setting of New Zealand
% Plate boundary
pac = load('pacific_plate.mat'); lat = pac.pac(:,2); lon = pac.pac(:,1);

load coastlines
load('subduction_zones.mat')

study_area  = [170 170 190 190 170; -45 -25 -25 -45 -45]';

f = figure('visible','off');
%figure
hold on;
plot(lon, lat, 'LineWidth', 1.5, 'Color', 'black'); % Plate boundary
ylim([-48 -25]); xlim([165 190]); yticks([-45 -40 -35 -30 -25]); xticks([165 170 175 180 185 190]); set(gca, 'FontSize',10,'YAxisLocation','right');
text(168,-45,{'South', 'Island'}, 'FontSize', 10, 'FontWeight', 'bold'); text(174.7,-39,{'North', 'Island'}, 'FontSize', 10, 'FontWeight', 'bold');
a = text(178.65,-40.99,'HSM', 'FontSize', 10, 'FontWeight', 'bold'); b = text(183.2,-32.5,'TKSZ', 'FontSize', 10, 'FontWeight', 'bold');
c = text(165,-47,'PSZ', 'FontSize', 10, 'FontWeight', 'bold');
text(168.2,-33,'Australian Plate', 'FontSize', 10, 'FontWeight', 'bold'); text(182,-46,'Pacific Plate', 'FontSize', 10, 'FontWeight', 'bold');

text(174.99,-43.05,'22mm/yr', 'FontSize', 9, 'FontWeight', 'bold'); text(179.22,-42.12,'39mm/yr', 'FontSize', 9, 'FontWeight', 'bold');
text(181.15,-40.1,'47mm/yr', 'FontSize', 9, 'FontWeight', 'bold'); text(181.69,-38.69,'57mm/yr', 'FontSize', 9, 'FontWeight', 'bold');
text(185,-25.5,'90mm/yr', 'FontSize', 9, 'FontWeight', 'bold');

line([178.56,180.53],[-36.8,-38.02], 'Color','black','LineStyle',':', 'LineWidth', 2);

quiver(176.4,-42.5, -1,-0.3,'k','LineWidth',1, 'MaxHeadSize', 2 );quiver(179.1,-41.8, -1,-0.3,'k','LineWidth',1, 'MaxHeadSize', 2 );
quiver(180.9,-39.8, -1,-0.2,'k','LineWidth',1, 'MaxHeadSize', 2 );quiver(182,-38.2, -1,-0.2,'k','LineWidth',1, 'MaxHeadSize', 2 );
quiver(185.5,-25.75, -1,-0.1,'k','LineWidth',1, 'MaxHeadSize', 2 );

scatter(182.07, -29.27, 100, 'square', 'MarkerEdgeColor','white','MarkerFaceColor','black','LineWidth',1)
text(179.5,-28.7,'Raoul Island', 'FontSize', 9, 'FontWeight', 'bold', 'HorizontalAlignment','left');

scatter(173.09, -42.62, 100, 'o', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','#A2142F'); % Kaikoura
scatter(178.80, -38.85, 100, 'o', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','#EDB120'); % tsunami earthquakes

scatter(174.75, -36.9, 75, 'square', 'MarkerEdgeColor','black','LineWidth',1,'MarkerFaceColor','#F1DE23');
t10 = text(174.4, -36.9,'Auckland','Color','black', 'HorizontalAlignment', 'right');
scatter(174.7, -41.3, 75, 'square', 'MarkerEdgeColor','black','LineWidth',1,'MarkerFaceColor','#F1DE23');
t11 = text(174.2, -40.8,'Wellington','Color','black');
scatter(172.4, -43.35, 75, 'square', 'MarkerEdgeColor','black','LineWidth',1,'MarkerFaceColor','#F1DE23');
t12 = text(173, -43.5,'Christchurch','Color','black');
t13 = text(177.4, -38.08,'RP','Color','black');

set(a, 'Rotation', 50); set (b, 'Rotation', 70)

% Inset showing global subudction zones:
axes('Position',[0.02 0.66 0.5 0.35])
ax = worldmap('World');
setm(ax,"Origin",[0 180 0])
p = findobj(ax,'type','patch'); set(p,'FaceColor',[1 1 1]); 
geoshow('landareas.shp','FaceColor','#BCBDC0');
set(findall(ax,'Tag','PLabel'),'visible','off'); set(findall(ax,'Tag','MLabel'),'visible','off');%framem; gridm;
z = plotm(subduction_zones(:,2),subduction_zones(:,1), 'LineWidth',2); set(z, 'Color', '#000000'); hold on;
scatterm(-38.24, -73.05, 200, 'filled', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','#A2142F');
scatterm(3.316, 95.854, 200, 'filled', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','#A2142F');
scatterm(38.322, 142.369, 200, 'filled', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','#A2142F');
z1 = plotm(study_area(:,2),study_area(:,1), 'LineWidth',4); set(z1, 'Color', '#A2142F');
hold off

%pos = get(gcf, 'Position')
set(gcf,'position',[624,348,547,617])

fig = gcf;
exportgraphics(fig, 'NZ_tectonic_setting.png', 'BackgroundColor','white')

%%-----------------------------------------------------------------------%%
% Figure Two: Datasets analysed

pac = load('pacific.mat'); lat = pac.pac(:,1); lon = pac.pac(:,2);
cmap = custom_cmap('whitemagma');

% Creep
creep = csvread('creep_gt8_catalogue.csv', 1,0);
creep_events = zeros(485, 5);
for ii = 1:485
    disp(ii)
    event_x = creep(ii,5); event_y = creep(ii,6); event_z = creep(ii,7)/1000*-1;
    [event_lon, event_lat] = NZTM2Geo(event_x, event_y);
    event_info = [creep(ii,1), event_lon, event_lat, event_z, creep(ii,4)];
    creep_events(ii, [1,2,3,4, 5]) = event_info;
end
creep_events = sortrows(creep_events, 4, 'descend');

% Lock
lock = csvread('lock_gt8_catalogue.csv', 1,0);
lock_events = zeros(445, 5);
for ii = 1:445
    disp(ii)
    event_x = lock(ii,5); event_y = lock(ii,6); event_z = lock(ii,7)/1000*-1;
    [event_lon, event_lat] = NZTM2Geo(event_x, event_y);
    event_info = [lock(ii,1), event_lon, event_lat, event_z, lock(ii,4)];
    lock_events(ii, [1,2,3,4, 5]) = event_info;
end
lock_events = sortrows(lock_events, 4, 'descend');

% plate70
plate70 = csvread('plate70_gt8_catalogue.csv', 1,0);
plate70_events = zeros(844, 5);
for ii = 1:844
    disp(ii)
    event_x = plate70(ii,5); event_y = plate70(ii,6); event_z = plate70(ii,7)/1000*-1;
    [event_lon, event_lat] = NZTM2Geo(event_x, event_y);
    event_info = [plate70(ii,1), event_lon, event_lat, event_z, plate70(ii,4)];
    plate70_events(ii, [1,2,3,4, 5]) = event_info;
end
plate70_events = sortrows(plate70_events, 4, 'descend');


data = importdata('hik_kerm_adjusted_creep.txt'); 
mesh = data.data(:, 1:10); 
xvalue_NZTM = [mesh(:,1)' mesh(:,4)' mesh(:,7)']'; yvalue_NZTM = [mesh(:,2)' mesh(:,5)' mesh(:,8)']';
zvalue_creep  = [mesh(:,3)' mesh(:,6)' mesh(:,9)']'; cvalue_creep  = [mesh(:,10)' mesh(:,10)' mesh(:,10)']';
[xvalue_creep, yvalue_creep] = NZTM2Geo(xvalue_NZTM,yvalue_NZTM);
T_creep = delaunay(xvalue_creep, yvalue_creep); 

data = importdata('hik_kerm_adjusted_lock.txt'); 
mesh = data.data(:, 1:10); 
xvalue_NZTM = [mesh(:,1)' mesh(:,4)' mesh(:,7)']'; yvalue_NZTM = [mesh(:,2)' mesh(:,5)' mesh(:,8)']';
zvalue_lock  = [mesh(:,3)' mesh(:,6)' mesh(:,9)']'; cvalue_lock = [mesh(:,10)' mesh(:,10)' mesh(:,10)'];
[xvalue_lock, yvalue_lock] = NZTM2Geo(xvalue_NZTM,yvalue_NZTM);
T_lock = delaunay(xvalue_lock, yvalue_lock); 

data = importdata('hik_kerm_adjusted_plate70.txt'); 
mesh = data.data(:, 1:10); 
xvalue_NZTM = [mesh(:,1)' mesh(:,4)' mesh(:,7)']'; yvalue_NZTM = [mesh(:,2)' mesh(:,5)' mesh(:,8)']';
zvalue_plate70  = [mesh(:,3)' mesh(:,6)' mesh(:,9)']'; cvalue_plate70  = [mesh(:,10)' mesh(:,10)' mesh(:,10)'];
[xvalue_plate70, yvalue_plate70] = NZTM2Geo(xvalue_NZTM,yvalue_NZTM);
T_plate70 = delaunay(xvalue_plate70, yvalue_plate70); 

f = figure('visible','off');
%figure
tlo = tiledlayout(5,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1, [2,1]); 
trimesh(T_creep,xvalue_creep,yvalue_creep,zvalue_creep, cvalue_creep); shading flat; view([0.9, 90]); grid off; hold on;
ylim([-45 -23]); xlim([171 187]); set(gca, 'FontSize',10);
caxis([0 70]); colormap(ax1, cmap);
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]);
text(169,-23,'A', 'FontSize', 15, 'FontWeight', 'bold');set(gca,'Layer','top'); box on;
title('Trench_{Creep}'); hold off;

ax2 =  nexttile(2, [2,1]); 
trimesh(T_lock,xvalue_lock,yvalue_lock,zvalue_lock, cvalue_lock); shading flat; view([0.9, 90]);grid off;hold on;
ylim([-45 -23]); xlim([171 187]); set(gca, 'FontSize',10);
caxis([0 70]); colormap(ax2, cmap);
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]);set(gca,'Layer','top'); box on;
text(169,-23,'B', 'FontSize', 15, 'FontWeight', 'bold');
title('Trench_{Lock}'); hold off;

ax3 =  nexttile(3, [2,1]); 
trimesh(T_plate70,xvalue_plate70,yvalue_plate70,zvalue_plate70, cvalue_plate70); shading flat; view([0.9, 90]);grid off;hold on;
ylim([-45 -23]); xlim([171 187]); set(gca, 'FontSize',10);
caxis([0 70]); colormap(ax3, cmap)
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]);set(gca,'Layer','top'); box on;
a = colorbar('eastoutside', 'FontSize', 10); ylabel(a,'Slip Deficit (mm/year)','FontSize',10);
text(169,-23,'C', 'FontSize', 15, 'FontWeight', 'bold');
title('Plate_{70}'); hold off;

ax4 =  nexttile(7, [2,1]); 
hold on;
plot(lon, lat, 'LineWidth', 2, 'Color', 'black')
ylim([-45 -23]); xlim([171 187]); set(gca, 'FontSize',10);
scatter(creep_events(:,2),creep_events(:,3),(10.^creep_events(:,5))/5000000,creep_events(:,4),'filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1)
set(gca,'ColorScale','log', 'CLim', [5 50]) 
colormap(ax4, 'parula'); caxis([5 50])
set(gca, 'FontSize',10); 
scatter(172.8,-27, 10^8.0/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-27.2,'Mw8.0','FontSize',10.5);
scatter(172.8,-26.2, 10^8.5/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-26.2,'Mw8.5','FontSize',10.5);
scatter(172.8,-25, 10^9/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-25,'Mw9.0','FontSize',10.5);
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]);
text(169,-23,'D', 'FontSize', 15, 'FontWeight', 'bold');
hold off

ax5 =  nexttile(8, [2,1]); 
hold on;
plot(lon, lat, 'LineWidth', 2, 'Color', 'black')
ylim([-45 -23]); xlim([171 187]); set(gca, 'FontSize',10);
scatter(lock_events(:,2),lock_events(:,3),(10.^lock_events(:,5))/5000000,lock_events(:,4),'filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1)
set(gca,'ColorScale','log', 'CLim', [5 50]) 
colormap(ax5, 'parula'); caxis([5 50])
set(gca, 'FontSize',10); 
scatter(172.8,-27, 10^8.0/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-27.2,'Mw8.0','FontSize',10.5);
scatter(172.8,-26.2, 10^8.5/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-26.2,'Mw8.5','FontSize',10.5);
scatter(172.8,-25, 10^9/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-25,'Mw9.0','FontSize',10.5);
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]);
text(169,-23,'E', 'FontSize', 15, 'FontWeight', 'bold');
hold off

ax6 =  nexttile(9, [2,1]); 
hold on;
plot(lon, lat, 'LineWidth', 2, 'Color', 'black')
ylim([-45 -23]); xlim([171 187]); set(gca, 'FontSize',10);
scatter(plate70_events(:,2),plate70_events(:,3),(10.^plate70_events(:,5))/5000000,plate70_events(:,4),'filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1)
set(gca,'ColorScale','log', 'CLim', [5 50]) 
c = colorbar('eastoutside', 'FontSize', 10); 
c.Ticks = unique([5, 10, 20, 30, 40, 50]);  
c.TickLabels{1} = '5'; c.TickLabels{2} = '10'; c.TickLabels{3} = '20';
c.TickLabels{4} = '30'; c.TickLabels{5} = '40'; c.TickLabels{6} = '50';
colormap(ax6, 'parula'); caxis([5 50])
ylabel(c,'Depth (km)','FontSize',10);
set(gca, 'FontSize',10); 
scatter(172.8,-27, 10^8.0/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-27.2,'Mw8.0','FontSize',10.5);
scatter(172.8,-26.2, 10^8.5/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-26.2,'Mw8.5','FontSize',10.5);
scatter(172.8,-25, 10^9/5000000, 'blue','filled','MarkerFaceAlpha',0.5, 'MarkerEdgeColor','black','LineWidth',0.1); text(174.6,-25,'Mw9.0','FontSize',10.5);
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]);
text(169,-23,'F', 'FontSize', 15, 'FontWeight', 'bold');
hold off

ax7 =  nexttile(13); 
b = histogram(creep_events(:,5),'FaceAlpha',0.8); b.BinWidth = 0.1;
xlabel('Earthquake Magnitude (Mw)', 'FontSize',10); ylabel('Number of events', 'FontSize',10);
ylim([0.9 175]); xlim([8.0 9.2]);
set(gca, 'FontSize',10); b.FaceColor = '#0072BD'; b.EdgeColor = '#0072BD'; %
text(7.8,175,'G', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

ax8 =  nexttile(14); 
b = histogram(lock_events(:,5),'FaceAlpha',0.8); b.BinWidth = 0.1;
xlabel('Earthquake Magnitude (Mw)', 'FontSize',10); ylabel('Number of events', 'FontSize',10);
ylim([0.9 175]); xlim([8.0 9.2]);
set(gca, 'FontSize',10); b.FaceColor = '#77AC30'; b.EdgeColor = '#77AC30';  
text(7.8,175,'H', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

ax9 =  nexttile(15); 
b = histogram(plate70_events(:,5),'FaceAlpha',0.8); b.BinWidth = 0.1;
xlabel('Earthquake Magnitude (Mw)', 'FontSize',10); ylabel('Number of events', 'FontSize',10);
ylim([0.9 175]); xlim([8.0 9.2]); 
set(gca, 'FontSize',10); b.FaceColor = '#7E2F8E'; b.EdgeColor = '#7E2F8E'; 
text(7.8,175,'I', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[418,131,827,788])
fig = gcf;
exportgraphics(fig, 'datasets.png', 'BackgroundColor','white')


%%-----------------------------------------------------------------------%%
% Figure Three: Largest magnitude earthquake
% Earthquake Data
% Creep
event_path = 'creep_grd\'; event = 'creep_104279';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_creep = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_creep, Latitude_creep] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% Lock
event_path = 'lock_grd\'; event = 'lock_153268';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_231889';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 

%Tsunami Data
filename = ['layer03_x.dat']; layer03_x = importdata(filename);
filename = ['layer03_y.dat']; layer03_y = importdata(filename);

filename = ['zmax_layer03_creep_event104279.dat'];
layer03_max = importdata(filename); A1 = permute(layer03_max, [2 1]); B1 = reshape(A1, 1560, 2238); B1(any(isnan(B1), 2), :) = []; maximum_creep = B1.';

filename = ['zmax_layer03_lock_event153268.dat'];
layer03_max = importdata(filename); A1 = permute(layer03_max, [2 1]); B1 = reshape(A1, 1560, 2238); B1(any(isnan(B1), 2), :) = []; maximum_lock = B1.';

filename = ['zmax_layer03_lock_event231889.dat'];
layer03_max = importdata(filename); A1 = permute(layer03_max, [2 1]); B1 = reshape(A1, 1560, 2238); B1(any(isnan(B1), 2), :) = []; maximum_plate70 = B1.';

% Plate boundary
pac = load('pacific.mat'); lat = pac.pac(:,1); lon = pac.pac(:,2);

mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
mycolormap2 = customcolormap(linspace(0,1,11), {'#7f3c0a','#b35807','#e28212','#f9b967','#ffe0b2','#f7f7f5','#d7d9ee','#b3abd2','#8073a9','#562689','#2f004d'});

f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1); %Largest magnitude event creep
pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); set(gca, 'FontSize',10);
shading flat; hold on
scatter(174.723, -41.407, 200, 'pentagram', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','black');
ylim([-45.5 -34]); xlim([171 182]);text(170,-34,'A', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Creep}'); hold off;

ax2 =  nexttile(2); % Largest magnitude event ML1a
pcolor(Longitude_lock, Latitude_lock,  eventZ_NZTM_lock); colormap(ax2, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; hold on
scatter(175.1681,-41.6232, 200, 'pentagram', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','black');
ylim([-45.5 -34]); xlim([171 182]);text(170,-34,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Lock}'); hold off;

ax3 =  nexttile(3); % Largest magnitude event ML2a
pcolor(Longitude_plate70, Latitude_plate70,  eventZ_NZTM_plate70); colormap(ax3, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; a = colorbar('eastoutside', 'FontSize', 10); a.Label.String = 'Vertical displacement (m)';
a.Label.FontSize = 10; ylabel(a,'Displacement (m)','FontSize',10); hold on
scatter(174.259,-41.111, 200, 'pentagram', 'MarkerEdgeColor','black','LineWidth',1, 'MarkerFaceColor','black');
ylim([-45.5 -34]); xlim([171 182]);text(170,-34,'C', 'FontSize', 15, 'FontWeight', 'bold');
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Plate_{70}');hold off;

ax4 =  nexttile(4); % Coupling BES2
pcolor(layer03_x, layer03_y, maximum_creep); shading flat; colormap(ax4, parula); hold on
set(gca,'ColorScale','log', 'CLim', [0.1 20]);set(gca, 'FontSize',10);
xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
title('Trench_{Creep} Tsunami'); text(165,-34,'D', 'FontSize', 15, 'FontWeight', 'bold'); hold off;

ax5 =  nexttile(5); % Coupling ML1a
pcolor(layer03_x, layer03_y, maximum_lock); shading flat; colormap(ax5, parula); hold on
set(gca,'ColorScale','log', 'CLim', [0.1 20]);set(gca, 'FontSize',10);
xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
title('Trench_{Lock} Tsunami'); text(165,-34,'E', 'FontSize', 15, 'FontWeight', 'bold');hold off;

ax6 =  nexttile(6); % Coupling ML1a
pcolor(layer03_x, layer03_y, maximum_plate70); shading flat; colormap(ax6, parula); hold on
set(gca,'ColorScale','log', 'CLim', [0.1 20]);set(gca, 'FontSize',10);
xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
b = colorbar('FontSize', 10,'TickLabels', {'0.1','1','10'}); set(gca,'ColorScale','log', 'CLim', [0.1 10]);
b.Label.String = 'Wave height (m)'; b.Label.FontSize = 10; pos = get(b,'Position'); b.Label.Position = [2.5 pos(2)+0.8]; 
title('Plate_{70} Tsunami');text(165,-34,'F', 'FontSize', 15, 'FontWeight', 'bold');hold off;

ax7 =  nexttile(7); % Coupling BES2
pcolor(layer03_x, layer03_y, maximum_creep-maximum_lock); shading flat; colormap(ax7, mycolormap); hold on
set(gca, 'CLim', [-3 3]); set(gca, 'FontSize',10);
xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
title('Trench_{Creep} - Trench_{Lock}'); text(165,-34,'G', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

ax8 =  nexttile(8); % Coupling ML1a
pcolor(layer03_x, layer03_y, maximum_creep-maximum_plate70); shading flat; 
colormap(ax8, mycolormap); hold on
set(gca, 'CLim', [-3 3]);set(gca, 'FontSize',10);
xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
title('Trench_{Creep} - Plate_{70}');text(165,-34,'H', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

ax9 =  nexttile(9); % Coupling ML1a
pcolor(layer03_x, layer03_y, maximum_lock-maximum_plate70); shading flat; 
colormap(ax9, mycolormap); hold on
set(gca, 'CLim', [-3 3]);set(gca, 'FontSize',10);
xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
c = colorbar('FontSize', 10); c.Label.String = 'Difference (m)'; c.Label.FontSize = 10; pos = get(c,'Position'); c.Label.Position = [2.5 pos(2)+0.3];
title('Trench_{Lock} - Plate_{70}'); text(165,-34,'I', 'FontSize', 15, 'FontWeight', 'bold'); hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[413,42,827,954])
fig = gcf;
exportgraphics(fig, 'largest_magnitude.png', 'BackgroundColor','white')

%%-----------------------------------------------------------------------%%
% Figure four: return periods
% Tsunami data:
load('creep_coastal_data.mat'); load('lock_coastal_data.mat'); load('plate70_coastal_data.mat'); 
creep = creep_coastline(2:end, :); lock = lock_coastline(2:end, :); plate70 = plate70_coastline(2:end, :);

% creep tsunami hazard
t = maxk(creep, 1, 2); min_exceed = mink(t, 1,2); creep_30000 = round(min_exceed, 2); % Maximum hazard
t = maxk(creep, 60, 2); min_exceed = mink(t, 1,2); creep_500 = round(min_exceed, 2);% 500year return period 

% lock tsunami hazard
t = maxk(lock, 1, 2); min_exceed = mink(t, 1,2); lock_30000 = round(min_exceed, 2); % Maximum hazard
t = maxk(lock, 60, 2); min_exceed = mink(t, 1,2); lock_500 = round(min_exceed, 2);% 500year return period 

% plate70 tsunami hazard
t = maxk(plate70, 1, 2); min_exceed = mink(t, 1,2); plate70_30000 = round(min_exceed, 2);% Maximum hazard
t = maxk(plate70, 60, 2); min_exceed = mink(t, 1,2); plate70_500 = round(min_exceed, 2);% 500year return period 

coastal_points = load('coastal_points.mat');
coastal_i = coastal_points.coastal_points(:,3); coastal_j = coastal_points.coastal_points(:,4);
coastal_x = coastal_points.coastal_points(:,1); coastal_y = coastal_points.coastal_points(:,2);

mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
mycolormap2 = customcolormap(linspace(0,1,11), {'#7f3c0a','#b35807','#e28212','#f9b967','#ffe0b2','#f7f7f5','#d7d9ee','#b3abd2','#8073a9','#562689','#2f004d'});

creep_info = creep_30000; lock_info = lock_30000; plate70_info = plate70_30000;
creep_info2 = creep_500; lock_info2 = lock_500; plate70_info2 = plate70_500;

creep_lock = creep_info - lock_info; temp = [creep_lock coastal_x coastal_y abs(creep_lock)]; creep_lock_info = sortrows(temp, 4);
creep_plate70 = creep_info - plate70_info; temp = [creep_plate70 coastal_x coastal_y abs(creep_plate70)]; creep_plate70_info = sortrows(temp, 4);
lock_plate70 = lock_info - plate70_info;temp = [lock_plate70 coastal_x coastal_y abs(lock_plate70)]; lock_plate70_info = sortrows(temp, 4);
creep_lock2 = creep_info2 - lock_info2; temp = [creep_lock2 coastal_x coastal_y abs(creep_lock2)]; creep_lock_info2 = sortrows(temp, 4);
creep_plate702 = creep_info2 - plate70_info2; temp = [creep_plate702 coastal_x coastal_y abs(creep_plate702)]; creep_plate70_info2 = sortrows(temp, 4);
lock_plate702 = lock_info2 - plate70_info2;temp = [lock_plate702 coastal_x coastal_y abs(lock_plate702)]; lock_plate70_info2 = sortrows(temp, 4);

lim = 5; lim2 = 2;

f = figure('visible','off');
%figure
tlo = tiledlayout(4,3,'TileSpacing','compact','Padding','compact');
% Maximum hazard
ax1 = nexttile; % maximum hazard
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, creep_info); 
colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
set(gca, 'FontSize', 10); title('Trench_{Creep}'); ylabel('Maximum hazard','FontWeight','bold'); text(164.5,-33.5,'A', 'FontSize', 15, 'FontWeight', 'bold');
ax1 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, lock_info); 
colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
set(gca, 'FontSize', 10); title('Trench_{Lock}'); text(164.5,-33.5,'B', 'FontSize', 15, 'FontWeight', 'bold');
ax1 =nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, plate70_info); 
set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
colormap(ax1,'parula');
c = colorbar('FontSize', 10); set(gca,'ColorScale','log', 'CLim', [0.1 10]);
c.Label.String = 'Wave height (m)'; pos = get(c,'Position'); c.Label.Position = [2 pos(2)+0.9];
c.Ticks = unique([0.1, 1, 10]); c.TickLabels{1} = '0.1'; c.TickLabels{2} = '1'; c.TickLabels{3} = '10'; 
set(gca, 'FontSize', 10); title('Plate_{70}'); text(164.5,-33.5,'C', 'FontSize', 15, 'FontWeight', 'bold');

ax2 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(creep_lock_info(:,2),creep_lock_info(:,3), 5, creep_lock_info(:,1), 'filled'); 
colormap(ax2,mycolormap); set(gca, 'CLim', [lim*-1 lim]); 
set(gca, 'FontSize', 10);title('Trench_{Creep} - Trench_{Lock}'); text(164.5,-33.5,'D', 'FontSize', 15, 'FontWeight', 'bold'); ylabel('Maximum difference','FontWeight','bold');
ax2 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);title('Trench_{Creep} - Plate_{70}');
yticks([-45 -40 -35]); xticks([170 175]);
scatter(creep_plate70_info(:,2),creep_plate70_info(:,3), 5, creep_plate70_info(:,1), 'filled'); text(164.5,-33.5,'E', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); set(gca, 'FontSize', 10);set(gca, 'CLim', [lim*-1 lim]);
ax2 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(lock_plate70_info(:,2),lock_plate70_info(:,3), 5, lock_plate70_info(:,1), 'filled'); text(164.5,-33.5,'F', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); 
set(gca, 'FontSize', 10);
c = colorbar('FontSize', 10); set(gca, 'CLim', [lim*-1 lim]); 
c.Label.String = 'Difference (m)'; pos = get(c,'Position'); c.Label.Position = [2.1 pos(2)];title('Trench_{Lock} - Plate_{70}');

%%---------%%

ax3 = nexttile; 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, creep_info2); 
colormap(ax3,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 5]); 
set(gca, 'FontSize', 10); title('Trench_{Creep}'); ylabel('500-year return period hazard','FontWeight','bold'); text(164.5,-33.5,'G', 'FontSize', 15, 'FontWeight', 'bold');
ax3 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, lock_info2); 
colormap(ax3,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 5]); 
set(gca, 'FontSize', 10); title('Trench_{Lock}'); text(164.5,-33.5,'H', 'FontSize', 15, 'FontWeight', 'bold');
ax3 =nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, plate70_info2); 
set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
colormap(ax3,'parula');
c = colorbar('FontSize', 10); set(gca,'ColorScale','log', 'CLim', [0.1 5]);
c.Label.String = 'Wave height (m)'; pos = get(c,'Position'); c.Label.Position = [2 pos(2)+0.5];
c.Ticks = unique([0.1, 1, 5]);  
c.TickLabels{1} = '0.1'; c.TickLabels{2} = '1'; c.TickLabels{3} = '5'; 
set(gca, 'FontSize', 10); title('Plate_{70}'); text(164.5,-33.5,'I', 'FontSize', 15, 'FontWeight', 'bold');

ax2 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(creep_lock_info2(:,2),creep_lock_info2(:,3), 5, creep_lock_info2(:,1), 'filled'); 
colormap(ax2,mycolormap); set(gca, 'CLim', [lim2*-1 lim2]); 
set(gca, 'FontSize', 10);title('Trench_{Creep} - Trench_{Lock}'); text(164.5,-33.5,'J', 'FontSize', 15, 'FontWeight', 'bold'); ylabel('500-year difference','FontWeight','bold');
ax2 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);title('Trench_{Creep} - Plate_{70}');
yticks([-45 -40 -35]); xticks([170 175]);
scatter(creep_plate70_info2(:,2),creep_plate70_info2(:,3), 5, creep_plate70_info2(:,1), 'filled'); text(164.5,-33.5,'K', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); set(gca, 'FontSize', 10);set(gca, 'CLim', [lim2*-1 lim2]);
ax2 = nexttile;
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(lock_plate70_info2(:,2),lock_plate70_info2(:,3), 5, lock_plate70_info2(:,1), 'filled'); text(164.5,-33.5,'L', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); 
set(gca, 'FontSize', 10);
c = colorbar('FontSize', 10); set(gca, 'CLim', [lim2*-1 lim2]); 
c.Label.String = 'Difference (m)'; pos = get(c,'Position'); c.Label.Position = [2.1 pos(2)];title('Trench_{Lock} - Plate_{70}');

%pos = get(gcf, 'Position')
set(gcf,'position',[538,16,627,980]) 
fig = gcf;
exportgraphics(fig, 'return_period_comparison.png', 'BackgroundColor','white') % this saves the figure

%%-----------------------------------------------------------------------%%
% Figure five - Spatial variability
% Format the zone information
coastal_points = load('coastal_points.mat');
coastal_x = coastal_points.coastal_points(:,1); coastal_y = coastal_points.coastal_points(:,2);

zones = readtable('zones_small_name_coord.txt'); zones_new = removevars(zones, {'Var6', 'Var7'});
temp_zones_matrix = table2array(zones_new); temp_zones_matrix(37462, :) = [];
zones_matrix = temp_zones_matrix;

NaN_rows = find(all(isnan(zones_matrix),2)); zone_number = [];
% Isolate zone names
for ii = 1:length(NaN_rows)-1
    row_value = NaN_rows(ii)+1;
    zone_num = zones_matrix(row_value, 5);
    zone_number = [zone_number, zone_num];
end
zone_numbers = [42, zone_number];
% Remove unnecessary information
for ii = 1:length(NaN_rows)-1
   x = find(all(isnan(zones_matrix), 2)); zones_matrix(x(ii)+1, :) = [];
end
%Make a series of variables for the zones
for ii = 1:length(x)
   zone_num =  zone_numbers(ii);
   name = ['zone', num2str(zone_num), '_coord'];
   if ii == 1
      lat_lon = zones_matrix(1:x(ii)-1, 1:2); 
   else
      lat_lon = zones_matrix(x(ii-1)+1:x(ii)-1, 1:2); 
   end
   assignin('base',name,lat_lon)
end
%%-----------------------------------------------------------------------%%
% Tsunami data: CREEP:
load('creep_coastal_data.mat'); creep = creep_coastline(2:end, :);
creep = csvread('creep_gt8_catalogue.csv', 1,0);

% Isolate the idex of events that fit within a time frame
start_time = creep(1,2); 
time_step1 = 4.7304*10^11; time_step2 = 3.1536*10^11; 
time_step3 = 1.5768*10^11; time_step4 = 7.884*10^10;

time_idx_15000 = zeros(2,2); %15000year groups
for ii = 1:2
    time = start_time+time_step1*ii; [val,idx]=min(abs(creep(:,2)-time)); minVal=creep(idx, 2);
    time_idx_15000(ii, [1,2]) = [idx, minVal];
end
time_idx_10000 = zeros(3,2); % 10000 year groups
for ii = 1:3
    time = start_time+time_step2*ii; [val,idx]=min(abs(creep(:,2)-time)); minVal=creep(idx, 2);
    time_idx_10000(ii, [1,2]) = [idx, minVal];
end
time_idx_5000 = zeros(6,2); % 5000 year groups
for ii = 1:6
    time = start_time+time_step3*ii; [val,idx]=min(abs(creep(:,2)-time)); minVal=creep(idx, 2);
    time_idx_5000(ii, [1,2]) = [idx, minVal];
end
time_idx_2500 = zeros(12,2); %2500 year groups
for ii = 1:12
    time = start_time+time_step4*ii; [val,idx]=min(abs(creep(:,2)-time)); minVal=creep(idx, 2);
    time_idx_2500(ii, [1,2]) = [idx, minVal];
end
% Isolate the associated wave height data:
load('creep_coastal_data.mat'); creep_coast = creep_coastline(2:end, :); 
t = maxk(creep_coast, 12, 2); min_exceed = mink(t, 1,2); creep_30000 = round(min_exceed, 2);

coast = creep_coast(:, 1:time_idx_15000(1,1)); t = maxk(coast, 6, 2); min_exceed = mink(t, 1,2); creep_15000a = round(min_exceed, 2);
coast = creep_coast(:, time_idx_15000(1,1):time_idx_15000(2,1)); t = maxk(coast, 6, 2); min_exceed = mink(t, 1,2); creep_15000b = round(min_exceed, 2);

coast = creep_coast(:, 1:time_idx_10000(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); creep_10000a = round(min_exceed, 2);
coast = creep_coast(:, time_idx_10000(1,1):time_idx_10000(2,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); creep_10000b = round(min_exceed, 2);
coast = creep_coast(:, time_idx_10000(2,1):time_idx_10000(3,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); creep_10000c = round(min_exceed, 2);

coast = creep_coast(:, 1:time_idx_5000(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); creep_5000a = round(min_exceed, 2);
coast = creep_coast(:, time_idx_5000(1,1):time_idx_5000(2,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); creep_5000b = round(min_exceed, 2);
coast = creep_coast(:, time_idx_5000(2,1):time_idx_5000(3,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); creep_5000c = round(min_exceed, 2);
coast = creep_coast(:, time_idx_5000(3,1):time_idx_5000(4,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); creep_5000d = round(min_exceed, 2);
coast = creep_coast(:, time_idx_5000(4,1):time_idx_5000(5,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); creep_5000e = round(min_exceed, 2);
coast = creep_coast(:, time_idx_5000(5,1):time_idx_5000(6,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); creep_5000f = round(min_exceed, 2);

coast = creep_coast(:, 1:time_idx_2500(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); creep_2500a = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(1,1):time_idx_2500(2,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500b = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(2,1):time_idx_2500(3,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500c = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(3,1):time_idx_2500(4,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500d = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(4,1):time_idx_2500(5,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500e = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(5,1):time_idx_2500(6,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500f = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(6,1):time_idx_2500(7,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500g = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(7,1):time_idx_2500(8,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500h = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(8,1):time_idx_2500(9,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500i = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(9,1):time_idx_2500(10,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500j = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(10,1):time_idx_2500(11,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500k = round(min_exceed, 2);
coast = creep_coast(:, time_idx_2500(11,1):time_idx_2500(12,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); creep_2500l = round(min_exceed, 2);
%%-----------------------------------------------------------------------%%
% Tsunami data: LOCK:
load('lock_coastal_data.mat'); lock = lock_coastline(2:end, :); 
lock = csvread('lock_gt8_catalogue.csv', 1,0);

% Isolate the idex of events that fit within a time frame
start_time = lock(1,2); 
time_step1 = 4.7304*10^11; time_step2 = 3.1536*10^11; 
time_step3 = 1.5768*10^11; time_step4 = 7.884*10^10;

time_idx_15000 = zeros(2,2); %15000year groups
for ii = 1:2
    time = start_time+time_step1*ii; [val,idx]=min(abs(lock(:,2)-time)); minVal=lock(idx, 2);
    time_idx_15000(ii, [1,2]) = [idx, minVal];
end
time_idx_10000 = zeros(3,2); % 10000 year groups
for ii = 1:3
    time = start_time+time_step2*ii; [val,idx]=min(abs(lock(:,2)-time)); minVal=lock(idx, 2);
    time_idx_10000(ii, [1,2]) = [idx, minVal];
end
time_idx_5000 = zeros(6,2); % 5000 year groups
for ii = 1:6
    time = start_time+time_step3*ii; [val,idx]=min(abs(lock(:,2)-time)); minVal=lock(idx, 2);
    time_idx_5000(ii, [1,2]) = [idx, minVal];
end
time_idx_2500 = zeros(12,2); %2500 year groups
for ii = 1:12
    time = start_time+time_step4*ii; [val,idx]=min(abs(lock(:,2)-time)); minVal=lock(idx, 2);
    time_idx_2500(ii, [1,2]) = [idx, minVal];
end
% Isolate the associated wave height data:
load('lock_coastal_data.mat'); lock_coast = lock_coastline(2:end, :); 

t = maxk(lock_coast, 12, 2); min_exceed = mink(t, 1,2); lock_30000 = round(min_exceed, 2); % 2500year return period - 30000year time

coast = lock_coast(:, 1:time_idx_15000(1,1)); t = maxk(coast, 6, 2); min_exceed = mink(t, 1,2); lock_15000a = round(min_exceed, 2);
coast = lock_coast(:, time_idx_15000(1,1):time_idx_15000(2,1)); t = maxk(coast, 6, 2); min_exceed = mink(t, 1,2); lock_15000b = round(min_exceed, 2);

coast = lock_coast(:, 1:time_idx_10000(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); lock_10000a = round(min_exceed, 2);
coast = lock_coast(:, time_idx_10000(1,1):time_idx_10000(2,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); lock_10000b = round(min_exceed, 2);
coast = lock_coast(:, time_idx_10000(2,1):time_idx_10000(3,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); lock_10000c = round(min_exceed, 2);

coast = lock_coast(:, 1:time_idx_5000(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); lock_5000a = round(min_exceed, 2);
coast = lock_coast(:, time_idx_5000(1,1):time_idx_5000(2,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); lock_5000b = round(min_exceed, 2);
coast = lock_coast(:, time_idx_5000(2,1):time_idx_5000(3,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); lock_5000c = round(min_exceed, 2);
coast = lock_coast(:, time_idx_5000(3,1):time_idx_5000(4,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); lock_5000d = round(min_exceed, 2);
coast = lock_coast(:, time_idx_5000(4,1):time_idx_5000(5,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); lock_5000e = round(min_exceed, 2);
coast = lock_coast(:, time_idx_5000(5,1):time_idx_5000(6,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); lock_5000f = round(min_exceed, 2);

coast = lock_coast(:, 1:time_idx_2500(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); lock_2500a = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(1,1):time_idx_2500(2,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500b = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(2,1):time_idx_2500(3,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500c = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(3,1):time_idx_2500(4,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500d = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(4,1):time_idx_2500(5,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500e = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(5,1):time_idx_2500(6,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500f = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(6,1):time_idx_2500(7,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500g = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(7,1):time_idx_2500(8,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500h = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(8,1):time_idx_2500(9,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500i = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(9,1):time_idx_2500(10,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500j = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(10,1):time_idx_2500(11,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500k = round(min_exceed, 2);
coast = lock_coast(:, time_idx_2500(11,1):time_idx_2500(12,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); lock_2500l = round(min_exceed, 2);
%%-----------------------------------------------------------------------%%
% Tsunami data: PLATE70:
plate70 = csvread('plate70_gt8_catalogue.csv', 1,0);

% Isolate the idex of events that fit within a time frame
start_time = plate70(1,2); 
time_step1 = 4.7304*10^11; time_step2 = 3.1536*10^11; 
time_step3 = 1.5768*10^11; time_step4 = 7.884*10^10;

time_idx_15000 = zeros(2,2); %15000year groups
for ii = 1:2
    time = start_time+time_step1*ii; [val,idx]=min(abs(plate70(:,2)-time)); minVal=plate70(idx, 2);
    time_idx_15000(ii, [1,2]) = [idx, minVal];
end
time_idx_10000 = zeros(3,2); % 10000 year groups
for ii = 1:3
    time = start_time+time_step2*ii; [val,idx]=min(abs(plate70(:,2)-time)); minVal=plate70(idx, 2);
    time_idx_10000(ii, [1,2]) = [idx, minVal];
end
time_idx_5000 = zeros(6,2); % 5000 year groups
for ii = 1:6
    time = start_time+time_step3*ii; [val,idx]=min(abs(plate70(:,2)-time)); minVal=plate70(idx, 2);
    time_idx_5000(ii, [1,2]) = [idx, minVal];
end
time_idx_2500 = zeros(12,2); %2500 year groups
for ii = 1:12
    time = start_time+time_step4*ii; [val,idx]=min(abs(plate70(:,2)-time)); minVal=plate70(idx, 2);
    time_idx_2500(ii, [1,2]) = [idx, minVal];
end


% Isolate the associated wave height data:
load('plate70_coastal_data.mat'); plate70_coast = plate70_coastline(2:end, :); 

t = maxk(plate70_coast, 12, 2); min_exceed = mink(t, 1,2); plate70_30000 = round(min_exceed, 2); % 2500year return period - 30000year time

coast = plate70_coast(:, 1:time_idx_15000(1,1)); t = maxk(coast, 6, 2); min_exceed = mink(t, 1,2); plate70_15000a = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_15000(1,1):time_idx_15000(2,1)); t = maxk(coast, 6, 2); min_exceed = mink(t, 1,2); plate70_15000b = round(min_exceed, 2);

coast = plate70_coast(:, 1:time_idx_10000(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); plate70_10000a = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_10000(1,1):time_idx_10000(2,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); plate70_10000b = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_10000(2,1):time_idx_10000(3,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); plate70_10000c = round(min_exceed, 2);

coast = plate70_coast(:, 1:time_idx_5000(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); plate70_5000a = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_5000(1,1):time_idx_5000(2,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); plate70_5000b = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_5000(2,1):time_idx_5000(3,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); plate70_5000c = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_5000(3,1):time_idx_5000(4,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); plate70_5000d = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_5000(4,1):time_idx_5000(5,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); plate70_5000e = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_5000(5,1):time_idx_5000(6,1)); t = maxk(coast, 2, 2); min_exceed = mink(t, 1,2); plate70_5000f = round(min_exceed, 2);

coast = plate70_coast(:, 1:time_idx_2500(1,1)); t = maxk(coast, 4, 2); min_exceed = mink(t, 1,2); plate70_2500a = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(1,1):time_idx_2500(2,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500b = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(2,1):time_idx_2500(3,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500c = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(3,1):time_idx_2500(4,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500d = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(4,1):time_idx_2500(5,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500e = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(5,1):time_idx_2500(6,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500f = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(6,1):time_idx_2500(7,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500g = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(7,1):time_idx_2500(8,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500h = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(8,1):time_idx_2500(9,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500i = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(9,1):time_idx_2500(10,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500j = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(10,1):time_idx_2500(11,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500k = round(min_exceed, 2);
coast = plate70_coast(:, time_idx_2500(11,1):time_idx_2500(12,1)); t = maxk(coast, 1, 2); min_exceed = mink(t, 1,2); plate70_2500l = round(min_exceed, 2);
%%-----------------------------------------------------------------------%%

% Find the datapoints that fit into each of the zones
for dataset = 1:3
    if dataset == 1
        for zone = 1:252
                name = ['zone', num2str(zone), '_coord'];
                disp(['zone', num2str(zone)])
                eval(['d =', name, ';']);
                temp_30000 = [];
                temp_15000a = [];temp_15000b = [];
                temp_10000a = [];temp_10000b = [];temp_10000c = [];
                temp_5000a = [];temp_5000b = [];temp_5000c = []; temp_5000d = [];temp_5000e = [];temp_5000f = [];
                temp_2500a = [];temp_2500b = [];temp_2500c = []; temp_2500d = [];temp_2500e = [];temp_2500f = [];
                temp_2500g = [];temp_2500h = [];temp_2500i = []; temp_2500j = [];temp_2500k = [];temp_2500l = [];
        
                for point = 1:length(creep_30000)
                    x_point = coastal_x(point); y_point = coastal_y(point); 
                    if inpolygon(x_point, y_point, d(:, 1), d(:, 2)) == 1
                        temp_30000 = [temp_30000, creep_30000(point)];
                        temp_15000a = [temp_15000a, creep_15000a(point)]; temp_15000b = [temp_15000b, creep_15000b(point)]; 
                        temp_10000a = [temp_10000a, creep_10000a(point)]; temp_10000b = [temp_10000b, creep_10000b(point)]; temp_10000c = [temp_10000c, creep_10000c(point)];
                        temp_5000a = [temp_5000a, creep_5000a(point)]; temp_5000b = [temp_5000b, creep_5000b(point)]; temp_5000c = [temp_5000c, creep_5000c(point)];
                        temp_5000d = [temp_5000d, creep_5000d(point)]; temp_5000e = [temp_5000e, creep_5000e(point)]; temp_5000f = [temp_5000f, creep_5000f(point)];
                        temp_2500a = [temp_2500a, creep_2500a(point)]; temp_2500b = [temp_2500b, creep_2500b(point)]; temp_2500c = [temp_2500c, creep_2500c(point)];
                        temp_2500d = [temp_2500d, creep_2500d(point)]; temp_2500e = [temp_2500e, creep_2500e(point)]; temp_2500f = [temp_2500f, creep_2500f(point)];                
                        temp_2500g = [temp_2500g, creep_2500g(point)]; temp_2500h = [temp_2500h, creep_2500h(point)]; temp_2500i = [temp_2500i, creep_2500i(point)];
                        temp_2500j = [temp_2500j, creep_2500j(point)]; temp_2500k = [temp_2500k, creep_2500k(point)]; temp_2500l = [temp_2500l, creep_2500l(point)];
                    end    
                end
                data_name = ['zone', num2str(zone), '_data'];
                assignin('base', data_name, [temp_30000', temp_15000a', temp_15000b',...
                    temp_10000a', temp_10000b', temp_10000c', ...
                    temp_5000a', temp_5000b', temp_5000c', temp_5000d', temp_5000e', temp_5000f',...
                    temp_2500a', temp_2500b', temp_2500c', temp_2500d', temp_2500e', temp_2500f',...
                    temp_2500g', temp_2500h', temp_2500i', temp_2500j', temp_2500k', temp_2500l'])
        end
        creep_zones = zeros(252, 23);
        for zone = 1:252
            disp(zone)
            name2 = ['zone', num2str(zone), '_data']; eval(['data =', name2, ';']);
            %wave_height1 = quantile(data(:,1), 1); wave_height2 = quantile(data(:,2), 1); wave_height3 = quantile(data(:,3), 1);
           
            info = [zone, quantile(data(:,1), 1), quantile(data(:,2), 1),quantile(data(:,3), 1),...
                quantile(data(:,4), 1),quantile(data(:,5), 1),quantile(data(:,6), 1),...
                quantile(data(:,7), 1),quantile(data(:,8), 1),quantile(data(:,9), 1),...
                quantile(data(:,10), 1),quantile(data(:,11), 1),quantile(data(:,12), 1),...
                quantile(data(:,13), 1),quantile(data(:,14), 1),quantile(data(:,15), 1),...
                quantile(data(:,16), 1),quantile(data(:,17), 1),quantile(data(:,18), 1),...
                quantile(data(:,19), 1),quantile(data(:,20), 1),quantile(data(:,21), 1),quantile(data(:,22), 1)];
    
            creep_zones(zone, :) = info;
        end

    elseif dataset == 2
        for zone = 1:252
                name = ['zone', num2str(zone), '_coord'];
                disp(['zone', num2str(zone)])
                eval(['d =', name, ';']);
                temp_30000 = [];
                temp_15000a = [];temp_15000b = [];
                temp_10000a = [];temp_10000b = [];temp_10000c = [];
                temp_5000a = [];temp_5000b = [];temp_5000c = []; temp_5000d = [];temp_5000e = [];temp_5000f = [];
                temp_2500a = [];temp_2500b = [];temp_2500c = []; temp_2500d = [];temp_2500e = [];temp_2500f = [];
                temp_2500g = [];temp_2500h = [];temp_2500i = []; temp_2500j = [];temp_2500k = [];temp_2500l = [];
        
                for point = 1:length(lock_30000)
                    x_point = coastal_x(point); y_point = coastal_y(point); 
                    if inpolygon(x_point, y_point, d(:, 1), d(:, 2)) == 1
                        temp_30000 = [temp_30000, lock_30000(point)];
                        temp_15000a = [temp_15000a, lock_15000a(point)]; temp_15000b = [temp_15000b, lock_15000b(point)]; 
                        temp_10000a = [temp_10000a, lock_10000a(point)]; temp_10000b = [temp_10000b, lock_10000b(point)]; temp_10000c = [temp_10000c, lock_10000c(point)];
                        temp_5000a = [temp_5000a, lock_5000a(point)]; temp_5000b = [temp_5000b, lock_5000b(point)]; temp_5000c = [temp_5000c, lock_5000c(point)];
                        temp_5000d = [temp_5000d, lock_5000d(point)]; temp_5000e = [temp_5000e, lock_5000e(point)]; temp_5000f = [temp_5000f, lock_5000f(point)];
                        temp_2500a = [temp_2500a, lock_2500a(point)]; temp_2500b = [temp_2500b, lock_2500b(point)]; temp_2500c = [temp_2500c, lock_2500c(point)];
                        temp_2500d = [temp_2500d, lock_2500d(point)]; temp_2500e = [temp_2500e, lock_2500e(point)]; temp_2500f = [temp_2500f, lock_2500f(point)];                
                        temp_2500g = [temp_2500g, lock_2500g(point)]; temp_2500h = [temp_2500h, lock_2500h(point)]; temp_2500i = [temp_2500i, lock_2500i(point)];
                        temp_2500j = [temp_2500j, lock_2500j(point)]; temp_2500k = [temp_2500k, lock_2500k(point)]; temp_2500l = [temp_2500l, lock_2500l(point)];
                    end    
                end
                data_name = ['zone', num2str(zone), '_data'];
                assignin('base', data_name, [temp_30000', temp_15000a', temp_15000b',...
                    temp_10000a', temp_10000b', temp_10000c', ...
                    temp_5000a', temp_5000b', temp_5000c', temp_5000d', temp_5000e', temp_5000f',...
                    temp_2500a', temp_2500b', temp_2500c', temp_2500d', temp_2500e', temp_2500f',...
                    temp_2500g', temp_2500h', temp_2500i', temp_2500j', temp_2500k', temp_2500l'])
        end
            lock_zones = zeros(252, 23);
            for zone = 1:252
                disp(zone)
                name2 = ['zone', num2str(zone), '_data']; eval(['data =', name2, ';']);
                %wave_height1 = quantile(data(:,1), 1); wave_height2 = quantile(data(:,2), 1); wave_height3 = quantile(data(:,3), 1);
               
                info = [zone, quantile(data(:,1), 1), quantile(data(:,2), 1),quantile(data(:,3), 1),...
                    quantile(data(:,4), 1),quantile(data(:,5), 1),quantile(data(:,6), 1),...
                    quantile(data(:,7), 1),quantile(data(:,8), 1),quantile(data(:,9), 1),...
                    quantile(data(:,10), 1),quantile(data(:,11), 1),quantile(data(:,12), 1),...
                    quantile(data(:,13), 1),quantile(data(:,14), 1),quantile(data(:,15), 1),...
                    quantile(data(:,16), 1),quantile(data(:,17), 1),quantile(data(:,18), 1),...
                    quantile(data(:,19), 1),quantile(data(:,20), 1),quantile(data(:,21), 1),quantile(data(:,22), 1)];
        
                lock_zones(zone, :) = info;
            end
    else
        for zone = 1:252
                name = ['zone', num2str(zone), '_coord'];
                disp(['zone', num2str(zone)])
                eval(['d =', name, ';']);
                temp_30000 = [];
                temp_15000a = [];temp_15000b = [];
                temp_10000a = [];temp_10000b = [];temp_10000c = [];
                temp_5000a = [];temp_5000b = [];temp_5000c = []; temp_5000d = [];temp_5000e = [];temp_5000f = [];
                temp_2500a = [];temp_2500b = [];temp_2500c = []; temp_2500d = [];temp_2500e = [];temp_2500f = [];
                temp_2500g = [];temp_2500h = [];temp_2500i = []; temp_2500j = [];temp_2500k = [];temp_2500l = [];
        
                for point = 1:length(plate70_30000)
                    x_point = coastal_x(point); y_point = coastal_y(point); 
                    if inpolygon(x_point, y_point, d(:, 1), d(:, 2)) == 1
                        temp_30000 = [temp_30000, plate70_30000(point)];
                        temp_15000a = [temp_15000a, plate70_15000a(point)]; temp_15000b = [temp_15000b, plate70_15000b(point)]; 
                        temp_10000a = [temp_10000a, plate70_10000a(point)]; temp_10000b = [temp_10000b, plate70_10000b(point)]; temp_10000c = [temp_10000c, plate70_10000c(point)];
                        temp_5000a = [temp_5000a, plate70_5000a(point)]; temp_5000b = [temp_5000b, plate70_5000b(point)]; temp_5000c = [temp_5000c, plate70_5000c(point)];
                        temp_5000d = [temp_5000d, plate70_5000d(point)]; temp_5000e = [temp_5000e, plate70_5000e(point)]; temp_5000f = [temp_5000f, plate70_5000f(point)];
                        temp_2500a = [temp_2500a, plate70_2500a(point)]; temp_2500b = [temp_2500b, plate70_2500b(point)]; temp_2500c = [temp_2500c, plate70_2500c(point)];
                        temp_2500d = [temp_2500d, plate70_2500d(point)]; temp_2500e = [temp_2500e, plate70_2500e(point)]; temp_2500f = [temp_2500f, plate70_2500f(point)];                
                        temp_2500g = [temp_2500g, plate70_2500g(point)]; temp_2500h = [temp_2500h, plate70_2500h(point)]; temp_2500i = [temp_2500i, plate70_2500i(point)];
                        temp_2500j = [temp_2500j, plate70_2500j(point)]; temp_2500k = [temp_2500k, plate70_2500k(point)]; temp_2500l = [temp_2500l, plate70_2500l(point)];
                    end    
                end
                data_name = ['zone', num2str(zone), '_data'];
                assignin('base', data_name, [temp_30000', temp_15000a', temp_15000b',...
                    temp_10000a', temp_10000b', temp_10000c', ...
                    temp_5000a', temp_5000b', temp_5000c', temp_5000d', temp_5000e', temp_5000f',...
                    temp_2500a', temp_2500b', temp_2500c', temp_2500d', temp_2500e', temp_2500f',...
                    temp_2500g', temp_2500h', temp_2500i', temp_2500j', temp_2500k', temp_2500l'])
        end
            plate70_zones = zeros(252, 23);
            for zone = 1:252
                disp(zone)
                name2 = ['zone', num2str(zone), '_data']; eval(['data =', name2, ';']);
                %wave_height1 = quantile(data(:,1), 1); wave_height2 = quantile(data(:,2), 1); wave_height3 = quantile(data(:,3), 1);
               
                info = [zone, quantile(data(:,1), 1), quantile(data(:,2), 1),quantile(data(:,3), 1),...
                    quantile(data(:,4), 1),quantile(data(:,5), 1),quantile(data(:,6), 1),...
                    quantile(data(:,7), 1),quantile(data(:,8), 1),quantile(data(:,9), 1),...
                    quantile(data(:,10), 1),quantile(data(:,11), 1),quantile(data(:,12), 1),...
                    quantile(data(:,13), 1),quantile(data(:,14), 1),quantile(data(:,15), 1),...
                    quantile(data(:,16), 1),quantile(data(:,17), 1),quantile(data(:,18), 1),...
                    quantile(data(:,19), 1),quantile(data(:,20), 1),quantile(data(:,21), 1),quantile(data(:,22), 1)];
        
                plate70_zones(zone, :) = info;
            end
    end
end
%Spatial Variability:
x = creep_zones(:, 1); xfill = [x(:); flipud(x(:))];

ymax_creep = max(creep_zones(:, 2:end), [], 2); ymin_creep = min(creep_zones(:, 2:end), [], 2);
yfill_creep = [ymax_creep(:); flipud(ymin_creep(:))];

ymax_lock = max(lock_zones(:, 2:end), [], 2); ymin_lock = min(lock_zones(:, 2:end), [], 2);
yfill_lock = [ymax_lock(:); flipud(ymin_lock(:))];

ymax_plate70 = max(plate70_zones(:, 2:end), [], 2); ymin_plate70 = min(plate70_zones(:, 2:end), [], 2);
yfill_plate70 = [ymax_plate70(:); flipud(ymin_plate70(:))];

fillcolor = [.5 .5 .5];


% Plate boundary
pac = load('pacific_plate.mat'); lat = pac.pac(:,2); lon = pac.pac(:,1);
towns = csvread('towns.csv', 1,0);
load coastlines

f = figure('visible','off');
%figure
tlo = tiledlayout(3,1,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1);
hold on;
a1 = fill(xfill, yfill_creep, fillcolor,'FaceAlpha',0.3, 'EdgeColor','none');
a = plot(creep_zones(1:137, 1),creep_zones(1:137, 2),'-','Color', '#0072BD', 'LineWidth',2); plot(creep_zones(138:end, 1),creep_zones(138:end, 2),'-','Color', '#0072BD', 'LineWidth',2);
set(gca, 'FontSize',10);
text(65,19,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.','HandleVisibility','off')
text(195,19,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 20]); ylabel('Wave height at coast (m)'); 
xlim([1 252]); xticks([31 73 91 111 144 150 190 210 232 247]); set(gca,'Xticklabel',[])
text(-15,21,'A', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

ax2 =  nexttile(2);
hold on;
fill(xfill, yfill_lock, fillcolor,'FaceAlpha',0.3, 'EdgeColor','none');
b = plot(lock_zones(1:137, 1),lock_zones(1:137, 2),'-','Color', '#77AC30', 'LineWidth',2);  plot(lock_zones(138:end, 1),lock_zones(138:end, 2),'-','Color', '#77AC30', 'LineWidth',2);
set(gca, 'FontSize',10);
text(65,19,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.','HandleVisibility','off')
text(195,19,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 20]); ylabel('Wave height at coast (m)'); 
xlim([1 252]); xticks([31 73 91 111 144 150 190 210 232 247]); set(gca,'Xticklabel',[])
text(-15,21,'B', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

ax3 =  nexttile(3);
hold on;
fill(xfill, yfill_plate70, fillcolor,'FaceAlpha',0.3, 'EdgeColor','none');
f = plot(plate70_zones(1:137, 1),plate70_zones(1:137, 2),'-','Color', '#7E2F8E', 'LineWidth',2); plot(plate70_zones(138:end, 1),plate70_zones(138:end, 2),'-','Color', '#7E2F8E', 'LineWidth',2);
lgd = legend(ax3,[a1, a ,b,f], {'Wave Height Uncertainty', 'Trench_{Creep} 2,500-year Return Reriod', 'Trench_{Lock} 2,500-year Return Reriod', 'Plate_{70} 2,500-year Return Reriod'}, 'Location','southoutside');
lgd.NumColumns = 2; legend('boxoff')
set(gca, 'FontSize',10);
text(65,19,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.','HandleVisibility','off')
text(195,19,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 20]); ylabel('Wave height at coast (m)'); 
xlim([1 252]); xticks([1 31 65 73 91 111 144 150 190 210 232 247]); 
xticklabels({'Ahipara','Auckland','Gisborne','Napier','Wellington','New Plymouth','Kaikōura','Christchurch','Stewart Island','Milford Sound','Westport','Nelson'}); xtickangle(40)
text(-15,21,'C', 'FontSize', 15, 'FontWeight', 'bold');
hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[382,44,858,934]) 
fig = gcf;
exportgraphics(fig, 'spatial_variability_trench_creep_lock_plate70_return_period.png', 'BackgroundColor','white') % this saves the figure

%%-----------------------------------------------------------------------%%
% Figure six: tsunami hazard return period using Plate70R
% Tsunami data:
load('creep_coastal_data.mat'); creep = creep_coastline(2:end, :); 
load('lock_coastal_data.mat'); lock = lock_coastline(2:end, :);
load(plate70_coastal_data.mat'); plate70_full = plate70_coastline(2:end, :);
plate70_reduced_ids = csvread('plate70_reduced.csv', 1,0);
plate70_reduced_coastline = zeros(12619, 445);
for i = 1:844
    id_1 = plate70_coastline(1,i);
    for ii = 1:length(plate70_reduced_ids)
        id_2 = plate70_reduced_ids(ii);
        if id_1 == id_2
            coastline = plate70_coastline(:, i);
            plate70_reduced_coastline(:, ii) = coastline;
        end
    end
end
plate70 = plate70_reduced_coastline(2:end, :);

% creep tsunami hazard
t = maxk(creep, 6, 2); min_exceed = mink(t, 1,2); creep_30000 = round(min_exceed, 2); % Maximum hazard
t = maxk(creep, 60, 2); min_exceed = mink(t, 1,2); creep_500 = round(min_exceed, 2);% 500year return period 

% lock tsunami hazard
t = maxk(lock, 6, 2); min_exceed = mink(t, 1,2); lock_30000 = round(min_exceed, 2); % Maximum hazard
t = maxk(lock, 60, 2); min_exceed = mink(t, 1,2); lock_500 = round(min_exceed, 2);% 500year return period 

% plate70 tsunami hazard - full
t = maxk(plate70_full, 6, 2); min_exceed = mink(t, 1,2); plate70_full_30000 = round(min_exceed, 2);% Maximum hazard
t = maxk(plate70_full, 60, 2); min_exceed = mink(t, 1,2); plate70_full_500 = round(min_exceed, 2);% 500year return period 

% plate70 tsunami hazard
t = maxk(plate70, 6, 2); min_exceed = mink(t, 1,2); plate70_30000 = round(min_exceed, 2);% Maximum hazard
t = maxk(plate70, 60, 2); min_exceed = mink(t, 1,2); plate70_500 = round(min_exceed, 2);% 500year return period 

coastal_points = load('coastal_points.mat');
coastal_i = coastal_points.coastal_points(:,3); coastal_j = coastal_points.coastal_points(:,4);
coastal_x = coastal_points.coastal_points(:,1); coastal_y = coastal_points.coastal_points(:,2);

mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
mycolormap2 = customcolormap(linspace(0,1,11), {'#7f3c0a','#b35807','#e28212','#f9b967','#ffe0b2','#f7f7f5','#d7d9ee','#b3abd2','#8073a9','#562689','#2f004d'});

creep_info = creep_30000; lock_info = lock_30000; plate70_info = plate70_30000; plate70_full_info = plate70_full_30000;
creep_info2 = creep_500; lock_info2 = lock_500; plate70_info2 = plate70_500; plate70_full_info2 = plate70_full_500;

creep_lock = creep_info - lock_info; temp = [creep_lock coastal_x coastal_y abs(creep_lock)]; creep_lock_info = sortrows(temp, 4);
creep_plate70 = creep_info - plate70_info; temp = [creep_plate70 coastal_x coastal_y abs(creep_plate70)]; creep_plate70_info = sortrows(temp, 4);
lock_plate70 = lock_info - plate70_info;temp = [lock_plate70 coastal_x coastal_y abs(lock_plate70)]; lock_plate70_info = sortrows(temp, 4);
plate70_plate70 = plate70_full_info - plate70_info;temp = [plate70_plate70 coastal_x coastal_y abs(plate70_plate70)]; plate70_plate70_info = sortrows(temp, 4);

creep_lock2 = creep_info2 - lock_info2; temp = [creep_lock2 coastal_x coastal_y abs(creep_lock2)]; creep_lock_info2 = sortrows(temp, 4);
creep_plate702 = creep_info2 - plate70_info2; temp = [creep_plate702 coastal_x coastal_y abs(creep_plate702)]; creep_plate70_info2 = sortrows(temp, 4);
lock_plate702 = lock_info2 - plate70_info2;temp = [lock_plate702 coastal_x coastal_y abs(lock_plate702)]; lock_plate70_info2 = sortrows(temp, 4);
plate70_plate702 = plate70_full_info2 - plate70_info2;temp = [plate70_plate702 coastal_x coastal_y abs(plate70_plate702)]; plate70_plate70_info2 = sortrows(temp, 4);

lim = 5; lim2 = 2;

f = figure('visible','off');
%figure
tlo = tiledlayout(4,4,'TileSpacing','compact','Padding','compact');
ax1 = nexttile(1); 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, creep_info); 
colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
set(gca, 'FontSize', 10); title('Trench_{Creep}'); ylabel('5,000-year return period','FontWeight','bold'); text(164.5,-33.5,'A', 'FontSize', 15, 'FontWeight', 'bold');
ax1 = nexttile(2);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, lock_info); 
colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
set(gca, 'FontSize', 10); title('Trench_{Lock}'); text(164.5,-33.5,'B', 'FontSize', 15, 'FontWeight', 'bold');
ax1 = nexttile(3);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, plate70_full_info); 
colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
set(gca, 'FontSize', 10); title('Plate_{70}'); text(164.5,-33.5,'C', 'FontSize', 15, 'FontWeight', 'bold');
ax1 =nexttile(4);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, plate70_info); 
set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
colormap(ax1,'parula');
c = colorbar('FontSize', 10); set(gca,'ColorScale','log', 'CLim', [0.1 10]);
c.Label.String = 'Wave height (m)'; pos = get(c,'Position'); c.Label.Position = [2 pos(2)+0.7];
c.Ticks = unique([0.1, 1, 10]); c.TickLabels{1} = '0.1'; c.TickLabels{2} = '1'; c.TickLabels{3} = '10'; 
set(gca, 'FontSize', 10); title('Plate_{70R}'); text(164.5,-33.5,'D', 'FontSize', 15, 'FontWeight', 'bold');

ax2 = nexttile(5);
hold on; xlim([166 179]); ylim([-48 -34]);title('Trench_{Creep} - Plate_{70R}');
yticks([-45 -40 -35]); xticks([170 175]);  ylabel('5,000-year difference','FontWeight','bold');
scatter(creep_plate70_info(:,2),creep_plate70_info(:,3), 5, creep_plate70_info(:,1), 'filled'); text(164.5,-33.5,'E', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); set(gca, 'FontSize', 10);set(gca, 'CLim', [lim*-1 lim]);
ax2 = nexttile(6);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);title('Trench_{Lock} - Plate_{70R}');
scatter(lock_plate70_info(:,2),lock_plate70_info(:,3), 5, lock_plate70_info(:,1), 'filled'); text(164.5,-33.5,'F', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); set(gca, 'CLim', [lim*-1 lim]); set(gca, 'FontSize', 10);
ax2 = nexttile(7);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(plate70_plate70_info(:,2),plate70_plate70_info(:,3), 5, plate70_plate70_info(:,1), 'filled'); 
colormap(ax2,mycolormap); set(gca, 'CLim', [lim*-1 lim]); 
set(gca, 'FontSize', 10);title('Plate_{70} - Plate_{70R}'); text(164.5,-33.5,'G', 'FontSize', 15, 'FontWeight', 'bold');

ax2 = nexttile(8);
set(gca,'XColor', 'none','YColor','none')
set(gca, 'color', 'none');
colormap(ax2,mycolormap);
c1 = colorbar('FontSize', 10); set(gca, 'CLim', [lim*-1 lim]); 
c1.Label.String = 'Difference (m)'; pos = get(c1,'Position'); 
set(c1,'Position',[0.7,0.539,0.0210,0.1838]); c1.AxisLocation = 'in';
c1.Label.Position = [2.1 pos(2)];

%%----------%%

ax3 = nexttile(9); 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, creep_info2); 
colormap(ax3,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 5]); 
set(gca, 'FontSize', 10); title('Trench_{Creep}'); ylabel('500-year return period','FontWeight','bold'); text(164.5,-33.5,'H', 'FontSize', 15, 'FontWeight', 'bold');
ax3 = nexttile(10);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, lock_info2); 
colormap(ax3,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 5]); 
set(gca, 'FontSize', 10); title('Trench_{Lock}'); text(164.5,-33.5,'I', 'FontSize', 15, 'FontWeight', 'bold');
ax3 = nexttile(11);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, plate70_full_info2); 
colormap(ax3,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 5]); 
set(gca, 'FontSize', 10); title('Plate_{70}'); text(164.5,-33.5,'J', 'FontSize', 15, 'FontWeight', 'bold');
ax3 =nexttile(12);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, plate70_info2); 
set(gca,'ColorScale','log', 'CLim', [0.1 10]); 
colormap(ax3,'parula');
c = colorbar('FontSize', 10); set(gca,'ColorScale','log', 'CLim', [0.1 5]);
c.Label.String = 'Wave height (m)'; pos = get(c,'Position'); c.Label.Position = [2 pos(2)+0.5];
c.Ticks = unique([0.1, 1, 5]);  
c.TickLabels{1} = '0.1'; c.TickLabels{2} = '1'; c.TickLabels{3} = '5'; 
set(gca, 'FontSize', 10); title('Plate_{70R}'); text(164.5,-33.5,'K', 'FontSize', 15, 'FontWeight', 'bold');


ax2 = nexttile(13);
hold on; xlim([166 179]); ylim([-48 -34]);title('Trench_{Creep} - Plate_{70R}');
yticks([-45 -40 -35]); xticks([170 175]);
scatter(creep_plate70_info2(:,2),creep_plate70_info2(:,3), 5, creep_plate70_info2(:,1), 'filled'); text(164.5,-33.5,'L', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); set(gca, 'FontSize', 10);set(gca, 'CLim', [lim2*-1 lim2]); ylabel('500-year difference','FontWeight','bold');
ax2 = nexttile(14);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(lock_plate70_info2(:,2),lock_plate70_info2(:,3), 5, lock_plate70_info2(:,1), 'filled'); text(164.3,-33.5,'M', 'FontSize', 15, 'FontWeight', 'bold');
colormap(ax2,mycolormap); set(gca, 'CLim', [lim2*-1 lim2]); set(gca, 'FontSize', 10);title('Trench_{Lock} - Plate_{70R}'); 
ax2 = nexttile(15);
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]); scatter(plate70_plate70_info2(:,2),plate70_plate70_info2(:,3), 5, plate70_plate70_info2(:,1), 'filled'); 
colormap(ax2,mycolormap); set(gca, 'CLim', [lim2*-1 lim2]); 
set(gca, 'FontSize', 10);title('Plate_{70} - Plate_{70R}'); text(164.5,-33.5,'N', 'FontSize', 15, 'FontWeight', 'bold'); 

ax2 = nexttile(16);
set(gca,'XColor', 'none','YColor','none')
set(gca, 'color', 'none');
colormap(ax2,mycolormap);
c2 = colorbar('FontSize', 10); set(gca, 'CLim', [lim2*-1 lim2]); c2.Label.Position = [2.1 pos(2)];
c2.Label.String = 'Difference (m)'; pos = get(c2,'Position'); 
set(c2,'Position',[0.7,0.0550,0.0210,0.1838]); c2.AxisLocation = 'in';
c2.Label.Position = [2.1 pos(2)];

%pos = get(gcf, 'Position')
set(gcf,'position',[538,16,763,980]) 
fig = gcf;
exportgraphics(fig, 'return_period_comparison_plate70_reduced.png', 'BackgroundColor','white') % this saves the figure

%%-----------------------------------------------------------------------%%
% Figure seven: characteristic earthquakes
% Format the zone information
coastal_points = load('coastal_points.mat');
coastal_x = coastal_points.coastal_points(:,1); coastal_y = coastal_points.coastal_points(:,2);

zones = readtable('zones_small_name_coord.txt'); zones_new = removevars(zones, {'Var6', 'Var7'});
temp_zones_matrix = table2array(zones_new); temp_zones_matrix(37462, :) = [];
zones_matrix = temp_zones_matrix;

NaN_rows = find(all(isnan(zones_matrix),2)); zone_number = [];
% Isolate zone names
for ii = 1:length(NaN_rows)-1
    row_value = NaN_rows(ii)+1;
    zone_num = zones_matrix(row_value, 5);
    zone_number = [zone_number, zone_num];
end
zone_numbers = [42, zone_number];
% Remove unnecessary information
for ii = 1:length(NaN_rows)-1
   x = find(all(isnan(zones_matrix), 2)); zones_matrix(x(ii)+1, :) = [];
end
%Make a series of variables for the zones
for ii = 1:length(x)
   zone_num =  zone_numbers(ii);
   name = ['zone', num2str(zone_num), '_coord'];
   if ii == 1
      lat_lon = zones_matrix(1:x(ii)-1, 1:2); 
   else
      lat_lon = zones_matrix(x(ii-1)+1:x(ii)-1, 1:2); 
   end
   assignin('base',name,lat_lon)
end
%%-----------%%
load('creep_coastal_data.mat'); 
load('lock_coastal_data.mat'); 
load('plate70_coastal_data.mat'); 

%%-----------%%
% Plate boundary
pac = load('pacific.mat'); lat = pac.pac(:,1); lon = pac.pac(:,2);

mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
mycolormap2 = customcolormap(linspace(0,1,11), {'#7f3c0a','#b35807','#e28212','#f9b967','#ffe0b2','#f7f7f5','#d7d9ee','#b3abd2','#8073a9','#562689','#2f004d'});

coastal_points = load('coastal_points.mat');
coastal_i = coastal_points.coastal_points(:,3); coastal_j = coastal_points.coastal_points(:,4);
coastal_x = coastal_points.coastal_points(:,1); coastal_y = coastal_points.coastal_points(:,2);

%%-----------%%
% Set 1:
creep_tsunami = creep_coastline(2:end,1); waveheight1 = creep_tsunami;
lock_tsunami = lock_coastline(2:end,355); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,30); waveheight3 = plate70_tsunami;

% Find the datapoints that fit into each of the zones
for dataset = 1:3
    if dataset == 1
        for zone = 1:252
            name = ['zone', num2str(zone), '_coord'];
            disp(['zone', num2str(zone)])
            eval(['d =', name, ';']);
            temp = [];
            for point = 1:length(waveheight1)
                x_point = coastal_x(point); y_point = coastal_y(point); 
                if inpolygon(x_point, y_point, d(:, 1), d(:, 2)) == 1
                   temp = [temp, waveheight1(point)];
                end    
            end
            data_name = ['zone', num2str(zone), '_data'];
            assignin('base', data_name, temp)
        end
        creep_zones = zeros(252, 2);
        for zone = 1:252
            disp(zone)
            name2 = ['zone', num2str(zone), '_data']; eval(['data =', name2, ';']);
            wave_height = quantile(data, 0.99); info = [zone, wave_height];
            creep_zones(zone, [1,2]) = info;
        end
    elseif dataset == 2
        for zone = 1:252
            name = ['zone', num2str(zone), '_coord'];
            disp(['zone', num2str(zone)])
            eval(['d =', name, ';']);
            temp = [];
            for point = 1:length(waveheight2)
                x_point = coastal_x(point); y_point = coastal_y(point); 
                if inpolygon(x_point, y_point, d(:, 1), d(:, 2)) == 1
                   temp = [temp, waveheight2(point)];
                end    
            end
            data_name = ['zone', num2str(zone), '_data'];
            assignin('base', data_name, temp)
        end
        lock_zones = zeros(252, 2);
        for zone = 1:252
            disp(zone)
            name2 = ['zone', num2str(zone), '_data']; eval(['data =', name2, ';']);
            wave_height = quantile(data, 0.99); info = [zone, wave_height];
            lock_zones(zone, [1,2]) = info;
        end
    else
        for zone = 1:252
            name = ['zone', num2str(zone), '_coord'];
            disp(['zone', num2str(zone)])
            eval(['d =', name, ';']);
            temp = [];
            for point = 1:length(waveheight3)
                x_point = coastal_x(point); y_point = coastal_y(point); 
                if inpolygon(x_point, y_point, d(:, 1), d(:, 2)) == 1
                   temp = [temp, waveheight3(point)];
                end    
            end
            data_name = ['zone', num2str(zone), '_data'];
            assignin('base', data_name, temp)
        end
        plate70_zones = zeros(252, 2);
        for zone = 1:252
            disp(zone)
            name2 = ['zone', num2str(zone), '_data']; eval(['data =', name2, ';']);
            wave_height = quantile(data, 0.99); info = [zone, wave_height];
            plate70_zones(zone, [1,2]) = info;
        end
    end
end

% Creep
event_path = 'creep_grd\'; event = 'creep_90905';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_creep = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_creep, Latitude_creep] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% Lock
event_path = 'lock_grd\'; event = 'lock_150129';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_187898';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 

f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1);
pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
set(gca,'Layer','top');
ylim([-45.5 -34]); xlim([171 182]);% 
text(169.5,-33.5,'A', 'FontSize', 15, 'FontWeight', 'bold');set(gca,'Layer','top');
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Creep}'); hold off;

ax2 =  nexttile(2); 
pcolor(Longitude_lock, Latitude_lock,  eventZ_NZTM_lock); colormap(ax2, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; hold on
set(gca,'Layer','top');
ylim([-45.5 -34]); xlim([171 182]);
text(169.5,-33.5,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Lock}'); hold off;

ax3 =  nexttile(3); 
pcolor(Longitude_plate70, Latitude_plate70,  eventZ_NZTM_plate70); colormap(ax3, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; a = colorbar('eastoutside', 'FontSize', 10); a.Label.String = 'Vertical displacement (m)';
a.Label.FontSize = 10; ylabel(a,'Displacement (m)','FontSize',10); hold on
set(gca,'Layer','top');
ylim([-45.5 -34]); xlim([171 182]);
text(169.5,-33.5,'C', 'FontSize', 15, 'FontWeight', 'bold');
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Plate_{70}');hold off;

ax4 =  nexttile(4); 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, creep_tsunami); 
colormap(ax4,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 10]);
set(gca, 'FontSize', 10); text(164.5,-33.5,'D', 'FontSize', 15, 'FontWeight', 'bold'); hold off;

ax5 =  nexttile(5); 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, lock_tsunami); 
colormap(ax5,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 10]);
set(gca, 'FontSize', 10); text(164.5,-33.5,'E', 'FontSize', 15, 'FontWeight', 'bold'); hold off;

ax6 =  nexttile(6); 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
scatter(coastal_x,coastal_y, 5, plate70_tsunami); 
colormap(ax6,'parula'); c = colorbar('FontSize', 10); set(gca,'ColorScale','log', 'CLim', [0.1 10]);
c.Label.String = 'Wave height (m)'; pos = get(c,'Position'); c.Label.Position = [2 pos(2)+0.9];
c.Ticks = unique([0.1, 1, 10]); c.TickLabels{1} = '0.1'; c.TickLabels{2} = '1'; c.TickLabels{3} = '10'; 
set(gca, 'FontSize', 10); text(164.5,-33.5,'F', 'FontSize', 15, 'FontWeight', 'bold'); hold off;

ax7 =  nexttile(7, [1,3]);
hold on;
l1 = plot(lock_zones(1:137, 1),lock_zones(1:137, 2), '-','Color', '#77AC30','LineWidth',2); plot(lock_zones(138:end, 1),lock_zones(138:end, 2), '-','Color', '#77AC30','LineWidth',2); 
c1 = plot(creep_zones(1:137, 1),creep_zones(1:137, 2), '-','Color', '#0072BD','LineWidth',2); plot(creep_zones(138:end, 1),creep_zones(138:end, 2), '-','Color', '#0072BD','LineWidth',2); 
p1 = plot(plate70_zones(1:137, 1),plate70_zones(1:137, 2), '-','Color', '#7E2F8E','LineWidth',2); plot(plate70_zones(138:end, 1),plate70_zones(138:end, 2), '-','Color', '#7E2F8E','LineWidth',2); 
set(gca, 'FontSize',10);
text(65,11,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.')
text(195,11,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 12]); ylabel('Wave height at coast (m)'); 
xlim([0 252]); xticks([1 31 65 73 91 111 144 150 190 210 232 247]); 
xticklabels({'Ahipara', 'Auckland', 'Gisborne','Napier','Wellington','New Plymouth','Kaikōura','Christchurch','Stewart Island','Milford Sound','Westport','Nelson'}); xtickangle(40)
lgd = legend(ax7,[c1,l1,p1], {'Trench_{Creep} Event Wave Height', 'Trench_{Lock} Event Wave Height', 'Plate_{70} Event Wave Height'}, 'Location','southoutside');
lgd.NumColumns = 3; legend('boxoff')
text(-15,12,'G', 'FontSize', 12, 'FontWeight', 'bold');
hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[453,181,697,802])
fig = gcf;
exportgraphics(fig, 'hazard_comparison_set1.png', 'BackgroundColor','white')

%%-----------------------------------------------------------------------%%
% Appendix figures:
%%-----------------------------------------------------------------------%%
% Figure: similar ruptures
% New Zealand coastline
% Plate boundary
pac = load('F:\PhD\figures_VUWcomputer\DataSets\pacific.mat'); lat = pac.pac(:,1); lon = pac.pac(:,2);

mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
mycolormap2 = customcolormap(linspace(0,1,11), {'#7f3c0a','#b35807','#e28212','#f9b967','#ffe0b2','#f7f7f5','#d7d9ee','#b3abd2','#8073a9','#562689','#2f004d'});

magnitudes = [8.0 8.25 8.5 8.75 9.0]; mag_events = [8 825 85 875 9];
mag_8 = [119135, 158818, 212595];
mag_825 = [112209, 130934, 189707];
mag_85 = [119831, 119873, 217141];
mag_875 = [93316, 111081, 188376]; 
mag_9 = [112545, 139606, 245420];

filename = ['layer03_x.dat']; layer03_x = importdata(filename);
filename = ['layer03_y.dat']; layer03_y = importdata(filename);


for mag = 4:4%length(magnitudes)
    disp(mag)
    eval(['event_numbers = mag_', num2str(mag_events(mag)), ';']);

    % Creep earthquake    
    event_path = 'creep_'; 
    eventX_NZTM = ncread([event_path, num2str(event_numbers(1)), '.grd'],'x'); eventY_NZTM = ncread([event_path, num2str(event_numbers(1)), '.grd'],'y'); eventZ_NZTM_creep = ncread([event_path, num2str(event_numbers(1)), '.grd'],'z'); 
    [NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_creep, Latitude_creep] = NZTM2Geo(NZTM_EE, NZTM_NN); 
    % Creep tsunami
    filename = ['zmax_layer03_creep_event', num2str(event_numbers(1)), '.dat'];
    layer03_max = importdata(filename); A1 = permute(layer03_max, [2 1]); B1 = reshape(A1, 1560, 2238); B1(any(isnan(B1), 2), :) = []; maximum_creep = B1.';

    % Lock Earthquake
    event_path = 'lock_'; 
    eventX_NZTM = ncread([event_path, num2str(event_numbers(2)), '.grd'],'x'); eventY_NZTM = ncread([event_path, num2str(event_numbers(2)), '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, num2str(event_numbers(2)), '.grd'],'z'); 
    [NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 
    % Lock Tsunami
    filename = ['zmax_layer03_lock_event', num2str(event_numbers(2)), '.dat'];
    layer03_max = importdata(filename); A1 = permute(layer03_max, [2 1]); B1 = reshape(A1, 1560, 2238); B1(any(isnan(B1), 2), :) = []; maximum_lock = B1.';

    % Plate70 earthquake
    event_path = 'plate70_'; 
    eventX_NZTM = ncread([event_path, num2str(event_numbers(3)), '.grd'],'x'); eventY_NZTM = ncread([event_path, num2str(event_numbers(3)), '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, num2str(event_numbers(3)), '.grd'],'z'); 
    [NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 
    % Plate70 Tsunami
    filename = ['plate70_tsunami\zmax_layer03_lock_event', num2str(event_numbers(3)), '.dat'];
    layer03_max = importdata(filename); A1 = permute(layer03_max, [2 1]); B1 = reshape(A1, 1560, 2238); B1(any(isnan(B1), 2), :) = []; maximum_plate70 = B1.';

    f = figure('visible','off');
    %figure
    tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
    ax1 =  nexttile(1); 
    pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([max(max(eventZ_NZTM_creep))*-1 max(max(eventZ_NZTM_creep))]); set(gca, 'FontSize',10);
    shading flat; hold on
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'black'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'black');
    %ylim([-45.5 -34]); xlim([171 182]);
    ylim([-40 -25]); xlim([175 186]);
    %text(171,-33.5,'A', 'FontSize', 15, 'FontWeight', 'bold'); 
    text(174,-24.5,'A', 'FontSize', 15, 'FontWeight', 'bold'); 
    yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
    title('Trench_{Creep}'); hold off;
    
    ax2 =  nexttile(2); 
    pcolor(Longitude_lock, Latitude_lock,  eventZ_NZTM_lock); colormap(ax2, mycolormap2); caxis([max(max(eventZ_NZTM_creep))*-1 max(max(eventZ_NZTM_creep))]);set(gca, 'FontSize',10);
    shading flat; hold on
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'black'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'black');
    %ylim([-45.5 -34]); xlim([171 182]);
    ylim([-40 -25]); xlim([175 186]);
    %text(171,-33.5,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
    text(174,-24.5,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
    yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
    title('Trench_{Lock}'); hold off;
    
    ax3 =  nexttile(3); 
    pcolor(Longitude_plate70, Latitude_plate70,  eventZ_NZTM_plate70); colormap(ax3, mycolormap2); caxis([max(max(eventZ_NZTM_creep))*-1 max(max(eventZ_NZTM_creep))]);set(gca, 'FontSize',10);
    shading flat; a = colorbar('eastoutside', 'FontSize', 10); a.Label.String = 'Vertical displacement (m)';
    a.Label.FontSize = 10; ylabel(a,'Displacement (m)','FontSize',10); hold on
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'black'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'black');
    %ylim([-45.5 -34]); xlim([171 182]);
    ylim([-40 -25]); xlim([175 186]);
    %text(171,-33.5,'C', 'FontSize', 15, 'FontWeight', 'bold');
    text(174,-24.5,'C', 'FontSize', 15, 'FontWeight', 'bold');
    yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
    title('Plate_{70}');hold off;
    
    ax4 =  nexttile(4); 
    pcolor(layer03_x, layer03_y, maximum_creep); shading flat; colormap(ax4, parula); hold on
    set(gca,'ColorScale','log', 'CLim', [0.1 20]);set(gca, 'FontSize',10);
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'white'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'white');
    xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
    title('Trench_{Creep} Tsunami'); text(165,-34,'D', 'FontSize', 15, 'FontWeight', 'bold'); hold off;
    
    ax5 =  nexttile(5);
    pcolor(layer03_x, layer03_y, maximum_lock); shading flat; colormap(ax5, parula); hold on
    set(gca,'ColorScale','log', 'CLim', [0.1 20]);set(gca, 'FontSize',10);
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'white'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'white');
    xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
    title('Trench_{Lock} Tsunami'); text(165,-34,'E', 'FontSize', 15, 'FontWeight', 'bold');hold off;
    
    ax6 =  nexttile(6); 
    pcolor(layer03_x, layer03_y, maximum_plate70); shading flat; colormap(ax6, parula); hold on
    set(gca,'ColorScale','log', 'CLim', [0.1 20]);set(gca, 'FontSize',10);
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'white'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'white');
    xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
    b = colorbar('FontSize', 10,'TickLabels', {'0.1','1','10'}); set(gca,'ColorScale','log', 'CLim', [0.1 10]);
    b.Label.String = 'Wave height (m)'; b.Label.FontSize = 10; pos = get(b,'Position'); b.Label.Position = [2.5 pos(2)+1.1]; 
    title('Plate_{70} Tsunami'); text(165,-34,'F', 'FontSize', 15, 'FontWeight', 'bold');hold off;
    
    ax7 =  nexttile(7); 
    pcolor(layer03_x, layer03_y, maximum_creep-maximum_lock); shading flat; colormap(ax7, mycolormap); hold on
    set(gca,'CLim', [-2 2]);set(gca, 'FontSize',10);
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'black'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'black');
    xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
    title('Trench_{Creep} - Trench_{Lock}'); text(165,-34,'G', 'FontSize', 15, 'FontWeight', 'bold');
    hold off;
    
    ax8 =  nexttile(8); 
    pcolor(layer03_x, layer03_y, maximum_creep-maximum_plate70); shading flat;
    colormap(ax8, mycolormap); hold on
    set(gca,'CLim', [-2 2]);set(gca, 'FontSize',10);
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'black'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'black');
    xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
    title('Trench_{Creep} - Plate_{70}'); text(165,-34,'H', 'FontSize', 15, 'FontWeight', 'bold');
    hold off;
    
    ax9 =  nexttile(9); % Coupling ML1a
    pcolor(layer03_x, layer03_y, maximum_lock-maximum_plate70); shading flat; 
    colormap(ax9, mycolormap); hold on
    set(gca,'CLim', [-2 2]);set(gca, 'FontSize',10);
    plot(NIx,NIy, 'LineWidth', 1, 'Color', 'black'); plot(SIx,SIy, 'LineWidth', 1, 'Color', 'black');
    xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]); set(gca, 'FontSize',10);
    c = colorbar('FontSize', 10); c.Label.String = 'Wave height (m)'; c.Label.FontSize = 10; pos = get(c,'Position'); c.Label.Position = [2.5 pos(2)+1.1];
    title('Trench_{Lock} - Plate_{70}'); text(165,-34,'I', 'FontSize', 15, 'FontWeight', 'bold'); hold off;
    
    sgtitle(['Magnitude ', num2str(magnitudes(mag)), ' Events'], 'FontWeight', 'bold');

    %pos = get(gcf, 'Position')
    set(gcf,'position',[413,42,827,954])
    fig = gcf;
    
    exportgraphics(fig, ['similar_events\magnitude', num2str(mag_events(mag)), '.png'], 'BackgroundColor','white')
end

%%-----------------------------------------------------------------------%%
% Figure: alternative return periods
% Tsunami data:
load('creep_coastal_data.mat'); creep = creep_coastline(2:end, :); 
load('lock_coastal_data.mat'); lock = lock_coastline(2:end, :); 
load('plate70_coastal_data.mat'); plate70 = plate70_coastline(2:end, :);

mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

coastal_points = load('C:\Users\hughesla\OneDrive - Victoria University of Wellington - STAFF\Documents\hazard_statistics\coastal_points.mat');
coastal_i = coastal_points.coastal_points(:,3); coastal_j = coastal_points.coastal_points(:,4);
coastal_x = coastal_points.coastal_points(:,1); coastal_y = coastal_points.coastal_points(:,2);

% creep tsunami hazard
t = maxk(creep, 3, 2); min_exceed = mink(t, 1,2); creep_10000 = round(min_exceed, 2);% 10000year return period 
t = maxk(creep, 6, 2); min_exceed = mink(t, 1,2); creep_5000 = round(min_exceed, 2);% 5000year return period 
t = maxk(creep, 12, 2); min_exceed = mink(t, 1,2); creep_2500 = round(min_exceed, 2);% 1500year return period 
t = maxk(creep, 20, 2); min_exceed = mink(t, 1,2); creep_1500 = round(min_exceed, 2);% 1500year return period 
t = maxk(creep, 30, 2); min_exceed = mink(t, 1,2); creep_1000 = round(min_exceed, 2); % 1000year return period
t = maxk(creep, 40, 2); min_exceed = mink(t, 1,2); creep_750 = round(min_exceed, 2);% 750year return period 
t = maxk(creep, 120, 2); min_exceed = mink(t, 1,2); creep_250 = round(min_exceed, 2);% 250year return period 
t = maxk(creep, 200, 2); min_exceed = mink(t, 1,2); creep_150 = round(min_exceed, 2);% 150year return period 

% lock tsunami hazard
t = maxk(lock, 3, 2); min_exceed = mink(t, 1,2); lock_10000 = round(min_exceed, 2);% 10000year return period 
t = maxk(lock, 6, 2); min_exceed = mink(t, 1,2); lock_5000 = round(min_exceed, 2);% 5000year return period 
t = maxk(lock, 12, 2); min_exceed = mink(t, 1,2); lock_2500 = round(min_exceed, 2);% 1500year return period  
t = maxk(lock, 20, 2); min_exceed = mink(t, 1,2); lock_1500 = round(min_exceed, 2);% 1500year return period 
t = maxk(lock, 30, 2); min_exceed = mink(t, 1,2); lock_1000 = round(min_exceed, 2); % 1000year return period
t = maxk(lock, 40, 2); min_exceed = mink(t, 1,2); lock_750 = round(min_exceed, 2);% 750year return period 
t = maxk(lock, 120, 2); min_exceed = mink(t, 1,2); lock_250 = round(min_exceed, 2);% 250year return period 
t = maxk(lock, 200, 2); min_exceed = mink(t, 1,2); lock_150 = round(min_exceed, 2);% 150year return period 

% plate70 tsunami hazard
t = maxk(plate70, 3, 2); min_exceed = mink(t, 1,2); plate70_10000 = round(min_exceed, 2);% 10000year return period 
t = maxk(plate70, 6, 2); min_exceed = mink(t, 1,2); plate70_5000 = round(min_exceed, 2);% 5000year return period 
t = maxk(plate70, 12, 2); min_exceed = mink(t, 1,2); plate70_2500 = round(min_exceed, 2);% 1500year return period  
t = maxk(plate70, 20, 2); min_exceed = mink(t, 1,2); plate70_1500 = round(min_exceed, 2);% 1500year return period  
t = maxk(plate70, 30, 2); min_exceed = mink(t, 1,2); plate70_1000 = round(min_exceed, 2); % 1000year return period
t = maxk(plate70, 40, 2); min_exceed = mink(t, 1,2); plate70_750 = round(min_exceed, 2);% 750year return period 
t = maxk(plate70, 120, 2); min_exceed = mink(t, 1,2); plate70_250 = round(min_exceed, 2);% 250year return period 
t = maxk(plate70, 200, 2); min_exceed = mink(t, 1,2); plate70_150 = round(min_exceed, 2);% 150year return period 


return_periods = [10000,5000,2500,1500,1000,750,250,150];

for ii = 8:length(return_periods)
    disp(return_periods(ii))

    eval(['creep_info = creep_', num2str(return_periods(ii)), ';']);
    eval(['lock_info = lock_', num2str(return_periods(ii)), ';']);
    eval(['plate70_info = plate70_', num2str(return_periods(ii)), ';']);


    creep_lock = creep_info - lock_info; temp = [creep_lock coastal_x coastal_y abs(creep_lock)]; creep_lock_info = sortrows(temp, 4);
    creep_plate70 = creep_info - plate70_info; temp = [creep_plate70 coastal_x coastal_y abs(creep_plate70)]; creep_plate70_info = sortrows(temp, 4);
    lock_plate70 = lock_info - plate70_info;temp = [lock_plate70 coastal_x coastal_y abs(lock_plate70)]; lock_plate70_info = sortrows(temp, 4);

    lim = round(max(lock_info-plate70_info))+2;

    f = figure('visible','off');
    %figure
    tlo = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
    % Maximum hazard
    ax1 = nexttile; % maximum hazard
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, creep_info); 
    colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 20]); 
    set(gca, 'FontSize', 10); title('Trench_{Creep}'); ylabel('Return period hazard','FontWeight','bold'); text(164.5,-34,'A', 'FontSize', 15, 'FontWeight', 'bold');
    ax1 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, lock_info); 
    colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 20]); 
    set(gca, 'FontSize', 10); title('Trench_{Lock}'); text(164.5,-34,'B', 'FontSize', 15, 'FontWeight', 'bold');
    ax1 =nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, plate70_info); 
    set(gca,'ColorScale','log', 'CLim', [0.1 20]); colormap(ax1,'parula');
    c = colorbar('FontSize', 10); set(gca,'ColorScale','log', 'CLim', [0.1 20]);
    c.Label.String = 'Wave height (m)'; pos = get(c,'Position'); c.Label.Position = [2 pos(2)+1.5];
    c.Ticks = unique([0.1, 1, 10, 20]); c.TickLabels{1} = '0.1'; c.TickLabels{2} = '1'; c.TickLabels{3} = '10'; c.TickLabels{4} = '20'; 
    set(gca, 'FontSize', 10); title('Plate_{70}'); text(164.5,-34,'C', 'FontSize', 15, 'FontWeight', 'bold');


    ax2 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]);
    scatter(creep_lock_info(:,2),creep_lock_info(:,3), 5, creep_lock_info(:,1), 'filled'); 
    colormap(ax2,mycolormap); set(gca, 'CLim', [lim*-1 lim]); 
    set(gca, 'FontSize', 10);title('Trench_{Creep} - Trench_{Lock}'); text(164.5,-34,'D', 'FontSize', 15, 'FontWeight', 'bold'); ylabel('Difference','FontWeight','bold');
    ax2 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);title('Trench_{Creep} - Plate_{70}');
    yticks([-45 -40 -35]); xticks([170 175]);
    scatter(creep_plate70_info(:,2),creep_plate70_info(:,3), 5, creep_plate70_info(:,1), 'filled'); 
    text(164.5,-34,'E', 'FontSize', 15, 'FontWeight', 'bold');
    colormap(ax2,mycolormap); set(gca, 'FontSize', 10);set(gca, 'CLim', [lim*-1 lim]);
    ax2 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]);
    scatter(lock_plate70_info(:,2),lock_plate70_info(:,3), 5, lock_plate70_info(:,1), 'filled'); 
     text(164.5,-34,'F', 'FontSize', 15, 'FontWeight', 'bold');
    colormap(ax2,mycolormap); set(gca, 'FontSize', 10); c = colorbar('FontSize', 10); set(gca, 'CLim', [lim*-1 lim]); 
    c.Label.String = 'Difference (m)'; pos = get(c,'Position'); c.Label.Position = [2.1 pos(2)];title('Trench_{Lock} - Plate_{70}');

    sgtitle([num2str(return_periods(ii)), '-year return period'], 'FontWeight', 'bold');

    %pos = get(gcf, 'Position')
    set(gcf,'position',[422, 396, 703, 582]) 
    fig = gcf;
    exportgraphics(fig, ['return_periods\', num2str(return_periods(ii)), 'return_period.png'], 'BackgroundColor','white') % this saves the figure
end

%%-----------------------------------------------------------------------%%
% Figure: alternative return periods using plate70R

% Tsunami data:
load('creep_coastal_data.mat'); creep = creep_coastline(2:end, :); 
load('lock_coastal_data.mat'); lock = lock_coastline(2:end, :); 
load('plate70_reduced_coastal_data.mat'); plate70 = plate70_reduced_coastline(2:end, :);

mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

coastal_points = load('coastal_points.mat');
coastal_i = coastal_points.coastal_points(:,3); coastal_j = coastal_points.coastal_points(:,4);
coastal_x = coastal_points.coastal_points(:,1); coastal_y = coastal_points.coastal_points(:,2);

% creep tsunami hazard
t = maxk(creep, 3, 2); min_exceed = mink(t, 1,2); creep_10000 = round(min_exceed, 2);% 10000year return period 
t = maxk(creep, 6, 2); min_exceed = mink(t, 1,2); creep_5000 = round(min_exceed, 2);% 5000year return period 
t = maxk(creep, 12, 2); min_exceed = mink(t, 1,2); creep_2500 = round(min_exceed, 2);% 1500year return period 
t = maxk(creep, 20, 2); min_exceed = mink(t, 1,2); creep_1500 = round(min_exceed, 2);% 1500year return period 
t = maxk(creep, 30, 2); min_exceed = mink(t, 1,2); creep_1000 = round(min_exceed, 2); % 1000year return period
t = maxk(creep, 40, 2); min_exceed = mink(t, 1,2); creep_750 = round(min_exceed, 2);% 750year return period 
t = maxk(creep, 120, 2); min_exceed = mink(t, 1,2); creep_250 = round(min_exceed, 2);% 250year return period 
t = maxk(creep, 200, 2); min_exceed = mink(t, 1,2); creep_150 = round(min_exceed, 2);% 150year return period 

% lock tsunami hazard
t = maxk(lock, 3, 2); min_exceed = mink(t, 1,2); lock_10000 = round(min_exceed, 2);% 10000year return period 
t = maxk(lock, 6, 2); min_exceed = mink(t, 1,2); lock_5000 = round(min_exceed, 2);% 5000year return period 
t = maxk(lock, 12, 2); min_exceed = mink(t, 1,2); lock_2500 = round(min_exceed, 2);% 1500year return period  
t = maxk(lock, 20, 2); min_exceed = mink(t, 1,2); lock_1500 = round(min_exceed, 2);% 1500year return period 
t = maxk(lock, 30, 2); min_exceed = mink(t, 1,2); lock_1000 = round(min_exceed, 2); % 1000year return period
t = maxk(lock, 40, 2); min_exceed = mink(t, 1,2); lock_750 = round(min_exceed, 2);% 750year return period 
t = maxk(lock, 120, 2); min_exceed = mink(t, 1,2); lock_250 = round(min_exceed, 2);% 250year return period 
t = maxk(lock, 200, 2); min_exceed = mink(t, 1,2); lock_150 = round(min_exceed, 2);% 150year return period 

% plate70 tsunami hazard
t = maxk(plate70, 3, 2); min_exceed = mink(t, 1,2); plate70_10000 = round(min_exceed, 2);% 10000year return period 
t = maxk(plate70, 6, 2); min_exceed = mink(t, 1,2); plate70_5000 = round(min_exceed, 2);% 5000year return period 
t = maxk(plate70, 12, 2); min_exceed = mink(t, 1,2); plate70_2500 = round(min_exceed, 2);% 1500year return period  
t = maxk(plate70, 20, 2); min_exceed = mink(t, 1,2); plate70_1500 = round(min_exceed, 2);% 1500year return period  
t = maxk(plate70, 30, 2); min_exceed = mink(t, 1,2); plate70_1000 = round(min_exceed, 2); % 1000year return period
t = maxk(plate70, 40, 2); min_exceed = mink(t, 1,2); plate70_750 = round(min_exceed, 2);% 750year return period 
t = maxk(plate70, 120, 2); min_exceed = mink(t, 1,2); plate70_250 = round(min_exceed, 2);% 250year return period 
t = maxk(plate70, 200, 2); min_exceed = mink(t, 1,2); plate70_150 = round(min_exceed, 2);% 150year return period 

return_periods = [10000,5000,2500,1500,1000,750,250,150];

for ii = 5:length(return_periods)
    disp(return_periods(ii))

    eval(['creep_info = creep_', num2str(return_periods(ii)), ';']);
    eval(['lock_info = lock_', num2str(return_periods(ii)), ';']);
    eval(['plate70_info = plate70_', num2str(return_periods(ii)), ';']);

    creep_lock = creep_info - lock_info; temp = [creep_lock coastal_x coastal_y abs(creep_lock)]; creep_lock_info = sortrows(temp, 4);
    creep_plate70 = creep_info - plate70_info; temp = [creep_plate70 coastal_x coastal_y abs(creep_plate70)]; creep_plate70_info = sortrows(temp, 4);
    lock_plate70 = lock_info - plate70_info;temp = [lock_plate70 coastal_x coastal_y abs(lock_plate70)]; lock_plate70_info = sortrows(temp, 4);

    lim = round(max(lock_info-plate70_info))+2;
    
    f = figure('visible','off');
    %figure
    tlo = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
    % Maximum hazard
    ax1 = nexttile; % maximum hazard
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, creep_info); 
    colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 20]); 
    set(gca, 'FontSize', 10); title('Trench_{Creep}'); ylabel('Return period hazard','FontWeight','bold'); text(164.5,-34,'A', 'FontSize', 15, 'FontWeight', 'bold');
    ax1 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, lock_info); 
    colormap(ax1,'parula'); set(gca,'ColorScale','log', 'CLim', [0.1 20]); 
    set(gca, 'FontSize', 10); title('Trench_{Lock}'); text(164.5,-34,'B', 'FontSize', 15, 'FontWeight', 'bold');
    ax1 =nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]); scatter(coastal_x,coastal_y, 5, plate70_info); 
    set(gca,'ColorScale','log', 'CLim', [0.1 20]); colormap(ax1,'parula');
    c = colorbar('FontSize', 10); set(gca,'ColorScale','log', 'CLim', [0.1 20]);
    c.Label.String = 'Wave height (m)'; pos = get(c,'Position'); c.Label.Position = [2 pos(2)+1.5];
    c.Ticks = unique([0.1, 1, 10, 20]); c.TickLabels{1} = '0.1'; c.TickLabels{2} = '1'; c.TickLabels{3} = '10'; c.TickLabels{4} = '20'; 
    set(gca, 'FontSize', 10); title('Plate_{70R}'); text(164.5,-34,'C', 'FontSize', 15, 'FontWeight', 'bold');


    ax2 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);
    yticks([-45 -40 -35]); xticks([170 175]);
    scatter(creep_lock_info(:,2),creep_lock_info(:,3), 5, creep_lock_info(:,1), 'filled'); 
    colormap(ax2,mycolormap); set(gca, 'CLim', [lim*-1 lim]); 
    set(gca, 'FontSize', 10);title('Trench_{Creep} - Trench_{Lock}'); text(164.5,-34,'D', 'FontSize', 15, 'FontWeight', 'bold'); ylabel('Difference','FontWeight','bold');
    ax2 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]);title('Trench_{Creep} - Plate_{70R}');
    yticks([-45 -40 -35]); xticks([170 175]);
    scatter(creep_plate70_info(:,2),creep_plate70_info(:,3), 5, creep_plate70_info(:,1), 'filled'); 
    text(164.5,-34,'E', 'FontSize', 15, 'FontWeight', 'bold');
    colormap(ax2,mycolormap); set(gca, 'FontSize', 10);set(gca, 'CLim', [lim*-1 lim]);
    ax2 = nexttile;
    hold on; xlim([166 179]); ylim([-48 -34]); yticks([-45 -40 -35]); xticks([170 175]);
    scatter(lock_plate70_info(:,2),lock_plate70_info(:,3), 5, lock_plate70_info(:,1), 'filled'); 
     text(164.5,-34,'F', 'FontSize', 15, 'FontWeight', 'bold');
    colormap(ax2,mycolormap); set(gca, 'FontSize', 10); c = colorbar('FontSize', 10); set(gca, 'CLim', [lim*-1 lim]); 
    c.Label.String = 'Difference (m)'; pos = get(c,'Position'); c.Label.Position = [2.1 pos(2)];title('Trench_{Lock} - Plate_{70R}');

    sgtitle([num2str(return_periods(ii)), '-year return period'], 'FontWeight', 'bold');

    %pos = get(gcf, 'Position')
    set(gcf,'position',[422, 396, 703, 582]) 
    fig = gcf;
    exportgraphics(fig, ['return_periods_reduced_plate70\', num2str(return_periods(ii)), 'return_period_plate70_reduced.png'], 'BackgroundColor','white') % this saves the figure
end













