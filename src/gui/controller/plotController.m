%% Plot controller:

%% Select MVCC direction if needed:

resultToPlot = result;

if (graph.stats.above || graph.stats.below)
    statsToPlot = stats;
end

if strcmp(cfg.analysis,'MVCC')
    if isstruct(result)
        if strcmp(graph.mvccDirection,'ab')
            resultToPlot = result.ab;
            if (graph.stats.above || graph.stats.below)
                statsToPlot = stats.ab;
            end
        elseif strcmp(graph.mvccDirection,'ba')
            resultToPlot = result.ba;
            if (graph.stats.above || graph.stats.below)
                statsToPlot = stats.ba;
            end
        end
    end
end

%% Plot MVPA and MVCC results:

if ~cfg.sf.flag
    if cfg.classmodel.tempgen
        if (graph.stats.above || graph.stats.below)
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plottempogen(graph,cfg,resultToPlot,statsToPlot);
        else
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plottempogen(graph,cfg,resultToPlot);
        end
    else
        if (graph.stats.above || graph.stats.below)
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plotdecoding(graph,cfg,resultToPlot,statsToPlot);
        else
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plotdecoding(graph,cfg,resultToPlot);
        end
    end
    
    
else
    
    if (graph.stats.above || graph.stats.below)
        
        if ~graph.add
            figure;
        end
        
        hold on;
        mvpalab_plotslidfilt(graph,cfg,resultToPlot,statsToPlot);
    else
        
        if ~graph.add
            figure;
        end
        
        hold on;
        mvpalab_plotslidfilt(graph,cfg,resultToPlot);
    end
    
end