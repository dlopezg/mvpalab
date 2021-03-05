%% Save cfg state:
mvpalab_savecfg(cfg);

%% Compute SF analysis:
if strcmp(cfg.analysis,'MVPA')
    [cfg,result,stats] = mvpalab_sfiltermvpa(cfg);
elseif strcmp(cfg.analysis,'MVCC')
    [cfg,result,stats] = mvpalab_sfiltermvpa(cfg);
end
