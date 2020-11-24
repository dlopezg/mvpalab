
figure;

%% 

if cfg.classmodel.tempgen
    if (graph.stats.above || graph.stats.below)
        mvpalab_plottg(graph,cfg,result,stats);
    else
        mvpalab_plottg(graph,cfg,result);
    end
else
    
end