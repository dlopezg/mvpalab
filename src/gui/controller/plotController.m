%% Plot controller:

if strcmp(cfg.analysis,'MVPA')
    if cfg.classmodel.tempgen
        if (graph.stats.above || graph.stats.below)
            figure; hold on;
            mvpalab_plottg(graph,cfg,result,stats);
        else
            figure; hold on;
            mvpalab_plottg(graph,cfg,result);
        end
    else
        if (graph.stats.above || graph.stats.below)
            figure; hold on;
            mvpalab_plotcr(graph,cfg,result,stats);
        else
            figure; hold on;
            mvpalab_plotcr(graph,cfg,result);
        end
    end
elseif strcmp(cfg.analysis,'MVCC')
    if cfg.classmodel.tempgen
        if (graph.stats.above || graph.stats.below)
            if isstruct(result)
                figure; hold on;
                mvpalab_plottg(graph,cfg,result.ab,stats.ab);
                title('MVCC direction: A - B');
                figure; hold on;
                mvpalab_plottg(graph,cfg,result.ba,stats.ba);
                title('MVCC direction: B - A');
            else
                figure; hold on;
                mvpalab_plottg(graph,cfg,result,stats);
            end
        else
            if isstruct(result)
                figure; hold on;
                mvpalab_plottg(graph,cfg,result.ab);
                title('MVCC direction: A - B');
                figure; hold on;
                mvpalab_plottg(graph,cfg,result.ba);
                title('MVCC direction: B - A');
            else
                figure; hold on;
                mvpalab_plottg(graph,cfg,result);
            end
        end
    else
        if (graph.stats.above || graph.stats.below)
            if isstruct(result)
                figure; hold on;
                mvpalab_plotcr(graph,cfg,result.ab,stats.ab);
                title('MVCC direction: A - B');
                figure; hold on;
                mvpalab_plotcr(graph,cfg,result.ba,stats.ba);
                title('MVCC direction: B - A');
            else
                figure; hold on;
                mvpalab_plotcr(graph,cfg,result,stats);
            end
        else
            if isstruct(result)
                figure; hold on;
                mvpalab_plotcr(graph,cfg,result.ab);
                title('MVCC direction: A - B');
                figure; hold on;
                mvpalab_plotcr(graph,cfg,result.ba);
                title('MVCC direction: B - A');
            else
                figure; hold on;
                mvpalab_plotcr(graph,cfg,result);
            end
        end
    end
end