function [ stats ] = mvpalab_permtest( cfg, acc, permuted_maps )
%MVPALAB_PERMTEST Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Permutation test: </strong>\n');
%% Initilization - Generate permutation idx matrix:
% Here we determine the map of each subject that has to be selected in each
% permutation.
nSubjects = length(cfg.study.dataFiles{1,1});
cfg.stats.sub = nSubjects;
perm_idxs = randi(cfg.stats.nper,cfg.stats.sub,cfg.stats.nperg,'single');

%% Generate permuted maps at group level:
% One permuted map of each subject has to be randomly selected and group
% averaged. Here we are using the previously determined permutation
% indexes for each subject and permutation.

fprintf('   - Generating permuted maps at group level: \n');
fprintf('      # Permuted maps >> ');
for i = 1 : cfg.stats.nperg
    for j = 1 : cfg.stats.sub
        permaps(:,:,j) = squeeze(permuted_maps(:,:,j,perm_idxs(j,i)));
    end
    gpermaps(:,:,i) = mean(permaps,3);
    mvpalab_pcounter(i,cfg.stats.nperg);
end
fprintf(' - Done!\n');

%% Generate the null distribution and p-value thresholds:
% Generate the null distribution for each timepoint using the permuted
% accuracy maps. Here we can define the accuracy level associated to a
% p-value of 0.001 (99.9th percentile) for each timepoint and generate a
% thresold mask.

fprintf('   - Generating the null distribution and p-value thresholds:');
for i = 1 : size(gpermaps,1)
    for j = 1 : size(gpermaps,2)
        pctval(i,j) = prctile(gpermaps(i,j,:),cfg.stats.pgroup);
        pctval_(i,j) = prctile(gpermaps(i,j,:),100-cfg.stats.pgroup);
    end
end
fprintf(' - Done!\n');

%% Plot the null distribution of performance values:
% Plot the null distribution of performance values for a specific timepoint
% (i) and permuted map (j).

figure;
subplot(1,4,[1 2]);
h = histogram(gpermaps(i,j,:),'Normalization','probability');
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
hold on
vl = vline(double(pctval(i,j)),'r-','Accuracy threshold (p<.001)');
vl = vline(double(pctval_(i,j)),'r-','Accuracy threshold (p<.001)');
xlabel('acc');
grid minor
title('Accuracy null distribution (group level)')
xlabel('Accuracy');
ylabel('Normalized histogram')

%% Search clusters in permuted maps:
% Clusters are defined using the pctval mask previously calculated.

fprintf('   - Searching clusters in permuted maps:');
for map = 1 : size(gpermaps,3)
    thresmaps(:,:,map) = gpermaps(:,:,map) > pctval;
    thresmaps_(:,:,map) = gpermaps(:,:,map) < pctval_;
    clustmaps{map} = bwconncomp(thresmaps(:,:,map));
    clustmaps_{map} = bwconncomp(thresmaps_(:,:,map));
end
fprintf(' - Done!\n');

%% Generate cluster size distribution:
fprintf('   - Generating cluster size distribution:');
sizedist = [];
sizedist_ = [];

for map = 1 : size(gpermaps,3)
    for i = 1 : clustmaps{map}.NumObjects
        sizedist(end+1) = numel(clustmaps{map}.PixelIdxList{i});
    end
    for i = 1 : clustmaps_{map}.NumObjects
        sizedist_(end+1) = numel(clustmaps_{map}.PixelIdxList{i});
    end
end
fprintf(' - Done!\n');

%% Plot the null distribution of cluster sizes:

% Cluster size distribution - above chance level.
subplot(1,4,3);
hold on
h = histogram(...
    sizedist,'Normalization','probability','BinMethod','integers');
hnorm = h.BinCounts/sum(h.BinCounts)';

set(gca, 'YScale', 'log')
h.FaceColor = [.5 .5 .5];
h.EdgeColor = [.5 .5 .5];
grid minor
xlabel('Cluster size');
ylabel('Normalized histogram (log scale)')
title('Cluster size null distribution (above chance)')

% Cluster size distribution - below chance level.
subplot(1,4,4);
hold on
h_ = histogram(...
    sizedist_,'Normalization','probability','BinMethod','integers');
hnorm_ = h_.BinCounts/sum(h_.BinCounts)';
set(gca, 'YScale', 'log')
h_.FaceColor = [.5 .5 .5];
h_.EdgeColor = [.5 .5 .5];
grid minor
xlabel('Cluster size');
ylabel('Normalized histogram (log scale)')
title('Cluster size null distribution (below chance)')

%% Uncorrected cluster size threshold:
% stats.uncorrcsize = prctile(sizedist,cfg.stats.pclust);
% stats.uncorrcsize_ = prctile(sizedist_,cfg.stats.pclust);

%% False Discovery Rate (FDR) correction at cluster level:
pval = (100 - cfg.stats.pclust) / 100;

fdr = mafdr(hnorm,'bhfdr','true');
fdr_ = mafdr(hnorm_,'bhfdr','true');

stats.corrcsize = find((fdr < pval) & (fdr ~= 0),1);
stats.corrcsize_ = find((fdr_ < pval) & (fdr_ ~= 0),1);

if isempty(stats.corrcsize); stats.corrcsize = length(fdr); end
if isempty(stats.corrcsize_); stats.corrcsize_ = length(fdr_); end

subplot(1,4,3);
vl = vline(stats.corrcsize,'r-','Cluster size threshold (p<.001)');
subplot(1,4,4);
vl = vline(stats.corrcsize_,'r-','Cluster size threshold (p<.001)');

%% Search clusters in real data:
fprintf('   - Searching clusters in real data:');

% Thresholded performance map - above chance level:
stats.thresdata = mean(acc,3) > pctval;
stats.thresdata_ = mean(acc,3) < pctval_;

stats.clusters = bwconncomp(stats.thresdata);
stats.clusters_ = bwconncomp(stats.thresdata_);

stats.clusters.sig = [];
stats.clusters_.sig = [];

% Significant clusters - above chance level.
for i = 1 : stats.clusters.NumObjects
    if numel(stats.clusters.PixelIdxList{i}) > stats.corrcsize
        stats.clusters.sig = [stats.clusters.sig;...
            stats.clusters.PixelIdxList{i}];
    end
end

% Significant clusters - below chance level.
for i = 1 : stats.clusters_.NumObjects
    if numel(stats.clusters_.PixelIdxList{i}) > stats.corrcsize_
        stats.clusters_.sig = [stats.clusters_.sig;...
            stats.clusters_.PixelIdxList{i}];
    end
end

% Significant clusters mask for representation.
stats.sigmask = ones(size(gpermaps,1),size(gpermaps,2));
stats.sigmask(stats.clusters.sig) = 0;

stats.sigmask_ = ones(size(gpermaps,1),size(gpermaps,2));
stats.sigmask_(stats.clusters_.sig) = 0;

fprintf(' - Done!\n');
fprintf('<strong> > Stelzer permutation test finished!</strong>\n');
end

