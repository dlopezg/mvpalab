
figure;
hold on;

%%
if strcmp(cfg.analysis,'MVPA')
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
elseif strcmp(cfg.analysis,'MVCC')
    if cfg.classmodel.tempgen
        if (graph.stats.above || graph.stats.below)
            if isfield(result,'ab')
                mvpalab_plottg(graph,cfg,result.ab,stats.ab);
            end
            if isfield(result,'ba')
                figure;
            hold on;
                mvpalab_plottg(graph,cfg,result.ba,stats.ba);
            end
        else
            if isfield(result,'ab')
                mvpalab_plottg(graph,cfg,result.ab);
            end
            if isfield(result,'ba')
                figure;
            hold on;
                mvpalab_plottg(graph,cfg,result.ba);
            end
        end
    else
        if (graph.stats.above || graph.stats.below)
            if isfield(result,'ab')
                mvpalab_plotcr(graph,cfg,result.ab,stats.ab);
            end
            if isfield(result,'ba')
                mvpalab_plotcr(graph,cfg,result.ba,stats.ba);
            end
            
        else
            if isfield(result,'ab')
                mvpalab_plotcr(graph,cfg,result.ab);
            end
            if isfield(result,'ba')
                mvpalab_plotcr(graph,cfg,result.ba);
            end
        end
    end
end