function mvpalab_plotdecoding(graph,cfg,data,stats)
%% MVPALAB_PLOTDECODING
%
%  This function plots a time-resolved result in the current axes: the
%  mean across subjects (graph.plotmean), a shade with the STD or the SEM
%  (graph.stdsem) and a dotted line at the chance level (graph.chanlvl).
%  The data can be smoothed for the plot (graph.smoothdata) and one
%  subject can be selected (graph.subject, see mvpalab_selectsub).
%
%  With stats, the significant timepoints above (graph.stats.above) and
%  below (graph.stats.below) chance are shown as a shade
%  (graph.sigmode.shade: the band is grey and coloured at the significant
%  timepoints) or as points at height graph.sigh (graph.sigmode.points).
%  Without stats, or without a selected tail, the band is coloured.
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

% Check cfg structure:
cfg = mvpalab_updatecfg(cfg);
times = cfg.tm.times;

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Mean and STD/SEM, smoothed for the representation if needed:
datamean = mean(data,3);
if graph.smoothdata
    datamean = smooth(datamean,graph.smoothdata)';
    for subject = 1 : size(data,3)
        data(1,:,subject) = smooth(data(1,:,subject),graph.smoothdata);
    end
end

stdsem = nanstd(data,[],3);
if ~graph.stdsem, stdsem = stdsem/sqrt(size(data,3)); end

%% Error band and significant timepoints:
shade = ~isempty(stats) && graph.sigmode.shade;
points = ~isempty(stats) && graph.sigmode.points;

if shade
    plotband(times,datamean,stdsem,true(size(times)),[.7 .7 .7],.5);
    segments = bwconncomp(sigmask(graph,stats));
    for i = 1 : segments.NumObjects
        plotband(times,datamean,stdsem,segments.PixelIdxList{i},...
            graph.shadecolor,graph.shadealpha);
    end
else
    plotband(times,datamean,stdsem,true(size(times)),...
        graph.shadecolor,graph.shadealpha);
end

if points
    sig = sigmask(graph,stats);
    scatter(times(sig),graph.sigh*ones(1,nnz(sig)),80,graph.sigc,'filled','s');
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
set(gca,'XTick',graph.xlim(1):100:graph.xlim(2))
set(gca,'YTick',graph.ylim(1):.05:graph.ylim(2))
set(gca,'FontSize',graph.fontsize)

xlabel(graph.xlabel);
ylabel(graph.ylabel);
ylim(graph.ylim)
xlim(graph.xlim)
title(graph.title);
set(gca,'Layer','top')

end

function sig = sigmask(graph,stats)
%% Significant timepoints in the selected tails [1 x timepoints].

sig = (~stats.sigmask & graph.stats.above) | (~stats.sigmask_ & graph.stats.below);

end

function plotband(times,datamean,stdsem,idx,color,alpha)
%% Band of the mean plus and minus the STD/SEM at the timepoints idx.

t = times(idx);
upper = datamean(idx) + stdsem(idx);
lower = datamean(idx) - stdsem(idx);
fill([t fliplr(t)],[upper fliplr(lower)],color,'FaceAlpha',alpha,'linestyle','none');

end
