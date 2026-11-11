function [cfg,diffMap,stats] = mvpalab_sfilter(cfg)
%% MVPALAB_SFILTER
%
%  This function computes a sliding filter analysis: the diffMaps, the
%  performance of each frequency band minus the performance of the
%  unfiltered data (see mvpalab_gendiffmap). The feature vectors of the
%  bands must be in cfg.sf.filesLocation (see mvpalab_import with
%  cfg.sf.flag enabled).
%
%  All the maps are computed with mvpalab_evalsubjects. The unfiltered
%  baseline is read again with mvpalab_readdata, and its feature vectors
%  are rounded to single precision, as those of the bands saved by the
%  import (see mvpalab_savesfdata), so a filter without effect gives a
%  diffMap of exactly 0. The bands and the baseline
%  share their random draws (see mvpalab_sfrng), except the draws of the
%  hyperparameter search (cfg.classmodel.optimize), with a warning.
%
%  If cfg.stats.flag is enabled, it computes the permutation test of the
%  diffMaps (see mvpalab_permtest). With cfg.stats.signflip the permuted
%  maps are not computed, and the test uses the sign flip maps of the
%  diffMaps around 0 (see mvpalab_selectnull).
%
%  It saves cfg (see mvpalab_savecfg) after checking it and again after
%  computing the maps, and these files in cfg.savefolder,
%  cfg.location/results/cfg.analysis/diffMaps (see mvpalab_save):
%  - result.mat: diffMap of cfg.sf.metric, with cfg.
%  - stats.mat: Statistics, if cfg.stats.flag is enabled.
%  - other/performance_maps.mat, other/performance.mat: Maps of the bands
%    and of the baseline.
%  - other/permuted_maps.mat, other/permuted_performance.mat: Permuted
%    maps of the bands and of the baseline, if they are computed.
%  - other/perdiffMap.mat: Permuted or sign flip diffMaps, if
%    cfg.stats.flag is enabled.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.
%
%  - {struct} - diffMap:
%    Field cfg.sf.metric with the diffMaps [bands x ntp x subjects]. In
%    MVCC, fields ab and ba.
%
%  - {struct} - stats:
%    Statistics of cfg.sf.metric (see mvpalab_permtest), or empty if
%    cfg.stats.flag is disabled.

% Check cfg structure:
cfg = mvpalab_updatecfg(cfg);

% Check the settings of the analysis. The permuted maps follow the same
% settings, and the sign flip test does not compute them:
mvpalab_validatedecoding(cfg,'observed');
mvpalab_validatesf(cfg);
mvpalab_savecfg(cfg);

% Folder of the results (see mvpalab_save):
cfg.savefolder = fullfile(cfg.location,'results',cfg.analysis,'diffMaps');
mvpalab_mkdir(fullfile(cfg.savefolder,'other'));

% Only computed if cfg.stats.flag is enabled:
stats = [];

% The sign flip test does not need permuted maps:
permuted = cfg.stats.flag && ~cfg.stats.signflip;

% The bands and the unfiltered baseline share their draws (see mvpalab_sfrng):
cfg.sf.rng = cell(length(cfg.study.dataFiles{1,1}),2);
if cfg.classmodel.optimize.flag
    warning('The hyperparameter search does not share its draws across bands.');
end

%% Sliding filter analysis:

% Compute analysis for each frequency band:
[performance_maps,cfg] = mvpalab_evalsubjects(cfg,[],'observed');

save(fullfile(cfg.savefolder,'other','performance_maps.mat'),...
    'performance_maps','-v7.3');

% Generate permuted maps for each frequency band if needed:
if permuted
    [permuted_maps,cfg] = mvpalab_evalsubjects(cfg,[],'permuted');
    save(fullfile(cfg.savefolder,'other','permuted_maps.mat'),...
        'permuted_maps','-v7.3');
end

%% MVPA analysis:

% Time-resolved MVPA (unfiltered baseline). Without cfg.sf.flag the maps
% are computed from fv and not from the bands on disk:
cfg.sf.flag = false;
[cfg,~,fv] = mvpalab_readdata(cfg);
fv = cellfun(@singleprecision,fv,'UniformOutput',false);

[performance,cfg] = mvpalab_evalsubjects(cfg,fv,'observed');

save(fullfile(cfg.savefolder,'other','performance.mat'),...
    'performance','-v7.3');

% Chance level if needed:
%  One permuted map of the unfiltered data for each permutation, so every
%  permuted diffMap has its own baseline (see mvpalab_gendiffmap).
if permuted
    [permuted_performance,cfg] = mvpalab_evalsubjects(cfg,fv,'permuted');
    save(fullfile(cfg.savefolder,'other','permuted_performance.mat'),...
        'permuted_performance','-v7.3');
end

cfg.sf = rmfield(cfg.sf,'rng');
cfg.sf.flag = true;
mvpalab_savecfg(cfg);

%% Sliding filter analysis - Generate diffMaps:

if permuted
    [cfg,diffMap,perdiffMap] = mvpalab_gendiffmap(...
        cfg,performance.(cfg.sf.metric),...
        performance_maps.(cfg.sf.metric),...
        permuted_performance.(cfg.sf.metric),...
        permuted_maps.(cfg.sf.metric));
else
    [cfg,diffMap] = mvpalab_gendiffmap(...
        cfg,performance.(cfg.sf.metric),...
        performance_maps.(cfg.sf.metric));
    perdiffMap = [];
end

result = diffMap.(cfg.sf.metric);
save(fullfile(cfg.savefolder,'result.mat'),'result','cfg','-v7.3');

%% Compute permutation test if needed:
if cfg.stats.flag
    % Permuted or sign flip diffMaps; the diffMaps have no effect at 0:
    perdiffMap = mvpalab_selectnull(cfg,diffMap,perdiffMap,0);
    save(fullfile(cfg.savefolder,'other','perdiffMap.mat'),...
        'perdiffMap','-v7.3');
    stats = mvpalab_permtest(cfg,diffMap,perdiffMap);
    stats = stats.(cfg.sf.metric);
    save(fullfile(cfg.savefolder,'stats.mat'),'stats','-v7.3');
end

end

function fv = singleprecision(fv)
%% Feature vectors of one subject rounded to single precision and read in
%  double precision, as the bands (see mvpalab_savesfdata and
%  mvpalab_subjectdata).

for field = fieldnames(fv.X)'
    fv.X.(field{1}) = double(single(fv.X.(field{1})));
end

end
