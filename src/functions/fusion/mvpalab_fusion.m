function [cfg,res,permaps,stats] = mvpalab_fusion(cfg,eeg_rdms,fmri_rdms)
%% MVPALAB_FUSION
%
%  This function computes the fusion of the M/EEG and fMRI RDMs: the RDM of
%  each region of interest is correlated with the M/EEG RDM at each
%  timepoint (Spearman correlation, Fisher z-transformed, see
%  mvpalab_computecorr). The subjects are combined as set in
%  cfg.fusion.mode:
%
%  - 'mean-fmri': the mean fMRI RDM of each region (mvpalab_meanrdm) with
%    the RDM of each M/EEG subject (mvpalab_fusion_meanfmri).
%  - 'mean-eeg': the mean M/EEG RDM with the RDM of each fMRI subject
%    (mvpalab_fusion_meaneeg).
%  - 'no-mean': each pair of an fMRI subject and an M/EEG subject
%    (mvpalab_fusion_nomean). The observations are not independent, so the
%    sign flip test (cfg.stats.signflip) is not available.
%
%  With cfg.stats.flag the permutation test is run (mvpalab_permtest), with
%  the permuted maps or, with cfg.stats.signflip, the maps of the sign flip
%  test (mvpalab_signmaps). The results and the permuted maps are saved
%  with mvpalab_save, the statistics are saved by mvpalab_permtest, and the
%  configuration is saved with mvpalab_savecfg at the start and at the end
%  of the analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - eeg_rdms:
%    RDM of each M/EEG subject [conditions x conditions x timepoints], as
%    in the field rdms of the result of mvpalab_rsa_time.
%
%  - {struct} - fmri_rdms:
%    One field per region of interest, with a cell array that contains the
%    RDM of each fMRI subject [conditions x conditions], as in the field
%    rdms of each region in the result of mvpalab_rsa_roi.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - res:
%    Correlations in res.(cfg.fusion.distance).(region)
%    [1 x timepoints x observations], with one observation per M/EEG
%    subject ('mean-fmri'), per fMRI subject ('mean-eeg') or per pair of
%    subjects ('no-mean').
%
%  - {struct} - permaps:
%    Permuted maps in permaps.(cfg.fusion.distance).(region)
%    [1 x timepoints x observations x permutations], or the maps of the
%    sign flip test [1 x timepoints x observations x 2]. Empty without
%    cfg.stats.flag.
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag. mvpalab_permtest receives the whole res, so the
%    statistics are in
%    stats.(cfg.fusion.distance).(cfg.fusion.distance).(region).

%% Initialization;

cfg = mvpalab_checkcfg(cfg);
mvpalab_savecfg(cfg);
permaps = struct();
stats = struct();

%% Check the statistics:
%  In 'no-mean' each observation is a pair of subjects, so the observations
%  are not independent and the signs cannot be flipped.

mvpalab_checksignflip(cfg);
if cfg.stats.signflip && strcmp(cfg.fusion.mode,'no-mean')
    error('The sign flip test is not available in the ''no-mean'' fusion mode.');
end

%% Compute fusion:
%  Description:

if strcmp(cfg.fusion.mode,'mean-fmri')
    [cfg,result] = mvpalab_fusion_meanfmri(cfg,fmri_rdms,eeg_rdms);
    
elseif strcmp(cfg.fusion.mode,'mean-eeg')
    [cfg,result] = mvpalab_fusion_meaneeg(cfg,fmri_rdms,eeg_rdms);
    
elseif strcmp(cfg.fusion.mode,'no-mean')
    [cfg,result] = mvpalab_fusion_nomean(cfg,fmri_rdms,eeg_rdms);
    
end

%% Save results:
res.(cfg.fusion.distance) = result.res;
mvpalab_save(cfg,res,'res');

%% Compute permutation test:
%  If needed:

if cfg.stats.flag
    if cfg.stats.signflip
        permaps = mvpalab_signmaps(res,0);
    else
        permaps.(cfg.fusion.distance) = result.permaps;
    end
    stats.(cfg.fusion.distance) = mvpalab_permtest(cfg,res,permaps);
    
end

%% Save permuted maps:
%  If needed:

if cfg.stats.flag && ~cfg.stats.signflip
    mvpalab_save(cfg,permaps,'permaps');
end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);


end

