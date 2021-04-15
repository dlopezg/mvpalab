if exist('result','var')
    if strcmp(cfg.analysis,'MVCC')
        if strcmp(graph.mvccDirection,'ab')
            performance = result.ab;
        elseif strcmp(graph.mvccDirection,'ba')
            performance = result.ba;
        end
    else
        performance = result;
    end
else
    performance = [];
end

if strcmp(cfg.analysis,'MVCC')
    if isstruct(wvector)
        if strcmp(graph.mvccDirection,'ab')
            mvpalab_plotwanalysis(graph,cfg,wvector.ab,performance);
        elseif strcmp(graph.mvccDirection,'ba')
            mvpalab_plotwanalysis(graph,cfg,wvector.ba,performance);
        end
    end
else
    mvpalab_plotwanalysis(graph,cfg,wvector,performance);
end


