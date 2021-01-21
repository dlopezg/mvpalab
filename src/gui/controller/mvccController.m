%% Save cfg state:
mvpalab_savecfg(cfg);

%% Create result and stats folder
mvpalab_mkdir([cfg.location '/results']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVCC analysis:
[result,cfg] = mvpalab_mvcc(cfg,fv);
mvpalab_saveresults(cfg,result);

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
    %% Save stats:
    mvpalab_savepermaps(cfg,permaps);
    mvpalab_savestats(cfg,stats);
    
end

%% Save results:
mvpalab_savecfg(cfg);

%% Extract diag:
if cfg.classmodel.tempgen
    if exist('permaps','var')
        [resultdiag.cr.ab,permapsdiag.cr.ab] = mvpalab_extractdiag(...
            result.cr.ab,permaps.cr.ab);
        statsdiag.cr.ab = mvpalab_permtest(...
            cfg,resultdiag.cr.ab,permapsdiag.cr.ab);
        
        if isfield(result.cr,'ba')
            [resultdiag.cr.ba,permapsdiag.cr.ba] = mvpalab_extractdiag(...
                result.cr.ba,permaps.cr.ba);
            statsdiag.cr.ba = mvpalab_permtest(...
                cfg,resultdiag.cr.ba,permapsdiag.cr.ba);
        end
        
        if cfg.classmodel.roc
            [resultdiag.auc.ab,permapsdiag.auc.ab] = mvpalab_extractdiag(...
                result.auc.ab,permaps.auc.ab);
            statsdiag.auc.ab = mvpalab_permtest(...
                cfg,resultdiag.auc.ab,permapsdiag.auc.ab);
            
            if isfield(result.auc,'ba')
                [resultdiag.auc.ba,permapsdiag.auc.ba] = mvpalab_extractdiag(...
                    result.auc.ba,permaps.auc.ba);
                statsdiag.auc.ba = mvpalab_permtest(...
                    cfg,resultdiag.auc.ba,permapsdiag.auc.ba);
            end
        end
        
        %% Save diag:
        mvpalab_savediag(cfg,resultdiag,permapsdiag,statsdiag);
    else
        resultdiag.cr.ab = mvpalab_extractdiag(result.cr.ab);
        if isfield(result.cr,'ba')
            resultdiag.cr.ba = mvpalab_extractdiag(result.cr.ba);
        end
        
        if cfg.classmodel.roc
            [resultdiag.auc.ab] = mvpalab_extractdiag(result.auc.ab);
            if isfield(result.cr,'ba')
                [resultdiag.auc.ba] = mvpalab_extractdiag(result.auc.ba);
            end
        end
        
        %% Save diag:
        mvpalab_savediag(cfg,resultdiag);
    end
end


