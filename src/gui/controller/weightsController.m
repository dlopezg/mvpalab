if strcmp(cfg.analysis,'MVCC')
    if isstruct(wvector)
        if strcmp(graph.mvccDirection,'ab')
            mvpalab_plotwanalysis(graph,cfg,wvector.ab);
        elseif strcmp(graph.mvccDirection,'ba')
            mvpalab_plotwanalysis(graph,cfg,wvector.ba);
        end
    end
else
   mvpalab_plotwanalysis(graph,cfg,wvector); 
end


