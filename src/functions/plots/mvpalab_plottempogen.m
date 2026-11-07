function [] = mvpalab_plottempogen(graph,cfg,data,stats)
%% MVPALAB_PLOTTEMPOGEN
%
%  This function plots a temporal generalization matrix in the current
%  axes: the mean across subjects, or one subject (graph.subject, see
%  mvpalab_selectsub).
%
%  With stats, the contours of the significant clusters above
%  (graph.stats.above) and below (graph.stats.below) chance are drawn.
%  If graph has the field onscreen (two times), dash-dot lines are drawn
%  at both times on the two axes. If graph.caxis is zero, the color
%  limits are the minimum and maximum of the matrix. If cfg.tm.tpstart_ and cfg.tm.tpend_ are 0 (older
%  versions of MVPAlab), cfg.tm.tpstart and cfg.tm.tpend are used.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit).
%
%  - {struct} - cfg:
%    Configuration structure (cfg.tm).
%
%  - {matrix} - data:
%    Temporal generalization matrix [ntp x ntp_ x subjects].
%
%  - {struct} - stats (optional):
%    Statistics of the matrix, with stats.clusters, stats.clusters_,
%    stats.sigmask and stats.sigmask_ (see mvpalab_computepermtest).

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

% Bug fix for older versions of mvpalab:
if ~cfg.tm.tpstart_ && ~cfg.tm.tpend_
    cfg.tm.tpstart_ = cfg.tm.tpstart;
    cfg.tm.tpend_ = cfg.tm.tpend;
end

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Plot temporal generalization results:
y = linspace(cfg.tm.tpstart,cfg.tm.tpend,size(data,1));
x = linspace(cfg.tm.tpstart_,cfg.tm.tpend_,size(data,2));
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

if any(graph.caxis)
    caxis(graph.caxis);
else
    caxis([min(min(acc_map)) max(max(acc_map))]);
end

end

