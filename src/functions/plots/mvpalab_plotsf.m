function [] = mvpalab_plotsf(graph,cfg,data,stats )
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Plot the results:
x = linspace(cfg.tm.tpstart,cfg.tm.tpend,size(data,2));
y = cfg.sf.freqvec+cfg.sf.hbw;
acc_map = mean(data,3);
contourf(x,y,acc_map,30,'LineStyle','none')
hold on
set(gca, 'YDir','normal')

if strcmp(cfg.sf.fspac,'log')
    set(gca,'YScale','log')
end

if exist('stats','var')
    if ~isempty(stats.clusters)
        contour(x,y,stats.sigmask,1,...
            'LineWidth',graph.clusterLineWidth,...
            'LineColor',graph.clusterLineColor);
    end
    if ~isempty(stats.clusters_)
        contour(x,y,stats.sigmask_,1,...
            'LineWidth',graph.clusterLineWidth_,...
            'LineColor',graph.clusterLineColor_);
    end
end

%% Configure plot appearance:
xlabel('Time (ms)');
ylabel('Removed frequencies (Hz) ');
colorbar('Eastoutside');

set(gca,'XMinorTick','on','YMinorTick','on');
set(gca,'XTickLabelRotation',90);
set(gca,'YAxisLocation','origin');
set(gca,'XAxisLocation','origin');
set(gca,'YColor','k');
set(gca,'XColor','k');
set(gca,'FontSize',graph.fontsize);
set(gca,'Layer','top');

set(gca,'XTick',graph.xlim(1):100:graph.xlim(2))

for i = 1 : length(cfg.sf.fcutoff)
    v(i) = cfg.sf.fcutoff{i}(2);
end

set(gca,'YTick',v);

if graph.caxis == 0
    caxis([min(min(acc_map)) max(max(acc_map))]);
else
    caxis(graph.caxis);
end

colormap(graph.colorMap);

end

