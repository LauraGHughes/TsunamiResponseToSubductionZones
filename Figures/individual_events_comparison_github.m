% Set two:
load('creep_coastal_data.mat'); 
load('lock_coastal_data.mat'); 
load('plate70_coastal_data.mat'); 
%%-------------------------------------%%
% Set 2:
creep_tsunami = creep_coastline(2:end,18); waveheight1 = creep_tsunami;
lock_tsunami = lock_coastline(2:end,31); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,109); waveheight3 = plate70_tsunami;

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
event_path = 'creep_grd\'; event = 'creep_92718';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_creep = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_creep, Latitude_creep] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% Lock
event_path = 'lock_grd\'; event = 'lock_110753';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_195918';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 

f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1); 
pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
ylim([-45.5 -34]); xlim([171 182]);% 
text(169.5,-33.5,'A', 'FontSize', 15, 'FontWeight', 'bold');set(gca,'Layer','top');
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Creep}'); hold off;

ax2 =  nexttile(2); 
pcolor(Longitude_lock, Latitude_lock, eventZ_NZTM_lock); colormap(ax2, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; hold on
ylim([-45.5 -34]); xlim([171 182]);
text(169.5,-33.5,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Lock}'); hold off;

ax3 =  nexttile(3); 
pcolor(Longitude_plate70, Latitude_plate70,  eventZ_NZTM_plate70); colormap(ax3, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; a = colorbar('eastoutside', 'FontSize', 10); a.Label.String = 'Vertical displacement (m)';
a.Label.FontSize = 10; ylabel(a,'Displacement (m)','FontSize',10); hold on
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
exportgraphics(fig, 'hazard_comparison_set2.png', 'BackgroundColor','white')

%%-----------------------------------------------------------------------%%
% Set 3:
lock_tsunami = lock_coastline(2:end,213); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,370); waveheight3 = plate70_tsunami;

% Find the datapoints that fit into each of the zones
for dataset = 2:3
    if dataset == 2
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

% Lock
event_path = 'lock_grd\'; event = 'lock_132874';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_225365';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 
f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1);
%pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
ylim([-45.5 -34]); xlim([171 182]);% 
text(169.5,-33.5,'A', 'FontSize', 15, 'FontWeight', 'bold');set(gca,'Layer','top');
% ylim([-41 -30]); xlim([175 185]);
% text(172,-29,'A', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Creep}'); hold off;

