function [nullmaps,cfg] = mvpalab_fusionnullmaps(cfg,eeg_rdms,fmri_rdms,res)
%% MVPALAB_FUSIONNULLMAPS
%
%  This function returns the maps of the null distribution of the shared
%  permutation test of an M/EEG-fMRI fusion (see mvpalab_fusion), the
%  input of mvpalab_permtest:
%
%  - Each permutation reorders the conditions of the M/EEG RDM, rows and
%    columns together, and the same permutation is used for all the
%    observations, all the timepoints and all the regions (local function
%    sharedpidx): cfg.stats.nper permutations, or all the different
%    permutations (factorial of the conditions minus 1) if there are not
%    more than cfg.stats.nper, which gives an exact test.
%  - nullmaps.pairing = 'shared' tells mvpalab_permtest that the null map
%    at group level of each permutation is the mean of its maps of all the
%    observations, so the null distribution includes the noise that the
%    observations share, the averaged RDM. cfg.stats.nperg is not used.
%  - Independent permutations per observation combined at random (Stelzer
%    et al., 2013), or the sign flip test, leave that shared noise out and
%    are liberal when one modality has structure that the other does not
%    share. In a simulation with a 5% level they reached 22-30% of false
%    positives in 'mean-eeg' and 8-13% in 'mean-fmri', while the shared
%    permutation stayed at 2-5% in both modes. The sign flip test is not
%    available (see mvpalab_validatefusion).
%  - The conditions are treated as random and the subjects of both
%    modalities as fixed: the result holds for these subjects and these
%    conditions (the condition-label randomization test of Nili et al.,
%    2014). It does not generalize to new subjects.
%
%  It warns if the null distribution has few maps (cfg.stats.nper below
%  1000, unless every different permutation is used) or if there are fewer
%  than 7 conditions (Nili et al., 2014): with n conditions there are only
%  factorial(n) orders, so no p-value is below 1/factorial(n).
%
%  mvpalab_fusion calls it with cfg.stats.flag enabled, with its own cfg,
%  so the null maps always follow the settings of the result. To call it
%  separately, use the cfg returned by mvpalab_fusion. The RDMs are
%  checked: they must give the observed correlations of res, so the null
%  maps come from the same data. The permuted maps are saved with
%  mvpalab_save.
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
%    Configuration structure returned by mvpalab_fusion.
%
%  - {cell array} - eeg_rdms:
%    RDMs of the M/EEG subjects, as in mvpalab_fusion.
%
%  - {struct} - fmri_rdms:
%    RDMs of the fMRI subjects of each region, as in mvpalab_fusion.
%
%  - {struct} - res:
%    Result of mvpalab_fusion.
%
%%  OUTPUT:
%
%  - {struct} - nullmaps:
%    Permuted maps of each region in nullmaps.(region)
%    [1 x timepoints x observations x permutations], where map k of every
%    observation uses the same permutation, and pairing = 'shared'.
%
%  - {struct} - cfg:
%    Configuration structure.

cfg = mvpalab_updatecfg(cfg);
mvpalab_validatefusion(cfg);

nconds = size(eeg_rdms{1},1);
if factorial(nconds) - 1 > cfg.stats.nper && cfg.stats.nper < 1000
    warning(['The shared permutation test of the fusion has one null map ' ...
        'per permutation, and cfg.stats.nper = %d. Use at least 1000.'],...
        cfg.stats.nper);
end
if nconds < 7
    warning(['With %d conditions there are only %d permutations, so no ' ...
        'p-value of the fusion can be below 1/%d. Use at least 7 ' ...
        'conditions.'],nconds,factorial(nconds),factorial(nconds));
end

% Shared permutations of the conditions, after the identity:
pidx = sharedpidx(cfg,nconds);

regions = fieldnames(fmri_rdms);
for roi = 1 : numel(regions)
    region = regions{roi};
    fprintf(['\n<strong> > Computing fusion permuted maps: </strong>- Region: ' region '\n']);

    [veeg,vfmri] = mvpalab_fusionpairs(cfg,eeg_rdms,fmri_rdms.(region));

    for obs = 1 : numel(veeg)
        z = mvpalab_spearmanz(veeg{obs},vfmri{obs},pidx);
        if ~isequaln(z(:,1)',res.(region)(1,:,obs))
            error(['The RDMs of region %s do not give the result of the ' ...
                'fusion: use the RDMs of the analysis.'],region);
        end
        nullmaps.(region)(1,:,obs,:) = permute(z(:,2:end),[3 1 4 2]);
    end
end

mvpalab_save(cfg,nullmaps,'permaps');
nullmaps.pairing = 'shared';

end

function pidx = sharedpidx(cfg,nconds)
%% Order of the pairs of conditions of each map [maps x pairs], shared by
%  all the observations: the identity (the observed map) and then
%  cfg.stats.nper permutations (see mvpalab_rsapermidx), or every
%  different permutation once if there are not more than cfg.stats.nper.

nvec = nconds*(nconds - 1)/2;
if factorial(nconds) - 1 > cfg.stats.nper
    pidx = mvpalab_rsapermidx(cfg,nvec,true);
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
