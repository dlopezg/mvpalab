function job = mvpalab_decodingjob(cfg,mode)
%% MVPALAB_DECODINGJOB
%
%  This function returns the description of a decoding analysis (see
%  mvpalab_decoding). The structure is passed along the pipeline, which
%  completes it with the current subject, band, map and repetition.
%
%  The permuted maps only contain the metrics that can be compared with a
%  null distribution: every field of the result needs its permuted map in
%  mvpalab_permtest, except for the ROC curves, the confusion matrices and
%  the feature weights, which are not computed for them.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {string} - mode:
%    'observed' or 'permuted'.
%
%%  OUTPUT:
%
%  - {struct} - job:
%    - mvcc:     True in a cross-classification analysis.
%    - permuted: True if the maps are computed with permuted labels.
%    - dirs:     Field name of each direction of a map: 'aa' (MVPA, within
%                dataset A) or 'ab' and 'ba' (MVCC, training - test).
%    - nsub:     Number of subjects.
%    - nfreq:    Number of frequency bands.
%    - nper:     Number of maps.
%    - nreps:    Number of repetitions: k-fold, or MVCC without
%                cross-validation if each repetition draws new supertrials.
%    - numeric:  Metrics stored in numeric maps: 'acc' and 'auc'.
%    - averaged: Metrics stored per timepoint, averaged across repetitions.
%    - lastrep:  ROC curves, taken from the last repetition.
%    - keep:     Outputs of the evaluation functions that are needed.
%    - folders:  Subject folders of a sliding filter analysis.
%    - title:    Name of the analysis in the console.
%    - savemode: Save modality of mvpalab_save.
%
%    The pipeline completes the structure with:
%    - sub, freq, per, rep: Current subject, band, map and repetition.

if ~any(strcmp(mode,{'observed','permuted'}))
    error('The mode of mvpalab_decoding must be ''observed'' or ''permuted''.');
end

job.mvcc = strcmp(cfg.analysis,'MVCC');
job.permuted = strcmp(mode,'permuted');

job.dirs = {'aa'};
if job.mvcc, job.dirs = {'ab','ba'}; end

job.nsub = length(cfg.study.dataFiles{1,1});

job.nfreq = 1;
job.folders = [];
if cfg.sf.flag
    job.nfreq = length(cfg.sf.freqvec);
    job.folders = dir([cfg.sf.filesLocation filesep 'fv' filesep 's_*']);
end

job.nper = 1;
if job.permuted, job.nper = cfg.stats.nper; end

job.nreps = 1;
redraw = job.mvcc && strcmp(cfg.cv.method,'none') && cfg.trialaver.flag ...
    && strcmp(cfg.trialaver.order,'rand');
if strcmp(cfg.cv.method,'kfold') || redraw, job.nreps = cfg.cv.nreps; end

job.numeric = {'acc'};
if cfg.classmodel.auc, job.numeric = {'acc','auc'}; end

metrics = {'precision','recall','f1score'};
if ~job.permuted, metrics = [{'confmat'} metrics {'wvector'}]; end
enabled = cellfun(@(metric) logical(cfg.classmodel.(metric)),metrics);
job.averaged = metrics(enabled);

job.lastrep = {};
if ~job.permuted && cfg.classmodel.roc, job.lastrep = {'x','y','t'}; end

job.keep = [job.numeric job.averaged job.lastrep];

if ~job.permuted
    job.savemode = 'res';
    job.title = 'MVPA analysis';
    if job.mvcc, job.title = 'MVCC analysis'; end
else
    job.savemode = 'permaps';
    job.title = 'permuted maps';
    if job.mvcc, job.title = 'permuted maps (MVCC)'; end
end

end