ax2 =  nexttile(2); 
pcolor(Longitude_lock, Latitude_lock,  eventZ_NZTM_lock); colormap(ax2, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; hold on
ylim([-45.5 -34]); xlim([171 182]);
text(169.5,-33.5,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
% ylim([-41 -30]); xlim([175 185]);
% text(172,-29,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Lock}'); hold off;

ax3 =  nexttile(3); 
pcolor(Longitude_plate70, Latitude_plate70,  eventZ_NZTM_plate70); colormap(ax3, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; a = colorbar('eastoutside', 'FontSize', 10); a.Label.String = 'Vertical displacement (m)';
a.Label.FontSize = 10; ylabel(a,'Displacement (m)','FontSize',10); hold on
ylim([-45.5 -34]); xlim([171 182]);
text(169.5,-33.5,'C', 'FontSize', 15, 'FontWeight', 'bold');
% ylim([-41 -30]); xlim([175 185]);
% text(172,-29,'C', 'FontSize', 15, 'FontWeight', 'bold');
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Plate_{70}');hold off;

ax4 =  nexttile(4); 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
%scatter(coastal_x,coastal_y, 5, creep_tsunami); 
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
%c1 = plot(creep_zones(1:137, 1),creep_zones(1:137, 2), '-','Color', '#0072BD','LineWidth',2); plot(creep_zones(138:end, 1),creep_zones(138:end, 2), '-','Color', '#0072BD','LineWidth',2); 
p1 = plot(plate70_zones(1:137, 1),plate70_zones(1:137, 2), '-','Color', '#7E2F8E','LineWidth',2); plot(plate70_zones(138:end, 1),plate70_zones(138:end, 2), '-','Color', '#7E2F8E','LineWidth',2); 
%legend(ax4, {'Trench_{Lock}', 'Trench_{Creep}', 'Plate_{70}'}, 'Location','northwest'); legend('boxoff')
set(gca, 'FontSize',10);
text(65,15,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.')
text(195,15,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 16]); ylabel('Wave height at coast (m)'); 
xlim([0 252]); xticks([1 31 65 73 91 111 144 150 190 210 232 247]); 
xticklabels({'Ahipara', 'Auckland', 'Gisborne','Napier','Wellington','New Plymouth','Kaikōura','Christchurch','Stewart Island','Milford Sound','Westport','Nelson'}); xtickangle(40)
lgd = legend(ax7,[l1,p1], {'Trench_{Lock} Event Wave Height', 'Plate_{70} Event Wave Height'}, 'Location','southoutside');
lgd.NumColumns = 2; legend('boxoff')
text(-15,16,'G', 'FontSize', 12, 'FontWeight', 'bold');
hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[453,181,697,802])
fig = gcf;
exportgraphics(fig, 'hazard_comparison_set3.png', 'BackgroundColor','white')
%%-----------------------------------------------------------------------%%
% Set 4:
lock_tsunami = lock_coastline(2:end,245); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,344); waveheight3 = plate70_tsunami;

% Find the datapoints that fit into each of the zones
for dataset = 2:3
    if dataset == 2
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

% Lock
event_path = 'lock_grd\'; event = 'lock_136667';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_221469';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 

f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1); 
%pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
ylim([-41 -30]); xlim([175 185]);
text(172,-29,'A', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Creep}'); hold off;

ax2 =  nexttile(2); 
pcolor(Longitude_lock, Latitude_lock,  eventZ_NZTM_lock); colormap(ax2, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; hold on
ylim([-41 -30]); xlim([175 185]);
text(172,-29,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Lock}'); hold off;

ax3 =  nexttile(3); 
pcolor(Longitude_plate70, Latitude_plate70,  eventZ_NZTM_plate70); colormap(ax3, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; a = colorbar('eastoutside', 'FontSize', 10); a.Label.String = 'Vertical displacement (m)';
a.Label.FontSize = 10; ylabel(a,'Displacement (m)','FontSize',10); hold on
ylim([-41 -30]); xlim([175 185]);
text(172,-29,'C', 'FontSize', 15, 'FontWeight', 'bold');
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Plate_{70}');hold off;

ax4 =  nexttile(4); 
hold on; xlim([166 179]); ylim([-48 -34]);
yticks([-45 -40 -35]); xticks([170 175]);
%scatter(coastal_x,coastal_y, 5, creep_tsunami); 
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
%c1 = plot(creep_zones(1:137, 1),creep_zones(1:137, 2), '-','Color', '#0072BD','LineWidth',2); plot(creep_zones(138:end, 1),creep_zones(138:end, 2), '-','Color', '#0072BD','LineWidth',2); 
p1 = plot(plate70_zones(1:137, 1),plate70_zones(1:137, 2), '-','Color', '#7E2F8E','LineWidth',2); plot(plate70_zones(138:end, 1),plate70_zones(138:end, 2), '-','Color', '#7E2F8E','LineWidth',2); 
%legend(ax4, {'Trench_{Lock}', 'Trench_{Creep}', 'Plate_{70}'}, 'Location','northwest'); legend('boxoff')
set(gca, 'FontSize',10);
text(65,11,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.')
text(195,11,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 12]); ylabel('Wave height at coast (m)'); 
xlim([0 252]); xticks([1 31 65 73 91 111 144 150 190 210 232 247]); 
xticklabels({'Ahipara', 'Auckland', 'Gisborne','Napier','Wellington','New Plymouth','Kaikōura','Christchurch','Stewart Island','Milford Sound','Westport','Nelson'}); xtickangle(40)
lgd = legend(ax7,[l1,p1], {'Trench_{Lock} Event Wave Height', 'Plate_{70} Event Wave Height'}, 'Location','southoutside');
lgd.NumColumns = 2; legend('boxoff')
text(-15,12,'G', 'FontSize', 12, 'FontWeight', 'bold');
hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[453,181,697,802])
fig = gcf;
exportgraphics(fig, 'hazard_comparison_set4.png', 'BackgroundColor','white')
%%-----------------------------------------------------------------------%%
% Set 5:
lock_tsunami = lock_coastline(2:end,266); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,494); waveheight3 = plate70_tsunami;

