function [] = mvpalab_plotdecoding(graph,cfg,data,stats)
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
%  (graph.sigmode.shade) or as points at height graph.sigh
%  (graph.sigmode.points).
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
%    mvpalab_computepermtest).

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

%% Select subject:
data = mvpalab_selectsub(graph,data);

%% Calculate the mean for each timepoint:
datamean = squeeze(mean(data,3));
datamean = datamean(:);
chancelevel = zeros(1,length(datamean))+graph.chanlvl;

%% Smooth the data for the representation if needed:
if graph.smoothdata
    datamean = smooth(datamean,graph.smoothdata);
    for subject = 1 : size(data,3) 
        data(1,:,subject) = smooth(data(1,:,subject),graph.smoothdata);
    end
end

%% Compute the STD/SEM:
if graph.stdsem
    stdsem = nanstd(data,[],3);
else
    stdsem = nanstd(data,[],3)/sqrt(size(data,3));
end


%% Plots:
if  exist('stats','var')
    if graph.sigmode.shade
        fill(...
            [cfg.tm.times fliplr(cfg.tm.times)],...
            [datamean'+stdsem fliplr(datamean'-stdsem)],...
            [.7 .7 .7], 'FaceAlpha',...
            .5,'linestyle','none');
        
        significant_vector = logical(...
            ~stats.sigmask * graph.stats.above + ...
            ~stats.sigmask_* graph.stats.below);
        
        segments = bwconncomp(significant_vector);
        
        for i = 1 : segments.NumObjects
            times = cfg.tm.times(segments.PixelIdxList{i});
            values = datamean(segments.PixelIdxList{i});
            var = stdsem(segments.PixelIdxList{i});
            
            if significant_vector(segments.PixelIdxList{i})
                fill(...
                    [times fliplr(times)],...
                    [values'+var fliplr(values'-var)],...
                    graph.shadecolor, 'FaceAlpha',...
                    graph.shadealpha,'linestyle','none');
            end
        end
    end
    if graph.sigmode.points
        
        fill(...
            [cfg.tm.times fliplr(cfg.tm.times)],...
            [datamean'+stdsem fliplr(datamean'-stdsem)],...
            graph.shadecolor, 'FaceAlpha',...
            graph.shadealpha,'linestyle','none');
        
        
        stpoints = ones(1,length(datamean))*graph.sigh;
        times = cfg.tm.times(logical(~stats.sigmask  * graph.stats.above ...
            + ~stats.sigmask_ * graph.stats.below));
        points = stpoints(logical(~stats.sigmask  * graph.stats.above ...
            + ~stats.sigmask_ * graph.stats.below));
        scatter(times,points,80,graph.sigc,'filled','s');
        %scatter(cfg.tm.times,stpoints,80,'k','s');
    end
    
else
    fill(...
        [cfg.tm.times fliplr(cfg.tm.times)],...
        [datamean'+stdsem fliplr(datamean'-stdsem)],...
        graph.shadecolor,...
        'FaceAlpha',graph.shadealpha,'linestyle','none');
end

if graph.plotmean
    plot(cfg.tm.times,datamean,...
        'color',graph.shadecolor,...
        'linewidth',graph.linewidth,...
        'linestyle',graph.linestyle);
end

plot(cfg.tm.times,chancelevel,'k','LineWidth',.5,'LineStyle',':');

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

