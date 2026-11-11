function [diffMap,cfg,stats,nullmaps] = mvpalab_sfilter(cfg)
%% MVPALAB_SFILTER
%
%  This function computes a sliding filter analysis: the diffMaps, the
%  performance of each frequency band minus the performance of the
%  unfiltered data (see mvpalab_gendiffmap). The feature vectors of the
%  bands must be in cfg.sf.filesLocation (see mvpalab_import with
%  cfg.sf.flag enabled), from the import of this cfg: the settings of the
%  import must not change (see mvpalab_validatesfimport and
%  mvpalab_subjectdata).
%
%  All the maps are computed with mvpalab_evalsubjects. The unfiltered
%  baseline is read again (see mvpalab_sfbaseline). The bands and the
%  baseline share their random draws (see mvpalab_sfrng), so a diffMap only
%  contains the effect of the filter, except the draws of the
%  hyperparameter search (cfg.classmodel.optimize), with a warning.
%
%  With cfg.stats.flag enabled, it also computes the maps of the null
%  distribution (see mvpalab_sfnullmaps) and the permutation test (see
%  mvpalab_permtest) in the same call, with the same cfg, so the result and
%  its null distribution always follow the same settings. To repeat the
%  test with other settings of cfg.stats (for example cfg.stats.pclust),
%  call mvpalab_permtest again with the returned null maps.
%
%  It saves cfg (see mvpalab_savecfg) after checking it and again after
%  computing the maps, and these files in cfg.savefolder,
%  cfg.location/results/cfg.analysis/diffMaps:
%  - The diffMaps of cfg.sf.metric with mvpalab_save, for example
%    acc/result.mat (acc/ab/result.mat and acc/ba/result.mat in MVCC).
%  - other/performance_maps.mat and other/performance.mat: Maps of the
%    bands and of the baseline, with cfg.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - diffMap:
%    Field cfg.sf.metric with the diffMaps [bands x ntp x subjects]. In
%    MVCC, fields ab and ba.
%
%  - {struct} - cfg:
%    Updated configuration structure.
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag.
%
%  - {struct} - nullmaps:
%    Maps of the null distribution (see mvpalab_sfnullmaps), empty without
%    cfg.stats.flag.

% Check cfg structure:
cfg = mvpalab_updatecfg(cfg);

% Check the settings of the analysis:
mvpalab_validatedecoding(cfg,'observed');
mvpalab_validatesf(cfg);
mvpalab_validatesfimport(cfg);
mvpalab_savecfg(cfg);

% Folder of the results (see mvpalab_save):
cfg.savefolder = fullfile(cfg.location,'results',cfg.analysis,'diffMaps');
mvpalab_mkdir(fullfile(cfg.savefolder,'other'));

% The bands and the unfiltered baseline share their draws (see mvpalab_sfrng):
cfg.sf.rng = cell(length(cfg.study.dataFiles{1,1}),2);
if cfg.classmodel.optimize.flag
    warning('The hyperparameter search does not share its draws across bands.');
end

%% Maps of each frequency band:
[performance_maps,cfg] = mvpalab_evalsubjects(cfg,[],'observed');

%% Unfiltered baseline:
%  Without cfg.sf.flag the maps are computed from fv and not from the bands
%  on disk.
cfg.sf.flag = false;
[fv,cfg] = mvpalab_sfbaseline(cfg);
[performance,cfg] = mvpalab_evalsubjects(cfg,fv,'observed');

cfg.sf = rmfield(cfg.sf,'rng');
cfg.sf.flag = true;

% Maps of the bands and of the baseline, with the cfg of the analysis:
save(fullfile(cfg.savefolder,'other','performance_maps.mat'),...
    'performance_maps','cfg','-v7.3');
save(fullfile(cfg.savefolder,'other','performance.mat'),...
    'performance','cfg','-v7.3');

%% diffMaps:
diffMap = mvpalab_gendiffmap(cfg,performance.(cfg.sf.metric),...
    performance_maps.(cfg.sf.metric),'observed');

mvpalab_save(cfg,diffMap,'res');

%% Null maps and permutation test, if needed:
stats = [];
nullmaps = [];
if cfg.stats.flag
    [nullmaps,cfg] = mvpalab_sfnullmaps(cfg,diffMap);
    stats = mvpalab_permtest(cfg,diffMap,nullmaps);
end

mvpalab_savecfg(cfg);

end
