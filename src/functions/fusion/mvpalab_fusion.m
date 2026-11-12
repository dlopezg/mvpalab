function [res,cfg,stats,nullmaps] = mvpalab_fusion(cfg,eeg_rdms,fmri_rdms)
%% MVPALAB_FUSION
%
%  This function computes the fusion of the M/EEG and fMRI RDMs: the RDM of
%  each region of interest is correlated with the M/EEG RDM at each
%  timepoint (Spearman correlation, Fisher z-transformed, see
%  mvpalab_spearmanz). The subjects are combined as set in
%  cfg.fusion.mode (see mvpalab_fusionpairs):
%
%  - 'mean-fmri': the mean fMRI RDM of each region (mvpalab_meanrdm) with
%    the RDM of each M/EEG subject.
%  - 'mean-eeg': the mean M/EEG RDM with the RDM of each fMRI subject.
%
%  The mode 'no-mean' (each pair of an fMRI subject and an M/EEG subject)
%  was removed: no published fusion or toolbox correlates all the pairs,
%  and its observations are not independent.
%
%  With cfg.stats.flag enabled, it also computes the maps of the null
%  distribution (see mvpalab_fusionnullmaps) and the permutation test (see
%  mvpalab_permtest) in the same call, with the same cfg, so the result and
%  its null distribution always follow the same settings. To repeat the
%  test with other settings of cfg.stats (for example cfg.stats.pclust),
%  call mvpalab_permtest again with the returned null maps. The test uses a
%  permutation of the conditions shared by all the observations (see
%  mvpalab_fusionnullmaps).
%
%  The conditions are paired by their position in the RDMs: the names of
%  the conditions are not compared, because they can be different in the
%  two modalities. The pairs of each region are shown in the console and
%  kept in cfg.fusion.conditions.(region) [conditions x 2] (M/EEG, fMRI)
%  so they can be checked. Only the number of conditions is checked (see
%  mvpalab_validatefusionrdms).
%
%  The results are saved with mvpalab_save in cfg.savefolder. The
%  configuration is saved with mvpalab_savecfg once the settings are
%  checked (see mvpalab_validatefusion) and at the end of the analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - eeg_rdms:
%    RDMs of the M/EEG subjects, the field rdms of the result of
%    mvpalab_rsa_time (condition-wise): the RDM of each subject in rdm
%    [conditions x conditions x timepoints] and the names of the
%    conditions in conditions.
%
%  - {struct} - fmri_rdms:
%    One field per region of interest with the RDMs of the fMRI subjects,
%    the field rdms of each region in the result of mvpalab_rsa_roi: the
%    RDM of each subject in rdm [conditions x conditions] and the names of
%    the conditions in conditions.
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Correlations in res.(region) [1 x timepoints x observations], with
%    one observation per M/EEG subject ('mean-fmri') or per fMRI subject
%    ('mean-eeg'). They are saved in cfg.savefolder,
%    cfg.location/results/cfg.analysis/<region> (see mvpalab_save): use
%    cfg.analysis to keep apart the fusions of RDMs computed with different
%    distances.
%
%  - {struct} - cfg:
%    Configuration structure, with the pairs of conditions of each region
%    in cfg.fusion.conditions.
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag.
%
%  - {struct} - nullmaps:
%    Maps of the null distribution (see mvpalab_fusionnullmaps), empty
%    without cfg.stats.flag.

%% Initialization:
cfg = mvpalab_updatecfg(cfg);
cfg.stats.pairing = 'shared';  % Saved with every file (see mvpalab_permtest).
mvpalab_validatefusion(cfg);
mvpalab_validatefusionrdms(eeg_rdms,fmri_rdms);
cfg = conditionpairs(cfg,eeg_rdms,fmri_rdms);
mvpalab_savecfg(cfg);
cfg.savefolder = fullfile(cfg.location,'results',cfg.analysis);

%% Compute fusion:
regions = fieldnames(fmri_rdms);

for roi = 1 : numel(regions)
    region = regions{roi};
    fprintf(['\n<strong> > Computing fusion: </strong>- Region: ' region '\n']);

    [veeg,vfmri] = mvpalab_fusionpairs(cfg,eeg_rdms.rdm,...
        fmri_rdms.(region).rdm);

    for obs = 1 : numel(veeg)
        z = mvpalab_spearmanz(veeg{obs},vfmri{obs},1:numel(vfmri{obs}));
        res.(region)(1,:,obs) = z';
    end
end

%% Save results:
mvpalab_save(cfg,res,'res');

%% Shared permutation test, if needed:
stats = [];
nullmaps = [];
if cfg.stats.flag
    [nullmaps,cfg] = mvpalab_fusionnullmaps(cfg,eeg_rdms,fmri_rdms,res);
    stats = mvpalab_permtest(cfg,res,nullmaps);
end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end

function cfg = conditionpairs(cfg,eeg_rdms,fmri_rdms)
%% Pairs of conditions of each region, shown in the console and kept in cfg.

fprintf('\n<strong> > Pairs of conditions (M/EEG - fMRI): </strong>\n');
cfg.fusion.conditions = struct();
regions = fieldnames(fmri_rdms);
for roi = 1 : numel(regions)
    pairs = [eeg_rdms.conditions(:) fmri_rdms.(regions{roi}).conditions(:)];
    cfg.fusion.conditions.(regions{roi}) = pairs;
    fprintf('   - Region: %s\n',regions{roi});
    for c = 1 : size(pairs,1)
        fprintf('      %2d. %s - %s\n',c,pairs{c,1},pairs{c,2});
    end
end

end
