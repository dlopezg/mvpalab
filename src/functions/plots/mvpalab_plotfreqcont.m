function mvpalab_plotfreqcont(graph,cfg,data,stats)
%% MVPALAB_PLOTFREQCONT
%
%  This function plots the frequency contribution map of a sliding filter
%  analysis in the current axes: the mean across subjects for each
%  frequency band and timepoint, or one subject (graph.subject, see
%  mvpalab_selectsub). It needs at least two frequency bands in
%  cfg.sf.freqvec.
%
%  With stats, the contours of the significant clusters above
%  (graph.stats.above) and below (graph.stats.below) chance are drawn.
%  If graph.caxis is zero, the color limits are the minimum and maximum
%  of the map (see mvpalab_mapstyle). The time axis is the timepoints of
%  the analysis (cfg.tm.times) and the frequency axis the high cutoff of
%  each band, in log scale with cfg.sf.fspac = 'log'.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit).
%
%  - {struct} - cfg:
%    Configuration structure (cfg.tm and cfg.sf).
%
%  - {matrix} - data:
%    Frequency contribution map [bands x timepoints x subjects].
%
%  - {struct} - stats (optional):
%    Statistics of the map, with stats.sigmask and stats.sigmask_ (see
%    mvpalab_computepermtest), or empty.

if nargin < 4, stats = []; end

% Check cfg structure:
cfg = mvpalab_updatecfg(cfg);

if length(cfg.sf.freqvec) < 2
    error('The frequency contribution map needs at least two frequency bands.');
end

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Plot the results:
x = cfg.tm.times;
y = cfg.sf.freqvec + cfg.sf.hbw;
map = mean(data,3);
contourf(x,y,map,30,'LineStyle','none')
hold on
set(gca,'YDir','normal')
if strcmp(cfg.sf.fspac,'log'), set(gca,'YScale','log'); end
mvpalab_plotclusters(graph,x,y,stats);

%% Configure plot appearance:
mvpalab_mapstyle(graph,map);
set(gca,'XTick',graph.xlim(1):100:graph.xlim(2));
set(gca,'YTick',round(y,2));

end
