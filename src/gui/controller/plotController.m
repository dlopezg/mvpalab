
figure;
hold on;

%% 
if cfg.classmodel.tempgen
    if (graph.stats.above || graph.stats.below)
        mvpalab_plottg(graph,cfg,result,stats);
    else
        mvpalab_plottg(graph,cfg,result);
    end
else
    if (graph.stats.above || graph.stats.below)
        mvpalab_plotcr(graph,cfg,result,stats);
    else
        mvpalab_plotcr(graph,cfg,result);
    end
end