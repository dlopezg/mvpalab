%% Save cfg state:
mvpalab_savecfg(cfg);

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVCC analysis:
[result,cfg] = mvpalab_mvcc(cfg,fv);

%% If permutation analysis is enabled
if cfg.stats.flag
    %% Generate permuted maps:
    [permaps,cfg] = mvpalab_cpermaps(cfg,fv);
    
    %% Cross-classification direction:
    if strcmp(cfg.study.mvccDirection,'both')
        stats.cr.ab = mvpalab_permtest(cfg,result.cr.ab,permaps.cr.ab);
        stats.cr.ba = mvpalab_permtest(cfg,result.cr.ba,permaps.cr.ba);
        if cfg.classmodel.roc
            stats.auc.ab = mvpalab_permtest(cfg,result.auc.ab,permaps.auc.ab);
            stats.auc.ba = mvpalab_permtest(cfg,result.auc.ba,permaps.auc.ba);
        end
    elseif strcmp(cfg.study.mvccDirection,'AB')
        stats.cr.ab = mvpalab_permtest(cfg,result.cr.ab,permaps.cr.ab);
        if cfg.classmodel.roc
            stats.auc.ab = mvpalab_permtest(cfg,result.auc.ab,permaps.auc.ab);
        end
    elseif strcmp(cfg.study.mvccDirection,'BA')
        if cfg.classmodel.roc
            stats.auc.ba = mvpalab_permtest(cfg,result.auc.ba,permaps.auc.ba);
        end
    end
    
end

%% Save results:
mvpalab_savecfg(cfg);
mvpalab_saveresults(cfg,result);
if cfg.stats.savepmaps
    mvpalab_savepermaps(cfg,permaps);
end
mvpalab_savestats(cfg,stats);
