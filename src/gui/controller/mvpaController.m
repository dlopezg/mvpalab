%% Save cfg state:
mvpalab_savecfg(cfg);

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis and save results:
[result,cfg] = mvpalab_mvpa(cfg,fv);
mvpalab_saveresults(cfg,result);

%% If permutation analysis is enabled
if cfg.stats.flag
    %% Generate permuted maps:
    [permaps,cfg] = mvpalab_permaps(cfg,fv);
    
    %% Compute the permutation based analysis:
    stats.cr = mvpalab_permtest(cfg,result.cr,permaps.cr);
    
    if cfg.classmodel.roc
        stats.auc = mvpalab_permtest(cfg,result.auc,permaps.auc);
    end
    
    %% Save stats:
    mvpalab_savestats(cfg,stats);
    mvpalab_savepermaps(cfg,permaps);
end

%% Save results:
mvpalab_savecfg(cfg);

%% Extract diag:
if cfg.classmodel.tempgen
    if exist('permaps','var')
        [resultdiag.cr,permapsdiag.cr] = mvpalab_extractdiag(result.cr,permaps.cr);
        statsdiag = mvpalab_permtest(cfg,resultdiag.cr,permapsdiag.cr);
        
        if cfg.classmodel.roc
            [resultdiag.auc,permapsdiag.auc] = mvpalab_extractdiag(result.auc,permaps.auc);
            statsdiag = mvpalab_permtest(cfg,resultdiag.auc,permapsdiag.auc);
        end
        
        mvpalab_savediag(cfg,resultdiag,permapsdiag,statsdiag);
    else
        resultdiag.cr = mvpalab_extractdiag(result.cr);
         
        if cfg.classmodel.roc
            [resultdiag.auc] = mvpalab_extractdiag(result.auc);
        end
        
        mvpalab_savediag(cfg,resultdiag);
    end
end
    
    