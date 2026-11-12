function mvpalab_plotdecoding(graph,cfg,data,stats)
%% MVPALAB_PLOTDECODING
%
%  This function plots a time-resolved result in the current axes: the
%  mean across subjects (graph.plotmean), a shade with the STD or the SEM
%  (graph.stdsem) and a dotted line at the chance level (graph.chanlvl).
%  The data can be smoothed for the plot with a moving mean of
%  graph.smoothdata timepoints (1 for no smoothing) and one subject can be
%  selected (graph.subject, see mvpalab_selectsub). An empty graph.xlim
%  keeps the limits of the data.
%
%  With stats, the significant timepoints above (graph.stats.above) and
%  below (graph.stats.below) chance are shown as a shade
%  (graph.sigmode.shade: the band is grey and coloured at the significant
%  timepoints, half a timepoint to each side) or as points at height
%  graph.sigh (graph.sigmode.points). Above chance they use
%  graph.shadecolor in the shade and graph.sigc in the points, and below
%  chance graph.sigc_. Without stats, or without a selected tail, the band
%  is coloured.
%
%%  INPUT:
%
%  - {struct} - graph:
%    Parameters of the plot (see mvpalab_plotinit).
%
%  - {struct} - cfg:
%    Configuration structure (cfg.tm.times).
%
%  - {matrix} - data:
%    Time-resolved result [1 x timepoints x subjects].
%
%  - {struct} - stats (optional):
%    Statistics of the result, with the masks of the significant
%    clusters stats.sigmask and stats.sigmask_ (see
%    mvpalab_computepermtest), or empty.

if nargin < 4 || ~(graph.stats.above || graph.stats.below), stats = []; end

cfg = mvpalab_updatecfg(cfg);
times = cfg.tm.times;

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Mean and STD/SEM, smoothed for the representation if needed:
if graph.smoothdata > 1, data = movmean(data,graph.smoothdata,2); end
datamean = mean(data,3);

stdsem = std(data,0,3,'omitnan');
if ~graph.stdsem, stdsem = stdsem/sqrt(size(data,3)); end

%% Error band and significant timepoints:
shade = ~isempty(stats) && graph.sigmode.shade;
points = ~isempty(stats) && graph.sigmode.points;

if shade
    plotband(times,datamean,stdsem,1:numel(times),[.7 .7 .7],.5);
    [above,below] = sigmask(graph,stats);
    tails = {above,graph.shadecolor;below,graph.sigc_};
    for tail = 1 : 2
        segments = bwconncomp(tails{tail,1});
        for i = 1 : segments.NumObjects
            plotband(times,datamean,stdsem,segments.PixelIdxList{i},...
                tails{tail,2},graph.shadealpha);
        end
    end
else
    plotband(times,datamean,stdsem,1:numel(times),...
        graph.shadecolor,graph.shadealpha);
end

if points
    [above,below] = sigmask(graph,stats);
    scatter(times(above),graph.sigh*ones(1,nnz(above)),80,graph.sigc,'filled','s');
    scatter(times(below),graph.sigh*ones(1,nnz(below)),80,graph.sigc_,'filled','s');
end

if graph.plotmean
    plot(times,datamean,...
        'color',graph.shadecolor,...
        'linewidth',graph.linewidth,...
        'linestyle',graph.linestyle);
end

plot(times,zeros(size(times)) + graph.chanlvl,'k','LineWidth',.5,'LineStyle',':');

%%  Graph configuration:
set(gca,'Color','w')
set(gca,'XGrid','on');
set(gca,'YAxisLocation','origin');
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'XTickLabelRotation',90);
set(gca,'FontSize',graph.fontsize)

xlabel(graph.xlabel);
ylabel(graph.ylabel);
ylim(graph.ylim)
if ~isempty(graph.xlim), xlim(graph.xlim); end
limits = xlim;
set(gca,'XTick',limits(1):100:limits(2))
set(gca,'YTick',graph.ylim(1):.05:graph.ylim(2))
title(graph.title);
set(gca,'Layer','top')

end

function [above,below] = sigmask(graph,stats)
%% Significant timepoints above and below chance, in the selected tails
%  [1 x timepoints].

above = ~stats.sigmask & graph.stats.above;
below = ~stats.sigmask_ & graph.stats.below;

end

function plotband(times,datamean,stdsem,idx,color,alpha)
%% Band of the mean plus and minus the STD/SEM at the timepoints idx,
%  half a timepoint wider at each side (inside the times), so a single
%  timepoint is visible.

idx = idx(:)';
half = (times(end) - times(1))/(numel(times) - 1)/2;
t = [max(times(idx(1)) - half,times(1)) times(idx) ...
    min(times(idx(end)) + half,times(end))];
idx = idx([1 1:end end]);
upper = datamean(idx) + stdsem(idx);
lower = datamean(idx) - stdsem(idx);
fill([t fliplr(t)],[upper fliplr(lower)],color,'FaceAlpha',alpha,'linestyle','none');

end
