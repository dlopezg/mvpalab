function [res,cfg,stats,nullmaps] = mvpalab_rsa_time(cfg,fv)
%% MVPALAB_RSA_TIME
%
%  This function computes the time-resolved representational similarity
%  analysis of M/EEG data. For each subject it prepares the data
%  (mvpalab_preparedata), the RDM at each timepoint of cfg.tm.tpoints
%  (mvpalab_rdm) and the theoretical RDMs (mvpalab_gentrdms), and compares
%  them as set in cfg.rsa.modality:
%
%  - 'corr': Spearman correlation with each theoretical model, Fisher
%    z-transformed (mvpalab_spearmanz).
%  - 'regress': a general linear model for each theoretical model
%    (mvpalab_glm).
%  - 'multiple_regress': one general linear model with all the theoretical
%    models as regressors (mvpalab_glm).
%
%  The RDMs use the channels of cfg.channels.selected (all of them if it is
%  empty). The values 3 and 4 of cfg.normdata have no effect in RSA (a
%  warning is shown).
%
%  With cfg.stats.flag enabled, it also computes the maps of the null
%  distribution (see mvpalab_rsanullmaps) and the permutation test (see
%  mvpalab_permtest) in the same call, with the same cfg, so the result and
%  its null distribution always follow the same settings. To repeat the
%  test with other settings of cfg.stats (for example cfg.stats.pclust),
%  call mvpalab_permtest again with the returned null maps. The result
%  keeps the RDMs of each subject, so the null maps are computed from it.
%  The results are saved with mvpalab_save in cfg.savefolder. The
%  configuration is saved with mvpalab_savecfg once the settings are
%  checked (see mvpalab_validatersa) and at the end of the analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject, with the data in X.a [trials x
%    channels x timepoints] and the labels in Y.a.
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Results in res.(cfg.rsa.modality).(cfg.rsa.distance):
%    - One field per theoretical model (cfg.rsa.tmodels{i}.id): the
%      Fisher z of the Spearman correlation [1 x timepoints x subjects] in
%      'corr', or the fields
%      bvalues and tvalues of the same size in 'regress' and
%      'multiple_regress'.
%    - rdms: RDMs of the subjects, saved together in one file (see
%      mvpalab_save):
%      - rdm: Cell array with the RDM of each subject [conditions x
%        conditions x timepoints] or, with cfg.rsa.trialwise, [trials x
%        trials x timepoints].
%      - conditions: Names of the conditions in the order of the rows of
%        condition-wise RDMs (cfg.study.conditionIdentifier), the same
%        order as the rows of the theoretical models. In trial-wise RDMs
%        the condition of each row is in cfg.rsa.bounds.
%    - theo: Cell array with the theoretical RDMs of each subject (see
%      mvpalab_gentrdms).
%
%  - {struct} - cfg:
%    Configuration structure, with the condition boundaries of each
%    subject in cfg.rsa.bounds (see mvpalab_findbound).
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag.
%
%  - {struct} - nullmaps:
%    Maps of the null distribution (see mvpalab_rsanullmaps), empty without
%    cfg.stats.flag.

cfg = mvpalab_updatecfg(cfg);
cfg.stats.pairing = 'random';  % Saved with every file (see mvpalab_permtest).

%% Initialize
nsub = length(cfg.study.dataFiles{1,1});
mode = cfg.rsa.modality;
dist = cfg.rsa.distance;
res.(mode).(dist) = struct();

%% Check the configuration:
mvpalab_validatersa(cfg,size(cfg.study.dataFiles,2));
mvpalab_savecfg(cfg);
cfg.savefolder = fullfile(cfg.location,'results',cfg.analysis);

%% Subjects loop:
for sub = 1 : nsub

    fprintf('\n<strong> > Computing RSA analysis: </strong>');
    fprintf(['- Subject: ' int2str(sub) '/' int2str(nsub) '\n\n']);

    %%  Select datamatrix:
    %   Select subject data, labels and timepoints. The RDMs are computed
    %   once, so the data is prepared once per subject (see
    %   mvpalab_preparedata), as one repetition of a decoding analysis.

    mvpalab_validatefv(cfg,fv{sub});
    data.a.X = fv{sub}.X.a; data.a.Y = fv{sub}.Y.a;
    data = mvpalab_preparedata(cfg,data,max(cfg.rsa.nfolds,1));
    X = data.a.X(:,:,cfg.tm.tpoints); Y = data.a.Y;

    %% Neural and theoretical RDMs:
    %  rdm.rdm - [conditions x conditions x timepoints], or trials with
    %  cfg.rsa.trialwise. theo - [conditions x conditions x 1 x models].

    rdm = mvpalab_rdm(cfg,X,Y);
    rdms{sub} = rdm.rdm;
    labels{sub} = rdm.labels;
    theo{sub} = mvpalab_gentrdms(cfg,cfg.rsa.tmodels,rdm.labels);

    %% Vectorized RDMs:
    %  vrdm - [timepoints x pairs], vtheo - [pairs x models].

    vrdm = mvpalab_vectorizerdm(rdm.rdm);
    vtheo = permute(mvpalab_vectorizerdm(theo{sub}),[2 3 1]);

    %% Observed map of the subject (the identity order of the pairs):
    maps = mvpalab_rsamaps(cfg,vrdm,vtheo,1:size(vrdm,2));
    res.(mode).(dist) = mvpalab_storersamaps(res.(mode).(dist),maps,sub);
end

%% Condition boundaries of each subject (see mvpalab_findbound):
cfg.rsa.bounds = cellfun(@mvpalab_findbound,labels,'UniformOutput',false);

% Locations of the selected channels, once every subject has passed the
% check of the selection (see mvpalab_chanselection):
cfg = mvpalab_updatechanloc(cfg,cfg.channels.selected);

%% Save RSA data:
%  Only the RDM matrices are saved (numeric [conditions x conditions x
%  timepoints] or [trials x trials x timepoints] for each subject), as in
%  the fMRI ROI analysis. This is the format read by the fusion analysis
%  (mvpalab_fusion). The condition boundaries are saved in cfg.rsa.bounds.

res.(mode).(dist).rdms.rdm = rdms;
res.(mode).(dist).rdms.conditions = cfg.study.conditionIdentifier(1,:)';
res.(mode).(dist).theo = theo;

% Save results:
mvpalab_save(cfg,res,'res');

% Null maps and permutation test, if needed:
stats = [];
nullmaps = [];
if cfg.stats.flag
    [nullmaps,cfg] = mvpalab_rsanullmaps(cfg,res);
    stats = mvpalab_permtest(cfg,res,nullmaps);
end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end