% Find the datapoints that fit into each of the zones
for dataset = 2:3
    if dataset == 2
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

% Lock
event_path = 'lock_grd\'; event = 'lock_139606';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_237931';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 


f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1); 
%pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
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
%scatter(coastal_x,coastal_y, 5, creep_tsunami); 
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
%c1 = plot(creep_zones(1:137, 1),creep_zones(1:137, 2), '-','Color', '#0072BD','LineWidth',2); plot(creep_zones(138:end, 1),creep_zones(138:end, 2), '-','Color', '#0072BD','LineWidth',2); 
p1 = plot(plate70_zones(1:137, 1),plate70_zones(1:137, 2), '-','Color', '#7E2F8E','LineWidth',2); plot(plate70_zones(138:end, 1),plate70_zones(138:end, 2), '-','Color', '#7E2F8E','LineWidth',2); 
%legend(ax4, {'Trench_{Lock}', 'Trench_{Creep}', 'Plate_{70}'}, 'Location','northwest'); legend('boxoff')
set(gca, 'FontSize',10);
text(65,15,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.')
text(195,15,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 16]); ylabel('Wave height at coast (m)'); 
xlim([0 252]); xticks([1 31 65 73 91 111 144 150 190 210 232 247]); 
xticklabels({'Ahipara', 'Auckland', 'Gisborne','Napier','Wellington','New Plymouth','Kaikōura','Christchurch','Stewart Island','Milford Sound','Westport','Nelson'}); xtickangle(40)
lgd = legend(ax7,[l1,p1], {'Trench_{Lock} Event Wave Height', 'Plate_{70} Event Wave Height'}, 'Location','southoutside');
lgd.NumColumns = 2; legend('boxoff')
text(-15,16,'G', 'FontSize', 12, 'FontWeight', 'bold');
hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[453,181,697,802])
fig = gcf;
exportgraphics(fig, 'hazard_comparison_set5.png', 'BackgroundColor','white')
%%-----------------------------------------------------------------------%%
% Set 6:
creep_tsunami = creep_coastline(2:end,121); waveheight1 = creep_tsunami;
lock_tsunami = lock_coastline(2:end,270); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,35); waveheight3 = plate70_tsunami;

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
event_path = 'creep_grd\'; event = 'creep_101611';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_creep = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_creep, Latitude_creep] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% Lock
event_path = 'lock_grd\'; event = 'lock_140156';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_188569';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 

f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1); 
pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
ylim([-41 -30]); xlim([175 185]);
text(172,-29,'A', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Creep}'); hold off;

ax2 =  nexttile(2); 
pcolor(Longitude_lock, Latitude_lock,  eventZ_NZTM_lock); colormap(ax2, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; hold on
set(gca,'Layer','top');
ylim([-41 -30]); xlim([175 185]);
text(172,-29,'B', 'FontSize', 15, 'FontWeight', 'bold'); 
yticks([-45 -40 -35 -30 -25]); xticks([170 175 180 185]); 
title('Trench_{Lock}'); hold off;

ax3 =  nexttile(3); 
pcolor(Longitude_plate70, Latitude_plate70,  eventZ_NZTM_plate70); colormap(ax3, mycolormap2); caxis([-5 5]);set(gca, 'FontSize',10);
shading flat; a = colorbar('eastoutside', 'FontSize', 10); a.Label.String = 'Vertical displacement (m)';
a.Label.FontSize = 10; ylabel(a,'Displacement (m)','FontSize',10); hold on
set(gca,'Layer','top');
ylim([-41 -30]); xlim([175 185]);
text(172,-29,'C', 'FontSize', 15, 'FontWeight', 'bold');
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
%legend(ax4, {'Trench_{Lock}', 'Trench_{Creep}', 'Plate_{70}'}, 'Location','northwest'); legend('boxoff')
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
exportgraphics(fig, 'hazard_comparison_set6.png', 'BackgroundColor','white')
%%-----------------------------------------------------------------------%%
% Set 7:
creep_tsunami = creep_coastline(2:end,46); waveheight1 = creep_tsunami;
lock_tsunami = lock_coastline(2:end,340); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,303); waveheight3 = plate70_tsunami;

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
event_path = 'creep_grd\'; event = 'creep_94781';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_creep = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_creep, Latitude_creep] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% Lock
event_path = 'lock_grd\'; event = 'lock_148944';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_216830';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 

