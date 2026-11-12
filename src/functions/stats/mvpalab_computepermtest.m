function stats = mvpalab_computepermtest(cfg,performance,nullmaps,pairing)
%% MVPALAB_COMPUTEPERMTEST
%
%  This function computes the cluster-based permutation test of one
%  performance map at group level (Stelzer et al., 2013):
%
%  - It builds the permuted maps at group level as set in pairing:
%    - 'random' (default): cfg.stats.nperg maps, each one the mean of one
%      permuted map of each subject selected at random (Stelzer et al.,
%      2013). The permuted maps of each subject are independent of those
%      of the other subjects.
%    - 'shared': one map per permutation, the mean of the permuted map k
%      of all the subjects, because map k of every subject was computed
%      with the same permutation (the shared permutation of the conditions
%      of the M/EEG-fMRI fusion, see mvpalab_fusion). cfg.stats.nperg is
%      not used. The null distribution then includes everything the
%      subjects share, such as the noise of an averaged RDM, which a random
%      combination of independent permutations leaves out.
%    They are computed in blocks, first of positions of the maps for the
%    thresholds and then of permuted maps for the clusters, so the memory
%    does not grow with the number of maps.
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
%  or 2 (both). The function stops with an error if the settings of the
%  test are not valid (see mvpalab_validatestats and
%  mvpalab_validatesignflip), or if the null maps do not have the positions
%  and subjects of the result. With cfg.stats.shownulldis it opens a figure
%  with the null distribution at the last position of the maps and the null
%  distribution of the cluster sizes used by the correction (all the
%  clusters with 'fdr', the largest cluster of each permuted map with
%  'max'). It does not save any file.
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
%  - {matrix} - nullmaps:
%    Maps of the null distribution of each subject [ntp x ntp_ x subjects x
%    maps]: its permuted maps or, with cfg.stats.signflip, its result and
%    its reflection around chance (see mvpalab_decodingnullmaps). With
%    pairing = 'shared', map k of every subject uses the same permutation.
%
%  - {string} - pairing (optional):
%    'random' (default) or 'shared', see above.
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

if nargin < 4, pairing = 'random'; end
if ~any(strcmp(pairing,{'random','shared'}))
    error('mvpalab:computepermtest',...
        'The pairing of the permuted maps must be ''random'' or ''shared''.');
end

mvpalab_validatestats(cfg);
mvpalab_validatesignflip(cfg);

% Tails of the test:
above = cfg.stats.tails ~= -1;
below = cfg.stats.tails ~= 1;

%% Null maps at group level:
%  Each one is the mean of one map of each subject: chosen at random
%  ('random') or the map with the same permutation ('shared'). The maps of
%  the subjects are the columns of pages, and page(:,i) are the columns of
%  the null map i.

[n1,n2,nsub,nmaps] = size(nullmaps);
if ~isequal(size(performance,1:3),[n1 n2 nsub])
    error('mvpalab:computepermtest',...
        ['The null maps [%s] do not match the result [%s]: they come ' ...
        'from another analysis.'],num2str([n1 n2 nsub]),num2str(size(performance,1:3)));
end

fprintf('   - Generating permuted maps at group level: ');
if strcmp(pairing,'shared')
    nperg = nmaps;
    idx = repmat(1:nmaps,nsub,1);
else
    nperg = cfg.stats.nperg;
    idx = randi(nmaps,nsub,nperg,'single');
end
pages = reshape(nullmaps,n1*n2,nsub*nmaps);
page = (1:nsub)' + nsub*(double(idx) - 1);
fprintf(' - Done!\n');

%% Primary threshold at each position of the maps:
%  The percentile cfg.stats.pgroup of the null distribution, split between
%  the two tails with cfg.stats.tails = 2.

threshold = cfg.stats.pgroup;
if cfg.stats.tails == 2
    threshold = cfg.stats.pgroup + (100 - cfg.stats.pgroup)/2;
end

fprintf('   - Generating the null distribution and p-value thresholds:');
pctval = zeros(n1,n2,'like',nullmaps);
pctval_ = pctval;
for block = blocks(n1*n2,nsub*nperg)
    positions = block{1};
    gnull = groupnull(pages,page,positions,1:nperg);
    if above, pctval(positions) = prctile(gnull,threshold,2); end
    if below, pctval_(positions) = prctile(gnull,100 - threshold,2); end
end
lastnull = gnull(end,:);
fprintf(' - Done!\n');

%% Null distributions of the cluster sizes:
%  sizedist: sizes of all the clusters of all the null maps ('fdr').
%  maxdist: size of the largest cluster of each null map ('max').

sizedist = []; maxdist = zeros(1,nperg);
sizedist_ = []; maxdist_ = zeros(1,nperg);

