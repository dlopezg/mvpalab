function [] = mvpalab_plottempogen(graph,cfg,data,stats)
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Plot temporal generalization results:
x = linspace(cfg.tm.tpstart,cfg.tm.tpend,size(data,1));
y = x;
acc_map = mean(data,3);
contourf(x,y,acc_map,16,'LineStyle','none')
hold on

%% Plot significant clusters:
if exist('stats','var')
    if ~isempty(stats.clusters) && graph.stats.above
        contour(x,y,stats.sigmask,1,...
            'LineWidth',graph.clusterLineWidth,...
            'LineColor',graph.clusterLineColor);
    end
    if ~isempty(stats.clusters_) && graph.stats.below
        contour(x,y,stats.sigmask_,1,...
            'LineWidth',graph.clusterLineWidth_,...
            'LineColor',graph.clusterLineColor_);
    end
end

%% Plot stim onscreen:
if isfield(graph,'onscreen')
    vline(graph.onscreen(1),'k-.')
    vline(graph.onscreen(2),'k-.')
    hline(graph.onscreen(1),'k-.')
    hline(graph.onscreen(2),'k-.')
end

%% Configure plot appearance:
title(graph.title)
xlabel(graph.xlabel);
ylabel(graph.ylabel);

xlim(graph.xlim);
ylim(graph.ylim);

colorbar('Eastoutside');
colormap(graph.colorMap);

set(gca,'XMinorTick','on','YMinorTick','on');
set(gca,'XTickLabelRotation',90);
set(gca,'YAxisLocation','origin');
set(gca,'XAxisLocation','origin');
set(gca,'YColor','k');
set(gca,'XColor','k');
set(gca,'FontSize',graph.fontsize);
set(gca,'Layer','top');

if abs(sum(graph.caxis(1)))
    caxis(graph.caxis);
else
    caxis([min(min(acc_map)) max(max(acc_map))]);
end

end

