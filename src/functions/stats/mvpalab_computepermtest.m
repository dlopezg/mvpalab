function stats = mvpalab_computepermtest(cfg,performance,permuted_maps)
%% MVPALAB_COMPUTEPERMTEST
%
%  This function computes the cluster-based permutation test of one
%  performance map at group level (Stelzer et al., 2013):
%
%  - It builds cfg.stats.nperg permuted maps at group level, each one the
%    mean of one permuted map of each subject selected at random.
%  - At each position of the maps, the threshold is the percentile
%    cfg.stats.pgroup of this null distribution. With cfg.stats.tails = 2
%    the percentile is split between the two tails.
%  - The clusters are the connected positions above (or below) the
%    threshold (bwconncomp), in the permuted maps and in the group mean of
%    the real maps.
%  - Each cluster of the real data is accepted or rejected at the level
%    cfg.stats.pclust with the correction in cfg.stats.clustcorr: 'fdr',
%    the null distribution of all the cluster sizes with the
%    Benjamini-Hochberg FDR correction, or 'max', the null distribution of
%    the largest cluster of each permuted map (Maris & Oostenveld, 2007).
%    See mvpalab_clusterpvals.
%
%  cfg.stats.tails selects the tails: 1 (above chance), -1 (below chance)
%  or 2 (both). The function stops with an error if cfg.stats.tails is
%  not one of them or if the settings of the sign flip test are not valid
%  (see mvpalab_checksignflip). It opens a figure with the null
%  distribution at the last position of the maps and the null
%  distributions of the cluster sizes, which is closed if
%  cfg.stats.shownulldis is false. It does not save any file.
%
%  - Maris, E., & Oostenveld, R. (2007). Nonparametric statistical testing
%    of EEG- and MEG-data. Journal of Neuroscience Methods, 164(1),
%    177-190.
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
%  - {matrix} - performance:
%    Maps of each subject, for example the accuracy,
%    [ntp x ntp_ x subjects], with a single row in the time-resolved
%    analyses.
%
%  - {matrix} - permuted_maps:
%    Permuted maps of each subject [ntp x ntp_ x subjects x maps].
%
%%  OUTPUT:
%
%  - {struct} - stats:
%    Results of the test. The fields without _ are the above-chance tail
%    and the fields with _ the below-chance tail:
%    - thresdata, thresdata_: Logical maps [ntp x ntp_], true where the
%      group mean performance is above (below) the threshold. Empty if
%      the tail is not tested.
%    - clusters, clusters_: Clusters of thresdata (thresdata_), the
%      output of bwconncomp with the fields of mvpalab_clusterpvals
%      (sizes, pvals, fdr, sig_idx, sig, maxdist). With no objects and
%      empty fields if the tail is not tested.
%    - sigmask, sigmask_: Maps [ntp x ntp_] of ones, with 0 at the
%      positions of the significant clusters.
%    - corrcsize, corrcsize_: Minimum size of the significant clusters
%      (Inf if none or if the tail is not tested).

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

if ~ismember(cfg.stats.tails,[-1 1 2])
    error('cfg.stats.tails must be 1 (above chance), -1 (below chance) or 2.');
end

mvpalab_checksignflip(cfg);

%% Initilization - Generate permutation idx matrix:
% Here we determine the map of each subject that has to be selected in each
% permutation.
nSubjects = size(performance,3);
perm_idxs = randi(size(permuted_maps,4),nSubjects,cfg.stats.nperg,'single');

%% Generate permuted maps at group level:
% One permuted map of each subject has to be randomly selected and group
% averaged. Here we are using the previously determined permutation
% indexes for each subject and permutation.

fprintf('   - Generating permuted maps at group level: ');
for i = 1 : cfg.stats.nperg
    for j = 1 : nSubjects
        permaps(:,:,j) = permuted_maps(:,:,j,perm_idxs(j,i));
    end
    gpermaps(:,:,i) = mean(permaps,3);
end
fprintf(' - Done!\n');

%% Generate the null distribution and p-value thresholds:
% Generate the null distribution for each timepoint using the permuted
% performanceuracy maps. Here we can define the performance level 
% associated to a p-value of 0.05 (95th percentile) for each timepoint and 
% generate a threshold mask.

% Define the distribution threshold
threshold = cfg.stats.pgroup;

% Update de distribution threshold for two tail test.
if (cfg.stats.tails == 2)
    tail = ( 100 - cfg.stats.pgroup ) / 2;
    threshold = cfg.stats.pgroup + tail;  
end

% Tails of the test:
above = cfg.stats.tails ~= -1;
below = cfg.stats.tails ~= 1;

fprintf('   - Generating the null distribution and p-value thresholds:');
if above, pctval = percentiles(gpermaps,threshold); end
if below, pctval_ = percentiles(gpermaps,100-threshold); end
fprintf(' - Done!\n');

%% Plot the null distribution of performance values:
% Plot the null distribution of performance values at the last position of
% the maps.
pvg = num2str((100 - cfg.stats.pgroup ) / 100);
f1 = figure;
subplot(2,2,[1 2]);
h = histogram(gpermaps(end,end,:),'Normalization','probability');
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
hold on
if above, vline(double(pctval(end,end)),'r-',['Above chance threshold (p<' pvg ')']); end
if below, vline(double(pctval_(end,end)),'r-',['Below chance threshold (p<' pvg ')']); end
grid minor
title('Permuted distribution (group level)')
xlabel('Data distribution');
ylabel('Normalized histogram')


