function [] = mvpalab_plotcr(graphs,cfg,data,stats)
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

%% Calculate the mean for each timepoint:
datamean = squeeze(mean(data,3));
chancelevel = zeros(1,length(datamean))+.5;

%% Smooth the data for the representation if needed:
if graphs.smoothdata
    datamean = smooth(datamean,graphs.smoothdata);
end

%% Compute the STD/SEM:
if graphs.stdsem
    stdsem = nanstd(data,[],3);
else
    stdsem = nanstd(data,[],3)/sqrt(size(data,3));
end


%% Plots:
if exist('stats','var')
    if graphs.sigmode.shade
        fill(...
            [cfg.tm.times fliplr(cfg.tm.times)],...
            [datamean'+stdsem fliplr(datamean'-stdsem)],...
            [.7 .7 .7], 'FaceAlpha',...
            .5,'linestyle','none');
        
        significant_vector = logical(~stats.sigmask + ~stats.sigmask_);
        segments = bwconncomp(significant_vector);
        
        for i = 1 : segments.NumObjects
            times = cfg.tm.times(segments.PixelIdxList{i});
            values = datamean(segments.PixelIdxList{i});
            var = stdsem(segments.PixelIdxList{i});
            
            if significant_vector(segments.PixelIdxList{i})
                fill(...
                    [times fliplr(times)],...
                    [values'+var fliplr(values'-var)],...
                    graphs.shadecolor, 'FaceAlpha',...
                    graphs.shadealpha,'linestyle','none');
            end
        end
        if graphs.sigmode.points
            stpoints = ones(1,length(datamean))*graphs.sigh;
            times = cfg.tm.times(logical(~stats.sigmask + ~stats.sigmask_));
            points = stpoints(logical(~stats.sigmask + ~stats.sigmask_));
            scatter(times,points,80,graphs.sigc,'filled','s');
            scatter(cfg.tm.times,stpoints,80,'k','s');
        end
        
    else
        fill(...
            [cfg.tm.times fliplr(cfg.tm.times)],...
            [datamean'+stdsem fliplr(datamean'-stdsem)],...
            graphs.shadecolor,...
            'FaceAlpha',graphs.shadealpha,'linestyle','none');
        
        if graphs.plotmean
            plot(cfg.tm.times,datamean,...
                'color',graphs.shadecolor,...
                'linewidth',1,...
                'linestyle','-');
        end
    end
    
    plot(cfg.tm.times,chancelevel,'k','LineWidth',.5,'LineStyle',':');
    
    %%  Graph configuration:
    set(gca,'Color','w')
    set(gca,'XGrid','on');
    set(gca,'YAxisLocation','origin');
    set(gca,'XMinorTick','on','YMinorTick','on')
    set(gca,'XTick',graph.xlim(1):100:graph.xlim(2))
    set(gca,'YTick',graph.ylim(1):.05:graph.ylim(2))
    set(gca,'FontSize',14)
    
    xlabel('Time (ms)');
    ylabel('Classifier performance')
    ylim(graphs.ylim)
    xlim(graphs.xlim)
    set(gca,'Layer','top')
    
    
end

