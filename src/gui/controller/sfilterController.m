%% Save cfg state:
mvpalab_savecfg(cfg);

%% Compute analysis:
[cfg,result,stats] = mvpalab_sfilter(cfg);