fprintf('   - Searching clusters in permuted maps:');
found = {}; found_ = {};
for block = blocks(nperg,n1*n2*nsub)
    maps = block{1};
    gnull = reshape(groupnull(pages,page,1:n1*n2,maps),n1,n2,numel(maps));
    if above, found{end+1} = nullclusters(gnull > pctval,maps); end %#ok<AGROW>
    if below, found_{end+1} = nullclusters(gnull < pctval_,maps); end %#ok<AGROW>
end
fprintf(' - Done!\n');

fprintf('   - Generating cluster size distribution:');
if above, [sizedist,maxdist] = clustersizes(found,nperg); end
if below, [sizedist_,maxdist_] = clustersizes(found_,nperg); end
fprintf(' - Done!\n');

%% Clusters of the group mean of the real maps:
%  With the same primary threshold as the null maps.

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

%% Cluster-level p-values and correction (see mvpalab_clusterpvals):
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
sigmask = ones(n1,n2);
sigmask(clusters.sig) = 0;

sigmask_ = ones(n1,n2);
sigmask_(clusters_.sig) = 0;

%% Store results:
stats.thresdata = thresdata;
stats.thresdata_ = thresdata_;

stats.clusters = clusters;
stats.clusters_ = clusters_;

stats.sigmask = sigmask;
stats.sigmask_ = sigmask_;

stats.corrcsize  = corrcsize;
stats.corrcsize_ = corrcsize_;

%% Null distributions, if requested:
if cfg.stats.shownulldis
    figure;
    % Level of each tail: split between the two tails with tails = 2.
    pvg = num2str((100 - threshold)/100);
    subplot(2,2,[1 2]);
    plotnull(lastnull);
    if above, vline(double(pctval(end,end)),'r-',['Above chance threshold (p<' pvg ')']); end
    if below, vline(double(pctval_(end,end)),'r-',['Below chance threshold (p<' pvg ')']); end

    if strcmp(cfg.stats.clustcorr,'max')
        if above, plotsizes(maxdist,3,'Maximum cluster size','above chance'); end
        if below, plotsizes(maxdist_,4,'Maximum cluster size','below chance'); end
    else
        if above, plotsizes(sizedist,3,'Cluster size','above chance'); end
        if below, plotsizes(sizedist_,4,'Cluster size','below chance'); end
    end
end

end

function list = blocks(n,each)
%% Blocks of 1:n, with about 2.5e7/each elements in each block, where each
%  element needs each values, so a block of null maps takes about 200 MB.

step = max(1,floor(2.5e7/each));
list = arrayfun(@(first) first : min(first + step - 1,n),1 : step : n,...
    'UniformOutput',false);

end

function gnull = groupnull(pages,page,positions,maps)
%% Null maps at group level [positions x maps]: the mean of the maps of
%  the subjects in page(:,maps), at the given positions.

nsub = size(page,1);
selected = pages(positions,page(:,maps));
selected = reshape(selected,numel(positions),1,nsub,numel(maps));
gnull = reshape(mean(selected,3),numel(positions),numel(maps));

end

function found = nullclusters(mask,maps)
%% Size of each cluster of the null maps [n1 x n2 x maps] and the null map
%  it belongs to (one of maps), in the order of the maps.

[n1,n2,nmaps] = size(mask);

if n1 == 1
    % Time-resolved maps: the clusters are runs of consecutive timepoints,
    % as bwconncomp finds them in a single row.
    edges = diff([false(1,nmaps); reshape(mask,n2,nmaps); false(1,nmaps)]);
    starts = find(edges == 1);
    found.sizes = (find(edges == -1) - starts)';
    found.map = maps(ceil(starts'/(n2 + 1)));
    return
end

perm = cell(1,nmaps);
for m = 1 : nmaps
    cc = bwconncomp(mask(:,:,m));
    perm{m} = cellfun(@numel,cc.PixelIdxList);
end
found.map = repelem(maps,cellfun(@numel,perm));
found.sizes = [perm{:}];

end

function [sizedist,maxdist] = clustersizes(found,nmaps)
%% Sizes of all the clusters and largest cluster of each null map.

found = [found{:}];
sizedist = [found.sizes];
map = [found.map];
maxdist = accumarray(map(:),sizedist(:),[nmaps 1],@max,0)';

end

function plotnull(values)
%% Histogram of the null distribution at one position of the maps.

h = histogram(values,'Normalization','probability');
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
hold on
grid minor
title('Null distribution (group level)')
xlabel('Data distribution');
ylabel('Normalized histogram')

end

function plotsizes(sizes,position,what,tail)
%% Histogram of the null distribution of the cluster sizes of one tail.

subplot(2,2,position);
hold on
h = histogram(sizes,'Normalization','probability','BinMethod','integers');
set(gca,'YScale','log')
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
grid minor
xlabel(what);
ylabel('Normalized histogram (log scale)')
title([what ' null distribution (' tail ')'])

end
