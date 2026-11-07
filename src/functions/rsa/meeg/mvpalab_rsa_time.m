function [res,stats,cfg] = mvpalab_rsa_time(cfg,fv)
%% MVPALAB_RSA_TIME
%
%  This function computes the time-resolved representational similarity
%  analysis of M/EEG data. For each subject it builds the supertrials
%  (mvpalab_supertrials), the RDM at each timepoint of cfg.tm.tpoints
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
%  The observed map is the permuted map with the identity (see
%  mvpalab_rsapermidx), and the permutations of a subject are drawn once
%  and shared by all the models (see mvpalab_rsamaps).
%
%  The RDMs use the channels of cfg.channels.selected (all of them if it is
%  empty). The values 3 and 4 of cfg.normdata have no effect in RSA (a
%  warning is shown). With cfg.stats.flag the permuted maps are computed and the
%  permutation test is run (mvpalab_permtest); with cfg.stats.signflip the
%  sign flip test is used instead (mvpalab_signmaps).
%
%  The results and the permuted maps are saved with mvpalab_save and the
%  statistics by mvpalab_permtest, except in a sliding filter analysis
%  (cfg.sf.flag). The configuration is saved with mvpalab_savecfg at the
%  start and at the end of the analysis.
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
%      correlation [1 x timepoints x subjects] in 'corr', or the fields
%      bvalues and tvalues of the same size in 'regress' and
%      'multiple_regress'.
%    - rdms: Cell array with the RDM of each subject [conditions x
%      conditions x timepoints] or, with cfg.rsa.trialwise, [trials x
%      trials x timepoints].
%    - theo: Cell array with the theoretical RDMs of each subject (see
%      mvpalab_gentrdms).
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag.
%
%  - {struct} - cfg:
%    Configuration structure, with the condition boundaries of each
%    subject in cfg.rsa.bounds (see mvpalab_findbound).

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);
mvpalab_savecfg(cfg);
mvpalab_checksignflip(cfg);

%% Initialize
stats = struct();
nsub = length(cfg.study.dataFiles{1,1});
mode = cfg.rsa.modality;
dist = cfg.rsa.distance;
permuted = cfg.stats.flag && ~cfg.stats.signflip;
res.(mode).(dist) = struct();
permaps.(mode).(dist) = struct();

%% Check the configuration:
mvpalab_checkrsa(cfg);

%% Subjects loop:
for sub = 1 : nsub

    fprintf('\n<strong> > Computing RSA analysis: </strong>');
    fprintf(['- Subject: ' int2str(sub) '/' int2str(nsub) '\n\n']);

    %%  Select datamatrix:
    %   Select subject data, labels and timepoints. The RDMs are computed
    %   once, so the supertrials are also built once per subject.

    mvpalab_checkfv(cfg,fv{sub});
    data.a.X = fv{sub}.X.a; data.a.Y = fv{sub}.Y.a;
    data = mvpalab_supertrials(cfg,data);
    X = mvpalab_chanselection(data.a.X,cfg); Y = data.a.Y;
    X = X(:,:,cfg.tm.tpoints);

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

    %% Observed and permuted maps of the subject:
    pidx = mvpalab_rsapermidx(cfg,size(vrdm,2),permuted);
    maps = mvpalab_rsamaps(cfg,vrdm,vtheo,pidx);
    [res.(mode).(dist),permaps.(mode).(dist)] = storemaps(...
        res.(mode).(dist),permaps.(mode).(dist),maps,sub);
end

%% Condition boundaries of each subject (see mvpalab_findbound):
cfg.rsa.bounds = cellfun(@mvpalab_findbound,labels,'UniformOutput',false);

% Locations of the selected channels, once every subject has passed the
% check of the selection (see mvpalab_chanselection):
cfg = mvpalab_updatechanloc(cfg.channels.selected,cfg);

%% Save RSA data:
%  Only the RDM matrices are saved (numeric [conditions x conditions x
%  timepoints] or [trials x trials x timepoints] for each subject), as in
%  the fMRI ROI analysis. This is the format read by the fusion analysis
%  (mvpalab_fusion). The condition boundaries are saved in cfg.rsa.bounds.

res.(mode).(dist).rdms = rdms;
res.(mode).(dist).theo = theo;

% Save results:
if ~cfg.sf.flag, mvpalab_save(cfg,res,'res'); end

if permuted
    if ~cfg.sf.flag, mvpalab_save(cfg,permaps,'permaps'); end
end

%% Compute permutation test:
%  If needed. The correlations and the coefficients have no effect at 0.

if cfg.stats.flag
    if cfg.stats.signflip, permaps = mvpalab_signmaps(res,0); end
    stats = mvpalab_permtest(cfg,res,permaps);
end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end

function [obs,per] = storemaps(obs,per,maps,sub)
%% Observed map (first column) and permuted maps of one subject, in each
%  field of the maps.

if isstruct(maps)
    for field = fieldnames(maps)'
        name = field{1};
        if ~isfield(obs,name), obs.(name) = []; per.(name) = []; end
        [obs.(name),per.(name)] = storemaps(obs.(name),per.(name),maps.(name),sub);
    end
    return
end

obs(1,:,sub) = maps(:,1)';
if size(maps,2) > 1
    per(1,:,sub,:) = permute(maps(:,2:end),[3 1 4 2]);
end

end
