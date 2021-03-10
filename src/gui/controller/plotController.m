%% Plot controller:

%% Select MVCC direction if needed:

if strcmp(cfg.analysis,'MVCC')
    if isstruct(result)
        if strcmp(graph.mvccDirection,'ab')
            result = result.ab;
            if (graph.stats.above || graph.stats.below)
                stats = stats.ab;
            end
        elseif strcmp(graph.mvccDirection,'ba')
            result = result.ba;
            if (graph.stats.above || graph.stats.below)
                stats = stats.ba;
            end
        end
    end
end
    
%% Plot MVPA and MVCC results:

if strcmp(cfg.analysis,'MVPA') || strcmp(cfg.analysis,'MVCC')
    if cfg.classmodel.tempgen
        if (graph.stats.above || graph.stats.below)
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plottg(graph,cfg,result,stats);
        else
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plottg(graph,cfg,result);
        end
    else
        if (graph.stats.above || graph.stats.below)
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plotcr(graph,cfg,result,stats);
        else
            
            if ~graph.add
                figure;
            end
            
            hold on;
            mvpalab_plotcr(graph,cfg,result);
        end
    end
end