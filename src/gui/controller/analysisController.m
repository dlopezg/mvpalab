%% Load data, generate conditions and feature extraction:
[cfg,~,fv] = mvpalab_import(cfg);

%% Compute the decoding analysis and save results:
%  With cfg.stats.flag it also computes the null maps (permuted or sign
%  flip) and the permutation test.
[result,cfg,stats,nullmaps] = mvpalab_decoding(cfg,fv);

%% Extract diag:
if cfg.classmodel.tempgen && cfg.classmodel.extdiag
    if cfg.stats.flag
        [resultdiag,nullmapsdiag,statsdiag] = mvpalab_extractdiag(cfg,result,nullmaps);
    else
        resultdiag = mvpalab_extractdiag(cfg,result);
    end
end
