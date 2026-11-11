function [cfg,res,nullmaps,stats] = mvpalab_fusion(cfg,eeg_rdms,fmri_rdms)
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
%  - 'no-mean': each pair of an fMRI subject and an M/EEG subject. The
%    observations are not independent, so the sign flip test
%    (cfg.stats.signflip) is not available.
%
%  The permuted maps permute the conditions of the M/EEG RDM in every
%  mode (see mvpalab_rsapermidx).
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
%  - {struct} - nullmaps:
%    Maps of the null distribution of the permutation test, in
%    nullmaps.(cfg.fusion.distance).(region): the permuted maps
%    [1 x timepoints x observations x permutations] or, with
%    cfg.stats.signflip, the maps of the sign flip test
%    [1 x timepoints x observations x 2]. Empty without cfg.stats.flag.
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag, in stats.(cfg.fusion.distance).(region), as res.

%% Initialization:
cfg = mvpalab_updatecfg(cfg);
mvpalab_savecfg(cfg);
mvpalab_checkfusion(cfg);

dist = cfg.fusion.distance;
permuted = cfg.stats.flag && ~cfg.stats.signflip;
permaps = struct();
nullmaps = struct();
stats = struct();

%% Compute fusion:
regions = fieldnames(fmri_rdms);

for roi = 1 : numel(regions)
    region = regions{roi};
    fprintf(['\n<strong> > Computing fusion: </strong>- Region: ' region '\n']);

    [veeg,vfmri] = mvpalab_fusionpairs(cfg,eeg_rdms,fmri_rdms.(region));

    for obs = 1 : numel(veeg)
        pidx = mvpalab_rsapermidx(cfg,size(veeg{obs},2),permuted);
        z = mvpalab_spearmanz(veeg{obs},vfmri{obs},pidx);
        res.(dist).(region)(1,:,obs) = z(:,1)';
        if permuted
            permaps.(dist).(region)(1,:,obs,:) = permute(z(:,2:end),[3 1 4 2]);
        end
    end
end

%% Save results:
mvpalab_save(cfg,res,'res');

%% Compute permutation test if needed:
if cfg.stats.flag
    nullmaps = permaps;
    if cfg.stats.signflip, nullmaps = mvpalab_signmaps(cfg,res,0); end
    stats = mvpalab_permtest(cfg,res,nullmaps);
end

%% Save permuted maps if needed:
if permuted, mvpalab_save(cfg,permaps,'permaps'); end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end
