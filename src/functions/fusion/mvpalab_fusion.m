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
%
%  The mode 'no-mean' (each pair of an fMRI subject and an M/EEG subject)
%  was removed: no published fusion or toolbox correlates all the pairs,
%  and its observations are not independent.
%
%  Shared permutation test (cfg.stats.flag):
%
%  - Each permutation reorders the conditions of the M/EEG RDM, rows and
%    columns together, and the same permutation is used for all the
%    observations, all the timepoints and all the regions (local function
%    sharedpidx): the identity and then cfg.stats.nper permutations, or
%    all the different permutations (factorial of the conditions minus 1)
%    if there are not more than cfg.stats.nper, which gives an exact test.
%  - The null map at group level of each permutation is the mean of its
%    maps of all the observations (mvpalab_permtest with pairing
%    'shared'), so the null distribution includes the noise that the
%    observations share, the averaged RDM. cfg.stats.nperg is not used.
%  - Independent permutations per observation combined at random (Stelzer
%    et al., 2013), or the sign flip test, leave that shared noise out and
%    are liberal when one modality has structure that the other does not
%    share. In a simulation with a 5% level they reached 22-30% of false
%    positives in 'mean-eeg' and 8-13% in 'mean-fmri', while the shared
%    permutation stayed at 2-5% in both modes. The sign flip test is not
%    available (see mvpalab_checkfusion).
%  - The conditions are treated as random and the subjects of both
%    modalities as fixed: the result holds for these subjects and these
%    conditions (the condition-label randomization test of Nili et al.,
%    2014). It does not generalize to new subjects.
%
%  The results and the permuted maps are saved with mvpalab_save, the
%  statistics are saved by mvpalab_permtest, and the configuration is
%  saved with mvpalab_savecfg once the settings are checked (see
%  mvpalab_checkfusion) and at the end of the analysis.
%
%  - Nili, H., Wingfield, C., Walther, A., Su, L., Marslen-Wilson, W., &
%    Kriegeskorte, N. (2014). A toolbox for representational similarity
%    analysis. PLoS Computational Biology, 10(4), e1003553.
%
%  - Stelzer, J., Chen, Y., & Turner, R. (2013). Statistical inference and
%    multiple testing correction in classification-based multi-voxel
%    pattern analysis (MVPA): random permutations and cluster size
%    control. NeuroImage, 65, 69-82.
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
%    subject ('mean-fmri') or per fMRI subject ('mean-eeg').
%
%  - {struct} - nullmaps:
%    Maps of the null distribution of the permutation test, in
%    nullmaps.(cfg.fusion.distance).(region): the permuted maps
%    [1 x timepoints x observations x permutations], where map k of every
%    observation uses the same permutation. Empty without
%    cfg.stats.flag.
%
%  - {struct} - stats:
%    Result of the permutation test (see mvpalab_permtest), empty without
%    cfg.stats.flag, in stats.(cfg.fusion.distance).(region), as res.

%% Initialization:
cfg = mvpalab_updatecfg(cfg);
nconds = size(eeg_rdms{1},1);
mvpalab_checkfusion(cfg,nconds);
mvpalab_savecfg(cfg);

dist = cfg.fusion.distance;
permaps = struct();
nullmaps = struct();
stats = struct();

% Shared permutations of the conditions, the same for every observation
% and region:
pidx = sharedpidx(cfg,nconds,cfg.stats.flag);

%% Compute fusion:
regions = fieldnames(fmri_rdms);

for roi = 1 : numel(regions)
    region = regions{roi};
    fprintf(['\n<strong> > Computing fusion: </strong>- Region: ' region '\n']);

    [veeg,vfmri] = mvpalab_fusionpairs(cfg,eeg_rdms,fmri_rdms.(region));

    for obs = 1 : numel(veeg)
        z = mvpalab_spearmanz(veeg{obs},vfmri{obs},pidx);
        res.(dist).(region)(1,:,obs) = z(:,1)';
        if cfg.stats.flag
            permaps.(dist).(region)(1,:,obs,:) = permute(z(:,2:end),[3 1 4 2]);
        end
    end
end

%% Save results:
mvpalab_save(cfg,res,'res');

%% Shared permutation test if needed:
if cfg.stats.flag
    nullmaps = permaps;
    stats = mvpalab_permtest(cfg,res,nullmaps,'shared');
    mvpalab_save(cfg,permaps,'permaps');
end

% Save the configuration with the fields set by the analysis:
mvpalab_savecfg(cfg);

end

function pidx = sharedpidx(cfg,nconds,permuted)
%% Order of the pairs of conditions of each map [maps x pairs], shared by
%  all the observations: the identity (the observed map) and then
%  cfg.stats.nper permutations (see mvpalab_rsapermidx), or every
%  different permutation once if there are not more than cfg.stats.nper.

nvec = nconds*(nconds - 1)/2;
if ~permuted || factorial(nconds) - 1 > cfg.stats.nper
    pidx = mvpalab_rsapermidx(cfg,nvec,permuted);
    return
end

lin = squareform(1:nvec);
orders = perms(1:nconds);
orders = orders(any(orders ~= 1:nconds,2),:);
pidx = zeros(size(orders,1) + 1,nvec);
pidx(1,:) = 1 : nvec;
for k = 1 : size(orders,1)
    p = orders(k,:);
    pidx(k + 1,:) = squareform(lin(p,p));
end

end
