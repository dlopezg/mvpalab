%% Save cfg state:
mvpalab_savecfg(cfg);

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis:
[result,cfg] = mvpalab_mvpa(cfg,fv);

%% If permutation analysis is enabled
if cfg.stats.flag
    %% Generate permuted maps:
    [permaps,cfg] = mvpalab_permaps(cfg,fv);
    
    %% Compute the permutation based analysis:
    stats.cr = mvpalab_permtest(cfg,result.cr,permaps.cr);
    
    if cfg.classmodel.roc
        stats.auc = mvpalab_permtest(cfg,result.auc,permaps.auc);
    end
end

%% Save results:
mvpalab_savecfg(cfg);
mvpalab_saveresults(cfg,result);
if cfg.stats.savepmaps
    mvpalab_savepermaps(cfg,permaps);
end
mvpalab_savestats(cfg,stats);