%% Search clusters in permuted maps:
% Clusters are defined using the pctval mask previously calculated.

fprintf('   - Searching clusters in permuted maps:');
if above, clustmaps = searchclusters(gpermaps,pctval,@gt); end
if below, clustmaps_ = searchclusters(gpermaps,pctval_,@lt); end
fprintf(' - Done!\n');

%% Generate cluster size distribution:
%  sizedist / sizedist_: sizes of all the clusters of all the permuted maps.
%  maxdist / maxdist_: size of the largest cluster of each permuted map.

fprintf('   - Generating cluster size distribution:');
sizedist = [];
sizedist_ = [];
maxdist = zeros(1,size(gpermaps,3));
maxdist_ = zeros(1,size(gpermaps,3));

if above, [sizedist,maxdist] = clustersizes(clustmaps); end
if below, [sizedist_,maxdist_] = clustersizes(clustmaps_); end
fprintf(' - Done!\n');

%% Plot the null distribution of cluster sizes:

if above, plotsizes(sizedist,3,'above chance'); end
if below, plotsizes(sizedist_,4,'below chance'); end

%% Search clusters in real data:
%  Clusters are detected in the group-mean performance map using the
%  primary (voxel-/timepoint-wise) threshold pctval / pctval_, exactly the
%  same threshold used for the permuted maps.

fprintf('   - Searching clusters in real data:');

thresdata  = [];
thresdata_ = [];
clusters   = struct('Connectivity',[],'ImageSize',[],'NumObjects',0,'PixelIdxList',{{}});
clusters_  = struct('Connectivity',[],'ImageSize',[],'NumObjects',0,'PixelIdxList',{{}});

if above
    thresdata  = mean(performance,3) > pctval;
    clusters   = bwconncomp(thresdata);
end
if below
    thresdata_ = mean(performance,3) < pctval_;
    clusters_  = bwconncomp(thresdata_);
end

fprintf(' - Done!\n');

%% Cluster-level p-values and correction:
%  Each observed cluster is accepted or rejected individually using the
%  method selected in cfg.stats.clustcorr (see mvpalab_clusterpvals):
%  'fdr' - Null distribution of all the cluster sizes + Benjamini-Hochberg
%          FDR (Stelzer et al., 2013).
%  'max' - Null distribution of the maximum cluster size, FWER control
%          (Maris & Oostenveld, 2007).

for field = {'sig','sizes','pvals','fdr','sig_idx','maxdist'}
    clusters.(field{1})  = [];
    clusters_.(field{1}) = [];
end

% corrcsize / corrcsize_: minimum cluster size that survives the
% correction in the above-chance / below-chance tail (Inf if none).
corrcsize  = Inf;
corrcsize_ = Inf;

if above
    [clusters,corrcsize] = mvpalab_clusterpvals(cfg,clusters,sizedist,maxdist);
end
if below
    [clusters_,corrcsize_] = mvpalab_clusterpvals(cfg,clusters_,sizedist_,maxdist_);
end

% Significant clusters mask for representation.
sigmask = ones(size(gpermaps,1),size(gpermaps,2));
sigmask(clusters.sig) = 0;

sigmask_ = ones(size(gpermaps,1),size(gpermaps,2));
sigmask_(clusters_.sig) = 0;

% Store results:
stats.thresdata = thresdata;
stats.thresdata_ = thresdata_;

stats.clusters = clusters;
stats.clusters_ = clusters_;

stats.sigmask = sigmask;
stats.sigmask_ = sigmask_;

stats.corrcsize  = corrcsize;
stats.corrcsize_ = corrcsize_;

if ~cfg.stats.shownulldis
    close(f1);
end

end

function values = percentiles(gpermaps,percentile)
%% Percentile of the null distribution at each position of the maps.

for i = 1 : size(gpermaps,1)
    for j = 1 : size(gpermaps,2)
        values(i,j) = prctile(gpermaps(i,j,:),percentile);
    end
end

end

function clustmaps = searchclusters(gpermaps,pctval,compare)
%% Clusters of each permuted map, above (@gt) or below (@lt) the threshold.

for map = 1 : size(gpermaps,3)
    clustmaps{map} = bwconncomp(compare(gpermaps(:,:,map),pctval));
end

end

function [sizedist,maxdist] = clustersizes(clustmaps)
%% Sizes of all the clusters and largest cluster of each permuted map.

sizedist = [];
maxdist = zeros(1,numel(clustmaps));

for map = 1 : numel(clustmaps)
    sizes = cellfun(@numel,clustmaps{map}.PixelIdxList);
    sizedist = [sizedist sizes]; %#ok<AGROW>
    if ~isempty(sizes), maxdist(map) = max(sizes); end
end

end

function plotsizes(sizedist,position,name)
%% Histogram of the cluster sizes of one tail.

subplot(2,2,position);
hold on
h = histogram(sizedist,'Normalization','probability','BinMethod','integers');
set(gca,'YScale','log')
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
grid minor
xlabel('Cluster size');
ylabel('Normalized histogram (log scale)')
title(['Cluster size null distribution (' name ')'])

end
