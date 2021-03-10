%% Save cfg state:
mvpalab_savecfg(cfg);

%% Import data:
cfg = mvpalab_import(cfg);

%% Compute analysis:
if cfg.stats.flag
    [cfg,result,stats] = mvpalab_sfilter(cfg);
else
    [cfg,result] = mvpalab_sfilter(cfg);
end

