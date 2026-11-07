function mvpalab_plottempogen(graph,cfg,data,stats)
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
%  limits are the minimum and maximum of the matrix (see
%  mvpalab_mapstyle). The axes are the timepoints of the analysis,
%  cfg.tm.times (training) and cfg.tm.times_ (test); a configuration of
%  an older version without cfg.tm.times_ uses cfg.tm.times for both.
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
%    Statistics of the matrix, with stats.sigmask and stats.sigmask_ (see
%    mvpalab_computepermtest), or empty.

if nargin < 4, stats = []; end

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Plot temporal generalization results:
y = cfg.tm.times;
x = cfg.tm.times;
if isfield(cfg.tm,'times_'), x = cfg.tm.times_; end
map = mean(data,3);
contourf(x,y,map,16,'LineStyle','none')
hold on
mvpalab_plotclusters(graph,x,y,stats);

%% Plot stim onscreen:
if isfield(graph,'onscreen')
    vline(graph.onscreen(1),'k-.')
    vline(graph.onscreen(2),'k-.')
    hline(graph.onscreen(1),'k-.')
    hline(graph.onscreen(2),'k-.')
end

%% Configure plot appearance:
mvpalab_mapstyle(graph,map);

end
