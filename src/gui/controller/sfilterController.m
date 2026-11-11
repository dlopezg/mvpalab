%% Import data:
cfg = mvpalab_import(cfg);

%% Compute the sliding filter analysis and save results:
%  With cfg.stats.flag it also computes the null maps (permuted or sign
%  flip diffMaps) and the permutation test.
[result,cfg,stats,nullmaps] = mvpalab_sfilter(cfg);
