%% Save cfg state:
mvpalab_savecfg(cfg);

%% Create result and stats folder
mvpalab_mkdir([cfg.location '/results']);

%% Load data, generate conditions and feature extraction:
[cfg,~,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis and save results:
if strcmp(cfg.analysis,'MVPA')
    [result,cfg] = mvpalab_mvpa(cfg,fv);
elseif strcmp(cfg.analysis,'MVCC')
    [result,cfg] = mvpalab_mvcc(cfg,fv);
end

%% If permutation analysis is enabled
if cfg.stats.flag
    % Generate permuted maps:
    if strcmp(cfg.analysis,'MVPA')
        [permaps,cfg] = mvpalab_permaps(cfg,fv);
    elseif strcmp(cfg.analysis,'MVCC')
        [permaps,cfg] = mvpalab_cpermaps(cfg,fv);
    end
    
    % Compute the permutation based analysis:
    stats = mvpalab_permtest(cfg,result,permaps);
end

%% Save cfg file:
mvpalab_savecfg(cfg);

%% Extract diag:
if cfg.classmodel.tempgen && cfg.classmodel.extdiag
    if cfg.stats.flag
        [resultdiag,permapsdiag,statsdiag] = mvpalab_extractdiag(cfg,result,permaps);
    else
        resultdiag = mvpalab_extractdiag(cfg,result);
    end
end

