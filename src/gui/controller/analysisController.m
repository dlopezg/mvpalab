%% Load data, generate conditions and feature extraction:
[cfg,~,fv] = mvpalab_import(cfg);

%% Compute the decoding analysis and save results:
[result,cfg] = mvpalab_decoding(cfg,fv);

%% If permutation analysis is enabled
if cfg.stats.flag
    % Generate permuted maps:
    [permaps,cfg] = mvpalab_nullmaps(cfg,fv,result);

    % Compute the permutation based analysis:
    stats = mvpalab_permtest(cfg,result,permaps);
end

%% Extract diag:
if cfg.classmodel.tempgen && cfg.classmodel.extdiag
    if cfg.stats.flag
        [resultdiag,permapsdiag,statsdiag] = mvpalab_extractdiag(cfg,result,permaps);
    else
        resultdiag = mvpalab_extractdiag(cfg,result);
    end
end

