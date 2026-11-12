function [res,cfg,stats,nullmaps] = mvpalab_decoding(cfg,fv,mode)
%% MVPALAB_DECODING
%
%  This function computes the decoding analysis of the study: MVPA, or
%  MVCC if dataset B has files (see mvpalab_ismvcc), a cross-classification
%  between datasets A and B in both directions (training in A and test in B
%  and vice versa), and their permuted maps for the permutation test:
%
%    [result,cfg,stats,nullmaps] = mvpalab_decoding(cfg,fv);
%    [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');
%
%  A permuted map is the observed map computed with permuted labels, so
%  both follow the same pipeline:
%
%    Subjects > frequency bands > maps (one if observed, cfg.stats.nper if
%    permuted) > repetitions (supertrials and partitions) > timepoints (see
%    mvpalab_evalmap).
%
%  In MVCC each permuted map uses one reassignment of the labels of dataset
%  A in both directions (training labels in A - B, test labels in B - A),
%  while dataset B keeps its labels. The two directions of the observed
%  analysis use the same data and labels, so they are correlated; permuting
%  each direction separately loses this correlation and the null
%  distribution of their mean is too narrow. With supertrials, both
%  directions of a repetition use the same supertrials of each dataset.
%
%  Limitation: the permutation also removes the decoding within dataset A.
%  If datasets A and B contain decoding effects that are not shared, the
%  null distribution can be narrower than the distribution of the
%  cross-decoding between them, so the test can be liberal. The sign flip
%  test (cfg.stats.signflip) does not permute labels, so it is recommended
%  for MVCC (see mvpalab_signmaps).
%
%  With cfg.stats.flag enabled, it also computes the maps of the null
%  distribution (see mvpalab_decodingnullmaps) and the permutation test
%  (see mvpalab_permtest) in the same call, with the same cfg, so the
%  result and its null distribution always follow the same settings. To
%  repeat the test with other settings of cfg.stats (for example
%  cfg.stats.pclust), call mvpalab_permtest again with the returned null
%  maps. The 'permuted' mode only returns the permuted maps.
%
%  It stops with an error before computing or saving anything if a
%  setting is not valid (see mvpalab_validatedecoding) or if cfg.sf.flag is
%  enabled, because a sliding filter analysis is computed by
%  mvpalab_sfilter. It saves:
%
%  - cfg.mat, once the settings are checked and again at the end, with the
%    fields set by the analysis (see mvpalab_savecfg).
%  - The result (result.mat) or the permuted maps (permaps.mat) of each
%    metric in cfg.savefolder: cfg.location/results/cfg.analysis/
%    time_resolved or temporal_generalization (see mvpalab_save).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject (single trials if cfg.trialaver.flag
%    is enabled).
%
%  - {string} - mode:
%    'observed' (default) or 'permuted'.
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Result or permuted maps of each performance metric (see
%    mvpalab_storemap). In MVPA, without the level of the direction.
%
%  - {struct} - cfg:
%    Updated configuration structure.
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag.
%
%  - {struct} - nullmaps:
%    Maps of the null distribution (see mvpalab_decodingnullmaps), empty
%    without cfg.stats.flag.

if nargin < 2, fv = []; end
if nargin < 3, mode = 'observed'; end

cfg = mvpalab_updatecfg(cfg);
cfg.stats.pairing = 'random';  % Saved with every file (see mvpalab_permtest).

% Check the settings of the analysis:
if cfg.sf.flag
    error('mvpalab:decoding',...
        'Use mvpalab_sfilter for a sliding filter analysis (cfg.sf.flag).');
end
mvpalab_validatedecoding(cfg,mode);
mvpalab_savecfg(cfg);

% Folder of the results (see mvpalab_save):
folder = 'time_resolved';
if cfg.classmodel.tempgen, folder = 'temporal_generalization'; end
cfg.savefolder = fullfile(cfg.location,'results',cfg.analysis,folder);

[res,cfg,job] = mvpalab_evalsubjects(cfg,fv,mode);

% Save result:
mvpalab_save(cfg,res,job.savemode);

% Null maps and permutation test of the observed result, if needed:
stats = [];
nullmaps = [];
if strcmp(mode,'observed') && cfg.stats.flag
    [nullmaps,cfg] = mvpalab_decodingnullmaps(cfg,fv,res);
    stats = mvpalab_permtest(cfg,res,nullmaps);
end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end
