%% Plot MVPA and MVCC results:

if ~cfg.sf.flag
    if cfg.classmodel.tempgen
        if (graph.stats.above || graph.stats.below)
            if ~graph.add, figure; end
            hold on;
            mvpalab_plottempogen(graph,cfg,result,stats);
        else
            if ~graph.add, figure; end
            hold on;
            mvpalab_plottempogen(graph,cfg,result);
        end
    else
        if (graph.stats.above || graph.stats.below)
            if ~graph.add, figure; end
            hold on;
            mvpalab_plotdecoding(graph,cfg,result,stats);
        else
            if ~graph.add, figure; end
            hold on;
            mvpalab_plotdecoding(graph,cfg,result);
        end
    end
else
    if (graph.stats.above || graph.stats.below)    
        if ~graph.add, figure; end
        hold on;
        mvpalab_plotfreqcont(graph,cfg,result,stats);
    else
        if ~graph.add, figure; end
        hold on;
        mvpalab_plotfreqcont(graph,cfg,result);
    end
end