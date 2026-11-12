function [clusters,corrcsize] = mvpalab_clusterpvals(cfg,clusters,sizedist,maxdist)
%% MVPALAB_CLUSTERPVALS
%
%  This function computes the cluster-level p-values of the clusters found
%  in the real data and decides which of them are significant. Two
%  correction methods are available (cfg.stats.clustcorr):
%
%  - 'fdr': For each cluster, the p-value is the probability of obtaining
%    a cluster of equal or greater size in the null distribution of all
%    the clusters found in all the permuted maps (sizedist). The
%    Benjamini-Hochberg FDR correction is then applied to the vector of
%    cluster p-values (Stelzer et al., 2013, see mvpalab_bhfdr). Controls
%    the false discovery rate among the significant clusters.
%
%  - 'max': For each cluster, the p-value is the probability of obtaining
%    a maximum cluster of equal or greater size in the null distribution
%    of the largest cluster of each permuted map (maxdist). No further
%    correction is needed (Maris & Oostenveld, 2007). Controls the
%    family-wise error rate.
%
%  In both cases the standard (count + 1) / (N + 1) smoothing is used to
%  avoid p = 0 with a finite number of permutations.
%
%%  REFERENCES:
%
%  - Maris, E., & Oostenveld, R. (2007). Nonparametric statistical testing
%    of EEG- and MEG-data. Journal of Neuroscience Methods, 164(1),
%    177-190. https://doi.org/10.1016/j.jneumeth.2007.03.024
%
%  - Stelzer, J., Chen, Y., & Turner, R. (2013). Statistical inference and
%    multiple testing correction in classification-based multi-voxel
%    pattern analysis (MVPA): random permutations and cluster size
%    control. NeuroImage, 65, 69-82.
%    https://doi.org/10.1016/j.neuroimage.2012.09.063
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - clusters:
%    Clusters found in the real data (output of bwconncomp).
%
%  - {matrix} - sizedist:
%    Sizes of all the clusters found in all the permuted maps.
%
%  - {matrix} - maxdist:
%    Size of the largest cluster of each permuted map (0 if the permuted
%    map has no clusters). [1 x cfg.stats.nperg]
%
%%  OUTPUT:
%
%  - {struct} - clusters:
%    Input structure with the following new fields:
%    - sizes:   Size of each cluster.
%    - pvals:   Cluster p-values. Uncorrected for 'fdr' and FWER-corrected
%               for 'max'.
%    - fdr:     FDR-adjusted p-values ('fdr' only, empty for 'max').
%    - sig_idx: Significant clusters (logical).
%    - sig:     Indexes of all the significant points.
%    - maxdist: Null distribution of the maximum cluster size.
%
%  - {double} - corrcsize:
%    Minimum size of the significant clusters (Inf if none).
%

alpha = (100 - cfg.stats.pclust) / 100;
nC = clusters.NumObjects;

%% Cluster sizes and p-values:
csizes = zeros(nC,1);
cpvals = ones(nC,1);
cfdr   = [];

for i = 1 : nC
    csizes(i) = numel(clusters.PixelIdxList{i});
    if strcmp(cfg.stats.clustcorr,'max')
        cpvals(i) = (sum(maxdist >= csizes(i)) + 1) / (numel(maxdist) + 1);
    else
        cpvals(i) = (sum(sizedist >= csizes(i)) + 1) / (numel(sizedist) + 1);
    end
end

%% Significant clusters:
%  cfg.stats.clustcorr is 'max' or 'fdr' (see mvpalab_validatestats):
if strcmp(cfg.stats.clustcorr,'max')
    sig_idx = cpvals < alpha;
else
    if nC > 0
        cfdr = mvpalab_bhfdr(cpvals);
    end
    sig_idx = cfdr < alpha;
end

clusters.sig = [];
for i = 1 : nC
    if sig_idx(i)
        clusters.sig = [clusters.sig; clusters.PixelIdxList{i}];
    end
end

clusters.sizes   = csizes;
clusters.pvals   = cpvals;
clusters.fdr     = cfdr;
clusters.sig_idx = sig_idx;
clusters.maxdist = maxdist;

corrcsize = Inf;
if any(sig_idx)
    corrcsize = min(csizes(sig_idx));
end

end