f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1); 
pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
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
%legend(ax4, {'Trench_{Lock}', 'Trench_{Creep}', 'Plate_{70}'}, 'Location','northwest'); legend('boxoff')
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
exportgraphics(fig, 'hazard_comparison_set7.png', 'BackgroundColor','white')
%%-----------------------------------------------------------------------%%
% Set 8:
creep_tsunami = creep_coastline(2:end,25); waveheight1 = creep_tsunami;
lock_tsunami = lock_coastline(2:end,9); waveheight2 = lock_tsunami;
plate70_tsunami = plate70_coastline(2:end,42); waveheight3 = plate70_tsunami;

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
event_path = 'creep_grd\'; event = 'creep_93113';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_creep = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_creep, Latitude_creep] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% Lock
event_path = 'lock_grd\'; event = 'lock_107945';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_lock = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_lock, Latitude_lock] = NZTM2Geo(NZTM_EE, NZTM_NN); 

% plate70
event_path = 'plate70_grd\'; event = 'plate70_189388';
eventX_NZTM = ncread([event_path, event, '.grd'],'x'); eventY_NZTM = ncread([event_path, event, '.grd'],'y'); eventZ_NZTM_plate70 = ncread([event_path, event, '.grd'],'z'); 
[NZTM_NN, NZTM_EE] = meshgrid(eventY_NZTM, eventX_NZTM); [Longitude_plate70, Latitude_plate70] = NZTM2Geo(NZTM_EE, NZTM_NN); 

f = figure('visible','off');
%figure
tlo = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
ax1 =  nexttile(1); 
pcolor(Longitude_creep, Latitude_creep,  eventZ_NZTM_creep); colormap(ax1, mycolormap2); caxis([-5 5]); shading flat;
set(gca, 'FontSize',10); set(gca,'Layer','top');
hold on
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
%legend(ax4, {'Trench_{Lock}', 'Trench_{Creep}', 'Plate_{70}'}, 'Location','northwest'); legend('boxoff')
set(gca, 'FontSize',10);
text(65,7,'North Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center'); 
xline(137.5, '-.')
text(195,7,'South Island','Color','black','FontSize',11, 'HorizontalAlignment', 'center');
ylim([0.1 8]); ylabel('Wave height at coast (m)'); 
xlim([0 252]); xticks([1 31 65 73 91 111 144 150 190 210 232 247]); 
xticklabels({'Ahipara', 'Auckland', 'Gisborne','Napier','Wellington','New Plymouth','Kaikōura','Christchurch','Stewart Island','Milford Sound','Westport','Nelson'}); xtickangle(40)
lgd = legend(ax7,[c1,l1,p1], {'Trench_{Creep} Event Wave Height', 'Trench_{Lock} Event Wave Height', 'Plate_{70} Event Wave Height'}, 'Location','southoutside');
lgd.NumColumns = 3; legend('boxoff')
text(-15,8,'G', 'FontSize', 12, 'FontWeight', 'bold');
hold off;

%pos = get(gcf, 'Position')
set(gcf,'position',[453,181,697,802])
fig = gcf;
exportgraphics(fig, 'hazard_comparison_set8.png', 'BackgroundColor','white')






